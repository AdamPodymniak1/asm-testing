#################################################################
# Program ma wyliczyc wartosc formuly podanej przez prowadzacego
# i wydrukowac wynik w oknie terminala (funkcja printf):
# (maks. 7 punktów): pojedynczy wynik
# (maks. 10 punktów): kilka wynikow dla podanych wartosci
#
# Zadanie ratunkowe - (maks. 5 pkt):  policzyc i wydrukowac
# wartosc wyrazenia podanego przez prowadzacego zajecia
#
# Uwaga: zmiana wartosci i/lub typow danych bedzie traktowana
# jako rozwiazanie nie w pełni poprawne!
#################################################################

.data

# Zdefiniuj odpowiednie napisy do wyswietlenia wynikow (zapytać, czy aby na pewno powinno być 6., a nie coś innego, bo to wygląda jak literówka)
txt_1: .string "X = %6.f -> Y = %6.f\n"
txt_2: .string "X = %6.1f -> Y = %6.1f\n"
txt_3: .string "X = %6.Lf -> Y = %6.Lf\n"

# Wartosc poczatkowa zmiennych i niezbedne stale.
dwapi: .double 6.28
x_1:   .long   1
x_2:   .float  2.0
x_3:   .double 3.0
y:     .tfloat 0.0

cw:    .word   0

.text
.global main
        
main:
push %rbp

finit

# Ustaw odpowiednia precyzje obliczen, wylacz wyjatki
fstcw cw
orw $0x037f, cw
fldcw cw

# OBLICZENIA I WYNIK DLA X_1 (long / int) -> format txt_1
fildl x_1 # fildl dla liczby całkowitej (int)
fmull dwapi
fstpt y

# Konwersja y (tfloat) na double do %xmm1
fldt y
sub $8, %rsp
fstpl (%rsp)
movsd (%rsp), %xmm1
add $8, %rsp

# Konwersja x_1 (int) na double do %xmm0 (bo txt_1 oczekuje %6.f)
cvtsi2sd x_1, %xmm0

mov $txt_1, %rdi
mov $2, %eax
call printf

# OBLICZENIA I WYNIK DLA X_2 (float) -> format txt_2
flds x_2 # flds dla liczby single precision (float)
fmull dwapi
fstpt y

# Konwersja y (tfloat) na double do %xmm1
fldt y
sub $8, %rsp
fstpl (%rsp)
movsd (%rsp), %xmm1
add $8, %rsp

# Konwersja x_2 (float) na double do %xmm0
cvtss2sd x_2, %xmm0

mov $txt_2, %rdi
mov $2, %eax
call printf

# OBLICZENIA I WYNIK DLA X_3 (double) -> format txt_3
fldl x_3 # fldl dla liczby double precision (double)
fmull dwapi
fstpt y

# txt_3 jako jedyny używa %Lf (Long Double), czyli przekazujemy przez stos
mov $txt_3, %rdi
sub $32, %rsp # Miejsce na dwa argumenty 80-bitowe (po 16 bajtów rezerwacji)

# Pierwszy argument na stosie: X_3 skonwertowane do tfloat
fldl x_3
fstpt (%rsp)

# Drugi argument na stosie: Y
fldt y
fstpt 16(%rsp)

mov $0, %eax # 0 rejestrów XMM (wszystko leci przez stos CPU)
call printf
add $32, %rsp # Sprzątanie stosu

# Koniec funkcji main
pop %rbp
xor %eax, %eax
ret

# By linker nie wariował
.section .note.GNU-stack,"",@progbits

// Kompilowanie:
// gcc -no-pie kol2_1.s -o main
// ./main
