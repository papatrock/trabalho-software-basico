# Todo assembly
- [x] inicia alocador
- [ ] Aloca mem
    - [x] primeira alocação
    - [x] n alocações
    - [ ] criar mais espaço se alocação não couber em nenhum bloco livre
    - [x] best fit
- [ ] libera mem
    - [ ] zerar memoria, colocar o nodo na lista de blocos livres e retirar da lista de blocos ocupados
    - [ ] ao liberar memoria verificar se blocos adjacentes estão livres, se sim fazer a fusão
- [ ] Finaliza alocador

# Enunciado
Implemente o algoritmo proposto na Seção 6.1.2 em **assembly**.
Especificação (2024/2): Página 97 (Projetos de Implementação) 
itens 6.1, 6.2-c, 6.2-e (best fit), 6.4 
## Variações:
* c) Minimize o número de chamadas ao serviço brk alocando espaços múltiplos de 4096 bytes por vez. Se for solicitado um espaço maior, digamos 5000 bytes, então será alocado um espaço de 4096 ∗ 2 = 8192 bytes para acomodá-lo.
* e) Escolha dos nós livres: best fit: percorre toda a lista e seleciona o nó com menor bloco que é maior do que o solicitado;

## Enunciado do livro
![image](https://github.com/user-attachments/assets/d28ae9b7-c205-4c3e-a99a-af6211473415)


### 6.2 implemente as seguintes variações:
**a)** faça a fusão de nós livres **NÃO PRECISA**

**b)** use duas regiões: uma para as informações gerenciais e uma para os nós **NÃO PRECISA**

**c)** minimize o número de chamadas ao serviço brk alocando espaços múltiplos de 4096 bytes por vez. Se for solicitado um espaço maior, digamos 5000 bytes, então será alocado um espaço de 4096 ∗ 2 = 8192 bytes
para acomodá-lo.

**d)** utilize duas listas: uma com os nós livres e uma com os ocupados **NÃO PRECISA**

**e)** escreva variações do algoritmo de escolha dos nós livres

* first fit: percorre a lista do início e escolhe o primeiro nó com tamanho maior ou igual ao solicitado;
* best fit: percorre toda a lista e seleciona o nó com menor bloco, que é maior do que o solicitado; **ESSE AQUI**
* next fit: é first fit em uma lista circular. A busca começa onde a última parou.
### 6.4 implemente um procedimento que imprime um mapa da memória da região da heap em todos os algoritmos propostos aqui. Cada byte da parte gerencial do nó deve ser impresso com o caractere "#". O caractere usado para a impressão dos bytes do bloco de cada nó depende se o bloco estiver livre ou ocupado. Se estiver livre, imprime o caractere -". Se estiver ocupado, imprime o caractere "+".
# Programa utilizado na avaliação
## exemplo.c
```cpp
#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a, *b;

  iniciaAlocador();               // Impressão esperada
  imprimeMapa();                  // <vazio>

  a = (void *) alocaMem(10);
  imprimeMapa();                  // ################**********
  b = (void *) alocaMem(4);
  imprimeMapa();                  // ################**********##############****
  liberaMem(a);
  imprimeMapa();                  // ################----------##############****
  liberaMem(b);                   // ################----------------------------
                                  // ou
                                  // <vazio>
  finalizaAlocador();
}
```
## meuAlocador.h
```cpp
 // Protótipos (seção 6.1.2 e Projeto de Implementação 6.2)
void iniciaAlocador();   // Executa syscall brk para obter o endereço do topo
                         // corrente da heap e o armazena em uma
                         // variável global, topoInicialHeap.
void finalizaAlocador(); // Executa syscall brk para restaurar o valor
                         // original da heap contido em topoInicialHeap.
int liberaMem(void* bloco); // indica que o bloco está livre.
void* alocaMem(int num_bytes) // 1. Procura um bloco livre com tamanho maior ou
                              //    igual à num_bytes.
                              // 2. Se encontrar, indica que o bloco está
                              //    ocupado e retorna o endereço inicial do bloco;
                              // 3. Se não encontrar, abre espaço
                              //    para um novo bloco, indica que o bloco está
                              //    ocupado e retorna o endereço inicial do bloco.
void imprimeMapa();       // imprime um mapa da memória da região da heap.
                          // Cada byte da parte gerencial do nó deve ser impresso
                          // com o caractere "#". O caractere usado para
                          // a impressão dos bytes do bloco de cada nó depende
                          // se o bloco estiver livre ou ocupado. Se estiver livre, imprime o
                          // caractere -". Se estiver ocupado, imprime o caractere "+".

```


# Links

[Man brk](https://man7.org/linux/man-pages/man2/brk.2.html)

[Understanding Heap Memory Allocation in C — sbrk and brk](https://scottc130.medium.com/understanding-heap-memory-allocation-in-c-sbrk-and-brk-d9b95c344cbc)
