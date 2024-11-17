#include <unistd.h> // para usar brk();
#include <stdlib.h> // para malloc (TEMPORARIO)
#include "../include/lista-lib.h"

#define TAM_BLOQ_CTRL 100


void iniciaAlocador();


void *alocaMem(int bytes);

nodo_t *iniciaBloco(int tam,nodo_t *inicio);
