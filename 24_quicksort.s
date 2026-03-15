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
orig_msg: .asciz "Original Array:\n"
sort_msg: .asciz "\nSorted Array:\n"

.text
_start:
    # Fill the array
    xor %r12, %r12
_fill_loop:
    cmp $array_size, %r12
    je _fill_done
    call _get_one_rand 
    mov %rax, my_array(,%r12, 8)
    inc %r12
    jmp _fill_loop

_fill_done:
    # Print Original
    lea orig_msg, %rdi
    call _print
    call _print_array

    # Call Quicksort
    # RDI = array address, RSI = low index (0), RDX = high index (size - 1)
    lea my_array, %rdi
    xor %rsi, %rsi
    mov $array_size, %rdx
    dec %rdx # High index is 99
    call _quicksort

    # Print Sorted
    lea sort_msg, %rdi
    call _print
    call _print_array

    # Exit
    jmp exit

# QUICKSORT LOGIC

_quicksort:
    # Check if low < high
    cmp %rdx, %rsi
    jge _qs_exit

    # Save registers before recursion
    push %rdi
    push %rsi
    push %rdx

    # Partition the array
    call _partition # Returns pivot index in RAX
    
    # Save pivot index
    mov %rax, %rcx          
    
    # Setup for Left Side: quicksort(arr, low, pivot - 1)
    pop %rdx # Original high
    pop %rsi # Original low
    pop %rdi # Array base
    
    push %rdi
    push %rsi
    push %rdx
    push %rcx # Save pivot for right side call

    mov %rcx, %rdx
    dec %rdx # high = pivot - 1
    call _quicksort

    # Setup for Right Side: quicksort(arr, pivot + 1, high)
    pop %rcx # Restore pivot
    pop %rdx # Restore original high
    pop %rsi # Restore original low (not used, but for stack balance)
    pop %rdi # Restore array base

    mov %rcx, %rsi
    inc %rsi # low = pivot + 1
    call _quicksort

_qs_exit:
    ret

_partition:
    # RDI: arr, RSI: low, RDX: high
    # Pivot = arr[high]
    mov (%rdi, %rdx, 8), %r10 # %r10 is the pivot value
    
    # i = low - 1
    mov %rsi, %r8
    dec %r8 # %r8 is i

    # j = low
    mov %rsi, %r9 # %r9 is j

_part_loop:
    cmp %rdx, %r9
    jge _part_done

    # if arr[j] <= pivot
    mov (%rdi, %r9, 8), %r11
    cmp %r10, %r11
    jg _next_j

    # inc i, swap arr[i] and arr[j]
    inc %r8
    mov (%rdi, %r8, 8), %rax
    mov %r11, (%rdi, %r8, 8)
    mov %rax, (%rdi, %r9, 8)

_next_j:
    inc %r9
    jmp _part_loop

_part_done:
    # swap arr[i+1] and arr[high]
    inc %r8
    mov (%rdi, %r8, 8), %rax
    mov %r10, (%rdi, %r8, 8)
    mov %rax, (%rdi, %rdx, 8)
    
    mov %r8, %rax # return i + 1
    ret

# HELPERS

_get_one_rand:
    sub $8, %rsp
    mov %rsp, %rdi
    mov $8, %rsi
    xor %rdx, %rdx
    mov $318, %rax # getrandom
    syscall
    pop %rax
    mov $100, %rbx
    xor %rdx, %rdx
    div %rbx
    add $1, %rdx
    mov %rdx, %rax
    ret

_print_array:
    push %r12
    xor %r12, %r12
_p_loop:
    cmp $array_size, %r12
    je _p_done
    mov my_array(,%r12, 8), %rax
    lea dec_buf, %rdi
    call _u64_to_dec
    mov %rax, %rdi
    call _print
    lea space, %rdi
    call _print
    inc %r12
    jmp _p_loop
_p_done:
    pop %r12
    ret

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

exit:
    lea newline, %rdi
    call _print
    mov $60, %rax
    xor %rdi, %rdi
    syscall
