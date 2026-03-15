.global _start

.data
rand_buf: .quad 0
dec_buf: .skip 32
newline: .asciz "\n"

.text
_start:
    # Get a random 64-bit number from the kernel
    lea rand_buf, %rdi
    mov $8, %rsi
    xor %rdx, %rdx
    call _getrandom

    # Set the range (1-100)
    mov rand_buf, %rax # Get random number
    mov $100, %rbx # The range size (divisor)
    xor %rdx, %rdx # Clear RDX before DIV
    div %rbx # RAX = quotient, RDX = remainder (0-99)
    
    add $1, %rdx # Offset (1)

    mov %rdx, %rax # move result to RAX for converter
    
    # Convert raw value to a decimal string
    lea dec_buf, %rdi
    call _u64_to_dec
    
    # Print the resulting decimal string
    mov %rax, %rdi
    call _print
    
    lea newline, %rdi
    call _print

    jmp exit

# DECIMAL CONVERSION
_u64_to_dec: 
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
    ret

# GET RANDOM SYSCALL
_getrandom:
    mov $318, %rax # getrandom syscall (x86-64 Linux)
    syscall
    ret

# HELPERS
_print:
    push %rdi
    call _str_len
    pop %rsi
    mov %rax, %rdx
    mov $1, %rax
    mov $1, %rdi
    syscall
    ret

_str_len:
    xor %rax, %rax
_len_loop:
    cmpb $0, (%rdi, %rax)
    je _len_exit
    inc %rax
    jmp _len_loop
_len_exit:
    ret

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
