    .org 0x0
    .global _start
    .text
_start:
    li t0, 0x0
    li t1, 0x0
    li a0, 0x80000100
    li a1, 0x64
loop:
    addi t1, t1, 0x1
    add t0, t0, t1
    bne t1, a1, loop
    sw t0, 0x0(a0)
save_chars:
    li t1, 0x64
    sb t1, 0x4(a0)
    li t1, 0x6f
    sb t1, 0x8(a0)
    li t1, 0x6e
    sb t1, 0xc(a0)
    li t1, 0x65
    sb t1, 0x10(a0)
    li t1, 0x21
    sb t1, 0x14(a0)
init_write_serial:
    li a1, 0x10000000
    li t1, 0x80000114
write_serial_start:
    addi a0, a0, 0x4
    lb t2, 0x0(a0)
write_serial_wait:
    lb t0, %lo(0x5)(a1)
    andi t0, t0, 0x20
    beq t0, x0, write_serial_wait
write_serial:
    sb t2, 0x0(a1)
    bne a0, t1, write_serial_start
end:
    beq x0, x0, end
