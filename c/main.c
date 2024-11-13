#include "main.h"

void *a;
nodo_t blocosLivre;
nodo_t blocoOcupados;

int main(int argc, char **argv)
{
    iniciaAlocador(&blocosLivre,&blocoOcupados);
    

    /*b = alocaMem(200);
    

    
    strcpy (a, "Preenchimento de Vetor");
    strcpy(b, a);
    
    liberaMem(a);
    liberaMem(b);

    a = alocaMem(50);
    liberaMem(a);
    */
    //finalizaAlocador();

    return 0;
}
