#include "../include/main.h"

nodo_t *blocosLivres;
nodo_t *blocosOcupados;

int main(int argc, char **argv)
{
    iniciaAlocador();
    void *a = alocaMem(100);
    //void *b = alocaMem(200);
    //printf("\n\n%p\n,addr:%p\nprox:%p\nstatus:%d\ntam:%d",blocosLivres,blocosLivres->endereco,blocosLivres->prox,blocosLivres->status,blocosLivres->tam);    
    //printf("\n\n");
    //printf("%p\n,addr:%p\nprox:%p\nstatus:%d\ntam:%d",blocosLivres->prox,blocosLivres->prox->endereco,blocosLivres->prox->prox,blocosLivres->prox->status,blocosLivres->prox->tam);    


    #ifdef _DEBUG_
    printf("blocos livres:\n");
    printLista(blocosLivres);
    printf("------------------\n");
    printf("\nblocos ocupados:\n");
    printLista(blocosOcupados);
    #endif
    strcpy (a, "Preenchimento de Vetor");
    printf("a:%s\n addr:%p\n",(char*)a,a);
    //strcpy(b, a);
    //printf("a:%s addr:%p\nb:%s addr:%p\n",(char*)a,a,(char*)b,b);
    /*
    liberaMem(a);
    liberaMem(b);

    a = alocaMem(50);
    liberaMem(a);
    */
    //finalizaAlocador();

    return 0;
}
