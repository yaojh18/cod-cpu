    .org 0x0
    .global _start
    .text
_start:
    li x3, 0x80001000
    li x7, 0x10000000
    li x1, 0x1
    li x2, 0x21
    auipc x4, 0x1
    and x5, x1, x2
    slli x6, x1, 0x1
    sw x1, 0x0(x3)
    beq x1, x2, end
    sb x2, 0x0(x7)
    lw x8, 0x0(x3)
    sw x4, 0x4(x3)
    sb x5, 0x5(x3)
    sw x6, 0xc(x3)
    jal x9, end
end:
    beq x0, x0, end
    nop
    nop
    nop
    nop
