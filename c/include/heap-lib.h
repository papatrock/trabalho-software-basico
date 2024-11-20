#include <unistd.h> // para usar brk();
#include "../include/lista-lib.h"
#include <stdio.h>
#include <string.h>

#define TAM_BLOQ_CTRL 100


void iniciaAlocador();

void *alocaMem(int bytes);

void finalizaAlocador();

nodo_t *bestFit(nodo_t *inicio,size_t tam);

void liberaMem(void *bloco);

void imprimeMapa();
