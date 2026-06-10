.section .note.GNU-stack, "", @progbits

# Program ma obliczyc srednia wazona elementow tablicy val.
# Wagi, odpowiadajace tym elementom, zawarte sa w tablicy wgt.
# Jednostka obliczeniowa dowolna - x87 lub SSE.
# Obliczenia oraz wydrukowanie wyniku - liczby pojedynczej precyzji.

.globl main

.data

val:    .float 2.6, 3.4, 6.8, 1.5
wgt:    .float 2.0, 1.0, 4.0, 3.0
res:    .float 0.0
nel:    .long 4
cw:     .word 0
str:    .string "AVG_W = %3.3f\n"

.text

main:

sub $8 , %rsp

# W zaleznosci od wybranej jenostki arytmetycznej:
# - wlacz FPU,
# - ustaw pojedyncza precyzje obliczen,
# - zaokraglanie "to nearest even".
finit
fstcw cw
andw $0xfcff, cw # Ustawienie precyzji 24-bitowej (single precision)
andw $0xf3ff, cw # Zaokrąglanie do najbliższej parzystej
fldcw  cw

# Zainicjuj rejestry odpowiednimi wartosciami poczatkowymi,
# oblicz srednia wazona elementow tablicy.
fldz # ST(1): suma wag (0.0)
fldz # ST(0): suma iloczynów (0.0)
mov nel, %ecx
mov $0, %rbx # Indeks przesunięcia w tablicach (w bajtach)

sum_loop:
flds wgt(%rbx) # ST(0)=wgt[i], ST(1)=suma_il, ST(2)=suma_wag
fadd %st(0), %st(2) # Dodaj wagę do sumy wag: ST(2) = suma_wag + wgt[i]
fmuls val(%rbx) # Pomnóż wagę przez wartość: ST(0) = wgt[i] * val[i]
faddp %st(0), %st(1) # Dodaj do sumy iloczynów i zdejmij ze stosu: ST(0) = suma_il + (wgt*val)

add $4, %rbx # Przejdź do kolejnego elementu (float = 4 bajty)
dec %ecx
jnz sum_loop

# Obliczenie średniej ważonej: suma_iloczynów / suma_wag
fdiv %st(1), %st(0) # ST(0) = ST(0) / ST(1)
fstps res # Zapisz wynik końcowy do zmiennej res i wyczyść stos FPU

# Wydrukuj wynik
cvtss2sd res, %xmm0 # Konwersja float do double wymagana przez printf
mov $str, %rdi
mov $1, %eax
call printf

add $8 , %rsp
ret

// Kompilacja
// gcc -no-pie kol2_6.s -o main
// ./main
