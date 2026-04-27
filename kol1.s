#####################################################################
#
# Na maks. 8 punktow:
# program ma wykonac dzialanie 4 * (a + b) i wyswietlic wynik.
#
# Liczby a i b (32-bitowe bez znaku) maja zostac przekazane
# jako parametry z linii komend.
#
# Na maks. 10 punktow - dopisac obsluge bledow:
# np. jak liczba przekazanych parametrow jest rozna od 3
# wyjdz po wydrukowaniu odpowiedniego komunikatu.
#
# Zadanie ratunkowe:
# na maks. 5 punktow: wydrukowanie tekstu "str"
# z wartosciami (w rejestrach) podanymi przez prowadzacego
# (funkcja "printf", calosc napisana w asemblerze).
#####################################################################

.globl main

.data

str: .asciz "4 * (%u + %u) = %u\n"
err_msg: .asciz "Blad: wymagane 2 parametry liczbowe.\n"

# Zmienne w pamieci, w ktorych przechowywane sa dane
arg_a: .long 0
arg_b: .long 0
result: .long 0

#####################################################################

.text

main:
sub $8, %rsp # Stos jest wyrownywany do granicy 16 bajtow

# Sprawdz warunek:
# jezeli liczba parametrow jest rozna od 3
# to wydrukuj odpowiedni komunikat i wyjdz.

cmp $3, %edi # Rejestr argc jest porownywany z liczba 3
je params_ok # Skok jest wykonywany, gdy warunek rownosci zostal spelniony

lea err_msg(%rip), %rdi # Adres komunikatu o bledzie jest ladowany do RDI
xor %eax, %eax # Rejestr EAX jest zerowany
call printf # Funkcja printf jest wywolywana
add $8, %rsp # Wskaznik stosu jest przywracany
mov $1, %eax # Kod bledu 1 jest wpisywany do rejestru EAX
ret

params_ok:
# Konwersja string->int przekazanych jako parametry liczb.

mov %rsi, %rbx # Wartosc rejestru RSI (argv) jest kopiowana do RBX

mov 8(%rbx), %rdi # Adres pierwszego argumentu (argv[1]) jest pobierany
call atoi # Funkcja atoi jest wywolywana
mov %eax, arg_a(%rip) # Wynik konwersji jest zapisywany w zmiennej arg_a

# Kolejna konwersja string->int

mov 16(%rbx), %rdi # Adres drugiego argumentu (argv[2]) jest pobierany
call atoi # Funkcja atoi jest wywolywana ponownie
mov %eax, arg_b(%rip) # Wynik konwersji jest umieszczany w zmiennej arg_b

# Wykonaj dzialanie 4 * (a + b).

mov arg_a(%rip), %eax # Wartosc zmiennej arg_a jest przenoszona do rejestru EAX
add arg_b(%rip), %eax # Wartosc zmiennej arg_b jest dodawana do rejestru EAX

# Mnozenie przez 4
mov $4, %ecx # Liczba 4 jest ladowana do rejestru pomocniczego ECX
mul %ecx # Rejestr EAX jest mnozony przez wartosc rejestru ECX

mov %eax, result(%rip) # Wynik operacji mnozenia jest zapisywany w zmiennej result

# Wyswietl wynik (printf) zgodnie z formatowaniem ciagu "str"
# przekazujac argumenty zgodnie ABI.

lea str(%rip), %rdi # Adres ciagu formatujacego jest ladowany do RDI
mov arg_a(%rip), %esi # Wartosc arg_a jest przekazywana jako drugi parametr
mov arg_b(%rip), %edx # Wartosc arg_b jest przekazywana jako trzeci parametr
mov result(%rip), %ecx # Obliczony wynik jest przekazywany jako czwarty parametr
xor %eax, %eax # Rejestr EAX jest czyszczony przed wywolaniem funkcji
call printf # Wyswietlenie wyniku jest realizowane przez funkcje printf

# Koniec funkcji main.

koniec:
add $8, %rsp # Stos jest przywracany do stanu poczatkowego
xor %eax, %eax # Kod sukcesu 0 jest wpisywany do rejestru EAX
ret

.section .note.GNU-stack,"",@progbits

# gcc kol1.s -o kol1 -no-pie
# ./kol1 5 10
