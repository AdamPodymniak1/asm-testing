.global _start

.data

buff: .skip 128
buffsize = . - buff
tokens: .skip 128
newline: .asciz "\n"
whitespace: .asciz " "
s_nodata: .asciz "\nNo data entered!\n"
s_cmd_unsupported: .asciz "Command not supported!\n" # UNSUPPORTED COMMAND MESSAGE
s_cmd_exit: .asciz "exit" # COMMAND TO EXIT TINY SHELL
s_cmd_echo: .asciz "echo" # COMMAND TO ECHO A STRING
s_cmd_help: .asciz "help" # COMMAND TO PRINT HELP MANUAL
s_help_manual: .asciz "Available commands:\n>echo\n>exit\n>help\n"

.text
_start:

# MAIN TINY SHELL LOOP
_shell_loop:

lea (buff), %rdi
lea (buffsize), %rsi
call _read_terminal

lea (buff), %rdi
lea (tokens), %rsi
call _tokenize

lea (tokens), %rdi
mov (%rdi), %rdi
lea (s_cmd_exit), %rsi # LOAD EXIT COMMAND
call _strcmp # RETURN 0 IF COMMAND IS EXIT
je exit

lea (tokens), %rdi
mov (%rdi), %rdi
lea (s_cmd_echo), %rsi # LOAD ECHO COMMAND
call _strcmp # RETURN 0 IF COMMAND IS ECHO
je _select_echo

lea (tokens), %rdi
mov (%rdi), %rdi
lea (s_cmd_help), %rsi
call _strcmp
je _help

lea (s_cmd_unsupported), %rdi # LOAD UNSUPPORTED MESSAGE
call _print # PRINT THE MESSAGE IF USER USED UNSUPPORTED COMMAND

jmp _shell_loop

# HELP COMMAND
_help:
lea (s_help_manual), %rdi # PRINT WHITESPACE AFTER EVERY TOKEN
call _print
jmp _shell_loop

# HELPER FOR ECHO COMMAND
_select_echo:
lea (tokens + 8), %rdi
call _echo
jmp _shell_loop

# COMMAND TO ECHO A STRING
_echo:
mov %rdi, %r15
_echo_loop:
mov (%r15), %rdi
cmp $0, %rdi # CHECK IF THERE IS ANOTHER TOKEN TO PRINT
je _echo_return
call _print
lea (whitespace), %rdi # PRINT WHITESPACE AFTER EVERY TOKEN
call _print
add $8, %r15 # MOVE TO NEXT TOKEN
jmp _echo_loop

_echo_return:
lea (newline), %rdi
call _print
ret

_strcmp: # args: rdi s1, rsi s2
movb (%rdi), %al
movb (%rsi), %dl
cmp %al, %dl
jne _strcmp_return
cmp $0, %al
je _strcmp_return
inc %rdi
inc %rsi
jmp _strcmp
_strcmp_return:
movzx %al, %rax
movzx %dl, %rdx
sub %rdx, %rax
ret

_str_n_cmp: # args: rdi s1, rsi s2, rdx len
mov %rdx, %rcx
_str_n_cmp_loop:
dec %rcx

mov (%rdi), %al
mov (%rsi), %dl
cmp %al, %dl
jne _str_n_cmp_return
cmp $0, %al
je _str_n_cmp_return

cmp $0, %rcx
je _str_n_cmp_return

inc %rdi
inc %rsi
jmp _str_n_cmp_loop

_str_n_cmp_return:
sub %dl, %al
ret

_print_tokens: # args: tokens
lea (tokens), %r15

_print_tokens_loop:
mov (%r15), %rdi
cmpq $0, %rdi
je _print_tokens_return

call _print_line
add $8, %r15

jmp _print_tokens_loop

_print_tokens_return:
ret

_tokenize: # args: rdi str, rsi arr
mov %rsi, %r15

_tokenize_loop:

call _skip_whitespace
mov %rdi, (%r15)
add $8, %r15

call _find_end
cmpb $0, (%rdi)
je _tokenize_return
movb $0, (%rdi)
inc %rdi

jmp _tokenize_loop

_tokenize_return:
ret

_find_end:
cmpb $0x20, (%rdi)
je _find_end_ret
cmpb $0x0a, (%rdi)
je _find_end_ret
cmpb $0, (%rdi)
je _find_end_ret
inc %rdi
jmp _find_end
_find_end_ret:
ret

_skip_whitespace:
cmpb $0x20, (%rdi)
je _skip_whitespace_advance
ret

_skip_whitespace_advance:
inc %rdi
jmp _skip_whitespace

_read_terminal: # args: rdi buff, rsi buffsize
mov %rdi, %rsi
mov %rsi, %rdx
xor %rdi, %rdi
xor %rax, %rax
syscall
ret

_print: # args: rdi str
push %rdi
call _str_len
pop %rdi
mov %rax, %rdx
mov %rdi, %rsi

mov $1, %rax
mov $1, %rdi
syscall
ret

_print_line: # args: rdi str
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
