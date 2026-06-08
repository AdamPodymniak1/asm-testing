#################################################################
#
# Program ma przeszukac tablice i wydrukowac w oknie terminala:
#
# (na maks. 7 punktow)
#
# - maksymalna wartosc przechowywana w tablicy (typy 16 bitowe, ze znakiem),
#
# kontynuacja - (na maks. 10 punktow):
#
# - dodatkowo - numer elementu (indeks), w ktorym przechowywana jest najwieksza wartosc.
#
# Zadanie ratunkowe - na maks. 4 punkty: wydrukowanie tekstu "napis"
# np. z wartosciami podanymi przez prowadzacego (funkcja printf, wartosci przekazane w rejestrach).
#
#################################################################

.globl main

.data

.equ liczba_elementow, 16

napis: .asciz "max = %hd w elemencie %hu\n"

tablica: .word 64, 4, 3, 3, 0, 8, 7, 10, -1, 8, 8, 8, -8, 4, 15, 72

element: .long 0
maks: .short 0

#################################################################

.text

main:
sub $8, %rsp # Stos jest wyrownywany

# Przykladowe etapy zadania.

# Inicjuj zmienne wartosciami poczatkowymi.

mov tablica(%rip), %ax # Pierwszy element jest pobierany do rejestru AX
mov %ax, maks(%rip) # Pierwsza wartosc jest ustawiana jako poczatkowe maksimum
movl $0, element(%rip) # Indeks maksymalnego elementu jest zerowany
movq $0, %rcx # Licznik pętli RCX jest zerowany

petla:

# Usun bledy i odczytaj w prawidlowy sposob element tablicy.

# Uzywany jest mnoznik 2, poniewaz .word zajmuje 2 bajty
mov tablica(,%rcx,2), %ax # Aktualny element jest ladowany do rejestru AX

# Sprawdz czy odczytana z tablicy wartosc jest wieksza od najwiekszej dotychczas znalezionej,
# jesli tak - zaktualizuj odpowiednie zmienne.

cmp maks(%rip), %ax # Wartosc z AX jest porownywana z dotychczasowym maksimum
jle pomin_aktualizacje # Skok, gdy wartosc nie jest wieksza

mov %ax, maks(%rip) # Nowa wartosc maksymalna jest zapisywana w pamieci
mov %ecx, element(%rip) # Aktualny indeks jest zapisywany jako indeks maksymalny

pomin_aktualizacje:

# Zaktualizuj licznik iteracji, sprawdz warunek zakonczenia petli.

inc %rcx # Licznik iteracji jest zwiekszany o jeden
cmp $liczba_elementow, %rcx # Licznik jest porownywany z liczba elementow
jne petla # Skok do poczatku petli, gdy nie osiagnieto konca

koniec:

# Wyswietl wynik (printf) zgodnie z formatowaniem ciagu "str"
# przekazujac argumenty zgodnie ABI.

lea napis(%rip), %rdi # Adres formatu jest ladowany do RDI
mov maks(%rip), %esi # Wartosc maksymalna jest rozszerzana do ESI (2. argument)
mov element(%rip), %edx # Numer elementu jest ladowany do EDX (3. argument)
xor %eax, %eax # Rejestr EAX jest zerowany dla funkcji printf
call printf # Wynik jest wyswietlany w terminalu

# Koniec funkcji main.

add $8, %rsp # Wskaznik stosu jest przywracany
xor %eax, %eax # Kod powrotu 0 jest ustawiany w EAX
ret

.section .note.GNU-stack,"",@progbits

#################################################################

# gcc kol3.s -o kol3 -no-pie
# ./kol3
