.section .data
    brk_atual: .quad 0
    brk_original: .quad 0

    hashtag .byte '#'
    ponto .byte '.' 
    mais .byte '+'

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
# rdi = n
ajusta_brk:
    pushq %rbp
    movq %rsp, %rbp

        movq %rdi, %rdx 
        call ret_brk_atual           # Obter o valor atual do brk em %rax
        addq %rdx, %rax              # Soma o deslocamento ao valor atual do brk
    
    
        movq %rax, %rdi          # Prepara o novo valor para ajustar o brk
        movq $12, %rax           # Syscall 'brk'
        syscall                  # Ajusta o brk

        lea brk_atual(%rip), %r15 # endereço de brk atual em rbx
        movq %rax, (%r15)         # novo valor do brk em brk_atual

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
    movq $16, %rdi
    call ajusta_brk

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
# bytes =%rdi 

alocaMem:
    pushq %rbp
    movq %rsp, %rbp
    movq brk_original, %rcx
    cmpq $0,8(%rcx)
    je lista_vazia
    # --- lista não vazia, procura bloco ------
    
    call bestFit        # rax = retorno do bestFit
    cmpq $0, %rax        # rax = 0 não achou bloco, cria outro no fim
    je if_bestFit_0
    # --- achou um bloco ----
    movq $1,0(%rax)     # seta status
    movq 8(%rax), %rdx  # rbx = tam
    movq %rdi, 8(%rax)  # seta tam (rdi = bytes)

    # ---verifica se sobrou espaço no bloco -----
    subq %rdi,%rbx          # rbx = tam - bytes
    cmpq $0, %rbx
    je sem_mem_restante
    subq $8,%rsp
    movq %rax, -8(%rbp)     # endereço do bloco escolhido
    addq $16,%rax            # soma o header
    movq -8(%rbp), %r13
    addq 8(%r13), %rax      # soma o tamanho
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
        call alocaNovoBloco
        movq -8(%rsp),%rdi

    fim_aloca_mem:
        popq %rbp
        ret

    lista_vazia:
        # parametro bytes em %rdi
        call calculaTam      
        movq %rax,%r13         # r13 = tam
        movq %rdi,%rbx       # rbx = bytes
        movq %rax,%rdi 
        call ajusta_brk      # seta o brk para tam

        movq brk_original, %rcx
        movq $1,(%rcx)  # seta status
        movq %rbx,8(%rcx) # seta tamamnho
        
        # verifica se sobrou espaco

        subq %rbx, %r13  # rax = tam - bytes
        cmpq $0, %r13
        je semMemR
        movq brk_original,%rbx
        add $16,%rbx
        addq 8(%rcx), %rbx
        movq $0,(%rbx)
        subq $16, %r13      # tam restante - header
        movq %r13,8(%rbx)
        semMemR:
            movq %rcx, %rax     # rax = end
            addq $16, %rax          # rax = end de dados
            jmp fim_aloca_mem


# alocaNovoBloco(bytes) aloca novo bloco ao fim do bloco alocado
alocaNovoBloco:
    movq brk_atual,%r12     # rbx = inicio do bloco a ser alocado

    call calculaTam
    sub $16,%rsp
    movq %rdi,-8(%rbp)         # bytes
    movq %rax,-16(%rbp)      # tam
   
    
    movq $16,%rdi           # tamanho do header
    addq -16(%rbp),%rdi
    call ajusta_brk     

    movq $1,0(%r12)     # seta status
    movq -8(%rbp),%r11
    movq %r11,8(%r12)    # seta tam
    
    # --- verifica se sobrou memoria no bloco ------
    movq -16(%rbp), %rbx  # rbx = tam
    subq -8(%rbp), %rbx  # rbx = tam - bytes
    cmpq $0, %rbx
    je semMemRestante
    movq %rbx,%r14
    subq $16, %r14      # tamanho que sobrou
    cmp $17,%r14        # se nao tiver espaço para o header +1
    jl semMemParaHeader

    movq %r12,%rax
    addq $16,%rax
    addq 8(%r12),%rax
    movq $0,0(%rax)         # seta status
    subq $16, %rbx          # header tam restantes - header
    movq %rbx,8(%rax)       # seta o tamamnho
    jmp semMemRestante
semMemParaHeader:
    addq %rbx,8(%r12)        #  adiciona o espaço a mais no bloco alocado   
semMemRestante:
    movq %r12, %rax     # rax = end
    addq $16, %rax          # rax = end de dados
    
    addq $16, %rsp  # limpa pilha
    addq $8, %rsp   # TODO descobrir da onde vem esses 8 a mais
    popq %rbp
    ret

# bestFit(tam) 
# tam = %rdi
bestFit:
    pushq %rbp
    movq %rsp, %rbp

    sub $16,%rsp                 # aloca espaço para 2 long int
    movq brk_original, %rcx
    movq %rcx, -8(%rbp)            # tmp = inicio - tmp = -8(%rbp)
    movq $0, -16(%rbp)           # bestFit = -16(%rbp)  0 == NULL
    movq brk_atual, %r12
    # --- percorre os blocos -----
    while:
        cmpq %r12,-8(%rbp)            # se endereço do tmp >= brk sai do while
        jge fim_while
        movq -8(%rbp), %rax           # rax = tmp
        cmpq $0, 0(%rax)              # Compara tmp.status com 0
        jne fim_cond
        movq -8(%rbp), %rbx
        movq 8(%rbx), %rbx            # rbx = nodo.tam
        cmpq %rdi,%rbx
        jl fim_cond
        cmpq $0, -16(%rbp)            # se bestFit == 0, é o primeiro bloco com espaço, logo bestFit = bloco
        je true
        movq -16(%rbp), %rbx          # -16(rbp) = bestfit atual
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
        add $16,%rsp
        popq %rbp
        ret

# bytes = %rdi
calculaTam:
    pushq %rbp
    movq %rsp, %rbp

    movq $4096, %r11
    cmpq %r11,%rdi
    jg else # if(bytes > 4096) jump else
    movq $4096,%rax # tam = 4096
    popq %rbp
    ret
    else: # Calcula multiplo de 4096
        movq %rdi, %rax    # rax = bytes
        addq $4096, %rax       # Soma 4096
        subq $1, %rax          # Subtrai 1
        xorq %rdx, %rdx        # Limpa %rdx para evitar erros no divq
        movq $4096, %rbx       # Divisor
        divq %rbx              # Divide %rax por 4096 (resultado em %rax)
        imulq $4096, %rax      # Multiplica o quociente por 4096
        
        popq %rbp
        ret                    # retorna tam calculado em %rax

imprimeMapa: 
    pushq %rbp 
    movq %rsp, %rbp   

    #aloca espaço na pilha para o endereço de bloco 
    sub $8,%rsp

    #armazena o endereço de brk_original em %rcx
    movq brk_original, %rcx
    #armazena %rcx na pilha
    movq %rcx, -8(%rbp)  

    #armazena o endereço do brk_atual em %r12
    movq brk_atual, %r12          

    while_inicio: 
        #comparação while
        cmpq %r12,-8(%rbp) 
        jge while_fim

            #instruções while
            movq $0, %r13 # %r13: contador = 0
            
            #calcula tamanho no nodo 
            movq 8(%rcx), %r11
            addq $16, %r11

            for1_inicio: 
                #comparação for 1
                cmpq %r13, %r11 #se %r13 > %r11
                jg for1_fim
            
                #instrucoes for1 

                #print #
                li $v0, 4 #instrução de impressao
                la $a0, hashtag 
                syscall

                #incrementa contador for
                addq $1, %r13 

            for1_fim
            movq $0, %r13 # %r13: contador = 0

            #calcula o tamanho armazenado
            subq $16, %r11

            for2_inicio: 
            
            #comparação for 2
            
            cmpq %r13, 8(%rcx) #se %r13 < 8(%rcx)
            jg for2_fim

            #instrucoes for2 
                
                movq %r14, %rcx # %r14: status 
                cmp %rcx, $0 #compara com 0 
                jmp else

                #imprime . 
                li $v0, 4 #instrução de impressao
                la $a0, ponto 
                syscall

                jmp fim_if 

                else: 

                #imprime +
                li $v0, 4 #instrução de impressao
                la $a0, mais 
                syscall
                
                fim_if:
            
            #incrementa contador for
            addq $1, %r13 

            for1_fim:



        jmp while_inicio
    

    popq %rbp 
    ret 