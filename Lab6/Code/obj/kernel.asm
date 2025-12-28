
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000c297          	auipc	t0,0xc
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020c000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000c297          	auipc	t0,0xc
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020c008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020b2b7          	lui	t0,0xc020b
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
ffffffffc020003c:	c020b137          	lui	sp,0xc020b

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
ffffffffc020004a:	000c3517          	auipc	a0,0xc3
ffffffffc020004e:	c0650513          	addi	a0,a0,-1018 # ffffffffc02c2c50 <buf>
ffffffffc0200052:	000c7617          	auipc	a2,0xc7
ffffffffc0200056:	0de60613          	addi	a2,a2,222 # ffffffffc02c7130 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	4d4050ef          	jal	ra,ffffffffc0205536 <memset>
    cons_init(); // init the console
ffffffffc0200066:	0d5000ef          	jal	ra,ffffffffc020093a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006a:	00006597          	auipc	a1,0x6
ffffffffc020006e:	8fe58593          	addi	a1,a1,-1794 # ffffffffc0205968 <etext+0x4>
ffffffffc0200072:	00006517          	auipc	a0,0x6
ffffffffc0200076:	91650513          	addi	a0,a0,-1770 # ffffffffc0205988 <etext+0x24>
ffffffffc020007a:	06a000ef          	jal	ra,ffffffffc02000e4 <cprintf>

    print_kerninfo();
ffffffffc020007e:	250000ef          	jal	ra,ffffffffc02002ce <print_kerninfo>

    // grade_backtrace();

    dtb_init(); // init dtb
ffffffffc0200082:	4be000ef          	jal	ra,ffffffffc0200540 <dtb_init>

    pmm_init(); // init physical memory management
ffffffffc0200086:	603020ef          	jal	ra,ffffffffc0202e88 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	123000ef          	jal	ra,ffffffffc02009ac <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12d000ef          	jal	ra,ffffffffc02009ba <idt_init>

    vmm_init(); // init virtual memory management
ffffffffc0200092:	2e2010ef          	jal	ra,ffffffffc0201374 <vmm_init>
    sched_init();
ffffffffc0200096:	052050ef          	jal	ra,ffffffffc02050e8 <sched_init>
    proc_init(); // init process table
ffffffffc020009a:	63b040ef          	jal	ra,ffffffffc0204ed4 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009e:	053000ef          	jal	ra,ffffffffc02008f0 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc02000a2:	10d000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a6:	7c7040ef          	jal	ra,ffffffffc020506c <cpu_idle>

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
ffffffffc02000d8:	4f4050ef          	jal	ra,ffffffffc02055cc <vprintfmt>
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
ffffffffc02000e6:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
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
ffffffffc020010e:	4be050ef          	jal	ra,ffffffffc02055cc <vprintfmt>
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
ffffffffc0200188:	80c50513          	addi	a0,a0,-2036 # ffffffffc0205990 <etext+0x2c>
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
ffffffffc020019a:	000c3b97          	auipc	s7,0xc3
ffffffffc020019e:	ab6b8b93          	addi	s7,s7,-1354 # ffffffffc02c2c50 <buf>
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
ffffffffc02001f6:	000c3517          	auipc	a0,0xc3
ffffffffc02001fa:	a5a50513          	addi	a0,a0,-1446 # ffffffffc02c2c50 <buf>
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
ffffffffc0200222:	000c7317          	auipc	t1,0xc7
ffffffffc0200226:	e8630313          	addi	t1,t1,-378 # ffffffffc02c70a8 <is_panic>
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
ffffffffc0200250:	00005517          	auipc	a0,0x5
ffffffffc0200254:	74850513          	addi	a0,a0,1864 # ffffffffc0205998 <etext+0x34>
    va_start(ap, fmt);
ffffffffc0200258:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020025a:	e8bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020025e:	65a2                	ld	a1,8(sp)
ffffffffc0200260:	8522                	mv	a0,s0
ffffffffc0200262:	e63ff0ef          	jal	ra,ffffffffc02000c4 <vcprintf>
    cprintf("\n");
ffffffffc0200266:	00007517          	auipc	a0,0x7
ffffffffc020026a:	d9a50513          	addi	a0,a0,-614 # ffffffffc0207000 <default_pmm_manager+0x488>
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
ffffffffc020029a:	00005517          	auipc	a0,0x5
ffffffffc020029e:	71e50513          	addi	a0,a0,1822 # ffffffffc02059b8 <etext+0x54>
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
ffffffffc02002ba:	00007517          	auipc	a0,0x7
ffffffffc02002be:	d4650513          	addi	a0,a0,-698 # ffffffffc0207000 <default_pmm_manager+0x488>
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
ffffffffc02002d0:	00005517          	auipc	a0,0x5
ffffffffc02002d4:	70850513          	addi	a0,a0,1800 # ffffffffc02059d8 <etext+0x74>
void print_kerninfo(void) {
ffffffffc02002d8:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02002da:	e0bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02002de:	00000597          	auipc	a1,0x0
ffffffffc02002e2:	d6c58593          	addi	a1,a1,-660 # ffffffffc020004a <kern_init>
ffffffffc02002e6:	00005517          	auipc	a0,0x5
ffffffffc02002ea:	71250513          	addi	a0,a0,1810 # ffffffffc02059f8 <etext+0x94>
ffffffffc02002ee:	df7ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02002f2:	00005597          	auipc	a1,0x5
ffffffffc02002f6:	67258593          	addi	a1,a1,1650 # ffffffffc0205964 <etext>
ffffffffc02002fa:	00005517          	auipc	a0,0x5
ffffffffc02002fe:	71e50513          	addi	a0,a0,1822 # ffffffffc0205a18 <etext+0xb4>
ffffffffc0200302:	de3ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200306:	000c3597          	auipc	a1,0xc3
ffffffffc020030a:	94a58593          	addi	a1,a1,-1718 # ffffffffc02c2c50 <buf>
ffffffffc020030e:	00005517          	auipc	a0,0x5
ffffffffc0200312:	72a50513          	addi	a0,a0,1834 # ffffffffc0205a38 <etext+0xd4>
ffffffffc0200316:	dcfff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc020031a:	000c7597          	auipc	a1,0xc7
ffffffffc020031e:	e1658593          	addi	a1,a1,-490 # ffffffffc02c7130 <end>
ffffffffc0200322:	00005517          	auipc	a0,0x5
ffffffffc0200326:	73650513          	addi	a0,a0,1846 # ffffffffc0205a58 <etext+0xf4>
ffffffffc020032a:	dbbff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020032e:	000c7597          	auipc	a1,0xc7
ffffffffc0200332:	20158593          	addi	a1,a1,513 # ffffffffc02c752f <end+0x3ff>
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
ffffffffc0200350:	00005517          	auipc	a0,0x5
ffffffffc0200354:	72850513          	addi	a0,a0,1832 # ffffffffc0205a78 <etext+0x114>
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
ffffffffc020035e:	00005617          	auipc	a2,0x5
ffffffffc0200362:	74a60613          	addi	a2,a2,1866 # ffffffffc0205aa8 <etext+0x144>
ffffffffc0200366:	04d00593          	li	a1,77
ffffffffc020036a:	00005517          	auipc	a0,0x5
ffffffffc020036e:	75650513          	addi	a0,a0,1878 # ffffffffc0205ac0 <etext+0x15c>
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
ffffffffc020037a:	00005617          	auipc	a2,0x5
ffffffffc020037e:	75e60613          	addi	a2,a2,1886 # ffffffffc0205ad8 <etext+0x174>
ffffffffc0200382:	00005597          	auipc	a1,0x5
ffffffffc0200386:	77658593          	addi	a1,a1,1910 # ffffffffc0205af8 <etext+0x194>
ffffffffc020038a:	00005517          	auipc	a0,0x5
ffffffffc020038e:	77650513          	addi	a0,a0,1910 # ffffffffc0205b00 <etext+0x19c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200392:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200394:	d51ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc0200398:	00005617          	auipc	a2,0x5
ffffffffc020039c:	77860613          	addi	a2,a2,1912 # ffffffffc0205b10 <etext+0x1ac>
ffffffffc02003a0:	00005597          	auipc	a1,0x5
ffffffffc02003a4:	79858593          	addi	a1,a1,1944 # ffffffffc0205b38 <etext+0x1d4>
ffffffffc02003a8:	00005517          	auipc	a0,0x5
ffffffffc02003ac:	75850513          	addi	a0,a0,1880 # ffffffffc0205b00 <etext+0x19c>
ffffffffc02003b0:	d35ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc02003b4:	00005617          	auipc	a2,0x5
ffffffffc02003b8:	79460613          	addi	a2,a2,1940 # ffffffffc0205b48 <etext+0x1e4>
ffffffffc02003bc:	00005597          	auipc	a1,0x5
ffffffffc02003c0:	7ac58593          	addi	a1,a1,1964 # ffffffffc0205b68 <etext+0x204>
ffffffffc02003c4:	00005517          	auipc	a0,0x5
ffffffffc02003c8:	73c50513          	addi	a0,a0,1852 # ffffffffc0205b00 <etext+0x19c>
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
ffffffffc02003fe:	00005517          	auipc	a0,0x5
ffffffffc0200402:	77a50513          	addi	a0,a0,1914 # ffffffffc0205b78 <etext+0x214>
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
ffffffffc0200420:	00005517          	auipc	a0,0x5
ffffffffc0200424:	78050513          	addi	a0,a0,1920 # ffffffffc0205ba0 <etext+0x23c>
ffffffffc0200428:	cbdff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    if (tf != NULL) {
ffffffffc020042c:	000b8563          	beqz	s7,ffffffffc0200436 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200430:	855e                	mv	a0,s7
ffffffffc0200432:	770000ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
ffffffffc0200436:	00005c17          	auipc	s8,0x5
ffffffffc020043a:	7dac0c13          	addi	s8,s8,2010 # ffffffffc0205c10 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020043e:	00005917          	auipc	s2,0x5
ffffffffc0200442:	78a90913          	addi	s2,s2,1930 # ffffffffc0205bc8 <etext+0x264>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200446:	00005497          	auipc	s1,0x5
ffffffffc020044a:	78a48493          	addi	s1,s1,1930 # ffffffffc0205bd0 <etext+0x26c>
        if (argc == MAXARGS - 1) {
ffffffffc020044e:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200450:	00005b17          	auipc	s6,0x5
ffffffffc0200454:	788b0b13          	addi	s6,s6,1928 # ffffffffc0205bd8 <etext+0x274>
        argv[argc ++] = buf;
ffffffffc0200458:	00005a17          	auipc	s4,0x5
ffffffffc020045c:	6a0a0a13          	addi	s4,s4,1696 # ffffffffc0205af8 <etext+0x194>
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
ffffffffc020047a:	00005d17          	auipc	s10,0x5
ffffffffc020047e:	796d0d13          	addi	s10,s10,1942 # ffffffffc0205c10 <commands>
        argv[argc ++] = buf;
ffffffffc0200482:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200484:	4401                	li	s0,0
ffffffffc0200486:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200488:	054050ef          	jal	ra,ffffffffc02054dc <strcmp>
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
ffffffffc020049c:	040050ef          	jal	ra,ffffffffc02054dc <strcmp>
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
ffffffffc02004da:	046050ef          	jal	ra,ffffffffc0205520 <strchr>
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
ffffffffc0200518:	008050ef          	jal	ra,ffffffffc0205520 <strchr>
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
ffffffffc0200532:	00005517          	auipc	a0,0x5
ffffffffc0200536:	6c650513          	addi	a0,a0,1734 # ffffffffc0205bf8 <etext+0x294>
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
ffffffffc0200542:	00005517          	auipc	a0,0x5
ffffffffc0200546:	71650513          	addi	a0,a0,1814 # ffffffffc0205c58 <commands+0x48>
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
ffffffffc0200568:	0000c597          	auipc	a1,0xc
ffffffffc020056c:	a985b583          	ld	a1,-1384(a1) # ffffffffc020c000 <boot_hartid>
ffffffffc0200570:	00005517          	auipc	a0,0x5
ffffffffc0200574:	6f850513          	addi	a0,a0,1784 # ffffffffc0205c68 <commands+0x58>
ffffffffc0200578:	b6dff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020057c:	0000c417          	auipc	s0,0xc
ffffffffc0200580:	a8c40413          	addi	s0,s0,-1396 # ffffffffc020c008 <boot_dtb>
ffffffffc0200584:	600c                	ld	a1,0(s0)
ffffffffc0200586:	00005517          	auipc	a0,0x5
ffffffffc020058a:	6f250513          	addi	a0,a0,1778 # ffffffffc0205c78 <commands+0x68>
ffffffffc020058e:	b57ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200592:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200596:	00005517          	auipc	a0,0x5
ffffffffc020059a:	6fa50513          	addi	a0,a0,1786 # ffffffffc0205c90 <commands+0x80>
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
ffffffffc02005de:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe18dbd>
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
ffffffffc0200650:	00005917          	auipc	s2,0x5
ffffffffc0200654:	69090913          	addi	s2,s2,1680 # ffffffffc0205ce0 <commands+0xd0>
ffffffffc0200658:	49bd                	li	s3,15
        switch (token) {
ffffffffc020065a:	4d91                	li	s11,4
ffffffffc020065c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020065e:	00005497          	auipc	s1,0x5
ffffffffc0200662:	67a48493          	addi	s1,s1,1658 # ffffffffc0205cd8 <commands+0xc8>
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
ffffffffc02006b2:	00005517          	auipc	a0,0x5
ffffffffc02006b6:	6a650513          	addi	a0,a0,1702 # ffffffffc0205d58 <commands+0x148>
ffffffffc02006ba:	a2bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006be:	00005517          	auipc	a0,0x5
ffffffffc02006c2:	6d250513          	addi	a0,a0,1746 # ffffffffc0205d90 <commands+0x180>
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
ffffffffc02006fe:	00005517          	auipc	a0,0x5
ffffffffc0200702:	5b250513          	addi	a0,a0,1458 # ffffffffc0205cb0 <commands+0xa0>
}
ffffffffc0200706:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200708:	baf1                	j	ffffffffc02000e4 <cprintf>
                int name_len = strlen(name);
ffffffffc020070a:	8556                	mv	a0,s5
ffffffffc020070c:	589040ef          	jal	ra,ffffffffc0205494 <strlen>
ffffffffc0200710:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200712:	4619                	li	a2,6
ffffffffc0200714:	85a6                	mv	a1,s1
ffffffffc0200716:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200718:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071a:	5e1040ef          	jal	ra,ffffffffc02054fa <strncmp>
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
ffffffffc02007b0:	52d040ef          	jal	ra,ffffffffc02054dc <strcmp>
ffffffffc02007b4:	66a2                	ld	a3,8(sp)
ffffffffc02007b6:	f94d                	bnez	a0,ffffffffc0200768 <dtb_init+0x228>
ffffffffc02007b8:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200768 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007bc:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007c0:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007c4:	00005517          	auipc	a0,0x5
ffffffffc02007c8:	52450513          	addi	a0,a0,1316 # ffffffffc0205ce8 <commands+0xd8>
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
ffffffffc0200892:	00005517          	auipc	a0,0x5
ffffffffc0200896:	47650513          	addi	a0,a0,1142 # ffffffffc0205d08 <commands+0xf8>
ffffffffc020089a:	84bff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020089e:	014b5613          	srli	a2,s6,0x14
ffffffffc02008a2:	85da                	mv	a1,s6
ffffffffc02008a4:	00005517          	auipc	a0,0x5
ffffffffc02008a8:	47c50513          	addi	a0,a0,1148 # ffffffffc0205d20 <commands+0x110>
ffffffffc02008ac:	839ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008b0:	008b05b3          	add	a1,s6,s0
ffffffffc02008b4:	15fd                	addi	a1,a1,-1
ffffffffc02008b6:	00005517          	auipc	a0,0x5
ffffffffc02008ba:	48a50513          	addi	a0,a0,1162 # ffffffffc0205d40 <commands+0x130>
ffffffffc02008be:	827ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02008c2:	00005517          	auipc	a0,0x5
ffffffffc02008c6:	4ce50513          	addi	a0,a0,1230 # ffffffffc0205d90 <commands+0x180>
        memory_base = mem_base;
ffffffffc02008ca:	000c6797          	auipc	a5,0xc6
ffffffffc02008ce:	7e87b323          	sd	s0,2022(a5) # ffffffffc02c70b0 <memory_base>
        memory_size = mem_size;
ffffffffc02008d2:	000c6797          	auipc	a5,0xc6
ffffffffc02008d6:	7f67b323          	sd	s6,2022(a5) # ffffffffc02c70b8 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02008da:	b3f5                	j	ffffffffc02006c6 <dtb_init+0x186>

ffffffffc02008dc <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008dc:	000c6517          	auipc	a0,0xc6
ffffffffc02008e0:	7d453503          	ld	a0,2004(a0) # ffffffffc02c70b0 <memory_base>
ffffffffc02008e4:	8082                	ret

ffffffffc02008e6 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008e6:	000c6517          	auipc	a0,0xc6
ffffffffc02008ea:	7d253503          	ld	a0,2002(a0) # ffffffffc02c70b8 <memory_size>
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
ffffffffc02008fe:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf40>
ffffffffc0200902:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200904:	4581                	li	a1,0
ffffffffc0200906:	4601                	li	a2,0
ffffffffc0200908:	4881                	li	a7,0
ffffffffc020090a:	00000073          	ecall
    cprintf("++ setup timer interrupts\n");
ffffffffc020090e:	00005517          	auipc	a0,0x5
ffffffffc0200912:	49a50513          	addi	a0,a0,1178 # ffffffffc0205da8 <commands+0x198>
    ticks = 0;
ffffffffc0200916:	000c6797          	auipc	a5,0xc6
ffffffffc020091a:	7a07b523          	sd	zero,1962(a5) # ffffffffc02c70c0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020091e:	fc6ff06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0200922 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200922:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200926:	67e1                	lui	a5,0x18
ffffffffc0200928:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_matrix_out_size+0xbf40>
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
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020093c:	100027f3          	csrr	a5,sstatus
ffffffffc0200940:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200942:	0ff57513          	zext.b	a0,a0
ffffffffc0200946:	e799                	bnez	a5,ffffffffc0200954 <cons_putc+0x18>
ffffffffc0200948:	4581                	li	a1,0
ffffffffc020094a:	4601                	li	a2,0
ffffffffc020094c:	4885                	li	a7,1
ffffffffc020094e:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
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
    {
        intr_enable();
ffffffffc020096e:	a081                	j	ffffffffc02009ae <intr_enable>

ffffffffc0200970 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
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
ffffffffc02009c2:	57278793          	addi	a5,a5,1394 # ffffffffc0200f30 <__alltraps>
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
ffffffffc02009dc:	00005517          	auipc	a0,0x5
ffffffffc02009e0:	3ec50513          	addi	a0,a0,1004 # ffffffffc0205dc8 <commands+0x1b8>
{
ffffffffc02009e4:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e6:	efeff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ea:	640c                	ld	a1,8(s0)
ffffffffc02009ec:	00005517          	auipc	a0,0x5
ffffffffc02009f0:	3f450513          	addi	a0,a0,1012 # ffffffffc0205de0 <commands+0x1d0>
ffffffffc02009f4:	ef0ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009f8:	680c                	ld	a1,16(s0)
ffffffffc02009fa:	00005517          	auipc	a0,0x5
ffffffffc02009fe:	3fe50513          	addi	a0,a0,1022 # ffffffffc0205df8 <commands+0x1e8>
ffffffffc0200a02:	ee2ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a06:	6c0c                	ld	a1,24(s0)
ffffffffc0200a08:	00005517          	auipc	a0,0x5
ffffffffc0200a0c:	40850513          	addi	a0,a0,1032 # ffffffffc0205e10 <commands+0x200>
ffffffffc0200a10:	ed4ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a14:	700c                	ld	a1,32(s0)
ffffffffc0200a16:	00005517          	auipc	a0,0x5
ffffffffc0200a1a:	41250513          	addi	a0,a0,1042 # ffffffffc0205e28 <commands+0x218>
ffffffffc0200a1e:	ec6ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a22:	740c                	ld	a1,40(s0)
ffffffffc0200a24:	00005517          	auipc	a0,0x5
ffffffffc0200a28:	41c50513          	addi	a0,a0,1052 # ffffffffc0205e40 <commands+0x230>
ffffffffc0200a2c:	eb8ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a30:	780c                	ld	a1,48(s0)
ffffffffc0200a32:	00005517          	auipc	a0,0x5
ffffffffc0200a36:	42650513          	addi	a0,a0,1062 # ffffffffc0205e58 <commands+0x248>
ffffffffc0200a3a:	eaaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a3e:	7c0c                	ld	a1,56(s0)
ffffffffc0200a40:	00005517          	auipc	a0,0x5
ffffffffc0200a44:	43050513          	addi	a0,a0,1072 # ffffffffc0205e70 <commands+0x260>
ffffffffc0200a48:	e9cff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4c:	602c                	ld	a1,64(s0)
ffffffffc0200a4e:	00005517          	auipc	a0,0x5
ffffffffc0200a52:	43a50513          	addi	a0,a0,1082 # ffffffffc0205e88 <commands+0x278>
ffffffffc0200a56:	e8eff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5a:	642c                	ld	a1,72(s0)
ffffffffc0200a5c:	00005517          	auipc	a0,0x5
ffffffffc0200a60:	44450513          	addi	a0,a0,1092 # ffffffffc0205ea0 <commands+0x290>
ffffffffc0200a64:	e80ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a68:	682c                	ld	a1,80(s0)
ffffffffc0200a6a:	00005517          	auipc	a0,0x5
ffffffffc0200a6e:	44e50513          	addi	a0,a0,1102 # ffffffffc0205eb8 <commands+0x2a8>
ffffffffc0200a72:	e72ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a76:	6c2c                	ld	a1,88(s0)
ffffffffc0200a78:	00005517          	auipc	a0,0x5
ffffffffc0200a7c:	45850513          	addi	a0,a0,1112 # ffffffffc0205ed0 <commands+0x2c0>
ffffffffc0200a80:	e64ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a84:	702c                	ld	a1,96(s0)
ffffffffc0200a86:	00005517          	auipc	a0,0x5
ffffffffc0200a8a:	46250513          	addi	a0,a0,1122 # ffffffffc0205ee8 <commands+0x2d8>
ffffffffc0200a8e:	e56ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a92:	742c                	ld	a1,104(s0)
ffffffffc0200a94:	00005517          	auipc	a0,0x5
ffffffffc0200a98:	46c50513          	addi	a0,a0,1132 # ffffffffc0205f00 <commands+0x2f0>
ffffffffc0200a9c:	e48ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa0:	782c                	ld	a1,112(s0)
ffffffffc0200aa2:	00005517          	auipc	a0,0x5
ffffffffc0200aa6:	47650513          	addi	a0,a0,1142 # ffffffffc0205f18 <commands+0x308>
ffffffffc0200aaa:	e3aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200aae:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab0:	00005517          	auipc	a0,0x5
ffffffffc0200ab4:	48050513          	addi	a0,a0,1152 # ffffffffc0205f30 <commands+0x320>
ffffffffc0200ab8:	e2cff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abc:	604c                	ld	a1,128(s0)
ffffffffc0200abe:	00005517          	auipc	a0,0x5
ffffffffc0200ac2:	48a50513          	addi	a0,a0,1162 # ffffffffc0205f48 <commands+0x338>
ffffffffc0200ac6:	e1eff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200aca:	644c                	ld	a1,136(s0)
ffffffffc0200acc:	00005517          	auipc	a0,0x5
ffffffffc0200ad0:	49450513          	addi	a0,a0,1172 # ffffffffc0205f60 <commands+0x350>
ffffffffc0200ad4:	e10ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ad8:	684c                	ld	a1,144(s0)
ffffffffc0200ada:	00005517          	auipc	a0,0x5
ffffffffc0200ade:	49e50513          	addi	a0,a0,1182 # ffffffffc0205f78 <commands+0x368>
ffffffffc0200ae2:	e02ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae6:	6c4c                	ld	a1,152(s0)
ffffffffc0200ae8:	00005517          	auipc	a0,0x5
ffffffffc0200aec:	4a850513          	addi	a0,a0,1192 # ffffffffc0205f90 <commands+0x380>
ffffffffc0200af0:	df4ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af4:	704c                	ld	a1,160(s0)
ffffffffc0200af6:	00005517          	auipc	a0,0x5
ffffffffc0200afa:	4b250513          	addi	a0,a0,1202 # ffffffffc0205fa8 <commands+0x398>
ffffffffc0200afe:	de6ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b02:	744c                	ld	a1,168(s0)
ffffffffc0200b04:	00005517          	auipc	a0,0x5
ffffffffc0200b08:	4bc50513          	addi	a0,a0,1212 # ffffffffc0205fc0 <commands+0x3b0>
ffffffffc0200b0c:	dd8ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b10:	784c                	ld	a1,176(s0)
ffffffffc0200b12:	00005517          	auipc	a0,0x5
ffffffffc0200b16:	4c650513          	addi	a0,a0,1222 # ffffffffc0205fd8 <commands+0x3c8>
ffffffffc0200b1a:	dcaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b1e:	7c4c                	ld	a1,184(s0)
ffffffffc0200b20:	00005517          	auipc	a0,0x5
ffffffffc0200b24:	4d050513          	addi	a0,a0,1232 # ffffffffc0205ff0 <commands+0x3e0>
ffffffffc0200b28:	dbcff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2c:	606c                	ld	a1,192(s0)
ffffffffc0200b2e:	00005517          	auipc	a0,0x5
ffffffffc0200b32:	4da50513          	addi	a0,a0,1242 # ffffffffc0206008 <commands+0x3f8>
ffffffffc0200b36:	daeff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3a:	646c                	ld	a1,200(s0)
ffffffffc0200b3c:	00005517          	auipc	a0,0x5
ffffffffc0200b40:	4e450513          	addi	a0,a0,1252 # ffffffffc0206020 <commands+0x410>
ffffffffc0200b44:	da0ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b48:	686c                	ld	a1,208(s0)
ffffffffc0200b4a:	00005517          	auipc	a0,0x5
ffffffffc0200b4e:	4ee50513          	addi	a0,a0,1262 # ffffffffc0206038 <commands+0x428>
ffffffffc0200b52:	d92ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b56:	6c6c                	ld	a1,216(s0)
ffffffffc0200b58:	00005517          	auipc	a0,0x5
ffffffffc0200b5c:	4f850513          	addi	a0,a0,1272 # ffffffffc0206050 <commands+0x440>
ffffffffc0200b60:	d84ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b64:	706c                	ld	a1,224(s0)
ffffffffc0200b66:	00005517          	auipc	a0,0x5
ffffffffc0200b6a:	50250513          	addi	a0,a0,1282 # ffffffffc0206068 <commands+0x458>
ffffffffc0200b6e:	d76ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b72:	746c                	ld	a1,232(s0)
ffffffffc0200b74:	00005517          	auipc	a0,0x5
ffffffffc0200b78:	50c50513          	addi	a0,a0,1292 # ffffffffc0206080 <commands+0x470>
ffffffffc0200b7c:	d68ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b80:	786c                	ld	a1,240(s0)
ffffffffc0200b82:	00005517          	auipc	a0,0x5
ffffffffc0200b86:	51650513          	addi	a0,a0,1302 # ffffffffc0206098 <commands+0x488>
ffffffffc0200b8a:	d5aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b8e:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b90:	6402                	ld	s0,0(sp)
ffffffffc0200b92:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b94:	00005517          	auipc	a0,0x5
ffffffffc0200b98:	51c50513          	addi	a0,a0,1308 # ffffffffc02060b0 <commands+0x4a0>
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
ffffffffc0200baa:	00005517          	auipc	a0,0x5
ffffffffc0200bae:	51e50513          	addi	a0,a0,1310 # ffffffffc02060c8 <commands+0x4b8>
{
ffffffffc0200bb2:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb4:	d30ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bb8:	8522                	mv	a0,s0
ffffffffc0200bba:	e1bff0ef          	jal	ra,ffffffffc02009d4 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bbe:	10043583          	ld	a1,256(s0)
ffffffffc0200bc2:	00005517          	auipc	a0,0x5
ffffffffc0200bc6:	51e50513          	addi	a0,a0,1310 # ffffffffc02060e0 <commands+0x4d0>
ffffffffc0200bca:	d1aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bce:	10843583          	ld	a1,264(s0)
ffffffffc0200bd2:	00005517          	auipc	a0,0x5
ffffffffc0200bd6:	52650513          	addi	a0,a0,1318 # ffffffffc02060f8 <commands+0x4e8>
ffffffffc0200bda:	d0aff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200bde:	11043583          	ld	a1,272(s0)
ffffffffc0200be2:	00005517          	auipc	a0,0x5
ffffffffc0200be6:	52e50513          	addi	a0,a0,1326 # ffffffffc0206110 <commands+0x500>
ffffffffc0200bea:	cfaff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bee:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf2:	6402                	ld	s0,0(sp)
ffffffffc0200bf4:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf6:	00005517          	auipc	a0,0x5
ffffffffc0200bfa:	52a50513          	addi	a0,a0,1322 # ffffffffc0206120 <commands+0x510>
}
ffffffffc0200bfe:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c00:	ce4ff06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc0200c04 <pgfault_handler>:
pgfault_handler(struct trapframe *tf) {
ffffffffc0200c04:	1141                	addi	sp,sp,-16
ffffffffc0200c06:	e406                	sd	ra,8(sp)
    if (current == NULL) {
ffffffffc0200c08:	000c6797          	auipc	a5,0xc6
ffffffffc0200c0c:	4f87b783          	ld	a5,1272(a5) # ffffffffc02c7100 <current>
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
ffffffffc0200c22:	00005617          	auipc	a2,0x5
ffffffffc0200c26:	51660613          	addi	a2,a2,1302 # ffffffffc0206138 <commands+0x528>
ffffffffc0200c2a:	02500593          	li	a1,37
ffffffffc0200c2e:	00005517          	auipc	a0,0x5
ffffffffc0200c32:	52250513          	addi	a0,a0,1314 # ffffffffc0206150 <commands+0x540>
ffffffffc0200c36:	decff0ef          	jal	ra,ffffffffc0200222 <__panic>
        print_trapframe(tf);
ffffffffc0200c3a:	f69ff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
        panic("page fault in kernel thread!");
ffffffffc0200c3e:	00005617          	auipc	a2,0x5
ffffffffc0200c42:	52a60613          	addi	a2,a2,1322 # ffffffffc0206168 <commands+0x558>
ffffffffc0200c46:	02a00593          	li	a1,42
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	50650513          	addi	a0,a0,1286 # ffffffffc0206150 <commands+0x540>
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
ffffffffc0200c60:	08f76263          	bltu	a4,a5,ffffffffc0200ce4 <interrupt_handler+0x8e>
ffffffffc0200c64:	00005717          	auipc	a4,0x5
ffffffffc0200c68:	5e470713          	addi	a4,a4,1508 # ffffffffc0206248 <commands+0x638>
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
ffffffffc0200c76:	00005517          	auipc	a0,0x5
ffffffffc0200c7a:	57250513          	addi	a0,a0,1394 # ffffffffc02061e8 <commands+0x5d8>
ffffffffc0200c7e:	c66ff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c82:	00005517          	auipc	a0,0x5
ffffffffc0200c86:	54650513          	addi	a0,a0,1350 # ffffffffc02061c8 <commands+0x5b8>
ffffffffc0200c8a:	c5aff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c8e:	00005517          	auipc	a0,0x5
ffffffffc0200c92:	4fa50513          	addi	a0,a0,1274 # ffffffffc0206188 <commands+0x578>
ffffffffc0200c96:	c4eff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c9a:	00005517          	auipc	a0,0x5
ffffffffc0200c9e:	50e50513          	addi	a0,a0,1294 # ffffffffc02061a8 <commands+0x598>
ffffffffc0200ca2:	c42ff06f          	j	ffffffffc02000e4 <cprintf>
{
ffffffffc0200ca6:	1141                	addi	sp,sp,-16
ffffffffc0200ca8:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200caa:	c79ff0ef          	jal	ra,ffffffffc0200922 <clock_set_next_event>
        ticks++;
ffffffffc0200cae:	000c6797          	auipc	a5,0xc6
ffffffffc0200cb2:	41278793          	addi	a5,a5,1042 # ffffffffc02c70c0 <ticks>
ffffffffc0200cb6:	6398                	ld	a4,0(a5)
ffffffffc0200cb8:	0705                	addi	a4,a4,1
ffffffffc0200cba:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200cbc:	639c                	ld	a5,0(a5)
ffffffffc0200cbe:	06400713          	li	a4,100
ffffffffc0200cc2:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200cc6:	c385                	beqz	a5,ffffffffc0200ce6 <interrupt_handler+0x90>
            }
        }

        // lab6: 2313815_段俊宇_2313485_陈展_2310591_李相儒  (update LAB3 steps)
        //  在时钟中断时调用调度器的 sched_class_proc_tick 函数
        if (current != NULL) {
ffffffffc0200cc8:	000c6517          	auipc	a0,0xc6
ffffffffc0200ccc:	43853503          	ld	a0,1080(a0) # ffffffffc02c7100 <current>
ffffffffc0200cd0:	e121                	bnez	a0,ffffffffc0200d10 <interrupt_handler+0xba>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cd2:	60a2                	ld	ra,8(sp)
ffffffffc0200cd4:	0141                	addi	sp,sp,16
ffffffffc0200cd6:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200cd8:	00005517          	auipc	a0,0x5
ffffffffc0200cdc:	55050513          	addi	a0,a0,1360 # ffffffffc0206228 <commands+0x618>
ffffffffc0200ce0:	c04ff06f          	j	ffffffffc02000e4 <cprintf>
        print_trapframe(tf);
ffffffffc0200ce4:	bd7d                	j	ffffffffc0200ba2 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200ce6:	06400593          	li	a1,100
ffffffffc0200cea:	00005517          	auipc	a0,0x5
ffffffffc0200cee:	51e50513          	addi	a0,a0,1310 # ffffffffc0206208 <commands+0x5f8>
ffffffffc0200cf2:	bf2ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    cprintf("End of Test.\n");
ffffffffc0200cf6:	00005517          	auipc	a0,0x5
ffffffffc0200cfa:	52250513          	addi	a0,a0,1314 # ffffffffc0206218 <commands+0x608>
ffffffffc0200cfe:	be6ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            if(current != NULL)
ffffffffc0200d02:	000c6517          	auipc	a0,0xc6
ffffffffc0200d06:	3fe53503          	ld	a0,1022(a0) # ffffffffc02c7100 <current>
ffffffffc0200d0a:	d561                	beqz	a0,ffffffffc0200cd2 <interrupt_handler+0x7c>
                current->need_resched = 1;
ffffffffc0200d0c:	4785                	li	a5,1
ffffffffc0200d0e:	ed1c                	sd	a5,24(a0)
}
ffffffffc0200d10:	60a2                	ld	ra,8(sp)
ffffffffc0200d12:	0141                	addi	sp,sp,16
            sched_class_proc_tick(current);
ffffffffc0200d14:	3ac0406f          	j	ffffffffc02050c0 <sched_class_proc_tick>

ffffffffc0200d18 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200d18:	11853783          	ld	a5,280(a0)
{
ffffffffc0200d1c:	1141                	addi	sp,sp,-16
ffffffffc0200d1e:	e022                	sd	s0,0(sp)
ffffffffc0200d20:	e406                	sd	ra,8(sp)
ffffffffc0200d22:	473d                	li	a4,15
ffffffffc0200d24:	842a                	mv	s0,a0
ffffffffc0200d26:	10f76863          	bltu	a4,a5,ffffffffc0200e36 <exception_handler+0x11e>
ffffffffc0200d2a:	00005717          	auipc	a4,0x5
ffffffffc0200d2e:	6de70713          	addi	a4,a4,1758 # ffffffffc0206408 <commands+0x7f8>
ffffffffc0200d32:	078a                	slli	a5,a5,0x2
ffffffffc0200d34:	97ba                	add	a5,a5,a4
ffffffffc0200d36:	439c                	lw	a5,0(a5)
ffffffffc0200d38:	97ba                	add	a5,a5,a4
ffffffffc0200d3a:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200d3c:	00005517          	auipc	a0,0x5
ffffffffc0200d40:	60c50513          	addi	a0,a0,1548 # ffffffffc0206348 <commands+0x738>
ffffffffc0200d44:	ba0ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        tf->epc += 4;
ffffffffc0200d48:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d4c:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200d4e:	0791                	addi	a5,a5,4
ffffffffc0200d50:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d54:	6402                	ld	s0,0(sp)
ffffffffc0200d56:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d58:	6ba0406f          	j	ffffffffc0205412 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d5c:	00005517          	auipc	a0,0x5
ffffffffc0200d60:	60c50513          	addi	a0,a0,1548 # ffffffffc0206368 <commands+0x758>
}
ffffffffc0200d64:	6402                	ld	s0,0(sp)
ffffffffc0200d66:	60a2                	ld	ra,8(sp)
ffffffffc0200d68:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d6a:	b7aff06f          	j	ffffffffc02000e4 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d6e:	00005517          	auipc	a0,0x5
ffffffffc0200d72:	61a50513          	addi	a0,a0,1562 # ffffffffc0206388 <commands+0x778>
ffffffffc0200d76:	b7fd                	j	ffffffffc0200d64 <exception_handler+0x4c>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d78:	e8dff0ef          	jal	ra,ffffffffc0200c04 <pgfault_handler>
ffffffffc0200d7c:	0c051e63          	bnez	a0,ffffffffc0200e58 <exception_handler+0x140>
}
ffffffffc0200d80:	60a2                	ld	ra,8(sp)
ffffffffc0200d82:	6402                	ld	s0,0(sp)
ffffffffc0200d84:	0141                	addi	sp,sp,16
ffffffffc0200d86:	8082                	ret
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d88:	e7dff0ef          	jal	ra,ffffffffc0200c04 <pgfault_handler>
ffffffffc0200d8c:	d975                	beqz	a0,ffffffffc0200d80 <exception_handler+0x68>
            cprintf("Load page fault\n");
ffffffffc0200d8e:	00005517          	auipc	a0,0x5
ffffffffc0200d92:	64a50513          	addi	a0,a0,1610 # ffffffffc02063d8 <commands+0x7c8>
ffffffffc0200d96:	b4eff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            print_trapframe(tf);
ffffffffc0200d9a:	8522                	mv	a0,s0
ffffffffc0200d9c:	e07ff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
            if (current != NULL) {
ffffffffc0200da0:	000c6797          	auipc	a5,0xc6
ffffffffc0200da4:	3607b783          	ld	a5,864(a5) # ffffffffc02c7100 <current>
ffffffffc0200da8:	ef95                	bnez	a5,ffffffffc0200de4 <exception_handler+0xcc>
                panic("kernel page fault");
ffffffffc0200daa:	00005617          	auipc	a2,0x5
ffffffffc0200dae:	61660613          	addi	a2,a2,1558 # ffffffffc02063c0 <commands+0x7b0>
ffffffffc0200db2:	0fc00593          	li	a1,252
ffffffffc0200db6:	00005517          	auipc	a0,0x5
ffffffffc0200dba:	39a50513          	addi	a0,a0,922 # ffffffffc0206150 <commands+0x540>
ffffffffc0200dbe:	c64ff0ef          	jal	ra,ffffffffc0200222 <__panic>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200dc2:	e43ff0ef          	jal	ra,ffffffffc0200c04 <pgfault_handler>
ffffffffc0200dc6:	dd4d                	beqz	a0,ffffffffc0200d80 <exception_handler+0x68>
            cprintf("Store/AMO page fault\n");
ffffffffc0200dc8:	00005517          	auipc	a0,0x5
ffffffffc0200dcc:	62850513          	addi	a0,a0,1576 # ffffffffc02063f0 <commands+0x7e0>
ffffffffc0200dd0:	b14ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            print_trapframe(tf);
ffffffffc0200dd4:	8522                	mv	a0,s0
ffffffffc0200dd6:	dcdff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
            if (current != NULL) {
ffffffffc0200dda:	000c6797          	auipc	a5,0xc6
ffffffffc0200dde:	3267b783          	ld	a5,806(a5) # ffffffffc02c7100 <current>
ffffffffc0200de2:	c7cd                	beqz	a5,ffffffffc0200e8c <exception_handler+0x174>
}
ffffffffc0200de4:	6402                	ld	s0,0(sp)
ffffffffc0200de6:	60a2                	ld	ra,8(sp)
                do_exit(-E_KILLED);
ffffffffc0200de8:	555d                	li	a0,-9
}
ffffffffc0200dea:	0141                	addi	sp,sp,16
                do_exit(-E_KILLED);
ffffffffc0200dec:	6300306f          	j	ffffffffc020441c <do_exit>
        cprintf("Instruction address misaligned\n");
ffffffffc0200df0:	00005517          	auipc	a0,0x5
ffffffffc0200df4:	48850513          	addi	a0,a0,1160 # ffffffffc0206278 <commands+0x668>
ffffffffc0200df8:	b7b5                	j	ffffffffc0200d64 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200dfa:	00005517          	auipc	a0,0x5
ffffffffc0200dfe:	49e50513          	addi	a0,a0,1182 # ffffffffc0206298 <commands+0x688>
ffffffffc0200e02:	b78d                	j	ffffffffc0200d64 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200e04:	00005517          	auipc	a0,0x5
ffffffffc0200e08:	4b450513          	addi	a0,a0,1204 # ffffffffc02062b8 <commands+0x6a8>
ffffffffc0200e0c:	bfa1                	j	ffffffffc0200d64 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200e0e:	00005517          	auipc	a0,0x5
ffffffffc0200e12:	4c250513          	addi	a0,a0,1218 # ffffffffc02062d0 <commands+0x6c0>
ffffffffc0200e16:	b7b9                	j	ffffffffc0200d64 <exception_handler+0x4c>
        cprintf("Load address misaligned\n");
ffffffffc0200e18:	00005517          	auipc	a0,0x5
ffffffffc0200e1c:	4c850513          	addi	a0,a0,1224 # ffffffffc02062e0 <commands+0x6d0>
ffffffffc0200e20:	b791                	j	ffffffffc0200d64 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200e22:	00005517          	auipc	a0,0x5
ffffffffc0200e26:	4de50513          	addi	a0,a0,1246 # ffffffffc0206300 <commands+0x6f0>
ffffffffc0200e2a:	bf2d                	j	ffffffffc0200d64 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200e2c:	00005517          	auipc	a0,0x5
ffffffffc0200e30:	50450513          	addi	a0,a0,1284 # ffffffffc0206330 <commands+0x720>
ffffffffc0200e34:	bf05                	j	ffffffffc0200d64 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200e36:	8522                	mv	a0,s0
}
ffffffffc0200e38:	6402                	ld	s0,0(sp)
ffffffffc0200e3a:	60a2                	ld	ra,8(sp)
ffffffffc0200e3c:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200e3e:	b395                	j	ffffffffc0200ba2 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200e40:	00005617          	auipc	a2,0x5
ffffffffc0200e44:	4d860613          	addi	a2,a2,1240 # ffffffffc0206318 <commands+0x708>
ffffffffc0200e48:	0d500593          	li	a1,213
ffffffffc0200e4c:	00005517          	auipc	a0,0x5
ffffffffc0200e50:	30450513          	addi	a0,a0,772 # ffffffffc0206150 <commands+0x540>
ffffffffc0200e54:	bceff0ef          	jal	ra,ffffffffc0200222 <__panic>
            cprintf("Fetch page fault\n");
ffffffffc0200e58:	00005517          	auipc	a0,0x5
ffffffffc0200e5c:	55050513          	addi	a0,a0,1360 # ffffffffc02063a8 <commands+0x798>
ffffffffc0200e60:	a84ff0ef          	jal	ra,ffffffffc02000e4 <cprintf>
            print_trapframe(tf);
ffffffffc0200e64:	8522                	mv	a0,s0
ffffffffc0200e66:	d3dff0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
            if (current != NULL) {
ffffffffc0200e6a:	000c6797          	auipc	a5,0xc6
ffffffffc0200e6e:	2967b783          	ld	a5,662(a5) # ffffffffc02c7100 <current>
ffffffffc0200e72:	fbad                	bnez	a5,ffffffffc0200de4 <exception_handler+0xcc>
                panic("kernel page fault");
ffffffffc0200e74:	00005617          	auipc	a2,0x5
ffffffffc0200e78:	54c60613          	addi	a2,a2,1356 # ffffffffc02063c0 <commands+0x7b0>
ffffffffc0200e7c:	0f100593          	li	a1,241
ffffffffc0200e80:	00005517          	auipc	a0,0x5
ffffffffc0200e84:	2d050513          	addi	a0,a0,720 # ffffffffc0206150 <commands+0x540>
ffffffffc0200e88:	b9aff0ef          	jal	ra,ffffffffc0200222 <__panic>
                panic("kernel page fault");
ffffffffc0200e8c:	00005617          	auipc	a2,0x5
ffffffffc0200e90:	53460613          	addi	a2,a2,1332 # ffffffffc02063c0 <commands+0x7b0>
ffffffffc0200e94:	10700593          	li	a1,263
ffffffffc0200e98:	00005517          	auipc	a0,0x5
ffffffffc0200e9c:	2b850513          	addi	a0,a0,696 # ffffffffc0206150 <commands+0x540>
ffffffffc0200ea0:	b82ff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0200ea4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200ea4:	1101                	addi	sp,sp,-32
ffffffffc0200ea6:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200ea8:	000c6417          	auipc	s0,0xc6
ffffffffc0200eac:	25840413          	addi	s0,s0,600 # ffffffffc02c7100 <current>
ffffffffc0200eb0:	6018                	ld	a4,0(s0)
{
ffffffffc0200eb2:	ec06                	sd	ra,24(sp)
ffffffffc0200eb4:	e426                	sd	s1,8(sp)
ffffffffc0200eb6:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200eb8:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200ebc:	cf1d                	beqz	a4,ffffffffc0200efa <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200ebe:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200ec2:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200ec6:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200ec8:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ecc:	0206c463          	bltz	a3,ffffffffc0200ef4 <trap+0x50>
        exception_handler(tf);
ffffffffc0200ed0:	e49ff0ef          	jal	ra,ffffffffc0200d18 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200ed4:	601c                	ld	a5,0(s0)
ffffffffc0200ed6:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200eda:	e499                	bnez	s1,ffffffffc0200ee8 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200edc:	0b07a703          	lw	a4,176(a5)
ffffffffc0200ee0:	8b05                	andi	a4,a4,1
ffffffffc0200ee2:	e329                	bnez	a4,ffffffffc0200f24 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200ee4:	6f9c                	ld	a5,24(a5)
ffffffffc0200ee6:	eb85                	bnez	a5,ffffffffc0200f16 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200ee8:	60e2                	ld	ra,24(sp)
ffffffffc0200eea:	6442                	ld	s0,16(sp)
ffffffffc0200eec:	64a2                	ld	s1,8(sp)
ffffffffc0200eee:	6902                	ld	s2,0(sp)
ffffffffc0200ef0:	6105                	addi	sp,sp,32
ffffffffc0200ef2:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200ef4:	d63ff0ef          	jal	ra,ffffffffc0200c56 <interrupt_handler>
ffffffffc0200ef8:	bff1                	j	ffffffffc0200ed4 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200efa:	0006c863          	bltz	a3,ffffffffc0200f0a <trap+0x66>
}
ffffffffc0200efe:	6442                	ld	s0,16(sp)
ffffffffc0200f00:	60e2                	ld	ra,24(sp)
ffffffffc0200f02:	64a2                	ld	s1,8(sp)
ffffffffc0200f04:	6902                	ld	s2,0(sp)
ffffffffc0200f06:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200f08:	bd01                	j	ffffffffc0200d18 <exception_handler>
}
ffffffffc0200f0a:	6442                	ld	s0,16(sp)
ffffffffc0200f0c:	60e2                	ld	ra,24(sp)
ffffffffc0200f0e:	64a2                	ld	s1,8(sp)
ffffffffc0200f10:	6902                	ld	s2,0(sp)
ffffffffc0200f12:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200f14:	b389                	j	ffffffffc0200c56 <interrupt_handler>
}
ffffffffc0200f16:	6442                	ld	s0,16(sp)
ffffffffc0200f18:	60e2                	ld	ra,24(sp)
ffffffffc0200f1a:	64a2                	ld	s1,8(sp)
ffffffffc0200f1c:	6902                	ld	s2,0(sp)
ffffffffc0200f1e:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200f20:	2cc0406f          	j	ffffffffc02051ec <schedule>
                do_exit(-E_KILLED);
ffffffffc0200f24:	555d                	li	a0,-9
ffffffffc0200f26:	4f6030ef          	jal	ra,ffffffffc020441c <do_exit>
            if (current->need_resched)
ffffffffc0200f2a:	601c                	ld	a5,0(s0)
ffffffffc0200f2c:	bf65                	j	ffffffffc0200ee4 <trap+0x40>
	...

ffffffffc0200f30 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200f30:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200f34:	00011463          	bnez	sp,ffffffffc0200f3c <__alltraps+0xc>
ffffffffc0200f38:	14002173          	csrr	sp,sscratch
ffffffffc0200f3c:	712d                	addi	sp,sp,-288
ffffffffc0200f3e:	e002                	sd	zero,0(sp)
ffffffffc0200f40:	e406                	sd	ra,8(sp)
ffffffffc0200f42:	ec0e                	sd	gp,24(sp)
ffffffffc0200f44:	f012                	sd	tp,32(sp)
ffffffffc0200f46:	f416                	sd	t0,40(sp)
ffffffffc0200f48:	f81a                	sd	t1,48(sp)
ffffffffc0200f4a:	fc1e                	sd	t2,56(sp)
ffffffffc0200f4c:	e0a2                	sd	s0,64(sp)
ffffffffc0200f4e:	e4a6                	sd	s1,72(sp)
ffffffffc0200f50:	e8aa                	sd	a0,80(sp)
ffffffffc0200f52:	ecae                	sd	a1,88(sp)
ffffffffc0200f54:	f0b2                	sd	a2,96(sp)
ffffffffc0200f56:	f4b6                	sd	a3,104(sp)
ffffffffc0200f58:	f8ba                	sd	a4,112(sp)
ffffffffc0200f5a:	fcbe                	sd	a5,120(sp)
ffffffffc0200f5c:	e142                	sd	a6,128(sp)
ffffffffc0200f5e:	e546                	sd	a7,136(sp)
ffffffffc0200f60:	e94a                	sd	s2,144(sp)
ffffffffc0200f62:	ed4e                	sd	s3,152(sp)
ffffffffc0200f64:	f152                	sd	s4,160(sp)
ffffffffc0200f66:	f556                	sd	s5,168(sp)
ffffffffc0200f68:	f95a                	sd	s6,176(sp)
ffffffffc0200f6a:	fd5e                	sd	s7,184(sp)
ffffffffc0200f6c:	e1e2                	sd	s8,192(sp)
ffffffffc0200f6e:	e5e6                	sd	s9,200(sp)
ffffffffc0200f70:	e9ea                	sd	s10,208(sp)
ffffffffc0200f72:	edee                	sd	s11,216(sp)
ffffffffc0200f74:	f1f2                	sd	t3,224(sp)
ffffffffc0200f76:	f5f6                	sd	t4,232(sp)
ffffffffc0200f78:	f9fa                	sd	t5,240(sp)
ffffffffc0200f7a:	fdfe                	sd	t6,248(sp)
ffffffffc0200f7c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f80:	100024f3          	csrr	s1,sstatus
ffffffffc0200f84:	14102973          	csrr	s2,sepc
ffffffffc0200f88:	143029f3          	csrr	s3,stval
ffffffffc0200f8c:	14202a73          	csrr	s4,scause
ffffffffc0200f90:	e822                	sd	s0,16(sp)
ffffffffc0200f92:	e226                	sd	s1,256(sp)
ffffffffc0200f94:	e64a                	sd	s2,264(sp)
ffffffffc0200f96:	ea4e                	sd	s3,272(sp)
ffffffffc0200f98:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f9a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f9c:	f09ff0ef          	jal	ra,ffffffffc0200ea4 <trap>

ffffffffc0200fa0 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200fa0:	6492                	ld	s1,256(sp)
ffffffffc0200fa2:	6932                	ld	s2,264(sp)
ffffffffc0200fa4:	1004f413          	andi	s0,s1,256
ffffffffc0200fa8:	e401                	bnez	s0,ffffffffc0200fb0 <__trapret+0x10>
ffffffffc0200faa:	1200                	addi	s0,sp,288
ffffffffc0200fac:	14041073          	csrw	sscratch,s0
ffffffffc0200fb0:	10049073          	csrw	sstatus,s1
ffffffffc0200fb4:	14191073          	csrw	sepc,s2
ffffffffc0200fb8:	60a2                	ld	ra,8(sp)
ffffffffc0200fba:	61e2                	ld	gp,24(sp)
ffffffffc0200fbc:	7202                	ld	tp,32(sp)
ffffffffc0200fbe:	72a2                	ld	t0,40(sp)
ffffffffc0200fc0:	7342                	ld	t1,48(sp)
ffffffffc0200fc2:	73e2                	ld	t2,56(sp)
ffffffffc0200fc4:	6406                	ld	s0,64(sp)
ffffffffc0200fc6:	64a6                	ld	s1,72(sp)
ffffffffc0200fc8:	6546                	ld	a0,80(sp)
ffffffffc0200fca:	65e6                	ld	a1,88(sp)
ffffffffc0200fcc:	7606                	ld	a2,96(sp)
ffffffffc0200fce:	76a6                	ld	a3,104(sp)
ffffffffc0200fd0:	7746                	ld	a4,112(sp)
ffffffffc0200fd2:	77e6                	ld	a5,120(sp)
ffffffffc0200fd4:	680a                	ld	a6,128(sp)
ffffffffc0200fd6:	68aa                	ld	a7,136(sp)
ffffffffc0200fd8:	694a                	ld	s2,144(sp)
ffffffffc0200fda:	69ea                	ld	s3,152(sp)
ffffffffc0200fdc:	7a0a                	ld	s4,160(sp)
ffffffffc0200fde:	7aaa                	ld	s5,168(sp)
ffffffffc0200fe0:	7b4a                	ld	s6,176(sp)
ffffffffc0200fe2:	7bea                	ld	s7,184(sp)
ffffffffc0200fe4:	6c0e                	ld	s8,192(sp)
ffffffffc0200fe6:	6cae                	ld	s9,200(sp)
ffffffffc0200fe8:	6d4e                	ld	s10,208(sp)
ffffffffc0200fea:	6dee                	ld	s11,216(sp)
ffffffffc0200fec:	7e0e                	ld	t3,224(sp)
ffffffffc0200fee:	7eae                	ld	t4,232(sp)
ffffffffc0200ff0:	7f4e                	ld	t5,240(sp)
ffffffffc0200ff2:	7fee                	ld	t6,248(sp)
ffffffffc0200ff4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200ff6:	10200073          	sret

ffffffffc0200ffa <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200ffa:	812a                	mv	sp,a0
ffffffffc0200ffc:	b755                	j	ffffffffc0200fa0 <__trapret>

ffffffffc0200ffe <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0200ffe:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0201000:	00005697          	auipc	a3,0x5
ffffffffc0201004:	44868693          	addi	a3,a3,1096 # ffffffffc0206448 <commands+0x838>
ffffffffc0201008:	00005617          	auipc	a2,0x5
ffffffffc020100c:	46060613          	addi	a2,a2,1120 # ffffffffc0206468 <commands+0x858>
ffffffffc0201010:	07400593          	li	a1,116
ffffffffc0201014:	00005517          	auipc	a0,0x5
ffffffffc0201018:	46c50513          	addi	a0,a0,1132 # ffffffffc0206480 <commands+0x870>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020101c:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc020101e:	a04ff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201022 <mm_create>:
{
ffffffffc0201022:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201024:	04000513          	li	a0,64
{
ffffffffc0201028:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020102a:	135000ef          	jal	ra,ffffffffc020195e <kmalloc>
    if (mm != NULL)
ffffffffc020102e:	cd19                	beqz	a0,ffffffffc020104c <mm_create+0x2a>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201030:	e508                	sd	a0,8(a0)
ffffffffc0201032:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0201034:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0201038:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020103c:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0201040:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0201044:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0201048:	02053c23          	sd	zero,56(a0)
}
ffffffffc020104c:	60a2                	ld	ra,8(sp)
ffffffffc020104e:	0141                	addi	sp,sp,16
ffffffffc0201050:	8082                	ret

ffffffffc0201052 <find_vma>:
{
ffffffffc0201052:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0201054:	c505                	beqz	a0,ffffffffc020107c <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0201056:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201058:	c501                	beqz	a0,ffffffffc0201060 <find_vma+0xe>
ffffffffc020105a:	651c                	ld	a5,8(a0)
ffffffffc020105c:	02f5f263          	bgeu	a1,a5,ffffffffc0201080 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201060:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0201062:	00f68d63          	beq	a3,a5,ffffffffc020107c <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0201066:	fe87b703          	ld	a4,-24(a5)
ffffffffc020106a:	00e5e663          	bltu	a1,a4,ffffffffc0201076 <find_vma+0x24>
ffffffffc020106e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201072:	00e5ec63          	bltu	a1,a4,ffffffffc020108a <find_vma+0x38>
ffffffffc0201076:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0201078:	fef697e3          	bne	a3,a5,ffffffffc0201066 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020107c:	4501                	li	a0,0
}
ffffffffc020107e:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201080:	691c                	ld	a5,16(a0)
ffffffffc0201082:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0201060 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0201086:	ea88                	sd	a0,16(a3)
ffffffffc0201088:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020108a:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020108e:	ea88                	sd	a0,16(a3)
ffffffffc0201090:	8082                	ret

ffffffffc0201092 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201092:	6590                	ld	a2,8(a1)
ffffffffc0201094:	0105b803          	ld	a6,16(a1)
{
ffffffffc0201098:	1141                	addi	sp,sp,-16
ffffffffc020109a:	e406                	sd	ra,8(sp)
ffffffffc020109c:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020109e:	01066763          	bltu	a2,a6,ffffffffc02010ac <insert_vma_struct+0x1a>
ffffffffc02010a2:	a085                	j	ffffffffc0201102 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc02010a4:	fe87b703          	ld	a4,-24(a5)
ffffffffc02010a8:	04e66863          	bltu	a2,a4,ffffffffc02010f8 <insert_vma_struct+0x66>
ffffffffc02010ac:	86be                	mv	a3,a5
ffffffffc02010ae:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc02010b0:	fef51ae3          	bne	a0,a5,ffffffffc02010a4 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc02010b4:	02a68463          	beq	a3,a0,ffffffffc02010dc <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02010b8:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02010bc:	fe86b883          	ld	a7,-24(a3)
ffffffffc02010c0:	08e8f163          	bgeu	a7,a4,ffffffffc0201142 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02010c4:	04e66f63          	bltu	a2,a4,ffffffffc0201122 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc02010c8:	00f50a63          	beq	a0,a5,ffffffffc02010dc <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc02010cc:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02010d0:	05076963          	bltu	a4,a6,ffffffffc0201122 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02010d4:	ff07b603          	ld	a2,-16(a5)
ffffffffc02010d8:	02c77363          	bgeu	a4,a2,ffffffffc02010fe <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02010dc:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02010de:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02010e0:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02010e4:	e390                	sd	a2,0(a5)
ffffffffc02010e6:	e690                	sd	a2,8(a3)
}
ffffffffc02010e8:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02010ea:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02010ec:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02010ee:	0017079b          	addiw	a5,a4,1
ffffffffc02010f2:	d11c                	sw	a5,32(a0)
}
ffffffffc02010f4:	0141                	addi	sp,sp,16
ffffffffc02010f6:	8082                	ret
    if (le_prev != list)
ffffffffc02010f8:	fca690e3          	bne	a3,a0,ffffffffc02010b8 <insert_vma_struct+0x26>
ffffffffc02010fc:	bfd1                	j	ffffffffc02010d0 <insert_vma_struct+0x3e>
ffffffffc02010fe:	f01ff0ef          	jal	ra,ffffffffc0200ffe <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201102:	00005697          	auipc	a3,0x5
ffffffffc0201106:	38e68693          	addi	a3,a3,910 # ffffffffc0206490 <commands+0x880>
ffffffffc020110a:	00005617          	auipc	a2,0x5
ffffffffc020110e:	35e60613          	addi	a2,a2,862 # ffffffffc0206468 <commands+0x858>
ffffffffc0201112:	07a00593          	li	a1,122
ffffffffc0201116:	00005517          	auipc	a0,0x5
ffffffffc020111a:	36a50513          	addi	a0,a0,874 # ffffffffc0206480 <commands+0x870>
ffffffffc020111e:	904ff0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201122:	00005697          	auipc	a3,0x5
ffffffffc0201126:	3ae68693          	addi	a3,a3,942 # ffffffffc02064d0 <commands+0x8c0>
ffffffffc020112a:	00005617          	auipc	a2,0x5
ffffffffc020112e:	33e60613          	addi	a2,a2,830 # ffffffffc0206468 <commands+0x858>
ffffffffc0201132:	07300593          	li	a1,115
ffffffffc0201136:	00005517          	auipc	a0,0x5
ffffffffc020113a:	34a50513          	addi	a0,a0,842 # ffffffffc0206480 <commands+0x870>
ffffffffc020113e:	8e4ff0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201142:	00005697          	auipc	a3,0x5
ffffffffc0201146:	36e68693          	addi	a3,a3,878 # ffffffffc02064b0 <commands+0x8a0>
ffffffffc020114a:	00005617          	auipc	a2,0x5
ffffffffc020114e:	31e60613          	addi	a2,a2,798 # ffffffffc0206468 <commands+0x858>
ffffffffc0201152:	07200593          	li	a1,114
ffffffffc0201156:	00005517          	auipc	a0,0x5
ffffffffc020115a:	32a50513          	addi	a0,a0,810 # ffffffffc0206480 <commands+0x870>
ffffffffc020115e:	8c4ff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201162 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0201162:	591c                	lw	a5,48(a0)
{
ffffffffc0201164:	1141                	addi	sp,sp,-16
ffffffffc0201166:	e406                	sd	ra,8(sp)
ffffffffc0201168:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc020116a:	e78d                	bnez	a5,ffffffffc0201194 <mm_destroy+0x32>
ffffffffc020116c:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020116e:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0201170:	00a40c63          	beq	s0,a0,ffffffffc0201188 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0201174:	6118                	ld	a4,0(a0)
ffffffffc0201176:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0201178:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020117a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020117c:	e398                	sd	a4,0(a5)
ffffffffc020117e:	091000ef          	jal	ra,ffffffffc0201a0e <kfree>
    return listelm->next;
ffffffffc0201182:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0201184:	fea418e3          	bne	s0,a0,ffffffffc0201174 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0201188:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc020118a:	6402                	ld	s0,0(sp)
ffffffffc020118c:	60a2                	ld	ra,8(sp)
ffffffffc020118e:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0201190:	07f0006f          	j	ffffffffc0201a0e <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0201194:	00005697          	auipc	a3,0x5
ffffffffc0201198:	35c68693          	addi	a3,a3,860 # ffffffffc02064f0 <commands+0x8e0>
ffffffffc020119c:	00005617          	auipc	a2,0x5
ffffffffc02011a0:	2cc60613          	addi	a2,a2,716 # ffffffffc0206468 <commands+0x858>
ffffffffc02011a4:	09e00593          	li	a1,158
ffffffffc02011a8:	00005517          	auipc	a0,0x5
ffffffffc02011ac:	2d850513          	addi	a0,a0,728 # ffffffffc0206480 <commands+0x870>
ffffffffc02011b0:	872ff0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02011b4 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc02011b4:	7139                	addi	sp,sp,-64
ffffffffc02011b6:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02011b8:	6405                	lui	s0,0x1
ffffffffc02011ba:	147d                	addi	s0,s0,-1
ffffffffc02011bc:	77fd                	lui	a5,0xfffff
ffffffffc02011be:	9622                	add	a2,a2,s0
ffffffffc02011c0:	962e                	add	a2,a2,a1
{
ffffffffc02011c2:	f426                	sd	s1,40(sp)
ffffffffc02011c4:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02011c6:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc02011ca:	f04a                	sd	s2,32(sp)
ffffffffc02011cc:	ec4e                	sd	s3,24(sp)
ffffffffc02011ce:	e852                	sd	s4,16(sp)
ffffffffc02011d0:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc02011d2:	002005b7          	lui	a1,0x200
ffffffffc02011d6:	00f67433          	and	s0,a2,a5
ffffffffc02011da:	06b4e363          	bltu	s1,a1,ffffffffc0201240 <mm_map+0x8c>
ffffffffc02011de:	0684f163          	bgeu	s1,s0,ffffffffc0201240 <mm_map+0x8c>
ffffffffc02011e2:	4785                	li	a5,1
ffffffffc02011e4:	07fe                	slli	a5,a5,0x1f
ffffffffc02011e6:	0487ed63          	bltu	a5,s0,ffffffffc0201240 <mm_map+0x8c>
ffffffffc02011ea:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02011ec:	cd21                	beqz	a0,ffffffffc0201244 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02011ee:	85a6                	mv	a1,s1
ffffffffc02011f0:	8ab6                	mv	s5,a3
ffffffffc02011f2:	8a3a                	mv	s4,a4
ffffffffc02011f4:	e5fff0ef          	jal	ra,ffffffffc0201052 <find_vma>
ffffffffc02011f8:	c501                	beqz	a0,ffffffffc0201200 <mm_map+0x4c>
ffffffffc02011fa:	651c                	ld	a5,8(a0)
ffffffffc02011fc:	0487e263          	bltu	a5,s0,ffffffffc0201240 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201200:	03000513          	li	a0,48
ffffffffc0201204:	75a000ef          	jal	ra,ffffffffc020195e <kmalloc>
ffffffffc0201208:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc020120a:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc020120c:	02090163          	beqz	s2,ffffffffc020122e <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0201210:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0201212:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0201216:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc020121a:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc020121e:	85ca                	mv	a1,s2
ffffffffc0201220:	e73ff0ef          	jal	ra,ffffffffc0201092 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0201224:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0201226:	000a0463          	beqz	s4,ffffffffc020122e <mm_map+0x7a>
        *vma_store = vma;
ffffffffc020122a:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc020122e:	70e2                	ld	ra,56(sp)
ffffffffc0201230:	7442                	ld	s0,48(sp)
ffffffffc0201232:	74a2                	ld	s1,40(sp)
ffffffffc0201234:	7902                	ld	s2,32(sp)
ffffffffc0201236:	69e2                	ld	s3,24(sp)
ffffffffc0201238:	6a42                	ld	s4,16(sp)
ffffffffc020123a:	6aa2                	ld	s5,8(sp)
ffffffffc020123c:	6121                	addi	sp,sp,64
ffffffffc020123e:	8082                	ret
        return -E_INVAL;
ffffffffc0201240:	5575                	li	a0,-3
ffffffffc0201242:	b7f5                	j	ffffffffc020122e <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0201244:	00005697          	auipc	a3,0x5
ffffffffc0201248:	2c468693          	addi	a3,a3,708 # ffffffffc0206508 <commands+0x8f8>
ffffffffc020124c:	00005617          	auipc	a2,0x5
ffffffffc0201250:	21c60613          	addi	a2,a2,540 # ffffffffc0206468 <commands+0x858>
ffffffffc0201254:	0b300593          	li	a1,179
ffffffffc0201258:	00005517          	auipc	a0,0x5
ffffffffc020125c:	22850513          	addi	a0,a0,552 # ffffffffc0206480 <commands+0x870>
ffffffffc0201260:	fc3fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201264 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0201264:	7139                	addi	sp,sp,-64
ffffffffc0201266:	fc06                	sd	ra,56(sp)
ffffffffc0201268:	f822                	sd	s0,48(sp)
ffffffffc020126a:	f426                	sd	s1,40(sp)
ffffffffc020126c:	f04a                	sd	s2,32(sp)
ffffffffc020126e:	ec4e                	sd	s3,24(sp)
ffffffffc0201270:	e852                	sd	s4,16(sp)
ffffffffc0201272:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0201274:	c52d                	beqz	a0,ffffffffc02012de <dup_mmap+0x7a>
ffffffffc0201276:	892a                	mv	s2,a0
ffffffffc0201278:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc020127a:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc020127c:	e595                	bnez	a1,ffffffffc02012a8 <dup_mmap+0x44>
ffffffffc020127e:	a085                	j	ffffffffc02012de <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0201280:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0201282:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_matrix_out_size+0x1f38a8>
        vma->vm_end = vm_end;
ffffffffc0201286:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc020128a:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc020128e:	e05ff0ef          	jal	ra,ffffffffc0201092 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0201292:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8fa8>
ffffffffc0201296:	fe843603          	ld	a2,-24(s0)
ffffffffc020129a:	6c8c                	ld	a1,24(s1)
ffffffffc020129c:	01893503          	ld	a0,24(s2)
ffffffffc02012a0:	4701                	li	a4,0
ffffffffc02012a2:	027020ef          	jal	ra,ffffffffc0203ac8 <copy_range>
ffffffffc02012a6:	e105                	bnez	a0,ffffffffc02012c6 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc02012a8:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc02012aa:	02848863          	beq	s1,s0,ffffffffc02012da <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02012ae:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc02012b2:	fe843a83          	ld	s5,-24(s0)
ffffffffc02012b6:	ff043a03          	ld	s4,-16(s0)
ffffffffc02012ba:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02012be:	6a0000ef          	jal	ra,ffffffffc020195e <kmalloc>
ffffffffc02012c2:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc02012c4:	fd55                	bnez	a0,ffffffffc0201280 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc02012c6:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc02012c8:	70e2                	ld	ra,56(sp)
ffffffffc02012ca:	7442                	ld	s0,48(sp)
ffffffffc02012cc:	74a2                	ld	s1,40(sp)
ffffffffc02012ce:	7902                	ld	s2,32(sp)
ffffffffc02012d0:	69e2                	ld	s3,24(sp)
ffffffffc02012d2:	6a42                	ld	s4,16(sp)
ffffffffc02012d4:	6aa2                	ld	s5,8(sp)
ffffffffc02012d6:	6121                	addi	sp,sp,64
ffffffffc02012d8:	8082                	ret
    return 0;
ffffffffc02012da:	4501                	li	a0,0
ffffffffc02012dc:	b7f5                	j	ffffffffc02012c8 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc02012de:	00005697          	auipc	a3,0x5
ffffffffc02012e2:	23a68693          	addi	a3,a3,570 # ffffffffc0206518 <commands+0x908>
ffffffffc02012e6:	00005617          	auipc	a2,0x5
ffffffffc02012ea:	18260613          	addi	a2,a2,386 # ffffffffc0206468 <commands+0x858>
ffffffffc02012ee:	0cf00593          	li	a1,207
ffffffffc02012f2:	00005517          	auipc	a0,0x5
ffffffffc02012f6:	18e50513          	addi	a0,a0,398 # ffffffffc0206480 <commands+0x870>
ffffffffc02012fa:	f29fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02012fe <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02012fe:	1101                	addi	sp,sp,-32
ffffffffc0201300:	ec06                	sd	ra,24(sp)
ffffffffc0201302:	e822                	sd	s0,16(sp)
ffffffffc0201304:	e426                	sd	s1,8(sp)
ffffffffc0201306:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0201308:	c531                	beqz	a0,ffffffffc0201354 <exit_mmap+0x56>
ffffffffc020130a:	591c                	lw	a5,48(a0)
ffffffffc020130c:	84aa                	mv	s1,a0
ffffffffc020130e:	e3b9                	bnez	a5,ffffffffc0201354 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0201310:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0201312:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0201316:	02850663          	beq	a0,s0,ffffffffc0201342 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc020131a:	ff043603          	ld	a2,-16(s0)
ffffffffc020131e:	fe843583          	ld	a1,-24(s0)
ffffffffc0201322:	854a                	mv	a0,s2
ffffffffc0201324:	5fa010ef          	jal	ra,ffffffffc020291e <unmap_range>
ffffffffc0201328:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc020132a:	fe8498e3          	bne	s1,s0,ffffffffc020131a <exit_mmap+0x1c>
ffffffffc020132e:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0201330:	00848c63          	beq	s1,s0,ffffffffc0201348 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0201334:	ff043603          	ld	a2,-16(s0)
ffffffffc0201338:	fe843583          	ld	a1,-24(s0)
ffffffffc020133c:	854a                	mv	a0,s2
ffffffffc020133e:	726010ef          	jal	ra,ffffffffc0202a64 <exit_range>
ffffffffc0201342:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0201344:	fe8498e3          	bne	s1,s0,ffffffffc0201334 <exit_mmap+0x36>
    }
}
ffffffffc0201348:	60e2                	ld	ra,24(sp)
ffffffffc020134a:	6442                	ld	s0,16(sp)
ffffffffc020134c:	64a2                	ld	s1,8(sp)
ffffffffc020134e:	6902                	ld	s2,0(sp)
ffffffffc0201350:	6105                	addi	sp,sp,32
ffffffffc0201352:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0201354:	00005697          	auipc	a3,0x5
ffffffffc0201358:	1e468693          	addi	a3,a3,484 # ffffffffc0206538 <commands+0x928>
ffffffffc020135c:	00005617          	auipc	a2,0x5
ffffffffc0201360:	10c60613          	addi	a2,a2,268 # ffffffffc0206468 <commands+0x858>
ffffffffc0201364:	0e800593          	li	a1,232
ffffffffc0201368:	00005517          	auipc	a0,0x5
ffffffffc020136c:	11850513          	addi	a0,a0,280 # ffffffffc0206480 <commands+0x870>
ffffffffc0201370:	eb3fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201374 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0201374:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201376:	04000513          	li	a0,64
{
ffffffffc020137a:	fc06                	sd	ra,56(sp)
ffffffffc020137c:	f822                	sd	s0,48(sp)
ffffffffc020137e:	f426                	sd	s1,40(sp)
ffffffffc0201380:	f04a                	sd	s2,32(sp)
ffffffffc0201382:	ec4e                	sd	s3,24(sp)
ffffffffc0201384:	e852                	sd	s4,16(sp)
ffffffffc0201386:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201388:	5d6000ef          	jal	ra,ffffffffc020195e <kmalloc>
    if (mm != NULL)
ffffffffc020138c:	2e050663          	beqz	a0,ffffffffc0201678 <vmm_init+0x304>
ffffffffc0201390:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0201392:	e508                	sd	a0,8(a0)
ffffffffc0201394:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0201396:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020139a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020139e:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02013a2:	02053423          	sd	zero,40(a0)
ffffffffc02013a6:	02052823          	sw	zero,48(a0)
ffffffffc02013aa:	02053c23          	sd	zero,56(a0)
ffffffffc02013ae:	03200413          	li	s0,50
ffffffffc02013b2:	a811                	j	ffffffffc02013c6 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc02013b4:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02013b6:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02013b8:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc02013bc:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02013be:	8526                	mv	a0,s1
ffffffffc02013c0:	cd3ff0ef          	jal	ra,ffffffffc0201092 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc02013c4:	c80d                	beqz	s0,ffffffffc02013f6 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02013c6:	03000513          	li	a0,48
ffffffffc02013ca:	594000ef          	jal	ra,ffffffffc020195e <kmalloc>
ffffffffc02013ce:	85aa                	mv	a1,a0
ffffffffc02013d0:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02013d4:	f165                	bnez	a0,ffffffffc02013b4 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc02013d6:	00005697          	auipc	a3,0x5
ffffffffc02013da:	2fa68693          	addi	a3,a3,762 # ffffffffc02066d0 <commands+0xac0>
ffffffffc02013de:	00005617          	auipc	a2,0x5
ffffffffc02013e2:	08a60613          	addi	a2,a2,138 # ffffffffc0206468 <commands+0x858>
ffffffffc02013e6:	12c00593          	li	a1,300
ffffffffc02013ea:	00005517          	auipc	a0,0x5
ffffffffc02013ee:	09650513          	addi	a0,a0,150 # ffffffffc0206480 <commands+0x870>
ffffffffc02013f2:	e31fe0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc02013f6:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02013fa:	1f900913          	li	s2,505
ffffffffc02013fe:	a819                	j	ffffffffc0201414 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0201400:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201402:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201404:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0201408:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020140a:	8526                	mv	a0,s1
ffffffffc020140c:	c87ff0ef          	jal	ra,ffffffffc0201092 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0201410:	03240a63          	beq	s0,s2,ffffffffc0201444 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201414:	03000513          	li	a0,48
ffffffffc0201418:	546000ef          	jal	ra,ffffffffc020195e <kmalloc>
ffffffffc020141c:	85aa                	mv	a1,a0
ffffffffc020141e:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0201422:	fd79                	bnez	a0,ffffffffc0201400 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0201424:	00005697          	auipc	a3,0x5
ffffffffc0201428:	2ac68693          	addi	a3,a3,684 # ffffffffc02066d0 <commands+0xac0>
ffffffffc020142c:	00005617          	auipc	a2,0x5
ffffffffc0201430:	03c60613          	addi	a2,a2,60 # ffffffffc0206468 <commands+0x858>
ffffffffc0201434:	13300593          	li	a1,307
ffffffffc0201438:	00005517          	auipc	a0,0x5
ffffffffc020143c:	04850513          	addi	a0,a0,72 # ffffffffc0206480 <commands+0x870>
ffffffffc0201440:	de3fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    return listelm->next;
ffffffffc0201444:	649c                	ld	a5,8(s1)
ffffffffc0201446:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0201448:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc020144c:	16f48663          	beq	s1,a5,ffffffffc02015b8 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201450:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd37eb8>
ffffffffc0201454:	ffe70693          	addi	a3,a4,-2
ffffffffc0201458:	10d61063          	bne	a2,a3,ffffffffc0201558 <vmm_init+0x1e4>
ffffffffc020145c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0201460:	0ed71c63          	bne	a4,a3,ffffffffc0201558 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0201464:	0715                	addi	a4,a4,5
ffffffffc0201466:	679c                	ld	a5,8(a5)
ffffffffc0201468:	feb712e3          	bne	a4,a1,ffffffffc020144c <vmm_init+0xd8>
ffffffffc020146c:	4a1d                	li	s4,7
ffffffffc020146e:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0201470:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0201474:	85a2                	mv	a1,s0
ffffffffc0201476:	8526                	mv	a0,s1
ffffffffc0201478:	bdbff0ef          	jal	ra,ffffffffc0201052 <find_vma>
ffffffffc020147c:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc020147e:	16050d63          	beqz	a0,ffffffffc02015f8 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0201482:	00140593          	addi	a1,s0,1
ffffffffc0201486:	8526                	mv	a0,s1
ffffffffc0201488:	bcbff0ef          	jal	ra,ffffffffc0201052 <find_vma>
ffffffffc020148c:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc020148e:	14050563          	beqz	a0,ffffffffc02015d8 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0201492:	85d2                	mv	a1,s4
ffffffffc0201494:	8526                	mv	a0,s1
ffffffffc0201496:	bbdff0ef          	jal	ra,ffffffffc0201052 <find_vma>
        assert(vma3 == NULL);
ffffffffc020149a:	16051f63          	bnez	a0,ffffffffc0201618 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc020149e:	00340593          	addi	a1,s0,3
ffffffffc02014a2:	8526                	mv	a0,s1
ffffffffc02014a4:	bafff0ef          	jal	ra,ffffffffc0201052 <find_vma>
        assert(vma4 == NULL);
ffffffffc02014a8:	1a051863          	bnez	a0,ffffffffc0201658 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc02014ac:	00440593          	addi	a1,s0,4
ffffffffc02014b0:	8526                	mv	a0,s1
ffffffffc02014b2:	ba1ff0ef          	jal	ra,ffffffffc0201052 <find_vma>
        assert(vma5 == NULL);
ffffffffc02014b6:	18051163          	bnez	a0,ffffffffc0201638 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc02014ba:	00893783          	ld	a5,8(s2)
ffffffffc02014be:	0a879d63          	bne	a5,s0,ffffffffc0201578 <vmm_init+0x204>
ffffffffc02014c2:	01093783          	ld	a5,16(s2)
ffffffffc02014c6:	0b479963          	bne	a5,s4,ffffffffc0201578 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc02014ca:	0089b783          	ld	a5,8(s3)
ffffffffc02014ce:	0c879563          	bne	a5,s0,ffffffffc0201598 <vmm_init+0x224>
ffffffffc02014d2:	0109b783          	ld	a5,16(s3)
ffffffffc02014d6:	0d479163          	bne	a5,s4,ffffffffc0201598 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc02014da:	0415                	addi	s0,s0,5
ffffffffc02014dc:	0a15                	addi	s4,s4,5
ffffffffc02014de:	f9541be3          	bne	s0,s5,ffffffffc0201474 <vmm_init+0x100>
ffffffffc02014e2:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc02014e4:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc02014e6:	85a2                	mv	a1,s0
ffffffffc02014e8:	8526                	mv	a0,s1
ffffffffc02014ea:	b69ff0ef          	jal	ra,ffffffffc0201052 <find_vma>
ffffffffc02014ee:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc02014f2:	c90d                	beqz	a0,ffffffffc0201524 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02014f4:	6914                	ld	a3,16(a0)
ffffffffc02014f6:	6510                	ld	a2,8(a0)
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	16050513          	addi	a0,a0,352 # ffffffffc0206658 <commands+0xa48>
ffffffffc0201500:	be5fe0ef          	jal	ra,ffffffffc02000e4 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0201504:	00005697          	auipc	a3,0x5
ffffffffc0201508:	17c68693          	addi	a3,a3,380 # ffffffffc0206680 <commands+0xa70>
ffffffffc020150c:	00005617          	auipc	a2,0x5
ffffffffc0201510:	f5c60613          	addi	a2,a2,-164 # ffffffffc0206468 <commands+0x858>
ffffffffc0201514:	15900593          	li	a1,345
ffffffffc0201518:	00005517          	auipc	a0,0x5
ffffffffc020151c:	f6850513          	addi	a0,a0,-152 # ffffffffc0206480 <commands+0x870>
ffffffffc0201520:	d03fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0201524:	147d                	addi	s0,s0,-1
ffffffffc0201526:	fd2410e3          	bne	s0,s2,ffffffffc02014e6 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc020152a:	8526                	mv	a0,s1
ffffffffc020152c:	c37ff0ef          	jal	ra,ffffffffc0201162 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0201530:	00005517          	auipc	a0,0x5
ffffffffc0201534:	16850513          	addi	a0,a0,360 # ffffffffc0206698 <commands+0xa88>
ffffffffc0201538:	badfe0ef          	jal	ra,ffffffffc02000e4 <cprintf>
}
ffffffffc020153c:	7442                	ld	s0,48(sp)
ffffffffc020153e:	70e2                	ld	ra,56(sp)
ffffffffc0201540:	74a2                	ld	s1,40(sp)
ffffffffc0201542:	7902                	ld	s2,32(sp)
ffffffffc0201544:	69e2                	ld	s3,24(sp)
ffffffffc0201546:	6a42                	ld	s4,16(sp)
ffffffffc0201548:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc020154a:	00005517          	auipc	a0,0x5
ffffffffc020154e:	16e50513          	addi	a0,a0,366 # ffffffffc02066b8 <commands+0xaa8>
}
ffffffffc0201552:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0201554:	b91fe06f          	j	ffffffffc02000e4 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201558:	00005697          	auipc	a3,0x5
ffffffffc020155c:	01868693          	addi	a3,a3,24 # ffffffffc0206570 <commands+0x960>
ffffffffc0201560:	00005617          	auipc	a2,0x5
ffffffffc0201564:	f0860613          	addi	a2,a2,-248 # ffffffffc0206468 <commands+0x858>
ffffffffc0201568:	13d00593          	li	a1,317
ffffffffc020156c:	00005517          	auipc	a0,0x5
ffffffffc0201570:	f1450513          	addi	a0,a0,-236 # ffffffffc0206480 <commands+0x870>
ffffffffc0201574:	caffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0201578:	00005697          	auipc	a3,0x5
ffffffffc020157c:	08068693          	addi	a3,a3,128 # ffffffffc02065f8 <commands+0x9e8>
ffffffffc0201580:	00005617          	auipc	a2,0x5
ffffffffc0201584:	ee860613          	addi	a2,a2,-280 # ffffffffc0206468 <commands+0x858>
ffffffffc0201588:	14e00593          	li	a1,334
ffffffffc020158c:	00005517          	auipc	a0,0x5
ffffffffc0201590:	ef450513          	addi	a0,a0,-268 # ffffffffc0206480 <commands+0x870>
ffffffffc0201594:	c8ffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0201598:	00005697          	auipc	a3,0x5
ffffffffc020159c:	09068693          	addi	a3,a3,144 # ffffffffc0206628 <commands+0xa18>
ffffffffc02015a0:	00005617          	auipc	a2,0x5
ffffffffc02015a4:	ec860613          	addi	a2,a2,-312 # ffffffffc0206468 <commands+0x858>
ffffffffc02015a8:	14f00593          	li	a1,335
ffffffffc02015ac:	00005517          	auipc	a0,0x5
ffffffffc02015b0:	ed450513          	addi	a0,a0,-300 # ffffffffc0206480 <commands+0x870>
ffffffffc02015b4:	c6ffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc02015b8:	00005697          	auipc	a3,0x5
ffffffffc02015bc:	fa068693          	addi	a3,a3,-96 # ffffffffc0206558 <commands+0x948>
ffffffffc02015c0:	00005617          	auipc	a2,0x5
ffffffffc02015c4:	ea860613          	addi	a2,a2,-344 # ffffffffc0206468 <commands+0x858>
ffffffffc02015c8:	13b00593          	li	a1,315
ffffffffc02015cc:	00005517          	auipc	a0,0x5
ffffffffc02015d0:	eb450513          	addi	a0,a0,-332 # ffffffffc0206480 <commands+0x870>
ffffffffc02015d4:	c4ffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma2 != NULL);
ffffffffc02015d8:	00005697          	auipc	a3,0x5
ffffffffc02015dc:	fe068693          	addi	a3,a3,-32 # ffffffffc02065b8 <commands+0x9a8>
ffffffffc02015e0:	00005617          	auipc	a2,0x5
ffffffffc02015e4:	e8860613          	addi	a2,a2,-376 # ffffffffc0206468 <commands+0x858>
ffffffffc02015e8:	14600593          	li	a1,326
ffffffffc02015ec:	00005517          	auipc	a0,0x5
ffffffffc02015f0:	e9450513          	addi	a0,a0,-364 # ffffffffc0206480 <commands+0x870>
ffffffffc02015f4:	c2ffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma1 != NULL);
ffffffffc02015f8:	00005697          	auipc	a3,0x5
ffffffffc02015fc:	fb068693          	addi	a3,a3,-80 # ffffffffc02065a8 <commands+0x998>
ffffffffc0201600:	00005617          	auipc	a2,0x5
ffffffffc0201604:	e6860613          	addi	a2,a2,-408 # ffffffffc0206468 <commands+0x858>
ffffffffc0201608:	14400593          	li	a1,324
ffffffffc020160c:	00005517          	auipc	a0,0x5
ffffffffc0201610:	e7450513          	addi	a0,a0,-396 # ffffffffc0206480 <commands+0x870>
ffffffffc0201614:	c0ffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma3 == NULL);
ffffffffc0201618:	00005697          	auipc	a3,0x5
ffffffffc020161c:	fb068693          	addi	a3,a3,-80 # ffffffffc02065c8 <commands+0x9b8>
ffffffffc0201620:	00005617          	auipc	a2,0x5
ffffffffc0201624:	e4860613          	addi	a2,a2,-440 # ffffffffc0206468 <commands+0x858>
ffffffffc0201628:	14800593          	li	a1,328
ffffffffc020162c:	00005517          	auipc	a0,0x5
ffffffffc0201630:	e5450513          	addi	a0,a0,-428 # ffffffffc0206480 <commands+0x870>
ffffffffc0201634:	beffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma5 == NULL);
ffffffffc0201638:	00005697          	auipc	a3,0x5
ffffffffc020163c:	fb068693          	addi	a3,a3,-80 # ffffffffc02065e8 <commands+0x9d8>
ffffffffc0201640:	00005617          	auipc	a2,0x5
ffffffffc0201644:	e2860613          	addi	a2,a2,-472 # ffffffffc0206468 <commands+0x858>
ffffffffc0201648:	14c00593          	li	a1,332
ffffffffc020164c:	00005517          	auipc	a0,0x5
ffffffffc0201650:	e3450513          	addi	a0,a0,-460 # ffffffffc0206480 <commands+0x870>
ffffffffc0201654:	bcffe0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(vma4 == NULL);
ffffffffc0201658:	00005697          	auipc	a3,0x5
ffffffffc020165c:	f8068693          	addi	a3,a3,-128 # ffffffffc02065d8 <commands+0x9c8>
ffffffffc0201660:	00005617          	auipc	a2,0x5
ffffffffc0201664:	e0860613          	addi	a2,a2,-504 # ffffffffc0206468 <commands+0x858>
ffffffffc0201668:	14a00593          	li	a1,330
ffffffffc020166c:	00005517          	auipc	a0,0x5
ffffffffc0201670:	e1450513          	addi	a0,a0,-492 # ffffffffc0206480 <commands+0x870>
ffffffffc0201674:	baffe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(mm != NULL);
ffffffffc0201678:	00005697          	auipc	a3,0x5
ffffffffc020167c:	e9068693          	addi	a3,a3,-368 # ffffffffc0206508 <commands+0x8f8>
ffffffffc0201680:	00005617          	auipc	a2,0x5
ffffffffc0201684:	de860613          	addi	a2,a2,-536 # ffffffffc0206468 <commands+0x858>
ffffffffc0201688:	12400593          	li	a1,292
ffffffffc020168c:	00005517          	auipc	a0,0x5
ffffffffc0201690:	df450513          	addi	a0,a0,-524 # ffffffffc0206480 <commands+0x870>
ffffffffc0201694:	b8ffe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201698 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0201698:	7179                	addi	sp,sp,-48
ffffffffc020169a:	f022                	sd	s0,32(sp)
ffffffffc020169c:	f406                	sd	ra,40(sp)
ffffffffc020169e:	ec26                	sd	s1,24(sp)
ffffffffc02016a0:	e84a                	sd	s2,16(sp)
ffffffffc02016a2:	e44e                	sd	s3,8(sp)
ffffffffc02016a4:	e052                	sd	s4,0(sp)
ffffffffc02016a6:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc02016a8:	c135                	beqz	a0,ffffffffc020170c <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc02016aa:	002007b7          	lui	a5,0x200
ffffffffc02016ae:	04f5e663          	bltu	a1,a5,ffffffffc02016fa <user_mem_check+0x62>
ffffffffc02016b2:	00c584b3          	add	s1,a1,a2
ffffffffc02016b6:	0495f263          	bgeu	a1,s1,ffffffffc02016fa <user_mem_check+0x62>
ffffffffc02016ba:	4785                	li	a5,1
ffffffffc02016bc:	07fe                	slli	a5,a5,0x1f
ffffffffc02016be:	0297ee63          	bltu	a5,s1,ffffffffc02016fa <user_mem_check+0x62>
ffffffffc02016c2:	892a                	mv	s2,a0
ffffffffc02016c4:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc02016c6:	6a05                	lui	s4,0x1
ffffffffc02016c8:	a821                	j	ffffffffc02016e0 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02016ca:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc02016ce:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc02016d0:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02016d2:	c685                	beqz	a3,ffffffffc02016fa <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc02016d4:	c399                	beqz	a5,ffffffffc02016da <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc02016d6:	02e46263          	bltu	s0,a4,ffffffffc02016fa <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc02016da:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc02016dc:	04947663          	bgeu	s0,s1,ffffffffc0201728 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc02016e0:	85a2                	mv	a1,s0
ffffffffc02016e2:	854a                	mv	a0,s2
ffffffffc02016e4:	96fff0ef          	jal	ra,ffffffffc0201052 <find_vma>
ffffffffc02016e8:	c909                	beqz	a0,ffffffffc02016fa <user_mem_check+0x62>
ffffffffc02016ea:	6518                	ld	a4,8(a0)
ffffffffc02016ec:	00e46763          	bltu	s0,a4,ffffffffc02016fa <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02016f0:	4d1c                	lw	a5,24(a0)
ffffffffc02016f2:	fc099ce3          	bnez	s3,ffffffffc02016ca <user_mem_check+0x32>
ffffffffc02016f6:	8b85                	andi	a5,a5,1
ffffffffc02016f8:	f3ed                	bnez	a5,ffffffffc02016da <user_mem_check+0x42>
            return 0;
ffffffffc02016fa:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc02016fc:	70a2                	ld	ra,40(sp)
ffffffffc02016fe:	7402                	ld	s0,32(sp)
ffffffffc0201700:	64e2                	ld	s1,24(sp)
ffffffffc0201702:	6942                	ld	s2,16(sp)
ffffffffc0201704:	69a2                	ld	s3,8(sp)
ffffffffc0201706:	6a02                	ld	s4,0(sp)
ffffffffc0201708:	6145                	addi	sp,sp,48
ffffffffc020170a:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc020170c:	c02007b7          	lui	a5,0xc0200
ffffffffc0201710:	4501                	li	a0,0
ffffffffc0201712:	fef5e5e3          	bltu	a1,a5,ffffffffc02016fc <user_mem_check+0x64>
ffffffffc0201716:	962e                	add	a2,a2,a1
ffffffffc0201718:	fec5f2e3          	bgeu	a1,a2,ffffffffc02016fc <user_mem_check+0x64>
ffffffffc020171c:	c8000537          	lui	a0,0xc8000
ffffffffc0201720:	0505                	addi	a0,a0,1
ffffffffc0201722:	00a63533          	sltu	a0,a2,a0
ffffffffc0201726:	bfd9                	j	ffffffffc02016fc <user_mem_check+0x64>
        return 1;
ffffffffc0201728:	4505                	li	a0,1
ffffffffc020172a:	bfc9                	j	ffffffffc02016fc <user_mem_check+0x64>

ffffffffc020172c <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc020172c:	c94d                	beqz	a0,ffffffffc02017de <slob_free+0xb2>
{
ffffffffc020172e:	1141                	addi	sp,sp,-16
ffffffffc0201730:	e022                	sd	s0,0(sp)
ffffffffc0201732:	e406                	sd	ra,8(sp)
ffffffffc0201734:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201736:	e9c1                	bnez	a1,ffffffffc02017c6 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201738:	100027f3          	csrr	a5,sstatus
ffffffffc020173c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020173e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201740:	ebd9                	bnez	a5,ffffffffc02017d6 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201742:	000c1617          	auipc	a2,0xc1
ffffffffc0201746:	4fe60613          	addi	a2,a2,1278 # ffffffffc02c2c40 <slobfree>
ffffffffc020174a:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020174c:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020174e:	679c                	ld	a5,8(a5)
ffffffffc0201750:	02877a63          	bgeu	a4,s0,ffffffffc0201784 <slob_free+0x58>
ffffffffc0201754:	00f46463          	bltu	s0,a5,ffffffffc020175c <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201758:	fef76ae3          	bltu	a4,a5,ffffffffc020174c <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc020175c:	400c                	lw	a1,0(s0)
ffffffffc020175e:	00459693          	slli	a3,a1,0x4
ffffffffc0201762:	96a2                	add	a3,a3,s0
ffffffffc0201764:	02d78a63          	beq	a5,a3,ffffffffc0201798 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201768:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc020176a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc020176c:	00469793          	slli	a5,a3,0x4
ffffffffc0201770:	97ba                	add	a5,a5,a4
ffffffffc0201772:	02f40e63          	beq	s0,a5,ffffffffc02017ae <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201776:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201778:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc020177a:	e129                	bnez	a0,ffffffffc02017bc <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc020177c:	60a2                	ld	ra,8(sp)
ffffffffc020177e:	6402                	ld	s0,0(sp)
ffffffffc0201780:	0141                	addi	sp,sp,16
ffffffffc0201782:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201784:	fcf764e3          	bltu	a4,a5,ffffffffc020174c <slob_free+0x20>
ffffffffc0201788:	fcf472e3          	bgeu	s0,a5,ffffffffc020174c <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc020178c:	400c                	lw	a1,0(s0)
ffffffffc020178e:	00459693          	slli	a3,a1,0x4
ffffffffc0201792:	96a2                	add	a3,a3,s0
ffffffffc0201794:	fcd79ae3          	bne	a5,a3,ffffffffc0201768 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201798:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020179a:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc020179c:	9db5                	addw	a1,a1,a3
ffffffffc020179e:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc02017a0:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02017a2:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02017a4:	00469793          	slli	a5,a3,0x4
ffffffffc02017a8:	97ba                	add	a5,a5,a4
ffffffffc02017aa:	fcf416e3          	bne	s0,a5,ffffffffc0201776 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc02017ae:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc02017b0:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc02017b2:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc02017b4:	9ebd                	addw	a3,a3,a5
ffffffffc02017b6:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc02017b8:	e70c                	sd	a1,8(a4)
ffffffffc02017ba:	d169                	beqz	a0,ffffffffc020177c <slob_free+0x50>
}
ffffffffc02017bc:	6402                	ld	s0,0(sp)
ffffffffc02017be:	60a2                	ld	ra,8(sp)
ffffffffc02017c0:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02017c2:	9ecff06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc02017c6:	25bd                	addiw	a1,a1,15
ffffffffc02017c8:	8191                	srli	a1,a1,0x4
ffffffffc02017ca:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02017cc:	100027f3          	csrr	a5,sstatus
ffffffffc02017d0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02017d2:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02017d4:	d7bd                	beqz	a5,ffffffffc0201742 <slob_free+0x16>
        intr_disable();
ffffffffc02017d6:	9deff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02017da:	4505                	li	a0,1
ffffffffc02017dc:	b79d                	j	ffffffffc0201742 <slob_free+0x16>
ffffffffc02017de:	8082                	ret

ffffffffc02017e0 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc02017e0:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02017e2:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc02017e4:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02017e8:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc02017ea:	601000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
	if (!page)
ffffffffc02017ee:	c91d                	beqz	a0,ffffffffc0201824 <__slob_get_free_pages.constprop.0+0x44>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc02017f0:	000c6697          	auipc	a3,0xc6
ffffffffc02017f4:	8f86b683          	ld	a3,-1800(a3) # ffffffffc02c70e8 <pages>
ffffffffc02017f8:	8d15                	sub	a0,a0,a3
ffffffffc02017fa:	8519                	srai	a0,a0,0x6
ffffffffc02017fc:	00007697          	auipc	a3,0x7
ffffffffc0201800:	ad46b683          	ld	a3,-1324(a3) # ffffffffc02082d0 <nbase>
ffffffffc0201804:	9536                	add	a0,a0,a3
}

static inline void *
page2kva(struct Page *page)
{
    return KADDR(page2pa(page));
ffffffffc0201806:	00c51793          	slli	a5,a0,0xc
ffffffffc020180a:	83b1                	srli	a5,a5,0xc
ffffffffc020180c:	000c6717          	auipc	a4,0xc6
ffffffffc0201810:	8d473703          	ld	a4,-1836(a4) # ffffffffc02c70e0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201814:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201816:	00e7fa63          	bgeu	a5,a4,ffffffffc020182a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc020181a:	000c6697          	auipc	a3,0xc6
ffffffffc020181e:	8de6b683          	ld	a3,-1826(a3) # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0201822:	9536                	add	a0,a0,a3
}
ffffffffc0201824:	60a2                	ld	ra,8(sp)
ffffffffc0201826:	0141                	addi	sp,sp,16
ffffffffc0201828:	8082                	ret
ffffffffc020182a:	86aa                	mv	a3,a0
ffffffffc020182c:	00005617          	auipc	a2,0x5
ffffffffc0201830:	eb460613          	addi	a2,a2,-332 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0201834:	07100593          	li	a1,113
ffffffffc0201838:	00005517          	auipc	a0,0x5
ffffffffc020183c:	ed050513          	addi	a0,a0,-304 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0201840:	9e3fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201844 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201844:	1101                	addi	sp,sp,-32
ffffffffc0201846:	ec06                	sd	ra,24(sp)
ffffffffc0201848:	e822                	sd	s0,16(sp)
ffffffffc020184a:	e426                	sd	s1,8(sp)
ffffffffc020184c:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020184e:	01050713          	addi	a4,a0,16
ffffffffc0201852:	6785                	lui	a5,0x1
ffffffffc0201854:	0cf77363          	bgeu	a4,a5,ffffffffc020191a <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201858:	00f50493          	addi	s1,a0,15
ffffffffc020185c:	8091                	srli	s1,s1,0x4
ffffffffc020185e:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201860:	10002673          	csrr	a2,sstatus
ffffffffc0201864:	8a09                	andi	a2,a2,2
ffffffffc0201866:	e25d                	bnez	a2,ffffffffc020190c <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201868:	000c1917          	auipc	s2,0xc1
ffffffffc020186c:	3d890913          	addi	s2,s2,984 # ffffffffc02c2c40 <slobfree>
ffffffffc0201870:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201874:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201876:	4398                	lw	a4,0(a5)
ffffffffc0201878:	08975e63          	bge	a4,s1,ffffffffc0201914 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc020187c:	00f68b63          	beq	a3,a5,ffffffffc0201892 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201880:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201882:	4018                	lw	a4,0(s0)
ffffffffc0201884:	02975a63          	bge	a4,s1,ffffffffc02018b8 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201888:	00093683          	ld	a3,0(s2)
ffffffffc020188c:	87a2                	mv	a5,s0
ffffffffc020188e:	fef699e3          	bne	a3,a5,ffffffffc0201880 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201892:	ee31                	bnez	a2,ffffffffc02018ee <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201894:	4501                	li	a0,0
ffffffffc0201896:	f4bff0ef          	jal	ra,ffffffffc02017e0 <__slob_get_free_pages.constprop.0>
ffffffffc020189a:	842a                	mv	s0,a0
			if (!cur)
ffffffffc020189c:	cd05                	beqz	a0,ffffffffc02018d4 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc020189e:	6585                	lui	a1,0x1
ffffffffc02018a0:	e8dff0ef          	jal	ra,ffffffffc020172c <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02018a4:	10002673          	csrr	a2,sstatus
ffffffffc02018a8:	8a09                	andi	a2,a2,2
ffffffffc02018aa:	ee05                	bnez	a2,ffffffffc02018e2 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc02018ac:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02018b0:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02018b2:	4018                	lw	a4,0(s0)
ffffffffc02018b4:	fc974ae3          	blt	a4,s1,ffffffffc0201888 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc02018b8:	04e48763          	beq	s1,a4,ffffffffc0201906 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc02018bc:	00449693          	slli	a3,s1,0x4
ffffffffc02018c0:	96a2                	add	a3,a3,s0
ffffffffc02018c2:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc02018c4:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc02018c6:	9f05                	subw	a4,a4,s1
ffffffffc02018c8:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc02018ca:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc02018cc:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc02018ce:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc02018d2:	e20d                	bnez	a2,ffffffffc02018f4 <slob_alloc.constprop.0+0xb0>
}
ffffffffc02018d4:	60e2                	ld	ra,24(sp)
ffffffffc02018d6:	8522                	mv	a0,s0
ffffffffc02018d8:	6442                	ld	s0,16(sp)
ffffffffc02018da:	64a2                	ld	s1,8(sp)
ffffffffc02018dc:	6902                	ld	s2,0(sp)
ffffffffc02018de:	6105                	addi	sp,sp,32
ffffffffc02018e0:	8082                	ret
        intr_disable();
ffffffffc02018e2:	8d2ff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc02018e6:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc02018ea:	4605                	li	a2,1
ffffffffc02018ec:	b7d1                	j	ffffffffc02018b0 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02018ee:	8c0ff0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02018f2:	b74d                	j	ffffffffc0201894 <slob_alloc.constprop.0+0x50>
ffffffffc02018f4:	8baff0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02018f8:	60e2                	ld	ra,24(sp)
ffffffffc02018fa:	8522                	mv	a0,s0
ffffffffc02018fc:	6442                	ld	s0,16(sp)
ffffffffc02018fe:	64a2                	ld	s1,8(sp)
ffffffffc0201900:	6902                	ld	s2,0(sp)
ffffffffc0201902:	6105                	addi	sp,sp,32
ffffffffc0201904:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201906:	6418                	ld	a4,8(s0)
ffffffffc0201908:	e798                	sd	a4,8(a5)
ffffffffc020190a:	b7d1                	j	ffffffffc02018ce <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc020190c:	8a8ff0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201910:	4605                	li	a2,1
ffffffffc0201912:	bf99                	j	ffffffffc0201868 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201914:	843e                	mv	s0,a5
ffffffffc0201916:	87b6                	mv	a5,a3
ffffffffc0201918:	b745                	j	ffffffffc02018b8 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020191a:	00005697          	auipc	a3,0x5
ffffffffc020191e:	dfe68693          	addi	a3,a3,-514 # ffffffffc0206718 <commands+0xb08>
ffffffffc0201922:	00005617          	auipc	a2,0x5
ffffffffc0201926:	b4660613          	addi	a2,a2,-1210 # ffffffffc0206468 <commands+0x858>
ffffffffc020192a:	06300593          	li	a1,99
ffffffffc020192e:	00005517          	auipc	a0,0x5
ffffffffc0201932:	e0a50513          	addi	a0,a0,-502 # ffffffffc0206738 <commands+0xb28>
ffffffffc0201936:	8edfe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020193a <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc020193a:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc020193c:	00005517          	auipc	a0,0x5
ffffffffc0201940:	e1450513          	addi	a0,a0,-492 # ffffffffc0206750 <commands+0xb40>
{
ffffffffc0201944:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201946:	f9efe0ef          	jal	ra,ffffffffc02000e4 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc020194a:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc020194c:	00005517          	auipc	a0,0x5
ffffffffc0201950:	e1c50513          	addi	a0,a0,-484 # ffffffffc0206768 <commands+0xb58>
}
ffffffffc0201954:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201956:	f8efe06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc020195a <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc020195a:	4501                	li	a0,0
ffffffffc020195c:	8082                	ret

ffffffffc020195e <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc020195e:	1101                	addi	sp,sp,-32
ffffffffc0201960:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201962:	6905                	lui	s2,0x1
{
ffffffffc0201964:	e822                	sd	s0,16(sp)
ffffffffc0201966:	ec06                	sd	ra,24(sp)
ffffffffc0201968:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc020196a:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8fa9>
{
ffffffffc020196e:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201970:	04a7f963          	bgeu	a5,a0,ffffffffc02019c2 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201974:	4561                	li	a0,24
ffffffffc0201976:	ecfff0ef          	jal	ra,ffffffffc0201844 <slob_alloc.constprop.0>
ffffffffc020197a:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc020197c:	c929                	beqz	a0,ffffffffc02019ce <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc020197e:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201982:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201984:	00f95763          	bge	s2,a5,ffffffffc0201992 <kmalloc+0x34>
ffffffffc0201988:	6705                	lui	a4,0x1
ffffffffc020198a:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc020198c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc020198e:	fef74ee3          	blt	a4,a5,ffffffffc020198a <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201992:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201994:	e4dff0ef          	jal	ra,ffffffffc02017e0 <__slob_get_free_pages.constprop.0>
ffffffffc0201998:	e488                	sd	a0,8(s1)
ffffffffc020199a:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc020199c:	c525                	beqz	a0,ffffffffc0201a04 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020199e:	100027f3          	csrr	a5,sstatus
ffffffffc02019a2:	8b89                	andi	a5,a5,2
ffffffffc02019a4:	ef8d                	bnez	a5,ffffffffc02019de <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc02019a6:	000c5797          	auipc	a5,0xc5
ffffffffc02019aa:	72278793          	addi	a5,a5,1826 # ffffffffc02c70c8 <bigblocks>
ffffffffc02019ae:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02019b0:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02019b2:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc02019b4:	60e2                	ld	ra,24(sp)
ffffffffc02019b6:	8522                	mv	a0,s0
ffffffffc02019b8:	6442                	ld	s0,16(sp)
ffffffffc02019ba:	64a2                	ld	s1,8(sp)
ffffffffc02019bc:	6902                	ld	s2,0(sp)
ffffffffc02019be:	6105                	addi	sp,sp,32
ffffffffc02019c0:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc02019c2:	0541                	addi	a0,a0,16
ffffffffc02019c4:	e81ff0ef          	jal	ra,ffffffffc0201844 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc02019c8:	01050413          	addi	s0,a0,16
ffffffffc02019cc:	f565                	bnez	a0,ffffffffc02019b4 <kmalloc+0x56>
ffffffffc02019ce:	4401                	li	s0,0
}
ffffffffc02019d0:	60e2                	ld	ra,24(sp)
ffffffffc02019d2:	8522                	mv	a0,s0
ffffffffc02019d4:	6442                	ld	s0,16(sp)
ffffffffc02019d6:	64a2                	ld	s1,8(sp)
ffffffffc02019d8:	6902                	ld	s2,0(sp)
ffffffffc02019da:	6105                	addi	sp,sp,32
ffffffffc02019dc:	8082                	ret
        intr_disable();
ffffffffc02019de:	fd7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc02019e2:	000c5797          	auipc	a5,0xc5
ffffffffc02019e6:	6e678793          	addi	a5,a5,1766 # ffffffffc02c70c8 <bigblocks>
ffffffffc02019ea:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02019ec:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02019ee:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc02019f0:	fbffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc02019f4:	6480                	ld	s0,8(s1)
}
ffffffffc02019f6:	60e2                	ld	ra,24(sp)
ffffffffc02019f8:	64a2                	ld	s1,8(sp)
ffffffffc02019fa:	8522                	mv	a0,s0
ffffffffc02019fc:	6442                	ld	s0,16(sp)
ffffffffc02019fe:	6902                	ld	s2,0(sp)
ffffffffc0201a00:	6105                	addi	sp,sp,32
ffffffffc0201a02:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a04:	45e1                	li	a1,24
ffffffffc0201a06:	8526                	mv	a0,s1
ffffffffc0201a08:	d25ff0ef          	jal	ra,ffffffffc020172c <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201a0c:	b765                	j	ffffffffc02019b4 <kmalloc+0x56>

ffffffffc0201a0e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201a0e:	c169                	beqz	a0,ffffffffc0201ad0 <kfree+0xc2>
{
ffffffffc0201a10:	1101                	addi	sp,sp,-32
ffffffffc0201a12:	e822                	sd	s0,16(sp)
ffffffffc0201a14:	ec06                	sd	ra,24(sp)
ffffffffc0201a16:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201a18:	03451793          	slli	a5,a0,0x34
ffffffffc0201a1c:	842a                	mv	s0,a0
ffffffffc0201a1e:	e3d9                	bnez	a5,ffffffffc0201aa4 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a20:	100027f3          	csrr	a5,sstatus
ffffffffc0201a24:	8b89                	andi	a5,a5,2
ffffffffc0201a26:	e7d9                	bnez	a5,ffffffffc0201ab4 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201a28:	000c5797          	auipc	a5,0xc5
ffffffffc0201a2c:	6a07b783          	ld	a5,1696(a5) # ffffffffc02c70c8 <bigblocks>
    return 0;
ffffffffc0201a30:	4601                	li	a2,0
ffffffffc0201a32:	cbad                	beqz	a5,ffffffffc0201aa4 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201a34:	000c5697          	auipc	a3,0xc5
ffffffffc0201a38:	69468693          	addi	a3,a3,1684 # ffffffffc02c70c8 <bigblocks>
ffffffffc0201a3c:	a021                	j	ffffffffc0201a44 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201a3e:	01048693          	addi	a3,s1,16
ffffffffc0201a42:	c3a5                	beqz	a5,ffffffffc0201aa2 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201a44:	6798                	ld	a4,8(a5)
ffffffffc0201a46:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201a48:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201a4a:	fe871ae3          	bne	a4,s0,ffffffffc0201a3e <kfree+0x30>
				*last = bb->next;
ffffffffc0201a4e:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201a50:	ee2d                	bnez	a2,ffffffffc0201aca <kfree+0xbc>
}

static inline struct Page *
kva2page(void *kva)
{
    return pa2page(PADDR(kva));
ffffffffc0201a52:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201a56:	4098                	lw	a4,0(s1)
ffffffffc0201a58:	08f46963          	bltu	s0,a5,ffffffffc0201aea <kfree+0xdc>
ffffffffc0201a5c:	000c5697          	auipc	a3,0xc5
ffffffffc0201a60:	69c6b683          	ld	a3,1692(a3) # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0201a64:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201a66:	8031                	srli	s0,s0,0xc
ffffffffc0201a68:	000c5797          	auipc	a5,0xc5
ffffffffc0201a6c:	6787b783          	ld	a5,1656(a5) # ffffffffc02c70e0 <npage>
ffffffffc0201a70:	06f47163          	bgeu	s0,a5,ffffffffc0201ad2 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201a74:	00007517          	auipc	a0,0x7
ffffffffc0201a78:	85c53503          	ld	a0,-1956(a0) # ffffffffc02082d0 <nbase>
ffffffffc0201a7c:	8c09                	sub	s0,s0,a0
ffffffffc0201a7e:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201a80:	000c5517          	auipc	a0,0xc5
ffffffffc0201a84:	66853503          	ld	a0,1640(a0) # ffffffffc02c70e8 <pages>
ffffffffc0201a88:	4585                	li	a1,1
ffffffffc0201a8a:	9522                	add	a0,a0,s0
ffffffffc0201a8c:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201a90:	399000ef          	jal	ra,ffffffffc0202628 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201a94:	6442                	ld	s0,16(sp)
ffffffffc0201a96:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a98:	8526                	mv	a0,s1
}
ffffffffc0201a9a:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a9c:	45e1                	li	a1,24
}
ffffffffc0201a9e:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201aa0:	b171                	j	ffffffffc020172c <slob_free>
ffffffffc0201aa2:	e20d                	bnez	a2,ffffffffc0201ac4 <kfree+0xb6>
ffffffffc0201aa4:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201aa8:	6442                	ld	s0,16(sp)
ffffffffc0201aaa:	60e2                	ld	ra,24(sp)
ffffffffc0201aac:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201aae:	4581                	li	a1,0
}
ffffffffc0201ab0:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ab2:	b9ad                	j	ffffffffc020172c <slob_free>
        intr_disable();
ffffffffc0201ab4:	f01fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201ab8:	000c5797          	auipc	a5,0xc5
ffffffffc0201abc:	6107b783          	ld	a5,1552(a5) # ffffffffc02c70c8 <bigblocks>
        return 1;
ffffffffc0201ac0:	4605                	li	a2,1
ffffffffc0201ac2:	fbad                	bnez	a5,ffffffffc0201a34 <kfree+0x26>
        intr_enable();
ffffffffc0201ac4:	eebfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201ac8:	bff1                	j	ffffffffc0201aa4 <kfree+0x96>
ffffffffc0201aca:	ee5fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201ace:	b751                	j	ffffffffc0201a52 <kfree+0x44>
ffffffffc0201ad0:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201ad2:	00005617          	auipc	a2,0x5
ffffffffc0201ad6:	cde60613          	addi	a2,a2,-802 # ffffffffc02067b0 <commands+0xba0>
ffffffffc0201ada:	06900593          	li	a1,105
ffffffffc0201ade:	00005517          	auipc	a0,0x5
ffffffffc0201ae2:	c2a50513          	addi	a0,a0,-982 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0201ae6:	f3cfe0ef          	jal	ra,ffffffffc0200222 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201aea:	86a2                	mv	a3,s0
ffffffffc0201aec:	00005617          	auipc	a2,0x5
ffffffffc0201af0:	c9c60613          	addi	a2,a2,-868 # ffffffffc0206788 <commands+0xb78>
ffffffffc0201af4:	07700593          	li	a1,119
ffffffffc0201af8:	00005517          	auipc	a0,0x5
ffffffffc0201afc:	c1050513          	addi	a0,a0,-1008 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0201b00:	f22fe0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0201b04 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201b04:	000c1797          	auipc	a5,0xc1
ffffffffc0201b08:	54c78793          	addi	a5,a5,1356 # ffffffffc02c3050 <free_area>
ffffffffc0201b0c:	e79c                	sd	a5,8(a5)
ffffffffc0201b0e:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201b10:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201b14:	8082                	ret

ffffffffc0201b16 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201b16:	000c1517          	auipc	a0,0xc1
ffffffffc0201b1a:	54a56503          	lwu	a0,1354(a0) # ffffffffc02c3060 <free_area+0x10>
ffffffffc0201b1e:	8082                	ret

ffffffffc0201b20 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201b20:	715d                	addi	sp,sp,-80
ffffffffc0201b22:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201b24:	000c1417          	auipc	s0,0xc1
ffffffffc0201b28:	52c40413          	addi	s0,s0,1324 # ffffffffc02c3050 <free_area>
ffffffffc0201b2c:	641c                	ld	a5,8(s0)
ffffffffc0201b2e:	e486                	sd	ra,72(sp)
ffffffffc0201b30:	fc26                	sd	s1,56(sp)
ffffffffc0201b32:	f84a                	sd	s2,48(sp)
ffffffffc0201b34:	f44e                	sd	s3,40(sp)
ffffffffc0201b36:	f052                	sd	s4,32(sp)
ffffffffc0201b38:	ec56                	sd	s5,24(sp)
ffffffffc0201b3a:	e85a                	sd	s6,16(sp)
ffffffffc0201b3c:	e45e                	sd	s7,8(sp)
ffffffffc0201b3e:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201b40:	2a878d63          	beq	a5,s0,ffffffffc0201dfa <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0201b44:	4481                	li	s1,0
ffffffffc0201b46:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201b48:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201b4c:	8b09                	andi	a4,a4,2
ffffffffc0201b4e:	2a070a63          	beqz	a4,ffffffffc0201e02 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201b52:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b56:	679c                	ld	a5,8(a5)
ffffffffc0201b58:	2905                	addiw	s2,s2,1
ffffffffc0201b5a:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201b5c:	fe8796e3          	bne	a5,s0,ffffffffc0201b48 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201b60:	89a6                	mv	s3,s1
ffffffffc0201b62:	307000ef          	jal	ra,ffffffffc0202668 <nr_free_pages>
ffffffffc0201b66:	6f351e63          	bne	a0,s3,ffffffffc0202262 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201b6a:	4505                	li	a0,1
ffffffffc0201b6c:	27f000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201b70:	8aaa                	mv	s5,a0
ffffffffc0201b72:	42050863          	beqz	a0,ffffffffc0201fa2 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201b76:	4505                	li	a0,1
ffffffffc0201b78:	273000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201b7c:	89aa                	mv	s3,a0
ffffffffc0201b7e:	70050263          	beqz	a0,ffffffffc0202282 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201b82:	4505                	li	a0,1
ffffffffc0201b84:	267000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201b88:	8a2a                	mv	s4,a0
ffffffffc0201b8a:	48050c63          	beqz	a0,ffffffffc0202022 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201b8e:	293a8a63          	beq	s5,s3,ffffffffc0201e22 <default_check+0x302>
ffffffffc0201b92:	28aa8863          	beq	s5,a0,ffffffffc0201e22 <default_check+0x302>
ffffffffc0201b96:	28a98663          	beq	s3,a0,ffffffffc0201e22 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201b9a:	000aa783          	lw	a5,0(s5)
ffffffffc0201b9e:	2a079263          	bnez	a5,ffffffffc0201e42 <default_check+0x322>
ffffffffc0201ba2:	0009a783          	lw	a5,0(s3)
ffffffffc0201ba6:	28079e63          	bnez	a5,ffffffffc0201e42 <default_check+0x322>
ffffffffc0201baa:	411c                	lw	a5,0(a0)
ffffffffc0201bac:	28079b63          	bnez	a5,ffffffffc0201e42 <default_check+0x322>
    return page - pages + nbase;
ffffffffc0201bb0:	000c5797          	auipc	a5,0xc5
ffffffffc0201bb4:	5387b783          	ld	a5,1336(a5) # ffffffffc02c70e8 <pages>
ffffffffc0201bb8:	40fa8733          	sub	a4,s5,a5
ffffffffc0201bbc:	00006617          	auipc	a2,0x6
ffffffffc0201bc0:	71463603          	ld	a2,1812(a2) # ffffffffc02082d0 <nbase>
ffffffffc0201bc4:	8719                	srai	a4,a4,0x6
ffffffffc0201bc6:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201bc8:	000c5697          	auipc	a3,0xc5
ffffffffc0201bcc:	5186b683          	ld	a3,1304(a3) # ffffffffc02c70e0 <npage>
ffffffffc0201bd0:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bd2:	0732                	slli	a4,a4,0xc
ffffffffc0201bd4:	28d77763          	bgeu	a4,a3,ffffffffc0201e62 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0201bd8:	40f98733          	sub	a4,s3,a5
ffffffffc0201bdc:	8719                	srai	a4,a4,0x6
ffffffffc0201bde:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201be0:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201be2:	4cd77063          	bgeu	a4,a3,ffffffffc02020a2 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201be6:	40f507b3          	sub	a5,a0,a5
ffffffffc0201bea:	8799                	srai	a5,a5,0x6
ffffffffc0201bec:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bee:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201bf0:	30d7f963          	bgeu	a5,a3,ffffffffc0201f02 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201bf4:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201bf6:	00043c03          	ld	s8,0(s0)
ffffffffc0201bfa:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201bfe:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201c02:	e400                	sd	s0,8(s0)
ffffffffc0201c04:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201c06:	000c1797          	auipc	a5,0xc1
ffffffffc0201c0a:	4407ad23          	sw	zero,1114(a5) # ffffffffc02c3060 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201c0e:	1dd000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c12:	2c051863          	bnez	a0,ffffffffc0201ee2 <default_check+0x3c2>
    free_page(p0);
ffffffffc0201c16:	4585                	li	a1,1
ffffffffc0201c18:	8556                	mv	a0,s5
ffffffffc0201c1a:	20f000ef          	jal	ra,ffffffffc0202628 <free_pages>
    free_page(p1);
ffffffffc0201c1e:	4585                	li	a1,1
ffffffffc0201c20:	854e                	mv	a0,s3
ffffffffc0201c22:	207000ef          	jal	ra,ffffffffc0202628 <free_pages>
    free_page(p2);
ffffffffc0201c26:	4585                	li	a1,1
ffffffffc0201c28:	8552                	mv	a0,s4
ffffffffc0201c2a:	1ff000ef          	jal	ra,ffffffffc0202628 <free_pages>
    assert(nr_free == 3);
ffffffffc0201c2e:	4818                	lw	a4,16(s0)
ffffffffc0201c30:	478d                	li	a5,3
ffffffffc0201c32:	28f71863          	bne	a4,a5,ffffffffc0201ec2 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201c36:	4505                	li	a0,1
ffffffffc0201c38:	1b3000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c3c:	89aa                	mv	s3,a0
ffffffffc0201c3e:	26050263          	beqz	a0,ffffffffc0201ea2 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201c42:	4505                	li	a0,1
ffffffffc0201c44:	1a7000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c48:	8aaa                	mv	s5,a0
ffffffffc0201c4a:	3a050c63          	beqz	a0,ffffffffc0202002 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201c4e:	4505                	li	a0,1
ffffffffc0201c50:	19b000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c54:	8a2a                	mv	s4,a0
ffffffffc0201c56:	38050663          	beqz	a0,ffffffffc0201fe2 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201c5a:	4505                	li	a0,1
ffffffffc0201c5c:	18f000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c60:	36051163          	bnez	a0,ffffffffc0201fc2 <default_check+0x4a2>
    free_page(p0);
ffffffffc0201c64:	4585                	li	a1,1
ffffffffc0201c66:	854e                	mv	a0,s3
ffffffffc0201c68:	1c1000ef          	jal	ra,ffffffffc0202628 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201c6c:	641c                	ld	a5,8(s0)
ffffffffc0201c6e:	20878a63          	beq	a5,s0,ffffffffc0201e82 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201c72:	4505                	li	a0,1
ffffffffc0201c74:	177000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c78:	30a99563          	bne	s3,a0,ffffffffc0201f82 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201c7c:	4505                	li	a0,1
ffffffffc0201c7e:	16d000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201c82:	2e051063          	bnez	a0,ffffffffc0201f62 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201c86:	481c                	lw	a5,16(s0)
ffffffffc0201c88:	2a079d63          	bnez	a5,ffffffffc0201f42 <default_check+0x422>
    free_page(p);
ffffffffc0201c8c:	854e                	mv	a0,s3
ffffffffc0201c8e:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201c90:	01843023          	sd	s8,0(s0)
ffffffffc0201c94:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201c98:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201c9c:	18d000ef          	jal	ra,ffffffffc0202628 <free_pages>
    free_page(p1);
ffffffffc0201ca0:	4585                	li	a1,1
ffffffffc0201ca2:	8556                	mv	a0,s5
ffffffffc0201ca4:	185000ef          	jal	ra,ffffffffc0202628 <free_pages>
    free_page(p2);
ffffffffc0201ca8:	4585                	li	a1,1
ffffffffc0201caa:	8552                	mv	a0,s4
ffffffffc0201cac:	17d000ef          	jal	ra,ffffffffc0202628 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201cb0:	4515                	li	a0,5
ffffffffc0201cb2:	139000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201cb6:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201cb8:	26050563          	beqz	a0,ffffffffc0201f22 <default_check+0x402>
ffffffffc0201cbc:	651c                	ld	a5,8(a0)
ffffffffc0201cbe:	8385                	srli	a5,a5,0x1
ffffffffc0201cc0:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201cc2:	54079063          	bnez	a5,ffffffffc0202202 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201cc6:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201cc8:	00043b03          	ld	s6,0(s0)
ffffffffc0201ccc:	00843a83          	ld	s5,8(s0)
ffffffffc0201cd0:	e000                	sd	s0,0(s0)
ffffffffc0201cd2:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201cd4:	117000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201cd8:	50051563          	bnez	a0,ffffffffc02021e2 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201cdc:	08098a13          	addi	s4,s3,128
ffffffffc0201ce0:	8552                	mv	a0,s4
ffffffffc0201ce2:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201ce4:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201ce8:	000c1797          	auipc	a5,0xc1
ffffffffc0201cec:	3607ac23          	sw	zero,888(a5) # ffffffffc02c3060 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201cf0:	139000ef          	jal	ra,ffffffffc0202628 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201cf4:	4511                	li	a0,4
ffffffffc0201cf6:	0f5000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201cfa:	4c051463          	bnez	a0,ffffffffc02021c2 <default_check+0x6a2>
ffffffffc0201cfe:	0889b783          	ld	a5,136(s3)
ffffffffc0201d02:	8385                	srli	a5,a5,0x1
ffffffffc0201d04:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201d06:	48078e63          	beqz	a5,ffffffffc02021a2 <default_check+0x682>
ffffffffc0201d0a:	0909a703          	lw	a4,144(s3)
ffffffffc0201d0e:	478d                	li	a5,3
ffffffffc0201d10:	48f71963          	bne	a4,a5,ffffffffc02021a2 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201d14:	450d                	li	a0,3
ffffffffc0201d16:	0d5000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201d1a:	8c2a                	mv	s8,a0
ffffffffc0201d1c:	46050363          	beqz	a0,ffffffffc0202182 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201d20:	4505                	li	a0,1
ffffffffc0201d22:	0c9000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201d26:	42051e63          	bnez	a0,ffffffffc0202162 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201d2a:	418a1c63          	bne	s4,s8,ffffffffc0202142 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201d2e:	4585                	li	a1,1
ffffffffc0201d30:	854e                	mv	a0,s3
ffffffffc0201d32:	0f7000ef          	jal	ra,ffffffffc0202628 <free_pages>
    free_pages(p1, 3);
ffffffffc0201d36:	458d                	li	a1,3
ffffffffc0201d38:	8552                	mv	a0,s4
ffffffffc0201d3a:	0ef000ef          	jal	ra,ffffffffc0202628 <free_pages>
ffffffffc0201d3e:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201d42:	04098c13          	addi	s8,s3,64
ffffffffc0201d46:	8385                	srli	a5,a5,0x1
ffffffffc0201d48:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201d4a:	3c078c63          	beqz	a5,ffffffffc0202122 <default_check+0x602>
ffffffffc0201d4e:	0109a703          	lw	a4,16(s3)
ffffffffc0201d52:	4785                	li	a5,1
ffffffffc0201d54:	3cf71763          	bne	a4,a5,ffffffffc0202122 <default_check+0x602>
ffffffffc0201d58:	008a3783          	ld	a5,8(s4) # 1008 <_binary_obj___user_faultread_out_size-0x8f90>
ffffffffc0201d5c:	8385                	srli	a5,a5,0x1
ffffffffc0201d5e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201d60:	3a078163          	beqz	a5,ffffffffc0202102 <default_check+0x5e2>
ffffffffc0201d64:	010a2703          	lw	a4,16(s4)
ffffffffc0201d68:	478d                	li	a5,3
ffffffffc0201d6a:	38f71c63          	bne	a4,a5,ffffffffc0202102 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201d6e:	4505                	li	a0,1
ffffffffc0201d70:	07b000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201d74:	36a99763          	bne	s3,a0,ffffffffc02020e2 <default_check+0x5c2>
    free_page(p0);
ffffffffc0201d78:	4585                	li	a1,1
ffffffffc0201d7a:	0af000ef          	jal	ra,ffffffffc0202628 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201d7e:	4509                	li	a0,2
ffffffffc0201d80:	06b000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201d84:	32aa1f63          	bne	s4,a0,ffffffffc02020c2 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201d88:	4589                	li	a1,2
ffffffffc0201d8a:	09f000ef          	jal	ra,ffffffffc0202628 <free_pages>
    free_page(p2);
ffffffffc0201d8e:	4585                	li	a1,1
ffffffffc0201d90:	8562                	mv	a0,s8
ffffffffc0201d92:	097000ef          	jal	ra,ffffffffc0202628 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201d96:	4515                	li	a0,5
ffffffffc0201d98:	053000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201d9c:	89aa                	mv	s3,a0
ffffffffc0201d9e:	48050263          	beqz	a0,ffffffffc0202222 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201da2:	4505                	li	a0,1
ffffffffc0201da4:	047000ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0201da8:	2c051d63          	bnez	a0,ffffffffc0202082 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201dac:	481c                	lw	a5,16(s0)
ffffffffc0201dae:	2a079a63          	bnez	a5,ffffffffc0202062 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201db2:	4595                	li	a1,5
ffffffffc0201db4:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201db6:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201dba:	01643023          	sd	s6,0(s0)
ffffffffc0201dbe:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201dc2:	067000ef          	jal	ra,ffffffffc0202628 <free_pages>
    return listelm->next;
ffffffffc0201dc6:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201dc8:	00878963          	beq	a5,s0,ffffffffc0201dda <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201dcc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201dd0:	679c                	ld	a5,8(a5)
ffffffffc0201dd2:	397d                	addiw	s2,s2,-1
ffffffffc0201dd4:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201dd6:	fe879be3          	bne	a5,s0,ffffffffc0201dcc <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201dda:	26091463          	bnez	s2,ffffffffc0202042 <default_check+0x522>
    assert(total == 0);
ffffffffc0201dde:	46049263          	bnez	s1,ffffffffc0202242 <default_check+0x722>
}
ffffffffc0201de2:	60a6                	ld	ra,72(sp)
ffffffffc0201de4:	6406                	ld	s0,64(sp)
ffffffffc0201de6:	74e2                	ld	s1,56(sp)
ffffffffc0201de8:	7942                	ld	s2,48(sp)
ffffffffc0201dea:	79a2                	ld	s3,40(sp)
ffffffffc0201dec:	7a02                	ld	s4,32(sp)
ffffffffc0201dee:	6ae2                	ld	s5,24(sp)
ffffffffc0201df0:	6b42                	ld	s6,16(sp)
ffffffffc0201df2:	6ba2                	ld	s7,8(sp)
ffffffffc0201df4:	6c02                	ld	s8,0(sp)
ffffffffc0201df6:	6161                	addi	sp,sp,80
ffffffffc0201df8:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201dfa:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201dfc:	4481                	li	s1,0
ffffffffc0201dfe:	4901                	li	s2,0
ffffffffc0201e00:	b38d                	j	ffffffffc0201b62 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201e02:	00005697          	auipc	a3,0x5
ffffffffc0201e06:	9ce68693          	addi	a3,a3,-1586 # ffffffffc02067d0 <commands+0xbc0>
ffffffffc0201e0a:	00004617          	auipc	a2,0x4
ffffffffc0201e0e:	65e60613          	addi	a2,a2,1630 # ffffffffc0206468 <commands+0x858>
ffffffffc0201e12:	11000593          	li	a1,272
ffffffffc0201e16:	00005517          	auipc	a0,0x5
ffffffffc0201e1a:	9ca50513          	addi	a0,a0,-1590 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201e1e:	c04fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201e22:	00005697          	auipc	a3,0x5
ffffffffc0201e26:	a5668693          	addi	a3,a3,-1450 # ffffffffc0206878 <commands+0xc68>
ffffffffc0201e2a:	00004617          	auipc	a2,0x4
ffffffffc0201e2e:	63e60613          	addi	a2,a2,1598 # ffffffffc0206468 <commands+0x858>
ffffffffc0201e32:	0db00593          	li	a1,219
ffffffffc0201e36:	00005517          	auipc	a0,0x5
ffffffffc0201e3a:	9aa50513          	addi	a0,a0,-1622 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201e3e:	be4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201e42:	00005697          	auipc	a3,0x5
ffffffffc0201e46:	a5e68693          	addi	a3,a3,-1442 # ffffffffc02068a0 <commands+0xc90>
ffffffffc0201e4a:	00004617          	auipc	a2,0x4
ffffffffc0201e4e:	61e60613          	addi	a2,a2,1566 # ffffffffc0206468 <commands+0x858>
ffffffffc0201e52:	0dc00593          	li	a1,220
ffffffffc0201e56:	00005517          	auipc	a0,0x5
ffffffffc0201e5a:	98a50513          	addi	a0,a0,-1654 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201e5e:	bc4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201e62:	00005697          	auipc	a3,0x5
ffffffffc0201e66:	a7e68693          	addi	a3,a3,-1410 # ffffffffc02068e0 <commands+0xcd0>
ffffffffc0201e6a:	00004617          	auipc	a2,0x4
ffffffffc0201e6e:	5fe60613          	addi	a2,a2,1534 # ffffffffc0206468 <commands+0x858>
ffffffffc0201e72:	0de00593          	li	a1,222
ffffffffc0201e76:	00005517          	auipc	a0,0x5
ffffffffc0201e7a:	96a50513          	addi	a0,a0,-1686 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201e7e:	ba4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201e82:	00005697          	auipc	a3,0x5
ffffffffc0201e86:	ae668693          	addi	a3,a3,-1306 # ffffffffc0206968 <commands+0xd58>
ffffffffc0201e8a:	00004617          	auipc	a2,0x4
ffffffffc0201e8e:	5de60613          	addi	a2,a2,1502 # ffffffffc0206468 <commands+0x858>
ffffffffc0201e92:	0f700593          	li	a1,247
ffffffffc0201e96:	00005517          	auipc	a0,0x5
ffffffffc0201e9a:	94a50513          	addi	a0,a0,-1718 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201e9e:	b84fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201ea2:	00005697          	auipc	a3,0x5
ffffffffc0201ea6:	97668693          	addi	a3,a3,-1674 # ffffffffc0206818 <commands+0xc08>
ffffffffc0201eaa:	00004617          	auipc	a2,0x4
ffffffffc0201eae:	5be60613          	addi	a2,a2,1470 # ffffffffc0206468 <commands+0x858>
ffffffffc0201eb2:	0f000593          	li	a1,240
ffffffffc0201eb6:	00005517          	auipc	a0,0x5
ffffffffc0201eba:	92a50513          	addi	a0,a0,-1750 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201ebe:	b64fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free == 3);
ffffffffc0201ec2:	00005697          	auipc	a3,0x5
ffffffffc0201ec6:	a9668693          	addi	a3,a3,-1386 # ffffffffc0206958 <commands+0xd48>
ffffffffc0201eca:	00004617          	auipc	a2,0x4
ffffffffc0201ece:	59e60613          	addi	a2,a2,1438 # ffffffffc0206468 <commands+0x858>
ffffffffc0201ed2:	0ee00593          	li	a1,238
ffffffffc0201ed6:	00005517          	auipc	a0,0x5
ffffffffc0201eda:	90a50513          	addi	a0,a0,-1782 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201ede:	b44fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201ee2:	00005697          	auipc	a3,0x5
ffffffffc0201ee6:	a5e68693          	addi	a3,a3,-1442 # ffffffffc0206940 <commands+0xd30>
ffffffffc0201eea:	00004617          	auipc	a2,0x4
ffffffffc0201eee:	57e60613          	addi	a2,a2,1406 # ffffffffc0206468 <commands+0x858>
ffffffffc0201ef2:	0e900593          	li	a1,233
ffffffffc0201ef6:	00005517          	auipc	a0,0x5
ffffffffc0201efa:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201efe:	b24fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201f02:	00005697          	auipc	a3,0x5
ffffffffc0201f06:	a1e68693          	addi	a3,a3,-1506 # ffffffffc0206920 <commands+0xd10>
ffffffffc0201f0a:	00004617          	auipc	a2,0x4
ffffffffc0201f0e:	55e60613          	addi	a2,a2,1374 # ffffffffc0206468 <commands+0x858>
ffffffffc0201f12:	0e000593          	li	a1,224
ffffffffc0201f16:	00005517          	auipc	a0,0x5
ffffffffc0201f1a:	8ca50513          	addi	a0,a0,-1846 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201f1e:	b04fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(p0 != NULL);
ffffffffc0201f22:	00005697          	auipc	a3,0x5
ffffffffc0201f26:	a8e68693          	addi	a3,a3,-1394 # ffffffffc02069b0 <commands+0xda0>
ffffffffc0201f2a:	00004617          	auipc	a2,0x4
ffffffffc0201f2e:	53e60613          	addi	a2,a2,1342 # ffffffffc0206468 <commands+0x858>
ffffffffc0201f32:	11800593          	li	a1,280
ffffffffc0201f36:	00005517          	auipc	a0,0x5
ffffffffc0201f3a:	8aa50513          	addi	a0,a0,-1878 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201f3e:	ae4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free == 0);
ffffffffc0201f42:	00005697          	auipc	a3,0x5
ffffffffc0201f46:	a5e68693          	addi	a3,a3,-1442 # ffffffffc02069a0 <commands+0xd90>
ffffffffc0201f4a:	00004617          	auipc	a2,0x4
ffffffffc0201f4e:	51e60613          	addi	a2,a2,1310 # ffffffffc0206468 <commands+0x858>
ffffffffc0201f52:	0fd00593          	li	a1,253
ffffffffc0201f56:	00005517          	auipc	a0,0x5
ffffffffc0201f5a:	88a50513          	addi	a0,a0,-1910 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201f5e:	ac4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201f62:	00005697          	auipc	a3,0x5
ffffffffc0201f66:	9de68693          	addi	a3,a3,-1570 # ffffffffc0206940 <commands+0xd30>
ffffffffc0201f6a:	00004617          	auipc	a2,0x4
ffffffffc0201f6e:	4fe60613          	addi	a2,a2,1278 # ffffffffc0206468 <commands+0x858>
ffffffffc0201f72:	0fb00593          	li	a1,251
ffffffffc0201f76:	00005517          	auipc	a0,0x5
ffffffffc0201f7a:	86a50513          	addi	a0,a0,-1942 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201f7e:	aa4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201f82:	00005697          	auipc	a3,0x5
ffffffffc0201f86:	9fe68693          	addi	a3,a3,-1538 # ffffffffc0206980 <commands+0xd70>
ffffffffc0201f8a:	00004617          	auipc	a2,0x4
ffffffffc0201f8e:	4de60613          	addi	a2,a2,1246 # ffffffffc0206468 <commands+0x858>
ffffffffc0201f92:	0fa00593          	li	a1,250
ffffffffc0201f96:	00005517          	auipc	a0,0x5
ffffffffc0201f9a:	84a50513          	addi	a0,a0,-1974 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201f9e:	a84fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201fa2:	00005697          	auipc	a3,0x5
ffffffffc0201fa6:	87668693          	addi	a3,a3,-1930 # ffffffffc0206818 <commands+0xc08>
ffffffffc0201faa:	00004617          	auipc	a2,0x4
ffffffffc0201fae:	4be60613          	addi	a2,a2,1214 # ffffffffc0206468 <commands+0x858>
ffffffffc0201fb2:	0d700593          	li	a1,215
ffffffffc0201fb6:	00005517          	auipc	a0,0x5
ffffffffc0201fba:	82a50513          	addi	a0,a0,-2006 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201fbe:	a64fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201fc2:	00005697          	auipc	a3,0x5
ffffffffc0201fc6:	97e68693          	addi	a3,a3,-1666 # ffffffffc0206940 <commands+0xd30>
ffffffffc0201fca:	00004617          	auipc	a2,0x4
ffffffffc0201fce:	49e60613          	addi	a2,a2,1182 # ffffffffc0206468 <commands+0x858>
ffffffffc0201fd2:	0f400593          	li	a1,244
ffffffffc0201fd6:	00005517          	auipc	a0,0x5
ffffffffc0201fda:	80a50513          	addi	a0,a0,-2038 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201fde:	a44fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201fe2:	00005697          	auipc	a3,0x5
ffffffffc0201fe6:	87668693          	addi	a3,a3,-1930 # ffffffffc0206858 <commands+0xc48>
ffffffffc0201fea:	00004617          	auipc	a2,0x4
ffffffffc0201fee:	47e60613          	addi	a2,a2,1150 # ffffffffc0206468 <commands+0x858>
ffffffffc0201ff2:	0f200593          	li	a1,242
ffffffffc0201ff6:	00004517          	auipc	a0,0x4
ffffffffc0201ffa:	7ea50513          	addi	a0,a0,2026 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc0201ffe:	a24fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202002:	00005697          	auipc	a3,0x5
ffffffffc0202006:	83668693          	addi	a3,a3,-1994 # ffffffffc0206838 <commands+0xc28>
ffffffffc020200a:	00004617          	auipc	a2,0x4
ffffffffc020200e:	45e60613          	addi	a2,a2,1118 # ffffffffc0206468 <commands+0x858>
ffffffffc0202012:	0f100593          	li	a1,241
ffffffffc0202016:	00004517          	auipc	a0,0x4
ffffffffc020201a:	7ca50513          	addi	a0,a0,1994 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020201e:	a04fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202022:	00005697          	auipc	a3,0x5
ffffffffc0202026:	83668693          	addi	a3,a3,-1994 # ffffffffc0206858 <commands+0xc48>
ffffffffc020202a:	00004617          	auipc	a2,0x4
ffffffffc020202e:	43e60613          	addi	a2,a2,1086 # ffffffffc0206468 <commands+0x858>
ffffffffc0202032:	0d900593          	li	a1,217
ffffffffc0202036:	00004517          	auipc	a0,0x4
ffffffffc020203a:	7aa50513          	addi	a0,a0,1962 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020203e:	9e4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(count == 0);
ffffffffc0202042:	00005697          	auipc	a3,0x5
ffffffffc0202046:	abe68693          	addi	a3,a3,-1346 # ffffffffc0206b00 <commands+0xef0>
ffffffffc020204a:	00004617          	auipc	a2,0x4
ffffffffc020204e:	41e60613          	addi	a2,a2,1054 # ffffffffc0206468 <commands+0x858>
ffffffffc0202052:	14600593          	li	a1,326
ffffffffc0202056:	00004517          	auipc	a0,0x4
ffffffffc020205a:	78a50513          	addi	a0,a0,1930 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020205e:	9c4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free == 0);
ffffffffc0202062:	00005697          	auipc	a3,0x5
ffffffffc0202066:	93e68693          	addi	a3,a3,-1730 # ffffffffc02069a0 <commands+0xd90>
ffffffffc020206a:	00004617          	auipc	a2,0x4
ffffffffc020206e:	3fe60613          	addi	a2,a2,1022 # ffffffffc0206468 <commands+0x858>
ffffffffc0202072:	13a00593          	li	a1,314
ffffffffc0202076:	00004517          	auipc	a0,0x4
ffffffffc020207a:	76a50513          	addi	a0,a0,1898 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020207e:	9a4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202082:	00005697          	auipc	a3,0x5
ffffffffc0202086:	8be68693          	addi	a3,a3,-1858 # ffffffffc0206940 <commands+0xd30>
ffffffffc020208a:	00004617          	auipc	a2,0x4
ffffffffc020208e:	3de60613          	addi	a2,a2,990 # ffffffffc0206468 <commands+0x858>
ffffffffc0202092:	13800593          	li	a1,312
ffffffffc0202096:	00004517          	auipc	a0,0x4
ffffffffc020209a:	74a50513          	addi	a0,a0,1866 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020209e:	984fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02020a2:	00005697          	auipc	a3,0x5
ffffffffc02020a6:	85e68693          	addi	a3,a3,-1954 # ffffffffc0206900 <commands+0xcf0>
ffffffffc02020aa:	00004617          	auipc	a2,0x4
ffffffffc02020ae:	3be60613          	addi	a2,a2,958 # ffffffffc0206468 <commands+0x858>
ffffffffc02020b2:	0df00593          	li	a1,223
ffffffffc02020b6:	00004517          	auipc	a0,0x4
ffffffffc02020ba:	72a50513          	addi	a0,a0,1834 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02020be:	964fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02020c2:	00005697          	auipc	a3,0x5
ffffffffc02020c6:	9fe68693          	addi	a3,a3,-1538 # ffffffffc0206ac0 <commands+0xeb0>
ffffffffc02020ca:	00004617          	auipc	a2,0x4
ffffffffc02020ce:	39e60613          	addi	a2,a2,926 # ffffffffc0206468 <commands+0x858>
ffffffffc02020d2:	13200593          	li	a1,306
ffffffffc02020d6:	00004517          	auipc	a0,0x4
ffffffffc02020da:	70a50513          	addi	a0,a0,1802 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02020de:	944fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02020e2:	00005697          	auipc	a3,0x5
ffffffffc02020e6:	9be68693          	addi	a3,a3,-1602 # ffffffffc0206aa0 <commands+0xe90>
ffffffffc02020ea:	00004617          	auipc	a2,0x4
ffffffffc02020ee:	37e60613          	addi	a2,a2,894 # ffffffffc0206468 <commands+0x858>
ffffffffc02020f2:	13000593          	li	a1,304
ffffffffc02020f6:	00004517          	auipc	a0,0x4
ffffffffc02020fa:	6ea50513          	addi	a0,a0,1770 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02020fe:	924fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0202102:	00005697          	auipc	a3,0x5
ffffffffc0202106:	97668693          	addi	a3,a3,-1674 # ffffffffc0206a78 <commands+0xe68>
ffffffffc020210a:	00004617          	auipc	a2,0x4
ffffffffc020210e:	35e60613          	addi	a2,a2,862 # ffffffffc0206468 <commands+0x858>
ffffffffc0202112:	12e00593          	li	a1,302
ffffffffc0202116:	00004517          	auipc	a0,0x4
ffffffffc020211a:	6ca50513          	addi	a0,a0,1738 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020211e:	904fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0202122:	00005697          	auipc	a3,0x5
ffffffffc0202126:	92e68693          	addi	a3,a3,-1746 # ffffffffc0206a50 <commands+0xe40>
ffffffffc020212a:	00004617          	auipc	a2,0x4
ffffffffc020212e:	33e60613          	addi	a2,a2,830 # ffffffffc0206468 <commands+0x858>
ffffffffc0202132:	12d00593          	li	a1,301
ffffffffc0202136:	00004517          	auipc	a0,0x4
ffffffffc020213a:	6aa50513          	addi	a0,a0,1706 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020213e:	8e4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0202142:	00005697          	auipc	a3,0x5
ffffffffc0202146:	8fe68693          	addi	a3,a3,-1794 # ffffffffc0206a40 <commands+0xe30>
ffffffffc020214a:	00004617          	auipc	a2,0x4
ffffffffc020214e:	31e60613          	addi	a2,a2,798 # ffffffffc0206468 <commands+0x858>
ffffffffc0202152:	12800593          	li	a1,296
ffffffffc0202156:	00004517          	auipc	a0,0x4
ffffffffc020215a:	68a50513          	addi	a0,a0,1674 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020215e:	8c4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202162:	00004697          	auipc	a3,0x4
ffffffffc0202166:	7de68693          	addi	a3,a3,2014 # ffffffffc0206940 <commands+0xd30>
ffffffffc020216a:	00004617          	auipc	a2,0x4
ffffffffc020216e:	2fe60613          	addi	a2,a2,766 # ffffffffc0206468 <commands+0x858>
ffffffffc0202172:	12700593          	li	a1,295
ffffffffc0202176:	00004517          	auipc	a0,0x4
ffffffffc020217a:	66a50513          	addi	a0,a0,1642 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020217e:	8a4fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0202182:	00005697          	auipc	a3,0x5
ffffffffc0202186:	89e68693          	addi	a3,a3,-1890 # ffffffffc0206a20 <commands+0xe10>
ffffffffc020218a:	00004617          	auipc	a2,0x4
ffffffffc020218e:	2de60613          	addi	a2,a2,734 # ffffffffc0206468 <commands+0x858>
ffffffffc0202192:	12600593          	li	a1,294
ffffffffc0202196:	00004517          	auipc	a0,0x4
ffffffffc020219a:	64a50513          	addi	a0,a0,1610 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020219e:	884fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02021a2:	00005697          	auipc	a3,0x5
ffffffffc02021a6:	84e68693          	addi	a3,a3,-1970 # ffffffffc02069f0 <commands+0xde0>
ffffffffc02021aa:	00004617          	auipc	a2,0x4
ffffffffc02021ae:	2be60613          	addi	a2,a2,702 # ffffffffc0206468 <commands+0x858>
ffffffffc02021b2:	12500593          	li	a1,293
ffffffffc02021b6:	00004517          	auipc	a0,0x4
ffffffffc02021ba:	62a50513          	addi	a0,a0,1578 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02021be:	864fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02021c2:	00005697          	auipc	a3,0x5
ffffffffc02021c6:	81668693          	addi	a3,a3,-2026 # ffffffffc02069d8 <commands+0xdc8>
ffffffffc02021ca:	00004617          	auipc	a2,0x4
ffffffffc02021ce:	29e60613          	addi	a2,a2,670 # ffffffffc0206468 <commands+0x858>
ffffffffc02021d2:	12400593          	li	a1,292
ffffffffc02021d6:	00004517          	auipc	a0,0x4
ffffffffc02021da:	60a50513          	addi	a0,a0,1546 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02021de:	844fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02021e2:	00004697          	auipc	a3,0x4
ffffffffc02021e6:	75e68693          	addi	a3,a3,1886 # ffffffffc0206940 <commands+0xd30>
ffffffffc02021ea:	00004617          	auipc	a2,0x4
ffffffffc02021ee:	27e60613          	addi	a2,a2,638 # ffffffffc0206468 <commands+0x858>
ffffffffc02021f2:	11e00593          	li	a1,286
ffffffffc02021f6:	00004517          	auipc	a0,0x4
ffffffffc02021fa:	5ea50513          	addi	a0,a0,1514 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02021fe:	824fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(!PageProperty(p0));
ffffffffc0202202:	00004697          	auipc	a3,0x4
ffffffffc0202206:	7be68693          	addi	a3,a3,1982 # ffffffffc02069c0 <commands+0xdb0>
ffffffffc020220a:	00004617          	auipc	a2,0x4
ffffffffc020220e:	25e60613          	addi	a2,a2,606 # ffffffffc0206468 <commands+0x858>
ffffffffc0202212:	11900593          	li	a1,281
ffffffffc0202216:	00004517          	auipc	a0,0x4
ffffffffc020221a:	5ca50513          	addi	a0,a0,1482 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020221e:	804fe0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0202222:	00005697          	auipc	a3,0x5
ffffffffc0202226:	8be68693          	addi	a3,a3,-1858 # ffffffffc0206ae0 <commands+0xed0>
ffffffffc020222a:	00004617          	auipc	a2,0x4
ffffffffc020222e:	23e60613          	addi	a2,a2,574 # ffffffffc0206468 <commands+0x858>
ffffffffc0202232:	13700593          	li	a1,311
ffffffffc0202236:	00004517          	auipc	a0,0x4
ffffffffc020223a:	5aa50513          	addi	a0,a0,1450 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020223e:	fe5fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(total == 0);
ffffffffc0202242:	00005697          	auipc	a3,0x5
ffffffffc0202246:	8ce68693          	addi	a3,a3,-1842 # ffffffffc0206b10 <commands+0xf00>
ffffffffc020224a:	00004617          	auipc	a2,0x4
ffffffffc020224e:	21e60613          	addi	a2,a2,542 # ffffffffc0206468 <commands+0x858>
ffffffffc0202252:	14700593          	li	a1,327
ffffffffc0202256:	00004517          	auipc	a0,0x4
ffffffffc020225a:	58a50513          	addi	a0,a0,1418 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020225e:	fc5fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(total == nr_free_pages());
ffffffffc0202262:	00004697          	auipc	a3,0x4
ffffffffc0202266:	59668693          	addi	a3,a3,1430 # ffffffffc02067f8 <commands+0xbe8>
ffffffffc020226a:	00004617          	auipc	a2,0x4
ffffffffc020226e:	1fe60613          	addi	a2,a2,510 # ffffffffc0206468 <commands+0x858>
ffffffffc0202272:	11300593          	li	a1,275
ffffffffc0202276:	00004517          	auipc	a0,0x4
ffffffffc020227a:	56a50513          	addi	a0,a0,1386 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020227e:	fa5fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202282:	00004697          	auipc	a3,0x4
ffffffffc0202286:	5b668693          	addi	a3,a3,1462 # ffffffffc0206838 <commands+0xc28>
ffffffffc020228a:	00004617          	auipc	a2,0x4
ffffffffc020228e:	1de60613          	addi	a2,a2,478 # ffffffffc0206468 <commands+0x858>
ffffffffc0202292:	0d800593          	li	a1,216
ffffffffc0202296:	00004517          	auipc	a0,0x4
ffffffffc020229a:	54a50513          	addi	a0,a0,1354 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020229e:	f85fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02022a2 <default_free_pages>:
{
ffffffffc02022a2:	1141                	addi	sp,sp,-16
ffffffffc02022a4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02022a6:	14058463          	beqz	a1,ffffffffc02023ee <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc02022aa:	00659693          	slli	a3,a1,0x6
ffffffffc02022ae:	96aa                	add	a3,a3,a0
ffffffffc02022b0:	87aa                	mv	a5,a0
ffffffffc02022b2:	02d50263          	beq	a0,a3,ffffffffc02022d6 <default_free_pages+0x34>
ffffffffc02022b6:	6798                	ld	a4,8(a5)
ffffffffc02022b8:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02022ba:	10071a63          	bnez	a4,ffffffffc02023ce <default_free_pages+0x12c>
ffffffffc02022be:	6798                	ld	a4,8(a5)
ffffffffc02022c0:	8b09                	andi	a4,a4,2
ffffffffc02022c2:	10071663          	bnez	a4,ffffffffc02023ce <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02022c6:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02022ca:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02022ce:	04078793          	addi	a5,a5,64
ffffffffc02022d2:	fed792e3          	bne	a5,a3,ffffffffc02022b6 <default_free_pages+0x14>
    base->property = n;
ffffffffc02022d6:	2581                	sext.w	a1,a1
ffffffffc02022d8:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02022da:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02022de:	4789                	li	a5,2
ffffffffc02022e0:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02022e4:	000c1697          	auipc	a3,0xc1
ffffffffc02022e8:	d6c68693          	addi	a3,a3,-660 # ffffffffc02c3050 <free_area>
ffffffffc02022ec:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02022ee:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02022f0:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02022f4:	9db9                	addw	a1,a1,a4
ffffffffc02022f6:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02022f8:	0ad78463          	beq	a5,a3,ffffffffc02023a0 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02022fc:	fe878713          	addi	a4,a5,-24
ffffffffc0202300:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0202304:	4581                	li	a1,0
            if (base < page)
ffffffffc0202306:	00e56a63          	bltu	a0,a4,ffffffffc020231a <default_free_pages+0x78>
    return listelm->next;
ffffffffc020230a:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020230c:	04d70c63          	beq	a4,a3,ffffffffc0202364 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0202310:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0202312:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0202316:	fee57ae3          	bgeu	a0,a4,ffffffffc020230a <default_free_pages+0x68>
ffffffffc020231a:	c199                	beqz	a1,ffffffffc0202320 <default_free_pages+0x7e>
ffffffffc020231c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202320:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0202322:	e390                	sd	a2,0(a5)
ffffffffc0202324:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202326:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202328:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc020232a:	00d70d63          	beq	a4,a3,ffffffffc0202344 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc020232e:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_obj___user_faultread_out_size-0x8fa0>
        p = le2page(le, page_link);
ffffffffc0202332:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0202336:	02059813          	slli	a6,a1,0x20
ffffffffc020233a:	01a85793          	srli	a5,a6,0x1a
ffffffffc020233e:	97b2                	add	a5,a5,a2
ffffffffc0202340:	02f50c63          	beq	a0,a5,ffffffffc0202378 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0202344:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0202346:	00d78c63          	beq	a5,a3,ffffffffc020235e <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020234a:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020234c:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0202350:	02061593          	slli	a1,a2,0x20
ffffffffc0202354:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0202358:	972a                	add	a4,a4,a0
ffffffffc020235a:	04e68a63          	beq	a3,a4,ffffffffc02023ae <default_free_pages+0x10c>
}
ffffffffc020235e:	60a2                	ld	ra,8(sp)
ffffffffc0202360:	0141                	addi	sp,sp,16
ffffffffc0202362:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202364:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202366:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0202368:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020236a:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc020236c:	02d70763          	beq	a4,a3,ffffffffc020239a <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0202370:	8832                	mv	a6,a2
ffffffffc0202372:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0202374:	87ba                	mv	a5,a4
ffffffffc0202376:	bf71                	j	ffffffffc0202312 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0202378:	491c                	lw	a5,16(a0)
ffffffffc020237a:	9dbd                	addw	a1,a1,a5
ffffffffc020237c:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202380:	57f5                	li	a5,-3
ffffffffc0202382:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202386:	01853803          	ld	a6,24(a0)
ffffffffc020238a:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020238c:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc020238e:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0202392:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0202394:	0105b023          	sd	a6,0(a1) # 1000 <_binary_obj___user_faultread_out_size-0x8f98>
ffffffffc0202398:	b77d                	j	ffffffffc0202346 <default_free_pages+0xa4>
ffffffffc020239a:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc020239c:	873e                	mv	a4,a5
ffffffffc020239e:	bf41                	j	ffffffffc020232e <default_free_pages+0x8c>
}
ffffffffc02023a0:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02023a2:	e390                	sd	a2,0(a5)
ffffffffc02023a4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02023a6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02023a8:	ed1c                	sd	a5,24(a0)
ffffffffc02023aa:	0141                	addi	sp,sp,16
ffffffffc02023ac:	8082                	ret
            base->property += p->property;
ffffffffc02023ae:	ff87a703          	lw	a4,-8(a5)
ffffffffc02023b2:	ff078693          	addi	a3,a5,-16
ffffffffc02023b6:	9e39                	addw	a2,a2,a4
ffffffffc02023b8:	c910                	sw	a2,16(a0)
ffffffffc02023ba:	5775                	li	a4,-3
ffffffffc02023bc:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02023c0:	6398                	ld	a4,0(a5)
ffffffffc02023c2:	679c                	ld	a5,8(a5)
}
ffffffffc02023c4:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02023c6:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02023c8:	e398                	sd	a4,0(a5)
ffffffffc02023ca:	0141                	addi	sp,sp,16
ffffffffc02023cc:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02023ce:	00004697          	auipc	a3,0x4
ffffffffc02023d2:	75a68693          	addi	a3,a3,1882 # ffffffffc0206b28 <commands+0xf18>
ffffffffc02023d6:	00004617          	auipc	a2,0x4
ffffffffc02023da:	09260613          	addi	a2,a2,146 # ffffffffc0206468 <commands+0x858>
ffffffffc02023de:	09400593          	li	a1,148
ffffffffc02023e2:	00004517          	auipc	a0,0x4
ffffffffc02023e6:	3fe50513          	addi	a0,a0,1022 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02023ea:	e39fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(n > 0);
ffffffffc02023ee:	00004697          	auipc	a3,0x4
ffffffffc02023f2:	73268693          	addi	a3,a3,1842 # ffffffffc0206b20 <commands+0xf10>
ffffffffc02023f6:	00004617          	auipc	a2,0x4
ffffffffc02023fa:	07260613          	addi	a2,a2,114 # ffffffffc0206468 <commands+0x858>
ffffffffc02023fe:	09000593          	li	a1,144
ffffffffc0202402:	00004517          	auipc	a0,0x4
ffffffffc0202406:	3de50513          	addi	a0,a0,990 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020240a:	e19fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020240e <default_alloc_pages>:
    assert(n > 0);
ffffffffc020240e:	c941                	beqz	a0,ffffffffc020249e <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0202410:	000c1597          	auipc	a1,0xc1
ffffffffc0202414:	c4058593          	addi	a1,a1,-960 # ffffffffc02c3050 <free_area>
ffffffffc0202418:	0105a803          	lw	a6,16(a1)
ffffffffc020241c:	872a                	mv	a4,a0
ffffffffc020241e:	02081793          	slli	a5,a6,0x20
ffffffffc0202422:	9381                	srli	a5,a5,0x20
ffffffffc0202424:	00a7ee63          	bltu	a5,a0,ffffffffc0202440 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0202428:	87ae                	mv	a5,a1
ffffffffc020242a:	a801                	j	ffffffffc020243a <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc020242c:	ff87a683          	lw	a3,-8(a5)
ffffffffc0202430:	02069613          	slli	a2,a3,0x20
ffffffffc0202434:	9201                	srli	a2,a2,0x20
ffffffffc0202436:	00e67763          	bgeu	a2,a4,ffffffffc0202444 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc020243a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc020243c:	feb798e3          	bne	a5,a1,ffffffffc020242c <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0202440:	4501                	li	a0,0
}
ffffffffc0202442:	8082                	ret
    return listelm->prev;
ffffffffc0202444:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202448:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc020244c:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0202450:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0202454:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0202458:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc020245c:	02c77863          	bgeu	a4,a2,ffffffffc020248c <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0202460:	071a                	slli	a4,a4,0x6
ffffffffc0202462:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0202464:	41c686bb          	subw	a3,a3,t3
ffffffffc0202468:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020246a:	00870613          	addi	a2,a4,8
ffffffffc020246e:	4689                	li	a3,2
ffffffffc0202470:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202474:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0202478:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc020247c:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0202480:	e290                	sd	a2,0(a3)
ffffffffc0202482:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0202486:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0202488:	01173c23          	sd	a7,24(a4)
ffffffffc020248c:	41c8083b          	subw	a6,a6,t3
ffffffffc0202490:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202494:	5775                	li	a4,-3
ffffffffc0202496:	17c1                	addi	a5,a5,-16
ffffffffc0202498:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020249c:	8082                	ret
{
ffffffffc020249e:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02024a0:	00004697          	auipc	a3,0x4
ffffffffc02024a4:	68068693          	addi	a3,a3,1664 # ffffffffc0206b20 <commands+0xf10>
ffffffffc02024a8:	00004617          	auipc	a2,0x4
ffffffffc02024ac:	fc060613          	addi	a2,a2,-64 # ffffffffc0206468 <commands+0x858>
ffffffffc02024b0:	06c00593          	li	a1,108
ffffffffc02024b4:	00004517          	auipc	a0,0x4
ffffffffc02024b8:	32c50513          	addi	a0,a0,812 # ffffffffc02067e0 <commands+0xbd0>
{
ffffffffc02024bc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02024be:	d65fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02024c2 <default_init_memmap>:
{
ffffffffc02024c2:	1141                	addi	sp,sp,-16
ffffffffc02024c4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02024c6:	c5f1                	beqz	a1,ffffffffc0202592 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02024c8:	00659693          	slli	a3,a1,0x6
ffffffffc02024cc:	96aa                	add	a3,a3,a0
ffffffffc02024ce:	87aa                	mv	a5,a0
ffffffffc02024d0:	00d50f63          	beq	a0,a3,ffffffffc02024ee <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02024d4:	6798                	ld	a4,8(a5)
ffffffffc02024d6:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02024d8:	cf49                	beqz	a4,ffffffffc0202572 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02024da:	0007a823          	sw	zero,16(a5)
ffffffffc02024de:	0007b423          	sd	zero,8(a5)
ffffffffc02024e2:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02024e6:	04078793          	addi	a5,a5,64
ffffffffc02024ea:	fed795e3          	bne	a5,a3,ffffffffc02024d4 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02024ee:	2581                	sext.w	a1,a1
ffffffffc02024f0:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02024f2:	4789                	li	a5,2
ffffffffc02024f4:	00850713          	addi	a4,a0,8
ffffffffc02024f8:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02024fc:	000c1697          	auipc	a3,0xc1
ffffffffc0202500:	b5468693          	addi	a3,a3,-1196 # ffffffffc02c3050 <free_area>
ffffffffc0202504:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0202506:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0202508:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020250c:	9db9                	addw	a1,a1,a4
ffffffffc020250e:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0202510:	04d78a63          	beq	a5,a3,ffffffffc0202564 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0202514:	fe878713          	addi	a4,a5,-24
ffffffffc0202518:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc020251c:	4581                	li	a1,0
            if (base < page)
ffffffffc020251e:	00e56a63          	bltu	a0,a4,ffffffffc0202532 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0202522:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0202524:	02d70263          	beq	a4,a3,ffffffffc0202548 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0202528:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc020252a:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc020252e:	fee57ae3          	bgeu	a0,a4,ffffffffc0202522 <default_init_memmap+0x60>
ffffffffc0202532:	c199                	beqz	a1,ffffffffc0202538 <default_init_memmap+0x76>
ffffffffc0202534:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202538:	6398                	ld	a4,0(a5)
}
ffffffffc020253a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020253c:	e390                	sd	a2,0(a5)
ffffffffc020253e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202540:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202542:	ed18                	sd	a4,24(a0)
ffffffffc0202544:	0141                	addi	sp,sp,16
ffffffffc0202546:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202548:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020254a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020254c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020254e:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0202550:	00d70663          	beq	a4,a3,ffffffffc020255c <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0202554:	8832                	mv	a6,a2
ffffffffc0202556:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0202558:	87ba                	mv	a5,a4
ffffffffc020255a:	bfc1                	j	ffffffffc020252a <default_init_memmap+0x68>
}
ffffffffc020255c:	60a2                	ld	ra,8(sp)
ffffffffc020255e:	e290                	sd	a2,0(a3)
ffffffffc0202560:	0141                	addi	sp,sp,16
ffffffffc0202562:	8082                	ret
ffffffffc0202564:	60a2                	ld	ra,8(sp)
ffffffffc0202566:	e390                	sd	a2,0(a5)
ffffffffc0202568:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020256a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020256c:	ed1c                	sd	a5,24(a0)
ffffffffc020256e:	0141                	addi	sp,sp,16
ffffffffc0202570:	8082                	ret
        assert(PageReserved(p));
ffffffffc0202572:	00004697          	auipc	a3,0x4
ffffffffc0202576:	5de68693          	addi	a3,a3,1502 # ffffffffc0206b50 <commands+0xf40>
ffffffffc020257a:	00004617          	auipc	a2,0x4
ffffffffc020257e:	eee60613          	addi	a2,a2,-274 # ffffffffc0206468 <commands+0x858>
ffffffffc0202582:	04b00593          	li	a1,75
ffffffffc0202586:	00004517          	auipc	a0,0x4
ffffffffc020258a:	25a50513          	addi	a0,a0,602 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc020258e:	c95fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(n > 0);
ffffffffc0202592:	00004697          	auipc	a3,0x4
ffffffffc0202596:	58e68693          	addi	a3,a3,1422 # ffffffffc0206b20 <commands+0xf10>
ffffffffc020259a:	00004617          	auipc	a2,0x4
ffffffffc020259e:	ece60613          	addi	a2,a2,-306 # ffffffffc0206468 <commands+0x858>
ffffffffc02025a2:	04700593          	li	a1,71
ffffffffc02025a6:	00004517          	auipc	a0,0x4
ffffffffc02025aa:	23a50513          	addi	a0,a0,570 # ffffffffc02067e0 <commands+0xbd0>
ffffffffc02025ae:	c75fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02025b2 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc02025b2:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02025b4:	00004617          	auipc	a2,0x4
ffffffffc02025b8:	1fc60613          	addi	a2,a2,508 # ffffffffc02067b0 <commands+0xba0>
ffffffffc02025bc:	06900593          	li	a1,105
ffffffffc02025c0:	00004517          	auipc	a0,0x4
ffffffffc02025c4:	14850513          	addi	a0,a0,328 # ffffffffc0206708 <commands+0xaf8>
pa2page(uintptr_t pa)
ffffffffc02025c8:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc02025ca:	c59fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02025ce <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc02025ce:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc02025d0:	00004617          	auipc	a2,0x4
ffffffffc02025d4:	5e060613          	addi	a2,a2,1504 # ffffffffc0206bb0 <default_pmm_manager+0x38>
ffffffffc02025d8:	07f00593          	li	a1,127
ffffffffc02025dc:	00004517          	auipc	a0,0x4
ffffffffc02025e0:	12c50513          	addi	a0,a0,300 # ffffffffc0206708 <commands+0xaf8>
pte2page(pte_t pte)
ffffffffc02025e4:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc02025e6:	c3dfd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02025ea <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02025ea:	100027f3          	csrr	a5,sstatus
ffffffffc02025ee:	8b89                	andi	a5,a5,2
ffffffffc02025f0:	e799                	bnez	a5,ffffffffc02025fe <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02025f2:	000c5797          	auipc	a5,0xc5
ffffffffc02025f6:	afe7b783          	ld	a5,-1282(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc02025fa:	6f9c                	ld	a5,24(a5)
ffffffffc02025fc:	8782                	jr	a5
{
ffffffffc02025fe:	1141                	addi	sp,sp,-16
ffffffffc0202600:	e406                	sd	ra,8(sp)
ffffffffc0202602:	e022                	sd	s0,0(sp)
ffffffffc0202604:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0202606:	baefe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020260a:	000c5797          	auipc	a5,0xc5
ffffffffc020260e:	ae67b783          	ld	a5,-1306(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202612:	6f9c                	ld	a5,24(a5)
ffffffffc0202614:	8522                	mv	a0,s0
ffffffffc0202616:	9782                	jalr	a5
ffffffffc0202618:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020261a:	b94fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020261e:	60a2                	ld	ra,8(sp)
ffffffffc0202620:	8522                	mv	a0,s0
ffffffffc0202622:	6402                	ld	s0,0(sp)
ffffffffc0202624:	0141                	addi	sp,sp,16
ffffffffc0202626:	8082                	ret

ffffffffc0202628 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202628:	100027f3          	csrr	a5,sstatus
ffffffffc020262c:	8b89                	andi	a5,a5,2
ffffffffc020262e:	e799                	bnez	a5,ffffffffc020263c <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0202630:	000c5797          	auipc	a5,0xc5
ffffffffc0202634:	ac07b783          	ld	a5,-1344(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202638:	739c                	ld	a5,32(a5)
ffffffffc020263a:	8782                	jr	a5
{
ffffffffc020263c:	1101                	addi	sp,sp,-32
ffffffffc020263e:	ec06                	sd	ra,24(sp)
ffffffffc0202640:	e822                	sd	s0,16(sp)
ffffffffc0202642:	e426                	sd	s1,8(sp)
ffffffffc0202644:	842a                	mv	s0,a0
ffffffffc0202646:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202648:	b6cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020264c:	000c5797          	auipc	a5,0xc5
ffffffffc0202650:	aa47b783          	ld	a5,-1372(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202654:	739c                	ld	a5,32(a5)
ffffffffc0202656:	85a6                	mv	a1,s1
ffffffffc0202658:	8522                	mv	a0,s0
ffffffffc020265a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc020265c:	6442                	ld	s0,16(sp)
ffffffffc020265e:	60e2                	ld	ra,24(sp)
ffffffffc0202660:	64a2                	ld	s1,8(sp)
ffffffffc0202662:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202664:	b4afe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0202668 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202668:	100027f3          	csrr	a5,sstatus
ffffffffc020266c:	8b89                	andi	a5,a5,2
ffffffffc020266e:	e799                	bnez	a5,ffffffffc020267c <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0202670:	000c5797          	auipc	a5,0xc5
ffffffffc0202674:	a807b783          	ld	a5,-1408(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202678:	779c                	ld	a5,40(a5)
ffffffffc020267a:	8782                	jr	a5
{
ffffffffc020267c:	1141                	addi	sp,sp,-16
ffffffffc020267e:	e406                	sd	ra,8(sp)
ffffffffc0202680:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202682:	b32fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202686:	000c5797          	auipc	a5,0xc5
ffffffffc020268a:	a6a7b783          	ld	a5,-1430(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc020268e:	779c                	ld	a5,40(a5)
ffffffffc0202690:	9782                	jalr	a5
ffffffffc0202692:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202694:	b1afe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202698:	60a2                	ld	ra,8(sp)
ffffffffc020269a:	8522                	mv	a0,s0
ffffffffc020269c:	6402                	ld	s0,0(sp)
ffffffffc020269e:	0141                	addi	sp,sp,16
ffffffffc02026a0:	8082                	ret

ffffffffc02026a2 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02026a2:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02026a6:	1ff7f793          	andi	a5,a5,511
{
ffffffffc02026aa:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02026ac:	078e                	slli	a5,a5,0x3
{
ffffffffc02026ae:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02026b0:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc02026b4:	6094                	ld	a3,0(s1)
{
ffffffffc02026b6:	f04a                	sd	s2,32(sp)
ffffffffc02026b8:	ec4e                	sd	s3,24(sp)
ffffffffc02026ba:	e852                	sd	s4,16(sp)
ffffffffc02026bc:	fc06                	sd	ra,56(sp)
ffffffffc02026be:	f822                	sd	s0,48(sp)
ffffffffc02026c0:	e456                	sd	s5,8(sp)
ffffffffc02026c2:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc02026c4:	0016f793          	andi	a5,a3,1
{
ffffffffc02026c8:	892e                	mv	s2,a1
ffffffffc02026ca:	8a32                	mv	s4,a2
ffffffffc02026cc:	000c5997          	auipc	s3,0xc5
ffffffffc02026d0:	a1498993          	addi	s3,s3,-1516 # ffffffffc02c70e0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc02026d4:	efbd                	bnez	a5,ffffffffc0202752 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02026d6:	14060c63          	beqz	a2,ffffffffc020282e <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026da:	100027f3          	csrr	a5,sstatus
ffffffffc02026de:	8b89                	andi	a5,a5,2
ffffffffc02026e0:	14079963          	bnez	a5,ffffffffc0202832 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc02026e4:	000c5797          	auipc	a5,0xc5
ffffffffc02026e8:	a0c7b783          	ld	a5,-1524(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc02026ec:	6f9c                	ld	a5,24(a5)
ffffffffc02026ee:	4505                	li	a0,1
ffffffffc02026f0:	9782                	jalr	a5
ffffffffc02026f2:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02026f4:	12040d63          	beqz	s0,ffffffffc020282e <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02026f8:	000c5b17          	auipc	s6,0xc5
ffffffffc02026fc:	9f0b0b13          	addi	s6,s6,-1552 # ffffffffc02c70e8 <pages>
ffffffffc0202700:	000b3503          	ld	a0,0(s6)
ffffffffc0202704:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202708:	000c5997          	auipc	s3,0xc5
ffffffffc020270c:	9d898993          	addi	s3,s3,-1576 # ffffffffc02c70e0 <npage>
ffffffffc0202710:	40a40533          	sub	a0,s0,a0
ffffffffc0202714:	8519                	srai	a0,a0,0x6
ffffffffc0202716:	9556                	add	a0,a0,s5
ffffffffc0202718:	0009b703          	ld	a4,0(s3)
ffffffffc020271c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202720:	4685                	li	a3,1
ffffffffc0202722:	c014                	sw	a3,0(s0)
ffffffffc0202724:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202726:	0532                	slli	a0,a0,0xc
ffffffffc0202728:	16e7f763          	bgeu	a5,a4,ffffffffc0202896 <get_pte+0x1f4>
ffffffffc020272c:	000c5797          	auipc	a5,0xc5
ffffffffc0202730:	9cc7b783          	ld	a5,-1588(a5) # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0202734:	6605                	lui	a2,0x1
ffffffffc0202736:	4581                	li	a1,0
ffffffffc0202738:	953e                	add	a0,a0,a5
ffffffffc020273a:	5fd020ef          	jal	ra,ffffffffc0205536 <memset>
    return page - pages + nbase;
ffffffffc020273e:	000b3683          	ld	a3,0(s6)
ffffffffc0202742:	40d406b3          	sub	a3,s0,a3
ffffffffc0202746:	8699                	srai	a3,a3,0x6
ffffffffc0202748:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020274a:	06aa                	slli	a3,a3,0xa
ffffffffc020274c:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202750:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202752:	77fd                	lui	a5,0xfffff
ffffffffc0202754:	068a                	slli	a3,a3,0x2
ffffffffc0202756:	0009b703          	ld	a4,0(s3)
ffffffffc020275a:	8efd                	and	a3,a3,a5
ffffffffc020275c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202760:	10e7ff63          	bgeu	a5,a4,ffffffffc020287e <get_pte+0x1dc>
ffffffffc0202764:	000c5a97          	auipc	s5,0xc5
ffffffffc0202768:	994a8a93          	addi	s5,s5,-1644 # ffffffffc02c70f8 <va_pa_offset>
ffffffffc020276c:	000ab403          	ld	s0,0(s5)
ffffffffc0202770:	01595793          	srli	a5,s2,0x15
ffffffffc0202774:	1ff7f793          	andi	a5,a5,511
ffffffffc0202778:	96a2                	add	a3,a3,s0
ffffffffc020277a:	00379413          	slli	s0,a5,0x3
ffffffffc020277e:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202780:	6014                	ld	a3,0(s0)
ffffffffc0202782:	0016f793          	andi	a5,a3,1
ffffffffc0202786:	ebad                	bnez	a5,ffffffffc02027f8 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202788:	0a0a0363          	beqz	s4,ffffffffc020282e <get_pte+0x18c>
ffffffffc020278c:	100027f3          	csrr	a5,sstatus
ffffffffc0202790:	8b89                	andi	a5,a5,2
ffffffffc0202792:	efcd                	bnez	a5,ffffffffc020284c <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202794:	000c5797          	auipc	a5,0xc5
ffffffffc0202798:	95c7b783          	ld	a5,-1700(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc020279c:	6f9c                	ld	a5,24(a5)
ffffffffc020279e:	4505                	li	a0,1
ffffffffc02027a0:	9782                	jalr	a5
ffffffffc02027a2:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02027a4:	c4c9                	beqz	s1,ffffffffc020282e <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02027a6:	000c5b17          	auipc	s6,0xc5
ffffffffc02027aa:	942b0b13          	addi	s6,s6,-1726 # ffffffffc02c70e8 <pages>
ffffffffc02027ae:	000b3503          	ld	a0,0(s6)
ffffffffc02027b2:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02027b6:	0009b703          	ld	a4,0(s3)
ffffffffc02027ba:	40a48533          	sub	a0,s1,a0
ffffffffc02027be:	8519                	srai	a0,a0,0x6
ffffffffc02027c0:	9552                	add	a0,a0,s4
ffffffffc02027c2:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02027c6:	4685                	li	a3,1
ffffffffc02027c8:	c094                	sw	a3,0(s1)
ffffffffc02027ca:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02027cc:	0532                	slli	a0,a0,0xc
ffffffffc02027ce:	0ee7f163          	bgeu	a5,a4,ffffffffc02028b0 <get_pte+0x20e>
ffffffffc02027d2:	000ab783          	ld	a5,0(s5)
ffffffffc02027d6:	6605                	lui	a2,0x1
ffffffffc02027d8:	4581                	li	a1,0
ffffffffc02027da:	953e                	add	a0,a0,a5
ffffffffc02027dc:	55b020ef          	jal	ra,ffffffffc0205536 <memset>
    return page - pages + nbase;
ffffffffc02027e0:	000b3683          	ld	a3,0(s6)
ffffffffc02027e4:	40d486b3          	sub	a3,s1,a3
ffffffffc02027e8:	8699                	srai	a3,a3,0x6
ffffffffc02027ea:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02027ec:	06aa                	slli	a3,a3,0xa
ffffffffc02027ee:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02027f2:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02027f4:	0009b703          	ld	a4,0(s3)
ffffffffc02027f8:	068a                	slli	a3,a3,0x2
ffffffffc02027fa:	757d                	lui	a0,0xfffff
ffffffffc02027fc:	8ee9                	and	a3,a3,a0
ffffffffc02027fe:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202802:	06e7f263          	bgeu	a5,a4,ffffffffc0202866 <get_pte+0x1c4>
ffffffffc0202806:	000ab503          	ld	a0,0(s5)
ffffffffc020280a:	00c95913          	srli	s2,s2,0xc
ffffffffc020280e:	1ff97913          	andi	s2,s2,511
ffffffffc0202812:	96aa                	add	a3,a3,a0
ffffffffc0202814:	00391513          	slli	a0,s2,0x3
ffffffffc0202818:	9536                	add	a0,a0,a3
}
ffffffffc020281a:	70e2                	ld	ra,56(sp)
ffffffffc020281c:	7442                	ld	s0,48(sp)
ffffffffc020281e:	74a2                	ld	s1,40(sp)
ffffffffc0202820:	7902                	ld	s2,32(sp)
ffffffffc0202822:	69e2                	ld	s3,24(sp)
ffffffffc0202824:	6a42                	ld	s4,16(sp)
ffffffffc0202826:	6aa2                	ld	s5,8(sp)
ffffffffc0202828:	6b02                	ld	s6,0(sp)
ffffffffc020282a:	6121                	addi	sp,sp,64
ffffffffc020282c:	8082                	ret
            return NULL;
ffffffffc020282e:	4501                	li	a0,0
ffffffffc0202830:	b7ed                	j	ffffffffc020281a <get_pte+0x178>
        intr_disable();
ffffffffc0202832:	982fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202836:	000c5797          	auipc	a5,0xc5
ffffffffc020283a:	8ba7b783          	ld	a5,-1862(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc020283e:	6f9c                	ld	a5,24(a5)
ffffffffc0202840:	4505                	li	a0,1
ffffffffc0202842:	9782                	jalr	a5
ffffffffc0202844:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202846:	968fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020284a:	b56d                	j	ffffffffc02026f4 <get_pte+0x52>
        intr_disable();
ffffffffc020284c:	968fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202850:	000c5797          	auipc	a5,0xc5
ffffffffc0202854:	8a07b783          	ld	a5,-1888(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202858:	6f9c                	ld	a5,24(a5)
ffffffffc020285a:	4505                	li	a0,1
ffffffffc020285c:	9782                	jalr	a5
ffffffffc020285e:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0202860:	94efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202864:	b781                	j	ffffffffc02027a4 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202866:	00004617          	auipc	a2,0x4
ffffffffc020286a:	e7a60613          	addi	a2,a2,-390 # ffffffffc02066e0 <commands+0xad0>
ffffffffc020286e:	0fa00593          	li	a1,250
ffffffffc0202872:	00004517          	auipc	a0,0x4
ffffffffc0202876:	36650513          	addi	a0,a0,870 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020287a:	9a9fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020287e:	00004617          	auipc	a2,0x4
ffffffffc0202882:	e6260613          	addi	a2,a2,-414 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0202886:	0ed00593          	li	a1,237
ffffffffc020288a:	00004517          	auipc	a0,0x4
ffffffffc020288e:	34e50513          	addi	a0,a0,846 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0202892:	991fd0ef          	jal	ra,ffffffffc0200222 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202896:	86aa                	mv	a3,a0
ffffffffc0202898:	00004617          	auipc	a2,0x4
ffffffffc020289c:	e4860613          	addi	a2,a2,-440 # ffffffffc02066e0 <commands+0xad0>
ffffffffc02028a0:	0e900593          	li	a1,233
ffffffffc02028a4:	00004517          	auipc	a0,0x4
ffffffffc02028a8:	33450513          	addi	a0,a0,820 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02028ac:	977fd0ef          	jal	ra,ffffffffc0200222 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02028b0:	86aa                	mv	a3,a0
ffffffffc02028b2:	00004617          	auipc	a2,0x4
ffffffffc02028b6:	e2e60613          	addi	a2,a2,-466 # ffffffffc02066e0 <commands+0xad0>
ffffffffc02028ba:	0f700593          	li	a1,247
ffffffffc02028be:	00004517          	auipc	a0,0x4
ffffffffc02028c2:	31a50513          	addi	a0,a0,794 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02028c6:	95dfd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02028ca <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02028ca:	1141                	addi	sp,sp,-16
ffffffffc02028cc:	e022                	sd	s0,0(sp)
ffffffffc02028ce:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02028d0:	4601                	li	a2,0
{
ffffffffc02028d2:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02028d4:	dcfff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
    if (ptep_store != NULL)
ffffffffc02028d8:	c011                	beqz	s0,ffffffffc02028dc <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02028da:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02028dc:	c511                	beqz	a0,ffffffffc02028e8 <get_page+0x1e>
ffffffffc02028de:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02028e0:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02028e2:	0017f713          	andi	a4,a5,1
ffffffffc02028e6:	e709                	bnez	a4,ffffffffc02028f0 <get_page+0x26>
}
ffffffffc02028e8:	60a2                	ld	ra,8(sp)
ffffffffc02028ea:	6402                	ld	s0,0(sp)
ffffffffc02028ec:	0141                	addi	sp,sp,16
ffffffffc02028ee:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02028f0:	078a                	slli	a5,a5,0x2
ffffffffc02028f2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02028f4:	000c4717          	auipc	a4,0xc4
ffffffffc02028f8:	7ec73703          	ld	a4,2028(a4) # ffffffffc02c70e0 <npage>
ffffffffc02028fc:	00e7ff63          	bgeu	a5,a4,ffffffffc020291a <get_page+0x50>
ffffffffc0202900:	60a2                	ld	ra,8(sp)
ffffffffc0202902:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0202904:	fff80537          	lui	a0,0xfff80
ffffffffc0202908:	97aa                	add	a5,a5,a0
ffffffffc020290a:	079a                	slli	a5,a5,0x6
ffffffffc020290c:	000c4517          	auipc	a0,0xc4
ffffffffc0202910:	7dc53503          	ld	a0,2012(a0) # ffffffffc02c70e8 <pages>
ffffffffc0202914:	953e                	add	a0,a0,a5
ffffffffc0202916:	0141                	addi	sp,sp,16
ffffffffc0202918:	8082                	ret
ffffffffc020291a:	c99ff0ef          	jal	ra,ffffffffc02025b2 <pa2page.part.0>

ffffffffc020291e <unmap_range>:
        tlb_invalidate(pgdir, la); //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc020291e:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202920:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202924:	f486                	sd	ra,104(sp)
ffffffffc0202926:	f0a2                	sd	s0,96(sp)
ffffffffc0202928:	eca6                	sd	s1,88(sp)
ffffffffc020292a:	e8ca                	sd	s2,80(sp)
ffffffffc020292c:	e4ce                	sd	s3,72(sp)
ffffffffc020292e:	e0d2                	sd	s4,64(sp)
ffffffffc0202930:	fc56                	sd	s5,56(sp)
ffffffffc0202932:	f85a                	sd	s6,48(sp)
ffffffffc0202934:	f45e                	sd	s7,40(sp)
ffffffffc0202936:	f062                	sd	s8,32(sp)
ffffffffc0202938:	ec66                	sd	s9,24(sp)
ffffffffc020293a:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020293c:	17d2                	slli	a5,a5,0x34
ffffffffc020293e:	e3ed                	bnez	a5,ffffffffc0202a20 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc0202940:	002007b7          	lui	a5,0x200
ffffffffc0202944:	842e                	mv	s0,a1
ffffffffc0202946:	0ef5ed63          	bltu	a1,a5,ffffffffc0202a40 <unmap_range+0x122>
ffffffffc020294a:	8932                	mv	s2,a2
ffffffffc020294c:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202a40 <unmap_range+0x122>
ffffffffc0202950:	4785                	li	a5,1
ffffffffc0202952:	07fe                	slli	a5,a5,0x1f
ffffffffc0202954:	0ec7e663          	bltu	a5,a2,ffffffffc0202a40 <unmap_range+0x122>
ffffffffc0202958:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc020295a:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020295c:	000c4c97          	auipc	s9,0xc4
ffffffffc0202960:	784c8c93          	addi	s9,s9,1924 # ffffffffc02c70e0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202964:	000c4c17          	auipc	s8,0xc4
ffffffffc0202968:	784c0c13          	addi	s8,s8,1924 # ffffffffc02c70e8 <pages>
ffffffffc020296c:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc0202970:	000c4d17          	auipc	s10,0xc4
ffffffffc0202974:	780d0d13          	addi	s10,s10,1920 # ffffffffc02c70f0 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202978:	00200b37          	lui	s6,0x200
ffffffffc020297c:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202980:	4601                	li	a2,0
ffffffffc0202982:	85a2                	mv	a1,s0
ffffffffc0202984:	854e                	mv	a0,s3
ffffffffc0202986:	d1dff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc020298a:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020298c:	cd29                	beqz	a0,ffffffffc02029e6 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020298e:	611c                	ld	a5,0(a0)
ffffffffc0202990:	e395                	bnez	a5,ffffffffc02029b4 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202992:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202994:	ff2466e3          	bltu	s0,s2,ffffffffc0202980 <unmap_range+0x62>
}
ffffffffc0202998:	70a6                	ld	ra,104(sp)
ffffffffc020299a:	7406                	ld	s0,96(sp)
ffffffffc020299c:	64e6                	ld	s1,88(sp)
ffffffffc020299e:	6946                	ld	s2,80(sp)
ffffffffc02029a0:	69a6                	ld	s3,72(sp)
ffffffffc02029a2:	6a06                	ld	s4,64(sp)
ffffffffc02029a4:	7ae2                	ld	s5,56(sp)
ffffffffc02029a6:	7b42                	ld	s6,48(sp)
ffffffffc02029a8:	7ba2                	ld	s7,40(sp)
ffffffffc02029aa:	7c02                	ld	s8,32(sp)
ffffffffc02029ac:	6ce2                	ld	s9,24(sp)
ffffffffc02029ae:	6d42                	ld	s10,16(sp)
ffffffffc02029b0:	6165                	addi	sp,sp,112
ffffffffc02029b2:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02029b4:	0017f713          	andi	a4,a5,1
ffffffffc02029b8:	df69                	beqz	a4,ffffffffc0202992 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc02029ba:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02029be:	078a                	slli	a5,a5,0x2
ffffffffc02029c0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029c2:	08e7ff63          	bgeu	a5,a4,ffffffffc0202a60 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc02029c6:	000c3503          	ld	a0,0(s8)
ffffffffc02029ca:	97de                	add	a5,a5,s7
ffffffffc02029cc:	079a                	slli	a5,a5,0x6
ffffffffc02029ce:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02029d0:	411c                	lw	a5,0(a0)
ffffffffc02029d2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02029d6:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02029d8:	cf11                	beqz	a4,ffffffffc02029f4 <unmap_range+0xd6>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc02029da:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02029de:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02029e2:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02029e4:	bf45                	j	ffffffffc0202994 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02029e6:	945a                	add	s0,s0,s6
ffffffffc02029e8:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02029ec:	d455                	beqz	s0,ffffffffc0202998 <unmap_range+0x7a>
ffffffffc02029ee:	f92469e3          	bltu	s0,s2,ffffffffc0202980 <unmap_range+0x62>
ffffffffc02029f2:	b75d                	j	ffffffffc0202998 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02029f4:	100027f3          	csrr	a5,sstatus
ffffffffc02029f8:	8b89                	andi	a5,a5,2
ffffffffc02029fa:	e799                	bnez	a5,ffffffffc0202a08 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02029fc:	000d3783          	ld	a5,0(s10)
ffffffffc0202a00:	4585                	li	a1,1
ffffffffc0202a02:	739c                	ld	a5,32(a5)
ffffffffc0202a04:	9782                	jalr	a5
    if (flag)
ffffffffc0202a06:	bfd1                	j	ffffffffc02029da <unmap_range+0xbc>
ffffffffc0202a08:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202a0a:	fabfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202a0e:	000d3783          	ld	a5,0(s10)
ffffffffc0202a12:	6522                	ld	a0,8(sp)
ffffffffc0202a14:	4585                	li	a1,1
ffffffffc0202a16:	739c                	ld	a5,32(a5)
ffffffffc0202a18:	9782                	jalr	a5
        intr_enable();
ffffffffc0202a1a:	f95fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202a1e:	bf75                	j	ffffffffc02029da <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202a20:	00004697          	auipc	a3,0x4
ffffffffc0202a24:	1c868693          	addi	a3,a3,456 # ffffffffc0206be8 <default_pmm_manager+0x70>
ffffffffc0202a28:	00004617          	auipc	a2,0x4
ffffffffc0202a2c:	a4060613          	addi	a2,a2,-1472 # ffffffffc0206468 <commands+0x858>
ffffffffc0202a30:	12200593          	li	a1,290
ffffffffc0202a34:	00004517          	auipc	a0,0x4
ffffffffc0202a38:	1a450513          	addi	a0,a0,420 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0202a3c:	fe6fd0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202a40:	00004697          	auipc	a3,0x4
ffffffffc0202a44:	1d868693          	addi	a3,a3,472 # ffffffffc0206c18 <default_pmm_manager+0xa0>
ffffffffc0202a48:	00004617          	auipc	a2,0x4
ffffffffc0202a4c:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206468 <commands+0x858>
ffffffffc0202a50:	12300593          	li	a1,291
ffffffffc0202a54:	00004517          	auipc	a0,0x4
ffffffffc0202a58:	18450513          	addi	a0,a0,388 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0202a5c:	fc6fd0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc0202a60:	b53ff0ef          	jal	ra,ffffffffc02025b2 <pa2page.part.0>

ffffffffc0202a64 <exit_range>:
{
ffffffffc0202a64:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202a66:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202a6a:	fc86                	sd	ra,120(sp)
ffffffffc0202a6c:	f8a2                	sd	s0,112(sp)
ffffffffc0202a6e:	f4a6                	sd	s1,104(sp)
ffffffffc0202a70:	f0ca                	sd	s2,96(sp)
ffffffffc0202a72:	ecce                	sd	s3,88(sp)
ffffffffc0202a74:	e8d2                	sd	s4,80(sp)
ffffffffc0202a76:	e4d6                	sd	s5,72(sp)
ffffffffc0202a78:	e0da                	sd	s6,64(sp)
ffffffffc0202a7a:	fc5e                	sd	s7,56(sp)
ffffffffc0202a7c:	f862                	sd	s8,48(sp)
ffffffffc0202a7e:	f466                	sd	s9,40(sp)
ffffffffc0202a80:	f06a                	sd	s10,32(sp)
ffffffffc0202a82:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202a84:	17d2                	slli	a5,a5,0x34
ffffffffc0202a86:	20079a63          	bnez	a5,ffffffffc0202c9a <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202a8a:	002007b7          	lui	a5,0x200
ffffffffc0202a8e:	24f5e463          	bltu	a1,a5,ffffffffc0202cd6 <exit_range+0x272>
ffffffffc0202a92:	8ab2                	mv	s5,a2
ffffffffc0202a94:	24c5f163          	bgeu	a1,a2,ffffffffc0202cd6 <exit_range+0x272>
ffffffffc0202a98:	4785                	li	a5,1
ffffffffc0202a9a:	07fe                	slli	a5,a5,0x1f
ffffffffc0202a9c:	22c7ed63          	bltu	a5,a2,ffffffffc0202cd6 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202aa0:	c00009b7          	lui	s3,0xc0000
ffffffffc0202aa4:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202aa8:	ffe00937          	lui	s2,0xffe00
ffffffffc0202aac:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202ab0:	5cfd                	li	s9,-1
ffffffffc0202ab2:	8c2a                	mv	s8,a0
ffffffffc0202ab4:	0125f933          	and	s2,a1,s2
ffffffffc0202ab8:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202aba:	000c4d17          	auipc	s10,0xc4
ffffffffc0202abe:	626d0d13          	addi	s10,s10,1574 # ffffffffc02c70e0 <npage>
    return KADDR(page2pa(page));
ffffffffc0202ac2:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202ac6:	000c4717          	auipc	a4,0xc4
ffffffffc0202aca:	62270713          	addi	a4,a4,1570 # ffffffffc02c70e8 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202ace:	000c4d97          	auipc	s11,0xc4
ffffffffc0202ad2:	622d8d93          	addi	s11,s11,1570 # ffffffffc02c70f0 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202ad6:	c0000437          	lui	s0,0xc0000
ffffffffc0202ada:	944e                	add	s0,s0,s3
ffffffffc0202adc:	8079                	srli	s0,s0,0x1e
ffffffffc0202ade:	1ff47413          	andi	s0,s0,511
ffffffffc0202ae2:	040e                	slli	s0,s0,0x3
ffffffffc0202ae4:	9462                	add	s0,s0,s8
ffffffffc0202ae6:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38a0>
        if (pde1 & PTE_V)
ffffffffc0202aea:	001a7793          	andi	a5,s4,1
ffffffffc0202aee:	eb99                	bnez	a5,ffffffffc0202b04 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc0202af0:	12098463          	beqz	s3,ffffffffc0202c18 <exit_range+0x1b4>
ffffffffc0202af4:	400007b7          	lui	a5,0x40000
ffffffffc0202af8:	97ce                	add	a5,a5,s3
ffffffffc0202afa:	894e                	mv	s2,s3
ffffffffc0202afc:	1159fe63          	bgeu	s3,s5,ffffffffc0202c18 <exit_range+0x1b4>
ffffffffc0202b00:	89be                	mv	s3,a5
ffffffffc0202b02:	bfd1                	j	ffffffffc0202ad6 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc0202b04:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b08:	0a0a                	slli	s4,s4,0x2
ffffffffc0202b0a:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b0e:	1cfa7263          	bgeu	s4,a5,ffffffffc0202cd2 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b12:	fff80637          	lui	a2,0xfff80
ffffffffc0202b16:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202b18:	000806b7          	lui	a3,0x80
ffffffffc0202b1c:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202b1e:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202b22:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b24:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b26:	18f5fa63          	bgeu	a1,a5,ffffffffc0202cba <exit_range+0x256>
ffffffffc0202b2a:	000c4817          	auipc	a6,0xc4
ffffffffc0202b2e:	5ce80813          	addi	a6,a6,1486 # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0202b32:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202b36:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202b38:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202b3c:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202b3e:	00080337          	lui	t1,0x80
ffffffffc0202b42:	6885                	lui	a7,0x1
ffffffffc0202b44:	a819                	j	ffffffffc0202b5a <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202b46:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202b48:	002007b7          	lui	a5,0x200
ffffffffc0202b4c:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202b4e:	08090c63          	beqz	s2,ffffffffc0202be6 <exit_range+0x182>
ffffffffc0202b52:	09397a63          	bgeu	s2,s3,ffffffffc0202be6 <exit_range+0x182>
ffffffffc0202b56:	0f597063          	bgeu	s2,s5,ffffffffc0202c36 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202b5a:	01595493          	srli	s1,s2,0x15
ffffffffc0202b5e:	1ff4f493          	andi	s1,s1,511
ffffffffc0202b62:	048e                	slli	s1,s1,0x3
ffffffffc0202b64:	94da                	add	s1,s1,s6
ffffffffc0202b66:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202b68:	0017f693          	andi	a3,a5,1
ffffffffc0202b6c:	dee9                	beqz	a3,ffffffffc0202b46 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202b6e:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b72:	078a                	slli	a5,a5,0x2
ffffffffc0202b74:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b76:	14b7fe63          	bgeu	a5,a1,ffffffffc0202cd2 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b7a:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0202b7c:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc0202b80:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202b84:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b88:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b8a:	12bef863          	bgeu	t4,a1,ffffffffc0202cba <exit_range+0x256>
ffffffffc0202b8e:	00083783          	ld	a5,0(a6)
ffffffffc0202b92:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202b94:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202b98:	629c                	ld	a5,0(a3)
ffffffffc0202b9a:	8b85                	andi	a5,a5,1
ffffffffc0202b9c:	f7d5                	bnez	a5,ffffffffc0202b48 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202b9e:	06a1                	addi	a3,a3,8
ffffffffc0202ba0:	fed59ce3          	bne	a1,a3,ffffffffc0202b98 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ba4:	631c                	ld	a5,0(a4)
ffffffffc0202ba6:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202ba8:	100027f3          	csrr	a5,sstatus
ffffffffc0202bac:	8b89                	andi	a5,a5,2
ffffffffc0202bae:	e7d9                	bnez	a5,ffffffffc0202c3c <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202bb0:	000db783          	ld	a5,0(s11)
ffffffffc0202bb4:	4585                	li	a1,1
ffffffffc0202bb6:	e032                	sd	a2,0(sp)
ffffffffc0202bb8:	739c                	ld	a5,32(a5)
ffffffffc0202bba:	9782                	jalr	a5
    if (flag)
ffffffffc0202bbc:	6602                	ld	a2,0(sp)
ffffffffc0202bbe:	000c4817          	auipc	a6,0xc4
ffffffffc0202bc2:	53a80813          	addi	a6,a6,1338 # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0202bc6:	fff80e37          	lui	t3,0xfff80
ffffffffc0202bca:	00080337          	lui	t1,0x80
ffffffffc0202bce:	6885                	lui	a7,0x1
ffffffffc0202bd0:	000c4717          	auipc	a4,0xc4
ffffffffc0202bd4:	51870713          	addi	a4,a4,1304 # ffffffffc02c70e8 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202bd8:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202bdc:	002007b7          	lui	a5,0x200
ffffffffc0202be0:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202be2:	f60918e3          	bnez	s2,ffffffffc0202b52 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202be6:	f00b85e3          	beqz	s7,ffffffffc0202af0 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202bea:	000d3783          	ld	a5,0(s10)
ffffffffc0202bee:	0efa7263          	bgeu	s4,a5,ffffffffc0202cd2 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bf2:	6308                	ld	a0,0(a4)
ffffffffc0202bf4:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202bf6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bfa:	8b89                	andi	a5,a5,2
ffffffffc0202bfc:	efad                	bnez	a5,ffffffffc0202c76 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202bfe:	000db783          	ld	a5,0(s11)
ffffffffc0202c02:	4585                	li	a1,1
ffffffffc0202c04:	739c                	ld	a5,32(a5)
ffffffffc0202c06:	9782                	jalr	a5
ffffffffc0202c08:	000c4717          	auipc	a4,0xc4
ffffffffc0202c0c:	4e070713          	addi	a4,a4,1248 # ffffffffc02c70e8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202c10:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc0202c14:	ee0990e3          	bnez	s3,ffffffffc0202af4 <exit_range+0x90>
}
ffffffffc0202c18:	70e6                	ld	ra,120(sp)
ffffffffc0202c1a:	7446                	ld	s0,112(sp)
ffffffffc0202c1c:	74a6                	ld	s1,104(sp)
ffffffffc0202c1e:	7906                	ld	s2,96(sp)
ffffffffc0202c20:	69e6                	ld	s3,88(sp)
ffffffffc0202c22:	6a46                	ld	s4,80(sp)
ffffffffc0202c24:	6aa6                	ld	s5,72(sp)
ffffffffc0202c26:	6b06                	ld	s6,64(sp)
ffffffffc0202c28:	7be2                	ld	s7,56(sp)
ffffffffc0202c2a:	7c42                	ld	s8,48(sp)
ffffffffc0202c2c:	7ca2                	ld	s9,40(sp)
ffffffffc0202c2e:	7d02                	ld	s10,32(sp)
ffffffffc0202c30:	6de2                	ld	s11,24(sp)
ffffffffc0202c32:	6109                	addi	sp,sp,128
ffffffffc0202c34:	8082                	ret
            if (free_pd0)
ffffffffc0202c36:	ea0b8fe3          	beqz	s7,ffffffffc0202af4 <exit_range+0x90>
ffffffffc0202c3a:	bf45                	j	ffffffffc0202bea <exit_range+0x186>
ffffffffc0202c3c:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202c3e:	e42a                	sd	a0,8(sp)
ffffffffc0202c40:	d75fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c44:	000db783          	ld	a5,0(s11)
ffffffffc0202c48:	6522                	ld	a0,8(sp)
ffffffffc0202c4a:	4585                	li	a1,1
ffffffffc0202c4c:	739c                	ld	a5,32(a5)
ffffffffc0202c4e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c50:	d5ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202c54:	6602                	ld	a2,0(sp)
ffffffffc0202c56:	000c4717          	auipc	a4,0xc4
ffffffffc0202c5a:	49270713          	addi	a4,a4,1170 # ffffffffc02c70e8 <pages>
ffffffffc0202c5e:	6885                	lui	a7,0x1
ffffffffc0202c60:	00080337          	lui	t1,0x80
ffffffffc0202c64:	fff80e37          	lui	t3,0xfff80
ffffffffc0202c68:	000c4817          	auipc	a6,0xc4
ffffffffc0202c6c:	49080813          	addi	a6,a6,1168 # ffffffffc02c70f8 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202c70:	0004b023          	sd	zero,0(s1)
ffffffffc0202c74:	b7a5                	j	ffffffffc0202bdc <exit_range+0x178>
ffffffffc0202c76:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202c78:	d3dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c7c:	000db783          	ld	a5,0(s11)
ffffffffc0202c80:	6502                	ld	a0,0(sp)
ffffffffc0202c82:	4585                	li	a1,1
ffffffffc0202c84:	739c                	ld	a5,32(a5)
ffffffffc0202c86:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c88:	d27fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202c8c:	000c4717          	auipc	a4,0xc4
ffffffffc0202c90:	45c70713          	addi	a4,a4,1116 # ffffffffc02c70e8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202c94:	00043023          	sd	zero,0(s0)
ffffffffc0202c98:	bfb5                	j	ffffffffc0202c14 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202c9a:	00004697          	auipc	a3,0x4
ffffffffc0202c9e:	f4e68693          	addi	a3,a3,-178 # ffffffffc0206be8 <default_pmm_manager+0x70>
ffffffffc0202ca2:	00003617          	auipc	a2,0x3
ffffffffc0202ca6:	7c660613          	addi	a2,a2,1990 # ffffffffc0206468 <commands+0x858>
ffffffffc0202caa:	13700593          	li	a1,311
ffffffffc0202cae:	00004517          	auipc	a0,0x4
ffffffffc0202cb2:	f2a50513          	addi	a0,a0,-214 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0202cb6:	d6cfd0ef          	jal	ra,ffffffffc0200222 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202cba:	00004617          	auipc	a2,0x4
ffffffffc0202cbe:	a2660613          	addi	a2,a2,-1498 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0202cc2:	07100593          	li	a1,113
ffffffffc0202cc6:	00004517          	auipc	a0,0x4
ffffffffc0202cca:	a4250513          	addi	a0,a0,-1470 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0202cce:	d54fd0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc0202cd2:	8e1ff0ef          	jal	ra,ffffffffc02025b2 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202cd6:	00004697          	auipc	a3,0x4
ffffffffc0202cda:	f4268693          	addi	a3,a3,-190 # ffffffffc0206c18 <default_pmm_manager+0xa0>
ffffffffc0202cde:	00003617          	auipc	a2,0x3
ffffffffc0202ce2:	78a60613          	addi	a2,a2,1930 # ffffffffc0206468 <commands+0x858>
ffffffffc0202ce6:	13800593          	li	a1,312
ffffffffc0202cea:	00004517          	auipc	a0,0x4
ffffffffc0202cee:	eee50513          	addi	a0,a0,-274 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0202cf2:	d30fd0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0202cf6 <page_remove>:
{
ffffffffc0202cf6:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202cf8:	4601                	li	a2,0
{
ffffffffc0202cfa:	ec26                	sd	s1,24(sp)
ffffffffc0202cfc:	f406                	sd	ra,40(sp)
ffffffffc0202cfe:	f022                	sd	s0,32(sp)
ffffffffc0202d00:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d02:	9a1ff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
    if (ptep != NULL)
ffffffffc0202d06:	c511                	beqz	a0,ffffffffc0202d12 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202d08:	611c                	ld	a5,0(a0)
ffffffffc0202d0a:	842a                	mv	s0,a0
ffffffffc0202d0c:	0017f713          	andi	a4,a5,1
ffffffffc0202d10:	e711                	bnez	a4,ffffffffc0202d1c <page_remove+0x26>
}
ffffffffc0202d12:	70a2                	ld	ra,40(sp)
ffffffffc0202d14:	7402                	ld	s0,32(sp)
ffffffffc0202d16:	64e2                	ld	s1,24(sp)
ffffffffc0202d18:	6145                	addi	sp,sp,48
ffffffffc0202d1a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202d1c:	078a                	slli	a5,a5,0x2
ffffffffc0202d1e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d20:	000c4717          	auipc	a4,0xc4
ffffffffc0202d24:	3c073703          	ld	a4,960(a4) # ffffffffc02c70e0 <npage>
ffffffffc0202d28:	06e7f363          	bgeu	a5,a4,ffffffffc0202d8e <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d2c:	fff80537          	lui	a0,0xfff80
ffffffffc0202d30:	97aa                	add	a5,a5,a0
ffffffffc0202d32:	079a                	slli	a5,a5,0x6
ffffffffc0202d34:	000c4517          	auipc	a0,0xc4
ffffffffc0202d38:	3b453503          	ld	a0,948(a0) # ffffffffc02c70e8 <pages>
ffffffffc0202d3c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202d3e:	411c                	lw	a5,0(a0)
ffffffffc0202d40:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202d44:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202d46:	cb11                	beqz	a4,ffffffffc0202d5a <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202d48:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202d4c:	12048073          	sfence.vma	s1
}
ffffffffc0202d50:	70a2                	ld	ra,40(sp)
ffffffffc0202d52:	7402                	ld	s0,32(sp)
ffffffffc0202d54:	64e2                	ld	s1,24(sp)
ffffffffc0202d56:	6145                	addi	sp,sp,48
ffffffffc0202d58:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202d5a:	100027f3          	csrr	a5,sstatus
ffffffffc0202d5e:	8b89                	andi	a5,a5,2
ffffffffc0202d60:	eb89                	bnez	a5,ffffffffc0202d72 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202d62:	000c4797          	auipc	a5,0xc4
ffffffffc0202d66:	38e7b783          	ld	a5,910(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202d6a:	739c                	ld	a5,32(a5)
ffffffffc0202d6c:	4585                	li	a1,1
ffffffffc0202d6e:	9782                	jalr	a5
    if (flag)
ffffffffc0202d70:	bfe1                	j	ffffffffc0202d48 <page_remove+0x52>
        intr_disable();
ffffffffc0202d72:	e42a                	sd	a0,8(sp)
ffffffffc0202d74:	c41fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d78:	000c4797          	auipc	a5,0xc4
ffffffffc0202d7c:	3787b783          	ld	a5,888(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202d80:	739c                	ld	a5,32(a5)
ffffffffc0202d82:	6522                	ld	a0,8(sp)
ffffffffc0202d84:	4585                	li	a1,1
ffffffffc0202d86:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d88:	c27fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d8c:	bf75                	j	ffffffffc0202d48 <page_remove+0x52>
ffffffffc0202d8e:	825ff0ef          	jal	ra,ffffffffc02025b2 <pa2page.part.0>

ffffffffc0202d92 <page_insert>:
{
ffffffffc0202d92:	7139                	addi	sp,sp,-64
ffffffffc0202d94:	e852                	sd	s4,16(sp)
ffffffffc0202d96:	8a32                	mv	s4,a2
ffffffffc0202d98:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202d9a:	4605                	li	a2,1
{
ffffffffc0202d9c:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202d9e:	85d2                	mv	a1,s4
{
ffffffffc0202da0:	f426                	sd	s1,40(sp)
ffffffffc0202da2:	fc06                	sd	ra,56(sp)
ffffffffc0202da4:	f04a                	sd	s2,32(sp)
ffffffffc0202da6:	ec4e                	sd	s3,24(sp)
ffffffffc0202da8:	e456                	sd	s5,8(sp)
ffffffffc0202daa:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202dac:	8f7ff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
    if (ptep == NULL)
ffffffffc0202db0:	c961                	beqz	a0,ffffffffc0202e80 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202db2:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202db4:	611c                	ld	a5,0(a0)
ffffffffc0202db6:	89aa                	mv	s3,a0
ffffffffc0202db8:	0016871b          	addiw	a4,a3,1
ffffffffc0202dbc:	c018                	sw	a4,0(s0)
ffffffffc0202dbe:	0017f713          	andi	a4,a5,1
ffffffffc0202dc2:	ef05                	bnez	a4,ffffffffc0202dfa <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202dc4:	000c4717          	auipc	a4,0xc4
ffffffffc0202dc8:	32473703          	ld	a4,804(a4) # ffffffffc02c70e8 <pages>
ffffffffc0202dcc:	8c19                	sub	s0,s0,a4
ffffffffc0202dce:	000807b7          	lui	a5,0x80
ffffffffc0202dd2:	8419                	srai	s0,s0,0x6
ffffffffc0202dd4:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202dd6:	042a                	slli	s0,s0,0xa
ffffffffc0202dd8:	8cc1                	or	s1,s1,s0
ffffffffc0202dda:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202dde:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_matrix_out_size+0xffffffffbfff38a0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202de2:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202de6:	4501                	li	a0,0
}
ffffffffc0202de8:	70e2                	ld	ra,56(sp)
ffffffffc0202dea:	7442                	ld	s0,48(sp)
ffffffffc0202dec:	74a2                	ld	s1,40(sp)
ffffffffc0202dee:	7902                	ld	s2,32(sp)
ffffffffc0202df0:	69e2                	ld	s3,24(sp)
ffffffffc0202df2:	6a42                	ld	s4,16(sp)
ffffffffc0202df4:	6aa2                	ld	s5,8(sp)
ffffffffc0202df6:	6121                	addi	sp,sp,64
ffffffffc0202df8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202dfa:	078a                	slli	a5,a5,0x2
ffffffffc0202dfc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202dfe:	000c4717          	auipc	a4,0xc4
ffffffffc0202e02:	2e273703          	ld	a4,738(a4) # ffffffffc02c70e0 <npage>
ffffffffc0202e06:	06e7ff63          	bgeu	a5,a4,ffffffffc0202e84 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e0a:	000c4a97          	auipc	s5,0xc4
ffffffffc0202e0e:	2dea8a93          	addi	s5,s5,734 # ffffffffc02c70e8 <pages>
ffffffffc0202e12:	000ab703          	ld	a4,0(s5)
ffffffffc0202e16:	fff80937          	lui	s2,0xfff80
ffffffffc0202e1a:	993e                	add	s2,s2,a5
ffffffffc0202e1c:	091a                	slli	s2,s2,0x6
ffffffffc0202e1e:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0202e20:	01240c63          	beq	s0,s2,ffffffffc0202e38 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc0202e24:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcb8ed0>
ffffffffc0202e28:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202e2c:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0202e30:	c691                	beqz	a3,ffffffffc0202e3c <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202e32:	120a0073          	sfence.vma	s4
}
ffffffffc0202e36:	bf59                	j	ffffffffc0202dcc <page_insert+0x3a>
ffffffffc0202e38:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202e3a:	bf49                	j	ffffffffc0202dcc <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202e3c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e40:	8b89                	andi	a5,a5,2
ffffffffc0202e42:	ef91                	bnez	a5,ffffffffc0202e5e <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202e44:	000c4797          	auipc	a5,0xc4
ffffffffc0202e48:	2ac7b783          	ld	a5,684(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202e4c:	739c                	ld	a5,32(a5)
ffffffffc0202e4e:	4585                	li	a1,1
ffffffffc0202e50:	854a                	mv	a0,s2
ffffffffc0202e52:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202e54:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202e58:	120a0073          	sfence.vma	s4
ffffffffc0202e5c:	bf85                	j	ffffffffc0202dcc <page_insert+0x3a>
        intr_disable();
ffffffffc0202e5e:	b57fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e62:	000c4797          	auipc	a5,0xc4
ffffffffc0202e66:	28e7b783          	ld	a5,654(a5) # ffffffffc02c70f0 <pmm_manager>
ffffffffc0202e6a:	739c                	ld	a5,32(a5)
ffffffffc0202e6c:	4585                	li	a1,1
ffffffffc0202e6e:	854a                	mv	a0,s2
ffffffffc0202e70:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e72:	b3dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e76:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202e7a:	120a0073          	sfence.vma	s4
ffffffffc0202e7e:	b7b9                	j	ffffffffc0202dcc <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202e80:	5571                	li	a0,-4
ffffffffc0202e82:	b79d                	j	ffffffffc0202de8 <page_insert+0x56>
ffffffffc0202e84:	f2eff0ef          	jal	ra,ffffffffc02025b2 <pa2page.part.0>

ffffffffc0202e88 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202e88:	00004797          	auipc	a5,0x4
ffffffffc0202e8c:	cf078793          	addi	a5,a5,-784 # ffffffffc0206b78 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202e90:	638c                	ld	a1,0(a5)
{
ffffffffc0202e92:	7159                	addi	sp,sp,-112
ffffffffc0202e94:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202e96:	00004517          	auipc	a0,0x4
ffffffffc0202e9a:	d9a50513          	addi	a0,a0,-614 # ffffffffc0206c30 <default_pmm_manager+0xb8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202e9e:	000c4b17          	auipc	s6,0xc4
ffffffffc0202ea2:	252b0b13          	addi	s6,s6,594 # ffffffffc02c70f0 <pmm_manager>
{
ffffffffc0202ea6:	f486                	sd	ra,104(sp)
ffffffffc0202ea8:	e8ca                	sd	s2,80(sp)
ffffffffc0202eaa:	e4ce                	sd	s3,72(sp)
ffffffffc0202eac:	f0a2                	sd	s0,96(sp)
ffffffffc0202eae:	eca6                	sd	s1,88(sp)
ffffffffc0202eb0:	e0d2                	sd	s4,64(sp)
ffffffffc0202eb2:	fc56                	sd	s5,56(sp)
ffffffffc0202eb4:	f45e                	sd	s7,40(sp)
ffffffffc0202eb6:	f062                	sd	s8,32(sp)
ffffffffc0202eb8:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202eba:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202ebe:	a26fd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    pmm_manager->init();
ffffffffc0202ec2:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202ec6:	000c4997          	auipc	s3,0xc4
ffffffffc0202eca:	23298993          	addi	s3,s3,562 # ffffffffc02c70f8 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202ece:	679c                	ld	a5,8(a5)
ffffffffc0202ed0:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202ed2:	57f5                	li	a5,-3
ffffffffc0202ed4:	07fa                	slli	a5,a5,0x1e
ffffffffc0202ed6:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202eda:	a03fd0ef          	jal	ra,ffffffffc02008dc <get_memory_base>
ffffffffc0202ede:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202ee0:	a07fd0ef          	jal	ra,ffffffffc02008e6 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202ee4:	200505e3          	beqz	a0,ffffffffc02038ee <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202ee8:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202eea:	00004517          	auipc	a0,0x4
ffffffffc0202eee:	d7e50513          	addi	a0,a0,-642 # ffffffffc0206c68 <default_pmm_manager+0xf0>
ffffffffc0202ef2:	9f2fd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202ef6:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202efa:	fff40693          	addi	a3,s0,-1
ffffffffc0202efe:	864a                	mv	a2,s2
ffffffffc0202f00:	85a6                	mv	a1,s1
ffffffffc0202f02:	00004517          	auipc	a0,0x4
ffffffffc0202f06:	d7e50513          	addi	a0,a0,-642 # ffffffffc0206c80 <default_pmm_manager+0x108>
ffffffffc0202f0a:	9dafd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202f0e:	c8000737          	lui	a4,0xc8000
ffffffffc0202f12:	87a2                	mv	a5,s0
ffffffffc0202f14:	54876163          	bltu	a4,s0,ffffffffc0203456 <pmm_init+0x5ce>
ffffffffc0202f18:	757d                	lui	a0,0xfffff
ffffffffc0202f1a:	000c5617          	auipc	a2,0xc5
ffffffffc0202f1e:	21560613          	addi	a2,a2,533 # ffffffffc02c812f <end+0xfff>
ffffffffc0202f22:	8e69                	and	a2,a2,a0
ffffffffc0202f24:	000c4497          	auipc	s1,0xc4
ffffffffc0202f28:	1bc48493          	addi	s1,s1,444 # ffffffffc02c70e0 <npage>
ffffffffc0202f2c:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202f30:	000c4b97          	auipc	s7,0xc4
ffffffffc0202f34:	1b8b8b93          	addi	s7,s7,440 # ffffffffc02c70e8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202f38:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202f3a:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f3e:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202f42:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f44:	02f50863          	beq	a0,a5,ffffffffc0202f74 <pmm_init+0xec>
ffffffffc0202f48:	4781                	li	a5,0
ffffffffc0202f4a:	4585                	li	a1,1
ffffffffc0202f4c:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202f50:	00679513          	slli	a0,a5,0x6
ffffffffc0202f54:	9532                	add	a0,a0,a2
ffffffffc0202f56:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd37ed8>
ffffffffc0202f5a:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f5e:	6088                	ld	a0,0(s1)
ffffffffc0202f60:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202f62:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202f66:	00d50733          	add	a4,a0,a3
ffffffffc0202f6a:	fee7e3e3          	bltu	a5,a4,ffffffffc0202f50 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202f6e:	071a                	slli	a4,a4,0x6
ffffffffc0202f70:	00e606b3          	add	a3,a2,a4
ffffffffc0202f74:	c02007b7          	lui	a5,0xc0200
ffffffffc0202f78:	2ef6ece3          	bltu	a3,a5,ffffffffc0203a70 <pmm_init+0xbe8>
ffffffffc0202f7c:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202f80:	77fd                	lui	a5,0xfffff
ffffffffc0202f82:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202f84:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202f86:	5086eb63          	bltu	a3,s0,ffffffffc020349c <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202f8a:	00004517          	auipc	a0,0x4
ffffffffc0202f8e:	d1e50513          	addi	a0,a0,-738 # ffffffffc0206ca8 <default_pmm_manager+0x130>
ffffffffc0202f92:	952fd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202f96:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202f9a:	000c4917          	auipc	s2,0xc4
ffffffffc0202f9e:	13e90913          	addi	s2,s2,318 # ffffffffc02c70d8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202fa2:	7b9c                	ld	a5,48(a5)
ffffffffc0202fa4:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202fa6:	00004517          	auipc	a0,0x4
ffffffffc0202faa:	d1a50513          	addi	a0,a0,-742 # ffffffffc0206cc0 <default_pmm_manager+0x148>
ffffffffc0202fae:	936fd0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202fb2:	00008697          	auipc	a3,0x8
ffffffffc0202fb6:	04e68693          	addi	a3,a3,78 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc0202fba:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202fbe:	c02007b7          	lui	a5,0xc0200
ffffffffc0202fc2:	28f6ebe3          	bltu	a3,a5,ffffffffc0203a58 <pmm_init+0xbd0>
ffffffffc0202fc6:	0009b783          	ld	a5,0(s3)
ffffffffc0202fca:	8e9d                	sub	a3,a3,a5
ffffffffc0202fcc:	000c4797          	auipc	a5,0xc4
ffffffffc0202fd0:	10d7b223          	sd	a3,260(a5) # ffffffffc02c70d0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202fd4:	100027f3          	csrr	a5,sstatus
ffffffffc0202fd8:	8b89                	andi	a5,a5,2
ffffffffc0202fda:	4a079763          	bnez	a5,ffffffffc0203488 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202fde:	000b3783          	ld	a5,0(s6)
ffffffffc0202fe2:	779c                	ld	a5,40(a5)
ffffffffc0202fe4:	9782                	jalr	a5
ffffffffc0202fe6:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202fe8:	6098                	ld	a4,0(s1)
ffffffffc0202fea:	c80007b7          	lui	a5,0xc8000
ffffffffc0202fee:	83b1                	srli	a5,a5,0xc
ffffffffc0202ff0:	66e7e363          	bltu	a5,a4,ffffffffc0203656 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ff4:	00093503          	ld	a0,0(s2)
ffffffffc0202ff8:	62050f63          	beqz	a0,ffffffffc0203636 <pmm_init+0x7ae>
ffffffffc0202ffc:	03451793          	slli	a5,a0,0x34
ffffffffc0203000:	62079b63          	bnez	a5,ffffffffc0203636 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203004:	4601                	li	a2,0
ffffffffc0203006:	4581                	li	a1,0
ffffffffc0203008:	8c3ff0ef          	jal	ra,ffffffffc02028ca <get_page>
ffffffffc020300c:	60051563          	bnez	a0,ffffffffc0203616 <pmm_init+0x78e>
ffffffffc0203010:	100027f3          	csrr	a5,sstatus
ffffffffc0203014:	8b89                	andi	a5,a5,2
ffffffffc0203016:	44079e63          	bnez	a5,ffffffffc0203472 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc020301a:	000b3783          	ld	a5,0(s6)
ffffffffc020301e:	4505                	li	a0,1
ffffffffc0203020:	6f9c                	ld	a5,24(a5)
ffffffffc0203022:	9782                	jalr	a5
ffffffffc0203024:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203026:	00093503          	ld	a0,0(s2)
ffffffffc020302a:	4681                	li	a3,0
ffffffffc020302c:	4601                	li	a2,0
ffffffffc020302e:	85d2                	mv	a1,s4
ffffffffc0203030:	d63ff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
ffffffffc0203034:	26051ae3          	bnez	a0,ffffffffc0203aa8 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203038:	00093503          	ld	a0,0(s2)
ffffffffc020303c:	4601                	li	a2,0
ffffffffc020303e:	4581                	li	a1,0
ffffffffc0203040:	e62ff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc0203044:	240502e3          	beqz	a0,ffffffffc0203a88 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0203048:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020304a:	0017f713          	andi	a4,a5,1
ffffffffc020304e:	5a070263          	beqz	a4,ffffffffc02035f2 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0203052:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203054:	078a                	slli	a5,a5,0x2
ffffffffc0203056:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203058:	58e7fb63          	bgeu	a5,a4,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020305c:	000bb683          	ld	a3,0(s7)
ffffffffc0203060:	fff80637          	lui	a2,0xfff80
ffffffffc0203064:	97b2                	add	a5,a5,a2
ffffffffc0203066:	079a                	slli	a5,a5,0x6
ffffffffc0203068:	97b6                	add	a5,a5,a3
ffffffffc020306a:	14fa17e3          	bne	s4,a5,ffffffffc02039b8 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020306e:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f98>
ffffffffc0203072:	4785                	li	a5,1
ffffffffc0203074:	12f692e3          	bne	a3,a5,ffffffffc0203998 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203078:	00093503          	ld	a0,0(s2)
ffffffffc020307c:	77fd                	lui	a5,0xfffff
ffffffffc020307e:	6114                	ld	a3,0(a0)
ffffffffc0203080:	068a                	slli	a3,a3,0x2
ffffffffc0203082:	8efd                	and	a3,a3,a5
ffffffffc0203084:	00c6d613          	srli	a2,a3,0xc
ffffffffc0203088:	0ee67ce3          	bgeu	a2,a4,ffffffffc0203980 <pmm_init+0xaf8>
ffffffffc020308c:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203090:	96e2                	add	a3,a3,s8
ffffffffc0203092:	0006ba83          	ld	s5,0(a3)
ffffffffc0203096:	0a8a                	slli	s5,s5,0x2
ffffffffc0203098:	00fafab3          	and	s5,s5,a5
ffffffffc020309c:	00cad793          	srli	a5,s5,0xc
ffffffffc02030a0:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203966 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02030a4:	4601                	li	a2,0
ffffffffc02030a6:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02030a8:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02030aa:	df8ff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02030ae:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02030b0:	55551363          	bne	a0,s5,ffffffffc02035f6 <pmm_init+0x76e>
ffffffffc02030b4:	100027f3          	csrr	a5,sstatus
ffffffffc02030b8:	8b89                	andi	a5,a5,2
ffffffffc02030ba:	3a079163          	bnez	a5,ffffffffc020345c <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc02030be:	000b3783          	ld	a5,0(s6)
ffffffffc02030c2:	4505                	li	a0,1
ffffffffc02030c4:	6f9c                	ld	a5,24(a5)
ffffffffc02030c6:	9782                	jalr	a5
ffffffffc02030c8:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02030ca:	00093503          	ld	a0,0(s2)
ffffffffc02030ce:	46d1                	li	a3,20
ffffffffc02030d0:	6605                	lui	a2,0x1
ffffffffc02030d2:	85e2                	mv	a1,s8
ffffffffc02030d4:	cbfff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
ffffffffc02030d8:	060517e3          	bnez	a0,ffffffffc0203946 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030dc:	00093503          	ld	a0,0(s2)
ffffffffc02030e0:	4601                	li	a2,0
ffffffffc02030e2:	6585                	lui	a1,0x1
ffffffffc02030e4:	dbeff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc02030e8:	02050fe3          	beqz	a0,ffffffffc0203926 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02030ec:	611c                	ld	a5,0(a0)
ffffffffc02030ee:	0107f713          	andi	a4,a5,16
ffffffffc02030f2:	7c070e63          	beqz	a4,ffffffffc02038ce <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02030f6:	8b91                	andi	a5,a5,4
ffffffffc02030f8:	7a078b63          	beqz	a5,ffffffffc02038ae <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02030fc:	00093503          	ld	a0,0(s2)
ffffffffc0203100:	611c                	ld	a5,0(a0)
ffffffffc0203102:	8bc1                	andi	a5,a5,16
ffffffffc0203104:	78078563          	beqz	a5,ffffffffc020388e <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0203108:	000c2703          	lw	a4,0(s8)
ffffffffc020310c:	4785                	li	a5,1
ffffffffc020310e:	76f71063          	bne	a4,a5,ffffffffc020386e <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203112:	4681                	li	a3,0
ffffffffc0203114:	6605                	lui	a2,0x1
ffffffffc0203116:	85d2                	mv	a1,s4
ffffffffc0203118:	c7bff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
ffffffffc020311c:	72051963          	bnez	a0,ffffffffc020384e <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0203120:	000a2703          	lw	a4,0(s4)
ffffffffc0203124:	4789                	li	a5,2
ffffffffc0203126:	70f71463          	bne	a4,a5,ffffffffc020382e <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc020312a:	000c2783          	lw	a5,0(s8)
ffffffffc020312e:	6e079063          	bnez	a5,ffffffffc020380e <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203132:	00093503          	ld	a0,0(s2)
ffffffffc0203136:	4601                	li	a2,0
ffffffffc0203138:	6585                	lui	a1,0x1
ffffffffc020313a:	d68ff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc020313e:	6a050863          	beqz	a0,ffffffffc02037ee <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0203142:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0203144:	00177793          	andi	a5,a4,1
ffffffffc0203148:	4a078563          	beqz	a5,ffffffffc02035f2 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020314c:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020314e:	00271793          	slli	a5,a4,0x2
ffffffffc0203152:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203154:	48d7fd63          	bgeu	a5,a3,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203158:	000bb683          	ld	a3,0(s7)
ffffffffc020315c:	fff80ab7          	lui	s5,0xfff80
ffffffffc0203160:	97d6                	add	a5,a5,s5
ffffffffc0203162:	079a                	slli	a5,a5,0x6
ffffffffc0203164:	97b6                	add	a5,a5,a3
ffffffffc0203166:	66fa1463          	bne	s4,a5,ffffffffc02037ce <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc020316a:	8b41                	andi	a4,a4,16
ffffffffc020316c:	64071163          	bnez	a4,ffffffffc02037ae <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0203170:	00093503          	ld	a0,0(s2)
ffffffffc0203174:	4581                	li	a1,0
ffffffffc0203176:	b81ff0ef          	jal	ra,ffffffffc0202cf6 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020317a:	000a2c83          	lw	s9,0(s4)
ffffffffc020317e:	4785                	li	a5,1
ffffffffc0203180:	60fc9763          	bne	s9,a5,ffffffffc020378e <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0203184:	000c2783          	lw	a5,0(s8)
ffffffffc0203188:	5e079363          	bnez	a5,ffffffffc020376e <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020318c:	00093503          	ld	a0,0(s2)
ffffffffc0203190:	6585                	lui	a1,0x1
ffffffffc0203192:	b65ff0ef          	jal	ra,ffffffffc0202cf6 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0203196:	000a2783          	lw	a5,0(s4)
ffffffffc020319a:	52079a63          	bnez	a5,ffffffffc02036ce <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc020319e:	000c2783          	lw	a5,0(s8)
ffffffffc02031a2:	50079663          	bnez	a5,ffffffffc02036ae <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02031a6:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc02031aa:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02031ac:	000a3683          	ld	a3,0(s4)
ffffffffc02031b0:	068a                	slli	a3,a3,0x2
ffffffffc02031b2:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc02031b4:	42b6fd63          	bgeu	a3,a1,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02031b8:	000bb503          	ld	a0,0(s7)
ffffffffc02031bc:	96d6                	add	a3,a3,s5
ffffffffc02031be:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc02031c0:	00d507b3          	add	a5,a0,a3
ffffffffc02031c4:	439c                	lw	a5,0(a5)
ffffffffc02031c6:	4d979463          	bne	a5,s9,ffffffffc020368e <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc02031ca:	8699                	srai	a3,a3,0x6
ffffffffc02031cc:	00080637          	lui	a2,0x80
ffffffffc02031d0:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02031d2:	00c69713          	slli	a4,a3,0xc
ffffffffc02031d6:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02031d8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02031da:	48b77e63          	bgeu	a4,a1,ffffffffc0203676 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02031de:	0009b703          	ld	a4,0(s3)
ffffffffc02031e2:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02031e4:	629c                	ld	a5,0(a3)
ffffffffc02031e6:	078a                	slli	a5,a5,0x2
ffffffffc02031e8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02031ea:	40b7f263          	bgeu	a5,a1,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02031ee:	8f91                	sub	a5,a5,a2
ffffffffc02031f0:	079a                	slli	a5,a5,0x6
ffffffffc02031f2:	953e                	add	a0,a0,a5
ffffffffc02031f4:	100027f3          	csrr	a5,sstatus
ffffffffc02031f8:	8b89                	andi	a5,a5,2
ffffffffc02031fa:	30079963          	bnez	a5,ffffffffc020350c <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02031fe:	000b3783          	ld	a5,0(s6)
ffffffffc0203202:	4585                	li	a1,1
ffffffffc0203204:	739c                	ld	a5,32(a5)
ffffffffc0203206:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203208:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc020320c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020320e:	078a                	slli	a5,a5,0x2
ffffffffc0203210:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203212:	3ce7fe63          	bgeu	a5,a4,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203216:	000bb503          	ld	a0,0(s7)
ffffffffc020321a:	fff80737          	lui	a4,0xfff80
ffffffffc020321e:	97ba                	add	a5,a5,a4
ffffffffc0203220:	079a                	slli	a5,a5,0x6
ffffffffc0203222:	953e                	add	a0,a0,a5
ffffffffc0203224:	100027f3          	csrr	a5,sstatus
ffffffffc0203228:	8b89                	andi	a5,a5,2
ffffffffc020322a:	2c079563          	bnez	a5,ffffffffc02034f4 <pmm_init+0x66c>
ffffffffc020322e:	000b3783          	ld	a5,0(s6)
ffffffffc0203232:	4585                	li	a1,1
ffffffffc0203234:	739c                	ld	a5,32(a5)
ffffffffc0203236:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0203238:	00093783          	ld	a5,0(s2)
ffffffffc020323c:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd37ed0>
    asm volatile("sfence.vma");
ffffffffc0203240:	12000073          	sfence.vma
ffffffffc0203244:	100027f3          	csrr	a5,sstatus
ffffffffc0203248:	8b89                	andi	a5,a5,2
ffffffffc020324a:	28079b63          	bnez	a5,ffffffffc02034e0 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc020324e:	000b3783          	ld	a5,0(s6)
ffffffffc0203252:	779c                	ld	a5,40(a5)
ffffffffc0203254:	9782                	jalr	a5
ffffffffc0203256:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0203258:	4b441b63          	bne	s0,s4,ffffffffc020370e <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc020325c:	00004517          	auipc	a0,0x4
ffffffffc0203260:	d8c50513          	addi	a0,a0,-628 # ffffffffc0206fe8 <default_pmm_manager+0x470>
ffffffffc0203264:	e81fc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
ffffffffc0203268:	100027f3          	csrr	a5,sstatus
ffffffffc020326c:	8b89                	andi	a5,a5,2
ffffffffc020326e:	24079f63          	bnez	a5,ffffffffc02034cc <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203272:	000b3783          	ld	a5,0(s6)
ffffffffc0203276:	779c                	ld	a5,40(a5)
ffffffffc0203278:	9782                	jalr	a5
ffffffffc020327a:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020327c:	6098                	ld	a4,0(s1)
ffffffffc020327e:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203282:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0203284:	00c71793          	slli	a5,a4,0xc
ffffffffc0203288:	6a05                	lui	s4,0x1
ffffffffc020328a:	02f47c63          	bgeu	s0,a5,ffffffffc02032c2 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020328e:	00c45793          	srli	a5,s0,0xc
ffffffffc0203292:	00093503          	ld	a0,0(s2)
ffffffffc0203296:	2ee7ff63          	bgeu	a5,a4,ffffffffc0203594 <pmm_init+0x70c>
ffffffffc020329a:	0009b583          	ld	a1,0(s3)
ffffffffc020329e:	4601                	li	a2,0
ffffffffc02032a0:	95a2                	add	a1,a1,s0
ffffffffc02032a2:	c00ff0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc02032a6:	32050463          	beqz	a0,ffffffffc02035ce <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02032aa:	611c                	ld	a5,0(a0)
ffffffffc02032ac:	078a                	slli	a5,a5,0x2
ffffffffc02032ae:	0157f7b3          	and	a5,a5,s5
ffffffffc02032b2:	2e879e63          	bne	a5,s0,ffffffffc02035ae <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02032b6:	6098                	ld	a4,0(s1)
ffffffffc02032b8:	9452                	add	s0,s0,s4
ffffffffc02032ba:	00c71793          	slli	a5,a4,0xc
ffffffffc02032be:	fcf468e3          	bltu	s0,a5,ffffffffc020328e <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc02032c2:	00093783          	ld	a5,0(s2)
ffffffffc02032c6:	639c                	ld	a5,0(a5)
ffffffffc02032c8:	42079363          	bnez	a5,ffffffffc02036ee <pmm_init+0x866>
ffffffffc02032cc:	100027f3          	csrr	a5,sstatus
ffffffffc02032d0:	8b89                	andi	a5,a5,2
ffffffffc02032d2:	24079963          	bnez	a5,ffffffffc0203524 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02032d6:	000b3783          	ld	a5,0(s6)
ffffffffc02032da:	4505                	li	a0,1
ffffffffc02032dc:	6f9c                	ld	a5,24(a5)
ffffffffc02032de:	9782                	jalr	a5
ffffffffc02032e0:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02032e2:	00093503          	ld	a0,0(s2)
ffffffffc02032e6:	4699                	li	a3,6
ffffffffc02032e8:	10000613          	li	a2,256
ffffffffc02032ec:	85d2                	mv	a1,s4
ffffffffc02032ee:	aa5ff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
ffffffffc02032f2:	44051e63          	bnez	a0,ffffffffc020374e <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc02032f6:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f98>
ffffffffc02032fa:	4785                	li	a5,1
ffffffffc02032fc:	42f71963          	bne	a4,a5,ffffffffc020372e <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203300:	00093503          	ld	a0,0(s2)
ffffffffc0203304:	6405                	lui	s0,0x1
ffffffffc0203306:	4699                	li	a3,6
ffffffffc0203308:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8e98>
ffffffffc020330c:	85d2                	mv	a1,s4
ffffffffc020330e:	a85ff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
ffffffffc0203312:	72051363          	bnez	a0,ffffffffc0203a38 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0203316:	000a2703          	lw	a4,0(s4)
ffffffffc020331a:	4789                	li	a5,2
ffffffffc020331c:	6ef71e63          	bne	a4,a5,ffffffffc0203a18 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0203320:	00004597          	auipc	a1,0x4
ffffffffc0203324:	e1058593          	addi	a1,a1,-496 # ffffffffc0207130 <default_pmm_manager+0x5b8>
ffffffffc0203328:	10000513          	li	a0,256
ffffffffc020332c:	19e020ef          	jal	ra,ffffffffc02054ca <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203330:	10040593          	addi	a1,s0,256
ffffffffc0203334:	10000513          	li	a0,256
ffffffffc0203338:	1a4020ef          	jal	ra,ffffffffc02054dc <strcmp>
ffffffffc020333c:	6a051e63          	bnez	a0,ffffffffc02039f8 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0203340:	000bb683          	ld	a3,0(s7)
ffffffffc0203344:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0203348:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc020334a:	40da06b3          	sub	a3,s4,a3
ffffffffc020334e:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203350:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0203352:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0203354:	8031                	srli	s0,s0,0xc
ffffffffc0203356:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc020335a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020335c:	30f77d63          	bgeu	a4,a5,ffffffffc0203676 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203360:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203364:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203368:	96be                	add	a3,a3,a5
ffffffffc020336a:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020336e:	126020ef          	jal	ra,ffffffffc0205494 <strlen>
ffffffffc0203372:	66051363          	bnez	a0,ffffffffc02039d8 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0203376:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020337a:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020337c:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd37ed0>
ffffffffc0203380:	068a                	slli	a3,a3,0x2
ffffffffc0203382:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0203384:	26f6f563          	bgeu	a3,a5,ffffffffc02035ee <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0203388:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020338a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020338c:	2ef47563          	bgeu	s0,a5,ffffffffc0203676 <pmm_init+0x7ee>
ffffffffc0203390:	0009b403          	ld	s0,0(s3)
ffffffffc0203394:	9436                	add	s0,s0,a3
ffffffffc0203396:	100027f3          	csrr	a5,sstatus
ffffffffc020339a:	8b89                	andi	a5,a5,2
ffffffffc020339c:	1e079163          	bnez	a5,ffffffffc020357e <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc02033a0:	000b3783          	ld	a5,0(s6)
ffffffffc02033a4:	4585                	li	a1,1
ffffffffc02033a6:	8552                	mv	a0,s4
ffffffffc02033a8:	739c                	ld	a5,32(a5)
ffffffffc02033aa:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02033ac:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc02033ae:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02033b0:	078a                	slli	a5,a5,0x2
ffffffffc02033b2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02033b4:	22e7fd63          	bgeu	a5,a4,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02033b8:	000bb503          	ld	a0,0(s7)
ffffffffc02033bc:	fff80737          	lui	a4,0xfff80
ffffffffc02033c0:	97ba                	add	a5,a5,a4
ffffffffc02033c2:	079a                	slli	a5,a5,0x6
ffffffffc02033c4:	953e                	add	a0,a0,a5
ffffffffc02033c6:	100027f3          	csrr	a5,sstatus
ffffffffc02033ca:	8b89                	andi	a5,a5,2
ffffffffc02033cc:	18079d63          	bnez	a5,ffffffffc0203566 <pmm_init+0x6de>
ffffffffc02033d0:	000b3783          	ld	a5,0(s6)
ffffffffc02033d4:	4585                	li	a1,1
ffffffffc02033d6:	739c                	ld	a5,32(a5)
ffffffffc02033d8:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02033da:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc02033de:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02033e0:	078a                	slli	a5,a5,0x2
ffffffffc02033e2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02033e4:	20e7f563          	bgeu	a5,a4,ffffffffc02035ee <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02033e8:	000bb503          	ld	a0,0(s7)
ffffffffc02033ec:	fff80737          	lui	a4,0xfff80
ffffffffc02033f0:	97ba                	add	a5,a5,a4
ffffffffc02033f2:	079a                	slli	a5,a5,0x6
ffffffffc02033f4:	953e                	add	a0,a0,a5
ffffffffc02033f6:	100027f3          	csrr	a5,sstatus
ffffffffc02033fa:	8b89                	andi	a5,a5,2
ffffffffc02033fc:	14079963          	bnez	a5,ffffffffc020354e <pmm_init+0x6c6>
ffffffffc0203400:	000b3783          	ld	a5,0(s6)
ffffffffc0203404:	4585                	li	a1,1
ffffffffc0203406:	739c                	ld	a5,32(a5)
ffffffffc0203408:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020340a:	00093783          	ld	a5,0(s2)
ffffffffc020340e:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0203412:	12000073          	sfence.vma
ffffffffc0203416:	100027f3          	csrr	a5,sstatus
ffffffffc020341a:	8b89                	andi	a5,a5,2
ffffffffc020341c:	10079f63          	bnez	a5,ffffffffc020353a <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203420:	000b3783          	ld	a5,0(s6)
ffffffffc0203424:	779c                	ld	a5,40(a5)
ffffffffc0203426:	9782                	jalr	a5
ffffffffc0203428:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc020342a:	4c8c1e63          	bne	s8,s0,ffffffffc0203906 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc020342e:	00004517          	auipc	a0,0x4
ffffffffc0203432:	d7a50513          	addi	a0,a0,-646 # ffffffffc02071a8 <default_pmm_manager+0x630>
ffffffffc0203436:	caffc0ef          	jal	ra,ffffffffc02000e4 <cprintf>
}
ffffffffc020343a:	7406                	ld	s0,96(sp)
ffffffffc020343c:	70a6                	ld	ra,104(sp)
ffffffffc020343e:	64e6                	ld	s1,88(sp)
ffffffffc0203440:	6946                	ld	s2,80(sp)
ffffffffc0203442:	69a6                	ld	s3,72(sp)
ffffffffc0203444:	6a06                	ld	s4,64(sp)
ffffffffc0203446:	7ae2                	ld	s5,56(sp)
ffffffffc0203448:	7b42                	ld	s6,48(sp)
ffffffffc020344a:	7ba2                	ld	s7,40(sp)
ffffffffc020344c:	7c02                	ld	s8,32(sp)
ffffffffc020344e:	6ce2                	ld	s9,24(sp)
ffffffffc0203450:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0203452:	ce8fe06f          	j	ffffffffc020193a <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0203456:	c80007b7          	lui	a5,0xc8000
ffffffffc020345a:	bc7d                	j	ffffffffc0202f18 <pmm_init+0x90>
        intr_disable();
ffffffffc020345c:	d58fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203460:	000b3783          	ld	a5,0(s6)
ffffffffc0203464:	4505                	li	a0,1
ffffffffc0203466:	6f9c                	ld	a5,24(a5)
ffffffffc0203468:	9782                	jalr	a5
ffffffffc020346a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020346c:	d42fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203470:	b9a9                	j	ffffffffc02030ca <pmm_init+0x242>
        intr_disable();
ffffffffc0203472:	d42fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203476:	000b3783          	ld	a5,0(s6)
ffffffffc020347a:	4505                	li	a0,1
ffffffffc020347c:	6f9c                	ld	a5,24(a5)
ffffffffc020347e:	9782                	jalr	a5
ffffffffc0203480:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203482:	d2cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203486:	b645                	j	ffffffffc0203026 <pmm_init+0x19e>
        intr_disable();
ffffffffc0203488:	d2cfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020348c:	000b3783          	ld	a5,0(s6)
ffffffffc0203490:	779c                	ld	a5,40(a5)
ffffffffc0203492:	9782                	jalr	a5
ffffffffc0203494:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203496:	d18fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020349a:	b6b9                	j	ffffffffc0202fe8 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020349c:	6705                	lui	a4,0x1
ffffffffc020349e:	177d                	addi	a4,a4,-1
ffffffffc02034a0:	96ba                	add	a3,a3,a4
ffffffffc02034a2:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc02034a4:	00c7d713          	srli	a4,a5,0xc
ffffffffc02034a8:	14a77363          	bgeu	a4,a0,ffffffffc02035ee <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc02034ac:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc02034b0:	fff80537          	lui	a0,0xfff80
ffffffffc02034b4:	972a                	add	a4,a4,a0
ffffffffc02034b6:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02034b8:	8c1d                	sub	s0,s0,a5
ffffffffc02034ba:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc02034be:	00c45593          	srli	a1,s0,0xc
ffffffffc02034c2:	9532                	add	a0,a0,a2
ffffffffc02034c4:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02034c6:	0009b583          	ld	a1,0(s3)
}
ffffffffc02034ca:	b4c1                	j	ffffffffc0202f8a <pmm_init+0x102>
        intr_disable();
ffffffffc02034cc:	ce8fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02034d0:	000b3783          	ld	a5,0(s6)
ffffffffc02034d4:	779c                	ld	a5,40(a5)
ffffffffc02034d6:	9782                	jalr	a5
ffffffffc02034d8:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02034da:	cd4fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034de:	bb79                	j	ffffffffc020327c <pmm_init+0x3f4>
        intr_disable();
ffffffffc02034e0:	cd4fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02034e4:	000b3783          	ld	a5,0(s6)
ffffffffc02034e8:	779c                	ld	a5,40(a5)
ffffffffc02034ea:	9782                	jalr	a5
ffffffffc02034ec:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02034ee:	cc0fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02034f2:	b39d                	j	ffffffffc0203258 <pmm_init+0x3d0>
ffffffffc02034f4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02034f6:	cbefd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02034fa:	000b3783          	ld	a5,0(s6)
ffffffffc02034fe:	6522                	ld	a0,8(sp)
ffffffffc0203500:	4585                	li	a1,1
ffffffffc0203502:	739c                	ld	a5,32(a5)
ffffffffc0203504:	9782                	jalr	a5
        intr_enable();
ffffffffc0203506:	ca8fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020350a:	b33d                	j	ffffffffc0203238 <pmm_init+0x3b0>
ffffffffc020350c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020350e:	ca6fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203512:	000b3783          	ld	a5,0(s6)
ffffffffc0203516:	6522                	ld	a0,8(sp)
ffffffffc0203518:	4585                	li	a1,1
ffffffffc020351a:	739c                	ld	a5,32(a5)
ffffffffc020351c:	9782                	jalr	a5
        intr_enable();
ffffffffc020351e:	c90fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203522:	b1dd                	j	ffffffffc0203208 <pmm_init+0x380>
        intr_disable();
ffffffffc0203524:	c90fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203528:	000b3783          	ld	a5,0(s6)
ffffffffc020352c:	4505                	li	a0,1
ffffffffc020352e:	6f9c                	ld	a5,24(a5)
ffffffffc0203530:	9782                	jalr	a5
ffffffffc0203532:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203534:	c7afd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203538:	b36d                	j	ffffffffc02032e2 <pmm_init+0x45a>
        intr_disable();
ffffffffc020353a:	c7afd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020353e:	000b3783          	ld	a5,0(s6)
ffffffffc0203542:	779c                	ld	a5,40(a5)
ffffffffc0203544:	9782                	jalr	a5
ffffffffc0203546:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203548:	c66fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020354c:	bdf9                	j	ffffffffc020342a <pmm_init+0x5a2>
ffffffffc020354e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203550:	c64fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203554:	000b3783          	ld	a5,0(s6)
ffffffffc0203558:	6522                	ld	a0,8(sp)
ffffffffc020355a:	4585                	li	a1,1
ffffffffc020355c:	739c                	ld	a5,32(a5)
ffffffffc020355e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203560:	c4efd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203564:	b55d                	j	ffffffffc020340a <pmm_init+0x582>
ffffffffc0203566:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203568:	c4cfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020356c:	000b3783          	ld	a5,0(s6)
ffffffffc0203570:	6522                	ld	a0,8(sp)
ffffffffc0203572:	4585                	li	a1,1
ffffffffc0203574:	739c                	ld	a5,32(a5)
ffffffffc0203576:	9782                	jalr	a5
        intr_enable();
ffffffffc0203578:	c36fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020357c:	bdb9                	j	ffffffffc02033da <pmm_init+0x552>
        intr_disable();
ffffffffc020357e:	c36fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203582:	000b3783          	ld	a5,0(s6)
ffffffffc0203586:	4585                	li	a1,1
ffffffffc0203588:	8552                	mv	a0,s4
ffffffffc020358a:	739c                	ld	a5,32(a5)
ffffffffc020358c:	9782                	jalr	a5
        intr_enable();
ffffffffc020358e:	c20fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203592:	bd29                	j	ffffffffc02033ac <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203594:	86a2                	mv	a3,s0
ffffffffc0203596:	00003617          	auipc	a2,0x3
ffffffffc020359a:	14a60613          	addi	a2,a2,330 # ffffffffc02066e0 <commands+0xad0>
ffffffffc020359e:	25100593          	li	a1,593
ffffffffc02035a2:	00003517          	auipc	a0,0x3
ffffffffc02035a6:	63650513          	addi	a0,a0,1590 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02035aa:	c79fc0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02035ae:	00004697          	auipc	a3,0x4
ffffffffc02035b2:	a9a68693          	addi	a3,a3,-1382 # ffffffffc0207048 <default_pmm_manager+0x4d0>
ffffffffc02035b6:	00003617          	auipc	a2,0x3
ffffffffc02035ba:	eb260613          	addi	a2,a2,-334 # ffffffffc0206468 <commands+0x858>
ffffffffc02035be:	25200593          	li	a1,594
ffffffffc02035c2:	00003517          	auipc	a0,0x3
ffffffffc02035c6:	61650513          	addi	a0,a0,1558 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02035ca:	c59fc0ef          	jal	ra,ffffffffc0200222 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02035ce:	00004697          	auipc	a3,0x4
ffffffffc02035d2:	a3a68693          	addi	a3,a3,-1478 # ffffffffc0207008 <default_pmm_manager+0x490>
ffffffffc02035d6:	00003617          	auipc	a2,0x3
ffffffffc02035da:	e9260613          	addi	a2,a2,-366 # ffffffffc0206468 <commands+0x858>
ffffffffc02035de:	25100593          	li	a1,593
ffffffffc02035e2:	00003517          	auipc	a0,0x3
ffffffffc02035e6:	5f650513          	addi	a0,a0,1526 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02035ea:	c39fc0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc02035ee:	fc5fe0ef          	jal	ra,ffffffffc02025b2 <pa2page.part.0>
ffffffffc02035f2:	fddfe0ef          	jal	ra,ffffffffc02025ce <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02035f6:	00004697          	auipc	a3,0x4
ffffffffc02035fa:	80a68693          	addi	a3,a3,-2038 # ffffffffc0206e00 <default_pmm_manager+0x288>
ffffffffc02035fe:	00003617          	auipc	a2,0x3
ffffffffc0203602:	e6a60613          	addi	a2,a2,-406 # ffffffffc0206468 <commands+0x858>
ffffffffc0203606:	22100593          	li	a1,545
ffffffffc020360a:	00003517          	auipc	a0,0x3
ffffffffc020360e:	5ce50513          	addi	a0,a0,1486 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203612:	c11fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0203616:	00003697          	auipc	a3,0x3
ffffffffc020361a:	72a68693          	addi	a3,a3,1834 # ffffffffc0206d40 <default_pmm_manager+0x1c8>
ffffffffc020361e:	00003617          	auipc	a2,0x3
ffffffffc0203622:	e4a60613          	addi	a2,a2,-438 # ffffffffc0206468 <commands+0x858>
ffffffffc0203626:	21400593          	li	a1,532
ffffffffc020362a:	00003517          	auipc	a0,0x3
ffffffffc020362e:	5ae50513          	addi	a0,a0,1454 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203632:	bf1fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0203636:	00003697          	auipc	a3,0x3
ffffffffc020363a:	6ca68693          	addi	a3,a3,1738 # ffffffffc0206d00 <default_pmm_manager+0x188>
ffffffffc020363e:	00003617          	auipc	a2,0x3
ffffffffc0203642:	e2a60613          	addi	a2,a2,-470 # ffffffffc0206468 <commands+0x858>
ffffffffc0203646:	21300593          	li	a1,531
ffffffffc020364a:	00003517          	auipc	a0,0x3
ffffffffc020364e:	58e50513          	addi	a0,a0,1422 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203652:	bd1fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203656:	00003697          	auipc	a3,0x3
ffffffffc020365a:	68a68693          	addi	a3,a3,1674 # ffffffffc0206ce0 <default_pmm_manager+0x168>
ffffffffc020365e:	00003617          	auipc	a2,0x3
ffffffffc0203662:	e0a60613          	addi	a2,a2,-502 # ffffffffc0206468 <commands+0x858>
ffffffffc0203666:	21200593          	li	a1,530
ffffffffc020366a:	00003517          	auipc	a0,0x3
ffffffffc020366e:	56e50513          	addi	a0,a0,1390 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203672:	bb1fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203676:	00003617          	auipc	a2,0x3
ffffffffc020367a:	06a60613          	addi	a2,a2,106 # ffffffffc02066e0 <commands+0xad0>
ffffffffc020367e:	07100593          	li	a1,113
ffffffffc0203682:	00003517          	auipc	a0,0x3
ffffffffc0203686:	08650513          	addi	a0,a0,134 # ffffffffc0206708 <commands+0xaf8>
ffffffffc020368a:	b99fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc020368e:	00004697          	auipc	a3,0x4
ffffffffc0203692:	90268693          	addi	a3,a3,-1790 # ffffffffc0206f90 <default_pmm_manager+0x418>
ffffffffc0203696:	00003617          	auipc	a2,0x3
ffffffffc020369a:	dd260613          	addi	a2,a2,-558 # ffffffffc0206468 <commands+0x858>
ffffffffc020369e:	23a00593          	li	a1,570
ffffffffc02036a2:	00003517          	auipc	a0,0x3
ffffffffc02036a6:	53650513          	addi	a0,a0,1334 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02036aa:	b79fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02036ae:	00004697          	auipc	a3,0x4
ffffffffc02036b2:	89a68693          	addi	a3,a3,-1894 # ffffffffc0206f48 <default_pmm_manager+0x3d0>
ffffffffc02036b6:	00003617          	auipc	a2,0x3
ffffffffc02036ba:	db260613          	addi	a2,a2,-590 # ffffffffc0206468 <commands+0x858>
ffffffffc02036be:	23800593          	li	a1,568
ffffffffc02036c2:	00003517          	auipc	a0,0x3
ffffffffc02036c6:	51650513          	addi	a0,a0,1302 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02036ca:	b59fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02036ce:	00004697          	auipc	a3,0x4
ffffffffc02036d2:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0206f78 <default_pmm_manager+0x400>
ffffffffc02036d6:	00003617          	auipc	a2,0x3
ffffffffc02036da:	d9260613          	addi	a2,a2,-622 # ffffffffc0206468 <commands+0x858>
ffffffffc02036de:	23700593          	li	a1,567
ffffffffc02036e2:	00003517          	auipc	a0,0x3
ffffffffc02036e6:	4f650513          	addi	a0,a0,1270 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02036ea:	b39fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02036ee:	00004697          	auipc	a3,0x4
ffffffffc02036f2:	97268693          	addi	a3,a3,-1678 # ffffffffc0207060 <default_pmm_manager+0x4e8>
ffffffffc02036f6:	00003617          	auipc	a2,0x3
ffffffffc02036fa:	d7260613          	addi	a2,a2,-654 # ffffffffc0206468 <commands+0x858>
ffffffffc02036fe:	25500593          	li	a1,597
ffffffffc0203702:	00003517          	auipc	a0,0x3
ffffffffc0203706:	4d650513          	addi	a0,a0,1238 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020370a:	b19fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020370e:	00004697          	auipc	a3,0x4
ffffffffc0203712:	8b268693          	addi	a3,a3,-1870 # ffffffffc0206fc0 <default_pmm_manager+0x448>
ffffffffc0203716:	00003617          	auipc	a2,0x3
ffffffffc020371a:	d5260613          	addi	a2,a2,-686 # ffffffffc0206468 <commands+0x858>
ffffffffc020371e:	24200593          	li	a1,578
ffffffffc0203722:	00003517          	auipc	a0,0x3
ffffffffc0203726:	4b650513          	addi	a0,a0,1206 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020372a:	af9fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p) == 1);
ffffffffc020372e:	00004697          	auipc	a3,0x4
ffffffffc0203732:	98a68693          	addi	a3,a3,-1654 # ffffffffc02070b8 <default_pmm_manager+0x540>
ffffffffc0203736:	00003617          	auipc	a2,0x3
ffffffffc020373a:	d3260613          	addi	a2,a2,-718 # ffffffffc0206468 <commands+0x858>
ffffffffc020373e:	25a00593          	li	a1,602
ffffffffc0203742:	00003517          	auipc	a0,0x3
ffffffffc0203746:	49650513          	addi	a0,a0,1174 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020374a:	ad9fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020374e:	00004697          	auipc	a3,0x4
ffffffffc0203752:	92a68693          	addi	a3,a3,-1750 # ffffffffc0207078 <default_pmm_manager+0x500>
ffffffffc0203756:	00003617          	auipc	a2,0x3
ffffffffc020375a:	d1260613          	addi	a2,a2,-750 # ffffffffc0206468 <commands+0x858>
ffffffffc020375e:	25900593          	li	a1,601
ffffffffc0203762:	00003517          	auipc	a0,0x3
ffffffffc0203766:	47650513          	addi	a0,a0,1142 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020376a:	ab9fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020376e:	00003697          	auipc	a3,0x3
ffffffffc0203772:	7da68693          	addi	a3,a3,2010 # ffffffffc0206f48 <default_pmm_manager+0x3d0>
ffffffffc0203776:	00003617          	auipc	a2,0x3
ffffffffc020377a:	cf260613          	addi	a2,a2,-782 # ffffffffc0206468 <commands+0x858>
ffffffffc020377e:	23400593          	li	a1,564
ffffffffc0203782:	00003517          	auipc	a0,0x3
ffffffffc0203786:	45650513          	addi	a0,a0,1110 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020378a:	a99fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020378e:	00003697          	auipc	a3,0x3
ffffffffc0203792:	65a68693          	addi	a3,a3,1626 # ffffffffc0206de8 <default_pmm_manager+0x270>
ffffffffc0203796:	00003617          	auipc	a2,0x3
ffffffffc020379a:	cd260613          	addi	a2,a2,-814 # ffffffffc0206468 <commands+0x858>
ffffffffc020379e:	23300593          	li	a1,563
ffffffffc02037a2:	00003517          	auipc	a0,0x3
ffffffffc02037a6:	43650513          	addi	a0,a0,1078 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02037aa:	a79fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02037ae:	00003697          	auipc	a3,0x3
ffffffffc02037b2:	7b268693          	addi	a3,a3,1970 # ffffffffc0206f60 <default_pmm_manager+0x3e8>
ffffffffc02037b6:	00003617          	auipc	a2,0x3
ffffffffc02037ba:	cb260613          	addi	a2,a2,-846 # ffffffffc0206468 <commands+0x858>
ffffffffc02037be:	23000593          	li	a1,560
ffffffffc02037c2:	00003517          	auipc	a0,0x3
ffffffffc02037c6:	41650513          	addi	a0,a0,1046 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02037ca:	a59fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02037ce:	00003697          	auipc	a3,0x3
ffffffffc02037d2:	60268693          	addi	a3,a3,1538 # ffffffffc0206dd0 <default_pmm_manager+0x258>
ffffffffc02037d6:	00003617          	auipc	a2,0x3
ffffffffc02037da:	c9260613          	addi	a2,a2,-878 # ffffffffc0206468 <commands+0x858>
ffffffffc02037de:	22f00593          	li	a1,559
ffffffffc02037e2:	00003517          	auipc	a0,0x3
ffffffffc02037e6:	3f650513          	addi	a0,a0,1014 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02037ea:	a39fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02037ee:	00003697          	auipc	a3,0x3
ffffffffc02037f2:	68268693          	addi	a3,a3,1666 # ffffffffc0206e70 <default_pmm_manager+0x2f8>
ffffffffc02037f6:	00003617          	auipc	a2,0x3
ffffffffc02037fa:	c7260613          	addi	a2,a2,-910 # ffffffffc0206468 <commands+0x858>
ffffffffc02037fe:	22e00593          	li	a1,558
ffffffffc0203802:	00003517          	auipc	a0,0x3
ffffffffc0203806:	3d650513          	addi	a0,a0,982 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020380a:	a19fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020380e:	00003697          	auipc	a3,0x3
ffffffffc0203812:	73a68693          	addi	a3,a3,1850 # ffffffffc0206f48 <default_pmm_manager+0x3d0>
ffffffffc0203816:	00003617          	auipc	a2,0x3
ffffffffc020381a:	c5260613          	addi	a2,a2,-942 # ffffffffc0206468 <commands+0x858>
ffffffffc020381e:	22d00593          	li	a1,557
ffffffffc0203822:	00003517          	auipc	a0,0x3
ffffffffc0203826:	3b650513          	addi	a0,a0,950 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020382a:	9f9fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc020382e:	00003697          	auipc	a3,0x3
ffffffffc0203832:	70268693          	addi	a3,a3,1794 # ffffffffc0206f30 <default_pmm_manager+0x3b8>
ffffffffc0203836:	00003617          	auipc	a2,0x3
ffffffffc020383a:	c3260613          	addi	a2,a2,-974 # ffffffffc0206468 <commands+0x858>
ffffffffc020383e:	22c00593          	li	a1,556
ffffffffc0203842:	00003517          	auipc	a0,0x3
ffffffffc0203846:	39650513          	addi	a0,a0,918 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020384a:	9d9fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020384e:	00003697          	auipc	a3,0x3
ffffffffc0203852:	6b268693          	addi	a3,a3,1714 # ffffffffc0206f00 <default_pmm_manager+0x388>
ffffffffc0203856:	00003617          	auipc	a2,0x3
ffffffffc020385a:	c1260613          	addi	a2,a2,-1006 # ffffffffc0206468 <commands+0x858>
ffffffffc020385e:	22b00593          	li	a1,555
ffffffffc0203862:	00003517          	auipc	a0,0x3
ffffffffc0203866:	37650513          	addi	a0,a0,886 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020386a:	9b9fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020386e:	00003697          	auipc	a3,0x3
ffffffffc0203872:	67a68693          	addi	a3,a3,1658 # ffffffffc0206ee8 <default_pmm_manager+0x370>
ffffffffc0203876:	00003617          	auipc	a2,0x3
ffffffffc020387a:	bf260613          	addi	a2,a2,-1038 # ffffffffc0206468 <commands+0x858>
ffffffffc020387e:	22900593          	li	a1,553
ffffffffc0203882:	00003517          	auipc	a0,0x3
ffffffffc0203886:	35650513          	addi	a0,a0,854 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020388a:	999fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020388e:	00003697          	auipc	a3,0x3
ffffffffc0203892:	63a68693          	addi	a3,a3,1594 # ffffffffc0206ec8 <default_pmm_manager+0x350>
ffffffffc0203896:	00003617          	auipc	a2,0x3
ffffffffc020389a:	bd260613          	addi	a2,a2,-1070 # ffffffffc0206468 <commands+0x858>
ffffffffc020389e:	22800593          	li	a1,552
ffffffffc02038a2:	00003517          	auipc	a0,0x3
ffffffffc02038a6:	33650513          	addi	a0,a0,822 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02038aa:	979fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(*ptep & PTE_W);
ffffffffc02038ae:	00003697          	auipc	a3,0x3
ffffffffc02038b2:	60a68693          	addi	a3,a3,1546 # ffffffffc0206eb8 <default_pmm_manager+0x340>
ffffffffc02038b6:	00003617          	auipc	a2,0x3
ffffffffc02038ba:	bb260613          	addi	a2,a2,-1102 # ffffffffc0206468 <commands+0x858>
ffffffffc02038be:	22700593          	li	a1,551
ffffffffc02038c2:	00003517          	auipc	a0,0x3
ffffffffc02038c6:	31650513          	addi	a0,a0,790 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02038ca:	959fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02038ce:	00003697          	auipc	a3,0x3
ffffffffc02038d2:	5da68693          	addi	a3,a3,1498 # ffffffffc0206ea8 <default_pmm_manager+0x330>
ffffffffc02038d6:	00003617          	auipc	a2,0x3
ffffffffc02038da:	b9260613          	addi	a2,a2,-1134 # ffffffffc0206468 <commands+0x858>
ffffffffc02038de:	22600593          	li	a1,550
ffffffffc02038e2:	00003517          	auipc	a0,0x3
ffffffffc02038e6:	2f650513          	addi	a0,a0,758 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02038ea:	939fc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("DTB memory info not available");
ffffffffc02038ee:	00003617          	auipc	a2,0x3
ffffffffc02038f2:	35a60613          	addi	a2,a2,858 # ffffffffc0206c48 <default_pmm_manager+0xd0>
ffffffffc02038f6:	06500593          	li	a1,101
ffffffffc02038fa:	00003517          	auipc	a0,0x3
ffffffffc02038fe:	2de50513          	addi	a0,a0,734 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203902:	921fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203906:	00003697          	auipc	a3,0x3
ffffffffc020390a:	6ba68693          	addi	a3,a3,1722 # ffffffffc0206fc0 <default_pmm_manager+0x448>
ffffffffc020390e:	00003617          	auipc	a2,0x3
ffffffffc0203912:	b5a60613          	addi	a2,a2,-1190 # ffffffffc0206468 <commands+0x858>
ffffffffc0203916:	26c00593          	li	a1,620
ffffffffc020391a:	00003517          	auipc	a0,0x3
ffffffffc020391e:	2be50513          	addi	a0,a0,702 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203922:	901fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203926:	00003697          	auipc	a3,0x3
ffffffffc020392a:	54a68693          	addi	a3,a3,1354 # ffffffffc0206e70 <default_pmm_manager+0x2f8>
ffffffffc020392e:	00003617          	auipc	a2,0x3
ffffffffc0203932:	b3a60613          	addi	a2,a2,-1222 # ffffffffc0206468 <commands+0x858>
ffffffffc0203936:	22500593          	li	a1,549
ffffffffc020393a:	00003517          	auipc	a0,0x3
ffffffffc020393e:	29e50513          	addi	a0,a0,670 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203942:	8e1fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203946:	00003697          	auipc	a3,0x3
ffffffffc020394a:	4ea68693          	addi	a3,a3,1258 # ffffffffc0206e30 <default_pmm_manager+0x2b8>
ffffffffc020394e:	00003617          	auipc	a2,0x3
ffffffffc0203952:	b1a60613          	addi	a2,a2,-1254 # ffffffffc0206468 <commands+0x858>
ffffffffc0203956:	22400593          	li	a1,548
ffffffffc020395a:	00003517          	auipc	a0,0x3
ffffffffc020395e:	27e50513          	addi	a0,a0,638 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203962:	8c1fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203966:	86d6                	mv	a3,s5
ffffffffc0203968:	00003617          	auipc	a2,0x3
ffffffffc020396c:	d7860613          	addi	a2,a2,-648 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0203970:	22000593          	li	a1,544
ffffffffc0203974:	00003517          	auipc	a0,0x3
ffffffffc0203978:	26450513          	addi	a0,a0,612 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc020397c:	8a7fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203980:	00003617          	auipc	a2,0x3
ffffffffc0203984:	d6060613          	addi	a2,a2,-672 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0203988:	21f00593          	li	a1,543
ffffffffc020398c:	00003517          	auipc	a0,0x3
ffffffffc0203990:	24c50513          	addi	a0,a0,588 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203994:	88ffc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203998:	00003697          	auipc	a3,0x3
ffffffffc020399c:	45068693          	addi	a3,a3,1104 # ffffffffc0206de8 <default_pmm_manager+0x270>
ffffffffc02039a0:	00003617          	auipc	a2,0x3
ffffffffc02039a4:	ac860613          	addi	a2,a2,-1336 # ffffffffc0206468 <commands+0x858>
ffffffffc02039a8:	21d00593          	li	a1,541
ffffffffc02039ac:	00003517          	auipc	a0,0x3
ffffffffc02039b0:	22c50513          	addi	a0,a0,556 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02039b4:	86ffc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02039b8:	00003697          	auipc	a3,0x3
ffffffffc02039bc:	41868693          	addi	a3,a3,1048 # ffffffffc0206dd0 <default_pmm_manager+0x258>
ffffffffc02039c0:	00003617          	auipc	a2,0x3
ffffffffc02039c4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0206468 <commands+0x858>
ffffffffc02039c8:	21c00593          	li	a1,540
ffffffffc02039cc:	00003517          	auipc	a0,0x3
ffffffffc02039d0:	20c50513          	addi	a0,a0,524 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02039d4:	84ffc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02039d8:	00003697          	auipc	a3,0x3
ffffffffc02039dc:	7a868693          	addi	a3,a3,1960 # ffffffffc0207180 <default_pmm_manager+0x608>
ffffffffc02039e0:	00003617          	auipc	a2,0x3
ffffffffc02039e4:	a8860613          	addi	a2,a2,-1400 # ffffffffc0206468 <commands+0x858>
ffffffffc02039e8:	26300593          	li	a1,611
ffffffffc02039ec:	00003517          	auipc	a0,0x3
ffffffffc02039f0:	1ec50513          	addi	a0,a0,492 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc02039f4:	82ffc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02039f8:	00003697          	auipc	a3,0x3
ffffffffc02039fc:	75068693          	addi	a3,a3,1872 # ffffffffc0207148 <default_pmm_manager+0x5d0>
ffffffffc0203a00:	00003617          	auipc	a2,0x3
ffffffffc0203a04:	a6860613          	addi	a2,a2,-1432 # ffffffffc0206468 <commands+0x858>
ffffffffc0203a08:	26000593          	li	a1,608
ffffffffc0203a0c:	00003517          	auipc	a0,0x3
ffffffffc0203a10:	1cc50513          	addi	a0,a0,460 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203a14:	80ffc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203a18:	00003697          	auipc	a3,0x3
ffffffffc0203a1c:	70068693          	addi	a3,a3,1792 # ffffffffc0207118 <default_pmm_manager+0x5a0>
ffffffffc0203a20:	00003617          	auipc	a2,0x3
ffffffffc0203a24:	a4860613          	addi	a2,a2,-1464 # ffffffffc0206468 <commands+0x858>
ffffffffc0203a28:	25c00593          	li	a1,604
ffffffffc0203a2c:	00003517          	auipc	a0,0x3
ffffffffc0203a30:	1ac50513          	addi	a0,a0,428 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203a34:	feefc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203a38:	00003697          	auipc	a3,0x3
ffffffffc0203a3c:	69868693          	addi	a3,a3,1688 # ffffffffc02070d0 <default_pmm_manager+0x558>
ffffffffc0203a40:	00003617          	auipc	a2,0x3
ffffffffc0203a44:	a2860613          	addi	a2,a2,-1496 # ffffffffc0206468 <commands+0x858>
ffffffffc0203a48:	25b00593          	li	a1,603
ffffffffc0203a4c:	00003517          	auipc	a0,0x3
ffffffffc0203a50:	18c50513          	addi	a0,a0,396 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203a54:	fcefc0ef          	jal	ra,ffffffffc0200222 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203a58:	00003617          	auipc	a2,0x3
ffffffffc0203a5c:	d3060613          	addi	a2,a2,-720 # ffffffffc0206788 <commands+0xb78>
ffffffffc0203a60:	0c900593          	li	a1,201
ffffffffc0203a64:	00003517          	auipc	a0,0x3
ffffffffc0203a68:	17450513          	addi	a0,a0,372 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203a6c:	fb6fc0ef          	jal	ra,ffffffffc0200222 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203a70:	00003617          	auipc	a2,0x3
ffffffffc0203a74:	d1860613          	addi	a2,a2,-744 # ffffffffc0206788 <commands+0xb78>
ffffffffc0203a78:	08100593          	li	a1,129
ffffffffc0203a7c:	00003517          	auipc	a0,0x3
ffffffffc0203a80:	15c50513          	addi	a0,a0,348 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203a84:	f9efc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203a88:	00003697          	auipc	a3,0x3
ffffffffc0203a8c:	31868693          	addi	a3,a3,792 # ffffffffc0206da0 <default_pmm_manager+0x228>
ffffffffc0203a90:	00003617          	auipc	a2,0x3
ffffffffc0203a94:	9d860613          	addi	a2,a2,-1576 # ffffffffc0206468 <commands+0x858>
ffffffffc0203a98:	21b00593          	li	a1,539
ffffffffc0203a9c:	00003517          	auipc	a0,0x3
ffffffffc0203aa0:	13c50513          	addi	a0,a0,316 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203aa4:	f7efc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203aa8:	00003697          	auipc	a3,0x3
ffffffffc0203aac:	2c868693          	addi	a3,a3,712 # ffffffffc0206d70 <default_pmm_manager+0x1f8>
ffffffffc0203ab0:	00003617          	auipc	a2,0x3
ffffffffc0203ab4:	9b860613          	addi	a2,a2,-1608 # ffffffffc0206468 <commands+0x858>
ffffffffc0203ab8:	21800593          	li	a1,536
ffffffffc0203abc:	00003517          	auipc	a0,0x3
ffffffffc0203ac0:	11c50513          	addi	a0,a0,284 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203ac4:	f5efc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203ac8 <copy_range>:
{
ffffffffc0203ac8:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203aca:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203ace:	f486                	sd	ra,104(sp)
ffffffffc0203ad0:	f0a2                	sd	s0,96(sp)
ffffffffc0203ad2:	eca6                	sd	s1,88(sp)
ffffffffc0203ad4:	e8ca                	sd	s2,80(sp)
ffffffffc0203ad6:	e4ce                	sd	s3,72(sp)
ffffffffc0203ad8:	e0d2                	sd	s4,64(sp)
ffffffffc0203ada:	fc56                	sd	s5,56(sp)
ffffffffc0203adc:	f85a                	sd	s6,48(sp)
ffffffffc0203ade:	f45e                	sd	s7,40(sp)
ffffffffc0203ae0:	f062                	sd	s8,32(sp)
ffffffffc0203ae2:	ec66                	sd	s9,24(sp)
ffffffffc0203ae4:	e86a                	sd	s10,16(sp)
ffffffffc0203ae6:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203ae8:	17d2                	slli	a5,a5,0x34
ffffffffc0203aea:	20079f63          	bnez	a5,ffffffffc0203d08 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc0203aee:	002007b7          	lui	a5,0x200
ffffffffc0203af2:	8432                	mv	s0,a2
ffffffffc0203af4:	1af66263          	bltu	a2,a5,ffffffffc0203c98 <copy_range+0x1d0>
ffffffffc0203af8:	8936                	mv	s2,a3
ffffffffc0203afa:	18d67f63          	bgeu	a2,a3,ffffffffc0203c98 <copy_range+0x1d0>
ffffffffc0203afe:	4785                	li	a5,1
ffffffffc0203b00:	07fe                	slli	a5,a5,0x1f
ffffffffc0203b02:	18d7eb63          	bltu	a5,a3,ffffffffc0203c98 <copy_range+0x1d0>
ffffffffc0203b06:	5b7d                	li	s6,-1
ffffffffc0203b08:	8aaa                	mv	s5,a0
ffffffffc0203b0a:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc0203b0c:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0203b0e:	000c3c17          	auipc	s8,0xc3
ffffffffc0203b12:	5d2c0c13          	addi	s8,s8,1490 # ffffffffc02c70e0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203b16:	000c3b97          	auipc	s7,0xc3
ffffffffc0203b1a:	5d2b8b93          	addi	s7,s7,1490 # ffffffffc02c70e8 <pages>
    return KADDR(page2pa(page));
ffffffffc0203b1e:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc0203b22:	000c3c97          	auipc	s9,0xc3
ffffffffc0203b26:	5cec8c93          	addi	s9,s9,1486 # ffffffffc02c70f0 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203b2a:	4601                	li	a2,0
ffffffffc0203b2c:	85a2                	mv	a1,s0
ffffffffc0203b2e:	854e                	mv	a0,s3
ffffffffc0203b30:	b73fe0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc0203b34:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0203b36:	0e050c63          	beqz	a0,ffffffffc0203c2e <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc0203b3a:	611c                	ld	a5,0(a0)
ffffffffc0203b3c:	8b85                	andi	a5,a5,1
ffffffffc0203b3e:	e785                	bnez	a5,ffffffffc0203b66 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc0203b40:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0203b42:	ff2464e3          	bltu	s0,s2,ffffffffc0203b2a <copy_range+0x62>
    return 0;
ffffffffc0203b46:	4501                	li	a0,0
}
ffffffffc0203b48:	70a6                	ld	ra,104(sp)
ffffffffc0203b4a:	7406                	ld	s0,96(sp)
ffffffffc0203b4c:	64e6                	ld	s1,88(sp)
ffffffffc0203b4e:	6946                	ld	s2,80(sp)
ffffffffc0203b50:	69a6                	ld	s3,72(sp)
ffffffffc0203b52:	6a06                	ld	s4,64(sp)
ffffffffc0203b54:	7ae2                	ld	s5,56(sp)
ffffffffc0203b56:	7b42                	ld	s6,48(sp)
ffffffffc0203b58:	7ba2                	ld	s7,40(sp)
ffffffffc0203b5a:	7c02                	ld	s8,32(sp)
ffffffffc0203b5c:	6ce2                	ld	s9,24(sp)
ffffffffc0203b5e:	6d42                	ld	s10,16(sp)
ffffffffc0203b60:	6da2                	ld	s11,8(sp)
ffffffffc0203b62:	6165                	addi	sp,sp,112
ffffffffc0203b64:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203b66:	4605                	li	a2,1
ffffffffc0203b68:	85a2                	mv	a1,s0
ffffffffc0203b6a:	8556                	mv	a0,s5
ffffffffc0203b6c:	b37fe0ef          	jal	ra,ffffffffc02026a2 <get_pte>
ffffffffc0203b70:	c56d                	beqz	a0,ffffffffc0203c5a <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203b72:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203b74:	0017f713          	andi	a4,a5,1
ffffffffc0203b78:	01f7f493          	andi	s1,a5,31
ffffffffc0203b7c:	16070a63          	beqz	a4,ffffffffc0203cf0 <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc0203b80:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203b84:	078a                	slli	a5,a5,0x2
ffffffffc0203b86:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203b8a:	14d77763          	bgeu	a4,a3,ffffffffc0203cd8 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0203b8e:	000bb783          	ld	a5,0(s7)
ffffffffc0203b92:	fff806b7          	lui	a3,0xfff80
ffffffffc0203b96:	9736                	add	a4,a4,a3
ffffffffc0203b98:	071a                	slli	a4,a4,0x6
ffffffffc0203b9a:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203b9e:	10002773          	csrr	a4,sstatus
ffffffffc0203ba2:	8b09                	andi	a4,a4,2
ffffffffc0203ba4:	e345                	bnez	a4,ffffffffc0203c44 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203ba6:	000cb703          	ld	a4,0(s9)
ffffffffc0203baa:	4505                	li	a0,1
ffffffffc0203bac:	6f18                	ld	a4,24(a4)
ffffffffc0203bae:	9702                	jalr	a4
ffffffffc0203bb0:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203bb2:	0c0d8363          	beqz	s11,ffffffffc0203c78 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203bb6:	100d0163          	beqz	s10,ffffffffc0203cb8 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203bba:	000bb703          	ld	a4,0(s7)
ffffffffc0203bbe:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203bc2:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203bc6:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203bca:	8699                	srai	a3,a3,0x6
ffffffffc0203bcc:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0203bce:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203bd2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203bd4:	08c7f663          	bgeu	a5,a2,ffffffffc0203c60 <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203bd8:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc0203bdc:	000c3717          	auipc	a4,0xc3
ffffffffc0203be0:	51c70713          	addi	a4,a4,1308 # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0203be4:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203be6:	8799                	srai	a5,a5,0x6
ffffffffc0203be8:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc0203bea:	0167f733          	and	a4,a5,s6
ffffffffc0203bee:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203bf2:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203bf4:	06c77563          	bgeu	a4,a2,ffffffffc0203c5e <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203bf8:	6605                	lui	a2,0x1
ffffffffc0203bfa:	953e                	add	a0,a0,a5
ffffffffc0203bfc:	14d010ef          	jal	ra,ffffffffc0205548 <memcpy>
            int ret = page_insert(to, npage, start, perm);
ffffffffc0203c00:	86a6                	mv	a3,s1
ffffffffc0203c02:	8622                	mv	a2,s0
ffffffffc0203c04:	85ea                	mv	a1,s10
ffffffffc0203c06:	8556                	mv	a0,s5
ffffffffc0203c08:	98aff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
            assert(ret == 0);
ffffffffc0203c0c:	d915                	beqz	a0,ffffffffc0203b40 <copy_range+0x78>
ffffffffc0203c0e:	00003697          	auipc	a3,0x3
ffffffffc0203c12:	5da68693          	addi	a3,a3,1498 # ffffffffc02071e8 <default_pmm_manager+0x670>
ffffffffc0203c16:	00003617          	auipc	a2,0x3
ffffffffc0203c1a:	85260613          	addi	a2,a2,-1966 # ffffffffc0206468 <commands+0x858>
ffffffffc0203c1e:	1b000593          	li	a1,432
ffffffffc0203c22:	00003517          	auipc	a0,0x3
ffffffffc0203c26:	fb650513          	addi	a0,a0,-74 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203c2a:	df8fc0ef          	jal	ra,ffffffffc0200222 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203c2e:	00200637          	lui	a2,0x200
ffffffffc0203c32:	9432                	add	s0,s0,a2
ffffffffc0203c34:	ffe00637          	lui	a2,0xffe00
ffffffffc0203c38:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc0203c3a:	f00406e3          	beqz	s0,ffffffffc0203b46 <copy_range+0x7e>
ffffffffc0203c3e:	ef2466e3          	bltu	s0,s2,ffffffffc0203b2a <copy_range+0x62>
ffffffffc0203c42:	b711                	j	ffffffffc0203b46 <copy_range+0x7e>
        intr_disable();
ffffffffc0203c44:	d71fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203c48:	000cb703          	ld	a4,0(s9)
ffffffffc0203c4c:	4505                	li	a0,1
ffffffffc0203c4e:	6f18                	ld	a4,24(a4)
ffffffffc0203c50:	9702                	jalr	a4
ffffffffc0203c52:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc0203c54:	d5bfc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203c58:	bfa9                	j	ffffffffc0203bb2 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0203c5a:	5571                	li	a0,-4
ffffffffc0203c5c:	b5f5                	j	ffffffffc0203b48 <copy_range+0x80>
ffffffffc0203c5e:	86be                	mv	a3,a5
ffffffffc0203c60:	00003617          	auipc	a2,0x3
ffffffffc0203c64:	a8060613          	addi	a2,a2,-1408 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0203c68:	07100593          	li	a1,113
ffffffffc0203c6c:	00003517          	auipc	a0,0x3
ffffffffc0203c70:	a9c50513          	addi	a0,a0,-1380 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0203c74:	daefc0ef          	jal	ra,ffffffffc0200222 <__panic>
            assert(page != NULL);
ffffffffc0203c78:	00003697          	auipc	a3,0x3
ffffffffc0203c7c:	55068693          	addi	a3,a3,1360 # ffffffffc02071c8 <default_pmm_manager+0x650>
ffffffffc0203c80:	00002617          	auipc	a2,0x2
ffffffffc0203c84:	7e860613          	addi	a2,a2,2024 # ffffffffc0206468 <commands+0x858>
ffffffffc0203c88:	19600593          	li	a1,406
ffffffffc0203c8c:	00003517          	auipc	a0,0x3
ffffffffc0203c90:	f4c50513          	addi	a0,a0,-180 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203c94:	d8efc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203c98:	00003697          	auipc	a3,0x3
ffffffffc0203c9c:	f8068693          	addi	a3,a3,-128 # ffffffffc0206c18 <default_pmm_manager+0xa0>
ffffffffc0203ca0:	00002617          	auipc	a2,0x2
ffffffffc0203ca4:	7c860613          	addi	a2,a2,1992 # ffffffffc0206468 <commands+0x858>
ffffffffc0203ca8:	17e00593          	li	a1,382
ffffffffc0203cac:	00003517          	auipc	a0,0x3
ffffffffc0203cb0:	f2c50513          	addi	a0,a0,-212 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203cb4:	d6efc0ef          	jal	ra,ffffffffc0200222 <__panic>
            assert(npage != NULL);
ffffffffc0203cb8:	00003697          	auipc	a3,0x3
ffffffffc0203cbc:	52068693          	addi	a3,a3,1312 # ffffffffc02071d8 <default_pmm_manager+0x660>
ffffffffc0203cc0:	00002617          	auipc	a2,0x2
ffffffffc0203cc4:	7a860613          	addi	a2,a2,1960 # ffffffffc0206468 <commands+0x858>
ffffffffc0203cc8:	19700593          	li	a1,407
ffffffffc0203ccc:	00003517          	auipc	a0,0x3
ffffffffc0203cd0:	f0c50513          	addi	a0,a0,-244 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203cd4:	d4efc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203cd8:	00003617          	auipc	a2,0x3
ffffffffc0203cdc:	ad860613          	addi	a2,a2,-1320 # ffffffffc02067b0 <commands+0xba0>
ffffffffc0203ce0:	06900593          	li	a1,105
ffffffffc0203ce4:	00003517          	auipc	a0,0x3
ffffffffc0203ce8:	a2450513          	addi	a0,a0,-1500 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0203cec:	d36fc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203cf0:	00003617          	auipc	a2,0x3
ffffffffc0203cf4:	ec060613          	addi	a2,a2,-320 # ffffffffc0206bb0 <default_pmm_manager+0x38>
ffffffffc0203cf8:	07f00593          	li	a1,127
ffffffffc0203cfc:	00003517          	auipc	a0,0x3
ffffffffc0203d00:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0203d04:	d1efc0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203d08:	00003697          	auipc	a3,0x3
ffffffffc0203d0c:	ee068693          	addi	a3,a3,-288 # ffffffffc0206be8 <default_pmm_manager+0x70>
ffffffffc0203d10:	00002617          	auipc	a2,0x2
ffffffffc0203d14:	75860613          	addi	a2,a2,1880 # ffffffffc0206468 <commands+0x858>
ffffffffc0203d18:	17d00593          	li	a1,381
ffffffffc0203d1c:	00003517          	auipc	a0,0x3
ffffffffc0203d20:	ebc50513          	addi	a0,a0,-324 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203d24:	cfefc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203d28 <pgdir_alloc_page>:
{
ffffffffc0203d28:	7179                	addi	sp,sp,-48
ffffffffc0203d2a:	ec26                	sd	s1,24(sp)
ffffffffc0203d2c:	e84a                	sd	s2,16(sp)
ffffffffc0203d2e:	e052                	sd	s4,0(sp)
ffffffffc0203d30:	f406                	sd	ra,40(sp)
ffffffffc0203d32:	f022                	sd	s0,32(sp)
ffffffffc0203d34:	e44e                	sd	s3,8(sp)
ffffffffc0203d36:	8a2a                	mv	s4,a0
ffffffffc0203d38:	84ae                	mv	s1,a1
ffffffffc0203d3a:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203d3c:	100027f3          	csrr	a5,sstatus
ffffffffc0203d40:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203d42:	000c3997          	auipc	s3,0xc3
ffffffffc0203d46:	3ae98993          	addi	s3,s3,942 # ffffffffc02c70f0 <pmm_manager>
ffffffffc0203d4a:	ef8d                	bnez	a5,ffffffffc0203d84 <pgdir_alloc_page+0x5c>
ffffffffc0203d4c:	0009b783          	ld	a5,0(s3)
ffffffffc0203d50:	4505                	li	a0,1
ffffffffc0203d52:	6f9c                	ld	a5,24(a5)
ffffffffc0203d54:	9782                	jalr	a5
ffffffffc0203d56:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203d58:	cc09                	beqz	s0,ffffffffc0203d72 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203d5a:	86ca                	mv	a3,s2
ffffffffc0203d5c:	8626                	mv	a2,s1
ffffffffc0203d5e:	85a2                	mv	a1,s0
ffffffffc0203d60:	8552                	mv	a0,s4
ffffffffc0203d62:	830ff0ef          	jal	ra,ffffffffc0202d92 <page_insert>
ffffffffc0203d66:	e915                	bnez	a0,ffffffffc0203d9a <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203d68:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203d6a:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203d6c:	4785                	li	a5,1
ffffffffc0203d6e:	04f71e63          	bne	a4,a5,ffffffffc0203dca <pgdir_alloc_page+0xa2>
}
ffffffffc0203d72:	70a2                	ld	ra,40(sp)
ffffffffc0203d74:	8522                	mv	a0,s0
ffffffffc0203d76:	7402                	ld	s0,32(sp)
ffffffffc0203d78:	64e2                	ld	s1,24(sp)
ffffffffc0203d7a:	6942                	ld	s2,16(sp)
ffffffffc0203d7c:	69a2                	ld	s3,8(sp)
ffffffffc0203d7e:	6a02                	ld	s4,0(sp)
ffffffffc0203d80:	6145                	addi	sp,sp,48
ffffffffc0203d82:	8082                	ret
        intr_disable();
ffffffffc0203d84:	c31fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203d88:	0009b783          	ld	a5,0(s3)
ffffffffc0203d8c:	4505                	li	a0,1
ffffffffc0203d8e:	6f9c                	ld	a5,24(a5)
ffffffffc0203d90:	9782                	jalr	a5
ffffffffc0203d92:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203d94:	c1bfc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203d98:	b7c1                	j	ffffffffc0203d58 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203d9a:	100027f3          	csrr	a5,sstatus
ffffffffc0203d9e:	8b89                	andi	a5,a5,2
ffffffffc0203da0:	eb89                	bnez	a5,ffffffffc0203db2 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203da2:	0009b783          	ld	a5,0(s3)
ffffffffc0203da6:	8522                	mv	a0,s0
ffffffffc0203da8:	4585                	li	a1,1
ffffffffc0203daa:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203dac:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203dae:	9782                	jalr	a5
    if (flag)
ffffffffc0203db0:	b7c9                	j	ffffffffc0203d72 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203db2:	c03fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203db6:	0009b783          	ld	a5,0(s3)
ffffffffc0203dba:	8522                	mv	a0,s0
ffffffffc0203dbc:	4585                	li	a1,1
ffffffffc0203dbe:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203dc0:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203dc2:	9782                	jalr	a5
        intr_enable();
ffffffffc0203dc4:	bebfc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203dc8:	b76d                	j	ffffffffc0203d72 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203dca:	00003697          	auipc	a3,0x3
ffffffffc0203dce:	42e68693          	addi	a3,a3,1070 # ffffffffc02071f8 <default_pmm_manager+0x680>
ffffffffc0203dd2:	00002617          	auipc	a2,0x2
ffffffffc0203dd6:	69660613          	addi	a2,a2,1686 # ffffffffc0206468 <commands+0x858>
ffffffffc0203dda:	1f900593          	li	a1,505
ffffffffc0203dde:	00003517          	auipc	a0,0x3
ffffffffc0203de2:	dfa50513          	addi	a0,a0,-518 # ffffffffc0206bd8 <default_pmm_manager+0x60>
ffffffffc0203de6:	c3cfc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203dea <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203dea:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203dee:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203df2:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0203df4:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203df6:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203dfa:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203dfe:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203e02:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203e06:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203e0a:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203e0e:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203e12:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203e16:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203e1a:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203e1e:	0005b083          	ld	ra,0(a1) # 80000 <_binary_obj___user_matrix_out_size+0x738a0>
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0203e22:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0203e26:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203e28:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203e2a:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203e2e:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0203e32:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0203e36:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203e3a:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203e3e:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0203e42:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0203e46:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203e4a:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203e4e:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0203e52:	8082                	ret

ffffffffc0203e54 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203e54:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203e56:	9402                	jalr	s0

	jal do_exit
ffffffffc0203e58:	5c4000ef          	jal	ra,ffffffffc020441c <do_exit>

ffffffffc0203e5c <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203e5c:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203e5e:	14800513          	li	a0,328
{
ffffffffc0203e62:	e022                	sd	s0,0(sp)
ffffffffc0203e64:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203e66:	af9fd0ef          	jal	ra,ffffffffc020195e <kmalloc>
ffffffffc0203e6a:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203e6c:	c551                	beqz	a0,ffffffffc0203ef8 <alloc_proc+0x9c>
         *       skew_heap_entry_t lab6_run_pool;            // entry in the run pool (lab6 stride)
         *       uint32_t lab6_stride;                       // stride value (lab6 stride)
         *       uint32_t lab6_priority;                     // priority value (lab6 stride)
         */
        // LAB4原有
        proc->state = PROC_UNINIT;
ffffffffc0203e6e:	57fd                	li	a5,-1
ffffffffc0203e70:	1782                	slli	a5,a5,0x20
ffffffffc0203e72:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203e74:	07000613          	li	a2,112
ffffffffc0203e78:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203e7a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203e7e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203e82:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203e86:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203e8a:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203e8e:	03050513          	addi	a0,a0,48
ffffffffc0203e92:	6a4010ef          	jal	ra,ffffffffc0205536 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203e96:	000c3797          	auipc	a5,0xc3
ffffffffc0203e9a:	23a7b783          	ld	a5,570(a5) # ffffffffc02c70d0 <boot_pgdir_pa>
ffffffffc0203e9e:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203ea0:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203ea4:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN+1);
ffffffffc0203ea8:	4641                	li	a2,16
ffffffffc0203eaa:	4581                	li	a1,0
ffffffffc0203eac:	0b440513          	addi	a0,s0,180
ffffffffc0203eb0:	686010ef          	jal	ra,ffffffffc0205536 <memset>
        list_init(&(proc->list_link));
ffffffffc0203eb4:	0c840693          	addi	a3,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203eb8:	0d840713          	addi	a4,s0,216
        proc->optr = NULL;
        proc->yptr = NULL;

        // Lab6新增
        proc->rq = NULL;
        list_init(&(proc->run_link));
ffffffffc0203ebc:	11040793          	addi	a5,s0,272
    elm->prev = elm->next = elm;
ffffffffc0203ec0:	e874                	sd	a3,208(s0)
ffffffffc0203ec2:	e474                	sd	a3,200(s0)
ffffffffc0203ec4:	f078                	sd	a4,224(s0)
ffffffffc0203ec6:	ec78                	sd	a4,216(s0)
        proc->wait_state = 0;
ffffffffc0203ec8:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;
ffffffffc0203ecc:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc0203ed0:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0203ed4:	0e043c23          	sd	zero,248(s0)
        proc->rq = NULL;
ffffffffc0203ed8:	10043423          	sd	zero,264(s0)
ffffffffc0203edc:	10f43c23          	sd	a5,280(s0)
ffffffffc0203ee0:	10f43823          	sd	a5,272(s0)
        proc->time_slice = 0;
ffffffffc0203ee4:	12042023          	sw	zero,288(s0)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
ffffffffc0203ee8:	12043423          	sd	zero,296(s0)
ffffffffc0203eec:	12043823          	sd	zero,304(s0)
ffffffffc0203ef0:	12043c23          	sd	zero,312(s0)
        skew_heap_init(&(proc->lab6_run_pool));
        proc->lab6_stride = 0;
ffffffffc0203ef4:	14043023          	sd	zero,320(s0)
        proc->lab6_priority = 0;
    }
    return proc;
}
ffffffffc0203ef8:	60a2                	ld	ra,8(sp)
ffffffffc0203efa:	8522                	mv	a0,s0
ffffffffc0203efc:	6402                	ld	s0,0(sp)
ffffffffc0203efe:	0141                	addi	sp,sp,16
ffffffffc0203f00:	8082                	ret

ffffffffc0203f02 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203f02:	000c3797          	auipc	a5,0xc3
ffffffffc0203f06:	1fe7b783          	ld	a5,510(a5) # ffffffffc02c7100 <current>
ffffffffc0203f0a:	73c8                	ld	a0,160(a5)
ffffffffc0203f0c:	8eefd06f          	j	ffffffffc0200ffa <forkrets>

ffffffffc0203f10 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203f10:	6d14                	ld	a3,24(a0)
}

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm)
{
ffffffffc0203f12:	1141                	addi	sp,sp,-16
ffffffffc0203f14:	e406                	sd	ra,8(sp)
ffffffffc0203f16:	c02007b7          	lui	a5,0xc0200
ffffffffc0203f1a:	02f6ee63          	bltu	a3,a5,ffffffffc0203f56 <put_pgdir+0x46>
ffffffffc0203f1e:	000c3517          	auipc	a0,0xc3
ffffffffc0203f22:	1da53503          	ld	a0,474(a0) # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0203f26:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203f28:	82b1                	srli	a3,a3,0xc
ffffffffc0203f2a:	000c3797          	auipc	a5,0xc3
ffffffffc0203f2e:	1b67b783          	ld	a5,438(a5) # ffffffffc02c70e0 <npage>
ffffffffc0203f32:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f6e <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f36:	00004517          	auipc	a0,0x4
ffffffffc0203f3a:	39a53503          	ld	a0,922(a0) # ffffffffc02082d0 <nbase>
    free_page(kva2page(mm->pgdir));
}
ffffffffc0203f3e:	60a2                	ld	ra,8(sp)
ffffffffc0203f40:	8e89                	sub	a3,a3,a0
ffffffffc0203f42:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203f44:	000c3517          	auipc	a0,0xc3
ffffffffc0203f48:	1a453503          	ld	a0,420(a0) # ffffffffc02c70e8 <pages>
ffffffffc0203f4c:	4585                	li	a1,1
ffffffffc0203f4e:	9536                	add	a0,a0,a3
}
ffffffffc0203f50:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203f52:	ed6fe06f          	j	ffffffffc0202628 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f56:	00003617          	auipc	a2,0x3
ffffffffc0203f5a:	83260613          	addi	a2,a2,-1998 # ffffffffc0206788 <commands+0xb78>
ffffffffc0203f5e:	07700593          	li	a1,119
ffffffffc0203f62:	00002517          	auipc	a0,0x2
ffffffffc0203f66:	7a650513          	addi	a0,a0,1958 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0203f6a:	ab8fc0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f6e:	00003617          	auipc	a2,0x3
ffffffffc0203f72:	84260613          	addi	a2,a2,-1982 # ffffffffc02067b0 <commands+0xba0>
ffffffffc0203f76:	06900593          	li	a1,105
ffffffffc0203f7a:	00002517          	auipc	a0,0x2
ffffffffc0203f7e:	78e50513          	addi	a0,a0,1934 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0203f82:	aa0fc0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0203f86 <proc_run>:
{
ffffffffc0203f86:	7179                	addi	sp,sp,-48
ffffffffc0203f88:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203f8a:	000c3917          	auipc	s2,0xc3
ffffffffc0203f8e:	17690913          	addi	s2,s2,374 # ffffffffc02c7100 <current>
{
ffffffffc0203f92:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203f94:	00093483          	ld	s1,0(s2)
{
ffffffffc0203f98:	f406                	sd	ra,40(sp)
ffffffffc0203f9a:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203f9c:	02a48d63          	beq	s1,a0,ffffffffc0203fd6 <proc_run+0x50>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203fa0:	100027f3          	csrr	a5,sstatus
ffffffffc0203fa4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203fa6:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203fa8:	e7a1                	bnez	a5,ffffffffc0203ff0 <proc_run+0x6a>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203faa:	755c                	ld	a5,168(a0)
ffffffffc0203fac:	577d                	li	a4,-1
ffffffffc0203fae:	177e                	slli	a4,a4,0x3f
ffffffffc0203fb0:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc0203fb2:	00a93023          	sd	a0,0(s2)
ffffffffc0203fb6:	8fd9                	or	a5,a5,a4
ffffffffc0203fb8:	18079073          	csrw	satp,a5
        proc->runs++;
ffffffffc0203fbc:	451c                	lw	a5,8(a0)
        proc->need_resched = 0;
ffffffffc0203fbe:	00053c23          	sd	zero,24(a0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc0203fc2:	03050593          	addi	a1,a0,48
        proc->runs++;
ffffffffc0203fc6:	2785                	addiw	a5,a5,1
ffffffffc0203fc8:	c51c                	sw	a5,8(a0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc0203fca:	03048513          	addi	a0,s1,48
ffffffffc0203fce:	e1dff0ef          	jal	ra,ffffffffc0203dea <switch_to>
    if (flag)
ffffffffc0203fd2:	00099863          	bnez	s3,ffffffffc0203fe2 <proc_run+0x5c>
}
ffffffffc0203fd6:	70a2                	ld	ra,40(sp)
ffffffffc0203fd8:	7482                	ld	s1,32(sp)
ffffffffc0203fda:	6962                	ld	s2,24(sp)
ffffffffc0203fdc:	69c2                	ld	s3,16(sp)
ffffffffc0203fde:	6145                	addi	sp,sp,48
ffffffffc0203fe0:	8082                	ret
ffffffffc0203fe2:	70a2                	ld	ra,40(sp)
ffffffffc0203fe4:	7482                	ld	s1,32(sp)
ffffffffc0203fe6:	6962                	ld	s2,24(sp)
ffffffffc0203fe8:	69c2                	ld	s3,16(sp)
ffffffffc0203fea:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203fec:	9c3fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc0203ff0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203ff2:	9c3fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0203ff6:	6522                	ld	a0,8(sp)
ffffffffc0203ff8:	4985                	li	s3,1
ffffffffc0203ffa:	bf45                	j	ffffffffc0203faa <proc_run+0x24>

ffffffffc0203ffc <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
ffffffffc0203ffc:	7119                	addi	sp,sp,-128
ffffffffc0203ffe:	f0ca                	sd	s2,96(sp)
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS)
ffffffffc0204000:	000c3917          	auipc	s2,0xc3
ffffffffc0204004:	11890913          	addi	s2,s2,280 # ffffffffc02c7118 <nr_process>
ffffffffc0204008:	00092703          	lw	a4,0(s2)
{
ffffffffc020400c:	fc86                	sd	ra,120(sp)
ffffffffc020400e:	f8a2                	sd	s0,112(sp)
ffffffffc0204010:	f4a6                	sd	s1,104(sp)
ffffffffc0204012:	ecce                	sd	s3,88(sp)
ffffffffc0204014:	e8d2                	sd	s4,80(sp)
ffffffffc0204016:	e4d6                	sd	s5,72(sp)
ffffffffc0204018:	e0da                	sd	s6,64(sp)
ffffffffc020401a:	fc5e                	sd	s7,56(sp)
ffffffffc020401c:	f862                	sd	s8,48(sp)
ffffffffc020401e:	f466                	sd	s9,40(sp)
ffffffffc0204020:	f06a                	sd	s10,32(sp)
ffffffffc0204022:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204024:	6785                	lui	a5,0x1
ffffffffc0204026:	30f75163          	bge	a4,a5,ffffffffc0204328 <do_fork+0x32c>
ffffffffc020402a:	8a2a                	mv	s4,a0
ffffffffc020402c:	89ae                	mv	s3,a1
ffffffffc020402e:	8432                	mv	s0,a2
     *    set_links:  set the relation links of process.  ALSO SEE: remove_links:  lean the relation links of process
     *    -------------------
     *    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
     *    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
     */
    proc = alloc_proc();
ffffffffc0204030:	e2dff0ef          	jal	ra,ffffffffc0203e5c <alloc_proc>
ffffffffc0204034:	84aa                	mv	s1,a0
    if(proc==NULL)
ffffffffc0204036:	2c050d63          	beqz	a0,ffffffffc0204310 <do_fork+0x314>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020403a:	4509                	li	a0,2
ffffffffc020403c:	daefe0ef          	jal	ra,ffffffffc02025ea <alloc_pages>
    if (page != NULL)
ffffffffc0204040:	2c050563          	beqz	a0,ffffffffc020430a <do_fork+0x30e>
    return page - pages + nbase;
ffffffffc0204044:	000c3a97          	auipc	s5,0xc3
ffffffffc0204048:	0a4a8a93          	addi	s5,s5,164 # ffffffffc02c70e8 <pages>
ffffffffc020404c:	000ab683          	ld	a3,0(s5)
ffffffffc0204050:	00004797          	auipc	a5,0x4
ffffffffc0204054:	28078793          	addi	a5,a5,640 # ffffffffc02082d0 <nbase>
ffffffffc0204058:	6398                	ld	a4,0(a5)
ffffffffc020405a:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc020405e:	000c3b97          	auipc	s7,0xc3
ffffffffc0204062:	082b8b93          	addi	s7,s7,130 # ffffffffc02c70e0 <npage>
    return page - pages + nbase;
ffffffffc0204066:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204068:	57fd                	li	a5,-1
ffffffffc020406a:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc020406e:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0204070:	00c7db13          	srli	s6,a5,0xc
ffffffffc0204074:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0204078:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020407a:	2ac5fc63          	bgeu	a1,a2,ffffffffc0204332 <do_fork+0x336>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc020407e:	000c3c97          	auipc	s9,0xc3
ffffffffc0204082:	082c8c93          	addi	s9,s9,130 # ffffffffc02c7100 <current>
ffffffffc0204086:	000cb303          	ld	t1,0(s9)
ffffffffc020408a:	000c3c17          	auipc	s8,0xc3
ffffffffc020408e:	06ec0c13          	addi	s8,s8,110 # ffffffffc02c70f8 <va_pa_offset>
ffffffffc0204092:	000c3603          	ld	a2,0(s8)
ffffffffc0204096:	02833d83          	ld	s11,40(t1) # 80028 <_binary_obj___user_matrix_out_size+0x738c8>
ffffffffc020409a:	e43a                	sd	a4,8(sp)
ffffffffc020409c:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020409e:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc02040a0:	020d8a63          	beqz	s11,ffffffffc02040d4 <do_fork+0xd8>
    if (clone_flags & CLONE_VM)
ffffffffc02040a4:	100a7a13          	andi	s4,s4,256
ffffffffc02040a8:	1a0a0063          	beqz	s4,ffffffffc0204248 <do_fork+0x24c>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc02040ac:	030da703          	lw	a4,48(s11)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040b0:	018db783          	ld	a5,24(s11)
ffffffffc02040b4:	c02006b7          	lui	a3,0xc0200
ffffffffc02040b8:	2705                	addiw	a4,a4,1
ffffffffc02040ba:	02eda823          	sw	a4,48(s11)
    proc->mm = mm;
ffffffffc02040be:	03b4b423          	sd	s11,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040c2:	2cd7ec63          	bltu	a5,a3,ffffffffc020439a <do_fork+0x39e>
ffffffffc02040c6:	000c3703          	ld	a4,0(s8)
        goto bad_fork_cleanup_proc;
    if(copy_mm(clone_flags, proc)!=0)
        goto bad_fork_cleanup_kstack;

    copy_thread(proc, stack, tf);
    proc->parent = current;
ffffffffc02040ca:	000cb303          	ld	t1,0(s9)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040ce:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040d0:	8f99                	sub	a5,a5,a4
ffffffffc02040d2:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040d4:	6789                	lui	a5,0x2
ffffffffc02040d6:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x80b8>
ffffffffc02040da:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02040dc:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040de:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02040e0:	87b6                	mv	a5,a3
ffffffffc02040e2:	12040893          	addi	a7,s0,288
ffffffffc02040e6:	00063803          	ld	a6,0(a2)
ffffffffc02040ea:	6608                	ld	a0,8(a2)
ffffffffc02040ec:	6a0c                	ld	a1,16(a2)
ffffffffc02040ee:	6e18                	ld	a4,24(a2)
ffffffffc02040f0:	0107b023          	sd	a6,0(a5)
ffffffffc02040f4:	e788                	sd	a0,8(a5)
ffffffffc02040f6:	eb8c                	sd	a1,16(a5)
ffffffffc02040f8:	ef98                	sd	a4,24(a5)
ffffffffc02040fa:	02060613          	addi	a2,a2,32
ffffffffc02040fe:	02078793          	addi	a5,a5,32
ffffffffc0204102:	ff1612e3          	bne	a2,a7,ffffffffc02040e6 <do_fork+0xea>
    proc->tf->gpr.a0 = 0;
ffffffffc0204106:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020410a:	12098d63          	beqz	s3,ffffffffc0204244 <do_fork+0x248>
    assert(current->wait_state == 0);
ffffffffc020410e:	0ec32783          	lw	a5,236(t1)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204112:	00000717          	auipc	a4,0x0
ffffffffc0204116:	df070713          	addi	a4,a4,-528 # ffffffffc0203f02 <forkret>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020411a:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020411e:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204120:	fc94                	sd	a3,56(s1)
    proc->parent = current;
ffffffffc0204122:	0264b023          	sd	t1,32(s1)
    assert(current->wait_state == 0);
ffffffffc0204126:	22079263          	bnez	a5,ffffffffc020434a <do_fork+0x34e>
    if (++last_pid >= MAX_PID)
ffffffffc020412a:	000bf817          	auipc	a6,0xbf
ffffffffc020412e:	b1e80813          	addi	a6,a6,-1250 # ffffffffc02c2c48 <last_pid.1>
ffffffffc0204132:	00082783          	lw	a5,0(a6)
ffffffffc0204136:	6709                	lui	a4,0x2
ffffffffc0204138:	0017851b          	addiw	a0,a5,1
ffffffffc020413c:	00a82023          	sw	a0,0(a6)
ffffffffc0204140:	08e55b63          	bge	a0,a4,ffffffffc02041d6 <do_fork+0x1da>
    if (last_pid >= next_safe)
ffffffffc0204144:	000bf317          	auipc	t1,0xbf
ffffffffc0204148:	b0830313          	addi	t1,t1,-1272 # ffffffffc02c2c4c <next_safe.0>
ffffffffc020414c:	00032783          	lw	a5,0(t1)
ffffffffc0204150:	000c3417          	auipc	s0,0xc3
ffffffffc0204154:	f1840413          	addi	s0,s0,-232 # ffffffffc02c7068 <proc_list>
ffffffffc0204158:	08f55763          	bge	a0,a5,ffffffffc02041e6 <do_fork+0x1ea>
    
    proc->pid = get_pid();
ffffffffc020415c:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020415e:	45a9                	li	a1,10
ffffffffc0204160:	2501                	sext.w	a0,a0
ffffffffc0204162:	7ec010ef          	jal	ra,ffffffffc020594e <hash32>
ffffffffc0204166:	02051793          	slli	a5,a0,0x20
ffffffffc020416a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020416e:	000bf797          	auipc	a5,0xbf
ffffffffc0204172:	efa78793          	addi	a5,a5,-262 # ffffffffc02c3068 <hash_list>
ffffffffc0204176:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204178:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020417a:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020417c:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc0204180:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204182:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0204184:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204186:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204188:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc020418c:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc020418e:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc0204190:	e21c                	sd	a5,0(a2)
ffffffffc0204192:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0204194:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204196:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204198:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020419c:	10e4b023          	sd	a4,256(s1)
ffffffffc02041a0:	c311                	beqz	a4,ffffffffc02041a4 <do_fork+0x1a8>
        proc->optr->yptr = proc;
ffffffffc02041a2:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc02041a4:	00092783          	lw	a5,0(s2)
    hash_proc(proc);
    set_links(proc);

    wakeup_proc(proc);
ffffffffc02041a8:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc02041aa:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc02041ac:	2785                	addiw	a5,a5,1
ffffffffc02041ae:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02041b2:	789000ef          	jal	ra,ffffffffc020513a <wakeup_proc>

    ret = proc->pid;
ffffffffc02041b6:	40c8                	lw	a0,4(s1)
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
ffffffffc02041b8:	70e6                	ld	ra,120(sp)
ffffffffc02041ba:	7446                	ld	s0,112(sp)
ffffffffc02041bc:	74a6                	ld	s1,104(sp)
ffffffffc02041be:	7906                	ld	s2,96(sp)
ffffffffc02041c0:	69e6                	ld	s3,88(sp)
ffffffffc02041c2:	6a46                	ld	s4,80(sp)
ffffffffc02041c4:	6aa6                	ld	s5,72(sp)
ffffffffc02041c6:	6b06                	ld	s6,64(sp)
ffffffffc02041c8:	7be2                	ld	s7,56(sp)
ffffffffc02041ca:	7c42                	ld	s8,48(sp)
ffffffffc02041cc:	7ca2                	ld	s9,40(sp)
ffffffffc02041ce:	7d02                	ld	s10,32(sp)
ffffffffc02041d0:	6de2                	ld	s11,24(sp)
ffffffffc02041d2:	6109                	addi	sp,sp,128
ffffffffc02041d4:	8082                	ret
        last_pid = 1;
ffffffffc02041d6:	4785                	li	a5,1
ffffffffc02041d8:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02041dc:	4505                	li	a0,1
ffffffffc02041de:	000bf317          	auipc	t1,0xbf
ffffffffc02041e2:	a6e30313          	addi	t1,t1,-1426 # ffffffffc02c2c4c <next_safe.0>
    return listelm->next;
ffffffffc02041e6:	000c3417          	auipc	s0,0xc3
ffffffffc02041ea:	e8240413          	addi	s0,s0,-382 # ffffffffc02c7068 <proc_list>
ffffffffc02041ee:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02041f2:	6789                	lui	a5,0x2
ffffffffc02041f4:	00f32023          	sw	a5,0(t1)
ffffffffc02041f8:	86aa                	mv	a3,a0
ffffffffc02041fa:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02041fc:	6e89                	lui	t4,0x2
ffffffffc02041fe:	128e0063          	beq	t3,s0,ffffffffc020431e <do_fork+0x322>
ffffffffc0204202:	88ae                	mv	a7,a1
ffffffffc0204204:	87f2                	mv	a5,t3
ffffffffc0204206:	6609                	lui	a2,0x2
ffffffffc0204208:	a811                	j	ffffffffc020421c <do_fork+0x220>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020420a:	00e6d663          	bge	a3,a4,ffffffffc0204216 <do_fork+0x21a>
ffffffffc020420e:	00c75463          	bge	a4,a2,ffffffffc0204216 <do_fork+0x21a>
ffffffffc0204212:	863a                	mv	a2,a4
ffffffffc0204214:	4885                	li	a7,1
ffffffffc0204216:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204218:	00878d63          	beq	a5,s0,ffffffffc0204232 <do_fork+0x236>
            if (proc->pid == last_pid)
ffffffffc020421c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x805c>
ffffffffc0204220:	fed715e3          	bne	a4,a3,ffffffffc020420a <do_fork+0x20e>
                if (++last_pid >= next_safe)
ffffffffc0204224:	2685                	addiw	a3,a3,1
ffffffffc0204226:	0ec6d763          	bge	a3,a2,ffffffffc0204314 <do_fork+0x318>
ffffffffc020422a:	679c                	ld	a5,8(a5)
ffffffffc020422c:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020422e:	fe8797e3          	bne	a5,s0,ffffffffc020421c <do_fork+0x220>
ffffffffc0204232:	c581                	beqz	a1,ffffffffc020423a <do_fork+0x23e>
ffffffffc0204234:	00d82023          	sw	a3,0(a6)
ffffffffc0204238:	8536                	mv	a0,a3
ffffffffc020423a:	f20881e3          	beqz	a7,ffffffffc020415c <do_fork+0x160>
ffffffffc020423e:	00c32023          	sw	a2,0(t1)
ffffffffc0204242:	bf29                	j	ffffffffc020415c <do_fork+0x160>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204244:	89b6                	mv	s3,a3
ffffffffc0204246:	b5e1                	j	ffffffffc020410e <do_fork+0x112>
    if ((mm = mm_create()) == NULL)
ffffffffc0204248:	ddbfc0ef          	jal	ra,ffffffffc0201022 <mm_create>
ffffffffc020424c:	8d2a                	mv	s10,a0
ffffffffc020424e:	c159                	beqz	a0,ffffffffc02042d4 <do_fork+0x2d8>
    if ((page = alloc_page()) == NULL)
ffffffffc0204250:	4505                	li	a0,1
ffffffffc0204252:	b98fe0ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0204256:	cd25                	beqz	a0,ffffffffc02042ce <do_fork+0x2d2>
    return page - pages + nbase;
ffffffffc0204258:	000ab683          	ld	a3,0(s5)
ffffffffc020425c:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc020425e:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc0204262:	40d506b3          	sub	a3,a0,a3
ffffffffc0204266:	8699                	srai	a3,a3,0x6
ffffffffc0204268:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc020426a:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020426e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204270:	0cc7f163          	bgeu	a5,a2,ffffffffc0204332 <do_fork+0x336>
ffffffffc0204274:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204278:	6605                	lui	a2,0x1
ffffffffc020427a:	000c3597          	auipc	a1,0xc3
ffffffffc020427e:	e5e5b583          	ld	a1,-418(a1) # ffffffffc02c70d8 <boot_pgdir_va>
ffffffffc0204282:	9a36                	add	s4,s4,a3
ffffffffc0204284:	8552                	mv	a0,s4
ffffffffc0204286:	2c2010ef          	jal	ra,ffffffffc0205548 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc020428a:	038d8b13          	addi	s6,s11,56
    mm->pgdir = pgdir;
ffffffffc020428e:	014d3c23          	sd	s4,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204292:	4785                	li	a5,1
ffffffffc0204294:	40fb37af          	amoor.d	a5,a5,(s6)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204298:	8b85                	andi	a5,a5,1
ffffffffc020429a:	4a05                	li	s4,1
ffffffffc020429c:	c799                	beqz	a5,ffffffffc02042aa <do_fork+0x2ae>
    {
        schedule();
ffffffffc020429e:	74f000ef          	jal	ra,ffffffffc02051ec <schedule>
ffffffffc02042a2:	414b37af          	amoor.d	a5,s4,(s6)
    while (!try_lock(lock))
ffffffffc02042a6:	8b85                	andi	a5,a5,1
ffffffffc02042a8:	fbfd                	bnez	a5,ffffffffc020429e <do_fork+0x2a2>
        ret = dup_mmap(mm, oldmm);
ffffffffc02042aa:	85ee                	mv	a1,s11
ffffffffc02042ac:	856a                	mv	a0,s10
ffffffffc02042ae:	fb7fc0ef          	jal	ra,ffffffffc0201264 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02042b2:	57f9                	li	a5,-2
ffffffffc02042b4:	60fb37af          	amoand.d	a5,a5,(s6)
ffffffffc02042b8:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02042ba:	c7e1                	beqz	a5,ffffffffc0204382 <do_fork+0x386>
good_mm:
ffffffffc02042bc:	8dea                	mv	s11,s10
    if (ret != 0)
ffffffffc02042be:	de0507e3          	beqz	a0,ffffffffc02040ac <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc02042c2:	856a                	mv	a0,s10
ffffffffc02042c4:	83afd0ef          	jal	ra,ffffffffc02012fe <exit_mmap>
    put_pgdir(mm);
ffffffffc02042c8:	856a                	mv	a0,s10
ffffffffc02042ca:	c47ff0ef          	jal	ra,ffffffffc0203f10 <put_pgdir>
    mm_destroy(mm);
ffffffffc02042ce:	856a                	mv	a0,s10
ffffffffc02042d0:	e93fc0ef          	jal	ra,ffffffffc0201162 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02042d4:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02042d6:	c02007b7          	lui	a5,0xc0200
ffffffffc02042da:	0cf6ed63          	bltu	a3,a5,ffffffffc02043b4 <do_fork+0x3b8>
ffffffffc02042de:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02042e2:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02042e6:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02042ea:	83b1                	srli	a5,a5,0xc
ffffffffc02042ec:	06e7ff63          	bgeu	a5,a4,ffffffffc020436a <do_fork+0x36e>
    return &pages[PPN(pa) - nbase];
ffffffffc02042f0:	00004717          	auipc	a4,0x4
ffffffffc02042f4:	fe070713          	addi	a4,a4,-32 # ffffffffc02082d0 <nbase>
ffffffffc02042f8:	6318                	ld	a4,0(a4)
ffffffffc02042fa:	000ab503          	ld	a0,0(s5)
ffffffffc02042fe:	4589                	li	a1,2
ffffffffc0204300:	8f99                	sub	a5,a5,a4
ffffffffc0204302:	079a                	slli	a5,a5,0x6
ffffffffc0204304:	953e                	add	a0,a0,a5
ffffffffc0204306:	b22fe0ef          	jal	ra,ffffffffc0202628 <free_pages>
    kfree(proc);
ffffffffc020430a:	8526                	mv	a0,s1
ffffffffc020430c:	f02fd0ef          	jal	ra,ffffffffc0201a0e <kfree>
    ret = -E_NO_MEM;
ffffffffc0204310:	5571                	li	a0,-4
    return ret;
ffffffffc0204312:	b55d                	j	ffffffffc02041b8 <do_fork+0x1bc>
                    if (last_pid >= MAX_PID)
ffffffffc0204314:	01d6c363          	blt	a3,t4,ffffffffc020431a <do_fork+0x31e>
                        last_pid = 1;
ffffffffc0204318:	4685                	li	a3,1
                    goto repeat;
ffffffffc020431a:	4585                	li	a1,1
ffffffffc020431c:	b5cd                	j	ffffffffc02041fe <do_fork+0x202>
ffffffffc020431e:	c599                	beqz	a1,ffffffffc020432c <do_fork+0x330>
ffffffffc0204320:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204324:	8536                	mv	a0,a3
ffffffffc0204326:	bd1d                	j	ffffffffc020415c <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204328:	556d                	li	a0,-5
ffffffffc020432a:	b579                	j	ffffffffc02041b8 <do_fork+0x1bc>
    return last_pid;
ffffffffc020432c:	00082503          	lw	a0,0(a6)
ffffffffc0204330:	b535                	j	ffffffffc020415c <do_fork+0x160>
    return KADDR(page2pa(page));
ffffffffc0204332:	00002617          	auipc	a2,0x2
ffffffffc0204336:	3ae60613          	addi	a2,a2,942 # ffffffffc02066e0 <commands+0xad0>
ffffffffc020433a:	07100593          	li	a1,113
ffffffffc020433e:	00002517          	auipc	a0,0x2
ffffffffc0204342:	3ca50513          	addi	a0,a0,970 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0204346:	eddfb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(current->wait_state == 0);
ffffffffc020434a:	00003697          	auipc	a3,0x3
ffffffffc020434e:	f0668693          	addi	a3,a3,-250 # ffffffffc0207250 <default_pmm_manager+0x6d8>
ffffffffc0204352:	00002617          	auipc	a2,0x2
ffffffffc0204356:	11660613          	addi	a2,a2,278 # ffffffffc0206468 <commands+0x858>
ffffffffc020435a:	1fa00593          	li	a1,506
ffffffffc020435e:	00003517          	auipc	a0,0x3
ffffffffc0204362:	eda50513          	addi	a0,a0,-294 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204366:	ebdfb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020436a:	00002617          	auipc	a2,0x2
ffffffffc020436e:	44660613          	addi	a2,a2,1094 # ffffffffc02067b0 <commands+0xba0>
ffffffffc0204372:	06900593          	li	a1,105
ffffffffc0204376:	00002517          	auipc	a0,0x2
ffffffffc020437a:	39250513          	addi	a0,a0,914 # ffffffffc0206708 <commands+0xaf8>
ffffffffc020437e:	ea5fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc0204382:	00003617          	auipc	a2,0x3
ffffffffc0204386:	e8e60613          	addi	a2,a2,-370 # ffffffffc0207210 <default_pmm_manager+0x698>
ffffffffc020438a:	04000593          	li	a1,64
ffffffffc020438e:	00003517          	auipc	a0,0x3
ffffffffc0204392:	e9250513          	addi	a0,a0,-366 # ffffffffc0207220 <default_pmm_manager+0x6a8>
ffffffffc0204396:	e8dfb0ef          	jal	ra,ffffffffc0200222 <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020439a:	86be                	mv	a3,a5
ffffffffc020439c:	00002617          	auipc	a2,0x2
ffffffffc02043a0:	3ec60613          	addi	a2,a2,1004 # ffffffffc0206788 <commands+0xb78>
ffffffffc02043a4:	1a600593          	li	a1,422
ffffffffc02043a8:	00003517          	auipc	a0,0x3
ffffffffc02043ac:	e9050513          	addi	a0,a0,-368 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc02043b0:	e73fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02043b4:	00002617          	auipc	a2,0x2
ffffffffc02043b8:	3d460613          	addi	a2,a2,980 # ffffffffc0206788 <commands+0xb78>
ffffffffc02043bc:	07700593          	li	a1,119
ffffffffc02043c0:	00002517          	auipc	a0,0x2
ffffffffc02043c4:	34850513          	addi	a0,a0,840 # ffffffffc0206708 <commands+0xaf8>
ffffffffc02043c8:	e5bfb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02043cc <kernel_thread>:
{
ffffffffc02043cc:	7129                	addi	sp,sp,-320
ffffffffc02043ce:	fa22                	sd	s0,304(sp)
ffffffffc02043d0:	f626                	sd	s1,296(sp)
ffffffffc02043d2:	f24a                	sd	s2,288(sp)
ffffffffc02043d4:	84ae                	mv	s1,a1
ffffffffc02043d6:	892a                	mv	s2,a0
ffffffffc02043d8:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043da:	4581                	li	a1,0
ffffffffc02043dc:	12000613          	li	a2,288
ffffffffc02043e0:	850a                	mv	a0,sp
{
ffffffffc02043e2:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043e4:	152010ef          	jal	ra,ffffffffc0205536 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02043e8:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02043ea:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02043ec:	100027f3          	csrr	a5,sstatus
ffffffffc02043f0:	edd7f793          	andi	a5,a5,-291
ffffffffc02043f4:	1207e793          	ori	a5,a5,288
ffffffffc02043f8:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043fa:	860a                	mv	a2,sp
ffffffffc02043fc:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204400:	00000797          	auipc	a5,0x0
ffffffffc0204404:	a5478793          	addi	a5,a5,-1452 # ffffffffc0203e54 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204408:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020440a:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020440c:	bf1ff0ef          	jal	ra,ffffffffc0203ffc <do_fork>
}
ffffffffc0204410:	70f2                	ld	ra,312(sp)
ffffffffc0204412:	7452                	ld	s0,304(sp)
ffffffffc0204414:	74b2                	ld	s1,296(sp)
ffffffffc0204416:	7912                	ld	s2,288(sp)
ffffffffc0204418:	6131                	addi	sp,sp,320
ffffffffc020441a:	8082                	ret

ffffffffc020441c <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int do_exit(int error_code)
{
ffffffffc020441c:	7179                	addi	sp,sp,-48
ffffffffc020441e:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204420:	000c3417          	auipc	s0,0xc3
ffffffffc0204424:	ce040413          	addi	s0,s0,-800 # ffffffffc02c7100 <current>
ffffffffc0204428:	601c                	ld	a5,0(s0)
{
ffffffffc020442a:	f406                	sd	ra,40(sp)
ffffffffc020442c:	ec26                	sd	s1,24(sp)
ffffffffc020442e:	e84a                	sd	s2,16(sp)
ffffffffc0204430:	e44e                	sd	s3,8(sp)
ffffffffc0204432:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204434:	000c3717          	auipc	a4,0xc3
ffffffffc0204438:	cd473703          	ld	a4,-812(a4) # ffffffffc02c7108 <idleproc>
ffffffffc020443c:	0ce78c63          	beq	a5,a4,ffffffffc0204514 <do_exit+0xf8>
    {
        panic("idleproc exit.\n");
    }
    if (current == initproc)
ffffffffc0204440:	000c3497          	auipc	s1,0xc3
ffffffffc0204444:	cd048493          	addi	s1,s1,-816 # ffffffffc02c7110 <initproc>
ffffffffc0204448:	6098                	ld	a4,0(s1)
ffffffffc020444a:	0ee78b63          	beq	a5,a4,ffffffffc0204540 <do_exit+0x124>
    {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
ffffffffc020444e:	0287b983          	ld	s3,40(a5)
ffffffffc0204452:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204454:	02098663          	beqz	s3,ffffffffc0204480 <do_exit+0x64>
ffffffffc0204458:	000c3797          	auipc	a5,0xc3
ffffffffc020445c:	c787b783          	ld	a5,-904(a5) # ffffffffc02c70d0 <boot_pgdir_pa>
ffffffffc0204460:	577d                	li	a4,-1
ffffffffc0204462:	177e                	slli	a4,a4,0x3f
ffffffffc0204464:	83b1                	srli	a5,a5,0xc
ffffffffc0204466:	8fd9                	or	a5,a5,a4
ffffffffc0204468:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020446c:	0309a783          	lw	a5,48(s3)
ffffffffc0204470:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204474:	02e9a823          	sw	a4,48(s3)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
ffffffffc0204478:	cb55                	beqz	a4,ffffffffc020452c <do_exit+0x110>
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
ffffffffc020447a:	601c                	ld	a5,0(s0)
ffffffffc020447c:	0207b423          	sd	zero,40(a5)
    }
    current->state = PROC_ZOMBIE;
ffffffffc0204480:	601c                	ld	a5,0(s0)
ffffffffc0204482:	470d                	li	a4,3
ffffffffc0204484:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204486:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020448a:	100027f3          	csrr	a5,sstatus
ffffffffc020448e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204490:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204492:	e3f9                	bnez	a5,ffffffffc0204558 <do_exit+0x13c>
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
ffffffffc0204494:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204496:	800007b7          	lui	a5,0x80000
ffffffffc020449a:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc020449c:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc020449e:	0ec52703          	lw	a4,236(a0)
ffffffffc02044a2:	0af70f63          	beq	a4,a5,ffffffffc0204560 <do_exit+0x144>
        {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL)
ffffffffc02044a6:	6018                	ld	a4,0(s0)
ffffffffc02044a8:	7b7c                	ld	a5,240(a4)
ffffffffc02044aa:	c3a1                	beqz	a5,ffffffffc02044ea <do_exit+0xce>
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE)
            {
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044ac:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044b0:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044b2:	0985                	addi	s3,s3,1
ffffffffc02044b4:	a021                	j	ffffffffc02044bc <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02044b6:	6018                	ld	a4,0(s0)
ffffffffc02044b8:	7b7c                	ld	a5,240(a4)
ffffffffc02044ba:	cb85                	beqz	a5,ffffffffc02044ea <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02044bc:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_matrix_out_size+0xffffffff7fff39a0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044c0:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02044c2:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044c4:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02044c6:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044ca:	10e7b023          	sd	a4,256(a5)
ffffffffc02044ce:	c311                	beqz	a4,ffffffffc02044d2 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02044d0:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044d2:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02044d4:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02044d6:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044d8:	fd271fe3          	bne	a4,s2,ffffffffc02044b6 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044dc:	0ec52783          	lw	a5,236(a0)
ffffffffc02044e0:	fd379be3          	bne	a5,s3,ffffffffc02044b6 <do_exit+0x9a>
                {
                    wakeup_proc(initproc);
ffffffffc02044e4:	457000ef          	jal	ra,ffffffffc020513a <wakeup_proc>
ffffffffc02044e8:	b7f9                	j	ffffffffc02044b6 <do_exit+0x9a>
    if (flag)
ffffffffc02044ea:	020a1263          	bnez	s4,ffffffffc020450e <do_exit+0xf2>
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
ffffffffc02044ee:	4ff000ef          	jal	ra,ffffffffc02051ec <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02044f2:	601c                	ld	a5,0(s0)
ffffffffc02044f4:	00003617          	auipc	a2,0x3
ffffffffc02044f8:	d9c60613          	addi	a2,a2,-612 # ffffffffc0207290 <default_pmm_manager+0x718>
ffffffffc02044fc:	24a00593          	li	a1,586
ffffffffc0204500:	43d4                	lw	a3,4(a5)
ffffffffc0204502:	00003517          	auipc	a0,0x3
ffffffffc0204506:	d3650513          	addi	a0,a0,-714 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc020450a:	d19fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        intr_enable();
ffffffffc020450e:	ca0fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204512:	bff1                	j	ffffffffc02044ee <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204514:	00003617          	auipc	a2,0x3
ffffffffc0204518:	d5c60613          	addi	a2,a2,-676 # ffffffffc0207270 <default_pmm_manager+0x6f8>
ffffffffc020451c:	21600593          	li	a1,534
ffffffffc0204520:	00003517          	auipc	a0,0x3
ffffffffc0204524:	d1850513          	addi	a0,a0,-744 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204528:	cfbfb0ef          	jal	ra,ffffffffc0200222 <__panic>
            exit_mmap(mm);
ffffffffc020452c:	854e                	mv	a0,s3
ffffffffc020452e:	dd1fc0ef          	jal	ra,ffffffffc02012fe <exit_mmap>
            put_pgdir(mm);
ffffffffc0204532:	854e                	mv	a0,s3
ffffffffc0204534:	9ddff0ef          	jal	ra,ffffffffc0203f10 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204538:	854e                	mv	a0,s3
ffffffffc020453a:	c29fc0ef          	jal	ra,ffffffffc0201162 <mm_destroy>
ffffffffc020453e:	bf35                	j	ffffffffc020447a <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204540:	00003617          	auipc	a2,0x3
ffffffffc0204544:	d4060613          	addi	a2,a2,-704 # ffffffffc0207280 <default_pmm_manager+0x708>
ffffffffc0204548:	21a00593          	li	a1,538
ffffffffc020454c:	00003517          	auipc	a0,0x3
ffffffffc0204550:	cec50513          	addi	a0,a0,-788 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204554:	ccffb0ef          	jal	ra,ffffffffc0200222 <__panic>
        intr_disable();
ffffffffc0204558:	c5cfc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020455c:	4a05                	li	s4,1
ffffffffc020455e:	bf1d                	j	ffffffffc0204494 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204560:	3db000ef          	jal	ra,ffffffffc020513a <wakeup_proc>
ffffffffc0204564:	b789                	j	ffffffffc02044a6 <do_exit+0x8a>

ffffffffc0204566 <do_wait.part.0>:
}

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int do_wait(int pid, int *code_store)
ffffffffc0204566:	715d                	addi	sp,sp,-80
ffffffffc0204568:	f84a                	sd	s2,48(sp)
ffffffffc020456a:	f44e                	sd	s3,40(sp)
        }
    }
    if (haskid)
    {
        current->state = PROC_SLEEPING;
        current->wait_state = WT_CHILD;
ffffffffc020456c:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204570:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204572:	fc26                	sd	s1,56(sp)
ffffffffc0204574:	f052                	sd	s4,32(sp)
ffffffffc0204576:	ec56                	sd	s5,24(sp)
ffffffffc0204578:	e85a                	sd	s6,16(sp)
ffffffffc020457a:	e45e                	sd	s7,8(sp)
ffffffffc020457c:	e486                	sd	ra,72(sp)
ffffffffc020457e:	e0a2                	sd	s0,64(sp)
ffffffffc0204580:	84aa                	mv	s1,a0
ffffffffc0204582:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204584:	000c3b97          	auipc	s7,0xc3
ffffffffc0204588:	b7cb8b93          	addi	s7,s7,-1156 # ffffffffc02c7100 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc020458c:	00050b1b          	sext.w	s6,a0
ffffffffc0204590:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204594:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204596:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204598:	ccbd                	beqz	s1,ffffffffc0204616 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc020459a:	0359e863          	bltu	s3,s5,ffffffffc02045ca <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020459e:	45a9                	li	a1,10
ffffffffc02045a0:	855a                	mv	a0,s6
ffffffffc02045a2:	3ac010ef          	jal	ra,ffffffffc020594e <hash32>
ffffffffc02045a6:	02051793          	slli	a5,a0,0x20
ffffffffc02045aa:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02045ae:	000bf797          	auipc	a5,0xbf
ffffffffc02045b2:	aba78793          	addi	a5,a5,-1350 # ffffffffc02c3068 <hash_list>
ffffffffc02045b6:	953e                	add	a0,a0,a5
ffffffffc02045b8:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02045ba:	a029                	j	ffffffffc02045c4 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02045bc:	f2c42783          	lw	a5,-212(s0)
ffffffffc02045c0:	02978163          	beq	a5,s1,ffffffffc02045e2 <do_wait.part.0+0x7c>
ffffffffc02045c4:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02045c6:	fe851be3          	bne	a0,s0,ffffffffc02045bc <do_wait.part.0+0x56>
        {
            do_exit(-E_KILLED);
        }
        goto repeat;
    }
    return -E_BAD_PROC;
ffffffffc02045ca:	5579                	li	a0,-2
    }
    local_intr_restore(intr_flag);
    put_kstack(proc);
    kfree(proc);
    return 0;
}
ffffffffc02045cc:	60a6                	ld	ra,72(sp)
ffffffffc02045ce:	6406                	ld	s0,64(sp)
ffffffffc02045d0:	74e2                	ld	s1,56(sp)
ffffffffc02045d2:	7942                	ld	s2,48(sp)
ffffffffc02045d4:	79a2                	ld	s3,40(sp)
ffffffffc02045d6:	7a02                	ld	s4,32(sp)
ffffffffc02045d8:	6ae2                	ld	s5,24(sp)
ffffffffc02045da:	6b42                	ld	s6,16(sp)
ffffffffc02045dc:	6ba2                	ld	s7,8(sp)
ffffffffc02045de:	6161                	addi	sp,sp,80
ffffffffc02045e0:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045e2:	000bb683          	ld	a3,0(s7)
ffffffffc02045e6:	f4843783          	ld	a5,-184(s0)
ffffffffc02045ea:	fed790e3          	bne	a5,a3,ffffffffc02045ca <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045ee:	f2842703          	lw	a4,-216(s0)
ffffffffc02045f2:	478d                	li	a5,3
ffffffffc02045f4:	0ef70b63          	beq	a4,a5,ffffffffc02046ea <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02045f8:	4785                	li	a5,1
ffffffffc02045fa:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02045fc:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204600:	3ed000ef          	jal	ra,ffffffffc02051ec <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204604:	000bb783          	ld	a5,0(s7)
ffffffffc0204608:	0b07a783          	lw	a5,176(a5)
ffffffffc020460c:	8b85                	andi	a5,a5,1
ffffffffc020460e:	d7c9                	beqz	a5,ffffffffc0204598 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204610:	555d                	li	a0,-9
ffffffffc0204612:	e0bff0ef          	jal	ra,ffffffffc020441c <do_exit>
        proc = current->cptr;
ffffffffc0204616:	000bb683          	ld	a3,0(s7)
ffffffffc020461a:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020461c:	d45d                	beqz	s0,ffffffffc02045ca <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020461e:	470d                	li	a4,3
ffffffffc0204620:	a021                	j	ffffffffc0204628 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204622:	10043403          	ld	s0,256(s0)
ffffffffc0204626:	d869                	beqz	s0,ffffffffc02045f8 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204628:	401c                	lw	a5,0(s0)
ffffffffc020462a:	fee79ce3          	bne	a5,a4,ffffffffc0204622 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc020462e:	000c3797          	auipc	a5,0xc3
ffffffffc0204632:	ada7b783          	ld	a5,-1318(a5) # ffffffffc02c7108 <idleproc>
ffffffffc0204636:	0c878963          	beq	a5,s0,ffffffffc0204708 <do_wait.part.0+0x1a2>
ffffffffc020463a:	000c3797          	auipc	a5,0xc3
ffffffffc020463e:	ad67b783          	ld	a5,-1322(a5) # ffffffffc02c7110 <initproc>
ffffffffc0204642:	0cf40363          	beq	s0,a5,ffffffffc0204708 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204646:	000a0663          	beqz	s4,ffffffffc0204652 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020464a:	0e842783          	lw	a5,232(s0)
ffffffffc020464e:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8f98>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204652:	100027f3          	csrr	a5,sstatus
ffffffffc0204656:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204658:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020465a:	e7c1                	bnez	a5,ffffffffc02046e2 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020465c:	6c70                	ld	a2,216(s0)
ffffffffc020465e:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204660:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204664:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204666:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204668:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020466a:	6470                	ld	a2,200(s0)
ffffffffc020466c:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc020466e:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204670:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204672:	c319                	beqz	a4,ffffffffc0204678 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204674:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204676:	7c7c                	ld	a5,248(s0)
ffffffffc0204678:	c3b5                	beqz	a5,ffffffffc02046dc <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020467a:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc020467e:	000c3717          	auipc	a4,0xc3
ffffffffc0204682:	a9a70713          	addi	a4,a4,-1382 # ffffffffc02c7118 <nr_process>
ffffffffc0204686:	431c                	lw	a5,0(a4)
ffffffffc0204688:	37fd                	addiw	a5,a5,-1
ffffffffc020468a:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc020468c:	e5a9                	bnez	a1,ffffffffc02046d6 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020468e:	6814                	ld	a3,16(s0)
ffffffffc0204690:	c02007b7          	lui	a5,0xc0200
ffffffffc0204694:	04f6ee63          	bltu	a3,a5,ffffffffc02046f0 <do_wait.part.0+0x18a>
ffffffffc0204698:	000c3797          	auipc	a5,0xc3
ffffffffc020469c:	a607b783          	ld	a5,-1440(a5) # ffffffffc02c70f8 <va_pa_offset>
ffffffffc02046a0:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02046a2:	82b1                	srli	a3,a3,0xc
ffffffffc02046a4:	000c3797          	auipc	a5,0xc3
ffffffffc02046a8:	a3c7b783          	ld	a5,-1476(a5) # ffffffffc02c70e0 <npage>
ffffffffc02046ac:	06f6fa63          	bgeu	a3,a5,ffffffffc0204720 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02046b0:	00004517          	auipc	a0,0x4
ffffffffc02046b4:	c2053503          	ld	a0,-992(a0) # ffffffffc02082d0 <nbase>
ffffffffc02046b8:	8e89                	sub	a3,a3,a0
ffffffffc02046ba:	069a                	slli	a3,a3,0x6
ffffffffc02046bc:	000c3517          	auipc	a0,0xc3
ffffffffc02046c0:	a2c53503          	ld	a0,-1492(a0) # ffffffffc02c70e8 <pages>
ffffffffc02046c4:	9536                	add	a0,a0,a3
ffffffffc02046c6:	4589                	li	a1,2
ffffffffc02046c8:	f61fd0ef          	jal	ra,ffffffffc0202628 <free_pages>
    kfree(proc);
ffffffffc02046cc:	8522                	mv	a0,s0
ffffffffc02046ce:	b40fd0ef          	jal	ra,ffffffffc0201a0e <kfree>
    return 0;
ffffffffc02046d2:	4501                	li	a0,0
ffffffffc02046d4:	bde5                	j	ffffffffc02045cc <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02046d6:	ad8fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02046da:	bf55                	j	ffffffffc020468e <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02046dc:	701c                	ld	a5,32(s0)
ffffffffc02046de:	fbf8                	sd	a4,240(a5)
ffffffffc02046e0:	bf79                	j	ffffffffc020467e <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02046e2:	ad2fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02046e6:	4585                	li	a1,1
ffffffffc02046e8:	bf95                	j	ffffffffc020465c <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02046ea:	f2840413          	addi	s0,s0,-216
ffffffffc02046ee:	b781                	j	ffffffffc020462e <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02046f0:	00002617          	auipc	a2,0x2
ffffffffc02046f4:	09860613          	addi	a2,a2,152 # ffffffffc0206788 <commands+0xb78>
ffffffffc02046f8:	07700593          	li	a1,119
ffffffffc02046fc:	00002517          	auipc	a0,0x2
ffffffffc0204700:	00c50513          	addi	a0,a0,12 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0204704:	b1ffb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204708:	00003617          	auipc	a2,0x3
ffffffffc020470c:	ba860613          	addi	a2,a2,-1112 # ffffffffc02072b0 <default_pmm_manager+0x738>
ffffffffc0204710:	37400593          	li	a1,884
ffffffffc0204714:	00003517          	auipc	a0,0x3
ffffffffc0204718:	b2450513          	addi	a0,a0,-1244 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc020471c:	b07fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204720:	00002617          	auipc	a2,0x2
ffffffffc0204724:	09060613          	addi	a2,a2,144 # ffffffffc02067b0 <commands+0xba0>
ffffffffc0204728:	06900593          	li	a1,105
ffffffffc020472c:	00002517          	auipc	a0,0x2
ffffffffc0204730:	fdc50513          	addi	a0,a0,-36 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0204734:	aeffb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0204738 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204738:	1141                	addi	sp,sp,-16
ffffffffc020473a:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020473c:	f2dfd0ef          	jal	ra,ffffffffc0202668 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204740:	a1afd0ef          	jal	ra,ffffffffc020195a <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204744:	4601                	li	a2,0
ffffffffc0204746:	4581                	li	a1,0
ffffffffc0204748:	00000517          	auipc	a0,0x0
ffffffffc020474c:	62c50513          	addi	a0,a0,1580 # ffffffffc0204d74 <user_main>
ffffffffc0204750:	c7dff0ef          	jal	ra,ffffffffc02043cc <kernel_thread>
    if (pid <= 0)
ffffffffc0204754:	00a04563          	bgtz	a0,ffffffffc020475e <init_main+0x26>
ffffffffc0204758:	a071                	j	ffffffffc02047e4 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020475a:	293000ef          	jal	ra,ffffffffc02051ec <schedule>
    if (code_store != NULL)
ffffffffc020475e:	4581                	li	a1,0
ffffffffc0204760:	4501                	li	a0,0
ffffffffc0204762:	e05ff0ef          	jal	ra,ffffffffc0204566 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204766:	d975                	beqz	a0,ffffffffc020475a <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204768:	00003517          	auipc	a0,0x3
ffffffffc020476c:	b8850513          	addi	a0,a0,-1144 # ffffffffc02072f0 <default_pmm_manager+0x778>
ffffffffc0204770:	975fb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204774:	000c3797          	auipc	a5,0xc3
ffffffffc0204778:	99c7b783          	ld	a5,-1636(a5) # ffffffffc02c7110 <initproc>
ffffffffc020477c:	7bf8                	ld	a4,240(a5)
ffffffffc020477e:	e339                	bnez	a4,ffffffffc02047c4 <init_main+0x8c>
ffffffffc0204780:	7ff8                	ld	a4,248(a5)
ffffffffc0204782:	e329                	bnez	a4,ffffffffc02047c4 <init_main+0x8c>
ffffffffc0204784:	1007b703          	ld	a4,256(a5)
ffffffffc0204788:	ef15                	bnez	a4,ffffffffc02047c4 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020478a:	000c3697          	auipc	a3,0xc3
ffffffffc020478e:	98e6a683          	lw	a3,-1650(a3) # ffffffffc02c7118 <nr_process>
ffffffffc0204792:	4709                	li	a4,2
ffffffffc0204794:	0ae69463          	bne	a3,a4,ffffffffc020483c <init_main+0x104>
    return listelm->next;
ffffffffc0204798:	000c3697          	auipc	a3,0xc3
ffffffffc020479c:	8d068693          	addi	a3,a3,-1840 # ffffffffc02c7068 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02047a0:	6698                	ld	a4,8(a3)
ffffffffc02047a2:	0c878793          	addi	a5,a5,200
ffffffffc02047a6:	06f71b63          	bne	a4,a5,ffffffffc020481c <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047aa:	629c                	ld	a5,0(a3)
ffffffffc02047ac:	04f71863          	bne	a4,a5,ffffffffc02047fc <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02047b0:	00003517          	auipc	a0,0x3
ffffffffc02047b4:	c2850513          	addi	a0,a0,-984 # ffffffffc02073d8 <default_pmm_manager+0x860>
ffffffffc02047b8:	92dfb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    return 0;
}
ffffffffc02047bc:	60a2                	ld	ra,8(sp)
ffffffffc02047be:	4501                	li	a0,0
ffffffffc02047c0:	0141                	addi	sp,sp,16
ffffffffc02047c2:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02047c4:	00003697          	auipc	a3,0x3
ffffffffc02047c8:	b5468693          	addi	a3,a3,-1196 # ffffffffc0207318 <default_pmm_manager+0x7a0>
ffffffffc02047cc:	00002617          	auipc	a2,0x2
ffffffffc02047d0:	c9c60613          	addi	a2,a2,-868 # ffffffffc0206468 <commands+0x858>
ffffffffc02047d4:	3e000593          	li	a1,992
ffffffffc02047d8:	00003517          	auipc	a0,0x3
ffffffffc02047dc:	a6050513          	addi	a0,a0,-1440 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc02047e0:	a43fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("create user_main failed.\n");
ffffffffc02047e4:	00003617          	auipc	a2,0x3
ffffffffc02047e8:	aec60613          	addi	a2,a2,-1300 # ffffffffc02072d0 <default_pmm_manager+0x758>
ffffffffc02047ec:	3d700593          	li	a1,983
ffffffffc02047f0:	00003517          	auipc	a0,0x3
ffffffffc02047f4:	a4850513          	addi	a0,a0,-1464 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc02047f8:	a2bfb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047fc:	00003697          	auipc	a3,0x3
ffffffffc0204800:	bac68693          	addi	a3,a3,-1108 # ffffffffc02073a8 <default_pmm_manager+0x830>
ffffffffc0204804:	00002617          	auipc	a2,0x2
ffffffffc0204808:	c6460613          	addi	a2,a2,-924 # ffffffffc0206468 <commands+0x858>
ffffffffc020480c:	3e300593          	li	a1,995
ffffffffc0204810:	00003517          	auipc	a0,0x3
ffffffffc0204814:	a2850513          	addi	a0,a0,-1496 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204818:	a0bfb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020481c:	00003697          	auipc	a3,0x3
ffffffffc0204820:	b5c68693          	addi	a3,a3,-1188 # ffffffffc0207378 <default_pmm_manager+0x800>
ffffffffc0204824:	00002617          	auipc	a2,0x2
ffffffffc0204828:	c4460613          	addi	a2,a2,-956 # ffffffffc0206468 <commands+0x858>
ffffffffc020482c:	3e200593          	li	a1,994
ffffffffc0204830:	00003517          	auipc	a0,0x3
ffffffffc0204834:	a0850513          	addi	a0,a0,-1528 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204838:	9ebfb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(nr_process == 2);
ffffffffc020483c:	00003697          	auipc	a3,0x3
ffffffffc0204840:	b2c68693          	addi	a3,a3,-1236 # ffffffffc0207368 <default_pmm_manager+0x7f0>
ffffffffc0204844:	00002617          	auipc	a2,0x2
ffffffffc0204848:	c2460613          	addi	a2,a2,-988 # ffffffffc0206468 <commands+0x858>
ffffffffc020484c:	3e100593          	li	a1,993
ffffffffc0204850:	00003517          	auipc	a0,0x3
ffffffffc0204854:	9e850513          	addi	a0,a0,-1560 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204858:	9cbfb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020485c <do_execve>:
{
ffffffffc020485c:	7171                	addi	sp,sp,-176
ffffffffc020485e:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204860:	000c3d97          	auipc	s11,0xc3
ffffffffc0204864:	8a0d8d93          	addi	s11,s11,-1888 # ffffffffc02c7100 <current>
ffffffffc0204868:	000db783          	ld	a5,0(s11)
{
ffffffffc020486c:	e54e                	sd	s3,136(sp)
ffffffffc020486e:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204870:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204874:	e94a                	sd	s2,144(sp)
ffffffffc0204876:	f4de                	sd	s7,104(sp)
ffffffffc0204878:	892a                	mv	s2,a0
ffffffffc020487a:	8bb2                	mv	s7,a2
ffffffffc020487c:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020487e:	862e                	mv	a2,a1
ffffffffc0204880:	4681                	li	a3,0
ffffffffc0204882:	85aa                	mv	a1,a0
ffffffffc0204884:	854e                	mv	a0,s3
{
ffffffffc0204886:	f506                	sd	ra,168(sp)
ffffffffc0204888:	f122                	sd	s0,160(sp)
ffffffffc020488a:	e152                	sd	s4,128(sp)
ffffffffc020488c:	fcd6                	sd	s5,120(sp)
ffffffffc020488e:	f8da                	sd	s6,112(sp)
ffffffffc0204890:	f0e2                	sd	s8,96(sp)
ffffffffc0204892:	ece6                	sd	s9,88(sp)
ffffffffc0204894:	e8ea                	sd	s10,80(sp)
ffffffffc0204896:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204898:	e01fc0ef          	jal	ra,ffffffffc0201698 <user_mem_check>
ffffffffc020489c:	40050c63          	beqz	a0,ffffffffc0204cb4 <do_execve+0x458>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02048a0:	4641                	li	a2,16
ffffffffc02048a2:	4581                	li	a1,0
ffffffffc02048a4:	1808                	addi	a0,sp,48
ffffffffc02048a6:	491000ef          	jal	ra,ffffffffc0205536 <memset>
    memcpy(local_name, name, len);
ffffffffc02048aa:	47bd                	li	a5,15
ffffffffc02048ac:	8626                	mv	a2,s1
ffffffffc02048ae:	1e97e463          	bltu	a5,s1,ffffffffc0204a96 <do_execve+0x23a>
ffffffffc02048b2:	85ca                	mv	a1,s2
ffffffffc02048b4:	1808                	addi	a0,sp,48
ffffffffc02048b6:	493000ef          	jal	ra,ffffffffc0205548 <memcpy>
    if (mm != NULL)
ffffffffc02048ba:	1e098563          	beqz	s3,ffffffffc0204aa4 <do_execve+0x248>
        cputs("mm != NULL");
ffffffffc02048be:	00002517          	auipc	a0,0x2
ffffffffc02048c2:	c4a50513          	addi	a0,a0,-950 # ffffffffc0206508 <commands+0x8f8>
ffffffffc02048c6:	859fb0ef          	jal	ra,ffffffffc020011e <cputs>
ffffffffc02048ca:	000c3797          	auipc	a5,0xc3
ffffffffc02048ce:	8067b783          	ld	a5,-2042(a5) # ffffffffc02c70d0 <boot_pgdir_pa>
ffffffffc02048d2:	577d                	li	a4,-1
ffffffffc02048d4:	177e                	slli	a4,a4,0x3f
ffffffffc02048d6:	83b1                	srli	a5,a5,0xc
ffffffffc02048d8:	8fd9                	or	a5,a5,a4
ffffffffc02048da:	18079073          	csrw	satp,a5
ffffffffc02048de:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7f68>
ffffffffc02048e2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02048e6:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02048ea:	2c070663          	beqz	a4,ffffffffc0204bb6 <do_execve+0x35a>
        current->mm = NULL;
ffffffffc02048ee:	000db783          	ld	a5,0(s11)
ffffffffc02048f2:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02048f6:	f2cfc0ef          	jal	ra,ffffffffc0201022 <mm_create>
ffffffffc02048fa:	84aa                	mv	s1,a0
ffffffffc02048fc:	1c050f63          	beqz	a0,ffffffffc0204ada <do_execve+0x27e>
    if ((page = alloc_page()) == NULL)
ffffffffc0204900:	4505                	li	a0,1
ffffffffc0204902:	ce9fd0ef          	jal	ra,ffffffffc02025ea <alloc_pages>
ffffffffc0204906:	3a050b63          	beqz	a0,ffffffffc0204cbc <do_execve+0x460>
    return page - pages + nbase;
ffffffffc020490a:	000c2c97          	auipc	s9,0xc2
ffffffffc020490e:	7dec8c93          	addi	s9,s9,2014 # ffffffffc02c70e8 <pages>
ffffffffc0204912:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204916:	000c2c17          	auipc	s8,0xc2
ffffffffc020491a:	7cac0c13          	addi	s8,s8,1994 # ffffffffc02c70e0 <npage>
    return page - pages + nbase;
ffffffffc020491e:	00004717          	auipc	a4,0x4
ffffffffc0204922:	9b273703          	ld	a4,-1614(a4) # ffffffffc02082d0 <nbase>
ffffffffc0204926:	40d506b3          	sub	a3,a0,a3
ffffffffc020492a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020492c:	5afd                	li	s5,-1
ffffffffc020492e:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204932:	96ba                	add	a3,a3,a4
ffffffffc0204934:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204936:	00cad713          	srli	a4,s5,0xc
ffffffffc020493a:	ec3a                	sd	a4,24(sp)
ffffffffc020493c:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020493e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204940:	38f77263          	bgeu	a4,a5,ffffffffc0204cc4 <do_execve+0x468>
ffffffffc0204944:	000c2b17          	auipc	s6,0xc2
ffffffffc0204948:	7b4b0b13          	addi	s6,s6,1972 # ffffffffc02c70f8 <va_pa_offset>
ffffffffc020494c:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204950:	6605                	lui	a2,0x1
ffffffffc0204952:	000c2597          	auipc	a1,0xc2
ffffffffc0204956:	7865b583          	ld	a1,1926(a1) # ffffffffc02c70d8 <boot_pgdir_va>
ffffffffc020495a:	9936                	add	s2,s2,a3
ffffffffc020495c:	854a                	mv	a0,s2
ffffffffc020495e:	3eb000ef          	jal	ra,ffffffffc0205548 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204962:	7782                	ld	a5,32(sp)
ffffffffc0204964:	4398                	lw	a4,0(a5)
ffffffffc0204966:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc020496a:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc020496e:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_matrix_out_size+0x464b7e1f>
ffffffffc0204972:	14f71a63          	bne	a4,a5,ffffffffc0204ac6 <do_execve+0x26a>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204976:	7682                	ld	a3,32(sp)
ffffffffc0204978:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020497c:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204980:	00371793          	slli	a5,a4,0x3
ffffffffc0204984:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204986:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204988:	078e                	slli	a5,a5,0x3
ffffffffc020498a:	97ce                	add	a5,a5,s3
ffffffffc020498c:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc020498e:	00f9fc63          	bgeu	s3,a5,ffffffffc02049a6 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204992:	0009a783          	lw	a5,0(s3)
ffffffffc0204996:	4705                	li	a4,1
ffffffffc0204998:	14e78363          	beq	a5,a4,ffffffffc0204ade <do_execve+0x282>
    for (; ph < ph_end; ph++)
ffffffffc020499c:	77a2                	ld	a5,40(sp)
ffffffffc020499e:	03898993          	addi	s3,s3,56
ffffffffc02049a2:	fef9e8e3          	bltu	s3,a5,ffffffffc0204992 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc02049a6:	4701                	li	a4,0
ffffffffc02049a8:	46ad                	li	a3,11
ffffffffc02049aa:	00100637          	lui	a2,0x100
ffffffffc02049ae:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02049b2:	8526                	mv	a0,s1
ffffffffc02049b4:	801fc0ef          	jal	ra,ffffffffc02011b4 <mm_map>
ffffffffc02049b8:	8a2a                	mv	s4,a0
ffffffffc02049ba:	1e051463          	bnez	a0,ffffffffc0204ba2 <do_execve+0x346>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02049be:	6c88                	ld	a0,24(s1)
ffffffffc02049c0:	467d                	li	a2,31
ffffffffc02049c2:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02049c6:	b62ff0ef          	jal	ra,ffffffffc0203d28 <pgdir_alloc_page>
ffffffffc02049ca:	38050563          	beqz	a0,ffffffffc0204d54 <do_execve+0x4f8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049ce:	6c88                	ld	a0,24(s1)
ffffffffc02049d0:	467d                	li	a2,31
ffffffffc02049d2:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02049d6:	b52ff0ef          	jal	ra,ffffffffc0203d28 <pgdir_alloc_page>
ffffffffc02049da:	34050d63          	beqz	a0,ffffffffc0204d34 <do_execve+0x4d8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049de:	6c88                	ld	a0,24(s1)
ffffffffc02049e0:	467d                	li	a2,31
ffffffffc02049e2:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049e6:	b42ff0ef          	jal	ra,ffffffffc0203d28 <pgdir_alloc_page>
ffffffffc02049ea:	32050563          	beqz	a0,ffffffffc0204d14 <do_execve+0x4b8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049ee:	6c88                	ld	a0,24(s1)
ffffffffc02049f0:	467d                	li	a2,31
ffffffffc02049f2:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049f6:	b32ff0ef          	jal	ra,ffffffffc0203d28 <pgdir_alloc_page>
ffffffffc02049fa:	2e050d63          	beqz	a0,ffffffffc0204cf4 <do_execve+0x498>
    mm->mm_count += 1;
ffffffffc02049fe:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204a00:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204a04:	6c94                	ld	a3,24(s1)
ffffffffc0204a06:	2785                	addiw	a5,a5,1
ffffffffc0204a08:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204a0a:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204a0c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204a10:	2cf6e663          	bltu	a3,a5,ffffffffc0204cdc <do_execve+0x480>
ffffffffc0204a14:	000b3783          	ld	a5,0(s6)
ffffffffc0204a18:	577d                	li	a4,-1
ffffffffc0204a1a:	177e                	slli	a4,a4,0x3f
ffffffffc0204a1c:	8e9d                	sub	a3,a3,a5
ffffffffc0204a1e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204a22:	f654                	sd	a3,168(a2)
ffffffffc0204a24:	8fd9                	or	a5,a5,a4
ffffffffc0204a26:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204a2a:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a2c:	4581                	li	a1,0
ffffffffc0204a2e:	12000613          	li	a2,288
ffffffffc0204a32:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204a34:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a38:	2ff000ef          	jal	ra,ffffffffc0205536 <memset>
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0204a3c:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a3e:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a42:	edf4f493          	andi	s1,s1,-289
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0204a46:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0204a48:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a4a:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_matrix_out_size+0xffffffff7fff3954>
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0204a4e:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a50:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a54:	4641                	li	a2,16
ffffffffc0204a56:	4581                	li	a1,0
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0204a58:	e81c                	sd	a5,16(s0)
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0204a5a:	10e43423          	sd	a4,264(s0)
    tf->gpr.a0 = 0;
ffffffffc0204a5e:	04043823          	sd	zero,80(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204a62:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a66:	854a                	mv	a0,s2
ffffffffc0204a68:	2cf000ef          	jal	ra,ffffffffc0205536 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a6c:	463d                	li	a2,15
ffffffffc0204a6e:	180c                	addi	a1,sp,48
ffffffffc0204a70:	854a                	mv	a0,s2
ffffffffc0204a72:	2d7000ef          	jal	ra,ffffffffc0205548 <memcpy>
}
ffffffffc0204a76:	70aa                	ld	ra,168(sp)
ffffffffc0204a78:	740a                	ld	s0,160(sp)
ffffffffc0204a7a:	64ea                	ld	s1,152(sp)
ffffffffc0204a7c:	694a                	ld	s2,144(sp)
ffffffffc0204a7e:	69aa                	ld	s3,136(sp)
ffffffffc0204a80:	7ae6                	ld	s5,120(sp)
ffffffffc0204a82:	7b46                	ld	s6,112(sp)
ffffffffc0204a84:	7ba6                	ld	s7,104(sp)
ffffffffc0204a86:	7c06                	ld	s8,96(sp)
ffffffffc0204a88:	6ce6                	ld	s9,88(sp)
ffffffffc0204a8a:	6d46                	ld	s10,80(sp)
ffffffffc0204a8c:	6da6                	ld	s11,72(sp)
ffffffffc0204a8e:	8552                	mv	a0,s4
ffffffffc0204a90:	6a0a                	ld	s4,128(sp)
ffffffffc0204a92:	614d                	addi	sp,sp,176
ffffffffc0204a94:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a96:	463d                	li	a2,15
ffffffffc0204a98:	85ca                	mv	a1,s2
ffffffffc0204a9a:	1808                	addi	a0,sp,48
ffffffffc0204a9c:	2ad000ef          	jal	ra,ffffffffc0205548 <memcpy>
    if (mm != NULL)
ffffffffc0204aa0:	e0099fe3          	bnez	s3,ffffffffc02048be <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204aa4:	000db783          	ld	a5,0(s11)
ffffffffc0204aa8:	779c                	ld	a5,40(a5)
ffffffffc0204aaa:	e40786e3          	beqz	a5,ffffffffc02048f6 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204aae:	00003617          	auipc	a2,0x3
ffffffffc0204ab2:	94a60613          	addi	a2,a2,-1718 # ffffffffc02073f8 <default_pmm_manager+0x880>
ffffffffc0204ab6:	25600593          	li	a1,598
ffffffffc0204aba:	00002517          	auipc	a0,0x2
ffffffffc0204abe:	77e50513          	addi	a0,a0,1918 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204ac2:	f60fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    put_pgdir(mm);
ffffffffc0204ac6:	8526                	mv	a0,s1
ffffffffc0204ac8:	c48ff0ef          	jal	ra,ffffffffc0203f10 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204acc:	8526                	mv	a0,s1
ffffffffc0204ace:	e94fc0ef          	jal	ra,ffffffffc0201162 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204ad2:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204ad4:	8552                	mv	a0,s4
ffffffffc0204ad6:	947ff0ef          	jal	ra,ffffffffc020441c <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204ada:	5a71                	li	s4,-4
ffffffffc0204adc:	bfe5                	j	ffffffffc0204ad4 <do_execve+0x278>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204ade:	0289b603          	ld	a2,40(s3)
ffffffffc0204ae2:	0209b783          	ld	a5,32(s3)
ffffffffc0204ae6:	1cf66d63          	bltu	a2,a5,ffffffffc0204cc0 <do_execve+0x464>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204aea:	0049a783          	lw	a5,4(s3)
ffffffffc0204aee:	0017f693          	andi	a3,a5,1
ffffffffc0204af2:	c291                	beqz	a3,ffffffffc0204af6 <do_execve+0x29a>
            vm_flags |= VM_EXEC;
ffffffffc0204af4:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204af6:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204afa:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204afc:	e779                	bnez	a4,ffffffffc0204bca <do_execve+0x36e>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204afe:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204b00:	c781                	beqz	a5,ffffffffc0204b08 <do_execve+0x2ac>
            vm_flags |= VM_READ;
ffffffffc0204b02:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204b06:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204b08:	0026f793          	andi	a5,a3,2
ffffffffc0204b0c:	e3f1                	bnez	a5,ffffffffc0204bd0 <do_execve+0x374>
        if (vm_flags & VM_EXEC)
ffffffffc0204b0e:	0046f793          	andi	a5,a3,4
ffffffffc0204b12:	c399                	beqz	a5,ffffffffc0204b18 <do_execve+0x2bc>
            perm |= PTE_X;
ffffffffc0204b14:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204b18:	0109b583          	ld	a1,16(s3)
ffffffffc0204b1c:	4701                	li	a4,0
ffffffffc0204b1e:	8526                	mv	a0,s1
ffffffffc0204b20:	e94fc0ef          	jal	ra,ffffffffc02011b4 <mm_map>
ffffffffc0204b24:	8a2a                	mv	s4,a0
ffffffffc0204b26:	ed35                	bnez	a0,ffffffffc0204ba2 <do_execve+0x346>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b28:	0109bb83          	ld	s7,16(s3)
ffffffffc0204b2c:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b2e:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b32:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b36:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b3a:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b3c:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b3e:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204b40:	054be963          	bltu	s7,s4,ffffffffc0204b92 <do_execve+0x336>
ffffffffc0204b44:	aa95                	j	ffffffffc0204cb8 <do_execve+0x45c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b46:	6785                	lui	a5,0x1
ffffffffc0204b48:	415b8533          	sub	a0,s7,s5
ffffffffc0204b4c:	9abe                	add	s5,s5,a5
ffffffffc0204b4e:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204b52:	015a7463          	bgeu	s4,s5,ffffffffc0204b5a <do_execve+0x2fe>
                size -= la - end;
ffffffffc0204b56:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204b5a:	000cb683          	ld	a3,0(s9)
ffffffffc0204b5e:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b60:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204b64:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b68:	8699                	srai	a3,a3,0x6
ffffffffc0204b6a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b6c:	67e2                	ld	a5,24(sp)
ffffffffc0204b6e:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b72:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b74:	14b87863          	bgeu	a6,a1,ffffffffc0204cc4 <do_execve+0x468>
ffffffffc0204b78:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b7c:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204b7e:	9bb2                	add	s7,s7,a2
ffffffffc0204b80:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b82:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204b84:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b86:	1c3000ef          	jal	ra,ffffffffc0205548 <memcpy>
            start += size, from += size;
ffffffffc0204b8a:	6622                	ld	a2,8(sp)
ffffffffc0204b8c:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204b8e:	054bf363          	bgeu	s7,s4,ffffffffc0204bd4 <do_execve+0x378>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b92:	6c88                	ld	a0,24(s1)
ffffffffc0204b94:	866a                	mv	a2,s10
ffffffffc0204b96:	85d6                	mv	a1,s5
ffffffffc0204b98:	990ff0ef          	jal	ra,ffffffffc0203d28 <pgdir_alloc_page>
ffffffffc0204b9c:	842a                	mv	s0,a0
ffffffffc0204b9e:	f545                	bnez	a0,ffffffffc0204b46 <do_execve+0x2ea>
        ret = -E_NO_MEM;
ffffffffc0204ba0:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204ba2:	8526                	mv	a0,s1
ffffffffc0204ba4:	f5afc0ef          	jal	ra,ffffffffc02012fe <exit_mmap>
    put_pgdir(mm);
ffffffffc0204ba8:	8526                	mv	a0,s1
ffffffffc0204baa:	b66ff0ef          	jal	ra,ffffffffc0203f10 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204bae:	8526                	mv	a0,s1
ffffffffc0204bb0:	db2fc0ef          	jal	ra,ffffffffc0201162 <mm_destroy>
    return ret;
ffffffffc0204bb4:	b705                	j	ffffffffc0204ad4 <do_execve+0x278>
            exit_mmap(mm);
ffffffffc0204bb6:	854e                	mv	a0,s3
ffffffffc0204bb8:	f46fc0ef          	jal	ra,ffffffffc02012fe <exit_mmap>
            put_pgdir(mm);
ffffffffc0204bbc:	854e                	mv	a0,s3
ffffffffc0204bbe:	b52ff0ef          	jal	ra,ffffffffc0203f10 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204bc2:	854e                	mv	a0,s3
ffffffffc0204bc4:	d9efc0ef          	jal	ra,ffffffffc0201162 <mm_destroy>
ffffffffc0204bc8:	b31d                	j	ffffffffc02048ee <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204bca:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bce:	fb95                	bnez	a5,ffffffffc0204b02 <do_execve+0x2a6>
            perm |= (PTE_W | PTE_R);
ffffffffc0204bd0:	4d5d                	li	s10,23
ffffffffc0204bd2:	bf35                	j	ffffffffc0204b0e <do_execve+0x2b2>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204bd4:	0109b683          	ld	a3,16(s3)
ffffffffc0204bd8:	0289b903          	ld	s2,40(s3)
ffffffffc0204bdc:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204bde:	075bfd63          	bgeu	s7,s5,ffffffffc0204c58 <do_execve+0x3fc>
            if (start == end)
ffffffffc0204be2:	db790de3          	beq	s2,s7,ffffffffc020499c <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204be6:	6785                	lui	a5,0x1
ffffffffc0204be8:	00fb8533          	add	a0,s7,a5
ffffffffc0204bec:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204bf0:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204bf4:	0b597d63          	bgeu	s2,s5,ffffffffc0204cae <do_execve+0x452>
    return page - pages + nbase;
ffffffffc0204bf8:	000cb683          	ld	a3,0(s9)
ffffffffc0204bfc:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bfe:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204c02:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c06:	8699                	srai	a3,a3,0x6
ffffffffc0204c08:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c0a:	67e2                	ld	a5,24(sp)
ffffffffc0204c0c:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c10:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c12:	0ac5f963          	bgeu	a1,a2,ffffffffc0204cc4 <do_execve+0x468>
ffffffffc0204c16:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c1a:	8652                	mv	a2,s4
ffffffffc0204c1c:	4581                	li	a1,0
ffffffffc0204c1e:	96c2                	add	a3,a3,a6
ffffffffc0204c20:	9536                	add	a0,a0,a3
ffffffffc0204c22:	115000ef          	jal	ra,ffffffffc0205536 <memset>
            start += size;
ffffffffc0204c26:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204c2a:	03597463          	bgeu	s2,s5,ffffffffc0204c52 <do_execve+0x3f6>
ffffffffc0204c2e:	d6e907e3          	beq	s2,a4,ffffffffc020499c <do_execve+0x140>
ffffffffc0204c32:	00002697          	auipc	a3,0x2
ffffffffc0204c36:	7ee68693          	addi	a3,a3,2030 # ffffffffc0207420 <default_pmm_manager+0x8a8>
ffffffffc0204c3a:	00002617          	auipc	a2,0x2
ffffffffc0204c3e:	82e60613          	addi	a2,a2,-2002 # ffffffffc0206468 <commands+0x858>
ffffffffc0204c42:	2bf00593          	li	a1,703
ffffffffc0204c46:	00002517          	auipc	a0,0x2
ffffffffc0204c4a:	5f250513          	addi	a0,a0,1522 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204c4e:	dd4fb0ef          	jal	ra,ffffffffc0200222 <__panic>
ffffffffc0204c52:	ff5710e3          	bne	a4,s5,ffffffffc0204c32 <do_execve+0x3d6>
ffffffffc0204c56:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204c58:	d52bf2e3          	bgeu	s7,s2,ffffffffc020499c <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c5c:	6c88                	ld	a0,24(s1)
ffffffffc0204c5e:	866a                	mv	a2,s10
ffffffffc0204c60:	85d6                	mv	a1,s5
ffffffffc0204c62:	8c6ff0ef          	jal	ra,ffffffffc0203d28 <pgdir_alloc_page>
ffffffffc0204c66:	842a                	mv	s0,a0
ffffffffc0204c68:	dd05                	beqz	a0,ffffffffc0204ba0 <do_execve+0x344>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c6a:	6785                	lui	a5,0x1
ffffffffc0204c6c:	415b8533          	sub	a0,s7,s5
ffffffffc0204c70:	9abe                	add	s5,s5,a5
ffffffffc0204c72:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204c76:	01597463          	bgeu	s2,s5,ffffffffc0204c7e <do_execve+0x422>
                size -= la - end;
ffffffffc0204c7a:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204c7e:	000cb683          	ld	a3,0(s9)
ffffffffc0204c82:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c84:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c88:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c8c:	8699                	srai	a3,a3,0x6
ffffffffc0204c8e:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c90:	67e2                	ld	a5,24(sp)
ffffffffc0204c92:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c96:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c98:	02b87663          	bgeu	a6,a1,ffffffffc0204cc4 <do_execve+0x468>
ffffffffc0204c9c:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ca0:	4581                	li	a1,0
            start += size;
ffffffffc0204ca2:	9bb2                	add	s7,s7,a2
ffffffffc0204ca4:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ca6:	9536                	add	a0,a0,a3
ffffffffc0204ca8:	08f000ef          	jal	ra,ffffffffc0205536 <memset>
ffffffffc0204cac:	b775                	j	ffffffffc0204c58 <do_execve+0x3fc>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204cae:	417a8a33          	sub	s4,s5,s7
ffffffffc0204cb2:	b799                	j	ffffffffc0204bf8 <do_execve+0x39c>
        return -E_INVAL;
ffffffffc0204cb4:	5a75                	li	s4,-3
ffffffffc0204cb6:	b3c1                	j	ffffffffc0204a76 <do_execve+0x21a>
        while (start < end)
ffffffffc0204cb8:	86de                	mv	a3,s7
ffffffffc0204cba:	bf39                	j	ffffffffc0204bd8 <do_execve+0x37c>
    int ret = -E_NO_MEM;
ffffffffc0204cbc:	5a71                	li	s4,-4
ffffffffc0204cbe:	bdc5                	j	ffffffffc0204bae <do_execve+0x352>
            ret = -E_INVAL_ELF;
ffffffffc0204cc0:	5a61                	li	s4,-8
ffffffffc0204cc2:	b5c5                	j	ffffffffc0204ba2 <do_execve+0x346>
ffffffffc0204cc4:	00002617          	auipc	a2,0x2
ffffffffc0204cc8:	a1c60613          	addi	a2,a2,-1508 # ffffffffc02066e0 <commands+0xad0>
ffffffffc0204ccc:	07100593          	li	a1,113
ffffffffc0204cd0:	00002517          	auipc	a0,0x2
ffffffffc0204cd4:	a3850513          	addi	a0,a0,-1480 # ffffffffc0206708 <commands+0xaf8>
ffffffffc0204cd8:	d4afb0ef          	jal	ra,ffffffffc0200222 <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cdc:	00002617          	auipc	a2,0x2
ffffffffc0204ce0:	aac60613          	addi	a2,a2,-1364 # ffffffffc0206788 <commands+0xb78>
ffffffffc0204ce4:	2de00593          	li	a1,734
ffffffffc0204ce8:	00002517          	auipc	a0,0x2
ffffffffc0204cec:	55050513          	addi	a0,a0,1360 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204cf0:	d32fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cf4:	00003697          	auipc	a3,0x3
ffffffffc0204cf8:	84468693          	addi	a3,a3,-1980 # ffffffffc0207538 <default_pmm_manager+0x9c0>
ffffffffc0204cfc:	00001617          	auipc	a2,0x1
ffffffffc0204d00:	76c60613          	addi	a2,a2,1900 # ffffffffc0206468 <commands+0x858>
ffffffffc0204d04:	2d900593          	li	a1,729
ffffffffc0204d08:	00002517          	auipc	a0,0x2
ffffffffc0204d0c:	53050513          	addi	a0,a0,1328 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204d10:	d12fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d14:	00002697          	auipc	a3,0x2
ffffffffc0204d18:	7dc68693          	addi	a3,a3,2012 # ffffffffc02074f0 <default_pmm_manager+0x978>
ffffffffc0204d1c:	00001617          	auipc	a2,0x1
ffffffffc0204d20:	74c60613          	addi	a2,a2,1868 # ffffffffc0206468 <commands+0x858>
ffffffffc0204d24:	2d800593          	li	a1,728
ffffffffc0204d28:	00002517          	auipc	a0,0x2
ffffffffc0204d2c:	51050513          	addi	a0,a0,1296 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204d30:	cf2fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d34:	00002697          	auipc	a3,0x2
ffffffffc0204d38:	77468693          	addi	a3,a3,1908 # ffffffffc02074a8 <default_pmm_manager+0x930>
ffffffffc0204d3c:	00001617          	auipc	a2,0x1
ffffffffc0204d40:	72c60613          	addi	a2,a2,1836 # ffffffffc0206468 <commands+0x858>
ffffffffc0204d44:	2d700593          	li	a1,727
ffffffffc0204d48:	00002517          	auipc	a0,0x2
ffffffffc0204d4c:	4f050513          	addi	a0,a0,1264 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204d50:	cd2fb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d54:	00002697          	auipc	a3,0x2
ffffffffc0204d58:	70c68693          	addi	a3,a3,1804 # ffffffffc0207460 <default_pmm_manager+0x8e8>
ffffffffc0204d5c:	00001617          	auipc	a2,0x1
ffffffffc0204d60:	70c60613          	addi	a2,a2,1804 # ffffffffc0206468 <commands+0x858>
ffffffffc0204d64:	2d600593          	li	a1,726
ffffffffc0204d68:	00002517          	auipc	a0,0x2
ffffffffc0204d6c:	4d050513          	addi	a0,a0,1232 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204d70:	cb2fb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0204d74 <user_main>:
{
ffffffffc0204d74:	1101                	addi	sp,sp,-32
ffffffffc0204d76:	e04a                	sd	s2,0(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d78:	000c2917          	auipc	s2,0xc2
ffffffffc0204d7c:	38890913          	addi	s2,s2,904 # ffffffffc02c7100 <current>
ffffffffc0204d80:	00093783          	ld	a5,0(s2)
ffffffffc0204d84:	00002617          	auipc	a2,0x2
ffffffffc0204d88:	7fc60613          	addi	a2,a2,2044 # ffffffffc0207580 <default_pmm_manager+0xa08>
ffffffffc0204d8c:	00003517          	auipc	a0,0x3
ffffffffc0204d90:	80450513          	addi	a0,a0,-2044 # ffffffffc0207590 <default_pmm_manager+0xa18>
ffffffffc0204d94:	43cc                	lw	a1,4(a5)
{
ffffffffc0204d96:	ec06                	sd	ra,24(sp)
ffffffffc0204d98:	e822                	sd	s0,16(sp)
ffffffffc0204d9a:	e426                	sd	s1,8(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204d9c:	b48fb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    size_t len = strlen(name);
ffffffffc0204da0:	00002517          	auipc	a0,0x2
ffffffffc0204da4:	7e050513          	addi	a0,a0,2016 # ffffffffc0207580 <default_pmm_manager+0xa08>
ffffffffc0204da8:	6ec000ef          	jal	ra,ffffffffc0205494 <strlen>
    struct trapframe *old_tf = current->tf;
ffffffffc0204dac:	00093783          	ld	a5,0(s2)
    size_t len = strlen(name);
ffffffffc0204db0:	84aa                	mv	s1,a0
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204db2:	12000613          	li	a2,288
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204db6:	6b80                	ld	s0,16(a5)
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204db8:	73cc                	ld	a1,160(a5)
    struct trapframe *new_tf = (struct trapframe *)(current->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0204dba:	6789                	lui	a5,0x2
ffffffffc0204dbc:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x80b8>
ffffffffc0204dc0:	943e                	add	s0,s0,a5
    memcpy(new_tf, old_tf, sizeof(struct trapframe));
ffffffffc0204dc2:	8522                	mv	a0,s0
ffffffffc0204dc4:	784000ef          	jal	ra,ffffffffc0205548 <memcpy>
    current->tf = new_tf;
ffffffffc0204dc8:	00093783          	ld	a5,0(s2)
    ret = do_execve(name, len, binary, size);
ffffffffc0204dcc:	3fe07697          	auipc	a3,0x3fe07
ffffffffc0204dd0:	9bc68693          	addi	a3,a3,-1604 # b788 <_binary_obj___user_priority_out_size>
ffffffffc0204dd4:	00047617          	auipc	a2,0x47
ffffffffc0204dd8:	b1460613          	addi	a2,a2,-1260 # ffffffffc024b8e8 <_binary_obj___user_priority_out_start>
    current->tf = new_tf;
ffffffffc0204ddc:	f3c0                	sd	s0,160(a5)
    ret = do_execve(name, len, binary, size);
ffffffffc0204dde:	85a6                	mv	a1,s1
ffffffffc0204de0:	00002517          	auipc	a0,0x2
ffffffffc0204de4:	7a050513          	addi	a0,a0,1952 # ffffffffc0207580 <default_pmm_manager+0xa08>
ffffffffc0204de8:	a75ff0ef          	jal	ra,ffffffffc020485c <do_execve>
    asm volatile(
ffffffffc0204dec:	8122                	mv	sp,s0
ffffffffc0204dee:	9b2fc06f          	j	ffffffffc0200fa0 <__trapret>
    panic("user_main execve failed.\n");
ffffffffc0204df2:	00002617          	auipc	a2,0x2
ffffffffc0204df6:	7c660613          	addi	a2,a2,1990 # ffffffffc02075b8 <default_pmm_manager+0xa40>
ffffffffc0204dfa:	3ca00593          	li	a1,970
ffffffffc0204dfe:	00002517          	auipc	a0,0x2
ffffffffc0204e02:	43a50513          	addi	a0,a0,1082 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0204e06:	c1cfb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0204e0a <do_yield>:
    current->need_resched = 1;
ffffffffc0204e0a:	000c2797          	auipc	a5,0xc2
ffffffffc0204e0e:	2f67b783          	ld	a5,758(a5) # ffffffffc02c7100 <current>
ffffffffc0204e12:	4705                	li	a4,1
ffffffffc0204e14:	ef98                	sd	a4,24(a5)
}
ffffffffc0204e16:	4501                	li	a0,0
ffffffffc0204e18:	8082                	ret

ffffffffc0204e1a <do_wait>:
{
ffffffffc0204e1a:	1101                	addi	sp,sp,-32
ffffffffc0204e1c:	e822                	sd	s0,16(sp)
ffffffffc0204e1e:	e426                	sd	s1,8(sp)
ffffffffc0204e20:	ec06                	sd	ra,24(sp)
ffffffffc0204e22:	842e                	mv	s0,a1
ffffffffc0204e24:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204e26:	c999                	beqz	a1,ffffffffc0204e3c <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204e28:	000c2797          	auipc	a5,0xc2
ffffffffc0204e2c:	2d87b783          	ld	a5,728(a5) # ffffffffc02c7100 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204e30:	7788                	ld	a0,40(a5)
ffffffffc0204e32:	4685                	li	a3,1
ffffffffc0204e34:	4611                	li	a2,4
ffffffffc0204e36:	863fc0ef          	jal	ra,ffffffffc0201698 <user_mem_check>
ffffffffc0204e3a:	c909                	beqz	a0,ffffffffc0204e4c <do_wait+0x32>
ffffffffc0204e3c:	85a2                	mv	a1,s0
}
ffffffffc0204e3e:	6442                	ld	s0,16(sp)
ffffffffc0204e40:	60e2                	ld	ra,24(sp)
ffffffffc0204e42:	8526                	mv	a0,s1
ffffffffc0204e44:	64a2                	ld	s1,8(sp)
ffffffffc0204e46:	6105                	addi	sp,sp,32
ffffffffc0204e48:	f1eff06f          	j	ffffffffc0204566 <do_wait.part.0>
ffffffffc0204e4c:	60e2                	ld	ra,24(sp)
ffffffffc0204e4e:	6442                	ld	s0,16(sp)
ffffffffc0204e50:	64a2                	ld	s1,8(sp)
ffffffffc0204e52:	5575                	li	a0,-3
ffffffffc0204e54:	6105                	addi	sp,sp,32
ffffffffc0204e56:	8082                	ret

ffffffffc0204e58 <do_kill>:
{
ffffffffc0204e58:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e5a:	6789                	lui	a5,0x2
{
ffffffffc0204e5c:	e406                	sd	ra,8(sp)
ffffffffc0204e5e:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204e60:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204e64:	17f9                	addi	a5,a5,-2
ffffffffc0204e66:	02e7e963          	bltu	a5,a4,ffffffffc0204e98 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204e6a:	842a                	mv	s0,a0
ffffffffc0204e6c:	45a9                	li	a1,10
ffffffffc0204e6e:	2501                	sext.w	a0,a0
ffffffffc0204e70:	2df000ef          	jal	ra,ffffffffc020594e <hash32>
ffffffffc0204e74:	02051793          	slli	a5,a0,0x20
ffffffffc0204e78:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204e7c:	000be797          	auipc	a5,0xbe
ffffffffc0204e80:	1ec78793          	addi	a5,a5,492 # ffffffffc02c3068 <hash_list>
ffffffffc0204e84:	953e                	add	a0,a0,a5
ffffffffc0204e86:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204e88:	a029                	j	ffffffffc0204e92 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204e8a:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204e8e:	00870b63          	beq	a4,s0,ffffffffc0204ea4 <do_kill+0x4c>
ffffffffc0204e92:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204e94:	fef51be3          	bne	a0,a5,ffffffffc0204e8a <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204e98:	5475                	li	s0,-3
}
ffffffffc0204e9a:	60a2                	ld	ra,8(sp)
ffffffffc0204e9c:	8522                	mv	a0,s0
ffffffffc0204e9e:	6402                	ld	s0,0(sp)
ffffffffc0204ea0:	0141                	addi	sp,sp,16
ffffffffc0204ea2:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204ea4:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204ea8:	00177693          	andi	a3,a4,1
ffffffffc0204eac:	e295                	bnez	a3,ffffffffc0204ed0 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204eae:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204eb0:	00176713          	ori	a4,a4,1
ffffffffc0204eb4:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204eb8:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204eba:	fe06d0e3          	bgez	a3,ffffffffc0204e9a <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204ebe:	f2878513          	addi	a0,a5,-216
ffffffffc0204ec2:	278000ef          	jal	ra,ffffffffc020513a <wakeup_proc>
}
ffffffffc0204ec6:	60a2                	ld	ra,8(sp)
ffffffffc0204ec8:	8522                	mv	a0,s0
ffffffffc0204eca:	6402                	ld	s0,0(sp)
ffffffffc0204ecc:	0141                	addi	sp,sp,16
ffffffffc0204ece:	8082                	ret
        return -E_KILLED;
ffffffffc0204ed0:	545d                	li	s0,-9
ffffffffc0204ed2:	b7e1                	j	ffffffffc0204e9a <do_kill+0x42>

ffffffffc0204ed4 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204ed4:	1101                	addi	sp,sp,-32
ffffffffc0204ed6:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204ed8:	000c2797          	auipc	a5,0xc2
ffffffffc0204edc:	19078793          	addi	a5,a5,400 # ffffffffc02c7068 <proc_list>
ffffffffc0204ee0:	ec06                	sd	ra,24(sp)
ffffffffc0204ee2:	e822                	sd	s0,16(sp)
ffffffffc0204ee4:	e04a                	sd	s2,0(sp)
ffffffffc0204ee6:	000be497          	auipc	s1,0xbe
ffffffffc0204eea:	18248493          	addi	s1,s1,386 # ffffffffc02c3068 <hash_list>
ffffffffc0204eee:	e79c                	sd	a5,8(a5)
ffffffffc0204ef0:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204ef2:	000c2717          	auipc	a4,0xc2
ffffffffc0204ef6:	17670713          	addi	a4,a4,374 # ffffffffc02c7068 <proc_list>
ffffffffc0204efa:	87a6                	mv	a5,s1
ffffffffc0204efc:	e79c                	sd	a5,8(a5)
ffffffffc0204efe:	e39c                	sd	a5,0(a5)
ffffffffc0204f00:	07c1                	addi	a5,a5,16
ffffffffc0204f02:	fef71de3          	bne	a4,a5,ffffffffc0204efc <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204f06:	f57fe0ef          	jal	ra,ffffffffc0203e5c <alloc_proc>
ffffffffc0204f0a:	000c2917          	auipc	s2,0xc2
ffffffffc0204f0e:	1fe90913          	addi	s2,s2,510 # ffffffffc02c7108 <idleproc>
ffffffffc0204f12:	00a93023          	sd	a0,0(s2)
ffffffffc0204f16:	0e050f63          	beqz	a0,ffffffffc0205014 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204f1a:	4789                	li	a5,2
ffffffffc0204f1c:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204f1e:	00004797          	auipc	a5,0x4
ffffffffc0204f22:	0e278793          	addi	a5,a5,226 # ffffffffc0209000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f26:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204f2a:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204f2c:	4785                	li	a5,1
ffffffffc0204f2e:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f30:	4641                	li	a2,16
ffffffffc0204f32:	4581                	li	a1,0
ffffffffc0204f34:	8522                	mv	a0,s0
ffffffffc0204f36:	600000ef          	jal	ra,ffffffffc0205536 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f3a:	463d                	li	a2,15
ffffffffc0204f3c:	00002597          	auipc	a1,0x2
ffffffffc0204f40:	6b458593          	addi	a1,a1,1716 # ffffffffc02075f0 <default_pmm_manager+0xa78>
ffffffffc0204f44:	8522                	mv	a0,s0
ffffffffc0204f46:	602000ef          	jal	ra,ffffffffc0205548 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204f4a:	000c2717          	auipc	a4,0xc2
ffffffffc0204f4e:	1ce70713          	addi	a4,a4,462 # ffffffffc02c7118 <nr_process>
ffffffffc0204f52:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204f54:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204f58:	4601                	li	a2,0
    nr_process++;
ffffffffc0204f5a:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204f5c:	4581                	li	a1,0
ffffffffc0204f5e:	fffff517          	auipc	a0,0xfffff
ffffffffc0204f62:	7da50513          	addi	a0,a0,2010 # ffffffffc0204738 <init_main>
    nr_process++;
ffffffffc0204f66:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204f68:	000c2797          	auipc	a5,0xc2
ffffffffc0204f6c:	18d7bc23          	sd	a3,408(a5) # ffffffffc02c7100 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204f70:	c5cff0ef          	jal	ra,ffffffffc02043cc <kernel_thread>
ffffffffc0204f74:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204f76:	08a05363          	blez	a0,ffffffffc0204ffc <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204f7a:	6789                	lui	a5,0x2
ffffffffc0204f7c:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204f80:	17f9                	addi	a5,a5,-2
ffffffffc0204f82:	2501                	sext.w	a0,a0
ffffffffc0204f84:	02e7e363          	bltu	a5,a4,ffffffffc0204faa <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204f88:	45a9                	li	a1,10
ffffffffc0204f8a:	1c5000ef          	jal	ra,ffffffffc020594e <hash32>
ffffffffc0204f8e:	02051793          	slli	a5,a0,0x20
ffffffffc0204f92:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204f96:	96a6                	add	a3,a3,s1
ffffffffc0204f98:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204f9a:	a029                	j	ffffffffc0204fa4 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204f9c:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x806c>
ffffffffc0204fa0:	04870b63          	beq	a4,s0,ffffffffc0204ff6 <proc_init+0x122>
    return listelm->next;
ffffffffc0204fa4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204fa6:	fef69be3          	bne	a3,a5,ffffffffc0204f9c <proc_init+0xc8>
    return NULL;
ffffffffc0204faa:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fac:	0b478493          	addi	s1,a5,180
ffffffffc0204fb0:	4641                	li	a2,16
ffffffffc0204fb2:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204fb4:	000c2417          	auipc	s0,0xc2
ffffffffc0204fb8:	15c40413          	addi	s0,s0,348 # ffffffffc02c7110 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fbc:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204fbe:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fc0:	576000ef          	jal	ra,ffffffffc0205536 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204fc4:	463d                	li	a2,15
ffffffffc0204fc6:	00002597          	auipc	a1,0x2
ffffffffc0204fca:	65258593          	addi	a1,a1,1618 # ffffffffc0207618 <default_pmm_manager+0xaa0>
ffffffffc0204fce:	8526                	mv	a0,s1
ffffffffc0204fd0:	578000ef          	jal	ra,ffffffffc0205548 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204fd4:	00093783          	ld	a5,0(s2)
ffffffffc0204fd8:	cbb5                	beqz	a5,ffffffffc020504c <proc_init+0x178>
ffffffffc0204fda:	43dc                	lw	a5,4(a5)
ffffffffc0204fdc:	eba5                	bnez	a5,ffffffffc020504c <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204fde:	601c                	ld	a5,0(s0)
ffffffffc0204fe0:	c7b1                	beqz	a5,ffffffffc020502c <proc_init+0x158>
ffffffffc0204fe2:	43d8                	lw	a4,4(a5)
ffffffffc0204fe4:	4785                	li	a5,1
ffffffffc0204fe6:	04f71363          	bne	a4,a5,ffffffffc020502c <proc_init+0x158>
}
ffffffffc0204fea:	60e2                	ld	ra,24(sp)
ffffffffc0204fec:	6442                	ld	s0,16(sp)
ffffffffc0204fee:	64a2                	ld	s1,8(sp)
ffffffffc0204ff0:	6902                	ld	s2,0(sp)
ffffffffc0204ff2:	6105                	addi	sp,sp,32
ffffffffc0204ff4:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204ff6:	f2878793          	addi	a5,a5,-216
ffffffffc0204ffa:	bf4d                	j	ffffffffc0204fac <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204ffc:	00002617          	auipc	a2,0x2
ffffffffc0205000:	5fc60613          	addi	a2,a2,1532 # ffffffffc02075f8 <default_pmm_manager+0xa80>
ffffffffc0205004:	40600593          	li	a1,1030
ffffffffc0205008:	00002517          	auipc	a0,0x2
ffffffffc020500c:	23050513          	addi	a0,a0,560 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0205010:	a12fb0ef          	jal	ra,ffffffffc0200222 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205014:	00002617          	auipc	a2,0x2
ffffffffc0205018:	5c460613          	addi	a2,a2,1476 # ffffffffc02075d8 <default_pmm_manager+0xa60>
ffffffffc020501c:	3f700593          	li	a1,1015
ffffffffc0205020:	00002517          	auipc	a0,0x2
ffffffffc0205024:	21850513          	addi	a0,a0,536 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0205028:	9fafb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020502c:	00002697          	auipc	a3,0x2
ffffffffc0205030:	61c68693          	addi	a3,a3,1564 # ffffffffc0207648 <default_pmm_manager+0xad0>
ffffffffc0205034:	00001617          	auipc	a2,0x1
ffffffffc0205038:	43460613          	addi	a2,a2,1076 # ffffffffc0206468 <commands+0x858>
ffffffffc020503c:	40d00593          	li	a1,1037
ffffffffc0205040:	00002517          	auipc	a0,0x2
ffffffffc0205044:	1f850513          	addi	a0,a0,504 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0205048:	9dafb0ef          	jal	ra,ffffffffc0200222 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020504c:	00002697          	auipc	a3,0x2
ffffffffc0205050:	5d468693          	addi	a3,a3,1492 # ffffffffc0207620 <default_pmm_manager+0xaa8>
ffffffffc0205054:	00001617          	auipc	a2,0x1
ffffffffc0205058:	41460613          	addi	a2,a2,1044 # ffffffffc0206468 <commands+0x858>
ffffffffc020505c:	40c00593          	li	a1,1036
ffffffffc0205060:	00002517          	auipc	a0,0x2
ffffffffc0205064:	1d850513          	addi	a0,a0,472 # ffffffffc0207238 <default_pmm_manager+0x6c0>
ffffffffc0205068:	9bafb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020506c <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc020506c:	1141                	addi	sp,sp,-16
ffffffffc020506e:	e022                	sd	s0,0(sp)
ffffffffc0205070:	e406                	sd	ra,8(sp)
ffffffffc0205072:	000c2417          	auipc	s0,0xc2
ffffffffc0205076:	08e40413          	addi	s0,s0,142 # ffffffffc02c7100 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc020507a:	6018                	ld	a4,0(s0)
ffffffffc020507c:	6f1c                	ld	a5,24(a4)
ffffffffc020507e:	dffd                	beqz	a5,ffffffffc020507c <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205080:	16c000ef          	jal	ra,ffffffffc02051ec <schedule>
ffffffffc0205084:	bfdd                	j	ffffffffc020507a <cpu_idle+0xe>

ffffffffc0205086 <lab6_set_priority>:
        }
    }
}
// FOR LAB6, set the process's priority (bigger value will get more CPU time)
void lab6_set_priority(uint32_t priority)
{
ffffffffc0205086:	1141                	addi	sp,sp,-16
ffffffffc0205088:	e022                	sd	s0,0(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc020508a:	85aa                	mv	a1,a0
{
ffffffffc020508c:	842a                	mv	s0,a0
    cprintf("set priority to %d\n", priority);
ffffffffc020508e:	00002517          	auipc	a0,0x2
ffffffffc0205092:	5e250513          	addi	a0,a0,1506 # ffffffffc0207670 <default_pmm_manager+0xaf8>
{
ffffffffc0205096:	e406                	sd	ra,8(sp)
    cprintf("set priority to %d\n", priority);
ffffffffc0205098:	84cfb0ef          	jal	ra,ffffffffc02000e4 <cprintf>
    if (priority == 0)
        current->lab6_priority = 1;
ffffffffc020509c:	000c2797          	auipc	a5,0xc2
ffffffffc02050a0:	0647b783          	ld	a5,100(a5) # ffffffffc02c7100 <current>
    if (priority == 0)
ffffffffc02050a4:	e801                	bnez	s0,ffffffffc02050b4 <lab6_set_priority+0x2e>
    else
        current->lab6_priority = priority;
}
ffffffffc02050a6:	60a2                	ld	ra,8(sp)
ffffffffc02050a8:	6402                	ld	s0,0(sp)
        current->lab6_priority = 1;
ffffffffc02050aa:	4705                	li	a4,1
ffffffffc02050ac:	14e7a223          	sw	a4,324(a5)
}
ffffffffc02050b0:	0141                	addi	sp,sp,16
ffffffffc02050b2:	8082                	ret
ffffffffc02050b4:	60a2                	ld	ra,8(sp)
        current->lab6_priority = priority;
ffffffffc02050b6:	1487a223          	sw	s0,324(a5)
}
ffffffffc02050ba:	6402                	ld	s0,0(sp)
ffffffffc02050bc:	0141                	addi	sp,sp,16
ffffffffc02050be:	8082                	ret

ffffffffc02050c0 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc)
ffffffffc02050c0:	000c2797          	auipc	a5,0xc2
ffffffffc02050c4:	0487b783          	ld	a5,72(a5) # ffffffffc02c7108 <idleproc>
{
ffffffffc02050c8:	85aa                	mv	a1,a0
    if (proc != idleproc)
ffffffffc02050ca:	00a78c63          	beq	a5,a0,ffffffffc02050e2 <sched_class_proc_tick+0x22>
    {
        sched_class->proc_tick(rq, proc);
ffffffffc02050ce:	000c2797          	auipc	a5,0xc2
ffffffffc02050d2:	05a7b783          	ld	a5,90(a5) # ffffffffc02c7128 <sched_class>
ffffffffc02050d6:	779c                	ld	a5,40(a5)
ffffffffc02050d8:	000c2517          	auipc	a0,0xc2
ffffffffc02050dc:	04853503          	ld	a0,72(a0) # ffffffffc02c7120 <rq>
ffffffffc02050e0:	8782                	jr	a5
    }
    else
    {
        proc->need_resched = 1;
ffffffffc02050e2:	4705                	li	a4,1
ffffffffc02050e4:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc02050e6:	8082                	ret

ffffffffc02050e8 <sched_init>:

static struct run_queue __rq;

void sched_init(void)
{
ffffffffc02050e8:	1141                	addi	sp,sp,-16
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc02050ea:	000be717          	auipc	a4,0xbe
ffffffffc02050ee:	b2670713          	addi	a4,a4,-1242 # ffffffffc02c2c10 <default_sched_class>
{
ffffffffc02050f2:	e022                	sd	s0,0(sp)
ffffffffc02050f4:	e406                	sd	ra,8(sp)
    elm->prev = elm->next = elm;
ffffffffc02050f6:	000c2797          	auipc	a5,0xc2
ffffffffc02050fa:	fa278793          	addi	a5,a5,-94 # ffffffffc02c7098 <timer_list>

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc02050fe:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc0205100:	000c2517          	auipc	a0,0xc2
ffffffffc0205104:	f7850513          	addi	a0,a0,-136 # ffffffffc02c7078 <__rq>
ffffffffc0205108:	e79c                	sd	a5,8(a5)
ffffffffc020510a:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc020510c:	4795                	li	a5,5
ffffffffc020510e:	c95c                	sw	a5,20(a0)
    sched_class = &default_sched_class;
ffffffffc0205110:	000c2417          	auipc	s0,0xc2
ffffffffc0205114:	01840413          	addi	s0,s0,24 # ffffffffc02c7128 <sched_class>
    rq = &__rq;
ffffffffc0205118:	000c2797          	auipc	a5,0xc2
ffffffffc020511c:	00a7b423          	sd	a0,8(a5) # ffffffffc02c7120 <rq>
    sched_class = &default_sched_class;
ffffffffc0205120:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc0205122:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205124:	601c                	ld	a5,0(s0)
}
ffffffffc0205126:	6402                	ld	s0,0(sp)
ffffffffc0205128:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020512a:	638c                	ld	a1,0(a5)
ffffffffc020512c:	00002517          	auipc	a0,0x2
ffffffffc0205130:	55c50513          	addi	a0,a0,1372 # ffffffffc0207688 <default_pmm_manager+0xb10>
}
ffffffffc0205134:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0205136:	faffa06f          	j	ffffffffc02000e4 <cprintf>

ffffffffc020513a <wakeup_proc>:

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020513a:	4118                	lw	a4,0(a0)
{
ffffffffc020513c:	1101                	addi	sp,sp,-32
ffffffffc020513e:	ec06                	sd	ra,24(sp)
ffffffffc0205140:	e822                	sd	s0,16(sp)
ffffffffc0205142:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205144:	478d                	li	a5,3
ffffffffc0205146:	08f70363          	beq	a4,a5,ffffffffc02051cc <wakeup_proc+0x92>
ffffffffc020514a:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020514c:	100027f3          	csrr	a5,sstatus
ffffffffc0205150:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205152:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205154:	e7bd                	bnez	a5,ffffffffc02051c2 <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205156:	4789                	li	a5,2
ffffffffc0205158:	04f70863          	beq	a4,a5,ffffffffc02051a8 <wakeup_proc+0x6e>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc020515c:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc020515e:	0e042623          	sw	zero,236(s0)
            if (proc != current)
ffffffffc0205162:	000c2797          	auipc	a5,0xc2
ffffffffc0205166:	f9e7b783          	ld	a5,-98(a5) # ffffffffc02c7100 <current>
ffffffffc020516a:	02878363          	beq	a5,s0,ffffffffc0205190 <wakeup_proc+0x56>
    if (proc != idleproc)
ffffffffc020516e:	000c2797          	auipc	a5,0xc2
ffffffffc0205172:	f9a7b783          	ld	a5,-102(a5) # ffffffffc02c7108 <idleproc>
ffffffffc0205176:	00f40d63          	beq	s0,a5,ffffffffc0205190 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc020517a:	000c2797          	auipc	a5,0xc2
ffffffffc020517e:	fae7b783          	ld	a5,-82(a5) # ffffffffc02c7128 <sched_class>
ffffffffc0205182:	6b9c                	ld	a5,16(a5)
ffffffffc0205184:	85a2                	mv	a1,s0
ffffffffc0205186:	000c2517          	auipc	a0,0xc2
ffffffffc020518a:	f9a53503          	ld	a0,-102(a0) # ffffffffc02c7120 <rq>
ffffffffc020518e:	9782                	jalr	a5
    if (flag)
ffffffffc0205190:	e491                	bnez	s1,ffffffffc020519c <wakeup_proc+0x62>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205192:	60e2                	ld	ra,24(sp)
ffffffffc0205194:	6442                	ld	s0,16(sp)
ffffffffc0205196:	64a2                	ld	s1,8(sp)
ffffffffc0205198:	6105                	addi	sp,sp,32
ffffffffc020519a:	8082                	ret
ffffffffc020519c:	6442                	ld	s0,16(sp)
ffffffffc020519e:	60e2                	ld	ra,24(sp)
ffffffffc02051a0:	64a2                	ld	s1,8(sp)
ffffffffc02051a2:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02051a4:	80bfb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc02051a8:	00002617          	auipc	a2,0x2
ffffffffc02051ac:	53060613          	addi	a2,a2,1328 # ffffffffc02076d8 <default_pmm_manager+0xb60>
ffffffffc02051b0:	05100593          	li	a1,81
ffffffffc02051b4:	00002517          	auipc	a0,0x2
ffffffffc02051b8:	50c50513          	addi	a0,a0,1292 # ffffffffc02076c0 <default_pmm_manager+0xb48>
ffffffffc02051bc:	8cefb0ef          	jal	ra,ffffffffc020028a <__warn>
ffffffffc02051c0:	bfc1                	j	ffffffffc0205190 <wakeup_proc+0x56>
        intr_disable();
ffffffffc02051c2:	ff2fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02051c6:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc02051c8:	4485                	li	s1,1
ffffffffc02051ca:	b771                	j	ffffffffc0205156 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02051cc:	00002697          	auipc	a3,0x2
ffffffffc02051d0:	4d468693          	addi	a3,a3,1236 # ffffffffc02076a0 <default_pmm_manager+0xb28>
ffffffffc02051d4:	00001617          	auipc	a2,0x1
ffffffffc02051d8:	29460613          	addi	a2,a2,660 # ffffffffc0206468 <commands+0x858>
ffffffffc02051dc:	04200593          	li	a1,66
ffffffffc02051e0:	00002517          	auipc	a0,0x2
ffffffffc02051e4:	4e050513          	addi	a0,a0,1248 # ffffffffc02076c0 <default_pmm_manager+0xb48>
ffffffffc02051e8:	83afb0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc02051ec <schedule>:

void schedule(void)
{
ffffffffc02051ec:	7179                	addi	sp,sp,-48
ffffffffc02051ee:	f406                	sd	ra,40(sp)
ffffffffc02051f0:	f022                	sd	s0,32(sp)
ffffffffc02051f2:	ec26                	sd	s1,24(sp)
ffffffffc02051f4:	e84a                	sd	s2,16(sp)
ffffffffc02051f6:	e44e                	sd	s3,8(sp)
ffffffffc02051f8:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02051fa:	100027f3          	csrr	a5,sstatus
ffffffffc02051fe:	8b89                	andi	a5,a5,2
ffffffffc0205200:	4a01                	li	s4,0
ffffffffc0205202:	e3cd                	bnez	a5,ffffffffc02052a4 <schedule+0xb8>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205204:	000c2497          	auipc	s1,0xc2
ffffffffc0205208:	efc48493          	addi	s1,s1,-260 # ffffffffc02c7100 <current>
ffffffffc020520c:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc020520e:	000c2997          	auipc	s3,0xc2
ffffffffc0205212:	f1a98993          	addi	s3,s3,-230 # ffffffffc02c7128 <sched_class>
ffffffffc0205216:	000c2917          	auipc	s2,0xc2
ffffffffc020521a:	f0a90913          	addi	s2,s2,-246 # ffffffffc02c7120 <rq>
        if (current->state == PROC_RUNNABLE)
ffffffffc020521e:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc0205220:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE)
ffffffffc0205224:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc0205226:	0009b783          	ld	a5,0(s3)
ffffffffc020522a:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE)
ffffffffc020522e:	04e68e63          	beq	a3,a4,ffffffffc020528a <schedule+0x9e>
    return sched_class->pick_next(rq);
ffffffffc0205232:	739c                	ld	a5,32(a5)
ffffffffc0205234:	9782                	jalr	a5
ffffffffc0205236:	842a                	mv	s0,a0
        {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL)
ffffffffc0205238:	c521                	beqz	a0,ffffffffc0205280 <schedule+0x94>
    sched_class->dequeue(rq, proc);
ffffffffc020523a:	0009b783          	ld	a5,0(s3)
ffffffffc020523e:	00093503          	ld	a0,0(s2)
ffffffffc0205242:	85a2                	mv	a1,s0
ffffffffc0205244:	6f9c                	ld	a5,24(a5)
ffffffffc0205246:	9782                	jalr	a5
        }
        if (next == NULL)
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205248:	441c                	lw	a5,8(s0)
        if (next != current)
ffffffffc020524a:	6098                	ld	a4,0(s1)
        next->runs++;
ffffffffc020524c:	2785                	addiw	a5,a5,1
ffffffffc020524e:	c41c                	sw	a5,8(s0)
        if (next != current)
ffffffffc0205250:	00870563          	beq	a4,s0,ffffffffc020525a <schedule+0x6e>
        {
            proc_run(next);
ffffffffc0205254:	8522                	mv	a0,s0
ffffffffc0205256:	d31fe0ef          	jal	ra,ffffffffc0203f86 <proc_run>
    if (flag)
ffffffffc020525a:	000a1a63          	bnez	s4,ffffffffc020526e <schedule+0x82>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020525e:	70a2                	ld	ra,40(sp)
ffffffffc0205260:	7402                	ld	s0,32(sp)
ffffffffc0205262:	64e2                	ld	s1,24(sp)
ffffffffc0205264:	6942                	ld	s2,16(sp)
ffffffffc0205266:	69a2                	ld	s3,8(sp)
ffffffffc0205268:	6a02                	ld	s4,0(sp)
ffffffffc020526a:	6145                	addi	sp,sp,48
ffffffffc020526c:	8082                	ret
ffffffffc020526e:	7402                	ld	s0,32(sp)
ffffffffc0205270:	70a2                	ld	ra,40(sp)
ffffffffc0205272:	64e2                	ld	s1,24(sp)
ffffffffc0205274:	6942                	ld	s2,16(sp)
ffffffffc0205276:	69a2                	ld	s3,8(sp)
ffffffffc0205278:	6a02                	ld	s4,0(sp)
ffffffffc020527a:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc020527c:	f32fb06f          	j	ffffffffc02009ae <intr_enable>
            next = idleproc;
ffffffffc0205280:	000c2417          	auipc	s0,0xc2
ffffffffc0205284:	e8843403          	ld	s0,-376(s0) # ffffffffc02c7108 <idleproc>
ffffffffc0205288:	b7c1                	j	ffffffffc0205248 <schedule+0x5c>
    if (proc != idleproc)
ffffffffc020528a:	000c2717          	auipc	a4,0xc2
ffffffffc020528e:	e7e73703          	ld	a4,-386(a4) # ffffffffc02c7108 <idleproc>
ffffffffc0205292:	fae580e3          	beq	a1,a4,ffffffffc0205232 <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc0205296:	6b9c                	ld	a5,16(a5)
ffffffffc0205298:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc020529a:	0009b783          	ld	a5,0(s3)
ffffffffc020529e:	00093503          	ld	a0,0(s2)
ffffffffc02052a2:	bf41                	j	ffffffffc0205232 <schedule+0x46>
        intr_disable();
ffffffffc02052a4:	f10fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02052a8:	4a05                	li	s4,1
ffffffffc02052aa:	bfa9                	j	ffffffffc0205204 <schedule+0x18>

ffffffffc02052ac <RR_init>:
ffffffffc02052ac:	e508                	sd	a0,8(a0)
ffffffffc02052ae:	e108                	sd	a0,0(a0)
static void
RR_init(struct run_queue *rq)
{
    // LAB6: YOUR CODE
    list_init(&(rq->run_list));
    rq->proc_num = 0;
ffffffffc02052b0:	00052823          	sw	zero,16(a0)
}
ffffffffc02052b4:	8082                	ret

ffffffffc02052b6 <RR_pick_next>:
    return listelm->next;
ffffffffc02052b6:	651c                	ld	a5,8(a0)
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    // LAB6: YOUR CODE
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
ffffffffc02052b8:	00f50563          	beq	a0,a5,ffffffffc02052c2 <RR_pick_next+0xc>
        return le2proc(le, run_link);
ffffffffc02052bc:	ef078513          	addi	a0,a5,-272
ffffffffc02052c0:	8082                	ret
    }
    return NULL;
ffffffffc02052c2:	4501                	li	a0,0
}
ffffffffc02052c4:	8082                	ret

ffffffffc02052c6 <RR_proc_tick>:
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    // LAB6: YOUR CODE
    if (proc->time_slice > 0) {
ffffffffc02052c6:	1205a783          	lw	a5,288(a1)
ffffffffc02052ca:	00f05563          	blez	a5,ffffffffc02052d4 <RR_proc_tick+0xe>
        proc->time_slice--;
ffffffffc02052ce:	37fd                	addiw	a5,a5,-1
ffffffffc02052d0:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc02052d4:	e399                	bnez	a5,ffffffffc02052da <RR_proc_tick+0x14>
        proc->need_resched = 1;
ffffffffc02052d6:	4785                	li	a5,1
ffffffffc02052d8:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc02052da:	8082                	ret

ffffffffc02052dc <RR_dequeue>:
    assert(!list_empty(&(rq->run_list)) && proc->rq == rq);
ffffffffc02052dc:	651c                	ld	a5,8(a0)
ffffffffc02052de:	02f50663          	beq	a0,a5,ffffffffc020530a <RR_dequeue+0x2e>
ffffffffc02052e2:	1085b783          	ld	a5,264(a1)
ffffffffc02052e6:	02a79263          	bne	a5,a0,ffffffffc020530a <RR_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc02052ea:	1105b503          	ld	a0,272(a1)
ffffffffc02052ee:	1185b603          	ld	a2,280(a1)
    rq->proc_num--;
ffffffffc02052f2:	4b98                	lw	a4,16(a5)
    list_del_init(&(proc->run_link));
ffffffffc02052f4:	11058693          	addi	a3,a1,272
    prev->next = next;
ffffffffc02052f8:	e510                	sd	a2,8(a0)
    next->prev = prev;
ffffffffc02052fa:	e208                	sd	a0,0(a2)
    elm->prev = elm->next = elm;
ffffffffc02052fc:	10d5bc23          	sd	a3,280(a1)
ffffffffc0205300:	10d5b823          	sd	a3,272(a1)
    rq->proc_num--;
ffffffffc0205304:	377d                	addiw	a4,a4,-1
ffffffffc0205306:	cb98                	sw	a4,16(a5)
ffffffffc0205308:	8082                	ret
{
ffffffffc020530a:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(rq->run_list)) && proc->rq == rq);
ffffffffc020530c:	00002697          	auipc	a3,0x2
ffffffffc0205310:	3ec68693          	addi	a3,a3,1004 # ffffffffc02076f8 <default_pmm_manager+0xb80>
ffffffffc0205314:	00001617          	auipc	a2,0x1
ffffffffc0205318:	15460613          	addi	a2,a2,340 # ffffffffc0206468 <commands+0x858>
ffffffffc020531c:	03c00593          	li	a1,60
ffffffffc0205320:	00002517          	auipc	a0,0x2
ffffffffc0205324:	40850513          	addi	a0,a0,1032 # ffffffffc0207728 <default_pmm_manager+0xbb0>
{
ffffffffc0205328:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(rq->run_list)) && proc->rq == rq);
ffffffffc020532a:	ef9fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc020532e <RR_enqueue>:
    assert(list_empty(&(proc->run_link)));
ffffffffc020532e:	1185b703          	ld	a4,280(a1)
ffffffffc0205332:	11058793          	addi	a5,a1,272
ffffffffc0205336:	02e79d63          	bne	a5,a4,ffffffffc0205370 <RR_enqueue+0x42>
    __list_add(elm, listelm->prev, listelm);
ffffffffc020533a:	6118                	ld	a4,0(a0)
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc020533c:	1205a683          	lw	a3,288(a1)
    prev->next = next->prev = elm;
ffffffffc0205340:	e11c                	sd	a5,0(a0)
ffffffffc0205342:	e71c                	sd	a5,8(a4)
    elm->next = next;
ffffffffc0205344:	10a5bc23          	sd	a0,280(a1)
    elm->prev = prev;
ffffffffc0205348:	10e5b823          	sd	a4,272(a1)
ffffffffc020534c:	495c                	lw	a5,20(a0)
ffffffffc020534e:	ea89                	bnez	a3,ffffffffc0205360 <RR_enqueue+0x32>
        proc->time_slice = rq->max_time_slice;
ffffffffc0205350:	12f5a023          	sw	a5,288(a1)
    rq->proc_num++;
ffffffffc0205354:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0205356:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc020535a:	2785                	addiw	a5,a5,1
ffffffffc020535c:	c91c                	sw	a5,16(a0)
ffffffffc020535e:	8082                	ret
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc0205360:	fed7c8e3          	blt	a5,a3,ffffffffc0205350 <RR_enqueue+0x22>
    rq->proc_num++;
ffffffffc0205364:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0205366:	10a5b423          	sd	a0,264(a1)
    rq->proc_num++;
ffffffffc020536a:	2785                	addiw	a5,a5,1
ffffffffc020536c:	c91c                	sw	a5,16(a0)
ffffffffc020536e:	8082                	ret
{
ffffffffc0205370:	1141                	addi	sp,sp,-16
    assert(list_empty(&(proc->run_link)));
ffffffffc0205372:	00002697          	auipc	a3,0x2
ffffffffc0205376:	3d668693          	addi	a3,a3,982 # ffffffffc0207748 <default_pmm_manager+0xbd0>
ffffffffc020537a:	00001617          	auipc	a2,0x1
ffffffffc020537e:	0ee60613          	addi	a2,a2,238 # ffffffffc0206468 <commands+0x858>
ffffffffc0205382:	02800593          	li	a1,40
ffffffffc0205386:	00002517          	auipc	a0,0x2
ffffffffc020538a:	3a250513          	addi	a0,a0,930 # ffffffffc0207728 <default_pmm_manager+0xbb0>
{
ffffffffc020538e:	e406                	sd	ra,8(sp)
    assert(list_empty(&(proc->run_link)));
ffffffffc0205390:	e93fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205394 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205394:	000c2797          	auipc	a5,0xc2
ffffffffc0205398:	d6c7b783          	ld	a5,-660(a5) # ffffffffc02c7100 <current>
}
ffffffffc020539c:	43c8                	lw	a0,4(a5)
ffffffffc020539e:	8082                	ret

ffffffffc02053a0 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02053a0:	4501                	li	a0,0
ffffffffc02053a2:	8082                	ret

ffffffffc02053a4 <sys_gettime>:
static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc02053a4:	000c2797          	auipc	a5,0xc2
ffffffffc02053a8:	d1c7b783          	ld	a5,-740(a5) # ffffffffc02c70c0 <ticks>
ffffffffc02053ac:	0027951b          	slliw	a0,a5,0x2
ffffffffc02053b0:	9d3d                	addw	a0,a0,a5
}
ffffffffc02053b2:	0015151b          	slliw	a0,a0,0x1
ffffffffc02053b6:	8082                	ret

ffffffffc02053b8 <sys_lab6_set_priority>:
static int sys_lab6_set_priority(uint64_t arg[]){
    uint64_t priority = (uint64_t)arg[0];
    lab6_set_priority(priority);
ffffffffc02053b8:	4108                	lw	a0,0(a0)
static int sys_lab6_set_priority(uint64_t arg[]){
ffffffffc02053ba:	1141                	addi	sp,sp,-16
ffffffffc02053bc:	e406                	sd	ra,8(sp)
    lab6_set_priority(priority);
ffffffffc02053be:	cc9ff0ef          	jal	ra,ffffffffc0205086 <lab6_set_priority>
    return 0;
}
ffffffffc02053c2:	60a2                	ld	ra,8(sp)
ffffffffc02053c4:	4501                	li	a0,0
ffffffffc02053c6:	0141                	addi	sp,sp,16
ffffffffc02053c8:	8082                	ret

ffffffffc02053ca <sys_putc>:
    cputchar(c);
ffffffffc02053ca:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02053cc:	1141                	addi	sp,sp,-16
ffffffffc02053ce:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02053d0:	d4bfa0ef          	jal	ra,ffffffffc020011a <cputchar>
}
ffffffffc02053d4:	60a2                	ld	ra,8(sp)
ffffffffc02053d6:	4501                	li	a0,0
ffffffffc02053d8:	0141                	addi	sp,sp,16
ffffffffc02053da:	8082                	ret

ffffffffc02053dc <sys_kill>:
    return do_kill(pid);
ffffffffc02053dc:	4108                	lw	a0,0(a0)
ffffffffc02053de:	a7bff06f          	j	ffffffffc0204e58 <do_kill>

ffffffffc02053e2 <sys_yield>:
    return do_yield();
ffffffffc02053e2:	a29ff06f          	j	ffffffffc0204e0a <do_yield>

ffffffffc02053e6 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02053e6:	6d14                	ld	a3,24(a0)
ffffffffc02053e8:	6910                	ld	a2,16(a0)
ffffffffc02053ea:	650c                	ld	a1,8(a0)
ffffffffc02053ec:	6108                	ld	a0,0(a0)
ffffffffc02053ee:	c6eff06f          	j	ffffffffc020485c <do_execve>

ffffffffc02053f2 <sys_wait>:
    return do_wait(pid, store);
ffffffffc02053f2:	650c                	ld	a1,8(a0)
ffffffffc02053f4:	4108                	lw	a0,0(a0)
ffffffffc02053f6:	a25ff06f          	j	ffffffffc0204e1a <do_wait>

ffffffffc02053fa <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02053fa:	000c2797          	auipc	a5,0xc2
ffffffffc02053fe:	d067b783          	ld	a5,-762(a5) # ffffffffc02c7100 <current>
ffffffffc0205402:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205404:	4501                	li	a0,0
ffffffffc0205406:	6a0c                	ld	a1,16(a2)
ffffffffc0205408:	bf5fe06f          	j	ffffffffc0203ffc <do_fork>

ffffffffc020540c <sys_exit>:
    return do_exit(error_code);
ffffffffc020540c:	4108                	lw	a0,0(a0)
ffffffffc020540e:	80eff06f          	j	ffffffffc020441c <do_exit>

ffffffffc0205412 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205412:	715d                	addi	sp,sp,-80
ffffffffc0205414:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205416:	000c2497          	auipc	s1,0xc2
ffffffffc020541a:	cea48493          	addi	s1,s1,-790 # ffffffffc02c7100 <current>
ffffffffc020541e:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205420:	e0a2                	sd	s0,64(sp)
ffffffffc0205422:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205424:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc0205426:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205428:	0ff00793          	li	a5,255
    int num = tf->gpr.a0;
ffffffffc020542c:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205430:	0327ee63          	bltu	a5,s2,ffffffffc020546c <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc0205434:	00391713          	slli	a4,s2,0x3
ffffffffc0205438:	00002797          	auipc	a5,0x2
ffffffffc020543c:	38878793          	addi	a5,a5,904 # ffffffffc02077c0 <syscalls>
ffffffffc0205440:	97ba                	add	a5,a5,a4
ffffffffc0205442:	639c                	ld	a5,0(a5)
ffffffffc0205444:	c785                	beqz	a5,ffffffffc020546c <syscall+0x5a>
            arg[0] = tf->gpr.a1;
ffffffffc0205446:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc0205448:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc020544a:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc020544c:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc020544e:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0205450:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc0205452:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc0205454:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc0205456:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc0205458:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020545a:	0028                	addi	a0,sp,8
ffffffffc020545c:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc020545e:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205460:	e828                	sd	a0,80(s0)
}
ffffffffc0205462:	6406                	ld	s0,64(sp)
ffffffffc0205464:	74e2                	ld	s1,56(sp)
ffffffffc0205466:	7942                	ld	s2,48(sp)
ffffffffc0205468:	6161                	addi	sp,sp,80
ffffffffc020546a:	8082                	ret
    print_trapframe(tf);
ffffffffc020546c:	8522                	mv	a0,s0
ffffffffc020546e:	f34fb0ef          	jal	ra,ffffffffc0200ba2 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205472:	609c                	ld	a5,0(s1)
ffffffffc0205474:	86ca                	mv	a3,s2
ffffffffc0205476:	00002617          	auipc	a2,0x2
ffffffffc020547a:	30260613          	addi	a2,a2,770 # ffffffffc0207778 <default_pmm_manager+0xc00>
ffffffffc020547e:	43d8                	lw	a4,4(a5)
ffffffffc0205480:	06c00593          	li	a1,108
ffffffffc0205484:	0b478793          	addi	a5,a5,180
ffffffffc0205488:	00002517          	auipc	a0,0x2
ffffffffc020548c:	32050513          	addi	a0,a0,800 # ffffffffc02077a8 <default_pmm_manager+0xc30>
ffffffffc0205490:	d93fa0ef          	jal	ra,ffffffffc0200222 <__panic>

ffffffffc0205494 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205494:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205498:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020549a:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020549c:	cb81                	beqz	a5,ffffffffc02054ac <strlen+0x18>
        cnt ++;
ffffffffc020549e:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02054a0:	00a707b3          	add	a5,a4,a0
ffffffffc02054a4:	0007c783          	lbu	a5,0(a5)
ffffffffc02054a8:	fbfd                	bnez	a5,ffffffffc020549e <strlen+0xa>
ffffffffc02054aa:	8082                	ret
    }
    return cnt;
}
ffffffffc02054ac:	8082                	ret

ffffffffc02054ae <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02054ae:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02054b0:	e589                	bnez	a1,ffffffffc02054ba <strnlen+0xc>
ffffffffc02054b2:	a811                	j	ffffffffc02054c6 <strnlen+0x18>
        cnt ++;
ffffffffc02054b4:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02054b6:	00f58863          	beq	a1,a5,ffffffffc02054c6 <strnlen+0x18>
ffffffffc02054ba:	00f50733          	add	a4,a0,a5
ffffffffc02054be:	00074703          	lbu	a4,0(a4)
ffffffffc02054c2:	fb6d                	bnez	a4,ffffffffc02054b4 <strnlen+0x6>
ffffffffc02054c4:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02054c6:	852e                	mv	a0,a1
ffffffffc02054c8:	8082                	ret

ffffffffc02054ca <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02054ca:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02054cc:	0005c703          	lbu	a4,0(a1)
ffffffffc02054d0:	0785                	addi	a5,a5,1
ffffffffc02054d2:	0585                	addi	a1,a1,1
ffffffffc02054d4:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02054d8:	fb75                	bnez	a4,ffffffffc02054cc <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02054da:	8082                	ret

ffffffffc02054dc <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02054dc:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02054e0:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02054e4:	cb89                	beqz	a5,ffffffffc02054f6 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02054e6:	0505                	addi	a0,a0,1
ffffffffc02054e8:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02054ea:	fee789e3          	beq	a5,a4,ffffffffc02054dc <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02054ee:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02054f2:	9d19                	subw	a0,a0,a4
ffffffffc02054f4:	8082                	ret
ffffffffc02054f6:	4501                	li	a0,0
ffffffffc02054f8:	bfed                	j	ffffffffc02054f2 <strcmp+0x16>

ffffffffc02054fa <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02054fa:	c20d                	beqz	a2,ffffffffc020551c <strncmp+0x22>
ffffffffc02054fc:	962e                	add	a2,a2,a1
ffffffffc02054fe:	a031                	j	ffffffffc020550a <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205500:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205502:	00e79a63          	bne	a5,a4,ffffffffc0205516 <strncmp+0x1c>
ffffffffc0205506:	00b60b63          	beq	a2,a1,ffffffffc020551c <strncmp+0x22>
ffffffffc020550a:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc020550e:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205510:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0205514:	f7f5                	bnez	a5,ffffffffc0205500 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205516:	40e7853b          	subw	a0,a5,a4
}
ffffffffc020551a:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020551c:	4501                	li	a0,0
ffffffffc020551e:	8082                	ret

ffffffffc0205520 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205520:	00054783          	lbu	a5,0(a0)
ffffffffc0205524:	c799                	beqz	a5,ffffffffc0205532 <strchr+0x12>
        if (*s == c) {
ffffffffc0205526:	00f58763          	beq	a1,a5,ffffffffc0205534 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020552a:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc020552e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205530:	fbfd                	bnez	a5,ffffffffc0205526 <strchr+0x6>
    }
    return NULL;
ffffffffc0205532:	4501                	li	a0,0
}
ffffffffc0205534:	8082                	ret

ffffffffc0205536 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205536:	ca01                	beqz	a2,ffffffffc0205546 <memset+0x10>
ffffffffc0205538:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020553a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020553c:	0785                	addi	a5,a5,1
ffffffffc020553e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205542:	fec79de3          	bne	a5,a2,ffffffffc020553c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0205546:	8082                	ret

ffffffffc0205548 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0205548:	ca19                	beqz	a2,ffffffffc020555e <memcpy+0x16>
ffffffffc020554a:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020554c:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020554e:	0005c703          	lbu	a4,0(a1)
ffffffffc0205552:	0585                	addi	a1,a1,1
ffffffffc0205554:	0785                	addi	a5,a5,1
ffffffffc0205556:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc020555a:	fec59ae3          	bne	a1,a2,ffffffffc020554e <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc020555e:	8082                	ret

ffffffffc0205560 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205560:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205564:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205566:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020556a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020556c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205570:	f022                	sd	s0,32(sp)
ffffffffc0205572:	ec26                	sd	s1,24(sp)
ffffffffc0205574:	e84a                	sd	s2,16(sp)
ffffffffc0205576:	f406                	sd	ra,40(sp)
ffffffffc0205578:	e44e                	sd	s3,8(sp)
ffffffffc020557a:	84aa                	mv	s1,a0
ffffffffc020557c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020557e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205582:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205584:	03067e63          	bgeu	a2,a6,ffffffffc02055c0 <printnum+0x60>
ffffffffc0205588:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020558a:	00805763          	blez	s0,ffffffffc0205598 <printnum+0x38>
ffffffffc020558e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205590:	85ca                	mv	a1,s2
ffffffffc0205592:	854e                	mv	a0,s3
ffffffffc0205594:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205596:	fc65                	bnez	s0,ffffffffc020558e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205598:	1a02                	slli	s4,s4,0x20
ffffffffc020559a:	00003797          	auipc	a5,0x3
ffffffffc020559e:	a2678793          	addi	a5,a5,-1498 # ffffffffc0207fc0 <syscalls+0x800>
ffffffffc02055a2:	020a5a13          	srli	s4,s4,0x20
ffffffffc02055a6:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02055a8:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055aa:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02055ae:	70a2                	ld	ra,40(sp)
ffffffffc02055b0:	69a2                	ld	s3,8(sp)
ffffffffc02055b2:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055b4:	85ca                	mv	a1,s2
ffffffffc02055b6:	87a6                	mv	a5,s1
}
ffffffffc02055b8:	6942                	ld	s2,16(sp)
ffffffffc02055ba:	64e2                	ld	s1,24(sp)
ffffffffc02055bc:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02055be:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02055c0:	03065633          	divu	a2,a2,a6
ffffffffc02055c4:	8722                	mv	a4,s0
ffffffffc02055c6:	f9bff0ef          	jal	ra,ffffffffc0205560 <printnum>
ffffffffc02055ca:	b7f9                	j	ffffffffc0205598 <printnum+0x38>

ffffffffc02055cc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02055cc:	7119                	addi	sp,sp,-128
ffffffffc02055ce:	f4a6                	sd	s1,104(sp)
ffffffffc02055d0:	f0ca                	sd	s2,96(sp)
ffffffffc02055d2:	ecce                	sd	s3,88(sp)
ffffffffc02055d4:	e8d2                	sd	s4,80(sp)
ffffffffc02055d6:	e4d6                	sd	s5,72(sp)
ffffffffc02055d8:	e0da                	sd	s6,64(sp)
ffffffffc02055da:	fc5e                	sd	s7,56(sp)
ffffffffc02055dc:	f06a                	sd	s10,32(sp)
ffffffffc02055de:	fc86                	sd	ra,120(sp)
ffffffffc02055e0:	f8a2                	sd	s0,112(sp)
ffffffffc02055e2:	f862                	sd	s8,48(sp)
ffffffffc02055e4:	f466                	sd	s9,40(sp)
ffffffffc02055e6:	ec6e                	sd	s11,24(sp)
ffffffffc02055e8:	892a                	mv	s2,a0
ffffffffc02055ea:	84ae                	mv	s1,a1
ffffffffc02055ec:	8d32                	mv	s10,a2
ffffffffc02055ee:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055f0:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02055f4:	5b7d                	li	s6,-1
ffffffffc02055f6:	00003a97          	auipc	s5,0x3
ffffffffc02055fa:	9f6a8a93          	addi	s5,s5,-1546 # ffffffffc0207fec <syscalls+0x82c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02055fe:	00003b97          	auipc	s7,0x3
ffffffffc0205602:	c0ab8b93          	addi	s7,s7,-1014 # ffffffffc0208208 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205606:	000d4503          	lbu	a0,0(s10)
ffffffffc020560a:	001d0413          	addi	s0,s10,1
ffffffffc020560e:	01350a63          	beq	a0,s3,ffffffffc0205622 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0205612:	c121                	beqz	a0,ffffffffc0205652 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0205614:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205616:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205618:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020561a:	fff44503          	lbu	a0,-1(s0)
ffffffffc020561e:	ff351ae3          	bne	a0,s3,ffffffffc0205612 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205622:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205626:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020562a:	4c81                	li	s9,0
ffffffffc020562c:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020562e:	5c7d                	li	s8,-1
ffffffffc0205630:	5dfd                	li	s11,-1
ffffffffc0205632:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205636:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205638:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020563c:	0ff5f593          	zext.b	a1,a1
ffffffffc0205640:	00140d13          	addi	s10,s0,1
ffffffffc0205644:	04b56263          	bltu	a0,a1,ffffffffc0205688 <vprintfmt+0xbc>
ffffffffc0205648:	058a                	slli	a1,a1,0x2
ffffffffc020564a:	95d6                	add	a1,a1,s5
ffffffffc020564c:	4194                	lw	a3,0(a1)
ffffffffc020564e:	96d6                	add	a3,a3,s5
ffffffffc0205650:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205652:	70e6                	ld	ra,120(sp)
ffffffffc0205654:	7446                	ld	s0,112(sp)
ffffffffc0205656:	74a6                	ld	s1,104(sp)
ffffffffc0205658:	7906                	ld	s2,96(sp)
ffffffffc020565a:	69e6                	ld	s3,88(sp)
ffffffffc020565c:	6a46                	ld	s4,80(sp)
ffffffffc020565e:	6aa6                	ld	s5,72(sp)
ffffffffc0205660:	6b06                	ld	s6,64(sp)
ffffffffc0205662:	7be2                	ld	s7,56(sp)
ffffffffc0205664:	7c42                	ld	s8,48(sp)
ffffffffc0205666:	7ca2                	ld	s9,40(sp)
ffffffffc0205668:	7d02                	ld	s10,32(sp)
ffffffffc020566a:	6de2                	ld	s11,24(sp)
ffffffffc020566c:	6109                	addi	sp,sp,128
ffffffffc020566e:	8082                	ret
            padc = '0';
ffffffffc0205670:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205672:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205676:	846a                	mv	s0,s10
ffffffffc0205678:	00140d13          	addi	s10,s0,1
ffffffffc020567c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205680:	0ff5f593          	zext.b	a1,a1
ffffffffc0205684:	fcb572e3          	bgeu	a0,a1,ffffffffc0205648 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205688:	85a6                	mv	a1,s1
ffffffffc020568a:	02500513          	li	a0,37
ffffffffc020568e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205690:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205694:	8d22                	mv	s10,s0
ffffffffc0205696:	f73788e3          	beq	a5,s3,ffffffffc0205606 <vprintfmt+0x3a>
ffffffffc020569a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020569e:	1d7d                	addi	s10,s10,-1
ffffffffc02056a0:	ff379de3          	bne	a5,s3,ffffffffc020569a <vprintfmt+0xce>
ffffffffc02056a4:	b78d                	j	ffffffffc0205606 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02056a6:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02056aa:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056ae:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02056b0:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02056b4:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02056b8:	02d86463          	bltu	a6,a3,ffffffffc02056e0 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02056bc:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02056c0:	002c169b          	slliw	a3,s8,0x2
ffffffffc02056c4:	0186873b          	addw	a4,a3,s8
ffffffffc02056c8:	0017171b          	slliw	a4,a4,0x1
ffffffffc02056cc:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02056ce:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02056d2:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02056d4:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02056d8:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02056dc:	fed870e3          	bgeu	a6,a3,ffffffffc02056bc <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02056e0:	f40ddce3          	bgez	s11,ffffffffc0205638 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02056e4:	8de2                	mv	s11,s8
ffffffffc02056e6:	5c7d                	li	s8,-1
ffffffffc02056e8:	bf81                	j	ffffffffc0205638 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02056ea:	fffdc693          	not	a3,s11
ffffffffc02056ee:	96fd                	srai	a3,a3,0x3f
ffffffffc02056f0:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056f4:	00144603          	lbu	a2,1(s0)
ffffffffc02056f8:	2d81                	sext.w	s11,s11
ffffffffc02056fa:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02056fc:	bf35                	j	ffffffffc0205638 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02056fe:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205702:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0205706:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205708:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020570a:	bfd9                	j	ffffffffc02056e0 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020570c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020570e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205712:	01174463          	blt	a4,a7,ffffffffc020571a <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205716:	1a088e63          	beqz	a7,ffffffffc02058d2 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020571a:	000a3603          	ld	a2,0(s4)
ffffffffc020571e:	46c1                	li	a3,16
ffffffffc0205720:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205722:	2781                	sext.w	a5,a5
ffffffffc0205724:	876e                	mv	a4,s11
ffffffffc0205726:	85a6                	mv	a1,s1
ffffffffc0205728:	854a                	mv	a0,s2
ffffffffc020572a:	e37ff0ef          	jal	ra,ffffffffc0205560 <printnum>
            break;
ffffffffc020572e:	bde1                	j	ffffffffc0205606 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205730:	000a2503          	lw	a0,0(s4)
ffffffffc0205734:	85a6                	mv	a1,s1
ffffffffc0205736:	0a21                	addi	s4,s4,8
ffffffffc0205738:	9902                	jalr	s2
            break;
ffffffffc020573a:	b5f1                	j	ffffffffc0205606 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020573c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020573e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205742:	01174463          	blt	a4,a7,ffffffffc020574a <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205746:	18088163          	beqz	a7,ffffffffc02058c8 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020574a:	000a3603          	ld	a2,0(s4)
ffffffffc020574e:	46a9                	li	a3,10
ffffffffc0205750:	8a2e                	mv	s4,a1
ffffffffc0205752:	bfc1                	j	ffffffffc0205722 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205754:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205758:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020575a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020575c:	bdf1                	j	ffffffffc0205638 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020575e:	85a6                	mv	a1,s1
ffffffffc0205760:	02500513          	li	a0,37
ffffffffc0205764:	9902                	jalr	s2
            break;
ffffffffc0205766:	b545                	j	ffffffffc0205606 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205768:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020576c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020576e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205770:	b5e1                	j	ffffffffc0205638 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205772:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205774:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205778:	01174463          	blt	a4,a7,ffffffffc0205780 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020577c:	14088163          	beqz	a7,ffffffffc02058be <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205780:	000a3603          	ld	a2,0(s4)
ffffffffc0205784:	46a1                	li	a3,8
ffffffffc0205786:	8a2e                	mv	s4,a1
ffffffffc0205788:	bf69                	j	ffffffffc0205722 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020578a:	03000513          	li	a0,48
ffffffffc020578e:	85a6                	mv	a1,s1
ffffffffc0205790:	e03e                	sd	a5,0(sp)
ffffffffc0205792:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205794:	85a6                	mv	a1,s1
ffffffffc0205796:	07800513          	li	a0,120
ffffffffc020579a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020579c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020579e:	6782                	ld	a5,0(sp)
ffffffffc02057a0:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02057a2:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02057a6:	bfb5                	j	ffffffffc0205722 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057a8:	000a3403          	ld	s0,0(s4)
ffffffffc02057ac:	008a0713          	addi	a4,s4,8
ffffffffc02057b0:	e03a                	sd	a4,0(sp)
ffffffffc02057b2:	14040263          	beqz	s0,ffffffffc02058f6 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02057b6:	0fb05763          	blez	s11,ffffffffc02058a4 <vprintfmt+0x2d8>
ffffffffc02057ba:	02d00693          	li	a3,45
ffffffffc02057be:	0cd79163          	bne	a5,a3,ffffffffc0205880 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057c2:	00044783          	lbu	a5,0(s0)
ffffffffc02057c6:	0007851b          	sext.w	a0,a5
ffffffffc02057ca:	cf85                	beqz	a5,ffffffffc0205802 <vprintfmt+0x236>
ffffffffc02057cc:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057d0:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057d4:	000c4563          	bltz	s8,ffffffffc02057de <vprintfmt+0x212>
ffffffffc02057d8:	3c7d                	addiw	s8,s8,-1
ffffffffc02057da:	036c0263          	beq	s8,s6,ffffffffc02057fe <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02057de:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057e0:	0e0c8e63          	beqz	s9,ffffffffc02058dc <vprintfmt+0x310>
ffffffffc02057e4:	3781                	addiw	a5,a5,-32
ffffffffc02057e6:	0ef47b63          	bgeu	s0,a5,ffffffffc02058dc <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02057ea:	03f00513          	li	a0,63
ffffffffc02057ee:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057f0:	000a4783          	lbu	a5,0(s4)
ffffffffc02057f4:	3dfd                	addiw	s11,s11,-1
ffffffffc02057f6:	0a05                	addi	s4,s4,1
ffffffffc02057f8:	0007851b          	sext.w	a0,a5
ffffffffc02057fc:	ffe1                	bnez	a5,ffffffffc02057d4 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02057fe:	01b05963          	blez	s11,ffffffffc0205810 <vprintfmt+0x244>
ffffffffc0205802:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0205804:	85a6                	mv	a1,s1
ffffffffc0205806:	02000513          	li	a0,32
ffffffffc020580a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020580c:	fe0d9be3          	bnez	s11,ffffffffc0205802 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205810:	6a02                	ld	s4,0(sp)
ffffffffc0205812:	bbd5                	j	ffffffffc0205606 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205814:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205816:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020581a:	01174463          	blt	a4,a7,ffffffffc0205822 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020581e:	08088d63          	beqz	a7,ffffffffc02058b8 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205822:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205826:	0a044d63          	bltz	s0,ffffffffc02058e0 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020582a:	8622                	mv	a2,s0
ffffffffc020582c:	8a66                	mv	s4,s9
ffffffffc020582e:	46a9                	li	a3,10
ffffffffc0205830:	bdcd                	j	ffffffffc0205722 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205832:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205836:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205838:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020583a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020583e:	8fb5                	xor	a5,a5,a3
ffffffffc0205840:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205844:	02d74163          	blt	a4,a3,ffffffffc0205866 <vprintfmt+0x29a>
ffffffffc0205848:	00369793          	slli	a5,a3,0x3
ffffffffc020584c:	97de                	add	a5,a5,s7
ffffffffc020584e:	639c                	ld	a5,0(a5)
ffffffffc0205850:	cb99                	beqz	a5,ffffffffc0205866 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205852:	86be                	mv	a3,a5
ffffffffc0205854:	00000617          	auipc	a2,0x0
ffffffffc0205858:	13c60613          	addi	a2,a2,316 # ffffffffc0205990 <etext+0x2c>
ffffffffc020585c:	85a6                	mv	a1,s1
ffffffffc020585e:	854a                	mv	a0,s2
ffffffffc0205860:	0ce000ef          	jal	ra,ffffffffc020592e <printfmt>
ffffffffc0205864:	b34d                	j	ffffffffc0205606 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205866:	00002617          	auipc	a2,0x2
ffffffffc020586a:	77a60613          	addi	a2,a2,1914 # ffffffffc0207fe0 <syscalls+0x820>
ffffffffc020586e:	85a6                	mv	a1,s1
ffffffffc0205870:	854a                	mv	a0,s2
ffffffffc0205872:	0bc000ef          	jal	ra,ffffffffc020592e <printfmt>
ffffffffc0205876:	bb41                	j	ffffffffc0205606 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205878:	00002417          	auipc	s0,0x2
ffffffffc020587c:	76040413          	addi	s0,s0,1888 # ffffffffc0207fd8 <syscalls+0x818>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205880:	85e2                	mv	a1,s8
ffffffffc0205882:	8522                	mv	a0,s0
ffffffffc0205884:	e43e                	sd	a5,8(sp)
ffffffffc0205886:	c29ff0ef          	jal	ra,ffffffffc02054ae <strnlen>
ffffffffc020588a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020588e:	01b05b63          	blez	s11,ffffffffc02058a4 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205892:	67a2                	ld	a5,8(sp)
ffffffffc0205894:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205898:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020589a:	85a6                	mv	a1,s1
ffffffffc020589c:	8552                	mv	a0,s4
ffffffffc020589e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02058a0:	fe0d9ce3          	bnez	s11,ffffffffc0205898 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058a4:	00044783          	lbu	a5,0(s0)
ffffffffc02058a8:	00140a13          	addi	s4,s0,1
ffffffffc02058ac:	0007851b          	sext.w	a0,a5
ffffffffc02058b0:	d3a5                	beqz	a5,ffffffffc0205810 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02058b2:	05e00413          	li	s0,94
ffffffffc02058b6:	bf39                	j	ffffffffc02057d4 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02058b8:	000a2403          	lw	s0,0(s4)
ffffffffc02058bc:	b7ad                	j	ffffffffc0205826 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02058be:	000a6603          	lwu	a2,0(s4)
ffffffffc02058c2:	46a1                	li	a3,8
ffffffffc02058c4:	8a2e                	mv	s4,a1
ffffffffc02058c6:	bdb1                	j	ffffffffc0205722 <vprintfmt+0x156>
ffffffffc02058c8:	000a6603          	lwu	a2,0(s4)
ffffffffc02058cc:	46a9                	li	a3,10
ffffffffc02058ce:	8a2e                	mv	s4,a1
ffffffffc02058d0:	bd89                	j	ffffffffc0205722 <vprintfmt+0x156>
ffffffffc02058d2:	000a6603          	lwu	a2,0(s4)
ffffffffc02058d6:	46c1                	li	a3,16
ffffffffc02058d8:	8a2e                	mv	s4,a1
ffffffffc02058da:	b5a1                	j	ffffffffc0205722 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02058dc:	9902                	jalr	s2
ffffffffc02058de:	bf09                	j	ffffffffc02057f0 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02058e0:	85a6                	mv	a1,s1
ffffffffc02058e2:	02d00513          	li	a0,45
ffffffffc02058e6:	e03e                	sd	a5,0(sp)
ffffffffc02058e8:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02058ea:	6782                	ld	a5,0(sp)
ffffffffc02058ec:	8a66                	mv	s4,s9
ffffffffc02058ee:	40800633          	neg	a2,s0
ffffffffc02058f2:	46a9                	li	a3,10
ffffffffc02058f4:	b53d                	j	ffffffffc0205722 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02058f6:	03b05163          	blez	s11,ffffffffc0205918 <vprintfmt+0x34c>
ffffffffc02058fa:	02d00693          	li	a3,45
ffffffffc02058fe:	f6d79de3          	bne	a5,a3,ffffffffc0205878 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0205902:	00002417          	auipc	s0,0x2
ffffffffc0205906:	6d640413          	addi	s0,s0,1750 # ffffffffc0207fd8 <syscalls+0x818>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020590a:	02800793          	li	a5,40
ffffffffc020590e:	02800513          	li	a0,40
ffffffffc0205912:	00140a13          	addi	s4,s0,1
ffffffffc0205916:	bd6d                	j	ffffffffc02057d0 <vprintfmt+0x204>
ffffffffc0205918:	00002a17          	auipc	s4,0x2
ffffffffc020591c:	6c1a0a13          	addi	s4,s4,1729 # ffffffffc0207fd9 <syscalls+0x819>
ffffffffc0205920:	02800513          	li	a0,40
ffffffffc0205924:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205928:	05e00413          	li	s0,94
ffffffffc020592c:	b565                	j	ffffffffc02057d4 <vprintfmt+0x208>

ffffffffc020592e <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020592e:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205930:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205934:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205936:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205938:	ec06                	sd	ra,24(sp)
ffffffffc020593a:	f83a                	sd	a4,48(sp)
ffffffffc020593c:	fc3e                	sd	a5,56(sp)
ffffffffc020593e:	e0c2                	sd	a6,64(sp)
ffffffffc0205940:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205942:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205944:	c89ff0ef          	jal	ra,ffffffffc02055cc <vprintfmt>
}
ffffffffc0205948:	60e2                	ld	ra,24(sp)
ffffffffc020594a:	6161                	addi	sp,sp,80
ffffffffc020594c:	8082                	ret

ffffffffc020594e <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020594e:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205952:	2785                	addiw	a5,a5,1
ffffffffc0205954:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205958:	02000793          	li	a5,32
ffffffffc020595c:	9f8d                	subw	a5,a5,a1
}
ffffffffc020595e:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205962:	8082                	ret
