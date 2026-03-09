SRC ?= main.s
BASE = $(basename $(SRC))

all: $(BASE)

$(BASE): $(BASE).o
	@ld $(BASE).o -o $@

$(BASE).o: $(SRC)
	@as $< -o $@

run: all
	@./$(BASE)