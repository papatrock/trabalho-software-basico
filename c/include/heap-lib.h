#include <unistd.h> // para usar brk();
#include <stdlib.h> // para malloc (TEMPORARIO)
#include "../include/lista-lib.h"

#define TAM_BLOQ_CTRL 100


void iniciaAlocador();

void *alocaMem(int bytes);

void finalizaAlocador();

nodo_t *bestFit(nodo_t *inicio,size_t tam);

void liberaMem(void *bloco);
