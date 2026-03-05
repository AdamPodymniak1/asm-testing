.global _start

.data

hellowrld: .ascii "HELLO, WORLD!" # CREATE DATA POINT
newline: .byte 0x0A
len = . - hellowrld

.text
_start:

# HELLO WORLD CODE:
mov $1, %rax # SPECIFY WRITING MODE
mov $1, %rdi # SPECIFY STD OUT (TERMINAL)
mov $hellowrld, %rsi # SEND DATA ADRESS
mov $len, %rdx # SPECIFY STRINGS LENGTH
syscall # CALLING THE WRITE FUNCTION

# SAFE EXITING
mov $60, %rax
xor %rdi, %rdi
syscall
