.section  .note.GNU-stack, "", @progbits

.globl gcd

.text

.type	gcd,@function

gcd:
sub	$8 , %rsp

# Zabezpiecz odpowiednie rejestry przed nadpisaniem
# i wywolaj print_call.

push %rdi
push %rsi

call print_call

pop %rsi
pop %rdi

# Algorytm Euklidesa:
#
# unsigned int GCD(unsigned int a, unsigned int b) 
# { 
#   if (b==0) return a; 
#   else GCD(b, a % b); 
# } 

cmp $0, %esi # Sprawdzanie, czy b=0?
je return_gcd

xor %edx, %edx # Zerowanie, bo dzielenie przechodzi też na EDX (Modulo)
mov %edi, %eax
div %esi # Dzielenie EDI na ESI (a / b)
mov %esi, %edi # drugi argument na miejsce pierwszego
mov %edx, %esi # Modulo jako drugi argument

call gcd

return_gcd:

# Zabezpiecz odpowiednie rejestry przed nadpisaniem
# i wywolaj print_ret.

push %rdi
push %rsi

call print_ret

pop %rsi
pop %rdi

# Zwroc obliczona wartosc w %eax.

mov %edi, %eax # Pierwszy argument funkcji zwracany w EAX

add	$8 , %rsp
ret
