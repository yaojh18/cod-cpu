
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00100293          	li	t0,1
   4:	00100313          	li	t1,1
   8:	800013b7          	lui	t2,0x80001
   c:	00000013          	nop
  10:	00000013          	nop
  14:	00000013          	nop
  18:	00000013          	nop
  1c:	00000013          	nop
  20:	00000013          	nop
  24:	00000013          	nop
  28:	00000013          	nop
  2c:	006282b3          	add	t0,t0,t1
  30:	00528333          	add	t1,t0,t0
  34:	00000013          	nop
  38:	00000013          	nop
  3c:	00000013          	nop
  40:	0063a023          	sw	t1,0(t2) # 80001000 <__global_pointer$+0x7ffff790>
  44:	0180006f          	j	5c <end>
  48:	006282b3          	add	t0,t0,t1
  4c:	0003a383          	lw	t2,0(t2)
  50:	00000013          	nop
  54:	00000013          	nop
  58:	00000013          	nop

0000005c <end>:
  5c:	00000063          	beqz	zero,5c <end>
  60:	00000013          	nop
  64:	00000013          	nop
  68:	00000013          	nop
  6c:	00000013          	nop
