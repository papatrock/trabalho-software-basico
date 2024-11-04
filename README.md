# Enunciado
Implemente o algoritmo proposto na Seção 6.1.2 em **assembly**.
## Variações:
* c) Minimize o número de chamadas ao serviço brk alocando espaços múltiplos de 4096 bytes por vez. Se for solicitado um espaço maior, digamos 5000 bytes, então será alocado um espaço de 4096 ∗ 2 = 8192 bytes para acomodá-lo.
* e) Escolha dos nós livres: best fit: percorre toda a lista e seleciona o nó com menor bloco que é maior do que o solicitado;

## Enunciado do livro
![image](https://github.com/user-attachments/assets/81695c7f-87fc-4dee-a3b1-bfae04468154)

### 6.2 implemente as seguintes variações:
**a)** faça a fusão de nós livres;

**b)** use duas regiões: uma para as informações gerenciais e uma para os nós;

**c)** minimize o número de chamadas ao serviço brk alocando espaços múltiplos de 4096 bytes por vez. Se for solicitado um espaço maior, digamos 5000 bytes, então será alocado um espaço de 4096 ∗ 2 = 8192 bytes
para acomodá-lo.

**d)** utilize duas listas: uma com os nós livres e uma com os ocupados;

**e)** escreva variações do algoritmo de escolha dos nós livres:
* first fit: percorre a lista do início e escolhe o primeiro nó com tamanho maior ou igual ao solicitado;
* best fit: percorre toda a lista e seleciona o nó com menor bloco, que é maior do que o solicitado; 
* next fit: é first fit em uma lista circular. A busca começa onde a última parou.

# Links
https://man7.org/linux/man-pages/man2/brk.2.html
