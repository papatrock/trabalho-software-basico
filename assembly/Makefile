CC = gcc
AS = as
CFLAGS = -g -no-pie
LFLAGS = -lm -ld printfScanf.o -o printfScanf -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 \
/usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o \
/usr/lib/x86_64-linux-gnu/crtn.o -lc 

main: main.o meuAlocador.o
	$(CC) $(CFLAGS) $(LFLAGS) -o main exemplo.o meuAlocador.o

meuAlocador.o: meuAlocador.s 
	$(AS) $(CFLAGS) -c meuAlocador.s -o meuAlocador.o

main.o: exemplo.c meuAlocador.h
	$(CC) $(CFLAGS) -c exemplo.c -o exemplo.o

run:
	./exemplo

clean:
	rm ./*.o

purge:
	rm main *.o	