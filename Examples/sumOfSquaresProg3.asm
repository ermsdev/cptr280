## Program to compute the sum of squares (i^2) i=1..4
## Massive usage of memory.
	
	.text
 	.globl main

main:
	subu	$sp, $sp, 16	# make space for parameters on stack (4 words)
    				# $sp = $sp - 16

	#			# sw $register offset($base-adress)
	#			# store the resiter offset bytes from the base-adress

	sw	$ra, 0($sp)	# save register $ra on stack
	sw	$a0, 4($sp)	# save register $a0 on stack
	sw	$zero, 8($sp)	# zero position 8 on stack (i)
	sw	$zero, 12($sp)	# zero position 12 on stack (sum)

loop:
	lw	$t0, 8($sp)	# load i from memory
	#			# load word - same idea as store word
	mul	$t1, $t0, $t0	# Compute i^2
	lw	$t2, 12($sp)	# load sum from memory
	addu	$t2, $t2, $t1	# Accumulate sum
	sw	$t2, 12($sp)	# save sum to memory
	addu	$t0, $t0, 1	# Increase i
	sw	$t0, 8($sp)	# save i to memory
	ble	$t0, 4, loop	# Loop control

	#			# Prepare to print result
	li	$v0,4		# load syscall option: 4 = print string
	la	$a0, str	# load the string address into $a0 (argument)
	syscall			# call syscall.

	li	$v0,1		# same idea, load syscall option: 1 = print integer
	lw	$a0,12($sp)	# load integer to be printed to $a0 (argument)
	syscall			# call syscall.

	li	$v0,4		# once again.
	la	$a0, newl	# print text in newline as a string
	syscall

	#			# free space on stack, and jump back to the original $ra
	lw	$ra, 0($sp)	# Restore register 31
	addu	$sp, $sp, 16	# Pop stack
	jr	$ra		# return

	# Here data is stored
	.data
str:
	.asciiz	"\nThe sum of i^2 from 1 .. 4 = "
newl:
	.asciiz	"\n"

