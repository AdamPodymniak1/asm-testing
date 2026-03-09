all: main

main: main.o
	@ld main.o -o main

main.o: main.s
	@as main.s -o main.o

run: all
	@./main