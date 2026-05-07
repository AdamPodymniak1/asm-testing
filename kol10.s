#################################################################
#
# Program ma przeszukac tablice i wydrukowac w oknie terminala:
#
# (na maks. 8 punktow)
#
# - maksymalna wartosc przechowywana w tablicy (typy 32-bitowe, bez znaku),
#
# kontynuacja - (na maks. 10 punktow):
#
# - dodatkowo - numer elementu (indeks), w ktorym przechowywana jest najwieksza wartosc.
#
# Zadanie ratunkowe - na maks. 5 punktow: wydrukowanie tekstu "napis"
# np. z wartosciami podanymi przez prowadzacego (funkcja printf, wartosci przekazane w rejestrach).
#
#################################################################
.section	.note.GNU-stack, "", @progbits

.globl	main

.data

.equ	liczba_elementow, 16

napis:		.asciz	"maks. = %u w elemencie %u\n"

tablica:	.long	2400, 7, 355, 3, 1, 87, 7, 10, 1, 0, 98, 13, 78, 49, 97, 3600

element:	.long	0

maks:		.long	0

#################################################################

.text

main:
sub $8, %rsp # do wyrównywania stosu

mov tablica(%rip), %eax
mov %eax, maks(%rip)
mov $0, %ecx # zerowanie licznika pętli

petla:

mov tablica(,%ecx,4), %eax

cmp maks(%rip), %eax # porównywanie do obecnego maximum
jle bez_zmian

# aktualizowanie wartości maksymalnej i indeksu
mov %eax, maks(%rip)
mov %ecx, element(%rip)

bez_zmian:

inc %ecx
cmp $liczba_elementow, %ecx
jne petla

koniec:

# wg. V-ABI
lea napis(%rip), %rdi
mov maks(%rip), %esi
mov element(%rip), %edx
xor %eax, %eax
call printf

# Koniec funkcji main.

add $8, %rsp # do wyrównywania stosu
xor %eax, %eax
ret
