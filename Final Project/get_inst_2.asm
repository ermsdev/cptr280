# Stephen Ermshar
# CPTR 280
# Final Project : get inst 2
# 2017 NOV 24
# version history: https://github.com/sermshar/cptr280

.data
	# https://opencores.org/project,plasma,opcodes
	# used a spreadsheet and textwrangler to turn the table in the link into these two lines
	# NOTE: many instructions share a common initial 6 bits, like sycall and sll (000000) and differ in the last bits.

	# TODO: add special case for nop, where the entire instruction is 0x0, check for nop before checking for dup_00 becuase sll has 0x00 as its first and last 6 bits, a nop would be interpreted as an sll

	dup_00_fnc:			.byte		0x1A, 0x1B, 0x11, 0x13, 0x18, 0x19, 0x08, 0x0C, 0x0D, 0x20, 0x21, 0x24, 0x27, 0x25, 0x2A, 0x2B, 0x22, 0x23, 0x26, 0x00, 0x04, 0x03, 0x07, 0x02, 0x06, 0x10, 0x12, 0x09
	dup_00_fnc_txt:		.asciiz		"div    ", "divu   ", "mthi   ", "mtlo   ", "mult   ", "multu  ", "jr     ", "syscall", "break  ", "add    ", "addu   ", "and    ", "nor    ", "or     ", "slt    ", "sltu   ", "sub    ", "subu   ", "xor    ", "sll    ", "sllv   ", "sra    ", "srav   ", "srl    ", "srlv   ", "mfhi   ", "mflo   ", "jalr   "

	dup_01:				.byte		0x01, 0x11, 0x00, 0x10
	dup_01_txt:			.asciiz		"bgez   ", "bgezal ", "bltz   ", "bltzal "

	dup_10:				.byte		0x00, 0x04
	dup_10_txt:			.asciiz		"mfc0   ", "mtc0   "

	not_dup_opc:		.byte		0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x20, 0x21, 0x23, 0x24, 0x25, 0x28, 0x29, 0x2B
	not_dup_opc_txt:	.asciiz		"j      ", "jal    ", "beq    ", "bne    ", "blez   ", "bgtz   ", "addi   ", "addiu  ", "slti   ", "sltiu  ", "andi   ", "ori    ", "xori   ", "lui    ", "lb     ", "lh     ", "lw     ", "lbu    ", "lbu    ", "sb     ", "sh     ", "sw     "

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

		jal		print_opc
		nop

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

		# branch to splice_opc
		# branch depending on case (check dup cases first, then check use whatever's remaining)
		# return ascii value address

		li		$a0,	0
		li		$a1,	5	# 0 - 5 are first 6 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		beq		$t0,	$0,		dup_00_case		# if opcode is 0x00, then $t0 will be all 0, no need to create an immediate register
		nop

		li		$t1,	0x01				# immediate register to see if opcode is 0x01
		beq		$t0,	$t1,	dup_01_case
		nop

		li		$t1,	0x10
		beq		$t0,	$t1,	dup_10_case
		nop

		j not_dup_case							# if the first 6 bits don't fit in the first three conditionals, they must not be from a dup set
		nop

	print_opc_out:
		li		$v0,	4				# syscall_4: print string
		syscall
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

### DUP 00 : handles cases where the opcode is 0x00
	dup_00_case:
		# resplice to get the function code (last 6 bits)
		li		$a0,	26
		li		$a1,	31	# 26 - 31 are last 6 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	dup_00_fnc
		la		$t2,	dup_00_fnc_txt
		j		search
		nop
### ------

### DUP 01 : handles cases where the opcode is 0x01
	dup_01_case:
		# resplice to get the 5 bits in 3rd field
		li		$a0,	11
		li		$a1,	15	# 11 - 15 are 5 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	dup_01
		la		$t2,	dup_01_txt
		j		search
		nop
### ------

### DUP 10 : handles cases where the opcode is 0x10
	dup_10_case:
		# resplice to get the 5 bits in 2nd field
		li		$a0,	6
		li		$a1,	10	# 6 - 10 are 5 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	dup_10
		la		$t2,	dup_10_txt
		j		search
		nop
### ------

### NOT DUP : handles cases where the opcode is unique
	not_dup_case:
		# resplice to get first 6 bits in the opcode
		# this is a repeat of a splice that was done earlier, but to reduce errors I'm sticking with this less efficient route. once i know it works I may refactor it so as to save the opcode splice instead of resplicing to get the unique opcode again
		li		$a0,	0
		li		$a1,	5	# 0 - 5 are first 6 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	not_dup_opc
		la		$t2,	not_dup_opc_txt
		j		search
		nop
### ------

### SEARCH : takes two base addresses ($t1 and $t2) and searches the first set for one that matches the current bitpattern splice ($t0), then returns the corresponding text
	search:
		li		$t3,	0
	search_loop:
		# $t4 : address of the current bitpattern from list in .data
		# $t5 : current bitpattern from list in .data
		add		$t4,	$t3,	$t1		# add the offset and base address of opcode bitpatterns
		lb		$t5,	0($t4)			# load the opcode bitpattern from .data, occupies the last 6 digits of the register

		beq		$t5, $t0, search_found     # if the opcode from the current instruction matchest the current opcode from .data go to found
		nop

		addi	$t3,	$t3,	1	# otherwise increment the offset and...
		j search_loop				# check again
		nop

	search_found:
		li		$t9,	8				# using t9 as an immediate register
		mul		$t3,	$t3,	$t9		# multiply offset by 8, text opcodes are 8-byte-aligned, also its ok to clober the offset register becaue we're done searching through .data for the moment
		add		$a0,	$t3,	$t2		# add new offset and opcode string base address and put in a0 to be printed back in print_opc_out
		
		j print_opc_out
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
