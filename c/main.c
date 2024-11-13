#include "main.h"

void *a;
void *base;
void *topo;

int main(int argc, char **argv)
{
    base = topo = NULL;
    iniciaAlocador(&base,&topo);
    
    printf("base: %p\ntopo: %p\n",base,topo);

    
    a = alocaMem(100);

    strcpy (a, "Preenchimento de Vetor");
    
    printf("%s\n",(char*)a);
    

    void *inicio = sbrk(0);
    void *fim = inicio + 100;

    printf("inicio: %p\nfim: %p\n",inicio,fim);
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
