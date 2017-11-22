# Stephen Ermshar
# CPTR 280
# Final Project
# 2017 DEC 11
# version history: https://github.com/sermshar/cptr280

.data
# http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html
# used a spreadsheet and textwrangler to turn the table in the link into these two lines
# TODO: try pre-sorting these and using a binary search
    opc:        .byte   0x20, 0x21, 0x08, 0x09, 0x24, 0x0C, 0x1A, 0x1B, 0x18, 0x19, 0x27, 0x25, 0x0D, 0x00, 0x04, 0x03, 0x07, 0x02, 0x06, 0x22, 0x23, 0x26, 0x0E, 0x19, 0x18, 0x2A, 0x29, 0x0A, 0x09, 0x04, 0x07, 0x06, 0x05, 0x02, 0x03, 0x09, 0x08, 0x20, 0x24, 0x21, 0x25, 0x23, 0x28, 0x29, 0x2B, 0x10, 0x12, 0x11, 0x13, 0x1A
    opc_txt:    .asciiz "add", "addu", "addi", "addiu", "and", "andi", "div", "divu", "mult", "multu", "nor", "or", "ori", "sll", "sllv", "sra", "srav", "srl", "srlv", "sub", "subu", "xor", "xori", "lhi", "llo", "slt", "sltu", "slti", "sltiu", "beq", "bgtz", "blez", "bne", "j", "jal", "jalr", "jr", "lb", "lbu", "lh", "lhu", "lw", "sb", "sh", "sw", "mfhi", "mflo", "mthi", "mtlo", "trap"

    prompt:     .asciiz "enter the integer decimal representation of an opcode: "
    prompt2:    .asciiz "success"
    prompt3:    .asciiz "fail"
.text
    main:
        la		$a0,	prompt
        li		$v0,	4				# syscall_4: print string
        syscall

        li		$v0,	5				# syscall_4: print string
        syscall 
        move 	$s0,    $v0

        la		$s1, opc
        lb		$s2, 0($s1)

        beq		$s2, $s0, target	# if $s2 == $t1 then target
        nop
        bne		$s2, $s0, target2
        nop
        j end
        nop

    target:
        la		$a0,	prompt2
        li		$v0,	4				# syscall_4: print string
        syscall
        j end
        nop

    target2:
        la		$a0,	prompt3
        li		$v0,	4				# syscall_4: print string
        syscall

    end:
        li		$v0, 10		# $v0 =10 
        syscall
    
        

# use shifts and bools to compare non-byte aligned patterns
#   get first 8 bits (byte) of instruction
#   shift right logical so the last 6 bits of selected byte are the opcode
#   use boolean to compare to opcode table
#   return the offset of the opcode in the table
#   use the offset to find the corresponding ascii opcode
#   