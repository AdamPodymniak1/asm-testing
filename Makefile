SRC ?= main.s
BASE = $(basename $(SRC))

ASFLAGS = -g

all: $(BASE)

$(BASE): $(BASE).o
	@ld $(BASE).o -o $@

$(BASE).o: $(SRC)
	@as $(ASFLAGS) $< -o $@
\
debug: all
	@gdb -x .gdbinit ./$(BASE)

run: all
	@./$(BASE)

clean:
	@rm -f $(BASE) $(BASE).o