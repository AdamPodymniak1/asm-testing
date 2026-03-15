tui enable

break _start

layout regs

tui focus cmd
display/16gx $rsp

run

# si - next instruction
# display/16gx $rsp + 8 // an offset of 8