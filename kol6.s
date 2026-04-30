#################################################################
#
# Na maks. 10 punktow:
#
# Program skopiować reprezentujace litery elementy ciagu str1
# do kolejnych bajtow ciagu str2:
# 
# "a2c4e6g8" -> "aceg----"
#
# Nalezy wydrukowac ciag str2 w oknie terminala.
#
# Zadanie ratunkowe - na maks. 4 punkty: wydrukowanie tekstu "str1"
# (funkcja system call).
#
#################################################################

.globl _start

.data

str1: .asciz "a2c4e6g8\n"
str2: .asciz "--------\n"

#################################################################

.text

_start:

# Przykladowe kroki.

# Inicjuj zmienne wartosciami poczatkowymi.

mov $0, %rsi # Licznik pozycji czytania (str1) jest zerowany
mov $0, %rdi # Licznik pozycji zapisu (str2) jest zerowany

petla1:

# Usun bledy odczytaj w prawidlowy sposob element ciagu.

mov str1(%rsi), %al # Bajt z ciagu str1 jest ladowany do rejestru AL

# Sprawdz warunek zakonczenia petli - znaku konca ciagu (NULL).

cmp $0, %al # Wartosc bajtu jest porownywana z zerem (NULL)
je koniec # Skok do sekcji konczacej, gdy napotkano koniec ciagu

# Sprawdz czy odczytany znak jest litera ("a" ... "z", wg tablicy ASCII).

cmp $'a', %al # Znak jest porownywany z kodem litery 'a'
jl pomin_znak # Skok jest wykonywany, gdy kod jest mniejszy od 'a'
cmp $'z', %al # Znak jest porownywany z kodem litery 'z'
jg pomin_znak # Skok jest wykonywany, gdy kod jest wiekszy od 'z'

# Jesli tak, zapisz element w miejsce docelowe.

mov %al, str2(%rdi) # Litera jest kopiowana do ciagu str2
inc %rdi # Licznik zapisu jest zwiekszany o jeden

pomin_znak:

# Zaktualizuj odpowiednie liczniki elementow ciagow.

inc %rsi # Licznik czytania jest zawsze zwiekszany o jeden
jmp petla1 # Skok powrotny do poczatku petli jest realizowany

koniec:

# Wyswietl wynik - ciag "str2" wywolujac System Call.

mov $1, %rax # Numer System Call 1 (write) jest ladowany do RAX
mov $1, %rdi # Deskryptor pliku 1 (stdout) jest ladowany do RDI
lea str2(%rip), %rsi # Adres ciagu wynikowego jest ladowany do RSI
mov $9, %rdx # Dlugosc ciagu (8 znakow + \n) jest ladowana do RDX
syscall # Wywolanie systemowe zapisu jest wykonywane

# Wywolaj System Call 60 - EXIT

mov $60, %rax # Numer System Call 60 (exit) jest ladowany do RAX
xor %rdi, %rdi # Kod powrotu 0 jest ladowany do RDI
syscall # Wywolanie systemowe zakonczenia jest wykonywane

#################################################################

# as kol6.s -o kol6.o
# ld kol6.o -o kol6
# ./kol6
