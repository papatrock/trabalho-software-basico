#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a,*b,*c,*d,*e;

  iniciaAlocador(); 
  imprimeMapa(); //ok
  // 0) estado inicial

  a=(void *) alocaMem(100);
  imprimeMapa(); //ok
  b=(void *) alocaMem(130);
  imprimeMapa(); //ok
  c=(void *) alocaMem(140);
  imprimeMapa(); //ok
  d=(void *) alocaMem(110);
  imprimeMapa(); //ok
  // 1) Espero ver quatro segmentos ocupados

  liberaMem(b);
  imprimeMapa(); //k
  liberaMem(d);
  imprimeMapa(); //ok
  // 2) Espero ver quatro segmentos alternando
  //    ocupados e livres

  b=(void *) alocaMem(50);
  imprimeMapa(); //ok
  d=(void *) alocaMem(90);
  imprimeMapa(); //ok
  e=(void *) alocaMem(40);
  imprimeMapa(); //ok
  // 3) Deduzam
	
  liberaMem(c);
  imprimeMapa(); 
  liberaMem(a);
  imprimeMapa();
  liberaMem(b);
  imprimeMapa();
  liberaMem(d);
  imprimeMapa();
  liberaMem(e);
  imprimeMapa();
   // 4) volta ao estado inicial

  finalizaAlocador();
}
