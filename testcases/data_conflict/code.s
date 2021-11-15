    .global _start
    .text
_start:
    lui a0, 0x80001
    addi t1, zero, 0x64
    sb t1,4(a0)
    addi t1, zero, 0x6f
    sb t1,8(a0)
    addi t1, zero, 0x6e
    sb t1,12(a0)
    addi t1, zero, 0x65
    sb t1,16(a0)
    addi t1, zero, 0x21
    sb t1,20(a0)
    lui a1, 0x10000
    lui t1, 0x80001
    addi t1, t1, 20

loop1:
    addi a0, a0, 4
    lb t2, 0(a0)

loop2:
    lb t0, 5(a1)
    andi t0, t0, 32
    beqz t0, loop2

    sb t2, 0(a1)
    bne a0, t1, loop1

end:
    beqz zero, end
