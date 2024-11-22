alocamMem:
    pushq %rbp
    movq %rsp, %rbp
    movq $0, %rax
    movq 8($brk_original), %rbx # Se tamanho do primeiro bloco = 0 -> lista vazia
    cmp %rbx, %rax
    je lista_vazia

lista_vazia:
    cmp $4096,16(%rbp)
    jg else # if(bytes > 4096) jump else
    movq $4096,-8(%rbp) # tam = 4096
    j seta_status
# ------- calcula tam -----------
else: # Calcula multiplo de 4096
    movq 16(%rbp), %rax    # rax = bytes
    addq $4096, %rax       # Soma 4096
    subq $1, %rax          # Subtrai 1
    xorq %rdx, %rdx        # Limpa %rdx para evitar erros no divq
    movq $4096, %rbx       # Divisor
    divq %rbx              # Divide %rax por 4096 (resultado em %rax)
    imulq $4096, %rax      # Multiplica o quociente por 4096
    movq %rax, -8(%rbp)    # Armazena o múltiplo em -8(%rbp) (tam)
    j seta_status
# -------- fim calcula tam -------
seta_status:
    movq $1,0($brk_original) # status = 0
    movq 16(%rbp), 8($brk_original) # bloco.tam = bytes
# ------ calcula tam restante
    movq -8(%rbp), %rbx
    subq 16(%rbp), %rbx # rbx = tam - bytes
    cmp $0, rbx
    jg aloca_mem_restante # TODO criar novo bloco
    j retorna_endereco

aloca_mem_restante:
    movq $brk_original, %rax
    add $16, %rax            # tamanho do header
    add 8(%brk_original), %rax
    movq $0, 0(%rax)        # seta status do novo bloco
    movq %rbx, 8(%rax)      # seta o tamanho do novo bloco
    j retorna_endereco

retorna_endereco:
    movq $brk_original, %rax
    addq $16, %rax # endereço do inicio do bloco
    popq %rbp
    ret







