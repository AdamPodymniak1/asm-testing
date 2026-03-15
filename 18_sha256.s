.global _start

.data
# SHA-256 Constants (K)
k_table:
.long 0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5
.long 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174
.long 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da
.long 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967
.long 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85
.long 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070
.long 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3
.long 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2

# Initial Hash Values (H)
h_init:
.long 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19

# Buffers
buff:       .skip 128
w_schedule: .skip 256
h_state:    .skip 32
hex_out:    .skip 65
newline:    .asciz "\n"
hex_chars:  .asciz "0123456789abcdef"

.text
_start:
    # Read input
    lea buff, %rdi
    mov $128, %rsi
    call _read_terminal
    
    # Clean input
    lea buff, %rdi
    call _strip_newline
    mov %rax, %r12 # r12 = string length

    # Padding (Single 512-bit block logic)
    lea buff, %rdi
    add %r12, %rdi
    movb $0x80, (%rdi) # Append 1 bit
    
    mov %r12, %rcx
    add $1, %rcx
_pad_zero_loop:
    cmp $56, %rcx
    jge _pad_len
    inc %rdi
    movb $0, (%rdi)
    inc %rcx
    jmp _pad_zero_loop

_pad_len:
    mov %r12, %rax
    shl $3, %rax # length in bits
    bswap %rax # Big Endian
    mov %rax, buff+56

    # Init State
    lea h_init, %rsi
    lea h_state, %rdi
    mov $8, %rcx
    rep movsl

    # Message Schedule (W)
    xor %rcx, %rcx
_w_init_loop:
    mov buff(,%rcx, 4), %eax
    bswap %eax
    mov %eax, w_schedule(,%rcx, 4)
    inc %rcx
    cmp $16, %rcx
    jl _w_init_loop

_w_extend_loop:
    # s0 = (w[i-15] ror 7) ^ (w[i-15] ror 18) ^ (w[i-15] >> 3)
    mov w_schedule-60(,%rcx, 4), %eax
    mov %eax, %edx
    ror $7, %eax
    mov %edx, %ebx
    ror $18, %ebx
    xor %ebx, %eax
    shr $3, %edx
    xor %edx, %eax
    mov %eax, %r8d

    # s1 = (w[i-2] ror 17) ^ (w[i-2] ror 19) ^ (w[i-2] >> 10)
    mov w_schedule-8(,%rcx, 4), %eax
    mov %eax, %edx
    ror $17, %eax
    mov %edx, %ebx
    ror $19, %ebx
    xor %ebx, %eax
    shr $10, %edx
    xor %edx, %eax

    add w_schedule-64(,%rcx, 4), %eax
    add %r8d, %eax
    add w_schedule-28(,%rcx, 4), %eax
    mov %eax, w_schedule(,%rcx, 4)
    inc %rcx
    cmp $64, %rcx
    jl _w_extend_loop

    # Compression
    lea h_state, %rsi
    mov 0(%rsi), %r8d # a
    mov 4(%rsi), %r9d # b
    mov 8(%rsi), %r10d # c
    mov 12(%rsi), %r11d # d
    mov 16(%rsi), %r12d # e
    mov 20(%rsi), %r13d # f
    mov 24(%rsi), %r14d # g
    mov 28(%rsi), %r15d # h

    xor %rcx, %rcx
_compress_loop:
    # S1
    mov %r12d, %eax
    ror $6, %eax
    mov %r12d, %ebx
    ror $11, %ebx
    xor %ebx, %eax
    mov %r12d, %ebx
    ror $25, %ebx
    xor %ebx, %eax
    mov %eax, %ebp

    # ch
    mov %r12d, %eax
    and %r13d, %eax
    mov %r12d, %ebx
    not %ebx
    and %r14d, %ebx
    xor %ebx, %eax

    add %r15d, %eax
    add %ebp, %eax
    add k_table(,%rcx, 4), %eax
    add w_schedule(,%rcx, 4), %eax # eax = temp1

    # S0
    mov %r8d, %edx
    ror $2, %edx
    mov %r8d, %ebx
    ror $13, %ebx
    xor %ebx, %edx
    mov %r8d, %ebx
    ror $22, %ebx
    xor %ebx, %edx

    # maj
    mov %r8d, %ebx
    and %r9d, %ebx
    mov %r8d, %edi
    and %r10d, %edi
    xor %edi, %ebx
    mov %r9d, %edi
    and %r10d, %edi
    xor %edi, %ebx
    add %edx, %ebx # ebx = temp2

    # Shift
    mov %r14d, %r15d
    mov %r13d, %r14d
    mov %r12d, %r13d
    mov %r11d, %r12d
    add %eax, %r12d
    mov %r10d, %r11d
    mov %r9d, %r10d
    mov %r8d, %r9d
    add %ebx, %eax
    mov %eax, %r8d

    inc %rcx
    cmp $64, %rcx
    jl _compress_loop

    # Update State
    lea h_state, %rsi
    add %r8d, 0(%rsi)
    add %r9d, 4(%rsi)
    add %r10d, 8(%rsi)
    add %r11d, 12(%rsi)
    add %r12d, 16(%rsi)
    add %r13d, 20(%rsi)
    add %r14d, 24(%rsi)
    add %r15d, 28(%rsi)

    # Hex conversion
    lea h_state, %rsi
    lea hex_out, %rdi
    mov $8, %rcx
_hex_loop:
    push %rcx
    mov (%rsi), %eax
    # bswap %eax
    call _u32_to_hex
    add $4, %rsi
    pop %rcx
    loop _hex_loop

    # Final output
    lea hex_out, %rdi
    call _print
    lea newline, %rdi
    call _print
    jmp exit

# HELPERS

_u32_to_hex:
    mov %eax, %edx
    mov $8, %r8
_u32_inner:
    rol $4, %edx
    mov %edx, %ebx
    and $0xF, %ebx
    movb hex_chars(%rbx), %al
    movb %al, (%rdi)
    inc %rdi
    dec %r8
    jnz _u32_inner
    ret

_strip_newline:
    xor %rax, %rax
_sn_loop:
    movb (%rdi, %rax), %cl
    cmp $0x0A, %cl
    je _sn_term
    cmp $0, %cl
    je _sn_exit
    inc %rax
    jmp _sn_loop
_sn_term:
    movb $0, (%rdi, %rax)
_sn_exit:
    ret

_read_terminal:
    mov %rsi, %rdx
    mov %rdi, %rsi
    xor %rdi, %rdi
    xor %rax, %rax
    syscall
    ret

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
