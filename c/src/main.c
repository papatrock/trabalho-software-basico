#include "../include/main.h"

nodo_t *blocosLivres;
nodo_t *blocosOcupados;

int main(int argc, char **argv)
{
    iniciaAlocador();
    void *a = alocaMem(100);
    void *b = alocaMem(200);

    #ifdef _DEBUG_
    printf("blocos livres:\n");
    printLista(blocosLivres);
    printf("\nblocos ocupados:\n");
    printLista(blocosOcupados);
    #endif

    
    strcpy (a, "Preenchimento de Vetor");
    printf("a:%s addr:%p\n",(char*)a,a);
    strcpy(b, a);
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
