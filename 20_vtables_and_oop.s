.global _start

.data
# VTABLES
# Each table contains the address of the functions for that "Class"
vtable_square:
    .quad _draw_square
    .quad _area_square

vtable_circle:
    .quad _draw_circle
    .quad _area_circle

# OBJECTS
# An "Instance" is just memory. The first 8 bytes is the VTable Pointer (vptr).
obj_square_1:
    .quad vtable_square # vptr pointing to Square's logic
    .quad 10 # Data: side length

obj_circle_1:
    .quad vtable_circle # vptr pointing to Circle's logic
    .quad 7 # Data: radius

# Strings for output
s_sq_draw:  .asciz "Drawing a Square\n"
s_ci_draw:  .asciz "Drawing a Circle\n"

.text
_start:
    # DYNAMIC DISPATCH
    
    # Point RSI to our Square object
    lea obj_square_1, %rsi
    call _do_draw # This will draw a square

    # Point RSI to our Circle object
    lea obj_circle_1, %rsi
    call _do_draw # This will draw a circle

    jmp exit

# THE POLYMORPHIC CALLER
# This function doesn't know what it's drawing
# It just knows: object address is in RSI
_do_draw:
    mov (%rsi), %rax # 1. Get the vptr (address of the vtable)
    mov (%rax), %rax # 2. Get the 1st entry in vtable (the 'draw' function)
    jmp *%rax # 3. Jump to that address!

# SQUARE METHODS
_draw_square:
    lea s_sq_draw, %rdi
    call _print
    ret

_area_square:
    # logic would go here...
    ret

# CIRCLE METHODS
_draw_circle:
    lea s_ci_draw, %rdi
    call _print
    ret

_area_circle:
    # logic would go here...
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
