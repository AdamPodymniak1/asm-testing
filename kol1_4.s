###############################################################
#
# Na maks. 10 punktow:
#
# Program ma obliczyc i wydrukowac w oknie terminala
# srednia wartosc elementow przechowywanych w tablicy (liczby calkowite, 16 bitowe, bez znaku).
#
# Zadanie ratunkowe - na maks. 4 punkty: wydrukowanie tekstu "napis"
# np. z wartosciami podanymi przez prowadzacego (funkcja printf, wartosci przekazane w rejestrach).
#
#################################################################

.globl main

.data

.equ liczba_elementow, 16

napis: .asciz "avg = %hd\n"

tablica: .word 64, 4, 3, 3, 0, 8, 7, 10, 1, 8, 8, 8, 8, 4, 15, 72

avg: .long 0

#################################################################

.text

main:
sub $8, %rsp # Wyrównywanie stosu

# Przykladowe etapy zadania.

# Inicjuj zmienne wartosciami poczatkowymi.

movq $0, %rax # Rejestr sumy jest zerowany
movq $0, %rcx # Licznik petli RCX jest zerowany

petla:

# Usun bledy i odczytaj w prawidlowy sposob element tablicy.

# Uzywany jest mnoznik 2, poniewaz .word to 2 bajty. Wartosc jest ladowana do DX, aby nie zamazac sumy w RAX.
mov tablica(,%rcx,2), %dx # Element jest pobierany do rejestru DX
movzwl %dx, %edx # Wartosc jest rozszerzana do 32 bitow (bez znaku)
add %rdx, %rax # Wartosc elementu jest dodawana do sumy calkowitej w RAX

# Zaktualizuj licznik iteracji, sprawdz warunek zakonczenia petli.

inc %rcx # Licznik iteracji jest zwiekszany o jeden
cmp $liczba_elementow, %rcx # Licznik jest porownywany z liczba elementow
jne petla # Skok do poczatku petli

koniec:

# Oblicz srednia.

xor %rdx, %rdx # Rejestr RDX jest zerowany przed dzieleniem (reszta)
mov $liczba_elementow, %rcx # Dzielnik jest ladowany do rejestru RCX
div %rcx # Suma w RAX jest dzielona przez liczbe elementow (wynik w RAX)
mov %eax, avg(%rip) # Wynik dzielenia (srednia) jest zapisywany w pamieci

# Wyswietl wynik (printf) zgodnie z formatowaniem ciagu "str"
# przekazujac argumenty zgodnie ABI.

lea napis(%rip), %rdi # Adres formatu jest ladowany do RDI
mov avg(%rip), %esi # Obliczona srednia jest ladowana do ESI (2. argument)
xor %eax, %eax # Rejestr EAX jest zerowany dla funkcji printf
call printf # Wynik jest drukowany w terminalu

# Koniec funkcji main.

add $8, %rsp # Wskaznik stosu jest przywracany
xor %eax, %eax # Kod powrotu 0 jest ustawiany w EAX
ret

.section .note.GNU-stack,"",@progbits

#################################################################

# gcc kol4.s -o kol4 -no-pie
# ./kol4
