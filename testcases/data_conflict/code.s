    .global _start
    .text
_start:
    lui t0, 0x80001
    add t1, zero, 2
    sw t1, 0(t0)
    lw t2, 0(t0)
    add t2, t1, t2
end:
    beq x0, x0, end
    nop
    nop
