CC = gcc
AS = as
CFLAGS = -g -no-pie

main: main.o meuAlocador.o
	$(CC) $(CFLAGS) -o main exemplo.o meuAlocador.o

meuAlocador.o: meuAlocador.s 
	$(AS) $(CFLAGS) -c meuAlocador.s -o meuAlocador.o

main.o: exemplo.c meuAlocador.h
	$(CC) $(CFLAGS) -c exemplo.c -o exemplo.o

run:
	./main

clean:
	rm ./*.o

purge:
	rm main *.o	