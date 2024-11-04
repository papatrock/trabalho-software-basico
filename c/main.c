#include "main.h"

void *a;

int main(int argc, char **argv)
{
    void *b;
    iniciaAlocador();
    a = alocaMem(100);
    b = alocaMem(200);
    
    strcpy (a, "Preenchimento de Vetor");
    strcpy(b, a);
    
    liberaMem(a);
    liberaMem(b);

    a = alocaMem(50);
    liberaMem(a);

    finalizaAlocador();

    return 0;
}
