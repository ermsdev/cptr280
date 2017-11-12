# Stephen Ermshar
# CPTR 280
# HW 8
# 2017 NOV 12
# version history: https://github.com/sermshar/cptr280

# To Do
# Write a program in Mips assembly language that calculates the first two or three pairs of amicable numbers. Amicable pairs of numbers have the property that each of the two numbers is the sum of the proper divisors of the other. For example, 220 and 284 form the smallest amicable pair. The proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55, and 110, which sum to 284. The proper divisors of 284 are 1, 2, 4, 71, and 142, which total 220. Note that the use of subroutines will likely ease the task of program design and implementation.
# Your program should follow the steps below:
# • Initialize.
# • Prompt the user to enter an integer: 0 means terminate the program without doing anything, 1 means
# compute the numbers, and all other numbers are rejected.
# • Calculate and display the first two or three pairs of amicable numbers.
# • Print a goodbye message.
# • Terminate.

.data
prompt:		.asciiz		"Enter 1 to begin computation, 0 to quit: "

.text
main:

	la		$a0,		prompt
	li		$v0,		4				# syscall_4: print string
	syscall

	li		$a3,	10

	sum_div:
		# $t9 --> the number we're summing devisors from
		# $t8 --> the number we're checking for devisorship (initialy for deviding input by 2)
		move	$t9,	$a3

		# devide input number by 2 and use it as the start of the list of numbers to check devisorship
		li		$t8,	2
		div		$t9,	$t8				# $t9 / $t0
		mflo	$t8
		addi	$t8,	$t8,	1		# $t8 = $t8 + 1
		
		
		

		check_div:
			div		$t0, 	$t1			# $t0 / $t1
			mfhi	$t8					# will be 0 if division is perfect

			
		bne		$t0, $t1, target	# if $t0 != $t1 then target

		li

		addi	$sp, $sp, 4		# $sp = $sp - 4
		sw		$t1, 0($sp)		# store $tw at stack pointer
