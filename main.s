.global _start

.data
    x: .float 3.14 # Floating point numbers (32 bit)
    y: .float 2.1

.text
_start:
    # Registers xmm0 - xmm15 are designed for storing floating points
    movss (x), %xmm0 # ss - scalar single-precision (32 bit)
exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
