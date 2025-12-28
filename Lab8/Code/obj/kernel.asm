
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	1bc0b0ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0200066:	209000ef          	jal	ra,ffffffffc0200a6e <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	6b658593          	addi	a1,a1,1718 # ffffffffc020b720 <etext+0x6>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	6ce50513          	addi	a0,a0,1742 # ffffffffc020b740 <etext+0x26>
ffffffffc020007a:	0b0000ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020007e:	25c000ef          	jal	ra,ffffffffc02002da <print_kerninfo>
ffffffffc0200082:	4ca000ef          	jal	ra,ffffffffc020054c <dtb_init>
ffffffffc0200086:	318030ef          	jal	ra,ffffffffc020339e <pmm_init>
ffffffffc020008a:	2ff000ef          	jal	ra,ffffffffc0200b88 <pic_init>
ffffffffc020008e:	519000ef          	jal	ra,ffffffffc0200da6 <idt_init>
ffffffffc0200092:	640010ef          	jal	ra,ffffffffc02016d2 <vmm_init>
ffffffffc0200096:	21c070ef          	jal	ra,ffffffffc02072b2 <sched_init>
ffffffffc020009a:	775060ef          	jal	ra,ffffffffc020700e <proc_init>
ffffffffc020009e:	2ed000ef          	jal	ra,ffffffffc0200b8a <ide_init>
ffffffffc02000a2:	7b8050ef          	jal	ra,ffffffffc020585a <fs_init>
ffffffffc02000a6:	17f000ef          	jal	ra,ffffffffc0200a24 <clock_init>
ffffffffc02000aa:	4f1000ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02000ae:	12c070ef          	jal	ra,ffffffffc02071da <cpu_idle>

ffffffffc02000b2 <strdup>:
ffffffffc02000b2:	1101                	addi	sp,sp,-32
ffffffffc02000b4:	ec06                	sd	ra,24(sp)
ffffffffc02000b6:	e822                	sd	s0,16(sp)
ffffffffc02000b8:	e426                	sd	s1,8(sp)
ffffffffc02000ba:	e04a                	sd	s2,0(sp)
ffffffffc02000bc:	892a                	mv	s2,a0
ffffffffc02000be:	0be0b0ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc02000c2:	842a                	mv	s0,a0
ffffffffc02000c4:	0505                	addi	a0,a0,1
ffffffffc02000c6:	4e9010ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc02000ca:	84aa                	mv	s1,a0
ffffffffc02000cc:	c901                	beqz	a0,ffffffffc02000dc <strdup+0x2a>
ffffffffc02000ce:	8622                	mv	a2,s0
ffffffffc02000d0:	85ca                	mv	a1,s2
ffffffffc02000d2:	9426                	add	s0,s0,s1
ffffffffc02000d4:	19c0b0ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc02000d8:	00040023          	sb	zero,0(s0)
ffffffffc02000dc:	60e2                	ld	ra,24(sp)
ffffffffc02000de:	6442                	ld	s0,16(sp)
ffffffffc02000e0:	6902                	ld	s2,0(sp)
ffffffffc02000e2:	8526                	mv	a0,s1
ffffffffc02000e4:	64a2                	ld	s1,8(sp)
ffffffffc02000e6:	6105                	addi	sp,sp,32
ffffffffc02000e8:	8082                	ret

ffffffffc02000ea <cputch>:
ffffffffc02000ea:	1141                	addi	sp,sp,-16
ffffffffc02000ec:	e022                	sd	s0,0(sp)
ffffffffc02000ee:	e406                	sd	ra,8(sp)
ffffffffc02000f0:	842e                	mv	s0,a1
ffffffffc02000f2:	18b000ef          	jal	ra,ffffffffc0200a7c <cons_putc>
ffffffffc02000f6:	401c                	lw	a5,0(s0)
ffffffffc02000f8:	60a2                	ld	ra,8(sp)
ffffffffc02000fa:	2785                	addiw	a5,a5,1
ffffffffc02000fc:	c01c                	sw	a5,0(s0)
ffffffffc02000fe:	6402                	ld	s0,0(sp)
ffffffffc0200100:	0141                	addi	sp,sp,16
ffffffffc0200102:	8082                	ret

ffffffffc0200104 <vcprintf>:
ffffffffc0200104:	1101                	addi	sp,sp,-32
ffffffffc0200106:	872e                	mv	a4,a1
ffffffffc0200108:	75dd                	lui	a1,0xffff7
ffffffffc020010a:	86aa                	mv	a3,a0
ffffffffc020010c:	0070                	addi	a2,sp,12
ffffffffc020010e:	00000517          	auipc	a0,0x0
ffffffffc0200112:	fdc50513          	addi	a0,a0,-36 # ffffffffc02000ea <cputch>
ffffffffc0200116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020011a:	ec06                	sd	ra,24(sp)
ffffffffc020011c:	c602                	sw	zero,12(sp)
ffffffffc020011e:	1fa0b0ef          	jal	ra,ffffffffc020b318 <vprintfmt>
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	4532                	lw	a0,12(sp)
ffffffffc0200126:	6105                	addi	sp,sp,32
ffffffffc0200128:	8082                	ret

ffffffffc020012a <cprintf>:
ffffffffc020012a:	711d                	addi	sp,sp,-96
ffffffffc020012c:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc0200130:	8e2a                	mv	t3,a0
ffffffffc0200132:	f42e                	sd	a1,40(sp)
ffffffffc0200134:	75dd                	lui	a1,0xffff7
ffffffffc0200136:	f832                	sd	a2,48(sp)
ffffffffc0200138:	fc36                	sd	a3,56(sp)
ffffffffc020013a:	e0ba                	sd	a4,64(sp)
ffffffffc020013c:	00000517          	auipc	a0,0x0
ffffffffc0200140:	fae50513          	addi	a0,a0,-82 # ffffffffc02000ea <cputch>
ffffffffc0200144:	0050                	addi	a2,sp,4
ffffffffc0200146:	871a                	mv	a4,t1
ffffffffc0200148:	86f2                	mv	a3,t3
ffffffffc020014a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020014e:	ec06                	sd	ra,24(sp)
ffffffffc0200150:	e4be                	sd	a5,72(sp)
ffffffffc0200152:	e8c2                	sd	a6,80(sp)
ffffffffc0200154:	ecc6                	sd	a7,88(sp)
ffffffffc0200156:	e41a                	sd	t1,8(sp)
ffffffffc0200158:	c202                	sw	zero,4(sp)
ffffffffc020015a:	1be0b0ef          	jal	ra,ffffffffc020b318 <vprintfmt>
ffffffffc020015e:	60e2                	ld	ra,24(sp)
ffffffffc0200160:	4512                	lw	a0,4(sp)
ffffffffc0200162:	6125                	addi	sp,sp,96
ffffffffc0200164:	8082                	ret

ffffffffc0200166 <cputchar>:
ffffffffc0200166:	1170006f          	j	ffffffffc0200a7c <cons_putc>

ffffffffc020016a <getchar>:
ffffffffc020016a:	1141                	addi	sp,sp,-16
ffffffffc020016c:	e406                	sd	ra,8(sp)
ffffffffc020016e:	163000ef          	jal	ra,ffffffffc0200ad0 <cons_getc>
ffffffffc0200172:	dd75                	beqz	a0,ffffffffc020016e <getchar+0x4>
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	0141                	addi	sp,sp,16
ffffffffc0200178:	8082                	ret

ffffffffc020017a <readline>:
ffffffffc020017a:	715d                	addi	sp,sp,-80
ffffffffc020017c:	e486                	sd	ra,72(sp)
ffffffffc020017e:	e0a6                	sd	s1,64(sp)
ffffffffc0200180:	fc4a                	sd	s2,56(sp)
ffffffffc0200182:	f84e                	sd	s3,48(sp)
ffffffffc0200184:	f452                	sd	s4,40(sp)
ffffffffc0200186:	f056                	sd	s5,32(sp)
ffffffffc0200188:	ec5a                	sd	s6,24(sp)
ffffffffc020018a:	e85e                	sd	s7,16(sp)
ffffffffc020018c:	c901                	beqz	a0,ffffffffc020019c <readline+0x22>
ffffffffc020018e:	85aa                	mv	a1,a0
ffffffffc0200190:	0000b517          	auipc	a0,0xb
ffffffffc0200194:	5b850513          	addi	a0,a0,1464 # ffffffffc020b748 <etext+0x2e>
ffffffffc0200198:	f93ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020019c:	4481                	li	s1,0
ffffffffc020019e:	497d                	li	s2,31
ffffffffc02001a0:	49a1                	li	s3,8
ffffffffc02001a2:	4aa9                	li	s5,10
ffffffffc02001a4:	4b35                	li	s6,13
ffffffffc02001a6:	00091b97          	auipc	s7,0x91
ffffffffc02001aa:	ebab8b93          	addi	s7,s7,-326 # ffffffffc0291060 <buf>
ffffffffc02001ae:	3fe00a13          	li	s4,1022
ffffffffc02001b2:	fb9ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001b6:	00054a63          	bltz	a0,ffffffffc02001ca <readline+0x50>
ffffffffc02001ba:	00a95a63          	bge	s2,a0,ffffffffc02001ce <readline+0x54>
ffffffffc02001be:	029a5263          	bge	s4,s1,ffffffffc02001e2 <readline+0x68>
ffffffffc02001c2:	fa9ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001c6:	fe055ae3          	bgez	a0,ffffffffc02001ba <readline+0x40>
ffffffffc02001ca:	4501                	li	a0,0
ffffffffc02001cc:	a091                	j	ffffffffc0200210 <readline+0x96>
ffffffffc02001ce:	03351463          	bne	a0,s3,ffffffffc02001f6 <readline+0x7c>
ffffffffc02001d2:	e8a9                	bnez	s1,ffffffffc0200224 <readline+0xaa>
ffffffffc02001d4:	f97ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001d8:	fe0549e3          	bltz	a0,ffffffffc02001ca <readline+0x50>
ffffffffc02001dc:	fea959e3          	bge	s2,a0,ffffffffc02001ce <readline+0x54>
ffffffffc02001e0:	4481                	li	s1,0
ffffffffc02001e2:	e42a                	sd	a0,8(sp)
ffffffffc02001e4:	f83ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc02001e8:	6522                	ld	a0,8(sp)
ffffffffc02001ea:	009b87b3          	add	a5,s7,s1
ffffffffc02001ee:	2485                	addiw	s1,s1,1
ffffffffc02001f0:	00a78023          	sb	a0,0(a5)
ffffffffc02001f4:	bf7d                	j	ffffffffc02001b2 <readline+0x38>
ffffffffc02001f6:	01550463          	beq	a0,s5,ffffffffc02001fe <readline+0x84>
ffffffffc02001fa:	fb651ce3          	bne	a0,s6,ffffffffc02001b2 <readline+0x38>
ffffffffc02001fe:	f69ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc0200202:	00091517          	auipc	a0,0x91
ffffffffc0200206:	e5e50513          	addi	a0,a0,-418 # ffffffffc0291060 <buf>
ffffffffc020020a:	94aa                	add	s1,s1,a0
ffffffffc020020c:	00048023          	sb	zero,0(s1)
ffffffffc0200210:	60a6                	ld	ra,72(sp)
ffffffffc0200212:	6486                	ld	s1,64(sp)
ffffffffc0200214:	7962                	ld	s2,56(sp)
ffffffffc0200216:	79c2                	ld	s3,48(sp)
ffffffffc0200218:	7a22                	ld	s4,40(sp)
ffffffffc020021a:	7a82                	ld	s5,32(sp)
ffffffffc020021c:	6b62                	ld	s6,24(sp)
ffffffffc020021e:	6bc2                	ld	s7,16(sp)
ffffffffc0200220:	6161                	addi	sp,sp,80
ffffffffc0200222:	8082                	ret
ffffffffc0200224:	4521                	li	a0,8
ffffffffc0200226:	f41ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc020022a:	34fd                	addiw	s1,s1,-1
ffffffffc020022c:	b759                	j	ffffffffc02001b2 <readline+0x38>

ffffffffc020022e <__panic>:
ffffffffc020022e:	00096317          	auipc	t1,0x96
ffffffffc0200232:	63a30313          	addi	t1,t1,1594 # ffffffffc0296868 <is_panic>
ffffffffc0200236:	00033e03          	ld	t3,0(t1)
ffffffffc020023a:	715d                	addi	sp,sp,-80
ffffffffc020023c:	ec06                	sd	ra,24(sp)
ffffffffc020023e:	e822                	sd	s0,16(sp)
ffffffffc0200240:	f436                	sd	a3,40(sp)
ffffffffc0200242:	f83a                	sd	a4,48(sp)
ffffffffc0200244:	fc3e                	sd	a5,56(sp)
ffffffffc0200246:	e0c2                	sd	a6,64(sp)
ffffffffc0200248:	e4c6                	sd	a7,72(sp)
ffffffffc020024a:	020e1a63          	bnez	t3,ffffffffc020027e <__panic+0x50>
ffffffffc020024e:	4785                	li	a5,1
ffffffffc0200250:	00f33023          	sd	a5,0(t1)
ffffffffc0200254:	8432                	mv	s0,a2
ffffffffc0200256:	103c                	addi	a5,sp,40
ffffffffc0200258:	862e                	mv	a2,a1
ffffffffc020025a:	85aa                	mv	a1,a0
ffffffffc020025c:	0000b517          	auipc	a0,0xb
ffffffffc0200260:	4f450513          	addi	a0,a0,1268 # ffffffffc020b750 <etext+0x36>
ffffffffc0200264:	e43e                	sd	a5,8(sp)
ffffffffc0200266:	ec5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020026a:	65a2                	ld	a1,8(sp)
ffffffffc020026c:	8522                	mv	a0,s0
ffffffffc020026e:	e97ff0ef          	jal	ra,ffffffffc0200104 <vcprintf>
ffffffffc0200272:	0000d517          	auipc	a0,0xd
ffffffffc0200276:	cd650513          	addi	a0,a0,-810 # ffffffffc020cf48 <default_pmm_manager+0x520>
ffffffffc020027a:	eb1ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020027e:	4501                	li	a0,0
ffffffffc0200280:	4581                	li	a1,0
ffffffffc0200282:	4601                	li	a2,0
ffffffffc0200284:	48a1                	li	a7,8
ffffffffc0200286:	00000073          	ecall
ffffffffc020028a:	317000ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020028e:	4501                	li	a0,0
ffffffffc0200290:	174000ef          	jal	ra,ffffffffc0200404 <kmonitor>
ffffffffc0200294:	bfed                	j	ffffffffc020028e <__panic+0x60>

ffffffffc0200296 <__warn>:
ffffffffc0200296:	715d                	addi	sp,sp,-80
ffffffffc0200298:	832e                	mv	t1,a1
ffffffffc020029a:	e822                	sd	s0,16(sp)
ffffffffc020029c:	85aa                	mv	a1,a0
ffffffffc020029e:	8432                	mv	s0,a2
ffffffffc02002a0:	fc3e                	sd	a5,56(sp)
ffffffffc02002a2:	861a                	mv	a2,t1
ffffffffc02002a4:	103c                	addi	a5,sp,40
ffffffffc02002a6:	0000b517          	auipc	a0,0xb
ffffffffc02002aa:	4ca50513          	addi	a0,a0,1226 # ffffffffc020b770 <etext+0x56>
ffffffffc02002ae:	ec06                	sd	ra,24(sp)
ffffffffc02002b0:	f436                	sd	a3,40(sp)
ffffffffc02002b2:	f83a                	sd	a4,48(sp)
ffffffffc02002b4:	e0c2                	sd	a6,64(sp)
ffffffffc02002b6:	e4c6                	sd	a7,72(sp)
ffffffffc02002b8:	e43e                	sd	a5,8(sp)
ffffffffc02002ba:	e71ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002be:	65a2                	ld	a1,8(sp)
ffffffffc02002c0:	8522                	mv	a0,s0
ffffffffc02002c2:	e43ff0ef          	jal	ra,ffffffffc0200104 <vcprintf>
ffffffffc02002c6:	0000d517          	auipc	a0,0xd
ffffffffc02002ca:	c8250513          	addi	a0,a0,-894 # ffffffffc020cf48 <default_pmm_manager+0x520>
ffffffffc02002ce:	e5dff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002d2:	60e2                	ld	ra,24(sp)
ffffffffc02002d4:	6442                	ld	s0,16(sp)
ffffffffc02002d6:	6161                	addi	sp,sp,80
ffffffffc02002d8:	8082                	ret

ffffffffc02002da <print_kerninfo>:
ffffffffc02002da:	1141                	addi	sp,sp,-16
ffffffffc02002dc:	0000b517          	auipc	a0,0xb
ffffffffc02002e0:	4b450513          	addi	a0,a0,1204 # ffffffffc020b790 <etext+0x76>
ffffffffc02002e4:	e406                	sd	ra,8(sp)
ffffffffc02002e6:	e45ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002ea:	00000597          	auipc	a1,0x0
ffffffffc02002ee:	d6058593          	addi	a1,a1,-672 # ffffffffc020004a <kern_init>
ffffffffc02002f2:	0000b517          	auipc	a0,0xb
ffffffffc02002f6:	4be50513          	addi	a0,a0,1214 # ffffffffc020b7b0 <etext+0x96>
ffffffffc02002fa:	e31ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	41c58593          	addi	a1,a1,1052 # ffffffffc020b71a <etext>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	4ca50513          	addi	a0,a0,1226 # ffffffffc020b7d0 <etext+0xb6>
ffffffffc020030e:	e1dff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200312:	00091597          	auipc	a1,0x91
ffffffffc0200316:	d4e58593          	addi	a1,a1,-690 # ffffffffc0291060 <buf>
ffffffffc020031a:	0000b517          	auipc	a0,0xb
ffffffffc020031e:	4d650513          	addi	a0,a0,1238 # ffffffffc020b7f0 <etext+0xd6>
ffffffffc0200322:	e09ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200326:	00096597          	auipc	a1,0x96
ffffffffc020032a:	5ea58593          	addi	a1,a1,1514 # ffffffffc0296910 <end>
ffffffffc020032e:	0000b517          	auipc	a0,0xb
ffffffffc0200332:	4e250513          	addi	a0,a0,1250 # ffffffffc020b810 <etext+0xf6>
ffffffffc0200336:	df5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020033a:	00097597          	auipc	a1,0x97
ffffffffc020033e:	9d558593          	addi	a1,a1,-1579 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200342:	00000797          	auipc	a5,0x0
ffffffffc0200346:	d0878793          	addi	a5,a5,-760 # ffffffffc020004a <kern_init>
ffffffffc020034a:	40f587b3          	sub	a5,a1,a5
ffffffffc020034e:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200352:	60a2                	ld	ra,8(sp)
ffffffffc0200354:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200358:	95be                	add	a1,a1,a5
ffffffffc020035a:	85a9                	srai	a1,a1,0xa
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	4d450513          	addi	a0,a0,1236 # ffffffffc020b830 <etext+0x116>
ffffffffc0200364:	0141                	addi	sp,sp,16
ffffffffc0200366:	b3d1                	j	ffffffffc020012a <cprintf>

ffffffffc0200368 <print_stackframe>:
ffffffffc0200368:	1141                	addi	sp,sp,-16
ffffffffc020036a:	0000b617          	auipc	a2,0xb
ffffffffc020036e:	4f660613          	addi	a2,a2,1270 # ffffffffc020b860 <etext+0x146>
ffffffffc0200372:	04e00593          	li	a1,78
ffffffffc0200376:	0000b517          	auipc	a0,0xb
ffffffffc020037a:	50250513          	addi	a0,a0,1282 # ffffffffc020b878 <etext+0x15e>
ffffffffc020037e:	e406                	sd	ra,8(sp)
ffffffffc0200380:	eafff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200384 <mon_help>:
ffffffffc0200384:	1141                	addi	sp,sp,-16
ffffffffc0200386:	0000b617          	auipc	a2,0xb
ffffffffc020038a:	50a60613          	addi	a2,a2,1290 # ffffffffc020b890 <etext+0x176>
ffffffffc020038e:	0000b597          	auipc	a1,0xb
ffffffffc0200392:	52258593          	addi	a1,a1,1314 # ffffffffc020b8b0 <etext+0x196>
ffffffffc0200396:	0000b517          	auipc	a0,0xb
ffffffffc020039a:	52250513          	addi	a0,a0,1314 # ffffffffc020b8b8 <etext+0x19e>
ffffffffc020039e:	e406                	sd	ra,8(sp)
ffffffffc02003a0:	d8bff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003a4:	0000b617          	auipc	a2,0xb
ffffffffc02003a8:	52460613          	addi	a2,a2,1316 # ffffffffc020b8c8 <etext+0x1ae>
ffffffffc02003ac:	0000b597          	auipc	a1,0xb
ffffffffc02003b0:	54458593          	addi	a1,a1,1348 # ffffffffc020b8f0 <etext+0x1d6>
ffffffffc02003b4:	0000b517          	auipc	a0,0xb
ffffffffc02003b8:	50450513          	addi	a0,a0,1284 # ffffffffc020b8b8 <etext+0x19e>
ffffffffc02003bc:	d6fff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003c0:	0000b617          	auipc	a2,0xb
ffffffffc02003c4:	54060613          	addi	a2,a2,1344 # ffffffffc020b900 <etext+0x1e6>
ffffffffc02003c8:	0000b597          	auipc	a1,0xb
ffffffffc02003cc:	55858593          	addi	a1,a1,1368 # ffffffffc020b920 <etext+0x206>
ffffffffc02003d0:	0000b517          	auipc	a0,0xb
ffffffffc02003d4:	4e850513          	addi	a0,a0,1256 # ffffffffc020b8b8 <etext+0x19e>
ffffffffc02003d8:	d53ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003dc:	60a2                	ld	ra,8(sp)
ffffffffc02003de:	4501                	li	a0,0
ffffffffc02003e0:	0141                	addi	sp,sp,16
ffffffffc02003e2:	8082                	ret

ffffffffc02003e4 <mon_kerninfo>:
ffffffffc02003e4:	1141                	addi	sp,sp,-16
ffffffffc02003e6:	e406                	sd	ra,8(sp)
ffffffffc02003e8:	ef3ff0ef          	jal	ra,ffffffffc02002da <print_kerninfo>
ffffffffc02003ec:	60a2                	ld	ra,8(sp)
ffffffffc02003ee:	4501                	li	a0,0
ffffffffc02003f0:	0141                	addi	sp,sp,16
ffffffffc02003f2:	8082                	ret

ffffffffc02003f4 <mon_backtrace>:
ffffffffc02003f4:	1141                	addi	sp,sp,-16
ffffffffc02003f6:	e406                	sd	ra,8(sp)
ffffffffc02003f8:	f71ff0ef          	jal	ra,ffffffffc0200368 <print_stackframe>
ffffffffc02003fc:	60a2                	ld	ra,8(sp)
ffffffffc02003fe:	4501                	li	a0,0
ffffffffc0200400:	0141                	addi	sp,sp,16
ffffffffc0200402:	8082                	ret

ffffffffc0200404 <kmonitor>:
ffffffffc0200404:	7115                	addi	sp,sp,-224
ffffffffc0200406:	ed5e                	sd	s7,152(sp)
ffffffffc0200408:	8baa                	mv	s7,a0
ffffffffc020040a:	0000b517          	auipc	a0,0xb
ffffffffc020040e:	52650513          	addi	a0,a0,1318 # ffffffffc020b930 <etext+0x216>
ffffffffc0200412:	ed86                	sd	ra,216(sp)
ffffffffc0200414:	e9a2                	sd	s0,208(sp)
ffffffffc0200416:	e5a6                	sd	s1,200(sp)
ffffffffc0200418:	e1ca                	sd	s2,192(sp)
ffffffffc020041a:	fd4e                	sd	s3,184(sp)
ffffffffc020041c:	f952                	sd	s4,176(sp)
ffffffffc020041e:	f556                	sd	s5,168(sp)
ffffffffc0200420:	f15a                	sd	s6,160(sp)
ffffffffc0200422:	e962                	sd	s8,144(sp)
ffffffffc0200424:	e566                	sd	s9,136(sp)
ffffffffc0200426:	e16a                	sd	s10,128(sp)
ffffffffc0200428:	d03ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020042c:	0000b517          	auipc	a0,0xb
ffffffffc0200430:	52c50513          	addi	a0,a0,1324 # ffffffffc020b958 <etext+0x23e>
ffffffffc0200434:	cf7ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200438:	000b8563          	beqz	s7,ffffffffc0200442 <kmonitor+0x3e>
ffffffffc020043c:	855e                	mv	a0,s7
ffffffffc020043e:	351000ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc0200442:	0000bc17          	auipc	s8,0xb
ffffffffc0200446:	586c0c13          	addi	s8,s8,1414 # ffffffffc020b9c8 <commands>
ffffffffc020044a:	0000b917          	auipc	s2,0xb
ffffffffc020044e:	53690913          	addi	s2,s2,1334 # ffffffffc020b980 <etext+0x266>
ffffffffc0200452:	0000b497          	auipc	s1,0xb
ffffffffc0200456:	53648493          	addi	s1,s1,1334 # ffffffffc020b988 <etext+0x26e>
ffffffffc020045a:	49bd                	li	s3,15
ffffffffc020045c:	0000bb17          	auipc	s6,0xb
ffffffffc0200460:	534b0b13          	addi	s6,s6,1332 # ffffffffc020b990 <etext+0x276>
ffffffffc0200464:	0000ba17          	auipc	s4,0xb
ffffffffc0200468:	44ca0a13          	addi	s4,s4,1100 # ffffffffc020b8b0 <etext+0x196>
ffffffffc020046c:	4a8d                	li	s5,3
ffffffffc020046e:	854a                	mv	a0,s2
ffffffffc0200470:	d0bff0ef          	jal	ra,ffffffffc020017a <readline>
ffffffffc0200474:	842a                	mv	s0,a0
ffffffffc0200476:	dd65                	beqz	a0,ffffffffc020046e <kmonitor+0x6a>
ffffffffc0200478:	00054583          	lbu	a1,0(a0)
ffffffffc020047c:	4c81                	li	s9,0
ffffffffc020047e:	e1bd                	bnez	a1,ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc0200480:	fe0c87e3          	beqz	s9,ffffffffc020046e <kmonitor+0x6a>
ffffffffc0200484:	6582                	ld	a1,0(sp)
ffffffffc0200486:	0000bd17          	auipc	s10,0xb
ffffffffc020048a:	542d0d13          	addi	s10,s10,1346 # ffffffffc020b9c8 <commands>
ffffffffc020048e:	8552                	mv	a0,s4
ffffffffc0200490:	4401                	li	s0,0
ffffffffc0200492:	0d61                	addi	s10,s10,24
ffffffffc0200494:	5310a0ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc0200498:	c919                	beqz	a0,ffffffffc02004ae <kmonitor+0xaa>
ffffffffc020049a:	2405                	addiw	s0,s0,1
ffffffffc020049c:	0b540063          	beq	s0,s5,ffffffffc020053c <kmonitor+0x138>
ffffffffc02004a0:	000d3503          	ld	a0,0(s10)
ffffffffc02004a4:	6582                	ld	a1,0(sp)
ffffffffc02004a6:	0d61                	addi	s10,s10,24
ffffffffc02004a8:	51d0a0ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc02004ac:	f57d                	bnez	a0,ffffffffc020049a <kmonitor+0x96>
ffffffffc02004ae:	00141793          	slli	a5,s0,0x1
ffffffffc02004b2:	97a2                	add	a5,a5,s0
ffffffffc02004b4:	078e                	slli	a5,a5,0x3
ffffffffc02004b6:	97e2                	add	a5,a5,s8
ffffffffc02004b8:	6b9c                	ld	a5,16(a5)
ffffffffc02004ba:	865e                	mv	a2,s7
ffffffffc02004bc:	002c                	addi	a1,sp,8
ffffffffc02004be:	fffc851b          	addiw	a0,s9,-1
ffffffffc02004c2:	9782                	jalr	a5
ffffffffc02004c4:	fa0555e3          	bgez	a0,ffffffffc020046e <kmonitor+0x6a>
ffffffffc02004c8:	60ee                	ld	ra,216(sp)
ffffffffc02004ca:	644e                	ld	s0,208(sp)
ffffffffc02004cc:	64ae                	ld	s1,200(sp)
ffffffffc02004ce:	690e                	ld	s2,192(sp)
ffffffffc02004d0:	79ea                	ld	s3,184(sp)
ffffffffc02004d2:	7a4a                	ld	s4,176(sp)
ffffffffc02004d4:	7aaa                	ld	s5,168(sp)
ffffffffc02004d6:	7b0a                	ld	s6,160(sp)
ffffffffc02004d8:	6bea                	ld	s7,152(sp)
ffffffffc02004da:	6c4a                	ld	s8,144(sp)
ffffffffc02004dc:	6caa                	ld	s9,136(sp)
ffffffffc02004de:	6d0a                	ld	s10,128(sp)
ffffffffc02004e0:	612d                	addi	sp,sp,224
ffffffffc02004e2:	8082                	ret
ffffffffc02004e4:	8526                	mv	a0,s1
ffffffffc02004e6:	5230a0ef          	jal	ra,ffffffffc020b208 <strchr>
ffffffffc02004ea:	c901                	beqz	a0,ffffffffc02004fa <kmonitor+0xf6>
ffffffffc02004ec:	00144583          	lbu	a1,1(s0)
ffffffffc02004f0:	00040023          	sb	zero,0(s0)
ffffffffc02004f4:	0405                	addi	s0,s0,1
ffffffffc02004f6:	d5c9                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc02004f8:	b7f5                	j	ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc02004fa:	00044783          	lbu	a5,0(s0)
ffffffffc02004fe:	d3c9                	beqz	a5,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200500:	033c8963          	beq	s9,s3,ffffffffc0200532 <kmonitor+0x12e>
ffffffffc0200504:	003c9793          	slli	a5,s9,0x3
ffffffffc0200508:	0118                	addi	a4,sp,128
ffffffffc020050a:	97ba                	add	a5,a5,a4
ffffffffc020050c:	f887b023          	sd	s0,-128(a5)
ffffffffc0200510:	00044583          	lbu	a1,0(s0)
ffffffffc0200514:	2c85                	addiw	s9,s9,1
ffffffffc0200516:	e591                	bnez	a1,ffffffffc0200522 <kmonitor+0x11e>
ffffffffc0200518:	b7b5                	j	ffffffffc0200484 <kmonitor+0x80>
ffffffffc020051a:	00144583          	lbu	a1,1(s0)
ffffffffc020051e:	0405                	addi	s0,s0,1
ffffffffc0200520:	d1a5                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200522:	8526                	mv	a0,s1
ffffffffc0200524:	4e50a0ef          	jal	ra,ffffffffc020b208 <strchr>
ffffffffc0200528:	d96d                	beqz	a0,ffffffffc020051a <kmonitor+0x116>
ffffffffc020052a:	00044583          	lbu	a1,0(s0)
ffffffffc020052e:	d9a9                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200530:	bf55                	j	ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc0200532:	45c1                	li	a1,16
ffffffffc0200534:	855a                	mv	a0,s6
ffffffffc0200536:	bf5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020053a:	b7e9                	j	ffffffffc0200504 <kmonitor+0x100>
ffffffffc020053c:	6582                	ld	a1,0(sp)
ffffffffc020053e:	0000b517          	auipc	a0,0xb
ffffffffc0200542:	47250513          	addi	a0,a0,1138 # ffffffffc020b9b0 <etext+0x296>
ffffffffc0200546:	be5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020054a:	b715                	j	ffffffffc020046e <kmonitor+0x6a>

ffffffffc020054c <dtb_init>:
ffffffffc020054c:	7119                	addi	sp,sp,-128
ffffffffc020054e:	0000b517          	auipc	a0,0xb
ffffffffc0200552:	4c250513          	addi	a0,a0,1218 # ffffffffc020ba10 <commands+0x48>
ffffffffc0200556:	fc86                	sd	ra,120(sp)
ffffffffc0200558:	f8a2                	sd	s0,112(sp)
ffffffffc020055a:	e8d2                	sd	s4,80(sp)
ffffffffc020055c:	f4a6                	sd	s1,104(sp)
ffffffffc020055e:	f0ca                	sd	s2,96(sp)
ffffffffc0200560:	ecce                	sd	s3,88(sp)
ffffffffc0200562:	e4d6                	sd	s5,72(sp)
ffffffffc0200564:	e0da                	sd	s6,64(sp)
ffffffffc0200566:	fc5e                	sd	s7,56(sp)
ffffffffc0200568:	f862                	sd	s8,48(sp)
ffffffffc020056a:	f466                	sd	s9,40(sp)
ffffffffc020056c:	f06a                	sd	s10,32(sp)
ffffffffc020056e:	ec6e                	sd	s11,24(sp)
ffffffffc0200570:	bbbff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200574:	00014597          	auipc	a1,0x14
ffffffffc0200578:	a8c5b583          	ld	a1,-1396(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc020057c:	0000b517          	auipc	a0,0xb
ffffffffc0200580:	4a450513          	addi	a0,a0,1188 # ffffffffc020ba20 <commands+0x58>
ffffffffc0200584:	ba7ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200588:	00014417          	auipc	s0,0x14
ffffffffc020058c:	a8040413          	addi	s0,s0,-1408 # ffffffffc0214008 <boot_dtb>
ffffffffc0200590:	600c                	ld	a1,0(s0)
ffffffffc0200592:	0000b517          	auipc	a0,0xb
ffffffffc0200596:	49e50513          	addi	a0,a0,1182 # ffffffffc020ba30 <commands+0x68>
ffffffffc020059a:	b91ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020059e:	00043a03          	ld	s4,0(s0)
ffffffffc02005a2:	0000b517          	auipc	a0,0xb
ffffffffc02005a6:	4a650513          	addi	a0,a0,1190 # ffffffffc020ba48 <commands+0x80>
ffffffffc02005aa:	120a0463          	beqz	s4,ffffffffc02006d2 <dtb_init+0x186>
ffffffffc02005ae:	57f5                	li	a5,-3
ffffffffc02005b0:	07fa                	slli	a5,a5,0x1e
ffffffffc02005b2:	00fa0733          	add	a4,s4,a5
ffffffffc02005b6:	431c                	lw	a5,0(a4)
ffffffffc02005b8:	00ff0637          	lui	a2,0xff0
ffffffffc02005bc:	6b41                	lui	s6,0x10
ffffffffc02005be:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005c2:	0187969b          	slliw	a3,a5,0x18
ffffffffc02005c6:	0187d51b          	srliw	a0,a5,0x18
ffffffffc02005ca:	0105959b          	slliw	a1,a1,0x10
ffffffffc02005ce:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02005d2:	8df1                	and	a1,a1,a2
ffffffffc02005d4:	8ec9                	or	a3,a3,a0
ffffffffc02005d6:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005da:	1b7d                	addi	s6,s6,-1
ffffffffc02005dc:	0167f7b3          	and	a5,a5,s6
ffffffffc02005e0:	8dd5                	or	a1,a1,a3
ffffffffc02005e2:	8ddd                	or	a1,a1,a5
ffffffffc02005e4:	d00e07b7          	lui	a5,0xd00e0
ffffffffc02005e8:	2581                	sext.w	a1,a1
ffffffffc02005ea:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc02005ee:	10f59163          	bne	a1,a5,ffffffffc02006f0 <dtb_init+0x1a4>
ffffffffc02005f2:	471c                	lw	a5,8(a4)
ffffffffc02005f4:	4754                	lw	a3,12(a4)
ffffffffc02005f6:	4c81                	li	s9,0
ffffffffc02005f8:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005fc:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200600:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200604:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200608:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020060c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200610:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200614:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200618:	0105959b          	slliw	a1,a1,0x10
ffffffffc020061c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200620:	8d71                	and	a0,a0,a2
ffffffffc0200622:	01146433          	or	s0,s0,a7
ffffffffc0200626:	0086969b          	slliw	a3,a3,0x8
ffffffffc020062a:	010a6a33          	or	s4,s4,a6
ffffffffc020062e:	8e6d                	and	a2,a2,a1
ffffffffc0200630:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200634:	8c49                	or	s0,s0,a0
ffffffffc0200636:	0166f6b3          	and	a3,a3,s6
ffffffffc020063a:	00ca6a33          	or	s4,s4,a2
ffffffffc020063e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200642:	8c55                	or	s0,s0,a3
ffffffffc0200644:	00fa6a33          	or	s4,s4,a5
ffffffffc0200648:	1402                	slli	s0,s0,0x20
ffffffffc020064a:	1a02                	slli	s4,s4,0x20
ffffffffc020064c:	9001                	srli	s0,s0,0x20
ffffffffc020064e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0200652:	943a                	add	s0,s0,a4
ffffffffc0200654:	9a3a                	add	s4,s4,a4
ffffffffc0200656:	00ff0c37          	lui	s8,0xff0
ffffffffc020065a:	4b8d                	li	s7,3
ffffffffc020065c:	0000b917          	auipc	s2,0xb
ffffffffc0200660:	43c90913          	addi	s2,s2,1084 # ffffffffc020ba98 <commands+0xd0>
ffffffffc0200664:	49bd                	li	s3,15
ffffffffc0200666:	4d91                	li	s11,4
ffffffffc0200668:	4d05                	li	s10,1
ffffffffc020066a:	0000b497          	auipc	s1,0xb
ffffffffc020066e:	42648493          	addi	s1,s1,1062 # ffffffffc020ba90 <commands+0xc8>
ffffffffc0200672:	000a2703          	lw	a4,0(s4)
ffffffffc0200676:	004a0a93          	addi	s5,s4,4
ffffffffc020067a:	0087569b          	srliw	a3,a4,0x8
ffffffffc020067e:	0187179b          	slliw	a5,a4,0x18
ffffffffc0200682:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200686:	0106969b          	slliw	a3,a3,0x10
ffffffffc020068a:	0107571b          	srliw	a4,a4,0x10
ffffffffc020068e:	8fd1                	or	a5,a5,a2
ffffffffc0200690:	0186f6b3          	and	a3,a3,s8
ffffffffc0200694:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200698:	8fd5                	or	a5,a5,a3
ffffffffc020069a:	00eb7733          	and	a4,s6,a4
ffffffffc020069e:	8fd9                	or	a5,a5,a4
ffffffffc02006a0:	2781                	sext.w	a5,a5
ffffffffc02006a2:	09778c63          	beq	a5,s7,ffffffffc020073a <dtb_init+0x1ee>
ffffffffc02006a6:	00fbea63          	bltu	s7,a5,ffffffffc02006ba <dtb_init+0x16e>
ffffffffc02006aa:	07a78663          	beq	a5,s10,ffffffffc0200716 <dtb_init+0x1ca>
ffffffffc02006ae:	4709                	li	a4,2
ffffffffc02006b0:	00e79763          	bne	a5,a4,ffffffffc02006be <dtb_init+0x172>
ffffffffc02006b4:	4c81                	li	s9,0
ffffffffc02006b6:	8a56                	mv	s4,s5
ffffffffc02006b8:	bf6d                	j	ffffffffc0200672 <dtb_init+0x126>
ffffffffc02006ba:	ffb78ee3          	beq	a5,s11,ffffffffc02006b6 <dtb_init+0x16a>
ffffffffc02006be:	0000b517          	auipc	a0,0xb
ffffffffc02006c2:	45250513          	addi	a0,a0,1106 # ffffffffc020bb10 <commands+0x148>
ffffffffc02006c6:	a65ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02006ca:	0000b517          	auipc	a0,0xb
ffffffffc02006ce:	47e50513          	addi	a0,a0,1150 # ffffffffc020bb48 <commands+0x180>
ffffffffc02006d2:	7446                	ld	s0,112(sp)
ffffffffc02006d4:	70e6                	ld	ra,120(sp)
ffffffffc02006d6:	74a6                	ld	s1,104(sp)
ffffffffc02006d8:	7906                	ld	s2,96(sp)
ffffffffc02006da:	69e6                	ld	s3,88(sp)
ffffffffc02006dc:	6a46                	ld	s4,80(sp)
ffffffffc02006de:	6aa6                	ld	s5,72(sp)
ffffffffc02006e0:	6b06                	ld	s6,64(sp)
ffffffffc02006e2:	7be2                	ld	s7,56(sp)
ffffffffc02006e4:	7c42                	ld	s8,48(sp)
ffffffffc02006e6:	7ca2                	ld	s9,40(sp)
ffffffffc02006e8:	7d02                	ld	s10,32(sp)
ffffffffc02006ea:	6de2                	ld	s11,24(sp)
ffffffffc02006ec:	6109                	addi	sp,sp,128
ffffffffc02006ee:	bc35                	j	ffffffffc020012a <cprintf>
ffffffffc02006f0:	7446                	ld	s0,112(sp)
ffffffffc02006f2:	70e6                	ld	ra,120(sp)
ffffffffc02006f4:	74a6                	ld	s1,104(sp)
ffffffffc02006f6:	7906                	ld	s2,96(sp)
ffffffffc02006f8:	69e6                	ld	s3,88(sp)
ffffffffc02006fa:	6a46                	ld	s4,80(sp)
ffffffffc02006fc:	6aa6                	ld	s5,72(sp)
ffffffffc02006fe:	6b06                	ld	s6,64(sp)
ffffffffc0200700:	7be2                	ld	s7,56(sp)
ffffffffc0200702:	7c42                	ld	s8,48(sp)
ffffffffc0200704:	7ca2                	ld	s9,40(sp)
ffffffffc0200706:	7d02                	ld	s10,32(sp)
ffffffffc0200708:	6de2                	ld	s11,24(sp)
ffffffffc020070a:	0000b517          	auipc	a0,0xb
ffffffffc020070e:	35e50513          	addi	a0,a0,862 # ffffffffc020ba68 <commands+0xa0>
ffffffffc0200712:	6109                	addi	sp,sp,128
ffffffffc0200714:	bc19                	j	ffffffffc020012a <cprintf>
ffffffffc0200716:	8556                	mv	a0,s5
ffffffffc0200718:	2650a0ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc020071c:	8a2a                	mv	s4,a0
ffffffffc020071e:	4619                	li	a2,6
ffffffffc0200720:	85a6                	mv	a1,s1
ffffffffc0200722:	8556                	mv	a0,s5
ffffffffc0200724:	2a01                	sext.w	s4,s4
ffffffffc0200726:	2bd0a0ef          	jal	ra,ffffffffc020b1e2 <strncmp>
ffffffffc020072a:	e111                	bnez	a0,ffffffffc020072e <dtb_init+0x1e2>
ffffffffc020072c:	4c85                	li	s9,1
ffffffffc020072e:	0a91                	addi	s5,s5,4
ffffffffc0200730:	9ad2                	add	s5,s5,s4
ffffffffc0200732:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200736:	8a56                	mv	s4,s5
ffffffffc0200738:	bf2d                	j	ffffffffc0200672 <dtb_init+0x126>
ffffffffc020073a:	004a2783          	lw	a5,4(s4)
ffffffffc020073e:	00ca0693          	addi	a3,s4,12
ffffffffc0200742:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200746:	01879a9b          	slliw	s5,a5,0x18
ffffffffc020074a:	0187d61b          	srliw	a2,a5,0x18
ffffffffc020074e:	0107171b          	slliw	a4,a4,0x10
ffffffffc0200752:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200756:	00caeab3          	or	s5,s5,a2
ffffffffc020075a:	01877733          	and	a4,a4,s8
ffffffffc020075e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200762:	00eaeab3          	or	s5,s5,a4
ffffffffc0200766:	00fb77b3          	and	a5,s6,a5
ffffffffc020076a:	00faeab3          	or	s5,s5,a5
ffffffffc020076e:	2a81                	sext.w	s5,s5
ffffffffc0200770:	000c9c63          	bnez	s9,ffffffffc0200788 <dtb_init+0x23c>
ffffffffc0200774:	1a82                	slli	s5,s5,0x20
ffffffffc0200776:	00368793          	addi	a5,a3,3
ffffffffc020077a:	020ada93          	srli	s5,s5,0x20
ffffffffc020077e:	9abe                	add	s5,s5,a5
ffffffffc0200780:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200784:	8a56                	mv	s4,s5
ffffffffc0200786:	b5f5                	j	ffffffffc0200672 <dtb_init+0x126>
ffffffffc0200788:	008a2783          	lw	a5,8(s4)
ffffffffc020078c:	85ca                	mv	a1,s2
ffffffffc020078e:	e436                	sd	a3,8(sp)
ffffffffc0200790:	0087d51b          	srliw	a0,a5,0x8
ffffffffc0200794:	0187d61b          	srliw	a2,a5,0x18
ffffffffc0200798:	0187971b          	slliw	a4,a5,0x18
ffffffffc020079c:	0105151b          	slliw	a0,a0,0x10
ffffffffc02007a0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007a4:	8f51                	or	a4,a4,a2
ffffffffc02007a6:	01857533          	and	a0,a0,s8
ffffffffc02007aa:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007ae:	8d59                	or	a0,a0,a4
ffffffffc02007b0:	00fb77b3          	and	a5,s6,a5
ffffffffc02007b4:	8d5d                	or	a0,a0,a5
ffffffffc02007b6:	1502                	slli	a0,a0,0x20
ffffffffc02007b8:	9101                	srli	a0,a0,0x20
ffffffffc02007ba:	9522                	add	a0,a0,s0
ffffffffc02007bc:	2090a0ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc02007c0:	66a2                	ld	a3,8(sp)
ffffffffc02007c2:	f94d                	bnez	a0,ffffffffc0200774 <dtb_init+0x228>
ffffffffc02007c4:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200774 <dtb_init+0x228>
ffffffffc02007c8:	00ca3783          	ld	a5,12(s4)
ffffffffc02007cc:	014a3703          	ld	a4,20(s4)
ffffffffc02007d0:	0000b517          	auipc	a0,0xb
ffffffffc02007d4:	2d050513          	addi	a0,a0,720 # ffffffffc020baa0 <commands+0xd8>
ffffffffc02007d8:	4207d613          	srai	a2,a5,0x20
ffffffffc02007dc:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02007e0:	42075593          	srai	a1,a4,0x20
ffffffffc02007e4:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02007e8:	0186581b          	srliw	a6,a2,0x18
ffffffffc02007ec:	0187941b          	slliw	s0,a5,0x18
ffffffffc02007f0:	0107d89b          	srliw	a7,a5,0x10
ffffffffc02007f4:	0187d693          	srli	a3,a5,0x18
ffffffffc02007f8:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02007fc:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200800:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200804:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200808:	010f6f33          	or	t5,t5,a6
ffffffffc020080c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200810:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200814:	01837333          	and	t1,t1,s8
ffffffffc0200818:	01c46433          	or	s0,s0,t3
ffffffffc020081c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200820:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200824:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200828:	0107581b          	srliw	a6,a4,0x10
ffffffffc020082c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200830:	8361                	srli	a4,a4,0x18
ffffffffc0200832:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200836:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020083a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020083e:	00cb7633          	and	a2,s6,a2
ffffffffc0200842:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200846:	0085959b          	slliw	a1,a1,0x8
ffffffffc020084a:	00646433          	or	s0,s0,t1
ffffffffc020084e:	0187f7b3          	and	a5,a5,s8
ffffffffc0200852:	01fe6333          	or	t1,t3,t6
ffffffffc0200856:	01877c33          	and	s8,a4,s8
ffffffffc020085a:	0088989b          	slliw	a7,a7,0x8
ffffffffc020085e:	011b78b3          	and	a7,s6,a7
ffffffffc0200862:	005eeeb3          	or	t4,t4,t0
ffffffffc0200866:	00c6e733          	or	a4,a3,a2
ffffffffc020086a:	006c6c33          	or	s8,s8,t1
ffffffffc020086e:	010b76b3          	and	a3,s6,a6
ffffffffc0200872:	00bb7b33          	and	s6,s6,a1
ffffffffc0200876:	01d7e7b3          	or	a5,a5,t4
ffffffffc020087a:	016c6b33          	or	s6,s8,s6
ffffffffc020087e:	01146433          	or	s0,s0,a7
ffffffffc0200882:	8fd5                	or	a5,a5,a3
ffffffffc0200884:	1702                	slli	a4,a4,0x20
ffffffffc0200886:	1b02                	slli	s6,s6,0x20
ffffffffc0200888:	1782                	slli	a5,a5,0x20
ffffffffc020088a:	9301                	srli	a4,a4,0x20
ffffffffc020088c:	1402                	slli	s0,s0,0x20
ffffffffc020088e:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200892:	0167eb33          	or	s6,a5,s6
ffffffffc0200896:	8c59                	or	s0,s0,a4
ffffffffc0200898:	893ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020089c:	85a2                	mv	a1,s0
ffffffffc020089e:	0000b517          	auipc	a0,0xb
ffffffffc02008a2:	22250513          	addi	a0,a0,546 # ffffffffc020bac0 <commands+0xf8>
ffffffffc02008a6:	885ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008aa:	014b5613          	srli	a2,s6,0x14
ffffffffc02008ae:	85da                	mv	a1,s6
ffffffffc02008b0:	0000b517          	auipc	a0,0xb
ffffffffc02008b4:	22850513          	addi	a0,a0,552 # ffffffffc020bad8 <commands+0x110>
ffffffffc02008b8:	873ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008bc:	008b05b3          	add	a1,s6,s0
ffffffffc02008c0:	15fd                	addi	a1,a1,-1
ffffffffc02008c2:	0000b517          	auipc	a0,0xb
ffffffffc02008c6:	23650513          	addi	a0,a0,566 # ffffffffc020baf8 <commands+0x130>
ffffffffc02008ca:	861ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008ce:	0000b517          	auipc	a0,0xb
ffffffffc02008d2:	27a50513          	addi	a0,a0,634 # ffffffffc020bb48 <commands+0x180>
ffffffffc02008d6:	00096797          	auipc	a5,0x96
ffffffffc02008da:	f887bd23          	sd	s0,-102(a5) # ffffffffc0296870 <memory_base>
ffffffffc02008de:	00096797          	auipc	a5,0x96
ffffffffc02008e2:	f967bd23          	sd	s6,-102(a5) # ffffffffc0296878 <memory_size>
ffffffffc02008e6:	b3f5                	j	ffffffffc02006d2 <dtb_init+0x186>

ffffffffc02008e8 <get_memory_base>:
ffffffffc02008e8:	00096517          	auipc	a0,0x96
ffffffffc02008ec:	f8853503          	ld	a0,-120(a0) # ffffffffc0296870 <memory_base>
ffffffffc02008f0:	8082                	ret

ffffffffc02008f2 <get_memory_size>:
ffffffffc02008f2:	00096517          	auipc	a0,0x96
ffffffffc02008f6:	f8653503          	ld	a0,-122(a0) # ffffffffc0296878 <memory_size>
ffffffffc02008fa:	8082                	ret

ffffffffc02008fc <ramdisk_write>:
ffffffffc02008fc:	00856703          	lwu	a4,8(a0)
ffffffffc0200900:	1141                	addi	sp,sp,-16
ffffffffc0200902:	e406                	sd	ra,8(sp)
ffffffffc0200904:	8f0d                	sub	a4,a4,a1
ffffffffc0200906:	87ae                	mv	a5,a1
ffffffffc0200908:	85b2                	mv	a1,a2
ffffffffc020090a:	00e6f363          	bgeu	a3,a4,ffffffffc0200910 <ramdisk_write+0x14>
ffffffffc020090e:	8736                	mv	a4,a3
ffffffffc0200910:	6908                	ld	a0,16(a0)
ffffffffc0200912:	07a6                	slli	a5,a5,0x9
ffffffffc0200914:	00971613          	slli	a2,a4,0x9
ffffffffc0200918:	953e                	add	a0,a0,a5
ffffffffc020091a:	1570a0ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc020091e:	60a2                	ld	ra,8(sp)
ffffffffc0200920:	4501                	li	a0,0
ffffffffc0200922:	0141                	addi	sp,sp,16
ffffffffc0200924:	8082                	ret

ffffffffc0200926 <ramdisk_read>:
ffffffffc0200926:	00856783          	lwu	a5,8(a0)
ffffffffc020092a:	1141                	addi	sp,sp,-16
ffffffffc020092c:	e406                	sd	ra,8(sp)
ffffffffc020092e:	8f8d                	sub	a5,a5,a1
ffffffffc0200930:	872a                	mv	a4,a0
ffffffffc0200932:	8532                	mv	a0,a2
ffffffffc0200934:	00f6f363          	bgeu	a3,a5,ffffffffc020093a <ramdisk_read+0x14>
ffffffffc0200938:	87b6                	mv	a5,a3
ffffffffc020093a:	6b18                	ld	a4,16(a4)
ffffffffc020093c:	05a6                	slli	a1,a1,0x9
ffffffffc020093e:	00979613          	slli	a2,a5,0x9
ffffffffc0200942:	95ba                	add	a1,a1,a4
ffffffffc0200944:	12d0a0ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0200948:	60a2                	ld	ra,8(sp)
ffffffffc020094a:	4501                	li	a0,0
ffffffffc020094c:	0141                	addi	sp,sp,16
ffffffffc020094e:	8082                	ret

ffffffffc0200950 <ramdisk_init>:
ffffffffc0200950:	1101                	addi	sp,sp,-32
ffffffffc0200952:	e822                	sd	s0,16(sp)
ffffffffc0200954:	842e                	mv	s0,a1
ffffffffc0200956:	e426                	sd	s1,8(sp)
ffffffffc0200958:	05000613          	li	a2,80
ffffffffc020095c:	84aa                	mv	s1,a0
ffffffffc020095e:	4581                	li	a1,0
ffffffffc0200960:	8522                	mv	a0,s0
ffffffffc0200962:	ec06                	sd	ra,24(sp)
ffffffffc0200964:	e04a                	sd	s2,0(sp)
ffffffffc0200966:	0b90a0ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc020096a:	4785                	li	a5,1
ffffffffc020096c:	06f48b63          	beq	s1,a5,ffffffffc02009e2 <ramdisk_init+0x92>
ffffffffc0200970:	4789                	li	a5,2
ffffffffc0200972:	00090617          	auipc	a2,0x90
ffffffffc0200976:	69e60613          	addi	a2,a2,1694 # ffffffffc0291010 <arena>
ffffffffc020097a:	0001b917          	auipc	s2,0x1b
ffffffffc020097e:	39690913          	addi	s2,s2,918 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200982:	08f49563          	bne	s1,a5,ffffffffc0200a0c <ramdisk_init+0xbc>
ffffffffc0200986:	06c90863          	beq	s2,a2,ffffffffc02009f6 <ramdisk_init+0xa6>
ffffffffc020098a:	412604b3          	sub	s1,a2,s2
ffffffffc020098e:	86a6                	mv	a3,s1
ffffffffc0200990:	85ca                	mv	a1,s2
ffffffffc0200992:	167d                	addi	a2,a2,-1
ffffffffc0200994:	0000b517          	auipc	a0,0xb
ffffffffc0200998:	1e450513          	addi	a0,a0,484 # ffffffffc020bb78 <commands+0x1b0>
ffffffffc020099c:	f8eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02009a0:	57fd                	li	a5,-1
ffffffffc02009a2:	1782                	slli	a5,a5,0x20
ffffffffc02009a4:	0785                	addi	a5,a5,1
ffffffffc02009a6:	0094d49b          	srliw	s1,s1,0x9
ffffffffc02009aa:	e01c                	sd	a5,0(s0)
ffffffffc02009ac:	c404                	sw	s1,8(s0)
ffffffffc02009ae:	01243823          	sd	s2,16(s0)
ffffffffc02009b2:	02040513          	addi	a0,s0,32
ffffffffc02009b6:	0000b597          	auipc	a1,0xb
ffffffffc02009ba:	21a58593          	addi	a1,a1,538 # ffffffffc020bbd0 <commands+0x208>
ffffffffc02009be:	7f40a0ef          	jal	ra,ffffffffc020b1b2 <strcpy>
ffffffffc02009c2:	00000797          	auipc	a5,0x0
ffffffffc02009c6:	f6478793          	addi	a5,a5,-156 # ffffffffc0200926 <ramdisk_read>
ffffffffc02009ca:	e03c                	sd	a5,64(s0)
ffffffffc02009cc:	00000797          	auipc	a5,0x0
ffffffffc02009d0:	f3078793          	addi	a5,a5,-208 # ffffffffc02008fc <ramdisk_write>
ffffffffc02009d4:	60e2                	ld	ra,24(sp)
ffffffffc02009d6:	e43c                	sd	a5,72(s0)
ffffffffc02009d8:	6442                	ld	s0,16(sp)
ffffffffc02009da:	64a2                	ld	s1,8(sp)
ffffffffc02009dc:	6902                	ld	s2,0(sp)
ffffffffc02009de:	6105                	addi	sp,sp,32
ffffffffc02009e0:	8082                	ret
ffffffffc02009e2:	0001b617          	auipc	a2,0x1b
ffffffffc02009e6:	32e60613          	addi	a2,a2,814 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc02009ea:	00013917          	auipc	s2,0x13
ffffffffc02009ee:	62690913          	addi	s2,s2,1574 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc02009f2:	f8c91ce3          	bne	s2,a2,ffffffffc020098a <ramdisk_init+0x3a>
ffffffffc02009f6:	6442                	ld	s0,16(sp)
ffffffffc02009f8:	60e2                	ld	ra,24(sp)
ffffffffc02009fa:	64a2                	ld	s1,8(sp)
ffffffffc02009fc:	6902                	ld	s2,0(sp)
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	16250513          	addi	a0,a0,354 # ffffffffc020bb60 <commands+0x198>
ffffffffc0200a06:	6105                	addi	sp,sp,32
ffffffffc0200a08:	f22ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0200a0c:	0000b617          	auipc	a2,0xb
ffffffffc0200a10:	19460613          	addi	a2,a2,404 # ffffffffc020bba0 <commands+0x1d8>
ffffffffc0200a14:	03200593          	li	a1,50
ffffffffc0200a18:	0000b517          	auipc	a0,0xb
ffffffffc0200a1c:	1a050513          	addi	a0,a0,416 # ffffffffc020bbb8 <commands+0x1f0>
ffffffffc0200a20:	80fff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200a24 <clock_init>:
ffffffffc0200a24:	02000793          	li	a5,32
ffffffffc0200a28:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200a2c:	c0102573          	rdtime	a0
ffffffffc0200a30:	67e1                	lui	a5,0x18
ffffffffc0200a32:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200a36:	953e                	add	a0,a0,a5
ffffffffc0200a38:	4581                	li	a1,0
ffffffffc0200a3a:	4601                	li	a2,0
ffffffffc0200a3c:	4881                	li	a7,0
ffffffffc0200a3e:	00000073          	ecall
ffffffffc0200a42:	0000b517          	auipc	a0,0xb
ffffffffc0200a46:	19e50513          	addi	a0,a0,414 # ffffffffc020bbe0 <commands+0x218>
ffffffffc0200a4a:	00096797          	auipc	a5,0x96
ffffffffc0200a4e:	e207bb23          	sd	zero,-458(a5) # ffffffffc0296880 <ticks>
ffffffffc0200a52:	ed8ff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200a56 <clock_set_next_event>:
ffffffffc0200a56:	c0102573          	rdtime	a0
ffffffffc0200a5a:	67e1                	lui	a5,0x18
ffffffffc0200a5c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200a60:	953e                	add	a0,a0,a5
ffffffffc0200a62:	4581                	li	a1,0
ffffffffc0200a64:	4601                	li	a2,0
ffffffffc0200a66:	4881                	li	a7,0
ffffffffc0200a68:	00000073          	ecall
ffffffffc0200a6c:	8082                	ret

ffffffffc0200a6e <cons_init>:
ffffffffc0200a6e:	4501                	li	a0,0
ffffffffc0200a70:	4581                	li	a1,0
ffffffffc0200a72:	4601                	li	a2,0
ffffffffc0200a74:	4889                	li	a7,2
ffffffffc0200a76:	00000073          	ecall
ffffffffc0200a7a:	8082                	ret

ffffffffc0200a7c <cons_putc>:
ffffffffc0200a7c:	1101                	addi	sp,sp,-32
ffffffffc0200a7e:	ec06                	sd	ra,24(sp)
ffffffffc0200a80:	100027f3          	csrr	a5,sstatus
ffffffffc0200a84:	8b89                	andi	a5,a5,2
ffffffffc0200a86:	4701                	li	a4,0
ffffffffc0200a88:	ef95                	bnez	a5,ffffffffc0200ac4 <cons_putc+0x48>
ffffffffc0200a8a:	47a1                	li	a5,8
ffffffffc0200a8c:	00f50b63          	beq	a0,a5,ffffffffc0200aa2 <cons_putc+0x26>
ffffffffc0200a90:	4581                	li	a1,0
ffffffffc0200a92:	4601                	li	a2,0
ffffffffc0200a94:	4885                	li	a7,1
ffffffffc0200a96:	00000073          	ecall
ffffffffc0200a9a:	e315                	bnez	a4,ffffffffc0200abe <cons_putc+0x42>
ffffffffc0200a9c:	60e2                	ld	ra,24(sp)
ffffffffc0200a9e:	6105                	addi	sp,sp,32
ffffffffc0200aa0:	8082                	ret
ffffffffc0200aa2:	4521                	li	a0,8
ffffffffc0200aa4:	4581                	li	a1,0
ffffffffc0200aa6:	4601                	li	a2,0
ffffffffc0200aa8:	4885                	li	a7,1
ffffffffc0200aaa:	00000073          	ecall
ffffffffc0200aae:	02000513          	li	a0,32
ffffffffc0200ab2:	00000073          	ecall
ffffffffc0200ab6:	4521                	li	a0,8
ffffffffc0200ab8:	00000073          	ecall
ffffffffc0200abc:	d365                	beqz	a4,ffffffffc0200a9c <cons_putc+0x20>
ffffffffc0200abe:	60e2                	ld	ra,24(sp)
ffffffffc0200ac0:	6105                	addi	sp,sp,32
ffffffffc0200ac2:	ace1                	j	ffffffffc0200d9a <intr_enable>
ffffffffc0200ac4:	e42a                	sd	a0,8(sp)
ffffffffc0200ac6:	2da000ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0200aca:	6522                	ld	a0,8(sp)
ffffffffc0200acc:	4705                	li	a4,1
ffffffffc0200ace:	bf75                	j	ffffffffc0200a8a <cons_putc+0xe>

ffffffffc0200ad0 <cons_getc>:
ffffffffc0200ad0:	1101                	addi	sp,sp,-32
ffffffffc0200ad2:	ec06                	sd	ra,24(sp)
ffffffffc0200ad4:	100027f3          	csrr	a5,sstatus
ffffffffc0200ad8:	8b89                	andi	a5,a5,2
ffffffffc0200ada:	4801                	li	a6,0
ffffffffc0200adc:	e3d5                	bnez	a5,ffffffffc0200b80 <cons_getc+0xb0>
ffffffffc0200ade:	00091697          	auipc	a3,0x91
ffffffffc0200ae2:	98268693          	addi	a3,a3,-1662 # ffffffffc0291460 <cons>
ffffffffc0200ae6:	07f00713          	li	a4,127
ffffffffc0200aea:	20000313          	li	t1,512
ffffffffc0200aee:	a021                	j	ffffffffc0200af6 <cons_getc+0x26>
ffffffffc0200af0:	0ff57513          	zext.b	a0,a0
ffffffffc0200af4:	ef91                	bnez	a5,ffffffffc0200b10 <cons_getc+0x40>
ffffffffc0200af6:	4501                	li	a0,0
ffffffffc0200af8:	4581                	li	a1,0
ffffffffc0200afa:	4601                	li	a2,0
ffffffffc0200afc:	4889                	li	a7,2
ffffffffc0200afe:	00000073          	ecall
ffffffffc0200b02:	0005079b          	sext.w	a5,a0
ffffffffc0200b06:	0207c763          	bltz	a5,ffffffffc0200b34 <cons_getc+0x64>
ffffffffc0200b0a:	fee793e3          	bne	a5,a4,ffffffffc0200af0 <cons_getc+0x20>
ffffffffc0200b0e:	4521                	li	a0,8
ffffffffc0200b10:	2046a783          	lw	a5,516(a3)
ffffffffc0200b14:	02079613          	slli	a2,a5,0x20
ffffffffc0200b18:	9201                	srli	a2,a2,0x20
ffffffffc0200b1a:	2785                	addiw	a5,a5,1
ffffffffc0200b1c:	9636                	add	a2,a2,a3
ffffffffc0200b1e:	20f6a223          	sw	a5,516(a3)
ffffffffc0200b22:	00a60023          	sb	a0,0(a2)
ffffffffc0200b26:	fc6798e3          	bne	a5,t1,ffffffffc0200af6 <cons_getc+0x26>
ffffffffc0200b2a:	00091797          	auipc	a5,0x91
ffffffffc0200b2e:	b207ad23          	sw	zero,-1222(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200b32:	b7d1                	j	ffffffffc0200af6 <cons_getc+0x26>
ffffffffc0200b34:	2006a783          	lw	a5,512(a3)
ffffffffc0200b38:	2046a703          	lw	a4,516(a3)
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	00f70f63          	beq	a4,a5,ffffffffc0200b5c <cons_getc+0x8c>
ffffffffc0200b42:	0017861b          	addiw	a2,a5,1
ffffffffc0200b46:	1782                	slli	a5,a5,0x20
ffffffffc0200b48:	9381                	srli	a5,a5,0x20
ffffffffc0200b4a:	97b6                	add	a5,a5,a3
ffffffffc0200b4c:	20c6a023          	sw	a2,512(a3)
ffffffffc0200b50:	20000713          	li	a4,512
ffffffffc0200b54:	0007c503          	lbu	a0,0(a5)
ffffffffc0200b58:	00e60763          	beq	a2,a4,ffffffffc0200b66 <cons_getc+0x96>
ffffffffc0200b5c:	00081b63          	bnez	a6,ffffffffc0200b72 <cons_getc+0xa2>
ffffffffc0200b60:	60e2                	ld	ra,24(sp)
ffffffffc0200b62:	6105                	addi	sp,sp,32
ffffffffc0200b64:	8082                	ret
ffffffffc0200b66:	00091797          	auipc	a5,0x91
ffffffffc0200b6a:	ae07ad23          	sw	zero,-1286(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200b6e:	fe0809e3          	beqz	a6,ffffffffc0200b60 <cons_getc+0x90>
ffffffffc0200b72:	e42a                	sd	a0,8(sp)
ffffffffc0200b74:	226000ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0200b78:	60e2                	ld	ra,24(sp)
ffffffffc0200b7a:	6522                	ld	a0,8(sp)
ffffffffc0200b7c:	6105                	addi	sp,sp,32
ffffffffc0200b7e:	8082                	ret
ffffffffc0200b80:	220000ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0200b84:	4805                	li	a6,1
ffffffffc0200b86:	bfa1                	j	ffffffffc0200ade <cons_getc+0xe>

ffffffffc0200b88 <pic_init>:
ffffffffc0200b88:	8082                	ret

ffffffffc0200b8a <ide_init>:
ffffffffc0200b8a:	1141                	addi	sp,sp,-16
ffffffffc0200b8c:	00091597          	auipc	a1,0x91
ffffffffc0200b90:	b2c58593          	addi	a1,a1,-1236 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200b94:	4505                	li	a0,1
ffffffffc0200b96:	e022                	sd	s0,0(sp)
ffffffffc0200b98:	00091797          	auipc	a5,0x91
ffffffffc0200b9c:	ac07a823          	sw	zero,-1328(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200ba0:	00091797          	auipc	a5,0x91
ffffffffc0200ba4:	b007ac23          	sw	zero,-1256(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200ba8:	00091797          	auipc	a5,0x91
ffffffffc0200bac:	b607a023          	sw	zero,-1184(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200bb0:	00091797          	auipc	a5,0x91
ffffffffc0200bb4:	ba07a423          	sw	zero,-1112(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200bb8:	e406                	sd	ra,8(sp)
ffffffffc0200bba:	00091417          	auipc	s0,0x91
ffffffffc0200bbe:	aae40413          	addi	s0,s0,-1362 # ffffffffc0291668 <ide_devices>
ffffffffc0200bc2:	d8fff0ef          	jal	ra,ffffffffc0200950 <ramdisk_init>
ffffffffc0200bc6:	483c                	lw	a5,80(s0)
ffffffffc0200bc8:	cf99                	beqz	a5,ffffffffc0200be6 <ide_init+0x5c>
ffffffffc0200bca:	00091597          	auipc	a1,0x91
ffffffffc0200bce:	b3e58593          	addi	a1,a1,-1218 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200bd2:	4509                	li	a0,2
ffffffffc0200bd4:	d7dff0ef          	jal	ra,ffffffffc0200950 <ramdisk_init>
ffffffffc0200bd8:	0a042783          	lw	a5,160(s0)
ffffffffc0200bdc:	c785                	beqz	a5,ffffffffc0200c04 <ide_init+0x7a>
ffffffffc0200bde:	60a2                	ld	ra,8(sp)
ffffffffc0200be0:	6402                	ld	s0,0(sp)
ffffffffc0200be2:	0141                	addi	sp,sp,16
ffffffffc0200be4:	8082                	ret
ffffffffc0200be6:	0000b697          	auipc	a3,0xb
ffffffffc0200bea:	01a68693          	addi	a3,a3,26 # ffffffffc020bc00 <commands+0x238>
ffffffffc0200bee:	0000b617          	auipc	a2,0xb
ffffffffc0200bf2:	02a60613          	addi	a2,a2,42 # ffffffffc020bc18 <commands+0x250>
ffffffffc0200bf6:	45c5                	li	a1,17
ffffffffc0200bf8:	0000b517          	auipc	a0,0xb
ffffffffc0200bfc:	03850513          	addi	a0,a0,56 # ffffffffc020bc30 <commands+0x268>
ffffffffc0200c00:	e2eff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0200c04:	0000b697          	auipc	a3,0xb
ffffffffc0200c08:	04468693          	addi	a3,a3,68 # ffffffffc020bc48 <commands+0x280>
ffffffffc0200c0c:	0000b617          	auipc	a2,0xb
ffffffffc0200c10:	00c60613          	addi	a2,a2,12 # ffffffffc020bc18 <commands+0x250>
ffffffffc0200c14:	45d1                	li	a1,20
ffffffffc0200c16:	0000b517          	auipc	a0,0xb
ffffffffc0200c1a:	01a50513          	addi	a0,a0,26 # ffffffffc020bc30 <commands+0x268>
ffffffffc0200c1e:	e10ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200c22 <ide_device_valid>:
ffffffffc0200c22:	478d                	li	a5,3
ffffffffc0200c24:	00a7ef63          	bltu	a5,a0,ffffffffc0200c42 <ide_device_valid+0x20>
ffffffffc0200c28:	00251793          	slli	a5,a0,0x2
ffffffffc0200c2c:	953e                	add	a0,a0,a5
ffffffffc0200c2e:	0512                	slli	a0,a0,0x4
ffffffffc0200c30:	00091797          	auipc	a5,0x91
ffffffffc0200c34:	a3878793          	addi	a5,a5,-1480 # ffffffffc0291668 <ide_devices>
ffffffffc0200c38:	953e                	add	a0,a0,a5
ffffffffc0200c3a:	4108                	lw	a0,0(a0)
ffffffffc0200c3c:	00a03533          	snez	a0,a0
ffffffffc0200c40:	8082                	ret
ffffffffc0200c42:	4501                	li	a0,0
ffffffffc0200c44:	8082                	ret

ffffffffc0200c46 <ide_device_size>:
ffffffffc0200c46:	478d                	li	a5,3
ffffffffc0200c48:	02a7e163          	bltu	a5,a0,ffffffffc0200c6a <ide_device_size+0x24>
ffffffffc0200c4c:	00251793          	slli	a5,a0,0x2
ffffffffc0200c50:	953e                	add	a0,a0,a5
ffffffffc0200c52:	0512                	slli	a0,a0,0x4
ffffffffc0200c54:	00091797          	auipc	a5,0x91
ffffffffc0200c58:	a1478793          	addi	a5,a5,-1516 # ffffffffc0291668 <ide_devices>
ffffffffc0200c5c:	97aa                	add	a5,a5,a0
ffffffffc0200c5e:	4398                	lw	a4,0(a5)
ffffffffc0200c60:	4501                	li	a0,0
ffffffffc0200c62:	c709                	beqz	a4,ffffffffc0200c6c <ide_device_size+0x26>
ffffffffc0200c64:	0087e503          	lwu	a0,8(a5)
ffffffffc0200c68:	8082                	ret
ffffffffc0200c6a:	4501                	li	a0,0
ffffffffc0200c6c:	8082                	ret

ffffffffc0200c6e <ide_read_secs>:
ffffffffc0200c6e:	1141                	addi	sp,sp,-16
ffffffffc0200c70:	e406                	sd	ra,8(sp)
ffffffffc0200c72:	08000793          	li	a5,128
ffffffffc0200c76:	04d7e763          	bltu	a5,a3,ffffffffc0200cc4 <ide_read_secs+0x56>
ffffffffc0200c7a:	478d                	li	a5,3
ffffffffc0200c7c:	0005081b          	sext.w	a6,a0
ffffffffc0200c80:	04a7e263          	bltu	a5,a0,ffffffffc0200cc4 <ide_read_secs+0x56>
ffffffffc0200c84:	00281793          	slli	a5,a6,0x2
ffffffffc0200c88:	97c2                	add	a5,a5,a6
ffffffffc0200c8a:	0792                	slli	a5,a5,0x4
ffffffffc0200c8c:	00091817          	auipc	a6,0x91
ffffffffc0200c90:	9dc80813          	addi	a6,a6,-1572 # ffffffffc0291668 <ide_devices>
ffffffffc0200c94:	97c2                	add	a5,a5,a6
ffffffffc0200c96:	0007a883          	lw	a7,0(a5)
ffffffffc0200c9a:	02088563          	beqz	a7,ffffffffc0200cc4 <ide_read_secs+0x56>
ffffffffc0200c9e:	100008b7          	lui	a7,0x10000
ffffffffc0200ca2:	0515f163          	bgeu	a1,a7,ffffffffc0200ce4 <ide_read_secs+0x76>
ffffffffc0200ca6:	1582                	slli	a1,a1,0x20
ffffffffc0200ca8:	9181                	srli	a1,a1,0x20
ffffffffc0200caa:	00d58733          	add	a4,a1,a3
ffffffffc0200cae:	02e8eb63          	bltu	a7,a4,ffffffffc0200ce4 <ide_read_secs+0x76>
ffffffffc0200cb2:	00251713          	slli	a4,a0,0x2
ffffffffc0200cb6:	60a2                	ld	ra,8(sp)
ffffffffc0200cb8:	63bc                	ld	a5,64(a5)
ffffffffc0200cba:	953a                	add	a0,a0,a4
ffffffffc0200cbc:	0512                	slli	a0,a0,0x4
ffffffffc0200cbe:	9542                	add	a0,a0,a6
ffffffffc0200cc0:	0141                	addi	sp,sp,16
ffffffffc0200cc2:	8782                	jr	a5
ffffffffc0200cc4:	0000b697          	auipc	a3,0xb
ffffffffc0200cc8:	f9c68693          	addi	a3,a3,-100 # ffffffffc020bc60 <commands+0x298>
ffffffffc0200ccc:	0000b617          	auipc	a2,0xb
ffffffffc0200cd0:	f4c60613          	addi	a2,a2,-180 # ffffffffc020bc18 <commands+0x250>
ffffffffc0200cd4:	02200593          	li	a1,34
ffffffffc0200cd8:	0000b517          	auipc	a0,0xb
ffffffffc0200cdc:	f5850513          	addi	a0,a0,-168 # ffffffffc020bc30 <commands+0x268>
ffffffffc0200ce0:	d4eff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0200ce4:	0000b697          	auipc	a3,0xb
ffffffffc0200ce8:	fa468693          	addi	a3,a3,-92 # ffffffffc020bc88 <commands+0x2c0>
ffffffffc0200cec:	0000b617          	auipc	a2,0xb
ffffffffc0200cf0:	f2c60613          	addi	a2,a2,-212 # ffffffffc020bc18 <commands+0x250>
ffffffffc0200cf4:	02300593          	li	a1,35
ffffffffc0200cf8:	0000b517          	auipc	a0,0xb
ffffffffc0200cfc:	f3850513          	addi	a0,a0,-200 # ffffffffc020bc30 <commands+0x268>
ffffffffc0200d00:	d2eff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200d04 <ide_write_secs>:
ffffffffc0200d04:	1141                	addi	sp,sp,-16
ffffffffc0200d06:	e406                	sd	ra,8(sp)
ffffffffc0200d08:	08000793          	li	a5,128
ffffffffc0200d0c:	04d7e763          	bltu	a5,a3,ffffffffc0200d5a <ide_write_secs+0x56>
ffffffffc0200d10:	478d                	li	a5,3
ffffffffc0200d12:	0005081b          	sext.w	a6,a0
ffffffffc0200d16:	04a7e263          	bltu	a5,a0,ffffffffc0200d5a <ide_write_secs+0x56>
ffffffffc0200d1a:	00281793          	slli	a5,a6,0x2
ffffffffc0200d1e:	97c2                	add	a5,a5,a6
ffffffffc0200d20:	0792                	slli	a5,a5,0x4
ffffffffc0200d22:	00091817          	auipc	a6,0x91
ffffffffc0200d26:	94680813          	addi	a6,a6,-1722 # ffffffffc0291668 <ide_devices>
ffffffffc0200d2a:	97c2                	add	a5,a5,a6
ffffffffc0200d2c:	0007a883          	lw	a7,0(a5)
ffffffffc0200d30:	02088563          	beqz	a7,ffffffffc0200d5a <ide_write_secs+0x56>
ffffffffc0200d34:	100008b7          	lui	a7,0x10000
ffffffffc0200d38:	0515f163          	bgeu	a1,a7,ffffffffc0200d7a <ide_write_secs+0x76>
ffffffffc0200d3c:	1582                	slli	a1,a1,0x20
ffffffffc0200d3e:	9181                	srli	a1,a1,0x20
ffffffffc0200d40:	00d58733          	add	a4,a1,a3
ffffffffc0200d44:	02e8eb63          	bltu	a7,a4,ffffffffc0200d7a <ide_write_secs+0x76>
ffffffffc0200d48:	00251713          	slli	a4,a0,0x2
ffffffffc0200d4c:	60a2                	ld	ra,8(sp)
ffffffffc0200d4e:	67bc                	ld	a5,72(a5)
ffffffffc0200d50:	953a                	add	a0,a0,a4
ffffffffc0200d52:	0512                	slli	a0,a0,0x4
ffffffffc0200d54:	9542                	add	a0,a0,a6
ffffffffc0200d56:	0141                	addi	sp,sp,16
ffffffffc0200d58:	8782                	jr	a5
ffffffffc0200d5a:	0000b697          	auipc	a3,0xb
ffffffffc0200d5e:	f0668693          	addi	a3,a3,-250 # ffffffffc020bc60 <commands+0x298>
ffffffffc0200d62:	0000b617          	auipc	a2,0xb
ffffffffc0200d66:	eb660613          	addi	a2,a2,-330 # ffffffffc020bc18 <commands+0x250>
ffffffffc0200d6a:	02900593          	li	a1,41
ffffffffc0200d6e:	0000b517          	auipc	a0,0xb
ffffffffc0200d72:	ec250513          	addi	a0,a0,-318 # ffffffffc020bc30 <commands+0x268>
ffffffffc0200d76:	cb8ff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0200d7a:	0000b697          	auipc	a3,0xb
ffffffffc0200d7e:	f0e68693          	addi	a3,a3,-242 # ffffffffc020bc88 <commands+0x2c0>
ffffffffc0200d82:	0000b617          	auipc	a2,0xb
ffffffffc0200d86:	e9660613          	addi	a2,a2,-362 # ffffffffc020bc18 <commands+0x250>
ffffffffc0200d8a:	02a00593          	li	a1,42
ffffffffc0200d8e:	0000b517          	auipc	a0,0xb
ffffffffc0200d92:	ea250513          	addi	a0,a0,-350 # ffffffffc020bc30 <commands+0x268>
ffffffffc0200d96:	c98ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200d9a <intr_enable>:
ffffffffc0200d9a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200d9e:	8082                	ret

ffffffffc0200da0 <intr_disable>:
ffffffffc0200da0:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200da4:	8082                	ret

ffffffffc0200da6 <idt_init>:
ffffffffc0200da6:	14005073          	csrwi	sscratch,0
ffffffffc0200daa:	00000797          	auipc	a5,0x0
ffffffffc0200dae:	4d678793          	addi	a5,a5,1238 # ffffffffc0201280 <__alltraps>
ffffffffc0200db2:	10579073          	csrw	stvec,a5
ffffffffc0200db6:	000407b7          	lui	a5,0x40
ffffffffc0200dba:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dbe:	8082                	ret

ffffffffc0200dc0 <print_regs>:
ffffffffc0200dc0:	610c                	ld	a1,0(a0)
ffffffffc0200dc2:	1141                	addi	sp,sp,-16
ffffffffc0200dc4:	e022                	sd	s0,0(sp)
ffffffffc0200dc6:	842a                	mv	s0,a0
ffffffffc0200dc8:	0000b517          	auipc	a0,0xb
ffffffffc0200dcc:	f0050513          	addi	a0,a0,-256 # ffffffffc020bcc8 <commands+0x300>
ffffffffc0200dd0:	e406                	sd	ra,8(sp)
ffffffffc0200dd2:	b58ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200dd6:	640c                	ld	a1,8(s0)
ffffffffc0200dd8:	0000b517          	auipc	a0,0xb
ffffffffc0200ddc:	f0850513          	addi	a0,a0,-248 # ffffffffc020bce0 <commands+0x318>
ffffffffc0200de0:	b4aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200de4:	680c                	ld	a1,16(s0)
ffffffffc0200de6:	0000b517          	auipc	a0,0xb
ffffffffc0200dea:	f1250513          	addi	a0,a0,-238 # ffffffffc020bcf8 <commands+0x330>
ffffffffc0200dee:	b3cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200df2:	6c0c                	ld	a1,24(s0)
ffffffffc0200df4:	0000b517          	auipc	a0,0xb
ffffffffc0200df8:	f1c50513          	addi	a0,a0,-228 # ffffffffc020bd10 <commands+0x348>
ffffffffc0200dfc:	b2eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e00:	700c                	ld	a1,32(s0)
ffffffffc0200e02:	0000b517          	auipc	a0,0xb
ffffffffc0200e06:	f2650513          	addi	a0,a0,-218 # ffffffffc020bd28 <commands+0x360>
ffffffffc0200e0a:	b20ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e0e:	740c                	ld	a1,40(s0)
ffffffffc0200e10:	0000b517          	auipc	a0,0xb
ffffffffc0200e14:	f3050513          	addi	a0,a0,-208 # ffffffffc020bd40 <commands+0x378>
ffffffffc0200e18:	b12ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e1c:	780c                	ld	a1,48(s0)
ffffffffc0200e1e:	0000b517          	auipc	a0,0xb
ffffffffc0200e22:	f3a50513          	addi	a0,a0,-198 # ffffffffc020bd58 <commands+0x390>
ffffffffc0200e26:	b04ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e2a:	7c0c                	ld	a1,56(s0)
ffffffffc0200e2c:	0000b517          	auipc	a0,0xb
ffffffffc0200e30:	f4450513          	addi	a0,a0,-188 # ffffffffc020bd70 <commands+0x3a8>
ffffffffc0200e34:	af6ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e38:	602c                	ld	a1,64(s0)
ffffffffc0200e3a:	0000b517          	auipc	a0,0xb
ffffffffc0200e3e:	f4e50513          	addi	a0,a0,-178 # ffffffffc020bd88 <commands+0x3c0>
ffffffffc0200e42:	ae8ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e46:	642c                	ld	a1,72(s0)
ffffffffc0200e48:	0000b517          	auipc	a0,0xb
ffffffffc0200e4c:	f5850513          	addi	a0,a0,-168 # ffffffffc020bda0 <commands+0x3d8>
ffffffffc0200e50:	adaff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e54:	682c                	ld	a1,80(s0)
ffffffffc0200e56:	0000b517          	auipc	a0,0xb
ffffffffc0200e5a:	f6250513          	addi	a0,a0,-158 # ffffffffc020bdb8 <commands+0x3f0>
ffffffffc0200e5e:	accff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e62:	6c2c                	ld	a1,88(s0)
ffffffffc0200e64:	0000b517          	auipc	a0,0xb
ffffffffc0200e68:	f6c50513          	addi	a0,a0,-148 # ffffffffc020bdd0 <commands+0x408>
ffffffffc0200e6c:	abeff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e70:	702c                	ld	a1,96(s0)
ffffffffc0200e72:	0000b517          	auipc	a0,0xb
ffffffffc0200e76:	f7650513          	addi	a0,a0,-138 # ffffffffc020bde8 <commands+0x420>
ffffffffc0200e7a:	ab0ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e7e:	742c                	ld	a1,104(s0)
ffffffffc0200e80:	0000b517          	auipc	a0,0xb
ffffffffc0200e84:	f8050513          	addi	a0,a0,-128 # ffffffffc020be00 <commands+0x438>
ffffffffc0200e88:	aa2ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e8c:	782c                	ld	a1,112(s0)
ffffffffc0200e8e:	0000b517          	auipc	a0,0xb
ffffffffc0200e92:	f8a50513          	addi	a0,a0,-118 # ffffffffc020be18 <commands+0x450>
ffffffffc0200e96:	a94ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e9a:	7c2c                	ld	a1,120(s0)
ffffffffc0200e9c:	0000b517          	auipc	a0,0xb
ffffffffc0200ea0:	f9450513          	addi	a0,a0,-108 # ffffffffc020be30 <commands+0x468>
ffffffffc0200ea4:	a86ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ea8:	604c                	ld	a1,128(s0)
ffffffffc0200eaa:	0000b517          	auipc	a0,0xb
ffffffffc0200eae:	f9e50513          	addi	a0,a0,-98 # ffffffffc020be48 <commands+0x480>
ffffffffc0200eb2:	a78ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200eb6:	644c                	ld	a1,136(s0)
ffffffffc0200eb8:	0000b517          	auipc	a0,0xb
ffffffffc0200ebc:	fa850513          	addi	a0,a0,-88 # ffffffffc020be60 <commands+0x498>
ffffffffc0200ec0:	a6aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ec4:	684c                	ld	a1,144(s0)
ffffffffc0200ec6:	0000b517          	auipc	a0,0xb
ffffffffc0200eca:	fb250513          	addi	a0,a0,-78 # ffffffffc020be78 <commands+0x4b0>
ffffffffc0200ece:	a5cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ed2:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed4:	0000b517          	auipc	a0,0xb
ffffffffc0200ed8:	fbc50513          	addi	a0,a0,-68 # ffffffffc020be90 <commands+0x4c8>
ffffffffc0200edc:	a4eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ee0:	704c                	ld	a1,160(s0)
ffffffffc0200ee2:	0000b517          	auipc	a0,0xb
ffffffffc0200ee6:	fc650513          	addi	a0,a0,-58 # ffffffffc020bea8 <commands+0x4e0>
ffffffffc0200eea:	a40ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200eee:	744c                	ld	a1,168(s0)
ffffffffc0200ef0:	0000b517          	auipc	a0,0xb
ffffffffc0200ef4:	fd050513          	addi	a0,a0,-48 # ffffffffc020bec0 <commands+0x4f8>
ffffffffc0200ef8:	a32ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200efc:	784c                	ld	a1,176(s0)
ffffffffc0200efe:	0000b517          	auipc	a0,0xb
ffffffffc0200f02:	fda50513          	addi	a0,a0,-38 # ffffffffc020bed8 <commands+0x510>
ffffffffc0200f06:	a24ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f0a:	7c4c                	ld	a1,184(s0)
ffffffffc0200f0c:	0000b517          	auipc	a0,0xb
ffffffffc0200f10:	fe450513          	addi	a0,a0,-28 # ffffffffc020bef0 <commands+0x528>
ffffffffc0200f14:	a16ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f18:	606c                	ld	a1,192(s0)
ffffffffc0200f1a:	0000b517          	auipc	a0,0xb
ffffffffc0200f1e:	fee50513          	addi	a0,a0,-18 # ffffffffc020bf08 <commands+0x540>
ffffffffc0200f22:	a08ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f26:	646c                	ld	a1,200(s0)
ffffffffc0200f28:	0000b517          	auipc	a0,0xb
ffffffffc0200f2c:	ff850513          	addi	a0,a0,-8 # ffffffffc020bf20 <commands+0x558>
ffffffffc0200f30:	9faff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f34:	686c                	ld	a1,208(s0)
ffffffffc0200f36:	0000b517          	auipc	a0,0xb
ffffffffc0200f3a:	00250513          	addi	a0,a0,2 # ffffffffc020bf38 <commands+0x570>
ffffffffc0200f3e:	9ecff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f42:	6c6c                	ld	a1,216(s0)
ffffffffc0200f44:	0000b517          	auipc	a0,0xb
ffffffffc0200f48:	00c50513          	addi	a0,a0,12 # ffffffffc020bf50 <commands+0x588>
ffffffffc0200f4c:	9deff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f50:	706c                	ld	a1,224(s0)
ffffffffc0200f52:	0000b517          	auipc	a0,0xb
ffffffffc0200f56:	01650513          	addi	a0,a0,22 # ffffffffc020bf68 <commands+0x5a0>
ffffffffc0200f5a:	9d0ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f5e:	746c                	ld	a1,232(s0)
ffffffffc0200f60:	0000b517          	auipc	a0,0xb
ffffffffc0200f64:	02050513          	addi	a0,a0,32 # ffffffffc020bf80 <commands+0x5b8>
ffffffffc0200f68:	9c2ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f6c:	786c                	ld	a1,240(s0)
ffffffffc0200f6e:	0000b517          	auipc	a0,0xb
ffffffffc0200f72:	02a50513          	addi	a0,a0,42 # ffffffffc020bf98 <commands+0x5d0>
ffffffffc0200f76:	9b4ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f7a:	7c6c                	ld	a1,248(s0)
ffffffffc0200f7c:	6402                	ld	s0,0(sp)
ffffffffc0200f7e:	60a2                	ld	ra,8(sp)
ffffffffc0200f80:	0000b517          	auipc	a0,0xb
ffffffffc0200f84:	03050513          	addi	a0,a0,48 # ffffffffc020bfb0 <commands+0x5e8>
ffffffffc0200f88:	0141                	addi	sp,sp,16
ffffffffc0200f8a:	9a0ff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200f8e <print_trapframe>:
ffffffffc0200f8e:	1141                	addi	sp,sp,-16
ffffffffc0200f90:	e022                	sd	s0,0(sp)
ffffffffc0200f92:	85aa                	mv	a1,a0
ffffffffc0200f94:	842a                	mv	s0,a0
ffffffffc0200f96:	0000b517          	auipc	a0,0xb
ffffffffc0200f9a:	03250513          	addi	a0,a0,50 # ffffffffc020bfc8 <commands+0x600>
ffffffffc0200f9e:	e406                	sd	ra,8(sp)
ffffffffc0200fa0:	98aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fa4:	8522                	mv	a0,s0
ffffffffc0200fa6:	e1bff0ef          	jal	ra,ffffffffc0200dc0 <print_regs>
ffffffffc0200faa:	10043583          	ld	a1,256(s0)
ffffffffc0200fae:	0000b517          	auipc	a0,0xb
ffffffffc0200fb2:	03250513          	addi	a0,a0,50 # ffffffffc020bfe0 <commands+0x618>
ffffffffc0200fb6:	974ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fba:	10843583          	ld	a1,264(s0)
ffffffffc0200fbe:	0000b517          	auipc	a0,0xb
ffffffffc0200fc2:	03a50513          	addi	a0,a0,58 # ffffffffc020bff8 <commands+0x630>
ffffffffc0200fc6:	964ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fca:	11043583          	ld	a1,272(s0)
ffffffffc0200fce:	0000b517          	auipc	a0,0xb
ffffffffc0200fd2:	04250513          	addi	a0,a0,66 # ffffffffc020c010 <commands+0x648>
ffffffffc0200fd6:	954ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fda:	11843583          	ld	a1,280(s0)
ffffffffc0200fde:	6402                	ld	s0,0(sp)
ffffffffc0200fe0:	60a2                	ld	ra,8(sp)
ffffffffc0200fe2:	0000b517          	auipc	a0,0xb
ffffffffc0200fe6:	03e50513          	addi	a0,a0,62 # ffffffffc020c020 <commands+0x658>
ffffffffc0200fea:	0141                	addi	sp,sp,16
ffffffffc0200fec:	93eff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200ff0 <interrupt_handler>:
ffffffffc0200ff0:	11853783          	ld	a5,280(a0)
ffffffffc0200ff4:	472d                	li	a4,11
ffffffffc0200ff6:	0786                	slli	a5,a5,0x1
ffffffffc0200ff8:	8385                	srli	a5,a5,0x1
ffffffffc0200ffa:	06f76e63          	bltu	a4,a5,ffffffffc0201076 <interrupt_handler+0x86>
ffffffffc0200ffe:	0000b717          	auipc	a4,0xb
ffffffffc0201002:	0da70713          	addi	a4,a4,218 # ffffffffc020c0d8 <commands+0x710>
ffffffffc0201006:	078a                	slli	a5,a5,0x2
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	439c                	lw	a5,0(a5)
ffffffffc020100c:	97ba                	add	a5,a5,a4
ffffffffc020100e:	8782                	jr	a5
ffffffffc0201010:	0000b517          	auipc	a0,0xb
ffffffffc0201014:	08850513          	addi	a0,a0,136 # ffffffffc020c098 <commands+0x6d0>
ffffffffc0201018:	912ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc020101c:	0000b517          	auipc	a0,0xb
ffffffffc0201020:	05c50513          	addi	a0,a0,92 # ffffffffc020c078 <commands+0x6b0>
ffffffffc0201024:	906ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201028:	0000b517          	auipc	a0,0xb
ffffffffc020102c:	01050513          	addi	a0,a0,16 # ffffffffc020c038 <commands+0x670>
ffffffffc0201030:	8faff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201034:	0000b517          	auipc	a0,0xb
ffffffffc0201038:	02450513          	addi	a0,a0,36 # ffffffffc020c058 <commands+0x690>
ffffffffc020103c:	8eeff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201040:	1141                	addi	sp,sp,-16
ffffffffc0201042:	e406                	sd	ra,8(sp)
ffffffffc0201044:	a13ff0ef          	jal	ra,ffffffffc0200a56 <clock_set_next_event>
ffffffffc0201048:	00096717          	auipc	a4,0x96
ffffffffc020104c:	83870713          	addi	a4,a4,-1992 # ffffffffc0296880 <ticks>
ffffffffc0201050:	631c                	ld	a5,0(a4)
ffffffffc0201052:	0785                	addi	a5,a5,1
ffffffffc0201054:	e31c                	sd	a5,0(a4)
ffffffffc0201056:	56c060ef          	jal	ra,ffffffffc02075c2 <run_timer_list>
ffffffffc020105a:	a77ff0ef          	jal	ra,ffffffffc0200ad0 <cons_getc>
ffffffffc020105e:	60a2                	ld	ra,8(sp)
ffffffffc0201060:	0ff57513          	zext.b	a0,a0
ffffffffc0201064:	0141                	addi	sp,sp,16
ffffffffc0201066:	76a0706f          	j	ffffffffc02087d0 <dev_stdin_write>
ffffffffc020106a:	0000b517          	auipc	a0,0xb
ffffffffc020106e:	04e50513          	addi	a0,a0,78 # ffffffffc020c0b8 <commands+0x6f0>
ffffffffc0201072:	8b8ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201076:	bf21                	j	ffffffffc0200f8e <print_trapframe>

ffffffffc0201078 <exception_handler>:
ffffffffc0201078:	11853783          	ld	a5,280(a0)
ffffffffc020107c:	1141                	addi	sp,sp,-16
ffffffffc020107e:	e022                	sd	s0,0(sp)
ffffffffc0201080:	e406                	sd	ra,8(sp)
ffffffffc0201082:	473d                	li	a4,15
ffffffffc0201084:	842a                	mv	s0,a0
ffffffffc0201086:	12f76b63          	bltu	a4,a5,ffffffffc02011bc <exception_handler+0x144>
ffffffffc020108a:	0000b717          	auipc	a4,0xb
ffffffffc020108e:	24670713          	addi	a4,a4,582 # ffffffffc020c2d0 <commands+0x908>
ffffffffc0201092:	078a                	slli	a5,a5,0x2
ffffffffc0201094:	97ba                	add	a5,a5,a4
ffffffffc0201096:	439c                	lw	a5,0(a5)
ffffffffc0201098:	97ba                	add	a5,a5,a4
ffffffffc020109a:	8782                	jr	a5
ffffffffc020109c:	0000b517          	auipc	a0,0xb
ffffffffc02010a0:	15450513          	addi	a0,a0,340 # ffffffffc020c1f0 <commands+0x828>
ffffffffc02010a4:	886ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02010a8:	10843783          	ld	a5,264(s0)
ffffffffc02010ac:	60a2                	ld	ra,8(sp)
ffffffffc02010ae:	0791                	addi	a5,a5,4
ffffffffc02010b0:	10f43423          	sd	a5,264(s0)
ffffffffc02010b4:	6402                	ld	s0,0(sp)
ffffffffc02010b6:	0141                	addi	sp,sp,16
ffffffffc02010b8:	0090606f          	j	ffffffffc02078c0 <syscall>
ffffffffc02010bc:	0000b517          	auipc	a0,0xb
ffffffffc02010c0:	15450513          	addi	a0,a0,340 # ffffffffc020c210 <commands+0x848>
ffffffffc02010c4:	6402                	ld	s0,0(sp)
ffffffffc02010c6:	60a2                	ld	ra,8(sp)
ffffffffc02010c8:	0141                	addi	sp,sp,16
ffffffffc02010ca:	860ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc02010ce:	0000b517          	auipc	a0,0xb
ffffffffc02010d2:	16250513          	addi	a0,a0,354 # ffffffffc020c230 <commands+0x868>
ffffffffc02010d6:	b7fd                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02010d8:	11053583          	ld	a1,272(a0)
ffffffffc02010dc:	0000b517          	auipc	a0,0xb
ffffffffc02010e0:	17450513          	addi	a0,a0,372 # ffffffffc020c250 <commands+0x888>
ffffffffc02010e4:	846ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02010e8:	8522                	mv	a0,s0
ffffffffc02010ea:	ea5ff0ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc02010ee:	00095797          	auipc	a5,0x95
ffffffffc02010f2:	7d27b783          	ld	a5,2002(a5) # ffffffffc02968c0 <current>
ffffffffc02010f6:	0e078463          	beqz	a5,ffffffffc02011de <exception_handler+0x166>
ffffffffc02010fa:	6402                	ld	s0,0(sp)
ffffffffc02010fc:	60a2                	ld	ra,8(sp)
ffffffffc02010fe:	555d                	li	a0,-9
ffffffffc0201100:	0141                	addi	sp,sp,16
ffffffffc0201102:	7d90406f          	j	ffffffffc02060da <do_exit>
ffffffffc0201106:	11053583          	ld	a1,272(a0)
ffffffffc020110a:	0000b517          	auipc	a0,0xb
ffffffffc020110e:	18650513          	addi	a0,a0,390 # ffffffffc020c290 <commands+0x8c8>
ffffffffc0201112:	818ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201116:	8522                	mv	a0,s0
ffffffffc0201118:	e77ff0ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc020111c:	00095797          	auipc	a5,0x95
ffffffffc0201120:	7a47b783          	ld	a5,1956(a5) # ffffffffc02968c0 <current>
ffffffffc0201124:	fbf9                	bnez	a5,ffffffffc02010fa <exception_handler+0x82>
ffffffffc0201126:	0000b617          	auipc	a2,0xb
ffffffffc020112a:	15260613          	addi	a2,a2,338 # ffffffffc020c278 <commands+0x8b0>
ffffffffc020112e:	0d800593          	li	a1,216
ffffffffc0201132:	0000b517          	auipc	a0,0xb
ffffffffc0201136:	08e50513          	addi	a0,a0,142 # ffffffffc020c1c0 <commands+0x7f8>
ffffffffc020113a:	8f4ff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020113e:	11053583          	ld	a1,272(a0)
ffffffffc0201142:	0000b517          	auipc	a0,0xb
ffffffffc0201146:	16e50513          	addi	a0,a0,366 # ffffffffc020c2b0 <commands+0x8e8>
ffffffffc020114a:	fe1fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020114e:	8522                	mv	a0,s0
ffffffffc0201150:	e3fff0ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc0201154:	00095797          	auipc	a5,0x95
ffffffffc0201158:	76c7b783          	ld	a5,1900(a5) # ffffffffc02968c0 <current>
ffffffffc020115c:	ffd9                	bnez	a5,ffffffffc02010fa <exception_handler+0x82>
ffffffffc020115e:	0000b617          	auipc	a2,0xb
ffffffffc0201162:	11a60613          	addi	a2,a2,282 # ffffffffc020c278 <commands+0x8b0>
ffffffffc0201166:	0e100593          	li	a1,225
ffffffffc020116a:	0000b517          	auipc	a0,0xb
ffffffffc020116e:	05650513          	addi	a0,a0,86 # ffffffffc020c1c0 <commands+0x7f8>
ffffffffc0201172:	8bcff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201176:	0000b517          	auipc	a0,0xb
ffffffffc020117a:	f9250513          	addi	a0,a0,-110 # ffffffffc020c108 <commands+0x740>
ffffffffc020117e:	b799                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc0201180:	0000b517          	auipc	a0,0xb
ffffffffc0201184:	fa850513          	addi	a0,a0,-88 # ffffffffc020c128 <commands+0x760>
ffffffffc0201188:	bf35                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc020118a:	0000b517          	auipc	a0,0xb
ffffffffc020118e:	fbe50513          	addi	a0,a0,-66 # ffffffffc020c148 <commands+0x780>
ffffffffc0201192:	bf0d                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc0201194:	0000b517          	auipc	a0,0xb
ffffffffc0201198:	fcc50513          	addi	a0,a0,-52 # ffffffffc020c160 <commands+0x798>
ffffffffc020119c:	b725                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc020119e:	0000b517          	auipc	a0,0xb
ffffffffc02011a2:	fd250513          	addi	a0,a0,-46 # ffffffffc020c170 <commands+0x7a8>
ffffffffc02011a6:	bf39                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02011a8:	0000b517          	auipc	a0,0xb
ffffffffc02011ac:	fe850513          	addi	a0,a0,-24 # ffffffffc020c190 <commands+0x7c8>
ffffffffc02011b0:	bf11                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02011b2:	0000b517          	auipc	a0,0xb
ffffffffc02011b6:	02650513          	addi	a0,a0,38 # ffffffffc020c1d8 <commands+0x810>
ffffffffc02011ba:	b729                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02011bc:	8522                	mv	a0,s0
ffffffffc02011be:	6402                	ld	s0,0(sp)
ffffffffc02011c0:	60a2                	ld	ra,8(sp)
ffffffffc02011c2:	0141                	addi	sp,sp,16
ffffffffc02011c4:	b3e9                	j	ffffffffc0200f8e <print_trapframe>
ffffffffc02011c6:	0000b617          	auipc	a2,0xb
ffffffffc02011ca:	fe260613          	addi	a2,a2,-30 # ffffffffc020c1a8 <commands+0x7e0>
ffffffffc02011ce:	0b400593          	li	a1,180
ffffffffc02011d2:	0000b517          	auipc	a0,0xb
ffffffffc02011d6:	fee50513          	addi	a0,a0,-18 # ffffffffc020c1c0 <commands+0x7f8>
ffffffffc02011da:	854ff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02011de:	0000b617          	auipc	a2,0xb
ffffffffc02011e2:	09a60613          	addi	a2,a2,154 # ffffffffc020c278 <commands+0x8b0>
ffffffffc02011e6:	0cf00593          	li	a1,207
ffffffffc02011ea:	0000b517          	auipc	a0,0xb
ffffffffc02011ee:	fd650513          	addi	a0,a0,-42 # ffffffffc020c1c0 <commands+0x7f8>
ffffffffc02011f2:	83cff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02011f6 <trap>:
ffffffffc02011f6:	1101                	addi	sp,sp,-32
ffffffffc02011f8:	e822                	sd	s0,16(sp)
ffffffffc02011fa:	00095417          	auipc	s0,0x95
ffffffffc02011fe:	6c640413          	addi	s0,s0,1734 # ffffffffc02968c0 <current>
ffffffffc0201202:	6018                	ld	a4,0(s0)
ffffffffc0201204:	ec06                	sd	ra,24(sp)
ffffffffc0201206:	e426                	sd	s1,8(sp)
ffffffffc0201208:	e04a                	sd	s2,0(sp)
ffffffffc020120a:	11853683          	ld	a3,280(a0)
ffffffffc020120e:	cf1d                	beqz	a4,ffffffffc020124c <trap+0x56>
ffffffffc0201210:	10053483          	ld	s1,256(a0)
ffffffffc0201214:	0a073903          	ld	s2,160(a4)
ffffffffc0201218:	f348                	sd	a0,160(a4)
ffffffffc020121a:	1004f493          	andi	s1,s1,256
ffffffffc020121e:	0206c463          	bltz	a3,ffffffffc0201246 <trap+0x50>
ffffffffc0201222:	e57ff0ef          	jal	ra,ffffffffc0201078 <exception_handler>
ffffffffc0201226:	601c                	ld	a5,0(s0)
ffffffffc0201228:	0b27b023          	sd	s2,160(a5)
ffffffffc020122c:	e499                	bnez	s1,ffffffffc020123a <trap+0x44>
ffffffffc020122e:	0b07a703          	lw	a4,176(a5)
ffffffffc0201232:	8b05                	andi	a4,a4,1
ffffffffc0201234:	e329                	bnez	a4,ffffffffc0201276 <trap+0x80>
ffffffffc0201236:	6f9c                	ld	a5,24(a5)
ffffffffc0201238:	eb85                	bnez	a5,ffffffffc0201268 <trap+0x72>
ffffffffc020123a:	60e2                	ld	ra,24(sp)
ffffffffc020123c:	6442                	ld	s0,16(sp)
ffffffffc020123e:	64a2                	ld	s1,8(sp)
ffffffffc0201240:	6902                	ld	s2,0(sp)
ffffffffc0201242:	6105                	addi	sp,sp,32
ffffffffc0201244:	8082                	ret
ffffffffc0201246:	dabff0ef          	jal	ra,ffffffffc0200ff0 <interrupt_handler>
ffffffffc020124a:	bff1                	j	ffffffffc0201226 <trap+0x30>
ffffffffc020124c:	0006c863          	bltz	a3,ffffffffc020125c <trap+0x66>
ffffffffc0201250:	6442                	ld	s0,16(sp)
ffffffffc0201252:	60e2                	ld	ra,24(sp)
ffffffffc0201254:	64a2                	ld	s1,8(sp)
ffffffffc0201256:	6902                	ld	s2,0(sp)
ffffffffc0201258:	6105                	addi	sp,sp,32
ffffffffc020125a:	bd39                	j	ffffffffc0201078 <exception_handler>
ffffffffc020125c:	6442                	ld	s0,16(sp)
ffffffffc020125e:	60e2                	ld	ra,24(sp)
ffffffffc0201260:	64a2                	ld	s1,8(sp)
ffffffffc0201262:	6902                	ld	s2,0(sp)
ffffffffc0201264:	6105                	addi	sp,sp,32
ffffffffc0201266:	b369                	j	ffffffffc0200ff0 <interrupt_handler>
ffffffffc0201268:	6442                	ld	s0,16(sp)
ffffffffc020126a:	60e2                	ld	ra,24(sp)
ffffffffc020126c:	64a2                	ld	s1,8(sp)
ffffffffc020126e:	6902                	ld	s2,0(sp)
ffffffffc0201270:	6105                	addi	sp,sp,32
ffffffffc0201272:	1440606f          	j	ffffffffc02073b6 <schedule>
ffffffffc0201276:	555d                	li	a0,-9
ffffffffc0201278:	663040ef          	jal	ra,ffffffffc02060da <do_exit>
ffffffffc020127c:	601c                	ld	a5,0(s0)
ffffffffc020127e:	bf65                	j	ffffffffc0201236 <trap+0x40>

ffffffffc0201280 <__alltraps>:
ffffffffc0201280:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201284:	00011463          	bnez	sp,ffffffffc020128c <__alltraps+0xc>
ffffffffc0201288:	14002173          	csrr	sp,sscratch
ffffffffc020128c:	712d                	addi	sp,sp,-288
ffffffffc020128e:	e002                	sd	zero,0(sp)
ffffffffc0201290:	e406                	sd	ra,8(sp)
ffffffffc0201292:	ec0e                	sd	gp,24(sp)
ffffffffc0201294:	f012                	sd	tp,32(sp)
ffffffffc0201296:	f416                	sd	t0,40(sp)
ffffffffc0201298:	f81a                	sd	t1,48(sp)
ffffffffc020129a:	fc1e                	sd	t2,56(sp)
ffffffffc020129c:	e0a2                	sd	s0,64(sp)
ffffffffc020129e:	e4a6                	sd	s1,72(sp)
ffffffffc02012a0:	e8aa                	sd	a0,80(sp)
ffffffffc02012a2:	ecae                	sd	a1,88(sp)
ffffffffc02012a4:	f0b2                	sd	a2,96(sp)
ffffffffc02012a6:	f4b6                	sd	a3,104(sp)
ffffffffc02012a8:	f8ba                	sd	a4,112(sp)
ffffffffc02012aa:	fcbe                	sd	a5,120(sp)
ffffffffc02012ac:	e142                	sd	a6,128(sp)
ffffffffc02012ae:	e546                	sd	a7,136(sp)
ffffffffc02012b0:	e94a                	sd	s2,144(sp)
ffffffffc02012b2:	ed4e                	sd	s3,152(sp)
ffffffffc02012b4:	f152                	sd	s4,160(sp)
ffffffffc02012b6:	f556                	sd	s5,168(sp)
ffffffffc02012b8:	f95a                	sd	s6,176(sp)
ffffffffc02012ba:	fd5e                	sd	s7,184(sp)
ffffffffc02012bc:	e1e2                	sd	s8,192(sp)
ffffffffc02012be:	e5e6                	sd	s9,200(sp)
ffffffffc02012c0:	e9ea                	sd	s10,208(sp)
ffffffffc02012c2:	edee                	sd	s11,216(sp)
ffffffffc02012c4:	f1f2                	sd	t3,224(sp)
ffffffffc02012c6:	f5f6                	sd	t4,232(sp)
ffffffffc02012c8:	f9fa                	sd	t5,240(sp)
ffffffffc02012ca:	fdfe                	sd	t6,248(sp)
ffffffffc02012cc:	14001473          	csrrw	s0,sscratch,zero
ffffffffc02012d0:	100024f3          	csrr	s1,sstatus
ffffffffc02012d4:	14102973          	csrr	s2,sepc
ffffffffc02012d8:	143029f3          	csrr	s3,stval
ffffffffc02012dc:	14202a73          	csrr	s4,scause
ffffffffc02012e0:	e822                	sd	s0,16(sp)
ffffffffc02012e2:	e226                	sd	s1,256(sp)
ffffffffc02012e4:	e64a                	sd	s2,264(sp)
ffffffffc02012e6:	ea4e                	sd	s3,272(sp)
ffffffffc02012e8:	ee52                	sd	s4,280(sp)
ffffffffc02012ea:	850a                	mv	a0,sp
ffffffffc02012ec:	f0bff0ef          	jal	ra,ffffffffc02011f6 <trap>

ffffffffc02012f0 <__trapret>:
ffffffffc02012f0:	6492                	ld	s1,256(sp)
ffffffffc02012f2:	6932                	ld	s2,264(sp)
ffffffffc02012f4:	1004f413          	andi	s0,s1,256
ffffffffc02012f8:	e401                	bnez	s0,ffffffffc0201300 <__trapret+0x10>
ffffffffc02012fa:	1200                	addi	s0,sp,288
ffffffffc02012fc:	14041073          	csrw	sscratch,s0
ffffffffc0201300:	10049073          	csrw	sstatus,s1
ffffffffc0201304:	14191073          	csrw	sepc,s2
ffffffffc0201308:	60a2                	ld	ra,8(sp)
ffffffffc020130a:	61e2                	ld	gp,24(sp)
ffffffffc020130c:	7202                	ld	tp,32(sp)
ffffffffc020130e:	72a2                	ld	t0,40(sp)
ffffffffc0201310:	7342                	ld	t1,48(sp)
ffffffffc0201312:	73e2                	ld	t2,56(sp)
ffffffffc0201314:	6406                	ld	s0,64(sp)
ffffffffc0201316:	64a6                	ld	s1,72(sp)
ffffffffc0201318:	6546                	ld	a0,80(sp)
ffffffffc020131a:	65e6                	ld	a1,88(sp)
ffffffffc020131c:	7606                	ld	a2,96(sp)
ffffffffc020131e:	76a6                	ld	a3,104(sp)
ffffffffc0201320:	7746                	ld	a4,112(sp)
ffffffffc0201322:	77e6                	ld	a5,120(sp)
ffffffffc0201324:	680a                	ld	a6,128(sp)
ffffffffc0201326:	68aa                	ld	a7,136(sp)
ffffffffc0201328:	694a                	ld	s2,144(sp)
ffffffffc020132a:	69ea                	ld	s3,152(sp)
ffffffffc020132c:	7a0a                	ld	s4,160(sp)
ffffffffc020132e:	7aaa                	ld	s5,168(sp)
ffffffffc0201330:	7b4a                	ld	s6,176(sp)
ffffffffc0201332:	7bea                	ld	s7,184(sp)
ffffffffc0201334:	6c0e                	ld	s8,192(sp)
ffffffffc0201336:	6cae                	ld	s9,200(sp)
ffffffffc0201338:	6d4e                	ld	s10,208(sp)
ffffffffc020133a:	6dee                	ld	s11,216(sp)
ffffffffc020133c:	7e0e                	ld	t3,224(sp)
ffffffffc020133e:	7eae                	ld	t4,232(sp)
ffffffffc0201340:	7f4e                	ld	t5,240(sp)
ffffffffc0201342:	7fee                	ld	t6,248(sp)
ffffffffc0201344:	6142                	ld	sp,16(sp)
ffffffffc0201346:	10200073          	sret

ffffffffc020134a <forkrets>:
ffffffffc020134a:	812a                	mv	sp,a0
ffffffffc020134c:	b755                	j	ffffffffc02012f0 <__trapret>

ffffffffc020134e <check_vma_overlap.part.0>:
ffffffffc020134e:	1141                	addi	sp,sp,-16
ffffffffc0201350:	0000b697          	auipc	a3,0xb
ffffffffc0201354:	fc068693          	addi	a3,a3,-64 # ffffffffc020c310 <commands+0x948>
ffffffffc0201358:	0000b617          	auipc	a2,0xb
ffffffffc020135c:	8c060613          	addi	a2,a2,-1856 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201360:	07400593          	li	a1,116
ffffffffc0201364:	0000b517          	auipc	a0,0xb
ffffffffc0201368:	fcc50513          	addi	a0,a0,-52 # ffffffffc020c330 <commands+0x968>
ffffffffc020136c:	e406                	sd	ra,8(sp)
ffffffffc020136e:	ec1fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201372 <mm_create>:
ffffffffc0201372:	1141                	addi	sp,sp,-16
ffffffffc0201374:	05800513          	li	a0,88
ffffffffc0201378:	e022                	sd	s0,0(sp)
ffffffffc020137a:	e406                	sd	ra,8(sp)
ffffffffc020137c:	233000ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0201380:	842a                	mv	s0,a0
ffffffffc0201382:	c115                	beqz	a0,ffffffffc02013a6 <mm_create+0x34>
ffffffffc0201384:	e408                	sd	a0,8(s0)
ffffffffc0201386:	e008                	sd	a0,0(s0)
ffffffffc0201388:	00053823          	sd	zero,16(a0)
ffffffffc020138c:	00053c23          	sd	zero,24(a0)
ffffffffc0201390:	02052023          	sw	zero,32(a0)
ffffffffc0201394:	02053423          	sd	zero,40(a0)
ffffffffc0201398:	02052823          	sw	zero,48(a0)
ffffffffc020139c:	4585                	li	a1,1
ffffffffc020139e:	03850513          	addi	a0,a0,56
ffffffffc02013a2:	434030ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc02013a6:	60a2                	ld	ra,8(sp)
ffffffffc02013a8:	8522                	mv	a0,s0
ffffffffc02013aa:	6402                	ld	s0,0(sp)
ffffffffc02013ac:	0141                	addi	sp,sp,16
ffffffffc02013ae:	8082                	ret

ffffffffc02013b0 <find_vma>:
ffffffffc02013b0:	86aa                	mv	a3,a0
ffffffffc02013b2:	c505                	beqz	a0,ffffffffc02013da <find_vma+0x2a>
ffffffffc02013b4:	6908                	ld	a0,16(a0)
ffffffffc02013b6:	c501                	beqz	a0,ffffffffc02013be <find_vma+0xe>
ffffffffc02013b8:	651c                	ld	a5,8(a0)
ffffffffc02013ba:	02f5f263          	bgeu	a1,a5,ffffffffc02013de <find_vma+0x2e>
ffffffffc02013be:	669c                	ld	a5,8(a3)
ffffffffc02013c0:	00f68d63          	beq	a3,a5,ffffffffc02013da <find_vma+0x2a>
ffffffffc02013c4:	fe87b703          	ld	a4,-24(a5)
ffffffffc02013c8:	00e5e663          	bltu	a1,a4,ffffffffc02013d4 <find_vma+0x24>
ffffffffc02013cc:	ff07b703          	ld	a4,-16(a5)
ffffffffc02013d0:	00e5ec63          	bltu	a1,a4,ffffffffc02013e8 <find_vma+0x38>
ffffffffc02013d4:	679c                	ld	a5,8(a5)
ffffffffc02013d6:	fef697e3          	bne	a3,a5,ffffffffc02013c4 <find_vma+0x14>
ffffffffc02013da:	4501                	li	a0,0
ffffffffc02013dc:	8082                	ret
ffffffffc02013de:	691c                	ld	a5,16(a0)
ffffffffc02013e0:	fcf5ffe3          	bgeu	a1,a5,ffffffffc02013be <find_vma+0xe>
ffffffffc02013e4:	ea88                	sd	a0,16(a3)
ffffffffc02013e6:	8082                	ret
ffffffffc02013e8:	fe078513          	addi	a0,a5,-32
ffffffffc02013ec:	ea88                	sd	a0,16(a3)
ffffffffc02013ee:	8082                	ret

ffffffffc02013f0 <insert_vma_struct>:
ffffffffc02013f0:	6590                	ld	a2,8(a1)
ffffffffc02013f2:	0105b803          	ld	a6,16(a1)
ffffffffc02013f6:	1141                	addi	sp,sp,-16
ffffffffc02013f8:	e406                	sd	ra,8(sp)
ffffffffc02013fa:	87aa                	mv	a5,a0
ffffffffc02013fc:	01066763          	bltu	a2,a6,ffffffffc020140a <insert_vma_struct+0x1a>
ffffffffc0201400:	a085                	j	ffffffffc0201460 <insert_vma_struct+0x70>
ffffffffc0201402:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201406:	04e66863          	bltu	a2,a4,ffffffffc0201456 <insert_vma_struct+0x66>
ffffffffc020140a:	86be                	mv	a3,a5
ffffffffc020140c:	679c                	ld	a5,8(a5)
ffffffffc020140e:	fef51ae3          	bne	a0,a5,ffffffffc0201402 <insert_vma_struct+0x12>
ffffffffc0201412:	02a68463          	beq	a3,a0,ffffffffc020143a <insert_vma_struct+0x4a>
ffffffffc0201416:	ff06b703          	ld	a4,-16(a3)
ffffffffc020141a:	fe86b883          	ld	a7,-24(a3)
ffffffffc020141e:	08e8f163          	bgeu	a7,a4,ffffffffc02014a0 <insert_vma_struct+0xb0>
ffffffffc0201422:	04e66f63          	bltu	a2,a4,ffffffffc0201480 <insert_vma_struct+0x90>
ffffffffc0201426:	00f50a63          	beq	a0,a5,ffffffffc020143a <insert_vma_struct+0x4a>
ffffffffc020142a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020142e:	05076963          	bltu	a4,a6,ffffffffc0201480 <insert_vma_struct+0x90>
ffffffffc0201432:	ff07b603          	ld	a2,-16(a5)
ffffffffc0201436:	02c77363          	bgeu	a4,a2,ffffffffc020145c <insert_vma_struct+0x6c>
ffffffffc020143a:	5118                	lw	a4,32(a0)
ffffffffc020143c:	e188                	sd	a0,0(a1)
ffffffffc020143e:	02058613          	addi	a2,a1,32
ffffffffc0201442:	e390                	sd	a2,0(a5)
ffffffffc0201444:	e690                	sd	a2,8(a3)
ffffffffc0201446:	60a2                	ld	ra,8(sp)
ffffffffc0201448:	f59c                	sd	a5,40(a1)
ffffffffc020144a:	f194                	sd	a3,32(a1)
ffffffffc020144c:	0017079b          	addiw	a5,a4,1
ffffffffc0201450:	d11c                	sw	a5,32(a0)
ffffffffc0201452:	0141                	addi	sp,sp,16
ffffffffc0201454:	8082                	ret
ffffffffc0201456:	fca690e3          	bne	a3,a0,ffffffffc0201416 <insert_vma_struct+0x26>
ffffffffc020145a:	bfd1                	j	ffffffffc020142e <insert_vma_struct+0x3e>
ffffffffc020145c:	ef3ff0ef          	jal	ra,ffffffffc020134e <check_vma_overlap.part.0>
ffffffffc0201460:	0000b697          	auipc	a3,0xb
ffffffffc0201464:	ee068693          	addi	a3,a3,-288 # ffffffffc020c340 <commands+0x978>
ffffffffc0201468:	0000a617          	auipc	a2,0xa
ffffffffc020146c:	7b060613          	addi	a2,a2,1968 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201470:	07a00593          	li	a1,122
ffffffffc0201474:	0000b517          	auipc	a0,0xb
ffffffffc0201478:	ebc50513          	addi	a0,a0,-324 # ffffffffc020c330 <commands+0x968>
ffffffffc020147c:	db3fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201480:	0000b697          	auipc	a3,0xb
ffffffffc0201484:	f0068693          	addi	a3,a3,-256 # ffffffffc020c380 <commands+0x9b8>
ffffffffc0201488:	0000a617          	auipc	a2,0xa
ffffffffc020148c:	79060613          	addi	a2,a2,1936 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201490:	07300593          	li	a1,115
ffffffffc0201494:	0000b517          	auipc	a0,0xb
ffffffffc0201498:	e9c50513          	addi	a0,a0,-356 # ffffffffc020c330 <commands+0x968>
ffffffffc020149c:	d93fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02014a0:	0000b697          	auipc	a3,0xb
ffffffffc02014a4:	ec068693          	addi	a3,a3,-320 # ffffffffc020c360 <commands+0x998>
ffffffffc02014a8:	0000a617          	auipc	a2,0xa
ffffffffc02014ac:	77060613          	addi	a2,a2,1904 # ffffffffc020bc18 <commands+0x250>
ffffffffc02014b0:	07200593          	li	a1,114
ffffffffc02014b4:	0000b517          	auipc	a0,0xb
ffffffffc02014b8:	e7c50513          	addi	a0,a0,-388 # ffffffffc020c330 <commands+0x968>
ffffffffc02014bc:	d73fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02014c0 <mm_destroy>:
ffffffffc02014c0:	591c                	lw	a5,48(a0)
ffffffffc02014c2:	1141                	addi	sp,sp,-16
ffffffffc02014c4:	e406                	sd	ra,8(sp)
ffffffffc02014c6:	e022                	sd	s0,0(sp)
ffffffffc02014c8:	e78d                	bnez	a5,ffffffffc02014f2 <mm_destroy+0x32>
ffffffffc02014ca:	842a                	mv	s0,a0
ffffffffc02014cc:	6508                	ld	a0,8(a0)
ffffffffc02014ce:	00a40c63          	beq	s0,a0,ffffffffc02014e6 <mm_destroy+0x26>
ffffffffc02014d2:	6118                	ld	a4,0(a0)
ffffffffc02014d4:	651c                	ld	a5,8(a0)
ffffffffc02014d6:	1501                	addi	a0,a0,-32
ffffffffc02014d8:	e71c                	sd	a5,8(a4)
ffffffffc02014da:	e398                	sd	a4,0(a5)
ffffffffc02014dc:	183000ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02014e0:	6408                	ld	a0,8(s0)
ffffffffc02014e2:	fea418e3          	bne	s0,a0,ffffffffc02014d2 <mm_destroy+0x12>
ffffffffc02014e6:	8522                	mv	a0,s0
ffffffffc02014e8:	6402                	ld	s0,0(sp)
ffffffffc02014ea:	60a2                	ld	ra,8(sp)
ffffffffc02014ec:	0141                	addi	sp,sp,16
ffffffffc02014ee:	1710006f          	j	ffffffffc0201e5e <kfree>
ffffffffc02014f2:	0000b697          	auipc	a3,0xb
ffffffffc02014f6:	eae68693          	addi	a3,a3,-338 # ffffffffc020c3a0 <commands+0x9d8>
ffffffffc02014fa:	0000a617          	auipc	a2,0xa
ffffffffc02014fe:	71e60613          	addi	a2,a2,1822 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201502:	09e00593          	li	a1,158
ffffffffc0201506:	0000b517          	auipc	a0,0xb
ffffffffc020150a:	e2a50513          	addi	a0,a0,-470 # ffffffffc020c330 <commands+0x968>
ffffffffc020150e:	d21fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201512 <mm_map>:
ffffffffc0201512:	7139                	addi	sp,sp,-64
ffffffffc0201514:	f822                	sd	s0,48(sp)
ffffffffc0201516:	6405                	lui	s0,0x1
ffffffffc0201518:	147d                	addi	s0,s0,-1
ffffffffc020151a:	77fd                	lui	a5,0xfffff
ffffffffc020151c:	9622                	add	a2,a2,s0
ffffffffc020151e:	962e                	add	a2,a2,a1
ffffffffc0201520:	f426                	sd	s1,40(sp)
ffffffffc0201522:	fc06                	sd	ra,56(sp)
ffffffffc0201524:	00f5f4b3          	and	s1,a1,a5
ffffffffc0201528:	f04a                	sd	s2,32(sp)
ffffffffc020152a:	ec4e                	sd	s3,24(sp)
ffffffffc020152c:	e852                	sd	s4,16(sp)
ffffffffc020152e:	e456                	sd	s5,8(sp)
ffffffffc0201530:	002005b7          	lui	a1,0x200
ffffffffc0201534:	00f67433          	and	s0,a2,a5
ffffffffc0201538:	06b4e363          	bltu	s1,a1,ffffffffc020159e <mm_map+0x8c>
ffffffffc020153c:	0684f163          	bgeu	s1,s0,ffffffffc020159e <mm_map+0x8c>
ffffffffc0201540:	4785                	li	a5,1
ffffffffc0201542:	07fe                	slli	a5,a5,0x1f
ffffffffc0201544:	0487ed63          	bltu	a5,s0,ffffffffc020159e <mm_map+0x8c>
ffffffffc0201548:	89aa                	mv	s3,a0
ffffffffc020154a:	cd21                	beqz	a0,ffffffffc02015a2 <mm_map+0x90>
ffffffffc020154c:	85a6                	mv	a1,s1
ffffffffc020154e:	8ab6                	mv	s5,a3
ffffffffc0201550:	8a3a                	mv	s4,a4
ffffffffc0201552:	e5fff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc0201556:	c501                	beqz	a0,ffffffffc020155e <mm_map+0x4c>
ffffffffc0201558:	651c                	ld	a5,8(a0)
ffffffffc020155a:	0487e263          	bltu	a5,s0,ffffffffc020159e <mm_map+0x8c>
ffffffffc020155e:	03000513          	li	a0,48
ffffffffc0201562:	04d000ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0201566:	892a                	mv	s2,a0
ffffffffc0201568:	5571                	li	a0,-4
ffffffffc020156a:	02090163          	beqz	s2,ffffffffc020158c <mm_map+0x7a>
ffffffffc020156e:	854e                	mv	a0,s3
ffffffffc0201570:	00993423          	sd	s1,8(s2)
ffffffffc0201574:	00893823          	sd	s0,16(s2)
ffffffffc0201578:	01592c23          	sw	s5,24(s2)
ffffffffc020157c:	85ca                	mv	a1,s2
ffffffffc020157e:	e73ff0ef          	jal	ra,ffffffffc02013f0 <insert_vma_struct>
ffffffffc0201582:	4501                	li	a0,0
ffffffffc0201584:	000a0463          	beqz	s4,ffffffffc020158c <mm_map+0x7a>
ffffffffc0201588:	012a3023          	sd	s2,0(s4)
ffffffffc020158c:	70e2                	ld	ra,56(sp)
ffffffffc020158e:	7442                	ld	s0,48(sp)
ffffffffc0201590:	74a2                	ld	s1,40(sp)
ffffffffc0201592:	7902                	ld	s2,32(sp)
ffffffffc0201594:	69e2                	ld	s3,24(sp)
ffffffffc0201596:	6a42                	ld	s4,16(sp)
ffffffffc0201598:	6aa2                	ld	s5,8(sp)
ffffffffc020159a:	6121                	addi	sp,sp,64
ffffffffc020159c:	8082                	ret
ffffffffc020159e:	5575                	li	a0,-3
ffffffffc02015a0:	b7f5                	j	ffffffffc020158c <mm_map+0x7a>
ffffffffc02015a2:	0000b697          	auipc	a3,0xb
ffffffffc02015a6:	e1668693          	addi	a3,a3,-490 # ffffffffc020c3b8 <commands+0x9f0>
ffffffffc02015aa:	0000a617          	auipc	a2,0xa
ffffffffc02015ae:	66e60613          	addi	a2,a2,1646 # ffffffffc020bc18 <commands+0x250>
ffffffffc02015b2:	0b300593          	li	a1,179
ffffffffc02015b6:	0000b517          	auipc	a0,0xb
ffffffffc02015ba:	d7a50513          	addi	a0,a0,-646 # ffffffffc020c330 <commands+0x968>
ffffffffc02015be:	c71fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02015c2 <dup_mmap>:
ffffffffc02015c2:	7139                	addi	sp,sp,-64
ffffffffc02015c4:	fc06                	sd	ra,56(sp)
ffffffffc02015c6:	f822                	sd	s0,48(sp)
ffffffffc02015c8:	f426                	sd	s1,40(sp)
ffffffffc02015ca:	f04a                	sd	s2,32(sp)
ffffffffc02015cc:	ec4e                	sd	s3,24(sp)
ffffffffc02015ce:	e852                	sd	s4,16(sp)
ffffffffc02015d0:	e456                	sd	s5,8(sp)
ffffffffc02015d2:	c52d                	beqz	a0,ffffffffc020163c <dup_mmap+0x7a>
ffffffffc02015d4:	892a                	mv	s2,a0
ffffffffc02015d6:	84ae                	mv	s1,a1
ffffffffc02015d8:	842e                	mv	s0,a1
ffffffffc02015da:	e595                	bnez	a1,ffffffffc0201606 <dup_mmap+0x44>
ffffffffc02015dc:	a085                	j	ffffffffc020163c <dup_mmap+0x7a>
ffffffffc02015de:	854a                	mv	a0,s2
ffffffffc02015e0:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc02015e4:	0145b823          	sd	s4,16(a1)
ffffffffc02015e8:	0135ac23          	sw	s3,24(a1)
ffffffffc02015ec:	e05ff0ef          	jal	ra,ffffffffc02013f0 <insert_vma_struct>
ffffffffc02015f0:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc02015f4:	fe843603          	ld	a2,-24(s0)
ffffffffc02015f8:	6c8c                	ld	a1,24(s1)
ffffffffc02015fa:	01893503          	ld	a0,24(s2)
ffffffffc02015fe:	4701                	li	a4,0
ffffffffc0201600:	391020ef          	jal	ra,ffffffffc0204190 <copy_range>
ffffffffc0201604:	e105                	bnez	a0,ffffffffc0201624 <dup_mmap+0x62>
ffffffffc0201606:	6000                	ld	s0,0(s0)
ffffffffc0201608:	02848863          	beq	s1,s0,ffffffffc0201638 <dup_mmap+0x76>
ffffffffc020160c:	03000513          	li	a0,48
ffffffffc0201610:	fe843a83          	ld	s5,-24(s0)
ffffffffc0201614:	ff043a03          	ld	s4,-16(s0)
ffffffffc0201618:	ff842983          	lw	s3,-8(s0)
ffffffffc020161c:	792000ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0201620:	85aa                	mv	a1,a0
ffffffffc0201622:	fd55                	bnez	a0,ffffffffc02015de <dup_mmap+0x1c>
ffffffffc0201624:	5571                	li	a0,-4
ffffffffc0201626:	70e2                	ld	ra,56(sp)
ffffffffc0201628:	7442                	ld	s0,48(sp)
ffffffffc020162a:	74a2                	ld	s1,40(sp)
ffffffffc020162c:	7902                	ld	s2,32(sp)
ffffffffc020162e:	69e2                	ld	s3,24(sp)
ffffffffc0201630:	6a42                	ld	s4,16(sp)
ffffffffc0201632:	6aa2                	ld	s5,8(sp)
ffffffffc0201634:	6121                	addi	sp,sp,64
ffffffffc0201636:	8082                	ret
ffffffffc0201638:	4501                	li	a0,0
ffffffffc020163a:	b7f5                	j	ffffffffc0201626 <dup_mmap+0x64>
ffffffffc020163c:	0000b697          	auipc	a3,0xb
ffffffffc0201640:	d8c68693          	addi	a3,a3,-628 # ffffffffc020c3c8 <commands+0xa00>
ffffffffc0201644:	0000a617          	auipc	a2,0xa
ffffffffc0201648:	5d460613          	addi	a2,a2,1492 # ffffffffc020bc18 <commands+0x250>
ffffffffc020164c:	0cf00593          	li	a1,207
ffffffffc0201650:	0000b517          	auipc	a0,0xb
ffffffffc0201654:	ce050513          	addi	a0,a0,-800 # ffffffffc020c330 <commands+0x968>
ffffffffc0201658:	bd7fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020165c <exit_mmap>:
ffffffffc020165c:	1101                	addi	sp,sp,-32
ffffffffc020165e:	ec06                	sd	ra,24(sp)
ffffffffc0201660:	e822                	sd	s0,16(sp)
ffffffffc0201662:	e426                	sd	s1,8(sp)
ffffffffc0201664:	e04a                	sd	s2,0(sp)
ffffffffc0201666:	c531                	beqz	a0,ffffffffc02016b2 <exit_mmap+0x56>
ffffffffc0201668:	591c                	lw	a5,48(a0)
ffffffffc020166a:	84aa                	mv	s1,a0
ffffffffc020166c:	e3b9                	bnez	a5,ffffffffc02016b2 <exit_mmap+0x56>
ffffffffc020166e:	6500                	ld	s0,8(a0)
ffffffffc0201670:	01853903          	ld	s2,24(a0)
ffffffffc0201674:	02850663          	beq	a0,s0,ffffffffc02016a0 <exit_mmap+0x44>
ffffffffc0201678:	ff043603          	ld	a2,-16(s0)
ffffffffc020167c:	fe843583          	ld	a1,-24(s0)
ffffffffc0201680:	854a                	mv	a0,s2
ffffffffc0201682:	7b2010ef          	jal	ra,ffffffffc0202e34 <unmap_range>
ffffffffc0201686:	6400                	ld	s0,8(s0)
ffffffffc0201688:	fe8498e3          	bne	s1,s0,ffffffffc0201678 <exit_mmap+0x1c>
ffffffffc020168c:	6400                	ld	s0,8(s0)
ffffffffc020168e:	00848c63          	beq	s1,s0,ffffffffc02016a6 <exit_mmap+0x4a>
ffffffffc0201692:	ff043603          	ld	a2,-16(s0)
ffffffffc0201696:	fe843583          	ld	a1,-24(s0)
ffffffffc020169a:	854a                	mv	a0,s2
ffffffffc020169c:	0df010ef          	jal	ra,ffffffffc0202f7a <exit_range>
ffffffffc02016a0:	6400                	ld	s0,8(s0)
ffffffffc02016a2:	fe8498e3          	bne	s1,s0,ffffffffc0201692 <exit_mmap+0x36>
ffffffffc02016a6:	60e2                	ld	ra,24(sp)
ffffffffc02016a8:	6442                	ld	s0,16(sp)
ffffffffc02016aa:	64a2                	ld	s1,8(sp)
ffffffffc02016ac:	6902                	ld	s2,0(sp)
ffffffffc02016ae:	6105                	addi	sp,sp,32
ffffffffc02016b0:	8082                	ret
ffffffffc02016b2:	0000b697          	auipc	a3,0xb
ffffffffc02016b6:	d3668693          	addi	a3,a3,-714 # ffffffffc020c3e8 <commands+0xa20>
ffffffffc02016ba:	0000a617          	auipc	a2,0xa
ffffffffc02016be:	55e60613          	addi	a2,a2,1374 # ffffffffc020bc18 <commands+0x250>
ffffffffc02016c2:	0e800593          	li	a1,232
ffffffffc02016c6:	0000b517          	auipc	a0,0xb
ffffffffc02016ca:	c6a50513          	addi	a0,a0,-918 # ffffffffc020c330 <commands+0x968>
ffffffffc02016ce:	b61fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02016d2 <vmm_init>:
ffffffffc02016d2:	7139                	addi	sp,sp,-64
ffffffffc02016d4:	05800513          	li	a0,88
ffffffffc02016d8:	fc06                	sd	ra,56(sp)
ffffffffc02016da:	f822                	sd	s0,48(sp)
ffffffffc02016dc:	f426                	sd	s1,40(sp)
ffffffffc02016de:	f04a                	sd	s2,32(sp)
ffffffffc02016e0:	ec4e                	sd	s3,24(sp)
ffffffffc02016e2:	e852                	sd	s4,16(sp)
ffffffffc02016e4:	e456                	sd	s5,8(sp)
ffffffffc02016e6:	6c8000ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc02016ea:	2e050963          	beqz	a0,ffffffffc02019dc <vmm_init+0x30a>
ffffffffc02016ee:	e508                	sd	a0,8(a0)
ffffffffc02016f0:	e108                	sd	a0,0(a0)
ffffffffc02016f2:	00053823          	sd	zero,16(a0)
ffffffffc02016f6:	00053c23          	sd	zero,24(a0)
ffffffffc02016fa:	02052023          	sw	zero,32(a0)
ffffffffc02016fe:	02053423          	sd	zero,40(a0)
ffffffffc0201702:	02052823          	sw	zero,48(a0)
ffffffffc0201706:	84aa                	mv	s1,a0
ffffffffc0201708:	4585                	li	a1,1
ffffffffc020170a:	03850513          	addi	a0,a0,56
ffffffffc020170e:	0c8030ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc0201712:	03200413          	li	s0,50
ffffffffc0201716:	a811                	j	ffffffffc020172a <vmm_init+0x58>
ffffffffc0201718:	e500                	sd	s0,8(a0)
ffffffffc020171a:	e91c                	sd	a5,16(a0)
ffffffffc020171c:	00052c23          	sw	zero,24(a0)
ffffffffc0201720:	146d                	addi	s0,s0,-5
ffffffffc0201722:	8526                	mv	a0,s1
ffffffffc0201724:	ccdff0ef          	jal	ra,ffffffffc02013f0 <insert_vma_struct>
ffffffffc0201728:	c80d                	beqz	s0,ffffffffc020175a <vmm_init+0x88>
ffffffffc020172a:	03000513          	li	a0,48
ffffffffc020172e:	680000ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0201732:	85aa                	mv	a1,a0
ffffffffc0201734:	00240793          	addi	a5,s0,2
ffffffffc0201738:	f165                	bnez	a0,ffffffffc0201718 <vmm_init+0x46>
ffffffffc020173a:	0000b697          	auipc	a3,0xb
ffffffffc020173e:	e4668693          	addi	a3,a3,-442 # ffffffffc020c580 <commands+0xbb8>
ffffffffc0201742:	0000a617          	auipc	a2,0xa
ffffffffc0201746:	4d660613          	addi	a2,a2,1238 # ffffffffc020bc18 <commands+0x250>
ffffffffc020174a:	12c00593          	li	a1,300
ffffffffc020174e:	0000b517          	auipc	a0,0xb
ffffffffc0201752:	be250513          	addi	a0,a0,-1054 # ffffffffc020c330 <commands+0x968>
ffffffffc0201756:	ad9fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020175a:	03700413          	li	s0,55
ffffffffc020175e:	1f900913          	li	s2,505
ffffffffc0201762:	a819                	j	ffffffffc0201778 <vmm_init+0xa6>
ffffffffc0201764:	e500                	sd	s0,8(a0)
ffffffffc0201766:	e91c                	sd	a5,16(a0)
ffffffffc0201768:	00052c23          	sw	zero,24(a0)
ffffffffc020176c:	0415                	addi	s0,s0,5
ffffffffc020176e:	8526                	mv	a0,s1
ffffffffc0201770:	c81ff0ef          	jal	ra,ffffffffc02013f0 <insert_vma_struct>
ffffffffc0201774:	03240a63          	beq	s0,s2,ffffffffc02017a8 <vmm_init+0xd6>
ffffffffc0201778:	03000513          	li	a0,48
ffffffffc020177c:	632000ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0201780:	85aa                	mv	a1,a0
ffffffffc0201782:	00240793          	addi	a5,s0,2
ffffffffc0201786:	fd79                	bnez	a0,ffffffffc0201764 <vmm_init+0x92>
ffffffffc0201788:	0000b697          	auipc	a3,0xb
ffffffffc020178c:	df868693          	addi	a3,a3,-520 # ffffffffc020c580 <commands+0xbb8>
ffffffffc0201790:	0000a617          	auipc	a2,0xa
ffffffffc0201794:	48860613          	addi	a2,a2,1160 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201798:	13300593          	li	a1,307
ffffffffc020179c:	0000b517          	auipc	a0,0xb
ffffffffc02017a0:	b9450513          	addi	a0,a0,-1132 # ffffffffc020c330 <commands+0x968>
ffffffffc02017a4:	a8bfe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02017a8:	649c                	ld	a5,8(s1)
ffffffffc02017aa:	471d                	li	a4,7
ffffffffc02017ac:	1fb00593          	li	a1,507
ffffffffc02017b0:	16f48663          	beq	s1,a5,ffffffffc020191c <vmm_init+0x24a>
ffffffffc02017b4:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc02017b8:	ffe70693          	addi	a3,a4,-2
ffffffffc02017bc:	10d61063          	bne	a2,a3,ffffffffc02018bc <vmm_init+0x1ea>
ffffffffc02017c0:	ff07b683          	ld	a3,-16(a5)
ffffffffc02017c4:	0ed71c63          	bne	a4,a3,ffffffffc02018bc <vmm_init+0x1ea>
ffffffffc02017c8:	0715                	addi	a4,a4,5
ffffffffc02017ca:	679c                	ld	a5,8(a5)
ffffffffc02017cc:	feb712e3          	bne	a4,a1,ffffffffc02017b0 <vmm_init+0xde>
ffffffffc02017d0:	4a1d                	li	s4,7
ffffffffc02017d2:	4415                	li	s0,5
ffffffffc02017d4:	1f900a93          	li	s5,505
ffffffffc02017d8:	85a2                	mv	a1,s0
ffffffffc02017da:	8526                	mv	a0,s1
ffffffffc02017dc:	bd5ff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc02017e0:	892a                	mv	s2,a0
ffffffffc02017e2:	16050d63          	beqz	a0,ffffffffc020195c <vmm_init+0x28a>
ffffffffc02017e6:	00140593          	addi	a1,s0,1
ffffffffc02017ea:	8526                	mv	a0,s1
ffffffffc02017ec:	bc5ff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc02017f0:	89aa                	mv	s3,a0
ffffffffc02017f2:	14050563          	beqz	a0,ffffffffc020193c <vmm_init+0x26a>
ffffffffc02017f6:	85d2                	mv	a1,s4
ffffffffc02017f8:	8526                	mv	a0,s1
ffffffffc02017fa:	bb7ff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc02017fe:	16051f63          	bnez	a0,ffffffffc020197c <vmm_init+0x2aa>
ffffffffc0201802:	00340593          	addi	a1,s0,3
ffffffffc0201806:	8526                	mv	a0,s1
ffffffffc0201808:	ba9ff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc020180c:	1a051863          	bnez	a0,ffffffffc02019bc <vmm_init+0x2ea>
ffffffffc0201810:	00440593          	addi	a1,s0,4
ffffffffc0201814:	8526                	mv	a0,s1
ffffffffc0201816:	b9bff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc020181a:	18051163          	bnez	a0,ffffffffc020199c <vmm_init+0x2ca>
ffffffffc020181e:	00893783          	ld	a5,8(s2)
ffffffffc0201822:	0a879d63          	bne	a5,s0,ffffffffc02018dc <vmm_init+0x20a>
ffffffffc0201826:	01093783          	ld	a5,16(s2)
ffffffffc020182a:	0b479963          	bne	a5,s4,ffffffffc02018dc <vmm_init+0x20a>
ffffffffc020182e:	0089b783          	ld	a5,8(s3)
ffffffffc0201832:	0c879563          	bne	a5,s0,ffffffffc02018fc <vmm_init+0x22a>
ffffffffc0201836:	0109b783          	ld	a5,16(s3)
ffffffffc020183a:	0d479163          	bne	a5,s4,ffffffffc02018fc <vmm_init+0x22a>
ffffffffc020183e:	0415                	addi	s0,s0,5
ffffffffc0201840:	0a15                	addi	s4,s4,5
ffffffffc0201842:	f9541be3          	bne	s0,s5,ffffffffc02017d8 <vmm_init+0x106>
ffffffffc0201846:	4411                	li	s0,4
ffffffffc0201848:	597d                	li	s2,-1
ffffffffc020184a:	85a2                	mv	a1,s0
ffffffffc020184c:	8526                	mv	a0,s1
ffffffffc020184e:	b63ff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc0201852:	0004059b          	sext.w	a1,s0
ffffffffc0201856:	c90d                	beqz	a0,ffffffffc0201888 <vmm_init+0x1b6>
ffffffffc0201858:	6914                	ld	a3,16(a0)
ffffffffc020185a:	6510                	ld	a2,8(a0)
ffffffffc020185c:	0000b517          	auipc	a0,0xb
ffffffffc0201860:	cac50513          	addi	a0,a0,-852 # ffffffffc020c508 <commands+0xb40>
ffffffffc0201864:	8c7fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201868:	0000b697          	auipc	a3,0xb
ffffffffc020186c:	cc868693          	addi	a3,a3,-824 # ffffffffc020c530 <commands+0xb68>
ffffffffc0201870:	0000a617          	auipc	a2,0xa
ffffffffc0201874:	3a860613          	addi	a2,a2,936 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201878:	15900593          	li	a1,345
ffffffffc020187c:	0000b517          	auipc	a0,0xb
ffffffffc0201880:	ab450513          	addi	a0,a0,-1356 # ffffffffc020c330 <commands+0x968>
ffffffffc0201884:	9abfe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201888:	147d                	addi	s0,s0,-1
ffffffffc020188a:	fd2410e3          	bne	s0,s2,ffffffffc020184a <vmm_init+0x178>
ffffffffc020188e:	8526                	mv	a0,s1
ffffffffc0201890:	c31ff0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0201894:	0000b517          	auipc	a0,0xb
ffffffffc0201898:	cb450513          	addi	a0,a0,-844 # ffffffffc020c548 <commands+0xb80>
ffffffffc020189c:	88ffe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02018a0:	7442                	ld	s0,48(sp)
ffffffffc02018a2:	70e2                	ld	ra,56(sp)
ffffffffc02018a4:	74a2                	ld	s1,40(sp)
ffffffffc02018a6:	7902                	ld	s2,32(sp)
ffffffffc02018a8:	69e2                	ld	s3,24(sp)
ffffffffc02018aa:	6a42                	ld	s4,16(sp)
ffffffffc02018ac:	6aa2                	ld	s5,8(sp)
ffffffffc02018ae:	0000b517          	auipc	a0,0xb
ffffffffc02018b2:	cba50513          	addi	a0,a0,-838 # ffffffffc020c568 <commands+0xba0>
ffffffffc02018b6:	6121                	addi	sp,sp,64
ffffffffc02018b8:	873fe06f          	j	ffffffffc020012a <cprintf>
ffffffffc02018bc:	0000b697          	auipc	a3,0xb
ffffffffc02018c0:	b6468693          	addi	a3,a3,-1180 # ffffffffc020c420 <commands+0xa58>
ffffffffc02018c4:	0000a617          	auipc	a2,0xa
ffffffffc02018c8:	35460613          	addi	a2,a2,852 # ffffffffc020bc18 <commands+0x250>
ffffffffc02018cc:	13d00593          	li	a1,317
ffffffffc02018d0:	0000b517          	auipc	a0,0xb
ffffffffc02018d4:	a6050513          	addi	a0,a0,-1440 # ffffffffc020c330 <commands+0x968>
ffffffffc02018d8:	957fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02018dc:	0000b697          	auipc	a3,0xb
ffffffffc02018e0:	bcc68693          	addi	a3,a3,-1076 # ffffffffc020c4a8 <commands+0xae0>
ffffffffc02018e4:	0000a617          	auipc	a2,0xa
ffffffffc02018e8:	33460613          	addi	a2,a2,820 # ffffffffc020bc18 <commands+0x250>
ffffffffc02018ec:	14e00593          	li	a1,334
ffffffffc02018f0:	0000b517          	auipc	a0,0xb
ffffffffc02018f4:	a4050513          	addi	a0,a0,-1472 # ffffffffc020c330 <commands+0x968>
ffffffffc02018f8:	937fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02018fc:	0000b697          	auipc	a3,0xb
ffffffffc0201900:	bdc68693          	addi	a3,a3,-1060 # ffffffffc020c4d8 <commands+0xb10>
ffffffffc0201904:	0000a617          	auipc	a2,0xa
ffffffffc0201908:	31460613          	addi	a2,a2,788 # ffffffffc020bc18 <commands+0x250>
ffffffffc020190c:	14f00593          	li	a1,335
ffffffffc0201910:	0000b517          	auipc	a0,0xb
ffffffffc0201914:	a2050513          	addi	a0,a0,-1504 # ffffffffc020c330 <commands+0x968>
ffffffffc0201918:	917fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020191c:	0000b697          	auipc	a3,0xb
ffffffffc0201920:	aec68693          	addi	a3,a3,-1300 # ffffffffc020c408 <commands+0xa40>
ffffffffc0201924:	0000a617          	auipc	a2,0xa
ffffffffc0201928:	2f460613          	addi	a2,a2,756 # ffffffffc020bc18 <commands+0x250>
ffffffffc020192c:	13b00593          	li	a1,315
ffffffffc0201930:	0000b517          	auipc	a0,0xb
ffffffffc0201934:	a0050513          	addi	a0,a0,-1536 # ffffffffc020c330 <commands+0x968>
ffffffffc0201938:	8f7fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020193c:	0000b697          	auipc	a3,0xb
ffffffffc0201940:	b2c68693          	addi	a3,a3,-1236 # ffffffffc020c468 <commands+0xaa0>
ffffffffc0201944:	0000a617          	auipc	a2,0xa
ffffffffc0201948:	2d460613          	addi	a2,a2,724 # ffffffffc020bc18 <commands+0x250>
ffffffffc020194c:	14600593          	li	a1,326
ffffffffc0201950:	0000b517          	auipc	a0,0xb
ffffffffc0201954:	9e050513          	addi	a0,a0,-1568 # ffffffffc020c330 <commands+0x968>
ffffffffc0201958:	8d7fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020195c:	0000b697          	auipc	a3,0xb
ffffffffc0201960:	afc68693          	addi	a3,a3,-1284 # ffffffffc020c458 <commands+0xa90>
ffffffffc0201964:	0000a617          	auipc	a2,0xa
ffffffffc0201968:	2b460613          	addi	a2,a2,692 # ffffffffc020bc18 <commands+0x250>
ffffffffc020196c:	14400593          	li	a1,324
ffffffffc0201970:	0000b517          	auipc	a0,0xb
ffffffffc0201974:	9c050513          	addi	a0,a0,-1600 # ffffffffc020c330 <commands+0x968>
ffffffffc0201978:	8b7fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020197c:	0000b697          	auipc	a3,0xb
ffffffffc0201980:	afc68693          	addi	a3,a3,-1284 # ffffffffc020c478 <commands+0xab0>
ffffffffc0201984:	0000a617          	auipc	a2,0xa
ffffffffc0201988:	29460613          	addi	a2,a2,660 # ffffffffc020bc18 <commands+0x250>
ffffffffc020198c:	14800593          	li	a1,328
ffffffffc0201990:	0000b517          	auipc	a0,0xb
ffffffffc0201994:	9a050513          	addi	a0,a0,-1632 # ffffffffc020c330 <commands+0x968>
ffffffffc0201998:	897fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020199c:	0000b697          	auipc	a3,0xb
ffffffffc02019a0:	afc68693          	addi	a3,a3,-1284 # ffffffffc020c498 <commands+0xad0>
ffffffffc02019a4:	0000a617          	auipc	a2,0xa
ffffffffc02019a8:	27460613          	addi	a2,a2,628 # ffffffffc020bc18 <commands+0x250>
ffffffffc02019ac:	14c00593          	li	a1,332
ffffffffc02019b0:	0000b517          	auipc	a0,0xb
ffffffffc02019b4:	98050513          	addi	a0,a0,-1664 # ffffffffc020c330 <commands+0x968>
ffffffffc02019b8:	877fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02019bc:	0000b697          	auipc	a3,0xb
ffffffffc02019c0:	acc68693          	addi	a3,a3,-1332 # ffffffffc020c488 <commands+0xac0>
ffffffffc02019c4:	0000a617          	auipc	a2,0xa
ffffffffc02019c8:	25460613          	addi	a2,a2,596 # ffffffffc020bc18 <commands+0x250>
ffffffffc02019cc:	14a00593          	li	a1,330
ffffffffc02019d0:	0000b517          	auipc	a0,0xb
ffffffffc02019d4:	96050513          	addi	a0,a0,-1696 # ffffffffc020c330 <commands+0x968>
ffffffffc02019d8:	857fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02019dc:	0000b697          	auipc	a3,0xb
ffffffffc02019e0:	9dc68693          	addi	a3,a3,-1572 # ffffffffc020c3b8 <commands+0x9f0>
ffffffffc02019e4:	0000a617          	auipc	a2,0xa
ffffffffc02019e8:	23460613          	addi	a2,a2,564 # ffffffffc020bc18 <commands+0x250>
ffffffffc02019ec:	12400593          	li	a1,292
ffffffffc02019f0:	0000b517          	auipc	a0,0xb
ffffffffc02019f4:	94050513          	addi	a0,a0,-1728 # ffffffffc020c330 <commands+0x968>
ffffffffc02019f8:	837fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02019fc <user_mem_check>:
ffffffffc02019fc:	7179                	addi	sp,sp,-48
ffffffffc02019fe:	f022                	sd	s0,32(sp)
ffffffffc0201a00:	f406                	sd	ra,40(sp)
ffffffffc0201a02:	ec26                	sd	s1,24(sp)
ffffffffc0201a04:	e84a                	sd	s2,16(sp)
ffffffffc0201a06:	e44e                	sd	s3,8(sp)
ffffffffc0201a08:	e052                	sd	s4,0(sp)
ffffffffc0201a0a:	842e                	mv	s0,a1
ffffffffc0201a0c:	c135                	beqz	a0,ffffffffc0201a70 <user_mem_check+0x74>
ffffffffc0201a0e:	002007b7          	lui	a5,0x200
ffffffffc0201a12:	04f5e663          	bltu	a1,a5,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a16:	00c584b3          	add	s1,a1,a2
ffffffffc0201a1a:	0495f263          	bgeu	a1,s1,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a1e:	4785                	li	a5,1
ffffffffc0201a20:	07fe                	slli	a5,a5,0x1f
ffffffffc0201a22:	0297ee63          	bltu	a5,s1,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a26:	892a                	mv	s2,a0
ffffffffc0201a28:	89b6                	mv	s3,a3
ffffffffc0201a2a:	6a05                	lui	s4,0x1
ffffffffc0201a2c:	a821                	j	ffffffffc0201a44 <user_mem_check+0x48>
ffffffffc0201a2e:	0027f693          	andi	a3,a5,2
ffffffffc0201a32:	9752                	add	a4,a4,s4
ffffffffc0201a34:	8ba1                	andi	a5,a5,8
ffffffffc0201a36:	c685                	beqz	a3,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a38:	c399                	beqz	a5,ffffffffc0201a3e <user_mem_check+0x42>
ffffffffc0201a3a:	02e46263          	bltu	s0,a4,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a3e:	6900                	ld	s0,16(a0)
ffffffffc0201a40:	04947663          	bgeu	s0,s1,ffffffffc0201a8c <user_mem_check+0x90>
ffffffffc0201a44:	85a2                	mv	a1,s0
ffffffffc0201a46:	854a                	mv	a0,s2
ffffffffc0201a48:	969ff0ef          	jal	ra,ffffffffc02013b0 <find_vma>
ffffffffc0201a4c:	c909                	beqz	a0,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a4e:	6518                	ld	a4,8(a0)
ffffffffc0201a50:	00e46763          	bltu	s0,a4,ffffffffc0201a5e <user_mem_check+0x62>
ffffffffc0201a54:	4d1c                	lw	a5,24(a0)
ffffffffc0201a56:	fc099ce3          	bnez	s3,ffffffffc0201a2e <user_mem_check+0x32>
ffffffffc0201a5a:	8b85                	andi	a5,a5,1
ffffffffc0201a5c:	f3ed                	bnez	a5,ffffffffc0201a3e <user_mem_check+0x42>
ffffffffc0201a5e:	4501                	li	a0,0
ffffffffc0201a60:	70a2                	ld	ra,40(sp)
ffffffffc0201a62:	7402                	ld	s0,32(sp)
ffffffffc0201a64:	64e2                	ld	s1,24(sp)
ffffffffc0201a66:	6942                	ld	s2,16(sp)
ffffffffc0201a68:	69a2                	ld	s3,8(sp)
ffffffffc0201a6a:	6a02                	ld	s4,0(sp)
ffffffffc0201a6c:	6145                	addi	sp,sp,48
ffffffffc0201a6e:	8082                	ret
ffffffffc0201a70:	c02007b7          	lui	a5,0xc0200
ffffffffc0201a74:	4501                	li	a0,0
ffffffffc0201a76:	fef5e5e3          	bltu	a1,a5,ffffffffc0201a60 <user_mem_check+0x64>
ffffffffc0201a7a:	962e                	add	a2,a2,a1
ffffffffc0201a7c:	fec5f2e3          	bgeu	a1,a2,ffffffffc0201a60 <user_mem_check+0x64>
ffffffffc0201a80:	c8000537          	lui	a0,0xc8000
ffffffffc0201a84:	0505                	addi	a0,a0,1
ffffffffc0201a86:	00a63533          	sltu	a0,a2,a0
ffffffffc0201a8a:	bfd9                	j	ffffffffc0201a60 <user_mem_check+0x64>
ffffffffc0201a8c:	4505                	li	a0,1
ffffffffc0201a8e:	bfc9                	j	ffffffffc0201a60 <user_mem_check+0x64>

ffffffffc0201a90 <copy_from_user>:
ffffffffc0201a90:	1101                	addi	sp,sp,-32
ffffffffc0201a92:	e822                	sd	s0,16(sp)
ffffffffc0201a94:	e426                	sd	s1,8(sp)
ffffffffc0201a96:	8432                	mv	s0,a2
ffffffffc0201a98:	84b6                	mv	s1,a3
ffffffffc0201a9a:	e04a                	sd	s2,0(sp)
ffffffffc0201a9c:	86ba                	mv	a3,a4
ffffffffc0201a9e:	892e                	mv	s2,a1
ffffffffc0201aa0:	8626                	mv	a2,s1
ffffffffc0201aa2:	85a2                	mv	a1,s0
ffffffffc0201aa4:	ec06                	sd	ra,24(sp)
ffffffffc0201aa6:	f57ff0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc0201aaa:	c519                	beqz	a0,ffffffffc0201ab8 <copy_from_user+0x28>
ffffffffc0201aac:	8626                	mv	a2,s1
ffffffffc0201aae:	85a2                	mv	a1,s0
ffffffffc0201ab0:	854a                	mv	a0,s2
ffffffffc0201ab2:	7be090ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0201ab6:	4505                	li	a0,1
ffffffffc0201ab8:	60e2                	ld	ra,24(sp)
ffffffffc0201aba:	6442                	ld	s0,16(sp)
ffffffffc0201abc:	64a2                	ld	s1,8(sp)
ffffffffc0201abe:	6902                	ld	s2,0(sp)
ffffffffc0201ac0:	6105                	addi	sp,sp,32
ffffffffc0201ac2:	8082                	ret

ffffffffc0201ac4 <copy_to_user>:
ffffffffc0201ac4:	1101                	addi	sp,sp,-32
ffffffffc0201ac6:	e822                	sd	s0,16(sp)
ffffffffc0201ac8:	8436                	mv	s0,a3
ffffffffc0201aca:	e04a                	sd	s2,0(sp)
ffffffffc0201acc:	4685                	li	a3,1
ffffffffc0201ace:	8932                	mv	s2,a2
ffffffffc0201ad0:	8622                	mv	a2,s0
ffffffffc0201ad2:	e426                	sd	s1,8(sp)
ffffffffc0201ad4:	ec06                	sd	ra,24(sp)
ffffffffc0201ad6:	84ae                	mv	s1,a1
ffffffffc0201ad8:	f25ff0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc0201adc:	c519                	beqz	a0,ffffffffc0201aea <copy_to_user+0x26>
ffffffffc0201ade:	8622                	mv	a2,s0
ffffffffc0201ae0:	85ca                	mv	a1,s2
ffffffffc0201ae2:	8526                	mv	a0,s1
ffffffffc0201ae4:	78c090ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0201ae8:	4505                	li	a0,1
ffffffffc0201aea:	60e2                	ld	ra,24(sp)
ffffffffc0201aec:	6442                	ld	s0,16(sp)
ffffffffc0201aee:	64a2                	ld	s1,8(sp)
ffffffffc0201af0:	6902                	ld	s2,0(sp)
ffffffffc0201af2:	6105                	addi	sp,sp,32
ffffffffc0201af4:	8082                	ret

ffffffffc0201af6 <copy_string>:
ffffffffc0201af6:	7139                	addi	sp,sp,-64
ffffffffc0201af8:	ec4e                	sd	s3,24(sp)
ffffffffc0201afa:	6985                	lui	s3,0x1
ffffffffc0201afc:	99b2                	add	s3,s3,a2
ffffffffc0201afe:	77fd                	lui	a5,0xfffff
ffffffffc0201b00:	00f9f9b3          	and	s3,s3,a5
ffffffffc0201b04:	f426                	sd	s1,40(sp)
ffffffffc0201b06:	f04a                	sd	s2,32(sp)
ffffffffc0201b08:	e852                	sd	s4,16(sp)
ffffffffc0201b0a:	e456                	sd	s5,8(sp)
ffffffffc0201b0c:	fc06                	sd	ra,56(sp)
ffffffffc0201b0e:	f822                	sd	s0,48(sp)
ffffffffc0201b10:	84b2                	mv	s1,a2
ffffffffc0201b12:	8aaa                	mv	s5,a0
ffffffffc0201b14:	8a2e                	mv	s4,a1
ffffffffc0201b16:	8936                	mv	s2,a3
ffffffffc0201b18:	40c989b3          	sub	s3,s3,a2
ffffffffc0201b1c:	a015                	j	ffffffffc0201b40 <copy_string+0x4a>
ffffffffc0201b1e:	678090ef          	jal	ra,ffffffffc020b196 <strnlen>
ffffffffc0201b22:	87aa                	mv	a5,a0
ffffffffc0201b24:	85a6                	mv	a1,s1
ffffffffc0201b26:	8552                	mv	a0,s4
ffffffffc0201b28:	8622                	mv	a2,s0
ffffffffc0201b2a:	0487e363          	bltu	a5,s0,ffffffffc0201b70 <copy_string+0x7a>
ffffffffc0201b2e:	0329f763          	bgeu	s3,s2,ffffffffc0201b5c <copy_string+0x66>
ffffffffc0201b32:	73e090ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0201b36:	9a22                	add	s4,s4,s0
ffffffffc0201b38:	94a2                	add	s1,s1,s0
ffffffffc0201b3a:	40890933          	sub	s2,s2,s0
ffffffffc0201b3e:	6985                	lui	s3,0x1
ffffffffc0201b40:	4681                	li	a3,0
ffffffffc0201b42:	85a6                	mv	a1,s1
ffffffffc0201b44:	8556                	mv	a0,s5
ffffffffc0201b46:	844a                	mv	s0,s2
ffffffffc0201b48:	0129f363          	bgeu	s3,s2,ffffffffc0201b4e <copy_string+0x58>
ffffffffc0201b4c:	844e                	mv	s0,s3
ffffffffc0201b4e:	8622                	mv	a2,s0
ffffffffc0201b50:	eadff0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc0201b54:	87aa                	mv	a5,a0
ffffffffc0201b56:	85a2                	mv	a1,s0
ffffffffc0201b58:	8526                	mv	a0,s1
ffffffffc0201b5a:	f3f1                	bnez	a5,ffffffffc0201b1e <copy_string+0x28>
ffffffffc0201b5c:	4501                	li	a0,0
ffffffffc0201b5e:	70e2                	ld	ra,56(sp)
ffffffffc0201b60:	7442                	ld	s0,48(sp)
ffffffffc0201b62:	74a2                	ld	s1,40(sp)
ffffffffc0201b64:	7902                	ld	s2,32(sp)
ffffffffc0201b66:	69e2                	ld	s3,24(sp)
ffffffffc0201b68:	6a42                	ld	s4,16(sp)
ffffffffc0201b6a:	6aa2                	ld	s5,8(sp)
ffffffffc0201b6c:	6121                	addi	sp,sp,64
ffffffffc0201b6e:	8082                	ret
ffffffffc0201b70:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0201b74:	6fc090ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0201b78:	4505                	li	a0,1
ffffffffc0201b7a:	b7d5                	j	ffffffffc0201b5e <copy_string+0x68>

ffffffffc0201b7c <slob_free>:
ffffffffc0201b7c:	c94d                	beqz	a0,ffffffffc0201c2e <slob_free+0xb2>
ffffffffc0201b7e:	1141                	addi	sp,sp,-16
ffffffffc0201b80:	e022                	sd	s0,0(sp)
ffffffffc0201b82:	e406                	sd	ra,8(sp)
ffffffffc0201b84:	842a                	mv	s0,a0
ffffffffc0201b86:	e9c1                	bnez	a1,ffffffffc0201c16 <slob_free+0x9a>
ffffffffc0201b88:	100027f3          	csrr	a5,sstatus
ffffffffc0201b8c:	8b89                	andi	a5,a5,2
ffffffffc0201b8e:	4501                	li	a0,0
ffffffffc0201b90:	ebd9                	bnez	a5,ffffffffc0201c26 <slob_free+0xaa>
ffffffffc0201b92:	0008f617          	auipc	a2,0x8f
ffffffffc0201b96:	4be60613          	addi	a2,a2,1214 # ffffffffc0291050 <slobfree>
ffffffffc0201b9a:	621c                	ld	a5,0(a2)
ffffffffc0201b9c:	873e                	mv	a4,a5
ffffffffc0201b9e:	679c                	ld	a5,8(a5)
ffffffffc0201ba0:	02877a63          	bgeu	a4,s0,ffffffffc0201bd4 <slob_free+0x58>
ffffffffc0201ba4:	00f46463          	bltu	s0,a5,ffffffffc0201bac <slob_free+0x30>
ffffffffc0201ba8:	fef76ae3          	bltu	a4,a5,ffffffffc0201b9c <slob_free+0x20>
ffffffffc0201bac:	400c                	lw	a1,0(s0)
ffffffffc0201bae:	00459693          	slli	a3,a1,0x4
ffffffffc0201bb2:	96a2                	add	a3,a3,s0
ffffffffc0201bb4:	02d78a63          	beq	a5,a3,ffffffffc0201be8 <slob_free+0x6c>
ffffffffc0201bb8:	4314                	lw	a3,0(a4)
ffffffffc0201bba:	e41c                	sd	a5,8(s0)
ffffffffc0201bbc:	00469793          	slli	a5,a3,0x4
ffffffffc0201bc0:	97ba                	add	a5,a5,a4
ffffffffc0201bc2:	02f40e63          	beq	s0,a5,ffffffffc0201bfe <slob_free+0x82>
ffffffffc0201bc6:	e700                	sd	s0,8(a4)
ffffffffc0201bc8:	e218                	sd	a4,0(a2)
ffffffffc0201bca:	e129                	bnez	a0,ffffffffc0201c0c <slob_free+0x90>
ffffffffc0201bcc:	60a2                	ld	ra,8(sp)
ffffffffc0201bce:	6402                	ld	s0,0(sp)
ffffffffc0201bd0:	0141                	addi	sp,sp,16
ffffffffc0201bd2:	8082                	ret
ffffffffc0201bd4:	fcf764e3          	bltu	a4,a5,ffffffffc0201b9c <slob_free+0x20>
ffffffffc0201bd8:	fcf472e3          	bgeu	s0,a5,ffffffffc0201b9c <slob_free+0x20>
ffffffffc0201bdc:	400c                	lw	a1,0(s0)
ffffffffc0201bde:	00459693          	slli	a3,a1,0x4
ffffffffc0201be2:	96a2                	add	a3,a3,s0
ffffffffc0201be4:	fcd79ae3          	bne	a5,a3,ffffffffc0201bb8 <slob_free+0x3c>
ffffffffc0201be8:	4394                	lw	a3,0(a5)
ffffffffc0201bea:	679c                	ld	a5,8(a5)
ffffffffc0201bec:	9db5                	addw	a1,a1,a3
ffffffffc0201bee:	c00c                	sw	a1,0(s0)
ffffffffc0201bf0:	4314                	lw	a3,0(a4)
ffffffffc0201bf2:	e41c                	sd	a5,8(s0)
ffffffffc0201bf4:	00469793          	slli	a5,a3,0x4
ffffffffc0201bf8:	97ba                	add	a5,a5,a4
ffffffffc0201bfa:	fcf416e3          	bne	s0,a5,ffffffffc0201bc6 <slob_free+0x4a>
ffffffffc0201bfe:	401c                	lw	a5,0(s0)
ffffffffc0201c00:	640c                	ld	a1,8(s0)
ffffffffc0201c02:	e218                	sd	a4,0(a2)
ffffffffc0201c04:	9ebd                	addw	a3,a3,a5
ffffffffc0201c06:	c314                	sw	a3,0(a4)
ffffffffc0201c08:	e70c                	sd	a1,8(a4)
ffffffffc0201c0a:	d169                	beqz	a0,ffffffffc0201bcc <slob_free+0x50>
ffffffffc0201c0c:	6402                	ld	s0,0(sp)
ffffffffc0201c0e:	60a2                	ld	ra,8(sp)
ffffffffc0201c10:	0141                	addi	sp,sp,16
ffffffffc0201c12:	988ff06f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0201c16:	25bd                	addiw	a1,a1,15
ffffffffc0201c18:	8191                	srli	a1,a1,0x4
ffffffffc0201c1a:	c10c                	sw	a1,0(a0)
ffffffffc0201c1c:	100027f3          	csrr	a5,sstatus
ffffffffc0201c20:	8b89                	andi	a5,a5,2
ffffffffc0201c22:	4501                	li	a0,0
ffffffffc0201c24:	d7bd                	beqz	a5,ffffffffc0201b92 <slob_free+0x16>
ffffffffc0201c26:	97aff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201c2a:	4505                	li	a0,1
ffffffffc0201c2c:	b79d                	j	ffffffffc0201b92 <slob_free+0x16>
ffffffffc0201c2e:	8082                	ret

ffffffffc0201c30 <__slob_get_free_pages.constprop.0>:
ffffffffc0201c30:	4785                	li	a5,1
ffffffffc0201c32:	1141                	addi	sp,sp,-16
ffffffffc0201c34:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201c38:	e406                	sd	ra,8(sp)
ffffffffc0201c3a:	601000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0201c3e:	c91d                	beqz	a0,ffffffffc0201c74 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201c40:	00095697          	auipc	a3,0x95
ffffffffc0201c44:	c686b683          	ld	a3,-920(a3) # ffffffffc02968a8 <pages>
ffffffffc0201c48:	8d15                	sub	a0,a0,a3
ffffffffc0201c4a:	8519                	srai	a0,a0,0x6
ffffffffc0201c4c:	0000e697          	auipc	a3,0xe
ffffffffc0201c50:	cd46b683          	ld	a3,-812(a3) # ffffffffc020f920 <nbase>
ffffffffc0201c54:	9536                	add	a0,a0,a3
ffffffffc0201c56:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c5a:	83b1                	srli	a5,a5,0xc
ffffffffc0201c5c:	00095717          	auipc	a4,0x95
ffffffffc0201c60:	c4473703          	ld	a4,-956(a4) # ffffffffc02968a0 <npage>
ffffffffc0201c64:	0532                	slli	a0,a0,0xc
ffffffffc0201c66:	00e7fa63          	bgeu	a5,a4,ffffffffc0201c7a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201c6a:	00095697          	auipc	a3,0x95
ffffffffc0201c6e:	c4e6b683          	ld	a3,-946(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201c72:	9536                	add	a0,a0,a3
ffffffffc0201c74:	60a2                	ld	ra,8(sp)
ffffffffc0201c76:	0141                	addi	sp,sp,16
ffffffffc0201c78:	8082                	ret
ffffffffc0201c7a:	86aa                	mv	a3,a0
ffffffffc0201c7c:	0000b617          	auipc	a2,0xb
ffffffffc0201c80:	91460613          	addi	a2,a2,-1772 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0201c84:	07100593          	li	a1,113
ffffffffc0201c88:	0000b517          	auipc	a0,0xb
ffffffffc0201c8c:	93050513          	addi	a0,a0,-1744 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0201c90:	d9efe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201c94 <slob_alloc.constprop.0>:
ffffffffc0201c94:	1101                	addi	sp,sp,-32
ffffffffc0201c96:	ec06                	sd	ra,24(sp)
ffffffffc0201c98:	e822                	sd	s0,16(sp)
ffffffffc0201c9a:	e426                	sd	s1,8(sp)
ffffffffc0201c9c:	e04a                	sd	s2,0(sp)
ffffffffc0201c9e:	01050713          	addi	a4,a0,16
ffffffffc0201ca2:	6785                	lui	a5,0x1
ffffffffc0201ca4:	0cf77363          	bgeu	a4,a5,ffffffffc0201d6a <slob_alloc.constprop.0+0xd6>
ffffffffc0201ca8:	00f50493          	addi	s1,a0,15
ffffffffc0201cac:	8091                	srli	s1,s1,0x4
ffffffffc0201cae:	2481                	sext.w	s1,s1
ffffffffc0201cb0:	10002673          	csrr	a2,sstatus
ffffffffc0201cb4:	8a09                	andi	a2,a2,2
ffffffffc0201cb6:	e25d                	bnez	a2,ffffffffc0201d5c <slob_alloc.constprop.0+0xc8>
ffffffffc0201cb8:	0008f917          	auipc	s2,0x8f
ffffffffc0201cbc:	39890913          	addi	s2,s2,920 # ffffffffc0291050 <slobfree>
ffffffffc0201cc0:	00093683          	ld	a3,0(s2)
ffffffffc0201cc4:	669c                	ld	a5,8(a3)
ffffffffc0201cc6:	4398                	lw	a4,0(a5)
ffffffffc0201cc8:	08975e63          	bge	a4,s1,ffffffffc0201d64 <slob_alloc.constprop.0+0xd0>
ffffffffc0201ccc:	00f68b63          	beq	a3,a5,ffffffffc0201ce2 <slob_alloc.constprop.0+0x4e>
ffffffffc0201cd0:	6780                	ld	s0,8(a5)
ffffffffc0201cd2:	4018                	lw	a4,0(s0)
ffffffffc0201cd4:	02975a63          	bge	a4,s1,ffffffffc0201d08 <slob_alloc.constprop.0+0x74>
ffffffffc0201cd8:	00093683          	ld	a3,0(s2)
ffffffffc0201cdc:	87a2                	mv	a5,s0
ffffffffc0201cde:	fef699e3          	bne	a3,a5,ffffffffc0201cd0 <slob_alloc.constprop.0+0x3c>
ffffffffc0201ce2:	ee31                	bnez	a2,ffffffffc0201d3e <slob_alloc.constprop.0+0xaa>
ffffffffc0201ce4:	4501                	li	a0,0
ffffffffc0201ce6:	f4bff0ef          	jal	ra,ffffffffc0201c30 <__slob_get_free_pages.constprop.0>
ffffffffc0201cea:	842a                	mv	s0,a0
ffffffffc0201cec:	cd05                	beqz	a0,ffffffffc0201d24 <slob_alloc.constprop.0+0x90>
ffffffffc0201cee:	6585                	lui	a1,0x1
ffffffffc0201cf0:	e8dff0ef          	jal	ra,ffffffffc0201b7c <slob_free>
ffffffffc0201cf4:	10002673          	csrr	a2,sstatus
ffffffffc0201cf8:	8a09                	andi	a2,a2,2
ffffffffc0201cfa:	ee05                	bnez	a2,ffffffffc0201d32 <slob_alloc.constprop.0+0x9e>
ffffffffc0201cfc:	00093783          	ld	a5,0(s2)
ffffffffc0201d00:	6780                	ld	s0,8(a5)
ffffffffc0201d02:	4018                	lw	a4,0(s0)
ffffffffc0201d04:	fc974ae3          	blt	a4,s1,ffffffffc0201cd8 <slob_alloc.constprop.0+0x44>
ffffffffc0201d08:	04e48763          	beq	s1,a4,ffffffffc0201d56 <slob_alloc.constprop.0+0xc2>
ffffffffc0201d0c:	00449693          	slli	a3,s1,0x4
ffffffffc0201d10:	96a2                	add	a3,a3,s0
ffffffffc0201d12:	e794                	sd	a3,8(a5)
ffffffffc0201d14:	640c                	ld	a1,8(s0)
ffffffffc0201d16:	9f05                	subw	a4,a4,s1
ffffffffc0201d18:	c298                	sw	a4,0(a3)
ffffffffc0201d1a:	e68c                	sd	a1,8(a3)
ffffffffc0201d1c:	c004                	sw	s1,0(s0)
ffffffffc0201d1e:	00f93023          	sd	a5,0(s2)
ffffffffc0201d22:	e20d                	bnez	a2,ffffffffc0201d44 <slob_alloc.constprop.0+0xb0>
ffffffffc0201d24:	60e2                	ld	ra,24(sp)
ffffffffc0201d26:	8522                	mv	a0,s0
ffffffffc0201d28:	6442                	ld	s0,16(sp)
ffffffffc0201d2a:	64a2                	ld	s1,8(sp)
ffffffffc0201d2c:	6902                	ld	s2,0(sp)
ffffffffc0201d2e:	6105                	addi	sp,sp,32
ffffffffc0201d30:	8082                	ret
ffffffffc0201d32:	86eff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201d36:	00093783          	ld	a5,0(s2)
ffffffffc0201d3a:	4605                	li	a2,1
ffffffffc0201d3c:	b7d1                	j	ffffffffc0201d00 <slob_alloc.constprop.0+0x6c>
ffffffffc0201d3e:	85cff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201d42:	b74d                	j	ffffffffc0201ce4 <slob_alloc.constprop.0+0x50>
ffffffffc0201d44:	856ff0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201d48:	60e2                	ld	ra,24(sp)
ffffffffc0201d4a:	8522                	mv	a0,s0
ffffffffc0201d4c:	6442                	ld	s0,16(sp)
ffffffffc0201d4e:	64a2                	ld	s1,8(sp)
ffffffffc0201d50:	6902                	ld	s2,0(sp)
ffffffffc0201d52:	6105                	addi	sp,sp,32
ffffffffc0201d54:	8082                	ret
ffffffffc0201d56:	6418                	ld	a4,8(s0)
ffffffffc0201d58:	e798                	sd	a4,8(a5)
ffffffffc0201d5a:	b7d1                	j	ffffffffc0201d1e <slob_alloc.constprop.0+0x8a>
ffffffffc0201d5c:	844ff0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201d60:	4605                	li	a2,1
ffffffffc0201d62:	bf99                	j	ffffffffc0201cb8 <slob_alloc.constprop.0+0x24>
ffffffffc0201d64:	843e                	mv	s0,a5
ffffffffc0201d66:	87b6                	mv	a5,a3
ffffffffc0201d68:	b745                	j	ffffffffc0201d08 <slob_alloc.constprop.0+0x74>
ffffffffc0201d6a:	0000b697          	auipc	a3,0xb
ffffffffc0201d6e:	85e68693          	addi	a3,a3,-1954 # ffffffffc020c5c8 <commands+0xc00>
ffffffffc0201d72:	0000a617          	auipc	a2,0xa
ffffffffc0201d76:	ea660613          	addi	a2,a2,-346 # ffffffffc020bc18 <commands+0x250>
ffffffffc0201d7a:	06300593          	li	a1,99
ffffffffc0201d7e:	0000b517          	auipc	a0,0xb
ffffffffc0201d82:	86a50513          	addi	a0,a0,-1942 # ffffffffc020c5e8 <commands+0xc20>
ffffffffc0201d86:	ca8fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201d8a <kmalloc_init>:
ffffffffc0201d8a:	1141                	addi	sp,sp,-16
ffffffffc0201d8c:	0000b517          	auipc	a0,0xb
ffffffffc0201d90:	87450513          	addi	a0,a0,-1932 # ffffffffc020c600 <commands+0xc38>
ffffffffc0201d94:	e406                	sd	ra,8(sp)
ffffffffc0201d96:	b94fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201d9a:	60a2                	ld	ra,8(sp)
ffffffffc0201d9c:	0000b517          	auipc	a0,0xb
ffffffffc0201da0:	87c50513          	addi	a0,a0,-1924 # ffffffffc020c618 <commands+0xc50>
ffffffffc0201da4:	0141                	addi	sp,sp,16
ffffffffc0201da6:	b84fe06f          	j	ffffffffc020012a <cprintf>

ffffffffc0201daa <kallocated>:
ffffffffc0201daa:	4501                	li	a0,0
ffffffffc0201dac:	8082                	ret

ffffffffc0201dae <kmalloc>:
ffffffffc0201dae:	1101                	addi	sp,sp,-32
ffffffffc0201db0:	e04a                	sd	s2,0(sp)
ffffffffc0201db2:	6905                	lui	s2,0x1
ffffffffc0201db4:	e822                	sd	s0,16(sp)
ffffffffc0201db6:	ec06                	sd	ra,24(sp)
ffffffffc0201db8:	e426                	sd	s1,8(sp)
ffffffffc0201dba:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0201dbe:	842a                	mv	s0,a0
ffffffffc0201dc0:	04a7f963          	bgeu	a5,a0,ffffffffc0201e12 <kmalloc+0x64>
ffffffffc0201dc4:	4561                	li	a0,24
ffffffffc0201dc6:	ecfff0ef          	jal	ra,ffffffffc0201c94 <slob_alloc.constprop.0>
ffffffffc0201dca:	84aa                	mv	s1,a0
ffffffffc0201dcc:	c929                	beqz	a0,ffffffffc0201e1e <kmalloc+0x70>
ffffffffc0201dce:	0004079b          	sext.w	a5,s0
ffffffffc0201dd2:	4501                	li	a0,0
ffffffffc0201dd4:	00f95763          	bge	s2,a5,ffffffffc0201de2 <kmalloc+0x34>
ffffffffc0201dd8:	6705                	lui	a4,0x1
ffffffffc0201dda:	8785                	srai	a5,a5,0x1
ffffffffc0201ddc:	2505                	addiw	a0,a0,1
ffffffffc0201dde:	fef74ee3          	blt	a4,a5,ffffffffc0201dda <kmalloc+0x2c>
ffffffffc0201de2:	c088                	sw	a0,0(s1)
ffffffffc0201de4:	e4dff0ef          	jal	ra,ffffffffc0201c30 <__slob_get_free_pages.constprop.0>
ffffffffc0201de8:	e488                	sd	a0,8(s1)
ffffffffc0201dea:	842a                	mv	s0,a0
ffffffffc0201dec:	c525                	beqz	a0,ffffffffc0201e54 <kmalloc+0xa6>
ffffffffc0201dee:	100027f3          	csrr	a5,sstatus
ffffffffc0201df2:	8b89                	andi	a5,a5,2
ffffffffc0201df4:	ef8d                	bnez	a5,ffffffffc0201e2e <kmalloc+0x80>
ffffffffc0201df6:	00095797          	auipc	a5,0x95
ffffffffc0201dfa:	a9278793          	addi	a5,a5,-1390 # ffffffffc0296888 <bigblocks>
ffffffffc0201dfe:	6398                	ld	a4,0(a5)
ffffffffc0201e00:	e384                	sd	s1,0(a5)
ffffffffc0201e02:	e898                	sd	a4,16(s1)
ffffffffc0201e04:	60e2                	ld	ra,24(sp)
ffffffffc0201e06:	8522                	mv	a0,s0
ffffffffc0201e08:	6442                	ld	s0,16(sp)
ffffffffc0201e0a:	64a2                	ld	s1,8(sp)
ffffffffc0201e0c:	6902                	ld	s2,0(sp)
ffffffffc0201e0e:	6105                	addi	sp,sp,32
ffffffffc0201e10:	8082                	ret
ffffffffc0201e12:	0541                	addi	a0,a0,16
ffffffffc0201e14:	e81ff0ef          	jal	ra,ffffffffc0201c94 <slob_alloc.constprop.0>
ffffffffc0201e18:	01050413          	addi	s0,a0,16
ffffffffc0201e1c:	f565                	bnez	a0,ffffffffc0201e04 <kmalloc+0x56>
ffffffffc0201e1e:	4401                	li	s0,0
ffffffffc0201e20:	60e2                	ld	ra,24(sp)
ffffffffc0201e22:	8522                	mv	a0,s0
ffffffffc0201e24:	6442                	ld	s0,16(sp)
ffffffffc0201e26:	64a2                	ld	s1,8(sp)
ffffffffc0201e28:	6902                	ld	s2,0(sp)
ffffffffc0201e2a:	6105                	addi	sp,sp,32
ffffffffc0201e2c:	8082                	ret
ffffffffc0201e2e:	f73fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201e32:	00095797          	auipc	a5,0x95
ffffffffc0201e36:	a5678793          	addi	a5,a5,-1450 # ffffffffc0296888 <bigblocks>
ffffffffc0201e3a:	6398                	ld	a4,0(a5)
ffffffffc0201e3c:	e384                	sd	s1,0(a5)
ffffffffc0201e3e:	e898                	sd	a4,16(s1)
ffffffffc0201e40:	f5bfe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201e44:	6480                	ld	s0,8(s1)
ffffffffc0201e46:	60e2                	ld	ra,24(sp)
ffffffffc0201e48:	64a2                	ld	s1,8(sp)
ffffffffc0201e4a:	8522                	mv	a0,s0
ffffffffc0201e4c:	6442                	ld	s0,16(sp)
ffffffffc0201e4e:	6902                	ld	s2,0(sp)
ffffffffc0201e50:	6105                	addi	sp,sp,32
ffffffffc0201e52:	8082                	ret
ffffffffc0201e54:	45e1                	li	a1,24
ffffffffc0201e56:	8526                	mv	a0,s1
ffffffffc0201e58:	d25ff0ef          	jal	ra,ffffffffc0201b7c <slob_free>
ffffffffc0201e5c:	b765                	j	ffffffffc0201e04 <kmalloc+0x56>

ffffffffc0201e5e <kfree>:
ffffffffc0201e5e:	c169                	beqz	a0,ffffffffc0201f20 <kfree+0xc2>
ffffffffc0201e60:	1101                	addi	sp,sp,-32
ffffffffc0201e62:	e822                	sd	s0,16(sp)
ffffffffc0201e64:	ec06                	sd	ra,24(sp)
ffffffffc0201e66:	e426                	sd	s1,8(sp)
ffffffffc0201e68:	03451793          	slli	a5,a0,0x34
ffffffffc0201e6c:	842a                	mv	s0,a0
ffffffffc0201e6e:	e3d9                	bnez	a5,ffffffffc0201ef4 <kfree+0x96>
ffffffffc0201e70:	100027f3          	csrr	a5,sstatus
ffffffffc0201e74:	8b89                	andi	a5,a5,2
ffffffffc0201e76:	e7d9                	bnez	a5,ffffffffc0201f04 <kfree+0xa6>
ffffffffc0201e78:	00095797          	auipc	a5,0x95
ffffffffc0201e7c:	a107b783          	ld	a5,-1520(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0201e80:	4601                	li	a2,0
ffffffffc0201e82:	cbad                	beqz	a5,ffffffffc0201ef4 <kfree+0x96>
ffffffffc0201e84:	00095697          	auipc	a3,0x95
ffffffffc0201e88:	a0468693          	addi	a3,a3,-1532 # ffffffffc0296888 <bigblocks>
ffffffffc0201e8c:	a021                	j	ffffffffc0201e94 <kfree+0x36>
ffffffffc0201e8e:	01048693          	addi	a3,s1,16
ffffffffc0201e92:	c3a5                	beqz	a5,ffffffffc0201ef2 <kfree+0x94>
ffffffffc0201e94:	6798                	ld	a4,8(a5)
ffffffffc0201e96:	84be                	mv	s1,a5
ffffffffc0201e98:	6b9c                	ld	a5,16(a5)
ffffffffc0201e9a:	fe871ae3          	bne	a4,s0,ffffffffc0201e8e <kfree+0x30>
ffffffffc0201e9e:	e29c                	sd	a5,0(a3)
ffffffffc0201ea0:	ee2d                	bnez	a2,ffffffffc0201f1a <kfree+0xbc>
ffffffffc0201ea2:	c02007b7          	lui	a5,0xc0200
ffffffffc0201ea6:	4098                	lw	a4,0(s1)
ffffffffc0201ea8:	08f46963          	bltu	s0,a5,ffffffffc0201f3a <kfree+0xdc>
ffffffffc0201eac:	00095697          	auipc	a3,0x95
ffffffffc0201eb0:	a0c6b683          	ld	a3,-1524(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201eb4:	8c15                	sub	s0,s0,a3
ffffffffc0201eb6:	8031                	srli	s0,s0,0xc
ffffffffc0201eb8:	00095797          	auipc	a5,0x95
ffffffffc0201ebc:	9e87b783          	ld	a5,-1560(a5) # ffffffffc02968a0 <npage>
ffffffffc0201ec0:	06f47163          	bgeu	s0,a5,ffffffffc0201f22 <kfree+0xc4>
ffffffffc0201ec4:	0000e517          	auipc	a0,0xe
ffffffffc0201ec8:	a5c53503          	ld	a0,-1444(a0) # ffffffffc020f920 <nbase>
ffffffffc0201ecc:	8c09                	sub	s0,s0,a0
ffffffffc0201ece:	041a                	slli	s0,s0,0x6
ffffffffc0201ed0:	00095517          	auipc	a0,0x95
ffffffffc0201ed4:	9d853503          	ld	a0,-1576(a0) # ffffffffc02968a8 <pages>
ffffffffc0201ed8:	4585                	li	a1,1
ffffffffc0201eda:	9522                	add	a0,a0,s0
ffffffffc0201edc:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201ee0:	399000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0201ee4:	6442                	ld	s0,16(sp)
ffffffffc0201ee6:	60e2                	ld	ra,24(sp)
ffffffffc0201ee8:	8526                	mv	a0,s1
ffffffffc0201eea:	64a2                	ld	s1,8(sp)
ffffffffc0201eec:	45e1                	li	a1,24
ffffffffc0201eee:	6105                	addi	sp,sp,32
ffffffffc0201ef0:	b171                	j	ffffffffc0201b7c <slob_free>
ffffffffc0201ef2:	e20d                	bnez	a2,ffffffffc0201f14 <kfree+0xb6>
ffffffffc0201ef4:	ff040513          	addi	a0,s0,-16
ffffffffc0201ef8:	6442                	ld	s0,16(sp)
ffffffffc0201efa:	60e2                	ld	ra,24(sp)
ffffffffc0201efc:	64a2                	ld	s1,8(sp)
ffffffffc0201efe:	4581                	li	a1,0
ffffffffc0201f00:	6105                	addi	sp,sp,32
ffffffffc0201f02:	b9ad                	j	ffffffffc0201b7c <slob_free>
ffffffffc0201f04:	e9dfe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0201f08:	00095797          	auipc	a5,0x95
ffffffffc0201f0c:	9807b783          	ld	a5,-1664(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0201f10:	4605                	li	a2,1
ffffffffc0201f12:	fbad                	bnez	a5,ffffffffc0201e84 <kfree+0x26>
ffffffffc0201f14:	e87fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201f18:	bff1                	j	ffffffffc0201ef4 <kfree+0x96>
ffffffffc0201f1a:	e81fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0201f1e:	b751                	j	ffffffffc0201ea2 <kfree+0x44>
ffffffffc0201f20:	8082                	ret
ffffffffc0201f22:	0000a617          	auipc	a2,0xa
ffffffffc0201f26:	73e60613          	addi	a2,a2,1854 # ffffffffc020c660 <commands+0xc98>
ffffffffc0201f2a:	06900593          	li	a1,105
ffffffffc0201f2e:	0000a517          	auipc	a0,0xa
ffffffffc0201f32:	68a50513          	addi	a0,a0,1674 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0201f36:	af8fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201f3a:	86a2                	mv	a3,s0
ffffffffc0201f3c:	0000a617          	auipc	a2,0xa
ffffffffc0201f40:	6fc60613          	addi	a2,a2,1788 # ffffffffc020c638 <commands+0xc70>
ffffffffc0201f44:	07700593          	li	a1,119
ffffffffc0201f48:	0000a517          	auipc	a0,0xa
ffffffffc0201f4c:	67050513          	addi	a0,a0,1648 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0201f50:	adefe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201f54 <default_init>:
ffffffffc0201f54:	00090797          	auipc	a5,0x90
ffffffffc0201f58:	85478793          	addi	a5,a5,-1964 # ffffffffc02917a8 <free_area>
ffffffffc0201f5c:	e79c                	sd	a5,8(a5)
ffffffffc0201f5e:	e39c                	sd	a5,0(a5)
ffffffffc0201f60:	0007a823          	sw	zero,16(a5)
ffffffffc0201f64:	8082                	ret

ffffffffc0201f66 <default_nr_free_pages>:
ffffffffc0201f66:	00090517          	auipc	a0,0x90
ffffffffc0201f6a:	85256503          	lwu	a0,-1966(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201f6e:	8082                	ret

ffffffffc0201f70 <default_check>:
ffffffffc0201f70:	715d                	addi	sp,sp,-80
ffffffffc0201f72:	e0a2                	sd	s0,64(sp)
ffffffffc0201f74:	00090417          	auipc	s0,0x90
ffffffffc0201f78:	83440413          	addi	s0,s0,-1996 # ffffffffc02917a8 <free_area>
ffffffffc0201f7c:	641c                	ld	a5,8(s0)
ffffffffc0201f7e:	e486                	sd	ra,72(sp)
ffffffffc0201f80:	fc26                	sd	s1,56(sp)
ffffffffc0201f82:	f84a                	sd	s2,48(sp)
ffffffffc0201f84:	f44e                	sd	s3,40(sp)
ffffffffc0201f86:	f052                	sd	s4,32(sp)
ffffffffc0201f88:	ec56                	sd	s5,24(sp)
ffffffffc0201f8a:	e85a                	sd	s6,16(sp)
ffffffffc0201f8c:	e45e                	sd	s7,8(sp)
ffffffffc0201f8e:	e062                	sd	s8,0(sp)
ffffffffc0201f90:	2a878d63          	beq	a5,s0,ffffffffc020224a <default_check+0x2da>
ffffffffc0201f94:	4481                	li	s1,0
ffffffffc0201f96:	4901                	li	s2,0
ffffffffc0201f98:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201f9c:	8b09                	andi	a4,a4,2
ffffffffc0201f9e:	2a070a63          	beqz	a4,ffffffffc0202252 <default_check+0x2e2>
ffffffffc0201fa2:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201fa6:	679c                	ld	a5,8(a5)
ffffffffc0201fa8:	2905                	addiw	s2,s2,1
ffffffffc0201faa:	9cb9                	addw	s1,s1,a4
ffffffffc0201fac:	fe8796e3          	bne	a5,s0,ffffffffc0201f98 <default_check+0x28>
ffffffffc0201fb0:	89a6                	mv	s3,s1
ffffffffc0201fb2:	307000ef          	jal	ra,ffffffffc0202ab8 <nr_free_pages>
ffffffffc0201fb6:	6f351e63          	bne	a0,s3,ffffffffc02026b2 <default_check+0x742>
ffffffffc0201fba:	4505                	li	a0,1
ffffffffc0201fbc:	27f000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0201fc0:	8aaa                	mv	s5,a0
ffffffffc0201fc2:	42050863          	beqz	a0,ffffffffc02023f2 <default_check+0x482>
ffffffffc0201fc6:	4505                	li	a0,1
ffffffffc0201fc8:	273000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0201fcc:	89aa                	mv	s3,a0
ffffffffc0201fce:	70050263          	beqz	a0,ffffffffc02026d2 <default_check+0x762>
ffffffffc0201fd2:	4505                	li	a0,1
ffffffffc0201fd4:	267000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0201fd8:	8a2a                	mv	s4,a0
ffffffffc0201fda:	48050c63          	beqz	a0,ffffffffc0202472 <default_check+0x502>
ffffffffc0201fde:	293a8a63          	beq	s5,s3,ffffffffc0202272 <default_check+0x302>
ffffffffc0201fe2:	28aa8863          	beq	s5,a0,ffffffffc0202272 <default_check+0x302>
ffffffffc0201fe6:	28a98663          	beq	s3,a0,ffffffffc0202272 <default_check+0x302>
ffffffffc0201fea:	000aa783          	lw	a5,0(s5)
ffffffffc0201fee:	2a079263          	bnez	a5,ffffffffc0202292 <default_check+0x322>
ffffffffc0201ff2:	0009a783          	lw	a5,0(s3) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0201ff6:	28079e63          	bnez	a5,ffffffffc0202292 <default_check+0x322>
ffffffffc0201ffa:	411c                	lw	a5,0(a0)
ffffffffc0201ffc:	28079b63          	bnez	a5,ffffffffc0202292 <default_check+0x322>
ffffffffc0202000:	00095797          	auipc	a5,0x95
ffffffffc0202004:	8a87b783          	ld	a5,-1880(a5) # ffffffffc02968a8 <pages>
ffffffffc0202008:	40fa8733          	sub	a4,s5,a5
ffffffffc020200c:	0000e617          	auipc	a2,0xe
ffffffffc0202010:	91463603          	ld	a2,-1772(a2) # ffffffffc020f920 <nbase>
ffffffffc0202014:	8719                	srai	a4,a4,0x6
ffffffffc0202016:	9732                	add	a4,a4,a2
ffffffffc0202018:	00095697          	auipc	a3,0x95
ffffffffc020201c:	8886b683          	ld	a3,-1912(a3) # ffffffffc02968a0 <npage>
ffffffffc0202020:	06b2                	slli	a3,a3,0xc
ffffffffc0202022:	0732                	slli	a4,a4,0xc
ffffffffc0202024:	28d77763          	bgeu	a4,a3,ffffffffc02022b2 <default_check+0x342>
ffffffffc0202028:	40f98733          	sub	a4,s3,a5
ffffffffc020202c:	8719                	srai	a4,a4,0x6
ffffffffc020202e:	9732                	add	a4,a4,a2
ffffffffc0202030:	0732                	slli	a4,a4,0xc
ffffffffc0202032:	4cd77063          	bgeu	a4,a3,ffffffffc02024f2 <default_check+0x582>
ffffffffc0202036:	40f507b3          	sub	a5,a0,a5
ffffffffc020203a:	8799                	srai	a5,a5,0x6
ffffffffc020203c:	97b2                	add	a5,a5,a2
ffffffffc020203e:	07b2                	slli	a5,a5,0xc
ffffffffc0202040:	30d7f963          	bgeu	a5,a3,ffffffffc0202352 <default_check+0x3e2>
ffffffffc0202044:	4505                	li	a0,1
ffffffffc0202046:	00043c03          	ld	s8,0(s0)
ffffffffc020204a:	00843b83          	ld	s7,8(s0)
ffffffffc020204e:	01042b03          	lw	s6,16(s0)
ffffffffc0202052:	e400                	sd	s0,8(s0)
ffffffffc0202054:	e000                	sd	s0,0(s0)
ffffffffc0202056:	0008f797          	auipc	a5,0x8f
ffffffffc020205a:	7607a123          	sw	zero,1890(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020205e:	1dd000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0202062:	2c051863          	bnez	a0,ffffffffc0202332 <default_check+0x3c2>
ffffffffc0202066:	4585                	li	a1,1
ffffffffc0202068:	8556                	mv	a0,s5
ffffffffc020206a:	20f000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc020206e:	4585                	li	a1,1
ffffffffc0202070:	854e                	mv	a0,s3
ffffffffc0202072:	207000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0202076:	4585                	li	a1,1
ffffffffc0202078:	8552                	mv	a0,s4
ffffffffc020207a:	1ff000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc020207e:	4818                	lw	a4,16(s0)
ffffffffc0202080:	478d                	li	a5,3
ffffffffc0202082:	28f71863          	bne	a4,a5,ffffffffc0202312 <default_check+0x3a2>
ffffffffc0202086:	4505                	li	a0,1
ffffffffc0202088:	1b3000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc020208c:	89aa                	mv	s3,a0
ffffffffc020208e:	26050263          	beqz	a0,ffffffffc02022f2 <default_check+0x382>
ffffffffc0202092:	4505                	li	a0,1
ffffffffc0202094:	1a7000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0202098:	8aaa                	mv	s5,a0
ffffffffc020209a:	3a050c63          	beqz	a0,ffffffffc0202452 <default_check+0x4e2>
ffffffffc020209e:	4505                	li	a0,1
ffffffffc02020a0:	19b000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02020a4:	8a2a                	mv	s4,a0
ffffffffc02020a6:	38050663          	beqz	a0,ffffffffc0202432 <default_check+0x4c2>
ffffffffc02020aa:	4505                	li	a0,1
ffffffffc02020ac:	18f000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02020b0:	36051163          	bnez	a0,ffffffffc0202412 <default_check+0x4a2>
ffffffffc02020b4:	4585                	li	a1,1
ffffffffc02020b6:	854e                	mv	a0,s3
ffffffffc02020b8:	1c1000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02020bc:	641c                	ld	a5,8(s0)
ffffffffc02020be:	20878a63          	beq	a5,s0,ffffffffc02022d2 <default_check+0x362>
ffffffffc02020c2:	4505                	li	a0,1
ffffffffc02020c4:	177000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02020c8:	30a99563          	bne	s3,a0,ffffffffc02023d2 <default_check+0x462>
ffffffffc02020cc:	4505                	li	a0,1
ffffffffc02020ce:	16d000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02020d2:	2e051063          	bnez	a0,ffffffffc02023b2 <default_check+0x442>
ffffffffc02020d6:	481c                	lw	a5,16(s0)
ffffffffc02020d8:	2a079d63          	bnez	a5,ffffffffc0202392 <default_check+0x422>
ffffffffc02020dc:	854e                	mv	a0,s3
ffffffffc02020de:	4585                	li	a1,1
ffffffffc02020e0:	01843023          	sd	s8,0(s0)
ffffffffc02020e4:	01743423          	sd	s7,8(s0)
ffffffffc02020e8:	01642823          	sw	s6,16(s0)
ffffffffc02020ec:	18d000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02020f0:	4585                	li	a1,1
ffffffffc02020f2:	8556                	mv	a0,s5
ffffffffc02020f4:	185000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02020f8:	4585                	li	a1,1
ffffffffc02020fa:	8552                	mv	a0,s4
ffffffffc02020fc:	17d000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0202100:	4515                	li	a0,5
ffffffffc0202102:	139000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0202106:	89aa                	mv	s3,a0
ffffffffc0202108:	26050563          	beqz	a0,ffffffffc0202372 <default_check+0x402>
ffffffffc020210c:	651c                	ld	a5,8(a0)
ffffffffc020210e:	8385                	srli	a5,a5,0x1
ffffffffc0202110:	8b85                	andi	a5,a5,1
ffffffffc0202112:	54079063          	bnez	a5,ffffffffc0202652 <default_check+0x6e2>
ffffffffc0202116:	4505                	li	a0,1
ffffffffc0202118:	00043b03          	ld	s6,0(s0)
ffffffffc020211c:	00843a83          	ld	s5,8(s0)
ffffffffc0202120:	e000                	sd	s0,0(s0)
ffffffffc0202122:	e400                	sd	s0,8(s0)
ffffffffc0202124:	117000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0202128:	50051563          	bnez	a0,ffffffffc0202632 <default_check+0x6c2>
ffffffffc020212c:	08098a13          	addi	s4,s3,128
ffffffffc0202130:	8552                	mv	a0,s4
ffffffffc0202132:	458d                	li	a1,3
ffffffffc0202134:	01042b83          	lw	s7,16(s0)
ffffffffc0202138:	0008f797          	auipc	a5,0x8f
ffffffffc020213c:	6807a023          	sw	zero,1664(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0202140:	139000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0202144:	4511                	li	a0,4
ffffffffc0202146:	0f5000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc020214a:	4c051463          	bnez	a0,ffffffffc0202612 <default_check+0x6a2>
ffffffffc020214e:	0889b783          	ld	a5,136(s3)
ffffffffc0202152:	8385                	srli	a5,a5,0x1
ffffffffc0202154:	8b85                	andi	a5,a5,1
ffffffffc0202156:	48078e63          	beqz	a5,ffffffffc02025f2 <default_check+0x682>
ffffffffc020215a:	0909a703          	lw	a4,144(s3)
ffffffffc020215e:	478d                	li	a5,3
ffffffffc0202160:	48f71963          	bne	a4,a5,ffffffffc02025f2 <default_check+0x682>
ffffffffc0202164:	450d                	li	a0,3
ffffffffc0202166:	0d5000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc020216a:	8c2a                	mv	s8,a0
ffffffffc020216c:	46050363          	beqz	a0,ffffffffc02025d2 <default_check+0x662>
ffffffffc0202170:	4505                	li	a0,1
ffffffffc0202172:	0c9000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0202176:	42051e63          	bnez	a0,ffffffffc02025b2 <default_check+0x642>
ffffffffc020217a:	418a1c63          	bne	s4,s8,ffffffffc0202592 <default_check+0x622>
ffffffffc020217e:	4585                	li	a1,1
ffffffffc0202180:	854e                	mv	a0,s3
ffffffffc0202182:	0f7000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0202186:	458d                	li	a1,3
ffffffffc0202188:	8552                	mv	a0,s4
ffffffffc020218a:	0ef000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc020218e:	0089b783          	ld	a5,8(s3)
ffffffffc0202192:	04098c13          	addi	s8,s3,64
ffffffffc0202196:	8385                	srli	a5,a5,0x1
ffffffffc0202198:	8b85                	andi	a5,a5,1
ffffffffc020219a:	3c078c63          	beqz	a5,ffffffffc0202572 <default_check+0x602>
ffffffffc020219e:	0109a703          	lw	a4,16(s3)
ffffffffc02021a2:	4785                	li	a5,1
ffffffffc02021a4:	3cf71763          	bne	a4,a5,ffffffffc0202572 <default_check+0x602>
ffffffffc02021a8:	008a3783          	ld	a5,8(s4) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc02021ac:	8385                	srli	a5,a5,0x1
ffffffffc02021ae:	8b85                	andi	a5,a5,1
ffffffffc02021b0:	3a078163          	beqz	a5,ffffffffc0202552 <default_check+0x5e2>
ffffffffc02021b4:	010a2703          	lw	a4,16(s4)
ffffffffc02021b8:	478d                	li	a5,3
ffffffffc02021ba:	38f71c63          	bne	a4,a5,ffffffffc0202552 <default_check+0x5e2>
ffffffffc02021be:	4505                	li	a0,1
ffffffffc02021c0:	07b000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02021c4:	36a99763          	bne	s3,a0,ffffffffc0202532 <default_check+0x5c2>
ffffffffc02021c8:	4585                	li	a1,1
ffffffffc02021ca:	0af000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02021ce:	4509                	li	a0,2
ffffffffc02021d0:	06b000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02021d4:	32aa1f63          	bne	s4,a0,ffffffffc0202512 <default_check+0x5a2>
ffffffffc02021d8:	4589                	li	a1,2
ffffffffc02021da:	09f000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02021de:	4585                	li	a1,1
ffffffffc02021e0:	8562                	mv	a0,s8
ffffffffc02021e2:	097000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02021e6:	4515                	li	a0,5
ffffffffc02021e8:	053000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02021ec:	89aa                	mv	s3,a0
ffffffffc02021ee:	48050263          	beqz	a0,ffffffffc0202672 <default_check+0x702>
ffffffffc02021f2:	4505                	li	a0,1
ffffffffc02021f4:	047000ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02021f8:	2c051d63          	bnez	a0,ffffffffc02024d2 <default_check+0x562>
ffffffffc02021fc:	481c                	lw	a5,16(s0)
ffffffffc02021fe:	2a079a63          	bnez	a5,ffffffffc02024b2 <default_check+0x542>
ffffffffc0202202:	4595                	li	a1,5
ffffffffc0202204:	854e                	mv	a0,s3
ffffffffc0202206:	01742823          	sw	s7,16(s0)
ffffffffc020220a:	01643023          	sd	s6,0(s0)
ffffffffc020220e:	01543423          	sd	s5,8(s0)
ffffffffc0202212:	067000ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0202216:	641c                	ld	a5,8(s0)
ffffffffc0202218:	00878963          	beq	a5,s0,ffffffffc020222a <default_check+0x2ba>
ffffffffc020221c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202220:	679c                	ld	a5,8(a5)
ffffffffc0202222:	397d                	addiw	s2,s2,-1
ffffffffc0202224:	9c99                	subw	s1,s1,a4
ffffffffc0202226:	fe879be3          	bne	a5,s0,ffffffffc020221c <default_check+0x2ac>
ffffffffc020222a:	26091463          	bnez	s2,ffffffffc0202492 <default_check+0x522>
ffffffffc020222e:	46049263          	bnez	s1,ffffffffc0202692 <default_check+0x722>
ffffffffc0202232:	60a6                	ld	ra,72(sp)
ffffffffc0202234:	6406                	ld	s0,64(sp)
ffffffffc0202236:	74e2                	ld	s1,56(sp)
ffffffffc0202238:	7942                	ld	s2,48(sp)
ffffffffc020223a:	79a2                	ld	s3,40(sp)
ffffffffc020223c:	7a02                	ld	s4,32(sp)
ffffffffc020223e:	6ae2                	ld	s5,24(sp)
ffffffffc0202240:	6b42                	ld	s6,16(sp)
ffffffffc0202242:	6ba2                	ld	s7,8(sp)
ffffffffc0202244:	6c02                	ld	s8,0(sp)
ffffffffc0202246:	6161                	addi	sp,sp,80
ffffffffc0202248:	8082                	ret
ffffffffc020224a:	4981                	li	s3,0
ffffffffc020224c:	4481                	li	s1,0
ffffffffc020224e:	4901                	li	s2,0
ffffffffc0202250:	b38d                	j	ffffffffc0201fb2 <default_check+0x42>
ffffffffc0202252:	0000a697          	auipc	a3,0xa
ffffffffc0202256:	42e68693          	addi	a3,a3,1070 # ffffffffc020c680 <commands+0xcb8>
ffffffffc020225a:	0000a617          	auipc	a2,0xa
ffffffffc020225e:	9be60613          	addi	a2,a2,-1602 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202262:	0ef00593          	li	a1,239
ffffffffc0202266:	0000a517          	auipc	a0,0xa
ffffffffc020226a:	42a50513          	addi	a0,a0,1066 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020226e:	fc1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202272:	0000a697          	auipc	a3,0xa
ffffffffc0202276:	4b668693          	addi	a3,a3,1206 # ffffffffc020c728 <commands+0xd60>
ffffffffc020227a:	0000a617          	auipc	a2,0xa
ffffffffc020227e:	99e60613          	addi	a2,a2,-1634 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202282:	0bc00593          	li	a1,188
ffffffffc0202286:	0000a517          	auipc	a0,0xa
ffffffffc020228a:	40a50513          	addi	a0,a0,1034 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020228e:	fa1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202292:	0000a697          	auipc	a3,0xa
ffffffffc0202296:	4be68693          	addi	a3,a3,1214 # ffffffffc020c750 <commands+0xd88>
ffffffffc020229a:	0000a617          	auipc	a2,0xa
ffffffffc020229e:	97e60613          	addi	a2,a2,-1666 # ffffffffc020bc18 <commands+0x250>
ffffffffc02022a2:	0bd00593          	li	a1,189
ffffffffc02022a6:	0000a517          	auipc	a0,0xa
ffffffffc02022aa:	3ea50513          	addi	a0,a0,1002 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02022ae:	f81fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02022b2:	0000a697          	auipc	a3,0xa
ffffffffc02022b6:	4de68693          	addi	a3,a3,1246 # ffffffffc020c790 <commands+0xdc8>
ffffffffc02022ba:	0000a617          	auipc	a2,0xa
ffffffffc02022be:	95e60613          	addi	a2,a2,-1698 # ffffffffc020bc18 <commands+0x250>
ffffffffc02022c2:	0bf00593          	li	a1,191
ffffffffc02022c6:	0000a517          	auipc	a0,0xa
ffffffffc02022ca:	3ca50513          	addi	a0,a0,970 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02022ce:	f61fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02022d2:	0000a697          	auipc	a3,0xa
ffffffffc02022d6:	54668693          	addi	a3,a3,1350 # ffffffffc020c818 <commands+0xe50>
ffffffffc02022da:	0000a617          	auipc	a2,0xa
ffffffffc02022de:	93e60613          	addi	a2,a2,-1730 # ffffffffc020bc18 <commands+0x250>
ffffffffc02022e2:	0d800593          	li	a1,216
ffffffffc02022e6:	0000a517          	auipc	a0,0xa
ffffffffc02022ea:	3aa50513          	addi	a0,a0,938 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02022ee:	f41fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02022f2:	0000a697          	auipc	a3,0xa
ffffffffc02022f6:	3d668693          	addi	a3,a3,982 # ffffffffc020c6c8 <commands+0xd00>
ffffffffc02022fa:	0000a617          	auipc	a2,0xa
ffffffffc02022fe:	91e60613          	addi	a2,a2,-1762 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202302:	0d100593          	li	a1,209
ffffffffc0202306:	0000a517          	auipc	a0,0xa
ffffffffc020230a:	38a50513          	addi	a0,a0,906 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020230e:	f21fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202312:	0000a697          	auipc	a3,0xa
ffffffffc0202316:	4f668693          	addi	a3,a3,1270 # ffffffffc020c808 <commands+0xe40>
ffffffffc020231a:	0000a617          	auipc	a2,0xa
ffffffffc020231e:	8fe60613          	addi	a2,a2,-1794 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202322:	0cf00593          	li	a1,207
ffffffffc0202326:	0000a517          	auipc	a0,0xa
ffffffffc020232a:	36a50513          	addi	a0,a0,874 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020232e:	f01fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202332:	0000a697          	auipc	a3,0xa
ffffffffc0202336:	4be68693          	addi	a3,a3,1214 # ffffffffc020c7f0 <commands+0xe28>
ffffffffc020233a:	0000a617          	auipc	a2,0xa
ffffffffc020233e:	8de60613          	addi	a2,a2,-1826 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202342:	0ca00593          	li	a1,202
ffffffffc0202346:	0000a517          	auipc	a0,0xa
ffffffffc020234a:	34a50513          	addi	a0,a0,842 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020234e:	ee1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202352:	0000a697          	auipc	a3,0xa
ffffffffc0202356:	47e68693          	addi	a3,a3,1150 # ffffffffc020c7d0 <commands+0xe08>
ffffffffc020235a:	0000a617          	auipc	a2,0xa
ffffffffc020235e:	8be60613          	addi	a2,a2,-1858 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202362:	0c100593          	li	a1,193
ffffffffc0202366:	0000a517          	auipc	a0,0xa
ffffffffc020236a:	32a50513          	addi	a0,a0,810 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020236e:	ec1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202372:	0000a697          	auipc	a3,0xa
ffffffffc0202376:	4ee68693          	addi	a3,a3,1262 # ffffffffc020c860 <commands+0xe98>
ffffffffc020237a:	0000a617          	auipc	a2,0xa
ffffffffc020237e:	89e60613          	addi	a2,a2,-1890 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202382:	0f700593          	li	a1,247
ffffffffc0202386:	0000a517          	auipc	a0,0xa
ffffffffc020238a:	30a50513          	addi	a0,a0,778 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020238e:	ea1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202392:	0000a697          	auipc	a3,0xa
ffffffffc0202396:	4be68693          	addi	a3,a3,1214 # ffffffffc020c850 <commands+0xe88>
ffffffffc020239a:	0000a617          	auipc	a2,0xa
ffffffffc020239e:	87e60613          	addi	a2,a2,-1922 # ffffffffc020bc18 <commands+0x250>
ffffffffc02023a2:	0de00593          	li	a1,222
ffffffffc02023a6:	0000a517          	auipc	a0,0xa
ffffffffc02023aa:	2ea50513          	addi	a0,a0,746 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02023ae:	e81fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02023b2:	0000a697          	auipc	a3,0xa
ffffffffc02023b6:	43e68693          	addi	a3,a3,1086 # ffffffffc020c7f0 <commands+0xe28>
ffffffffc02023ba:	0000a617          	auipc	a2,0xa
ffffffffc02023be:	85e60613          	addi	a2,a2,-1954 # ffffffffc020bc18 <commands+0x250>
ffffffffc02023c2:	0dc00593          	li	a1,220
ffffffffc02023c6:	0000a517          	auipc	a0,0xa
ffffffffc02023ca:	2ca50513          	addi	a0,a0,714 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02023ce:	e61fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02023d2:	0000a697          	auipc	a3,0xa
ffffffffc02023d6:	45e68693          	addi	a3,a3,1118 # ffffffffc020c830 <commands+0xe68>
ffffffffc02023da:	0000a617          	auipc	a2,0xa
ffffffffc02023de:	83e60613          	addi	a2,a2,-1986 # ffffffffc020bc18 <commands+0x250>
ffffffffc02023e2:	0db00593          	li	a1,219
ffffffffc02023e6:	0000a517          	auipc	a0,0xa
ffffffffc02023ea:	2aa50513          	addi	a0,a0,682 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02023ee:	e41fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02023f2:	0000a697          	auipc	a3,0xa
ffffffffc02023f6:	2d668693          	addi	a3,a3,726 # ffffffffc020c6c8 <commands+0xd00>
ffffffffc02023fa:	0000a617          	auipc	a2,0xa
ffffffffc02023fe:	81e60613          	addi	a2,a2,-2018 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202402:	0b800593          	li	a1,184
ffffffffc0202406:	0000a517          	auipc	a0,0xa
ffffffffc020240a:	28a50513          	addi	a0,a0,650 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020240e:	e21fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202412:	0000a697          	auipc	a3,0xa
ffffffffc0202416:	3de68693          	addi	a3,a3,990 # ffffffffc020c7f0 <commands+0xe28>
ffffffffc020241a:	00009617          	auipc	a2,0x9
ffffffffc020241e:	7fe60613          	addi	a2,a2,2046 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202422:	0d500593          	li	a1,213
ffffffffc0202426:	0000a517          	auipc	a0,0xa
ffffffffc020242a:	26a50513          	addi	a0,a0,618 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020242e:	e01fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202432:	0000a697          	auipc	a3,0xa
ffffffffc0202436:	2d668693          	addi	a3,a3,726 # ffffffffc020c708 <commands+0xd40>
ffffffffc020243a:	00009617          	auipc	a2,0x9
ffffffffc020243e:	7de60613          	addi	a2,a2,2014 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202442:	0d300593          	li	a1,211
ffffffffc0202446:	0000a517          	auipc	a0,0xa
ffffffffc020244a:	24a50513          	addi	a0,a0,586 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020244e:	de1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202452:	0000a697          	auipc	a3,0xa
ffffffffc0202456:	29668693          	addi	a3,a3,662 # ffffffffc020c6e8 <commands+0xd20>
ffffffffc020245a:	00009617          	auipc	a2,0x9
ffffffffc020245e:	7be60613          	addi	a2,a2,1982 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202462:	0d200593          	li	a1,210
ffffffffc0202466:	0000a517          	auipc	a0,0xa
ffffffffc020246a:	22a50513          	addi	a0,a0,554 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020246e:	dc1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202472:	0000a697          	auipc	a3,0xa
ffffffffc0202476:	29668693          	addi	a3,a3,662 # ffffffffc020c708 <commands+0xd40>
ffffffffc020247a:	00009617          	auipc	a2,0x9
ffffffffc020247e:	79e60613          	addi	a2,a2,1950 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202482:	0ba00593          	li	a1,186
ffffffffc0202486:	0000a517          	auipc	a0,0xa
ffffffffc020248a:	20a50513          	addi	a0,a0,522 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020248e:	da1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202492:	0000a697          	auipc	a3,0xa
ffffffffc0202496:	51e68693          	addi	a3,a3,1310 # ffffffffc020c9b0 <commands+0xfe8>
ffffffffc020249a:	00009617          	auipc	a2,0x9
ffffffffc020249e:	77e60613          	addi	a2,a2,1918 # ffffffffc020bc18 <commands+0x250>
ffffffffc02024a2:	12400593          	li	a1,292
ffffffffc02024a6:	0000a517          	auipc	a0,0xa
ffffffffc02024aa:	1ea50513          	addi	a0,a0,490 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02024ae:	d81fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024b2:	0000a697          	auipc	a3,0xa
ffffffffc02024b6:	39e68693          	addi	a3,a3,926 # ffffffffc020c850 <commands+0xe88>
ffffffffc02024ba:	00009617          	auipc	a2,0x9
ffffffffc02024be:	75e60613          	addi	a2,a2,1886 # ffffffffc020bc18 <commands+0x250>
ffffffffc02024c2:	11900593          	li	a1,281
ffffffffc02024c6:	0000a517          	auipc	a0,0xa
ffffffffc02024ca:	1ca50513          	addi	a0,a0,458 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02024ce:	d61fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024d2:	0000a697          	auipc	a3,0xa
ffffffffc02024d6:	31e68693          	addi	a3,a3,798 # ffffffffc020c7f0 <commands+0xe28>
ffffffffc02024da:	00009617          	auipc	a2,0x9
ffffffffc02024de:	73e60613          	addi	a2,a2,1854 # ffffffffc020bc18 <commands+0x250>
ffffffffc02024e2:	11700593          	li	a1,279
ffffffffc02024e6:	0000a517          	auipc	a0,0xa
ffffffffc02024ea:	1aa50513          	addi	a0,a0,426 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02024ee:	d41fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024f2:	0000a697          	auipc	a3,0xa
ffffffffc02024f6:	2be68693          	addi	a3,a3,702 # ffffffffc020c7b0 <commands+0xde8>
ffffffffc02024fa:	00009617          	auipc	a2,0x9
ffffffffc02024fe:	71e60613          	addi	a2,a2,1822 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202502:	0c000593          	li	a1,192
ffffffffc0202506:	0000a517          	auipc	a0,0xa
ffffffffc020250a:	18a50513          	addi	a0,a0,394 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020250e:	d21fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202512:	0000a697          	auipc	a3,0xa
ffffffffc0202516:	45e68693          	addi	a3,a3,1118 # ffffffffc020c970 <commands+0xfa8>
ffffffffc020251a:	00009617          	auipc	a2,0x9
ffffffffc020251e:	6fe60613          	addi	a2,a2,1790 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202522:	11100593          	li	a1,273
ffffffffc0202526:	0000a517          	auipc	a0,0xa
ffffffffc020252a:	16a50513          	addi	a0,a0,362 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020252e:	d01fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202532:	0000a697          	auipc	a3,0xa
ffffffffc0202536:	41e68693          	addi	a3,a3,1054 # ffffffffc020c950 <commands+0xf88>
ffffffffc020253a:	00009617          	auipc	a2,0x9
ffffffffc020253e:	6de60613          	addi	a2,a2,1758 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202542:	10f00593          	li	a1,271
ffffffffc0202546:	0000a517          	auipc	a0,0xa
ffffffffc020254a:	14a50513          	addi	a0,a0,330 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020254e:	ce1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202552:	0000a697          	auipc	a3,0xa
ffffffffc0202556:	3d668693          	addi	a3,a3,982 # ffffffffc020c928 <commands+0xf60>
ffffffffc020255a:	00009617          	auipc	a2,0x9
ffffffffc020255e:	6be60613          	addi	a2,a2,1726 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202562:	10d00593          	li	a1,269
ffffffffc0202566:	0000a517          	auipc	a0,0xa
ffffffffc020256a:	12a50513          	addi	a0,a0,298 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020256e:	cc1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202572:	0000a697          	auipc	a3,0xa
ffffffffc0202576:	38e68693          	addi	a3,a3,910 # ffffffffc020c900 <commands+0xf38>
ffffffffc020257a:	00009617          	auipc	a2,0x9
ffffffffc020257e:	69e60613          	addi	a2,a2,1694 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202582:	10c00593          	li	a1,268
ffffffffc0202586:	0000a517          	auipc	a0,0xa
ffffffffc020258a:	10a50513          	addi	a0,a0,266 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020258e:	ca1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202592:	0000a697          	auipc	a3,0xa
ffffffffc0202596:	35e68693          	addi	a3,a3,862 # ffffffffc020c8f0 <commands+0xf28>
ffffffffc020259a:	00009617          	auipc	a2,0x9
ffffffffc020259e:	67e60613          	addi	a2,a2,1662 # ffffffffc020bc18 <commands+0x250>
ffffffffc02025a2:	10700593          	li	a1,263
ffffffffc02025a6:	0000a517          	auipc	a0,0xa
ffffffffc02025aa:	0ea50513          	addi	a0,a0,234 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02025ae:	c81fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025b2:	0000a697          	auipc	a3,0xa
ffffffffc02025b6:	23e68693          	addi	a3,a3,574 # ffffffffc020c7f0 <commands+0xe28>
ffffffffc02025ba:	00009617          	auipc	a2,0x9
ffffffffc02025be:	65e60613          	addi	a2,a2,1630 # ffffffffc020bc18 <commands+0x250>
ffffffffc02025c2:	10600593          	li	a1,262
ffffffffc02025c6:	0000a517          	auipc	a0,0xa
ffffffffc02025ca:	0ca50513          	addi	a0,a0,202 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02025ce:	c61fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025d2:	0000a697          	auipc	a3,0xa
ffffffffc02025d6:	2fe68693          	addi	a3,a3,766 # ffffffffc020c8d0 <commands+0xf08>
ffffffffc02025da:	00009617          	auipc	a2,0x9
ffffffffc02025de:	63e60613          	addi	a2,a2,1598 # ffffffffc020bc18 <commands+0x250>
ffffffffc02025e2:	10500593          	li	a1,261
ffffffffc02025e6:	0000a517          	auipc	a0,0xa
ffffffffc02025ea:	0aa50513          	addi	a0,a0,170 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02025ee:	c41fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025f2:	0000a697          	auipc	a3,0xa
ffffffffc02025f6:	2ae68693          	addi	a3,a3,686 # ffffffffc020c8a0 <commands+0xed8>
ffffffffc02025fa:	00009617          	auipc	a2,0x9
ffffffffc02025fe:	61e60613          	addi	a2,a2,1566 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202602:	10400593          	li	a1,260
ffffffffc0202606:	0000a517          	auipc	a0,0xa
ffffffffc020260a:	08a50513          	addi	a0,a0,138 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020260e:	c21fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202612:	0000a697          	auipc	a3,0xa
ffffffffc0202616:	27668693          	addi	a3,a3,630 # ffffffffc020c888 <commands+0xec0>
ffffffffc020261a:	00009617          	auipc	a2,0x9
ffffffffc020261e:	5fe60613          	addi	a2,a2,1534 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202622:	10300593          	li	a1,259
ffffffffc0202626:	0000a517          	auipc	a0,0xa
ffffffffc020262a:	06a50513          	addi	a0,a0,106 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020262e:	c01fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202632:	0000a697          	auipc	a3,0xa
ffffffffc0202636:	1be68693          	addi	a3,a3,446 # ffffffffc020c7f0 <commands+0xe28>
ffffffffc020263a:	00009617          	auipc	a2,0x9
ffffffffc020263e:	5de60613          	addi	a2,a2,1502 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202642:	0fd00593          	li	a1,253
ffffffffc0202646:	0000a517          	auipc	a0,0xa
ffffffffc020264a:	04a50513          	addi	a0,a0,74 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020264e:	be1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202652:	0000a697          	auipc	a3,0xa
ffffffffc0202656:	21e68693          	addi	a3,a3,542 # ffffffffc020c870 <commands+0xea8>
ffffffffc020265a:	00009617          	auipc	a2,0x9
ffffffffc020265e:	5be60613          	addi	a2,a2,1470 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202662:	0f800593          	li	a1,248
ffffffffc0202666:	0000a517          	auipc	a0,0xa
ffffffffc020266a:	02a50513          	addi	a0,a0,42 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020266e:	bc1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202672:	0000a697          	auipc	a3,0xa
ffffffffc0202676:	31e68693          	addi	a3,a3,798 # ffffffffc020c990 <commands+0xfc8>
ffffffffc020267a:	00009617          	auipc	a2,0x9
ffffffffc020267e:	59e60613          	addi	a2,a2,1438 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202682:	11600593          	li	a1,278
ffffffffc0202686:	0000a517          	auipc	a0,0xa
ffffffffc020268a:	00a50513          	addi	a0,a0,10 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020268e:	ba1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202692:	0000a697          	auipc	a3,0xa
ffffffffc0202696:	32e68693          	addi	a3,a3,814 # ffffffffc020c9c0 <commands+0xff8>
ffffffffc020269a:	00009617          	auipc	a2,0x9
ffffffffc020269e:	57e60613          	addi	a2,a2,1406 # ffffffffc020bc18 <commands+0x250>
ffffffffc02026a2:	12500593          	li	a1,293
ffffffffc02026a6:	0000a517          	auipc	a0,0xa
ffffffffc02026aa:	fea50513          	addi	a0,a0,-22 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02026ae:	b81fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026b2:	0000a697          	auipc	a3,0xa
ffffffffc02026b6:	ff668693          	addi	a3,a3,-10 # ffffffffc020c6a8 <commands+0xce0>
ffffffffc02026ba:	00009617          	auipc	a2,0x9
ffffffffc02026be:	55e60613          	addi	a2,a2,1374 # ffffffffc020bc18 <commands+0x250>
ffffffffc02026c2:	0f200593          	li	a1,242
ffffffffc02026c6:	0000a517          	auipc	a0,0xa
ffffffffc02026ca:	fca50513          	addi	a0,a0,-54 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02026ce:	b61fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026d2:	0000a697          	auipc	a3,0xa
ffffffffc02026d6:	01668693          	addi	a3,a3,22 # ffffffffc020c6e8 <commands+0xd20>
ffffffffc02026da:	00009617          	auipc	a2,0x9
ffffffffc02026de:	53e60613          	addi	a2,a2,1342 # ffffffffc020bc18 <commands+0x250>
ffffffffc02026e2:	0b900593          	li	a1,185
ffffffffc02026e6:	0000a517          	auipc	a0,0xa
ffffffffc02026ea:	faa50513          	addi	a0,a0,-86 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02026ee:	b41fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02026f2 <default_free_pages>:
ffffffffc02026f2:	1141                	addi	sp,sp,-16
ffffffffc02026f4:	e406                	sd	ra,8(sp)
ffffffffc02026f6:	14058463          	beqz	a1,ffffffffc020283e <default_free_pages+0x14c>
ffffffffc02026fa:	00659693          	slli	a3,a1,0x6
ffffffffc02026fe:	96aa                	add	a3,a3,a0
ffffffffc0202700:	87aa                	mv	a5,a0
ffffffffc0202702:	02d50263          	beq	a0,a3,ffffffffc0202726 <default_free_pages+0x34>
ffffffffc0202706:	6798                	ld	a4,8(a5)
ffffffffc0202708:	8b05                	andi	a4,a4,1
ffffffffc020270a:	10071a63          	bnez	a4,ffffffffc020281e <default_free_pages+0x12c>
ffffffffc020270e:	6798                	ld	a4,8(a5)
ffffffffc0202710:	8b09                	andi	a4,a4,2
ffffffffc0202712:	10071663          	bnez	a4,ffffffffc020281e <default_free_pages+0x12c>
ffffffffc0202716:	0007b423          	sd	zero,8(a5)
ffffffffc020271a:	0007a023          	sw	zero,0(a5)
ffffffffc020271e:	04078793          	addi	a5,a5,64
ffffffffc0202722:	fed792e3          	bne	a5,a3,ffffffffc0202706 <default_free_pages+0x14>
ffffffffc0202726:	2581                	sext.w	a1,a1
ffffffffc0202728:	c90c                	sw	a1,16(a0)
ffffffffc020272a:	00850893          	addi	a7,a0,8
ffffffffc020272e:	4789                	li	a5,2
ffffffffc0202730:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0202734:	0008f697          	auipc	a3,0x8f
ffffffffc0202738:	07468693          	addi	a3,a3,116 # ffffffffc02917a8 <free_area>
ffffffffc020273c:	4a98                	lw	a4,16(a3)
ffffffffc020273e:	669c                	ld	a5,8(a3)
ffffffffc0202740:	01850613          	addi	a2,a0,24
ffffffffc0202744:	9db9                	addw	a1,a1,a4
ffffffffc0202746:	ca8c                	sw	a1,16(a3)
ffffffffc0202748:	0ad78463          	beq	a5,a3,ffffffffc02027f0 <default_free_pages+0xfe>
ffffffffc020274c:	fe878713          	addi	a4,a5,-24
ffffffffc0202750:	0006b803          	ld	a6,0(a3)
ffffffffc0202754:	4581                	li	a1,0
ffffffffc0202756:	00e56a63          	bltu	a0,a4,ffffffffc020276a <default_free_pages+0x78>
ffffffffc020275a:	6798                	ld	a4,8(a5)
ffffffffc020275c:	04d70c63          	beq	a4,a3,ffffffffc02027b4 <default_free_pages+0xc2>
ffffffffc0202760:	87ba                	mv	a5,a4
ffffffffc0202762:	fe878713          	addi	a4,a5,-24
ffffffffc0202766:	fee57ae3          	bgeu	a0,a4,ffffffffc020275a <default_free_pages+0x68>
ffffffffc020276a:	c199                	beqz	a1,ffffffffc0202770 <default_free_pages+0x7e>
ffffffffc020276c:	0106b023          	sd	a6,0(a3)
ffffffffc0202770:	6398                	ld	a4,0(a5)
ffffffffc0202772:	e390                	sd	a2,0(a5)
ffffffffc0202774:	e710                	sd	a2,8(a4)
ffffffffc0202776:	f11c                	sd	a5,32(a0)
ffffffffc0202778:	ed18                	sd	a4,24(a0)
ffffffffc020277a:	00d70d63          	beq	a4,a3,ffffffffc0202794 <default_free_pages+0xa2>
ffffffffc020277e:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_bin_swap_img_size-0x6d08>
ffffffffc0202782:	fe870613          	addi	a2,a4,-24
ffffffffc0202786:	02059813          	slli	a6,a1,0x20
ffffffffc020278a:	01a85793          	srli	a5,a6,0x1a
ffffffffc020278e:	97b2                	add	a5,a5,a2
ffffffffc0202790:	02f50c63          	beq	a0,a5,ffffffffc02027c8 <default_free_pages+0xd6>
ffffffffc0202794:	711c                	ld	a5,32(a0)
ffffffffc0202796:	00d78c63          	beq	a5,a3,ffffffffc02027ae <default_free_pages+0xbc>
ffffffffc020279a:	4910                	lw	a2,16(a0)
ffffffffc020279c:	fe878693          	addi	a3,a5,-24
ffffffffc02027a0:	02061593          	slli	a1,a2,0x20
ffffffffc02027a4:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02027a8:	972a                	add	a4,a4,a0
ffffffffc02027aa:	04e68a63          	beq	a3,a4,ffffffffc02027fe <default_free_pages+0x10c>
ffffffffc02027ae:	60a2                	ld	ra,8(sp)
ffffffffc02027b0:	0141                	addi	sp,sp,16
ffffffffc02027b2:	8082                	ret
ffffffffc02027b4:	e790                	sd	a2,8(a5)
ffffffffc02027b6:	f114                	sd	a3,32(a0)
ffffffffc02027b8:	6798                	ld	a4,8(a5)
ffffffffc02027ba:	ed1c                	sd	a5,24(a0)
ffffffffc02027bc:	02d70763          	beq	a4,a3,ffffffffc02027ea <default_free_pages+0xf8>
ffffffffc02027c0:	8832                	mv	a6,a2
ffffffffc02027c2:	4585                	li	a1,1
ffffffffc02027c4:	87ba                	mv	a5,a4
ffffffffc02027c6:	bf71                	j	ffffffffc0202762 <default_free_pages+0x70>
ffffffffc02027c8:	491c                	lw	a5,16(a0)
ffffffffc02027ca:	9dbd                	addw	a1,a1,a5
ffffffffc02027cc:	feb72c23          	sw	a1,-8(a4)
ffffffffc02027d0:	57f5                	li	a5,-3
ffffffffc02027d2:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc02027d6:	01853803          	ld	a6,24(a0)
ffffffffc02027da:	710c                	ld	a1,32(a0)
ffffffffc02027dc:	8532                	mv	a0,a2
ffffffffc02027de:	00b83423          	sd	a1,8(a6)
ffffffffc02027e2:	671c                	ld	a5,8(a4)
ffffffffc02027e4:	0105b023          	sd	a6,0(a1) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02027e8:	b77d                	j	ffffffffc0202796 <default_free_pages+0xa4>
ffffffffc02027ea:	e290                	sd	a2,0(a3)
ffffffffc02027ec:	873e                	mv	a4,a5
ffffffffc02027ee:	bf41                	j	ffffffffc020277e <default_free_pages+0x8c>
ffffffffc02027f0:	60a2                	ld	ra,8(sp)
ffffffffc02027f2:	e390                	sd	a2,0(a5)
ffffffffc02027f4:	e790                	sd	a2,8(a5)
ffffffffc02027f6:	f11c                	sd	a5,32(a0)
ffffffffc02027f8:	ed1c                	sd	a5,24(a0)
ffffffffc02027fa:	0141                	addi	sp,sp,16
ffffffffc02027fc:	8082                	ret
ffffffffc02027fe:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202802:	ff078693          	addi	a3,a5,-16
ffffffffc0202806:	9e39                	addw	a2,a2,a4
ffffffffc0202808:	c910                	sw	a2,16(a0)
ffffffffc020280a:	5775                	li	a4,-3
ffffffffc020280c:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0202810:	6398                	ld	a4,0(a5)
ffffffffc0202812:	679c                	ld	a5,8(a5)
ffffffffc0202814:	60a2                	ld	ra,8(sp)
ffffffffc0202816:	e71c                	sd	a5,8(a4)
ffffffffc0202818:	e398                	sd	a4,0(a5)
ffffffffc020281a:	0141                	addi	sp,sp,16
ffffffffc020281c:	8082                	ret
ffffffffc020281e:	0000a697          	auipc	a3,0xa
ffffffffc0202822:	1ba68693          	addi	a3,a3,442 # ffffffffc020c9d8 <commands+0x1010>
ffffffffc0202826:	00009617          	auipc	a2,0x9
ffffffffc020282a:	3f260613          	addi	a2,a2,1010 # ffffffffc020bc18 <commands+0x250>
ffffffffc020282e:	08200593          	li	a1,130
ffffffffc0202832:	0000a517          	auipc	a0,0xa
ffffffffc0202836:	e5e50513          	addi	a0,a0,-418 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020283a:	9f5fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020283e:	0000a697          	auipc	a3,0xa
ffffffffc0202842:	19268693          	addi	a3,a3,402 # ffffffffc020c9d0 <commands+0x1008>
ffffffffc0202846:	00009617          	auipc	a2,0x9
ffffffffc020284a:	3d260613          	addi	a2,a2,978 # ffffffffc020bc18 <commands+0x250>
ffffffffc020284e:	07f00593          	li	a1,127
ffffffffc0202852:	0000a517          	auipc	a0,0xa
ffffffffc0202856:	e3e50513          	addi	a0,a0,-450 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020285a:	9d5fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020285e <default_alloc_pages>:
ffffffffc020285e:	c941                	beqz	a0,ffffffffc02028ee <default_alloc_pages+0x90>
ffffffffc0202860:	0008f597          	auipc	a1,0x8f
ffffffffc0202864:	f4858593          	addi	a1,a1,-184 # ffffffffc02917a8 <free_area>
ffffffffc0202868:	0105a803          	lw	a6,16(a1)
ffffffffc020286c:	872a                	mv	a4,a0
ffffffffc020286e:	02081793          	slli	a5,a6,0x20
ffffffffc0202872:	9381                	srli	a5,a5,0x20
ffffffffc0202874:	00a7ee63          	bltu	a5,a0,ffffffffc0202890 <default_alloc_pages+0x32>
ffffffffc0202878:	87ae                	mv	a5,a1
ffffffffc020287a:	a801                	j	ffffffffc020288a <default_alloc_pages+0x2c>
ffffffffc020287c:	ff87a683          	lw	a3,-8(a5)
ffffffffc0202880:	02069613          	slli	a2,a3,0x20
ffffffffc0202884:	9201                	srli	a2,a2,0x20
ffffffffc0202886:	00e67763          	bgeu	a2,a4,ffffffffc0202894 <default_alloc_pages+0x36>
ffffffffc020288a:	679c                	ld	a5,8(a5)
ffffffffc020288c:	feb798e3          	bne	a5,a1,ffffffffc020287c <default_alloc_pages+0x1e>
ffffffffc0202890:	4501                	li	a0,0
ffffffffc0202892:	8082                	ret
ffffffffc0202894:	0007b883          	ld	a7,0(a5)
ffffffffc0202898:	0087b303          	ld	t1,8(a5)
ffffffffc020289c:	fe878513          	addi	a0,a5,-24
ffffffffc02028a0:	00070e1b          	sext.w	t3,a4
ffffffffc02028a4:	0068b423          	sd	t1,8(a7) # 10000008 <_binary_bin_sfs_img_size+0xff8ad08>
ffffffffc02028a8:	01133023          	sd	a7,0(t1)
ffffffffc02028ac:	02c77863          	bgeu	a4,a2,ffffffffc02028dc <default_alloc_pages+0x7e>
ffffffffc02028b0:	071a                	slli	a4,a4,0x6
ffffffffc02028b2:	972a                	add	a4,a4,a0
ffffffffc02028b4:	41c686bb          	subw	a3,a3,t3
ffffffffc02028b8:	cb14                	sw	a3,16(a4)
ffffffffc02028ba:	00870613          	addi	a2,a4,8
ffffffffc02028be:	4689                	li	a3,2
ffffffffc02028c0:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc02028c4:	0088b683          	ld	a3,8(a7)
ffffffffc02028c8:	01870613          	addi	a2,a4,24
ffffffffc02028cc:	0105a803          	lw	a6,16(a1)
ffffffffc02028d0:	e290                	sd	a2,0(a3)
ffffffffc02028d2:	00c8b423          	sd	a2,8(a7)
ffffffffc02028d6:	f314                	sd	a3,32(a4)
ffffffffc02028d8:	01173c23          	sd	a7,24(a4)
ffffffffc02028dc:	41c8083b          	subw	a6,a6,t3
ffffffffc02028e0:	0105a823          	sw	a6,16(a1)
ffffffffc02028e4:	5775                	li	a4,-3
ffffffffc02028e6:	17c1                	addi	a5,a5,-16
ffffffffc02028e8:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc02028ec:	8082                	ret
ffffffffc02028ee:	1141                	addi	sp,sp,-16
ffffffffc02028f0:	0000a697          	auipc	a3,0xa
ffffffffc02028f4:	0e068693          	addi	a3,a3,224 # ffffffffc020c9d0 <commands+0x1008>
ffffffffc02028f8:	00009617          	auipc	a2,0x9
ffffffffc02028fc:	32060613          	addi	a2,a2,800 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202900:	06100593          	li	a1,97
ffffffffc0202904:	0000a517          	auipc	a0,0xa
ffffffffc0202908:	d8c50513          	addi	a0,a0,-628 # ffffffffc020c690 <commands+0xcc8>
ffffffffc020290c:	e406                	sd	ra,8(sp)
ffffffffc020290e:	921fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202912 <default_init_memmap>:
ffffffffc0202912:	1141                	addi	sp,sp,-16
ffffffffc0202914:	e406                	sd	ra,8(sp)
ffffffffc0202916:	c5f1                	beqz	a1,ffffffffc02029e2 <default_init_memmap+0xd0>
ffffffffc0202918:	00659693          	slli	a3,a1,0x6
ffffffffc020291c:	96aa                	add	a3,a3,a0
ffffffffc020291e:	87aa                	mv	a5,a0
ffffffffc0202920:	00d50f63          	beq	a0,a3,ffffffffc020293e <default_init_memmap+0x2c>
ffffffffc0202924:	6798                	ld	a4,8(a5)
ffffffffc0202926:	8b05                	andi	a4,a4,1
ffffffffc0202928:	cf49                	beqz	a4,ffffffffc02029c2 <default_init_memmap+0xb0>
ffffffffc020292a:	0007a823          	sw	zero,16(a5)
ffffffffc020292e:	0007b423          	sd	zero,8(a5)
ffffffffc0202932:	0007a023          	sw	zero,0(a5)
ffffffffc0202936:	04078793          	addi	a5,a5,64
ffffffffc020293a:	fed795e3          	bne	a5,a3,ffffffffc0202924 <default_init_memmap+0x12>
ffffffffc020293e:	2581                	sext.w	a1,a1
ffffffffc0202940:	c90c                	sw	a1,16(a0)
ffffffffc0202942:	4789                	li	a5,2
ffffffffc0202944:	00850713          	addi	a4,a0,8
ffffffffc0202948:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc020294c:	0008f697          	auipc	a3,0x8f
ffffffffc0202950:	e5c68693          	addi	a3,a3,-420 # ffffffffc02917a8 <free_area>
ffffffffc0202954:	4a98                	lw	a4,16(a3)
ffffffffc0202956:	669c                	ld	a5,8(a3)
ffffffffc0202958:	01850613          	addi	a2,a0,24
ffffffffc020295c:	9db9                	addw	a1,a1,a4
ffffffffc020295e:	ca8c                	sw	a1,16(a3)
ffffffffc0202960:	04d78a63          	beq	a5,a3,ffffffffc02029b4 <default_init_memmap+0xa2>
ffffffffc0202964:	fe878713          	addi	a4,a5,-24
ffffffffc0202968:	0006b803          	ld	a6,0(a3)
ffffffffc020296c:	4581                	li	a1,0
ffffffffc020296e:	00e56a63          	bltu	a0,a4,ffffffffc0202982 <default_init_memmap+0x70>
ffffffffc0202972:	6798                	ld	a4,8(a5)
ffffffffc0202974:	02d70263          	beq	a4,a3,ffffffffc0202998 <default_init_memmap+0x86>
ffffffffc0202978:	87ba                	mv	a5,a4
ffffffffc020297a:	fe878713          	addi	a4,a5,-24
ffffffffc020297e:	fee57ae3          	bgeu	a0,a4,ffffffffc0202972 <default_init_memmap+0x60>
ffffffffc0202982:	c199                	beqz	a1,ffffffffc0202988 <default_init_memmap+0x76>
ffffffffc0202984:	0106b023          	sd	a6,0(a3)
ffffffffc0202988:	6398                	ld	a4,0(a5)
ffffffffc020298a:	60a2                	ld	ra,8(sp)
ffffffffc020298c:	e390                	sd	a2,0(a5)
ffffffffc020298e:	e710                	sd	a2,8(a4)
ffffffffc0202990:	f11c                	sd	a5,32(a0)
ffffffffc0202992:	ed18                	sd	a4,24(a0)
ffffffffc0202994:	0141                	addi	sp,sp,16
ffffffffc0202996:	8082                	ret
ffffffffc0202998:	e790                	sd	a2,8(a5)
ffffffffc020299a:	f114                	sd	a3,32(a0)
ffffffffc020299c:	6798                	ld	a4,8(a5)
ffffffffc020299e:	ed1c                	sd	a5,24(a0)
ffffffffc02029a0:	00d70663          	beq	a4,a3,ffffffffc02029ac <default_init_memmap+0x9a>
ffffffffc02029a4:	8832                	mv	a6,a2
ffffffffc02029a6:	4585                	li	a1,1
ffffffffc02029a8:	87ba                	mv	a5,a4
ffffffffc02029aa:	bfc1                	j	ffffffffc020297a <default_init_memmap+0x68>
ffffffffc02029ac:	60a2                	ld	ra,8(sp)
ffffffffc02029ae:	e290                	sd	a2,0(a3)
ffffffffc02029b0:	0141                	addi	sp,sp,16
ffffffffc02029b2:	8082                	ret
ffffffffc02029b4:	60a2                	ld	ra,8(sp)
ffffffffc02029b6:	e390                	sd	a2,0(a5)
ffffffffc02029b8:	e790                	sd	a2,8(a5)
ffffffffc02029ba:	f11c                	sd	a5,32(a0)
ffffffffc02029bc:	ed1c                	sd	a5,24(a0)
ffffffffc02029be:	0141                	addi	sp,sp,16
ffffffffc02029c0:	8082                	ret
ffffffffc02029c2:	0000a697          	auipc	a3,0xa
ffffffffc02029c6:	03e68693          	addi	a3,a3,62 # ffffffffc020ca00 <commands+0x1038>
ffffffffc02029ca:	00009617          	auipc	a2,0x9
ffffffffc02029ce:	24e60613          	addi	a2,a2,590 # ffffffffc020bc18 <commands+0x250>
ffffffffc02029d2:	04800593          	li	a1,72
ffffffffc02029d6:	0000a517          	auipc	a0,0xa
ffffffffc02029da:	cba50513          	addi	a0,a0,-838 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02029de:	851fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029e2:	0000a697          	auipc	a3,0xa
ffffffffc02029e6:	fee68693          	addi	a3,a3,-18 # ffffffffc020c9d0 <commands+0x1008>
ffffffffc02029ea:	00009617          	auipc	a2,0x9
ffffffffc02029ee:	22e60613          	addi	a2,a2,558 # ffffffffc020bc18 <commands+0x250>
ffffffffc02029f2:	04500593          	li	a1,69
ffffffffc02029f6:	0000a517          	auipc	a0,0xa
ffffffffc02029fa:	c9a50513          	addi	a0,a0,-870 # ffffffffc020c690 <commands+0xcc8>
ffffffffc02029fe:	831fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202a02 <pa2page.part.0>:
ffffffffc0202a02:	1141                	addi	sp,sp,-16
ffffffffc0202a04:	0000a617          	auipc	a2,0xa
ffffffffc0202a08:	c5c60613          	addi	a2,a2,-932 # ffffffffc020c660 <commands+0xc98>
ffffffffc0202a0c:	06900593          	li	a1,105
ffffffffc0202a10:	0000a517          	auipc	a0,0xa
ffffffffc0202a14:	ba850513          	addi	a0,a0,-1112 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0202a18:	e406                	sd	ra,8(sp)
ffffffffc0202a1a:	815fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202a1e <pte2page.part.0>:
ffffffffc0202a1e:	1141                	addi	sp,sp,-16
ffffffffc0202a20:	0000a617          	auipc	a2,0xa
ffffffffc0202a24:	04060613          	addi	a2,a2,64 # ffffffffc020ca60 <default_pmm_manager+0x38>
ffffffffc0202a28:	07f00593          	li	a1,127
ffffffffc0202a2c:	0000a517          	auipc	a0,0xa
ffffffffc0202a30:	b8c50513          	addi	a0,a0,-1140 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0202a34:	e406                	sd	ra,8(sp)
ffffffffc0202a36:	ff8fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202a3a <alloc_pages>:
ffffffffc0202a3a:	100027f3          	csrr	a5,sstatus
ffffffffc0202a3e:	8b89                	andi	a5,a5,2
ffffffffc0202a40:	e799                	bnez	a5,ffffffffc0202a4e <alloc_pages+0x14>
ffffffffc0202a42:	00094797          	auipc	a5,0x94
ffffffffc0202a46:	e6e7b783          	ld	a5,-402(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a4a:	6f9c                	ld	a5,24(a5)
ffffffffc0202a4c:	8782                	jr	a5
ffffffffc0202a4e:	1141                	addi	sp,sp,-16
ffffffffc0202a50:	e406                	sd	ra,8(sp)
ffffffffc0202a52:	e022                	sd	s0,0(sp)
ffffffffc0202a54:	842a                	mv	s0,a0
ffffffffc0202a56:	b4afe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202a5a:	00094797          	auipc	a5,0x94
ffffffffc0202a5e:	e567b783          	ld	a5,-426(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a62:	6f9c                	ld	a5,24(a5)
ffffffffc0202a64:	8522                	mv	a0,s0
ffffffffc0202a66:	9782                	jalr	a5
ffffffffc0202a68:	842a                	mv	s0,a0
ffffffffc0202a6a:	b30fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202a6e:	60a2                	ld	ra,8(sp)
ffffffffc0202a70:	8522                	mv	a0,s0
ffffffffc0202a72:	6402                	ld	s0,0(sp)
ffffffffc0202a74:	0141                	addi	sp,sp,16
ffffffffc0202a76:	8082                	ret

ffffffffc0202a78 <free_pages>:
ffffffffc0202a78:	100027f3          	csrr	a5,sstatus
ffffffffc0202a7c:	8b89                	andi	a5,a5,2
ffffffffc0202a7e:	e799                	bnez	a5,ffffffffc0202a8c <free_pages+0x14>
ffffffffc0202a80:	00094797          	auipc	a5,0x94
ffffffffc0202a84:	e307b783          	ld	a5,-464(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a88:	739c                	ld	a5,32(a5)
ffffffffc0202a8a:	8782                	jr	a5
ffffffffc0202a8c:	1101                	addi	sp,sp,-32
ffffffffc0202a8e:	ec06                	sd	ra,24(sp)
ffffffffc0202a90:	e822                	sd	s0,16(sp)
ffffffffc0202a92:	e426                	sd	s1,8(sp)
ffffffffc0202a94:	842a                	mv	s0,a0
ffffffffc0202a96:	84ae                	mv	s1,a1
ffffffffc0202a98:	b08fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202a9c:	00094797          	auipc	a5,0x94
ffffffffc0202aa0:	e147b783          	ld	a5,-492(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202aa4:	739c                	ld	a5,32(a5)
ffffffffc0202aa6:	85a6                	mv	a1,s1
ffffffffc0202aa8:	8522                	mv	a0,s0
ffffffffc0202aaa:	9782                	jalr	a5
ffffffffc0202aac:	6442                	ld	s0,16(sp)
ffffffffc0202aae:	60e2                	ld	ra,24(sp)
ffffffffc0202ab0:	64a2                	ld	s1,8(sp)
ffffffffc0202ab2:	6105                	addi	sp,sp,32
ffffffffc0202ab4:	ae6fe06f          	j	ffffffffc0200d9a <intr_enable>

ffffffffc0202ab8 <nr_free_pages>:
ffffffffc0202ab8:	100027f3          	csrr	a5,sstatus
ffffffffc0202abc:	8b89                	andi	a5,a5,2
ffffffffc0202abe:	e799                	bnez	a5,ffffffffc0202acc <nr_free_pages+0x14>
ffffffffc0202ac0:	00094797          	auipc	a5,0x94
ffffffffc0202ac4:	df07b783          	ld	a5,-528(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202ac8:	779c                	ld	a5,40(a5)
ffffffffc0202aca:	8782                	jr	a5
ffffffffc0202acc:	1141                	addi	sp,sp,-16
ffffffffc0202ace:	e406                	sd	ra,8(sp)
ffffffffc0202ad0:	e022                	sd	s0,0(sp)
ffffffffc0202ad2:	acefe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202ad6:	00094797          	auipc	a5,0x94
ffffffffc0202ada:	dda7b783          	ld	a5,-550(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202ade:	779c                	ld	a5,40(a5)
ffffffffc0202ae0:	9782                	jalr	a5
ffffffffc0202ae2:	842a                	mv	s0,a0
ffffffffc0202ae4:	ab6fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202ae8:	60a2                	ld	ra,8(sp)
ffffffffc0202aea:	8522                	mv	a0,s0
ffffffffc0202aec:	6402                	ld	s0,0(sp)
ffffffffc0202aee:	0141                	addi	sp,sp,16
ffffffffc0202af0:	8082                	ret

ffffffffc0202af2 <get_pte>:
ffffffffc0202af2:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202af6:	1ff7f793          	andi	a5,a5,511
ffffffffc0202afa:	7139                	addi	sp,sp,-64
ffffffffc0202afc:	078e                	slli	a5,a5,0x3
ffffffffc0202afe:	f426                	sd	s1,40(sp)
ffffffffc0202b00:	00f504b3          	add	s1,a0,a5
ffffffffc0202b04:	6094                	ld	a3,0(s1)
ffffffffc0202b06:	f04a                	sd	s2,32(sp)
ffffffffc0202b08:	ec4e                	sd	s3,24(sp)
ffffffffc0202b0a:	e852                	sd	s4,16(sp)
ffffffffc0202b0c:	fc06                	sd	ra,56(sp)
ffffffffc0202b0e:	f822                	sd	s0,48(sp)
ffffffffc0202b10:	e456                	sd	s5,8(sp)
ffffffffc0202b12:	e05a                	sd	s6,0(sp)
ffffffffc0202b14:	0016f793          	andi	a5,a3,1
ffffffffc0202b18:	892e                	mv	s2,a1
ffffffffc0202b1a:	8a32                	mv	s4,a2
ffffffffc0202b1c:	00094997          	auipc	s3,0x94
ffffffffc0202b20:	d8498993          	addi	s3,s3,-636 # ffffffffc02968a0 <npage>
ffffffffc0202b24:	efbd                	bnez	a5,ffffffffc0202ba2 <get_pte+0xb0>
ffffffffc0202b26:	14060c63          	beqz	a2,ffffffffc0202c7e <get_pte+0x18c>
ffffffffc0202b2a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b2e:	8b89                	andi	a5,a5,2
ffffffffc0202b30:	14079963          	bnez	a5,ffffffffc0202c82 <get_pte+0x190>
ffffffffc0202b34:	00094797          	auipc	a5,0x94
ffffffffc0202b38:	d7c7b783          	ld	a5,-644(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202b3c:	6f9c                	ld	a5,24(a5)
ffffffffc0202b3e:	4505                	li	a0,1
ffffffffc0202b40:	9782                	jalr	a5
ffffffffc0202b42:	842a                	mv	s0,a0
ffffffffc0202b44:	12040d63          	beqz	s0,ffffffffc0202c7e <get_pte+0x18c>
ffffffffc0202b48:	00094b17          	auipc	s6,0x94
ffffffffc0202b4c:	d60b0b13          	addi	s6,s6,-672 # ffffffffc02968a8 <pages>
ffffffffc0202b50:	000b3503          	ld	a0,0(s6)
ffffffffc0202b54:	00080ab7          	lui	s5,0x80
ffffffffc0202b58:	00094997          	auipc	s3,0x94
ffffffffc0202b5c:	d4898993          	addi	s3,s3,-696 # ffffffffc02968a0 <npage>
ffffffffc0202b60:	40a40533          	sub	a0,s0,a0
ffffffffc0202b64:	8519                	srai	a0,a0,0x6
ffffffffc0202b66:	9556                	add	a0,a0,s5
ffffffffc0202b68:	0009b703          	ld	a4,0(s3)
ffffffffc0202b6c:	00c51793          	slli	a5,a0,0xc
ffffffffc0202b70:	4685                	li	a3,1
ffffffffc0202b72:	c014                	sw	a3,0(s0)
ffffffffc0202b74:	83b1                	srli	a5,a5,0xc
ffffffffc0202b76:	0532                	slli	a0,a0,0xc
ffffffffc0202b78:	16e7f763          	bgeu	a5,a4,ffffffffc0202ce6 <get_pte+0x1f4>
ffffffffc0202b7c:	00094797          	auipc	a5,0x94
ffffffffc0202b80:	d3c7b783          	ld	a5,-708(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202b84:	6605                	lui	a2,0x1
ffffffffc0202b86:	4581                	li	a1,0
ffffffffc0202b88:	953e                	add	a0,a0,a5
ffffffffc0202b8a:	694080ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0202b8e:	000b3683          	ld	a3,0(s6)
ffffffffc0202b92:	40d406b3          	sub	a3,s0,a3
ffffffffc0202b96:	8699                	srai	a3,a3,0x6
ffffffffc0202b98:	96d6                	add	a3,a3,s5
ffffffffc0202b9a:	06aa                	slli	a3,a3,0xa
ffffffffc0202b9c:	0116e693          	ori	a3,a3,17
ffffffffc0202ba0:	e094                	sd	a3,0(s1)
ffffffffc0202ba2:	77fd                	lui	a5,0xfffff
ffffffffc0202ba4:	068a                	slli	a3,a3,0x2
ffffffffc0202ba6:	0009b703          	ld	a4,0(s3)
ffffffffc0202baa:	8efd                	and	a3,a3,a5
ffffffffc0202bac:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202bb0:	10e7ff63          	bgeu	a5,a4,ffffffffc0202cce <get_pte+0x1dc>
ffffffffc0202bb4:	00094a97          	auipc	s5,0x94
ffffffffc0202bb8:	d04a8a93          	addi	s5,s5,-764 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202bbc:	000ab403          	ld	s0,0(s5)
ffffffffc0202bc0:	01595793          	srli	a5,s2,0x15
ffffffffc0202bc4:	1ff7f793          	andi	a5,a5,511
ffffffffc0202bc8:	96a2                	add	a3,a3,s0
ffffffffc0202bca:	00379413          	slli	s0,a5,0x3
ffffffffc0202bce:	9436                	add	s0,s0,a3
ffffffffc0202bd0:	6014                	ld	a3,0(s0)
ffffffffc0202bd2:	0016f793          	andi	a5,a3,1
ffffffffc0202bd6:	ebad                	bnez	a5,ffffffffc0202c48 <get_pte+0x156>
ffffffffc0202bd8:	0a0a0363          	beqz	s4,ffffffffc0202c7e <get_pte+0x18c>
ffffffffc0202bdc:	100027f3          	csrr	a5,sstatus
ffffffffc0202be0:	8b89                	andi	a5,a5,2
ffffffffc0202be2:	efcd                	bnez	a5,ffffffffc0202c9c <get_pte+0x1aa>
ffffffffc0202be4:	00094797          	auipc	a5,0x94
ffffffffc0202be8:	ccc7b783          	ld	a5,-820(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202bec:	6f9c                	ld	a5,24(a5)
ffffffffc0202bee:	4505                	li	a0,1
ffffffffc0202bf0:	9782                	jalr	a5
ffffffffc0202bf2:	84aa                	mv	s1,a0
ffffffffc0202bf4:	c4c9                	beqz	s1,ffffffffc0202c7e <get_pte+0x18c>
ffffffffc0202bf6:	00094b17          	auipc	s6,0x94
ffffffffc0202bfa:	cb2b0b13          	addi	s6,s6,-846 # ffffffffc02968a8 <pages>
ffffffffc0202bfe:	000b3503          	ld	a0,0(s6)
ffffffffc0202c02:	00080a37          	lui	s4,0x80
ffffffffc0202c06:	0009b703          	ld	a4,0(s3)
ffffffffc0202c0a:	40a48533          	sub	a0,s1,a0
ffffffffc0202c0e:	8519                	srai	a0,a0,0x6
ffffffffc0202c10:	9552                	add	a0,a0,s4
ffffffffc0202c12:	00c51793          	slli	a5,a0,0xc
ffffffffc0202c16:	4685                	li	a3,1
ffffffffc0202c18:	c094                	sw	a3,0(s1)
ffffffffc0202c1a:	83b1                	srli	a5,a5,0xc
ffffffffc0202c1c:	0532                	slli	a0,a0,0xc
ffffffffc0202c1e:	0ee7f163          	bgeu	a5,a4,ffffffffc0202d00 <get_pte+0x20e>
ffffffffc0202c22:	000ab783          	ld	a5,0(s5)
ffffffffc0202c26:	6605                	lui	a2,0x1
ffffffffc0202c28:	4581                	li	a1,0
ffffffffc0202c2a:	953e                	add	a0,a0,a5
ffffffffc0202c2c:	5f2080ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0202c30:	000b3683          	ld	a3,0(s6)
ffffffffc0202c34:	40d486b3          	sub	a3,s1,a3
ffffffffc0202c38:	8699                	srai	a3,a3,0x6
ffffffffc0202c3a:	96d2                	add	a3,a3,s4
ffffffffc0202c3c:	06aa                	slli	a3,a3,0xa
ffffffffc0202c3e:	0116e693          	ori	a3,a3,17
ffffffffc0202c42:	e014                	sd	a3,0(s0)
ffffffffc0202c44:	0009b703          	ld	a4,0(s3)
ffffffffc0202c48:	068a                	slli	a3,a3,0x2
ffffffffc0202c4a:	757d                	lui	a0,0xfffff
ffffffffc0202c4c:	8ee9                	and	a3,a3,a0
ffffffffc0202c4e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202c52:	06e7f263          	bgeu	a5,a4,ffffffffc0202cb6 <get_pte+0x1c4>
ffffffffc0202c56:	000ab503          	ld	a0,0(s5)
ffffffffc0202c5a:	00c95913          	srli	s2,s2,0xc
ffffffffc0202c5e:	1ff97913          	andi	s2,s2,511
ffffffffc0202c62:	96aa                	add	a3,a3,a0
ffffffffc0202c64:	00391513          	slli	a0,s2,0x3
ffffffffc0202c68:	9536                	add	a0,a0,a3
ffffffffc0202c6a:	70e2                	ld	ra,56(sp)
ffffffffc0202c6c:	7442                	ld	s0,48(sp)
ffffffffc0202c6e:	74a2                	ld	s1,40(sp)
ffffffffc0202c70:	7902                	ld	s2,32(sp)
ffffffffc0202c72:	69e2                	ld	s3,24(sp)
ffffffffc0202c74:	6a42                	ld	s4,16(sp)
ffffffffc0202c76:	6aa2                	ld	s5,8(sp)
ffffffffc0202c78:	6b02                	ld	s6,0(sp)
ffffffffc0202c7a:	6121                	addi	sp,sp,64
ffffffffc0202c7c:	8082                	ret
ffffffffc0202c7e:	4501                	li	a0,0
ffffffffc0202c80:	b7ed                	j	ffffffffc0202c6a <get_pte+0x178>
ffffffffc0202c82:	91efe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202c86:	00094797          	auipc	a5,0x94
ffffffffc0202c8a:	c2a7b783          	ld	a5,-982(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202c8e:	6f9c                	ld	a5,24(a5)
ffffffffc0202c90:	4505                	li	a0,1
ffffffffc0202c92:	9782                	jalr	a5
ffffffffc0202c94:	842a                	mv	s0,a0
ffffffffc0202c96:	904fe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202c9a:	b56d                	j	ffffffffc0202b44 <get_pte+0x52>
ffffffffc0202c9c:	904fe0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202ca0:	00094797          	auipc	a5,0x94
ffffffffc0202ca4:	c107b783          	ld	a5,-1008(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202ca8:	6f9c                	ld	a5,24(a5)
ffffffffc0202caa:	4505                	li	a0,1
ffffffffc0202cac:	9782                	jalr	a5
ffffffffc0202cae:	84aa                	mv	s1,a0
ffffffffc0202cb0:	8eafe0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202cb4:	b781                	j	ffffffffc0202bf4 <get_pte+0x102>
ffffffffc0202cb6:	0000a617          	auipc	a2,0xa
ffffffffc0202cba:	8da60613          	addi	a2,a2,-1830 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0202cbe:	13300593          	li	a1,307
ffffffffc0202cc2:	0000a517          	auipc	a0,0xa
ffffffffc0202cc6:	dc650513          	addi	a0,a0,-570 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202cca:	d64fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202cce:	0000a617          	auipc	a2,0xa
ffffffffc0202cd2:	8c260613          	addi	a2,a2,-1854 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0202cd6:	12600593          	li	a1,294
ffffffffc0202cda:	0000a517          	auipc	a0,0xa
ffffffffc0202cde:	dae50513          	addi	a0,a0,-594 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202ce2:	d4cfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202ce6:	86aa                	mv	a3,a0
ffffffffc0202ce8:	0000a617          	auipc	a2,0xa
ffffffffc0202cec:	8a860613          	addi	a2,a2,-1880 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0202cf0:	12200593          	li	a1,290
ffffffffc0202cf4:	0000a517          	auipc	a0,0xa
ffffffffc0202cf8:	d9450513          	addi	a0,a0,-620 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202cfc:	d32fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202d00:	86aa                	mv	a3,a0
ffffffffc0202d02:	0000a617          	auipc	a2,0xa
ffffffffc0202d06:	88e60613          	addi	a2,a2,-1906 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0202d0a:	13000593          	li	a1,304
ffffffffc0202d0e:	0000a517          	auipc	a0,0xa
ffffffffc0202d12:	d7a50513          	addi	a0,a0,-646 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202d16:	d18fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202d1a <boot_map_segment>:
ffffffffc0202d1a:	6785                	lui	a5,0x1
ffffffffc0202d1c:	7139                	addi	sp,sp,-64
ffffffffc0202d1e:	00d5c833          	xor	a6,a1,a3
ffffffffc0202d22:	17fd                	addi	a5,a5,-1
ffffffffc0202d24:	fc06                	sd	ra,56(sp)
ffffffffc0202d26:	f822                	sd	s0,48(sp)
ffffffffc0202d28:	f426                	sd	s1,40(sp)
ffffffffc0202d2a:	f04a                	sd	s2,32(sp)
ffffffffc0202d2c:	ec4e                	sd	s3,24(sp)
ffffffffc0202d2e:	e852                	sd	s4,16(sp)
ffffffffc0202d30:	e456                	sd	s5,8(sp)
ffffffffc0202d32:	00f87833          	and	a6,a6,a5
ffffffffc0202d36:	08081563          	bnez	a6,ffffffffc0202dc0 <boot_map_segment+0xa6>
ffffffffc0202d3a:	00f5f4b3          	and	s1,a1,a5
ffffffffc0202d3e:	963e                	add	a2,a2,a5
ffffffffc0202d40:	94b2                	add	s1,s1,a2
ffffffffc0202d42:	797d                	lui	s2,0xfffff
ffffffffc0202d44:	80b1                	srli	s1,s1,0xc
ffffffffc0202d46:	0125f5b3          	and	a1,a1,s2
ffffffffc0202d4a:	0126f6b3          	and	a3,a3,s2
ffffffffc0202d4e:	c0a1                	beqz	s1,ffffffffc0202d8e <boot_map_segment+0x74>
ffffffffc0202d50:	00176713          	ori	a4,a4,1
ffffffffc0202d54:	04b2                	slli	s1,s1,0xc
ffffffffc0202d56:	02071993          	slli	s3,a4,0x20
ffffffffc0202d5a:	8a2a                	mv	s4,a0
ffffffffc0202d5c:	842e                	mv	s0,a1
ffffffffc0202d5e:	94ae                	add	s1,s1,a1
ffffffffc0202d60:	40b68933          	sub	s2,a3,a1
ffffffffc0202d64:	0209d993          	srli	s3,s3,0x20
ffffffffc0202d68:	6a85                	lui	s5,0x1
ffffffffc0202d6a:	4605                	li	a2,1
ffffffffc0202d6c:	85a2                	mv	a1,s0
ffffffffc0202d6e:	8552                	mv	a0,s4
ffffffffc0202d70:	d83ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc0202d74:	008907b3          	add	a5,s2,s0
ffffffffc0202d78:	c505                	beqz	a0,ffffffffc0202da0 <boot_map_segment+0x86>
ffffffffc0202d7a:	83b1                	srli	a5,a5,0xc
ffffffffc0202d7c:	07aa                	slli	a5,a5,0xa
ffffffffc0202d7e:	0137e7b3          	or	a5,a5,s3
ffffffffc0202d82:	0017e793          	ori	a5,a5,1
ffffffffc0202d86:	e11c                	sd	a5,0(a0)
ffffffffc0202d88:	9456                	add	s0,s0,s5
ffffffffc0202d8a:	fe8490e3          	bne	s1,s0,ffffffffc0202d6a <boot_map_segment+0x50>
ffffffffc0202d8e:	70e2                	ld	ra,56(sp)
ffffffffc0202d90:	7442                	ld	s0,48(sp)
ffffffffc0202d92:	74a2                	ld	s1,40(sp)
ffffffffc0202d94:	7902                	ld	s2,32(sp)
ffffffffc0202d96:	69e2                	ld	s3,24(sp)
ffffffffc0202d98:	6a42                	ld	s4,16(sp)
ffffffffc0202d9a:	6aa2                	ld	s5,8(sp)
ffffffffc0202d9c:	6121                	addi	sp,sp,64
ffffffffc0202d9e:	8082                	ret
ffffffffc0202da0:	0000a697          	auipc	a3,0xa
ffffffffc0202da4:	d1068693          	addi	a3,a3,-752 # ffffffffc020cab0 <default_pmm_manager+0x88>
ffffffffc0202da8:	00009617          	auipc	a2,0x9
ffffffffc0202dac:	e7060613          	addi	a2,a2,-400 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202db0:	09d00593          	li	a1,157
ffffffffc0202db4:	0000a517          	auipc	a0,0xa
ffffffffc0202db8:	cd450513          	addi	a0,a0,-812 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202dbc:	c72fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202dc0:	0000a697          	auipc	a3,0xa
ffffffffc0202dc4:	cd868693          	addi	a3,a3,-808 # ffffffffc020ca98 <default_pmm_manager+0x70>
ffffffffc0202dc8:	00009617          	auipc	a2,0x9
ffffffffc0202dcc:	e5060613          	addi	a2,a2,-432 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202dd0:	09600593          	li	a1,150
ffffffffc0202dd4:	0000a517          	auipc	a0,0xa
ffffffffc0202dd8:	cb450513          	addi	a0,a0,-844 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202ddc:	c52fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202de0 <get_page>:
ffffffffc0202de0:	1141                	addi	sp,sp,-16
ffffffffc0202de2:	e022                	sd	s0,0(sp)
ffffffffc0202de4:	8432                	mv	s0,a2
ffffffffc0202de6:	4601                	li	a2,0
ffffffffc0202de8:	e406                	sd	ra,8(sp)
ffffffffc0202dea:	d09ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc0202dee:	c011                	beqz	s0,ffffffffc0202df2 <get_page+0x12>
ffffffffc0202df0:	e008                	sd	a0,0(s0)
ffffffffc0202df2:	c511                	beqz	a0,ffffffffc0202dfe <get_page+0x1e>
ffffffffc0202df4:	611c                	ld	a5,0(a0)
ffffffffc0202df6:	4501                	li	a0,0
ffffffffc0202df8:	0017f713          	andi	a4,a5,1
ffffffffc0202dfc:	e709                	bnez	a4,ffffffffc0202e06 <get_page+0x26>
ffffffffc0202dfe:	60a2                	ld	ra,8(sp)
ffffffffc0202e00:	6402                	ld	s0,0(sp)
ffffffffc0202e02:	0141                	addi	sp,sp,16
ffffffffc0202e04:	8082                	ret
ffffffffc0202e06:	078a                	slli	a5,a5,0x2
ffffffffc0202e08:	83b1                	srli	a5,a5,0xc
ffffffffc0202e0a:	00094717          	auipc	a4,0x94
ffffffffc0202e0e:	a9673703          	ld	a4,-1386(a4) # ffffffffc02968a0 <npage>
ffffffffc0202e12:	00e7ff63          	bgeu	a5,a4,ffffffffc0202e30 <get_page+0x50>
ffffffffc0202e16:	60a2                	ld	ra,8(sp)
ffffffffc0202e18:	6402                	ld	s0,0(sp)
ffffffffc0202e1a:	fff80537          	lui	a0,0xfff80
ffffffffc0202e1e:	97aa                	add	a5,a5,a0
ffffffffc0202e20:	079a                	slli	a5,a5,0x6
ffffffffc0202e22:	00094517          	auipc	a0,0x94
ffffffffc0202e26:	a8653503          	ld	a0,-1402(a0) # ffffffffc02968a8 <pages>
ffffffffc0202e2a:	953e                	add	a0,a0,a5
ffffffffc0202e2c:	0141                	addi	sp,sp,16
ffffffffc0202e2e:	8082                	ret
ffffffffc0202e30:	bd3ff0ef          	jal	ra,ffffffffc0202a02 <pa2page.part.0>

ffffffffc0202e34 <unmap_range>:
ffffffffc0202e34:	7159                	addi	sp,sp,-112
ffffffffc0202e36:	00c5e7b3          	or	a5,a1,a2
ffffffffc0202e3a:	f486                	sd	ra,104(sp)
ffffffffc0202e3c:	f0a2                	sd	s0,96(sp)
ffffffffc0202e3e:	eca6                	sd	s1,88(sp)
ffffffffc0202e40:	e8ca                	sd	s2,80(sp)
ffffffffc0202e42:	e4ce                	sd	s3,72(sp)
ffffffffc0202e44:	e0d2                	sd	s4,64(sp)
ffffffffc0202e46:	fc56                	sd	s5,56(sp)
ffffffffc0202e48:	f85a                	sd	s6,48(sp)
ffffffffc0202e4a:	f45e                	sd	s7,40(sp)
ffffffffc0202e4c:	f062                	sd	s8,32(sp)
ffffffffc0202e4e:	ec66                	sd	s9,24(sp)
ffffffffc0202e50:	e86a                	sd	s10,16(sp)
ffffffffc0202e52:	17d2                	slli	a5,a5,0x34
ffffffffc0202e54:	e3ed                	bnez	a5,ffffffffc0202f36 <unmap_range+0x102>
ffffffffc0202e56:	002007b7          	lui	a5,0x200
ffffffffc0202e5a:	842e                	mv	s0,a1
ffffffffc0202e5c:	0ef5ed63          	bltu	a1,a5,ffffffffc0202f56 <unmap_range+0x122>
ffffffffc0202e60:	8932                	mv	s2,a2
ffffffffc0202e62:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202f56 <unmap_range+0x122>
ffffffffc0202e66:	4785                	li	a5,1
ffffffffc0202e68:	07fe                	slli	a5,a5,0x1f
ffffffffc0202e6a:	0ec7e663          	bltu	a5,a2,ffffffffc0202f56 <unmap_range+0x122>
ffffffffc0202e6e:	89aa                	mv	s3,a0
ffffffffc0202e70:	6a05                	lui	s4,0x1
ffffffffc0202e72:	00094c97          	auipc	s9,0x94
ffffffffc0202e76:	a2ec8c93          	addi	s9,s9,-1490 # ffffffffc02968a0 <npage>
ffffffffc0202e7a:	00094c17          	auipc	s8,0x94
ffffffffc0202e7e:	a2ec0c13          	addi	s8,s8,-1490 # ffffffffc02968a8 <pages>
ffffffffc0202e82:	fff80bb7          	lui	s7,0xfff80
ffffffffc0202e86:	00094d17          	auipc	s10,0x94
ffffffffc0202e8a:	a2ad0d13          	addi	s10,s10,-1494 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202e8e:	00200b37          	lui	s6,0x200
ffffffffc0202e92:	ffe00ab7          	lui	s5,0xffe00
ffffffffc0202e96:	4601                	li	a2,0
ffffffffc0202e98:	85a2                	mv	a1,s0
ffffffffc0202e9a:	854e                	mv	a0,s3
ffffffffc0202e9c:	c57ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc0202ea0:	84aa                	mv	s1,a0
ffffffffc0202ea2:	cd29                	beqz	a0,ffffffffc0202efc <unmap_range+0xc8>
ffffffffc0202ea4:	611c                	ld	a5,0(a0)
ffffffffc0202ea6:	e395                	bnez	a5,ffffffffc0202eca <unmap_range+0x96>
ffffffffc0202ea8:	9452                	add	s0,s0,s4
ffffffffc0202eaa:	ff2466e3          	bltu	s0,s2,ffffffffc0202e96 <unmap_range+0x62>
ffffffffc0202eae:	70a6                	ld	ra,104(sp)
ffffffffc0202eb0:	7406                	ld	s0,96(sp)
ffffffffc0202eb2:	64e6                	ld	s1,88(sp)
ffffffffc0202eb4:	6946                	ld	s2,80(sp)
ffffffffc0202eb6:	69a6                	ld	s3,72(sp)
ffffffffc0202eb8:	6a06                	ld	s4,64(sp)
ffffffffc0202eba:	7ae2                	ld	s5,56(sp)
ffffffffc0202ebc:	7b42                	ld	s6,48(sp)
ffffffffc0202ebe:	7ba2                	ld	s7,40(sp)
ffffffffc0202ec0:	7c02                	ld	s8,32(sp)
ffffffffc0202ec2:	6ce2                	ld	s9,24(sp)
ffffffffc0202ec4:	6d42                	ld	s10,16(sp)
ffffffffc0202ec6:	6165                	addi	sp,sp,112
ffffffffc0202ec8:	8082                	ret
ffffffffc0202eca:	0017f713          	andi	a4,a5,1
ffffffffc0202ece:	df69                	beqz	a4,ffffffffc0202ea8 <unmap_range+0x74>
ffffffffc0202ed0:	000cb703          	ld	a4,0(s9)
ffffffffc0202ed4:	078a                	slli	a5,a5,0x2
ffffffffc0202ed6:	83b1                	srli	a5,a5,0xc
ffffffffc0202ed8:	08e7ff63          	bgeu	a5,a4,ffffffffc0202f76 <unmap_range+0x142>
ffffffffc0202edc:	000c3503          	ld	a0,0(s8)
ffffffffc0202ee0:	97de                	add	a5,a5,s7
ffffffffc0202ee2:	079a                	slli	a5,a5,0x6
ffffffffc0202ee4:	953e                	add	a0,a0,a5
ffffffffc0202ee6:	411c                	lw	a5,0(a0)
ffffffffc0202ee8:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202eec:	c118                	sw	a4,0(a0)
ffffffffc0202eee:	cf11                	beqz	a4,ffffffffc0202f0a <unmap_range+0xd6>
ffffffffc0202ef0:	0004b023          	sd	zero,0(s1)
ffffffffc0202ef4:	12040073          	sfence.vma	s0
ffffffffc0202ef8:	9452                	add	s0,s0,s4
ffffffffc0202efa:	bf45                	j	ffffffffc0202eaa <unmap_range+0x76>
ffffffffc0202efc:	945a                	add	s0,s0,s6
ffffffffc0202efe:	01547433          	and	s0,s0,s5
ffffffffc0202f02:	d455                	beqz	s0,ffffffffc0202eae <unmap_range+0x7a>
ffffffffc0202f04:	f92469e3          	bltu	s0,s2,ffffffffc0202e96 <unmap_range+0x62>
ffffffffc0202f08:	b75d                	j	ffffffffc0202eae <unmap_range+0x7a>
ffffffffc0202f0a:	100027f3          	csrr	a5,sstatus
ffffffffc0202f0e:	8b89                	andi	a5,a5,2
ffffffffc0202f10:	e799                	bnez	a5,ffffffffc0202f1e <unmap_range+0xea>
ffffffffc0202f12:	000d3783          	ld	a5,0(s10)
ffffffffc0202f16:	4585                	li	a1,1
ffffffffc0202f18:	739c                	ld	a5,32(a5)
ffffffffc0202f1a:	9782                	jalr	a5
ffffffffc0202f1c:	bfd1                	j	ffffffffc0202ef0 <unmap_range+0xbc>
ffffffffc0202f1e:	e42a                	sd	a0,8(sp)
ffffffffc0202f20:	e81fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0202f24:	000d3783          	ld	a5,0(s10)
ffffffffc0202f28:	6522                	ld	a0,8(sp)
ffffffffc0202f2a:	4585                	li	a1,1
ffffffffc0202f2c:	739c                	ld	a5,32(a5)
ffffffffc0202f2e:	9782                	jalr	a5
ffffffffc0202f30:	e6bfd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0202f34:	bf75                	j	ffffffffc0202ef0 <unmap_range+0xbc>
ffffffffc0202f36:	0000a697          	auipc	a3,0xa
ffffffffc0202f3a:	b8a68693          	addi	a3,a3,-1142 # ffffffffc020cac0 <default_pmm_manager+0x98>
ffffffffc0202f3e:	00009617          	auipc	a2,0x9
ffffffffc0202f42:	cda60613          	addi	a2,a2,-806 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202f46:	15b00593          	li	a1,347
ffffffffc0202f4a:	0000a517          	auipc	a0,0xa
ffffffffc0202f4e:	b3e50513          	addi	a0,a0,-1218 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202f52:	adcfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202f56:	0000a697          	auipc	a3,0xa
ffffffffc0202f5a:	b9a68693          	addi	a3,a3,-1126 # ffffffffc020caf0 <default_pmm_manager+0xc8>
ffffffffc0202f5e:	00009617          	auipc	a2,0x9
ffffffffc0202f62:	cba60613          	addi	a2,a2,-838 # ffffffffc020bc18 <commands+0x250>
ffffffffc0202f66:	15c00593          	li	a1,348
ffffffffc0202f6a:	0000a517          	auipc	a0,0xa
ffffffffc0202f6e:	b1e50513          	addi	a0,a0,-1250 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0202f72:	abcfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202f76:	a8dff0ef          	jal	ra,ffffffffc0202a02 <pa2page.part.0>

ffffffffc0202f7a <exit_range>:
ffffffffc0202f7a:	7119                	addi	sp,sp,-128
ffffffffc0202f7c:	00c5e7b3          	or	a5,a1,a2
ffffffffc0202f80:	fc86                	sd	ra,120(sp)
ffffffffc0202f82:	f8a2                	sd	s0,112(sp)
ffffffffc0202f84:	f4a6                	sd	s1,104(sp)
ffffffffc0202f86:	f0ca                	sd	s2,96(sp)
ffffffffc0202f88:	ecce                	sd	s3,88(sp)
ffffffffc0202f8a:	e8d2                	sd	s4,80(sp)
ffffffffc0202f8c:	e4d6                	sd	s5,72(sp)
ffffffffc0202f8e:	e0da                	sd	s6,64(sp)
ffffffffc0202f90:	fc5e                	sd	s7,56(sp)
ffffffffc0202f92:	f862                	sd	s8,48(sp)
ffffffffc0202f94:	f466                	sd	s9,40(sp)
ffffffffc0202f96:	f06a                	sd	s10,32(sp)
ffffffffc0202f98:	ec6e                	sd	s11,24(sp)
ffffffffc0202f9a:	17d2                	slli	a5,a5,0x34
ffffffffc0202f9c:	20079a63          	bnez	a5,ffffffffc02031b0 <exit_range+0x236>
ffffffffc0202fa0:	002007b7          	lui	a5,0x200
ffffffffc0202fa4:	24f5e463          	bltu	a1,a5,ffffffffc02031ec <exit_range+0x272>
ffffffffc0202fa8:	8ab2                	mv	s5,a2
ffffffffc0202faa:	24c5f163          	bgeu	a1,a2,ffffffffc02031ec <exit_range+0x272>
ffffffffc0202fae:	4785                	li	a5,1
ffffffffc0202fb0:	07fe                	slli	a5,a5,0x1f
ffffffffc0202fb2:	22c7ed63          	bltu	a5,a2,ffffffffc02031ec <exit_range+0x272>
ffffffffc0202fb6:	c00009b7          	lui	s3,0xc0000
ffffffffc0202fba:	0135f9b3          	and	s3,a1,s3
ffffffffc0202fbe:	ffe00937          	lui	s2,0xffe00
ffffffffc0202fc2:	400007b7          	lui	a5,0x40000
ffffffffc0202fc6:	5cfd                	li	s9,-1
ffffffffc0202fc8:	8c2a                	mv	s8,a0
ffffffffc0202fca:	0125f933          	and	s2,a1,s2
ffffffffc0202fce:	99be                	add	s3,s3,a5
ffffffffc0202fd0:	00094d17          	auipc	s10,0x94
ffffffffc0202fd4:	8d0d0d13          	addi	s10,s10,-1840 # ffffffffc02968a0 <npage>
ffffffffc0202fd8:	00ccdc93          	srli	s9,s9,0xc
ffffffffc0202fdc:	00094717          	auipc	a4,0x94
ffffffffc0202fe0:	8cc70713          	addi	a4,a4,-1844 # ffffffffc02968a8 <pages>
ffffffffc0202fe4:	00094d97          	auipc	s11,0x94
ffffffffc0202fe8:	8ccd8d93          	addi	s11,s11,-1844 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202fec:	c0000437          	lui	s0,0xc0000
ffffffffc0202ff0:	944e                	add	s0,s0,s3
ffffffffc0202ff2:	8079                	srli	s0,s0,0x1e
ffffffffc0202ff4:	1ff47413          	andi	s0,s0,511
ffffffffc0202ff8:	040e                	slli	s0,s0,0x3
ffffffffc0202ffa:	9462                	add	s0,s0,s8
ffffffffc0202ffc:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0203000:	001a7793          	andi	a5,s4,1
ffffffffc0203004:	eb99                	bnez	a5,ffffffffc020301a <exit_range+0xa0>
ffffffffc0203006:	12098463          	beqz	s3,ffffffffc020312e <exit_range+0x1b4>
ffffffffc020300a:	400007b7          	lui	a5,0x40000
ffffffffc020300e:	97ce                	add	a5,a5,s3
ffffffffc0203010:	894e                	mv	s2,s3
ffffffffc0203012:	1159fe63          	bgeu	s3,s5,ffffffffc020312e <exit_range+0x1b4>
ffffffffc0203016:	89be                	mv	s3,a5
ffffffffc0203018:	bfd1                	j	ffffffffc0202fec <exit_range+0x72>
ffffffffc020301a:	000d3783          	ld	a5,0(s10)
ffffffffc020301e:	0a0a                	slli	s4,s4,0x2
ffffffffc0203020:	00ca5a13          	srli	s4,s4,0xc
ffffffffc0203024:	1cfa7263          	bgeu	s4,a5,ffffffffc02031e8 <exit_range+0x26e>
ffffffffc0203028:	fff80637          	lui	a2,0xfff80
ffffffffc020302c:	9652                	add	a2,a2,s4
ffffffffc020302e:	000806b7          	lui	a3,0x80
ffffffffc0203032:	96b2                	add	a3,a3,a2
ffffffffc0203034:	0196f5b3          	and	a1,a3,s9
ffffffffc0203038:	061a                	slli	a2,a2,0x6
ffffffffc020303a:	06b2                	slli	a3,a3,0xc
ffffffffc020303c:	18f5fa63          	bgeu	a1,a5,ffffffffc02031d0 <exit_range+0x256>
ffffffffc0203040:	00094817          	auipc	a6,0x94
ffffffffc0203044:	87880813          	addi	a6,a6,-1928 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0203048:	00083b03          	ld	s6,0(a6)
ffffffffc020304c:	4b85                	li	s7,1
ffffffffc020304e:	fff80e37          	lui	t3,0xfff80
ffffffffc0203052:	9b36                	add	s6,s6,a3
ffffffffc0203054:	00080337          	lui	t1,0x80
ffffffffc0203058:	6885                	lui	a7,0x1
ffffffffc020305a:	a819                	j	ffffffffc0203070 <exit_range+0xf6>
ffffffffc020305c:	4b81                	li	s7,0
ffffffffc020305e:	002007b7          	lui	a5,0x200
ffffffffc0203062:	993e                	add	s2,s2,a5
ffffffffc0203064:	08090c63          	beqz	s2,ffffffffc02030fc <exit_range+0x182>
ffffffffc0203068:	09397a63          	bgeu	s2,s3,ffffffffc02030fc <exit_range+0x182>
ffffffffc020306c:	0f597063          	bgeu	s2,s5,ffffffffc020314c <exit_range+0x1d2>
ffffffffc0203070:	01595493          	srli	s1,s2,0x15
ffffffffc0203074:	1ff4f493          	andi	s1,s1,511
ffffffffc0203078:	048e                	slli	s1,s1,0x3
ffffffffc020307a:	94da                	add	s1,s1,s6
ffffffffc020307c:	609c                	ld	a5,0(s1)
ffffffffc020307e:	0017f693          	andi	a3,a5,1
ffffffffc0203082:	dee9                	beqz	a3,ffffffffc020305c <exit_range+0xe2>
ffffffffc0203084:	000d3583          	ld	a1,0(s10)
ffffffffc0203088:	078a                	slli	a5,a5,0x2
ffffffffc020308a:	83b1                	srli	a5,a5,0xc
ffffffffc020308c:	14b7fe63          	bgeu	a5,a1,ffffffffc02031e8 <exit_range+0x26e>
ffffffffc0203090:	97f2                	add	a5,a5,t3
ffffffffc0203092:	006786b3          	add	a3,a5,t1
ffffffffc0203096:	0196feb3          	and	t4,a3,s9
ffffffffc020309a:	00679513          	slli	a0,a5,0x6
ffffffffc020309e:	06b2                	slli	a3,a3,0xc
ffffffffc02030a0:	12bef863          	bgeu	t4,a1,ffffffffc02031d0 <exit_range+0x256>
ffffffffc02030a4:	00083783          	ld	a5,0(a6)
ffffffffc02030a8:	96be                	add	a3,a3,a5
ffffffffc02030aa:	011685b3          	add	a1,a3,a7
ffffffffc02030ae:	629c                	ld	a5,0(a3)
ffffffffc02030b0:	8b85                	andi	a5,a5,1
ffffffffc02030b2:	f7d5                	bnez	a5,ffffffffc020305e <exit_range+0xe4>
ffffffffc02030b4:	06a1                	addi	a3,a3,8
ffffffffc02030b6:	fed59ce3          	bne	a1,a3,ffffffffc02030ae <exit_range+0x134>
ffffffffc02030ba:	631c                	ld	a5,0(a4)
ffffffffc02030bc:	953e                	add	a0,a0,a5
ffffffffc02030be:	100027f3          	csrr	a5,sstatus
ffffffffc02030c2:	8b89                	andi	a5,a5,2
ffffffffc02030c4:	e7d9                	bnez	a5,ffffffffc0203152 <exit_range+0x1d8>
ffffffffc02030c6:	000db783          	ld	a5,0(s11)
ffffffffc02030ca:	4585                	li	a1,1
ffffffffc02030cc:	e032                	sd	a2,0(sp)
ffffffffc02030ce:	739c                	ld	a5,32(a5)
ffffffffc02030d0:	9782                	jalr	a5
ffffffffc02030d2:	6602                	ld	a2,0(sp)
ffffffffc02030d4:	00093817          	auipc	a6,0x93
ffffffffc02030d8:	7e480813          	addi	a6,a6,2020 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02030dc:	fff80e37          	lui	t3,0xfff80
ffffffffc02030e0:	00080337          	lui	t1,0x80
ffffffffc02030e4:	6885                	lui	a7,0x1
ffffffffc02030e6:	00093717          	auipc	a4,0x93
ffffffffc02030ea:	7c270713          	addi	a4,a4,1986 # ffffffffc02968a8 <pages>
ffffffffc02030ee:	0004b023          	sd	zero,0(s1)
ffffffffc02030f2:	002007b7          	lui	a5,0x200
ffffffffc02030f6:	993e                	add	s2,s2,a5
ffffffffc02030f8:	f60918e3          	bnez	s2,ffffffffc0203068 <exit_range+0xee>
ffffffffc02030fc:	f00b85e3          	beqz	s7,ffffffffc0203006 <exit_range+0x8c>
ffffffffc0203100:	000d3783          	ld	a5,0(s10)
ffffffffc0203104:	0efa7263          	bgeu	s4,a5,ffffffffc02031e8 <exit_range+0x26e>
ffffffffc0203108:	6308                	ld	a0,0(a4)
ffffffffc020310a:	9532                	add	a0,a0,a2
ffffffffc020310c:	100027f3          	csrr	a5,sstatus
ffffffffc0203110:	8b89                	andi	a5,a5,2
ffffffffc0203112:	efad                	bnez	a5,ffffffffc020318c <exit_range+0x212>
ffffffffc0203114:	000db783          	ld	a5,0(s11)
ffffffffc0203118:	4585                	li	a1,1
ffffffffc020311a:	739c                	ld	a5,32(a5)
ffffffffc020311c:	9782                	jalr	a5
ffffffffc020311e:	00093717          	auipc	a4,0x93
ffffffffc0203122:	78a70713          	addi	a4,a4,1930 # ffffffffc02968a8 <pages>
ffffffffc0203126:	00043023          	sd	zero,0(s0)
ffffffffc020312a:	ee0990e3          	bnez	s3,ffffffffc020300a <exit_range+0x90>
ffffffffc020312e:	70e6                	ld	ra,120(sp)
ffffffffc0203130:	7446                	ld	s0,112(sp)
ffffffffc0203132:	74a6                	ld	s1,104(sp)
ffffffffc0203134:	7906                	ld	s2,96(sp)
ffffffffc0203136:	69e6                	ld	s3,88(sp)
ffffffffc0203138:	6a46                	ld	s4,80(sp)
ffffffffc020313a:	6aa6                	ld	s5,72(sp)
ffffffffc020313c:	6b06                	ld	s6,64(sp)
ffffffffc020313e:	7be2                	ld	s7,56(sp)
ffffffffc0203140:	7c42                	ld	s8,48(sp)
ffffffffc0203142:	7ca2                	ld	s9,40(sp)
ffffffffc0203144:	7d02                	ld	s10,32(sp)
ffffffffc0203146:	6de2                	ld	s11,24(sp)
ffffffffc0203148:	6109                	addi	sp,sp,128
ffffffffc020314a:	8082                	ret
ffffffffc020314c:	ea0b8fe3          	beqz	s7,ffffffffc020300a <exit_range+0x90>
ffffffffc0203150:	bf45                	j	ffffffffc0203100 <exit_range+0x186>
ffffffffc0203152:	e032                	sd	a2,0(sp)
ffffffffc0203154:	e42a                	sd	a0,8(sp)
ffffffffc0203156:	c4bfd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020315a:	000db783          	ld	a5,0(s11)
ffffffffc020315e:	6522                	ld	a0,8(sp)
ffffffffc0203160:	4585                	li	a1,1
ffffffffc0203162:	739c                	ld	a5,32(a5)
ffffffffc0203164:	9782                	jalr	a5
ffffffffc0203166:	c35fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020316a:	6602                	ld	a2,0(sp)
ffffffffc020316c:	00093717          	auipc	a4,0x93
ffffffffc0203170:	73c70713          	addi	a4,a4,1852 # ffffffffc02968a8 <pages>
ffffffffc0203174:	6885                	lui	a7,0x1
ffffffffc0203176:	00080337          	lui	t1,0x80
ffffffffc020317a:	fff80e37          	lui	t3,0xfff80
ffffffffc020317e:	00093817          	auipc	a6,0x93
ffffffffc0203182:	73a80813          	addi	a6,a6,1850 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0203186:	0004b023          	sd	zero,0(s1)
ffffffffc020318a:	b7a5                	j	ffffffffc02030f2 <exit_range+0x178>
ffffffffc020318c:	e02a                	sd	a0,0(sp)
ffffffffc020318e:	c13fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203192:	000db783          	ld	a5,0(s11)
ffffffffc0203196:	6502                	ld	a0,0(sp)
ffffffffc0203198:	4585                	li	a1,1
ffffffffc020319a:	739c                	ld	a5,32(a5)
ffffffffc020319c:	9782                	jalr	a5
ffffffffc020319e:	bfdfd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02031a2:	00093717          	auipc	a4,0x93
ffffffffc02031a6:	70670713          	addi	a4,a4,1798 # ffffffffc02968a8 <pages>
ffffffffc02031aa:	00043023          	sd	zero,0(s0)
ffffffffc02031ae:	bfb5                	j	ffffffffc020312a <exit_range+0x1b0>
ffffffffc02031b0:	0000a697          	auipc	a3,0xa
ffffffffc02031b4:	91068693          	addi	a3,a3,-1776 # ffffffffc020cac0 <default_pmm_manager+0x98>
ffffffffc02031b8:	00009617          	auipc	a2,0x9
ffffffffc02031bc:	a6060613          	addi	a2,a2,-1440 # ffffffffc020bc18 <commands+0x250>
ffffffffc02031c0:	17000593          	li	a1,368
ffffffffc02031c4:	0000a517          	auipc	a0,0xa
ffffffffc02031c8:	8c450513          	addi	a0,a0,-1852 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02031cc:	862fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02031d0:	00009617          	auipc	a2,0x9
ffffffffc02031d4:	3c060613          	addi	a2,a2,960 # ffffffffc020c590 <commands+0xbc8>
ffffffffc02031d8:	07100593          	li	a1,113
ffffffffc02031dc:	00009517          	auipc	a0,0x9
ffffffffc02031e0:	3dc50513          	addi	a0,a0,988 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc02031e4:	84afd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02031e8:	81bff0ef          	jal	ra,ffffffffc0202a02 <pa2page.part.0>
ffffffffc02031ec:	0000a697          	auipc	a3,0xa
ffffffffc02031f0:	90468693          	addi	a3,a3,-1788 # ffffffffc020caf0 <default_pmm_manager+0xc8>
ffffffffc02031f4:	00009617          	auipc	a2,0x9
ffffffffc02031f8:	a2460613          	addi	a2,a2,-1500 # ffffffffc020bc18 <commands+0x250>
ffffffffc02031fc:	17100593          	li	a1,369
ffffffffc0203200:	0000a517          	auipc	a0,0xa
ffffffffc0203204:	88850513          	addi	a0,a0,-1912 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203208:	826fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020320c <page_remove>:
ffffffffc020320c:	7179                	addi	sp,sp,-48
ffffffffc020320e:	4601                	li	a2,0
ffffffffc0203210:	ec26                	sd	s1,24(sp)
ffffffffc0203212:	f406                	sd	ra,40(sp)
ffffffffc0203214:	f022                	sd	s0,32(sp)
ffffffffc0203216:	84ae                	mv	s1,a1
ffffffffc0203218:	8dbff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc020321c:	c511                	beqz	a0,ffffffffc0203228 <page_remove+0x1c>
ffffffffc020321e:	611c                	ld	a5,0(a0)
ffffffffc0203220:	842a                	mv	s0,a0
ffffffffc0203222:	0017f713          	andi	a4,a5,1
ffffffffc0203226:	e711                	bnez	a4,ffffffffc0203232 <page_remove+0x26>
ffffffffc0203228:	70a2                	ld	ra,40(sp)
ffffffffc020322a:	7402                	ld	s0,32(sp)
ffffffffc020322c:	64e2                	ld	s1,24(sp)
ffffffffc020322e:	6145                	addi	sp,sp,48
ffffffffc0203230:	8082                	ret
ffffffffc0203232:	078a                	slli	a5,a5,0x2
ffffffffc0203234:	83b1                	srli	a5,a5,0xc
ffffffffc0203236:	00093717          	auipc	a4,0x93
ffffffffc020323a:	66a73703          	ld	a4,1642(a4) # ffffffffc02968a0 <npage>
ffffffffc020323e:	06e7f363          	bgeu	a5,a4,ffffffffc02032a4 <page_remove+0x98>
ffffffffc0203242:	fff80537          	lui	a0,0xfff80
ffffffffc0203246:	97aa                	add	a5,a5,a0
ffffffffc0203248:	079a                	slli	a5,a5,0x6
ffffffffc020324a:	00093517          	auipc	a0,0x93
ffffffffc020324e:	65e53503          	ld	a0,1630(a0) # ffffffffc02968a8 <pages>
ffffffffc0203252:	953e                	add	a0,a0,a5
ffffffffc0203254:	411c                	lw	a5,0(a0)
ffffffffc0203256:	fff7871b          	addiw	a4,a5,-1
ffffffffc020325a:	c118                	sw	a4,0(a0)
ffffffffc020325c:	cb11                	beqz	a4,ffffffffc0203270 <page_remove+0x64>
ffffffffc020325e:	00043023          	sd	zero,0(s0)
ffffffffc0203262:	12048073          	sfence.vma	s1
ffffffffc0203266:	70a2                	ld	ra,40(sp)
ffffffffc0203268:	7402                	ld	s0,32(sp)
ffffffffc020326a:	64e2                	ld	s1,24(sp)
ffffffffc020326c:	6145                	addi	sp,sp,48
ffffffffc020326e:	8082                	ret
ffffffffc0203270:	100027f3          	csrr	a5,sstatus
ffffffffc0203274:	8b89                	andi	a5,a5,2
ffffffffc0203276:	eb89                	bnez	a5,ffffffffc0203288 <page_remove+0x7c>
ffffffffc0203278:	00093797          	auipc	a5,0x93
ffffffffc020327c:	6387b783          	ld	a5,1592(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0203280:	739c                	ld	a5,32(a5)
ffffffffc0203282:	4585                	li	a1,1
ffffffffc0203284:	9782                	jalr	a5
ffffffffc0203286:	bfe1                	j	ffffffffc020325e <page_remove+0x52>
ffffffffc0203288:	e42a                	sd	a0,8(sp)
ffffffffc020328a:	b17fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020328e:	00093797          	auipc	a5,0x93
ffffffffc0203292:	6227b783          	ld	a5,1570(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0203296:	739c                	ld	a5,32(a5)
ffffffffc0203298:	6522                	ld	a0,8(sp)
ffffffffc020329a:	4585                	li	a1,1
ffffffffc020329c:	9782                	jalr	a5
ffffffffc020329e:	afdfd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02032a2:	bf75                	j	ffffffffc020325e <page_remove+0x52>
ffffffffc02032a4:	f5eff0ef          	jal	ra,ffffffffc0202a02 <pa2page.part.0>

ffffffffc02032a8 <page_insert>:
ffffffffc02032a8:	7139                	addi	sp,sp,-64
ffffffffc02032aa:	e852                	sd	s4,16(sp)
ffffffffc02032ac:	8a32                	mv	s4,a2
ffffffffc02032ae:	f822                	sd	s0,48(sp)
ffffffffc02032b0:	4605                	li	a2,1
ffffffffc02032b2:	842e                	mv	s0,a1
ffffffffc02032b4:	85d2                	mv	a1,s4
ffffffffc02032b6:	f426                	sd	s1,40(sp)
ffffffffc02032b8:	fc06                	sd	ra,56(sp)
ffffffffc02032ba:	f04a                	sd	s2,32(sp)
ffffffffc02032bc:	ec4e                	sd	s3,24(sp)
ffffffffc02032be:	e456                	sd	s5,8(sp)
ffffffffc02032c0:	84b6                	mv	s1,a3
ffffffffc02032c2:	831ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc02032c6:	c961                	beqz	a0,ffffffffc0203396 <page_insert+0xee>
ffffffffc02032c8:	4014                	lw	a3,0(s0)
ffffffffc02032ca:	611c                	ld	a5,0(a0)
ffffffffc02032cc:	89aa                	mv	s3,a0
ffffffffc02032ce:	0016871b          	addiw	a4,a3,1
ffffffffc02032d2:	c018                	sw	a4,0(s0)
ffffffffc02032d4:	0017f713          	andi	a4,a5,1
ffffffffc02032d8:	ef05                	bnez	a4,ffffffffc0203310 <page_insert+0x68>
ffffffffc02032da:	00093717          	auipc	a4,0x93
ffffffffc02032de:	5ce73703          	ld	a4,1486(a4) # ffffffffc02968a8 <pages>
ffffffffc02032e2:	8c19                	sub	s0,s0,a4
ffffffffc02032e4:	000807b7          	lui	a5,0x80
ffffffffc02032e8:	8419                	srai	s0,s0,0x6
ffffffffc02032ea:	943e                	add	s0,s0,a5
ffffffffc02032ec:	042a                	slli	s0,s0,0xa
ffffffffc02032ee:	8cc1                	or	s1,s1,s0
ffffffffc02032f0:	0014e493          	ori	s1,s1,1
ffffffffc02032f4:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc02032f8:	120a0073          	sfence.vma	s4
ffffffffc02032fc:	4501                	li	a0,0
ffffffffc02032fe:	70e2                	ld	ra,56(sp)
ffffffffc0203300:	7442                	ld	s0,48(sp)
ffffffffc0203302:	74a2                	ld	s1,40(sp)
ffffffffc0203304:	7902                	ld	s2,32(sp)
ffffffffc0203306:	69e2                	ld	s3,24(sp)
ffffffffc0203308:	6a42                	ld	s4,16(sp)
ffffffffc020330a:	6aa2                	ld	s5,8(sp)
ffffffffc020330c:	6121                	addi	sp,sp,64
ffffffffc020330e:	8082                	ret
ffffffffc0203310:	078a                	slli	a5,a5,0x2
ffffffffc0203312:	83b1                	srli	a5,a5,0xc
ffffffffc0203314:	00093717          	auipc	a4,0x93
ffffffffc0203318:	58c73703          	ld	a4,1420(a4) # ffffffffc02968a0 <npage>
ffffffffc020331c:	06e7ff63          	bgeu	a5,a4,ffffffffc020339a <page_insert+0xf2>
ffffffffc0203320:	00093a97          	auipc	s5,0x93
ffffffffc0203324:	588a8a93          	addi	s5,s5,1416 # ffffffffc02968a8 <pages>
ffffffffc0203328:	000ab703          	ld	a4,0(s5)
ffffffffc020332c:	fff80937          	lui	s2,0xfff80
ffffffffc0203330:	993e                	add	s2,s2,a5
ffffffffc0203332:	091a                	slli	s2,s2,0x6
ffffffffc0203334:	993a                	add	s2,s2,a4
ffffffffc0203336:	01240c63          	beq	s0,s2,ffffffffc020334e <page_insert+0xa6>
ffffffffc020333a:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc020333e:	fff7869b          	addiw	a3,a5,-1
ffffffffc0203342:	00d92023          	sw	a3,0(s2)
ffffffffc0203346:	c691                	beqz	a3,ffffffffc0203352 <page_insert+0xaa>
ffffffffc0203348:	120a0073          	sfence.vma	s4
ffffffffc020334c:	bf59                	j	ffffffffc02032e2 <page_insert+0x3a>
ffffffffc020334e:	c014                	sw	a3,0(s0)
ffffffffc0203350:	bf49                	j	ffffffffc02032e2 <page_insert+0x3a>
ffffffffc0203352:	100027f3          	csrr	a5,sstatus
ffffffffc0203356:	8b89                	andi	a5,a5,2
ffffffffc0203358:	ef91                	bnez	a5,ffffffffc0203374 <page_insert+0xcc>
ffffffffc020335a:	00093797          	auipc	a5,0x93
ffffffffc020335e:	5567b783          	ld	a5,1366(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0203362:	739c                	ld	a5,32(a5)
ffffffffc0203364:	4585                	li	a1,1
ffffffffc0203366:	854a                	mv	a0,s2
ffffffffc0203368:	9782                	jalr	a5
ffffffffc020336a:	000ab703          	ld	a4,0(s5)
ffffffffc020336e:	120a0073          	sfence.vma	s4
ffffffffc0203372:	bf85                	j	ffffffffc02032e2 <page_insert+0x3a>
ffffffffc0203374:	a2dfd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203378:	00093797          	auipc	a5,0x93
ffffffffc020337c:	5387b783          	ld	a5,1336(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0203380:	739c                	ld	a5,32(a5)
ffffffffc0203382:	4585                	li	a1,1
ffffffffc0203384:	854a                	mv	a0,s2
ffffffffc0203386:	9782                	jalr	a5
ffffffffc0203388:	a13fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc020338c:	000ab703          	ld	a4,0(s5)
ffffffffc0203390:	120a0073          	sfence.vma	s4
ffffffffc0203394:	b7b9                	j	ffffffffc02032e2 <page_insert+0x3a>
ffffffffc0203396:	5571                	li	a0,-4
ffffffffc0203398:	b79d                	j	ffffffffc02032fe <page_insert+0x56>
ffffffffc020339a:	e68ff0ef          	jal	ra,ffffffffc0202a02 <pa2page.part.0>

ffffffffc020339e <pmm_init>:
ffffffffc020339e:	00009797          	auipc	a5,0x9
ffffffffc02033a2:	68a78793          	addi	a5,a5,1674 # ffffffffc020ca28 <default_pmm_manager>
ffffffffc02033a6:	638c                	ld	a1,0(a5)
ffffffffc02033a8:	7159                	addi	sp,sp,-112
ffffffffc02033aa:	f85a                	sd	s6,48(sp)
ffffffffc02033ac:	00009517          	auipc	a0,0x9
ffffffffc02033b0:	75c50513          	addi	a0,a0,1884 # ffffffffc020cb08 <default_pmm_manager+0xe0>
ffffffffc02033b4:	00093b17          	auipc	s6,0x93
ffffffffc02033b8:	4fcb0b13          	addi	s6,s6,1276 # ffffffffc02968b0 <pmm_manager>
ffffffffc02033bc:	f486                	sd	ra,104(sp)
ffffffffc02033be:	e8ca                	sd	s2,80(sp)
ffffffffc02033c0:	e4ce                	sd	s3,72(sp)
ffffffffc02033c2:	f0a2                	sd	s0,96(sp)
ffffffffc02033c4:	eca6                	sd	s1,88(sp)
ffffffffc02033c6:	e0d2                	sd	s4,64(sp)
ffffffffc02033c8:	fc56                	sd	s5,56(sp)
ffffffffc02033ca:	f45e                	sd	s7,40(sp)
ffffffffc02033cc:	f062                	sd	s8,32(sp)
ffffffffc02033ce:	ec66                	sd	s9,24(sp)
ffffffffc02033d0:	00fb3023          	sd	a5,0(s6)
ffffffffc02033d4:	d57fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02033d8:	000b3783          	ld	a5,0(s6)
ffffffffc02033dc:	00093997          	auipc	s3,0x93
ffffffffc02033e0:	4dc98993          	addi	s3,s3,1244 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02033e4:	679c                	ld	a5,8(a5)
ffffffffc02033e6:	9782                	jalr	a5
ffffffffc02033e8:	57f5                	li	a5,-3
ffffffffc02033ea:	07fa                	slli	a5,a5,0x1e
ffffffffc02033ec:	00f9b023          	sd	a5,0(s3)
ffffffffc02033f0:	cf8fd0ef          	jal	ra,ffffffffc02008e8 <get_memory_base>
ffffffffc02033f4:	892a                	mv	s2,a0
ffffffffc02033f6:	cfcfd0ef          	jal	ra,ffffffffc02008f2 <get_memory_size>
ffffffffc02033fa:	280502e3          	beqz	a0,ffffffffc0203e7e <pmm_init+0xae0>
ffffffffc02033fe:	84aa                	mv	s1,a0
ffffffffc0203400:	00009517          	auipc	a0,0x9
ffffffffc0203404:	74050513          	addi	a0,a0,1856 # ffffffffc020cb40 <default_pmm_manager+0x118>
ffffffffc0203408:	d23fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020340c:	00990433          	add	s0,s2,s1
ffffffffc0203410:	fff40693          	addi	a3,s0,-1
ffffffffc0203414:	864a                	mv	a2,s2
ffffffffc0203416:	85a6                	mv	a1,s1
ffffffffc0203418:	00009517          	auipc	a0,0x9
ffffffffc020341c:	74050513          	addi	a0,a0,1856 # ffffffffc020cb58 <default_pmm_manager+0x130>
ffffffffc0203420:	d0bfc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0203424:	c8000737          	lui	a4,0xc8000
ffffffffc0203428:	87a2                	mv	a5,s0
ffffffffc020342a:	5e876e63          	bltu	a4,s0,ffffffffc0203a26 <pmm_init+0x688>
ffffffffc020342e:	757d                	lui	a0,0xfffff
ffffffffc0203430:	00094617          	auipc	a2,0x94
ffffffffc0203434:	4df60613          	addi	a2,a2,1247 # ffffffffc029790f <end+0xfff>
ffffffffc0203438:	8e69                	and	a2,a2,a0
ffffffffc020343a:	00093497          	auipc	s1,0x93
ffffffffc020343e:	46648493          	addi	s1,s1,1126 # ffffffffc02968a0 <npage>
ffffffffc0203442:	00c7d513          	srli	a0,a5,0xc
ffffffffc0203446:	00093b97          	auipc	s7,0x93
ffffffffc020344a:	462b8b93          	addi	s7,s7,1122 # ffffffffc02968a8 <pages>
ffffffffc020344e:	e088                	sd	a0,0(s1)
ffffffffc0203450:	00cbb023          	sd	a2,0(s7)
ffffffffc0203454:	000807b7          	lui	a5,0x80
ffffffffc0203458:	86b2                	mv	a3,a2
ffffffffc020345a:	02f50863          	beq	a0,a5,ffffffffc020348a <pmm_init+0xec>
ffffffffc020345e:	4781                	li	a5,0
ffffffffc0203460:	4585                	li	a1,1
ffffffffc0203462:	fff806b7          	lui	a3,0xfff80
ffffffffc0203466:	00679513          	slli	a0,a5,0x6
ffffffffc020346a:	9532                	add	a0,a0,a2
ffffffffc020346c:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0203470:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0203474:	6088                	ld	a0,0(s1)
ffffffffc0203476:	0785                	addi	a5,a5,1
ffffffffc0203478:	000bb603          	ld	a2,0(s7)
ffffffffc020347c:	00d50733          	add	a4,a0,a3
ffffffffc0203480:	fee7e3e3          	bltu	a5,a4,ffffffffc0203466 <pmm_init+0xc8>
ffffffffc0203484:	071a                	slli	a4,a4,0x6
ffffffffc0203486:	00e606b3          	add	a3,a2,a4
ffffffffc020348a:	c02007b7          	lui	a5,0xc0200
ffffffffc020348e:	3af6eae3          	bltu	a3,a5,ffffffffc0204042 <pmm_init+0xca4>
ffffffffc0203492:	0009b583          	ld	a1,0(s3)
ffffffffc0203496:	77fd                	lui	a5,0xfffff
ffffffffc0203498:	8c7d                	and	s0,s0,a5
ffffffffc020349a:	8e8d                	sub	a3,a3,a1
ffffffffc020349c:	5e86e363          	bltu	a3,s0,ffffffffc0203a82 <pmm_init+0x6e4>
ffffffffc02034a0:	00009517          	auipc	a0,0x9
ffffffffc02034a4:	6e050513          	addi	a0,a0,1760 # ffffffffc020cb80 <default_pmm_manager+0x158>
ffffffffc02034a8:	c83fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02034ac:	000b3783          	ld	a5,0(s6)
ffffffffc02034b0:	7b9c                	ld	a5,48(a5)
ffffffffc02034b2:	9782                	jalr	a5
ffffffffc02034b4:	00009517          	auipc	a0,0x9
ffffffffc02034b8:	6e450513          	addi	a0,a0,1764 # ffffffffc020cb98 <default_pmm_manager+0x170>
ffffffffc02034bc:	c6ffc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02034c0:	100027f3          	csrr	a5,sstatus
ffffffffc02034c4:	8b89                	andi	a5,a5,2
ffffffffc02034c6:	5a079363          	bnez	a5,ffffffffc0203a6c <pmm_init+0x6ce>
ffffffffc02034ca:	000b3783          	ld	a5,0(s6)
ffffffffc02034ce:	4505                	li	a0,1
ffffffffc02034d0:	6f9c                	ld	a5,24(a5)
ffffffffc02034d2:	9782                	jalr	a5
ffffffffc02034d4:	842a                	mv	s0,a0
ffffffffc02034d6:	180408e3          	beqz	s0,ffffffffc0203e66 <pmm_init+0xac8>
ffffffffc02034da:	000bb683          	ld	a3,0(s7)
ffffffffc02034de:	5a7d                	li	s4,-1
ffffffffc02034e0:	6098                	ld	a4,0(s1)
ffffffffc02034e2:	40d406b3          	sub	a3,s0,a3
ffffffffc02034e6:	8699                	srai	a3,a3,0x6
ffffffffc02034e8:	00080437          	lui	s0,0x80
ffffffffc02034ec:	96a2                	add	a3,a3,s0
ffffffffc02034ee:	00ca5793          	srli	a5,s4,0xc
ffffffffc02034f2:	8ff5                	and	a5,a5,a3
ffffffffc02034f4:	06b2                	slli	a3,a3,0xc
ffffffffc02034f6:	30e7fde3          	bgeu	a5,a4,ffffffffc0204010 <pmm_init+0xc72>
ffffffffc02034fa:	0009b403          	ld	s0,0(s3)
ffffffffc02034fe:	6605                	lui	a2,0x1
ffffffffc0203500:	4581                	li	a1,0
ffffffffc0203502:	9436                	add	s0,s0,a3
ffffffffc0203504:	8522                	mv	a0,s0
ffffffffc0203506:	519070ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc020350a:	0009b683          	ld	a3,0(s3)
ffffffffc020350e:	77fd                	lui	a5,0xfffff
ffffffffc0203510:	00009917          	auipc	s2,0x9
ffffffffc0203514:	20990913          	addi	s2,s2,521 # ffffffffc020c719 <commands+0xd51>
ffffffffc0203518:	00f97933          	and	s2,s2,a5
ffffffffc020351c:	c0200ab7          	lui	s5,0xc0200
ffffffffc0203520:	3fe00637          	lui	a2,0x3fe00
ffffffffc0203524:	964a                	add	a2,a2,s2
ffffffffc0203526:	4729                	li	a4,10
ffffffffc0203528:	40da86b3          	sub	a3,s5,a3
ffffffffc020352c:	c02005b7          	lui	a1,0xc0200
ffffffffc0203530:	8522                	mv	a0,s0
ffffffffc0203532:	fe8ff0ef          	jal	ra,ffffffffc0202d1a <boot_map_segment>
ffffffffc0203536:	c8000637          	lui	a2,0xc8000
ffffffffc020353a:	41260633          	sub	a2,a2,s2
ffffffffc020353e:	3f596ce3          	bltu	s2,s5,ffffffffc0204136 <pmm_init+0xd98>
ffffffffc0203542:	0009b683          	ld	a3,0(s3)
ffffffffc0203546:	85ca                	mv	a1,s2
ffffffffc0203548:	4719                	li	a4,6
ffffffffc020354a:	40d906b3          	sub	a3,s2,a3
ffffffffc020354e:	8522                	mv	a0,s0
ffffffffc0203550:	00093917          	auipc	s2,0x93
ffffffffc0203554:	34890913          	addi	s2,s2,840 # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0203558:	fc2ff0ef          	jal	ra,ffffffffc0202d1a <boot_map_segment>
ffffffffc020355c:	00893023          	sd	s0,0(s2)
ffffffffc0203560:	2d5464e3          	bltu	s0,s5,ffffffffc0204028 <pmm_init+0xc8a>
ffffffffc0203564:	0009b783          	ld	a5,0(s3)
ffffffffc0203568:	1a7e                	slli	s4,s4,0x3f
ffffffffc020356a:	8c1d                	sub	s0,s0,a5
ffffffffc020356c:	00c45793          	srli	a5,s0,0xc
ffffffffc0203570:	00093717          	auipc	a4,0x93
ffffffffc0203574:	32873023          	sd	s0,800(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0203578:	0147ea33          	or	s4,a5,s4
ffffffffc020357c:	180a1073          	csrw	satp,s4
ffffffffc0203580:	12000073          	sfence.vma
ffffffffc0203584:	00009517          	auipc	a0,0x9
ffffffffc0203588:	65450513          	addi	a0,a0,1620 # ffffffffc020cbd8 <default_pmm_manager+0x1b0>
ffffffffc020358c:	b9ffc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0203590:	0000e717          	auipc	a4,0xe
ffffffffc0203594:	a7070713          	addi	a4,a4,-1424 # ffffffffc0211000 <bootstack>
ffffffffc0203598:	0000e797          	auipc	a5,0xe
ffffffffc020359c:	a6878793          	addi	a5,a5,-1432 # ffffffffc0211000 <bootstack>
ffffffffc02035a0:	5cf70d63          	beq	a4,a5,ffffffffc0203b7a <pmm_init+0x7dc>
ffffffffc02035a4:	100027f3          	csrr	a5,sstatus
ffffffffc02035a8:	8b89                	andi	a5,a5,2
ffffffffc02035aa:	4a079763          	bnez	a5,ffffffffc0203a58 <pmm_init+0x6ba>
ffffffffc02035ae:	000b3783          	ld	a5,0(s6)
ffffffffc02035b2:	779c                	ld	a5,40(a5)
ffffffffc02035b4:	9782                	jalr	a5
ffffffffc02035b6:	842a                	mv	s0,a0
ffffffffc02035b8:	6098                	ld	a4,0(s1)
ffffffffc02035ba:	c80007b7          	lui	a5,0xc8000
ffffffffc02035be:	83b1                	srli	a5,a5,0xc
ffffffffc02035c0:	08e7e3e3          	bltu	a5,a4,ffffffffc0203e46 <pmm_init+0xaa8>
ffffffffc02035c4:	00093503          	ld	a0,0(s2)
ffffffffc02035c8:	04050fe3          	beqz	a0,ffffffffc0203e26 <pmm_init+0xa88>
ffffffffc02035cc:	03451793          	slli	a5,a0,0x34
ffffffffc02035d0:	04079be3          	bnez	a5,ffffffffc0203e26 <pmm_init+0xa88>
ffffffffc02035d4:	4601                	li	a2,0
ffffffffc02035d6:	4581                	li	a1,0
ffffffffc02035d8:	809ff0ef          	jal	ra,ffffffffc0202de0 <get_page>
ffffffffc02035dc:	2e0511e3          	bnez	a0,ffffffffc02040be <pmm_init+0xd20>
ffffffffc02035e0:	100027f3          	csrr	a5,sstatus
ffffffffc02035e4:	8b89                	andi	a5,a5,2
ffffffffc02035e6:	44079e63          	bnez	a5,ffffffffc0203a42 <pmm_init+0x6a4>
ffffffffc02035ea:	000b3783          	ld	a5,0(s6)
ffffffffc02035ee:	4505                	li	a0,1
ffffffffc02035f0:	6f9c                	ld	a5,24(a5)
ffffffffc02035f2:	9782                	jalr	a5
ffffffffc02035f4:	8a2a                	mv	s4,a0
ffffffffc02035f6:	00093503          	ld	a0,0(s2)
ffffffffc02035fa:	4681                	li	a3,0
ffffffffc02035fc:	4601                	li	a2,0
ffffffffc02035fe:	85d2                	mv	a1,s4
ffffffffc0203600:	ca9ff0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc0203604:	26051be3          	bnez	a0,ffffffffc020407a <pmm_init+0xcdc>
ffffffffc0203608:	00093503          	ld	a0,0(s2)
ffffffffc020360c:	4601                	li	a2,0
ffffffffc020360e:	4581                	li	a1,0
ffffffffc0203610:	ce2ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc0203614:	280505e3          	beqz	a0,ffffffffc020409e <pmm_init+0xd00>
ffffffffc0203618:	611c                	ld	a5,0(a0)
ffffffffc020361a:	0017f713          	andi	a4,a5,1
ffffffffc020361e:	26070ee3          	beqz	a4,ffffffffc020409a <pmm_init+0xcfc>
ffffffffc0203622:	6098                	ld	a4,0(s1)
ffffffffc0203624:	078a                	slli	a5,a5,0x2
ffffffffc0203626:	83b1                	srli	a5,a5,0xc
ffffffffc0203628:	62e7f363          	bgeu	a5,a4,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc020362c:	000bb683          	ld	a3,0(s7)
ffffffffc0203630:	fff80637          	lui	a2,0xfff80
ffffffffc0203634:	97b2                	add	a5,a5,a2
ffffffffc0203636:	079a                	slli	a5,a5,0x6
ffffffffc0203638:	97b6                	add	a5,a5,a3
ffffffffc020363a:	2afa12e3          	bne	s4,a5,ffffffffc02040de <pmm_init+0xd40>
ffffffffc020363e:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203642:	4785                	li	a5,1
ffffffffc0203644:	2cf699e3          	bne	a3,a5,ffffffffc0204116 <pmm_init+0xd78>
ffffffffc0203648:	00093503          	ld	a0,0(s2)
ffffffffc020364c:	77fd                	lui	a5,0xfffff
ffffffffc020364e:	6114                	ld	a3,0(a0)
ffffffffc0203650:	068a                	slli	a3,a3,0x2
ffffffffc0203652:	8efd                	and	a3,a3,a5
ffffffffc0203654:	00c6d613          	srli	a2,a3,0xc
ffffffffc0203658:	2ae673e3          	bgeu	a2,a4,ffffffffc02040fe <pmm_init+0xd60>
ffffffffc020365c:	0009bc03          	ld	s8,0(s3)
ffffffffc0203660:	96e2                	add	a3,a3,s8
ffffffffc0203662:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0203666:	0a8a                	slli	s5,s5,0x2
ffffffffc0203668:	00fafab3          	and	s5,s5,a5
ffffffffc020366c:	00cad793          	srli	a5,s5,0xc
ffffffffc0203670:	06e7f3e3          	bgeu	a5,a4,ffffffffc0203ed6 <pmm_init+0xb38>
ffffffffc0203674:	4601                	li	a2,0
ffffffffc0203676:	6585                	lui	a1,0x1
ffffffffc0203678:	9ae2                	add	s5,s5,s8
ffffffffc020367a:	c78ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc020367e:	0aa1                	addi	s5,s5,8
ffffffffc0203680:	03551be3          	bne	a0,s5,ffffffffc0203eb6 <pmm_init+0xb18>
ffffffffc0203684:	100027f3          	csrr	a5,sstatus
ffffffffc0203688:	8b89                	andi	a5,a5,2
ffffffffc020368a:	3a079163          	bnez	a5,ffffffffc0203a2c <pmm_init+0x68e>
ffffffffc020368e:	000b3783          	ld	a5,0(s6)
ffffffffc0203692:	4505                	li	a0,1
ffffffffc0203694:	6f9c                	ld	a5,24(a5)
ffffffffc0203696:	9782                	jalr	a5
ffffffffc0203698:	8c2a                	mv	s8,a0
ffffffffc020369a:	00093503          	ld	a0,0(s2)
ffffffffc020369e:	46d1                	li	a3,20
ffffffffc02036a0:	6605                	lui	a2,0x1
ffffffffc02036a2:	85e2                	mv	a1,s8
ffffffffc02036a4:	c05ff0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc02036a8:	1a0519e3          	bnez	a0,ffffffffc020405a <pmm_init+0xcbc>
ffffffffc02036ac:	00093503          	ld	a0,0(s2)
ffffffffc02036b0:	4601                	li	a2,0
ffffffffc02036b2:	6585                	lui	a1,0x1
ffffffffc02036b4:	c3eff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc02036b8:	10050ce3          	beqz	a0,ffffffffc0203fd0 <pmm_init+0xc32>
ffffffffc02036bc:	611c                	ld	a5,0(a0)
ffffffffc02036be:	0107f713          	andi	a4,a5,16
ffffffffc02036c2:	0e0707e3          	beqz	a4,ffffffffc0203fb0 <pmm_init+0xc12>
ffffffffc02036c6:	8b91                	andi	a5,a5,4
ffffffffc02036c8:	0c0784e3          	beqz	a5,ffffffffc0203f90 <pmm_init+0xbf2>
ffffffffc02036cc:	00093503          	ld	a0,0(s2)
ffffffffc02036d0:	611c                	ld	a5,0(a0)
ffffffffc02036d2:	8bc1                	andi	a5,a5,16
ffffffffc02036d4:	08078ee3          	beqz	a5,ffffffffc0203f70 <pmm_init+0xbd2>
ffffffffc02036d8:	000c2703          	lw	a4,0(s8)
ffffffffc02036dc:	4785                	li	a5,1
ffffffffc02036de:	06f719e3          	bne	a4,a5,ffffffffc0203f50 <pmm_init+0xbb2>
ffffffffc02036e2:	4681                	li	a3,0
ffffffffc02036e4:	6605                	lui	a2,0x1
ffffffffc02036e6:	85d2                	mv	a1,s4
ffffffffc02036e8:	bc1ff0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc02036ec:	040512e3          	bnez	a0,ffffffffc0203f30 <pmm_init+0xb92>
ffffffffc02036f0:	000a2703          	lw	a4,0(s4)
ffffffffc02036f4:	4789                	li	a5,2
ffffffffc02036f6:	00f71de3          	bne	a4,a5,ffffffffc0203f10 <pmm_init+0xb72>
ffffffffc02036fa:	000c2783          	lw	a5,0(s8)
ffffffffc02036fe:	7e079963          	bnez	a5,ffffffffc0203ef0 <pmm_init+0xb52>
ffffffffc0203702:	00093503          	ld	a0,0(s2)
ffffffffc0203706:	4601                	li	a2,0
ffffffffc0203708:	6585                	lui	a1,0x1
ffffffffc020370a:	be8ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc020370e:	54050263          	beqz	a0,ffffffffc0203c52 <pmm_init+0x8b4>
ffffffffc0203712:	6118                	ld	a4,0(a0)
ffffffffc0203714:	00177793          	andi	a5,a4,1
ffffffffc0203718:	180781e3          	beqz	a5,ffffffffc020409a <pmm_init+0xcfc>
ffffffffc020371c:	6094                	ld	a3,0(s1)
ffffffffc020371e:	00271793          	slli	a5,a4,0x2
ffffffffc0203722:	83b1                	srli	a5,a5,0xc
ffffffffc0203724:	52d7f563          	bgeu	a5,a3,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc0203728:	000bb683          	ld	a3,0(s7)
ffffffffc020372c:	fff80ab7          	lui	s5,0xfff80
ffffffffc0203730:	97d6                	add	a5,a5,s5
ffffffffc0203732:	079a                	slli	a5,a5,0x6
ffffffffc0203734:	97b6                	add	a5,a5,a3
ffffffffc0203736:	58fa1e63          	bne	s4,a5,ffffffffc0203cd2 <pmm_init+0x934>
ffffffffc020373a:	8b41                	andi	a4,a4,16
ffffffffc020373c:	56071b63          	bnez	a4,ffffffffc0203cb2 <pmm_init+0x914>
ffffffffc0203740:	00093503          	ld	a0,0(s2)
ffffffffc0203744:	4581                	li	a1,0
ffffffffc0203746:	ac7ff0ef          	jal	ra,ffffffffc020320c <page_remove>
ffffffffc020374a:	000a2c83          	lw	s9,0(s4)
ffffffffc020374e:	4785                	li	a5,1
ffffffffc0203750:	5cfc9163          	bne	s9,a5,ffffffffc0203d12 <pmm_init+0x974>
ffffffffc0203754:	000c2783          	lw	a5,0(s8)
ffffffffc0203758:	58079d63          	bnez	a5,ffffffffc0203cf2 <pmm_init+0x954>
ffffffffc020375c:	00093503          	ld	a0,0(s2)
ffffffffc0203760:	6585                	lui	a1,0x1
ffffffffc0203762:	aabff0ef          	jal	ra,ffffffffc020320c <page_remove>
ffffffffc0203766:	000a2783          	lw	a5,0(s4)
ffffffffc020376a:	200793e3          	bnez	a5,ffffffffc0204170 <pmm_init+0xdd2>
ffffffffc020376e:	000c2783          	lw	a5,0(s8)
ffffffffc0203772:	1c079fe3          	bnez	a5,ffffffffc0204150 <pmm_init+0xdb2>
ffffffffc0203776:	00093a03          	ld	s4,0(s2)
ffffffffc020377a:	608c                	ld	a1,0(s1)
ffffffffc020377c:	000a3683          	ld	a3,0(s4)
ffffffffc0203780:	068a                	slli	a3,a3,0x2
ffffffffc0203782:	82b1                	srli	a3,a3,0xc
ffffffffc0203784:	4cb6f563          	bgeu	a3,a1,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc0203788:	000bb503          	ld	a0,0(s7)
ffffffffc020378c:	96d6                	add	a3,a3,s5
ffffffffc020378e:	069a                	slli	a3,a3,0x6
ffffffffc0203790:	00d507b3          	add	a5,a0,a3
ffffffffc0203794:	439c                	lw	a5,0(a5)
ffffffffc0203796:	4f979e63          	bne	a5,s9,ffffffffc0203c92 <pmm_init+0x8f4>
ffffffffc020379a:	8699                	srai	a3,a3,0x6
ffffffffc020379c:	00080637          	lui	a2,0x80
ffffffffc02037a0:	96b2                	add	a3,a3,a2
ffffffffc02037a2:	00c69713          	slli	a4,a3,0xc
ffffffffc02037a6:	8331                	srli	a4,a4,0xc
ffffffffc02037a8:	06b2                	slli	a3,a3,0xc
ffffffffc02037aa:	06b773e3          	bgeu	a4,a1,ffffffffc0204010 <pmm_init+0xc72>
ffffffffc02037ae:	0009b703          	ld	a4,0(s3)
ffffffffc02037b2:	96ba                	add	a3,a3,a4
ffffffffc02037b4:	629c                	ld	a5,0(a3)
ffffffffc02037b6:	078a                	slli	a5,a5,0x2
ffffffffc02037b8:	83b1                	srli	a5,a5,0xc
ffffffffc02037ba:	48b7fa63          	bgeu	a5,a1,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc02037be:	8f91                	sub	a5,a5,a2
ffffffffc02037c0:	079a                	slli	a5,a5,0x6
ffffffffc02037c2:	953e                	add	a0,a0,a5
ffffffffc02037c4:	100027f3          	csrr	a5,sstatus
ffffffffc02037c8:	8b89                	andi	a5,a5,2
ffffffffc02037ca:	32079463          	bnez	a5,ffffffffc0203af2 <pmm_init+0x754>
ffffffffc02037ce:	000b3783          	ld	a5,0(s6)
ffffffffc02037d2:	4585                	li	a1,1
ffffffffc02037d4:	739c                	ld	a5,32(a5)
ffffffffc02037d6:	9782                	jalr	a5
ffffffffc02037d8:	000a3783          	ld	a5,0(s4)
ffffffffc02037dc:	6098                	ld	a4,0(s1)
ffffffffc02037de:	078a                	slli	a5,a5,0x2
ffffffffc02037e0:	83b1                	srli	a5,a5,0xc
ffffffffc02037e2:	46e7f663          	bgeu	a5,a4,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc02037e6:	000bb503          	ld	a0,0(s7)
ffffffffc02037ea:	fff80737          	lui	a4,0xfff80
ffffffffc02037ee:	97ba                	add	a5,a5,a4
ffffffffc02037f0:	079a                	slli	a5,a5,0x6
ffffffffc02037f2:	953e                	add	a0,a0,a5
ffffffffc02037f4:	100027f3          	csrr	a5,sstatus
ffffffffc02037f8:	8b89                	andi	a5,a5,2
ffffffffc02037fa:	2e079063          	bnez	a5,ffffffffc0203ada <pmm_init+0x73c>
ffffffffc02037fe:	000b3783          	ld	a5,0(s6)
ffffffffc0203802:	4585                	li	a1,1
ffffffffc0203804:	739c                	ld	a5,32(a5)
ffffffffc0203806:	9782                	jalr	a5
ffffffffc0203808:	00093783          	ld	a5,0(s2)
ffffffffc020380c:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0203810:	12000073          	sfence.vma
ffffffffc0203814:	100027f3          	csrr	a5,sstatus
ffffffffc0203818:	8b89                	andi	a5,a5,2
ffffffffc020381a:	2a079663          	bnez	a5,ffffffffc0203ac6 <pmm_init+0x728>
ffffffffc020381e:	000b3783          	ld	a5,0(s6)
ffffffffc0203822:	779c                	ld	a5,40(a5)
ffffffffc0203824:	9782                	jalr	a5
ffffffffc0203826:	8a2a                	mv	s4,a0
ffffffffc0203828:	7d441463          	bne	s0,s4,ffffffffc0203ff0 <pmm_init+0xc52>
ffffffffc020382c:	00009517          	auipc	a0,0x9
ffffffffc0203830:	70450513          	addi	a0,a0,1796 # ffffffffc020cf30 <default_pmm_manager+0x508>
ffffffffc0203834:	8f7fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0203838:	100027f3          	csrr	a5,sstatus
ffffffffc020383c:	8b89                	andi	a5,a5,2
ffffffffc020383e:	26079a63          	bnez	a5,ffffffffc0203ab2 <pmm_init+0x714>
ffffffffc0203842:	000b3783          	ld	a5,0(s6)
ffffffffc0203846:	779c                	ld	a5,40(a5)
ffffffffc0203848:	9782                	jalr	a5
ffffffffc020384a:	8c2a                	mv	s8,a0
ffffffffc020384c:	6098                	ld	a4,0(s1)
ffffffffc020384e:	c0200437          	lui	s0,0xc0200
ffffffffc0203852:	7afd                	lui	s5,0xfffff
ffffffffc0203854:	00c71793          	slli	a5,a4,0xc
ffffffffc0203858:	6a05                	lui	s4,0x1
ffffffffc020385a:	02f47c63          	bgeu	s0,a5,ffffffffc0203892 <pmm_init+0x4f4>
ffffffffc020385e:	00c45793          	srli	a5,s0,0xc
ffffffffc0203862:	00093503          	ld	a0,0(s2)
ffffffffc0203866:	3ae7f763          	bgeu	a5,a4,ffffffffc0203c14 <pmm_init+0x876>
ffffffffc020386a:	0009b583          	ld	a1,0(s3)
ffffffffc020386e:	4601                	li	a2,0
ffffffffc0203870:	95a2                	add	a1,a1,s0
ffffffffc0203872:	a80ff0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc0203876:	36050f63          	beqz	a0,ffffffffc0203bf4 <pmm_init+0x856>
ffffffffc020387a:	611c                	ld	a5,0(a0)
ffffffffc020387c:	078a                	slli	a5,a5,0x2
ffffffffc020387e:	0157f7b3          	and	a5,a5,s5
ffffffffc0203882:	3a879663          	bne	a5,s0,ffffffffc0203c2e <pmm_init+0x890>
ffffffffc0203886:	6098                	ld	a4,0(s1)
ffffffffc0203888:	9452                	add	s0,s0,s4
ffffffffc020388a:	00c71793          	slli	a5,a4,0xc
ffffffffc020388e:	fcf468e3          	bltu	s0,a5,ffffffffc020385e <pmm_init+0x4c0>
ffffffffc0203892:	00093783          	ld	a5,0(s2)
ffffffffc0203896:	639c                	ld	a5,0(a5)
ffffffffc0203898:	48079d63          	bnez	a5,ffffffffc0203d32 <pmm_init+0x994>
ffffffffc020389c:	100027f3          	csrr	a5,sstatus
ffffffffc02038a0:	8b89                	andi	a5,a5,2
ffffffffc02038a2:	26079463          	bnez	a5,ffffffffc0203b0a <pmm_init+0x76c>
ffffffffc02038a6:	000b3783          	ld	a5,0(s6)
ffffffffc02038aa:	4505                	li	a0,1
ffffffffc02038ac:	6f9c                	ld	a5,24(a5)
ffffffffc02038ae:	9782                	jalr	a5
ffffffffc02038b0:	8a2a                	mv	s4,a0
ffffffffc02038b2:	00093503          	ld	a0,0(s2)
ffffffffc02038b6:	4699                	li	a3,6
ffffffffc02038b8:	10000613          	li	a2,256
ffffffffc02038bc:	85d2                	mv	a1,s4
ffffffffc02038be:	9ebff0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc02038c2:	4a051863          	bnez	a0,ffffffffc0203d72 <pmm_init+0x9d4>
ffffffffc02038c6:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02038ca:	4785                	li	a5,1
ffffffffc02038cc:	48f71363          	bne	a4,a5,ffffffffc0203d52 <pmm_init+0x9b4>
ffffffffc02038d0:	00093503          	ld	a0,0(s2)
ffffffffc02038d4:	6405                	lui	s0,0x1
ffffffffc02038d6:	4699                	li	a3,6
ffffffffc02038d8:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc02038dc:	85d2                	mv	a1,s4
ffffffffc02038de:	9cbff0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc02038e2:	38051863          	bnez	a0,ffffffffc0203c72 <pmm_init+0x8d4>
ffffffffc02038e6:	000a2703          	lw	a4,0(s4)
ffffffffc02038ea:	4789                	li	a5,2
ffffffffc02038ec:	4ef71363          	bne	a4,a5,ffffffffc0203dd2 <pmm_init+0xa34>
ffffffffc02038f0:	00009597          	auipc	a1,0x9
ffffffffc02038f4:	78858593          	addi	a1,a1,1928 # ffffffffc020d078 <default_pmm_manager+0x650>
ffffffffc02038f8:	10000513          	li	a0,256
ffffffffc02038fc:	0b7070ef          	jal	ra,ffffffffc020b1b2 <strcpy>
ffffffffc0203900:	10040593          	addi	a1,s0,256
ffffffffc0203904:	10000513          	li	a0,256
ffffffffc0203908:	0bd070ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc020390c:	4a051363          	bnez	a0,ffffffffc0203db2 <pmm_init+0xa14>
ffffffffc0203910:	000bb683          	ld	a3,0(s7)
ffffffffc0203914:	00080737          	lui	a4,0x80
ffffffffc0203918:	547d                	li	s0,-1
ffffffffc020391a:	40da06b3          	sub	a3,s4,a3
ffffffffc020391e:	8699                	srai	a3,a3,0x6
ffffffffc0203920:	609c                	ld	a5,0(s1)
ffffffffc0203922:	96ba                	add	a3,a3,a4
ffffffffc0203924:	8031                	srli	s0,s0,0xc
ffffffffc0203926:	0086f733          	and	a4,a3,s0
ffffffffc020392a:	06b2                	slli	a3,a3,0xc
ffffffffc020392c:	6ef77263          	bgeu	a4,a5,ffffffffc0204010 <pmm_init+0xc72>
ffffffffc0203930:	0009b783          	ld	a5,0(s3)
ffffffffc0203934:	10000513          	li	a0,256
ffffffffc0203938:	96be                	add	a3,a3,a5
ffffffffc020393a:	10068023          	sb	zero,256(a3)
ffffffffc020393e:	03f070ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc0203942:	44051863          	bnez	a0,ffffffffc0203d92 <pmm_init+0x9f4>
ffffffffc0203946:	00093a83          	ld	s5,0(s2)
ffffffffc020394a:	609c                	ld	a5,0(s1)
ffffffffc020394c:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0203950:	068a                	slli	a3,a3,0x2
ffffffffc0203952:	82b1                	srli	a3,a3,0xc
ffffffffc0203954:	2ef6fd63          	bgeu	a3,a5,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc0203958:	8c75                	and	s0,s0,a3
ffffffffc020395a:	06b2                	slli	a3,a3,0xc
ffffffffc020395c:	6af47a63          	bgeu	s0,a5,ffffffffc0204010 <pmm_init+0xc72>
ffffffffc0203960:	0009b403          	ld	s0,0(s3)
ffffffffc0203964:	9436                	add	s0,s0,a3
ffffffffc0203966:	100027f3          	csrr	a5,sstatus
ffffffffc020396a:	8b89                	andi	a5,a5,2
ffffffffc020396c:	1e079c63          	bnez	a5,ffffffffc0203b64 <pmm_init+0x7c6>
ffffffffc0203970:	000b3783          	ld	a5,0(s6)
ffffffffc0203974:	4585                	li	a1,1
ffffffffc0203976:	8552                	mv	a0,s4
ffffffffc0203978:	739c                	ld	a5,32(a5)
ffffffffc020397a:	9782                	jalr	a5
ffffffffc020397c:	601c                	ld	a5,0(s0)
ffffffffc020397e:	6098                	ld	a4,0(s1)
ffffffffc0203980:	078a                	slli	a5,a5,0x2
ffffffffc0203982:	83b1                	srli	a5,a5,0xc
ffffffffc0203984:	2ce7f563          	bgeu	a5,a4,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc0203988:	000bb503          	ld	a0,0(s7)
ffffffffc020398c:	fff80737          	lui	a4,0xfff80
ffffffffc0203990:	97ba                	add	a5,a5,a4
ffffffffc0203992:	079a                	slli	a5,a5,0x6
ffffffffc0203994:	953e                	add	a0,a0,a5
ffffffffc0203996:	100027f3          	csrr	a5,sstatus
ffffffffc020399a:	8b89                	andi	a5,a5,2
ffffffffc020399c:	1a079863          	bnez	a5,ffffffffc0203b4c <pmm_init+0x7ae>
ffffffffc02039a0:	000b3783          	ld	a5,0(s6)
ffffffffc02039a4:	4585                	li	a1,1
ffffffffc02039a6:	739c                	ld	a5,32(a5)
ffffffffc02039a8:	9782                	jalr	a5
ffffffffc02039aa:	000ab783          	ld	a5,0(s5)
ffffffffc02039ae:	6098                	ld	a4,0(s1)
ffffffffc02039b0:	078a                	slli	a5,a5,0x2
ffffffffc02039b2:	83b1                	srli	a5,a5,0xc
ffffffffc02039b4:	28e7fd63          	bgeu	a5,a4,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc02039b8:	000bb503          	ld	a0,0(s7)
ffffffffc02039bc:	fff80737          	lui	a4,0xfff80
ffffffffc02039c0:	97ba                	add	a5,a5,a4
ffffffffc02039c2:	079a                	slli	a5,a5,0x6
ffffffffc02039c4:	953e                	add	a0,a0,a5
ffffffffc02039c6:	100027f3          	csrr	a5,sstatus
ffffffffc02039ca:	8b89                	andi	a5,a5,2
ffffffffc02039cc:	16079463          	bnez	a5,ffffffffc0203b34 <pmm_init+0x796>
ffffffffc02039d0:	000b3783          	ld	a5,0(s6)
ffffffffc02039d4:	4585                	li	a1,1
ffffffffc02039d6:	739c                	ld	a5,32(a5)
ffffffffc02039d8:	9782                	jalr	a5
ffffffffc02039da:	00093783          	ld	a5,0(s2)
ffffffffc02039de:	0007b023          	sd	zero,0(a5)
ffffffffc02039e2:	12000073          	sfence.vma
ffffffffc02039e6:	100027f3          	csrr	a5,sstatus
ffffffffc02039ea:	8b89                	andi	a5,a5,2
ffffffffc02039ec:	12079a63          	bnez	a5,ffffffffc0203b20 <pmm_init+0x782>
ffffffffc02039f0:	000b3783          	ld	a5,0(s6)
ffffffffc02039f4:	779c                	ld	a5,40(a5)
ffffffffc02039f6:	9782                	jalr	a5
ffffffffc02039f8:	842a                	mv	s0,a0
ffffffffc02039fa:	488c1e63          	bne	s8,s0,ffffffffc0203e96 <pmm_init+0xaf8>
ffffffffc02039fe:	00009517          	auipc	a0,0x9
ffffffffc0203a02:	6f250513          	addi	a0,a0,1778 # ffffffffc020d0f0 <default_pmm_manager+0x6c8>
ffffffffc0203a06:	f24fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0203a0a:	7406                	ld	s0,96(sp)
ffffffffc0203a0c:	70a6                	ld	ra,104(sp)
ffffffffc0203a0e:	64e6                	ld	s1,88(sp)
ffffffffc0203a10:	6946                	ld	s2,80(sp)
ffffffffc0203a12:	69a6                	ld	s3,72(sp)
ffffffffc0203a14:	6a06                	ld	s4,64(sp)
ffffffffc0203a16:	7ae2                	ld	s5,56(sp)
ffffffffc0203a18:	7b42                	ld	s6,48(sp)
ffffffffc0203a1a:	7ba2                	ld	s7,40(sp)
ffffffffc0203a1c:	7c02                	ld	s8,32(sp)
ffffffffc0203a1e:	6ce2                	ld	s9,24(sp)
ffffffffc0203a20:	6165                	addi	sp,sp,112
ffffffffc0203a22:	b68fe06f          	j	ffffffffc0201d8a <kmalloc_init>
ffffffffc0203a26:	c80007b7          	lui	a5,0xc8000
ffffffffc0203a2a:	b411                	j	ffffffffc020342e <pmm_init+0x90>
ffffffffc0203a2c:	b74fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203a30:	000b3783          	ld	a5,0(s6)
ffffffffc0203a34:	4505                	li	a0,1
ffffffffc0203a36:	6f9c                	ld	a5,24(a5)
ffffffffc0203a38:	9782                	jalr	a5
ffffffffc0203a3a:	8c2a                	mv	s8,a0
ffffffffc0203a3c:	b5efd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203a40:	b9a9                	j	ffffffffc020369a <pmm_init+0x2fc>
ffffffffc0203a42:	b5efd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203a46:	000b3783          	ld	a5,0(s6)
ffffffffc0203a4a:	4505                	li	a0,1
ffffffffc0203a4c:	6f9c                	ld	a5,24(a5)
ffffffffc0203a4e:	9782                	jalr	a5
ffffffffc0203a50:	8a2a                	mv	s4,a0
ffffffffc0203a52:	b48fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203a56:	b645                	j	ffffffffc02035f6 <pmm_init+0x258>
ffffffffc0203a58:	b48fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203a5c:	000b3783          	ld	a5,0(s6)
ffffffffc0203a60:	779c                	ld	a5,40(a5)
ffffffffc0203a62:	9782                	jalr	a5
ffffffffc0203a64:	842a                	mv	s0,a0
ffffffffc0203a66:	b34fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203a6a:	b6b9                	j	ffffffffc02035b8 <pmm_init+0x21a>
ffffffffc0203a6c:	b34fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203a70:	000b3783          	ld	a5,0(s6)
ffffffffc0203a74:	4505                	li	a0,1
ffffffffc0203a76:	6f9c                	ld	a5,24(a5)
ffffffffc0203a78:	9782                	jalr	a5
ffffffffc0203a7a:	842a                	mv	s0,a0
ffffffffc0203a7c:	b1efd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203a80:	bc99                	j	ffffffffc02034d6 <pmm_init+0x138>
ffffffffc0203a82:	6705                	lui	a4,0x1
ffffffffc0203a84:	177d                	addi	a4,a4,-1
ffffffffc0203a86:	96ba                	add	a3,a3,a4
ffffffffc0203a88:	8ff5                	and	a5,a5,a3
ffffffffc0203a8a:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203a8e:	1ca77063          	bgeu	a4,a0,ffffffffc0203c4e <pmm_init+0x8b0>
ffffffffc0203a92:	000b3683          	ld	a3,0(s6)
ffffffffc0203a96:	fff80537          	lui	a0,0xfff80
ffffffffc0203a9a:	972a                	add	a4,a4,a0
ffffffffc0203a9c:	6a94                	ld	a3,16(a3)
ffffffffc0203a9e:	8c1d                	sub	s0,s0,a5
ffffffffc0203aa0:	00671513          	slli	a0,a4,0x6
ffffffffc0203aa4:	00c45593          	srli	a1,s0,0xc
ffffffffc0203aa8:	9532                	add	a0,a0,a2
ffffffffc0203aaa:	9682                	jalr	a3
ffffffffc0203aac:	0009b583          	ld	a1,0(s3)
ffffffffc0203ab0:	bac5                	j	ffffffffc02034a0 <pmm_init+0x102>
ffffffffc0203ab2:	aeefd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203ab6:	000b3783          	ld	a5,0(s6)
ffffffffc0203aba:	779c                	ld	a5,40(a5)
ffffffffc0203abc:	9782                	jalr	a5
ffffffffc0203abe:	8c2a                	mv	s8,a0
ffffffffc0203ac0:	adafd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203ac4:	b361                	j	ffffffffc020384c <pmm_init+0x4ae>
ffffffffc0203ac6:	adafd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203aca:	000b3783          	ld	a5,0(s6)
ffffffffc0203ace:	779c                	ld	a5,40(a5)
ffffffffc0203ad0:	9782                	jalr	a5
ffffffffc0203ad2:	8a2a                	mv	s4,a0
ffffffffc0203ad4:	ac6fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203ad8:	bb81                	j	ffffffffc0203828 <pmm_init+0x48a>
ffffffffc0203ada:	e42a                	sd	a0,8(sp)
ffffffffc0203adc:	ac4fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203ae0:	000b3783          	ld	a5,0(s6)
ffffffffc0203ae4:	6522                	ld	a0,8(sp)
ffffffffc0203ae6:	4585                	li	a1,1
ffffffffc0203ae8:	739c                	ld	a5,32(a5)
ffffffffc0203aea:	9782                	jalr	a5
ffffffffc0203aec:	aaefd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203af0:	bb21                	j	ffffffffc0203808 <pmm_init+0x46a>
ffffffffc0203af2:	e42a                	sd	a0,8(sp)
ffffffffc0203af4:	aacfd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203af8:	000b3783          	ld	a5,0(s6)
ffffffffc0203afc:	6522                	ld	a0,8(sp)
ffffffffc0203afe:	4585                	li	a1,1
ffffffffc0203b00:	739c                	ld	a5,32(a5)
ffffffffc0203b02:	9782                	jalr	a5
ffffffffc0203b04:	a96fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203b08:	b9c1                	j	ffffffffc02037d8 <pmm_init+0x43a>
ffffffffc0203b0a:	a96fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203b0e:	000b3783          	ld	a5,0(s6)
ffffffffc0203b12:	4505                	li	a0,1
ffffffffc0203b14:	6f9c                	ld	a5,24(a5)
ffffffffc0203b16:	9782                	jalr	a5
ffffffffc0203b18:	8a2a                	mv	s4,a0
ffffffffc0203b1a:	a80fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203b1e:	bb51                	j	ffffffffc02038b2 <pmm_init+0x514>
ffffffffc0203b20:	a80fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203b24:	000b3783          	ld	a5,0(s6)
ffffffffc0203b28:	779c                	ld	a5,40(a5)
ffffffffc0203b2a:	9782                	jalr	a5
ffffffffc0203b2c:	842a                	mv	s0,a0
ffffffffc0203b2e:	a6cfd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203b32:	b5e1                	j	ffffffffc02039fa <pmm_init+0x65c>
ffffffffc0203b34:	e42a                	sd	a0,8(sp)
ffffffffc0203b36:	a6afd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203b3a:	000b3783          	ld	a5,0(s6)
ffffffffc0203b3e:	6522                	ld	a0,8(sp)
ffffffffc0203b40:	4585                	li	a1,1
ffffffffc0203b42:	739c                	ld	a5,32(a5)
ffffffffc0203b44:	9782                	jalr	a5
ffffffffc0203b46:	a54fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203b4a:	bd41                	j	ffffffffc02039da <pmm_init+0x63c>
ffffffffc0203b4c:	e42a                	sd	a0,8(sp)
ffffffffc0203b4e:	a52fd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203b52:	000b3783          	ld	a5,0(s6)
ffffffffc0203b56:	6522                	ld	a0,8(sp)
ffffffffc0203b58:	4585                	li	a1,1
ffffffffc0203b5a:	739c                	ld	a5,32(a5)
ffffffffc0203b5c:	9782                	jalr	a5
ffffffffc0203b5e:	a3cfd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203b62:	b5a1                	j	ffffffffc02039aa <pmm_init+0x60c>
ffffffffc0203b64:	a3cfd0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0203b68:	000b3783          	ld	a5,0(s6)
ffffffffc0203b6c:	4585                	li	a1,1
ffffffffc0203b6e:	8552                	mv	a0,s4
ffffffffc0203b70:	739c                	ld	a5,32(a5)
ffffffffc0203b72:	9782                	jalr	a5
ffffffffc0203b74:	a26fd0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0203b78:	b511                	j	ffffffffc020397c <pmm_init+0x5de>
ffffffffc0203b7a:	0000f417          	auipc	s0,0xf
ffffffffc0203b7e:	48640413          	addi	s0,s0,1158 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0203b82:	0000f797          	auipc	a5,0xf
ffffffffc0203b86:	47e78793          	addi	a5,a5,1150 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0203b8a:	a0f41de3          	bne	s0,a5,ffffffffc02035a4 <pmm_init+0x206>
ffffffffc0203b8e:	4581                	li	a1,0
ffffffffc0203b90:	6605                	lui	a2,0x1
ffffffffc0203b92:	8522                	mv	a0,s0
ffffffffc0203b94:	68a070ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0203b98:	0000c597          	auipc	a1,0xc
ffffffffc0203b9c:	46858593          	addi	a1,a1,1128 # ffffffffc0210000 <bootstackguard>
ffffffffc0203ba0:	0000d797          	auipc	a5,0xd
ffffffffc0203ba4:	44078fa3          	sb	zero,1119(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc0203ba8:	0000c797          	auipc	a5,0xc
ffffffffc0203bac:	44078c23          	sb	zero,1112(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc0203bb0:	00093503          	ld	a0,0(s2)
ffffffffc0203bb4:	2555ec63          	bltu	a1,s5,ffffffffc0203e0c <pmm_init+0xa6e>
ffffffffc0203bb8:	0009b683          	ld	a3,0(s3)
ffffffffc0203bbc:	4701                	li	a4,0
ffffffffc0203bbe:	6605                	lui	a2,0x1
ffffffffc0203bc0:	40d586b3          	sub	a3,a1,a3
ffffffffc0203bc4:	956ff0ef          	jal	ra,ffffffffc0202d1a <boot_map_segment>
ffffffffc0203bc8:	00093503          	ld	a0,0(s2)
ffffffffc0203bcc:	23546363          	bltu	s0,s5,ffffffffc0203df2 <pmm_init+0xa54>
ffffffffc0203bd0:	0009b683          	ld	a3,0(s3)
ffffffffc0203bd4:	4701                	li	a4,0
ffffffffc0203bd6:	6605                	lui	a2,0x1
ffffffffc0203bd8:	40d406b3          	sub	a3,s0,a3
ffffffffc0203bdc:	85a2                	mv	a1,s0
ffffffffc0203bde:	93cff0ef          	jal	ra,ffffffffc0202d1a <boot_map_segment>
ffffffffc0203be2:	12000073          	sfence.vma
ffffffffc0203be6:	00009517          	auipc	a0,0x9
ffffffffc0203bea:	01a50513          	addi	a0,a0,26 # ffffffffc020cc00 <default_pmm_manager+0x1d8>
ffffffffc0203bee:	d3cfc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0203bf2:	ba4d                	j	ffffffffc02035a4 <pmm_init+0x206>
ffffffffc0203bf4:	00009697          	auipc	a3,0x9
ffffffffc0203bf8:	35c68693          	addi	a3,a3,860 # ffffffffc020cf50 <default_pmm_manager+0x528>
ffffffffc0203bfc:	00008617          	auipc	a2,0x8
ffffffffc0203c00:	01c60613          	addi	a2,a2,28 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203c04:	28b00593          	li	a1,651
ffffffffc0203c08:	00009517          	auipc	a0,0x9
ffffffffc0203c0c:	e8050513          	addi	a0,a0,-384 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203c10:	e1efc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c14:	86a2                	mv	a3,s0
ffffffffc0203c16:	00009617          	auipc	a2,0x9
ffffffffc0203c1a:	97a60613          	addi	a2,a2,-1670 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0203c1e:	28b00593          	li	a1,651
ffffffffc0203c22:	00009517          	auipc	a0,0x9
ffffffffc0203c26:	e6650513          	addi	a0,a0,-410 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203c2a:	e04fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c2e:	00009697          	auipc	a3,0x9
ffffffffc0203c32:	36268693          	addi	a3,a3,866 # ffffffffc020cf90 <default_pmm_manager+0x568>
ffffffffc0203c36:	00008617          	auipc	a2,0x8
ffffffffc0203c3a:	fe260613          	addi	a2,a2,-30 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203c3e:	28c00593          	li	a1,652
ffffffffc0203c42:	00009517          	auipc	a0,0x9
ffffffffc0203c46:	e4650513          	addi	a0,a0,-442 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203c4a:	de4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c4e:	db5fe0ef          	jal	ra,ffffffffc0202a02 <pa2page.part.0>
ffffffffc0203c52:	00009697          	auipc	a3,0x9
ffffffffc0203c56:	16668693          	addi	a3,a3,358 # ffffffffc020cdb8 <default_pmm_manager+0x390>
ffffffffc0203c5a:	00008617          	auipc	a2,0x8
ffffffffc0203c5e:	fbe60613          	addi	a2,a2,-66 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203c62:	26800593          	li	a1,616
ffffffffc0203c66:	00009517          	auipc	a0,0x9
ffffffffc0203c6a:	e2250513          	addi	a0,a0,-478 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203c6e:	dc0fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c72:	00009697          	auipc	a3,0x9
ffffffffc0203c76:	3a668693          	addi	a3,a3,934 # ffffffffc020d018 <default_pmm_manager+0x5f0>
ffffffffc0203c7a:	00008617          	auipc	a2,0x8
ffffffffc0203c7e:	f9e60613          	addi	a2,a2,-98 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203c82:	29500593          	li	a1,661
ffffffffc0203c86:	00009517          	auipc	a0,0x9
ffffffffc0203c8a:	e0250513          	addi	a0,a0,-510 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203c8e:	da0fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c92:	00009697          	auipc	a3,0x9
ffffffffc0203c96:	24668693          	addi	a3,a3,582 # ffffffffc020ced8 <default_pmm_manager+0x4b0>
ffffffffc0203c9a:	00008617          	auipc	a2,0x8
ffffffffc0203c9e:	f7e60613          	addi	a2,a2,-130 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203ca2:	27400593          	li	a1,628
ffffffffc0203ca6:	00009517          	auipc	a0,0x9
ffffffffc0203caa:	de250513          	addi	a0,a0,-542 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203cae:	d80fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cb2:	00009697          	auipc	a3,0x9
ffffffffc0203cb6:	1f668693          	addi	a3,a3,502 # ffffffffc020cea8 <default_pmm_manager+0x480>
ffffffffc0203cba:	00008617          	auipc	a2,0x8
ffffffffc0203cbe:	f5e60613          	addi	a2,a2,-162 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203cc2:	26a00593          	li	a1,618
ffffffffc0203cc6:	00009517          	auipc	a0,0x9
ffffffffc0203cca:	dc250513          	addi	a0,a0,-574 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203cce:	d60fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cd2:	00009697          	auipc	a3,0x9
ffffffffc0203cd6:	04668693          	addi	a3,a3,70 # ffffffffc020cd18 <default_pmm_manager+0x2f0>
ffffffffc0203cda:	00008617          	auipc	a2,0x8
ffffffffc0203cde:	f3e60613          	addi	a2,a2,-194 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203ce2:	26900593          	li	a1,617
ffffffffc0203ce6:	00009517          	auipc	a0,0x9
ffffffffc0203cea:	da250513          	addi	a0,a0,-606 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203cee:	d40fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cf2:	00009697          	auipc	a3,0x9
ffffffffc0203cf6:	19e68693          	addi	a3,a3,414 # ffffffffc020ce90 <default_pmm_manager+0x468>
ffffffffc0203cfa:	00008617          	auipc	a2,0x8
ffffffffc0203cfe:	f1e60613          	addi	a2,a2,-226 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203d02:	26e00593          	li	a1,622
ffffffffc0203d06:	00009517          	auipc	a0,0x9
ffffffffc0203d0a:	d8250513          	addi	a0,a0,-638 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203d0e:	d20fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d12:	00009697          	auipc	a3,0x9
ffffffffc0203d16:	01e68693          	addi	a3,a3,30 # ffffffffc020cd30 <default_pmm_manager+0x308>
ffffffffc0203d1a:	00008617          	auipc	a2,0x8
ffffffffc0203d1e:	efe60613          	addi	a2,a2,-258 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203d22:	26d00593          	li	a1,621
ffffffffc0203d26:	00009517          	auipc	a0,0x9
ffffffffc0203d2a:	d6250513          	addi	a0,a0,-670 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203d2e:	d00fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d32:	00009697          	auipc	a3,0x9
ffffffffc0203d36:	27668693          	addi	a3,a3,630 # ffffffffc020cfa8 <default_pmm_manager+0x580>
ffffffffc0203d3a:	00008617          	auipc	a2,0x8
ffffffffc0203d3e:	ede60613          	addi	a2,a2,-290 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203d42:	28f00593          	li	a1,655
ffffffffc0203d46:	00009517          	auipc	a0,0x9
ffffffffc0203d4a:	d4250513          	addi	a0,a0,-702 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203d4e:	ce0fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d52:	00009697          	auipc	a3,0x9
ffffffffc0203d56:	2ae68693          	addi	a3,a3,686 # ffffffffc020d000 <default_pmm_manager+0x5d8>
ffffffffc0203d5a:	00008617          	auipc	a2,0x8
ffffffffc0203d5e:	ebe60613          	addi	a2,a2,-322 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203d62:	29400593          	li	a1,660
ffffffffc0203d66:	00009517          	auipc	a0,0x9
ffffffffc0203d6a:	d2250513          	addi	a0,a0,-734 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203d6e:	cc0fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d72:	00009697          	auipc	a3,0x9
ffffffffc0203d76:	24e68693          	addi	a3,a3,590 # ffffffffc020cfc0 <default_pmm_manager+0x598>
ffffffffc0203d7a:	00008617          	auipc	a2,0x8
ffffffffc0203d7e:	e9e60613          	addi	a2,a2,-354 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203d82:	29300593          	li	a1,659
ffffffffc0203d86:	00009517          	auipc	a0,0x9
ffffffffc0203d8a:	d0250513          	addi	a0,a0,-766 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203d8e:	ca0fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d92:	00009697          	auipc	a3,0x9
ffffffffc0203d96:	33668693          	addi	a3,a3,822 # ffffffffc020d0c8 <default_pmm_manager+0x6a0>
ffffffffc0203d9a:	00008617          	auipc	a2,0x8
ffffffffc0203d9e:	e7e60613          	addi	a2,a2,-386 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203da2:	29d00593          	li	a1,669
ffffffffc0203da6:	00009517          	auipc	a0,0x9
ffffffffc0203daa:	ce250513          	addi	a0,a0,-798 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203dae:	c80fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203db2:	00009697          	auipc	a3,0x9
ffffffffc0203db6:	2de68693          	addi	a3,a3,734 # ffffffffc020d090 <default_pmm_manager+0x668>
ffffffffc0203dba:	00008617          	auipc	a2,0x8
ffffffffc0203dbe:	e5e60613          	addi	a2,a2,-418 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203dc2:	29a00593          	li	a1,666
ffffffffc0203dc6:	00009517          	auipc	a0,0x9
ffffffffc0203dca:	cc250513          	addi	a0,a0,-830 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203dce:	c60fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203dd2:	00009697          	auipc	a3,0x9
ffffffffc0203dd6:	28e68693          	addi	a3,a3,654 # ffffffffc020d060 <default_pmm_manager+0x638>
ffffffffc0203dda:	00008617          	auipc	a2,0x8
ffffffffc0203dde:	e3e60613          	addi	a2,a2,-450 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203de2:	29600593          	li	a1,662
ffffffffc0203de6:	00009517          	auipc	a0,0x9
ffffffffc0203dea:	ca250513          	addi	a0,a0,-862 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203dee:	c40fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203df2:	86a2                	mv	a3,s0
ffffffffc0203df4:	00009617          	auipc	a2,0x9
ffffffffc0203df8:	84460613          	addi	a2,a2,-1980 # ffffffffc020c638 <commands+0xc70>
ffffffffc0203dfc:	0dd00593          	li	a1,221
ffffffffc0203e00:	00009517          	auipc	a0,0x9
ffffffffc0203e04:	c8850513          	addi	a0,a0,-888 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203e08:	c26fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e0c:	86ae                	mv	a3,a1
ffffffffc0203e0e:	00009617          	auipc	a2,0x9
ffffffffc0203e12:	82a60613          	addi	a2,a2,-2006 # ffffffffc020c638 <commands+0xc70>
ffffffffc0203e16:	0dc00593          	li	a1,220
ffffffffc0203e1a:	00009517          	auipc	a0,0x9
ffffffffc0203e1e:	c6e50513          	addi	a0,a0,-914 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203e22:	c0cfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e26:	00009697          	auipc	a3,0x9
ffffffffc0203e2a:	e2268693          	addi	a3,a3,-478 # ffffffffc020cc48 <default_pmm_manager+0x220>
ffffffffc0203e2e:	00008617          	auipc	a2,0x8
ffffffffc0203e32:	dea60613          	addi	a2,a2,-534 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203e36:	24d00593          	li	a1,589
ffffffffc0203e3a:	00009517          	auipc	a0,0x9
ffffffffc0203e3e:	c4e50513          	addi	a0,a0,-946 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203e42:	becfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e46:	00009697          	auipc	a3,0x9
ffffffffc0203e4a:	de268693          	addi	a3,a3,-542 # ffffffffc020cc28 <default_pmm_manager+0x200>
ffffffffc0203e4e:	00008617          	auipc	a2,0x8
ffffffffc0203e52:	dca60613          	addi	a2,a2,-566 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203e56:	24c00593          	li	a1,588
ffffffffc0203e5a:	00009517          	auipc	a0,0x9
ffffffffc0203e5e:	c2e50513          	addi	a0,a0,-978 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203e62:	bccfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e66:	00009617          	auipc	a2,0x9
ffffffffc0203e6a:	d5260613          	addi	a2,a2,-686 # ffffffffc020cbb8 <default_pmm_manager+0x190>
ffffffffc0203e6e:	0ab00593          	li	a1,171
ffffffffc0203e72:	00009517          	auipc	a0,0x9
ffffffffc0203e76:	c1650513          	addi	a0,a0,-1002 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203e7a:	bb4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e7e:	00009617          	auipc	a2,0x9
ffffffffc0203e82:	ca260613          	addi	a2,a2,-862 # ffffffffc020cb20 <default_pmm_manager+0xf8>
ffffffffc0203e86:	06600593          	li	a1,102
ffffffffc0203e8a:	00009517          	auipc	a0,0x9
ffffffffc0203e8e:	bfe50513          	addi	a0,a0,-1026 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203e92:	b9cfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e96:	00009697          	auipc	a3,0x9
ffffffffc0203e9a:	07268693          	addi	a3,a3,114 # ffffffffc020cf08 <default_pmm_manager+0x4e0>
ffffffffc0203e9e:	00008617          	auipc	a2,0x8
ffffffffc0203ea2:	d7a60613          	addi	a2,a2,-646 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203ea6:	2a600593          	li	a1,678
ffffffffc0203eaa:	00009517          	auipc	a0,0x9
ffffffffc0203eae:	bde50513          	addi	a0,a0,-1058 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203eb2:	b7cfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203eb6:	00009697          	auipc	a3,0x9
ffffffffc0203eba:	e9268693          	addi	a3,a3,-366 # ffffffffc020cd48 <default_pmm_manager+0x320>
ffffffffc0203ebe:	00008617          	auipc	a2,0x8
ffffffffc0203ec2:	d5a60613          	addi	a2,a2,-678 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203ec6:	25b00593          	li	a1,603
ffffffffc0203eca:	00009517          	auipc	a0,0x9
ffffffffc0203ece:	bbe50513          	addi	a0,a0,-1090 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203ed2:	b5cfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203ed6:	86d6                	mv	a3,s5
ffffffffc0203ed8:	00008617          	auipc	a2,0x8
ffffffffc0203edc:	6b860613          	addi	a2,a2,1720 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0203ee0:	25a00593          	li	a1,602
ffffffffc0203ee4:	00009517          	auipc	a0,0x9
ffffffffc0203ee8:	ba450513          	addi	a0,a0,-1116 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203eec:	b42fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203ef0:	00009697          	auipc	a3,0x9
ffffffffc0203ef4:	fa068693          	addi	a3,a3,-96 # ffffffffc020ce90 <default_pmm_manager+0x468>
ffffffffc0203ef8:	00008617          	auipc	a2,0x8
ffffffffc0203efc:	d2060613          	addi	a2,a2,-736 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203f00:	26700593          	li	a1,615
ffffffffc0203f04:	00009517          	auipc	a0,0x9
ffffffffc0203f08:	b8450513          	addi	a0,a0,-1148 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203f0c:	b22fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f10:	00009697          	auipc	a3,0x9
ffffffffc0203f14:	f6868693          	addi	a3,a3,-152 # ffffffffc020ce78 <default_pmm_manager+0x450>
ffffffffc0203f18:	00008617          	auipc	a2,0x8
ffffffffc0203f1c:	d0060613          	addi	a2,a2,-768 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203f20:	26600593          	li	a1,614
ffffffffc0203f24:	00009517          	auipc	a0,0x9
ffffffffc0203f28:	b6450513          	addi	a0,a0,-1180 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203f2c:	b02fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f30:	00009697          	auipc	a3,0x9
ffffffffc0203f34:	f1868693          	addi	a3,a3,-232 # ffffffffc020ce48 <default_pmm_manager+0x420>
ffffffffc0203f38:	00008617          	auipc	a2,0x8
ffffffffc0203f3c:	ce060613          	addi	a2,a2,-800 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203f40:	26500593          	li	a1,613
ffffffffc0203f44:	00009517          	auipc	a0,0x9
ffffffffc0203f48:	b4450513          	addi	a0,a0,-1212 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203f4c:	ae2fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f50:	00009697          	auipc	a3,0x9
ffffffffc0203f54:	ee068693          	addi	a3,a3,-288 # ffffffffc020ce30 <default_pmm_manager+0x408>
ffffffffc0203f58:	00008617          	auipc	a2,0x8
ffffffffc0203f5c:	cc060613          	addi	a2,a2,-832 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203f60:	26300593          	li	a1,611
ffffffffc0203f64:	00009517          	auipc	a0,0x9
ffffffffc0203f68:	b2450513          	addi	a0,a0,-1244 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203f6c:	ac2fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f70:	00009697          	auipc	a3,0x9
ffffffffc0203f74:	ea068693          	addi	a3,a3,-352 # ffffffffc020ce10 <default_pmm_manager+0x3e8>
ffffffffc0203f78:	00008617          	auipc	a2,0x8
ffffffffc0203f7c:	ca060613          	addi	a2,a2,-864 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203f80:	26200593          	li	a1,610
ffffffffc0203f84:	00009517          	auipc	a0,0x9
ffffffffc0203f88:	b0450513          	addi	a0,a0,-1276 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203f8c:	aa2fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f90:	00009697          	auipc	a3,0x9
ffffffffc0203f94:	e7068693          	addi	a3,a3,-400 # ffffffffc020ce00 <default_pmm_manager+0x3d8>
ffffffffc0203f98:	00008617          	auipc	a2,0x8
ffffffffc0203f9c:	c8060613          	addi	a2,a2,-896 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203fa0:	26100593          	li	a1,609
ffffffffc0203fa4:	00009517          	auipc	a0,0x9
ffffffffc0203fa8:	ae450513          	addi	a0,a0,-1308 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203fac:	a82fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fb0:	00009697          	auipc	a3,0x9
ffffffffc0203fb4:	e4068693          	addi	a3,a3,-448 # ffffffffc020cdf0 <default_pmm_manager+0x3c8>
ffffffffc0203fb8:	00008617          	auipc	a2,0x8
ffffffffc0203fbc:	c6060613          	addi	a2,a2,-928 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203fc0:	26000593          	li	a1,608
ffffffffc0203fc4:	00009517          	auipc	a0,0x9
ffffffffc0203fc8:	ac450513          	addi	a0,a0,-1340 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203fcc:	a62fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fd0:	00009697          	auipc	a3,0x9
ffffffffc0203fd4:	de868693          	addi	a3,a3,-536 # ffffffffc020cdb8 <default_pmm_manager+0x390>
ffffffffc0203fd8:	00008617          	auipc	a2,0x8
ffffffffc0203fdc:	c4060613          	addi	a2,a2,-960 # ffffffffc020bc18 <commands+0x250>
ffffffffc0203fe0:	25f00593          	li	a1,607
ffffffffc0203fe4:	00009517          	auipc	a0,0x9
ffffffffc0203fe8:	aa450513          	addi	a0,a0,-1372 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0203fec:	a42fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203ff0:	00009697          	auipc	a3,0x9
ffffffffc0203ff4:	f1868693          	addi	a3,a3,-232 # ffffffffc020cf08 <default_pmm_manager+0x4e0>
ffffffffc0203ff8:	00008617          	auipc	a2,0x8
ffffffffc0203ffc:	c2060613          	addi	a2,a2,-992 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204000:	27c00593          	li	a1,636
ffffffffc0204004:	00009517          	auipc	a0,0x9
ffffffffc0204008:	a8450513          	addi	a0,a0,-1404 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020400c:	a22fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204010:	00008617          	auipc	a2,0x8
ffffffffc0204014:	58060613          	addi	a2,a2,1408 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0204018:	07100593          	li	a1,113
ffffffffc020401c:	00008517          	auipc	a0,0x8
ffffffffc0204020:	59c50513          	addi	a0,a0,1436 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0204024:	a0afc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204028:	86a2                	mv	a3,s0
ffffffffc020402a:	00008617          	auipc	a2,0x8
ffffffffc020402e:	60e60613          	addi	a2,a2,1550 # ffffffffc020c638 <commands+0xc70>
ffffffffc0204032:	0cb00593          	li	a1,203
ffffffffc0204036:	00009517          	auipc	a0,0x9
ffffffffc020403a:	a5250513          	addi	a0,a0,-1454 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020403e:	9f0fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204042:	00008617          	auipc	a2,0x8
ffffffffc0204046:	5f660613          	addi	a2,a2,1526 # ffffffffc020c638 <commands+0xc70>
ffffffffc020404a:	08200593          	li	a1,130
ffffffffc020404e:	00009517          	auipc	a0,0x9
ffffffffc0204052:	a3a50513          	addi	a0,a0,-1478 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0204056:	9d8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020405a:	00009697          	auipc	a3,0x9
ffffffffc020405e:	d1e68693          	addi	a3,a3,-738 # ffffffffc020cd78 <default_pmm_manager+0x350>
ffffffffc0204062:	00008617          	auipc	a2,0x8
ffffffffc0204066:	bb660613          	addi	a2,a2,-1098 # ffffffffc020bc18 <commands+0x250>
ffffffffc020406a:	25e00593          	li	a1,606
ffffffffc020406e:	00009517          	auipc	a0,0x9
ffffffffc0204072:	a1a50513          	addi	a0,a0,-1510 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0204076:	9b8fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020407a:	00009697          	auipc	a3,0x9
ffffffffc020407e:	c3e68693          	addi	a3,a3,-962 # ffffffffc020ccb8 <default_pmm_manager+0x290>
ffffffffc0204082:	00008617          	auipc	a2,0x8
ffffffffc0204086:	b9660613          	addi	a2,a2,-1130 # ffffffffc020bc18 <commands+0x250>
ffffffffc020408a:	25200593          	li	a1,594
ffffffffc020408e:	00009517          	auipc	a0,0x9
ffffffffc0204092:	9fa50513          	addi	a0,a0,-1542 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0204096:	998fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020409a:	985fe0ef          	jal	ra,ffffffffc0202a1e <pte2page.part.0>
ffffffffc020409e:	00009697          	auipc	a3,0x9
ffffffffc02040a2:	c4a68693          	addi	a3,a3,-950 # ffffffffc020cce8 <default_pmm_manager+0x2c0>
ffffffffc02040a6:	00008617          	auipc	a2,0x8
ffffffffc02040aa:	b7260613          	addi	a2,a2,-1166 # ffffffffc020bc18 <commands+0x250>
ffffffffc02040ae:	25500593          	li	a1,597
ffffffffc02040b2:	00009517          	auipc	a0,0x9
ffffffffc02040b6:	9d650513          	addi	a0,a0,-1578 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02040ba:	974fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040be:	00009697          	auipc	a3,0x9
ffffffffc02040c2:	bca68693          	addi	a3,a3,-1078 # ffffffffc020cc88 <default_pmm_manager+0x260>
ffffffffc02040c6:	00008617          	auipc	a2,0x8
ffffffffc02040ca:	b5260613          	addi	a2,a2,-1198 # ffffffffc020bc18 <commands+0x250>
ffffffffc02040ce:	24e00593          	li	a1,590
ffffffffc02040d2:	00009517          	auipc	a0,0x9
ffffffffc02040d6:	9b650513          	addi	a0,a0,-1610 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02040da:	954fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040de:	00009697          	auipc	a3,0x9
ffffffffc02040e2:	c3a68693          	addi	a3,a3,-966 # ffffffffc020cd18 <default_pmm_manager+0x2f0>
ffffffffc02040e6:	00008617          	auipc	a2,0x8
ffffffffc02040ea:	b3260613          	addi	a2,a2,-1230 # ffffffffc020bc18 <commands+0x250>
ffffffffc02040ee:	25600593          	li	a1,598
ffffffffc02040f2:	00009517          	auipc	a0,0x9
ffffffffc02040f6:	99650513          	addi	a0,a0,-1642 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02040fa:	934fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040fe:	00008617          	auipc	a2,0x8
ffffffffc0204102:	49260613          	addi	a2,a2,1170 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0204106:	25900593          	li	a1,601
ffffffffc020410a:	00009517          	auipc	a0,0x9
ffffffffc020410e:	97e50513          	addi	a0,a0,-1666 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0204112:	91cfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204116:	00009697          	auipc	a3,0x9
ffffffffc020411a:	c1a68693          	addi	a3,a3,-998 # ffffffffc020cd30 <default_pmm_manager+0x308>
ffffffffc020411e:	00008617          	auipc	a2,0x8
ffffffffc0204122:	afa60613          	addi	a2,a2,-1286 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204126:	25700593          	li	a1,599
ffffffffc020412a:	00009517          	auipc	a0,0x9
ffffffffc020412e:	95e50513          	addi	a0,a0,-1698 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc0204132:	8fcfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204136:	86ca                	mv	a3,s2
ffffffffc0204138:	00008617          	auipc	a2,0x8
ffffffffc020413c:	50060613          	addi	a2,a2,1280 # ffffffffc020c638 <commands+0xc70>
ffffffffc0204140:	0c700593          	li	a1,199
ffffffffc0204144:	00009517          	auipc	a0,0x9
ffffffffc0204148:	94450513          	addi	a0,a0,-1724 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020414c:	8e2fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204150:	00009697          	auipc	a3,0x9
ffffffffc0204154:	d4068693          	addi	a3,a3,-704 # ffffffffc020ce90 <default_pmm_manager+0x468>
ffffffffc0204158:	00008617          	auipc	a2,0x8
ffffffffc020415c:	ac060613          	addi	a2,a2,-1344 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204160:	27200593          	li	a1,626
ffffffffc0204164:	00009517          	auipc	a0,0x9
ffffffffc0204168:	92450513          	addi	a0,a0,-1756 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020416c:	8c2fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204170:	00009697          	auipc	a3,0x9
ffffffffc0204174:	d5068693          	addi	a3,a3,-688 # ffffffffc020cec0 <default_pmm_manager+0x498>
ffffffffc0204178:	00008617          	auipc	a2,0x8
ffffffffc020417c:	aa060613          	addi	a2,a2,-1376 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204180:	27100593          	li	a1,625
ffffffffc0204184:	00009517          	auipc	a0,0x9
ffffffffc0204188:	90450513          	addi	a0,a0,-1788 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020418c:	8a2fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204190 <copy_range>:
ffffffffc0204190:	7159                	addi	sp,sp,-112
ffffffffc0204192:	00d667b3          	or	a5,a2,a3
ffffffffc0204196:	f486                	sd	ra,104(sp)
ffffffffc0204198:	f0a2                	sd	s0,96(sp)
ffffffffc020419a:	eca6                	sd	s1,88(sp)
ffffffffc020419c:	e8ca                	sd	s2,80(sp)
ffffffffc020419e:	e4ce                	sd	s3,72(sp)
ffffffffc02041a0:	e0d2                	sd	s4,64(sp)
ffffffffc02041a2:	fc56                	sd	s5,56(sp)
ffffffffc02041a4:	f85a                	sd	s6,48(sp)
ffffffffc02041a6:	f45e                	sd	s7,40(sp)
ffffffffc02041a8:	f062                	sd	s8,32(sp)
ffffffffc02041aa:	ec66                	sd	s9,24(sp)
ffffffffc02041ac:	e86a                	sd	s10,16(sp)
ffffffffc02041ae:	e46e                	sd	s11,8(sp)
ffffffffc02041b0:	17d2                	slli	a5,a5,0x34
ffffffffc02041b2:	20079f63          	bnez	a5,ffffffffc02043d0 <copy_range+0x240>
ffffffffc02041b6:	002007b7          	lui	a5,0x200
ffffffffc02041ba:	8432                	mv	s0,a2
ffffffffc02041bc:	1af66263          	bltu	a2,a5,ffffffffc0204360 <copy_range+0x1d0>
ffffffffc02041c0:	8936                	mv	s2,a3
ffffffffc02041c2:	18d67f63          	bgeu	a2,a3,ffffffffc0204360 <copy_range+0x1d0>
ffffffffc02041c6:	4785                	li	a5,1
ffffffffc02041c8:	07fe                	slli	a5,a5,0x1f
ffffffffc02041ca:	18d7eb63          	bltu	a5,a3,ffffffffc0204360 <copy_range+0x1d0>
ffffffffc02041ce:	5b7d                	li	s6,-1
ffffffffc02041d0:	8aaa                	mv	s5,a0
ffffffffc02041d2:	89ae                	mv	s3,a1
ffffffffc02041d4:	6a05                	lui	s4,0x1
ffffffffc02041d6:	00092c17          	auipc	s8,0x92
ffffffffc02041da:	6cac0c13          	addi	s8,s8,1738 # ffffffffc02968a0 <npage>
ffffffffc02041de:	00092b97          	auipc	s7,0x92
ffffffffc02041e2:	6cab8b93          	addi	s7,s7,1738 # ffffffffc02968a8 <pages>
ffffffffc02041e6:	00cb5b13          	srli	s6,s6,0xc
ffffffffc02041ea:	00092c97          	auipc	s9,0x92
ffffffffc02041ee:	6c6c8c93          	addi	s9,s9,1734 # ffffffffc02968b0 <pmm_manager>
ffffffffc02041f2:	4601                	li	a2,0
ffffffffc02041f4:	85a2                	mv	a1,s0
ffffffffc02041f6:	854e                	mv	a0,s3
ffffffffc02041f8:	8fbfe0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc02041fc:	84aa                	mv	s1,a0
ffffffffc02041fe:	0e050c63          	beqz	a0,ffffffffc02042f6 <copy_range+0x166>
ffffffffc0204202:	611c                	ld	a5,0(a0)
ffffffffc0204204:	8b85                	andi	a5,a5,1
ffffffffc0204206:	e785                	bnez	a5,ffffffffc020422e <copy_range+0x9e>
ffffffffc0204208:	9452                	add	s0,s0,s4
ffffffffc020420a:	ff2464e3          	bltu	s0,s2,ffffffffc02041f2 <copy_range+0x62>
ffffffffc020420e:	4501                	li	a0,0
ffffffffc0204210:	70a6                	ld	ra,104(sp)
ffffffffc0204212:	7406                	ld	s0,96(sp)
ffffffffc0204214:	64e6                	ld	s1,88(sp)
ffffffffc0204216:	6946                	ld	s2,80(sp)
ffffffffc0204218:	69a6                	ld	s3,72(sp)
ffffffffc020421a:	6a06                	ld	s4,64(sp)
ffffffffc020421c:	7ae2                	ld	s5,56(sp)
ffffffffc020421e:	7b42                	ld	s6,48(sp)
ffffffffc0204220:	7ba2                	ld	s7,40(sp)
ffffffffc0204222:	7c02                	ld	s8,32(sp)
ffffffffc0204224:	6ce2                	ld	s9,24(sp)
ffffffffc0204226:	6d42                	ld	s10,16(sp)
ffffffffc0204228:	6da2                	ld	s11,8(sp)
ffffffffc020422a:	6165                	addi	sp,sp,112
ffffffffc020422c:	8082                	ret
ffffffffc020422e:	4605                	li	a2,1
ffffffffc0204230:	85a2                	mv	a1,s0
ffffffffc0204232:	8556                	mv	a0,s5
ffffffffc0204234:	8bffe0ef          	jal	ra,ffffffffc0202af2 <get_pte>
ffffffffc0204238:	c56d                	beqz	a0,ffffffffc0204322 <copy_range+0x192>
ffffffffc020423a:	609c                	ld	a5,0(s1)
ffffffffc020423c:	0017f713          	andi	a4,a5,1
ffffffffc0204240:	01f7f493          	andi	s1,a5,31
ffffffffc0204244:	16070a63          	beqz	a4,ffffffffc02043b8 <copy_range+0x228>
ffffffffc0204248:	000c3683          	ld	a3,0(s8)
ffffffffc020424c:	078a                	slli	a5,a5,0x2
ffffffffc020424e:	00c7d713          	srli	a4,a5,0xc
ffffffffc0204252:	14d77763          	bgeu	a4,a3,ffffffffc02043a0 <copy_range+0x210>
ffffffffc0204256:	000bb783          	ld	a5,0(s7)
ffffffffc020425a:	fff806b7          	lui	a3,0xfff80
ffffffffc020425e:	9736                	add	a4,a4,a3
ffffffffc0204260:	071a                	slli	a4,a4,0x6
ffffffffc0204262:	00e78db3          	add	s11,a5,a4
ffffffffc0204266:	10002773          	csrr	a4,sstatus
ffffffffc020426a:	8b09                	andi	a4,a4,2
ffffffffc020426c:	e345                	bnez	a4,ffffffffc020430c <copy_range+0x17c>
ffffffffc020426e:	000cb703          	ld	a4,0(s9)
ffffffffc0204272:	4505                	li	a0,1
ffffffffc0204274:	6f18                	ld	a4,24(a4)
ffffffffc0204276:	9702                	jalr	a4
ffffffffc0204278:	8d2a                	mv	s10,a0
ffffffffc020427a:	0c0d8363          	beqz	s11,ffffffffc0204340 <copy_range+0x1b0>
ffffffffc020427e:	100d0163          	beqz	s10,ffffffffc0204380 <copy_range+0x1f0>
ffffffffc0204282:	000bb703          	ld	a4,0(s7)
ffffffffc0204286:	000805b7          	lui	a1,0x80
ffffffffc020428a:	000c3603          	ld	a2,0(s8)
ffffffffc020428e:	40ed86b3          	sub	a3,s11,a4
ffffffffc0204292:	8699                	srai	a3,a3,0x6
ffffffffc0204294:	96ae                	add	a3,a3,a1
ffffffffc0204296:	0166f7b3          	and	a5,a3,s6
ffffffffc020429a:	06b2                	slli	a3,a3,0xc
ffffffffc020429c:	08c7f663          	bgeu	a5,a2,ffffffffc0204328 <copy_range+0x198>
ffffffffc02042a0:	40ed07b3          	sub	a5,s10,a4
ffffffffc02042a4:	00092717          	auipc	a4,0x92
ffffffffc02042a8:	61470713          	addi	a4,a4,1556 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02042ac:	6308                	ld	a0,0(a4)
ffffffffc02042ae:	8799                	srai	a5,a5,0x6
ffffffffc02042b0:	97ae                	add	a5,a5,a1
ffffffffc02042b2:	0167f733          	and	a4,a5,s6
ffffffffc02042b6:	00a685b3          	add	a1,a3,a0
ffffffffc02042ba:	07b2                	slli	a5,a5,0xc
ffffffffc02042bc:	06c77563          	bgeu	a4,a2,ffffffffc0204326 <copy_range+0x196>
ffffffffc02042c0:	6605                	lui	a2,0x1
ffffffffc02042c2:	953e                	add	a0,a0,a5
ffffffffc02042c4:	7ad060ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc02042c8:	86a6                	mv	a3,s1
ffffffffc02042ca:	8622                	mv	a2,s0
ffffffffc02042cc:	85ea                	mv	a1,s10
ffffffffc02042ce:	8556                	mv	a0,s5
ffffffffc02042d0:	fd9fe0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc02042d4:	d915                	beqz	a0,ffffffffc0204208 <copy_range+0x78>
ffffffffc02042d6:	00009697          	auipc	a3,0x9
ffffffffc02042da:	e5a68693          	addi	a3,a3,-422 # ffffffffc020d130 <default_pmm_manager+0x708>
ffffffffc02042de:	00008617          	auipc	a2,0x8
ffffffffc02042e2:	93a60613          	addi	a2,a2,-1734 # ffffffffc020bc18 <commands+0x250>
ffffffffc02042e6:	1ea00593          	li	a1,490
ffffffffc02042ea:	00008517          	auipc	a0,0x8
ffffffffc02042ee:	79e50513          	addi	a0,a0,1950 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02042f2:	f3dfb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02042f6:	00200637          	lui	a2,0x200
ffffffffc02042fa:	9432                	add	s0,s0,a2
ffffffffc02042fc:	ffe00637          	lui	a2,0xffe00
ffffffffc0204300:	8c71                	and	s0,s0,a2
ffffffffc0204302:	f00406e3          	beqz	s0,ffffffffc020420e <copy_range+0x7e>
ffffffffc0204306:	ef2466e3          	bltu	s0,s2,ffffffffc02041f2 <copy_range+0x62>
ffffffffc020430a:	b711                	j	ffffffffc020420e <copy_range+0x7e>
ffffffffc020430c:	a95fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0204310:	000cb703          	ld	a4,0(s9)
ffffffffc0204314:	4505                	li	a0,1
ffffffffc0204316:	6f18                	ld	a4,24(a4)
ffffffffc0204318:	9702                	jalr	a4
ffffffffc020431a:	8d2a                	mv	s10,a0
ffffffffc020431c:	a7ffc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0204320:	bfa9                	j	ffffffffc020427a <copy_range+0xea>
ffffffffc0204322:	5571                	li	a0,-4
ffffffffc0204324:	b5f5                	j	ffffffffc0204210 <copy_range+0x80>
ffffffffc0204326:	86be                	mv	a3,a5
ffffffffc0204328:	00008617          	auipc	a2,0x8
ffffffffc020432c:	26860613          	addi	a2,a2,616 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0204330:	07100593          	li	a1,113
ffffffffc0204334:	00008517          	auipc	a0,0x8
ffffffffc0204338:	28450513          	addi	a0,a0,644 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc020433c:	ef3fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204340:	00009697          	auipc	a3,0x9
ffffffffc0204344:	dd068693          	addi	a3,a3,-560 # ffffffffc020d110 <default_pmm_manager+0x6e8>
ffffffffc0204348:	00008617          	auipc	a2,0x8
ffffffffc020434c:	8d060613          	addi	a2,a2,-1840 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204350:	1cf00593          	li	a1,463
ffffffffc0204354:	00008517          	auipc	a0,0x8
ffffffffc0204358:	73450513          	addi	a0,a0,1844 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020435c:	ed3fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204360:	00008697          	auipc	a3,0x8
ffffffffc0204364:	79068693          	addi	a3,a3,1936 # ffffffffc020caf0 <default_pmm_manager+0xc8>
ffffffffc0204368:	00008617          	auipc	a2,0x8
ffffffffc020436c:	8b060613          	addi	a2,a2,-1872 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204370:	1b700593          	li	a1,439
ffffffffc0204374:	00008517          	auipc	a0,0x8
ffffffffc0204378:	71450513          	addi	a0,a0,1812 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020437c:	eb3fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204380:	00009697          	auipc	a3,0x9
ffffffffc0204384:	da068693          	addi	a3,a3,-608 # ffffffffc020d120 <default_pmm_manager+0x6f8>
ffffffffc0204388:	00008617          	auipc	a2,0x8
ffffffffc020438c:	89060613          	addi	a2,a2,-1904 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204390:	1d000593          	li	a1,464
ffffffffc0204394:	00008517          	auipc	a0,0x8
ffffffffc0204398:	6f450513          	addi	a0,a0,1780 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc020439c:	e93fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02043a0:	00008617          	auipc	a2,0x8
ffffffffc02043a4:	2c060613          	addi	a2,a2,704 # ffffffffc020c660 <commands+0xc98>
ffffffffc02043a8:	06900593          	li	a1,105
ffffffffc02043ac:	00008517          	auipc	a0,0x8
ffffffffc02043b0:	20c50513          	addi	a0,a0,524 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc02043b4:	e7bfb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02043b8:	00008617          	auipc	a2,0x8
ffffffffc02043bc:	6a860613          	addi	a2,a2,1704 # ffffffffc020ca60 <default_pmm_manager+0x38>
ffffffffc02043c0:	07f00593          	li	a1,127
ffffffffc02043c4:	00008517          	auipc	a0,0x8
ffffffffc02043c8:	1f450513          	addi	a0,a0,500 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc02043cc:	e63fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02043d0:	00008697          	auipc	a3,0x8
ffffffffc02043d4:	6f068693          	addi	a3,a3,1776 # ffffffffc020cac0 <default_pmm_manager+0x98>
ffffffffc02043d8:	00008617          	auipc	a2,0x8
ffffffffc02043dc:	84060613          	addi	a2,a2,-1984 # ffffffffc020bc18 <commands+0x250>
ffffffffc02043e0:	1b600593          	li	a1,438
ffffffffc02043e4:	00008517          	auipc	a0,0x8
ffffffffc02043e8:	6a450513          	addi	a0,a0,1700 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02043ec:	e43fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02043f0 <pgdir_alloc_page>:
ffffffffc02043f0:	7179                	addi	sp,sp,-48
ffffffffc02043f2:	ec26                	sd	s1,24(sp)
ffffffffc02043f4:	e84a                	sd	s2,16(sp)
ffffffffc02043f6:	e052                	sd	s4,0(sp)
ffffffffc02043f8:	f406                	sd	ra,40(sp)
ffffffffc02043fa:	f022                	sd	s0,32(sp)
ffffffffc02043fc:	e44e                	sd	s3,8(sp)
ffffffffc02043fe:	8a2a                	mv	s4,a0
ffffffffc0204400:	84ae                	mv	s1,a1
ffffffffc0204402:	8932                	mv	s2,a2
ffffffffc0204404:	100027f3          	csrr	a5,sstatus
ffffffffc0204408:	8b89                	andi	a5,a5,2
ffffffffc020440a:	00092997          	auipc	s3,0x92
ffffffffc020440e:	4a698993          	addi	s3,s3,1190 # ffffffffc02968b0 <pmm_manager>
ffffffffc0204412:	ef8d                	bnez	a5,ffffffffc020444c <pgdir_alloc_page+0x5c>
ffffffffc0204414:	0009b783          	ld	a5,0(s3)
ffffffffc0204418:	4505                	li	a0,1
ffffffffc020441a:	6f9c                	ld	a5,24(a5)
ffffffffc020441c:	9782                	jalr	a5
ffffffffc020441e:	842a                	mv	s0,a0
ffffffffc0204420:	cc09                	beqz	s0,ffffffffc020443a <pgdir_alloc_page+0x4a>
ffffffffc0204422:	86ca                	mv	a3,s2
ffffffffc0204424:	8626                	mv	a2,s1
ffffffffc0204426:	85a2                	mv	a1,s0
ffffffffc0204428:	8552                	mv	a0,s4
ffffffffc020442a:	e7ffe0ef          	jal	ra,ffffffffc02032a8 <page_insert>
ffffffffc020442e:	e915                	bnez	a0,ffffffffc0204462 <pgdir_alloc_page+0x72>
ffffffffc0204430:	4018                	lw	a4,0(s0)
ffffffffc0204432:	fc04                	sd	s1,56(s0)
ffffffffc0204434:	4785                	li	a5,1
ffffffffc0204436:	04f71e63          	bne	a4,a5,ffffffffc0204492 <pgdir_alloc_page+0xa2>
ffffffffc020443a:	70a2                	ld	ra,40(sp)
ffffffffc020443c:	8522                	mv	a0,s0
ffffffffc020443e:	7402                	ld	s0,32(sp)
ffffffffc0204440:	64e2                	ld	s1,24(sp)
ffffffffc0204442:	6942                	ld	s2,16(sp)
ffffffffc0204444:	69a2                	ld	s3,8(sp)
ffffffffc0204446:	6a02                	ld	s4,0(sp)
ffffffffc0204448:	6145                	addi	sp,sp,48
ffffffffc020444a:	8082                	ret
ffffffffc020444c:	955fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0204450:	0009b783          	ld	a5,0(s3)
ffffffffc0204454:	4505                	li	a0,1
ffffffffc0204456:	6f9c                	ld	a5,24(a5)
ffffffffc0204458:	9782                	jalr	a5
ffffffffc020445a:	842a                	mv	s0,a0
ffffffffc020445c:	93ffc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0204460:	b7c1                	j	ffffffffc0204420 <pgdir_alloc_page+0x30>
ffffffffc0204462:	100027f3          	csrr	a5,sstatus
ffffffffc0204466:	8b89                	andi	a5,a5,2
ffffffffc0204468:	eb89                	bnez	a5,ffffffffc020447a <pgdir_alloc_page+0x8a>
ffffffffc020446a:	0009b783          	ld	a5,0(s3)
ffffffffc020446e:	8522                	mv	a0,s0
ffffffffc0204470:	4585                	li	a1,1
ffffffffc0204472:	739c                	ld	a5,32(a5)
ffffffffc0204474:	4401                	li	s0,0
ffffffffc0204476:	9782                	jalr	a5
ffffffffc0204478:	b7c9                	j	ffffffffc020443a <pgdir_alloc_page+0x4a>
ffffffffc020447a:	927fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020447e:	0009b783          	ld	a5,0(s3)
ffffffffc0204482:	8522                	mv	a0,s0
ffffffffc0204484:	4585                	li	a1,1
ffffffffc0204486:	739c                	ld	a5,32(a5)
ffffffffc0204488:	4401                	li	s0,0
ffffffffc020448a:	9782                	jalr	a5
ffffffffc020448c:	90ffc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0204490:	b76d                	j	ffffffffc020443a <pgdir_alloc_page+0x4a>
ffffffffc0204492:	00009697          	auipc	a3,0x9
ffffffffc0204496:	cae68693          	addi	a3,a3,-850 # ffffffffc020d140 <default_pmm_manager+0x718>
ffffffffc020449a:	00007617          	auipc	a2,0x7
ffffffffc020449e:	77e60613          	addi	a2,a2,1918 # ffffffffc020bc18 <commands+0x250>
ffffffffc02044a2:	23300593          	li	a1,563
ffffffffc02044a6:	00008517          	auipc	a0,0x8
ffffffffc02044aa:	5e250513          	addi	a0,a0,1506 # ffffffffc020ca88 <default_pmm_manager+0x60>
ffffffffc02044ae:	d81fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02044b2 <wait_queue_init>:
ffffffffc02044b2:	e508                	sd	a0,8(a0)
ffffffffc02044b4:	e108                	sd	a0,0(a0)
ffffffffc02044b6:	8082                	ret

ffffffffc02044b8 <wait_queue_del>:
ffffffffc02044b8:	7198                	ld	a4,32(a1)
ffffffffc02044ba:	01858793          	addi	a5,a1,24 # 80018 <_binary_bin_sfs_img_size+0xad18>
ffffffffc02044be:	00e78b63          	beq	a5,a4,ffffffffc02044d4 <wait_queue_del+0x1c>
ffffffffc02044c2:	6994                	ld	a3,16(a1)
ffffffffc02044c4:	00a69863          	bne	a3,a0,ffffffffc02044d4 <wait_queue_del+0x1c>
ffffffffc02044c8:	6d94                	ld	a3,24(a1)
ffffffffc02044ca:	e698                	sd	a4,8(a3)
ffffffffc02044cc:	e314                	sd	a3,0(a4)
ffffffffc02044ce:	f19c                	sd	a5,32(a1)
ffffffffc02044d0:	ed9c                	sd	a5,24(a1)
ffffffffc02044d2:	8082                	ret
ffffffffc02044d4:	1141                	addi	sp,sp,-16
ffffffffc02044d6:	00009697          	auipc	a3,0x9
ffffffffc02044da:	cd268693          	addi	a3,a3,-814 # ffffffffc020d1a8 <default_pmm_manager+0x780>
ffffffffc02044de:	00007617          	auipc	a2,0x7
ffffffffc02044e2:	73a60613          	addi	a2,a2,1850 # ffffffffc020bc18 <commands+0x250>
ffffffffc02044e6:	45f1                	li	a1,28
ffffffffc02044e8:	00009517          	auipc	a0,0x9
ffffffffc02044ec:	ca850513          	addi	a0,a0,-856 # ffffffffc020d190 <default_pmm_manager+0x768>
ffffffffc02044f0:	e406                	sd	ra,8(sp)
ffffffffc02044f2:	d3dfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02044f6 <wait_queue_first>:
ffffffffc02044f6:	651c                	ld	a5,8(a0)
ffffffffc02044f8:	00f50563          	beq	a0,a5,ffffffffc0204502 <wait_queue_first+0xc>
ffffffffc02044fc:	fe878513          	addi	a0,a5,-24 # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0204500:	8082                	ret
ffffffffc0204502:	4501                	li	a0,0
ffffffffc0204504:	8082                	ret

ffffffffc0204506 <wait_queue_empty>:
ffffffffc0204506:	651c                	ld	a5,8(a0)
ffffffffc0204508:	40a78533          	sub	a0,a5,a0
ffffffffc020450c:	00153513          	seqz	a0,a0
ffffffffc0204510:	8082                	ret

ffffffffc0204512 <wait_in_queue>:
ffffffffc0204512:	711c                	ld	a5,32(a0)
ffffffffc0204514:	0561                	addi	a0,a0,24
ffffffffc0204516:	40a78533          	sub	a0,a5,a0
ffffffffc020451a:	00a03533          	snez	a0,a0
ffffffffc020451e:	8082                	ret

ffffffffc0204520 <wakeup_wait>:
ffffffffc0204520:	e689                	bnez	a3,ffffffffc020452a <wakeup_wait+0xa>
ffffffffc0204522:	6188                	ld	a0,0(a1)
ffffffffc0204524:	c590                	sw	a2,8(a1)
ffffffffc0204526:	5df0206f          	j	ffffffffc0207304 <wakeup_proc>
ffffffffc020452a:	7198                	ld	a4,32(a1)
ffffffffc020452c:	01858793          	addi	a5,a1,24
ffffffffc0204530:	00e78e63          	beq	a5,a4,ffffffffc020454c <wakeup_wait+0x2c>
ffffffffc0204534:	6994                	ld	a3,16(a1)
ffffffffc0204536:	00d51b63          	bne	a0,a3,ffffffffc020454c <wakeup_wait+0x2c>
ffffffffc020453a:	6d94                	ld	a3,24(a1)
ffffffffc020453c:	6188                	ld	a0,0(a1)
ffffffffc020453e:	e698                	sd	a4,8(a3)
ffffffffc0204540:	e314                	sd	a3,0(a4)
ffffffffc0204542:	f19c                	sd	a5,32(a1)
ffffffffc0204544:	ed9c                	sd	a5,24(a1)
ffffffffc0204546:	c590                	sw	a2,8(a1)
ffffffffc0204548:	5bd0206f          	j	ffffffffc0207304 <wakeup_proc>
ffffffffc020454c:	1141                	addi	sp,sp,-16
ffffffffc020454e:	00009697          	auipc	a3,0x9
ffffffffc0204552:	c5a68693          	addi	a3,a3,-934 # ffffffffc020d1a8 <default_pmm_manager+0x780>
ffffffffc0204556:	00007617          	auipc	a2,0x7
ffffffffc020455a:	6c260613          	addi	a2,a2,1730 # ffffffffc020bc18 <commands+0x250>
ffffffffc020455e:	45f1                	li	a1,28
ffffffffc0204560:	00009517          	auipc	a0,0x9
ffffffffc0204564:	c3050513          	addi	a0,a0,-976 # ffffffffc020d190 <default_pmm_manager+0x768>
ffffffffc0204568:	e406                	sd	ra,8(sp)
ffffffffc020456a:	cc5fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020456e <wakeup_queue>:
ffffffffc020456e:	651c                	ld	a5,8(a0)
ffffffffc0204570:	0ca78563          	beq	a5,a0,ffffffffc020463a <wakeup_queue+0xcc>
ffffffffc0204574:	1101                	addi	sp,sp,-32
ffffffffc0204576:	e822                	sd	s0,16(sp)
ffffffffc0204578:	e426                	sd	s1,8(sp)
ffffffffc020457a:	e04a                	sd	s2,0(sp)
ffffffffc020457c:	ec06                	sd	ra,24(sp)
ffffffffc020457e:	84aa                	mv	s1,a0
ffffffffc0204580:	892e                	mv	s2,a1
ffffffffc0204582:	fe878413          	addi	s0,a5,-24
ffffffffc0204586:	e23d                	bnez	a2,ffffffffc02045ec <wakeup_queue+0x7e>
ffffffffc0204588:	6008                	ld	a0,0(s0)
ffffffffc020458a:	01242423          	sw	s2,8(s0)
ffffffffc020458e:	577020ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc0204592:	701c                	ld	a5,32(s0)
ffffffffc0204594:	01840713          	addi	a4,s0,24
ffffffffc0204598:	02e78463          	beq	a5,a4,ffffffffc02045c0 <wakeup_queue+0x52>
ffffffffc020459c:	6818                	ld	a4,16(s0)
ffffffffc020459e:	02e49163          	bne	s1,a4,ffffffffc02045c0 <wakeup_queue+0x52>
ffffffffc02045a2:	02f48f63          	beq	s1,a5,ffffffffc02045e0 <wakeup_queue+0x72>
ffffffffc02045a6:	fe87b503          	ld	a0,-24(a5)
ffffffffc02045aa:	ff27a823          	sw	s2,-16(a5)
ffffffffc02045ae:	fe878413          	addi	s0,a5,-24
ffffffffc02045b2:	553020ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc02045b6:	701c                	ld	a5,32(s0)
ffffffffc02045b8:	01840713          	addi	a4,s0,24
ffffffffc02045bc:	fee790e3          	bne	a5,a4,ffffffffc020459c <wakeup_queue+0x2e>
ffffffffc02045c0:	00009697          	auipc	a3,0x9
ffffffffc02045c4:	be868693          	addi	a3,a3,-1048 # ffffffffc020d1a8 <default_pmm_manager+0x780>
ffffffffc02045c8:	00007617          	auipc	a2,0x7
ffffffffc02045cc:	65060613          	addi	a2,a2,1616 # ffffffffc020bc18 <commands+0x250>
ffffffffc02045d0:	02200593          	li	a1,34
ffffffffc02045d4:	00009517          	auipc	a0,0x9
ffffffffc02045d8:	bbc50513          	addi	a0,a0,-1092 # ffffffffc020d190 <default_pmm_manager+0x768>
ffffffffc02045dc:	c53fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02045e0:	60e2                	ld	ra,24(sp)
ffffffffc02045e2:	6442                	ld	s0,16(sp)
ffffffffc02045e4:	64a2                	ld	s1,8(sp)
ffffffffc02045e6:	6902                	ld	s2,0(sp)
ffffffffc02045e8:	6105                	addi	sp,sp,32
ffffffffc02045ea:	8082                	ret
ffffffffc02045ec:	6798                	ld	a4,8(a5)
ffffffffc02045ee:	02f70763          	beq	a4,a5,ffffffffc020461c <wakeup_queue+0xae>
ffffffffc02045f2:	6814                	ld	a3,16(s0)
ffffffffc02045f4:	02d49463          	bne	s1,a3,ffffffffc020461c <wakeup_queue+0xae>
ffffffffc02045f8:	6c14                	ld	a3,24(s0)
ffffffffc02045fa:	6008                	ld	a0,0(s0)
ffffffffc02045fc:	e698                	sd	a4,8(a3)
ffffffffc02045fe:	e314                	sd	a3,0(a4)
ffffffffc0204600:	f01c                	sd	a5,32(s0)
ffffffffc0204602:	ec1c                	sd	a5,24(s0)
ffffffffc0204604:	01242423          	sw	s2,8(s0)
ffffffffc0204608:	4fd020ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc020460c:	6480                	ld	s0,8(s1)
ffffffffc020460e:	fc8489e3          	beq	s1,s0,ffffffffc02045e0 <wakeup_queue+0x72>
ffffffffc0204612:	6418                	ld	a4,8(s0)
ffffffffc0204614:	87a2                	mv	a5,s0
ffffffffc0204616:	1421                	addi	s0,s0,-24
ffffffffc0204618:	fce79de3          	bne	a5,a4,ffffffffc02045f2 <wakeup_queue+0x84>
ffffffffc020461c:	00009697          	auipc	a3,0x9
ffffffffc0204620:	b8c68693          	addi	a3,a3,-1140 # ffffffffc020d1a8 <default_pmm_manager+0x780>
ffffffffc0204624:	00007617          	auipc	a2,0x7
ffffffffc0204628:	5f460613          	addi	a2,a2,1524 # ffffffffc020bc18 <commands+0x250>
ffffffffc020462c:	45f1                	li	a1,28
ffffffffc020462e:	00009517          	auipc	a0,0x9
ffffffffc0204632:	b6250513          	addi	a0,a0,-1182 # ffffffffc020d190 <default_pmm_manager+0x768>
ffffffffc0204636:	bf9fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020463a:	8082                	ret

ffffffffc020463c <wait_current_set>:
ffffffffc020463c:	00092797          	auipc	a5,0x92
ffffffffc0204640:	2847b783          	ld	a5,644(a5) # ffffffffc02968c0 <current>
ffffffffc0204644:	c39d                	beqz	a5,ffffffffc020466a <wait_current_set+0x2e>
ffffffffc0204646:	01858713          	addi	a4,a1,24
ffffffffc020464a:	800006b7          	lui	a3,0x80000
ffffffffc020464e:	ed98                	sd	a4,24(a1)
ffffffffc0204650:	e19c                	sd	a5,0(a1)
ffffffffc0204652:	c594                	sw	a3,8(a1)
ffffffffc0204654:	4685                	li	a3,1
ffffffffc0204656:	c394                	sw	a3,0(a5)
ffffffffc0204658:	0ec7a623          	sw	a2,236(a5)
ffffffffc020465c:	611c                	ld	a5,0(a0)
ffffffffc020465e:	e988                	sd	a0,16(a1)
ffffffffc0204660:	e118                	sd	a4,0(a0)
ffffffffc0204662:	e798                	sd	a4,8(a5)
ffffffffc0204664:	f188                	sd	a0,32(a1)
ffffffffc0204666:	ed9c                	sd	a5,24(a1)
ffffffffc0204668:	8082                	ret
ffffffffc020466a:	1141                	addi	sp,sp,-16
ffffffffc020466c:	00009697          	auipc	a3,0x9
ffffffffc0204670:	b7c68693          	addi	a3,a3,-1156 # ffffffffc020d1e8 <default_pmm_manager+0x7c0>
ffffffffc0204674:	00007617          	auipc	a2,0x7
ffffffffc0204678:	5a460613          	addi	a2,a2,1444 # ffffffffc020bc18 <commands+0x250>
ffffffffc020467c:	07400593          	li	a1,116
ffffffffc0204680:	00009517          	auipc	a0,0x9
ffffffffc0204684:	b1050513          	addi	a0,a0,-1264 # ffffffffc020d190 <default_pmm_manager+0x768>
ffffffffc0204688:	e406                	sd	ra,8(sp)
ffffffffc020468a:	ba5fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020468e <__down.constprop.0>:
ffffffffc020468e:	715d                	addi	sp,sp,-80
ffffffffc0204690:	e0a2                	sd	s0,64(sp)
ffffffffc0204692:	e486                	sd	ra,72(sp)
ffffffffc0204694:	fc26                	sd	s1,56(sp)
ffffffffc0204696:	842a                	mv	s0,a0
ffffffffc0204698:	100027f3          	csrr	a5,sstatus
ffffffffc020469c:	8b89                	andi	a5,a5,2
ffffffffc020469e:	ebb1                	bnez	a5,ffffffffc02046f2 <__down.constprop.0+0x64>
ffffffffc02046a0:	411c                	lw	a5,0(a0)
ffffffffc02046a2:	00f05a63          	blez	a5,ffffffffc02046b6 <__down.constprop.0+0x28>
ffffffffc02046a6:	37fd                	addiw	a5,a5,-1
ffffffffc02046a8:	c11c                	sw	a5,0(a0)
ffffffffc02046aa:	4501                	li	a0,0
ffffffffc02046ac:	60a6                	ld	ra,72(sp)
ffffffffc02046ae:	6406                	ld	s0,64(sp)
ffffffffc02046b0:	74e2                	ld	s1,56(sp)
ffffffffc02046b2:	6161                	addi	sp,sp,80
ffffffffc02046b4:	8082                	ret
ffffffffc02046b6:	00850413          	addi	s0,a0,8
ffffffffc02046ba:	0024                	addi	s1,sp,8
ffffffffc02046bc:	10000613          	li	a2,256
ffffffffc02046c0:	85a6                	mv	a1,s1
ffffffffc02046c2:	8522                	mv	a0,s0
ffffffffc02046c4:	f79ff0ef          	jal	ra,ffffffffc020463c <wait_current_set>
ffffffffc02046c8:	4ef020ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc02046cc:	100027f3          	csrr	a5,sstatus
ffffffffc02046d0:	8b89                	andi	a5,a5,2
ffffffffc02046d2:	efb9                	bnez	a5,ffffffffc0204730 <__down.constprop.0+0xa2>
ffffffffc02046d4:	8526                	mv	a0,s1
ffffffffc02046d6:	e3dff0ef          	jal	ra,ffffffffc0204512 <wait_in_queue>
ffffffffc02046da:	e531                	bnez	a0,ffffffffc0204726 <__down.constprop.0+0x98>
ffffffffc02046dc:	4542                	lw	a0,16(sp)
ffffffffc02046de:	10000793          	li	a5,256
ffffffffc02046e2:	fcf515e3          	bne	a0,a5,ffffffffc02046ac <__down.constprop.0+0x1e>
ffffffffc02046e6:	60a6                	ld	ra,72(sp)
ffffffffc02046e8:	6406                	ld	s0,64(sp)
ffffffffc02046ea:	74e2                	ld	s1,56(sp)
ffffffffc02046ec:	4501                	li	a0,0
ffffffffc02046ee:	6161                	addi	sp,sp,80
ffffffffc02046f0:	8082                	ret
ffffffffc02046f2:	eaefc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02046f6:	401c                	lw	a5,0(s0)
ffffffffc02046f8:	00f05c63          	blez	a5,ffffffffc0204710 <__down.constprop.0+0x82>
ffffffffc02046fc:	37fd                	addiw	a5,a5,-1
ffffffffc02046fe:	c01c                	sw	a5,0(s0)
ffffffffc0204700:	e9afc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0204704:	60a6                	ld	ra,72(sp)
ffffffffc0204706:	6406                	ld	s0,64(sp)
ffffffffc0204708:	74e2                	ld	s1,56(sp)
ffffffffc020470a:	4501                	li	a0,0
ffffffffc020470c:	6161                	addi	sp,sp,80
ffffffffc020470e:	8082                	ret
ffffffffc0204710:	0421                	addi	s0,s0,8
ffffffffc0204712:	0024                	addi	s1,sp,8
ffffffffc0204714:	10000613          	li	a2,256
ffffffffc0204718:	85a6                	mv	a1,s1
ffffffffc020471a:	8522                	mv	a0,s0
ffffffffc020471c:	f21ff0ef          	jal	ra,ffffffffc020463c <wait_current_set>
ffffffffc0204720:	e7afc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0204724:	b755                	j	ffffffffc02046c8 <__down.constprop.0+0x3a>
ffffffffc0204726:	85a6                	mv	a1,s1
ffffffffc0204728:	8522                	mv	a0,s0
ffffffffc020472a:	d8fff0ef          	jal	ra,ffffffffc02044b8 <wait_queue_del>
ffffffffc020472e:	b77d                	j	ffffffffc02046dc <__down.constprop.0+0x4e>
ffffffffc0204730:	e70fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0204734:	8526                	mv	a0,s1
ffffffffc0204736:	dddff0ef          	jal	ra,ffffffffc0204512 <wait_in_queue>
ffffffffc020473a:	e501                	bnez	a0,ffffffffc0204742 <__down.constprop.0+0xb4>
ffffffffc020473c:	e5efc0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0204740:	bf71                	j	ffffffffc02046dc <__down.constprop.0+0x4e>
ffffffffc0204742:	85a6                	mv	a1,s1
ffffffffc0204744:	8522                	mv	a0,s0
ffffffffc0204746:	d73ff0ef          	jal	ra,ffffffffc02044b8 <wait_queue_del>
ffffffffc020474a:	bfcd                	j	ffffffffc020473c <__down.constprop.0+0xae>

ffffffffc020474c <__up.constprop.0>:
ffffffffc020474c:	1101                	addi	sp,sp,-32
ffffffffc020474e:	e822                	sd	s0,16(sp)
ffffffffc0204750:	ec06                	sd	ra,24(sp)
ffffffffc0204752:	e426                	sd	s1,8(sp)
ffffffffc0204754:	e04a                	sd	s2,0(sp)
ffffffffc0204756:	842a                	mv	s0,a0
ffffffffc0204758:	100027f3          	csrr	a5,sstatus
ffffffffc020475c:	8b89                	andi	a5,a5,2
ffffffffc020475e:	4901                	li	s2,0
ffffffffc0204760:	eba1                	bnez	a5,ffffffffc02047b0 <__up.constprop.0+0x64>
ffffffffc0204762:	00840493          	addi	s1,s0,8
ffffffffc0204766:	8526                	mv	a0,s1
ffffffffc0204768:	d8fff0ef          	jal	ra,ffffffffc02044f6 <wait_queue_first>
ffffffffc020476c:	85aa                	mv	a1,a0
ffffffffc020476e:	cd0d                	beqz	a0,ffffffffc02047a8 <__up.constprop.0+0x5c>
ffffffffc0204770:	6118                	ld	a4,0(a0)
ffffffffc0204772:	10000793          	li	a5,256
ffffffffc0204776:	0ec72703          	lw	a4,236(a4)
ffffffffc020477a:	02f71f63          	bne	a4,a5,ffffffffc02047b8 <__up.constprop.0+0x6c>
ffffffffc020477e:	4685                	li	a3,1
ffffffffc0204780:	10000613          	li	a2,256
ffffffffc0204784:	8526                	mv	a0,s1
ffffffffc0204786:	d9bff0ef          	jal	ra,ffffffffc0204520 <wakeup_wait>
ffffffffc020478a:	00091863          	bnez	s2,ffffffffc020479a <__up.constprop.0+0x4e>
ffffffffc020478e:	60e2                	ld	ra,24(sp)
ffffffffc0204790:	6442                	ld	s0,16(sp)
ffffffffc0204792:	64a2                	ld	s1,8(sp)
ffffffffc0204794:	6902                	ld	s2,0(sp)
ffffffffc0204796:	6105                	addi	sp,sp,32
ffffffffc0204798:	8082                	ret
ffffffffc020479a:	6442                	ld	s0,16(sp)
ffffffffc020479c:	60e2                	ld	ra,24(sp)
ffffffffc020479e:	64a2                	ld	s1,8(sp)
ffffffffc02047a0:	6902                	ld	s2,0(sp)
ffffffffc02047a2:	6105                	addi	sp,sp,32
ffffffffc02047a4:	df6fc06f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc02047a8:	401c                	lw	a5,0(s0)
ffffffffc02047aa:	2785                	addiw	a5,a5,1
ffffffffc02047ac:	c01c                	sw	a5,0(s0)
ffffffffc02047ae:	bff1                	j	ffffffffc020478a <__up.constprop.0+0x3e>
ffffffffc02047b0:	df0fc0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02047b4:	4905                	li	s2,1
ffffffffc02047b6:	b775                	j	ffffffffc0204762 <__up.constprop.0+0x16>
ffffffffc02047b8:	00009697          	auipc	a3,0x9
ffffffffc02047bc:	a4068693          	addi	a3,a3,-1472 # ffffffffc020d1f8 <default_pmm_manager+0x7d0>
ffffffffc02047c0:	00007617          	auipc	a2,0x7
ffffffffc02047c4:	45860613          	addi	a2,a2,1112 # ffffffffc020bc18 <commands+0x250>
ffffffffc02047c8:	45e5                	li	a1,25
ffffffffc02047ca:	00009517          	auipc	a0,0x9
ffffffffc02047ce:	a5650513          	addi	a0,a0,-1450 # ffffffffc020d220 <default_pmm_manager+0x7f8>
ffffffffc02047d2:	a5dfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02047d6 <sem_init>:
ffffffffc02047d6:	c10c                	sw	a1,0(a0)
ffffffffc02047d8:	0521                	addi	a0,a0,8
ffffffffc02047da:	cd9ff06f          	j	ffffffffc02044b2 <wait_queue_init>

ffffffffc02047de <up>:
ffffffffc02047de:	f6fff06f          	j	ffffffffc020474c <__up.constprop.0>

ffffffffc02047e2 <down>:
ffffffffc02047e2:	1141                	addi	sp,sp,-16
ffffffffc02047e4:	e406                	sd	ra,8(sp)
ffffffffc02047e6:	ea9ff0ef          	jal	ra,ffffffffc020468e <__down.constprop.0>
ffffffffc02047ea:	2501                	sext.w	a0,a0
ffffffffc02047ec:	e501                	bnez	a0,ffffffffc02047f4 <down+0x12>
ffffffffc02047ee:	60a2                	ld	ra,8(sp)
ffffffffc02047f0:	0141                	addi	sp,sp,16
ffffffffc02047f2:	8082                	ret
ffffffffc02047f4:	00009697          	auipc	a3,0x9
ffffffffc02047f8:	a3c68693          	addi	a3,a3,-1476 # ffffffffc020d230 <default_pmm_manager+0x808>
ffffffffc02047fc:	00007617          	auipc	a2,0x7
ffffffffc0204800:	41c60613          	addi	a2,a2,1052 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204804:	04000593          	li	a1,64
ffffffffc0204808:	00009517          	auipc	a0,0x9
ffffffffc020480c:	a1850513          	addi	a0,a0,-1512 # ffffffffc020d220 <default_pmm_manager+0x7f8>
ffffffffc0204810:	a1ffb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204814 <copy_path>:
ffffffffc0204814:	7139                	addi	sp,sp,-64
ffffffffc0204816:	f04a                	sd	s2,32(sp)
ffffffffc0204818:	00092917          	auipc	s2,0x92
ffffffffc020481c:	0a890913          	addi	s2,s2,168 # ffffffffc02968c0 <current>
ffffffffc0204820:	00093703          	ld	a4,0(s2)
ffffffffc0204824:	ec4e                	sd	s3,24(sp)
ffffffffc0204826:	89aa                	mv	s3,a0
ffffffffc0204828:	6505                	lui	a0,0x1
ffffffffc020482a:	f426                	sd	s1,40(sp)
ffffffffc020482c:	e852                	sd	s4,16(sp)
ffffffffc020482e:	fc06                	sd	ra,56(sp)
ffffffffc0204830:	f822                	sd	s0,48(sp)
ffffffffc0204832:	e456                	sd	s5,8(sp)
ffffffffc0204834:	02873a03          	ld	s4,40(a4)
ffffffffc0204838:	84ae                	mv	s1,a1
ffffffffc020483a:	d74fd0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020483e:	c141                	beqz	a0,ffffffffc02048be <copy_path+0xaa>
ffffffffc0204840:	842a                	mv	s0,a0
ffffffffc0204842:	040a0563          	beqz	s4,ffffffffc020488c <copy_path+0x78>
ffffffffc0204846:	038a0a93          	addi	s5,s4,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc020484a:	8556                	mv	a0,s5
ffffffffc020484c:	f97ff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204850:	00093783          	ld	a5,0(s2)
ffffffffc0204854:	cba1                	beqz	a5,ffffffffc02048a4 <copy_path+0x90>
ffffffffc0204856:	43dc                	lw	a5,4(a5)
ffffffffc0204858:	6685                	lui	a3,0x1
ffffffffc020485a:	8626                	mv	a2,s1
ffffffffc020485c:	04fa2823          	sw	a5,80(s4)
ffffffffc0204860:	85a2                	mv	a1,s0
ffffffffc0204862:	8552                	mv	a0,s4
ffffffffc0204864:	a92fd0ef          	jal	ra,ffffffffc0201af6 <copy_string>
ffffffffc0204868:	c529                	beqz	a0,ffffffffc02048b2 <copy_path+0x9e>
ffffffffc020486a:	8556                	mv	a0,s5
ffffffffc020486c:	f73ff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204870:	040a2823          	sw	zero,80(s4)
ffffffffc0204874:	0089b023          	sd	s0,0(s3)
ffffffffc0204878:	4501                	li	a0,0
ffffffffc020487a:	70e2                	ld	ra,56(sp)
ffffffffc020487c:	7442                	ld	s0,48(sp)
ffffffffc020487e:	74a2                	ld	s1,40(sp)
ffffffffc0204880:	7902                	ld	s2,32(sp)
ffffffffc0204882:	69e2                	ld	s3,24(sp)
ffffffffc0204884:	6a42                	ld	s4,16(sp)
ffffffffc0204886:	6aa2                	ld	s5,8(sp)
ffffffffc0204888:	6121                	addi	sp,sp,64
ffffffffc020488a:	8082                	ret
ffffffffc020488c:	85aa                	mv	a1,a0
ffffffffc020488e:	6685                	lui	a3,0x1
ffffffffc0204890:	8626                	mv	a2,s1
ffffffffc0204892:	4501                	li	a0,0
ffffffffc0204894:	a62fd0ef          	jal	ra,ffffffffc0201af6 <copy_string>
ffffffffc0204898:	fd71                	bnez	a0,ffffffffc0204874 <copy_path+0x60>
ffffffffc020489a:	8522                	mv	a0,s0
ffffffffc020489c:	dc2fd0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02048a0:	5575                	li	a0,-3
ffffffffc02048a2:	bfe1                	j	ffffffffc020487a <copy_path+0x66>
ffffffffc02048a4:	6685                	lui	a3,0x1
ffffffffc02048a6:	8626                	mv	a2,s1
ffffffffc02048a8:	85a2                	mv	a1,s0
ffffffffc02048aa:	8552                	mv	a0,s4
ffffffffc02048ac:	a4afd0ef          	jal	ra,ffffffffc0201af6 <copy_string>
ffffffffc02048b0:	fd4d                	bnez	a0,ffffffffc020486a <copy_path+0x56>
ffffffffc02048b2:	8556                	mv	a0,s5
ffffffffc02048b4:	f2bff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc02048b8:	040a2823          	sw	zero,80(s4)
ffffffffc02048bc:	bff9                	j	ffffffffc020489a <copy_path+0x86>
ffffffffc02048be:	5571                	li	a0,-4
ffffffffc02048c0:	bf6d                	j	ffffffffc020487a <copy_path+0x66>

ffffffffc02048c2 <sysfile_open>:
ffffffffc02048c2:	7179                	addi	sp,sp,-48
ffffffffc02048c4:	872a                	mv	a4,a0
ffffffffc02048c6:	ec26                	sd	s1,24(sp)
ffffffffc02048c8:	0028                	addi	a0,sp,8
ffffffffc02048ca:	84ae                	mv	s1,a1
ffffffffc02048cc:	85ba                	mv	a1,a4
ffffffffc02048ce:	f022                	sd	s0,32(sp)
ffffffffc02048d0:	f406                	sd	ra,40(sp)
ffffffffc02048d2:	f43ff0ef          	jal	ra,ffffffffc0204814 <copy_path>
ffffffffc02048d6:	842a                	mv	s0,a0
ffffffffc02048d8:	e909                	bnez	a0,ffffffffc02048ea <sysfile_open+0x28>
ffffffffc02048da:	6522                	ld	a0,8(sp)
ffffffffc02048dc:	85a6                	mv	a1,s1
ffffffffc02048de:	7ba000ef          	jal	ra,ffffffffc0205098 <file_open>
ffffffffc02048e2:	842a                	mv	s0,a0
ffffffffc02048e4:	6522                	ld	a0,8(sp)
ffffffffc02048e6:	d78fd0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02048ea:	70a2                	ld	ra,40(sp)
ffffffffc02048ec:	8522                	mv	a0,s0
ffffffffc02048ee:	7402                	ld	s0,32(sp)
ffffffffc02048f0:	64e2                	ld	s1,24(sp)
ffffffffc02048f2:	6145                	addi	sp,sp,48
ffffffffc02048f4:	8082                	ret

ffffffffc02048f6 <sysfile_close>:
ffffffffc02048f6:	0a10006f          	j	ffffffffc0205196 <file_close>

ffffffffc02048fa <sysfile_read>:
ffffffffc02048fa:	7159                	addi	sp,sp,-112
ffffffffc02048fc:	f0a2                	sd	s0,96(sp)
ffffffffc02048fe:	f486                	sd	ra,104(sp)
ffffffffc0204900:	eca6                	sd	s1,88(sp)
ffffffffc0204902:	e8ca                	sd	s2,80(sp)
ffffffffc0204904:	e4ce                	sd	s3,72(sp)
ffffffffc0204906:	e0d2                	sd	s4,64(sp)
ffffffffc0204908:	fc56                	sd	s5,56(sp)
ffffffffc020490a:	f85a                	sd	s6,48(sp)
ffffffffc020490c:	f45e                	sd	s7,40(sp)
ffffffffc020490e:	f062                	sd	s8,32(sp)
ffffffffc0204910:	ec66                	sd	s9,24(sp)
ffffffffc0204912:	4401                	li	s0,0
ffffffffc0204914:	ee19                	bnez	a2,ffffffffc0204932 <sysfile_read+0x38>
ffffffffc0204916:	70a6                	ld	ra,104(sp)
ffffffffc0204918:	8522                	mv	a0,s0
ffffffffc020491a:	7406                	ld	s0,96(sp)
ffffffffc020491c:	64e6                	ld	s1,88(sp)
ffffffffc020491e:	6946                	ld	s2,80(sp)
ffffffffc0204920:	69a6                	ld	s3,72(sp)
ffffffffc0204922:	6a06                	ld	s4,64(sp)
ffffffffc0204924:	7ae2                	ld	s5,56(sp)
ffffffffc0204926:	7b42                	ld	s6,48(sp)
ffffffffc0204928:	7ba2                	ld	s7,40(sp)
ffffffffc020492a:	7c02                	ld	s8,32(sp)
ffffffffc020492c:	6ce2                	ld	s9,24(sp)
ffffffffc020492e:	6165                	addi	sp,sp,112
ffffffffc0204930:	8082                	ret
ffffffffc0204932:	00092c97          	auipc	s9,0x92
ffffffffc0204936:	f8ec8c93          	addi	s9,s9,-114 # ffffffffc02968c0 <current>
ffffffffc020493a:	000cb783          	ld	a5,0(s9)
ffffffffc020493e:	84b2                	mv	s1,a2
ffffffffc0204940:	8b2e                	mv	s6,a1
ffffffffc0204942:	4601                	li	a2,0
ffffffffc0204944:	4585                	li	a1,1
ffffffffc0204946:	0287b903          	ld	s2,40(a5)
ffffffffc020494a:	8aaa                	mv	s5,a0
ffffffffc020494c:	6f8000ef          	jal	ra,ffffffffc0205044 <file_testfd>
ffffffffc0204950:	c959                	beqz	a0,ffffffffc02049e6 <sysfile_read+0xec>
ffffffffc0204952:	6505                	lui	a0,0x1
ffffffffc0204954:	c5afd0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0204958:	89aa                	mv	s3,a0
ffffffffc020495a:	c941                	beqz	a0,ffffffffc02049ea <sysfile_read+0xf0>
ffffffffc020495c:	4b81                	li	s7,0
ffffffffc020495e:	6a05                	lui	s4,0x1
ffffffffc0204960:	03890c13          	addi	s8,s2,56
ffffffffc0204964:	0744ec63          	bltu	s1,s4,ffffffffc02049dc <sysfile_read+0xe2>
ffffffffc0204968:	e452                	sd	s4,8(sp)
ffffffffc020496a:	6605                	lui	a2,0x1
ffffffffc020496c:	0034                	addi	a3,sp,8
ffffffffc020496e:	85ce                	mv	a1,s3
ffffffffc0204970:	8556                	mv	a0,s5
ffffffffc0204972:	07b000ef          	jal	ra,ffffffffc02051ec <file_read>
ffffffffc0204976:	66a2                	ld	a3,8(sp)
ffffffffc0204978:	842a                	mv	s0,a0
ffffffffc020497a:	ca9d                	beqz	a3,ffffffffc02049b0 <sysfile_read+0xb6>
ffffffffc020497c:	00090c63          	beqz	s2,ffffffffc0204994 <sysfile_read+0x9a>
ffffffffc0204980:	8562                	mv	a0,s8
ffffffffc0204982:	e61ff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204986:	000cb783          	ld	a5,0(s9)
ffffffffc020498a:	cfa1                	beqz	a5,ffffffffc02049e2 <sysfile_read+0xe8>
ffffffffc020498c:	43dc                	lw	a5,4(a5)
ffffffffc020498e:	66a2                	ld	a3,8(sp)
ffffffffc0204990:	04f92823          	sw	a5,80(s2)
ffffffffc0204994:	864e                	mv	a2,s3
ffffffffc0204996:	85da                	mv	a1,s6
ffffffffc0204998:	854a                	mv	a0,s2
ffffffffc020499a:	92afd0ef          	jal	ra,ffffffffc0201ac4 <copy_to_user>
ffffffffc020499e:	c50d                	beqz	a0,ffffffffc02049c8 <sysfile_read+0xce>
ffffffffc02049a0:	67a2                	ld	a5,8(sp)
ffffffffc02049a2:	04f4e663          	bltu	s1,a5,ffffffffc02049ee <sysfile_read+0xf4>
ffffffffc02049a6:	9b3e                	add	s6,s6,a5
ffffffffc02049a8:	8c9d                	sub	s1,s1,a5
ffffffffc02049aa:	9bbe                	add	s7,s7,a5
ffffffffc02049ac:	02091263          	bnez	s2,ffffffffc02049d0 <sysfile_read+0xd6>
ffffffffc02049b0:	e401                	bnez	s0,ffffffffc02049b8 <sysfile_read+0xbe>
ffffffffc02049b2:	67a2                	ld	a5,8(sp)
ffffffffc02049b4:	c391                	beqz	a5,ffffffffc02049b8 <sysfile_read+0xbe>
ffffffffc02049b6:	f4dd                	bnez	s1,ffffffffc0204964 <sysfile_read+0x6a>
ffffffffc02049b8:	854e                	mv	a0,s3
ffffffffc02049ba:	ca4fd0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02049be:	f40b8ce3          	beqz	s7,ffffffffc0204916 <sysfile_read+0x1c>
ffffffffc02049c2:	000b841b          	sext.w	s0,s7
ffffffffc02049c6:	bf81                	j	ffffffffc0204916 <sysfile_read+0x1c>
ffffffffc02049c8:	e011                	bnez	s0,ffffffffc02049cc <sysfile_read+0xd2>
ffffffffc02049ca:	5475                	li	s0,-3
ffffffffc02049cc:	fe0906e3          	beqz	s2,ffffffffc02049b8 <sysfile_read+0xbe>
ffffffffc02049d0:	8562                	mv	a0,s8
ffffffffc02049d2:	e0dff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc02049d6:	04092823          	sw	zero,80(s2)
ffffffffc02049da:	bfd9                	j	ffffffffc02049b0 <sysfile_read+0xb6>
ffffffffc02049dc:	e426                	sd	s1,8(sp)
ffffffffc02049de:	8626                	mv	a2,s1
ffffffffc02049e0:	b771                	j	ffffffffc020496c <sysfile_read+0x72>
ffffffffc02049e2:	66a2                	ld	a3,8(sp)
ffffffffc02049e4:	bf45                	j	ffffffffc0204994 <sysfile_read+0x9a>
ffffffffc02049e6:	5475                	li	s0,-3
ffffffffc02049e8:	b73d                	j	ffffffffc0204916 <sysfile_read+0x1c>
ffffffffc02049ea:	5471                	li	s0,-4
ffffffffc02049ec:	b72d                	j	ffffffffc0204916 <sysfile_read+0x1c>
ffffffffc02049ee:	00009697          	auipc	a3,0x9
ffffffffc02049f2:	85268693          	addi	a3,a3,-1966 # ffffffffc020d240 <default_pmm_manager+0x818>
ffffffffc02049f6:	00007617          	auipc	a2,0x7
ffffffffc02049fa:	22260613          	addi	a2,a2,546 # ffffffffc020bc18 <commands+0x250>
ffffffffc02049fe:	05500593          	li	a1,85
ffffffffc0204a02:	00009517          	auipc	a0,0x9
ffffffffc0204a06:	84e50513          	addi	a0,a0,-1970 # ffffffffc020d250 <default_pmm_manager+0x828>
ffffffffc0204a0a:	825fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204a0e <sysfile_write>:
ffffffffc0204a0e:	7159                	addi	sp,sp,-112
ffffffffc0204a10:	e8ca                	sd	s2,80(sp)
ffffffffc0204a12:	f486                	sd	ra,104(sp)
ffffffffc0204a14:	f0a2                	sd	s0,96(sp)
ffffffffc0204a16:	eca6                	sd	s1,88(sp)
ffffffffc0204a18:	e4ce                	sd	s3,72(sp)
ffffffffc0204a1a:	e0d2                	sd	s4,64(sp)
ffffffffc0204a1c:	fc56                	sd	s5,56(sp)
ffffffffc0204a1e:	f85a                	sd	s6,48(sp)
ffffffffc0204a20:	f45e                	sd	s7,40(sp)
ffffffffc0204a22:	f062                	sd	s8,32(sp)
ffffffffc0204a24:	ec66                	sd	s9,24(sp)
ffffffffc0204a26:	4901                	li	s2,0
ffffffffc0204a28:	ee19                	bnez	a2,ffffffffc0204a46 <sysfile_write+0x38>
ffffffffc0204a2a:	70a6                	ld	ra,104(sp)
ffffffffc0204a2c:	7406                	ld	s0,96(sp)
ffffffffc0204a2e:	64e6                	ld	s1,88(sp)
ffffffffc0204a30:	69a6                	ld	s3,72(sp)
ffffffffc0204a32:	6a06                	ld	s4,64(sp)
ffffffffc0204a34:	7ae2                	ld	s5,56(sp)
ffffffffc0204a36:	7b42                	ld	s6,48(sp)
ffffffffc0204a38:	7ba2                	ld	s7,40(sp)
ffffffffc0204a3a:	7c02                	ld	s8,32(sp)
ffffffffc0204a3c:	6ce2                	ld	s9,24(sp)
ffffffffc0204a3e:	854a                	mv	a0,s2
ffffffffc0204a40:	6946                	ld	s2,80(sp)
ffffffffc0204a42:	6165                	addi	sp,sp,112
ffffffffc0204a44:	8082                	ret
ffffffffc0204a46:	00092c17          	auipc	s8,0x92
ffffffffc0204a4a:	e7ac0c13          	addi	s8,s8,-390 # ffffffffc02968c0 <current>
ffffffffc0204a4e:	000c3783          	ld	a5,0(s8)
ffffffffc0204a52:	8432                	mv	s0,a2
ffffffffc0204a54:	89ae                	mv	s3,a1
ffffffffc0204a56:	4605                	li	a2,1
ffffffffc0204a58:	4581                	li	a1,0
ffffffffc0204a5a:	7784                	ld	s1,40(a5)
ffffffffc0204a5c:	8baa                	mv	s7,a0
ffffffffc0204a5e:	5e6000ef          	jal	ra,ffffffffc0205044 <file_testfd>
ffffffffc0204a62:	cd59                	beqz	a0,ffffffffc0204b00 <sysfile_write+0xf2>
ffffffffc0204a64:	6505                	lui	a0,0x1
ffffffffc0204a66:	b48fd0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0204a6a:	8a2a                	mv	s4,a0
ffffffffc0204a6c:	cd41                	beqz	a0,ffffffffc0204b04 <sysfile_write+0xf6>
ffffffffc0204a6e:	4c81                	li	s9,0
ffffffffc0204a70:	6a85                	lui	s5,0x1
ffffffffc0204a72:	03848b13          	addi	s6,s1,56
ffffffffc0204a76:	05546a63          	bltu	s0,s5,ffffffffc0204aca <sysfile_write+0xbc>
ffffffffc0204a7a:	e456                	sd	s5,8(sp)
ffffffffc0204a7c:	c8a9                	beqz	s1,ffffffffc0204ace <sysfile_write+0xc0>
ffffffffc0204a7e:	855a                	mv	a0,s6
ffffffffc0204a80:	d63ff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204a84:	000c3783          	ld	a5,0(s8)
ffffffffc0204a88:	c399                	beqz	a5,ffffffffc0204a8e <sysfile_write+0x80>
ffffffffc0204a8a:	43dc                	lw	a5,4(a5)
ffffffffc0204a8c:	c8bc                	sw	a5,80(s1)
ffffffffc0204a8e:	66a2                	ld	a3,8(sp)
ffffffffc0204a90:	4701                	li	a4,0
ffffffffc0204a92:	864e                	mv	a2,s3
ffffffffc0204a94:	85d2                	mv	a1,s4
ffffffffc0204a96:	8526                	mv	a0,s1
ffffffffc0204a98:	ff9fc0ef          	jal	ra,ffffffffc0201a90 <copy_from_user>
ffffffffc0204a9c:	c139                	beqz	a0,ffffffffc0204ae2 <sysfile_write+0xd4>
ffffffffc0204a9e:	855a                	mv	a0,s6
ffffffffc0204aa0:	d3fff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204aa4:	0404a823          	sw	zero,80(s1)
ffffffffc0204aa8:	6622                	ld	a2,8(sp)
ffffffffc0204aaa:	0034                	addi	a3,sp,8
ffffffffc0204aac:	85d2                	mv	a1,s4
ffffffffc0204aae:	855e                	mv	a0,s7
ffffffffc0204ab0:	023000ef          	jal	ra,ffffffffc02052d2 <file_write>
ffffffffc0204ab4:	67a2                	ld	a5,8(sp)
ffffffffc0204ab6:	892a                	mv	s2,a0
ffffffffc0204ab8:	ef85                	bnez	a5,ffffffffc0204af0 <sysfile_write+0xe2>
ffffffffc0204aba:	8552                	mv	a0,s4
ffffffffc0204abc:	ba2fd0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0204ac0:	f60c85e3          	beqz	s9,ffffffffc0204a2a <sysfile_write+0x1c>
ffffffffc0204ac4:	000c891b          	sext.w	s2,s9
ffffffffc0204ac8:	b78d                	j	ffffffffc0204a2a <sysfile_write+0x1c>
ffffffffc0204aca:	e422                	sd	s0,8(sp)
ffffffffc0204acc:	f8cd                	bnez	s1,ffffffffc0204a7e <sysfile_write+0x70>
ffffffffc0204ace:	66a2                	ld	a3,8(sp)
ffffffffc0204ad0:	4701                	li	a4,0
ffffffffc0204ad2:	864e                	mv	a2,s3
ffffffffc0204ad4:	85d2                	mv	a1,s4
ffffffffc0204ad6:	4501                	li	a0,0
ffffffffc0204ad8:	fb9fc0ef          	jal	ra,ffffffffc0201a90 <copy_from_user>
ffffffffc0204adc:	f571                	bnez	a0,ffffffffc0204aa8 <sysfile_write+0x9a>
ffffffffc0204ade:	5975                	li	s2,-3
ffffffffc0204ae0:	bfe9                	j	ffffffffc0204aba <sysfile_write+0xac>
ffffffffc0204ae2:	855a                	mv	a0,s6
ffffffffc0204ae4:	cfbff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204ae8:	5975                	li	s2,-3
ffffffffc0204aea:	0404a823          	sw	zero,80(s1)
ffffffffc0204aee:	b7f1                	j	ffffffffc0204aba <sysfile_write+0xac>
ffffffffc0204af0:	00f46c63          	bltu	s0,a5,ffffffffc0204b08 <sysfile_write+0xfa>
ffffffffc0204af4:	99be                	add	s3,s3,a5
ffffffffc0204af6:	8c1d                	sub	s0,s0,a5
ffffffffc0204af8:	9cbe                	add	s9,s9,a5
ffffffffc0204afa:	f161                	bnez	a0,ffffffffc0204aba <sysfile_write+0xac>
ffffffffc0204afc:	fc2d                	bnez	s0,ffffffffc0204a76 <sysfile_write+0x68>
ffffffffc0204afe:	bf75                	j	ffffffffc0204aba <sysfile_write+0xac>
ffffffffc0204b00:	5975                	li	s2,-3
ffffffffc0204b02:	b725                	j	ffffffffc0204a2a <sysfile_write+0x1c>
ffffffffc0204b04:	5971                	li	s2,-4
ffffffffc0204b06:	b715                	j	ffffffffc0204a2a <sysfile_write+0x1c>
ffffffffc0204b08:	00008697          	auipc	a3,0x8
ffffffffc0204b0c:	73868693          	addi	a3,a3,1848 # ffffffffc020d240 <default_pmm_manager+0x818>
ffffffffc0204b10:	00007617          	auipc	a2,0x7
ffffffffc0204b14:	10860613          	addi	a2,a2,264 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204b18:	08a00593          	li	a1,138
ffffffffc0204b1c:	00008517          	auipc	a0,0x8
ffffffffc0204b20:	73450513          	addi	a0,a0,1844 # ffffffffc020d250 <default_pmm_manager+0x828>
ffffffffc0204b24:	f0afb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204b28 <sysfile_seek>:
ffffffffc0204b28:	0910006f          	j	ffffffffc02053b8 <file_seek>

ffffffffc0204b2c <sysfile_fstat>:
ffffffffc0204b2c:	715d                	addi	sp,sp,-80
ffffffffc0204b2e:	f44e                	sd	s3,40(sp)
ffffffffc0204b30:	00092997          	auipc	s3,0x92
ffffffffc0204b34:	d9098993          	addi	s3,s3,-624 # ffffffffc02968c0 <current>
ffffffffc0204b38:	0009b703          	ld	a4,0(s3)
ffffffffc0204b3c:	fc26                	sd	s1,56(sp)
ffffffffc0204b3e:	84ae                	mv	s1,a1
ffffffffc0204b40:	858a                	mv	a1,sp
ffffffffc0204b42:	e0a2                	sd	s0,64(sp)
ffffffffc0204b44:	f84a                	sd	s2,48(sp)
ffffffffc0204b46:	e486                	sd	ra,72(sp)
ffffffffc0204b48:	02873903          	ld	s2,40(a4)
ffffffffc0204b4c:	f052                	sd	s4,32(sp)
ffffffffc0204b4e:	18b000ef          	jal	ra,ffffffffc02054d8 <file_fstat>
ffffffffc0204b52:	842a                	mv	s0,a0
ffffffffc0204b54:	e91d                	bnez	a0,ffffffffc0204b8a <sysfile_fstat+0x5e>
ffffffffc0204b56:	04090363          	beqz	s2,ffffffffc0204b9c <sysfile_fstat+0x70>
ffffffffc0204b5a:	03890a13          	addi	s4,s2,56
ffffffffc0204b5e:	8552                	mv	a0,s4
ffffffffc0204b60:	c83ff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204b64:	0009b783          	ld	a5,0(s3)
ffffffffc0204b68:	c3b9                	beqz	a5,ffffffffc0204bae <sysfile_fstat+0x82>
ffffffffc0204b6a:	43dc                	lw	a5,4(a5)
ffffffffc0204b6c:	02000693          	li	a3,32
ffffffffc0204b70:	860a                	mv	a2,sp
ffffffffc0204b72:	04f92823          	sw	a5,80(s2)
ffffffffc0204b76:	85a6                	mv	a1,s1
ffffffffc0204b78:	854a                	mv	a0,s2
ffffffffc0204b7a:	f4bfc0ef          	jal	ra,ffffffffc0201ac4 <copy_to_user>
ffffffffc0204b7e:	c121                	beqz	a0,ffffffffc0204bbe <sysfile_fstat+0x92>
ffffffffc0204b80:	8552                	mv	a0,s4
ffffffffc0204b82:	c5dff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204b86:	04092823          	sw	zero,80(s2)
ffffffffc0204b8a:	60a6                	ld	ra,72(sp)
ffffffffc0204b8c:	8522                	mv	a0,s0
ffffffffc0204b8e:	6406                	ld	s0,64(sp)
ffffffffc0204b90:	74e2                	ld	s1,56(sp)
ffffffffc0204b92:	7942                	ld	s2,48(sp)
ffffffffc0204b94:	79a2                	ld	s3,40(sp)
ffffffffc0204b96:	7a02                	ld	s4,32(sp)
ffffffffc0204b98:	6161                	addi	sp,sp,80
ffffffffc0204b9a:	8082                	ret
ffffffffc0204b9c:	02000693          	li	a3,32
ffffffffc0204ba0:	860a                	mv	a2,sp
ffffffffc0204ba2:	85a6                	mv	a1,s1
ffffffffc0204ba4:	f21fc0ef          	jal	ra,ffffffffc0201ac4 <copy_to_user>
ffffffffc0204ba8:	f16d                	bnez	a0,ffffffffc0204b8a <sysfile_fstat+0x5e>
ffffffffc0204baa:	5475                	li	s0,-3
ffffffffc0204bac:	bff9                	j	ffffffffc0204b8a <sysfile_fstat+0x5e>
ffffffffc0204bae:	02000693          	li	a3,32
ffffffffc0204bb2:	860a                	mv	a2,sp
ffffffffc0204bb4:	85a6                	mv	a1,s1
ffffffffc0204bb6:	854a                	mv	a0,s2
ffffffffc0204bb8:	f0dfc0ef          	jal	ra,ffffffffc0201ac4 <copy_to_user>
ffffffffc0204bbc:	f171                	bnez	a0,ffffffffc0204b80 <sysfile_fstat+0x54>
ffffffffc0204bbe:	8552                	mv	a0,s4
ffffffffc0204bc0:	c1fff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204bc4:	5475                	li	s0,-3
ffffffffc0204bc6:	04092823          	sw	zero,80(s2)
ffffffffc0204bca:	b7c1                	j	ffffffffc0204b8a <sysfile_fstat+0x5e>

ffffffffc0204bcc <sysfile_fsync>:
ffffffffc0204bcc:	1cd0006f          	j	ffffffffc0205598 <file_fsync>

ffffffffc0204bd0 <sysfile_getcwd>:
ffffffffc0204bd0:	715d                	addi	sp,sp,-80
ffffffffc0204bd2:	f44e                	sd	s3,40(sp)
ffffffffc0204bd4:	00092997          	auipc	s3,0x92
ffffffffc0204bd8:	cec98993          	addi	s3,s3,-788 # ffffffffc02968c0 <current>
ffffffffc0204bdc:	0009b783          	ld	a5,0(s3)
ffffffffc0204be0:	f84a                	sd	s2,48(sp)
ffffffffc0204be2:	e486                	sd	ra,72(sp)
ffffffffc0204be4:	e0a2                	sd	s0,64(sp)
ffffffffc0204be6:	fc26                	sd	s1,56(sp)
ffffffffc0204be8:	f052                	sd	s4,32(sp)
ffffffffc0204bea:	0287b903          	ld	s2,40(a5)
ffffffffc0204bee:	cda9                	beqz	a1,ffffffffc0204c48 <sysfile_getcwd+0x78>
ffffffffc0204bf0:	842e                	mv	s0,a1
ffffffffc0204bf2:	84aa                	mv	s1,a0
ffffffffc0204bf4:	04090363          	beqz	s2,ffffffffc0204c3a <sysfile_getcwd+0x6a>
ffffffffc0204bf8:	03890a13          	addi	s4,s2,56
ffffffffc0204bfc:	8552                	mv	a0,s4
ffffffffc0204bfe:	be5ff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204c02:	0009b783          	ld	a5,0(s3)
ffffffffc0204c06:	c781                	beqz	a5,ffffffffc0204c0e <sysfile_getcwd+0x3e>
ffffffffc0204c08:	43dc                	lw	a5,4(a5)
ffffffffc0204c0a:	04f92823          	sw	a5,80(s2)
ffffffffc0204c0e:	4685                	li	a3,1
ffffffffc0204c10:	8622                	mv	a2,s0
ffffffffc0204c12:	85a6                	mv	a1,s1
ffffffffc0204c14:	854a                	mv	a0,s2
ffffffffc0204c16:	de7fc0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc0204c1a:	e90d                	bnez	a0,ffffffffc0204c4c <sysfile_getcwd+0x7c>
ffffffffc0204c1c:	5475                	li	s0,-3
ffffffffc0204c1e:	8552                	mv	a0,s4
ffffffffc0204c20:	bbfff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204c24:	04092823          	sw	zero,80(s2)
ffffffffc0204c28:	60a6                	ld	ra,72(sp)
ffffffffc0204c2a:	8522                	mv	a0,s0
ffffffffc0204c2c:	6406                	ld	s0,64(sp)
ffffffffc0204c2e:	74e2                	ld	s1,56(sp)
ffffffffc0204c30:	7942                	ld	s2,48(sp)
ffffffffc0204c32:	79a2                	ld	s3,40(sp)
ffffffffc0204c34:	7a02                	ld	s4,32(sp)
ffffffffc0204c36:	6161                	addi	sp,sp,80
ffffffffc0204c38:	8082                	ret
ffffffffc0204c3a:	862e                	mv	a2,a1
ffffffffc0204c3c:	4685                	li	a3,1
ffffffffc0204c3e:	85aa                	mv	a1,a0
ffffffffc0204c40:	4501                	li	a0,0
ffffffffc0204c42:	dbbfc0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc0204c46:	ed09                	bnez	a0,ffffffffc0204c60 <sysfile_getcwd+0x90>
ffffffffc0204c48:	5475                	li	s0,-3
ffffffffc0204c4a:	bff9                	j	ffffffffc0204c28 <sysfile_getcwd+0x58>
ffffffffc0204c4c:	8622                	mv	a2,s0
ffffffffc0204c4e:	4681                	li	a3,0
ffffffffc0204c50:	85a6                	mv	a1,s1
ffffffffc0204c52:	850a                	mv	a0,sp
ffffffffc0204c54:	371000ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc0204c58:	1ec030ef          	jal	ra,ffffffffc0207e44 <vfs_getcwd>
ffffffffc0204c5c:	842a                	mv	s0,a0
ffffffffc0204c5e:	b7c1                	j	ffffffffc0204c1e <sysfile_getcwd+0x4e>
ffffffffc0204c60:	8622                	mv	a2,s0
ffffffffc0204c62:	4681                	li	a3,0
ffffffffc0204c64:	85a6                	mv	a1,s1
ffffffffc0204c66:	850a                	mv	a0,sp
ffffffffc0204c68:	35d000ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc0204c6c:	1d8030ef          	jal	ra,ffffffffc0207e44 <vfs_getcwd>
ffffffffc0204c70:	842a                	mv	s0,a0
ffffffffc0204c72:	bf5d                	j	ffffffffc0204c28 <sysfile_getcwd+0x58>

ffffffffc0204c74 <sysfile_getdirentry>:
ffffffffc0204c74:	7139                	addi	sp,sp,-64
ffffffffc0204c76:	e852                	sd	s4,16(sp)
ffffffffc0204c78:	00092a17          	auipc	s4,0x92
ffffffffc0204c7c:	c48a0a13          	addi	s4,s4,-952 # ffffffffc02968c0 <current>
ffffffffc0204c80:	000a3703          	ld	a4,0(s4)
ffffffffc0204c84:	ec4e                	sd	s3,24(sp)
ffffffffc0204c86:	89aa                	mv	s3,a0
ffffffffc0204c88:	10800513          	li	a0,264
ffffffffc0204c8c:	f426                	sd	s1,40(sp)
ffffffffc0204c8e:	f04a                	sd	s2,32(sp)
ffffffffc0204c90:	fc06                	sd	ra,56(sp)
ffffffffc0204c92:	f822                	sd	s0,48(sp)
ffffffffc0204c94:	e456                	sd	s5,8(sp)
ffffffffc0204c96:	7704                	ld	s1,40(a4)
ffffffffc0204c98:	892e                	mv	s2,a1
ffffffffc0204c9a:	914fd0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0204c9e:	c169                	beqz	a0,ffffffffc0204d60 <sysfile_getdirentry+0xec>
ffffffffc0204ca0:	842a                	mv	s0,a0
ffffffffc0204ca2:	c8c1                	beqz	s1,ffffffffc0204d32 <sysfile_getdirentry+0xbe>
ffffffffc0204ca4:	03848a93          	addi	s5,s1,56
ffffffffc0204ca8:	8556                	mv	a0,s5
ffffffffc0204caa:	b39ff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204cae:	000a3783          	ld	a5,0(s4)
ffffffffc0204cb2:	c399                	beqz	a5,ffffffffc0204cb8 <sysfile_getdirentry+0x44>
ffffffffc0204cb4:	43dc                	lw	a5,4(a5)
ffffffffc0204cb6:	c8bc                	sw	a5,80(s1)
ffffffffc0204cb8:	4705                	li	a4,1
ffffffffc0204cba:	46a1                	li	a3,8
ffffffffc0204cbc:	864a                	mv	a2,s2
ffffffffc0204cbe:	85a2                	mv	a1,s0
ffffffffc0204cc0:	8526                	mv	a0,s1
ffffffffc0204cc2:	dcffc0ef          	jal	ra,ffffffffc0201a90 <copy_from_user>
ffffffffc0204cc6:	e505                	bnez	a0,ffffffffc0204cee <sysfile_getdirentry+0x7a>
ffffffffc0204cc8:	8556                	mv	a0,s5
ffffffffc0204cca:	b15ff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204cce:	59f5                	li	s3,-3
ffffffffc0204cd0:	0404a823          	sw	zero,80(s1)
ffffffffc0204cd4:	8522                	mv	a0,s0
ffffffffc0204cd6:	988fd0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0204cda:	70e2                	ld	ra,56(sp)
ffffffffc0204cdc:	7442                	ld	s0,48(sp)
ffffffffc0204cde:	74a2                	ld	s1,40(sp)
ffffffffc0204ce0:	7902                	ld	s2,32(sp)
ffffffffc0204ce2:	6a42                	ld	s4,16(sp)
ffffffffc0204ce4:	6aa2                	ld	s5,8(sp)
ffffffffc0204ce6:	854e                	mv	a0,s3
ffffffffc0204ce8:	69e2                	ld	s3,24(sp)
ffffffffc0204cea:	6121                	addi	sp,sp,64
ffffffffc0204cec:	8082                	ret
ffffffffc0204cee:	8556                	mv	a0,s5
ffffffffc0204cf0:	aefff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204cf4:	854e                	mv	a0,s3
ffffffffc0204cf6:	85a2                	mv	a1,s0
ffffffffc0204cf8:	0404a823          	sw	zero,80(s1)
ffffffffc0204cfc:	14b000ef          	jal	ra,ffffffffc0205646 <file_getdirentry>
ffffffffc0204d00:	89aa                	mv	s3,a0
ffffffffc0204d02:	f969                	bnez	a0,ffffffffc0204cd4 <sysfile_getdirentry+0x60>
ffffffffc0204d04:	8556                	mv	a0,s5
ffffffffc0204d06:	addff0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0204d0a:	000a3783          	ld	a5,0(s4)
ffffffffc0204d0e:	c399                	beqz	a5,ffffffffc0204d14 <sysfile_getdirentry+0xa0>
ffffffffc0204d10:	43dc                	lw	a5,4(a5)
ffffffffc0204d12:	c8bc                	sw	a5,80(s1)
ffffffffc0204d14:	10800693          	li	a3,264
ffffffffc0204d18:	8622                	mv	a2,s0
ffffffffc0204d1a:	85ca                	mv	a1,s2
ffffffffc0204d1c:	8526                	mv	a0,s1
ffffffffc0204d1e:	da7fc0ef          	jal	ra,ffffffffc0201ac4 <copy_to_user>
ffffffffc0204d22:	e111                	bnez	a0,ffffffffc0204d26 <sysfile_getdirentry+0xb2>
ffffffffc0204d24:	59f5                	li	s3,-3
ffffffffc0204d26:	8556                	mv	a0,s5
ffffffffc0204d28:	ab7ff0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0204d2c:	0404a823          	sw	zero,80(s1)
ffffffffc0204d30:	b755                	j	ffffffffc0204cd4 <sysfile_getdirentry+0x60>
ffffffffc0204d32:	85aa                	mv	a1,a0
ffffffffc0204d34:	4705                	li	a4,1
ffffffffc0204d36:	46a1                	li	a3,8
ffffffffc0204d38:	864a                	mv	a2,s2
ffffffffc0204d3a:	4501                	li	a0,0
ffffffffc0204d3c:	d55fc0ef          	jal	ra,ffffffffc0201a90 <copy_from_user>
ffffffffc0204d40:	cd11                	beqz	a0,ffffffffc0204d5c <sysfile_getdirentry+0xe8>
ffffffffc0204d42:	854e                	mv	a0,s3
ffffffffc0204d44:	85a2                	mv	a1,s0
ffffffffc0204d46:	101000ef          	jal	ra,ffffffffc0205646 <file_getdirentry>
ffffffffc0204d4a:	89aa                	mv	s3,a0
ffffffffc0204d4c:	f541                	bnez	a0,ffffffffc0204cd4 <sysfile_getdirentry+0x60>
ffffffffc0204d4e:	10800693          	li	a3,264
ffffffffc0204d52:	8622                	mv	a2,s0
ffffffffc0204d54:	85ca                	mv	a1,s2
ffffffffc0204d56:	d6ffc0ef          	jal	ra,ffffffffc0201ac4 <copy_to_user>
ffffffffc0204d5a:	fd2d                	bnez	a0,ffffffffc0204cd4 <sysfile_getdirentry+0x60>
ffffffffc0204d5c:	59f5                	li	s3,-3
ffffffffc0204d5e:	bf9d                	j	ffffffffc0204cd4 <sysfile_getdirentry+0x60>
ffffffffc0204d60:	59f1                	li	s3,-4
ffffffffc0204d62:	bfa5                	j	ffffffffc0204cda <sysfile_getdirentry+0x66>

ffffffffc0204d64 <sysfile_dup>:
ffffffffc0204d64:	1c90006f          	j	ffffffffc020572c <file_dup>

ffffffffc0204d68 <get_fd_array.part.0>:
ffffffffc0204d68:	1141                	addi	sp,sp,-16
ffffffffc0204d6a:	00008697          	auipc	a3,0x8
ffffffffc0204d6e:	4fe68693          	addi	a3,a3,1278 # ffffffffc020d268 <default_pmm_manager+0x840>
ffffffffc0204d72:	00007617          	auipc	a2,0x7
ffffffffc0204d76:	ea660613          	addi	a2,a2,-346 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204d7a:	45d1                	li	a1,20
ffffffffc0204d7c:	00008517          	auipc	a0,0x8
ffffffffc0204d80:	51c50513          	addi	a0,a0,1308 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204d84:	e406                	sd	ra,8(sp)
ffffffffc0204d86:	ca8fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204d8a <fd_array_alloc>:
ffffffffc0204d8a:	00092797          	auipc	a5,0x92
ffffffffc0204d8e:	b367b783          	ld	a5,-1226(a5) # ffffffffc02968c0 <current>
ffffffffc0204d92:	1487b783          	ld	a5,328(a5)
ffffffffc0204d96:	1141                	addi	sp,sp,-16
ffffffffc0204d98:	e406                	sd	ra,8(sp)
ffffffffc0204d9a:	c3a5                	beqz	a5,ffffffffc0204dfa <fd_array_alloc+0x70>
ffffffffc0204d9c:	4b98                	lw	a4,16(a5)
ffffffffc0204d9e:	04e05e63          	blez	a4,ffffffffc0204dfa <fd_array_alloc+0x70>
ffffffffc0204da2:	775d                	lui	a4,0xffff7
ffffffffc0204da4:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204da8:	679c                	ld	a5,8(a5)
ffffffffc0204daa:	02e50863          	beq	a0,a4,ffffffffc0204dda <fd_array_alloc+0x50>
ffffffffc0204dae:	04700713          	li	a4,71
ffffffffc0204db2:	04a76263          	bltu	a4,a0,ffffffffc0204df6 <fd_array_alloc+0x6c>
ffffffffc0204db6:	00351713          	slli	a4,a0,0x3
ffffffffc0204dba:	40a70533          	sub	a0,a4,a0
ffffffffc0204dbe:	050e                	slli	a0,a0,0x3
ffffffffc0204dc0:	97aa                	add	a5,a5,a0
ffffffffc0204dc2:	4398                	lw	a4,0(a5)
ffffffffc0204dc4:	e71d                	bnez	a4,ffffffffc0204df2 <fd_array_alloc+0x68>
ffffffffc0204dc6:	5b88                	lw	a0,48(a5)
ffffffffc0204dc8:	e91d                	bnez	a0,ffffffffc0204dfe <fd_array_alloc+0x74>
ffffffffc0204dca:	4705                	li	a4,1
ffffffffc0204dcc:	c398                	sw	a4,0(a5)
ffffffffc0204dce:	0207b423          	sd	zero,40(a5)
ffffffffc0204dd2:	e19c                	sd	a5,0(a1)
ffffffffc0204dd4:	60a2                	ld	ra,8(sp)
ffffffffc0204dd6:	0141                	addi	sp,sp,16
ffffffffc0204dd8:	8082                	ret
ffffffffc0204dda:	6685                	lui	a3,0x1
ffffffffc0204ddc:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0204de0:	96be                	add	a3,a3,a5
ffffffffc0204de2:	4398                	lw	a4,0(a5)
ffffffffc0204de4:	d36d                	beqz	a4,ffffffffc0204dc6 <fd_array_alloc+0x3c>
ffffffffc0204de6:	03878793          	addi	a5,a5,56
ffffffffc0204dea:	fef69ce3          	bne	a3,a5,ffffffffc0204de2 <fd_array_alloc+0x58>
ffffffffc0204dee:	5529                	li	a0,-22
ffffffffc0204df0:	b7d5                	j	ffffffffc0204dd4 <fd_array_alloc+0x4a>
ffffffffc0204df2:	5545                	li	a0,-15
ffffffffc0204df4:	b7c5                	j	ffffffffc0204dd4 <fd_array_alloc+0x4a>
ffffffffc0204df6:	5575                	li	a0,-3
ffffffffc0204df8:	bff1                	j	ffffffffc0204dd4 <fd_array_alloc+0x4a>
ffffffffc0204dfa:	f6fff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>
ffffffffc0204dfe:	00008697          	auipc	a3,0x8
ffffffffc0204e02:	4aa68693          	addi	a3,a3,1194 # ffffffffc020d2a8 <default_pmm_manager+0x880>
ffffffffc0204e06:	00007617          	auipc	a2,0x7
ffffffffc0204e0a:	e1260613          	addi	a2,a2,-494 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204e0e:	03b00593          	li	a1,59
ffffffffc0204e12:	00008517          	auipc	a0,0x8
ffffffffc0204e16:	48650513          	addi	a0,a0,1158 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204e1a:	c14fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e1e <fd_array_free>:
ffffffffc0204e1e:	411c                	lw	a5,0(a0)
ffffffffc0204e20:	1141                	addi	sp,sp,-16
ffffffffc0204e22:	e022                	sd	s0,0(sp)
ffffffffc0204e24:	e406                	sd	ra,8(sp)
ffffffffc0204e26:	4705                	li	a4,1
ffffffffc0204e28:	842a                	mv	s0,a0
ffffffffc0204e2a:	04e78063          	beq	a5,a4,ffffffffc0204e6a <fd_array_free+0x4c>
ffffffffc0204e2e:	470d                	li	a4,3
ffffffffc0204e30:	04e79563          	bne	a5,a4,ffffffffc0204e7a <fd_array_free+0x5c>
ffffffffc0204e34:	591c                	lw	a5,48(a0)
ffffffffc0204e36:	c38d                	beqz	a5,ffffffffc0204e58 <fd_array_free+0x3a>
ffffffffc0204e38:	00008697          	auipc	a3,0x8
ffffffffc0204e3c:	47068693          	addi	a3,a3,1136 # ffffffffc020d2a8 <default_pmm_manager+0x880>
ffffffffc0204e40:	00007617          	auipc	a2,0x7
ffffffffc0204e44:	dd860613          	addi	a2,a2,-552 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204e48:	04500593          	li	a1,69
ffffffffc0204e4c:	00008517          	auipc	a0,0x8
ffffffffc0204e50:	44c50513          	addi	a0,a0,1100 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204e54:	bdafb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204e58:	7408                	ld	a0,40(s0)
ffffffffc0204e5a:	444030ef          	jal	ra,ffffffffc020829e <vfs_close>
ffffffffc0204e5e:	60a2                	ld	ra,8(sp)
ffffffffc0204e60:	00042023          	sw	zero,0(s0)
ffffffffc0204e64:	6402                	ld	s0,0(sp)
ffffffffc0204e66:	0141                	addi	sp,sp,16
ffffffffc0204e68:	8082                	ret
ffffffffc0204e6a:	591c                	lw	a5,48(a0)
ffffffffc0204e6c:	f7f1                	bnez	a5,ffffffffc0204e38 <fd_array_free+0x1a>
ffffffffc0204e6e:	60a2                	ld	ra,8(sp)
ffffffffc0204e70:	00042023          	sw	zero,0(s0)
ffffffffc0204e74:	6402                	ld	s0,0(sp)
ffffffffc0204e76:	0141                	addi	sp,sp,16
ffffffffc0204e78:	8082                	ret
ffffffffc0204e7a:	00008697          	auipc	a3,0x8
ffffffffc0204e7e:	46668693          	addi	a3,a3,1126 # ffffffffc020d2e0 <default_pmm_manager+0x8b8>
ffffffffc0204e82:	00007617          	auipc	a2,0x7
ffffffffc0204e86:	d9660613          	addi	a2,a2,-618 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204e8a:	04400593          	li	a1,68
ffffffffc0204e8e:	00008517          	auipc	a0,0x8
ffffffffc0204e92:	40a50513          	addi	a0,a0,1034 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204e96:	b98fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e9a <fd_array_release>:
ffffffffc0204e9a:	4118                	lw	a4,0(a0)
ffffffffc0204e9c:	1141                	addi	sp,sp,-16
ffffffffc0204e9e:	e406                	sd	ra,8(sp)
ffffffffc0204ea0:	4685                	li	a3,1
ffffffffc0204ea2:	3779                	addiw	a4,a4,-2
ffffffffc0204ea4:	04e6e063          	bltu	a3,a4,ffffffffc0204ee4 <fd_array_release+0x4a>
ffffffffc0204ea8:	5918                	lw	a4,48(a0)
ffffffffc0204eaa:	00e05d63          	blez	a4,ffffffffc0204ec4 <fd_array_release+0x2a>
ffffffffc0204eae:	fff7069b          	addiw	a3,a4,-1
ffffffffc0204eb2:	d914                	sw	a3,48(a0)
ffffffffc0204eb4:	c681                	beqz	a3,ffffffffc0204ebc <fd_array_release+0x22>
ffffffffc0204eb6:	60a2                	ld	ra,8(sp)
ffffffffc0204eb8:	0141                	addi	sp,sp,16
ffffffffc0204eba:	8082                	ret
ffffffffc0204ebc:	60a2                	ld	ra,8(sp)
ffffffffc0204ebe:	0141                	addi	sp,sp,16
ffffffffc0204ec0:	f5fff06f          	j	ffffffffc0204e1e <fd_array_free>
ffffffffc0204ec4:	00008697          	auipc	a3,0x8
ffffffffc0204ec8:	48c68693          	addi	a3,a3,1164 # ffffffffc020d350 <default_pmm_manager+0x928>
ffffffffc0204ecc:	00007617          	auipc	a2,0x7
ffffffffc0204ed0:	d4c60613          	addi	a2,a2,-692 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204ed4:	05600593          	li	a1,86
ffffffffc0204ed8:	00008517          	auipc	a0,0x8
ffffffffc0204edc:	3c050513          	addi	a0,a0,960 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204ee0:	b4efb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204ee4:	00008697          	auipc	a3,0x8
ffffffffc0204ee8:	43468693          	addi	a3,a3,1076 # ffffffffc020d318 <default_pmm_manager+0x8f0>
ffffffffc0204eec:	00007617          	auipc	a2,0x7
ffffffffc0204ef0:	d2c60613          	addi	a2,a2,-724 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204ef4:	05500593          	li	a1,85
ffffffffc0204ef8:	00008517          	auipc	a0,0x8
ffffffffc0204efc:	3a050513          	addi	a0,a0,928 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204f00:	b2efb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204f04 <fd_array_open.part.0>:
ffffffffc0204f04:	1141                	addi	sp,sp,-16
ffffffffc0204f06:	00008697          	auipc	a3,0x8
ffffffffc0204f0a:	46268693          	addi	a3,a3,1122 # ffffffffc020d368 <default_pmm_manager+0x940>
ffffffffc0204f0e:	00007617          	auipc	a2,0x7
ffffffffc0204f12:	d0a60613          	addi	a2,a2,-758 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204f16:	05f00593          	li	a1,95
ffffffffc0204f1a:	00008517          	auipc	a0,0x8
ffffffffc0204f1e:	37e50513          	addi	a0,a0,894 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204f22:	e406                	sd	ra,8(sp)
ffffffffc0204f24:	b0afb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204f28 <fd_array_init>:
ffffffffc0204f28:	4781                	li	a5,0
ffffffffc0204f2a:	04800713          	li	a4,72
ffffffffc0204f2e:	cd1c                	sw	a5,24(a0)
ffffffffc0204f30:	02052823          	sw	zero,48(a0)
ffffffffc0204f34:	00052023          	sw	zero,0(a0)
ffffffffc0204f38:	2785                	addiw	a5,a5,1
ffffffffc0204f3a:	03850513          	addi	a0,a0,56
ffffffffc0204f3e:	fee798e3          	bne	a5,a4,ffffffffc0204f2e <fd_array_init+0x6>
ffffffffc0204f42:	8082                	ret

ffffffffc0204f44 <fd_array_close>:
ffffffffc0204f44:	4118                	lw	a4,0(a0)
ffffffffc0204f46:	1141                	addi	sp,sp,-16
ffffffffc0204f48:	e406                	sd	ra,8(sp)
ffffffffc0204f4a:	e022                	sd	s0,0(sp)
ffffffffc0204f4c:	4789                	li	a5,2
ffffffffc0204f4e:	04f71a63          	bne	a4,a5,ffffffffc0204fa2 <fd_array_close+0x5e>
ffffffffc0204f52:	591c                	lw	a5,48(a0)
ffffffffc0204f54:	842a                	mv	s0,a0
ffffffffc0204f56:	02f05663          	blez	a5,ffffffffc0204f82 <fd_array_close+0x3e>
ffffffffc0204f5a:	37fd                	addiw	a5,a5,-1
ffffffffc0204f5c:	470d                	li	a4,3
ffffffffc0204f5e:	c118                	sw	a4,0(a0)
ffffffffc0204f60:	d91c                	sw	a5,48(a0)
ffffffffc0204f62:	0007871b          	sext.w	a4,a5
ffffffffc0204f66:	c709                	beqz	a4,ffffffffc0204f70 <fd_array_close+0x2c>
ffffffffc0204f68:	60a2                	ld	ra,8(sp)
ffffffffc0204f6a:	6402                	ld	s0,0(sp)
ffffffffc0204f6c:	0141                	addi	sp,sp,16
ffffffffc0204f6e:	8082                	ret
ffffffffc0204f70:	7508                	ld	a0,40(a0)
ffffffffc0204f72:	32c030ef          	jal	ra,ffffffffc020829e <vfs_close>
ffffffffc0204f76:	60a2                	ld	ra,8(sp)
ffffffffc0204f78:	00042023          	sw	zero,0(s0)
ffffffffc0204f7c:	6402                	ld	s0,0(sp)
ffffffffc0204f7e:	0141                	addi	sp,sp,16
ffffffffc0204f80:	8082                	ret
ffffffffc0204f82:	00008697          	auipc	a3,0x8
ffffffffc0204f86:	3ce68693          	addi	a3,a3,974 # ffffffffc020d350 <default_pmm_manager+0x928>
ffffffffc0204f8a:	00007617          	auipc	a2,0x7
ffffffffc0204f8e:	c8e60613          	addi	a2,a2,-882 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204f92:	06800593          	li	a1,104
ffffffffc0204f96:	00008517          	auipc	a0,0x8
ffffffffc0204f9a:	30250513          	addi	a0,a0,770 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204f9e:	a90fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204fa2:	00008697          	auipc	a3,0x8
ffffffffc0204fa6:	31e68693          	addi	a3,a3,798 # ffffffffc020d2c0 <default_pmm_manager+0x898>
ffffffffc0204faa:	00007617          	auipc	a2,0x7
ffffffffc0204fae:	c6e60613          	addi	a2,a2,-914 # ffffffffc020bc18 <commands+0x250>
ffffffffc0204fb2:	06700593          	li	a1,103
ffffffffc0204fb6:	00008517          	auipc	a0,0x8
ffffffffc0204fba:	2e250513          	addi	a0,a0,738 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0204fbe:	a70fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204fc2 <fd_array_dup>:
ffffffffc0204fc2:	7179                	addi	sp,sp,-48
ffffffffc0204fc4:	e84a                	sd	s2,16(sp)
ffffffffc0204fc6:	00052903          	lw	s2,0(a0)
ffffffffc0204fca:	f406                	sd	ra,40(sp)
ffffffffc0204fcc:	f022                	sd	s0,32(sp)
ffffffffc0204fce:	ec26                	sd	s1,24(sp)
ffffffffc0204fd0:	e44e                	sd	s3,8(sp)
ffffffffc0204fd2:	4785                	li	a5,1
ffffffffc0204fd4:	04f91663          	bne	s2,a5,ffffffffc0205020 <fd_array_dup+0x5e>
ffffffffc0204fd8:	0005a983          	lw	s3,0(a1)
ffffffffc0204fdc:	4789                	li	a5,2
ffffffffc0204fde:	04f99163          	bne	s3,a5,ffffffffc0205020 <fd_array_dup+0x5e>
ffffffffc0204fe2:	7584                	ld	s1,40(a1)
ffffffffc0204fe4:	699c                	ld	a5,16(a1)
ffffffffc0204fe6:	7194                	ld	a3,32(a1)
ffffffffc0204fe8:	6598                	ld	a4,8(a1)
ffffffffc0204fea:	842a                	mv	s0,a0
ffffffffc0204fec:	e91c                	sd	a5,16(a0)
ffffffffc0204fee:	f114                	sd	a3,32(a0)
ffffffffc0204ff0:	e518                	sd	a4,8(a0)
ffffffffc0204ff2:	8526                	mv	a0,s1
ffffffffc0204ff4:	344030ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0204ff8:	8526                	mv	a0,s1
ffffffffc0204ffa:	34a030ef          	jal	ra,ffffffffc0208344 <inode_open_inc>
ffffffffc0204ffe:	401c                	lw	a5,0(s0)
ffffffffc0205000:	f404                	sd	s1,40(s0)
ffffffffc0205002:	03279f63          	bne	a5,s2,ffffffffc0205040 <fd_array_dup+0x7e>
ffffffffc0205006:	cc8d                	beqz	s1,ffffffffc0205040 <fd_array_dup+0x7e>
ffffffffc0205008:	581c                	lw	a5,48(s0)
ffffffffc020500a:	01342023          	sw	s3,0(s0)
ffffffffc020500e:	70a2                	ld	ra,40(sp)
ffffffffc0205010:	2785                	addiw	a5,a5,1
ffffffffc0205012:	d81c                	sw	a5,48(s0)
ffffffffc0205014:	7402                	ld	s0,32(sp)
ffffffffc0205016:	64e2                	ld	s1,24(sp)
ffffffffc0205018:	6942                	ld	s2,16(sp)
ffffffffc020501a:	69a2                	ld	s3,8(sp)
ffffffffc020501c:	6145                	addi	sp,sp,48
ffffffffc020501e:	8082                	ret
ffffffffc0205020:	00008697          	auipc	a3,0x8
ffffffffc0205024:	37868693          	addi	a3,a3,888 # ffffffffc020d398 <default_pmm_manager+0x970>
ffffffffc0205028:	00007617          	auipc	a2,0x7
ffffffffc020502c:	bf060613          	addi	a2,a2,-1040 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205030:	07300593          	li	a1,115
ffffffffc0205034:	00008517          	auipc	a0,0x8
ffffffffc0205038:	26450513          	addi	a0,a0,612 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc020503c:	9f2fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205040:	ec5ff0ef          	jal	ra,ffffffffc0204f04 <fd_array_open.part.0>

ffffffffc0205044 <file_testfd>:
ffffffffc0205044:	04700793          	li	a5,71
ffffffffc0205048:	04a7e263          	bltu	a5,a0,ffffffffc020508c <file_testfd+0x48>
ffffffffc020504c:	00092797          	auipc	a5,0x92
ffffffffc0205050:	8747b783          	ld	a5,-1932(a5) # ffffffffc02968c0 <current>
ffffffffc0205054:	1487b783          	ld	a5,328(a5)
ffffffffc0205058:	cf85                	beqz	a5,ffffffffc0205090 <file_testfd+0x4c>
ffffffffc020505a:	4b98                	lw	a4,16(a5)
ffffffffc020505c:	02e05a63          	blez	a4,ffffffffc0205090 <file_testfd+0x4c>
ffffffffc0205060:	6798                	ld	a4,8(a5)
ffffffffc0205062:	00351793          	slli	a5,a0,0x3
ffffffffc0205066:	8f89                	sub	a5,a5,a0
ffffffffc0205068:	078e                	slli	a5,a5,0x3
ffffffffc020506a:	97ba                	add	a5,a5,a4
ffffffffc020506c:	4394                	lw	a3,0(a5)
ffffffffc020506e:	4709                	li	a4,2
ffffffffc0205070:	00e69e63          	bne	a3,a4,ffffffffc020508c <file_testfd+0x48>
ffffffffc0205074:	4f98                	lw	a4,24(a5)
ffffffffc0205076:	00a71b63          	bne	a4,a0,ffffffffc020508c <file_testfd+0x48>
ffffffffc020507a:	c199                	beqz	a1,ffffffffc0205080 <file_testfd+0x3c>
ffffffffc020507c:	6788                	ld	a0,8(a5)
ffffffffc020507e:	c901                	beqz	a0,ffffffffc020508e <file_testfd+0x4a>
ffffffffc0205080:	4505                	li	a0,1
ffffffffc0205082:	c611                	beqz	a2,ffffffffc020508e <file_testfd+0x4a>
ffffffffc0205084:	6b88                	ld	a0,16(a5)
ffffffffc0205086:	00a03533          	snez	a0,a0
ffffffffc020508a:	8082                	ret
ffffffffc020508c:	4501                	li	a0,0
ffffffffc020508e:	8082                	ret
ffffffffc0205090:	1141                	addi	sp,sp,-16
ffffffffc0205092:	e406                	sd	ra,8(sp)
ffffffffc0205094:	cd5ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>

ffffffffc0205098 <file_open>:
ffffffffc0205098:	711d                	addi	sp,sp,-96
ffffffffc020509a:	ec86                	sd	ra,88(sp)
ffffffffc020509c:	e8a2                	sd	s0,80(sp)
ffffffffc020509e:	e4a6                	sd	s1,72(sp)
ffffffffc02050a0:	e0ca                	sd	s2,64(sp)
ffffffffc02050a2:	fc4e                	sd	s3,56(sp)
ffffffffc02050a4:	f852                	sd	s4,48(sp)
ffffffffc02050a6:	0035f793          	andi	a5,a1,3
ffffffffc02050aa:	470d                	li	a4,3
ffffffffc02050ac:	0ce78163          	beq	a5,a4,ffffffffc020516e <file_open+0xd6>
ffffffffc02050b0:	078e                	slli	a5,a5,0x3
ffffffffc02050b2:	00008717          	auipc	a4,0x8
ffffffffc02050b6:	55670713          	addi	a4,a4,1366 # ffffffffc020d608 <CSWTCH.79>
ffffffffc02050ba:	892a                	mv	s2,a0
ffffffffc02050bc:	00008697          	auipc	a3,0x8
ffffffffc02050c0:	53468693          	addi	a3,a3,1332 # ffffffffc020d5f0 <CSWTCH.78>
ffffffffc02050c4:	755d                	lui	a0,0xffff7
ffffffffc02050c6:	96be                	add	a3,a3,a5
ffffffffc02050c8:	84ae                	mv	s1,a1
ffffffffc02050ca:	97ba                	add	a5,a5,a4
ffffffffc02050cc:	858a                	mv	a1,sp
ffffffffc02050ce:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02050d2:	0006ba03          	ld	s4,0(a3)
ffffffffc02050d6:	0007b983          	ld	s3,0(a5)
ffffffffc02050da:	cb1ff0ef          	jal	ra,ffffffffc0204d8a <fd_array_alloc>
ffffffffc02050de:	842a                	mv	s0,a0
ffffffffc02050e0:	c911                	beqz	a0,ffffffffc02050f4 <file_open+0x5c>
ffffffffc02050e2:	60e6                	ld	ra,88(sp)
ffffffffc02050e4:	8522                	mv	a0,s0
ffffffffc02050e6:	6446                	ld	s0,80(sp)
ffffffffc02050e8:	64a6                	ld	s1,72(sp)
ffffffffc02050ea:	6906                	ld	s2,64(sp)
ffffffffc02050ec:	79e2                	ld	s3,56(sp)
ffffffffc02050ee:	7a42                	ld	s4,48(sp)
ffffffffc02050f0:	6125                	addi	sp,sp,96
ffffffffc02050f2:	8082                	ret
ffffffffc02050f4:	0030                	addi	a2,sp,8
ffffffffc02050f6:	85a6                	mv	a1,s1
ffffffffc02050f8:	854a                	mv	a0,s2
ffffffffc02050fa:	7ff020ef          	jal	ra,ffffffffc02080f8 <vfs_open>
ffffffffc02050fe:	842a                	mv	s0,a0
ffffffffc0205100:	e13d                	bnez	a0,ffffffffc0205166 <file_open+0xce>
ffffffffc0205102:	6782                	ld	a5,0(sp)
ffffffffc0205104:	0204f493          	andi	s1,s1,32
ffffffffc0205108:	6422                	ld	s0,8(sp)
ffffffffc020510a:	0207b023          	sd	zero,32(a5)
ffffffffc020510e:	c885                	beqz	s1,ffffffffc020513e <file_open+0xa6>
ffffffffc0205110:	c03d                	beqz	s0,ffffffffc0205176 <file_open+0xde>
ffffffffc0205112:	783c                	ld	a5,112(s0)
ffffffffc0205114:	c3ad                	beqz	a5,ffffffffc0205176 <file_open+0xde>
ffffffffc0205116:	779c                	ld	a5,40(a5)
ffffffffc0205118:	cfb9                	beqz	a5,ffffffffc0205176 <file_open+0xde>
ffffffffc020511a:	8522                	mv	a0,s0
ffffffffc020511c:	00008597          	auipc	a1,0x8
ffffffffc0205120:	30458593          	addi	a1,a1,772 # ffffffffc020d420 <default_pmm_manager+0x9f8>
ffffffffc0205124:	22c030ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0205128:	783c                	ld	a5,112(s0)
ffffffffc020512a:	6522                	ld	a0,8(sp)
ffffffffc020512c:	080c                	addi	a1,sp,16
ffffffffc020512e:	779c                	ld	a5,40(a5)
ffffffffc0205130:	9782                	jalr	a5
ffffffffc0205132:	842a                	mv	s0,a0
ffffffffc0205134:	e515                	bnez	a0,ffffffffc0205160 <file_open+0xc8>
ffffffffc0205136:	6782                	ld	a5,0(sp)
ffffffffc0205138:	7722                	ld	a4,40(sp)
ffffffffc020513a:	6422                	ld	s0,8(sp)
ffffffffc020513c:	f398                	sd	a4,32(a5)
ffffffffc020513e:	4394                	lw	a3,0(a5)
ffffffffc0205140:	f780                	sd	s0,40(a5)
ffffffffc0205142:	0147b423          	sd	s4,8(a5)
ffffffffc0205146:	0137b823          	sd	s3,16(a5)
ffffffffc020514a:	4705                	li	a4,1
ffffffffc020514c:	02e69363          	bne	a3,a4,ffffffffc0205172 <file_open+0xda>
ffffffffc0205150:	c00d                	beqz	s0,ffffffffc0205172 <file_open+0xda>
ffffffffc0205152:	5b98                	lw	a4,48(a5)
ffffffffc0205154:	4689                	li	a3,2
ffffffffc0205156:	4f80                	lw	s0,24(a5)
ffffffffc0205158:	2705                	addiw	a4,a4,1
ffffffffc020515a:	c394                	sw	a3,0(a5)
ffffffffc020515c:	db98                	sw	a4,48(a5)
ffffffffc020515e:	b751                	j	ffffffffc02050e2 <file_open+0x4a>
ffffffffc0205160:	6522                	ld	a0,8(sp)
ffffffffc0205162:	13c030ef          	jal	ra,ffffffffc020829e <vfs_close>
ffffffffc0205166:	6502                	ld	a0,0(sp)
ffffffffc0205168:	cb7ff0ef          	jal	ra,ffffffffc0204e1e <fd_array_free>
ffffffffc020516c:	bf9d                	j	ffffffffc02050e2 <file_open+0x4a>
ffffffffc020516e:	5475                	li	s0,-3
ffffffffc0205170:	bf8d                	j	ffffffffc02050e2 <file_open+0x4a>
ffffffffc0205172:	d93ff0ef          	jal	ra,ffffffffc0204f04 <fd_array_open.part.0>
ffffffffc0205176:	00008697          	auipc	a3,0x8
ffffffffc020517a:	25a68693          	addi	a3,a3,602 # ffffffffc020d3d0 <default_pmm_manager+0x9a8>
ffffffffc020517e:	00007617          	auipc	a2,0x7
ffffffffc0205182:	a9a60613          	addi	a2,a2,-1382 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205186:	0b500593          	li	a1,181
ffffffffc020518a:	00008517          	auipc	a0,0x8
ffffffffc020518e:	10e50513          	addi	a0,a0,270 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0205192:	89cfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205196 <file_close>:
ffffffffc0205196:	04700713          	li	a4,71
ffffffffc020519a:	04a76563          	bltu	a4,a0,ffffffffc02051e4 <file_close+0x4e>
ffffffffc020519e:	00091717          	auipc	a4,0x91
ffffffffc02051a2:	72273703          	ld	a4,1826(a4) # ffffffffc02968c0 <current>
ffffffffc02051a6:	14873703          	ld	a4,328(a4)
ffffffffc02051aa:	1141                	addi	sp,sp,-16
ffffffffc02051ac:	e406                	sd	ra,8(sp)
ffffffffc02051ae:	cf0d                	beqz	a4,ffffffffc02051e8 <file_close+0x52>
ffffffffc02051b0:	4b14                	lw	a3,16(a4)
ffffffffc02051b2:	02d05b63          	blez	a3,ffffffffc02051e8 <file_close+0x52>
ffffffffc02051b6:	6718                	ld	a4,8(a4)
ffffffffc02051b8:	87aa                	mv	a5,a0
ffffffffc02051ba:	050e                	slli	a0,a0,0x3
ffffffffc02051bc:	8d1d                	sub	a0,a0,a5
ffffffffc02051be:	050e                	slli	a0,a0,0x3
ffffffffc02051c0:	953a                	add	a0,a0,a4
ffffffffc02051c2:	4114                	lw	a3,0(a0)
ffffffffc02051c4:	4709                	li	a4,2
ffffffffc02051c6:	00e69b63          	bne	a3,a4,ffffffffc02051dc <file_close+0x46>
ffffffffc02051ca:	4d18                	lw	a4,24(a0)
ffffffffc02051cc:	00f71863          	bne	a4,a5,ffffffffc02051dc <file_close+0x46>
ffffffffc02051d0:	d75ff0ef          	jal	ra,ffffffffc0204f44 <fd_array_close>
ffffffffc02051d4:	60a2                	ld	ra,8(sp)
ffffffffc02051d6:	4501                	li	a0,0
ffffffffc02051d8:	0141                	addi	sp,sp,16
ffffffffc02051da:	8082                	ret
ffffffffc02051dc:	60a2                	ld	ra,8(sp)
ffffffffc02051de:	5575                	li	a0,-3
ffffffffc02051e0:	0141                	addi	sp,sp,16
ffffffffc02051e2:	8082                	ret
ffffffffc02051e4:	5575                	li	a0,-3
ffffffffc02051e6:	8082                	ret
ffffffffc02051e8:	b81ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>

ffffffffc02051ec <file_read>:
ffffffffc02051ec:	715d                	addi	sp,sp,-80
ffffffffc02051ee:	e486                	sd	ra,72(sp)
ffffffffc02051f0:	e0a2                	sd	s0,64(sp)
ffffffffc02051f2:	fc26                	sd	s1,56(sp)
ffffffffc02051f4:	f84a                	sd	s2,48(sp)
ffffffffc02051f6:	f44e                	sd	s3,40(sp)
ffffffffc02051f8:	f052                	sd	s4,32(sp)
ffffffffc02051fa:	0006b023          	sd	zero,0(a3)
ffffffffc02051fe:	04700793          	li	a5,71
ffffffffc0205202:	0aa7e463          	bltu	a5,a0,ffffffffc02052aa <file_read+0xbe>
ffffffffc0205206:	00091797          	auipc	a5,0x91
ffffffffc020520a:	6ba7b783          	ld	a5,1722(a5) # ffffffffc02968c0 <current>
ffffffffc020520e:	1487b783          	ld	a5,328(a5)
ffffffffc0205212:	cfd1                	beqz	a5,ffffffffc02052ae <file_read+0xc2>
ffffffffc0205214:	4b98                	lw	a4,16(a5)
ffffffffc0205216:	08e05c63          	blez	a4,ffffffffc02052ae <file_read+0xc2>
ffffffffc020521a:	6780                	ld	s0,8(a5)
ffffffffc020521c:	00351793          	slli	a5,a0,0x3
ffffffffc0205220:	8f89                	sub	a5,a5,a0
ffffffffc0205222:	078e                	slli	a5,a5,0x3
ffffffffc0205224:	943e                	add	s0,s0,a5
ffffffffc0205226:	00042983          	lw	s3,0(s0)
ffffffffc020522a:	4789                	li	a5,2
ffffffffc020522c:	06f99f63          	bne	s3,a5,ffffffffc02052aa <file_read+0xbe>
ffffffffc0205230:	4c1c                	lw	a5,24(s0)
ffffffffc0205232:	06a79c63          	bne	a5,a0,ffffffffc02052aa <file_read+0xbe>
ffffffffc0205236:	641c                	ld	a5,8(s0)
ffffffffc0205238:	cbad                	beqz	a5,ffffffffc02052aa <file_read+0xbe>
ffffffffc020523a:	581c                	lw	a5,48(s0)
ffffffffc020523c:	8a36                	mv	s4,a3
ffffffffc020523e:	7014                	ld	a3,32(s0)
ffffffffc0205240:	2785                	addiw	a5,a5,1
ffffffffc0205242:	850a                	mv	a0,sp
ffffffffc0205244:	d81c                	sw	a5,48(s0)
ffffffffc0205246:	57e000ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc020524a:	02843903          	ld	s2,40(s0)
ffffffffc020524e:	84aa                	mv	s1,a0
ffffffffc0205250:	06090163          	beqz	s2,ffffffffc02052b2 <file_read+0xc6>
ffffffffc0205254:	07093783          	ld	a5,112(s2)
ffffffffc0205258:	cfa9                	beqz	a5,ffffffffc02052b2 <file_read+0xc6>
ffffffffc020525a:	6f9c                	ld	a5,24(a5)
ffffffffc020525c:	cbb9                	beqz	a5,ffffffffc02052b2 <file_read+0xc6>
ffffffffc020525e:	00008597          	auipc	a1,0x8
ffffffffc0205262:	21a58593          	addi	a1,a1,538 # ffffffffc020d478 <default_pmm_manager+0xa50>
ffffffffc0205266:	854a                	mv	a0,s2
ffffffffc0205268:	0e8030ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc020526c:	07093783          	ld	a5,112(s2)
ffffffffc0205270:	7408                	ld	a0,40(s0)
ffffffffc0205272:	85a6                	mv	a1,s1
ffffffffc0205274:	6f9c                	ld	a5,24(a5)
ffffffffc0205276:	9782                	jalr	a5
ffffffffc0205278:	689c                	ld	a5,16(s1)
ffffffffc020527a:	6c94                	ld	a3,24(s1)
ffffffffc020527c:	4018                	lw	a4,0(s0)
ffffffffc020527e:	84aa                	mv	s1,a0
ffffffffc0205280:	8f95                	sub	a5,a5,a3
ffffffffc0205282:	03370063          	beq	a4,s3,ffffffffc02052a2 <file_read+0xb6>
ffffffffc0205286:	00fa3023          	sd	a5,0(s4)
ffffffffc020528a:	8522                	mv	a0,s0
ffffffffc020528c:	c0fff0ef          	jal	ra,ffffffffc0204e9a <fd_array_release>
ffffffffc0205290:	60a6                	ld	ra,72(sp)
ffffffffc0205292:	6406                	ld	s0,64(sp)
ffffffffc0205294:	7942                	ld	s2,48(sp)
ffffffffc0205296:	79a2                	ld	s3,40(sp)
ffffffffc0205298:	7a02                	ld	s4,32(sp)
ffffffffc020529a:	8526                	mv	a0,s1
ffffffffc020529c:	74e2                	ld	s1,56(sp)
ffffffffc020529e:	6161                	addi	sp,sp,80
ffffffffc02052a0:	8082                	ret
ffffffffc02052a2:	7018                	ld	a4,32(s0)
ffffffffc02052a4:	973e                	add	a4,a4,a5
ffffffffc02052a6:	f018                	sd	a4,32(s0)
ffffffffc02052a8:	bff9                	j	ffffffffc0205286 <file_read+0x9a>
ffffffffc02052aa:	54f5                	li	s1,-3
ffffffffc02052ac:	b7d5                	j	ffffffffc0205290 <file_read+0xa4>
ffffffffc02052ae:	abbff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>
ffffffffc02052b2:	00008697          	auipc	a3,0x8
ffffffffc02052b6:	17668693          	addi	a3,a3,374 # ffffffffc020d428 <default_pmm_manager+0xa00>
ffffffffc02052ba:	00007617          	auipc	a2,0x7
ffffffffc02052be:	95e60613          	addi	a2,a2,-1698 # ffffffffc020bc18 <commands+0x250>
ffffffffc02052c2:	0de00593          	li	a1,222
ffffffffc02052c6:	00008517          	auipc	a0,0x8
ffffffffc02052ca:	fd250513          	addi	a0,a0,-46 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc02052ce:	f61fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02052d2 <file_write>:
ffffffffc02052d2:	715d                	addi	sp,sp,-80
ffffffffc02052d4:	e486                	sd	ra,72(sp)
ffffffffc02052d6:	e0a2                	sd	s0,64(sp)
ffffffffc02052d8:	fc26                	sd	s1,56(sp)
ffffffffc02052da:	f84a                	sd	s2,48(sp)
ffffffffc02052dc:	f44e                	sd	s3,40(sp)
ffffffffc02052de:	f052                	sd	s4,32(sp)
ffffffffc02052e0:	0006b023          	sd	zero,0(a3)
ffffffffc02052e4:	04700793          	li	a5,71
ffffffffc02052e8:	0aa7e463          	bltu	a5,a0,ffffffffc0205390 <file_write+0xbe>
ffffffffc02052ec:	00091797          	auipc	a5,0x91
ffffffffc02052f0:	5d47b783          	ld	a5,1492(a5) # ffffffffc02968c0 <current>
ffffffffc02052f4:	1487b783          	ld	a5,328(a5)
ffffffffc02052f8:	cfd1                	beqz	a5,ffffffffc0205394 <file_write+0xc2>
ffffffffc02052fa:	4b98                	lw	a4,16(a5)
ffffffffc02052fc:	08e05c63          	blez	a4,ffffffffc0205394 <file_write+0xc2>
ffffffffc0205300:	6780                	ld	s0,8(a5)
ffffffffc0205302:	00351793          	slli	a5,a0,0x3
ffffffffc0205306:	8f89                	sub	a5,a5,a0
ffffffffc0205308:	078e                	slli	a5,a5,0x3
ffffffffc020530a:	943e                	add	s0,s0,a5
ffffffffc020530c:	00042983          	lw	s3,0(s0)
ffffffffc0205310:	4789                	li	a5,2
ffffffffc0205312:	06f99f63          	bne	s3,a5,ffffffffc0205390 <file_write+0xbe>
ffffffffc0205316:	4c1c                	lw	a5,24(s0)
ffffffffc0205318:	06a79c63          	bne	a5,a0,ffffffffc0205390 <file_write+0xbe>
ffffffffc020531c:	681c                	ld	a5,16(s0)
ffffffffc020531e:	cbad                	beqz	a5,ffffffffc0205390 <file_write+0xbe>
ffffffffc0205320:	581c                	lw	a5,48(s0)
ffffffffc0205322:	8a36                	mv	s4,a3
ffffffffc0205324:	7014                	ld	a3,32(s0)
ffffffffc0205326:	2785                	addiw	a5,a5,1
ffffffffc0205328:	850a                	mv	a0,sp
ffffffffc020532a:	d81c                	sw	a5,48(s0)
ffffffffc020532c:	498000ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc0205330:	02843903          	ld	s2,40(s0)
ffffffffc0205334:	84aa                	mv	s1,a0
ffffffffc0205336:	06090163          	beqz	s2,ffffffffc0205398 <file_write+0xc6>
ffffffffc020533a:	07093783          	ld	a5,112(s2)
ffffffffc020533e:	cfa9                	beqz	a5,ffffffffc0205398 <file_write+0xc6>
ffffffffc0205340:	739c                	ld	a5,32(a5)
ffffffffc0205342:	cbb9                	beqz	a5,ffffffffc0205398 <file_write+0xc6>
ffffffffc0205344:	00008597          	auipc	a1,0x8
ffffffffc0205348:	18c58593          	addi	a1,a1,396 # ffffffffc020d4d0 <default_pmm_manager+0xaa8>
ffffffffc020534c:	854a                	mv	a0,s2
ffffffffc020534e:	002030ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0205352:	07093783          	ld	a5,112(s2)
ffffffffc0205356:	7408                	ld	a0,40(s0)
ffffffffc0205358:	85a6                	mv	a1,s1
ffffffffc020535a:	739c                	ld	a5,32(a5)
ffffffffc020535c:	9782                	jalr	a5
ffffffffc020535e:	689c                	ld	a5,16(s1)
ffffffffc0205360:	6c94                	ld	a3,24(s1)
ffffffffc0205362:	4018                	lw	a4,0(s0)
ffffffffc0205364:	84aa                	mv	s1,a0
ffffffffc0205366:	8f95                	sub	a5,a5,a3
ffffffffc0205368:	03370063          	beq	a4,s3,ffffffffc0205388 <file_write+0xb6>
ffffffffc020536c:	00fa3023          	sd	a5,0(s4)
ffffffffc0205370:	8522                	mv	a0,s0
ffffffffc0205372:	b29ff0ef          	jal	ra,ffffffffc0204e9a <fd_array_release>
ffffffffc0205376:	60a6                	ld	ra,72(sp)
ffffffffc0205378:	6406                	ld	s0,64(sp)
ffffffffc020537a:	7942                	ld	s2,48(sp)
ffffffffc020537c:	79a2                	ld	s3,40(sp)
ffffffffc020537e:	7a02                	ld	s4,32(sp)
ffffffffc0205380:	8526                	mv	a0,s1
ffffffffc0205382:	74e2                	ld	s1,56(sp)
ffffffffc0205384:	6161                	addi	sp,sp,80
ffffffffc0205386:	8082                	ret
ffffffffc0205388:	7018                	ld	a4,32(s0)
ffffffffc020538a:	973e                	add	a4,a4,a5
ffffffffc020538c:	f018                	sd	a4,32(s0)
ffffffffc020538e:	bff9                	j	ffffffffc020536c <file_write+0x9a>
ffffffffc0205390:	54f5                	li	s1,-3
ffffffffc0205392:	b7d5                	j	ffffffffc0205376 <file_write+0xa4>
ffffffffc0205394:	9d5ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>
ffffffffc0205398:	00008697          	auipc	a3,0x8
ffffffffc020539c:	0e868693          	addi	a3,a3,232 # ffffffffc020d480 <default_pmm_manager+0xa58>
ffffffffc02053a0:	00007617          	auipc	a2,0x7
ffffffffc02053a4:	87860613          	addi	a2,a2,-1928 # ffffffffc020bc18 <commands+0x250>
ffffffffc02053a8:	0f800593          	li	a1,248
ffffffffc02053ac:	00008517          	auipc	a0,0x8
ffffffffc02053b0:	eec50513          	addi	a0,a0,-276 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc02053b4:	e7bfa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02053b8 <file_seek>:
ffffffffc02053b8:	7139                	addi	sp,sp,-64
ffffffffc02053ba:	fc06                	sd	ra,56(sp)
ffffffffc02053bc:	f822                	sd	s0,48(sp)
ffffffffc02053be:	f426                	sd	s1,40(sp)
ffffffffc02053c0:	f04a                	sd	s2,32(sp)
ffffffffc02053c2:	04700793          	li	a5,71
ffffffffc02053c6:	08a7e863          	bltu	a5,a0,ffffffffc0205456 <file_seek+0x9e>
ffffffffc02053ca:	00091797          	auipc	a5,0x91
ffffffffc02053ce:	4f67b783          	ld	a5,1270(a5) # ffffffffc02968c0 <current>
ffffffffc02053d2:	1487b783          	ld	a5,328(a5)
ffffffffc02053d6:	cfdd                	beqz	a5,ffffffffc0205494 <file_seek+0xdc>
ffffffffc02053d8:	4b98                	lw	a4,16(a5)
ffffffffc02053da:	0ae05d63          	blez	a4,ffffffffc0205494 <file_seek+0xdc>
ffffffffc02053de:	6780                	ld	s0,8(a5)
ffffffffc02053e0:	00351793          	slli	a5,a0,0x3
ffffffffc02053e4:	8f89                	sub	a5,a5,a0
ffffffffc02053e6:	078e                	slli	a5,a5,0x3
ffffffffc02053e8:	943e                	add	s0,s0,a5
ffffffffc02053ea:	4018                	lw	a4,0(s0)
ffffffffc02053ec:	4789                	li	a5,2
ffffffffc02053ee:	06f71463          	bne	a4,a5,ffffffffc0205456 <file_seek+0x9e>
ffffffffc02053f2:	4c1c                	lw	a5,24(s0)
ffffffffc02053f4:	06a79163          	bne	a5,a0,ffffffffc0205456 <file_seek+0x9e>
ffffffffc02053f8:	581c                	lw	a5,48(s0)
ffffffffc02053fa:	4685                	li	a3,1
ffffffffc02053fc:	892e                	mv	s2,a1
ffffffffc02053fe:	2785                	addiw	a5,a5,1
ffffffffc0205400:	d81c                	sw	a5,48(s0)
ffffffffc0205402:	02d60063          	beq	a2,a3,ffffffffc0205422 <file_seek+0x6a>
ffffffffc0205406:	06e60063          	beq	a2,a4,ffffffffc0205466 <file_seek+0xae>
ffffffffc020540a:	54f5                	li	s1,-3
ffffffffc020540c:	ce11                	beqz	a2,ffffffffc0205428 <file_seek+0x70>
ffffffffc020540e:	8522                	mv	a0,s0
ffffffffc0205410:	a8bff0ef          	jal	ra,ffffffffc0204e9a <fd_array_release>
ffffffffc0205414:	70e2                	ld	ra,56(sp)
ffffffffc0205416:	7442                	ld	s0,48(sp)
ffffffffc0205418:	7902                	ld	s2,32(sp)
ffffffffc020541a:	8526                	mv	a0,s1
ffffffffc020541c:	74a2                	ld	s1,40(sp)
ffffffffc020541e:	6121                	addi	sp,sp,64
ffffffffc0205420:	8082                	ret
ffffffffc0205422:	701c                	ld	a5,32(s0)
ffffffffc0205424:	00f58933          	add	s2,a1,a5
ffffffffc0205428:	7404                	ld	s1,40(s0)
ffffffffc020542a:	c4bd                	beqz	s1,ffffffffc0205498 <file_seek+0xe0>
ffffffffc020542c:	78bc                	ld	a5,112(s1)
ffffffffc020542e:	c7ad                	beqz	a5,ffffffffc0205498 <file_seek+0xe0>
ffffffffc0205430:	6fbc                	ld	a5,88(a5)
ffffffffc0205432:	c3bd                	beqz	a5,ffffffffc0205498 <file_seek+0xe0>
ffffffffc0205434:	8526                	mv	a0,s1
ffffffffc0205436:	00008597          	auipc	a1,0x8
ffffffffc020543a:	0f258593          	addi	a1,a1,242 # ffffffffc020d528 <default_pmm_manager+0xb00>
ffffffffc020543e:	713020ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0205442:	78bc                	ld	a5,112(s1)
ffffffffc0205444:	7408                	ld	a0,40(s0)
ffffffffc0205446:	85ca                	mv	a1,s2
ffffffffc0205448:	6fbc                	ld	a5,88(a5)
ffffffffc020544a:	9782                	jalr	a5
ffffffffc020544c:	84aa                	mv	s1,a0
ffffffffc020544e:	f161                	bnez	a0,ffffffffc020540e <file_seek+0x56>
ffffffffc0205450:	03243023          	sd	s2,32(s0)
ffffffffc0205454:	bf6d                	j	ffffffffc020540e <file_seek+0x56>
ffffffffc0205456:	70e2                	ld	ra,56(sp)
ffffffffc0205458:	7442                	ld	s0,48(sp)
ffffffffc020545a:	54f5                	li	s1,-3
ffffffffc020545c:	7902                	ld	s2,32(sp)
ffffffffc020545e:	8526                	mv	a0,s1
ffffffffc0205460:	74a2                	ld	s1,40(sp)
ffffffffc0205462:	6121                	addi	sp,sp,64
ffffffffc0205464:	8082                	ret
ffffffffc0205466:	7404                	ld	s1,40(s0)
ffffffffc0205468:	c8a1                	beqz	s1,ffffffffc02054b8 <file_seek+0x100>
ffffffffc020546a:	78bc                	ld	a5,112(s1)
ffffffffc020546c:	c7b1                	beqz	a5,ffffffffc02054b8 <file_seek+0x100>
ffffffffc020546e:	779c                	ld	a5,40(a5)
ffffffffc0205470:	c7a1                	beqz	a5,ffffffffc02054b8 <file_seek+0x100>
ffffffffc0205472:	8526                	mv	a0,s1
ffffffffc0205474:	00008597          	auipc	a1,0x8
ffffffffc0205478:	fac58593          	addi	a1,a1,-84 # ffffffffc020d420 <default_pmm_manager+0x9f8>
ffffffffc020547c:	6d5020ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0205480:	78bc                	ld	a5,112(s1)
ffffffffc0205482:	7408                	ld	a0,40(s0)
ffffffffc0205484:	858a                	mv	a1,sp
ffffffffc0205486:	779c                	ld	a5,40(a5)
ffffffffc0205488:	9782                	jalr	a5
ffffffffc020548a:	84aa                	mv	s1,a0
ffffffffc020548c:	f149                	bnez	a0,ffffffffc020540e <file_seek+0x56>
ffffffffc020548e:	67e2                	ld	a5,24(sp)
ffffffffc0205490:	993e                	add	s2,s2,a5
ffffffffc0205492:	bf59                	j	ffffffffc0205428 <file_seek+0x70>
ffffffffc0205494:	8d5ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>
ffffffffc0205498:	00008697          	auipc	a3,0x8
ffffffffc020549c:	04068693          	addi	a3,a3,64 # ffffffffc020d4d8 <default_pmm_manager+0xab0>
ffffffffc02054a0:	00006617          	auipc	a2,0x6
ffffffffc02054a4:	77860613          	addi	a2,a2,1912 # ffffffffc020bc18 <commands+0x250>
ffffffffc02054a8:	11a00593          	li	a1,282
ffffffffc02054ac:	00008517          	auipc	a0,0x8
ffffffffc02054b0:	dec50513          	addi	a0,a0,-532 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc02054b4:	d7bfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02054b8:	00008697          	auipc	a3,0x8
ffffffffc02054bc:	f1868693          	addi	a3,a3,-232 # ffffffffc020d3d0 <default_pmm_manager+0x9a8>
ffffffffc02054c0:	00006617          	auipc	a2,0x6
ffffffffc02054c4:	75860613          	addi	a2,a2,1880 # ffffffffc020bc18 <commands+0x250>
ffffffffc02054c8:	11200593          	li	a1,274
ffffffffc02054cc:	00008517          	auipc	a0,0x8
ffffffffc02054d0:	dcc50513          	addi	a0,a0,-564 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc02054d4:	d5bfa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02054d8 <file_fstat>:
ffffffffc02054d8:	1101                	addi	sp,sp,-32
ffffffffc02054da:	ec06                	sd	ra,24(sp)
ffffffffc02054dc:	e822                	sd	s0,16(sp)
ffffffffc02054de:	e426                	sd	s1,8(sp)
ffffffffc02054e0:	e04a                	sd	s2,0(sp)
ffffffffc02054e2:	04700793          	li	a5,71
ffffffffc02054e6:	06a7ef63          	bltu	a5,a0,ffffffffc0205564 <file_fstat+0x8c>
ffffffffc02054ea:	00091797          	auipc	a5,0x91
ffffffffc02054ee:	3d67b783          	ld	a5,982(a5) # ffffffffc02968c0 <current>
ffffffffc02054f2:	1487b783          	ld	a5,328(a5)
ffffffffc02054f6:	cfd9                	beqz	a5,ffffffffc0205594 <file_fstat+0xbc>
ffffffffc02054f8:	4b98                	lw	a4,16(a5)
ffffffffc02054fa:	08e05d63          	blez	a4,ffffffffc0205594 <file_fstat+0xbc>
ffffffffc02054fe:	6780                	ld	s0,8(a5)
ffffffffc0205500:	00351793          	slli	a5,a0,0x3
ffffffffc0205504:	8f89                	sub	a5,a5,a0
ffffffffc0205506:	078e                	slli	a5,a5,0x3
ffffffffc0205508:	943e                	add	s0,s0,a5
ffffffffc020550a:	4018                	lw	a4,0(s0)
ffffffffc020550c:	4789                	li	a5,2
ffffffffc020550e:	04f71b63          	bne	a4,a5,ffffffffc0205564 <file_fstat+0x8c>
ffffffffc0205512:	4c1c                	lw	a5,24(s0)
ffffffffc0205514:	04a79863          	bne	a5,a0,ffffffffc0205564 <file_fstat+0x8c>
ffffffffc0205518:	581c                	lw	a5,48(s0)
ffffffffc020551a:	02843903          	ld	s2,40(s0)
ffffffffc020551e:	2785                	addiw	a5,a5,1
ffffffffc0205520:	d81c                	sw	a5,48(s0)
ffffffffc0205522:	04090963          	beqz	s2,ffffffffc0205574 <file_fstat+0x9c>
ffffffffc0205526:	07093783          	ld	a5,112(s2)
ffffffffc020552a:	c7a9                	beqz	a5,ffffffffc0205574 <file_fstat+0x9c>
ffffffffc020552c:	779c                	ld	a5,40(a5)
ffffffffc020552e:	c3b9                	beqz	a5,ffffffffc0205574 <file_fstat+0x9c>
ffffffffc0205530:	84ae                	mv	s1,a1
ffffffffc0205532:	854a                	mv	a0,s2
ffffffffc0205534:	00008597          	auipc	a1,0x8
ffffffffc0205538:	eec58593          	addi	a1,a1,-276 # ffffffffc020d420 <default_pmm_manager+0x9f8>
ffffffffc020553c:	615020ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0205540:	07093783          	ld	a5,112(s2)
ffffffffc0205544:	7408                	ld	a0,40(s0)
ffffffffc0205546:	85a6                	mv	a1,s1
ffffffffc0205548:	779c                	ld	a5,40(a5)
ffffffffc020554a:	9782                	jalr	a5
ffffffffc020554c:	87aa                	mv	a5,a0
ffffffffc020554e:	8522                	mv	a0,s0
ffffffffc0205550:	843e                	mv	s0,a5
ffffffffc0205552:	949ff0ef          	jal	ra,ffffffffc0204e9a <fd_array_release>
ffffffffc0205556:	60e2                	ld	ra,24(sp)
ffffffffc0205558:	8522                	mv	a0,s0
ffffffffc020555a:	6442                	ld	s0,16(sp)
ffffffffc020555c:	64a2                	ld	s1,8(sp)
ffffffffc020555e:	6902                	ld	s2,0(sp)
ffffffffc0205560:	6105                	addi	sp,sp,32
ffffffffc0205562:	8082                	ret
ffffffffc0205564:	5475                	li	s0,-3
ffffffffc0205566:	60e2                	ld	ra,24(sp)
ffffffffc0205568:	8522                	mv	a0,s0
ffffffffc020556a:	6442                	ld	s0,16(sp)
ffffffffc020556c:	64a2                	ld	s1,8(sp)
ffffffffc020556e:	6902                	ld	s2,0(sp)
ffffffffc0205570:	6105                	addi	sp,sp,32
ffffffffc0205572:	8082                	ret
ffffffffc0205574:	00008697          	auipc	a3,0x8
ffffffffc0205578:	e5c68693          	addi	a3,a3,-420 # ffffffffc020d3d0 <default_pmm_manager+0x9a8>
ffffffffc020557c:	00006617          	auipc	a2,0x6
ffffffffc0205580:	69c60613          	addi	a2,a2,1692 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205584:	12c00593          	li	a1,300
ffffffffc0205588:	00008517          	auipc	a0,0x8
ffffffffc020558c:	d1050513          	addi	a0,a0,-752 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0205590:	c9ffa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205594:	fd4ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>

ffffffffc0205598 <file_fsync>:
ffffffffc0205598:	1101                	addi	sp,sp,-32
ffffffffc020559a:	ec06                	sd	ra,24(sp)
ffffffffc020559c:	e822                	sd	s0,16(sp)
ffffffffc020559e:	e426                	sd	s1,8(sp)
ffffffffc02055a0:	04700793          	li	a5,71
ffffffffc02055a4:	06a7e863          	bltu	a5,a0,ffffffffc0205614 <file_fsync+0x7c>
ffffffffc02055a8:	00091797          	auipc	a5,0x91
ffffffffc02055ac:	3187b783          	ld	a5,792(a5) # ffffffffc02968c0 <current>
ffffffffc02055b0:	1487b783          	ld	a5,328(a5)
ffffffffc02055b4:	c7d9                	beqz	a5,ffffffffc0205642 <file_fsync+0xaa>
ffffffffc02055b6:	4b98                	lw	a4,16(a5)
ffffffffc02055b8:	08e05563          	blez	a4,ffffffffc0205642 <file_fsync+0xaa>
ffffffffc02055bc:	6780                	ld	s0,8(a5)
ffffffffc02055be:	00351793          	slli	a5,a0,0x3
ffffffffc02055c2:	8f89                	sub	a5,a5,a0
ffffffffc02055c4:	078e                	slli	a5,a5,0x3
ffffffffc02055c6:	943e                	add	s0,s0,a5
ffffffffc02055c8:	4018                	lw	a4,0(s0)
ffffffffc02055ca:	4789                	li	a5,2
ffffffffc02055cc:	04f71463          	bne	a4,a5,ffffffffc0205614 <file_fsync+0x7c>
ffffffffc02055d0:	4c1c                	lw	a5,24(s0)
ffffffffc02055d2:	04a79163          	bne	a5,a0,ffffffffc0205614 <file_fsync+0x7c>
ffffffffc02055d6:	581c                	lw	a5,48(s0)
ffffffffc02055d8:	7404                	ld	s1,40(s0)
ffffffffc02055da:	2785                	addiw	a5,a5,1
ffffffffc02055dc:	d81c                	sw	a5,48(s0)
ffffffffc02055de:	c0b1                	beqz	s1,ffffffffc0205622 <file_fsync+0x8a>
ffffffffc02055e0:	78bc                	ld	a5,112(s1)
ffffffffc02055e2:	c3a1                	beqz	a5,ffffffffc0205622 <file_fsync+0x8a>
ffffffffc02055e4:	7b9c                	ld	a5,48(a5)
ffffffffc02055e6:	cf95                	beqz	a5,ffffffffc0205622 <file_fsync+0x8a>
ffffffffc02055e8:	00008597          	auipc	a1,0x8
ffffffffc02055ec:	f9858593          	addi	a1,a1,-104 # ffffffffc020d580 <default_pmm_manager+0xb58>
ffffffffc02055f0:	8526                	mv	a0,s1
ffffffffc02055f2:	55f020ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc02055f6:	78bc                	ld	a5,112(s1)
ffffffffc02055f8:	7408                	ld	a0,40(s0)
ffffffffc02055fa:	7b9c                	ld	a5,48(a5)
ffffffffc02055fc:	9782                	jalr	a5
ffffffffc02055fe:	87aa                	mv	a5,a0
ffffffffc0205600:	8522                	mv	a0,s0
ffffffffc0205602:	843e                	mv	s0,a5
ffffffffc0205604:	897ff0ef          	jal	ra,ffffffffc0204e9a <fd_array_release>
ffffffffc0205608:	60e2                	ld	ra,24(sp)
ffffffffc020560a:	8522                	mv	a0,s0
ffffffffc020560c:	6442                	ld	s0,16(sp)
ffffffffc020560e:	64a2                	ld	s1,8(sp)
ffffffffc0205610:	6105                	addi	sp,sp,32
ffffffffc0205612:	8082                	ret
ffffffffc0205614:	5475                	li	s0,-3
ffffffffc0205616:	60e2                	ld	ra,24(sp)
ffffffffc0205618:	8522                	mv	a0,s0
ffffffffc020561a:	6442                	ld	s0,16(sp)
ffffffffc020561c:	64a2                	ld	s1,8(sp)
ffffffffc020561e:	6105                	addi	sp,sp,32
ffffffffc0205620:	8082                	ret
ffffffffc0205622:	00008697          	auipc	a3,0x8
ffffffffc0205626:	f0e68693          	addi	a3,a3,-242 # ffffffffc020d530 <default_pmm_manager+0xb08>
ffffffffc020562a:	00006617          	auipc	a2,0x6
ffffffffc020562e:	5ee60613          	addi	a2,a2,1518 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205632:	13a00593          	li	a1,314
ffffffffc0205636:	00008517          	auipc	a0,0x8
ffffffffc020563a:	c6250513          	addi	a0,a0,-926 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc020563e:	bf1fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205642:	f26ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>

ffffffffc0205646 <file_getdirentry>:
ffffffffc0205646:	715d                	addi	sp,sp,-80
ffffffffc0205648:	e486                	sd	ra,72(sp)
ffffffffc020564a:	e0a2                	sd	s0,64(sp)
ffffffffc020564c:	fc26                	sd	s1,56(sp)
ffffffffc020564e:	f84a                	sd	s2,48(sp)
ffffffffc0205650:	f44e                	sd	s3,40(sp)
ffffffffc0205652:	04700793          	li	a5,71
ffffffffc0205656:	0aa7e063          	bltu	a5,a0,ffffffffc02056f6 <file_getdirentry+0xb0>
ffffffffc020565a:	00091797          	auipc	a5,0x91
ffffffffc020565e:	2667b783          	ld	a5,614(a5) # ffffffffc02968c0 <current>
ffffffffc0205662:	1487b783          	ld	a5,328(a5)
ffffffffc0205666:	c3e9                	beqz	a5,ffffffffc0205728 <file_getdirentry+0xe2>
ffffffffc0205668:	4b98                	lw	a4,16(a5)
ffffffffc020566a:	0ae05f63          	blez	a4,ffffffffc0205728 <file_getdirentry+0xe2>
ffffffffc020566e:	6780                	ld	s0,8(a5)
ffffffffc0205670:	00351793          	slli	a5,a0,0x3
ffffffffc0205674:	8f89                	sub	a5,a5,a0
ffffffffc0205676:	078e                	slli	a5,a5,0x3
ffffffffc0205678:	943e                	add	s0,s0,a5
ffffffffc020567a:	4018                	lw	a4,0(s0)
ffffffffc020567c:	4789                	li	a5,2
ffffffffc020567e:	06f71c63          	bne	a4,a5,ffffffffc02056f6 <file_getdirentry+0xb0>
ffffffffc0205682:	4c1c                	lw	a5,24(s0)
ffffffffc0205684:	06a79963          	bne	a5,a0,ffffffffc02056f6 <file_getdirentry+0xb0>
ffffffffc0205688:	581c                	lw	a5,48(s0)
ffffffffc020568a:	6194                	ld	a3,0(a1)
ffffffffc020568c:	84ae                	mv	s1,a1
ffffffffc020568e:	2785                	addiw	a5,a5,1
ffffffffc0205690:	10000613          	li	a2,256
ffffffffc0205694:	d81c                	sw	a5,48(s0)
ffffffffc0205696:	05a1                	addi	a1,a1,8
ffffffffc0205698:	850a                	mv	a0,sp
ffffffffc020569a:	12a000ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc020569e:	02843983          	ld	s3,40(s0)
ffffffffc02056a2:	892a                	mv	s2,a0
ffffffffc02056a4:	06098263          	beqz	s3,ffffffffc0205708 <file_getdirentry+0xc2>
ffffffffc02056a8:	0709b783          	ld	a5,112(s3)
ffffffffc02056ac:	cfb1                	beqz	a5,ffffffffc0205708 <file_getdirentry+0xc2>
ffffffffc02056ae:	63bc                	ld	a5,64(a5)
ffffffffc02056b0:	cfa1                	beqz	a5,ffffffffc0205708 <file_getdirentry+0xc2>
ffffffffc02056b2:	854e                	mv	a0,s3
ffffffffc02056b4:	00008597          	auipc	a1,0x8
ffffffffc02056b8:	f2c58593          	addi	a1,a1,-212 # ffffffffc020d5e0 <default_pmm_manager+0xbb8>
ffffffffc02056bc:	495020ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc02056c0:	0709b783          	ld	a5,112(s3)
ffffffffc02056c4:	7408                	ld	a0,40(s0)
ffffffffc02056c6:	85ca                	mv	a1,s2
ffffffffc02056c8:	63bc                	ld	a5,64(a5)
ffffffffc02056ca:	9782                	jalr	a5
ffffffffc02056cc:	89aa                	mv	s3,a0
ffffffffc02056ce:	e909                	bnez	a0,ffffffffc02056e0 <file_getdirentry+0x9a>
ffffffffc02056d0:	609c                	ld	a5,0(s1)
ffffffffc02056d2:	01093683          	ld	a3,16(s2)
ffffffffc02056d6:	01893703          	ld	a4,24(s2)
ffffffffc02056da:	97b6                	add	a5,a5,a3
ffffffffc02056dc:	8f99                	sub	a5,a5,a4
ffffffffc02056de:	e09c                	sd	a5,0(s1)
ffffffffc02056e0:	8522                	mv	a0,s0
ffffffffc02056e2:	fb8ff0ef          	jal	ra,ffffffffc0204e9a <fd_array_release>
ffffffffc02056e6:	60a6                	ld	ra,72(sp)
ffffffffc02056e8:	6406                	ld	s0,64(sp)
ffffffffc02056ea:	74e2                	ld	s1,56(sp)
ffffffffc02056ec:	7942                	ld	s2,48(sp)
ffffffffc02056ee:	854e                	mv	a0,s3
ffffffffc02056f0:	79a2                	ld	s3,40(sp)
ffffffffc02056f2:	6161                	addi	sp,sp,80
ffffffffc02056f4:	8082                	ret
ffffffffc02056f6:	60a6                	ld	ra,72(sp)
ffffffffc02056f8:	6406                	ld	s0,64(sp)
ffffffffc02056fa:	59f5                	li	s3,-3
ffffffffc02056fc:	74e2                	ld	s1,56(sp)
ffffffffc02056fe:	7942                	ld	s2,48(sp)
ffffffffc0205700:	854e                	mv	a0,s3
ffffffffc0205702:	79a2                	ld	s3,40(sp)
ffffffffc0205704:	6161                	addi	sp,sp,80
ffffffffc0205706:	8082                	ret
ffffffffc0205708:	00008697          	auipc	a3,0x8
ffffffffc020570c:	e8068693          	addi	a3,a3,-384 # ffffffffc020d588 <default_pmm_manager+0xb60>
ffffffffc0205710:	00006617          	auipc	a2,0x6
ffffffffc0205714:	50860613          	addi	a2,a2,1288 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205718:	14a00593          	li	a1,330
ffffffffc020571c:	00008517          	auipc	a0,0x8
ffffffffc0205720:	b7c50513          	addi	a0,a0,-1156 # ffffffffc020d298 <default_pmm_manager+0x870>
ffffffffc0205724:	b0bfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205728:	e40ff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>

ffffffffc020572c <file_dup>:
ffffffffc020572c:	04700713          	li	a4,71
ffffffffc0205730:	06a76463          	bltu	a4,a0,ffffffffc0205798 <file_dup+0x6c>
ffffffffc0205734:	00091717          	auipc	a4,0x91
ffffffffc0205738:	18c73703          	ld	a4,396(a4) # ffffffffc02968c0 <current>
ffffffffc020573c:	14873703          	ld	a4,328(a4)
ffffffffc0205740:	1101                	addi	sp,sp,-32
ffffffffc0205742:	ec06                	sd	ra,24(sp)
ffffffffc0205744:	e822                	sd	s0,16(sp)
ffffffffc0205746:	cb39                	beqz	a4,ffffffffc020579c <file_dup+0x70>
ffffffffc0205748:	4b14                	lw	a3,16(a4)
ffffffffc020574a:	04d05963          	blez	a3,ffffffffc020579c <file_dup+0x70>
ffffffffc020574e:	6700                	ld	s0,8(a4)
ffffffffc0205750:	00351713          	slli	a4,a0,0x3
ffffffffc0205754:	8f09                	sub	a4,a4,a0
ffffffffc0205756:	070e                	slli	a4,a4,0x3
ffffffffc0205758:	943a                	add	s0,s0,a4
ffffffffc020575a:	4014                	lw	a3,0(s0)
ffffffffc020575c:	4709                	li	a4,2
ffffffffc020575e:	02e69863          	bne	a3,a4,ffffffffc020578e <file_dup+0x62>
ffffffffc0205762:	4c18                	lw	a4,24(s0)
ffffffffc0205764:	02a71563          	bne	a4,a0,ffffffffc020578e <file_dup+0x62>
ffffffffc0205768:	852e                	mv	a0,a1
ffffffffc020576a:	002c                	addi	a1,sp,8
ffffffffc020576c:	e1eff0ef          	jal	ra,ffffffffc0204d8a <fd_array_alloc>
ffffffffc0205770:	c509                	beqz	a0,ffffffffc020577a <file_dup+0x4e>
ffffffffc0205772:	60e2                	ld	ra,24(sp)
ffffffffc0205774:	6442                	ld	s0,16(sp)
ffffffffc0205776:	6105                	addi	sp,sp,32
ffffffffc0205778:	8082                	ret
ffffffffc020577a:	6522                	ld	a0,8(sp)
ffffffffc020577c:	85a2                	mv	a1,s0
ffffffffc020577e:	845ff0ef          	jal	ra,ffffffffc0204fc2 <fd_array_dup>
ffffffffc0205782:	67a2                	ld	a5,8(sp)
ffffffffc0205784:	60e2                	ld	ra,24(sp)
ffffffffc0205786:	6442                	ld	s0,16(sp)
ffffffffc0205788:	4f88                	lw	a0,24(a5)
ffffffffc020578a:	6105                	addi	sp,sp,32
ffffffffc020578c:	8082                	ret
ffffffffc020578e:	60e2                	ld	ra,24(sp)
ffffffffc0205790:	6442                	ld	s0,16(sp)
ffffffffc0205792:	5575                	li	a0,-3
ffffffffc0205794:	6105                	addi	sp,sp,32
ffffffffc0205796:	8082                	ret
ffffffffc0205798:	5575                	li	a0,-3
ffffffffc020579a:	8082                	ret
ffffffffc020579c:	dccff0ef          	jal	ra,ffffffffc0204d68 <get_fd_array.part.0>

ffffffffc02057a0 <iobuf_skip.part.0>:
ffffffffc02057a0:	1141                	addi	sp,sp,-16
ffffffffc02057a2:	00008697          	auipc	a3,0x8
ffffffffc02057a6:	e7e68693          	addi	a3,a3,-386 # ffffffffc020d620 <CSWTCH.79+0x18>
ffffffffc02057aa:	00006617          	auipc	a2,0x6
ffffffffc02057ae:	46e60613          	addi	a2,a2,1134 # ffffffffc020bc18 <commands+0x250>
ffffffffc02057b2:	04a00593          	li	a1,74
ffffffffc02057b6:	00008517          	auipc	a0,0x8
ffffffffc02057ba:	e8250513          	addi	a0,a0,-382 # ffffffffc020d638 <CSWTCH.79+0x30>
ffffffffc02057be:	e406                	sd	ra,8(sp)
ffffffffc02057c0:	a6ffa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02057c4 <iobuf_init>:
ffffffffc02057c4:	e10c                	sd	a1,0(a0)
ffffffffc02057c6:	e514                	sd	a3,8(a0)
ffffffffc02057c8:	ed10                	sd	a2,24(a0)
ffffffffc02057ca:	e910                	sd	a2,16(a0)
ffffffffc02057cc:	8082                	ret

ffffffffc02057ce <iobuf_move>:
ffffffffc02057ce:	7179                	addi	sp,sp,-48
ffffffffc02057d0:	ec26                	sd	s1,24(sp)
ffffffffc02057d2:	6d04                	ld	s1,24(a0)
ffffffffc02057d4:	f022                	sd	s0,32(sp)
ffffffffc02057d6:	e84a                	sd	s2,16(sp)
ffffffffc02057d8:	e44e                	sd	s3,8(sp)
ffffffffc02057da:	f406                	sd	ra,40(sp)
ffffffffc02057dc:	842a                	mv	s0,a0
ffffffffc02057de:	8932                	mv	s2,a2
ffffffffc02057e0:	852e                	mv	a0,a1
ffffffffc02057e2:	89ba                	mv	s3,a4
ffffffffc02057e4:	00967363          	bgeu	a2,s1,ffffffffc02057ea <iobuf_move+0x1c>
ffffffffc02057e8:	84b2                	mv	s1,a2
ffffffffc02057ea:	c495                	beqz	s1,ffffffffc0205816 <iobuf_move+0x48>
ffffffffc02057ec:	600c                	ld	a1,0(s0)
ffffffffc02057ee:	c681                	beqz	a3,ffffffffc02057f6 <iobuf_move+0x28>
ffffffffc02057f0:	87ae                	mv	a5,a1
ffffffffc02057f2:	85aa                	mv	a1,a0
ffffffffc02057f4:	853e                	mv	a0,a5
ffffffffc02057f6:	8626                	mv	a2,s1
ffffffffc02057f8:	239050ef          	jal	ra,ffffffffc020b230 <memmove>
ffffffffc02057fc:	6c1c                	ld	a5,24(s0)
ffffffffc02057fe:	0297ea63          	bltu	a5,s1,ffffffffc0205832 <iobuf_move+0x64>
ffffffffc0205802:	6014                	ld	a3,0(s0)
ffffffffc0205804:	6418                	ld	a4,8(s0)
ffffffffc0205806:	8f85                	sub	a5,a5,s1
ffffffffc0205808:	96a6                	add	a3,a3,s1
ffffffffc020580a:	9726                	add	a4,a4,s1
ffffffffc020580c:	e014                	sd	a3,0(s0)
ffffffffc020580e:	e418                	sd	a4,8(s0)
ffffffffc0205810:	ec1c                	sd	a5,24(s0)
ffffffffc0205812:	40990933          	sub	s2,s2,s1
ffffffffc0205816:	00098463          	beqz	s3,ffffffffc020581e <iobuf_move+0x50>
ffffffffc020581a:	0099b023          	sd	s1,0(s3)
ffffffffc020581e:	4501                	li	a0,0
ffffffffc0205820:	00091b63          	bnez	s2,ffffffffc0205836 <iobuf_move+0x68>
ffffffffc0205824:	70a2                	ld	ra,40(sp)
ffffffffc0205826:	7402                	ld	s0,32(sp)
ffffffffc0205828:	64e2                	ld	s1,24(sp)
ffffffffc020582a:	6942                	ld	s2,16(sp)
ffffffffc020582c:	69a2                	ld	s3,8(sp)
ffffffffc020582e:	6145                	addi	sp,sp,48
ffffffffc0205830:	8082                	ret
ffffffffc0205832:	f6fff0ef          	jal	ra,ffffffffc02057a0 <iobuf_skip.part.0>
ffffffffc0205836:	5571                	li	a0,-4
ffffffffc0205838:	b7f5                	j	ffffffffc0205824 <iobuf_move+0x56>

ffffffffc020583a <iobuf_skip>:
ffffffffc020583a:	6d1c                	ld	a5,24(a0)
ffffffffc020583c:	00b7eb63          	bltu	a5,a1,ffffffffc0205852 <iobuf_skip+0x18>
ffffffffc0205840:	6114                	ld	a3,0(a0)
ffffffffc0205842:	6518                	ld	a4,8(a0)
ffffffffc0205844:	8f8d                	sub	a5,a5,a1
ffffffffc0205846:	96ae                	add	a3,a3,a1
ffffffffc0205848:	95ba                	add	a1,a1,a4
ffffffffc020584a:	e114                	sd	a3,0(a0)
ffffffffc020584c:	e50c                	sd	a1,8(a0)
ffffffffc020584e:	ed1c                	sd	a5,24(a0)
ffffffffc0205850:	8082                	ret
ffffffffc0205852:	1141                	addi	sp,sp,-16
ffffffffc0205854:	e406                	sd	ra,8(sp)
ffffffffc0205856:	f4bff0ef          	jal	ra,ffffffffc02057a0 <iobuf_skip.part.0>

ffffffffc020585a <fs_init>:
ffffffffc020585a:	1141                	addi	sp,sp,-16
ffffffffc020585c:	e406                	sd	ra,8(sp)
ffffffffc020585e:	511020ef          	jal	ra,ffffffffc020856e <vfs_init>
ffffffffc0205862:	748030ef          	jal	ra,ffffffffc0208faa <dev_init>
ffffffffc0205866:	60a2                	ld	ra,8(sp)
ffffffffc0205868:	0141                	addi	sp,sp,16
ffffffffc020586a:	7800306f          	j	ffffffffc0208fea <sfs_init>

ffffffffc020586e <fs_cleanup>:
ffffffffc020586e:	23a0206f          	j	ffffffffc0207aa8 <vfs_cleanup>

ffffffffc0205872 <lock_files>:
ffffffffc0205872:	0561                	addi	a0,a0,24
ffffffffc0205874:	f6ffe06f          	j	ffffffffc02047e2 <down>

ffffffffc0205878 <unlock_files>:
ffffffffc0205878:	0561                	addi	a0,a0,24
ffffffffc020587a:	f65fe06f          	j	ffffffffc02047de <up>

ffffffffc020587e <files_create>:
ffffffffc020587e:	1141                	addi	sp,sp,-16
ffffffffc0205880:	6505                	lui	a0,0x1
ffffffffc0205882:	e022                	sd	s0,0(sp)
ffffffffc0205884:	e406                	sd	ra,8(sp)
ffffffffc0205886:	d28fc0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020588a:	842a                	mv	s0,a0
ffffffffc020588c:	cd19                	beqz	a0,ffffffffc02058aa <files_create+0x2c>
ffffffffc020588e:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc0205892:	00043023          	sd	zero,0(s0)
ffffffffc0205896:	0561                	addi	a0,a0,24
ffffffffc0205898:	e41c                	sd	a5,8(s0)
ffffffffc020589a:	00042823          	sw	zero,16(s0)
ffffffffc020589e:	4585                	li	a1,1
ffffffffc02058a0:	f37fe0ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc02058a4:	6408                	ld	a0,8(s0)
ffffffffc02058a6:	e82ff0ef          	jal	ra,ffffffffc0204f28 <fd_array_init>
ffffffffc02058aa:	60a2                	ld	ra,8(sp)
ffffffffc02058ac:	8522                	mv	a0,s0
ffffffffc02058ae:	6402                	ld	s0,0(sp)
ffffffffc02058b0:	0141                	addi	sp,sp,16
ffffffffc02058b2:	8082                	ret

ffffffffc02058b4 <files_destroy>:
ffffffffc02058b4:	7179                	addi	sp,sp,-48
ffffffffc02058b6:	f406                	sd	ra,40(sp)
ffffffffc02058b8:	f022                	sd	s0,32(sp)
ffffffffc02058ba:	ec26                	sd	s1,24(sp)
ffffffffc02058bc:	e84a                	sd	s2,16(sp)
ffffffffc02058be:	e44e                	sd	s3,8(sp)
ffffffffc02058c0:	c52d                	beqz	a0,ffffffffc020592a <files_destroy+0x76>
ffffffffc02058c2:	491c                	lw	a5,16(a0)
ffffffffc02058c4:	89aa                	mv	s3,a0
ffffffffc02058c6:	e3b5                	bnez	a5,ffffffffc020592a <files_destroy+0x76>
ffffffffc02058c8:	6108                	ld	a0,0(a0)
ffffffffc02058ca:	c119                	beqz	a0,ffffffffc02058d0 <files_destroy+0x1c>
ffffffffc02058cc:	33b020ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc02058d0:	0089b403          	ld	s0,8(s3)
ffffffffc02058d4:	6485                	lui	s1,0x1
ffffffffc02058d6:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02058da:	94a2                	add	s1,s1,s0
ffffffffc02058dc:	4909                	li	s2,2
ffffffffc02058de:	401c                	lw	a5,0(s0)
ffffffffc02058e0:	03278063          	beq	a5,s2,ffffffffc0205900 <files_destroy+0x4c>
ffffffffc02058e4:	e39d                	bnez	a5,ffffffffc020590a <files_destroy+0x56>
ffffffffc02058e6:	03840413          	addi	s0,s0,56
ffffffffc02058ea:	fe849ae3          	bne	s1,s0,ffffffffc02058de <files_destroy+0x2a>
ffffffffc02058ee:	7402                	ld	s0,32(sp)
ffffffffc02058f0:	70a2                	ld	ra,40(sp)
ffffffffc02058f2:	64e2                	ld	s1,24(sp)
ffffffffc02058f4:	6942                	ld	s2,16(sp)
ffffffffc02058f6:	854e                	mv	a0,s3
ffffffffc02058f8:	69a2                	ld	s3,8(sp)
ffffffffc02058fa:	6145                	addi	sp,sp,48
ffffffffc02058fc:	d62fc06f          	j	ffffffffc0201e5e <kfree>
ffffffffc0205900:	8522                	mv	a0,s0
ffffffffc0205902:	e42ff0ef          	jal	ra,ffffffffc0204f44 <fd_array_close>
ffffffffc0205906:	401c                	lw	a5,0(s0)
ffffffffc0205908:	bff1                	j	ffffffffc02058e4 <files_destroy+0x30>
ffffffffc020590a:	00008697          	auipc	a3,0x8
ffffffffc020590e:	d7e68693          	addi	a3,a3,-642 # ffffffffc020d688 <CSWTCH.79+0x80>
ffffffffc0205912:	00006617          	auipc	a2,0x6
ffffffffc0205916:	30660613          	addi	a2,a2,774 # ffffffffc020bc18 <commands+0x250>
ffffffffc020591a:	03d00593          	li	a1,61
ffffffffc020591e:	00008517          	auipc	a0,0x8
ffffffffc0205922:	d5a50513          	addi	a0,a0,-678 # ffffffffc020d678 <CSWTCH.79+0x70>
ffffffffc0205926:	909fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020592a:	00008697          	auipc	a3,0x8
ffffffffc020592e:	d1e68693          	addi	a3,a3,-738 # ffffffffc020d648 <CSWTCH.79+0x40>
ffffffffc0205932:	00006617          	auipc	a2,0x6
ffffffffc0205936:	2e660613          	addi	a2,a2,742 # ffffffffc020bc18 <commands+0x250>
ffffffffc020593a:	03300593          	li	a1,51
ffffffffc020593e:	00008517          	auipc	a0,0x8
ffffffffc0205942:	d3a50513          	addi	a0,a0,-710 # ffffffffc020d678 <CSWTCH.79+0x70>
ffffffffc0205946:	8e9fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020594a <files_closeall>:
ffffffffc020594a:	1101                	addi	sp,sp,-32
ffffffffc020594c:	ec06                	sd	ra,24(sp)
ffffffffc020594e:	e822                	sd	s0,16(sp)
ffffffffc0205950:	e426                	sd	s1,8(sp)
ffffffffc0205952:	e04a                	sd	s2,0(sp)
ffffffffc0205954:	c129                	beqz	a0,ffffffffc0205996 <files_closeall+0x4c>
ffffffffc0205956:	491c                	lw	a5,16(a0)
ffffffffc0205958:	02f05f63          	blez	a5,ffffffffc0205996 <files_closeall+0x4c>
ffffffffc020595c:	6504                	ld	s1,8(a0)
ffffffffc020595e:	6785                	lui	a5,0x1
ffffffffc0205960:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205964:	07048413          	addi	s0,s1,112
ffffffffc0205968:	4909                	li	s2,2
ffffffffc020596a:	94be                	add	s1,s1,a5
ffffffffc020596c:	a029                	j	ffffffffc0205976 <files_closeall+0x2c>
ffffffffc020596e:	03840413          	addi	s0,s0,56
ffffffffc0205972:	00848c63          	beq	s1,s0,ffffffffc020598a <files_closeall+0x40>
ffffffffc0205976:	401c                	lw	a5,0(s0)
ffffffffc0205978:	ff279be3          	bne	a5,s2,ffffffffc020596e <files_closeall+0x24>
ffffffffc020597c:	8522                	mv	a0,s0
ffffffffc020597e:	03840413          	addi	s0,s0,56
ffffffffc0205982:	dc2ff0ef          	jal	ra,ffffffffc0204f44 <fd_array_close>
ffffffffc0205986:	fe8498e3          	bne	s1,s0,ffffffffc0205976 <files_closeall+0x2c>
ffffffffc020598a:	60e2                	ld	ra,24(sp)
ffffffffc020598c:	6442                	ld	s0,16(sp)
ffffffffc020598e:	64a2                	ld	s1,8(sp)
ffffffffc0205990:	6902                	ld	s2,0(sp)
ffffffffc0205992:	6105                	addi	sp,sp,32
ffffffffc0205994:	8082                	ret
ffffffffc0205996:	00008697          	auipc	a3,0x8
ffffffffc020599a:	8d268693          	addi	a3,a3,-1838 # ffffffffc020d268 <default_pmm_manager+0x840>
ffffffffc020599e:	00006617          	auipc	a2,0x6
ffffffffc02059a2:	27a60613          	addi	a2,a2,634 # ffffffffc020bc18 <commands+0x250>
ffffffffc02059a6:	04500593          	li	a1,69
ffffffffc02059aa:	00008517          	auipc	a0,0x8
ffffffffc02059ae:	cce50513          	addi	a0,a0,-818 # ffffffffc020d678 <CSWTCH.79+0x70>
ffffffffc02059b2:	87dfa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02059b6 <dup_files>:
ffffffffc02059b6:	7179                	addi	sp,sp,-48
ffffffffc02059b8:	f406                	sd	ra,40(sp)
ffffffffc02059ba:	f022                	sd	s0,32(sp)
ffffffffc02059bc:	ec26                	sd	s1,24(sp)
ffffffffc02059be:	e84a                	sd	s2,16(sp)
ffffffffc02059c0:	e44e                	sd	s3,8(sp)
ffffffffc02059c2:	e052                	sd	s4,0(sp)
ffffffffc02059c4:	c52d                	beqz	a0,ffffffffc0205a2e <dup_files+0x78>
ffffffffc02059c6:	842e                	mv	s0,a1
ffffffffc02059c8:	c1bd                	beqz	a1,ffffffffc0205a2e <dup_files+0x78>
ffffffffc02059ca:	491c                	lw	a5,16(a0)
ffffffffc02059cc:	84aa                	mv	s1,a0
ffffffffc02059ce:	e3c1                	bnez	a5,ffffffffc0205a4e <dup_files+0x98>
ffffffffc02059d0:	499c                	lw	a5,16(a1)
ffffffffc02059d2:	06f05e63          	blez	a5,ffffffffc0205a4e <dup_files+0x98>
ffffffffc02059d6:	6188                	ld	a0,0(a1)
ffffffffc02059d8:	e088                	sd	a0,0(s1)
ffffffffc02059da:	c119                	beqz	a0,ffffffffc02059e0 <dup_files+0x2a>
ffffffffc02059dc:	15d020ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc02059e0:	6400                	ld	s0,8(s0)
ffffffffc02059e2:	6905                	lui	s2,0x1
ffffffffc02059e4:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02059e8:	6484                	ld	s1,8(s1)
ffffffffc02059ea:	9922                	add	s2,s2,s0
ffffffffc02059ec:	4989                	li	s3,2
ffffffffc02059ee:	4a05                	li	s4,1
ffffffffc02059f0:	a039                	j	ffffffffc02059fe <dup_files+0x48>
ffffffffc02059f2:	03840413          	addi	s0,s0,56
ffffffffc02059f6:	03848493          	addi	s1,s1,56
ffffffffc02059fa:	02890163          	beq	s2,s0,ffffffffc0205a1c <dup_files+0x66>
ffffffffc02059fe:	401c                	lw	a5,0(s0)
ffffffffc0205a00:	ff3799e3          	bne	a5,s3,ffffffffc02059f2 <dup_files+0x3c>
ffffffffc0205a04:	0144a023          	sw	s4,0(s1)
ffffffffc0205a08:	85a2                	mv	a1,s0
ffffffffc0205a0a:	8526                	mv	a0,s1
ffffffffc0205a0c:	03840413          	addi	s0,s0,56
ffffffffc0205a10:	db2ff0ef          	jal	ra,ffffffffc0204fc2 <fd_array_dup>
ffffffffc0205a14:	03848493          	addi	s1,s1,56
ffffffffc0205a18:	fe8913e3          	bne	s2,s0,ffffffffc02059fe <dup_files+0x48>
ffffffffc0205a1c:	70a2                	ld	ra,40(sp)
ffffffffc0205a1e:	7402                	ld	s0,32(sp)
ffffffffc0205a20:	64e2                	ld	s1,24(sp)
ffffffffc0205a22:	6942                	ld	s2,16(sp)
ffffffffc0205a24:	69a2                	ld	s3,8(sp)
ffffffffc0205a26:	6a02                	ld	s4,0(sp)
ffffffffc0205a28:	4501                	li	a0,0
ffffffffc0205a2a:	6145                	addi	sp,sp,48
ffffffffc0205a2c:	8082                	ret
ffffffffc0205a2e:	00007697          	auipc	a3,0x7
ffffffffc0205a32:	99a68693          	addi	a3,a3,-1638 # ffffffffc020c3c8 <commands+0xa00>
ffffffffc0205a36:	00006617          	auipc	a2,0x6
ffffffffc0205a3a:	1e260613          	addi	a2,a2,482 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205a3e:	05300593          	li	a1,83
ffffffffc0205a42:	00008517          	auipc	a0,0x8
ffffffffc0205a46:	c3650513          	addi	a0,a0,-970 # ffffffffc020d678 <CSWTCH.79+0x70>
ffffffffc0205a4a:	fe4fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205a4e:	00008697          	auipc	a3,0x8
ffffffffc0205a52:	c5268693          	addi	a3,a3,-942 # ffffffffc020d6a0 <CSWTCH.79+0x98>
ffffffffc0205a56:	00006617          	auipc	a2,0x6
ffffffffc0205a5a:	1c260613          	addi	a2,a2,450 # ffffffffc020bc18 <commands+0x250>
ffffffffc0205a5e:	05400593          	li	a1,84
ffffffffc0205a62:	00008517          	auipc	a0,0x8
ffffffffc0205a66:	c1650513          	addi	a0,a0,-1002 # ffffffffc020d678 <CSWTCH.79+0x70>
ffffffffc0205a6a:	fc4fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205a6e <switch_to>:
ffffffffc0205a6e:	00153023          	sd	ra,0(a0)
ffffffffc0205a72:	00253423          	sd	sp,8(a0)
ffffffffc0205a76:	e900                	sd	s0,16(a0)
ffffffffc0205a78:	ed04                	sd	s1,24(a0)
ffffffffc0205a7a:	03253023          	sd	s2,32(a0)
ffffffffc0205a7e:	03353423          	sd	s3,40(a0)
ffffffffc0205a82:	03453823          	sd	s4,48(a0)
ffffffffc0205a86:	03553c23          	sd	s5,56(a0)
ffffffffc0205a8a:	05653023          	sd	s6,64(a0)
ffffffffc0205a8e:	05753423          	sd	s7,72(a0)
ffffffffc0205a92:	05853823          	sd	s8,80(a0)
ffffffffc0205a96:	05953c23          	sd	s9,88(a0)
ffffffffc0205a9a:	07a53023          	sd	s10,96(a0)
ffffffffc0205a9e:	07b53423          	sd	s11,104(a0)
ffffffffc0205aa2:	0005b083          	ld	ra,0(a1)
ffffffffc0205aa6:	0085b103          	ld	sp,8(a1)
ffffffffc0205aaa:	6980                	ld	s0,16(a1)
ffffffffc0205aac:	6d84                	ld	s1,24(a1)
ffffffffc0205aae:	0205b903          	ld	s2,32(a1)
ffffffffc0205ab2:	0285b983          	ld	s3,40(a1)
ffffffffc0205ab6:	0305ba03          	ld	s4,48(a1)
ffffffffc0205aba:	0385ba83          	ld	s5,56(a1)
ffffffffc0205abe:	0405bb03          	ld	s6,64(a1)
ffffffffc0205ac2:	0485bb83          	ld	s7,72(a1)
ffffffffc0205ac6:	0505bc03          	ld	s8,80(a1)
ffffffffc0205aca:	0585bc83          	ld	s9,88(a1)
ffffffffc0205ace:	0605bd03          	ld	s10,96(a1)
ffffffffc0205ad2:	0685bd83          	ld	s11,104(a1)
ffffffffc0205ad6:	8082                	ret

ffffffffc0205ad8 <kernel_thread_entry>:
ffffffffc0205ad8:	8526                	mv	a0,s1
ffffffffc0205ada:	9402                	jalr	s0
ffffffffc0205adc:	5fe000ef          	jal	ra,ffffffffc02060da <do_exit>

ffffffffc0205ae0 <alloc_proc>:
ffffffffc0205ae0:	1141                	addi	sp,sp,-16
ffffffffc0205ae2:	15000513          	li	a0,336
ffffffffc0205ae6:	e022                	sd	s0,0(sp)
ffffffffc0205ae8:	e406                	sd	ra,8(sp)
ffffffffc0205aea:	ac4fc0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0205aee:	842a                	mv	s0,a0
ffffffffc0205af0:	c141                	beqz	a0,ffffffffc0205b70 <alloc_proc+0x90>
ffffffffc0205af2:	57fd                	li	a5,-1
ffffffffc0205af4:	1782                	slli	a5,a5,0x20
ffffffffc0205af6:	e11c                	sd	a5,0(a0)
ffffffffc0205af8:	07000613          	li	a2,112
ffffffffc0205afc:	4581                	li	a1,0
ffffffffc0205afe:	00052423          	sw	zero,8(a0)
ffffffffc0205b02:	00053823          	sd	zero,16(a0)
ffffffffc0205b06:	00053c23          	sd	zero,24(a0)
ffffffffc0205b0a:	02053023          	sd	zero,32(a0)
ffffffffc0205b0e:	02053423          	sd	zero,40(a0)
ffffffffc0205b12:	03050513          	addi	a0,a0,48
ffffffffc0205b16:	708050ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0205b1a:	00091797          	auipc	a5,0x91
ffffffffc0205b1e:	d767b783          	ld	a5,-650(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205b22:	f45c                	sd	a5,168(s0)
ffffffffc0205b24:	0a043023          	sd	zero,160(s0)
ffffffffc0205b28:	0a042823          	sw	zero,176(s0)
ffffffffc0205b2c:	463d                	li	a2,15
ffffffffc0205b2e:	4581                	li	a1,0
ffffffffc0205b30:	0b440513          	addi	a0,s0,180
ffffffffc0205b34:	6ea050ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0205b38:	11040793          	addi	a5,s0,272
ffffffffc0205b3c:	0e042623          	sw	zero,236(s0)
ffffffffc0205b40:	0e043c23          	sd	zero,248(s0)
ffffffffc0205b44:	10043023          	sd	zero,256(s0)
ffffffffc0205b48:	0e043823          	sd	zero,240(s0)
ffffffffc0205b4c:	10043423          	sd	zero,264(s0)
ffffffffc0205b50:	10f43c23          	sd	a5,280(s0)
ffffffffc0205b54:	10f43823          	sd	a5,272(s0)
ffffffffc0205b58:	12042023          	sw	zero,288(s0)
ffffffffc0205b5c:	12043423          	sd	zero,296(s0)
ffffffffc0205b60:	12043823          	sd	zero,304(s0)
ffffffffc0205b64:	12043c23          	sd	zero,312(s0)
ffffffffc0205b68:	14043023          	sd	zero,320(s0)
ffffffffc0205b6c:	14043423          	sd	zero,328(s0)
ffffffffc0205b70:	60a2                	ld	ra,8(sp)
ffffffffc0205b72:	8522                	mv	a0,s0
ffffffffc0205b74:	6402                	ld	s0,0(sp)
ffffffffc0205b76:	0141                	addi	sp,sp,16
ffffffffc0205b78:	8082                	ret

ffffffffc0205b7a <forkret>:
ffffffffc0205b7a:	00091797          	auipc	a5,0x91
ffffffffc0205b7e:	d467b783          	ld	a5,-698(a5) # ffffffffc02968c0 <current>
ffffffffc0205b82:	73c8                	ld	a0,160(a5)
ffffffffc0205b84:	fc6fb06f          	j	ffffffffc020134a <forkrets>

ffffffffc0205b88 <put_pgdir.isra.0>:
ffffffffc0205b88:	1141                	addi	sp,sp,-16
ffffffffc0205b8a:	e406                	sd	ra,8(sp)
ffffffffc0205b8c:	c02007b7          	lui	a5,0xc0200
ffffffffc0205b90:	02f56e63          	bltu	a0,a5,ffffffffc0205bcc <put_pgdir.isra.0+0x44>
ffffffffc0205b94:	00091697          	auipc	a3,0x91
ffffffffc0205b98:	d246b683          	ld	a3,-732(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205b9c:	8d15                	sub	a0,a0,a3
ffffffffc0205b9e:	8131                	srli	a0,a0,0xc
ffffffffc0205ba0:	00091797          	auipc	a5,0x91
ffffffffc0205ba4:	d007b783          	ld	a5,-768(a5) # ffffffffc02968a0 <npage>
ffffffffc0205ba8:	02f57f63          	bgeu	a0,a5,ffffffffc0205be6 <put_pgdir.isra.0+0x5e>
ffffffffc0205bac:	0000a697          	auipc	a3,0xa
ffffffffc0205bb0:	d746b683          	ld	a3,-652(a3) # ffffffffc020f920 <nbase>
ffffffffc0205bb4:	60a2                	ld	ra,8(sp)
ffffffffc0205bb6:	8d15                	sub	a0,a0,a3
ffffffffc0205bb8:	00091797          	auipc	a5,0x91
ffffffffc0205bbc:	cf07b783          	ld	a5,-784(a5) # ffffffffc02968a8 <pages>
ffffffffc0205bc0:	051a                	slli	a0,a0,0x6
ffffffffc0205bc2:	4585                	li	a1,1
ffffffffc0205bc4:	953e                	add	a0,a0,a5
ffffffffc0205bc6:	0141                	addi	sp,sp,16
ffffffffc0205bc8:	eb1fc06f          	j	ffffffffc0202a78 <free_pages>
ffffffffc0205bcc:	86aa                	mv	a3,a0
ffffffffc0205bce:	00007617          	auipc	a2,0x7
ffffffffc0205bd2:	a6a60613          	addi	a2,a2,-1430 # ffffffffc020c638 <commands+0xc70>
ffffffffc0205bd6:	07700593          	li	a1,119
ffffffffc0205bda:	00007517          	auipc	a0,0x7
ffffffffc0205bde:	9de50513          	addi	a0,a0,-1570 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0205be2:	e4cfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205be6:	00007617          	auipc	a2,0x7
ffffffffc0205bea:	a7a60613          	addi	a2,a2,-1414 # ffffffffc020c660 <commands+0xc98>
ffffffffc0205bee:	06900593          	li	a1,105
ffffffffc0205bf2:	00007517          	auipc	a0,0x7
ffffffffc0205bf6:	9c650513          	addi	a0,a0,-1594 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0205bfa:	e34fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205bfe <proc_run>:
ffffffffc0205bfe:	7179                	addi	sp,sp,-48
ffffffffc0205c00:	ec26                	sd	s1,24(sp)
ffffffffc0205c02:	00091497          	auipc	s1,0x91
ffffffffc0205c06:	cbe48493          	addi	s1,s1,-834 # ffffffffc02968c0 <current>
ffffffffc0205c0a:	f022                	sd	s0,32(sp)
ffffffffc0205c0c:	e44e                	sd	s3,8(sp)
ffffffffc0205c0e:	f406                	sd	ra,40(sp)
ffffffffc0205c10:	0004b983          	ld	s3,0(s1)
ffffffffc0205c14:	e84a                	sd	s2,16(sp)
ffffffffc0205c16:	842a                	mv	s0,a0
ffffffffc0205c18:	100027f3          	csrr	a5,sstatus
ffffffffc0205c1c:	8b89                	andi	a5,a5,2
ffffffffc0205c1e:	4901                	li	s2,0
ffffffffc0205c20:	e7b9                	bnez	a5,ffffffffc0205c6e <proc_run+0x70>
ffffffffc0205c22:	745c                	ld	a5,168(s0)
ffffffffc0205c24:	577d                	li	a4,-1
ffffffffc0205c26:	177e                	slli	a4,a4,0x3f
ffffffffc0205c28:	83b1                	srli	a5,a5,0xc
ffffffffc0205c2a:	e080                	sd	s0,0(s1)
ffffffffc0205c2c:	8fd9                	or	a5,a5,a4
ffffffffc0205c2e:	18079073          	csrw	satp,a5
ffffffffc0205c32:	441c                	lw	a5,8(s0)
ffffffffc0205c34:	00043c23          	sd	zero,24(s0)
ffffffffc0205c38:	2785                	addiw	a5,a5,1
ffffffffc0205c3a:	c41c                	sw	a5,8(s0)
ffffffffc0205c3c:	12000073          	sfence.vma
ffffffffc0205c40:	03040593          	addi	a1,s0,48
ffffffffc0205c44:	03098513          	addi	a0,s3,48
ffffffffc0205c48:	e27ff0ef          	jal	ra,ffffffffc0205a6e <switch_to>
ffffffffc0205c4c:	00091963          	bnez	s2,ffffffffc0205c5e <proc_run+0x60>
ffffffffc0205c50:	70a2                	ld	ra,40(sp)
ffffffffc0205c52:	7402                	ld	s0,32(sp)
ffffffffc0205c54:	64e2                	ld	s1,24(sp)
ffffffffc0205c56:	6942                	ld	s2,16(sp)
ffffffffc0205c58:	69a2                	ld	s3,8(sp)
ffffffffc0205c5a:	6145                	addi	sp,sp,48
ffffffffc0205c5c:	8082                	ret
ffffffffc0205c5e:	7402                	ld	s0,32(sp)
ffffffffc0205c60:	70a2                	ld	ra,40(sp)
ffffffffc0205c62:	64e2                	ld	s1,24(sp)
ffffffffc0205c64:	6942                	ld	s2,16(sp)
ffffffffc0205c66:	69a2                	ld	s3,8(sp)
ffffffffc0205c68:	6145                	addi	sp,sp,48
ffffffffc0205c6a:	930fb06f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0205c6e:	932fb0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0205c72:	4905                	li	s2,1
ffffffffc0205c74:	b77d                	j	ffffffffc0205c22 <proc_run+0x24>

ffffffffc0205c76 <do_fork>:
ffffffffc0205c76:	7119                	addi	sp,sp,-128
ffffffffc0205c78:	ecce                	sd	s3,88(sp)
ffffffffc0205c7a:	00091997          	auipc	s3,0x91
ffffffffc0205c7e:	c5e98993          	addi	s3,s3,-930 # ffffffffc02968d8 <nr_process>
ffffffffc0205c82:	0009a703          	lw	a4,0(s3)
ffffffffc0205c86:	fc86                	sd	ra,120(sp)
ffffffffc0205c88:	f8a2                	sd	s0,112(sp)
ffffffffc0205c8a:	f4a6                	sd	s1,104(sp)
ffffffffc0205c8c:	f0ca                	sd	s2,96(sp)
ffffffffc0205c8e:	e8d2                	sd	s4,80(sp)
ffffffffc0205c90:	e4d6                	sd	s5,72(sp)
ffffffffc0205c92:	e0da                	sd	s6,64(sp)
ffffffffc0205c94:	fc5e                	sd	s7,56(sp)
ffffffffc0205c96:	f862                	sd	s8,48(sp)
ffffffffc0205c98:	f466                	sd	s9,40(sp)
ffffffffc0205c9a:	f06a                	sd	s10,32(sp)
ffffffffc0205c9c:	ec6e                	sd	s11,24(sp)
ffffffffc0205c9e:	6785                	lui	a5,0x1
ffffffffc0205ca0:	32f75463          	bge	a4,a5,ffffffffc0205fc8 <do_fork+0x352>
ffffffffc0205ca4:	892a                	mv	s2,a0
ffffffffc0205ca6:	8a2e                	mv	s4,a1
ffffffffc0205ca8:	8432                	mv	s0,a2
ffffffffc0205caa:	e37ff0ef          	jal	ra,ffffffffc0205ae0 <alloc_proc>
ffffffffc0205cae:	84aa                	mv	s1,a0
ffffffffc0205cb0:	30050163          	beqz	a0,ffffffffc0205fb2 <do_fork+0x33c>
ffffffffc0205cb4:	4509                	li	a0,2
ffffffffc0205cb6:	d85fc0ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0205cba:	2e050963          	beqz	a0,ffffffffc0205fac <do_fork+0x336>
ffffffffc0205cbe:	00091b17          	auipc	s6,0x91
ffffffffc0205cc2:	beab0b13          	addi	s6,s6,-1046 # ffffffffc02968a8 <pages>
ffffffffc0205cc6:	000b3683          	ld	a3,0(s6)
ffffffffc0205cca:	00091b97          	auipc	s7,0x91
ffffffffc0205cce:	bd6b8b93          	addi	s7,s7,-1066 # ffffffffc02968a0 <npage>
ffffffffc0205cd2:	0000aa97          	auipc	s5,0xa
ffffffffc0205cd6:	c4eaba83          	ld	s5,-946(s5) # ffffffffc020f920 <nbase>
ffffffffc0205cda:	40d506b3          	sub	a3,a0,a3
ffffffffc0205cde:	8699                	srai	a3,a3,0x6
ffffffffc0205ce0:	5d7d                	li	s10,-1
ffffffffc0205ce2:	000bb783          	ld	a5,0(s7)
ffffffffc0205ce6:	96d6                	add	a3,a3,s5
ffffffffc0205ce8:	00cd5d13          	srli	s10,s10,0xc
ffffffffc0205cec:	01a6f733          	and	a4,a3,s10
ffffffffc0205cf0:	06b2                	slli	a3,a3,0xc
ffffffffc0205cf2:	34f77063          	bgeu	a4,a5,ffffffffc0206032 <do_fork+0x3bc>
ffffffffc0205cf6:	00091c17          	auipc	s8,0x91
ffffffffc0205cfa:	bcac0c13          	addi	s8,s8,-1078 # ffffffffc02968c0 <current>
ffffffffc0205cfe:	000c3803          	ld	a6,0(s8)
ffffffffc0205d02:	00091c97          	auipc	s9,0x91
ffffffffc0205d06:	bb6c8c93          	addi	s9,s9,-1098 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205d0a:	000cb703          	ld	a4,0(s9)
ffffffffc0205d0e:	02883d83          	ld	s11,40(a6)
ffffffffc0205d12:	96ba                	add	a3,a3,a4
ffffffffc0205d14:	e894                	sd	a3,16(s1)
ffffffffc0205d16:	020d8a63          	beqz	s11,ffffffffc0205d4a <do_fork+0xd4>
ffffffffc0205d1a:	10097713          	andi	a4,s2,256
ffffffffc0205d1e:	1c070863          	beqz	a4,ffffffffc0205eee <do_fork+0x278>
ffffffffc0205d22:	030da683          	lw	a3,48(s11)
ffffffffc0205d26:	018db703          	ld	a4,24(s11)
ffffffffc0205d2a:	c0200637          	lui	a2,0xc0200
ffffffffc0205d2e:	2685                	addiw	a3,a3,1
ffffffffc0205d30:	02dda823          	sw	a3,48(s11)
ffffffffc0205d34:	03b4b423          	sd	s11,40(s1)
ffffffffc0205d38:	2ec76063          	bltu	a4,a2,ffffffffc0206018 <do_fork+0x3a2>
ffffffffc0205d3c:	000cb783          	ld	a5,0(s9)
ffffffffc0205d40:	000c3803          	ld	a6,0(s8)
ffffffffc0205d44:	6894                	ld	a3,16(s1)
ffffffffc0205d46:	8f1d                	sub	a4,a4,a5
ffffffffc0205d48:	f4d8                	sd	a4,168(s1)
ffffffffc0205d4a:	6789                	lui	a5,0x2
ffffffffc0205d4c:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205d50:	96be                	add	a3,a3,a5
ffffffffc0205d52:	f0d4                	sd	a3,160(s1)
ffffffffc0205d54:	87b6                	mv	a5,a3
ffffffffc0205d56:	12040893          	addi	a7,s0,288
ffffffffc0205d5a:	6008                	ld	a0,0(s0)
ffffffffc0205d5c:	640c                	ld	a1,8(s0)
ffffffffc0205d5e:	6810                	ld	a2,16(s0)
ffffffffc0205d60:	6c18                	ld	a4,24(s0)
ffffffffc0205d62:	e388                	sd	a0,0(a5)
ffffffffc0205d64:	e78c                	sd	a1,8(a5)
ffffffffc0205d66:	eb90                	sd	a2,16(a5)
ffffffffc0205d68:	ef98                	sd	a4,24(a5)
ffffffffc0205d6a:	02040413          	addi	s0,s0,32
ffffffffc0205d6e:	02078793          	addi	a5,a5,32
ffffffffc0205d72:	ff1414e3          	bne	s0,a7,ffffffffc0205d5a <do_fork+0xe4>
ffffffffc0205d76:	0406b823          	sd	zero,80(a3)
ffffffffc0205d7a:	140a0c63          	beqz	s4,ffffffffc0205ed2 <do_fork+0x25c>
ffffffffc0205d7e:	14883403          	ld	s0,328(a6)
ffffffffc0205d82:	00000797          	auipc	a5,0x0
ffffffffc0205d86:	df878793          	addi	a5,a5,-520 # ffffffffc0205b7a <forkret>
ffffffffc0205d8a:	0146b823          	sd	s4,16(a3)
ffffffffc0205d8e:	f89c                	sd	a5,48(s1)
ffffffffc0205d90:	fc94                	sd	a3,56(s1)
ffffffffc0205d92:	2a040c63          	beqz	s0,ffffffffc020604a <do_fork+0x3d4>
ffffffffc0205d96:	00b95913          	srli	s2,s2,0xb
ffffffffc0205d9a:	00197913          	andi	s2,s2,1
ffffffffc0205d9e:	12090c63          	beqz	s2,ffffffffc0205ed6 <do_fork+0x260>
ffffffffc0205da2:	481c                	lw	a5,16(s0)
ffffffffc0205da4:	0ec82703          	lw	a4,236(a6)
ffffffffc0205da8:	2785                	addiw	a5,a5,1
ffffffffc0205daa:	c81c                	sw	a5,16(s0)
ffffffffc0205dac:	1484b423          	sd	s0,328(s1)
ffffffffc0205db0:	0304b023          	sd	a6,32(s1)
ffffffffc0205db4:	2a071b63          	bnez	a4,ffffffffc020606a <do_fork+0x3f4>
ffffffffc0205db8:	0008b817          	auipc	a6,0x8b
ffffffffc0205dbc:	2a080813          	addi	a6,a6,672 # ffffffffc0291058 <last_pid.1>
ffffffffc0205dc0:	00082783          	lw	a5,0(a6)
ffffffffc0205dc4:	6709                	lui	a4,0x2
ffffffffc0205dc6:	0017851b          	addiw	a0,a5,1
ffffffffc0205dca:	00a82023          	sw	a0,0(a6)
ffffffffc0205dce:	08e55b63          	bge	a0,a4,ffffffffc0205e64 <do_fork+0x1ee>
ffffffffc0205dd2:	0008b317          	auipc	t1,0x8b
ffffffffc0205dd6:	28a30313          	addi	t1,t1,650 # ffffffffc029105c <next_safe.0>
ffffffffc0205dda:	00032783          	lw	a5,0(t1)
ffffffffc0205dde:	00090417          	auipc	s0,0x90
ffffffffc0205de2:	9e240413          	addi	s0,s0,-1566 # ffffffffc02957c0 <proc_list>
ffffffffc0205de6:	08f55763          	bge	a0,a5,ffffffffc0205e74 <do_fork+0x1fe>
ffffffffc0205dea:	c0c8                	sw	a0,4(s1)
ffffffffc0205dec:	45a9                	li	a1,10
ffffffffc0205dee:	2501                	sext.w	a0,a0
ffffffffc0205df0:	115050ef          	jal	ra,ffffffffc020b704 <hash32>
ffffffffc0205df4:	02051793          	slli	a5,a0,0x20
ffffffffc0205df8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205dfc:	0008c797          	auipc	a5,0x8c
ffffffffc0205e00:	9c478793          	addi	a5,a5,-1596 # ffffffffc02917c0 <hash_list>
ffffffffc0205e04:	953e                	add	a0,a0,a5
ffffffffc0205e06:	650c                	ld	a1,8(a0)
ffffffffc0205e08:	7094                	ld	a3,32(s1)
ffffffffc0205e0a:	0d848793          	addi	a5,s1,216
ffffffffc0205e0e:	e19c                	sd	a5,0(a1)
ffffffffc0205e10:	6410                	ld	a2,8(s0)
ffffffffc0205e12:	e51c                	sd	a5,8(a0)
ffffffffc0205e14:	7af8                	ld	a4,240(a3)
ffffffffc0205e16:	0c848793          	addi	a5,s1,200
ffffffffc0205e1a:	f0ec                	sd	a1,224(s1)
ffffffffc0205e1c:	ece8                	sd	a0,216(s1)
ffffffffc0205e1e:	e21c                	sd	a5,0(a2)
ffffffffc0205e20:	e41c                	sd	a5,8(s0)
ffffffffc0205e22:	e8f0                	sd	a2,208(s1)
ffffffffc0205e24:	e4e0                	sd	s0,200(s1)
ffffffffc0205e26:	0e04bc23          	sd	zero,248(s1)
ffffffffc0205e2a:	10e4b023          	sd	a4,256(s1)
ffffffffc0205e2e:	c311                	beqz	a4,ffffffffc0205e32 <do_fork+0x1bc>
ffffffffc0205e30:	ff64                	sd	s1,248(a4)
ffffffffc0205e32:	0009a783          	lw	a5,0(s3)
ffffffffc0205e36:	8526                	mv	a0,s1
ffffffffc0205e38:	fae4                	sd	s1,240(a3)
ffffffffc0205e3a:	2785                	addiw	a5,a5,1
ffffffffc0205e3c:	00f9a023          	sw	a5,0(s3)
ffffffffc0205e40:	4c4010ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc0205e44:	40c8                	lw	a0,4(s1)
ffffffffc0205e46:	70e6                	ld	ra,120(sp)
ffffffffc0205e48:	7446                	ld	s0,112(sp)
ffffffffc0205e4a:	74a6                	ld	s1,104(sp)
ffffffffc0205e4c:	7906                	ld	s2,96(sp)
ffffffffc0205e4e:	69e6                	ld	s3,88(sp)
ffffffffc0205e50:	6a46                	ld	s4,80(sp)
ffffffffc0205e52:	6aa6                	ld	s5,72(sp)
ffffffffc0205e54:	6b06                	ld	s6,64(sp)
ffffffffc0205e56:	7be2                	ld	s7,56(sp)
ffffffffc0205e58:	7c42                	ld	s8,48(sp)
ffffffffc0205e5a:	7ca2                	ld	s9,40(sp)
ffffffffc0205e5c:	7d02                	ld	s10,32(sp)
ffffffffc0205e5e:	6de2                	ld	s11,24(sp)
ffffffffc0205e60:	6109                	addi	sp,sp,128
ffffffffc0205e62:	8082                	ret
ffffffffc0205e64:	4785                	li	a5,1
ffffffffc0205e66:	00f82023          	sw	a5,0(a6)
ffffffffc0205e6a:	4505                	li	a0,1
ffffffffc0205e6c:	0008b317          	auipc	t1,0x8b
ffffffffc0205e70:	1f030313          	addi	t1,t1,496 # ffffffffc029105c <next_safe.0>
ffffffffc0205e74:	00090417          	auipc	s0,0x90
ffffffffc0205e78:	94c40413          	addi	s0,s0,-1716 # ffffffffc02957c0 <proc_list>
ffffffffc0205e7c:	00843e03          	ld	t3,8(s0)
ffffffffc0205e80:	6789                	lui	a5,0x2
ffffffffc0205e82:	00f32023          	sw	a5,0(t1)
ffffffffc0205e86:	86aa                	mv	a3,a0
ffffffffc0205e88:	4581                	li	a1,0
ffffffffc0205e8a:	6e89                	lui	t4,0x2
ffffffffc0205e8c:	128e0963          	beq	t3,s0,ffffffffc0205fbe <do_fork+0x348>
ffffffffc0205e90:	88ae                	mv	a7,a1
ffffffffc0205e92:	87f2                	mv	a5,t3
ffffffffc0205e94:	6609                	lui	a2,0x2
ffffffffc0205e96:	a811                	j	ffffffffc0205eaa <do_fork+0x234>
ffffffffc0205e98:	00e6d663          	bge	a3,a4,ffffffffc0205ea4 <do_fork+0x22e>
ffffffffc0205e9c:	00c75463          	bge	a4,a2,ffffffffc0205ea4 <do_fork+0x22e>
ffffffffc0205ea0:	863a                	mv	a2,a4
ffffffffc0205ea2:	4885                	li	a7,1
ffffffffc0205ea4:	679c                	ld	a5,8(a5)
ffffffffc0205ea6:	00878d63          	beq	a5,s0,ffffffffc0205ec0 <do_fork+0x24a>
ffffffffc0205eaa:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205eae:	fed715e3          	bne	a4,a3,ffffffffc0205e98 <do_fork+0x222>
ffffffffc0205eb2:	2685                	addiw	a3,a3,1
ffffffffc0205eb4:	0ac6dd63          	bge	a3,a2,ffffffffc0205f6e <do_fork+0x2f8>
ffffffffc0205eb8:	679c                	ld	a5,8(a5)
ffffffffc0205eba:	4585                	li	a1,1
ffffffffc0205ebc:	fe8797e3          	bne	a5,s0,ffffffffc0205eaa <do_fork+0x234>
ffffffffc0205ec0:	c581                	beqz	a1,ffffffffc0205ec8 <do_fork+0x252>
ffffffffc0205ec2:	00d82023          	sw	a3,0(a6)
ffffffffc0205ec6:	8536                	mv	a0,a3
ffffffffc0205ec8:	f20881e3          	beqz	a7,ffffffffc0205dea <do_fork+0x174>
ffffffffc0205ecc:	00c32023          	sw	a2,0(t1)
ffffffffc0205ed0:	bf29                	j	ffffffffc0205dea <do_fork+0x174>
ffffffffc0205ed2:	8a36                	mv	s4,a3
ffffffffc0205ed4:	b56d                	j	ffffffffc0205d7e <do_fork+0x108>
ffffffffc0205ed6:	9a9ff0ef          	jal	ra,ffffffffc020587e <files_create>
ffffffffc0205eda:	892a                	mv	s2,a0
ffffffffc0205edc:	c14d                	beqz	a0,ffffffffc0205f7e <do_fork+0x308>
ffffffffc0205ede:	85a2                	mv	a1,s0
ffffffffc0205ee0:	ad7ff0ef          	jal	ra,ffffffffc02059b6 <dup_files>
ffffffffc0205ee4:	e969                	bnez	a0,ffffffffc0205fb6 <do_fork+0x340>
ffffffffc0205ee6:	000c3803          	ld	a6,0(s8)
ffffffffc0205eea:	844a                	mv	s0,s2
ffffffffc0205eec:	bd5d                	j	ffffffffc0205da2 <do_fork+0x12c>
ffffffffc0205eee:	c84fb0ef          	jal	ra,ffffffffc0201372 <mm_create>
ffffffffc0205ef2:	e02a                	sd	a0,0(sp)
ffffffffc0205ef4:	c549                	beqz	a0,ffffffffc0205f7e <do_fork+0x308>
ffffffffc0205ef6:	4505                	li	a0,1
ffffffffc0205ef8:	b43fc0ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc0205efc:	cd35                	beqz	a0,ffffffffc0205f78 <do_fork+0x302>
ffffffffc0205efe:	000b3683          	ld	a3,0(s6)
ffffffffc0205f02:	000bb703          	ld	a4,0(s7)
ffffffffc0205f06:	40d506b3          	sub	a3,a0,a3
ffffffffc0205f0a:	8699                	srai	a3,a3,0x6
ffffffffc0205f0c:	96d6                	add	a3,a3,s5
ffffffffc0205f0e:	01a6fd33          	and	s10,a3,s10
ffffffffc0205f12:	06b2                	slli	a3,a3,0xc
ffffffffc0205f14:	10ed7f63          	bgeu	s10,a4,ffffffffc0206032 <do_fork+0x3bc>
ffffffffc0205f18:	000cbd03          	ld	s10,0(s9)
ffffffffc0205f1c:	6605                	lui	a2,0x1
ffffffffc0205f1e:	00091597          	auipc	a1,0x91
ffffffffc0205f22:	97a5b583          	ld	a1,-1670(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0205f26:	9d36                	add	s10,s10,a3
ffffffffc0205f28:	856a                	mv	a0,s10
ffffffffc0205f2a:	346050ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0205f2e:	6782                	ld	a5,0(sp)
ffffffffc0205f30:	038d8713          	addi	a4,s11,56
ffffffffc0205f34:	853a                	mv	a0,a4
ffffffffc0205f36:	01a7bc23          	sd	s10,24(a5)
ffffffffc0205f3a:	e43a                	sd	a4,8(sp)
ffffffffc0205f3c:	8a7fe0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0205f40:	000c3683          	ld	a3,0(s8)
ffffffffc0205f44:	6722                	ld	a4,8(sp)
ffffffffc0205f46:	c681                	beqz	a3,ffffffffc0205f4e <do_fork+0x2d8>
ffffffffc0205f48:	42d4                	lw	a3,4(a3)
ffffffffc0205f4a:	04dda823          	sw	a3,80(s11)
ffffffffc0205f4e:	6502                	ld	a0,0(sp)
ffffffffc0205f50:	85ee                	mv	a1,s11
ffffffffc0205f52:	e43a                	sd	a4,8(sp)
ffffffffc0205f54:	e6efb0ef          	jal	ra,ffffffffc02015c2 <dup_mmap>
ffffffffc0205f58:	6722                	ld	a4,8(sp)
ffffffffc0205f5a:	8d2a                	mv	s10,a0
ffffffffc0205f5c:	853a                	mv	a0,a4
ffffffffc0205f5e:	881fe0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0205f62:	040da823          	sw	zero,80(s11)
ffffffffc0205f66:	060d1663          	bnez	s10,ffffffffc0205fd2 <do_fork+0x35c>
ffffffffc0205f6a:	6d82                	ld	s11,0(sp)
ffffffffc0205f6c:	bb5d                	j	ffffffffc0205d22 <do_fork+0xac>
ffffffffc0205f6e:	01d6c363          	blt	a3,t4,ffffffffc0205f74 <do_fork+0x2fe>
ffffffffc0205f72:	4685                	li	a3,1
ffffffffc0205f74:	4585                	li	a1,1
ffffffffc0205f76:	bf19                	j	ffffffffc0205e8c <do_fork+0x216>
ffffffffc0205f78:	6502                	ld	a0,0(sp)
ffffffffc0205f7a:	d46fb0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0205f7e:	6894                	ld	a3,16(s1)
ffffffffc0205f80:	c02007b7          	lui	a5,0xc0200
ffffffffc0205f84:	06f6e263          	bltu	a3,a5,ffffffffc0205fe8 <do_fork+0x372>
ffffffffc0205f88:	000cb783          	ld	a5,0(s9)
ffffffffc0205f8c:	000bb703          	ld	a4,0(s7)
ffffffffc0205f90:	40f687b3          	sub	a5,a3,a5
ffffffffc0205f94:	83b1                	srli	a5,a5,0xc
ffffffffc0205f96:	06e7f563          	bgeu	a5,a4,ffffffffc0206000 <do_fork+0x38a>
ffffffffc0205f9a:	000b3503          	ld	a0,0(s6)
ffffffffc0205f9e:	415787b3          	sub	a5,a5,s5
ffffffffc0205fa2:	079a                	slli	a5,a5,0x6
ffffffffc0205fa4:	4589                	li	a1,2
ffffffffc0205fa6:	953e                	add	a0,a0,a5
ffffffffc0205fa8:	ad1fc0ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc0205fac:	8526                	mv	a0,s1
ffffffffc0205fae:	eb1fb0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0205fb2:	5571                	li	a0,-4
ffffffffc0205fb4:	bd49                	j	ffffffffc0205e46 <do_fork+0x1d0>
ffffffffc0205fb6:	854a                	mv	a0,s2
ffffffffc0205fb8:	8fdff0ef          	jal	ra,ffffffffc02058b4 <files_destroy>
ffffffffc0205fbc:	b7c9                	j	ffffffffc0205f7e <do_fork+0x308>
ffffffffc0205fbe:	c599                	beqz	a1,ffffffffc0205fcc <do_fork+0x356>
ffffffffc0205fc0:	00d82023          	sw	a3,0(a6)
ffffffffc0205fc4:	8536                	mv	a0,a3
ffffffffc0205fc6:	b515                	j	ffffffffc0205dea <do_fork+0x174>
ffffffffc0205fc8:	556d                	li	a0,-5
ffffffffc0205fca:	bdb5                	j	ffffffffc0205e46 <do_fork+0x1d0>
ffffffffc0205fcc:	00082503          	lw	a0,0(a6)
ffffffffc0205fd0:	bd29                	j	ffffffffc0205dea <do_fork+0x174>
ffffffffc0205fd2:	6402                	ld	s0,0(sp)
ffffffffc0205fd4:	8522                	mv	a0,s0
ffffffffc0205fd6:	e86fb0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc0205fda:	6c08                	ld	a0,24(s0)
ffffffffc0205fdc:	badff0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc0205fe0:	8522                	mv	a0,s0
ffffffffc0205fe2:	cdefb0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0205fe6:	bf61                	j	ffffffffc0205f7e <do_fork+0x308>
ffffffffc0205fe8:	00006617          	auipc	a2,0x6
ffffffffc0205fec:	65060613          	addi	a2,a2,1616 # ffffffffc020c638 <commands+0xc70>
ffffffffc0205ff0:	07700593          	li	a1,119
ffffffffc0205ff4:	00006517          	auipc	a0,0x6
ffffffffc0205ff8:	5c450513          	addi	a0,a0,1476 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0205ffc:	a32fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206000:	00006617          	auipc	a2,0x6
ffffffffc0206004:	66060613          	addi	a2,a2,1632 # ffffffffc020c660 <commands+0xc98>
ffffffffc0206008:	06900593          	li	a1,105
ffffffffc020600c:	00006517          	auipc	a0,0x6
ffffffffc0206010:	5ac50513          	addi	a0,a0,1452 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0206014:	a1afa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206018:	86ba                	mv	a3,a4
ffffffffc020601a:	00006617          	auipc	a2,0x6
ffffffffc020601e:	61e60613          	addi	a2,a2,1566 # ffffffffc020c638 <commands+0xc70>
ffffffffc0206022:	1b700593          	li	a1,439
ffffffffc0206026:	00007517          	auipc	a0,0x7
ffffffffc020602a:	6aa50513          	addi	a0,a0,1706 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc020602e:	a00fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206032:	00006617          	auipc	a2,0x6
ffffffffc0206036:	55e60613          	addi	a2,a2,1374 # ffffffffc020c590 <commands+0xbc8>
ffffffffc020603a:	07100593          	li	a1,113
ffffffffc020603e:	00006517          	auipc	a0,0x6
ffffffffc0206042:	57a50513          	addi	a0,a0,1402 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0206046:	9e8fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020604a:	00007697          	auipc	a3,0x7
ffffffffc020604e:	69e68693          	addi	a3,a3,1694 # ffffffffc020d6e8 <CSWTCH.79+0xe0>
ffffffffc0206052:	00006617          	auipc	a2,0x6
ffffffffc0206056:	bc660613          	addi	a2,a2,-1082 # ffffffffc020bc18 <commands+0x250>
ffffffffc020605a:	1d700593          	li	a1,471
ffffffffc020605e:	00007517          	auipc	a0,0x7
ffffffffc0206062:	67250513          	addi	a0,a0,1650 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0206066:	9c8fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020606a:	00007697          	auipc	a3,0x7
ffffffffc020606e:	69668693          	addi	a3,a3,1686 # ffffffffc020d700 <CSWTCH.79+0xf8>
ffffffffc0206072:	00006617          	auipc	a2,0x6
ffffffffc0206076:	ba660613          	addi	a2,a2,-1114 # ffffffffc020bc18 <commands+0x250>
ffffffffc020607a:	24300593          	li	a1,579
ffffffffc020607e:	00007517          	auipc	a0,0x7
ffffffffc0206082:	65250513          	addi	a0,a0,1618 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0206086:	9a8fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020608a <kernel_thread>:
ffffffffc020608a:	7129                	addi	sp,sp,-320
ffffffffc020608c:	fa22                	sd	s0,304(sp)
ffffffffc020608e:	f626                	sd	s1,296(sp)
ffffffffc0206090:	f24a                	sd	s2,288(sp)
ffffffffc0206092:	84ae                	mv	s1,a1
ffffffffc0206094:	892a                	mv	s2,a0
ffffffffc0206096:	8432                	mv	s0,a2
ffffffffc0206098:	4581                	li	a1,0
ffffffffc020609a:	12000613          	li	a2,288
ffffffffc020609e:	850a                	mv	a0,sp
ffffffffc02060a0:	fe06                	sd	ra,312(sp)
ffffffffc02060a2:	17c050ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc02060a6:	e0ca                	sd	s2,64(sp)
ffffffffc02060a8:	e4a6                	sd	s1,72(sp)
ffffffffc02060aa:	100027f3          	csrr	a5,sstatus
ffffffffc02060ae:	edd7f793          	andi	a5,a5,-291
ffffffffc02060b2:	1207e793          	ori	a5,a5,288
ffffffffc02060b6:	e23e                	sd	a5,256(sp)
ffffffffc02060b8:	860a                	mv	a2,sp
ffffffffc02060ba:	10046513          	ori	a0,s0,256
ffffffffc02060be:	00000797          	auipc	a5,0x0
ffffffffc02060c2:	a1a78793          	addi	a5,a5,-1510 # ffffffffc0205ad8 <kernel_thread_entry>
ffffffffc02060c6:	4581                	li	a1,0
ffffffffc02060c8:	e63e                	sd	a5,264(sp)
ffffffffc02060ca:	badff0ef          	jal	ra,ffffffffc0205c76 <do_fork>
ffffffffc02060ce:	70f2                	ld	ra,312(sp)
ffffffffc02060d0:	7452                	ld	s0,304(sp)
ffffffffc02060d2:	74b2                	ld	s1,296(sp)
ffffffffc02060d4:	7912                	ld	s2,288(sp)
ffffffffc02060d6:	6131                	addi	sp,sp,320
ffffffffc02060d8:	8082                	ret

ffffffffc02060da <do_exit>:
ffffffffc02060da:	7179                	addi	sp,sp,-48
ffffffffc02060dc:	f022                	sd	s0,32(sp)
ffffffffc02060de:	00090417          	auipc	s0,0x90
ffffffffc02060e2:	7e240413          	addi	s0,s0,2018 # ffffffffc02968c0 <current>
ffffffffc02060e6:	601c                	ld	a5,0(s0)
ffffffffc02060e8:	f406                	sd	ra,40(sp)
ffffffffc02060ea:	ec26                	sd	s1,24(sp)
ffffffffc02060ec:	e84a                	sd	s2,16(sp)
ffffffffc02060ee:	e44e                	sd	s3,8(sp)
ffffffffc02060f0:	e052                	sd	s4,0(sp)
ffffffffc02060f2:	00090717          	auipc	a4,0x90
ffffffffc02060f6:	7d673703          	ld	a4,2006(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02060fa:	0ee78763          	beq	a5,a4,ffffffffc02061e8 <do_exit+0x10e>
ffffffffc02060fe:	00090497          	auipc	s1,0x90
ffffffffc0206102:	7d248493          	addi	s1,s1,2002 # ffffffffc02968d0 <initproc>
ffffffffc0206106:	6098                	ld	a4,0(s1)
ffffffffc0206108:	10e78763          	beq	a5,a4,ffffffffc0206216 <do_exit+0x13c>
ffffffffc020610c:	0287b983          	ld	s3,40(a5)
ffffffffc0206110:	892a                	mv	s2,a0
ffffffffc0206112:	02098e63          	beqz	s3,ffffffffc020614e <do_exit+0x74>
ffffffffc0206116:	00090797          	auipc	a5,0x90
ffffffffc020611a:	77a7b783          	ld	a5,1914(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc020611e:	577d                	li	a4,-1
ffffffffc0206120:	177e                	slli	a4,a4,0x3f
ffffffffc0206122:	83b1                	srli	a5,a5,0xc
ffffffffc0206124:	8fd9                	or	a5,a5,a4
ffffffffc0206126:	18079073          	csrw	satp,a5
ffffffffc020612a:	0309a783          	lw	a5,48(s3)
ffffffffc020612e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206132:	02e9a823          	sw	a4,48(s3)
ffffffffc0206136:	c769                	beqz	a4,ffffffffc0206200 <do_exit+0x126>
ffffffffc0206138:	601c                	ld	a5,0(s0)
ffffffffc020613a:	1487b503          	ld	a0,328(a5)
ffffffffc020613e:	0207b423          	sd	zero,40(a5)
ffffffffc0206142:	c511                	beqz	a0,ffffffffc020614e <do_exit+0x74>
ffffffffc0206144:	491c                	lw	a5,16(a0)
ffffffffc0206146:	fff7871b          	addiw	a4,a5,-1
ffffffffc020614a:	c918                	sw	a4,16(a0)
ffffffffc020614c:	cb59                	beqz	a4,ffffffffc02061e2 <do_exit+0x108>
ffffffffc020614e:	601c                	ld	a5,0(s0)
ffffffffc0206150:	470d                	li	a4,3
ffffffffc0206152:	c398                	sw	a4,0(a5)
ffffffffc0206154:	0f27a423          	sw	s2,232(a5)
ffffffffc0206158:	100027f3          	csrr	a5,sstatus
ffffffffc020615c:	8b89                	andi	a5,a5,2
ffffffffc020615e:	4a01                	li	s4,0
ffffffffc0206160:	e7f9                	bnez	a5,ffffffffc020622e <do_exit+0x154>
ffffffffc0206162:	6018                	ld	a4,0(s0)
ffffffffc0206164:	800007b7          	lui	a5,0x80000
ffffffffc0206168:	0785                	addi	a5,a5,1
ffffffffc020616a:	7308                	ld	a0,32(a4)
ffffffffc020616c:	0ec52703          	lw	a4,236(a0)
ffffffffc0206170:	0cf70363          	beq	a4,a5,ffffffffc0206236 <do_exit+0x15c>
ffffffffc0206174:	6018                	ld	a4,0(s0)
ffffffffc0206176:	7b7c                	ld	a5,240(a4)
ffffffffc0206178:	c3a1                	beqz	a5,ffffffffc02061b8 <do_exit+0xde>
ffffffffc020617a:	800009b7          	lui	s3,0x80000
ffffffffc020617e:	490d                	li	s2,3
ffffffffc0206180:	0985                	addi	s3,s3,1
ffffffffc0206182:	a021                	j	ffffffffc020618a <do_exit+0xb0>
ffffffffc0206184:	6018                	ld	a4,0(s0)
ffffffffc0206186:	7b7c                	ld	a5,240(a4)
ffffffffc0206188:	cb85                	beqz	a5,ffffffffc02061b8 <do_exit+0xde>
ffffffffc020618a:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc020618e:	6088                	ld	a0,0(s1)
ffffffffc0206190:	fb74                	sd	a3,240(a4)
ffffffffc0206192:	7978                	ld	a4,240(a0)
ffffffffc0206194:	0e07bc23          	sd	zero,248(a5)
ffffffffc0206198:	10e7b023          	sd	a4,256(a5)
ffffffffc020619c:	c311                	beqz	a4,ffffffffc02061a0 <do_exit+0xc6>
ffffffffc020619e:	ff7c                	sd	a5,248(a4)
ffffffffc02061a0:	4398                	lw	a4,0(a5)
ffffffffc02061a2:	f388                	sd	a0,32(a5)
ffffffffc02061a4:	f97c                	sd	a5,240(a0)
ffffffffc02061a6:	fd271fe3          	bne	a4,s2,ffffffffc0206184 <do_exit+0xaa>
ffffffffc02061aa:	0ec52783          	lw	a5,236(a0)
ffffffffc02061ae:	fd379be3          	bne	a5,s3,ffffffffc0206184 <do_exit+0xaa>
ffffffffc02061b2:	152010ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc02061b6:	b7f9                	j	ffffffffc0206184 <do_exit+0xaa>
ffffffffc02061b8:	020a1263          	bnez	s4,ffffffffc02061dc <do_exit+0x102>
ffffffffc02061bc:	1fa010ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc02061c0:	601c                	ld	a5,0(s0)
ffffffffc02061c2:	00007617          	auipc	a2,0x7
ffffffffc02061c6:	57e60613          	addi	a2,a2,1406 # ffffffffc020d740 <CSWTCH.79+0x138>
ffffffffc02061ca:	29800593          	li	a1,664
ffffffffc02061ce:	43d4                	lw	a3,4(a5)
ffffffffc02061d0:	00007517          	auipc	a0,0x7
ffffffffc02061d4:	50050513          	addi	a0,a0,1280 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02061d8:	856fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02061dc:	bbffa0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02061e0:	bff1                	j	ffffffffc02061bc <do_exit+0xe2>
ffffffffc02061e2:	ed2ff0ef          	jal	ra,ffffffffc02058b4 <files_destroy>
ffffffffc02061e6:	b7a5                	j	ffffffffc020614e <do_exit+0x74>
ffffffffc02061e8:	00007617          	auipc	a2,0x7
ffffffffc02061ec:	53860613          	addi	a2,a2,1336 # ffffffffc020d720 <CSWTCH.79+0x118>
ffffffffc02061f0:	26300593          	li	a1,611
ffffffffc02061f4:	00007517          	auipc	a0,0x7
ffffffffc02061f8:	4dc50513          	addi	a0,a0,1244 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02061fc:	832fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206200:	854e                	mv	a0,s3
ffffffffc0206202:	c5afb0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc0206206:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc020620a:	97fff0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc020620e:	854e                	mv	a0,s3
ffffffffc0206210:	ab0fb0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206214:	b715                	j	ffffffffc0206138 <do_exit+0x5e>
ffffffffc0206216:	00007617          	auipc	a2,0x7
ffffffffc020621a:	51a60613          	addi	a2,a2,1306 # ffffffffc020d730 <CSWTCH.79+0x128>
ffffffffc020621e:	26700593          	li	a1,615
ffffffffc0206222:	00007517          	auipc	a0,0x7
ffffffffc0206226:	4ae50513          	addi	a0,a0,1198 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc020622a:	804fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020622e:	b73fa0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0206232:	4a05                	li	s4,1
ffffffffc0206234:	b73d                	j	ffffffffc0206162 <do_exit+0x88>
ffffffffc0206236:	0ce010ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc020623a:	bf2d                	j	ffffffffc0206174 <do_exit+0x9a>

ffffffffc020623c <do_wait.part.0>:
ffffffffc020623c:	715d                	addi	sp,sp,-80
ffffffffc020623e:	f84a                	sd	s2,48(sp)
ffffffffc0206240:	f44e                	sd	s3,40(sp)
ffffffffc0206242:	80000937          	lui	s2,0x80000
ffffffffc0206246:	6989                	lui	s3,0x2
ffffffffc0206248:	fc26                	sd	s1,56(sp)
ffffffffc020624a:	f052                	sd	s4,32(sp)
ffffffffc020624c:	ec56                	sd	s5,24(sp)
ffffffffc020624e:	e85a                	sd	s6,16(sp)
ffffffffc0206250:	e45e                	sd	s7,8(sp)
ffffffffc0206252:	e486                	sd	ra,72(sp)
ffffffffc0206254:	e0a2                	sd	s0,64(sp)
ffffffffc0206256:	84aa                	mv	s1,a0
ffffffffc0206258:	8a2e                	mv	s4,a1
ffffffffc020625a:	00090b97          	auipc	s7,0x90
ffffffffc020625e:	666b8b93          	addi	s7,s7,1638 # ffffffffc02968c0 <current>
ffffffffc0206262:	00050b1b          	sext.w	s6,a0
ffffffffc0206266:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020626a:	19f9                	addi	s3,s3,-2
ffffffffc020626c:	0905                	addi	s2,s2,1
ffffffffc020626e:	ccbd                	beqz	s1,ffffffffc02062ec <do_wait.part.0+0xb0>
ffffffffc0206270:	0359e863          	bltu	s3,s5,ffffffffc02062a0 <do_wait.part.0+0x64>
ffffffffc0206274:	45a9                	li	a1,10
ffffffffc0206276:	855a                	mv	a0,s6
ffffffffc0206278:	48c050ef          	jal	ra,ffffffffc020b704 <hash32>
ffffffffc020627c:	02051793          	slli	a5,a0,0x20
ffffffffc0206280:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206284:	0008b797          	auipc	a5,0x8b
ffffffffc0206288:	53c78793          	addi	a5,a5,1340 # ffffffffc02917c0 <hash_list>
ffffffffc020628c:	953e                	add	a0,a0,a5
ffffffffc020628e:	842a                	mv	s0,a0
ffffffffc0206290:	a029                	j	ffffffffc020629a <do_wait.part.0+0x5e>
ffffffffc0206292:	f2c42783          	lw	a5,-212(s0)
ffffffffc0206296:	02978163          	beq	a5,s1,ffffffffc02062b8 <do_wait.part.0+0x7c>
ffffffffc020629a:	6400                	ld	s0,8(s0)
ffffffffc020629c:	fe851be3          	bne	a0,s0,ffffffffc0206292 <do_wait.part.0+0x56>
ffffffffc02062a0:	5579                	li	a0,-2
ffffffffc02062a2:	60a6                	ld	ra,72(sp)
ffffffffc02062a4:	6406                	ld	s0,64(sp)
ffffffffc02062a6:	74e2                	ld	s1,56(sp)
ffffffffc02062a8:	7942                	ld	s2,48(sp)
ffffffffc02062aa:	79a2                	ld	s3,40(sp)
ffffffffc02062ac:	7a02                	ld	s4,32(sp)
ffffffffc02062ae:	6ae2                	ld	s5,24(sp)
ffffffffc02062b0:	6b42                	ld	s6,16(sp)
ffffffffc02062b2:	6ba2                	ld	s7,8(sp)
ffffffffc02062b4:	6161                	addi	sp,sp,80
ffffffffc02062b6:	8082                	ret
ffffffffc02062b8:	000bb683          	ld	a3,0(s7)
ffffffffc02062bc:	f4843783          	ld	a5,-184(s0)
ffffffffc02062c0:	fed790e3          	bne	a5,a3,ffffffffc02062a0 <do_wait.part.0+0x64>
ffffffffc02062c4:	f2842703          	lw	a4,-216(s0)
ffffffffc02062c8:	478d                	li	a5,3
ffffffffc02062ca:	0ef70b63          	beq	a4,a5,ffffffffc02063c0 <do_wait.part.0+0x184>
ffffffffc02062ce:	4785                	li	a5,1
ffffffffc02062d0:	c29c                	sw	a5,0(a3)
ffffffffc02062d2:	0f26a623          	sw	s2,236(a3)
ffffffffc02062d6:	0e0010ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc02062da:	000bb783          	ld	a5,0(s7)
ffffffffc02062de:	0b07a783          	lw	a5,176(a5)
ffffffffc02062e2:	8b85                	andi	a5,a5,1
ffffffffc02062e4:	d7c9                	beqz	a5,ffffffffc020626e <do_wait.part.0+0x32>
ffffffffc02062e6:	555d                	li	a0,-9
ffffffffc02062e8:	df3ff0ef          	jal	ra,ffffffffc02060da <do_exit>
ffffffffc02062ec:	000bb683          	ld	a3,0(s7)
ffffffffc02062f0:	7ae0                	ld	s0,240(a3)
ffffffffc02062f2:	d45d                	beqz	s0,ffffffffc02062a0 <do_wait.part.0+0x64>
ffffffffc02062f4:	470d                	li	a4,3
ffffffffc02062f6:	a021                	j	ffffffffc02062fe <do_wait.part.0+0xc2>
ffffffffc02062f8:	10043403          	ld	s0,256(s0)
ffffffffc02062fc:	d869                	beqz	s0,ffffffffc02062ce <do_wait.part.0+0x92>
ffffffffc02062fe:	401c                	lw	a5,0(s0)
ffffffffc0206300:	fee79ce3          	bne	a5,a4,ffffffffc02062f8 <do_wait.part.0+0xbc>
ffffffffc0206304:	00090797          	auipc	a5,0x90
ffffffffc0206308:	5c47b783          	ld	a5,1476(a5) # ffffffffc02968c8 <idleproc>
ffffffffc020630c:	0c878963          	beq	a5,s0,ffffffffc02063de <do_wait.part.0+0x1a2>
ffffffffc0206310:	00090797          	auipc	a5,0x90
ffffffffc0206314:	5c07b783          	ld	a5,1472(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206318:	0cf40363          	beq	s0,a5,ffffffffc02063de <do_wait.part.0+0x1a2>
ffffffffc020631c:	000a0663          	beqz	s4,ffffffffc0206328 <do_wait.part.0+0xec>
ffffffffc0206320:	0e842783          	lw	a5,232(s0)
ffffffffc0206324:	00fa2023          	sw	a5,0(s4)
ffffffffc0206328:	100027f3          	csrr	a5,sstatus
ffffffffc020632c:	8b89                	andi	a5,a5,2
ffffffffc020632e:	4581                	li	a1,0
ffffffffc0206330:	e7c1                	bnez	a5,ffffffffc02063b8 <do_wait.part.0+0x17c>
ffffffffc0206332:	6c70                	ld	a2,216(s0)
ffffffffc0206334:	7074                	ld	a3,224(s0)
ffffffffc0206336:	10043703          	ld	a4,256(s0)
ffffffffc020633a:	7c7c                	ld	a5,248(s0)
ffffffffc020633c:	e614                	sd	a3,8(a2)
ffffffffc020633e:	e290                	sd	a2,0(a3)
ffffffffc0206340:	6470                	ld	a2,200(s0)
ffffffffc0206342:	6874                	ld	a3,208(s0)
ffffffffc0206344:	e614                	sd	a3,8(a2)
ffffffffc0206346:	e290                	sd	a2,0(a3)
ffffffffc0206348:	c319                	beqz	a4,ffffffffc020634e <do_wait.part.0+0x112>
ffffffffc020634a:	ff7c                	sd	a5,248(a4)
ffffffffc020634c:	7c7c                	ld	a5,248(s0)
ffffffffc020634e:	c3b5                	beqz	a5,ffffffffc02063b2 <do_wait.part.0+0x176>
ffffffffc0206350:	10e7b023          	sd	a4,256(a5)
ffffffffc0206354:	00090717          	auipc	a4,0x90
ffffffffc0206358:	58470713          	addi	a4,a4,1412 # ffffffffc02968d8 <nr_process>
ffffffffc020635c:	431c                	lw	a5,0(a4)
ffffffffc020635e:	37fd                	addiw	a5,a5,-1
ffffffffc0206360:	c31c                	sw	a5,0(a4)
ffffffffc0206362:	e5a9                	bnez	a1,ffffffffc02063ac <do_wait.part.0+0x170>
ffffffffc0206364:	6814                	ld	a3,16(s0)
ffffffffc0206366:	c02007b7          	lui	a5,0xc0200
ffffffffc020636a:	04f6ee63          	bltu	a3,a5,ffffffffc02063c6 <do_wait.part.0+0x18a>
ffffffffc020636e:	00090797          	auipc	a5,0x90
ffffffffc0206372:	54a7b783          	ld	a5,1354(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206376:	8e9d                	sub	a3,a3,a5
ffffffffc0206378:	82b1                	srli	a3,a3,0xc
ffffffffc020637a:	00090797          	auipc	a5,0x90
ffffffffc020637e:	5267b783          	ld	a5,1318(a5) # ffffffffc02968a0 <npage>
ffffffffc0206382:	06f6fa63          	bgeu	a3,a5,ffffffffc02063f6 <do_wait.part.0+0x1ba>
ffffffffc0206386:	00009517          	auipc	a0,0x9
ffffffffc020638a:	59a53503          	ld	a0,1434(a0) # ffffffffc020f920 <nbase>
ffffffffc020638e:	8e89                	sub	a3,a3,a0
ffffffffc0206390:	069a                	slli	a3,a3,0x6
ffffffffc0206392:	00090517          	auipc	a0,0x90
ffffffffc0206396:	51653503          	ld	a0,1302(a0) # ffffffffc02968a8 <pages>
ffffffffc020639a:	9536                	add	a0,a0,a3
ffffffffc020639c:	4589                	li	a1,2
ffffffffc020639e:	edafc0ef          	jal	ra,ffffffffc0202a78 <free_pages>
ffffffffc02063a2:	8522                	mv	a0,s0
ffffffffc02063a4:	abbfb0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02063a8:	4501                	li	a0,0
ffffffffc02063aa:	bde5                	j	ffffffffc02062a2 <do_wait.part.0+0x66>
ffffffffc02063ac:	9effa0ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02063b0:	bf55                	j	ffffffffc0206364 <do_wait.part.0+0x128>
ffffffffc02063b2:	701c                	ld	a5,32(s0)
ffffffffc02063b4:	fbf8                	sd	a4,240(a5)
ffffffffc02063b6:	bf79                	j	ffffffffc0206354 <do_wait.part.0+0x118>
ffffffffc02063b8:	9e9fa0ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02063bc:	4585                	li	a1,1
ffffffffc02063be:	bf95                	j	ffffffffc0206332 <do_wait.part.0+0xf6>
ffffffffc02063c0:	f2840413          	addi	s0,s0,-216
ffffffffc02063c4:	b781                	j	ffffffffc0206304 <do_wait.part.0+0xc8>
ffffffffc02063c6:	00006617          	auipc	a2,0x6
ffffffffc02063ca:	27260613          	addi	a2,a2,626 # ffffffffc020c638 <commands+0xc70>
ffffffffc02063ce:	07700593          	li	a1,119
ffffffffc02063d2:	00006517          	auipc	a0,0x6
ffffffffc02063d6:	1e650513          	addi	a0,a0,486 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc02063da:	e55f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02063de:	00007617          	auipc	a2,0x7
ffffffffc02063e2:	38260613          	addi	a2,a2,898 # ffffffffc020d760 <CSWTCH.79+0x158>
ffffffffc02063e6:	47e00593          	li	a1,1150
ffffffffc02063ea:	00007517          	auipc	a0,0x7
ffffffffc02063ee:	2e650513          	addi	a0,a0,742 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02063f2:	e3df90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02063f6:	00006617          	auipc	a2,0x6
ffffffffc02063fa:	26a60613          	addi	a2,a2,618 # ffffffffc020c660 <commands+0xc98>
ffffffffc02063fe:	06900593          	li	a1,105
ffffffffc0206402:	00006517          	auipc	a0,0x6
ffffffffc0206406:	1b650513          	addi	a0,a0,438 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc020640a:	e25f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020640e <init_main>:
ffffffffc020640e:	1141                	addi	sp,sp,-16
ffffffffc0206410:	00007517          	auipc	a0,0x7
ffffffffc0206414:	37050513          	addi	a0,a0,880 # ffffffffc020d780 <CSWTCH.79+0x178>
ffffffffc0206418:	e406                	sd	ra,8(sp)
ffffffffc020641a:	16e020ef          	jal	ra,ffffffffc0208588 <vfs_set_bootfs>
ffffffffc020641e:	e179                	bnez	a0,ffffffffc02064e4 <init_main+0xd6>
ffffffffc0206420:	e98fc0ef          	jal	ra,ffffffffc0202ab8 <nr_free_pages>
ffffffffc0206424:	987fb0ef          	jal	ra,ffffffffc0201daa <kallocated>
ffffffffc0206428:	4601                	li	a2,0
ffffffffc020642a:	4581                	li	a1,0
ffffffffc020642c:	00001517          	auipc	a0,0x1
ffffffffc0206430:	a8450513          	addi	a0,a0,-1404 # ffffffffc0206eb0 <user_main>
ffffffffc0206434:	c57ff0ef          	jal	ra,ffffffffc020608a <kernel_thread>
ffffffffc0206438:	00a04563          	bgtz	a0,ffffffffc0206442 <init_main+0x34>
ffffffffc020643c:	a841                	j	ffffffffc02064cc <init_main+0xbe>
ffffffffc020643e:	779000ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc0206442:	4581                	li	a1,0
ffffffffc0206444:	4501                	li	a0,0
ffffffffc0206446:	df7ff0ef          	jal	ra,ffffffffc020623c <do_wait.part.0>
ffffffffc020644a:	d975                	beqz	a0,ffffffffc020643e <init_main+0x30>
ffffffffc020644c:	c22ff0ef          	jal	ra,ffffffffc020586e <fs_cleanup>
ffffffffc0206450:	00007517          	auipc	a0,0x7
ffffffffc0206454:	37850513          	addi	a0,a0,888 # ffffffffc020d7c8 <CSWTCH.79+0x1c0>
ffffffffc0206458:	cd3f90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020645c:	00090797          	auipc	a5,0x90
ffffffffc0206460:	4747b783          	ld	a5,1140(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206464:	7bf8                	ld	a4,240(a5)
ffffffffc0206466:	e339                	bnez	a4,ffffffffc02064ac <init_main+0x9e>
ffffffffc0206468:	7ff8                	ld	a4,248(a5)
ffffffffc020646a:	e329                	bnez	a4,ffffffffc02064ac <init_main+0x9e>
ffffffffc020646c:	1007b703          	ld	a4,256(a5)
ffffffffc0206470:	ef15                	bnez	a4,ffffffffc02064ac <init_main+0x9e>
ffffffffc0206472:	00090697          	auipc	a3,0x90
ffffffffc0206476:	4666a683          	lw	a3,1126(a3) # ffffffffc02968d8 <nr_process>
ffffffffc020647a:	4709                	li	a4,2
ffffffffc020647c:	0ce69163          	bne	a3,a4,ffffffffc020653e <init_main+0x130>
ffffffffc0206480:	0008f717          	auipc	a4,0x8f
ffffffffc0206484:	34070713          	addi	a4,a4,832 # ffffffffc02957c0 <proc_list>
ffffffffc0206488:	6714                	ld	a3,8(a4)
ffffffffc020648a:	0c878793          	addi	a5,a5,200
ffffffffc020648e:	08d79863          	bne	a5,a3,ffffffffc020651e <init_main+0x110>
ffffffffc0206492:	6318                	ld	a4,0(a4)
ffffffffc0206494:	06e79563          	bne	a5,a4,ffffffffc02064fe <init_main+0xf0>
ffffffffc0206498:	00007517          	auipc	a0,0x7
ffffffffc020649c:	41850513          	addi	a0,a0,1048 # ffffffffc020d8b0 <CSWTCH.79+0x2a8>
ffffffffc02064a0:	c8bf90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02064a4:	60a2                	ld	ra,8(sp)
ffffffffc02064a6:	4501                	li	a0,0
ffffffffc02064a8:	0141                	addi	sp,sp,16
ffffffffc02064aa:	8082                	ret
ffffffffc02064ac:	00007697          	auipc	a3,0x7
ffffffffc02064b0:	34468693          	addi	a3,a3,836 # ffffffffc020d7f0 <CSWTCH.79+0x1e8>
ffffffffc02064b4:	00005617          	auipc	a2,0x5
ffffffffc02064b8:	76460613          	addi	a2,a2,1892 # ffffffffc020bc18 <commands+0x250>
ffffffffc02064bc:	4f400593          	li	a1,1268
ffffffffc02064c0:	00007517          	auipc	a0,0x7
ffffffffc02064c4:	21050513          	addi	a0,a0,528 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02064c8:	d67f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064cc:	00007617          	auipc	a2,0x7
ffffffffc02064d0:	2dc60613          	addi	a2,a2,732 # ffffffffc020d7a8 <CSWTCH.79+0x1a0>
ffffffffc02064d4:	4e700593          	li	a1,1255
ffffffffc02064d8:	00007517          	auipc	a0,0x7
ffffffffc02064dc:	1f850513          	addi	a0,a0,504 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02064e0:	d4ff90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064e4:	86aa                	mv	a3,a0
ffffffffc02064e6:	00007617          	auipc	a2,0x7
ffffffffc02064ea:	2a260613          	addi	a2,a2,674 # ffffffffc020d788 <CSWTCH.79+0x180>
ffffffffc02064ee:	4df00593          	li	a1,1247
ffffffffc02064f2:	00007517          	auipc	a0,0x7
ffffffffc02064f6:	1de50513          	addi	a0,a0,478 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02064fa:	d35f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064fe:	00007697          	auipc	a3,0x7
ffffffffc0206502:	38268693          	addi	a3,a3,898 # ffffffffc020d880 <CSWTCH.79+0x278>
ffffffffc0206506:	00005617          	auipc	a2,0x5
ffffffffc020650a:	71260613          	addi	a2,a2,1810 # ffffffffc020bc18 <commands+0x250>
ffffffffc020650e:	4f700593          	li	a1,1271
ffffffffc0206512:	00007517          	auipc	a0,0x7
ffffffffc0206516:	1be50513          	addi	a0,a0,446 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc020651a:	d15f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020651e:	00007697          	auipc	a3,0x7
ffffffffc0206522:	33268693          	addi	a3,a3,818 # ffffffffc020d850 <CSWTCH.79+0x248>
ffffffffc0206526:	00005617          	auipc	a2,0x5
ffffffffc020652a:	6f260613          	addi	a2,a2,1778 # ffffffffc020bc18 <commands+0x250>
ffffffffc020652e:	4f600593          	li	a1,1270
ffffffffc0206532:	00007517          	auipc	a0,0x7
ffffffffc0206536:	19e50513          	addi	a0,a0,414 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc020653a:	cf5f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020653e:	00007697          	auipc	a3,0x7
ffffffffc0206542:	30268693          	addi	a3,a3,770 # ffffffffc020d840 <CSWTCH.79+0x238>
ffffffffc0206546:	00005617          	auipc	a2,0x5
ffffffffc020654a:	6d260613          	addi	a2,a2,1746 # ffffffffc020bc18 <commands+0x250>
ffffffffc020654e:	4f500593          	li	a1,1269
ffffffffc0206552:	00007517          	auipc	a0,0x7
ffffffffc0206556:	17e50513          	addi	a0,a0,382 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc020655a:	cd5f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020655e <do_execve>:
ffffffffc020655e:	c9010113          	addi	sp,sp,-880
ffffffffc0206562:	33713423          	sd	s7,808(sp)
ffffffffc0206566:	00090b97          	auipc	s7,0x90
ffffffffc020656a:	35ab8b93          	addi	s7,s7,858 # ffffffffc02968c0 <current>
ffffffffc020656e:	000bb683          	ld	a3,0(s7)
ffffffffc0206572:	fff5871b          	addiw	a4,a1,-1
ffffffffc0206576:	35413023          	sd	s4,832(sp)
ffffffffc020657a:	36113423          	sd	ra,872(sp)
ffffffffc020657e:	36813023          	sd	s0,864(sp)
ffffffffc0206582:	34913c23          	sd	s1,856(sp)
ffffffffc0206586:	35213823          	sd	s2,848(sp)
ffffffffc020658a:	35313423          	sd	s3,840(sp)
ffffffffc020658e:	33513c23          	sd	s5,824(sp)
ffffffffc0206592:	33613823          	sd	s6,816(sp)
ffffffffc0206596:	33813023          	sd	s8,800(sp)
ffffffffc020659a:	31913c23          	sd	s9,792(sp)
ffffffffc020659e:	31a13823          	sd	s10,784(sp)
ffffffffc02065a2:	31b13423          	sd	s11,776(sp)
ffffffffc02065a6:	c83a                	sw	a4,16(sp)
ffffffffc02065a8:	47fd                	li	a5,31
ffffffffc02065aa:	0286ba03          	ld	s4,40(a3)
ffffffffc02065ae:	70e7e663          	bltu	a5,a4,ffffffffc0206cba <do_execve+0x75c>
ffffffffc02065b2:	842e                	mv	s0,a1
ffffffffc02065b4:	84aa                	mv	s1,a0
ffffffffc02065b6:	8b32                	mv	s6,a2
ffffffffc02065b8:	4581                	li	a1,0
ffffffffc02065ba:	4641                	li	a2,16
ffffffffc02065bc:	18a8                	addi	a0,sp,120
ffffffffc02065be:	461040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc02065c2:	000a0c63          	beqz	s4,ffffffffc02065da <do_execve+0x7c>
ffffffffc02065c6:	038a0513          	addi	a0,s4,56
ffffffffc02065ca:	a18fe0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc02065ce:	000bb783          	ld	a5,0(s7)
ffffffffc02065d2:	c781                	beqz	a5,ffffffffc02065da <do_execve+0x7c>
ffffffffc02065d4:	43dc                	lw	a5,4(a5)
ffffffffc02065d6:	04fa2823          	sw	a5,80(s4)
ffffffffc02065da:	22048f63          	beqz	s1,ffffffffc0206818 <do_execve+0x2ba>
ffffffffc02065de:	46c1                	li	a3,16
ffffffffc02065e0:	8626                	mv	a2,s1
ffffffffc02065e2:	18ac                	addi	a1,sp,120
ffffffffc02065e4:	8552                	mv	a0,s4
ffffffffc02065e6:	d10fb0ef          	jal	ra,ffffffffc0201af6 <copy_string>
ffffffffc02065ea:	76050563          	beqz	a0,ffffffffc0206d54 <do_execve+0x7f6>
ffffffffc02065ee:	00341d93          	slli	s11,s0,0x3
ffffffffc02065f2:	4681                	li	a3,0
ffffffffc02065f4:	866e                	mv	a2,s11
ffffffffc02065f6:	85da                	mv	a1,s6
ffffffffc02065f8:	8552                	mv	a0,s4
ffffffffc02065fa:	c02fb0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc02065fe:	89da                	mv	s3,s6
ffffffffc0206600:	74050663          	beqz	a0,ffffffffc0206d4c <do_execve+0x7ee>
ffffffffc0206604:	10010a93          	addi	s5,sp,256
ffffffffc0206608:	4481                	li	s1,0
ffffffffc020660a:	a011                	j	ffffffffc020660e <do_execve+0xb0>
ffffffffc020660c:	84be                	mv	s1,a5
ffffffffc020660e:	6505                	lui	a0,0x1
ffffffffc0206610:	f9efb0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0206614:	892a                	mv	s2,a0
ffffffffc0206616:	16050e63          	beqz	a0,ffffffffc0206792 <do_execve+0x234>
ffffffffc020661a:	0009b603          	ld	a2,0(s3) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020661e:	85aa                	mv	a1,a0
ffffffffc0206620:	6685                	lui	a3,0x1
ffffffffc0206622:	8552                	mv	a0,s4
ffffffffc0206624:	cd2fb0ef          	jal	ra,ffffffffc0201af6 <copy_string>
ffffffffc0206628:	1e050363          	beqz	a0,ffffffffc020680e <do_execve+0x2b0>
ffffffffc020662c:	012ab023          	sd	s2,0(s5)
ffffffffc0206630:	0014879b          	addiw	a5,s1,1
ffffffffc0206634:	0aa1                	addi	s5,s5,8
ffffffffc0206636:	09a1                	addi	s3,s3,8
ffffffffc0206638:	fcf41ae3          	bne	s0,a5,ffffffffc020660c <do_execve+0xae>
ffffffffc020663c:	000b3903          	ld	s2,0(s6)
ffffffffc0206640:	100a0763          	beqz	s4,ffffffffc020674e <do_execve+0x1f0>
ffffffffc0206644:	038a0513          	addi	a0,s4,56
ffffffffc0206648:	996fe0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020664c:	000bb783          	ld	a5,0(s7)
ffffffffc0206650:	040a2823          	sw	zero,80(s4)
ffffffffc0206654:	1487b503          	ld	a0,328(a5)
ffffffffc0206658:	af2ff0ef          	jal	ra,ffffffffc020594a <files_closeall>
ffffffffc020665c:	4581                	li	a1,0
ffffffffc020665e:	854a                	mv	a0,s2
ffffffffc0206660:	a62fe0ef          	jal	ra,ffffffffc02048c2 <sysfile_open>
ffffffffc0206664:	8aaa                	mv	s5,a0
ffffffffc0206666:	0a054f63          	bltz	a0,ffffffffc0206724 <do_execve+0x1c6>
ffffffffc020666a:	00090797          	auipc	a5,0x90
ffffffffc020666e:	2267b783          	ld	a5,550(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0206672:	577d                	li	a4,-1
ffffffffc0206674:	177e                	slli	a4,a4,0x3f
ffffffffc0206676:	83b1                	srli	a5,a5,0xc
ffffffffc0206678:	8fd9                	or	a5,a5,a4
ffffffffc020667a:	18079073          	csrw	satp,a5
ffffffffc020667e:	030a2783          	lw	a5,48(s4)
ffffffffc0206682:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206686:	02ea2823          	sw	a4,48(s4)
ffffffffc020668a:	1a070363          	beqz	a4,ffffffffc0206830 <do_execve+0x2d2>
ffffffffc020668e:	000bb783          	ld	a5,0(s7)
ffffffffc0206692:	0207b423          	sd	zero,40(a5)
ffffffffc0206696:	cddfa0ef          	jal	ra,ffffffffc0201372 <mm_create>
ffffffffc020669a:	8a2a                	mv	s4,a0
ffffffffc020669c:	0e050963          	beqz	a0,ffffffffc020678e <do_execve+0x230>
ffffffffc02066a0:	4505                	li	a0,1
ffffffffc02066a2:	b98fc0ef          	jal	ra,ffffffffc0202a3a <alloc_pages>
ffffffffc02066a6:	0e050163          	beqz	a0,ffffffffc0206788 <do_execve+0x22a>
ffffffffc02066aa:	00090d17          	auipc	s10,0x90
ffffffffc02066ae:	1fed0d13          	addi	s10,s10,510 # ffffffffc02968a8 <pages>
ffffffffc02066b2:	000d3683          	ld	a3,0(s10)
ffffffffc02066b6:	00009717          	auipc	a4,0x9
ffffffffc02066ba:	26a73703          	ld	a4,618(a4) # ffffffffc020f920 <nbase>
ffffffffc02066be:	00090997          	auipc	s3,0x90
ffffffffc02066c2:	1e298993          	addi	s3,s3,482 # ffffffffc02968a0 <npage>
ffffffffc02066c6:	40d506b3          	sub	a3,a0,a3
ffffffffc02066ca:	8699                	srai	a3,a3,0x6
ffffffffc02066cc:	96ba                	add	a3,a3,a4
ffffffffc02066ce:	ec3a                	sd	a4,24(sp)
ffffffffc02066d0:	0009b783          	ld	a5,0(s3)
ffffffffc02066d4:	577d                	li	a4,-1
ffffffffc02066d6:	8331                	srli	a4,a4,0xc
ffffffffc02066d8:	e43a                	sd	a4,8(sp)
ffffffffc02066da:	8f75                	and	a4,a4,a3
ffffffffc02066dc:	06b2                	slli	a3,a3,0xc
ffffffffc02066de:	78f77363          	bgeu	a4,a5,ffffffffc0206e64 <do_execve+0x906>
ffffffffc02066e2:	00090797          	auipc	a5,0x90
ffffffffc02066e6:	1d678793          	addi	a5,a5,470 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02066ea:	0007b903          	ld	s2,0(a5)
ffffffffc02066ee:	6605                	lui	a2,0x1
ffffffffc02066f0:	00090597          	auipc	a1,0x90
ffffffffc02066f4:	1a85b583          	ld	a1,424(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc02066f8:	9936                	add	s2,s2,a3
ffffffffc02066fa:	854a                	mv	a0,s2
ffffffffc02066fc:	375040ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0206700:	4601                	li	a2,0
ffffffffc0206702:	012a3c23          	sd	s2,24(s4)
ffffffffc0206706:	4581                	li	a1,0
ffffffffc0206708:	8556                	mv	a0,s5
ffffffffc020670a:	c1efe0ef          	jal	ra,ffffffffc0204b28 <sysfile_seek>
ffffffffc020670e:	8c2a                	mv	s8,a0
ffffffffc0206710:	12050b63          	beqz	a0,ffffffffc0206846 <do_execve+0x2e8>
ffffffffc0206714:	018a3503          	ld	a0,24(s4)
ffffffffc0206718:	8ae2                	mv	s5,s8
ffffffffc020671a:	c6eff0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc020671e:	8552                	mv	a0,s4
ffffffffc0206720:	da1fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206724:	67c2                	ld	a5,16(sp)
ffffffffc0206726:	147d                	addi	s0,s0,-1
ffffffffc0206728:	1984                	addi	s1,sp,240
ffffffffc020672a:	02079713          	slli	a4,a5,0x20
ffffffffc020672e:	01d75793          	srli	a5,a4,0x1d
ffffffffc0206732:	040e                	slli	s0,s0,0x3
ffffffffc0206734:	94ee                	add	s1,s1,s11
ffffffffc0206736:	0218                	addi	a4,sp,256
ffffffffc0206738:	943a                	add	s0,s0,a4
ffffffffc020673a:	8c9d                	sub	s1,s1,a5
ffffffffc020673c:	6008                	ld	a0,0(s0)
ffffffffc020673e:	1461                	addi	s0,s0,-8
ffffffffc0206740:	f1efb0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0206744:	fe849ce3          	bne	s1,s0,ffffffffc020673c <do_execve+0x1de>
ffffffffc0206748:	8556                	mv	a0,s5
ffffffffc020674a:	991ff0ef          	jal	ra,ffffffffc02060da <do_exit>
ffffffffc020674e:	000bb783          	ld	a5,0(s7)
ffffffffc0206752:	1487b503          	ld	a0,328(a5)
ffffffffc0206756:	9f4ff0ef          	jal	ra,ffffffffc020594a <files_closeall>
ffffffffc020675a:	4581                	li	a1,0
ffffffffc020675c:	854a                	mv	a0,s2
ffffffffc020675e:	964fe0ef          	jal	ra,ffffffffc02048c2 <sysfile_open>
ffffffffc0206762:	8aaa                	mv	s5,a0
ffffffffc0206764:	fc0540e3          	bltz	a0,ffffffffc0206724 <do_execve+0x1c6>
ffffffffc0206768:	000bb783          	ld	a5,0(s7)
ffffffffc020676c:	779c                	ld	a5,40(a5)
ffffffffc020676e:	d785                	beqz	a5,ffffffffc0206696 <do_execve+0x138>
ffffffffc0206770:	00007617          	auipc	a2,0x7
ffffffffc0206774:	17060613          	addi	a2,a2,368 # ffffffffc020d8e0 <CSWTCH.79+0x2d8>
ffffffffc0206778:	2ca00593          	li	a1,714
ffffffffc020677c:	00007517          	auipc	a0,0x7
ffffffffc0206780:	f5450513          	addi	a0,a0,-172 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0206784:	aabf90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206788:	8552                	mv	a0,s4
ffffffffc020678a:	d37fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc020678e:	5af1                	li	s5,-4
ffffffffc0206790:	bf51                	j	ffffffffc0206724 <do_execve+0x1c6>
ffffffffc0206792:	5c71                	li	s8,-4
ffffffffc0206794:	c49d                	beqz	s1,ffffffffc02067c2 <do_execve+0x264>
ffffffffc0206796:	00349713          	slli	a4,s1,0x3
ffffffffc020679a:	fff48413          	addi	s0,s1,-1
ffffffffc020679e:	199c                	addi	a5,sp,240
ffffffffc02067a0:	34fd                	addiw	s1,s1,-1
ffffffffc02067a2:	97ba                	add	a5,a5,a4
ffffffffc02067a4:	02049713          	slli	a4,s1,0x20
ffffffffc02067a8:	01d75493          	srli	s1,a4,0x1d
ffffffffc02067ac:	040e                	slli	s0,s0,0x3
ffffffffc02067ae:	0218                	addi	a4,sp,256
ffffffffc02067b0:	943a                	add	s0,s0,a4
ffffffffc02067b2:	409784b3          	sub	s1,a5,s1
ffffffffc02067b6:	6008                	ld	a0,0(s0)
ffffffffc02067b8:	1461                	addi	s0,s0,-8
ffffffffc02067ba:	ea4fb0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02067be:	fe849ce3          	bne	s1,s0,ffffffffc02067b6 <do_execve+0x258>
ffffffffc02067c2:	000a0863          	beqz	s4,ffffffffc02067d2 <do_execve+0x274>
ffffffffc02067c6:	038a0513          	addi	a0,s4,56
ffffffffc02067ca:	814fe0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc02067ce:	040a2823          	sw	zero,80(s4)
ffffffffc02067d2:	36813083          	ld	ra,872(sp)
ffffffffc02067d6:	36013403          	ld	s0,864(sp)
ffffffffc02067da:	35813483          	ld	s1,856(sp)
ffffffffc02067de:	35013903          	ld	s2,848(sp)
ffffffffc02067e2:	34813983          	ld	s3,840(sp)
ffffffffc02067e6:	34013a03          	ld	s4,832(sp)
ffffffffc02067ea:	33813a83          	ld	s5,824(sp)
ffffffffc02067ee:	33013b03          	ld	s6,816(sp)
ffffffffc02067f2:	32813b83          	ld	s7,808(sp)
ffffffffc02067f6:	31813c83          	ld	s9,792(sp)
ffffffffc02067fa:	31013d03          	ld	s10,784(sp)
ffffffffc02067fe:	30813d83          	ld	s11,776(sp)
ffffffffc0206802:	8562                	mv	a0,s8
ffffffffc0206804:	32013c03          	ld	s8,800(sp)
ffffffffc0206808:	37010113          	addi	sp,sp,880
ffffffffc020680c:	8082                	ret
ffffffffc020680e:	854a                	mv	a0,s2
ffffffffc0206810:	e4efb0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0206814:	5c75                	li	s8,-3
ffffffffc0206816:	bfbd                	j	ffffffffc0206794 <do_execve+0x236>
ffffffffc0206818:	000bb783          	ld	a5,0(s7)
ffffffffc020681c:	00007617          	auipc	a2,0x7
ffffffffc0206820:	0b460613          	addi	a2,a2,180 # ffffffffc020d8d0 <CSWTCH.79+0x2c8>
ffffffffc0206824:	45c1                	li	a1,16
ffffffffc0206826:	43d4                	lw	a3,4(a5)
ffffffffc0206828:	18a8                	addi	a0,sp,120
ffffffffc020682a:	68d040ef          	jal	ra,ffffffffc020b6b6 <snprintf>
ffffffffc020682e:	b3c1                	j	ffffffffc02065ee <do_execve+0x90>
ffffffffc0206830:	8552                	mv	a0,s4
ffffffffc0206832:	e2bfa0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc0206836:	018a3503          	ld	a0,24(s4)
ffffffffc020683a:	b4eff0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc020683e:	8552                	mv	a0,s4
ffffffffc0206840:	c81fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206844:	b5a9                	j	ffffffffc020668e <do_execve+0x130>
ffffffffc0206846:	04000613          	li	a2,64
ffffffffc020684a:	018c                	addi	a1,sp,192
ffffffffc020684c:	8556                	mv	a0,s5
ffffffffc020684e:	8acfe0ef          	jal	ra,ffffffffc02048fa <sysfile_read>
ffffffffc0206852:	04000793          	li	a5,64
ffffffffc0206856:	00f50863          	beq	a0,a5,ffffffffc0206866 <do_execve+0x308>
ffffffffc020685a:	00050c1b          	sext.w	s8,a0
ffffffffc020685e:	ea054be3          	bltz	a0,ffffffffc0206714 <do_execve+0x1b6>
ffffffffc0206862:	5c7d                	li	s8,-1
ffffffffc0206864:	bd45                	j	ffffffffc0206714 <do_execve+0x1b6>
ffffffffc0206866:	470e                	lw	a4,192(sp)
ffffffffc0206868:	464c47b7          	lui	a5,0x464c4
ffffffffc020686c:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206870:	00f70b63          	beq	a4,a5,ffffffffc0206886 <do_execve+0x328>
ffffffffc0206874:	018a3503          	ld	a0,24(s4)
ffffffffc0206878:	5ae1                	li	s5,-8
ffffffffc020687a:	b0eff0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc020687e:	8552                	mv	a0,s4
ffffffffc0206880:	c41fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206884:	b545                	j	ffffffffc0206724 <do_execve+0x1c6>
ffffffffc0206886:	676e                	ld	a4,216(sp)
ffffffffc0206888:	0f815783          	lhu	a5,248(sp)
ffffffffc020688c:	e082                	sd	zero,64(sp)
ffffffffc020688e:	f0ba                	sd	a4,96(sp)
ffffffffc0206890:	e482                	sd	zero,72(sp)
ffffffffc0206892:	16078e63          	beqz	a5,ffffffffc0206a0e <do_execve+0x4b0>
ffffffffc0206896:	f86e                	sd	s11,48(sp)
ffffffffc0206898:	f4a6                	sd	s1,104(sp)
ffffffffc020689a:	ece2                	sd	s8,88(sp)
ffffffffc020689c:	fc22                	sd	s0,56(sp)
ffffffffc020689e:	758e                	ld	a1,224(sp)
ffffffffc02068a0:	6786                	ld	a5,64(sp)
ffffffffc02068a2:	4601                	li	a2,0
ffffffffc02068a4:	8556                	mv	a0,s5
ffffffffc02068a6:	95be                	add	a1,a1,a5
ffffffffc02068a8:	a80fe0ef          	jal	ra,ffffffffc0204b28 <sysfile_seek>
ffffffffc02068ac:	e02a                	sd	a0,0(sp)
ffffffffc02068ae:	12051a63          	bnez	a0,ffffffffc02069e2 <do_execve+0x484>
ffffffffc02068b2:	03800613          	li	a2,56
ffffffffc02068b6:	012c                	addi	a1,sp,136
ffffffffc02068b8:	8556                	mv	a0,s5
ffffffffc02068ba:	840fe0ef          	jal	ra,ffffffffc02048fa <sysfile_read>
ffffffffc02068be:	03800793          	li	a5,56
ffffffffc02068c2:	12f50363          	beq	a0,a5,ffffffffc02069e8 <do_execve+0x48a>
ffffffffc02068c6:	7dc2                	ld	s11,48(sp)
ffffffffc02068c8:	7462                	ld	s0,56(sp)
ffffffffc02068ca:	8b2a                	mv	s6,a0
ffffffffc02068cc:	00054363          	bltz	a0,ffffffffc02068d2 <do_execve+0x374>
ffffffffc02068d0:	5b7d                	li	s6,-1
ffffffffc02068d2:	000b079b          	sext.w	a5,s6
ffffffffc02068d6:	e03e                	sd	a5,0(sp)
ffffffffc02068d8:	8552                	mv	a0,s4
ffffffffc02068da:	d83fa0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc02068de:	018a3503          	ld	a0,24(s4)
ffffffffc02068e2:	6a82                	ld	s5,0(sp)
ffffffffc02068e4:	aa4ff0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc02068e8:	8552                	mv	a0,s4
ffffffffc02068ea:	bd7fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc02068ee:	bd1d                	j	ffffffffc0206724 <do_execve+0x1c6>
ffffffffc02068f0:	764a                	ld	a2,176(sp)
ffffffffc02068f2:	77aa                	ld	a5,168(sp)
ffffffffc02068f4:	46f66f63          	bltu	a2,a5,ffffffffc0206d72 <do_execve+0x814>
ffffffffc02068f8:	47ba                	lw	a5,140(sp)
ffffffffc02068fa:	0017f693          	andi	a3,a5,1
ffffffffc02068fe:	c291                	beqz	a3,ffffffffc0206902 <do_execve+0x3a4>
ffffffffc0206900:	4691                	li	a3,4
ffffffffc0206902:	0027f713          	andi	a4,a5,2
ffffffffc0206906:	8b91                	andi	a5,a5,4
ffffffffc0206908:	2c071d63          	bnez	a4,ffffffffc0206be2 <do_execve+0x684>
ffffffffc020690c:	4745                	li	a4,17
ffffffffc020690e:	e8ba                	sd	a4,80(sp)
ffffffffc0206910:	c789                	beqz	a5,ffffffffc020691a <do_execve+0x3bc>
ffffffffc0206912:	47cd                	li	a5,19
ffffffffc0206914:	0016e693          	ori	a3,a3,1
ffffffffc0206918:	e8be                	sd	a5,80(sp)
ffffffffc020691a:	0026f793          	andi	a5,a3,2
ffffffffc020691e:	2c079663          	bnez	a5,ffffffffc0206bea <do_execve+0x68c>
ffffffffc0206922:	0046f793          	andi	a5,a3,4
ffffffffc0206926:	c789                	beqz	a5,ffffffffc0206930 <do_execve+0x3d2>
ffffffffc0206928:	67c6                	ld	a5,80(sp)
ffffffffc020692a:	0087e793          	ori	a5,a5,8
ffffffffc020692e:	e8be                	sd	a5,80(sp)
ffffffffc0206930:	65ea                	ld	a1,152(sp)
ffffffffc0206932:	4701                	li	a4,0
ffffffffc0206934:	8552                	mv	a0,s4
ffffffffc0206936:	bddfa0ef          	jal	ra,ffffffffc0201512 <mm_map>
ffffffffc020693a:	e02a                	sd	a0,0(sp)
ffffffffc020693c:	e15d                	bnez	a0,ffffffffc02069e2 <do_execve+0x484>
ffffffffc020693e:	6cea                	ld	s9,152(sp)
ffffffffc0206940:	7c2a                	ld	s8,168(sp)
ffffffffc0206942:	77fd                	lui	a5,0xfffff
ffffffffc0206944:	00fcf433          	and	s0,s9,a5
ffffffffc0206948:	9c66                	add	s8,s8,s9
ffffffffc020694a:	418cff63          	bgeu	s9,s8,ffffffffc0206d68 <do_execve+0x80a>
ffffffffc020694e:	57f1                	li	a5,-4
ffffffffc0206950:	64c6                	ld	s1,80(sp)
ffffffffc0206952:	e03e                	sd	a5,0(sp)
ffffffffc0206954:	8922                	mv	s2,s0
ffffffffc0206956:	a015                	j	ffffffffc020697a <do_execve+0x41c>
ffffffffc0206958:	7702                	ld	a4,32(sp)
ffffffffc020695a:	77a2                	ld	a5,40(sp)
ffffffffc020695c:	412c8933          	sub	s2,s9,s2
ffffffffc0206960:	865a                	mv	a2,s6
ffffffffc0206962:	00f705b3          	add	a1,a4,a5
ffffffffc0206966:	95ca                	add	a1,a1,s2
ffffffffc0206968:	8556                	mv	a0,s5
ffffffffc020696a:	f91fd0ef          	jal	ra,ffffffffc02048fa <sysfile_read>
ffffffffc020696e:	f4ab1ce3          	bne	s6,a0,ffffffffc02068c6 <do_execve+0x368>
ffffffffc0206972:	9cda                	add	s9,s9,s6
ffffffffc0206974:	358cf563          	bgeu	s9,s8,ffffffffc0206cbe <do_execve+0x760>
ffffffffc0206978:	896e                	mv	s2,s11
ffffffffc020697a:	018a3503          	ld	a0,24(s4)
ffffffffc020697e:	8626                	mv	a2,s1
ffffffffc0206980:	85ca                	mv	a1,s2
ffffffffc0206982:	a6ffd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206986:	842a                	mv	s0,a0
ffffffffc0206988:	2c050863          	beqz	a0,ffffffffc0206c58 <do_execve+0x6fa>
ffffffffc020698c:	6785                	lui	a5,0x1
ffffffffc020698e:	00f90db3          	add	s11,s2,a5
ffffffffc0206992:	419d8b33          	sub	s6,s11,s9
ffffffffc0206996:	01bc7463          	bgeu	s8,s11,ffffffffc020699e <do_execve+0x440>
ffffffffc020699a:	419c0b33          	sub	s6,s8,s9
ffffffffc020699e:	000d3583          	ld	a1,0(s10)
ffffffffc02069a2:	67e2                	ld	a5,24(sp)
ffffffffc02069a4:	0009b603          	ld	a2,0(s3)
ffffffffc02069a8:	40b405b3          	sub	a1,s0,a1
ffffffffc02069ac:	8599                	srai	a1,a1,0x6
ffffffffc02069ae:	95be                	add	a1,a1,a5
ffffffffc02069b0:	67a2                	ld	a5,8(sp)
ffffffffc02069b2:	00f5f533          	and	a0,a1,a5
ffffffffc02069b6:	00c59793          	slli	a5,a1,0xc
ffffffffc02069ba:	f03e                	sd	a5,32(sp)
ffffffffc02069bc:	4ac57363          	bgeu	a0,a2,ffffffffc0206e62 <do_execve+0x904>
ffffffffc02069c0:	65ca                	ld	a1,144(sp)
ffffffffc02069c2:	68ea                	ld	a7,152(sp)
ffffffffc02069c4:	00090797          	auipc	a5,0x90
ffffffffc02069c8:	ef478793          	addi	a5,a5,-268 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02069cc:	639c                	ld	a5,0(a5)
ffffffffc02069ce:	411585b3          	sub	a1,a1,a7
ffffffffc02069d2:	4601                	li	a2,0
ffffffffc02069d4:	8556                	mv	a0,s5
ffffffffc02069d6:	95e6                	add	a1,a1,s9
ffffffffc02069d8:	f43e                	sd	a5,40(sp)
ffffffffc02069da:	94efe0ef          	jal	ra,ffffffffc0204b28 <sysfile_seek>
ffffffffc02069de:	e02a                	sd	a0,0(sp)
ffffffffc02069e0:	dd25                	beqz	a0,ffffffffc0206958 <do_execve+0x3fa>
ffffffffc02069e2:	7dc2                	ld	s11,48(sp)
ffffffffc02069e4:	7462                	ld	s0,56(sp)
ffffffffc02069e6:	bdcd                	j	ffffffffc02068d8 <do_execve+0x37a>
ffffffffc02069e8:	47aa                	lw	a5,136(sp)
ffffffffc02069ea:	4705                	li	a4,1
ffffffffc02069ec:	f0e782e3          	beq	a5,a4,ffffffffc02068f0 <do_execve+0x392>
ffffffffc02069f0:	6726                	ld	a4,72(sp)
ffffffffc02069f2:	6686                	ld	a3,64(sp)
ffffffffc02069f4:	0f815783          	lhu	a5,248(sp)
ffffffffc02069f8:	2705                	addiw	a4,a4,1
ffffffffc02069fa:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc02069fe:	e4ba                	sd	a4,72(sp)
ffffffffc0206a00:	e0b6                	sd	a3,64(sp)
ffffffffc0206a02:	e8f76ee3          	bltu	a4,a5,ffffffffc020689e <do_execve+0x340>
ffffffffc0206a06:	7dc2                	ld	s11,48(sp)
ffffffffc0206a08:	74a6                	ld	s1,104(sp)
ffffffffc0206a0a:	6c66                	ld	s8,88(sp)
ffffffffc0206a0c:	7462                	ld	s0,56(sp)
ffffffffc0206a0e:	8556                	mv	a0,s5
ffffffffc0206a10:	ee7fd0ef          	jal	ra,ffffffffc02048f6 <sysfile_close>
ffffffffc0206a14:	4701                	li	a4,0
ffffffffc0206a16:	46ad                	li	a3,11
ffffffffc0206a18:	00100637          	lui	a2,0x100
ffffffffc0206a1c:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206a20:	8552                	mv	a0,s4
ffffffffc0206a22:	af1fa0ef          	jal	ra,ffffffffc0201512 <mm_map>
ffffffffc0206a26:	e02a                	sd	a0,0(sp)
ffffffffc0206a28:	ea0518e3          	bnez	a0,ffffffffc02068d8 <do_execve+0x37a>
ffffffffc0206a2c:	018a3503          	ld	a0,24(s4)
ffffffffc0206a30:	467d                	li	a2,31
ffffffffc0206a32:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206a36:	9bbfd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206a3a:	34050163          	beqz	a0,ffffffffc0206d7c <do_execve+0x81e>
ffffffffc0206a3e:	018a3503          	ld	a0,24(s4)
ffffffffc0206a42:	467d                	li	a2,31
ffffffffc0206a44:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206a48:	9a9fd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206a4c:	32050863          	beqz	a0,ffffffffc0206d7c <do_execve+0x81e>
ffffffffc0206a50:	018a3503          	ld	a0,24(s4)
ffffffffc0206a54:	467d                	li	a2,31
ffffffffc0206a56:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206a5a:	997fd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206a5e:	30050f63          	beqz	a0,ffffffffc0206d7c <do_execve+0x81e>
ffffffffc0206a62:	018a3503          	ld	a0,24(s4)
ffffffffc0206a66:	467d                	li	a2,31
ffffffffc0206a68:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0206a6c:	985fd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206a70:	30050663          	beqz	a0,ffffffffc0206d7c <do_execve+0x81e>
ffffffffc0206a74:	030a2783          	lw	a5,48(s4)
ffffffffc0206a78:	000bb703          	ld	a4,0(s7)
ffffffffc0206a7c:	018a3683          	ld	a3,24(s4)
ffffffffc0206a80:	2785                	addiw	a5,a5,1
ffffffffc0206a82:	02fa2823          	sw	a5,48(s4)
ffffffffc0206a86:	03473423          	sd	s4,40(a4)
ffffffffc0206a8a:	c02007b7          	lui	a5,0xc0200
ffffffffc0206a8e:	40f6e263          	bltu	a3,a5,ffffffffc0206e92 <do_execve+0x934>
ffffffffc0206a92:	00090797          	auipc	a5,0x90
ffffffffc0206a96:	e2678793          	addi	a5,a5,-474 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206a9a:	639c                	ld	a5,0(a5)
ffffffffc0206a9c:	8e9d                	sub	a3,a3,a5
ffffffffc0206a9e:	f754                	sd	a3,168(a4)
ffffffffc0206aa0:	577d                	li	a4,-1
ffffffffc0206aa2:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206aa6:	177e                	slli	a4,a4,0x3f
ffffffffc0206aa8:	8fd9                	or	a5,a5,a4
ffffffffc0206aaa:	18079073          	csrw	satp,a5
ffffffffc0206aae:	4a81                	li	s5,0
ffffffffc0206ab0:	10010b13          	addi	s6,sp,256
ffffffffc0206ab4:	4901                	li	s2,0
ffffffffc0206ab6:	000b3503          	ld	a0,0(s6)
ffffffffc0206aba:	0b21                	addi	s6,s6,8
ffffffffc0206abc:	6c0040ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc0206ac0:	00150793          	addi	a5,a0,1
ffffffffc0206ac4:	8756                	mv	a4,s5
ffffffffc0206ac6:	0127893b          	addw	s2,a5,s2
ffffffffc0206aca:	2a85                	addiw	s5,s5,1
ffffffffc0206acc:	fe9745e3          	blt	a4,s1,ffffffffc0206ab6 <do_execve+0x558>
ffffffffc0206ad0:	800007b7          	lui	a5,0x80000
ffffffffc0206ad4:	4127873b          	subw	a4,a5,s2
ffffffffc0206ad8:	0024879b          	addiw	a5,s1,2
ffffffffc0206adc:	9b71                	andi	a4,a4,-4
ffffffffc0206ade:	0037979b          	slliw	a5,a5,0x3
ffffffffc0206ae2:	40f707bb          	subw	a5,a4,a5
ffffffffc0206ae6:	c0be                	sw	a5,64(sp)
ffffffffc0206ae8:	1782                	slli	a5,a5,0x20
ffffffffc0206aea:	9381                	srli	a5,a5,0x20
ffffffffc0206aec:	f43e                	sd	a5,40(sp)
ffffffffc0206aee:	021c                	addi	a5,sp,256
ffffffffc0206af0:	e43e                	sd	a5,8(sp)
ffffffffc0206af2:	57fd                	li	a5,-1
ffffffffc0206af4:	20010a93          	addi	s5,sp,512
ffffffffc0206af8:	83b1                	srli	a5,a5,0xc
ffffffffc0206afa:	00070c9b          	sext.w	s9,a4
ffffffffc0206afe:	f056                	sd	s5,32(sp)
ffffffffc0206b00:	f802                	sd	zero,48(sp)
ffffffffc0206b02:	e4be                	sd	a5,72(sp)
ffffffffc0206b04:	e8d6                	sd	s5,80(sp)
ffffffffc0206b06:	fc22                	sd	s0,56(sp)
ffffffffc0206b08:	a8a1                	j	ffffffffc0206b60 <do_execve+0x602>
ffffffffc0206b0a:	000d3603          	ld	a2,0(s10)
ffffffffc0206b0e:	6762                	ld	a4,24(sp)
ffffffffc0206b10:	0009b683          	ld	a3,0(s3)
ffffffffc0206b14:	8f91                	sub	a5,a5,a2
ffffffffc0206b16:	8799                	srai	a5,a5,0x6
ffffffffc0206b18:	97ba                	add	a5,a5,a4
ffffffffc0206b1a:	6726                	ld	a4,72(sp)
ffffffffc0206b1c:	00e7f633          	and	a2,a5,a4
ffffffffc0206b20:	07b2                	slli	a5,a5,0xc
ffffffffc0206b22:	32d67363          	bgeu	a2,a3,ffffffffc0206e48 <do_execve+0x8ea>
ffffffffc0206b26:	00090717          	auipc	a4,0x90
ffffffffc0206b2a:	d9270713          	addi	a4,a4,-622 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206b2e:	6314                	ld	a3,0(a4)
ffffffffc0206b30:	415b0533          	sub	a0,s6,s5
ffffffffc0206b34:	02091613          	slli	a2,s2,0x20
ffffffffc0206b38:	97b6                	add	a5,a5,a3
ffffffffc0206b3a:	953e                	add	a0,a0,a5
ffffffffc0206b3c:	9201                	srli	a2,a2,0x20
ffffffffc0206b3e:	85a2                	mv	a1,s0
ffffffffc0206b40:	730040ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0206b44:	66a2                	ld	a3,8(sp)
ffffffffc0206b46:	7742                	ld	a4,48(sp)
ffffffffc0206b48:	01990cbb          	addw	s9,s2,s9
ffffffffc0206b4c:	06a1                	addi	a3,a3,8
ffffffffc0206b4e:	e436                	sd	a3,8(sp)
ffffffffc0206b50:	7682                	ld	a3,32(sp)
ffffffffc0206b52:	0017079b          	addiw	a5,a4,1
ffffffffc0206b56:	06a1                	addi	a3,a3,8
ffffffffc0206b58:	f036                	sd	a3,32(sp)
ffffffffc0206b5a:	22975d63          	bge	a4,s1,ffffffffc0206d94 <do_execve+0x836>
ffffffffc0206b5e:	f83e                	sd	a5,48(sp)
ffffffffc0206b60:	67a2                	ld	a5,8(sp)
ffffffffc0206b62:	020c9b13          	slli	s6,s9,0x20
ffffffffc0206b66:	020b5b13          	srli	s6,s6,0x20
ffffffffc0206b6a:	6380                	ld	s0,0(a5)
ffffffffc0206b6c:	8522                	mv	a0,s0
ffffffffc0206b6e:	60e040ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc0206b72:	77fd                	lui	a5,0xfffff
ffffffffc0206b74:	00fcf5b3          	and	a1,s9,a5
ffffffffc0206b78:	7782                	ld	a5,32(sp)
ffffffffc0206b7a:	892a                	mv	s2,a0
ffffffffc0206b7c:	02059a93          	slli	s5,a1,0x20
ffffffffc0206b80:	018a3503          	ld	a0,24(s4)
ffffffffc0206b84:	020ada93          	srli	s5,s5,0x20
ffffffffc0206b88:	0167b023          	sd	s6,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0206b8c:	1890                	addi	a2,sp,112
ffffffffc0206b8e:	85d6                	mv	a1,s5
ffffffffc0206b90:	a50fc0ef          	jal	ra,ffffffffc0202de0 <get_page>
ffffffffc0206b94:	2905                	addiw	s2,s2,1
ffffffffc0206b96:	87aa                	mv	a5,a0
ffffffffc0206b98:	f92d                	bnez	a0,ffffffffc0206b0a <do_execve+0x5ac>
ffffffffc0206b9a:	018a3503          	ld	a0,24(s4)
ffffffffc0206b9e:	467d                	li	a2,31
ffffffffc0206ba0:	85d6                	mv	a1,s5
ffffffffc0206ba2:	84ffd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206ba6:	87aa                	mv	a5,a0
ffffffffc0206ba8:	f12d                	bnez	a0,ffffffffc0206b0a <do_execve+0x5ac>
ffffffffc0206baa:	7462                	ld	s0,56(sp)
ffffffffc0206bac:	00090497          	auipc	s1,0x90
ffffffffc0206bb0:	ce448493          	addi	s1,s1,-796 # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0206bb4:	609c                	ld	a5,0(s1)
ffffffffc0206bb6:	577d                	li	a4,-1
ffffffffc0206bb8:	177e                	slli	a4,a4,0x3f
ffffffffc0206bba:	83b1                	srli	a5,a5,0xc
ffffffffc0206bbc:	8fd9                	or	a5,a5,a4
ffffffffc0206bbe:	18079073          	csrw	satp,a5
ffffffffc0206bc2:	030a2783          	lw	a5,48(s4)
ffffffffc0206bc6:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206bca:	02ea2823          	sw	a4,48(s4)
ffffffffc0206bce:	2a070763          	beqz	a4,ffffffffc0206e7c <do_execve+0x91e>
ffffffffc0206bd2:	000bb783          	ld	a5,0(s7)
ffffffffc0206bd6:	6098                	ld	a4,0(s1)
ffffffffc0206bd8:	5af1                	li	s5,-4
ffffffffc0206bda:	0207b423          	sd	zero,40(a5)
ffffffffc0206bde:	f7d8                	sd	a4,168(a5)
ffffffffc0206be0:	b691                	j	ffffffffc0206724 <do_execve+0x1c6>
ffffffffc0206be2:	0026e693          	ori	a3,a3,2
ffffffffc0206be6:	d20796e3          	bnez	a5,ffffffffc0206912 <do_execve+0x3b4>
ffffffffc0206bea:	47dd                	li	a5,23
ffffffffc0206bec:	e8be                	sd	a5,80(sp)
ffffffffc0206bee:	bb15                	j	ffffffffc0206922 <do_execve+0x3c4>
ffffffffc0206bf0:	13b79c63          	bne	a5,s11,ffffffffc0206d28 <do_execve+0x7ca>
ffffffffc0206bf4:	8cee                	mv	s9,s11
ffffffffc0206bf6:	de9cfde3          	bgeu	s9,s1,ffffffffc02069f0 <do_execve+0x492>
ffffffffc0206bfa:	6446                	ld	s0,80(sp)
ffffffffc0206bfc:	6962                	ld	s2,24(sp)
ffffffffc0206bfe:	a0a9                	j	ffffffffc0206c48 <do_execve+0x6ea>
ffffffffc0206c00:	6785                	lui	a5,0x1
ffffffffc0206c02:	41bc8533          	sub	a0,s9,s11
ffffffffc0206c06:	9dbe                	add	s11,s11,a5
ffffffffc0206c08:	419d8633          	sub	a2,s11,s9
ffffffffc0206c0c:	01b4f463          	bgeu	s1,s11,ffffffffc0206c14 <do_execve+0x6b6>
ffffffffc0206c10:	41948633          	sub	a2,s1,s9
ffffffffc0206c14:	000d3783          	ld	a5,0(s10)
ffffffffc0206c18:	66a2                	ld	a3,8(sp)
ffffffffc0206c1a:	0009b703          	ld	a4,0(s3)
ffffffffc0206c1e:	40fb07b3          	sub	a5,s6,a5
ffffffffc0206c22:	8799                	srai	a5,a5,0x6
ffffffffc0206c24:	97ca                	add	a5,a5,s2
ffffffffc0206c26:	8efd                	and	a3,a3,a5
ffffffffc0206c28:	07b2                	slli	a5,a5,0xc
ffffffffc0206c2a:	20e6ff63          	bgeu	a3,a4,ffffffffc0206e48 <do_execve+0x8ea>
ffffffffc0206c2e:	00090717          	auipc	a4,0x90
ffffffffc0206c32:	c8a70713          	addi	a4,a4,-886 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206c36:	6318                	ld	a4,0(a4)
ffffffffc0206c38:	9cb2                	add	s9,s9,a2
ffffffffc0206c3a:	4581                	li	a1,0
ffffffffc0206c3c:	97ba                	add	a5,a5,a4
ffffffffc0206c3e:	953e                	add	a0,a0,a5
ffffffffc0206c40:	5de040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0206c44:	109cf263          	bgeu	s9,s1,ffffffffc0206d48 <do_execve+0x7ea>
ffffffffc0206c48:	018a3503          	ld	a0,24(s4)
ffffffffc0206c4c:	8622                	mv	a2,s0
ffffffffc0206c4e:	85ee                	mv	a1,s11
ffffffffc0206c50:	fa0fd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206c54:	8b2a                	mv	s6,a0
ffffffffc0206c56:	f54d                	bnez	a0,ffffffffc0206c00 <do_execve+0x6a2>
ffffffffc0206c58:	8552                	mv	a0,s4
ffffffffc0206c5a:	7dc2                	ld	s11,48(sp)
ffffffffc0206c5c:	6c66                	ld	s8,88(sp)
ffffffffc0206c5e:	7462                	ld	s0,56(sp)
ffffffffc0206c60:	9fdfa0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc0206c64:	018a3503          	ld	a0,24(s4)
ffffffffc0206c68:	f21fe0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc0206c6c:	8552                	mv	a0,s4
ffffffffc0206c6e:	853fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206c72:	6782                	ld	a5,0(sp)
ffffffffc0206c74:	22079b63          	bnez	a5,ffffffffc0206eaa <do_execve+0x94c>
ffffffffc0206c78:	67c2                	ld	a5,16(sp)
ffffffffc0206c7a:	147d                	addi	s0,s0,-1
ffffffffc0206c7c:	1984                	addi	s1,sp,240
ffffffffc0206c7e:	02079713          	slli	a4,a5,0x20
ffffffffc0206c82:	01d75793          	srli	a5,a4,0x1d
ffffffffc0206c86:	040e                	slli	s0,s0,0x3
ffffffffc0206c88:	94ee                	add	s1,s1,s11
ffffffffc0206c8a:	0218                	addi	a4,sp,256
ffffffffc0206c8c:	943a                	add	s0,s0,a4
ffffffffc0206c8e:	8c9d                	sub	s1,s1,a5
ffffffffc0206c90:	6008                	ld	a0,0(s0)
ffffffffc0206c92:	1461                	addi	s0,s0,-8
ffffffffc0206c94:	9cafb0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0206c98:	fe849ce3          	bne	s1,s0,ffffffffc0206c90 <do_execve+0x732>
ffffffffc0206c9c:	000bb403          	ld	s0,0(s7)
ffffffffc0206ca0:	4641                	li	a2,16
ffffffffc0206ca2:	4581                	li	a1,0
ffffffffc0206ca4:	0b440413          	addi	s0,s0,180
ffffffffc0206ca8:	8522                	mv	a0,s0
ffffffffc0206caa:	574040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0206cae:	463d                	li	a2,15
ffffffffc0206cb0:	18ac                	addi	a1,sp,120
ffffffffc0206cb2:	8522                	mv	a0,s0
ffffffffc0206cb4:	5bc040ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0206cb8:	be29                	j	ffffffffc02067d2 <do_execve+0x274>
ffffffffc0206cba:	5c75                	li	s8,-3
ffffffffc0206cbc:	be19                	j	ffffffffc02067d2 <do_execve+0x274>
ffffffffc0206cbe:	64ea                	ld	s1,152(sp)
ffffffffc0206cc0:	f022                	sd	s0,32(sp)
ffffffffc0206cc2:	76ca                	ld	a3,176(sp)
ffffffffc0206cc4:	94b6                	add	s1,s1,a3
ffffffffc0206cc6:	f3bcf8e3          	bgeu	s9,s11,ffffffffc0206bf6 <do_execve+0x698>
ffffffffc0206cca:	d39483e3          	beq	s1,s9,ffffffffc02069f0 <do_execve+0x492>
ffffffffc0206cce:	6785                	lui	a5,0x1
ffffffffc0206cd0:	00fc8533          	add	a0,s9,a5
ffffffffc0206cd4:	41b50533          	sub	a0,a0,s11
ffffffffc0206cd8:	41948933          	sub	s2,s1,s9
ffffffffc0206cdc:	01b4e463          	bltu	s1,s11,ffffffffc0206ce4 <do_execve+0x786>
ffffffffc0206ce0:	419d8933          	sub	s2,s11,s9
ffffffffc0206ce4:	7782                	ld	a5,32(sp)
ffffffffc0206ce6:	000d3683          	ld	a3,0(s10)
ffffffffc0206cea:	0009b603          	ld	a2,0(s3)
ffffffffc0206cee:	40d786b3          	sub	a3,a5,a3
ffffffffc0206cf2:	67e2                	ld	a5,24(sp)
ffffffffc0206cf4:	8699                	srai	a3,a3,0x6
ffffffffc0206cf6:	96be                	add	a3,a3,a5
ffffffffc0206cf8:	67a2                	ld	a5,8(sp)
ffffffffc0206cfa:	00f6f5b3          	and	a1,a3,a5
ffffffffc0206cfe:	06b2                	slli	a3,a3,0xc
ffffffffc0206d00:	16c5f263          	bgeu	a1,a2,ffffffffc0206e64 <do_execve+0x906>
ffffffffc0206d04:	00090797          	auipc	a5,0x90
ffffffffc0206d08:	bb478793          	addi	a5,a5,-1100 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206d0c:	0007b803          	ld	a6,0(a5)
ffffffffc0206d10:	864a                	mv	a2,s2
ffffffffc0206d12:	4581                	li	a1,0
ffffffffc0206d14:	96c2                	add	a3,a3,a6
ffffffffc0206d16:	9536                	add	a0,a0,a3
ffffffffc0206d18:	506040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0206d1c:	019907b3          	add	a5,s2,s9
ffffffffc0206d20:	edb4f8e3          	bgeu	s1,s11,ffffffffc0206bf0 <do_execve+0x692>
ffffffffc0206d24:	ccf486e3          	beq	s1,a5,ffffffffc02069f0 <do_execve+0x492>
ffffffffc0206d28:	00007697          	auipc	a3,0x7
ffffffffc0206d2c:	be068693          	addi	a3,a3,-1056 # ffffffffc020d908 <CSWTCH.79+0x300>
ffffffffc0206d30:	00005617          	auipc	a2,0x5
ffffffffc0206d34:	ee860613          	addi	a2,a2,-280 # ffffffffc020bc18 <commands+0x250>
ffffffffc0206d38:	33600593          	li	a1,822
ffffffffc0206d3c:	00007517          	auipc	a0,0x7
ffffffffc0206d40:	99450513          	addi	a0,a0,-1644 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0206d44:	ceaf90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206d48:	f05a                	sd	s6,32(sp)
ffffffffc0206d4a:	b15d                	j	ffffffffc02069f0 <do_execve+0x492>
ffffffffc0206d4c:	5c75                	li	s8,-3
ffffffffc0206d4e:	a60a1ce3          	bnez	s4,ffffffffc02067c6 <do_execve+0x268>
ffffffffc0206d52:	b441                	j	ffffffffc02067d2 <do_execve+0x274>
ffffffffc0206d54:	f60a03e3          	beqz	s4,ffffffffc0206cba <do_execve+0x75c>
ffffffffc0206d58:	038a0513          	addi	a0,s4,56
ffffffffc0206d5c:	a83fd0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0206d60:	5c75                	li	s8,-3
ffffffffc0206d62:	040a2823          	sw	zero,80(s4)
ffffffffc0206d66:	b4b5                	j	ffffffffc02067d2 <do_execve+0x274>
ffffffffc0206d68:	57f1                	li	a5,-4
ffffffffc0206d6a:	84e6                	mv	s1,s9
ffffffffc0206d6c:	8da2                	mv	s11,s0
ffffffffc0206d6e:	e03e                	sd	a5,0(sp)
ffffffffc0206d70:	bf89                	j	ffffffffc0206cc2 <do_execve+0x764>
ffffffffc0206d72:	57e1                	li	a5,-8
ffffffffc0206d74:	7dc2                	ld	s11,48(sp)
ffffffffc0206d76:	7462                	ld	s0,56(sp)
ffffffffc0206d78:	e03e                	sd	a5,0(sp)
ffffffffc0206d7a:	beb9                	j	ffffffffc02068d8 <do_execve+0x37a>
ffffffffc0206d7c:	8552                	mv	a0,s4
ffffffffc0206d7e:	8dffa0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc0206d82:	018a3503          	ld	a0,24(s4)
ffffffffc0206d86:	5af1                	li	s5,-4
ffffffffc0206d88:	e01fe0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc0206d8c:	8552                	mv	a0,s4
ffffffffc0206d8e:	f32fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206d92:	ba49                	j	ffffffffc0206724 <do_execve+0x1c6>
ffffffffc0206d94:	6786                	ld	a5,64(sp)
ffffffffc0206d96:	797d                	lui	s2,0xfffff
ffffffffc0206d98:	018a3503          	ld	a0,24(s4)
ffffffffc0206d9c:	0127f933          	and	s2,a5,s2
ffffffffc0206da0:	1902                	slli	s2,s2,0x20
ffffffffc0206da2:	02095913          	srli	s2,s2,0x20
ffffffffc0206da6:	1890                	addi	a2,sp,112
ffffffffc0206da8:	85ca                	mv	a1,s2
ffffffffc0206daa:	6ac6                	ld	s5,80(sp)
ffffffffc0206dac:	7462                	ld	s0,56(sp)
ffffffffc0206dae:	832fc0ef          	jal	ra,ffffffffc0202de0 <get_page>
ffffffffc0206db2:	87aa                	mv	a5,a0
ffffffffc0206db4:	c149                	beqz	a0,ffffffffc0206e36 <do_execve+0x8d8>
ffffffffc0206db6:	000d3683          	ld	a3,0(s10)
ffffffffc0206dba:	0009b703          	ld	a4,0(s3)
ffffffffc0206dbe:	40d786b3          	sub	a3,a5,a3
ffffffffc0206dc2:	67e2                	ld	a5,24(sp)
ffffffffc0206dc4:	8699                	srai	a3,a3,0x6
ffffffffc0206dc6:	96be                	add	a3,a3,a5
ffffffffc0206dc8:	00c69793          	slli	a5,a3,0xc
ffffffffc0206dcc:	83b1                	srli	a5,a5,0xc
ffffffffc0206dce:	06b2                	slli	a3,a3,0xc
ffffffffc0206dd0:	08e7fa63          	bgeu	a5,a4,ffffffffc0206e64 <do_execve+0x906>
ffffffffc0206dd4:	00090797          	auipc	a5,0x90
ffffffffc0206dd8:	ae478793          	addi	a5,a5,-1308 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206ddc:	7722                	ld	a4,40(sp)
ffffffffc0206dde:	639c                	ld	a5,0(a5)
ffffffffc0206de0:	41270933          	sub	s2,a4,s2
ffffffffc0206de4:	97b6                	add	a5,a5,a3
ffffffffc0206de6:	6682                	ld	a3,0(sp)
ffffffffc0206de8:	97ca                	add	a5,a5,s2
ffffffffc0206dea:	873e                	mv	a4,a5
ffffffffc0206dec:	000ab583          	ld	a1,0(s5)
ffffffffc0206df0:	8636                	mv	a2,a3
ffffffffc0206df2:	0aa1                	addi	s5,s5,8
ffffffffc0206df4:	e30c                	sd	a1,0(a4)
ffffffffc0206df6:	2685                	addiw	a3,a3,1
ffffffffc0206df8:	0721                	addi	a4,a4,8
ffffffffc0206dfa:	fe9649e3          	blt	a2,s1,ffffffffc0206dec <do_execve+0x88e>
ffffffffc0206dfe:	000bb703          	ld	a4,0(s7)
ffffffffc0206e02:	97ee                	add	a5,a5,s11
ffffffffc0206e04:	0007b023          	sd	zero,0(a5)
ffffffffc0206e08:	7344                	ld	s1,160(a4)
ffffffffc0206e0a:	12000613          	li	a2,288
ffffffffc0206e0e:	4581                	li	a1,0
ffffffffc0206e10:	1004b903          	ld	s2,256(s1)
ffffffffc0206e14:	8526                	mv	a0,s1
ffffffffc0206e16:	408040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0206e1a:	7722                	ld	a4,40(sp)
ffffffffc0206e1c:	7686                	ld	a3,96(sp)
ffffffffc0206e1e:	edf97793          	andi	a5,s2,-289
ffffffffc0206e22:	0207e793          	ori	a5,a5,32
ffffffffc0206e26:	e898                	sd	a4,16(s1)
ffffffffc0206e28:	10d4b423          	sd	a3,264(s1)
ffffffffc0206e2c:	e8a0                	sd	s0,80(s1)
ffffffffc0206e2e:	ecb8                	sd	a4,88(s1)
ffffffffc0206e30:	10f4b023          	sd	a5,256(s1)
ffffffffc0206e34:	b591                	j	ffffffffc0206c78 <do_execve+0x71a>
ffffffffc0206e36:	018a3503          	ld	a0,24(s4)
ffffffffc0206e3a:	467d                	li	a2,31
ffffffffc0206e3c:	85ca                	mv	a1,s2
ffffffffc0206e3e:	db2fd0ef          	jal	ra,ffffffffc02043f0 <pgdir_alloc_page>
ffffffffc0206e42:	87aa                	mv	a5,a0
ffffffffc0206e44:	f92d                	bnez	a0,ffffffffc0206db6 <do_execve+0x858>
ffffffffc0206e46:	b39d                	j	ffffffffc0206bac <do_execve+0x64e>
ffffffffc0206e48:	86be                	mv	a3,a5
ffffffffc0206e4a:	00005617          	auipc	a2,0x5
ffffffffc0206e4e:	74660613          	addi	a2,a2,1862 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0206e52:	07100593          	li	a1,113
ffffffffc0206e56:	00005517          	auipc	a0,0x5
ffffffffc0206e5a:	76250513          	addi	a0,a0,1890 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0206e5e:	bd0f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206e62:	86be                	mv	a3,a5
ffffffffc0206e64:	00005617          	auipc	a2,0x5
ffffffffc0206e68:	72c60613          	addi	a2,a2,1836 # ffffffffc020c590 <commands+0xbc8>
ffffffffc0206e6c:	07100593          	li	a1,113
ffffffffc0206e70:	00005517          	auipc	a0,0x5
ffffffffc0206e74:	74850513          	addi	a0,a0,1864 # ffffffffc020c5b8 <commands+0xbf0>
ffffffffc0206e78:	bb6f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206e7c:	8552                	mv	a0,s4
ffffffffc0206e7e:	fdefa0ef          	jal	ra,ffffffffc020165c <exit_mmap>
ffffffffc0206e82:	018a3503          	ld	a0,24(s4)
ffffffffc0206e86:	d03fe0ef          	jal	ra,ffffffffc0205b88 <put_pgdir.isra.0>
ffffffffc0206e8a:	8552                	mv	a0,s4
ffffffffc0206e8c:	e34fa0ef          	jal	ra,ffffffffc02014c0 <mm_destroy>
ffffffffc0206e90:	b389                	j	ffffffffc0206bd2 <do_execve+0x674>
ffffffffc0206e92:	00005617          	auipc	a2,0x5
ffffffffc0206e96:	7a660613          	addi	a2,a2,1958 # ffffffffc020c638 <commands+0xc70>
ffffffffc0206e9a:	36000593          	li	a1,864
ffffffffc0206e9e:	00007517          	auipc	a0,0x7
ffffffffc0206ea2:	83250513          	addi	a0,a0,-1998 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0206ea6:	b88f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206eaa:	6a82                	ld	s5,0(sp)
ffffffffc0206eac:	879ff06f          	j	ffffffffc0206724 <do_execve+0x1c6>

ffffffffc0206eb0 <user_main>:
ffffffffc0206eb0:	7179                	addi	sp,sp,-48
ffffffffc0206eb2:	e84a                	sd	s2,16(sp)
ffffffffc0206eb4:	00090917          	auipc	s2,0x90
ffffffffc0206eb8:	a0c90913          	addi	s2,s2,-1524 # ffffffffc02968c0 <current>
ffffffffc0206ebc:	00093783          	ld	a5,0(s2)
ffffffffc0206ec0:	00007617          	auipc	a2,0x7
ffffffffc0206ec4:	a8860613          	addi	a2,a2,-1400 # ffffffffc020d948 <CSWTCH.79+0x340>
ffffffffc0206ec8:	00007517          	auipc	a0,0x7
ffffffffc0206ecc:	a8850513          	addi	a0,a0,-1400 # ffffffffc020d950 <CSWTCH.79+0x348>
ffffffffc0206ed0:	43cc                	lw	a1,4(a5)
ffffffffc0206ed2:	f406                	sd	ra,40(sp)
ffffffffc0206ed4:	f022                	sd	s0,32(sp)
ffffffffc0206ed6:	ec26                	sd	s1,24(sp)
ffffffffc0206ed8:	e032                	sd	a2,0(sp)
ffffffffc0206eda:	e402                	sd	zero,8(sp)
ffffffffc0206edc:	a4ef90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0206ee0:	6782                	ld	a5,0(sp)
ffffffffc0206ee2:	cfb9                	beqz	a5,ffffffffc0206f40 <user_main+0x90>
ffffffffc0206ee4:	003c                	addi	a5,sp,8
ffffffffc0206ee6:	4401                	li	s0,0
ffffffffc0206ee8:	6398                	ld	a4,0(a5)
ffffffffc0206eea:	0405                	addi	s0,s0,1
ffffffffc0206eec:	07a1                	addi	a5,a5,8
ffffffffc0206eee:	ff6d                	bnez	a4,ffffffffc0206ee8 <user_main+0x38>
ffffffffc0206ef0:	00093783          	ld	a5,0(s2)
ffffffffc0206ef4:	12000613          	li	a2,288
ffffffffc0206ef8:	6b84                	ld	s1,16(a5)
ffffffffc0206efa:	73cc                	ld	a1,160(a5)
ffffffffc0206efc:	6789                	lui	a5,0x2
ffffffffc0206efe:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206f02:	94be                	add	s1,s1,a5
ffffffffc0206f04:	8526                	mv	a0,s1
ffffffffc0206f06:	36a040ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0206f0a:	00093783          	ld	a5,0(s2)
ffffffffc0206f0e:	860a                	mv	a2,sp
ffffffffc0206f10:	0004059b          	sext.w	a1,s0
ffffffffc0206f14:	f3c4                	sd	s1,160(a5)
ffffffffc0206f16:	00007517          	auipc	a0,0x7
ffffffffc0206f1a:	a3250513          	addi	a0,a0,-1486 # ffffffffc020d948 <CSWTCH.79+0x340>
ffffffffc0206f1e:	e40ff0ef          	jal	ra,ffffffffc020655e <do_execve>
ffffffffc0206f22:	8126                	mv	sp,s1
ffffffffc0206f24:	bccfa06f          	j	ffffffffc02012f0 <__trapret>
ffffffffc0206f28:	00007617          	auipc	a2,0x7
ffffffffc0206f2c:	a5060613          	addi	a2,a2,-1456 # ffffffffc020d978 <CSWTCH.79+0x370>
ffffffffc0206f30:	4d500593          	li	a1,1237
ffffffffc0206f34:	00006517          	auipc	a0,0x6
ffffffffc0206f38:	79c50513          	addi	a0,a0,1948 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0206f3c:	af2f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206f40:	4401                	li	s0,0
ffffffffc0206f42:	b77d                	j	ffffffffc0206ef0 <user_main+0x40>

ffffffffc0206f44 <do_yield>:
ffffffffc0206f44:	00090797          	auipc	a5,0x90
ffffffffc0206f48:	97c7b783          	ld	a5,-1668(a5) # ffffffffc02968c0 <current>
ffffffffc0206f4c:	4705                	li	a4,1
ffffffffc0206f4e:	ef98                	sd	a4,24(a5)
ffffffffc0206f50:	4501                	li	a0,0
ffffffffc0206f52:	8082                	ret

ffffffffc0206f54 <do_wait>:
ffffffffc0206f54:	1101                	addi	sp,sp,-32
ffffffffc0206f56:	e822                	sd	s0,16(sp)
ffffffffc0206f58:	e426                	sd	s1,8(sp)
ffffffffc0206f5a:	ec06                	sd	ra,24(sp)
ffffffffc0206f5c:	842e                	mv	s0,a1
ffffffffc0206f5e:	84aa                	mv	s1,a0
ffffffffc0206f60:	c999                	beqz	a1,ffffffffc0206f76 <do_wait+0x22>
ffffffffc0206f62:	00090797          	auipc	a5,0x90
ffffffffc0206f66:	95e7b783          	ld	a5,-1698(a5) # ffffffffc02968c0 <current>
ffffffffc0206f6a:	7788                	ld	a0,40(a5)
ffffffffc0206f6c:	4685                	li	a3,1
ffffffffc0206f6e:	4611                	li	a2,4
ffffffffc0206f70:	a8dfa0ef          	jal	ra,ffffffffc02019fc <user_mem_check>
ffffffffc0206f74:	c909                	beqz	a0,ffffffffc0206f86 <do_wait+0x32>
ffffffffc0206f76:	85a2                	mv	a1,s0
ffffffffc0206f78:	6442                	ld	s0,16(sp)
ffffffffc0206f7a:	60e2                	ld	ra,24(sp)
ffffffffc0206f7c:	8526                	mv	a0,s1
ffffffffc0206f7e:	64a2                	ld	s1,8(sp)
ffffffffc0206f80:	6105                	addi	sp,sp,32
ffffffffc0206f82:	abaff06f          	j	ffffffffc020623c <do_wait.part.0>
ffffffffc0206f86:	60e2                	ld	ra,24(sp)
ffffffffc0206f88:	6442                	ld	s0,16(sp)
ffffffffc0206f8a:	64a2                	ld	s1,8(sp)
ffffffffc0206f8c:	5575                	li	a0,-3
ffffffffc0206f8e:	6105                	addi	sp,sp,32
ffffffffc0206f90:	8082                	ret

ffffffffc0206f92 <do_kill>:
ffffffffc0206f92:	1141                	addi	sp,sp,-16
ffffffffc0206f94:	6789                	lui	a5,0x2
ffffffffc0206f96:	e406                	sd	ra,8(sp)
ffffffffc0206f98:	e022                	sd	s0,0(sp)
ffffffffc0206f9a:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206f9e:	17f9                	addi	a5,a5,-2
ffffffffc0206fa0:	02e7e963          	bltu	a5,a4,ffffffffc0206fd2 <do_kill+0x40>
ffffffffc0206fa4:	842a                	mv	s0,a0
ffffffffc0206fa6:	45a9                	li	a1,10
ffffffffc0206fa8:	2501                	sext.w	a0,a0
ffffffffc0206faa:	75a040ef          	jal	ra,ffffffffc020b704 <hash32>
ffffffffc0206fae:	02051793          	slli	a5,a0,0x20
ffffffffc0206fb2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206fb6:	0008b797          	auipc	a5,0x8b
ffffffffc0206fba:	80a78793          	addi	a5,a5,-2038 # ffffffffc02917c0 <hash_list>
ffffffffc0206fbe:	953e                	add	a0,a0,a5
ffffffffc0206fc0:	87aa                	mv	a5,a0
ffffffffc0206fc2:	a029                	j	ffffffffc0206fcc <do_kill+0x3a>
ffffffffc0206fc4:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206fc8:	00870b63          	beq	a4,s0,ffffffffc0206fde <do_kill+0x4c>
ffffffffc0206fcc:	679c                	ld	a5,8(a5)
ffffffffc0206fce:	fef51be3          	bne	a0,a5,ffffffffc0206fc4 <do_kill+0x32>
ffffffffc0206fd2:	5475                	li	s0,-3
ffffffffc0206fd4:	60a2                	ld	ra,8(sp)
ffffffffc0206fd6:	8522                	mv	a0,s0
ffffffffc0206fd8:	6402                	ld	s0,0(sp)
ffffffffc0206fda:	0141                	addi	sp,sp,16
ffffffffc0206fdc:	8082                	ret
ffffffffc0206fde:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206fe2:	00177693          	andi	a3,a4,1
ffffffffc0206fe6:	e295                	bnez	a3,ffffffffc020700a <do_kill+0x78>
ffffffffc0206fe8:	4bd4                	lw	a3,20(a5)
ffffffffc0206fea:	00176713          	ori	a4,a4,1
ffffffffc0206fee:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0206ff2:	4401                	li	s0,0
ffffffffc0206ff4:	fe06d0e3          	bgez	a3,ffffffffc0206fd4 <do_kill+0x42>
ffffffffc0206ff8:	f2878513          	addi	a0,a5,-216
ffffffffc0206ffc:	308000ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc0207000:	60a2                	ld	ra,8(sp)
ffffffffc0207002:	8522                	mv	a0,s0
ffffffffc0207004:	6402                	ld	s0,0(sp)
ffffffffc0207006:	0141                	addi	sp,sp,16
ffffffffc0207008:	8082                	ret
ffffffffc020700a:	545d                	li	s0,-9
ffffffffc020700c:	b7e1                	j	ffffffffc0206fd4 <do_kill+0x42>

ffffffffc020700e <proc_init>:
ffffffffc020700e:	1101                	addi	sp,sp,-32
ffffffffc0207010:	e426                	sd	s1,8(sp)
ffffffffc0207012:	0008e797          	auipc	a5,0x8e
ffffffffc0207016:	7ae78793          	addi	a5,a5,1966 # ffffffffc02957c0 <proc_list>
ffffffffc020701a:	ec06                	sd	ra,24(sp)
ffffffffc020701c:	e822                	sd	s0,16(sp)
ffffffffc020701e:	e04a                	sd	s2,0(sp)
ffffffffc0207020:	0008a497          	auipc	s1,0x8a
ffffffffc0207024:	7a048493          	addi	s1,s1,1952 # ffffffffc02917c0 <hash_list>
ffffffffc0207028:	e79c                	sd	a5,8(a5)
ffffffffc020702a:	e39c                	sd	a5,0(a5)
ffffffffc020702c:	0008e717          	auipc	a4,0x8e
ffffffffc0207030:	79470713          	addi	a4,a4,1940 # ffffffffc02957c0 <proc_list>
ffffffffc0207034:	87a6                	mv	a5,s1
ffffffffc0207036:	e79c                	sd	a5,8(a5)
ffffffffc0207038:	e39c                	sd	a5,0(a5)
ffffffffc020703a:	07c1                	addi	a5,a5,16
ffffffffc020703c:	fef71de3          	bne	a4,a5,ffffffffc0207036 <proc_init+0x28>
ffffffffc0207040:	aa1fe0ef          	jal	ra,ffffffffc0205ae0 <alloc_proc>
ffffffffc0207044:	00090917          	auipc	s2,0x90
ffffffffc0207048:	88490913          	addi	s2,s2,-1916 # ffffffffc02968c8 <idleproc>
ffffffffc020704c:	00a93023          	sd	a0,0(s2)
ffffffffc0207050:	842a                	mv	s0,a0
ffffffffc0207052:	12050863          	beqz	a0,ffffffffc0207182 <proc_init+0x174>
ffffffffc0207056:	4789                	li	a5,2
ffffffffc0207058:	e11c                	sd	a5,0(a0)
ffffffffc020705a:	0000a797          	auipc	a5,0xa
ffffffffc020705e:	fa678793          	addi	a5,a5,-90 # ffffffffc0211000 <bootstack>
ffffffffc0207062:	e91c                	sd	a5,16(a0)
ffffffffc0207064:	4785                	li	a5,1
ffffffffc0207066:	ed1c                	sd	a5,24(a0)
ffffffffc0207068:	817fe0ef          	jal	ra,ffffffffc020587e <files_create>
ffffffffc020706c:	14a43423          	sd	a0,328(s0)
ffffffffc0207070:	0e050d63          	beqz	a0,ffffffffc020716a <proc_init+0x15c>
ffffffffc0207074:	00093403          	ld	s0,0(s2)
ffffffffc0207078:	4641                	li	a2,16
ffffffffc020707a:	4581                	li	a1,0
ffffffffc020707c:	14843703          	ld	a4,328(s0)
ffffffffc0207080:	0b440413          	addi	s0,s0,180
ffffffffc0207084:	8522                	mv	a0,s0
ffffffffc0207086:	4b1c                	lw	a5,16(a4)
ffffffffc0207088:	2785                	addiw	a5,a5,1
ffffffffc020708a:	cb1c                	sw	a5,16(a4)
ffffffffc020708c:	192040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0207090:	463d                	li	a2,15
ffffffffc0207092:	00007597          	auipc	a1,0x7
ffffffffc0207096:	94658593          	addi	a1,a1,-1722 # ffffffffc020d9d8 <CSWTCH.79+0x3d0>
ffffffffc020709a:	8522                	mv	a0,s0
ffffffffc020709c:	1d4040ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc02070a0:	00090717          	auipc	a4,0x90
ffffffffc02070a4:	83870713          	addi	a4,a4,-1992 # ffffffffc02968d8 <nr_process>
ffffffffc02070a8:	431c                	lw	a5,0(a4)
ffffffffc02070aa:	00093683          	ld	a3,0(s2)
ffffffffc02070ae:	4601                	li	a2,0
ffffffffc02070b0:	2785                	addiw	a5,a5,1
ffffffffc02070b2:	4581                	li	a1,0
ffffffffc02070b4:	fffff517          	auipc	a0,0xfffff
ffffffffc02070b8:	35a50513          	addi	a0,a0,858 # ffffffffc020640e <init_main>
ffffffffc02070bc:	c31c                	sw	a5,0(a4)
ffffffffc02070be:	00090797          	auipc	a5,0x90
ffffffffc02070c2:	80d7b123          	sd	a3,-2046(a5) # ffffffffc02968c0 <current>
ffffffffc02070c6:	fc5fe0ef          	jal	ra,ffffffffc020608a <kernel_thread>
ffffffffc02070ca:	842a                	mv	s0,a0
ffffffffc02070cc:	08a05363          	blez	a0,ffffffffc0207152 <proc_init+0x144>
ffffffffc02070d0:	6789                	lui	a5,0x2
ffffffffc02070d2:	fff5071b          	addiw	a4,a0,-1
ffffffffc02070d6:	17f9                	addi	a5,a5,-2
ffffffffc02070d8:	2501                	sext.w	a0,a0
ffffffffc02070da:	02e7e363          	bltu	a5,a4,ffffffffc0207100 <proc_init+0xf2>
ffffffffc02070de:	45a9                	li	a1,10
ffffffffc02070e0:	624040ef          	jal	ra,ffffffffc020b704 <hash32>
ffffffffc02070e4:	02051793          	slli	a5,a0,0x20
ffffffffc02070e8:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02070ec:	96a6                	add	a3,a3,s1
ffffffffc02070ee:	87b6                	mv	a5,a3
ffffffffc02070f0:	a029                	j	ffffffffc02070fa <proc_init+0xec>
ffffffffc02070f2:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc02070f6:	04870b63          	beq	a4,s0,ffffffffc020714c <proc_init+0x13e>
ffffffffc02070fa:	679c                	ld	a5,8(a5)
ffffffffc02070fc:	fef69be3          	bne	a3,a5,ffffffffc02070f2 <proc_init+0xe4>
ffffffffc0207100:	4781                	li	a5,0
ffffffffc0207102:	0b478493          	addi	s1,a5,180
ffffffffc0207106:	4641                	li	a2,16
ffffffffc0207108:	4581                	li	a1,0
ffffffffc020710a:	0008f417          	auipc	s0,0x8f
ffffffffc020710e:	7c640413          	addi	s0,s0,1990 # ffffffffc02968d0 <initproc>
ffffffffc0207112:	8526                	mv	a0,s1
ffffffffc0207114:	e01c                	sd	a5,0(s0)
ffffffffc0207116:	108040ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc020711a:	463d                	li	a2,15
ffffffffc020711c:	00007597          	auipc	a1,0x7
ffffffffc0207120:	8e458593          	addi	a1,a1,-1820 # ffffffffc020da00 <CSWTCH.79+0x3f8>
ffffffffc0207124:	8526                	mv	a0,s1
ffffffffc0207126:	14a040ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc020712a:	00093783          	ld	a5,0(s2)
ffffffffc020712e:	c7d1                	beqz	a5,ffffffffc02071ba <proc_init+0x1ac>
ffffffffc0207130:	43dc                	lw	a5,4(a5)
ffffffffc0207132:	e7c1                	bnez	a5,ffffffffc02071ba <proc_init+0x1ac>
ffffffffc0207134:	601c                	ld	a5,0(s0)
ffffffffc0207136:	c3b5                	beqz	a5,ffffffffc020719a <proc_init+0x18c>
ffffffffc0207138:	43d8                	lw	a4,4(a5)
ffffffffc020713a:	4785                	li	a5,1
ffffffffc020713c:	04f71f63          	bne	a4,a5,ffffffffc020719a <proc_init+0x18c>
ffffffffc0207140:	60e2                	ld	ra,24(sp)
ffffffffc0207142:	6442                	ld	s0,16(sp)
ffffffffc0207144:	64a2                	ld	s1,8(sp)
ffffffffc0207146:	6902                	ld	s2,0(sp)
ffffffffc0207148:	6105                	addi	sp,sp,32
ffffffffc020714a:	8082                	ret
ffffffffc020714c:	f2878793          	addi	a5,a5,-216
ffffffffc0207150:	bf4d                	j	ffffffffc0207102 <proc_init+0xf4>
ffffffffc0207152:	00007617          	auipc	a2,0x7
ffffffffc0207156:	88e60613          	addi	a2,a2,-1906 # ffffffffc020d9e0 <CSWTCH.79+0x3d8>
ffffffffc020715a:	52100593          	li	a1,1313
ffffffffc020715e:	00006517          	auipc	a0,0x6
ffffffffc0207162:	57250513          	addi	a0,a0,1394 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0207166:	8c8f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020716a:	00007617          	auipc	a2,0x7
ffffffffc020716e:	84660613          	addi	a2,a2,-1978 # ffffffffc020d9b0 <CSWTCH.79+0x3a8>
ffffffffc0207172:	51500593          	li	a1,1301
ffffffffc0207176:	00006517          	auipc	a0,0x6
ffffffffc020717a:	55a50513          	addi	a0,a0,1370 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc020717e:	8b0f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207182:	00007617          	auipc	a2,0x7
ffffffffc0207186:	81660613          	addi	a2,a2,-2026 # ffffffffc020d998 <CSWTCH.79+0x390>
ffffffffc020718a:	50b00593          	li	a1,1291
ffffffffc020718e:	00006517          	auipc	a0,0x6
ffffffffc0207192:	54250513          	addi	a0,a0,1346 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc0207196:	898f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020719a:	00007697          	auipc	a3,0x7
ffffffffc020719e:	89668693          	addi	a3,a3,-1898 # ffffffffc020da30 <CSWTCH.79+0x428>
ffffffffc02071a2:	00005617          	auipc	a2,0x5
ffffffffc02071a6:	a7660613          	addi	a2,a2,-1418 # ffffffffc020bc18 <commands+0x250>
ffffffffc02071aa:	52800593          	li	a1,1320
ffffffffc02071ae:	00006517          	auipc	a0,0x6
ffffffffc02071b2:	52250513          	addi	a0,a0,1314 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02071b6:	878f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02071ba:	00007697          	auipc	a3,0x7
ffffffffc02071be:	84e68693          	addi	a3,a3,-1970 # ffffffffc020da08 <CSWTCH.79+0x400>
ffffffffc02071c2:	00005617          	auipc	a2,0x5
ffffffffc02071c6:	a5660613          	addi	a2,a2,-1450 # ffffffffc020bc18 <commands+0x250>
ffffffffc02071ca:	52700593          	li	a1,1319
ffffffffc02071ce:	00006517          	auipc	a0,0x6
ffffffffc02071d2:	50250513          	addi	a0,a0,1282 # ffffffffc020d6d0 <CSWTCH.79+0xc8>
ffffffffc02071d6:	858f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02071da <cpu_idle>:
ffffffffc02071da:	1141                	addi	sp,sp,-16
ffffffffc02071dc:	e022                	sd	s0,0(sp)
ffffffffc02071de:	e406                	sd	ra,8(sp)
ffffffffc02071e0:	0008f417          	auipc	s0,0x8f
ffffffffc02071e4:	6e040413          	addi	s0,s0,1760 # ffffffffc02968c0 <current>
ffffffffc02071e8:	6018                	ld	a4,0(s0)
ffffffffc02071ea:	6f1c                	ld	a5,24(a4)
ffffffffc02071ec:	dffd                	beqz	a5,ffffffffc02071ea <cpu_idle+0x10>
ffffffffc02071ee:	1c8000ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc02071f2:	bfdd                	j	ffffffffc02071e8 <cpu_idle+0xe>

ffffffffc02071f4 <lab6_set_priority>:
ffffffffc02071f4:	1141                	addi	sp,sp,-16
ffffffffc02071f6:	e022                	sd	s0,0(sp)
ffffffffc02071f8:	85aa                	mv	a1,a0
ffffffffc02071fa:	842a                	mv	s0,a0
ffffffffc02071fc:	00007517          	auipc	a0,0x7
ffffffffc0207200:	85c50513          	addi	a0,a0,-1956 # ffffffffc020da58 <CSWTCH.79+0x450>
ffffffffc0207204:	e406                	sd	ra,8(sp)
ffffffffc0207206:	f25f80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020720a:	0008f797          	auipc	a5,0x8f
ffffffffc020720e:	6b67b783          	ld	a5,1718(a5) # ffffffffc02968c0 <current>
ffffffffc0207212:	e801                	bnez	s0,ffffffffc0207222 <lab6_set_priority+0x2e>
ffffffffc0207214:	60a2                	ld	ra,8(sp)
ffffffffc0207216:	6402                	ld	s0,0(sp)
ffffffffc0207218:	4705                	li	a4,1
ffffffffc020721a:	14e7a223          	sw	a4,324(a5)
ffffffffc020721e:	0141                	addi	sp,sp,16
ffffffffc0207220:	8082                	ret
ffffffffc0207222:	60a2                	ld	ra,8(sp)
ffffffffc0207224:	1487a223          	sw	s0,324(a5)
ffffffffc0207228:	6402                	ld	s0,0(sp)
ffffffffc020722a:	0141                	addi	sp,sp,16
ffffffffc020722c:	8082                	ret

ffffffffc020722e <do_sleep>:
ffffffffc020722e:	c539                	beqz	a0,ffffffffc020727c <do_sleep+0x4e>
ffffffffc0207230:	7179                	addi	sp,sp,-48
ffffffffc0207232:	f022                	sd	s0,32(sp)
ffffffffc0207234:	f406                	sd	ra,40(sp)
ffffffffc0207236:	842a                	mv	s0,a0
ffffffffc0207238:	100027f3          	csrr	a5,sstatus
ffffffffc020723c:	8b89                	andi	a5,a5,2
ffffffffc020723e:	e3a9                	bnez	a5,ffffffffc0207280 <do_sleep+0x52>
ffffffffc0207240:	0008f797          	auipc	a5,0x8f
ffffffffc0207244:	6807b783          	ld	a5,1664(a5) # ffffffffc02968c0 <current>
ffffffffc0207248:	0818                	addi	a4,sp,16
ffffffffc020724a:	c02a                	sw	a0,0(sp)
ffffffffc020724c:	ec3a                	sd	a4,24(sp)
ffffffffc020724e:	e83a                	sd	a4,16(sp)
ffffffffc0207250:	e43e                	sd	a5,8(sp)
ffffffffc0207252:	4705                	li	a4,1
ffffffffc0207254:	c398                	sw	a4,0(a5)
ffffffffc0207256:	80000737          	lui	a4,0x80000
ffffffffc020725a:	840a                	mv	s0,sp
ffffffffc020725c:	0709                	addi	a4,a4,2
ffffffffc020725e:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207262:	8522                	mv	a0,s0
ffffffffc0207264:	212000ef          	jal	ra,ffffffffc0207476 <add_timer>
ffffffffc0207268:	14e000ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc020726c:	8522                	mv	a0,s0
ffffffffc020726e:	2d0000ef          	jal	ra,ffffffffc020753e <del_timer>
ffffffffc0207272:	70a2                	ld	ra,40(sp)
ffffffffc0207274:	7402                	ld	s0,32(sp)
ffffffffc0207276:	4501                	li	a0,0
ffffffffc0207278:	6145                	addi	sp,sp,48
ffffffffc020727a:	8082                	ret
ffffffffc020727c:	4501                	li	a0,0
ffffffffc020727e:	8082                	ret
ffffffffc0207280:	b21f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0207284:	0008f797          	auipc	a5,0x8f
ffffffffc0207288:	63c7b783          	ld	a5,1596(a5) # ffffffffc02968c0 <current>
ffffffffc020728c:	0818                	addi	a4,sp,16
ffffffffc020728e:	c022                	sw	s0,0(sp)
ffffffffc0207290:	e43e                	sd	a5,8(sp)
ffffffffc0207292:	ec3a                	sd	a4,24(sp)
ffffffffc0207294:	e83a                	sd	a4,16(sp)
ffffffffc0207296:	4705                	li	a4,1
ffffffffc0207298:	c398                	sw	a4,0(a5)
ffffffffc020729a:	80000737          	lui	a4,0x80000
ffffffffc020729e:	0709                	addi	a4,a4,2
ffffffffc02072a0:	840a                	mv	s0,sp
ffffffffc02072a2:	8522                	mv	a0,s0
ffffffffc02072a4:	0ee7a623          	sw	a4,236(a5)
ffffffffc02072a8:	1ce000ef          	jal	ra,ffffffffc0207476 <add_timer>
ffffffffc02072ac:	aeff90ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02072b0:	bf65                	j	ffffffffc0207268 <do_sleep+0x3a>

ffffffffc02072b2 <sched_init>:
ffffffffc02072b2:	1141                	addi	sp,sp,-16
ffffffffc02072b4:	0008a717          	auipc	a4,0x8a
ffffffffc02072b8:	d6c70713          	addi	a4,a4,-660 # ffffffffc0291020 <default_sched_class>
ffffffffc02072bc:	e022                	sd	s0,0(sp)
ffffffffc02072be:	e406                	sd	ra,8(sp)
ffffffffc02072c0:	0008e797          	auipc	a5,0x8e
ffffffffc02072c4:	53078793          	addi	a5,a5,1328 # ffffffffc02957f0 <timer_list>
ffffffffc02072c8:	6714                	ld	a3,8(a4)
ffffffffc02072ca:	0008e517          	auipc	a0,0x8e
ffffffffc02072ce:	50650513          	addi	a0,a0,1286 # ffffffffc02957d0 <__rq>
ffffffffc02072d2:	e79c                	sd	a5,8(a5)
ffffffffc02072d4:	e39c                	sd	a5,0(a5)
ffffffffc02072d6:	4795                	li	a5,5
ffffffffc02072d8:	c95c                	sw	a5,20(a0)
ffffffffc02072da:	0008f417          	auipc	s0,0x8f
ffffffffc02072de:	60e40413          	addi	s0,s0,1550 # ffffffffc02968e8 <sched_class>
ffffffffc02072e2:	0008f797          	auipc	a5,0x8f
ffffffffc02072e6:	5ea7bf23          	sd	a0,1534(a5) # ffffffffc02968e0 <rq>
ffffffffc02072ea:	e018                	sd	a4,0(s0)
ffffffffc02072ec:	9682                	jalr	a3
ffffffffc02072ee:	601c                	ld	a5,0(s0)
ffffffffc02072f0:	6402                	ld	s0,0(sp)
ffffffffc02072f2:	60a2                	ld	ra,8(sp)
ffffffffc02072f4:	638c                	ld	a1,0(a5)
ffffffffc02072f6:	00006517          	auipc	a0,0x6
ffffffffc02072fa:	77a50513          	addi	a0,a0,1914 # ffffffffc020da70 <CSWTCH.79+0x468>
ffffffffc02072fe:	0141                	addi	sp,sp,16
ffffffffc0207300:	e2bf806f          	j	ffffffffc020012a <cprintf>

ffffffffc0207304 <wakeup_proc>:
ffffffffc0207304:	4118                	lw	a4,0(a0)
ffffffffc0207306:	1101                	addi	sp,sp,-32
ffffffffc0207308:	ec06                	sd	ra,24(sp)
ffffffffc020730a:	e822                	sd	s0,16(sp)
ffffffffc020730c:	e426                	sd	s1,8(sp)
ffffffffc020730e:	478d                	li	a5,3
ffffffffc0207310:	08f70363          	beq	a4,a5,ffffffffc0207396 <wakeup_proc+0x92>
ffffffffc0207314:	842a                	mv	s0,a0
ffffffffc0207316:	100027f3          	csrr	a5,sstatus
ffffffffc020731a:	8b89                	andi	a5,a5,2
ffffffffc020731c:	4481                	li	s1,0
ffffffffc020731e:	e7bd                	bnez	a5,ffffffffc020738c <wakeup_proc+0x88>
ffffffffc0207320:	4789                	li	a5,2
ffffffffc0207322:	04f70863          	beq	a4,a5,ffffffffc0207372 <wakeup_proc+0x6e>
ffffffffc0207326:	c01c                	sw	a5,0(s0)
ffffffffc0207328:	0e042623          	sw	zero,236(s0)
ffffffffc020732c:	0008f797          	auipc	a5,0x8f
ffffffffc0207330:	5947b783          	ld	a5,1428(a5) # ffffffffc02968c0 <current>
ffffffffc0207334:	02878363          	beq	a5,s0,ffffffffc020735a <wakeup_proc+0x56>
ffffffffc0207338:	0008f797          	auipc	a5,0x8f
ffffffffc020733c:	5907b783          	ld	a5,1424(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0207340:	00f40d63          	beq	s0,a5,ffffffffc020735a <wakeup_proc+0x56>
ffffffffc0207344:	0008f797          	auipc	a5,0x8f
ffffffffc0207348:	5a47b783          	ld	a5,1444(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020734c:	6b9c                	ld	a5,16(a5)
ffffffffc020734e:	85a2                	mv	a1,s0
ffffffffc0207350:	0008f517          	auipc	a0,0x8f
ffffffffc0207354:	59053503          	ld	a0,1424(a0) # ffffffffc02968e0 <rq>
ffffffffc0207358:	9782                	jalr	a5
ffffffffc020735a:	e491                	bnez	s1,ffffffffc0207366 <wakeup_proc+0x62>
ffffffffc020735c:	60e2                	ld	ra,24(sp)
ffffffffc020735e:	6442                	ld	s0,16(sp)
ffffffffc0207360:	64a2                	ld	s1,8(sp)
ffffffffc0207362:	6105                	addi	sp,sp,32
ffffffffc0207364:	8082                	ret
ffffffffc0207366:	6442                	ld	s0,16(sp)
ffffffffc0207368:	60e2                	ld	ra,24(sp)
ffffffffc020736a:	64a2                	ld	s1,8(sp)
ffffffffc020736c:	6105                	addi	sp,sp,32
ffffffffc020736e:	a2df906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc0207372:	00006617          	auipc	a2,0x6
ffffffffc0207376:	74e60613          	addi	a2,a2,1870 # ffffffffc020dac0 <CSWTCH.79+0x4b8>
ffffffffc020737a:	05200593          	li	a1,82
ffffffffc020737e:	00006517          	auipc	a0,0x6
ffffffffc0207382:	72a50513          	addi	a0,a0,1834 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc0207386:	f11f80ef          	jal	ra,ffffffffc0200296 <__warn>
ffffffffc020738a:	bfc1                	j	ffffffffc020735a <wakeup_proc+0x56>
ffffffffc020738c:	a15f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0207390:	4018                	lw	a4,0(s0)
ffffffffc0207392:	4485                	li	s1,1
ffffffffc0207394:	b771                	j	ffffffffc0207320 <wakeup_proc+0x1c>
ffffffffc0207396:	00006697          	auipc	a3,0x6
ffffffffc020739a:	6f268693          	addi	a3,a3,1778 # ffffffffc020da88 <CSWTCH.79+0x480>
ffffffffc020739e:	00005617          	auipc	a2,0x5
ffffffffc02073a2:	87a60613          	addi	a2,a2,-1926 # ffffffffc020bc18 <commands+0x250>
ffffffffc02073a6:	04300593          	li	a1,67
ffffffffc02073aa:	00006517          	auipc	a0,0x6
ffffffffc02073ae:	6fe50513          	addi	a0,a0,1790 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc02073b2:	e7df80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02073b6 <schedule>:
ffffffffc02073b6:	7179                	addi	sp,sp,-48
ffffffffc02073b8:	f406                	sd	ra,40(sp)
ffffffffc02073ba:	f022                	sd	s0,32(sp)
ffffffffc02073bc:	ec26                	sd	s1,24(sp)
ffffffffc02073be:	e84a                	sd	s2,16(sp)
ffffffffc02073c0:	e44e                	sd	s3,8(sp)
ffffffffc02073c2:	e052                	sd	s4,0(sp)
ffffffffc02073c4:	100027f3          	csrr	a5,sstatus
ffffffffc02073c8:	8b89                	andi	a5,a5,2
ffffffffc02073ca:	4a01                	li	s4,0
ffffffffc02073cc:	e3cd                	bnez	a5,ffffffffc020746e <schedule+0xb8>
ffffffffc02073ce:	0008f497          	auipc	s1,0x8f
ffffffffc02073d2:	4f248493          	addi	s1,s1,1266 # ffffffffc02968c0 <current>
ffffffffc02073d6:	608c                	ld	a1,0(s1)
ffffffffc02073d8:	0008f997          	auipc	s3,0x8f
ffffffffc02073dc:	51098993          	addi	s3,s3,1296 # ffffffffc02968e8 <sched_class>
ffffffffc02073e0:	0008f917          	auipc	s2,0x8f
ffffffffc02073e4:	50090913          	addi	s2,s2,1280 # ffffffffc02968e0 <rq>
ffffffffc02073e8:	4194                	lw	a3,0(a1)
ffffffffc02073ea:	0005bc23          	sd	zero,24(a1)
ffffffffc02073ee:	4709                	li	a4,2
ffffffffc02073f0:	0009b783          	ld	a5,0(s3)
ffffffffc02073f4:	00093503          	ld	a0,0(s2)
ffffffffc02073f8:	04e68e63          	beq	a3,a4,ffffffffc0207454 <schedule+0x9e>
ffffffffc02073fc:	739c                	ld	a5,32(a5)
ffffffffc02073fe:	9782                	jalr	a5
ffffffffc0207400:	842a                	mv	s0,a0
ffffffffc0207402:	c521                	beqz	a0,ffffffffc020744a <schedule+0x94>
ffffffffc0207404:	0009b783          	ld	a5,0(s3)
ffffffffc0207408:	00093503          	ld	a0,0(s2)
ffffffffc020740c:	85a2                	mv	a1,s0
ffffffffc020740e:	6f9c                	ld	a5,24(a5)
ffffffffc0207410:	9782                	jalr	a5
ffffffffc0207412:	441c                	lw	a5,8(s0)
ffffffffc0207414:	6098                	ld	a4,0(s1)
ffffffffc0207416:	2785                	addiw	a5,a5,1
ffffffffc0207418:	c41c                	sw	a5,8(s0)
ffffffffc020741a:	00870563          	beq	a4,s0,ffffffffc0207424 <schedule+0x6e>
ffffffffc020741e:	8522                	mv	a0,s0
ffffffffc0207420:	fdefe0ef          	jal	ra,ffffffffc0205bfe <proc_run>
ffffffffc0207424:	000a1a63          	bnez	s4,ffffffffc0207438 <schedule+0x82>
ffffffffc0207428:	70a2                	ld	ra,40(sp)
ffffffffc020742a:	7402                	ld	s0,32(sp)
ffffffffc020742c:	64e2                	ld	s1,24(sp)
ffffffffc020742e:	6942                	ld	s2,16(sp)
ffffffffc0207430:	69a2                	ld	s3,8(sp)
ffffffffc0207432:	6a02                	ld	s4,0(sp)
ffffffffc0207434:	6145                	addi	sp,sp,48
ffffffffc0207436:	8082                	ret
ffffffffc0207438:	7402                	ld	s0,32(sp)
ffffffffc020743a:	70a2                	ld	ra,40(sp)
ffffffffc020743c:	64e2                	ld	s1,24(sp)
ffffffffc020743e:	6942                	ld	s2,16(sp)
ffffffffc0207440:	69a2                	ld	s3,8(sp)
ffffffffc0207442:	6a02                	ld	s4,0(sp)
ffffffffc0207444:	6145                	addi	sp,sp,48
ffffffffc0207446:	955f906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc020744a:	0008f417          	auipc	s0,0x8f
ffffffffc020744e:	47e43403          	ld	s0,1150(s0) # ffffffffc02968c8 <idleproc>
ffffffffc0207452:	b7c1                	j	ffffffffc0207412 <schedule+0x5c>
ffffffffc0207454:	0008f717          	auipc	a4,0x8f
ffffffffc0207458:	47473703          	ld	a4,1140(a4) # ffffffffc02968c8 <idleproc>
ffffffffc020745c:	fae580e3          	beq	a1,a4,ffffffffc02073fc <schedule+0x46>
ffffffffc0207460:	6b9c                	ld	a5,16(a5)
ffffffffc0207462:	9782                	jalr	a5
ffffffffc0207464:	0009b783          	ld	a5,0(s3)
ffffffffc0207468:	00093503          	ld	a0,0(s2)
ffffffffc020746c:	bf41                	j	ffffffffc02073fc <schedule+0x46>
ffffffffc020746e:	933f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc0207472:	4a05                	li	s4,1
ffffffffc0207474:	bfa9                	j	ffffffffc02073ce <schedule+0x18>

ffffffffc0207476 <add_timer>:
ffffffffc0207476:	1141                	addi	sp,sp,-16
ffffffffc0207478:	e022                	sd	s0,0(sp)
ffffffffc020747a:	e406                	sd	ra,8(sp)
ffffffffc020747c:	842a                	mv	s0,a0
ffffffffc020747e:	100027f3          	csrr	a5,sstatus
ffffffffc0207482:	8b89                	andi	a5,a5,2
ffffffffc0207484:	4501                	li	a0,0
ffffffffc0207486:	eba5                	bnez	a5,ffffffffc02074f6 <add_timer+0x80>
ffffffffc0207488:	401c                	lw	a5,0(s0)
ffffffffc020748a:	cbb5                	beqz	a5,ffffffffc02074fe <add_timer+0x88>
ffffffffc020748c:	6418                	ld	a4,8(s0)
ffffffffc020748e:	cb25                	beqz	a4,ffffffffc02074fe <add_timer+0x88>
ffffffffc0207490:	6c18                	ld	a4,24(s0)
ffffffffc0207492:	01040593          	addi	a1,s0,16
ffffffffc0207496:	08e59463          	bne	a1,a4,ffffffffc020751e <add_timer+0xa8>
ffffffffc020749a:	0008e617          	auipc	a2,0x8e
ffffffffc020749e:	35660613          	addi	a2,a2,854 # ffffffffc02957f0 <timer_list>
ffffffffc02074a2:	6618                	ld	a4,8(a2)
ffffffffc02074a4:	00c71863          	bne	a4,a2,ffffffffc02074b4 <add_timer+0x3e>
ffffffffc02074a8:	a80d                	j	ffffffffc02074da <add_timer+0x64>
ffffffffc02074aa:	6718                	ld	a4,8(a4)
ffffffffc02074ac:	9f95                	subw	a5,a5,a3
ffffffffc02074ae:	c01c                	sw	a5,0(s0)
ffffffffc02074b0:	02c70563          	beq	a4,a2,ffffffffc02074da <add_timer+0x64>
ffffffffc02074b4:	ff072683          	lw	a3,-16(a4)
ffffffffc02074b8:	fed7f9e3          	bgeu	a5,a3,ffffffffc02074aa <add_timer+0x34>
ffffffffc02074bc:	40f687bb          	subw	a5,a3,a5
ffffffffc02074c0:	fef72823          	sw	a5,-16(a4)
ffffffffc02074c4:	631c                	ld	a5,0(a4)
ffffffffc02074c6:	e30c                	sd	a1,0(a4)
ffffffffc02074c8:	e78c                	sd	a1,8(a5)
ffffffffc02074ca:	ec18                	sd	a4,24(s0)
ffffffffc02074cc:	e81c                	sd	a5,16(s0)
ffffffffc02074ce:	c105                	beqz	a0,ffffffffc02074ee <add_timer+0x78>
ffffffffc02074d0:	6402                	ld	s0,0(sp)
ffffffffc02074d2:	60a2                	ld	ra,8(sp)
ffffffffc02074d4:	0141                	addi	sp,sp,16
ffffffffc02074d6:	8c5f906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc02074da:	0008e717          	auipc	a4,0x8e
ffffffffc02074de:	31670713          	addi	a4,a4,790 # ffffffffc02957f0 <timer_list>
ffffffffc02074e2:	631c                	ld	a5,0(a4)
ffffffffc02074e4:	e30c                	sd	a1,0(a4)
ffffffffc02074e6:	e78c                	sd	a1,8(a5)
ffffffffc02074e8:	ec18                	sd	a4,24(s0)
ffffffffc02074ea:	e81c                	sd	a5,16(s0)
ffffffffc02074ec:	f175                	bnez	a0,ffffffffc02074d0 <add_timer+0x5a>
ffffffffc02074ee:	60a2                	ld	ra,8(sp)
ffffffffc02074f0:	6402                	ld	s0,0(sp)
ffffffffc02074f2:	0141                	addi	sp,sp,16
ffffffffc02074f4:	8082                	ret
ffffffffc02074f6:	8abf90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02074fa:	4505                	li	a0,1
ffffffffc02074fc:	b771                	j	ffffffffc0207488 <add_timer+0x12>
ffffffffc02074fe:	00006697          	auipc	a3,0x6
ffffffffc0207502:	5e268693          	addi	a3,a3,1506 # ffffffffc020dae0 <CSWTCH.79+0x4d8>
ffffffffc0207506:	00004617          	auipc	a2,0x4
ffffffffc020750a:	71260613          	addi	a2,a2,1810 # ffffffffc020bc18 <commands+0x250>
ffffffffc020750e:	07a00593          	li	a1,122
ffffffffc0207512:	00006517          	auipc	a0,0x6
ffffffffc0207516:	59650513          	addi	a0,a0,1430 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc020751a:	d15f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020751e:	00006697          	auipc	a3,0x6
ffffffffc0207522:	5f268693          	addi	a3,a3,1522 # ffffffffc020db10 <CSWTCH.79+0x508>
ffffffffc0207526:	00004617          	auipc	a2,0x4
ffffffffc020752a:	6f260613          	addi	a2,a2,1778 # ffffffffc020bc18 <commands+0x250>
ffffffffc020752e:	07b00593          	li	a1,123
ffffffffc0207532:	00006517          	auipc	a0,0x6
ffffffffc0207536:	57650513          	addi	a0,a0,1398 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc020753a:	cf5f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020753e <del_timer>:
ffffffffc020753e:	1101                	addi	sp,sp,-32
ffffffffc0207540:	e822                	sd	s0,16(sp)
ffffffffc0207542:	ec06                	sd	ra,24(sp)
ffffffffc0207544:	e426                	sd	s1,8(sp)
ffffffffc0207546:	842a                	mv	s0,a0
ffffffffc0207548:	100027f3          	csrr	a5,sstatus
ffffffffc020754c:	8b89                	andi	a5,a5,2
ffffffffc020754e:	01050493          	addi	s1,a0,16
ffffffffc0207552:	eb9d                	bnez	a5,ffffffffc0207588 <del_timer+0x4a>
ffffffffc0207554:	6d1c                	ld	a5,24(a0)
ffffffffc0207556:	02978463          	beq	a5,s1,ffffffffc020757e <del_timer+0x40>
ffffffffc020755a:	4114                	lw	a3,0(a0)
ffffffffc020755c:	6918                	ld	a4,16(a0)
ffffffffc020755e:	ce81                	beqz	a3,ffffffffc0207576 <del_timer+0x38>
ffffffffc0207560:	0008e617          	auipc	a2,0x8e
ffffffffc0207564:	29060613          	addi	a2,a2,656 # ffffffffc02957f0 <timer_list>
ffffffffc0207568:	00c78763          	beq	a5,a2,ffffffffc0207576 <del_timer+0x38>
ffffffffc020756c:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207570:	9eb1                	addw	a3,a3,a2
ffffffffc0207572:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207576:	e71c                	sd	a5,8(a4)
ffffffffc0207578:	e398                	sd	a4,0(a5)
ffffffffc020757a:	ec04                	sd	s1,24(s0)
ffffffffc020757c:	e804                	sd	s1,16(s0)
ffffffffc020757e:	60e2                	ld	ra,24(sp)
ffffffffc0207580:	6442                	ld	s0,16(sp)
ffffffffc0207582:	64a2                	ld	s1,8(sp)
ffffffffc0207584:	6105                	addi	sp,sp,32
ffffffffc0207586:	8082                	ret
ffffffffc0207588:	819f90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020758c:	6c1c                	ld	a5,24(s0)
ffffffffc020758e:	02978463          	beq	a5,s1,ffffffffc02075b6 <del_timer+0x78>
ffffffffc0207592:	4014                	lw	a3,0(s0)
ffffffffc0207594:	6818                	ld	a4,16(s0)
ffffffffc0207596:	ce81                	beqz	a3,ffffffffc02075ae <del_timer+0x70>
ffffffffc0207598:	0008e617          	auipc	a2,0x8e
ffffffffc020759c:	25860613          	addi	a2,a2,600 # ffffffffc02957f0 <timer_list>
ffffffffc02075a0:	00c78763          	beq	a5,a2,ffffffffc02075ae <del_timer+0x70>
ffffffffc02075a4:	ff07a603          	lw	a2,-16(a5)
ffffffffc02075a8:	9eb1                	addw	a3,a3,a2
ffffffffc02075aa:	fed7a823          	sw	a3,-16(a5)
ffffffffc02075ae:	e71c                	sd	a5,8(a4)
ffffffffc02075b0:	e398                	sd	a4,0(a5)
ffffffffc02075b2:	ec04                	sd	s1,24(s0)
ffffffffc02075b4:	e804                	sd	s1,16(s0)
ffffffffc02075b6:	6442                	ld	s0,16(sp)
ffffffffc02075b8:	60e2                	ld	ra,24(sp)
ffffffffc02075ba:	64a2                	ld	s1,8(sp)
ffffffffc02075bc:	6105                	addi	sp,sp,32
ffffffffc02075be:	fdcf906f          	j	ffffffffc0200d9a <intr_enable>

ffffffffc02075c2 <run_timer_list>:
ffffffffc02075c2:	7139                	addi	sp,sp,-64
ffffffffc02075c4:	fc06                	sd	ra,56(sp)
ffffffffc02075c6:	f822                	sd	s0,48(sp)
ffffffffc02075c8:	f426                	sd	s1,40(sp)
ffffffffc02075ca:	f04a                	sd	s2,32(sp)
ffffffffc02075cc:	ec4e                	sd	s3,24(sp)
ffffffffc02075ce:	e852                	sd	s4,16(sp)
ffffffffc02075d0:	e456                	sd	s5,8(sp)
ffffffffc02075d2:	e05a                	sd	s6,0(sp)
ffffffffc02075d4:	100027f3          	csrr	a5,sstatus
ffffffffc02075d8:	8b89                	andi	a5,a5,2
ffffffffc02075da:	4b01                	li	s6,0
ffffffffc02075dc:	efe9                	bnez	a5,ffffffffc02076b6 <run_timer_list+0xf4>
ffffffffc02075de:	0008e997          	auipc	s3,0x8e
ffffffffc02075e2:	21298993          	addi	s3,s3,530 # ffffffffc02957f0 <timer_list>
ffffffffc02075e6:	0089b403          	ld	s0,8(s3)
ffffffffc02075ea:	07340a63          	beq	s0,s3,ffffffffc020765e <run_timer_list+0x9c>
ffffffffc02075ee:	ff042783          	lw	a5,-16(s0)
ffffffffc02075f2:	ff040913          	addi	s2,s0,-16
ffffffffc02075f6:	0e078763          	beqz	a5,ffffffffc02076e4 <run_timer_list+0x122>
ffffffffc02075fa:	fff7871b          	addiw	a4,a5,-1
ffffffffc02075fe:	fee42823          	sw	a4,-16(s0)
ffffffffc0207602:	ef31                	bnez	a4,ffffffffc020765e <run_timer_list+0x9c>
ffffffffc0207604:	00006a97          	auipc	s5,0x6
ffffffffc0207608:	574a8a93          	addi	s5,s5,1396 # ffffffffc020db78 <CSWTCH.79+0x570>
ffffffffc020760c:	00006a17          	auipc	s4,0x6
ffffffffc0207610:	49ca0a13          	addi	s4,s4,1180 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc0207614:	a005                	j	ffffffffc0207634 <run_timer_list+0x72>
ffffffffc0207616:	0a07d763          	bgez	a5,ffffffffc02076c4 <run_timer_list+0x102>
ffffffffc020761a:	8526                	mv	a0,s1
ffffffffc020761c:	ce9ff0ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc0207620:	854a                	mv	a0,s2
ffffffffc0207622:	f1dff0ef          	jal	ra,ffffffffc020753e <del_timer>
ffffffffc0207626:	03340c63          	beq	s0,s3,ffffffffc020765e <run_timer_list+0x9c>
ffffffffc020762a:	ff042783          	lw	a5,-16(s0)
ffffffffc020762e:	ff040913          	addi	s2,s0,-16
ffffffffc0207632:	e795                	bnez	a5,ffffffffc020765e <run_timer_list+0x9c>
ffffffffc0207634:	00893483          	ld	s1,8(s2)
ffffffffc0207638:	6400                	ld	s0,8(s0)
ffffffffc020763a:	0ec4a783          	lw	a5,236(s1)
ffffffffc020763e:	ffe1                	bnez	a5,ffffffffc0207616 <run_timer_list+0x54>
ffffffffc0207640:	40d4                	lw	a3,4(s1)
ffffffffc0207642:	8656                	mv	a2,s5
ffffffffc0207644:	0ba00593          	li	a1,186
ffffffffc0207648:	8552                	mv	a0,s4
ffffffffc020764a:	c4df80ef          	jal	ra,ffffffffc0200296 <__warn>
ffffffffc020764e:	8526                	mv	a0,s1
ffffffffc0207650:	cb5ff0ef          	jal	ra,ffffffffc0207304 <wakeup_proc>
ffffffffc0207654:	854a                	mv	a0,s2
ffffffffc0207656:	ee9ff0ef          	jal	ra,ffffffffc020753e <del_timer>
ffffffffc020765a:	fd3418e3          	bne	s0,s3,ffffffffc020762a <run_timer_list+0x68>
ffffffffc020765e:	0008f597          	auipc	a1,0x8f
ffffffffc0207662:	2625b583          	ld	a1,610(a1) # ffffffffc02968c0 <current>
ffffffffc0207666:	c18d                	beqz	a1,ffffffffc0207688 <run_timer_list+0xc6>
ffffffffc0207668:	0008f797          	auipc	a5,0x8f
ffffffffc020766c:	2607b783          	ld	a5,608(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0207670:	04f58763          	beq	a1,a5,ffffffffc02076be <run_timer_list+0xfc>
ffffffffc0207674:	0008f797          	auipc	a5,0x8f
ffffffffc0207678:	2747b783          	ld	a5,628(a5) # ffffffffc02968e8 <sched_class>
ffffffffc020767c:	779c                	ld	a5,40(a5)
ffffffffc020767e:	0008f517          	auipc	a0,0x8f
ffffffffc0207682:	26253503          	ld	a0,610(a0) # ffffffffc02968e0 <rq>
ffffffffc0207686:	9782                	jalr	a5
ffffffffc0207688:	000b1c63          	bnez	s6,ffffffffc02076a0 <run_timer_list+0xde>
ffffffffc020768c:	70e2                	ld	ra,56(sp)
ffffffffc020768e:	7442                	ld	s0,48(sp)
ffffffffc0207690:	74a2                	ld	s1,40(sp)
ffffffffc0207692:	7902                	ld	s2,32(sp)
ffffffffc0207694:	69e2                	ld	s3,24(sp)
ffffffffc0207696:	6a42                	ld	s4,16(sp)
ffffffffc0207698:	6aa2                	ld	s5,8(sp)
ffffffffc020769a:	6b02                	ld	s6,0(sp)
ffffffffc020769c:	6121                	addi	sp,sp,64
ffffffffc020769e:	8082                	ret
ffffffffc02076a0:	7442                	ld	s0,48(sp)
ffffffffc02076a2:	70e2                	ld	ra,56(sp)
ffffffffc02076a4:	74a2                	ld	s1,40(sp)
ffffffffc02076a6:	7902                	ld	s2,32(sp)
ffffffffc02076a8:	69e2                	ld	s3,24(sp)
ffffffffc02076aa:	6a42                	ld	s4,16(sp)
ffffffffc02076ac:	6aa2                	ld	s5,8(sp)
ffffffffc02076ae:	6b02                	ld	s6,0(sp)
ffffffffc02076b0:	6121                	addi	sp,sp,64
ffffffffc02076b2:	ee8f906f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc02076b6:	eeaf90ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02076ba:	4b05                	li	s6,1
ffffffffc02076bc:	b70d                	j	ffffffffc02075de <run_timer_list+0x1c>
ffffffffc02076be:	4785                	li	a5,1
ffffffffc02076c0:	ed9c                	sd	a5,24(a1)
ffffffffc02076c2:	b7d9                	j	ffffffffc0207688 <run_timer_list+0xc6>
ffffffffc02076c4:	00006697          	auipc	a3,0x6
ffffffffc02076c8:	48c68693          	addi	a3,a3,1164 # ffffffffc020db50 <CSWTCH.79+0x548>
ffffffffc02076cc:	00004617          	auipc	a2,0x4
ffffffffc02076d0:	54c60613          	addi	a2,a2,1356 # ffffffffc020bc18 <commands+0x250>
ffffffffc02076d4:	0b600593          	li	a1,182
ffffffffc02076d8:	00006517          	auipc	a0,0x6
ffffffffc02076dc:	3d050513          	addi	a0,a0,976 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc02076e0:	b4ff80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02076e4:	00006697          	auipc	a3,0x6
ffffffffc02076e8:	45468693          	addi	a3,a3,1108 # ffffffffc020db38 <CSWTCH.79+0x530>
ffffffffc02076ec:	00004617          	auipc	a2,0x4
ffffffffc02076f0:	52c60613          	addi	a2,a2,1324 # ffffffffc020bc18 <commands+0x250>
ffffffffc02076f4:	0ae00593          	li	a1,174
ffffffffc02076f8:	00006517          	auipc	a0,0x6
ffffffffc02076fc:	3b050513          	addi	a0,a0,944 # ffffffffc020daa8 <CSWTCH.79+0x4a0>
ffffffffc0207700:	b2ff80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207704 <RR_init>:
ffffffffc0207704:	e508                	sd	a0,8(a0)
ffffffffc0207706:	e108                	sd	a0,0(a0)
ffffffffc0207708:	00052823          	sw	zero,16(a0)
ffffffffc020770c:	8082                	ret

ffffffffc020770e <RR_pick_next>:
ffffffffc020770e:	651c                	ld	a5,8(a0)
ffffffffc0207710:	00f50563          	beq	a0,a5,ffffffffc020771a <RR_pick_next+0xc>
ffffffffc0207714:	ef078513          	addi	a0,a5,-272
ffffffffc0207718:	8082                	ret
ffffffffc020771a:	4501                	li	a0,0
ffffffffc020771c:	8082                	ret

ffffffffc020771e <RR_proc_tick>:
ffffffffc020771e:	1205a783          	lw	a5,288(a1)
ffffffffc0207722:	00f05563          	blez	a5,ffffffffc020772c <RR_proc_tick+0xe>
ffffffffc0207726:	37fd                	addiw	a5,a5,-1
ffffffffc0207728:	12f5a023          	sw	a5,288(a1)
ffffffffc020772c:	e399                	bnez	a5,ffffffffc0207732 <RR_proc_tick+0x14>
ffffffffc020772e:	4785                	li	a5,1
ffffffffc0207730:	ed9c                	sd	a5,24(a1)
ffffffffc0207732:	8082                	ret

ffffffffc0207734 <RR_dequeue>:
ffffffffc0207734:	1185b703          	ld	a4,280(a1)
ffffffffc0207738:	11058793          	addi	a5,a1,272
ffffffffc020773c:	02e78363          	beq	a5,a4,ffffffffc0207762 <RR_dequeue+0x2e>
ffffffffc0207740:	1085b683          	ld	a3,264(a1)
ffffffffc0207744:	00a69f63          	bne	a3,a0,ffffffffc0207762 <RR_dequeue+0x2e>
ffffffffc0207748:	1105b503          	ld	a0,272(a1)
ffffffffc020774c:	4a90                	lw	a2,16(a3)
ffffffffc020774e:	e518                	sd	a4,8(a0)
ffffffffc0207750:	e308                	sd	a0,0(a4)
ffffffffc0207752:	10f5bc23          	sd	a5,280(a1)
ffffffffc0207756:	10f5b823          	sd	a5,272(a1)
ffffffffc020775a:	fff6079b          	addiw	a5,a2,-1
ffffffffc020775e:	ca9c                	sw	a5,16(a3)
ffffffffc0207760:	8082                	ret
ffffffffc0207762:	1141                	addi	sp,sp,-16
ffffffffc0207764:	00006697          	auipc	a3,0x6
ffffffffc0207768:	43468693          	addi	a3,a3,1076 # ffffffffc020db98 <CSWTCH.79+0x590>
ffffffffc020776c:	00004617          	auipc	a2,0x4
ffffffffc0207770:	4ac60613          	addi	a2,a2,1196 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207774:	03c00593          	li	a1,60
ffffffffc0207778:	00006517          	auipc	a0,0x6
ffffffffc020777c:	45850513          	addi	a0,a0,1112 # ffffffffc020dbd0 <CSWTCH.79+0x5c8>
ffffffffc0207780:	e406                	sd	ra,8(sp)
ffffffffc0207782:	aadf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207786 <RR_enqueue>:
ffffffffc0207786:	1185b703          	ld	a4,280(a1)
ffffffffc020778a:	11058793          	addi	a5,a1,272
ffffffffc020778e:	02e79d63          	bne	a5,a4,ffffffffc02077c8 <RR_enqueue+0x42>
ffffffffc0207792:	6118                	ld	a4,0(a0)
ffffffffc0207794:	1205a683          	lw	a3,288(a1)
ffffffffc0207798:	e11c                	sd	a5,0(a0)
ffffffffc020779a:	e71c                	sd	a5,8(a4)
ffffffffc020779c:	10a5bc23          	sd	a0,280(a1)
ffffffffc02077a0:	10e5b823          	sd	a4,272(a1)
ffffffffc02077a4:	495c                	lw	a5,20(a0)
ffffffffc02077a6:	ea89                	bnez	a3,ffffffffc02077b8 <RR_enqueue+0x32>
ffffffffc02077a8:	12f5a023          	sw	a5,288(a1)
ffffffffc02077ac:	491c                	lw	a5,16(a0)
ffffffffc02077ae:	10a5b423          	sd	a0,264(a1)
ffffffffc02077b2:	2785                	addiw	a5,a5,1
ffffffffc02077b4:	c91c                	sw	a5,16(a0)
ffffffffc02077b6:	8082                	ret
ffffffffc02077b8:	fed7c8e3          	blt	a5,a3,ffffffffc02077a8 <RR_enqueue+0x22>
ffffffffc02077bc:	491c                	lw	a5,16(a0)
ffffffffc02077be:	10a5b423          	sd	a0,264(a1)
ffffffffc02077c2:	2785                	addiw	a5,a5,1
ffffffffc02077c4:	c91c                	sw	a5,16(a0)
ffffffffc02077c6:	8082                	ret
ffffffffc02077c8:	1141                	addi	sp,sp,-16
ffffffffc02077ca:	00006697          	auipc	a3,0x6
ffffffffc02077ce:	42668693          	addi	a3,a3,1062 # ffffffffc020dbf0 <CSWTCH.79+0x5e8>
ffffffffc02077d2:	00004617          	auipc	a2,0x4
ffffffffc02077d6:	44660613          	addi	a2,a2,1094 # ffffffffc020bc18 <commands+0x250>
ffffffffc02077da:	02800593          	li	a1,40
ffffffffc02077de:	00006517          	auipc	a0,0x6
ffffffffc02077e2:	3f250513          	addi	a0,a0,1010 # ffffffffc020dbd0 <CSWTCH.79+0x5c8>
ffffffffc02077e6:	e406                	sd	ra,8(sp)
ffffffffc02077e8:	a47f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02077ec <sys_getpid>:
ffffffffc02077ec:	0008f797          	auipc	a5,0x8f
ffffffffc02077f0:	0d47b783          	ld	a5,212(a5) # ffffffffc02968c0 <current>
ffffffffc02077f4:	43c8                	lw	a0,4(a5)
ffffffffc02077f6:	8082                	ret

ffffffffc02077f8 <sys_pgdir>:
ffffffffc02077f8:	4501                	li	a0,0
ffffffffc02077fa:	8082                	ret

ffffffffc02077fc <sys_gettime>:
ffffffffc02077fc:	0008f797          	auipc	a5,0x8f
ffffffffc0207800:	0847b783          	ld	a5,132(a5) # ffffffffc0296880 <ticks>
ffffffffc0207804:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207808:	9d3d                	addw	a0,a0,a5
ffffffffc020780a:	0015151b          	slliw	a0,a0,0x1
ffffffffc020780e:	8082                	ret

ffffffffc0207810 <sys_lab6_set_priority>:
ffffffffc0207810:	4108                	lw	a0,0(a0)
ffffffffc0207812:	1141                	addi	sp,sp,-16
ffffffffc0207814:	e406                	sd	ra,8(sp)
ffffffffc0207816:	9dfff0ef          	jal	ra,ffffffffc02071f4 <lab6_set_priority>
ffffffffc020781a:	60a2                	ld	ra,8(sp)
ffffffffc020781c:	4501                	li	a0,0
ffffffffc020781e:	0141                	addi	sp,sp,16
ffffffffc0207820:	8082                	ret

ffffffffc0207822 <sys_dup>:
ffffffffc0207822:	450c                	lw	a1,8(a0)
ffffffffc0207824:	4108                	lw	a0,0(a0)
ffffffffc0207826:	d3efd06f          	j	ffffffffc0204d64 <sysfile_dup>

ffffffffc020782a <sys_getdirentry>:
ffffffffc020782a:	650c                	ld	a1,8(a0)
ffffffffc020782c:	4108                	lw	a0,0(a0)
ffffffffc020782e:	c46fd06f          	j	ffffffffc0204c74 <sysfile_getdirentry>

ffffffffc0207832 <sys_getcwd>:
ffffffffc0207832:	650c                	ld	a1,8(a0)
ffffffffc0207834:	6108                	ld	a0,0(a0)
ffffffffc0207836:	b9afd06f          	j	ffffffffc0204bd0 <sysfile_getcwd>

ffffffffc020783a <sys_fsync>:
ffffffffc020783a:	4108                	lw	a0,0(a0)
ffffffffc020783c:	b90fd06f          	j	ffffffffc0204bcc <sysfile_fsync>

ffffffffc0207840 <sys_fstat>:
ffffffffc0207840:	650c                	ld	a1,8(a0)
ffffffffc0207842:	4108                	lw	a0,0(a0)
ffffffffc0207844:	ae8fd06f          	j	ffffffffc0204b2c <sysfile_fstat>

ffffffffc0207848 <sys_seek>:
ffffffffc0207848:	4910                	lw	a2,16(a0)
ffffffffc020784a:	650c                	ld	a1,8(a0)
ffffffffc020784c:	4108                	lw	a0,0(a0)
ffffffffc020784e:	adafd06f          	j	ffffffffc0204b28 <sysfile_seek>

ffffffffc0207852 <sys_write>:
ffffffffc0207852:	6910                	ld	a2,16(a0)
ffffffffc0207854:	650c                	ld	a1,8(a0)
ffffffffc0207856:	4108                	lw	a0,0(a0)
ffffffffc0207858:	9b6fd06f          	j	ffffffffc0204a0e <sysfile_write>

ffffffffc020785c <sys_read>:
ffffffffc020785c:	6910                	ld	a2,16(a0)
ffffffffc020785e:	650c                	ld	a1,8(a0)
ffffffffc0207860:	4108                	lw	a0,0(a0)
ffffffffc0207862:	898fd06f          	j	ffffffffc02048fa <sysfile_read>

ffffffffc0207866 <sys_close>:
ffffffffc0207866:	4108                	lw	a0,0(a0)
ffffffffc0207868:	88efd06f          	j	ffffffffc02048f6 <sysfile_close>

ffffffffc020786c <sys_open>:
ffffffffc020786c:	450c                	lw	a1,8(a0)
ffffffffc020786e:	6108                	ld	a0,0(a0)
ffffffffc0207870:	852fd06f          	j	ffffffffc02048c2 <sysfile_open>

ffffffffc0207874 <sys_putc>:
ffffffffc0207874:	4108                	lw	a0,0(a0)
ffffffffc0207876:	1141                	addi	sp,sp,-16
ffffffffc0207878:	e406                	sd	ra,8(sp)
ffffffffc020787a:	8edf80ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc020787e:	60a2                	ld	ra,8(sp)
ffffffffc0207880:	4501                	li	a0,0
ffffffffc0207882:	0141                	addi	sp,sp,16
ffffffffc0207884:	8082                	ret

ffffffffc0207886 <sys_kill>:
ffffffffc0207886:	4108                	lw	a0,0(a0)
ffffffffc0207888:	f0aff06f          	j	ffffffffc0206f92 <do_kill>

ffffffffc020788c <sys_sleep>:
ffffffffc020788c:	4108                	lw	a0,0(a0)
ffffffffc020788e:	9a1ff06f          	j	ffffffffc020722e <do_sleep>

ffffffffc0207892 <sys_yield>:
ffffffffc0207892:	eb2ff06f          	j	ffffffffc0206f44 <do_yield>

ffffffffc0207896 <sys_exec>:
ffffffffc0207896:	6910                	ld	a2,16(a0)
ffffffffc0207898:	450c                	lw	a1,8(a0)
ffffffffc020789a:	6108                	ld	a0,0(a0)
ffffffffc020789c:	cc3fe06f          	j	ffffffffc020655e <do_execve>

ffffffffc02078a0 <sys_wait>:
ffffffffc02078a0:	650c                	ld	a1,8(a0)
ffffffffc02078a2:	4108                	lw	a0,0(a0)
ffffffffc02078a4:	eb0ff06f          	j	ffffffffc0206f54 <do_wait>

ffffffffc02078a8 <sys_fork>:
ffffffffc02078a8:	0008f797          	auipc	a5,0x8f
ffffffffc02078ac:	0187b783          	ld	a5,24(a5) # ffffffffc02968c0 <current>
ffffffffc02078b0:	73d0                	ld	a2,160(a5)
ffffffffc02078b2:	4501                	li	a0,0
ffffffffc02078b4:	6a0c                	ld	a1,16(a2)
ffffffffc02078b6:	bc0fe06f          	j	ffffffffc0205c76 <do_fork>

ffffffffc02078ba <sys_exit>:
ffffffffc02078ba:	4108                	lw	a0,0(a0)
ffffffffc02078bc:	81ffe06f          	j	ffffffffc02060da <do_exit>

ffffffffc02078c0 <syscall>:
ffffffffc02078c0:	715d                	addi	sp,sp,-80
ffffffffc02078c2:	fc26                	sd	s1,56(sp)
ffffffffc02078c4:	0008f497          	auipc	s1,0x8f
ffffffffc02078c8:	ffc48493          	addi	s1,s1,-4 # ffffffffc02968c0 <current>
ffffffffc02078cc:	6098                	ld	a4,0(s1)
ffffffffc02078ce:	e0a2                	sd	s0,64(sp)
ffffffffc02078d0:	f84a                	sd	s2,48(sp)
ffffffffc02078d2:	7340                	ld	s0,160(a4)
ffffffffc02078d4:	e486                	sd	ra,72(sp)
ffffffffc02078d6:	0ff00793          	li	a5,255
ffffffffc02078da:	05042903          	lw	s2,80(s0)
ffffffffc02078de:	0327ee63          	bltu	a5,s2,ffffffffc020791a <syscall+0x5a>
ffffffffc02078e2:	00391713          	slli	a4,s2,0x3
ffffffffc02078e6:	00006797          	auipc	a5,0x6
ffffffffc02078ea:	38278793          	addi	a5,a5,898 # ffffffffc020dc68 <syscalls>
ffffffffc02078ee:	97ba                	add	a5,a5,a4
ffffffffc02078f0:	639c                	ld	a5,0(a5)
ffffffffc02078f2:	c785                	beqz	a5,ffffffffc020791a <syscall+0x5a>
ffffffffc02078f4:	6c28                	ld	a0,88(s0)
ffffffffc02078f6:	702c                	ld	a1,96(s0)
ffffffffc02078f8:	7430                	ld	a2,104(s0)
ffffffffc02078fa:	7834                	ld	a3,112(s0)
ffffffffc02078fc:	7c38                	ld	a4,120(s0)
ffffffffc02078fe:	e42a                	sd	a0,8(sp)
ffffffffc0207900:	e82e                	sd	a1,16(sp)
ffffffffc0207902:	ec32                	sd	a2,24(sp)
ffffffffc0207904:	f036                	sd	a3,32(sp)
ffffffffc0207906:	f43a                	sd	a4,40(sp)
ffffffffc0207908:	0028                	addi	a0,sp,8
ffffffffc020790a:	9782                	jalr	a5
ffffffffc020790c:	60a6                	ld	ra,72(sp)
ffffffffc020790e:	e828                	sd	a0,80(s0)
ffffffffc0207910:	6406                	ld	s0,64(sp)
ffffffffc0207912:	74e2                	ld	s1,56(sp)
ffffffffc0207914:	7942                	ld	s2,48(sp)
ffffffffc0207916:	6161                	addi	sp,sp,80
ffffffffc0207918:	8082                	ret
ffffffffc020791a:	8522                	mv	a0,s0
ffffffffc020791c:	e72f90ef          	jal	ra,ffffffffc0200f8e <print_trapframe>
ffffffffc0207920:	609c                	ld	a5,0(s1)
ffffffffc0207922:	86ca                	mv	a3,s2
ffffffffc0207924:	00006617          	auipc	a2,0x6
ffffffffc0207928:	2fc60613          	addi	a2,a2,764 # ffffffffc020dc20 <CSWTCH.79+0x618>
ffffffffc020792c:	43d8                	lw	a4,4(a5)
ffffffffc020792e:	0d800593          	li	a1,216
ffffffffc0207932:	0b478793          	addi	a5,a5,180
ffffffffc0207936:	00006517          	auipc	a0,0x6
ffffffffc020793a:	31a50513          	addi	a0,a0,794 # ffffffffc020dc50 <CSWTCH.79+0x648>
ffffffffc020793e:	8f1f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207942 <vfs_do_add>:
ffffffffc0207942:	7139                	addi	sp,sp,-64
ffffffffc0207944:	fc06                	sd	ra,56(sp)
ffffffffc0207946:	f822                	sd	s0,48(sp)
ffffffffc0207948:	f426                	sd	s1,40(sp)
ffffffffc020794a:	f04a                	sd	s2,32(sp)
ffffffffc020794c:	ec4e                	sd	s3,24(sp)
ffffffffc020794e:	e852                	sd	s4,16(sp)
ffffffffc0207950:	e456                	sd	s5,8(sp)
ffffffffc0207952:	e05a                	sd	s6,0(sp)
ffffffffc0207954:	0e050b63          	beqz	a0,ffffffffc0207a4a <vfs_do_add+0x108>
ffffffffc0207958:	842a                	mv	s0,a0
ffffffffc020795a:	8a2e                	mv	s4,a1
ffffffffc020795c:	8b32                	mv	s6,a2
ffffffffc020795e:	8ab6                	mv	s5,a3
ffffffffc0207960:	c5cd                	beqz	a1,ffffffffc0207a0a <vfs_do_add+0xc8>
ffffffffc0207962:	4db8                	lw	a4,88(a1)
ffffffffc0207964:	6785                	lui	a5,0x1
ffffffffc0207966:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020796a:	0af71163          	bne	a4,a5,ffffffffc0207a0c <vfs_do_add+0xca>
ffffffffc020796e:	8522                	mv	a0,s0
ffffffffc0207970:	00d030ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc0207974:	47fd                	li	a5,31
ffffffffc0207976:	0ca7e663          	bltu	a5,a0,ffffffffc0207a42 <vfs_do_add+0x100>
ffffffffc020797a:	8522                	mv	a0,s0
ffffffffc020797c:	f36f80ef          	jal	ra,ffffffffc02000b2 <strdup>
ffffffffc0207980:	84aa                	mv	s1,a0
ffffffffc0207982:	c171                	beqz	a0,ffffffffc0207a46 <vfs_do_add+0x104>
ffffffffc0207984:	03000513          	li	a0,48
ffffffffc0207988:	c26fa0ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020798c:	89aa                	mv	s3,a0
ffffffffc020798e:	c92d                	beqz	a0,ffffffffc0207a00 <vfs_do_add+0xbe>
ffffffffc0207990:	0008e517          	auipc	a0,0x8e
ffffffffc0207994:	e8050513          	addi	a0,a0,-384 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207998:	0008e917          	auipc	s2,0x8e
ffffffffc020799c:	e6890913          	addi	s2,s2,-408 # ffffffffc0295800 <vdev_list>
ffffffffc02079a0:	e43fc0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc02079a4:	844a                	mv	s0,s2
ffffffffc02079a6:	a039                	j	ffffffffc02079b4 <vfs_do_add+0x72>
ffffffffc02079a8:	fe043503          	ld	a0,-32(s0)
ffffffffc02079ac:	85a6                	mv	a1,s1
ffffffffc02079ae:	017030ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc02079b2:	cd2d                	beqz	a0,ffffffffc0207a2c <vfs_do_add+0xea>
ffffffffc02079b4:	6400                	ld	s0,8(s0)
ffffffffc02079b6:	ff2419e3          	bne	s0,s2,ffffffffc02079a8 <vfs_do_add+0x66>
ffffffffc02079ba:	6418                	ld	a4,8(s0)
ffffffffc02079bc:	02098793          	addi	a5,s3,32
ffffffffc02079c0:	0099b023          	sd	s1,0(s3)
ffffffffc02079c4:	0149b423          	sd	s4,8(s3)
ffffffffc02079c8:	0159bc23          	sd	s5,24(s3)
ffffffffc02079cc:	0169b823          	sd	s6,16(s3)
ffffffffc02079d0:	e31c                	sd	a5,0(a4)
ffffffffc02079d2:	0289b023          	sd	s0,32(s3)
ffffffffc02079d6:	02e9b423          	sd	a4,40(s3)
ffffffffc02079da:	0008e517          	auipc	a0,0x8e
ffffffffc02079de:	e3650513          	addi	a0,a0,-458 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02079e2:	e41c                	sd	a5,8(s0)
ffffffffc02079e4:	4401                	li	s0,0
ffffffffc02079e6:	df9fc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc02079ea:	70e2                	ld	ra,56(sp)
ffffffffc02079ec:	8522                	mv	a0,s0
ffffffffc02079ee:	7442                	ld	s0,48(sp)
ffffffffc02079f0:	74a2                	ld	s1,40(sp)
ffffffffc02079f2:	7902                	ld	s2,32(sp)
ffffffffc02079f4:	69e2                	ld	s3,24(sp)
ffffffffc02079f6:	6a42                	ld	s4,16(sp)
ffffffffc02079f8:	6aa2                	ld	s5,8(sp)
ffffffffc02079fa:	6b02                	ld	s6,0(sp)
ffffffffc02079fc:	6121                	addi	sp,sp,64
ffffffffc02079fe:	8082                	ret
ffffffffc0207a00:	5471                	li	s0,-4
ffffffffc0207a02:	8526                	mv	a0,s1
ffffffffc0207a04:	c5afa0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0207a08:	b7cd                	j	ffffffffc02079ea <vfs_do_add+0xa8>
ffffffffc0207a0a:	d2b5                	beqz	a3,ffffffffc020796e <vfs_do_add+0x2c>
ffffffffc0207a0c:	00007697          	auipc	a3,0x7
ffffffffc0207a10:	a8468693          	addi	a3,a3,-1404 # ffffffffc020e490 <syscalls+0x828>
ffffffffc0207a14:	00004617          	auipc	a2,0x4
ffffffffc0207a18:	20460613          	addi	a2,a2,516 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207a1c:	08f00593          	li	a1,143
ffffffffc0207a20:	00007517          	auipc	a0,0x7
ffffffffc0207a24:	a5850513          	addi	a0,a0,-1448 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207a28:	807f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207a2c:	0008e517          	auipc	a0,0x8e
ffffffffc0207a30:	de450513          	addi	a0,a0,-540 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207a34:	dabfc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0207a38:	854e                	mv	a0,s3
ffffffffc0207a3a:	c24fa0ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc0207a3e:	5425                	li	s0,-23
ffffffffc0207a40:	b7c9                	j	ffffffffc0207a02 <vfs_do_add+0xc0>
ffffffffc0207a42:	5451                	li	s0,-12
ffffffffc0207a44:	b75d                	j	ffffffffc02079ea <vfs_do_add+0xa8>
ffffffffc0207a46:	5471                	li	s0,-4
ffffffffc0207a48:	b74d                	j	ffffffffc02079ea <vfs_do_add+0xa8>
ffffffffc0207a4a:	00007697          	auipc	a3,0x7
ffffffffc0207a4e:	a1e68693          	addi	a3,a3,-1506 # ffffffffc020e468 <syscalls+0x800>
ffffffffc0207a52:	00004617          	auipc	a2,0x4
ffffffffc0207a56:	1c660613          	addi	a2,a2,454 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207a5a:	08e00593          	li	a1,142
ffffffffc0207a5e:	00007517          	auipc	a0,0x7
ffffffffc0207a62:	a1a50513          	addi	a0,a0,-1510 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207a66:	fc8f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207a6a <find_mount.part.0>:
ffffffffc0207a6a:	1141                	addi	sp,sp,-16
ffffffffc0207a6c:	00007697          	auipc	a3,0x7
ffffffffc0207a70:	9fc68693          	addi	a3,a3,-1540 # ffffffffc020e468 <syscalls+0x800>
ffffffffc0207a74:	00004617          	auipc	a2,0x4
ffffffffc0207a78:	1a460613          	addi	a2,a2,420 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207a7c:	0cd00593          	li	a1,205
ffffffffc0207a80:	00007517          	auipc	a0,0x7
ffffffffc0207a84:	9f850513          	addi	a0,a0,-1544 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207a88:	e406                	sd	ra,8(sp)
ffffffffc0207a8a:	fa4f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207a8e <vfs_devlist_init>:
ffffffffc0207a8e:	0008e797          	auipc	a5,0x8e
ffffffffc0207a92:	d7278793          	addi	a5,a5,-654 # ffffffffc0295800 <vdev_list>
ffffffffc0207a96:	4585                	li	a1,1
ffffffffc0207a98:	0008e517          	auipc	a0,0x8e
ffffffffc0207a9c:	d7850513          	addi	a0,a0,-648 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207aa0:	e79c                	sd	a5,8(a5)
ffffffffc0207aa2:	e39c                	sd	a5,0(a5)
ffffffffc0207aa4:	d33fc06f          	j	ffffffffc02047d6 <sem_init>

ffffffffc0207aa8 <vfs_cleanup>:
ffffffffc0207aa8:	1101                	addi	sp,sp,-32
ffffffffc0207aaa:	e426                	sd	s1,8(sp)
ffffffffc0207aac:	0008e497          	auipc	s1,0x8e
ffffffffc0207ab0:	d5448493          	addi	s1,s1,-684 # ffffffffc0295800 <vdev_list>
ffffffffc0207ab4:	649c                	ld	a5,8(s1)
ffffffffc0207ab6:	ec06                	sd	ra,24(sp)
ffffffffc0207ab8:	e822                	sd	s0,16(sp)
ffffffffc0207aba:	02978e63          	beq	a5,s1,ffffffffc0207af6 <vfs_cleanup+0x4e>
ffffffffc0207abe:	0008e517          	auipc	a0,0x8e
ffffffffc0207ac2:	d5250513          	addi	a0,a0,-686 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207ac6:	d1dfc0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0207aca:	6480                	ld	s0,8(s1)
ffffffffc0207acc:	00940b63          	beq	s0,s1,ffffffffc0207ae2 <vfs_cleanup+0x3a>
ffffffffc0207ad0:	ff043783          	ld	a5,-16(s0)
ffffffffc0207ad4:	853e                	mv	a0,a5
ffffffffc0207ad6:	c399                	beqz	a5,ffffffffc0207adc <vfs_cleanup+0x34>
ffffffffc0207ad8:	6bfc                	ld	a5,208(a5)
ffffffffc0207ada:	9782                	jalr	a5
ffffffffc0207adc:	6400                	ld	s0,8(s0)
ffffffffc0207ade:	fe9419e3          	bne	s0,s1,ffffffffc0207ad0 <vfs_cleanup+0x28>
ffffffffc0207ae2:	6442                	ld	s0,16(sp)
ffffffffc0207ae4:	60e2                	ld	ra,24(sp)
ffffffffc0207ae6:	64a2                	ld	s1,8(sp)
ffffffffc0207ae8:	0008e517          	auipc	a0,0x8e
ffffffffc0207aec:	d2850513          	addi	a0,a0,-728 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207af0:	6105                	addi	sp,sp,32
ffffffffc0207af2:	cedfc06f          	j	ffffffffc02047de <up>
ffffffffc0207af6:	60e2                	ld	ra,24(sp)
ffffffffc0207af8:	6442                	ld	s0,16(sp)
ffffffffc0207afa:	64a2                	ld	s1,8(sp)
ffffffffc0207afc:	6105                	addi	sp,sp,32
ffffffffc0207afe:	8082                	ret

ffffffffc0207b00 <vfs_get_root>:
ffffffffc0207b00:	7179                	addi	sp,sp,-48
ffffffffc0207b02:	f406                	sd	ra,40(sp)
ffffffffc0207b04:	f022                	sd	s0,32(sp)
ffffffffc0207b06:	ec26                	sd	s1,24(sp)
ffffffffc0207b08:	e84a                	sd	s2,16(sp)
ffffffffc0207b0a:	e44e                	sd	s3,8(sp)
ffffffffc0207b0c:	e052                	sd	s4,0(sp)
ffffffffc0207b0e:	c541                	beqz	a0,ffffffffc0207b96 <vfs_get_root+0x96>
ffffffffc0207b10:	0008e917          	auipc	s2,0x8e
ffffffffc0207b14:	cf090913          	addi	s2,s2,-784 # ffffffffc0295800 <vdev_list>
ffffffffc0207b18:	00893783          	ld	a5,8(s2)
ffffffffc0207b1c:	07278b63          	beq	a5,s2,ffffffffc0207b92 <vfs_get_root+0x92>
ffffffffc0207b20:	89aa                	mv	s3,a0
ffffffffc0207b22:	0008e517          	auipc	a0,0x8e
ffffffffc0207b26:	cee50513          	addi	a0,a0,-786 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207b2a:	8a2e                	mv	s4,a1
ffffffffc0207b2c:	844a                	mv	s0,s2
ffffffffc0207b2e:	cb5fc0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0207b32:	a801                	j	ffffffffc0207b42 <vfs_get_root+0x42>
ffffffffc0207b34:	fe043583          	ld	a1,-32(s0)
ffffffffc0207b38:	854e                	mv	a0,s3
ffffffffc0207b3a:	68a030ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc0207b3e:	84aa                	mv	s1,a0
ffffffffc0207b40:	c505                	beqz	a0,ffffffffc0207b68 <vfs_get_root+0x68>
ffffffffc0207b42:	6400                	ld	s0,8(s0)
ffffffffc0207b44:	ff2418e3          	bne	s0,s2,ffffffffc0207b34 <vfs_get_root+0x34>
ffffffffc0207b48:	54cd                	li	s1,-13
ffffffffc0207b4a:	0008e517          	auipc	a0,0x8e
ffffffffc0207b4e:	cc650513          	addi	a0,a0,-826 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207b52:	c8dfc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0207b56:	70a2                	ld	ra,40(sp)
ffffffffc0207b58:	7402                	ld	s0,32(sp)
ffffffffc0207b5a:	6942                	ld	s2,16(sp)
ffffffffc0207b5c:	69a2                	ld	s3,8(sp)
ffffffffc0207b5e:	6a02                	ld	s4,0(sp)
ffffffffc0207b60:	8526                	mv	a0,s1
ffffffffc0207b62:	64e2                	ld	s1,24(sp)
ffffffffc0207b64:	6145                	addi	sp,sp,48
ffffffffc0207b66:	8082                	ret
ffffffffc0207b68:	ff043503          	ld	a0,-16(s0)
ffffffffc0207b6c:	c519                	beqz	a0,ffffffffc0207b7a <vfs_get_root+0x7a>
ffffffffc0207b6e:	617c                	ld	a5,192(a0)
ffffffffc0207b70:	9782                	jalr	a5
ffffffffc0207b72:	c519                	beqz	a0,ffffffffc0207b80 <vfs_get_root+0x80>
ffffffffc0207b74:	00aa3023          	sd	a0,0(s4)
ffffffffc0207b78:	bfc9                	j	ffffffffc0207b4a <vfs_get_root+0x4a>
ffffffffc0207b7a:	ff843783          	ld	a5,-8(s0)
ffffffffc0207b7e:	c399                	beqz	a5,ffffffffc0207b84 <vfs_get_root+0x84>
ffffffffc0207b80:	54c9                	li	s1,-14
ffffffffc0207b82:	b7e1                	j	ffffffffc0207b4a <vfs_get_root+0x4a>
ffffffffc0207b84:	fe843503          	ld	a0,-24(s0)
ffffffffc0207b88:	7b0000ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0207b8c:	fe843503          	ld	a0,-24(s0)
ffffffffc0207b90:	b7cd                	j	ffffffffc0207b72 <vfs_get_root+0x72>
ffffffffc0207b92:	54cd                	li	s1,-13
ffffffffc0207b94:	b7c9                	j	ffffffffc0207b56 <vfs_get_root+0x56>
ffffffffc0207b96:	00007697          	auipc	a3,0x7
ffffffffc0207b9a:	8d268693          	addi	a3,a3,-1838 # ffffffffc020e468 <syscalls+0x800>
ffffffffc0207b9e:	00004617          	auipc	a2,0x4
ffffffffc0207ba2:	07a60613          	addi	a2,a2,122 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207ba6:	04500593          	li	a1,69
ffffffffc0207baa:	00007517          	auipc	a0,0x7
ffffffffc0207bae:	8ce50513          	addi	a0,a0,-1842 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207bb2:	e7cf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207bb6 <vfs_get_devname>:
ffffffffc0207bb6:	0008e697          	auipc	a3,0x8e
ffffffffc0207bba:	c4a68693          	addi	a3,a3,-950 # ffffffffc0295800 <vdev_list>
ffffffffc0207bbe:	87b6                	mv	a5,a3
ffffffffc0207bc0:	e511                	bnez	a0,ffffffffc0207bcc <vfs_get_devname+0x16>
ffffffffc0207bc2:	a829                	j	ffffffffc0207bdc <vfs_get_devname+0x26>
ffffffffc0207bc4:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207bc8:	00a70763          	beq	a4,a0,ffffffffc0207bd6 <vfs_get_devname+0x20>
ffffffffc0207bcc:	679c                	ld	a5,8(a5)
ffffffffc0207bce:	fed79be3          	bne	a5,a3,ffffffffc0207bc4 <vfs_get_devname+0xe>
ffffffffc0207bd2:	4501                	li	a0,0
ffffffffc0207bd4:	8082                	ret
ffffffffc0207bd6:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207bda:	8082                	ret
ffffffffc0207bdc:	1141                	addi	sp,sp,-16
ffffffffc0207bde:	00007697          	auipc	a3,0x7
ffffffffc0207be2:	91268693          	addi	a3,a3,-1774 # ffffffffc020e4f0 <syscalls+0x888>
ffffffffc0207be6:	00004617          	auipc	a2,0x4
ffffffffc0207bea:	03260613          	addi	a2,a2,50 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207bee:	06a00593          	li	a1,106
ffffffffc0207bf2:	00007517          	auipc	a0,0x7
ffffffffc0207bf6:	88650513          	addi	a0,a0,-1914 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207bfa:	e406                	sd	ra,8(sp)
ffffffffc0207bfc:	e32f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207c00 <vfs_add_dev>:
ffffffffc0207c00:	86b2                	mv	a3,a2
ffffffffc0207c02:	4601                	li	a2,0
ffffffffc0207c04:	d3fff06f          	j	ffffffffc0207942 <vfs_do_add>

ffffffffc0207c08 <vfs_mount>:
ffffffffc0207c08:	7179                	addi	sp,sp,-48
ffffffffc0207c0a:	e84a                	sd	s2,16(sp)
ffffffffc0207c0c:	892a                	mv	s2,a0
ffffffffc0207c0e:	0008e517          	auipc	a0,0x8e
ffffffffc0207c12:	c0250513          	addi	a0,a0,-1022 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207c16:	e44e                	sd	s3,8(sp)
ffffffffc0207c18:	f406                	sd	ra,40(sp)
ffffffffc0207c1a:	f022                	sd	s0,32(sp)
ffffffffc0207c1c:	ec26                	sd	s1,24(sp)
ffffffffc0207c1e:	89ae                	mv	s3,a1
ffffffffc0207c20:	bc3fc0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0207c24:	08090a63          	beqz	s2,ffffffffc0207cb8 <vfs_mount+0xb0>
ffffffffc0207c28:	0008e497          	auipc	s1,0x8e
ffffffffc0207c2c:	bd848493          	addi	s1,s1,-1064 # ffffffffc0295800 <vdev_list>
ffffffffc0207c30:	6480                	ld	s0,8(s1)
ffffffffc0207c32:	00941663          	bne	s0,s1,ffffffffc0207c3e <vfs_mount+0x36>
ffffffffc0207c36:	a8ad                	j	ffffffffc0207cb0 <vfs_mount+0xa8>
ffffffffc0207c38:	6400                	ld	s0,8(s0)
ffffffffc0207c3a:	06940b63          	beq	s0,s1,ffffffffc0207cb0 <vfs_mount+0xa8>
ffffffffc0207c3e:	ff843783          	ld	a5,-8(s0)
ffffffffc0207c42:	dbfd                	beqz	a5,ffffffffc0207c38 <vfs_mount+0x30>
ffffffffc0207c44:	fe043503          	ld	a0,-32(s0)
ffffffffc0207c48:	85ca                	mv	a1,s2
ffffffffc0207c4a:	57a030ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc0207c4e:	f56d                	bnez	a0,ffffffffc0207c38 <vfs_mount+0x30>
ffffffffc0207c50:	ff043783          	ld	a5,-16(s0)
ffffffffc0207c54:	e3a5                	bnez	a5,ffffffffc0207cb4 <vfs_mount+0xac>
ffffffffc0207c56:	fe043783          	ld	a5,-32(s0)
ffffffffc0207c5a:	c3c9                	beqz	a5,ffffffffc0207cdc <vfs_mount+0xd4>
ffffffffc0207c5c:	ff843783          	ld	a5,-8(s0)
ffffffffc0207c60:	cfb5                	beqz	a5,ffffffffc0207cdc <vfs_mount+0xd4>
ffffffffc0207c62:	fe843503          	ld	a0,-24(s0)
ffffffffc0207c66:	c939                	beqz	a0,ffffffffc0207cbc <vfs_mount+0xb4>
ffffffffc0207c68:	4d38                	lw	a4,88(a0)
ffffffffc0207c6a:	6785                	lui	a5,0x1
ffffffffc0207c6c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207c70:	04f71663          	bne	a4,a5,ffffffffc0207cbc <vfs_mount+0xb4>
ffffffffc0207c74:	ff040593          	addi	a1,s0,-16
ffffffffc0207c78:	9982                	jalr	s3
ffffffffc0207c7a:	84aa                	mv	s1,a0
ffffffffc0207c7c:	ed01                	bnez	a0,ffffffffc0207c94 <vfs_mount+0x8c>
ffffffffc0207c7e:	ff043783          	ld	a5,-16(s0)
ffffffffc0207c82:	cfad                	beqz	a5,ffffffffc0207cfc <vfs_mount+0xf4>
ffffffffc0207c84:	fe043583          	ld	a1,-32(s0)
ffffffffc0207c88:	00007517          	auipc	a0,0x7
ffffffffc0207c8c:	8f850513          	addi	a0,a0,-1800 # ffffffffc020e580 <syscalls+0x918>
ffffffffc0207c90:	c9af80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0207c94:	0008e517          	auipc	a0,0x8e
ffffffffc0207c98:	b7c50513          	addi	a0,a0,-1156 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207c9c:	b43fc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0207ca0:	70a2                	ld	ra,40(sp)
ffffffffc0207ca2:	7402                	ld	s0,32(sp)
ffffffffc0207ca4:	6942                	ld	s2,16(sp)
ffffffffc0207ca6:	69a2                	ld	s3,8(sp)
ffffffffc0207ca8:	8526                	mv	a0,s1
ffffffffc0207caa:	64e2                	ld	s1,24(sp)
ffffffffc0207cac:	6145                	addi	sp,sp,48
ffffffffc0207cae:	8082                	ret
ffffffffc0207cb0:	54cd                	li	s1,-13
ffffffffc0207cb2:	b7cd                	j	ffffffffc0207c94 <vfs_mount+0x8c>
ffffffffc0207cb4:	54c5                	li	s1,-15
ffffffffc0207cb6:	bff9                	j	ffffffffc0207c94 <vfs_mount+0x8c>
ffffffffc0207cb8:	db3ff0ef          	jal	ra,ffffffffc0207a6a <find_mount.part.0>
ffffffffc0207cbc:	00007697          	auipc	a3,0x7
ffffffffc0207cc0:	87468693          	addi	a3,a3,-1932 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0207cc4:	00004617          	auipc	a2,0x4
ffffffffc0207cc8:	f5460613          	addi	a2,a2,-172 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207ccc:	0ed00593          	li	a1,237
ffffffffc0207cd0:	00006517          	auipc	a0,0x6
ffffffffc0207cd4:	7a850513          	addi	a0,a0,1960 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207cd8:	d56f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207cdc:	00007697          	auipc	a3,0x7
ffffffffc0207ce0:	82468693          	addi	a3,a3,-2012 # ffffffffc020e500 <syscalls+0x898>
ffffffffc0207ce4:	00004617          	auipc	a2,0x4
ffffffffc0207ce8:	f3460613          	addi	a2,a2,-204 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207cec:	0eb00593          	li	a1,235
ffffffffc0207cf0:	00006517          	auipc	a0,0x6
ffffffffc0207cf4:	78850513          	addi	a0,a0,1928 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207cf8:	d36f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207cfc:	00007697          	auipc	a3,0x7
ffffffffc0207d00:	86c68693          	addi	a3,a3,-1940 # ffffffffc020e568 <syscalls+0x900>
ffffffffc0207d04:	00004617          	auipc	a2,0x4
ffffffffc0207d08:	f1460613          	addi	a2,a2,-236 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207d0c:	0ef00593          	li	a1,239
ffffffffc0207d10:	00006517          	auipc	a0,0x6
ffffffffc0207d14:	76850513          	addi	a0,a0,1896 # ffffffffc020e478 <syscalls+0x810>
ffffffffc0207d18:	d16f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207d1c <vfs_get_curdir>:
ffffffffc0207d1c:	0008f797          	auipc	a5,0x8f
ffffffffc0207d20:	ba47b783          	ld	a5,-1116(a5) # ffffffffc02968c0 <current>
ffffffffc0207d24:	1487b783          	ld	a5,328(a5)
ffffffffc0207d28:	1101                	addi	sp,sp,-32
ffffffffc0207d2a:	e426                	sd	s1,8(sp)
ffffffffc0207d2c:	6384                	ld	s1,0(a5)
ffffffffc0207d2e:	ec06                	sd	ra,24(sp)
ffffffffc0207d30:	e822                	sd	s0,16(sp)
ffffffffc0207d32:	cc81                	beqz	s1,ffffffffc0207d4a <vfs_get_curdir+0x2e>
ffffffffc0207d34:	842a                	mv	s0,a0
ffffffffc0207d36:	8526                	mv	a0,s1
ffffffffc0207d38:	600000ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0207d3c:	4501                	li	a0,0
ffffffffc0207d3e:	e004                	sd	s1,0(s0)
ffffffffc0207d40:	60e2                	ld	ra,24(sp)
ffffffffc0207d42:	6442                	ld	s0,16(sp)
ffffffffc0207d44:	64a2                	ld	s1,8(sp)
ffffffffc0207d46:	6105                	addi	sp,sp,32
ffffffffc0207d48:	8082                	ret
ffffffffc0207d4a:	5541                	li	a0,-16
ffffffffc0207d4c:	bfd5                	j	ffffffffc0207d40 <vfs_get_curdir+0x24>

ffffffffc0207d4e <vfs_set_curdir>:
ffffffffc0207d4e:	7139                	addi	sp,sp,-64
ffffffffc0207d50:	f04a                	sd	s2,32(sp)
ffffffffc0207d52:	0008f917          	auipc	s2,0x8f
ffffffffc0207d56:	b6e90913          	addi	s2,s2,-1170 # ffffffffc02968c0 <current>
ffffffffc0207d5a:	00093783          	ld	a5,0(s2)
ffffffffc0207d5e:	f822                	sd	s0,48(sp)
ffffffffc0207d60:	842a                	mv	s0,a0
ffffffffc0207d62:	1487b503          	ld	a0,328(a5)
ffffffffc0207d66:	ec4e                	sd	s3,24(sp)
ffffffffc0207d68:	fc06                	sd	ra,56(sp)
ffffffffc0207d6a:	f426                	sd	s1,40(sp)
ffffffffc0207d6c:	b07fd0ef          	jal	ra,ffffffffc0205872 <lock_files>
ffffffffc0207d70:	00093783          	ld	a5,0(s2)
ffffffffc0207d74:	1487b503          	ld	a0,328(a5)
ffffffffc0207d78:	00053983          	ld	s3,0(a0)
ffffffffc0207d7c:	07340963          	beq	s0,s3,ffffffffc0207dee <vfs_set_curdir+0xa0>
ffffffffc0207d80:	cc39                	beqz	s0,ffffffffc0207dde <vfs_set_curdir+0x90>
ffffffffc0207d82:	783c                	ld	a5,112(s0)
ffffffffc0207d84:	c7bd                	beqz	a5,ffffffffc0207df2 <vfs_set_curdir+0xa4>
ffffffffc0207d86:	6bbc                	ld	a5,80(a5)
ffffffffc0207d88:	c7ad                	beqz	a5,ffffffffc0207df2 <vfs_set_curdir+0xa4>
ffffffffc0207d8a:	00007597          	auipc	a1,0x7
ffffffffc0207d8e:	86e58593          	addi	a1,a1,-1938 # ffffffffc020e5f8 <syscalls+0x990>
ffffffffc0207d92:	8522                	mv	a0,s0
ffffffffc0207d94:	5bc000ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0207d98:	783c                	ld	a5,112(s0)
ffffffffc0207d9a:	006c                	addi	a1,sp,12
ffffffffc0207d9c:	8522                	mv	a0,s0
ffffffffc0207d9e:	6bbc                	ld	a5,80(a5)
ffffffffc0207da0:	9782                	jalr	a5
ffffffffc0207da2:	84aa                	mv	s1,a0
ffffffffc0207da4:	e901                	bnez	a0,ffffffffc0207db4 <vfs_set_curdir+0x66>
ffffffffc0207da6:	47b2                	lw	a5,12(sp)
ffffffffc0207da8:	669d                	lui	a3,0x7
ffffffffc0207daa:	6709                	lui	a4,0x2
ffffffffc0207dac:	8ff5                	and	a5,a5,a3
ffffffffc0207dae:	54b9                	li	s1,-18
ffffffffc0207db0:	02e78063          	beq	a5,a4,ffffffffc0207dd0 <vfs_set_curdir+0x82>
ffffffffc0207db4:	00093783          	ld	a5,0(s2)
ffffffffc0207db8:	1487b503          	ld	a0,328(a5)
ffffffffc0207dbc:	abdfd0ef          	jal	ra,ffffffffc0205878 <unlock_files>
ffffffffc0207dc0:	70e2                	ld	ra,56(sp)
ffffffffc0207dc2:	7442                	ld	s0,48(sp)
ffffffffc0207dc4:	7902                	ld	s2,32(sp)
ffffffffc0207dc6:	69e2                	ld	s3,24(sp)
ffffffffc0207dc8:	8526                	mv	a0,s1
ffffffffc0207dca:	74a2                	ld	s1,40(sp)
ffffffffc0207dcc:	6121                	addi	sp,sp,64
ffffffffc0207dce:	8082                	ret
ffffffffc0207dd0:	8522                	mv	a0,s0
ffffffffc0207dd2:	566000ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0207dd6:	00093783          	ld	a5,0(s2)
ffffffffc0207dda:	1487b503          	ld	a0,328(a5)
ffffffffc0207dde:	e100                	sd	s0,0(a0)
ffffffffc0207de0:	4481                	li	s1,0
ffffffffc0207de2:	fc098de3          	beqz	s3,ffffffffc0207dbc <vfs_set_curdir+0x6e>
ffffffffc0207de6:	854e                	mv	a0,s3
ffffffffc0207de8:	61e000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc0207dec:	b7e1                	j	ffffffffc0207db4 <vfs_set_curdir+0x66>
ffffffffc0207dee:	4481                	li	s1,0
ffffffffc0207df0:	b7f1                	j	ffffffffc0207dbc <vfs_set_curdir+0x6e>
ffffffffc0207df2:	00006697          	auipc	a3,0x6
ffffffffc0207df6:	79e68693          	addi	a3,a3,1950 # ffffffffc020e590 <syscalls+0x928>
ffffffffc0207dfa:	00004617          	auipc	a2,0x4
ffffffffc0207dfe:	e1e60613          	addi	a2,a2,-482 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207e02:	04300593          	li	a1,67
ffffffffc0207e06:	00006517          	auipc	a0,0x6
ffffffffc0207e0a:	7da50513          	addi	a0,a0,2010 # ffffffffc020e5e0 <syscalls+0x978>
ffffffffc0207e0e:	c20f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207e12 <vfs_chdir>:
ffffffffc0207e12:	1101                	addi	sp,sp,-32
ffffffffc0207e14:	002c                	addi	a1,sp,8
ffffffffc0207e16:	e822                	sd	s0,16(sp)
ffffffffc0207e18:	ec06                	sd	ra,24(sp)
ffffffffc0207e1a:	21e000ef          	jal	ra,ffffffffc0208038 <vfs_lookup>
ffffffffc0207e1e:	842a                	mv	s0,a0
ffffffffc0207e20:	c511                	beqz	a0,ffffffffc0207e2c <vfs_chdir+0x1a>
ffffffffc0207e22:	60e2                	ld	ra,24(sp)
ffffffffc0207e24:	8522                	mv	a0,s0
ffffffffc0207e26:	6442                	ld	s0,16(sp)
ffffffffc0207e28:	6105                	addi	sp,sp,32
ffffffffc0207e2a:	8082                	ret
ffffffffc0207e2c:	6522                	ld	a0,8(sp)
ffffffffc0207e2e:	f21ff0ef          	jal	ra,ffffffffc0207d4e <vfs_set_curdir>
ffffffffc0207e32:	842a                	mv	s0,a0
ffffffffc0207e34:	6522                	ld	a0,8(sp)
ffffffffc0207e36:	5d0000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc0207e3a:	60e2                	ld	ra,24(sp)
ffffffffc0207e3c:	8522                	mv	a0,s0
ffffffffc0207e3e:	6442                	ld	s0,16(sp)
ffffffffc0207e40:	6105                	addi	sp,sp,32
ffffffffc0207e42:	8082                	ret

ffffffffc0207e44 <vfs_getcwd>:
ffffffffc0207e44:	0008f797          	auipc	a5,0x8f
ffffffffc0207e48:	a7c7b783          	ld	a5,-1412(a5) # ffffffffc02968c0 <current>
ffffffffc0207e4c:	1487b783          	ld	a5,328(a5)
ffffffffc0207e50:	7179                	addi	sp,sp,-48
ffffffffc0207e52:	ec26                	sd	s1,24(sp)
ffffffffc0207e54:	6384                	ld	s1,0(a5)
ffffffffc0207e56:	f406                	sd	ra,40(sp)
ffffffffc0207e58:	f022                	sd	s0,32(sp)
ffffffffc0207e5a:	e84a                	sd	s2,16(sp)
ffffffffc0207e5c:	ccbd                	beqz	s1,ffffffffc0207eda <vfs_getcwd+0x96>
ffffffffc0207e5e:	892a                	mv	s2,a0
ffffffffc0207e60:	8526                	mv	a0,s1
ffffffffc0207e62:	4d6000ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0207e66:	74a8                	ld	a0,104(s1)
ffffffffc0207e68:	c93d                	beqz	a0,ffffffffc0207ede <vfs_getcwd+0x9a>
ffffffffc0207e6a:	d4dff0ef          	jal	ra,ffffffffc0207bb6 <vfs_get_devname>
ffffffffc0207e6e:	842a                	mv	s0,a0
ffffffffc0207e70:	30c030ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc0207e74:	862a                	mv	a2,a0
ffffffffc0207e76:	85a2                	mv	a1,s0
ffffffffc0207e78:	4701                	li	a4,0
ffffffffc0207e7a:	4685                	li	a3,1
ffffffffc0207e7c:	854a                	mv	a0,s2
ffffffffc0207e7e:	951fd0ef          	jal	ra,ffffffffc02057ce <iobuf_move>
ffffffffc0207e82:	842a                	mv	s0,a0
ffffffffc0207e84:	c919                	beqz	a0,ffffffffc0207e9a <vfs_getcwd+0x56>
ffffffffc0207e86:	8526                	mv	a0,s1
ffffffffc0207e88:	57e000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc0207e8c:	70a2                	ld	ra,40(sp)
ffffffffc0207e8e:	8522                	mv	a0,s0
ffffffffc0207e90:	7402                	ld	s0,32(sp)
ffffffffc0207e92:	64e2                	ld	s1,24(sp)
ffffffffc0207e94:	6942                	ld	s2,16(sp)
ffffffffc0207e96:	6145                	addi	sp,sp,48
ffffffffc0207e98:	8082                	ret
ffffffffc0207e9a:	03a00793          	li	a5,58
ffffffffc0207e9e:	4701                	li	a4,0
ffffffffc0207ea0:	4685                	li	a3,1
ffffffffc0207ea2:	4605                	li	a2,1
ffffffffc0207ea4:	00f10593          	addi	a1,sp,15
ffffffffc0207ea8:	854a                	mv	a0,s2
ffffffffc0207eaa:	00f107a3          	sb	a5,15(sp)
ffffffffc0207eae:	921fd0ef          	jal	ra,ffffffffc02057ce <iobuf_move>
ffffffffc0207eb2:	842a                	mv	s0,a0
ffffffffc0207eb4:	f969                	bnez	a0,ffffffffc0207e86 <vfs_getcwd+0x42>
ffffffffc0207eb6:	78bc                	ld	a5,112(s1)
ffffffffc0207eb8:	c3b9                	beqz	a5,ffffffffc0207efe <vfs_getcwd+0xba>
ffffffffc0207eba:	7f9c                	ld	a5,56(a5)
ffffffffc0207ebc:	c3a9                	beqz	a5,ffffffffc0207efe <vfs_getcwd+0xba>
ffffffffc0207ebe:	00006597          	auipc	a1,0x6
ffffffffc0207ec2:	7b258593          	addi	a1,a1,1970 # ffffffffc020e670 <syscalls+0xa08>
ffffffffc0207ec6:	8526                	mv	a0,s1
ffffffffc0207ec8:	488000ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0207ecc:	78bc                	ld	a5,112(s1)
ffffffffc0207ece:	85ca                	mv	a1,s2
ffffffffc0207ed0:	8526                	mv	a0,s1
ffffffffc0207ed2:	7f9c                	ld	a5,56(a5)
ffffffffc0207ed4:	9782                	jalr	a5
ffffffffc0207ed6:	842a                	mv	s0,a0
ffffffffc0207ed8:	b77d                	j	ffffffffc0207e86 <vfs_getcwd+0x42>
ffffffffc0207eda:	5441                	li	s0,-16
ffffffffc0207edc:	bf45                	j	ffffffffc0207e8c <vfs_getcwd+0x48>
ffffffffc0207ede:	00006697          	auipc	a3,0x6
ffffffffc0207ee2:	72268693          	addi	a3,a3,1826 # ffffffffc020e600 <syscalls+0x998>
ffffffffc0207ee6:	00004617          	auipc	a2,0x4
ffffffffc0207eea:	d3260613          	addi	a2,a2,-718 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207eee:	06e00593          	li	a1,110
ffffffffc0207ef2:	00006517          	auipc	a0,0x6
ffffffffc0207ef6:	6ee50513          	addi	a0,a0,1774 # ffffffffc020e5e0 <syscalls+0x978>
ffffffffc0207efa:	b34f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207efe:	00006697          	auipc	a3,0x6
ffffffffc0207f02:	71a68693          	addi	a3,a3,1818 # ffffffffc020e618 <syscalls+0x9b0>
ffffffffc0207f06:	00004617          	auipc	a2,0x4
ffffffffc0207f0a:	d1260613          	addi	a2,a2,-750 # ffffffffc020bc18 <commands+0x250>
ffffffffc0207f0e:	07800593          	li	a1,120
ffffffffc0207f12:	00006517          	auipc	a0,0x6
ffffffffc0207f16:	6ce50513          	addi	a0,a0,1742 # ffffffffc020e5e0 <syscalls+0x978>
ffffffffc0207f1a:	b14f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207f1e <get_device>:
ffffffffc0207f1e:	7179                	addi	sp,sp,-48
ffffffffc0207f20:	ec26                	sd	s1,24(sp)
ffffffffc0207f22:	e84a                	sd	s2,16(sp)
ffffffffc0207f24:	f406                	sd	ra,40(sp)
ffffffffc0207f26:	f022                	sd	s0,32(sp)
ffffffffc0207f28:	00054303          	lbu	t1,0(a0)
ffffffffc0207f2c:	892e                	mv	s2,a1
ffffffffc0207f2e:	84b2                	mv	s1,a2
ffffffffc0207f30:	02030463          	beqz	t1,ffffffffc0207f58 <get_device+0x3a>
ffffffffc0207f34:	00150413          	addi	s0,a0,1
ffffffffc0207f38:	86a2                	mv	a3,s0
ffffffffc0207f3a:	879a                	mv	a5,t1
ffffffffc0207f3c:	4701                	li	a4,0
ffffffffc0207f3e:	03a00813          	li	a6,58
ffffffffc0207f42:	02f00893          	li	a7,47
ffffffffc0207f46:	03078363          	beq	a5,a6,ffffffffc0207f6c <get_device+0x4e>
ffffffffc0207f4a:	05178a63          	beq	a5,a7,ffffffffc0207f9e <get_device+0x80>
ffffffffc0207f4e:	0006c783          	lbu	a5,0(a3)
ffffffffc0207f52:	2705                	addiw	a4,a4,1
ffffffffc0207f54:	0685                	addi	a3,a3,1
ffffffffc0207f56:	fbe5                	bnez	a5,ffffffffc0207f46 <get_device+0x28>
ffffffffc0207f58:	7402                	ld	s0,32(sp)
ffffffffc0207f5a:	00a93023          	sd	a0,0(s2)
ffffffffc0207f5e:	70a2                	ld	ra,40(sp)
ffffffffc0207f60:	6942                	ld	s2,16(sp)
ffffffffc0207f62:	8526                	mv	a0,s1
ffffffffc0207f64:	64e2                	ld	s1,24(sp)
ffffffffc0207f66:	6145                	addi	sp,sp,48
ffffffffc0207f68:	db5ff06f          	j	ffffffffc0207d1c <vfs_get_curdir>
ffffffffc0207f6c:	cb15                	beqz	a4,ffffffffc0207fa0 <get_device+0x82>
ffffffffc0207f6e:	00e507b3          	add	a5,a0,a4
ffffffffc0207f72:	0705                	addi	a4,a4,1
ffffffffc0207f74:	00078023          	sb	zero,0(a5)
ffffffffc0207f78:	972a                	add	a4,a4,a0
ffffffffc0207f7a:	02f00613          	li	a2,47
ffffffffc0207f7e:	00074783          	lbu	a5,0(a4) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc0207f82:	86ba                	mv	a3,a4
ffffffffc0207f84:	0705                	addi	a4,a4,1
ffffffffc0207f86:	fec78ce3          	beq	a5,a2,ffffffffc0207f7e <get_device+0x60>
ffffffffc0207f8a:	7402                	ld	s0,32(sp)
ffffffffc0207f8c:	70a2                	ld	ra,40(sp)
ffffffffc0207f8e:	00d93023          	sd	a3,0(s2)
ffffffffc0207f92:	85a6                	mv	a1,s1
ffffffffc0207f94:	6942                	ld	s2,16(sp)
ffffffffc0207f96:	64e2                	ld	s1,24(sp)
ffffffffc0207f98:	6145                	addi	sp,sp,48
ffffffffc0207f9a:	b67ff06f          	j	ffffffffc0207b00 <vfs_get_root>
ffffffffc0207f9e:	ff4d                	bnez	a4,ffffffffc0207f58 <get_device+0x3a>
ffffffffc0207fa0:	02f00793          	li	a5,47
ffffffffc0207fa4:	04f30563          	beq	t1,a5,ffffffffc0207fee <get_device+0xd0>
ffffffffc0207fa8:	03a00793          	li	a5,58
ffffffffc0207fac:	06f31663          	bne	t1,a5,ffffffffc0208018 <get_device+0xfa>
ffffffffc0207fb0:	0028                	addi	a0,sp,8
ffffffffc0207fb2:	d6bff0ef          	jal	ra,ffffffffc0207d1c <vfs_get_curdir>
ffffffffc0207fb6:	e515                	bnez	a0,ffffffffc0207fe2 <get_device+0xc4>
ffffffffc0207fb8:	67a2                	ld	a5,8(sp)
ffffffffc0207fba:	77a8                	ld	a0,104(a5)
ffffffffc0207fbc:	cd15                	beqz	a0,ffffffffc0207ff8 <get_device+0xda>
ffffffffc0207fbe:	617c                	ld	a5,192(a0)
ffffffffc0207fc0:	9782                	jalr	a5
ffffffffc0207fc2:	87aa                	mv	a5,a0
ffffffffc0207fc4:	6522                	ld	a0,8(sp)
ffffffffc0207fc6:	e09c                	sd	a5,0(s1)
ffffffffc0207fc8:	43e000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc0207fcc:	02f00713          	li	a4,47
ffffffffc0207fd0:	a011                	j	ffffffffc0207fd4 <get_device+0xb6>
ffffffffc0207fd2:	0405                	addi	s0,s0,1
ffffffffc0207fd4:	00044783          	lbu	a5,0(s0)
ffffffffc0207fd8:	fee78de3          	beq	a5,a4,ffffffffc0207fd2 <get_device+0xb4>
ffffffffc0207fdc:	00893023          	sd	s0,0(s2)
ffffffffc0207fe0:	4501                	li	a0,0
ffffffffc0207fe2:	70a2                	ld	ra,40(sp)
ffffffffc0207fe4:	7402                	ld	s0,32(sp)
ffffffffc0207fe6:	64e2                	ld	s1,24(sp)
ffffffffc0207fe8:	6942                	ld	s2,16(sp)
ffffffffc0207fea:	6145                	addi	sp,sp,48
ffffffffc0207fec:	8082                	ret
ffffffffc0207fee:	8526                	mv	a0,s1
ffffffffc0207ff0:	616000ef          	jal	ra,ffffffffc0208606 <vfs_get_bootfs>
ffffffffc0207ff4:	dd61                	beqz	a0,ffffffffc0207fcc <get_device+0xae>
ffffffffc0207ff6:	b7f5                	j	ffffffffc0207fe2 <get_device+0xc4>
ffffffffc0207ff8:	00006697          	auipc	a3,0x6
ffffffffc0207ffc:	60868693          	addi	a3,a3,1544 # ffffffffc020e600 <syscalls+0x998>
ffffffffc0208000:	00004617          	auipc	a2,0x4
ffffffffc0208004:	c1860613          	addi	a2,a2,-1000 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208008:	03900593          	li	a1,57
ffffffffc020800c:	00006517          	auipc	a0,0x6
ffffffffc0208010:	68450513          	addi	a0,a0,1668 # ffffffffc020e690 <syscalls+0xa28>
ffffffffc0208014:	a1af80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208018:	00006697          	auipc	a3,0x6
ffffffffc020801c:	66868693          	addi	a3,a3,1640 # ffffffffc020e680 <syscalls+0xa18>
ffffffffc0208020:	00004617          	auipc	a2,0x4
ffffffffc0208024:	bf860613          	addi	a2,a2,-1032 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208028:	03300593          	li	a1,51
ffffffffc020802c:	00006517          	auipc	a0,0x6
ffffffffc0208030:	66450513          	addi	a0,a0,1636 # ffffffffc020e690 <syscalls+0xa28>
ffffffffc0208034:	9faf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208038 <vfs_lookup>:
ffffffffc0208038:	7139                	addi	sp,sp,-64
ffffffffc020803a:	f426                	sd	s1,40(sp)
ffffffffc020803c:	0830                	addi	a2,sp,24
ffffffffc020803e:	84ae                	mv	s1,a1
ffffffffc0208040:	002c                	addi	a1,sp,8
ffffffffc0208042:	f822                	sd	s0,48(sp)
ffffffffc0208044:	fc06                	sd	ra,56(sp)
ffffffffc0208046:	f04a                	sd	s2,32(sp)
ffffffffc0208048:	e42a                	sd	a0,8(sp)
ffffffffc020804a:	ed5ff0ef          	jal	ra,ffffffffc0207f1e <get_device>
ffffffffc020804e:	842a                	mv	s0,a0
ffffffffc0208050:	ed1d                	bnez	a0,ffffffffc020808e <vfs_lookup+0x56>
ffffffffc0208052:	67a2                	ld	a5,8(sp)
ffffffffc0208054:	6962                	ld	s2,24(sp)
ffffffffc0208056:	0007c783          	lbu	a5,0(a5)
ffffffffc020805a:	c3a9                	beqz	a5,ffffffffc020809c <vfs_lookup+0x64>
ffffffffc020805c:	04090963          	beqz	s2,ffffffffc02080ae <vfs_lookup+0x76>
ffffffffc0208060:	07093783          	ld	a5,112(s2)
ffffffffc0208064:	c7a9                	beqz	a5,ffffffffc02080ae <vfs_lookup+0x76>
ffffffffc0208066:	7bbc                	ld	a5,112(a5)
ffffffffc0208068:	c3b9                	beqz	a5,ffffffffc02080ae <vfs_lookup+0x76>
ffffffffc020806a:	854a                	mv	a0,s2
ffffffffc020806c:	00006597          	auipc	a1,0x6
ffffffffc0208070:	68c58593          	addi	a1,a1,1676 # ffffffffc020e6f8 <syscalls+0xa90>
ffffffffc0208074:	2dc000ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0208078:	07093783          	ld	a5,112(s2)
ffffffffc020807c:	65a2                	ld	a1,8(sp)
ffffffffc020807e:	6562                	ld	a0,24(sp)
ffffffffc0208080:	7bbc                	ld	a5,112(a5)
ffffffffc0208082:	8626                	mv	a2,s1
ffffffffc0208084:	9782                	jalr	a5
ffffffffc0208086:	842a                	mv	s0,a0
ffffffffc0208088:	6562                	ld	a0,24(sp)
ffffffffc020808a:	37c000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020808e:	70e2                	ld	ra,56(sp)
ffffffffc0208090:	8522                	mv	a0,s0
ffffffffc0208092:	7442                	ld	s0,48(sp)
ffffffffc0208094:	74a2                	ld	s1,40(sp)
ffffffffc0208096:	7902                	ld	s2,32(sp)
ffffffffc0208098:	6121                	addi	sp,sp,64
ffffffffc020809a:	8082                	ret
ffffffffc020809c:	70e2                	ld	ra,56(sp)
ffffffffc020809e:	8522                	mv	a0,s0
ffffffffc02080a0:	7442                	ld	s0,48(sp)
ffffffffc02080a2:	0124b023          	sd	s2,0(s1)
ffffffffc02080a6:	74a2                	ld	s1,40(sp)
ffffffffc02080a8:	7902                	ld	s2,32(sp)
ffffffffc02080aa:	6121                	addi	sp,sp,64
ffffffffc02080ac:	8082                	ret
ffffffffc02080ae:	00006697          	auipc	a3,0x6
ffffffffc02080b2:	5fa68693          	addi	a3,a3,1530 # ffffffffc020e6a8 <syscalls+0xa40>
ffffffffc02080b6:	00004617          	auipc	a2,0x4
ffffffffc02080ba:	b6260613          	addi	a2,a2,-1182 # ffffffffc020bc18 <commands+0x250>
ffffffffc02080be:	04f00593          	li	a1,79
ffffffffc02080c2:	00006517          	auipc	a0,0x6
ffffffffc02080c6:	5ce50513          	addi	a0,a0,1486 # ffffffffc020e690 <syscalls+0xa28>
ffffffffc02080ca:	964f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02080ce <vfs_lookup_parent>:
ffffffffc02080ce:	7139                	addi	sp,sp,-64
ffffffffc02080d0:	f822                	sd	s0,48(sp)
ffffffffc02080d2:	f426                	sd	s1,40(sp)
ffffffffc02080d4:	842e                	mv	s0,a1
ffffffffc02080d6:	84b2                	mv	s1,a2
ffffffffc02080d8:	002c                	addi	a1,sp,8
ffffffffc02080da:	0830                	addi	a2,sp,24
ffffffffc02080dc:	fc06                	sd	ra,56(sp)
ffffffffc02080de:	e42a                	sd	a0,8(sp)
ffffffffc02080e0:	e3fff0ef          	jal	ra,ffffffffc0207f1e <get_device>
ffffffffc02080e4:	e509                	bnez	a0,ffffffffc02080ee <vfs_lookup_parent+0x20>
ffffffffc02080e6:	67a2                	ld	a5,8(sp)
ffffffffc02080e8:	e09c                	sd	a5,0(s1)
ffffffffc02080ea:	67e2                	ld	a5,24(sp)
ffffffffc02080ec:	e01c                	sd	a5,0(s0)
ffffffffc02080ee:	70e2                	ld	ra,56(sp)
ffffffffc02080f0:	7442                	ld	s0,48(sp)
ffffffffc02080f2:	74a2                	ld	s1,40(sp)
ffffffffc02080f4:	6121                	addi	sp,sp,64
ffffffffc02080f6:	8082                	ret

ffffffffc02080f8 <vfs_open>:
ffffffffc02080f8:	711d                	addi	sp,sp,-96
ffffffffc02080fa:	e4a6                	sd	s1,72(sp)
ffffffffc02080fc:	e0ca                	sd	s2,64(sp)
ffffffffc02080fe:	fc4e                	sd	s3,56(sp)
ffffffffc0208100:	ec86                	sd	ra,88(sp)
ffffffffc0208102:	e8a2                	sd	s0,80(sp)
ffffffffc0208104:	f852                	sd	s4,48(sp)
ffffffffc0208106:	f456                	sd	s5,40(sp)
ffffffffc0208108:	0035f793          	andi	a5,a1,3
ffffffffc020810c:	84ae                	mv	s1,a1
ffffffffc020810e:	892a                	mv	s2,a0
ffffffffc0208110:	89b2                	mv	s3,a2
ffffffffc0208112:	0e078663          	beqz	a5,ffffffffc02081fe <vfs_open+0x106>
ffffffffc0208116:	470d                	li	a4,3
ffffffffc0208118:	0105fa93          	andi	s5,a1,16
ffffffffc020811c:	0ce78f63          	beq	a5,a4,ffffffffc02081fa <vfs_open+0x102>
ffffffffc0208120:	002c                	addi	a1,sp,8
ffffffffc0208122:	854a                	mv	a0,s2
ffffffffc0208124:	f15ff0ef          	jal	ra,ffffffffc0208038 <vfs_lookup>
ffffffffc0208128:	842a                	mv	s0,a0
ffffffffc020812a:	0044fa13          	andi	s4,s1,4
ffffffffc020812e:	e159                	bnez	a0,ffffffffc02081b4 <vfs_open+0xbc>
ffffffffc0208130:	00c4f793          	andi	a5,s1,12
ffffffffc0208134:	4731                	li	a4,12
ffffffffc0208136:	0ee78263          	beq	a5,a4,ffffffffc020821a <vfs_open+0x122>
ffffffffc020813a:	6422                	ld	s0,8(sp)
ffffffffc020813c:	12040163          	beqz	s0,ffffffffc020825e <vfs_open+0x166>
ffffffffc0208140:	783c                	ld	a5,112(s0)
ffffffffc0208142:	cff1                	beqz	a5,ffffffffc020821e <vfs_open+0x126>
ffffffffc0208144:	679c                	ld	a5,8(a5)
ffffffffc0208146:	cfe1                	beqz	a5,ffffffffc020821e <vfs_open+0x126>
ffffffffc0208148:	8522                	mv	a0,s0
ffffffffc020814a:	00006597          	auipc	a1,0x6
ffffffffc020814e:	68658593          	addi	a1,a1,1670 # ffffffffc020e7d0 <syscalls+0xb68>
ffffffffc0208152:	1fe000ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0208156:	783c                	ld	a5,112(s0)
ffffffffc0208158:	6522                	ld	a0,8(sp)
ffffffffc020815a:	85a6                	mv	a1,s1
ffffffffc020815c:	679c                	ld	a5,8(a5)
ffffffffc020815e:	9782                	jalr	a5
ffffffffc0208160:	842a                	mv	s0,a0
ffffffffc0208162:	6522                	ld	a0,8(sp)
ffffffffc0208164:	e845                	bnez	s0,ffffffffc0208214 <vfs_open+0x11c>
ffffffffc0208166:	015a6a33          	or	s4,s4,s5
ffffffffc020816a:	1da000ef          	jal	ra,ffffffffc0208344 <inode_open_inc>
ffffffffc020816e:	020a0663          	beqz	s4,ffffffffc020819a <vfs_open+0xa2>
ffffffffc0208172:	64a2                	ld	s1,8(sp)
ffffffffc0208174:	c4e9                	beqz	s1,ffffffffc020823e <vfs_open+0x146>
ffffffffc0208176:	78bc                	ld	a5,112(s1)
ffffffffc0208178:	c3f9                	beqz	a5,ffffffffc020823e <vfs_open+0x146>
ffffffffc020817a:	73bc                	ld	a5,96(a5)
ffffffffc020817c:	c3e9                	beqz	a5,ffffffffc020823e <vfs_open+0x146>
ffffffffc020817e:	00006597          	auipc	a1,0x6
ffffffffc0208182:	6b258593          	addi	a1,a1,1714 # ffffffffc020e830 <syscalls+0xbc8>
ffffffffc0208186:	8526                	mv	a0,s1
ffffffffc0208188:	1c8000ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc020818c:	78bc                	ld	a5,112(s1)
ffffffffc020818e:	6522                	ld	a0,8(sp)
ffffffffc0208190:	4581                	li	a1,0
ffffffffc0208192:	73bc                	ld	a5,96(a5)
ffffffffc0208194:	9782                	jalr	a5
ffffffffc0208196:	87aa                	mv	a5,a0
ffffffffc0208198:	e92d                	bnez	a0,ffffffffc020820a <vfs_open+0x112>
ffffffffc020819a:	67a2                	ld	a5,8(sp)
ffffffffc020819c:	00f9b023          	sd	a5,0(s3)
ffffffffc02081a0:	60e6                	ld	ra,88(sp)
ffffffffc02081a2:	8522                	mv	a0,s0
ffffffffc02081a4:	6446                	ld	s0,80(sp)
ffffffffc02081a6:	64a6                	ld	s1,72(sp)
ffffffffc02081a8:	6906                	ld	s2,64(sp)
ffffffffc02081aa:	79e2                	ld	s3,56(sp)
ffffffffc02081ac:	7a42                	ld	s4,48(sp)
ffffffffc02081ae:	7aa2                	ld	s5,40(sp)
ffffffffc02081b0:	6125                	addi	sp,sp,96
ffffffffc02081b2:	8082                	ret
ffffffffc02081b4:	57c1                	li	a5,-16
ffffffffc02081b6:	fef515e3          	bne	a0,a5,ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc02081ba:	fe0a03e3          	beqz	s4,ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc02081be:	0810                	addi	a2,sp,16
ffffffffc02081c0:	082c                	addi	a1,sp,24
ffffffffc02081c2:	854a                	mv	a0,s2
ffffffffc02081c4:	f0bff0ef          	jal	ra,ffffffffc02080ce <vfs_lookup_parent>
ffffffffc02081c8:	842a                	mv	s0,a0
ffffffffc02081ca:	f979                	bnez	a0,ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc02081cc:	6462                	ld	s0,24(sp)
ffffffffc02081ce:	c845                	beqz	s0,ffffffffc020827e <vfs_open+0x186>
ffffffffc02081d0:	783c                	ld	a5,112(s0)
ffffffffc02081d2:	c7d5                	beqz	a5,ffffffffc020827e <vfs_open+0x186>
ffffffffc02081d4:	77bc                	ld	a5,104(a5)
ffffffffc02081d6:	c7c5                	beqz	a5,ffffffffc020827e <vfs_open+0x186>
ffffffffc02081d8:	8522                	mv	a0,s0
ffffffffc02081da:	00006597          	auipc	a1,0x6
ffffffffc02081de:	58e58593          	addi	a1,a1,1422 # ffffffffc020e768 <syscalls+0xb00>
ffffffffc02081e2:	16e000ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc02081e6:	783c                	ld	a5,112(s0)
ffffffffc02081e8:	65c2                	ld	a1,16(sp)
ffffffffc02081ea:	6562                	ld	a0,24(sp)
ffffffffc02081ec:	77bc                	ld	a5,104(a5)
ffffffffc02081ee:	4034d613          	srai	a2,s1,0x3
ffffffffc02081f2:	0034                	addi	a3,sp,8
ffffffffc02081f4:	8a05                	andi	a2,a2,1
ffffffffc02081f6:	9782                	jalr	a5
ffffffffc02081f8:	b789                	j	ffffffffc020813a <vfs_open+0x42>
ffffffffc02081fa:	5475                	li	s0,-3
ffffffffc02081fc:	b755                	j	ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc02081fe:	0105fa93          	andi	s5,a1,16
ffffffffc0208202:	5475                	li	s0,-3
ffffffffc0208204:	f80a9ee3          	bnez	s5,ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc0208208:	bf21                	j	ffffffffc0208120 <vfs_open+0x28>
ffffffffc020820a:	6522                	ld	a0,8(sp)
ffffffffc020820c:	843e                	mv	s0,a5
ffffffffc020820e:	2a0000ef          	jal	ra,ffffffffc02084ae <inode_open_dec>
ffffffffc0208212:	6522                	ld	a0,8(sp)
ffffffffc0208214:	1f2000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc0208218:	b761                	j	ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc020821a:	5425                	li	s0,-23
ffffffffc020821c:	b751                	j	ffffffffc02081a0 <vfs_open+0xa8>
ffffffffc020821e:	00006697          	auipc	a3,0x6
ffffffffc0208222:	56268693          	addi	a3,a3,1378 # ffffffffc020e780 <syscalls+0xb18>
ffffffffc0208226:	00004617          	auipc	a2,0x4
ffffffffc020822a:	9f260613          	addi	a2,a2,-1550 # ffffffffc020bc18 <commands+0x250>
ffffffffc020822e:	03300593          	li	a1,51
ffffffffc0208232:	00006517          	auipc	a0,0x6
ffffffffc0208236:	51e50513          	addi	a0,a0,1310 # ffffffffc020e750 <syscalls+0xae8>
ffffffffc020823a:	ff5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020823e:	00006697          	auipc	a3,0x6
ffffffffc0208242:	59a68693          	addi	a3,a3,1434 # ffffffffc020e7d8 <syscalls+0xb70>
ffffffffc0208246:	00004617          	auipc	a2,0x4
ffffffffc020824a:	9d260613          	addi	a2,a2,-1582 # ffffffffc020bc18 <commands+0x250>
ffffffffc020824e:	03a00593          	li	a1,58
ffffffffc0208252:	00006517          	auipc	a0,0x6
ffffffffc0208256:	4fe50513          	addi	a0,a0,1278 # ffffffffc020e750 <syscalls+0xae8>
ffffffffc020825a:	fd5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020825e:	00006697          	auipc	a3,0x6
ffffffffc0208262:	51268693          	addi	a3,a3,1298 # ffffffffc020e770 <syscalls+0xb08>
ffffffffc0208266:	00004617          	auipc	a2,0x4
ffffffffc020826a:	9b260613          	addi	a2,a2,-1614 # ffffffffc020bc18 <commands+0x250>
ffffffffc020826e:	03100593          	li	a1,49
ffffffffc0208272:	00006517          	auipc	a0,0x6
ffffffffc0208276:	4de50513          	addi	a0,a0,1246 # ffffffffc020e750 <syscalls+0xae8>
ffffffffc020827a:	fb5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020827e:	00006697          	auipc	a3,0x6
ffffffffc0208282:	48268693          	addi	a3,a3,1154 # ffffffffc020e700 <syscalls+0xa98>
ffffffffc0208286:	00004617          	auipc	a2,0x4
ffffffffc020828a:	99260613          	addi	a2,a2,-1646 # ffffffffc020bc18 <commands+0x250>
ffffffffc020828e:	02c00593          	li	a1,44
ffffffffc0208292:	00006517          	auipc	a0,0x6
ffffffffc0208296:	4be50513          	addi	a0,a0,1214 # ffffffffc020e750 <syscalls+0xae8>
ffffffffc020829a:	f95f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020829e <vfs_close>:
ffffffffc020829e:	1141                	addi	sp,sp,-16
ffffffffc02082a0:	e406                	sd	ra,8(sp)
ffffffffc02082a2:	e022                	sd	s0,0(sp)
ffffffffc02082a4:	842a                	mv	s0,a0
ffffffffc02082a6:	208000ef          	jal	ra,ffffffffc02084ae <inode_open_dec>
ffffffffc02082aa:	8522                	mv	a0,s0
ffffffffc02082ac:	15a000ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc02082b0:	60a2                	ld	ra,8(sp)
ffffffffc02082b2:	6402                	ld	s0,0(sp)
ffffffffc02082b4:	4501                	li	a0,0
ffffffffc02082b6:	0141                	addi	sp,sp,16
ffffffffc02082b8:	8082                	ret

ffffffffc02082ba <__alloc_inode>:
ffffffffc02082ba:	1141                	addi	sp,sp,-16
ffffffffc02082bc:	e022                	sd	s0,0(sp)
ffffffffc02082be:	842a                	mv	s0,a0
ffffffffc02082c0:	07800513          	li	a0,120
ffffffffc02082c4:	e406                	sd	ra,8(sp)
ffffffffc02082c6:	ae9f90ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc02082ca:	c111                	beqz	a0,ffffffffc02082ce <__alloc_inode+0x14>
ffffffffc02082cc:	cd20                	sw	s0,88(a0)
ffffffffc02082ce:	60a2                	ld	ra,8(sp)
ffffffffc02082d0:	6402                	ld	s0,0(sp)
ffffffffc02082d2:	0141                	addi	sp,sp,16
ffffffffc02082d4:	8082                	ret

ffffffffc02082d6 <inode_init>:
ffffffffc02082d6:	4785                	li	a5,1
ffffffffc02082d8:	06052023          	sw	zero,96(a0)
ffffffffc02082dc:	f92c                	sd	a1,112(a0)
ffffffffc02082de:	f530                	sd	a2,104(a0)
ffffffffc02082e0:	cd7c                	sw	a5,92(a0)
ffffffffc02082e2:	8082                	ret

ffffffffc02082e4 <inode_kill>:
ffffffffc02082e4:	4d78                	lw	a4,92(a0)
ffffffffc02082e6:	1141                	addi	sp,sp,-16
ffffffffc02082e8:	e406                	sd	ra,8(sp)
ffffffffc02082ea:	e719                	bnez	a4,ffffffffc02082f8 <inode_kill+0x14>
ffffffffc02082ec:	513c                	lw	a5,96(a0)
ffffffffc02082ee:	e78d                	bnez	a5,ffffffffc0208318 <inode_kill+0x34>
ffffffffc02082f0:	60a2                	ld	ra,8(sp)
ffffffffc02082f2:	0141                	addi	sp,sp,16
ffffffffc02082f4:	b6bf906f          	j	ffffffffc0201e5e <kfree>
ffffffffc02082f8:	00006697          	auipc	a3,0x6
ffffffffc02082fc:	54868693          	addi	a3,a3,1352 # ffffffffc020e840 <syscalls+0xbd8>
ffffffffc0208300:	00004617          	auipc	a2,0x4
ffffffffc0208304:	91860613          	addi	a2,a2,-1768 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208308:	02900593          	li	a1,41
ffffffffc020830c:	00006517          	auipc	a0,0x6
ffffffffc0208310:	55450513          	addi	a0,a0,1364 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc0208314:	f1bf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208318:	00006697          	auipc	a3,0x6
ffffffffc020831c:	56068693          	addi	a3,a3,1376 # ffffffffc020e878 <syscalls+0xc10>
ffffffffc0208320:	00004617          	auipc	a2,0x4
ffffffffc0208324:	8f860613          	addi	a2,a2,-1800 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208328:	02a00593          	li	a1,42
ffffffffc020832c:	00006517          	auipc	a0,0x6
ffffffffc0208330:	53450513          	addi	a0,a0,1332 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc0208334:	efbf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208338 <inode_ref_inc>:
ffffffffc0208338:	4d7c                	lw	a5,92(a0)
ffffffffc020833a:	2785                	addiw	a5,a5,1
ffffffffc020833c:	cd7c                	sw	a5,92(a0)
ffffffffc020833e:	0007851b          	sext.w	a0,a5
ffffffffc0208342:	8082                	ret

ffffffffc0208344 <inode_open_inc>:
ffffffffc0208344:	513c                	lw	a5,96(a0)
ffffffffc0208346:	2785                	addiw	a5,a5,1
ffffffffc0208348:	d13c                	sw	a5,96(a0)
ffffffffc020834a:	0007851b          	sext.w	a0,a5
ffffffffc020834e:	8082                	ret

ffffffffc0208350 <inode_check>:
ffffffffc0208350:	1141                	addi	sp,sp,-16
ffffffffc0208352:	e406                	sd	ra,8(sp)
ffffffffc0208354:	c90d                	beqz	a0,ffffffffc0208386 <inode_check+0x36>
ffffffffc0208356:	793c                	ld	a5,112(a0)
ffffffffc0208358:	c79d                	beqz	a5,ffffffffc0208386 <inode_check+0x36>
ffffffffc020835a:	6398                	ld	a4,0(a5)
ffffffffc020835c:	4625d7b7          	lui	a5,0x4625d
ffffffffc0208360:	0786                	slli	a5,a5,0x1
ffffffffc0208362:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0208366:	08f71063          	bne	a4,a5,ffffffffc02083e6 <inode_check+0x96>
ffffffffc020836a:	4d78                	lw	a4,92(a0)
ffffffffc020836c:	513c                	lw	a5,96(a0)
ffffffffc020836e:	04f74c63          	blt	a4,a5,ffffffffc02083c6 <inode_check+0x76>
ffffffffc0208372:	0407ca63          	bltz	a5,ffffffffc02083c6 <inode_check+0x76>
ffffffffc0208376:	66c1                	lui	a3,0x10
ffffffffc0208378:	02d75763          	bge	a4,a3,ffffffffc02083a6 <inode_check+0x56>
ffffffffc020837c:	02d7d563          	bge	a5,a3,ffffffffc02083a6 <inode_check+0x56>
ffffffffc0208380:	60a2                	ld	ra,8(sp)
ffffffffc0208382:	0141                	addi	sp,sp,16
ffffffffc0208384:	8082                	ret
ffffffffc0208386:	00006697          	auipc	a3,0x6
ffffffffc020838a:	51268693          	addi	a3,a3,1298 # ffffffffc020e898 <syscalls+0xc30>
ffffffffc020838e:	00004617          	auipc	a2,0x4
ffffffffc0208392:	88a60613          	addi	a2,a2,-1910 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208396:	06e00593          	li	a1,110
ffffffffc020839a:	00006517          	auipc	a0,0x6
ffffffffc020839e:	4c650513          	addi	a0,a0,1222 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc02083a2:	e8df70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02083a6:	00006697          	auipc	a3,0x6
ffffffffc02083aa:	57268693          	addi	a3,a3,1394 # ffffffffc020e918 <syscalls+0xcb0>
ffffffffc02083ae:	00004617          	auipc	a2,0x4
ffffffffc02083b2:	86a60613          	addi	a2,a2,-1942 # ffffffffc020bc18 <commands+0x250>
ffffffffc02083b6:	07200593          	li	a1,114
ffffffffc02083ba:	00006517          	auipc	a0,0x6
ffffffffc02083be:	4a650513          	addi	a0,a0,1190 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc02083c2:	e6df70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02083c6:	00006697          	auipc	a3,0x6
ffffffffc02083ca:	52268693          	addi	a3,a3,1314 # ffffffffc020e8e8 <syscalls+0xc80>
ffffffffc02083ce:	00004617          	auipc	a2,0x4
ffffffffc02083d2:	84a60613          	addi	a2,a2,-1974 # ffffffffc020bc18 <commands+0x250>
ffffffffc02083d6:	07100593          	li	a1,113
ffffffffc02083da:	00006517          	auipc	a0,0x6
ffffffffc02083de:	48650513          	addi	a0,a0,1158 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc02083e2:	e4df70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02083e6:	00006697          	auipc	a3,0x6
ffffffffc02083ea:	4da68693          	addi	a3,a3,1242 # ffffffffc020e8c0 <syscalls+0xc58>
ffffffffc02083ee:	00004617          	auipc	a2,0x4
ffffffffc02083f2:	82a60613          	addi	a2,a2,-2006 # ffffffffc020bc18 <commands+0x250>
ffffffffc02083f6:	06f00593          	li	a1,111
ffffffffc02083fa:	00006517          	auipc	a0,0x6
ffffffffc02083fe:	46650513          	addi	a0,a0,1126 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc0208402:	e2df70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208406 <inode_ref_dec>:
ffffffffc0208406:	4d7c                	lw	a5,92(a0)
ffffffffc0208408:	1101                	addi	sp,sp,-32
ffffffffc020840a:	ec06                	sd	ra,24(sp)
ffffffffc020840c:	e822                	sd	s0,16(sp)
ffffffffc020840e:	e426                	sd	s1,8(sp)
ffffffffc0208410:	e04a                	sd	s2,0(sp)
ffffffffc0208412:	06f05e63          	blez	a5,ffffffffc020848e <inode_ref_dec+0x88>
ffffffffc0208416:	fff7849b          	addiw	s1,a5,-1
ffffffffc020841a:	cd64                	sw	s1,92(a0)
ffffffffc020841c:	842a                	mv	s0,a0
ffffffffc020841e:	e09d                	bnez	s1,ffffffffc0208444 <inode_ref_dec+0x3e>
ffffffffc0208420:	793c                	ld	a5,112(a0)
ffffffffc0208422:	c7b1                	beqz	a5,ffffffffc020846e <inode_ref_dec+0x68>
ffffffffc0208424:	0487b903          	ld	s2,72(a5)
ffffffffc0208428:	04090363          	beqz	s2,ffffffffc020846e <inode_ref_dec+0x68>
ffffffffc020842c:	00006597          	auipc	a1,0x6
ffffffffc0208430:	59c58593          	addi	a1,a1,1436 # ffffffffc020e9c8 <syscalls+0xd60>
ffffffffc0208434:	f1dff0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0208438:	8522                	mv	a0,s0
ffffffffc020843a:	9902                	jalr	s2
ffffffffc020843c:	c501                	beqz	a0,ffffffffc0208444 <inode_ref_dec+0x3e>
ffffffffc020843e:	57c5                	li	a5,-15
ffffffffc0208440:	00f51963          	bne	a0,a5,ffffffffc0208452 <inode_ref_dec+0x4c>
ffffffffc0208444:	60e2                	ld	ra,24(sp)
ffffffffc0208446:	6442                	ld	s0,16(sp)
ffffffffc0208448:	6902                	ld	s2,0(sp)
ffffffffc020844a:	8526                	mv	a0,s1
ffffffffc020844c:	64a2                	ld	s1,8(sp)
ffffffffc020844e:	6105                	addi	sp,sp,32
ffffffffc0208450:	8082                	ret
ffffffffc0208452:	85aa                	mv	a1,a0
ffffffffc0208454:	00006517          	auipc	a0,0x6
ffffffffc0208458:	57c50513          	addi	a0,a0,1404 # ffffffffc020e9d0 <syscalls+0xd68>
ffffffffc020845c:	ccff70ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0208460:	60e2                	ld	ra,24(sp)
ffffffffc0208462:	6442                	ld	s0,16(sp)
ffffffffc0208464:	6902                	ld	s2,0(sp)
ffffffffc0208466:	8526                	mv	a0,s1
ffffffffc0208468:	64a2                	ld	s1,8(sp)
ffffffffc020846a:	6105                	addi	sp,sp,32
ffffffffc020846c:	8082                	ret
ffffffffc020846e:	00006697          	auipc	a3,0x6
ffffffffc0208472:	50a68693          	addi	a3,a3,1290 # ffffffffc020e978 <syscalls+0xd10>
ffffffffc0208476:	00003617          	auipc	a2,0x3
ffffffffc020847a:	7a260613          	addi	a2,a2,1954 # ffffffffc020bc18 <commands+0x250>
ffffffffc020847e:	04400593          	li	a1,68
ffffffffc0208482:	00006517          	auipc	a0,0x6
ffffffffc0208486:	3de50513          	addi	a0,a0,990 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc020848a:	da5f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020848e:	00006697          	auipc	a3,0x6
ffffffffc0208492:	4ca68693          	addi	a3,a3,1226 # ffffffffc020e958 <syscalls+0xcf0>
ffffffffc0208496:	00003617          	auipc	a2,0x3
ffffffffc020849a:	78260613          	addi	a2,a2,1922 # ffffffffc020bc18 <commands+0x250>
ffffffffc020849e:	03f00593          	li	a1,63
ffffffffc02084a2:	00006517          	auipc	a0,0x6
ffffffffc02084a6:	3be50513          	addi	a0,a0,958 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc02084aa:	d85f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02084ae <inode_open_dec>:
ffffffffc02084ae:	513c                	lw	a5,96(a0)
ffffffffc02084b0:	1101                	addi	sp,sp,-32
ffffffffc02084b2:	ec06                	sd	ra,24(sp)
ffffffffc02084b4:	e822                	sd	s0,16(sp)
ffffffffc02084b6:	e426                	sd	s1,8(sp)
ffffffffc02084b8:	e04a                	sd	s2,0(sp)
ffffffffc02084ba:	06f05b63          	blez	a5,ffffffffc0208530 <inode_open_dec+0x82>
ffffffffc02084be:	fff7849b          	addiw	s1,a5,-1
ffffffffc02084c2:	d124                	sw	s1,96(a0)
ffffffffc02084c4:	842a                	mv	s0,a0
ffffffffc02084c6:	e085                	bnez	s1,ffffffffc02084e6 <inode_open_dec+0x38>
ffffffffc02084c8:	793c                	ld	a5,112(a0)
ffffffffc02084ca:	c3b9                	beqz	a5,ffffffffc0208510 <inode_open_dec+0x62>
ffffffffc02084cc:	0107b903          	ld	s2,16(a5)
ffffffffc02084d0:	04090063          	beqz	s2,ffffffffc0208510 <inode_open_dec+0x62>
ffffffffc02084d4:	00006597          	auipc	a1,0x6
ffffffffc02084d8:	58c58593          	addi	a1,a1,1420 # ffffffffc020ea60 <syscalls+0xdf8>
ffffffffc02084dc:	e75ff0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc02084e0:	8522                	mv	a0,s0
ffffffffc02084e2:	9902                	jalr	s2
ffffffffc02084e4:	e901                	bnez	a0,ffffffffc02084f4 <inode_open_dec+0x46>
ffffffffc02084e6:	60e2                	ld	ra,24(sp)
ffffffffc02084e8:	6442                	ld	s0,16(sp)
ffffffffc02084ea:	6902                	ld	s2,0(sp)
ffffffffc02084ec:	8526                	mv	a0,s1
ffffffffc02084ee:	64a2                	ld	s1,8(sp)
ffffffffc02084f0:	6105                	addi	sp,sp,32
ffffffffc02084f2:	8082                	ret
ffffffffc02084f4:	85aa                	mv	a1,a0
ffffffffc02084f6:	00006517          	auipc	a0,0x6
ffffffffc02084fa:	57250513          	addi	a0,a0,1394 # ffffffffc020ea68 <syscalls+0xe00>
ffffffffc02084fe:	c2df70ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0208502:	60e2                	ld	ra,24(sp)
ffffffffc0208504:	6442                	ld	s0,16(sp)
ffffffffc0208506:	6902                	ld	s2,0(sp)
ffffffffc0208508:	8526                	mv	a0,s1
ffffffffc020850a:	64a2                	ld	s1,8(sp)
ffffffffc020850c:	6105                	addi	sp,sp,32
ffffffffc020850e:	8082                	ret
ffffffffc0208510:	00006697          	auipc	a3,0x6
ffffffffc0208514:	50068693          	addi	a3,a3,1280 # ffffffffc020ea10 <syscalls+0xda8>
ffffffffc0208518:	00003617          	auipc	a2,0x3
ffffffffc020851c:	70060613          	addi	a2,a2,1792 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208520:	06100593          	li	a1,97
ffffffffc0208524:	00006517          	auipc	a0,0x6
ffffffffc0208528:	33c50513          	addi	a0,a0,828 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc020852c:	d03f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208530:	00006697          	auipc	a3,0x6
ffffffffc0208534:	4c068693          	addi	a3,a3,1216 # ffffffffc020e9f0 <syscalls+0xd88>
ffffffffc0208538:	00003617          	auipc	a2,0x3
ffffffffc020853c:	6e060613          	addi	a2,a2,1760 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208540:	05c00593          	li	a1,92
ffffffffc0208544:	00006517          	auipc	a0,0x6
ffffffffc0208548:	31c50513          	addi	a0,a0,796 # ffffffffc020e860 <syscalls+0xbf8>
ffffffffc020854c:	ce3f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208550 <__alloc_fs>:
ffffffffc0208550:	1141                	addi	sp,sp,-16
ffffffffc0208552:	e022                	sd	s0,0(sp)
ffffffffc0208554:	842a                	mv	s0,a0
ffffffffc0208556:	0d800513          	li	a0,216
ffffffffc020855a:	e406                	sd	ra,8(sp)
ffffffffc020855c:	853f90ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0208560:	c119                	beqz	a0,ffffffffc0208566 <__alloc_fs+0x16>
ffffffffc0208562:	0a852823          	sw	s0,176(a0)
ffffffffc0208566:	60a2                	ld	ra,8(sp)
ffffffffc0208568:	6402                	ld	s0,0(sp)
ffffffffc020856a:	0141                	addi	sp,sp,16
ffffffffc020856c:	8082                	ret

ffffffffc020856e <vfs_init>:
ffffffffc020856e:	1141                	addi	sp,sp,-16
ffffffffc0208570:	4585                	li	a1,1
ffffffffc0208572:	0008d517          	auipc	a0,0x8d
ffffffffc0208576:	2b650513          	addi	a0,a0,694 # ffffffffc0295828 <bootfs_sem>
ffffffffc020857a:	e406                	sd	ra,8(sp)
ffffffffc020857c:	a5afc0ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc0208580:	60a2                	ld	ra,8(sp)
ffffffffc0208582:	0141                	addi	sp,sp,16
ffffffffc0208584:	d0aff06f          	j	ffffffffc0207a8e <vfs_devlist_init>

ffffffffc0208588 <vfs_set_bootfs>:
ffffffffc0208588:	7179                	addi	sp,sp,-48
ffffffffc020858a:	f022                	sd	s0,32(sp)
ffffffffc020858c:	f406                	sd	ra,40(sp)
ffffffffc020858e:	ec26                	sd	s1,24(sp)
ffffffffc0208590:	e402                	sd	zero,8(sp)
ffffffffc0208592:	842a                	mv	s0,a0
ffffffffc0208594:	c915                	beqz	a0,ffffffffc02085c8 <vfs_set_bootfs+0x40>
ffffffffc0208596:	03a00593          	li	a1,58
ffffffffc020859a:	46f020ef          	jal	ra,ffffffffc020b208 <strchr>
ffffffffc020859e:	c135                	beqz	a0,ffffffffc0208602 <vfs_set_bootfs+0x7a>
ffffffffc02085a0:	00154783          	lbu	a5,1(a0)
ffffffffc02085a4:	efb9                	bnez	a5,ffffffffc0208602 <vfs_set_bootfs+0x7a>
ffffffffc02085a6:	8522                	mv	a0,s0
ffffffffc02085a8:	86bff0ef          	jal	ra,ffffffffc0207e12 <vfs_chdir>
ffffffffc02085ac:	842a                	mv	s0,a0
ffffffffc02085ae:	c519                	beqz	a0,ffffffffc02085bc <vfs_set_bootfs+0x34>
ffffffffc02085b0:	70a2                	ld	ra,40(sp)
ffffffffc02085b2:	8522                	mv	a0,s0
ffffffffc02085b4:	7402                	ld	s0,32(sp)
ffffffffc02085b6:	64e2                	ld	s1,24(sp)
ffffffffc02085b8:	6145                	addi	sp,sp,48
ffffffffc02085ba:	8082                	ret
ffffffffc02085bc:	0028                	addi	a0,sp,8
ffffffffc02085be:	f5eff0ef          	jal	ra,ffffffffc0207d1c <vfs_get_curdir>
ffffffffc02085c2:	842a                	mv	s0,a0
ffffffffc02085c4:	f575                	bnez	a0,ffffffffc02085b0 <vfs_set_bootfs+0x28>
ffffffffc02085c6:	6422                	ld	s0,8(sp)
ffffffffc02085c8:	0008d517          	auipc	a0,0x8d
ffffffffc02085cc:	26050513          	addi	a0,a0,608 # ffffffffc0295828 <bootfs_sem>
ffffffffc02085d0:	a12fc0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc02085d4:	0008e797          	auipc	a5,0x8e
ffffffffc02085d8:	31c78793          	addi	a5,a5,796 # ffffffffc02968f0 <bootfs_node>
ffffffffc02085dc:	6384                	ld	s1,0(a5)
ffffffffc02085de:	0008d517          	auipc	a0,0x8d
ffffffffc02085e2:	24a50513          	addi	a0,a0,586 # ffffffffc0295828 <bootfs_sem>
ffffffffc02085e6:	e380                	sd	s0,0(a5)
ffffffffc02085e8:	4401                	li	s0,0
ffffffffc02085ea:	9f4fc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc02085ee:	d0e9                	beqz	s1,ffffffffc02085b0 <vfs_set_bootfs+0x28>
ffffffffc02085f0:	8526                	mv	a0,s1
ffffffffc02085f2:	e15ff0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc02085f6:	70a2                	ld	ra,40(sp)
ffffffffc02085f8:	8522                	mv	a0,s0
ffffffffc02085fa:	7402                	ld	s0,32(sp)
ffffffffc02085fc:	64e2                	ld	s1,24(sp)
ffffffffc02085fe:	6145                	addi	sp,sp,48
ffffffffc0208600:	8082                	ret
ffffffffc0208602:	5475                	li	s0,-3
ffffffffc0208604:	b775                	j	ffffffffc02085b0 <vfs_set_bootfs+0x28>

ffffffffc0208606 <vfs_get_bootfs>:
ffffffffc0208606:	1101                	addi	sp,sp,-32
ffffffffc0208608:	e426                	sd	s1,8(sp)
ffffffffc020860a:	0008e497          	auipc	s1,0x8e
ffffffffc020860e:	2e648493          	addi	s1,s1,742 # ffffffffc02968f0 <bootfs_node>
ffffffffc0208612:	609c                	ld	a5,0(s1)
ffffffffc0208614:	ec06                	sd	ra,24(sp)
ffffffffc0208616:	e822                	sd	s0,16(sp)
ffffffffc0208618:	c3a1                	beqz	a5,ffffffffc0208658 <vfs_get_bootfs+0x52>
ffffffffc020861a:	842a                	mv	s0,a0
ffffffffc020861c:	0008d517          	auipc	a0,0x8d
ffffffffc0208620:	20c50513          	addi	a0,a0,524 # ffffffffc0295828 <bootfs_sem>
ffffffffc0208624:	9befc0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0208628:	6084                	ld	s1,0(s1)
ffffffffc020862a:	c08d                	beqz	s1,ffffffffc020864c <vfs_get_bootfs+0x46>
ffffffffc020862c:	8526                	mv	a0,s1
ffffffffc020862e:	d0bff0ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0208632:	0008d517          	auipc	a0,0x8d
ffffffffc0208636:	1f650513          	addi	a0,a0,502 # ffffffffc0295828 <bootfs_sem>
ffffffffc020863a:	9a4fc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020863e:	4501                	li	a0,0
ffffffffc0208640:	e004                	sd	s1,0(s0)
ffffffffc0208642:	60e2                	ld	ra,24(sp)
ffffffffc0208644:	6442                	ld	s0,16(sp)
ffffffffc0208646:	64a2                	ld	s1,8(sp)
ffffffffc0208648:	6105                	addi	sp,sp,32
ffffffffc020864a:	8082                	ret
ffffffffc020864c:	0008d517          	auipc	a0,0x8d
ffffffffc0208650:	1dc50513          	addi	a0,a0,476 # ffffffffc0295828 <bootfs_sem>
ffffffffc0208654:	98afc0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0208658:	5541                	li	a0,-16
ffffffffc020865a:	b7e5                	j	ffffffffc0208642 <vfs_get_bootfs+0x3c>

ffffffffc020865c <stdin_open>:
ffffffffc020865c:	4501                	li	a0,0
ffffffffc020865e:	e191                	bnez	a1,ffffffffc0208662 <stdin_open+0x6>
ffffffffc0208660:	8082                	ret
ffffffffc0208662:	5575                	li	a0,-3
ffffffffc0208664:	8082                	ret

ffffffffc0208666 <stdin_close>:
ffffffffc0208666:	4501                	li	a0,0
ffffffffc0208668:	8082                	ret

ffffffffc020866a <stdin_ioctl>:
ffffffffc020866a:	5575                	li	a0,-3
ffffffffc020866c:	8082                	ret

ffffffffc020866e <stdin_io>:
ffffffffc020866e:	7135                	addi	sp,sp,-160
ffffffffc0208670:	ed06                	sd	ra,152(sp)
ffffffffc0208672:	e922                	sd	s0,144(sp)
ffffffffc0208674:	e526                	sd	s1,136(sp)
ffffffffc0208676:	e14a                	sd	s2,128(sp)
ffffffffc0208678:	fcce                	sd	s3,120(sp)
ffffffffc020867a:	f8d2                	sd	s4,112(sp)
ffffffffc020867c:	f4d6                	sd	s5,104(sp)
ffffffffc020867e:	f0da                	sd	s6,96(sp)
ffffffffc0208680:	ecde                	sd	s7,88(sp)
ffffffffc0208682:	e8e2                	sd	s8,80(sp)
ffffffffc0208684:	e4e6                	sd	s9,72(sp)
ffffffffc0208686:	e0ea                	sd	s10,64(sp)
ffffffffc0208688:	fc6e                	sd	s11,56(sp)
ffffffffc020868a:	14061163          	bnez	a2,ffffffffc02087cc <stdin_io+0x15e>
ffffffffc020868e:	0005bd83          	ld	s11,0(a1)
ffffffffc0208692:	0185bd03          	ld	s10,24(a1)
ffffffffc0208696:	8b2e                	mv	s6,a1
ffffffffc0208698:	100027f3          	csrr	a5,sstatus
ffffffffc020869c:	8b89                	andi	a5,a5,2
ffffffffc020869e:	10079e63          	bnez	a5,ffffffffc02087ba <stdin_io+0x14c>
ffffffffc02086a2:	4401                	li	s0,0
ffffffffc02086a4:	100d0963          	beqz	s10,ffffffffc02087b6 <stdin_io+0x148>
ffffffffc02086a8:	0008e997          	auipc	s3,0x8e
ffffffffc02086ac:	25098993          	addi	s3,s3,592 # ffffffffc02968f8 <p_rpos>
ffffffffc02086b0:	0009b783          	ld	a5,0(s3)
ffffffffc02086b4:	800004b7          	lui	s1,0x80000
ffffffffc02086b8:	6c85                	lui	s9,0x1
ffffffffc02086ba:	4a81                	li	s5,0
ffffffffc02086bc:	0008ea17          	auipc	s4,0x8e
ffffffffc02086c0:	244a0a13          	addi	s4,s4,580 # ffffffffc0296900 <p_wpos>
ffffffffc02086c4:	0491                	addi	s1,s1,4
ffffffffc02086c6:	0008d917          	auipc	s2,0x8d
ffffffffc02086ca:	17a90913          	addi	s2,s2,378 # ffffffffc0295840 <__wait_queue>
ffffffffc02086ce:	1cfd                	addi	s9,s9,-1
ffffffffc02086d0:	000a3703          	ld	a4,0(s4)
ffffffffc02086d4:	000a8c1b          	sext.w	s8,s5
ffffffffc02086d8:	8be2                	mv	s7,s8
ffffffffc02086da:	02e7d763          	bge	a5,a4,ffffffffc0208708 <stdin_io+0x9a>
ffffffffc02086de:	a859                	j	ffffffffc0208774 <stdin_io+0x106>
ffffffffc02086e0:	cd7fe0ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc02086e4:	100027f3          	csrr	a5,sstatus
ffffffffc02086e8:	8b89                	andi	a5,a5,2
ffffffffc02086ea:	4401                	li	s0,0
ffffffffc02086ec:	ef8d                	bnez	a5,ffffffffc0208726 <stdin_io+0xb8>
ffffffffc02086ee:	0028                	addi	a0,sp,8
ffffffffc02086f0:	e23fb0ef          	jal	ra,ffffffffc0204512 <wait_in_queue>
ffffffffc02086f4:	e121                	bnez	a0,ffffffffc0208734 <stdin_io+0xc6>
ffffffffc02086f6:	47c2                	lw	a5,16(sp)
ffffffffc02086f8:	04979563          	bne	a5,s1,ffffffffc0208742 <stdin_io+0xd4>
ffffffffc02086fc:	0009b783          	ld	a5,0(s3)
ffffffffc0208700:	000a3703          	ld	a4,0(s4)
ffffffffc0208704:	06e7c863          	blt	a5,a4,ffffffffc0208774 <stdin_io+0x106>
ffffffffc0208708:	8626                	mv	a2,s1
ffffffffc020870a:	002c                	addi	a1,sp,8
ffffffffc020870c:	854a                	mv	a0,s2
ffffffffc020870e:	f2ffb0ef          	jal	ra,ffffffffc020463c <wait_current_set>
ffffffffc0208712:	d479                	beqz	s0,ffffffffc02086e0 <stdin_io+0x72>
ffffffffc0208714:	e86f80ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc0208718:	c9ffe0ef          	jal	ra,ffffffffc02073b6 <schedule>
ffffffffc020871c:	100027f3          	csrr	a5,sstatus
ffffffffc0208720:	8b89                	andi	a5,a5,2
ffffffffc0208722:	4401                	li	s0,0
ffffffffc0208724:	d7e9                	beqz	a5,ffffffffc02086ee <stdin_io+0x80>
ffffffffc0208726:	e7af80ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020872a:	0028                	addi	a0,sp,8
ffffffffc020872c:	4405                	li	s0,1
ffffffffc020872e:	de5fb0ef          	jal	ra,ffffffffc0204512 <wait_in_queue>
ffffffffc0208732:	d171                	beqz	a0,ffffffffc02086f6 <stdin_io+0x88>
ffffffffc0208734:	002c                	addi	a1,sp,8
ffffffffc0208736:	854a                	mv	a0,s2
ffffffffc0208738:	d81fb0ef          	jal	ra,ffffffffc02044b8 <wait_queue_del>
ffffffffc020873c:	47c2                	lw	a5,16(sp)
ffffffffc020873e:	fa978fe3          	beq	a5,s1,ffffffffc02086fc <stdin_io+0x8e>
ffffffffc0208742:	e435                	bnez	s0,ffffffffc02087ae <stdin_io+0x140>
ffffffffc0208744:	060b8963          	beqz	s7,ffffffffc02087b6 <stdin_io+0x148>
ffffffffc0208748:	018b3783          	ld	a5,24(s6)
ffffffffc020874c:	41578ab3          	sub	s5,a5,s5
ffffffffc0208750:	015b3c23          	sd	s5,24(s6)
ffffffffc0208754:	60ea                	ld	ra,152(sp)
ffffffffc0208756:	644a                	ld	s0,144(sp)
ffffffffc0208758:	64aa                	ld	s1,136(sp)
ffffffffc020875a:	690a                	ld	s2,128(sp)
ffffffffc020875c:	79e6                	ld	s3,120(sp)
ffffffffc020875e:	7a46                	ld	s4,112(sp)
ffffffffc0208760:	7aa6                	ld	s5,104(sp)
ffffffffc0208762:	7b06                	ld	s6,96(sp)
ffffffffc0208764:	6c46                	ld	s8,80(sp)
ffffffffc0208766:	6ca6                	ld	s9,72(sp)
ffffffffc0208768:	6d06                	ld	s10,64(sp)
ffffffffc020876a:	7de2                	ld	s11,56(sp)
ffffffffc020876c:	855e                	mv	a0,s7
ffffffffc020876e:	6be6                	ld	s7,88(sp)
ffffffffc0208770:	610d                	addi	sp,sp,160
ffffffffc0208772:	8082                	ret
ffffffffc0208774:	43f7d713          	srai	a4,a5,0x3f
ffffffffc0208778:	03475693          	srli	a3,a4,0x34
ffffffffc020877c:	00d78733          	add	a4,a5,a3
ffffffffc0208780:	01977733          	and	a4,a4,s9
ffffffffc0208784:	8f15                	sub	a4,a4,a3
ffffffffc0208786:	0008d697          	auipc	a3,0x8d
ffffffffc020878a:	0ca68693          	addi	a3,a3,202 # ffffffffc0295850 <stdin_buffer>
ffffffffc020878e:	9736                	add	a4,a4,a3
ffffffffc0208790:	00074683          	lbu	a3,0(a4)
ffffffffc0208794:	0785                	addi	a5,a5,1
ffffffffc0208796:	015d8733          	add	a4,s11,s5
ffffffffc020879a:	00d70023          	sb	a3,0(a4)
ffffffffc020879e:	00f9b023          	sd	a5,0(s3)
ffffffffc02087a2:	0a85                	addi	s5,s5,1
ffffffffc02087a4:	001c0b9b          	addiw	s7,s8,1
ffffffffc02087a8:	f3aae4e3          	bltu	s5,s10,ffffffffc02086d0 <stdin_io+0x62>
ffffffffc02087ac:	dc51                	beqz	s0,ffffffffc0208748 <stdin_io+0xda>
ffffffffc02087ae:	decf80ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02087b2:	f80b9be3          	bnez	s7,ffffffffc0208748 <stdin_io+0xda>
ffffffffc02087b6:	4b81                	li	s7,0
ffffffffc02087b8:	bf71                	j	ffffffffc0208754 <stdin_io+0xe6>
ffffffffc02087ba:	de6f80ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc02087be:	4405                	li	s0,1
ffffffffc02087c0:	ee0d14e3          	bnez	s10,ffffffffc02086a8 <stdin_io+0x3a>
ffffffffc02087c4:	dd6f80ef          	jal	ra,ffffffffc0200d9a <intr_enable>
ffffffffc02087c8:	4b81                	li	s7,0
ffffffffc02087ca:	b769                	j	ffffffffc0208754 <stdin_io+0xe6>
ffffffffc02087cc:	5bf5                	li	s7,-3
ffffffffc02087ce:	b759                	j	ffffffffc0208754 <stdin_io+0xe6>

ffffffffc02087d0 <dev_stdin_write>:
ffffffffc02087d0:	e111                	bnez	a0,ffffffffc02087d4 <dev_stdin_write+0x4>
ffffffffc02087d2:	8082                	ret
ffffffffc02087d4:	1101                	addi	sp,sp,-32
ffffffffc02087d6:	e822                	sd	s0,16(sp)
ffffffffc02087d8:	ec06                	sd	ra,24(sp)
ffffffffc02087da:	e426                	sd	s1,8(sp)
ffffffffc02087dc:	842a                	mv	s0,a0
ffffffffc02087de:	100027f3          	csrr	a5,sstatus
ffffffffc02087e2:	8b89                	andi	a5,a5,2
ffffffffc02087e4:	4481                	li	s1,0
ffffffffc02087e6:	e3c1                	bnez	a5,ffffffffc0208866 <dev_stdin_write+0x96>
ffffffffc02087e8:	0008e597          	auipc	a1,0x8e
ffffffffc02087ec:	11858593          	addi	a1,a1,280 # ffffffffc0296900 <p_wpos>
ffffffffc02087f0:	6198                	ld	a4,0(a1)
ffffffffc02087f2:	6605                	lui	a2,0x1
ffffffffc02087f4:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02087f8:	43f75693          	srai	a3,a4,0x3f
ffffffffc02087fc:	92d1                	srli	a3,a3,0x34
ffffffffc02087fe:	00d707b3          	add	a5,a4,a3
ffffffffc0208802:	8fe9                	and	a5,a5,a0
ffffffffc0208804:	8f95                	sub	a5,a5,a3
ffffffffc0208806:	0008d697          	auipc	a3,0x8d
ffffffffc020880a:	04a68693          	addi	a3,a3,74 # ffffffffc0295850 <stdin_buffer>
ffffffffc020880e:	97b6                	add	a5,a5,a3
ffffffffc0208810:	00878023          	sb	s0,0(a5)
ffffffffc0208814:	0008e797          	auipc	a5,0x8e
ffffffffc0208818:	0e47b783          	ld	a5,228(a5) # ffffffffc02968f8 <p_rpos>
ffffffffc020881c:	40f707b3          	sub	a5,a4,a5
ffffffffc0208820:	00c7d463          	bge	a5,a2,ffffffffc0208828 <dev_stdin_write+0x58>
ffffffffc0208824:	0705                	addi	a4,a4,1
ffffffffc0208826:	e198                	sd	a4,0(a1)
ffffffffc0208828:	0008d517          	auipc	a0,0x8d
ffffffffc020882c:	01850513          	addi	a0,a0,24 # ffffffffc0295840 <__wait_queue>
ffffffffc0208830:	cd7fb0ef          	jal	ra,ffffffffc0204506 <wait_queue_empty>
ffffffffc0208834:	cd09                	beqz	a0,ffffffffc020884e <dev_stdin_write+0x7e>
ffffffffc0208836:	e491                	bnez	s1,ffffffffc0208842 <dev_stdin_write+0x72>
ffffffffc0208838:	60e2                	ld	ra,24(sp)
ffffffffc020883a:	6442                	ld	s0,16(sp)
ffffffffc020883c:	64a2                	ld	s1,8(sp)
ffffffffc020883e:	6105                	addi	sp,sp,32
ffffffffc0208840:	8082                	ret
ffffffffc0208842:	6442                	ld	s0,16(sp)
ffffffffc0208844:	60e2                	ld	ra,24(sp)
ffffffffc0208846:	64a2                	ld	s1,8(sp)
ffffffffc0208848:	6105                	addi	sp,sp,32
ffffffffc020884a:	d50f806f          	j	ffffffffc0200d9a <intr_enable>
ffffffffc020884e:	800005b7          	lui	a1,0x80000
ffffffffc0208852:	4605                	li	a2,1
ffffffffc0208854:	0591                	addi	a1,a1,4
ffffffffc0208856:	0008d517          	auipc	a0,0x8d
ffffffffc020885a:	fea50513          	addi	a0,a0,-22 # ffffffffc0295840 <__wait_queue>
ffffffffc020885e:	d11fb0ef          	jal	ra,ffffffffc020456e <wakeup_queue>
ffffffffc0208862:	d8f9                	beqz	s1,ffffffffc0208838 <dev_stdin_write+0x68>
ffffffffc0208864:	bff9                	j	ffffffffc0208842 <dev_stdin_write+0x72>
ffffffffc0208866:	d3af80ef          	jal	ra,ffffffffc0200da0 <intr_disable>
ffffffffc020886a:	4485                	li	s1,1
ffffffffc020886c:	bfb5                	j	ffffffffc02087e8 <dev_stdin_write+0x18>

ffffffffc020886e <dev_init_stdin>:
ffffffffc020886e:	1141                	addi	sp,sp,-16
ffffffffc0208870:	e406                	sd	ra,8(sp)
ffffffffc0208872:	e022                	sd	s0,0(sp)
ffffffffc0208874:	74a000ef          	jal	ra,ffffffffc0208fbe <dev_create_inode>
ffffffffc0208878:	c93d                	beqz	a0,ffffffffc02088ee <dev_init_stdin+0x80>
ffffffffc020887a:	4d38                	lw	a4,88(a0)
ffffffffc020887c:	6785                	lui	a5,0x1
ffffffffc020887e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208882:	842a                	mv	s0,a0
ffffffffc0208884:	08f71e63          	bne	a4,a5,ffffffffc0208920 <dev_init_stdin+0xb2>
ffffffffc0208888:	4785                	li	a5,1
ffffffffc020888a:	e41c                	sd	a5,8(s0)
ffffffffc020888c:	00000797          	auipc	a5,0x0
ffffffffc0208890:	dd078793          	addi	a5,a5,-560 # ffffffffc020865c <stdin_open>
ffffffffc0208894:	e81c                	sd	a5,16(s0)
ffffffffc0208896:	00000797          	auipc	a5,0x0
ffffffffc020889a:	dd078793          	addi	a5,a5,-560 # ffffffffc0208666 <stdin_close>
ffffffffc020889e:	ec1c                	sd	a5,24(s0)
ffffffffc02088a0:	00000797          	auipc	a5,0x0
ffffffffc02088a4:	dce78793          	addi	a5,a5,-562 # ffffffffc020866e <stdin_io>
ffffffffc02088a8:	f01c                	sd	a5,32(s0)
ffffffffc02088aa:	00000797          	auipc	a5,0x0
ffffffffc02088ae:	dc078793          	addi	a5,a5,-576 # ffffffffc020866a <stdin_ioctl>
ffffffffc02088b2:	f41c                	sd	a5,40(s0)
ffffffffc02088b4:	0008d517          	auipc	a0,0x8d
ffffffffc02088b8:	f8c50513          	addi	a0,a0,-116 # ffffffffc0295840 <__wait_queue>
ffffffffc02088bc:	00043023          	sd	zero,0(s0)
ffffffffc02088c0:	0008e797          	auipc	a5,0x8e
ffffffffc02088c4:	0407b023          	sd	zero,64(a5) # ffffffffc0296900 <p_wpos>
ffffffffc02088c8:	0008e797          	auipc	a5,0x8e
ffffffffc02088cc:	0207b823          	sd	zero,48(a5) # ffffffffc02968f8 <p_rpos>
ffffffffc02088d0:	be3fb0ef          	jal	ra,ffffffffc02044b2 <wait_queue_init>
ffffffffc02088d4:	4601                	li	a2,0
ffffffffc02088d6:	85a2                	mv	a1,s0
ffffffffc02088d8:	00006517          	auipc	a0,0x6
ffffffffc02088dc:	1f050513          	addi	a0,a0,496 # ffffffffc020eac8 <syscalls+0xe60>
ffffffffc02088e0:	b20ff0ef          	jal	ra,ffffffffc0207c00 <vfs_add_dev>
ffffffffc02088e4:	e10d                	bnez	a0,ffffffffc0208906 <dev_init_stdin+0x98>
ffffffffc02088e6:	60a2                	ld	ra,8(sp)
ffffffffc02088e8:	6402                	ld	s0,0(sp)
ffffffffc02088ea:	0141                	addi	sp,sp,16
ffffffffc02088ec:	8082                	ret
ffffffffc02088ee:	00006617          	auipc	a2,0x6
ffffffffc02088f2:	19a60613          	addi	a2,a2,410 # ffffffffc020ea88 <syscalls+0xe20>
ffffffffc02088f6:	07500593          	li	a1,117
ffffffffc02088fa:	00006517          	auipc	a0,0x6
ffffffffc02088fe:	1ae50513          	addi	a0,a0,430 # ffffffffc020eaa8 <syscalls+0xe40>
ffffffffc0208902:	92df70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208906:	86aa                	mv	a3,a0
ffffffffc0208908:	00006617          	auipc	a2,0x6
ffffffffc020890c:	1c860613          	addi	a2,a2,456 # ffffffffc020ead0 <syscalls+0xe68>
ffffffffc0208910:	07b00593          	li	a1,123
ffffffffc0208914:	00006517          	auipc	a0,0x6
ffffffffc0208918:	19450513          	addi	a0,a0,404 # ffffffffc020eaa8 <syscalls+0xe40>
ffffffffc020891c:	913f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208920:	00006697          	auipc	a3,0x6
ffffffffc0208924:	c1068693          	addi	a3,a3,-1008 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208928:	00003617          	auipc	a2,0x3
ffffffffc020892c:	2f060613          	addi	a2,a2,752 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208930:	07700593          	li	a1,119
ffffffffc0208934:	00006517          	auipc	a0,0x6
ffffffffc0208938:	17450513          	addi	a0,a0,372 # ffffffffc020eaa8 <syscalls+0xe40>
ffffffffc020893c:	8f3f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208940 <disk0_open>:
ffffffffc0208940:	4501                	li	a0,0
ffffffffc0208942:	8082                	ret

ffffffffc0208944 <disk0_close>:
ffffffffc0208944:	4501                	li	a0,0
ffffffffc0208946:	8082                	ret

ffffffffc0208948 <disk0_ioctl>:
ffffffffc0208948:	5531                	li	a0,-20
ffffffffc020894a:	8082                	ret

ffffffffc020894c <disk0_io>:
ffffffffc020894c:	659c                	ld	a5,8(a1)
ffffffffc020894e:	7159                	addi	sp,sp,-112
ffffffffc0208950:	eca6                	sd	s1,88(sp)
ffffffffc0208952:	f45e                	sd	s7,40(sp)
ffffffffc0208954:	6d84                	ld	s1,24(a1)
ffffffffc0208956:	6b85                	lui	s7,0x1
ffffffffc0208958:	1bfd                	addi	s7,s7,-1
ffffffffc020895a:	e4ce                	sd	s3,72(sp)
ffffffffc020895c:	43f7d993          	srai	s3,a5,0x3f
ffffffffc0208960:	0179f9b3          	and	s3,s3,s7
ffffffffc0208964:	99be                	add	s3,s3,a5
ffffffffc0208966:	8fc5                	or	a5,a5,s1
ffffffffc0208968:	f486                	sd	ra,104(sp)
ffffffffc020896a:	f0a2                	sd	s0,96(sp)
ffffffffc020896c:	e8ca                	sd	s2,80(sp)
ffffffffc020896e:	e0d2                	sd	s4,64(sp)
ffffffffc0208970:	fc56                	sd	s5,56(sp)
ffffffffc0208972:	f85a                	sd	s6,48(sp)
ffffffffc0208974:	f062                	sd	s8,32(sp)
ffffffffc0208976:	ec66                	sd	s9,24(sp)
ffffffffc0208978:	e86a                	sd	s10,16(sp)
ffffffffc020897a:	0177f7b3          	and	a5,a5,s7
ffffffffc020897e:	10079d63          	bnez	a5,ffffffffc0208a98 <disk0_io+0x14c>
ffffffffc0208982:	40c9d993          	srai	s3,s3,0xc
ffffffffc0208986:	00c4d713          	srli	a4,s1,0xc
ffffffffc020898a:	2981                	sext.w	s3,s3
ffffffffc020898c:	2701                	sext.w	a4,a4
ffffffffc020898e:	00e987bb          	addw	a5,s3,a4
ffffffffc0208992:	6114                	ld	a3,0(a0)
ffffffffc0208994:	1782                	slli	a5,a5,0x20
ffffffffc0208996:	9381                	srli	a5,a5,0x20
ffffffffc0208998:	10f6e063          	bltu	a3,a5,ffffffffc0208a98 <disk0_io+0x14c>
ffffffffc020899c:	4501                	li	a0,0
ffffffffc020899e:	ef19                	bnez	a4,ffffffffc02089bc <disk0_io+0x70>
ffffffffc02089a0:	70a6                	ld	ra,104(sp)
ffffffffc02089a2:	7406                	ld	s0,96(sp)
ffffffffc02089a4:	64e6                	ld	s1,88(sp)
ffffffffc02089a6:	6946                	ld	s2,80(sp)
ffffffffc02089a8:	69a6                	ld	s3,72(sp)
ffffffffc02089aa:	6a06                	ld	s4,64(sp)
ffffffffc02089ac:	7ae2                	ld	s5,56(sp)
ffffffffc02089ae:	7b42                	ld	s6,48(sp)
ffffffffc02089b0:	7ba2                	ld	s7,40(sp)
ffffffffc02089b2:	7c02                	ld	s8,32(sp)
ffffffffc02089b4:	6ce2                	ld	s9,24(sp)
ffffffffc02089b6:	6d42                	ld	s10,16(sp)
ffffffffc02089b8:	6165                	addi	sp,sp,112
ffffffffc02089ba:	8082                	ret
ffffffffc02089bc:	0008e517          	auipc	a0,0x8e
ffffffffc02089c0:	e9450513          	addi	a0,a0,-364 # ffffffffc0296850 <disk0_sem>
ffffffffc02089c4:	8b2e                	mv	s6,a1
ffffffffc02089c6:	8c32                	mv	s8,a2
ffffffffc02089c8:	0008ea97          	auipc	s5,0x8e
ffffffffc02089cc:	f40a8a93          	addi	s5,s5,-192 # ffffffffc0296908 <disk0_buffer>
ffffffffc02089d0:	e13fb0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc02089d4:	6c91                	lui	s9,0x4
ffffffffc02089d6:	e4b9                	bnez	s1,ffffffffc0208a24 <disk0_io+0xd8>
ffffffffc02089d8:	a845                	j	ffffffffc0208a88 <disk0_io+0x13c>
ffffffffc02089da:	00c4d413          	srli	s0,s1,0xc
ffffffffc02089de:	0034169b          	slliw	a3,s0,0x3
ffffffffc02089e2:	00068d1b          	sext.w	s10,a3
ffffffffc02089e6:	1682                	slli	a3,a3,0x20
ffffffffc02089e8:	2401                	sext.w	s0,s0
ffffffffc02089ea:	9281                	srli	a3,a3,0x20
ffffffffc02089ec:	8926                	mv	s2,s1
ffffffffc02089ee:	00399a1b          	slliw	s4,s3,0x3
ffffffffc02089f2:	862e                	mv	a2,a1
ffffffffc02089f4:	4509                	li	a0,2
ffffffffc02089f6:	85d2                	mv	a1,s4
ffffffffc02089f8:	a76f80ef          	jal	ra,ffffffffc0200c6e <ide_read_secs>
ffffffffc02089fc:	e165                	bnez	a0,ffffffffc0208adc <disk0_io+0x190>
ffffffffc02089fe:	000ab583          	ld	a1,0(s5)
ffffffffc0208a02:	0038                	addi	a4,sp,8
ffffffffc0208a04:	4685                	li	a3,1
ffffffffc0208a06:	864a                	mv	a2,s2
ffffffffc0208a08:	855a                	mv	a0,s6
ffffffffc0208a0a:	dc5fc0ef          	jal	ra,ffffffffc02057ce <iobuf_move>
ffffffffc0208a0e:	67a2                	ld	a5,8(sp)
ffffffffc0208a10:	09279663          	bne	a5,s2,ffffffffc0208a9c <disk0_io+0x150>
ffffffffc0208a14:	017977b3          	and	a5,s2,s7
ffffffffc0208a18:	e3d1                	bnez	a5,ffffffffc0208a9c <disk0_io+0x150>
ffffffffc0208a1a:	412484b3          	sub	s1,s1,s2
ffffffffc0208a1e:	013409bb          	addw	s3,s0,s3
ffffffffc0208a22:	c0bd                	beqz	s1,ffffffffc0208a88 <disk0_io+0x13c>
ffffffffc0208a24:	000ab583          	ld	a1,0(s5)
ffffffffc0208a28:	000c1b63          	bnez	s8,ffffffffc0208a3e <disk0_io+0xf2>
ffffffffc0208a2c:	fb94e7e3          	bltu	s1,s9,ffffffffc02089da <disk0_io+0x8e>
ffffffffc0208a30:	02000693          	li	a3,32
ffffffffc0208a34:	02000d13          	li	s10,32
ffffffffc0208a38:	4411                	li	s0,4
ffffffffc0208a3a:	6911                	lui	s2,0x4
ffffffffc0208a3c:	bf4d                	j	ffffffffc02089ee <disk0_io+0xa2>
ffffffffc0208a3e:	0038                	addi	a4,sp,8
ffffffffc0208a40:	4681                	li	a3,0
ffffffffc0208a42:	6611                	lui	a2,0x4
ffffffffc0208a44:	855a                	mv	a0,s6
ffffffffc0208a46:	d89fc0ef          	jal	ra,ffffffffc02057ce <iobuf_move>
ffffffffc0208a4a:	6422                	ld	s0,8(sp)
ffffffffc0208a4c:	c825                	beqz	s0,ffffffffc0208abc <disk0_io+0x170>
ffffffffc0208a4e:	0684e763          	bltu	s1,s0,ffffffffc0208abc <disk0_io+0x170>
ffffffffc0208a52:	017477b3          	and	a5,s0,s7
ffffffffc0208a56:	e3bd                	bnez	a5,ffffffffc0208abc <disk0_io+0x170>
ffffffffc0208a58:	8031                	srli	s0,s0,0xc
ffffffffc0208a5a:	0034179b          	slliw	a5,s0,0x3
ffffffffc0208a5e:	000ab603          	ld	a2,0(s5)
ffffffffc0208a62:	0039991b          	slliw	s2,s3,0x3
ffffffffc0208a66:	02079693          	slli	a3,a5,0x20
ffffffffc0208a6a:	9281                	srli	a3,a3,0x20
ffffffffc0208a6c:	85ca                	mv	a1,s2
ffffffffc0208a6e:	4509                	li	a0,2
ffffffffc0208a70:	2401                	sext.w	s0,s0
ffffffffc0208a72:	00078a1b          	sext.w	s4,a5
ffffffffc0208a76:	a8ef80ef          	jal	ra,ffffffffc0200d04 <ide_write_secs>
ffffffffc0208a7a:	e151                	bnez	a0,ffffffffc0208afe <disk0_io+0x1b2>
ffffffffc0208a7c:	6922                	ld	s2,8(sp)
ffffffffc0208a7e:	013409bb          	addw	s3,s0,s3
ffffffffc0208a82:	412484b3          	sub	s1,s1,s2
ffffffffc0208a86:	fcd9                	bnez	s1,ffffffffc0208a24 <disk0_io+0xd8>
ffffffffc0208a88:	0008e517          	auipc	a0,0x8e
ffffffffc0208a8c:	dc850513          	addi	a0,a0,-568 # ffffffffc0296850 <disk0_sem>
ffffffffc0208a90:	d4ffb0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0208a94:	4501                	li	a0,0
ffffffffc0208a96:	b729                	j	ffffffffc02089a0 <disk0_io+0x54>
ffffffffc0208a98:	5575                	li	a0,-3
ffffffffc0208a9a:	b719                	j	ffffffffc02089a0 <disk0_io+0x54>
ffffffffc0208a9c:	00006697          	auipc	a3,0x6
ffffffffc0208aa0:	14c68693          	addi	a3,a3,332 # ffffffffc020ebe8 <syscalls+0xf80>
ffffffffc0208aa4:	00003617          	auipc	a2,0x3
ffffffffc0208aa8:	17460613          	addi	a2,a2,372 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208aac:	06200593          	li	a1,98
ffffffffc0208ab0:	00006517          	auipc	a0,0x6
ffffffffc0208ab4:	08050513          	addi	a0,a0,128 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208ab8:	f76f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208abc:	00006697          	auipc	a3,0x6
ffffffffc0208ac0:	03468693          	addi	a3,a3,52 # ffffffffc020eaf0 <syscalls+0xe88>
ffffffffc0208ac4:	00003617          	auipc	a2,0x3
ffffffffc0208ac8:	15460613          	addi	a2,a2,340 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208acc:	05700593          	li	a1,87
ffffffffc0208ad0:	00006517          	auipc	a0,0x6
ffffffffc0208ad4:	06050513          	addi	a0,a0,96 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208ad8:	f56f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208adc:	88aa                	mv	a7,a0
ffffffffc0208ade:	886a                	mv	a6,s10
ffffffffc0208ae0:	87a2                	mv	a5,s0
ffffffffc0208ae2:	8752                	mv	a4,s4
ffffffffc0208ae4:	86ce                	mv	a3,s3
ffffffffc0208ae6:	00006617          	auipc	a2,0x6
ffffffffc0208aea:	0ba60613          	addi	a2,a2,186 # ffffffffc020eba0 <syscalls+0xf38>
ffffffffc0208aee:	02d00593          	li	a1,45
ffffffffc0208af2:	00006517          	auipc	a0,0x6
ffffffffc0208af6:	03e50513          	addi	a0,a0,62 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208afa:	f34f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208afe:	88aa                	mv	a7,a0
ffffffffc0208b00:	8852                	mv	a6,s4
ffffffffc0208b02:	87a2                	mv	a5,s0
ffffffffc0208b04:	874a                	mv	a4,s2
ffffffffc0208b06:	86ce                	mv	a3,s3
ffffffffc0208b08:	00006617          	auipc	a2,0x6
ffffffffc0208b0c:	04860613          	addi	a2,a2,72 # ffffffffc020eb50 <syscalls+0xee8>
ffffffffc0208b10:	03700593          	li	a1,55
ffffffffc0208b14:	00006517          	auipc	a0,0x6
ffffffffc0208b18:	01c50513          	addi	a0,a0,28 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208b1c:	f12f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208b20 <dev_init_disk0>:
ffffffffc0208b20:	1101                	addi	sp,sp,-32
ffffffffc0208b22:	ec06                	sd	ra,24(sp)
ffffffffc0208b24:	e822                	sd	s0,16(sp)
ffffffffc0208b26:	e426                	sd	s1,8(sp)
ffffffffc0208b28:	496000ef          	jal	ra,ffffffffc0208fbe <dev_create_inode>
ffffffffc0208b2c:	c541                	beqz	a0,ffffffffc0208bb4 <dev_init_disk0+0x94>
ffffffffc0208b2e:	4d38                	lw	a4,88(a0)
ffffffffc0208b30:	6485                	lui	s1,0x1
ffffffffc0208b32:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208b36:	842a                	mv	s0,a0
ffffffffc0208b38:	0cf71f63          	bne	a4,a5,ffffffffc0208c16 <dev_init_disk0+0xf6>
ffffffffc0208b3c:	4509                	li	a0,2
ffffffffc0208b3e:	8e4f80ef          	jal	ra,ffffffffc0200c22 <ide_device_valid>
ffffffffc0208b42:	cd55                	beqz	a0,ffffffffc0208bfe <dev_init_disk0+0xde>
ffffffffc0208b44:	4509                	li	a0,2
ffffffffc0208b46:	900f80ef          	jal	ra,ffffffffc0200c46 <ide_device_size>
ffffffffc0208b4a:	00355793          	srli	a5,a0,0x3
ffffffffc0208b4e:	e01c                	sd	a5,0(s0)
ffffffffc0208b50:	00000797          	auipc	a5,0x0
ffffffffc0208b54:	df078793          	addi	a5,a5,-528 # ffffffffc0208940 <disk0_open>
ffffffffc0208b58:	e81c                	sd	a5,16(s0)
ffffffffc0208b5a:	00000797          	auipc	a5,0x0
ffffffffc0208b5e:	dea78793          	addi	a5,a5,-534 # ffffffffc0208944 <disk0_close>
ffffffffc0208b62:	ec1c                	sd	a5,24(s0)
ffffffffc0208b64:	00000797          	auipc	a5,0x0
ffffffffc0208b68:	de878793          	addi	a5,a5,-536 # ffffffffc020894c <disk0_io>
ffffffffc0208b6c:	f01c                	sd	a5,32(s0)
ffffffffc0208b6e:	00000797          	auipc	a5,0x0
ffffffffc0208b72:	dda78793          	addi	a5,a5,-550 # ffffffffc0208948 <disk0_ioctl>
ffffffffc0208b76:	f41c                	sd	a5,40(s0)
ffffffffc0208b78:	4585                	li	a1,1
ffffffffc0208b7a:	0008e517          	auipc	a0,0x8e
ffffffffc0208b7e:	cd650513          	addi	a0,a0,-810 # ffffffffc0296850 <disk0_sem>
ffffffffc0208b82:	e404                	sd	s1,8(s0)
ffffffffc0208b84:	c53fb0ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc0208b88:	6511                	lui	a0,0x4
ffffffffc0208b8a:	a24f90ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0208b8e:	0008e797          	auipc	a5,0x8e
ffffffffc0208b92:	d6a7bd23          	sd	a0,-646(a5) # ffffffffc0296908 <disk0_buffer>
ffffffffc0208b96:	c921                	beqz	a0,ffffffffc0208be6 <dev_init_disk0+0xc6>
ffffffffc0208b98:	4605                	li	a2,1
ffffffffc0208b9a:	85a2                	mv	a1,s0
ffffffffc0208b9c:	00006517          	auipc	a0,0x6
ffffffffc0208ba0:	0dc50513          	addi	a0,a0,220 # ffffffffc020ec78 <syscalls+0x1010>
ffffffffc0208ba4:	85cff0ef          	jal	ra,ffffffffc0207c00 <vfs_add_dev>
ffffffffc0208ba8:	e115                	bnez	a0,ffffffffc0208bcc <dev_init_disk0+0xac>
ffffffffc0208baa:	60e2                	ld	ra,24(sp)
ffffffffc0208bac:	6442                	ld	s0,16(sp)
ffffffffc0208bae:	64a2                	ld	s1,8(sp)
ffffffffc0208bb0:	6105                	addi	sp,sp,32
ffffffffc0208bb2:	8082                	ret
ffffffffc0208bb4:	00006617          	auipc	a2,0x6
ffffffffc0208bb8:	06460613          	addi	a2,a2,100 # ffffffffc020ec18 <syscalls+0xfb0>
ffffffffc0208bbc:	08700593          	li	a1,135
ffffffffc0208bc0:	00006517          	auipc	a0,0x6
ffffffffc0208bc4:	f7050513          	addi	a0,a0,-144 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208bc8:	e66f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208bcc:	86aa                	mv	a3,a0
ffffffffc0208bce:	00006617          	auipc	a2,0x6
ffffffffc0208bd2:	0b260613          	addi	a2,a2,178 # ffffffffc020ec80 <syscalls+0x1018>
ffffffffc0208bd6:	08d00593          	li	a1,141
ffffffffc0208bda:	00006517          	auipc	a0,0x6
ffffffffc0208bde:	f5650513          	addi	a0,a0,-170 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208be2:	e4cf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208be6:	00006617          	auipc	a2,0x6
ffffffffc0208bea:	07260613          	addi	a2,a2,114 # ffffffffc020ec58 <syscalls+0xff0>
ffffffffc0208bee:	07f00593          	li	a1,127
ffffffffc0208bf2:	00006517          	auipc	a0,0x6
ffffffffc0208bf6:	f3e50513          	addi	a0,a0,-194 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208bfa:	e34f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208bfe:	00006617          	auipc	a2,0x6
ffffffffc0208c02:	03a60613          	addi	a2,a2,58 # ffffffffc020ec38 <syscalls+0xfd0>
ffffffffc0208c06:	07300593          	li	a1,115
ffffffffc0208c0a:	00006517          	auipc	a0,0x6
ffffffffc0208c0e:	f2650513          	addi	a0,a0,-218 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208c12:	e1cf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208c16:	00006697          	auipc	a3,0x6
ffffffffc0208c1a:	91a68693          	addi	a3,a3,-1766 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208c1e:	00003617          	auipc	a2,0x3
ffffffffc0208c22:	ffa60613          	addi	a2,a2,-6 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208c26:	08900593          	li	a1,137
ffffffffc0208c2a:	00006517          	auipc	a0,0x6
ffffffffc0208c2e:	f0650513          	addi	a0,a0,-250 # ffffffffc020eb30 <syscalls+0xec8>
ffffffffc0208c32:	dfcf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208c36 <stdout_open>:
ffffffffc0208c36:	4785                	li	a5,1
ffffffffc0208c38:	4501                	li	a0,0
ffffffffc0208c3a:	00f59363          	bne	a1,a5,ffffffffc0208c40 <stdout_open+0xa>
ffffffffc0208c3e:	8082                	ret
ffffffffc0208c40:	5575                	li	a0,-3
ffffffffc0208c42:	8082                	ret

ffffffffc0208c44 <stdout_close>:
ffffffffc0208c44:	4501                	li	a0,0
ffffffffc0208c46:	8082                	ret

ffffffffc0208c48 <stdout_ioctl>:
ffffffffc0208c48:	5575                	li	a0,-3
ffffffffc0208c4a:	8082                	ret

ffffffffc0208c4c <stdout_io>:
ffffffffc0208c4c:	ca05                	beqz	a2,ffffffffc0208c7c <stdout_io+0x30>
ffffffffc0208c4e:	6d9c                	ld	a5,24(a1)
ffffffffc0208c50:	1101                	addi	sp,sp,-32
ffffffffc0208c52:	e822                	sd	s0,16(sp)
ffffffffc0208c54:	e426                	sd	s1,8(sp)
ffffffffc0208c56:	ec06                	sd	ra,24(sp)
ffffffffc0208c58:	6180                	ld	s0,0(a1)
ffffffffc0208c5a:	84ae                	mv	s1,a1
ffffffffc0208c5c:	cb91                	beqz	a5,ffffffffc0208c70 <stdout_io+0x24>
ffffffffc0208c5e:	00044503          	lbu	a0,0(s0)
ffffffffc0208c62:	0405                	addi	s0,s0,1
ffffffffc0208c64:	d02f70ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc0208c68:	6c9c                	ld	a5,24(s1)
ffffffffc0208c6a:	17fd                	addi	a5,a5,-1
ffffffffc0208c6c:	ec9c                	sd	a5,24(s1)
ffffffffc0208c6e:	fbe5                	bnez	a5,ffffffffc0208c5e <stdout_io+0x12>
ffffffffc0208c70:	60e2                	ld	ra,24(sp)
ffffffffc0208c72:	6442                	ld	s0,16(sp)
ffffffffc0208c74:	64a2                	ld	s1,8(sp)
ffffffffc0208c76:	4501                	li	a0,0
ffffffffc0208c78:	6105                	addi	sp,sp,32
ffffffffc0208c7a:	8082                	ret
ffffffffc0208c7c:	5575                	li	a0,-3
ffffffffc0208c7e:	8082                	ret

ffffffffc0208c80 <dev_init_stdout>:
ffffffffc0208c80:	1141                	addi	sp,sp,-16
ffffffffc0208c82:	e406                	sd	ra,8(sp)
ffffffffc0208c84:	33a000ef          	jal	ra,ffffffffc0208fbe <dev_create_inode>
ffffffffc0208c88:	c939                	beqz	a0,ffffffffc0208cde <dev_init_stdout+0x5e>
ffffffffc0208c8a:	4d38                	lw	a4,88(a0)
ffffffffc0208c8c:	6785                	lui	a5,0x1
ffffffffc0208c8e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c92:	85aa                	mv	a1,a0
ffffffffc0208c94:	06f71e63          	bne	a4,a5,ffffffffc0208d10 <dev_init_stdout+0x90>
ffffffffc0208c98:	4785                	li	a5,1
ffffffffc0208c9a:	e51c                	sd	a5,8(a0)
ffffffffc0208c9c:	00000797          	auipc	a5,0x0
ffffffffc0208ca0:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208c36 <stdout_open>
ffffffffc0208ca4:	e91c                	sd	a5,16(a0)
ffffffffc0208ca6:	00000797          	auipc	a5,0x0
ffffffffc0208caa:	f9e78793          	addi	a5,a5,-98 # ffffffffc0208c44 <stdout_close>
ffffffffc0208cae:	ed1c                	sd	a5,24(a0)
ffffffffc0208cb0:	00000797          	auipc	a5,0x0
ffffffffc0208cb4:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208c4c <stdout_io>
ffffffffc0208cb8:	f11c                	sd	a5,32(a0)
ffffffffc0208cba:	00000797          	auipc	a5,0x0
ffffffffc0208cbe:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208c48 <stdout_ioctl>
ffffffffc0208cc2:	00053023          	sd	zero,0(a0)
ffffffffc0208cc6:	f51c                	sd	a5,40(a0)
ffffffffc0208cc8:	4601                	li	a2,0
ffffffffc0208cca:	00006517          	auipc	a0,0x6
ffffffffc0208cce:	01650513          	addi	a0,a0,22 # ffffffffc020ece0 <syscalls+0x1078>
ffffffffc0208cd2:	f2ffe0ef          	jal	ra,ffffffffc0207c00 <vfs_add_dev>
ffffffffc0208cd6:	e105                	bnez	a0,ffffffffc0208cf6 <dev_init_stdout+0x76>
ffffffffc0208cd8:	60a2                	ld	ra,8(sp)
ffffffffc0208cda:	0141                	addi	sp,sp,16
ffffffffc0208cdc:	8082                	ret
ffffffffc0208cde:	00006617          	auipc	a2,0x6
ffffffffc0208ce2:	fc260613          	addi	a2,a2,-62 # ffffffffc020eca0 <syscalls+0x1038>
ffffffffc0208ce6:	03700593          	li	a1,55
ffffffffc0208cea:	00006517          	auipc	a0,0x6
ffffffffc0208cee:	fd650513          	addi	a0,a0,-42 # ffffffffc020ecc0 <syscalls+0x1058>
ffffffffc0208cf2:	d3cf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208cf6:	86aa                	mv	a3,a0
ffffffffc0208cf8:	00006617          	auipc	a2,0x6
ffffffffc0208cfc:	ff060613          	addi	a2,a2,-16 # ffffffffc020ece8 <syscalls+0x1080>
ffffffffc0208d00:	03d00593          	li	a1,61
ffffffffc0208d04:	00006517          	auipc	a0,0x6
ffffffffc0208d08:	fbc50513          	addi	a0,a0,-68 # ffffffffc020ecc0 <syscalls+0x1058>
ffffffffc0208d0c:	d22f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208d10:	00006697          	auipc	a3,0x6
ffffffffc0208d14:	82068693          	addi	a3,a3,-2016 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208d18:	00003617          	auipc	a2,0x3
ffffffffc0208d1c:	f0060613          	addi	a2,a2,-256 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208d20:	03900593          	li	a1,57
ffffffffc0208d24:	00006517          	auipc	a0,0x6
ffffffffc0208d28:	f9c50513          	addi	a0,a0,-100 # ffffffffc020ecc0 <syscalls+0x1058>
ffffffffc0208d2c:	d02f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208d30 <dev_lookup>:
ffffffffc0208d30:	0005c783          	lbu	a5,0(a1) # ffffffff80000000 <_binary_bin_sfs_img_size+0xffffffff7ff8ad00>
ffffffffc0208d34:	e385                	bnez	a5,ffffffffc0208d54 <dev_lookup+0x24>
ffffffffc0208d36:	1101                	addi	sp,sp,-32
ffffffffc0208d38:	e822                	sd	s0,16(sp)
ffffffffc0208d3a:	e426                	sd	s1,8(sp)
ffffffffc0208d3c:	ec06                	sd	ra,24(sp)
ffffffffc0208d3e:	84aa                	mv	s1,a0
ffffffffc0208d40:	8432                	mv	s0,a2
ffffffffc0208d42:	df6ff0ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc0208d46:	60e2                	ld	ra,24(sp)
ffffffffc0208d48:	e004                	sd	s1,0(s0)
ffffffffc0208d4a:	6442                	ld	s0,16(sp)
ffffffffc0208d4c:	64a2                	ld	s1,8(sp)
ffffffffc0208d4e:	4501                	li	a0,0
ffffffffc0208d50:	6105                	addi	sp,sp,32
ffffffffc0208d52:	8082                	ret
ffffffffc0208d54:	5541                	li	a0,-16
ffffffffc0208d56:	8082                	ret

ffffffffc0208d58 <dev_fstat>:
ffffffffc0208d58:	1101                	addi	sp,sp,-32
ffffffffc0208d5a:	e426                	sd	s1,8(sp)
ffffffffc0208d5c:	84ae                	mv	s1,a1
ffffffffc0208d5e:	e822                	sd	s0,16(sp)
ffffffffc0208d60:	02000613          	li	a2,32
ffffffffc0208d64:	842a                	mv	s0,a0
ffffffffc0208d66:	4581                	li	a1,0
ffffffffc0208d68:	8526                	mv	a0,s1
ffffffffc0208d6a:	ec06                	sd	ra,24(sp)
ffffffffc0208d6c:	4b2020ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0208d70:	c429                	beqz	s0,ffffffffc0208dba <dev_fstat+0x62>
ffffffffc0208d72:	783c                	ld	a5,112(s0)
ffffffffc0208d74:	c3b9                	beqz	a5,ffffffffc0208dba <dev_fstat+0x62>
ffffffffc0208d76:	6bbc                	ld	a5,80(a5)
ffffffffc0208d78:	c3a9                	beqz	a5,ffffffffc0208dba <dev_fstat+0x62>
ffffffffc0208d7a:	00006597          	auipc	a1,0x6
ffffffffc0208d7e:	87e58593          	addi	a1,a1,-1922 # ffffffffc020e5f8 <syscalls+0x990>
ffffffffc0208d82:	8522                	mv	a0,s0
ffffffffc0208d84:	dccff0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0208d88:	783c                	ld	a5,112(s0)
ffffffffc0208d8a:	85a6                	mv	a1,s1
ffffffffc0208d8c:	8522                	mv	a0,s0
ffffffffc0208d8e:	6bbc                	ld	a5,80(a5)
ffffffffc0208d90:	9782                	jalr	a5
ffffffffc0208d92:	ed19                	bnez	a0,ffffffffc0208db0 <dev_fstat+0x58>
ffffffffc0208d94:	4c38                	lw	a4,88(s0)
ffffffffc0208d96:	6785                	lui	a5,0x1
ffffffffc0208d98:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d9c:	02f71f63          	bne	a4,a5,ffffffffc0208dda <dev_fstat+0x82>
ffffffffc0208da0:	6018                	ld	a4,0(s0)
ffffffffc0208da2:	641c                	ld	a5,8(s0)
ffffffffc0208da4:	4685                	li	a3,1
ffffffffc0208da6:	e494                	sd	a3,8(s1)
ffffffffc0208da8:	02e787b3          	mul	a5,a5,a4
ffffffffc0208dac:	e898                	sd	a4,16(s1)
ffffffffc0208dae:	ec9c                	sd	a5,24(s1)
ffffffffc0208db0:	60e2                	ld	ra,24(sp)
ffffffffc0208db2:	6442                	ld	s0,16(sp)
ffffffffc0208db4:	64a2                	ld	s1,8(sp)
ffffffffc0208db6:	6105                	addi	sp,sp,32
ffffffffc0208db8:	8082                	ret
ffffffffc0208dba:	00005697          	auipc	a3,0x5
ffffffffc0208dbe:	7d668693          	addi	a3,a3,2006 # ffffffffc020e590 <syscalls+0x928>
ffffffffc0208dc2:	00003617          	auipc	a2,0x3
ffffffffc0208dc6:	e5660613          	addi	a2,a2,-426 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208dca:	04200593          	li	a1,66
ffffffffc0208dce:	00006517          	auipc	a0,0x6
ffffffffc0208dd2:	f3a50513          	addi	a0,a0,-198 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208dd6:	c58f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208dda:	00005697          	auipc	a3,0x5
ffffffffc0208dde:	75668693          	addi	a3,a3,1878 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208de2:	00003617          	auipc	a2,0x3
ffffffffc0208de6:	e3660613          	addi	a2,a2,-458 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208dea:	04500593          	li	a1,69
ffffffffc0208dee:	00006517          	auipc	a0,0x6
ffffffffc0208df2:	f1a50513          	addi	a0,a0,-230 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208df6:	c38f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208dfa <dev_ioctl>:
ffffffffc0208dfa:	c909                	beqz	a0,ffffffffc0208e0c <dev_ioctl+0x12>
ffffffffc0208dfc:	4d34                	lw	a3,88(a0)
ffffffffc0208dfe:	6705                	lui	a4,0x1
ffffffffc0208e00:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e04:	00e69463          	bne	a3,a4,ffffffffc0208e0c <dev_ioctl+0x12>
ffffffffc0208e08:	751c                	ld	a5,40(a0)
ffffffffc0208e0a:	8782                	jr	a5
ffffffffc0208e0c:	1141                	addi	sp,sp,-16
ffffffffc0208e0e:	00005697          	auipc	a3,0x5
ffffffffc0208e12:	72268693          	addi	a3,a3,1826 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208e16:	00003617          	auipc	a2,0x3
ffffffffc0208e1a:	e0260613          	addi	a2,a2,-510 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208e1e:	03500593          	li	a1,53
ffffffffc0208e22:	00006517          	auipc	a0,0x6
ffffffffc0208e26:	ee650513          	addi	a0,a0,-282 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208e2a:	e406                	sd	ra,8(sp)
ffffffffc0208e2c:	c02f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208e30 <dev_tryseek>:
ffffffffc0208e30:	c51d                	beqz	a0,ffffffffc0208e5e <dev_tryseek+0x2e>
ffffffffc0208e32:	4d38                	lw	a4,88(a0)
ffffffffc0208e34:	6785                	lui	a5,0x1
ffffffffc0208e36:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e3a:	02f71263          	bne	a4,a5,ffffffffc0208e5e <dev_tryseek+0x2e>
ffffffffc0208e3e:	611c                	ld	a5,0(a0)
ffffffffc0208e40:	cf89                	beqz	a5,ffffffffc0208e5a <dev_tryseek+0x2a>
ffffffffc0208e42:	6518                	ld	a4,8(a0)
ffffffffc0208e44:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208e48:	ea89                	bnez	a3,ffffffffc0208e5a <dev_tryseek+0x2a>
ffffffffc0208e4a:	0005c863          	bltz	a1,ffffffffc0208e5a <dev_tryseek+0x2a>
ffffffffc0208e4e:	02e787b3          	mul	a5,a5,a4
ffffffffc0208e52:	00f5f463          	bgeu	a1,a5,ffffffffc0208e5a <dev_tryseek+0x2a>
ffffffffc0208e56:	4501                	li	a0,0
ffffffffc0208e58:	8082                	ret
ffffffffc0208e5a:	5575                	li	a0,-3
ffffffffc0208e5c:	8082                	ret
ffffffffc0208e5e:	1141                	addi	sp,sp,-16
ffffffffc0208e60:	00005697          	auipc	a3,0x5
ffffffffc0208e64:	6d068693          	addi	a3,a3,1744 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208e68:	00003617          	auipc	a2,0x3
ffffffffc0208e6c:	db060613          	addi	a2,a2,-592 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208e70:	05f00593          	li	a1,95
ffffffffc0208e74:	00006517          	auipc	a0,0x6
ffffffffc0208e78:	e9450513          	addi	a0,a0,-364 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208e7c:	e406                	sd	ra,8(sp)
ffffffffc0208e7e:	bb0f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208e82 <dev_gettype>:
ffffffffc0208e82:	c10d                	beqz	a0,ffffffffc0208ea4 <dev_gettype+0x22>
ffffffffc0208e84:	4d38                	lw	a4,88(a0)
ffffffffc0208e86:	6785                	lui	a5,0x1
ffffffffc0208e88:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e8c:	00f71c63          	bne	a4,a5,ffffffffc0208ea4 <dev_gettype+0x22>
ffffffffc0208e90:	6118                	ld	a4,0(a0)
ffffffffc0208e92:	6795                	lui	a5,0x5
ffffffffc0208e94:	c701                	beqz	a4,ffffffffc0208e9c <dev_gettype+0x1a>
ffffffffc0208e96:	c19c                	sw	a5,0(a1)
ffffffffc0208e98:	4501                	li	a0,0
ffffffffc0208e9a:	8082                	ret
ffffffffc0208e9c:	6791                	lui	a5,0x4
ffffffffc0208e9e:	c19c                	sw	a5,0(a1)
ffffffffc0208ea0:	4501                	li	a0,0
ffffffffc0208ea2:	8082                	ret
ffffffffc0208ea4:	1141                	addi	sp,sp,-16
ffffffffc0208ea6:	00005697          	auipc	a3,0x5
ffffffffc0208eaa:	68a68693          	addi	a3,a3,1674 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208eae:	00003617          	auipc	a2,0x3
ffffffffc0208eb2:	d6a60613          	addi	a2,a2,-662 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208eb6:	05300593          	li	a1,83
ffffffffc0208eba:	00006517          	auipc	a0,0x6
ffffffffc0208ebe:	e4e50513          	addi	a0,a0,-434 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208ec2:	e406                	sd	ra,8(sp)
ffffffffc0208ec4:	b6af70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208ec8 <dev_write>:
ffffffffc0208ec8:	c911                	beqz	a0,ffffffffc0208edc <dev_write+0x14>
ffffffffc0208eca:	4d34                	lw	a3,88(a0)
ffffffffc0208ecc:	6705                	lui	a4,0x1
ffffffffc0208ece:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208ed2:	00e69563          	bne	a3,a4,ffffffffc0208edc <dev_write+0x14>
ffffffffc0208ed6:	711c                	ld	a5,32(a0)
ffffffffc0208ed8:	4605                	li	a2,1
ffffffffc0208eda:	8782                	jr	a5
ffffffffc0208edc:	1141                	addi	sp,sp,-16
ffffffffc0208ede:	00005697          	auipc	a3,0x5
ffffffffc0208ee2:	65268693          	addi	a3,a3,1618 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208ee6:	00003617          	auipc	a2,0x3
ffffffffc0208eea:	d3260613          	addi	a2,a2,-718 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208eee:	02c00593          	li	a1,44
ffffffffc0208ef2:	00006517          	auipc	a0,0x6
ffffffffc0208ef6:	e1650513          	addi	a0,a0,-490 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208efa:	e406                	sd	ra,8(sp)
ffffffffc0208efc:	b32f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208f00 <dev_read>:
ffffffffc0208f00:	c911                	beqz	a0,ffffffffc0208f14 <dev_read+0x14>
ffffffffc0208f02:	4d34                	lw	a3,88(a0)
ffffffffc0208f04:	6705                	lui	a4,0x1
ffffffffc0208f06:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208f0a:	00e69563          	bne	a3,a4,ffffffffc0208f14 <dev_read+0x14>
ffffffffc0208f0e:	711c                	ld	a5,32(a0)
ffffffffc0208f10:	4601                	li	a2,0
ffffffffc0208f12:	8782                	jr	a5
ffffffffc0208f14:	1141                	addi	sp,sp,-16
ffffffffc0208f16:	00005697          	auipc	a3,0x5
ffffffffc0208f1a:	61a68693          	addi	a3,a3,1562 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208f1e:	00003617          	auipc	a2,0x3
ffffffffc0208f22:	cfa60613          	addi	a2,a2,-774 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208f26:	02300593          	li	a1,35
ffffffffc0208f2a:	00006517          	auipc	a0,0x6
ffffffffc0208f2e:	dde50513          	addi	a0,a0,-546 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208f32:	e406                	sd	ra,8(sp)
ffffffffc0208f34:	afaf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208f38 <dev_close>:
ffffffffc0208f38:	c909                	beqz	a0,ffffffffc0208f4a <dev_close+0x12>
ffffffffc0208f3a:	4d34                	lw	a3,88(a0)
ffffffffc0208f3c:	6705                	lui	a4,0x1
ffffffffc0208f3e:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208f42:	00e69463          	bne	a3,a4,ffffffffc0208f4a <dev_close+0x12>
ffffffffc0208f46:	6d1c                	ld	a5,24(a0)
ffffffffc0208f48:	8782                	jr	a5
ffffffffc0208f4a:	1141                	addi	sp,sp,-16
ffffffffc0208f4c:	00005697          	auipc	a3,0x5
ffffffffc0208f50:	5e468693          	addi	a3,a3,1508 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208f54:	00003617          	auipc	a2,0x3
ffffffffc0208f58:	cc460613          	addi	a2,a2,-828 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208f5c:	45e9                	li	a1,26
ffffffffc0208f5e:	00006517          	auipc	a0,0x6
ffffffffc0208f62:	daa50513          	addi	a0,a0,-598 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208f66:	e406                	sd	ra,8(sp)
ffffffffc0208f68:	ac6f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208f6c <dev_open>:
ffffffffc0208f6c:	03c5f713          	andi	a4,a1,60
ffffffffc0208f70:	eb11                	bnez	a4,ffffffffc0208f84 <dev_open+0x18>
ffffffffc0208f72:	c919                	beqz	a0,ffffffffc0208f88 <dev_open+0x1c>
ffffffffc0208f74:	4d34                	lw	a3,88(a0)
ffffffffc0208f76:	6705                	lui	a4,0x1
ffffffffc0208f78:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208f7c:	00e69663          	bne	a3,a4,ffffffffc0208f88 <dev_open+0x1c>
ffffffffc0208f80:	691c                	ld	a5,16(a0)
ffffffffc0208f82:	8782                	jr	a5
ffffffffc0208f84:	5575                	li	a0,-3
ffffffffc0208f86:	8082                	ret
ffffffffc0208f88:	1141                	addi	sp,sp,-16
ffffffffc0208f8a:	00005697          	auipc	a3,0x5
ffffffffc0208f8e:	5a668693          	addi	a3,a3,1446 # ffffffffc020e530 <syscalls+0x8c8>
ffffffffc0208f92:	00003617          	auipc	a2,0x3
ffffffffc0208f96:	c8660613          	addi	a2,a2,-890 # ffffffffc020bc18 <commands+0x250>
ffffffffc0208f9a:	45c5                	li	a1,17
ffffffffc0208f9c:	00006517          	auipc	a0,0x6
ffffffffc0208fa0:	d6c50513          	addi	a0,a0,-660 # ffffffffc020ed08 <syscalls+0x10a0>
ffffffffc0208fa4:	e406                	sd	ra,8(sp)
ffffffffc0208fa6:	a88f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208faa <dev_init>:
ffffffffc0208faa:	1141                	addi	sp,sp,-16
ffffffffc0208fac:	e406                	sd	ra,8(sp)
ffffffffc0208fae:	8c1ff0ef          	jal	ra,ffffffffc020886e <dev_init_stdin>
ffffffffc0208fb2:	ccfff0ef          	jal	ra,ffffffffc0208c80 <dev_init_stdout>
ffffffffc0208fb6:	60a2                	ld	ra,8(sp)
ffffffffc0208fb8:	0141                	addi	sp,sp,16
ffffffffc0208fba:	b67ff06f          	j	ffffffffc0208b20 <dev_init_disk0>

ffffffffc0208fbe <dev_create_inode>:
ffffffffc0208fbe:	6505                	lui	a0,0x1
ffffffffc0208fc0:	1141                	addi	sp,sp,-16
ffffffffc0208fc2:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208fc6:	e022                	sd	s0,0(sp)
ffffffffc0208fc8:	e406                	sd	ra,8(sp)
ffffffffc0208fca:	af0ff0ef          	jal	ra,ffffffffc02082ba <__alloc_inode>
ffffffffc0208fce:	842a                	mv	s0,a0
ffffffffc0208fd0:	c901                	beqz	a0,ffffffffc0208fe0 <dev_create_inode+0x22>
ffffffffc0208fd2:	4601                	li	a2,0
ffffffffc0208fd4:	00006597          	auipc	a1,0x6
ffffffffc0208fd8:	d4c58593          	addi	a1,a1,-692 # ffffffffc020ed20 <dev_node_ops>
ffffffffc0208fdc:	afaff0ef          	jal	ra,ffffffffc02082d6 <inode_init>
ffffffffc0208fe0:	60a2                	ld	ra,8(sp)
ffffffffc0208fe2:	8522                	mv	a0,s0
ffffffffc0208fe4:	6402                	ld	s0,0(sp)
ffffffffc0208fe6:	0141                	addi	sp,sp,16
ffffffffc0208fe8:	8082                	ret

ffffffffc0208fea <sfs_init>:
ffffffffc0208fea:	1141                	addi	sp,sp,-16
ffffffffc0208fec:	00006517          	auipc	a0,0x6
ffffffffc0208ff0:	c8c50513          	addi	a0,a0,-884 # ffffffffc020ec78 <syscalls+0x1010>
ffffffffc0208ff4:	e406                	sd	ra,8(sp)
ffffffffc0208ff6:	735010ef          	jal	ra,ffffffffc020af2a <sfs_mount>
ffffffffc0208ffa:	e501                	bnez	a0,ffffffffc0209002 <sfs_init+0x18>
ffffffffc0208ffc:	60a2                	ld	ra,8(sp)
ffffffffc0208ffe:	0141                	addi	sp,sp,16
ffffffffc0209000:	8082                	ret
ffffffffc0209002:	86aa                	mv	a3,a0
ffffffffc0209004:	00006617          	auipc	a2,0x6
ffffffffc0209008:	d9c60613          	addi	a2,a2,-612 # ffffffffc020eda0 <dev_node_ops+0x80>
ffffffffc020900c:	45c1                	li	a1,16
ffffffffc020900e:	00006517          	auipc	a0,0x6
ffffffffc0209012:	db250513          	addi	a0,a0,-590 # ffffffffc020edc0 <dev_node_ops+0xa0>
ffffffffc0209016:	a18f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020901a <sfs_rwblock_nolock>:
ffffffffc020901a:	7139                	addi	sp,sp,-64
ffffffffc020901c:	f822                	sd	s0,48(sp)
ffffffffc020901e:	f426                	sd	s1,40(sp)
ffffffffc0209020:	fc06                	sd	ra,56(sp)
ffffffffc0209022:	842a                	mv	s0,a0
ffffffffc0209024:	84b6                	mv	s1,a3
ffffffffc0209026:	e211                	bnez	a2,ffffffffc020902a <sfs_rwblock_nolock+0x10>
ffffffffc0209028:	e715                	bnez	a4,ffffffffc0209054 <sfs_rwblock_nolock+0x3a>
ffffffffc020902a:	405c                	lw	a5,4(s0)
ffffffffc020902c:	02f67463          	bgeu	a2,a5,ffffffffc0209054 <sfs_rwblock_nolock+0x3a>
ffffffffc0209030:	00c6169b          	slliw	a3,a2,0xc
ffffffffc0209034:	1682                	slli	a3,a3,0x20
ffffffffc0209036:	6605                	lui	a2,0x1
ffffffffc0209038:	9281                	srli	a3,a3,0x20
ffffffffc020903a:	850a                	mv	a0,sp
ffffffffc020903c:	f88fc0ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc0209040:	85aa                	mv	a1,a0
ffffffffc0209042:	7808                	ld	a0,48(s0)
ffffffffc0209044:	8626                	mv	a2,s1
ffffffffc0209046:	7118                	ld	a4,32(a0)
ffffffffc0209048:	9702                	jalr	a4
ffffffffc020904a:	70e2                	ld	ra,56(sp)
ffffffffc020904c:	7442                	ld	s0,48(sp)
ffffffffc020904e:	74a2                	ld	s1,40(sp)
ffffffffc0209050:	6121                	addi	sp,sp,64
ffffffffc0209052:	8082                	ret
ffffffffc0209054:	00006697          	auipc	a3,0x6
ffffffffc0209058:	d8468693          	addi	a3,a3,-636 # ffffffffc020edd8 <dev_node_ops+0xb8>
ffffffffc020905c:	00003617          	auipc	a2,0x3
ffffffffc0209060:	bbc60613          	addi	a2,a2,-1092 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209064:	45d5                	li	a1,21
ffffffffc0209066:	00006517          	auipc	a0,0x6
ffffffffc020906a:	daa50513          	addi	a0,a0,-598 # ffffffffc020ee10 <dev_node_ops+0xf0>
ffffffffc020906e:	9c0f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209072 <sfs_rblock>:
ffffffffc0209072:	7139                	addi	sp,sp,-64
ffffffffc0209074:	ec4e                	sd	s3,24(sp)
ffffffffc0209076:	89b6                	mv	s3,a3
ffffffffc0209078:	f822                	sd	s0,48(sp)
ffffffffc020907a:	f04a                	sd	s2,32(sp)
ffffffffc020907c:	e852                	sd	s4,16(sp)
ffffffffc020907e:	fc06                	sd	ra,56(sp)
ffffffffc0209080:	f426                	sd	s1,40(sp)
ffffffffc0209082:	e456                	sd	s5,8(sp)
ffffffffc0209084:	8a2a                	mv	s4,a0
ffffffffc0209086:	892e                	mv	s2,a1
ffffffffc0209088:	8432                	mv	s0,a2
ffffffffc020908a:	2e0000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc020908e:	04098063          	beqz	s3,ffffffffc02090ce <sfs_rblock+0x5c>
ffffffffc0209092:	013409bb          	addw	s3,s0,s3
ffffffffc0209096:	6a85                	lui	s5,0x1
ffffffffc0209098:	a021                	j	ffffffffc02090a0 <sfs_rblock+0x2e>
ffffffffc020909a:	9956                	add	s2,s2,s5
ffffffffc020909c:	02898963          	beq	s3,s0,ffffffffc02090ce <sfs_rblock+0x5c>
ffffffffc02090a0:	8622                	mv	a2,s0
ffffffffc02090a2:	85ca                	mv	a1,s2
ffffffffc02090a4:	4705                	li	a4,1
ffffffffc02090a6:	4681                	li	a3,0
ffffffffc02090a8:	8552                	mv	a0,s4
ffffffffc02090aa:	f71ff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc02090ae:	84aa                	mv	s1,a0
ffffffffc02090b0:	2405                	addiw	s0,s0,1
ffffffffc02090b2:	d565                	beqz	a0,ffffffffc020909a <sfs_rblock+0x28>
ffffffffc02090b4:	8552                	mv	a0,s4
ffffffffc02090b6:	2c4000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc02090ba:	70e2                	ld	ra,56(sp)
ffffffffc02090bc:	7442                	ld	s0,48(sp)
ffffffffc02090be:	7902                	ld	s2,32(sp)
ffffffffc02090c0:	69e2                	ld	s3,24(sp)
ffffffffc02090c2:	6a42                	ld	s4,16(sp)
ffffffffc02090c4:	6aa2                	ld	s5,8(sp)
ffffffffc02090c6:	8526                	mv	a0,s1
ffffffffc02090c8:	74a2                	ld	s1,40(sp)
ffffffffc02090ca:	6121                	addi	sp,sp,64
ffffffffc02090cc:	8082                	ret
ffffffffc02090ce:	4481                	li	s1,0
ffffffffc02090d0:	b7d5                	j	ffffffffc02090b4 <sfs_rblock+0x42>

ffffffffc02090d2 <sfs_wblock>:
ffffffffc02090d2:	7139                	addi	sp,sp,-64
ffffffffc02090d4:	ec4e                	sd	s3,24(sp)
ffffffffc02090d6:	89b6                	mv	s3,a3
ffffffffc02090d8:	f822                	sd	s0,48(sp)
ffffffffc02090da:	f04a                	sd	s2,32(sp)
ffffffffc02090dc:	e852                	sd	s4,16(sp)
ffffffffc02090de:	fc06                	sd	ra,56(sp)
ffffffffc02090e0:	f426                	sd	s1,40(sp)
ffffffffc02090e2:	e456                	sd	s5,8(sp)
ffffffffc02090e4:	8a2a                	mv	s4,a0
ffffffffc02090e6:	892e                	mv	s2,a1
ffffffffc02090e8:	8432                	mv	s0,a2
ffffffffc02090ea:	280000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc02090ee:	04098063          	beqz	s3,ffffffffc020912e <sfs_wblock+0x5c>
ffffffffc02090f2:	013409bb          	addw	s3,s0,s3
ffffffffc02090f6:	6a85                	lui	s5,0x1
ffffffffc02090f8:	a021                	j	ffffffffc0209100 <sfs_wblock+0x2e>
ffffffffc02090fa:	9956                	add	s2,s2,s5
ffffffffc02090fc:	02898963          	beq	s3,s0,ffffffffc020912e <sfs_wblock+0x5c>
ffffffffc0209100:	8622                	mv	a2,s0
ffffffffc0209102:	85ca                	mv	a1,s2
ffffffffc0209104:	4705                	li	a4,1
ffffffffc0209106:	4685                	li	a3,1
ffffffffc0209108:	8552                	mv	a0,s4
ffffffffc020910a:	f11ff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc020910e:	84aa                	mv	s1,a0
ffffffffc0209110:	2405                	addiw	s0,s0,1
ffffffffc0209112:	d565                	beqz	a0,ffffffffc02090fa <sfs_wblock+0x28>
ffffffffc0209114:	8552                	mv	a0,s4
ffffffffc0209116:	264000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc020911a:	70e2                	ld	ra,56(sp)
ffffffffc020911c:	7442                	ld	s0,48(sp)
ffffffffc020911e:	7902                	ld	s2,32(sp)
ffffffffc0209120:	69e2                	ld	s3,24(sp)
ffffffffc0209122:	6a42                	ld	s4,16(sp)
ffffffffc0209124:	6aa2                	ld	s5,8(sp)
ffffffffc0209126:	8526                	mv	a0,s1
ffffffffc0209128:	74a2                	ld	s1,40(sp)
ffffffffc020912a:	6121                	addi	sp,sp,64
ffffffffc020912c:	8082                	ret
ffffffffc020912e:	4481                	li	s1,0
ffffffffc0209130:	b7d5                	j	ffffffffc0209114 <sfs_wblock+0x42>

ffffffffc0209132 <sfs_rbuf>:
ffffffffc0209132:	7179                	addi	sp,sp,-48
ffffffffc0209134:	f406                	sd	ra,40(sp)
ffffffffc0209136:	f022                	sd	s0,32(sp)
ffffffffc0209138:	ec26                	sd	s1,24(sp)
ffffffffc020913a:	e84a                	sd	s2,16(sp)
ffffffffc020913c:	e44e                	sd	s3,8(sp)
ffffffffc020913e:	e052                	sd	s4,0(sp)
ffffffffc0209140:	6785                	lui	a5,0x1
ffffffffc0209142:	04f77863          	bgeu	a4,a5,ffffffffc0209192 <sfs_rbuf+0x60>
ffffffffc0209146:	84ba                	mv	s1,a4
ffffffffc0209148:	9732                	add	a4,a4,a2
ffffffffc020914a:	89b2                	mv	s3,a2
ffffffffc020914c:	04e7e363          	bltu	a5,a4,ffffffffc0209192 <sfs_rbuf+0x60>
ffffffffc0209150:	8936                	mv	s2,a3
ffffffffc0209152:	842a                	mv	s0,a0
ffffffffc0209154:	8a2e                	mv	s4,a1
ffffffffc0209156:	214000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc020915a:	642c                	ld	a1,72(s0)
ffffffffc020915c:	864a                	mv	a2,s2
ffffffffc020915e:	4705                	li	a4,1
ffffffffc0209160:	4681                	li	a3,0
ffffffffc0209162:	8522                	mv	a0,s0
ffffffffc0209164:	eb7ff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc0209168:	892a                	mv	s2,a0
ffffffffc020916a:	cd09                	beqz	a0,ffffffffc0209184 <sfs_rbuf+0x52>
ffffffffc020916c:	8522                	mv	a0,s0
ffffffffc020916e:	20c000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc0209172:	70a2                	ld	ra,40(sp)
ffffffffc0209174:	7402                	ld	s0,32(sp)
ffffffffc0209176:	64e2                	ld	s1,24(sp)
ffffffffc0209178:	69a2                	ld	s3,8(sp)
ffffffffc020917a:	6a02                	ld	s4,0(sp)
ffffffffc020917c:	854a                	mv	a0,s2
ffffffffc020917e:	6942                	ld	s2,16(sp)
ffffffffc0209180:	6145                	addi	sp,sp,48
ffffffffc0209182:	8082                	ret
ffffffffc0209184:	642c                	ld	a1,72(s0)
ffffffffc0209186:	864e                	mv	a2,s3
ffffffffc0209188:	8552                	mv	a0,s4
ffffffffc020918a:	95a6                	add	a1,a1,s1
ffffffffc020918c:	0e4020ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0209190:	bff1                	j	ffffffffc020916c <sfs_rbuf+0x3a>
ffffffffc0209192:	00006697          	auipc	a3,0x6
ffffffffc0209196:	c9668693          	addi	a3,a3,-874 # ffffffffc020ee28 <dev_node_ops+0x108>
ffffffffc020919a:	00003617          	auipc	a2,0x3
ffffffffc020919e:	a7e60613          	addi	a2,a2,-1410 # ffffffffc020bc18 <commands+0x250>
ffffffffc02091a2:	05500593          	li	a1,85
ffffffffc02091a6:	00006517          	auipc	a0,0x6
ffffffffc02091aa:	c6a50513          	addi	a0,a0,-918 # ffffffffc020ee10 <dev_node_ops+0xf0>
ffffffffc02091ae:	880f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02091b2 <sfs_wbuf>:
ffffffffc02091b2:	7139                	addi	sp,sp,-64
ffffffffc02091b4:	fc06                	sd	ra,56(sp)
ffffffffc02091b6:	f822                	sd	s0,48(sp)
ffffffffc02091b8:	f426                	sd	s1,40(sp)
ffffffffc02091ba:	f04a                	sd	s2,32(sp)
ffffffffc02091bc:	ec4e                	sd	s3,24(sp)
ffffffffc02091be:	e852                	sd	s4,16(sp)
ffffffffc02091c0:	e456                	sd	s5,8(sp)
ffffffffc02091c2:	6785                	lui	a5,0x1
ffffffffc02091c4:	06f77163          	bgeu	a4,a5,ffffffffc0209226 <sfs_wbuf+0x74>
ffffffffc02091c8:	893a                	mv	s2,a4
ffffffffc02091ca:	9732                	add	a4,a4,a2
ffffffffc02091cc:	8a32                	mv	s4,a2
ffffffffc02091ce:	04e7ec63          	bltu	a5,a4,ffffffffc0209226 <sfs_wbuf+0x74>
ffffffffc02091d2:	842a                	mv	s0,a0
ffffffffc02091d4:	89b6                	mv	s3,a3
ffffffffc02091d6:	8aae                	mv	s5,a1
ffffffffc02091d8:	192000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc02091dc:	642c                	ld	a1,72(s0)
ffffffffc02091de:	4705                	li	a4,1
ffffffffc02091e0:	4681                	li	a3,0
ffffffffc02091e2:	864e                	mv	a2,s3
ffffffffc02091e4:	8522                	mv	a0,s0
ffffffffc02091e6:	e35ff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc02091ea:	84aa                	mv	s1,a0
ffffffffc02091ec:	cd11                	beqz	a0,ffffffffc0209208 <sfs_wbuf+0x56>
ffffffffc02091ee:	8522                	mv	a0,s0
ffffffffc02091f0:	18a000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc02091f4:	70e2                	ld	ra,56(sp)
ffffffffc02091f6:	7442                	ld	s0,48(sp)
ffffffffc02091f8:	7902                	ld	s2,32(sp)
ffffffffc02091fa:	69e2                	ld	s3,24(sp)
ffffffffc02091fc:	6a42                	ld	s4,16(sp)
ffffffffc02091fe:	6aa2                	ld	s5,8(sp)
ffffffffc0209200:	8526                	mv	a0,s1
ffffffffc0209202:	74a2                	ld	s1,40(sp)
ffffffffc0209204:	6121                	addi	sp,sp,64
ffffffffc0209206:	8082                	ret
ffffffffc0209208:	6428                	ld	a0,72(s0)
ffffffffc020920a:	8652                	mv	a2,s4
ffffffffc020920c:	85d6                	mv	a1,s5
ffffffffc020920e:	954a                	add	a0,a0,s2
ffffffffc0209210:	060020ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc0209214:	642c                	ld	a1,72(s0)
ffffffffc0209216:	4705                	li	a4,1
ffffffffc0209218:	4685                	li	a3,1
ffffffffc020921a:	864e                	mv	a2,s3
ffffffffc020921c:	8522                	mv	a0,s0
ffffffffc020921e:	dfdff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc0209222:	84aa                	mv	s1,a0
ffffffffc0209224:	b7e9                	j	ffffffffc02091ee <sfs_wbuf+0x3c>
ffffffffc0209226:	00006697          	auipc	a3,0x6
ffffffffc020922a:	c0268693          	addi	a3,a3,-1022 # ffffffffc020ee28 <dev_node_ops+0x108>
ffffffffc020922e:	00003617          	auipc	a2,0x3
ffffffffc0209232:	9ea60613          	addi	a2,a2,-1558 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209236:	06b00593          	li	a1,107
ffffffffc020923a:	00006517          	auipc	a0,0x6
ffffffffc020923e:	bd650513          	addi	a0,a0,-1066 # ffffffffc020ee10 <dev_node_ops+0xf0>
ffffffffc0209242:	fedf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209246 <sfs_sync_super>:
ffffffffc0209246:	1101                	addi	sp,sp,-32
ffffffffc0209248:	ec06                	sd	ra,24(sp)
ffffffffc020924a:	e822                	sd	s0,16(sp)
ffffffffc020924c:	e426                	sd	s1,8(sp)
ffffffffc020924e:	842a                	mv	s0,a0
ffffffffc0209250:	11a000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc0209254:	6428                	ld	a0,72(s0)
ffffffffc0209256:	6605                	lui	a2,0x1
ffffffffc0209258:	4581                	li	a1,0
ffffffffc020925a:	7c5010ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc020925e:	6428                	ld	a0,72(s0)
ffffffffc0209260:	85a2                	mv	a1,s0
ffffffffc0209262:	02c00613          	li	a2,44
ffffffffc0209266:	00a020ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc020926a:	642c                	ld	a1,72(s0)
ffffffffc020926c:	4701                	li	a4,0
ffffffffc020926e:	4685                	li	a3,1
ffffffffc0209270:	4601                	li	a2,0
ffffffffc0209272:	8522                	mv	a0,s0
ffffffffc0209274:	da7ff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc0209278:	84aa                	mv	s1,a0
ffffffffc020927a:	8522                	mv	a0,s0
ffffffffc020927c:	0fe000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc0209280:	60e2                	ld	ra,24(sp)
ffffffffc0209282:	6442                	ld	s0,16(sp)
ffffffffc0209284:	8526                	mv	a0,s1
ffffffffc0209286:	64a2                	ld	s1,8(sp)
ffffffffc0209288:	6105                	addi	sp,sp,32
ffffffffc020928a:	8082                	ret

ffffffffc020928c <sfs_sync_freemap>:
ffffffffc020928c:	7139                	addi	sp,sp,-64
ffffffffc020928e:	ec4e                	sd	s3,24(sp)
ffffffffc0209290:	e852                	sd	s4,16(sp)
ffffffffc0209292:	00456983          	lwu	s3,4(a0)
ffffffffc0209296:	8a2a                	mv	s4,a0
ffffffffc0209298:	7d08                	ld	a0,56(a0)
ffffffffc020929a:	67a1                	lui	a5,0x8
ffffffffc020929c:	17fd                	addi	a5,a5,-1
ffffffffc020929e:	4581                	li	a1,0
ffffffffc02092a0:	f822                	sd	s0,48(sp)
ffffffffc02092a2:	fc06                	sd	ra,56(sp)
ffffffffc02092a4:	f426                	sd	s1,40(sp)
ffffffffc02092a6:	f04a                	sd	s2,32(sp)
ffffffffc02092a8:	e456                	sd	s5,8(sp)
ffffffffc02092aa:	99be                	add	s3,s3,a5
ffffffffc02092ac:	6c3010ef          	jal	ra,ffffffffc020b16e <bitmap_getdata>
ffffffffc02092b0:	00f9d993          	srli	s3,s3,0xf
ffffffffc02092b4:	842a                	mv	s0,a0
ffffffffc02092b6:	8552                	mv	a0,s4
ffffffffc02092b8:	0b2000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc02092bc:	04098163          	beqz	s3,ffffffffc02092fe <sfs_sync_freemap+0x72>
ffffffffc02092c0:	09b2                	slli	s3,s3,0xc
ffffffffc02092c2:	99a2                	add	s3,s3,s0
ffffffffc02092c4:	4909                	li	s2,2
ffffffffc02092c6:	6a85                	lui	s5,0x1
ffffffffc02092c8:	a021                	j	ffffffffc02092d0 <sfs_sync_freemap+0x44>
ffffffffc02092ca:	2905                	addiw	s2,s2,1
ffffffffc02092cc:	02898963          	beq	s3,s0,ffffffffc02092fe <sfs_sync_freemap+0x72>
ffffffffc02092d0:	85a2                	mv	a1,s0
ffffffffc02092d2:	864a                	mv	a2,s2
ffffffffc02092d4:	4705                	li	a4,1
ffffffffc02092d6:	4685                	li	a3,1
ffffffffc02092d8:	8552                	mv	a0,s4
ffffffffc02092da:	d41ff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc02092de:	84aa                	mv	s1,a0
ffffffffc02092e0:	9456                	add	s0,s0,s5
ffffffffc02092e2:	d565                	beqz	a0,ffffffffc02092ca <sfs_sync_freemap+0x3e>
ffffffffc02092e4:	8552                	mv	a0,s4
ffffffffc02092e6:	094000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc02092ea:	70e2                	ld	ra,56(sp)
ffffffffc02092ec:	7442                	ld	s0,48(sp)
ffffffffc02092ee:	7902                	ld	s2,32(sp)
ffffffffc02092f0:	69e2                	ld	s3,24(sp)
ffffffffc02092f2:	6a42                	ld	s4,16(sp)
ffffffffc02092f4:	6aa2                	ld	s5,8(sp)
ffffffffc02092f6:	8526                	mv	a0,s1
ffffffffc02092f8:	74a2                	ld	s1,40(sp)
ffffffffc02092fa:	6121                	addi	sp,sp,64
ffffffffc02092fc:	8082                	ret
ffffffffc02092fe:	4481                	li	s1,0
ffffffffc0209300:	b7d5                	j	ffffffffc02092e4 <sfs_sync_freemap+0x58>

ffffffffc0209302 <sfs_clear_block>:
ffffffffc0209302:	7179                	addi	sp,sp,-48
ffffffffc0209304:	f022                	sd	s0,32(sp)
ffffffffc0209306:	e84a                	sd	s2,16(sp)
ffffffffc0209308:	e44e                	sd	s3,8(sp)
ffffffffc020930a:	f406                	sd	ra,40(sp)
ffffffffc020930c:	89b2                	mv	s3,a2
ffffffffc020930e:	ec26                	sd	s1,24(sp)
ffffffffc0209310:	892a                	mv	s2,a0
ffffffffc0209312:	842e                	mv	s0,a1
ffffffffc0209314:	056000ef          	jal	ra,ffffffffc020936a <lock_sfs_io>
ffffffffc0209318:	04893503          	ld	a0,72(s2) # 4048 <_binary_bin_swap_img_size-0x3cb8>
ffffffffc020931c:	6605                	lui	a2,0x1
ffffffffc020931e:	4581                	li	a1,0
ffffffffc0209320:	6ff010ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc0209324:	02098d63          	beqz	s3,ffffffffc020935e <sfs_clear_block+0x5c>
ffffffffc0209328:	013409bb          	addw	s3,s0,s3
ffffffffc020932c:	a019                	j	ffffffffc0209332 <sfs_clear_block+0x30>
ffffffffc020932e:	02898863          	beq	s3,s0,ffffffffc020935e <sfs_clear_block+0x5c>
ffffffffc0209332:	04893583          	ld	a1,72(s2)
ffffffffc0209336:	8622                	mv	a2,s0
ffffffffc0209338:	4705                	li	a4,1
ffffffffc020933a:	4685                	li	a3,1
ffffffffc020933c:	854a                	mv	a0,s2
ffffffffc020933e:	cddff0ef          	jal	ra,ffffffffc020901a <sfs_rwblock_nolock>
ffffffffc0209342:	84aa                	mv	s1,a0
ffffffffc0209344:	2405                	addiw	s0,s0,1
ffffffffc0209346:	d565                	beqz	a0,ffffffffc020932e <sfs_clear_block+0x2c>
ffffffffc0209348:	854a                	mv	a0,s2
ffffffffc020934a:	030000ef          	jal	ra,ffffffffc020937a <unlock_sfs_io>
ffffffffc020934e:	70a2                	ld	ra,40(sp)
ffffffffc0209350:	7402                	ld	s0,32(sp)
ffffffffc0209352:	6942                	ld	s2,16(sp)
ffffffffc0209354:	69a2                	ld	s3,8(sp)
ffffffffc0209356:	8526                	mv	a0,s1
ffffffffc0209358:	64e2                	ld	s1,24(sp)
ffffffffc020935a:	6145                	addi	sp,sp,48
ffffffffc020935c:	8082                	ret
ffffffffc020935e:	4481                	li	s1,0
ffffffffc0209360:	b7e5                	j	ffffffffc0209348 <sfs_clear_block+0x46>

ffffffffc0209362 <lock_sfs_fs>:
ffffffffc0209362:	05050513          	addi	a0,a0,80
ffffffffc0209366:	c7cfb06f          	j	ffffffffc02047e2 <down>

ffffffffc020936a <lock_sfs_io>:
ffffffffc020936a:	06850513          	addi	a0,a0,104
ffffffffc020936e:	c74fb06f          	j	ffffffffc02047e2 <down>

ffffffffc0209372 <unlock_sfs_fs>:
ffffffffc0209372:	05050513          	addi	a0,a0,80
ffffffffc0209376:	c68fb06f          	j	ffffffffc02047de <up>

ffffffffc020937a <unlock_sfs_io>:
ffffffffc020937a:	06850513          	addi	a0,a0,104
ffffffffc020937e:	c60fb06f          	j	ffffffffc02047de <up>

ffffffffc0209382 <sfs_opendir>:
ffffffffc0209382:	0235f593          	andi	a1,a1,35
ffffffffc0209386:	4501                	li	a0,0
ffffffffc0209388:	e191                	bnez	a1,ffffffffc020938c <sfs_opendir+0xa>
ffffffffc020938a:	8082                	ret
ffffffffc020938c:	553d                	li	a0,-17
ffffffffc020938e:	8082                	ret

ffffffffc0209390 <sfs_openfile>:
ffffffffc0209390:	4501                	li	a0,0
ffffffffc0209392:	8082                	ret

ffffffffc0209394 <sfs_gettype>:
ffffffffc0209394:	1141                	addi	sp,sp,-16
ffffffffc0209396:	e406                	sd	ra,8(sp)
ffffffffc0209398:	c939                	beqz	a0,ffffffffc02093ee <sfs_gettype+0x5a>
ffffffffc020939a:	4d34                	lw	a3,88(a0)
ffffffffc020939c:	6785                	lui	a5,0x1
ffffffffc020939e:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02093a2:	04e69663          	bne	a3,a4,ffffffffc02093ee <sfs_gettype+0x5a>
ffffffffc02093a6:	6114                	ld	a3,0(a0)
ffffffffc02093a8:	4709                	li	a4,2
ffffffffc02093aa:	0046d683          	lhu	a3,4(a3)
ffffffffc02093ae:	02e68a63          	beq	a3,a4,ffffffffc02093e2 <sfs_gettype+0x4e>
ffffffffc02093b2:	470d                	li	a4,3
ffffffffc02093b4:	02e68163          	beq	a3,a4,ffffffffc02093d6 <sfs_gettype+0x42>
ffffffffc02093b8:	4705                	li	a4,1
ffffffffc02093ba:	00e68f63          	beq	a3,a4,ffffffffc02093d8 <sfs_gettype+0x44>
ffffffffc02093be:	00006617          	auipc	a2,0x6
ffffffffc02093c2:	b0260613          	addi	a2,a2,-1278 # ffffffffc020eec0 <dev_node_ops+0x1a0>
ffffffffc02093c6:	3b700593          	li	a1,951
ffffffffc02093ca:	00006517          	auipc	a0,0x6
ffffffffc02093ce:	ade50513          	addi	a0,a0,-1314 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02093d2:	e5df60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02093d6:	678d                	lui	a5,0x3
ffffffffc02093d8:	60a2                	ld	ra,8(sp)
ffffffffc02093da:	c19c                	sw	a5,0(a1)
ffffffffc02093dc:	4501                	li	a0,0
ffffffffc02093de:	0141                	addi	sp,sp,16
ffffffffc02093e0:	8082                	ret
ffffffffc02093e2:	60a2                	ld	ra,8(sp)
ffffffffc02093e4:	6789                	lui	a5,0x2
ffffffffc02093e6:	c19c                	sw	a5,0(a1)
ffffffffc02093e8:	4501                	li	a0,0
ffffffffc02093ea:	0141                	addi	sp,sp,16
ffffffffc02093ec:	8082                	ret
ffffffffc02093ee:	00006697          	auipc	a3,0x6
ffffffffc02093f2:	a8268693          	addi	a3,a3,-1406 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc02093f6:	00003617          	auipc	a2,0x3
ffffffffc02093fa:	82260613          	addi	a2,a2,-2014 # ffffffffc020bc18 <commands+0x250>
ffffffffc02093fe:	3ab00593          	li	a1,939
ffffffffc0209402:	00006517          	auipc	a0,0x6
ffffffffc0209406:	aa650513          	addi	a0,a0,-1370 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020940a:	e25f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020940e <sfs_fsync>:
ffffffffc020940e:	7179                	addi	sp,sp,-48
ffffffffc0209410:	ec26                	sd	s1,24(sp)
ffffffffc0209412:	7524                	ld	s1,104(a0)
ffffffffc0209414:	f406                	sd	ra,40(sp)
ffffffffc0209416:	f022                	sd	s0,32(sp)
ffffffffc0209418:	e84a                	sd	s2,16(sp)
ffffffffc020941a:	e44e                	sd	s3,8(sp)
ffffffffc020941c:	c4bd                	beqz	s1,ffffffffc020948a <sfs_fsync+0x7c>
ffffffffc020941e:	0b04a783          	lw	a5,176(s1)
ffffffffc0209422:	e7a5                	bnez	a5,ffffffffc020948a <sfs_fsync+0x7c>
ffffffffc0209424:	4d38                	lw	a4,88(a0)
ffffffffc0209426:	6785                	lui	a5,0x1
ffffffffc0209428:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020942c:	842a                	mv	s0,a0
ffffffffc020942e:	06f71e63          	bne	a4,a5,ffffffffc02094aa <sfs_fsync+0x9c>
ffffffffc0209432:	691c                	ld	a5,16(a0)
ffffffffc0209434:	4901                	li	s2,0
ffffffffc0209436:	eb89                	bnez	a5,ffffffffc0209448 <sfs_fsync+0x3a>
ffffffffc0209438:	70a2                	ld	ra,40(sp)
ffffffffc020943a:	7402                	ld	s0,32(sp)
ffffffffc020943c:	64e2                	ld	s1,24(sp)
ffffffffc020943e:	69a2                	ld	s3,8(sp)
ffffffffc0209440:	854a                	mv	a0,s2
ffffffffc0209442:	6942                	ld	s2,16(sp)
ffffffffc0209444:	6145                	addi	sp,sp,48
ffffffffc0209446:	8082                	ret
ffffffffc0209448:	02050993          	addi	s3,a0,32
ffffffffc020944c:	854e                	mv	a0,s3
ffffffffc020944e:	b94fb0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0209452:	681c                	ld	a5,16(s0)
ffffffffc0209454:	ef81                	bnez	a5,ffffffffc020946c <sfs_fsync+0x5e>
ffffffffc0209456:	854e                	mv	a0,s3
ffffffffc0209458:	b86fb0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020945c:	70a2                	ld	ra,40(sp)
ffffffffc020945e:	7402                	ld	s0,32(sp)
ffffffffc0209460:	64e2                	ld	s1,24(sp)
ffffffffc0209462:	69a2                	ld	s3,8(sp)
ffffffffc0209464:	854a                	mv	a0,s2
ffffffffc0209466:	6942                	ld	s2,16(sp)
ffffffffc0209468:	6145                	addi	sp,sp,48
ffffffffc020946a:	8082                	ret
ffffffffc020946c:	4414                	lw	a3,8(s0)
ffffffffc020946e:	600c                	ld	a1,0(s0)
ffffffffc0209470:	00043823          	sd	zero,16(s0)
ffffffffc0209474:	4701                	li	a4,0
ffffffffc0209476:	04000613          	li	a2,64
ffffffffc020947a:	8526                	mv	a0,s1
ffffffffc020947c:	d37ff0ef          	jal	ra,ffffffffc02091b2 <sfs_wbuf>
ffffffffc0209480:	892a                	mv	s2,a0
ffffffffc0209482:	d971                	beqz	a0,ffffffffc0209456 <sfs_fsync+0x48>
ffffffffc0209484:	4785                	li	a5,1
ffffffffc0209486:	e81c                	sd	a5,16(s0)
ffffffffc0209488:	b7f9                	j	ffffffffc0209456 <sfs_fsync+0x48>
ffffffffc020948a:	00006697          	auipc	a3,0x6
ffffffffc020948e:	a4e68693          	addi	a3,a3,-1458 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc0209492:	00002617          	auipc	a2,0x2
ffffffffc0209496:	78660613          	addi	a2,a2,1926 # ffffffffc020bc18 <commands+0x250>
ffffffffc020949a:	2ce00593          	li	a1,718
ffffffffc020949e:	00006517          	auipc	a0,0x6
ffffffffc02094a2:	a0a50513          	addi	a0,a0,-1526 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02094a6:	d89f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02094aa:	00006697          	auipc	a3,0x6
ffffffffc02094ae:	9c668693          	addi	a3,a3,-1594 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc02094b2:	00002617          	auipc	a2,0x2
ffffffffc02094b6:	76660613          	addi	a2,a2,1894 # ffffffffc020bc18 <commands+0x250>
ffffffffc02094ba:	2cf00593          	li	a1,719
ffffffffc02094be:	00006517          	auipc	a0,0x6
ffffffffc02094c2:	9ea50513          	addi	a0,a0,-1558 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02094c6:	d69f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02094ca <sfs_fstat>:
ffffffffc02094ca:	1101                	addi	sp,sp,-32
ffffffffc02094cc:	e426                	sd	s1,8(sp)
ffffffffc02094ce:	84ae                	mv	s1,a1
ffffffffc02094d0:	e822                	sd	s0,16(sp)
ffffffffc02094d2:	02000613          	li	a2,32
ffffffffc02094d6:	842a                	mv	s0,a0
ffffffffc02094d8:	4581                	li	a1,0
ffffffffc02094da:	8526                	mv	a0,s1
ffffffffc02094dc:	ec06                	sd	ra,24(sp)
ffffffffc02094de:	541010ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc02094e2:	c439                	beqz	s0,ffffffffc0209530 <sfs_fstat+0x66>
ffffffffc02094e4:	783c                	ld	a5,112(s0)
ffffffffc02094e6:	c7a9                	beqz	a5,ffffffffc0209530 <sfs_fstat+0x66>
ffffffffc02094e8:	6bbc                	ld	a5,80(a5)
ffffffffc02094ea:	c3b9                	beqz	a5,ffffffffc0209530 <sfs_fstat+0x66>
ffffffffc02094ec:	00005597          	auipc	a1,0x5
ffffffffc02094f0:	10c58593          	addi	a1,a1,268 # ffffffffc020e5f8 <syscalls+0x990>
ffffffffc02094f4:	8522                	mv	a0,s0
ffffffffc02094f6:	e5bfe0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc02094fa:	783c                	ld	a5,112(s0)
ffffffffc02094fc:	85a6                	mv	a1,s1
ffffffffc02094fe:	8522                	mv	a0,s0
ffffffffc0209500:	6bbc                	ld	a5,80(a5)
ffffffffc0209502:	9782                	jalr	a5
ffffffffc0209504:	e10d                	bnez	a0,ffffffffc0209526 <sfs_fstat+0x5c>
ffffffffc0209506:	4c38                	lw	a4,88(s0)
ffffffffc0209508:	6785                	lui	a5,0x1
ffffffffc020950a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020950e:	04f71163          	bne	a4,a5,ffffffffc0209550 <sfs_fstat+0x86>
ffffffffc0209512:	601c                	ld	a5,0(s0)
ffffffffc0209514:	0067d683          	lhu	a3,6(a5)
ffffffffc0209518:	0087e703          	lwu	a4,8(a5)
ffffffffc020951c:	0007e783          	lwu	a5,0(a5)
ffffffffc0209520:	e494                	sd	a3,8(s1)
ffffffffc0209522:	e898                	sd	a4,16(s1)
ffffffffc0209524:	ec9c                	sd	a5,24(s1)
ffffffffc0209526:	60e2                	ld	ra,24(sp)
ffffffffc0209528:	6442                	ld	s0,16(sp)
ffffffffc020952a:	64a2                	ld	s1,8(sp)
ffffffffc020952c:	6105                	addi	sp,sp,32
ffffffffc020952e:	8082                	ret
ffffffffc0209530:	00005697          	auipc	a3,0x5
ffffffffc0209534:	06068693          	addi	a3,a3,96 # ffffffffc020e590 <syscalls+0x928>
ffffffffc0209538:	00002617          	auipc	a2,0x2
ffffffffc020953c:	6e060613          	addi	a2,a2,1760 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209540:	2bf00593          	li	a1,703
ffffffffc0209544:	00006517          	auipc	a0,0x6
ffffffffc0209548:	96450513          	addi	a0,a0,-1692 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020954c:	ce3f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209550:	00006697          	auipc	a3,0x6
ffffffffc0209554:	92068693          	addi	a3,a3,-1760 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc0209558:	00002617          	auipc	a2,0x2
ffffffffc020955c:	6c060613          	addi	a2,a2,1728 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209560:	2c200593          	li	a1,706
ffffffffc0209564:	00006517          	auipc	a0,0x6
ffffffffc0209568:	94450513          	addi	a0,a0,-1724 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020956c:	cc3f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209570 <sfs_tryseek>:
ffffffffc0209570:	080007b7          	lui	a5,0x8000
ffffffffc0209574:	04f5fd63          	bgeu	a1,a5,ffffffffc02095ce <sfs_tryseek+0x5e>
ffffffffc0209578:	1101                	addi	sp,sp,-32
ffffffffc020957a:	e822                	sd	s0,16(sp)
ffffffffc020957c:	ec06                	sd	ra,24(sp)
ffffffffc020957e:	e426                	sd	s1,8(sp)
ffffffffc0209580:	842a                	mv	s0,a0
ffffffffc0209582:	c921                	beqz	a0,ffffffffc02095d2 <sfs_tryseek+0x62>
ffffffffc0209584:	4d38                	lw	a4,88(a0)
ffffffffc0209586:	6785                	lui	a5,0x1
ffffffffc0209588:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020958c:	04f71363          	bne	a4,a5,ffffffffc02095d2 <sfs_tryseek+0x62>
ffffffffc0209590:	611c                	ld	a5,0(a0)
ffffffffc0209592:	84ae                	mv	s1,a1
ffffffffc0209594:	0007e783          	lwu	a5,0(a5)
ffffffffc0209598:	02b7d563          	bge	a5,a1,ffffffffc02095c2 <sfs_tryseek+0x52>
ffffffffc020959c:	793c                	ld	a5,112(a0)
ffffffffc020959e:	cbb1                	beqz	a5,ffffffffc02095f2 <sfs_tryseek+0x82>
ffffffffc02095a0:	73bc                	ld	a5,96(a5)
ffffffffc02095a2:	cba1                	beqz	a5,ffffffffc02095f2 <sfs_tryseek+0x82>
ffffffffc02095a4:	00005597          	auipc	a1,0x5
ffffffffc02095a8:	28c58593          	addi	a1,a1,652 # ffffffffc020e830 <syscalls+0xbc8>
ffffffffc02095ac:	da5fe0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc02095b0:	783c                	ld	a5,112(s0)
ffffffffc02095b2:	8522                	mv	a0,s0
ffffffffc02095b4:	6442                	ld	s0,16(sp)
ffffffffc02095b6:	60e2                	ld	ra,24(sp)
ffffffffc02095b8:	73bc                	ld	a5,96(a5)
ffffffffc02095ba:	85a6                	mv	a1,s1
ffffffffc02095bc:	64a2                	ld	s1,8(sp)
ffffffffc02095be:	6105                	addi	sp,sp,32
ffffffffc02095c0:	8782                	jr	a5
ffffffffc02095c2:	60e2                	ld	ra,24(sp)
ffffffffc02095c4:	6442                	ld	s0,16(sp)
ffffffffc02095c6:	64a2                	ld	s1,8(sp)
ffffffffc02095c8:	4501                	li	a0,0
ffffffffc02095ca:	6105                	addi	sp,sp,32
ffffffffc02095cc:	8082                	ret
ffffffffc02095ce:	5575                	li	a0,-3
ffffffffc02095d0:	8082                	ret
ffffffffc02095d2:	00006697          	auipc	a3,0x6
ffffffffc02095d6:	89e68693          	addi	a3,a3,-1890 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc02095da:	00002617          	auipc	a2,0x2
ffffffffc02095de:	63e60613          	addi	a2,a2,1598 # ffffffffc020bc18 <commands+0x250>
ffffffffc02095e2:	3c200593          	li	a1,962
ffffffffc02095e6:	00006517          	auipc	a0,0x6
ffffffffc02095ea:	8c250513          	addi	a0,a0,-1854 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02095ee:	c41f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02095f2:	00005697          	auipc	a3,0x5
ffffffffc02095f6:	1e668693          	addi	a3,a3,486 # ffffffffc020e7d8 <syscalls+0xb70>
ffffffffc02095fa:	00002617          	auipc	a2,0x2
ffffffffc02095fe:	61e60613          	addi	a2,a2,1566 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209602:	3c400593          	li	a1,964
ffffffffc0209606:	00006517          	auipc	a0,0x6
ffffffffc020960a:	8a250513          	addi	a0,a0,-1886 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020960e:	c21f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209612 <sfs_close>:
ffffffffc0209612:	1141                	addi	sp,sp,-16
ffffffffc0209614:	e406                	sd	ra,8(sp)
ffffffffc0209616:	e022                	sd	s0,0(sp)
ffffffffc0209618:	c11d                	beqz	a0,ffffffffc020963e <sfs_close+0x2c>
ffffffffc020961a:	793c                	ld	a5,112(a0)
ffffffffc020961c:	842a                	mv	s0,a0
ffffffffc020961e:	c385                	beqz	a5,ffffffffc020963e <sfs_close+0x2c>
ffffffffc0209620:	7b9c                	ld	a5,48(a5)
ffffffffc0209622:	cf91                	beqz	a5,ffffffffc020963e <sfs_close+0x2c>
ffffffffc0209624:	00004597          	auipc	a1,0x4
ffffffffc0209628:	f5c58593          	addi	a1,a1,-164 # ffffffffc020d580 <default_pmm_manager+0xb58>
ffffffffc020962c:	d25fe0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0209630:	783c                	ld	a5,112(s0)
ffffffffc0209632:	8522                	mv	a0,s0
ffffffffc0209634:	6402                	ld	s0,0(sp)
ffffffffc0209636:	60a2                	ld	ra,8(sp)
ffffffffc0209638:	7b9c                	ld	a5,48(a5)
ffffffffc020963a:	0141                	addi	sp,sp,16
ffffffffc020963c:	8782                	jr	a5
ffffffffc020963e:	00004697          	auipc	a3,0x4
ffffffffc0209642:	ef268693          	addi	a3,a3,-270 # ffffffffc020d530 <default_pmm_manager+0xb08>
ffffffffc0209646:	00002617          	auipc	a2,0x2
ffffffffc020964a:	5d260613          	addi	a2,a2,1490 # ffffffffc020bc18 <commands+0x250>
ffffffffc020964e:	21c00593          	li	a1,540
ffffffffc0209652:	00006517          	auipc	a0,0x6
ffffffffc0209656:	85650513          	addi	a0,a0,-1962 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020965a:	bd5f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020965e <sfs_io.part.0>:
ffffffffc020965e:	1141                	addi	sp,sp,-16
ffffffffc0209660:	00006697          	auipc	a3,0x6
ffffffffc0209664:	81068693          	addi	a3,a3,-2032 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc0209668:	00002617          	auipc	a2,0x2
ffffffffc020966c:	5b060613          	addi	a2,a2,1456 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209670:	29e00593          	li	a1,670
ffffffffc0209674:	00006517          	auipc	a0,0x6
ffffffffc0209678:	83450513          	addi	a0,a0,-1996 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020967c:	e406                	sd	ra,8(sp)
ffffffffc020967e:	bb1f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209682 <sfs_block_free>:
ffffffffc0209682:	1101                	addi	sp,sp,-32
ffffffffc0209684:	e426                	sd	s1,8(sp)
ffffffffc0209686:	ec06                	sd	ra,24(sp)
ffffffffc0209688:	e822                	sd	s0,16(sp)
ffffffffc020968a:	4154                	lw	a3,4(a0)
ffffffffc020968c:	84ae                	mv	s1,a1
ffffffffc020968e:	c595                	beqz	a1,ffffffffc02096ba <sfs_block_free+0x38>
ffffffffc0209690:	02d5f563          	bgeu	a1,a3,ffffffffc02096ba <sfs_block_free+0x38>
ffffffffc0209694:	842a                	mv	s0,a0
ffffffffc0209696:	7d08                	ld	a0,56(a0)
ffffffffc0209698:	243010ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc020969c:	ed05                	bnez	a0,ffffffffc02096d4 <sfs_block_free+0x52>
ffffffffc020969e:	7c08                	ld	a0,56(s0)
ffffffffc02096a0:	85a6                	mv	a1,s1
ffffffffc02096a2:	261010ef          	jal	ra,ffffffffc020b102 <bitmap_free>
ffffffffc02096a6:	441c                	lw	a5,8(s0)
ffffffffc02096a8:	4705                	li	a4,1
ffffffffc02096aa:	60e2                	ld	ra,24(sp)
ffffffffc02096ac:	2785                	addiw	a5,a5,1
ffffffffc02096ae:	e038                	sd	a4,64(s0)
ffffffffc02096b0:	c41c                	sw	a5,8(s0)
ffffffffc02096b2:	6442                	ld	s0,16(sp)
ffffffffc02096b4:	64a2                	ld	s1,8(sp)
ffffffffc02096b6:	6105                	addi	sp,sp,32
ffffffffc02096b8:	8082                	ret
ffffffffc02096ba:	8726                	mv	a4,s1
ffffffffc02096bc:	00006617          	auipc	a2,0x6
ffffffffc02096c0:	84c60613          	addi	a2,a2,-1972 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc02096c4:	05300593          	li	a1,83
ffffffffc02096c8:	00005517          	auipc	a0,0x5
ffffffffc02096cc:	7e050513          	addi	a0,a0,2016 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02096d0:	b5ff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02096d4:	00006697          	auipc	a3,0x6
ffffffffc02096d8:	86c68693          	addi	a3,a3,-1940 # ffffffffc020ef40 <dev_node_ops+0x220>
ffffffffc02096dc:	00002617          	auipc	a2,0x2
ffffffffc02096e0:	53c60613          	addi	a2,a2,1340 # ffffffffc020bc18 <commands+0x250>
ffffffffc02096e4:	06a00593          	li	a1,106
ffffffffc02096e8:	00005517          	auipc	a0,0x5
ffffffffc02096ec:	7c050513          	addi	a0,a0,1984 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02096f0:	b3ff60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02096f4 <sfs_reclaim>:
ffffffffc02096f4:	1101                	addi	sp,sp,-32
ffffffffc02096f6:	e426                	sd	s1,8(sp)
ffffffffc02096f8:	7524                	ld	s1,104(a0)
ffffffffc02096fa:	ec06                	sd	ra,24(sp)
ffffffffc02096fc:	e822                	sd	s0,16(sp)
ffffffffc02096fe:	e04a                	sd	s2,0(sp)
ffffffffc0209700:	0e048a63          	beqz	s1,ffffffffc02097f4 <sfs_reclaim+0x100>
ffffffffc0209704:	0b04a783          	lw	a5,176(s1)
ffffffffc0209708:	0e079663          	bnez	a5,ffffffffc02097f4 <sfs_reclaim+0x100>
ffffffffc020970c:	4d38                	lw	a4,88(a0)
ffffffffc020970e:	6785                	lui	a5,0x1
ffffffffc0209710:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209714:	842a                	mv	s0,a0
ffffffffc0209716:	10f71f63          	bne	a4,a5,ffffffffc0209834 <sfs_reclaim+0x140>
ffffffffc020971a:	8526                	mv	a0,s1
ffffffffc020971c:	c47ff0ef          	jal	ra,ffffffffc0209362 <lock_sfs_fs>
ffffffffc0209720:	4c1c                	lw	a5,24(s0)
ffffffffc0209722:	0ef05963          	blez	a5,ffffffffc0209814 <sfs_reclaim+0x120>
ffffffffc0209726:	fff7871b          	addiw	a4,a5,-1
ffffffffc020972a:	cc18                	sw	a4,24(s0)
ffffffffc020972c:	eb59                	bnez	a4,ffffffffc02097c2 <sfs_reclaim+0xce>
ffffffffc020972e:	05c42903          	lw	s2,92(s0)
ffffffffc0209732:	08091863          	bnez	s2,ffffffffc02097c2 <sfs_reclaim+0xce>
ffffffffc0209736:	601c                	ld	a5,0(s0)
ffffffffc0209738:	0067d783          	lhu	a5,6(a5)
ffffffffc020973c:	e785                	bnez	a5,ffffffffc0209764 <sfs_reclaim+0x70>
ffffffffc020973e:	783c                	ld	a5,112(s0)
ffffffffc0209740:	10078a63          	beqz	a5,ffffffffc0209854 <sfs_reclaim+0x160>
ffffffffc0209744:	73bc                	ld	a5,96(a5)
ffffffffc0209746:	10078763          	beqz	a5,ffffffffc0209854 <sfs_reclaim+0x160>
ffffffffc020974a:	00005597          	auipc	a1,0x5
ffffffffc020974e:	0e658593          	addi	a1,a1,230 # ffffffffc020e830 <syscalls+0xbc8>
ffffffffc0209752:	8522                	mv	a0,s0
ffffffffc0209754:	bfdfe0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0209758:	783c                	ld	a5,112(s0)
ffffffffc020975a:	4581                	li	a1,0
ffffffffc020975c:	8522                	mv	a0,s0
ffffffffc020975e:	73bc                	ld	a5,96(a5)
ffffffffc0209760:	9782                	jalr	a5
ffffffffc0209762:	e559                	bnez	a0,ffffffffc02097f0 <sfs_reclaim+0xfc>
ffffffffc0209764:	681c                	ld	a5,16(s0)
ffffffffc0209766:	c39d                	beqz	a5,ffffffffc020978c <sfs_reclaim+0x98>
ffffffffc0209768:	783c                	ld	a5,112(s0)
ffffffffc020976a:	10078563          	beqz	a5,ffffffffc0209874 <sfs_reclaim+0x180>
ffffffffc020976e:	7b9c                	ld	a5,48(a5)
ffffffffc0209770:	10078263          	beqz	a5,ffffffffc0209874 <sfs_reclaim+0x180>
ffffffffc0209774:	8522                	mv	a0,s0
ffffffffc0209776:	00004597          	auipc	a1,0x4
ffffffffc020977a:	e0a58593          	addi	a1,a1,-502 # ffffffffc020d580 <default_pmm_manager+0xb58>
ffffffffc020977e:	bd3fe0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc0209782:	783c                	ld	a5,112(s0)
ffffffffc0209784:	8522                	mv	a0,s0
ffffffffc0209786:	7b9c                	ld	a5,48(a5)
ffffffffc0209788:	9782                	jalr	a5
ffffffffc020978a:	e13d                	bnez	a0,ffffffffc02097f0 <sfs_reclaim+0xfc>
ffffffffc020978c:	7c18                	ld	a4,56(s0)
ffffffffc020978e:	603c                	ld	a5,64(s0)
ffffffffc0209790:	8526                	mv	a0,s1
ffffffffc0209792:	e71c                	sd	a5,8(a4)
ffffffffc0209794:	e398                	sd	a4,0(a5)
ffffffffc0209796:	6438                	ld	a4,72(s0)
ffffffffc0209798:	683c                	ld	a5,80(s0)
ffffffffc020979a:	e71c                	sd	a5,8(a4)
ffffffffc020979c:	e398                	sd	a4,0(a5)
ffffffffc020979e:	bd5ff0ef          	jal	ra,ffffffffc0209372 <unlock_sfs_fs>
ffffffffc02097a2:	6008                	ld	a0,0(s0)
ffffffffc02097a4:	00655783          	lhu	a5,6(a0)
ffffffffc02097a8:	cb85                	beqz	a5,ffffffffc02097d8 <sfs_reclaim+0xe4>
ffffffffc02097aa:	eb4f80ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc02097ae:	8522                	mv	a0,s0
ffffffffc02097b0:	b35fe0ef          	jal	ra,ffffffffc02082e4 <inode_kill>
ffffffffc02097b4:	60e2                	ld	ra,24(sp)
ffffffffc02097b6:	6442                	ld	s0,16(sp)
ffffffffc02097b8:	64a2                	ld	s1,8(sp)
ffffffffc02097ba:	854a                	mv	a0,s2
ffffffffc02097bc:	6902                	ld	s2,0(sp)
ffffffffc02097be:	6105                	addi	sp,sp,32
ffffffffc02097c0:	8082                	ret
ffffffffc02097c2:	5945                	li	s2,-15
ffffffffc02097c4:	8526                	mv	a0,s1
ffffffffc02097c6:	badff0ef          	jal	ra,ffffffffc0209372 <unlock_sfs_fs>
ffffffffc02097ca:	60e2                	ld	ra,24(sp)
ffffffffc02097cc:	6442                	ld	s0,16(sp)
ffffffffc02097ce:	64a2                	ld	s1,8(sp)
ffffffffc02097d0:	854a                	mv	a0,s2
ffffffffc02097d2:	6902                	ld	s2,0(sp)
ffffffffc02097d4:	6105                	addi	sp,sp,32
ffffffffc02097d6:	8082                	ret
ffffffffc02097d8:	440c                	lw	a1,8(s0)
ffffffffc02097da:	8526                	mv	a0,s1
ffffffffc02097dc:	ea7ff0ef          	jal	ra,ffffffffc0209682 <sfs_block_free>
ffffffffc02097e0:	6008                	ld	a0,0(s0)
ffffffffc02097e2:	5d4c                	lw	a1,60(a0)
ffffffffc02097e4:	d1f9                	beqz	a1,ffffffffc02097aa <sfs_reclaim+0xb6>
ffffffffc02097e6:	8526                	mv	a0,s1
ffffffffc02097e8:	e9bff0ef          	jal	ra,ffffffffc0209682 <sfs_block_free>
ffffffffc02097ec:	6008                	ld	a0,0(s0)
ffffffffc02097ee:	bf75                	j	ffffffffc02097aa <sfs_reclaim+0xb6>
ffffffffc02097f0:	892a                	mv	s2,a0
ffffffffc02097f2:	bfc9                	j	ffffffffc02097c4 <sfs_reclaim+0xd0>
ffffffffc02097f4:	00005697          	auipc	a3,0x5
ffffffffc02097f8:	6e468693          	addi	a3,a3,1764 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc02097fc:	00002617          	auipc	a2,0x2
ffffffffc0209800:	41c60613          	addi	a2,a2,1052 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209804:	38000593          	li	a1,896
ffffffffc0209808:	00005517          	auipc	a0,0x5
ffffffffc020980c:	6a050513          	addi	a0,a0,1696 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209810:	a1ff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209814:	00005697          	auipc	a3,0x5
ffffffffc0209818:	74c68693          	addi	a3,a3,1868 # ffffffffc020ef60 <dev_node_ops+0x240>
ffffffffc020981c:	00002617          	auipc	a2,0x2
ffffffffc0209820:	3fc60613          	addi	a2,a2,1020 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209824:	38600593          	li	a1,902
ffffffffc0209828:	00005517          	auipc	a0,0x5
ffffffffc020982c:	68050513          	addi	a0,a0,1664 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209830:	9fff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209834:	00005697          	auipc	a3,0x5
ffffffffc0209838:	63c68693          	addi	a3,a3,1596 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020983c:	00002617          	auipc	a2,0x2
ffffffffc0209840:	3dc60613          	addi	a2,a2,988 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209844:	38100593          	li	a1,897
ffffffffc0209848:	00005517          	auipc	a0,0x5
ffffffffc020984c:	66050513          	addi	a0,a0,1632 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209850:	9dff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209854:	00005697          	auipc	a3,0x5
ffffffffc0209858:	f8468693          	addi	a3,a3,-124 # ffffffffc020e7d8 <syscalls+0xb70>
ffffffffc020985c:	00002617          	auipc	a2,0x2
ffffffffc0209860:	3bc60613          	addi	a2,a2,956 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209864:	38b00593          	li	a1,907
ffffffffc0209868:	00005517          	auipc	a0,0x5
ffffffffc020986c:	64050513          	addi	a0,a0,1600 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209870:	9bff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209874:	00004697          	auipc	a3,0x4
ffffffffc0209878:	cbc68693          	addi	a3,a3,-836 # ffffffffc020d530 <default_pmm_manager+0xb08>
ffffffffc020987c:	00002617          	auipc	a2,0x2
ffffffffc0209880:	39c60613          	addi	a2,a2,924 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209884:	39000593          	li	a1,912
ffffffffc0209888:	00005517          	auipc	a0,0x5
ffffffffc020988c:	62050513          	addi	a0,a0,1568 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209890:	99ff60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209894 <sfs_block_alloc>:
ffffffffc0209894:	1101                	addi	sp,sp,-32
ffffffffc0209896:	e822                	sd	s0,16(sp)
ffffffffc0209898:	842a                	mv	s0,a0
ffffffffc020989a:	7d08                	ld	a0,56(a0)
ffffffffc020989c:	e426                	sd	s1,8(sp)
ffffffffc020989e:	ec06                	sd	ra,24(sp)
ffffffffc02098a0:	84ae                	mv	s1,a1
ffffffffc02098a2:	7c8010ef          	jal	ra,ffffffffc020b06a <bitmap_alloc>
ffffffffc02098a6:	e90d                	bnez	a0,ffffffffc02098d8 <sfs_block_alloc+0x44>
ffffffffc02098a8:	441c                	lw	a5,8(s0)
ffffffffc02098aa:	cbad                	beqz	a5,ffffffffc020991c <sfs_block_alloc+0x88>
ffffffffc02098ac:	37fd                	addiw	a5,a5,-1
ffffffffc02098ae:	c41c                	sw	a5,8(s0)
ffffffffc02098b0:	408c                	lw	a1,0(s1)
ffffffffc02098b2:	4785                	li	a5,1
ffffffffc02098b4:	e03c                	sd	a5,64(s0)
ffffffffc02098b6:	4054                	lw	a3,4(s0)
ffffffffc02098b8:	c58d                	beqz	a1,ffffffffc02098e2 <sfs_block_alloc+0x4e>
ffffffffc02098ba:	02d5f463          	bgeu	a1,a3,ffffffffc02098e2 <sfs_block_alloc+0x4e>
ffffffffc02098be:	7c08                	ld	a0,56(s0)
ffffffffc02098c0:	01b010ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc02098c4:	ed05                	bnez	a0,ffffffffc02098fc <sfs_block_alloc+0x68>
ffffffffc02098c6:	8522                	mv	a0,s0
ffffffffc02098c8:	6442                	ld	s0,16(sp)
ffffffffc02098ca:	408c                	lw	a1,0(s1)
ffffffffc02098cc:	60e2                	ld	ra,24(sp)
ffffffffc02098ce:	64a2                	ld	s1,8(sp)
ffffffffc02098d0:	4605                	li	a2,1
ffffffffc02098d2:	6105                	addi	sp,sp,32
ffffffffc02098d4:	a2fff06f          	j	ffffffffc0209302 <sfs_clear_block>
ffffffffc02098d8:	60e2                	ld	ra,24(sp)
ffffffffc02098da:	6442                	ld	s0,16(sp)
ffffffffc02098dc:	64a2                	ld	s1,8(sp)
ffffffffc02098de:	6105                	addi	sp,sp,32
ffffffffc02098e0:	8082                	ret
ffffffffc02098e2:	872e                	mv	a4,a1
ffffffffc02098e4:	00005617          	auipc	a2,0x5
ffffffffc02098e8:	62460613          	addi	a2,a2,1572 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc02098ec:	05300593          	li	a1,83
ffffffffc02098f0:	00005517          	auipc	a0,0x5
ffffffffc02098f4:	5b850513          	addi	a0,a0,1464 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02098f8:	937f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02098fc:	00005697          	auipc	a3,0x5
ffffffffc0209900:	69c68693          	addi	a3,a3,1692 # ffffffffc020ef98 <dev_node_ops+0x278>
ffffffffc0209904:	00002617          	auipc	a2,0x2
ffffffffc0209908:	31460613          	addi	a2,a2,788 # ffffffffc020bc18 <commands+0x250>
ffffffffc020990c:	06100593          	li	a1,97
ffffffffc0209910:	00005517          	auipc	a0,0x5
ffffffffc0209914:	59850513          	addi	a0,a0,1432 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209918:	917f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020991c:	00005697          	auipc	a3,0x5
ffffffffc0209920:	65c68693          	addi	a3,a3,1628 # ffffffffc020ef78 <dev_node_ops+0x258>
ffffffffc0209924:	00002617          	auipc	a2,0x2
ffffffffc0209928:	2f460613          	addi	a2,a2,756 # ffffffffc020bc18 <commands+0x250>
ffffffffc020992c:	05f00593          	li	a1,95
ffffffffc0209930:	00005517          	auipc	a0,0x5
ffffffffc0209934:	57850513          	addi	a0,a0,1400 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209938:	8f7f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020993c <sfs_bmap_load_nolock>:
ffffffffc020993c:	7159                	addi	sp,sp,-112
ffffffffc020993e:	f85a                	sd	s6,48(sp)
ffffffffc0209940:	0005bb03          	ld	s6,0(a1)
ffffffffc0209944:	f45e                	sd	s7,40(sp)
ffffffffc0209946:	f486                	sd	ra,104(sp)
ffffffffc0209948:	008b2b83          	lw	s7,8(s6)
ffffffffc020994c:	f0a2                	sd	s0,96(sp)
ffffffffc020994e:	eca6                	sd	s1,88(sp)
ffffffffc0209950:	e8ca                	sd	s2,80(sp)
ffffffffc0209952:	e4ce                	sd	s3,72(sp)
ffffffffc0209954:	e0d2                	sd	s4,64(sp)
ffffffffc0209956:	fc56                	sd	s5,56(sp)
ffffffffc0209958:	f062                	sd	s8,32(sp)
ffffffffc020995a:	ec66                	sd	s9,24(sp)
ffffffffc020995c:	18cbe363          	bltu	s7,a2,ffffffffc0209ae2 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209960:	47ad                	li	a5,11
ffffffffc0209962:	8aae                	mv	s5,a1
ffffffffc0209964:	8432                	mv	s0,a2
ffffffffc0209966:	84aa                	mv	s1,a0
ffffffffc0209968:	89b6                	mv	s3,a3
ffffffffc020996a:	04c7f563          	bgeu	a5,a2,ffffffffc02099b4 <sfs_bmap_load_nolock+0x78>
ffffffffc020996e:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209972:	0007069b          	sext.w	a3,a4
ffffffffc0209976:	3ff00793          	li	a5,1023
ffffffffc020997a:	1ad7e163          	bltu	a5,a3,ffffffffc0209b1c <sfs_bmap_load_nolock+0x1e0>
ffffffffc020997e:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209982:	02071793          	slli	a5,a4,0x20
ffffffffc0209986:	c602                	sw	zero,12(sp)
ffffffffc0209988:	c452                	sw	s4,8(sp)
ffffffffc020998a:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc020998e:	0e0a1e63          	bnez	s4,ffffffffc0209a8a <sfs_bmap_load_nolock+0x14e>
ffffffffc0209992:	0acb8663          	beq	s7,a2,ffffffffc0209a3e <sfs_bmap_load_nolock+0x102>
ffffffffc0209996:	4a01                	li	s4,0
ffffffffc0209998:	40d4                	lw	a3,4(s1)
ffffffffc020999a:	8752                	mv	a4,s4
ffffffffc020999c:	00005617          	auipc	a2,0x5
ffffffffc02099a0:	56c60613          	addi	a2,a2,1388 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc02099a4:	05300593          	li	a1,83
ffffffffc02099a8:	00005517          	auipc	a0,0x5
ffffffffc02099ac:	50050513          	addi	a0,a0,1280 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc02099b0:	87ff60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02099b4:	02061793          	slli	a5,a2,0x20
ffffffffc02099b8:	01e7da13          	srli	s4,a5,0x1e
ffffffffc02099bc:	9a5a                	add	s4,s4,s6
ffffffffc02099be:	00ca2583          	lw	a1,12(s4)
ffffffffc02099c2:	c22e                	sw	a1,4(sp)
ffffffffc02099c4:	ed99                	bnez	a1,ffffffffc02099e2 <sfs_bmap_load_nolock+0xa6>
ffffffffc02099c6:	fccb98e3          	bne	s7,a2,ffffffffc0209996 <sfs_bmap_load_nolock+0x5a>
ffffffffc02099ca:	004c                	addi	a1,sp,4
ffffffffc02099cc:	ec9ff0ef          	jal	ra,ffffffffc0209894 <sfs_block_alloc>
ffffffffc02099d0:	892a                	mv	s2,a0
ffffffffc02099d2:	e921                	bnez	a0,ffffffffc0209a22 <sfs_bmap_load_nolock+0xe6>
ffffffffc02099d4:	4592                	lw	a1,4(sp)
ffffffffc02099d6:	4705                	li	a4,1
ffffffffc02099d8:	00ba2623          	sw	a1,12(s4)
ffffffffc02099dc:	00eab823          	sd	a4,16(s5) # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc02099e0:	d9dd                	beqz	a1,ffffffffc0209996 <sfs_bmap_load_nolock+0x5a>
ffffffffc02099e2:	40d4                	lw	a3,4(s1)
ffffffffc02099e4:	10d5ff63          	bgeu	a1,a3,ffffffffc0209b02 <sfs_bmap_load_nolock+0x1c6>
ffffffffc02099e8:	7c88                	ld	a0,56(s1)
ffffffffc02099ea:	6f0010ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc02099ee:	18051363          	bnez	a0,ffffffffc0209b74 <sfs_bmap_load_nolock+0x238>
ffffffffc02099f2:	4a12                	lw	s4,4(sp)
ffffffffc02099f4:	fa0a02e3          	beqz	s4,ffffffffc0209998 <sfs_bmap_load_nolock+0x5c>
ffffffffc02099f8:	40dc                	lw	a5,4(s1)
ffffffffc02099fa:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209998 <sfs_bmap_load_nolock+0x5c>
ffffffffc02099fe:	7c88                	ld	a0,56(s1)
ffffffffc0209a00:	85d2                	mv	a1,s4
ffffffffc0209a02:	6d8010ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc0209a06:	12051763          	bnez	a0,ffffffffc0209b34 <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209a0a:	008b9763          	bne	s7,s0,ffffffffc0209a18 <sfs_bmap_load_nolock+0xdc>
ffffffffc0209a0e:	008b2783          	lw	a5,8(s6)
ffffffffc0209a12:	2785                	addiw	a5,a5,1
ffffffffc0209a14:	00fb2423          	sw	a5,8(s6)
ffffffffc0209a18:	4901                	li	s2,0
ffffffffc0209a1a:	00098463          	beqz	s3,ffffffffc0209a22 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209a1e:	0149a023          	sw	s4,0(s3)
ffffffffc0209a22:	70a6                	ld	ra,104(sp)
ffffffffc0209a24:	7406                	ld	s0,96(sp)
ffffffffc0209a26:	64e6                	ld	s1,88(sp)
ffffffffc0209a28:	69a6                	ld	s3,72(sp)
ffffffffc0209a2a:	6a06                	ld	s4,64(sp)
ffffffffc0209a2c:	7ae2                	ld	s5,56(sp)
ffffffffc0209a2e:	7b42                	ld	s6,48(sp)
ffffffffc0209a30:	7ba2                	ld	s7,40(sp)
ffffffffc0209a32:	7c02                	ld	s8,32(sp)
ffffffffc0209a34:	6ce2                	ld	s9,24(sp)
ffffffffc0209a36:	854a                	mv	a0,s2
ffffffffc0209a38:	6946                	ld	s2,80(sp)
ffffffffc0209a3a:	6165                	addi	sp,sp,112
ffffffffc0209a3c:	8082                	ret
ffffffffc0209a3e:	002c                	addi	a1,sp,8
ffffffffc0209a40:	e55ff0ef          	jal	ra,ffffffffc0209894 <sfs_block_alloc>
ffffffffc0209a44:	892a                	mv	s2,a0
ffffffffc0209a46:	00c10c93          	addi	s9,sp,12
ffffffffc0209a4a:	fd61                	bnez	a0,ffffffffc0209a22 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209a4c:	85e6                	mv	a1,s9
ffffffffc0209a4e:	8526                	mv	a0,s1
ffffffffc0209a50:	e45ff0ef          	jal	ra,ffffffffc0209894 <sfs_block_alloc>
ffffffffc0209a54:	892a                	mv	s2,a0
ffffffffc0209a56:	e925                	bnez	a0,ffffffffc0209ac6 <sfs_bmap_load_nolock+0x18a>
ffffffffc0209a58:	46a2                	lw	a3,8(sp)
ffffffffc0209a5a:	85e6                	mv	a1,s9
ffffffffc0209a5c:	8762                	mv	a4,s8
ffffffffc0209a5e:	4611                	li	a2,4
ffffffffc0209a60:	8526                	mv	a0,s1
ffffffffc0209a62:	f50ff0ef          	jal	ra,ffffffffc02091b2 <sfs_wbuf>
ffffffffc0209a66:	45b2                	lw	a1,12(sp)
ffffffffc0209a68:	892a                	mv	s2,a0
ffffffffc0209a6a:	e939                	bnez	a0,ffffffffc0209ac0 <sfs_bmap_load_nolock+0x184>
ffffffffc0209a6c:	03cb2683          	lw	a3,60(s6)
ffffffffc0209a70:	4722                	lw	a4,8(sp)
ffffffffc0209a72:	c22e                	sw	a1,4(sp)
ffffffffc0209a74:	f6d706e3          	beq	a4,a3,ffffffffc02099e0 <sfs_bmap_load_nolock+0xa4>
ffffffffc0209a78:	eef1                	bnez	a3,ffffffffc0209b54 <sfs_bmap_load_nolock+0x218>
ffffffffc0209a7a:	02eb2e23          	sw	a4,60(s6)
ffffffffc0209a7e:	4705                	li	a4,1
ffffffffc0209a80:	00eab823          	sd	a4,16(s5)
ffffffffc0209a84:	f00589e3          	beqz	a1,ffffffffc0209996 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209a88:	bfa9                	j	ffffffffc02099e2 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209a8a:	00c10c93          	addi	s9,sp,12
ffffffffc0209a8e:	8762                	mv	a4,s8
ffffffffc0209a90:	86d2                	mv	a3,s4
ffffffffc0209a92:	4611                	li	a2,4
ffffffffc0209a94:	85e6                	mv	a1,s9
ffffffffc0209a96:	e9cff0ef          	jal	ra,ffffffffc0209132 <sfs_rbuf>
ffffffffc0209a9a:	892a                	mv	s2,a0
ffffffffc0209a9c:	f159                	bnez	a0,ffffffffc0209a22 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209a9e:	45b2                	lw	a1,12(sp)
ffffffffc0209aa0:	e995                	bnez	a1,ffffffffc0209ad4 <sfs_bmap_load_nolock+0x198>
ffffffffc0209aa2:	fa8b85e3          	beq	s7,s0,ffffffffc0209a4c <sfs_bmap_load_nolock+0x110>
ffffffffc0209aa6:	03cb2703          	lw	a4,60(s6)
ffffffffc0209aaa:	47a2                	lw	a5,8(sp)
ffffffffc0209aac:	c202                	sw	zero,4(sp)
ffffffffc0209aae:	eee784e3          	beq	a5,a4,ffffffffc0209996 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209ab2:	e34d                	bnez	a4,ffffffffc0209b54 <sfs_bmap_load_nolock+0x218>
ffffffffc0209ab4:	02fb2e23          	sw	a5,60(s6)
ffffffffc0209ab8:	4785                	li	a5,1
ffffffffc0209aba:	00fab823          	sd	a5,16(s5)
ffffffffc0209abe:	bde1                	j	ffffffffc0209996 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209ac0:	8526                	mv	a0,s1
ffffffffc0209ac2:	bc1ff0ef          	jal	ra,ffffffffc0209682 <sfs_block_free>
ffffffffc0209ac6:	45a2                	lw	a1,8(sp)
ffffffffc0209ac8:	f4ba0de3          	beq	s4,a1,ffffffffc0209a22 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209acc:	8526                	mv	a0,s1
ffffffffc0209ace:	bb5ff0ef          	jal	ra,ffffffffc0209682 <sfs_block_free>
ffffffffc0209ad2:	bf81                	j	ffffffffc0209a22 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209ad4:	03cb2683          	lw	a3,60(s6)
ffffffffc0209ad8:	4722                	lw	a4,8(sp)
ffffffffc0209ada:	c22e                	sw	a1,4(sp)
ffffffffc0209adc:	f8e69ee3          	bne	a3,a4,ffffffffc0209a78 <sfs_bmap_load_nolock+0x13c>
ffffffffc0209ae0:	b709                	j	ffffffffc02099e2 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209ae2:	00005697          	auipc	a3,0x5
ffffffffc0209ae6:	4de68693          	addi	a3,a3,1246 # ffffffffc020efc0 <dev_node_ops+0x2a0>
ffffffffc0209aea:	00002617          	auipc	a2,0x2
ffffffffc0209aee:	12e60613          	addi	a2,a2,302 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209af2:	16400593          	li	a1,356
ffffffffc0209af6:	00005517          	auipc	a0,0x5
ffffffffc0209afa:	3b250513          	addi	a0,a0,946 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209afe:	f30f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b02:	872e                	mv	a4,a1
ffffffffc0209b04:	00005617          	auipc	a2,0x5
ffffffffc0209b08:	40460613          	addi	a2,a2,1028 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc0209b0c:	05300593          	li	a1,83
ffffffffc0209b10:	00005517          	auipc	a0,0x5
ffffffffc0209b14:	39850513          	addi	a0,a0,920 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209b18:	f16f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b1c:	00005617          	auipc	a2,0x5
ffffffffc0209b20:	4d460613          	addi	a2,a2,1236 # ffffffffc020eff0 <dev_node_ops+0x2d0>
ffffffffc0209b24:	11e00593          	li	a1,286
ffffffffc0209b28:	00005517          	auipc	a0,0x5
ffffffffc0209b2c:	38050513          	addi	a0,a0,896 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209b30:	efef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b34:	00005697          	auipc	a3,0x5
ffffffffc0209b38:	40c68693          	addi	a3,a3,1036 # ffffffffc020ef40 <dev_node_ops+0x220>
ffffffffc0209b3c:	00002617          	auipc	a2,0x2
ffffffffc0209b40:	0dc60613          	addi	a2,a2,220 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209b44:	16b00593          	li	a1,363
ffffffffc0209b48:	00005517          	auipc	a0,0x5
ffffffffc0209b4c:	36050513          	addi	a0,a0,864 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209b50:	edef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b54:	00005697          	auipc	a3,0x5
ffffffffc0209b58:	48468693          	addi	a3,a3,1156 # ffffffffc020efd8 <dev_node_ops+0x2b8>
ffffffffc0209b5c:	00002617          	auipc	a2,0x2
ffffffffc0209b60:	0bc60613          	addi	a2,a2,188 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209b64:	11800593          	li	a1,280
ffffffffc0209b68:	00005517          	auipc	a0,0x5
ffffffffc0209b6c:	34050513          	addi	a0,a0,832 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209b70:	ebef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209b74:	00005697          	auipc	a3,0x5
ffffffffc0209b78:	4ac68693          	addi	a3,a3,1196 # ffffffffc020f020 <dev_node_ops+0x300>
ffffffffc0209b7c:	00002617          	auipc	a2,0x2
ffffffffc0209b80:	09c60613          	addi	a2,a2,156 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209b84:	12100593          	li	a1,289
ffffffffc0209b88:	00005517          	auipc	a0,0x5
ffffffffc0209b8c:	32050513          	addi	a0,a0,800 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209b90:	e9ef60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209b94 <sfs_io_nolock>:
ffffffffc0209b94:	7175                	addi	sp,sp,-144
ffffffffc0209b96:	f8ca                	sd	s2,112(sp)
ffffffffc0209b98:	892e                	mv	s2,a1
ffffffffc0209b9a:	618c                	ld	a1,0(a1)
ffffffffc0209b9c:	e506                	sd	ra,136(sp)
ffffffffc0209b9e:	e122                	sd	s0,128(sp)
ffffffffc0209ba0:	0045d883          	lhu	a7,4(a1)
ffffffffc0209ba4:	fca6                	sd	s1,120(sp)
ffffffffc0209ba6:	f4ce                	sd	s3,104(sp)
ffffffffc0209ba8:	f0d2                	sd	s4,96(sp)
ffffffffc0209baa:	ecd6                	sd	s5,88(sp)
ffffffffc0209bac:	e8da                	sd	s6,80(sp)
ffffffffc0209bae:	e4de                	sd	s7,72(sp)
ffffffffc0209bb0:	e0e2                	sd	s8,64(sp)
ffffffffc0209bb2:	fc66                	sd	s9,56(sp)
ffffffffc0209bb4:	f86a                	sd	s10,48(sp)
ffffffffc0209bb6:	f46e                	sd	s11,40(sp)
ffffffffc0209bb8:	4809                	li	a6,2
ffffffffc0209bba:	19088063          	beq	a7,a6,ffffffffc0209d3a <sfs_io_nolock+0x1a6>
ffffffffc0209bbe:	6304                	ld	s1,0(a4)
ffffffffc0209bc0:	8c3a                	mv	s8,a4
ffffffffc0209bc2:	000c3023          	sd	zero,0(s8)
ffffffffc0209bc6:	08000737          	lui	a4,0x8000
ffffffffc0209bca:	8436                	mv	s0,a3
ffffffffc0209bcc:	88b6                	mv	a7,a3
ffffffffc0209bce:	94b6                	add	s1,s1,a3
ffffffffc0209bd0:	16e6f363          	bgeu	a3,a4,ffffffffc0209d36 <sfs_io_nolock+0x1a2>
ffffffffc0209bd4:	16d4c163          	blt	s1,a3,ffffffffc0209d36 <sfs_io_nolock+0x1a2>
ffffffffc0209bd8:	8caa                	mv	s9,a0
ffffffffc0209bda:	4501                	li	a0,0
ffffffffc0209bdc:	0a968c63          	beq	a3,s1,ffffffffc0209c94 <sfs_io_nolock+0x100>
ffffffffc0209be0:	89b2                	mv	s3,a2
ffffffffc0209be2:	00977463          	bgeu	a4,s1,ffffffffc0209bea <sfs_io_nolock+0x56>
ffffffffc0209be6:	080004b7          	lui	s1,0x8000
ffffffffc0209bea:	c7e1                	beqz	a5,ffffffffc0209cb2 <sfs_io_nolock+0x11e>
ffffffffc0209bec:	fffff797          	auipc	a5,0xfffff
ffffffffc0209bf0:	5c678793          	addi	a5,a5,1478 # ffffffffc02091b2 <sfs_wbuf>
ffffffffc0209bf4:	fffffb97          	auipc	s7,0xfffff
ffffffffc0209bf8:	4deb8b93          	addi	s7,s7,1246 # ffffffffc02090d2 <sfs_wblock>
ffffffffc0209bfc:	e03e                	sd	a5,0(sp)
ffffffffc0209bfe:	6785                	lui	a5,0x1
ffffffffc0209c00:	40c45a93          	srai	s5,s0,0xc
ffffffffc0209c04:	40c4dd13          	srai	s10,s1,0xc
ffffffffc0209c08:	fff78d93          	addi	s11,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209c0c:	415d0b3b          	subw	s6,s10,s5
ffffffffc0209c10:	01b47db3          	and	s11,s0,s11
ffffffffc0209c14:	8d5a                	mv	s10,s6
ffffffffc0209c16:	2a81                	sext.w	s5,s5
ffffffffc0209c18:	8a6e                	mv	s4,s11
ffffffffc0209c1a:	020d8e63          	beqz	s11,ffffffffc0209c56 <sfs_io_nolock+0xc2>
ffffffffc0209c1e:	40848a33          	sub	s4,s1,s0
ffffffffc0209c22:	0c0b1963          	bnez	s6,ffffffffc0209cf4 <sfs_io_nolock+0x160>
ffffffffc0209c26:	0874                	addi	a3,sp,28
ffffffffc0209c28:	8656                	mv	a2,s5
ffffffffc0209c2a:	85ca                	mv	a1,s2
ffffffffc0209c2c:	8566                	mv	a0,s9
ffffffffc0209c2e:	e446                	sd	a7,8(sp)
ffffffffc0209c30:	d0dff0ef          	jal	ra,ffffffffc020993c <sfs_bmap_load_nolock>
ffffffffc0209c34:	68a2                	ld	a7,8(sp)
ffffffffc0209c36:	ed69                	bnez	a0,ffffffffc0209d10 <sfs_io_nolock+0x17c>
ffffffffc0209c38:	46f2                	lw	a3,28(sp)
ffffffffc0209c3a:	6782                	ld	a5,0(sp)
ffffffffc0209c3c:	876e                	mv	a4,s11
ffffffffc0209c3e:	8652                	mv	a2,s4
ffffffffc0209c40:	85ce                	mv	a1,s3
ffffffffc0209c42:	8566                	mv	a0,s9
ffffffffc0209c44:	9782                	jalr	a5
ffffffffc0209c46:	68a2                	ld	a7,8(sp)
ffffffffc0209c48:	e561                	bnez	a0,ffffffffc0209d10 <sfs_io_nolock+0x17c>
ffffffffc0209c4a:	020b0563          	beqz	s6,ffffffffc0209c74 <sfs_io_nolock+0xe0>
ffffffffc0209c4e:	99d2                	add	s3,s3,s4
ffffffffc0209c50:	2a85                	addiw	s5,s5,1
ffffffffc0209c52:	fffd0b1b          	addiw	s6,s10,-1
ffffffffc0209c56:	080b0763          	beqz	s6,ffffffffc0209ce4 <sfs_io_nolock+0x150>
ffffffffc0209c5a:	0874                	addi	a3,sp,28
ffffffffc0209c5c:	8656                	mv	a2,s5
ffffffffc0209c5e:	85ca                	mv	a1,s2
ffffffffc0209c60:	8566                	mv	a0,s9
ffffffffc0209c62:	cdbff0ef          	jal	ra,ffffffffc020993c <sfs_bmap_load_nolock>
ffffffffc0209c66:	e519                	bnez	a0,ffffffffc0209c74 <sfs_io_nolock+0xe0>
ffffffffc0209c68:	4672                	lw	a2,28(sp)
ffffffffc0209c6a:	86da                	mv	a3,s6
ffffffffc0209c6c:	85ce                	mv	a1,s3
ffffffffc0209c6e:	8566                	mv	a0,s9
ffffffffc0209c70:	9b82                	jalr	s7
ffffffffc0209c72:	c12d                	beqz	a0,ffffffffc0209cd4 <sfs_io_nolock+0x140>
ffffffffc0209c74:	014408b3          	add	a7,s0,s4
ffffffffc0209c78:	00093783          	ld	a5,0(s2)
ffffffffc0209c7c:	014c3023          	sd	s4,0(s8)
ffffffffc0209c80:	0007e703          	lwu	a4,0(a5)
ffffffffc0209c84:	01177863          	bgeu	a4,a7,ffffffffc0209c94 <sfs_io_nolock+0x100>
ffffffffc0209c88:	0144043b          	addw	s0,s0,s4
ffffffffc0209c8c:	c380                	sw	s0,0(a5)
ffffffffc0209c8e:	4785                	li	a5,1
ffffffffc0209c90:	00f93823          	sd	a5,16(s2)
ffffffffc0209c94:	60aa                	ld	ra,136(sp)
ffffffffc0209c96:	640a                	ld	s0,128(sp)
ffffffffc0209c98:	74e6                	ld	s1,120(sp)
ffffffffc0209c9a:	7946                	ld	s2,112(sp)
ffffffffc0209c9c:	79a6                	ld	s3,104(sp)
ffffffffc0209c9e:	7a06                	ld	s4,96(sp)
ffffffffc0209ca0:	6ae6                	ld	s5,88(sp)
ffffffffc0209ca2:	6b46                	ld	s6,80(sp)
ffffffffc0209ca4:	6ba6                	ld	s7,72(sp)
ffffffffc0209ca6:	6c06                	ld	s8,64(sp)
ffffffffc0209ca8:	7ce2                	ld	s9,56(sp)
ffffffffc0209caa:	7d42                	ld	s10,48(sp)
ffffffffc0209cac:	7da2                	ld	s11,40(sp)
ffffffffc0209cae:	6149                	addi	sp,sp,144
ffffffffc0209cb0:	8082                	ret
ffffffffc0209cb2:	0005e783          	lwu	a5,0(a1)
ffffffffc0209cb6:	4501                	li	a0,0
ffffffffc0209cb8:	fcf45ee3          	bge	s0,a5,ffffffffc0209c94 <sfs_io_nolock+0x100>
ffffffffc0209cbc:	0297cf63          	blt	a5,s1,ffffffffc0209cfa <sfs_io_nolock+0x166>
ffffffffc0209cc0:	fffff797          	auipc	a5,0xfffff
ffffffffc0209cc4:	47278793          	addi	a5,a5,1138 # ffffffffc0209132 <sfs_rbuf>
ffffffffc0209cc8:	fffffb97          	auipc	s7,0xfffff
ffffffffc0209ccc:	3aab8b93          	addi	s7,s7,938 # ffffffffc0209072 <sfs_rblock>
ffffffffc0209cd0:	e03e                	sd	a5,0(sp)
ffffffffc0209cd2:	b735                	j	ffffffffc0209bfe <sfs_io_nolock+0x6a>
ffffffffc0209cd4:	00cb179b          	slliw	a5,s6,0xc
ffffffffc0209cd8:	1782                	slli	a5,a5,0x20
ffffffffc0209cda:	9381                	srli	a5,a5,0x20
ffffffffc0209cdc:	9a3e                	add	s4,s4,a5
ffffffffc0209cde:	99be                	add	s3,s3,a5
ffffffffc0209ce0:	016a8abb          	addw	s5,s5,s6
ffffffffc0209ce4:	14d2                	slli	s1,s1,0x34
ffffffffc0209ce6:	0344db13          	srli	s6,s1,0x34
ffffffffc0209cea:	e48d                	bnez	s1,ffffffffc0209d14 <sfs_io_nolock+0x180>
ffffffffc0209cec:	014408b3          	add	a7,s0,s4
ffffffffc0209cf0:	4501                	li	a0,0
ffffffffc0209cf2:	b759                	j	ffffffffc0209c78 <sfs_io_nolock+0xe4>
ffffffffc0209cf4:	41b78a33          	sub	s4,a5,s11
ffffffffc0209cf8:	b73d                	j	ffffffffc0209c26 <sfs_io_nolock+0x92>
ffffffffc0209cfa:	84be                	mv	s1,a5
ffffffffc0209cfc:	fffff797          	auipc	a5,0xfffff
ffffffffc0209d00:	43678793          	addi	a5,a5,1078 # ffffffffc0209132 <sfs_rbuf>
ffffffffc0209d04:	fffffb97          	auipc	s7,0xfffff
ffffffffc0209d08:	36eb8b93          	addi	s7,s7,878 # ffffffffc0209072 <sfs_rblock>
ffffffffc0209d0c:	e03e                	sd	a5,0(sp)
ffffffffc0209d0e:	bdc5                	j	ffffffffc0209bfe <sfs_io_nolock+0x6a>
ffffffffc0209d10:	4a01                	li	s4,0
ffffffffc0209d12:	b79d                	j	ffffffffc0209c78 <sfs_io_nolock+0xe4>
ffffffffc0209d14:	0874                	addi	a3,sp,28
ffffffffc0209d16:	8656                	mv	a2,s5
ffffffffc0209d18:	85ca                	mv	a1,s2
ffffffffc0209d1a:	8566                	mv	a0,s9
ffffffffc0209d1c:	c21ff0ef          	jal	ra,ffffffffc020993c <sfs_bmap_load_nolock>
ffffffffc0209d20:	f931                	bnez	a0,ffffffffc0209c74 <sfs_io_nolock+0xe0>
ffffffffc0209d22:	46f2                	lw	a3,28(sp)
ffffffffc0209d24:	6782                	ld	a5,0(sp)
ffffffffc0209d26:	4701                	li	a4,0
ffffffffc0209d28:	865a                	mv	a2,s6
ffffffffc0209d2a:	85ce                	mv	a1,s3
ffffffffc0209d2c:	8566                	mv	a0,s9
ffffffffc0209d2e:	9782                	jalr	a5
ffffffffc0209d30:	f131                	bnez	a0,ffffffffc0209c74 <sfs_io_nolock+0xe0>
ffffffffc0209d32:	9a5a                	add	s4,s4,s6
ffffffffc0209d34:	b781                	j	ffffffffc0209c74 <sfs_io_nolock+0xe0>
ffffffffc0209d36:	5575                	li	a0,-3
ffffffffc0209d38:	bfb1                	j	ffffffffc0209c94 <sfs_io_nolock+0x100>
ffffffffc0209d3a:	00005697          	auipc	a3,0x5
ffffffffc0209d3e:	30e68693          	addi	a3,a3,782 # ffffffffc020f048 <dev_node_ops+0x328>
ffffffffc0209d42:	00002617          	auipc	a2,0x2
ffffffffc0209d46:	ed660613          	addi	a2,a2,-298 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209d4a:	22b00593          	li	a1,555
ffffffffc0209d4e:	00005517          	auipc	a0,0x5
ffffffffc0209d52:	15a50513          	addi	a0,a0,346 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209d56:	cd8f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209d5a <sfs_read>:
ffffffffc0209d5a:	7139                	addi	sp,sp,-64
ffffffffc0209d5c:	f04a                	sd	s2,32(sp)
ffffffffc0209d5e:	06853903          	ld	s2,104(a0)
ffffffffc0209d62:	fc06                	sd	ra,56(sp)
ffffffffc0209d64:	f822                	sd	s0,48(sp)
ffffffffc0209d66:	f426                	sd	s1,40(sp)
ffffffffc0209d68:	ec4e                	sd	s3,24(sp)
ffffffffc0209d6a:	04090f63          	beqz	s2,ffffffffc0209dc8 <sfs_read+0x6e>
ffffffffc0209d6e:	0b092783          	lw	a5,176(s2)
ffffffffc0209d72:	ebb9                	bnez	a5,ffffffffc0209dc8 <sfs_read+0x6e>
ffffffffc0209d74:	4d38                	lw	a4,88(a0)
ffffffffc0209d76:	6785                	lui	a5,0x1
ffffffffc0209d78:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209d7c:	842a                	mv	s0,a0
ffffffffc0209d7e:	06f71563          	bne	a4,a5,ffffffffc0209de8 <sfs_read+0x8e>
ffffffffc0209d82:	02050993          	addi	s3,a0,32
ffffffffc0209d86:	854e                	mv	a0,s3
ffffffffc0209d88:	84ae                	mv	s1,a1
ffffffffc0209d8a:	a59fa0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0209d8e:	0184b803          	ld	a6,24(s1) # 8000018 <_binary_bin_sfs_img_size+0x7f8ad18>
ffffffffc0209d92:	6494                	ld	a3,8(s1)
ffffffffc0209d94:	6090                	ld	a2,0(s1)
ffffffffc0209d96:	85a2                	mv	a1,s0
ffffffffc0209d98:	4781                	li	a5,0
ffffffffc0209d9a:	0038                	addi	a4,sp,8
ffffffffc0209d9c:	854a                	mv	a0,s2
ffffffffc0209d9e:	e442                	sd	a6,8(sp)
ffffffffc0209da0:	df5ff0ef          	jal	ra,ffffffffc0209b94 <sfs_io_nolock>
ffffffffc0209da4:	65a2                	ld	a1,8(sp)
ffffffffc0209da6:	842a                	mv	s0,a0
ffffffffc0209da8:	ed81                	bnez	a1,ffffffffc0209dc0 <sfs_read+0x66>
ffffffffc0209daa:	854e                	mv	a0,s3
ffffffffc0209dac:	a33fa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0209db0:	70e2                	ld	ra,56(sp)
ffffffffc0209db2:	8522                	mv	a0,s0
ffffffffc0209db4:	7442                	ld	s0,48(sp)
ffffffffc0209db6:	74a2                	ld	s1,40(sp)
ffffffffc0209db8:	7902                	ld	s2,32(sp)
ffffffffc0209dba:	69e2                	ld	s3,24(sp)
ffffffffc0209dbc:	6121                	addi	sp,sp,64
ffffffffc0209dbe:	8082                	ret
ffffffffc0209dc0:	8526                	mv	a0,s1
ffffffffc0209dc2:	a79fb0ef          	jal	ra,ffffffffc020583a <iobuf_skip>
ffffffffc0209dc6:	b7d5                	j	ffffffffc0209daa <sfs_read+0x50>
ffffffffc0209dc8:	00005697          	auipc	a3,0x5
ffffffffc0209dcc:	11068693          	addi	a3,a3,272 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc0209dd0:	00002617          	auipc	a2,0x2
ffffffffc0209dd4:	e4860613          	addi	a2,a2,-440 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209dd8:	29d00593          	li	a1,669
ffffffffc0209ddc:	00005517          	auipc	a0,0x5
ffffffffc0209de0:	0cc50513          	addi	a0,a0,204 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209de4:	c4af60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209de8:	877ff0ef          	jal	ra,ffffffffc020965e <sfs_io.part.0>

ffffffffc0209dec <sfs_write>:
ffffffffc0209dec:	7139                	addi	sp,sp,-64
ffffffffc0209dee:	f04a                	sd	s2,32(sp)
ffffffffc0209df0:	06853903          	ld	s2,104(a0)
ffffffffc0209df4:	fc06                	sd	ra,56(sp)
ffffffffc0209df6:	f822                	sd	s0,48(sp)
ffffffffc0209df8:	f426                	sd	s1,40(sp)
ffffffffc0209dfa:	ec4e                	sd	s3,24(sp)
ffffffffc0209dfc:	04090f63          	beqz	s2,ffffffffc0209e5a <sfs_write+0x6e>
ffffffffc0209e00:	0b092783          	lw	a5,176(s2)
ffffffffc0209e04:	ebb9                	bnez	a5,ffffffffc0209e5a <sfs_write+0x6e>
ffffffffc0209e06:	4d38                	lw	a4,88(a0)
ffffffffc0209e08:	6785                	lui	a5,0x1
ffffffffc0209e0a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209e0e:	842a                	mv	s0,a0
ffffffffc0209e10:	06f71563          	bne	a4,a5,ffffffffc0209e7a <sfs_write+0x8e>
ffffffffc0209e14:	02050993          	addi	s3,a0,32
ffffffffc0209e18:	854e                	mv	a0,s3
ffffffffc0209e1a:	84ae                	mv	s1,a1
ffffffffc0209e1c:	9c7fa0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0209e20:	0184b803          	ld	a6,24(s1)
ffffffffc0209e24:	6494                	ld	a3,8(s1)
ffffffffc0209e26:	6090                	ld	a2,0(s1)
ffffffffc0209e28:	85a2                	mv	a1,s0
ffffffffc0209e2a:	4785                	li	a5,1
ffffffffc0209e2c:	0038                	addi	a4,sp,8
ffffffffc0209e2e:	854a                	mv	a0,s2
ffffffffc0209e30:	e442                	sd	a6,8(sp)
ffffffffc0209e32:	d63ff0ef          	jal	ra,ffffffffc0209b94 <sfs_io_nolock>
ffffffffc0209e36:	65a2                	ld	a1,8(sp)
ffffffffc0209e38:	842a                	mv	s0,a0
ffffffffc0209e3a:	ed81                	bnez	a1,ffffffffc0209e52 <sfs_write+0x66>
ffffffffc0209e3c:	854e                	mv	a0,s3
ffffffffc0209e3e:	9a1fa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0209e42:	70e2                	ld	ra,56(sp)
ffffffffc0209e44:	8522                	mv	a0,s0
ffffffffc0209e46:	7442                	ld	s0,48(sp)
ffffffffc0209e48:	74a2                	ld	s1,40(sp)
ffffffffc0209e4a:	7902                	ld	s2,32(sp)
ffffffffc0209e4c:	69e2                	ld	s3,24(sp)
ffffffffc0209e4e:	6121                	addi	sp,sp,64
ffffffffc0209e50:	8082                	ret
ffffffffc0209e52:	8526                	mv	a0,s1
ffffffffc0209e54:	9e7fb0ef          	jal	ra,ffffffffc020583a <iobuf_skip>
ffffffffc0209e58:	b7d5                	j	ffffffffc0209e3c <sfs_write+0x50>
ffffffffc0209e5a:	00005697          	auipc	a3,0x5
ffffffffc0209e5e:	07e68693          	addi	a3,a3,126 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc0209e62:	00002617          	auipc	a2,0x2
ffffffffc0209e66:	db660613          	addi	a2,a2,-586 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209e6a:	29d00593          	li	a1,669
ffffffffc0209e6e:	00005517          	auipc	a0,0x5
ffffffffc0209e72:	03a50513          	addi	a0,a0,58 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209e76:	bb8f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e7a:	fe4ff0ef          	jal	ra,ffffffffc020965e <sfs_io.part.0>

ffffffffc0209e7e <sfs_dirent_read_nolock>:
ffffffffc0209e7e:	6198                	ld	a4,0(a1)
ffffffffc0209e80:	7179                	addi	sp,sp,-48
ffffffffc0209e82:	f406                	sd	ra,40(sp)
ffffffffc0209e84:	00475883          	lhu	a7,4(a4) # 8000004 <_binary_bin_sfs_img_size+0x7f8ad04>
ffffffffc0209e88:	f022                	sd	s0,32(sp)
ffffffffc0209e8a:	ec26                	sd	s1,24(sp)
ffffffffc0209e8c:	4809                	li	a6,2
ffffffffc0209e8e:	05089b63          	bne	a7,a6,ffffffffc0209ee4 <sfs_dirent_read_nolock+0x66>
ffffffffc0209e92:	4718                	lw	a4,8(a4)
ffffffffc0209e94:	87b2                	mv	a5,a2
ffffffffc0209e96:	2601                	sext.w	a2,a2
ffffffffc0209e98:	04e7f663          	bgeu	a5,a4,ffffffffc0209ee4 <sfs_dirent_read_nolock+0x66>
ffffffffc0209e9c:	84b6                	mv	s1,a3
ffffffffc0209e9e:	0074                	addi	a3,sp,12
ffffffffc0209ea0:	842a                	mv	s0,a0
ffffffffc0209ea2:	a9bff0ef          	jal	ra,ffffffffc020993c <sfs_bmap_load_nolock>
ffffffffc0209ea6:	c511                	beqz	a0,ffffffffc0209eb2 <sfs_dirent_read_nolock+0x34>
ffffffffc0209ea8:	70a2                	ld	ra,40(sp)
ffffffffc0209eaa:	7402                	ld	s0,32(sp)
ffffffffc0209eac:	64e2                	ld	s1,24(sp)
ffffffffc0209eae:	6145                	addi	sp,sp,48
ffffffffc0209eb0:	8082                	ret
ffffffffc0209eb2:	45b2                	lw	a1,12(sp)
ffffffffc0209eb4:	4054                	lw	a3,4(s0)
ffffffffc0209eb6:	c5b9                	beqz	a1,ffffffffc0209f04 <sfs_dirent_read_nolock+0x86>
ffffffffc0209eb8:	04d5f663          	bgeu	a1,a3,ffffffffc0209f04 <sfs_dirent_read_nolock+0x86>
ffffffffc0209ebc:	7c08                	ld	a0,56(s0)
ffffffffc0209ebe:	21c010ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc0209ec2:	ed31                	bnez	a0,ffffffffc0209f1e <sfs_dirent_read_nolock+0xa0>
ffffffffc0209ec4:	46b2                	lw	a3,12(sp)
ffffffffc0209ec6:	4701                	li	a4,0
ffffffffc0209ec8:	10400613          	li	a2,260
ffffffffc0209ecc:	85a6                	mv	a1,s1
ffffffffc0209ece:	8522                	mv	a0,s0
ffffffffc0209ed0:	a62ff0ef          	jal	ra,ffffffffc0209132 <sfs_rbuf>
ffffffffc0209ed4:	f971                	bnez	a0,ffffffffc0209ea8 <sfs_dirent_read_nolock+0x2a>
ffffffffc0209ed6:	100481a3          	sb	zero,259(s1)
ffffffffc0209eda:	70a2                	ld	ra,40(sp)
ffffffffc0209edc:	7402                	ld	s0,32(sp)
ffffffffc0209ede:	64e2                	ld	s1,24(sp)
ffffffffc0209ee0:	6145                	addi	sp,sp,48
ffffffffc0209ee2:	8082                	ret
ffffffffc0209ee4:	00005697          	auipc	a3,0x5
ffffffffc0209ee8:	18468693          	addi	a3,a3,388 # ffffffffc020f068 <dev_node_ops+0x348>
ffffffffc0209eec:	00002617          	auipc	a2,0x2
ffffffffc0209ef0:	d2c60613          	addi	a2,a2,-724 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209ef4:	18e00593          	li	a1,398
ffffffffc0209ef8:	00005517          	auipc	a0,0x5
ffffffffc0209efc:	fb050513          	addi	a0,a0,-80 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209f00:	b2ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209f04:	872e                	mv	a4,a1
ffffffffc0209f06:	00005617          	auipc	a2,0x5
ffffffffc0209f0a:	00260613          	addi	a2,a2,2 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc0209f0e:	05300593          	li	a1,83
ffffffffc0209f12:	00005517          	auipc	a0,0x5
ffffffffc0209f16:	f9650513          	addi	a0,a0,-106 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209f1a:	b14f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209f1e:	00005697          	auipc	a3,0x5
ffffffffc0209f22:	02268693          	addi	a3,a3,34 # ffffffffc020ef40 <dev_node_ops+0x220>
ffffffffc0209f26:	00002617          	auipc	a2,0x2
ffffffffc0209f2a:	cf260613          	addi	a2,a2,-782 # ffffffffc020bc18 <commands+0x250>
ffffffffc0209f2e:	19500593          	li	a1,405
ffffffffc0209f32:	00005517          	auipc	a0,0x5
ffffffffc0209f36:	f7650513          	addi	a0,a0,-138 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc0209f3a:	af4f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209f3e <sfs_getdirentry>:
ffffffffc0209f3e:	715d                	addi	sp,sp,-80
ffffffffc0209f40:	ec56                	sd	s5,24(sp)
ffffffffc0209f42:	8aaa                	mv	s5,a0
ffffffffc0209f44:	10400513          	li	a0,260
ffffffffc0209f48:	e85a                	sd	s6,16(sp)
ffffffffc0209f4a:	e486                	sd	ra,72(sp)
ffffffffc0209f4c:	e0a2                	sd	s0,64(sp)
ffffffffc0209f4e:	fc26                	sd	s1,56(sp)
ffffffffc0209f50:	f84a                	sd	s2,48(sp)
ffffffffc0209f52:	f44e                	sd	s3,40(sp)
ffffffffc0209f54:	f052                	sd	s4,32(sp)
ffffffffc0209f56:	e45e                	sd	s7,8(sp)
ffffffffc0209f58:	e062                	sd	s8,0(sp)
ffffffffc0209f5a:	8b2e                	mv	s6,a1
ffffffffc0209f5c:	e53f70ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc0209f60:	cd61                	beqz	a0,ffffffffc020a038 <sfs_getdirentry+0xfa>
ffffffffc0209f62:	068abb83          	ld	s7,104(s5)
ffffffffc0209f66:	0c0b8b63          	beqz	s7,ffffffffc020a03c <sfs_getdirentry+0xfe>
ffffffffc0209f6a:	0b0ba783          	lw	a5,176(s7)
ffffffffc0209f6e:	e7f9                	bnez	a5,ffffffffc020a03c <sfs_getdirentry+0xfe>
ffffffffc0209f70:	058aa703          	lw	a4,88(s5)
ffffffffc0209f74:	6785                	lui	a5,0x1
ffffffffc0209f76:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209f7a:	0ef71163          	bne	a4,a5,ffffffffc020a05c <sfs_getdirentry+0x11e>
ffffffffc0209f7e:	008b3983          	ld	s3,8(s6)
ffffffffc0209f82:	892a                	mv	s2,a0
ffffffffc0209f84:	0a09c163          	bltz	s3,ffffffffc020a026 <sfs_getdirentry+0xe8>
ffffffffc0209f88:	0ff9f793          	zext.b	a5,s3
ffffffffc0209f8c:	efc9                	bnez	a5,ffffffffc020a026 <sfs_getdirentry+0xe8>
ffffffffc0209f8e:	000ab783          	ld	a5,0(s5)
ffffffffc0209f92:	0089d993          	srli	s3,s3,0x8
ffffffffc0209f96:	2981                	sext.w	s3,s3
ffffffffc0209f98:	479c                	lw	a5,8(a5)
ffffffffc0209f9a:	0937eb63          	bltu	a5,s3,ffffffffc020a030 <sfs_getdirentry+0xf2>
ffffffffc0209f9e:	020a8c13          	addi	s8,s5,32
ffffffffc0209fa2:	8562                	mv	a0,s8
ffffffffc0209fa4:	83ffa0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc0209fa8:	000ab783          	ld	a5,0(s5)
ffffffffc0209fac:	0087aa03          	lw	s4,8(a5)
ffffffffc0209fb0:	07405663          	blez	s4,ffffffffc020a01c <sfs_getdirentry+0xde>
ffffffffc0209fb4:	4481                	li	s1,0
ffffffffc0209fb6:	a811                	j	ffffffffc0209fca <sfs_getdirentry+0x8c>
ffffffffc0209fb8:	00092783          	lw	a5,0(s2)
ffffffffc0209fbc:	c781                	beqz	a5,ffffffffc0209fc4 <sfs_getdirentry+0x86>
ffffffffc0209fbe:	02098263          	beqz	s3,ffffffffc0209fe2 <sfs_getdirentry+0xa4>
ffffffffc0209fc2:	39fd                	addiw	s3,s3,-1
ffffffffc0209fc4:	2485                	addiw	s1,s1,1
ffffffffc0209fc6:	049a0b63          	beq	s4,s1,ffffffffc020a01c <sfs_getdirentry+0xde>
ffffffffc0209fca:	86ca                	mv	a3,s2
ffffffffc0209fcc:	8626                	mv	a2,s1
ffffffffc0209fce:	85d6                	mv	a1,s5
ffffffffc0209fd0:	855e                	mv	a0,s7
ffffffffc0209fd2:	eadff0ef          	jal	ra,ffffffffc0209e7e <sfs_dirent_read_nolock>
ffffffffc0209fd6:	842a                	mv	s0,a0
ffffffffc0209fd8:	d165                	beqz	a0,ffffffffc0209fb8 <sfs_getdirentry+0x7a>
ffffffffc0209fda:	8562                	mv	a0,s8
ffffffffc0209fdc:	803fa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0209fe0:	a831                	j	ffffffffc0209ffc <sfs_getdirentry+0xbe>
ffffffffc0209fe2:	8562                	mv	a0,s8
ffffffffc0209fe4:	ffafa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc0209fe8:	4701                	li	a4,0
ffffffffc0209fea:	4685                	li	a3,1
ffffffffc0209fec:	10000613          	li	a2,256
ffffffffc0209ff0:	00490593          	addi	a1,s2,4
ffffffffc0209ff4:	855a                	mv	a0,s6
ffffffffc0209ff6:	fd8fb0ef          	jal	ra,ffffffffc02057ce <iobuf_move>
ffffffffc0209ffa:	842a                	mv	s0,a0
ffffffffc0209ffc:	854a                	mv	a0,s2
ffffffffc0209ffe:	e61f70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a002:	60a6                	ld	ra,72(sp)
ffffffffc020a004:	8522                	mv	a0,s0
ffffffffc020a006:	6406                	ld	s0,64(sp)
ffffffffc020a008:	74e2                	ld	s1,56(sp)
ffffffffc020a00a:	7942                	ld	s2,48(sp)
ffffffffc020a00c:	79a2                	ld	s3,40(sp)
ffffffffc020a00e:	7a02                	ld	s4,32(sp)
ffffffffc020a010:	6ae2                	ld	s5,24(sp)
ffffffffc020a012:	6b42                	ld	s6,16(sp)
ffffffffc020a014:	6ba2                	ld	s7,8(sp)
ffffffffc020a016:	6c02                	ld	s8,0(sp)
ffffffffc020a018:	6161                	addi	sp,sp,80
ffffffffc020a01a:	8082                	ret
ffffffffc020a01c:	8562                	mv	a0,s8
ffffffffc020a01e:	5441                	li	s0,-16
ffffffffc020a020:	fbefa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020a024:	bfe1                	j	ffffffffc0209ffc <sfs_getdirentry+0xbe>
ffffffffc020a026:	854a                	mv	a0,s2
ffffffffc020a028:	e37f70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a02c:	5475                	li	s0,-3
ffffffffc020a02e:	bfd1                	j	ffffffffc020a002 <sfs_getdirentry+0xc4>
ffffffffc020a030:	e2ff70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a034:	5441                	li	s0,-16
ffffffffc020a036:	b7f1                	j	ffffffffc020a002 <sfs_getdirentry+0xc4>
ffffffffc020a038:	5471                	li	s0,-4
ffffffffc020a03a:	b7e1                	j	ffffffffc020a002 <sfs_getdirentry+0xc4>
ffffffffc020a03c:	00005697          	auipc	a3,0x5
ffffffffc020a040:	e9c68693          	addi	a3,a3,-356 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020a044:	00002617          	auipc	a2,0x2
ffffffffc020a048:	bd460613          	addi	a2,a2,-1068 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a04c:	36200593          	li	a1,866
ffffffffc020a050:	00005517          	auipc	a0,0x5
ffffffffc020a054:	e5850513          	addi	a0,a0,-424 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a058:	9d6f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a05c:	00005697          	auipc	a3,0x5
ffffffffc020a060:	e1468693          	addi	a3,a3,-492 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a064:	00002617          	auipc	a2,0x2
ffffffffc020a068:	bb460613          	addi	a2,a2,-1100 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a06c:	36300593          	li	a1,867
ffffffffc020a070:	00005517          	auipc	a0,0x5
ffffffffc020a074:	e3850513          	addi	a0,a0,-456 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a078:	9b6f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a07c <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a07c:	715d                	addi	sp,sp,-80
ffffffffc020a07e:	f052                	sd	s4,32(sp)
ffffffffc020a080:	8a2a                	mv	s4,a0
ffffffffc020a082:	8532                	mv	a0,a2
ffffffffc020a084:	f44e                	sd	s3,40(sp)
ffffffffc020a086:	e85a                	sd	s6,16(sp)
ffffffffc020a088:	e45e                	sd	s7,8(sp)
ffffffffc020a08a:	e486                	sd	ra,72(sp)
ffffffffc020a08c:	e0a2                	sd	s0,64(sp)
ffffffffc020a08e:	fc26                	sd	s1,56(sp)
ffffffffc020a090:	f84a                	sd	s2,48(sp)
ffffffffc020a092:	ec56                	sd	s5,24(sp)
ffffffffc020a094:	e062                	sd	s8,0(sp)
ffffffffc020a096:	8b32                	mv	s6,a2
ffffffffc020a098:	89ae                	mv	s3,a1
ffffffffc020a09a:	8bb6                	mv	s7,a3
ffffffffc020a09c:	0e0010ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc020a0a0:	0ff00793          	li	a5,255
ffffffffc020a0a4:	06a7ef63          	bltu	a5,a0,ffffffffc020a122 <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a0a8:	10400513          	li	a0,260
ffffffffc020a0ac:	d03f70ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020a0b0:	892a                	mv	s2,a0
ffffffffc020a0b2:	c535                	beqz	a0,ffffffffc020a11e <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a0b4:	0009b783          	ld	a5,0(s3)
ffffffffc020a0b8:	0087aa83          	lw	s5,8(a5)
ffffffffc020a0bc:	05505a63          	blez	s5,ffffffffc020a110 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a0c0:	4481                	li	s1,0
ffffffffc020a0c2:	00450c13          	addi	s8,a0,4
ffffffffc020a0c6:	a829                	j	ffffffffc020a0e0 <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a0c8:	00092783          	lw	a5,0(s2)
ffffffffc020a0cc:	c799                	beqz	a5,ffffffffc020a0da <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a0ce:	85e2                	mv	a1,s8
ffffffffc020a0d0:	855a                	mv	a0,s6
ffffffffc020a0d2:	0f2010ef          	jal	ra,ffffffffc020b1c4 <strcmp>
ffffffffc020a0d6:	842a                	mv	s0,a0
ffffffffc020a0d8:	cd15                	beqz	a0,ffffffffc020a114 <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a0da:	2485                	addiw	s1,s1,1
ffffffffc020a0dc:	029a8a63          	beq	s5,s1,ffffffffc020a110 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a0e0:	86ca                	mv	a3,s2
ffffffffc020a0e2:	8626                	mv	a2,s1
ffffffffc020a0e4:	85ce                	mv	a1,s3
ffffffffc020a0e6:	8552                	mv	a0,s4
ffffffffc020a0e8:	d97ff0ef          	jal	ra,ffffffffc0209e7e <sfs_dirent_read_nolock>
ffffffffc020a0ec:	842a                	mv	s0,a0
ffffffffc020a0ee:	dd69                	beqz	a0,ffffffffc020a0c8 <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a0f0:	854a                	mv	a0,s2
ffffffffc020a0f2:	d6df70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a0f6:	60a6                	ld	ra,72(sp)
ffffffffc020a0f8:	8522                	mv	a0,s0
ffffffffc020a0fa:	6406                	ld	s0,64(sp)
ffffffffc020a0fc:	74e2                	ld	s1,56(sp)
ffffffffc020a0fe:	7942                	ld	s2,48(sp)
ffffffffc020a100:	79a2                	ld	s3,40(sp)
ffffffffc020a102:	7a02                	ld	s4,32(sp)
ffffffffc020a104:	6ae2                	ld	s5,24(sp)
ffffffffc020a106:	6b42                	ld	s6,16(sp)
ffffffffc020a108:	6ba2                	ld	s7,8(sp)
ffffffffc020a10a:	6c02                	ld	s8,0(sp)
ffffffffc020a10c:	6161                	addi	sp,sp,80
ffffffffc020a10e:	8082                	ret
ffffffffc020a110:	5441                	li	s0,-16
ffffffffc020a112:	bff9                	j	ffffffffc020a0f0 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a114:	00092783          	lw	a5,0(s2)
ffffffffc020a118:	00fba023          	sw	a5,0(s7)
ffffffffc020a11c:	bfd1                	j	ffffffffc020a0f0 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a11e:	5471                	li	s0,-4
ffffffffc020a120:	bfd9                	j	ffffffffc020a0f6 <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a122:	00005697          	auipc	a3,0x5
ffffffffc020a126:	f9668693          	addi	a3,a3,-106 # ffffffffc020f0b8 <dev_node_ops+0x398>
ffffffffc020a12a:	00002617          	auipc	a2,0x2
ffffffffc020a12e:	aee60613          	addi	a2,a2,-1298 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a132:	1ba00593          	li	a1,442
ffffffffc020a136:	00005517          	auipc	a0,0x5
ffffffffc020a13a:	d7250513          	addi	a0,a0,-654 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a13e:	8f0f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a142 <sfs_truncfile>:
ffffffffc020a142:	7175                	addi	sp,sp,-144
ffffffffc020a144:	e506                	sd	ra,136(sp)
ffffffffc020a146:	e122                	sd	s0,128(sp)
ffffffffc020a148:	fca6                	sd	s1,120(sp)
ffffffffc020a14a:	f8ca                	sd	s2,112(sp)
ffffffffc020a14c:	f4ce                	sd	s3,104(sp)
ffffffffc020a14e:	f0d2                	sd	s4,96(sp)
ffffffffc020a150:	ecd6                	sd	s5,88(sp)
ffffffffc020a152:	e8da                	sd	s6,80(sp)
ffffffffc020a154:	e4de                	sd	s7,72(sp)
ffffffffc020a156:	e0e2                	sd	s8,64(sp)
ffffffffc020a158:	fc66                	sd	s9,56(sp)
ffffffffc020a15a:	f86a                	sd	s10,48(sp)
ffffffffc020a15c:	f46e                	sd	s11,40(sp)
ffffffffc020a15e:	080007b7          	lui	a5,0x8000
ffffffffc020a162:	16b7e463          	bltu	a5,a1,ffffffffc020a2ca <sfs_truncfile+0x188>
ffffffffc020a166:	06853c83          	ld	s9,104(a0)
ffffffffc020a16a:	89aa                	mv	s3,a0
ffffffffc020a16c:	160c8163          	beqz	s9,ffffffffc020a2ce <sfs_truncfile+0x18c>
ffffffffc020a170:	0b0ca783          	lw	a5,176(s9) # 40b0 <_binary_bin_swap_img_size-0x3c50>
ffffffffc020a174:	14079d63          	bnez	a5,ffffffffc020a2ce <sfs_truncfile+0x18c>
ffffffffc020a178:	4d38                	lw	a4,88(a0)
ffffffffc020a17a:	6405                	lui	s0,0x1
ffffffffc020a17c:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a180:	16f71763          	bne	a4,a5,ffffffffc020a2ee <sfs_truncfile+0x1ac>
ffffffffc020a184:	00053a83          	ld	s5,0(a0)
ffffffffc020a188:	147d                	addi	s0,s0,-1
ffffffffc020a18a:	942e                	add	s0,s0,a1
ffffffffc020a18c:	000ae783          	lwu	a5,0(s5)
ffffffffc020a190:	8031                	srli	s0,s0,0xc
ffffffffc020a192:	8a2e                	mv	s4,a1
ffffffffc020a194:	2401                	sext.w	s0,s0
ffffffffc020a196:	02b79763          	bne	a5,a1,ffffffffc020a1c4 <sfs_truncfile+0x82>
ffffffffc020a19a:	008aa783          	lw	a5,8(s5)
ffffffffc020a19e:	4901                	li	s2,0
ffffffffc020a1a0:	18879763          	bne	a5,s0,ffffffffc020a32e <sfs_truncfile+0x1ec>
ffffffffc020a1a4:	60aa                	ld	ra,136(sp)
ffffffffc020a1a6:	640a                	ld	s0,128(sp)
ffffffffc020a1a8:	74e6                	ld	s1,120(sp)
ffffffffc020a1aa:	79a6                	ld	s3,104(sp)
ffffffffc020a1ac:	7a06                	ld	s4,96(sp)
ffffffffc020a1ae:	6ae6                	ld	s5,88(sp)
ffffffffc020a1b0:	6b46                	ld	s6,80(sp)
ffffffffc020a1b2:	6ba6                	ld	s7,72(sp)
ffffffffc020a1b4:	6c06                	ld	s8,64(sp)
ffffffffc020a1b6:	7ce2                	ld	s9,56(sp)
ffffffffc020a1b8:	7d42                	ld	s10,48(sp)
ffffffffc020a1ba:	7da2                	ld	s11,40(sp)
ffffffffc020a1bc:	854a                	mv	a0,s2
ffffffffc020a1be:	7946                	ld	s2,112(sp)
ffffffffc020a1c0:	6149                	addi	sp,sp,144
ffffffffc020a1c2:	8082                	ret
ffffffffc020a1c4:	02050b13          	addi	s6,a0,32
ffffffffc020a1c8:	855a                	mv	a0,s6
ffffffffc020a1ca:	e18fa0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc020a1ce:	008aa483          	lw	s1,8(s5)
ffffffffc020a1d2:	0a84e663          	bltu	s1,s0,ffffffffc020a27e <sfs_truncfile+0x13c>
ffffffffc020a1d6:	0c947163          	bgeu	s0,s1,ffffffffc020a298 <sfs_truncfile+0x156>
ffffffffc020a1da:	4dad                	li	s11,11
ffffffffc020a1dc:	4b85                	li	s7,1
ffffffffc020a1de:	a09d                	j	ffffffffc020a244 <sfs_truncfile+0x102>
ffffffffc020a1e0:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a1e4:	0009079b          	sext.w	a5,s2
ffffffffc020a1e8:	3ff00713          	li	a4,1023
ffffffffc020a1ec:	04f76563          	bltu	a4,a5,ffffffffc020a236 <sfs_truncfile+0xf4>
ffffffffc020a1f0:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a1f4:	040c0163          	beqz	s8,ffffffffc020a236 <sfs_truncfile+0xf4>
ffffffffc020a1f8:	004ca783          	lw	a5,4(s9)
ffffffffc020a1fc:	18fc7963          	bgeu	s8,a5,ffffffffc020a38e <sfs_truncfile+0x24c>
ffffffffc020a200:	038cb503          	ld	a0,56(s9)
ffffffffc020a204:	85e2                	mv	a1,s8
ffffffffc020a206:	6d5000ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc020a20a:	16051263          	bnez	a0,ffffffffc020a36e <sfs_truncfile+0x22c>
ffffffffc020a20e:	02091793          	slli	a5,s2,0x20
ffffffffc020a212:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a216:	86e2                	mv	a3,s8
ffffffffc020a218:	4611                	li	a2,4
ffffffffc020a21a:	082c                	addi	a1,sp,24
ffffffffc020a21c:	8566                	mv	a0,s9
ffffffffc020a21e:	e43a                	sd	a4,8(sp)
ffffffffc020a220:	ce02                	sw	zero,28(sp)
ffffffffc020a222:	f11fe0ef          	jal	ra,ffffffffc0209132 <sfs_rbuf>
ffffffffc020a226:	892a                	mv	s2,a0
ffffffffc020a228:	e141                	bnez	a0,ffffffffc020a2a8 <sfs_truncfile+0x166>
ffffffffc020a22a:	47e2                	lw	a5,24(sp)
ffffffffc020a22c:	6722                	ld	a4,8(sp)
ffffffffc020a22e:	e3c9                	bnez	a5,ffffffffc020a2b0 <sfs_truncfile+0x16e>
ffffffffc020a230:	008d2603          	lw	a2,8(s10)
ffffffffc020a234:	367d                	addiw	a2,a2,-1
ffffffffc020a236:	00cd2423          	sw	a2,8(s10)
ffffffffc020a23a:	0179b823          	sd	s7,16(s3)
ffffffffc020a23e:	34fd                	addiw	s1,s1,-1
ffffffffc020a240:	04940a63          	beq	s0,s1,ffffffffc020a294 <sfs_truncfile+0x152>
ffffffffc020a244:	0009bd03          	ld	s10,0(s3)
ffffffffc020a248:	008d2703          	lw	a4,8(s10)
ffffffffc020a24c:	c369                	beqz	a4,ffffffffc020a30e <sfs_truncfile+0x1cc>
ffffffffc020a24e:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a252:	0007861b          	sext.w	a2,a5
ffffffffc020a256:	f8cde5e3          	bltu	s11,a2,ffffffffc020a1e0 <sfs_truncfile+0x9e>
ffffffffc020a25a:	02079713          	slli	a4,a5,0x20
ffffffffc020a25e:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a262:	00fd0933          	add	s2,s10,a5
ffffffffc020a266:	00c92583          	lw	a1,12(s2)
ffffffffc020a26a:	d5f1                	beqz	a1,ffffffffc020a236 <sfs_truncfile+0xf4>
ffffffffc020a26c:	8566                	mv	a0,s9
ffffffffc020a26e:	c14ff0ef          	jal	ra,ffffffffc0209682 <sfs_block_free>
ffffffffc020a272:	00092623          	sw	zero,12(s2)
ffffffffc020a276:	008d2603          	lw	a2,8(s10)
ffffffffc020a27a:	367d                	addiw	a2,a2,-1
ffffffffc020a27c:	bf6d                	j	ffffffffc020a236 <sfs_truncfile+0xf4>
ffffffffc020a27e:	4681                	li	a3,0
ffffffffc020a280:	8626                	mv	a2,s1
ffffffffc020a282:	85ce                	mv	a1,s3
ffffffffc020a284:	8566                	mv	a0,s9
ffffffffc020a286:	eb6ff0ef          	jal	ra,ffffffffc020993c <sfs_bmap_load_nolock>
ffffffffc020a28a:	892a                	mv	s2,a0
ffffffffc020a28c:	ed11                	bnez	a0,ffffffffc020a2a8 <sfs_truncfile+0x166>
ffffffffc020a28e:	2485                	addiw	s1,s1,1
ffffffffc020a290:	fe9417e3          	bne	s0,s1,ffffffffc020a27e <sfs_truncfile+0x13c>
ffffffffc020a294:	008aa483          	lw	s1,8(s5)
ffffffffc020a298:	0a941b63          	bne	s0,s1,ffffffffc020a34e <sfs_truncfile+0x20c>
ffffffffc020a29c:	014aa023          	sw	s4,0(s5)
ffffffffc020a2a0:	4785                	li	a5,1
ffffffffc020a2a2:	00f9b823          	sd	a5,16(s3)
ffffffffc020a2a6:	4901                	li	s2,0
ffffffffc020a2a8:	855a                	mv	a0,s6
ffffffffc020a2aa:	d34fa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020a2ae:	bddd                	j	ffffffffc020a1a4 <sfs_truncfile+0x62>
ffffffffc020a2b0:	86e2                	mv	a3,s8
ffffffffc020a2b2:	4611                	li	a2,4
ffffffffc020a2b4:	086c                	addi	a1,sp,28
ffffffffc020a2b6:	8566                	mv	a0,s9
ffffffffc020a2b8:	efbfe0ef          	jal	ra,ffffffffc02091b2 <sfs_wbuf>
ffffffffc020a2bc:	892a                	mv	s2,a0
ffffffffc020a2be:	f56d                	bnez	a0,ffffffffc020a2a8 <sfs_truncfile+0x166>
ffffffffc020a2c0:	45e2                	lw	a1,24(sp)
ffffffffc020a2c2:	8566                	mv	a0,s9
ffffffffc020a2c4:	bbeff0ef          	jal	ra,ffffffffc0209682 <sfs_block_free>
ffffffffc020a2c8:	b7a5                	j	ffffffffc020a230 <sfs_truncfile+0xee>
ffffffffc020a2ca:	5975                	li	s2,-3
ffffffffc020a2cc:	bde1                	j	ffffffffc020a1a4 <sfs_truncfile+0x62>
ffffffffc020a2ce:	00005697          	auipc	a3,0x5
ffffffffc020a2d2:	c0a68693          	addi	a3,a3,-1014 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020a2d6:	00002617          	auipc	a2,0x2
ffffffffc020a2da:	94260613          	addi	a2,a2,-1726 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a2de:	3d100593          	li	a1,977
ffffffffc020a2e2:	00005517          	auipc	a0,0x5
ffffffffc020a2e6:	bc650513          	addi	a0,a0,-1082 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a2ea:	f45f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a2ee:	00005697          	auipc	a3,0x5
ffffffffc020a2f2:	b8268693          	addi	a3,a3,-1150 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a2f6:	00002617          	auipc	a2,0x2
ffffffffc020a2fa:	92260613          	addi	a2,a2,-1758 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a2fe:	3d200593          	li	a1,978
ffffffffc020a302:	00005517          	auipc	a0,0x5
ffffffffc020a306:	ba650513          	addi	a0,a0,-1114 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a30a:	f25f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a30e:	00005697          	auipc	a3,0x5
ffffffffc020a312:	dea68693          	addi	a3,a3,-534 # ffffffffc020f0f8 <dev_node_ops+0x3d8>
ffffffffc020a316:	00002617          	auipc	a2,0x2
ffffffffc020a31a:	90260613          	addi	a2,a2,-1790 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a31e:	17b00593          	li	a1,379
ffffffffc020a322:	00005517          	auipc	a0,0x5
ffffffffc020a326:	b8650513          	addi	a0,a0,-1146 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a32a:	f05f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a32e:	00005697          	auipc	a3,0x5
ffffffffc020a332:	db268693          	addi	a3,a3,-590 # ffffffffc020f0e0 <dev_node_ops+0x3c0>
ffffffffc020a336:	00002617          	auipc	a2,0x2
ffffffffc020a33a:	8e260613          	addi	a2,a2,-1822 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a33e:	3d900593          	li	a1,985
ffffffffc020a342:	00005517          	auipc	a0,0x5
ffffffffc020a346:	b6650513          	addi	a0,a0,-1178 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a34a:	ee5f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a34e:	00005697          	auipc	a3,0x5
ffffffffc020a352:	dfa68693          	addi	a3,a3,-518 # ffffffffc020f148 <dev_node_ops+0x428>
ffffffffc020a356:	00002617          	auipc	a2,0x2
ffffffffc020a35a:	8c260613          	addi	a2,a2,-1854 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a35e:	3f200593          	li	a1,1010
ffffffffc020a362:	00005517          	auipc	a0,0x5
ffffffffc020a366:	b4650513          	addi	a0,a0,-1210 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a36a:	ec5f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a36e:	00005697          	auipc	a3,0x5
ffffffffc020a372:	da268693          	addi	a3,a3,-606 # ffffffffc020f110 <dev_node_ops+0x3f0>
ffffffffc020a376:	00002617          	auipc	a2,0x2
ffffffffc020a37a:	8a260613          	addi	a2,a2,-1886 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a37e:	12b00593          	li	a1,299
ffffffffc020a382:	00005517          	auipc	a0,0x5
ffffffffc020a386:	b2650513          	addi	a0,a0,-1242 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a38a:	ea5f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a38e:	8762                	mv	a4,s8
ffffffffc020a390:	86be                	mv	a3,a5
ffffffffc020a392:	00005617          	auipc	a2,0x5
ffffffffc020a396:	b7660613          	addi	a2,a2,-1162 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc020a39a:	05300593          	li	a1,83
ffffffffc020a39e:	00005517          	auipc	a0,0x5
ffffffffc020a3a2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a3a6:	e89f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a3aa <sfs_load_inode>:
ffffffffc020a3aa:	7139                	addi	sp,sp,-64
ffffffffc020a3ac:	fc06                	sd	ra,56(sp)
ffffffffc020a3ae:	f822                	sd	s0,48(sp)
ffffffffc020a3b0:	f426                	sd	s1,40(sp)
ffffffffc020a3b2:	f04a                	sd	s2,32(sp)
ffffffffc020a3b4:	84b2                	mv	s1,a2
ffffffffc020a3b6:	892a                	mv	s2,a0
ffffffffc020a3b8:	ec4e                	sd	s3,24(sp)
ffffffffc020a3ba:	e852                	sd	s4,16(sp)
ffffffffc020a3bc:	89ae                	mv	s3,a1
ffffffffc020a3be:	e456                	sd	s5,8(sp)
ffffffffc020a3c0:	fa3fe0ef          	jal	ra,ffffffffc0209362 <lock_sfs_fs>
ffffffffc020a3c4:	45a9                	li	a1,10
ffffffffc020a3c6:	8526                	mv	a0,s1
ffffffffc020a3c8:	0a893403          	ld	s0,168(s2)
ffffffffc020a3cc:	338010ef          	jal	ra,ffffffffc020b704 <hash32>
ffffffffc020a3d0:	02051793          	slli	a5,a0,0x20
ffffffffc020a3d4:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a3d8:	9722                	add	a4,a4,s0
ffffffffc020a3da:	843a                	mv	s0,a4
ffffffffc020a3dc:	a029                	j	ffffffffc020a3e6 <sfs_load_inode+0x3c>
ffffffffc020a3de:	fc042783          	lw	a5,-64(s0)
ffffffffc020a3e2:	10978863          	beq	a5,s1,ffffffffc020a4f2 <sfs_load_inode+0x148>
ffffffffc020a3e6:	6400                	ld	s0,8(s0)
ffffffffc020a3e8:	fe871be3          	bne	a4,s0,ffffffffc020a3de <sfs_load_inode+0x34>
ffffffffc020a3ec:	04000513          	li	a0,64
ffffffffc020a3f0:	9bff70ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020a3f4:	8aaa                	mv	s5,a0
ffffffffc020a3f6:	16050563          	beqz	a0,ffffffffc020a560 <sfs_load_inode+0x1b6>
ffffffffc020a3fa:	00492683          	lw	a3,4(s2)
ffffffffc020a3fe:	18048363          	beqz	s1,ffffffffc020a584 <sfs_load_inode+0x1da>
ffffffffc020a402:	18d4f163          	bgeu	s1,a3,ffffffffc020a584 <sfs_load_inode+0x1da>
ffffffffc020a406:	03893503          	ld	a0,56(s2)
ffffffffc020a40a:	85a6                	mv	a1,s1
ffffffffc020a40c:	4cf000ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc020a410:	18051763          	bnez	a0,ffffffffc020a59e <sfs_load_inode+0x1f4>
ffffffffc020a414:	4701                	li	a4,0
ffffffffc020a416:	86a6                	mv	a3,s1
ffffffffc020a418:	04000613          	li	a2,64
ffffffffc020a41c:	85d6                	mv	a1,s5
ffffffffc020a41e:	854a                	mv	a0,s2
ffffffffc020a420:	d13fe0ef          	jal	ra,ffffffffc0209132 <sfs_rbuf>
ffffffffc020a424:	842a                	mv	s0,a0
ffffffffc020a426:	0e051563          	bnez	a0,ffffffffc020a510 <sfs_load_inode+0x166>
ffffffffc020a42a:	006ad783          	lhu	a5,6(s5)
ffffffffc020a42e:	12078b63          	beqz	a5,ffffffffc020a564 <sfs_load_inode+0x1ba>
ffffffffc020a432:	6405                	lui	s0,0x1
ffffffffc020a434:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a438:	e83fd0ef          	jal	ra,ffffffffc02082ba <__alloc_inode>
ffffffffc020a43c:	8a2a                	mv	s4,a0
ffffffffc020a43e:	c961                	beqz	a0,ffffffffc020a50e <sfs_load_inode+0x164>
ffffffffc020a440:	004ad683          	lhu	a3,4(s5)
ffffffffc020a444:	4785                	li	a5,1
ffffffffc020a446:	0cf69c63          	bne	a3,a5,ffffffffc020a51e <sfs_load_inode+0x174>
ffffffffc020a44a:	864a                	mv	a2,s2
ffffffffc020a44c:	00005597          	auipc	a1,0x5
ffffffffc020a450:	e0c58593          	addi	a1,a1,-500 # ffffffffc020f258 <sfs_node_fileops>
ffffffffc020a454:	e83fd0ef          	jal	ra,ffffffffc02082d6 <inode_init>
ffffffffc020a458:	058a2783          	lw	a5,88(s4)
ffffffffc020a45c:	23540413          	addi	s0,s0,565
ffffffffc020a460:	0e879063          	bne	a5,s0,ffffffffc020a540 <sfs_load_inode+0x196>
ffffffffc020a464:	4785                	li	a5,1
ffffffffc020a466:	00fa2c23          	sw	a5,24(s4)
ffffffffc020a46a:	015a3023          	sd	s5,0(s4)
ffffffffc020a46e:	009a2423          	sw	s1,8(s4)
ffffffffc020a472:	000a3823          	sd	zero,16(s4)
ffffffffc020a476:	4585                	li	a1,1
ffffffffc020a478:	020a0513          	addi	a0,s4,32
ffffffffc020a47c:	b5afa0ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc020a480:	058a2703          	lw	a4,88(s4)
ffffffffc020a484:	6785                	lui	a5,0x1
ffffffffc020a486:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a48a:	14f71663          	bne	a4,a5,ffffffffc020a5d6 <sfs_load_inode+0x22c>
ffffffffc020a48e:	0a093703          	ld	a4,160(s2)
ffffffffc020a492:	038a0793          	addi	a5,s4,56
ffffffffc020a496:	008a2503          	lw	a0,8(s4)
ffffffffc020a49a:	e31c                	sd	a5,0(a4)
ffffffffc020a49c:	0af93023          	sd	a5,160(s2)
ffffffffc020a4a0:	09890793          	addi	a5,s2,152
ffffffffc020a4a4:	0a893403          	ld	s0,168(s2)
ffffffffc020a4a8:	45a9                	li	a1,10
ffffffffc020a4aa:	04ea3023          	sd	a4,64(s4)
ffffffffc020a4ae:	02fa3c23          	sd	a5,56(s4)
ffffffffc020a4b2:	252010ef          	jal	ra,ffffffffc020b704 <hash32>
ffffffffc020a4b6:	02051713          	slli	a4,a0,0x20
ffffffffc020a4ba:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a4be:	97a2                	add	a5,a5,s0
ffffffffc020a4c0:	6798                	ld	a4,8(a5)
ffffffffc020a4c2:	048a0693          	addi	a3,s4,72
ffffffffc020a4c6:	e314                	sd	a3,0(a4)
ffffffffc020a4c8:	e794                	sd	a3,8(a5)
ffffffffc020a4ca:	04ea3823          	sd	a4,80(s4)
ffffffffc020a4ce:	04fa3423          	sd	a5,72(s4)
ffffffffc020a4d2:	854a                	mv	a0,s2
ffffffffc020a4d4:	e9ffe0ef          	jal	ra,ffffffffc0209372 <unlock_sfs_fs>
ffffffffc020a4d8:	4401                	li	s0,0
ffffffffc020a4da:	0149b023          	sd	s4,0(s3)
ffffffffc020a4de:	70e2                	ld	ra,56(sp)
ffffffffc020a4e0:	8522                	mv	a0,s0
ffffffffc020a4e2:	7442                	ld	s0,48(sp)
ffffffffc020a4e4:	74a2                	ld	s1,40(sp)
ffffffffc020a4e6:	7902                	ld	s2,32(sp)
ffffffffc020a4e8:	69e2                	ld	s3,24(sp)
ffffffffc020a4ea:	6a42                	ld	s4,16(sp)
ffffffffc020a4ec:	6aa2                	ld	s5,8(sp)
ffffffffc020a4ee:	6121                	addi	sp,sp,64
ffffffffc020a4f0:	8082                	ret
ffffffffc020a4f2:	fb840a13          	addi	s4,s0,-72
ffffffffc020a4f6:	8552                	mv	a0,s4
ffffffffc020a4f8:	e41fd0ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc020a4fc:	4785                	li	a5,1
ffffffffc020a4fe:	fcf51ae3          	bne	a0,a5,ffffffffc020a4d2 <sfs_load_inode+0x128>
ffffffffc020a502:	fd042783          	lw	a5,-48(s0)
ffffffffc020a506:	2785                	addiw	a5,a5,1
ffffffffc020a508:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a50c:	b7d9                	j	ffffffffc020a4d2 <sfs_load_inode+0x128>
ffffffffc020a50e:	5471                	li	s0,-4
ffffffffc020a510:	8556                	mv	a0,s5
ffffffffc020a512:	94df70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a516:	854a                	mv	a0,s2
ffffffffc020a518:	e5bfe0ef          	jal	ra,ffffffffc0209372 <unlock_sfs_fs>
ffffffffc020a51c:	b7c9                	j	ffffffffc020a4de <sfs_load_inode+0x134>
ffffffffc020a51e:	4789                	li	a5,2
ffffffffc020a520:	08f69f63          	bne	a3,a5,ffffffffc020a5be <sfs_load_inode+0x214>
ffffffffc020a524:	864a                	mv	a2,s2
ffffffffc020a526:	00005597          	auipc	a1,0x5
ffffffffc020a52a:	cb258593          	addi	a1,a1,-846 # ffffffffc020f1d8 <sfs_node_dirops>
ffffffffc020a52e:	da9fd0ef          	jal	ra,ffffffffc02082d6 <inode_init>
ffffffffc020a532:	058a2703          	lw	a4,88(s4)
ffffffffc020a536:	6785                	lui	a5,0x1
ffffffffc020a538:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a53c:	f2f704e3          	beq	a4,a5,ffffffffc020a464 <sfs_load_inode+0xba>
ffffffffc020a540:	00005697          	auipc	a3,0x5
ffffffffc020a544:	93068693          	addi	a3,a3,-1744 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a548:	00001617          	auipc	a2,0x1
ffffffffc020a54c:	6d060613          	addi	a2,a2,1744 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a550:	07700593          	li	a1,119
ffffffffc020a554:	00005517          	auipc	a0,0x5
ffffffffc020a558:	95450513          	addi	a0,a0,-1708 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a55c:	cd3f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a560:	5471                	li	s0,-4
ffffffffc020a562:	bf55                	j	ffffffffc020a516 <sfs_load_inode+0x16c>
ffffffffc020a564:	00005697          	auipc	a3,0x5
ffffffffc020a568:	bfc68693          	addi	a3,a3,-1028 # ffffffffc020f160 <dev_node_ops+0x440>
ffffffffc020a56c:	00001617          	auipc	a2,0x1
ffffffffc020a570:	6ac60613          	addi	a2,a2,1708 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a574:	0ad00593          	li	a1,173
ffffffffc020a578:	00005517          	auipc	a0,0x5
ffffffffc020a57c:	93050513          	addi	a0,a0,-1744 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a580:	caff50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a584:	8726                	mv	a4,s1
ffffffffc020a586:	00005617          	auipc	a2,0x5
ffffffffc020a58a:	98260613          	addi	a2,a2,-1662 # ffffffffc020ef08 <dev_node_ops+0x1e8>
ffffffffc020a58e:	05300593          	li	a1,83
ffffffffc020a592:	00005517          	auipc	a0,0x5
ffffffffc020a596:	91650513          	addi	a0,a0,-1770 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a59a:	c95f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a59e:	00005697          	auipc	a3,0x5
ffffffffc020a5a2:	9a268693          	addi	a3,a3,-1630 # ffffffffc020ef40 <dev_node_ops+0x220>
ffffffffc020a5a6:	00001617          	auipc	a2,0x1
ffffffffc020a5aa:	67260613          	addi	a2,a2,1650 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a5ae:	0a800593          	li	a1,168
ffffffffc020a5b2:	00005517          	auipc	a0,0x5
ffffffffc020a5b6:	8f650513          	addi	a0,a0,-1802 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a5ba:	c75f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a5be:	00005617          	auipc	a2,0x5
ffffffffc020a5c2:	90260613          	addi	a2,a2,-1790 # ffffffffc020eec0 <dev_node_ops+0x1a0>
ffffffffc020a5c6:	02e00593          	li	a1,46
ffffffffc020a5ca:	00005517          	auipc	a0,0x5
ffffffffc020a5ce:	8de50513          	addi	a0,a0,-1826 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a5d2:	c5df50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a5d6:	00005697          	auipc	a3,0x5
ffffffffc020a5da:	89a68693          	addi	a3,a3,-1894 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a5de:	00001617          	auipc	a2,0x1
ffffffffc020a5e2:	63a60613          	addi	a2,a2,1594 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a5e6:	0b100593          	li	a1,177
ffffffffc020a5ea:	00005517          	auipc	a0,0x5
ffffffffc020a5ee:	8be50513          	addi	a0,a0,-1858 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a5f2:	c3df50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a5f6 <sfs_lookup>:
ffffffffc020a5f6:	7139                	addi	sp,sp,-64
ffffffffc020a5f8:	ec4e                	sd	s3,24(sp)
ffffffffc020a5fa:	06853983          	ld	s3,104(a0)
ffffffffc020a5fe:	fc06                	sd	ra,56(sp)
ffffffffc020a600:	f822                	sd	s0,48(sp)
ffffffffc020a602:	f426                	sd	s1,40(sp)
ffffffffc020a604:	f04a                	sd	s2,32(sp)
ffffffffc020a606:	e852                	sd	s4,16(sp)
ffffffffc020a608:	0a098c63          	beqz	s3,ffffffffc020a6c0 <sfs_lookup+0xca>
ffffffffc020a60c:	0b09a783          	lw	a5,176(s3)
ffffffffc020a610:	ebc5                	bnez	a5,ffffffffc020a6c0 <sfs_lookup+0xca>
ffffffffc020a612:	0005c783          	lbu	a5,0(a1)
ffffffffc020a616:	84ae                	mv	s1,a1
ffffffffc020a618:	c7c1                	beqz	a5,ffffffffc020a6a0 <sfs_lookup+0xaa>
ffffffffc020a61a:	02f00713          	li	a4,47
ffffffffc020a61e:	08e78163          	beq	a5,a4,ffffffffc020a6a0 <sfs_lookup+0xaa>
ffffffffc020a622:	842a                	mv	s0,a0
ffffffffc020a624:	8a32                	mv	s4,a2
ffffffffc020a626:	d13fd0ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc020a62a:	4c38                	lw	a4,88(s0)
ffffffffc020a62c:	6785                	lui	a5,0x1
ffffffffc020a62e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a632:	0af71763          	bne	a4,a5,ffffffffc020a6e0 <sfs_lookup+0xea>
ffffffffc020a636:	6018                	ld	a4,0(s0)
ffffffffc020a638:	4789                	li	a5,2
ffffffffc020a63a:	00475703          	lhu	a4,4(a4)
ffffffffc020a63e:	04f71c63          	bne	a4,a5,ffffffffc020a696 <sfs_lookup+0xa0>
ffffffffc020a642:	02040913          	addi	s2,s0,32
ffffffffc020a646:	854a                	mv	a0,s2
ffffffffc020a648:	99afa0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc020a64c:	8626                	mv	a2,s1
ffffffffc020a64e:	0054                	addi	a3,sp,4
ffffffffc020a650:	85a2                	mv	a1,s0
ffffffffc020a652:	854e                	mv	a0,s3
ffffffffc020a654:	a29ff0ef          	jal	ra,ffffffffc020a07c <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a658:	84aa                	mv	s1,a0
ffffffffc020a65a:	854a                	mv	a0,s2
ffffffffc020a65c:	982fa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020a660:	cc89                	beqz	s1,ffffffffc020a67a <sfs_lookup+0x84>
ffffffffc020a662:	8522                	mv	a0,s0
ffffffffc020a664:	da3fd0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020a668:	70e2                	ld	ra,56(sp)
ffffffffc020a66a:	7442                	ld	s0,48(sp)
ffffffffc020a66c:	7902                	ld	s2,32(sp)
ffffffffc020a66e:	69e2                	ld	s3,24(sp)
ffffffffc020a670:	6a42                	ld	s4,16(sp)
ffffffffc020a672:	8526                	mv	a0,s1
ffffffffc020a674:	74a2                	ld	s1,40(sp)
ffffffffc020a676:	6121                	addi	sp,sp,64
ffffffffc020a678:	8082                	ret
ffffffffc020a67a:	4612                	lw	a2,4(sp)
ffffffffc020a67c:	002c                	addi	a1,sp,8
ffffffffc020a67e:	854e                	mv	a0,s3
ffffffffc020a680:	d2bff0ef          	jal	ra,ffffffffc020a3aa <sfs_load_inode>
ffffffffc020a684:	84aa                	mv	s1,a0
ffffffffc020a686:	8522                	mv	a0,s0
ffffffffc020a688:	d7ffd0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020a68c:	fcf1                	bnez	s1,ffffffffc020a668 <sfs_lookup+0x72>
ffffffffc020a68e:	67a2                	ld	a5,8(sp)
ffffffffc020a690:	00fa3023          	sd	a5,0(s4)
ffffffffc020a694:	bfd1                	j	ffffffffc020a668 <sfs_lookup+0x72>
ffffffffc020a696:	8522                	mv	a0,s0
ffffffffc020a698:	d6ffd0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020a69c:	54b9                	li	s1,-18
ffffffffc020a69e:	b7e9                	j	ffffffffc020a668 <sfs_lookup+0x72>
ffffffffc020a6a0:	00005697          	auipc	a3,0x5
ffffffffc020a6a4:	ad868693          	addi	a3,a3,-1320 # ffffffffc020f178 <dev_node_ops+0x458>
ffffffffc020a6a8:	00001617          	auipc	a2,0x1
ffffffffc020a6ac:	57060613          	addi	a2,a2,1392 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a6b0:	40300593          	li	a1,1027
ffffffffc020a6b4:	00004517          	auipc	a0,0x4
ffffffffc020a6b8:	7f450513          	addi	a0,a0,2036 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a6bc:	b73f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a6c0:	00005697          	auipc	a3,0x5
ffffffffc020a6c4:	81868693          	addi	a3,a3,-2024 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020a6c8:	00001617          	auipc	a2,0x1
ffffffffc020a6cc:	55060613          	addi	a2,a2,1360 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a6d0:	40200593          	li	a1,1026
ffffffffc020a6d4:	00004517          	auipc	a0,0x4
ffffffffc020a6d8:	7d450513          	addi	a0,a0,2004 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a6dc:	b53f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a6e0:	00004697          	auipc	a3,0x4
ffffffffc020a6e4:	79068693          	addi	a3,a3,1936 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a6e8:	00001617          	auipc	a2,0x1
ffffffffc020a6ec:	53060613          	addi	a2,a2,1328 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a6f0:	40500593          	li	a1,1029
ffffffffc020a6f4:	00004517          	auipc	a0,0x4
ffffffffc020a6f8:	7b450513          	addi	a0,a0,1972 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a6fc:	b33f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a700 <sfs_namefile>:
ffffffffc020a700:	7135                	addi	sp,sp,-160
ffffffffc020a702:	e922                	sd	s0,144(sp)
ffffffffc020a704:	ed06                	sd	ra,152(sp)
ffffffffc020a706:	e526                	sd	s1,136(sp)
ffffffffc020a708:	e14a                	sd	s2,128(sp)
ffffffffc020a70a:	fcce                	sd	s3,120(sp)
ffffffffc020a70c:	f8d2                	sd	s4,112(sp)
ffffffffc020a70e:	f4d6                	sd	s5,104(sp)
ffffffffc020a710:	f0da                	sd	s6,96(sp)
ffffffffc020a712:	ecde                	sd	s7,88(sp)
ffffffffc020a714:	e8e2                	sd	s8,80(sp)
ffffffffc020a716:	e4e6                	sd	s9,72(sp)
ffffffffc020a718:	e0ea                	sd	s10,64(sp)
ffffffffc020a71a:	fc6e                	sd	s11,56(sp)
ffffffffc020a71c:	1100                	addi	s0,sp,160
ffffffffc020a71e:	6d98                	ld	a4,24(a1)
ffffffffc020a720:	f6b43823          	sd	a1,-144(s0)
ffffffffc020a724:	4789                	li	a5,2
ffffffffc020a726:	24e7f463          	bgeu	a5,a4,ffffffffc020a96e <sfs_namefile+0x26e>
ffffffffc020a72a:	8a2a                	mv	s4,a0
ffffffffc020a72c:	10400513          	li	a0,260
ffffffffc020a730:	e7ef70ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020a734:	84aa                	mv	s1,a0
ffffffffc020a736:	22050c63          	beqz	a0,ffffffffc020a96e <sfs_namefile+0x26e>
ffffffffc020a73a:	068a3903          	ld	s2,104(s4)
ffffffffc020a73e:	28090c63          	beqz	s2,ffffffffc020a9d6 <sfs_namefile+0x2d6>
ffffffffc020a742:	0b092783          	lw	a5,176(s2)
ffffffffc020a746:	28079863          	bnez	a5,ffffffffc020a9d6 <sfs_namefile+0x2d6>
ffffffffc020a74a:	058a2983          	lw	s3,88(s4)
ffffffffc020a74e:	6785                	lui	a5,0x1
ffffffffc020a750:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a754:	26f99163          	bne	s3,a5,ffffffffc020a9b6 <sfs_namefile+0x2b6>
ffffffffc020a758:	f7043703          	ld	a4,-144(s0)
ffffffffc020a75c:	8552                	mv	a0,s4
ffffffffc020a75e:	8bd2                	mv	s7,s4
ffffffffc020a760:	6f1c                	ld	a5,24(a4)
ffffffffc020a762:	6318                	ld	a4,0(a4)
ffffffffc020a764:	020a0b13          	addi	s6,s4,32
ffffffffc020a768:	07bd                	addi	a5,a5,15
ffffffffc020a76a:	9bc1                	andi	a5,a5,-16
ffffffffc020a76c:	40f10133          	sub	sp,sp,a5
ffffffffc020a770:	f6e43023          	sd	a4,-160(s0)
ffffffffc020a774:	f6243c23          	sd	sp,-136(s0)
ffffffffc020a778:	4a81                	li	s5,0
ffffffffc020a77a:	bbffd0ef          	jal	ra,ffffffffc0208338 <inode_ref_inc>
ffffffffc020a77e:	00448c13          	addi	s8,s1,4
ffffffffc020a782:	f7343423          	sd	s3,-152(s0)
ffffffffc020a786:	855a                	mv	a0,s6
ffffffffc020a788:	85afa0ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc020a78c:	f8440693          	addi	a3,s0,-124
ffffffffc020a790:	00005617          	auipc	a2,0x5
ffffffffc020a794:	a0860613          	addi	a2,a2,-1528 # ffffffffc020f198 <dev_node_ops+0x478>
ffffffffc020a798:	85de                	mv	a1,s7
ffffffffc020a79a:	854a                	mv	a0,s2
ffffffffc020a79c:	8e1ff0ef          	jal	ra,ffffffffc020a07c <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a7a0:	8caa                	mv	s9,a0
ffffffffc020a7a2:	855a                	mv	a0,s6
ffffffffc020a7a4:	83afa0ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020a7a8:	020c8a63          	beqz	s9,ffffffffc020a7dc <sfs_namefile+0xdc>
ffffffffc020a7ac:	8552                	mv	a0,s4
ffffffffc020a7ae:	c59fd0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020a7b2:	8526                	mv	a0,s1
ffffffffc020a7b4:	eaaf70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a7b8:	f6040113          	addi	sp,s0,-160
ffffffffc020a7bc:	60ea                	ld	ra,152(sp)
ffffffffc020a7be:	8566                	mv	a0,s9
ffffffffc020a7c0:	644a                	ld	s0,144(sp)
ffffffffc020a7c2:	64aa                	ld	s1,136(sp)
ffffffffc020a7c4:	690a                	ld	s2,128(sp)
ffffffffc020a7c6:	79e6                	ld	s3,120(sp)
ffffffffc020a7c8:	7a46                	ld	s4,112(sp)
ffffffffc020a7ca:	7aa6                	ld	s5,104(sp)
ffffffffc020a7cc:	7b06                	ld	s6,96(sp)
ffffffffc020a7ce:	6be6                	ld	s7,88(sp)
ffffffffc020a7d0:	6c46                	ld	s8,80(sp)
ffffffffc020a7d2:	6ca6                	ld	s9,72(sp)
ffffffffc020a7d4:	6d06                	ld	s10,64(sp)
ffffffffc020a7d6:	7de2                	ld	s11,56(sp)
ffffffffc020a7d8:	610d                	addi	sp,sp,160
ffffffffc020a7da:	8082                	ret
ffffffffc020a7dc:	f8442603          	lw	a2,-124(s0)
ffffffffc020a7e0:	f8840593          	addi	a1,s0,-120
ffffffffc020a7e4:	854a                	mv	a0,s2
ffffffffc020a7e6:	bc5ff0ef          	jal	ra,ffffffffc020a3aa <sfs_load_inode>
ffffffffc020a7ea:	8d2a                	mv	s10,a0
ffffffffc020a7ec:	20051563          	bnez	a0,ffffffffc020a9f6 <sfs_namefile+0x2f6>
ffffffffc020a7f0:	8552                	mv	a0,s4
ffffffffc020a7f2:	008ba983          	lw	s3,8(s7)
ffffffffc020a7f6:	c11fd0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020a7fa:	f8843d83          	ld	s11,-120(s0)
ffffffffc020a7fe:	0b4d8f63          	beq	s11,s4,ffffffffc020a8bc <sfs_namefile+0x1bc>
ffffffffc020a802:	160d8a63          	beqz	s11,ffffffffc020a976 <sfs_namefile+0x276>
ffffffffc020a806:	058da783          	lw	a5,88(s11)
ffffffffc020a80a:	f6843703          	ld	a4,-152(s0)
ffffffffc020a80e:	16e79463          	bne	a5,a4,ffffffffc020a976 <sfs_namefile+0x276>
ffffffffc020a812:	008da783          	lw	a5,8(s11)
ffffffffc020a816:	8bee                	mv	s7,s11
ffffffffc020a818:	17378f63          	beq	a5,s3,ffffffffc020a996 <sfs_namefile+0x296>
ffffffffc020a81c:	000db783          	ld	a5,0(s11)
ffffffffc020a820:	4709                	li	a4,2
ffffffffc020a822:	0047d783          	lhu	a5,4(a5)
ffffffffc020a826:	16e79863          	bne	a5,a4,ffffffffc020a996 <sfs_namefile+0x296>
ffffffffc020a82a:	020d8b13          	addi	s6,s11,32
ffffffffc020a82e:	855a                	mv	a0,s6
ffffffffc020a830:	fb3f90ef          	jal	ra,ffffffffc02047e2 <down>
ffffffffc020a834:	000db783          	ld	a5,0(s11)
ffffffffc020a838:	0087aa03          	lw	s4,8(a5)
ffffffffc020a83c:	01404963          	bgtz	s4,ffffffffc020a84e <sfs_namefile+0x14e>
ffffffffc020a840:	a885                	j	ffffffffc020a8b0 <sfs_namefile+0x1b0>
ffffffffc020a842:	409c                	lw	a5,0(s1)
ffffffffc020a844:	01378e63          	beq	a5,s3,ffffffffc020a860 <sfs_namefile+0x160>
ffffffffc020a848:	2d05                	addiw	s10,s10,1
ffffffffc020a84a:	07aa0363          	beq	s4,s10,ffffffffc020a8b0 <sfs_namefile+0x1b0>
ffffffffc020a84e:	86a6                	mv	a3,s1
ffffffffc020a850:	866a                	mv	a2,s10
ffffffffc020a852:	85ee                	mv	a1,s11
ffffffffc020a854:	854a                	mv	a0,s2
ffffffffc020a856:	e28ff0ef          	jal	ra,ffffffffc0209e7e <sfs_dirent_read_nolock>
ffffffffc020a85a:	8caa                	mv	s9,a0
ffffffffc020a85c:	d17d                	beqz	a0,ffffffffc020a842 <sfs_namefile+0x142>
ffffffffc020a85e:	a891                	j	ffffffffc020a8b2 <sfs_namefile+0x1b2>
ffffffffc020a860:	855a                	mv	a0,s6
ffffffffc020a862:	f7df90ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020a866:	8562                	mv	a0,s8
ffffffffc020a868:	115000ef          	jal	ra,ffffffffc020b17c <strlen>
ffffffffc020a86c:	f7043783          	ld	a5,-144(s0)
ffffffffc020a870:	89aa                	mv	s3,a0
ffffffffc020a872:	6f94                	ld	a3,24(a5)
ffffffffc020a874:	001a8793          	addi	a5,s5,1
ffffffffc020a878:	00a78633          	add	a2,a5,a0
ffffffffc020a87c:	8556                	mv	a0,s5
ffffffffc020a87e:	08c6e763          	bltu	a3,a2,ffffffffc020a90c <sfs_namefile+0x20c>
ffffffffc020a882:	01505c63          	blez	s5,ffffffffc020a89a <sfs_namefile+0x19a>
ffffffffc020a886:	f7843703          	ld	a4,-136(s0)
ffffffffc020a88a:	853e                	mv	a0,a5
ffffffffc020a88c:	015706b3          	add	a3,a4,s5
ffffffffc020a890:	02f00713          	li	a4,47
ffffffffc020a894:	00e68023          	sb	a4,0(a3)
ffffffffc020a898:	2a85                	addiw	s5,s5,1
ffffffffc020a89a:	f7843783          	ld	a5,-136(s0)
ffffffffc020a89e:	864e                	mv	a2,s3
ffffffffc020a8a0:	85e2                	mv	a1,s8
ffffffffc020a8a2:	953e                	add	a0,a0,a5
ffffffffc020a8a4:	1cd000ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc020a8a8:	01598abb          	addw	s5,s3,s5
ffffffffc020a8ac:	8a6e                	mv	s4,s11
ffffffffc020a8ae:	bde1                	j	ffffffffc020a786 <sfs_namefile+0x86>
ffffffffc020a8b0:	5cc1                	li	s9,-16
ffffffffc020a8b2:	855a                	mv	a0,s6
ffffffffc020a8b4:	f2bf90ef          	jal	ra,ffffffffc02047de <up>
ffffffffc020a8b8:	8a6e                	mv	s4,s11
ffffffffc020a8ba:	bdcd                	j	ffffffffc020a7ac <sfs_namefile+0xac>
ffffffffc020a8bc:	8552                	mv	a0,s4
ffffffffc020a8be:	b49fd0ef          	jal	ra,ffffffffc0208406 <inode_ref_dec>
ffffffffc020a8c2:	040a9863          	bnez	s5,ffffffffc020a912 <sfs_namefile+0x212>
ffffffffc020a8c6:	f7843703          	ld	a4,-136(s0)
ffffffffc020a8ca:	02f00793          	li	a5,47
ffffffffc020a8ce:	4905                	li	s2,1
ffffffffc020a8d0:	00f70023          	sb	a5,0(a4)
ffffffffc020a8d4:	f7043983          	ld	s3,-144(s0)
ffffffffc020a8d8:	5cf1                	li	s9,-4
ffffffffc020a8da:	0189b703          	ld	a4,24(s3)
ffffffffc020a8de:	ed2767e3          	bltu	a4,s2,ffffffffc020a7ac <sfs_namefile+0xac>
ffffffffc020a8e2:	f6043a03          	ld	s4,-160(s0)
ffffffffc020a8e6:	f7843583          	ld	a1,-136(s0)
ffffffffc020a8ea:	864a                	mv	a2,s2
ffffffffc020a8ec:	8552                	mv	a0,s4
ffffffffc020a8ee:	183000ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc020a8f2:	012a07b3          	add	a5,s4,s2
ffffffffc020a8f6:	85ca                	mv	a1,s2
ffffffffc020a8f8:	00078023          	sb	zero,0(a5)
ffffffffc020a8fc:	854e                	mv	a0,s3
ffffffffc020a8fe:	f3dfa0ef          	jal	ra,ffffffffc020583a <iobuf_skip>
ffffffffc020a902:	8526                	mv	a0,s1
ffffffffc020a904:	d5af70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020a908:	4c81                	li	s9,0
ffffffffc020a90a:	b57d                	j	ffffffffc020a7b8 <sfs_namefile+0xb8>
ffffffffc020a90c:	8a6e                	mv	s4,s11
ffffffffc020a90e:	5cf1                	li	s9,-4
ffffffffc020a910:	bd71                	j	ffffffffc020a7ac <sfs_namefile+0xac>
ffffffffc020a912:	f7043783          	ld	a5,-144(s0)
ffffffffc020a916:	898a                	mv	s3,sp
ffffffffc020a918:	6f9c                	ld	a5,24(a5)
ffffffffc020a91a:	07bd                	addi	a5,a5,15
ffffffffc020a91c:	9bc1                	andi	a5,a5,-16
ffffffffc020a91e:	40f10133          	sub	sp,sp,a5
ffffffffc020a922:	02f00793          	li	a5,47
ffffffffc020a926:	00f10023          	sb	a5,0(sp)
ffffffffc020a92a:	858a                	mv	a1,sp
ffffffffc020a92c:	05505363          	blez	s5,ffffffffc020a972 <sfs_namefile+0x272>
ffffffffc020a930:	fffa861b          	addiw	a2,s5,-1
ffffffffc020a934:	f7843783          	ld	a5,-136(s0)
ffffffffc020a938:	1602                	slli	a2,a2,0x20
ffffffffc020a93a:	9201                	srli	a2,a2,0x20
ffffffffc020a93c:	fffa8713          	addi	a4,s5,-1
ffffffffc020a940:	0609                	addi	a2,a2,2
ffffffffc020a942:	973e                	add	a4,a4,a5
ffffffffc020a944:	000a891b          	sext.w	s2,s5
ffffffffc020a948:	00110793          	addi	a5,sp,1
ffffffffc020a94c:	960a                	add	a2,a2,sp
ffffffffc020a94e:	00074683          	lbu	a3,0(a4)
ffffffffc020a952:	0785                	addi	a5,a5,1
ffffffffc020a954:	177d                	addi	a4,a4,-1
ffffffffc020a956:	fed78fa3          	sb	a3,-1(a5)
ffffffffc020a95a:	fec79ae3          	bne	a5,a2,ffffffffc020a94e <sfs_namefile+0x24e>
ffffffffc020a95e:	2905                	addiw	s2,s2,1
ffffffffc020a960:	f7843503          	ld	a0,-136(s0)
ffffffffc020a964:	864a                	mv	a2,s2
ffffffffc020a966:	10b000ef          	jal	ra,ffffffffc020b270 <memcpy>
ffffffffc020a96a:	814e                	mv	sp,s3
ffffffffc020a96c:	b7a5                	j	ffffffffc020a8d4 <sfs_namefile+0x1d4>
ffffffffc020a96e:	5cf1                	li	s9,-4
ffffffffc020a970:	b5a1                	j	ffffffffc020a7b8 <sfs_namefile+0xb8>
ffffffffc020a972:	4905                	li	s2,1
ffffffffc020a974:	b7f5                	j	ffffffffc020a960 <sfs_namefile+0x260>
ffffffffc020a976:	00004697          	auipc	a3,0x4
ffffffffc020a97a:	4fa68693          	addi	a3,a3,1274 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a97e:	00001617          	auipc	a2,0x1
ffffffffc020a982:	29a60613          	addi	a2,a2,666 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a986:	30500593          	li	a1,773
ffffffffc020a98a:	00004517          	auipc	a0,0x4
ffffffffc020a98e:	51e50513          	addi	a0,a0,1310 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a992:	89df50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a996:	00005697          	auipc	a3,0x5
ffffffffc020a99a:	80a68693          	addi	a3,a3,-2038 # ffffffffc020f1a0 <dev_node_ops+0x480>
ffffffffc020a99e:	00001617          	auipc	a2,0x1
ffffffffc020a9a2:	27a60613          	addi	a2,a2,634 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a9a6:	30600593          	li	a1,774
ffffffffc020a9aa:	00004517          	auipc	a0,0x4
ffffffffc020a9ae:	4fe50513          	addi	a0,a0,1278 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a9b2:	87df50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a9b6:	00004697          	auipc	a3,0x4
ffffffffc020a9ba:	4ba68693          	addi	a3,a3,1210 # ffffffffc020ee70 <dev_node_ops+0x150>
ffffffffc020a9be:	00001617          	auipc	a2,0x1
ffffffffc020a9c2:	25a60613          	addi	a2,a2,602 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a9c6:	2ec00593          	li	a1,748
ffffffffc020a9ca:	00004517          	auipc	a0,0x4
ffffffffc020a9ce:	4de50513          	addi	a0,a0,1246 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a9d2:	85df50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a9d6:	00004697          	auipc	a3,0x4
ffffffffc020a9da:	50268693          	addi	a3,a3,1282 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020a9de:	00001617          	auipc	a2,0x1
ffffffffc020a9e2:	23a60613          	addi	a2,a2,570 # ffffffffc020bc18 <commands+0x250>
ffffffffc020a9e6:	2eb00593          	li	a1,747
ffffffffc020a9ea:	00004517          	auipc	a0,0x4
ffffffffc020a9ee:	4be50513          	addi	a0,a0,1214 # ffffffffc020eea8 <dev_node_ops+0x188>
ffffffffc020a9f2:	83df50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a9f6:	8caa                	mv	s9,a0
ffffffffc020a9f8:	bb55                	j	ffffffffc020a7ac <sfs_namefile+0xac>

ffffffffc020a9fa <sfs_unmount>:
ffffffffc020a9fa:	1141                	addi	sp,sp,-16
ffffffffc020a9fc:	e406                	sd	ra,8(sp)
ffffffffc020a9fe:	e022                	sd	s0,0(sp)
ffffffffc020aa00:	cd1d                	beqz	a0,ffffffffc020aa3e <sfs_unmount+0x44>
ffffffffc020aa02:	0b052783          	lw	a5,176(a0)
ffffffffc020aa06:	842a                	mv	s0,a0
ffffffffc020aa08:	eb9d                	bnez	a5,ffffffffc020aa3e <sfs_unmount+0x44>
ffffffffc020aa0a:	7158                	ld	a4,160(a0)
ffffffffc020aa0c:	09850793          	addi	a5,a0,152
ffffffffc020aa10:	02f71563          	bne	a4,a5,ffffffffc020aa3a <sfs_unmount+0x40>
ffffffffc020aa14:	613c                	ld	a5,64(a0)
ffffffffc020aa16:	e7a1                	bnez	a5,ffffffffc020aa5e <sfs_unmount+0x64>
ffffffffc020aa18:	7d08                	ld	a0,56(a0)
ffffffffc020aa1a:	73a000ef          	jal	ra,ffffffffc020b154 <bitmap_destroy>
ffffffffc020aa1e:	6428                	ld	a0,72(s0)
ffffffffc020aa20:	c3ef70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020aa24:	7448                	ld	a0,168(s0)
ffffffffc020aa26:	c38f70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020aa2a:	8522                	mv	a0,s0
ffffffffc020aa2c:	c32f70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020aa30:	4501                	li	a0,0
ffffffffc020aa32:	60a2                	ld	ra,8(sp)
ffffffffc020aa34:	6402                	ld	s0,0(sp)
ffffffffc020aa36:	0141                	addi	sp,sp,16
ffffffffc020aa38:	8082                	ret
ffffffffc020aa3a:	5545                	li	a0,-15
ffffffffc020aa3c:	bfdd                	j	ffffffffc020aa32 <sfs_unmount+0x38>
ffffffffc020aa3e:	00004697          	auipc	a3,0x4
ffffffffc020aa42:	49a68693          	addi	a3,a3,1178 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020aa46:	00001617          	auipc	a2,0x1
ffffffffc020aa4a:	1d260613          	addi	a2,a2,466 # ffffffffc020bc18 <commands+0x250>
ffffffffc020aa4e:	04100593          	li	a1,65
ffffffffc020aa52:	00005517          	auipc	a0,0x5
ffffffffc020aa56:	88650513          	addi	a0,a0,-1914 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020aa5a:	fd4f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020aa5e:	00005697          	auipc	a3,0x5
ffffffffc020aa62:	89268693          	addi	a3,a3,-1902 # ffffffffc020f2f0 <sfs_node_fileops+0x98>
ffffffffc020aa66:	00001617          	auipc	a2,0x1
ffffffffc020aa6a:	1b260613          	addi	a2,a2,434 # ffffffffc020bc18 <commands+0x250>
ffffffffc020aa6e:	04500593          	li	a1,69
ffffffffc020aa72:	00005517          	auipc	a0,0x5
ffffffffc020aa76:	86650513          	addi	a0,a0,-1946 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020aa7a:	fb4f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020aa7e <sfs_cleanup>:
ffffffffc020aa7e:	1101                	addi	sp,sp,-32
ffffffffc020aa80:	ec06                	sd	ra,24(sp)
ffffffffc020aa82:	e822                	sd	s0,16(sp)
ffffffffc020aa84:	e426                	sd	s1,8(sp)
ffffffffc020aa86:	e04a                	sd	s2,0(sp)
ffffffffc020aa88:	c525                	beqz	a0,ffffffffc020aaf0 <sfs_cleanup+0x72>
ffffffffc020aa8a:	0b052783          	lw	a5,176(a0)
ffffffffc020aa8e:	84aa                	mv	s1,a0
ffffffffc020aa90:	e3a5                	bnez	a5,ffffffffc020aaf0 <sfs_cleanup+0x72>
ffffffffc020aa92:	4158                	lw	a4,4(a0)
ffffffffc020aa94:	4514                	lw	a3,8(a0)
ffffffffc020aa96:	00c50913          	addi	s2,a0,12
ffffffffc020aa9a:	85ca                	mv	a1,s2
ffffffffc020aa9c:	40d7063b          	subw	a2,a4,a3
ffffffffc020aaa0:	00005517          	auipc	a0,0x5
ffffffffc020aaa4:	86850513          	addi	a0,a0,-1944 # ffffffffc020f308 <sfs_node_fileops+0xb0>
ffffffffc020aaa8:	e82f50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020aaac:	02000413          	li	s0,32
ffffffffc020aab0:	a019                	j	ffffffffc020aab6 <sfs_cleanup+0x38>
ffffffffc020aab2:	347d                	addiw	s0,s0,-1
ffffffffc020aab4:	c819                	beqz	s0,ffffffffc020aaca <sfs_cleanup+0x4c>
ffffffffc020aab6:	7cdc                	ld	a5,184(s1)
ffffffffc020aab8:	8526                	mv	a0,s1
ffffffffc020aaba:	9782                	jalr	a5
ffffffffc020aabc:	f97d                	bnez	a0,ffffffffc020aab2 <sfs_cleanup+0x34>
ffffffffc020aabe:	60e2                	ld	ra,24(sp)
ffffffffc020aac0:	6442                	ld	s0,16(sp)
ffffffffc020aac2:	64a2                	ld	s1,8(sp)
ffffffffc020aac4:	6902                	ld	s2,0(sp)
ffffffffc020aac6:	6105                	addi	sp,sp,32
ffffffffc020aac8:	8082                	ret
ffffffffc020aaca:	6442                	ld	s0,16(sp)
ffffffffc020aacc:	60e2                	ld	ra,24(sp)
ffffffffc020aace:	64a2                	ld	s1,8(sp)
ffffffffc020aad0:	86ca                	mv	a3,s2
ffffffffc020aad2:	6902                	ld	s2,0(sp)
ffffffffc020aad4:	872a                	mv	a4,a0
ffffffffc020aad6:	00005617          	auipc	a2,0x5
ffffffffc020aada:	85260613          	addi	a2,a2,-1966 # ffffffffc020f328 <sfs_node_fileops+0xd0>
ffffffffc020aade:	05f00593          	li	a1,95
ffffffffc020aae2:	00004517          	auipc	a0,0x4
ffffffffc020aae6:	7f650513          	addi	a0,a0,2038 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020aaea:	6105                	addi	sp,sp,32
ffffffffc020aaec:	faaf506f          	j	ffffffffc0200296 <__warn>
ffffffffc020aaf0:	00004697          	auipc	a3,0x4
ffffffffc020aaf4:	3e868693          	addi	a3,a3,1000 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020aaf8:	00001617          	auipc	a2,0x1
ffffffffc020aafc:	12060613          	addi	a2,a2,288 # ffffffffc020bc18 <commands+0x250>
ffffffffc020ab00:	05400593          	li	a1,84
ffffffffc020ab04:	00004517          	auipc	a0,0x4
ffffffffc020ab08:	7d450513          	addi	a0,a0,2004 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020ab0c:	f22f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ab10 <sfs_sync>:
ffffffffc020ab10:	7179                	addi	sp,sp,-48
ffffffffc020ab12:	f406                	sd	ra,40(sp)
ffffffffc020ab14:	f022                	sd	s0,32(sp)
ffffffffc020ab16:	ec26                	sd	s1,24(sp)
ffffffffc020ab18:	e84a                	sd	s2,16(sp)
ffffffffc020ab1a:	e44e                	sd	s3,8(sp)
ffffffffc020ab1c:	e052                	sd	s4,0(sp)
ffffffffc020ab1e:	cd4d                	beqz	a0,ffffffffc020abd8 <sfs_sync+0xc8>
ffffffffc020ab20:	0b052783          	lw	a5,176(a0)
ffffffffc020ab24:	8a2a                	mv	s4,a0
ffffffffc020ab26:	ebcd                	bnez	a5,ffffffffc020abd8 <sfs_sync+0xc8>
ffffffffc020ab28:	83bfe0ef          	jal	ra,ffffffffc0209362 <lock_sfs_fs>
ffffffffc020ab2c:	0a0a3403          	ld	s0,160(s4)
ffffffffc020ab30:	098a0913          	addi	s2,s4,152
ffffffffc020ab34:	02890763          	beq	s2,s0,ffffffffc020ab62 <sfs_sync+0x52>
ffffffffc020ab38:	00003997          	auipc	s3,0x3
ffffffffc020ab3c:	a4898993          	addi	s3,s3,-1464 # ffffffffc020d580 <default_pmm_manager+0xb58>
ffffffffc020ab40:	7c1c                	ld	a5,56(s0)
ffffffffc020ab42:	fc840493          	addi	s1,s0,-56
ffffffffc020ab46:	cbb5                	beqz	a5,ffffffffc020abba <sfs_sync+0xaa>
ffffffffc020ab48:	7b9c                	ld	a5,48(a5)
ffffffffc020ab4a:	cba5                	beqz	a5,ffffffffc020abba <sfs_sync+0xaa>
ffffffffc020ab4c:	85ce                	mv	a1,s3
ffffffffc020ab4e:	8526                	mv	a0,s1
ffffffffc020ab50:	801fd0ef          	jal	ra,ffffffffc0208350 <inode_check>
ffffffffc020ab54:	7c1c                	ld	a5,56(s0)
ffffffffc020ab56:	8526                	mv	a0,s1
ffffffffc020ab58:	7b9c                	ld	a5,48(a5)
ffffffffc020ab5a:	9782                	jalr	a5
ffffffffc020ab5c:	6400                	ld	s0,8(s0)
ffffffffc020ab5e:	fe8911e3          	bne	s2,s0,ffffffffc020ab40 <sfs_sync+0x30>
ffffffffc020ab62:	8552                	mv	a0,s4
ffffffffc020ab64:	80ffe0ef          	jal	ra,ffffffffc0209372 <unlock_sfs_fs>
ffffffffc020ab68:	040a3783          	ld	a5,64(s4)
ffffffffc020ab6c:	4501                	li	a0,0
ffffffffc020ab6e:	eb89                	bnez	a5,ffffffffc020ab80 <sfs_sync+0x70>
ffffffffc020ab70:	70a2                	ld	ra,40(sp)
ffffffffc020ab72:	7402                	ld	s0,32(sp)
ffffffffc020ab74:	64e2                	ld	s1,24(sp)
ffffffffc020ab76:	6942                	ld	s2,16(sp)
ffffffffc020ab78:	69a2                	ld	s3,8(sp)
ffffffffc020ab7a:	6a02                	ld	s4,0(sp)
ffffffffc020ab7c:	6145                	addi	sp,sp,48
ffffffffc020ab7e:	8082                	ret
ffffffffc020ab80:	040a3023          	sd	zero,64(s4)
ffffffffc020ab84:	8552                	mv	a0,s4
ffffffffc020ab86:	ec0fe0ef          	jal	ra,ffffffffc0209246 <sfs_sync_super>
ffffffffc020ab8a:	cd01                	beqz	a0,ffffffffc020aba2 <sfs_sync+0x92>
ffffffffc020ab8c:	70a2                	ld	ra,40(sp)
ffffffffc020ab8e:	7402                	ld	s0,32(sp)
ffffffffc020ab90:	4785                	li	a5,1
ffffffffc020ab92:	04fa3023          	sd	a5,64(s4)
ffffffffc020ab96:	64e2                	ld	s1,24(sp)
ffffffffc020ab98:	6942                	ld	s2,16(sp)
ffffffffc020ab9a:	69a2                	ld	s3,8(sp)
ffffffffc020ab9c:	6a02                	ld	s4,0(sp)
ffffffffc020ab9e:	6145                	addi	sp,sp,48
ffffffffc020aba0:	8082                	ret
ffffffffc020aba2:	8552                	mv	a0,s4
ffffffffc020aba4:	ee8fe0ef          	jal	ra,ffffffffc020928c <sfs_sync_freemap>
ffffffffc020aba8:	f175                	bnez	a0,ffffffffc020ab8c <sfs_sync+0x7c>
ffffffffc020abaa:	70a2                	ld	ra,40(sp)
ffffffffc020abac:	7402                	ld	s0,32(sp)
ffffffffc020abae:	64e2                	ld	s1,24(sp)
ffffffffc020abb0:	6942                	ld	s2,16(sp)
ffffffffc020abb2:	69a2                	ld	s3,8(sp)
ffffffffc020abb4:	6a02                	ld	s4,0(sp)
ffffffffc020abb6:	6145                	addi	sp,sp,48
ffffffffc020abb8:	8082                	ret
ffffffffc020abba:	00003697          	auipc	a3,0x3
ffffffffc020abbe:	97668693          	addi	a3,a3,-1674 # ffffffffc020d530 <default_pmm_manager+0xb08>
ffffffffc020abc2:	00001617          	auipc	a2,0x1
ffffffffc020abc6:	05660613          	addi	a2,a2,86 # ffffffffc020bc18 <commands+0x250>
ffffffffc020abca:	45ed                	li	a1,27
ffffffffc020abcc:	00004517          	auipc	a0,0x4
ffffffffc020abd0:	70c50513          	addi	a0,a0,1804 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020abd4:	e5af50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020abd8:	00004697          	auipc	a3,0x4
ffffffffc020abdc:	30068693          	addi	a3,a3,768 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020abe0:	00001617          	auipc	a2,0x1
ffffffffc020abe4:	03860613          	addi	a2,a2,56 # ffffffffc020bc18 <commands+0x250>
ffffffffc020abe8:	45d5                	li	a1,21
ffffffffc020abea:	00004517          	auipc	a0,0x4
ffffffffc020abee:	6ee50513          	addi	a0,a0,1774 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020abf2:	e3cf50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020abf6 <sfs_get_root>:
ffffffffc020abf6:	1101                	addi	sp,sp,-32
ffffffffc020abf8:	ec06                	sd	ra,24(sp)
ffffffffc020abfa:	cd09                	beqz	a0,ffffffffc020ac14 <sfs_get_root+0x1e>
ffffffffc020abfc:	0b052783          	lw	a5,176(a0)
ffffffffc020ac00:	eb91                	bnez	a5,ffffffffc020ac14 <sfs_get_root+0x1e>
ffffffffc020ac02:	4605                	li	a2,1
ffffffffc020ac04:	002c                	addi	a1,sp,8
ffffffffc020ac06:	fa4ff0ef          	jal	ra,ffffffffc020a3aa <sfs_load_inode>
ffffffffc020ac0a:	e50d                	bnez	a0,ffffffffc020ac34 <sfs_get_root+0x3e>
ffffffffc020ac0c:	60e2                	ld	ra,24(sp)
ffffffffc020ac0e:	6522                	ld	a0,8(sp)
ffffffffc020ac10:	6105                	addi	sp,sp,32
ffffffffc020ac12:	8082                	ret
ffffffffc020ac14:	00004697          	auipc	a3,0x4
ffffffffc020ac18:	2c468693          	addi	a3,a3,708 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020ac1c:	00001617          	auipc	a2,0x1
ffffffffc020ac20:	ffc60613          	addi	a2,a2,-4 # ffffffffc020bc18 <commands+0x250>
ffffffffc020ac24:	03600593          	li	a1,54
ffffffffc020ac28:	00004517          	auipc	a0,0x4
ffffffffc020ac2c:	6b050513          	addi	a0,a0,1712 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020ac30:	dfef50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020ac34:	86aa                	mv	a3,a0
ffffffffc020ac36:	00004617          	auipc	a2,0x4
ffffffffc020ac3a:	71260613          	addi	a2,a2,1810 # ffffffffc020f348 <sfs_node_fileops+0xf0>
ffffffffc020ac3e:	03700593          	li	a1,55
ffffffffc020ac42:	00004517          	auipc	a0,0x4
ffffffffc020ac46:	69650513          	addi	a0,a0,1686 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020ac4a:	de4f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ac4e <sfs_do_mount>:
ffffffffc020ac4e:	6518                	ld	a4,8(a0)
ffffffffc020ac50:	7171                	addi	sp,sp,-176
ffffffffc020ac52:	f506                	sd	ra,168(sp)
ffffffffc020ac54:	f122                	sd	s0,160(sp)
ffffffffc020ac56:	ed26                	sd	s1,152(sp)
ffffffffc020ac58:	e94a                	sd	s2,144(sp)
ffffffffc020ac5a:	e54e                	sd	s3,136(sp)
ffffffffc020ac5c:	e152                	sd	s4,128(sp)
ffffffffc020ac5e:	fcd6                	sd	s5,120(sp)
ffffffffc020ac60:	f8da                	sd	s6,112(sp)
ffffffffc020ac62:	f4de                	sd	s7,104(sp)
ffffffffc020ac64:	f0e2                	sd	s8,96(sp)
ffffffffc020ac66:	ece6                	sd	s9,88(sp)
ffffffffc020ac68:	e8ea                	sd	s10,80(sp)
ffffffffc020ac6a:	e4ee                	sd	s11,72(sp)
ffffffffc020ac6c:	6785                	lui	a5,0x1
ffffffffc020ac6e:	24f71663          	bne	a4,a5,ffffffffc020aeba <sfs_do_mount+0x26c>
ffffffffc020ac72:	892a                	mv	s2,a0
ffffffffc020ac74:	4501                	li	a0,0
ffffffffc020ac76:	8aae                	mv	s5,a1
ffffffffc020ac78:	8d9fd0ef          	jal	ra,ffffffffc0208550 <__alloc_fs>
ffffffffc020ac7c:	842a                	mv	s0,a0
ffffffffc020ac7e:	24050463          	beqz	a0,ffffffffc020aec6 <sfs_do_mount+0x278>
ffffffffc020ac82:	0b052b03          	lw	s6,176(a0)
ffffffffc020ac86:	260b1263          	bnez	s6,ffffffffc020aeea <sfs_do_mount+0x29c>
ffffffffc020ac8a:	03253823          	sd	s2,48(a0)
ffffffffc020ac8e:	6505                	lui	a0,0x1
ffffffffc020ac90:	91ef70ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020ac94:	e428                	sd	a0,72(s0)
ffffffffc020ac96:	84aa                	mv	s1,a0
ffffffffc020ac98:	16050363          	beqz	a0,ffffffffc020adfe <sfs_do_mount+0x1b0>
ffffffffc020ac9c:	85aa                	mv	a1,a0
ffffffffc020ac9e:	4681                	li	a3,0
ffffffffc020aca0:	6605                	lui	a2,0x1
ffffffffc020aca2:	1008                	addi	a0,sp,32
ffffffffc020aca4:	b21fa0ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc020aca8:	02093783          	ld	a5,32(s2)
ffffffffc020acac:	85aa                	mv	a1,a0
ffffffffc020acae:	4601                	li	a2,0
ffffffffc020acb0:	854a                	mv	a0,s2
ffffffffc020acb2:	9782                	jalr	a5
ffffffffc020acb4:	8a2a                	mv	s4,a0
ffffffffc020acb6:	10051e63          	bnez	a0,ffffffffc020add2 <sfs_do_mount+0x184>
ffffffffc020acba:	408c                	lw	a1,0(s1)
ffffffffc020acbc:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc020acc0:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc020acc4:	14c59863          	bne	a1,a2,ffffffffc020ae14 <sfs_do_mount+0x1c6>
ffffffffc020acc8:	40dc                	lw	a5,4(s1)
ffffffffc020acca:	00093603          	ld	a2,0(s2)
ffffffffc020acce:	02079713          	slli	a4,a5,0x20
ffffffffc020acd2:	9301                	srli	a4,a4,0x20
ffffffffc020acd4:	12e66763          	bltu	a2,a4,ffffffffc020ae02 <sfs_do_mount+0x1b4>
ffffffffc020acd8:	020485a3          	sb	zero,43(s1)
ffffffffc020acdc:	0084af03          	lw	t5,8(s1)
ffffffffc020ace0:	00c4ae83          	lw	t4,12(s1)
ffffffffc020ace4:	0104ae03          	lw	t3,16(s1)
ffffffffc020ace8:	0144a303          	lw	t1,20(s1)
ffffffffc020acec:	0184a883          	lw	a7,24(s1)
ffffffffc020acf0:	01c4a803          	lw	a6,28(s1)
ffffffffc020acf4:	5090                	lw	a2,32(s1)
ffffffffc020acf6:	50d4                	lw	a3,36(s1)
ffffffffc020acf8:	5498                	lw	a4,40(s1)
ffffffffc020acfa:	6511                	lui	a0,0x4
ffffffffc020acfc:	c00c                	sw	a1,0(s0)
ffffffffc020acfe:	c05c                	sw	a5,4(s0)
ffffffffc020ad00:	01e42423          	sw	t5,8(s0)
ffffffffc020ad04:	01d42623          	sw	t4,12(s0)
ffffffffc020ad08:	01c42823          	sw	t3,16(s0)
ffffffffc020ad0c:	00642a23          	sw	t1,20(s0)
ffffffffc020ad10:	01142c23          	sw	a7,24(s0)
ffffffffc020ad14:	01042e23          	sw	a6,28(s0)
ffffffffc020ad18:	d010                	sw	a2,32(s0)
ffffffffc020ad1a:	d054                	sw	a3,36(s0)
ffffffffc020ad1c:	d418                	sw	a4,40(s0)
ffffffffc020ad1e:	890f70ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020ad22:	f448                	sd	a0,168(s0)
ffffffffc020ad24:	8c2a                	mv	s8,a0
ffffffffc020ad26:	18050c63          	beqz	a0,ffffffffc020aebe <sfs_do_mount+0x270>
ffffffffc020ad2a:	6711                	lui	a4,0x4
ffffffffc020ad2c:	87aa                	mv	a5,a0
ffffffffc020ad2e:	972a                	add	a4,a4,a0
ffffffffc020ad30:	e79c                	sd	a5,8(a5)
ffffffffc020ad32:	e39c                	sd	a5,0(a5)
ffffffffc020ad34:	07c1                	addi	a5,a5,16
ffffffffc020ad36:	fee79de3          	bne	a5,a4,ffffffffc020ad30 <sfs_do_mount+0xe2>
ffffffffc020ad3a:	0044eb83          	lwu	s7,4(s1)
ffffffffc020ad3e:	67a1                	lui	a5,0x8
ffffffffc020ad40:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020ad44:	9bce                	add	s7,s7,s3
ffffffffc020ad46:	77e1                	lui	a5,0xffff8
ffffffffc020ad48:	00fbfbb3          	and	s7,s7,a5
ffffffffc020ad4c:	2b81                	sext.w	s7,s7
ffffffffc020ad4e:	855e                	mv	a0,s7
ffffffffc020ad50:	20a000ef          	jal	ra,ffffffffc020af5a <bitmap_create>
ffffffffc020ad54:	fc08                	sd	a0,56(s0)
ffffffffc020ad56:	8d2a                	mv	s10,a0
ffffffffc020ad58:	14050f63          	beqz	a0,ffffffffc020aeb6 <sfs_do_mount+0x268>
ffffffffc020ad5c:	0044e783          	lwu	a5,4(s1)
ffffffffc020ad60:	082c                	addi	a1,sp,24
ffffffffc020ad62:	97ce                	add	a5,a5,s3
ffffffffc020ad64:	00f7d713          	srli	a4,a5,0xf
ffffffffc020ad68:	e43a                	sd	a4,8(sp)
ffffffffc020ad6a:	40f7d993          	srai	s3,a5,0xf
ffffffffc020ad6e:	400000ef          	jal	ra,ffffffffc020b16e <bitmap_getdata>
ffffffffc020ad72:	14050c63          	beqz	a0,ffffffffc020aeca <sfs_do_mount+0x27c>
ffffffffc020ad76:	00c9979b          	slliw	a5,s3,0xc
ffffffffc020ad7a:	66e2                	ld	a3,24(sp)
ffffffffc020ad7c:	1782                	slli	a5,a5,0x20
ffffffffc020ad7e:	9381                	srli	a5,a5,0x20
ffffffffc020ad80:	14d79563          	bne	a5,a3,ffffffffc020aeca <sfs_do_mount+0x27c>
ffffffffc020ad84:	6722                	ld	a4,8(sp)
ffffffffc020ad86:	6d89                	lui	s11,0x2
ffffffffc020ad88:	89aa                	mv	s3,a0
ffffffffc020ad8a:	00c71c93          	slli	s9,a4,0xc
ffffffffc020ad8e:	9caa                	add	s9,s9,a0
ffffffffc020ad90:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020ad94:	e711                	bnez	a4,ffffffffc020ada0 <sfs_do_mount+0x152>
ffffffffc020ad96:	a079                	j	ffffffffc020ae24 <sfs_do_mount+0x1d6>
ffffffffc020ad98:	6785                	lui	a5,0x1
ffffffffc020ad9a:	99be                	add	s3,s3,a5
ffffffffc020ad9c:	093c8463          	beq	s9,s3,ffffffffc020ae24 <sfs_do_mount+0x1d6>
ffffffffc020ada0:	013d86bb          	addw	a3,s11,s3
ffffffffc020ada4:	1682                	slli	a3,a3,0x20
ffffffffc020ada6:	6605                	lui	a2,0x1
ffffffffc020ada8:	85ce                	mv	a1,s3
ffffffffc020adaa:	9281                	srli	a3,a3,0x20
ffffffffc020adac:	1008                	addi	a0,sp,32
ffffffffc020adae:	a17fa0ef          	jal	ra,ffffffffc02057c4 <iobuf_init>
ffffffffc020adb2:	02093783          	ld	a5,32(s2)
ffffffffc020adb6:	85aa                	mv	a1,a0
ffffffffc020adb8:	4601                	li	a2,0
ffffffffc020adba:	854a                	mv	a0,s2
ffffffffc020adbc:	9782                	jalr	a5
ffffffffc020adbe:	dd69                	beqz	a0,ffffffffc020ad98 <sfs_do_mount+0x14a>
ffffffffc020adc0:	e42a                	sd	a0,8(sp)
ffffffffc020adc2:	856a                	mv	a0,s10
ffffffffc020adc4:	390000ef          	jal	ra,ffffffffc020b154 <bitmap_destroy>
ffffffffc020adc8:	67a2                	ld	a5,8(sp)
ffffffffc020adca:	8a3e                	mv	s4,a5
ffffffffc020adcc:	8562                	mv	a0,s8
ffffffffc020adce:	890f70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020add2:	8526                	mv	a0,s1
ffffffffc020add4:	88af70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020add8:	8522                	mv	a0,s0
ffffffffc020adda:	884f70ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020adde:	70aa                	ld	ra,168(sp)
ffffffffc020ade0:	740a                	ld	s0,160(sp)
ffffffffc020ade2:	64ea                	ld	s1,152(sp)
ffffffffc020ade4:	694a                	ld	s2,144(sp)
ffffffffc020ade6:	69aa                	ld	s3,136(sp)
ffffffffc020ade8:	7ae6                	ld	s5,120(sp)
ffffffffc020adea:	7b46                	ld	s6,112(sp)
ffffffffc020adec:	7ba6                	ld	s7,104(sp)
ffffffffc020adee:	7c06                	ld	s8,96(sp)
ffffffffc020adf0:	6ce6                	ld	s9,88(sp)
ffffffffc020adf2:	6d46                	ld	s10,80(sp)
ffffffffc020adf4:	6da6                	ld	s11,72(sp)
ffffffffc020adf6:	8552                	mv	a0,s4
ffffffffc020adf8:	6a0a                	ld	s4,128(sp)
ffffffffc020adfa:	614d                	addi	sp,sp,176
ffffffffc020adfc:	8082                	ret
ffffffffc020adfe:	5a71                	li	s4,-4
ffffffffc020ae00:	bfe1                	j	ffffffffc020add8 <sfs_do_mount+0x18a>
ffffffffc020ae02:	85be                	mv	a1,a5
ffffffffc020ae04:	00004517          	auipc	a0,0x4
ffffffffc020ae08:	59c50513          	addi	a0,a0,1436 # ffffffffc020f3a0 <sfs_node_fileops+0x148>
ffffffffc020ae0c:	b1ef50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020ae10:	5a75                	li	s4,-3
ffffffffc020ae12:	b7c1                	j	ffffffffc020add2 <sfs_do_mount+0x184>
ffffffffc020ae14:	00004517          	auipc	a0,0x4
ffffffffc020ae18:	55450513          	addi	a0,a0,1364 # ffffffffc020f368 <sfs_node_fileops+0x110>
ffffffffc020ae1c:	b0ef50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020ae20:	5a75                	li	s4,-3
ffffffffc020ae22:	bf45                	j	ffffffffc020add2 <sfs_do_mount+0x184>
ffffffffc020ae24:	00442903          	lw	s2,4(s0)
ffffffffc020ae28:	4481                	li	s1,0
ffffffffc020ae2a:	080b8c63          	beqz	s7,ffffffffc020aec2 <sfs_do_mount+0x274>
ffffffffc020ae2e:	85a6                	mv	a1,s1
ffffffffc020ae30:	856a                	mv	a0,s10
ffffffffc020ae32:	2a8000ef          	jal	ra,ffffffffc020b0da <bitmap_test>
ffffffffc020ae36:	c111                	beqz	a0,ffffffffc020ae3a <sfs_do_mount+0x1ec>
ffffffffc020ae38:	2b05                	addiw	s6,s6,1
ffffffffc020ae3a:	2485                	addiw	s1,s1,1
ffffffffc020ae3c:	fe9b99e3          	bne	s7,s1,ffffffffc020ae2e <sfs_do_mount+0x1e0>
ffffffffc020ae40:	441c                	lw	a5,8(s0)
ffffffffc020ae42:	0d679463          	bne	a5,s6,ffffffffc020af0a <sfs_do_mount+0x2bc>
ffffffffc020ae46:	4585                	li	a1,1
ffffffffc020ae48:	05040513          	addi	a0,s0,80
ffffffffc020ae4c:	04043023          	sd	zero,64(s0)
ffffffffc020ae50:	987f90ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc020ae54:	4585                	li	a1,1
ffffffffc020ae56:	06840513          	addi	a0,s0,104
ffffffffc020ae5a:	97df90ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc020ae5e:	4585                	li	a1,1
ffffffffc020ae60:	08040513          	addi	a0,s0,128
ffffffffc020ae64:	973f90ef          	jal	ra,ffffffffc02047d6 <sem_init>
ffffffffc020ae68:	09840793          	addi	a5,s0,152
ffffffffc020ae6c:	f05c                	sd	a5,160(s0)
ffffffffc020ae6e:	ec5c                	sd	a5,152(s0)
ffffffffc020ae70:	874a                	mv	a4,s2
ffffffffc020ae72:	86da                	mv	a3,s6
ffffffffc020ae74:	4169063b          	subw	a2,s2,s6
ffffffffc020ae78:	00c40593          	addi	a1,s0,12
ffffffffc020ae7c:	00004517          	auipc	a0,0x4
ffffffffc020ae80:	5b450513          	addi	a0,a0,1460 # ffffffffc020f430 <sfs_node_fileops+0x1d8>
ffffffffc020ae84:	aa6f50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020ae88:	00000797          	auipc	a5,0x0
ffffffffc020ae8c:	c8878793          	addi	a5,a5,-888 # ffffffffc020ab10 <sfs_sync>
ffffffffc020ae90:	fc5c                	sd	a5,184(s0)
ffffffffc020ae92:	00000797          	auipc	a5,0x0
ffffffffc020ae96:	d6478793          	addi	a5,a5,-668 # ffffffffc020abf6 <sfs_get_root>
ffffffffc020ae9a:	e07c                	sd	a5,192(s0)
ffffffffc020ae9c:	00000797          	auipc	a5,0x0
ffffffffc020aea0:	b5e78793          	addi	a5,a5,-1186 # ffffffffc020a9fa <sfs_unmount>
ffffffffc020aea4:	e47c                	sd	a5,200(s0)
ffffffffc020aea6:	00000797          	auipc	a5,0x0
ffffffffc020aeaa:	bd878793          	addi	a5,a5,-1064 # ffffffffc020aa7e <sfs_cleanup>
ffffffffc020aeae:	e87c                	sd	a5,208(s0)
ffffffffc020aeb0:	008ab023          	sd	s0,0(s5)
ffffffffc020aeb4:	b72d                	j	ffffffffc020adde <sfs_do_mount+0x190>
ffffffffc020aeb6:	5a71                	li	s4,-4
ffffffffc020aeb8:	bf11                	j	ffffffffc020adcc <sfs_do_mount+0x17e>
ffffffffc020aeba:	5a49                	li	s4,-14
ffffffffc020aebc:	b70d                	j	ffffffffc020adde <sfs_do_mount+0x190>
ffffffffc020aebe:	5a71                	li	s4,-4
ffffffffc020aec0:	bf09                	j	ffffffffc020add2 <sfs_do_mount+0x184>
ffffffffc020aec2:	4b01                	li	s6,0
ffffffffc020aec4:	bfb5                	j	ffffffffc020ae40 <sfs_do_mount+0x1f2>
ffffffffc020aec6:	5a71                	li	s4,-4
ffffffffc020aec8:	bf19                	j	ffffffffc020adde <sfs_do_mount+0x190>
ffffffffc020aeca:	00004697          	auipc	a3,0x4
ffffffffc020aece:	50668693          	addi	a3,a3,1286 # ffffffffc020f3d0 <sfs_node_fileops+0x178>
ffffffffc020aed2:	00001617          	auipc	a2,0x1
ffffffffc020aed6:	d4660613          	addi	a2,a2,-698 # ffffffffc020bc18 <commands+0x250>
ffffffffc020aeda:	08300593          	li	a1,131
ffffffffc020aede:	00004517          	auipc	a0,0x4
ffffffffc020aee2:	3fa50513          	addi	a0,a0,1018 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020aee6:	b48f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020aeea:	00004697          	auipc	a3,0x4
ffffffffc020aeee:	fee68693          	addi	a3,a3,-18 # ffffffffc020eed8 <dev_node_ops+0x1b8>
ffffffffc020aef2:	00001617          	auipc	a2,0x1
ffffffffc020aef6:	d2660613          	addi	a2,a2,-730 # ffffffffc020bc18 <commands+0x250>
ffffffffc020aefa:	0a300593          	li	a1,163
ffffffffc020aefe:	00004517          	auipc	a0,0x4
ffffffffc020af02:	3da50513          	addi	a0,a0,986 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020af06:	b28f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020af0a:	00004697          	auipc	a3,0x4
ffffffffc020af0e:	4f668693          	addi	a3,a3,1270 # ffffffffc020f400 <sfs_node_fileops+0x1a8>
ffffffffc020af12:	00001617          	auipc	a2,0x1
ffffffffc020af16:	d0660613          	addi	a2,a2,-762 # ffffffffc020bc18 <commands+0x250>
ffffffffc020af1a:	0e000593          	li	a1,224
ffffffffc020af1e:	00004517          	auipc	a0,0x4
ffffffffc020af22:	3ba50513          	addi	a0,a0,954 # ffffffffc020f2d8 <sfs_node_fileops+0x80>
ffffffffc020af26:	b08f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020af2a <sfs_mount>:
ffffffffc020af2a:	00000597          	auipc	a1,0x0
ffffffffc020af2e:	d2458593          	addi	a1,a1,-732 # ffffffffc020ac4e <sfs_do_mount>
ffffffffc020af32:	cd7fc06f          	j	ffffffffc0207c08 <vfs_mount>

ffffffffc020af36 <bitmap_translate.part.0>:
ffffffffc020af36:	1141                	addi	sp,sp,-16
ffffffffc020af38:	00004697          	auipc	a3,0x4
ffffffffc020af3c:	51868693          	addi	a3,a3,1304 # ffffffffc020f450 <sfs_node_fileops+0x1f8>
ffffffffc020af40:	00001617          	auipc	a2,0x1
ffffffffc020af44:	cd860613          	addi	a2,a2,-808 # ffffffffc020bc18 <commands+0x250>
ffffffffc020af48:	04c00593          	li	a1,76
ffffffffc020af4c:	00004517          	auipc	a0,0x4
ffffffffc020af50:	51c50513          	addi	a0,a0,1308 # ffffffffc020f468 <sfs_node_fileops+0x210>
ffffffffc020af54:	e406                	sd	ra,8(sp)
ffffffffc020af56:	ad8f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020af5a <bitmap_create>:
ffffffffc020af5a:	7139                	addi	sp,sp,-64
ffffffffc020af5c:	fc06                	sd	ra,56(sp)
ffffffffc020af5e:	f822                	sd	s0,48(sp)
ffffffffc020af60:	f426                	sd	s1,40(sp)
ffffffffc020af62:	f04a                	sd	s2,32(sp)
ffffffffc020af64:	ec4e                	sd	s3,24(sp)
ffffffffc020af66:	e852                	sd	s4,16(sp)
ffffffffc020af68:	e456                	sd	s5,8(sp)
ffffffffc020af6a:	c14d                	beqz	a0,ffffffffc020b00c <bitmap_create+0xb2>
ffffffffc020af6c:	842a                	mv	s0,a0
ffffffffc020af6e:	4541                	li	a0,16
ffffffffc020af70:	e3ff60ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020af74:	84aa                	mv	s1,a0
ffffffffc020af76:	cd25                	beqz	a0,ffffffffc020afee <bitmap_create+0x94>
ffffffffc020af78:	02041a13          	slli	s4,s0,0x20
ffffffffc020af7c:	020a5a13          	srli	s4,s4,0x20
ffffffffc020af80:	01fa0793          	addi	a5,s4,31
ffffffffc020af84:	0057d993          	srli	s3,a5,0x5
ffffffffc020af88:	00299a93          	slli	s5,s3,0x2
ffffffffc020af8c:	8556                	mv	a0,s5
ffffffffc020af8e:	894e                	mv	s2,s3
ffffffffc020af90:	e1ff60ef          	jal	ra,ffffffffc0201dae <kmalloc>
ffffffffc020af94:	c53d                	beqz	a0,ffffffffc020b002 <bitmap_create+0xa8>
ffffffffc020af96:	0134a223          	sw	s3,4(s1)
ffffffffc020af9a:	c080                	sw	s0,0(s1)
ffffffffc020af9c:	8656                	mv	a2,s5
ffffffffc020af9e:	0ff00593          	li	a1,255
ffffffffc020afa2:	27c000ef          	jal	ra,ffffffffc020b21e <memset>
ffffffffc020afa6:	e488                	sd	a0,8(s1)
ffffffffc020afa8:	0996                	slli	s3,s3,0x5
ffffffffc020afaa:	053a0263          	beq	s4,s3,ffffffffc020afee <bitmap_create+0x94>
ffffffffc020afae:	fff9079b          	addiw	a5,s2,-1
ffffffffc020afb2:	0057969b          	slliw	a3,a5,0x5
ffffffffc020afb6:	0054561b          	srliw	a2,s0,0x5
ffffffffc020afba:	40d4073b          	subw	a4,s0,a3
ffffffffc020afbe:	0054541b          	srliw	s0,s0,0x5
ffffffffc020afc2:	08f61463          	bne	a2,a5,ffffffffc020b04a <bitmap_create+0xf0>
ffffffffc020afc6:	fff7069b          	addiw	a3,a4,-1
ffffffffc020afca:	47f9                	li	a5,30
ffffffffc020afcc:	04d7ef63          	bltu	a5,a3,ffffffffc020b02a <bitmap_create+0xd0>
ffffffffc020afd0:	1402                	slli	s0,s0,0x20
ffffffffc020afd2:	8079                	srli	s0,s0,0x1e
ffffffffc020afd4:	9522                	add	a0,a0,s0
ffffffffc020afd6:	411c                	lw	a5,0(a0)
ffffffffc020afd8:	4585                	li	a1,1
ffffffffc020afda:	02000613          	li	a2,32
ffffffffc020afde:	00e596bb          	sllw	a3,a1,a4
ffffffffc020afe2:	8fb5                	xor	a5,a5,a3
ffffffffc020afe4:	2705                	addiw	a4,a4,1
ffffffffc020afe6:	2781                	sext.w	a5,a5
ffffffffc020afe8:	fec71be3          	bne	a4,a2,ffffffffc020afde <bitmap_create+0x84>
ffffffffc020afec:	c11c                	sw	a5,0(a0)
ffffffffc020afee:	70e2                	ld	ra,56(sp)
ffffffffc020aff0:	7442                	ld	s0,48(sp)
ffffffffc020aff2:	7902                	ld	s2,32(sp)
ffffffffc020aff4:	69e2                	ld	s3,24(sp)
ffffffffc020aff6:	6a42                	ld	s4,16(sp)
ffffffffc020aff8:	6aa2                	ld	s5,8(sp)
ffffffffc020affa:	8526                	mv	a0,s1
ffffffffc020affc:	74a2                	ld	s1,40(sp)
ffffffffc020affe:	6121                	addi	sp,sp,64
ffffffffc020b000:	8082                	ret
ffffffffc020b002:	8526                	mv	a0,s1
ffffffffc020b004:	e5bf60ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020b008:	4481                	li	s1,0
ffffffffc020b00a:	b7d5                	j	ffffffffc020afee <bitmap_create+0x94>
ffffffffc020b00c:	00004697          	auipc	a3,0x4
ffffffffc020b010:	47468693          	addi	a3,a3,1140 # ffffffffc020f480 <sfs_node_fileops+0x228>
ffffffffc020b014:	00001617          	auipc	a2,0x1
ffffffffc020b018:	c0460613          	addi	a2,a2,-1020 # ffffffffc020bc18 <commands+0x250>
ffffffffc020b01c:	45d5                	li	a1,21
ffffffffc020b01e:	00004517          	auipc	a0,0x4
ffffffffc020b022:	44a50513          	addi	a0,a0,1098 # ffffffffc020f468 <sfs_node_fileops+0x210>
ffffffffc020b026:	a08f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020b02a:	00004697          	auipc	a3,0x4
ffffffffc020b02e:	49668693          	addi	a3,a3,1174 # ffffffffc020f4c0 <sfs_node_fileops+0x268>
ffffffffc020b032:	00001617          	auipc	a2,0x1
ffffffffc020b036:	be660613          	addi	a2,a2,-1050 # ffffffffc020bc18 <commands+0x250>
ffffffffc020b03a:	02b00593          	li	a1,43
ffffffffc020b03e:	00004517          	auipc	a0,0x4
ffffffffc020b042:	42a50513          	addi	a0,a0,1066 # ffffffffc020f468 <sfs_node_fileops+0x210>
ffffffffc020b046:	9e8f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020b04a:	00004697          	auipc	a3,0x4
ffffffffc020b04e:	45e68693          	addi	a3,a3,1118 # ffffffffc020f4a8 <sfs_node_fileops+0x250>
ffffffffc020b052:	00001617          	auipc	a2,0x1
ffffffffc020b056:	bc660613          	addi	a2,a2,-1082 # ffffffffc020bc18 <commands+0x250>
ffffffffc020b05a:	02a00593          	li	a1,42
ffffffffc020b05e:	00004517          	auipc	a0,0x4
ffffffffc020b062:	40a50513          	addi	a0,a0,1034 # ffffffffc020f468 <sfs_node_fileops+0x210>
ffffffffc020b066:	9c8f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020b06a <bitmap_alloc>:
ffffffffc020b06a:	4150                	lw	a2,4(a0)
ffffffffc020b06c:	651c                	ld	a5,8(a0)
ffffffffc020b06e:	c231                	beqz	a2,ffffffffc020b0b2 <bitmap_alloc+0x48>
ffffffffc020b070:	4701                	li	a4,0
ffffffffc020b072:	a029                	j	ffffffffc020b07c <bitmap_alloc+0x12>
ffffffffc020b074:	2705                	addiw	a4,a4,1
ffffffffc020b076:	0791                	addi	a5,a5,4
ffffffffc020b078:	02e60d63          	beq	a2,a4,ffffffffc020b0b2 <bitmap_alloc+0x48>
ffffffffc020b07c:	4394                	lw	a3,0(a5)
ffffffffc020b07e:	dafd                	beqz	a3,ffffffffc020b074 <bitmap_alloc+0xa>
ffffffffc020b080:	4501                	li	a0,0
ffffffffc020b082:	4885                	li	a7,1
ffffffffc020b084:	8e36                	mv	t3,a3
ffffffffc020b086:	02000313          	li	t1,32
ffffffffc020b08a:	a021                	j	ffffffffc020b092 <bitmap_alloc+0x28>
ffffffffc020b08c:	2505                	addiw	a0,a0,1
ffffffffc020b08e:	02650463          	beq	a0,t1,ffffffffc020b0b6 <bitmap_alloc+0x4c>
ffffffffc020b092:	00a8983b          	sllw	a6,a7,a0
ffffffffc020b096:	0106f633          	and	a2,a3,a6
ffffffffc020b09a:	2601                	sext.w	a2,a2
ffffffffc020b09c:	da65                	beqz	a2,ffffffffc020b08c <bitmap_alloc+0x22>
ffffffffc020b09e:	010e4833          	xor	a6,t3,a6
ffffffffc020b0a2:	0057171b          	slliw	a4,a4,0x5
ffffffffc020b0a6:	9f29                	addw	a4,a4,a0
ffffffffc020b0a8:	0107a023          	sw	a6,0(a5)
ffffffffc020b0ac:	c198                	sw	a4,0(a1)
ffffffffc020b0ae:	4501                	li	a0,0
ffffffffc020b0b0:	8082                	ret
ffffffffc020b0b2:	5571                	li	a0,-4
ffffffffc020b0b4:	8082                	ret
ffffffffc020b0b6:	1141                	addi	sp,sp,-16
ffffffffc020b0b8:	00002697          	auipc	a3,0x2
ffffffffc020b0bc:	e1868693          	addi	a3,a3,-488 # ffffffffc020ced0 <default_pmm_manager+0x4a8>
ffffffffc020b0c0:	00001617          	auipc	a2,0x1
ffffffffc020b0c4:	b5860613          	addi	a2,a2,-1192 # ffffffffc020bc18 <commands+0x250>
ffffffffc020b0c8:	04300593          	li	a1,67
ffffffffc020b0cc:	00004517          	auipc	a0,0x4
ffffffffc020b0d0:	39c50513          	addi	a0,a0,924 # ffffffffc020f468 <sfs_node_fileops+0x210>
ffffffffc020b0d4:	e406                	sd	ra,8(sp)
ffffffffc020b0d6:	958f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020b0da <bitmap_test>:
ffffffffc020b0da:	411c                	lw	a5,0(a0)
ffffffffc020b0dc:	00f5ff63          	bgeu	a1,a5,ffffffffc020b0fa <bitmap_test+0x20>
ffffffffc020b0e0:	651c                	ld	a5,8(a0)
ffffffffc020b0e2:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020b0e6:	070a                	slli	a4,a4,0x2
ffffffffc020b0e8:	97ba                	add	a5,a5,a4
ffffffffc020b0ea:	4388                	lw	a0,0(a5)
ffffffffc020b0ec:	4785                	li	a5,1
ffffffffc020b0ee:	00b795bb          	sllw	a1,a5,a1
ffffffffc020b0f2:	8d6d                	and	a0,a0,a1
ffffffffc020b0f4:	1502                	slli	a0,a0,0x20
ffffffffc020b0f6:	9101                	srli	a0,a0,0x20
ffffffffc020b0f8:	8082                	ret
ffffffffc020b0fa:	1141                	addi	sp,sp,-16
ffffffffc020b0fc:	e406                	sd	ra,8(sp)
ffffffffc020b0fe:	e39ff0ef          	jal	ra,ffffffffc020af36 <bitmap_translate.part.0>

ffffffffc020b102 <bitmap_free>:
ffffffffc020b102:	411c                	lw	a5,0(a0)
ffffffffc020b104:	1141                	addi	sp,sp,-16
ffffffffc020b106:	e406                	sd	ra,8(sp)
ffffffffc020b108:	02f5f463          	bgeu	a1,a5,ffffffffc020b130 <bitmap_free+0x2e>
ffffffffc020b10c:	651c                	ld	a5,8(a0)
ffffffffc020b10e:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020b112:	070a                	slli	a4,a4,0x2
ffffffffc020b114:	97ba                	add	a5,a5,a4
ffffffffc020b116:	4398                	lw	a4,0(a5)
ffffffffc020b118:	4685                	li	a3,1
ffffffffc020b11a:	00b695bb          	sllw	a1,a3,a1
ffffffffc020b11e:	00b776b3          	and	a3,a4,a1
ffffffffc020b122:	2681                	sext.w	a3,a3
ffffffffc020b124:	ea81                	bnez	a3,ffffffffc020b134 <bitmap_free+0x32>
ffffffffc020b126:	60a2                	ld	ra,8(sp)
ffffffffc020b128:	8f4d                	or	a4,a4,a1
ffffffffc020b12a:	c398                	sw	a4,0(a5)
ffffffffc020b12c:	0141                	addi	sp,sp,16
ffffffffc020b12e:	8082                	ret
ffffffffc020b130:	e07ff0ef          	jal	ra,ffffffffc020af36 <bitmap_translate.part.0>
ffffffffc020b134:	00004697          	auipc	a3,0x4
ffffffffc020b138:	3b468693          	addi	a3,a3,948 # ffffffffc020f4e8 <sfs_node_fileops+0x290>
ffffffffc020b13c:	00001617          	auipc	a2,0x1
ffffffffc020b140:	adc60613          	addi	a2,a2,-1316 # ffffffffc020bc18 <commands+0x250>
ffffffffc020b144:	05f00593          	li	a1,95
ffffffffc020b148:	00004517          	auipc	a0,0x4
ffffffffc020b14c:	32050513          	addi	a0,a0,800 # ffffffffc020f468 <sfs_node_fileops+0x210>
ffffffffc020b150:	8def50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020b154 <bitmap_destroy>:
ffffffffc020b154:	1141                	addi	sp,sp,-16
ffffffffc020b156:	e022                	sd	s0,0(sp)
ffffffffc020b158:	842a                	mv	s0,a0
ffffffffc020b15a:	6508                	ld	a0,8(a0)
ffffffffc020b15c:	e406                	sd	ra,8(sp)
ffffffffc020b15e:	d01f60ef          	jal	ra,ffffffffc0201e5e <kfree>
ffffffffc020b162:	8522                	mv	a0,s0
ffffffffc020b164:	6402                	ld	s0,0(sp)
ffffffffc020b166:	60a2                	ld	ra,8(sp)
ffffffffc020b168:	0141                	addi	sp,sp,16
ffffffffc020b16a:	cf5f606f          	j	ffffffffc0201e5e <kfree>

ffffffffc020b16e <bitmap_getdata>:
ffffffffc020b16e:	c589                	beqz	a1,ffffffffc020b178 <bitmap_getdata+0xa>
ffffffffc020b170:	00456783          	lwu	a5,4(a0)
ffffffffc020b174:	078a                	slli	a5,a5,0x2
ffffffffc020b176:	e19c                	sd	a5,0(a1)
ffffffffc020b178:	6508                	ld	a0,8(a0)
ffffffffc020b17a:	8082                	ret

ffffffffc020b17c <strlen>:
ffffffffc020b17c:	00054783          	lbu	a5,0(a0)
ffffffffc020b180:	872a                	mv	a4,a0
ffffffffc020b182:	4501                	li	a0,0
ffffffffc020b184:	cb81                	beqz	a5,ffffffffc020b194 <strlen+0x18>
ffffffffc020b186:	0505                	addi	a0,a0,1
ffffffffc020b188:	00a707b3          	add	a5,a4,a0
ffffffffc020b18c:	0007c783          	lbu	a5,0(a5)
ffffffffc020b190:	fbfd                	bnez	a5,ffffffffc020b186 <strlen+0xa>
ffffffffc020b192:	8082                	ret
ffffffffc020b194:	8082                	ret

ffffffffc020b196 <strnlen>:
ffffffffc020b196:	4781                	li	a5,0
ffffffffc020b198:	e589                	bnez	a1,ffffffffc020b1a2 <strnlen+0xc>
ffffffffc020b19a:	a811                	j	ffffffffc020b1ae <strnlen+0x18>
ffffffffc020b19c:	0785                	addi	a5,a5,1
ffffffffc020b19e:	00f58863          	beq	a1,a5,ffffffffc020b1ae <strnlen+0x18>
ffffffffc020b1a2:	00f50733          	add	a4,a0,a5
ffffffffc020b1a6:	00074703          	lbu	a4,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc020b1aa:	fb6d                	bnez	a4,ffffffffc020b19c <strnlen+0x6>
ffffffffc020b1ac:	85be                	mv	a1,a5
ffffffffc020b1ae:	852e                	mv	a0,a1
ffffffffc020b1b0:	8082                	ret

ffffffffc020b1b2 <strcpy>:
ffffffffc020b1b2:	87aa                	mv	a5,a0
ffffffffc020b1b4:	0005c703          	lbu	a4,0(a1)
ffffffffc020b1b8:	0785                	addi	a5,a5,1
ffffffffc020b1ba:	0585                	addi	a1,a1,1
ffffffffc020b1bc:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b1c0:	fb75                	bnez	a4,ffffffffc020b1b4 <strcpy+0x2>
ffffffffc020b1c2:	8082                	ret

ffffffffc020b1c4 <strcmp>:
ffffffffc020b1c4:	00054783          	lbu	a5,0(a0)
ffffffffc020b1c8:	0005c703          	lbu	a4,0(a1)
ffffffffc020b1cc:	cb89                	beqz	a5,ffffffffc020b1de <strcmp+0x1a>
ffffffffc020b1ce:	0505                	addi	a0,a0,1
ffffffffc020b1d0:	0585                	addi	a1,a1,1
ffffffffc020b1d2:	fee789e3          	beq	a5,a4,ffffffffc020b1c4 <strcmp>
ffffffffc020b1d6:	0007851b          	sext.w	a0,a5
ffffffffc020b1da:	9d19                	subw	a0,a0,a4
ffffffffc020b1dc:	8082                	ret
ffffffffc020b1de:	4501                	li	a0,0
ffffffffc020b1e0:	bfed                	j	ffffffffc020b1da <strcmp+0x16>

ffffffffc020b1e2 <strncmp>:
ffffffffc020b1e2:	c20d                	beqz	a2,ffffffffc020b204 <strncmp+0x22>
ffffffffc020b1e4:	962e                	add	a2,a2,a1
ffffffffc020b1e6:	a031                	j	ffffffffc020b1f2 <strncmp+0x10>
ffffffffc020b1e8:	0505                	addi	a0,a0,1
ffffffffc020b1ea:	00e79a63          	bne	a5,a4,ffffffffc020b1fe <strncmp+0x1c>
ffffffffc020b1ee:	00b60b63          	beq	a2,a1,ffffffffc020b204 <strncmp+0x22>
ffffffffc020b1f2:	00054783          	lbu	a5,0(a0)
ffffffffc020b1f6:	0585                	addi	a1,a1,1
ffffffffc020b1f8:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020b1fc:	f7f5                	bnez	a5,ffffffffc020b1e8 <strncmp+0x6>
ffffffffc020b1fe:	40e7853b          	subw	a0,a5,a4
ffffffffc020b202:	8082                	ret
ffffffffc020b204:	4501                	li	a0,0
ffffffffc020b206:	8082                	ret

ffffffffc020b208 <strchr>:
ffffffffc020b208:	00054783          	lbu	a5,0(a0)
ffffffffc020b20c:	c799                	beqz	a5,ffffffffc020b21a <strchr+0x12>
ffffffffc020b20e:	00f58763          	beq	a1,a5,ffffffffc020b21c <strchr+0x14>
ffffffffc020b212:	00154783          	lbu	a5,1(a0)
ffffffffc020b216:	0505                	addi	a0,a0,1
ffffffffc020b218:	fbfd                	bnez	a5,ffffffffc020b20e <strchr+0x6>
ffffffffc020b21a:	4501                	li	a0,0
ffffffffc020b21c:	8082                	ret

ffffffffc020b21e <memset>:
ffffffffc020b21e:	ca01                	beqz	a2,ffffffffc020b22e <memset+0x10>
ffffffffc020b220:	962a                	add	a2,a2,a0
ffffffffc020b222:	87aa                	mv	a5,a0
ffffffffc020b224:	0785                	addi	a5,a5,1
ffffffffc020b226:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b22a:	fec79de3          	bne	a5,a2,ffffffffc020b224 <memset+0x6>
ffffffffc020b22e:	8082                	ret

ffffffffc020b230 <memmove>:
ffffffffc020b230:	02a5f263          	bgeu	a1,a0,ffffffffc020b254 <memmove+0x24>
ffffffffc020b234:	00c587b3          	add	a5,a1,a2
ffffffffc020b238:	00f57e63          	bgeu	a0,a5,ffffffffc020b254 <memmove+0x24>
ffffffffc020b23c:	00c50733          	add	a4,a0,a2
ffffffffc020b240:	c615                	beqz	a2,ffffffffc020b26c <memmove+0x3c>
ffffffffc020b242:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b246:	17fd                	addi	a5,a5,-1
ffffffffc020b248:	177d                	addi	a4,a4,-1
ffffffffc020b24a:	00d70023          	sb	a3,0(a4)
ffffffffc020b24e:	fef59ae3          	bne	a1,a5,ffffffffc020b242 <memmove+0x12>
ffffffffc020b252:	8082                	ret
ffffffffc020b254:	00c586b3          	add	a3,a1,a2
ffffffffc020b258:	87aa                	mv	a5,a0
ffffffffc020b25a:	ca11                	beqz	a2,ffffffffc020b26e <memmove+0x3e>
ffffffffc020b25c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b260:	0585                	addi	a1,a1,1
ffffffffc020b262:	0785                	addi	a5,a5,1
ffffffffc020b264:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b268:	fed59ae3          	bne	a1,a3,ffffffffc020b25c <memmove+0x2c>
ffffffffc020b26c:	8082                	ret
ffffffffc020b26e:	8082                	ret

ffffffffc020b270 <memcpy>:
ffffffffc020b270:	ca19                	beqz	a2,ffffffffc020b286 <memcpy+0x16>
ffffffffc020b272:	962e                	add	a2,a2,a1
ffffffffc020b274:	87aa                	mv	a5,a0
ffffffffc020b276:	0005c703          	lbu	a4,0(a1)
ffffffffc020b27a:	0585                	addi	a1,a1,1
ffffffffc020b27c:	0785                	addi	a5,a5,1
ffffffffc020b27e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b282:	fec59ae3          	bne	a1,a2,ffffffffc020b276 <memcpy+0x6>
ffffffffc020b286:	8082                	ret

ffffffffc020b288 <printnum>:
ffffffffc020b288:	02071893          	slli	a7,a4,0x20
ffffffffc020b28c:	7139                	addi	sp,sp,-64
ffffffffc020b28e:	0208d893          	srli	a7,a7,0x20
ffffffffc020b292:	e456                	sd	s5,8(sp)
ffffffffc020b294:	0316fab3          	remu	s5,a3,a7
ffffffffc020b298:	f822                	sd	s0,48(sp)
ffffffffc020b29a:	f426                	sd	s1,40(sp)
ffffffffc020b29c:	f04a                	sd	s2,32(sp)
ffffffffc020b29e:	ec4e                	sd	s3,24(sp)
ffffffffc020b2a0:	fc06                	sd	ra,56(sp)
ffffffffc020b2a2:	e852                	sd	s4,16(sp)
ffffffffc020b2a4:	84aa                	mv	s1,a0
ffffffffc020b2a6:	89ae                	mv	s3,a1
ffffffffc020b2a8:	8932                	mv	s2,a2
ffffffffc020b2aa:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b2ae:	2a81                	sext.w	s5,s5
ffffffffc020b2b0:	0516f163          	bgeu	a3,a7,ffffffffc020b2f2 <printnum+0x6a>
ffffffffc020b2b4:	8a42                	mv	s4,a6
ffffffffc020b2b6:	00805863          	blez	s0,ffffffffc020b2c6 <printnum+0x3e>
ffffffffc020b2ba:	347d                	addiw	s0,s0,-1
ffffffffc020b2bc:	864e                	mv	a2,s3
ffffffffc020b2be:	85ca                	mv	a1,s2
ffffffffc020b2c0:	8552                	mv	a0,s4
ffffffffc020b2c2:	9482                	jalr	s1
ffffffffc020b2c4:	f87d                	bnez	s0,ffffffffc020b2ba <printnum+0x32>
ffffffffc020b2c6:	1a82                	slli	s5,s5,0x20
ffffffffc020b2c8:	00004797          	auipc	a5,0x4
ffffffffc020b2cc:	23078793          	addi	a5,a5,560 # ffffffffc020f4f8 <sfs_node_fileops+0x2a0>
ffffffffc020b2d0:	020ada93          	srli	s5,s5,0x20
ffffffffc020b2d4:	9abe                	add	s5,s5,a5
ffffffffc020b2d6:	7442                	ld	s0,48(sp)
ffffffffc020b2d8:	000ac503          	lbu	a0,0(s5)
ffffffffc020b2dc:	70e2                	ld	ra,56(sp)
ffffffffc020b2de:	6a42                	ld	s4,16(sp)
ffffffffc020b2e0:	6aa2                	ld	s5,8(sp)
ffffffffc020b2e2:	864e                	mv	a2,s3
ffffffffc020b2e4:	85ca                	mv	a1,s2
ffffffffc020b2e6:	69e2                	ld	s3,24(sp)
ffffffffc020b2e8:	7902                	ld	s2,32(sp)
ffffffffc020b2ea:	87a6                	mv	a5,s1
ffffffffc020b2ec:	74a2                	ld	s1,40(sp)
ffffffffc020b2ee:	6121                	addi	sp,sp,64
ffffffffc020b2f0:	8782                	jr	a5
ffffffffc020b2f2:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b2f6:	87a2                	mv	a5,s0
ffffffffc020b2f8:	f91ff0ef          	jal	ra,ffffffffc020b288 <printnum>
ffffffffc020b2fc:	b7e9                	j	ffffffffc020b2c6 <printnum+0x3e>

ffffffffc020b2fe <sprintputch>:
ffffffffc020b2fe:	499c                	lw	a5,16(a1)
ffffffffc020b300:	6198                	ld	a4,0(a1)
ffffffffc020b302:	6594                	ld	a3,8(a1)
ffffffffc020b304:	2785                	addiw	a5,a5,1
ffffffffc020b306:	c99c                	sw	a5,16(a1)
ffffffffc020b308:	00d77763          	bgeu	a4,a3,ffffffffc020b316 <sprintputch+0x18>
ffffffffc020b30c:	00170793          	addi	a5,a4,1
ffffffffc020b310:	e19c                	sd	a5,0(a1)
ffffffffc020b312:	00a70023          	sb	a0,0(a4)
ffffffffc020b316:	8082                	ret

ffffffffc020b318 <vprintfmt>:
ffffffffc020b318:	7119                	addi	sp,sp,-128
ffffffffc020b31a:	f4a6                	sd	s1,104(sp)
ffffffffc020b31c:	f0ca                	sd	s2,96(sp)
ffffffffc020b31e:	ecce                	sd	s3,88(sp)
ffffffffc020b320:	e8d2                	sd	s4,80(sp)
ffffffffc020b322:	e4d6                	sd	s5,72(sp)
ffffffffc020b324:	e0da                	sd	s6,64(sp)
ffffffffc020b326:	fc5e                	sd	s7,56(sp)
ffffffffc020b328:	ec6e                	sd	s11,24(sp)
ffffffffc020b32a:	fc86                	sd	ra,120(sp)
ffffffffc020b32c:	f8a2                	sd	s0,112(sp)
ffffffffc020b32e:	f862                	sd	s8,48(sp)
ffffffffc020b330:	f466                	sd	s9,40(sp)
ffffffffc020b332:	f06a                	sd	s10,32(sp)
ffffffffc020b334:	89aa                	mv	s3,a0
ffffffffc020b336:	892e                	mv	s2,a1
ffffffffc020b338:	84b2                	mv	s1,a2
ffffffffc020b33a:	8db6                	mv	s11,a3
ffffffffc020b33c:	8aba                	mv	s5,a4
ffffffffc020b33e:	02500a13          	li	s4,37
ffffffffc020b342:	5bfd                	li	s7,-1
ffffffffc020b344:	00004b17          	auipc	s6,0x4
ffffffffc020b348:	1e0b0b13          	addi	s6,s6,480 # ffffffffc020f524 <sfs_node_fileops+0x2cc>
ffffffffc020b34c:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b350:	001d8413          	addi	s0,s11,1
ffffffffc020b354:	01450b63          	beq	a0,s4,ffffffffc020b36a <vprintfmt+0x52>
ffffffffc020b358:	c129                	beqz	a0,ffffffffc020b39a <vprintfmt+0x82>
ffffffffc020b35a:	864a                	mv	a2,s2
ffffffffc020b35c:	85a6                	mv	a1,s1
ffffffffc020b35e:	0405                	addi	s0,s0,1
ffffffffc020b360:	9982                	jalr	s3
ffffffffc020b362:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b366:	ff4519e3          	bne	a0,s4,ffffffffc020b358 <vprintfmt+0x40>
ffffffffc020b36a:	00044583          	lbu	a1,0(s0)
ffffffffc020b36e:	02000813          	li	a6,32
ffffffffc020b372:	4d01                	li	s10,0
ffffffffc020b374:	4301                	li	t1,0
ffffffffc020b376:	5cfd                	li	s9,-1
ffffffffc020b378:	5c7d                	li	s8,-1
ffffffffc020b37a:	05500513          	li	a0,85
ffffffffc020b37e:	48a5                	li	a7,9
ffffffffc020b380:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b384:	0ff67613          	zext.b	a2,a2
ffffffffc020b388:	00140d93          	addi	s11,s0,1
ffffffffc020b38c:	04c56263          	bltu	a0,a2,ffffffffc020b3d0 <vprintfmt+0xb8>
ffffffffc020b390:	060a                	slli	a2,a2,0x2
ffffffffc020b392:	965a                	add	a2,a2,s6
ffffffffc020b394:	4214                	lw	a3,0(a2)
ffffffffc020b396:	96da                	add	a3,a3,s6
ffffffffc020b398:	8682                	jr	a3
ffffffffc020b39a:	70e6                	ld	ra,120(sp)
ffffffffc020b39c:	7446                	ld	s0,112(sp)
ffffffffc020b39e:	74a6                	ld	s1,104(sp)
ffffffffc020b3a0:	7906                	ld	s2,96(sp)
ffffffffc020b3a2:	69e6                	ld	s3,88(sp)
ffffffffc020b3a4:	6a46                	ld	s4,80(sp)
ffffffffc020b3a6:	6aa6                	ld	s5,72(sp)
ffffffffc020b3a8:	6b06                	ld	s6,64(sp)
ffffffffc020b3aa:	7be2                	ld	s7,56(sp)
ffffffffc020b3ac:	7c42                	ld	s8,48(sp)
ffffffffc020b3ae:	7ca2                	ld	s9,40(sp)
ffffffffc020b3b0:	7d02                	ld	s10,32(sp)
ffffffffc020b3b2:	6de2                	ld	s11,24(sp)
ffffffffc020b3b4:	6109                	addi	sp,sp,128
ffffffffc020b3b6:	8082                	ret
ffffffffc020b3b8:	882e                	mv	a6,a1
ffffffffc020b3ba:	00144583          	lbu	a1,1(s0)
ffffffffc020b3be:	846e                	mv	s0,s11
ffffffffc020b3c0:	00140d93          	addi	s11,s0,1
ffffffffc020b3c4:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b3c8:	0ff67613          	zext.b	a2,a2
ffffffffc020b3cc:	fcc572e3          	bgeu	a0,a2,ffffffffc020b390 <vprintfmt+0x78>
ffffffffc020b3d0:	864a                	mv	a2,s2
ffffffffc020b3d2:	85a6                	mv	a1,s1
ffffffffc020b3d4:	02500513          	li	a0,37
ffffffffc020b3d8:	9982                	jalr	s3
ffffffffc020b3da:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b3de:	8da2                	mv	s11,s0
ffffffffc020b3e0:	f74786e3          	beq	a5,s4,ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b3e4:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b3e8:	1dfd                	addi	s11,s11,-1
ffffffffc020b3ea:	ff479de3          	bne	a5,s4,ffffffffc020b3e4 <vprintfmt+0xcc>
ffffffffc020b3ee:	bfb9                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b3f0:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b3f4:	00144583          	lbu	a1,1(s0)
ffffffffc020b3f8:	846e                	mv	s0,s11
ffffffffc020b3fa:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b3fe:	0005861b          	sext.w	a2,a1
ffffffffc020b402:	02d8e463          	bltu	a7,a3,ffffffffc020b42a <vprintfmt+0x112>
ffffffffc020b406:	00144583          	lbu	a1,1(s0)
ffffffffc020b40a:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b40e:	0196873b          	addw	a4,a3,s9
ffffffffc020b412:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b416:	9f31                	addw	a4,a4,a2
ffffffffc020b418:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b41c:	0405                	addi	s0,s0,1
ffffffffc020b41e:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b422:	0005861b          	sext.w	a2,a1
ffffffffc020b426:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b406 <vprintfmt+0xee>
ffffffffc020b42a:	f40c5be3          	bgez	s8,ffffffffc020b380 <vprintfmt+0x68>
ffffffffc020b42e:	8c66                	mv	s8,s9
ffffffffc020b430:	5cfd                	li	s9,-1
ffffffffc020b432:	b7b9                	j	ffffffffc020b380 <vprintfmt+0x68>
ffffffffc020b434:	fffc4693          	not	a3,s8
ffffffffc020b438:	96fd                	srai	a3,a3,0x3f
ffffffffc020b43a:	00dc77b3          	and	a5,s8,a3
ffffffffc020b43e:	00144583          	lbu	a1,1(s0)
ffffffffc020b442:	00078c1b          	sext.w	s8,a5
ffffffffc020b446:	846e                	mv	s0,s11
ffffffffc020b448:	bf25                	j	ffffffffc020b380 <vprintfmt+0x68>
ffffffffc020b44a:	000aac83          	lw	s9,0(s5)
ffffffffc020b44e:	00144583          	lbu	a1,1(s0)
ffffffffc020b452:	0aa1                	addi	s5,s5,8
ffffffffc020b454:	846e                	mv	s0,s11
ffffffffc020b456:	bfd1                	j	ffffffffc020b42a <vprintfmt+0x112>
ffffffffc020b458:	4705                	li	a4,1
ffffffffc020b45a:	008a8613          	addi	a2,s5,8
ffffffffc020b45e:	00674463          	blt	a4,t1,ffffffffc020b466 <vprintfmt+0x14e>
ffffffffc020b462:	1c030c63          	beqz	t1,ffffffffc020b63a <vprintfmt+0x322>
ffffffffc020b466:	000ab683          	ld	a3,0(s5)
ffffffffc020b46a:	4741                	li	a4,16
ffffffffc020b46c:	8ab2                	mv	s5,a2
ffffffffc020b46e:	2801                	sext.w	a6,a6
ffffffffc020b470:	87e2                	mv	a5,s8
ffffffffc020b472:	8626                	mv	a2,s1
ffffffffc020b474:	85ca                	mv	a1,s2
ffffffffc020b476:	854e                	mv	a0,s3
ffffffffc020b478:	e11ff0ef          	jal	ra,ffffffffc020b288 <printnum>
ffffffffc020b47c:	bdc1                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b47e:	000aa503          	lw	a0,0(s5)
ffffffffc020b482:	864a                	mv	a2,s2
ffffffffc020b484:	85a6                	mv	a1,s1
ffffffffc020b486:	0aa1                	addi	s5,s5,8
ffffffffc020b488:	9982                	jalr	s3
ffffffffc020b48a:	b5c9                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b48c:	4705                	li	a4,1
ffffffffc020b48e:	008a8613          	addi	a2,s5,8
ffffffffc020b492:	00674463          	blt	a4,t1,ffffffffc020b49a <vprintfmt+0x182>
ffffffffc020b496:	18030d63          	beqz	t1,ffffffffc020b630 <vprintfmt+0x318>
ffffffffc020b49a:	000ab683          	ld	a3,0(s5)
ffffffffc020b49e:	4729                	li	a4,10
ffffffffc020b4a0:	8ab2                	mv	s5,a2
ffffffffc020b4a2:	b7f1                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b4a4:	00144583          	lbu	a1,1(s0)
ffffffffc020b4a8:	4d05                	li	s10,1
ffffffffc020b4aa:	846e                	mv	s0,s11
ffffffffc020b4ac:	bdd1                	j	ffffffffc020b380 <vprintfmt+0x68>
ffffffffc020b4ae:	864a                	mv	a2,s2
ffffffffc020b4b0:	85a6                	mv	a1,s1
ffffffffc020b4b2:	02500513          	li	a0,37
ffffffffc020b4b6:	9982                	jalr	s3
ffffffffc020b4b8:	bd51                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b4ba:	00144583          	lbu	a1,1(s0)
ffffffffc020b4be:	2305                	addiw	t1,t1,1
ffffffffc020b4c0:	846e                	mv	s0,s11
ffffffffc020b4c2:	bd7d                	j	ffffffffc020b380 <vprintfmt+0x68>
ffffffffc020b4c4:	4705                	li	a4,1
ffffffffc020b4c6:	008a8613          	addi	a2,s5,8
ffffffffc020b4ca:	00674463          	blt	a4,t1,ffffffffc020b4d2 <vprintfmt+0x1ba>
ffffffffc020b4ce:	14030c63          	beqz	t1,ffffffffc020b626 <vprintfmt+0x30e>
ffffffffc020b4d2:	000ab683          	ld	a3,0(s5)
ffffffffc020b4d6:	4721                	li	a4,8
ffffffffc020b4d8:	8ab2                	mv	s5,a2
ffffffffc020b4da:	bf51                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b4dc:	03000513          	li	a0,48
ffffffffc020b4e0:	864a                	mv	a2,s2
ffffffffc020b4e2:	85a6                	mv	a1,s1
ffffffffc020b4e4:	e042                	sd	a6,0(sp)
ffffffffc020b4e6:	9982                	jalr	s3
ffffffffc020b4e8:	864a                	mv	a2,s2
ffffffffc020b4ea:	85a6                	mv	a1,s1
ffffffffc020b4ec:	07800513          	li	a0,120
ffffffffc020b4f0:	9982                	jalr	s3
ffffffffc020b4f2:	0aa1                	addi	s5,s5,8
ffffffffc020b4f4:	6802                	ld	a6,0(sp)
ffffffffc020b4f6:	4741                	li	a4,16
ffffffffc020b4f8:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b4fc:	bf8d                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b4fe:	000ab403          	ld	s0,0(s5)
ffffffffc020b502:	008a8793          	addi	a5,s5,8
ffffffffc020b506:	e03e                	sd	a5,0(sp)
ffffffffc020b508:	14040c63          	beqz	s0,ffffffffc020b660 <vprintfmt+0x348>
ffffffffc020b50c:	11805063          	blez	s8,ffffffffc020b60c <vprintfmt+0x2f4>
ffffffffc020b510:	02d00693          	li	a3,45
ffffffffc020b514:	0cd81963          	bne	a6,a3,ffffffffc020b5e6 <vprintfmt+0x2ce>
ffffffffc020b518:	00044683          	lbu	a3,0(s0)
ffffffffc020b51c:	0006851b          	sext.w	a0,a3
ffffffffc020b520:	ce8d                	beqz	a3,ffffffffc020b55a <vprintfmt+0x242>
ffffffffc020b522:	00140a93          	addi	s5,s0,1
ffffffffc020b526:	05e00413          	li	s0,94
ffffffffc020b52a:	000cc563          	bltz	s9,ffffffffc020b534 <vprintfmt+0x21c>
ffffffffc020b52e:	3cfd                	addiw	s9,s9,-1
ffffffffc020b530:	037c8363          	beq	s9,s7,ffffffffc020b556 <vprintfmt+0x23e>
ffffffffc020b534:	864a                	mv	a2,s2
ffffffffc020b536:	85a6                	mv	a1,s1
ffffffffc020b538:	100d0663          	beqz	s10,ffffffffc020b644 <vprintfmt+0x32c>
ffffffffc020b53c:	3681                	addiw	a3,a3,-32
ffffffffc020b53e:	10d47363          	bgeu	s0,a3,ffffffffc020b644 <vprintfmt+0x32c>
ffffffffc020b542:	03f00513          	li	a0,63
ffffffffc020b546:	9982                	jalr	s3
ffffffffc020b548:	000ac683          	lbu	a3,0(s5)
ffffffffc020b54c:	3c7d                	addiw	s8,s8,-1
ffffffffc020b54e:	0a85                	addi	s5,s5,1
ffffffffc020b550:	0006851b          	sext.w	a0,a3
ffffffffc020b554:	faf9                	bnez	a3,ffffffffc020b52a <vprintfmt+0x212>
ffffffffc020b556:	01805a63          	blez	s8,ffffffffc020b56a <vprintfmt+0x252>
ffffffffc020b55a:	3c7d                	addiw	s8,s8,-1
ffffffffc020b55c:	864a                	mv	a2,s2
ffffffffc020b55e:	85a6                	mv	a1,s1
ffffffffc020b560:	02000513          	li	a0,32
ffffffffc020b564:	9982                	jalr	s3
ffffffffc020b566:	fe0c1ae3          	bnez	s8,ffffffffc020b55a <vprintfmt+0x242>
ffffffffc020b56a:	6a82                	ld	s5,0(sp)
ffffffffc020b56c:	b3c5                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b56e:	4705                	li	a4,1
ffffffffc020b570:	008a8d13          	addi	s10,s5,8
ffffffffc020b574:	00674463          	blt	a4,t1,ffffffffc020b57c <vprintfmt+0x264>
ffffffffc020b578:	0a030463          	beqz	t1,ffffffffc020b620 <vprintfmt+0x308>
ffffffffc020b57c:	000ab403          	ld	s0,0(s5)
ffffffffc020b580:	0c044463          	bltz	s0,ffffffffc020b648 <vprintfmt+0x330>
ffffffffc020b584:	86a2                	mv	a3,s0
ffffffffc020b586:	8aea                	mv	s5,s10
ffffffffc020b588:	4729                	li	a4,10
ffffffffc020b58a:	b5d5                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b58c:	000aa783          	lw	a5,0(s5)
ffffffffc020b590:	46e1                	li	a3,24
ffffffffc020b592:	0aa1                	addi	s5,s5,8
ffffffffc020b594:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b598:	8fb9                	xor	a5,a5,a4
ffffffffc020b59a:	40e7873b          	subw	a4,a5,a4
ffffffffc020b59e:	02e6c663          	blt	a3,a4,ffffffffc020b5ca <vprintfmt+0x2b2>
ffffffffc020b5a2:	00371793          	slli	a5,a4,0x3
ffffffffc020b5a6:	00004697          	auipc	a3,0x4
ffffffffc020b5aa:	2b268693          	addi	a3,a3,690 # ffffffffc020f858 <error_string>
ffffffffc020b5ae:	97b6                	add	a5,a5,a3
ffffffffc020b5b0:	639c                	ld	a5,0(a5)
ffffffffc020b5b2:	cf81                	beqz	a5,ffffffffc020b5ca <vprintfmt+0x2b2>
ffffffffc020b5b4:	873e                	mv	a4,a5
ffffffffc020b5b6:	00000697          	auipc	a3,0x0
ffffffffc020b5ba:	19268693          	addi	a3,a3,402 # ffffffffc020b748 <etext+0x2e>
ffffffffc020b5be:	8626                	mv	a2,s1
ffffffffc020b5c0:	85ca                	mv	a1,s2
ffffffffc020b5c2:	854e                	mv	a0,s3
ffffffffc020b5c4:	0d4000ef          	jal	ra,ffffffffc020b698 <printfmt>
ffffffffc020b5c8:	b351                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b5ca:	00004697          	auipc	a3,0x4
ffffffffc020b5ce:	f4e68693          	addi	a3,a3,-178 # ffffffffc020f518 <sfs_node_fileops+0x2c0>
ffffffffc020b5d2:	8626                	mv	a2,s1
ffffffffc020b5d4:	85ca                	mv	a1,s2
ffffffffc020b5d6:	854e                	mv	a0,s3
ffffffffc020b5d8:	0c0000ef          	jal	ra,ffffffffc020b698 <printfmt>
ffffffffc020b5dc:	bb85                	j	ffffffffc020b34c <vprintfmt+0x34>
ffffffffc020b5de:	00004417          	auipc	s0,0x4
ffffffffc020b5e2:	f3240413          	addi	s0,s0,-206 # ffffffffc020f510 <sfs_node_fileops+0x2b8>
ffffffffc020b5e6:	85e6                	mv	a1,s9
ffffffffc020b5e8:	8522                	mv	a0,s0
ffffffffc020b5ea:	e442                	sd	a6,8(sp)
ffffffffc020b5ec:	babff0ef          	jal	ra,ffffffffc020b196 <strnlen>
ffffffffc020b5f0:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b5f4:	01805c63          	blez	s8,ffffffffc020b60c <vprintfmt+0x2f4>
ffffffffc020b5f8:	6822                	ld	a6,8(sp)
ffffffffc020b5fa:	00080a9b          	sext.w	s5,a6
ffffffffc020b5fe:	3c7d                	addiw	s8,s8,-1
ffffffffc020b600:	864a                	mv	a2,s2
ffffffffc020b602:	85a6                	mv	a1,s1
ffffffffc020b604:	8556                	mv	a0,s5
ffffffffc020b606:	9982                	jalr	s3
ffffffffc020b608:	fe0c1be3          	bnez	s8,ffffffffc020b5fe <vprintfmt+0x2e6>
ffffffffc020b60c:	00044683          	lbu	a3,0(s0)
ffffffffc020b610:	00140a93          	addi	s5,s0,1
ffffffffc020b614:	0006851b          	sext.w	a0,a3
ffffffffc020b618:	daa9                	beqz	a3,ffffffffc020b56a <vprintfmt+0x252>
ffffffffc020b61a:	05e00413          	li	s0,94
ffffffffc020b61e:	b731                	j	ffffffffc020b52a <vprintfmt+0x212>
ffffffffc020b620:	000aa403          	lw	s0,0(s5)
ffffffffc020b624:	bfb1                	j	ffffffffc020b580 <vprintfmt+0x268>
ffffffffc020b626:	000ae683          	lwu	a3,0(s5)
ffffffffc020b62a:	4721                	li	a4,8
ffffffffc020b62c:	8ab2                	mv	s5,a2
ffffffffc020b62e:	b581                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b630:	000ae683          	lwu	a3,0(s5)
ffffffffc020b634:	4729                	li	a4,10
ffffffffc020b636:	8ab2                	mv	s5,a2
ffffffffc020b638:	bd1d                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b63a:	000ae683          	lwu	a3,0(s5)
ffffffffc020b63e:	4741                	li	a4,16
ffffffffc020b640:	8ab2                	mv	s5,a2
ffffffffc020b642:	b535                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b644:	9982                	jalr	s3
ffffffffc020b646:	b709                	j	ffffffffc020b548 <vprintfmt+0x230>
ffffffffc020b648:	864a                	mv	a2,s2
ffffffffc020b64a:	85a6                	mv	a1,s1
ffffffffc020b64c:	02d00513          	li	a0,45
ffffffffc020b650:	e042                	sd	a6,0(sp)
ffffffffc020b652:	9982                	jalr	s3
ffffffffc020b654:	6802                	ld	a6,0(sp)
ffffffffc020b656:	8aea                	mv	s5,s10
ffffffffc020b658:	408006b3          	neg	a3,s0
ffffffffc020b65c:	4729                	li	a4,10
ffffffffc020b65e:	bd01                	j	ffffffffc020b46e <vprintfmt+0x156>
ffffffffc020b660:	03805163          	blez	s8,ffffffffc020b682 <vprintfmt+0x36a>
ffffffffc020b664:	02d00693          	li	a3,45
ffffffffc020b668:	f6d81be3          	bne	a6,a3,ffffffffc020b5de <vprintfmt+0x2c6>
ffffffffc020b66c:	00004417          	auipc	s0,0x4
ffffffffc020b670:	ea440413          	addi	s0,s0,-348 # ffffffffc020f510 <sfs_node_fileops+0x2b8>
ffffffffc020b674:	02800693          	li	a3,40
ffffffffc020b678:	02800513          	li	a0,40
ffffffffc020b67c:	00140a93          	addi	s5,s0,1
ffffffffc020b680:	b55d                	j	ffffffffc020b526 <vprintfmt+0x20e>
ffffffffc020b682:	00004a97          	auipc	s5,0x4
ffffffffc020b686:	e8fa8a93          	addi	s5,s5,-369 # ffffffffc020f511 <sfs_node_fileops+0x2b9>
ffffffffc020b68a:	02800513          	li	a0,40
ffffffffc020b68e:	02800693          	li	a3,40
ffffffffc020b692:	05e00413          	li	s0,94
ffffffffc020b696:	bd51                	j	ffffffffc020b52a <vprintfmt+0x212>

ffffffffc020b698 <printfmt>:
ffffffffc020b698:	7139                	addi	sp,sp,-64
ffffffffc020b69a:	02010313          	addi	t1,sp,32
ffffffffc020b69e:	f03a                	sd	a4,32(sp)
ffffffffc020b6a0:	871a                	mv	a4,t1
ffffffffc020b6a2:	ec06                	sd	ra,24(sp)
ffffffffc020b6a4:	f43e                	sd	a5,40(sp)
ffffffffc020b6a6:	f842                	sd	a6,48(sp)
ffffffffc020b6a8:	fc46                	sd	a7,56(sp)
ffffffffc020b6aa:	e41a                	sd	t1,8(sp)
ffffffffc020b6ac:	c6dff0ef          	jal	ra,ffffffffc020b318 <vprintfmt>
ffffffffc020b6b0:	60e2                	ld	ra,24(sp)
ffffffffc020b6b2:	6121                	addi	sp,sp,64
ffffffffc020b6b4:	8082                	ret

ffffffffc020b6b6 <snprintf>:
ffffffffc020b6b6:	711d                	addi	sp,sp,-96
ffffffffc020b6b8:	15fd                	addi	a1,a1,-1
ffffffffc020b6ba:	03810313          	addi	t1,sp,56
ffffffffc020b6be:	95aa                	add	a1,a1,a0
ffffffffc020b6c0:	f406                	sd	ra,40(sp)
ffffffffc020b6c2:	fc36                	sd	a3,56(sp)
ffffffffc020b6c4:	e0ba                	sd	a4,64(sp)
ffffffffc020b6c6:	e4be                	sd	a5,72(sp)
ffffffffc020b6c8:	e8c2                	sd	a6,80(sp)
ffffffffc020b6ca:	ecc6                	sd	a7,88(sp)
ffffffffc020b6cc:	e01a                	sd	t1,0(sp)
ffffffffc020b6ce:	e42a                	sd	a0,8(sp)
ffffffffc020b6d0:	e82e                	sd	a1,16(sp)
ffffffffc020b6d2:	cc02                	sw	zero,24(sp)
ffffffffc020b6d4:	c515                	beqz	a0,ffffffffc020b700 <snprintf+0x4a>
ffffffffc020b6d6:	02a5e563          	bltu	a1,a0,ffffffffc020b700 <snprintf+0x4a>
ffffffffc020b6da:	75dd                	lui	a1,0xffff7
ffffffffc020b6dc:	86b2                	mv	a3,a2
ffffffffc020b6de:	00000517          	auipc	a0,0x0
ffffffffc020b6e2:	c2050513          	addi	a0,a0,-992 # ffffffffc020b2fe <sprintputch>
ffffffffc020b6e6:	871a                	mv	a4,t1
ffffffffc020b6e8:	0030                	addi	a2,sp,8
ffffffffc020b6ea:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b6ee:	c2bff0ef          	jal	ra,ffffffffc020b318 <vprintfmt>
ffffffffc020b6f2:	67a2                	ld	a5,8(sp)
ffffffffc020b6f4:	00078023          	sb	zero,0(a5)
ffffffffc020b6f8:	4562                	lw	a0,24(sp)
ffffffffc020b6fa:	70a2                	ld	ra,40(sp)
ffffffffc020b6fc:	6125                	addi	sp,sp,96
ffffffffc020b6fe:	8082                	ret
ffffffffc020b700:	5575                	li	a0,-3
ffffffffc020b702:	bfe5                	j	ffffffffc020b6fa <snprintf+0x44>

ffffffffc020b704 <hash32>:
ffffffffc020b704:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b708:	2785                	addiw	a5,a5,1
ffffffffc020b70a:	02a7853b          	mulw	a0,a5,a0
ffffffffc020b70e:	02000793          	li	a5,32
ffffffffc020b712:	9f8d                	subw	a5,a5,a1
ffffffffc020b714:	00f5553b          	srlw	a0,a0,a5
ffffffffc020b718:	8082                	ret
