.global _start

.data

s1: .asciz "First!\n"
s2: .asciz "Second!\n"
s3: .asciz "Third!\n"

.text
_start:

lea (s1), %rdi # LOAD FIRST CHAR OF STRING_1 TO RDI
call _print

lea (s2), %rdi # LOAD FIRST CHAR OF STRING_2 TO RDI
call _print

lea (s3), %rdi # LOAD FIRST CHAR OF STRING_3 TO RDI
call _print

jmp exit

_print:
push %rdi # SAVE RDI ON THE STACK, SO WE KNOW THAT THE STR_LEN FUNCTION WON'T DESTROY IT (good practice)
call _str_len # CALL STR_LEN FUNCTION TO DYNAMICALLY FIND STRINGS LENGTH
pop %rdi # POP THE RDI BACK FROM THE STACK
mov %rax, %rdx # MOVE RAX TO RDX TO SET THE LENGTH OF STRING
mov %rdi, %rsi # MOVE RDI TO RSI BEFORE CHANGINT RDI TO 1

mov $1, %rax
mov $1, %rdi
syscall
ret

# USING BASIC_STR_LEN
_str_len:
mov %rdi, %rax # MOVE THE FIRST CHAR OF STRING FROM RDI TO RAX
xor %rcx, %rcx

loop:
mov (%rax), %bl
cmp $0, %bl
je _str_len_exit
inc %rcx
inc %rax
jmp loop

# MOVE THE STRING LENGTH VALUE TO RAX AND RETURN
_str_len_exit:
mov %rcx, %rax
ret

exit:
mov $60, %rax
xor %rsi, %rsi
syscall
