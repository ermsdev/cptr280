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
	dup_00_cases:		.byte		2, 2, 3, 3, 2, 2, 3, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 4, 4, 3

	dup_01:				.byte		0x01, 0x11, 0x00, 0x10
	dup_01_txt:			.asciiz		"bgez   ", "bgezal ", "bltz   ", "bltzal "
	dup_01_cases:		.byte		6, 6, 6, 6 

	dup_10:				.byte		0x00, 0x04
	dup_10_txt:			.asciiz		"mfc0   ", "mtc0   "
	dup_10_cases:		.byte		7, 7

	not_dup_opc:		.byte		0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x20, 0x21, 0x23, 0x24, 0x25, 0x28, 0x29, 0x2B
	not_dup_opc_txt:	.asciiz		"j      ", "jal    ", "beq    ", "bne    ", "blez   ", "bgtz   ", "addi   ", "addiu  ", "slti   ", "sltiu  ", "andi   ", "ori    ", "xori   ", "lui    ", "lb     ", "lh     ", "lw     ", "lbu    ", "lbu    ", "sb     ", "sh     ", "sw     "
	not_dup_cases:		.byte		8, 8, 9, 9, 6, 6, 9, 9, 9, 9, 9, 9, 9, 11, 12, 12, 12, 12, 12, 12, 12, 12

	nl:			.asciiz		"\n"
	tb:			.asciiz		"\t"
	the_nop: 	.asciiz		"nop    "
	dollar:		.asciiz		"$"
	comma:		.asciiz		","
	l_paren:	.asciiz		"("
	r_paren:	.asciiz		")"
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

		jal		check_if_nop				# checks for the special case of nop, which confuses the system for sll
		nop

		jal		print_opc
		nop

	was_nop:							# kinda like TSA Precheck, just for nop, because it's special like that
		la		$a0,	nl
		li		$v0,	4				# syscall_4: print string newline
		syscall

		bne		$s7,	$0,		end		# a 1 in s7 indicates that this was the last loop DO NOT USE s7 WITHOUT PUTTING IT BACK!
		
		addi	$s0,	$s0,	4		# go to next instruction
		j main_loop						# loop again
		nop
### ------

### PRINT OPC : 
	print_opc:		# THIS DOESN'T DO THE PRINTING, IT JUST STARTS THE PROCESS OF PRINTING THE WHOLE INSTRUCTION, NEED TO CHANGE NAME, BUT NOT RIGHT NOW
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)

		li		$a0,	0
		li		$a1,	5	# 0 - 5 are first 6 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$ra,	print_opc_out		# instead of using a jal I'm setting $ra myself becuase I dont want any of these to return where they left off, but I also want to convert everything to proper jumps with links so I can use $sp more consistently 

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
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

### DUP 00 : handles cases where the opcode is 0x00
	dup_00_case:
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)

		# resplice to get the function code (last 6 bits)
		li		$a0,	26
		li		$a1,	31	# 26 - 31 are last 6 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	dup_00_fnc
		la		$t2,	dup_00_fnc_txt
		# make search JAL after adding jr and stack stuff to each case
		jal		search
		nop
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$t7,	dup_00_cases	# base address for the register printing cases
		jal print_regs
		nop

		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

### DUP 01 : handles cases where the opcode is 0x01
	dup_01_case:
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)

		# resplice to get the 5 bits in 3rd field
		li		$a0,	11
		li		$a1,	15	# 11 - 15 are 5 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	dup_01
		la		$t2,	dup_01_txt
		jal		search
		nop
		li		$v0,	4				# syscall_4: print string
		syscall
		
		la		$t7,	dup_01_cases	# base address for the register printing cases
		jal print_regs
		nop

		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop

### ------

### DUP 10 : handles cases where the opcode is 0x10
	dup_10_case:
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)

		# resplice to get the 5 bits in 2nd field
		li		$a0,	6
		li		$a1,	10	# 6 - 10 are 5 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	dup_10
		la		$t2,	dup_10_txt
		jal		search
		nop
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$t7,	dup_10_cases	# base address for the register printing cases
		jal print_regs
		nop

		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

### NOT DUP : handles cases where the opcode is unique
	not_dup_case:
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)
		# resplice to get first 6 bits in the opcode
		# this is a repeat of a splice that was done earlier, but to reduce errors I'm sticking with this less efficient route. once i know it works I may refactor it so as to save the opcode splice instead of resplicing to get the unique opcode again
		li		$a0,	0
		li		$a1,	5	# 0 - 5 are first 6 bits of the register
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$t1,	not_dup_opc
		la		$t2,	not_dup_opc_txt
		jal		search
		nop
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$t7,	not_dup_cases	# base address for the register printing cases
		jal print_regs
		nop

		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

### PRINT REGS : print the rest of the instruction, for R types
	print_regs:
		addi	$sp,	$sp,	-4
		sw 		$ra,	0($sp)

		# we need the base address of the relevant case list (t7)
		# we need the current offset we used to find the opcode txt (t6)
		# use t9 as an immediate register

		add		$t7,	$t7,	$t6	# add the address and the offset to get the address of the case number
		lb		$t6,	0($t7)		# load the case number into t6, it should be safe to clober t6 now that we've gotten the address from it, we wont be using the offset again for the current instruction

		li		$t9,	0
		beq		$t6,	$t9,	c_0
		nop

		li		$t9,	1
		beq		$t6,	$t9,	c_1
		nop

		li		$t9,	2
		beq		$t6,	$t9,	c_2
		nop

		li		$t9,	3
		beq		$t6,	$t9,	c_3
		nop

		li		$t9,	4
		beq		$t6,	$t9,	c_4
		nop

		li		$t9,	5
		beq		$t6,	$t9,	c_5
		nop

		li		$t9,	6
		beq		$t6,	$t9,	c_6
		nop

		li		$t9,	7
		beq		$t6,	$t9,	c_7
		nop

		li		$t9,	8
		beq		$t6,	$t9,	c_8
		nop

		li		$t9,	9
		beq		$t6,	$t9,	c_9
		nop

		li		$t9,	10
		beq		$t6,	$t9,	c_10
		nop

		li		$t9,	11
		beq		$t6,	$t9,	c_11
		nop

		li		$t9,	12
		beq		$t6,	$t9,	c_12
		nop

	print_regs_out:
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	4
		jr		$ra
		nop
### ------

###	D REG : print the register in the third field of the instruction
	d_reg:
		addi	$sp,	$sp,	-8
		sw 		$ra,	0($sp)
		sw		$t0,	4($sp)
		# splice (third field ie. 16-20)
		li		$a0,	16
		li		$a1,	20
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$a0,	dollar
		li		$v0,	4				# syscall_4: print string
		syscall

		move	$a0,	$t0
		li		$v0,	1				# syscall_1: print int
		syscall

		lw		$t0,	-4($sp)
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	8
		jr		$ra
		nop
### ------

### S REG : print the register in the first field of the instruction
	s_reg:
		addi	$sp,	$sp,	-8
		sw 		$ra,	0($sp)
		sw		$t0,	4($sp)
		# splice (first field ie. 6-10)
		li		$a0,	6
		li		$a1,	10
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$a0,	dollar
		li		$v0,	4				# syscall_4: print string
		syscall

		move	$a0,	$t0
		li		$v0,	1				# syscall_1: print int
		syscall

		lw		$t0,	-4($sp)
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	8
		jr		$ra
		nop
### ------

### T REG : print the register in the second field of the instruction
	t_reg:
		addi	$sp,	$sp,	-8
		sw 		$ra,	0($sp)
		sw		$t0,	4($sp)
		# splice (third register to be printed is the second field ie. 11-15)
		li		$a0,	11
		li		$a1,	15
		jal		splice_bits	# splice result stored in $t0
		nop

		la		$a0,	dollar
		li		$v0,	4				# syscall_4: print string
		syscall

		move	$a0,	$t0
		li		$v0,	1				# syscall_1: print int
		syscall

		lw		$t0,	-4($sp)
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	8
		jr		$ra
		nop
### ------

### SHIFT FIELD : print the integer in the fourth field of the instruction
	shift_field:
		addi	$sp,	$sp,	-8
		sw 		$ra,	0($sp)
		sw		$t0,	4($sp)
		# splice (fourth field ie. 21-25)
		li		$a0,	21
		li		$a1,	25
		jal		splice_bits	# splice result stored in $t0
		nop

		move	$a0,	$t0
		li		$v0,	1				# syscall_1: print int
		syscall

		lw		$t0,	-4($sp)
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	8
		jr		$ra
		nop
### ------

### IMM FIELD : print the integer in the immediate field of the instruction
	imm_field:
		addi	$sp,	$sp,	-8
		sw 		$ra,	0($sp)
		sw		$t0,	4($sp)
		# splice (bits 16-31)
		li		$a0,	16
		li		$a1,	31
		jal		splice_bits	# splice result stored in $t0
		nop

		move	$a0,	$t0
		li		$v0,	1				# syscall_1: print int
		syscall

		lw		$t0,	-4($sp)
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	8
		jr		$ra
		nop
### ------

### TARGET FIELD : print the integer in the target field of the instruction
	target_field:
		addi	$sp,	$sp,	-8
		sw 		$ra,	0($sp)
		sw		$t0,	4($sp)
		# splice (bits 6-31)
		li		$a0,	6
		li		$a1,	31
		jal		splice_bits	# splice result stored in $t0
		nop

		move	$a0,	$t0
		li		$v0,	34				# syscall_34: print hex
		syscall

		lw		$t0,	-4($sp)
		lw		$ra,	0($sp)
		addi	$sp,	$sp,	8
		jr		$ra
		nop
### ------

##########################

# THE CASE SYSTEM : 
	# Case Numbers:
	# 0: rd, rs, rt
	# 1: rt, rd, sa
	# 2: rs, rt
	# 3: rs
	# 4: rd
	# 5: rs, rd
	# 6: rs, imm
	# 7: rt, rd
	# 8: target
	# 9: rt, rs, imm
	# 10: No fields
	# 11: rt, imm
	# 12: rt,imm(rs)

### 0 : rd, rs, rt
	c_0:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	d_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall
		
		jal	s_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop
		j		print_regs_out
		nop
### ------

### 1: rd, rt, sa
	c_1:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	d_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	shift_field
		nop
		j		print_regs_out
		nop
### ------

### 2: rs, rt
	c_2:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	s_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop
		j		print_regs_out
		nop
### ------

### 3: rs
	c_3:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	s_reg
		nop
		j		print_regs_out
		nop
### ------

### 4: rd
	c_4:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	d_reg
		nop
		j		print_regs_out
		nop
### ------

### 5: rs, rd
	c_5:

	# I don't know where I got the idea that this case exists, I can't find it in my spreadsheet now... I'll leave this here in case I remember, I'm pretty sure I double checked the others so this shouldn't be indicative of a larger problem

### ------

### 6: rs, imm
	c_6:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal s_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal imm_field
		nop
		j		print_regs_out
		nop
### ------

### 7: rt, rd
	c_7:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	d_reg
		nop
		j		print_regs_out
		nop

### ------

### 8: target
	c_8:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	target_field
		nop
		j		print_regs_out
		nop
### ------

### 9: rt, rs, imm
	c_9:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	s_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	imm_field
		nop
		j		print_regs_out
		nop
### ------

### 10: No fields
	c_10:
		j		print_regs_out
		nop
### ------

### 11: rt, imm
	c_11:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	imm_field
		nop
		j		print_regs_out
		nop
### ------

### 12: rt,imm(rs)
	c_12:
		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	t_reg
		nop

		la		$a0,	comma
		li		$v0,	4				# syscall_4: print string
		syscall

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	imm_field
		nop

		la		$a0,	l_paren
		li		$v0,	4				# syscall_4: print string
		syscall

		jal	s_reg
		nop

		la		$a0,	r_paren
		li		$v0,	4				# syscall_4: print string
		syscall

		j		print_regs_out
		nop
### ------


##########################

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
		move	$t6,	$t3				# saving the offset, because I just realized I'll need it later
		li		$t9,	8				# using t9 as an immediate register
		mult	$t3,	$t9
		mflo	$t3
		add		$a0,	$t3,	$t2		# add new offset and opcode string base address and put in a0 to be printed back in print_opc_out NOT IN OPC_OUT, NEED TO CHANGE NAME
		
		jr		$ra					# jump to $ra
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

### CHECK IF NOP
	check_if_nop:
		bne		$s1,	$0,	not_nop

		la		$a0,	the_nop
		li		$v0,	4				# syscall_4: print string
		syscall

		j		was_nop				# jump to was_nop
		nop

	not_nop:
		jr		$ra						# jump to $ra
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

		la		$a0,	tb
		li		$v0,	4				# syscall_4: print_string
		syscall

		jr		$ra						# jump to $ra
		nop
### ------

### END
	end:
		sll		$t0,	$t0,	5
		li		$v0,	10
		syscall
### ------
