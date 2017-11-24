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

### MAIN LOOP
	main_loop:
		jal		get_inst				# get the instruction
		nop

		jal check_if_last
		nop

		jal		print_hex_inst				# print the instruction (integer)
		nop


		addi	$s0,	$s0,	4		# go to next instruction

		j main_loop						# loop again
		nop
### ------

## CHECK IF LAST : checks if the current instruction is the last one, if it is it prints it and jumps to end
	check_if_last:
		li		$t0,	0xC				# immediate register : syscall bitpattern
		bne		$s1,	$t0,	not_last_out
		li		$t0,	0x2402000A		# immediate register : instruction that would have loaded 10 into $v0
		lw		$t1,	-4($s0)			# load the last instruction into $t1
		bne		$t0,	$t1,	not_last_out	# if the last instruction is not the expected one that would load 10 into $v0, then this is not the end
		jal		print_hex_inst			# if it passes the first two branches then it's reached the end, print and quit
		nop
		j		end						
		nop
	not_last_out:
		jr		$ra						# jump to $ra
		nop
### ------

### GET INST : loads the current instruction into a register
	get_inst:
		lw		$s1,	0($s0)			# copy instruction into $s1
		jr		$ra						# jump to $ra
		nop
### ------

### PRINT HEX INST : prints the hex of each instruction
	print_hex_inst:
		move	$a0,	$s1				# move instruction to be printed
		li		$v0,	34				# syscall_1: print int
		syscall

		la		$a0,	nl
		li		$v0,	4				# syscall_4: print string
		syscall

		jr		$ra						# jump to $ra
		nop
### ------

### END
	end:
		li		$v0,	10
		syscall
### ------
