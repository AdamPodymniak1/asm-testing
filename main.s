# KOD Z LAB_3 CZĘŚĆ DALSZA
.globl _start

.data

var8:	.byte	237
var16:	.word	57005
var32:	.long	4276994270
var64:	.quad	13464654573299691533

str:	.ascii	"val = ................h\n"
.equ	strlen, . - str

.text

_start:

	xor	%rax , %rax

    mov var64, %rax
    mov $str+4, %rdi # Przesunięcie wskaźnika z 20 do 4 (20-2*8=4)

    mov $8, %rcx

	call	convert

	mov	$1 , %rax
	mov	%rax , %rdi
	mov	$str , %rsi
	mov	$strlen, %rdx
	syscall

	mov	$60, %rax
	xor	%rdi, %rdi
	syscall

convert:
    mov %rax, %rdx

	call convert_byte
    // Zapisuje do rdi+rcx*2
    mov %ax, (%rdi, %rcx, 2) # stala(%rej1, %rej2, skalar)

    mov %rdx, %rax
    shr $8, %rax

    dec %rcx

    cmp $0, %rcx
    jnz convert

	ret

convert_byte:
    mov %al, %bl

    and $0x0F, %al
	call convert_nibble
    mov %al, %ah

    mov %bl, %al
    shr $4, %al
    call convert_nibble

	ret

convert_nibble:
    cmp $10, %al
    jae cn_else
    add $48, %al
    ret

cn_else:
    add $55, %al
    ret
