tui enable

break _start

layout regs

tui focus cmd
display/16gx $rsp

run

# si // next instruction
# ni // next instruction (skips functions)
# display/16gx $rsp + 8 // an offset of 8
# info proc mappings // shows where heap starting position is
# x/16xg heap_starting_pos // displays the heap
# watch *heap_starting_pos // stops program the moment the heap changes (then type c for continue)
# jump exit // exits the program (then q to exit completely)
# layout src // displays source code
# int3 // in asm code, to break at speciffic point
# source ~/.gdb-dashboard // open dashboard
# tui reg general / vector / float / system / next / prev # showing different register groups