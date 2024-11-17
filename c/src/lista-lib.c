#include "../include/lista-lib.h"

void printLista(nodo_t *inicio){
    if (inicio == NULL) {
        printf("A lista está vazia.\n");
        return;
    }

    nodo_t *tmp = inicio;
    
    while (tmp != NULL) {
        printf("Endereco: %p, Status: %d, Tam: %d\n", tmp->endereco, tmp->status, tmp->tam);
        tmp = tmp->prox;
    }
}

int insereNoFim(nodo_t *inicio, nodo_t *nodo){
    if (inicio == NULL || nodo == NULL) {
        return 0; 
    }

    nodo->prox = NULL;

    if (inicio == NULL){
        inicio = nodo;
        return 1;
    }
    
    nodo_t *tmp = inicio;

    while (tmp->prox != NULL)
        tmp = tmp->prox;

    tmp->prox = nodo;


    return 1;
}

int insereNaPosicao(nodo_t *inicio,void* endereco, nodo_t *nodo){

    return 1;
}
/*
* Não remover nodo de uma lista sem antes alocar na outra
* para nao ter leaks (sdds free())
*/
int removeNodo(nodo_t *inicio, nodo_t *nodo){
    if (inicio == NULL || nodo == NULL) {
        return -1;
    }

    nodo_t *tmp = inicio;

    if (comparaNodo(tmp, nodo)) {
        inicio = tmp->prox; 
        return 1;
    }

    while (tmp->prox != NULL && !comparaNodo(tmp->prox, nodo))
        tmp = tmp->prox;

    if (tmp->prox == NULL)
        return 0; // Nodo não está na lista
    
    tmp->prox = tmp->prox->prox;
    return 1;
}

int comparaNodo(nodo_t *nodo1, nodo_t *nodo2) {

    if (nodo1 == NULL || nodo2 == NULL) {
        return 0; //TODO 0 mesmo?
    }

    return nodo1->endereco == nodo2->endereco &&
           nodo1->status == nodo2->status &&
           nodo1->tam == nodo2->tam &&
           nodo1->prox == nodo2->prox;
}
