## Program to compute the sum of squares (i^2) i=1..4
	
	.text
	.globl main
	
main:
    	move	$s0, $zero	# $s0 : i
	move	$s1, $zero	# $s1 : sum
loop:
	mul	$t0, $s0, $s0	# Compute i^2
	addu	$s1, $s1, $t0	# Accumulate sum
	addi	$s0, $s0, 1	# Increase i
	ble	$s0, 4, loop	# Loop control if (i <= 4) goto loop
#	end of loop

#	Print result
	
	# Print string "\nThe sum of i^2 from 1 .. 4 = "
	li	$v0,4		# load syscall option: 4 = print string
	la	$a0, str	# load the string address into $a0 (argument)
	syscall			# call syscall.

	# Print integer (should be 30 ...)
	li	$v0,1		# same idea, load syscall option: 1 = print integer
	move	$a0, $s1
	syscall			# call syscall.

	# Print string "\n"
	li	$v0,4		# once again.
	la	$a0, newl	# print text in newline as a string
	syscall

	# Here data is stored
	.data
str:
	.asciiz	"\nThe sum of i^2 from 1 .. 4 = "
newl:
	.asciiz	"\n"
