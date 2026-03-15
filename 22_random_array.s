.global _start

.data
# The Array: 100 elements, 8 bytes each (800 bytes total)
.align 8
my_array: .skip 800
array_size = 100

# Formatting
dec_buf: .skip 32
space: .asciz " "
newline: .asciz "\n"

.text
_start:
    # Fill the array with random values (1-100)
    xor %r12, %r12 # Loop counter (index)
_fill_loop:
    cmp $array_size, %r12
    je _fill_done

    # Get random number
    call _get_one_rand # Returns random 1-100 in RAX
    
    # Store in array: my_array + (index * 8)
    mov %rax, my_array(,%r12, 8)

    inc %r12
    jmp _fill_loop

_fill_done:
    # Print the array to verify
    call _print_array

    # Exit
    lea newline, %rdi
    call _print
    jmp exit

# GET RANDOM FUNCTION
_getrandom:
    mov $318, %rax # getrandom syscall (x86-64 Linux)
    syscall
    ret

# RANDOM RANGE HELPER (1-100)
_get_one_rand:
    sub $8, %rsp # Create space on stack for getrandom
    mov %rsp, %rdi # Buffer is the stack address
    mov $8, %rsi # 8 bytes
    xor %rdx, %rdx
    call _getrandom

    pop %rax # Load the random bytes into RAX
    mov $100, %rbx
    xor %rdx, %rdx
    div %rbx # RDX = random % 100
    add $1, %rdx # RDX = 1 to 100
    mov %rdx, %rax
    ret

# ARRAY PRINTER
_print_array:
    xor %r12, %r12
_p_loop:
    cmp $array_size, %r12
    je _p_done

    # Load value and convert
    mov my_array(,%r12, 8), %rax
    lea dec_buf, %rdi
    call _u64_to_dec # Returns start of string in RAX

    # Print number
    mov %rax, %rdi
    call _print

    # Print space
    lea space, %rdi
    call _print

    inc %r12
    jmp _p_loop
_p_done:
    ret

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
