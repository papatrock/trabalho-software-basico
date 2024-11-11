CFLAGS = -Wall
Objs = main.o heap-lib.o

all: main

debug: CFLAGS += -D_DEBUG_ -g
debug: all

main: $(Objs)
	gcc $(Objs) $(CFLAGS) -o main

main.o: main.c main.h
	gcc $(CFLAGS) -c main.c -o main.o

heap-lib.o: heap-lib.c heap-lib.h
	gcc $(CFLAGS) -c heap-lib.c -o heap-lib.o

clean:
	rm -f *~ *.o

purge: clean
	rm -f main
