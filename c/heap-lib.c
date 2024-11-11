#include "heap-lib.h"
#include <unistd.h>
#include <stdio.h>



/*
*
* Cria as estruturas de gerenciamento da heap
* Aloca 4096 bytes na heap e aponta o ponteiro
* base para base da alocação
* e o ponteiro topo para o topo da alocação
* TODO criar estruturas de dados para gerenciamento da heap
*/
void iniciaAlocador(void **base, void **topo){
    *base = sbrk(0);
    sbrk(4096);
    *topo = sbrk(0);
   
    //TODO inicializar as duas lista, como faz isso sem malloc? boa pergunta
    struct nodo_t blocosLivres;
    struct nodo_t blocosOcupados;


    
    #ifdef _DEBUG_
    printf("base: %p\ntopo: %p\n",*base,*topo);
    #endif

}
/*
 *solicita a alocação de um bloco com num_bytes bytes
 *na heap e que retorne o ende-reço inicial deste bloco
 * 
 */
void *alocaMem(int bytes){

    return sbrk(bytes);
}


/*
 *Libera as estruturas criadas por iniciaAlocador()
 * 
 */
void finalizaAlocador(){

}


/*
 *Devolve para a heap o bloco que foi alocado por alocaMem.
 *O parâmetro bloco é o ende-reço retornado por alocaMem.
 *
 * */
int liberaMem(void *bloco){


    return 0;
}
