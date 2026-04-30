#####################################################
# Program ma wyznaczyc i wydrukowac w oknie terminala (funkcja printf):
#
# na maks. 7 punktow
#
# maksymalna wartosc wszystkich elementow tablicy oraz liczbe wartosci rownych 0
# kontynuacja na maks. 10 punktow:
#
# dodatkowo minimalna wartosc elementow tablicy
#
# Zadanie ratunkowe na maks. 4 punkty: wydrukowanie tekstu "Imie nazwisko nr_albumu", # przy czym nr_albumu ma stanowic wartosc zmiennej
#
#####################################################

.data

text_a: .string "Max = %d, zera = %d, min = %d\n"

tab: .long 6, 1, 0, 2, 5, 9, 7, 1, 2, 8, 3, 5, 9, 1, 2
count: .long 15

maxv: .long 0
minv: .long 0
cnt_0: .long 0

text_b: .string "Adam Podymniak nr %d\n"
number: .long 123456

#####################################################

.text
.global main

main:
push %rbp # Tworzenie ramki stosu
mov %rsp, %rbp # Wskaznik stosu jest kopiowany do RBP

# nadaj wartosci poczatkowe licznikom i wartosciom max, min # dane mozna przechowywac gdziekolwiek (w rejestrach, w pamieci)
# usun bledy i odczytaj w prawidlowy sposob element tablicy

mov tab(%rip), %eax # Pierwszy element tablicy jest pobierany do rejestru EAX
mov %eax, maxv(%rip) # Wartosc z EAX jest ustawiana jako poczatkowe maksimum
mov %eax, minv(%rip) # Wartosc z EAX jest ustawiana jako poczatkowe minimum
movl $0, cnt_0(%rip) # Licznik zer jest inicjalizowany wartoscia 0
mov $0, %rbx # Indeks pętli w rejestrze RBX jest zerowany

petla:
mov count(%rip), %ecx # Rozmiar tablicy jest ladowany do rejestru ECX
cmp %rbx, %rcx # Indeks jest porownywany z rozmiarem tablicy
jle koniec_petli # Skok do sekcji konczacej jest wykonywany, gdy indeks >= rozmiar

mov tab(,%rbx,4), %eax # Element tablicy jest pobierany przy uzyciu indeksu przesunietego o 4 bajty

# sprawdz czy wartosc jest wieksza od aktualnego maksimum # tak zaktualizuj maksimum

cmp maxv(%rip), %eax # Aktualny element jest porownywany z wartoscia maksymalna
jle pomin_max # Skok, jeżeli element jest większy
mov %eax, maxv(%rip) # Nowa wartosc maksymalna jest zapisywana w pamieci
pomin_max:

# sprawdz czy wartosc jest rowna 0
# tak - zaktualizuj licznik wartosci zerowych

cmp $0, %eax # Aktualny element jest porownywany z zerem
jne pomin_zero # Skok, jezeli element jest rozny od zera
incl cnt_0(%rip) # Licznik wartosci zerowych jest zwiekszany o jeden
pomin_zero:

# sprawdz czy wartosc jest mniejsza od aktualnego minimum # tak zaktualizuj minimum

cmp minv(%rip), %eax # Aktualny element jest porownywany z wartoscia minimalna
jge pomin_min # Skok, jezeli element nie jest mniejszy
mov %eax, minv(%rip) # Nowa wartosc minimalna jest zapisywana w pamieci
pomin_min:

inc %rbx # Indeks tablicy jest zwiekszany o jeden
jmp petla # Skok do poczatku petli

koniec_petli:

# przekaz argumenty
# wyswietl wyniki (printf)

lea text_a(%rip), %rdi # Adres ciagu formatujacego jest ladowany do RDI
mov maxv(%rip), %esi # Wartosc maksymalna jest przekazywana jako drugi argument
mov cnt_0(%rip), %edx # Liczba zer jest przekazywana jako trzeci argument
mov minv(%rip), %ecx # Wartosc minimalna jest przekazywana jako czwarty argument
xor %eax, %eax # Rejestr EAX jest zerowany przed wywolaniem funkcji
call printf # Funkcja printf jest wywolywana w celu wyswietlenia wynikow

# Zadanie ratunkowe
lea text_b(%rip), %rdi # Adres napisu z danymi osobowymi jest ladowany do RDI
mov number(%rip), %esi # Numer albumu jest ladowany do rejestru ESI
xor %eax, %eax # Rejestr EAX jest ponownie zerowany
call printf # Dane osobowe sa drukowane na ekranie

# koniec funkcji main

koniec:
pop %rbp # Wartosc rejestru RBP jest przywracana ze stosu
xor %rax, %rax # Kod zakonczenia 0 jest ustawiany w rejestrze RAX
ret

.section .note.GNU-stack,"",@progbits

# gcc kol2.s -o kol2 -no-pie
# ./kol2
