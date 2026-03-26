#################################################################
#
# Laboratorium 2b. Konwersja liczby calkowitej bez znaku
# do postaci ciagu tekstowego (reprezentacja w systemie dziesietnym).

.globl _start

#################################################################
#
# Alokacja pamieci - zmienne statyczne, 8/16/32/64-bitowe,
# z nadana wartoscia poczatkowa.

.data

var8:	.byte	0b01011101
var16:	.word	0x6300
var32:	.long	0xFFFFFFFF
var64:	.quad	0xAB54A98EEE391EEA

str:	.ascii	"val = ....................\n"

.equ	strlen, . - str

#################################################################
#
# Program glowny.

 .text

_start:

	xor	%eax , %eax

# Przekaz tylko niezbedne argumenty do funkcji konwertujacej.
# Przykladowo:
# w %rax (odpowiedniej dlugosci) liczbe podlegajaca konwersji,
# w rejestrze %rdi adres bufora (pozycji odpowiadajacej cyfrze jednosci).

    mov var64, %rax

	mov	$str+25 , %rdi

# Wywolaj funkcje konwertujaca.

	call	convert_dec

# Wyswietl wynik (system_call nr 1).

	mov	$1 , %eax
	mov	$1 , %edi
	mov	$str , %rsi
	mov	$strlen , %edx
	syscall

# Zakoncz program (system_call nr 60).

	mov	$60 , %eax
	xor	%edi , %edi
	syscall

#################################################################
#
# Konwertuj wielobajtowy typ danych na ciag tekstowy
# (reprezentacja liczby w systemie dziesietnym).
# Argumenty: liczba w rejestrze %rax (odpowiedniej dlugosci), adres zapisu w %rdi.
#
# Zwracana wartosc: -
# Nadpisywane rejestry: ustalic

convert_dec:
    mov $10, %rbx # Dzielnik w rejestrze RBX
convert:
    xor %rdx, %rdx # Zerowanie przed dzieleniem, bo wynik overflowuje do RDX

    div %rbx
    add $48, %dl # Przesuń do przestrzeni znaków ASCII
    mov %dl, (%rdi) # Zapisz znak
    dec %rdi # Przesuń wskaźnik

    // Pętla
    # cmp $0, %rax
    and %rax, %rax # Szybsze porównywanie, czy rax = 0 (może być and/or)
    jnz convert

	ret

#################################################################
