#include "../include/main.h"

nodo_t *bloco; //variavel global que aponta para o começo do bloco a ser alocado 

int main(int argc, char **argv)
{
    iniciaAlocador();
    void *a = alocaMem(4000);
    void *b = alocaMem(200);
    void *c = alocaMem(200);
    void *d = alocaMem(200);
    void *teste = alocaMem(5);

    #ifdef _DEBUG_
    printf("blocos alocado:\n");
    printLista(bloco);
    printf("------------------\n");
    #endif
    //strcpy (a, "Preenchimento de Vetor");
    printf("a:%s\n addr:%p\n",(char*)a,a);
    //strcpy(b, a);
    liberaMem(a);
    liberaMem(b);
    
    #ifdef _DEBUG_
    printf("blocos alocados após libera mem:\n");
    printLista(bloco);
    printf("------------------\n");
    #endif
    finalizaAlocador();

    return 0;
}