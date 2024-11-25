.section .data

.section .bss
    .global brk_original
    .global brk_atual

.section .text
    
.globl  _start

# Retorna o valor do brk atual em rax
brk_atual:                            
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax
    movq $0, %rdi                   
    syscall

    popq %rbp
    ret

ajusta_brk:
    pushq %rbp
    movq %rsp, %rbp

    call brk_atual           # Obter o valor atual do break em %rax
    addq 16(%rbp), %rax      # Soma o deslocamento ao valor atual do break
    movq %rax, %rdi          # Prepara o novo valor para ajustar o break
    movq $12, %rax           # Syscall 'brk'
    syscall                  # Ajusta o break
    addq 16(%rbp),$brk_atual # ajusta var global TODO talvez chamar brk_atual pra garantir?

    popq %rbp
    ret
    
iniciaAlocador: 
pushq %rbp 
movq %rsp, %rbp 

    #salvar endereço inicial da heap em brk_original
    movq $0, %rdi
    movq %rax, 12
    syscall
    lea brk_original(%rip), %rcx        #pega o endereço na memória de brk_original e salva em %rcx
    movq %rax, (%rcx)       #armazena o valor de %rax no endereço de memória de brk_original

    #alocar espaço para o nodo 
    movq $0, %rdi
    movq %rax, 12
    syscall
    movq [bloco], %rax  #salva o endereço do bloco 

    #configurar nodo 
    movq $0, %rdi
    movq %rax, 12
    syscall
    movq %rbx, [bloco]      #carrega o endereço do bloco
    movq (%rbx), %ax        #carrega o endereço do topo da heap em bloco->endereço

    #aloca status 
    movq (%rbx)+8, $0

    #aloca tamanho
    movq (%rbx)+16, $0

    #aloca próximo bloco 
    movq %rcx, (%rbx)+16 #%rcx recebe o tamanho
    addq %rcx, (%rbx)+16 #soma o tamanho ao endereço de memória 
    movq (%rcx), $0 #endereço de memória do inicio do próximo bloco     

popq %rbp
ret


# alocaMem(int bytes)
# bytes =16(%rbp) --> parametro passado por valor

alocamMem:
    pushq %rbp
    movq %rsp, %rbp

    cmp $0, 8($brk_original)
    je lista_vazia
    # --- lista não vazia, procura bloco ------
    pushq 16(%rbp)
    call bestFit        # rax = retorno do bestFit
    addq $8, %rsp
    cmp $0, %rax        # rax = 0 não achou bloco, cria outro no fim
    je if_bestFit_0
    # --- achou um bloco ----
    movq $1,0(%rax)     # seta status
    movq 8(%rax), %rbx  # rbx = tam
    movq 16(%rbp), 8(%rax) # seta tam

    # ---verifica se sobrou espaço no bloco -----
    subq 16(%rbp),%rbx  # rbx = tam - bytes
    cmp $0, %rbx
    je semMemRestante
    subq $8,%rsp
    movq %rax, -8(%rbp)  # endereço do bloco escolhido
    add $16,%rax            # soma o header
    add 16(%rbp), %rax      # soma o tamanho
    movq $0, 0(%rax)        # seta status
    subq $16, %rbx          # tam = tam - header
    movq %rbx, 8(%rax)      # seta o tamanho
    movq -8(%rbp), %rax
    addq $8, %rsp           # retorna mem
    semMemRestante:
        addq $16, %rax          # rax = end de dados

        popq %rbp
        ret

    if_bestFit_0:
        pushq $brk_atual
        pushq 16(%rbp)
        call alocaNovoBloco
        subq $16, %rsp
        popq %rbp
        ret


# alocaNovoBloco(bytes) aloca novo bloco ao fim do bloco alocado
alocaNovoBloco:
    subq $8, %rsp       # espaco para end
    movq $brk_atual, -8(%rsp) # end
    movq $16,%rax
    pushq %rax
    call ajusta_brk     # sbrk(16)
    addq $8, %rsp
    
    pushq 16(%rbp)      # empilha bytes
    call calculaTam
    
    subq $8, %rsp       # espaco para tam
    movq %rax, -16(%rbp)  # tam = multiplo de 4096

    pushq -16(%rbp)
    call ajusta_brk     # sbrk(tam)
    addq $8, %rsp

    movq -8(%rbp), %rbx 
    movq $1,0(%rbx)     # seta status
    movq 16(%rbp),8(%rbx)    # seta tam
    
    # --- verifica se sobrou memoria no bloco ------
    movq -16(%rbp), %rbx  # rbx = tam
    subq 8(%rbp), %rbx  # rbx = tam - bytes
    cmp $0, %rbx
    je semMemRestante

    movq -8(%rbp), %rax
    add $16, %rax  
    add 8(%rbp), %rax      # rax = end da mem restante
    movq $0,0(%rax)         # seta status
    subq $16, %rbx          # header tam restantes - header
    movq %rbx,8(%rax)       # seta o tamamnho
semMemRestante:
    movq -8(%rbp), %rax     # rax = end
    addq $16, %rax          # rax = end de dados

    # limpa pilha
    addq $16, %rsp

    popq %rbp
    ret

# bestFit(tam) 
# tam = 16(%rbp)
bestFit:
    pushq %rbp
    movq %rsp, %rbp

    movq 16(%rbp), rbx           # rbx = tam
    sub $16,%rsp                 # aloca espaço para 2 long int
    movq $brk_original, -8(%rbp) # tmp = inicio - tmp = -8(%rbp)
    movq $0, -16(%rbp)           # bestFit = -16(%rbp)  0 == NULL

    # --- percorre os blocos -----
    while:
        cmp $brk_atual,-8(%rbp)     # se endereço do tmp >= brk sai do while
        jge fim_while
        movq -8(%rbp), %rax           # rax = tmp.status
        cmpq $0, 0(%rax)          # Compara tmp.status com 0
        jne fim_cond
        movq -8(%rbp), %rbx
        movq 8(%rbx), %rbx          # rbx = nodo.tam
        cmp 16(rbp),%rbx
        jl fim_cond
        cmp $0, -16(%rbp)           # se bestFit == 0, é o primeiro bloco com espaço, logo bestFit = bloco
        je true
        movq -16(%rbp), %rbx        # rbx = bestFit atual
        cmp  8(%rbx),8(%rax)
        jl true
        jmp fim_cond
        true:
            movq %rax,-16(%rbp)

        fim_cond:
            movq -8(%rbp), %rbx
            movq 8(%rbx), %rbx      # rbx = tmp.tam
            addq $16,-8(%rbp)       # tmp = tmp + header
            addq %rbx,-8(%rbp)      # tmp = tmp + tmpAnterior.tam
        jmp while
        
    fim_while:
        movq -16(%rbp), %rax        # rax = bestFit
        popq %rbp
        ret



lista_vazia:
        pushq 16(%rbp)  # bytes
        calculaTam      #  rax = tam
        popq %rbx       # rbx = bytes
        pushq %rax 
        ajusta_brk      # seta o brk para tbm
        popq %rax

        movq $1,0($brk_original)  # seta status
        movq %rbx,8($brk_original) # seta tamamnho
        
        # verifica se sobrou espaco

        subq %rbx, %rax  # rax = tam - bytes
        cmp $0, %rax
        je semMemR
        movq $brk_original,%rbx
        add $16,%rbx
        addq 8($brk_original), %rbx
        movq $0,(%rbx)
        subq $16, %rax      # tam restante - header
        movq %rax,8(%rbx)
        semMemR:
            movq $brk_original, %rax     # rax = end
            addq $16, %rax          # rax = end de dados
            ret

calculaTam:
    pushq %rbp
    movq %rsp, %rbp

    cmp $4096,16(%rbp)
    jg else # if(bytes > 4096) jump else
    movq $4096,%rax # tam = 4096
    popq %rbp
    ret
    else: # Calcula multiplo de 4096
        movq 16(%rbp), %rax    # rax = bytes
        addq $4096, %rax       # Soma 4096
        subq $1, %rax          # Subtrai 1
        xorq %rdx, %rdx        # Limpa %rdx para evitar erros no divq
        movq $4096, %rbx       # Divisor
        divq %rbx              # Divide %rax por 4096 (resultado em %rax)
        imulq $4096, %rax      # Multiplica o quociente por 4096
        
        popq %rbp
        ret                    # retorna tam calculado em %rax
