tui enable

break _start

layout regs

tui focus cmd
display/16gx $rsp

run

# si // next instruction
# display/16gx $rsp + 8 // an offset of 8
# info proc mappings // shows where heap starting position is
# x/16xg heap_starting_pos // displays the heap
# watch *heap_starting_pos // stops program the moment the heap changes (then type c for continue)
# jump exit // exits the program (then q to exit completely)