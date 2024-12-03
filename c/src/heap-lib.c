#include "../include/heap-lib.h"



nodo_t *bloco;
void *brk_original;

/*
* Cria as estruturas de gerenciamento da heap
* aloca dois blocos de TAM_BLOQ_CTRL * tamanho do nodo_t
* um para alocar a lista de blocos livre e a outro para blocos ocupados
* Utiliza variaveis globais para fazer o controle
*/
void iniciaAlocador()
{
    brk_original = sbrk(0);
    bloco = sbrk(sizeof(nodo_t));
    bloco->endereco = sbrk(0); //inicio da lista aponta para começo da
    bloco->prox = NULL;
    bloco->status = 0;
    bloco->tam = 0;
    
}

/**
 *solicita a alocação de um bloco da heap
 * @param bytes  tamanho da alocação
 * @return ponteiro para o inicio do bloco
 */
void *alocaMem(int bytes){

    //lista vazia
    if (bloco->prox == NULL && bloco->tam == 0) {
        size_t tam;
        
        // Calcula o tamanho (multiplo de 4096)
        if (bytes <= 4096)
            tam = 4096;
        else
            tam = ((bytes + 4096 - 1) / 4096) * 4096;
        
        
        bloco->endereco = sbrk(tam);
        if (bloco->endereco == (void *)-1) {
            // Erro ao alocar memória
            perror("Erro ao alocar memória com sbrk");
            return NULL;
        }

        bloco->status = 1;
        bloco->tam = bytes;
        
        nodo_t *novoNodo = sbrk(sizeof(nodo_t));
        if (novoNodo == (void *)-1) {
            // Erro ao alocar memória
            perror("Erro ao alocar memória com sbrk");
            return NULL;
        }
        // Cria o novo nodo livre com a memoria restante
        novoNodo->endereco = bloco->endereco + bloco->tam;
        novoNodo->tam = tam - bloco->tam;
        novoNodo->status = 0;
        novoNodo->prox = NULL;
        
        bloco->prox = novoNodo;

        return bloco->endereco;
    }
    
    size_t tamRestante;
    nodo_t *novoNodo = bestFit(bloco, bytes);
    //se nao encontrar, cria um novo nodo e insere no fim da lista
    if(!novoNodo){
        novoNodo = sbrk(sizeof(nodo_t));
        size_t tam;
        
        // Calcula o tamanho (multiplo de 4096)
        if (bytes <= 4096)
            tam = 4096;
        else
            tam = ((bytes + 4096 - 1) / 4096) * 4096;

        novoNodo->endereco = sbrk(tam);
        novoNodo->tam = bytes;
        novoNodo->status = 1;
        novoNodo->prox = NULL;
        bloco = insereNoFim(bloco,novoNodo);
        tamRestante = tam - bytes;
    }else{
        tamRestante = novoNodo->tam - bytes; //memoria restante daquele bloco
        novoNodo->status = 1;
        novoNodo->tam = bytes;
    }
    //aloca memoria restante em um novo nodo
    if(tamRestante > 0){   
        nodo_t *memRestante = sbrk(sizeof(nodo_t));
        if (novoNodo == (void *)-1) {
            // Erro ao alocar memória
            perror("Erro ao alocar memória com sbrk");
            return NULL;
        }
        // Cria o novo nodo livre com a memoria restante
        memRestante->endereco = novoNodo + novoNodo->tam;
        memRestante->tam = tamRestante;
        memRestante->status = 0;
        memRestante->prox = novoNodo->prox;

        novoNodo->prox = memRestante;
    }

    return novoNodo->endereco; 
}

nodo_t *bestFit(nodo_t *inicio,size_t tam){
    nodo_t *tmp = inicio;
    nodo_t *bestFit = NULL;

    while(tmp != NULL){
        if((tmp->tam >= tam && tmp->status == 0) && (bestFit == NULL || tmp->tam < bestFit->tam))
            bestFit = tmp;
        
        tmp = tmp->prox;
    }
    return bestFit;
}

nodo_t *worstFit(nodo_t *inicio,size_t tam){
    nodo_t *tmp = inicio;
    nodo_t *bestFit = NULL;

    while(tmp != NULL){
        if((tmp->tam >= tam && tmp->status == 0) && (bestFit == NULL || tmp->tam > bestFit->tam))
            bestFit = tmp;
        
        tmp = tmp->prox;
    }
    return bestFit;
}

/*
 *Devolve para a heap o bloco que foi alocado por alocaMem->
 *O parâmetro bloco é o endereço retornado por alocaMem->
 *
 * */
void liberaMem(void *endereco){
    if (!endereco) {
        printf("Erro: endereço inválido.\n");
        return;
    }

    nodo_t *nodo = bloco;

    while(nodo != NULL && nodo->endereco != endereco){
        //nodo_t *anterior = nodo;
        nodo = nodo->prox;
    }

    if(!nodo){
        printf("Erro: endereço não encontrado na lista\n");
        return;
    }
    //zera memoria
    memset(nodo->endereco, 0, nodo->tam); // sera q precisa?
    nodo->status = 0;
    endereco = NULL;
    printf("Memoria liberada com sucesso\n");
}


/*
 *Libera as estruturas criadas por iniciaAlocador()
 * 
 */
void finalizaAlocador() {
    #ifdef _DEBUG_
    printf("brk antes de finalizaAlocador: %p\n", sbrk(0));
    #endif

    brk(brk_original);

    #ifdef _DEBUG_
    // temq usar fprinf porq o buffer do printf foi de base dps de restaurar brk
    fprintf(stderr,"brk depois de finalizaAlocador: %p\n", sbrk(0));
    #endif
}

void imprimeMapa() {
    nodo_t *nodo = bloco;  

    while (nodo != NULL) {
        
        for (int i = 0; i < sizeof(nodo_t); i++) {
            printf("#");  
        }
        
        for (int i = 0; i < nodo->tam; i++) {
            if (nodo->status == 0) {
                printf(".");  
            } else {
                printf("+"); 
            }
        }

        printf("\n");
        nodo = nodo->prox;  
    }
}
