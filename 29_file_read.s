.global _start

.data
    path: .asciz "./test.txt" # path to file

.bss # for storing static data without initializing them
    buff: .space 1024 # reserving 1024 bytes for read text

.text
_start:
    mov $2, %rax # sys_open for reading files
    lea (path), %rdi
    mov $0, %rsi
    syscall

    mov %rax, %rdi # save address from sys_open to RDI
    mov $0, %rax # sys_read
    lea (buff), %rsi # Pointer to buffer
    mov $1024, %rdx # Max bytes to read
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
