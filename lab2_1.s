#################################################################
#
# Laboratorium 2 - sterowanie przebiegiem programu:
# - petla "for" (rozne sposoby).

.globl _start

# Definicje stalych, uzywanych w programie (opcjonalnie).

.equ	sys_write,	1
.equ	sys_exit,	60
.equ	stdout,		1
.equ	strlen, 	new_line + 1 - str


#################################################################
#
# Alokacja pamieci - zmienne statyczne, z nadana wartoscia poczatkowa.

.data

counter:	.byte	43
str:		.ascii	"iteracja nr: x"
new_line:	.byte	0x0A

#################################################################
#
# Program glowny.

.text

_start:

# Zadanie 1. Petla for: sposob "naiwny" - analiza i ew. optymalizacja.

# 1. Inicjuj licznik petli wartoscia poczatkowa:

movb $0, %bl

petla_for:

# 2. Sprawdz warunek wyjscia z petli:

cmpb counter, %bl

# 3a. Jesli warunek spelniony - wyjdz z petli:

je koniec_for

# 3b. Jesli nie - wykonaj kod objety petla:

# wydrukuj ciag tekstowy "str" w petli "n" razy.

# Korekcja ASCII - zmodyfikuj "x" w ciagu "str" tak,
# aby w jego miejscu drukowana byla wartosc licznika iteracji "counter"

mov %bl, %al		# wczytaj licznik do dowolnego, 8-bitowego rejestru
add	$48 , %al		# przesuniecie +48, wg tablicy ASCII
mov	%al , new_line - 1	# zapisz kod znaku pod odpowiedni adres

# Wywolaj System Call nr 1 (sys_write) - powtorz "n" razy.

mov	$sys_write , %eax
mov	$stdout , %edi
mov	$str , %esi
mov	$strlen , %edx
syscall

# 4. Zmodyfikuj licznik petli i bezwarunkowo skocz na jej poczatek:

incb %bl

jmp	petla_for

koniec_for:

# Zakoncz poprawnie program - System Call nr 60 (sys_exit).

mov	$sys_exit , %eax
xor	%edi , %edi		# kod bledu:  %edi = %edi xor %edi = 0
syscall
