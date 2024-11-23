OBJECTS = main.o meuAlocador.o

all: main

main.o: main.s
	as -o main.o main.s

meuAlocador.o: meuAlocador.s
	as -o meuAlocador.o meuAlocador.s

main: $(OBJECTS)
	ld -o main $(OBJECTS)

clean:
	rm -f $(OBJECTS) main
