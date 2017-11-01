# addthree.asm --- print sum of three integers
# This program illustrates simple subroutine linkage
# QTSpim settings: Load delays ON; Branch delays ON; Trap file OFF; Pseudoinstructions ON

.text
.globl main

main:
   jal pread		# read first integer
   nop
   move $s0,$v0	# save it in $s0
   jal pread		# read second integer
   nop
   move $s1,$v0	# save it in $s1
   jal pread		# read third integer
   nop
   move $s2,$v0	# save it in $s2
   addu $s0,$s0,$s1	# compute the sum
   addu $a0,$s0,$s2
   li $v0,1		# print the sum
   syscall
   li $v0,10		# exit
   syscall 

# pread -- subroutine to prompt for and read an integer
# on entry:
#    $ra -- return address
# on exit:
#    $v0 -- the integer

.text
.globl pread

pread:
   la $a0,prompt	# print string
   li $v0,4		# service 4
   syscall
   li $v0,5		# read int into $v0
   syscall		# service 5
   jr $ra			# return
   nop			# branch delay slot

   .data
   prompt:
            .asciiz "Enter an integer: "

