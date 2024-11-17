#include <unistd.h> // para usar brk();
#include <stdlib.h> // para malloc (TEMPORARIO)

#define TAM_BLOQ_CTRL 100

struct nodo {
    void *endereco;
    int status;
    int tam;
    struct nodo *prox;
};
typedef struct nodo nodo_t;

void iniciaAlocador();


void *alocaMem(int bytes);

nodo_t *iniciaBloco(int tam,nodo_t *inicio);
