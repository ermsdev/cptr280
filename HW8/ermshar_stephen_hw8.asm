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
space:		.asciiz		" "
nl:			.asciiz		"\n"
amicable:	.asciiz		" AMICABLE PAIR FOUND"

.text
main:
	# t0 --> artificial immediate (for instructions that don't support immediate values)

#--------------------------------------------------------------------
# welcome message: prompts beginning of computation
# BEGIN
#--------------------------------------------------------------------
	la		$a0,	prompt
	li		$v0,	4				# syscall_4: print string
	syscall

	li		$v0,	5				# syscall_5: read int
	syscall

	beq		$v0,	$0,		end		# end if user enters 0
	li		$t0,	1
	bne		$v0,	$t0,	main	# start over if user doesn't enter a 1 (or a 0 as a result of last instruction)
#--------------------------------------------------------------------
# END
# welcome message: prompts beginning of computation
#--------------------------------------------------------------------

# t1: n
# t2: s(n)


	li		$t1,	1
list_nums:

	addi	$t1,	$t1,	1

	move 	$a3,	$t1
	jal		sum_divs		# find s(n) (ristricted divisor function)
	nop

	move	$t2,	$v1		# put s(n) in t2 and print

	li	$t0,	1						# if s(n) = 1 go on to the next n
	beq	$t2, $t0, list_nums
	nop

	move 	$a3,	$t2
	jal		sum_divs		# find s(s(n)) = s(t2)
	nop
	
	move	$t3,	$v1		# put s(n) in t2 and print

	bne		$t1, $t3, list_nums	# if $t0 != $t1 then target
	nop
	beq		$t1, $t2, list_nums
	nop

	move	$a0,	$t1		# print n
	li		$v0,	1
	syscall

	la		$a0,		space
	li		$v0,		4
	syscall

	move 	$a0,	$t2
	li		$v0,		1
	syscall

	la		$a0,		space
	li		$v0,		4				# syscall_4: print string
	syscall

	move 	$a0,	$t3
	li		$v0,		1
	syscall

	la		$a0,		amicable
	li		$v0,		4				# syscall_4: print string
	syscall

	# if s(n) = 1 do nothing here
	# if s(n) != 1, find s(s(n))
	# if s(s(n)) = n mark as amicable

	la		$a0,		nl
	li		$v0,		4				# syscall_4: print string
	syscall

new_line:
	j	list_nums
	nop

#--------------------------------------------------------------------
# sum_divs subroutine: input $a3, sums all proper devisors of input
# BEGIN
#--------------------------------------------------------------------
sum_divs:
	# t9: input to find devisors of
	# t8: potential devisor of t9
	# t7: sum of devisors
	move 	$t9,	$a3				# t9 <-- a3
	li		$t8,	1
	li		$t7,	1

check_sum_divs:
	addi	$t8, $t8, 1
	div		$t9, $t8
	mfhi	$t6
	mflo	$t5
	bne		$t6, $0, check_sum_divs
	nop
	blt		$t5, $t8, sum_out	# if $t5 < $t8 then check_sum_divs
	nop
	add		$t7, $t7, $t8
	beq		$t5, $t8, check_sum_divs
	nop
	add		$t7, $t7, $t5
	j		check_sum_divs				# jump to target
	nop

sum_out:
	move	$v1,	$t7
	# j		end
	# nop
	jr		$ra				# jump to ra, allows register jumps from branch instructions
	nop
#--------------------------------------------------------------------
# END
# sum_divs subroutine: input $a3, sums all proper devisors of input
#--------------------------------------------------------------------

end:
	li		$v0,	10				# syscall_10: terminate program
	syscall