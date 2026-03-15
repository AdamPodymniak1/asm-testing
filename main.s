.global _start

.data

.text
_start:
    mov $12, %rax # Brk(), for heap
    mov $0, %rdi # 0 to return the start and end position of Heap (at the start they are the same)
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall