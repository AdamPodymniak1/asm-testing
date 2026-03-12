.global _start

.data

arr: .long 0x1234, 0x56789, 0xabcdef1, 0x12345678 # LONG IS 4 BYTE LONG
# STRING ARRAY IN SEPARATE VARS TO HAVE POINTERS TO EVERY VALUE
str1: .asciz "First"
str2: .asciz "Second"
str3: .asciz "Third"

.text
_start:

# FIXED SIZE NUMERICAL ARRAY
lea (arr), %rsi # LOAD POINTER TO THE FIRST ELEMENT OF ARRAY
mov $2, %rbx # LET THIS BE OUR INDEX
mov (%rsi, %rbx, 4), %eax # TO MOVE TO DIFFERENT ELEMENT IN ARRAY WE NEED TO MULTIPLY THE INDEX WITH THE BYTE SIZE (arr[3] == arr[ptr + index * size])

# STRING ARRAY WITH HARD CODED PADDING
lea (str1), %rsi
lea 0x30(%rsi), %rdi # PADDING OF VALUE 30 TO PUT THERE THE NEXT STRING
mov %rsi, (%rdi) # SAVE POINTER OF THE FIRST STRING
# MOVE AND SAVE THE SECOND STRINGS POINTER
add $8, %rdi
lea (str2), %rsi
mov %rsi, (%rdi)
# MOVE AND SAVE THE THIRD STRINGS POINTER
add $8, %rdi
lea (str3), %rsi
mov %rsi, (%rdi)

exit:
mov $60, %rax
xor %rdi, %rdi
syscall
