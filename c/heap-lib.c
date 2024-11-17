#include "heap-lib.h"
#include <unistd.h>
#include <stdio.h>


extern nodo_t *blocosLivres;
extern nodo_t *blocosOcupados;
void *memoriaLivreBloco1 = NULL;
void *fimBloco1 = NULL; 
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

    size_t blocTam = sizeof(nodo_t);
    printf("tamanho:%ld\n",blocTam);

    void* bloco1 = sbrk(blocTam * TAM_BLOQ_CTRL);
    if (bloco1 == (void*)-1) {
        fprintf(stderr,"Erro de alocacao\n");
        exit(EXIT_FAILURE);
    }
    memoriaLivreBloco1 = bloco1; 
    fimBloco1 = bloco1 + blocTam * 1000;


    void* bloco2 = sbrk(blocTam * TAM_BLOQ_CTRL);
    if (bloco2 == (void*)-1) {
        fprintf(stderr,"Erro de alocacao\n");
        exit(EXIT_FAILURE);
    }

    blocosLivres = (nodo_t*) bloco1;
    blocosLivres->endereco = NULL;
    blocosLivres->prox = NULL;
    blocosLivres->status = 0;
    blocosLivres->tam = 0;

    blocosOcupados = (nodo_t*) bloco2;
    blocosOcupados->endereco = NULL;
    blocosOcupados->prox = NULL;
    blocosOcupados->status = 0;
    blocosOcupados->tam = 0;
    
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
        return NULL;
    }

    bloco->status = 0;
    bloco->tam = 0;
    bloco->endereco = sbrk(tam);
    if(bloco->endereco == (void *)-1){
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
    //TODO encontrar o melhor bloco
    nodo_t *nodo = blocosLivres;

    //lista vazia
    if(nodo->endereco == NULL && nodo->prox == NULL){
        nodo->endereco = sbrk(4096); //TODO implementar verificador de acesso (nosso proprio segfault)
        nodo->status = 1;
        nodo->tam = bytes;
        return nodo->endereco;

    }

    while (nodo->prox != NULL)
        nodo = nodo->prox;
    
    nodo_t *novo_nodo = (nodo_t *)memoriaLivreBloco1;
    memoriaLivreBloco1 += sizeof(nodo_t);
    novo_nodo->status = 1;
    novo_nodo->tam = bytes;
    novo_nodo->endereco = (void *)((char *)nodo->endereco + nodo->tam); //TODO verificar esses endereços
    
    nodo->prox = novo_nodo;
    
    return novo_nodo->endereco; 
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
