    .global _start
    .text
_start:
    addi t0, zero, 1
    addi t1, zero, 1
    lui t2, 0x80001
    nop
    nop
    nop
    nop
    nop
    add t0, t0, t1
    add t1, t0, t0
    nop
    sw t1, 0(t2)
    nop
    lw t0, 0(t2)
    addi a0, t0, 1
    nop
    nop
    j end
    add t0, t0, t1
    lw t2, 0(t2)
    nop
    nop
    nop
end:
    beq x0, x0, end
    nop
    nop
    nop
    nop
