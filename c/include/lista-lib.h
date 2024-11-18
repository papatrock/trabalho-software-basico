#include <stdlib.h>
#include <stdio.h>

struct nodo {
    void *endereco;
    int status;
    int tam;
    struct nodo *prox;
};
typedef struct nodo nodo_t;


void printLista(nodo_t *inicio);

nodo_t* insereNoFim(nodo_t *inicio, nodo_t *nodo);

int insereNaPosicao(nodo_t *inicio,void* endereco, nodo_t *nodo);

int removeNodo(nodo_t *inicio, nodo_t *nodo);

int comparaNodo(nodo_t *nodo1, nodo_t *nodo2);