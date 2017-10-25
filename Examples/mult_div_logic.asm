## Program is example code to illustrate multiply, divide, logic, shift, etc. instructions

.data			# data section - default start address is 0x10010000

   value:	.word 0b1010, 0b0101
   p41b:	.word 20, 105, 4
   p41c:	.word 'a'
	
.text 		# text section
.globl main	# call main by QTSpim

main:
	# Multiply and divide examples
	li $t0, 10
	li $t1, 20
	li $t2, -5
	mult $t1, $t0
	mflo $t4
	mfhi $t5
	mult $t2, $t0
	multu $t2, $t0
	mul $t6, $t1, $t0		# With overflow exception
	mul $t6, $t2, $t0
	nop
	div $t1, $t0		# Divides $t1 by $t2
	div $t0, $t1
	divu $t1, $t2
	divu $t2, $t1

	li $t0, 0x00005555	# hexadecimal
	li $t1, 0x0000aaaa
	li $t3, 5
	and $t2, $t1, $t0
	or $t2, $t1, $t0
	xor $t2, $t1, $t0
	nor $t2, $t1, $t0
	ori $t2, $t1, 0x5555

	sll $t2, $t1, 5
	sllv $t2, $t1, $t3
	srl $t2, $t1, 4
	sra $t2, $t1, 4

	ror $t2, $t1, 4
	
