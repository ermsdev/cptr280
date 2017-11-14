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
	bye:        .asciiz     "Program Ended"

.text
	main:
		la		$a0,	prompt
		li		$v0,	4				# syscall_4: print string
		syscall
		li		$v0,	5				# syscall_5: read int
		syscall
		move	$s0,	$v0
		blt		$s0,	$0,		end		# end if user enters negative number

		move	$a0,	$s0	
	factorial:
		move	$t0,	$a0
		

	end:
		la		$a0,		bye
		li		$v0,		4				# syscall_4: print string
		syscall

		li		$v0,	10				# syscall_10: terminate program
		syscall