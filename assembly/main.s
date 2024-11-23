.section .data
.section .text  
.globl  _start


_start:
    movq %rax, %rbx
    movq $60, %rax
    movq %rbx, %rdi
    syscall 
