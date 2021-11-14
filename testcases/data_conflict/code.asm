
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	800012b7          	lui	t0,0x80001
   4:	00200313          	li	t1,2
   8:	0062a023          	sw	t1,0(t0) # 80001000 <__global_pointer$+0x7ffff7e0>
   c:	0002a383          	lw	t2,0(t0)
  10:	007303b3          	add	t2,t1,t2

00000014 <end>:
  14:	00000063          	beqz	zero,14 <end>
  18:	00000013          	nop
  1c:	00000013          	nop
