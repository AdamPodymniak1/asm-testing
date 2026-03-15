.global _start

.data

.text
_start:
    # Heap is growing from bottom to top, and stack is growing from top to bottom
    sub $4, %rsp # Make space for stack to allocate memory (4 Bytes)
    movl $0x11111111, (%rsp) # Move data to the allocated memory

    # Allocating another variable
    sub $4, %rsp
    movl $0x22222222, (%rsp)

    sub $4, %rsp
    movl $0x33333333, (%rsp)

    # Add offset of 4 to talk to the first variable
    # movl $0x33333333, 4(%rsp)
    # That's how most compilers work, because they can dynamically change offset of each variable kept in data table (which is more optimized)

    # Stack frame (using RBP - Base Pointer)
    mov %rsp, %rbp

    # With base pointer changing variables is static (offset is always the same)
    movl $0x11111111, -4(%rsp)
    movl $0x22222222, -8(%rsp)
exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
