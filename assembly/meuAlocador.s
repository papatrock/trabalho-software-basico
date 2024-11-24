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
    