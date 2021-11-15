
kernel.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <INITLOCATE>:
80000000:	00000d17          	auipc	s10,0x0
80000004:	00cd0d13          	addi	s10,s10,12 # 8000000c <START>
80000008:	000d0067          	jr	s10

8000000c <START>:
8000000c:	007f0d17          	auipc	s10,0x7f0
80000010:	ff4d0d13          	addi	s10,s10,-12 # 807f0000 <_sbss>
80000014:	007f0d97          	auipc	s11,0x7f0
80000018:	104d8d93          	addi	s11,s11,260 # 807f0118 <_ebss>

8000001c <bss_init>:
8000001c:	01bd0863          	beq	s10,s11,8000002c <bss_init_done>
80000020:	000d2023          	sw	zero,0(s10)
80000024:	004d0d13          	addi	s10,s10,4
80000028:	ff5ff06f          	j	8000001c <bss_init>

8000002c <bss_init_done>:
8000002c:	00800117          	auipc	sp,0x800
80000030:	fd410113          	addi	sp,sp,-44 # 80800000 <KERNEL_STACK_INIT>
80000034:	807f02b7          	lui	t0,0x807f0
80000038:	007f0317          	auipc	t1,0x7f0
8000003c:	fcc30313          	addi	t1,t1,-52 # 807f0004 <uregs_sp>
80000040:	00532023          	sw	t0,0(t1)
80000044:	007f0317          	auipc	t1,0x7f0
80000048:	fd830313          	addi	t1,t1,-40 # 807f001c <uregs_fp>
8000004c:	00532023          	sw	t0,0(t1)
80000050:	100002b7          	lui	t0,0x10000
80000054:	00700313          	li	t1,7
80000058:	00628123          	sb	t1,2(t0) # 10000002 <INITLOCATE-0x6ffffffe>
8000005c:	08000313          	li	t1,128
80000060:	006281a3          	sb	t1,3(t0)
80000064:	00c00313          	li	t1,12
80000068:	00628023          	sb	t1,0(t0)
8000006c:	000280a3          	sb	zero,1(t0)
80000070:	00300313          	li	t1,3
80000074:	006281a3          	sb	t1,3(t0)
80000078:	00028223          	sb	zero,4(t0)
8000007c:	00100313          	li	t1,1
80000080:	006280a3          	sb	t1,1(t0)
80000084:	08000293          	li	t0,128
80000088:	ffc28293          	addi	t0,t0,-4
8000008c:	ffc10113          	addi	sp,sp,-4
80000090:	00012023          	sw	zero,0(sp)
80000094:	fe029ae3          	bnez	t0,80000088 <bss_init_done+0x5c>
80000098:	007f0297          	auipc	t0,0x7f0
8000009c:	06828293          	addi	t0,t0,104 # 807f0100 <TCBT>
800000a0:	0022a023          	sw	sp,0(t0)
800000a4:	00010f93          	mv	t6,sp
800000a8:	08000293          	li	t0,128
800000ac:	ffc28293          	addi	t0,t0,-4
800000b0:	ffc10113          	addi	sp,sp,-4
800000b4:	00012023          	sw	zero,0(sp)
800000b8:	fe029ae3          	bnez	t0,800000ac <bss_init_done+0x80>
800000bc:	007f0297          	auipc	t0,0x7f0
800000c0:	04428293          	addi	t0,t0,68 # 807f0100 <TCBT>
800000c4:	0022a223          	sw	sp,4(t0)
800000c8:	002fa223          	sw	sp,4(t6)
800000cc:	007f0397          	auipc	t2,0x7f0
800000d0:	03838393          	addi	t2,t2,56 # 807f0104 <TCBT+0x4>
800000d4:	0003a383          	lw	t2,0(t2)
800000d8:	007f0317          	auipc	t1,0x7f0
800000dc:	03830313          	addi	t1,t1,56 # 807f0110 <current>
800000e0:	00732023          	sw	t2,0(t1)
800000e4:	0040006f          	j	800000e8 <WELCOME>

800000e8 <WELCOME>:
800000e8:	00001517          	auipc	a0,0x1
800000ec:	06c50513          	addi	a0,a0,108 # 80001154 <monitor_version>
800000f0:	32c000ef          	jal	ra,8000041c <WRITE_SERIAL_STRING>
800000f4:	0040006f          	j	800000f8 <SHELL>

800000f8 <SHELL>:
800000f8:	344000ef          	jal	ra,8000043c <READ_SERIAL>
800000fc:	05200293          	li	t0,82
80000100:	06550863          	beq	a0,t0,80000170 <.OP_R>
80000104:	04400293          	li	t0,68
80000108:	0a550263          	beq	a0,t0,800001ac <.OP_D>
8000010c:	04100293          	li	t0,65
80000110:	0c550e63          	beq	a0,t0,800001ec <.OP_A>
80000114:	04700293          	li	t0,71
80000118:	10550c63          	beq	a0,t0,80000230 <.OP_G>
8000011c:	05400293          	li	t0,84
80000120:	00550863          	beq	a0,t0,80000130 <.OP_T>
80000124:	00400513          	li	a0,4
80000128:	270000ef          	jal	ra,80000398 <WRITE_SERIAL>
8000012c:	2400006f          	j	8000036c <.DONE>

80000130 <.OP_T>:
80000130:	ff410113          	addi	sp,sp,-12
80000134:	00912023          	sw	s1,0(sp)
80000138:	01212223          	sw	s2,4(sp)
8000013c:	fff00493          	li	s1,-1
80000140:	00912423          	sw	s1,8(sp)
80000144:	00810493          	addi	s1,sp,8
80000148:	00400913          	li	s2,4
8000014c:	00048503          	lb	a0,0(s1)
80000150:	fff90913          	addi	s2,s2,-1
80000154:	244000ef          	jal	ra,80000398 <WRITE_SERIAL>
80000158:	00148493          	addi	s1,s1,1
8000015c:	fe0918e3          	bnez	s2,8000014c <.OP_T+0x1c>
80000160:	00012483          	lw	s1,0(sp)
80000164:	00412903          	lw	s2,4(sp)
80000168:	00c10113          	addi	sp,sp,12
8000016c:	2000006f          	j	8000036c <.DONE>

80000170 <.OP_R>:
80000170:	ff810113          	addi	sp,sp,-8
80000174:	00912023          	sw	s1,0(sp)
80000178:	01212223          	sw	s2,4(sp)
8000017c:	007f0497          	auipc	s1,0x7f0
80000180:	e8448493          	addi	s1,s1,-380 # 807f0000 <_sbss>
80000184:	07c00913          	li	s2,124
80000188:	00048503          	lb	a0,0(s1)
8000018c:	fff90913          	addi	s2,s2,-1
80000190:	208000ef          	jal	ra,80000398 <WRITE_SERIAL>
80000194:	00148493          	addi	s1,s1,1
80000198:	fe0918e3          	bnez	s2,80000188 <.OP_R+0x18>
8000019c:	00012483          	lw	s1,0(sp)
800001a0:	00412903          	lw	s2,4(sp)
800001a4:	00810113          	addi	sp,sp,8
800001a8:	1c40006f          	j	8000036c <.DONE>

800001ac <.OP_D>:
800001ac:	ff810113          	addi	sp,sp,-8
800001b0:	00912023          	sw	s1,0(sp)
800001b4:	01212223          	sw	s2,4(sp)
800001b8:	320000ef          	jal	ra,800004d8 <READ_SERIAL_XLEN>
800001bc:	000564b3          	or	s1,a0,zero
800001c0:	318000ef          	jal	ra,800004d8 <READ_SERIAL_XLEN>
800001c4:	00056933          	or	s2,a0,zero
800001c8:	00048503          	lb	a0,0(s1)
800001cc:	fff90913          	addi	s2,s2,-1
800001d0:	1c8000ef          	jal	ra,80000398 <WRITE_SERIAL>
800001d4:	00148493          	addi	s1,s1,1
800001d8:	fe0918e3          	bnez	s2,800001c8 <.OP_D+0x1c>
800001dc:	00012483          	lw	s1,0(sp)
800001e0:	00412903          	lw	s2,4(sp)
800001e4:	00810113          	addi	sp,sp,8
800001e8:	1840006f          	j	8000036c <.DONE>

800001ec <.OP_A>:
800001ec:	ff810113          	addi	sp,sp,-8
800001f0:	00912023          	sw	s1,0(sp)
800001f4:	01212223          	sw	s2,4(sp)
800001f8:	2e0000ef          	jal	ra,800004d8 <READ_SERIAL_XLEN>
800001fc:	000564b3          	or	s1,a0,zero
80000200:	2d8000ef          	jal	ra,800004d8 <READ_SERIAL_XLEN>
80000204:	00056933          	or	s2,a0,zero
80000208:	00295913          	srli	s2,s2,0x2
8000020c:	24c000ef          	jal	ra,80000458 <READ_SERIAL_WORD>
80000210:	00a4a023          	sw	a0,0(s1)
80000214:	fff90913          	addi	s2,s2,-1
80000218:	00448493          	addi	s1,s1,4
8000021c:	fe0918e3          	bnez	s2,8000020c <.OP_A+0x20>
80000220:	00012483          	lw	s1,0(sp)
80000224:	00412903          	lw	s2,4(sp)
80000228:	00810113          	addi	sp,sp,8
8000022c:	1400006f          	j	8000036c <.DONE>

80000230 <.OP_G>:
80000230:	2a8000ef          	jal	ra,800004d8 <READ_SERIAL_XLEN>
80000234:	00050d13          	mv	s10,a0
80000238:	00600513          	li	a0,6
8000023c:	15c000ef          	jal	ra,80000398 <WRITE_SERIAL>
80000240:	007f0097          	auipc	ra,0x7f0
80000244:	dc008093          	addi	ra,ra,-576 # 807f0000 <_sbss>
80000248:	0820a023          	sw	sp,128(ra)
8000024c:	0040a103          	lw	sp,4(ra)
80000250:	0080a183          	lw	gp,8(ra)
80000254:	00c0a203          	lw	tp,12(ra)
80000258:	0100a283          	lw	t0,16(ra)
8000025c:	0140a303          	lw	t1,20(ra)
80000260:	0180a383          	lw	t2,24(ra)
80000264:	01c0a403          	lw	s0,28(ra)
80000268:	0200a483          	lw	s1,32(ra)
8000026c:	0240a503          	lw	a0,36(ra)
80000270:	0280a583          	lw	a1,40(ra)
80000274:	02c0a603          	lw	a2,44(ra)
80000278:	0300a683          	lw	a3,48(ra)
8000027c:	0340a703          	lw	a4,52(ra)
80000280:	0380a783          	lw	a5,56(ra)
80000284:	03c0a803          	lw	a6,60(ra)
80000288:	0400a883          	lw	a7,64(ra)
8000028c:	0440a903          	lw	s2,68(ra)
80000290:	0480a983          	lw	s3,72(ra)
80000294:	04c0aa03          	lw	s4,76(ra)
80000298:	0500aa83          	lw	s5,80(ra)
8000029c:	0540ab03          	lw	s6,84(ra)
800002a0:	0580ab83          	lw	s7,88(ra)
800002a4:	05c0ac03          	lw	s8,92(ra)
800002a8:	0600ac83          	lw	s9,96(ra)
800002ac:	0680ad83          	lw	s11,104(ra)
800002b0:	06c0ae03          	lw	t3,108(ra)
800002b4:	0700ae83          	lw	t4,112(ra)
800002b8:	0740af03          	lw	t5,116(ra)
800002bc:	0780af83          	lw	t6,120(ra)

800002c0 <.ENTER_UESR>:
800002c0:	00000097          	auipc	ra,0x0
800002c4:	00c08093          	addi	ra,ra,12 # 800002cc <.USERRET2>
800002c8:	000d0067          	jr	s10

800002cc <.USERRET2>:
800002cc:	007f0097          	auipc	ra,0x7f0
800002d0:	d3408093          	addi	ra,ra,-716 # 807f0000 <_sbss>
800002d4:	0020a223          	sw	sp,4(ra)
800002d8:	0030a423          	sw	gp,8(ra)
800002dc:	0040a623          	sw	tp,12(ra)
800002e0:	0050a823          	sw	t0,16(ra)
800002e4:	0060aa23          	sw	t1,20(ra)
800002e8:	0070ac23          	sw	t2,24(ra)
800002ec:	0080ae23          	sw	s0,28(ra)
800002f0:	0290a023          	sw	s1,32(ra)
800002f4:	02a0a223          	sw	a0,36(ra)
800002f8:	02b0a423          	sw	a1,40(ra)
800002fc:	02c0a623          	sw	a2,44(ra)
80000300:	02d0a823          	sw	a3,48(ra)
80000304:	02e0aa23          	sw	a4,52(ra)
80000308:	02f0ac23          	sw	a5,56(ra)
8000030c:	0300ae23          	sw	a6,60(ra)
80000310:	0510a023          	sw	a7,64(ra)
80000314:	0520a223          	sw	s2,68(ra)
80000318:	0530a423          	sw	s3,72(ra)
8000031c:	0540a623          	sw	s4,76(ra)
80000320:	0550a823          	sw	s5,80(ra)
80000324:	0560aa23          	sw	s6,84(ra)
80000328:	0570ac23          	sw	s7,88(ra)
8000032c:	0580ae23          	sw	s8,92(ra)
80000330:	0790a023          	sw	s9,96(ra)
80000334:	07a0a223          	sw	s10,100(ra)
80000338:	07b0a423          	sw	s11,104(ra)
8000033c:	07c0a623          	sw	t3,108(ra)
80000340:	07d0a823          	sw	t4,112(ra)
80000344:	07e0aa23          	sw	t5,116(ra)
80000348:	07f0ac23          	sw	t6,120(ra)
8000034c:	0800a103          	lw	sp,128(ra)
80000350:	00008513          	mv	a0,ra
80000354:	00000097          	auipc	ra,0x0
80000358:	f7808093          	addi	ra,ra,-136 # 800002cc <.USERRET2>
8000035c:	00152023          	sw	ra,0(a0)
80000360:	00700513          	li	a0,7
80000364:	034000ef          	jal	ra,80000398 <WRITE_SERIAL>
80000368:	0040006f          	j	8000036c <.DONE>

8000036c <.DONE>:
8000036c:	d8dff06f          	j	800000f8 <SHELL>

80000370 <EXCEPTION_HANDLER>:
80000370:	0000006f          	j	80000370 <EXCEPTION_HANDLER>

80000374 <FATAL>:
80000374:	08000513          	li	a0,128
80000378:	020000ef          	jal	ra,80000398 <WRITE_SERIAL>
8000037c:	00000513          	li	a0,0
80000380:	084000ef          	jal	ra,80000404 <WRITE_SERIAL_XLEN>
80000384:	080000ef          	jal	ra,80000404 <WRITE_SERIAL_XLEN>
80000388:	07c000ef          	jal	ra,80000404 <WRITE_SERIAL_XLEN>
8000038c:	00000517          	auipc	a0,0x0
80000390:	c8050513          	addi	a0,a0,-896 # 8000000c <START>
80000394:	00050067          	jr	a0

80000398 <WRITE_SERIAL>:
80000398:	100002b7          	lui	t0,0x10000

8000039c <.TESTW>:
8000039c:	00528303          	lb	t1,5(t0) # 10000005 <INITLOCATE-0x6ffffffb>
800003a0:	02037313          	andi	t1,t1,32
800003a4:	00031463          	bnez	t1,800003ac <.WSERIAL>
800003a8:	ff5ff06f          	j	8000039c <.TESTW>

800003ac <.WSERIAL>:
800003ac:	00a28023          	sb	a0,0(t0)
800003b0:	00008067          	ret

800003b4 <WRITE_SERIAL_WORD>:
800003b4:	ff810113          	addi	sp,sp,-8
800003b8:	00112023          	sw	ra,0(sp)
800003bc:	00812223          	sw	s0,4(sp)
800003c0:	00050413          	mv	s0,a0
800003c4:	0ff57513          	andi	a0,a0,255
800003c8:	fd1ff0ef          	jal	ra,80000398 <WRITE_SERIAL>
800003cc:	00845513          	srli	a0,s0,0x8
800003d0:	0ff57513          	andi	a0,a0,255
800003d4:	fc5ff0ef          	jal	ra,80000398 <WRITE_SERIAL>
800003d8:	01045513          	srli	a0,s0,0x10
800003dc:	0ff57513          	andi	a0,a0,255
800003e0:	fb9ff0ef          	jal	ra,80000398 <WRITE_SERIAL>
800003e4:	01845513          	srli	a0,s0,0x18
800003e8:	0ff57513          	andi	a0,a0,255
800003ec:	fadff0ef          	jal	ra,80000398 <WRITE_SERIAL>
800003f0:	00040513          	mv	a0,s0
800003f4:	00012083          	lw	ra,0(sp)
800003f8:	00412403          	lw	s0,4(sp)
800003fc:	00810113          	addi	sp,sp,8
80000400:	00008067          	ret

80000404 <WRITE_SERIAL_XLEN>:
80000404:	ffc10113          	addi	sp,sp,-4
80000408:	00112023          	sw	ra,0(sp)
8000040c:	fa9ff0ef          	jal	ra,800003b4 <WRITE_SERIAL_WORD>
80000410:	00012083          	lw	ra,0(sp)
80000414:	00410113          	addi	sp,sp,4
80000418:	00008067          	ret

8000041c <WRITE_SERIAL_STRING>:
8000041c:	00050593          	mv	a1,a0
80000420:	00008613          	mv	a2,ra
80000424:	00058503          	lb	a0,0(a1)
80000428:	f71ff0ef          	jal	ra,80000398 <WRITE_SERIAL>
8000042c:	00158593          	addi	a1,a1,1
80000430:	00058503          	lb	a0,0(a1)
80000434:	fe051ae3          	bnez	a0,80000428 <WRITE_SERIAL_STRING+0xc>
80000438:	00060067          	jr	a2

8000043c <READ_SERIAL>:
8000043c:	100002b7          	lui	t0,0x10000

80000440 <.TESTR>:
80000440:	00528303          	lb	t1,5(t0) # 10000005 <INITLOCATE-0x6ffffffb>
80000444:	00137313          	andi	t1,t1,1
80000448:	00031463          	bnez	t1,80000450 <.RSERIAL>
8000044c:	ff5ff06f          	j	80000440 <.TESTR>

80000450 <.RSERIAL>:
80000450:	00028503          	lb	a0,0(t0)
80000454:	00008067          	ret

80000458 <READ_SERIAL_WORD>:
80000458:	fec10113          	addi	sp,sp,-20
8000045c:	00112023          	sw	ra,0(sp)
80000460:	00812223          	sw	s0,4(sp)
80000464:	00912423          	sw	s1,8(sp)
80000468:	01212623          	sw	s2,12(sp)
8000046c:	01312823          	sw	s3,16(sp)
80000470:	fcdff0ef          	jal	ra,8000043c <READ_SERIAL>
80000474:	00a06433          	or	s0,zero,a0
80000478:	fc5ff0ef          	jal	ra,8000043c <READ_SERIAL>
8000047c:	00a064b3          	or	s1,zero,a0
80000480:	fbdff0ef          	jal	ra,8000043c <READ_SERIAL>
80000484:	00a06933          	or	s2,zero,a0
80000488:	fb5ff0ef          	jal	ra,8000043c <READ_SERIAL>
8000048c:	00a069b3          	or	s3,zero,a0
80000490:	0ff47413          	andi	s0,s0,255
80000494:	0ff4f493          	andi	s1,s1,255
80000498:	0ff97913          	andi	s2,s2,255
8000049c:	0ff9f993          	andi	s3,s3,255
800004a0:	01306533          	or	a0,zero,s3
800004a4:	00851513          	slli	a0,a0,0x8
800004a8:	01256533          	or	a0,a0,s2
800004ac:	00851513          	slli	a0,a0,0x8
800004b0:	00956533          	or	a0,a0,s1
800004b4:	00851513          	slli	a0,a0,0x8
800004b8:	00856533          	or	a0,a0,s0
800004bc:	00012083          	lw	ra,0(sp)
800004c0:	00412403          	lw	s0,4(sp)
800004c4:	00812483          	lw	s1,8(sp)
800004c8:	00c12903          	lw	s2,12(sp)
800004cc:	01012983          	lw	s3,16(sp)
800004d0:	01410113          	addi	sp,sp,20
800004d4:	00008067          	ret

800004d8 <READ_SERIAL_XLEN>:
800004d8:	ff810113          	addi	sp,sp,-8
800004dc:	00112023          	sw	ra,0(sp)
800004e0:	00812223          	sw	s0,4(sp)
800004e4:	f75ff0ef          	jal	ra,80000458 <READ_SERIAL_WORD>
800004e8:	00050413          	mv	s0,a0
800004ec:	00040513          	mv	a0,s0
800004f0:	00012083          	lw	ra,0(sp)
800004f4:	00412403          	lw	s0,4(sp)
800004f8:	00810113          	addi	sp,sp,8
800004fc:	00008067          	ret
	...

80001000 <UTEST_SIMPLE>:
80001000:	001f0f13          	addi	t5,t5,1
80001004:	00008067          	ret

80001008 <UTEST_1PTB>:
80001008:	040002b7          	lui	t0,0x4000
8000100c:	fff28293          	addi	t0,t0,-1 # 3ffffff <INITLOCATE-0x7c000001>
80001010:	00000313          	li	t1,0
80001014:	00100393          	li	t2,1
80001018:	00200e13          	li	t3,2
8000101c:	fe0298e3          	bnez	t0,8000100c <UTEST_1PTB+0x4>
80001020:	00008067          	ret

80001024 <UTEST_2DCT>:
80001024:	010002b7          	lui	t0,0x1000
80001028:	00100313          	li	t1,1
8000102c:	00200393          	li	t2,2
80001030:	00300e13          	li	t3,3
80001034:	0063c3b3          	xor	t2,t2,t1
80001038:	00734333          	xor	t1,t1,t2
8000103c:	0063c3b3          	xor	t2,t2,t1
80001040:	007e4e33          	xor	t3,t3,t2
80001044:	01c3c3b3          	xor	t2,t2,t3
80001048:	007e4e33          	xor	t3,t3,t2
8000104c:	01c34333          	xor	t1,t1,t3
80001050:	006e4e33          	xor	t3,t3,t1
80001054:	01c34333          	xor	t1,t1,t3
80001058:	fff28293          	addi	t0,t0,-1 # ffffff <INITLOCATE-0x7f000001>
8000105c:	fc029ce3          	bnez	t0,80001034 <UTEST_2DCT+0x10>
80001060:	00008067          	ret

80001064 <UTEST_3CCT>:
80001064:	040002b7          	lui	t0,0x4000
80001068:	00029463          	bnez	t0,80001070 <UTEST_3CCT+0xc>
8000106c:	00008067          	ret
80001070:	0040006f          	j	80001074 <UTEST_3CCT+0x10>
80001074:	fff28293          	addi	t0,t0,-1 # 3ffffff <INITLOCATE-0x7c000001>
80001078:	ff1ff06f          	j	80001068 <UTEST_3CCT+0x4>
8000107c:	fff28293          	addi	t0,t0,-1

80001080 <UTEST_4MDCT>:
80001080:	020002b7          	lui	t0,0x2000
80001084:	ffc10113          	addi	sp,sp,-4
80001088:	00512023          	sw	t0,0(sp)
8000108c:	00012303          	lw	t1,0(sp)
80001090:	fff30313          	addi	t1,t1,-1
80001094:	00612023          	sw	t1,0(sp)
80001098:	00012283          	lw	t0,0(sp)
8000109c:	fe0296e3          	bnez	t0,80001088 <UTEST_4MDCT+0x8>
800010a0:	00410113          	addi	sp,sp,4
800010a4:	00008067          	ret

800010a8 <UTEST_CRYPTONIGHT>:
800010a8:	80400537          	lui	a0,0x80400
800010ac:	002005b7          	lui	a1,0x200
800010b0:	000806b7          	lui	a3,0x80
800010b4:	00200737          	lui	a4,0x200
800010b8:	ffc70713          	addi	a4,a4,-4 # 1ffffc <INITLOCATE-0x7fe00004>
800010bc:	00a585b3          	add	a1,a1,a0
800010c0:	00100413          	li	s0,1
800010c4:	00050613          	mv	a2,a0

800010c8 <.INIT_LOOP>:
800010c8:	00862023          	sw	s0,0(a2)
800010cc:	00d41493          	slli	s1,s0,0xd
800010d0:	00944433          	xor	s0,s0,s1
800010d4:	01145493          	srli	s1,s0,0x11
800010d8:	00944433          	xor	s0,s0,s1
800010dc:	00541493          	slli	s1,s0,0x5
800010e0:	00944433          	xor	s0,s0,s1
800010e4:	00460613          	addi	a2,a2,4
800010e8:	feb610e3          	bne	a2,a1,800010c8 <.INIT_LOOP>
800010ec:	00000613          	li	a2,0
800010f0:	00000293          	li	t0,0

800010f4 <.MAIN_LOOP>:
800010f4:	00e472b3          	and	t0,s0,a4
800010f8:	005502b3          	add	t0,a0,t0
800010fc:	0002a283          	lw	t0,0(t0) # 2000000 <INITLOCATE-0x7e000000>
80001100:	0062c2b3          	xor	t0,t0,t1
80001104:	00544433          	xor	s0,s0,t0
80001108:	00d41493          	slli	s1,s0,0xd
8000110c:	00944433          	xor	s0,s0,s1
80001110:	01145493          	srli	s1,s0,0x11
80001114:	00944433          	xor	s0,s0,s1
80001118:	00541493          	slli	s1,s0,0x5
8000111c:	00944433          	xor	s0,s0,s1
80001120:	00e47333          	and	t1,s0,a4
80001124:	00650333          	add	t1,a0,t1
80001128:	00532023          	sw	t0,0(t1)
8000112c:	00028313          	mv	t1,t0
80001130:	00d41493          	slli	s1,s0,0xd
80001134:	00944433          	xor	s0,s0,s1
80001138:	01145493          	srli	s1,s0,0x11
8000113c:	00944433          	xor	s0,s0,s1
80001140:	00541493          	slli	s1,s0,0x5
80001144:	00944433          	xor	s0,s0,s1
80001148:	00160613          	addi	a2,a2,1
8000114c:	fad614e3          	bne	a2,a3,800010f4 <.MAIN_LOOP>
80001150:	00008067          	ret
