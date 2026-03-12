# LAB 2_2, PĘTLA DO WHILE

.globl _start

.equ	sys_write,	1
.equ	sys_exit,	60
.equ	stdout,		1
.equ	strlen, 	new_line + 1 - str

.data

counter:	.byte	42
str:		.ascii	"iteracja nr: x"
new_line:	.byte	0x0A

.text

_start:

movb $0, %bl

petla_for:

mov %bl, %al
add	$48 , %al
mov	%al , new_line - 1

mov	$sys_write , %eax
mov	$stdout , %edi
mov	$str , %esi
mov	$strlen , %edx
syscall

incb %bl

# PĘTLA DO WHILE, CZYLI SPRAWDZANIE NA KOŃCU
cmpb counter, %bl
jbe	petla_for

koniec_for:

mov	$sys_exit , %eax
xor	%edi , %edi
syscall
