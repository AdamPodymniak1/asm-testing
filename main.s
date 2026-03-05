.global _start

.data

hellowrld: .ascii "HELLO, WORLD!" # CREATE DATA POINT
newline: .byte 0x0A # ADDED NEWLINE
len = . - hellowrld # COUNTS CHARS INCLUDING \n

# NEW TEXT DATA
hello2: .ascii "YOU TOO"
new2: .byte 0x0A
l2 = . - hello2

.text
_start:

# HELLO WORLD CODE:
mov $1, %rax # SPECIFY WRITING MODE
mov $1, %rdi # SPECIFY STD OUT (TERMINAL)
mov $hellowrld, %rsi # SEND DATA ADRESS
mov $len, %rdx # SPECIFY STRINGS LENGTH
syscall # CALLING THE WRITE FUNCTION

# ANOTHER WRITE CALL
mov $1, %rax
mov $1, %rdi
mov $hello2, %rsi
mov $l2, %rdx
syscall

# SAFE EXITING
mov $60, %rax
xor %rdi, %rdi
syscall
