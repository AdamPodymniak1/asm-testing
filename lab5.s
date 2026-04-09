#################################################################
#
# Laboratorium 5.
# Switch-case-break, ABI,
# przekazanie argumentow i wywolanie funkcji jezyka C.
#
# Program ma wykonac wybrana operacje logiczna lub arytmetyczna oraz wyswietlic:
# jej nazwe, argumenty oraz wynik.
#
# Argumenty do programu nalezy przekazac jako parametry z linii komend:
#
# ./swcs arg1 arg2 nr_operacji_logicznej

.globl	main

.section  .note.GNU-stack, "", @progbits

#################################################################
#
# Alokacja pamieci - zmienne statyczne z nadana wartoscia poczatkowa.

.data

str_and:	.asciz	"%u AND %u = %u\n"
str_or:		.asciz	"%u OR %u = %u\n"
str_xor:	.asciz	"%u XOR %u = %u\n"
str_add:	.asciz	"%u ADD %u = %u\n"
str_def:	.asciz	"DEFAULT\n"

arg_1:		.long	0
arg_2:		.long	0
result:		.long	0
case_no:	.long	0

# --- 2b ---
# Tablica skokow - adresow kolejnych sekcji switcha.

jump_table:	.quad c_def, c_and, c_def, c_add, c_def, c_or, c_def, c_xor

#################################################################
#
# program glowny

.text

main:

# W celu zachowania zgodnosci z ABI i funkcjami z GNU C Library
# wierzcholek stosu powinien byc wyrownany do granicy 16 bajtow
# (8-bajtowy adres powrotu + 8-bajtowa ramka stosu, ew. odkladanie
# na stos 16-bajtowych elementow).
# Ramki stosu nie tworzymy, wiec %rsp nalezy obnizyc o 8 bajtow.

sub	$8 , %rsp

# --- 1b --- Opcjonalnie:
#
# sprawdz, czy z linii komend przekazano trzy parametry,
# jesli nie - wyjdz (opcjonalnie zwracajac -1 w %eax).

cmp $4, %edi
je convert_argv
mov $-1, %eax
add $8, %rsp # Podniesienie rejestru ramki stosu do pierwotnej przed wyjściem
ret # Wychodzenie z main (równoznaczne z exit)

convert_argv:

# --- 1a --- Przekazywanie parametrow z linii komend.
#
# Konwertuj przekazane parametry (argv) z ciagu tekstowego na liczbe calkowita,
# np. jedna z funkcji biblioteki stdlib (np. atoi, strtol).

mov %rsi, %r12 # Kopia argv do rejestru zachowywanego przez funkcje biblioteczne
mov	8(%r12) , %rdi
call	atoi
mov	%eax , arg_1

# Analogicznie konwersje kolejnych parametrow:

mov	16(%r12) , %rdi
call	atoi
mov	%eax , arg_2

mov	24(%r12) , %rdi
call	atoi # w EAX jest numer działania

# --- 2a --- Switch - Case.
#
# Sprawdz, czy podany nr przypadku miesci sie w stablicowanym zakresie.

cmp	$7 , %eax
ja	c_def

# Czesc wspolna dla wszystkich przypadkow (za wyjatkiem default - mozna zoptymalizowac).

mov	arg_1 , %esi
mov	arg_2 , %edx
mov	%edx , %ecx

# --- 2c ---
#
# Skok posredni - do adresu odczytanego z tablicy (do odpowiedniego przypadku).

jmp *jump_table(, %eax, 8) # skocz pod adres odczytany z tablicy

# W kazdym z przypadkow (oprocz default) wykonaj odpowiednia operacje
# logiczna/arytmetyczna oraz przekaz niezbedne argumenty do funkcji printf.

c_and:
and	%esi , %ecx
mov	$str_and , %rdi
jmp	brk

c_or:
or	%esi , %ecx
mov	$str_or , %rdi
jmp	brk

c_xor:
xor	%esi , %ecx
mov	$str_xor , %rdi
jmp	brk

c_add:
add	%esi , %ecx
mov	$str_add , %rdi
jmp	brk

c_def:
mov	$str_def , %rdi

brk:

# Czesc wspolna dla wszystkich przypadkow:
# wywolaj funkcje printf z uprzednio umieszczonymi w odpowiednich rejestrach (wg ABI):
# adresem ciagu, argumentami i wynikiem operacji.
# Nie sa uzywane typy zmiennoprzecinkowe i rejestry wektorowe (%xmm) wiec %eax=0.

xor	%eax , %eax
call	printf

# Przesun wskaznik stosu o 8 bajtow w gore aby "ret" prawidlowo sciagnal adres powrotu.

add	$8 , %rsp

# Powrot z main, zwroc w %eax kod bledu.
xor	%eax , %eax
ret

#################################################################

