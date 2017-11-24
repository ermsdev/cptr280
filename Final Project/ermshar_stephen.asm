# Stephen Ermshar
# CPTR 280
# Final Project
# 2017 DEC 11
# version history: https://github.com/sermshar/cptr280

.data
# https://opencores.org/project,plasma,opcodes
# used a spreadsheet and textwrangler to turn the table in the link into these two lines
# TODO: try pre-sorting these and using a binary search
# NOTE: many instructions share a common initial 6 bits, like sycall and sll (000000) and differ in the last bits.
    opc:        .byte   0x00, 0x0F, 0x09, 0x00, 0x00, 0x0C, 0x0F, 0x00, 0x00, 0x0D, 0x00, 0x0A, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x01, 0x07, 0x06, 0x01, 0x01, 0x05, 0x00, 0x02, 0x03, 0x00, 0x00, 0x10, 0x10, 0x00, 0x20, 0x24, 0x21, 0x25, 0x23, 0x28, 0x29, 0x2B
    opc_txt:    .asciiz "add (0) ", "addi    ", "addiu   ", "addu    ", "and     ", "andi    ", "lui     ", "nor     ", "or      ", "ori     ", "slt     ", "slti    ", "sltiu   ", "sltu    ", "sub     ", "subu    ", "xor     ", "xori    ", "sll     ", "sllv    ", "sra     ", "srav    ", "srl     ", "srlv    ", "div     ", "divu    ", "mfhi    ", "mflo    ", "mthi    ", "mtlo    ", "mult    ", "multu   ", "beq     ", "bgez    ", "bgezal  ", "bgtz    ", "blez    ", "bltz    ", "bltzal  ", "bne     ", "break   ", "j       ", "jal     ", "jalr    ", "jr      ", "mfc0    ", "mtc0    ", "syscall ", "lb      ", "lbu     ", "lh      ", "lbu     ", "lw      ", "sb      ", "sh      ", "sw      "

    prompt: .asciiz "enter the integer decimal representation of an opcode: "
    scs:    .asciiz "success"
    fail:   .asciiz "fail"
    nl:     .asciiz "\n"

    # load current instruction
    # shift, find, and print the opc_txt
    #   if 6bit opc is 0, compare the end bits before printing
    # 
    # determine instruction format
    # double shift, appropriately, print for each field



.text
    main:
        # SAVED
        # $s0 : ADDRESS of current instruction to decode
        # TEMPORARY (used immeiately after declaration)
        # : opc_txt to be printed

        la		$s0,    0x00400000      # start with the first instruction


    read_inst:
        # $s1 : curent instruction

        # load current instruction
        lw      $s1,    0($s0)
    
        jal     print_opc
        nop

    # end protection
    end:
        li		$v0,    10 
        syscall


    print_opc:
        # $t0 : 8 bit (2 leading 0's) opcode from current instruction

        # shifts current instruction, finds it's matching opc_txt pirnts it

        srl     $t0,    $s1,    26      # shift the current instruction to front-opc



        # base address of opcode bitpatterns
        la      $t1,    opc
        # base address of opcode strings
        la      $t2,    opc_txt
        # offset for search loop
        li      $t3,    0
    print_opc_search:
        # $t4 : address of the current bitpattern from list in .data
        # $t5 : current bitpattern from list in .data
        add		$t4,    $t3,    $t1       # add the offset and base address of opcode bitpatterns
        lb      $t5,    0($t4)      # load the opcode bitpattern from .data, occupies the last 6 digits of the register

        beq		$t5, $t0, print_opc_found     # if the opcode from the current instruction matchest the current opcode from .data go to found
        nop

        addi    $t3,    $t3,    1   # otherwise increment the offset and...
        # bne     $t5,    $t0,    print_opc_search              # check again
        j print_opc_search  # check again
        nop

    print_opc_found:
        li      $t9,    8               # using t9 as an immediate register
        mul     $t3,    $t3,    $t9     # multiply offset by 8, text opcodes are 8-byte-aligned, also its ok to clober the offset register becaue we're done searching through .data for the moment
        add     $a0,    $t3,    $t2     # add new offset and opcode string base address and put in a0 to be printed
        li		$v0,	4				# syscall_4: print string
        syscall

    print_opc_exit_opc:
        jr      $ra                     # return
        nop

    # end protection
    j end

    # main:
        la		$a0,	prompt
        li		$v0,	4				# syscall_4: print string
        syscall

        li		$v0,	5				# syscall_5: read int
        syscall 
        move 	$s0,    $v0             # save input to $s0

        # base address of opcode bitpatterns
        la      $s1,    opc
        # base address of opcode strings
        la      $s2,    opc_txt
        # offset for search loop
        li      $s3,    0
    # search:
        add		$s4, $s3, $s1       # add the offset and base address of opcode bitpatterns
        # $s4 is now the address of the current bitpattern
        lw      $s5,    0($s4)
        # $s5 is now the current instruction bitpattern
        srl     $t0,    $s5,    26  # get the first 6 bits
        # $t0 is now the current 6 bit opcode (last 6 bits of the new 32-bit-word are the opcode)



        beq		$s5, $s0, found     # if the input and the current bitpattern are the same, branch to found
        nop
        # bne     $s3, $s0, n_found
        # nop
        addi    $s3,    $s3,    1   # otherwise increment the offset and...
        j		search              # check again
        

    # found:
        li      $t0,    8
        mult    $s3,    $t0
        mflo    $s3
        add     $a0,    $s3,    $s2     # add offset * 2 and opcode string base address
        li		$v0,	4				# syscall_4: print string
        syscall

        j end
        nop

    # n_found:
        la		$a0,	fail
        li		$v0,	4				# syscall_4: print string
        syscall
        j end

    # end:
        li		$v0, 10		# $v0 =10 
        syscall
    
        

# use shifts and bools to compare non-byte aligned patterns
#   get first 8 bits (byte) of instruction
#   shift right logical so the last 6 bits of selected byte are the opcode
#   use boolean to compare to opcode table
#   return the offset of the opcode in the table
#   use the offset to find the corresponding ascii opcode
#   