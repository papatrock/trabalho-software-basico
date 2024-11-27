#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a, *b, *c;

  iniciaAlocador();               // Impressão esperada
  //imprimeMapa();                  // <vazio>

  a = (void *) alocaMem(10);
  //imprimeMapa();                  // ################**********
  b = (void *) alocaMem(4);
  //imprimeMapa();                  // ################**********##############****

  c = (void *) alocaMem (5632);
  //liberaMem(a);
  //imprimeMapa();                  // ################----------##############****
  //liberaMem(b);                   // ################----------------------------
                                  // ou
                                  // <vazio>
  //finalizaAlocador();
}
