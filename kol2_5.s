.section .note.GNU-stack, "", @progbits

# Program ma obliczyc srednia harmoniczna elementow tablicy val.
#
# Jednostka obliczeniowa: x87 FPU.
# Obliczenia oraz wydrukowanie wyniku - liczby podwojnej precyzji.

.globl main

.data

val:    .double 1.4, 3.8, 1.0, 7.8, 4.7, 2.8, 2.9, 3.7

res:    .double 0.0
nel:    .long 8
cw:     .word 0
str:    .string "AVG_H = %3.10lf\n"

.text

main:

sub $8 , %rsp

# W zaleznosci od wybranej jednostki arytmetycznej:
# - wlacz FPU,
# - ustaw podwojna precyzje obliczen,
# - zaokraglanie "to nearest even".
finit
fstcw cw

# Ustawienie double precision (53-bit)
andw $0xfcff, cw
orw  $0x0200, cw

# Zaokraglanie: round to nearest even
andw $0xf3ff, cw

fldcw cw

# Zainicjuj rejestry odpowiednimi wartosciami poczatkowymi,
# oblicz srednia harmoniczna elementow tablicy.
fldz # ST(0) = suma odwrotnosci = 0.0

mov nel, %ecx # liczba elementow
mov $val, %rsi # adres tablicy

sum_loop:

fld1 # ST(0) = 1.0
fldl (%rsi) # ST(0) = val[i], ST(1) = 1.0, ST(2) = suma

fdivrp # ST(0) = 1.0 / val[i]

faddp # suma += 1/val[i]

add $8, %rsi # przejdz do kolejnego double
dec %ecx
jnz sum_loop

# H = n / suma(1/x)

fildl nel # ST(0)=8, ST(1)=suma
fxch %st(1) # ST(0)=suma, ST(1)=8

fdivrp # ST(0)=8/suma

fstpl res # zapisz wynik do res

# Wydrukuj wynik
movsd res, %xmm0
mov $str, %rdi
mov $1, %eax
call printf

add $8 , %rsp
ret

# Kompilacja:
# gcc -no-pie kol2_5.s -o main
# ./main
