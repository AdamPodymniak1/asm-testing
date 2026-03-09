.global _start

.data

str1: .ascii "Printing"
new_lime: .byte 0x0A
s1_len = . - str1

.text
_start:

mov $0, %rbx

loop:
cmp $3, %rbx # COMPARE TWO VALUES
jge exit # JUMP if GREATER OR EQUAL (je - JUMP if EQUAL, jne = JUMP if NOT EQUAL)
call print
inc %rbx # INCREMENT RAX. Alternative: add $1, %rax
jmp loop # CREATED LOOP

print:
mov $1, %rax
mov $1, %rdi
mov $str1, %rsi
mov $s1_len, %rdx
syscall
ret

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
