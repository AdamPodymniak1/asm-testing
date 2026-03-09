.global _start

.data

buff: .skip 1024 # SKIP ALLOCATES MEMORY AND INITIALIZES IT WITH ZERO

.text
_start:

mov $123, %rdi # NUMBER TO PRINT
lea (buff + 32), %rsi
call _itoa
mov %rax, %rdi
call _print

mov $123, %rdi # NUMBER TO PRINT
lea (buff + 32), %rsi
call _itob
mov %rax, %rdi
call _print

# EXITS
jmp exit

# INTEGER TO ASCII
_itoa:
mov $10, %rbx # SET DIVIDER TO 10
mov %rdi, %rax # FOR CONVENCION
lea (%rsi), %rdi # ADD OFFSET TO THE BUFFER TO MOVE BACKWARDS IN IT (Offset set as an argument in RSI registry)
movb $0, (%rdi) # ADD LINEBREAK BEFORE NULL TERMINATOR
dec %rdi
movb $'\n', (%rdi) # SET THE LAST CAHRACTER TO NULL TERMINATOR (movb to specify the size of the null terminator (one byte))

_itoa_loop:
xor %rdx, %rdx # ZERO OUT RDX REGISTER BEFORE DIVIDING
dec %rdi # MOVE THE POINTER IN BUFFER TO CHANGE TO THE NEXT CHARACTER SPACE
div %rbx # NOW RAX HAS THE DIVIDED VALUE AND RDX THE MODULO
add $'0', %rdx # MAKE IT A VALID NUMBER ASCII CHARACTER
mov %dl, (%rdi) # ADD IT TO BUFFER. Alternative: mov %dl, (%rdi)
cmp $0, %rax # CHECKS IF RAX IS ZERO TO EXIT LOOP
jne _itoa_loop
mov %rdi, %rax # MOVE THE FULL VALUE OF RDI TO RAX
ret

# INTEGER TO BINARY
_itob:
mov $2, %rbx # CHANGED DIVISOR FROM 10 TO 2
mov %rdi, %rax
lea (%rsi), %rdi
movb $0, (%rdi)
dec %rdi
movb $'\n', (%rdi)

_itob_loop:
xor %rdx, %rdx
dec %rdi
div %rbx
add $'0', %rdx
mov %dl, (%rdi)
cmp $0, %rax
jne _itob_loop
mov %rdi, %rax
ret

_print:
push %rdi
call _str_len
pop %rdi
mov %rax, %rdx
mov %rdi, %rsi

mov $1, %rax
mov $1, %rdi
syscall
ret

_str_len:
mov %rdi, %rax
xor %rcx, %rcx

_str_len_loop:
mov (%rax), %bl
cmp $0, %bl
je _str_len_exit
inc %rcx
inc %rax
jmp _str_len_loop

_str_len_exit:
mov %rcx, %rax
ret

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
