#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a, *b;

  iniciaAlocador();               // Impressão esperada
  //imprimeMapa();                  // <vazio>

  a = (void *) alocaMem(10);
  imprimeMapa();                  // ################**********
  
  /*b = (void *) alocaMem(4);
  imprimeMapa();                  // ################**********##############****
  liberaMem(a);
  imprimeMapa();                  // ################----------##############****
  liberaMem(b);                   // ################----------------------------
                                  // ou
                                  // <vazio>
  */
 finalizaAlocador();
}
/*
  movq brk_original, %rcx               # rcx = brk_original (valor atual da heap, início do header)
    movq $0, (%rcx)                 # status = 0
    movq $0, 8(%rcx)                # tamanho = 0
*/