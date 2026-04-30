#################################################################
#
# Na maks. 8 punktow:
# program ma zliczyc i wydrukowac (funkcja printf)
# liczbe wszystkich elementow tablicy o wartosci zerowej,
#
# kontynuacja (na maks. 10 punktow):
#
# - wyswietlic komunikat jezeli w tablicy nie ma elementow o wartosci zerowej.
#
# Zadanie ratunkowe - na maks. 5 punktow: wydrukowanie tekstu "str1"
# z wartosciami (w rejestrach) podanymi przez prowadzacego (funkcja "printf").
#
#################################################################

.section .note.GNU-stack,"",@progbits
.globl main

.data

.equ liczba_elementow, 8
str1: .asciz "%u elementow zerowych\n"
str2: .asciz "brak elementow zerowych\n"

tab: .long 0, 8, 7, 0, 3, 0, 4, 0

# Zmienna pomocnicza na licznik zer
cnt_0: .long 0

#################################################################

.text

main:
sub $8, %rsp # Stos jest wyrownywany

# Przykladowe etapy zadania.
# Inicjuj zmienne wartosciami poczatkowymi.

movl $0, cnt_0(%rip) # Licznik zer jest zerowany w pamieci
movq $0, %rcx # Rejestr indeksu pętli jest zerowany

petla:
# Odczytaj w prawidlowy sposob element tablicy.

# Elementy sa 32-bitowe (.long), wiec uzywany jest mnoznik 4
movl tab(,%rcx,4), %eax # Aktualny element jest ladowany do rejestru EAX

# Sprawdz czy odczytano zero. Jesli tak - modyfikuj licznik zer.

cmp $0, %eax # Wartosc jest porownywana z zerem
jne pomin_inkrementacje # Skok jest wykonywany, gdy wartosc nie jest zerem
incl cnt_0(%rip) # Licznik zer jest zwiekszany o jeden
pomin_inkrementacje:

# Zaktualizuj licznik iteracji, sprawdz warunek zakonczenia petli.

inc %rcx # Indeks pętli jest zwiekszany
cmp $liczba_elementow, %rcx # Indeks jest porownywany z rozmiarem tablicy
jne petla # Petla jest kontynuowana, poki nie przejrzano wszystkich elementow

# Wyswietl wynik (lub stosowny komunikat) funkcja printf,
# przekazujac argumenty zgodnie ABI.

movl cnt_0(%rip), %esi # Liczba znalezionych zer jest ladowana do ESI
cmp $0, %esi # Sprawdzane jest, czy znaleziono jakiekolwiek zera
je brak_zer # Skok do komunikatu o braku zer

lea str1(%rip), %rdi # Adres formatu liczbowego jest ladowany do RDI
xor %eax, %eax # Rejestr EAX jest czyszczony
call printf # Wynik jest drukowany
jmp koniec_main

brak_zer:
lea str2(%rip), %rdi # Adres komunikatu o braku zer jest ladowany do RDI
xor %eax, %eax # Rejestr EAX jest czyszczony
call printf # Komunikat jest drukowany

# Koniec funkcji main.

koniec_main:
add $8, %rsp # Stos jest przywracany
xor %eax, %eax # Kod sukcesu jest ustawiany
ret

#################################################################

# gcc kol8.s -o kol8 -no-pie
# ./kol8
