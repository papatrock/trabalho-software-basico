#include "main.h"

nodo_t *blocosLivres;
nodo_t *blocosOcupados;

int main(int argc, char **argv)
{
    //nodo_t blocosLivre;
    //nodo_t blocoOcupados;
    iniciaAlocador();
    

    void *b = alocaMem(200);
    void *a = alocaMem(100);

    
    strcpy (a, "Preenchimento de Vetor");
    strcpy(b, a);
    printf("a:%s addr:%p\nb:%s addr:%p\n",(char*)a,a,(char*)b,b);
    /*
    liberaMem(a);
    liberaMem(b);

    a = alocaMem(50);
    liberaMem(a);
    */
    //finalizaAlocador();

    return 0;
}
