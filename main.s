.global _start

.data

callstack: .skip 4096, 0x0 # INITIALIZING CALLSTACK (500 rows, 8 bytes each, rounded to closest binary value 500*8=4000~~4096). Zeroes out on initialization (0x0)

hellowrld: .ascii "HELLO, WORLD!"
newline: .byte 0x0A
len = . - hellowrld

.text
_start:

mov $callstack, %r15 # SAVING CALLSTACK ARRAY TO THE REGISTRY
mov $exit, %rax # SAVE EXIT ADDRESS IN REGISTRY
mov %rax, (%r15) # SAVE IT IN CALLSTACK

jmp print

print:
mov $1, %rax
mov $1, %rdi
mov $hellowrld, %rsi
mov $len, %rdx
syscall

mov (%r15), %rax # MOVE CURRENT CALLSTACK VALUE TO REGISTRY
add $8, %r15 # INCREASE CALLSTACK TO GET TO NEXT, EMPTY VALUE (for more nested functions)
jmp *%rax # JUMP TO CALLSTACK VALUE

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
