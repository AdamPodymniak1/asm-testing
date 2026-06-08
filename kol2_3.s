.section .note.GNU-stack, "", @progbits

# Program ma obliczyc srednia kwadratowa (Root Mean Square - RMS)
# elementow tablicy val.
# Jednostka obliczeniowa dowolna - x87 lub SSE.
# Obliczenia oraz wydrukowanie wyniku - liczby podwojnej precyzji.

.globl main

.data

val: .double 2.0, 4.0, 6.0, 8.0, 7.0, 5.0, 3.0, 1.0
res: .double 0.0
nel: .long 8
cw:  .word 0
str: .string "RMS = %3.10lf\n"

.text

main:
sub $8, %rsp

xorpd %xmm0, %xmm0 # %xmm0 będzie akumulatorem sumy kwadratów (ustawiamy 0.0)
mov nel, %ecx # Licznik pętli (8 elementów)
mov $0, %rbx # Indeks przesunięcia w tablicy (bajtowy)

sum_loop:
movsd val(%rbx), %xmm1 # Ładowanie elementu tablicy do %xmm1
mulsd %xmm1, %xmm1 # Podnoszenie go do kwadratu (%xmm1 = x_i^2)
addsd %xmm1, %xmm0 # Dodawanie do akumulatora sumy

add $8, %rbx # Przechodzenie do kolejnego double (8 bajtów)
dec %ecx # Zmniejszanie licznika pętli
jnz sum_loop

# Dzielenie przez liczbę elementów (nel) i pierwiastkowanie
cvtsi2sd nel, %xmm1 # Konwersja liczby elementów (int) na double w %xmm1
divsd %xmm1, %xmm0  # Dzielimy sumę kwadratów przez liczbę elementów
sqrtsd %xmm0, %xmm0 # Wyciągamy pierwiastek kwadratowy -> Wynik RMS w %xmm0

movsd %xmm0, res # Zapisanie wyniku końcowego do zmiennej res

# Wydrukuj wynik
mov $str, %rdi # Pierwszy argument printf: format string
mov $1, %eax # Informacja dla printf: 1 argument zmiennoprzecinkowy (w %xmm0)
call printf

add $8, %rsp
xor %eax, %eax
ret

// Kompilowanie:
// gcc -no-pie kol2_3.s -o main
// ./main
