CC = gcc              # Compilador C
AS = as               # Assembler

CFLAGS = -Wall -O2 -fPIC           # Flags para o compilador C
ASFLAGS =                   # Flags para o assembler
LDFLAGS = -nostartfiles -no-pie    # Flags para o linker

OBJECTS = exemplo.o main.o meuAlocador.o

all: main             # Alvo principal

# Compila exemplo.c
exemplo.o: exemplo.c meuAlocador.h
	$(CC) $(CFLAGS) -c exemplo.c -o exemplo.o

# Compila main.s
main.o: main.s
	$(AS) $(ASFLAGS) -o main.o main.s

# Compila meuAlocador.s
meuAlocador.o: meuAlocador.s meuAlocador.h
	$(AS) $(ASFLAGS) -o meuAlocador.o meuAlocador.s

# Faz o link de tudo para gerar o executável
main: $(OBJECTS)
	$(CC) $(LDFLAGS) -o main $(OBJECTS)

# Limpa os arquivos gerados
clean:
	rm -f $(OBJECTS) main
