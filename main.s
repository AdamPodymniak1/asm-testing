.extern printf
.extern exit
.global main

.data
    msg: .asciz "Hello world!"
    fmt: .asciz "The msg is: %s\n"

.text
main:
    # 16-byte stack alignment
    subq $8, %rsp
    
    # Load addresses into registers
    lea fmt(%rip), %rdi
    lea msg(%rip), %rsi
    
    # Clear RAX (variadic printf requires number of vector regs)
    xor %rax, %rax
    
    call printf
    
    # Restore stack and exit
    add $8, %rsp
    mov $0, %rdi
    call exit

# Section because of linker errors
.section .note.GNU-stack,"",@progbits
