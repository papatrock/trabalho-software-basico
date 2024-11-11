#include <unistd.h> //para usar brk();

int iniciaAlocador(void **base, void **topo);


void *alocaMem(int bytes);
