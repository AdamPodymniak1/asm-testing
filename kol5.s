################################################################
#
# Na maks. 10 punktow:
#
# program ma scalic ciagi str1 i str3 zapisujac calosc do str2:
# 
# "abcdefgh\0" + "12345678\0" -> "abcdefgh12345678\0".
#
# Nalezy wydrukowac ciag str2 w oknie terminala.
#
# Zadanie ratunkowe - na maks. 4 punkty: wydrukowanie ciagow str1 i str 2
# funkcja System Call.
#
#################################################################

.globl _start

.data

str1: .asciz "abcdefgh"
str2: .asciz "----------------\n"
str3: .asciz "12345678"

#################################################################

.text

_start:

# Przykladowe kroki.

# Inicjuj zmienne wartosciami poczatkowymi.

mov $0, %rcx # Licznik dla pierwszego ciagu (str1) jest zerowany
mov $0, %rbx # Licznik dla drugiego ciagu (str3) jest zerowany

petla1:
# Usun bledy i odczytaj w prawidlowy sposob elementy ciagow.

# Pierwszy znak z str1 jest pobierany
mov str1(%rcx), %al # Znak z str1 jest ladowany do rejestru AL

# Sprawdz warunek zakonczenia petli - znaku konca ciagu (NULL).

cmp $0, %al # Znak jest porownywany z wartoscia NULL
je petla2_start # Skok do drugiej petli po napotkaniu konca str1

# Zapisz kopiowane elementy w miejsca docelowe.

mov %al, str2(%rcx) # Znak jest kopiowany do str2 na pozycje licznika RCX

# Zaktualizuj licznik elementow.

inc %rcx # Licznik elementow jest zwiekszany o jeden
jmp petla1 # Skok do poczatku petli

petla2_start:
# Druga petla kopiuje str3 zaraz po znakach z str1

mov str3(%rbx), %al # Znak z str3 jest ladowany do rejestru AL
cmp $0, %al # Znak jest porownywany z zerem (NULL)
je koniec # Skok do sekcji koncowej, gdy str3 sie konczy

mov %al, str2(%rcx) # Znak z AL jest zapisywany w str2 na pozycji (RCX + RBX)

inc %rcx # Glowny wskaznik w str2 jest zwiekszany
inc %rbx # Wskaznik wewnetrzny str3 jest zwiekszany
jmp petla2_start # Skok powrotny do poczatku drugiej petli

koniec:

# Wyswietl wynik - ciag "str2" wywolujac System Call.

mov $1, %rax # Numer System Call dla write (1) jest ladowany do RAX
mov $1, %rdi # Deskryptor pliku stdout (1) jest ladowany do RDI
lea str2(%rip), %rsi # Adres ciagu str2 jest ladowany do RSI
mov $17, %rdx # Dlugosc ciagu (16 znakow + \n) jest ladowana do RDX
syscall

# Wywolaj System Call nr 60 - EXIT

mov $60, %rax # Numer System Call dla exit (60) jest ladowany do RAX
xor %rdi, %rdi # Kod powrotu 0 jest ladowany do RDI
syscall

#################################################################

# as kol5.s -o kol5.o
# ld kol5.o -o kol5
# ./kol5
