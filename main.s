.global _start

.data

s1: .asciz "Testing\n"
s_len = . - s1

.text
_start:

print:
mov $1, %rax
mov $1, %rdi
lea s1, %rsi
mov $s_len, %rdx
syscall

exit:
mov $60, %rax
xor %rsi, %rsi
syscall
