# Stephen Ermshar
# CPTR 280
# HW 4
# 2017 OCT 18

.text
.globl main
    main:
        # a) t3=t4+t5–t6;
        li      $t4,    20
        li      $t5,    30
        li      $t6,    40
        add     $t3,    $t4,    $t5
        sub     $t3,    $t3,    $t6

        # b) s3 = t2/(s1 – 5);
        li      $s1,    20
        li      $t2,    105
        li      $t0,    5
        sub     $s3,    $s1,    $t0
        div     $t2,    $s3             # how do div and mflo work?
        mflo    $s4

        # c) sp=sp–16;
        addi $sp, $sp, -16

        # d) cout << t3;
        li      $t3,    'a'
        move    $a0,    $t3
        li      $v0,    1               # syscall_1 = print_int_$a0
        syscall

        # e) cin >> t0;
        li      $v0,    5               # syscall_1 = read_int
        syscall
        move    $t0,    $v0

        # f) a0 = &array;
        la      $a0,    array1          # load base address of array1 into $t0, not sure if that's what this is asking for

        # g) t8 = mem(a0);
                                        # not sure what this is asking for

        # h) mem(a0 + 16) = 32768;
                                        # not sure what this is asking for

        # i) Cout << “Hello World”;
        li      $a0,    hello
        li      $v0,    4               # syscall_4 = print_string_$a0
        syscall

        # j) t0 = 2147483647 – 2147483648;
        li      $t0,    2147483647
        addi    $t0,    $t0,    -2147483648

        # k) s0=-1*s0;
        li      $t0,    -1
        mult    $t0,    $s0             # $t0 * $s0 = Hi and Lo registers
        mflo    $s0                     # copy $Lo to $s0

        # l) s1=s1*a0;
        mult    $a0,    $s1
        mflo    $s1                     #copy $Lo to $s0

        # m) s2=s4*8;
        li      $t0,    8
        mult    $s4,    $t0             # $s4 * $t0 = Hi and Lo registers
        mflo    $s2                     # copy $Lo to $s2


.data
    array1: .space  12                  # allocate 3 words (12 bytes)
    hello:  .asciiz "Hello World"