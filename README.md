# Todo
- [ ] inicia alocador
    - [ ] colocar uma variavel "maior bloco"
- [ ] Aloca mem
    - [x] primeira alocação
    - [ ] n alocações
    - [ ] criar mais espaço se alocação não couber em nenhum bloco livre
    - [ ] best fit
- [ ] libera mem
    - [ ] zerar memoria, colocar o nodo na lista de blocos livres e retirar da lista de blocos ocupados
    - [ ] ao liberar memoria verificar se blocos adjacentes estão livres, se sim fazer a fusão
- [ ] Finaliza alocador
- [ ] Funções auxiliares
    - [ ] insere na posição x
    - [ ] limpa nodo

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
**a)** faça a fusão de nós livres

**b)** use duas regiões: uma para as informações gerenciais e uma para os nós

**c)** minimize o número de chamadas ao serviço brk alocando espaços múltiplos de 4096 bytes por vez. Se for solicitado um espaço maior, digamos 5000 bytes, então será alocado um espaço de 4096 ∗ 2 = 8192 bytes
para acomodá-lo.

**d)** utilize duas listas: uma com os nós livres e uma com os ocupados

**e)** escreva variações do algoritmo de escolha dos nós livres

* first fit: percorre a lista do início e escolhe o primeiro nó com tamanho maior ou igual ao solicitado;
* best fit: percorre toda a lista e seleciona o nó com menor bloco, que é maior do que o solicitado; 
* next fit: é first fit em uma lista circular. A busca começa onde a última parou.
### 6.4 implemente um procedimento que imprime um mapa da memória da região da heap em todos os algoritmos propostos aqui. Cada byte da parte gerencial do nó deve ser impresso com o caractere "#". O caractere usado para a impressão dos bytes do bloco de cada nó depende se o bloco estiver livre ou ocupado. Se estiver livre, imprime o caractere -". Se estiver ocupado, imprime o caractere "+".

# Implementação em C

## brk()

```cpp=
#include <unistd.h>

int brk(void *addr); Sets the program break to the location specified by end_data_segment.
```
### Descrição
Define o final do segmento de dados para o valor especificado por addr
## sbrk()
```cpp=
#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[]){

    void *currentBreak = sbrk(0x5);
    printf("First increment of 0x5: %p\n",currentBreak);

    currentBreak = sbrk(0x5);
    printf("Second increment of 0x5: %p\n",currentBreak);
}
```
### Descrição
sbrk() incrementa o espaço de dados do programa em bytes de incremento. Chamar sbrk() com paramtro 0 pode ser usado para encontrar a localização atual da interrupção do programa.
#### Retorno:
Retorna um ponteiro pro inicio da memória recem alocada (se o parametro for 0 retorna o program break anterior) ou void -1 em caso de erro

# Links

[Man brk](https://man7.org/linux/man-pages/man2/brk.2.html)

[Understanding Heap Memory Allocation in C — sbrk and brk](https://scottc130.medium.com/understanding-heap-memory-allocation-in-c-sbrk-and-brk-d9b95c344cbc)
