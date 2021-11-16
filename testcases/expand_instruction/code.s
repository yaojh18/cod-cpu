    .global _start
    .text
_start:
    addi t0, zero, 0x123
    addi t1, zero, 0x456
    slli t2, t1, 0
end:
    beq x0, x0, end