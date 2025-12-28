
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000d297          	auipc	t0,0xd
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020d000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000d297          	auipc	t0,0xd
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020d008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020c2b7          	lui	t0,0xc020c
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c020c137          	lui	sp,0xc020c

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000dc517          	auipc	a0,0xdc
ffffffffc020004e:	af650513          	addi	a0,a0,-1290 # ffffffffc02dbb40 <buf>
ffffffffc0200052:	000e0617          	auipc	a2,0xe0
ffffffffc0200056:	11e60613          	addi	a2,a2,286 # ffffffffc02e0170 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	0ec060ef          	jal	ra,ffffffffc020614e <memset>
    cons_init(); // init the console
ffffffffc0200066:	0d5000ef          	jal	ra,ffffffffc020093a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	51658593          	addi	a1,a1,1302 # ffffffffc0206580 <etext+0x4>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	52e50513          	addi	a0,a0,1326 # ffffffffc02065a0 <etext+0x24>
ffffffffc020007a:	06a000ef          	jal	ra,ffffffffc02000e4 <cprintf>

    print_kerninfo();
ffffffffc020007e:	250000ef          	jal	ra,ffffffffc02002ce <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	4be000ef          	jal	ra,ffffffffc0200540 <dtb_init>
    pmm_init(); // init physical memory management
ffffffffc0200086:	5cf020ef          	jal	ra,ffffffffc0202e54 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	123000ef          	jal	ra,ffffffffc02009ac <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12d000ef          	jal	ra,ffffffffc02009ba <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	2a8010ef          	jal	ra,ffffffffc020133a <vmm_init>
    sched_init();
ffffffffc0200096:	1d9050ef          	jal	ra,ffffffffc0205a6e <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	764050ef          	jal	ra,ffffffffc02057fe <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	053000ef          	jal	ra,ffffffffc02008f0 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	10d000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	0f1050ef          	jal	ra,ffffffffc0205996 <cpu_idle>

ffffffffc02000aa <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc02000aa:	1141                	addi	sp,sp,-16
ffffffffc02000ac:	e022                	sd	s0,0(sp)
ffffffffc02000ae:	e406                	sd	ra,8(sp)
ffffffffc02000b0:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000b2:	08b000ef          	jal	ra,ffffffffc020093c <cons_putc>
    (*cnt)++;
ffffffffc02000b6:	401c                	lw	a5,0(s0)
}
ffffffffc02000b8:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc02000ba:	2785                	addiw	a5,a5,1
ffffffffc02000bc:	c01c                	sw	a5,0(s0)
}
ffffffffc02000be:	6402                	ld	s0,0(sp)
ffffffffc02000c0:	0141                	addi	sp,sp,16
ffffffffc02000c2:	8082                	ret

ffffffffc02000c4 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc02000c4:	1101                	addi	sp,sp,-32
ffffffffc02000c6:	862a                	mv	a2,a0
ffffffffc02000c8:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000ca:	00000517          	auipc	a0,0x0
ffffffffc02000ce:	fe050513          	addi	a0,a0,-32 # ffffffffc02000aa <cputch>
ffffffffc02000d2:	006c                	addi	a1,sp,12
{
ffffffffc02000d4:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000d6:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000d8:	10c060ef          	jal	ra,ffffffffc02061e4 <vprintfmt>
    return cnt;
}
ffffffffc02000dc:	60e2                	ld	ra,24(sp)
ffffffffc02000de:	4532                	lw	a0,12(sp)
ffffffffc02000e0:	6105                	addi	sp,sp,32
ffffffffc02000e2:	8082                	ret

ffffffffc02000e4 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc02000e4:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000e6:	02810313          	addi	t1,sp,40 # ffffffffc020c028 <boot_page_table_sv39+0x28>
{
ffffffffc02000ea:	8e2a                	mv	t3,a0
ffffffffc02000ec:	f42e                	sd	a1,40(sp)
ffffffffc02000ee:	f832                	sd	a2,48(sp)
ffffffffc02000f0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000f2:	00000517          	auipc	a0,0x0
ffffffffc02000f6:	fb850513          	addi	a0,a0,-72 # ffffffffc02000aa <cputch>
ffffffffc02000fa:	004c                	addi	a1,sp,4
ffffffffc02000fc:	869a                	mv	a3,t1
ffffffffc02000fe:	8672                	mv	a2,t3
{
ffffffffc0200100:	ec06                	sd	ra,24(sp)
ffffffffc0200102:	e0ba                	sd	a4,64(sp)
ffffffffc0200104:	e4be                	sd	a5,72(sp)
ffffffffc0200106:	e8c2                	sd	a6,80(sp)
ffffffffc0200108:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc020010a:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc020010c:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020010e:	0d6060ef          	jal	ra,ffffffffc02061e4 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200112:	60e2                	ld	ra,24(sp)
ffffffffc0200114:	4512                	lw	a0,4(sp)
ffffffffc0200116:	6125                	addi	sp,sp,96
ffffffffc0200118:	8082                	ret

ffffffffc020011a <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc020011a:	0230006f          	j	ffffffffc020093c <cons_putc>

ffffffffc020011e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc020011e:	1101                	addi	sp,sp,-32
ffffffffc0200120:	e822                	sd	s0,16(sp)
ffffffffc0200122:	ec06                	sd	ra,24(sp)
ffffffffc0200124:	e426                	sd	s1,8(sp)
ffffffffc0200126:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc0200128:	00054503          	lbu	a0,0(a0)
ffffffffc020012c:	c51d                	beqz	a0,ffffffffc020015a <cputs+0x3c>
ffffffffc020012e:	0405                	addi	s0,s0,1
ffffffffc0200130:	4485                	li	s1,1
ffffffffc0200132:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200134:	009000ef          	jal	ra,ffffffffc020093c <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc0200138:	00044503          	lbu	a0,0(s0)
ffffffffc020013c:	008487bb          	addw	a5,s1,s0
ffffffffc0200140:	0405                	addi	s0,s0,1
ffffffffc0200142:	f96d                	bnez	a0,ffffffffc0200134 <cputs+0x16>
    (*cnt)++;
ffffffffc0200144:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200148:	4529                	li	a0,10
ffffffffc020014a:	7f2000ef          	jal	ra,ffffffffc020093c <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020014e:	60e2                	ld	ra,24(sp)
ffffffffc0200150:	8522                	mv	a0,s0
ffffffffc0200152:	6442                	ld	s0,16(sp)
ffffffffc0200154:	64a2                	ld	s1,8(sp)
ffffffffc0200156:	6105                	addi	sp,sp,32
ffffffffc0200158:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc020015a:	4405                	li	s0,1
ffffffffc020015c:	b7f5                	j	ffffffffc0200148 <cputs+0x2a>

ffffffffc020015e <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020015e:	1141                	addi	sp,sp,-16
ffffffffc0200160:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200162:	00f000ef          	jal	ra,ffffffffc0200970 <cons_getc>
ffffffffc0200166:	dd75                	beqz	a0,ffffffffc0200162 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
ffffffffc020016a:	0141                	addi	sp,sp,16
ffffffffc020016c:	8082                	ret

ffffffffc020016e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020016e:	715d                	addi	sp,sp,-80
ffffffffc0200170:	e486                	sd	ra,72(sp)
ffffffffc0200172:	e0a6                	sd	s1,64(sp)
ffffffffc0200174:	fc4a                	sd	s2,56(sp)
ffffffffc0200176:	f84e                	sd	s3,48(sp)
ffffffffc0200178:	f452                	sd	s4,40(sp)
ffffffffc020017a:	f056                	sd	s5,32(sp)
ffffffffc020017c:	ec5a                	sd	s6,24(sp)
ffffffffc020017e:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0200180:	c901                	beqz	a0,ffffffffc0200190 <readline+0x22>
ffffffffc0200182:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0200184:	00006517          	auipc	a0,0x6
ffffffffc0200188:	42450513          	addi	a0,a0,1060 # ffffffffc02065a8 <etext+0x2c>
ffffffffc020018c:	f59ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
readline(const char *prompt) {
ffffffffc0200190:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200192:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200194:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200196:	4aa9                	li	s5,10
ffffffffc0200198:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc020019a:	000dcb97          	auipc	s7,0xdc
ffffffffc020019e:	9a6b8b93          	addi	s7,s7,-1626 # ffffffffc02dbb40 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001a2:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02001a6:	fb9ff0ef          	jal	ra,ffffffffc020015e <getchar>
        if (c < 0) {
ffffffffc02001aa:	00054a63          	bltz	a0,ffffffffc02001be <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001ae:	00a95a63          	bge	s2,a0,ffffffffc02001c2 <readline+0x54>
ffffffffc02001b2:	029a5263          	bge	s4,s1,ffffffffc02001d6 <readline+0x68>
        c = getchar();
ffffffffc02001b6:	fa9ff0ef          	jal	ra,ffffffffc020015e <getchar>
        if (c < 0) {
ffffffffc02001ba:	fe055ae3          	bgez	a0,ffffffffc02001ae <readline+0x40>
            return NULL;
ffffffffc02001be:	4501                	li	a0,0
ffffffffc02001c0:	a091                	j	ffffffffc0200204 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02001c2:	03351463          	bne	a0,s3,ffffffffc02001ea <readline+0x7c>
ffffffffc02001c6:	e8a9                	bnez	s1,ffffffffc0200218 <readline+0xaa>
        c = getchar();
ffffffffc02001c8:	f97ff0ef          	jal	ra,ffffffffc020015e <getchar>
        if (c < 0) {
ffffffffc02001cc:	fe0549e3          	bltz	a0,ffffffffc02001be <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001d0:	fea959e3          	bge	s2,a0,ffffffffc02001c2 <readline+0x54>
ffffffffc02001d4:	4481                	li	s1,0
            cputchar(c);
ffffffffc02001d6:	e42a                	sd	a0,8(sp)
ffffffffc02001d8:	f43ff0ef          	jal	ra,ffffffffc020011a <cputchar>
            buf[i ++] = c;
ffffffffc02001dc:	6522                	ld	a0,8(sp)
ffffffffc02001de:	009b87b3          	add	a5,s7,s1
ffffffffc02001e2:	2485                	addiw	s1,s1,1
ffffffffc02001e4:	00a78023          	sb	a0,0(a5)
ffffffffc02001e8:	bf7d                	j	ffffffffc02001a6 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02001ea:	01550463          	beq	a0,s5,ffffffffc02001f2 <readline+0x84>
ffffffffc02001ee:	fb651ce3          	bne	a0,s6,ffffffffc02001a6 <readline+0x38>
            cputchar(c);
ffffffffc02001f2:	f29ff0ef          	jal	ra,ffffffffc020011a <cputchar>
            buf[i] = '\0';
ffffffffc02001f6:	000dc517          	auipc	a0,0xdc
ffffffffc02001fa:	94a50513          	addi	a0,a0,-1718 # ffffffffc02dbb40 <buf>
ffffffffc02001fe:	94aa                	add	s1,s1,a0
ffffffffc0200200:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200204:	60a6                	ld	ra,72(sp)
ffffffffc0200206:	6486                	ld	s1,64(sp)
ffffffffc0200208:	7962                	ld	s2,56(sp)
ffffffffc020020a:	79c2                	ld	s3,48(sp)
ffffffffc020020c:	7a22                	ld	s4,40(sp)
ffffffffc020020e:	7a82                	ld	s5,32(sp)
ffffffffc0200210:	6b62                	ld	s6,24(sp)
ffffffffc0200212:	6bc2                	ld	s7,16(sp)
ffffffffc0200214:	6161                	addi	sp,sp,80
ffffffffc0200216:	8082                	ret
            cputchar(c);
ffffffffc0200218:	4521                	li	a0,8
ffffffffc020021a:	f01ff0ef          	jal	ra,ffffffffc020011a <cputchar>
            i --;
ffffffffc020021e:	34fd                	addiw	s1,s1,-1
ffffffffc0200220:	b759                	j	ffffffffc02001a6 <readline+0x38>

ffffffffc0200222 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200222:	000e0317          	auipc	t1,0xe0
ffffffffc0200226:	ec630313          	addi	t1,t1,-314 # ffffffffc02e00e8 <is_panic>
ffffffffc020022a:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020022e:	715d                	addi	sp,sp,-80
ffffffffc0200230:	ec06                	sd	ra,24(sp)
ffffffffc0200232:	e822                	sd	s0,16(sp)
ffffffffc0200234:	f436                	sd	a3,40(sp)
ffffffffc0200236:	f83a                	sd	a4,48(sp)
ffffffffc0200238:	fc3e                	sd	a5,56(sp)
ffffffffc020023a:	e0c2                	sd	a6,64(sp)
ffffffffc020023c:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020023e:	020e1a63          	bnez	t3,ffffffffc0200272 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200242:	4785                	li	a5,1
ffffffffc0200244:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200248:	8432                	mv	s0,a2
ffffffffc020024a:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020024c:	862e                	mv	a2,a1
ffffffffc020024e:	85aa                	mv	a1,a0
ffffffffc0200250:	00006517          	auipc	a0,0x6
ffffffffc0200254:	36050513          	addi	a0,a0,864 # ffffffffc02065b0 <etext+0x34>
    va_start(ap, fmt);
ffffffffc0200258:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020025a:	e8bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020025e:	65a2                	ld	a1,8(sp)
ffffffffc0200260:	8522                	mv	a0,s0
ffffffffc0200262:	e63ff0ef          	jal	ra,ffffffffc02000c4 <vcprintf>
    cprintf("\n");
ffffffffc0200266:	00008517          	auipc	a0,0x8
ffffffffc020026a:	99250513          	addi	a0,a0,-1646 # ffffffffc0207bf8 <default_pmm_manager+0x488>
ffffffffc020026e:	e77ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200272:	4501                	li	a0,0
ffffffffc0200274:	4581                	li	a1,0
ffffffffc0200276:	4601                	li	a2,0
ffffffffc0200278:	48a1                	li	a7,8
ffffffffc020027a:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc020027e:	736000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200282:	4501                	li	a0,0
ffffffffc0200284:	174000ef          	jal	ra,ffffffffc02003f8 <kmonitor>
    while (1) {
ffffffffc0200288:	bfed                	j	ffffffffc0200282 <__panic+0x60>

ffffffffc020028a <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc020028a:	715d                	addi	sp,sp,-80
ffffffffc020028c:	832e                	mv	t1,a1
ffffffffc020028e:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200290:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200292:	8432                	mv	s0,a2
ffffffffc0200294:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200296:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200298:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020029a:	00006517          	auipc	a0,0x6
ffffffffc020029e:	33650513          	addi	a0,a0,822 # ffffffffc02065d0 <etext+0x54>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02002a2:	ec06                	sd	ra,24(sp)
ffffffffc02002a4:	f436                	sd	a3,40(sp)
ffffffffc02002a6:	f83a                	sd	a4,48(sp)
ffffffffc02002a8:	e0c2                	sd	a6,64(sp)
ffffffffc02002aa:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02002ac:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02002ae:	e37ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02002b2:	65a2                	ld	a1,8(sp)
ffffffffc02002b4:	8522                	mv	a0,s0
ffffffffc02002b6:	e0fff0ef          	jal	ra,ffffffffc02000c4 <vcprintf>
    cprintf("\n");
ffffffffc02002ba:	00008517          	auipc	a0,0x8
ffffffffc02002be:	93e50513          	addi	a0,a0,-1730 # ffffffffc0207bf8 <default_pmm_manager+0x488>
ffffffffc02002c2:	e23ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    va_end(ap);
}
ffffffffc02002c6:	60e2                	ld	ra,24(sp)
ffffffffc02002c8:	6442                	ld	s0,16(sp)
ffffffffc02002ca:	6161                	addi	sp,sp,80
ffffffffc02002cc:	8082                	ret

ffffffffc02002ce <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc02002ce:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02002d0:	00006517          	auipc	a0,0x6
ffffffffc02002d4:	32050513          	addi	a0,a0,800 # ffffffffc02065f0 <etext+0x74>
void print_kerninfo(void) {
ffffffffc02002d8:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02002da:	e0bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02002de:	00000597          	auipc	a1,0x0
ffffffffc02002e2:	d6c58593          	addi	a1,a1,-660 # ffffffffc020004a <kern_init>
ffffffffc02002e6:	00006517          	auipc	a0,0x6
ffffffffc02002ea:	32a50513          	addi	a0,a0,810 # ffffffffc0206610 <etext+0x94>
ffffffffc02002ee:	df7ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02002f2:	00006597          	auipc	a1,0x6
ffffffffc02002f6:	28a58593          	addi	a1,a1,650 # ffffffffc020657c <etext>
ffffffffc02002fa:	00006517          	auipc	a0,0x6
ffffffffc02002fe:	33650513          	addi	a0,a0,822 # ffffffffc0206630 <etext+0xb4>
ffffffffc0200302:	de3ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200306:	000dc597          	auipc	a1,0xdc
ffffffffc020030a:	83a58593          	addi	a1,a1,-1990 # ffffffffc02dbb40 <buf>
ffffffffc020030e:	00006517          	auipc	a0,0x6
ffffffffc0200312:	34250513          	addi	a0,a0,834 # ffffffffc0206650 <etext+0xd4>
ffffffffc0200316:	dcfff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc020031a:	000e0597          	auipc	a1,0xe0
ffffffffc020031e:	e5658593          	addi	a1,a1,-426 # ffffffffc02e0170 <end>
ffffffffc0200322:	00006517          	auipc	a0,0x6
ffffffffc0200326:	34e50513          	addi	a0,a0,846 # ffffffffc0206670 <etext+0xf4>
ffffffffc020032a:	dbbff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020032e:	000e0597          	auipc	a1,0xe0
ffffffffc0200332:	24158593          	addi	a1,a1,577 # ffffffffc02e056f <end+0x3ff>
ffffffffc0200336:	00000797          	auipc	a5,0x0
ffffffffc020033a:	d1478793          	addi	a5,a5,-748 # ffffffffc020004a <kern_init>
ffffffffc020033e:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200342:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200346:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200348:	3ff5f593          	andi	a1,a1,1023
ffffffffc020034c:	95be                	add	a1,a1,a5
ffffffffc020034e:	85a9                	srai	a1,a1,0xa
ffffffffc0200350:	00006517          	auipc	a0,0x6
ffffffffc0200354:	34050513          	addi	a0,a0,832 # ffffffffc0206690 <etext+0x114>
}
ffffffffc0200358:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020035a:	b369                	j	ffffffffc02000e4 <cprintf>

ffffffffc020035c <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc020035c:	1141                	addi	sp,sp,-16
    
    panic("Not Implemented!");
ffffffffc020035e:	00006617          	auipc	a2,0x6
ffffffffc0200362:	36260613          	addi	a2,a2,866 # ffffffffc02066c0 <etext+0x144>
ffffffffc0200366:	04e00593          	li	a1,78
ffffffffc020036a:	00006517          	auipc	a0,0x6
ffffffffc020036e:	36e50513          	addi	a0,a0,878 # ffffffffc02066d8 <etext+0x15c>
void print_stackframe(void) {
ffffffffc0200372:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200374:	eafff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0200378 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200378:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020037a:	00006617          	auipc	a2,0x6
ffffffffc020037e:	37660613          	addi	a2,a2,886 # ffffffffc02066f0 <etext+0x174>
ffffffffc0200382:	00006597          	auipc	a1,0x6
ffffffffc0200386:	38e58593          	addi	a1,a1,910 # ffffffffc0206710 <etext+0x194>
ffffffffc020038a:	00006517          	auipc	a0,0x6
ffffffffc020038e:	38e50513          	addi	a0,a0,910 # ffffffffc0206718 <etext+0x19c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200392:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200394:	d51ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc0200398:	00006617          	auipc	a2,0x6
ffffffffc020039c:	39060613          	addi	a2,a2,912 # ffffffffc0206728 <etext+0x1ac>
ffffffffc02003a0:	00006597          	auipc	a1,0x6
ffffffffc02003a4:	3b058593          	addi	a1,a1,944 # ffffffffc0206750 <etext+0x1d4>
ffffffffc02003a8:	00006517          	auipc	a0,0x6
ffffffffc02003ac:	37050513          	addi	a0,a0,880 # ffffffffc0206718 <etext+0x19c>
ffffffffc02003b0:	d35ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc02003b4:	00006617          	auipc	a2,0x6
ffffffffc02003b8:	3ac60613          	addi	a2,a2,940 # ffffffffc0206760 <etext+0x1e4>
ffffffffc02003bc:	00006597          	auipc	a1,0x6
ffffffffc02003c0:	3c458593          	addi	a1,a1,964 # ffffffffc0206780 <etext+0x204>
ffffffffc02003c4:	00006517          	auipc	a0,0x6
ffffffffc02003c8:	35450513          	addi	a0,a0,852 # ffffffffc0206718 <etext+0x19c>
ffffffffc02003cc:	d19ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    }
    return 0;
}
ffffffffc02003d0:	60a2                	ld	ra,8(sp)
ffffffffc02003d2:	4501                	li	a0,0
ffffffffc02003d4:	0141                	addi	sp,sp,16
ffffffffc02003d6:	8082                	ret

ffffffffc02003d8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02003d8:	1141                	addi	sp,sp,-16
ffffffffc02003da:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02003dc:	ef3ff0ef          	jal	ra,ffffffffc02002ce <print_kerninfo>
    return 0;
}
ffffffffc02003e0:	60a2                	ld	ra,8(sp)
ffffffffc02003e2:	4501                	li	a0,0
ffffffffc02003e4:	0141                	addi	sp,sp,16
ffffffffc02003e6:	8082                	ret

ffffffffc02003e8 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02003e8:	1141                	addi	sp,sp,-16
ffffffffc02003ea:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02003ec:	f71ff0ef          	jal	ra,ffffffffc020035c <print_stackframe>
    return 0;
}
ffffffffc02003f0:	60a2                	ld	ra,8(sp)
ffffffffc02003f2:	4501                	li	a0,0
ffffffffc02003f4:	0141                	addi	sp,sp,16
ffffffffc02003f6:	8082                	ret

ffffffffc02003f8 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02003f8:	7115                	addi	sp,sp,-224
ffffffffc02003fa:	ed5e                	sd	s7,152(sp)
ffffffffc02003fc:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02003fe:	00006517          	auipc	a0,0x6
ffffffffc0200402:	39250513          	addi	a0,a0,914 # ffffffffc0206790 <etext+0x214>
kmonitor(struct trapframe *tf) {
ffffffffc0200406:	ed86                	sd	ra,216(sp)
ffffffffc0200408:	e9a2                	sd	s0,208(sp)
ffffffffc020040a:	e5a6                	sd	s1,200(sp)
ffffffffc020040c:	e1ca                	sd	s2,192(sp)
ffffffffc020040e:	fd4e                	sd	s3,184(sp)
ffffffffc0200410:	f952                	sd	s4,176(sp)
ffffffffc0200412:	f556                	sd	s5,168(sp)
ffffffffc0200414:	f15a                	sd	s6,160(sp)
ffffffffc0200416:	e962                	sd	s8,144(sp)
ffffffffc0200418:	e566                	sd	s9,136(sp)
ffffffffc020041a:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020041c:	cc9ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200420:	00006517          	auipc	a0,0x6
ffffffffc0200424:	39850513          	addi	a0,a0,920 # ffffffffc02067b8 <etext+0x23c>
ffffffffc0200428:	cbdff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    if (tf != NULL) {
ffffffffc020042c:	000b8563          	beqz	s7,ffffffffc0200436 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200430:	855e                	mv	a0,s7
ffffffffc0200432:	770000ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
ffffffffc0200436:	00006c17          	auipc	s8,0x6
ffffffffc020043a:	3f2c0c13          	addi	s8,s8,1010 # ffffffffc0206828 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020043e:	00006917          	auipc	s2,0x6
ffffffffc0200442:	3a290913          	addi	s2,s2,930 # ffffffffc02067e0 <etext+0x264>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200446:	00006497          	auipc	s1,0x6
ffffffffc020044a:	3a248493          	addi	s1,s1,930 # ffffffffc02067e8 <etext+0x26c>
        if (argc == MAXARGS - 1) {
ffffffffc020044e:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200450:	00006b17          	auipc	s6,0x6
ffffffffc0200454:	3a0b0b13          	addi	s6,s6,928 # ffffffffc02067f0 <etext+0x274>
        argv[argc ++] = buf;
ffffffffc0200458:	00006a17          	auipc	s4,0x6
ffffffffc020045c:	2b8a0a13          	addi	s4,s4,696 # ffffffffc0206710 <etext+0x194>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200460:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200462:	854a                	mv	a0,s2
ffffffffc0200464:	d0bff0ef          	jal	ra,ffffffffc020016e <readline>
ffffffffc0200468:	842a                	mv	s0,a0
ffffffffc020046a:	dd65                	beqz	a0,ffffffffc0200462 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020046c:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200470:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200472:	e1bd                	bnez	a1,ffffffffc02004d8 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200474:	fe0c87e3          	beqz	s9,ffffffffc0200462 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200478:	6582                	ld	a1,0(sp)
ffffffffc020047a:	00006d17          	auipc	s10,0x6
ffffffffc020047e:	3aed0d13          	addi	s10,s10,942 # ffffffffc0206828 <commands>
        argv[argc ++] = buf;
ffffffffc0200482:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200484:	4401                	li	s0,0
ffffffffc0200486:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200488:	46d050ef          	jal	ra,ffffffffc02060f4 <strcmp>
ffffffffc020048c:	c919                	beqz	a0,ffffffffc02004a2 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020048e:	2405                	addiw	s0,s0,1
ffffffffc0200490:	0b540063          	beq	s0,s5,ffffffffc0200530 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200494:	000d3503          	ld	a0,0(s10)
ffffffffc0200498:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020049a:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020049c:	459050ef          	jal	ra,ffffffffc02060f4 <strcmp>
ffffffffc02004a0:	f57d                	bnez	a0,ffffffffc020048e <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02004a2:	00141793          	slli	a5,s0,0x1
ffffffffc02004a6:	97a2                	add	a5,a5,s0
ffffffffc02004a8:	078e                	slli	a5,a5,0x3
ffffffffc02004aa:	97e2                	add	a5,a5,s8
ffffffffc02004ac:	6b9c                	ld	a5,16(a5)
ffffffffc02004ae:	865e                	mv	a2,s7
ffffffffc02004b0:	002c                	addi	a1,sp,8
ffffffffc02004b2:	fffc851b          	addiw	a0,s9,-1
ffffffffc02004b6:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02004b8:	fa0555e3          	bgez	a0,ffffffffc0200462 <kmonitor+0x6a>
}
ffffffffc02004bc:	60ee                	ld	ra,216(sp)
ffffffffc02004be:	644e                	ld	s0,208(sp)
ffffffffc02004c0:	64ae                	ld	s1,200(sp)
ffffffffc02004c2:	690e                	ld	s2,192(sp)
ffffffffc02004c4:	79ea                	ld	s3,184(sp)
ffffffffc02004c6:	7a4a                	ld	s4,176(sp)
ffffffffc02004c8:	7aaa                	ld	s5,168(sp)
ffffffffc02004ca:	7b0a                	ld	s6,160(sp)
ffffffffc02004cc:	6bea                	ld	s7,152(sp)
ffffffffc02004ce:	6c4a                	ld	s8,144(sp)
ffffffffc02004d0:	6caa                	ld	s9,136(sp)
ffffffffc02004d2:	6d0a                	ld	s10,128(sp)
ffffffffc02004d4:	612d                	addi	sp,sp,224
ffffffffc02004d6:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02004d8:	8526                	mv	a0,s1
ffffffffc02004da:	45f050ef          	jal	ra,ffffffffc0206138 <strchr>
ffffffffc02004de:	c901                	beqz	a0,ffffffffc02004ee <kmonitor+0xf6>
ffffffffc02004e0:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02004e4:	00040023          	sb	zero,0(s0)
ffffffffc02004e8:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02004ea:	d5c9                	beqz	a1,ffffffffc0200474 <kmonitor+0x7c>
ffffffffc02004ec:	b7f5                	j	ffffffffc02004d8 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc02004ee:	00044783          	lbu	a5,0(s0)
ffffffffc02004f2:	d3c9                	beqz	a5,ffffffffc0200474 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc02004f4:	033c8963          	beq	s9,s3,ffffffffc0200526 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc02004f8:	003c9793          	slli	a5,s9,0x3
ffffffffc02004fc:	0118                	addi	a4,sp,128
ffffffffc02004fe:	97ba                	add	a5,a5,a4
ffffffffc0200500:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200504:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200508:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020050a:	e591                	bnez	a1,ffffffffc0200516 <kmonitor+0x11e>
ffffffffc020050c:	b7b5                	j	ffffffffc0200478 <kmonitor+0x80>
ffffffffc020050e:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200512:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200514:	d1a5                	beqz	a1,ffffffffc0200474 <kmonitor+0x7c>
ffffffffc0200516:	8526                	mv	a0,s1
ffffffffc0200518:	421050ef          	jal	ra,ffffffffc0206138 <strchr>
ffffffffc020051c:	d96d                	beqz	a0,ffffffffc020050e <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020051e:	00044583          	lbu	a1,0(s0)
ffffffffc0200522:	d9a9                	beqz	a1,ffffffffc0200474 <kmonitor+0x7c>
ffffffffc0200524:	bf55                	j	ffffffffc02004d8 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200526:	45c1                	li	a1,16
ffffffffc0200528:	855a                	mv	a0,s6
ffffffffc020052a:	bbbff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc020052e:	b7e9                	j	ffffffffc02004f8 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200530:	6582                	ld	a1,0(sp)
ffffffffc0200532:	00006517          	auipc	a0,0x6
ffffffffc0200536:	2de50513          	addi	a0,a0,734 # ffffffffc0206810 <etext+0x294>
ffffffffc020053a:	babff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return 0;
ffffffffc020053e:	b715                	j	ffffffffc0200462 <kmonitor+0x6a>

ffffffffc0200540 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200540:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200542:	00006517          	auipc	a0,0x6
ffffffffc0200546:	32e50513          	addi	a0,a0,814 # ffffffffc0206870 <commands+0x48>
void dtb_init(void) {
ffffffffc020054a:	fc86                	sd	ra,120(sp)
ffffffffc020054c:	f8a2                	sd	s0,112(sp)
ffffffffc020054e:	e8d2                	sd	s4,80(sp)
ffffffffc0200550:	f4a6                	sd	s1,104(sp)
ffffffffc0200552:	f0ca                	sd	s2,96(sp)
ffffffffc0200554:	ecce                	sd	s3,88(sp)
ffffffffc0200556:	e4d6                	sd	s5,72(sp)
ffffffffc0200558:	e0da                	sd	s6,64(sp)
ffffffffc020055a:	fc5e                	sd	s7,56(sp)
ffffffffc020055c:	f862                	sd	s8,48(sp)
ffffffffc020055e:	f466                	sd	s9,40(sp)
ffffffffc0200560:	f06a                	sd	s10,32(sp)
ffffffffc0200562:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200564:	b81ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200568:	0000d597          	auipc	a1,0xd
ffffffffc020056c:	a985b583          	ld	a1,-1384(a1) # ffffffffc020d000 <boot_hartid>
ffffffffc0200570:	00006517          	auipc	a0,0x6
ffffffffc0200574:	31050513          	addi	a0,a0,784 # ffffffffc0206880 <commands+0x58>
ffffffffc0200578:	b6dff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020057c:	0000d417          	auipc	s0,0xd
ffffffffc0200580:	a8c40413          	addi	s0,s0,-1396 # ffffffffc020d008 <boot_dtb>
ffffffffc0200584:	600c                	ld	a1,0(s0)
ffffffffc0200586:	00006517          	auipc	a0,0x6
ffffffffc020058a:	30a50513          	addi	a0,a0,778 # ffffffffc0206890 <commands+0x68>
ffffffffc020058e:	b57ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200592:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200596:	00006517          	auipc	a0,0x6
ffffffffc020059a:	31250513          	addi	a0,a0,786 # ffffffffc02068a8 <commands+0x80>
    if (boot_dtb == 0) {
ffffffffc020059e:	120a0463          	beqz	s4,ffffffffc02006c6 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02005a2:	57f5                	li	a5,-3
ffffffffc02005a4:	07fa                	slli	a5,a5,0x1e
ffffffffc02005a6:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02005aa:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ac:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b0:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b2:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005b6:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ba:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005be:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c2:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c6:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c8:	8ec9                	or	a3,a3,a0
ffffffffc02005ca:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005ce:	1b7d                	addi	s6,s6,-1
ffffffffc02005d0:	0167f7b3          	and	a5,a5,s6
ffffffffc02005d4:	8dd5                	or	a1,a1,a3
ffffffffc02005d6:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02005d8:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005dc:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02005de:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfdffd7d>
ffffffffc02005e2:	10f59163          	bne	a1,a5,ffffffffc02006e4 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005e6:	471c                	lw	a5,8(a4)
ffffffffc02005e8:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02005ea:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ec:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005f0:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02005f4:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f8:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005fc:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200600:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200604:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200608:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020060c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200610:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200614:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200616:	01146433          	or	s0,s0,a7
ffffffffc020061a:	0086969b          	slliw	a3,a3,0x8
ffffffffc020061e:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200622:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200624:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200628:	8c49                	or	s0,s0,a0
ffffffffc020062a:	0166f6b3          	and	a3,a3,s6
ffffffffc020062e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200632:	0167f7b3          	and	a5,a5,s6
ffffffffc0200636:	8c55                	or	s0,s0,a3
ffffffffc0200638:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020063c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020063e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200640:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200642:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200646:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200648:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020064a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020064e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200650:	00006917          	auipc	s2,0x6
ffffffffc0200654:	2a890913          	addi	s2,s2,680 # ffffffffc02068f8 <commands+0xd0>
ffffffffc0200658:	49bd                	li	s3,15
        switch (token) {
ffffffffc020065a:	4d91                	li	s11,4
ffffffffc020065c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020065e:	00006497          	auipc	s1,0x6
ffffffffc0200662:	29248493          	addi	s1,s1,658 # ffffffffc02068f0 <commands+0xc8>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200666:	000a2703          	lw	a4,0(s4)
ffffffffc020066a:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066e:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200672:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200676:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067a:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067e:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200682:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200688:	0087171b          	slliw	a4,a4,0x8
ffffffffc020068c:	8fd5                	or	a5,a5,a3
ffffffffc020068e:	00eb7733          	and	a4,s6,a4
ffffffffc0200692:	8fd9                	or	a5,a5,a4
ffffffffc0200694:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200696:	09778c63          	beq	a5,s7,ffffffffc020072e <dtb_init+0x1ee>
ffffffffc020069a:	00fbea63          	bltu	s7,a5,ffffffffc02006ae <dtb_init+0x16e>
ffffffffc020069e:	07a78663          	beq	a5,s10,ffffffffc020070a <dtb_init+0x1ca>
ffffffffc02006a2:	4709                	li	a4,2
ffffffffc02006a4:	00e79763          	bne	a5,a4,ffffffffc02006b2 <dtb_init+0x172>
ffffffffc02006a8:	4c81                	li	s9,0
ffffffffc02006aa:	8a56                	mv	s4,s5
ffffffffc02006ac:	bf6d                	j	ffffffffc0200666 <dtb_init+0x126>
ffffffffc02006ae:	ffb78ee3          	beq	a5,s11,ffffffffc02006aa <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006b2:	00006517          	auipc	a0,0x6
ffffffffc02006b6:	2be50513          	addi	a0,a0,702 # ffffffffc0206970 <commands+0x148>
ffffffffc02006ba:	a2bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006be:	00006517          	auipc	a0,0x6
ffffffffc02006c2:	2ea50513          	addi	a0,a0,746 # ffffffffc02069a8 <commands+0x180>
}
ffffffffc02006c6:	7446                	ld	s0,112(sp)
ffffffffc02006c8:	70e6                	ld	ra,120(sp)
ffffffffc02006ca:	74a6                	ld	s1,104(sp)
ffffffffc02006cc:	7906                	ld	s2,96(sp)
ffffffffc02006ce:	69e6                	ld	s3,88(sp)
ffffffffc02006d0:	6a46                	ld	s4,80(sp)
ffffffffc02006d2:	6aa6                	ld	s5,72(sp)
ffffffffc02006d4:	6b06                	ld	s6,64(sp)
ffffffffc02006d6:	7be2                	ld	s7,56(sp)
ffffffffc02006d8:	7c42                	ld	s8,48(sp)
ffffffffc02006da:	7ca2                	ld	s9,40(sp)
ffffffffc02006dc:	7d02                	ld	s10,32(sp)
ffffffffc02006de:	6de2                	ld	s11,24(sp)
ffffffffc02006e0:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02006e2:	b409                	j	ffffffffc02000e4 <cprintf>
}
ffffffffc02006e4:	7446                	ld	s0,112(sp)
ffffffffc02006e6:	70e6                	ld	ra,120(sp)
ffffffffc02006e8:	74a6                	ld	s1,104(sp)
ffffffffc02006ea:	7906                	ld	s2,96(sp)
ffffffffc02006ec:	69e6                	ld	s3,88(sp)
ffffffffc02006ee:	6a46                	ld	s4,80(sp)
ffffffffc02006f0:	6aa6                	ld	s5,72(sp)
ffffffffc02006f2:	6b06                	ld	s6,64(sp)
ffffffffc02006f4:	7be2                	ld	s7,56(sp)
ffffffffc02006f6:	7c42                	ld	s8,48(sp)
ffffffffc02006f8:	7ca2                	ld	s9,40(sp)
ffffffffc02006fa:	7d02                	ld	s10,32(sp)
ffffffffc02006fc:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02006fe:	00006517          	auipc	a0,0x6
ffffffffc0200702:	1ca50513          	addi	a0,a0,458 # ffffffffc02068c8 <commands+0xa0>
}
ffffffffc0200706:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200708:	baf1                	j	ffffffffc02000e4 <cprintf>
                int name_len = strlen(name);
ffffffffc020070a:	8556                	mv	a0,s5
ffffffffc020070c:	1a1050ef          	jal	ra,ffffffffc02060ac <strlen>
ffffffffc0200710:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200712:	4619                	li	a2,6
ffffffffc0200714:	85a6                	mv	a1,s1
ffffffffc0200716:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200718:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071a:	1f9050ef          	jal	ra,ffffffffc0206112 <strncmp>
ffffffffc020071e:	e111                	bnez	a0,ffffffffc0200722 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200720:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200722:	0a91                	addi	s5,s5,4
ffffffffc0200724:	9ad2                	add	s5,s5,s4
ffffffffc0200726:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020072a:	8a56                	mv	s4,s5
ffffffffc020072c:	bf2d                	j	ffffffffc0200666 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020072e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200732:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200736:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020073a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020074a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020074e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200752:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200756:	00eaeab3          	or	s5,s5,a4
ffffffffc020075a:	00fb77b3          	and	a5,s6,a5
ffffffffc020075e:	00faeab3          	or	s5,s5,a5
ffffffffc0200762:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200764:	000c9c63          	bnez	s9,ffffffffc020077c <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200768:	1a82                	slli	s5,s5,0x20
ffffffffc020076a:	00368793          	addi	a5,a3,3
ffffffffc020076e:	020ada93          	srli	s5,s5,0x20
ffffffffc0200772:	9abe                	add	s5,s5,a5
ffffffffc0200774:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200778:	8a56                	mv	s4,s5
ffffffffc020077a:	b5f5                	j	ffffffffc0200666 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020077c:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200780:	85ca                	mv	a1,s2
ffffffffc0200782:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200784:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200788:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020078c:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200790:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200794:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200798:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020079a:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020079e:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007a2:	8d59                	or	a0,a0,a4
ffffffffc02007a4:	00fb77b3          	and	a5,s6,a5
ffffffffc02007a8:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007aa:	1502                	slli	a0,a0,0x20
ffffffffc02007ac:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007ae:	9522                	add	a0,a0,s0
ffffffffc02007b0:	145050ef          	jal	ra,ffffffffc02060f4 <strcmp>
ffffffffc02007b4:	66a2                	ld	a3,8(sp)
ffffffffc02007b6:	f94d                	bnez	a0,ffffffffc0200768 <dtb_init+0x228>
ffffffffc02007b8:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200768 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007bc:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007c0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007c4:	00006517          	auipc	a0,0x6
ffffffffc02007c8:	13c50513          	addi	a0,a0,316 # ffffffffc0206900 <commands+0xd8>
           fdt32_to_cpu(x >> 32);
ffffffffc02007cc:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d0:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007d4:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d8:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02007dc:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007e0:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e4:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007e8:	0187d693          	srli	a3,a5,0x18
ffffffffc02007ec:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02007f0:	0087579b          	srliw	a5,a4,0x8
ffffffffc02007f4:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f8:	0106561b          	srliw	a2,a2,0x10
ffffffffc02007fc:	010f6f33          	or	t5,t5,a6
ffffffffc0200800:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200804:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200808:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020080c:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200810:	0186f6b3          	and	a3,a3,s8
ffffffffc0200814:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200818:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020081c:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200820:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200824:	8361                	srli	a4,a4,0x18
ffffffffc0200826:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020082a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020082e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200832:	00cb7633          	and	a2,s6,a2
ffffffffc0200836:	0088181b          	slliw	a6,a6,0x8
ffffffffc020083a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020083e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200852:	011b78b3          	and	a7,s6,a7
ffffffffc0200856:	005eeeb3          	or	t4,t4,t0
ffffffffc020085a:	00c6e733          	or	a4,a3,a2
ffffffffc020085e:	006c6c33          	or	s8,s8,t1
ffffffffc0200862:	010b76b3          	and	a3,s6,a6
ffffffffc0200866:	00bb7b33          	and	s6,s6,a1
ffffffffc020086a:	01d7e7b3          	or	a5,a5,t4
ffffffffc020086e:	016c6b33          	or	s6,s8,s6
ffffffffc0200872:	01146433          	or	s0,s0,a7
ffffffffc0200876:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200878:	1702                	slli	a4,a4,0x20
ffffffffc020087a:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020087c:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020087e:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200880:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200882:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200886:	0167eb33          	or	s6,a5,s6
ffffffffc020088a:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020088c:	859ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200890:	85a2                	mv	a1,s0
ffffffffc0200892:	00006517          	auipc	a0,0x6
ffffffffc0200896:	08e50513          	addi	a0,a0,142 # ffffffffc0206920 <commands+0xf8>
ffffffffc020089a:	84bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020089e:	014b5613          	srli	a2,s6,0x14
ffffffffc02008a2:	85da                	mv	a1,s6
ffffffffc02008a4:	00006517          	auipc	a0,0x6
ffffffffc02008a8:	09450513          	addi	a0,a0,148 # ffffffffc0206938 <commands+0x110>
ffffffffc02008ac:	839ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008b0:	008b05b3          	add	a1,s6,s0
ffffffffc02008b4:	15fd                	addi	a1,a1,-1
ffffffffc02008b6:	00006517          	auipc	a0,0x6
ffffffffc02008ba:	0a250513          	addi	a0,a0,162 # ffffffffc0206958 <commands+0x130>
ffffffffc02008be:	827ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02008c2:	00006517          	auipc	a0,0x6
ffffffffc02008c6:	0e650513          	addi	a0,a0,230 # ffffffffc02069a8 <commands+0x180>
        memory_base = mem_base;
ffffffffc02008ca:	000e0797          	auipc	a5,0xe0
ffffffffc02008ce:	8287b323          	sd	s0,-2010(a5) # ffffffffc02e00f0 <memory_base>
        memory_size = mem_size;
ffffffffc02008d2:	000e0797          	auipc	a5,0xe0
ffffffffc02008d6:	8367b323          	sd	s6,-2010(a5) # ffffffffc02e00f8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02008da:	b3f5                	j	ffffffffc02006c6 <dtb_init+0x186>

ffffffffc02008dc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008dc:	000e0517          	auipc	a0,0xe0
ffffffffc02008e0:	81453503          	ld	a0,-2028(a0) # ffffffffc02e00f0 <memory_base>
ffffffffc02008e4:	8082                	ret

ffffffffc02008e6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008e6:	000e0517          	auipc	a0,0xe0
ffffffffc02008ea:	81253503          	ld	a0,-2030(a0) # ffffffffc02e00f8 <memory_size>
ffffffffc02008ee:	8082                	ret

ffffffffc02008f0 <clock_init>:
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);
ffffffffc02008f0:	02000793          	li	a5,32
ffffffffc02008f4:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02008f8:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02008fc:	67e1                	lui	a5,0x18
ffffffffc02008fe:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbd60>
ffffffffc0200902:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200904:	4581                	li	a1,0
ffffffffc0200906:	4601                	li	a2,0
ffffffffc0200908:	4881                	li	a7,0
ffffffffc020090a:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc020090e:	00006517          	auipc	a0,0x6
ffffffffc0200912:	0b250513          	addi	a0,a0,178 # ffffffffc02069c0 <commands+0x198>
    ticks = 0;
ffffffffc0200916:	000df797          	auipc	a5,0xdf
ffffffffc020091a:	7e07b523          	sd	zero,2026(a5) # ffffffffc02e0100 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020091e:	fc6ff06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0200922 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200922:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200926:	67e1                	lui	a5,0x18
ffffffffc0200928:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbd60>
ffffffffc020092c:	953e                	add	a0,a0,a5
ffffffffc020092e:	4581                	li	a1,0
ffffffffc0200930:	4601                	li	a2,0
ffffffffc0200932:	4881                	li	a7,0
ffffffffc0200934:	00000073          	ecall
ffffffffc0200938:	8082                	ret

ffffffffc020093a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020093a:	8082                	ret

ffffffffc020093c <cons_putc>:
#include <riscv.h>
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020093c:	100027f3          	csrr	a5,sstatus
ffffffffc0200940:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200942:	0ff57513          	zext.b	a0,a0
ffffffffc0200946:	e799                	bnez	a5,ffffffffc0200954 <cons_putc+0x18>
ffffffffc0200948:	4581                	li	a1,0
ffffffffc020094a:	4601                	li	a2,0
ffffffffc020094c:	4885                	li	a7,1
ffffffffc020094e:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200952:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200954:	1101                	addi	sp,sp,-32
ffffffffc0200956:	ec06                	sd	ra,24(sp)
ffffffffc0200958:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020095a:	05a000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020095e:	6522                	ld	a0,8(sp)
ffffffffc0200960:	4581                	li	a1,0
ffffffffc0200962:	4601                	li	a2,0
ffffffffc0200964:	4885                	li	a7,1
ffffffffc0200966:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020096a:	60e2                	ld	ra,24(sp)
ffffffffc020096c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020096e:	a081                	j	ffffffffc02009ae <intr_enable>

ffffffffc0200970 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200970:	100027f3          	csrr	a5,sstatus
ffffffffc0200974:	8b89                	andi	a5,a5,2
ffffffffc0200976:	eb89                	bnez	a5,ffffffffc0200988 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200978:	4501                	li	a0,0
ffffffffc020097a:	4581                	li	a1,0
ffffffffc020097c:	4601                	li	a2,0
ffffffffc020097e:	4889                	li	a7,2
ffffffffc0200980:	00000073          	ecall
ffffffffc0200984:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200986:	8082                	ret
int cons_getc(void) {
ffffffffc0200988:	1101                	addi	sp,sp,-32
ffffffffc020098a:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020098c:	028000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0200990:	4501                	li	a0,0
ffffffffc0200992:	4581                	li	a1,0
ffffffffc0200994:	4601                	li	a2,0
ffffffffc0200996:	4889                	li	a7,2
ffffffffc0200998:	00000073          	ecall
ffffffffc020099c:	2501                	sext.w	a0,a0
ffffffffc020099e:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02009a0:	00e000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02009a4:	60e2                	ld	ra,24(sp)
ffffffffc02009a6:	6522                	ld	a0,8(sp)
ffffffffc02009a8:	6105                	addi	sp,sp,32
ffffffffc02009aa:	8082                	ret

ffffffffc02009ac <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009ba:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009be:	00000797          	auipc	a5,0x0
ffffffffc02009c2:	52a78793          	addi	a5,a5,1322 # ffffffffc0200ee8 <__alltraps>
ffffffffc02009c6:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009ca:	000407b7          	lui	a5,0x40
ffffffffc02009ce:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d2:	8082                	ret

ffffffffc02009d4 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d4:	610c                	ld	a1,0(a0)
{
ffffffffc02009d6:	1141                	addi	sp,sp,-16
ffffffffc02009d8:	e022                	sd	s0,0(sp)
ffffffffc02009da:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009dc:	00006517          	auipc	a0,0x6
ffffffffc02009e0:	00450513          	addi	a0,a0,4 # ffffffffc02069e0 <commands+0x1b8>
{
ffffffffc02009e4:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e6:	efeff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ea:	640c                	ld	a1,8(s0)
ffffffffc02009ec:	00006517          	auipc	a0,0x6
ffffffffc02009f0:	00c50513          	addi	a0,a0,12 # ffffffffc02069f8 <commands+0x1d0>
ffffffffc02009f4:	ef0ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009f8:	680c                	ld	a1,16(s0)
ffffffffc02009fa:	00006517          	auipc	a0,0x6
ffffffffc02009fe:	01650513          	addi	a0,a0,22 # ffffffffc0206a10 <commands+0x1e8>
ffffffffc0200a02:	ee2ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a06:	6c0c                	ld	a1,24(s0)
ffffffffc0200a08:	00006517          	auipc	a0,0x6
ffffffffc0200a0c:	02050513          	addi	a0,a0,32 # ffffffffc0206a28 <commands+0x200>
ffffffffc0200a10:	ed4ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a14:	700c                	ld	a1,32(s0)
ffffffffc0200a16:	00006517          	auipc	a0,0x6
ffffffffc0200a1a:	02a50513          	addi	a0,a0,42 # ffffffffc0206a40 <commands+0x218>
ffffffffc0200a1e:	ec6ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a22:	740c                	ld	a1,40(s0)
ffffffffc0200a24:	00006517          	auipc	a0,0x6
ffffffffc0200a28:	03450513          	addi	a0,a0,52 # ffffffffc0206a58 <commands+0x230>
ffffffffc0200a2c:	eb8ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a30:	780c                	ld	a1,48(s0)
ffffffffc0200a32:	00006517          	auipc	a0,0x6
ffffffffc0200a36:	03e50513          	addi	a0,a0,62 # ffffffffc0206a70 <commands+0x248>
ffffffffc0200a3a:	eaaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a3e:	7c0c                	ld	a1,56(s0)
ffffffffc0200a40:	00006517          	auipc	a0,0x6
ffffffffc0200a44:	04850513          	addi	a0,a0,72 # ffffffffc0206a88 <commands+0x260>
ffffffffc0200a48:	e9cff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4c:	602c                	ld	a1,64(s0)
ffffffffc0200a4e:	00006517          	auipc	a0,0x6
ffffffffc0200a52:	05250513          	addi	a0,a0,82 # ffffffffc0206aa0 <commands+0x278>
ffffffffc0200a56:	e8eff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5a:	642c                	ld	a1,72(s0)
ffffffffc0200a5c:	00006517          	auipc	a0,0x6
ffffffffc0200a60:	05c50513          	addi	a0,a0,92 # ffffffffc0206ab8 <commands+0x290>
ffffffffc0200a64:	e80ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a68:	682c                	ld	a1,80(s0)
ffffffffc0200a6a:	00006517          	auipc	a0,0x6
ffffffffc0200a6e:	06650513          	addi	a0,a0,102 # ffffffffc0206ad0 <commands+0x2a8>
ffffffffc0200a72:	e72ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a76:	6c2c                	ld	a1,88(s0)
ffffffffc0200a78:	00006517          	auipc	a0,0x6
ffffffffc0200a7c:	07050513          	addi	a0,a0,112 # ffffffffc0206ae8 <commands+0x2c0>
ffffffffc0200a80:	e64ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a84:	702c                	ld	a1,96(s0)
ffffffffc0200a86:	00006517          	auipc	a0,0x6
ffffffffc0200a8a:	07a50513          	addi	a0,a0,122 # ffffffffc0206b00 <commands+0x2d8>
ffffffffc0200a8e:	e56ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a92:	742c                	ld	a1,104(s0)
ffffffffc0200a94:	00006517          	auipc	a0,0x6
ffffffffc0200a98:	08450513          	addi	a0,a0,132 # ffffffffc0206b18 <commands+0x2f0>
ffffffffc0200a9c:	e48ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa0:	782c                	ld	a1,112(s0)
ffffffffc0200aa2:	00006517          	auipc	a0,0x6
ffffffffc0200aa6:	08e50513          	addi	a0,a0,142 # ffffffffc0206b30 <commands+0x308>
ffffffffc0200aaa:	e3aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200aae:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab0:	00006517          	auipc	a0,0x6
ffffffffc0200ab4:	09850513          	addi	a0,a0,152 # ffffffffc0206b48 <commands+0x320>
ffffffffc0200ab8:	e2cff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abc:	604c                	ld	a1,128(s0)
ffffffffc0200abe:	00006517          	auipc	a0,0x6
ffffffffc0200ac2:	0a250513          	addi	a0,a0,162 # ffffffffc0206b60 <commands+0x338>
ffffffffc0200ac6:	e1eff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200aca:	644c                	ld	a1,136(s0)
ffffffffc0200acc:	00006517          	auipc	a0,0x6
ffffffffc0200ad0:	0ac50513          	addi	a0,a0,172 # ffffffffc0206b78 <commands+0x350>
ffffffffc0200ad4:	e10ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ad8:	684c                	ld	a1,144(s0)
ffffffffc0200ada:	00006517          	auipc	a0,0x6
ffffffffc0200ade:	0b650513          	addi	a0,a0,182 # ffffffffc0206b90 <commands+0x368>
ffffffffc0200ae2:	e02ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae6:	6c4c                	ld	a1,152(s0)
ffffffffc0200ae8:	00006517          	auipc	a0,0x6
ffffffffc0200aec:	0c050513          	addi	a0,a0,192 # ffffffffc0206ba8 <commands+0x380>
ffffffffc0200af0:	df4ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af4:	704c                	ld	a1,160(s0)
ffffffffc0200af6:	00006517          	auipc	a0,0x6
ffffffffc0200afa:	0ca50513          	addi	a0,a0,202 # ffffffffc0206bc0 <commands+0x398>
ffffffffc0200afe:	de6ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b02:	744c                	ld	a1,168(s0)
ffffffffc0200b04:	00006517          	auipc	a0,0x6
ffffffffc0200b08:	0d450513          	addi	a0,a0,212 # ffffffffc0206bd8 <commands+0x3b0>
ffffffffc0200b0c:	dd8ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b10:	784c                	ld	a1,176(s0)
ffffffffc0200b12:	00006517          	auipc	a0,0x6
ffffffffc0200b16:	0de50513          	addi	a0,a0,222 # ffffffffc0206bf0 <commands+0x3c8>
ffffffffc0200b1a:	dcaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b1e:	7c4c                	ld	a1,184(s0)
ffffffffc0200b20:	00006517          	auipc	a0,0x6
ffffffffc0200b24:	0e850513          	addi	a0,a0,232 # ffffffffc0206c08 <commands+0x3e0>
ffffffffc0200b28:	dbcff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2c:	606c                	ld	a1,192(s0)
ffffffffc0200b2e:	00006517          	auipc	a0,0x6
ffffffffc0200b32:	0f250513          	addi	a0,a0,242 # ffffffffc0206c20 <commands+0x3f8>
ffffffffc0200b36:	daeff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3a:	646c                	ld	a1,200(s0)
ffffffffc0200b3c:	00006517          	auipc	a0,0x6
ffffffffc0200b40:	0fc50513          	addi	a0,a0,252 # ffffffffc0206c38 <commands+0x410>
ffffffffc0200b44:	da0ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b48:	686c                	ld	a1,208(s0)
ffffffffc0200b4a:	00006517          	auipc	a0,0x6
ffffffffc0200b4e:	10650513          	addi	a0,a0,262 # ffffffffc0206c50 <commands+0x428>
ffffffffc0200b52:	d92ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b56:	6c6c                	ld	a1,216(s0)
ffffffffc0200b58:	00006517          	auipc	a0,0x6
ffffffffc0200b5c:	11050513          	addi	a0,a0,272 # ffffffffc0206c68 <commands+0x440>
ffffffffc0200b60:	d84ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b64:	706c                	ld	a1,224(s0)
ffffffffc0200b66:	00006517          	auipc	a0,0x6
ffffffffc0200b6a:	11a50513          	addi	a0,a0,282 # ffffffffc0206c80 <commands+0x458>
ffffffffc0200b6e:	d76ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b72:	746c                	ld	a1,232(s0)
ffffffffc0200b74:	00006517          	auipc	a0,0x6
ffffffffc0200b78:	12450513          	addi	a0,a0,292 # ffffffffc0206c98 <commands+0x470>
ffffffffc0200b7c:	d68ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b80:	786c                	ld	a1,240(s0)
ffffffffc0200b82:	00006517          	auipc	a0,0x6
ffffffffc0200b86:	12e50513          	addi	a0,a0,302 # ffffffffc0206cb0 <commands+0x488>
ffffffffc0200b8a:	d5aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b8e:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b90:	6402                	ld	s0,0(sp)
ffffffffc0200b92:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b94:	00006517          	auipc	a0,0x6
ffffffffc0200b98:	13450513          	addi	a0,a0,308 # ffffffffc0206cc8 <commands+0x4a0>
}
ffffffffc0200b9c:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b9e:	d46ff06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0200ba2 <print_trapframe>:
{
ffffffffc0200ba2:	1141                	addi	sp,sp,-16
ffffffffc0200ba4:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba6:	85aa                	mv	a1,a0
{
ffffffffc0200ba8:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200baa:	00006517          	auipc	a0,0x6
ffffffffc0200bae:	13650513          	addi	a0,a0,310 # ffffffffc0206ce0 <commands+0x4b8>
{
ffffffffc0200bb2:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb4:	d30ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bb8:	8522                	mv	a0,s0
ffffffffc0200bba:	e1bff0ef          	jal	ra,ffffffffc02009d4 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bbe:	10043583          	ld	a1,256(s0)
ffffffffc0200bc2:	00006517          	auipc	a0,0x6
ffffffffc0200bc6:	13650513          	addi	a0,a0,310 # ffffffffc0206cf8 <commands+0x4d0>
ffffffffc0200bca:	d1aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bce:	10843583          	ld	a1,264(s0)
ffffffffc0200bd2:	00006517          	auipc	a0,0x6
ffffffffc0200bd6:	13e50513          	addi	a0,a0,318 # ffffffffc0206d10 <commands+0x4e8>
ffffffffc0200bda:	d0aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200bde:	11043583          	ld	a1,272(s0)
ffffffffc0200be2:	00006517          	auipc	a0,0x6
ffffffffc0200be6:	14650513          	addi	a0,a0,326 # ffffffffc0206d28 <commands+0x500>
ffffffffc0200bea:	cfaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bee:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf2:	6402                	ld	s0,0(sp)
ffffffffc0200bf4:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf6:	00006517          	auipc	a0,0x6
ffffffffc0200bfa:	14250513          	addi	a0,a0,322 # ffffffffc0206d38 <commands+0x510>
}
ffffffffc0200bfe:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c00:	ce4ff06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0200c04 <pgfault_handler>:
pgfault_handler(struct trapframe *tf) {
ffffffffc0200c04:	1141                	addi	sp,sp,-16
ffffffffc0200c06:	e406                	sd	ra,8(sp)
    if (current == NULL) {
ffffffffc0200c08:	000df797          	auipc	a5,0xdf
ffffffffc0200c0c:	5387b783          	ld	a5,1336(a5) # ffffffffc02e0140 <current>
ffffffffc0200c10:	c799                	beqz	a5,ffffffffc0200c1e <pgfault_handler+0x1a>
    if (current->mm == NULL) {
ffffffffc0200c12:	779c                	ld	a5,40(a5)
ffffffffc0200c14:	c39d                	beqz	a5,ffffffffc0200c3a <pgfault_handler+0x36>
}
ffffffffc0200c16:	60a2                	ld	ra,8(sp)
ffffffffc0200c18:	5575                	li	a0,-3
ffffffffc0200c1a:	0141                	addi	sp,sp,16
ffffffffc0200c1c:	8082                	ret
        print_trapframe(tf);
ffffffffc0200c1e:	f85ff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
        panic("page fault in kernel!");
ffffffffc0200c22:	00006617          	auipc	a2,0x6
ffffffffc0200c26:	12e60613          	addi	a2,a2,302 # ffffffffc0206d50 <commands+0x528>
ffffffffc0200c2a:	02500593          	li	a1,37
ffffffffc0200c2e:	00006517          	auipc	a0,0x6
ffffffffc0200c32:	13a50513          	addi	a0,a0,314 # ffffffffc0206d68 <commands+0x540>
ffffffffc0200c36:	decff0ef          	jal	ra,ffffffffc0200222 <__panic>
        print_trapframe(tf);
ffffffffc0200c3a:	f69ff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
        panic("page fault in kernel thread!");
ffffffffc0200c3e:	00006617          	auipc	a2,0x6
ffffffffc0200c42:	14260613          	addi	a2,a2,322 # ffffffffc0206d80 <commands+0x558>
ffffffffc0200c46:	02a00593          	li	a1,42
ffffffffc0200c4a:	00006517          	auipc	a0,0x6
ffffffffc0200c4e:	11e50513          	addi	a0,a0,286 # ffffffffc0206d68 <commands+0x540>
ffffffffc0200c52:	dd0ff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0200c56 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c56:	11853783          	ld	a5,280(a0)
ffffffffc0200c5a:	472d                	li	a4,11
ffffffffc0200c5c:	0786                	slli	a5,a5,0x1
ffffffffc0200c5e:	8385                	srli	a5,a5,0x1
ffffffffc0200c60:	06f76863          	bltu	a4,a5,ffffffffc0200cd0 <interrupt_handler+0x7a>
ffffffffc0200c64:	00006717          	auipc	a4,0x6
ffffffffc0200c68:	1dc70713          	addi	a4,a4,476 # ffffffffc0206e40 <commands+0x618>
ffffffffc0200c6c:	078a                	slli	a5,a5,0x2
ffffffffc0200c6e:	97ba                	add	a5,a5,a4
ffffffffc0200c70:	439c                	lw	a5,0(a5)
ffffffffc0200c72:	97ba                	add	a5,a5,a4
ffffffffc0200c74:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c76:	00006517          	auipc	a0,0x6
ffffffffc0200c7a:	18a50513          	addi	a0,a0,394 # ffffffffc0206e00 <commands+0x5d8>
ffffffffc0200c7e:	c66ff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c82:	00006517          	auipc	a0,0x6
ffffffffc0200c86:	15e50513          	addi	a0,a0,350 # ffffffffc0206de0 <commands+0x5b8>
ffffffffc0200c8a:	c5aff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c8e:	00006517          	auipc	a0,0x6
ffffffffc0200c92:	11250513          	addi	a0,a0,274 # ffffffffc0206da0 <commands+0x578>
ffffffffc0200c96:	c4eff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c9a:	00006517          	auipc	a0,0x6
ffffffffc0200c9e:	12650513          	addi	a0,a0,294 # ffffffffc0206dc0 <commands+0x598>
ffffffffc0200ca2:	c42ff06f          	j	ffffffffc02000e4 <cprintf>
{
ffffffffc0200ca6:	1141                	addi	sp,sp,-16
ffffffffc0200ca8:	e406                	sd	ra,8(sp)
        // "All bits besides SSIP and USIP in the sip register are
        // read-only." -- privileged spec1.9.1, 4.1.4, p59
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);
        clock_set_next_event();
ffffffffc0200caa:	c79ff0ef          	jal	ra,ffffffffc0200922 <clock_set_next_event>
        ++ticks;
ffffffffc0200cae:	000df717          	auipc	a4,0xdf
ffffffffc0200cb2:	45270713          	addi	a4,a4,1106 # ffffffffc02e0100 <ticks>
ffffffffc0200cb6:	631c                	ld	a5,0(a4)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cb8:	60a2                	ld	ra,8(sp)
        ++ticks;
ffffffffc0200cba:	0785                	addi	a5,a5,1
ffffffffc0200cbc:	e31c                	sd	a5,0(a4)
}
ffffffffc0200cbe:	0141                	addi	sp,sp,16
        run_timer_list();
ffffffffc0200cc0:	0be0506f          	j	ffffffffc0205d7e <run_timer_list>
        cprintf("Supervisor external interrupt\n");
ffffffffc0200cc4:	00006517          	auipc	a0,0x6
ffffffffc0200cc8:	15c50513          	addi	a0,a0,348 # ffffffffc0206e20 <commands+0x5f8>
ffffffffc0200ccc:	c18ff06f          	j	ffffffffc02000e4 <cprintf>
        print_trapframe(tf);
ffffffffc0200cd0:	bdc9                	j	ffffffffc0200ba2 <print_trapframe>

ffffffffc0200cd2 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cd2:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cd6:	1141                	addi	sp,sp,-16
ffffffffc0200cd8:	e022                	sd	s0,0(sp)
ffffffffc0200cda:	e406                	sd	ra,8(sp)
ffffffffc0200cdc:	473d                	li	a4,15
ffffffffc0200cde:	842a                	mv	s0,a0
ffffffffc0200ce0:	10f76863          	bltu	a4,a5,ffffffffc0200df0 <exception_handler+0x11e>
ffffffffc0200ce4:	00006717          	auipc	a4,0x6
ffffffffc0200ce8:	31c70713          	addi	a4,a4,796 # ffffffffc0207000 <commands+0x7d8>
ffffffffc0200cec:	078a                	slli	a5,a5,0x2
ffffffffc0200cee:	97ba                	add	a5,a5,a4
ffffffffc0200cf0:	439c                	lw	a5,0(a5)
ffffffffc0200cf2:	97ba                	add	a5,a5,a4
ffffffffc0200cf4:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cf6:	00006517          	auipc	a0,0x6
ffffffffc0200cfa:	24a50513          	addi	a0,a0,586 # ffffffffc0206f40 <commands+0x718>
ffffffffc0200cfe:	be6ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        tf->epc += 4;
ffffffffc0200d02:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d06:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200d08:	0791                	addi	a5,a5,4
ffffffffc0200d0a:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d0e:	6402                	ld	s0,0(sp)
ffffffffc0200d10:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d12:	3180506f          	j	ffffffffc020602a <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d16:	00006517          	auipc	a0,0x6
ffffffffc0200d1a:	24a50513          	addi	a0,a0,586 # ffffffffc0206f60 <commands+0x738>
}
ffffffffc0200d1e:	6402                	ld	s0,0(sp)
ffffffffc0200d20:	60a2                	ld	ra,8(sp)
ffffffffc0200d22:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d24:	bc0ff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d28:	00006517          	auipc	a0,0x6
ffffffffc0200d2c:	25850513          	addi	a0,a0,600 # ffffffffc0206f80 <commands+0x758>
ffffffffc0200d30:	b7fd                	j	ffffffffc0200d1e <exception_handler+0x4c>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d32:	ed3ff0ef          	jal	ra,ffffffffc0200c04 <pgfault_handler>
ffffffffc0200d36:	0c051e63          	bnez	a0,ffffffffc0200e12 <exception_handler+0x140>
}
ffffffffc0200d3a:	60a2                	ld	ra,8(sp)
ffffffffc0200d3c:	6402                	ld	s0,0(sp)
ffffffffc0200d3e:	0141                	addi	sp,sp,16
ffffffffc0200d40:	8082                	ret
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d42:	ec3ff0ef          	jal	ra,ffffffffc0200c04 <pgfault_handler>
ffffffffc0200d46:	d975                	beqz	a0,ffffffffc0200d3a <exception_handler+0x68>
            cprintf("Load page fault\n");
ffffffffc0200d48:	00006517          	auipc	a0,0x6
ffffffffc0200d4c:	28850513          	addi	a0,a0,648 # ffffffffc0206fd0 <commands+0x7a8>
ffffffffc0200d50:	b94ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            print_trapframe(tf);
ffffffffc0200d54:	8522                	mv	a0,s0
ffffffffc0200d56:	e4dff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
            if (current != NULL) {
ffffffffc0200d5a:	000df797          	auipc	a5,0xdf
ffffffffc0200d5e:	3e67b783          	ld	a5,998(a5) # ffffffffc02e0140 <current>
ffffffffc0200d62:	ef95                	bnez	a5,ffffffffc0200d9e <exception_handler+0xcc>
                panic("kernel page fault");
ffffffffc0200d64:	00006617          	auipc	a2,0x6
ffffffffc0200d68:	25460613          	addi	a2,a2,596 # ffffffffc0206fb8 <commands+0x790>
ffffffffc0200d6c:	0e800593          	li	a1,232
ffffffffc0200d70:	00006517          	auipc	a0,0x6
ffffffffc0200d74:	ff850513          	addi	a0,a0,-8 # ffffffffc0206d68 <commands+0x540>
ffffffffc0200d78:	caaff0ef          	jal	ra,ffffffffc0200222 <__panic>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d7c:	e89ff0ef          	jal	ra,ffffffffc0200c04 <pgfault_handler>
ffffffffc0200d80:	dd4d                	beqz	a0,ffffffffc0200d3a <exception_handler+0x68>
            cprintf("Store/AMO page fault\n");
ffffffffc0200d82:	00006517          	auipc	a0,0x6
ffffffffc0200d86:	26650513          	addi	a0,a0,614 # ffffffffc0206fe8 <commands+0x7c0>
ffffffffc0200d8a:	b5aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            print_trapframe(tf);
ffffffffc0200d8e:	8522                	mv	a0,s0
ffffffffc0200d90:	e13ff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
            if (current != NULL) {
ffffffffc0200d94:	000df797          	auipc	a5,0xdf
ffffffffc0200d98:	3ac7b783          	ld	a5,940(a5) # ffffffffc02e0140 <current>
ffffffffc0200d9c:	c7cd                	beqz	a5,ffffffffc0200e46 <exception_handler+0x174>
}
ffffffffc0200d9e:	6402                	ld	s0,0(sp)
ffffffffc0200da0:	60a2                	ld	ra,8(sp)
                do_exit(-E_KILLED);
ffffffffc0200da2:	555d                	li	a0,-9
}
ffffffffc0200da4:	0141                	addi	sp,sp,16
                do_exit(-E_KILLED);
ffffffffc0200da6:	7990306f          	j	ffffffffc0204d3e <do_exit>
        cprintf("Instruction address misaligned\n");
ffffffffc0200daa:	00006517          	auipc	a0,0x6
ffffffffc0200dae:	0c650513          	addi	a0,a0,198 # ffffffffc0206e70 <commands+0x648>
ffffffffc0200db2:	b7b5                	j	ffffffffc0200d1e <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200db4:	00006517          	auipc	a0,0x6
ffffffffc0200db8:	0dc50513          	addi	a0,a0,220 # ffffffffc0206e90 <commands+0x668>
ffffffffc0200dbc:	b78d                	j	ffffffffc0200d1e <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200dbe:	00006517          	auipc	a0,0x6
ffffffffc0200dc2:	0f250513          	addi	a0,a0,242 # ffffffffc0206eb0 <commands+0x688>
ffffffffc0200dc6:	bfa1                	j	ffffffffc0200d1e <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200dc8:	00006517          	auipc	a0,0x6
ffffffffc0200dcc:	10050513          	addi	a0,a0,256 # ffffffffc0206ec8 <commands+0x6a0>
ffffffffc0200dd0:	b7b9                	j	ffffffffc0200d1e <exception_handler+0x4c>
        cprintf("Load address misaligned\n");
ffffffffc0200dd2:	00006517          	auipc	a0,0x6
ffffffffc0200dd6:	10650513          	addi	a0,a0,262 # ffffffffc0206ed8 <commands+0x6b0>
ffffffffc0200dda:	b791                	j	ffffffffc0200d1e <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200ddc:	00006517          	auipc	a0,0x6
ffffffffc0200de0:	11c50513          	addi	a0,a0,284 # ffffffffc0206ef8 <commands+0x6d0>
ffffffffc0200de4:	bf2d                	j	ffffffffc0200d1e <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200de6:	00006517          	auipc	a0,0x6
ffffffffc0200dea:	14250513          	addi	a0,a0,322 # ffffffffc0206f28 <commands+0x700>
ffffffffc0200dee:	bf05                	j	ffffffffc0200d1e <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200df0:	8522                	mv	a0,s0
}
ffffffffc0200df2:	6402                	ld	s0,0(sp)
ffffffffc0200df4:	60a2                	ld	ra,8(sp)
ffffffffc0200df6:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200df8:	b36d                	j	ffffffffc0200ba2 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200dfa:	00006617          	auipc	a2,0x6
ffffffffc0200dfe:	11660613          	addi	a2,a2,278 # ffffffffc0206f10 <commands+0x6e8>
ffffffffc0200e02:	0c100593          	li	a1,193
ffffffffc0200e06:	00006517          	auipc	a0,0x6
ffffffffc0200e0a:	f6250513          	addi	a0,a0,-158 # ffffffffc0206d68 <commands+0x540>
ffffffffc0200e0e:	c14ff0ef          	jal	ra,ffffffffc0200222 <__panic>
            cprintf("Fetch page fault\n");
ffffffffc0200e12:	00006517          	auipc	a0,0x6
ffffffffc0200e16:	18e50513          	addi	a0,a0,398 # ffffffffc0206fa0 <commands+0x778>
ffffffffc0200e1a:	acaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            print_trapframe(tf);
ffffffffc0200e1e:	8522                	mv	a0,s0
ffffffffc0200e20:	d83ff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
            if (current != NULL) {
ffffffffc0200e24:	000df797          	auipc	a5,0xdf
ffffffffc0200e28:	31c7b783          	ld	a5,796(a5) # ffffffffc02e0140 <current>
ffffffffc0200e2c:	fbad                	bnez	a5,ffffffffc0200d9e <exception_handler+0xcc>
                panic("kernel page fault");
ffffffffc0200e2e:	00006617          	auipc	a2,0x6
ffffffffc0200e32:	18a60613          	addi	a2,a2,394 # ffffffffc0206fb8 <commands+0x790>
ffffffffc0200e36:	0dd00593          	li	a1,221
ffffffffc0200e3a:	00006517          	auipc	a0,0x6
ffffffffc0200e3e:	f2e50513          	addi	a0,a0,-210 # ffffffffc0206d68 <commands+0x540>
ffffffffc0200e42:	be0ff0ef          	jal	ra,ffffffffc0200222 <__panic>
                panic("kernel page fault");
ffffffffc0200e46:	00006617          	auipc	a2,0x6
ffffffffc0200e4a:	17260613          	addi	a2,a2,370 # ffffffffc0206fb8 <commands+0x790>
ffffffffc0200e4e:	0f300593          	li	a1,243
ffffffffc0200e52:	00006517          	auipc	a0,0x6
ffffffffc0200e56:	f1650513          	addi	a0,a0,-234 # ffffffffc0206d68 <commands+0x540>
ffffffffc0200e5a:	bc8ff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0200e5e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200e5e:	1101                	addi	sp,sp,-32
ffffffffc0200e60:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e62:	000df417          	auipc	s0,0xdf
ffffffffc0200e66:	2de40413          	addi	s0,s0,734 # ffffffffc02e0140 <current>
ffffffffc0200e6a:	6018                	ld	a4,0(s0)
{
ffffffffc0200e6c:	ec06                	sd	ra,24(sp)
ffffffffc0200e6e:	e426                	sd	s1,8(sp)
ffffffffc0200e70:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e72:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e76:	cf1d                	beqz	a4,ffffffffc0200eb4 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e78:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e7c:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e80:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e82:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e86:	0206c463          	bltz	a3,ffffffffc0200eae <trap+0x50>
        exception_handler(tf);
ffffffffc0200e8a:	e49ff0ef          	jal	ra,ffffffffc0200cd2 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e8e:	601c                	ld	a5,0(s0)
ffffffffc0200e90:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e94:	e499                	bnez	s1,ffffffffc0200ea2 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e96:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e9a:	8b05                	andi	a4,a4,1
ffffffffc0200e9c:	e329                	bnez	a4,ffffffffc0200ede <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e9e:	6f9c                	ld	a5,24(a5)
ffffffffc0200ea0:	eb85                	bnez	a5,ffffffffc0200ed0 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200ea2:	60e2                	ld	ra,24(sp)
ffffffffc0200ea4:	6442                	ld	s0,16(sp)
ffffffffc0200ea6:	64a2                	ld	s1,8(sp)
ffffffffc0200ea8:	6902                	ld	s2,0(sp)
ffffffffc0200eaa:	6105                	addi	sp,sp,32
ffffffffc0200eac:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200eae:	da9ff0ef          	jal	ra,ffffffffc0200c56 <interrupt_handler>
ffffffffc0200eb2:	bff1                	j	ffffffffc0200e8e <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200eb4:	0006c863          	bltz	a3,ffffffffc0200ec4 <trap+0x66>
}
ffffffffc0200eb8:	6442                	ld	s0,16(sp)
ffffffffc0200eba:	60e2                	ld	ra,24(sp)
ffffffffc0200ebc:	64a2                	ld	s1,8(sp)
ffffffffc0200ebe:	6902                	ld	s2,0(sp)
ffffffffc0200ec0:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200ec2:	bd01                	j	ffffffffc0200cd2 <exception_handler>
}
ffffffffc0200ec4:	6442                	ld	s0,16(sp)
ffffffffc0200ec6:	60e2                	ld	ra,24(sp)
ffffffffc0200ec8:	64a2                	ld	s1,8(sp)
ffffffffc0200eca:	6902                	ld	s2,0(sp)
ffffffffc0200ecc:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200ece:	b361                	j	ffffffffc0200c56 <interrupt_handler>
}
ffffffffc0200ed0:	6442                	ld	s0,16(sp)
ffffffffc0200ed2:	60e2                	ld	ra,24(sp)
ffffffffc0200ed4:	64a2                	ld	s1,8(sp)
ffffffffc0200ed6:	6902                	ld	s2,0(sp)
ffffffffc0200ed8:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200eda:	4990406f          	j	ffffffffc0205b72 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200ede:	555d                	li	a0,-9
ffffffffc0200ee0:	65f030ef          	jal	ra,ffffffffc0204d3e <do_exit>
            if (current->need_resched)
ffffffffc0200ee4:	601c                	ld	a5,0(s0)
ffffffffc0200ee6:	bf65                	j	ffffffffc0200e9e <trap+0x40>

ffffffffc0200ee8 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200ee8:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200eec:	00011463          	bnez	sp,ffffffffc0200ef4 <__alltraps+0xc>
ffffffffc0200ef0:	14002173          	csrr	sp,sscratch
ffffffffc0200ef4:	712d                	addi	sp,sp,-288
ffffffffc0200ef6:	e002                	sd	zero,0(sp)
ffffffffc0200ef8:	e406                	sd	ra,8(sp)
ffffffffc0200efa:	ec0e                	sd	gp,24(sp)
ffffffffc0200efc:	f012                	sd	tp,32(sp)
ffffffffc0200efe:	f416                	sd	t0,40(sp)
ffffffffc0200f00:	f81a                	sd	t1,48(sp)
ffffffffc0200f02:	fc1e                	sd	t2,56(sp)
ffffffffc0200f04:	e0a2                	sd	s0,64(sp)
ffffffffc0200f06:	e4a6                	sd	s1,72(sp)
ffffffffc0200f08:	e8aa                	sd	a0,80(sp)
ffffffffc0200f0a:	ecae                	sd	a1,88(sp)
ffffffffc0200f0c:	f0b2                	sd	a2,96(sp)
ffffffffc0200f0e:	f4b6                	sd	a3,104(sp)
ffffffffc0200f10:	f8ba                	sd	a4,112(sp)
ffffffffc0200f12:	fcbe                	sd	a5,120(sp)
ffffffffc0200f14:	e142                	sd	a6,128(sp)
ffffffffc0200f16:	e546                	sd	a7,136(sp)
ffffffffc0200f18:	e94a                	sd	s2,144(sp)
ffffffffc0200f1a:	ed4e                	sd	s3,152(sp)
ffffffffc0200f1c:	f152                	sd	s4,160(sp)
ffffffffc0200f1e:	f556                	sd	s5,168(sp)
ffffffffc0200f20:	f95a                	sd	s6,176(sp)
ffffffffc0200f22:	fd5e                	sd	s7,184(sp)
ffffffffc0200f24:	e1e2                	sd	s8,192(sp)
ffffffffc0200f26:	e5e6                	sd	s9,200(sp)
ffffffffc0200f28:	e9ea                	sd	s10,208(sp)
ffffffffc0200f2a:	edee                	sd	s11,216(sp)
ffffffffc0200f2c:	f1f2                	sd	t3,224(sp)
ffffffffc0200f2e:	f5f6                	sd	t4,232(sp)
ffffffffc0200f30:	f9fa                	sd	t5,240(sp)
ffffffffc0200f32:	fdfe                	sd	t6,248(sp)
ffffffffc0200f34:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f38:	100024f3          	csrr	s1,sstatus
ffffffffc0200f3c:	14102973          	csrr	s2,sepc
ffffffffc0200f40:	143029f3          	csrr	s3,stval
ffffffffc0200f44:	14202a73          	csrr	s4,scause
ffffffffc0200f48:	e822                	sd	s0,16(sp)
ffffffffc0200f4a:	e226                	sd	s1,256(sp)
ffffffffc0200f4c:	e64a                	sd	s2,264(sp)
ffffffffc0200f4e:	ea4e                	sd	s3,272(sp)
ffffffffc0200f50:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f52:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f54:	f0bff0ef          	jal	ra,ffffffffc0200e5e <trap>

ffffffffc0200f58 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f58:	6492                	ld	s1,256(sp)
ffffffffc0200f5a:	6932                	ld	s2,264(sp)
ffffffffc0200f5c:	1004f413          	andi	s0,s1,256
ffffffffc0200f60:	e401                	bnez	s0,ffffffffc0200f68 <__trapret+0x10>
ffffffffc0200f62:	1200                	addi	s0,sp,288
ffffffffc0200f64:	14041073          	csrw	sscratch,s0
ffffffffc0200f68:	10049073          	csrw	sstatus,s1
ffffffffc0200f6c:	14191073          	csrw	sepc,s2
ffffffffc0200f70:	60a2                	ld	ra,8(sp)
ffffffffc0200f72:	61e2                	ld	gp,24(sp)
ffffffffc0200f74:	7202                	ld	tp,32(sp)
ffffffffc0200f76:	72a2                	ld	t0,40(sp)
ffffffffc0200f78:	7342                	ld	t1,48(sp)
ffffffffc0200f7a:	73e2                	ld	t2,56(sp)
ffffffffc0200f7c:	6406                	ld	s0,64(sp)
ffffffffc0200f7e:	64a6                	ld	s1,72(sp)
ffffffffc0200f80:	6546                	ld	a0,80(sp)
ffffffffc0200f82:	65e6                	ld	a1,88(sp)
ffffffffc0200f84:	7606                	ld	a2,96(sp)
ffffffffc0200f86:	76a6                	ld	a3,104(sp)
ffffffffc0200f88:	7746                	ld	a4,112(sp)
ffffffffc0200f8a:	77e6                	ld	a5,120(sp)
ffffffffc0200f8c:	680a                	ld	a6,128(sp)
ffffffffc0200f8e:	68aa                	ld	a7,136(sp)
ffffffffc0200f90:	694a                	ld	s2,144(sp)
ffffffffc0200f92:	69ea                	ld	s3,152(sp)
ffffffffc0200f94:	7a0a                	ld	s4,160(sp)
ffffffffc0200f96:	7aaa                	ld	s5,168(sp)
ffffffffc0200f98:	7b4a                	ld	s6,176(sp)
ffffffffc0200f9a:	7bea                	ld	s7,184(sp)
ffffffffc0200f9c:	6c0e                	ld	s8,192(sp)
ffffffffc0200f9e:	6cae                	ld	s9,200(sp)
ffffffffc0200fa0:	6d4e                	ld	s10,208(sp)
ffffffffc0200fa2:	6dee                	ld	s11,216(sp)
ffffffffc0200fa4:	7e0e                	ld	t3,224(sp)
ffffffffc0200fa6:	7eae                	ld	t4,232(sp)
ffffffffc0200fa8:	7f4e                	ld	t5,240(sp)
ffffffffc0200faa:	7fee                	ld	t6,248(sp)
ffffffffc0200fac:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200fae:	10200073          	sret

ffffffffc0200fb2 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200fb2:	812a                	mv	sp,a0
ffffffffc0200fb4:	b755                	j	ffffffffc0200f58 <__trapret>

ffffffffc0200fb6 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0200fb6:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0200fb8:	00006697          	auipc	a3,0x6
ffffffffc0200fbc:	08868693          	addi	a3,a3,136 # ffffffffc0207040 <commands+0x818>
ffffffffc0200fc0:	00006617          	auipc	a2,0x6
ffffffffc0200fc4:	0a060613          	addi	a2,a2,160 # ffffffffc0207060 <commands+0x838>
ffffffffc0200fc8:	07400593          	li	a1,116
ffffffffc0200fcc:	00006517          	auipc	a0,0x6
ffffffffc0200fd0:	0ac50513          	addi	a0,a0,172 # ffffffffc0207078 <commands+0x850>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0200fd4:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0200fd6:	a4cff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0200fda <mm_create>:
{
ffffffffc0200fda:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200fdc:	05800513          	li	a0,88
{
ffffffffc0200fe0:	e022                	sd	s0,0(sp)
ffffffffc0200fe2:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200fe4:	147000ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc0200fe8:	842a                	mv	s0,a0
    if (mm != NULL)
ffffffffc0200fea:	c115                	beqz	a0,ffffffffc020100e <mm_create+0x34>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fec:	e408                	sd	a0,8(s0)
ffffffffc0200fee:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0200ff0:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200ff4:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200ff8:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0200ffc:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0201000:	02052823          	sw	zero,48(a0)
        sem_init(&(mm->mm_sem), 1);
ffffffffc0201004:	4585                	li	a1,1
ffffffffc0201006:	03850513          	addi	a0,a0,56
ffffffffc020100a:	4e2030ef          	jal	ra,ffffffffc02044ec <sem_init>
}
ffffffffc020100e:	60a2                	ld	ra,8(sp)
ffffffffc0201010:	8522                	mv	a0,s0
ffffffffc0201012:	6402                	ld	s0,0(sp)
ffffffffc0201014:	0141                	addi	sp,sp,16
ffffffffc0201016:	8082                	ret

ffffffffc0201018 <find_vma>:
{
ffffffffc0201018:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc020101a:	c505                	beqz	a0,ffffffffc0201042 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc020101c:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020101e:	c501                	beqz	a0,ffffffffc0201026 <find_vma+0xe>
ffffffffc0201020:	651c                	ld	a5,8(a0)
ffffffffc0201022:	02f5f263          	bgeu	a1,a5,ffffffffc0201046 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201026:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0201028:	00f68d63          	beq	a3,a5,ffffffffc0201042 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020102c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201030:	00e5e663          	bltu	a1,a4,ffffffffc020103c <find_vma+0x24>
ffffffffc0201034:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201038:	00e5ec63          	bltu	a1,a4,ffffffffc0201050 <find_vma+0x38>
ffffffffc020103c:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc020103e:	fef697e3          	bne	a3,a5,ffffffffc020102c <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0201042:	4501                	li	a0,0
}
ffffffffc0201044:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201046:	691c                	ld	a5,16(a0)
ffffffffc0201048:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0201026 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020104c:	ea88                	sd	a0,16(a3)
ffffffffc020104e:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0201050:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0201054:	ea88                	sd	a0,16(a3)
ffffffffc0201056:	8082                	ret

ffffffffc0201058 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201058:	6590                	ld	a2,8(a1)
ffffffffc020105a:	0105b803          	ld	a6,16(a1)
{
ffffffffc020105e:	1141                	addi	sp,sp,-16
ffffffffc0201060:	e406                	sd	ra,8(sp)
ffffffffc0201062:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201064:	01066763          	bltu	a2,a6,ffffffffc0201072 <insert_vma_struct+0x1a>
ffffffffc0201068:	a085                	j	ffffffffc02010c8 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020106a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020106e:	04e66863          	bltu	a2,a4,ffffffffc02010be <insert_vma_struct+0x66>
ffffffffc0201072:	86be                	mv	a3,a5
ffffffffc0201074:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0201076:	fef51ae3          	bne	a0,a5,ffffffffc020106a <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020107a:	02a68463          	beq	a3,a0,ffffffffc02010a2 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020107e:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201082:	fe86b883          	ld	a7,-24(a3)
ffffffffc0201086:	08e8f163          	bgeu	a7,a4,ffffffffc0201108 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020108a:	04e66f63          	bltu	a2,a4,ffffffffc02010e8 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc020108e:	00f50a63          	beq	a0,a5,ffffffffc02010a2 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0201092:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201096:	05076963          	bltu	a4,a6,ffffffffc02010e8 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020109a:	ff07b603          	ld	a2,-16(a5)
ffffffffc020109e:	02c77363          	bgeu	a4,a2,ffffffffc02010c4 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02010a2:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02010a4:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02010a6:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02010aa:	e390                	sd	a2,0(a5)
ffffffffc02010ac:	e690                	sd	a2,8(a3)
}
ffffffffc02010ae:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02010b0:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02010b2:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02010b4:	0017079b          	addiw	a5,a4,1
ffffffffc02010b8:	d11c                	sw	a5,32(a0)
}
ffffffffc02010ba:	0141                	addi	sp,sp,16
ffffffffc02010bc:	8082                	ret
    if (le_prev != list)
ffffffffc02010be:	fca690e3          	bne	a3,a0,ffffffffc020107e <insert_vma_struct+0x26>
ffffffffc02010c2:	bfd1                	j	ffffffffc0201096 <insert_vma_struct+0x3e>
ffffffffc02010c4:	ef3ff0ef          	jal	ra,ffffffffc0200fb6 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02010c8:	00006697          	auipc	a3,0x6
ffffffffc02010cc:	fc068693          	addi	a3,a3,-64 # ffffffffc0207088 <commands+0x860>
ffffffffc02010d0:	00006617          	auipc	a2,0x6
ffffffffc02010d4:	f9060613          	addi	a2,a2,-112 # ffffffffc0207060 <commands+0x838>
ffffffffc02010d8:	07a00593          	li	a1,122
ffffffffc02010dc:	00006517          	auipc	a0,0x6
ffffffffc02010e0:	f9c50513          	addi	a0,a0,-100 # ffffffffc0207078 <commands+0x850>
ffffffffc02010e4:	93eff0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02010e8:	00006697          	auipc	a3,0x6
ffffffffc02010ec:	fe068693          	addi	a3,a3,-32 # ffffffffc02070c8 <commands+0x8a0>
ffffffffc02010f0:	00006617          	auipc	a2,0x6
ffffffffc02010f4:	f7060613          	addi	a2,a2,-144 # ffffffffc0207060 <commands+0x838>
ffffffffc02010f8:	07300593          	li	a1,115
ffffffffc02010fc:	00006517          	auipc	a0,0x6
ffffffffc0201100:	f7c50513          	addi	a0,a0,-132 # ffffffffc0207078 <commands+0x850>
ffffffffc0201104:	91eff0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201108:	00006697          	auipc	a3,0x6
ffffffffc020110c:	fa068693          	addi	a3,a3,-96 # ffffffffc02070a8 <commands+0x880>
ffffffffc0201110:	00006617          	auipc	a2,0x6
ffffffffc0201114:	f5060613          	addi	a2,a2,-176 # ffffffffc0207060 <commands+0x838>
ffffffffc0201118:	07200593          	li	a1,114
ffffffffc020111c:	00006517          	auipc	a0,0x6
ffffffffc0201120:	f5c50513          	addi	a0,a0,-164 # ffffffffc0207078 <commands+0x850>
ffffffffc0201124:	8feff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201128 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0201128:	591c                	lw	a5,48(a0)
{
ffffffffc020112a:	1141                	addi	sp,sp,-16
ffffffffc020112c:	e406                	sd	ra,8(sp)
ffffffffc020112e:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0201130:	e78d                	bnez	a5,ffffffffc020115a <mm_destroy+0x32>
ffffffffc0201132:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0201134:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0201136:	00a40c63          	beq	s0,a0,ffffffffc020114e <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc020113a:	6118                	ld	a4,0(a0)
ffffffffc020113c:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc020113e:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201140:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201142:	e398                	sd	a4,0(a5)
ffffffffc0201144:	097000ef          	jal	ra,ffffffffc02019da <kfree>
    return listelm->next;
ffffffffc0201148:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020114a:	fea418e3          	bne	s0,a0,ffffffffc020113a <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc020114e:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0201150:	6402                	ld	s0,0(sp)
ffffffffc0201152:	60a2                	ld	ra,8(sp)
ffffffffc0201154:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0201156:	0850006f          	j	ffffffffc02019da <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020115a:	00006697          	auipc	a3,0x6
ffffffffc020115e:	f8e68693          	addi	a3,a3,-114 # ffffffffc02070e8 <commands+0x8c0>
ffffffffc0201162:	00006617          	auipc	a2,0x6
ffffffffc0201166:	efe60613          	addi	a2,a2,-258 # ffffffffc0207060 <commands+0x838>
ffffffffc020116a:	09e00593          	li	a1,158
ffffffffc020116e:	00006517          	auipc	a0,0x6
ffffffffc0201172:	f0a50513          	addi	a0,a0,-246 # ffffffffc0207078 <commands+0x850>
ffffffffc0201176:	8acff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020117a <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020117a:	7139                	addi	sp,sp,-64
ffffffffc020117c:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020117e:	6405                	lui	s0,0x1
ffffffffc0201180:	147d                	addi	s0,s0,-1
ffffffffc0201182:	77fd                	lui	a5,0xfffff
ffffffffc0201184:	9622                	add	a2,a2,s0
ffffffffc0201186:	962e                	add	a2,a2,a1
{
ffffffffc0201188:	f426                	sd	s1,40(sp)
ffffffffc020118a:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020118c:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0201190:	f04a                	sd	s2,32(sp)
ffffffffc0201192:	ec4e                	sd	s3,24(sp)
ffffffffc0201194:	e852                	sd	s4,16(sp)
ffffffffc0201196:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0201198:	002005b7          	lui	a1,0x200
ffffffffc020119c:	00f67433          	and	s0,a2,a5
ffffffffc02011a0:	06b4e363          	bltu	s1,a1,ffffffffc0201206 <mm_map+0x8c>
ffffffffc02011a4:	0684f163          	bgeu	s1,s0,ffffffffc0201206 <mm_map+0x8c>
ffffffffc02011a8:	4785                	li	a5,1
ffffffffc02011aa:	07fe                	slli	a5,a5,0x1f
ffffffffc02011ac:	0487ed63          	bltu	a5,s0,ffffffffc0201206 <mm_map+0x8c>
ffffffffc02011b0:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02011b2:	cd21                	beqz	a0,ffffffffc020120a <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02011b4:	85a6                	mv	a1,s1
ffffffffc02011b6:	8ab6                	mv	s5,a3
ffffffffc02011b8:	8a3a                	mv	s4,a4
ffffffffc02011ba:	e5fff0ef          	jal	ra,ffffffffc0201018 <find_vma>
ffffffffc02011be:	c501                	beqz	a0,ffffffffc02011c6 <mm_map+0x4c>
ffffffffc02011c0:	651c                	ld	a5,8(a0)
ffffffffc02011c2:	0487e263          	bltu	a5,s0,ffffffffc0201206 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02011c6:	03000513          	li	a0,48
ffffffffc02011ca:	760000ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc02011ce:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02011d0:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02011d2:	02090163          	beqz	s2,ffffffffc02011f4 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02011d6:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02011d8:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02011dc:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02011e0:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02011e4:	85ca                	mv	a1,s2
ffffffffc02011e6:	e73ff0ef          	jal	ra,ffffffffc0201058 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02011ea:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02011ec:	000a0463          	beqz	s4,ffffffffc02011f4 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02011f0:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc02011f4:	70e2                	ld	ra,56(sp)
ffffffffc02011f6:	7442                	ld	s0,48(sp)
ffffffffc02011f8:	74a2                	ld	s1,40(sp)
ffffffffc02011fa:	7902                	ld	s2,32(sp)
ffffffffc02011fc:	69e2                	ld	s3,24(sp)
ffffffffc02011fe:	6a42                	ld	s4,16(sp)
ffffffffc0201200:	6aa2                	ld	s5,8(sp)
ffffffffc0201202:	6121                	addi	sp,sp,64
ffffffffc0201204:	8082                	ret
        return -E_INVAL;
ffffffffc0201206:	5575                	li	a0,-3
ffffffffc0201208:	b7f5                	j	ffffffffc02011f4 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc020120a:	00006697          	auipc	a3,0x6
ffffffffc020120e:	ef668693          	addi	a3,a3,-266 # ffffffffc0207100 <commands+0x8d8>
ffffffffc0201212:	00006617          	auipc	a2,0x6
ffffffffc0201216:	e4e60613          	addi	a2,a2,-434 # ffffffffc0207060 <commands+0x838>
ffffffffc020121a:	0b300593          	li	a1,179
ffffffffc020121e:	00006517          	auipc	a0,0x6
ffffffffc0201222:	e5a50513          	addi	a0,a0,-422 # ffffffffc0207078 <commands+0x850>
ffffffffc0201226:	ffdfe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020122a <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc020122a:	7139                	addi	sp,sp,-64
ffffffffc020122c:	fc06                	sd	ra,56(sp)
ffffffffc020122e:	f822                	sd	s0,48(sp)
ffffffffc0201230:	f426                	sd	s1,40(sp)
ffffffffc0201232:	f04a                	sd	s2,32(sp)
ffffffffc0201234:	ec4e                	sd	s3,24(sp)
ffffffffc0201236:	e852                	sd	s4,16(sp)
ffffffffc0201238:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc020123a:	c52d                	beqz	a0,ffffffffc02012a4 <dup_mmap+0x7a>
ffffffffc020123c:	892a                	mv	s2,a0
ffffffffc020123e:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0201240:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0201242:	e595                	bnez	a1,ffffffffc020126e <dup_mmap+0x44>
ffffffffc0201244:	a085                	j	ffffffffc02012a4 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0201246:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0201248:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_matrix_out_size+0x1f36c8>
        vma->vm_end = vm_end;
ffffffffc020124c:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0201250:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0201254:	e05ff0ef          	jal	ra,ffffffffc0201058 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0201258:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x9188>
ffffffffc020125c:	fe843603          	ld	a2,-24(s0)
ffffffffc0201260:	6c8c                	ld	a1,24(s1)
ffffffffc0201262:	01893503          	ld	a0,24(s2)
ffffffffc0201266:	4701                	li	a4,0
ffffffffc0201268:	02d020ef          	jal	ra,ffffffffc0203a94 <copy_range>
ffffffffc020126c:	e105                	bnez	a0,ffffffffc020128c <dup_mmap+0x62>
    return listelm->prev;
ffffffffc020126e:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0201270:	02848863          	beq	s1,s0,ffffffffc02012a0 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201274:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0201278:	fe843a83          	ld	s5,-24(s0)
ffffffffc020127c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0201280:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201284:	6a6000ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc0201288:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020128a:	fd55                	bnez	a0,ffffffffc0201246 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc020128c:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc020128e:	70e2                	ld	ra,56(sp)
ffffffffc0201290:	7442                	ld	s0,48(sp)
ffffffffc0201292:	74a2                	ld	s1,40(sp)
ffffffffc0201294:	7902                	ld	s2,32(sp)
ffffffffc0201296:	69e2                	ld	s3,24(sp)
ffffffffc0201298:	6a42                	ld	s4,16(sp)
ffffffffc020129a:	6aa2                	ld	s5,8(sp)
ffffffffc020129c:	6121                	addi	sp,sp,64
ffffffffc020129e:	8082                	ret
    return 0;
ffffffffc02012a0:	4501                	li	a0,0
ffffffffc02012a2:	b7f5                	j	ffffffffc020128e <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc02012a4:	00006697          	auipc	a3,0x6
ffffffffc02012a8:	e6c68693          	addi	a3,a3,-404 # ffffffffc0207110 <commands+0x8e8>
ffffffffc02012ac:	00006617          	auipc	a2,0x6
ffffffffc02012b0:	db460613          	addi	a2,a2,-588 # ffffffffc0207060 <commands+0x838>
ffffffffc02012b4:	0cf00593          	li	a1,207
ffffffffc02012b8:	00006517          	auipc	a0,0x6
ffffffffc02012bc:	dc050513          	addi	a0,a0,-576 # ffffffffc0207078 <commands+0x850>
ffffffffc02012c0:	f63fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02012c4 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02012c4:	1101                	addi	sp,sp,-32
ffffffffc02012c6:	ec06                	sd	ra,24(sp)
ffffffffc02012c8:	e822                	sd	s0,16(sp)
ffffffffc02012ca:	e426                	sd	s1,8(sp)
ffffffffc02012cc:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02012ce:	c531                	beqz	a0,ffffffffc020131a <exit_mmap+0x56>
ffffffffc02012d0:	591c                	lw	a5,48(a0)
ffffffffc02012d2:	84aa                	mv	s1,a0
ffffffffc02012d4:	e3b9                	bnez	a5,ffffffffc020131a <exit_mmap+0x56>
    return listelm->next;
ffffffffc02012d6:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02012d8:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02012dc:	02850663          	beq	a0,s0,ffffffffc0201308 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02012e0:	ff043603          	ld	a2,-16(s0)
ffffffffc02012e4:	fe843583          	ld	a1,-24(s0)
ffffffffc02012e8:	854a                	mv	a0,s2
ffffffffc02012ea:	600010ef          	jal	ra,ffffffffc02028ea <unmap_range>
ffffffffc02012ee:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02012f0:	fe8498e3          	bne	s1,s0,ffffffffc02012e0 <exit_mmap+0x1c>
ffffffffc02012f4:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02012f6:	00848c63          	beq	s1,s0,ffffffffc020130e <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02012fa:	ff043603          	ld	a2,-16(s0)
ffffffffc02012fe:	fe843583          	ld	a1,-24(s0)
ffffffffc0201302:	854a                	mv	a0,s2
ffffffffc0201304:	72c010ef          	jal	ra,ffffffffc0202a30 <exit_range>
ffffffffc0201308:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc020130a:	fe8498e3          	bne	s1,s0,ffffffffc02012fa <exit_mmap+0x36>
    }
}
ffffffffc020130e:	60e2                	ld	ra,24(sp)
ffffffffc0201310:	6442                	ld	s0,16(sp)
ffffffffc0201312:	64a2                	ld	s1,8(sp)
ffffffffc0201314:	6902                	ld	s2,0(sp)
ffffffffc0201316:	6105                	addi	sp,sp,32
ffffffffc0201318:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc020131a:	00006697          	auipc	a3,0x6
ffffffffc020131e:	e1668693          	addi	a3,a3,-490 # ffffffffc0207130 <commands+0x908>
ffffffffc0201322:	00006617          	auipc	a2,0x6
ffffffffc0201326:	d3e60613          	addi	a2,a2,-706 # ffffffffc0207060 <commands+0x838>
ffffffffc020132a:	0e800593          	li	a1,232
ffffffffc020132e:	00006517          	auipc	a0,0x6
ffffffffc0201332:	d4a50513          	addi	a0,a0,-694 # ffffffffc0207078 <commands+0x850>
ffffffffc0201336:	eedfe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020133a <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc020133a:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020133c:	05800513          	li	a0,88
{
ffffffffc0201340:	fc06                	sd	ra,56(sp)
ffffffffc0201342:	f822                	sd	s0,48(sp)
ffffffffc0201344:	f426                	sd	s1,40(sp)
ffffffffc0201346:	f04a                	sd	s2,32(sp)
ffffffffc0201348:	ec4e                	sd	s3,24(sp)
ffffffffc020134a:	e852                	sd	s4,16(sp)
ffffffffc020134c:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020134e:	5dc000ef          	jal	ra,ffffffffc020192a <kmalloc>
    if (mm != NULL)
ffffffffc0201352:	2e050963          	beqz	a0,ffffffffc0201644 <vmm_init+0x30a>
    elm->prev = elm->next = elm;
ffffffffc0201356:	e508                	sd	a0,8(a0)
ffffffffc0201358:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020135a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020135e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0201362:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0201366:	02053423          	sd	zero,40(a0)
ffffffffc020136a:	02052823          	sw	zero,48(a0)
        sem_init(&(mm->mm_sem), 1);
ffffffffc020136e:	84aa                	mv	s1,a0
ffffffffc0201370:	4585                	li	a1,1
ffffffffc0201372:	03850513          	addi	a0,a0,56
ffffffffc0201376:	176030ef          	jal	ra,ffffffffc02044ec <sem_init>
ffffffffc020137a:	03200413          	li	s0,50
ffffffffc020137e:	a811                	j	ffffffffc0201392 <vmm_init+0x58>
        vma->vm_start = vm_start;
ffffffffc0201380:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201382:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201384:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0201388:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020138a:	8526                	mv	a0,s1
ffffffffc020138c:	ccdff0ef          	jal	ra,ffffffffc0201058 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0201390:	c80d                	beqz	s0,ffffffffc02013c2 <vmm_init+0x88>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201392:	03000513          	li	a0,48
ffffffffc0201396:	594000ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc020139a:	85aa                	mv	a1,a0
ffffffffc020139c:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02013a0:	f165                	bnez	a0,ffffffffc0201380 <vmm_init+0x46>
        assert(vma != NULL);
ffffffffc02013a2:	00006697          	auipc	a3,0x6
ffffffffc02013a6:	f2668693          	addi	a3,a3,-218 # ffffffffc02072c8 <commands+0xaa0>
ffffffffc02013aa:	00006617          	auipc	a2,0x6
ffffffffc02013ae:	cb660613          	addi	a2,a2,-842 # ffffffffc0207060 <commands+0x838>
ffffffffc02013b2:	12c00593          	li	a1,300
ffffffffc02013b6:	00006517          	auipc	a0,0x6
ffffffffc02013ba:	cc250513          	addi	a0,a0,-830 # ffffffffc0207078 <commands+0x850>
ffffffffc02013be:	e65fe0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc02013c2:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02013c6:	1f900913          	li	s2,505
ffffffffc02013ca:	a819                	j	ffffffffc02013e0 <vmm_init+0xa6>
        vma->vm_start = vm_start;
ffffffffc02013cc:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02013ce:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02013d0:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02013d4:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02013d6:	8526                	mv	a0,s1
ffffffffc02013d8:	c81ff0ef          	jal	ra,ffffffffc0201058 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02013dc:	03240a63          	beq	s0,s2,ffffffffc0201410 <vmm_init+0xd6>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02013e0:	03000513          	li	a0,48
ffffffffc02013e4:	546000ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc02013e8:	85aa                	mv	a1,a0
ffffffffc02013ea:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02013ee:	fd79                	bnez	a0,ffffffffc02013cc <vmm_init+0x92>
        assert(vma != NULL);
ffffffffc02013f0:	00006697          	auipc	a3,0x6
ffffffffc02013f4:	ed868693          	addi	a3,a3,-296 # ffffffffc02072c8 <commands+0xaa0>
ffffffffc02013f8:	00006617          	auipc	a2,0x6
ffffffffc02013fc:	c6860613          	addi	a2,a2,-920 # ffffffffc0207060 <commands+0x838>
ffffffffc0201400:	13300593          	li	a1,307
ffffffffc0201404:	00006517          	auipc	a0,0x6
ffffffffc0201408:	c7450513          	addi	a0,a0,-908 # ffffffffc0207078 <commands+0x850>
ffffffffc020140c:	e17fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    return listelm->next;
ffffffffc0201410:	649c                	ld	a5,8(s1)
ffffffffc0201412:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0201414:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0201418:	16f48663          	beq	s1,a5,ffffffffc0201584 <vmm_init+0x24a>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc020141c:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd1ee78>
ffffffffc0201420:	ffe70693          	addi	a3,a4,-2
ffffffffc0201424:	10d61063          	bne	a2,a3,ffffffffc0201524 <vmm_init+0x1ea>
ffffffffc0201428:	ff07b683          	ld	a3,-16(a5)
ffffffffc020142c:	0ed71c63          	bne	a4,a3,ffffffffc0201524 <vmm_init+0x1ea>
    for (i = 1; i <= step2; i++)
ffffffffc0201430:	0715                	addi	a4,a4,5
ffffffffc0201432:	679c                	ld	a5,8(a5)
ffffffffc0201434:	feb712e3          	bne	a4,a1,ffffffffc0201418 <vmm_init+0xde>
ffffffffc0201438:	4a1d                	li	s4,7
ffffffffc020143a:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc020143c:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0201440:	85a2                	mv	a1,s0
ffffffffc0201442:	8526                	mv	a0,s1
ffffffffc0201444:	bd5ff0ef          	jal	ra,ffffffffc0201018 <find_vma>
ffffffffc0201448:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc020144a:	16050d63          	beqz	a0,ffffffffc02015c4 <vmm_init+0x28a>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc020144e:	00140593          	addi	a1,s0,1
ffffffffc0201452:	8526                	mv	a0,s1
ffffffffc0201454:	bc5ff0ef          	jal	ra,ffffffffc0201018 <find_vma>
ffffffffc0201458:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc020145a:	14050563          	beqz	a0,ffffffffc02015a4 <vmm_init+0x26a>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc020145e:	85d2                	mv	a1,s4
ffffffffc0201460:	8526                	mv	a0,s1
ffffffffc0201462:	bb7ff0ef          	jal	ra,ffffffffc0201018 <find_vma>
        assert(vma3 == NULL);
ffffffffc0201466:	16051f63          	bnez	a0,ffffffffc02015e4 <vmm_init+0x2aa>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc020146a:	00340593          	addi	a1,s0,3
ffffffffc020146e:	8526                	mv	a0,s1
ffffffffc0201470:	ba9ff0ef          	jal	ra,ffffffffc0201018 <find_vma>
        assert(vma4 == NULL);
ffffffffc0201474:	1a051863          	bnez	a0,ffffffffc0201624 <vmm_init+0x2ea>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0201478:	00440593          	addi	a1,s0,4
ffffffffc020147c:	8526                	mv	a0,s1
ffffffffc020147e:	b9bff0ef          	jal	ra,ffffffffc0201018 <find_vma>
        assert(vma5 == NULL);
ffffffffc0201482:	18051163          	bnez	a0,ffffffffc0201604 <vmm_init+0x2ca>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0201486:	00893783          	ld	a5,8(s2)
ffffffffc020148a:	0a879d63          	bne	a5,s0,ffffffffc0201544 <vmm_init+0x20a>
ffffffffc020148e:	01093783          	ld	a5,16(s2)
ffffffffc0201492:	0b479963          	bne	a5,s4,ffffffffc0201544 <vmm_init+0x20a>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0201496:	0089b783          	ld	a5,8(s3)
ffffffffc020149a:	0c879563          	bne	a5,s0,ffffffffc0201564 <vmm_init+0x22a>
ffffffffc020149e:	0109b783          	ld	a5,16(s3)
ffffffffc02014a2:	0d479163          	bne	a5,s4,ffffffffc0201564 <vmm_init+0x22a>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc02014a6:	0415                	addi	s0,s0,5
ffffffffc02014a8:	0a15                	addi	s4,s4,5
ffffffffc02014aa:	f9541be3          	bne	s0,s5,ffffffffc0201440 <vmm_init+0x106>
ffffffffc02014ae:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc02014b0:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc02014b2:	85a2                	mv	a1,s0
ffffffffc02014b4:	8526                	mv	a0,s1
ffffffffc02014b6:	b63ff0ef          	jal	ra,ffffffffc0201018 <find_vma>
ffffffffc02014ba:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc02014be:	c90d                	beqz	a0,ffffffffc02014f0 <vmm_init+0x1b6>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02014c0:	6914                	ld	a3,16(a0)
ffffffffc02014c2:	6510                	ld	a2,8(a0)
ffffffffc02014c4:	00006517          	auipc	a0,0x6
ffffffffc02014c8:	d8c50513          	addi	a0,a0,-628 # ffffffffc0207250 <commands+0xa28>
ffffffffc02014cc:	c19fe0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc02014d0:	00006697          	auipc	a3,0x6
ffffffffc02014d4:	da868693          	addi	a3,a3,-600 # ffffffffc0207278 <commands+0xa50>
ffffffffc02014d8:	00006617          	auipc	a2,0x6
ffffffffc02014dc:	b8860613          	addi	a2,a2,-1144 # ffffffffc0207060 <commands+0x838>
ffffffffc02014e0:	15900593          	li	a1,345
ffffffffc02014e4:	00006517          	auipc	a0,0x6
ffffffffc02014e8:	b9450513          	addi	a0,a0,-1132 # ffffffffc0207078 <commands+0x850>
ffffffffc02014ec:	d37fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc02014f0:	147d                	addi	s0,s0,-1
ffffffffc02014f2:	fd2410e3          	bne	s0,s2,ffffffffc02014b2 <vmm_init+0x178>
    }

    mm_destroy(mm);
ffffffffc02014f6:	8526                	mv	a0,s1
ffffffffc02014f8:	c31ff0ef          	jal	ra,ffffffffc0201128 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02014fc:	00006517          	auipc	a0,0x6
ffffffffc0201500:	d9450513          	addi	a0,a0,-620 # ffffffffc0207290 <commands+0xa68>
ffffffffc0201504:	be1fe0ef          	jal	ra,ffffffffc02000e4 <cprintf>
}
ffffffffc0201508:	7442                	ld	s0,48(sp)
ffffffffc020150a:	70e2                	ld	ra,56(sp)
ffffffffc020150c:	74a2                	ld	s1,40(sp)
ffffffffc020150e:	7902                	ld	s2,32(sp)
ffffffffc0201510:	69e2                	ld	s3,24(sp)
ffffffffc0201512:	6a42                	ld	s4,16(sp)
ffffffffc0201514:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0201516:	00006517          	auipc	a0,0x6
ffffffffc020151a:	d9a50513          	addi	a0,a0,-614 # ffffffffc02072b0 <commands+0xa88>
}
ffffffffc020151e:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0201520:	bc5fe06f          	j	ffffffffc02000e4 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201524:	00006697          	auipc	a3,0x6
ffffffffc0201528:	c4468693          	addi	a3,a3,-956 # ffffffffc0207168 <commands+0x940>
ffffffffc020152c:	00006617          	auipc	a2,0x6
ffffffffc0201530:	b3460613          	addi	a2,a2,-1228 # ffffffffc0207060 <commands+0x838>
ffffffffc0201534:	13d00593          	li	a1,317
ffffffffc0201538:	00006517          	auipc	a0,0x6
ffffffffc020153c:	b4050513          	addi	a0,a0,-1216 # ffffffffc0207078 <commands+0x850>
ffffffffc0201540:	ce3fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0201544:	00006697          	auipc	a3,0x6
ffffffffc0201548:	cac68693          	addi	a3,a3,-852 # ffffffffc02071f0 <commands+0x9c8>
ffffffffc020154c:	00006617          	auipc	a2,0x6
ffffffffc0201550:	b1460613          	addi	a2,a2,-1260 # ffffffffc0207060 <commands+0x838>
ffffffffc0201554:	14e00593          	li	a1,334
ffffffffc0201558:	00006517          	auipc	a0,0x6
ffffffffc020155c:	b2050513          	addi	a0,a0,-1248 # ffffffffc0207078 <commands+0x850>
ffffffffc0201560:	cc3fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0201564:	00006697          	auipc	a3,0x6
ffffffffc0201568:	cbc68693          	addi	a3,a3,-836 # ffffffffc0207220 <commands+0x9f8>
ffffffffc020156c:	00006617          	auipc	a2,0x6
ffffffffc0201570:	af460613          	addi	a2,a2,-1292 # ffffffffc0207060 <commands+0x838>
ffffffffc0201574:	14f00593          	li	a1,335
ffffffffc0201578:	00006517          	auipc	a0,0x6
ffffffffc020157c:	b0050513          	addi	a0,a0,-1280 # ffffffffc0207078 <commands+0x850>
ffffffffc0201580:	ca3fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0201584:	00006697          	auipc	a3,0x6
ffffffffc0201588:	bcc68693          	addi	a3,a3,-1076 # ffffffffc0207150 <commands+0x928>
ffffffffc020158c:	00006617          	auipc	a2,0x6
ffffffffc0201590:	ad460613          	addi	a2,a2,-1324 # ffffffffc0207060 <commands+0x838>
ffffffffc0201594:	13b00593          	li	a1,315
ffffffffc0201598:	00006517          	auipc	a0,0x6
ffffffffc020159c:	ae050513          	addi	a0,a0,-1312 # ffffffffc0207078 <commands+0x850>
ffffffffc02015a0:	c83fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma2 != NULL);
ffffffffc02015a4:	00006697          	auipc	a3,0x6
ffffffffc02015a8:	c0c68693          	addi	a3,a3,-1012 # ffffffffc02071b0 <commands+0x988>
ffffffffc02015ac:	00006617          	auipc	a2,0x6
ffffffffc02015b0:	ab460613          	addi	a2,a2,-1356 # ffffffffc0207060 <commands+0x838>
ffffffffc02015b4:	14600593          	li	a1,326
ffffffffc02015b8:	00006517          	auipc	a0,0x6
ffffffffc02015bc:	ac050513          	addi	a0,a0,-1344 # ffffffffc0207078 <commands+0x850>
ffffffffc02015c0:	c63fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma1 != NULL);
ffffffffc02015c4:	00006697          	auipc	a3,0x6
ffffffffc02015c8:	bdc68693          	addi	a3,a3,-1060 # ffffffffc02071a0 <commands+0x978>
ffffffffc02015cc:	00006617          	auipc	a2,0x6
ffffffffc02015d0:	a9460613          	addi	a2,a2,-1388 # ffffffffc0207060 <commands+0x838>
ffffffffc02015d4:	14400593          	li	a1,324
ffffffffc02015d8:	00006517          	auipc	a0,0x6
ffffffffc02015dc:	aa050513          	addi	a0,a0,-1376 # ffffffffc0207078 <commands+0x850>
ffffffffc02015e0:	c43fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma3 == NULL);
ffffffffc02015e4:	00006697          	auipc	a3,0x6
ffffffffc02015e8:	bdc68693          	addi	a3,a3,-1060 # ffffffffc02071c0 <commands+0x998>
ffffffffc02015ec:	00006617          	auipc	a2,0x6
ffffffffc02015f0:	a7460613          	addi	a2,a2,-1420 # ffffffffc0207060 <commands+0x838>
ffffffffc02015f4:	14800593          	li	a1,328
ffffffffc02015f8:	00006517          	auipc	a0,0x6
ffffffffc02015fc:	a8050513          	addi	a0,a0,-1408 # ffffffffc0207078 <commands+0x850>
ffffffffc0201600:	c23fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma5 == NULL);
ffffffffc0201604:	00006697          	auipc	a3,0x6
ffffffffc0201608:	bdc68693          	addi	a3,a3,-1060 # ffffffffc02071e0 <commands+0x9b8>
ffffffffc020160c:	00006617          	auipc	a2,0x6
ffffffffc0201610:	a5460613          	addi	a2,a2,-1452 # ffffffffc0207060 <commands+0x838>
ffffffffc0201614:	14c00593          	li	a1,332
ffffffffc0201618:	00006517          	auipc	a0,0x6
ffffffffc020161c:	a6050513          	addi	a0,a0,-1440 # ffffffffc0207078 <commands+0x850>
ffffffffc0201620:	c03fe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma4 == NULL);
ffffffffc0201624:	00006697          	auipc	a3,0x6
ffffffffc0201628:	bac68693          	addi	a3,a3,-1108 # ffffffffc02071d0 <commands+0x9a8>
ffffffffc020162c:	00006617          	auipc	a2,0x6
ffffffffc0201630:	a3460613          	addi	a2,a2,-1484 # ffffffffc0207060 <commands+0x838>
ffffffffc0201634:	14a00593          	li	a1,330
ffffffffc0201638:	00006517          	auipc	a0,0x6
ffffffffc020163c:	a4050513          	addi	a0,a0,-1472 # ffffffffc0207078 <commands+0x850>
ffffffffc0201640:	be3fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(mm != NULL);
ffffffffc0201644:	00006697          	auipc	a3,0x6
ffffffffc0201648:	abc68693          	addi	a3,a3,-1348 # ffffffffc0207100 <commands+0x8d8>
ffffffffc020164c:	00006617          	auipc	a2,0x6
ffffffffc0201650:	a1460613          	addi	a2,a2,-1516 # ffffffffc0207060 <commands+0x838>
ffffffffc0201654:	12400593          	li	a1,292
ffffffffc0201658:	00006517          	auipc	a0,0x6
ffffffffc020165c:	a2050513          	addi	a0,a0,-1504 # ffffffffc0207078 <commands+0x850>
ffffffffc0201660:	bc3fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201664 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0201664:	7179                	addi	sp,sp,-48
ffffffffc0201666:	f022                	sd	s0,32(sp)
ffffffffc0201668:	f406                	sd	ra,40(sp)
ffffffffc020166a:	ec26                	sd	s1,24(sp)
ffffffffc020166c:	e84a                	sd	s2,16(sp)
ffffffffc020166e:	e44e                	sd	s3,8(sp)
ffffffffc0201670:	e052                	sd	s4,0(sp)
ffffffffc0201672:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0201674:	c135                	beqz	a0,ffffffffc02016d8 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0201676:	002007b7          	lui	a5,0x200
ffffffffc020167a:	04f5e663          	bltu	a1,a5,ffffffffc02016c6 <user_mem_check+0x62>
ffffffffc020167e:	00c584b3          	add	s1,a1,a2
ffffffffc0201682:	0495f263          	bgeu	a1,s1,ffffffffc02016c6 <user_mem_check+0x62>
ffffffffc0201686:	4785                	li	a5,1
ffffffffc0201688:	07fe                	slli	a5,a5,0x1f
ffffffffc020168a:	0297ee63          	bltu	a5,s1,ffffffffc02016c6 <user_mem_check+0x62>
ffffffffc020168e:	892a                	mv	s2,a0
ffffffffc0201690:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0201692:	6a05                	lui	s4,0x1
ffffffffc0201694:	a821                	j	ffffffffc02016ac <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0201696:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc020169a:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc020169c:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc020169e:	c685                	beqz	a3,ffffffffc02016c6 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc02016a0:	c399                	beqz	a5,ffffffffc02016a6 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc02016a2:	02e46263          	bltu	s0,a4,ffffffffc02016c6 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc02016a6:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc02016a8:	04947663          	bgeu	s0,s1,ffffffffc02016f4 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc02016ac:	85a2                	mv	a1,s0
ffffffffc02016ae:	854a                	mv	a0,s2
ffffffffc02016b0:	969ff0ef          	jal	ra,ffffffffc0201018 <find_vma>
ffffffffc02016b4:	c909                	beqz	a0,ffffffffc02016c6 <user_mem_check+0x62>
ffffffffc02016b6:	6518                	ld	a4,8(a0)
ffffffffc02016b8:	00e46763          	bltu	s0,a4,ffffffffc02016c6 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02016bc:	4d1c                	lw	a5,24(a0)
ffffffffc02016be:	fc099ce3          	bnez	s3,ffffffffc0201696 <user_mem_check+0x32>
ffffffffc02016c2:	8b85                	andi	a5,a5,1
ffffffffc02016c4:	f3ed                	bnez	a5,ffffffffc02016a6 <user_mem_check+0x42>
            return 0;
ffffffffc02016c6:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc02016c8:	70a2                	ld	ra,40(sp)
ffffffffc02016ca:	7402                	ld	s0,32(sp)
ffffffffc02016cc:	64e2                	ld	s1,24(sp)
ffffffffc02016ce:	6942                	ld	s2,16(sp)
ffffffffc02016d0:	69a2                	ld	s3,8(sp)
ffffffffc02016d2:	6a02                	ld	s4,0(sp)
ffffffffc02016d4:	6145                	addi	sp,sp,48
ffffffffc02016d6:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc02016d8:	c02007b7          	lui	a5,0xc0200
ffffffffc02016dc:	4501                	li	a0,0
ffffffffc02016de:	fef5e5e3          	bltu	a1,a5,ffffffffc02016c8 <user_mem_check+0x64>
ffffffffc02016e2:	962e                	add	a2,a2,a1
ffffffffc02016e4:	fec5f2e3          	bgeu	a1,a2,ffffffffc02016c8 <user_mem_check+0x64>
ffffffffc02016e8:	c8000537          	lui	a0,0xc8000
ffffffffc02016ec:	0505                	addi	a0,a0,1
ffffffffc02016ee:	00a63533          	sltu	a0,a2,a0
ffffffffc02016f2:	bfd9                	j	ffffffffc02016c8 <user_mem_check+0x64>
        return 1;
ffffffffc02016f4:	4505                	li	a0,1
ffffffffc02016f6:	bfc9                	j	ffffffffc02016c8 <user_mem_check+0x64>

ffffffffc02016f8 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02016f8:	c94d                	beqz	a0,ffffffffc02017aa <slob_free+0xb2>
{
ffffffffc02016fa:	1141                	addi	sp,sp,-16
ffffffffc02016fc:	e022                	sd	s0,0(sp)
ffffffffc02016fe:	e406                	sd	ra,8(sp)
ffffffffc0201700:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201702:	e9c1                	bnez	a1,ffffffffc0201792 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201704:	100027f3          	csrr	a5,sstatus
ffffffffc0201708:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020170a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020170c:	ebd9                	bnez	a5,ffffffffc02017a2 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020170e:	000da617          	auipc	a2,0xda
ffffffffc0201712:	41a60613          	addi	a2,a2,1050 # ffffffffc02dbb28 <slobfree>
ffffffffc0201716:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201718:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020171a:	679c                	ld	a5,8(a5)
ffffffffc020171c:	02877a63          	bgeu	a4,s0,ffffffffc0201750 <slob_free+0x58>
ffffffffc0201720:	00f46463          	bltu	s0,a5,ffffffffc0201728 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201724:	fef76ae3          	bltu	a4,a5,ffffffffc0201718 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201728:	400c                	lw	a1,0(s0)
ffffffffc020172a:	00459693          	slli	a3,a1,0x4
ffffffffc020172e:	96a2                	add	a3,a3,s0
ffffffffc0201730:	02d78a63          	beq	a5,a3,ffffffffc0201764 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201734:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201736:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201738:	00469793          	slli	a5,a3,0x4
ffffffffc020173c:	97ba                	add	a5,a5,a4
ffffffffc020173e:	02f40e63          	beq	s0,a5,ffffffffc020177a <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201742:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201744:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc0201746:	e129                	bnez	a0,ffffffffc0201788 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201748:	60a2                	ld	ra,8(sp)
ffffffffc020174a:	6402                	ld	s0,0(sp)
ffffffffc020174c:	0141                	addi	sp,sp,16
ffffffffc020174e:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201750:	fcf764e3          	bltu	a4,a5,ffffffffc0201718 <slob_free+0x20>
ffffffffc0201754:	fcf472e3          	bgeu	s0,a5,ffffffffc0201718 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201758:	400c                	lw	a1,0(s0)
ffffffffc020175a:	00459693          	slli	a3,a1,0x4
ffffffffc020175e:	96a2                	add	a3,a3,s0
ffffffffc0201760:	fcd79ae3          	bne	a5,a3,ffffffffc0201734 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201764:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201766:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201768:	9db5                	addw	a1,a1,a3
ffffffffc020176a:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc020176c:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc020176e:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201770:	00469793          	slli	a5,a3,0x4
ffffffffc0201774:	97ba                	add	a5,a5,a4
ffffffffc0201776:	fcf416e3          	bne	s0,a5,ffffffffc0201742 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc020177a:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc020177c:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc020177e:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201780:	9ebd                	addw	a3,a3,a5
ffffffffc0201782:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201784:	e70c                	sd	a1,8(a4)
ffffffffc0201786:	d169                	beqz	a0,ffffffffc0201748 <slob_free+0x50>
}
ffffffffc0201788:	6402                	ld	s0,0(sp)
ffffffffc020178a:	60a2                	ld	ra,8(sp)
ffffffffc020178c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020178e:	a20ff06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201792:	25bd                	addiw	a1,a1,15
ffffffffc0201794:	8191                	srli	a1,a1,0x4
ffffffffc0201796:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201798:	100027f3          	csrr	a5,sstatus
ffffffffc020179c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020179e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017a0:	d7bd                	beqz	a5,ffffffffc020170e <slob_free+0x16>
        intr_disable();
ffffffffc02017a2:	a12ff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02017a6:	4505                	li	a0,1
ffffffffc02017a8:	b79d                	j	ffffffffc020170e <slob_free+0x16>
ffffffffc02017aa:	8082                	ret

ffffffffc02017ac <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc02017ac:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02017ae:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc02017b0:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02017b4:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc02017b6:	601000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
	if (!page)
ffffffffc02017ba:	c91d                	beqz	a0,ffffffffc02017f0 <__slob_get_free_pages.constprop.0+0x44>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc02017bc:	000df697          	auipc	a3,0xdf
ffffffffc02017c0:	96c6b683          	ld	a3,-1684(a3) # ffffffffc02e0128 <pages>
ffffffffc02017c4:	8d15                	sub	a0,a0,a3
ffffffffc02017c6:	8519                	srai	a0,a0,0x6
ffffffffc02017c8:	00008697          	auipc	a3,0x8
ffffffffc02017cc:	c406b683          	ld	a3,-960(a3) # ffffffffc0209408 <nbase>
ffffffffc02017d0:	9536                	add	a0,a0,a3
}

static inline void *
page2kva(struct Page *page)
{
    return KADDR(page2pa(page));
ffffffffc02017d2:	00c51793          	slli	a5,a0,0xc
ffffffffc02017d6:	83b1                	srli	a5,a5,0xc
ffffffffc02017d8:	000df717          	auipc	a4,0xdf
ffffffffc02017dc:	94873703          	ld	a4,-1720(a4) # ffffffffc02e0120 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02017e0:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc02017e2:	00e7fa63          	bgeu	a5,a4,ffffffffc02017f6 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02017e6:	000df697          	auipc	a3,0xdf
ffffffffc02017ea:	9526b683          	ld	a3,-1710(a3) # ffffffffc02e0138 <va_pa_offset>
ffffffffc02017ee:	9536                	add	a0,a0,a3
}
ffffffffc02017f0:	60a2                	ld	ra,8(sp)
ffffffffc02017f2:	0141                	addi	sp,sp,16
ffffffffc02017f4:	8082                	ret
ffffffffc02017f6:	86aa                	mv	a3,a0
ffffffffc02017f8:	00006617          	auipc	a2,0x6
ffffffffc02017fc:	ae060613          	addi	a2,a2,-1312 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0201800:	07100593          	li	a1,113
ffffffffc0201804:	00006517          	auipc	a0,0x6
ffffffffc0201808:	afc50513          	addi	a0,a0,-1284 # ffffffffc0207300 <commands+0xad8>
ffffffffc020180c:	a17fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201810 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201810:	1101                	addi	sp,sp,-32
ffffffffc0201812:	ec06                	sd	ra,24(sp)
ffffffffc0201814:	e822                	sd	s0,16(sp)
ffffffffc0201816:	e426                	sd	s1,8(sp)
ffffffffc0201818:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020181a:	01050713          	addi	a4,a0,16
ffffffffc020181e:	6785                	lui	a5,0x1
ffffffffc0201820:	0cf77363          	bgeu	a4,a5,ffffffffc02018e6 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201824:	00f50493          	addi	s1,a0,15
ffffffffc0201828:	8091                	srli	s1,s1,0x4
ffffffffc020182a:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020182c:	10002673          	csrr	a2,sstatus
ffffffffc0201830:	8a09                	andi	a2,a2,2
ffffffffc0201832:	e25d                	bnez	a2,ffffffffc02018d8 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201834:	000da917          	auipc	s2,0xda
ffffffffc0201838:	2f490913          	addi	s2,s2,756 # ffffffffc02dbb28 <slobfree>
ffffffffc020183c:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201840:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201842:	4398                	lw	a4,0(a5)
ffffffffc0201844:	08975e63          	bge	a4,s1,ffffffffc02018e0 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201848:	00f68b63          	beq	a3,a5,ffffffffc020185e <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc020184c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc020184e:	4018                	lw	a4,0(s0)
ffffffffc0201850:	02975a63          	bge	a4,s1,ffffffffc0201884 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201854:	00093683          	ld	a3,0(s2)
ffffffffc0201858:	87a2                	mv	a5,s0
ffffffffc020185a:	fef699e3          	bne	a3,a5,ffffffffc020184c <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc020185e:	ee31                	bnez	a2,ffffffffc02018ba <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201860:	4501                	li	a0,0
ffffffffc0201862:	f4bff0ef          	jal	ra,ffffffffc02017ac <__slob_get_free_pages.constprop.0>
ffffffffc0201866:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201868:	cd05                	beqz	a0,ffffffffc02018a0 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc020186a:	6585                	lui	a1,0x1
ffffffffc020186c:	e8dff0ef          	jal	ra,ffffffffc02016f8 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201870:	10002673          	csrr	a2,sstatus
ffffffffc0201874:	8a09                	andi	a2,a2,2
ffffffffc0201876:	ee05                	bnez	a2,ffffffffc02018ae <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201878:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc020187c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc020187e:	4018                	lw	a4,0(s0)
ffffffffc0201880:	fc974ae3          	blt	a4,s1,ffffffffc0201854 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201884:	04e48763          	beq	s1,a4,ffffffffc02018d2 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201888:	00449693          	slli	a3,s1,0x4
ffffffffc020188c:	96a2                	add	a3,a3,s0
ffffffffc020188e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201890:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201892:	9f05                	subw	a4,a4,s1
ffffffffc0201894:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201896:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201898:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc020189a:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc020189e:	e20d                	bnez	a2,ffffffffc02018c0 <slob_alloc.constprop.0+0xb0>
}
ffffffffc02018a0:	60e2                	ld	ra,24(sp)
ffffffffc02018a2:	8522                	mv	a0,s0
ffffffffc02018a4:	6442                	ld	s0,16(sp)
ffffffffc02018a6:	64a2                	ld	s1,8(sp)
ffffffffc02018a8:	6902                	ld	s2,0(sp)
ffffffffc02018aa:	6105                	addi	sp,sp,32
ffffffffc02018ac:	8082                	ret
        intr_disable();
ffffffffc02018ae:	906ff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc02018b2:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc02018b6:	4605                	li	a2,1
ffffffffc02018b8:	b7d1                	j	ffffffffc020187c <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02018ba:	8f4ff0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02018be:	b74d                	j	ffffffffc0201860 <slob_alloc.constprop.0+0x50>
ffffffffc02018c0:	8eeff0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02018c4:	60e2                	ld	ra,24(sp)
ffffffffc02018c6:	8522                	mv	a0,s0
ffffffffc02018c8:	6442                	ld	s0,16(sp)
ffffffffc02018ca:	64a2                	ld	s1,8(sp)
ffffffffc02018cc:	6902                	ld	s2,0(sp)
ffffffffc02018ce:	6105                	addi	sp,sp,32
ffffffffc02018d0:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc02018d2:	6418                	ld	a4,8(s0)
ffffffffc02018d4:	e798                	sd	a4,8(a5)
ffffffffc02018d6:	b7d1                	j	ffffffffc020189a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc02018d8:	8dcff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02018dc:	4605                	li	a2,1
ffffffffc02018de:	bf99                	j	ffffffffc0201834 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc02018e0:	843e                	mv	s0,a5
ffffffffc02018e2:	87b6                	mv	a5,a3
ffffffffc02018e4:	b745                	j	ffffffffc0201884 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc02018e6:	00006697          	auipc	a3,0x6
ffffffffc02018ea:	a2a68693          	addi	a3,a3,-1494 # ffffffffc0207310 <commands+0xae8>
ffffffffc02018ee:	00005617          	auipc	a2,0x5
ffffffffc02018f2:	77260613          	addi	a2,a2,1906 # ffffffffc0207060 <commands+0x838>
ffffffffc02018f6:	06300593          	li	a1,99
ffffffffc02018fa:	00006517          	auipc	a0,0x6
ffffffffc02018fe:	a3650513          	addi	a0,a0,-1482 # ffffffffc0207330 <commands+0xb08>
ffffffffc0201902:	921fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201906 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201906:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201908:	00006517          	auipc	a0,0x6
ffffffffc020190c:	a4050513          	addi	a0,a0,-1472 # ffffffffc0207348 <commands+0xb20>
{
ffffffffc0201910:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201912:	fd2fe0ef          	jal	ra,ffffffffc02000e4 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201916:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201918:	00006517          	auipc	a0,0x6
ffffffffc020191c:	a4850513          	addi	a0,a0,-1464 # ffffffffc0207360 <commands+0xb38>
}
ffffffffc0201920:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201922:	fc2fe06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0201926 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201926:	4501                	li	a0,0
ffffffffc0201928:	8082                	ret

ffffffffc020192a <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc020192a:	1101                	addi	sp,sp,-32
ffffffffc020192c:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc020192e:	6905                	lui	s2,0x1
{
ffffffffc0201930:	e822                	sd	s0,16(sp)
ffffffffc0201932:	ec06                	sd	ra,24(sp)
ffffffffc0201934:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201936:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x9189>
{
ffffffffc020193a:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc020193c:	04a7f963          	bgeu	a5,a0,ffffffffc020198e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201940:	4561                	li	a0,24
ffffffffc0201942:	ecfff0ef          	jal	ra,ffffffffc0201810 <slob_alloc.constprop.0>
ffffffffc0201946:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201948:	c929                	beqz	a0,ffffffffc020199a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc020194a:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc020194e:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201950:	00f95763          	bge	s2,a5,ffffffffc020195e <kmalloc+0x34>
ffffffffc0201954:	6705                	lui	a4,0x1
ffffffffc0201956:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201958:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc020195a:	fef74ee3          	blt	a4,a5,ffffffffc0201956 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc020195e:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201960:	e4dff0ef          	jal	ra,ffffffffc02017ac <__slob_get_free_pages.constprop.0>
ffffffffc0201964:	e488                	sd	a0,8(s1)
ffffffffc0201966:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201968:	c525                	beqz	a0,ffffffffc02019d0 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020196a:	100027f3          	csrr	a5,sstatus
ffffffffc020196e:	8b89                	andi	a5,a5,2
ffffffffc0201970:	ef8d                	bnez	a5,ffffffffc02019aa <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201972:	000de797          	auipc	a5,0xde
ffffffffc0201976:	79678793          	addi	a5,a5,1942 # ffffffffc02e0108 <bigblocks>
ffffffffc020197a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc020197c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc020197e:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201980:	60e2                	ld	ra,24(sp)
ffffffffc0201982:	8522                	mv	a0,s0
ffffffffc0201984:	6442                	ld	s0,16(sp)
ffffffffc0201986:	64a2                	ld	s1,8(sp)
ffffffffc0201988:	6902                	ld	s2,0(sp)
ffffffffc020198a:	6105                	addi	sp,sp,32
ffffffffc020198c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc020198e:	0541                	addi	a0,a0,16
ffffffffc0201990:	e81ff0ef          	jal	ra,ffffffffc0201810 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201994:	01050413          	addi	s0,a0,16
ffffffffc0201998:	f565                	bnez	a0,ffffffffc0201980 <kmalloc+0x56>
ffffffffc020199a:	4401                	li	s0,0
}
ffffffffc020199c:	60e2                	ld	ra,24(sp)
ffffffffc020199e:	8522                	mv	a0,s0
ffffffffc02019a0:	6442                	ld	s0,16(sp)
ffffffffc02019a2:	64a2                	ld	s1,8(sp)
ffffffffc02019a4:	6902                	ld	s2,0(sp)
ffffffffc02019a6:	6105                	addi	sp,sp,32
ffffffffc02019a8:	8082                	ret
        intr_disable();
ffffffffc02019aa:	80aff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc02019ae:	000de797          	auipc	a5,0xde
ffffffffc02019b2:	75a78793          	addi	a5,a5,1882 # ffffffffc02e0108 <bigblocks>
ffffffffc02019b6:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02019b8:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02019ba:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc02019bc:	ff3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc02019c0:	6480                	ld	s0,8(s1)
}
ffffffffc02019c2:	60e2                	ld	ra,24(sp)
ffffffffc02019c4:	64a2                	ld	s1,8(sp)
ffffffffc02019c6:	8522                	mv	a0,s0
ffffffffc02019c8:	6442                	ld	s0,16(sp)
ffffffffc02019ca:	6902                	ld	s2,0(sp)
ffffffffc02019cc:	6105                	addi	sp,sp,32
ffffffffc02019ce:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc02019d0:	45e1                	li	a1,24
ffffffffc02019d2:	8526                	mv	a0,s1
ffffffffc02019d4:	d25ff0ef          	jal	ra,ffffffffc02016f8 <slob_free>
	return __kmalloc(size, 0);
ffffffffc02019d8:	b765                	j	ffffffffc0201980 <kmalloc+0x56>

ffffffffc02019da <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc02019da:	c169                	beqz	a0,ffffffffc0201a9c <kfree+0xc2>
{
ffffffffc02019dc:	1101                	addi	sp,sp,-32
ffffffffc02019de:	e822                	sd	s0,16(sp)
ffffffffc02019e0:	ec06                	sd	ra,24(sp)
ffffffffc02019e2:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc02019e4:	03451793          	slli	a5,a0,0x34
ffffffffc02019e8:	842a                	mv	s0,a0
ffffffffc02019ea:	e3d9                	bnez	a5,ffffffffc0201a70 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019ec:	100027f3          	csrr	a5,sstatus
ffffffffc02019f0:	8b89                	andi	a5,a5,2
ffffffffc02019f2:	e7d9                	bnez	a5,ffffffffc0201a80 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc02019f4:	000de797          	auipc	a5,0xde
ffffffffc02019f8:	7147b783          	ld	a5,1812(a5) # ffffffffc02e0108 <bigblocks>
    return 0;
ffffffffc02019fc:	4601                	li	a2,0
ffffffffc02019fe:	cbad                	beqz	a5,ffffffffc0201a70 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201a00:	000de697          	auipc	a3,0xde
ffffffffc0201a04:	70868693          	addi	a3,a3,1800 # ffffffffc02e0108 <bigblocks>
ffffffffc0201a08:	a021                	j	ffffffffc0201a10 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201a0a:	01048693          	addi	a3,s1,16
ffffffffc0201a0e:	c3a5                	beqz	a5,ffffffffc0201a6e <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201a10:	6798                	ld	a4,8(a5)
ffffffffc0201a12:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201a14:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201a16:	fe871ae3          	bne	a4,s0,ffffffffc0201a0a <kfree+0x30>
				*last = bb->next;
ffffffffc0201a1a:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201a1c:	ee2d                	bnez	a2,ffffffffc0201a96 <kfree+0xbc>
}

static inline struct Page *
kva2page(void *kva)
{
    return pa2page(PADDR(kva));
ffffffffc0201a1e:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201a22:	4098                	lw	a4,0(s1)
ffffffffc0201a24:	08f46963          	bltu	s0,a5,ffffffffc0201ab6 <kfree+0xdc>
ffffffffc0201a28:	000de697          	auipc	a3,0xde
ffffffffc0201a2c:	7106b683          	ld	a3,1808(a3) # ffffffffc02e0138 <va_pa_offset>
ffffffffc0201a30:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201a32:	8031                	srli	s0,s0,0xc
ffffffffc0201a34:	000de797          	auipc	a5,0xde
ffffffffc0201a38:	6ec7b783          	ld	a5,1772(a5) # ffffffffc02e0120 <npage>
ffffffffc0201a3c:	06f47163          	bgeu	s0,a5,ffffffffc0201a9e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201a40:	00008517          	auipc	a0,0x8
ffffffffc0201a44:	9c853503          	ld	a0,-1592(a0) # ffffffffc0209408 <nbase>
ffffffffc0201a48:	8c09                	sub	s0,s0,a0
ffffffffc0201a4a:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201a4c:	000de517          	auipc	a0,0xde
ffffffffc0201a50:	6dc53503          	ld	a0,1756(a0) # ffffffffc02e0128 <pages>
ffffffffc0201a54:	4585                	li	a1,1
ffffffffc0201a56:	9522                	add	a0,a0,s0
ffffffffc0201a58:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201a5c:	399000ef          	jal	ra,ffffffffc02025f4 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201a60:	6442                	ld	s0,16(sp)
ffffffffc0201a62:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a64:	8526                	mv	a0,s1
}
ffffffffc0201a66:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a68:	45e1                	li	a1,24
}
ffffffffc0201a6a:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201a6c:	b171                	j	ffffffffc02016f8 <slob_free>
ffffffffc0201a6e:	e20d                	bnez	a2,ffffffffc0201a90 <kfree+0xb6>
ffffffffc0201a70:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201a74:	6442                	ld	s0,16(sp)
ffffffffc0201a76:	60e2                	ld	ra,24(sp)
ffffffffc0201a78:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201a7a:	4581                	li	a1,0
}
ffffffffc0201a7c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201a7e:	b9ad                	j	ffffffffc02016f8 <slob_free>
        intr_disable();
ffffffffc0201a80:	f35fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201a84:	000de797          	auipc	a5,0xde
ffffffffc0201a88:	6847b783          	ld	a5,1668(a5) # ffffffffc02e0108 <bigblocks>
        return 1;
ffffffffc0201a8c:	4605                	li	a2,1
ffffffffc0201a8e:	fbad                	bnez	a5,ffffffffc0201a00 <kfree+0x26>
        intr_enable();
ffffffffc0201a90:	f1ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201a94:	bff1                	j	ffffffffc0201a70 <kfree+0x96>
ffffffffc0201a96:	f19fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201a9a:	b751                	j	ffffffffc0201a1e <kfree+0x44>
ffffffffc0201a9c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201a9e:	00006617          	auipc	a2,0x6
ffffffffc0201aa2:	90a60613          	addi	a2,a2,-1782 # ffffffffc02073a8 <commands+0xb80>
ffffffffc0201aa6:	06900593          	li	a1,105
ffffffffc0201aaa:	00006517          	auipc	a0,0x6
ffffffffc0201aae:	85650513          	addi	a0,a0,-1962 # ffffffffc0207300 <commands+0xad8>
ffffffffc0201ab2:	f70fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201ab6:	86a2                	mv	a3,s0
ffffffffc0201ab8:	00006617          	auipc	a2,0x6
ffffffffc0201abc:	8c860613          	addi	a2,a2,-1848 # ffffffffc0207380 <commands+0xb58>
ffffffffc0201ac0:	07700593          	li	a1,119
ffffffffc0201ac4:	00006517          	auipc	a0,0x6
ffffffffc0201ac8:	83c50513          	addi	a0,a0,-1988 # ffffffffc0207300 <commands+0xad8>
ffffffffc0201acc:	f56fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201ad0 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201ad0:	000da797          	auipc	a5,0xda
ffffffffc0201ad4:	47078793          	addi	a5,a5,1136 # ffffffffc02dbf40 <free_area>
ffffffffc0201ad8:	e79c                	sd	a5,8(a5)
ffffffffc0201ada:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201adc:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201ae0:	8082                	ret

ffffffffc0201ae2 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201ae2:	000da517          	auipc	a0,0xda
ffffffffc0201ae6:	46e56503          	lwu	a0,1134(a0) # ffffffffc02dbf50 <free_area+0x10>
ffffffffc0201aea:	8082                	ret

ffffffffc0201aec <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201aec:	715d                	addi	sp,sp,-80
ffffffffc0201aee:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201af0:	000da417          	auipc	s0,0xda
ffffffffc0201af4:	45040413          	addi	s0,s0,1104 # ffffffffc02dbf40 <free_area>
ffffffffc0201af8:	641c                	ld	a5,8(s0)
ffffffffc0201afa:	e486                	sd	ra,72(sp)
ffffffffc0201afc:	fc26                	sd	s1,56(sp)
ffffffffc0201afe:	f84a                	sd	s2,48(sp)
ffffffffc0201b00:	f44e                	sd	s3,40(sp)
ffffffffc0201b02:	f052                	sd	s4,32(sp)
ffffffffc0201b04:	ec56                	sd	s5,24(sp)
ffffffffc0201b06:	e85a                	sd	s6,16(sp)
ffffffffc0201b08:	e45e                	sd	s7,8(sp)
ffffffffc0201b0a:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201b0c:	2a878d63          	beq	a5,s0,ffffffffc0201dc6 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0201b10:	4481                	li	s1,0
ffffffffc0201b12:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201b14:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201b18:	8b09                	andi	a4,a4,2
ffffffffc0201b1a:	2a070a63          	beqz	a4,ffffffffc0201dce <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0201b1e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b22:	679c                	ld	a5,8(a5)
ffffffffc0201b24:	2905                	addiw	s2,s2,1
ffffffffc0201b26:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201b28:	fe8796e3          	bne	a5,s0,ffffffffc0201b14 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201b2c:	89a6                	mv	s3,s1
ffffffffc0201b2e:	307000ef          	jal	ra,ffffffffc0202634 <nr_free_pages>
ffffffffc0201b32:	6f351e63          	bne	a0,s3,ffffffffc020222e <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201b36:	4505                	li	a0,1
ffffffffc0201b38:	27f000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201b3c:	8aaa                	mv	s5,a0
ffffffffc0201b3e:	42050863          	beqz	a0,ffffffffc0201f6e <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201b42:	4505                	li	a0,1
ffffffffc0201b44:	273000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201b48:	89aa                	mv	s3,a0
ffffffffc0201b4a:	70050263          	beqz	a0,ffffffffc020224e <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201b4e:	4505                	li	a0,1
ffffffffc0201b50:	267000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201b54:	8a2a                	mv	s4,a0
ffffffffc0201b56:	48050c63          	beqz	a0,ffffffffc0201fee <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201b5a:	293a8a63          	beq	s5,s3,ffffffffc0201dee <default_check+0x302>
ffffffffc0201b5e:	28aa8863          	beq	s5,a0,ffffffffc0201dee <default_check+0x302>
ffffffffc0201b62:	28a98663          	beq	s3,a0,ffffffffc0201dee <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201b66:	000aa783          	lw	a5,0(s5)
ffffffffc0201b6a:	2a079263          	bnez	a5,ffffffffc0201e0e <default_check+0x322>
ffffffffc0201b6e:	0009a783          	lw	a5,0(s3)
ffffffffc0201b72:	28079e63          	bnez	a5,ffffffffc0201e0e <default_check+0x322>
ffffffffc0201b76:	411c                	lw	a5,0(a0)
ffffffffc0201b78:	28079b63          	bnez	a5,ffffffffc0201e0e <default_check+0x322>
    return page - pages + nbase;
ffffffffc0201b7c:	000de797          	auipc	a5,0xde
ffffffffc0201b80:	5ac7b783          	ld	a5,1452(a5) # ffffffffc02e0128 <pages>
ffffffffc0201b84:	40fa8733          	sub	a4,s5,a5
ffffffffc0201b88:	00008617          	auipc	a2,0x8
ffffffffc0201b8c:	88063603          	ld	a2,-1920(a2) # ffffffffc0209408 <nbase>
ffffffffc0201b90:	8719                	srai	a4,a4,0x6
ffffffffc0201b92:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201b94:	000de697          	auipc	a3,0xde
ffffffffc0201b98:	58c6b683          	ld	a3,1420(a3) # ffffffffc02e0120 <npage>
ffffffffc0201b9c:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b9e:	0732                	slli	a4,a4,0xc
ffffffffc0201ba0:	28d77763          	bgeu	a4,a3,ffffffffc0201e2e <default_check+0x342>
    return page - pages + nbase;
ffffffffc0201ba4:	40f98733          	sub	a4,s3,a5
ffffffffc0201ba8:	8719                	srai	a4,a4,0x6
ffffffffc0201baa:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bac:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201bae:	4cd77063          	bgeu	a4,a3,ffffffffc020206e <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201bb2:	40f507b3          	sub	a5,a0,a5
ffffffffc0201bb6:	8799                	srai	a5,a5,0x6
ffffffffc0201bb8:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bba:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201bbc:	30d7f963          	bgeu	a5,a3,ffffffffc0201ece <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201bc0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201bc2:	00043c03          	ld	s8,0(s0)
ffffffffc0201bc6:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201bca:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201bce:	e400                	sd	s0,8(s0)
ffffffffc0201bd0:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201bd2:	000da797          	auipc	a5,0xda
ffffffffc0201bd6:	3607af23          	sw	zero,894(a5) # ffffffffc02dbf50 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201bda:	1dd000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201bde:	2c051863          	bnez	a0,ffffffffc0201eae <default_check+0x3c2>
    free_page(p0);
ffffffffc0201be2:	4585                	li	a1,1
ffffffffc0201be4:	8556                	mv	a0,s5
ffffffffc0201be6:	20f000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    free_page(p1);
ffffffffc0201bea:	4585                	li	a1,1
ffffffffc0201bec:	854e                	mv	a0,s3
ffffffffc0201bee:	207000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    free_page(p2);
ffffffffc0201bf2:	4585                	li	a1,1
ffffffffc0201bf4:	8552                	mv	a0,s4
ffffffffc0201bf6:	1ff000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    assert(nr_free == 3);
ffffffffc0201bfa:	4818                	lw	a4,16(s0)
ffffffffc0201bfc:	478d                	li	a5,3
ffffffffc0201bfe:	28f71863          	bne	a4,a5,ffffffffc0201e8e <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201c02:	4505                	li	a0,1
ffffffffc0201c04:	1b3000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c08:	89aa                	mv	s3,a0
ffffffffc0201c0a:	26050263          	beqz	a0,ffffffffc0201e6e <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201c0e:	4505                	li	a0,1
ffffffffc0201c10:	1a7000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c14:	8aaa                	mv	s5,a0
ffffffffc0201c16:	3a050c63          	beqz	a0,ffffffffc0201fce <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201c1a:	4505                	li	a0,1
ffffffffc0201c1c:	19b000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c20:	8a2a                	mv	s4,a0
ffffffffc0201c22:	38050663          	beqz	a0,ffffffffc0201fae <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201c26:	4505                	li	a0,1
ffffffffc0201c28:	18f000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c2c:	36051163          	bnez	a0,ffffffffc0201f8e <default_check+0x4a2>
    free_page(p0);
ffffffffc0201c30:	4585                	li	a1,1
ffffffffc0201c32:	854e                	mv	a0,s3
ffffffffc0201c34:	1c1000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201c38:	641c                	ld	a5,8(s0)
ffffffffc0201c3a:	20878a63          	beq	a5,s0,ffffffffc0201e4e <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201c3e:	4505                	li	a0,1
ffffffffc0201c40:	177000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c44:	30a99563          	bne	s3,a0,ffffffffc0201f4e <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201c48:	4505                	li	a0,1
ffffffffc0201c4a:	16d000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c4e:	2e051063          	bnez	a0,ffffffffc0201f2e <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201c52:	481c                	lw	a5,16(s0)
ffffffffc0201c54:	2a079d63          	bnez	a5,ffffffffc0201f0e <default_check+0x422>
    free_page(p);
ffffffffc0201c58:	854e                	mv	a0,s3
ffffffffc0201c5a:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201c5c:	01843023          	sd	s8,0(s0)
ffffffffc0201c60:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201c64:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201c68:	18d000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    free_page(p1);
ffffffffc0201c6c:	4585                	li	a1,1
ffffffffc0201c6e:	8556                	mv	a0,s5
ffffffffc0201c70:	185000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    free_page(p2);
ffffffffc0201c74:	4585                	li	a1,1
ffffffffc0201c76:	8552                	mv	a0,s4
ffffffffc0201c78:	17d000ef          	jal	ra,ffffffffc02025f4 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201c7c:	4515                	li	a0,5
ffffffffc0201c7e:	139000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201c82:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201c84:	26050563          	beqz	a0,ffffffffc0201eee <default_check+0x402>
ffffffffc0201c88:	651c                	ld	a5,8(a0)
ffffffffc0201c8a:	8385                	srli	a5,a5,0x1
ffffffffc0201c8c:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201c8e:	54079063          	bnez	a5,ffffffffc02021ce <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201c92:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201c94:	00043b03          	ld	s6,0(s0)
ffffffffc0201c98:	00843a83          	ld	s5,8(s0)
ffffffffc0201c9c:	e000                	sd	s0,0(s0)
ffffffffc0201c9e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201ca0:	117000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201ca4:	50051563          	bnez	a0,ffffffffc02021ae <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201ca8:	08098a13          	addi	s4,s3,128
ffffffffc0201cac:	8552                	mv	a0,s4
ffffffffc0201cae:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201cb0:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201cb4:	000da797          	auipc	a5,0xda
ffffffffc0201cb8:	2807ae23          	sw	zero,668(a5) # ffffffffc02dbf50 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201cbc:	139000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201cc0:	4511                	li	a0,4
ffffffffc0201cc2:	0f5000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201cc6:	4c051463          	bnez	a0,ffffffffc020218e <default_check+0x6a2>
ffffffffc0201cca:	0889b783          	ld	a5,136(s3)
ffffffffc0201cce:	8385                	srli	a5,a5,0x1
ffffffffc0201cd0:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201cd2:	48078e63          	beqz	a5,ffffffffc020216e <default_check+0x682>
ffffffffc0201cd6:	0909a703          	lw	a4,144(s3)
ffffffffc0201cda:	478d                	li	a5,3
ffffffffc0201cdc:	48f71963          	bne	a4,a5,ffffffffc020216e <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201ce0:	450d                	li	a0,3
ffffffffc0201ce2:	0d5000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201ce6:	8c2a                	mv	s8,a0
ffffffffc0201ce8:	46050363          	beqz	a0,ffffffffc020214e <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201cec:	4505                	li	a0,1
ffffffffc0201cee:	0c9000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201cf2:	42051e63          	bnez	a0,ffffffffc020212e <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201cf6:	418a1c63          	bne	s4,s8,ffffffffc020210e <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201cfa:	4585                	li	a1,1
ffffffffc0201cfc:	854e                	mv	a0,s3
ffffffffc0201cfe:	0f7000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    free_pages(p1, 3);
ffffffffc0201d02:	458d                	li	a1,3
ffffffffc0201d04:	8552                	mv	a0,s4
ffffffffc0201d06:	0ef000ef          	jal	ra,ffffffffc02025f4 <free_pages>
ffffffffc0201d0a:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201d0e:	04098c13          	addi	s8,s3,64
ffffffffc0201d12:	8385                	srli	a5,a5,0x1
ffffffffc0201d14:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201d16:	3c078c63          	beqz	a5,ffffffffc02020ee <default_check+0x602>
ffffffffc0201d1a:	0109a703          	lw	a4,16(s3)
ffffffffc0201d1e:	4785                	li	a5,1
ffffffffc0201d20:	3cf71763          	bne	a4,a5,ffffffffc02020ee <default_check+0x602>
ffffffffc0201d24:	008a3783          	ld	a5,8(s4) # 1008 <_binary_obj___user_faultread_out_size-0x9170>
ffffffffc0201d28:	8385                	srli	a5,a5,0x1
ffffffffc0201d2a:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201d2c:	3a078163          	beqz	a5,ffffffffc02020ce <default_check+0x5e2>
ffffffffc0201d30:	010a2703          	lw	a4,16(s4)
ffffffffc0201d34:	478d                	li	a5,3
ffffffffc0201d36:	38f71c63          	bne	a4,a5,ffffffffc02020ce <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201d3a:	4505                	li	a0,1
ffffffffc0201d3c:	07b000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201d40:	36a99763          	bne	s3,a0,ffffffffc02020ae <default_check+0x5c2>
    free_page(p0);
ffffffffc0201d44:	4585                	li	a1,1
ffffffffc0201d46:	0af000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201d4a:	4509                	li	a0,2
ffffffffc0201d4c:	06b000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201d50:	32aa1f63          	bne	s4,a0,ffffffffc020208e <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201d54:	4589                	li	a1,2
ffffffffc0201d56:	09f000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    free_page(p2);
ffffffffc0201d5a:	4585                	li	a1,1
ffffffffc0201d5c:	8562                	mv	a0,s8
ffffffffc0201d5e:	097000ef          	jal	ra,ffffffffc02025f4 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201d62:	4515                	li	a0,5
ffffffffc0201d64:	053000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201d68:	89aa                	mv	s3,a0
ffffffffc0201d6a:	48050263          	beqz	a0,ffffffffc02021ee <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201d6e:	4505                	li	a0,1
ffffffffc0201d70:	047000ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0201d74:	2c051d63          	bnez	a0,ffffffffc020204e <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201d78:	481c                	lw	a5,16(s0)
ffffffffc0201d7a:	2a079a63          	bnez	a5,ffffffffc020202e <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201d7e:	4595                	li	a1,5
ffffffffc0201d80:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201d82:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201d86:	01643023          	sd	s6,0(s0)
ffffffffc0201d8a:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201d8e:	067000ef          	jal	ra,ffffffffc02025f4 <free_pages>
    return listelm->next;
ffffffffc0201d92:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201d94:	00878963          	beq	a5,s0,ffffffffc0201da6 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201d98:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201d9c:	679c                	ld	a5,8(a5)
ffffffffc0201d9e:	397d                	addiw	s2,s2,-1
ffffffffc0201da0:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201da2:	fe879be3          	bne	a5,s0,ffffffffc0201d98 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201da6:	26091463          	bnez	s2,ffffffffc020200e <default_check+0x522>
    assert(total == 0);
ffffffffc0201daa:	46049263          	bnez	s1,ffffffffc020220e <default_check+0x722>
}
ffffffffc0201dae:	60a6                	ld	ra,72(sp)
ffffffffc0201db0:	6406                	ld	s0,64(sp)
ffffffffc0201db2:	74e2                	ld	s1,56(sp)
ffffffffc0201db4:	7942                	ld	s2,48(sp)
ffffffffc0201db6:	79a2                	ld	s3,40(sp)
ffffffffc0201db8:	7a02                	ld	s4,32(sp)
ffffffffc0201dba:	6ae2                	ld	s5,24(sp)
ffffffffc0201dbc:	6b42                	ld	s6,16(sp)
ffffffffc0201dbe:	6ba2                	ld	s7,8(sp)
ffffffffc0201dc0:	6c02                	ld	s8,0(sp)
ffffffffc0201dc2:	6161                	addi	sp,sp,80
ffffffffc0201dc4:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201dc6:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201dc8:	4481                	li	s1,0
ffffffffc0201dca:	4901                	li	s2,0
ffffffffc0201dcc:	b38d                	j	ffffffffc0201b2e <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201dce:	00005697          	auipc	a3,0x5
ffffffffc0201dd2:	5fa68693          	addi	a3,a3,1530 # ffffffffc02073c8 <commands+0xba0>
ffffffffc0201dd6:	00005617          	auipc	a2,0x5
ffffffffc0201dda:	28a60613          	addi	a2,a2,650 # ffffffffc0207060 <commands+0x838>
ffffffffc0201dde:	0ef00593          	li	a1,239
ffffffffc0201de2:	00005517          	auipc	a0,0x5
ffffffffc0201de6:	5f650513          	addi	a0,a0,1526 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201dea:	c38fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201dee:	00005697          	auipc	a3,0x5
ffffffffc0201df2:	68268693          	addi	a3,a3,1666 # ffffffffc0207470 <commands+0xc48>
ffffffffc0201df6:	00005617          	auipc	a2,0x5
ffffffffc0201dfa:	26a60613          	addi	a2,a2,618 # ffffffffc0207060 <commands+0x838>
ffffffffc0201dfe:	0bc00593          	li	a1,188
ffffffffc0201e02:	00005517          	auipc	a0,0x5
ffffffffc0201e06:	5d650513          	addi	a0,a0,1494 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201e0a:	c18fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201e0e:	00005697          	auipc	a3,0x5
ffffffffc0201e12:	68a68693          	addi	a3,a3,1674 # ffffffffc0207498 <commands+0xc70>
ffffffffc0201e16:	00005617          	auipc	a2,0x5
ffffffffc0201e1a:	24a60613          	addi	a2,a2,586 # ffffffffc0207060 <commands+0x838>
ffffffffc0201e1e:	0bd00593          	li	a1,189
ffffffffc0201e22:	00005517          	auipc	a0,0x5
ffffffffc0201e26:	5b650513          	addi	a0,a0,1462 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201e2a:	bf8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201e2e:	00005697          	auipc	a3,0x5
ffffffffc0201e32:	6aa68693          	addi	a3,a3,1706 # ffffffffc02074d8 <commands+0xcb0>
ffffffffc0201e36:	00005617          	auipc	a2,0x5
ffffffffc0201e3a:	22a60613          	addi	a2,a2,554 # ffffffffc0207060 <commands+0x838>
ffffffffc0201e3e:	0bf00593          	li	a1,191
ffffffffc0201e42:	00005517          	auipc	a0,0x5
ffffffffc0201e46:	59650513          	addi	a0,a0,1430 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201e4a:	bd8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201e4e:	00005697          	auipc	a3,0x5
ffffffffc0201e52:	71268693          	addi	a3,a3,1810 # ffffffffc0207560 <commands+0xd38>
ffffffffc0201e56:	00005617          	auipc	a2,0x5
ffffffffc0201e5a:	20a60613          	addi	a2,a2,522 # ffffffffc0207060 <commands+0x838>
ffffffffc0201e5e:	0d800593          	li	a1,216
ffffffffc0201e62:	00005517          	auipc	a0,0x5
ffffffffc0201e66:	57650513          	addi	a0,a0,1398 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201e6a:	bb8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201e6e:	00005697          	auipc	a3,0x5
ffffffffc0201e72:	5a268693          	addi	a3,a3,1442 # ffffffffc0207410 <commands+0xbe8>
ffffffffc0201e76:	00005617          	auipc	a2,0x5
ffffffffc0201e7a:	1ea60613          	addi	a2,a2,490 # ffffffffc0207060 <commands+0x838>
ffffffffc0201e7e:	0d100593          	li	a1,209
ffffffffc0201e82:	00005517          	auipc	a0,0x5
ffffffffc0201e86:	55650513          	addi	a0,a0,1366 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201e8a:	b98fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free == 3);
ffffffffc0201e8e:	00005697          	auipc	a3,0x5
ffffffffc0201e92:	6c268693          	addi	a3,a3,1730 # ffffffffc0207550 <commands+0xd28>
ffffffffc0201e96:	00005617          	auipc	a2,0x5
ffffffffc0201e9a:	1ca60613          	addi	a2,a2,458 # ffffffffc0207060 <commands+0x838>
ffffffffc0201e9e:	0cf00593          	li	a1,207
ffffffffc0201ea2:	00005517          	auipc	a0,0x5
ffffffffc0201ea6:	53650513          	addi	a0,a0,1334 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201eaa:	b78fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201eae:	00005697          	auipc	a3,0x5
ffffffffc0201eb2:	68a68693          	addi	a3,a3,1674 # ffffffffc0207538 <commands+0xd10>
ffffffffc0201eb6:	00005617          	auipc	a2,0x5
ffffffffc0201eba:	1aa60613          	addi	a2,a2,426 # ffffffffc0207060 <commands+0x838>
ffffffffc0201ebe:	0ca00593          	li	a1,202
ffffffffc0201ec2:	00005517          	auipc	a0,0x5
ffffffffc0201ec6:	51650513          	addi	a0,a0,1302 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201eca:	b58fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201ece:	00005697          	auipc	a3,0x5
ffffffffc0201ed2:	64a68693          	addi	a3,a3,1610 # ffffffffc0207518 <commands+0xcf0>
ffffffffc0201ed6:	00005617          	auipc	a2,0x5
ffffffffc0201eda:	18a60613          	addi	a2,a2,394 # ffffffffc0207060 <commands+0x838>
ffffffffc0201ede:	0c100593          	li	a1,193
ffffffffc0201ee2:	00005517          	auipc	a0,0x5
ffffffffc0201ee6:	4f650513          	addi	a0,a0,1270 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201eea:	b38fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(p0 != NULL);
ffffffffc0201eee:	00005697          	auipc	a3,0x5
ffffffffc0201ef2:	6ba68693          	addi	a3,a3,1722 # ffffffffc02075a8 <commands+0xd80>
ffffffffc0201ef6:	00005617          	auipc	a2,0x5
ffffffffc0201efa:	16a60613          	addi	a2,a2,362 # ffffffffc0207060 <commands+0x838>
ffffffffc0201efe:	0f700593          	li	a1,247
ffffffffc0201f02:	00005517          	auipc	a0,0x5
ffffffffc0201f06:	4d650513          	addi	a0,a0,1238 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201f0a:	b18fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free == 0);
ffffffffc0201f0e:	00005697          	auipc	a3,0x5
ffffffffc0201f12:	68a68693          	addi	a3,a3,1674 # ffffffffc0207598 <commands+0xd70>
ffffffffc0201f16:	00005617          	auipc	a2,0x5
ffffffffc0201f1a:	14a60613          	addi	a2,a2,330 # ffffffffc0207060 <commands+0x838>
ffffffffc0201f1e:	0de00593          	li	a1,222
ffffffffc0201f22:	00005517          	auipc	a0,0x5
ffffffffc0201f26:	4b650513          	addi	a0,a0,1206 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201f2a:	af8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201f2e:	00005697          	auipc	a3,0x5
ffffffffc0201f32:	60a68693          	addi	a3,a3,1546 # ffffffffc0207538 <commands+0xd10>
ffffffffc0201f36:	00005617          	auipc	a2,0x5
ffffffffc0201f3a:	12a60613          	addi	a2,a2,298 # ffffffffc0207060 <commands+0x838>
ffffffffc0201f3e:	0dc00593          	li	a1,220
ffffffffc0201f42:	00005517          	auipc	a0,0x5
ffffffffc0201f46:	49650513          	addi	a0,a0,1174 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201f4a:	ad8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201f4e:	00005697          	auipc	a3,0x5
ffffffffc0201f52:	62a68693          	addi	a3,a3,1578 # ffffffffc0207578 <commands+0xd50>
ffffffffc0201f56:	00005617          	auipc	a2,0x5
ffffffffc0201f5a:	10a60613          	addi	a2,a2,266 # ffffffffc0207060 <commands+0x838>
ffffffffc0201f5e:	0db00593          	li	a1,219
ffffffffc0201f62:	00005517          	auipc	a0,0x5
ffffffffc0201f66:	47650513          	addi	a0,a0,1142 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201f6a:	ab8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201f6e:	00005697          	auipc	a3,0x5
ffffffffc0201f72:	4a268693          	addi	a3,a3,1186 # ffffffffc0207410 <commands+0xbe8>
ffffffffc0201f76:	00005617          	auipc	a2,0x5
ffffffffc0201f7a:	0ea60613          	addi	a2,a2,234 # ffffffffc0207060 <commands+0x838>
ffffffffc0201f7e:	0b800593          	li	a1,184
ffffffffc0201f82:	00005517          	auipc	a0,0x5
ffffffffc0201f86:	45650513          	addi	a0,a0,1110 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201f8a:	a98fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201f8e:	00005697          	auipc	a3,0x5
ffffffffc0201f92:	5aa68693          	addi	a3,a3,1450 # ffffffffc0207538 <commands+0xd10>
ffffffffc0201f96:	00005617          	auipc	a2,0x5
ffffffffc0201f9a:	0ca60613          	addi	a2,a2,202 # ffffffffc0207060 <commands+0x838>
ffffffffc0201f9e:	0d500593          	li	a1,213
ffffffffc0201fa2:	00005517          	auipc	a0,0x5
ffffffffc0201fa6:	43650513          	addi	a0,a0,1078 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201faa:	a78fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201fae:	00005697          	auipc	a3,0x5
ffffffffc0201fb2:	4a268693          	addi	a3,a3,1186 # ffffffffc0207450 <commands+0xc28>
ffffffffc0201fb6:	00005617          	auipc	a2,0x5
ffffffffc0201fba:	0aa60613          	addi	a2,a2,170 # ffffffffc0207060 <commands+0x838>
ffffffffc0201fbe:	0d300593          	li	a1,211
ffffffffc0201fc2:	00005517          	auipc	a0,0x5
ffffffffc0201fc6:	41650513          	addi	a0,a0,1046 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201fca:	a58fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201fce:	00005697          	auipc	a3,0x5
ffffffffc0201fd2:	46268693          	addi	a3,a3,1122 # ffffffffc0207430 <commands+0xc08>
ffffffffc0201fd6:	00005617          	auipc	a2,0x5
ffffffffc0201fda:	08a60613          	addi	a2,a2,138 # ffffffffc0207060 <commands+0x838>
ffffffffc0201fde:	0d200593          	li	a1,210
ffffffffc0201fe2:	00005517          	auipc	a0,0x5
ffffffffc0201fe6:	3f650513          	addi	a0,a0,1014 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc0201fea:	a38fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201fee:	00005697          	auipc	a3,0x5
ffffffffc0201ff2:	46268693          	addi	a3,a3,1122 # ffffffffc0207450 <commands+0xc28>
ffffffffc0201ff6:	00005617          	auipc	a2,0x5
ffffffffc0201ffa:	06a60613          	addi	a2,a2,106 # ffffffffc0207060 <commands+0x838>
ffffffffc0201ffe:	0ba00593          	li	a1,186
ffffffffc0202002:	00005517          	auipc	a0,0x5
ffffffffc0202006:	3d650513          	addi	a0,a0,982 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020200a:	a18fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(count == 0);
ffffffffc020200e:	00005697          	auipc	a3,0x5
ffffffffc0202012:	6ea68693          	addi	a3,a3,1770 # ffffffffc02076f8 <commands+0xed0>
ffffffffc0202016:	00005617          	auipc	a2,0x5
ffffffffc020201a:	04a60613          	addi	a2,a2,74 # ffffffffc0207060 <commands+0x838>
ffffffffc020201e:	12400593          	li	a1,292
ffffffffc0202022:	00005517          	auipc	a0,0x5
ffffffffc0202026:	3b650513          	addi	a0,a0,950 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020202a:	9f8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free == 0);
ffffffffc020202e:	00005697          	auipc	a3,0x5
ffffffffc0202032:	56a68693          	addi	a3,a3,1386 # ffffffffc0207598 <commands+0xd70>
ffffffffc0202036:	00005617          	auipc	a2,0x5
ffffffffc020203a:	02a60613          	addi	a2,a2,42 # ffffffffc0207060 <commands+0x838>
ffffffffc020203e:	11900593          	li	a1,281
ffffffffc0202042:	00005517          	auipc	a0,0x5
ffffffffc0202046:	39650513          	addi	a0,a0,918 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020204a:	9d8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020204e:	00005697          	auipc	a3,0x5
ffffffffc0202052:	4ea68693          	addi	a3,a3,1258 # ffffffffc0207538 <commands+0xd10>
ffffffffc0202056:	00005617          	auipc	a2,0x5
ffffffffc020205a:	00a60613          	addi	a2,a2,10 # ffffffffc0207060 <commands+0x838>
ffffffffc020205e:	11700593          	li	a1,279
ffffffffc0202062:	00005517          	auipc	a0,0x5
ffffffffc0202066:	37650513          	addi	a0,a0,886 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020206a:	9b8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020206e:	00005697          	auipc	a3,0x5
ffffffffc0202072:	48a68693          	addi	a3,a3,1162 # ffffffffc02074f8 <commands+0xcd0>
ffffffffc0202076:	00005617          	auipc	a2,0x5
ffffffffc020207a:	fea60613          	addi	a2,a2,-22 # ffffffffc0207060 <commands+0x838>
ffffffffc020207e:	0c000593          	li	a1,192
ffffffffc0202082:	00005517          	auipc	a0,0x5
ffffffffc0202086:	35650513          	addi	a0,a0,854 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020208a:	998fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020208e:	00005697          	auipc	a3,0x5
ffffffffc0202092:	62a68693          	addi	a3,a3,1578 # ffffffffc02076b8 <commands+0xe90>
ffffffffc0202096:	00005617          	auipc	a2,0x5
ffffffffc020209a:	fca60613          	addi	a2,a2,-54 # ffffffffc0207060 <commands+0x838>
ffffffffc020209e:	11100593          	li	a1,273
ffffffffc02020a2:	00005517          	auipc	a0,0x5
ffffffffc02020a6:	33650513          	addi	a0,a0,822 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02020aa:	978fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02020ae:	00005697          	auipc	a3,0x5
ffffffffc02020b2:	5ea68693          	addi	a3,a3,1514 # ffffffffc0207698 <commands+0xe70>
ffffffffc02020b6:	00005617          	auipc	a2,0x5
ffffffffc02020ba:	faa60613          	addi	a2,a2,-86 # ffffffffc0207060 <commands+0x838>
ffffffffc02020be:	10f00593          	li	a1,271
ffffffffc02020c2:	00005517          	auipc	a0,0x5
ffffffffc02020c6:	31650513          	addi	a0,a0,790 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02020ca:	958fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02020ce:	00005697          	auipc	a3,0x5
ffffffffc02020d2:	5a268693          	addi	a3,a3,1442 # ffffffffc0207670 <commands+0xe48>
ffffffffc02020d6:	00005617          	auipc	a2,0x5
ffffffffc02020da:	f8a60613          	addi	a2,a2,-118 # ffffffffc0207060 <commands+0x838>
ffffffffc02020de:	10d00593          	li	a1,269
ffffffffc02020e2:	00005517          	auipc	a0,0x5
ffffffffc02020e6:	2f650513          	addi	a0,a0,758 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02020ea:	938fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02020ee:	00005697          	auipc	a3,0x5
ffffffffc02020f2:	55a68693          	addi	a3,a3,1370 # ffffffffc0207648 <commands+0xe20>
ffffffffc02020f6:	00005617          	auipc	a2,0x5
ffffffffc02020fa:	f6a60613          	addi	a2,a2,-150 # ffffffffc0207060 <commands+0x838>
ffffffffc02020fe:	10c00593          	li	a1,268
ffffffffc0202102:	00005517          	auipc	a0,0x5
ffffffffc0202106:	2d650513          	addi	a0,a0,726 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020210a:	918fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(p0 + 2 == p1);
ffffffffc020210e:	00005697          	auipc	a3,0x5
ffffffffc0202112:	52a68693          	addi	a3,a3,1322 # ffffffffc0207638 <commands+0xe10>
ffffffffc0202116:	00005617          	auipc	a2,0x5
ffffffffc020211a:	f4a60613          	addi	a2,a2,-182 # ffffffffc0207060 <commands+0x838>
ffffffffc020211e:	10700593          	li	a1,263
ffffffffc0202122:	00005517          	auipc	a0,0x5
ffffffffc0202126:	2b650513          	addi	a0,a0,694 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020212a:	8f8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020212e:	00005697          	auipc	a3,0x5
ffffffffc0202132:	40a68693          	addi	a3,a3,1034 # ffffffffc0207538 <commands+0xd10>
ffffffffc0202136:	00005617          	auipc	a2,0x5
ffffffffc020213a:	f2a60613          	addi	a2,a2,-214 # ffffffffc0207060 <commands+0x838>
ffffffffc020213e:	10600593          	li	a1,262
ffffffffc0202142:	00005517          	auipc	a0,0x5
ffffffffc0202146:	29650513          	addi	a0,a0,662 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020214a:	8d8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020214e:	00005697          	auipc	a3,0x5
ffffffffc0202152:	4ca68693          	addi	a3,a3,1226 # ffffffffc0207618 <commands+0xdf0>
ffffffffc0202156:	00005617          	auipc	a2,0x5
ffffffffc020215a:	f0a60613          	addi	a2,a2,-246 # ffffffffc0207060 <commands+0x838>
ffffffffc020215e:	10500593          	li	a1,261
ffffffffc0202162:	00005517          	auipc	a0,0x5
ffffffffc0202166:	27650513          	addi	a0,a0,630 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020216a:	8b8fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020216e:	00005697          	auipc	a3,0x5
ffffffffc0202172:	47a68693          	addi	a3,a3,1146 # ffffffffc02075e8 <commands+0xdc0>
ffffffffc0202176:	00005617          	auipc	a2,0x5
ffffffffc020217a:	eea60613          	addi	a2,a2,-278 # ffffffffc0207060 <commands+0x838>
ffffffffc020217e:	10400593          	li	a1,260
ffffffffc0202182:	00005517          	auipc	a0,0x5
ffffffffc0202186:	25650513          	addi	a0,a0,598 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020218a:	898fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020218e:	00005697          	auipc	a3,0x5
ffffffffc0202192:	44268693          	addi	a3,a3,1090 # ffffffffc02075d0 <commands+0xda8>
ffffffffc0202196:	00005617          	auipc	a2,0x5
ffffffffc020219a:	eca60613          	addi	a2,a2,-310 # ffffffffc0207060 <commands+0x838>
ffffffffc020219e:	10300593          	li	a1,259
ffffffffc02021a2:	00005517          	auipc	a0,0x5
ffffffffc02021a6:	23650513          	addi	a0,a0,566 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02021aa:	878fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02021ae:	00005697          	auipc	a3,0x5
ffffffffc02021b2:	38a68693          	addi	a3,a3,906 # ffffffffc0207538 <commands+0xd10>
ffffffffc02021b6:	00005617          	auipc	a2,0x5
ffffffffc02021ba:	eaa60613          	addi	a2,a2,-342 # ffffffffc0207060 <commands+0x838>
ffffffffc02021be:	0fd00593          	li	a1,253
ffffffffc02021c2:	00005517          	auipc	a0,0x5
ffffffffc02021c6:	21650513          	addi	a0,a0,534 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02021ca:	858fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(!PageProperty(p0));
ffffffffc02021ce:	00005697          	auipc	a3,0x5
ffffffffc02021d2:	3ea68693          	addi	a3,a3,1002 # ffffffffc02075b8 <commands+0xd90>
ffffffffc02021d6:	00005617          	auipc	a2,0x5
ffffffffc02021da:	e8a60613          	addi	a2,a2,-374 # ffffffffc0207060 <commands+0x838>
ffffffffc02021de:	0f800593          	li	a1,248
ffffffffc02021e2:	00005517          	auipc	a0,0x5
ffffffffc02021e6:	1f650513          	addi	a0,a0,502 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02021ea:	838fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02021ee:	00005697          	auipc	a3,0x5
ffffffffc02021f2:	4ea68693          	addi	a3,a3,1258 # ffffffffc02076d8 <commands+0xeb0>
ffffffffc02021f6:	00005617          	auipc	a2,0x5
ffffffffc02021fa:	e6a60613          	addi	a2,a2,-406 # ffffffffc0207060 <commands+0x838>
ffffffffc02021fe:	11600593          	li	a1,278
ffffffffc0202202:	00005517          	auipc	a0,0x5
ffffffffc0202206:	1d650513          	addi	a0,a0,470 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020220a:	818fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(total == 0);
ffffffffc020220e:	00005697          	auipc	a3,0x5
ffffffffc0202212:	4fa68693          	addi	a3,a3,1274 # ffffffffc0207708 <commands+0xee0>
ffffffffc0202216:	00005617          	auipc	a2,0x5
ffffffffc020221a:	e4a60613          	addi	a2,a2,-438 # ffffffffc0207060 <commands+0x838>
ffffffffc020221e:	12500593          	li	a1,293
ffffffffc0202222:	00005517          	auipc	a0,0x5
ffffffffc0202226:	1b650513          	addi	a0,a0,438 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020222a:	ff9fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(total == nr_free_pages());
ffffffffc020222e:	00005697          	auipc	a3,0x5
ffffffffc0202232:	1c268693          	addi	a3,a3,450 # ffffffffc02073f0 <commands+0xbc8>
ffffffffc0202236:	00005617          	auipc	a2,0x5
ffffffffc020223a:	e2a60613          	addi	a2,a2,-470 # ffffffffc0207060 <commands+0x838>
ffffffffc020223e:	0f200593          	li	a1,242
ffffffffc0202242:	00005517          	auipc	a0,0x5
ffffffffc0202246:	19650513          	addi	a0,a0,406 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020224a:	fd9fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020224e:	00005697          	auipc	a3,0x5
ffffffffc0202252:	1e268693          	addi	a3,a3,482 # ffffffffc0207430 <commands+0xc08>
ffffffffc0202256:	00005617          	auipc	a2,0x5
ffffffffc020225a:	e0a60613          	addi	a2,a2,-502 # ffffffffc0207060 <commands+0x838>
ffffffffc020225e:	0b900593          	li	a1,185
ffffffffc0202262:	00005517          	auipc	a0,0x5
ffffffffc0202266:	17650513          	addi	a0,a0,374 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020226a:	fb9fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020226e <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc020226e:	1141                	addi	sp,sp,-16
ffffffffc0202270:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202272:	14058463          	beqz	a1,ffffffffc02023ba <default_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0202276:	00659693          	slli	a3,a1,0x6
ffffffffc020227a:	96aa                	add	a3,a3,a0
ffffffffc020227c:	87aa                	mv	a5,a0
ffffffffc020227e:	02d50263          	beq	a0,a3,ffffffffc02022a2 <default_free_pages+0x34>
ffffffffc0202282:	6798                	ld	a4,8(a5)
ffffffffc0202284:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202286:	10071a63          	bnez	a4,ffffffffc020239a <default_free_pages+0x12c>
ffffffffc020228a:	6798                	ld	a4,8(a5)
ffffffffc020228c:	8b09                	andi	a4,a4,2
ffffffffc020228e:	10071663          	bnez	a4,ffffffffc020239a <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0202292:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0202296:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020229a:	04078793          	addi	a5,a5,64
ffffffffc020229e:	fed792e3          	bne	a5,a3,ffffffffc0202282 <default_free_pages+0x14>
    base->property = n;
ffffffffc02022a2:	2581                	sext.w	a1,a1
ffffffffc02022a4:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02022a6:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02022aa:	4789                	li	a5,2
ffffffffc02022ac:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02022b0:	000da697          	auipc	a3,0xda
ffffffffc02022b4:	c9068693          	addi	a3,a3,-880 # ffffffffc02dbf40 <free_area>
ffffffffc02022b8:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02022ba:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02022bc:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02022c0:	9db9                	addw	a1,a1,a4
ffffffffc02022c2:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02022c4:	0ad78463          	beq	a5,a3,ffffffffc020236c <default_free_pages+0xfe>
            struct Page* page = le2page(le, page_link);
ffffffffc02022c8:	fe878713          	addi	a4,a5,-24
ffffffffc02022cc:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02022d0:	4581                	li	a1,0
            if (base < page) {
ffffffffc02022d2:	00e56a63          	bltu	a0,a4,ffffffffc02022e6 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02022d6:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02022d8:	04d70c63          	beq	a4,a3,ffffffffc0202330 <default_free_pages+0xc2>
    for (; p != base + n; p ++) {
ffffffffc02022dc:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02022de:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02022e2:	fee57ae3          	bgeu	a0,a4,ffffffffc02022d6 <default_free_pages+0x68>
ffffffffc02022e6:	c199                	beqz	a1,ffffffffc02022ec <default_free_pages+0x7e>
ffffffffc02022e8:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02022ec:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02022ee:	e390                	sd	a2,0(a5)
ffffffffc02022f0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02022f2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02022f4:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc02022f6:	00d70d63          	beq	a4,a3,ffffffffc0202310 <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc02022fa:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_obj___user_faultread_out_size-0x9180>
        p = le2page(le, page_link);
ffffffffc02022fe:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0202302:	02059813          	slli	a6,a1,0x20
ffffffffc0202306:	01a85793          	srli	a5,a6,0x1a
ffffffffc020230a:	97b2                	add	a5,a5,a2
ffffffffc020230c:	02f50c63          	beq	a0,a5,ffffffffc0202344 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0202310:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0202312:	00d78c63          	beq	a5,a3,ffffffffc020232a <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0202316:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0202318:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc020231c:	02061593          	slli	a1,a2,0x20
ffffffffc0202320:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0202324:	972a                	add	a4,a4,a0
ffffffffc0202326:	04e68a63          	beq	a3,a4,ffffffffc020237a <default_free_pages+0x10c>
}
ffffffffc020232a:	60a2                	ld	ra,8(sp)
ffffffffc020232c:	0141                	addi	sp,sp,16
ffffffffc020232e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202330:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202332:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0202334:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0202336:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202338:	02d70763          	beq	a4,a3,ffffffffc0202366 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc020233c:	8832                	mv	a6,a2
ffffffffc020233e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202340:	87ba                	mv	a5,a4
ffffffffc0202342:	bf71                	j	ffffffffc02022de <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0202344:	491c                	lw	a5,16(a0)
ffffffffc0202346:	9dbd                	addw	a1,a1,a5
ffffffffc0202348:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020234c:	57f5                	li	a5,-3
ffffffffc020234e:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202352:	01853803          	ld	a6,24(a0)
ffffffffc0202356:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0202358:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc020235a:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc020235e:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0202360:	0105b023          	sd	a6,0(a1) # 1000 <_binary_obj___user_faultread_out_size-0x9178>
ffffffffc0202364:	b77d                	j	ffffffffc0202312 <default_free_pages+0xa4>
ffffffffc0202366:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202368:	873e                	mv	a4,a5
ffffffffc020236a:	bf41                	j	ffffffffc02022fa <default_free_pages+0x8c>
}
ffffffffc020236c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020236e:	e390                	sd	a2,0(a5)
ffffffffc0202370:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202372:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202374:	ed1c                	sd	a5,24(a0)
ffffffffc0202376:	0141                	addi	sp,sp,16
ffffffffc0202378:	8082                	ret
            base->property += p->property;
ffffffffc020237a:	ff87a703          	lw	a4,-8(a5)
ffffffffc020237e:	ff078693          	addi	a3,a5,-16
ffffffffc0202382:	9e39                	addw	a2,a2,a4
ffffffffc0202384:	c910                	sw	a2,16(a0)
ffffffffc0202386:	5775                	li	a4,-3
ffffffffc0202388:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020238c:	6398                	ld	a4,0(a5)
ffffffffc020238e:	679c                	ld	a5,8(a5)
}
ffffffffc0202390:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0202392:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202394:	e398                	sd	a4,0(a5)
ffffffffc0202396:	0141                	addi	sp,sp,16
ffffffffc0202398:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020239a:	00005697          	auipc	a3,0x5
ffffffffc020239e:	38668693          	addi	a3,a3,902 # ffffffffc0207720 <commands+0xef8>
ffffffffc02023a2:	00005617          	auipc	a2,0x5
ffffffffc02023a6:	cbe60613          	addi	a2,a2,-834 # ffffffffc0207060 <commands+0x838>
ffffffffc02023aa:	08200593          	li	a1,130
ffffffffc02023ae:	00005517          	auipc	a0,0x5
ffffffffc02023b2:	02a50513          	addi	a0,a0,42 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02023b6:	e6dfd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(n > 0);
ffffffffc02023ba:	00005697          	auipc	a3,0x5
ffffffffc02023be:	35e68693          	addi	a3,a3,862 # ffffffffc0207718 <commands+0xef0>
ffffffffc02023c2:	00005617          	auipc	a2,0x5
ffffffffc02023c6:	c9e60613          	addi	a2,a2,-866 # ffffffffc0207060 <commands+0x838>
ffffffffc02023ca:	07f00593          	li	a1,127
ffffffffc02023ce:	00005517          	auipc	a0,0x5
ffffffffc02023d2:	00a50513          	addi	a0,a0,10 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc02023d6:	e4dfd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02023da <default_alloc_pages>:
    assert(n > 0);
ffffffffc02023da:	c941                	beqz	a0,ffffffffc020246a <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc02023dc:	000da597          	auipc	a1,0xda
ffffffffc02023e0:	b6458593          	addi	a1,a1,-1180 # ffffffffc02dbf40 <free_area>
ffffffffc02023e4:	0105a803          	lw	a6,16(a1)
ffffffffc02023e8:	872a                	mv	a4,a0
ffffffffc02023ea:	02081793          	slli	a5,a6,0x20
ffffffffc02023ee:	9381                	srli	a5,a5,0x20
ffffffffc02023f0:	00a7ee63          	bltu	a5,a0,ffffffffc020240c <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02023f4:	87ae                	mv	a5,a1
ffffffffc02023f6:	a801                	j	ffffffffc0202406 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc02023f8:	ff87a683          	lw	a3,-8(a5)
ffffffffc02023fc:	02069613          	slli	a2,a3,0x20
ffffffffc0202400:	9201                	srli	a2,a2,0x20
ffffffffc0202402:	00e67763          	bgeu	a2,a4,ffffffffc0202410 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0202406:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202408:	feb798e3          	bne	a5,a1,ffffffffc02023f8 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020240c:	4501                	li	a0,0
}
ffffffffc020240e:	8082                	ret
    return listelm->prev;
ffffffffc0202410:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202414:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0202418:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc020241c:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0202420:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0202424:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0202428:	02c77863          	bgeu	a4,a2,ffffffffc0202458 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc020242c:	071a                	slli	a4,a4,0x6
ffffffffc020242e:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0202430:	41c686bb          	subw	a3,a3,t3
ffffffffc0202434:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202436:	00870613          	addi	a2,a4,8
ffffffffc020243a:	4689                	li	a3,2
ffffffffc020243c:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202440:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0202444:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0202448:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc020244c:	e290                	sd	a2,0(a3)
ffffffffc020244e:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0202452:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0202454:	01173c23          	sd	a7,24(a4)
ffffffffc0202458:	41c8083b          	subw	a6,a6,t3
ffffffffc020245c:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202460:	5775                	li	a4,-3
ffffffffc0202462:	17c1                	addi	a5,a5,-16
ffffffffc0202464:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0202468:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020246a:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020246c:	00005697          	auipc	a3,0x5
ffffffffc0202470:	2ac68693          	addi	a3,a3,684 # ffffffffc0207718 <commands+0xef0>
ffffffffc0202474:	00005617          	auipc	a2,0x5
ffffffffc0202478:	bec60613          	addi	a2,a2,-1044 # ffffffffc0207060 <commands+0x838>
ffffffffc020247c:	06100593          	li	a1,97
ffffffffc0202480:	00005517          	auipc	a0,0x5
ffffffffc0202484:	f5850513          	addi	a0,a0,-168 # ffffffffc02073d8 <commands+0xbb0>
default_alloc_pages(size_t n) {
ffffffffc0202488:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020248a:	d99fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020248e <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc020248e:	1141                	addi	sp,sp,-16
ffffffffc0202490:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202492:	c5f1                	beqz	a1,ffffffffc020255e <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc0202494:	00659693          	slli	a3,a1,0x6
ffffffffc0202498:	96aa                	add	a3,a3,a0
ffffffffc020249a:	87aa                	mv	a5,a0
ffffffffc020249c:	00d50f63          	beq	a0,a3,ffffffffc02024ba <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02024a0:	6798                	ld	a4,8(a5)
ffffffffc02024a2:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02024a4:	cf49                	beqz	a4,ffffffffc020253e <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02024a6:	0007a823          	sw	zero,16(a5)
ffffffffc02024aa:	0007b423          	sd	zero,8(a5)
ffffffffc02024ae:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02024b2:	04078793          	addi	a5,a5,64
ffffffffc02024b6:	fed795e3          	bne	a5,a3,ffffffffc02024a0 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02024ba:	2581                	sext.w	a1,a1
ffffffffc02024bc:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02024be:	4789                	li	a5,2
ffffffffc02024c0:	00850713          	addi	a4,a0,8
ffffffffc02024c4:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02024c8:	000da697          	auipc	a3,0xda
ffffffffc02024cc:	a7868693          	addi	a3,a3,-1416 # ffffffffc02dbf40 <free_area>
ffffffffc02024d0:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02024d2:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02024d4:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02024d8:	9db9                	addw	a1,a1,a4
ffffffffc02024da:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02024dc:	04d78a63          	beq	a5,a3,ffffffffc0202530 <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc02024e0:	fe878713          	addi	a4,a5,-24
ffffffffc02024e4:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02024e8:	4581                	li	a1,0
            if (base < page) {
ffffffffc02024ea:	00e56a63          	bltu	a0,a4,ffffffffc02024fe <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02024ee:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02024f0:	02d70263          	beq	a4,a3,ffffffffc0202514 <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc02024f4:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02024f6:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02024fa:	fee57ae3          	bgeu	a0,a4,ffffffffc02024ee <default_init_memmap+0x60>
ffffffffc02024fe:	c199                	beqz	a1,ffffffffc0202504 <default_init_memmap+0x76>
ffffffffc0202500:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202504:	6398                	ld	a4,0(a5)
}
ffffffffc0202506:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202508:	e390                	sd	a2,0(a5)
ffffffffc020250a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020250c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020250e:	ed18                	sd	a4,24(a0)
ffffffffc0202510:	0141                	addi	sp,sp,16
ffffffffc0202512:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202514:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202516:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0202518:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020251a:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020251c:	00d70663          	beq	a4,a3,ffffffffc0202528 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0202520:	8832                	mv	a6,a2
ffffffffc0202522:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202524:	87ba                	mv	a5,a4
ffffffffc0202526:	bfc1                	j	ffffffffc02024f6 <default_init_memmap+0x68>
}
ffffffffc0202528:	60a2                	ld	ra,8(sp)
ffffffffc020252a:	e290                	sd	a2,0(a3)
ffffffffc020252c:	0141                	addi	sp,sp,16
ffffffffc020252e:	8082                	ret
ffffffffc0202530:	60a2                	ld	ra,8(sp)
ffffffffc0202532:	e390                	sd	a2,0(a5)
ffffffffc0202534:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202536:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202538:	ed1c                	sd	a5,24(a0)
ffffffffc020253a:	0141                	addi	sp,sp,16
ffffffffc020253c:	8082                	ret
        assert(PageReserved(p));
ffffffffc020253e:	00005697          	auipc	a3,0x5
ffffffffc0202542:	20a68693          	addi	a3,a3,522 # ffffffffc0207748 <commands+0xf20>
ffffffffc0202546:	00005617          	auipc	a2,0x5
ffffffffc020254a:	b1a60613          	addi	a2,a2,-1254 # ffffffffc0207060 <commands+0x838>
ffffffffc020254e:	04800593          	li	a1,72
ffffffffc0202552:	00005517          	auipc	a0,0x5
ffffffffc0202556:	e8650513          	addi	a0,a0,-378 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020255a:	cc9fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(n > 0);
ffffffffc020255e:	00005697          	auipc	a3,0x5
ffffffffc0202562:	1ba68693          	addi	a3,a3,442 # ffffffffc0207718 <commands+0xef0>
ffffffffc0202566:	00005617          	auipc	a2,0x5
ffffffffc020256a:	afa60613          	addi	a2,a2,-1286 # ffffffffc0207060 <commands+0x838>
ffffffffc020256e:	04500593          	li	a1,69
ffffffffc0202572:	00005517          	auipc	a0,0x5
ffffffffc0202576:	e6650513          	addi	a0,a0,-410 # ffffffffc02073d8 <commands+0xbb0>
ffffffffc020257a:	ca9fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020257e <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc020257e:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202580:	00005617          	auipc	a2,0x5
ffffffffc0202584:	e2860613          	addi	a2,a2,-472 # ffffffffc02073a8 <commands+0xb80>
ffffffffc0202588:	06900593          	li	a1,105
ffffffffc020258c:	00005517          	auipc	a0,0x5
ffffffffc0202590:	d7450513          	addi	a0,a0,-652 # ffffffffc0207300 <commands+0xad8>
pa2page(uintptr_t pa)
ffffffffc0202594:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202596:	c8dfd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020259a <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc020259a:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc020259c:	00005617          	auipc	a2,0x5
ffffffffc02025a0:	20c60613          	addi	a2,a2,524 # ffffffffc02077a8 <default_pmm_manager+0x38>
ffffffffc02025a4:	07f00593          	li	a1,127
ffffffffc02025a8:	00005517          	auipc	a0,0x5
ffffffffc02025ac:	d5850513          	addi	a0,a0,-680 # ffffffffc0207300 <commands+0xad8>
pte2page(pte_t pte)
ffffffffc02025b0:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc02025b2:	c71fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02025b6 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02025b6:	100027f3          	csrr	a5,sstatus
ffffffffc02025ba:	8b89                	andi	a5,a5,2
ffffffffc02025bc:	e799                	bnez	a5,ffffffffc02025ca <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02025be:	000de797          	auipc	a5,0xde
ffffffffc02025c2:	b727b783          	ld	a5,-1166(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc02025c6:	6f9c                	ld	a5,24(a5)
ffffffffc02025c8:	8782                	jr	a5
{
ffffffffc02025ca:	1141                	addi	sp,sp,-16
ffffffffc02025cc:	e406                	sd	ra,8(sp)
ffffffffc02025ce:	e022                	sd	s0,0(sp)
ffffffffc02025d0:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02025d2:	be2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02025d6:	000de797          	auipc	a5,0xde
ffffffffc02025da:	b5a7b783          	ld	a5,-1190(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc02025de:	6f9c                	ld	a5,24(a5)
ffffffffc02025e0:	8522                	mv	a0,s0
ffffffffc02025e2:	9782                	jalr	a5
ffffffffc02025e4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02025e6:	bc8fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02025ea:	60a2                	ld	ra,8(sp)
ffffffffc02025ec:	8522                	mv	a0,s0
ffffffffc02025ee:	6402                	ld	s0,0(sp)
ffffffffc02025f0:	0141                	addi	sp,sp,16
ffffffffc02025f2:	8082                	ret

ffffffffc02025f4 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02025f4:	100027f3          	csrr	a5,sstatus
ffffffffc02025f8:	8b89                	andi	a5,a5,2
ffffffffc02025fa:	e799                	bnez	a5,ffffffffc0202608 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02025fc:	000de797          	auipc	a5,0xde
ffffffffc0202600:	b347b783          	ld	a5,-1228(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202604:	739c                	ld	a5,32(a5)
ffffffffc0202606:	8782                	jr	a5
{
ffffffffc0202608:	1101                	addi	sp,sp,-32
ffffffffc020260a:	ec06                	sd	ra,24(sp)
ffffffffc020260c:	e822                	sd	s0,16(sp)
ffffffffc020260e:	e426                	sd	s1,8(sp)
ffffffffc0202610:	842a                	mv	s0,a0
ffffffffc0202612:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202614:	ba0fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202618:	000de797          	auipc	a5,0xde
ffffffffc020261c:	b187b783          	ld	a5,-1256(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202620:	739c                	ld	a5,32(a5)
ffffffffc0202622:	85a6                	mv	a1,s1
ffffffffc0202624:	8522                	mv	a0,s0
ffffffffc0202626:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0202628:	6442                	ld	s0,16(sp)
ffffffffc020262a:	60e2                	ld	ra,24(sp)
ffffffffc020262c:	64a2                	ld	s1,8(sp)
ffffffffc020262e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202630:	b7efe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0202634 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202634:	100027f3          	csrr	a5,sstatus
ffffffffc0202638:	8b89                	andi	a5,a5,2
ffffffffc020263a:	e799                	bnez	a5,ffffffffc0202648 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc020263c:	000de797          	auipc	a5,0xde
ffffffffc0202640:	af47b783          	ld	a5,-1292(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202644:	779c                	ld	a5,40(a5)
ffffffffc0202646:	8782                	jr	a5
{
ffffffffc0202648:	1141                	addi	sp,sp,-16
ffffffffc020264a:	e406                	sd	ra,8(sp)
ffffffffc020264c:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020264e:	b66fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202652:	000de797          	auipc	a5,0xde
ffffffffc0202656:	ade7b783          	ld	a5,-1314(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc020265a:	779c                	ld	a5,40(a5)
ffffffffc020265c:	9782                	jalr	a5
ffffffffc020265e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202660:	b4efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202664:	60a2                	ld	ra,8(sp)
ffffffffc0202666:	8522                	mv	a0,s0
ffffffffc0202668:	6402                	ld	s0,0(sp)
ffffffffc020266a:	0141                	addi	sp,sp,16
ffffffffc020266c:	8082                	ret

ffffffffc020266e <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020266e:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202672:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0202676:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202678:	078e                	slli	a5,a5,0x3
{
ffffffffc020267a:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020267c:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0202680:	6094                	ld	a3,0(s1)
{
ffffffffc0202682:	f04a                	sd	s2,32(sp)
ffffffffc0202684:	ec4e                	sd	s3,24(sp)
ffffffffc0202686:	e852                	sd	s4,16(sp)
ffffffffc0202688:	fc06                	sd	ra,56(sp)
ffffffffc020268a:	f822                	sd	s0,48(sp)
ffffffffc020268c:	e456                	sd	s5,8(sp)
ffffffffc020268e:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0202690:	0016f793          	andi	a5,a3,1
{
ffffffffc0202694:	892e                	mv	s2,a1
ffffffffc0202696:	8a32                	mv	s4,a2
ffffffffc0202698:	000de997          	auipc	s3,0xde
ffffffffc020269c:	a8898993          	addi	s3,s3,-1400 # ffffffffc02e0120 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc02026a0:	efbd                	bnez	a5,ffffffffc020271e <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02026a2:	14060c63          	beqz	a2,ffffffffc02027fa <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02026a6:	100027f3          	csrr	a5,sstatus
ffffffffc02026aa:	8b89                	andi	a5,a5,2
ffffffffc02026ac:	14079963          	bnez	a5,ffffffffc02027fe <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc02026b0:	000de797          	auipc	a5,0xde
ffffffffc02026b4:	a807b783          	ld	a5,-1408(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc02026b8:	6f9c                	ld	a5,24(a5)
ffffffffc02026ba:	4505                	li	a0,1
ffffffffc02026bc:	9782                	jalr	a5
ffffffffc02026be:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02026c0:	12040d63          	beqz	s0,ffffffffc02027fa <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02026c4:	000deb17          	auipc	s6,0xde
ffffffffc02026c8:	a64b0b13          	addi	s6,s6,-1436 # ffffffffc02e0128 <pages>
ffffffffc02026cc:	000b3503          	ld	a0,0(s6)
ffffffffc02026d0:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02026d4:	000de997          	auipc	s3,0xde
ffffffffc02026d8:	a4c98993          	addi	s3,s3,-1460 # ffffffffc02e0120 <npage>
ffffffffc02026dc:	40a40533          	sub	a0,s0,a0
ffffffffc02026e0:	8519                	srai	a0,a0,0x6
ffffffffc02026e2:	9556                	add	a0,a0,s5
ffffffffc02026e4:	0009b703          	ld	a4,0(s3)
ffffffffc02026e8:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02026ec:	4685                	li	a3,1
ffffffffc02026ee:	c014                	sw	a3,0(s0)
ffffffffc02026f0:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02026f2:	0532                	slli	a0,a0,0xc
ffffffffc02026f4:	16e7f763          	bgeu	a5,a4,ffffffffc0202862 <get_pte+0x1f4>
ffffffffc02026f8:	000de797          	auipc	a5,0xde
ffffffffc02026fc:	a407b783          	ld	a5,-1472(a5) # ffffffffc02e0138 <va_pa_offset>
ffffffffc0202700:	6605                	lui	a2,0x1
ffffffffc0202702:	4581                	li	a1,0
ffffffffc0202704:	953e                	add	a0,a0,a5
ffffffffc0202706:	249030ef          	jal	ra,ffffffffc020614e <memset>
    return page - pages + nbase;
ffffffffc020270a:	000b3683          	ld	a3,0(s6)
ffffffffc020270e:	40d406b3          	sub	a3,s0,a3
ffffffffc0202712:	8699                	srai	a3,a3,0x6
ffffffffc0202714:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202716:	06aa                	slli	a3,a3,0xa
ffffffffc0202718:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020271c:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020271e:	77fd                	lui	a5,0xfffff
ffffffffc0202720:	068a                	slli	a3,a3,0x2
ffffffffc0202722:	0009b703          	ld	a4,0(s3)
ffffffffc0202726:	8efd                	and	a3,a3,a5
ffffffffc0202728:	00c6d793          	srli	a5,a3,0xc
ffffffffc020272c:	10e7ff63          	bgeu	a5,a4,ffffffffc020284a <get_pte+0x1dc>
ffffffffc0202730:	000dea97          	auipc	s5,0xde
ffffffffc0202734:	a08a8a93          	addi	s5,s5,-1528 # ffffffffc02e0138 <va_pa_offset>
ffffffffc0202738:	000ab403          	ld	s0,0(s5)
ffffffffc020273c:	01595793          	srli	a5,s2,0x15
ffffffffc0202740:	1ff7f793          	andi	a5,a5,511
ffffffffc0202744:	96a2                	add	a3,a3,s0
ffffffffc0202746:	00379413          	slli	s0,a5,0x3
ffffffffc020274a:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020274c:	6014                	ld	a3,0(s0)
ffffffffc020274e:	0016f793          	andi	a5,a3,1
ffffffffc0202752:	ebad                	bnez	a5,ffffffffc02027c4 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202754:	0a0a0363          	beqz	s4,ffffffffc02027fa <get_pte+0x18c>
ffffffffc0202758:	100027f3          	csrr	a5,sstatus
ffffffffc020275c:	8b89                	andi	a5,a5,2
ffffffffc020275e:	efcd                	bnez	a5,ffffffffc0202818 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202760:	000de797          	auipc	a5,0xde
ffffffffc0202764:	9d07b783          	ld	a5,-1584(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202768:	6f9c                	ld	a5,24(a5)
ffffffffc020276a:	4505                	li	a0,1
ffffffffc020276c:	9782                	jalr	a5
ffffffffc020276e:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202770:	c4c9                	beqz	s1,ffffffffc02027fa <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202772:	000deb17          	auipc	s6,0xde
ffffffffc0202776:	9b6b0b13          	addi	s6,s6,-1610 # ffffffffc02e0128 <pages>
ffffffffc020277a:	000b3503          	ld	a0,0(s6)
ffffffffc020277e:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202782:	0009b703          	ld	a4,0(s3)
ffffffffc0202786:	40a48533          	sub	a0,s1,a0
ffffffffc020278a:	8519                	srai	a0,a0,0x6
ffffffffc020278c:	9552                	add	a0,a0,s4
ffffffffc020278e:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202792:	4685                	li	a3,1
ffffffffc0202794:	c094                	sw	a3,0(s1)
ffffffffc0202796:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202798:	0532                	slli	a0,a0,0xc
ffffffffc020279a:	0ee7f163          	bgeu	a5,a4,ffffffffc020287c <get_pte+0x20e>
ffffffffc020279e:	000ab783          	ld	a5,0(s5)
ffffffffc02027a2:	6605                	lui	a2,0x1
ffffffffc02027a4:	4581                	li	a1,0
ffffffffc02027a6:	953e                	add	a0,a0,a5
ffffffffc02027a8:	1a7030ef          	jal	ra,ffffffffc020614e <memset>
    return page - pages + nbase;
ffffffffc02027ac:	000b3683          	ld	a3,0(s6)
ffffffffc02027b0:	40d486b3          	sub	a3,s1,a3
ffffffffc02027b4:	8699                	srai	a3,a3,0x6
ffffffffc02027b6:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02027b8:	06aa                	slli	a3,a3,0xa
ffffffffc02027ba:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02027be:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02027c0:	0009b703          	ld	a4,0(s3)
ffffffffc02027c4:	068a                	slli	a3,a3,0x2
ffffffffc02027c6:	757d                	lui	a0,0xfffff
ffffffffc02027c8:	8ee9                	and	a3,a3,a0
ffffffffc02027ca:	00c6d793          	srli	a5,a3,0xc
ffffffffc02027ce:	06e7f263          	bgeu	a5,a4,ffffffffc0202832 <get_pte+0x1c4>
ffffffffc02027d2:	000ab503          	ld	a0,0(s5)
ffffffffc02027d6:	00c95913          	srli	s2,s2,0xc
ffffffffc02027da:	1ff97913          	andi	s2,s2,511
ffffffffc02027de:	96aa                	add	a3,a3,a0
ffffffffc02027e0:	00391513          	slli	a0,s2,0x3
ffffffffc02027e4:	9536                	add	a0,a0,a3
}
ffffffffc02027e6:	70e2                	ld	ra,56(sp)
ffffffffc02027e8:	7442                	ld	s0,48(sp)
ffffffffc02027ea:	74a2                	ld	s1,40(sp)
ffffffffc02027ec:	7902                	ld	s2,32(sp)
ffffffffc02027ee:	69e2                	ld	s3,24(sp)
ffffffffc02027f0:	6a42                	ld	s4,16(sp)
ffffffffc02027f2:	6aa2                	ld	s5,8(sp)
ffffffffc02027f4:	6b02                	ld	s6,0(sp)
ffffffffc02027f6:	6121                	addi	sp,sp,64
ffffffffc02027f8:	8082                	ret
            return NULL;
ffffffffc02027fa:	4501                	li	a0,0
ffffffffc02027fc:	b7ed                	j	ffffffffc02027e6 <get_pte+0x178>
        intr_disable();
ffffffffc02027fe:	9b6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202802:	000de797          	auipc	a5,0xde
ffffffffc0202806:	92e7b783          	ld	a5,-1746(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc020280a:	6f9c                	ld	a5,24(a5)
ffffffffc020280c:	4505                	li	a0,1
ffffffffc020280e:	9782                	jalr	a5
ffffffffc0202810:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202812:	99cfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202816:	b56d                	j	ffffffffc02026c0 <get_pte+0x52>
        intr_disable();
ffffffffc0202818:	99cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020281c:	000de797          	auipc	a5,0xde
ffffffffc0202820:	9147b783          	ld	a5,-1772(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202824:	6f9c                	ld	a5,24(a5)
ffffffffc0202826:	4505                	li	a0,1
ffffffffc0202828:	9782                	jalr	a5
ffffffffc020282a:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020282c:	982fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202830:	b781                	j	ffffffffc0202770 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202832:	00005617          	auipc	a2,0x5
ffffffffc0202836:	aa660613          	addi	a2,a2,-1370 # ffffffffc02072d8 <commands+0xab0>
ffffffffc020283a:	0f900593          	li	a1,249
ffffffffc020283e:	00005517          	auipc	a0,0x5
ffffffffc0202842:	f9250513          	addi	a0,a0,-110 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202846:	9ddfd0ef          	jal	ra,ffffffffc0200222 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020284a:	00005617          	auipc	a2,0x5
ffffffffc020284e:	a8e60613          	addi	a2,a2,-1394 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0202852:	0ec00593          	li	a1,236
ffffffffc0202856:	00005517          	auipc	a0,0x5
ffffffffc020285a:	f7a50513          	addi	a0,a0,-134 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc020285e:	9c5fd0ef          	jal	ra,ffffffffc0200222 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202862:	86aa                	mv	a3,a0
ffffffffc0202864:	00005617          	auipc	a2,0x5
ffffffffc0202868:	a7460613          	addi	a2,a2,-1420 # ffffffffc02072d8 <commands+0xab0>
ffffffffc020286c:	0e800593          	li	a1,232
ffffffffc0202870:	00005517          	auipc	a0,0x5
ffffffffc0202874:	f6050513          	addi	a0,a0,-160 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202878:	9abfd0ef          	jal	ra,ffffffffc0200222 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020287c:	86aa                	mv	a3,a0
ffffffffc020287e:	00005617          	auipc	a2,0x5
ffffffffc0202882:	a5a60613          	addi	a2,a2,-1446 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0202886:	0f600593          	li	a1,246
ffffffffc020288a:	00005517          	auipc	a0,0x5
ffffffffc020288e:	f4650513          	addi	a0,a0,-186 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202892:	991fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0202896 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202896:	1141                	addi	sp,sp,-16
ffffffffc0202898:	e022                	sd	s0,0(sp)
ffffffffc020289a:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020289c:	4601                	li	a2,0
{
ffffffffc020289e:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02028a0:	dcfff0ef          	jal	ra,ffffffffc020266e <get_pte>
    if (ptep_store != NULL)
ffffffffc02028a4:	c011                	beqz	s0,ffffffffc02028a8 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02028a6:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02028a8:	c511                	beqz	a0,ffffffffc02028b4 <get_page+0x1e>
ffffffffc02028aa:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02028ac:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02028ae:	0017f713          	andi	a4,a5,1
ffffffffc02028b2:	e709                	bnez	a4,ffffffffc02028bc <get_page+0x26>
}
ffffffffc02028b4:	60a2                	ld	ra,8(sp)
ffffffffc02028b6:	6402                	ld	s0,0(sp)
ffffffffc02028b8:	0141                	addi	sp,sp,16
ffffffffc02028ba:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02028bc:	078a                	slli	a5,a5,0x2
ffffffffc02028be:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02028c0:	000de717          	auipc	a4,0xde
ffffffffc02028c4:	86073703          	ld	a4,-1952(a4) # ffffffffc02e0120 <npage>
ffffffffc02028c8:	00e7ff63          	bgeu	a5,a4,ffffffffc02028e6 <get_page+0x50>
ffffffffc02028cc:	60a2                	ld	ra,8(sp)
ffffffffc02028ce:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02028d0:	fff80537          	lui	a0,0xfff80
ffffffffc02028d4:	97aa                	add	a5,a5,a0
ffffffffc02028d6:	079a                	slli	a5,a5,0x6
ffffffffc02028d8:	000de517          	auipc	a0,0xde
ffffffffc02028dc:	85053503          	ld	a0,-1968(a0) # ffffffffc02e0128 <pages>
ffffffffc02028e0:	953e                	add	a0,a0,a5
ffffffffc02028e2:	0141                	addi	sp,sp,16
ffffffffc02028e4:	8082                	ret
ffffffffc02028e6:	c99ff0ef          	jal	ra,ffffffffc020257e <pa2page.part.0>

ffffffffc02028ea <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02028ea:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02028ec:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02028f0:	f486                	sd	ra,104(sp)
ffffffffc02028f2:	f0a2                	sd	s0,96(sp)
ffffffffc02028f4:	eca6                	sd	s1,88(sp)
ffffffffc02028f6:	e8ca                	sd	s2,80(sp)
ffffffffc02028f8:	e4ce                	sd	s3,72(sp)
ffffffffc02028fa:	e0d2                	sd	s4,64(sp)
ffffffffc02028fc:	fc56                	sd	s5,56(sp)
ffffffffc02028fe:	f85a                	sd	s6,48(sp)
ffffffffc0202900:	f45e                	sd	s7,40(sp)
ffffffffc0202902:	f062                	sd	s8,32(sp)
ffffffffc0202904:	ec66                	sd	s9,24(sp)
ffffffffc0202906:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202908:	17d2                	slli	a5,a5,0x34
ffffffffc020290a:	e3ed                	bnez	a5,ffffffffc02029ec <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020290c:	002007b7          	lui	a5,0x200
ffffffffc0202910:	842e                	mv	s0,a1
ffffffffc0202912:	0ef5ed63          	bltu	a1,a5,ffffffffc0202a0c <unmap_range+0x122>
ffffffffc0202916:	8932                	mv	s2,a2
ffffffffc0202918:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202a0c <unmap_range+0x122>
ffffffffc020291c:	4785                	li	a5,1
ffffffffc020291e:	07fe                	slli	a5,a5,0x1f
ffffffffc0202920:	0ec7e663          	bltu	a5,a2,ffffffffc0202a0c <unmap_range+0x122>
ffffffffc0202924:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202926:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0202928:	000ddc97          	auipc	s9,0xdd
ffffffffc020292c:	7f8c8c93          	addi	s9,s9,2040 # ffffffffc02e0120 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202930:	000ddc17          	auipc	s8,0xdd
ffffffffc0202934:	7f8c0c13          	addi	s8,s8,2040 # ffffffffc02e0128 <pages>
ffffffffc0202938:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020293c:	000ddd17          	auipc	s10,0xdd
ffffffffc0202940:	7f4d0d13          	addi	s10,s10,2036 # ffffffffc02e0130 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202944:	00200b37          	lui	s6,0x200
ffffffffc0202948:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020294c:	4601                	li	a2,0
ffffffffc020294e:	85a2                	mv	a1,s0
ffffffffc0202950:	854e                	mv	a0,s3
ffffffffc0202952:	d1dff0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc0202956:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0202958:	cd29                	beqz	a0,ffffffffc02029b2 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020295a:	611c                	ld	a5,0(a0)
ffffffffc020295c:	e395                	bnez	a5,ffffffffc0202980 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc020295e:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202960:	ff2466e3          	bltu	s0,s2,ffffffffc020294c <unmap_range+0x62>
}
ffffffffc0202964:	70a6                	ld	ra,104(sp)
ffffffffc0202966:	7406                	ld	s0,96(sp)
ffffffffc0202968:	64e6                	ld	s1,88(sp)
ffffffffc020296a:	6946                	ld	s2,80(sp)
ffffffffc020296c:	69a6                	ld	s3,72(sp)
ffffffffc020296e:	6a06                	ld	s4,64(sp)
ffffffffc0202970:	7ae2                	ld	s5,56(sp)
ffffffffc0202972:	7b42                	ld	s6,48(sp)
ffffffffc0202974:	7ba2                	ld	s7,40(sp)
ffffffffc0202976:	7c02                	ld	s8,32(sp)
ffffffffc0202978:	6ce2                	ld	s9,24(sp)
ffffffffc020297a:	6d42                	ld	s10,16(sp)
ffffffffc020297c:	6165                	addi	sp,sp,112
ffffffffc020297e:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202980:	0017f713          	andi	a4,a5,1
ffffffffc0202984:	df69                	beqz	a4,ffffffffc020295e <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202986:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020298a:	078a                	slli	a5,a5,0x2
ffffffffc020298c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020298e:	08e7ff63          	bgeu	a5,a4,ffffffffc0202a2c <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202992:	000c3503          	ld	a0,0(s8)
ffffffffc0202996:	97de                	add	a5,a5,s7
ffffffffc0202998:	079a                	slli	a5,a5,0x6
ffffffffc020299a:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020299c:	411c                	lw	a5,0(a0)
ffffffffc020299e:	fff7871b          	addiw	a4,a5,-1
ffffffffc02029a2:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02029a4:	cf11                	beqz	a4,ffffffffc02029c0 <unmap_range+0xd6>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc02029a6:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02029aa:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02029ae:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02029b0:	bf45                	j	ffffffffc0202960 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02029b2:	945a                	add	s0,s0,s6
ffffffffc02029b4:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02029b8:	d455                	beqz	s0,ffffffffc0202964 <unmap_range+0x7a>
ffffffffc02029ba:	f92469e3          	bltu	s0,s2,ffffffffc020294c <unmap_range+0x62>
ffffffffc02029be:	b75d                	j	ffffffffc0202964 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02029c0:	100027f3          	csrr	a5,sstatus
ffffffffc02029c4:	8b89                	andi	a5,a5,2
ffffffffc02029c6:	e799                	bnez	a5,ffffffffc02029d4 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02029c8:	000d3783          	ld	a5,0(s10)
ffffffffc02029cc:	4585                	li	a1,1
ffffffffc02029ce:	739c                	ld	a5,32(a5)
ffffffffc02029d0:	9782                	jalr	a5
    if (flag) {
ffffffffc02029d2:	bfd1                	j	ffffffffc02029a6 <unmap_range+0xbc>
ffffffffc02029d4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02029d6:	fdffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02029da:	000d3783          	ld	a5,0(s10)
ffffffffc02029de:	6522                	ld	a0,8(sp)
ffffffffc02029e0:	4585                	li	a1,1
ffffffffc02029e2:	739c                	ld	a5,32(a5)
ffffffffc02029e4:	9782                	jalr	a5
        intr_enable();
ffffffffc02029e6:	fc9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02029ea:	bf75                	j	ffffffffc02029a6 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02029ec:	00005697          	auipc	a3,0x5
ffffffffc02029f0:	df468693          	addi	a3,a3,-524 # ffffffffc02077e0 <default_pmm_manager+0x70>
ffffffffc02029f4:	00004617          	auipc	a2,0x4
ffffffffc02029f8:	66c60613          	addi	a2,a2,1644 # ffffffffc0207060 <commands+0x838>
ffffffffc02029fc:	12100593          	li	a1,289
ffffffffc0202a00:	00005517          	auipc	a0,0x5
ffffffffc0202a04:	dd050513          	addi	a0,a0,-560 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202a08:	81bfd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202a0c:	00005697          	auipc	a3,0x5
ffffffffc0202a10:	e0468693          	addi	a3,a3,-508 # ffffffffc0207810 <default_pmm_manager+0xa0>
ffffffffc0202a14:	00004617          	auipc	a2,0x4
ffffffffc0202a18:	64c60613          	addi	a2,a2,1612 # ffffffffc0207060 <commands+0x838>
ffffffffc0202a1c:	12200593          	li	a1,290
ffffffffc0202a20:	00005517          	auipc	a0,0x5
ffffffffc0202a24:	db050513          	addi	a0,a0,-592 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202a28:	ffafd0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc0202a2c:	b53ff0ef          	jal	ra,ffffffffc020257e <pa2page.part.0>

ffffffffc0202a30 <exit_range>:
{
ffffffffc0202a30:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202a32:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202a36:	fc86                	sd	ra,120(sp)
ffffffffc0202a38:	f8a2                	sd	s0,112(sp)
ffffffffc0202a3a:	f4a6                	sd	s1,104(sp)
ffffffffc0202a3c:	f0ca                	sd	s2,96(sp)
ffffffffc0202a3e:	ecce                	sd	s3,88(sp)
ffffffffc0202a40:	e8d2                	sd	s4,80(sp)
ffffffffc0202a42:	e4d6                	sd	s5,72(sp)
ffffffffc0202a44:	e0da                	sd	s6,64(sp)
ffffffffc0202a46:	fc5e                	sd	s7,56(sp)
ffffffffc0202a48:	f862                	sd	s8,48(sp)
ffffffffc0202a4a:	f466                	sd	s9,40(sp)
ffffffffc0202a4c:	f06a                	sd	s10,32(sp)
ffffffffc0202a4e:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202a50:	17d2                	slli	a5,a5,0x34
ffffffffc0202a52:	20079a63          	bnez	a5,ffffffffc0202c66 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202a56:	002007b7          	lui	a5,0x200
ffffffffc0202a5a:	24f5e463          	bltu	a1,a5,ffffffffc0202ca2 <exit_range+0x272>
ffffffffc0202a5e:	8ab2                	mv	s5,a2
ffffffffc0202a60:	24c5f163          	bgeu	a1,a2,ffffffffc0202ca2 <exit_range+0x272>
ffffffffc0202a64:	4785                	li	a5,1
ffffffffc0202a66:	07fe                	slli	a5,a5,0x1f
ffffffffc0202a68:	22c7ed63          	bltu	a5,a2,ffffffffc0202ca2 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202a6c:	c00009b7          	lui	s3,0xc0000
ffffffffc0202a70:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202a74:	ffe00937          	lui	s2,0xffe00
ffffffffc0202a78:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202a7c:	5cfd                	li	s9,-1
ffffffffc0202a7e:	8c2a                	mv	s8,a0
ffffffffc0202a80:	0125f933          	and	s2,a1,s2
ffffffffc0202a84:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202a86:	000ddd17          	auipc	s10,0xdd
ffffffffc0202a8a:	69ad0d13          	addi	s10,s10,1690 # ffffffffc02e0120 <npage>
    return KADDR(page2pa(page));
ffffffffc0202a8e:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202a92:	000dd717          	auipc	a4,0xdd
ffffffffc0202a96:	69670713          	addi	a4,a4,1686 # ffffffffc02e0128 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202a9a:	000ddd97          	auipc	s11,0xdd
ffffffffc0202a9e:	696d8d93          	addi	s11,s11,1686 # ffffffffc02e0130 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202aa2:	c0000437          	lui	s0,0xc0000
ffffffffc0202aa6:	944e                	add	s0,s0,s3
ffffffffc0202aa8:	8079                	srli	s0,s0,0x1e
ffffffffc0202aaa:	1ff47413          	andi	s0,s0,511
ffffffffc0202aae:	040e                	slli	s0,s0,0x3
ffffffffc0202ab0:	9462                	add	s0,s0,s8
ffffffffc0202ab2:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff36c0>
        if (pde1 & PTE_V)
ffffffffc0202ab6:	001a7793          	andi	a5,s4,1
ffffffffc0202aba:	eb99                	bnez	a5,ffffffffc0202ad0 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc0202abc:	12098463          	beqz	s3,ffffffffc0202be4 <exit_range+0x1b4>
ffffffffc0202ac0:	400007b7          	lui	a5,0x40000
ffffffffc0202ac4:	97ce                	add	a5,a5,s3
ffffffffc0202ac6:	894e                	mv	s2,s3
ffffffffc0202ac8:	1159fe63          	bgeu	s3,s5,ffffffffc0202be4 <exit_range+0x1b4>
ffffffffc0202acc:	89be                	mv	s3,a5
ffffffffc0202ace:	bfd1                	j	ffffffffc0202aa2 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc0202ad0:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ad4:	0a0a                	slli	s4,s4,0x2
ffffffffc0202ad6:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ada:	1cfa7263          	bgeu	s4,a5,ffffffffc0202c9e <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ade:	fff80637          	lui	a2,0xfff80
ffffffffc0202ae2:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202ae4:	000806b7          	lui	a3,0x80
ffffffffc0202ae8:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202aea:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202aee:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202af0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202af2:	18f5fa63          	bgeu	a1,a5,ffffffffc0202c86 <exit_range+0x256>
ffffffffc0202af6:	000dd817          	auipc	a6,0xdd
ffffffffc0202afa:	64280813          	addi	a6,a6,1602 # ffffffffc02e0138 <va_pa_offset>
ffffffffc0202afe:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202b02:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202b04:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202b08:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202b0a:	00080337          	lui	t1,0x80
ffffffffc0202b0e:	6885                	lui	a7,0x1
ffffffffc0202b10:	a819                	j	ffffffffc0202b26 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202b12:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202b14:	002007b7          	lui	a5,0x200
ffffffffc0202b18:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202b1a:	08090c63          	beqz	s2,ffffffffc0202bb2 <exit_range+0x182>
ffffffffc0202b1e:	09397a63          	bgeu	s2,s3,ffffffffc0202bb2 <exit_range+0x182>
ffffffffc0202b22:	0f597063          	bgeu	s2,s5,ffffffffc0202c02 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202b26:	01595493          	srli	s1,s2,0x15
ffffffffc0202b2a:	1ff4f493          	andi	s1,s1,511
ffffffffc0202b2e:	048e                	slli	s1,s1,0x3
ffffffffc0202b30:	94da                	add	s1,s1,s6
ffffffffc0202b32:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202b34:	0017f693          	andi	a3,a5,1
ffffffffc0202b38:	dee9                	beqz	a3,ffffffffc0202b12 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202b3a:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b3e:	078a                	slli	a5,a5,0x2
ffffffffc0202b40:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b42:	14b7fe63          	bgeu	a5,a1,ffffffffc0202c9e <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b46:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0202b48:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc0202b4c:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202b50:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b54:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b56:	12bef863          	bgeu	t4,a1,ffffffffc0202c86 <exit_range+0x256>
ffffffffc0202b5a:	00083783          	ld	a5,0(a6)
ffffffffc0202b5e:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202b60:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202b64:	629c                	ld	a5,0(a3)
ffffffffc0202b66:	8b85                	andi	a5,a5,1
ffffffffc0202b68:	f7d5                	bnez	a5,ffffffffc0202b14 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202b6a:	06a1                	addi	a3,a3,8
ffffffffc0202b6c:	fed59ce3          	bne	a1,a3,ffffffffc0202b64 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b70:	631c                	ld	a5,0(a4)
ffffffffc0202b72:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202b74:	100027f3          	csrr	a5,sstatus
ffffffffc0202b78:	8b89                	andi	a5,a5,2
ffffffffc0202b7a:	e7d9                	bnez	a5,ffffffffc0202c08 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202b7c:	000db783          	ld	a5,0(s11)
ffffffffc0202b80:	4585                	li	a1,1
ffffffffc0202b82:	e032                	sd	a2,0(sp)
ffffffffc0202b84:	739c                	ld	a5,32(a5)
ffffffffc0202b86:	9782                	jalr	a5
    if (flag) {
ffffffffc0202b88:	6602                	ld	a2,0(sp)
ffffffffc0202b8a:	000dd817          	auipc	a6,0xdd
ffffffffc0202b8e:	5ae80813          	addi	a6,a6,1454 # ffffffffc02e0138 <va_pa_offset>
ffffffffc0202b92:	fff80e37          	lui	t3,0xfff80
ffffffffc0202b96:	00080337          	lui	t1,0x80
ffffffffc0202b9a:	6885                	lui	a7,0x1
ffffffffc0202b9c:	000dd717          	auipc	a4,0xdd
ffffffffc0202ba0:	58c70713          	addi	a4,a4,1420 # ffffffffc02e0128 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202ba4:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202ba8:	002007b7          	lui	a5,0x200
ffffffffc0202bac:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202bae:	f60918e3          	bnez	s2,ffffffffc0202b1e <exit_range+0xee>
            if (free_pd0)
ffffffffc0202bb2:	f00b85e3          	beqz	s7,ffffffffc0202abc <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202bb6:	000d3783          	ld	a5,0(s10)
ffffffffc0202bba:	0efa7263          	bgeu	s4,a5,ffffffffc0202c9e <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bbe:	6308                	ld	a0,0(a4)
ffffffffc0202bc0:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202bc2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bc6:	8b89                	andi	a5,a5,2
ffffffffc0202bc8:	efad                	bnez	a5,ffffffffc0202c42 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202bca:	000db783          	ld	a5,0(s11)
ffffffffc0202bce:	4585                	li	a1,1
ffffffffc0202bd0:	739c                	ld	a5,32(a5)
ffffffffc0202bd2:	9782                	jalr	a5
ffffffffc0202bd4:	000dd717          	auipc	a4,0xdd
ffffffffc0202bd8:	55470713          	addi	a4,a4,1364 # ffffffffc02e0128 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202bdc:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc0202be0:	ee0990e3          	bnez	s3,ffffffffc0202ac0 <exit_range+0x90>
}
ffffffffc0202be4:	70e6                	ld	ra,120(sp)
ffffffffc0202be6:	7446                	ld	s0,112(sp)
ffffffffc0202be8:	74a6                	ld	s1,104(sp)
ffffffffc0202bea:	7906                	ld	s2,96(sp)
ffffffffc0202bec:	69e6                	ld	s3,88(sp)
ffffffffc0202bee:	6a46                	ld	s4,80(sp)
ffffffffc0202bf0:	6aa6                	ld	s5,72(sp)
ffffffffc0202bf2:	6b06                	ld	s6,64(sp)
ffffffffc0202bf4:	7be2                	ld	s7,56(sp)
ffffffffc0202bf6:	7c42                	ld	s8,48(sp)
ffffffffc0202bf8:	7ca2                	ld	s9,40(sp)
ffffffffc0202bfa:	7d02                	ld	s10,32(sp)
ffffffffc0202bfc:	6de2                	ld	s11,24(sp)
ffffffffc0202bfe:	6109                	addi	sp,sp,128
ffffffffc0202c00:	8082                	ret
            if (free_pd0)
ffffffffc0202c02:	ea0b8fe3          	beqz	s7,ffffffffc0202ac0 <exit_range+0x90>
ffffffffc0202c06:	bf45                	j	ffffffffc0202bb6 <exit_range+0x186>
ffffffffc0202c08:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202c0a:	e42a                	sd	a0,8(sp)
ffffffffc0202c0c:	da9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c10:	000db783          	ld	a5,0(s11)
ffffffffc0202c14:	6522                	ld	a0,8(sp)
ffffffffc0202c16:	4585                	li	a1,1
ffffffffc0202c18:	739c                	ld	a5,32(a5)
ffffffffc0202c1a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c1c:	d93fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202c20:	6602                	ld	a2,0(sp)
ffffffffc0202c22:	000dd717          	auipc	a4,0xdd
ffffffffc0202c26:	50670713          	addi	a4,a4,1286 # ffffffffc02e0128 <pages>
ffffffffc0202c2a:	6885                	lui	a7,0x1
ffffffffc0202c2c:	00080337          	lui	t1,0x80
ffffffffc0202c30:	fff80e37          	lui	t3,0xfff80
ffffffffc0202c34:	000dd817          	auipc	a6,0xdd
ffffffffc0202c38:	50480813          	addi	a6,a6,1284 # ffffffffc02e0138 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202c3c:	0004b023          	sd	zero,0(s1)
ffffffffc0202c40:	b7a5                	j	ffffffffc0202ba8 <exit_range+0x178>
ffffffffc0202c42:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202c44:	d71fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c48:	000db783          	ld	a5,0(s11)
ffffffffc0202c4c:	6502                	ld	a0,0(sp)
ffffffffc0202c4e:	4585                	li	a1,1
ffffffffc0202c50:	739c                	ld	a5,32(a5)
ffffffffc0202c52:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c54:	d5bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202c58:	000dd717          	auipc	a4,0xdd
ffffffffc0202c5c:	4d070713          	addi	a4,a4,1232 # ffffffffc02e0128 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202c60:	00043023          	sd	zero,0(s0)
ffffffffc0202c64:	bfb5                	j	ffffffffc0202be0 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202c66:	00005697          	auipc	a3,0x5
ffffffffc0202c6a:	b7a68693          	addi	a3,a3,-1158 # ffffffffc02077e0 <default_pmm_manager+0x70>
ffffffffc0202c6e:	00004617          	auipc	a2,0x4
ffffffffc0202c72:	3f260613          	addi	a2,a2,1010 # ffffffffc0207060 <commands+0x838>
ffffffffc0202c76:	13600593          	li	a1,310
ffffffffc0202c7a:	00005517          	auipc	a0,0x5
ffffffffc0202c7e:	b5650513          	addi	a0,a0,-1194 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202c82:	da0fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202c86:	00004617          	auipc	a2,0x4
ffffffffc0202c8a:	65260613          	addi	a2,a2,1618 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0202c8e:	07100593          	li	a1,113
ffffffffc0202c92:	00004517          	auipc	a0,0x4
ffffffffc0202c96:	66e50513          	addi	a0,a0,1646 # ffffffffc0207300 <commands+0xad8>
ffffffffc0202c9a:	d88fd0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc0202c9e:	8e1ff0ef          	jal	ra,ffffffffc020257e <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202ca2:	00005697          	auipc	a3,0x5
ffffffffc0202ca6:	b6e68693          	addi	a3,a3,-1170 # ffffffffc0207810 <default_pmm_manager+0xa0>
ffffffffc0202caa:	00004617          	auipc	a2,0x4
ffffffffc0202cae:	3b660613          	addi	a2,a2,950 # ffffffffc0207060 <commands+0x838>
ffffffffc0202cb2:	13700593          	li	a1,311
ffffffffc0202cb6:	00005517          	auipc	a0,0x5
ffffffffc0202cba:	b1a50513          	addi	a0,a0,-1254 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0202cbe:	d64fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0202cc2 <page_remove>:
{
ffffffffc0202cc2:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202cc4:	4601                	li	a2,0
{
ffffffffc0202cc6:	ec26                	sd	s1,24(sp)
ffffffffc0202cc8:	f406                	sd	ra,40(sp)
ffffffffc0202cca:	f022                	sd	s0,32(sp)
ffffffffc0202ccc:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202cce:	9a1ff0ef          	jal	ra,ffffffffc020266e <get_pte>
    if (ptep != NULL)
ffffffffc0202cd2:	c511                	beqz	a0,ffffffffc0202cde <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202cd4:	611c                	ld	a5,0(a0)
ffffffffc0202cd6:	842a                	mv	s0,a0
ffffffffc0202cd8:	0017f713          	andi	a4,a5,1
ffffffffc0202cdc:	e711                	bnez	a4,ffffffffc0202ce8 <page_remove+0x26>
}
ffffffffc0202cde:	70a2                	ld	ra,40(sp)
ffffffffc0202ce0:	7402                	ld	s0,32(sp)
ffffffffc0202ce2:	64e2                	ld	s1,24(sp)
ffffffffc0202ce4:	6145                	addi	sp,sp,48
ffffffffc0202ce6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202ce8:	078a                	slli	a5,a5,0x2
ffffffffc0202cea:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cec:	000dd717          	auipc	a4,0xdd
ffffffffc0202cf0:	43473703          	ld	a4,1076(a4) # ffffffffc02e0120 <npage>
ffffffffc0202cf4:	06e7f363          	bgeu	a5,a4,ffffffffc0202d5a <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cf8:	fff80537          	lui	a0,0xfff80
ffffffffc0202cfc:	97aa                	add	a5,a5,a0
ffffffffc0202cfe:	079a                	slli	a5,a5,0x6
ffffffffc0202d00:	000dd517          	auipc	a0,0xdd
ffffffffc0202d04:	42853503          	ld	a0,1064(a0) # ffffffffc02e0128 <pages>
ffffffffc0202d08:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202d0a:	411c                	lw	a5,0(a0)
ffffffffc0202d0c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202d10:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202d12:	cb11                	beqz	a4,ffffffffc0202d26 <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202d14:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202d18:	12048073          	sfence.vma	s1
}
ffffffffc0202d1c:	70a2                	ld	ra,40(sp)
ffffffffc0202d1e:	7402                	ld	s0,32(sp)
ffffffffc0202d20:	64e2                	ld	s1,24(sp)
ffffffffc0202d22:	6145                	addi	sp,sp,48
ffffffffc0202d24:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202d26:	100027f3          	csrr	a5,sstatus
ffffffffc0202d2a:	8b89                	andi	a5,a5,2
ffffffffc0202d2c:	eb89                	bnez	a5,ffffffffc0202d3e <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202d2e:	000dd797          	auipc	a5,0xdd
ffffffffc0202d32:	4027b783          	ld	a5,1026(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202d36:	739c                	ld	a5,32(a5)
ffffffffc0202d38:	4585                	li	a1,1
ffffffffc0202d3a:	9782                	jalr	a5
    if (flag) {
ffffffffc0202d3c:	bfe1                	j	ffffffffc0202d14 <page_remove+0x52>
        intr_disable();
ffffffffc0202d3e:	e42a                	sd	a0,8(sp)
ffffffffc0202d40:	c75fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d44:	000dd797          	auipc	a5,0xdd
ffffffffc0202d48:	3ec7b783          	ld	a5,1004(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202d4c:	739c                	ld	a5,32(a5)
ffffffffc0202d4e:	6522                	ld	a0,8(sp)
ffffffffc0202d50:	4585                	li	a1,1
ffffffffc0202d52:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d54:	c5bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d58:	bf75                	j	ffffffffc0202d14 <page_remove+0x52>
ffffffffc0202d5a:	825ff0ef          	jal	ra,ffffffffc020257e <pa2page.part.0>

ffffffffc0202d5e <page_insert>:
{
ffffffffc0202d5e:	7139                	addi	sp,sp,-64
ffffffffc0202d60:	e852                	sd	s4,16(sp)
ffffffffc0202d62:	8a32                	mv	s4,a2
ffffffffc0202d64:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202d66:	4605                	li	a2,1
{
ffffffffc0202d68:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202d6a:	85d2                	mv	a1,s4
{
ffffffffc0202d6c:	f426                	sd	s1,40(sp)
ffffffffc0202d6e:	fc06                	sd	ra,56(sp)
ffffffffc0202d70:	f04a                	sd	s2,32(sp)
ffffffffc0202d72:	ec4e                	sd	s3,24(sp)
ffffffffc0202d74:	e456                	sd	s5,8(sp)
ffffffffc0202d76:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202d78:	8f7ff0ef          	jal	ra,ffffffffc020266e <get_pte>
    if (ptep == NULL)
ffffffffc0202d7c:	c961                	beqz	a0,ffffffffc0202e4c <page_insert+0xee>
    page->ref += 1;
ffffffffc0202d7e:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202d80:	611c                	ld	a5,0(a0)
ffffffffc0202d82:	89aa                	mv	s3,a0
ffffffffc0202d84:	0016871b          	addiw	a4,a3,1
ffffffffc0202d88:	c018                	sw	a4,0(s0)
ffffffffc0202d8a:	0017f713          	andi	a4,a5,1
ffffffffc0202d8e:	ef05                	bnez	a4,ffffffffc0202dc6 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202d90:	000dd717          	auipc	a4,0xdd
ffffffffc0202d94:	39873703          	ld	a4,920(a4) # ffffffffc02e0128 <pages>
ffffffffc0202d98:	8c19                	sub	s0,s0,a4
ffffffffc0202d9a:	000807b7          	lui	a5,0x80
ffffffffc0202d9e:	8419                	srai	s0,s0,0x6
ffffffffc0202da0:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202da2:	042a                	slli	s0,s0,0xa
ffffffffc0202da4:	8cc1                	or	s1,s1,s0
ffffffffc0202da6:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202daa:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff36c0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202dae:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202db2:	4501                	li	a0,0
}
ffffffffc0202db4:	70e2                	ld	ra,56(sp)
ffffffffc0202db6:	7442                	ld	s0,48(sp)
ffffffffc0202db8:	74a2                	ld	s1,40(sp)
ffffffffc0202dba:	7902                	ld	s2,32(sp)
ffffffffc0202dbc:	69e2                	ld	s3,24(sp)
ffffffffc0202dbe:	6a42                	ld	s4,16(sp)
ffffffffc0202dc0:	6aa2                	ld	s5,8(sp)
ffffffffc0202dc2:	6121                	addi	sp,sp,64
ffffffffc0202dc4:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202dc6:	078a                	slli	a5,a5,0x2
ffffffffc0202dc8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dca:	000dd717          	auipc	a4,0xdd
ffffffffc0202dce:	35673703          	ld	a4,854(a4) # ffffffffc02e0120 <npage>
ffffffffc0202dd2:	06e7ff63          	bgeu	a5,a4,ffffffffc0202e50 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dd6:	000dda97          	auipc	s5,0xdd
ffffffffc0202dda:	352a8a93          	addi	s5,s5,850 # ffffffffc02e0128 <pages>
ffffffffc0202dde:	000ab703          	ld	a4,0(s5)
ffffffffc0202de2:	fff80937          	lui	s2,0xfff80
ffffffffc0202de6:	993e                	add	s2,s2,a5
ffffffffc0202de8:	091a                	slli	s2,s2,0x6
ffffffffc0202dea:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0202dec:	01240c63          	beq	s0,s2,ffffffffc0202e04 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc0202df0:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fc9fe90>
ffffffffc0202df4:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202df8:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0202dfc:	c691                	beqz	a3,ffffffffc0202e08 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202dfe:	120a0073          	sfence.vma	s4
}
ffffffffc0202e02:	bf59                	j	ffffffffc0202d98 <page_insert+0x3a>
ffffffffc0202e04:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202e06:	bf49                	j	ffffffffc0202d98 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202e08:	100027f3          	csrr	a5,sstatus
ffffffffc0202e0c:	8b89                	andi	a5,a5,2
ffffffffc0202e0e:	ef91                	bnez	a5,ffffffffc0202e2a <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202e10:	000dd797          	auipc	a5,0xdd
ffffffffc0202e14:	3207b783          	ld	a5,800(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202e18:	739c                	ld	a5,32(a5)
ffffffffc0202e1a:	4585                	li	a1,1
ffffffffc0202e1c:	854a                	mv	a0,s2
ffffffffc0202e1e:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202e20:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202e24:	120a0073          	sfence.vma	s4
ffffffffc0202e28:	bf85                	j	ffffffffc0202d98 <page_insert+0x3a>
        intr_disable();
ffffffffc0202e2a:	b8bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e2e:	000dd797          	auipc	a5,0xdd
ffffffffc0202e32:	3027b783          	ld	a5,770(a5) # ffffffffc02e0130 <pmm_manager>
ffffffffc0202e36:	739c                	ld	a5,32(a5)
ffffffffc0202e38:	4585                	li	a1,1
ffffffffc0202e3a:	854a                	mv	a0,s2
ffffffffc0202e3c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e3e:	b71fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e42:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202e46:	120a0073          	sfence.vma	s4
ffffffffc0202e4a:	b7b9                	j	ffffffffc0202d98 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202e4c:	5571                	li	a0,-4
ffffffffc0202e4e:	b79d                	j	ffffffffc0202db4 <page_insert+0x56>
ffffffffc0202e50:	f2eff0ef          	jal	ra,ffffffffc020257e <pa2page.part.0>

ffffffffc0202e54 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202e54:	00005797          	auipc	a5,0x5
ffffffffc0202e58:	91c78793          	addi	a5,a5,-1764 # ffffffffc0207770 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202e5c:	638c                	ld	a1,0(a5)
{
ffffffffc0202e5e:	7159                	addi	sp,sp,-112
ffffffffc0202e60:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202e62:	00005517          	auipc	a0,0x5
ffffffffc0202e66:	9c650513          	addi	a0,a0,-1594 # ffffffffc0207828 <default_pmm_manager+0xb8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202e6a:	000ddb17          	auipc	s6,0xdd
ffffffffc0202e6e:	2c6b0b13          	addi	s6,s6,710 # ffffffffc02e0130 <pmm_manager>
{
ffffffffc0202e72:	f486                	sd	ra,104(sp)
ffffffffc0202e74:	e8ca                	sd	s2,80(sp)
ffffffffc0202e76:	e4ce                	sd	s3,72(sp)
ffffffffc0202e78:	f0a2                	sd	s0,96(sp)
ffffffffc0202e7a:	eca6                	sd	s1,88(sp)
ffffffffc0202e7c:	e0d2                	sd	s4,64(sp)
ffffffffc0202e7e:	fc56                	sd	s5,56(sp)
ffffffffc0202e80:	f45e                	sd	s7,40(sp)
ffffffffc0202e82:	f062                	sd	s8,32(sp)
ffffffffc0202e84:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202e86:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202e8a:	a5afd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    pmm_manager->init();
ffffffffc0202e8e:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202e92:	000dd997          	auipc	s3,0xdd
ffffffffc0202e96:	2a698993          	addi	s3,s3,678 # ffffffffc02e0138 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202e9a:	679c                	ld	a5,8(a5)
ffffffffc0202e9c:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202e9e:	57f5                	li	a5,-3
ffffffffc0202ea0:	07fa                	slli	a5,a5,0x1e
ffffffffc0202ea2:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202ea6:	a37fd0ef          	jal	ra,ffffffffc02008dc <get_memory_base>
ffffffffc0202eaa:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0202eac:	a3bfd0ef          	jal	ra,ffffffffc02008e6 <get_memory_size>
    if (mem_size == 0) {
ffffffffc0202eb0:	200505e3          	beqz	a0,ffffffffc02038ba <pmm_init+0xa66>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202eb4:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202eb6:	00005517          	auipc	a0,0x5
ffffffffc0202eba:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0207860 <default_pmm_manager+0xf0>
ffffffffc0202ebe:	a26fd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202ec2:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202ec6:	fff40693          	addi	a3,s0,-1
ffffffffc0202eca:	864a                	mv	a2,s2
ffffffffc0202ecc:	85a6                	mv	a1,s1
ffffffffc0202ece:	00005517          	auipc	a0,0x5
ffffffffc0202ed2:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0207878 <default_pmm_manager+0x108>
ffffffffc0202ed6:	a0efd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202eda:	c8000737          	lui	a4,0xc8000
ffffffffc0202ede:	87a2                	mv	a5,s0
ffffffffc0202ee0:	54876163          	bltu	a4,s0,ffffffffc0203422 <pmm_init+0x5ce>
ffffffffc0202ee4:	757d                	lui	a0,0xfffff
ffffffffc0202ee6:	000de617          	auipc	a2,0xde
ffffffffc0202eea:	28960613          	addi	a2,a2,649 # ffffffffc02e116f <end+0xfff>
ffffffffc0202eee:	8e69                	and	a2,a2,a0
ffffffffc0202ef0:	000dd497          	auipc	s1,0xdd
ffffffffc0202ef4:	23048493          	addi	s1,s1,560 # ffffffffc02e0120 <npage>
ffffffffc0202ef8:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202efc:	000ddb97          	auipc	s7,0xdd
ffffffffc0202f00:	22cb8b93          	addi	s7,s7,556 # ffffffffc02e0128 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202f04:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202f06:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f0a:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202f0e:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f10:	02f50863          	beq	a0,a5,ffffffffc0202f40 <pmm_init+0xec>
ffffffffc0202f14:	4781                	li	a5,0
ffffffffc0202f16:	4585                	li	a1,1
ffffffffc0202f18:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202f1c:	00679513          	slli	a0,a5,0x6
ffffffffc0202f20:	9532                	add	a0,a0,a2
ffffffffc0202f22:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd1ee98>
ffffffffc0202f26:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f2a:	6088                	ld	a0,0(s1)
ffffffffc0202f2c:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202f2e:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f32:	00d50733          	add	a4,a0,a3
ffffffffc0202f36:	fee7e3e3          	bltu	a5,a4,ffffffffc0202f1c <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202f3a:	071a                	slli	a4,a4,0x6
ffffffffc0202f3c:	00e606b3          	add	a3,a2,a4
ffffffffc0202f40:	c02007b7          	lui	a5,0xc0200
ffffffffc0202f44:	2ef6ece3          	bltu	a3,a5,ffffffffc0203a3c <pmm_init+0xbe8>
ffffffffc0202f48:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202f4c:	77fd                	lui	a5,0xfffff
ffffffffc0202f4e:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202f50:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202f52:	5086eb63          	bltu	a3,s0,ffffffffc0203468 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202f56:	00005517          	auipc	a0,0x5
ffffffffc0202f5a:	94a50513          	addi	a0,a0,-1718 # ffffffffc02078a0 <default_pmm_manager+0x130>
ffffffffc0202f5e:	986fd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202f62:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202f66:	000dd917          	auipc	s2,0xdd
ffffffffc0202f6a:	1b290913          	addi	s2,s2,434 # ffffffffc02e0118 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202f6e:	7b9c                	ld	a5,48(a5)
ffffffffc0202f70:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202f72:	00005517          	auipc	a0,0x5
ffffffffc0202f76:	94650513          	addi	a0,a0,-1722 # ffffffffc02078b8 <default_pmm_manager+0x148>
ffffffffc0202f7a:	96afd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202f7e:	00009697          	auipc	a3,0x9
ffffffffc0202f82:	08268693          	addi	a3,a3,130 # ffffffffc020c000 <boot_page_table_sv39>
ffffffffc0202f86:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202f8a:	c02007b7          	lui	a5,0xc0200
ffffffffc0202f8e:	28f6ebe3          	bltu	a3,a5,ffffffffc0203a24 <pmm_init+0xbd0>
ffffffffc0202f92:	0009b783          	ld	a5,0(s3)
ffffffffc0202f96:	8e9d                	sub	a3,a3,a5
ffffffffc0202f98:	000dd797          	auipc	a5,0xdd
ffffffffc0202f9c:	16d7bc23          	sd	a3,376(a5) # ffffffffc02e0110 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202fa0:	100027f3          	csrr	a5,sstatus
ffffffffc0202fa4:	8b89                	andi	a5,a5,2
ffffffffc0202fa6:	4a079763          	bnez	a5,ffffffffc0203454 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202faa:	000b3783          	ld	a5,0(s6)
ffffffffc0202fae:	779c                	ld	a5,40(a5)
ffffffffc0202fb0:	9782                	jalr	a5
ffffffffc0202fb2:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202fb4:	6098                	ld	a4,0(s1)
ffffffffc0202fb6:	c80007b7          	lui	a5,0xc8000
ffffffffc0202fba:	83b1                	srli	a5,a5,0xc
ffffffffc0202fbc:	66e7e363          	bltu	a5,a4,ffffffffc0203622 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202fc0:	00093503          	ld	a0,0(s2)
ffffffffc0202fc4:	62050f63          	beqz	a0,ffffffffc0203602 <pmm_init+0x7ae>
ffffffffc0202fc8:	03451793          	slli	a5,a0,0x34
ffffffffc0202fcc:	62079b63          	bnez	a5,ffffffffc0203602 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202fd0:	4601                	li	a2,0
ffffffffc0202fd2:	4581                	li	a1,0
ffffffffc0202fd4:	8c3ff0ef          	jal	ra,ffffffffc0202896 <get_page>
ffffffffc0202fd8:	60051563          	bnez	a0,ffffffffc02035e2 <pmm_init+0x78e>
ffffffffc0202fdc:	100027f3          	csrr	a5,sstatus
ffffffffc0202fe0:	8b89                	andi	a5,a5,2
ffffffffc0202fe2:	44079e63          	bnez	a5,ffffffffc020343e <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202fe6:	000b3783          	ld	a5,0(s6)
ffffffffc0202fea:	4505                	li	a0,1
ffffffffc0202fec:	6f9c                	ld	a5,24(a5)
ffffffffc0202fee:	9782                	jalr	a5
ffffffffc0202ff0:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202ff2:	00093503          	ld	a0,0(s2)
ffffffffc0202ff6:	4681                	li	a3,0
ffffffffc0202ff8:	4601                	li	a2,0
ffffffffc0202ffa:	85d2                	mv	a1,s4
ffffffffc0202ffc:	d63ff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
ffffffffc0203000:	26051ae3          	bnez	a0,ffffffffc0203a74 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203004:	00093503          	ld	a0,0(s2)
ffffffffc0203008:	4601                	li	a2,0
ffffffffc020300a:	4581                	li	a1,0
ffffffffc020300c:	e62ff0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc0203010:	240502e3          	beqz	a0,ffffffffc0203a54 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0203014:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0203016:	0017f713          	andi	a4,a5,1
ffffffffc020301a:	5a070263          	beqz	a4,ffffffffc02035be <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020301e:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203020:	078a                	slli	a5,a5,0x2
ffffffffc0203022:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203024:	58e7fb63          	bgeu	a5,a4,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203028:	000bb683          	ld	a3,0(s7)
ffffffffc020302c:	fff80637          	lui	a2,0xfff80
ffffffffc0203030:	97b2                	add	a5,a5,a2
ffffffffc0203032:	079a                	slli	a5,a5,0x6
ffffffffc0203034:	97b6                	add	a5,a5,a3
ffffffffc0203036:	14fa17e3          	bne	s4,a5,ffffffffc0203984 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020303a:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x9178>
ffffffffc020303e:	4785                	li	a5,1
ffffffffc0203040:	12f692e3          	bne	a3,a5,ffffffffc0203964 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203044:	00093503          	ld	a0,0(s2)
ffffffffc0203048:	77fd                	lui	a5,0xfffff
ffffffffc020304a:	6114                	ld	a3,0(a0)
ffffffffc020304c:	068a                	slli	a3,a3,0x2
ffffffffc020304e:	8efd                	and	a3,a3,a5
ffffffffc0203050:	00c6d613          	srli	a2,a3,0xc
ffffffffc0203054:	0ee67ce3          	bgeu	a2,a4,ffffffffc020394c <pmm_init+0xaf8>
ffffffffc0203058:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020305c:	96e2                	add	a3,a3,s8
ffffffffc020305e:	0006ba83          	ld	s5,0(a3)
ffffffffc0203062:	0a8a                	slli	s5,s5,0x2
ffffffffc0203064:	00fafab3          	and	s5,s5,a5
ffffffffc0203068:	00cad793          	srli	a5,s5,0xc
ffffffffc020306c:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203932 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203070:	4601                	li	a2,0
ffffffffc0203072:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203074:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203076:	df8ff0ef          	jal	ra,ffffffffc020266e <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020307a:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020307c:	55551363          	bne	a0,s5,ffffffffc02035c2 <pmm_init+0x76e>
ffffffffc0203080:	100027f3          	csrr	a5,sstatus
ffffffffc0203084:	8b89                	andi	a5,a5,2
ffffffffc0203086:	3a079163          	bnez	a5,ffffffffc0203428 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc020308a:	000b3783          	ld	a5,0(s6)
ffffffffc020308e:	4505                	li	a0,1
ffffffffc0203090:	6f9c                	ld	a5,24(a5)
ffffffffc0203092:	9782                	jalr	a5
ffffffffc0203094:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203096:	00093503          	ld	a0,0(s2)
ffffffffc020309a:	46d1                	li	a3,20
ffffffffc020309c:	6605                	lui	a2,0x1
ffffffffc020309e:	85e2                	mv	a1,s8
ffffffffc02030a0:	cbfff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
ffffffffc02030a4:	060517e3          	bnez	a0,ffffffffc0203912 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030a8:	00093503          	ld	a0,0(s2)
ffffffffc02030ac:	4601                	li	a2,0
ffffffffc02030ae:	6585                	lui	a1,0x1
ffffffffc02030b0:	dbeff0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc02030b4:	02050fe3          	beqz	a0,ffffffffc02038f2 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02030b8:	611c                	ld	a5,0(a0)
ffffffffc02030ba:	0107f713          	andi	a4,a5,16
ffffffffc02030be:	7c070e63          	beqz	a4,ffffffffc020389a <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02030c2:	8b91                	andi	a5,a5,4
ffffffffc02030c4:	7a078b63          	beqz	a5,ffffffffc020387a <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02030c8:	00093503          	ld	a0,0(s2)
ffffffffc02030cc:	611c                	ld	a5,0(a0)
ffffffffc02030ce:	8bc1                	andi	a5,a5,16
ffffffffc02030d0:	78078563          	beqz	a5,ffffffffc020385a <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02030d4:	000c2703          	lw	a4,0(s8)
ffffffffc02030d8:	4785                	li	a5,1
ffffffffc02030da:	76f71063          	bne	a4,a5,ffffffffc020383a <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02030de:	4681                	li	a3,0
ffffffffc02030e0:	6605                	lui	a2,0x1
ffffffffc02030e2:	85d2                	mv	a1,s4
ffffffffc02030e4:	c7bff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
ffffffffc02030e8:	72051963          	bnez	a0,ffffffffc020381a <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02030ec:	000a2703          	lw	a4,0(s4)
ffffffffc02030f0:	4789                	li	a5,2
ffffffffc02030f2:	70f71463          	bne	a4,a5,ffffffffc02037fa <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02030f6:	000c2783          	lw	a5,0(s8)
ffffffffc02030fa:	6e079063          	bnez	a5,ffffffffc02037da <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030fe:	00093503          	ld	a0,0(s2)
ffffffffc0203102:	4601                	li	a2,0
ffffffffc0203104:	6585                	lui	a1,0x1
ffffffffc0203106:	d68ff0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc020310a:	6a050863          	beqz	a0,ffffffffc02037ba <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc020310e:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0203110:	00177793          	andi	a5,a4,1
ffffffffc0203114:	4a078563          	beqz	a5,ffffffffc02035be <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0203118:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020311a:	00271793          	slli	a5,a4,0x2
ffffffffc020311e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203120:	48d7fd63          	bgeu	a5,a3,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203124:	000bb683          	ld	a3,0(s7)
ffffffffc0203128:	fff80ab7          	lui	s5,0xfff80
ffffffffc020312c:	97d6                	add	a5,a5,s5
ffffffffc020312e:	079a                	slli	a5,a5,0x6
ffffffffc0203130:	97b6                	add	a5,a5,a3
ffffffffc0203132:	66fa1463          	bne	s4,a5,ffffffffc020379a <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0203136:	8b41                	andi	a4,a4,16
ffffffffc0203138:	64071163          	bnez	a4,ffffffffc020377a <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc020313c:	00093503          	ld	a0,0(s2)
ffffffffc0203140:	4581                	li	a1,0
ffffffffc0203142:	b81ff0ef          	jal	ra,ffffffffc0202cc2 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0203146:	000a2c83          	lw	s9,0(s4)
ffffffffc020314a:	4785                	li	a5,1
ffffffffc020314c:	60fc9763          	bne	s9,a5,ffffffffc020375a <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0203150:	000c2783          	lw	a5,0(s8)
ffffffffc0203154:	5e079363          	bnez	a5,ffffffffc020373a <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0203158:	00093503          	ld	a0,0(s2)
ffffffffc020315c:	6585                	lui	a1,0x1
ffffffffc020315e:	b65ff0ef          	jal	ra,ffffffffc0202cc2 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0203162:	000a2783          	lw	a5,0(s4)
ffffffffc0203166:	52079a63          	bnez	a5,ffffffffc020369a <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc020316a:	000c2783          	lw	a5,0(s8)
ffffffffc020316e:	50079663          	bnez	a5,ffffffffc020367a <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0203172:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0203176:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203178:	000a3683          	ld	a3,0(s4)
ffffffffc020317c:	068a                	slli	a3,a3,0x2
ffffffffc020317e:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0203180:	42b6fd63          	bgeu	a3,a1,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203184:	000bb503          	ld	a0,0(s7)
ffffffffc0203188:	96d6                	add	a3,a3,s5
ffffffffc020318a:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc020318c:	00d507b3          	add	a5,a0,a3
ffffffffc0203190:	439c                	lw	a5,0(a5)
ffffffffc0203192:	4d979463          	bne	a5,s9,ffffffffc020365a <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0203196:	8699                	srai	a3,a3,0x6
ffffffffc0203198:	00080637          	lui	a2,0x80
ffffffffc020319c:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc020319e:	00c69713          	slli	a4,a3,0xc
ffffffffc02031a2:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02031a4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02031a6:	48b77e63          	bgeu	a4,a1,ffffffffc0203642 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02031aa:	0009b703          	ld	a4,0(s3)
ffffffffc02031ae:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02031b0:	629c                	ld	a5,0(a3)
ffffffffc02031b2:	078a                	slli	a5,a5,0x2
ffffffffc02031b4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02031b6:	40b7f263          	bgeu	a5,a1,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02031ba:	8f91                	sub	a5,a5,a2
ffffffffc02031bc:	079a                	slli	a5,a5,0x6
ffffffffc02031be:	953e                	add	a0,a0,a5
ffffffffc02031c0:	100027f3          	csrr	a5,sstatus
ffffffffc02031c4:	8b89                	andi	a5,a5,2
ffffffffc02031c6:	30079963          	bnez	a5,ffffffffc02034d8 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02031ca:	000b3783          	ld	a5,0(s6)
ffffffffc02031ce:	4585                	li	a1,1
ffffffffc02031d0:	739c                	ld	a5,32(a5)
ffffffffc02031d2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02031d4:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02031d8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02031da:	078a                	slli	a5,a5,0x2
ffffffffc02031dc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02031de:	3ce7fe63          	bgeu	a5,a4,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02031e2:	000bb503          	ld	a0,0(s7)
ffffffffc02031e6:	fff80737          	lui	a4,0xfff80
ffffffffc02031ea:	97ba                	add	a5,a5,a4
ffffffffc02031ec:	079a                	slli	a5,a5,0x6
ffffffffc02031ee:	953e                	add	a0,a0,a5
ffffffffc02031f0:	100027f3          	csrr	a5,sstatus
ffffffffc02031f4:	8b89                	andi	a5,a5,2
ffffffffc02031f6:	2c079563          	bnez	a5,ffffffffc02034c0 <pmm_init+0x66c>
ffffffffc02031fa:	000b3783          	ld	a5,0(s6)
ffffffffc02031fe:	4585                	li	a1,1
ffffffffc0203200:	739c                	ld	a5,32(a5)
ffffffffc0203202:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0203204:	00093783          	ld	a5,0(s2)
ffffffffc0203208:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd1ee90>
    asm volatile("sfence.vma");
ffffffffc020320c:	12000073          	sfence.vma
ffffffffc0203210:	100027f3          	csrr	a5,sstatus
ffffffffc0203214:	8b89                	andi	a5,a5,2
ffffffffc0203216:	28079b63          	bnez	a5,ffffffffc02034ac <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc020321a:	000b3783          	ld	a5,0(s6)
ffffffffc020321e:	779c                	ld	a5,40(a5)
ffffffffc0203220:	9782                	jalr	a5
ffffffffc0203222:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0203224:	4b441b63          	bne	s0,s4,ffffffffc02036da <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0203228:	00005517          	auipc	a0,0x5
ffffffffc020322c:	9b850513          	addi	a0,a0,-1608 # ffffffffc0207be0 <default_pmm_manager+0x470>
ffffffffc0203230:	eb5fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc0203234:	100027f3          	csrr	a5,sstatus
ffffffffc0203238:	8b89                	andi	a5,a5,2
ffffffffc020323a:	24079f63          	bnez	a5,ffffffffc0203498 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc020323e:	000b3783          	ld	a5,0(s6)
ffffffffc0203242:	779c                	ld	a5,40(a5)
ffffffffc0203244:	9782                	jalr	a5
ffffffffc0203246:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0203248:	6098                	ld	a4,0(s1)
ffffffffc020324a:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020324e:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0203250:	00c71793          	slli	a5,a4,0xc
ffffffffc0203254:	6a05                	lui	s4,0x1
ffffffffc0203256:	02f47c63          	bgeu	s0,a5,ffffffffc020328e <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020325a:	00c45793          	srli	a5,s0,0xc
ffffffffc020325e:	00093503          	ld	a0,0(s2)
ffffffffc0203262:	2ee7ff63          	bgeu	a5,a4,ffffffffc0203560 <pmm_init+0x70c>
ffffffffc0203266:	0009b583          	ld	a1,0(s3)
ffffffffc020326a:	4601                	li	a2,0
ffffffffc020326c:	95a2                	add	a1,a1,s0
ffffffffc020326e:	c00ff0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc0203272:	32050463          	beqz	a0,ffffffffc020359a <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203276:	611c                	ld	a5,0(a0)
ffffffffc0203278:	078a                	slli	a5,a5,0x2
ffffffffc020327a:	0157f7b3          	and	a5,a5,s5
ffffffffc020327e:	2e879e63          	bne	a5,s0,ffffffffc020357a <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0203282:	6098                	ld	a4,0(s1)
ffffffffc0203284:	9452                	add	s0,s0,s4
ffffffffc0203286:	00c71793          	slli	a5,a4,0xc
ffffffffc020328a:	fcf468e3          	bltu	s0,a5,ffffffffc020325a <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc020328e:	00093783          	ld	a5,0(s2)
ffffffffc0203292:	639c                	ld	a5,0(a5)
ffffffffc0203294:	42079363          	bnez	a5,ffffffffc02036ba <pmm_init+0x866>
ffffffffc0203298:	100027f3          	csrr	a5,sstatus
ffffffffc020329c:	8b89                	andi	a5,a5,2
ffffffffc020329e:	24079963          	bnez	a5,ffffffffc02034f0 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02032a2:	000b3783          	ld	a5,0(s6)
ffffffffc02032a6:	4505                	li	a0,1
ffffffffc02032a8:	6f9c                	ld	a5,24(a5)
ffffffffc02032aa:	9782                	jalr	a5
ffffffffc02032ac:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02032ae:	00093503          	ld	a0,0(s2)
ffffffffc02032b2:	4699                	li	a3,6
ffffffffc02032b4:	10000613          	li	a2,256
ffffffffc02032b8:	85d2                	mv	a1,s4
ffffffffc02032ba:	aa5ff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
ffffffffc02032be:	44051e63          	bnez	a0,ffffffffc020371a <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc02032c2:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x9178>
ffffffffc02032c6:	4785                	li	a5,1
ffffffffc02032c8:	42f71963          	bne	a4,a5,ffffffffc02036fa <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02032cc:	00093503          	ld	a0,0(s2)
ffffffffc02032d0:	6405                	lui	s0,0x1
ffffffffc02032d2:	4699                	li	a3,6
ffffffffc02032d4:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x9078>
ffffffffc02032d8:	85d2                	mv	a1,s4
ffffffffc02032da:	a85ff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
ffffffffc02032de:	72051363          	bnez	a0,ffffffffc0203a04 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc02032e2:	000a2703          	lw	a4,0(s4)
ffffffffc02032e6:	4789                	li	a5,2
ffffffffc02032e8:	6ef71e63          	bne	a4,a5,ffffffffc02039e4 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02032ec:	00005597          	auipc	a1,0x5
ffffffffc02032f0:	a3c58593          	addi	a1,a1,-1476 # ffffffffc0207d28 <default_pmm_manager+0x5b8>
ffffffffc02032f4:	10000513          	li	a0,256
ffffffffc02032f8:	5eb020ef          	jal	ra,ffffffffc02060e2 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02032fc:	10040593          	addi	a1,s0,256
ffffffffc0203300:	10000513          	li	a0,256
ffffffffc0203304:	5f1020ef          	jal	ra,ffffffffc02060f4 <strcmp>
ffffffffc0203308:	6a051e63          	bnez	a0,ffffffffc02039c4 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc020330c:	000bb683          	ld	a3,0(s7)
ffffffffc0203310:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0203314:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0203316:	40da06b3          	sub	a3,s4,a3
ffffffffc020331a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020331c:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc020331e:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0203320:	8031                	srli	s0,s0,0xc
ffffffffc0203322:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203326:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203328:	30f77d63          	bgeu	a4,a5,ffffffffc0203642 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020332c:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203330:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203334:	96be                	add	a3,a3,a5
ffffffffc0203336:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020333a:	573020ef          	jal	ra,ffffffffc02060ac <strlen>
ffffffffc020333e:	66051363          	bnez	a0,ffffffffc02039a4 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0203342:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0203346:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203348:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd1ee90>
ffffffffc020334c:	068a                	slli	a3,a3,0x2
ffffffffc020334e:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0203350:	26f6f563          	bgeu	a3,a5,ffffffffc02035ba <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0203354:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203356:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203358:	2ef47563          	bgeu	s0,a5,ffffffffc0203642 <pmm_init+0x7ee>
ffffffffc020335c:	0009b403          	ld	s0,0(s3)
ffffffffc0203360:	9436                	add	s0,s0,a3
ffffffffc0203362:	100027f3          	csrr	a5,sstatus
ffffffffc0203366:	8b89                	andi	a5,a5,2
ffffffffc0203368:	1e079163          	bnez	a5,ffffffffc020354a <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc020336c:	000b3783          	ld	a5,0(s6)
ffffffffc0203370:	4585                	li	a1,1
ffffffffc0203372:	8552                	mv	a0,s4
ffffffffc0203374:	739c                	ld	a5,32(a5)
ffffffffc0203376:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203378:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc020337a:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020337c:	078a                	slli	a5,a5,0x2
ffffffffc020337e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203380:	22e7fd63          	bgeu	a5,a4,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203384:	000bb503          	ld	a0,0(s7)
ffffffffc0203388:	fff80737          	lui	a4,0xfff80
ffffffffc020338c:	97ba                	add	a5,a5,a4
ffffffffc020338e:	079a                	slli	a5,a5,0x6
ffffffffc0203390:	953e                	add	a0,a0,a5
ffffffffc0203392:	100027f3          	csrr	a5,sstatus
ffffffffc0203396:	8b89                	andi	a5,a5,2
ffffffffc0203398:	18079d63          	bnez	a5,ffffffffc0203532 <pmm_init+0x6de>
ffffffffc020339c:	000b3783          	ld	a5,0(s6)
ffffffffc02033a0:	4585                	li	a1,1
ffffffffc02033a2:	739c                	ld	a5,32(a5)
ffffffffc02033a4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02033a6:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc02033aa:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02033ac:	078a                	slli	a5,a5,0x2
ffffffffc02033ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02033b0:	20e7f563          	bgeu	a5,a4,ffffffffc02035ba <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02033b4:	000bb503          	ld	a0,0(s7)
ffffffffc02033b8:	fff80737          	lui	a4,0xfff80
ffffffffc02033bc:	97ba                	add	a5,a5,a4
ffffffffc02033be:	079a                	slli	a5,a5,0x6
ffffffffc02033c0:	953e                	add	a0,a0,a5
ffffffffc02033c2:	100027f3          	csrr	a5,sstatus
ffffffffc02033c6:	8b89                	andi	a5,a5,2
ffffffffc02033c8:	14079963          	bnez	a5,ffffffffc020351a <pmm_init+0x6c6>
ffffffffc02033cc:	000b3783          	ld	a5,0(s6)
ffffffffc02033d0:	4585                	li	a1,1
ffffffffc02033d2:	739c                	ld	a5,32(a5)
ffffffffc02033d4:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02033d6:	00093783          	ld	a5,0(s2)
ffffffffc02033da:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc02033de:	12000073          	sfence.vma
ffffffffc02033e2:	100027f3          	csrr	a5,sstatus
ffffffffc02033e6:	8b89                	andi	a5,a5,2
ffffffffc02033e8:	10079f63          	bnez	a5,ffffffffc0203506 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc02033ec:	000b3783          	ld	a5,0(s6)
ffffffffc02033f0:	779c                	ld	a5,40(a5)
ffffffffc02033f2:	9782                	jalr	a5
ffffffffc02033f4:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02033f6:	4c8c1e63          	bne	s8,s0,ffffffffc02038d2 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02033fa:	00005517          	auipc	a0,0x5
ffffffffc02033fe:	9a650513          	addi	a0,a0,-1626 # ffffffffc0207da0 <default_pmm_manager+0x630>
ffffffffc0203402:	ce3fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
}
ffffffffc0203406:	7406                	ld	s0,96(sp)
ffffffffc0203408:	70a6                	ld	ra,104(sp)
ffffffffc020340a:	64e6                	ld	s1,88(sp)
ffffffffc020340c:	6946                	ld	s2,80(sp)
ffffffffc020340e:	69a6                	ld	s3,72(sp)
ffffffffc0203410:	6a06                	ld	s4,64(sp)
ffffffffc0203412:	7ae2                	ld	s5,56(sp)
ffffffffc0203414:	7b42                	ld	s6,48(sp)
ffffffffc0203416:	7ba2                	ld	s7,40(sp)
ffffffffc0203418:	7c02                	ld	s8,32(sp)
ffffffffc020341a:	6ce2                	ld	s9,24(sp)
ffffffffc020341c:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc020341e:	ce8fe06f          	j	ffffffffc0201906 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0203422:	c80007b7          	lui	a5,0xc8000
ffffffffc0203426:	bc7d                	j	ffffffffc0202ee4 <pmm_init+0x90>
        intr_disable();
ffffffffc0203428:	d8cfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020342c:	000b3783          	ld	a5,0(s6)
ffffffffc0203430:	4505                	li	a0,1
ffffffffc0203432:	6f9c                	ld	a5,24(a5)
ffffffffc0203434:	9782                	jalr	a5
ffffffffc0203436:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0203438:	d76fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020343c:	b9a9                	j	ffffffffc0203096 <pmm_init+0x242>
        intr_disable();
ffffffffc020343e:	d76fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203442:	000b3783          	ld	a5,0(s6)
ffffffffc0203446:	4505                	li	a0,1
ffffffffc0203448:	6f9c                	ld	a5,24(a5)
ffffffffc020344a:	9782                	jalr	a5
ffffffffc020344c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc020344e:	d60fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203452:	b645                	j	ffffffffc0202ff2 <pmm_init+0x19e>
        intr_disable();
ffffffffc0203454:	d60fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203458:	000b3783          	ld	a5,0(s6)
ffffffffc020345c:	779c                	ld	a5,40(a5)
ffffffffc020345e:	9782                	jalr	a5
ffffffffc0203460:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203462:	d4cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203466:	b6b9                	j	ffffffffc0202fb4 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0203468:	6705                	lui	a4,0x1
ffffffffc020346a:	177d                	addi	a4,a4,-1
ffffffffc020346c:	96ba                	add	a3,a3,a4
ffffffffc020346e:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0203470:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203474:	14a77363          	bgeu	a4,a0,ffffffffc02035ba <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0203478:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc020347c:	fff80537          	lui	a0,0xfff80
ffffffffc0203480:	972a                	add	a4,a4,a0
ffffffffc0203482:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0203484:	8c1d                	sub	s0,s0,a5
ffffffffc0203486:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc020348a:	00c45593          	srli	a1,s0,0xc
ffffffffc020348e:	9532                	add	a0,a0,a2
ffffffffc0203490:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0203492:	0009b583          	ld	a1,0(s3)
}
ffffffffc0203496:	b4c1                	j	ffffffffc0202f56 <pmm_init+0x102>
        intr_disable();
ffffffffc0203498:	d1cfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020349c:	000b3783          	ld	a5,0(s6)
ffffffffc02034a0:	779c                	ld	a5,40(a5)
ffffffffc02034a2:	9782                	jalr	a5
ffffffffc02034a4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02034a6:	d08fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034aa:	bb79                	j	ffffffffc0203248 <pmm_init+0x3f4>
        intr_disable();
ffffffffc02034ac:	d08fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02034b0:	000b3783          	ld	a5,0(s6)
ffffffffc02034b4:	779c                	ld	a5,40(a5)
ffffffffc02034b6:	9782                	jalr	a5
ffffffffc02034b8:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02034ba:	cf4fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034be:	b39d                	j	ffffffffc0203224 <pmm_init+0x3d0>
ffffffffc02034c0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02034c2:	cf2fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02034c6:	000b3783          	ld	a5,0(s6)
ffffffffc02034ca:	6522                	ld	a0,8(sp)
ffffffffc02034cc:	4585                	li	a1,1
ffffffffc02034ce:	739c                	ld	a5,32(a5)
ffffffffc02034d0:	9782                	jalr	a5
        intr_enable();
ffffffffc02034d2:	cdcfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034d6:	b33d                	j	ffffffffc0203204 <pmm_init+0x3b0>
ffffffffc02034d8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02034da:	cdafd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02034de:	000b3783          	ld	a5,0(s6)
ffffffffc02034e2:	6522                	ld	a0,8(sp)
ffffffffc02034e4:	4585                	li	a1,1
ffffffffc02034e6:	739c                	ld	a5,32(a5)
ffffffffc02034e8:	9782                	jalr	a5
        intr_enable();
ffffffffc02034ea:	cc4fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034ee:	b1dd                	j	ffffffffc02031d4 <pmm_init+0x380>
        intr_disable();
ffffffffc02034f0:	cc4fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034f4:	000b3783          	ld	a5,0(s6)
ffffffffc02034f8:	4505                	li	a0,1
ffffffffc02034fa:	6f9c                	ld	a5,24(a5)
ffffffffc02034fc:	9782                	jalr	a5
ffffffffc02034fe:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203500:	caefd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203504:	b36d                	j	ffffffffc02032ae <pmm_init+0x45a>
        intr_disable();
ffffffffc0203506:	caefd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020350a:	000b3783          	ld	a5,0(s6)
ffffffffc020350e:	779c                	ld	a5,40(a5)
ffffffffc0203510:	9782                	jalr	a5
ffffffffc0203512:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203514:	c9afd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203518:	bdf9                	j	ffffffffc02033f6 <pmm_init+0x5a2>
ffffffffc020351a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020351c:	c98fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203520:	000b3783          	ld	a5,0(s6)
ffffffffc0203524:	6522                	ld	a0,8(sp)
ffffffffc0203526:	4585                	li	a1,1
ffffffffc0203528:	739c                	ld	a5,32(a5)
ffffffffc020352a:	9782                	jalr	a5
        intr_enable();
ffffffffc020352c:	c82fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203530:	b55d                	j	ffffffffc02033d6 <pmm_init+0x582>
ffffffffc0203532:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203534:	c80fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203538:	000b3783          	ld	a5,0(s6)
ffffffffc020353c:	6522                	ld	a0,8(sp)
ffffffffc020353e:	4585                	li	a1,1
ffffffffc0203540:	739c                	ld	a5,32(a5)
ffffffffc0203542:	9782                	jalr	a5
        intr_enable();
ffffffffc0203544:	c6afd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203548:	bdb9                	j	ffffffffc02033a6 <pmm_init+0x552>
        intr_disable();
ffffffffc020354a:	c6afd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020354e:	000b3783          	ld	a5,0(s6)
ffffffffc0203552:	4585                	li	a1,1
ffffffffc0203554:	8552                	mv	a0,s4
ffffffffc0203556:	739c                	ld	a5,32(a5)
ffffffffc0203558:	9782                	jalr	a5
        intr_enable();
ffffffffc020355a:	c54fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020355e:	bd29                	j	ffffffffc0203378 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203560:	86a2                	mv	a3,s0
ffffffffc0203562:	00004617          	auipc	a2,0x4
ffffffffc0203566:	d7660613          	addi	a2,a2,-650 # ffffffffc02072d8 <commands+0xab0>
ffffffffc020356a:	25000593          	li	a1,592
ffffffffc020356e:	00004517          	auipc	a0,0x4
ffffffffc0203572:	26250513          	addi	a0,a0,610 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203576:	cadfc0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020357a:	00004697          	auipc	a3,0x4
ffffffffc020357e:	6c668693          	addi	a3,a3,1734 # ffffffffc0207c40 <default_pmm_manager+0x4d0>
ffffffffc0203582:	00004617          	auipc	a2,0x4
ffffffffc0203586:	ade60613          	addi	a2,a2,-1314 # ffffffffc0207060 <commands+0x838>
ffffffffc020358a:	25100593          	li	a1,593
ffffffffc020358e:	00004517          	auipc	a0,0x4
ffffffffc0203592:	24250513          	addi	a0,a0,578 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203596:	c8dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020359a:	00004697          	auipc	a3,0x4
ffffffffc020359e:	66668693          	addi	a3,a3,1638 # ffffffffc0207c00 <default_pmm_manager+0x490>
ffffffffc02035a2:	00004617          	auipc	a2,0x4
ffffffffc02035a6:	abe60613          	addi	a2,a2,-1346 # ffffffffc0207060 <commands+0x838>
ffffffffc02035aa:	25000593          	li	a1,592
ffffffffc02035ae:	00004517          	auipc	a0,0x4
ffffffffc02035b2:	22250513          	addi	a0,a0,546 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02035b6:	c6dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc02035ba:	fc5fe0ef          	jal	ra,ffffffffc020257e <pa2page.part.0>
ffffffffc02035be:	fddfe0ef          	jal	ra,ffffffffc020259a <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02035c2:	00004697          	auipc	a3,0x4
ffffffffc02035c6:	43668693          	addi	a3,a3,1078 # ffffffffc02079f8 <default_pmm_manager+0x288>
ffffffffc02035ca:	00004617          	auipc	a2,0x4
ffffffffc02035ce:	a9660613          	addi	a2,a2,-1386 # ffffffffc0207060 <commands+0x838>
ffffffffc02035d2:	22000593          	li	a1,544
ffffffffc02035d6:	00004517          	auipc	a0,0x4
ffffffffc02035da:	1fa50513          	addi	a0,a0,506 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02035de:	c45fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02035e2:	00004697          	auipc	a3,0x4
ffffffffc02035e6:	35668693          	addi	a3,a3,854 # ffffffffc0207938 <default_pmm_manager+0x1c8>
ffffffffc02035ea:	00004617          	auipc	a2,0x4
ffffffffc02035ee:	a7660613          	addi	a2,a2,-1418 # ffffffffc0207060 <commands+0x838>
ffffffffc02035f2:	21300593          	li	a1,531
ffffffffc02035f6:	00004517          	auipc	a0,0x4
ffffffffc02035fa:	1da50513          	addi	a0,a0,474 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02035fe:	c25fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0203602:	00004697          	auipc	a3,0x4
ffffffffc0203606:	2f668693          	addi	a3,a3,758 # ffffffffc02078f8 <default_pmm_manager+0x188>
ffffffffc020360a:	00004617          	auipc	a2,0x4
ffffffffc020360e:	a5660613          	addi	a2,a2,-1450 # ffffffffc0207060 <commands+0x838>
ffffffffc0203612:	21200593          	li	a1,530
ffffffffc0203616:	00004517          	auipc	a0,0x4
ffffffffc020361a:	1ba50513          	addi	a0,a0,442 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc020361e:	c05fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203622:	00004697          	auipc	a3,0x4
ffffffffc0203626:	2b668693          	addi	a3,a3,694 # ffffffffc02078d8 <default_pmm_manager+0x168>
ffffffffc020362a:	00004617          	auipc	a2,0x4
ffffffffc020362e:	a3660613          	addi	a2,a2,-1482 # ffffffffc0207060 <commands+0x838>
ffffffffc0203632:	21100593          	li	a1,529
ffffffffc0203636:	00004517          	auipc	a0,0x4
ffffffffc020363a:	19a50513          	addi	a0,a0,410 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc020363e:	be5fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203642:	00004617          	auipc	a2,0x4
ffffffffc0203646:	c9660613          	addi	a2,a2,-874 # ffffffffc02072d8 <commands+0xab0>
ffffffffc020364a:	07100593          	li	a1,113
ffffffffc020364e:	00004517          	auipc	a0,0x4
ffffffffc0203652:	cb250513          	addi	a0,a0,-846 # ffffffffc0207300 <commands+0xad8>
ffffffffc0203656:	bcdfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc020365a:	00004697          	auipc	a3,0x4
ffffffffc020365e:	52e68693          	addi	a3,a3,1326 # ffffffffc0207b88 <default_pmm_manager+0x418>
ffffffffc0203662:	00004617          	auipc	a2,0x4
ffffffffc0203666:	9fe60613          	addi	a2,a2,-1538 # ffffffffc0207060 <commands+0x838>
ffffffffc020366a:	23900593          	li	a1,569
ffffffffc020366e:	00004517          	auipc	a0,0x4
ffffffffc0203672:	16250513          	addi	a0,a0,354 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203676:	badfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020367a:	00004697          	auipc	a3,0x4
ffffffffc020367e:	4c668693          	addi	a3,a3,1222 # ffffffffc0207b40 <default_pmm_manager+0x3d0>
ffffffffc0203682:	00004617          	auipc	a2,0x4
ffffffffc0203686:	9de60613          	addi	a2,a2,-1570 # ffffffffc0207060 <commands+0x838>
ffffffffc020368a:	23700593          	li	a1,567
ffffffffc020368e:	00004517          	auipc	a0,0x4
ffffffffc0203692:	14250513          	addi	a0,a0,322 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203696:	b8dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc020369a:	00004697          	auipc	a3,0x4
ffffffffc020369e:	4d668693          	addi	a3,a3,1238 # ffffffffc0207b70 <default_pmm_manager+0x400>
ffffffffc02036a2:	00004617          	auipc	a2,0x4
ffffffffc02036a6:	9be60613          	addi	a2,a2,-1602 # ffffffffc0207060 <commands+0x838>
ffffffffc02036aa:	23600593          	li	a1,566
ffffffffc02036ae:	00004517          	auipc	a0,0x4
ffffffffc02036b2:	12250513          	addi	a0,a0,290 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02036b6:	b6dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02036ba:	00004697          	auipc	a3,0x4
ffffffffc02036be:	59e68693          	addi	a3,a3,1438 # ffffffffc0207c58 <default_pmm_manager+0x4e8>
ffffffffc02036c2:	00004617          	auipc	a2,0x4
ffffffffc02036c6:	99e60613          	addi	a2,a2,-1634 # ffffffffc0207060 <commands+0x838>
ffffffffc02036ca:	25400593          	li	a1,596
ffffffffc02036ce:	00004517          	auipc	a0,0x4
ffffffffc02036d2:	10250513          	addi	a0,a0,258 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02036d6:	b4dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02036da:	00004697          	auipc	a3,0x4
ffffffffc02036de:	4de68693          	addi	a3,a3,1246 # ffffffffc0207bb8 <default_pmm_manager+0x448>
ffffffffc02036e2:	00004617          	auipc	a2,0x4
ffffffffc02036e6:	97e60613          	addi	a2,a2,-1666 # ffffffffc0207060 <commands+0x838>
ffffffffc02036ea:	24100593          	li	a1,577
ffffffffc02036ee:	00004517          	auipc	a0,0x4
ffffffffc02036f2:	0e250513          	addi	a0,a0,226 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02036f6:	b2dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02036fa:	00004697          	auipc	a3,0x4
ffffffffc02036fe:	5b668693          	addi	a3,a3,1462 # ffffffffc0207cb0 <default_pmm_manager+0x540>
ffffffffc0203702:	00004617          	auipc	a2,0x4
ffffffffc0203706:	95e60613          	addi	a2,a2,-1698 # ffffffffc0207060 <commands+0x838>
ffffffffc020370a:	25900593          	li	a1,601
ffffffffc020370e:	00004517          	auipc	a0,0x4
ffffffffc0203712:	0c250513          	addi	a0,a0,194 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203716:	b0dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020371a:	00004697          	auipc	a3,0x4
ffffffffc020371e:	55668693          	addi	a3,a3,1366 # ffffffffc0207c70 <default_pmm_manager+0x500>
ffffffffc0203722:	00004617          	auipc	a2,0x4
ffffffffc0203726:	93e60613          	addi	a2,a2,-1730 # ffffffffc0207060 <commands+0x838>
ffffffffc020372a:	25800593          	li	a1,600
ffffffffc020372e:	00004517          	auipc	a0,0x4
ffffffffc0203732:	0a250513          	addi	a0,a0,162 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203736:	aedfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020373a:	00004697          	auipc	a3,0x4
ffffffffc020373e:	40668693          	addi	a3,a3,1030 # ffffffffc0207b40 <default_pmm_manager+0x3d0>
ffffffffc0203742:	00004617          	auipc	a2,0x4
ffffffffc0203746:	91e60613          	addi	a2,a2,-1762 # ffffffffc0207060 <commands+0x838>
ffffffffc020374a:	23300593          	li	a1,563
ffffffffc020374e:	00004517          	auipc	a0,0x4
ffffffffc0203752:	08250513          	addi	a0,a0,130 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203756:	acdfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020375a:	00004697          	auipc	a3,0x4
ffffffffc020375e:	28668693          	addi	a3,a3,646 # ffffffffc02079e0 <default_pmm_manager+0x270>
ffffffffc0203762:	00004617          	auipc	a2,0x4
ffffffffc0203766:	8fe60613          	addi	a2,a2,-1794 # ffffffffc0207060 <commands+0x838>
ffffffffc020376a:	23200593          	li	a1,562
ffffffffc020376e:	00004517          	auipc	a0,0x4
ffffffffc0203772:	06250513          	addi	a0,a0,98 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203776:	aadfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc020377a:	00004697          	auipc	a3,0x4
ffffffffc020377e:	3de68693          	addi	a3,a3,990 # ffffffffc0207b58 <default_pmm_manager+0x3e8>
ffffffffc0203782:	00004617          	auipc	a2,0x4
ffffffffc0203786:	8de60613          	addi	a2,a2,-1826 # ffffffffc0207060 <commands+0x838>
ffffffffc020378a:	22f00593          	li	a1,559
ffffffffc020378e:	00004517          	auipc	a0,0x4
ffffffffc0203792:	04250513          	addi	a0,a0,66 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203796:	a8dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020379a:	00004697          	auipc	a3,0x4
ffffffffc020379e:	22e68693          	addi	a3,a3,558 # ffffffffc02079c8 <default_pmm_manager+0x258>
ffffffffc02037a2:	00004617          	auipc	a2,0x4
ffffffffc02037a6:	8be60613          	addi	a2,a2,-1858 # ffffffffc0207060 <commands+0x838>
ffffffffc02037aa:	22e00593          	li	a1,558
ffffffffc02037ae:	00004517          	auipc	a0,0x4
ffffffffc02037b2:	02250513          	addi	a0,a0,34 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02037b6:	a6dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02037ba:	00004697          	auipc	a3,0x4
ffffffffc02037be:	2ae68693          	addi	a3,a3,686 # ffffffffc0207a68 <default_pmm_manager+0x2f8>
ffffffffc02037c2:	00004617          	auipc	a2,0x4
ffffffffc02037c6:	89e60613          	addi	a2,a2,-1890 # ffffffffc0207060 <commands+0x838>
ffffffffc02037ca:	22d00593          	li	a1,557
ffffffffc02037ce:	00004517          	auipc	a0,0x4
ffffffffc02037d2:	00250513          	addi	a0,a0,2 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02037d6:	a4dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02037da:	00004697          	auipc	a3,0x4
ffffffffc02037de:	36668693          	addi	a3,a3,870 # ffffffffc0207b40 <default_pmm_manager+0x3d0>
ffffffffc02037e2:	00004617          	auipc	a2,0x4
ffffffffc02037e6:	87e60613          	addi	a2,a2,-1922 # ffffffffc0207060 <commands+0x838>
ffffffffc02037ea:	22c00593          	li	a1,556
ffffffffc02037ee:	00004517          	auipc	a0,0x4
ffffffffc02037f2:	fe250513          	addi	a0,a0,-30 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02037f6:	a2dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02037fa:	00004697          	auipc	a3,0x4
ffffffffc02037fe:	32e68693          	addi	a3,a3,814 # ffffffffc0207b28 <default_pmm_manager+0x3b8>
ffffffffc0203802:	00004617          	auipc	a2,0x4
ffffffffc0203806:	85e60613          	addi	a2,a2,-1954 # ffffffffc0207060 <commands+0x838>
ffffffffc020380a:	22b00593          	li	a1,555
ffffffffc020380e:	00004517          	auipc	a0,0x4
ffffffffc0203812:	fc250513          	addi	a0,a0,-62 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203816:	a0dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020381a:	00004697          	auipc	a3,0x4
ffffffffc020381e:	2de68693          	addi	a3,a3,734 # ffffffffc0207af8 <default_pmm_manager+0x388>
ffffffffc0203822:	00004617          	auipc	a2,0x4
ffffffffc0203826:	83e60613          	addi	a2,a2,-1986 # ffffffffc0207060 <commands+0x838>
ffffffffc020382a:	22a00593          	li	a1,554
ffffffffc020382e:	00004517          	auipc	a0,0x4
ffffffffc0203832:	fa250513          	addi	a0,a0,-94 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203836:	9edfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020383a:	00004697          	auipc	a3,0x4
ffffffffc020383e:	2a668693          	addi	a3,a3,678 # ffffffffc0207ae0 <default_pmm_manager+0x370>
ffffffffc0203842:	00004617          	auipc	a2,0x4
ffffffffc0203846:	81e60613          	addi	a2,a2,-2018 # ffffffffc0207060 <commands+0x838>
ffffffffc020384a:	22800593          	li	a1,552
ffffffffc020384e:	00004517          	auipc	a0,0x4
ffffffffc0203852:	f8250513          	addi	a0,a0,-126 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203856:	9cdfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020385a:	00004697          	auipc	a3,0x4
ffffffffc020385e:	26668693          	addi	a3,a3,614 # ffffffffc0207ac0 <default_pmm_manager+0x350>
ffffffffc0203862:	00003617          	auipc	a2,0x3
ffffffffc0203866:	7fe60613          	addi	a2,a2,2046 # ffffffffc0207060 <commands+0x838>
ffffffffc020386a:	22700593          	li	a1,551
ffffffffc020386e:	00004517          	auipc	a0,0x4
ffffffffc0203872:	f6250513          	addi	a0,a0,-158 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203876:	9adfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(*ptep & PTE_W);
ffffffffc020387a:	00004697          	auipc	a3,0x4
ffffffffc020387e:	23668693          	addi	a3,a3,566 # ffffffffc0207ab0 <default_pmm_manager+0x340>
ffffffffc0203882:	00003617          	auipc	a2,0x3
ffffffffc0203886:	7de60613          	addi	a2,a2,2014 # ffffffffc0207060 <commands+0x838>
ffffffffc020388a:	22600593          	li	a1,550
ffffffffc020388e:	00004517          	auipc	a0,0x4
ffffffffc0203892:	f4250513          	addi	a0,a0,-190 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203896:	98dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(*ptep & PTE_U);
ffffffffc020389a:	00004697          	auipc	a3,0x4
ffffffffc020389e:	20668693          	addi	a3,a3,518 # ffffffffc0207aa0 <default_pmm_manager+0x330>
ffffffffc02038a2:	00003617          	auipc	a2,0x3
ffffffffc02038a6:	7be60613          	addi	a2,a2,1982 # ffffffffc0207060 <commands+0x838>
ffffffffc02038aa:	22500593          	li	a1,549
ffffffffc02038ae:	00004517          	auipc	a0,0x4
ffffffffc02038b2:	f2250513          	addi	a0,a0,-222 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02038b6:	96dfc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("DTB memory info not available");
ffffffffc02038ba:	00004617          	auipc	a2,0x4
ffffffffc02038be:	f8660613          	addi	a2,a2,-122 # ffffffffc0207840 <default_pmm_manager+0xd0>
ffffffffc02038c2:	06400593          	li	a1,100
ffffffffc02038c6:	00004517          	auipc	a0,0x4
ffffffffc02038ca:	f0a50513          	addi	a0,a0,-246 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02038ce:	955fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02038d2:	00004697          	auipc	a3,0x4
ffffffffc02038d6:	2e668693          	addi	a3,a3,742 # ffffffffc0207bb8 <default_pmm_manager+0x448>
ffffffffc02038da:	00003617          	auipc	a2,0x3
ffffffffc02038de:	78660613          	addi	a2,a2,1926 # ffffffffc0207060 <commands+0x838>
ffffffffc02038e2:	26b00593          	li	a1,619
ffffffffc02038e6:	00004517          	auipc	a0,0x4
ffffffffc02038ea:	eea50513          	addi	a0,a0,-278 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02038ee:	935fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02038f2:	00004697          	auipc	a3,0x4
ffffffffc02038f6:	17668693          	addi	a3,a3,374 # ffffffffc0207a68 <default_pmm_manager+0x2f8>
ffffffffc02038fa:	00003617          	auipc	a2,0x3
ffffffffc02038fe:	76660613          	addi	a2,a2,1894 # ffffffffc0207060 <commands+0x838>
ffffffffc0203902:	22400593          	li	a1,548
ffffffffc0203906:	00004517          	auipc	a0,0x4
ffffffffc020390a:	eca50513          	addi	a0,a0,-310 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc020390e:	915fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203912:	00004697          	auipc	a3,0x4
ffffffffc0203916:	11668693          	addi	a3,a3,278 # ffffffffc0207a28 <default_pmm_manager+0x2b8>
ffffffffc020391a:	00003617          	auipc	a2,0x3
ffffffffc020391e:	74660613          	addi	a2,a2,1862 # ffffffffc0207060 <commands+0x838>
ffffffffc0203922:	22300593          	li	a1,547
ffffffffc0203926:	00004517          	auipc	a0,0x4
ffffffffc020392a:	eaa50513          	addi	a0,a0,-342 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc020392e:	8f5fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203932:	86d6                	mv	a3,s5
ffffffffc0203934:	00004617          	auipc	a2,0x4
ffffffffc0203938:	9a460613          	addi	a2,a2,-1628 # ffffffffc02072d8 <commands+0xab0>
ffffffffc020393c:	21f00593          	li	a1,543
ffffffffc0203940:	00004517          	auipc	a0,0x4
ffffffffc0203944:	e9050513          	addi	a0,a0,-368 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203948:	8dbfc0ef          	jal	ra,ffffffffc0200222 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020394c:	00004617          	auipc	a2,0x4
ffffffffc0203950:	98c60613          	addi	a2,a2,-1652 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0203954:	21e00593          	li	a1,542
ffffffffc0203958:	00004517          	auipc	a0,0x4
ffffffffc020395c:	e7850513          	addi	a0,a0,-392 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203960:	8c3fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203964:	00004697          	auipc	a3,0x4
ffffffffc0203968:	07c68693          	addi	a3,a3,124 # ffffffffc02079e0 <default_pmm_manager+0x270>
ffffffffc020396c:	00003617          	auipc	a2,0x3
ffffffffc0203970:	6f460613          	addi	a2,a2,1780 # ffffffffc0207060 <commands+0x838>
ffffffffc0203974:	21c00593          	li	a1,540
ffffffffc0203978:	00004517          	auipc	a0,0x4
ffffffffc020397c:	e5850513          	addi	a0,a0,-424 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203980:	8a3fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203984:	00004697          	auipc	a3,0x4
ffffffffc0203988:	04468693          	addi	a3,a3,68 # ffffffffc02079c8 <default_pmm_manager+0x258>
ffffffffc020398c:	00003617          	auipc	a2,0x3
ffffffffc0203990:	6d460613          	addi	a2,a2,1748 # ffffffffc0207060 <commands+0x838>
ffffffffc0203994:	21b00593          	li	a1,539
ffffffffc0203998:	00004517          	auipc	a0,0x4
ffffffffc020399c:	e3850513          	addi	a0,a0,-456 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02039a0:	883fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02039a4:	00004697          	auipc	a3,0x4
ffffffffc02039a8:	3d468693          	addi	a3,a3,980 # ffffffffc0207d78 <default_pmm_manager+0x608>
ffffffffc02039ac:	00003617          	auipc	a2,0x3
ffffffffc02039b0:	6b460613          	addi	a2,a2,1716 # ffffffffc0207060 <commands+0x838>
ffffffffc02039b4:	26200593          	li	a1,610
ffffffffc02039b8:	00004517          	auipc	a0,0x4
ffffffffc02039bc:	e1850513          	addi	a0,a0,-488 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02039c0:	863fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02039c4:	00004697          	auipc	a3,0x4
ffffffffc02039c8:	37c68693          	addi	a3,a3,892 # ffffffffc0207d40 <default_pmm_manager+0x5d0>
ffffffffc02039cc:	00003617          	auipc	a2,0x3
ffffffffc02039d0:	69460613          	addi	a2,a2,1684 # ffffffffc0207060 <commands+0x838>
ffffffffc02039d4:	25f00593          	li	a1,607
ffffffffc02039d8:	00004517          	auipc	a0,0x4
ffffffffc02039dc:	df850513          	addi	a0,a0,-520 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc02039e0:	843fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p) == 2);
ffffffffc02039e4:	00004697          	auipc	a3,0x4
ffffffffc02039e8:	32c68693          	addi	a3,a3,812 # ffffffffc0207d10 <default_pmm_manager+0x5a0>
ffffffffc02039ec:	00003617          	auipc	a2,0x3
ffffffffc02039f0:	67460613          	addi	a2,a2,1652 # ffffffffc0207060 <commands+0x838>
ffffffffc02039f4:	25b00593          	li	a1,603
ffffffffc02039f8:	00004517          	auipc	a0,0x4
ffffffffc02039fc:	dd850513          	addi	a0,a0,-552 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203a00:	823fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203a04:	00004697          	auipc	a3,0x4
ffffffffc0203a08:	2c468693          	addi	a3,a3,708 # ffffffffc0207cc8 <default_pmm_manager+0x558>
ffffffffc0203a0c:	00003617          	auipc	a2,0x3
ffffffffc0203a10:	65460613          	addi	a2,a2,1620 # ffffffffc0207060 <commands+0x838>
ffffffffc0203a14:	25a00593          	li	a1,602
ffffffffc0203a18:	00004517          	auipc	a0,0x4
ffffffffc0203a1c:	db850513          	addi	a0,a0,-584 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203a20:	803fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203a24:	00004617          	auipc	a2,0x4
ffffffffc0203a28:	95c60613          	addi	a2,a2,-1700 # ffffffffc0207380 <commands+0xb58>
ffffffffc0203a2c:	0c800593          	li	a1,200
ffffffffc0203a30:	00004517          	auipc	a0,0x4
ffffffffc0203a34:	da050513          	addi	a0,a0,-608 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203a38:	feafc0ef          	jal	ra,ffffffffc0200222 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203a3c:	00004617          	auipc	a2,0x4
ffffffffc0203a40:	94460613          	addi	a2,a2,-1724 # ffffffffc0207380 <commands+0xb58>
ffffffffc0203a44:	08000593          	li	a1,128
ffffffffc0203a48:	00004517          	auipc	a0,0x4
ffffffffc0203a4c:	d8850513          	addi	a0,a0,-632 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203a50:	fd2fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203a54:	00004697          	auipc	a3,0x4
ffffffffc0203a58:	f4468693          	addi	a3,a3,-188 # ffffffffc0207998 <default_pmm_manager+0x228>
ffffffffc0203a5c:	00003617          	auipc	a2,0x3
ffffffffc0203a60:	60460613          	addi	a2,a2,1540 # ffffffffc0207060 <commands+0x838>
ffffffffc0203a64:	21a00593          	li	a1,538
ffffffffc0203a68:	00004517          	auipc	a0,0x4
ffffffffc0203a6c:	d6850513          	addi	a0,a0,-664 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203a70:	fb2fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203a74:	00004697          	auipc	a3,0x4
ffffffffc0203a78:	ef468693          	addi	a3,a3,-268 # ffffffffc0207968 <default_pmm_manager+0x1f8>
ffffffffc0203a7c:	00003617          	auipc	a2,0x3
ffffffffc0203a80:	5e460613          	addi	a2,a2,1508 # ffffffffc0207060 <commands+0x838>
ffffffffc0203a84:	21700593          	li	a1,535
ffffffffc0203a88:	00004517          	auipc	a0,0x4
ffffffffc0203a8c:	d4850513          	addi	a0,a0,-696 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203a90:	f92fc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203a94 <copy_range>:
{
ffffffffc0203a94:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203a96:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203a9a:	f486                	sd	ra,104(sp)
ffffffffc0203a9c:	f0a2                	sd	s0,96(sp)
ffffffffc0203a9e:	eca6                	sd	s1,88(sp)
ffffffffc0203aa0:	e8ca                	sd	s2,80(sp)
ffffffffc0203aa2:	e4ce                	sd	s3,72(sp)
ffffffffc0203aa4:	e0d2                	sd	s4,64(sp)
ffffffffc0203aa6:	fc56                	sd	s5,56(sp)
ffffffffc0203aa8:	f85a                	sd	s6,48(sp)
ffffffffc0203aaa:	f45e                	sd	s7,40(sp)
ffffffffc0203aac:	f062                	sd	s8,32(sp)
ffffffffc0203aae:	ec66                	sd	s9,24(sp)
ffffffffc0203ab0:	e86a                	sd	s10,16(sp)
ffffffffc0203ab2:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203ab4:	17d2                	slli	a5,a5,0x34
ffffffffc0203ab6:	20079f63          	bnez	a5,ffffffffc0203cd4 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc0203aba:	002007b7          	lui	a5,0x200
ffffffffc0203abe:	8432                	mv	s0,a2
ffffffffc0203ac0:	1af66263          	bltu	a2,a5,ffffffffc0203c64 <copy_range+0x1d0>
ffffffffc0203ac4:	8936                	mv	s2,a3
ffffffffc0203ac6:	18d67f63          	bgeu	a2,a3,ffffffffc0203c64 <copy_range+0x1d0>
ffffffffc0203aca:	4785                	li	a5,1
ffffffffc0203acc:	07fe                	slli	a5,a5,0x1f
ffffffffc0203ace:	18d7eb63          	bltu	a5,a3,ffffffffc0203c64 <copy_range+0x1d0>
ffffffffc0203ad2:	5b7d                	li	s6,-1
ffffffffc0203ad4:	8aaa                	mv	s5,a0
ffffffffc0203ad6:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc0203ad8:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0203ada:	000dcc17          	auipc	s8,0xdc
ffffffffc0203ade:	646c0c13          	addi	s8,s8,1606 # ffffffffc02e0120 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203ae2:	000dcb97          	auipc	s7,0xdc
ffffffffc0203ae6:	646b8b93          	addi	s7,s7,1606 # ffffffffc02e0128 <pages>
    return KADDR(page2pa(page));
ffffffffc0203aea:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc0203aee:	000dcc97          	auipc	s9,0xdc
ffffffffc0203af2:	642c8c93          	addi	s9,s9,1602 # ffffffffc02e0130 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203af6:	4601                	li	a2,0
ffffffffc0203af8:	85a2                	mv	a1,s0
ffffffffc0203afa:	854e                	mv	a0,s3
ffffffffc0203afc:	b73fe0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc0203b00:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0203b02:	0e050c63          	beqz	a0,ffffffffc0203bfa <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc0203b06:	611c                	ld	a5,0(a0)
ffffffffc0203b08:	8b85                	andi	a5,a5,1
ffffffffc0203b0a:	e785                	bnez	a5,ffffffffc0203b32 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc0203b0c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0203b0e:	ff2464e3          	bltu	s0,s2,ffffffffc0203af6 <copy_range+0x62>
    return 0;
ffffffffc0203b12:	4501                	li	a0,0
}
ffffffffc0203b14:	70a6                	ld	ra,104(sp)
ffffffffc0203b16:	7406                	ld	s0,96(sp)
ffffffffc0203b18:	64e6                	ld	s1,88(sp)
ffffffffc0203b1a:	6946                	ld	s2,80(sp)
ffffffffc0203b1c:	69a6                	ld	s3,72(sp)
ffffffffc0203b1e:	6a06                	ld	s4,64(sp)
ffffffffc0203b20:	7ae2                	ld	s5,56(sp)
ffffffffc0203b22:	7b42                	ld	s6,48(sp)
ffffffffc0203b24:	7ba2                	ld	s7,40(sp)
ffffffffc0203b26:	7c02                	ld	s8,32(sp)
ffffffffc0203b28:	6ce2                	ld	s9,24(sp)
ffffffffc0203b2a:	6d42                	ld	s10,16(sp)
ffffffffc0203b2c:	6da2                	ld	s11,8(sp)
ffffffffc0203b2e:	6165                	addi	sp,sp,112
ffffffffc0203b30:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203b32:	4605                	li	a2,1
ffffffffc0203b34:	85a2                	mv	a1,s0
ffffffffc0203b36:	8556                	mv	a0,s5
ffffffffc0203b38:	b37fe0ef          	jal	ra,ffffffffc020266e <get_pte>
ffffffffc0203b3c:	c56d                	beqz	a0,ffffffffc0203c26 <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203b3e:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203b40:	0017f713          	andi	a4,a5,1
ffffffffc0203b44:	01f7f493          	andi	s1,a5,31
ffffffffc0203b48:	16070a63          	beqz	a4,ffffffffc0203cbc <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc0203b4c:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203b50:	078a                	slli	a5,a5,0x2
ffffffffc0203b52:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203b56:	14d77763          	bgeu	a4,a3,ffffffffc0203ca4 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0203b5a:	000bb783          	ld	a5,0(s7)
ffffffffc0203b5e:	fff806b7          	lui	a3,0xfff80
ffffffffc0203b62:	9736                	add	a4,a4,a3
ffffffffc0203b64:	071a                	slli	a4,a4,0x6
ffffffffc0203b66:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203b6a:	10002773          	csrr	a4,sstatus
ffffffffc0203b6e:	8b09                	andi	a4,a4,2
ffffffffc0203b70:	e345                	bnez	a4,ffffffffc0203c10 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203b72:	000cb703          	ld	a4,0(s9)
ffffffffc0203b76:	4505                	li	a0,1
ffffffffc0203b78:	6f18                	ld	a4,24(a4)
ffffffffc0203b7a:	9702                	jalr	a4
ffffffffc0203b7c:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203b7e:	0c0d8363          	beqz	s11,ffffffffc0203c44 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203b82:	100d0163          	beqz	s10,ffffffffc0203c84 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203b86:	000bb703          	ld	a4,0(s7)
ffffffffc0203b8a:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203b8e:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203b92:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203b96:	8699                	srai	a3,a3,0x6
ffffffffc0203b98:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0203b9a:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203b9e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203ba0:	08c7f663          	bgeu	a5,a2,ffffffffc0203c2c <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203ba4:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc0203ba8:	000dc717          	auipc	a4,0xdc
ffffffffc0203bac:	59070713          	addi	a4,a4,1424 # ffffffffc02e0138 <va_pa_offset>
ffffffffc0203bb0:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203bb2:	8799                	srai	a5,a5,0x6
ffffffffc0203bb4:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc0203bb6:	0167f733          	and	a4,a5,s6
ffffffffc0203bba:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203bbe:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203bc0:	06c77563          	bgeu	a4,a2,ffffffffc0203c2a <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203bc4:	6605                	lui	a2,0x1
ffffffffc0203bc6:	953e                	add	a0,a0,a5
ffffffffc0203bc8:	598020ef          	jal	ra,ffffffffc0206160 <memcpy>
            int ret = page_insert(to, npage, start, perm);
ffffffffc0203bcc:	86a6                	mv	a3,s1
ffffffffc0203bce:	8622                	mv	a2,s0
ffffffffc0203bd0:	85ea                	mv	a1,s10
ffffffffc0203bd2:	8556                	mv	a0,s5
ffffffffc0203bd4:	98aff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
            assert(ret == 0);
ffffffffc0203bd8:	d915                	beqz	a0,ffffffffc0203b0c <copy_range+0x78>
ffffffffc0203bda:	00004697          	auipc	a3,0x4
ffffffffc0203bde:	20668693          	addi	a3,a3,518 # ffffffffc0207de0 <default_pmm_manager+0x670>
ffffffffc0203be2:	00003617          	auipc	a2,0x3
ffffffffc0203be6:	47e60613          	addi	a2,a2,1150 # ffffffffc0207060 <commands+0x838>
ffffffffc0203bea:	1af00593          	li	a1,431
ffffffffc0203bee:	00004517          	auipc	a0,0x4
ffffffffc0203bf2:	be250513          	addi	a0,a0,-1054 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203bf6:	e2cfc0ef          	jal	ra,ffffffffc0200222 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203bfa:	00200637          	lui	a2,0x200
ffffffffc0203bfe:	9432                	add	s0,s0,a2
ffffffffc0203c00:	ffe00637          	lui	a2,0xffe00
ffffffffc0203c04:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc0203c06:	f00406e3          	beqz	s0,ffffffffc0203b12 <copy_range+0x7e>
ffffffffc0203c0a:	ef2466e3          	bltu	s0,s2,ffffffffc0203af6 <copy_range+0x62>
ffffffffc0203c0e:	b711                	j	ffffffffc0203b12 <copy_range+0x7e>
        intr_disable();
ffffffffc0203c10:	da5fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203c14:	000cb703          	ld	a4,0(s9)
ffffffffc0203c18:	4505                	li	a0,1
ffffffffc0203c1a:	6f18                	ld	a4,24(a4)
ffffffffc0203c1c:	9702                	jalr	a4
ffffffffc0203c1e:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc0203c20:	d8ffc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203c24:	bfa9                	j	ffffffffc0203b7e <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0203c26:	5571                	li	a0,-4
ffffffffc0203c28:	b5f5                	j	ffffffffc0203b14 <copy_range+0x80>
ffffffffc0203c2a:	86be                	mv	a3,a5
ffffffffc0203c2c:	00003617          	auipc	a2,0x3
ffffffffc0203c30:	6ac60613          	addi	a2,a2,1708 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0203c34:	07100593          	li	a1,113
ffffffffc0203c38:	00003517          	auipc	a0,0x3
ffffffffc0203c3c:	6c850513          	addi	a0,a0,1736 # ffffffffc0207300 <commands+0xad8>
ffffffffc0203c40:	de2fc0ef          	jal	ra,ffffffffc0200222 <__panic>
            assert(page != NULL);
ffffffffc0203c44:	00004697          	auipc	a3,0x4
ffffffffc0203c48:	17c68693          	addi	a3,a3,380 # ffffffffc0207dc0 <default_pmm_manager+0x650>
ffffffffc0203c4c:	00003617          	auipc	a2,0x3
ffffffffc0203c50:	41460613          	addi	a2,a2,1044 # ffffffffc0207060 <commands+0x838>
ffffffffc0203c54:	19500593          	li	a1,405
ffffffffc0203c58:	00004517          	auipc	a0,0x4
ffffffffc0203c5c:	b7850513          	addi	a0,a0,-1160 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203c60:	dc2fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203c64:	00004697          	auipc	a3,0x4
ffffffffc0203c68:	bac68693          	addi	a3,a3,-1108 # ffffffffc0207810 <default_pmm_manager+0xa0>
ffffffffc0203c6c:	00003617          	auipc	a2,0x3
ffffffffc0203c70:	3f460613          	addi	a2,a2,1012 # ffffffffc0207060 <commands+0x838>
ffffffffc0203c74:	17d00593          	li	a1,381
ffffffffc0203c78:	00004517          	auipc	a0,0x4
ffffffffc0203c7c:	b5850513          	addi	a0,a0,-1192 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203c80:	da2fc0ef          	jal	ra,ffffffffc0200222 <__panic>
            assert(npage != NULL);
ffffffffc0203c84:	00004697          	auipc	a3,0x4
ffffffffc0203c88:	14c68693          	addi	a3,a3,332 # ffffffffc0207dd0 <default_pmm_manager+0x660>
ffffffffc0203c8c:	00003617          	auipc	a2,0x3
ffffffffc0203c90:	3d460613          	addi	a2,a2,980 # ffffffffc0207060 <commands+0x838>
ffffffffc0203c94:	19600593          	li	a1,406
ffffffffc0203c98:	00004517          	auipc	a0,0x4
ffffffffc0203c9c:	b3850513          	addi	a0,a0,-1224 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203ca0:	d82fc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203ca4:	00003617          	auipc	a2,0x3
ffffffffc0203ca8:	70460613          	addi	a2,a2,1796 # ffffffffc02073a8 <commands+0xb80>
ffffffffc0203cac:	06900593          	li	a1,105
ffffffffc0203cb0:	00003517          	auipc	a0,0x3
ffffffffc0203cb4:	65050513          	addi	a0,a0,1616 # ffffffffc0207300 <commands+0xad8>
ffffffffc0203cb8:	d6afc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203cbc:	00004617          	auipc	a2,0x4
ffffffffc0203cc0:	aec60613          	addi	a2,a2,-1300 # ffffffffc02077a8 <default_pmm_manager+0x38>
ffffffffc0203cc4:	07f00593          	li	a1,127
ffffffffc0203cc8:	00003517          	auipc	a0,0x3
ffffffffc0203ccc:	63850513          	addi	a0,a0,1592 # ffffffffc0207300 <commands+0xad8>
ffffffffc0203cd0:	d52fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203cd4:	00004697          	auipc	a3,0x4
ffffffffc0203cd8:	b0c68693          	addi	a3,a3,-1268 # ffffffffc02077e0 <default_pmm_manager+0x70>
ffffffffc0203cdc:	00003617          	auipc	a2,0x3
ffffffffc0203ce0:	38460613          	addi	a2,a2,900 # ffffffffc0207060 <commands+0x838>
ffffffffc0203ce4:	17c00593          	li	a1,380
ffffffffc0203ce8:	00004517          	auipc	a0,0x4
ffffffffc0203cec:	ae850513          	addi	a0,a0,-1304 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203cf0:	d32fc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203cf4 <pgdir_alloc_page>:
{
ffffffffc0203cf4:	7179                	addi	sp,sp,-48
ffffffffc0203cf6:	ec26                	sd	s1,24(sp)
ffffffffc0203cf8:	e84a                	sd	s2,16(sp)
ffffffffc0203cfa:	e052                	sd	s4,0(sp)
ffffffffc0203cfc:	f406                	sd	ra,40(sp)
ffffffffc0203cfe:	f022                	sd	s0,32(sp)
ffffffffc0203d00:	e44e                	sd	s3,8(sp)
ffffffffc0203d02:	8a2a                	mv	s4,a0
ffffffffc0203d04:	84ae                	mv	s1,a1
ffffffffc0203d06:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203d08:	100027f3          	csrr	a5,sstatus
ffffffffc0203d0c:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203d0e:	000dc997          	auipc	s3,0xdc
ffffffffc0203d12:	42298993          	addi	s3,s3,1058 # ffffffffc02e0130 <pmm_manager>
ffffffffc0203d16:	ef8d                	bnez	a5,ffffffffc0203d50 <pgdir_alloc_page+0x5c>
ffffffffc0203d18:	0009b783          	ld	a5,0(s3)
ffffffffc0203d1c:	4505                	li	a0,1
ffffffffc0203d1e:	6f9c                	ld	a5,24(a5)
ffffffffc0203d20:	9782                	jalr	a5
ffffffffc0203d22:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203d24:	cc09                	beqz	s0,ffffffffc0203d3e <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203d26:	86ca                	mv	a3,s2
ffffffffc0203d28:	8626                	mv	a2,s1
ffffffffc0203d2a:	85a2                	mv	a1,s0
ffffffffc0203d2c:	8552                	mv	a0,s4
ffffffffc0203d2e:	830ff0ef          	jal	ra,ffffffffc0202d5e <page_insert>
ffffffffc0203d32:	e915                	bnez	a0,ffffffffc0203d66 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203d34:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203d36:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203d38:	4785                	li	a5,1
ffffffffc0203d3a:	04f71e63          	bne	a4,a5,ffffffffc0203d96 <pgdir_alloc_page+0xa2>
}
ffffffffc0203d3e:	70a2                	ld	ra,40(sp)
ffffffffc0203d40:	8522                	mv	a0,s0
ffffffffc0203d42:	7402                	ld	s0,32(sp)
ffffffffc0203d44:	64e2                	ld	s1,24(sp)
ffffffffc0203d46:	6942                	ld	s2,16(sp)
ffffffffc0203d48:	69a2                	ld	s3,8(sp)
ffffffffc0203d4a:	6a02                	ld	s4,0(sp)
ffffffffc0203d4c:	6145                	addi	sp,sp,48
ffffffffc0203d4e:	8082                	ret
        intr_disable();
ffffffffc0203d50:	c65fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203d54:	0009b783          	ld	a5,0(s3)
ffffffffc0203d58:	4505                	li	a0,1
ffffffffc0203d5a:	6f9c                	ld	a5,24(a5)
ffffffffc0203d5c:	9782                	jalr	a5
ffffffffc0203d5e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203d60:	c4ffc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203d64:	b7c1                	j	ffffffffc0203d24 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203d66:	100027f3          	csrr	a5,sstatus
ffffffffc0203d6a:	8b89                	andi	a5,a5,2
ffffffffc0203d6c:	eb89                	bnez	a5,ffffffffc0203d7e <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203d6e:	0009b783          	ld	a5,0(s3)
ffffffffc0203d72:	8522                	mv	a0,s0
ffffffffc0203d74:	4585                	li	a1,1
ffffffffc0203d76:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203d78:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203d7a:	9782                	jalr	a5
    if (flag) {
ffffffffc0203d7c:	b7c9                	j	ffffffffc0203d3e <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203d7e:	c37fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203d82:	0009b783          	ld	a5,0(s3)
ffffffffc0203d86:	8522                	mv	a0,s0
ffffffffc0203d88:	4585                	li	a1,1
ffffffffc0203d8a:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203d8c:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203d8e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203d90:	c1ffc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203d94:	b76d                	j	ffffffffc0203d3e <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203d96:	00004697          	auipc	a3,0x4
ffffffffc0203d9a:	05a68693          	addi	a3,a3,90 # ffffffffc0207df0 <default_pmm_manager+0x680>
ffffffffc0203d9e:	00003617          	auipc	a2,0x3
ffffffffc0203da2:	2c260613          	addi	a2,a2,706 # ffffffffc0207060 <commands+0x838>
ffffffffc0203da6:	1f800593          	li	a1,504
ffffffffc0203daa:	00004517          	auipc	a0,0x4
ffffffffc0203dae:	a2650513          	addi	a0,a0,-1498 # ffffffffc02077d0 <default_pmm_manager+0x60>
ffffffffc0203db2:	c70fc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203db6 <phi_test_sema>:

struct proc_struct *philosopher_proc_sema[N];

void phi_test_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
ffffffffc0203db6:	000d8697          	auipc	a3,0xd8
ffffffffc0203dba:	2da68693          	addi	a3,a3,730 # ffffffffc02dc090 <state_sema>
ffffffffc0203dbe:	00251793          	slli	a5,a0,0x2
ffffffffc0203dc2:	97b6                	add	a5,a5,a3
ffffffffc0203dc4:	4390                	lw	a2,0(a5)
ffffffffc0203dc6:	4705                	li	a4,1
ffffffffc0203dc8:	00e60363          	beq	a2,a4,ffffffffc0203dce <phi_test_sema+0x18>
            &&state_sema[RIGHT]!=EATING)
    {
        state_sema[i]=EATING;
        up(&s[i]);
    }
}
ffffffffc0203dcc:	8082                	ret
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
ffffffffc0203dce:	0045071b          	addiw	a4,a0,4
ffffffffc0203dd2:	4595                	li	a1,5
ffffffffc0203dd4:	02b7673b          	remw	a4,a4,a1
ffffffffc0203dd8:	4609                	li	a2,2
ffffffffc0203dda:	070a                	slli	a4,a4,0x2
ffffffffc0203ddc:	9736                	add	a4,a4,a3
ffffffffc0203dde:	4318                	lw	a4,0(a4)
ffffffffc0203de0:	fec706e3          	beq	a4,a2,ffffffffc0203dcc <phi_test_sema+0x16>
            &&state_sema[RIGHT]!=EATING)
ffffffffc0203de4:	0015071b          	addiw	a4,a0,1
ffffffffc0203de8:	02b7673b          	remw	a4,a4,a1
ffffffffc0203dec:	070a                	slli	a4,a4,0x2
ffffffffc0203dee:	96ba                	add	a3,a3,a4
ffffffffc0203df0:	4298                	lw	a4,0(a3)
ffffffffc0203df2:	fcc70de3          	beq	a4,a2,ffffffffc0203dcc <phi_test_sema+0x16>
        up(&s[i]);
ffffffffc0203df6:	00151713          	slli	a4,a0,0x1
ffffffffc0203dfa:	953a                	add	a0,a0,a4
ffffffffc0203dfc:	050e                	slli	a0,a0,0x3
ffffffffc0203dfe:	000d8717          	auipc	a4,0xd8
ffffffffc0203e02:	20270713          	addi	a4,a4,514 # ffffffffc02dc000 <s>
ffffffffc0203e06:	953a                	add	a0,a0,a4
        state_sema[i]=EATING;
ffffffffc0203e08:	c390                	sw	a2,0(a5)
        up(&s[i]);
ffffffffc0203e0a:	6ea0006f          	j	ffffffffc02044f4 <up>

ffffffffc0203e0e <philosopher_using_semaphore>:
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
        up(&mutex); /* 离开临界区 */
}

int philosopher_using_semaphore(void * arg) /* i：哲学家号码，从0到N-1 */
{
ffffffffc0203e0e:	711d                	addi	sp,sp,-96
ffffffffc0203e10:	e8a2                	sd	s0,80(sp)
    int i, iter=0;
    i=(int)arg;
ffffffffc0203e12:	0005041b          	sext.w	s0,a0
    cprintf("I am No.%d philosopher_sema\n",i);
ffffffffc0203e16:	85a2                	mv	a1,s0
ffffffffc0203e18:	00004517          	auipc	a0,0x4
ffffffffc0203e1c:	ff050513          	addi	a0,a0,-16 # ffffffffc0207e08 <default_pmm_manager+0x698>
{
ffffffffc0203e20:	e4a6                	sd	s1,72(sp)
ffffffffc0203e22:	e0ca                	sd	s2,64(sp)
ffffffffc0203e24:	fc4e                	sd	s3,56(sp)
ffffffffc0203e26:	f852                	sd	s4,48(sp)
ffffffffc0203e28:	f456                	sd	s5,40(sp)
ffffffffc0203e2a:	f05a                	sd	s6,32(sp)
ffffffffc0203e2c:	ec5e                	sd	s7,24(sp)
ffffffffc0203e2e:	e862                	sd	s8,16(sp)
ffffffffc0203e30:	e466                	sd	s9,8(sp)
ffffffffc0203e32:	e06a                	sd	s10,0(sp)
ffffffffc0203e34:	ec86                	sd	ra,88(sp)
    cprintf("I am No.%d philosopher_sema\n",i);
ffffffffc0203e36:	aaefc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203e3a:	4715                	li	a4,5
ffffffffc0203e3c:	00440b1b          	addiw	s6,s0,4
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203e40:	00140a1b          	addiw	s4,s0,1
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203e44:	02eb6b3b          	remw	s6,s6,a4
        down(&s[i]); /* 如果得不到叉子就阻塞 */
ffffffffc0203e48:	00141a93          	slli	s5,s0,0x1
ffffffffc0203e4c:	9aa2                	add	s5,s5,s0
ffffffffc0203e4e:	003a9793          	slli	a5,s5,0x3
ffffffffc0203e52:	00241693          	slli	a3,s0,0x2
ffffffffc0203e56:	000d8a97          	auipc	s5,0xd8
ffffffffc0203e5a:	1aaa8a93          	addi	s5,s5,426 # ffffffffc02dc000 <s>
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
ffffffffc0203e5e:	000d8997          	auipc	s3,0xd8
ffffffffc0203e62:	23298993          	addi	s3,s3,562 # ffffffffc02dc090 <state_sema>
        down(&s[i]); /* 如果得不到叉子就阻塞 */
ffffffffc0203e66:	9abe                	add	s5,s5,a5
    while(iter++<TIMES)
ffffffffc0203e68:	4485                	li	s1,1
    { /* 无限循环 */
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 哲学家正在思考 */
ffffffffc0203e6a:	00004d17          	auipc	s10,0x4
ffffffffc0203e6e:	fbed0d13          	addi	s10,s10,-66 # ffffffffc0207e28 <default_pmm_manager+0x6b8>
        down(&mutex); /* 进入临界区 */
ffffffffc0203e72:	000d8917          	auipc	s2,0xd8
ffffffffc0203e76:	12690913          	addi	s2,s2,294 # ffffffffc02dbf98 <mutex>
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
ffffffffc0203e7a:	99b6                	add	s3,s3,a3
ffffffffc0203e7c:	4c85                	li	s9,1
        do_sleep(SLEEP_TIME);
        phi_take_forks_sema(i); 
        /* 需要两只叉子，或者阻塞 */
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 进餐 */
ffffffffc0203e7e:	00004c17          	auipc	s8,0x4
ffffffffc0203e82:	fdac0c13          	addi	s8,s8,-38 # ffffffffc0207e58 <default_pmm_manager+0x6e8>
    while(iter++<TIMES)
ffffffffc0203e86:	4b95                	li	s7,5
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203e88:	02ea6a3b          	remw	s4,s4,a4
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 哲学家正在思考 */
ffffffffc0203e8c:	85a6                	mv	a1,s1
ffffffffc0203e8e:	8622                	mv	a2,s0
ffffffffc0203e90:	856a                	mv	a0,s10
ffffffffc0203e92:	a52fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc0203e96:	4529                	li	a0,10
ffffffffc0203e98:	353010ef          	jal	ra,ffffffffc02059ea <do_sleep>
        down(&mutex); /* 进入临界区 */
ffffffffc0203e9c:	854a                	mv	a0,s2
ffffffffc0203e9e:	65a000ef          	jal	ra,ffffffffc02044f8 <down>
        phi_test_sema(i); /* 试图得到两只叉子 */
ffffffffc0203ea2:	8522                	mv	a0,s0
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
ffffffffc0203ea4:	0199a023          	sw	s9,0(s3)
        phi_test_sema(i); /* 试图得到两只叉子 */
ffffffffc0203ea8:	f0fff0ef          	jal	ra,ffffffffc0203db6 <phi_test_sema>
        up(&mutex); /* 离开临界区 */
ffffffffc0203eac:	854a                	mv	a0,s2
ffffffffc0203eae:	646000ef          	jal	ra,ffffffffc02044f4 <up>
        down(&s[i]); /* 如果得不到叉子就阻塞 */
ffffffffc0203eb2:	8556                	mv	a0,s5
ffffffffc0203eb4:	644000ef          	jal	ra,ffffffffc02044f8 <down>
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 进餐 */
ffffffffc0203eb8:	85a6                	mv	a1,s1
ffffffffc0203eba:	8622                	mv	a2,s0
ffffffffc0203ebc:	8562                	mv	a0,s8
ffffffffc0203ebe:	a26fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc0203ec2:	4529                	li	a0,10
ffffffffc0203ec4:	327010ef          	jal	ra,ffffffffc02059ea <do_sleep>
        down(&mutex); /* 进入临界区 */
ffffffffc0203ec8:	854a                	mv	a0,s2
ffffffffc0203eca:	62e000ef          	jal	ra,ffffffffc02044f8 <down>
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203ece:	855a                	mv	a0,s6
        state_sema[i]=THINKING; /* 哲学家进餐结束 */
ffffffffc0203ed0:	0009a023          	sw	zero,0(s3)
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
ffffffffc0203ed4:	ee3ff0ef          	jal	ra,ffffffffc0203db6 <phi_test_sema>
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
ffffffffc0203ed8:	8552                	mv	a0,s4
ffffffffc0203eda:	eddff0ef          	jal	ra,ffffffffc0203db6 <phi_test_sema>
    while(iter++<TIMES)
ffffffffc0203ede:	2485                	addiw	s1,s1,1
        up(&mutex); /* 离开临界区 */
ffffffffc0203ee0:	854a                	mv	a0,s2
ffffffffc0203ee2:	612000ef          	jal	ra,ffffffffc02044f4 <up>
    while(iter++<TIMES)
ffffffffc0203ee6:	fb7493e3          	bne	s1,s7,ffffffffc0203e8c <philosopher_using_semaphore+0x7e>
        phi_put_forks_sema(i); 
        /* 把两把叉子同时放回桌子 */
    }
    cprintf("No.%d philosopher_sema quit\n",i);
ffffffffc0203eea:	85a2                	mv	a1,s0
ffffffffc0203eec:	00004517          	auipc	a0,0x4
ffffffffc0203ef0:	f9c50513          	addi	a0,a0,-100 # ffffffffc0207e88 <default_pmm_manager+0x718>
ffffffffc0203ef4:	9f0fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return 0;    
}
ffffffffc0203ef8:	60e6                	ld	ra,88(sp)
ffffffffc0203efa:	6446                	ld	s0,80(sp)
ffffffffc0203efc:	64a6                	ld	s1,72(sp)
ffffffffc0203efe:	6906                	ld	s2,64(sp)
ffffffffc0203f00:	79e2                	ld	s3,56(sp)
ffffffffc0203f02:	7a42                	ld	s4,48(sp)
ffffffffc0203f04:	7aa2                	ld	s5,40(sp)
ffffffffc0203f06:	7b02                	ld	s6,32(sp)
ffffffffc0203f08:	6be2                	ld	s7,24(sp)
ffffffffc0203f0a:	6c42                	ld	s8,16(sp)
ffffffffc0203f0c:	6ca2                	ld	s9,8(sp)
ffffffffc0203f0e:	6d02                	ld	s10,0(sp)
ffffffffc0203f10:	4501                	li	a0,0
ffffffffc0203f12:	6125                	addi	sp,sp,96
ffffffffc0203f14:	8082                	ret

ffffffffc0203f16 <phi_test_condvar>:

struct proc_struct *philosopher_proc_condvar[N]; // N philosopher
int state_condvar[N];                            // the philosopher's state: EATING, HUNGARY, THINKING  
monitor_t mt, *mtp=&mt;                          // monitor

void phi_test_condvar (int i) { 
ffffffffc0203f16:	7179                	addi	sp,sp,-48
ffffffffc0203f18:	ec26                	sd	s1,24(sp)
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
ffffffffc0203f1a:	000d8717          	auipc	a4,0xd8
ffffffffc0203f1e:	15e70713          	addi	a4,a4,350 # ffffffffc02dc078 <state_condvar>
ffffffffc0203f22:	00251493          	slli	s1,a0,0x2
void phi_test_condvar (int i) { 
ffffffffc0203f26:	e84a                	sd	s2,16(sp)
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
ffffffffc0203f28:	00970933          	add	s2,a4,s1
ffffffffc0203f2c:	00092683          	lw	a3,0(s2)
void phi_test_condvar (int i) { 
ffffffffc0203f30:	f406                	sd	ra,40(sp)
ffffffffc0203f32:	f022                	sd	s0,32(sp)
ffffffffc0203f34:	e44e                	sd	s3,8(sp)
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
ffffffffc0203f36:	4785                	li	a5,1
ffffffffc0203f38:	00f68963          	beq	a3,a5,ffffffffc0203f4a <phi_test_condvar+0x34>
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
        state_condvar[i] = EATING ;
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
        cond_signal(&mtp->cv[i]) ;
    }
}
ffffffffc0203f3c:	70a2                	ld	ra,40(sp)
ffffffffc0203f3e:	7402                	ld	s0,32(sp)
ffffffffc0203f40:	64e2                	ld	s1,24(sp)
ffffffffc0203f42:	6942                	ld	s2,16(sp)
ffffffffc0203f44:	69a2                	ld	s3,8(sp)
ffffffffc0203f46:	6145                	addi	sp,sp,48
ffffffffc0203f48:	8082                	ret
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
ffffffffc0203f4a:	0045079b          	addiw	a5,a0,4
ffffffffc0203f4e:	4695                	li	a3,5
ffffffffc0203f50:	02d7e7bb          	remw	a5,a5,a3
ffffffffc0203f54:	4989                	li	s3,2
ffffffffc0203f56:	842a                	mv	s0,a0
ffffffffc0203f58:	078a                	slli	a5,a5,0x2
ffffffffc0203f5a:	97ba                	add	a5,a5,a4
ffffffffc0203f5c:	439c                	lw	a5,0(a5)
ffffffffc0203f5e:	fd378fe3          	beq	a5,s3,ffffffffc0203f3c <phi_test_condvar+0x26>
            &&state_condvar[RIGHT]!=EATING) {
ffffffffc0203f62:	0015079b          	addiw	a5,a0,1
ffffffffc0203f66:	02d7e7bb          	remw	a5,a5,a3
ffffffffc0203f6a:	078a                	slli	a5,a5,0x2
ffffffffc0203f6c:	973e                	add	a4,a4,a5
ffffffffc0203f6e:	431c                	lw	a5,0(a4)
ffffffffc0203f70:	fd3786e3          	beq	a5,s3,ffffffffc0203f3c <phi_test_condvar+0x26>
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
ffffffffc0203f74:	85aa                	mv	a1,a0
ffffffffc0203f76:	00004517          	auipc	a0,0x4
ffffffffc0203f7a:	f3250513          	addi	a0,a0,-206 # ffffffffc0207ea8 <default_pmm_manager+0x738>
ffffffffc0203f7e:	966fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
ffffffffc0203f82:	85a2                	mv	a1,s0
        state_condvar[i] = EATING ;
ffffffffc0203f84:	01392023          	sw	s3,0(s2)
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
ffffffffc0203f88:	00004517          	auipc	a0,0x4
ffffffffc0203f8c:	f5850513          	addi	a0,a0,-168 # ffffffffc0207ee0 <default_pmm_manager+0x770>
ffffffffc0203f90:	954fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cond_signal(&mtp->cv[i]) ;
ffffffffc0203f94:	000d8797          	auipc	a5,0xd8
ffffffffc0203f98:	b9c7b783          	ld	a5,-1124(a5) # ffffffffc02dbb30 <mtp>
ffffffffc0203f9c:	7f88                	ld	a0,56(a5)
ffffffffc0203f9e:	9426                	add	s0,s0,s1
ffffffffc0203fa0:	040e                	slli	s0,s0,0x3
ffffffffc0203fa2:	9522                	add	a0,a0,s0
}
ffffffffc0203fa4:	7402                	ld	s0,32(sp)
ffffffffc0203fa6:	70a2                	ld	ra,40(sp)
ffffffffc0203fa8:	64e2                	ld	s1,24(sp)
ffffffffc0203faa:	6942                	ld	s2,16(sp)
ffffffffc0203fac:	69a2                	ld	s3,8(sp)
ffffffffc0203fae:	6145                	addi	sp,sp,48
        cond_signal(&mtp->cv[i]) ;
ffffffffc0203fb0:	a535                	j	ffffffffc02045dc <cond_signal>

ffffffffc0203fb2 <phi_take_forks_condvar>:


void phi_take_forks_condvar(int i) {
ffffffffc0203fb2:	7179                	addi	sp,sp,-48
ffffffffc0203fb4:	e84a                	sd	s2,16(sp)
     down(&(mtp->mutex));
ffffffffc0203fb6:	000d8917          	auipc	s2,0xd8
ffffffffc0203fba:	b7a90913          	addi	s2,s2,-1158 # ffffffffc02dbb30 <mtp>
void phi_take_forks_condvar(int i) {
ffffffffc0203fbe:	e44e                	sd	s3,8(sp)
ffffffffc0203fc0:	89aa                	mv	s3,a0
     down(&(mtp->mutex));
ffffffffc0203fc2:	00093503          	ld	a0,0(s2)
void phi_take_forks_condvar(int i) {
ffffffffc0203fc6:	f406                	sd	ra,40(sp)
ffffffffc0203fc8:	f022                	sd	s0,32(sp)
ffffffffc0203fca:	ec26                	sd	s1,24(sp)
//--------into routine in monitor--------------
     // LAB7 EXERCISE1: YOUR CODE
     // I am hungry
     // try to get fork
    state_condvar[i] = HUNGRY;
ffffffffc0203fcc:	00299413          	slli	s0,s3,0x2
     down(&(mtp->mutex));
ffffffffc0203fd0:	528000ef          	jal	ra,ffffffffc02044f8 <down>
    state_condvar[i] = HUNGRY;
ffffffffc0203fd4:	000d8497          	auipc	s1,0xd8
ffffffffc0203fd8:	0a448493          	addi	s1,s1,164 # ffffffffc02dc078 <state_condvar>
ffffffffc0203fdc:	4785                	li	a5,1
ffffffffc0203fde:	94a2                	add	s1,s1,s0
ffffffffc0203fe0:	c09c                	sw	a5,0(s1)
    phi_test_condvar(i);
ffffffffc0203fe2:	854e                	mv	a0,s3
ffffffffc0203fe4:	f33ff0ef          	jal	ra,ffffffffc0203f16 <phi_test_condvar>
    while(state_condvar[i] != EATING) {
ffffffffc0203fe8:	4098                	lw	a4,0(s1)
ffffffffc0203fea:	4789                	li	a5,2
ffffffffc0203fec:	00f70e63          	beq	a4,a5,ffffffffc0204008 <phi_take_forks_condvar+0x56>
        cond_wait(&mtp->cv[i]);
ffffffffc0203ff0:	944e                	add	s0,s0,s3
ffffffffc0203ff2:	040e                	slli	s0,s0,0x3
    while(state_condvar[i] != EATING) {
ffffffffc0203ff4:	4989                	li	s3,2
        cond_wait(&mtp->cv[i]);
ffffffffc0203ff6:	00093783          	ld	a5,0(s2)
ffffffffc0203ffa:	7f88                	ld	a0,56(a5)
ffffffffc0203ffc:	9522                	add	a0,a0,s0
ffffffffc0203ffe:	64e000ef          	jal	ra,ffffffffc020464c <cond_wait>
    while(state_condvar[i] != EATING) {
ffffffffc0204002:	409c                	lw	a5,0(s1)
ffffffffc0204004:	ff3799e3          	bne	a5,s3,ffffffffc0203ff6 <phi_take_forks_condvar+0x44>
    }
//--------leave routine in monitor--------------
      if(mtp->next_count>0)
ffffffffc0204008:	00093503          	ld	a0,0(s2)
ffffffffc020400c:	591c                	lw	a5,48(a0)
ffffffffc020400e:	00f05363          	blez	a5,ffffffffc0204014 <phi_take_forks_condvar+0x62>
         up(&(mtp->next));
ffffffffc0204012:	0561                	addi	a0,a0,24
      else
         up(&(mtp->mutex));
}
ffffffffc0204014:	7402                	ld	s0,32(sp)
ffffffffc0204016:	70a2                	ld	ra,40(sp)
ffffffffc0204018:	64e2                	ld	s1,24(sp)
ffffffffc020401a:	6942                	ld	s2,16(sp)
ffffffffc020401c:	69a2                	ld	s3,8(sp)
ffffffffc020401e:	6145                	addi	sp,sp,48
         up(&(mtp->mutex));
ffffffffc0204020:	a9d1                	j	ffffffffc02044f4 <up>

ffffffffc0204022 <phi_put_forks_condvar>:

void phi_put_forks_condvar(int i) {
ffffffffc0204022:	1101                	addi	sp,sp,-32
ffffffffc0204024:	e426                	sd	s1,8(sp)
     down(&(mtp->mutex));
ffffffffc0204026:	000d8497          	auipc	s1,0xd8
ffffffffc020402a:	b0a48493          	addi	s1,s1,-1270 # ffffffffc02dbb30 <mtp>
void phi_put_forks_condvar(int i) {
ffffffffc020402e:	e822                	sd	s0,16(sp)
ffffffffc0204030:	842a                	mv	s0,a0
     down(&(mtp->mutex));
ffffffffc0204032:	6088                	ld	a0,0(s1)
void phi_put_forks_condvar(int i) {
ffffffffc0204034:	ec06                	sd	ra,24(sp)
ffffffffc0204036:	e04a                	sd	s2,0(sp)
     down(&(mtp->mutex));
ffffffffc0204038:	4c0000ef          	jal	ra,ffffffffc02044f8 <down>
//--------into routine in monitor--------------
     // LAB7 EXERCISE1: YOUR CODE
     // I ate over
     // test left and right neighbors
    state_condvar[i] = THINKING;
    phi_test_condvar(LEFT);
ffffffffc020403c:	4915                	li	s2,5
ffffffffc020403e:	0044051b          	addiw	a0,s0,4
ffffffffc0204042:	0325653b          	remw	a0,a0,s2
    state_condvar[i] = THINKING;
ffffffffc0204046:	00241713          	slli	a4,s0,0x2
ffffffffc020404a:	000d8797          	auipc	a5,0xd8
ffffffffc020404e:	02e78793          	addi	a5,a5,46 # ffffffffc02dc078 <state_condvar>
ffffffffc0204052:	97ba                	add	a5,a5,a4
ffffffffc0204054:	0007a023          	sw	zero,0(a5)
    phi_test_condvar(LEFT);
ffffffffc0204058:	ebfff0ef          	jal	ra,ffffffffc0203f16 <phi_test_condvar>
    phi_test_condvar(RIGHT);
ffffffffc020405c:	0014051b          	addiw	a0,s0,1
ffffffffc0204060:	0325653b          	remw	a0,a0,s2
ffffffffc0204064:	eb3ff0ef          	jal	ra,ffffffffc0203f16 <phi_test_condvar>
//--------leave routine in monitor--------------
     if(mtp->next_count>0)
ffffffffc0204068:	6088                	ld	a0,0(s1)
ffffffffc020406a:	591c                	lw	a5,48(a0)
ffffffffc020406c:	00f05363          	blez	a5,ffffffffc0204072 <phi_put_forks_condvar+0x50>
        up(&(mtp->next));
ffffffffc0204070:	0561                	addi	a0,a0,24
     else
        up(&(mtp->mutex));
}
ffffffffc0204072:	6442                	ld	s0,16(sp)
ffffffffc0204074:	60e2                	ld	ra,24(sp)
ffffffffc0204076:	64a2                	ld	s1,8(sp)
ffffffffc0204078:	6902                	ld	s2,0(sp)
ffffffffc020407a:	6105                	addi	sp,sp,32
        up(&(mtp->mutex));
ffffffffc020407c:	a9a5                	j	ffffffffc02044f4 <up>

ffffffffc020407e <philosopher_using_condvar>:

//---------- philosophers using monitor (condition variable) ----------------------
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
ffffffffc020407e:	7179                	addi	sp,sp,-48
ffffffffc0204080:	f022                	sd	s0,32(sp)
  
    int i, iter=0;
    i=(int)arg;
ffffffffc0204082:	0005041b          	sext.w	s0,a0
    cprintf("I am No.%d philosopher_condvar\n",i);
ffffffffc0204086:	85a2                	mv	a1,s0
ffffffffc0204088:	00004517          	auipc	a0,0x4
ffffffffc020408c:	e8050513          	addi	a0,a0,-384 # ffffffffc0207f08 <default_pmm_manager+0x798>
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
ffffffffc0204090:	ec26                	sd	s1,24(sp)
ffffffffc0204092:	e84a                	sd	s2,16(sp)
ffffffffc0204094:	e44e                	sd	s3,8(sp)
ffffffffc0204096:	e052                	sd	s4,0(sp)
ffffffffc0204098:	f406                	sd	ra,40(sp)
    while(iter++<TIMES)
ffffffffc020409a:	4485                	li	s1,1
    cprintf("I am No.%d philosopher_condvar\n",i);
ffffffffc020409c:	848fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    { /* iterate*/
        cprintf("Iter %d, No.%d philosopher_condvar is thinking\n",iter,i); /* thinking*/
ffffffffc02040a0:	00004a17          	auipc	s4,0x4
ffffffffc02040a4:	e88a0a13          	addi	s4,s4,-376 # ffffffffc0207f28 <default_pmm_manager+0x7b8>
        do_sleep(SLEEP_TIME);
        phi_take_forks_condvar(i); 
        /* need two forks, maybe blocked */
        cprintf("Iter %d, No.%d philosopher_condvar is eating\n",iter,i); /* eating*/
ffffffffc02040a8:	00004997          	auipc	s3,0x4
ffffffffc02040ac:	eb098993          	addi	s3,s3,-336 # ffffffffc0207f58 <default_pmm_manager+0x7e8>
    while(iter++<TIMES)
ffffffffc02040b0:	4915                	li	s2,5
        cprintf("Iter %d, No.%d philosopher_condvar is thinking\n",iter,i); /* thinking*/
ffffffffc02040b2:	85a6                	mv	a1,s1
ffffffffc02040b4:	8622                	mv	a2,s0
ffffffffc02040b6:	8552                	mv	a0,s4
ffffffffc02040b8:	82cfc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc02040bc:	4529                	li	a0,10
ffffffffc02040be:	12d010ef          	jal	ra,ffffffffc02059ea <do_sleep>
        phi_take_forks_condvar(i); 
ffffffffc02040c2:	8522                	mv	a0,s0
ffffffffc02040c4:	eefff0ef          	jal	ra,ffffffffc0203fb2 <phi_take_forks_condvar>
        cprintf("Iter %d, No.%d philosopher_condvar is eating\n",iter,i); /* eating*/
ffffffffc02040c8:	85a6                	mv	a1,s1
ffffffffc02040ca:	8622                	mv	a2,s0
ffffffffc02040cc:	854e                	mv	a0,s3
ffffffffc02040ce:	816fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        do_sleep(SLEEP_TIME);
ffffffffc02040d2:	4529                	li	a0,10
ffffffffc02040d4:	117010ef          	jal	ra,ffffffffc02059ea <do_sleep>
    while(iter++<TIMES)
ffffffffc02040d8:	2485                	addiw	s1,s1,1
        phi_put_forks_condvar(i); 
ffffffffc02040da:	8522                	mv	a0,s0
ffffffffc02040dc:	f47ff0ef          	jal	ra,ffffffffc0204022 <phi_put_forks_condvar>
    while(iter++<TIMES)
ffffffffc02040e0:	fd2499e3          	bne	s1,s2,ffffffffc02040b2 <philosopher_using_condvar+0x34>
        /* return two forks back*/
    }
    cprintf("No.%d philosopher_condvar quit\n",i);
ffffffffc02040e4:	85a2                	mv	a1,s0
ffffffffc02040e6:	00004517          	auipc	a0,0x4
ffffffffc02040ea:	ea250513          	addi	a0,a0,-350 # ffffffffc0207f88 <default_pmm_manager+0x818>
ffffffffc02040ee:	ff7fb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return 0;    
}
ffffffffc02040f2:	70a2                	ld	ra,40(sp)
ffffffffc02040f4:	7402                	ld	s0,32(sp)
ffffffffc02040f6:	64e2                	ld	s1,24(sp)
ffffffffc02040f8:	6942                	ld	s2,16(sp)
ffffffffc02040fa:	69a2                	ld	s3,8(sp)
ffffffffc02040fc:	6a02                	ld	s4,0(sp)
ffffffffc02040fe:	4501                	li	a0,0
ffffffffc0204100:	6145                	addi	sp,sp,48
ffffffffc0204102:	8082                	ret

ffffffffc0204104 <check_sync>:

void check_sync(void){
ffffffffc0204104:	7159                	addi	sp,sp,-112
ffffffffc0204106:	f0a2                	sd	s0,96(sp)

    int i, pids[N];

    //check semaphore
    sem_init(&mutex, 1);
ffffffffc0204108:	4585                	li	a1,1
ffffffffc020410a:	000d8517          	auipc	a0,0xd8
ffffffffc020410e:	e8e50513          	addi	a0,a0,-370 # ffffffffc02dbf98 <mutex>
ffffffffc0204112:	0020                	addi	s0,sp,8
void check_sync(void){
ffffffffc0204114:	eca6                	sd	s1,88(sp)
ffffffffc0204116:	e8ca                	sd	s2,80(sp)
ffffffffc0204118:	e4ce                	sd	s3,72(sp)
ffffffffc020411a:	e0d2                	sd	s4,64(sp)
ffffffffc020411c:	fc56                	sd	s5,56(sp)
ffffffffc020411e:	f85a                	sd	s6,48(sp)
ffffffffc0204120:	f45e                	sd	s7,40(sp)
ffffffffc0204122:	f486                	sd	ra,104(sp)
ffffffffc0204124:	f062                	sd	s8,32(sp)
ffffffffc0204126:	000d8a17          	auipc	s4,0xd8
ffffffffc020412a:	edaa0a13          	addi	s4,s4,-294 # ffffffffc02dc000 <s>
    sem_init(&mutex, 1);
ffffffffc020412e:	3be000ef          	jal	ra,ffffffffc02044ec <sem_init>
    for(i=0;i<N;i++){
ffffffffc0204132:	000d8997          	auipc	s3,0xd8
ffffffffc0204136:	ea698993          	addi	s3,s3,-346 # ffffffffc02dbfd8 <philosopher_proc_sema>
    sem_init(&mutex, 1);
ffffffffc020413a:	8922                	mv	s2,s0
ffffffffc020413c:	4481                	li	s1,0
        sem_init(&s[i], 0);
        int pid = kernel_thread(philosopher_using_semaphore, (void *)i, 0);
ffffffffc020413e:	00000b97          	auipc	s7,0x0
ffffffffc0204142:	cd0b8b93          	addi	s7,s7,-816 # ffffffffc0203e0e <philosopher_using_semaphore>
        if (pid <= 0) {
            panic("create No.%d philosopher_using_semaphore failed.\n");
        }
        pids[i] = pid;
        philosopher_proc_sema[i] = find_proc(pid);
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
ffffffffc0204146:	00004b17          	auipc	s6,0x4
ffffffffc020414a:	eb2b0b13          	addi	s6,s6,-334 # ffffffffc0207ff8 <default_pmm_manager+0x888>
    for(i=0;i<N;i++){
ffffffffc020414e:	4a95                	li	s5,5
        sem_init(&s[i], 0);
ffffffffc0204150:	4581                	li	a1,0
ffffffffc0204152:	8552                	mv	a0,s4
ffffffffc0204154:	398000ef          	jal	ra,ffffffffc02044ec <sem_init>
        int pid = kernel_thread(philosopher_using_semaphore, (void *)i, 0);
ffffffffc0204158:	4601                	li	a2,0
ffffffffc020415a:	85a6                	mv	a1,s1
ffffffffc020415c:	855e                	mv	a0,s7
ffffffffc020415e:	391000ef          	jal	ra,ffffffffc0204cee <kernel_thread>
        if (pid <= 0) {
ffffffffc0204162:	0ca05863          	blez	a0,ffffffffc0204232 <check_sync+0x12e>
        pids[i] = pid;
ffffffffc0204166:	00a92023          	sw	a0,0(s2)
        philosopher_proc_sema[i] = find_proc(pid);
ffffffffc020416a:	776000ef          	jal	ra,ffffffffc02048e0 <find_proc>
ffffffffc020416e:	00a9b023          	sd	a0,0(s3)
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
ffffffffc0204172:	85da                	mv	a1,s6
    for(i=0;i<N;i++){
ffffffffc0204174:	0485                	addi	s1,s1,1
ffffffffc0204176:	0a61                	addi	s4,s4,24
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
ffffffffc0204178:	6ca000ef          	jal	ra,ffffffffc0204842 <set_proc_name>
    for(i=0;i<N;i++){
ffffffffc020417c:	0911                	addi	s2,s2,4
ffffffffc020417e:	09a1                	addi	s3,s3,8
ffffffffc0204180:	fd5498e3          	bne	s1,s5,ffffffffc0204150 <check_sync+0x4c>
ffffffffc0204184:	01440a93          	addi	s5,s0,20
ffffffffc0204188:	84a2                	mv	s1,s0
    }
    for (i=0;i<N;i++)
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc020418a:	4088                	lw	a0,0(s1)
ffffffffc020418c:	4581                	li	a1,0
ffffffffc020418e:	5b6010ef          	jal	ra,ffffffffc0205744 <do_wait>
ffffffffc0204192:	0e051863          	bnez	a0,ffffffffc0204282 <check_sync+0x17e>
    for (i=0;i<N;i++)
ffffffffc0204196:	0491                	addi	s1,s1,4
ffffffffc0204198:	ff5499e3          	bne	s1,s5,ffffffffc020418a <check_sync+0x86>

    //check condition variable
    monitor_init(&mt, N);
ffffffffc020419c:	4595                	li	a1,5
ffffffffc020419e:	000d8517          	auipc	a0,0xd8
ffffffffc02041a2:	dba50513          	addi	a0,a0,-582 # ffffffffc02dbf58 <mt>
ffffffffc02041a6:	384000ef          	jal	ra,ffffffffc020452a <monitor_init>
    for(i=0;i<N;i++){
ffffffffc02041aa:	000d8917          	auipc	s2,0xd8
ffffffffc02041ae:	ece90913          	addi	s2,s2,-306 # ffffffffc02dc078 <state_condvar>
ffffffffc02041b2:	000d8a17          	auipc	s4,0xd8
ffffffffc02041b6:	dfea0a13          	addi	s4,s4,-514 # ffffffffc02dbfb0 <philosopher_proc_condvar>
    monitor_init(&mt, N);
ffffffffc02041ba:	89a2                	mv	s3,s0
ffffffffc02041bc:	4481                	li	s1,0
        state_condvar[i]=THINKING;
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
ffffffffc02041be:	00000b17          	auipc	s6,0x0
ffffffffc02041c2:	ec0b0b13          	addi	s6,s6,-320 # ffffffffc020407e <philosopher_using_condvar>
        if (pid <= 0) {
            panic("create No.%d philosopher_using_condvar failed.\n");
        }
        pids[i] = pid;
        philosopher_proc_condvar[i] = find_proc(pid);
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
ffffffffc02041c6:	00004c17          	auipc	s8,0x4
ffffffffc02041ca:	e9ac0c13          	addi	s8,s8,-358 # ffffffffc0208060 <default_pmm_manager+0x8f0>
    for(i=0;i<N;i++){
ffffffffc02041ce:	4b95                	li	s7,5
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
ffffffffc02041d0:	4601                	li	a2,0
ffffffffc02041d2:	85a6                	mv	a1,s1
ffffffffc02041d4:	855a                	mv	a0,s6
        state_condvar[i]=THINKING;
ffffffffc02041d6:	00092023          	sw	zero,0(s2)
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
ffffffffc02041da:	315000ef          	jal	ra,ffffffffc0204cee <kernel_thread>
        if (pid <= 0) {
ffffffffc02041de:	08a05663          	blez	a0,ffffffffc020426a <check_sync+0x166>
        pids[i] = pid;
ffffffffc02041e2:	00a9a023          	sw	a0,0(s3)
        philosopher_proc_condvar[i] = find_proc(pid);
ffffffffc02041e6:	6fa000ef          	jal	ra,ffffffffc02048e0 <find_proc>
ffffffffc02041ea:	00aa3023          	sd	a0,0(s4)
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
ffffffffc02041ee:	85e2                	mv	a1,s8
    for(i=0;i<N;i++){
ffffffffc02041f0:	0485                	addi	s1,s1,1
ffffffffc02041f2:	0911                	addi	s2,s2,4
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
ffffffffc02041f4:	64e000ef          	jal	ra,ffffffffc0204842 <set_proc_name>
    for(i=0;i<N;i++){
ffffffffc02041f8:	0991                	addi	s3,s3,4
ffffffffc02041fa:	0a21                	addi	s4,s4,8
ffffffffc02041fc:	fd749ae3          	bne	s1,s7,ffffffffc02041d0 <check_sync+0xcc>
    }
    for (i=0;i<N;i++)
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc0204200:	4008                	lw	a0,0(s0)
ffffffffc0204202:	4581                	li	a1,0
ffffffffc0204204:	540010ef          	jal	ra,ffffffffc0205744 <do_wait>
ffffffffc0204208:	e129                	bnez	a0,ffffffffc020424a <check_sync+0x146>
    for (i=0;i<N;i++)
ffffffffc020420a:	0411                	addi	s0,s0,4
ffffffffc020420c:	ff541ae3          	bne	s0,s5,ffffffffc0204200 <check_sync+0xfc>
    monitor_free(&mt, N);
}
ffffffffc0204210:	7406                	ld	s0,96(sp)
ffffffffc0204212:	70a6                	ld	ra,104(sp)
ffffffffc0204214:	64e6                	ld	s1,88(sp)
ffffffffc0204216:	6946                	ld	s2,80(sp)
ffffffffc0204218:	69a6                	ld	s3,72(sp)
ffffffffc020421a:	6a06                	ld	s4,64(sp)
ffffffffc020421c:	7ae2                	ld	s5,56(sp)
ffffffffc020421e:	7b42                	ld	s6,48(sp)
ffffffffc0204220:	7ba2                	ld	s7,40(sp)
ffffffffc0204222:	7c02                	ld	s8,32(sp)
    monitor_free(&mt, N);
ffffffffc0204224:	4595                	li	a1,5
ffffffffc0204226:	000d8517          	auipc	a0,0xd8
ffffffffc020422a:	d3250513          	addi	a0,a0,-718 # ffffffffc02dbf58 <mt>
}
ffffffffc020422e:	6165                	addi	sp,sp,112
    monitor_free(&mt, N);
ffffffffc0204230:	a65d                	j	ffffffffc02045d6 <monitor_free>
            panic("create No.%d philosopher_using_semaphore failed.\n");
ffffffffc0204232:	00004617          	auipc	a2,0x4
ffffffffc0204236:	d7660613          	addi	a2,a2,-650 # ffffffffc0207fa8 <default_pmm_manager+0x838>
ffffffffc020423a:	0f700593          	li	a1,247
ffffffffc020423e:	00004517          	auipc	a0,0x4
ffffffffc0204242:	da250513          	addi	a0,a0,-606 # ffffffffc0207fe0 <default_pmm_manager+0x870>
ffffffffc0204246:	fddfb0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc020424a:	00004697          	auipc	a3,0x4
ffffffffc020424e:	dc668693          	addi	a3,a3,-570 # ffffffffc0208010 <default_pmm_manager+0x8a0>
ffffffffc0204252:	00003617          	auipc	a2,0x3
ffffffffc0204256:	e0e60613          	addi	a2,a2,-498 # ffffffffc0207060 <commands+0x838>
ffffffffc020425a:	10d00593          	li	a1,269
ffffffffc020425e:	00004517          	auipc	a0,0x4
ffffffffc0204262:	d8250513          	addi	a0,a0,-638 # ffffffffc0207fe0 <default_pmm_manager+0x870>
ffffffffc0204266:	fbdfb0ef          	jal	ra,ffffffffc0200222 <__panic>
            panic("create No.%d philosopher_using_condvar failed.\n");
ffffffffc020426a:	00004617          	auipc	a2,0x4
ffffffffc020426e:	dc660613          	addi	a2,a2,-570 # ffffffffc0208030 <default_pmm_manager+0x8c0>
ffffffffc0204272:	10600593          	li	a1,262
ffffffffc0204276:	00004517          	auipc	a0,0x4
ffffffffc020427a:	d6a50513          	addi	a0,a0,-662 # ffffffffc0207fe0 <default_pmm_manager+0x870>
ffffffffc020427e:	fa5fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(do_wait(pids[i],NULL) == 0);
ffffffffc0204282:	00004697          	auipc	a3,0x4
ffffffffc0204286:	d8e68693          	addi	a3,a3,-626 # ffffffffc0208010 <default_pmm_manager+0x8a0>
ffffffffc020428a:	00003617          	auipc	a2,0x3
ffffffffc020428e:	dd660613          	addi	a2,a2,-554 # ffffffffc0207060 <commands+0x838>
ffffffffc0204292:	0fe00593          	li	a1,254
ffffffffc0204296:	00004517          	auipc	a0,0x4
ffffffffc020429a:	d4a50513          	addi	a0,a0,-694 # ffffffffc0207fe0 <default_pmm_manager+0x870>
ffffffffc020429e:	f85fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02042a2 <wait_queue_init>:
    elm->prev = elm->next = elm;
ffffffffc02042a2:	e508                	sd	a0,8(a0)
ffffffffc02042a4:	e108                	sd	a0,0(a0)
}

void
wait_queue_init(wait_queue_t *queue) {
    list_init(&(queue->wait_head));
}
ffffffffc02042a6:	8082                	ret

ffffffffc02042a8 <wait_queue_del>:
    return list->next == list;
ffffffffc02042a8:	7198                	ld	a4,32(a1)
    list_add_before(&(queue->wait_head), &(wait->wait_link));
}

void
wait_queue_del(wait_queue_t *queue, wait_t *wait) {
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc02042aa:	01858793          	addi	a5,a1,24 # 80018 <_binary_obj___user_matrix_out_size+0x736d8>
ffffffffc02042ae:	00e78b63          	beq	a5,a4,ffffffffc02042c4 <wait_queue_del+0x1c>
ffffffffc02042b2:	6994                	ld	a3,16(a1)
ffffffffc02042b4:	00a69863          	bne	a3,a0,ffffffffc02042c4 <wait_queue_del+0x1c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02042b8:	6d94                	ld	a3,24(a1)
    prev->next = next;
ffffffffc02042ba:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc02042bc:	e314                	sd	a3,0(a4)
    elm->prev = elm->next = elm;
ffffffffc02042be:	f19c                	sd	a5,32(a1)
ffffffffc02042c0:	ed9c                	sd	a5,24(a1)
ffffffffc02042c2:	8082                	ret
wait_queue_del(wait_queue_t *queue, wait_t *wait) {
ffffffffc02042c4:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc02042c6:	00004697          	auipc	a3,0x4
ffffffffc02042ca:	e0a68693          	addi	a3,a3,-502 # ffffffffc02080d0 <default_pmm_manager+0x960>
ffffffffc02042ce:	00003617          	auipc	a2,0x3
ffffffffc02042d2:	d9260613          	addi	a2,a2,-622 # ffffffffc0207060 <commands+0x838>
ffffffffc02042d6:	45f1                	li	a1,28
ffffffffc02042d8:	00004517          	auipc	a0,0x4
ffffffffc02042dc:	de050513          	addi	a0,a0,-544 # ffffffffc02080b8 <default_pmm_manager+0x948>
wait_queue_del(wait_queue_t *queue, wait_t *wait) {
ffffffffc02042e0:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc02042e2:	f41fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02042e6 <wait_queue_first>:
    return listelm->next;
ffffffffc02042e6:	651c                	ld	a5,8(a0)
}

wait_t *
wait_queue_first(wait_queue_t *queue) {
    list_entry_t *le = list_next(&(queue->wait_head));
    if (le != &(queue->wait_head)) {
ffffffffc02042e8:	00f50563          	beq	a0,a5,ffffffffc02042f2 <wait_queue_first+0xc>
        return le2wait(le, wait_link);
ffffffffc02042ec:	fe878513          	addi	a0,a5,-24
ffffffffc02042f0:	8082                	ret
    }
    return NULL;
ffffffffc02042f2:	4501                	li	a0,0
}
ffffffffc02042f4:	8082                	ret

ffffffffc02042f6 <wait_in_queue>:
    return list_empty(&(queue->wait_head));
}

bool
wait_in_queue(wait_t *wait) {
    return !list_empty(&(wait->wait_link));
ffffffffc02042f6:	711c                	ld	a5,32(a0)
ffffffffc02042f8:	0561                	addi	a0,a0,24
ffffffffc02042fa:	40a78533          	sub	a0,a5,a0
}
ffffffffc02042fe:	00a03533          	snez	a0,a0
ffffffffc0204302:	8082                	ret

ffffffffc0204304 <wakeup_wait>:

void
wakeup_wait(wait_queue_t *queue, wait_t *wait, uint32_t wakeup_flags, bool del) {
    if (del) {
ffffffffc0204304:	e689                	bnez	a3,ffffffffc020430e <wakeup_wait+0xa>
        wait_queue_del(queue, wait);
    }
    wait->wakeup_flags = wakeup_flags;
    wakeup_proc(wait->proc);
ffffffffc0204306:	6188                	ld	a0,0(a1)
    wait->wakeup_flags = wakeup_flags;
ffffffffc0204308:	c590                	sw	a2,8(a1)
    wakeup_proc(wait->proc);
ffffffffc020430a:	7b60106f          	j	ffffffffc0205ac0 <wakeup_proc>
    return list->next == list;
ffffffffc020430e:	7198                	ld	a4,32(a1)
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc0204310:	01858793          	addi	a5,a1,24
ffffffffc0204314:	00e78e63          	beq	a5,a4,ffffffffc0204330 <wakeup_wait+0x2c>
ffffffffc0204318:	6994                	ld	a3,16(a1)
ffffffffc020431a:	00d51b63          	bne	a0,a3,ffffffffc0204330 <wakeup_wait+0x2c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020431e:	6d94                	ld	a3,24(a1)
    wakeup_proc(wait->proc);
ffffffffc0204320:	6188                	ld	a0,0(a1)
    prev->next = next;
ffffffffc0204322:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0204324:	e314                	sd	a3,0(a4)
    elm->prev = elm->next = elm;
ffffffffc0204326:	f19c                	sd	a5,32(a1)
ffffffffc0204328:	ed9c                	sd	a5,24(a1)
    wait->wakeup_flags = wakeup_flags;
ffffffffc020432a:	c590                	sw	a2,8(a1)
    wakeup_proc(wait->proc);
ffffffffc020432c:	7940106f          	j	ffffffffc0205ac0 <wakeup_proc>
wakeup_wait(wait_queue_t *queue, wait_t *wait, uint32_t wakeup_flags, bool del) {
ffffffffc0204330:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc0204332:	00004697          	auipc	a3,0x4
ffffffffc0204336:	d9e68693          	addi	a3,a3,-610 # ffffffffc02080d0 <default_pmm_manager+0x960>
ffffffffc020433a:	00003617          	auipc	a2,0x3
ffffffffc020433e:	d2660613          	addi	a2,a2,-730 # ffffffffc0207060 <commands+0x838>
ffffffffc0204342:	45f1                	li	a1,28
ffffffffc0204344:	00004517          	auipc	a0,0x4
ffffffffc0204348:	d7450513          	addi	a0,a0,-652 # ffffffffc02080b8 <default_pmm_manager+0x948>
wakeup_wait(wait_queue_t *queue, wait_t *wait, uint32_t wakeup_flags, bool del) {
ffffffffc020434c:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
ffffffffc020434e:	ed5fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0204352 <wait_current_set>:
    }
}

void
wait_current_set(wait_queue_t *queue, wait_t *wait, uint32_t wait_state) {
    assert(current != NULL);
ffffffffc0204352:	000dc797          	auipc	a5,0xdc
ffffffffc0204356:	dee7b783          	ld	a5,-530(a5) # ffffffffc02e0140 <current>
ffffffffc020435a:	c39d                	beqz	a5,ffffffffc0204380 <wait_current_set+0x2e>
    list_init(&(wait->wait_link));
ffffffffc020435c:	01858713          	addi	a4,a1,24
    wait->wakeup_flags = WT_INTERRUPTED;
ffffffffc0204360:	800006b7          	lui	a3,0x80000
ffffffffc0204364:	ed98                	sd	a4,24(a1)
    wait->proc = proc;
ffffffffc0204366:	e19c                	sd	a5,0(a1)
    wait->wakeup_flags = WT_INTERRUPTED;
ffffffffc0204368:	c594                	sw	a3,8(a1)
    wait_init(wait, current);
    current->state = PROC_SLEEPING;
ffffffffc020436a:	4685                	li	a3,1
ffffffffc020436c:	c394                	sw	a3,0(a5)
    current->wait_state = wait_state;
ffffffffc020436e:	0ec7a623          	sw	a2,236(a5)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0204372:	611c                	ld	a5,0(a0)
    wait->wait_queue = queue;
ffffffffc0204374:	e988                	sd	a0,16(a1)
    prev->next = next->prev = elm;
ffffffffc0204376:	e118                	sd	a4,0(a0)
ffffffffc0204378:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020437a:	f188                	sd	a0,32(a1)
    elm->prev = prev;
ffffffffc020437c:	ed9c                	sd	a5,24(a1)
ffffffffc020437e:	8082                	ret
wait_current_set(wait_queue_t *queue, wait_t *wait, uint32_t wait_state) {
ffffffffc0204380:	1141                	addi	sp,sp,-16
    assert(current != NULL);
ffffffffc0204382:	00004697          	auipc	a3,0x4
ffffffffc0204386:	d8e68693          	addi	a3,a3,-626 # ffffffffc0208110 <default_pmm_manager+0x9a0>
ffffffffc020438a:	00003617          	auipc	a2,0x3
ffffffffc020438e:	cd660613          	addi	a2,a2,-810 # ffffffffc0207060 <commands+0x838>
ffffffffc0204392:	07400593          	li	a1,116
ffffffffc0204396:	00004517          	auipc	a0,0x4
ffffffffc020439a:	d2250513          	addi	a0,a0,-734 # ffffffffc02080b8 <default_pmm_manager+0x948>
wait_current_set(wait_queue_t *queue, wait_t *wait, uint32_t wait_state) {
ffffffffc020439e:	e406                	sd	ra,8(sp)
    assert(current != NULL);
ffffffffc02043a0:	e83fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02043a4 <__down.constprop.0>:
        }
    }
    local_intr_restore(intr_flag);
}

static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
ffffffffc02043a4:	715d                	addi	sp,sp,-80
ffffffffc02043a6:	e0a2                	sd	s0,64(sp)
ffffffffc02043a8:	e486                	sd	ra,72(sp)
ffffffffc02043aa:	fc26                	sd	s1,56(sp)
ffffffffc02043ac:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02043ae:	100027f3          	csrr	a5,sstatus
ffffffffc02043b2:	8b89                	andi	a5,a5,2
ffffffffc02043b4:	ebb1                	bnez	a5,ffffffffc0204408 <__down.constprop.0+0x64>
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
ffffffffc02043b6:	411c                	lw	a5,0(a0)
ffffffffc02043b8:	00f05a63          	blez	a5,ffffffffc02043cc <__down.constprop.0+0x28>
        sem->value --;
ffffffffc02043bc:	37fd                	addiw	a5,a5,-1
ffffffffc02043be:	c11c                	sw	a5,0(a0)
        local_intr_restore(intr_flag);
        return 0;
ffffffffc02043c0:	4501                	li	a0,0

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
ffffffffc02043c2:	60a6                	ld	ra,72(sp)
ffffffffc02043c4:	6406                	ld	s0,64(sp)
ffffffffc02043c6:	74e2                	ld	s1,56(sp)
ffffffffc02043c8:	6161                	addi	sp,sp,80
ffffffffc02043ca:	8082                	ret
    wait_current_set(&(sem->wait_queue), wait, wait_state);
ffffffffc02043cc:	00850413          	addi	s0,a0,8
ffffffffc02043d0:	0024                	addi	s1,sp,8
ffffffffc02043d2:	10000613          	li	a2,256
ffffffffc02043d6:	85a6                	mv	a1,s1
ffffffffc02043d8:	8522                	mv	a0,s0
ffffffffc02043da:	f79ff0ef          	jal	ra,ffffffffc0204352 <wait_current_set>
    schedule();
ffffffffc02043de:	794010ef          	jal	ra,ffffffffc0205b72 <schedule>
ffffffffc02043e2:	100027f3          	csrr	a5,sstatus
ffffffffc02043e6:	8b89                	andi	a5,a5,2
ffffffffc02043e8:	efb9                	bnez	a5,ffffffffc0204446 <__down.constprop.0+0xa2>
    wait_current_del(&(sem->wait_queue), wait);
ffffffffc02043ea:	8526                	mv	a0,s1
ffffffffc02043ec:	f0bff0ef          	jal	ra,ffffffffc02042f6 <wait_in_queue>
ffffffffc02043f0:	e531                	bnez	a0,ffffffffc020443c <__down.constprop.0+0x98>
    if (wait->wakeup_flags != wait_state) {
ffffffffc02043f2:	4542                	lw	a0,16(sp)
ffffffffc02043f4:	10000793          	li	a5,256
ffffffffc02043f8:	fcf515e3          	bne	a0,a5,ffffffffc02043c2 <__down.constprop.0+0x1e>
}
ffffffffc02043fc:	60a6                	ld	ra,72(sp)
ffffffffc02043fe:	6406                	ld	s0,64(sp)
ffffffffc0204400:	74e2                	ld	s1,56(sp)
    return 0;
ffffffffc0204402:	4501                	li	a0,0
}
ffffffffc0204404:	6161                	addi	sp,sp,80
ffffffffc0204406:	8082                	ret
        intr_disable();
ffffffffc0204408:	dacfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    if (sem->value > 0) {
ffffffffc020440c:	401c                	lw	a5,0(s0)
ffffffffc020440e:	00f05c63          	blez	a5,ffffffffc0204426 <__down.constprop.0+0x82>
        sem->value --;
ffffffffc0204412:	37fd                	addiw	a5,a5,-1
ffffffffc0204414:	c01c                	sw	a5,0(s0)
        intr_enable();
ffffffffc0204416:	d98fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc020441a:	60a6                	ld	ra,72(sp)
ffffffffc020441c:	6406                	ld	s0,64(sp)
ffffffffc020441e:	74e2                	ld	s1,56(sp)
        return 0;
ffffffffc0204420:	4501                	li	a0,0
}
ffffffffc0204422:	6161                	addi	sp,sp,80
ffffffffc0204424:	8082                	ret
    wait_current_set(&(sem->wait_queue), wait, wait_state);
ffffffffc0204426:	0421                	addi	s0,s0,8
ffffffffc0204428:	0024                	addi	s1,sp,8
ffffffffc020442a:	10000613          	li	a2,256
ffffffffc020442e:	85a6                	mv	a1,s1
ffffffffc0204430:	8522                	mv	a0,s0
ffffffffc0204432:	f21ff0ef          	jal	ra,ffffffffc0204352 <wait_current_set>
ffffffffc0204436:	d78fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020443a:	b755                	j	ffffffffc02043de <__down.constprop.0+0x3a>
    wait_current_del(&(sem->wait_queue), wait);
ffffffffc020443c:	85a6                	mv	a1,s1
ffffffffc020443e:	8522                	mv	a0,s0
ffffffffc0204440:	e69ff0ef          	jal	ra,ffffffffc02042a8 <wait_queue_del>
    if (flag) {
ffffffffc0204444:	b77d                	j	ffffffffc02043f2 <__down.constprop.0+0x4e>
        intr_disable();
ffffffffc0204446:	d6efc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020444a:	8526                	mv	a0,s1
ffffffffc020444c:	eabff0ef          	jal	ra,ffffffffc02042f6 <wait_in_queue>
ffffffffc0204450:	e501                	bnez	a0,ffffffffc0204458 <__down.constprop.0+0xb4>
        intr_enable();
ffffffffc0204452:	d5cfc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204456:	bf71                	j	ffffffffc02043f2 <__down.constprop.0+0x4e>
ffffffffc0204458:	85a6                	mv	a1,s1
ffffffffc020445a:	8522                	mv	a0,s0
ffffffffc020445c:	e4dff0ef          	jal	ra,ffffffffc02042a8 <wait_queue_del>
    if (flag) {
ffffffffc0204460:	bfcd                	j	ffffffffc0204452 <__down.constprop.0+0xae>

ffffffffc0204462 <__up.constprop.0>:
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
ffffffffc0204462:	1101                	addi	sp,sp,-32
ffffffffc0204464:	e822                	sd	s0,16(sp)
ffffffffc0204466:	ec06                	sd	ra,24(sp)
ffffffffc0204468:	e426                	sd	s1,8(sp)
ffffffffc020446a:	e04a                	sd	s2,0(sp)
ffffffffc020446c:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020446e:	100027f3          	csrr	a5,sstatus
ffffffffc0204472:	8b89                	andi	a5,a5,2
ffffffffc0204474:	4901                	li	s2,0
ffffffffc0204476:	eba1                	bnez	a5,ffffffffc02044c6 <__up.constprop.0+0x64>
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
ffffffffc0204478:	00840493          	addi	s1,s0,8
ffffffffc020447c:	8526                	mv	a0,s1
ffffffffc020447e:	e69ff0ef          	jal	ra,ffffffffc02042e6 <wait_queue_first>
ffffffffc0204482:	85aa                	mv	a1,a0
ffffffffc0204484:	cd0d                	beqz	a0,ffffffffc02044be <__up.constprop.0+0x5c>
            assert(wait->proc->wait_state == wait_state);
ffffffffc0204486:	6118                	ld	a4,0(a0)
ffffffffc0204488:	10000793          	li	a5,256
ffffffffc020448c:	0ec72703          	lw	a4,236(a4)
ffffffffc0204490:	02f71f63          	bne	a4,a5,ffffffffc02044ce <__up.constprop.0+0x6c>
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
ffffffffc0204494:	4685                	li	a3,1
ffffffffc0204496:	10000613          	li	a2,256
ffffffffc020449a:	8526                	mv	a0,s1
ffffffffc020449c:	e69ff0ef          	jal	ra,ffffffffc0204304 <wakeup_wait>
    if (flag) {
ffffffffc02044a0:	00091863          	bnez	s2,ffffffffc02044b0 <__up.constprop.0+0x4e>
}
ffffffffc02044a4:	60e2                	ld	ra,24(sp)
ffffffffc02044a6:	6442                	ld	s0,16(sp)
ffffffffc02044a8:	64a2                	ld	s1,8(sp)
ffffffffc02044aa:	6902                	ld	s2,0(sp)
ffffffffc02044ac:	6105                	addi	sp,sp,32
ffffffffc02044ae:	8082                	ret
ffffffffc02044b0:	6442                	ld	s0,16(sp)
ffffffffc02044b2:	60e2                	ld	ra,24(sp)
ffffffffc02044b4:	64a2                	ld	s1,8(sp)
ffffffffc02044b6:	6902                	ld	s2,0(sp)
ffffffffc02044b8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02044ba:	cf4fc06f          	j	ffffffffc02009ae <intr_enable>
            sem->value ++;
ffffffffc02044be:	401c                	lw	a5,0(s0)
ffffffffc02044c0:	2785                	addiw	a5,a5,1
ffffffffc02044c2:	c01c                	sw	a5,0(s0)
ffffffffc02044c4:	bff1                	j	ffffffffc02044a0 <__up.constprop.0+0x3e>
        intr_disable();
ffffffffc02044c6:	ceefc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02044ca:	4905                	li	s2,1
ffffffffc02044cc:	b775                	j	ffffffffc0204478 <__up.constprop.0+0x16>
            assert(wait->proc->wait_state == wait_state);
ffffffffc02044ce:	00004697          	auipc	a3,0x4
ffffffffc02044d2:	c5268693          	addi	a3,a3,-942 # ffffffffc0208120 <default_pmm_manager+0x9b0>
ffffffffc02044d6:	00003617          	auipc	a2,0x3
ffffffffc02044da:	b8a60613          	addi	a2,a2,-1142 # ffffffffc0207060 <commands+0x838>
ffffffffc02044de:	45e5                	li	a1,25
ffffffffc02044e0:	00004517          	auipc	a0,0x4
ffffffffc02044e4:	c6850513          	addi	a0,a0,-920 # ffffffffc0208148 <default_pmm_manager+0x9d8>
ffffffffc02044e8:	d3bfb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02044ec <sem_init>:
    sem->value = value;
ffffffffc02044ec:	c10c                	sw	a1,0(a0)
    wait_queue_init(&(sem->wait_queue));
ffffffffc02044ee:	0521                	addi	a0,a0,8
ffffffffc02044f0:	db3ff06f          	j	ffffffffc02042a2 <wait_queue_init>

ffffffffc02044f4 <up>:

void
up(semaphore_t *sem) {
    __up(sem, WT_KSEM);
ffffffffc02044f4:	f6fff06f          	j	ffffffffc0204462 <__up.constprop.0>

ffffffffc02044f8 <down>:
}

void
down(semaphore_t *sem) {
ffffffffc02044f8:	1141                	addi	sp,sp,-16
ffffffffc02044fa:	e406                	sd	ra,8(sp)
    uint32_t flags = __down(sem, WT_KSEM);
ffffffffc02044fc:	ea9ff0ef          	jal	ra,ffffffffc02043a4 <__down.constprop.0>
ffffffffc0204500:	2501                	sext.w	a0,a0
    assert(flags == 0);
ffffffffc0204502:	e501                	bnez	a0,ffffffffc020450a <down+0x12>
}
ffffffffc0204504:	60a2                	ld	ra,8(sp)
ffffffffc0204506:	0141                	addi	sp,sp,16
ffffffffc0204508:	8082                	ret
    assert(flags == 0);
ffffffffc020450a:	00004697          	auipc	a3,0x4
ffffffffc020450e:	c4e68693          	addi	a3,a3,-946 # ffffffffc0208158 <default_pmm_manager+0x9e8>
ffffffffc0204512:	00003617          	auipc	a2,0x3
ffffffffc0204516:	b4e60613          	addi	a2,a2,-1202 # ffffffffc0207060 <commands+0x838>
ffffffffc020451a:	04000593          	li	a1,64
ffffffffc020451e:	00004517          	auipc	a0,0x4
ffffffffc0204522:	c2a50513          	addi	a0,a0,-982 # ffffffffc0208148 <default_pmm_manager+0x9d8>
ffffffffc0204526:	cfdfb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020452a <monitor_init>:
#include <assert.h>


// Initialize monitor.
void     
monitor_init (monitor_t * mtp, size_t num_cv) {
ffffffffc020452a:	7179                	addi	sp,sp,-48
ffffffffc020452c:	f406                	sd	ra,40(sp)
ffffffffc020452e:	f022                	sd	s0,32(sp)
ffffffffc0204530:	ec26                	sd	s1,24(sp)
ffffffffc0204532:	e84a                	sd	s2,16(sp)
ffffffffc0204534:	e44e                	sd	s3,8(sp)
    int i;
    assert(num_cv>0);
ffffffffc0204536:	c1b5                	beqz	a1,ffffffffc020459a <monitor_init+0x70>
    mtp->next_count = 0;
ffffffffc0204538:	89ae                	mv	s3,a1
ffffffffc020453a:	02052823          	sw	zero,48(a0)
    mtp->cv = NULL;
    sem_init(&(mtp->mutex), 1); //unlocked
ffffffffc020453e:	4585                	li	a1,1
    mtp->cv = NULL;
ffffffffc0204540:	02053c23          	sd	zero,56(a0)
    sem_init(&(mtp->mutex), 1); //unlocked
ffffffffc0204544:	892a                	mv	s2,a0
ffffffffc0204546:	fa7ff0ef          	jal	ra,ffffffffc02044ec <sem_init>
    sem_init(&(mtp->next), 0);
ffffffffc020454a:	4581                	li	a1,0
ffffffffc020454c:	01890513          	addi	a0,s2,24
ffffffffc0204550:	f9dff0ef          	jal	ra,ffffffffc02044ec <sem_init>
    mtp->cv =(condvar_t *) kmalloc(sizeof(condvar_t)*num_cv);
ffffffffc0204554:	00299513          	slli	a0,s3,0x2
ffffffffc0204558:	954e                	add	a0,a0,s3
ffffffffc020455a:	050e                	slli	a0,a0,0x3
ffffffffc020455c:	bcefd0ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc0204560:	02a93c23          	sd	a0,56(s2)
    assert(mtp->cv!=NULL);
ffffffffc0204564:	4401                	li	s0,0
ffffffffc0204566:	4481                	li	s1,0
ffffffffc0204568:	c921                	beqz	a0,ffffffffc02045b8 <monitor_init+0x8e>
    for(i=0; i<num_cv; i++){
        mtp->cv[i].count=0;
ffffffffc020456a:	9522                	add	a0,a0,s0
ffffffffc020456c:	00052c23          	sw	zero,24(a0)
        sem_init(&(mtp->cv[i].sem),0);
ffffffffc0204570:	4581                	li	a1,0
ffffffffc0204572:	f7bff0ef          	jal	ra,ffffffffc02044ec <sem_init>
        mtp->cv[i].owner=mtp;
ffffffffc0204576:	03893503          	ld	a0,56(s2)
    for(i=0; i<num_cv; i++){
ffffffffc020457a:	0485                	addi	s1,s1,1
        mtp->cv[i].owner=mtp;
ffffffffc020457c:	008507b3          	add	a5,a0,s0
ffffffffc0204580:	0327b023          	sd	s2,32(a5)
    for(i=0; i<num_cv; i++){
ffffffffc0204584:	02840413          	addi	s0,s0,40
ffffffffc0204588:	fe9991e3          	bne	s3,s1,ffffffffc020456a <monitor_init+0x40>
    }
}
ffffffffc020458c:	70a2                	ld	ra,40(sp)
ffffffffc020458e:	7402                	ld	s0,32(sp)
ffffffffc0204590:	64e2                	ld	s1,24(sp)
ffffffffc0204592:	6942                	ld	s2,16(sp)
ffffffffc0204594:	69a2                	ld	s3,8(sp)
ffffffffc0204596:	6145                	addi	sp,sp,48
ffffffffc0204598:	8082                	ret
    assert(num_cv>0);
ffffffffc020459a:	00004697          	auipc	a3,0x4
ffffffffc020459e:	bce68693          	addi	a3,a3,-1074 # ffffffffc0208168 <default_pmm_manager+0x9f8>
ffffffffc02045a2:	00003617          	auipc	a2,0x3
ffffffffc02045a6:	abe60613          	addi	a2,a2,-1346 # ffffffffc0207060 <commands+0x838>
ffffffffc02045aa:	45ad                	li	a1,11
ffffffffc02045ac:	00004517          	auipc	a0,0x4
ffffffffc02045b0:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0208178 <default_pmm_manager+0xa08>
ffffffffc02045b4:	c6ffb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(mtp->cv!=NULL);
ffffffffc02045b8:	00004697          	auipc	a3,0x4
ffffffffc02045bc:	bd868693          	addi	a3,a3,-1064 # ffffffffc0208190 <default_pmm_manager+0xa20>
ffffffffc02045c0:	00003617          	auipc	a2,0x3
ffffffffc02045c4:	aa060613          	addi	a2,a2,-1376 # ffffffffc0207060 <commands+0x838>
ffffffffc02045c8:	45c5                	li	a1,17
ffffffffc02045ca:	00004517          	auipc	a0,0x4
ffffffffc02045ce:	bae50513          	addi	a0,a0,-1106 # ffffffffc0208178 <default_pmm_manager+0xa08>
ffffffffc02045d2:	c51fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02045d6 <monitor_free>:

// Free monitor.
void
monitor_free (monitor_t * mtp, size_t num_cv) {
    kfree(mtp->cv);
ffffffffc02045d6:	7d08                	ld	a0,56(a0)
ffffffffc02045d8:	c02fd06f          	j	ffffffffc02019da <kfree>

ffffffffc02045dc <cond_signal>:

// Unlock one of threads waiting on the condition variable. 
void 
cond_signal (condvar_t *cvp) {
   //LAB7 EXERCISE1: YOUR CODE
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02045dc:	711c                	ld	a5,32(a0)
ffffffffc02045de:	4d10                	lw	a2,24(a0)
cond_signal (condvar_t *cvp) {
ffffffffc02045e0:	1141                	addi	sp,sp,-16
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02045e2:	5b94                	lw	a3,48(a5)
cond_signal (condvar_t *cvp) {
ffffffffc02045e4:	e022                	sd	s0,0(sp)
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02045e6:	85aa                	mv	a1,a0
cond_signal (condvar_t *cvp) {
ffffffffc02045e8:	842a                	mv	s0,a0
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02045ea:	00004517          	auipc	a0,0x4
ffffffffc02045ee:	bb650513          	addi	a0,a0,-1098 # ffffffffc02081a0 <default_pmm_manager+0xa30>
cond_signal (condvar_t *cvp) {
ffffffffc02045f2:	e406                	sd	ra,8(sp)
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
ffffffffc02045f4:	af1fb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
   *             wait(mt.next);
   *             mt.next_count--;
   *          }
   *       }
   */
   if(cvp->count > 0) {
ffffffffc02045f8:	4c10                	lw	a2,24(s0)
ffffffffc02045fa:	00c04e63          	bgtz	a2,ffffffffc0204616 <cond_signal+0x3a>
       cvp->owner->next_count++;
       up(&(cvp->sem));
       down(&(cvp->owner->next));
       cvp->owner->next_count--;
   }
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc02045fe:	701c                	ld	a5,32(s0)
ffffffffc0204600:	85a2                	mv	a1,s0
}
ffffffffc0204602:	6402                	ld	s0,0(sp)
ffffffffc0204604:	60a2                	ld	ra,8(sp)
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204606:	5b94                	lw	a3,48(a5)
ffffffffc0204608:	00004517          	auipc	a0,0x4
ffffffffc020460c:	be050513          	addi	a0,a0,-1056 # ffffffffc02081e8 <default_pmm_manager+0xa78>
}
ffffffffc0204610:	0141                	addi	sp,sp,16
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204612:	ad3fb06f          	j	ffffffffc02000e4 <cprintf>
       cvp->owner->next_count++;
ffffffffc0204616:	7018                	ld	a4,32(s0)
       up(&(cvp->sem));
ffffffffc0204618:	8522                	mv	a0,s0
       cvp->owner->next_count++;
ffffffffc020461a:	5b1c                	lw	a5,48(a4)
ffffffffc020461c:	2785                	addiw	a5,a5,1
ffffffffc020461e:	db1c                	sw	a5,48(a4)
       up(&(cvp->sem));
ffffffffc0204620:	ed5ff0ef          	jal	ra,ffffffffc02044f4 <up>
       down(&(cvp->owner->next));
ffffffffc0204624:	7008                	ld	a0,32(s0)
ffffffffc0204626:	0561                	addi	a0,a0,24
ffffffffc0204628:	ed1ff0ef          	jal	ra,ffffffffc02044f8 <down>
       cvp->owner->next_count--;
ffffffffc020462c:	7018                	ld	a4,32(s0)
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc020462e:	4c10                	lw	a2,24(s0)
ffffffffc0204630:	85a2                	mv	a1,s0
       cvp->owner->next_count--;
ffffffffc0204632:	5b1c                	lw	a5,48(a4)
}
ffffffffc0204634:	6402                	ld	s0,0(sp)
ffffffffc0204636:	60a2                	ld	ra,8(sp)
       cvp->owner->next_count--;
ffffffffc0204638:	fff7869b          	addiw	a3,a5,-1
ffffffffc020463c:	db14                	sw	a3,48(a4)
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc020463e:	00004517          	auipc	a0,0x4
ffffffffc0204642:	baa50513          	addi	a0,a0,-1110 # ffffffffc02081e8 <default_pmm_manager+0xa78>
}
ffffffffc0204646:	0141                	addi	sp,sp,16
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204648:	a9dfb06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc020464c <cond_wait>:
// Suspend calling thread on a condition variable waiting for condition Atomically unlocks 
// mutex and suspends calling thread on conditional variable after waking up locks mutex. Notice: mp is mutex semaphore for monitor's procedures
void
cond_wait (condvar_t *cvp) {
    //LAB7 EXERCISE1: YOUR CODE
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc020464c:	711c                	ld	a5,32(a0)
ffffffffc020464e:	4d10                	lw	a2,24(a0)
cond_wait (condvar_t *cvp) {
ffffffffc0204650:	1141                	addi	sp,sp,-16
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204652:	5b94                	lw	a3,48(a5)
cond_wait (condvar_t *cvp) {
ffffffffc0204654:	e022                	sd	s0,0(sp)
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204656:	85aa                	mv	a1,a0
cond_wait (condvar_t *cvp) {
ffffffffc0204658:	842a                	mv	s0,a0
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc020465a:	00004517          	auipc	a0,0x4
ffffffffc020465e:	bd650513          	addi	a0,a0,-1066 # ffffffffc0208230 <default_pmm_manager+0xac0>
cond_wait (condvar_t *cvp) {
ffffffffc0204662:	e406                	sd	ra,8(sp)
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204664:	a81fb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    *            signal(mt.mutex);
    *         wait(cv.sem);
    *         cv.count --;
    */
    cvp->count++;
    if(cvp->owner->next_count > 0)
ffffffffc0204668:	7008                	ld	a0,32(s0)
    cvp->count++;
ffffffffc020466a:	4c1c                	lw	a5,24(s0)
    if(cvp->owner->next_count > 0)
ffffffffc020466c:	5918                	lw	a4,48(a0)
    cvp->count++;
ffffffffc020466e:	2785                	addiw	a5,a5,1
ffffffffc0204670:	cc1c                	sw	a5,24(s0)
    if(cvp->owner->next_count > 0)
ffffffffc0204672:	02e05763          	blez	a4,ffffffffc02046a0 <cond_wait+0x54>
        up(&(cvp->owner->next));
ffffffffc0204676:	0561                	addi	a0,a0,24
ffffffffc0204678:	e7dff0ef          	jal	ra,ffffffffc02044f4 <up>
    else
        up(&(cvp->owner->mutex));
    down(&(cvp->sem));
ffffffffc020467c:	8522                	mv	a0,s0
ffffffffc020467e:	e7bff0ef          	jal	ra,ffffffffc02044f8 <down>
    cvp->count--;
ffffffffc0204682:	4c10                	lw	a2,24(s0)
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204684:	701c                	ld	a5,32(s0)
ffffffffc0204686:	85a2                	mv	a1,s0
    cvp->count--;
ffffffffc0204688:	367d                	addiw	a2,a2,-1
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc020468a:	5b94                	lw	a3,48(a5)
    cvp->count--;
ffffffffc020468c:	cc10                	sw	a2,24(s0)
}
ffffffffc020468e:	6402                	ld	s0,0(sp)
ffffffffc0204690:	60a2                	ld	ra,8(sp)
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc0204692:	00004517          	auipc	a0,0x4
ffffffffc0204696:	be650513          	addi	a0,a0,-1050 # ffffffffc0208278 <default_pmm_manager+0xb08>
}
ffffffffc020469a:	0141                	addi	sp,sp,16
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
ffffffffc020469c:	a49fb06f          	j	ffffffffc02000e4 <cprintf>
        up(&(cvp->owner->mutex));
ffffffffc02046a0:	e55ff0ef          	jal	ra,ffffffffc02044f4 <up>
ffffffffc02046a4:	bfe1                	j	ffffffffc020467c <cond_wait+0x30>

ffffffffc02046a6 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02046a6:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02046aa:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02046ae:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02046b0:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02046b2:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02046b6:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02046ba:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02046be:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02046c2:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02046c6:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02046ca:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02046ce:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02046d2:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02046d6:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02046da:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02046de:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02046e2:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02046e4:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02046e6:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02046ea:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02046ee:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02046f2:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02046f6:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02046fa:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02046fe:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204702:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0204706:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc020470a:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020470e:	8082                	ret

ffffffffc0204710 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204710:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204712:	9402                	jalr	s0

	jal do_exit
ffffffffc0204714:	62a000ef          	jal	ra,ffffffffc0204d3e <do_exit>

ffffffffc0204718 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0204718:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020471a:	14800513          	li	a0,328
{
ffffffffc020471e:	e022                	sd	s0,0(sp)
ffffffffc0204720:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204722:	a08fd0ef          	jal	ra,ffffffffc020192a <kmalloc>
ffffffffc0204726:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0204728:	c551                	beqz	a0,ffffffffc02047b4 <alloc_proc+0x9c>
         *       skew_heap_entry_t lab6_run_pool;            // entry in the run pool (lab6 stride)
         *       uint32_t lab6_stride;                       // stride value (lab6 stride)
         *       uint32_t lab6_priority;                     // priority value (lab6 stride)
         */
        // LAB4原有
        proc->state = PROC_UNINIT;
ffffffffc020472a:	57fd                	li	a5,-1
ffffffffc020472c:	1782                	slli	a5,a5,0x20
ffffffffc020472e:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0204730:	07000613          	li	a2,112
ffffffffc0204734:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0204736:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc020473a:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc020473e:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0204742:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0204746:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020474a:	03050513          	addi	a0,a0,48
ffffffffc020474e:	201010ef          	jal	ra,ffffffffc020614e <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0204752:	000dc797          	auipc	a5,0xdc
ffffffffc0204756:	9be7b783          	ld	a5,-1602(a5) # ffffffffc02e0110 <boot_pgdir_pa>
ffffffffc020475a:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc020475c:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0204760:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN+1);
ffffffffc0204764:	4641                	li	a2,16
ffffffffc0204766:	4581                	li	a1,0
ffffffffc0204768:	0b440513          	addi	a0,s0,180
ffffffffc020476c:	1e3010ef          	jal	ra,ffffffffc020614e <memset>
        list_init(&(proc->list_link));
ffffffffc0204770:	0c840693          	addi	a3,s0,200
        list_init(&(proc->hash_link));
ffffffffc0204774:	0d840713          	addi	a4,s0,216
        proc->optr = NULL;
        proc->yptr = NULL;

        // Lab6新增
        proc->rq = NULL;
        list_init(&(proc->run_link));
ffffffffc0204778:	11040793          	addi	a5,s0,272
    elm->prev = elm->next = elm;
ffffffffc020477c:	e874                	sd	a3,208(s0)
ffffffffc020477e:	e474                	sd	a3,200(s0)
ffffffffc0204780:	f078                	sd	a4,224(s0)
ffffffffc0204782:	ec78                	sd	a4,216(s0)
        proc->wait_state = 0;
ffffffffc0204784:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;
ffffffffc0204788:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc020478c:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0204790:	0e043c23          	sd	zero,248(s0)
        proc->rq = NULL;
ffffffffc0204794:	10043423          	sd	zero,264(s0)
ffffffffc0204798:	10f43c23          	sd	a5,280(s0)
ffffffffc020479c:	10f43823          	sd	a5,272(s0)
        proc->time_slice = 0;
ffffffffc02047a0:	12042023          	sw	zero,288(s0)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
ffffffffc02047a4:	12043423          	sd	zero,296(s0)
ffffffffc02047a8:	12043823          	sd	zero,304(s0)
ffffffffc02047ac:	12043c23          	sd	zero,312(s0)
        skew_heap_init(&(proc->lab6_run_pool));
        proc->lab6_stride = 0;
ffffffffc02047b0:	14043023          	sd	zero,320(s0)
        proc->lab6_priority = 0;
    }
    return proc;
}
ffffffffc02047b4:	60a2                	ld	ra,8(sp)
ffffffffc02047b6:	8522                	mv	a0,s0
ffffffffc02047b8:	6402                	ld	s0,0(sp)
ffffffffc02047ba:	0141                	addi	sp,sp,16
ffffffffc02047bc:	8082                	ret

ffffffffc02047be <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc02047be:	000dc797          	auipc	a5,0xdc
ffffffffc02047c2:	9827b783          	ld	a5,-1662(a5) # ffffffffc02e0140 <current>
ffffffffc02047c6:	73c8                	ld	a0,160(a5)
ffffffffc02047c8:	feafc06f          	j	ffffffffc0200fb2 <forkrets>

ffffffffc02047cc <put_pgdir.isra.0>:
    return 0;
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
ffffffffc02047cc:	1141                	addi	sp,sp,-16
ffffffffc02047ce:	e406                	sd	ra,8(sp)
    return pa2page(PADDR(kva));
ffffffffc02047d0:	c02007b7          	lui	a5,0xc0200
ffffffffc02047d4:	02f56e63          	bltu	a0,a5,ffffffffc0204810 <put_pgdir.isra.0+0x44>
ffffffffc02047d8:	000dc697          	auipc	a3,0xdc
ffffffffc02047dc:	9606b683          	ld	a3,-1696(a3) # ffffffffc02e0138 <va_pa_offset>
ffffffffc02047e0:	8d15                	sub	a0,a0,a3
    if (PPN(pa) >= npage)
ffffffffc02047e2:	8131                	srli	a0,a0,0xc
ffffffffc02047e4:	000dc797          	auipc	a5,0xdc
ffffffffc02047e8:	93c7b783          	ld	a5,-1732(a5) # ffffffffc02e0120 <npage>
ffffffffc02047ec:	02f57f63          	bgeu	a0,a5,ffffffffc020482a <put_pgdir.isra.0+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02047f0:	00005697          	auipc	a3,0x5
ffffffffc02047f4:	c186b683          	ld	a3,-1000(a3) # ffffffffc0209408 <nbase>
{
    free_page(kva2page(mm->pgdir));
}
ffffffffc02047f8:	60a2                	ld	ra,8(sp)
ffffffffc02047fa:	8d15                	sub	a0,a0,a3
    free_page(kva2page(mm->pgdir));
ffffffffc02047fc:	000dc797          	auipc	a5,0xdc
ffffffffc0204800:	92c7b783          	ld	a5,-1748(a5) # ffffffffc02e0128 <pages>
ffffffffc0204804:	051a                	slli	a0,a0,0x6
ffffffffc0204806:	4585                	li	a1,1
ffffffffc0204808:	953e                	add	a0,a0,a5
}
ffffffffc020480a:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc020480c:	de9fd06f          	j	ffffffffc02025f4 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204810:	86aa                	mv	a3,a0
ffffffffc0204812:	00003617          	auipc	a2,0x3
ffffffffc0204816:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0207380 <commands+0xb58>
ffffffffc020481a:	07700593          	li	a1,119
ffffffffc020481e:	00003517          	auipc	a0,0x3
ffffffffc0204822:	ae250513          	addi	a0,a0,-1310 # ffffffffc0207300 <commands+0xad8>
ffffffffc0204826:	9fdfb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020482a:	00003617          	auipc	a2,0x3
ffffffffc020482e:	b7e60613          	addi	a2,a2,-1154 # ffffffffc02073a8 <commands+0xb80>
ffffffffc0204832:	06900593          	li	a1,105
ffffffffc0204836:	00003517          	auipc	a0,0x3
ffffffffc020483a:	aca50513          	addi	a0,a0,-1334 # ffffffffc0207300 <commands+0xad8>
ffffffffc020483e:	9e5fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0204842 <set_proc_name>:
{
ffffffffc0204842:	1101                	addi	sp,sp,-32
ffffffffc0204844:	e822                	sd	s0,16(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204846:	0b450413          	addi	s0,a0,180
{
ffffffffc020484a:	e426                	sd	s1,8(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020484c:	4641                	li	a2,16
{
ffffffffc020484e:	84ae                	mv	s1,a1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204850:	8522                	mv	a0,s0
ffffffffc0204852:	4581                	li	a1,0
{
ffffffffc0204854:	ec06                	sd	ra,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204856:	0f9010ef          	jal	ra,ffffffffc020614e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020485a:	8522                	mv	a0,s0
}
ffffffffc020485c:	6442                	ld	s0,16(sp)
ffffffffc020485e:	60e2                	ld	ra,24(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204860:	85a6                	mv	a1,s1
}
ffffffffc0204862:	64a2                	ld	s1,8(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204864:	463d                	li	a2,15
}
ffffffffc0204866:	6105                	addi	sp,sp,32
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204868:	0f90106f          	j	ffffffffc0206160 <memcpy>

ffffffffc020486c <proc_run>:
{
ffffffffc020486c:	7179                	addi	sp,sp,-48
ffffffffc020486e:	ec26                	sd	s1,24(sp)
        struct proc_struct *prev = current;
ffffffffc0204870:	000dc497          	auipc	s1,0xdc
ffffffffc0204874:	8d048493          	addi	s1,s1,-1840 # ffffffffc02e0140 <current>
{
ffffffffc0204878:	f022                	sd	s0,32(sp)
ffffffffc020487a:	e44e                	sd	s3,8(sp)
ffffffffc020487c:	f406                	sd	ra,40(sp)
        struct proc_struct *prev = current;
ffffffffc020487e:	0004b983          	ld	s3,0(s1)
{
ffffffffc0204882:	e84a                	sd	s2,16(sp)
ffffffffc0204884:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204886:	100027f3          	csrr	a5,sstatus
ffffffffc020488a:	8b89                	andi	a5,a5,2
ffffffffc020488c:	4901                	li	s2,0
ffffffffc020488e:	e7a9                	bnez	a5,ffffffffc02048d8 <proc_run+0x6c>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204890:	745c                	ld	a5,168(s0)
ffffffffc0204892:	577d                	li	a4,-1
ffffffffc0204894:	177e                	slli	a4,a4,0x3f
ffffffffc0204896:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc0204898:	e080                	sd	s0,0(s1)
ffffffffc020489a:	8fd9                	or	a5,a5,a4
ffffffffc020489c:	18079073          	csrw	satp,a5
        proc->runs++;
ffffffffc02048a0:	441c                	lw	a5,8(s0)
        proc->need_resched = 0;
ffffffffc02048a2:	00043c23          	sd	zero,24(s0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc02048a6:	03040593          	addi	a1,s0,48
        proc->runs++;
ffffffffc02048aa:	2785                	addiw	a5,a5,1
ffffffffc02048ac:	c41c                	sw	a5,8(s0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc02048ae:	03098513          	addi	a0,s3,48
ffffffffc02048b2:	df5ff0ef          	jal	ra,ffffffffc02046a6 <switch_to>
    if (flag) {
ffffffffc02048b6:	00091963          	bnez	s2,ffffffffc02048c8 <proc_run+0x5c>
}
ffffffffc02048ba:	70a2                	ld	ra,40(sp)
ffffffffc02048bc:	7402                	ld	s0,32(sp)
ffffffffc02048be:	64e2                	ld	s1,24(sp)
ffffffffc02048c0:	6942                	ld	s2,16(sp)
ffffffffc02048c2:	69a2                	ld	s3,8(sp)
ffffffffc02048c4:	6145                	addi	sp,sp,48
ffffffffc02048c6:	8082                	ret
ffffffffc02048c8:	7402                	ld	s0,32(sp)
ffffffffc02048ca:	70a2                	ld	ra,40(sp)
ffffffffc02048cc:	64e2                	ld	s1,24(sp)
ffffffffc02048ce:	6942                	ld	s2,16(sp)
ffffffffc02048d0:	69a2                	ld	s3,8(sp)
ffffffffc02048d2:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02048d4:	8dafc06f          	j	ffffffffc02009ae <intr_enable>
        intr_disable();
ffffffffc02048d8:	8dcfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02048dc:	4905                	li	s2,1
ffffffffc02048de:	bf4d                	j	ffffffffc0204890 <proc_run+0x24>

ffffffffc02048e0 <find_proc>:
    if (0 < pid && pid < MAX_PID)
ffffffffc02048e0:	6789                	lui	a5,0x2
ffffffffc02048e2:	fff5071b          	addiw	a4,a0,-1
ffffffffc02048e6:	17f9                	addi	a5,a5,-2
ffffffffc02048e8:	04e7e163          	bltu	a5,a4,ffffffffc020492a <find_proc+0x4a>
{
ffffffffc02048ec:	1141                	addi	sp,sp,-16
ffffffffc02048ee:	e022                	sd	s0,0(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02048f0:	45a9                	li	a1,10
ffffffffc02048f2:	842a                	mv	s0,a0
ffffffffc02048f4:	2501                	sext.w	a0,a0
{
ffffffffc02048f6:	e406                	sd	ra,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02048f8:	46f010ef          	jal	ra,ffffffffc0206566 <hash32>
ffffffffc02048fc:	02051793          	slli	a5,a0,0x20
ffffffffc0204900:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204904:	000d7797          	auipc	a5,0xd7
ffffffffc0204908:	7a478793          	addi	a5,a5,1956 # ffffffffc02dc0a8 <hash_list>
ffffffffc020490c:	953e                	add	a0,a0,a5
ffffffffc020490e:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204910:	a029                	j	ffffffffc020491a <find_proc+0x3a>
            if (proc->pid == pid)
ffffffffc0204912:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204916:	00870c63          	beq	a4,s0,ffffffffc020492e <find_proc+0x4e>
    return listelm->next;
ffffffffc020491a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020491c:	fef51be3          	bne	a0,a5,ffffffffc0204912 <find_proc+0x32>
}
ffffffffc0204920:	60a2                	ld	ra,8(sp)
ffffffffc0204922:	6402                	ld	s0,0(sp)
    return NULL;
ffffffffc0204924:	4501                	li	a0,0
}
ffffffffc0204926:	0141                	addi	sp,sp,16
ffffffffc0204928:	8082                	ret
    return NULL;
ffffffffc020492a:	4501                	li	a0,0
}
ffffffffc020492c:	8082                	ret
ffffffffc020492e:	60a2                	ld	ra,8(sp)
ffffffffc0204930:	6402                	ld	s0,0(sp)
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204932:	f2878513          	addi	a0,a5,-216
}
ffffffffc0204936:	0141                	addi	sp,sp,16
ffffffffc0204938:	8082                	ret

ffffffffc020493a <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
ffffffffc020493a:	7119                	addi	sp,sp,-128
ffffffffc020493c:	f4a6                	sd	s1,104(sp)
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc020493e:	000dc497          	auipc	s1,0xdc
ffffffffc0204942:	81a48493          	addi	s1,s1,-2022 # ffffffffc02e0158 <nr_process>
ffffffffc0204946:	4098                	lw	a4,0(s1)
{
ffffffffc0204948:	fc86                	sd	ra,120(sp)
ffffffffc020494a:	f8a2                	sd	s0,112(sp)
ffffffffc020494c:	f0ca                	sd	s2,96(sp)
ffffffffc020494e:	ecce                	sd	s3,88(sp)
ffffffffc0204950:	e8d2                	sd	s4,80(sp)
ffffffffc0204952:	e4d6                	sd	s5,72(sp)
ffffffffc0204954:	e0da                	sd	s6,64(sp)
ffffffffc0204956:	fc5e                	sd	s7,56(sp)
ffffffffc0204958:	f862                	sd	s8,48(sp)
ffffffffc020495a:	f466                	sd	s9,40(sp)
ffffffffc020495c:	f06a                	sd	s10,32(sp)
ffffffffc020495e:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204960:	6785                	lui	a5,0x1
ffffffffc0204962:	2ef75563          	bge	a4,a5,ffffffffc0204c4c <do_fork+0x312>
ffffffffc0204966:	8a2a                	mv	s4,a0
ffffffffc0204968:	892e                	mv	s2,a1
ffffffffc020496a:	89b2                	mv	s3,a2
     *    set_links:  set the relation links of process.  ALSO SEE: remove_links:  lean the relation links of process
     *    -------------------
     *    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
     *    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
     */
    proc = alloc_proc();
ffffffffc020496c:	dadff0ef          	jal	ra,ffffffffc0204718 <alloc_proc>
ffffffffc0204970:	842a                	mv	s0,a0
    if(proc==NULL)
ffffffffc0204972:	2c050663          	beqz	a0,ffffffffc0204c3e <do_fork+0x304>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204976:	4509                	li	a0,2
ffffffffc0204978:	c3ffd0ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
    if (page != NULL)
ffffffffc020497c:	2a050e63          	beqz	a0,ffffffffc0204c38 <do_fork+0x2fe>
    return page - pages + nbase;
ffffffffc0204980:	000dbc97          	auipc	s9,0xdb
ffffffffc0204984:	7a8c8c93          	addi	s9,s9,1960 # ffffffffc02e0128 <pages>
ffffffffc0204988:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc020498c:	000dbd17          	auipc	s10,0xdb
ffffffffc0204990:	794d0d13          	addi	s10,s10,1940 # ffffffffc02e0120 <npage>
    return page - pages + nbase;
ffffffffc0204994:	00005a97          	auipc	s5,0x5
ffffffffc0204998:	a74aba83          	ld	s5,-1420(s5) # ffffffffc0209408 <nbase>
ffffffffc020499c:	40d506b3          	sub	a3,a0,a3
ffffffffc02049a0:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02049a2:	5c7d                	li	s8,-1
ffffffffc02049a4:	000d3783          	ld	a5,0(s10)
    return page - pages + nbase;
ffffffffc02049a8:	96d6                	add	a3,a3,s5
    return KADDR(page2pa(page));
ffffffffc02049aa:	00cc5c13          	srli	s8,s8,0xc
ffffffffc02049ae:	0186f733          	and	a4,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc02049b2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02049b4:	2ef77463          	bgeu	a4,a5,ffffffffc0204c9c <do_fork+0x362>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc02049b8:	000dbb17          	auipc	s6,0xdb
ffffffffc02049bc:	788b0b13          	addi	s6,s6,1928 # ffffffffc02e0140 <current>
ffffffffc02049c0:	000b3303          	ld	t1,0(s6)
ffffffffc02049c4:	000dbd97          	auipc	s11,0xdb
ffffffffc02049c8:	774d8d93          	addi	s11,s11,1908 # ffffffffc02e0138 <va_pa_offset>
ffffffffc02049cc:	000db703          	ld	a4,0(s11)
ffffffffc02049d0:	02833b83          	ld	s7,40(t1) # 80028 <_binary_obj___user_matrix_out_size+0x736e8>
ffffffffc02049d4:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02049d6:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc02049d8:	020b8a63          	beqz	s7,ffffffffc0204a0c <do_fork+0xd2>
    if (clone_flags & CLONE_VM)
ffffffffc02049dc:	100a7a13          	andi	s4,s4,256
ffffffffc02049e0:	1a0a0163          	beqz	s4,ffffffffc0204b82 <do_fork+0x248>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc02049e4:	030ba683          	lw	a3,48(s7)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02049e8:	018bb703          	ld	a4,24(s7)
ffffffffc02049ec:	c0200637          	lui	a2,0xc0200
ffffffffc02049f0:	2685                	addiw	a3,a3,1
ffffffffc02049f2:	02dba823          	sw	a3,48(s7)
    proc->mm = mm;
ffffffffc02049f6:	03743423          	sd	s7,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02049fa:	2ac76d63          	bltu	a4,a2,ffffffffc0204cb4 <do_fork+0x37a>
ffffffffc02049fe:	000db603          	ld	a2,0(s11)
        goto bad_fork_cleanup_proc;
    if(copy_mm(clone_flags, proc)!=0)
        goto bad_fork_cleanup_kstack;

    copy_thread(proc, stack, tf);
    proc->parent = current;
ffffffffc0204a02:	000b3303          	ld	t1,0(s6)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204a06:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204a08:	8f11                	sub	a4,a4,a2
ffffffffc0204a0a:	f458                	sd	a4,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204a0c:	6789                	lui	a5,0x2
ffffffffc0204a0e:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8298>
ffffffffc0204a12:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204a14:	864e                	mv	a2,s3
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204a16:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc0204a18:	87b6                	mv	a5,a3
ffffffffc0204a1a:	12098893          	addi	a7,s3,288
ffffffffc0204a1e:	00063803          	ld	a6,0(a2) # ffffffffc0200000 <kern_entry>
ffffffffc0204a22:	6608                	ld	a0,8(a2)
ffffffffc0204a24:	6a0c                	ld	a1,16(a2)
ffffffffc0204a26:	6e18                	ld	a4,24(a2)
ffffffffc0204a28:	0107b023          	sd	a6,0(a5)
ffffffffc0204a2c:	e788                	sd	a0,8(a5)
ffffffffc0204a2e:	eb8c                	sd	a1,16(a5)
ffffffffc0204a30:	ef98                	sd	a4,24(a5)
ffffffffc0204a32:	02060613          	addi	a2,a2,32
ffffffffc0204a36:	02078793          	addi	a5,a5,32
ffffffffc0204a3a:	ff1612e3          	bne	a2,a7,ffffffffc0204a1e <do_fork+0xe4>
    proc->tf->gpr.a0 = 0;
ffffffffc0204a3e:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204a42:	12090e63          	beqz	s2,ffffffffc0204b7e <do_fork+0x244>
    assert(current->wait_state == 0);
ffffffffc0204a46:	0ec32783          	lw	a5,236(t1)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204a4a:	00000717          	auipc	a4,0x0
ffffffffc0204a4e:	d7470713          	addi	a4,a4,-652 # ffffffffc02047be <forkret>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204a52:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204a56:	f818                	sd	a4,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204a58:	fc14                	sd	a3,56(s0)
    proc->parent = current;
ffffffffc0204a5a:	02643023          	sd	t1,32(s0)
    assert(current->wait_state == 0);
ffffffffc0204a5e:	26079863          	bnez	a5,ffffffffc0204cce <do_fork+0x394>
    if (++last_pid >= MAX_PID)
ffffffffc0204a62:	000d7817          	auipc	a6,0xd7
ffffffffc0204a66:	0d680813          	addi	a6,a6,214 # ffffffffc02dbb38 <last_pid.1>
ffffffffc0204a6a:	00082783          	lw	a5,0(a6)
ffffffffc0204a6e:	6709                	lui	a4,0x2
ffffffffc0204a70:	0017851b          	addiw	a0,a5,1
ffffffffc0204a74:	00a82023          	sw	a0,0(a6)
ffffffffc0204a78:	08e55c63          	bge	a0,a4,ffffffffc0204b10 <do_fork+0x1d6>
    if (last_pid >= next_safe)
ffffffffc0204a7c:	000d7317          	auipc	t1,0xd7
ffffffffc0204a80:	0c030313          	addi	t1,t1,192 # ffffffffc02dbb3c <next_safe.0>
ffffffffc0204a84:	00032783          	lw	a5,0(t1)
ffffffffc0204a88:	000db917          	auipc	s2,0xdb
ffffffffc0204a8c:	62090913          	addi	s2,s2,1568 # ffffffffc02e00a8 <proc_list>
ffffffffc0204a90:	08f55863          	bge	a0,a5,ffffffffc0204b20 <do_fork+0x1e6>
    
    proc->pid = get_pid();
ffffffffc0204a94:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204a96:	45a9                	li	a1,10
ffffffffc0204a98:	2501                	sext.w	a0,a0
ffffffffc0204a9a:	2cd010ef          	jal	ra,ffffffffc0206566 <hash32>
ffffffffc0204a9e:	02051793          	slli	a5,a0,0x20
ffffffffc0204aa2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204aa6:	000d7797          	auipc	a5,0xd7
ffffffffc0204aaa:	60278793          	addi	a5,a5,1538 # ffffffffc02dc0a8 <hash_list>
ffffffffc0204aae:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204ab0:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204ab2:	7014                	ld	a3,32(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204ab4:	0d840793          	addi	a5,s0,216
    prev->next = next->prev = elm;
ffffffffc0204ab8:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204aba:	00893603          	ld	a2,8(s2)
    prev->next = next->prev = elm;
ffffffffc0204abe:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204ac0:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204ac2:	0c840793          	addi	a5,s0,200
    elm->next = next;
ffffffffc0204ac6:	f06c                	sd	a1,224(s0)
    elm->prev = prev;
ffffffffc0204ac8:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc0204aca:	e21c                	sd	a5,0(a2)
ffffffffc0204acc:	00f93423          	sd	a5,8(s2)
    elm->next = next;
ffffffffc0204ad0:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204ad2:	0d243423          	sd	s2,200(s0)
    proc->yptr = NULL;
ffffffffc0204ad6:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204ada:	10e43023          	sd	a4,256(s0)
ffffffffc0204ade:	c311                	beqz	a4,ffffffffc0204ae2 <do_fork+0x1a8>
        proc->optr->yptr = proc;
ffffffffc0204ae0:	ff60                	sd	s0,248(a4)
    nr_process++;
ffffffffc0204ae2:	409c                	lw	a5,0(s1)
    hash_proc(proc);
    set_links(proc);

    wakeup_proc(proc);
ffffffffc0204ae4:	8522                	mv	a0,s0
    proc->parent->cptr = proc;
ffffffffc0204ae6:	fae0                	sd	s0,240(a3)
    nr_process++;
ffffffffc0204ae8:	2785                	addiw	a5,a5,1
ffffffffc0204aea:	c09c                	sw	a5,0(s1)
    wakeup_proc(proc);
ffffffffc0204aec:	7d5000ef          	jal	ra,ffffffffc0205ac0 <wakeup_proc>

    ret = proc->pid;
ffffffffc0204af0:	4048                	lw	a0,4(s0)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc0204af2:	70e6                	ld	ra,120(sp)
ffffffffc0204af4:	7446                	ld	s0,112(sp)
ffffffffc0204af6:	74a6                	ld	s1,104(sp)
ffffffffc0204af8:	7906                	ld	s2,96(sp)
ffffffffc0204afa:	69e6                	ld	s3,88(sp)
ffffffffc0204afc:	6a46                	ld	s4,80(sp)
ffffffffc0204afe:	6aa6                	ld	s5,72(sp)
ffffffffc0204b00:	6b06                	ld	s6,64(sp)
ffffffffc0204b02:	7be2                	ld	s7,56(sp)
ffffffffc0204b04:	7c42                	ld	s8,48(sp)
ffffffffc0204b06:	7ca2                	ld	s9,40(sp)
ffffffffc0204b08:	7d02                	ld	s10,32(sp)
ffffffffc0204b0a:	6de2                	ld	s11,24(sp)
ffffffffc0204b0c:	6109                	addi	sp,sp,128
ffffffffc0204b0e:	8082                	ret
        last_pid = 1;
ffffffffc0204b10:	4785                	li	a5,1
ffffffffc0204b12:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc0204b16:	4505                	li	a0,1
ffffffffc0204b18:	000d7317          	auipc	t1,0xd7
ffffffffc0204b1c:	02430313          	addi	t1,t1,36 # ffffffffc02dbb3c <next_safe.0>
    return listelm->next;
ffffffffc0204b20:	000db917          	auipc	s2,0xdb
ffffffffc0204b24:	58890913          	addi	s2,s2,1416 # ffffffffc02e00a8 <proc_list>
ffffffffc0204b28:	00893e03          	ld	t3,8(s2)
        next_safe = MAX_PID;
ffffffffc0204b2c:	6789                	lui	a5,0x2
ffffffffc0204b2e:	00f32023          	sw	a5,0(t1)
ffffffffc0204b32:	86aa                	mv	a3,a0
ffffffffc0204b34:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204b36:	6e89                	lui	t4,0x2
ffffffffc0204b38:	112e0563          	beq	t3,s2,ffffffffc0204c42 <do_fork+0x308>
ffffffffc0204b3c:	88ae                	mv	a7,a1
ffffffffc0204b3e:	87f2                	mv	a5,t3
ffffffffc0204b40:	6609                	lui	a2,0x2
ffffffffc0204b42:	a811                	j	ffffffffc0204b56 <do_fork+0x21c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204b44:	00e6d663          	bge	a3,a4,ffffffffc0204b50 <do_fork+0x216>
ffffffffc0204b48:	00c75463          	bge	a4,a2,ffffffffc0204b50 <do_fork+0x216>
ffffffffc0204b4c:	863a                	mv	a2,a4
ffffffffc0204b4e:	4885                	li	a7,1
ffffffffc0204b50:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204b52:	01278d63          	beq	a5,s2,ffffffffc0204b6c <do_fork+0x232>
            if (proc->pid == last_pid)
ffffffffc0204b56:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x823c>
ffffffffc0204b5a:	fee695e3          	bne	a3,a4,ffffffffc0204b44 <do_fork+0x20a>
                if (++last_pid >= next_safe)
ffffffffc0204b5e:	2685                	addiw	a3,a3,1
ffffffffc0204b60:	08c6dd63          	bge	a3,a2,ffffffffc0204bfa <do_fork+0x2c0>
ffffffffc0204b64:	679c                	ld	a5,8(a5)
ffffffffc0204b66:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204b68:	ff2797e3          	bne	a5,s2,ffffffffc0204b56 <do_fork+0x21c>
ffffffffc0204b6c:	c581                	beqz	a1,ffffffffc0204b74 <do_fork+0x23a>
ffffffffc0204b6e:	00d82023          	sw	a3,0(a6)
ffffffffc0204b72:	8536                	mv	a0,a3
ffffffffc0204b74:	f20880e3          	beqz	a7,ffffffffc0204a94 <do_fork+0x15a>
ffffffffc0204b78:	00c32023          	sw	a2,0(t1)
ffffffffc0204b7c:	bf21                	j	ffffffffc0204a94 <do_fork+0x15a>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204b7e:	8936                	mv	s2,a3
ffffffffc0204b80:	b5d9                	j	ffffffffc0204a46 <do_fork+0x10c>
    if ((mm = mm_create()) == NULL)
ffffffffc0204b82:	c58fc0ef          	jal	ra,ffffffffc0200fda <mm_create>
ffffffffc0204b86:	e42a                	sd	a0,8(sp)
ffffffffc0204b88:	c149                	beqz	a0,ffffffffc0204c0a <do_fork+0x2d0>
    if ((page = alloc_page()) == NULL)
ffffffffc0204b8a:	4505                	li	a0,1
ffffffffc0204b8c:	a2bfd0ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc0204b90:	c935                	beqz	a0,ffffffffc0204c04 <do_fork+0x2ca>
    return page - pages + nbase;
ffffffffc0204b92:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204b96:	000d3703          	ld	a4,0(s10)
    return page - pages + nbase;
ffffffffc0204b9a:	40d506b3          	sub	a3,a0,a3
ffffffffc0204b9e:	8699                	srai	a3,a3,0x6
ffffffffc0204ba0:	96d6                	add	a3,a3,s5
    return KADDR(page2pa(page));
ffffffffc0204ba2:	0186fc33          	and	s8,a3,s8
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ba6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ba8:	0eec7a63          	bgeu	s8,a4,ffffffffc0204c9c <do_fork+0x362>
ffffffffc0204bac:	000dba03          	ld	s4,0(s11)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204bb0:	6605                	lui	a2,0x1
ffffffffc0204bb2:	000db597          	auipc	a1,0xdb
ffffffffc0204bb6:	5665b583          	ld	a1,1382(a1) # ffffffffc02e0118 <boot_pgdir_va>
ffffffffc0204bba:	9a36                	add	s4,s4,a3
ffffffffc0204bbc:	8552                	mv	a0,s4
ffffffffc0204bbe:	5a2010ef          	jal	ra,ffffffffc0206160 <memcpy>
    mm->pgdir = pgdir;
ffffffffc0204bc2:	67a2                	ld	a5,8(sp)
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        down(&(mm->mm_sem));
ffffffffc0204bc4:	038b8c13          	addi	s8,s7,56
ffffffffc0204bc8:	8562                	mv	a0,s8
ffffffffc0204bca:	0147bc23          	sd	s4,24(a5)
ffffffffc0204bce:	92bff0ef          	jal	ra,ffffffffc02044f8 <down>
        if (current != NULL)
ffffffffc0204bd2:	000b3703          	ld	a4,0(s6)
ffffffffc0204bd6:	c701                	beqz	a4,ffffffffc0204bde <do_fork+0x2a4>
        {
            mm->locked_by = current->pid;
ffffffffc0204bd8:	4358                	lw	a4,4(a4)
ffffffffc0204bda:	04eba823          	sw	a4,80(s7)
        ret = dup_mmap(mm, oldmm);
ffffffffc0204bde:	6522                	ld	a0,8(sp)
ffffffffc0204be0:	85de                	mv	a1,s7
ffffffffc0204be2:	e48fc0ef          	jal	ra,ffffffffc020122a <dup_mmap>
ffffffffc0204be6:	8a2a                	mv	s4,a0
static inline void
unlock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        up(&(mm->mm_sem));
ffffffffc0204be8:	8562                	mv	a0,s8
ffffffffc0204bea:	90bff0ef          	jal	ra,ffffffffc02044f4 <up>
        mm->locked_by = 0;
ffffffffc0204bee:	040ba823          	sw	zero,80(s7)
    if (ret != 0)
ffffffffc0204bf2:	080a1a63          	bnez	s4,ffffffffc0204c86 <do_fork+0x34c>
ffffffffc0204bf6:	6ba2                	ld	s7,8(sp)
ffffffffc0204bf8:	b3f5                	j	ffffffffc02049e4 <do_fork+0xaa>
                    if (last_pid >= MAX_PID)
ffffffffc0204bfa:	01d6c363          	blt	a3,t4,ffffffffc0204c00 <do_fork+0x2c6>
                        last_pid = 1;
ffffffffc0204bfe:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204c00:	4585                	li	a1,1
ffffffffc0204c02:	bf1d                	j	ffffffffc0204b38 <do_fork+0x1fe>
    mm_destroy(mm);
ffffffffc0204c04:	6522                	ld	a0,8(sp)
ffffffffc0204c06:	d22fc0ef          	jal	ra,ffffffffc0201128 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204c0a:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204c0c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204c10:	04f6ef63          	bltu	a3,a5,ffffffffc0204c6e <do_fork+0x334>
ffffffffc0204c14:	000db783          	ld	a5,0(s11)
    if (PPN(pa) >= npage)
ffffffffc0204c18:	000d3703          	ld	a4,0(s10)
    return pa2page(PADDR(kva));
ffffffffc0204c1c:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204c20:	83b1                	srli	a5,a5,0xc
ffffffffc0204c22:	02e7fa63          	bgeu	a5,a4,ffffffffc0204c56 <do_fork+0x31c>
    return &pages[PPN(pa) - nbase];
ffffffffc0204c26:	000cb503          	ld	a0,0(s9)
ffffffffc0204c2a:	415787b3          	sub	a5,a5,s5
ffffffffc0204c2e:	079a                	slli	a5,a5,0x6
ffffffffc0204c30:	4589                	li	a1,2
ffffffffc0204c32:	953e                	add	a0,a0,a5
ffffffffc0204c34:	9c1fd0ef          	jal	ra,ffffffffc02025f4 <free_pages>
    kfree(proc);
ffffffffc0204c38:	8522                	mv	a0,s0
ffffffffc0204c3a:	da1fc0ef          	jal	ra,ffffffffc02019da <kfree>
    ret = -E_NO_MEM;
ffffffffc0204c3e:	5571                	li	a0,-4
    return ret;
ffffffffc0204c40:	bd4d                	j	ffffffffc0204af2 <do_fork+0x1b8>
ffffffffc0204c42:	c599                	beqz	a1,ffffffffc0204c50 <do_fork+0x316>
ffffffffc0204c44:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204c48:	8536                	mv	a0,a3
ffffffffc0204c4a:	b5a9                	j	ffffffffc0204a94 <do_fork+0x15a>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204c4c:	556d                	li	a0,-5
ffffffffc0204c4e:	b555                	j	ffffffffc0204af2 <do_fork+0x1b8>
    return last_pid;
ffffffffc0204c50:	00082503          	lw	a0,0(a6)
ffffffffc0204c54:	b581                	j	ffffffffc0204a94 <do_fork+0x15a>
        panic("pa2page called with invalid pa");
ffffffffc0204c56:	00002617          	auipc	a2,0x2
ffffffffc0204c5a:	75260613          	addi	a2,a2,1874 # ffffffffc02073a8 <commands+0xb80>
ffffffffc0204c5e:	06900593          	li	a1,105
ffffffffc0204c62:	00002517          	auipc	a0,0x2
ffffffffc0204c66:	69e50513          	addi	a0,a0,1694 # ffffffffc0207300 <commands+0xad8>
ffffffffc0204c6a:	db8fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204c6e:	00002617          	auipc	a2,0x2
ffffffffc0204c72:	71260613          	addi	a2,a2,1810 # ffffffffc0207380 <commands+0xb58>
ffffffffc0204c76:	07700593          	li	a1,119
ffffffffc0204c7a:	00002517          	auipc	a0,0x2
ffffffffc0204c7e:	68650513          	addi	a0,a0,1670 # ffffffffc0207300 <commands+0xad8>
ffffffffc0204c82:	da0fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    exit_mmap(mm);
ffffffffc0204c86:	64a2                	ld	s1,8(sp)
ffffffffc0204c88:	8526                	mv	a0,s1
ffffffffc0204c8a:	e3afc0ef          	jal	ra,ffffffffc02012c4 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204c8e:	6c88                	ld	a0,24(s1)
ffffffffc0204c90:	b3dff0ef          	jal	ra,ffffffffc02047cc <put_pgdir.isra.0>
    mm_destroy(mm);
ffffffffc0204c94:	8526                	mv	a0,s1
ffffffffc0204c96:	c92fc0ef          	jal	ra,ffffffffc0201128 <mm_destroy>
ffffffffc0204c9a:	bf85                	j	ffffffffc0204c0a <do_fork+0x2d0>
    return KADDR(page2pa(page));
ffffffffc0204c9c:	00002617          	auipc	a2,0x2
ffffffffc0204ca0:	63c60613          	addi	a2,a2,1596 # ffffffffc02072d8 <commands+0xab0>
ffffffffc0204ca4:	07100593          	li	a1,113
ffffffffc0204ca8:	00002517          	auipc	a0,0x2
ffffffffc0204cac:	65850513          	addi	a0,a0,1624 # ffffffffc0207300 <commands+0xad8>
ffffffffc0204cb0:	d72fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204cb4:	86ba                	mv	a3,a4
ffffffffc0204cb6:	00002617          	auipc	a2,0x2
ffffffffc0204cba:	6ca60613          	addi	a2,a2,1738 # ffffffffc0207380 <commands+0xb58>
ffffffffc0204cbe:	1a400593          	li	a1,420
ffffffffc0204cc2:	00003517          	auipc	a0,0x3
ffffffffc0204cc6:	5fe50513          	addi	a0,a0,1534 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0204cca:	d58fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(current->wait_state == 0);
ffffffffc0204cce:	00003697          	auipc	a3,0x3
ffffffffc0204cd2:	60a68693          	addi	a3,a3,1546 # ffffffffc02082d8 <default_pmm_manager+0xb68>
ffffffffc0204cd6:	00002617          	auipc	a2,0x2
ffffffffc0204cda:	38a60613          	addi	a2,a2,906 # ffffffffc0207060 <commands+0x838>
ffffffffc0204cde:	1f800593          	li	a1,504
ffffffffc0204ce2:	00003517          	auipc	a0,0x3
ffffffffc0204ce6:	5de50513          	addi	a0,a0,1502 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0204cea:	d38fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0204cee <kernel_thread>:
{
ffffffffc0204cee:	7129                	addi	sp,sp,-320
ffffffffc0204cf0:	fa22                	sd	s0,304(sp)
ffffffffc0204cf2:	f626                	sd	s1,296(sp)
ffffffffc0204cf4:	f24a                	sd	s2,288(sp)
ffffffffc0204cf6:	84ae                	mv	s1,a1
ffffffffc0204cf8:	892a                	mv	s2,a0
ffffffffc0204cfa:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204cfc:	4581                	li	a1,0
ffffffffc0204cfe:	12000613          	li	a2,288
ffffffffc0204d02:	850a                	mv	a0,sp
{
ffffffffc0204d04:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204d06:	448010ef          	jal	ra,ffffffffc020614e <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204d0a:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204d0c:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204d0e:	100027f3          	csrr	a5,sstatus
ffffffffc0204d12:	edd7f793          	andi	a5,a5,-291
ffffffffc0204d16:	1207e793          	ori	a5,a5,288
ffffffffc0204d1a:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204d1c:	860a                	mv	a2,sp
ffffffffc0204d1e:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204d22:	00000797          	auipc	a5,0x0
ffffffffc0204d26:	9ee78793          	addi	a5,a5,-1554 # ffffffffc0204710 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204d2a:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204d2c:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204d2e:	c0dff0ef          	jal	ra,ffffffffc020493a <do_fork>
}
ffffffffc0204d32:	70f2                	ld	ra,312(sp)
ffffffffc0204d34:	7452                	ld	s0,304(sp)
ffffffffc0204d36:	74b2                	ld	s1,296(sp)
ffffffffc0204d38:	7912                	ld	s2,288(sp)
ffffffffc0204d3a:	6131                	addi	sp,sp,320
ffffffffc0204d3c:	8082                	ret

ffffffffc0204d3e <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc0204d3e:	7179                	addi	sp,sp,-48
ffffffffc0204d40:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204d42:	000db417          	auipc	s0,0xdb
ffffffffc0204d46:	3fe40413          	addi	s0,s0,1022 # ffffffffc02e0140 <current>
ffffffffc0204d4a:	601c                	ld	a5,0(s0)
{
ffffffffc0204d4c:	f406                	sd	ra,40(sp)
ffffffffc0204d4e:	ec26                	sd	s1,24(sp)
ffffffffc0204d50:	e84a                	sd	s2,16(sp)
ffffffffc0204d52:	e44e                	sd	s3,8(sp)
ffffffffc0204d54:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204d56:	000db717          	auipc	a4,0xdb
ffffffffc0204d5a:	3f273703          	ld	a4,1010(a4) # ffffffffc02e0148 <idleproc>
ffffffffc0204d5e:	0ce78c63          	beq	a5,a4,ffffffffc0204e36 <do_exit+0xf8>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204d62:	000db497          	auipc	s1,0xdb
ffffffffc0204d66:	3ee48493          	addi	s1,s1,1006 # ffffffffc02e0150 <initproc>
ffffffffc0204d6a:	6098                	ld	a4,0(s1)
ffffffffc0204d6c:	0ee78c63          	beq	a5,a4,ffffffffc0204e64 <do_exit+0x126>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc0204d70:	0287b983          	ld	s3,40(a5)
ffffffffc0204d74:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204d76:	02098663          	beqz	s3,ffffffffc0204da2 <do_exit+0x64>
ffffffffc0204d7a:	000db797          	auipc	a5,0xdb
ffffffffc0204d7e:	3967b783          	ld	a5,918(a5) # ffffffffc02e0110 <boot_pgdir_pa>
ffffffffc0204d82:	577d                	li	a4,-1
ffffffffc0204d84:	177e                	slli	a4,a4,0x3f
ffffffffc0204d86:	83b1                	srli	a5,a5,0xc
ffffffffc0204d88:	8fd9                	or	a5,a5,a4
ffffffffc0204d8a:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204d8e:	0309a783          	lw	a5,48(s3)
ffffffffc0204d92:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204d96:	02e9a823          	sw	a4,48(s3)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc0204d9a:	cb55                	beqz	a4,ffffffffc0204e4e <do_exit+0x110>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc0204d9c:	601c                	ld	a5,0(s0)
ffffffffc0204d9e:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc0204da2:	601c                	ld	a5,0(s0)
ffffffffc0204da4:	470d                	li	a4,3
ffffffffc0204da6:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204da8:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204dac:	100027f3          	csrr	a5,sstatus
ffffffffc0204db0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204db2:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204db4:	e7e1                	bnez	a5,ffffffffc0204e7c <do_exit+0x13e>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc0204db6:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204db8:	800007b7          	lui	a5,0x80000
ffffffffc0204dbc:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204dbe:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204dc0:	0ec52703          	lw	a4,236(a0)
ffffffffc0204dc4:	0cf70063          	beq	a4,a5,ffffffffc0204e84 <do_exit+0x146>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc0204dc8:	6018                	ld	a4,0(s0)
ffffffffc0204dca:	7b7c                	ld	a5,240(a4)
ffffffffc0204dcc:	c3a1                	beqz	a5,ffffffffc0204e0c <do_exit+0xce>
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204dce:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204dd2:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204dd4:	0985                	addi	s3,s3,1
ffffffffc0204dd6:	a021                	j	ffffffffc0204dde <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc0204dd8:	6018                	ld	a4,0(s0)
ffffffffc0204dda:	7b7c                	ld	a5,240(a4)
ffffffffc0204ddc:	cb85                	beqz	a5,ffffffffc0204e0c <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204dde:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_matrix_out_size+0xffffffff7fff37c0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204de2:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204de4:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204de6:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc0204de8:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204dec:	10e7b023          	sd	a4,256(a5)
ffffffffc0204df0:	c311                	beqz	a4,ffffffffc0204df4 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc0204df2:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204df4:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204df6:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0204df8:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204dfa:	fd271fe3          	bne	a4,s2,ffffffffc0204dd8 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204dfe:	0ec52783          	lw	a5,236(a0)
ffffffffc0204e02:	fd379be3          	bne	a5,s3,ffffffffc0204dd8 <do_exit+0x9a>
                {
                    wakeup_proc(initproc);
ffffffffc0204e06:	4bb000ef          	jal	ra,ffffffffc0205ac0 <wakeup_proc>
ffffffffc0204e0a:	b7f9                	j	ffffffffc0204dd8 <do_exit+0x9a>
    if (flag) {
ffffffffc0204e0c:	020a1263          	bnez	s4,ffffffffc0204e30 <do_exit+0xf2>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc0204e10:	563000ef          	jal	ra,ffffffffc0205b72 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204e14:	601c                	ld	a5,0(s0)
ffffffffc0204e16:	00003617          	auipc	a2,0x3
ffffffffc0204e1a:	50260613          	addi	a2,a2,1282 # ffffffffc0208318 <default_pmm_manager+0xba8>
ffffffffc0204e1e:	24800593          	li	a1,584
ffffffffc0204e22:	43d4                	lw	a3,4(a5)
ffffffffc0204e24:	00003517          	auipc	a0,0x3
ffffffffc0204e28:	49c50513          	addi	a0,a0,1180 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0204e2c:	bf6fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        intr_enable();
ffffffffc0204e30:	b7ffb0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204e34:	bff1                	j	ffffffffc0204e10 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204e36:	00003617          	auipc	a2,0x3
ffffffffc0204e3a:	4c260613          	addi	a2,a2,1218 # ffffffffc02082f8 <default_pmm_manager+0xb88>
ffffffffc0204e3e:	21400593          	li	a1,532
ffffffffc0204e42:	00003517          	auipc	a0,0x3
ffffffffc0204e46:	47e50513          	addi	a0,a0,1150 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0204e4a:	bd8fb0ef          	jal	ra,ffffffffc0200222 <__panic>
            exit_mmap(mm);
ffffffffc0204e4e:	854e                	mv	a0,s3
ffffffffc0204e50:	c74fc0ef          	jal	ra,ffffffffc02012c4 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e54:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_obj___user_matrix_out_size+0xffffffff7fff36d8>
ffffffffc0204e58:	975ff0ef          	jal	ra,ffffffffc02047cc <put_pgdir.isra.0>
            mm_destroy(mm);
ffffffffc0204e5c:	854e                	mv	a0,s3
ffffffffc0204e5e:	acafc0ef          	jal	ra,ffffffffc0201128 <mm_destroy>
ffffffffc0204e62:	bf2d                	j	ffffffffc0204d9c <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204e64:	00003617          	auipc	a2,0x3
ffffffffc0204e68:	4a460613          	addi	a2,a2,1188 # ffffffffc0208308 <default_pmm_manager+0xb98>
ffffffffc0204e6c:	21800593          	li	a1,536
ffffffffc0204e70:	00003517          	auipc	a0,0x3
ffffffffc0204e74:	45050513          	addi	a0,a0,1104 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0204e78:	baafb0ef          	jal	ra,ffffffffc0200222 <__panic>
        intr_disable();
ffffffffc0204e7c:	b39fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204e80:	4a05                	li	s4,1
ffffffffc0204e82:	bf15                	j	ffffffffc0204db6 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204e84:	43d000ef          	jal	ra,ffffffffc0205ac0 <wakeup_proc>
ffffffffc0204e88:	b781                	j	ffffffffc0204dc8 <do_exit+0x8a>

ffffffffc0204e8a <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc0204e8a:	715d                	addi	sp,sp,-80
ffffffffc0204e8c:	f84a                	sd	s2,48(sp)
ffffffffc0204e8e:	f44e                	sd	s3,40(sp)
        }
    }
    if (haskid)
    {
        current->state = PROC_SLEEPING;
        current->wait_state = WT_CHILD;
ffffffffc0204e90:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e94:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204e96:	fc26                	sd	s1,56(sp)
ffffffffc0204e98:	f052                	sd	s4,32(sp)
ffffffffc0204e9a:	ec56                	sd	s5,24(sp)
ffffffffc0204e9c:	e85a                	sd	s6,16(sp)
ffffffffc0204e9e:	e45e                	sd	s7,8(sp)
ffffffffc0204ea0:	e486                	sd	ra,72(sp)
ffffffffc0204ea2:	e0a2                	sd	s0,64(sp)
ffffffffc0204ea4:	84aa                	mv	s1,a0
ffffffffc0204ea6:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204ea8:	000dbb97          	auipc	s7,0xdb
ffffffffc0204eac:	298b8b93          	addi	s7,s7,664 # ffffffffc02e0140 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204eb0:	00050b1b          	sext.w	s6,a0
ffffffffc0204eb4:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204eb8:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204eba:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204ebc:	ccbd                	beqz	s1,ffffffffc0204f3a <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ebe:	0359e863          	bltu	s3,s5,ffffffffc0204eee <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ec2:	45a9                	li	a1,10
ffffffffc0204ec4:	855a                	mv	a0,s6
ffffffffc0204ec6:	6a0010ef          	jal	ra,ffffffffc0206566 <hash32>
ffffffffc0204eca:	02051793          	slli	a5,a0,0x20
ffffffffc0204ece:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204ed2:	000d7797          	auipc	a5,0xd7
ffffffffc0204ed6:	1d678793          	addi	a5,a5,470 # ffffffffc02dc0a8 <hash_list>
ffffffffc0204eda:	953e                	add	a0,a0,a5
ffffffffc0204edc:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0204ede:	a029                	j	ffffffffc0204ee8 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204ee0:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204ee4:	02978163          	beq	a5,s1,ffffffffc0204f06 <do_wait.part.0+0x7c>
ffffffffc0204ee8:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc0204eea:	fe851be3          	bne	a0,s0,ffffffffc0204ee0 <do_wait.part.0+0x56>
        {
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
    return -E_BAD_PROC;
ffffffffc0204eee:	5579                	li	a0,-2
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc0204ef0:	60a6                	ld	ra,72(sp)
ffffffffc0204ef2:	6406                	ld	s0,64(sp)
ffffffffc0204ef4:	74e2                	ld	s1,56(sp)
ffffffffc0204ef6:	7942                	ld	s2,48(sp)
ffffffffc0204ef8:	79a2                	ld	s3,40(sp)
ffffffffc0204efa:	7a02                	ld	s4,32(sp)
ffffffffc0204efc:	6ae2                	ld	s5,24(sp)
ffffffffc0204efe:	6b42                	ld	s6,16(sp)
ffffffffc0204f00:	6ba2                	ld	s7,8(sp)
ffffffffc0204f02:	6161                	addi	sp,sp,80
ffffffffc0204f04:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204f06:	000bb683          	ld	a3,0(s7)
ffffffffc0204f0a:	f4843783          	ld	a5,-184(s0)
ffffffffc0204f0e:	fed790e3          	bne	a5,a3,ffffffffc0204eee <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204f12:	f2842703          	lw	a4,-216(s0)
ffffffffc0204f16:	478d                	li	a5,3
ffffffffc0204f18:	0ef70b63          	beq	a4,a5,ffffffffc020500e <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0204f1c:	4785                	li	a5,1
ffffffffc0204f1e:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204f20:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204f24:	44f000ef          	jal	ra,ffffffffc0205b72 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204f28:	000bb783          	ld	a5,0(s7)
ffffffffc0204f2c:	0b07a783          	lw	a5,176(a5)
ffffffffc0204f30:	8b85                	andi	a5,a5,1
ffffffffc0204f32:	d7c9                	beqz	a5,ffffffffc0204ebc <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204f34:	555d                	li	a0,-9
ffffffffc0204f36:	e09ff0ef          	jal	ra,ffffffffc0204d3e <do_exit>
        proc = current->cptr;
ffffffffc0204f3a:	000bb683          	ld	a3,0(s7)
ffffffffc0204f3e:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204f40:	d45d                	beqz	s0,ffffffffc0204eee <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204f42:	470d                	li	a4,3
ffffffffc0204f44:	a021                	j	ffffffffc0204f4c <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204f46:	10043403          	ld	s0,256(s0)
ffffffffc0204f4a:	d869                	beqz	s0,ffffffffc0204f1c <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204f4c:	401c                	lw	a5,0(s0)
ffffffffc0204f4e:	fee79ce3          	bne	a5,a4,ffffffffc0204f46 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204f52:	000db797          	auipc	a5,0xdb
ffffffffc0204f56:	1f67b783          	ld	a5,502(a5) # ffffffffc02e0148 <idleproc>
ffffffffc0204f5a:	0c878963          	beq	a5,s0,ffffffffc020502c <do_wait.part.0+0x1a2>
ffffffffc0204f5e:	000db797          	auipc	a5,0xdb
ffffffffc0204f62:	1f27b783          	ld	a5,498(a5) # ffffffffc02e0150 <initproc>
ffffffffc0204f66:	0cf40363          	beq	s0,a5,ffffffffc020502c <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204f6a:	000a0663          	beqz	s4,ffffffffc0204f76 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204f6e:	0e842783          	lw	a5,232(s0)
ffffffffc0204f72:	00fa2023          	sw	a5,0(s4)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204f76:	100027f3          	csrr	a5,sstatus
ffffffffc0204f7a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204f7c:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204f7e:	e7c1                	bnez	a5,ffffffffc0205006 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204f80:	6c70                	ld	a2,216(s0)
ffffffffc0204f82:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204f84:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204f88:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204f8a:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204f8c:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204f8e:	6470                	ld	a2,200(s0)
ffffffffc0204f90:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204f92:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204f94:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204f96:	c319                	beqz	a4,ffffffffc0204f9c <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204f98:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204f9a:	7c7c                	ld	a5,248(s0)
ffffffffc0204f9c:	c3b5                	beqz	a5,ffffffffc0205000 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204f9e:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204fa2:	000db717          	auipc	a4,0xdb
ffffffffc0204fa6:	1b670713          	addi	a4,a4,438 # ffffffffc02e0158 <nr_process>
ffffffffc0204faa:	431c                	lw	a5,0(a4)
ffffffffc0204fac:	37fd                	addiw	a5,a5,-1
ffffffffc0204fae:	c31c                	sw	a5,0(a4)
    if (flag) {
ffffffffc0204fb0:	e5a9                	bnez	a1,ffffffffc0204ffa <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204fb2:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204fb4:	c02007b7          	lui	a5,0xc0200
ffffffffc0204fb8:	04f6ee63          	bltu	a3,a5,ffffffffc0205014 <do_wait.part.0+0x18a>
ffffffffc0204fbc:	000db797          	auipc	a5,0xdb
ffffffffc0204fc0:	17c7b783          	ld	a5,380(a5) # ffffffffc02e0138 <va_pa_offset>
ffffffffc0204fc4:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204fc6:	82b1                	srli	a3,a3,0xc
ffffffffc0204fc8:	000db797          	auipc	a5,0xdb
ffffffffc0204fcc:	1587b783          	ld	a5,344(a5) # ffffffffc02e0120 <npage>
ffffffffc0204fd0:	06f6fa63          	bgeu	a3,a5,ffffffffc0205044 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204fd4:	00004517          	auipc	a0,0x4
ffffffffc0204fd8:	43453503          	ld	a0,1076(a0) # ffffffffc0209408 <nbase>
ffffffffc0204fdc:	8e89                	sub	a3,a3,a0
ffffffffc0204fde:	069a                	slli	a3,a3,0x6
ffffffffc0204fe0:	000db517          	auipc	a0,0xdb
ffffffffc0204fe4:	14853503          	ld	a0,328(a0) # ffffffffc02e0128 <pages>
ffffffffc0204fe8:	9536                	add	a0,a0,a3
ffffffffc0204fea:	4589                	li	a1,2
ffffffffc0204fec:	e08fd0ef          	jal	ra,ffffffffc02025f4 <free_pages>
    kfree(proc);
ffffffffc0204ff0:	8522                	mv	a0,s0
ffffffffc0204ff2:	9e9fc0ef          	jal	ra,ffffffffc02019da <kfree>
    return 0;
ffffffffc0204ff6:	4501                	li	a0,0
ffffffffc0204ff8:	bde5                	j	ffffffffc0204ef0 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc0204ffa:	9b5fb0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204ffe:	bf55                	j	ffffffffc0204fb2 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc0205000:	701c                	ld	a5,32(s0)
ffffffffc0205002:	fbf8                	sd	a4,240(a5)
ffffffffc0205004:	bf79                	j	ffffffffc0204fa2 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc0205006:	9affb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020500a:	4585                	li	a1,1
ffffffffc020500c:	bf95                	j	ffffffffc0204f80 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020500e:	f2840413          	addi	s0,s0,-216
ffffffffc0205012:	b781                	j	ffffffffc0204f52 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0205014:	00002617          	auipc	a2,0x2
ffffffffc0205018:	36c60613          	addi	a2,a2,876 # ffffffffc0207380 <commands+0xb58>
ffffffffc020501c:	07700593          	li	a1,119
ffffffffc0205020:	00002517          	auipc	a0,0x2
ffffffffc0205024:	2e050513          	addi	a0,a0,736 # ffffffffc0207300 <commands+0xad8>
ffffffffc0205028:	9fafb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc020502c:	00003617          	auipc	a2,0x3
ffffffffc0205030:	30c60613          	addi	a2,a2,780 # ffffffffc0208338 <default_pmm_manager+0xbc8>
ffffffffc0205034:	37200593          	li	a1,882
ffffffffc0205038:	00003517          	auipc	a0,0x3
ffffffffc020503c:	28850513          	addi	a0,a0,648 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205040:	9e2fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0205044:	00002617          	auipc	a2,0x2
ffffffffc0205048:	36460613          	addi	a2,a2,868 # ffffffffc02073a8 <commands+0xb80>
ffffffffc020504c:	06900593          	li	a1,105
ffffffffc0205050:	00002517          	auipc	a0,0x2
ffffffffc0205054:	2b050513          	addi	a0,a0,688 # ffffffffc0207300 <commands+0xad8>
ffffffffc0205058:	9cafb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020505c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020505c:	1141                	addi	sp,sp,-16
ffffffffc020505e:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0205060:	dd4fd0ef          	jal	ra,ffffffffc0202634 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0205064:	8c3fc0ef          	jal	ra,ffffffffc0201926 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0205068:	4601                	li	a2,0
ffffffffc020506a:	4581                	li	a1,0
ffffffffc020506c:	00000517          	auipc	a0,0x0
ffffffffc0205070:	63250513          	addi	a0,a0,1586 # ffffffffc020569e <user_main>
ffffffffc0205074:	c7bff0ef          	jal	ra,ffffffffc0204cee <kernel_thread>
    if (pid <= 0)
ffffffffc0205078:	08a05a63          	blez	a0,ffffffffc020510c <init_main+0xb0>
    {
        panic("create user_main failed.\n");
    }
    extern void check_sync(void);
    check_sync(); // check philosopher sync problem
ffffffffc020507c:	888ff0ef          	jal	ra,ffffffffc0204104 <check_sync>

    while (do_wait(0, NULL) == 0)
ffffffffc0205080:	a019                	j	ffffffffc0205086 <init_main+0x2a>
    {
        schedule();
ffffffffc0205082:	2f1000ef          	jal	ra,ffffffffc0205b72 <schedule>
    if (code_store != NULL)
ffffffffc0205086:	4581                	li	a1,0
ffffffffc0205088:	4501                	li	a0,0
ffffffffc020508a:	e01ff0ef          	jal	ra,ffffffffc0204e8a <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020508e:	d975                	beqz	a0,ffffffffc0205082 <init_main+0x26>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0205090:	00003517          	auipc	a0,0x3
ffffffffc0205094:	2e850513          	addi	a0,a0,744 # ffffffffc0208378 <default_pmm_manager+0xc08>
ffffffffc0205098:	84cfb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020509c:	000db797          	auipc	a5,0xdb
ffffffffc02050a0:	0b47b783          	ld	a5,180(a5) # ffffffffc02e0150 <initproc>
ffffffffc02050a4:	7bf8                	ld	a4,240(a5)
ffffffffc02050a6:	e339                	bnez	a4,ffffffffc02050ec <init_main+0x90>
ffffffffc02050a8:	7ff8                	ld	a4,248(a5)
ffffffffc02050aa:	e329                	bnez	a4,ffffffffc02050ec <init_main+0x90>
ffffffffc02050ac:	1007b703          	ld	a4,256(a5)
ffffffffc02050b0:	ef15                	bnez	a4,ffffffffc02050ec <init_main+0x90>
    assert(nr_process == 2);
ffffffffc02050b2:	000db697          	auipc	a3,0xdb
ffffffffc02050b6:	0a66a683          	lw	a3,166(a3) # ffffffffc02e0158 <nr_process>
ffffffffc02050ba:	4709                	li	a4,2
ffffffffc02050bc:	0ae69463          	bne	a3,a4,ffffffffc0205164 <init_main+0x108>
    return listelm->next;
ffffffffc02050c0:	000db697          	auipc	a3,0xdb
ffffffffc02050c4:	fe868693          	addi	a3,a3,-24 # ffffffffc02e00a8 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02050c8:	6698                	ld	a4,8(a3)
ffffffffc02050ca:	0c878793          	addi	a5,a5,200
ffffffffc02050ce:	06f71b63          	bne	a4,a5,ffffffffc0205144 <init_main+0xe8>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02050d2:	629c                	ld	a5,0(a3)
ffffffffc02050d4:	04f71863          	bne	a4,a5,ffffffffc0205124 <init_main+0xc8>

    cprintf("init check memory pass.\n");
ffffffffc02050d8:	00003517          	auipc	a0,0x3
ffffffffc02050dc:	38850513          	addi	a0,a0,904 # ffffffffc0208460 <default_pmm_manager+0xcf0>
ffffffffc02050e0:	804fb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return 0;
}
ffffffffc02050e4:	60a2                	ld	ra,8(sp)
ffffffffc02050e6:	4501                	li	a0,0
ffffffffc02050e8:	0141                	addi	sp,sp,16
ffffffffc02050ea:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02050ec:	00003697          	auipc	a3,0x3
ffffffffc02050f0:	2b468693          	addi	a3,a3,692 # ffffffffc02083a0 <default_pmm_manager+0xc30>
ffffffffc02050f4:	00002617          	auipc	a2,0x2
ffffffffc02050f8:	f6c60613          	addi	a2,a2,-148 # ffffffffc0207060 <commands+0x838>
ffffffffc02050fc:	3e100593          	li	a1,993
ffffffffc0205100:	00003517          	auipc	a0,0x3
ffffffffc0205104:	1c050513          	addi	a0,a0,448 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205108:	91afb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("create user_main failed.\n");
ffffffffc020510c:	00003617          	auipc	a2,0x3
ffffffffc0205110:	24c60613          	addi	a2,a2,588 # ffffffffc0208358 <default_pmm_manager+0xbe8>
ffffffffc0205114:	3d600593          	li	a1,982
ffffffffc0205118:	00003517          	auipc	a0,0x3
ffffffffc020511c:	1a850513          	addi	a0,a0,424 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205120:	902fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0205124:	00003697          	auipc	a3,0x3
ffffffffc0205128:	30c68693          	addi	a3,a3,780 # ffffffffc0208430 <default_pmm_manager+0xcc0>
ffffffffc020512c:	00002617          	auipc	a2,0x2
ffffffffc0205130:	f3460613          	addi	a2,a2,-204 # ffffffffc0207060 <commands+0x838>
ffffffffc0205134:	3e400593          	li	a1,996
ffffffffc0205138:	00003517          	auipc	a0,0x3
ffffffffc020513c:	18850513          	addi	a0,a0,392 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205140:	8e2fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0205144:	00003697          	auipc	a3,0x3
ffffffffc0205148:	2bc68693          	addi	a3,a3,700 # ffffffffc0208400 <default_pmm_manager+0xc90>
ffffffffc020514c:	00002617          	auipc	a2,0x2
ffffffffc0205150:	f1460613          	addi	a2,a2,-236 # ffffffffc0207060 <commands+0x838>
ffffffffc0205154:	3e300593          	li	a1,995
ffffffffc0205158:	00003517          	auipc	a0,0x3
ffffffffc020515c:	16850513          	addi	a0,a0,360 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205160:	8c2fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_process == 2);
ffffffffc0205164:	00003697          	auipc	a3,0x3
ffffffffc0205168:	28c68693          	addi	a3,a3,652 # ffffffffc02083f0 <default_pmm_manager+0xc80>
ffffffffc020516c:	00002617          	auipc	a2,0x2
ffffffffc0205170:	ef460613          	addi	a2,a2,-268 # ffffffffc0207060 <commands+0x838>
ffffffffc0205174:	3e200593          	li	a1,994
ffffffffc0205178:	00003517          	auipc	a0,0x3
ffffffffc020517c:	14850513          	addi	a0,a0,328 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205180:	8a2fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205184 <do_execve>:
{
ffffffffc0205184:	7171                	addi	sp,sp,-176
ffffffffc0205186:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205188:	000dbd97          	auipc	s11,0xdb
ffffffffc020518c:	fb8d8d93          	addi	s11,s11,-72 # ffffffffc02e0140 <current>
ffffffffc0205190:	000db783          	ld	a5,0(s11)
{
ffffffffc0205194:	e54e                	sd	s3,136(sp)
ffffffffc0205196:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205198:	0287b983          	ld	s3,40(a5)
{
ffffffffc020519c:	e94a                	sd	s2,144(sp)
ffffffffc020519e:	f4de                	sd	s7,104(sp)
ffffffffc02051a0:	892a                	mv	s2,a0
ffffffffc02051a2:	8bb2                	mv	s7,a2
ffffffffc02051a4:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02051a6:	862e                	mv	a2,a1
ffffffffc02051a8:	4681                	li	a3,0
ffffffffc02051aa:	85aa                	mv	a1,a0
ffffffffc02051ac:	854e                	mv	a0,s3
{
ffffffffc02051ae:	f506                	sd	ra,168(sp)
ffffffffc02051b0:	f122                	sd	s0,160(sp)
ffffffffc02051b2:	e152                	sd	s4,128(sp)
ffffffffc02051b4:	fcd6                	sd	s5,120(sp)
ffffffffc02051b6:	f8da                	sd	s6,112(sp)
ffffffffc02051b8:	f0e2                	sd	s8,96(sp)
ffffffffc02051ba:	ece6                	sd	s9,88(sp)
ffffffffc02051bc:	e8ea                	sd	s10,80(sp)
ffffffffc02051be:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02051c0:	ca4fc0ef          	jal	ra,ffffffffc0201664 <user_mem_check>
ffffffffc02051c4:	40050d63          	beqz	a0,ffffffffc02055de <do_execve+0x45a>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02051c8:	4641                	li	a2,16
ffffffffc02051ca:	4581                	li	a1,0
ffffffffc02051cc:	1808                	addi	a0,sp,48
ffffffffc02051ce:	781000ef          	jal	ra,ffffffffc020614e <memset>
    memcpy(local_name, name, len);
ffffffffc02051d2:	47bd                	li	a5,15
ffffffffc02051d4:	8626                	mv	a2,s1
ffffffffc02051d6:	1e97e463          	bltu	a5,s1,ffffffffc02053be <do_execve+0x23a>
ffffffffc02051da:	85ca                	mv	a1,s2
ffffffffc02051dc:	1808                	addi	a0,sp,48
ffffffffc02051de:	783000ef          	jal	ra,ffffffffc0206160 <memcpy>
    if (mm != NULL)
ffffffffc02051e2:	1e098563          	beqz	s3,ffffffffc02053cc <do_execve+0x248>
        cputs("mm != NULL");
ffffffffc02051e6:	00002517          	auipc	a0,0x2
ffffffffc02051ea:	f1a50513          	addi	a0,a0,-230 # ffffffffc0207100 <commands+0x8d8>
ffffffffc02051ee:	f31fa0ef          	jal	ra,ffffffffc020011e <cputs>
ffffffffc02051f2:	000db797          	auipc	a5,0xdb
ffffffffc02051f6:	f1e7b783          	ld	a5,-226(a5) # ffffffffc02e0110 <boot_pgdir_pa>
ffffffffc02051fa:	577d                	li	a4,-1
ffffffffc02051fc:	177e                	slli	a4,a4,0x3f
ffffffffc02051fe:	83b1                	srli	a5,a5,0xc
ffffffffc0205200:	8fd9                	or	a5,a5,a4
ffffffffc0205202:	18079073          	csrw	satp,a5
ffffffffc0205206:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x8148>
ffffffffc020520a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020520e:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0205212:	2c070663          	beqz	a4,ffffffffc02054de <do_execve+0x35a>
        current->mm = NULL;
ffffffffc0205216:	000db783          	ld	a5,0(s11)
ffffffffc020521a:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc020521e:	dbdfb0ef          	jal	ra,ffffffffc0200fda <mm_create>
ffffffffc0205222:	84aa                	mv	s1,a0
ffffffffc0205224:	1c050f63          	beqz	a0,ffffffffc0205402 <do_execve+0x27e>
    if ((page = alloc_page()) == NULL)
ffffffffc0205228:	4505                	li	a0,1
ffffffffc020522a:	b8cfd0ef          	jal	ra,ffffffffc02025b6 <alloc_pages>
ffffffffc020522e:	3a050c63          	beqz	a0,ffffffffc02055e6 <do_execve+0x462>
    return page - pages + nbase;
ffffffffc0205232:	000dbc97          	auipc	s9,0xdb
ffffffffc0205236:	ef6c8c93          	addi	s9,s9,-266 # ffffffffc02e0128 <pages>
ffffffffc020523a:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc020523e:	000dbc17          	auipc	s8,0xdb
ffffffffc0205242:	ee2c0c13          	addi	s8,s8,-286 # ffffffffc02e0120 <npage>
    return page - pages + nbase;
ffffffffc0205246:	00004717          	auipc	a4,0x4
ffffffffc020524a:	1c273703          	ld	a4,450(a4) # ffffffffc0209408 <nbase>
ffffffffc020524e:	40d506b3          	sub	a3,a0,a3
ffffffffc0205252:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0205254:	5afd                	li	s5,-1
ffffffffc0205256:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc020525a:	96ba                	add	a3,a3,a4
ffffffffc020525c:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc020525e:	00cad713          	srli	a4,s5,0xc
ffffffffc0205262:	ec3a                	sd	a4,24(sp)
ffffffffc0205264:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0205266:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205268:	38f77363          	bgeu	a4,a5,ffffffffc02055ee <do_execve+0x46a>
ffffffffc020526c:	000dbb17          	auipc	s6,0xdb
ffffffffc0205270:	eccb0b13          	addi	s6,s6,-308 # ffffffffc02e0138 <va_pa_offset>
ffffffffc0205274:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0205278:	6605                	lui	a2,0x1
ffffffffc020527a:	000db597          	auipc	a1,0xdb
ffffffffc020527e:	e9e5b583          	ld	a1,-354(a1) # ffffffffc02e0118 <boot_pgdir_va>
ffffffffc0205282:	9936                	add	s2,s2,a3
ffffffffc0205284:	854a                	mv	a0,s2
ffffffffc0205286:	6db000ef          	jal	ra,ffffffffc0206160 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020528a:	7782                	ld	a5,32(sp)
ffffffffc020528c:	4398                	lw	a4,0(a5)
ffffffffc020528e:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0205292:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0205296:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b7c3f>
ffffffffc020529a:	14f71a63          	bne	a4,a5,ffffffffc02053ee <do_execve+0x26a>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020529e:	7682                	ld	a3,32(sp)
ffffffffc02052a0:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02052a4:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02052a8:	00371793          	slli	a5,a4,0x3
ffffffffc02052ac:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc02052ae:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc02052b0:	078e                	slli	a5,a5,0x3
ffffffffc02052b2:	97ce                	add	a5,a5,s3
ffffffffc02052b4:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc02052b6:	00f9fc63          	bgeu	s3,a5,ffffffffc02052ce <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc02052ba:	0009a783          	lw	a5,0(s3)
ffffffffc02052be:	4705                	li	a4,1
ffffffffc02052c0:	14e78363          	beq	a5,a4,ffffffffc0205406 <do_execve+0x282>
    for (; ph < ph_end; ph++)
ffffffffc02052c4:	77a2                	ld	a5,40(sp)
ffffffffc02052c6:	03898993          	addi	s3,s3,56
ffffffffc02052ca:	fef9e8e3          	bltu	s3,a5,ffffffffc02052ba <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc02052ce:	4701                	li	a4,0
ffffffffc02052d0:	46ad                	li	a3,11
ffffffffc02052d2:	00100637          	lui	a2,0x100
ffffffffc02052d6:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02052da:	8526                	mv	a0,s1
ffffffffc02052dc:	e9ffb0ef          	jal	ra,ffffffffc020117a <mm_map>
ffffffffc02052e0:	8a2a                	mv	s4,a0
ffffffffc02052e2:	1e051463          	bnez	a0,ffffffffc02054ca <do_execve+0x346>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02052e6:	6c88                	ld	a0,24(s1)
ffffffffc02052e8:	467d                	li	a2,31
ffffffffc02052ea:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02052ee:	a07fe0ef          	jal	ra,ffffffffc0203cf4 <pgdir_alloc_page>
ffffffffc02052f2:	38050663          	beqz	a0,ffffffffc020567e <do_execve+0x4fa>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02052f6:	6c88                	ld	a0,24(s1)
ffffffffc02052f8:	467d                	li	a2,31
ffffffffc02052fa:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02052fe:	9f7fe0ef          	jal	ra,ffffffffc0203cf4 <pgdir_alloc_page>
ffffffffc0205302:	34050e63          	beqz	a0,ffffffffc020565e <do_execve+0x4da>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205306:	6c88                	ld	a0,24(s1)
ffffffffc0205308:	467d                	li	a2,31
ffffffffc020530a:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020530e:	9e7fe0ef          	jal	ra,ffffffffc0203cf4 <pgdir_alloc_page>
ffffffffc0205312:	32050663          	beqz	a0,ffffffffc020563e <do_execve+0x4ba>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0205316:	6c88                	ld	a0,24(s1)
ffffffffc0205318:	467d                	li	a2,31
ffffffffc020531a:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020531e:	9d7fe0ef          	jal	ra,ffffffffc0203cf4 <pgdir_alloc_page>
ffffffffc0205322:	2e050e63          	beqz	a0,ffffffffc020561e <do_execve+0x49a>
    mm->mm_count += 1;
ffffffffc0205326:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0205328:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc020532c:	6c94                	ld	a3,24(s1)
ffffffffc020532e:	2785                	addiw	a5,a5,1
ffffffffc0205330:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0205332:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0205334:	c02007b7          	lui	a5,0xc0200
ffffffffc0205338:	2cf6e763          	bltu	a3,a5,ffffffffc0205606 <do_execve+0x482>
ffffffffc020533c:	000b3783          	ld	a5,0(s6)
ffffffffc0205340:	577d                	li	a4,-1
ffffffffc0205342:	177e                	slli	a4,a4,0x3f
ffffffffc0205344:	8e9d                	sub	a3,a3,a5
ffffffffc0205346:	00c6d793          	srli	a5,a3,0xc
ffffffffc020534a:	f654                	sd	a3,168(a2)
ffffffffc020534c:	8fd9                	or	a5,a5,a4
ffffffffc020534e:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0205352:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0205354:	4581                	li	a1,0
ffffffffc0205356:	12000613          	li	a2,288
ffffffffc020535a:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc020535c:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0205360:	5ef000ef          	jal	ra,ffffffffc020614e <memset>
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0205364:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205366:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc020536a:	edf4f493          	andi	s1,s1,-289
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc020536e:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0205370:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205372:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_matrix_out_size+0xffffffff7fff3774>
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0205376:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0205378:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020537c:	4641                	li	a2,16
ffffffffc020537e:	4581                	li	a1,0
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0205380:	e81c                	sd	a5,16(s0)
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0205382:	10e43423          	sd	a4,264(s0)
    tf->gpr.a0 = 0;
ffffffffc0205386:	04043823          	sd	zero,80(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc020538a:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020538e:	854a                	mv	a0,s2
ffffffffc0205390:	5bf000ef          	jal	ra,ffffffffc020614e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205394:	463d                	li	a2,15
ffffffffc0205396:	180c                	addi	a1,sp,48
ffffffffc0205398:	854a                	mv	a0,s2
ffffffffc020539a:	5c7000ef          	jal	ra,ffffffffc0206160 <memcpy>
}
ffffffffc020539e:	70aa                	ld	ra,168(sp)
ffffffffc02053a0:	740a                	ld	s0,160(sp)
ffffffffc02053a2:	64ea                	ld	s1,152(sp)
ffffffffc02053a4:	694a                	ld	s2,144(sp)
ffffffffc02053a6:	69aa                	ld	s3,136(sp)
ffffffffc02053a8:	7ae6                	ld	s5,120(sp)
ffffffffc02053aa:	7b46                	ld	s6,112(sp)
ffffffffc02053ac:	7ba6                	ld	s7,104(sp)
ffffffffc02053ae:	7c06                	ld	s8,96(sp)
ffffffffc02053b0:	6ce6                	ld	s9,88(sp)
ffffffffc02053b2:	6d46                	ld	s10,80(sp)
ffffffffc02053b4:	6da6                	ld	s11,72(sp)
ffffffffc02053b6:	8552                	mv	a0,s4
ffffffffc02053b8:	6a0a                	ld	s4,128(sp)
ffffffffc02053ba:	614d                	addi	sp,sp,176
ffffffffc02053bc:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc02053be:	463d                	li	a2,15
ffffffffc02053c0:	85ca                	mv	a1,s2
ffffffffc02053c2:	1808                	addi	a0,sp,48
ffffffffc02053c4:	59d000ef          	jal	ra,ffffffffc0206160 <memcpy>
    if (mm != NULL)
ffffffffc02053c8:	e0099fe3          	bnez	s3,ffffffffc02051e6 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc02053cc:	000db783          	ld	a5,0(s11)
ffffffffc02053d0:	779c                	ld	a5,40(a5)
ffffffffc02053d2:	e40786e3          	beqz	a5,ffffffffc020521e <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc02053d6:	00003617          	auipc	a2,0x3
ffffffffc02053da:	0aa60613          	addi	a2,a2,170 # ffffffffc0208480 <default_pmm_manager+0xd10>
ffffffffc02053de:	25400593          	li	a1,596
ffffffffc02053e2:	00003517          	auipc	a0,0x3
ffffffffc02053e6:	ede50513          	addi	a0,a0,-290 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc02053ea:	e39fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    put_pgdir(mm);
ffffffffc02053ee:	854a                	mv	a0,s2
ffffffffc02053f0:	bdcff0ef          	jal	ra,ffffffffc02047cc <put_pgdir.isra.0>
    mm_destroy(mm);
ffffffffc02053f4:	8526                	mv	a0,s1
ffffffffc02053f6:	d33fb0ef          	jal	ra,ffffffffc0201128 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc02053fa:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc02053fc:	8552                	mv	a0,s4
ffffffffc02053fe:	941ff0ef          	jal	ra,ffffffffc0204d3e <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0205402:	5a71                	li	s4,-4
ffffffffc0205404:	bfe5                	j	ffffffffc02053fc <do_execve+0x278>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0205406:	0289b603          	ld	a2,40(s3)
ffffffffc020540a:	0209b783          	ld	a5,32(s3)
ffffffffc020540e:	1cf66e63          	bltu	a2,a5,ffffffffc02055ea <do_execve+0x466>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0205412:	0049a783          	lw	a5,4(s3)
ffffffffc0205416:	0017f693          	andi	a3,a5,1
ffffffffc020541a:	c291                	beqz	a3,ffffffffc020541e <do_execve+0x29a>
            vm_flags |= VM_EXEC;
ffffffffc020541c:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc020541e:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205422:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0205424:	eb61                	bnez	a4,ffffffffc02054f4 <do_execve+0x370>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0205426:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0205428:	c781                	beqz	a5,ffffffffc0205430 <do_execve+0x2ac>
            vm_flags |= VM_READ;
ffffffffc020542a:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc020542e:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0205430:	0026f793          	andi	a5,a3,2
ffffffffc0205434:	e3f9                	bnez	a5,ffffffffc02054fa <do_execve+0x376>
        if (vm_flags & VM_EXEC)
ffffffffc0205436:	0046f793          	andi	a5,a3,4
ffffffffc020543a:	c399                	beqz	a5,ffffffffc0205440 <do_execve+0x2bc>
            perm |= PTE_X;
ffffffffc020543c:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0205440:	0109b583          	ld	a1,16(s3)
ffffffffc0205444:	4701                	li	a4,0
ffffffffc0205446:	8526                	mv	a0,s1
ffffffffc0205448:	d33fb0ef          	jal	ra,ffffffffc020117a <mm_map>
ffffffffc020544c:	8a2a                	mv	s4,a0
ffffffffc020544e:	ed35                	bnez	a0,ffffffffc02054ca <do_execve+0x346>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205450:	0109bb83          	ld	s7,16(s3)
ffffffffc0205454:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0205456:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc020545a:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc020545e:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205462:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0205464:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205466:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0205468:	054be963          	bltu	s7,s4,ffffffffc02054ba <do_execve+0x336>
ffffffffc020546c:	aa9d                	j	ffffffffc02055e2 <do_execve+0x45e>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc020546e:	6785                	lui	a5,0x1
ffffffffc0205470:	415b8533          	sub	a0,s7,s5
ffffffffc0205474:	9abe                	add	s5,s5,a5
ffffffffc0205476:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc020547a:	015a7463          	bgeu	s4,s5,ffffffffc0205482 <do_execve+0x2fe>
                size -= la - end;
ffffffffc020547e:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0205482:	000cb683          	ld	a3,0(s9)
ffffffffc0205486:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205488:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc020548c:	40d406b3          	sub	a3,s0,a3
ffffffffc0205490:	8699                	srai	a3,a3,0x6
ffffffffc0205492:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0205494:	67e2                	ld	a5,24(sp)
ffffffffc0205496:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc020549a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020549c:	14b87963          	bgeu	a6,a1,ffffffffc02055ee <do_execve+0x46a>
ffffffffc02054a0:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02054a4:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc02054a6:	9bb2                	add	s7,s7,a2
ffffffffc02054a8:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc02054aa:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc02054ac:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc02054ae:	4b3000ef          	jal	ra,ffffffffc0206160 <memcpy>
            start += size, from += size;
ffffffffc02054b2:	6622                	ld	a2,8(sp)
ffffffffc02054b4:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc02054b6:	054bf463          	bgeu	s7,s4,ffffffffc02054fe <do_execve+0x37a>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc02054ba:	6c88                	ld	a0,24(s1)
ffffffffc02054bc:	866a                	mv	a2,s10
ffffffffc02054be:	85d6                	mv	a1,s5
ffffffffc02054c0:	835fe0ef          	jal	ra,ffffffffc0203cf4 <pgdir_alloc_page>
ffffffffc02054c4:	842a                	mv	s0,a0
ffffffffc02054c6:	f545                	bnez	a0,ffffffffc020546e <do_execve+0x2ea>
        ret = -E_NO_MEM;
ffffffffc02054c8:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc02054ca:	8526                	mv	a0,s1
ffffffffc02054cc:	df9fb0ef          	jal	ra,ffffffffc02012c4 <exit_mmap>
    put_pgdir(mm);
ffffffffc02054d0:	6c88                	ld	a0,24(s1)
ffffffffc02054d2:	afaff0ef          	jal	ra,ffffffffc02047cc <put_pgdir.isra.0>
    mm_destroy(mm);
ffffffffc02054d6:	8526                	mv	a0,s1
ffffffffc02054d8:	c51fb0ef          	jal	ra,ffffffffc0201128 <mm_destroy>
    return ret;
ffffffffc02054dc:	b705                	j	ffffffffc02053fc <do_execve+0x278>
            exit_mmap(mm);
ffffffffc02054de:	854e                	mv	a0,s3
ffffffffc02054e0:	de5fb0ef          	jal	ra,ffffffffc02012c4 <exit_mmap>
            put_pgdir(mm);
ffffffffc02054e4:	0189b503          	ld	a0,24(s3)
ffffffffc02054e8:	ae4ff0ef          	jal	ra,ffffffffc02047cc <put_pgdir.isra.0>
            mm_destroy(mm);
ffffffffc02054ec:	854e                	mv	a0,s3
ffffffffc02054ee:	c3bfb0ef          	jal	ra,ffffffffc0201128 <mm_destroy>
ffffffffc02054f2:	b315                	j	ffffffffc0205216 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc02054f4:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc02054f8:	fb8d                	bnez	a5,ffffffffc020542a <do_execve+0x2a6>
            perm |= (PTE_W | PTE_R);
ffffffffc02054fa:	4d5d                	li	s10,23
ffffffffc02054fc:	bf2d                	j	ffffffffc0205436 <do_execve+0x2b2>
        end = ph->p_va + ph->p_memsz;
ffffffffc02054fe:	0109b683          	ld	a3,16(s3)
ffffffffc0205502:	0289b903          	ld	s2,40(s3)
ffffffffc0205506:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0205508:	075bfd63          	bgeu	s7,s5,ffffffffc0205582 <do_execve+0x3fe>
            if (start == end)
ffffffffc020550c:	db790ce3          	beq	s2,s7,ffffffffc02052c4 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0205510:	6785                	lui	a5,0x1
ffffffffc0205512:	00fb8533          	add	a0,s7,a5
ffffffffc0205516:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc020551a:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc020551e:	0b597d63          	bgeu	s2,s5,ffffffffc02055d8 <do_execve+0x454>
    return page - pages + nbase;
ffffffffc0205522:	000cb683          	ld	a3,0(s9)
ffffffffc0205526:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0205528:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc020552c:	40d406b3          	sub	a3,s0,a3
ffffffffc0205530:	8699                	srai	a3,a3,0x6
ffffffffc0205532:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0205534:	67e2                	ld	a5,24(sp)
ffffffffc0205536:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc020553a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020553c:	0ac5f963          	bgeu	a1,a2,ffffffffc02055ee <do_execve+0x46a>
ffffffffc0205540:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0205544:	8652                	mv	a2,s4
ffffffffc0205546:	4581                	li	a1,0
ffffffffc0205548:	96c2                	add	a3,a3,a6
ffffffffc020554a:	9536                	add	a0,a0,a3
ffffffffc020554c:	403000ef          	jal	ra,ffffffffc020614e <memset>
            start += size;
ffffffffc0205550:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0205554:	03597463          	bgeu	s2,s5,ffffffffc020557c <do_execve+0x3f8>
ffffffffc0205558:	d6e906e3          	beq	s2,a4,ffffffffc02052c4 <do_execve+0x140>
ffffffffc020555c:	00003697          	auipc	a3,0x3
ffffffffc0205560:	f4c68693          	addi	a3,a3,-180 # ffffffffc02084a8 <default_pmm_manager+0xd38>
ffffffffc0205564:	00002617          	auipc	a2,0x2
ffffffffc0205568:	afc60613          	addi	a2,a2,-1284 # ffffffffc0207060 <commands+0x838>
ffffffffc020556c:	2bd00593          	li	a1,701
ffffffffc0205570:	00003517          	auipc	a0,0x3
ffffffffc0205574:	d5050513          	addi	a0,a0,-688 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205578:	cabfa0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc020557c:	ff5710e3          	bne	a4,s5,ffffffffc020555c <do_execve+0x3d8>
ffffffffc0205580:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0205582:	d52bf1e3          	bgeu	s7,s2,ffffffffc02052c4 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0205586:	6c88                	ld	a0,24(s1)
ffffffffc0205588:	866a                	mv	a2,s10
ffffffffc020558a:	85d6                	mv	a1,s5
ffffffffc020558c:	f68fe0ef          	jal	ra,ffffffffc0203cf4 <pgdir_alloc_page>
ffffffffc0205590:	842a                	mv	s0,a0
ffffffffc0205592:	d91d                	beqz	a0,ffffffffc02054c8 <do_execve+0x344>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205594:	6785                	lui	a5,0x1
ffffffffc0205596:	415b8533          	sub	a0,s7,s5
ffffffffc020559a:	9abe                	add	s5,s5,a5
ffffffffc020559c:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc02055a0:	01597463          	bgeu	s2,s5,ffffffffc02055a8 <do_execve+0x424>
                size -= la - end;
ffffffffc02055a4:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc02055a8:	000cb683          	ld	a3,0(s9)
ffffffffc02055ac:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc02055ae:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc02055b2:	40d406b3          	sub	a3,s0,a3
ffffffffc02055b6:	8699                	srai	a3,a3,0x6
ffffffffc02055b8:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02055ba:	67e2                	ld	a5,24(sp)
ffffffffc02055bc:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02055c0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02055c2:	02b87663          	bgeu	a6,a1,ffffffffc02055ee <do_execve+0x46a>
ffffffffc02055c6:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc02055ca:	4581                	li	a1,0
            start += size;
ffffffffc02055cc:	9bb2                	add	s7,s7,a2
ffffffffc02055ce:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc02055d0:	9536                	add	a0,a0,a3
ffffffffc02055d2:	37d000ef          	jal	ra,ffffffffc020614e <memset>
ffffffffc02055d6:	b775                	j	ffffffffc0205582 <do_execve+0x3fe>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc02055d8:	417a8a33          	sub	s4,s5,s7
ffffffffc02055dc:	b799                	j	ffffffffc0205522 <do_execve+0x39e>
        return -E_INVAL;
ffffffffc02055de:	5a75                	li	s4,-3
ffffffffc02055e0:	bb7d                	j	ffffffffc020539e <do_execve+0x21a>
        while (start < end)
ffffffffc02055e2:	86de                	mv	a3,s7
ffffffffc02055e4:	bf39                	j	ffffffffc0205502 <do_execve+0x37e>
    int ret = -E_NO_MEM;
ffffffffc02055e6:	5a71                	li	s4,-4
ffffffffc02055e8:	b5fd                	j	ffffffffc02054d6 <do_execve+0x352>
            ret = -E_INVAL_ELF;
ffffffffc02055ea:	5a61                	li	s4,-8
ffffffffc02055ec:	bdf9                	j	ffffffffc02054ca <do_execve+0x346>
ffffffffc02055ee:	00002617          	auipc	a2,0x2
ffffffffc02055f2:	cea60613          	addi	a2,a2,-790 # ffffffffc02072d8 <commands+0xab0>
ffffffffc02055f6:	07100593          	li	a1,113
ffffffffc02055fa:	00002517          	auipc	a0,0x2
ffffffffc02055fe:	d0650513          	addi	a0,a0,-762 # ffffffffc0207300 <commands+0xad8>
ffffffffc0205602:	c21fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0205606:	00002617          	auipc	a2,0x2
ffffffffc020560a:	d7a60613          	addi	a2,a2,-646 # ffffffffc0207380 <commands+0xb58>
ffffffffc020560e:	2dc00593          	li	a1,732
ffffffffc0205612:	00003517          	auipc	a0,0x3
ffffffffc0205616:	cae50513          	addi	a0,a0,-850 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc020561a:	c09fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc020561e:	00003697          	auipc	a3,0x3
ffffffffc0205622:	fa268693          	addi	a3,a3,-94 # ffffffffc02085c0 <default_pmm_manager+0xe50>
ffffffffc0205626:	00002617          	auipc	a2,0x2
ffffffffc020562a:	a3a60613          	addi	a2,a2,-1478 # ffffffffc0207060 <commands+0x838>
ffffffffc020562e:	2d700593          	li	a1,727
ffffffffc0205632:	00003517          	auipc	a0,0x3
ffffffffc0205636:	c8e50513          	addi	a0,a0,-882 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc020563a:	be9fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc020563e:	00003697          	auipc	a3,0x3
ffffffffc0205642:	f3a68693          	addi	a3,a3,-198 # ffffffffc0208578 <default_pmm_manager+0xe08>
ffffffffc0205646:	00002617          	auipc	a2,0x2
ffffffffc020564a:	a1a60613          	addi	a2,a2,-1510 # ffffffffc0207060 <commands+0x838>
ffffffffc020564e:	2d600593          	li	a1,726
ffffffffc0205652:	00003517          	auipc	a0,0x3
ffffffffc0205656:	c6e50513          	addi	a0,a0,-914 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc020565a:	bc9fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc020565e:	00003697          	auipc	a3,0x3
ffffffffc0205662:	ed268693          	addi	a3,a3,-302 # ffffffffc0208530 <default_pmm_manager+0xdc0>
ffffffffc0205666:	00002617          	auipc	a2,0x2
ffffffffc020566a:	9fa60613          	addi	a2,a2,-1542 # ffffffffc0207060 <commands+0x838>
ffffffffc020566e:	2d500593          	li	a1,725
ffffffffc0205672:	00003517          	auipc	a0,0x3
ffffffffc0205676:	c4e50513          	addi	a0,a0,-946 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc020567a:	ba9fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc020567e:	00003697          	auipc	a3,0x3
ffffffffc0205682:	e6a68693          	addi	a3,a3,-406 # ffffffffc02084e8 <default_pmm_manager+0xd78>
ffffffffc0205686:	00002617          	auipc	a2,0x2
ffffffffc020568a:	9da60613          	addi	a2,a2,-1574 # ffffffffc0207060 <commands+0x838>
ffffffffc020568e:	2d400593          	li	a1,724
ffffffffc0205692:	00003517          	auipc	a0,0x3
ffffffffc0205696:	c2e50513          	addi	a0,a0,-978 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc020569a:	b89fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020569e <user_main>:
{
ffffffffc020569e:	1101                	addi	sp,sp,-32
ffffffffc02056a0:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc02056a2:	000db917          	auipc	s2,0xdb
ffffffffc02056a6:	a9e90913          	addi	s2,s2,-1378 # ffffffffc02e0140 <current>
ffffffffc02056aa:	00093783          	ld	a5,0(s2)
ffffffffc02056ae:	00003617          	auipc	a2,0x3
ffffffffc02056b2:	f5a60613          	addi	a2,a2,-166 # ffffffffc0208608 <default_pmm_manager+0xe98>
ffffffffc02056b6:	00003517          	auipc	a0,0x3
ffffffffc02056ba:	f5a50513          	addi	a0,a0,-166 # ffffffffc0208610 <default_pmm_manager+0xea0>
ffffffffc02056be:	43cc                	lw	a1,4(a5)
{
ffffffffc02056c0:	ec06                	sd	ra,24(sp)
ffffffffc02056c2:	e822                	sd	s0,16(sp)
ffffffffc02056c4:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc02056c6:	a1ffa0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    size_t len = strlen(name);
ffffffffc02056ca:	00003517          	auipc	a0,0x3
ffffffffc02056ce:	f3e50513          	addi	a0,a0,-194 # ffffffffc0208608 <default_pmm_manager+0xe98>
ffffffffc02056d2:	1db000ef          	jal	ra,ffffffffc02060ac <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc02056d6:	00093783          	ld	a5,0(s2)
    size_t len = strlen(name);
ffffffffc02056da:	84aa                	mv	s1,a0
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc02056dc:	12000613          	li	a2,288
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02056e0:	6b80                	ld	s0,16(a5)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc02056e2:	73cc                	ld	a1,160(a5)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02056e4:	6789                	lui	a5,0x2
ffffffffc02056e6:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x8298>
ffffffffc02056ea:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc02056ec:	8522                	mv	a0,s0
ffffffffc02056ee:	273000ef          	jal	ra,ffffffffc0206160 <memcpy>
    current->tf = new_tf;
ffffffffc02056f2:	00093783          	ld	a5,0(s2)
    ret = do_execve(name, len, binary, size);
ffffffffc02056f6:	3fe07697          	auipc	a3,0x3fe07
ffffffffc02056fa:	24a68693          	addi	a3,a3,586 # c940 <_binary_obj___user_matrix_out_size>
ffffffffc02056fe:	000bf617          	auipc	a2,0xbf
ffffffffc0205702:	cba60613          	addi	a2,a2,-838 # ffffffffc02c43b8 <_binary_obj___user_matrix_out_start>
    current->tf = new_tf;
ffffffffc0205706:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0205708:	85a6                	mv	a1,s1
ffffffffc020570a:	00003517          	auipc	a0,0x3
ffffffffc020570e:	efe50513          	addi	a0,a0,-258 # ffffffffc0208608 <default_pmm_manager+0xe98>
ffffffffc0205712:	a73ff0ef          	jal	ra,ffffffffc0205184 <do_execve>
    asm volatile(
ffffffffc0205716:	8122                	mv	sp,s0
ffffffffc0205718:	841fb06f          	j	ffffffffc0200f58 <__trapret>
    panic("user_main execve failed.\n");
ffffffffc020571c:	00003617          	auipc	a2,0x3
ffffffffc0205720:	f1c60613          	addi	a2,a2,-228 # ffffffffc0208638 <default_pmm_manager+0xec8>
ffffffffc0205724:	3c900593          	li	a1,969
ffffffffc0205728:	00003517          	auipc	a0,0x3
ffffffffc020572c:	b9850513          	addi	a0,a0,-1128 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205730:	af3fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205734 <do_yield>:
    current->need_resched = 1;
ffffffffc0205734:	000db797          	auipc	a5,0xdb
ffffffffc0205738:	a0c7b783          	ld	a5,-1524(a5) # ffffffffc02e0140 <current>
ffffffffc020573c:	4705                	li	a4,1
ffffffffc020573e:	ef98                	sd	a4,24(a5)
}
ffffffffc0205740:	4501                	li	a0,0
ffffffffc0205742:	8082                	ret

ffffffffc0205744 <do_wait>:
{
ffffffffc0205744:	1101                	addi	sp,sp,-32
ffffffffc0205746:	e822                	sd	s0,16(sp)
ffffffffc0205748:	e426                	sd	s1,8(sp)
ffffffffc020574a:	ec06                	sd	ra,24(sp)
ffffffffc020574c:	842e                	mv	s0,a1
ffffffffc020574e:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0205750:	c999                	beqz	a1,ffffffffc0205766 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0205752:	000db797          	auipc	a5,0xdb
ffffffffc0205756:	9ee7b783          	ld	a5,-1554(a5) # ffffffffc02e0140 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc020575a:	7788                	ld	a0,40(a5)
ffffffffc020575c:	4685                	li	a3,1
ffffffffc020575e:	4611                	li	a2,4
ffffffffc0205760:	f05fb0ef          	jal	ra,ffffffffc0201664 <user_mem_check>
ffffffffc0205764:	c909                	beqz	a0,ffffffffc0205776 <do_wait+0x32>
ffffffffc0205766:	85a2                	mv	a1,s0
}
ffffffffc0205768:	6442                	ld	s0,16(sp)
ffffffffc020576a:	60e2                	ld	ra,24(sp)
ffffffffc020576c:	8526                	mv	a0,s1
ffffffffc020576e:	64a2                	ld	s1,8(sp)
ffffffffc0205770:	6105                	addi	sp,sp,32
ffffffffc0205772:	f18ff06f          	j	ffffffffc0204e8a <do_wait.part.0>
ffffffffc0205776:	60e2                	ld	ra,24(sp)
ffffffffc0205778:	6442                	ld	s0,16(sp)
ffffffffc020577a:	64a2                	ld	s1,8(sp)
ffffffffc020577c:	5575                	li	a0,-3
ffffffffc020577e:	6105                	addi	sp,sp,32
ffffffffc0205780:	8082                	ret

ffffffffc0205782 <do_kill>:
{
ffffffffc0205782:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0205784:	6789                	lui	a5,0x2
{
ffffffffc0205786:	e406                	sd	ra,8(sp)
ffffffffc0205788:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc020578a:	fff5071b          	addiw	a4,a0,-1
ffffffffc020578e:	17f9                	addi	a5,a5,-2
ffffffffc0205790:	02e7e963          	bltu	a5,a4,ffffffffc02057c2 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205794:	842a                	mv	s0,a0
ffffffffc0205796:	45a9                	li	a1,10
ffffffffc0205798:	2501                	sext.w	a0,a0
ffffffffc020579a:	5cd000ef          	jal	ra,ffffffffc0206566 <hash32>
ffffffffc020579e:	02051793          	slli	a5,a0,0x20
ffffffffc02057a2:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02057a6:	000d7797          	auipc	a5,0xd7
ffffffffc02057aa:	90278793          	addi	a5,a5,-1790 # ffffffffc02dc0a8 <hash_list>
ffffffffc02057ae:	953e                	add	a0,a0,a5
ffffffffc02057b0:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02057b2:	a029                	j	ffffffffc02057bc <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc02057b4:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02057b8:	00870b63          	beq	a4,s0,ffffffffc02057ce <do_kill+0x4c>
ffffffffc02057bc:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02057be:	fef51be3          	bne	a0,a5,ffffffffc02057b4 <do_kill+0x32>
    return -E_INVAL;
ffffffffc02057c2:	5475                	li	s0,-3
}
ffffffffc02057c4:	60a2                	ld	ra,8(sp)
ffffffffc02057c6:	8522                	mv	a0,s0
ffffffffc02057c8:	6402                	ld	s0,0(sp)
ffffffffc02057ca:	0141                	addi	sp,sp,16
ffffffffc02057cc:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc02057ce:	fd87a703          	lw	a4,-40(a5)
ffffffffc02057d2:	00177693          	andi	a3,a4,1
ffffffffc02057d6:	e295                	bnez	a3,ffffffffc02057fa <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc02057d8:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc02057da:	00176713          	ori	a4,a4,1
ffffffffc02057de:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc02057e2:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc02057e4:	fe06d0e3          	bgez	a3,ffffffffc02057c4 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc02057e8:	f2878513          	addi	a0,a5,-216
ffffffffc02057ec:	2d4000ef          	jal	ra,ffffffffc0205ac0 <wakeup_proc>
}
ffffffffc02057f0:	60a2                	ld	ra,8(sp)
ffffffffc02057f2:	8522                	mv	a0,s0
ffffffffc02057f4:	6402                	ld	s0,0(sp)
ffffffffc02057f6:	0141                	addi	sp,sp,16
ffffffffc02057f8:	8082                	ret
        return -E_KILLED;
ffffffffc02057fa:	545d                	li	s0,-9
ffffffffc02057fc:	b7e1                	j	ffffffffc02057c4 <do_kill+0x42>

ffffffffc02057fe <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc02057fe:	1101                	addi	sp,sp,-32
ffffffffc0205800:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0205802:	000db797          	auipc	a5,0xdb
ffffffffc0205806:	8a678793          	addi	a5,a5,-1882 # ffffffffc02e00a8 <proc_list>
ffffffffc020580a:	ec06                	sd	ra,24(sp)
ffffffffc020580c:	e822                	sd	s0,16(sp)
ffffffffc020580e:	e04a                	sd	s2,0(sp)
ffffffffc0205810:	000d7497          	auipc	s1,0xd7
ffffffffc0205814:	89848493          	addi	s1,s1,-1896 # ffffffffc02dc0a8 <hash_list>
ffffffffc0205818:	e79c                	sd	a5,8(a5)
ffffffffc020581a:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020581c:	000db717          	auipc	a4,0xdb
ffffffffc0205820:	88c70713          	addi	a4,a4,-1908 # ffffffffc02e00a8 <proc_list>
ffffffffc0205824:	87a6                	mv	a5,s1
ffffffffc0205826:	e79c                	sd	a5,8(a5)
ffffffffc0205828:	e39c                	sd	a5,0(a5)
ffffffffc020582a:	07c1                	addi	a5,a5,16
ffffffffc020582c:	fef71de3          	bne	a4,a5,ffffffffc0205826 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205830:	ee9fe0ef          	jal	ra,ffffffffc0204718 <alloc_proc>
ffffffffc0205834:	000db917          	auipc	s2,0xdb
ffffffffc0205838:	91490913          	addi	s2,s2,-1772 # ffffffffc02e0148 <idleproc>
ffffffffc020583c:	00a93023          	sd	a0,0(s2)
ffffffffc0205840:	0e050f63          	beqz	a0,ffffffffc020593e <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205844:	4789                	li	a5,2
ffffffffc0205846:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205848:	00004797          	auipc	a5,0x4
ffffffffc020584c:	7b878793          	addi	a5,a5,1976 # ffffffffc020a000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205850:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205854:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0205856:	4785                	li	a5,1
ffffffffc0205858:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020585a:	4641                	li	a2,16
ffffffffc020585c:	4581                	li	a1,0
ffffffffc020585e:	8522                	mv	a0,s0
ffffffffc0205860:	0ef000ef          	jal	ra,ffffffffc020614e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205864:	463d                	li	a2,15
ffffffffc0205866:	00003597          	auipc	a1,0x3
ffffffffc020586a:	e0a58593          	addi	a1,a1,-502 # ffffffffc0208670 <default_pmm_manager+0xf00>
ffffffffc020586e:	8522                	mv	a0,s0
ffffffffc0205870:	0f1000ef          	jal	ra,ffffffffc0206160 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205874:	000db717          	auipc	a4,0xdb
ffffffffc0205878:	8e470713          	addi	a4,a4,-1820 # ffffffffc02e0158 <nr_process>
ffffffffc020587c:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc020587e:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205882:	4601                	li	a2,0
    nr_process++;
ffffffffc0205884:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205886:	4581                	li	a1,0
ffffffffc0205888:	fffff517          	auipc	a0,0xfffff
ffffffffc020588c:	7d450513          	addi	a0,a0,2004 # ffffffffc020505c <init_main>
    nr_process++;
ffffffffc0205890:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0205892:	000db797          	auipc	a5,0xdb
ffffffffc0205896:	8ad7b723          	sd	a3,-1874(a5) # ffffffffc02e0140 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020589a:	c54ff0ef          	jal	ra,ffffffffc0204cee <kernel_thread>
ffffffffc020589e:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02058a0:	08a05363          	blez	a0,ffffffffc0205926 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02058a4:	6789                	lui	a5,0x2
ffffffffc02058a6:	fff5071b          	addiw	a4,a0,-1
ffffffffc02058aa:	17f9                	addi	a5,a5,-2
ffffffffc02058ac:	2501                	sext.w	a0,a0
ffffffffc02058ae:	02e7e363          	bltu	a5,a4,ffffffffc02058d4 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02058b2:	45a9                	li	a1,10
ffffffffc02058b4:	4b3000ef          	jal	ra,ffffffffc0206566 <hash32>
ffffffffc02058b8:	02051793          	slli	a5,a0,0x20
ffffffffc02058bc:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02058c0:	96a6                	add	a3,a3,s1
ffffffffc02058c2:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02058c4:	a029                	j	ffffffffc02058ce <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02058c6:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x824c>
ffffffffc02058ca:	04870b63          	beq	a4,s0,ffffffffc0205920 <proc_init+0x122>
    return listelm->next;
ffffffffc02058ce:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02058d0:	fef69be3          	bne	a3,a5,ffffffffc02058c6 <proc_init+0xc8>
    return NULL;
ffffffffc02058d4:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02058d6:	0b478493          	addi	s1,a5,180
ffffffffc02058da:	4641                	li	a2,16
ffffffffc02058dc:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02058de:	000db417          	auipc	s0,0xdb
ffffffffc02058e2:	87240413          	addi	s0,s0,-1934 # ffffffffc02e0150 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02058e6:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc02058e8:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02058ea:	065000ef          	jal	ra,ffffffffc020614e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02058ee:	463d                	li	a2,15
ffffffffc02058f0:	00003597          	auipc	a1,0x3
ffffffffc02058f4:	da858593          	addi	a1,a1,-600 # ffffffffc0208698 <default_pmm_manager+0xf28>
ffffffffc02058f8:	8526                	mv	a0,s1
ffffffffc02058fa:	067000ef          	jal	ra,ffffffffc0206160 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02058fe:	00093783          	ld	a5,0(s2)
ffffffffc0205902:	cbb5                	beqz	a5,ffffffffc0205976 <proc_init+0x178>
ffffffffc0205904:	43dc                	lw	a5,4(a5)
ffffffffc0205906:	eba5                	bnez	a5,ffffffffc0205976 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205908:	601c                	ld	a5,0(s0)
ffffffffc020590a:	c7b1                	beqz	a5,ffffffffc0205956 <proc_init+0x158>
ffffffffc020590c:	43d8                	lw	a4,4(a5)
ffffffffc020590e:	4785                	li	a5,1
ffffffffc0205910:	04f71363          	bne	a4,a5,ffffffffc0205956 <proc_init+0x158>
}
ffffffffc0205914:	60e2                	ld	ra,24(sp)
ffffffffc0205916:	6442                	ld	s0,16(sp)
ffffffffc0205918:	64a2                	ld	s1,8(sp)
ffffffffc020591a:	6902                	ld	s2,0(sp)
ffffffffc020591c:	6105                	addi	sp,sp,32
ffffffffc020591e:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205920:	f2878793          	addi	a5,a5,-216
ffffffffc0205924:	bf4d                	j	ffffffffc02058d6 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0205926:	00003617          	auipc	a2,0x3
ffffffffc020592a:	d5260613          	addi	a2,a2,-686 # ffffffffc0208678 <default_pmm_manager+0xf08>
ffffffffc020592e:	40700593          	li	a1,1031
ffffffffc0205932:	00003517          	auipc	a0,0x3
ffffffffc0205936:	98e50513          	addi	a0,a0,-1650 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc020593a:	8e9fa0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc020593e:	00003617          	auipc	a2,0x3
ffffffffc0205942:	d1a60613          	addi	a2,a2,-742 # ffffffffc0208658 <default_pmm_manager+0xee8>
ffffffffc0205946:	3f800593          	li	a1,1016
ffffffffc020594a:	00003517          	auipc	a0,0x3
ffffffffc020594e:	97650513          	addi	a0,a0,-1674 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205952:	8d1fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205956:	00003697          	auipc	a3,0x3
ffffffffc020595a:	d7268693          	addi	a3,a3,-654 # ffffffffc02086c8 <default_pmm_manager+0xf58>
ffffffffc020595e:	00001617          	auipc	a2,0x1
ffffffffc0205962:	70260613          	addi	a2,a2,1794 # ffffffffc0207060 <commands+0x838>
ffffffffc0205966:	40e00593          	li	a1,1038
ffffffffc020596a:	00003517          	auipc	a0,0x3
ffffffffc020596e:	95650513          	addi	a0,a0,-1706 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205972:	8b1fa0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205976:	00003697          	auipc	a3,0x3
ffffffffc020597a:	d2a68693          	addi	a3,a3,-726 # ffffffffc02086a0 <default_pmm_manager+0xf30>
ffffffffc020597e:	00001617          	auipc	a2,0x1
ffffffffc0205982:	6e260613          	addi	a2,a2,1762 # ffffffffc0207060 <commands+0x838>
ffffffffc0205986:	40d00593          	li	a1,1037
ffffffffc020598a:	00003517          	auipc	a0,0x3
ffffffffc020598e:	93650513          	addi	a0,a0,-1738 # ffffffffc02082c0 <default_pmm_manager+0xb50>
ffffffffc0205992:	891fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205996 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0205996:	1141                	addi	sp,sp,-16
ffffffffc0205998:	e022                	sd	s0,0(sp)
ffffffffc020599a:	e406                	sd	ra,8(sp)
ffffffffc020599c:	000da417          	auipc	s0,0xda
ffffffffc02059a0:	7a440413          	addi	s0,s0,1956 # ffffffffc02e0140 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02059a4:	6018                	ld	a4,0(s0)
ffffffffc02059a6:	6f1c                	ld	a5,24(a4)
ffffffffc02059a8:	dffd                	beqz	a5,ffffffffc02059a6 <cpu_idle+0x10>
        {
            schedule();
ffffffffc02059aa:	1c8000ef          	jal	ra,ffffffffc0205b72 <schedule>
ffffffffc02059ae:	bfdd                	j	ffffffffc02059a4 <cpu_idle+0xe>

ffffffffc02059b0 <lab6_set_priority>:
        }
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
ffffffffc02059b0:	1141                	addi	sp,sp,-16
ffffffffc02059b2:	e022                	sd	s0,0(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc02059b4:	85aa                	mv	a1,a0
{
ffffffffc02059b6:	842a                	mv	s0,a0
    cprintf("set priority to %d\n", priority);
ffffffffc02059b8:	00003517          	auipc	a0,0x3
ffffffffc02059bc:	d3850513          	addi	a0,a0,-712 # ffffffffc02086f0 <default_pmm_manager+0xf80>
{
ffffffffc02059c0:	e406                	sd	ra,8(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc02059c2:	f22fa0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    if (priority == 0)
        current->lab6_priority = 1;
ffffffffc02059c6:	000da797          	auipc	a5,0xda
ffffffffc02059ca:	77a7b783          	ld	a5,1914(a5) # ffffffffc02e0140 <current>
    if (priority == 0)
ffffffffc02059ce:	e801                	bnez	s0,ffffffffc02059de <lab6_set_priority+0x2e>
    else
        current->lab6_priority = priority;
}
ffffffffc02059d0:	60a2                	ld	ra,8(sp)
ffffffffc02059d2:	6402                	ld	s0,0(sp)
        current->lab6_priority = 1;
ffffffffc02059d4:	4705                	li	a4,1
ffffffffc02059d6:	14e7a223          	sw	a4,324(a5)
}
ffffffffc02059da:	0141                	addi	sp,sp,16
ffffffffc02059dc:	8082                	ret
ffffffffc02059de:	60a2                	ld	ra,8(sp)
        current->lab6_priority = priority;
ffffffffc02059e0:	1487a223          	sw	s0,324(a5)
}
ffffffffc02059e4:	6402                	ld	s0,0(sp)
ffffffffc02059e6:	0141                	addi	sp,sp,16
ffffffffc02059e8:	8082                	ret

ffffffffc02059ea <do_sleep>:
// do_sleep - set current process state to sleep and add timer with "time"
//          - then call scheduler. if process run again, delete timer first.
int do_sleep(unsigned int time)
{
    if (time == 0)
ffffffffc02059ea:	c539                	beqz	a0,ffffffffc0205a38 <do_sleep+0x4e>
{
ffffffffc02059ec:	7179                	addi	sp,sp,-48
ffffffffc02059ee:	f022                	sd	s0,32(sp)
ffffffffc02059f0:	f406                	sd	ra,40(sp)
ffffffffc02059f2:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02059f4:	100027f3          	csrr	a5,sstatus
ffffffffc02059f8:	8b89                	andi	a5,a5,2
ffffffffc02059fa:	e3a9                	bnez	a5,ffffffffc0205a3c <do_sleep+0x52>
    {
        return 0;
    }
    bool intr_flag;
    local_intr_save(intr_flag);
    timer_t __timer, *timer = timer_init(&__timer, current, time);
ffffffffc02059fc:	000da797          	auipc	a5,0xda
ffffffffc0205a00:	7447b783          	ld	a5,1860(a5) # ffffffffc02e0140 <current>
    elm->prev = elm->next = elm;
ffffffffc0205a04:	0818                	addi	a4,sp,16
to_struct((le), timer_t, member)

// init a timer
static inline timer_t *
timer_init(timer_t *timer, struct proc_struct *proc, int expires) {
    timer->expires = expires;
ffffffffc0205a06:	c02a                	sw	a0,0(sp)
ffffffffc0205a08:	ec3a                	sd	a4,24(sp)
ffffffffc0205a0a:	e83a                	sd	a4,16(sp)
    timer->proc = proc;
ffffffffc0205a0c:	e43e                	sd	a5,8(sp)
    current->state = PROC_SLEEPING;
ffffffffc0205a0e:	4705                	li	a4,1
ffffffffc0205a10:	c398                	sw	a4,0(a5)
    current->wait_state = WT_TIMER;
ffffffffc0205a12:	80000737          	lui	a4,0x80000
ffffffffc0205a16:	840a                	mv	s0,sp
ffffffffc0205a18:	0709                	addi	a4,a4,2
ffffffffc0205a1a:	0ee7a623          	sw	a4,236(a5)
    add_timer(timer);
ffffffffc0205a1e:	8522                	mv	a0,s0
ffffffffc0205a20:	212000ef          	jal	ra,ffffffffc0205c32 <add_timer>
    local_intr_restore(intr_flag);

    schedule();
ffffffffc0205a24:	14e000ef          	jal	ra,ffffffffc0205b72 <schedule>

    del_timer(timer);
ffffffffc0205a28:	8522                	mv	a0,s0
ffffffffc0205a2a:	2d0000ef          	jal	ra,ffffffffc0205cfa <del_timer>
    return 0;
}
ffffffffc0205a2e:	70a2                	ld	ra,40(sp)
ffffffffc0205a30:	7402                	ld	s0,32(sp)
ffffffffc0205a32:	4501                	li	a0,0
ffffffffc0205a34:	6145                	addi	sp,sp,48
ffffffffc0205a36:	8082                	ret
ffffffffc0205a38:	4501                	li	a0,0
ffffffffc0205a3a:	8082                	ret
        intr_disable();
ffffffffc0205a3c:	f79fa0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    timer_t __timer, *timer = timer_init(&__timer, current, time);
ffffffffc0205a40:	000da797          	auipc	a5,0xda
ffffffffc0205a44:	7007b783          	ld	a5,1792(a5) # ffffffffc02e0140 <current>
ffffffffc0205a48:	0818                	addi	a4,sp,16
    timer->expires = expires;
ffffffffc0205a4a:	c022                	sw	s0,0(sp)
    timer->proc = proc;
ffffffffc0205a4c:	e43e                	sd	a5,8(sp)
ffffffffc0205a4e:	ec3a                	sd	a4,24(sp)
ffffffffc0205a50:	e83a                	sd	a4,16(sp)
    current->state = PROC_SLEEPING;
ffffffffc0205a52:	4705                	li	a4,1
ffffffffc0205a54:	c398                	sw	a4,0(a5)
    current->wait_state = WT_TIMER;
ffffffffc0205a56:	80000737          	lui	a4,0x80000
ffffffffc0205a5a:	0709                	addi	a4,a4,2
ffffffffc0205a5c:	840a                	mv	s0,sp
    add_timer(timer);
ffffffffc0205a5e:	8522                	mv	a0,s0
    current->wait_state = WT_TIMER;
ffffffffc0205a60:	0ee7a623          	sw	a4,236(a5)
    add_timer(timer);
ffffffffc0205a64:	1ce000ef          	jal	ra,ffffffffc0205c32 <add_timer>
        intr_enable();
ffffffffc0205a68:	f47fa0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0205a6c:	bf65                	j	ffffffffc0205a24 <do_sleep+0x3a>

ffffffffc0205a6e <sched_init>:
}

static struct run_queue __rq;

void
sched_init(void) {
ffffffffc0205a6e:	1141                	addi	sp,sp,-16
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc0205a70:	000d6717          	auipc	a4,0xd6
ffffffffc0205a74:	08870713          	addi	a4,a4,136 # ffffffffc02dbaf8 <default_sched_class>
sched_init(void) {
ffffffffc0205a78:	e022                	sd	s0,0(sp)
ffffffffc0205a7a:	e406                	sd	ra,8(sp)
ffffffffc0205a7c:	000da797          	auipc	a5,0xda
ffffffffc0205a80:	65c78793          	addi	a5,a5,1628 # ffffffffc02e00d8 <timer_list>

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc0205a84:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc0205a86:	000da517          	auipc	a0,0xda
ffffffffc0205a8a:	63250513          	addi	a0,a0,1586 # ffffffffc02e00b8 <__rq>
ffffffffc0205a8e:	e79c                	sd	a5,8(a5)
ffffffffc0205a90:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0205a92:	4795                	li	a5,5
ffffffffc0205a94:	c95c                	sw	a5,20(a0)
    sched_class = &default_sched_class;
ffffffffc0205a96:	000da417          	auipc	s0,0xda
ffffffffc0205a9a:	6d240413          	addi	s0,s0,1746 # ffffffffc02e0168 <sched_class>
    rq = &__rq;
ffffffffc0205a9e:	000da797          	auipc	a5,0xda
ffffffffc0205aa2:	6ca7b123          	sd	a0,1730(a5) # ffffffffc02e0160 <rq>
    sched_class = &default_sched_class;
ffffffffc0205aa6:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc0205aa8:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205aaa:	601c                	ld	a5,0(s0)
}
ffffffffc0205aac:	6402                	ld	s0,0(sp)
ffffffffc0205aae:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205ab0:	638c                	ld	a1,0(a5)
ffffffffc0205ab2:	00003517          	auipc	a0,0x3
ffffffffc0205ab6:	c5650513          	addi	a0,a0,-938 # ffffffffc0208708 <default_pmm_manager+0xf98>
}
ffffffffc0205aba:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205abc:	e28fa06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0205ac0 <wakeup_proc>:

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205ac0:	4118                	lw	a4,0(a0)
wakeup_proc(struct proc_struct *proc) {
ffffffffc0205ac2:	1101                	addi	sp,sp,-32
ffffffffc0205ac4:	ec06                	sd	ra,24(sp)
ffffffffc0205ac6:	e822                	sd	s0,16(sp)
ffffffffc0205ac8:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205aca:	478d                	li	a5,3
ffffffffc0205acc:	08f70363          	beq	a4,a5,ffffffffc0205b52 <wakeup_proc+0x92>
ffffffffc0205ad0:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205ad2:	100027f3          	csrr	a5,sstatus
ffffffffc0205ad6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205ad8:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205ada:	e7bd                	bnez	a5,ffffffffc0205b48 <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
ffffffffc0205adc:	4789                	li	a5,2
ffffffffc0205ade:	04f70863          	beq	a4,a5,ffffffffc0205b2e <wakeup_proc+0x6e>
            proc->state = PROC_RUNNABLE;
ffffffffc0205ae2:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205ae4:	0e042623          	sw	zero,236(s0)
            if (proc != current) {
ffffffffc0205ae8:	000da797          	auipc	a5,0xda
ffffffffc0205aec:	6587b783          	ld	a5,1624(a5) # ffffffffc02e0140 <current>
ffffffffc0205af0:	02878363          	beq	a5,s0,ffffffffc0205b16 <wakeup_proc+0x56>
    if (proc != idleproc) {
ffffffffc0205af4:	000da797          	auipc	a5,0xda
ffffffffc0205af8:	6547b783          	ld	a5,1620(a5) # ffffffffc02e0148 <idleproc>
ffffffffc0205afc:	00f40d63          	beq	s0,a5,ffffffffc0205b16 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc0205b00:	000da797          	auipc	a5,0xda
ffffffffc0205b04:	6687b783          	ld	a5,1640(a5) # ffffffffc02e0168 <sched_class>
ffffffffc0205b08:	6b9c                	ld	a5,16(a5)
ffffffffc0205b0a:	85a2                	mv	a1,s0
ffffffffc0205b0c:	000da517          	auipc	a0,0xda
ffffffffc0205b10:	65453503          	ld	a0,1620(a0) # ffffffffc02e0160 <rq>
ffffffffc0205b14:	9782                	jalr	a5
    if (flag) {
ffffffffc0205b16:	e491                	bnez	s1,ffffffffc0205b22 <wakeup_proc+0x62>
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205b18:	60e2                	ld	ra,24(sp)
ffffffffc0205b1a:	6442                	ld	s0,16(sp)
ffffffffc0205b1c:	64a2                	ld	s1,8(sp)
ffffffffc0205b1e:	6105                	addi	sp,sp,32
ffffffffc0205b20:	8082                	ret
ffffffffc0205b22:	6442                	ld	s0,16(sp)
ffffffffc0205b24:	60e2                	ld	ra,24(sp)
ffffffffc0205b26:	64a2                	ld	s1,8(sp)
ffffffffc0205b28:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205b2a:	e85fa06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205b2e:	00003617          	auipc	a2,0x3
ffffffffc0205b32:	c2a60613          	addi	a2,a2,-982 # ffffffffc0208758 <default_pmm_manager+0xfe8>
ffffffffc0205b36:	04800593          	li	a1,72
ffffffffc0205b3a:	00003517          	auipc	a0,0x3
ffffffffc0205b3e:	c0650513          	addi	a0,a0,-1018 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205b42:	f48fa0ef          	jal	ra,ffffffffc020028a <__warn>
ffffffffc0205b46:	bfc1                	j	ffffffffc0205b16 <wakeup_proc+0x56>
        intr_disable();
ffffffffc0205b48:	e6dfa0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE) {
ffffffffc0205b4c:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205b4e:	4485                	li	s1,1
ffffffffc0205b50:	b771                	j	ffffffffc0205adc <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205b52:	00003697          	auipc	a3,0x3
ffffffffc0205b56:	bce68693          	addi	a3,a3,-1074 # ffffffffc0208720 <default_pmm_manager+0xfb0>
ffffffffc0205b5a:	00001617          	auipc	a2,0x1
ffffffffc0205b5e:	50660613          	addi	a2,a2,1286 # ffffffffc0207060 <commands+0x838>
ffffffffc0205b62:	03c00593          	li	a1,60
ffffffffc0205b66:	00003517          	auipc	a0,0x3
ffffffffc0205b6a:	bda50513          	addi	a0,a0,-1062 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205b6e:	eb4fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205b72 <schedule>:

void
schedule(void) {
ffffffffc0205b72:	7179                	addi	sp,sp,-48
ffffffffc0205b74:	f406                	sd	ra,40(sp)
ffffffffc0205b76:	f022                	sd	s0,32(sp)
ffffffffc0205b78:	ec26                	sd	s1,24(sp)
ffffffffc0205b7a:	e84a                	sd	s2,16(sp)
ffffffffc0205b7c:	e44e                	sd	s3,8(sp)
ffffffffc0205b7e:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205b80:	100027f3          	csrr	a5,sstatus
ffffffffc0205b84:	8b89                	andi	a5,a5,2
ffffffffc0205b86:	4a01                	li	s4,0
ffffffffc0205b88:	e3cd                	bnez	a5,ffffffffc0205c2a <schedule+0xb8>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205b8a:	000da497          	auipc	s1,0xda
ffffffffc0205b8e:	5b648493          	addi	s1,s1,1462 # ffffffffc02e0140 <current>
ffffffffc0205b92:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0205b94:	000da997          	auipc	s3,0xda
ffffffffc0205b98:	5d498993          	addi	s3,s3,1492 # ffffffffc02e0168 <sched_class>
ffffffffc0205b9c:	000da917          	auipc	s2,0xda
ffffffffc0205ba0:	5c490913          	addi	s2,s2,1476 # ffffffffc02e0160 <rq>
        if (current->state == PROC_RUNNABLE) {
ffffffffc0205ba4:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc0205ba6:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE) {
ffffffffc0205baa:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc0205bac:	0009b783          	ld	a5,0(s3)
ffffffffc0205bb0:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE) {
ffffffffc0205bb4:	04e68e63          	beq	a3,a4,ffffffffc0205c10 <schedule+0x9e>
    return sched_class->pick_next(rq);
ffffffffc0205bb8:	739c                	ld	a5,32(a5)
ffffffffc0205bba:	9782                	jalr	a5
ffffffffc0205bbc:	842a                	mv	s0,a0
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL) {
ffffffffc0205bbe:	c521                	beqz	a0,ffffffffc0205c06 <schedule+0x94>
    sched_class->dequeue(rq, proc);
ffffffffc0205bc0:	0009b783          	ld	a5,0(s3)
ffffffffc0205bc4:	00093503          	ld	a0,0(s2)
ffffffffc0205bc8:	85a2                	mv	a1,s0
ffffffffc0205bca:	6f9c                	ld	a5,24(a5)
ffffffffc0205bcc:	9782                	jalr	a5
            sched_class_dequeue(next);
        }
        if (next == NULL) {
            next = idleproc;
        }
        next->runs ++;
ffffffffc0205bce:	441c                	lw	a5,8(s0)
        if (next != current) {
ffffffffc0205bd0:	6098                	ld	a4,0(s1)
        next->runs ++;
ffffffffc0205bd2:	2785                	addiw	a5,a5,1
ffffffffc0205bd4:	c41c                	sw	a5,8(s0)
        if (next != current) {
ffffffffc0205bd6:	00870563          	beq	a4,s0,ffffffffc0205be0 <schedule+0x6e>
            proc_run(next);
ffffffffc0205bda:	8522                	mv	a0,s0
ffffffffc0205bdc:	c91fe0ef          	jal	ra,ffffffffc020486c <proc_run>
    if (flag) {
ffffffffc0205be0:	000a1a63          	bnez	s4,ffffffffc0205bf4 <schedule+0x82>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205be4:	70a2                	ld	ra,40(sp)
ffffffffc0205be6:	7402                	ld	s0,32(sp)
ffffffffc0205be8:	64e2                	ld	s1,24(sp)
ffffffffc0205bea:	6942                	ld	s2,16(sp)
ffffffffc0205bec:	69a2                	ld	s3,8(sp)
ffffffffc0205bee:	6a02                	ld	s4,0(sp)
ffffffffc0205bf0:	6145                	addi	sp,sp,48
ffffffffc0205bf2:	8082                	ret
ffffffffc0205bf4:	7402                	ld	s0,32(sp)
ffffffffc0205bf6:	70a2                	ld	ra,40(sp)
ffffffffc0205bf8:	64e2                	ld	s1,24(sp)
ffffffffc0205bfa:	6942                	ld	s2,16(sp)
ffffffffc0205bfc:	69a2                	ld	s3,8(sp)
ffffffffc0205bfe:	6a02                	ld	s4,0(sp)
ffffffffc0205c00:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0205c02:	dadfa06f          	j	ffffffffc02009ae <intr_enable>
            next = idleproc;
ffffffffc0205c06:	000da417          	auipc	s0,0xda
ffffffffc0205c0a:	54243403          	ld	s0,1346(s0) # ffffffffc02e0148 <idleproc>
ffffffffc0205c0e:	b7c1                	j	ffffffffc0205bce <schedule+0x5c>
    if (proc != idleproc) {
ffffffffc0205c10:	000da717          	auipc	a4,0xda
ffffffffc0205c14:	53873703          	ld	a4,1336(a4) # ffffffffc02e0148 <idleproc>
ffffffffc0205c18:	fae580e3          	beq	a1,a4,ffffffffc0205bb8 <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc0205c1c:	6b9c                	ld	a5,16(a5)
ffffffffc0205c1e:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc0205c20:	0009b783          	ld	a5,0(s3)
ffffffffc0205c24:	00093503          	ld	a0,0(s2)
ffffffffc0205c28:	bf41                	j	ffffffffc0205bb8 <schedule+0x46>
        intr_disable();
ffffffffc0205c2a:	d8bfa0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205c2e:	4a05                	li	s4,1
ffffffffc0205c30:	bfa9                	j	ffffffffc0205b8a <schedule+0x18>

ffffffffc0205c32 <add_timer>:

// add timer to timer_list
void
add_timer(timer_t *timer) {
ffffffffc0205c32:	1141                	addi	sp,sp,-16
ffffffffc0205c34:	e022                	sd	s0,0(sp)
ffffffffc0205c36:	e406                	sd	ra,8(sp)
ffffffffc0205c38:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205c3a:	100027f3          	csrr	a5,sstatus
ffffffffc0205c3e:	8b89                	andi	a5,a5,2
ffffffffc0205c40:	4501                	li	a0,0
ffffffffc0205c42:	eba5                	bnez	a5,ffffffffc0205cb2 <add_timer+0x80>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        assert(timer->expires > 0 && timer->proc != NULL);
ffffffffc0205c44:	401c                	lw	a5,0(s0)
ffffffffc0205c46:	cbb5                	beqz	a5,ffffffffc0205cba <add_timer+0x88>
ffffffffc0205c48:	6418                	ld	a4,8(s0)
ffffffffc0205c4a:	cb25                	beqz	a4,ffffffffc0205cba <add_timer+0x88>
        assert(list_empty(&(timer->timer_link)));
ffffffffc0205c4c:	6c18                	ld	a4,24(s0)
ffffffffc0205c4e:	01040593          	addi	a1,s0,16
ffffffffc0205c52:	08e59463          	bne	a1,a4,ffffffffc0205cda <add_timer+0xa8>
    return listelm->next;
ffffffffc0205c56:	000da617          	auipc	a2,0xda
ffffffffc0205c5a:	48260613          	addi	a2,a2,1154 # ffffffffc02e00d8 <timer_list>
ffffffffc0205c5e:	6618                	ld	a4,8(a2)
        list_entry_t *le = list_next(&timer_list);
        while (le != &timer_list) {
ffffffffc0205c60:	00c71863          	bne	a4,a2,ffffffffc0205c70 <add_timer+0x3e>
ffffffffc0205c64:	a80d                	j	ffffffffc0205c96 <add_timer+0x64>
ffffffffc0205c66:	6718                	ld	a4,8(a4)
            timer_t *next = le2timer(le, timer_link);
            if (timer->expires < next->expires) {
                next->expires -= timer->expires;
                break;
            }
            timer->expires -= next->expires;
ffffffffc0205c68:	9f95                	subw	a5,a5,a3
ffffffffc0205c6a:	c01c                	sw	a5,0(s0)
        while (le != &timer_list) {
ffffffffc0205c6c:	02c70563          	beq	a4,a2,ffffffffc0205c96 <add_timer+0x64>
            if (timer->expires < next->expires) {
ffffffffc0205c70:	ff072683          	lw	a3,-16(a4)
ffffffffc0205c74:	fed7f9e3          	bgeu	a5,a3,ffffffffc0205c66 <add_timer+0x34>
                next->expires -= timer->expires;
ffffffffc0205c78:	40f687bb          	subw	a5,a3,a5
ffffffffc0205c7c:	fef72823          	sw	a5,-16(a4)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0205c80:	631c                	ld	a5,0(a4)
    prev->next = next->prev = elm;
ffffffffc0205c82:	e30c                	sd	a1,0(a4)
ffffffffc0205c84:	e78c                	sd	a1,8(a5)
    elm->next = next;
ffffffffc0205c86:	ec18                	sd	a4,24(s0)
    elm->prev = prev;
ffffffffc0205c88:	e81c                	sd	a5,16(s0)
    if (flag) {
ffffffffc0205c8a:	c105                	beqz	a0,ffffffffc0205caa <add_timer+0x78>
            le = list_next(le);
        }
        list_add_before(le, &(timer->timer_link));
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205c8c:	6402                	ld	s0,0(sp)
ffffffffc0205c8e:	60a2                	ld	ra,8(sp)
ffffffffc0205c90:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205c92:	d1dfa06f          	j	ffffffffc02009ae <intr_enable>
    return 0;
ffffffffc0205c96:	000da717          	auipc	a4,0xda
ffffffffc0205c9a:	44270713          	addi	a4,a4,1090 # ffffffffc02e00d8 <timer_list>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0205c9e:	631c                	ld	a5,0(a4)
    prev->next = next->prev = elm;
ffffffffc0205ca0:	e30c                	sd	a1,0(a4)
ffffffffc0205ca2:	e78c                	sd	a1,8(a5)
    elm->next = next;
ffffffffc0205ca4:	ec18                	sd	a4,24(s0)
    elm->prev = prev;
ffffffffc0205ca6:	e81c                	sd	a5,16(s0)
    if (flag) {
ffffffffc0205ca8:	f175                	bnez	a0,ffffffffc0205c8c <add_timer+0x5a>
ffffffffc0205caa:	60a2                	ld	ra,8(sp)
ffffffffc0205cac:	6402                	ld	s0,0(sp)
ffffffffc0205cae:	0141                	addi	sp,sp,16
ffffffffc0205cb0:	8082                	ret
        intr_disable();
ffffffffc0205cb2:	d03fa0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205cb6:	4505                	li	a0,1
ffffffffc0205cb8:	b771                	j	ffffffffc0205c44 <add_timer+0x12>
        assert(timer->expires > 0 && timer->proc != NULL);
ffffffffc0205cba:	00003697          	auipc	a3,0x3
ffffffffc0205cbe:	abe68693          	addi	a3,a3,-1346 # ffffffffc0208778 <default_pmm_manager+0x1008>
ffffffffc0205cc2:	00001617          	auipc	a2,0x1
ffffffffc0205cc6:	39e60613          	addi	a2,a2,926 # ffffffffc0207060 <commands+0x838>
ffffffffc0205cca:	06c00593          	li	a1,108
ffffffffc0205cce:	00003517          	auipc	a0,0x3
ffffffffc0205cd2:	a7250513          	addi	a0,a0,-1422 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205cd6:	d4cfa0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(list_empty(&(timer->timer_link)));
ffffffffc0205cda:	00003697          	auipc	a3,0x3
ffffffffc0205cde:	ace68693          	addi	a3,a3,-1330 # ffffffffc02087a8 <default_pmm_manager+0x1038>
ffffffffc0205ce2:	00001617          	auipc	a2,0x1
ffffffffc0205ce6:	37e60613          	addi	a2,a2,894 # ffffffffc0207060 <commands+0x838>
ffffffffc0205cea:	06d00593          	li	a1,109
ffffffffc0205cee:	00003517          	auipc	a0,0x3
ffffffffc0205cf2:	a5250513          	addi	a0,a0,-1454 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205cf6:	d2cfa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205cfa <del_timer>:

// del timer from timer_list
void
del_timer(timer_t *timer) {
ffffffffc0205cfa:	1101                	addi	sp,sp,-32
ffffffffc0205cfc:	e822                	sd	s0,16(sp)
ffffffffc0205cfe:	ec06                	sd	ra,24(sp)
ffffffffc0205d00:	e426                	sd	s1,8(sp)
ffffffffc0205d02:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205d04:	100027f3          	csrr	a5,sstatus
ffffffffc0205d08:	8b89                	andi	a5,a5,2
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (!list_empty(&(timer->timer_link))) {
ffffffffc0205d0a:	01050493          	addi	s1,a0,16
ffffffffc0205d0e:	eb9d                	bnez	a5,ffffffffc0205d44 <del_timer+0x4a>
    return list->next == list;
ffffffffc0205d10:	6d1c                	ld	a5,24(a0)
ffffffffc0205d12:	02978463          	beq	a5,s1,ffffffffc0205d3a <del_timer+0x40>
            if (timer->expires != 0) {
ffffffffc0205d16:	4114                	lw	a3,0(a0)
    __list_del(listelm->prev, listelm->next);
ffffffffc0205d18:	6918                	ld	a4,16(a0)
ffffffffc0205d1a:	ce81                	beqz	a3,ffffffffc0205d32 <del_timer+0x38>
                list_entry_t *le = list_next(&(timer->timer_link));
                if (le != &timer_list) {
ffffffffc0205d1c:	000da617          	auipc	a2,0xda
ffffffffc0205d20:	3bc60613          	addi	a2,a2,956 # ffffffffc02e00d8 <timer_list>
ffffffffc0205d24:	00c78763          	beq	a5,a2,ffffffffc0205d32 <del_timer+0x38>
                    timer_t *next = le2timer(le, timer_link);
                    next->expires += timer->expires;
ffffffffc0205d28:	ff07a603          	lw	a2,-16(a5)
ffffffffc0205d2c:	9eb1                	addw	a3,a3,a2
ffffffffc0205d2e:	fed7a823          	sw	a3,-16(a5)
    prev->next = next;
ffffffffc0205d32:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0205d34:	e398                	sd	a4,0(a5)
    elm->prev = elm->next = elm;
ffffffffc0205d36:	ec04                	sd	s1,24(s0)
ffffffffc0205d38:	e804                	sd	s1,16(s0)
            }
            list_del_init(&(timer->timer_link));
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205d3a:	60e2                	ld	ra,24(sp)
ffffffffc0205d3c:	6442                	ld	s0,16(sp)
ffffffffc0205d3e:	64a2                	ld	s1,8(sp)
ffffffffc0205d40:	6105                	addi	sp,sp,32
ffffffffc0205d42:	8082                	ret
        intr_disable();
ffffffffc0205d44:	c71fa0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    return list->next == list;
ffffffffc0205d48:	6c1c                	ld	a5,24(s0)
        if (!list_empty(&(timer->timer_link))) {
ffffffffc0205d4a:	02978463          	beq	a5,s1,ffffffffc0205d72 <del_timer+0x78>
            if (timer->expires != 0) {
ffffffffc0205d4e:	4014                	lw	a3,0(s0)
    __list_del(listelm->prev, listelm->next);
ffffffffc0205d50:	6818                	ld	a4,16(s0)
ffffffffc0205d52:	ce81                	beqz	a3,ffffffffc0205d6a <del_timer+0x70>
                if (le != &timer_list) {
ffffffffc0205d54:	000da617          	auipc	a2,0xda
ffffffffc0205d58:	38460613          	addi	a2,a2,900 # ffffffffc02e00d8 <timer_list>
ffffffffc0205d5c:	00c78763          	beq	a5,a2,ffffffffc0205d6a <del_timer+0x70>
                    next->expires += timer->expires;
ffffffffc0205d60:	ff07a603          	lw	a2,-16(a5)
ffffffffc0205d64:	9eb1                	addw	a3,a3,a2
ffffffffc0205d66:	fed7a823          	sw	a3,-16(a5)
    prev->next = next;
ffffffffc0205d6a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0205d6c:	e398                	sd	a4,0(a5)
    elm->prev = elm->next = elm;
ffffffffc0205d6e:	ec04                	sd	s1,24(s0)
ffffffffc0205d70:	e804                	sd	s1,16(s0)
}
ffffffffc0205d72:	6442                	ld	s0,16(sp)
ffffffffc0205d74:	60e2                	ld	ra,24(sp)
ffffffffc0205d76:	64a2                	ld	s1,8(sp)
ffffffffc0205d78:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205d7a:	c35fa06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0205d7e <run_timer_list>:

// call scheduler to update tick related info, and check the timer is expired? If expired, then wakup proc
void
run_timer_list(void) {
ffffffffc0205d7e:	7139                	addi	sp,sp,-64
ffffffffc0205d80:	fc06                	sd	ra,56(sp)
ffffffffc0205d82:	f822                	sd	s0,48(sp)
ffffffffc0205d84:	f426                	sd	s1,40(sp)
ffffffffc0205d86:	f04a                	sd	s2,32(sp)
ffffffffc0205d88:	ec4e                	sd	s3,24(sp)
ffffffffc0205d8a:	e852                	sd	s4,16(sp)
ffffffffc0205d8c:	e456                	sd	s5,8(sp)
ffffffffc0205d8e:	e05a                	sd	s6,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205d90:	100027f3          	csrr	a5,sstatus
ffffffffc0205d94:	8b89                	andi	a5,a5,2
ffffffffc0205d96:	4b01                	li	s6,0
ffffffffc0205d98:	eff9                	bnez	a5,ffffffffc0205e76 <run_timer_list+0xf8>
    return listelm->next;
ffffffffc0205d9a:	000da997          	auipc	s3,0xda
ffffffffc0205d9e:	33e98993          	addi	s3,s3,830 # ffffffffc02e00d8 <timer_list>
ffffffffc0205da2:	0089b403          	ld	s0,8(s3)
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        list_entry_t *le = list_next(&timer_list);
        if (le != &timer_list) {
ffffffffc0205da6:	07340a63          	beq	s0,s3,ffffffffc0205e1a <run_timer_list+0x9c>
            timer_t *timer = le2timer(le, timer_link);
            assert(timer->expires != 0);
ffffffffc0205daa:	ff042783          	lw	a5,-16(s0)
            timer_t *timer = le2timer(le, timer_link);
ffffffffc0205dae:	ff040913          	addi	s2,s0,-16
            assert(timer->expires != 0);
ffffffffc0205db2:	0e078663          	beqz	a5,ffffffffc0205e9e <run_timer_list+0x120>
            timer->expires --;
ffffffffc0205db6:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205dba:	fee42823          	sw	a4,-16(s0)
            while (timer->expires == 0) {
ffffffffc0205dbe:	ef31                	bnez	a4,ffffffffc0205e1a <run_timer_list+0x9c>
                struct proc_struct *proc = timer->proc;
                if (proc->wait_state != 0) {
                    assert(proc->wait_state & WT_INTERRUPTED);
                }
                else {
                    warn("process %d's wait_state == 0.\n", proc->pid);
ffffffffc0205dc0:	00003a97          	auipc	s5,0x3
ffffffffc0205dc4:	a50a8a93          	addi	s5,s5,-1456 # ffffffffc0208810 <default_pmm_manager+0x10a0>
ffffffffc0205dc8:	00003a17          	auipc	s4,0x3
ffffffffc0205dcc:	978a0a13          	addi	s4,s4,-1672 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205dd0:	a005                	j	ffffffffc0205df0 <run_timer_list+0x72>
                    assert(proc->wait_state & WT_INTERRUPTED);
ffffffffc0205dd2:	0a07d663          	bgez	a5,ffffffffc0205e7e <run_timer_list+0x100>
                }
                wakeup_proc(proc);
ffffffffc0205dd6:	8526                	mv	a0,s1
ffffffffc0205dd8:	ce9ff0ef          	jal	ra,ffffffffc0205ac0 <wakeup_proc>
                del_timer(timer);
ffffffffc0205ddc:	854a                	mv	a0,s2
ffffffffc0205dde:	f1dff0ef          	jal	ra,ffffffffc0205cfa <del_timer>
                if (le == &timer_list) {
ffffffffc0205de2:	03340c63          	beq	s0,s3,ffffffffc0205e1a <run_timer_list+0x9c>
            while (timer->expires == 0) {
ffffffffc0205de6:	ff042783          	lw	a5,-16(s0)
                    break;
                }
                timer = le2timer(le, timer_link);
ffffffffc0205dea:	ff040913          	addi	s2,s0,-16
            while (timer->expires == 0) {
ffffffffc0205dee:	e795                	bnez	a5,ffffffffc0205e1a <run_timer_list+0x9c>
                struct proc_struct *proc = timer->proc;
ffffffffc0205df0:	00893483          	ld	s1,8(s2)
ffffffffc0205df4:	6400                	ld	s0,8(s0)
                if (proc->wait_state != 0) {
ffffffffc0205df6:	0ec4a783          	lw	a5,236(s1)
ffffffffc0205dfa:	ffe1                	bnez	a5,ffffffffc0205dd2 <run_timer_list+0x54>
                    warn("process %d's wait_state == 0.\n", proc->pid);
ffffffffc0205dfc:	40d4                	lw	a3,4(s1)
ffffffffc0205dfe:	8656                	mv	a2,s5
ffffffffc0205e00:	0a300593          	li	a1,163
ffffffffc0205e04:	8552                	mv	a0,s4
ffffffffc0205e06:	c84fa0ef          	jal	ra,ffffffffc020028a <__warn>
                wakeup_proc(proc);
ffffffffc0205e0a:	8526                	mv	a0,s1
ffffffffc0205e0c:	cb5ff0ef          	jal	ra,ffffffffc0205ac0 <wakeup_proc>
                del_timer(timer);
ffffffffc0205e10:	854a                	mv	a0,s2
ffffffffc0205e12:	ee9ff0ef          	jal	ra,ffffffffc0205cfa <del_timer>
                if (le == &timer_list) {
ffffffffc0205e16:	fd3418e3          	bne	s0,s3,ffffffffc0205de6 <run_timer_list+0x68>
            }
        }
        sched_class_proc_tick(current);
ffffffffc0205e1a:	000da597          	auipc	a1,0xda
ffffffffc0205e1e:	3265b583          	ld	a1,806(a1) # ffffffffc02e0140 <current>
    if (proc != idleproc) {
ffffffffc0205e22:	000da797          	auipc	a5,0xda
ffffffffc0205e26:	3267b783          	ld	a5,806(a5) # ffffffffc02e0148 <idleproc>
ffffffffc0205e2a:	04f58363          	beq	a1,a5,ffffffffc0205e70 <run_timer_list+0xf2>
        sched_class->proc_tick(rq, proc);
ffffffffc0205e2e:	000da797          	auipc	a5,0xda
ffffffffc0205e32:	33a7b783          	ld	a5,826(a5) # ffffffffc02e0168 <sched_class>
ffffffffc0205e36:	779c                	ld	a5,40(a5)
ffffffffc0205e38:	000da517          	auipc	a0,0xda
ffffffffc0205e3c:	32853503          	ld	a0,808(a0) # ffffffffc02e0160 <rq>
ffffffffc0205e40:	9782                	jalr	a5
    if (flag) {
ffffffffc0205e42:	000b1c63          	bnez	s6,ffffffffc0205e5a <run_timer_list+0xdc>
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205e46:	70e2                	ld	ra,56(sp)
ffffffffc0205e48:	7442                	ld	s0,48(sp)
ffffffffc0205e4a:	74a2                	ld	s1,40(sp)
ffffffffc0205e4c:	7902                	ld	s2,32(sp)
ffffffffc0205e4e:	69e2                	ld	s3,24(sp)
ffffffffc0205e50:	6a42                	ld	s4,16(sp)
ffffffffc0205e52:	6aa2                	ld	s5,8(sp)
ffffffffc0205e54:	6b02                	ld	s6,0(sp)
ffffffffc0205e56:	6121                	addi	sp,sp,64
ffffffffc0205e58:	8082                	ret
ffffffffc0205e5a:	7442                	ld	s0,48(sp)
ffffffffc0205e5c:	70e2                	ld	ra,56(sp)
ffffffffc0205e5e:	74a2                	ld	s1,40(sp)
ffffffffc0205e60:	7902                	ld	s2,32(sp)
ffffffffc0205e62:	69e2                	ld	s3,24(sp)
ffffffffc0205e64:	6a42                	ld	s4,16(sp)
ffffffffc0205e66:	6aa2                	ld	s5,8(sp)
ffffffffc0205e68:	6b02                	ld	s6,0(sp)
ffffffffc0205e6a:	6121                	addi	sp,sp,64
        intr_enable();
ffffffffc0205e6c:	b43fa06f          	j	ffffffffc02009ae <intr_enable>
        proc->need_resched = 1;
ffffffffc0205e70:	4785                	li	a5,1
ffffffffc0205e72:	ed9c                	sd	a5,24(a1)
ffffffffc0205e74:	b7f9                	j	ffffffffc0205e42 <run_timer_list+0xc4>
        intr_disable();
ffffffffc0205e76:	b3ffa0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205e7a:	4b05                	li	s6,1
ffffffffc0205e7c:	bf39                	j	ffffffffc0205d9a <run_timer_list+0x1c>
                    assert(proc->wait_state & WT_INTERRUPTED);
ffffffffc0205e7e:	00003697          	auipc	a3,0x3
ffffffffc0205e82:	96a68693          	addi	a3,a3,-1686 # ffffffffc02087e8 <default_pmm_manager+0x1078>
ffffffffc0205e86:	00001617          	auipc	a2,0x1
ffffffffc0205e8a:	1da60613          	addi	a2,a2,474 # ffffffffc0207060 <commands+0x838>
ffffffffc0205e8e:	0a000593          	li	a1,160
ffffffffc0205e92:	00003517          	auipc	a0,0x3
ffffffffc0205e96:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205e9a:	b88fa0ef          	jal	ra,ffffffffc0200222 <__panic>
            assert(timer->expires != 0);
ffffffffc0205e9e:	00003697          	auipc	a3,0x3
ffffffffc0205ea2:	93268693          	addi	a3,a3,-1742 # ffffffffc02087d0 <default_pmm_manager+0x1060>
ffffffffc0205ea6:	00001617          	auipc	a2,0x1
ffffffffc0205eaa:	1ba60613          	addi	a2,a2,442 # ffffffffc0207060 <commands+0x838>
ffffffffc0205eae:	09a00593          	li	a1,154
ffffffffc0205eb2:	00003517          	auipc	a0,0x3
ffffffffc0205eb6:	88e50513          	addi	a0,a0,-1906 # ffffffffc0208740 <default_pmm_manager+0xfd0>
ffffffffc0205eba:	b68fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205ebe <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc0205ebe:	e508                	sd	a0,8(a0)
ffffffffc0205ec0:	e108                	sd	a0,0(a0)
static void
RR_init(struct run_queue *rq)
{
    // LAB6: 填写你在lab6中实现的代码
    list_init(&(rq->run_list));
    rq->proc_num = 0;
ffffffffc0205ec2:	00052823          	sw	zero,16(a0)
}
ffffffffc0205ec6:	8082                	ret

ffffffffc0205ec8 <RR_pick_next>:
    return listelm->next;
ffffffffc0205ec8:	651c                	ld	a5,8(a0)
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    // LAB6: 填写你在lab6中实现的代码
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
ffffffffc0205eca:	00f50563          	beq	a0,a5,ffffffffc0205ed4 <RR_pick_next+0xc>
        return le2proc(le, run_link);
ffffffffc0205ece:	ef078513          	addi	a0,a5,-272
ffffffffc0205ed2:	8082                	ret
    }
    return NULL;
ffffffffc0205ed4:	4501                	li	a0,0
}
ffffffffc0205ed6:	8082                	ret

ffffffffc0205ed8 <RR_proc_tick>:
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: 填写你在lab6中实现的代码
    if (proc->time_slice > 0) {
ffffffffc0205ed8:	1205a783          	lw	a5,288(a1)
ffffffffc0205edc:	00f05563          	blez	a5,ffffffffc0205ee6 <RR_proc_tick+0xe>
        proc->time_slice--;
ffffffffc0205ee0:	37fd                	addiw	a5,a5,-1
ffffffffc0205ee2:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc0205ee6:	e399                	bnez	a5,ffffffffc0205eec <RR_proc_tick+0x14>
        proc->need_resched = 1;
ffffffffc0205ee8:	4785                	li	a5,1
ffffffffc0205eea:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc0205eec:	8082                	ret

ffffffffc0205eee <RR_dequeue>:
    assert(!list_empty(&(rq->run_list)) && proc->rq == rq);
ffffffffc0205eee:	651c                	ld	a5,8(a0)
ffffffffc0205ef0:	02f50663          	beq	a0,a5,ffffffffc0205f1c <RR_dequeue+0x2e>
ffffffffc0205ef4:	1085b783          	ld	a5,264(a1)
ffffffffc0205ef8:	02a79263          	bne	a5,a0,ffffffffc0205f1c <RR_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc0205efc:	1105b503          	ld	a0,272(a1)
ffffffffc0205f00:	1185b603          	ld	a2,280(a1)
    rq->proc_num--;
ffffffffc0205f04:	4b98                	lw	a4,16(a5)
    list_del_init(&(proc->run_link));
ffffffffc0205f06:	11058693          	addi	a3,a1,272
    prev->next = next;
ffffffffc0205f0a:	e510                	sd	a2,8(a0)
    next->prev = prev;
ffffffffc0205f0c:	e208                	sd	a0,0(a2)
    elm->prev = elm->next = elm;
ffffffffc0205f0e:	10d5bc23          	sd	a3,280(a1)
ffffffffc0205f12:	10d5b823          	sd	a3,272(a1)
    rq->proc_num--;
ffffffffc0205f16:	377d                	addiw	a4,a4,-1
ffffffffc0205f18:	cb98                	sw	a4,16(a5)
ffffffffc0205f1a:	8082                	ret
{
ffffffffc0205f1c:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(rq->run_list)) && proc->rq == rq);
ffffffffc0205f1e:	00003697          	auipc	a3,0x3
ffffffffc0205f22:	91268693          	addi	a3,a3,-1774 # ffffffffc0208830 <default_pmm_manager+0x10c0>
ffffffffc0205f26:	00001617          	auipc	a2,0x1
ffffffffc0205f2a:	13a60613          	addi	a2,a2,314 # ffffffffc0207060 <commands+0x838>
ffffffffc0205f2e:	03c00593          	li	a1,60
ffffffffc0205f32:	00003517          	auipc	a0,0x3
ffffffffc0205f36:	92e50513          	addi	a0,a0,-1746 # ffffffffc0208860 <default_pmm_manager+0x10f0>
{
ffffffffc0205f3a:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(rq->run_list)) && proc->rq == rq);
ffffffffc0205f3c:	ae6fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205f40 <RR_enqueue>:
    assert(list_empty(&(proc->run_link)));
ffffffffc0205f40:	1185b703          	ld	a4,280(a1)
ffffffffc0205f44:	11058793          	addi	a5,a1,272
ffffffffc0205f48:	02e79d63          	bne	a5,a4,ffffffffc0205f82 <RR_enqueue+0x42>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0205f4c:	6118                	ld	a4,0(a0)
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc0205f4e:	1205a683          	lw	a3,288(a1)
    prev->next = next->prev = elm;
ffffffffc0205f52:	e11c                	sd	a5,0(a0)
ffffffffc0205f54:	e71c                	sd	a5,8(a4)
    elm->next = next;
ffffffffc0205f56:	10a5bc23          	sd	a0,280(a1)
    elm->prev = prev;
ffffffffc0205f5a:	10e5b823          	sd	a4,272(a1)
ffffffffc0205f5e:	495c                	lw	a5,20(a0)
ffffffffc0205f60:	ea89                	bnez	a3,ffffffffc0205f72 <RR_enqueue+0x32>
        proc->time_slice = rq->max_time_slice;
ffffffffc0205f62:	12f5a023          	sw	a5,288(a1)
    rq->proc_num++;
ffffffffc0205f66:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0205f68:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc0205f6c:	2785                	addiw	a5,a5,1
ffffffffc0205f6e:	c91c                	sw	a5,16(a0)
ffffffffc0205f70:	8082                	ret
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc0205f72:	fed7c8e3          	blt	a5,a3,ffffffffc0205f62 <RR_enqueue+0x22>
    rq->proc_num++;
ffffffffc0205f76:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0205f78:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc0205f7c:	2785                	addiw	a5,a5,1
ffffffffc0205f7e:	c91c                	sw	a5,16(a0)
ffffffffc0205f80:	8082                	ret
{
ffffffffc0205f82:	1141                	addi	sp,sp,-16
    assert(list_empty(&(proc->run_link)));
ffffffffc0205f84:	00003697          	auipc	a3,0x3
ffffffffc0205f88:	8fc68693          	addi	a3,a3,-1796 # ffffffffc0208880 <default_pmm_manager+0x1110>
ffffffffc0205f8c:	00001617          	auipc	a2,0x1
ffffffffc0205f90:	0d460613          	addi	a2,a2,212 # ffffffffc0207060 <commands+0x838>
ffffffffc0205f94:	02800593          	li	a1,40
ffffffffc0205f98:	00003517          	auipc	a0,0x3
ffffffffc0205f9c:	8c850513          	addi	a0,a0,-1848 # ffffffffc0208860 <default_pmm_manager+0x10f0>
{
ffffffffc0205fa0:	e406                	sd	ra,8(sp)
    assert(list_empty(&(proc->run_link)));
ffffffffc0205fa2:	a80fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205fa6 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205fa6:	000da797          	auipc	a5,0xda
ffffffffc0205faa:	19a7b783          	ld	a5,410(a5) # ffffffffc02e0140 <current>
}
ffffffffc0205fae:	43c8                	lw	a0,4(a5)
ffffffffc0205fb0:	8082                	ret

ffffffffc0205fb2 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205fb2:	4501                	li	a0,0
ffffffffc0205fb4:	8082                	ret

ffffffffc0205fb6 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc0205fb6:	000da797          	auipc	a5,0xda
ffffffffc0205fba:	14a7b783          	ld	a5,330(a5) # ffffffffc02e0100 <ticks>
ffffffffc0205fbe:	0027951b          	slliw	a0,a5,0x2
ffffffffc0205fc2:	9d3d                	addw	a0,a0,a5
}
ffffffffc0205fc4:	0015151b          	slliw	a0,a0,0x1
ffffffffc0205fc8:	8082                	ret

ffffffffc0205fca <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc0205fca:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc0205fcc:	1141                	addi	sp,sp,-16
ffffffffc0205fce:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc0205fd0:	9e1ff0ef          	jal	ra,ffffffffc02059b0 <lab6_set_priority>
    return 0;
}
ffffffffc0205fd4:	60a2                	ld	ra,8(sp)
ffffffffc0205fd6:	4501                	li	a0,0
ffffffffc0205fd8:	0141                	addi	sp,sp,16
ffffffffc0205fda:	8082                	ret

ffffffffc0205fdc <sys_putc>:
    cputchar(c);
ffffffffc0205fdc:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205fde:	1141                	addi	sp,sp,-16
ffffffffc0205fe0:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205fe2:	938fa0ef          	jal	ra,ffffffffc020011a <cputchar>
}
ffffffffc0205fe6:	60a2                	ld	ra,8(sp)
ffffffffc0205fe8:	4501                	li	a0,0
ffffffffc0205fea:	0141                	addi	sp,sp,16
ffffffffc0205fec:	8082                	ret

ffffffffc0205fee <sys_kill>:
    return do_kill(pid);
ffffffffc0205fee:	4108                	lw	a0,0(a0)
ffffffffc0205ff0:	f92ff06f          	j	ffffffffc0205782 <do_kill>

ffffffffc0205ff4 <sys_sleep>:
static int
sys_sleep(uint64_t arg[]) {
    unsigned int time = (unsigned int)arg[0];
    return do_sleep(time);
ffffffffc0205ff4:	4108                	lw	a0,0(a0)
ffffffffc0205ff6:	9f5ff06f          	j	ffffffffc02059ea <do_sleep>

ffffffffc0205ffa <sys_yield>:
    return do_yield();
ffffffffc0205ffa:	f3aff06f          	j	ffffffffc0205734 <do_yield>

ffffffffc0205ffe <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205ffe:	6d14                	ld	a3,24(a0)
ffffffffc0206000:	6910                	ld	a2,16(a0)
ffffffffc0206002:	650c                	ld	a1,8(a0)
ffffffffc0206004:	6108                	ld	a0,0(a0)
ffffffffc0206006:	97eff06f          	j	ffffffffc0205184 <do_execve>

ffffffffc020600a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020600a:	650c                	ld	a1,8(a0)
ffffffffc020600c:	4108                	lw	a0,0(a0)
ffffffffc020600e:	f36ff06f          	j	ffffffffc0205744 <do_wait>

ffffffffc0206012 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0206012:	000da797          	auipc	a5,0xda
ffffffffc0206016:	12e7b783          	ld	a5,302(a5) # ffffffffc02e0140 <current>
ffffffffc020601a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020601c:	4501                	li	a0,0
ffffffffc020601e:	6a0c                	ld	a1,16(a2)
ffffffffc0206020:	91bfe06f          	j	ffffffffc020493a <do_fork>

ffffffffc0206024 <sys_exit>:
    return do_exit(error_code);
ffffffffc0206024:	4108                	lw	a0,0(a0)
ffffffffc0206026:	d19fe06f          	j	ffffffffc0204d3e <do_exit>

ffffffffc020602a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020602a:	715d                	addi	sp,sp,-80
ffffffffc020602c:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020602e:	000da497          	auipc	s1,0xda
ffffffffc0206032:	11248493          	addi	s1,s1,274 # ffffffffc02e0140 <current>
ffffffffc0206036:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0206038:	e0a2                	sd	s0,64(sp)
ffffffffc020603a:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020603c:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020603e:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0206040:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc0206044:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0206048:	0327ee63          	bltu	a5,s2,ffffffffc0206084 <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc020604c:	00391713          	slli	a4,s2,0x3
ffffffffc0206050:	00003797          	auipc	a5,0x3
ffffffffc0206054:	8a878793          	addi	a5,a5,-1880 # ffffffffc02088f8 <syscalls>
ffffffffc0206058:	97ba                	add	a5,a5,a4
ffffffffc020605a:	639c                	ld	a5,0(a5)
ffffffffc020605c:	c785                	beqz	a5,ffffffffc0206084 <syscall+0x5a>
            arg[0] = tf->gpr.a1;
ffffffffc020605e:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc0206060:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc0206062:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc0206064:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc0206066:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0206068:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc020606a:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc020606c:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc020606e:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc0206070:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0206072:	0028                	addi	a0,sp,8
ffffffffc0206074:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0206076:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0206078:	e828                	sd	a0,80(s0)
}
ffffffffc020607a:	6406                	ld	s0,64(sp)
ffffffffc020607c:	74e2                	ld	s1,56(sp)
ffffffffc020607e:	7942                	ld	s2,48(sp)
ffffffffc0206080:	6161                	addi	sp,sp,80
ffffffffc0206082:	8082                	ret
    print_trapframe(tf);
ffffffffc0206084:	8522                	mv	a0,s0
ffffffffc0206086:	b1dfa0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020608a:	609c                	ld	a5,0(s1)
ffffffffc020608c:	86ca                	mv	a3,s2
ffffffffc020608e:	00003617          	auipc	a2,0x3
ffffffffc0206092:	82260613          	addi	a2,a2,-2014 # ffffffffc02088b0 <default_pmm_manager+0x1140>
ffffffffc0206096:	43d8                	lw	a4,4(a5)
ffffffffc0206098:	07300593          	li	a1,115
ffffffffc020609c:	0b478793          	addi	a5,a5,180
ffffffffc02060a0:	00003517          	auipc	a0,0x3
ffffffffc02060a4:	84050513          	addi	a0,a0,-1984 # ffffffffc02088e0 <default_pmm_manager+0x1170>
ffffffffc02060a8:	97afa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02060ac <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02060ac:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02060b0:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02060b2:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02060b4:	cb81                	beqz	a5,ffffffffc02060c4 <strlen+0x18>
        cnt ++;
ffffffffc02060b6:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02060b8:	00a707b3          	add	a5,a4,a0
ffffffffc02060bc:	0007c783          	lbu	a5,0(a5)
ffffffffc02060c0:	fbfd                	bnez	a5,ffffffffc02060b6 <strlen+0xa>
ffffffffc02060c2:	8082                	ret
    }
    return cnt;
}
ffffffffc02060c4:	8082                	ret

ffffffffc02060c6 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02060c6:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02060c8:	e589                	bnez	a1,ffffffffc02060d2 <strnlen+0xc>
ffffffffc02060ca:	a811                	j	ffffffffc02060de <strnlen+0x18>
        cnt ++;
ffffffffc02060cc:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02060ce:	00f58863          	beq	a1,a5,ffffffffc02060de <strnlen+0x18>
ffffffffc02060d2:	00f50733          	add	a4,a0,a5
ffffffffc02060d6:	00074703          	lbu	a4,0(a4)
ffffffffc02060da:	fb6d                	bnez	a4,ffffffffc02060cc <strnlen+0x6>
ffffffffc02060dc:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02060de:	852e                	mv	a0,a1
ffffffffc02060e0:	8082                	ret

ffffffffc02060e2 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02060e2:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02060e4:	0005c703          	lbu	a4,0(a1)
ffffffffc02060e8:	0785                	addi	a5,a5,1
ffffffffc02060ea:	0585                	addi	a1,a1,1
ffffffffc02060ec:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02060f0:	fb75                	bnez	a4,ffffffffc02060e4 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02060f2:	8082                	ret

ffffffffc02060f4 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02060f4:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02060f8:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02060fc:	cb89                	beqz	a5,ffffffffc020610e <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02060fe:	0505                	addi	a0,a0,1
ffffffffc0206100:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0206102:	fee789e3          	beq	a5,a4,ffffffffc02060f4 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206106:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020610a:	9d19                	subw	a0,a0,a4
ffffffffc020610c:	8082                	ret
ffffffffc020610e:	4501                	li	a0,0
ffffffffc0206110:	bfed                	j	ffffffffc020610a <strcmp+0x16>

ffffffffc0206112 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206112:	c20d                	beqz	a2,ffffffffc0206134 <strncmp+0x22>
ffffffffc0206114:	962e                	add	a2,a2,a1
ffffffffc0206116:	a031                	j	ffffffffc0206122 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0206118:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020611a:	00e79a63          	bne	a5,a4,ffffffffc020612e <strncmp+0x1c>
ffffffffc020611e:	00b60b63          	beq	a2,a1,ffffffffc0206134 <strncmp+0x22>
ffffffffc0206122:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0206126:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0206128:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020612c:	f7f5                	bnez	a5,ffffffffc0206118 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020612e:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0206132:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0206134:	4501                	li	a0,0
ffffffffc0206136:	8082                	ret

ffffffffc0206138 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0206138:	00054783          	lbu	a5,0(a0)
ffffffffc020613c:	c799                	beqz	a5,ffffffffc020614a <strchr+0x12>
        if (*s == c) {
ffffffffc020613e:	00f58763          	beq	a1,a5,ffffffffc020614c <strchr+0x14>
    while (*s != '\0') {
ffffffffc0206142:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0206146:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0206148:	fbfd                	bnez	a5,ffffffffc020613e <strchr+0x6>
    }
    return NULL;
ffffffffc020614a:	4501                	li	a0,0
}
ffffffffc020614c:	8082                	ret

ffffffffc020614e <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020614e:	ca01                	beqz	a2,ffffffffc020615e <memset+0x10>
ffffffffc0206150:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0206152:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0206154:	0785                	addi	a5,a5,1
ffffffffc0206156:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020615a:	fec79de3          	bne	a5,a2,ffffffffc0206154 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020615e:	8082                	ret

ffffffffc0206160 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0206160:	ca19                	beqz	a2,ffffffffc0206176 <memcpy+0x16>
ffffffffc0206162:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0206164:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0206166:	0005c703          	lbu	a4,0(a1)
ffffffffc020616a:	0585                	addi	a1,a1,1
ffffffffc020616c:	0785                	addi	a5,a5,1
ffffffffc020616e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0206172:	fec59ae3          	bne	a1,a2,ffffffffc0206166 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0206176:	8082                	ret

ffffffffc0206178 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0206178:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020617c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020617e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0206182:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0206184:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0206188:	f022                	sd	s0,32(sp)
ffffffffc020618a:	ec26                	sd	s1,24(sp)
ffffffffc020618c:	e84a                	sd	s2,16(sp)
ffffffffc020618e:	f406                	sd	ra,40(sp)
ffffffffc0206190:	e44e                	sd	s3,8(sp)
ffffffffc0206192:	84aa                	mv	s1,a0
ffffffffc0206194:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0206196:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020619a:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020619c:	03067e63          	bgeu	a2,a6,ffffffffc02061d8 <printnum+0x60>
ffffffffc02061a0:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02061a2:	00805763          	blez	s0,ffffffffc02061b0 <printnum+0x38>
ffffffffc02061a6:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02061a8:	85ca                	mv	a1,s2
ffffffffc02061aa:	854e                	mv	a0,s3
ffffffffc02061ac:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02061ae:	fc65                	bnez	s0,ffffffffc02061a6 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02061b0:	1a02                	slli	s4,s4,0x20
ffffffffc02061b2:	00003797          	auipc	a5,0x3
ffffffffc02061b6:	f4678793          	addi	a5,a5,-186 # ffffffffc02090f8 <syscalls+0x800>
ffffffffc02061ba:	020a5a13          	srli	s4,s4,0x20
ffffffffc02061be:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02061c0:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02061c2:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02061c6:	70a2                	ld	ra,40(sp)
ffffffffc02061c8:	69a2                	ld	s3,8(sp)
ffffffffc02061ca:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02061cc:	85ca                	mv	a1,s2
ffffffffc02061ce:	87a6                	mv	a5,s1
}
ffffffffc02061d0:	6942                	ld	s2,16(sp)
ffffffffc02061d2:	64e2                	ld	s1,24(sp)
ffffffffc02061d4:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02061d6:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02061d8:	03065633          	divu	a2,a2,a6
ffffffffc02061dc:	8722                	mv	a4,s0
ffffffffc02061de:	f9bff0ef          	jal	ra,ffffffffc0206178 <printnum>
ffffffffc02061e2:	b7f9                	j	ffffffffc02061b0 <printnum+0x38>

ffffffffc02061e4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02061e4:	7119                	addi	sp,sp,-128
ffffffffc02061e6:	f4a6                	sd	s1,104(sp)
ffffffffc02061e8:	f0ca                	sd	s2,96(sp)
ffffffffc02061ea:	ecce                	sd	s3,88(sp)
ffffffffc02061ec:	e8d2                	sd	s4,80(sp)
ffffffffc02061ee:	e4d6                	sd	s5,72(sp)
ffffffffc02061f0:	e0da                	sd	s6,64(sp)
ffffffffc02061f2:	fc5e                	sd	s7,56(sp)
ffffffffc02061f4:	f06a                	sd	s10,32(sp)
ffffffffc02061f6:	fc86                	sd	ra,120(sp)
ffffffffc02061f8:	f8a2                	sd	s0,112(sp)
ffffffffc02061fa:	f862                	sd	s8,48(sp)
ffffffffc02061fc:	f466                	sd	s9,40(sp)
ffffffffc02061fe:	ec6e                	sd	s11,24(sp)
ffffffffc0206200:	892a                	mv	s2,a0
ffffffffc0206202:	84ae                	mv	s1,a1
ffffffffc0206204:	8d32                	mv	s10,a2
ffffffffc0206206:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0206208:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020620c:	5b7d                	li	s6,-1
ffffffffc020620e:	00003a97          	auipc	s5,0x3
ffffffffc0206212:	f16a8a93          	addi	s5,s5,-234 # ffffffffc0209124 <syscalls+0x82c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206216:	00003b97          	auipc	s7,0x3
ffffffffc020621a:	12ab8b93          	addi	s7,s7,298 # ffffffffc0209340 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020621e:	000d4503          	lbu	a0,0(s10)
ffffffffc0206222:	001d0413          	addi	s0,s10,1
ffffffffc0206226:	01350a63          	beq	a0,s3,ffffffffc020623a <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc020622a:	c121                	beqz	a0,ffffffffc020626a <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020622c:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020622e:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0206230:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0206232:	fff44503          	lbu	a0,-1(s0)
ffffffffc0206236:	ff351ae3          	bne	a0,s3,ffffffffc020622a <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020623a:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020623e:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0206242:	4c81                	li	s9,0
ffffffffc0206244:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0206246:	5c7d                	li	s8,-1
ffffffffc0206248:	5dfd                	li	s11,-1
ffffffffc020624a:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020624e:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206250:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0206254:	0ff5f593          	zext.b	a1,a1
ffffffffc0206258:	00140d13          	addi	s10,s0,1
ffffffffc020625c:	04b56263          	bltu	a0,a1,ffffffffc02062a0 <vprintfmt+0xbc>
ffffffffc0206260:	058a                	slli	a1,a1,0x2
ffffffffc0206262:	95d6                	add	a1,a1,s5
ffffffffc0206264:	4194                	lw	a3,0(a1)
ffffffffc0206266:	96d6                	add	a3,a3,s5
ffffffffc0206268:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020626a:	70e6                	ld	ra,120(sp)
ffffffffc020626c:	7446                	ld	s0,112(sp)
ffffffffc020626e:	74a6                	ld	s1,104(sp)
ffffffffc0206270:	7906                	ld	s2,96(sp)
ffffffffc0206272:	69e6                	ld	s3,88(sp)
ffffffffc0206274:	6a46                	ld	s4,80(sp)
ffffffffc0206276:	6aa6                	ld	s5,72(sp)
ffffffffc0206278:	6b06                	ld	s6,64(sp)
ffffffffc020627a:	7be2                	ld	s7,56(sp)
ffffffffc020627c:	7c42                	ld	s8,48(sp)
ffffffffc020627e:	7ca2                	ld	s9,40(sp)
ffffffffc0206280:	7d02                	ld	s10,32(sp)
ffffffffc0206282:	6de2                	ld	s11,24(sp)
ffffffffc0206284:	6109                	addi	sp,sp,128
ffffffffc0206286:	8082                	ret
            padc = '0';
ffffffffc0206288:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020628a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020628e:	846a                	mv	s0,s10
ffffffffc0206290:	00140d13          	addi	s10,s0,1
ffffffffc0206294:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0206298:	0ff5f593          	zext.b	a1,a1
ffffffffc020629c:	fcb572e3          	bgeu	a0,a1,ffffffffc0206260 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02062a0:	85a6                	mv	a1,s1
ffffffffc02062a2:	02500513          	li	a0,37
ffffffffc02062a6:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02062a8:	fff44783          	lbu	a5,-1(s0)
ffffffffc02062ac:	8d22                	mv	s10,s0
ffffffffc02062ae:	f73788e3          	beq	a5,s3,ffffffffc020621e <vprintfmt+0x3a>
ffffffffc02062b2:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02062b6:	1d7d                	addi	s10,s10,-1
ffffffffc02062b8:	ff379de3          	bne	a5,s3,ffffffffc02062b2 <vprintfmt+0xce>
ffffffffc02062bc:	b78d                	j	ffffffffc020621e <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02062be:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02062c2:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02062c6:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02062c8:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02062cc:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02062d0:	02d86463          	bltu	a6,a3,ffffffffc02062f8 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02062d4:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02062d8:	002c169b          	slliw	a3,s8,0x2
ffffffffc02062dc:	0186873b          	addw	a4,a3,s8
ffffffffc02062e0:	0017171b          	slliw	a4,a4,0x1
ffffffffc02062e4:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02062e6:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02062ea:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02062ec:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02062f0:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02062f4:	fed870e3          	bgeu	a6,a3,ffffffffc02062d4 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02062f8:	f40ddce3          	bgez	s11,ffffffffc0206250 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02062fc:	8de2                	mv	s11,s8
ffffffffc02062fe:	5c7d                	li	s8,-1
ffffffffc0206300:	bf81                	j	ffffffffc0206250 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0206302:	fffdc693          	not	a3,s11
ffffffffc0206306:	96fd                	srai	a3,a3,0x3f
ffffffffc0206308:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020630c:	00144603          	lbu	a2,1(s0)
ffffffffc0206310:	2d81                	sext.w	s11,s11
ffffffffc0206312:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0206314:	bf35                	j	ffffffffc0206250 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0206316:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020631a:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc020631e:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206320:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0206322:	bfd9                	j	ffffffffc02062f8 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0206324:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206326:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020632a:	01174463          	blt	a4,a7,ffffffffc0206332 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc020632e:	1a088e63          	beqz	a7,ffffffffc02064ea <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0206332:	000a3603          	ld	a2,0(s4)
ffffffffc0206336:	46c1                	li	a3,16
ffffffffc0206338:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020633a:	2781                	sext.w	a5,a5
ffffffffc020633c:	876e                	mv	a4,s11
ffffffffc020633e:	85a6                	mv	a1,s1
ffffffffc0206340:	854a                	mv	a0,s2
ffffffffc0206342:	e37ff0ef          	jal	ra,ffffffffc0206178 <printnum>
            break;
ffffffffc0206346:	bde1                	j	ffffffffc020621e <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0206348:	000a2503          	lw	a0,0(s4)
ffffffffc020634c:	85a6                	mv	a1,s1
ffffffffc020634e:	0a21                	addi	s4,s4,8
ffffffffc0206350:	9902                	jalr	s2
            break;
ffffffffc0206352:	b5f1                	j	ffffffffc020621e <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0206354:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0206356:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020635a:	01174463          	blt	a4,a7,ffffffffc0206362 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020635e:	18088163          	beqz	a7,ffffffffc02064e0 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0206362:	000a3603          	ld	a2,0(s4)
ffffffffc0206366:	46a9                	li	a3,10
ffffffffc0206368:	8a2e                	mv	s4,a1
ffffffffc020636a:	bfc1                	j	ffffffffc020633a <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020636c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0206370:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206372:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0206374:	bdf1                	j	ffffffffc0206250 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0206376:	85a6                	mv	a1,s1
ffffffffc0206378:	02500513          	li	a0,37
ffffffffc020637c:	9902                	jalr	s2
            break;
ffffffffc020637e:	b545                	j	ffffffffc020621e <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206380:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0206384:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206386:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0206388:	b5e1                	j	ffffffffc0206250 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020638a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020638c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0206390:	01174463          	blt	a4,a7,ffffffffc0206398 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0206394:	14088163          	beqz	a7,ffffffffc02064d6 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0206398:	000a3603          	ld	a2,0(s4)
ffffffffc020639c:	46a1                	li	a3,8
ffffffffc020639e:	8a2e                	mv	s4,a1
ffffffffc02063a0:	bf69                	j	ffffffffc020633a <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02063a2:	03000513          	li	a0,48
ffffffffc02063a6:	85a6                	mv	a1,s1
ffffffffc02063a8:	e03e                	sd	a5,0(sp)
ffffffffc02063aa:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02063ac:	85a6                	mv	a1,s1
ffffffffc02063ae:	07800513          	li	a0,120
ffffffffc02063b2:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02063b4:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02063b6:	6782                	ld	a5,0(sp)
ffffffffc02063b8:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02063ba:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02063be:	bfb5                	j	ffffffffc020633a <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02063c0:	000a3403          	ld	s0,0(s4)
ffffffffc02063c4:	008a0713          	addi	a4,s4,8
ffffffffc02063c8:	e03a                	sd	a4,0(sp)
ffffffffc02063ca:	14040263          	beqz	s0,ffffffffc020650e <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02063ce:	0fb05763          	blez	s11,ffffffffc02064bc <vprintfmt+0x2d8>
ffffffffc02063d2:	02d00693          	li	a3,45
ffffffffc02063d6:	0cd79163          	bne	a5,a3,ffffffffc0206498 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02063da:	00044783          	lbu	a5,0(s0)
ffffffffc02063de:	0007851b          	sext.w	a0,a5
ffffffffc02063e2:	cf85                	beqz	a5,ffffffffc020641a <vprintfmt+0x236>
ffffffffc02063e4:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02063e8:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02063ec:	000c4563          	bltz	s8,ffffffffc02063f6 <vprintfmt+0x212>
ffffffffc02063f0:	3c7d                	addiw	s8,s8,-1
ffffffffc02063f2:	036c0263          	beq	s8,s6,ffffffffc0206416 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02063f6:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02063f8:	0e0c8e63          	beqz	s9,ffffffffc02064f4 <vprintfmt+0x310>
ffffffffc02063fc:	3781                	addiw	a5,a5,-32
ffffffffc02063fe:	0ef47b63          	bgeu	s0,a5,ffffffffc02064f4 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0206402:	03f00513          	li	a0,63
ffffffffc0206406:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206408:	000a4783          	lbu	a5,0(s4)
ffffffffc020640c:	3dfd                	addiw	s11,s11,-1
ffffffffc020640e:	0a05                	addi	s4,s4,1
ffffffffc0206410:	0007851b          	sext.w	a0,a5
ffffffffc0206414:	ffe1                	bnez	a5,ffffffffc02063ec <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0206416:	01b05963          	blez	s11,ffffffffc0206428 <vprintfmt+0x244>
ffffffffc020641a:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc020641c:	85a6                	mv	a1,s1
ffffffffc020641e:	02000513          	li	a0,32
ffffffffc0206422:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0206424:	fe0d9be3          	bnez	s11,ffffffffc020641a <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206428:	6a02                	ld	s4,0(sp)
ffffffffc020642a:	bbd5                	j	ffffffffc020621e <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020642c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020642e:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0206432:	01174463          	blt	a4,a7,ffffffffc020643a <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0206436:	08088d63          	beqz	a7,ffffffffc02064d0 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020643a:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020643e:	0a044d63          	bltz	s0,ffffffffc02064f8 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0206442:	8622                	mv	a2,s0
ffffffffc0206444:	8a66                	mv	s4,s9
ffffffffc0206446:	46a9                	li	a3,10
ffffffffc0206448:	bdcd                	j	ffffffffc020633a <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020644a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020644e:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0206450:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0206452:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0206456:	8fb5                	xor	a5,a5,a3
ffffffffc0206458:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020645c:	02d74163          	blt	a4,a3,ffffffffc020647e <vprintfmt+0x29a>
ffffffffc0206460:	00369793          	slli	a5,a3,0x3
ffffffffc0206464:	97de                	add	a5,a5,s7
ffffffffc0206466:	639c                	ld	a5,0(a5)
ffffffffc0206468:	cb99                	beqz	a5,ffffffffc020647e <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020646a:	86be                	mv	a3,a5
ffffffffc020646c:	00000617          	auipc	a2,0x0
ffffffffc0206470:	13c60613          	addi	a2,a2,316 # ffffffffc02065a8 <etext+0x2c>
ffffffffc0206474:	85a6                	mv	a1,s1
ffffffffc0206476:	854a                	mv	a0,s2
ffffffffc0206478:	0ce000ef          	jal	ra,ffffffffc0206546 <printfmt>
ffffffffc020647c:	b34d                	j	ffffffffc020621e <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020647e:	00003617          	auipc	a2,0x3
ffffffffc0206482:	c9a60613          	addi	a2,a2,-870 # ffffffffc0209118 <syscalls+0x820>
ffffffffc0206486:	85a6                	mv	a1,s1
ffffffffc0206488:	854a                	mv	a0,s2
ffffffffc020648a:	0bc000ef          	jal	ra,ffffffffc0206546 <printfmt>
ffffffffc020648e:	bb41                	j	ffffffffc020621e <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0206490:	00003417          	auipc	s0,0x3
ffffffffc0206494:	c8040413          	addi	s0,s0,-896 # ffffffffc0209110 <syscalls+0x818>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206498:	85e2                	mv	a1,s8
ffffffffc020649a:	8522                	mv	a0,s0
ffffffffc020649c:	e43e                	sd	a5,8(sp)
ffffffffc020649e:	c29ff0ef          	jal	ra,ffffffffc02060c6 <strnlen>
ffffffffc02064a2:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02064a6:	01b05b63          	blez	s11,ffffffffc02064bc <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02064aa:	67a2                	ld	a5,8(sp)
ffffffffc02064ac:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02064b0:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02064b2:	85a6                	mv	a1,s1
ffffffffc02064b4:	8552                	mv	a0,s4
ffffffffc02064b6:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02064b8:	fe0d9ce3          	bnez	s11,ffffffffc02064b0 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02064bc:	00044783          	lbu	a5,0(s0)
ffffffffc02064c0:	00140a13          	addi	s4,s0,1
ffffffffc02064c4:	0007851b          	sext.w	a0,a5
ffffffffc02064c8:	d3a5                	beqz	a5,ffffffffc0206428 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02064ca:	05e00413          	li	s0,94
ffffffffc02064ce:	bf39                	j	ffffffffc02063ec <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02064d0:	000a2403          	lw	s0,0(s4)
ffffffffc02064d4:	b7ad                	j	ffffffffc020643e <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02064d6:	000a6603          	lwu	a2,0(s4)
ffffffffc02064da:	46a1                	li	a3,8
ffffffffc02064dc:	8a2e                	mv	s4,a1
ffffffffc02064de:	bdb1                	j	ffffffffc020633a <vprintfmt+0x156>
ffffffffc02064e0:	000a6603          	lwu	a2,0(s4)
ffffffffc02064e4:	46a9                	li	a3,10
ffffffffc02064e6:	8a2e                	mv	s4,a1
ffffffffc02064e8:	bd89                	j	ffffffffc020633a <vprintfmt+0x156>
ffffffffc02064ea:	000a6603          	lwu	a2,0(s4)
ffffffffc02064ee:	46c1                	li	a3,16
ffffffffc02064f0:	8a2e                	mv	s4,a1
ffffffffc02064f2:	b5a1                	j	ffffffffc020633a <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02064f4:	9902                	jalr	s2
ffffffffc02064f6:	bf09                	j	ffffffffc0206408 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02064f8:	85a6                	mv	a1,s1
ffffffffc02064fa:	02d00513          	li	a0,45
ffffffffc02064fe:	e03e                	sd	a5,0(sp)
ffffffffc0206500:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0206502:	6782                	ld	a5,0(sp)
ffffffffc0206504:	8a66                	mv	s4,s9
ffffffffc0206506:	40800633          	neg	a2,s0
ffffffffc020650a:	46a9                	li	a3,10
ffffffffc020650c:	b53d                	j	ffffffffc020633a <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc020650e:	03b05163          	blez	s11,ffffffffc0206530 <vprintfmt+0x34c>
ffffffffc0206512:	02d00693          	li	a3,45
ffffffffc0206516:	f6d79de3          	bne	a5,a3,ffffffffc0206490 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc020651a:	00003417          	auipc	s0,0x3
ffffffffc020651e:	bf640413          	addi	s0,s0,-1034 # ffffffffc0209110 <syscalls+0x818>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206522:	02800793          	li	a5,40
ffffffffc0206526:	02800513          	li	a0,40
ffffffffc020652a:	00140a13          	addi	s4,s0,1
ffffffffc020652e:	bd6d                	j	ffffffffc02063e8 <vprintfmt+0x204>
ffffffffc0206530:	00003a17          	auipc	s4,0x3
ffffffffc0206534:	be1a0a13          	addi	s4,s4,-1055 # ffffffffc0209111 <syscalls+0x819>
ffffffffc0206538:	02800513          	li	a0,40
ffffffffc020653c:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206540:	05e00413          	li	s0,94
ffffffffc0206544:	b565                	j	ffffffffc02063ec <vprintfmt+0x208>

ffffffffc0206546 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206546:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0206548:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020654c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020654e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206550:	ec06                	sd	ra,24(sp)
ffffffffc0206552:	f83a                	sd	a4,48(sp)
ffffffffc0206554:	fc3e                	sd	a5,56(sp)
ffffffffc0206556:	e0c2                	sd	a6,64(sp)
ffffffffc0206558:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020655a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020655c:	c89ff0ef          	jal	ra,ffffffffc02061e4 <vprintfmt>
}
ffffffffc0206560:	60e2                	ld	ra,24(sp)
ffffffffc0206562:	6161                	addi	sp,sp,80
ffffffffc0206564:	8082                	ret

ffffffffc0206566 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0206566:	9e3707b7          	lui	a5,0x9e370
ffffffffc020656a:	2785                	addiw	a5,a5,1
ffffffffc020656c:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0206570:	02000793          	li	a5,32
ffffffffc0206574:	9f8d                	subw	a5,a5,a1
}
ffffffffc0206576:	00f5553b          	srlw	a0,a0,a5
ffffffffc020657a:	8082                	ret
