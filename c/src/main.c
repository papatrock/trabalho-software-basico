#include "../include/main.h"

nodo_t *bloco; //variavel global que aponta para o começo do bloco a ser alocado 

int main(int argc, char **argv)
{
    iniciaAlocador();
    void *a = alocaMem(4000);
    void *b = alocaMem(200);
    void *c = alocaMem(200);
    void *d = alocaMem(200);
    //printf("\n\n%p\n,addr:%p\nprox:%p\nstatus:%d\ntam:%d",blocosLivres,blocosLivres->endereco,blocosLivres->prox,blocosLivres->status,blocosLivres->tam);    
    //printf("\n\n");
    //printf("%p\n,addr:%p\nprox:%p\nstatus:%d\ntam:%d",blocosLivres->prox,blocosLivres->prox->endereco,blocosLivres->prox->prox,blocosLivres->prox->status,blocosLivres->prox->tam);    

    #ifdef _DEBUG_
    printf("blocos alocado:\n");
    printLista(bloco);
    printf("------------------\n");
    #endif
    strcpy (a, "Preenchimento de Vetor");
    printf("a:%s\n addr:%p\n",(char*)a,a);
    //strcpy(b, a);
    //printf("a:%s addr:%p\nb:%s addr:%p\n",(char*)a,a,(char*)b,b);
    
    liberaMem(a);
    liberaMem(b);
    
    #ifdef _DEBUG_
    printf("blocos alocados após libera mem:\n");
    printLista(bloco);
    printf("------------------\n");
    #endif
    /*
    a = alocaMem(50);
    liberaMem(a);
    */
    //finalizaAlocador();

    return 0;
}
