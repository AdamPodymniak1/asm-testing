#################################################################
#
# Laboratorium 2a. Konwersja liczby calkowitej bez znaku
# do postaci ciagu tekstowego (reprezentacja w systemie szesnastkowym).

.globl _start

#################################################################
#
# Alokacja pamieci - zmienne statyczne, 8/16/32/64-bitowe,
# z nadana wartoscia poczatkowa.

.data

# en.wikipedia.org/wiki/Hexspeak
# en.wikipedia.org/wiki/Magic_number_(programming)

var8:	.byte	237
var16:	.word	57005
var32:	.long	4276994270
var64:	.quad	13464654573299691533

str:	.ascii	"val = ................h\n"
.equ	strlen, . - str

#################################################################
#
# Program glowny.

 .text

_start:

	xor	%rax , %rax

# Przekaz tylko niezbedne argumenty do funkcji konwertujacej.
# Przykladowo:
# w %rax (odpowiedniej dlugosci) - liczbe podlegajaca konwersji,
# w %rdi - adres bufora (pozycji odpowiadajacej cyfrze jednosci).

    mov var64, %rax
    mov $str+20, %rdi

# W przypadku konwersji typow wielobajtowych przekaz
# w rejestrze %ecx - rozmiar konwertowanego typu danych w bajtach: (1),2,4,8.

    mov $8, %rcx

# Wywolaj funkcje konwertujaca.

	call	convert	

# Wyswietl wynik (system_call nr 1).

	mov	$1 , %rax
	mov	%rax , %rdi
	mov	$str , %rsi
	mov	$strlen, %rdx
	syscall

# Zakoncz program (system_call nr 60).

	mov	$60, %rax
	xor	%rdi, %rdi
	syscall

#################################################################
#
# Zadanie --- 3 ---
#
# Konwertuj wielobajtowy typ danych.
#
# Argumenty:
# liczba w rejestrze %rax (odpowiedniej dlugosci),
# adres zapisu w %rdi,
# liczba bajtow do konwersji w %ecx.
#
# Funkcja moze wywolywac "convert_byte" z zadania 2.
# Ew. funkcje z zadan 2. i 3. mozna scalic w jedna i zoptymalizowac.
#
# Zwracana wartosc: - (zapis w pamieci).
# Nadpisywane rejestry: ustalic.

convert:
    mov %rax, %rdx

	call convert_byte
    mov %ax, (%rdi)

    mov %rdx, %rax
    shr $8, %rax
    sub $2, %rdi

    dec %rcx

    cmp $0, %rcx
    jnz convert

	ret

#################################################################
#
# Zadanie --- 2 ---
#
# Konwertuj pojedynczy bajt.
# Argumenty: dane w rejestrze %al, ew. adres zapisu (dwoch bajtow) w %rdi.
#
# Zwracana wartosc: ustalic.
# Nadpisywane rejestry: ustalic.

convert_byte:
    mov %al, %bl

    and $0x0F, %al # Zerowanie starszych bitów
	call convert_nibble
    mov %al, %ah # Młodsza część do AH, by całość była możliwa do odczytania w AX

    mov %bl, %al
    shr $4, %al # Przesunięcie bitowe logiczne w prawo o 4 bity
    call convert_nibble

	ret

#################################################################
#
# Zadanie --- 1 ---
#
# Konwertuj czterobitowa liczbe (nizszy polbajt, nizsza tetrade, lower nibble...)
# na odpowiadajacy jej kod znaku tablicy ASCII.
#
# Argument:
# 4 mlodsze bity w rejestrze %al (4 starsze musza byc wyzerowane).
#
# Zwracana wartosc: w %al - nr znaku wg tablicy ASCII.
# Nadpisywane rejestry:
#
# Wykonywane dzialanie: if (%al < 10) %al += 48; else %al += 55;
# (realizacja - dowolna).

convert_nibble:
    cmp $10, %al
    jae cn_else
    add $48, %al
    ret

cn_else:
    add $55, %al
    ret

#################################################################
