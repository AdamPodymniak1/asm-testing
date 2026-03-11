.global _start

.data

# STRINGS TO COMPARE
str1: .asciz "Hey"
str2: .asciz "Hey, there!"

# STRING TO SAY IF STRINGS ARE THE SAME
str_match: .asciz "Strings are the same"
str_nomatch: .asciz "Strings are not the same"

newline: .byte '\n' # NEWLINE FOR PRINT_LINE

.text
_start:

# LOAD TWO ARGUMENTS
lea (str1), %rdi
lea (str2), %rsi
mov $3, %rdx
call _str_n_cmp
cmp $0, %rax # CHECK IF STRINGS WERE THE SAME
je match
jne nomatch

match:
lea (str_match), %rdi
call _print_line
jmp exit

nomatch:
lea (str_nomatch), %rdi
call _print_line
jmp exit


# FUNCTION TO COMBARE STRINGS CHAR BY CHAR (s1: rdi, s2: rsi)
_strcmp:
# LOAD SINGLE CHARACTER
mov (%rdi), %al
mov (%rsi), %dl
cmp %al, %dl # COMPARE THE TWO CHARACTERS
jne _strcmp_return # IF NOT EQUAL, RETURN
cmp $0, %al # IF NULL TERMINATOR REACHED, THEN RETURN
je _strcmp_return
# OTHERWISE MOVE TO NEXT CHARACTER AND LOOP
inc %rdi
inc %rsi
jmp _strcmp

_strcmp_return:
sub %dl, %al # IF EQUAL, THEY WILL RETURN 0
ret

# COMPARE ONLY N CHARS OF BOTH STRINGS
_str_n_cmp:
mov %rdx, %rcx
_str_n_cmp_loop:
dec %rcx # MOVE DOWN CHAR COUNTER

mov (%rdi), %al
mov (%rsi), %dl
cmp %al, %dl
jne _str_n_cmp_return
cmp $0, %al
je _str_n_cmp_return

cmp $0, %rcx # CHECK IF CHAR COUNTER IS ZERO
je _str_n_cmp_return

inc %rdi
inc %rsi
jmp _str_n_cmp_loop

_str_n_cmp_return:
sub %dl, %al
ret

# PRINT FUNCTION

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

_print_line:
push %rdi
call _str_len
pop %rdi
mov %rax, %rdx
mov %rdi, %rsi

mov $1, %rax
mov $1, %rdi
syscall

mov $1, %rax
mov $1, %rdi
lea (newline), %rsi
mov $1, %rdx

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
