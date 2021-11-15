
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00000293          	li	t0,0
   4:	00000313          	li	t1,0
   8:	80000537          	lui	a0,0x80000
   c:	10050513          	addi	a0,a0,256 # 80000100 <__global_pointer$+0x7fffe888>
  10:	06400593          	li	a1,100

00000014 <loop>:
  14:	00130313          	addi	t1,t1,1
  18:	006282b3          	add	t0,t0,t1
  1c:	feb31ce3          	bne	t1,a1,14 <loop>
  20:	00552023          	sw	t0,0(a0)

00000024 <save_chars>:
  24:	06400313          	li	t1,100
  28:	00650223          	sb	t1,4(a0)
  2c:	06f00313          	li	t1,111
  30:	00650423          	sb	t1,8(a0)
  34:	06e00313          	li	t1,110
  38:	00650623          	sb	t1,12(a0)
  3c:	06500313          	li	t1,101
  40:	00650823          	sb	t1,16(a0)
  44:	02100313          	li	t1,33
  48:	00650a23          	sb	t1,20(a0)

0000004c <init_write_serial>:
  4c:	100005b7          	lui	a1,0x10000
  50:	80000337          	lui	t1,0x80000
  54:	11430313          	addi	t1,t1,276 # 80000114 <__global_pointer$+0x7fffe89c>

00000058 <write_serial_start>:
  58:	00450513          	addi	a0,a0,4
  5c:	00050383          	lb	t2,0(a0)

00000060 <write_serial_wait>:
  60:	00558283          	lb	t0,5(a1) # 10000005 <__global_pointer$+0xfffe78d>
  64:	0202f293          	andi	t0,t0,32
  68:	fe028ce3          	beqz	t0,60 <write_serial_wait>

0000006c <write_serial>:
  6c:	00758023          	sb	t2,0(a1)
  70:	fe6514e3          	bne	a0,t1,58 <write_serial_start>

00000074 <end>:
  74:	00000063          	beqz	zero,74 <end>
