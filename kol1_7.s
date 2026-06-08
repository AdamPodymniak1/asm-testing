#################################################################
#
# Na maks. 7 punktow:
# program ma wykonac dzialanie (a + b + c + d ) / 8 i wyswietlic wynik.
#
# Liczby a, b i c (32 bitowe ze znakiem) maja zostac przekazane
# jako parametry z linii komend.
#
# Na maks. 10 punktow - dopisac obsluge bledow.
# Np. jak liczba przekazanych parametrow jest rozna od 4
# wyjdz po wydrukowaniu odpowiedniego komunikatu.
#
# Zadanie ratunkowe - na maks. 4 punkty: wydrukowanie tekstu "str"
# z wartosciami (w rejestrach) podanymi przez prowadzacego (funkcja "printf").
#
#################################################################

.globl main

.data

str: .asciz "(%d + %d + %d + %d) / 8 = %d\n"
err: .asciz "Bledna liczba argumentow (wymagane 4).\n"

arg_a: .long 0
arg_b: .long 0
arg_c: .long 0
arg_d: .long 0
result: .long 0

#################################################################

.text

main:

sub $8, %rsp # Wyrównywanie stosu

# Przykladowe etapy zadania.
# Sprawdz warunek:
# jezeli liczba parametrow jest rozna od 5 to wyjdz
# wydrukuj odpowiedni komunikat i wyjdz.

cmp $5, %edi # Rejestr EDI (argc) jest porownywany z liczba 5
je params_ok # Skok, gdy podano dokladnie 4 liczby

lea err(%rip), %rdi # Adres komunikatu o bledzie jest ladowany do RDI
xor %eax, %eax # Rejestr EAX jest zerowany
call printf # Komunikat o bledzie jest wyswietlany
add $8, %rsp # Stos jest przywracany
mov $1, %eax # Kod bledu 1 jest zwracany
ret

params_ok:
# Konwersja string->int przekazanych jako parametry liczb.

mov %rsi, %rbx # Adres tablicy argv jest kopiowany do RBX

mov 8(%rbx), %rdi # Pierwszy argument jest pobierany
call atoi
mov %eax, arg_a(%rip) # Wynik jest zapisywany w arg_a

mov 16(%rbx), %rdi # Drugi argument jest pobierany
call atoi
mov %eax, arg_b(%rip) # Wynik jest zapisywany w arg_b

mov 24(%rbx), %rdi # Trzeci argument jest pobierany
call atoi
mov %eax, arg_c(%rip) # Wynik jest zapisywany w arg_c

mov 32(%rbx), %rdi # Czwarty argument jest pobierany
call atoi
mov %eax, arg_d(%rip) # Wynik jest zapisywany w arg_d

# Wykonaj dzialanie (a + b + c + d) / 8.

mov arg_a(%rip), %eax # Wartosc a jest ladowana do EAX
add arg_b(%rip), %eax # Wartosc b jest dodawana do EAX
add arg_c(%rip), %eax # Wartosc c jest dodawana do EAX
add arg_d(%rip), %eax # Wartosc d jest dodawana do EAX

# Przygotowanie do dzielenia liczb ze znakiem (32-bit)
mov $8, %ecx # Dzielnik 8 jest ladowany do rejestru ECX
div %ecx # Przelenie przez 8
mov %eax, result(%rip) # Wynik dzielenia jest zapisywany w pamieci

# Wyswietl wynik (printf) zgodnie z formatowaniem ciagu "str"
# przekazujac argumenty zgodnie ABI.

lea str(%rip), %rdi # Adres formatu jest ladowany do RDI
mov arg_a(%rip), %esi # Wartosc a jest ladowana do ESI
mov arg_b(%rip), %edx # Wartosc b jest ladowana do EDX
mov arg_c(%rip), %ecx # Wartosc c jest ladowana do ECX
mov arg_d(%rip), %r8 # Wartosc d jest ladowana do R8
mov result(%rip), %r9 # Wynik jest ladowany do R9
xor %eax, %eax # Rejestr EAX jest zerowany
call printf # Wynik operacji jest drukowany

# Koniec funkcji main.
koniec:

add $8, %rsp # Stos jest przywracany
xor %eax, %eax # Kod sukcesu 0 jest ustawiany
ret

.section .note.GNU-stack,"",@progbits

#################################################################

# gcc kol7.s -o kol7 -no-pie
# ./kol7 10 20 30 40
