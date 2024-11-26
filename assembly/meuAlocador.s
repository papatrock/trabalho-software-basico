.section .data
    brk_atual: .quad 0
    brk_original: .quad 0

.section .text
    
.globl ret_brk_atual,ajusta_brk,iniciaAlocador,alocaMem


# Retorna o valor do brk atual em rax
ret_brk_atual:                            
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax
    movq $0, %rdi                   
    syscall

    popq %rbp
    ret

# sbrk(n)
ajusta_brk:
    pushq %rbp
    movq %rsp, %rbp

    movq 16(%rbp), %rdx 
    call ret_brk_atual           # Obter o valor atual do break em %rax
    addq %rdx, %rax              # Soma o deslocamento ao valor atual do break
    
    
    movq %rax, %rdi          # Prepara o novo valor para ajustar o break
    movq $12, %rax           # Syscall 'brk'
    syscall                  # Ajusta o break

    lea brk_atual(%rip), %rbx # endereço de brk)atual em rbx
    movq %rax, (%rbx)         # novo valor do brk em brk_atual

    popq %rbp
    ret
    
iniciaAlocador: 
pushq %rbp 
movq %rsp, %rbp 

     # salvar endereço inicial da heap em brk_original
    call ret_brk_atual
    lea brk_original(%rip), %rcx # rcx = end. brk_original (var)
    movq %rax, (%rcx)            # rcx = brk_original (val)

    # alocar espaço para o header
    movq $16, %rax
    pushq %rax
    call ajusta_brk
    subq $8, %rsp

    # configurar nodo no novo espaço alocado
    lea brk_original(%rip), %rbx    # rbx = endereço de brk_original
    movq (%rbx), %rcx               # rcx = brk_original (valor atual da heap, início do header)
    movq $0, (%rcx)                 # status = 0
    movq $0, 8(%rcx)                # tamanho = 0

    # Atualizar brk_atual para o final do header
    addq $16, %rcx                  # brk_atual = brk_original + tamanho do header
    lea brk_atual(%rip), %rbx       # rbx = endereço de brk_atual
    movq %rcx, (%rbx)               # atualiza brk_atual com o novo valor

popq %rbp
ret


# alocaMem(int bytes)
# bytes =16(%rbp) --> parametro passado por valor

alocaMem:
    pushq %rbp
    movq %rsp, %rbp
    lea brk_original(%rip), %rcx
    cmpq $0,8(%rcx)
    je lista_vazia
    # --- lista não vazia, procura bloco ------
    pushq 16(%rbp)
    call bestFit        # rax = retorno do bestFit
    addq $8, %rsp
    cmpq $0, %rax        # rax = 0 não achou bloco, cria outro no fim
    je if_bestFit_0
    # --- achou um bloco ----
    movq $1,0(%rax)     # seta status
    movq 8(%rax), %rbx  # rbx = tam
    movq 16(%rbp),%r11
    movq %r11, 8(%rax) # seta tam

    # ---verifica se sobrou espaço no bloco -----
    subq 16(%rbp),%rbx  # rbx = tam - bytes
    cmpq $0, %rbx
    je sem_mem_restante
    subq $8,%rsp
    movq %rax, -8(%rbp)  # endereço do bloco escolhido
    add $16,%rax            # soma o header
    add 16(%rbp), %rax      # soma o tamanho
    movq $0, 0(%rax)        # seta status
    subq $16, %rbx          # tam = tam - header
    movq %rbx, 8(%rax)      # seta o tamanho
    movq -8(%rbp), %rax
    addq $8, %rsp           # retorna mem
    jmp fim_aloca_mem
    sem_mem_restante:
        addq $16, %rax          # rax = end de dados
        jmp fim_aloca_mem

    if_bestFit_0:
        movq brk_atual, %rcx
        pushq %rcx
        pushq 16(%rbp)
        call alocaNovoBloco
        subq $16, %rsp
    fim_aloca_mem:
        popq %rbp
        ret

# alocaNovoBloco(bytes) aloca novo bloco ao fim do bloco alocado
alocaNovoBloco:
    lea brk_atual(%rip), %rax  # Carrega o endereço de brk_atual em %rax
    movq %rax, -8(%rsp)        # Move o endereço de brk_atual para a pilha

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
    movq 16(%rbp),%r11
    movq %r11,8(%rbx)    # seta tam
    
    # --- verifica se sobrou memoria no bloco ------
    movq -16(%rbp), %rbx  # rbx = tam
    subq 8(%rbp), %rbx  # rbx = tam - bytes
    cmpq $0, %rbx
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

    movq 16(%rbp), %rbx           # rbx = tam
    sub $16,%rsp                 # aloca espaço para 2 long int
    lea brk_original(%rip), %rcx
    movq %rcx, -8(%rbp) # tmp = inicio - tmp = -8(%rbp)
    movq $0, -16(%rbp)           # bestFit = -16(%rbp)  0 == NULL
    lea brk_atual(%rip), %r12
    # --- percorre os blocos -----
    while:
        cmpq %r12,-8(%rbp)     # se endereço do tmp >= brk sai do while
        jge fim_while
        movq -8(%rbp), %rax           # rax = tmp.status
        cmpq $0, 0(%rax)          # Compara tmp.status com 0
        jne fim_cond
        movq -8(%rbp), %rbx
        movq 8(%rbx), %rbx          # rbx = nodo.tam
        cmpq 16(%rbp),%rbx
        jl fim_cond
        cmpq $0, -16(%rbp)           # se bestFit == 0, é o primeiro bloco com espaço, logo bestFit = bloco
        je true
        movq -16(%rbp), %rbx        # rbx = bestFit atual
        movq 8(%rbx),%r13
        cmpq  %r13,8(%rax)
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
        call calculaTam      #  rax = tam
        popq %rbx       # rbx = bytes
        pushq %rax 
        call ajusta_brk      # seta o brk para tbm
        popq %rax

        lea brk_original(%rip), %rcx
        movq $1,(%rcx)  # seta status
        movq %rbx,8(%rcx) # seta tamamnho
        
        # verifica se sobrou espaco

        subq %rbx, %rax  # rax = tam - bytes
        cmpq $0, %rax
        je semMemR
        movq %rcx,%rbx
        add $16,%rbx
        addq 8(%rcx), %rbx
        movq $0,(%rbx)
        subq $16, %rax      # tam restante - header
        movq %rax,8(%rbx)
        semMemR:
            movq %rcx, %rax     # rax = end
            addq $16, %rax          # rax = end de dados
            ret

calculaTam:
    pushq %rbp
    movq %rsp, %rbp

    cmpq $4096,16(%rbp)
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
