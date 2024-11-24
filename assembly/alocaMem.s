# alocaMem(int bytes)
# bytes =16(%rbp) --> parametro passado por valor

alocamMem:
    pushq %rbp
    movq %rsp, %rbp

    movq $0, %rax
    movq 8($brk_original), %rbx # Se tamanho do primeiro bloco = 0 -> lista vazia
    cmp $0, 8($brk_original)
    je lista_vazia
    # --- lista não vazia, procura bloco ------
    pushq 16(%rbp)
    call bestFit        # rax = retorno do bestFit
    cmp $0, %rax        # rax = 0 não achou bloco, cria outro no fim
    je if_bestFit_0
    # --- acho um bloco ----
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


# alocaNovoBloco(end, tam)
alocaNovoBloco:
    movq $16,%rax
    pushq %rax
    call ajusta_brk     # sbrk(16)
    popq %rbp
    call brk_atual
    subq $8, %rsp      # tam
    pushq 16(%rbp)      # empilha bytes
    call calculaTam
    popq %rbp
    movq %rax, -8(%rbp)  # tam = multiplo de 4096

    pushq -8(%rbp)
    call ajusta_brk     # sbrk(tam)
    popq %rbp
    
    movq 16(%rbp), %rbx
    movq $1,0(%rbx)     # seta status
    movq -8(%rbp),8(%rbx)    # seta tam
    # --- verifica se sobrou memoria no bloco ------
    subq 8(%rbp), %rbx  # rbx = tam - bytes
    cmp $0, %rbx
    je semMemRestante
    movq 16(%rbp), %rax
    add $16, %rax  
    add -8(%rbp), %rax      # rax = end da mem restante
    movq $0,0(%rax)         # seta status
    movq %rbx,8(%rax)       # seta o tamamnho
semMemRestante:
    movq 16(%rbp), %rax     # rax = end
    addq $16, %rax          # rax = end de dados

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
        cmp $0, -16(%rbp)           # se bestFit == 0, é o primeiro bloco com espaço, logo bestFit = bloco
        je true
        movq -16(%rbp), %rbx        # rbx = bestFit atual
        cmp  8(%rbx),8(%rax)
        jg true
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
        pushq $brk_original
        pushq 16(%rbp)
        call alocaNovoBloco # rax = end do novo bloco
        popq %rbp
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
