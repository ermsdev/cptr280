# Stephen Ermshar
# CPTR 280
# Final Project : get inst 2
# 2017 NOV 24
# version history: https://github.com/sermshar/cptr280

.data
	# https://opencores.org/project,plasma,opcodes
	# used a spreadsheet and textwrangler to turn the table in the link into these two lines
	# NOTE: many instructions share a common initial 6 bits, like sycall and sll (000000) and differ in the last bits.
    opc:        .byte   0x00, 0x08, 0x09, 0x00, 0x00, 0x0C, 0x0F, 0x00, 0x00, 0x0D, 0x00, 0x0A, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x01, 0x07, 0x06, 0x01, 0x01, 0x05, 0x00, 0x02, 0x03, 0x00, 0x00, 0x10, 0x10, 0x00, 0x20, 0x24, 0x21, 0x25, 0x23, 0x28, 0x29, 0x2B
    opc_txt:    .asciiz "add (0)", "addi   ", "addiu  ", "addu   ", "and    ", "andi   ", "lui    ", "nor    ", "or     ", "ori    ", "slt    ", "slti   ", "sltiu  ", "sltu   ", "sub    ", "subu   ", "xor    ", "xori   ", "sll    ", "sllv   ", "sra    ", "srav   ", "srl    ", "srlv   ", "div    ", "divu   ", "mfhi   ", "mflo   ", "mthi   ", "mtlo   ", "mult   ", "multu  ", "beq    ", "bgez   ", "bgezal ", "bgtz   ", "blez   ", "bltz   ", "bltzal ", "bne    ", "break  ", "j      ", "jal    ", "jalr   ", "jr     ", "mfc0   ", "mtc0   ", "syscall", "lb     ", "lbu    ", "lh     ", "lbu    ", "lw     ", "sb     ", "sh     ", "sw     "

	nl:		.asciiz		"\n"
.text
	main:
		la		$s0,	0x00400000		# start with the first instruction

### MAIN LOOP
	main_loop:
		jal		get_inst					# get the instruction
		nop

		jal 	check_if_last				# check if it's the last instruction, print it and quit if it is
		nop

		jal		print_hex_inst				# print the instruction (hex integer)
		nop

		# jal		print_opc
		nop

		la		$a0,	nl
		li		$v0,	4				# syscall_4: print string newline
		syscall

		addi	$s0,	$s0,	4		# go to next instruction
		j main_loop						# loop again
		nop
### ------

### PRINT OPC : 
	print_opc:
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

		jr		$ra						# jump to $ra
		nop
### ------

### END
	end:
		li		$v0,	10
		syscall
### ------
