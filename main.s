.global _start

.data

.text
_start:

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
