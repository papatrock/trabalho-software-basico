#include "../include/heap-lib.h"
#include <unistd.h>
#include <stdio.h>


extern nodo_t *blocosLivres;
extern nodo_t *blocosOcupados;
void *memoriaLivreBloco1 = NULL;
void *fimBloco1 = NULL;

/*
* Cria as estruturas de gerenciamento da heap
* aloca dois blocos de TAM_BLOQ_CTRL * tamanho do nodo_t
* um para alocar a lista de blocos livre e a outro para blocos ocupados
* Utiliza variaveis globais para fazer o controle
*/
void iniciaAlocador()
{
    size_t blocTam = sizeof(nodo_t);

    void* bloco1 = sbrk(blocTam * TAM_BLOQ_CTRL);
    if (bloco1 == (void*)-1) {
        fprintf(stderr,"Erro de alocacao\n");
        exit(EXIT_FAILURE);
    }
    memoriaLivreBloco1 = bloco1; 
    fimBloco1 = bloco1 + blocTam * TAM_BLOQ_CTRL;


    void* bloco2 = sbrk(blocTam * TAM_BLOQ_CTRL);
    if (bloco2 == (void*)-1) {
        fprintf(stderr,"Erro de alocacao\n");
        exit(EXIT_FAILURE);
    }

    blocosLivres = (nodo_t*) bloco1;
    blocosLivres->endereco = sbrk(0); //inicio da lista aponta para começo da
    blocosLivres->prox = NULL;
    blocosLivres->status = 0;
    blocosLivres->tam = 0;

    blocosOcupados = (nodo_t*) bloco2;
    blocosOcupados->endereco = NULL;
    blocosOcupados->prox = NULL;
    blocosOcupados->status = 0;
    blocosOcupados->tam = 0;
}

/**
 *solicita a alocação de um bloco da heap
 * @param bytes  tamanho da alocação
 * @return ponteiro para o inicio do bloco
 */
void *alocaMem(int bytes){

    //lista vazia
    if (blocosLivres->prox == NULL && blocosLivres->tam == 0) {
        size_t tam;
        
        // Calcula o tamanho (multiplo de 4096)
        if (bytes <= 4096)
            tam = 4096;
        else
            tam = ((bytes + 4096 - 1) / 4096) * 4096;
        
        nodo_t *novoNodo = blocosLivres;


        // Inicializa o novo nodo ocupado
        novoNodo->endereco = sbrk(tam);
        if (novoNodo->endereco == (void *)-1) {
            // Erro ao alocar memória
            perror("Erro ao alocar memória com sbrk");
            return NULL;
        }

        novoNodo->status = 1;
        novoNodo->tam = bytes;
        novoNodo->prox = NULL;

        // Insere o novo nodo na lista de blocos ocupados
        blocosOcupados = insereNoFim(blocosOcupados, novoNodo);
        
        // Cria o novo nodo livre com a memoria restante
        blocosLivres = novoNodo + sizeof(nodo_t);
        blocosLivres->endereco = novoNodo->endereco + novoNodo->tam;
        blocosLivres->prox = NULL;
        blocosLivres->status = 0;
        blocosLivres->tam = tam - novoNodo->tam;

        return novoNodo->endereco;
    }

    //daqui pra baixo ta errado
    
    nodo_t *tmp = blocosLivres;
    while (tmp->prox != NULL)
        tmp = tmp->prox;
    
    nodo_t *novoNodo = bestFit(blocosLivres, bytes);
    if(!novoNodo)
        printf("nao encontrou um nodo\n");
    size_t tam = novoNodo->tam - bytes;
    novoNodo->status = 1;
    novoNodo->tam = bytes;
    blocosOcupados = insereNoFim(blocosOcupados,novoNodo);

    //if(!novoNodo) -> cria um nodo novo no fim

    //aloca memoria restante em um novo nodo
    blocosLivres = novoNodo + sizeof(nodo_t);
    blocosLivres->endereco = novoNodo->endereco + novoNodo->tam;
    blocosLivres->prox = NULL;
    blocosLivres->status = 0;
    blocosLivres->tam = tam - novoNodo->tam;

    
    return novoNodo->endereco; 
}

nodo_t *bestFit(nodo_t *inicio,size_t tam){
    nodo_t *tmp = inicio;
    nodo_t *bestFit = NULL;

    while(tmp != NULL){
        if(tmp->tam >= tam && (bestFit == NULL || tmp->tam < bestFit->tam)){
            printf("AAAAAAAAAAAAAAAAA\n");
            bestFit = tmp;
        }
        tmp = tmp->prox;
    }

            

    return bestFit;
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
    nodo_t *nodo;

    //nodo = procuraNodo(bloco);
    if(!nodo)
        return 0;
    

    return 1;
}



