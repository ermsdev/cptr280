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

.text
main:
	# t0 --> artificial immediate (for instructions that don't support immediate values)

#--------------------------------------------------------------------
# welcome message: prompts beginning of computation
# BEGIN
#--------------------------------------------------------------------
	# la		$a0,	prompt
	# li		$v0,	4				# syscall_4: print string
	# syscall

	# li		$v0,	5				# syscall_5: read int
	# syscall

	# beq		$v0,	$0,		end		# end if user enters 0
	# li		$t0,	1				# $t1 = 1
	# bne		$v0,	$t0,	main	# start over if user doesn't enter a 1 (or a 0 as a result of last instruction)
#--------------------------------------------------------------------
# END
# welcome message: prompts beginning of computation
#--------------------------------------------------------------------

# 	li		$t1,	219

# search_n:
# 	addi	$t1,	$t1,	1
# 	move 	$a3,	$t1
# 	jal		sum_divs
# 	nop
# 	move 	$t2,	$v1
# 	move	$a3,	$t2
# 	jal		sum_divs
# 	nop
# 	move 	$t3,	$v1
# 	beq		$t1, $t3, print_pair
# 	nop
# 	j		search_n				# jump to search_n
# 	nop


# print_pair:
# 	move	$a0,	$t1
# 	li		$v0,	1				# syscall_4: print string
# 	syscall

# 	la		$a0,		space
# 	li		$v0,		4				# syscall_4: print string
# 	syscall

# 	move	$a0,	$t2
# 	li		$v0,	1				# syscall_4: print string
# 	syscall

# 	jr		$ra				# jump to ra, allows register jumps from branch instructions
# 	nop

	li		$a3,	1
list_nums:
	addi	$a3,	$a3,	1

	move	$a0,	$a3
	li		$v0,	1
	syscall

	la		$a0,		space
	li		$v0,		4				# syscall_4: print string
	syscall

	jal		sum_divs
	nop

	move 	$a0,	$v1
	li		$v0,		1
	syscall

	la		$a0,		nl
	li		$v0,		4				# syscall_4: print string
	syscall

	j	list_nums
	nop




jal		sum_divs				# jump to sum_divs and save position to $ra
nop

move	$a0,	$v1
li		$v0,	1
syscall

j		end				# jump to end

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
	addi	$t8, $t8, 1			# 8 = $t1 + 0
	div		$t9, $t8			# t9 / t8
	mfhi	$t6					# $t6 = 9 mod $t1 
	mflo	$t5					# $t5 = floor(9 / $t1) 
	bne		$t6, $0, check_sum_divs
	nop
	blt		$t5, $t8, sum_out	# if $t5 < $t8 then check_sum_divs
	nop
	add		$t7, $t7, $t8		# $t0 = $t1 + $t5
	beq		$t5, $t8, check_sum_divs	# if 2 == $t1 then target
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