.global _start

.data

s1: .asciz "Testing\n"

.text
_start:

exit:
mov $60, %rax
xor %rsi, %rsi
syscall
