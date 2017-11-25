# Stephen Ermshar
# CPTR 280
# Final Project : get inst 2
# 2017 NOV 24
# version history: https://github.com/sermshar/cptr280

.data
	# https://opencores.org/project,plasma,opcodes
	# used a spreadsheet and textwrangler to turn the table in the link into these two lines
	# NOTE: many instructions share a common initial 6 bits, like sycall and sll (000000) and differ in the last bits.
    

	nl:		.asciiz		"\n"
.text
	main:
		la		$s0,	0x00400000		# start with the first instruction

### MAIN LOOP
	main_loop:
		add		$s7,	$0,		$0			# set s7 to 0 in case it got messed with

		jal		get_inst					# get the instruction and PUT IT IN $s1
		nop

		jal 	check_if_last				# check if it's the last instruction, print it and quit if it is
		nop

		jal		print_hex_inst				# print the instruction (hex integer)
		nop

		# jal		print_opc
		# nop

		la		$a0,	nl
		li		$v0,	4				# syscall_4: print string newline
		syscall

		bne		$s7,	$0,		end		# a 1 in s7 indicates that this was the last loop DO NOT USE s7 WITHOUT PUTTING IT BACK!
		
		addi	$s0,	$s0,	4		# go to next instruction
		j main_loop						# loop again
		nop
### ------

### PRINT OPC : 
	print_opc:
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)
		# cases to be handled:
		#	duplicate initial 6 bits
		#		instruction types
		#			R, I, J
		# how they will be handled
		#	6 bit duplicates:
		#		0x00 : check last 6 bits for function code
		#		0x01 : check 5 bits in 3rd field
		#		0x10 : check 5 bits in 2nd field
		#		all other 6 bits opcodes are non-duplicates and can be checked directly

		# branch to get_opc
		# branch depending on case
		# return ascii value address

		li		$a0,	0
		li		$a1,	5	# 0 - 5 are first 6 bits of the register
		jal		splice_bits
		nop

		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

### SPLICE BITS : returns bits a0 to a1 (0 index) of the current instruction to t0 as the least significant bits of the register
	splice_bits:
		sllv	$t0,	$s1,	$a0
		li		$t1,	31
		sub		$a1,	$t1,	$a1
		add		$a1,	$a1,	$a0
		srlv	$t0,	$t0,	$a1
		jr		$ra					# jump to $ra
		nop
### ------

### CHECK IF LAST : checks if the current instruction is the last one, if it is it sets s7 to 1, otherwise it returns without changing anythin
	check_if_last:
		li		$t0,	0xC				# immediate register : syscall bitpattern
		bne		$s1,	$t0,	not_last_out
		nop
		li		$t0,	0x2402000A		# immediate register : instruction that would have loaded 10 into $v0
		lw		$t1,	-4($s0)			# load the last instruction into $t1
		bne		$t0,	$t1,	not_last_out	# if the last instruction is not the expected one that would load 10 into $v0, then this is not the end
		nop
		li		$s7,	1				# a 1 in s7 will indicate to the program that this is the last instruction
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

		jr		$ra						# jump to $ra
		nop
### ------

### END
	end:
		li		$v0,	10
		syscall
### ------
