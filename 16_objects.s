.global _start

.data

# ALL OBJECTS HAVE: base => starting point, stride => size of each object
# struct {x, y}
point:
.long 0x123, 0x456 # LONG = 4 BYTES
.long 0xaaaa, 0xbbbb
.long 0xcccc, 0xdddd
.long 0xeeee, 0xffff
.long 0x1111, 0x2222

.text
_start:

mov $4, %rax # GET OBJECT OF INDEX 4
mov $8, %rbx # THIS IS STRIDE
imul %rax, %rbx # GET THE STRIDE FOR ELEMENT AT INDEX 4
lea point(,%rax), %rcx # ADD STRIDE TO BASE
mov 4(%rcx), %edx # MOVE FROM x TO y

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
