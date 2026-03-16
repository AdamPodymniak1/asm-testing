.global _start

.data
    # IEEE-754 Double Precision (8 bytes)
    num1:   .double 10.5
    num2:   .double 20.25
    result: .double 0.0

    # For output
    msg:    .asciz "10.5 + 20.25 as an integer is: "
    newline: .asciz "\n"
    dec_buf: .skip 32

.text
_start:
    # Load floating point numbers into XMM registers
    movsd num1(%rip), %xmm0    # movsd = Move Scalar Double
    movsd num2(%rip), %xmm1

    # Perform addition
    addsd %xmm1, %xmm0         # xmm0 = xmm0 + xmm1 (30.75)
    
    # Store the result back to memory
    movsd %xmm0, result(%rip)

    # Demonstrate conversion (Float to Integer)
    # cvttsd2si = Convert with Truncation Scalar Double to Signed Integer
    cvttsd2si %xmm0, %rax # RAX will now be 30 (fractional part is dropped)

    # Print the integer part to verify
    push %rax
    lea msg, %rdi
    call _print
    pop %rax

    lea dec_buf, %rdi
    call _u64_to_dec
    mov %rax, %rdi
    call _print

    lea newline, %rdi
    call _print

    # Exit
    mov $60, %rax
    xor %rdi, %rdi
    syscall

# HELPERS
_u64_to_dec:
    add $31, %rdi
    movb $0, (%rdi)
    mov $10, %rbx
_d_loop:
    dec %rdi
    xor %rdx, %rdx
    div %rbx
    add $'0', %dl
    movb %dl, (%rdi)
    test %rax, %rax
    jnz _d_loop
    mov %rdi, %rax
    ret

_print:
    push %rdi
    xor %rax, %rax
_loop:
    cmpb $0, (%rdi, %rax)
    je _exit
    inc %rax
    jmp _loop
_exit:
    mov %rax, %rdx
    pop %rsi
    mov $1, %rax
    mov $1, %rdi
    syscall
    ret
