#include "heap-lib.h"
#include <unistd.h>
#include <stdio.h>



/*
* Cria as estruturas de gerenciamento da heap
* Aloca 4096 bytes na heap e aponta o ponteiro
* base para base da alocação
* e o ponteiro topo para o topo da alocação
* TODO criar estruturas de dados para gerenciamento da heap
*/
void iniciaAlocador(nodo_t *blocosLivres, nodo_t *blocosOcupados){
    /*
     * lista de blocos vazio aponta para o inicio
     * e de blocos ocupados para NULL (nenhum bloco ocupado ainda);
     */
    blocosLivres = iniciaBloco(0,NULL);
    blocosOcupados = iniciaBloco(0,NULL);
    blocosOcupados->endereco = NULL;
    
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
 * Inicia um bloco de TAM bytes
 * posiciona o bloco novo no fim da lista de blocos
 */
nodo_t *iniciaBloco(int tam, nodo_t inicio){
    nodo_t *bloco;
    bloco->status = 0;
    bloco->tam = 0;
    bloco->endereco = sbrk(tam);
    bloco->prox = NULL;
    //aloca na lista
    
    if(inicio == NULL)
        return bloco;

    for(noto_t nodo = inicio; nodo.prox != NULL; nodo = nodo.prox){}
    
    nodo.prox = bloco;
    return bloco;
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
