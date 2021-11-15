
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	80001537          	lui	a0,0x80001
   4:	06400313          	li	t1,100
   8:	00650223          	sb	t1,4(a0) # 80001004 <__global_pointer$+0x7ffff7ac>
   c:	06f00313          	li	t1,111
  10:	00650423          	sb	t1,8(a0)
  14:	06e00313          	li	t1,110
  18:	00650623          	sb	t1,12(a0)
  1c:	06500313          	li	t1,101
  20:	00650823          	sb	t1,16(a0)
  24:	02100313          	li	t1,33
  28:	00650a23          	sb	t1,20(a0)
  2c:	100005b7          	lui	a1,0x10000
  30:	80001337          	lui	t1,0x80001
  34:	01430313          	addi	t1,t1,20 # 80001014 <__global_pointer$+0x7ffff7bc>

00000038 <loop1>:
  38:	00450513          	addi	a0,a0,4
  3c:	00050383          	lb	t2,0(a0)

00000040 <loop2>:
  40:	00558283          	lb	t0,5(a1) # 10000005 <__global_pointer$+0xfffe7ad>
  44:	0202f293          	andi	t0,t0,32
  48:	fe028ce3          	beqz	t0,40 <loop2>
  4c:	00758023          	sb	t2,0(a1)
  50:	fe6514e3          	bne	a0,t1,38 <loop1>

00000054 <end>:
  54:	00000063          	beqz	zero,54 <end>
