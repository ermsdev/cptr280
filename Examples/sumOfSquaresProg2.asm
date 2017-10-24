## Program to compute the sum of squares (i^2) i=1..4
## Register usage
	
	.text
	.globl main

main:
	subu	$sp, $sp, 4	# make space for parameters on stack (1 words)
    				# $sp = $sp - 4

	#			# sw $register offset($base-adress)
	#			# store the resiter offset bytes from the base-adress
	sw	$ra, 0($sp)	# save register $ra on stack

    	move	$s0, $zero	# $s0 : i
	move	$s1, $zero	# $s1 : sum

loop:
	mul	$t0, $s0, $s0	# Compute i^2
	addu	$s1, $s1, $t0	# Accumulate sum
	addiu	$s0, $s0, 1	# Increase i
	ble	$s0, 4, loop	# Loop control
				# if (i <= 4) goto loop

	#			# Prepare to print result
	li	$v0,4		# load syscall option: 4 = print string
	la	$a0, str	# load the string address into $a0 (argument)
	syscall			# call syscall.

	li	$v0,1		# same idea, load syscall option: 1 = print integer
	move	$a0, $s1
	syscall			# call syscall.

	li	$v0,4		# once again.
	la	$a0, newl	# print text in newline as a string
	syscall

	#			# free space on stack, and jump back to the original $ra
	lw	$ra, 0($sp)	# Restore register 31
	addu	$sp, $sp, 4	# Pop stack
	jr	$ra		# return

	# Here data is stored
	.data
str:
	.asciiz	"\nThe sum of i^2 from 1 .. 4 = "
newl:
	.asciiz	"\n"
