.global _start

.data
    x: .float 3.14 # Floating point numbers (32 bit)
    y: .float 2.1
    z: .float 2.1

.text
_start:
    # Registers xmm0 - xmm15 are designed for storing floating points
    movss (x), %xmm0 # ss - scalar single-precision (32 bit)
    movss (y), %xmm1
    movss (z), %xmm2
    ucomiss %xmm1, %xmm0 # compare floating point values
    ja greater
    jmp exit
    addss %xmm1, %xmm0 # Adding two floating point numbers together

greater:
    mov $4, %rbx

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
