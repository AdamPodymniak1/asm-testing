.global _start

.data

str1: .ascii "First!\0" # NULL TERMINATOR (to show where the string ends)
str2: .asciz "Second!" # ASCIZ AUTOMATICALLY ADDS \0 AT THE END
str3: .string "Third!" # DOES THE SAME THING AS ASCIZ
char_out: .byte 0, 10 # SPACE FOR ONE CHAR AND NEWLINE

.text
_start:
lea str2, %rax # GET DATA ADRESS (mov copies the content, lea copies the adress)
xor %rcx, %rcx # SET RCX TO 0

loop:
mov (%rax), %bl # GET ONLY THE FIRST BYTE OF DATA
cmp $0, %bl
je print # PRINT SIZE IF NULL TERMINATOR
inc %rcx # INCREASE STR_LEN
inc %rax # GO TO NEXT BYTE (letter)
jmp loop

print:
add $48, %rcx # ADD 48 TO MAKE IT THE ASCII VALUE (0-9, higher numbers don't work)
mov %cl, char_out # MOVE LOW MEMORY OF RCX TO CHAR_OUT (to set str size to print)
# PRINTING LOGIC
mov $1, %rax
mov $1, %rdi
mov $char_out, %rsi
mov $2, %rdx
syscall

exit:
mov $60, %rax
xor %rsi, %rsi
syscall
