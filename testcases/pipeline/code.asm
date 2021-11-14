
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	800011b7          	lui	gp,0x80001
   4:	100003b7          	lui	t2,0x10000
   8:	00100093          	li	ra,1
   c:	02100113          	li	sp,33
  10:	00001217          	auipc	tp,0x1
  14:	0020f2b3          	and	t0,ra,sp
  18:	00109313          	slli	t1,ra,0x1
  1c:	0011a023          	sw	ra,0(gp) # 80001000 <__global_pointer$+0x7ffff7b0>
  20:	00208e63          	beq	ra,sp,3c <end>
  24:	00238023          	sb	sp,0(t2) # 10000000 <__global_pointer$+0xfffe7b0>
  28:	0001a403          	lw	s0,0(gp) # 1850 <__global_pointer$>
  2c:	0041a223          	sw	tp,4(gp) # 1854 <__global_pointer$+0x4>
  30:	005182a3          	sb	t0,5(gp) # 1855 <__global_pointer$+0x5>
  34:	0061a623          	sw	t1,12(gp) # 185c <__global_pointer$+0xc>
  38:	004004ef          	jal	s1,3c <end>

0000003c <end>:
  3c:	00000063          	beqz	zero,3c <end>
  40:	00000013          	nop
  44:	00000013          	nop
  48:	00000013          	nop
  4c:	00000013          	nop
