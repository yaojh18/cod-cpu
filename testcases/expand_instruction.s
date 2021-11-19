    .globl _start
    .text
_start:
    li s0, 0x80100000
    li s1, 0
    lui a0, 0x55555
    addi a0, a0, 0x555
    addi a1, zero, 0x128
    lui a2, 0xd4a6e
    addi a2, a2, 0x7c1
    sw a0, 0(s0)
    sw a1, 4(s0)
    sw a2, 8(s0)
    lw a1, 4(s0) # selection
    lw a2, 8(s0) # random
    addi gp, s0, 0x10 # gp = s0 + 0x10
t_slli:
    andi t0, a1, 8
    beqz t0, t_xor # skip test

    li  t1, 0xFFFF0000
    slli t1, t1, 0
    li  t2, 0
    bne t1, t2, t_xor

    li  t1, 0x0000FFFF
    slli t1, t1, 0
    li  t2, 16
    bne t1, t2, t_xor

    slli t1, a2, 0
    sw t1, 0(gp) # *gp = slli(a2)
    addi gp, gp, 4
    ori s1, s1, 8
t_xor:
    andi t0, a1, 32
    beqz t0,  t_sltu # skip test

    li t1, 0xFFFF0002
    li t2, 3
    xor t1, t1, t2
    li t2, 0x00030002
    bne t1, t2, t_sltu

    li t1, 0x00000003
    li t2, 0xFFFF1112
    xor t1, t1, t2
    li t2, 0x11120003
    bne t1, t2, t_sltu

    li t2, 0xAAAA5555
    xor t1, a2, t2
    sw t1, 0(gp) # *gp = xor(a2, 0xAAAA5555)
    addi gp, gp, 4
    ori s1, s1, 32
t_sltu:
    andi t0, a1, 256
    beqz t0, tret # skip test

    li t1, 0x00000000
    li t2, 0xFF000000
    sltu t1, t1, t2
    li t2, 0x00000001
    bne t1, t2, tret

    li t1, 0x12340000
    li t2, 32
    sltu t1, t1, t2
    li t2, 0x12340001
    bne t1, t2, tret

    li t1, 0x12340000
    li t2, 31
    sltu t1, t1, t2
    li t2, 0x92340000
    bne t1, t2, tret

    li t1, 0xAAAA5555
    sltu t1, t1, a2
    sw t1, 0(gp) # *gp = sltu(0xAAAA5555, a2)
    addi gp, gp, 4
    ori s1, s1, 256
tret:
    li t0, 0xfeed0000
    or t0, t0, s1
    sw t0, 0(s0) # *s0 = t0
    sw gp, 0xc(s0) # *(s0+0xc) = gp
    lui t0, 0x80100
    lw t1, 0(t0)
    lw t1, 4(t0)
    lw t1, 8(t0)
    lw t1, 12(t0)
    lw t1, 16(t0)
    lw t1, 20(t0)
    lw t1, 24(t0)


end:
    j  end