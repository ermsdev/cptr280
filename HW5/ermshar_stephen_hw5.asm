# Stephen Ermshar
# CPTR 280
# HW 5
# 2017 OCT 25
# version history: https://github.com/sermshar/cptr280

.data

.text
.globl main
    main:
# PART 1
# b) If(t0<0)thent7=0–t0elset7=t0;
        bltz    $t0,    less_0          # branch_on_less_than_zero to less_0
        j       main_2                  # else jump to main_2
    less_0:
        sub     $t7,    $0,     $t0     # $t7 = 0 - $t0
    main_2:
        move    $t7,    $t0

# c) while(t0!=0){s1=s1+t0;t2=t2+4;t0=mem(t2)}; 
    loop_0:
        add     $s1,    $s1,    $t0
        addi    $t2,    $t2,    4
        lw      $t0,    0($t2)
        bne     $t0,    $0,     loop_0

# d) for(t1=99;t1>0;t1=t1–1) v0=v0+t1;
        li      $t1,    99
    loop_f:
        add     $v0,    $v0,    $t1
        addi    $t1,    $t1,    -1
        bgez    $t1,    loop_f