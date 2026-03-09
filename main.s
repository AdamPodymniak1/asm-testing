.global _start

.data
str1: .ascii "Printing\n"
s1_len = . - str1

.text
_start:
    mov $0, %rbx

loop:
    # WAYS TO COMPARE
    # 1. Register vs Constant: cmp $3, %rbx
    # 2. Register vs Register: cmp %rcx, %rbx
    # 3. Register vs Memory:   cmp count_limit(%rip), %rbx
    
    cmp $3, %rbx
    
    # CONDITIONAL JUMPS (Check EFLAGS register)
    # jge = Greater or Equal (Signed)
    # jae = Above or Equal   (Unsigned - use for addresses)
    # jle = Less or Equal
    # je  = Equal / jne = Not Equal
    # jb  = Below / jbe = Below or Equal
    
    jge exit

    call print

    inc %rbx
    jmp loop

print:
    mov $1, %rax
    mov $1, %rdi
    mov $str1, %rsi
    mov $s1_len, %rdx
    syscall
    
    ret

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
