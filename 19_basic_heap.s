.global _start

.data
    buff: .byte 0xff # One byte pushes heap by 0x1000 (4096 bytes) because of alignment

.text
_start:
    mov $12, %rax # Brk(), for heap
    mov $0, %rdi # 0 to return the start and end position of Heap (at the start they are the same)
    syscall
    
    mov %rax, %r15 # Save start of heap to R15


    add $1024, %rax # Add 1024 bytes to heap
    mov %rax, %rdi # Move it to RDI, to Brk() knows where to put the end of heap
    mov $12, %rax
    syscall

    movq $0x1234, (%r15) # Move value to the start of the heap

    mov $12, %rax
    mov %r15, %rdi # Free the heap by returning to the original starting position
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
