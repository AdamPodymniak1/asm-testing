.global _start

.data

hellowrld: .ascii "HELLO, WORLD!"
newline: .byte 0x0A
len = . - hellowrld

.text
_start:

mov $return, %r15 # STACKING RETURN ADDRESS ON R15

jmp print # MOVE PROGRAM TO PRINT FUNCTION

return: # ADDING LABEL FOR MANUALLY CREATING CALLSTACK
 jmp exit

# PRINT FUNCTION:
print:
mov $1, %rax
mov $1, %rdi
mov $hellowrld, %rsi
mov $len, %rdx
syscall
# COULD DO jmp exit AFTER FINISHING PRINTING (rigid, not good practice). See return for better alternative
jmp *%r15 # JUMPING TO RETURN LABEL (* means indirect jump, that is to jump to what register is storing, and not to the register itself)

# EXIT FUNCTION
exit:
mov $60, %rax
xor %rdi, %rdi
syscall
