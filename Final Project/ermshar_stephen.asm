# Stephen Ermshar
# CPTR 280
# Final Project
# 2017 DEC 11
# version history: https://github.com/sermshar/cptr280

.data
# http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html
    opc:    .byte   10011001, 10011001, 10011001, 10011001


.text
    main:
# use shifts and bools to compare non-byte aligned patterns
#   get first 8 bits (byte) of instruction
#   shift right logical so the last 6 bits of selected byte are the opcode
#   use boolean to compare to opcode table
#   return the offset of the opcode in the table
#   use the offset to find the corresponding ascii opcode
#   