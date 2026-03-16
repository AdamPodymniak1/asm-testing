SRC ?= main.s
BASE = $(basename $(SRC))

ASFLAGS = -g

.PHONY: all debug run clean

all: $(BASE)

$(BASE): $(BASE).o
	@ld $< -o $@

$(BASE).o: $(SRC)
	@as $(ASFLAGS) $< -o $@

debug:
	@# This ensures we build the target corresponding to the current SRC
	@$(MAKE) $(BASE)
	gdb -x .gdbinit ./$(BASE)

run: all
	@./$(BASE)
	
run_c:
	@gcc -no-pie $(BASE).s -o $(BASE)
	@./$(BASE)

clean:
	@rm -f $(BASE) $(BASE).o