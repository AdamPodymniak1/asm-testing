#################################################################
#
# Na maks. 8 punktow:
# program ma wydrukowac (funkcja printf) numer (indeks)
# pierwszego odczytanego z tablicy elementu o wartosci zerowej,
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
str1: .asciz "indeks pierwszego elementu o wartosci zero = %u\n"
str2: .asciz "brak elementow zerowych\n"

tab: .long 6, 8, 7, 0, 3, 0, 1, 9

# Zmienna na przechowywanie znalezionego indeksu
znaleziony_indeks: .long 0

#################################################################

.text

main:
sub $8, %rsp

# Przykladowe etapy zadania.
# Inicjuj zmienne wartosciami poczatkowymi.

mov $0, %rcx # Rejestr indeksu pętli jest zerowany
movl $-1, znaleziony_indeks(%rip) # Wartosc -1 jest ustawiana jako znacznik braku zera

petla:
# Odczytaj w prawidlowy sposob element tablicy.

mov tab(,%rcx,4), %eax # Element o indeksie RCX jest ladowany do EAX

# Sprawdz czy odczytano zero. Jesli tak - zapisz numer elementu.

cmp $0, %eax # Wartosc jest porownywana z zerem
jne dalej # Skok jest wykonywany, gdy wartosc nie jest zerem

# Jesli znaleziono zero po raz pierwszy
cmpl $-1, znaleziony_indeks(%rip) # Sprawdzane jest, czy indeks zostal juz zapisany
jne dalej # Jesli tak, skok dalej

mov %ecx, znaleziony_indeks(%rip) # Aktualny indeks RCX jest zapisywany w pamieci
jmp koniec_petli # Po znalezieniu pierwszego zera petla jest przerywana

dalej:
# Zaktualizuj licznik iteracji, sprawdz warunek zakonczenia petli.

inc %rcx # Indeks pętli jest zwiekszany
cmp $liczba_elementow, %rcx # Indeks jest porownywany z limitem elementow
jne petla # Petla jest powtarzana

koniec_petli:

# Wyswietl numer elementu (lub stosowny komunikat) funkcja printf,
# przekazujac argumenty zgodnie ABI.

mov znaleziony_indeks(%rip), %esi # Znaleziony indeks jest ladowany do ESI
cmp $-1, %esi # Sprawdzane jest, czy znacznik -1 pozostal niezmieniony
je brak_zer # Skok do komunikatu o braku zer jest wykonywany

lea str1(%rip), %rdi # Adres formatu dla indeksu jest ladowany do RDI
xor %eax, %eax # Rejestr EAX jest zerowany
call printf # Wynik jest wyswietlany
jmp koniec_main

brak_zer:
lea str2(%rip), %rdi # Adres komunikatu o braku zer jest ladowany do RDI
xor %eax, %eax # Rejestr EAX jest zerowany
call printf # Komunikat o braku zer jest wyswietlany

# Koniec funkcji main.

koniec_main:
add $8, %rsp # Stos jest przywracany
xor %eax, %eax # Kod sukcesu 0 jest ustawiany
ret

#################################################################

# gcc kol9.s -o kol9 -no-pie
# ./kol9
