#include "heap-lib.h"
#include <unistd.h>
#include <stdio.h>



/*
* Aloca 4096 bytes na heap e aponta o ponteiro base para base da alocação
* e o ponteiro topo para o topo da alocação
*
*/
int iniciaAlocador(void **base, void **topo){
    *base = sbrk(0);
    sbrk(4096);
    *topo = sbrk(0);
    
    
    #ifdef _DEBUG_
    printf("base: %p\ntopo: %p\n",*base,*topo);
    #endif

    return 0;
}

void *alocaMem(int bytes){

    return sbrk(bytes);
}
