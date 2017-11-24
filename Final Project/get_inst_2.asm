# Stephen Ermshar
# CPTR 280
# Final Project : get inst 2
# 2017 NOV 24
# version history: https://github.com/sermshar/cptr280

.data
	nl:		.asciiz		"\n"
.text
	main:
		la		$s0,	0x00400000		# start with the first instruction
	
	main_loop:
		jal		get_inst				# get the instruction
		nop
		jal		print_inst				# print the instruction (integer)
		nop

		addi	$s0,	$s0,	4		# $t0 = $t1 + 0
		
		j main_loop						# loop again
		nop

	get_inst:
		lw		$s1,	0($s0)			# copy instruction into $s1
		jr		$ra						# jump to $ra
		nop

	print_inst:
		move	$a0,	$s1				# move instruction to be printed
		li		$v0,	34				# syscall_1: print int
		syscall

		la		$a0,	nl
		li		$v0,	4				# syscall_4: print string
		syscall

		jr		$ra						# jump to $ra
		nop


	end:
		li		$v0,	10
		syscall
