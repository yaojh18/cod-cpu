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
    sw t1, 0(t2)
    nop
    nop
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