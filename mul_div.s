.global _start

.data

s1: .asciz "Testing\n"

.text
_start:

# MULTIPLYING
mov $2, %rax
mov $3, %rdx
mov $4, %rbx
mul %rdx # RETURNS RAX * RDX (2*3), BECAUSE RAX MUST ALWAYS BE THE FIRST VALUE FOR MULTIPLYING
imul %rdx # CAN MULTIPLY BY NEGATIVE NUMBERS (overflow moves to RDX)
imul %rdx, %rbx # CAN TAKE TWO VALUES. Alternative: imul $7, %rbx, or imul $0x7, %rdx

# DIVIDING
xor %rdx, %rdx # ZERO OUT RDX, BECAUSE DIVISION ALSO OVERFLOWS TO RDX
mov $6, %rax
mov $3, %rbx
div %rbx # DIVISION ALSO TAKES RAX AS FIRST VALUE

mov $6, %rax
mov $4, %rbx
div %rbx # IF IT DIVIDES WITH SOMETHING IT CAN'T, THE MODULO WILL BE STORED IN RDX (rax = 1, rdx=2)

xor %rdx, %rdx # ZEROING OUT THE RDX AS BEFORE
mov $-7, %rax
mov $4, %rbx
cqo # Convert Quadwords to Octoquadwords (64 to 128). MAKES IT SO RDX IS ALWAYS SET TO REPRESENT THE CORRECT NEGATIVE VALUE
idiv %rbx # CAN USE NEGATIVE NUMBERS (rax=-1, rdx=-3)

exit:
mov $60, %rax
xor %rsi, %rsi
syscall
