
code.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	80100437          	lui	s0,0x80100
   4:	00000493          	li	s1,0
   8:	55555537          	lui	a0,0x55555
   c:	55550513          	addi	a0,a0,1365 # 55555555 <__global_pointer$+0x55553bf9>
  10:	12800593          	li	a1,296
  14:	d4a6e637          	lui	a2,0xd4a6e
  18:	7c160613          	addi	a2,a2,1985 # d4a6e7c1 <__global_pointer$+0xd4a6ce65>
  1c:	00a42023          	sw	a0,0(s0) # 80100000 <__global_pointer$+0x800fe6a4>
  20:	00b42223          	sw	a1,4(s0)
  24:	00c42423          	sw	a2,8(s0)
  28:	00442583          	lw	a1,4(s0)
  2c:	00842603          	lw	a2,8(s0)
  30:	01040193          	addi	gp,s0,16

00000034 <t_slli>:
  34:	0085f293          	andi	t0,a1,8
  38:	02028c63          	beqz	t0,70 <t_xor>
  3c:	ffff0337          	lui	t1,0xffff0
  40:	00031313          	slli	t1,t1,0x0
  44:	00000393          	li	t2,0
  48:	02731463          	bne	t1,t2,70 <t_xor>
  4c:	00010337          	lui	t1,0x10
  50:	fff30313          	addi	t1,t1,-1 # ffff <__global_pointer$+0xe6a3>
  54:	00031313          	slli	t1,t1,0x0
  58:	01000393          	li	t2,16
  5c:	00731a63          	bne	t1,t2,70 <t_xor>
  60:	00061313          	slli	t1,a2,0x0
  64:	0061a023          	sw	t1,0(gp) # 195c <__global_pointer$>
  68:	00418193          	addi	gp,gp,4 # 1960 <__global_pointer$+0x4>
  6c:	0084e493          	ori	s1,s1,8

00000070 <t_xor>:
  70:	0205f293          	andi	t0,a1,32
  74:	04028a63          	beqz	t0,c8 <t_sltu>
  78:	ffff0337          	lui	t1,0xffff0
  7c:	00230313          	addi	t1,t1,2 # ffff0002 <__global_pointer$+0xfffee6a6>
  80:	00300393          	li	t2,3
  84:	00734333          	xor	t1,t1,t2
  88:	000303b7          	lui	t2,0x30
  8c:	00238393          	addi	t2,t2,2 # 30002 <__global_pointer$+0x2e6a6>
  90:	02731c63          	bne	t1,t2,c8 <t_sltu>
  94:	00300313          	li	t1,3
  98:	ffff13b7          	lui	t2,0xffff1
  9c:	11238393          	addi	t2,t2,274 # ffff1112 <__global_pointer$+0xfffef7b6>
  a0:	00734333          	xor	t1,t1,t2
  a4:	111203b7          	lui	t2,0x11120
  a8:	00338393          	addi	t2,t2,3 # 11120003 <__global_pointer$+0x1111e6a7>
  ac:	00731e63          	bne	t1,t2,c8 <t_sltu>
  b0:	aaaa53b7          	lui	t2,0xaaaa5
  b4:	55538393          	addi	t2,t2,1365 # aaaa5555 <__global_pointer$+0xaaaa3bf9>
  b8:	00764333          	xor	t1,a2,t2
  bc:	0061a023          	sw	t1,0(gp) # 195c <__global_pointer$>
  c0:	00418193          	addi	gp,gp,4 # 1960 <__global_pointer$+0x4>
  c4:	0204e493          	ori	s1,s1,32

000000c8 <t_sltu>:
  c8:	1005f293          	andi	t0,a1,256
  cc:	04028e63          	beqz	t0,128 <tret>
  d0:	00000313          	li	t1,0
  d4:	ff0003b7          	lui	t2,0xff000
  d8:	00733333          	sltu	t1,t1,t2
  dc:	00100393          	li	t2,1
  e0:	04731463          	bne	t1,t2,128 <tret>
  e4:	12340337          	lui	t1,0x12340
  e8:	02000393          	li	t2,32
  ec:	00733333          	sltu	t1,t1,t2
  f0:	123403b7          	lui	t2,0x12340
  f4:	00138393          	addi	t2,t2,1 # 12340001 <__global_pointer$+0x1233e6a5>
  f8:	02731863          	bne	t1,t2,128 <tret>
  fc:	12340337          	lui	t1,0x12340
 100:	01f00393          	li	t2,31
 104:	00733333          	sltu	t1,t1,t2
 108:	923403b7          	lui	t2,0x92340
 10c:	00731e63          	bne	t1,t2,128 <tret>
 110:	aaaa5337          	lui	t1,0xaaaa5
 114:	55530313          	addi	t1,t1,1365 # aaaa5555 <__global_pointer$+0xaaaa3bf9>
 118:	00c33333          	sltu	t1,t1,a2
 11c:	0061a023          	sw	t1,0(gp) # 195c <__global_pointer$>
 120:	00418193          	addi	gp,gp,4 # 1960 <__global_pointer$+0x4>
 124:	1004e493          	ori	s1,s1,256

00000128 <tret>:
 128:	feed02b7          	lui	t0,0xfeed0
 12c:	0092e2b3          	or	t0,t0,s1
 130:	00542023          	sw	t0,0(s0)
 134:	00342623          	sw	gp,12(s0)
 138:	801002b7          	lui	t0,0x80100
 13c:	0002a303          	lw	t1,0(t0) # 80100000 <__global_pointer$+0x800fe6a4>
 140:	0042a303          	lw	t1,4(t0)
 144:	0082a303          	lw	t1,8(t0)
 148:	00c2a303          	lw	t1,12(t0)
 14c:	0102a303          	lw	t1,16(t0)
 150:	0142a303          	lw	t1,20(t0)
 154:	0182a303          	lw	t1,24(t0)

00000158 <end>:
 158:	0000006f          	j	158 <end>
