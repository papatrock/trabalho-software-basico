#include <unistd.h> // para usar brk();
#include <stdlib.h> // para malloc (TEMPORARIO)


struct nodo {
    void *endereco;
    int status;
    int tam;
    struct nodo *prox;
};
typedef struct nodo nodo_t;

void iniciaAlocador(nodo_t *blocosLivres,nodo_t *blocosOcupados);


void *alocaMem(int bytes);

nodo_t *iniciaBloco(int tam,nodo_t inicio);
