#include "../include/lista-lib.h"

void printLista(nodo_t *inicio){
    if (inicio == NULL) {
        printf("A lista está vazia.\n");
        return;
    }

    nodo_t *tmp = inicio;
    
    while (tmp != NULL) {
        printf("Ponteiro:%p\nEndereco: %p, Status: %d, Tam: %d,Prox:%p\n\n",tmp,tmp->endereco, tmp->status, tmp->tam, tmp->prox);
        tmp = tmp->prox;
    }
}

nodo_t* insereNoFim(nodo_t *inicio, nodo_t *nodo){
    if (nodo == NULL) {
        return inicio;
    }

    nodo->prox = NULL;

    // Primeiro da lista
    if (inicio->endereco == NULL && inicio->prox == NULL) {
        inicio = nodo;
        return inicio;
    }

    nodo_t *tmp = inicio;

    while (tmp->prox != NULL)
        tmp = tmp->prox;

    tmp->prox = nodo;

    return inicio;
}

int insereNaPosicao(nodo_t *inicio,void* endereco, nodo_t *nodo){

    return 1;
}

/*
* Não remover nodo de uma lista sem antes alocar na outra
* para nao ter leaks (sdds free())
*/
nodo_t* removeNodo(nodo_t *inicio, nodo_t *nodo){
    if (inicio == NULL || nodo == NULL) {
        return NULL;
    }

    nodo_t *tmp = inicio;

    if (comparaNodo(tmp, nodo)) {
        inicio = tmp->prox; 
        return inicio;
    }

    while (tmp->prox != NULL && !comparaNodo(tmp->prox, nodo))
        tmp = tmp->prox;

    if (tmp->prox == NULL) // Nodo não está na lista
        return inicio;  //retorna lista sem alteracao
    
    tmp->prox = tmp->prox->prox;
    return inicio;
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

