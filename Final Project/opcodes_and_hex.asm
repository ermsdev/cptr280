.data
dup_00_fnc:			.byte		0x1A, 0x1B, 0x11, 0x13, 0x18, 0x19, 0x08, 0x0C, 0x0D, 0x20, 0x21, 0x24, 0x27, 0x25, 0x2A, 0x2B, 0x22, 0x23, 0x26, 0x00, 0x04, 0x03, 0x07, 0x02, 0x06, 0x10, 0x12, 0x09
dup_00_fnc_txt:		.asciiz		"div    ", "divu   ", "mthi   ", "mtlo   ", "mult   ", "multu  ", "jr     ", "syscall", "break  ", "add    ", "addu   ", "and    ", "nor    ", "or     ", "slt    ", "sltu   ", "sub    ", "subu   ", "xor    ", "sll    ", "sllv   ", "sra    ", "srav   ", "srl    ", "srlv   ", "mfhi   ", "mflo   ", "jalr   "

dup_01:				.byte		0x01, 0x11, 0x00, 0x10
dup_01_txt:			.asciiz		"bgez   ", "bgezal ", "bltz   ", "bltzal "

dup_10:				.byte		0x00, 0x04
dup_10_txt:			.asciiz		"mfc0   ", "mtc0   "

not_dup_opc:		.byte		0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x20, 0x21, 0x23, 0x24, 0x25, 0x28, 0x29, 0x2B
not_dup_opc_txt:	.asciiz		"j      ", "jal    ", "beq    ", "bne    ", "blez   ", "bgtz   ", "addi   ", "addiu  ", "slti   ", "sltiu  ", "andi   ", "ori    ", "xori   ", "lui    ", "lb     ", "lh     ", "lw     ", "lbu    ", "lbu    ", "sb     ", "sh     ", "sw     "