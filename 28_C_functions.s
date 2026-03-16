.extern printf
.extern exit
.global main

.data
    msg1: .asciz "Hello"
    msg2: .asciz "test!"
    fmt: .asciz "The msg is: %s %s\n"

.text
main:
    # Load addresses into registers (V-ABI convencion applies)
    mov $fmt, %rdi
    mov $msg1, %rsi
    mov $msg2, %rdx
    
    # Clear RAX (variadic printf requires number of vector regs)
    xor %rax, %rax
    
    call printf
    
    mov $0, %rdi
    call exit

# Section because of linker errors
.section .note.GNU-stack,"",@progbits
