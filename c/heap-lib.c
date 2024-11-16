#include "heap-lib.h"
#include <unistd.h>
#include <stdio.h>


extern nodo_t *blocosLivres;
extern nodo_t *blocosOcupados;
/*
* Cria as estruturas de gerenciamento da heap
* Aloca 4096 bytes na heap e aponta o ponteiro
* base para base da alocação
* e o ponteiro topo para o topo da alocação
* TODO criar estruturas de dados para gerenciamento da heap
*/
void iniciaAlocador()
{
    /*
     * lista de blocos livres aponta para o início,
     * e de blocos ocupados para NULL (nenhum bloco ocupado ainda)->
     */
    blocosLivres = iniciaBloco(0, NULL);
    blocosOcupados = NULL;
    
    
    #ifdef _DEBUG_
    printf("Lista de blocos livres: %p\n", (void *)blocosLivres);
    printf("Lista de blocos ocupados: %p\n", (void *)blocosOcupados);
    #endif
}

/*
 * Inicia um bloco de TAM bytes
 * posiciona o bloco novo no fim da lista de blocos
 */
nodo_t *iniciaBloco(int tam, nodo_t *inicio){
    nodo_t *bloco = (nodo_t *)sbrk(sizeof(nodo_t));
    if(bloco == (void *)-1){
        printf("Erro ao alocar memória\n");
        return NULL;
    }

    bloco->status = 0;
    bloco->tam = 0;
    bloco->endereco = sbrk(tam);
    if(bloco->endereco == (void *)-1){
        printf("Erro ao alocar memória\n");
        return NULL;
    }

    bloco->prox = NULL;    
    if(inicio == NULL)
        return bloco;

    //coloca o bloco no final da lista
    nodo_t *nodo = inicio;
    while (nodo->prox != NULL) {
        nodo = nodo->prox;
    }
    
    nodo->prox = bloco;
    return bloco;
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
 *Devolve para a heap o bloco que foi alocado por alocaMem->
 *O parâmetro bloco é o ende-reço retornado por alocaMem->
 *
 * */
int liberaMem(void *bloco){


    return 0;
}
