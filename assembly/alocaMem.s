alocamMem:
    movq $0 %rax
    movq 0($brk_original), %rbx
    cmp %rbx, %rax
    je s_0


s_0:
    movq 8($brk_original), %rbx
    cmp %rbx, %rax
    je lista_vazia


lista_vazia:
    cmp $4096,16(%rbp)
    jle if
    jg else
fim_cond:
    j seta_status
# ------- calcula tam -----------
if:
    movq $4096,-8(%rbp) # tam = 4096
    j fim_cond
else: # Calcula multiplo de 4096
    movq 16(%rbp), %rax
    add $4096, %rax
    subq $1, %rax
    divq $4096, %rax
    multq $4096, %rax
    movq %rax,-8(%rbp) # tam = multiplo de 4096
    j fim_cond
# -------- fim calcula tam -------
seta_status:
    movq $1,0($brk_original) # status = 0
    movq 16(%rbp), 8($brk_original) # bloco.tam = bytes
# ------ calcula tam restante
    movq -8(%rbp), %rax
    subq 16(%rbp), %rax # rax = tam - bytes
    cmp $0, rax
    jg aloca_mem_restante # TODO criar novo bloco
    # cansei






