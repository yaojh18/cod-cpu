
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00100293          	li	t0,1
   4:	00200313          	li	t1,2
   8:	00530333          	add	t1,t1,t0
   c:	00530333          	add	t1,t1,t0
  10:	00530333          	add	t1,t1,t0
  14:	800012b7          	lui	t0,0x80001
  18:	0002a303          	lw	t1,0(t0) # 80001000 <__global_pointer$+0x7ffff7d8>
  1c:	00130393          	addi	t2,t1,1
  20:	00130393          	addi	t2,t1,1

00000024 <end>:
  24:	00000063          	beqz	zero,24 <end>
