.section .data
    nodo:
        .quad 0  # endereco
        .quad 0  # status
        .quad 0  # tam
        .quad 0  # prox

.section .text
    
.globl nodo_var  _start

nodo_var:
    .quad nodo;

start:
    movq %rax, %rbx
    movq $60, %rax
    movq %rbx, %rdi
    syscall 
