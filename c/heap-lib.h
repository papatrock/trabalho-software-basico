#include <unistd.h> //para usar brk();

struct nodo_t {
    void *endereco;
    int status;
    int tam;
    struct nodo_t *prox;
};

void iniciaAlocador(void **base, void **topo);


void *alocaMem(int bytes);
