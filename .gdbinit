tui enable

break _start

layout regs

tui focus cmd
display/20gx $rsp

run

# si - next instruction