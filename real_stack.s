.global _start

.data

hellowrld: .ascii "HELLO, WORLD!"
newline: .byte 0x0A
len = . - hellowrld

.text
_start:

call print # AUTOMATICALLY PUT ADDRESS ON A STACK, AND JUMP TO PRINT FUNCTION
jmp exit # JUMP TO EXIT AFTER RETURNING FROM PRINT FUNCTION

print:
mov $1, %rax
mov $1, %rdi
mov $hellowrld, %rsi
mov $len, %rdx
syscall
ret # RETURN FROM FUNCTION

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
