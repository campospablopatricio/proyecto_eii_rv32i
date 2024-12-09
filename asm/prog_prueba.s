.section .text.reset
.global reset
reset:
    addi t0,zero,36
    addi t1,zero,0
    addi t2,zero,8
    jal zero,L2
L1:
    sw t1,0(t0)
    addi t0,t0,4
    addi t1,t1,1
L2:
    blt t1,t2,L1
L3:
    jal zero,L3
.bss
datos: .word 0,0,0,0,0,0,0,0
