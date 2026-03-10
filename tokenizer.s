.global _start

.data

buff: .skip 128 # BUFFER FOR TOKENIZER
buffsize = . - buff # DYNAMIC BUFFER SIZE CALCULATION
tokens: .skip 128 # TOKENIZER ARRAY
newline: .byte '\n' # NEWLINE FOR PRINT_LINE

.text
_start:

lea (buff), %rdi # SET READ BUFFER
mov $buffsize, %rsi # SET REAF BUFFER SIZE
dec %rsi
call _read_terminal # READ FROM TERMINAL

lea (buff), %rdi
movb $0, (%rdi, %rax) # SET NULL TERMINATOR AT THE END OF THE READ STRING

lea (buff), %rdi # TOKENIZER FIRST ARGUMENT (Ptr to buffer)
lea (tokens), %rsi # TOKENIZER SECOND ARGUMENT (Ptr to tokens)
call _tokenize # TOKENIZE THE READ STRING

mov $tokens, %rdi # READ FIRST ARG FROM TOKENIZER
mov (%rdi), %rdi
call _print_tokens # PRINT TOKENS
jmp exit # EXIT

# FUNCTION TO PRINT TOKENS
_print_tokens:
lea (tokens), %r15

_print_tokens_loop:
mov (%r15), %rdi # MOVE FULL TOKEN TO RDI
cmpq $0, %rdi
je _print_tokens_return # IF TOKEN IS EQUAL TO ZERO, END PRINTING

call _print_line # PRINT TOKEN
add $8, %r15 # MOVE TO NEXT POTENCIAL TOKEN

jmp _print_tokens_loop

_print_tokens_return:
ret

# TOKENIZER FUNCTION
_tokenize:
mov %rsi, %r15 # COPY RSI TO R15 TO NEVER LOSE IT

# MAIN TOKENIZER LOOP
_tokenize_loop:

call _skip_whitespace # SKIP ANY WHITESPACES AT THE BEGINNING TO NOT CAUSE ANY ERRORS
mov %rdi, (%r15)
add $8, %r15

call _find_end # CALL FIND_END TO FIND SPACEBARS
cmpb $0, (%rdi) # CHECK IF FUNCTION RETURNED NULL TERMINATOR
je _tokenize_return # IF YES, RETURN
movb $0, (%rdi) # PUT NULL TERMINATOR IN PLACE OF SPACE
inc %rdi # INCREMENT AFTER CHANGIND CURRENT TO NULL TERMINATOR

jmp _tokenize_loop

_tokenize_return:
ret

_find_end:

cmpb $0x20, (%rdi) # CHECK IF WHITESPACE
je _find_end_ret # IF YES, RETURN

cmpb $0, (%rdi) # CHECK IF NULL TERMINATOR
je _find_end_ret # IF YES, RETURN

inc %rdi # SEARCH FURTHER
jmp _find_end

_find_end_ret:
ret

_skip_whitespace:
cmpb $0x20, (%rdi) # CHECK IF WHITESPACE
je _skip_whitespace_advance # IF YES, SKIP TO NEXT CHARACTER TO AVOID ERRORS CAUSED BY TOO MUCH WHITESPACES
ret # IF NOT, RETURN

_skip_whitespace_advance:
inc %rdi
jmp _skip_whitespace

_read_terminal:
mov %rdi, %rsi
mov %rsi, %rdx
xor %rdi, %rdi
xor %rax, %rax
syscall
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

# PRINT AND ADD NEWLINE
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
