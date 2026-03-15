.global _start

.data
dec_buf: .skip 32
newline: .asciz "\n"
msg:     .asciz "Factorial of 5 is: "

.text
_start:
    # Print the prefix message
    lea msg, %rdi
    call _print

    # Setup for recursion: Calculate 5!
    mov $5, %rdi
    call _factorial

    # RAX now contains the result (120)
    # Convert and print
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

# RECURSIVE FUNCTION
# Input: RDI = n
# Output: RAX = result
_factorial:
    # Base Case: If n <= 1, return 1
    cmp $1, %rdi
    jle _fact_base_case

    # Recursive Step:
    # We need to calculate n * factorial(n - 1)
    
    push %rdi # SAVE current n on the stack
    dec %rdi # Decrement n for the next call (n - 1)
    call _factorial # RECURSE: RAX = factorial(n - 1)
    
    pop %rdi # RESTORE the original n from the stack
    imul %rdi, %rax # Multiply: RAX = n * RAX
    ret

_fact_base_case:
    mov $1, %rax # Return 1
    ret

# HELPERS
_u64_to_dec: 
    push %rbx
    add $31, %rdi
    movb $0, (%rdi)
    mov $10, %rbx
_dec_loop:
    dec %rdi
    xor %rdx, %rdx
    div %rbx
    add $'0', %dl
    movb %dl, (%rdi)
    test %rax, %rax
    jnz _dec_loop
    mov %rdi, %rax
    pop %rbx
    ret

_print:
    push %rdi
    xor %rax, %rax
_loop:
    cmpb $0, (%rdi, %rax)
    je _exit
    inc %rax
    jmp _loop
_exit: mov %rax, %rdx
    pop %rsi
    mov $1, %rax
    mov $1, %rdi
    syscall
    ret
