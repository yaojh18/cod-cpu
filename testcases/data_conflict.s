    .global _start
    .text
_start:
    addi t0, zero, 1
    addi t1, zero, 2
    add t2, t0, t1
end:
    beq x0, x0, end
    nop
    nop