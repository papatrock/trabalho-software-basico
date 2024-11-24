# alocaMem(int bytes)
# bytes =16(%rbp) --> parametro passado por valor

alocamMem:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    movq 8($brk_original), %rbx # Se tamanho do primeiro bloco = 0 -> lista vazia
    cmp %rbx, %rax
    je lista_vazia
    # --- lista não vazia, procura bloco ------
    movq 16(%rbp), %rax
    push %rax
    call bestFit        # rax = retorno do bestFit
    cmp $0, %rax        # rax = 0 não achou bloco, cria outro no fim
    je alocaNovoBloco

alocaNovoBloco:




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
        movq $16, %rax
        push %rax
        call ajusta_brk         # soma header ao brk

        subq $8, %rsp           # espaço para tam
        pushq 16(%rbp)
        call calculaTam
        movq %rax,-8(%rbp)      # -8 rbp = tam calculado
        pushq -8(%rbp)          # empilha tam
        call ajusta_brk         

        movq $1,0($brk_original) # status = 0
        movq 16(%rbp), 8($brk_original) # bloco.tam = bytes

        movq -8(%rbp), %rbx     # rbx = tam
        subq 16(%rbp), %rbx     # rbx = rbx - tam (tam - bytes)

        # -- verifica se sobrou espaço no bloco
        cmp $0,%rbx
        je retorna_endereco
    # ------ calcula tam restante
        movq -8(%rbp), %rbx
        subq 16(%rbp), %rbx # rbx = tam - bytes
        cmp $0, rbx
        jg aloca_mem_restante # TODO criar novo bloco
        jmp retorna_endereco

    aloca_mem_restante:
        movq $brk_original, %rax
        add $16, %rax            # tamanho do header
        add 8(%brk_original), %rax # rax = end + tam

        movq $0, 0(%rax)        # seta status do novo bloco
        movq %rbx, 8(%rax)      # seta o tamanho do novo bloco
    retorna_endereco:
        movq $brk_original, %rax
        addq $16, %rax # endereço do inicio do bloco
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
