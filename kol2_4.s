.section .note.GNU-stack, "", @progbits

# Program ma obliczyc sume N poczatkowych wyrazow szeregu:
# S10 = (1/1) + (1/10) + (1/100) + (1/1000) + ...
# Jednostka obliczeniowa dowolna - x87 lub SSE.
# Obliczenia oraz wydrukowanie wyniku - liczby pojedynczej precyzji.

.globl main

.equ  N , 10

.data

outstr: .string "S10 = %1.10f\n"
c10:    .float 10.0
res:    .float 0.0
cw:     .word 0

.text

main:

sub $8 , %rsp

# W zaleznosci od wybranej jednostki arytmetycznej:
# - wlacz FPU,
# - ustaw pojedyncza precyzje obliczen,
# - zaokraglanie "to nearest even".
finit
fstcw cw
andw $0xfcff, cw # Ustawienie precyzji 24-bitowej (single precision)
andw $0xf3ff, cw # Zaokrąglanie do najbliższej parzystej (PC=00, RC=00)
fldcw cw

# Zainicjuj rejestry odpowiednimi wartosciami poczatkowymi,
# oblicz N pierwszych wyrazow szeregu.
fldz # ST(1) po fld1: suma częściowa (0.0)
fld1 # ST(0): bieżący wyraz szeregu (1.0)
mov $N, %ecx

for:
fadd %st(0), %st(1) # Suma = Suma + Bieżący wyraz
fdivs c10 # Bieżący wyraz = Bieżący wyraz / 10.0

dec %ecx
jnz for

# Pobranie wyniku i wyczyszczenie stosu FPU
fstp %st(0) # Usuń bieżący wyraz ze stosu
fstps res # Zapisz ostateczną sumę do 'res'

# Wydrukuj wynik
cvtss2sd res, %xmm0  # Konwersja float do double wymagana przez printf
mov $outstr, %rdi
mov $1, %eax
call printf

add $8 , %rsp
ret

// Kompilacja:
// gcc -no-pie kol2_4.s -o main
// ./main
