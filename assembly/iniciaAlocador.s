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
