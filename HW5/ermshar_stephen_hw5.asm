# Stephen Ermshar
# CPTR 280
# HW 5
# 2017 OCT 25
# version history: https://github.com/sermshar/cptr280

.data
    in_sz:      .word   16
    out_n:      .ascii  "n: "
    in_n:       .space  16
    out_t:      .ascii  "t: "
    in_t:       .space  16
    out_p:      .ascii  "p: "
    in_p:       .space  16
    out_v:      .ascii  "v: "
    in_v:       .space  16
    data:       .space  16

.text
.globl main

# PART 1
# b) If(t0<0)thent7=0–t0elset7=t0;
    main_1:
        bgez    $t0,    else_1          # branch_on_greater_than_or_zero to main_2
        sub     $t7,    $0,     $t0     # $t7 = 0 - $t0
    else_1:
        move    $t7,    $t0

# c) while(t0!=0){s1=s1+t0;t2=t2+4;t0=mem(t2)}; 
    loop_0:
        add     $s1,    $s1,    $t0
        addi    $t2,    $t2,    4
        la      $t2,    data
        lw      $t0,    0($t2)
        bne     $t0,    $0,     loop_0

# d) for(t1=99;t1>0;t1=t1–1) v0=v0+t1;
        li      $t1,    99
    loop_f:
        add     $v0,    $v0,    $t1
        addi    $t1,    $t1,    -1
        bgez    $t1,    loop_f

# PART 2
    main_3:                                 # collect user input
        li      $v0,    4                   # syscall_4 = print_string_$a0 (n)
        la      $a0,    out_n
        syscall
        li      $v0,    5                   # syscall_1 = read_int (n)
        syscall
        move    $s0,    $v0                 # n saved at $s0

        li      $v0,    4                   # syscall_4 = print_string_$a0 (n)
        la      $a0,    out_t
        syscall
        li      $v0,    5                   # syscall_1 = read_int (n)
        syscall
        move    $s1,    $v0                 # t saved at $s1

        li      $v0,    4                   # syscall_4 = print_string_$a0 (n)
        la      $a0,    out_p
        syscall
        li      $v0,    5                   # syscall_1 = read_int (n)
        syscall
        move    $s2,    $v0                 # p saved at $s2

    main_4:                                 # calculate ideal gas
        mult    $s0,    $s1                 # $s0 * s1 = Hi and Lo registers
        mflo	$t0                         # copy Lo to $t0

        div     $t0,    $s2                 # $t0 / $s1
        mflo    $t0                         # integer quotient to $t0

        li      $t1,    8314
        li      $t2,    1000
        div     $t1,    $t2
        mflo    $t3

        mult    $t0,    $t3
        mflo    $s4

        la      $a0,    out_v
        li      $v0,    4
        syscall

        move    $a0,    $s4
        li      $v0,    1
        syscall
        
        

# END PROGRAM
        li      $v0,    10              # syscall_10 = end_program
        syscall