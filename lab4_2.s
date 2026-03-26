# ODCZYTYWANIE WARTOŚCI Z LUT.S (ld main.o lut.o)
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

	xor	%eax , %eax

    mov var32, %eax
    mov $str+12, %edi

    mov $4, %ecx

	call	convert

	mov	$1 , %eax
	mov	%eax , %edi
	mov	$str , %rsi
	mov	$strlen, %edx
	syscall

	mov	$60, %rax
	xor	%rdi, %rdi
	syscall

convert:
    xor %edx, %edx # Czyszczenie RDX
    mov %al,%dl # Najmłodszy byte z RAX do RDX
    mov lut(, %edx, 2), %dx # Czytanie z Look Up Table do DX
    mov %dx, (%edi, %ecx, 2)

    shr $8, %eax

    dec %ecx
    
    jnz convert

	ret
