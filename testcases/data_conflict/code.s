    .global _start
    .text
_start:
    addi t0, zero, 1
    addi t1, zero, 2
    add t1, t1, t0
    add t1, t1, t0
    add t1, t1, t0
    lui t0, 0x80001
    lw t1, 0(t0)
    addi t2, t1, 1
    addi t2, t1, 1
end:
    beqz zero, end
