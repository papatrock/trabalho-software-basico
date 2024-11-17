#include "../include/main.h"

nodo_t *blocosLivres;
nodo_t *blocosOcupados;

int main(int argc, char **argv)
{
    //nodo_t blocosLivre;
    //nodo_t blocoOcupados;
    iniciaAlocador();
    
    void *a = alocaMem(100);
    //void *b = alocaMem(200);

    //printLista(blocosLivres);
    printLista(blocosOcupados);

    
    strcpy (a, "Preenchimento de Vetor");
    printf("a:%s addr:%p\n",(char*)a,a);
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
