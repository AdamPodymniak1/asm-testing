.global _start

.data
    path: .asciz "./output.txt"
    message: .asciz "Hello, this is a test write!\n"
    msg_len = . - message # Calculate length of the string automatically

.text
_start:
    # sys_open (Create and Open for Writing)
    # syscall: 2, rdi: path, rsi: flags, rdx: mode
    mov $2, %rax        
    lea path(%rip), %rdi 
    # Flags: O_WRONLY (1) | O_CREAT (64) | O_TRUNC (512) = 577
    mov $577, %rsi      
    # Mode: 0644 (Owner: read/write, Group/Others: read)
    mov $0644, %rdx     
    syscall

    # Save File Descriptor
    # The syscall returns the FD in RAX. We need it for writing and closing.
    mov %rax, %rdi      

    # sys_write
    # syscall: 1, rdi: fd, rsi: buffer, rdx: length
    mov $1, %rax        
    lea message(%rip), %rsi
    mov $msg_len, %rdx
    syscall

    # sys_close
    # syscall: 3, rdi: fd
    mov $3, %rax
    # %rdi already contains our File Descriptor
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
