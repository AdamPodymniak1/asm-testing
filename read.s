.global _start

.data

buff: .skip 4096 # BUFFER TO STORE DATA (4096 is standard size)

.text
_start:

call _read_terminal
mov %rax, %rdi
call _print
jmp exit

# READING FROM TERMINAL
_read_terminal:
mov $0, %rax # READ CALL
mov $0, %rdi # 0 = STD INPUT
lea (buff), %rsi # COPY BUFFER ADRESS TO RSI
mov $4096, %rdx # TELL THE PROGRAM HOW MUCH DATA YOU CAN MAXIMALLY TAKE (buffer size)
syscall
mov %rsi, %rax
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
