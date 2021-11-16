
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	12300293          	li	t0,291
   4:	45600313          	li	t1,1110
   8:	00031393          	slli	t2,t1,0x0

0000000c <end>:
   c:	00000063          	beqz	zero,c <end>
