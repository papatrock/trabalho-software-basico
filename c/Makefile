CFLAGS = -Wall -g
Objs = main.o heap-lib.o lista-lib.o

all: main

debug: CFLAGS += -D_DEBUG_ -g
debug: all

main: $(Objs)
	gcc $(Objs) $(CFLAGS) -o main

main.o: src/main.c include/main.h
	gcc $(CFLAGS) -c src/main.c -o main.o

heap-lib.o: src/heap-lib.c include/heap-lib.h
	gcc $(CFLAGS) -c src/heap-lib.c -o heap-lib.o

lista-lib.o: src/lista-lib.c include/lista-lib.h
	gcc $(CFLAGS) -c src/lista-lib.c -o lista-lib.o

clean:
	rm -f *~ *.o

purge: clean
	rm -f main
