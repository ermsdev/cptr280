# Stephen Ermshar
# CPTR 280
# HW 9
# 2017 NOV 17
# version history: https://github.com/sermshar/cptr280

# PROMPT:
# Write a program to compute factorial(n). You must use stack frames as discussed in class and your program must be recursive in nature.

# C++ code:
# fact_recur(int n) {
#     if (n == 0 || n == 1)
#         return 1;
#     else
#         return n * fact_recur(n - 1);
# }

.data
	prompt:     .asciiz     "Enter a positive integer to find its factorial: " 
	bye:        .asciiz     "\nProgram Ended"

.text
.globl main
	main:
		la		$a0,	prompt
		li		$v0,	4				# syscall_4: print string
		syscall
		li		$v0,	5				# syscall_5: read int
		syscall
		move	$a0,	$v0
		blt		$a0,	$0,		end		# end if user enters negative number
		nop

		li		$a0,	4
		jal		factorial
		nop

	end:
		move	$a0,	$v0
		li		$v0,	1				# syscall_4: print string
		syscall

		la		$a0,	bye
		li		$v0,	4				# syscall_4: print string
		syscall

		li		$v0,	10				# syscall_10: terminate program
		syscall

	factorial:
		addi	$sp,	$sp, -12	# adjust stack for 3 items
		sw		$ra,	8($sp)		# save the return address
		sw		$fp,	4($sp)		# save the frame pointer
		sw		$a0,	0($sp)		# save the argument n
		move	$fp,	$sp			# initialize the frame pointer

		slti 	$t0,	$a0,	1	# test for n < 1
		beq		$t0,	$0,		L1	# if n >= 1, go to L1
		nop

		addi	$v0,	$0, 	1	# if n < 1, return 1
		addi	$sp,	$sp,	12	# pop 3 items off stack
		jr		$ra
		nop

	L1:
		addi	$a0,	$a0,	-1
		jal 	factorial
		nop

									# return from jal: 
		lw		$a0,	0($sp)		# restore argument n
		lw		$fp,	4($sp)		# restore the frame pointer
		lw		$ra,	8($sp)		# restore the return address
		addi	$sp,	$sp,	12	# adjust stack pointer to pop 3 items

		mul		$v0,	$a0,	$v0	# return n * fact(n-1)

		jr $ra						# return to the caller
		nop