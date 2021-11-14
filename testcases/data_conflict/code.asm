
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00100293          	li	t0,1
   4:	00200313          	li	t1,2
   8:	006283b3          	add	t2,t0,t1

0000000c <end>:
   c:	00000063          	beqz	zero,c <end>
  10:	00000013          	nop
  14:	00000013          	nop
