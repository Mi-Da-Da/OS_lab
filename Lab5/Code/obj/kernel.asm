
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

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
ffffffffc020004a:	000a6517          	auipc	a0,0xa6
ffffffffc020004e:	72e50513          	addi	a0,a0,1838 # ffffffffc02a6778 <buf>
ffffffffc0200052:	000ab617          	auipc	a2,0xab
ffffffffc0200056:	bca60613          	addi	a2,a2,-1078 # ffffffffc02aac1c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	336050ef          	jal	ra,ffffffffc0205398 <memset>
    dtb_init();
ffffffffc0200066:	4d6000ef          	jal	ra,ffffffffc020053c <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	0d7000ef          	jal	ra,ffffffffc0200940 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	75a58593          	addi	a1,a1,1882 # ffffffffc02057c8 <etext+0x2>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	77250513          	addi	a0,a0,1906 # ffffffffc02057e8 <etext+0x22>
ffffffffc020007e:	062000ef          	jal	ra,ffffffffc02000e0 <cprintf>

    print_kerninfo();
ffffffffc0200082:	248000ef          	jal	ra,ffffffffc02002ca <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6c3020ef          	jal	ra,ffffffffc0202f48 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	129000ef          	jal	ra,ffffffffc02009b2 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	133000ef          	jal	ra,ffffffffc02009c0 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	3a2010ef          	jal	ra,ffffffffc0201434 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	6c3040ef          	jal	ra,ffffffffc0204f58 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	053000ef          	jal	ra,ffffffffc02008ec <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	117000ef          	jal	ra,ffffffffc02009b4 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	04e050ef          	jal	ra,ffffffffc02050f0 <cpu_idle>

ffffffffc02000a6 <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc02000a6:	1141                	addi	sp,sp,-16
ffffffffc02000a8:	e022                	sd	s0,0(sp)
ffffffffc02000aa:	e406                	sd	ra,8(sp)
ffffffffc02000ac:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000ae:	095000ef          	jal	ra,ffffffffc0200942 <cons_putc>
    (*cnt)++;
ffffffffc02000b2:	401c                	lw	a5,0(s0)
}
ffffffffc02000b4:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc02000b6:	2785                	addiw	a5,a5,1
ffffffffc02000b8:	c01c                	sw	a5,0(s0)
}
ffffffffc02000ba:	6402                	ld	s0,0(sp)
ffffffffc02000bc:	0141                	addi	sp,sp,16
ffffffffc02000be:	8082                	ret

ffffffffc02000c0 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc02000c0:	1101                	addi	sp,sp,-32
ffffffffc02000c2:	862a                	mv	a2,a0
ffffffffc02000c4:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000c6:	00000517          	auipc	a0,0x0
ffffffffc02000ca:	fe050513          	addi	a0,a0,-32 # ffffffffc02000a6 <cputch>
ffffffffc02000ce:	006c                	addi	a1,sp,12
{
ffffffffc02000d0:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000d2:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000d4:	35a050ef          	jal	ra,ffffffffc020542e <vprintfmt>
    return cnt;
}
ffffffffc02000d8:	60e2                	ld	ra,24(sp)
ffffffffc02000da:	4532                	lw	a0,12(sp)
ffffffffc02000dc:	6105                	addi	sp,sp,32
ffffffffc02000de:	8082                	ret

ffffffffc02000e0 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc02000e0:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000e2:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc02000e6:	8e2a                	mv	t3,a0
ffffffffc02000e8:	f42e                	sd	a1,40(sp)
ffffffffc02000ea:	f832                	sd	a2,48(sp)
ffffffffc02000ec:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000ee:	00000517          	auipc	a0,0x0
ffffffffc02000f2:	fb850513          	addi	a0,a0,-72 # ffffffffc02000a6 <cputch>
ffffffffc02000f6:	004c                	addi	a1,sp,4
ffffffffc02000f8:	869a                	mv	a3,t1
ffffffffc02000fa:	8672                	mv	a2,t3
{
ffffffffc02000fc:	ec06                	sd	ra,24(sp)
ffffffffc02000fe:	e0ba                	sd	a4,64(sp)
ffffffffc0200100:	e4be                	sd	a5,72(sp)
ffffffffc0200102:	e8c2                	sd	a6,80(sp)
ffffffffc0200104:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200106:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200108:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020010a:	324050ef          	jal	ra,ffffffffc020542e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020010e:	60e2                	ld	ra,24(sp)
ffffffffc0200110:	4512                	lw	a0,4(sp)
ffffffffc0200112:	6125                	addi	sp,sp,96
ffffffffc0200114:	8082                	ret

ffffffffc0200116 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc0200116:	02d0006f          	j	ffffffffc0200942 <cons_putc>

ffffffffc020011a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc020011a:	1101                	addi	sp,sp,-32
ffffffffc020011c:	e822                	sd	s0,16(sp)
ffffffffc020011e:	ec06                	sd	ra,24(sp)
ffffffffc0200120:	e426                	sd	s1,8(sp)
ffffffffc0200122:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc0200124:	00054503          	lbu	a0,0(a0)
ffffffffc0200128:	c51d                	beqz	a0,ffffffffc0200156 <cputs+0x3c>
ffffffffc020012a:	0405                	addi	s0,s0,1
ffffffffc020012c:	4485                	li	s1,1
ffffffffc020012e:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200130:	013000ef          	jal	ra,ffffffffc0200942 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc0200134:	00044503          	lbu	a0,0(s0)
ffffffffc0200138:	008487bb          	addw	a5,s1,s0
ffffffffc020013c:	0405                	addi	s0,s0,1
ffffffffc020013e:	f96d                	bnez	a0,ffffffffc0200130 <cputs+0x16>
    (*cnt)++;
ffffffffc0200140:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200144:	4529                	li	a0,10
ffffffffc0200146:	7fc000ef          	jal	ra,ffffffffc0200942 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020014a:	60e2                	ld	ra,24(sp)
ffffffffc020014c:	8522                	mv	a0,s0
ffffffffc020014e:	6442                	ld	s0,16(sp)
ffffffffc0200150:	64a2                	ld	s1,8(sp)
ffffffffc0200152:	6105                	addi	sp,sp,32
ffffffffc0200154:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200156:	4405                	li	s0,1
ffffffffc0200158:	b7f5                	j	ffffffffc0200144 <cputs+0x2a>

ffffffffc020015a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020015e:	019000ef          	jal	ra,ffffffffc0200976 <cons_getc>
ffffffffc0200162:	dd75                	beqz	a0,ffffffffc020015e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200164:	60a2                	ld	ra,8(sp)
ffffffffc0200166:	0141                	addi	sp,sp,16
ffffffffc0200168:	8082                	ret

ffffffffc020016a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020016a:	715d                	addi	sp,sp,-80
ffffffffc020016c:	e486                	sd	ra,72(sp)
ffffffffc020016e:	e0a6                	sd	s1,64(sp)
ffffffffc0200170:	fc4a                	sd	s2,56(sp)
ffffffffc0200172:	f84e                	sd	s3,48(sp)
ffffffffc0200174:	f452                	sd	s4,40(sp)
ffffffffc0200176:	f056                	sd	s5,32(sp)
ffffffffc0200178:	ec5a                	sd	s6,24(sp)
ffffffffc020017a:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc020017c:	c901                	beqz	a0,ffffffffc020018c <readline+0x22>
ffffffffc020017e:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0200180:	00005517          	auipc	a0,0x5
ffffffffc0200184:	67050513          	addi	a0,a0,1648 # ffffffffc02057f0 <etext+0x2a>
ffffffffc0200188:	f59ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
readline(const char *prompt) {
ffffffffc020018c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020018e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200190:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200192:	4aa9                	li	s5,10
ffffffffc0200194:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0200196:	000a6b97          	auipc	s7,0xa6
ffffffffc020019a:	5e2b8b93          	addi	s7,s7,1506 # ffffffffc02a6778 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020019e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02001a2:	fb9ff0ef          	jal	ra,ffffffffc020015a <getchar>
        if (c < 0) {
ffffffffc02001a6:	00054a63          	bltz	a0,ffffffffc02001ba <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001aa:	00a95a63          	bge	s2,a0,ffffffffc02001be <readline+0x54>
ffffffffc02001ae:	029a5263          	bge	s4,s1,ffffffffc02001d2 <readline+0x68>
        c = getchar();
ffffffffc02001b2:	fa9ff0ef          	jal	ra,ffffffffc020015a <getchar>
        if (c < 0) {
ffffffffc02001b6:	fe055ae3          	bgez	a0,ffffffffc02001aa <readline+0x40>
            return NULL;
ffffffffc02001ba:	4501                	li	a0,0
ffffffffc02001bc:	a091                	j	ffffffffc0200200 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02001be:	03351463          	bne	a0,s3,ffffffffc02001e6 <readline+0x7c>
ffffffffc02001c2:	e8a9                	bnez	s1,ffffffffc0200214 <readline+0xaa>
        c = getchar();
ffffffffc02001c4:	f97ff0ef          	jal	ra,ffffffffc020015a <getchar>
        if (c < 0) {
ffffffffc02001c8:	fe0549e3          	bltz	a0,ffffffffc02001ba <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001cc:	fea959e3          	bge	s2,a0,ffffffffc02001be <readline+0x54>
ffffffffc02001d0:	4481                	li	s1,0
            cputchar(c);
ffffffffc02001d2:	e42a                	sd	a0,8(sp)
ffffffffc02001d4:	f43ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i ++] = c;
ffffffffc02001d8:	6522                	ld	a0,8(sp)
ffffffffc02001da:	009b87b3          	add	a5,s7,s1
ffffffffc02001de:	2485                	addiw	s1,s1,1
ffffffffc02001e0:	00a78023          	sb	a0,0(a5)
ffffffffc02001e4:	bf7d                	j	ffffffffc02001a2 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02001e6:	01550463          	beq	a0,s5,ffffffffc02001ee <readline+0x84>
ffffffffc02001ea:	fb651ce3          	bne	a0,s6,ffffffffc02001a2 <readline+0x38>
            cputchar(c);
ffffffffc02001ee:	f29ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i] = '\0';
ffffffffc02001f2:	000a6517          	auipc	a0,0xa6
ffffffffc02001f6:	58650513          	addi	a0,a0,1414 # ffffffffc02a6778 <buf>
ffffffffc02001fa:	94aa                	add	s1,s1,a0
ffffffffc02001fc:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200200:	60a6                	ld	ra,72(sp)
ffffffffc0200202:	6486                	ld	s1,64(sp)
ffffffffc0200204:	7962                	ld	s2,56(sp)
ffffffffc0200206:	79c2                	ld	s3,48(sp)
ffffffffc0200208:	7a22                	ld	s4,40(sp)
ffffffffc020020a:	7a82                	ld	s5,32(sp)
ffffffffc020020c:	6b62                	ld	s6,24(sp)
ffffffffc020020e:	6bc2                	ld	s7,16(sp)
ffffffffc0200210:	6161                	addi	sp,sp,80
ffffffffc0200212:	8082                	ret
            cputchar(c);
ffffffffc0200214:	4521                	li	a0,8
ffffffffc0200216:	f01ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            i --;
ffffffffc020021a:	34fd                	addiw	s1,s1,-1
ffffffffc020021c:	b759                	j	ffffffffc02001a2 <readline+0x38>

ffffffffc020021e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020021e:	000ab317          	auipc	t1,0xab
ffffffffc0200222:	98230313          	addi	t1,t1,-1662 # ffffffffc02aaba0 <is_panic>
ffffffffc0200226:	00033e03          	ld	t3,0(t1)
{
ffffffffc020022a:	715d                	addi	sp,sp,-80
ffffffffc020022c:	ec06                	sd	ra,24(sp)
ffffffffc020022e:	e822                	sd	s0,16(sp)
ffffffffc0200230:	f436                	sd	a3,40(sp)
ffffffffc0200232:	f83a                	sd	a4,48(sp)
ffffffffc0200234:	fc3e                	sd	a5,56(sp)
ffffffffc0200236:	e0c2                	sd	a6,64(sp)
ffffffffc0200238:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc020023a:	020e1a63          	bnez	t3,ffffffffc020026e <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020023e:	4785                	li	a5,1
ffffffffc0200240:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200244:	8432                	mv	s0,a2
ffffffffc0200246:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200248:	862e                	mv	a2,a1
ffffffffc020024a:	85aa                	mv	a1,a0
ffffffffc020024c:	00005517          	auipc	a0,0x5
ffffffffc0200250:	5ac50513          	addi	a0,a0,1452 # ffffffffc02057f8 <etext+0x32>
    va_start(ap, fmt);
ffffffffc0200254:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200256:	e8bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020025a:	65a2                	ld	a1,8(sp)
ffffffffc020025c:	8522                	mv	a0,s0
ffffffffc020025e:	e63ff0ef          	jal	ra,ffffffffc02000c0 <vcprintf>
    cprintf("\n");
ffffffffc0200262:	00007517          	auipc	a0,0x7
ffffffffc0200266:	bee50513          	addi	a0,a0,-1042 # ffffffffc0206e50 <default_pmm_manager+0x488>
ffffffffc020026a:	e77ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc020026e:	4501                	li	a0,0
ffffffffc0200270:	4581                	li	a1,0
ffffffffc0200272:	4601                	li	a2,0
ffffffffc0200274:	48a1                	li	a7,8
ffffffffc0200276:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc020027a:	740000ef          	jal	ra,ffffffffc02009ba <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc020027e:	4501                	li	a0,0
ffffffffc0200280:	174000ef          	jal	ra,ffffffffc02003f4 <kmonitor>
    while (1)
ffffffffc0200284:	bfed                	j	ffffffffc020027e <__panic+0x60>

ffffffffc0200286 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc0200286:	715d                	addi	sp,sp,-80
ffffffffc0200288:	832e                	mv	t1,a1
ffffffffc020028a:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020028c:	85aa                	mv	a1,a0
{
ffffffffc020028e:	8432                	mv	s0,a2
ffffffffc0200290:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200292:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200294:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200296:	00005517          	auipc	a0,0x5
ffffffffc020029a:	58250513          	addi	a0,a0,1410 # ffffffffc0205818 <etext+0x52>
{
ffffffffc020029e:	ec06                	sd	ra,24(sp)
ffffffffc02002a0:	f436                	sd	a3,40(sp)
ffffffffc02002a2:	f83a                	sd	a4,48(sp)
ffffffffc02002a4:	e0c2                	sd	a6,64(sp)
ffffffffc02002a6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02002a8:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02002aa:	e37ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02002ae:	65a2                	ld	a1,8(sp)
ffffffffc02002b0:	8522                	mv	a0,s0
ffffffffc02002b2:	e0fff0ef          	jal	ra,ffffffffc02000c0 <vcprintf>
    cprintf("\n");
ffffffffc02002b6:	00007517          	auipc	a0,0x7
ffffffffc02002ba:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0206e50 <default_pmm_manager+0x488>
ffffffffc02002be:	e23ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    va_end(ap);
}
ffffffffc02002c2:	60e2                	ld	ra,24(sp)
ffffffffc02002c4:	6442                	ld	s0,16(sp)
ffffffffc02002c6:	6161                	addi	sp,sp,80
ffffffffc02002c8:	8082                	ret

ffffffffc02002ca <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02002ca:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02002cc:	00005517          	auipc	a0,0x5
ffffffffc02002d0:	56c50513          	addi	a0,a0,1388 # ffffffffc0205838 <etext+0x72>
{
ffffffffc02002d4:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02002d6:	e0bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02002da:	00000597          	auipc	a1,0x0
ffffffffc02002de:	d7058593          	addi	a1,a1,-656 # ffffffffc020004a <kern_init>
ffffffffc02002e2:	00005517          	auipc	a0,0x5
ffffffffc02002e6:	57650513          	addi	a0,a0,1398 # ffffffffc0205858 <etext+0x92>
ffffffffc02002ea:	df7ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	4d858593          	addi	a1,a1,1240 # ffffffffc02057c6 <etext>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	58250513          	addi	a0,a0,1410 # ffffffffc0205878 <etext+0xb2>
ffffffffc02002fe:	de3ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200302:	000a6597          	auipc	a1,0xa6
ffffffffc0200306:	47658593          	addi	a1,a1,1142 # ffffffffc02a6778 <buf>
ffffffffc020030a:	00005517          	auipc	a0,0x5
ffffffffc020030e:	58e50513          	addi	a0,a0,1422 # ffffffffc0205898 <etext+0xd2>
ffffffffc0200312:	dcfff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200316:	000ab597          	auipc	a1,0xab
ffffffffc020031a:	90658593          	addi	a1,a1,-1786 # ffffffffc02aac1c <end>
ffffffffc020031e:	00005517          	auipc	a0,0x5
ffffffffc0200322:	59a50513          	addi	a0,a0,1434 # ffffffffc02058b8 <etext+0xf2>
ffffffffc0200326:	dbbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020032a:	000ab597          	auipc	a1,0xab
ffffffffc020032e:	cf158593          	addi	a1,a1,-783 # ffffffffc02ab01b <end+0x3ff>
ffffffffc0200332:	00000797          	auipc	a5,0x0
ffffffffc0200336:	d1878793          	addi	a5,a5,-744 # ffffffffc020004a <kern_init>
ffffffffc020033a:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020033e:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200342:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200344:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200348:	95be                	add	a1,a1,a5
ffffffffc020034a:	85a9                	srai	a1,a1,0xa
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	58c50513          	addi	a0,a0,1420 # ffffffffc02058d8 <etext+0x112>
}
ffffffffc0200354:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200356:	b369                	j	ffffffffc02000e0 <cprintf>

ffffffffc0200358 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc0200358:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc020035a:	00005617          	auipc	a2,0x5
ffffffffc020035e:	5ae60613          	addi	a2,a2,1454 # ffffffffc0205908 <etext+0x142>
ffffffffc0200362:	04f00593          	li	a1,79
ffffffffc0200366:	00005517          	auipc	a0,0x5
ffffffffc020036a:	5ba50513          	addi	a0,a0,1466 # ffffffffc0205920 <etext+0x15a>
{
ffffffffc020036e:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200370:	eafff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0200374 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200374:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200376:	00005617          	auipc	a2,0x5
ffffffffc020037a:	5c260613          	addi	a2,a2,1474 # ffffffffc0205938 <etext+0x172>
ffffffffc020037e:	00005597          	auipc	a1,0x5
ffffffffc0200382:	5da58593          	addi	a1,a1,1498 # ffffffffc0205958 <etext+0x192>
ffffffffc0200386:	00005517          	auipc	a0,0x5
ffffffffc020038a:	5da50513          	addi	a0,a0,1498 # ffffffffc0205960 <etext+0x19a>
{
ffffffffc020038e:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200390:	d51ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0200394:	00005617          	auipc	a2,0x5
ffffffffc0200398:	5dc60613          	addi	a2,a2,1500 # ffffffffc0205970 <etext+0x1aa>
ffffffffc020039c:	00005597          	auipc	a1,0x5
ffffffffc02003a0:	5fc58593          	addi	a1,a1,1532 # ffffffffc0205998 <etext+0x1d2>
ffffffffc02003a4:	00005517          	auipc	a0,0x5
ffffffffc02003a8:	5bc50513          	addi	a0,a0,1468 # ffffffffc0205960 <etext+0x19a>
ffffffffc02003ac:	d35ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc02003b0:	00005617          	auipc	a2,0x5
ffffffffc02003b4:	5f860613          	addi	a2,a2,1528 # ffffffffc02059a8 <etext+0x1e2>
ffffffffc02003b8:	00005597          	auipc	a1,0x5
ffffffffc02003bc:	61058593          	addi	a1,a1,1552 # ffffffffc02059c8 <etext+0x202>
ffffffffc02003c0:	00005517          	auipc	a0,0x5
ffffffffc02003c4:	5a050513          	addi	a0,a0,1440 # ffffffffc0205960 <etext+0x19a>
ffffffffc02003c8:	d19ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    return 0;
}
ffffffffc02003cc:	60a2                	ld	ra,8(sp)
ffffffffc02003ce:	4501                	li	a0,0
ffffffffc02003d0:	0141                	addi	sp,sp,16
ffffffffc02003d2:	8082                	ret

ffffffffc02003d4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02003d4:	1141                	addi	sp,sp,-16
ffffffffc02003d6:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02003d8:	ef3ff0ef          	jal	ra,ffffffffc02002ca <print_kerninfo>
    return 0;
}
ffffffffc02003dc:	60a2                	ld	ra,8(sp)
ffffffffc02003de:	4501                	li	a0,0
ffffffffc02003e0:	0141                	addi	sp,sp,16
ffffffffc02003e2:	8082                	ret

ffffffffc02003e4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02003e4:	1141                	addi	sp,sp,-16
ffffffffc02003e6:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02003e8:	f71ff0ef          	jal	ra,ffffffffc0200358 <print_stackframe>
    return 0;
}
ffffffffc02003ec:	60a2                	ld	ra,8(sp)
ffffffffc02003ee:	4501                	li	a0,0
ffffffffc02003f0:	0141                	addi	sp,sp,16
ffffffffc02003f2:	8082                	ret

ffffffffc02003f4 <kmonitor>:
{
ffffffffc02003f4:	7115                	addi	sp,sp,-224
ffffffffc02003f6:	ed5e                	sd	s7,152(sp)
ffffffffc02003f8:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02003fa:	00005517          	auipc	a0,0x5
ffffffffc02003fe:	5de50513          	addi	a0,a0,1502 # ffffffffc02059d8 <etext+0x212>
{
ffffffffc0200402:	ed86                	sd	ra,216(sp)
ffffffffc0200404:	e9a2                	sd	s0,208(sp)
ffffffffc0200406:	e5a6                	sd	s1,200(sp)
ffffffffc0200408:	e1ca                	sd	s2,192(sp)
ffffffffc020040a:	fd4e                	sd	s3,184(sp)
ffffffffc020040c:	f952                	sd	s4,176(sp)
ffffffffc020040e:	f556                	sd	s5,168(sp)
ffffffffc0200410:	f15a                	sd	s6,160(sp)
ffffffffc0200412:	e962                	sd	s8,144(sp)
ffffffffc0200414:	e566                	sd	s9,136(sp)
ffffffffc0200416:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200418:	cc9ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020041c:	00005517          	auipc	a0,0x5
ffffffffc0200420:	5e450513          	addi	a0,a0,1508 # ffffffffc0205a00 <etext+0x23a>
ffffffffc0200424:	cbdff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    if (tf != NULL)
ffffffffc0200428:	000b8563          	beqz	s7,ffffffffc0200432 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020042c:	855e                	mv	a0,s7
ffffffffc020042e:	77a000ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
ffffffffc0200432:	00005c17          	auipc	s8,0x5
ffffffffc0200436:	63ec0c13          	addi	s8,s8,1598 # ffffffffc0205a70 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020043a:	00005917          	auipc	s2,0x5
ffffffffc020043e:	5ee90913          	addi	s2,s2,1518 # ffffffffc0205a28 <etext+0x262>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200442:	00005497          	auipc	s1,0x5
ffffffffc0200446:	5ee48493          	addi	s1,s1,1518 # ffffffffc0205a30 <etext+0x26a>
        if (argc == MAXARGS - 1)
ffffffffc020044a:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020044c:	00005b17          	auipc	s6,0x5
ffffffffc0200450:	5ecb0b13          	addi	s6,s6,1516 # ffffffffc0205a38 <etext+0x272>
        argv[argc++] = buf;
ffffffffc0200454:	00005a17          	auipc	s4,0x5
ffffffffc0200458:	504a0a13          	addi	s4,s4,1284 # ffffffffc0205958 <etext+0x192>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020045c:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc020045e:	854a                	mv	a0,s2
ffffffffc0200460:	d0bff0ef          	jal	ra,ffffffffc020016a <readline>
ffffffffc0200464:	842a                	mv	s0,a0
ffffffffc0200466:	dd65                	beqz	a0,ffffffffc020045e <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200468:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020046c:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046e:	e1bd                	bnez	a1,ffffffffc02004d4 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc0200470:	fe0c87e3          	beqz	s9,ffffffffc020045e <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200474:	6582                	ld	a1,0(sp)
ffffffffc0200476:	00005d17          	auipc	s10,0x5
ffffffffc020047a:	5fad0d13          	addi	s10,s10,1530 # ffffffffc0205a70 <commands>
        argv[argc++] = buf;
ffffffffc020047e:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200480:	4401                	li	s0,0
ffffffffc0200482:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200484:	6bb040ef          	jal	ra,ffffffffc020533e <strcmp>
ffffffffc0200488:	c919                	beqz	a0,ffffffffc020049e <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020048a:	2405                	addiw	s0,s0,1
ffffffffc020048c:	0b540063          	beq	s0,s5,ffffffffc020052c <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200490:	000d3503          	ld	a0,0(s10)
ffffffffc0200494:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200496:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200498:	6a7040ef          	jal	ra,ffffffffc020533e <strcmp>
ffffffffc020049c:	f57d                	bnez	a0,ffffffffc020048a <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020049e:	00141793          	slli	a5,s0,0x1
ffffffffc02004a2:	97a2                	add	a5,a5,s0
ffffffffc02004a4:	078e                	slli	a5,a5,0x3
ffffffffc02004a6:	97e2                	add	a5,a5,s8
ffffffffc02004a8:	6b9c                	ld	a5,16(a5)
ffffffffc02004aa:	865e                	mv	a2,s7
ffffffffc02004ac:	002c                	addi	a1,sp,8
ffffffffc02004ae:	fffc851b          	addiw	a0,s9,-1
ffffffffc02004b2:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc02004b4:	fa0555e3          	bgez	a0,ffffffffc020045e <kmonitor+0x6a>
}
ffffffffc02004b8:	60ee                	ld	ra,216(sp)
ffffffffc02004ba:	644e                	ld	s0,208(sp)
ffffffffc02004bc:	64ae                	ld	s1,200(sp)
ffffffffc02004be:	690e                	ld	s2,192(sp)
ffffffffc02004c0:	79ea                	ld	s3,184(sp)
ffffffffc02004c2:	7a4a                	ld	s4,176(sp)
ffffffffc02004c4:	7aaa                	ld	s5,168(sp)
ffffffffc02004c6:	7b0a                	ld	s6,160(sp)
ffffffffc02004c8:	6bea                	ld	s7,152(sp)
ffffffffc02004ca:	6c4a                	ld	s8,144(sp)
ffffffffc02004cc:	6caa                	ld	s9,136(sp)
ffffffffc02004ce:	6d0a                	ld	s10,128(sp)
ffffffffc02004d0:	612d                	addi	sp,sp,224
ffffffffc02004d2:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02004d4:	8526                	mv	a0,s1
ffffffffc02004d6:	6ad040ef          	jal	ra,ffffffffc0205382 <strchr>
ffffffffc02004da:	c901                	beqz	a0,ffffffffc02004ea <kmonitor+0xf6>
ffffffffc02004dc:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc02004e0:	00040023          	sb	zero,0(s0)
ffffffffc02004e4:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02004e6:	d5c9                	beqz	a1,ffffffffc0200470 <kmonitor+0x7c>
ffffffffc02004e8:	b7f5                	j	ffffffffc02004d4 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc02004ea:	00044783          	lbu	a5,0(s0)
ffffffffc02004ee:	d3c9                	beqz	a5,ffffffffc0200470 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc02004f0:	033c8963          	beq	s9,s3,ffffffffc0200522 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc02004f4:	003c9793          	slli	a5,s9,0x3
ffffffffc02004f8:	0118                	addi	a4,sp,128
ffffffffc02004fa:	97ba                	add	a5,a5,a4
ffffffffc02004fc:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200500:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200504:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200506:	e591                	bnez	a1,ffffffffc0200512 <kmonitor+0x11e>
ffffffffc0200508:	b7b5                	j	ffffffffc0200474 <kmonitor+0x80>
ffffffffc020050a:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc020050e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200510:	d1a5                	beqz	a1,ffffffffc0200470 <kmonitor+0x7c>
ffffffffc0200512:	8526                	mv	a0,s1
ffffffffc0200514:	66f040ef          	jal	ra,ffffffffc0205382 <strchr>
ffffffffc0200518:	d96d                	beqz	a0,ffffffffc020050a <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020051a:	00044583          	lbu	a1,0(s0)
ffffffffc020051e:	d9a9                	beqz	a1,ffffffffc0200470 <kmonitor+0x7c>
ffffffffc0200520:	bf55                	j	ffffffffc02004d4 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200522:	45c1                	li	a1,16
ffffffffc0200524:	855a                	mv	a0,s6
ffffffffc0200526:	bbbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc020052a:	b7e9                	j	ffffffffc02004f4 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020052c:	6582                	ld	a1,0(sp)
ffffffffc020052e:	00005517          	auipc	a0,0x5
ffffffffc0200532:	52a50513          	addi	a0,a0,1322 # ffffffffc0205a58 <etext+0x292>
ffffffffc0200536:	babff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
ffffffffc020053a:	b715                	j	ffffffffc020045e <kmonitor+0x6a>

ffffffffc020053c <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020053c:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc020053e:	00005517          	auipc	a0,0x5
ffffffffc0200542:	57a50513          	addi	a0,a0,1402 # ffffffffc0205ab8 <commands+0x48>
void dtb_init(void) {
ffffffffc0200546:	fc86                	sd	ra,120(sp)
ffffffffc0200548:	f8a2                	sd	s0,112(sp)
ffffffffc020054a:	e8d2                	sd	s4,80(sp)
ffffffffc020054c:	f4a6                	sd	s1,104(sp)
ffffffffc020054e:	f0ca                	sd	s2,96(sp)
ffffffffc0200550:	ecce                	sd	s3,88(sp)
ffffffffc0200552:	e4d6                	sd	s5,72(sp)
ffffffffc0200554:	e0da                	sd	s6,64(sp)
ffffffffc0200556:	fc5e                	sd	s7,56(sp)
ffffffffc0200558:	f862                	sd	s8,48(sp)
ffffffffc020055a:	f466                	sd	s9,40(sp)
ffffffffc020055c:	f06a                	sd	s10,32(sp)
ffffffffc020055e:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200560:	b81ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200564:	0000b597          	auipc	a1,0xb
ffffffffc0200568:	a9c5b583          	ld	a1,-1380(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020056c:	00005517          	auipc	a0,0x5
ffffffffc0200570:	55c50513          	addi	a0,a0,1372 # ffffffffc0205ac8 <commands+0x58>
ffffffffc0200574:	b6dff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200578:	0000b417          	auipc	s0,0xb
ffffffffc020057c:	a9040413          	addi	s0,s0,-1392 # ffffffffc020b008 <boot_dtb>
ffffffffc0200580:	600c                	ld	a1,0(s0)
ffffffffc0200582:	00005517          	auipc	a0,0x5
ffffffffc0200586:	55650513          	addi	a0,a0,1366 # ffffffffc0205ad8 <commands+0x68>
ffffffffc020058a:	b57ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020058e:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200592:	00005517          	auipc	a0,0x5
ffffffffc0200596:	55e50513          	addi	a0,a0,1374 # ffffffffc0205af0 <commands+0x80>
    if (boot_dtb == 0) {
ffffffffc020059a:	120a0463          	beqz	s4,ffffffffc02006c2 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020059e:	57f5                	li	a5,-3
ffffffffc02005a0:	07fa                	slli	a5,a5,0x1e
ffffffffc02005a2:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02005a6:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a8:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ac:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ae:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005b2:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b6:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ba:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005be:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c4:	8ec9                	or	a3,a3,a0
ffffffffc02005c6:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005ca:	1b7d                	addi	s6,s6,-1
ffffffffc02005cc:	0167f7b3          	and	a5,a5,s6
ffffffffc02005d0:	8dd5                	or	a1,a1,a3
ffffffffc02005d2:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02005d4:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d8:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02005da:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe352d1>
ffffffffc02005de:	10f59163          	bne	a1,a5,ffffffffc02006e0 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005e2:	471c                	lw	a5,8(a4)
ffffffffc02005e4:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02005e6:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e8:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005ec:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02005f0:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f4:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f8:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005fc:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200600:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200604:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200608:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020060c:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200610:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200612:	01146433          	or	s0,s0,a7
ffffffffc0200616:	0086969b          	slliw	a3,a3,0x8
ffffffffc020061a:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020061e:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200620:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200624:	8c49                	or	s0,s0,a0
ffffffffc0200626:	0166f6b3          	and	a3,a3,s6
ffffffffc020062a:	00ca6a33          	or	s4,s4,a2
ffffffffc020062e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200632:	8c55                	or	s0,s0,a3
ffffffffc0200634:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200638:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020063a:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020063c:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020063e:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200642:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200644:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200646:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020064a:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020064c:	00005917          	auipc	s2,0x5
ffffffffc0200650:	4f490913          	addi	s2,s2,1268 # ffffffffc0205b40 <commands+0xd0>
ffffffffc0200654:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200656:	4d91                	li	s11,4
ffffffffc0200658:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020065a:	00005497          	auipc	s1,0x5
ffffffffc020065e:	4de48493          	addi	s1,s1,1246 # ffffffffc0205b38 <commands+0xc8>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200662:	000a2703          	lw	a4,0(s4)
ffffffffc0200666:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	0087569b          	srliw	a3,a4,0x8
ffffffffc020066e:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200672:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200676:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067a:	0107571b          	srliw	a4,a4,0x10
ffffffffc020067e:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200680:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200684:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200688:	8fd5                	or	a5,a5,a3
ffffffffc020068a:	00eb7733          	and	a4,s6,a4
ffffffffc020068e:	8fd9                	or	a5,a5,a4
ffffffffc0200690:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200692:	09778c63          	beq	a5,s7,ffffffffc020072a <dtb_init+0x1ee>
ffffffffc0200696:	00fbea63          	bltu	s7,a5,ffffffffc02006aa <dtb_init+0x16e>
ffffffffc020069a:	07a78663          	beq	a5,s10,ffffffffc0200706 <dtb_init+0x1ca>
ffffffffc020069e:	4709                	li	a4,2
ffffffffc02006a0:	00e79763          	bne	a5,a4,ffffffffc02006ae <dtb_init+0x172>
ffffffffc02006a4:	4c81                	li	s9,0
ffffffffc02006a6:	8a56                	mv	s4,s5
ffffffffc02006a8:	bf6d                	j	ffffffffc0200662 <dtb_init+0x126>
ffffffffc02006aa:	ffb78ee3          	beq	a5,s11,ffffffffc02006a6 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006ae:	00005517          	auipc	a0,0x5
ffffffffc02006b2:	50a50513          	addi	a0,a0,1290 # ffffffffc0205bb8 <commands+0x148>
ffffffffc02006b6:	a2bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006ba:	00005517          	auipc	a0,0x5
ffffffffc02006be:	53650513          	addi	a0,a0,1334 # ffffffffc0205bf0 <commands+0x180>
}
ffffffffc02006c2:	7446                	ld	s0,112(sp)
ffffffffc02006c4:	70e6                	ld	ra,120(sp)
ffffffffc02006c6:	74a6                	ld	s1,104(sp)
ffffffffc02006c8:	7906                	ld	s2,96(sp)
ffffffffc02006ca:	69e6                	ld	s3,88(sp)
ffffffffc02006cc:	6a46                	ld	s4,80(sp)
ffffffffc02006ce:	6aa6                	ld	s5,72(sp)
ffffffffc02006d0:	6b06                	ld	s6,64(sp)
ffffffffc02006d2:	7be2                	ld	s7,56(sp)
ffffffffc02006d4:	7c42                	ld	s8,48(sp)
ffffffffc02006d6:	7ca2                	ld	s9,40(sp)
ffffffffc02006d8:	7d02                	ld	s10,32(sp)
ffffffffc02006da:	6de2                	ld	s11,24(sp)
ffffffffc02006dc:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02006de:	b409                	j	ffffffffc02000e0 <cprintf>
}
ffffffffc02006e0:	7446                	ld	s0,112(sp)
ffffffffc02006e2:	70e6                	ld	ra,120(sp)
ffffffffc02006e4:	74a6                	ld	s1,104(sp)
ffffffffc02006e6:	7906                	ld	s2,96(sp)
ffffffffc02006e8:	69e6                	ld	s3,88(sp)
ffffffffc02006ea:	6a46                	ld	s4,80(sp)
ffffffffc02006ec:	6aa6                	ld	s5,72(sp)
ffffffffc02006ee:	6b06                	ld	s6,64(sp)
ffffffffc02006f0:	7be2                	ld	s7,56(sp)
ffffffffc02006f2:	7c42                	ld	s8,48(sp)
ffffffffc02006f4:	7ca2                	ld	s9,40(sp)
ffffffffc02006f6:	7d02                	ld	s10,32(sp)
ffffffffc02006f8:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02006fa:	00005517          	auipc	a0,0x5
ffffffffc02006fe:	41650513          	addi	a0,a0,1046 # ffffffffc0205b10 <commands+0xa0>
}
ffffffffc0200702:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200704:	baf1                	j	ffffffffc02000e0 <cprintf>
                int name_len = strlen(name);
ffffffffc0200706:	8556                	mv	a0,s5
ffffffffc0200708:	3ef040ef          	jal	ra,ffffffffc02052f6 <strlen>
ffffffffc020070c:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020070e:	4619                	li	a2,6
ffffffffc0200710:	85a6                	mv	a1,s1
ffffffffc0200712:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200714:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200716:	447040ef          	jal	ra,ffffffffc020535c <strncmp>
ffffffffc020071a:	e111                	bnez	a0,ffffffffc020071e <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc020071c:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020071e:	0a91                	addi	s5,s5,4
ffffffffc0200720:	9ad2                	add	s5,s5,s4
ffffffffc0200722:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200726:	8a56                	mv	s4,s5
ffffffffc0200728:	bf2d                	j	ffffffffc0200662 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020072a:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020072e:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200732:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200736:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073a:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073e:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200742:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200746:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020074a:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020074e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200752:	00eaeab3          	or	s5,s5,a4
ffffffffc0200756:	00fb77b3          	and	a5,s6,a5
ffffffffc020075a:	00faeab3          	or	s5,s5,a5
ffffffffc020075e:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200760:	000c9c63          	bnez	s9,ffffffffc0200778 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200764:	1a82                	slli	s5,s5,0x20
ffffffffc0200766:	00368793          	addi	a5,a3,3
ffffffffc020076a:	020ada93          	srli	s5,s5,0x20
ffffffffc020076e:	9abe                	add	s5,s5,a5
ffffffffc0200770:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200774:	8a56                	mv	s4,s5
ffffffffc0200776:	b5f5                	j	ffffffffc0200662 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200778:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020077c:	85ca                	mv	a1,s2
ffffffffc020077e:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200780:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200784:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	0187971b          	slliw	a4,a5,0x18
ffffffffc020078c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200790:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200794:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200796:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020079a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020079e:	8d59                	or	a0,a0,a4
ffffffffc02007a0:	00fb77b3          	and	a5,s6,a5
ffffffffc02007a4:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007a6:	1502                	slli	a0,a0,0x20
ffffffffc02007a8:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007aa:	9522                	add	a0,a0,s0
ffffffffc02007ac:	393040ef          	jal	ra,ffffffffc020533e <strcmp>
ffffffffc02007b0:	66a2                	ld	a3,8(sp)
ffffffffc02007b2:	f94d                	bnez	a0,ffffffffc0200764 <dtb_init+0x228>
ffffffffc02007b4:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200764 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007b8:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007bc:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007c0:	00005517          	auipc	a0,0x5
ffffffffc02007c4:	38850513          	addi	a0,a0,904 # ffffffffc0205b48 <commands+0xd8>
           fdt32_to_cpu(x >> 32);
ffffffffc02007c8:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007cc:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007d0:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d4:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02007d8:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007dc:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e0:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007e4:	0187d693          	srli	a3,a5,0x18
ffffffffc02007e8:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02007ec:	0087579b          	srliw	a5,a4,0x8
ffffffffc02007f0:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f4:	0106561b          	srliw	a2,a2,0x10
ffffffffc02007f8:	010f6f33          	or	t5,t5,a6
ffffffffc02007fc:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200800:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200804:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200808:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200810:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200814:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200818:	0107581b          	srliw	a6,a4,0x10
ffffffffc020081c:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200820:	8361                	srli	a4,a4,0x18
ffffffffc0200822:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200826:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020082a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020082e:	00cb7633          	and	a2,s6,a2
ffffffffc0200832:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200836:	0085959b          	slliw	a1,a1,0x8
ffffffffc020083a:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020083e:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200842:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200846:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084a:	0088989b          	slliw	a7,a7,0x8
ffffffffc020084e:	011b78b3          	and	a7,s6,a7
ffffffffc0200852:	005eeeb3          	or	t4,t4,t0
ffffffffc0200856:	00c6e733          	or	a4,a3,a2
ffffffffc020085a:	006c6c33          	or	s8,s8,t1
ffffffffc020085e:	010b76b3          	and	a3,s6,a6
ffffffffc0200862:	00bb7b33          	and	s6,s6,a1
ffffffffc0200866:	01d7e7b3          	or	a5,a5,t4
ffffffffc020086a:	016c6b33          	or	s6,s8,s6
ffffffffc020086e:	01146433          	or	s0,s0,a7
ffffffffc0200872:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200874:	1702                	slli	a4,a4,0x20
ffffffffc0200876:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200878:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020087a:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020087c:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020087e:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200882:	0167eb33          	or	s6,a5,s6
ffffffffc0200886:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200888:	859ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020088c:	85a2                	mv	a1,s0
ffffffffc020088e:	00005517          	auipc	a0,0x5
ffffffffc0200892:	2da50513          	addi	a0,a0,730 # ffffffffc0205b68 <commands+0xf8>
ffffffffc0200896:	84bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020089a:	014b5613          	srli	a2,s6,0x14
ffffffffc020089e:	85da                	mv	a1,s6
ffffffffc02008a0:	00005517          	auipc	a0,0x5
ffffffffc02008a4:	2e050513          	addi	a0,a0,736 # ffffffffc0205b80 <commands+0x110>
ffffffffc02008a8:	839ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008ac:	008b05b3          	add	a1,s6,s0
ffffffffc02008b0:	15fd                	addi	a1,a1,-1
ffffffffc02008b2:	00005517          	auipc	a0,0x5
ffffffffc02008b6:	2ee50513          	addi	a0,a0,750 # ffffffffc0205ba0 <commands+0x130>
ffffffffc02008ba:	827ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02008be:	00005517          	auipc	a0,0x5
ffffffffc02008c2:	33250513          	addi	a0,a0,818 # ffffffffc0205bf0 <commands+0x180>
        memory_base = mem_base;
ffffffffc02008c6:	000aa797          	auipc	a5,0xaa
ffffffffc02008ca:	2e87b123          	sd	s0,738(a5) # ffffffffc02aaba8 <memory_base>
        memory_size = mem_size;
ffffffffc02008ce:	000aa797          	auipc	a5,0xaa
ffffffffc02008d2:	2f67b123          	sd	s6,738(a5) # ffffffffc02aabb0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02008d6:	b3f5                	j	ffffffffc02006c2 <dtb_init+0x186>

ffffffffc02008d8 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008d8:	000aa517          	auipc	a0,0xaa
ffffffffc02008dc:	2d053503          	ld	a0,720(a0) # ffffffffc02aaba8 <memory_base>
ffffffffc02008e0:	8082                	ret

ffffffffc02008e2 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008e2:	000aa517          	auipc	a0,0xaa
ffffffffc02008e6:	2ce53503          	ld	a0,718(a0) # ffffffffc02aabb0 <memory_size>
ffffffffc02008ea:	8082                	ret

ffffffffc02008ec <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02008ec:	67e1                	lui	a5,0x18
ffffffffc02008ee:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd530>
ffffffffc02008f2:	000aa717          	auipc	a4,0xaa
ffffffffc02008f6:	2cf73723          	sd	a5,718(a4) # ffffffffc02aabc0 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02008fa:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02008fe:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200900:	953e                	add	a0,a0,a5
ffffffffc0200902:	4601                	li	a2,0
ffffffffc0200904:	4881                	li	a7,0
ffffffffc0200906:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc020090a:	02000793          	li	a5,32
ffffffffc020090e:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200912:	00005517          	auipc	a0,0x5
ffffffffc0200916:	2f650513          	addi	a0,a0,758 # ffffffffc0205c08 <commands+0x198>
    ticks = 0;
ffffffffc020091a:	000aa797          	auipc	a5,0xaa
ffffffffc020091e:	2807bf23          	sd	zero,670(a5) # ffffffffc02aabb8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200922:	fbeff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200926 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200926:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020092a:	000aa797          	auipc	a5,0xaa
ffffffffc020092e:	2967b783          	ld	a5,662(a5) # ffffffffc02aabc0 <timebase>
ffffffffc0200932:	953e                	add	a0,a0,a5
ffffffffc0200934:	4581                	li	a1,0
ffffffffc0200936:	4601                	li	a2,0
ffffffffc0200938:	4881                	li	a7,0
ffffffffc020093a:	00000073          	ecall
ffffffffc020093e:	8082                	ret

ffffffffc0200940 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200940:	8082                	ret

ffffffffc0200942 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200942:	100027f3          	csrr	a5,sstatus
ffffffffc0200946:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200948:	0ff57513          	zext.b	a0,a0
ffffffffc020094c:	e799                	bnez	a5,ffffffffc020095a <cons_putc+0x18>
ffffffffc020094e:	4581                	li	a1,0
ffffffffc0200950:	4601                	li	a2,0
ffffffffc0200952:	4885                	li	a7,1
ffffffffc0200954:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc0200958:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc020095a:	1101                	addi	sp,sp,-32
ffffffffc020095c:	ec06                	sd	ra,24(sp)
ffffffffc020095e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200960:	05a000ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0200964:	6522                	ld	a0,8(sp)
ffffffffc0200966:	4581                	li	a1,0
ffffffffc0200968:	4601                	li	a2,0
ffffffffc020096a:	4885                	li	a7,1
ffffffffc020096c:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200970:	60e2                	ld	ra,24(sp)
ffffffffc0200972:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc0200974:	a081                	j	ffffffffc02009b4 <intr_enable>

ffffffffc0200976 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200976:	100027f3          	csrr	a5,sstatus
ffffffffc020097a:	8b89                	andi	a5,a5,2
ffffffffc020097c:	eb89                	bnez	a5,ffffffffc020098e <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020097e:	4501                	li	a0,0
ffffffffc0200980:	4581                	li	a1,0
ffffffffc0200982:	4601                	li	a2,0
ffffffffc0200984:	4889                	li	a7,2
ffffffffc0200986:	00000073          	ecall
ffffffffc020098a:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc020098c:	8082                	ret
int cons_getc(void) {
ffffffffc020098e:	1101                	addi	sp,sp,-32
ffffffffc0200990:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200992:	028000ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0200996:	4501                	li	a0,0
ffffffffc0200998:	4581                	li	a1,0
ffffffffc020099a:	4601                	li	a2,0
ffffffffc020099c:	4889                	li	a7,2
ffffffffc020099e:	00000073          	ecall
ffffffffc02009a2:	2501                	sext.w	a0,a0
ffffffffc02009a4:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02009a6:	00e000ef          	jal	ra,ffffffffc02009b4 <intr_enable>
}
ffffffffc02009aa:	60e2                	ld	ra,24(sp)
ffffffffc02009ac:	6522                	ld	a0,8(sp)
ffffffffc02009ae:	6105                	addi	sp,sp,32
ffffffffc02009b0:	8082                	ret

ffffffffc02009b2 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ba:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009be:	8082                	ret

ffffffffc02009c0 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009c0:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c4:	00000797          	auipc	a5,0x0
ffffffffc02009c8:	58478793          	addi	a5,a5,1412 # ffffffffc0200f48 <__alltraps>
ffffffffc02009cc:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009d0:	000407b7          	lui	a5,0x40
ffffffffc02009d4:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d8:	8082                	ret

ffffffffc02009da <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009da:	610c                	ld	a1,0(a0)
{
ffffffffc02009dc:	1141                	addi	sp,sp,-16
ffffffffc02009de:	e022                	sd	s0,0(sp)
ffffffffc02009e0:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e2:	00005517          	auipc	a0,0x5
ffffffffc02009e6:	24650513          	addi	a0,a0,582 # ffffffffc0205c28 <commands+0x1b8>
{
ffffffffc02009ea:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009ec:	ef4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009f0:	640c                	ld	a1,8(s0)
ffffffffc02009f2:	00005517          	auipc	a0,0x5
ffffffffc02009f6:	24e50513          	addi	a0,a0,590 # ffffffffc0205c40 <commands+0x1d0>
ffffffffc02009fa:	ee6ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fe:	680c                	ld	a1,16(s0)
ffffffffc0200a00:	00005517          	auipc	a0,0x5
ffffffffc0200a04:	25850513          	addi	a0,a0,600 # ffffffffc0205c58 <commands+0x1e8>
ffffffffc0200a08:	ed8ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a0c:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0e:	00005517          	auipc	a0,0x5
ffffffffc0200a12:	26250513          	addi	a0,a0,610 # ffffffffc0205c70 <commands+0x200>
ffffffffc0200a16:	ecaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a1a:	700c                	ld	a1,32(s0)
ffffffffc0200a1c:	00005517          	auipc	a0,0x5
ffffffffc0200a20:	26c50513          	addi	a0,a0,620 # ffffffffc0205c88 <commands+0x218>
ffffffffc0200a24:	ebcff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a28:	740c                	ld	a1,40(s0)
ffffffffc0200a2a:	00005517          	auipc	a0,0x5
ffffffffc0200a2e:	27650513          	addi	a0,a0,630 # ffffffffc0205ca0 <commands+0x230>
ffffffffc0200a32:	eaeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a36:	780c                	ld	a1,48(s0)
ffffffffc0200a38:	00005517          	auipc	a0,0x5
ffffffffc0200a3c:	28050513          	addi	a0,a0,640 # ffffffffc0205cb8 <commands+0x248>
ffffffffc0200a40:	ea0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a44:	7c0c                	ld	a1,56(s0)
ffffffffc0200a46:	00005517          	auipc	a0,0x5
ffffffffc0200a4a:	28a50513          	addi	a0,a0,650 # ffffffffc0205cd0 <commands+0x260>
ffffffffc0200a4e:	e92ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a52:	602c                	ld	a1,64(s0)
ffffffffc0200a54:	00005517          	auipc	a0,0x5
ffffffffc0200a58:	29450513          	addi	a0,a0,660 # ffffffffc0205ce8 <commands+0x278>
ffffffffc0200a5c:	e84ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a60:	642c                	ld	a1,72(s0)
ffffffffc0200a62:	00005517          	auipc	a0,0x5
ffffffffc0200a66:	29e50513          	addi	a0,a0,670 # ffffffffc0205d00 <commands+0x290>
ffffffffc0200a6a:	e76ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6e:	682c                	ld	a1,80(s0)
ffffffffc0200a70:	00005517          	auipc	a0,0x5
ffffffffc0200a74:	2a850513          	addi	a0,a0,680 # ffffffffc0205d18 <commands+0x2a8>
ffffffffc0200a78:	e68ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a7c:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7e:	00005517          	auipc	a0,0x5
ffffffffc0200a82:	2b250513          	addi	a0,a0,690 # ffffffffc0205d30 <commands+0x2c0>
ffffffffc0200a86:	e5aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a8a:	702c                	ld	a1,96(s0)
ffffffffc0200a8c:	00005517          	auipc	a0,0x5
ffffffffc0200a90:	2bc50513          	addi	a0,a0,700 # ffffffffc0205d48 <commands+0x2d8>
ffffffffc0200a94:	e4cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a98:	742c                	ld	a1,104(s0)
ffffffffc0200a9a:	00005517          	auipc	a0,0x5
ffffffffc0200a9e:	2c650513          	addi	a0,a0,710 # ffffffffc0205d60 <commands+0x2f0>
ffffffffc0200aa2:	e3eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa6:	782c                	ld	a1,112(s0)
ffffffffc0200aa8:	00005517          	auipc	a0,0x5
ffffffffc0200aac:	2d050513          	addi	a0,a0,720 # ffffffffc0205d78 <commands+0x308>
ffffffffc0200ab0:	e30ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab4:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab6:	00005517          	auipc	a0,0x5
ffffffffc0200aba:	2da50513          	addi	a0,a0,730 # ffffffffc0205d90 <commands+0x320>
ffffffffc0200abe:	e22ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200ac2:	604c                	ld	a1,128(s0)
ffffffffc0200ac4:	00005517          	auipc	a0,0x5
ffffffffc0200ac8:	2e450513          	addi	a0,a0,740 # ffffffffc0205da8 <commands+0x338>
ffffffffc0200acc:	e14ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200ad0:	644c                	ld	a1,136(s0)
ffffffffc0200ad2:	00005517          	auipc	a0,0x5
ffffffffc0200ad6:	2ee50513          	addi	a0,a0,750 # ffffffffc0205dc0 <commands+0x350>
ffffffffc0200ada:	e06ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ade:	684c                	ld	a1,144(s0)
ffffffffc0200ae0:	00005517          	auipc	a0,0x5
ffffffffc0200ae4:	2f850513          	addi	a0,a0,760 # ffffffffc0205dd8 <commands+0x368>
ffffffffc0200ae8:	df8ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200aec:	6c4c                	ld	a1,152(s0)
ffffffffc0200aee:	00005517          	auipc	a0,0x5
ffffffffc0200af2:	30250513          	addi	a0,a0,770 # ffffffffc0205df0 <commands+0x380>
ffffffffc0200af6:	deaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200afa:	704c                	ld	a1,160(s0)
ffffffffc0200afc:	00005517          	auipc	a0,0x5
ffffffffc0200b00:	30c50513          	addi	a0,a0,780 # ffffffffc0205e08 <commands+0x398>
ffffffffc0200b04:	ddcff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b08:	744c                	ld	a1,168(s0)
ffffffffc0200b0a:	00005517          	auipc	a0,0x5
ffffffffc0200b0e:	31650513          	addi	a0,a0,790 # ffffffffc0205e20 <commands+0x3b0>
ffffffffc0200b12:	dceff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b16:	784c                	ld	a1,176(s0)
ffffffffc0200b18:	00005517          	auipc	a0,0x5
ffffffffc0200b1c:	32050513          	addi	a0,a0,800 # ffffffffc0205e38 <commands+0x3c8>
ffffffffc0200b20:	dc0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b24:	7c4c                	ld	a1,184(s0)
ffffffffc0200b26:	00005517          	auipc	a0,0x5
ffffffffc0200b2a:	32a50513          	addi	a0,a0,810 # ffffffffc0205e50 <commands+0x3e0>
ffffffffc0200b2e:	db2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b32:	606c                	ld	a1,192(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	33450513          	addi	a0,a0,820 # ffffffffc0205e68 <commands+0x3f8>
ffffffffc0200b3c:	da4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b40:	646c                	ld	a1,200(s0)
ffffffffc0200b42:	00005517          	auipc	a0,0x5
ffffffffc0200b46:	33e50513          	addi	a0,a0,830 # ffffffffc0205e80 <commands+0x410>
ffffffffc0200b4a:	d96ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4e:	686c                	ld	a1,208(s0)
ffffffffc0200b50:	00005517          	auipc	a0,0x5
ffffffffc0200b54:	34850513          	addi	a0,a0,840 # ffffffffc0205e98 <commands+0x428>
ffffffffc0200b58:	d88ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b5c:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5e:	00005517          	auipc	a0,0x5
ffffffffc0200b62:	35250513          	addi	a0,a0,850 # ffffffffc0205eb0 <commands+0x440>
ffffffffc0200b66:	d7aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b6a:	706c                	ld	a1,224(s0)
ffffffffc0200b6c:	00005517          	auipc	a0,0x5
ffffffffc0200b70:	35c50513          	addi	a0,a0,860 # ffffffffc0205ec8 <commands+0x458>
ffffffffc0200b74:	d6cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b78:	746c                	ld	a1,232(s0)
ffffffffc0200b7a:	00005517          	auipc	a0,0x5
ffffffffc0200b7e:	36650513          	addi	a0,a0,870 # ffffffffc0205ee0 <commands+0x470>
ffffffffc0200b82:	d5eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b86:	786c                	ld	a1,240(s0)
ffffffffc0200b88:	00005517          	auipc	a0,0x5
ffffffffc0200b8c:	37050513          	addi	a0,a0,880 # ffffffffc0205ef8 <commands+0x488>
ffffffffc0200b90:	d50ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b94:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b96:	6402                	ld	s0,0(sp)
ffffffffc0200b98:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	37650513          	addi	a0,a0,886 # ffffffffc0205f10 <commands+0x4a0>
}
ffffffffc0200ba2:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba4:	d3cff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200ba8 <print_trapframe>:
{
ffffffffc0200ba8:	1141                	addi	sp,sp,-16
ffffffffc0200baa:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	85aa                	mv	a1,a0
{
ffffffffc0200bae:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb0:	00005517          	auipc	a0,0x5
ffffffffc0200bb4:	37850513          	addi	a0,a0,888 # ffffffffc0205f28 <commands+0x4b8>
{
ffffffffc0200bb8:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bba:	d26ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bbe:	8522                	mv	a0,s0
ffffffffc0200bc0:	e1bff0ef          	jal	ra,ffffffffc02009da <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc4:	10043583          	ld	a1,256(s0)
ffffffffc0200bc8:	00005517          	auipc	a0,0x5
ffffffffc0200bcc:	37850513          	addi	a0,a0,888 # ffffffffc0205f40 <commands+0x4d0>
ffffffffc0200bd0:	d10ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd4:	10843583          	ld	a1,264(s0)
ffffffffc0200bd8:	00005517          	auipc	a0,0x5
ffffffffc0200bdc:	38050513          	addi	a0,a0,896 # ffffffffc0205f58 <commands+0x4e8>
ffffffffc0200be0:	d00ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be4:	11043583          	ld	a1,272(s0)
ffffffffc0200be8:	00005517          	auipc	a0,0x5
ffffffffc0200bec:	38850513          	addi	a0,a0,904 # ffffffffc0205f70 <commands+0x500>
ffffffffc0200bf0:	cf0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf4:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf8:	6402                	ld	s0,0(sp)
ffffffffc0200bfa:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bfc:	00005517          	auipc	a0,0x5
ffffffffc0200c00:	38450513          	addi	a0,a0,900 # ffffffffc0205f80 <commands+0x510>
}
ffffffffc0200c04:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c06:	cdaff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200c0a <pgfault_handler>:
pgfault_handler(struct trapframe *tf) {
ffffffffc0200c0a:	1141                	addi	sp,sp,-16
ffffffffc0200c0c:	e406                	sd	ra,8(sp)
    if (current == NULL) {
ffffffffc0200c0e:	000aa797          	auipc	a5,0xaa
ffffffffc0200c12:	ff27b783          	ld	a5,-14(a5) # ffffffffc02aac00 <current>
ffffffffc0200c16:	c799                	beqz	a5,ffffffffc0200c24 <pgfault_handler+0x1a>
    if (current->mm == NULL) {
ffffffffc0200c18:	779c                	ld	a5,40(a5)
ffffffffc0200c1a:	c39d                	beqz	a5,ffffffffc0200c40 <pgfault_handler+0x36>
}
ffffffffc0200c1c:	60a2                	ld	ra,8(sp)
ffffffffc0200c1e:	5575                	li	a0,-3
ffffffffc0200c20:	0141                	addi	sp,sp,16
ffffffffc0200c22:	8082                	ret
        print_trapframe(tf);
ffffffffc0200c24:	f85ff0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
        panic("page fault in kernel!");
ffffffffc0200c28:	00005617          	auipc	a2,0x5
ffffffffc0200c2c:	37060613          	addi	a2,a2,880 # ffffffffc0205f98 <commands+0x528>
ffffffffc0200c30:	02400593          	li	a1,36
ffffffffc0200c34:	00005517          	auipc	a0,0x5
ffffffffc0200c38:	37c50513          	addi	a0,a0,892 # ffffffffc0205fb0 <commands+0x540>
ffffffffc0200c3c:	de2ff0ef          	jal	ra,ffffffffc020021e <__panic>
        print_trapframe(tf);
ffffffffc0200c40:	f69ff0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
        panic("page fault in kernel thread!");
ffffffffc0200c44:	00005617          	auipc	a2,0x5
ffffffffc0200c48:	38460613          	addi	a2,a2,900 # ffffffffc0205fc8 <commands+0x558>
ffffffffc0200c4c:	02900593          	li	a1,41
ffffffffc0200c50:	00005517          	auipc	a0,0x5
ffffffffc0200c54:	36050513          	addi	a0,a0,864 # ffffffffc0205fb0 <commands+0x540>
ffffffffc0200c58:	dc6ff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0200c5c <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c5c:	11853783          	ld	a5,280(a0)
ffffffffc0200c60:	472d                	li	a4,11
ffffffffc0200c62:	0786                	slli	a5,a5,0x1
ffffffffc0200c64:	8385                	srli	a5,a5,0x1
ffffffffc0200c66:	06f76d63          	bltu	a4,a5,ffffffffc0200ce0 <interrupt_handler+0x84>
ffffffffc0200c6a:	00005717          	auipc	a4,0x5
ffffffffc0200c6e:	42e70713          	addi	a4,a4,1070 # ffffffffc0206098 <commands+0x628>
ffffffffc0200c72:	078a                	slli	a5,a5,0x2
ffffffffc0200c74:	97ba                	add	a5,a5,a4
ffffffffc0200c76:	439c                	lw	a5,0(a5)
ffffffffc0200c78:	97ba                	add	a5,a5,a4
ffffffffc0200c7a:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c7c:	00005517          	auipc	a0,0x5
ffffffffc0200c80:	3cc50513          	addi	a0,a0,972 # ffffffffc0206048 <commands+0x5d8>
ffffffffc0200c84:	c5cff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c88:	00005517          	auipc	a0,0x5
ffffffffc0200c8c:	3a050513          	addi	a0,a0,928 # ffffffffc0206028 <commands+0x5b8>
ffffffffc0200c90:	c50ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c94:	00005517          	auipc	a0,0x5
ffffffffc0200c98:	35450513          	addi	a0,a0,852 # ffffffffc0205fe8 <commands+0x578>
ffffffffc0200c9c:	c44ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200ca0:	00005517          	auipc	a0,0x5
ffffffffc0200ca4:	36850513          	addi	a0,a0,872 # ffffffffc0206008 <commands+0x598>
ffffffffc0200ca8:	c38ff06f          	j	ffffffffc02000e0 <cprintf>
{
ffffffffc0200cac:	1141                	addi	sp,sp,-16
ffffffffc0200cae:	e406                	sd	ra,8(sp)
        /*(1)设置下次时钟中断- clock_set_next_event()
         *(2)计数器（ticks）加一
         *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
         * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
         */
        clock_set_next_event();
ffffffffc0200cb0:	c77ff0ef          	jal	ra,ffffffffc0200926 <clock_set_next_event>
        ticks++;
ffffffffc0200cb4:	000aa797          	auipc	a5,0xaa
ffffffffc0200cb8:	f0478793          	addi	a5,a5,-252 # ffffffffc02aabb8 <ticks>
ffffffffc0200cbc:	6398                	ld	a4,0(a5)
ffffffffc0200cbe:	0705                	addi	a4,a4,1
ffffffffc0200cc0:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200cc2:	639c                	ld	a5,0(a5)
ffffffffc0200cc4:	06400713          	li	a4,100
ffffffffc0200cc8:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200ccc:	cb99                	beqz	a5,ffffffffc0200ce2 <interrupt_handler+0x86>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cce:	60a2                	ld	ra,8(sp)
ffffffffc0200cd0:	0141                	addi	sp,sp,16
ffffffffc0200cd2:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200cd4:	00005517          	auipc	a0,0x5
ffffffffc0200cd8:	3a450513          	addi	a0,a0,932 # ffffffffc0206078 <commands+0x608>
ffffffffc0200cdc:	c04ff06f          	j	ffffffffc02000e0 <cprintf>
        print_trapframe(tf);
ffffffffc0200ce0:	b5e1                	j	ffffffffc0200ba8 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200ce2:	06400593          	li	a1,100
ffffffffc0200ce6:	00005517          	auipc	a0,0x5
ffffffffc0200cea:	38250513          	addi	a0,a0,898 # ffffffffc0206068 <commands+0x5f8>
ffffffffc0200cee:	bf2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
            if(current != NULL)
ffffffffc0200cf2:	000aa797          	auipc	a5,0xaa
ffffffffc0200cf6:	f0e7b783          	ld	a5,-242(a5) # ffffffffc02aac00 <current>
ffffffffc0200cfa:	dbf1                	beqz	a5,ffffffffc0200cce <interrupt_handler+0x72>
                current->need_resched = 1;
ffffffffc0200cfc:	4705                	li	a4,1
ffffffffc0200cfe:	ef98                	sd	a4,24(a5)
ffffffffc0200d00:	b7f9                	j	ffffffffc0200cce <interrupt_handler+0x72>

ffffffffc0200d02 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200d02:	11853783          	ld	a5,280(a0)
{
ffffffffc0200d06:	1141                	addi	sp,sp,-16
ffffffffc0200d08:	e022                	sd	s0,0(sp)
ffffffffc0200d0a:	e406                	sd	ra,8(sp)
ffffffffc0200d0c:	473d                	li	a4,15
ffffffffc0200d0e:	842a                	mv	s0,a0
ffffffffc0200d10:	14f76763          	bltu	a4,a5,ffffffffc0200e5e <exception_handler+0x15c>
ffffffffc0200d14:	00005717          	auipc	a4,0x5
ffffffffc0200d18:	54470713          	addi	a4,a4,1348 # ffffffffc0206258 <commands+0x7e8>
ffffffffc0200d1c:	078a                	slli	a5,a5,0x2
ffffffffc0200d1e:	97ba                	add	a5,a5,a4
ffffffffc0200d20:	439c                	lw	a5,0(a5)
ffffffffc0200d22:	97ba                	add	a5,a5,a4
ffffffffc0200d24:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200d26:	00005517          	auipc	a0,0x5
ffffffffc0200d2a:	47250513          	addi	a0,a0,1138 # ffffffffc0206198 <commands+0x728>
ffffffffc0200d2e:	bb2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        tf->epc += 4;
ffffffffc0200d32:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200d36:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200d38:	0791                	addi	a5,a5,4
ffffffffc0200d3a:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d3e:	6402                	ld	s0,0(sp)
ffffffffc0200d40:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200d42:	5340406f          	j	ffffffffc0205276 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d46:	00005517          	auipc	a0,0x5
ffffffffc0200d4a:	47250513          	addi	a0,a0,1138 # ffffffffc02061b8 <commands+0x748>
}
ffffffffc0200d4e:	6402                	ld	s0,0(sp)
ffffffffc0200d50:	60a2                	ld	ra,8(sp)
ffffffffc0200d52:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d54:	b8cff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d58:	00005517          	auipc	a0,0x5
ffffffffc0200d5c:	48050513          	addi	a0,a0,1152 # ffffffffc02061d8 <commands+0x768>
ffffffffc0200d60:	b7fd                	j	ffffffffc0200d4e <exception_handler+0x4c>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d62:	ea9ff0ef          	jal	ra,ffffffffc0200c0a <pgfault_handler>
ffffffffc0200d66:	0c050963          	beqz	a0,ffffffffc0200e38 <exception_handler+0x136>
            cprintf("Fetch page fault\n");
ffffffffc0200d6a:	00005517          	auipc	a0,0x5
ffffffffc0200d6e:	48e50513          	addi	a0,a0,1166 # ffffffffc02061f8 <commands+0x788>
ffffffffc0200d72:	b6eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
            print_trapframe(tf);
ffffffffc0200d76:	8522                	mv	a0,s0
ffffffffc0200d78:	e31ff0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
            if (current != NULL) {
ffffffffc0200d7c:	000aa797          	auipc	a5,0xaa
ffffffffc0200d80:	e847b783          	ld	a5,-380(a5) # ffffffffc02aac00 <current>
ffffffffc0200d84:	ebbd                	bnez	a5,ffffffffc0200dfa <exception_handler+0xf8>
                panic("kernel page fault");
ffffffffc0200d86:	00005617          	auipc	a2,0x5
ffffffffc0200d8a:	48a60613          	addi	a2,a2,1162 # ffffffffc0206210 <commands+0x7a0>
ffffffffc0200d8e:	0ef00593          	li	a1,239
ffffffffc0200d92:	00005517          	auipc	a0,0x5
ffffffffc0200d96:	21e50513          	addi	a0,a0,542 # ffffffffc0205fb0 <commands+0x540>
ffffffffc0200d9a:	c84ff0ef          	jal	ra,ffffffffc020021e <__panic>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200d9e:	e6dff0ef          	jal	ra,ffffffffc0200c0a <pgfault_handler>
ffffffffc0200da2:	c959                	beqz	a0,ffffffffc0200e38 <exception_handler+0x136>
            cprintf("Load page fault\n");
ffffffffc0200da4:	00005517          	auipc	a0,0x5
ffffffffc0200da8:	48450513          	addi	a0,a0,1156 # ffffffffc0206228 <commands+0x7b8>
ffffffffc0200dac:	b34ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
            print_trapframe(tf);
ffffffffc0200db0:	8522                	mv	a0,s0
ffffffffc0200db2:	df7ff0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
            if (current != NULL) {
ffffffffc0200db6:	000aa797          	auipc	a5,0xaa
ffffffffc0200dba:	e4a7b783          	ld	a5,-438(a5) # ffffffffc02aac00 <current>
ffffffffc0200dbe:	ef95                	bnez	a5,ffffffffc0200dfa <exception_handler+0xf8>
                panic("kernel page fault");
ffffffffc0200dc0:	00005617          	auipc	a2,0x5
ffffffffc0200dc4:	45060613          	addi	a2,a2,1104 # ffffffffc0206210 <commands+0x7a0>
ffffffffc0200dc8:	0fa00593          	li	a1,250
ffffffffc0200dcc:	00005517          	auipc	a0,0x5
ffffffffc0200dd0:	1e450513          	addi	a0,a0,484 # ffffffffc0205fb0 <commands+0x540>
ffffffffc0200dd4:	c4aff0ef          	jal	ra,ffffffffc020021e <__panic>
        if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200dd8:	e33ff0ef          	jal	ra,ffffffffc0200c0a <pgfault_handler>
ffffffffc0200ddc:	cd31                	beqz	a0,ffffffffc0200e38 <exception_handler+0x136>
            cprintf("Store/AMO page fault\n");
ffffffffc0200dde:	00005517          	auipc	a0,0x5
ffffffffc0200de2:	46250513          	addi	a0,a0,1122 # ffffffffc0206240 <commands+0x7d0>
ffffffffc0200de6:	afaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
            print_trapframe(tf);
ffffffffc0200dea:	8522                	mv	a0,s0
ffffffffc0200dec:	dbdff0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
            if (current != NULL) {
ffffffffc0200df0:	000aa797          	auipc	a5,0xaa
ffffffffc0200df4:	e107b783          	ld	a5,-496(a5) # ffffffffc02aac00 <current>
ffffffffc0200df8:	c7dd                	beqz	a5,ffffffffc0200ea6 <exception_handler+0x1a4>
}
ffffffffc0200dfa:	6402                	ld	s0,0(sp)
ffffffffc0200dfc:	60a2                	ld	ra,8(sp)
                do_exit(-E_KILLED);
ffffffffc0200dfe:	555d                	li	a0,-9
}
ffffffffc0200e00:	0141                	addi	sp,sp,16
                do_exit(-E_KILLED);
ffffffffc0200e02:	7340306f          	j	ffffffffc0204536 <do_exit>
        cprintf("Instruction address misaligned\n");
ffffffffc0200e06:	00005517          	auipc	a0,0x5
ffffffffc0200e0a:	2c250513          	addi	a0,a0,706 # ffffffffc02060c8 <commands+0x658>
ffffffffc0200e0e:	b781                	j	ffffffffc0200d4e <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200e10:	00005517          	auipc	a0,0x5
ffffffffc0200e14:	2d850513          	addi	a0,a0,728 # ffffffffc02060e8 <commands+0x678>
ffffffffc0200e18:	bf1d                	j	ffffffffc0200d4e <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200e1a:	00005517          	auipc	a0,0x5
ffffffffc0200e1e:	2ee50513          	addi	a0,a0,750 # ffffffffc0206108 <commands+0x698>
ffffffffc0200e22:	b735                	j	ffffffffc0200d4e <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200e24:	00005517          	auipc	a0,0x5
ffffffffc0200e28:	2fc50513          	addi	a0,a0,764 # ffffffffc0206120 <commands+0x6b0>
ffffffffc0200e2c:	ab4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200e30:	6458                	ld	a4,136(s0)
ffffffffc0200e32:	47a9                	li	a5,10
ffffffffc0200e34:	04f70663          	beq	a4,a5,ffffffffc0200e80 <exception_handler+0x17e>
}
ffffffffc0200e38:	60a2                	ld	ra,8(sp)
ffffffffc0200e3a:	6402                	ld	s0,0(sp)
ffffffffc0200e3c:	0141                	addi	sp,sp,16
ffffffffc0200e3e:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200e40:	00005517          	auipc	a0,0x5
ffffffffc0200e44:	2f050513          	addi	a0,a0,752 # ffffffffc0206130 <commands+0x6c0>
ffffffffc0200e48:	b719                	j	ffffffffc0200d4e <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200e4a:	00005517          	auipc	a0,0x5
ffffffffc0200e4e:	30650513          	addi	a0,a0,774 # ffffffffc0206150 <commands+0x6e0>
ffffffffc0200e52:	bdf5                	j	ffffffffc0200d4e <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200e54:	00005517          	auipc	a0,0x5
ffffffffc0200e58:	32c50513          	addi	a0,a0,812 # ffffffffc0206180 <commands+0x710>
ffffffffc0200e5c:	bdcd                	j	ffffffffc0200d4e <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200e5e:	8522                	mv	a0,s0
}
ffffffffc0200e60:	6402                	ld	s0,0(sp)
ffffffffc0200e62:	60a2                	ld	ra,8(sp)
ffffffffc0200e64:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200e66:	b389                	j	ffffffffc0200ba8 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200e68:	00005617          	auipc	a2,0x5
ffffffffc0200e6c:	30060613          	addi	a2,a2,768 # ffffffffc0206168 <commands+0x6f8>
ffffffffc0200e70:	0d300593          	li	a1,211
ffffffffc0200e74:	00005517          	auipc	a0,0x5
ffffffffc0200e78:	13c50513          	addi	a0,a0,316 # ffffffffc0205fb0 <commands+0x540>
ffffffffc0200e7c:	ba2ff0ef          	jal	ra,ffffffffc020021e <__panic>
            tf->epc += 4;
ffffffffc0200e80:	10843783          	ld	a5,264(s0)
ffffffffc0200e84:	0791                	addi	a5,a5,4
ffffffffc0200e86:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200e8a:	3ec040ef          	jal	ra,ffffffffc0205276 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e8e:	000aa797          	auipc	a5,0xaa
ffffffffc0200e92:	d727b783          	ld	a5,-654(a5) # ffffffffc02aac00 <current>
ffffffffc0200e96:	6b9c                	ld	a5,16(a5)
ffffffffc0200e98:	8522                	mv	a0,s0
}
ffffffffc0200e9a:	6402                	ld	s0,0(sp)
ffffffffc0200e9c:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e9e:	6589                	lui	a1,0x2
ffffffffc0200ea0:	95be                	add	a1,a1,a5
}
ffffffffc0200ea2:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200ea4:	aa8d                	j	ffffffffc0201016 <kernel_execve_ret>
                panic("kernel page fault");
ffffffffc0200ea6:	00005617          	auipc	a2,0x5
ffffffffc0200eaa:	36a60613          	addi	a2,a2,874 # ffffffffc0206210 <commands+0x7a0>
ffffffffc0200eae:	10500593          	li	a1,261
ffffffffc0200eb2:	00005517          	auipc	a0,0x5
ffffffffc0200eb6:	0fe50513          	addi	a0,a0,254 # ffffffffc0205fb0 <commands+0x540>
ffffffffc0200eba:	b64ff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0200ebe <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200ebe:	1101                	addi	sp,sp,-32
ffffffffc0200ec0:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200ec2:	000aa417          	auipc	s0,0xaa
ffffffffc0200ec6:	d3e40413          	addi	s0,s0,-706 # ffffffffc02aac00 <current>
ffffffffc0200eca:	6018                	ld	a4,0(s0)
{
ffffffffc0200ecc:	ec06                	sd	ra,24(sp)
ffffffffc0200ece:	e426                	sd	s1,8(sp)
ffffffffc0200ed0:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ed2:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200ed6:	cf1d                	beqz	a4,ffffffffc0200f14 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200ed8:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200edc:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200ee0:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200ee2:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ee6:	0206c463          	bltz	a3,ffffffffc0200f0e <trap+0x50>
        exception_handler(tf);
ffffffffc0200eea:	e19ff0ef          	jal	ra,ffffffffc0200d02 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200eee:	601c                	ld	a5,0(s0)
ffffffffc0200ef0:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200ef4:	e499                	bnez	s1,ffffffffc0200f02 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200ef6:	0b07a703          	lw	a4,176(a5)
ffffffffc0200efa:	8b05                	andi	a4,a4,1
ffffffffc0200efc:	e329                	bnez	a4,ffffffffc0200f3e <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200efe:	6f9c                	ld	a5,24(a5)
ffffffffc0200f00:	eb85                	bnez	a5,ffffffffc0200f30 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200f02:	60e2                	ld	ra,24(sp)
ffffffffc0200f04:	6442                	ld	s0,16(sp)
ffffffffc0200f06:	64a2                	ld	s1,8(sp)
ffffffffc0200f08:	6902                	ld	s2,0(sp)
ffffffffc0200f0a:	6105                	addi	sp,sp,32
ffffffffc0200f0c:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200f0e:	d4fff0ef          	jal	ra,ffffffffc0200c5c <interrupt_handler>
ffffffffc0200f12:	bff1                	j	ffffffffc0200eee <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200f14:	0006c863          	bltz	a3,ffffffffc0200f24 <trap+0x66>
}
ffffffffc0200f18:	6442                	ld	s0,16(sp)
ffffffffc0200f1a:	60e2                	ld	ra,24(sp)
ffffffffc0200f1c:	64a2                	ld	s1,8(sp)
ffffffffc0200f1e:	6902                	ld	s2,0(sp)
ffffffffc0200f20:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200f22:	b3c5                	j	ffffffffc0200d02 <exception_handler>
}
ffffffffc0200f24:	6442                	ld	s0,16(sp)
ffffffffc0200f26:	60e2                	ld	ra,24(sp)
ffffffffc0200f28:	64a2                	ld	s1,8(sp)
ffffffffc0200f2a:	6902                	ld	s2,0(sp)
ffffffffc0200f2c:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200f2e:	b33d                	j	ffffffffc0200c5c <interrupt_handler>
}
ffffffffc0200f30:	6442                	ld	s0,16(sp)
ffffffffc0200f32:	60e2                	ld	ra,24(sp)
ffffffffc0200f34:	64a2                	ld	s1,8(sp)
ffffffffc0200f36:	6902                	ld	s2,0(sp)
ffffffffc0200f38:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200f3a:	2500406f          	j	ffffffffc020518a <schedule>
                do_exit(-E_KILLED);
ffffffffc0200f3e:	555d                	li	a0,-9
ffffffffc0200f40:	5f6030ef          	jal	ra,ffffffffc0204536 <do_exit>
            if (current->need_resched)
ffffffffc0200f44:	601c                	ld	a5,0(s0)
ffffffffc0200f46:	bf65                	j	ffffffffc0200efe <trap+0x40>

ffffffffc0200f48 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200f48:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200f4c:	00011463          	bnez	sp,ffffffffc0200f54 <__alltraps+0xc>
ffffffffc0200f50:	14002173          	csrr	sp,sscratch
ffffffffc0200f54:	712d                	addi	sp,sp,-288
ffffffffc0200f56:	e002                	sd	zero,0(sp)
ffffffffc0200f58:	e406                	sd	ra,8(sp)
ffffffffc0200f5a:	ec0e                	sd	gp,24(sp)
ffffffffc0200f5c:	f012                	sd	tp,32(sp)
ffffffffc0200f5e:	f416                	sd	t0,40(sp)
ffffffffc0200f60:	f81a                	sd	t1,48(sp)
ffffffffc0200f62:	fc1e                	sd	t2,56(sp)
ffffffffc0200f64:	e0a2                	sd	s0,64(sp)
ffffffffc0200f66:	e4a6                	sd	s1,72(sp)
ffffffffc0200f68:	e8aa                	sd	a0,80(sp)
ffffffffc0200f6a:	ecae                	sd	a1,88(sp)
ffffffffc0200f6c:	f0b2                	sd	a2,96(sp)
ffffffffc0200f6e:	f4b6                	sd	a3,104(sp)
ffffffffc0200f70:	f8ba                	sd	a4,112(sp)
ffffffffc0200f72:	fcbe                	sd	a5,120(sp)
ffffffffc0200f74:	e142                	sd	a6,128(sp)
ffffffffc0200f76:	e546                	sd	a7,136(sp)
ffffffffc0200f78:	e94a                	sd	s2,144(sp)
ffffffffc0200f7a:	ed4e                	sd	s3,152(sp)
ffffffffc0200f7c:	f152                	sd	s4,160(sp)
ffffffffc0200f7e:	f556                	sd	s5,168(sp)
ffffffffc0200f80:	f95a                	sd	s6,176(sp)
ffffffffc0200f82:	fd5e                	sd	s7,184(sp)
ffffffffc0200f84:	e1e2                	sd	s8,192(sp)
ffffffffc0200f86:	e5e6                	sd	s9,200(sp)
ffffffffc0200f88:	e9ea                	sd	s10,208(sp)
ffffffffc0200f8a:	edee                	sd	s11,216(sp)
ffffffffc0200f8c:	f1f2                	sd	t3,224(sp)
ffffffffc0200f8e:	f5f6                	sd	t4,232(sp)
ffffffffc0200f90:	f9fa                	sd	t5,240(sp)
ffffffffc0200f92:	fdfe                	sd	t6,248(sp)
ffffffffc0200f94:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f98:	100024f3          	csrr	s1,sstatus
ffffffffc0200f9c:	14102973          	csrr	s2,sepc
ffffffffc0200fa0:	143029f3          	csrr	s3,stval
ffffffffc0200fa4:	14202a73          	csrr	s4,scause
ffffffffc0200fa8:	e822                	sd	s0,16(sp)
ffffffffc0200faa:	e226                	sd	s1,256(sp)
ffffffffc0200fac:	e64a                	sd	s2,264(sp)
ffffffffc0200fae:	ea4e                	sd	s3,272(sp)
ffffffffc0200fb0:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200fb2:	850a                	mv	a0,sp
    jal trap
ffffffffc0200fb4:	f0bff0ef          	jal	ra,ffffffffc0200ebe <trap>

ffffffffc0200fb8 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200fb8:	6492                	ld	s1,256(sp)
ffffffffc0200fba:	6932                	ld	s2,264(sp)
ffffffffc0200fbc:	1004f413          	andi	s0,s1,256
ffffffffc0200fc0:	e401                	bnez	s0,ffffffffc0200fc8 <__trapret+0x10>
ffffffffc0200fc2:	1200                	addi	s0,sp,288
ffffffffc0200fc4:	14041073          	csrw	sscratch,s0
ffffffffc0200fc8:	10049073          	csrw	sstatus,s1
ffffffffc0200fcc:	14191073          	csrw	sepc,s2
ffffffffc0200fd0:	60a2                	ld	ra,8(sp)
ffffffffc0200fd2:	61e2                	ld	gp,24(sp)
ffffffffc0200fd4:	7202                	ld	tp,32(sp)
ffffffffc0200fd6:	72a2                	ld	t0,40(sp)
ffffffffc0200fd8:	7342                	ld	t1,48(sp)
ffffffffc0200fda:	73e2                	ld	t2,56(sp)
ffffffffc0200fdc:	6406                	ld	s0,64(sp)
ffffffffc0200fde:	64a6                	ld	s1,72(sp)
ffffffffc0200fe0:	6546                	ld	a0,80(sp)
ffffffffc0200fe2:	65e6                	ld	a1,88(sp)
ffffffffc0200fe4:	7606                	ld	a2,96(sp)
ffffffffc0200fe6:	76a6                	ld	a3,104(sp)
ffffffffc0200fe8:	7746                	ld	a4,112(sp)
ffffffffc0200fea:	77e6                	ld	a5,120(sp)
ffffffffc0200fec:	680a                	ld	a6,128(sp)
ffffffffc0200fee:	68aa                	ld	a7,136(sp)
ffffffffc0200ff0:	694a                	ld	s2,144(sp)
ffffffffc0200ff2:	69ea                	ld	s3,152(sp)
ffffffffc0200ff4:	7a0a                	ld	s4,160(sp)
ffffffffc0200ff6:	7aaa                	ld	s5,168(sp)
ffffffffc0200ff8:	7b4a                	ld	s6,176(sp)
ffffffffc0200ffa:	7bea                	ld	s7,184(sp)
ffffffffc0200ffc:	6c0e                	ld	s8,192(sp)
ffffffffc0200ffe:	6cae                	ld	s9,200(sp)
ffffffffc0201000:	6d4e                	ld	s10,208(sp)
ffffffffc0201002:	6dee                	ld	s11,216(sp)
ffffffffc0201004:	7e0e                	ld	t3,224(sp)
ffffffffc0201006:	7eae                	ld	t4,232(sp)
ffffffffc0201008:	7f4e                	ld	t5,240(sp)
ffffffffc020100a:	7fee                	ld	t6,248(sp)
ffffffffc020100c:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc020100e:	10200073          	sret

ffffffffc0201012 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0201012:	812a                	mv	sp,a0
    j __trapret
ffffffffc0201014:	b755                	j	ffffffffc0200fb8 <__trapret>

ffffffffc0201016 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0201016:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7d20>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc020101a:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc020101e:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0201022:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0201026:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc020102a:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc020102e:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0201032:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0201036:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc020103a:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc020103c:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc020103e:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0201040:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0201042:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0201044:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0201046:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201048:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc020104a:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc020104c:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc020104e:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0201050:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0201052:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0201054:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0201056:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201058:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc020105a:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc020105c:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc020105e:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201060:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0201062:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0201064:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0201066:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201068:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc020106a:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc020106c:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc020106e:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201070:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0201072:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0201074:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0201076:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201078:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc020107a:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc020107c:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc020107e:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201080:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0201082:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0201084:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0201086:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201088:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc020108a:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc020108c:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc020108e:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201090:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0201092:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0201094:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0201096:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201098:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc020109a:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc020109c:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc020109e:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc02010a0:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc02010a2:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc02010a4:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc02010a6:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc02010a8:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc02010aa:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc02010ac:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc02010ae:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc02010b0:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc02010b2:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc02010b4:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc02010b6:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc02010b8:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc02010ba:	812e                	mv	sp,a1
ffffffffc02010bc:	bdf5                	j	ffffffffc0200fb8 <__trapret>

ffffffffc02010be <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02010be:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02010c0:	00005697          	auipc	a3,0x5
ffffffffc02010c4:	1d868693          	addi	a3,a3,472 # ffffffffc0206298 <commands+0x828>
ffffffffc02010c8:	00005617          	auipc	a2,0x5
ffffffffc02010cc:	1f060613          	addi	a2,a2,496 # ffffffffc02062b8 <commands+0x848>
ffffffffc02010d0:	07400593          	li	a1,116
ffffffffc02010d4:	00005517          	auipc	a0,0x5
ffffffffc02010d8:	1fc50513          	addi	a0,a0,508 # ffffffffc02062d0 <commands+0x860>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02010dc:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02010de:	940ff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02010e2 <mm_create>:
{
ffffffffc02010e2:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02010e4:	04000513          	li	a0,64
{
ffffffffc02010e8:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02010ea:	135000ef          	jal	ra,ffffffffc0201a1e <kmalloc>
    if (mm != NULL)
ffffffffc02010ee:	cd19                	beqz	a0,ffffffffc020110c <mm_create+0x2a>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02010f0:	e508                	sd	a0,8(a0)
ffffffffc02010f2:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02010f4:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02010f8:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02010fc:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0201100:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0201104:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0201108:	02053c23          	sd	zero,56(a0)
}
ffffffffc020110c:	60a2                	ld	ra,8(sp)
ffffffffc020110e:	0141                	addi	sp,sp,16
ffffffffc0201110:	8082                	ret

ffffffffc0201112 <find_vma>:
{
ffffffffc0201112:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0201114:	c505                	beqz	a0,ffffffffc020113c <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0201116:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201118:	c501                	beqz	a0,ffffffffc0201120 <find_vma+0xe>
ffffffffc020111a:	651c                	ld	a5,8(a0)
ffffffffc020111c:	02f5f263          	bgeu	a1,a5,ffffffffc0201140 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201120:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0201122:	00f68d63          	beq	a3,a5,ffffffffc020113c <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0201126:	fe87b703          	ld	a4,-24(a5)
ffffffffc020112a:	00e5e663          	bltu	a1,a4,ffffffffc0201136 <find_vma+0x24>
ffffffffc020112e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201132:	00e5ec63          	bltu	a1,a4,ffffffffc020114a <find_vma+0x38>
ffffffffc0201136:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0201138:	fef697e3          	bne	a3,a5,ffffffffc0201126 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc020113c:	4501                	li	a0,0
}
ffffffffc020113e:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201140:	691c                	ld	a5,16(a0)
ffffffffc0201142:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0201120 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0201146:	ea88                	sd	a0,16(a3)
ffffffffc0201148:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020114a:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020114e:	ea88                	sd	a0,16(a3)
ffffffffc0201150:	8082                	ret

ffffffffc0201152 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201152:	6590                	ld	a2,8(a1)
ffffffffc0201154:	0105b803          	ld	a6,16(a1)
{
ffffffffc0201158:	1141                	addi	sp,sp,-16
ffffffffc020115a:	e406                	sd	ra,8(sp)
ffffffffc020115c:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020115e:	01066763          	bltu	a2,a6,ffffffffc020116c <insert_vma_struct+0x1a>
ffffffffc0201162:	a085                	j	ffffffffc02011c2 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0201164:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201168:	04e66863          	bltu	a2,a4,ffffffffc02011b8 <insert_vma_struct+0x66>
ffffffffc020116c:	86be                	mv	a3,a5
ffffffffc020116e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0201170:	fef51ae3          	bne	a0,a5,ffffffffc0201164 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0201174:	02a68463          	beq	a3,a0,ffffffffc020119c <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0201178:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020117c:	fe86b883          	ld	a7,-24(a3)
ffffffffc0201180:	08e8f163          	bgeu	a7,a4,ffffffffc0201202 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201184:	04e66f63          	bltu	a2,a4,ffffffffc02011e2 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0201188:	00f50a63          	beq	a0,a5,ffffffffc020119c <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020118c:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201190:	05076963          	bltu	a4,a6,ffffffffc02011e2 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0201194:	ff07b603          	ld	a2,-16(a5)
ffffffffc0201198:	02c77363          	bgeu	a4,a2,ffffffffc02011be <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc020119c:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc020119e:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02011a0:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02011a4:	e390                	sd	a2,0(a5)
ffffffffc02011a6:	e690                	sd	a2,8(a3)
}
ffffffffc02011a8:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02011aa:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02011ac:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02011ae:	0017079b          	addiw	a5,a4,1
ffffffffc02011b2:	d11c                	sw	a5,32(a0)
}
ffffffffc02011b4:	0141                	addi	sp,sp,16
ffffffffc02011b6:	8082                	ret
    if (le_prev != list)
ffffffffc02011b8:	fca690e3          	bne	a3,a0,ffffffffc0201178 <insert_vma_struct+0x26>
ffffffffc02011bc:	bfd1                	j	ffffffffc0201190 <insert_vma_struct+0x3e>
ffffffffc02011be:	f01ff0ef          	jal	ra,ffffffffc02010be <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02011c2:	00005697          	auipc	a3,0x5
ffffffffc02011c6:	11e68693          	addi	a3,a3,286 # ffffffffc02062e0 <commands+0x870>
ffffffffc02011ca:	00005617          	auipc	a2,0x5
ffffffffc02011ce:	0ee60613          	addi	a2,a2,238 # ffffffffc02062b8 <commands+0x848>
ffffffffc02011d2:	07a00593          	li	a1,122
ffffffffc02011d6:	00005517          	auipc	a0,0x5
ffffffffc02011da:	0fa50513          	addi	a0,a0,250 # ffffffffc02062d0 <commands+0x860>
ffffffffc02011de:	840ff0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02011e2:	00005697          	auipc	a3,0x5
ffffffffc02011e6:	13e68693          	addi	a3,a3,318 # ffffffffc0206320 <commands+0x8b0>
ffffffffc02011ea:	00005617          	auipc	a2,0x5
ffffffffc02011ee:	0ce60613          	addi	a2,a2,206 # ffffffffc02062b8 <commands+0x848>
ffffffffc02011f2:	07300593          	li	a1,115
ffffffffc02011f6:	00005517          	auipc	a0,0x5
ffffffffc02011fa:	0da50513          	addi	a0,a0,218 # ffffffffc02062d0 <commands+0x860>
ffffffffc02011fe:	820ff0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201202:	00005697          	auipc	a3,0x5
ffffffffc0201206:	0fe68693          	addi	a3,a3,254 # ffffffffc0206300 <commands+0x890>
ffffffffc020120a:	00005617          	auipc	a2,0x5
ffffffffc020120e:	0ae60613          	addi	a2,a2,174 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201212:	07200593          	li	a1,114
ffffffffc0201216:	00005517          	auipc	a0,0x5
ffffffffc020121a:	0ba50513          	addi	a0,a0,186 # ffffffffc02062d0 <commands+0x860>
ffffffffc020121e:	800ff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201222 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0201222:	591c                	lw	a5,48(a0)
{
ffffffffc0201224:	1141                	addi	sp,sp,-16
ffffffffc0201226:	e406                	sd	ra,8(sp)
ffffffffc0201228:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc020122a:	e78d                	bnez	a5,ffffffffc0201254 <mm_destroy+0x32>
ffffffffc020122c:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020122e:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0201230:	00a40c63          	beq	s0,a0,ffffffffc0201248 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0201234:	6118                	ld	a4,0(a0)
ffffffffc0201236:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0201238:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020123a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020123c:	e398                	sd	a4,0(a5)
ffffffffc020123e:	091000ef          	jal	ra,ffffffffc0201ace <kfree>
    return listelm->next;
ffffffffc0201242:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0201244:	fea418e3          	bne	s0,a0,ffffffffc0201234 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0201248:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc020124a:	6402                	ld	s0,0(sp)
ffffffffc020124c:	60a2                	ld	ra,8(sp)
ffffffffc020124e:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0201250:	07f0006f          	j	ffffffffc0201ace <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0201254:	00005697          	auipc	a3,0x5
ffffffffc0201258:	0ec68693          	addi	a3,a3,236 # ffffffffc0206340 <commands+0x8d0>
ffffffffc020125c:	00005617          	auipc	a2,0x5
ffffffffc0201260:	05c60613          	addi	a2,a2,92 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201264:	09e00593          	li	a1,158
ffffffffc0201268:	00005517          	auipc	a0,0x5
ffffffffc020126c:	06850513          	addi	a0,a0,104 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201270:	faffe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201274 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0201274:	7139                	addi	sp,sp,-64
ffffffffc0201276:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0201278:	6405                	lui	s0,0x1
ffffffffc020127a:	147d                	addi	s0,s0,-1
ffffffffc020127c:	77fd                	lui	a5,0xfffff
ffffffffc020127e:	9622                	add	a2,a2,s0
ffffffffc0201280:	962e                	add	a2,a2,a1
{
ffffffffc0201282:	f426                	sd	s1,40(sp)
ffffffffc0201284:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0201286:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc020128a:	f04a                	sd	s2,32(sp)
ffffffffc020128c:	ec4e                	sd	s3,24(sp)
ffffffffc020128e:	e852                	sd	s4,16(sp)
ffffffffc0201290:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0201292:	002005b7          	lui	a1,0x200
ffffffffc0201296:	00f67433          	and	s0,a2,a5
ffffffffc020129a:	06b4e363          	bltu	s1,a1,ffffffffc0201300 <mm_map+0x8c>
ffffffffc020129e:	0684f163          	bgeu	s1,s0,ffffffffc0201300 <mm_map+0x8c>
ffffffffc02012a2:	4785                	li	a5,1
ffffffffc02012a4:	07fe                	slli	a5,a5,0x1f
ffffffffc02012a6:	0487ed63          	bltu	a5,s0,ffffffffc0201300 <mm_map+0x8c>
ffffffffc02012aa:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02012ac:	cd21                	beqz	a0,ffffffffc0201304 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02012ae:	85a6                	mv	a1,s1
ffffffffc02012b0:	8ab6                	mv	s5,a3
ffffffffc02012b2:	8a3a                	mv	s4,a4
ffffffffc02012b4:	e5fff0ef          	jal	ra,ffffffffc0201112 <find_vma>
ffffffffc02012b8:	c501                	beqz	a0,ffffffffc02012c0 <mm_map+0x4c>
ffffffffc02012ba:	651c                	ld	a5,8(a0)
ffffffffc02012bc:	0487e263          	bltu	a5,s0,ffffffffc0201300 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02012c0:	03000513          	li	a0,48
ffffffffc02012c4:	75a000ef          	jal	ra,ffffffffc0201a1e <kmalloc>
ffffffffc02012c8:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02012ca:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02012cc:	02090163          	beqz	s2,ffffffffc02012ee <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02012d0:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02012d2:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02012d6:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02012da:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02012de:	85ca                	mv	a1,s2
ffffffffc02012e0:	e73ff0ef          	jal	ra,ffffffffc0201152 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02012e4:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02012e6:	000a0463          	beqz	s4,ffffffffc02012ee <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02012ea:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc02012ee:	70e2                	ld	ra,56(sp)
ffffffffc02012f0:	7442                	ld	s0,48(sp)
ffffffffc02012f2:	74a2                	ld	s1,40(sp)
ffffffffc02012f4:	7902                	ld	s2,32(sp)
ffffffffc02012f6:	69e2                	ld	s3,24(sp)
ffffffffc02012f8:	6a42                	ld	s4,16(sp)
ffffffffc02012fa:	6aa2                	ld	s5,8(sp)
ffffffffc02012fc:	6121                	addi	sp,sp,64
ffffffffc02012fe:	8082                	ret
        return -E_INVAL;
ffffffffc0201300:	5575                	li	a0,-3
ffffffffc0201302:	b7f5                	j	ffffffffc02012ee <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0201304:	00005697          	auipc	a3,0x5
ffffffffc0201308:	05468693          	addi	a3,a3,84 # ffffffffc0206358 <commands+0x8e8>
ffffffffc020130c:	00005617          	auipc	a2,0x5
ffffffffc0201310:	fac60613          	addi	a2,a2,-84 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201314:	0b300593          	li	a1,179
ffffffffc0201318:	00005517          	auipc	a0,0x5
ffffffffc020131c:	fb850513          	addi	a0,a0,-72 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201320:	efffe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201324 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0201324:	7139                	addi	sp,sp,-64
ffffffffc0201326:	fc06                	sd	ra,56(sp)
ffffffffc0201328:	f822                	sd	s0,48(sp)
ffffffffc020132a:	f426                	sd	s1,40(sp)
ffffffffc020132c:	f04a                	sd	s2,32(sp)
ffffffffc020132e:	ec4e                	sd	s3,24(sp)
ffffffffc0201330:	e852                	sd	s4,16(sp)
ffffffffc0201332:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0201334:	c52d                	beqz	a0,ffffffffc020139e <dup_mmap+0x7a>
ffffffffc0201336:	892a                	mv	s2,a0
ffffffffc0201338:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc020133a:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc020133c:	e595                	bnez	a1,ffffffffc0201368 <dup_mmap+0x44>
ffffffffc020133e:	a085                	j	ffffffffc020139e <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0201340:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0201342:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4e98>
        vma->vm_end = vm_end;
ffffffffc0201346:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc020134a:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc020134e:	e05ff0ef          	jal	ra,ffffffffc0201152 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0201352:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8c10>
ffffffffc0201356:	fe843603          	ld	a2,-24(s0)
ffffffffc020135a:	6c8c                	ld	a1,24(s1)
ffffffffc020135c:	01893503          	ld	a0,24(s2)
ffffffffc0201360:	4701                	li	a4,0
ffffffffc0201362:	027020ef          	jal	ra,ffffffffc0203b88 <copy_range>
ffffffffc0201366:	e105                	bnez	a0,ffffffffc0201386 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0201368:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc020136a:	02848863          	beq	s1,s0,ffffffffc020139a <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020136e:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0201372:	fe843a83          	ld	s5,-24(s0)
ffffffffc0201376:	ff043a03          	ld	s4,-16(s0)
ffffffffc020137a:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020137e:	6a0000ef          	jal	ra,ffffffffc0201a1e <kmalloc>
ffffffffc0201382:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0201384:	fd55                	bnez	a0,ffffffffc0201340 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0201386:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0201388:	70e2                	ld	ra,56(sp)
ffffffffc020138a:	7442                	ld	s0,48(sp)
ffffffffc020138c:	74a2                	ld	s1,40(sp)
ffffffffc020138e:	7902                	ld	s2,32(sp)
ffffffffc0201390:	69e2                	ld	s3,24(sp)
ffffffffc0201392:	6a42                	ld	s4,16(sp)
ffffffffc0201394:	6aa2                	ld	s5,8(sp)
ffffffffc0201396:	6121                	addi	sp,sp,64
ffffffffc0201398:	8082                	ret
    return 0;
ffffffffc020139a:	4501                	li	a0,0
ffffffffc020139c:	b7f5                	j	ffffffffc0201388 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc020139e:	00005697          	auipc	a3,0x5
ffffffffc02013a2:	fca68693          	addi	a3,a3,-54 # ffffffffc0206368 <commands+0x8f8>
ffffffffc02013a6:	00005617          	auipc	a2,0x5
ffffffffc02013aa:	f1260613          	addi	a2,a2,-238 # ffffffffc02062b8 <commands+0x848>
ffffffffc02013ae:	0cf00593          	li	a1,207
ffffffffc02013b2:	00005517          	auipc	a0,0x5
ffffffffc02013b6:	f1e50513          	addi	a0,a0,-226 # ffffffffc02062d0 <commands+0x860>
ffffffffc02013ba:	e65fe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02013be <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02013be:	1101                	addi	sp,sp,-32
ffffffffc02013c0:	ec06                	sd	ra,24(sp)
ffffffffc02013c2:	e822                	sd	s0,16(sp)
ffffffffc02013c4:	e426                	sd	s1,8(sp)
ffffffffc02013c6:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02013c8:	c531                	beqz	a0,ffffffffc0201414 <exit_mmap+0x56>
ffffffffc02013ca:	591c                	lw	a5,48(a0)
ffffffffc02013cc:	84aa                	mv	s1,a0
ffffffffc02013ce:	e3b9                	bnez	a5,ffffffffc0201414 <exit_mmap+0x56>
    return listelm->next;
ffffffffc02013d0:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02013d2:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02013d6:	02850663          	beq	a0,s0,ffffffffc0201402 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02013da:	ff043603          	ld	a2,-16(s0)
ffffffffc02013de:	fe843583          	ld	a1,-24(s0)
ffffffffc02013e2:	854a                	mv	a0,s2
ffffffffc02013e4:	5fa010ef          	jal	ra,ffffffffc02029de <unmap_range>
ffffffffc02013e8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02013ea:	fe8498e3          	bne	s1,s0,ffffffffc02013da <exit_mmap+0x1c>
ffffffffc02013ee:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02013f0:	00848c63          	beq	s1,s0,ffffffffc0201408 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02013f4:	ff043603          	ld	a2,-16(s0)
ffffffffc02013f8:	fe843583          	ld	a1,-24(s0)
ffffffffc02013fc:	854a                	mv	a0,s2
ffffffffc02013fe:	726010ef          	jal	ra,ffffffffc0202b24 <exit_range>
ffffffffc0201402:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0201404:	fe8498e3          	bne	s1,s0,ffffffffc02013f4 <exit_mmap+0x36>
    }
}
ffffffffc0201408:	60e2                	ld	ra,24(sp)
ffffffffc020140a:	6442                	ld	s0,16(sp)
ffffffffc020140c:	64a2                	ld	s1,8(sp)
ffffffffc020140e:	6902                	ld	s2,0(sp)
ffffffffc0201410:	6105                	addi	sp,sp,32
ffffffffc0201412:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0201414:	00005697          	auipc	a3,0x5
ffffffffc0201418:	f7468693          	addi	a3,a3,-140 # ffffffffc0206388 <commands+0x918>
ffffffffc020141c:	00005617          	auipc	a2,0x5
ffffffffc0201420:	e9c60613          	addi	a2,a2,-356 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201424:	0e800593          	li	a1,232
ffffffffc0201428:	00005517          	auipc	a0,0x5
ffffffffc020142c:	ea850513          	addi	a0,a0,-344 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201430:	deffe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201434 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0201434:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201436:	04000513          	li	a0,64
{
ffffffffc020143a:	fc06                	sd	ra,56(sp)
ffffffffc020143c:	f822                	sd	s0,48(sp)
ffffffffc020143e:	f426                	sd	s1,40(sp)
ffffffffc0201440:	f04a                	sd	s2,32(sp)
ffffffffc0201442:	ec4e                	sd	s3,24(sp)
ffffffffc0201444:	e852                	sd	s4,16(sp)
ffffffffc0201446:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201448:	5d6000ef          	jal	ra,ffffffffc0201a1e <kmalloc>
    if (mm != NULL)
ffffffffc020144c:	2e050663          	beqz	a0,ffffffffc0201738 <vmm_init+0x304>
ffffffffc0201450:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0201452:	e508                	sd	a0,8(a0)
ffffffffc0201454:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0201456:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020145a:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020145e:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0201462:	02053423          	sd	zero,40(a0)
ffffffffc0201466:	02052823          	sw	zero,48(a0)
ffffffffc020146a:	02053c23          	sd	zero,56(a0)
ffffffffc020146e:	03200413          	li	s0,50
ffffffffc0201472:	a811                	j	ffffffffc0201486 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0201474:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201476:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201478:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc020147c:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc020147e:	8526                	mv	a0,s1
ffffffffc0201480:	cd3ff0ef          	jal	ra,ffffffffc0201152 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0201484:	c80d                	beqz	s0,ffffffffc02014b6 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201486:	03000513          	li	a0,48
ffffffffc020148a:	594000ef          	jal	ra,ffffffffc0201a1e <kmalloc>
ffffffffc020148e:	85aa                	mv	a1,a0
ffffffffc0201490:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0201494:	f165                	bnez	a0,ffffffffc0201474 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0201496:	00005697          	auipc	a3,0x5
ffffffffc020149a:	08a68693          	addi	a3,a3,138 # ffffffffc0206520 <commands+0xab0>
ffffffffc020149e:	00005617          	auipc	a2,0x5
ffffffffc02014a2:	e1a60613          	addi	a2,a2,-486 # ffffffffc02062b8 <commands+0x848>
ffffffffc02014a6:	12c00593          	li	a1,300
ffffffffc02014aa:	00005517          	auipc	a0,0x5
ffffffffc02014ae:	e2650513          	addi	a0,a0,-474 # ffffffffc02062d0 <commands+0x860>
ffffffffc02014b2:	d6dfe0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc02014b6:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02014ba:	1f900913          	li	s2,505
ffffffffc02014be:	a819                	j	ffffffffc02014d4 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc02014c0:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02014c2:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02014c4:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02014c8:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02014ca:	8526                	mv	a0,s1
ffffffffc02014cc:	c87ff0ef          	jal	ra,ffffffffc0201152 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02014d0:	03240a63          	beq	s0,s2,ffffffffc0201504 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02014d4:	03000513          	li	a0,48
ffffffffc02014d8:	546000ef          	jal	ra,ffffffffc0201a1e <kmalloc>
ffffffffc02014dc:	85aa                	mv	a1,a0
ffffffffc02014de:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02014e2:	fd79                	bnez	a0,ffffffffc02014c0 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc02014e4:	00005697          	auipc	a3,0x5
ffffffffc02014e8:	03c68693          	addi	a3,a3,60 # ffffffffc0206520 <commands+0xab0>
ffffffffc02014ec:	00005617          	auipc	a2,0x5
ffffffffc02014f0:	dcc60613          	addi	a2,a2,-564 # ffffffffc02062b8 <commands+0x848>
ffffffffc02014f4:	13300593          	li	a1,307
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	dd850513          	addi	a0,a0,-552 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201500:	d1ffe0ef          	jal	ra,ffffffffc020021e <__panic>
    return listelm->next;
ffffffffc0201504:	649c                	ld	a5,8(s1)
ffffffffc0201506:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0201508:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc020150c:	16f48663          	beq	s1,a5,ffffffffc0201678 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201510:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd543cc>
ffffffffc0201514:	ffe70693          	addi	a3,a4,-2
ffffffffc0201518:	10d61063          	bne	a2,a3,ffffffffc0201618 <vmm_init+0x1e4>
ffffffffc020151c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0201520:	0ed71c63          	bne	a4,a3,ffffffffc0201618 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0201524:	0715                	addi	a4,a4,5
ffffffffc0201526:	679c                	ld	a5,8(a5)
ffffffffc0201528:	feb712e3          	bne	a4,a1,ffffffffc020150c <vmm_init+0xd8>
ffffffffc020152c:	4a1d                	li	s4,7
ffffffffc020152e:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0201530:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0201534:	85a2                	mv	a1,s0
ffffffffc0201536:	8526                	mv	a0,s1
ffffffffc0201538:	bdbff0ef          	jal	ra,ffffffffc0201112 <find_vma>
ffffffffc020153c:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc020153e:	16050d63          	beqz	a0,ffffffffc02016b8 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0201542:	00140593          	addi	a1,s0,1
ffffffffc0201546:	8526                	mv	a0,s1
ffffffffc0201548:	bcbff0ef          	jal	ra,ffffffffc0201112 <find_vma>
ffffffffc020154c:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc020154e:	14050563          	beqz	a0,ffffffffc0201698 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0201552:	85d2                	mv	a1,s4
ffffffffc0201554:	8526                	mv	a0,s1
ffffffffc0201556:	bbdff0ef          	jal	ra,ffffffffc0201112 <find_vma>
        assert(vma3 == NULL);
ffffffffc020155a:	16051f63          	bnez	a0,ffffffffc02016d8 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc020155e:	00340593          	addi	a1,s0,3
ffffffffc0201562:	8526                	mv	a0,s1
ffffffffc0201564:	bafff0ef          	jal	ra,ffffffffc0201112 <find_vma>
        assert(vma4 == NULL);
ffffffffc0201568:	1a051863          	bnez	a0,ffffffffc0201718 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc020156c:	00440593          	addi	a1,s0,4
ffffffffc0201570:	8526                	mv	a0,s1
ffffffffc0201572:	ba1ff0ef          	jal	ra,ffffffffc0201112 <find_vma>
        assert(vma5 == NULL);
ffffffffc0201576:	18051163          	bnez	a0,ffffffffc02016f8 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc020157a:	00893783          	ld	a5,8(s2)
ffffffffc020157e:	0a879d63          	bne	a5,s0,ffffffffc0201638 <vmm_init+0x204>
ffffffffc0201582:	01093783          	ld	a5,16(s2)
ffffffffc0201586:	0b479963          	bne	a5,s4,ffffffffc0201638 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc020158a:	0089b783          	ld	a5,8(s3)
ffffffffc020158e:	0c879563          	bne	a5,s0,ffffffffc0201658 <vmm_init+0x224>
ffffffffc0201592:	0109b783          	ld	a5,16(s3)
ffffffffc0201596:	0d479163          	bne	a5,s4,ffffffffc0201658 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc020159a:	0415                	addi	s0,s0,5
ffffffffc020159c:	0a15                	addi	s4,s4,5
ffffffffc020159e:	f9541be3          	bne	s0,s5,ffffffffc0201534 <vmm_init+0x100>
ffffffffc02015a2:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc02015a4:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc02015a6:	85a2                	mv	a1,s0
ffffffffc02015a8:	8526                	mv	a0,s1
ffffffffc02015aa:	b69ff0ef          	jal	ra,ffffffffc0201112 <find_vma>
ffffffffc02015ae:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc02015b2:	c90d                	beqz	a0,ffffffffc02015e4 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02015b4:	6914                	ld	a3,16(a0)
ffffffffc02015b6:	6510                	ld	a2,8(a0)
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	ef050513          	addi	a0,a0,-272 # ffffffffc02064a8 <commands+0xa38>
ffffffffc02015c0:	b21fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	f0c68693          	addi	a3,a3,-244 # ffffffffc02064d0 <commands+0xa60>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	cec60613          	addi	a2,a2,-788 # ffffffffc02062b8 <commands+0x848>
ffffffffc02015d4:	15900593          	li	a1,345
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	cf850513          	addi	a0,a0,-776 # ffffffffc02062d0 <commands+0x860>
ffffffffc02015e0:	c3ffe0ef          	jal	ra,ffffffffc020021e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc02015e4:	147d                	addi	s0,s0,-1
ffffffffc02015e6:	fd2410e3          	bne	s0,s2,ffffffffc02015a6 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc02015ea:	8526                	mv	a0,s1
ffffffffc02015ec:	c37ff0ef          	jal	ra,ffffffffc0201222 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02015f0:	00005517          	auipc	a0,0x5
ffffffffc02015f4:	ef850513          	addi	a0,a0,-264 # ffffffffc02064e8 <commands+0xa78>
ffffffffc02015f8:	ae9fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc02015fc:	7442                	ld	s0,48(sp)
ffffffffc02015fe:	70e2                	ld	ra,56(sp)
ffffffffc0201600:	74a2                	ld	s1,40(sp)
ffffffffc0201602:	7902                	ld	s2,32(sp)
ffffffffc0201604:	69e2                	ld	s3,24(sp)
ffffffffc0201606:	6a42                	ld	s4,16(sp)
ffffffffc0201608:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc020160a:	00005517          	auipc	a0,0x5
ffffffffc020160e:	efe50513          	addi	a0,a0,-258 # ffffffffc0206508 <commands+0xa98>
}
ffffffffc0201612:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0201614:	acdfe06f          	j	ffffffffc02000e0 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201618:	00005697          	auipc	a3,0x5
ffffffffc020161c:	da868693          	addi	a3,a3,-600 # ffffffffc02063c0 <commands+0x950>
ffffffffc0201620:	00005617          	auipc	a2,0x5
ffffffffc0201624:	c9860613          	addi	a2,a2,-872 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201628:	13d00593          	li	a1,317
ffffffffc020162c:	00005517          	auipc	a0,0x5
ffffffffc0201630:	ca450513          	addi	a0,a0,-860 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201634:	bebfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0201638:	00005697          	auipc	a3,0x5
ffffffffc020163c:	e1068693          	addi	a3,a3,-496 # ffffffffc0206448 <commands+0x9d8>
ffffffffc0201640:	00005617          	auipc	a2,0x5
ffffffffc0201644:	c7860613          	addi	a2,a2,-904 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201648:	14e00593          	li	a1,334
ffffffffc020164c:	00005517          	auipc	a0,0x5
ffffffffc0201650:	c8450513          	addi	a0,a0,-892 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201654:	bcbfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0201658:	00005697          	auipc	a3,0x5
ffffffffc020165c:	e2068693          	addi	a3,a3,-480 # ffffffffc0206478 <commands+0xa08>
ffffffffc0201660:	00005617          	auipc	a2,0x5
ffffffffc0201664:	c5860613          	addi	a2,a2,-936 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201668:	14f00593          	li	a1,335
ffffffffc020166c:	00005517          	auipc	a0,0x5
ffffffffc0201670:	c6450513          	addi	a0,a0,-924 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201674:	babfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0201678:	00005697          	auipc	a3,0x5
ffffffffc020167c:	d3068693          	addi	a3,a3,-720 # ffffffffc02063a8 <commands+0x938>
ffffffffc0201680:	00005617          	auipc	a2,0x5
ffffffffc0201684:	c3860613          	addi	a2,a2,-968 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201688:	13b00593          	li	a1,315
ffffffffc020168c:	00005517          	auipc	a0,0x5
ffffffffc0201690:	c4450513          	addi	a0,a0,-956 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201694:	b8bfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma2 != NULL);
ffffffffc0201698:	00005697          	auipc	a3,0x5
ffffffffc020169c:	d7068693          	addi	a3,a3,-656 # ffffffffc0206408 <commands+0x998>
ffffffffc02016a0:	00005617          	auipc	a2,0x5
ffffffffc02016a4:	c1860613          	addi	a2,a2,-1000 # ffffffffc02062b8 <commands+0x848>
ffffffffc02016a8:	14600593          	li	a1,326
ffffffffc02016ac:	00005517          	auipc	a0,0x5
ffffffffc02016b0:	c2450513          	addi	a0,a0,-988 # ffffffffc02062d0 <commands+0x860>
ffffffffc02016b4:	b6bfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma1 != NULL);
ffffffffc02016b8:	00005697          	auipc	a3,0x5
ffffffffc02016bc:	d4068693          	addi	a3,a3,-704 # ffffffffc02063f8 <commands+0x988>
ffffffffc02016c0:	00005617          	auipc	a2,0x5
ffffffffc02016c4:	bf860613          	addi	a2,a2,-1032 # ffffffffc02062b8 <commands+0x848>
ffffffffc02016c8:	14400593          	li	a1,324
ffffffffc02016cc:	00005517          	auipc	a0,0x5
ffffffffc02016d0:	c0450513          	addi	a0,a0,-1020 # ffffffffc02062d0 <commands+0x860>
ffffffffc02016d4:	b4bfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma3 == NULL);
ffffffffc02016d8:	00005697          	auipc	a3,0x5
ffffffffc02016dc:	d4068693          	addi	a3,a3,-704 # ffffffffc0206418 <commands+0x9a8>
ffffffffc02016e0:	00005617          	auipc	a2,0x5
ffffffffc02016e4:	bd860613          	addi	a2,a2,-1064 # ffffffffc02062b8 <commands+0x848>
ffffffffc02016e8:	14800593          	li	a1,328
ffffffffc02016ec:	00005517          	auipc	a0,0x5
ffffffffc02016f0:	be450513          	addi	a0,a0,-1052 # ffffffffc02062d0 <commands+0x860>
ffffffffc02016f4:	b2bfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma5 == NULL);
ffffffffc02016f8:	00005697          	auipc	a3,0x5
ffffffffc02016fc:	d4068693          	addi	a3,a3,-704 # ffffffffc0206438 <commands+0x9c8>
ffffffffc0201700:	00005617          	auipc	a2,0x5
ffffffffc0201704:	bb860613          	addi	a2,a2,-1096 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201708:	14c00593          	li	a1,332
ffffffffc020170c:	00005517          	auipc	a0,0x5
ffffffffc0201710:	bc450513          	addi	a0,a0,-1084 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201714:	b0bfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma4 == NULL);
ffffffffc0201718:	00005697          	auipc	a3,0x5
ffffffffc020171c:	d1068693          	addi	a3,a3,-752 # ffffffffc0206428 <commands+0x9b8>
ffffffffc0201720:	00005617          	auipc	a2,0x5
ffffffffc0201724:	b9860613          	addi	a2,a2,-1128 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201728:	14a00593          	li	a1,330
ffffffffc020172c:	00005517          	auipc	a0,0x5
ffffffffc0201730:	ba450513          	addi	a0,a0,-1116 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201734:	aebfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(mm != NULL);
ffffffffc0201738:	00005697          	auipc	a3,0x5
ffffffffc020173c:	c2068693          	addi	a3,a3,-992 # ffffffffc0206358 <commands+0x8e8>
ffffffffc0201740:	00005617          	auipc	a2,0x5
ffffffffc0201744:	b7860613          	addi	a2,a2,-1160 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201748:	12400593          	li	a1,292
ffffffffc020174c:	00005517          	auipc	a0,0x5
ffffffffc0201750:	b8450513          	addi	a0,a0,-1148 # ffffffffc02062d0 <commands+0x860>
ffffffffc0201754:	acbfe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201758 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0201758:	7179                	addi	sp,sp,-48
ffffffffc020175a:	f022                	sd	s0,32(sp)
ffffffffc020175c:	f406                	sd	ra,40(sp)
ffffffffc020175e:	ec26                	sd	s1,24(sp)
ffffffffc0201760:	e84a                	sd	s2,16(sp)
ffffffffc0201762:	e44e                	sd	s3,8(sp)
ffffffffc0201764:	e052                	sd	s4,0(sp)
ffffffffc0201766:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0201768:	c135                	beqz	a0,ffffffffc02017cc <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc020176a:	002007b7          	lui	a5,0x200
ffffffffc020176e:	04f5e663          	bltu	a1,a5,ffffffffc02017ba <user_mem_check+0x62>
ffffffffc0201772:	00c584b3          	add	s1,a1,a2
ffffffffc0201776:	0495f263          	bgeu	a1,s1,ffffffffc02017ba <user_mem_check+0x62>
ffffffffc020177a:	4785                	li	a5,1
ffffffffc020177c:	07fe                	slli	a5,a5,0x1f
ffffffffc020177e:	0297ee63          	bltu	a5,s1,ffffffffc02017ba <user_mem_check+0x62>
ffffffffc0201782:	892a                	mv	s2,a0
ffffffffc0201784:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0201786:	6a05                	lui	s4,0x1
ffffffffc0201788:	a821                	j	ffffffffc02017a0 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc020178a:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc020178e:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0201790:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0201792:	c685                	beqz	a3,ffffffffc02017ba <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0201794:	c399                	beqz	a5,ffffffffc020179a <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0201796:	02e46263          	bltu	s0,a4,ffffffffc02017ba <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc020179a:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc020179c:	04947663          	bgeu	s0,s1,ffffffffc02017e8 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc02017a0:	85a2                	mv	a1,s0
ffffffffc02017a2:	854a                	mv	a0,s2
ffffffffc02017a4:	96fff0ef          	jal	ra,ffffffffc0201112 <find_vma>
ffffffffc02017a8:	c909                	beqz	a0,ffffffffc02017ba <user_mem_check+0x62>
ffffffffc02017aa:	6518                	ld	a4,8(a0)
ffffffffc02017ac:	00e46763          	bltu	s0,a4,ffffffffc02017ba <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc02017b0:	4d1c                	lw	a5,24(a0)
ffffffffc02017b2:	fc099ce3          	bnez	s3,ffffffffc020178a <user_mem_check+0x32>
ffffffffc02017b6:	8b85                	andi	a5,a5,1
ffffffffc02017b8:	f3ed                	bnez	a5,ffffffffc020179a <user_mem_check+0x42>
            return 0;
ffffffffc02017ba:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc02017bc:	70a2                	ld	ra,40(sp)
ffffffffc02017be:	7402                	ld	s0,32(sp)
ffffffffc02017c0:	64e2                	ld	s1,24(sp)
ffffffffc02017c2:	6942                	ld	s2,16(sp)
ffffffffc02017c4:	69a2                	ld	s3,8(sp)
ffffffffc02017c6:	6a02                	ld	s4,0(sp)
ffffffffc02017c8:	6145                	addi	sp,sp,48
ffffffffc02017ca:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc02017cc:	c02007b7          	lui	a5,0xc0200
ffffffffc02017d0:	4501                	li	a0,0
ffffffffc02017d2:	fef5e5e3          	bltu	a1,a5,ffffffffc02017bc <user_mem_check+0x64>
ffffffffc02017d6:	962e                	add	a2,a2,a1
ffffffffc02017d8:	fec5f2e3          	bgeu	a1,a2,ffffffffc02017bc <user_mem_check+0x64>
ffffffffc02017dc:	c8000537          	lui	a0,0xc8000
ffffffffc02017e0:	0505                	addi	a0,a0,1
ffffffffc02017e2:	00a63533          	sltu	a0,a2,a0
ffffffffc02017e6:	bfd9                	j	ffffffffc02017bc <user_mem_check+0x64>
        return 1;
ffffffffc02017e8:	4505                	li	a0,1
ffffffffc02017ea:	bfc9                	j	ffffffffc02017bc <user_mem_check+0x64>

ffffffffc02017ec <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02017ec:	c94d                	beqz	a0,ffffffffc020189e <slob_free+0xb2>
{
ffffffffc02017ee:	1141                	addi	sp,sp,-16
ffffffffc02017f0:	e022                	sd	s0,0(sp)
ffffffffc02017f2:	e406                	sd	ra,8(sp)
ffffffffc02017f4:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc02017f6:	e9c1                	bnez	a1,ffffffffc0201886 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02017f8:	100027f3          	csrr	a5,sstatus
ffffffffc02017fc:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02017fe:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201800:	ebd9                	bnez	a5,ffffffffc0201896 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201802:	000a5617          	auipc	a2,0xa5
ffffffffc0201806:	f6660613          	addi	a2,a2,-154 # ffffffffc02a6768 <slobfree>
ffffffffc020180a:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020180c:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020180e:	679c                	ld	a5,8(a5)
ffffffffc0201810:	02877a63          	bgeu	a4,s0,ffffffffc0201844 <slob_free+0x58>
ffffffffc0201814:	00f46463          	bltu	s0,a5,ffffffffc020181c <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201818:	fef76ae3          	bltu	a4,a5,ffffffffc020180c <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc020181c:	400c                	lw	a1,0(s0)
ffffffffc020181e:	00459693          	slli	a3,a1,0x4
ffffffffc0201822:	96a2                	add	a3,a3,s0
ffffffffc0201824:	02d78a63          	beq	a5,a3,ffffffffc0201858 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201828:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc020182a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc020182c:	00469793          	slli	a5,a3,0x4
ffffffffc0201830:	97ba                	add	a5,a5,a4
ffffffffc0201832:	02f40e63          	beq	s0,a5,ffffffffc020186e <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201836:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201838:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc020183a:	e129                	bnez	a0,ffffffffc020187c <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc020183c:	60a2                	ld	ra,8(sp)
ffffffffc020183e:	6402                	ld	s0,0(sp)
ffffffffc0201840:	0141                	addi	sp,sp,16
ffffffffc0201842:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201844:	fcf764e3          	bltu	a4,a5,ffffffffc020180c <slob_free+0x20>
ffffffffc0201848:	fcf472e3          	bgeu	s0,a5,ffffffffc020180c <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc020184c:	400c                	lw	a1,0(s0)
ffffffffc020184e:	00459693          	slli	a3,a1,0x4
ffffffffc0201852:	96a2                	add	a3,a3,s0
ffffffffc0201854:	fcd79ae3          	bne	a5,a3,ffffffffc0201828 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201858:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020185a:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc020185c:	9db5                	addw	a1,a1,a3
ffffffffc020185e:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201860:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201862:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201864:	00469793          	slli	a5,a3,0x4
ffffffffc0201868:	97ba                	add	a5,a5,a4
ffffffffc020186a:	fcf416e3          	bne	s0,a5,ffffffffc0201836 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc020186e:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201870:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201872:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201874:	9ebd                	addw	a3,a3,a5
ffffffffc0201876:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201878:	e70c                	sd	a1,8(a4)
ffffffffc020187a:	d169                	beqz	a0,ffffffffc020183c <slob_free+0x50>
}
ffffffffc020187c:	6402                	ld	s0,0(sp)
ffffffffc020187e:	60a2                	ld	ra,8(sp)
ffffffffc0201880:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201882:	932ff06f          	j	ffffffffc02009b4 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201886:	25bd                	addiw	a1,a1,15
ffffffffc0201888:	8191                	srli	a1,a1,0x4
ffffffffc020188a:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020188c:	100027f3          	csrr	a5,sstatus
ffffffffc0201890:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201892:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201894:	d7bd                	beqz	a5,ffffffffc0201802 <slob_free+0x16>
        intr_disable();
ffffffffc0201896:	924ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc020189a:	4505                	li	a0,1
ffffffffc020189c:	b79d                	j	ffffffffc0201802 <slob_free+0x16>
ffffffffc020189e:	8082                	ret

ffffffffc02018a0 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc02018a0:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02018a2:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc02018a4:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02018a8:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc02018aa:	601000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
	if (!page)
ffffffffc02018ae:	c91d                	beqz	a0,ffffffffc02018e4 <__slob_get_free_pages.constprop.0+0x44>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc02018b0:	000a9697          	auipc	a3,0xa9
ffffffffc02018b4:	3386b683          	ld	a3,824(a3) # ffffffffc02aabe8 <pages>
ffffffffc02018b8:	8d15                	sub	a0,a0,a3
ffffffffc02018ba:	8519                	srai	a0,a0,0x6
ffffffffc02018bc:	00006697          	auipc	a3,0x6
ffffffffc02018c0:	0c46b683          	ld	a3,196(a3) # ffffffffc0207980 <nbase>
ffffffffc02018c4:	9536                	add	a0,a0,a3
}

static inline void *
page2kva(struct Page *page)
{
    return KADDR(page2pa(page));
ffffffffc02018c6:	00c51793          	slli	a5,a0,0xc
ffffffffc02018ca:	83b1                	srli	a5,a5,0xc
ffffffffc02018cc:	000a9717          	auipc	a4,0xa9
ffffffffc02018d0:	31473703          	ld	a4,788(a4) # ffffffffc02aabe0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02018d4:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc02018d6:	00e7fa63          	bgeu	a5,a4,ffffffffc02018ea <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02018da:	000a9697          	auipc	a3,0xa9
ffffffffc02018de:	31e6b683          	ld	a3,798(a3) # ffffffffc02aabf8 <va_pa_offset>
ffffffffc02018e2:	9536                	add	a0,a0,a3
}
ffffffffc02018e4:	60a2                	ld	ra,8(sp)
ffffffffc02018e6:	0141                	addi	sp,sp,16
ffffffffc02018e8:	8082                	ret
ffffffffc02018ea:	86aa                	mv	a3,a0
ffffffffc02018ec:	00005617          	auipc	a2,0x5
ffffffffc02018f0:	c4460613          	addi	a2,a2,-956 # ffffffffc0206530 <commands+0xac0>
ffffffffc02018f4:	07100593          	li	a1,113
ffffffffc02018f8:	00005517          	auipc	a0,0x5
ffffffffc02018fc:	c6050513          	addi	a0,a0,-928 # ffffffffc0206558 <commands+0xae8>
ffffffffc0201900:	91ffe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201904 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201904:	1101                	addi	sp,sp,-32
ffffffffc0201906:	ec06                	sd	ra,24(sp)
ffffffffc0201908:	e822                	sd	s0,16(sp)
ffffffffc020190a:	e426                	sd	s1,8(sp)
ffffffffc020190c:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020190e:	01050713          	addi	a4,a0,16
ffffffffc0201912:	6785                	lui	a5,0x1
ffffffffc0201914:	0cf77363          	bgeu	a4,a5,ffffffffc02019da <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201918:	00f50493          	addi	s1,a0,15
ffffffffc020191c:	8091                	srli	s1,s1,0x4
ffffffffc020191e:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201920:	10002673          	csrr	a2,sstatus
ffffffffc0201924:	8a09                	andi	a2,a2,2
ffffffffc0201926:	e25d                	bnez	a2,ffffffffc02019cc <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201928:	000a5917          	auipc	s2,0xa5
ffffffffc020192c:	e4090913          	addi	s2,s2,-448 # ffffffffc02a6768 <slobfree>
ffffffffc0201930:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201934:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201936:	4398                	lw	a4,0(a5)
ffffffffc0201938:	08975e63          	bge	a4,s1,ffffffffc02019d4 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc020193c:	00f68b63          	beq	a3,a5,ffffffffc0201952 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201940:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201942:	4018                	lw	a4,0(s0)
ffffffffc0201944:	02975a63          	bge	a4,s1,ffffffffc0201978 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201948:	00093683          	ld	a3,0(s2)
ffffffffc020194c:	87a2                	mv	a5,s0
ffffffffc020194e:	fef699e3          	bne	a3,a5,ffffffffc0201940 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201952:	ee31                	bnez	a2,ffffffffc02019ae <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201954:	4501                	li	a0,0
ffffffffc0201956:	f4bff0ef          	jal	ra,ffffffffc02018a0 <__slob_get_free_pages.constprop.0>
ffffffffc020195a:	842a                	mv	s0,a0
			if (!cur)
ffffffffc020195c:	cd05                	beqz	a0,ffffffffc0201994 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc020195e:	6585                	lui	a1,0x1
ffffffffc0201960:	e8dff0ef          	jal	ra,ffffffffc02017ec <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201964:	10002673          	csrr	a2,sstatus
ffffffffc0201968:	8a09                	andi	a2,a2,2
ffffffffc020196a:	ee05                	bnez	a2,ffffffffc02019a2 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc020196c:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201970:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201972:	4018                	lw	a4,0(s0)
ffffffffc0201974:	fc974ae3          	blt	a4,s1,ffffffffc0201948 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201978:	04e48763          	beq	s1,a4,ffffffffc02019c6 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc020197c:	00449693          	slli	a3,s1,0x4
ffffffffc0201980:	96a2                	add	a3,a3,s0
ffffffffc0201982:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201984:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201986:	9f05                	subw	a4,a4,s1
ffffffffc0201988:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc020198a:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc020198c:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc020198e:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201992:	e20d                	bnez	a2,ffffffffc02019b4 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201994:	60e2                	ld	ra,24(sp)
ffffffffc0201996:	8522                	mv	a0,s0
ffffffffc0201998:	6442                	ld	s0,16(sp)
ffffffffc020199a:	64a2                	ld	s1,8(sp)
ffffffffc020199c:	6902                	ld	s2,0(sp)
ffffffffc020199e:	6105                	addi	sp,sp,32
ffffffffc02019a0:	8082                	ret
        intr_disable();
ffffffffc02019a2:	818ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
			cur = slobfree;
ffffffffc02019a6:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc02019aa:	4605                	li	a2,1
ffffffffc02019ac:	b7d1                	j	ffffffffc0201970 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02019ae:	806ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02019b2:	b74d                	j	ffffffffc0201954 <slob_alloc.constprop.0+0x50>
ffffffffc02019b4:	800ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
}
ffffffffc02019b8:	60e2                	ld	ra,24(sp)
ffffffffc02019ba:	8522                	mv	a0,s0
ffffffffc02019bc:	6442                	ld	s0,16(sp)
ffffffffc02019be:	64a2                	ld	s1,8(sp)
ffffffffc02019c0:	6902                	ld	s2,0(sp)
ffffffffc02019c2:	6105                	addi	sp,sp,32
ffffffffc02019c4:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc02019c6:	6418                	ld	a4,8(s0)
ffffffffc02019c8:	e798                	sd	a4,8(a5)
ffffffffc02019ca:	b7d1                	j	ffffffffc020198e <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc02019cc:	feffe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc02019d0:	4605                	li	a2,1
ffffffffc02019d2:	bf99                	j	ffffffffc0201928 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc02019d4:	843e                	mv	s0,a5
ffffffffc02019d6:	87b6                	mv	a5,a3
ffffffffc02019d8:	b745                	j	ffffffffc0201978 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc02019da:	00005697          	auipc	a3,0x5
ffffffffc02019de:	b8e68693          	addi	a3,a3,-1138 # ffffffffc0206568 <commands+0xaf8>
ffffffffc02019e2:	00005617          	auipc	a2,0x5
ffffffffc02019e6:	8d660613          	addi	a2,a2,-1834 # ffffffffc02062b8 <commands+0x848>
ffffffffc02019ea:	06300593          	li	a1,99
ffffffffc02019ee:	00005517          	auipc	a0,0x5
ffffffffc02019f2:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0206588 <commands+0xb18>
ffffffffc02019f6:	829fe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02019fa <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc02019fa:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc02019fc:	00005517          	auipc	a0,0x5
ffffffffc0201a00:	ba450513          	addi	a0,a0,-1116 # ffffffffc02065a0 <commands+0xb30>
{
ffffffffc0201a04:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201a06:	edafe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201a0a:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201a0c:	00005517          	auipc	a0,0x5
ffffffffc0201a10:	bac50513          	addi	a0,a0,-1108 # ffffffffc02065b8 <commands+0xb48>
}
ffffffffc0201a14:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201a16:	ecafe06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0201a1a <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201a1a:	4501                	li	a0,0
ffffffffc0201a1c:	8082                	ret

ffffffffc0201a1e <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201a1e:	1101                	addi	sp,sp,-32
ffffffffc0201a20:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201a22:	6905                	lui	s2,0x1
{
ffffffffc0201a24:	e822                	sd	s0,16(sp)
ffffffffc0201a26:	ec06                	sd	ra,24(sp)
ffffffffc0201a28:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201a2a:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8c11>
{
ffffffffc0201a2e:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201a30:	04a7f963          	bgeu	a5,a0,ffffffffc0201a82 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201a34:	4561                	li	a0,24
ffffffffc0201a36:	ecfff0ef          	jal	ra,ffffffffc0201904 <slob_alloc.constprop.0>
ffffffffc0201a3a:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201a3c:	c929                	beqz	a0,ffffffffc0201a8e <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201a3e:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201a42:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201a44:	00f95763          	bge	s2,a5,ffffffffc0201a52 <kmalloc+0x34>
ffffffffc0201a48:	6705                	lui	a4,0x1
ffffffffc0201a4a:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201a4c:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201a4e:	fef74ee3          	blt	a4,a5,ffffffffc0201a4a <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201a52:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201a54:	e4dff0ef          	jal	ra,ffffffffc02018a0 <__slob_get_free_pages.constprop.0>
ffffffffc0201a58:	e488                	sd	a0,8(s1)
ffffffffc0201a5a:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201a5c:	c525                	beqz	a0,ffffffffc0201ac4 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a5e:	100027f3          	csrr	a5,sstatus
ffffffffc0201a62:	8b89                	andi	a5,a5,2
ffffffffc0201a64:	ef8d                	bnez	a5,ffffffffc0201a9e <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201a66:	000a9797          	auipc	a5,0xa9
ffffffffc0201a6a:	16278793          	addi	a5,a5,354 # ffffffffc02aabc8 <bigblocks>
ffffffffc0201a6e:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201a70:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201a72:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201a74:	60e2                	ld	ra,24(sp)
ffffffffc0201a76:	8522                	mv	a0,s0
ffffffffc0201a78:	6442                	ld	s0,16(sp)
ffffffffc0201a7a:	64a2                	ld	s1,8(sp)
ffffffffc0201a7c:	6902                	ld	s2,0(sp)
ffffffffc0201a7e:	6105                	addi	sp,sp,32
ffffffffc0201a80:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201a82:	0541                	addi	a0,a0,16
ffffffffc0201a84:	e81ff0ef          	jal	ra,ffffffffc0201904 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201a88:	01050413          	addi	s0,a0,16
ffffffffc0201a8c:	f565                	bnez	a0,ffffffffc0201a74 <kmalloc+0x56>
ffffffffc0201a8e:	4401                	li	s0,0
}
ffffffffc0201a90:	60e2                	ld	ra,24(sp)
ffffffffc0201a92:	8522                	mv	a0,s0
ffffffffc0201a94:	6442                	ld	s0,16(sp)
ffffffffc0201a96:	64a2                	ld	s1,8(sp)
ffffffffc0201a98:	6902                	ld	s2,0(sp)
ffffffffc0201a9a:	6105                	addi	sp,sp,32
ffffffffc0201a9c:	8082                	ret
        intr_disable();
ffffffffc0201a9e:	f1dfe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
		bb->next = bigblocks;
ffffffffc0201aa2:	000a9797          	auipc	a5,0xa9
ffffffffc0201aa6:	12678793          	addi	a5,a5,294 # ffffffffc02aabc8 <bigblocks>
ffffffffc0201aaa:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201aac:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201aae:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201ab0:	f05fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
		return bb->pages;
ffffffffc0201ab4:	6480                	ld	s0,8(s1)
}
ffffffffc0201ab6:	60e2                	ld	ra,24(sp)
ffffffffc0201ab8:	64a2                	ld	s1,8(sp)
ffffffffc0201aba:	8522                	mv	a0,s0
ffffffffc0201abc:	6442                	ld	s0,16(sp)
ffffffffc0201abe:	6902                	ld	s2,0(sp)
ffffffffc0201ac0:	6105                	addi	sp,sp,32
ffffffffc0201ac2:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ac4:	45e1                	li	a1,24
ffffffffc0201ac6:	8526                	mv	a0,s1
ffffffffc0201ac8:	d25ff0ef          	jal	ra,ffffffffc02017ec <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201acc:	b765                	j	ffffffffc0201a74 <kmalloc+0x56>

ffffffffc0201ace <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201ace:	c169                	beqz	a0,ffffffffc0201b90 <kfree+0xc2>
{
ffffffffc0201ad0:	1101                	addi	sp,sp,-32
ffffffffc0201ad2:	e822                	sd	s0,16(sp)
ffffffffc0201ad4:	ec06                	sd	ra,24(sp)
ffffffffc0201ad6:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201ad8:	03451793          	slli	a5,a0,0x34
ffffffffc0201adc:	842a                	mv	s0,a0
ffffffffc0201ade:	e3d9                	bnez	a5,ffffffffc0201b64 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ae0:	100027f3          	csrr	a5,sstatus
ffffffffc0201ae4:	8b89                	andi	a5,a5,2
ffffffffc0201ae6:	e7d9                	bnez	a5,ffffffffc0201b74 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201ae8:	000a9797          	auipc	a5,0xa9
ffffffffc0201aec:	0e07b783          	ld	a5,224(a5) # ffffffffc02aabc8 <bigblocks>
    return 0;
ffffffffc0201af0:	4601                	li	a2,0
ffffffffc0201af2:	cbad                	beqz	a5,ffffffffc0201b64 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201af4:	000a9697          	auipc	a3,0xa9
ffffffffc0201af8:	0d468693          	addi	a3,a3,212 # ffffffffc02aabc8 <bigblocks>
ffffffffc0201afc:	a021                	j	ffffffffc0201b04 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201afe:	01048693          	addi	a3,s1,16
ffffffffc0201b02:	c3a5                	beqz	a5,ffffffffc0201b62 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201b04:	6798                	ld	a4,8(a5)
ffffffffc0201b06:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201b08:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201b0a:	fe871ae3          	bne	a4,s0,ffffffffc0201afe <kfree+0x30>
				*last = bb->next;
ffffffffc0201b0e:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201b10:	ee2d                	bnez	a2,ffffffffc0201b8a <kfree+0xbc>
}

static inline struct Page *
kva2page(void *kva)
{
    return pa2page(PADDR(kva));
ffffffffc0201b12:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201b16:	4098                	lw	a4,0(s1)
ffffffffc0201b18:	08f46963          	bltu	s0,a5,ffffffffc0201baa <kfree+0xdc>
ffffffffc0201b1c:	000a9697          	auipc	a3,0xa9
ffffffffc0201b20:	0dc6b683          	ld	a3,220(a3) # ffffffffc02aabf8 <va_pa_offset>
ffffffffc0201b24:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201b26:	8031                	srli	s0,s0,0xc
ffffffffc0201b28:	000a9797          	auipc	a5,0xa9
ffffffffc0201b2c:	0b87b783          	ld	a5,184(a5) # ffffffffc02aabe0 <npage>
ffffffffc0201b30:	06f47163          	bgeu	s0,a5,ffffffffc0201b92 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201b34:	00006517          	auipc	a0,0x6
ffffffffc0201b38:	e4c53503          	ld	a0,-436(a0) # ffffffffc0207980 <nbase>
ffffffffc0201b3c:	8c09                	sub	s0,s0,a0
ffffffffc0201b3e:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201b40:	000a9517          	auipc	a0,0xa9
ffffffffc0201b44:	0a853503          	ld	a0,168(a0) # ffffffffc02aabe8 <pages>
ffffffffc0201b48:	4585                	li	a1,1
ffffffffc0201b4a:	9522                	add	a0,a0,s0
ffffffffc0201b4c:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201b50:	399000ef          	jal	ra,ffffffffc02026e8 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201b54:	6442                	ld	s0,16(sp)
ffffffffc0201b56:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b58:	8526                	mv	a0,s1
}
ffffffffc0201b5a:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b5c:	45e1                	li	a1,24
}
ffffffffc0201b5e:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201b60:	b171                	j	ffffffffc02017ec <slob_free>
ffffffffc0201b62:	e20d                	bnez	a2,ffffffffc0201b84 <kfree+0xb6>
ffffffffc0201b64:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201b68:	6442                	ld	s0,16(sp)
ffffffffc0201b6a:	60e2                	ld	ra,24(sp)
ffffffffc0201b6c:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201b6e:	4581                	li	a1,0
}
ffffffffc0201b70:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201b72:	b9ad                	j	ffffffffc02017ec <slob_free>
        intr_disable();
ffffffffc0201b74:	e47fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b78:	000a9797          	auipc	a5,0xa9
ffffffffc0201b7c:	0507b783          	ld	a5,80(a5) # ffffffffc02aabc8 <bigblocks>
        return 1;
ffffffffc0201b80:	4605                	li	a2,1
ffffffffc0201b82:	fbad                	bnez	a5,ffffffffc0201af4 <kfree+0x26>
        intr_enable();
ffffffffc0201b84:	e31fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201b88:	bff1                	j	ffffffffc0201b64 <kfree+0x96>
ffffffffc0201b8a:	e2bfe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201b8e:	b751                	j	ffffffffc0201b12 <kfree+0x44>
ffffffffc0201b90:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201b92:	00005617          	auipc	a2,0x5
ffffffffc0201b96:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0206600 <commands+0xb90>
ffffffffc0201b9a:	06900593          	li	a1,105
ffffffffc0201b9e:	00005517          	auipc	a0,0x5
ffffffffc0201ba2:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0206558 <commands+0xae8>
ffffffffc0201ba6:	e78fe0ef          	jal	ra,ffffffffc020021e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201baa:	86a2                	mv	a3,s0
ffffffffc0201bac:	00005617          	auipc	a2,0x5
ffffffffc0201bb0:	a2c60613          	addi	a2,a2,-1492 # ffffffffc02065d8 <commands+0xb68>
ffffffffc0201bb4:	07700593          	li	a1,119
ffffffffc0201bb8:	00005517          	auipc	a0,0x5
ffffffffc0201bbc:	9a050513          	addi	a0,a0,-1632 # ffffffffc0206558 <commands+0xae8>
ffffffffc0201bc0:	e5efe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0201bc4 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201bc4:	000a5797          	auipc	a5,0xa5
ffffffffc0201bc8:	fb478793          	addi	a5,a5,-76 # ffffffffc02a6b78 <free_area>
ffffffffc0201bcc:	e79c                	sd	a5,8(a5)
ffffffffc0201bce:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201bd0:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201bd4:	8082                	ret

ffffffffc0201bd6 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201bd6:	000a5517          	auipc	a0,0xa5
ffffffffc0201bda:	fb256503          	lwu	a0,-78(a0) # ffffffffc02a6b88 <free_area+0x10>
ffffffffc0201bde:	8082                	ret

ffffffffc0201be0 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201be0:	715d                	addi	sp,sp,-80
ffffffffc0201be2:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201be4:	000a5417          	auipc	s0,0xa5
ffffffffc0201be8:	f9440413          	addi	s0,s0,-108 # ffffffffc02a6b78 <free_area>
ffffffffc0201bec:	641c                	ld	a5,8(s0)
ffffffffc0201bee:	e486                	sd	ra,72(sp)
ffffffffc0201bf0:	fc26                	sd	s1,56(sp)
ffffffffc0201bf2:	f84a                	sd	s2,48(sp)
ffffffffc0201bf4:	f44e                	sd	s3,40(sp)
ffffffffc0201bf6:	f052                	sd	s4,32(sp)
ffffffffc0201bf8:	ec56                	sd	s5,24(sp)
ffffffffc0201bfa:	e85a                	sd	s6,16(sp)
ffffffffc0201bfc:	e45e                	sd	s7,8(sp)
ffffffffc0201bfe:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201c00:	2a878d63          	beq	a5,s0,ffffffffc0201eba <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0201c04:	4481                	li	s1,0
ffffffffc0201c06:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201c08:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201c0c:	8b09                	andi	a4,a4,2
ffffffffc0201c0e:	2a070a63          	beqz	a4,ffffffffc0201ec2 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201c12:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201c16:	679c                	ld	a5,8(a5)
ffffffffc0201c18:	2905                	addiw	s2,s2,1
ffffffffc0201c1a:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201c1c:	fe8796e3          	bne	a5,s0,ffffffffc0201c08 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201c20:	89a6                	mv	s3,s1
ffffffffc0201c22:	307000ef          	jal	ra,ffffffffc0202728 <nr_free_pages>
ffffffffc0201c26:	6f351e63          	bne	a0,s3,ffffffffc0202322 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201c2a:	4505                	li	a0,1
ffffffffc0201c2c:	27f000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201c30:	8aaa                	mv	s5,a0
ffffffffc0201c32:	42050863          	beqz	a0,ffffffffc0202062 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201c36:	4505                	li	a0,1
ffffffffc0201c38:	273000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201c3c:	89aa                	mv	s3,a0
ffffffffc0201c3e:	70050263          	beqz	a0,ffffffffc0202342 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201c42:	4505                	li	a0,1
ffffffffc0201c44:	267000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201c48:	8a2a                	mv	s4,a0
ffffffffc0201c4a:	48050c63          	beqz	a0,ffffffffc02020e2 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201c4e:	293a8a63          	beq	s5,s3,ffffffffc0201ee2 <default_check+0x302>
ffffffffc0201c52:	28aa8863          	beq	s5,a0,ffffffffc0201ee2 <default_check+0x302>
ffffffffc0201c56:	28a98663          	beq	s3,a0,ffffffffc0201ee2 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201c5a:	000aa783          	lw	a5,0(s5)
ffffffffc0201c5e:	2a079263          	bnez	a5,ffffffffc0201f02 <default_check+0x322>
ffffffffc0201c62:	0009a783          	lw	a5,0(s3)
ffffffffc0201c66:	28079e63          	bnez	a5,ffffffffc0201f02 <default_check+0x322>
ffffffffc0201c6a:	411c                	lw	a5,0(a0)
ffffffffc0201c6c:	28079b63          	bnez	a5,ffffffffc0201f02 <default_check+0x322>
    return page - pages + nbase;
ffffffffc0201c70:	000a9797          	auipc	a5,0xa9
ffffffffc0201c74:	f787b783          	ld	a5,-136(a5) # ffffffffc02aabe8 <pages>
ffffffffc0201c78:	40fa8733          	sub	a4,s5,a5
ffffffffc0201c7c:	00006617          	auipc	a2,0x6
ffffffffc0201c80:	d0463603          	ld	a2,-764(a2) # ffffffffc0207980 <nbase>
ffffffffc0201c84:	8719                	srai	a4,a4,0x6
ffffffffc0201c86:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201c88:	000a9697          	auipc	a3,0xa9
ffffffffc0201c8c:	f586b683          	ld	a3,-168(a3) # ffffffffc02aabe0 <npage>
ffffffffc0201c90:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c92:	0732                	slli	a4,a4,0xc
ffffffffc0201c94:	28d77763          	bgeu	a4,a3,ffffffffc0201f22 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0201c98:	40f98733          	sub	a4,s3,a5
ffffffffc0201c9c:	8719                	srai	a4,a4,0x6
ffffffffc0201c9e:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ca0:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201ca2:	4cd77063          	bgeu	a4,a3,ffffffffc0202162 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201ca6:	40f507b3          	sub	a5,a0,a5
ffffffffc0201caa:	8799                	srai	a5,a5,0x6
ffffffffc0201cac:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201cae:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201cb0:	30d7f963          	bgeu	a5,a3,ffffffffc0201fc2 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201cb4:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201cb6:	00043c03          	ld	s8,0(s0)
ffffffffc0201cba:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201cbe:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201cc2:	e400                	sd	s0,8(s0)
ffffffffc0201cc4:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201cc6:	000a5797          	auipc	a5,0xa5
ffffffffc0201cca:	ec07a123          	sw	zero,-318(a5) # ffffffffc02a6b88 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201cce:	1dd000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201cd2:	2c051863          	bnez	a0,ffffffffc0201fa2 <default_check+0x3c2>
    free_page(p0);
ffffffffc0201cd6:	4585                	li	a1,1
ffffffffc0201cd8:	8556                	mv	a0,s5
ffffffffc0201cda:	20f000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    free_page(p1);
ffffffffc0201cde:	4585                	li	a1,1
ffffffffc0201ce0:	854e                	mv	a0,s3
ffffffffc0201ce2:	207000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    free_page(p2);
ffffffffc0201ce6:	4585                	li	a1,1
ffffffffc0201ce8:	8552                	mv	a0,s4
ffffffffc0201cea:	1ff000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    assert(nr_free == 3);
ffffffffc0201cee:	4818                	lw	a4,16(s0)
ffffffffc0201cf0:	478d                	li	a5,3
ffffffffc0201cf2:	28f71863          	bne	a4,a5,ffffffffc0201f82 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201cf6:	4505                	li	a0,1
ffffffffc0201cf8:	1b3000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201cfc:	89aa                	mv	s3,a0
ffffffffc0201cfe:	26050263          	beqz	a0,ffffffffc0201f62 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201d02:	4505                	li	a0,1
ffffffffc0201d04:	1a7000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d08:	8aaa                	mv	s5,a0
ffffffffc0201d0a:	3a050c63          	beqz	a0,ffffffffc02020c2 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201d0e:	4505                	li	a0,1
ffffffffc0201d10:	19b000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d14:	8a2a                	mv	s4,a0
ffffffffc0201d16:	38050663          	beqz	a0,ffffffffc02020a2 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201d1a:	4505                	li	a0,1
ffffffffc0201d1c:	18f000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d20:	36051163          	bnez	a0,ffffffffc0202082 <default_check+0x4a2>
    free_page(p0);
ffffffffc0201d24:	4585                	li	a1,1
ffffffffc0201d26:	854e                	mv	a0,s3
ffffffffc0201d28:	1c1000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201d2c:	641c                	ld	a5,8(s0)
ffffffffc0201d2e:	20878a63          	beq	a5,s0,ffffffffc0201f42 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201d32:	4505                	li	a0,1
ffffffffc0201d34:	177000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d38:	30a99563          	bne	s3,a0,ffffffffc0202042 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201d3c:	4505                	li	a0,1
ffffffffc0201d3e:	16d000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d42:	2e051063          	bnez	a0,ffffffffc0202022 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0201d46:	481c                	lw	a5,16(s0)
ffffffffc0201d48:	2a079d63          	bnez	a5,ffffffffc0202002 <default_check+0x422>
    free_page(p);
ffffffffc0201d4c:	854e                	mv	a0,s3
ffffffffc0201d4e:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201d50:	01843023          	sd	s8,0(s0)
ffffffffc0201d54:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201d58:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201d5c:	18d000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    free_page(p1);
ffffffffc0201d60:	4585                	li	a1,1
ffffffffc0201d62:	8556                	mv	a0,s5
ffffffffc0201d64:	185000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    free_page(p2);
ffffffffc0201d68:	4585                	li	a1,1
ffffffffc0201d6a:	8552                	mv	a0,s4
ffffffffc0201d6c:	17d000ef          	jal	ra,ffffffffc02026e8 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201d70:	4515                	li	a0,5
ffffffffc0201d72:	139000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d76:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201d78:	26050563          	beqz	a0,ffffffffc0201fe2 <default_check+0x402>
ffffffffc0201d7c:	651c                	ld	a5,8(a0)
ffffffffc0201d7e:	8385                	srli	a5,a5,0x1
ffffffffc0201d80:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201d82:	54079063          	bnez	a5,ffffffffc02022c2 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201d86:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201d88:	00043b03          	ld	s6,0(s0)
ffffffffc0201d8c:	00843a83          	ld	s5,8(s0)
ffffffffc0201d90:	e000                	sd	s0,0(s0)
ffffffffc0201d92:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201d94:	117000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201d98:	50051563          	bnez	a0,ffffffffc02022a2 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201d9c:	08098a13          	addi	s4,s3,128
ffffffffc0201da0:	8552                	mv	a0,s4
ffffffffc0201da2:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201da4:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201da8:	000a5797          	auipc	a5,0xa5
ffffffffc0201dac:	de07a023          	sw	zero,-544(a5) # ffffffffc02a6b88 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201db0:	139000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201db4:	4511                	li	a0,4
ffffffffc0201db6:	0f5000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201dba:	4c051463          	bnez	a0,ffffffffc0202282 <default_check+0x6a2>
ffffffffc0201dbe:	0889b783          	ld	a5,136(s3)
ffffffffc0201dc2:	8385                	srli	a5,a5,0x1
ffffffffc0201dc4:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201dc6:	48078e63          	beqz	a5,ffffffffc0202262 <default_check+0x682>
ffffffffc0201dca:	0909a703          	lw	a4,144(s3)
ffffffffc0201dce:	478d                	li	a5,3
ffffffffc0201dd0:	48f71963          	bne	a4,a5,ffffffffc0202262 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201dd4:	450d                	li	a0,3
ffffffffc0201dd6:	0d5000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201dda:	8c2a                	mv	s8,a0
ffffffffc0201ddc:	46050363          	beqz	a0,ffffffffc0202242 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201de0:	4505                	li	a0,1
ffffffffc0201de2:	0c9000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201de6:	42051e63          	bnez	a0,ffffffffc0202222 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201dea:	418a1c63          	bne	s4,s8,ffffffffc0202202 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201dee:	4585                	li	a1,1
ffffffffc0201df0:	854e                	mv	a0,s3
ffffffffc0201df2:	0f7000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    free_pages(p1, 3);
ffffffffc0201df6:	458d                	li	a1,3
ffffffffc0201df8:	8552                	mv	a0,s4
ffffffffc0201dfa:	0ef000ef          	jal	ra,ffffffffc02026e8 <free_pages>
ffffffffc0201dfe:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201e02:	04098c13          	addi	s8,s3,64
ffffffffc0201e06:	8385                	srli	a5,a5,0x1
ffffffffc0201e08:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201e0a:	3c078c63          	beqz	a5,ffffffffc02021e2 <default_check+0x602>
ffffffffc0201e0e:	0109a703          	lw	a4,16(s3)
ffffffffc0201e12:	4785                	li	a5,1
ffffffffc0201e14:	3cf71763          	bne	a4,a5,ffffffffc02021e2 <default_check+0x602>
ffffffffc0201e18:	008a3783          	ld	a5,8(s4) # 1008 <_binary_obj___user_faultread_out_size-0x8bf8>
ffffffffc0201e1c:	8385                	srli	a5,a5,0x1
ffffffffc0201e1e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201e20:	3a078163          	beqz	a5,ffffffffc02021c2 <default_check+0x5e2>
ffffffffc0201e24:	010a2703          	lw	a4,16(s4)
ffffffffc0201e28:	478d                	li	a5,3
ffffffffc0201e2a:	38f71c63          	bne	a4,a5,ffffffffc02021c2 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201e2e:	4505                	li	a0,1
ffffffffc0201e30:	07b000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201e34:	36a99763          	bne	s3,a0,ffffffffc02021a2 <default_check+0x5c2>
    free_page(p0);
ffffffffc0201e38:	4585                	li	a1,1
ffffffffc0201e3a:	0af000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201e3e:	4509                	li	a0,2
ffffffffc0201e40:	06b000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201e44:	32aa1f63          	bne	s4,a0,ffffffffc0202182 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0201e48:	4589                	li	a1,2
ffffffffc0201e4a:	09f000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    free_page(p2);
ffffffffc0201e4e:	4585                	li	a1,1
ffffffffc0201e50:	8562                	mv	a0,s8
ffffffffc0201e52:	097000ef          	jal	ra,ffffffffc02026e8 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201e56:	4515                	li	a0,5
ffffffffc0201e58:	053000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201e5c:	89aa                	mv	s3,a0
ffffffffc0201e5e:	48050263          	beqz	a0,ffffffffc02022e2 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201e62:	4505                	li	a0,1
ffffffffc0201e64:	047000ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0201e68:	2c051d63          	bnez	a0,ffffffffc0202142 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201e6c:	481c                	lw	a5,16(s0)
ffffffffc0201e6e:	2a079a63          	bnez	a5,ffffffffc0202122 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201e72:	4595                	li	a1,5
ffffffffc0201e74:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201e76:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201e7a:	01643023          	sd	s6,0(s0)
ffffffffc0201e7e:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201e82:	067000ef          	jal	ra,ffffffffc02026e8 <free_pages>
    return listelm->next;
ffffffffc0201e86:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201e88:	00878963          	beq	a5,s0,ffffffffc0201e9a <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc0201e8c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201e90:	679c                	ld	a5,8(a5)
ffffffffc0201e92:	397d                	addiw	s2,s2,-1
ffffffffc0201e94:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201e96:	fe879be3          	bne	a5,s0,ffffffffc0201e8c <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201e9a:	26091463          	bnez	s2,ffffffffc0202102 <default_check+0x522>
    assert(total == 0);
ffffffffc0201e9e:	46049263          	bnez	s1,ffffffffc0202302 <default_check+0x722>
}
ffffffffc0201ea2:	60a6                	ld	ra,72(sp)
ffffffffc0201ea4:	6406                	ld	s0,64(sp)
ffffffffc0201ea6:	74e2                	ld	s1,56(sp)
ffffffffc0201ea8:	7942                	ld	s2,48(sp)
ffffffffc0201eaa:	79a2                	ld	s3,40(sp)
ffffffffc0201eac:	7a02                	ld	s4,32(sp)
ffffffffc0201eae:	6ae2                	ld	s5,24(sp)
ffffffffc0201eb0:	6b42                	ld	s6,16(sp)
ffffffffc0201eb2:	6ba2                	ld	s7,8(sp)
ffffffffc0201eb4:	6c02                	ld	s8,0(sp)
ffffffffc0201eb6:	6161                	addi	sp,sp,80
ffffffffc0201eb8:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc0201eba:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201ebc:	4481                	li	s1,0
ffffffffc0201ebe:	4901                	li	s2,0
ffffffffc0201ec0:	b38d                	j	ffffffffc0201c22 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201ec2:	00004697          	auipc	a3,0x4
ffffffffc0201ec6:	75e68693          	addi	a3,a3,1886 # ffffffffc0206620 <commands+0xbb0>
ffffffffc0201eca:	00004617          	auipc	a2,0x4
ffffffffc0201ece:	3ee60613          	addi	a2,a2,1006 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201ed2:	11000593          	li	a1,272
ffffffffc0201ed6:	00004517          	auipc	a0,0x4
ffffffffc0201eda:	75a50513          	addi	a0,a0,1882 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201ede:	b40fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201ee2:	00004697          	auipc	a3,0x4
ffffffffc0201ee6:	7e668693          	addi	a3,a3,2022 # ffffffffc02066c8 <commands+0xc58>
ffffffffc0201eea:	00004617          	auipc	a2,0x4
ffffffffc0201eee:	3ce60613          	addi	a2,a2,974 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201ef2:	0db00593          	li	a1,219
ffffffffc0201ef6:	00004517          	auipc	a0,0x4
ffffffffc0201efa:	73a50513          	addi	a0,a0,1850 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201efe:	b20fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201f02:	00004697          	auipc	a3,0x4
ffffffffc0201f06:	7ee68693          	addi	a3,a3,2030 # ffffffffc02066f0 <commands+0xc80>
ffffffffc0201f0a:	00004617          	auipc	a2,0x4
ffffffffc0201f0e:	3ae60613          	addi	a2,a2,942 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201f12:	0dc00593          	li	a1,220
ffffffffc0201f16:	00004517          	auipc	a0,0x4
ffffffffc0201f1a:	71a50513          	addi	a0,a0,1818 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201f1e:	b00fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201f22:	00005697          	auipc	a3,0x5
ffffffffc0201f26:	80e68693          	addi	a3,a3,-2034 # ffffffffc0206730 <commands+0xcc0>
ffffffffc0201f2a:	00004617          	auipc	a2,0x4
ffffffffc0201f2e:	38e60613          	addi	a2,a2,910 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201f32:	0de00593          	li	a1,222
ffffffffc0201f36:	00004517          	auipc	a0,0x4
ffffffffc0201f3a:	6fa50513          	addi	a0,a0,1786 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201f3e:	ae0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201f42:	00005697          	auipc	a3,0x5
ffffffffc0201f46:	87668693          	addi	a3,a3,-1930 # ffffffffc02067b8 <commands+0xd48>
ffffffffc0201f4a:	00004617          	auipc	a2,0x4
ffffffffc0201f4e:	36e60613          	addi	a2,a2,878 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201f52:	0f700593          	li	a1,247
ffffffffc0201f56:	00004517          	auipc	a0,0x4
ffffffffc0201f5a:	6da50513          	addi	a0,a0,1754 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201f5e:	ac0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201f62:	00004697          	auipc	a3,0x4
ffffffffc0201f66:	70668693          	addi	a3,a3,1798 # ffffffffc0206668 <commands+0xbf8>
ffffffffc0201f6a:	00004617          	auipc	a2,0x4
ffffffffc0201f6e:	34e60613          	addi	a2,a2,846 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201f72:	0f000593          	li	a1,240
ffffffffc0201f76:	00004517          	auipc	a0,0x4
ffffffffc0201f7a:	6ba50513          	addi	a0,a0,1722 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201f7e:	aa0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free == 3);
ffffffffc0201f82:	00005697          	auipc	a3,0x5
ffffffffc0201f86:	82668693          	addi	a3,a3,-2010 # ffffffffc02067a8 <commands+0xd38>
ffffffffc0201f8a:	00004617          	auipc	a2,0x4
ffffffffc0201f8e:	32e60613          	addi	a2,a2,814 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201f92:	0ee00593          	li	a1,238
ffffffffc0201f96:	00004517          	auipc	a0,0x4
ffffffffc0201f9a:	69a50513          	addi	a0,a0,1690 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201f9e:	a80fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201fa2:	00004697          	auipc	a3,0x4
ffffffffc0201fa6:	7ee68693          	addi	a3,a3,2030 # ffffffffc0206790 <commands+0xd20>
ffffffffc0201faa:	00004617          	auipc	a2,0x4
ffffffffc0201fae:	30e60613          	addi	a2,a2,782 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201fb2:	0e900593          	li	a1,233
ffffffffc0201fb6:	00004517          	auipc	a0,0x4
ffffffffc0201fba:	67a50513          	addi	a0,a0,1658 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201fbe:	a60fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201fc2:	00004697          	auipc	a3,0x4
ffffffffc0201fc6:	7ae68693          	addi	a3,a3,1966 # ffffffffc0206770 <commands+0xd00>
ffffffffc0201fca:	00004617          	auipc	a2,0x4
ffffffffc0201fce:	2ee60613          	addi	a2,a2,750 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201fd2:	0e000593          	li	a1,224
ffffffffc0201fd6:	00004517          	auipc	a0,0x4
ffffffffc0201fda:	65a50513          	addi	a0,a0,1626 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201fde:	a40fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(p0 != NULL);
ffffffffc0201fe2:	00005697          	auipc	a3,0x5
ffffffffc0201fe6:	81e68693          	addi	a3,a3,-2018 # ffffffffc0206800 <commands+0xd90>
ffffffffc0201fea:	00004617          	auipc	a2,0x4
ffffffffc0201fee:	2ce60613          	addi	a2,a2,718 # ffffffffc02062b8 <commands+0x848>
ffffffffc0201ff2:	11800593          	li	a1,280
ffffffffc0201ff6:	00004517          	auipc	a0,0x4
ffffffffc0201ffa:	63a50513          	addi	a0,a0,1594 # ffffffffc0206630 <commands+0xbc0>
ffffffffc0201ffe:	a20fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free == 0);
ffffffffc0202002:	00004697          	auipc	a3,0x4
ffffffffc0202006:	7ee68693          	addi	a3,a3,2030 # ffffffffc02067f0 <commands+0xd80>
ffffffffc020200a:	00004617          	auipc	a2,0x4
ffffffffc020200e:	2ae60613          	addi	a2,a2,686 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202012:	0fd00593          	li	a1,253
ffffffffc0202016:	00004517          	auipc	a0,0x4
ffffffffc020201a:	61a50513          	addi	a0,a0,1562 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020201e:	a00fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202022:	00004697          	auipc	a3,0x4
ffffffffc0202026:	76e68693          	addi	a3,a3,1902 # ffffffffc0206790 <commands+0xd20>
ffffffffc020202a:	00004617          	auipc	a2,0x4
ffffffffc020202e:	28e60613          	addi	a2,a2,654 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202032:	0fb00593          	li	a1,251
ffffffffc0202036:	00004517          	auipc	a0,0x4
ffffffffc020203a:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020203e:	9e0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0202042:	00004697          	auipc	a3,0x4
ffffffffc0202046:	78e68693          	addi	a3,a3,1934 # ffffffffc02067d0 <commands+0xd60>
ffffffffc020204a:	00004617          	auipc	a2,0x4
ffffffffc020204e:	26e60613          	addi	a2,a2,622 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202052:	0fa00593          	li	a1,250
ffffffffc0202056:	00004517          	auipc	a0,0x4
ffffffffc020205a:	5da50513          	addi	a0,a0,1498 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020205e:	9c0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0202062:	00004697          	auipc	a3,0x4
ffffffffc0202066:	60668693          	addi	a3,a3,1542 # ffffffffc0206668 <commands+0xbf8>
ffffffffc020206a:	00004617          	auipc	a2,0x4
ffffffffc020206e:	24e60613          	addi	a2,a2,590 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202072:	0d700593          	li	a1,215
ffffffffc0202076:	00004517          	auipc	a0,0x4
ffffffffc020207a:	5ba50513          	addi	a0,a0,1466 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020207e:	9a0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202082:	00004697          	auipc	a3,0x4
ffffffffc0202086:	70e68693          	addi	a3,a3,1806 # ffffffffc0206790 <commands+0xd20>
ffffffffc020208a:	00004617          	auipc	a2,0x4
ffffffffc020208e:	22e60613          	addi	a2,a2,558 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202092:	0f400593          	li	a1,244
ffffffffc0202096:	00004517          	auipc	a0,0x4
ffffffffc020209a:	59a50513          	addi	a0,a0,1434 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020209e:	980fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02020a2:	00004697          	auipc	a3,0x4
ffffffffc02020a6:	60668693          	addi	a3,a3,1542 # ffffffffc02066a8 <commands+0xc38>
ffffffffc02020aa:	00004617          	auipc	a2,0x4
ffffffffc02020ae:	20e60613          	addi	a2,a2,526 # ffffffffc02062b8 <commands+0x848>
ffffffffc02020b2:	0f200593          	li	a1,242
ffffffffc02020b6:	00004517          	auipc	a0,0x4
ffffffffc02020ba:	57a50513          	addi	a0,a0,1402 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02020be:	960fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02020c2:	00004697          	auipc	a3,0x4
ffffffffc02020c6:	5c668693          	addi	a3,a3,1478 # ffffffffc0206688 <commands+0xc18>
ffffffffc02020ca:	00004617          	auipc	a2,0x4
ffffffffc02020ce:	1ee60613          	addi	a2,a2,494 # ffffffffc02062b8 <commands+0x848>
ffffffffc02020d2:	0f100593          	li	a1,241
ffffffffc02020d6:	00004517          	auipc	a0,0x4
ffffffffc02020da:	55a50513          	addi	a0,a0,1370 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02020de:	940fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02020e2:	00004697          	auipc	a3,0x4
ffffffffc02020e6:	5c668693          	addi	a3,a3,1478 # ffffffffc02066a8 <commands+0xc38>
ffffffffc02020ea:	00004617          	auipc	a2,0x4
ffffffffc02020ee:	1ce60613          	addi	a2,a2,462 # ffffffffc02062b8 <commands+0x848>
ffffffffc02020f2:	0d900593          	li	a1,217
ffffffffc02020f6:	00004517          	auipc	a0,0x4
ffffffffc02020fa:	53a50513          	addi	a0,a0,1338 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02020fe:	920fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(count == 0);
ffffffffc0202102:	00005697          	auipc	a3,0x5
ffffffffc0202106:	84e68693          	addi	a3,a3,-1970 # ffffffffc0206950 <commands+0xee0>
ffffffffc020210a:	00004617          	auipc	a2,0x4
ffffffffc020210e:	1ae60613          	addi	a2,a2,430 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202112:	14600593          	li	a1,326
ffffffffc0202116:	00004517          	auipc	a0,0x4
ffffffffc020211a:	51a50513          	addi	a0,a0,1306 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020211e:	900fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free == 0);
ffffffffc0202122:	00004697          	auipc	a3,0x4
ffffffffc0202126:	6ce68693          	addi	a3,a3,1742 # ffffffffc02067f0 <commands+0xd80>
ffffffffc020212a:	00004617          	auipc	a2,0x4
ffffffffc020212e:	18e60613          	addi	a2,a2,398 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202132:	13a00593          	li	a1,314
ffffffffc0202136:	00004517          	auipc	a0,0x4
ffffffffc020213a:	4fa50513          	addi	a0,a0,1274 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020213e:	8e0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202142:	00004697          	auipc	a3,0x4
ffffffffc0202146:	64e68693          	addi	a3,a3,1614 # ffffffffc0206790 <commands+0xd20>
ffffffffc020214a:	00004617          	auipc	a2,0x4
ffffffffc020214e:	16e60613          	addi	a2,a2,366 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202152:	13800593          	li	a1,312
ffffffffc0202156:	00004517          	auipc	a0,0x4
ffffffffc020215a:	4da50513          	addi	a0,a0,1242 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020215e:	8c0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0202162:	00004697          	auipc	a3,0x4
ffffffffc0202166:	5ee68693          	addi	a3,a3,1518 # ffffffffc0206750 <commands+0xce0>
ffffffffc020216a:	00004617          	auipc	a2,0x4
ffffffffc020216e:	14e60613          	addi	a2,a2,334 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202172:	0df00593          	li	a1,223
ffffffffc0202176:	00004517          	auipc	a0,0x4
ffffffffc020217a:	4ba50513          	addi	a0,a0,1210 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020217e:	8a0fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0202182:	00004697          	auipc	a3,0x4
ffffffffc0202186:	78e68693          	addi	a3,a3,1934 # ffffffffc0206910 <commands+0xea0>
ffffffffc020218a:	00004617          	auipc	a2,0x4
ffffffffc020218e:	12e60613          	addi	a2,a2,302 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202192:	13200593          	li	a1,306
ffffffffc0202196:	00004517          	auipc	a0,0x4
ffffffffc020219a:	49a50513          	addi	a0,a0,1178 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020219e:	880fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02021a2:	00004697          	auipc	a3,0x4
ffffffffc02021a6:	74e68693          	addi	a3,a3,1870 # ffffffffc02068f0 <commands+0xe80>
ffffffffc02021aa:	00004617          	auipc	a2,0x4
ffffffffc02021ae:	10e60613          	addi	a2,a2,270 # ffffffffc02062b8 <commands+0x848>
ffffffffc02021b2:	13000593          	li	a1,304
ffffffffc02021b6:	00004517          	auipc	a0,0x4
ffffffffc02021ba:	47a50513          	addi	a0,a0,1146 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02021be:	860fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02021c2:	00004697          	auipc	a3,0x4
ffffffffc02021c6:	70668693          	addi	a3,a3,1798 # ffffffffc02068c8 <commands+0xe58>
ffffffffc02021ca:	00004617          	auipc	a2,0x4
ffffffffc02021ce:	0ee60613          	addi	a2,a2,238 # ffffffffc02062b8 <commands+0x848>
ffffffffc02021d2:	12e00593          	li	a1,302
ffffffffc02021d6:	00004517          	auipc	a0,0x4
ffffffffc02021da:	45a50513          	addi	a0,a0,1114 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02021de:	840fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02021e2:	00004697          	auipc	a3,0x4
ffffffffc02021e6:	6be68693          	addi	a3,a3,1726 # ffffffffc02068a0 <commands+0xe30>
ffffffffc02021ea:	00004617          	auipc	a2,0x4
ffffffffc02021ee:	0ce60613          	addi	a2,a2,206 # ffffffffc02062b8 <commands+0x848>
ffffffffc02021f2:	12d00593          	li	a1,301
ffffffffc02021f6:	00004517          	auipc	a0,0x4
ffffffffc02021fa:	43a50513          	addi	a0,a0,1082 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02021fe:	820fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(p0 + 2 == p1);
ffffffffc0202202:	00004697          	auipc	a3,0x4
ffffffffc0202206:	68e68693          	addi	a3,a3,1678 # ffffffffc0206890 <commands+0xe20>
ffffffffc020220a:	00004617          	auipc	a2,0x4
ffffffffc020220e:	0ae60613          	addi	a2,a2,174 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202212:	12800593          	li	a1,296
ffffffffc0202216:	00004517          	auipc	a0,0x4
ffffffffc020221a:	41a50513          	addi	a0,a0,1050 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020221e:	800fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202222:	00004697          	auipc	a3,0x4
ffffffffc0202226:	56e68693          	addi	a3,a3,1390 # ffffffffc0206790 <commands+0xd20>
ffffffffc020222a:	00004617          	auipc	a2,0x4
ffffffffc020222e:	08e60613          	addi	a2,a2,142 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202232:	12700593          	li	a1,295
ffffffffc0202236:	00004517          	auipc	a0,0x4
ffffffffc020223a:	3fa50513          	addi	a0,a0,1018 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020223e:	fe1fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0202242:	00004697          	auipc	a3,0x4
ffffffffc0202246:	62e68693          	addi	a3,a3,1582 # ffffffffc0206870 <commands+0xe00>
ffffffffc020224a:	00004617          	auipc	a2,0x4
ffffffffc020224e:	06e60613          	addi	a2,a2,110 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202252:	12600593          	li	a1,294
ffffffffc0202256:	00004517          	auipc	a0,0x4
ffffffffc020225a:	3da50513          	addi	a0,a0,986 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020225e:	fc1fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0202262:	00004697          	auipc	a3,0x4
ffffffffc0202266:	5de68693          	addi	a3,a3,1502 # ffffffffc0206840 <commands+0xdd0>
ffffffffc020226a:	00004617          	auipc	a2,0x4
ffffffffc020226e:	04e60613          	addi	a2,a2,78 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202272:	12500593          	li	a1,293
ffffffffc0202276:	00004517          	auipc	a0,0x4
ffffffffc020227a:	3ba50513          	addi	a0,a0,954 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020227e:	fa1fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0202282:	00004697          	auipc	a3,0x4
ffffffffc0202286:	5a668693          	addi	a3,a3,1446 # ffffffffc0206828 <commands+0xdb8>
ffffffffc020228a:	00004617          	auipc	a2,0x4
ffffffffc020228e:	02e60613          	addi	a2,a2,46 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202292:	12400593          	li	a1,292
ffffffffc0202296:	00004517          	auipc	a0,0x4
ffffffffc020229a:	39a50513          	addi	a0,a0,922 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020229e:	f81fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02022a2:	00004697          	auipc	a3,0x4
ffffffffc02022a6:	4ee68693          	addi	a3,a3,1262 # ffffffffc0206790 <commands+0xd20>
ffffffffc02022aa:	00004617          	auipc	a2,0x4
ffffffffc02022ae:	00e60613          	addi	a2,a2,14 # ffffffffc02062b8 <commands+0x848>
ffffffffc02022b2:	11e00593          	li	a1,286
ffffffffc02022b6:	00004517          	auipc	a0,0x4
ffffffffc02022ba:	37a50513          	addi	a0,a0,890 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02022be:	f61fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(!PageProperty(p0));
ffffffffc02022c2:	00004697          	auipc	a3,0x4
ffffffffc02022c6:	54e68693          	addi	a3,a3,1358 # ffffffffc0206810 <commands+0xda0>
ffffffffc02022ca:	00004617          	auipc	a2,0x4
ffffffffc02022ce:	fee60613          	addi	a2,a2,-18 # ffffffffc02062b8 <commands+0x848>
ffffffffc02022d2:	11900593          	li	a1,281
ffffffffc02022d6:	00004517          	auipc	a0,0x4
ffffffffc02022da:	35a50513          	addi	a0,a0,858 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02022de:	f41fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02022e2:	00004697          	auipc	a3,0x4
ffffffffc02022e6:	64e68693          	addi	a3,a3,1614 # ffffffffc0206930 <commands+0xec0>
ffffffffc02022ea:	00004617          	auipc	a2,0x4
ffffffffc02022ee:	fce60613          	addi	a2,a2,-50 # ffffffffc02062b8 <commands+0x848>
ffffffffc02022f2:	13700593          	li	a1,311
ffffffffc02022f6:	00004517          	auipc	a0,0x4
ffffffffc02022fa:	33a50513          	addi	a0,a0,826 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02022fe:	f21fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(total == 0);
ffffffffc0202302:	00004697          	auipc	a3,0x4
ffffffffc0202306:	65e68693          	addi	a3,a3,1630 # ffffffffc0206960 <commands+0xef0>
ffffffffc020230a:	00004617          	auipc	a2,0x4
ffffffffc020230e:	fae60613          	addi	a2,a2,-82 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202312:	14700593          	li	a1,327
ffffffffc0202316:	00004517          	auipc	a0,0x4
ffffffffc020231a:	31a50513          	addi	a0,a0,794 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020231e:	f01fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(total == nr_free_pages());
ffffffffc0202322:	00004697          	auipc	a3,0x4
ffffffffc0202326:	32668693          	addi	a3,a3,806 # ffffffffc0206648 <commands+0xbd8>
ffffffffc020232a:	00004617          	auipc	a2,0x4
ffffffffc020232e:	f8e60613          	addi	a2,a2,-114 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202332:	11300593          	li	a1,275
ffffffffc0202336:	00004517          	auipc	a0,0x4
ffffffffc020233a:	2fa50513          	addi	a0,a0,762 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020233e:	ee1fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202342:	00004697          	auipc	a3,0x4
ffffffffc0202346:	34668693          	addi	a3,a3,838 # ffffffffc0206688 <commands+0xc18>
ffffffffc020234a:	00004617          	auipc	a2,0x4
ffffffffc020234e:	f6e60613          	addi	a2,a2,-146 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202352:	0d800593          	li	a1,216
ffffffffc0202356:	00004517          	auipc	a0,0x4
ffffffffc020235a:	2da50513          	addi	a0,a0,730 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020235e:	ec1fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202362 <default_free_pages>:
{
ffffffffc0202362:	1141                	addi	sp,sp,-16
ffffffffc0202364:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202366:	14058463          	beqz	a1,ffffffffc02024ae <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc020236a:	00659693          	slli	a3,a1,0x6
ffffffffc020236e:	96aa                	add	a3,a3,a0
ffffffffc0202370:	87aa                	mv	a5,a0
ffffffffc0202372:	02d50263          	beq	a0,a3,ffffffffc0202396 <default_free_pages+0x34>
ffffffffc0202376:	6798                	ld	a4,8(a5)
ffffffffc0202378:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020237a:	10071a63          	bnez	a4,ffffffffc020248e <default_free_pages+0x12c>
ffffffffc020237e:	6798                	ld	a4,8(a5)
ffffffffc0202380:	8b09                	andi	a4,a4,2
ffffffffc0202382:	10071663          	bnez	a4,ffffffffc020248e <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0202386:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc020238a:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc020238e:	04078793          	addi	a5,a5,64
ffffffffc0202392:	fed792e3          	bne	a5,a3,ffffffffc0202376 <default_free_pages+0x14>
    base->property = n;
ffffffffc0202396:	2581                	sext.w	a1,a1
ffffffffc0202398:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020239a:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020239e:	4789                	li	a5,2
ffffffffc02023a0:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02023a4:	000a4697          	auipc	a3,0xa4
ffffffffc02023a8:	7d468693          	addi	a3,a3,2004 # ffffffffc02a6b78 <free_area>
ffffffffc02023ac:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02023ae:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02023b0:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02023b4:	9db9                	addw	a1,a1,a4
ffffffffc02023b6:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02023b8:	0ad78463          	beq	a5,a3,ffffffffc0202460 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02023bc:	fe878713          	addi	a4,a5,-24
ffffffffc02023c0:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02023c4:	4581                	li	a1,0
            if (base < page)
ffffffffc02023c6:	00e56a63          	bltu	a0,a4,ffffffffc02023da <default_free_pages+0x78>
    return listelm->next;
ffffffffc02023ca:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02023cc:	04d70c63          	beq	a4,a3,ffffffffc0202424 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02023d0:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02023d2:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02023d6:	fee57ae3          	bgeu	a0,a4,ffffffffc02023ca <default_free_pages+0x68>
ffffffffc02023da:	c199                	beqz	a1,ffffffffc02023e0 <default_free_pages+0x7e>
ffffffffc02023dc:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02023e0:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02023e2:	e390                	sd	a2,0(a5)
ffffffffc02023e4:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02023e6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02023e8:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc02023ea:	00d70d63          	beq	a4,a3,ffffffffc0202404 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02023ee:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_obj___user_faultread_out_size-0x8c08>
        p = le2page(le, page_link);
ffffffffc02023f2:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02023f6:	02059813          	slli	a6,a1,0x20
ffffffffc02023fa:	01a85793          	srli	a5,a6,0x1a
ffffffffc02023fe:	97b2                	add	a5,a5,a2
ffffffffc0202400:	02f50c63          	beq	a0,a5,ffffffffc0202438 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0202404:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0202406:	00d78c63          	beq	a5,a3,ffffffffc020241e <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020240a:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020240c:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0202410:	02061593          	slli	a1,a2,0x20
ffffffffc0202414:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0202418:	972a                	add	a4,a4,a0
ffffffffc020241a:	04e68a63          	beq	a3,a4,ffffffffc020246e <default_free_pages+0x10c>
}
ffffffffc020241e:	60a2                	ld	ra,8(sp)
ffffffffc0202420:	0141                	addi	sp,sp,16
ffffffffc0202422:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202424:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202426:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0202428:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020242a:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc020242c:	02d70763          	beq	a4,a3,ffffffffc020245a <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0202430:	8832                	mv	a6,a2
ffffffffc0202432:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0202434:	87ba                	mv	a5,a4
ffffffffc0202436:	bf71                	j	ffffffffc02023d2 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0202438:	491c                	lw	a5,16(a0)
ffffffffc020243a:	9dbd                	addw	a1,a1,a5
ffffffffc020243c:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202440:	57f5                	li	a5,-3
ffffffffc0202442:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202446:	01853803          	ld	a6,24(a0)
ffffffffc020244a:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020244c:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc020244e:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0202452:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0202454:	0105b023          	sd	a6,0(a1) # 1000 <_binary_obj___user_faultread_out_size-0x8c00>
ffffffffc0202458:	b77d                	j	ffffffffc0202406 <default_free_pages+0xa4>
ffffffffc020245a:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc020245c:	873e                	mv	a4,a5
ffffffffc020245e:	bf41                	j	ffffffffc02023ee <default_free_pages+0x8c>
}
ffffffffc0202460:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202462:	e390                	sd	a2,0(a5)
ffffffffc0202464:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202466:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202468:	ed1c                	sd	a5,24(a0)
ffffffffc020246a:	0141                	addi	sp,sp,16
ffffffffc020246c:	8082                	ret
            base->property += p->property;
ffffffffc020246e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202472:	ff078693          	addi	a3,a5,-16
ffffffffc0202476:	9e39                	addw	a2,a2,a4
ffffffffc0202478:	c910                	sw	a2,16(a0)
ffffffffc020247a:	5775                	li	a4,-3
ffffffffc020247c:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202480:	6398                	ld	a4,0(a5)
ffffffffc0202482:	679c                	ld	a5,8(a5)
}
ffffffffc0202484:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0202486:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202488:	e398                	sd	a4,0(a5)
ffffffffc020248a:	0141                	addi	sp,sp,16
ffffffffc020248c:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020248e:	00004697          	auipc	a3,0x4
ffffffffc0202492:	4ea68693          	addi	a3,a3,1258 # ffffffffc0206978 <commands+0xf08>
ffffffffc0202496:	00004617          	auipc	a2,0x4
ffffffffc020249a:	e2260613          	addi	a2,a2,-478 # ffffffffc02062b8 <commands+0x848>
ffffffffc020249e:	09400593          	li	a1,148
ffffffffc02024a2:	00004517          	auipc	a0,0x4
ffffffffc02024a6:	18e50513          	addi	a0,a0,398 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02024aa:	d75fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(n > 0);
ffffffffc02024ae:	00004697          	auipc	a3,0x4
ffffffffc02024b2:	4c268693          	addi	a3,a3,1218 # ffffffffc0206970 <commands+0xf00>
ffffffffc02024b6:	00004617          	auipc	a2,0x4
ffffffffc02024ba:	e0260613          	addi	a2,a2,-510 # ffffffffc02062b8 <commands+0x848>
ffffffffc02024be:	09000593          	li	a1,144
ffffffffc02024c2:	00004517          	auipc	a0,0x4
ffffffffc02024c6:	16e50513          	addi	a0,a0,366 # ffffffffc0206630 <commands+0xbc0>
ffffffffc02024ca:	d55fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02024ce <default_alloc_pages>:
    assert(n > 0);
ffffffffc02024ce:	c941                	beqz	a0,ffffffffc020255e <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02024d0:	000a4597          	auipc	a1,0xa4
ffffffffc02024d4:	6a858593          	addi	a1,a1,1704 # ffffffffc02a6b78 <free_area>
ffffffffc02024d8:	0105a803          	lw	a6,16(a1)
ffffffffc02024dc:	872a                	mv	a4,a0
ffffffffc02024de:	02081793          	slli	a5,a6,0x20
ffffffffc02024e2:	9381                	srli	a5,a5,0x20
ffffffffc02024e4:	00a7ee63          	bltu	a5,a0,ffffffffc0202500 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02024e8:	87ae                	mv	a5,a1
ffffffffc02024ea:	a801                	j	ffffffffc02024fa <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc02024ec:	ff87a683          	lw	a3,-8(a5)
ffffffffc02024f0:	02069613          	slli	a2,a3,0x20
ffffffffc02024f4:	9201                	srli	a2,a2,0x20
ffffffffc02024f6:	00e67763          	bgeu	a2,a4,ffffffffc0202504 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02024fa:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc02024fc:	feb798e3          	bne	a5,a1,ffffffffc02024ec <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0202500:	4501                	li	a0,0
}
ffffffffc0202502:	8082                	ret
    return listelm->prev;
ffffffffc0202504:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202508:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc020250c:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0202510:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0202514:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0202518:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc020251c:	02c77863          	bgeu	a4,a2,ffffffffc020254c <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0202520:	071a                	slli	a4,a4,0x6
ffffffffc0202522:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0202524:	41c686bb          	subw	a3,a3,t3
ffffffffc0202528:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020252a:	00870613          	addi	a2,a4,8
ffffffffc020252e:	4689                	li	a3,2
ffffffffc0202530:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202534:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0202538:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc020253c:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0202540:	e290                	sd	a2,0(a3)
ffffffffc0202542:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0202546:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0202548:	01173c23          	sd	a7,24(a4)
ffffffffc020254c:	41c8083b          	subw	a6,a6,t3
ffffffffc0202550:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202554:	5775                	li	a4,-3
ffffffffc0202556:	17c1                	addi	a5,a5,-16
ffffffffc0202558:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020255c:	8082                	ret
{
ffffffffc020255e:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0202560:	00004697          	auipc	a3,0x4
ffffffffc0202564:	41068693          	addi	a3,a3,1040 # ffffffffc0206970 <commands+0xf00>
ffffffffc0202568:	00004617          	auipc	a2,0x4
ffffffffc020256c:	d5060613          	addi	a2,a2,-688 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202570:	06c00593          	li	a1,108
ffffffffc0202574:	00004517          	auipc	a0,0x4
ffffffffc0202578:	0bc50513          	addi	a0,a0,188 # ffffffffc0206630 <commands+0xbc0>
{
ffffffffc020257c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020257e:	ca1fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202582 <default_init_memmap>:
{
ffffffffc0202582:	1141                	addi	sp,sp,-16
ffffffffc0202584:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202586:	c5f1                	beqz	a1,ffffffffc0202652 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0202588:	00659693          	slli	a3,a1,0x6
ffffffffc020258c:	96aa                	add	a3,a3,a0
ffffffffc020258e:	87aa                	mv	a5,a0
ffffffffc0202590:	00d50f63          	beq	a0,a3,ffffffffc02025ae <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0202594:	6798                	ld	a4,8(a5)
ffffffffc0202596:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0202598:	cf49                	beqz	a4,ffffffffc0202632 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc020259a:	0007a823          	sw	zero,16(a5)
ffffffffc020259e:	0007b423          	sd	zero,8(a5)
ffffffffc02025a2:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02025a6:	04078793          	addi	a5,a5,64
ffffffffc02025aa:	fed795e3          	bne	a5,a3,ffffffffc0202594 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02025ae:	2581                	sext.w	a1,a1
ffffffffc02025b0:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02025b2:	4789                	li	a5,2
ffffffffc02025b4:	00850713          	addi	a4,a0,8
ffffffffc02025b8:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02025bc:	000a4697          	auipc	a3,0xa4
ffffffffc02025c0:	5bc68693          	addi	a3,a3,1468 # ffffffffc02a6b78 <free_area>
ffffffffc02025c4:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02025c6:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02025c8:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02025cc:	9db9                	addw	a1,a1,a4
ffffffffc02025ce:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02025d0:	04d78a63          	beq	a5,a3,ffffffffc0202624 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02025d4:	fe878713          	addi	a4,a5,-24
ffffffffc02025d8:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02025dc:	4581                	li	a1,0
            if (base < page)
ffffffffc02025de:	00e56a63          	bltu	a0,a4,ffffffffc02025f2 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02025e2:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02025e4:	02d70263          	beq	a4,a3,ffffffffc0202608 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc02025e8:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02025ea:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02025ee:	fee57ae3          	bgeu	a0,a4,ffffffffc02025e2 <default_init_memmap+0x60>
ffffffffc02025f2:	c199                	beqz	a1,ffffffffc02025f8 <default_init_memmap+0x76>
ffffffffc02025f4:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02025f8:	6398                	ld	a4,0(a5)
}
ffffffffc02025fa:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02025fc:	e390                	sd	a2,0(a5)
ffffffffc02025fe:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202600:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202602:	ed18                	sd	a4,24(a0)
ffffffffc0202604:	0141                	addi	sp,sp,16
ffffffffc0202606:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202608:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020260a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020260c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020260e:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0202610:	00d70663          	beq	a4,a3,ffffffffc020261c <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0202614:	8832                	mv	a6,a2
ffffffffc0202616:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0202618:	87ba                	mv	a5,a4
ffffffffc020261a:	bfc1                	j	ffffffffc02025ea <default_init_memmap+0x68>
}
ffffffffc020261c:	60a2                	ld	ra,8(sp)
ffffffffc020261e:	e290                	sd	a2,0(a3)
ffffffffc0202620:	0141                	addi	sp,sp,16
ffffffffc0202622:	8082                	ret
ffffffffc0202624:	60a2                	ld	ra,8(sp)
ffffffffc0202626:	e390                	sd	a2,0(a5)
ffffffffc0202628:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020262a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020262c:	ed1c                	sd	a5,24(a0)
ffffffffc020262e:	0141                	addi	sp,sp,16
ffffffffc0202630:	8082                	ret
        assert(PageReserved(p));
ffffffffc0202632:	00004697          	auipc	a3,0x4
ffffffffc0202636:	36e68693          	addi	a3,a3,878 # ffffffffc02069a0 <commands+0xf30>
ffffffffc020263a:	00004617          	auipc	a2,0x4
ffffffffc020263e:	c7e60613          	addi	a2,a2,-898 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202642:	04b00593          	li	a1,75
ffffffffc0202646:	00004517          	auipc	a0,0x4
ffffffffc020264a:	fea50513          	addi	a0,a0,-22 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020264e:	bd1fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(n > 0);
ffffffffc0202652:	00004697          	auipc	a3,0x4
ffffffffc0202656:	31e68693          	addi	a3,a3,798 # ffffffffc0206970 <commands+0xf00>
ffffffffc020265a:	00004617          	auipc	a2,0x4
ffffffffc020265e:	c5e60613          	addi	a2,a2,-930 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202662:	04700593          	li	a1,71
ffffffffc0202666:	00004517          	auipc	a0,0x4
ffffffffc020266a:	fca50513          	addi	a0,a0,-54 # ffffffffc0206630 <commands+0xbc0>
ffffffffc020266e:	bb1fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202672 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0202672:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202674:	00004617          	auipc	a2,0x4
ffffffffc0202678:	f8c60613          	addi	a2,a2,-116 # ffffffffc0206600 <commands+0xb90>
ffffffffc020267c:	06900593          	li	a1,105
ffffffffc0202680:	00004517          	auipc	a0,0x4
ffffffffc0202684:	ed850513          	addi	a0,a0,-296 # ffffffffc0206558 <commands+0xae8>
pa2page(uintptr_t pa)
ffffffffc0202688:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc020268a:	b95fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020268e <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc020268e:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0202690:	00004617          	auipc	a2,0x4
ffffffffc0202694:	37060613          	addi	a2,a2,880 # ffffffffc0206a00 <default_pmm_manager+0x38>
ffffffffc0202698:	07f00593          	li	a1,127
ffffffffc020269c:	00004517          	auipc	a0,0x4
ffffffffc02026a0:	ebc50513          	addi	a0,a0,-324 # ffffffffc0206558 <commands+0xae8>
pte2page(pte_t pte)
ffffffffc02026a4:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc02026a6:	b79fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02026aa <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026aa:	100027f3          	csrr	a5,sstatus
ffffffffc02026ae:	8b89                	andi	a5,a5,2
ffffffffc02026b0:	e799                	bnez	a5,ffffffffc02026be <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02026b2:	000a8797          	auipc	a5,0xa8
ffffffffc02026b6:	53e7b783          	ld	a5,1342(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc02026ba:	6f9c                	ld	a5,24(a5)
ffffffffc02026bc:	8782                	jr	a5
{
ffffffffc02026be:	1141                	addi	sp,sp,-16
ffffffffc02026c0:	e406                	sd	ra,8(sp)
ffffffffc02026c2:	e022                	sd	s0,0(sp)
ffffffffc02026c4:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02026c6:	af4fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02026ca:	000a8797          	auipc	a5,0xa8
ffffffffc02026ce:	5267b783          	ld	a5,1318(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc02026d2:	6f9c                	ld	a5,24(a5)
ffffffffc02026d4:	8522                	mv	a0,s0
ffffffffc02026d6:	9782                	jalr	a5
ffffffffc02026d8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02026da:	adafe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02026de:	60a2                	ld	ra,8(sp)
ffffffffc02026e0:	8522                	mv	a0,s0
ffffffffc02026e2:	6402                	ld	s0,0(sp)
ffffffffc02026e4:	0141                	addi	sp,sp,16
ffffffffc02026e6:	8082                	ret

ffffffffc02026e8 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026e8:	100027f3          	csrr	a5,sstatus
ffffffffc02026ec:	8b89                	andi	a5,a5,2
ffffffffc02026ee:	e799                	bnez	a5,ffffffffc02026fc <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02026f0:	000a8797          	auipc	a5,0xa8
ffffffffc02026f4:	5007b783          	ld	a5,1280(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc02026f8:	739c                	ld	a5,32(a5)
ffffffffc02026fa:	8782                	jr	a5
{
ffffffffc02026fc:	1101                	addi	sp,sp,-32
ffffffffc02026fe:	ec06                	sd	ra,24(sp)
ffffffffc0202700:	e822                	sd	s0,16(sp)
ffffffffc0202702:	e426                	sd	s1,8(sp)
ffffffffc0202704:	842a                	mv	s0,a0
ffffffffc0202706:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202708:	ab2fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020270c:	000a8797          	auipc	a5,0xa8
ffffffffc0202710:	4e47b783          	ld	a5,1252(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202714:	739c                	ld	a5,32(a5)
ffffffffc0202716:	85a6                	mv	a1,s1
ffffffffc0202718:	8522                	mv	a0,s0
ffffffffc020271a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc020271c:	6442                	ld	s0,16(sp)
ffffffffc020271e:	60e2                	ld	ra,24(sp)
ffffffffc0202720:	64a2                	ld	s1,8(sp)
ffffffffc0202722:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202724:	a90fe06f          	j	ffffffffc02009b4 <intr_enable>

ffffffffc0202728 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202728:	100027f3          	csrr	a5,sstatus
ffffffffc020272c:	8b89                	andi	a5,a5,2
ffffffffc020272e:	e799                	bnez	a5,ffffffffc020273c <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0202730:	000a8797          	auipc	a5,0xa8
ffffffffc0202734:	4c07b783          	ld	a5,1216(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202738:	779c                	ld	a5,40(a5)
ffffffffc020273a:	8782                	jr	a5
{
ffffffffc020273c:	1141                	addi	sp,sp,-16
ffffffffc020273e:	e406                	sd	ra,8(sp)
ffffffffc0202740:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202742:	a78fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202746:	000a8797          	auipc	a5,0xa8
ffffffffc020274a:	4aa7b783          	ld	a5,1194(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc020274e:	779c                	ld	a5,40(a5)
ffffffffc0202750:	9782                	jalr	a5
ffffffffc0202752:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202754:	a60fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202758:	60a2                	ld	ra,8(sp)
ffffffffc020275a:	8522                	mv	a0,s0
ffffffffc020275c:	6402                	ld	s0,0(sp)
ffffffffc020275e:	0141                	addi	sp,sp,16
ffffffffc0202760:	8082                	ret

ffffffffc0202762 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202762:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202766:	1ff7f793          	andi	a5,a5,511
{
ffffffffc020276a:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc020276c:	078e                	slli	a5,a5,0x3
{
ffffffffc020276e:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202770:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0202774:	6094                	ld	a3,0(s1)
{
ffffffffc0202776:	f04a                	sd	s2,32(sp)
ffffffffc0202778:	ec4e                	sd	s3,24(sp)
ffffffffc020277a:	e852                	sd	s4,16(sp)
ffffffffc020277c:	fc06                	sd	ra,56(sp)
ffffffffc020277e:	f822                	sd	s0,48(sp)
ffffffffc0202780:	e456                	sd	s5,8(sp)
ffffffffc0202782:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0202784:	0016f793          	andi	a5,a3,1
{
ffffffffc0202788:	892e                	mv	s2,a1
ffffffffc020278a:	8a32                	mv	s4,a2
ffffffffc020278c:	000a8997          	auipc	s3,0xa8
ffffffffc0202790:	45498993          	addi	s3,s3,1108 # ffffffffc02aabe0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0202794:	efbd                	bnez	a5,ffffffffc0202812 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202796:	14060c63          	beqz	a2,ffffffffc02028ee <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020279a:	100027f3          	csrr	a5,sstatus
ffffffffc020279e:	8b89                	andi	a5,a5,2
ffffffffc02027a0:	14079963          	bnez	a5,ffffffffc02028f2 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027a4:	000a8797          	auipc	a5,0xa8
ffffffffc02027a8:	44c7b783          	ld	a5,1100(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc02027ac:	6f9c                	ld	a5,24(a5)
ffffffffc02027ae:	4505                	li	a0,1
ffffffffc02027b0:	9782                	jalr	a5
ffffffffc02027b2:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02027b4:	12040d63          	beqz	s0,ffffffffc02028ee <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02027b8:	000a8b17          	auipc	s6,0xa8
ffffffffc02027bc:	430b0b13          	addi	s6,s6,1072 # ffffffffc02aabe8 <pages>
ffffffffc02027c0:	000b3503          	ld	a0,0(s6)
ffffffffc02027c4:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02027c8:	000a8997          	auipc	s3,0xa8
ffffffffc02027cc:	41898993          	addi	s3,s3,1048 # ffffffffc02aabe0 <npage>
ffffffffc02027d0:	40a40533          	sub	a0,s0,a0
ffffffffc02027d4:	8519                	srai	a0,a0,0x6
ffffffffc02027d6:	9556                	add	a0,a0,s5
ffffffffc02027d8:	0009b703          	ld	a4,0(s3)
ffffffffc02027dc:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02027e0:	4685                	li	a3,1
ffffffffc02027e2:	c014                	sw	a3,0(s0)
ffffffffc02027e4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02027e6:	0532                	slli	a0,a0,0xc
ffffffffc02027e8:	16e7f763          	bgeu	a5,a4,ffffffffc0202956 <get_pte+0x1f4>
ffffffffc02027ec:	000a8797          	auipc	a5,0xa8
ffffffffc02027f0:	40c7b783          	ld	a5,1036(a5) # ffffffffc02aabf8 <va_pa_offset>
ffffffffc02027f4:	6605                	lui	a2,0x1
ffffffffc02027f6:	4581                	li	a1,0
ffffffffc02027f8:	953e                	add	a0,a0,a5
ffffffffc02027fa:	39f020ef          	jal	ra,ffffffffc0205398 <memset>
    return page - pages + nbase;
ffffffffc02027fe:	000b3683          	ld	a3,0(s6)
ffffffffc0202802:	40d406b3          	sub	a3,s0,a3
ffffffffc0202806:	8699                	srai	a3,a3,0x6
ffffffffc0202808:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020280a:	06aa                	slli	a3,a3,0xa
ffffffffc020280c:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202810:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202812:	77fd                	lui	a5,0xfffff
ffffffffc0202814:	068a                	slli	a3,a3,0x2
ffffffffc0202816:	0009b703          	ld	a4,0(s3)
ffffffffc020281a:	8efd                	and	a3,a3,a5
ffffffffc020281c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202820:	10e7ff63          	bgeu	a5,a4,ffffffffc020293e <get_pte+0x1dc>
ffffffffc0202824:	000a8a97          	auipc	s5,0xa8
ffffffffc0202828:	3d4a8a93          	addi	s5,s5,980 # ffffffffc02aabf8 <va_pa_offset>
ffffffffc020282c:	000ab403          	ld	s0,0(s5)
ffffffffc0202830:	01595793          	srli	a5,s2,0x15
ffffffffc0202834:	1ff7f793          	andi	a5,a5,511
ffffffffc0202838:	96a2                	add	a3,a3,s0
ffffffffc020283a:	00379413          	slli	s0,a5,0x3
ffffffffc020283e:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0202840:	6014                	ld	a3,0(s0)
ffffffffc0202842:	0016f793          	andi	a5,a3,1
ffffffffc0202846:	ebad                	bnez	a5,ffffffffc02028b8 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202848:	0a0a0363          	beqz	s4,ffffffffc02028ee <get_pte+0x18c>
ffffffffc020284c:	100027f3          	csrr	a5,sstatus
ffffffffc0202850:	8b89                	andi	a5,a5,2
ffffffffc0202852:	efcd                	bnez	a5,ffffffffc020290c <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202854:	000a8797          	auipc	a5,0xa8
ffffffffc0202858:	39c7b783          	ld	a5,924(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc020285c:	6f9c                	ld	a5,24(a5)
ffffffffc020285e:	4505                	li	a0,1
ffffffffc0202860:	9782                	jalr	a5
ffffffffc0202862:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202864:	c4c9                	beqz	s1,ffffffffc02028ee <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202866:	000a8b17          	auipc	s6,0xa8
ffffffffc020286a:	382b0b13          	addi	s6,s6,898 # ffffffffc02aabe8 <pages>
ffffffffc020286e:	000b3503          	ld	a0,0(s6)
ffffffffc0202872:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202876:	0009b703          	ld	a4,0(s3)
ffffffffc020287a:	40a48533          	sub	a0,s1,a0
ffffffffc020287e:	8519                	srai	a0,a0,0x6
ffffffffc0202880:	9552                	add	a0,a0,s4
ffffffffc0202882:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202886:	4685                	li	a3,1
ffffffffc0202888:	c094                	sw	a3,0(s1)
ffffffffc020288a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020288c:	0532                	slli	a0,a0,0xc
ffffffffc020288e:	0ee7f163          	bgeu	a5,a4,ffffffffc0202970 <get_pte+0x20e>
ffffffffc0202892:	000ab783          	ld	a5,0(s5)
ffffffffc0202896:	6605                	lui	a2,0x1
ffffffffc0202898:	4581                	li	a1,0
ffffffffc020289a:	953e                	add	a0,a0,a5
ffffffffc020289c:	2fd020ef          	jal	ra,ffffffffc0205398 <memset>
    return page - pages + nbase;
ffffffffc02028a0:	000b3683          	ld	a3,0(s6)
ffffffffc02028a4:	40d486b3          	sub	a3,s1,a3
ffffffffc02028a8:	8699                	srai	a3,a3,0x6
ffffffffc02028aa:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02028ac:	06aa                	slli	a3,a3,0xa
ffffffffc02028ae:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02028b2:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02028b4:	0009b703          	ld	a4,0(s3)
ffffffffc02028b8:	068a                	slli	a3,a3,0x2
ffffffffc02028ba:	757d                	lui	a0,0xfffff
ffffffffc02028bc:	8ee9                	and	a3,a3,a0
ffffffffc02028be:	00c6d793          	srli	a5,a3,0xc
ffffffffc02028c2:	06e7f263          	bgeu	a5,a4,ffffffffc0202926 <get_pte+0x1c4>
ffffffffc02028c6:	000ab503          	ld	a0,0(s5)
ffffffffc02028ca:	00c95913          	srli	s2,s2,0xc
ffffffffc02028ce:	1ff97913          	andi	s2,s2,511
ffffffffc02028d2:	96aa                	add	a3,a3,a0
ffffffffc02028d4:	00391513          	slli	a0,s2,0x3
ffffffffc02028d8:	9536                	add	a0,a0,a3
}
ffffffffc02028da:	70e2                	ld	ra,56(sp)
ffffffffc02028dc:	7442                	ld	s0,48(sp)
ffffffffc02028de:	74a2                	ld	s1,40(sp)
ffffffffc02028e0:	7902                	ld	s2,32(sp)
ffffffffc02028e2:	69e2                	ld	s3,24(sp)
ffffffffc02028e4:	6a42                	ld	s4,16(sp)
ffffffffc02028e6:	6aa2                	ld	s5,8(sp)
ffffffffc02028e8:	6b02                	ld	s6,0(sp)
ffffffffc02028ea:	6121                	addi	sp,sp,64
ffffffffc02028ec:	8082                	ret
            return NULL;
ffffffffc02028ee:	4501                	li	a0,0
ffffffffc02028f0:	b7ed                	j	ffffffffc02028da <get_pte+0x178>
        intr_disable();
ffffffffc02028f2:	8c8fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028f6:	000a8797          	auipc	a5,0xa8
ffffffffc02028fa:	2fa7b783          	ld	a5,762(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc02028fe:	6f9c                	ld	a5,24(a5)
ffffffffc0202900:	4505                	li	a0,1
ffffffffc0202902:	9782                	jalr	a5
ffffffffc0202904:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202906:	8aefe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020290a:	b56d                	j	ffffffffc02027b4 <get_pte+0x52>
        intr_disable();
ffffffffc020290c:	8aefe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0202910:	000a8797          	auipc	a5,0xa8
ffffffffc0202914:	2e07b783          	ld	a5,736(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202918:	6f9c                	ld	a5,24(a5)
ffffffffc020291a:	4505                	li	a0,1
ffffffffc020291c:	9782                	jalr	a5
ffffffffc020291e:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0202920:	894fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202924:	b781                	j	ffffffffc0202864 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202926:	00004617          	auipc	a2,0x4
ffffffffc020292a:	c0a60613          	addi	a2,a2,-1014 # ffffffffc0206530 <commands+0xac0>
ffffffffc020292e:	0fa00593          	li	a1,250
ffffffffc0202932:	00004517          	auipc	a0,0x4
ffffffffc0202936:	0f650513          	addi	a0,a0,246 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020293a:	8e5fd0ef          	jal	ra,ffffffffc020021e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020293e:	00004617          	auipc	a2,0x4
ffffffffc0202942:	bf260613          	addi	a2,a2,-1038 # ffffffffc0206530 <commands+0xac0>
ffffffffc0202946:	0ed00593          	li	a1,237
ffffffffc020294a:	00004517          	auipc	a0,0x4
ffffffffc020294e:	0de50513          	addi	a0,a0,222 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0202952:	8cdfd0ef          	jal	ra,ffffffffc020021e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202956:	86aa                	mv	a3,a0
ffffffffc0202958:	00004617          	auipc	a2,0x4
ffffffffc020295c:	bd860613          	addi	a2,a2,-1064 # ffffffffc0206530 <commands+0xac0>
ffffffffc0202960:	0e900593          	li	a1,233
ffffffffc0202964:	00004517          	auipc	a0,0x4
ffffffffc0202968:	0c450513          	addi	a0,a0,196 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020296c:	8b3fd0ef          	jal	ra,ffffffffc020021e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202970:	86aa                	mv	a3,a0
ffffffffc0202972:	00004617          	auipc	a2,0x4
ffffffffc0202976:	bbe60613          	addi	a2,a2,-1090 # ffffffffc0206530 <commands+0xac0>
ffffffffc020297a:	0f700593          	li	a1,247
ffffffffc020297e:	00004517          	auipc	a0,0x4
ffffffffc0202982:	0aa50513          	addi	a0,a0,170 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0202986:	899fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020298a <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc020298a:	1141                	addi	sp,sp,-16
ffffffffc020298c:	e022                	sd	s0,0(sp)
ffffffffc020298e:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202990:	4601                	li	a2,0
{
ffffffffc0202992:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202994:	dcfff0ef          	jal	ra,ffffffffc0202762 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202998:	c011                	beqz	s0,ffffffffc020299c <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc020299a:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020299c:	c511                	beqz	a0,ffffffffc02029a8 <get_page+0x1e>
ffffffffc020299e:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02029a0:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02029a2:	0017f713          	andi	a4,a5,1
ffffffffc02029a6:	e709                	bnez	a4,ffffffffc02029b0 <get_page+0x26>
}
ffffffffc02029a8:	60a2                	ld	ra,8(sp)
ffffffffc02029aa:	6402                	ld	s0,0(sp)
ffffffffc02029ac:	0141                	addi	sp,sp,16
ffffffffc02029ae:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02029b0:	078a                	slli	a5,a5,0x2
ffffffffc02029b2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029b4:	000a8717          	auipc	a4,0xa8
ffffffffc02029b8:	22c73703          	ld	a4,556(a4) # ffffffffc02aabe0 <npage>
ffffffffc02029bc:	00e7ff63          	bgeu	a5,a4,ffffffffc02029da <get_page+0x50>
ffffffffc02029c0:	60a2                	ld	ra,8(sp)
ffffffffc02029c2:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02029c4:	fff80537          	lui	a0,0xfff80
ffffffffc02029c8:	97aa                	add	a5,a5,a0
ffffffffc02029ca:	079a                	slli	a5,a5,0x6
ffffffffc02029cc:	000a8517          	auipc	a0,0xa8
ffffffffc02029d0:	21c53503          	ld	a0,540(a0) # ffffffffc02aabe8 <pages>
ffffffffc02029d4:	953e                	add	a0,a0,a5
ffffffffc02029d6:	0141                	addi	sp,sp,16
ffffffffc02029d8:	8082                	ret
ffffffffc02029da:	c99ff0ef          	jal	ra,ffffffffc0202672 <pa2page.part.0>

ffffffffc02029de <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02029de:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02029e0:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02029e4:	f486                	sd	ra,104(sp)
ffffffffc02029e6:	f0a2                	sd	s0,96(sp)
ffffffffc02029e8:	eca6                	sd	s1,88(sp)
ffffffffc02029ea:	e8ca                	sd	s2,80(sp)
ffffffffc02029ec:	e4ce                	sd	s3,72(sp)
ffffffffc02029ee:	e0d2                	sd	s4,64(sp)
ffffffffc02029f0:	fc56                	sd	s5,56(sp)
ffffffffc02029f2:	f85a                	sd	s6,48(sp)
ffffffffc02029f4:	f45e                	sd	s7,40(sp)
ffffffffc02029f6:	f062                	sd	s8,32(sp)
ffffffffc02029f8:	ec66                	sd	s9,24(sp)
ffffffffc02029fa:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02029fc:	17d2                	slli	a5,a5,0x34
ffffffffc02029fe:	e3ed                	bnez	a5,ffffffffc0202ae0 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc0202a00:	002007b7          	lui	a5,0x200
ffffffffc0202a04:	842e                	mv	s0,a1
ffffffffc0202a06:	0ef5ed63          	bltu	a1,a5,ffffffffc0202b00 <unmap_range+0x122>
ffffffffc0202a0a:	8932                	mv	s2,a2
ffffffffc0202a0c:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202b00 <unmap_range+0x122>
ffffffffc0202a10:	4785                	li	a5,1
ffffffffc0202a12:	07fe                	slli	a5,a5,0x1f
ffffffffc0202a14:	0ec7e663          	bltu	a5,a2,ffffffffc0202b00 <unmap_range+0x122>
ffffffffc0202a18:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202a1a:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0202a1c:	000a8c97          	auipc	s9,0xa8
ffffffffc0202a20:	1c4c8c93          	addi	s9,s9,452 # ffffffffc02aabe0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a24:	000a8c17          	auipc	s8,0xa8
ffffffffc0202a28:	1c4c0c13          	addi	s8,s8,452 # ffffffffc02aabe8 <pages>
ffffffffc0202a2c:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc0202a30:	000a8d17          	auipc	s10,0xa8
ffffffffc0202a34:	1c0d0d13          	addi	s10,s10,448 # ffffffffc02aabf0 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202a38:	00200b37          	lui	s6,0x200
ffffffffc0202a3c:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0202a40:	4601                	li	a2,0
ffffffffc0202a42:	85a2                	mv	a1,s0
ffffffffc0202a44:	854e                	mv	a0,s3
ffffffffc0202a46:	d1dff0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc0202a4a:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0202a4c:	cd29                	beqz	a0,ffffffffc0202aa6 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0202a4e:	611c                	ld	a5,0(a0)
ffffffffc0202a50:	e395                	bnez	a5,ffffffffc0202a74 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202a52:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202a54:	ff2466e3          	bltu	s0,s2,ffffffffc0202a40 <unmap_range+0x62>
}
ffffffffc0202a58:	70a6                	ld	ra,104(sp)
ffffffffc0202a5a:	7406                	ld	s0,96(sp)
ffffffffc0202a5c:	64e6                	ld	s1,88(sp)
ffffffffc0202a5e:	6946                	ld	s2,80(sp)
ffffffffc0202a60:	69a6                	ld	s3,72(sp)
ffffffffc0202a62:	6a06                	ld	s4,64(sp)
ffffffffc0202a64:	7ae2                	ld	s5,56(sp)
ffffffffc0202a66:	7b42                	ld	s6,48(sp)
ffffffffc0202a68:	7ba2                	ld	s7,40(sp)
ffffffffc0202a6a:	7c02                	ld	s8,32(sp)
ffffffffc0202a6c:	6ce2                	ld	s9,24(sp)
ffffffffc0202a6e:	6d42                	ld	s10,16(sp)
ffffffffc0202a70:	6165                	addi	sp,sp,112
ffffffffc0202a72:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202a74:	0017f713          	andi	a4,a5,1
ffffffffc0202a78:	df69                	beqz	a4,ffffffffc0202a52 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202a7a:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a7e:	078a                	slli	a5,a5,0x2
ffffffffc0202a80:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a82:	08e7ff63          	bgeu	a5,a4,ffffffffc0202b20 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a86:	000c3503          	ld	a0,0(s8)
ffffffffc0202a8a:	97de                	add	a5,a5,s7
ffffffffc0202a8c:	079a                	slli	a5,a5,0x6
ffffffffc0202a8e:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202a90:	411c                	lw	a5,0(a0)
ffffffffc0202a92:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202a96:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202a98:	cf11                	beqz	a4,ffffffffc0202ab4 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202a9a:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202a9e:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202aa2:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202aa4:	bf45                	j	ffffffffc0202a54 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202aa6:	945a                	add	s0,s0,s6
ffffffffc0202aa8:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0202aac:	d455                	beqz	s0,ffffffffc0202a58 <unmap_range+0x7a>
ffffffffc0202aae:	f92469e3          	bltu	s0,s2,ffffffffc0202a40 <unmap_range+0x62>
ffffffffc0202ab2:	b75d                	j	ffffffffc0202a58 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202ab4:	100027f3          	csrr	a5,sstatus
ffffffffc0202ab8:	8b89                	andi	a5,a5,2
ffffffffc0202aba:	e799                	bnez	a5,ffffffffc0202ac8 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc0202abc:	000d3783          	ld	a5,0(s10)
ffffffffc0202ac0:	4585                	li	a1,1
ffffffffc0202ac2:	739c                	ld	a5,32(a5)
ffffffffc0202ac4:	9782                	jalr	a5
    if (flag)
ffffffffc0202ac6:	bfd1                	j	ffffffffc0202a9a <unmap_range+0xbc>
ffffffffc0202ac8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202aca:	ef1fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0202ace:	000d3783          	ld	a5,0(s10)
ffffffffc0202ad2:	6522                	ld	a0,8(sp)
ffffffffc0202ad4:	4585                	li	a1,1
ffffffffc0202ad6:	739c                	ld	a5,32(a5)
ffffffffc0202ad8:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ada:	edbfd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202ade:	bf75                	j	ffffffffc0202a9a <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202ae0:	00004697          	auipc	a3,0x4
ffffffffc0202ae4:	f5868693          	addi	a3,a3,-168 # ffffffffc0206a38 <default_pmm_manager+0x70>
ffffffffc0202ae8:	00003617          	auipc	a2,0x3
ffffffffc0202aec:	7d060613          	addi	a2,a2,2000 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202af0:	12000593          	li	a1,288
ffffffffc0202af4:	00004517          	auipc	a0,0x4
ffffffffc0202af8:	f3450513          	addi	a0,a0,-204 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0202afc:	f22fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202b00:	00004697          	auipc	a3,0x4
ffffffffc0202b04:	f6868693          	addi	a3,a3,-152 # ffffffffc0206a68 <default_pmm_manager+0xa0>
ffffffffc0202b08:	00003617          	auipc	a2,0x3
ffffffffc0202b0c:	7b060613          	addi	a2,a2,1968 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202b10:	12100593          	li	a1,289
ffffffffc0202b14:	00004517          	auipc	a0,0x4
ffffffffc0202b18:	f1450513          	addi	a0,a0,-236 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0202b1c:	f02fd0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0202b20:	b53ff0ef          	jal	ra,ffffffffc0202672 <pa2page.part.0>

ffffffffc0202b24 <exit_range>:
{
ffffffffc0202b24:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202b26:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202b2a:	fc86                	sd	ra,120(sp)
ffffffffc0202b2c:	f8a2                	sd	s0,112(sp)
ffffffffc0202b2e:	f4a6                	sd	s1,104(sp)
ffffffffc0202b30:	f0ca                	sd	s2,96(sp)
ffffffffc0202b32:	ecce                	sd	s3,88(sp)
ffffffffc0202b34:	e8d2                	sd	s4,80(sp)
ffffffffc0202b36:	e4d6                	sd	s5,72(sp)
ffffffffc0202b38:	e0da                	sd	s6,64(sp)
ffffffffc0202b3a:	fc5e                	sd	s7,56(sp)
ffffffffc0202b3c:	f862                	sd	s8,48(sp)
ffffffffc0202b3e:	f466                	sd	s9,40(sp)
ffffffffc0202b40:	f06a                	sd	s10,32(sp)
ffffffffc0202b42:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202b44:	17d2                	slli	a5,a5,0x34
ffffffffc0202b46:	20079a63          	bnez	a5,ffffffffc0202d5a <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202b4a:	002007b7          	lui	a5,0x200
ffffffffc0202b4e:	24f5e463          	bltu	a1,a5,ffffffffc0202d96 <exit_range+0x272>
ffffffffc0202b52:	8ab2                	mv	s5,a2
ffffffffc0202b54:	24c5f163          	bgeu	a1,a2,ffffffffc0202d96 <exit_range+0x272>
ffffffffc0202b58:	4785                	li	a5,1
ffffffffc0202b5a:	07fe                	slli	a5,a5,0x1f
ffffffffc0202b5c:	22c7ed63          	bltu	a5,a2,ffffffffc0202d96 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc0202b60:	c00009b7          	lui	s3,0xc0000
ffffffffc0202b64:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202b68:	ffe00937          	lui	s2,0xffe00
ffffffffc0202b6c:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc0202b70:	5cfd                	li	s9,-1
ffffffffc0202b72:	8c2a                	mv	s8,a0
ffffffffc0202b74:	0125f933          	and	s2,a1,s2
ffffffffc0202b78:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202b7a:	000a8d17          	auipc	s10,0xa8
ffffffffc0202b7e:	066d0d13          	addi	s10,s10,102 # ffffffffc02aabe0 <npage>
    return KADDR(page2pa(page));
ffffffffc0202b82:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202b86:	000a8717          	auipc	a4,0xa8
ffffffffc0202b8a:	06270713          	addi	a4,a4,98 # ffffffffc02aabe8 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202b8e:	000a8d97          	auipc	s11,0xa8
ffffffffc0202b92:	062d8d93          	addi	s11,s11,98 # ffffffffc02aabf0 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202b96:	c0000437          	lui	s0,0xc0000
ffffffffc0202b9a:	944e                	add	s0,s0,s3
ffffffffc0202b9c:	8079                	srli	s0,s0,0x1e
ffffffffc0202b9e:	1ff47413          	andi	s0,s0,511
ffffffffc0202ba2:	040e                	slli	s0,s0,0x3
ffffffffc0202ba4:	9462                	add	s0,s0,s8
ffffffffc0202ba6:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4e90>
        if (pde1 & PTE_V)
ffffffffc0202baa:	001a7793          	andi	a5,s4,1
ffffffffc0202bae:	eb99                	bnez	a5,ffffffffc0202bc4 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc0202bb0:	12098463          	beqz	s3,ffffffffc0202cd8 <exit_range+0x1b4>
ffffffffc0202bb4:	400007b7          	lui	a5,0x40000
ffffffffc0202bb8:	97ce                	add	a5,a5,s3
ffffffffc0202bba:	894e                	mv	s2,s3
ffffffffc0202bbc:	1159fe63          	bgeu	s3,s5,ffffffffc0202cd8 <exit_range+0x1b4>
ffffffffc0202bc0:	89be                	mv	s3,a5
ffffffffc0202bc2:	bfd1                	j	ffffffffc0202b96 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc0202bc4:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202bc8:	0a0a                	slli	s4,s4,0x2
ffffffffc0202bca:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202bce:	1cfa7263          	bgeu	s4,a5,ffffffffc0202d92 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202bd2:	fff80637          	lui	a2,0xfff80
ffffffffc0202bd6:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202bd8:	000806b7          	lui	a3,0x80
ffffffffc0202bdc:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202bde:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202be2:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202be4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202be6:	18f5fa63          	bgeu	a1,a5,ffffffffc0202d7a <exit_range+0x256>
ffffffffc0202bea:	000a8817          	auipc	a6,0xa8
ffffffffc0202bee:	00e80813          	addi	a6,a6,14 # ffffffffc02aabf8 <va_pa_offset>
ffffffffc0202bf2:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202bf6:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202bf8:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202bfc:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202bfe:	00080337          	lui	t1,0x80
ffffffffc0202c02:	6885                	lui	a7,0x1
ffffffffc0202c04:	a819                	j	ffffffffc0202c1a <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202c06:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202c08:	002007b7          	lui	a5,0x200
ffffffffc0202c0c:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202c0e:	08090c63          	beqz	s2,ffffffffc0202ca6 <exit_range+0x182>
ffffffffc0202c12:	09397a63          	bgeu	s2,s3,ffffffffc0202ca6 <exit_range+0x182>
ffffffffc0202c16:	0f597063          	bgeu	s2,s5,ffffffffc0202cf6 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202c1a:	01595493          	srli	s1,s2,0x15
ffffffffc0202c1e:	1ff4f493          	andi	s1,s1,511
ffffffffc0202c22:	048e                	slli	s1,s1,0x3
ffffffffc0202c24:	94da                	add	s1,s1,s6
ffffffffc0202c26:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202c28:	0017f693          	andi	a3,a5,1
ffffffffc0202c2c:	dee9                	beqz	a3,ffffffffc0202c06 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202c2e:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c32:	078a                	slli	a5,a5,0x2
ffffffffc0202c34:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c36:	14b7fe63          	bgeu	a5,a1,ffffffffc0202d92 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c3a:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0202c3c:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc0202c40:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202c44:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c48:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c4a:	12bef863          	bgeu	t4,a1,ffffffffc0202d7a <exit_range+0x256>
ffffffffc0202c4e:	00083783          	ld	a5,0(a6)
ffffffffc0202c52:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202c54:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202c58:	629c                	ld	a5,0(a3)
ffffffffc0202c5a:	8b85                	andi	a5,a5,1
ffffffffc0202c5c:	f7d5                	bnez	a5,ffffffffc0202c08 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202c5e:	06a1                	addi	a3,a3,8
ffffffffc0202c60:	fed59ce3          	bne	a1,a3,ffffffffc0202c58 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c64:	631c                	ld	a5,0(a4)
ffffffffc0202c66:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202c68:	100027f3          	csrr	a5,sstatus
ffffffffc0202c6c:	8b89                	andi	a5,a5,2
ffffffffc0202c6e:	e7d9                	bnez	a5,ffffffffc0202cfc <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc0202c70:	000db783          	ld	a5,0(s11)
ffffffffc0202c74:	4585                	li	a1,1
ffffffffc0202c76:	e032                	sd	a2,0(sp)
ffffffffc0202c78:	739c                	ld	a5,32(a5)
ffffffffc0202c7a:	9782                	jalr	a5
    if (flag)
ffffffffc0202c7c:	6602                	ld	a2,0(sp)
ffffffffc0202c7e:	000a8817          	auipc	a6,0xa8
ffffffffc0202c82:	f7a80813          	addi	a6,a6,-134 # ffffffffc02aabf8 <va_pa_offset>
ffffffffc0202c86:	fff80e37          	lui	t3,0xfff80
ffffffffc0202c8a:	00080337          	lui	t1,0x80
ffffffffc0202c8e:	6885                	lui	a7,0x1
ffffffffc0202c90:	000a8717          	auipc	a4,0xa8
ffffffffc0202c94:	f5870713          	addi	a4,a4,-168 # ffffffffc02aabe8 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202c98:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202c9c:	002007b7          	lui	a5,0x200
ffffffffc0202ca0:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202ca2:	f60918e3          	bnez	s2,ffffffffc0202c12 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202ca6:	f00b85e3          	beqz	s7,ffffffffc0202bb0 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202caa:	000d3783          	ld	a5,0(s10)
ffffffffc0202cae:	0efa7263          	bgeu	s4,a5,ffffffffc0202d92 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cb2:	6308                	ld	a0,0(a4)
ffffffffc0202cb4:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202cb6:	100027f3          	csrr	a5,sstatus
ffffffffc0202cba:	8b89                	andi	a5,a5,2
ffffffffc0202cbc:	efad                	bnez	a5,ffffffffc0202d36 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202cbe:	000db783          	ld	a5,0(s11)
ffffffffc0202cc2:	4585                	li	a1,1
ffffffffc0202cc4:	739c                	ld	a5,32(a5)
ffffffffc0202cc6:	9782                	jalr	a5
ffffffffc0202cc8:	000a8717          	auipc	a4,0xa8
ffffffffc0202ccc:	f2070713          	addi	a4,a4,-224 # ffffffffc02aabe8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202cd0:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc0202cd4:	ee0990e3          	bnez	s3,ffffffffc0202bb4 <exit_range+0x90>
}
ffffffffc0202cd8:	70e6                	ld	ra,120(sp)
ffffffffc0202cda:	7446                	ld	s0,112(sp)
ffffffffc0202cdc:	74a6                	ld	s1,104(sp)
ffffffffc0202cde:	7906                	ld	s2,96(sp)
ffffffffc0202ce0:	69e6                	ld	s3,88(sp)
ffffffffc0202ce2:	6a46                	ld	s4,80(sp)
ffffffffc0202ce4:	6aa6                	ld	s5,72(sp)
ffffffffc0202ce6:	6b06                	ld	s6,64(sp)
ffffffffc0202ce8:	7be2                	ld	s7,56(sp)
ffffffffc0202cea:	7c42                	ld	s8,48(sp)
ffffffffc0202cec:	7ca2                	ld	s9,40(sp)
ffffffffc0202cee:	7d02                	ld	s10,32(sp)
ffffffffc0202cf0:	6de2                	ld	s11,24(sp)
ffffffffc0202cf2:	6109                	addi	sp,sp,128
ffffffffc0202cf4:	8082                	ret
            if (free_pd0)
ffffffffc0202cf6:	ea0b8fe3          	beqz	s7,ffffffffc0202bb4 <exit_range+0x90>
ffffffffc0202cfa:	bf45                	j	ffffffffc0202caa <exit_range+0x186>
ffffffffc0202cfc:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202cfe:	e42a                	sd	a0,8(sp)
ffffffffc0202d00:	cbbfd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d04:	000db783          	ld	a5,0(s11)
ffffffffc0202d08:	6522                	ld	a0,8(sp)
ffffffffc0202d0a:	4585                	li	a1,1
ffffffffc0202d0c:	739c                	ld	a5,32(a5)
ffffffffc0202d0e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d10:	ca5fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202d14:	6602                	ld	a2,0(sp)
ffffffffc0202d16:	000a8717          	auipc	a4,0xa8
ffffffffc0202d1a:	ed270713          	addi	a4,a4,-302 # ffffffffc02aabe8 <pages>
ffffffffc0202d1e:	6885                	lui	a7,0x1
ffffffffc0202d20:	00080337          	lui	t1,0x80
ffffffffc0202d24:	fff80e37          	lui	t3,0xfff80
ffffffffc0202d28:	000a8817          	auipc	a6,0xa8
ffffffffc0202d2c:	ed080813          	addi	a6,a6,-304 # ffffffffc02aabf8 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202d30:	0004b023          	sd	zero,0(s1)
ffffffffc0202d34:	b7a5                	j	ffffffffc0202c9c <exit_range+0x178>
ffffffffc0202d36:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202d38:	c83fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202d3c:	000db783          	ld	a5,0(s11)
ffffffffc0202d40:	6502                	ld	a0,0(sp)
ffffffffc0202d42:	4585                	li	a1,1
ffffffffc0202d44:	739c                	ld	a5,32(a5)
ffffffffc0202d46:	9782                	jalr	a5
        intr_enable();
ffffffffc0202d48:	c6dfd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202d4c:	000a8717          	auipc	a4,0xa8
ffffffffc0202d50:	e9c70713          	addi	a4,a4,-356 # ffffffffc02aabe8 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202d54:	00043023          	sd	zero,0(s0)
ffffffffc0202d58:	bfb5                	j	ffffffffc0202cd4 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202d5a:	00004697          	auipc	a3,0x4
ffffffffc0202d5e:	cde68693          	addi	a3,a3,-802 # ffffffffc0206a38 <default_pmm_manager+0x70>
ffffffffc0202d62:	00003617          	auipc	a2,0x3
ffffffffc0202d66:	55660613          	addi	a2,a2,1366 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202d6a:	13500593          	li	a1,309
ffffffffc0202d6e:	00004517          	auipc	a0,0x4
ffffffffc0202d72:	cba50513          	addi	a0,a0,-838 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0202d76:	ca8fd0ef          	jal	ra,ffffffffc020021e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202d7a:	00003617          	auipc	a2,0x3
ffffffffc0202d7e:	7b660613          	addi	a2,a2,1974 # ffffffffc0206530 <commands+0xac0>
ffffffffc0202d82:	07100593          	li	a1,113
ffffffffc0202d86:	00003517          	auipc	a0,0x3
ffffffffc0202d8a:	7d250513          	addi	a0,a0,2002 # ffffffffc0206558 <commands+0xae8>
ffffffffc0202d8e:	c90fd0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0202d92:	8e1ff0ef          	jal	ra,ffffffffc0202672 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202d96:	00004697          	auipc	a3,0x4
ffffffffc0202d9a:	cd268693          	addi	a3,a3,-814 # ffffffffc0206a68 <default_pmm_manager+0xa0>
ffffffffc0202d9e:	00003617          	auipc	a2,0x3
ffffffffc0202da2:	51a60613          	addi	a2,a2,1306 # ffffffffc02062b8 <commands+0x848>
ffffffffc0202da6:	13600593          	li	a1,310
ffffffffc0202daa:	00004517          	auipc	a0,0x4
ffffffffc0202dae:	c7e50513          	addi	a0,a0,-898 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0202db2:	c6cfd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202db6 <page_remove>:
{
ffffffffc0202db6:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202db8:	4601                	li	a2,0
{
ffffffffc0202dba:	ec26                	sd	s1,24(sp)
ffffffffc0202dbc:	f406                	sd	ra,40(sp)
ffffffffc0202dbe:	f022                	sd	s0,32(sp)
ffffffffc0202dc0:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202dc2:	9a1ff0ef          	jal	ra,ffffffffc0202762 <get_pte>
    if (ptep != NULL)
ffffffffc0202dc6:	c511                	beqz	a0,ffffffffc0202dd2 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202dc8:	611c                	ld	a5,0(a0)
ffffffffc0202dca:	842a                	mv	s0,a0
ffffffffc0202dcc:	0017f713          	andi	a4,a5,1
ffffffffc0202dd0:	e711                	bnez	a4,ffffffffc0202ddc <page_remove+0x26>
}
ffffffffc0202dd2:	70a2                	ld	ra,40(sp)
ffffffffc0202dd4:	7402                	ld	s0,32(sp)
ffffffffc0202dd6:	64e2                	ld	s1,24(sp)
ffffffffc0202dd8:	6145                	addi	sp,sp,48
ffffffffc0202dda:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202ddc:	078a                	slli	a5,a5,0x2
ffffffffc0202dde:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202de0:	000a8717          	auipc	a4,0xa8
ffffffffc0202de4:	e0073703          	ld	a4,-512(a4) # ffffffffc02aabe0 <npage>
ffffffffc0202de8:	06e7f363          	bgeu	a5,a4,ffffffffc0202e4e <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202dec:	fff80537          	lui	a0,0xfff80
ffffffffc0202df0:	97aa                	add	a5,a5,a0
ffffffffc0202df2:	079a                	slli	a5,a5,0x6
ffffffffc0202df4:	000a8517          	auipc	a0,0xa8
ffffffffc0202df8:	df453503          	ld	a0,-524(a0) # ffffffffc02aabe8 <pages>
ffffffffc0202dfc:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202dfe:	411c                	lw	a5,0(a0)
ffffffffc0202e00:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202e04:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202e06:	cb11                	beqz	a4,ffffffffc0202e1a <page_remove+0x64>
        *ptep = 0;
ffffffffc0202e08:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202e0c:	12048073          	sfence.vma	s1
}
ffffffffc0202e10:	70a2                	ld	ra,40(sp)
ffffffffc0202e12:	7402                	ld	s0,32(sp)
ffffffffc0202e14:	64e2                	ld	s1,24(sp)
ffffffffc0202e16:	6145                	addi	sp,sp,48
ffffffffc0202e18:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202e1a:	100027f3          	csrr	a5,sstatus
ffffffffc0202e1e:	8b89                	andi	a5,a5,2
ffffffffc0202e20:	eb89                	bnez	a5,ffffffffc0202e32 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202e22:	000a8797          	auipc	a5,0xa8
ffffffffc0202e26:	dce7b783          	ld	a5,-562(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202e2a:	739c                	ld	a5,32(a5)
ffffffffc0202e2c:	4585                	li	a1,1
ffffffffc0202e2e:	9782                	jalr	a5
    if (flag)
ffffffffc0202e30:	bfe1                	j	ffffffffc0202e08 <page_remove+0x52>
        intr_disable();
ffffffffc0202e32:	e42a                	sd	a0,8(sp)
ffffffffc0202e34:	b87fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0202e38:	000a8797          	auipc	a5,0xa8
ffffffffc0202e3c:	db87b783          	ld	a5,-584(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202e40:	739c                	ld	a5,32(a5)
ffffffffc0202e42:	6522                	ld	a0,8(sp)
ffffffffc0202e44:	4585                	li	a1,1
ffffffffc0202e46:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e48:	b6dfd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202e4c:	bf75                	j	ffffffffc0202e08 <page_remove+0x52>
ffffffffc0202e4e:	825ff0ef          	jal	ra,ffffffffc0202672 <pa2page.part.0>

ffffffffc0202e52 <page_insert>:
{
ffffffffc0202e52:	7139                	addi	sp,sp,-64
ffffffffc0202e54:	e852                	sd	s4,16(sp)
ffffffffc0202e56:	8a32                	mv	s4,a2
ffffffffc0202e58:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e5a:	4605                	li	a2,1
{
ffffffffc0202e5c:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e5e:	85d2                	mv	a1,s4
{
ffffffffc0202e60:	f426                	sd	s1,40(sp)
ffffffffc0202e62:	fc06                	sd	ra,56(sp)
ffffffffc0202e64:	f04a                	sd	s2,32(sp)
ffffffffc0202e66:	ec4e                	sd	s3,24(sp)
ffffffffc0202e68:	e456                	sd	s5,8(sp)
ffffffffc0202e6a:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e6c:	8f7ff0ef          	jal	ra,ffffffffc0202762 <get_pte>
    if (ptep == NULL)
ffffffffc0202e70:	c961                	beqz	a0,ffffffffc0202f40 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202e72:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202e74:	611c                	ld	a5,0(a0)
ffffffffc0202e76:	89aa                	mv	s3,a0
ffffffffc0202e78:	0016871b          	addiw	a4,a3,1
ffffffffc0202e7c:	c018                	sw	a4,0(s0)
ffffffffc0202e7e:	0017f713          	andi	a4,a5,1
ffffffffc0202e82:	ef05                	bnez	a4,ffffffffc0202eba <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202e84:	000a8717          	auipc	a4,0xa8
ffffffffc0202e88:	d6473703          	ld	a4,-668(a4) # ffffffffc02aabe8 <pages>
ffffffffc0202e8c:	8c19                	sub	s0,s0,a4
ffffffffc0202e8e:	000807b7          	lui	a5,0x80
ffffffffc0202e92:	8419                	srai	s0,s0,0x6
ffffffffc0202e94:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202e96:	042a                	slli	s0,s0,0xa
ffffffffc0202e98:	8cc1                	or	s1,s1,s0
ffffffffc0202e9a:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202e9e:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4e90>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202ea2:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202ea6:	4501                	li	a0,0
}
ffffffffc0202ea8:	70e2                	ld	ra,56(sp)
ffffffffc0202eaa:	7442                	ld	s0,48(sp)
ffffffffc0202eac:	74a2                	ld	s1,40(sp)
ffffffffc0202eae:	7902                	ld	s2,32(sp)
ffffffffc0202eb0:	69e2                	ld	s3,24(sp)
ffffffffc0202eb2:	6a42                	ld	s4,16(sp)
ffffffffc0202eb4:	6aa2                	ld	s5,8(sp)
ffffffffc0202eb6:	6121                	addi	sp,sp,64
ffffffffc0202eb8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202eba:	078a                	slli	a5,a5,0x2
ffffffffc0202ebc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ebe:	000a8717          	auipc	a4,0xa8
ffffffffc0202ec2:	d2273703          	ld	a4,-734(a4) # ffffffffc02aabe0 <npage>
ffffffffc0202ec6:	06e7ff63          	bgeu	a5,a4,ffffffffc0202f44 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202eca:	000a8a97          	auipc	s5,0xa8
ffffffffc0202ece:	d1ea8a93          	addi	s5,s5,-738 # ffffffffc02aabe8 <pages>
ffffffffc0202ed2:	000ab703          	ld	a4,0(s5)
ffffffffc0202ed6:	fff80937          	lui	s2,0xfff80
ffffffffc0202eda:	993e                	add	s2,s2,a5
ffffffffc0202edc:	091a                	slli	s2,s2,0x6
ffffffffc0202ede:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0202ee0:	01240c63          	beq	s0,s2,ffffffffc0202ef8 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc0202ee4:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcd53e4>
ffffffffc0202ee8:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202eec:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc0202ef0:	c691                	beqz	a3,ffffffffc0202efc <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202ef2:	120a0073          	sfence.vma	s4
}
ffffffffc0202ef6:	bf59                	j	ffffffffc0202e8c <page_insert+0x3a>
ffffffffc0202ef8:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202efa:	bf49                	j	ffffffffc0202e8c <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202efc:	100027f3          	csrr	a5,sstatus
ffffffffc0202f00:	8b89                	andi	a5,a5,2
ffffffffc0202f02:	ef91                	bnez	a5,ffffffffc0202f1e <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202f04:	000a8797          	auipc	a5,0xa8
ffffffffc0202f08:	cec7b783          	ld	a5,-788(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202f0c:	739c                	ld	a5,32(a5)
ffffffffc0202f0e:	4585                	li	a1,1
ffffffffc0202f10:	854a                	mv	a0,s2
ffffffffc0202f12:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202f14:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202f18:	120a0073          	sfence.vma	s4
ffffffffc0202f1c:	bf85                	j	ffffffffc0202e8c <page_insert+0x3a>
        intr_disable();
ffffffffc0202f1e:	a9dfd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202f22:	000a8797          	auipc	a5,0xa8
ffffffffc0202f26:	cce7b783          	ld	a5,-818(a5) # ffffffffc02aabf0 <pmm_manager>
ffffffffc0202f2a:	739c                	ld	a5,32(a5)
ffffffffc0202f2c:	4585                	li	a1,1
ffffffffc0202f2e:	854a                	mv	a0,s2
ffffffffc0202f30:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f32:	a83fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202f36:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202f3a:	120a0073          	sfence.vma	s4
ffffffffc0202f3e:	b7b9                	j	ffffffffc0202e8c <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202f40:	5571                	li	a0,-4
ffffffffc0202f42:	b79d                	j	ffffffffc0202ea8 <page_insert+0x56>
ffffffffc0202f44:	f2eff0ef          	jal	ra,ffffffffc0202672 <pa2page.part.0>

ffffffffc0202f48 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202f48:	00004797          	auipc	a5,0x4
ffffffffc0202f4c:	a8078793          	addi	a5,a5,-1408 # ffffffffc02069c8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f50:	638c                	ld	a1,0(a5)
{
ffffffffc0202f52:	7159                	addi	sp,sp,-112
ffffffffc0202f54:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f56:	00004517          	auipc	a0,0x4
ffffffffc0202f5a:	b2a50513          	addi	a0,a0,-1238 # ffffffffc0206a80 <default_pmm_manager+0xb8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202f5e:	000a8b17          	auipc	s6,0xa8
ffffffffc0202f62:	c92b0b13          	addi	s6,s6,-878 # ffffffffc02aabf0 <pmm_manager>
{
ffffffffc0202f66:	f486                	sd	ra,104(sp)
ffffffffc0202f68:	e8ca                	sd	s2,80(sp)
ffffffffc0202f6a:	e4ce                	sd	s3,72(sp)
ffffffffc0202f6c:	f0a2                	sd	s0,96(sp)
ffffffffc0202f6e:	eca6                	sd	s1,88(sp)
ffffffffc0202f70:	e0d2                	sd	s4,64(sp)
ffffffffc0202f72:	fc56                	sd	s5,56(sp)
ffffffffc0202f74:	f45e                	sd	s7,40(sp)
ffffffffc0202f76:	f062                	sd	s8,32(sp)
ffffffffc0202f78:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202f7a:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f7e:	962fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    pmm_manager->init();
ffffffffc0202f82:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202f86:	000a8997          	auipc	s3,0xa8
ffffffffc0202f8a:	c7298993          	addi	s3,s3,-910 # ffffffffc02aabf8 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202f8e:	679c                	ld	a5,8(a5)
ffffffffc0202f90:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202f92:	57f5                	li	a5,-3
ffffffffc0202f94:	07fa                	slli	a5,a5,0x1e
ffffffffc0202f96:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202f9a:	93ffd0ef          	jal	ra,ffffffffc02008d8 <get_memory_base>
ffffffffc0202f9e:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc0202fa0:	943fd0ef          	jal	ra,ffffffffc02008e2 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202fa4:	200505e3          	beqz	a0,ffffffffc02039ae <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202fa8:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202faa:	00004517          	auipc	a0,0x4
ffffffffc0202fae:	b0e50513          	addi	a0,a0,-1266 # ffffffffc0206ab8 <default_pmm_manager+0xf0>
ffffffffc0202fb2:	92efd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202fb6:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202fba:	fff40693          	addi	a3,s0,-1
ffffffffc0202fbe:	864a                	mv	a2,s2
ffffffffc0202fc0:	85a6                	mv	a1,s1
ffffffffc0202fc2:	00004517          	auipc	a0,0x4
ffffffffc0202fc6:	b0e50513          	addi	a0,a0,-1266 # ffffffffc0206ad0 <default_pmm_manager+0x108>
ffffffffc0202fca:	916fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202fce:	c8000737          	lui	a4,0xc8000
ffffffffc0202fd2:	87a2                	mv	a5,s0
ffffffffc0202fd4:	54876163          	bltu	a4,s0,ffffffffc0203516 <pmm_init+0x5ce>
ffffffffc0202fd8:	757d                	lui	a0,0xfffff
ffffffffc0202fda:	000a9617          	auipc	a2,0xa9
ffffffffc0202fde:	c4160613          	addi	a2,a2,-959 # ffffffffc02abc1b <end+0xfff>
ffffffffc0202fe2:	8e69                	and	a2,a2,a0
ffffffffc0202fe4:	000a8497          	auipc	s1,0xa8
ffffffffc0202fe8:	bfc48493          	addi	s1,s1,-1028 # ffffffffc02aabe0 <npage>
ffffffffc0202fec:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202ff0:	000a8b97          	auipc	s7,0xa8
ffffffffc0202ff4:	bf8b8b93          	addi	s7,s7,-1032 # ffffffffc02aabe8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202ff8:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202ffa:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202ffe:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0203002:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0203004:	02f50863          	beq	a0,a5,ffffffffc0203034 <pmm_init+0xec>
ffffffffc0203008:	4781                	li	a5,0
ffffffffc020300a:	4585                	li	a1,1
ffffffffc020300c:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0203010:	00679513          	slli	a0,a5,0x6
ffffffffc0203014:	9532                	add	a0,a0,a2
ffffffffc0203016:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd543ec>
ffffffffc020301a:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020301e:	6088                	ld	a0,0(s1)
ffffffffc0203020:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0203022:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0203026:	00d50733          	add	a4,a0,a3
ffffffffc020302a:	fee7e3e3          	bltu	a5,a4,ffffffffc0203010 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020302e:	071a                	slli	a4,a4,0x6
ffffffffc0203030:	00e606b3          	add	a3,a2,a4
ffffffffc0203034:	c02007b7          	lui	a5,0xc0200
ffffffffc0203038:	2ef6ece3          	bltu	a3,a5,ffffffffc0203b30 <pmm_init+0xbe8>
ffffffffc020303c:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0203040:	77fd                	lui	a5,0xfffff
ffffffffc0203042:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203044:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0203046:	5086eb63          	bltu	a3,s0,ffffffffc020355c <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020304a:	00004517          	auipc	a0,0x4
ffffffffc020304e:	aae50513          	addi	a0,a0,-1362 # ffffffffc0206af8 <default_pmm_manager+0x130>
ffffffffc0203052:	88efd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0203056:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020305a:	000a8917          	auipc	s2,0xa8
ffffffffc020305e:	b7e90913          	addi	s2,s2,-1154 # ffffffffc02aabd8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0203062:	7b9c                	ld	a5,48(a5)
ffffffffc0203064:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0203066:	00004517          	auipc	a0,0x4
ffffffffc020306a:	aaa50513          	addi	a0,a0,-1366 # ffffffffc0206b10 <default_pmm_manager+0x148>
ffffffffc020306e:	872fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0203072:	00007697          	auipc	a3,0x7
ffffffffc0203076:	f8e68693          	addi	a3,a3,-114 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc020307a:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020307e:	c02007b7          	lui	a5,0xc0200
ffffffffc0203082:	28f6ebe3          	bltu	a3,a5,ffffffffc0203b18 <pmm_init+0xbd0>
ffffffffc0203086:	0009b783          	ld	a5,0(s3)
ffffffffc020308a:	8e9d                	sub	a3,a3,a5
ffffffffc020308c:	000a8797          	auipc	a5,0xa8
ffffffffc0203090:	b4d7b223          	sd	a3,-1212(a5) # ffffffffc02aabd0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203094:	100027f3          	csrr	a5,sstatus
ffffffffc0203098:	8b89                	andi	a5,a5,2
ffffffffc020309a:	4a079763          	bnez	a5,ffffffffc0203548 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc020309e:	000b3783          	ld	a5,0(s6)
ffffffffc02030a2:	779c                	ld	a5,40(a5)
ffffffffc02030a4:	9782                	jalr	a5
ffffffffc02030a6:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02030a8:	6098                	ld	a4,0(s1)
ffffffffc02030aa:	c80007b7          	lui	a5,0xc8000
ffffffffc02030ae:	83b1                	srli	a5,a5,0xc
ffffffffc02030b0:	66e7e363          	bltu	a5,a4,ffffffffc0203716 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02030b4:	00093503          	ld	a0,0(s2)
ffffffffc02030b8:	62050f63          	beqz	a0,ffffffffc02036f6 <pmm_init+0x7ae>
ffffffffc02030bc:	03451793          	slli	a5,a0,0x34
ffffffffc02030c0:	62079b63          	bnez	a5,ffffffffc02036f6 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02030c4:	4601                	li	a2,0
ffffffffc02030c6:	4581                	li	a1,0
ffffffffc02030c8:	8c3ff0ef          	jal	ra,ffffffffc020298a <get_page>
ffffffffc02030cc:	60051563          	bnez	a0,ffffffffc02036d6 <pmm_init+0x78e>
ffffffffc02030d0:	100027f3          	csrr	a5,sstatus
ffffffffc02030d4:	8b89                	andi	a5,a5,2
ffffffffc02030d6:	44079e63          	bnez	a5,ffffffffc0203532 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02030da:	000b3783          	ld	a5,0(s6)
ffffffffc02030de:	4505                	li	a0,1
ffffffffc02030e0:	6f9c                	ld	a5,24(a5)
ffffffffc02030e2:	9782                	jalr	a5
ffffffffc02030e4:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02030e6:	00093503          	ld	a0,0(s2)
ffffffffc02030ea:	4681                	li	a3,0
ffffffffc02030ec:	4601                	li	a2,0
ffffffffc02030ee:	85d2                	mv	a1,s4
ffffffffc02030f0:	d63ff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
ffffffffc02030f4:	26051ae3          	bnez	a0,ffffffffc0203b68 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02030f8:	00093503          	ld	a0,0(s2)
ffffffffc02030fc:	4601                	li	a2,0
ffffffffc02030fe:	4581                	li	a1,0
ffffffffc0203100:	e62ff0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc0203104:	240502e3          	beqz	a0,ffffffffc0203b48 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0203108:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020310a:	0017f713          	andi	a4,a5,1
ffffffffc020310e:	5a070263          	beqz	a4,ffffffffc02036b2 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0203112:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203114:	078a                	slli	a5,a5,0x2
ffffffffc0203116:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203118:	58e7fb63          	bgeu	a5,a4,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020311c:	000bb683          	ld	a3,0(s7)
ffffffffc0203120:	fff80637          	lui	a2,0xfff80
ffffffffc0203124:	97b2                	add	a5,a5,a2
ffffffffc0203126:	079a                	slli	a5,a5,0x6
ffffffffc0203128:	97b6                	add	a5,a5,a3
ffffffffc020312a:	14fa17e3          	bne	s4,a5,ffffffffc0203a78 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020312e:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8c00>
ffffffffc0203132:	4785                	li	a5,1
ffffffffc0203134:	12f692e3          	bne	a3,a5,ffffffffc0203a58 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203138:	00093503          	ld	a0,0(s2)
ffffffffc020313c:	77fd                	lui	a5,0xfffff
ffffffffc020313e:	6114                	ld	a3,0(a0)
ffffffffc0203140:	068a                	slli	a3,a3,0x2
ffffffffc0203142:	8efd                	and	a3,a3,a5
ffffffffc0203144:	00c6d613          	srli	a2,a3,0xc
ffffffffc0203148:	0ee67ce3          	bgeu	a2,a4,ffffffffc0203a40 <pmm_init+0xaf8>
ffffffffc020314c:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203150:	96e2                	add	a3,a3,s8
ffffffffc0203152:	0006ba83          	ld	s5,0(a3)
ffffffffc0203156:	0a8a                	slli	s5,s5,0x2
ffffffffc0203158:	00fafab3          	and	s5,s5,a5
ffffffffc020315c:	00cad793          	srli	a5,s5,0xc
ffffffffc0203160:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203a26 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203164:	4601                	li	a2,0
ffffffffc0203166:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203168:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020316a:	df8ff0ef          	jal	ra,ffffffffc0202762 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020316e:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0203170:	55551363          	bne	a0,s5,ffffffffc02036b6 <pmm_init+0x76e>
ffffffffc0203174:	100027f3          	csrr	a5,sstatus
ffffffffc0203178:	8b89                	andi	a5,a5,2
ffffffffc020317a:	3a079163          	bnez	a5,ffffffffc020351c <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc020317e:	000b3783          	ld	a5,0(s6)
ffffffffc0203182:	4505                	li	a0,1
ffffffffc0203184:	6f9c                	ld	a5,24(a5)
ffffffffc0203186:	9782                	jalr	a5
ffffffffc0203188:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020318a:	00093503          	ld	a0,0(s2)
ffffffffc020318e:	46d1                	li	a3,20
ffffffffc0203190:	6605                	lui	a2,0x1
ffffffffc0203192:	85e2                	mv	a1,s8
ffffffffc0203194:	cbfff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
ffffffffc0203198:	060517e3          	bnez	a0,ffffffffc0203a06 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020319c:	00093503          	ld	a0,0(s2)
ffffffffc02031a0:	4601                	li	a2,0
ffffffffc02031a2:	6585                	lui	a1,0x1
ffffffffc02031a4:	dbeff0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc02031a8:	02050fe3          	beqz	a0,ffffffffc02039e6 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02031ac:	611c                	ld	a5,0(a0)
ffffffffc02031ae:	0107f713          	andi	a4,a5,16
ffffffffc02031b2:	7c070e63          	beqz	a4,ffffffffc020398e <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02031b6:	8b91                	andi	a5,a5,4
ffffffffc02031b8:	7a078b63          	beqz	a5,ffffffffc020396e <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02031bc:	00093503          	ld	a0,0(s2)
ffffffffc02031c0:	611c                	ld	a5,0(a0)
ffffffffc02031c2:	8bc1                	andi	a5,a5,16
ffffffffc02031c4:	78078563          	beqz	a5,ffffffffc020394e <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02031c8:	000c2703          	lw	a4,0(s8)
ffffffffc02031cc:	4785                	li	a5,1
ffffffffc02031ce:	76f71063          	bne	a4,a5,ffffffffc020392e <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02031d2:	4681                	li	a3,0
ffffffffc02031d4:	6605                	lui	a2,0x1
ffffffffc02031d6:	85d2                	mv	a1,s4
ffffffffc02031d8:	c7bff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
ffffffffc02031dc:	72051963          	bnez	a0,ffffffffc020390e <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02031e0:	000a2703          	lw	a4,0(s4)
ffffffffc02031e4:	4789                	li	a5,2
ffffffffc02031e6:	70f71463          	bne	a4,a5,ffffffffc02038ee <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02031ea:	000c2783          	lw	a5,0(s8)
ffffffffc02031ee:	6e079063          	bnez	a5,ffffffffc02038ce <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031f2:	00093503          	ld	a0,0(s2)
ffffffffc02031f6:	4601                	li	a2,0
ffffffffc02031f8:	6585                	lui	a1,0x1
ffffffffc02031fa:	d68ff0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc02031fe:	6a050863          	beqz	a0,ffffffffc02038ae <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0203202:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0203204:	00177793          	andi	a5,a4,1
ffffffffc0203208:	4a078563          	beqz	a5,ffffffffc02036b2 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020320c:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020320e:	00271793          	slli	a5,a4,0x2
ffffffffc0203212:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203214:	48d7fd63          	bgeu	a5,a3,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203218:	000bb683          	ld	a3,0(s7)
ffffffffc020321c:	fff80ab7          	lui	s5,0xfff80
ffffffffc0203220:	97d6                	add	a5,a5,s5
ffffffffc0203222:	079a                	slli	a5,a5,0x6
ffffffffc0203224:	97b6                	add	a5,a5,a3
ffffffffc0203226:	66fa1463          	bne	s4,a5,ffffffffc020388e <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc020322a:	8b41                	andi	a4,a4,16
ffffffffc020322c:	64071163          	bnez	a4,ffffffffc020386e <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0203230:	00093503          	ld	a0,0(s2)
ffffffffc0203234:	4581                	li	a1,0
ffffffffc0203236:	b81ff0ef          	jal	ra,ffffffffc0202db6 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020323a:	000a2c83          	lw	s9,0(s4)
ffffffffc020323e:	4785                	li	a5,1
ffffffffc0203240:	60fc9763          	bne	s9,a5,ffffffffc020384e <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0203244:	000c2783          	lw	a5,0(s8)
ffffffffc0203248:	5e079363          	bnez	a5,ffffffffc020382e <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020324c:	00093503          	ld	a0,0(s2)
ffffffffc0203250:	6585                	lui	a1,0x1
ffffffffc0203252:	b65ff0ef          	jal	ra,ffffffffc0202db6 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0203256:	000a2783          	lw	a5,0(s4)
ffffffffc020325a:	52079a63          	bnez	a5,ffffffffc020378e <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc020325e:	000c2783          	lw	a5,0(s8)
ffffffffc0203262:	50079663          	bnez	a5,ffffffffc020376e <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0203266:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020326a:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020326c:	000a3683          	ld	a3,0(s4)
ffffffffc0203270:	068a                	slli	a3,a3,0x2
ffffffffc0203272:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0203274:	42b6fd63          	bgeu	a3,a1,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203278:	000bb503          	ld	a0,0(s7)
ffffffffc020327c:	96d6                	add	a3,a3,s5
ffffffffc020327e:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0203280:	00d507b3          	add	a5,a0,a3
ffffffffc0203284:	439c                	lw	a5,0(a5)
ffffffffc0203286:	4d979463          	bne	a5,s9,ffffffffc020374e <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc020328a:	8699                	srai	a3,a3,0x6
ffffffffc020328c:	00080637          	lui	a2,0x80
ffffffffc0203290:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0203292:	00c69713          	slli	a4,a3,0xc
ffffffffc0203296:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203298:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020329a:	48b77e63          	bgeu	a4,a1,ffffffffc0203736 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc020329e:	0009b703          	ld	a4,0(s3)
ffffffffc02032a2:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02032a4:	629c                	ld	a5,0(a3)
ffffffffc02032a6:	078a                	slli	a5,a5,0x2
ffffffffc02032a8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02032aa:	40b7f263          	bgeu	a5,a1,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02032ae:	8f91                	sub	a5,a5,a2
ffffffffc02032b0:	079a                	slli	a5,a5,0x6
ffffffffc02032b2:	953e                	add	a0,a0,a5
ffffffffc02032b4:	100027f3          	csrr	a5,sstatus
ffffffffc02032b8:	8b89                	andi	a5,a5,2
ffffffffc02032ba:	30079963          	bnez	a5,ffffffffc02035cc <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02032be:	000b3783          	ld	a5,0(s6)
ffffffffc02032c2:	4585                	li	a1,1
ffffffffc02032c4:	739c                	ld	a5,32(a5)
ffffffffc02032c6:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02032c8:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02032cc:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02032ce:	078a                	slli	a5,a5,0x2
ffffffffc02032d0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02032d2:	3ce7fe63          	bgeu	a5,a4,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02032d6:	000bb503          	ld	a0,0(s7)
ffffffffc02032da:	fff80737          	lui	a4,0xfff80
ffffffffc02032de:	97ba                	add	a5,a5,a4
ffffffffc02032e0:	079a                	slli	a5,a5,0x6
ffffffffc02032e2:	953e                	add	a0,a0,a5
ffffffffc02032e4:	100027f3          	csrr	a5,sstatus
ffffffffc02032e8:	8b89                	andi	a5,a5,2
ffffffffc02032ea:	2c079563          	bnez	a5,ffffffffc02035b4 <pmm_init+0x66c>
ffffffffc02032ee:	000b3783          	ld	a5,0(s6)
ffffffffc02032f2:	4585                	li	a1,1
ffffffffc02032f4:	739c                	ld	a5,32(a5)
ffffffffc02032f6:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02032f8:	00093783          	ld	a5,0(s2)
ffffffffc02032fc:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd543e4>
    asm volatile("sfence.vma");
ffffffffc0203300:	12000073          	sfence.vma
ffffffffc0203304:	100027f3          	csrr	a5,sstatus
ffffffffc0203308:	8b89                	andi	a5,a5,2
ffffffffc020330a:	28079b63          	bnez	a5,ffffffffc02035a0 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc020330e:	000b3783          	ld	a5,0(s6)
ffffffffc0203312:	779c                	ld	a5,40(a5)
ffffffffc0203314:	9782                	jalr	a5
ffffffffc0203316:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0203318:	4b441b63          	bne	s0,s4,ffffffffc02037ce <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc020331c:	00004517          	auipc	a0,0x4
ffffffffc0203320:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0206e38 <default_pmm_manager+0x470>
ffffffffc0203324:	dbdfc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0203328:	100027f3          	csrr	a5,sstatus
ffffffffc020332c:	8b89                	andi	a5,a5,2
ffffffffc020332e:	24079f63          	bnez	a5,ffffffffc020358c <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203332:	000b3783          	ld	a5,0(s6)
ffffffffc0203336:	779c                	ld	a5,40(a5)
ffffffffc0203338:	9782                	jalr	a5
ffffffffc020333a:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020333c:	6098                	ld	a4,0(s1)
ffffffffc020333e:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203342:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0203344:	00c71793          	slli	a5,a4,0xc
ffffffffc0203348:	6a05                	lui	s4,0x1
ffffffffc020334a:	02f47c63          	bgeu	s0,a5,ffffffffc0203382 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020334e:	00c45793          	srli	a5,s0,0xc
ffffffffc0203352:	00093503          	ld	a0,0(s2)
ffffffffc0203356:	2ee7ff63          	bgeu	a5,a4,ffffffffc0203654 <pmm_init+0x70c>
ffffffffc020335a:	0009b583          	ld	a1,0(s3)
ffffffffc020335e:	4601                	li	a2,0
ffffffffc0203360:	95a2                	add	a1,a1,s0
ffffffffc0203362:	c00ff0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc0203366:	32050463          	beqz	a0,ffffffffc020368e <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020336a:	611c                	ld	a5,0(a0)
ffffffffc020336c:	078a                	slli	a5,a5,0x2
ffffffffc020336e:	0157f7b3          	and	a5,a5,s5
ffffffffc0203372:	2e879e63          	bne	a5,s0,ffffffffc020366e <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0203376:	6098                	ld	a4,0(s1)
ffffffffc0203378:	9452                	add	s0,s0,s4
ffffffffc020337a:	00c71793          	slli	a5,a4,0xc
ffffffffc020337e:	fcf468e3          	bltu	s0,a5,ffffffffc020334e <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0203382:	00093783          	ld	a5,0(s2)
ffffffffc0203386:	639c                	ld	a5,0(a5)
ffffffffc0203388:	42079363          	bnez	a5,ffffffffc02037ae <pmm_init+0x866>
ffffffffc020338c:	100027f3          	csrr	a5,sstatus
ffffffffc0203390:	8b89                	andi	a5,a5,2
ffffffffc0203392:	24079963          	bnez	a5,ffffffffc02035e4 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203396:	000b3783          	ld	a5,0(s6)
ffffffffc020339a:	4505                	li	a0,1
ffffffffc020339c:	6f9c                	ld	a5,24(a5)
ffffffffc020339e:	9782                	jalr	a5
ffffffffc02033a0:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02033a2:	00093503          	ld	a0,0(s2)
ffffffffc02033a6:	4699                	li	a3,6
ffffffffc02033a8:	10000613          	li	a2,256
ffffffffc02033ac:	85d2                	mv	a1,s4
ffffffffc02033ae:	aa5ff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
ffffffffc02033b2:	44051e63          	bnez	a0,ffffffffc020380e <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc02033b6:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8c00>
ffffffffc02033ba:	4785                	li	a5,1
ffffffffc02033bc:	42f71963          	bne	a4,a5,ffffffffc02037ee <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02033c0:	00093503          	ld	a0,0(s2)
ffffffffc02033c4:	6405                	lui	s0,0x1
ffffffffc02033c6:	4699                	li	a3,6
ffffffffc02033c8:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8b00>
ffffffffc02033cc:	85d2                	mv	a1,s4
ffffffffc02033ce:	a85ff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
ffffffffc02033d2:	72051363          	bnez	a0,ffffffffc0203af8 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc02033d6:	000a2703          	lw	a4,0(s4)
ffffffffc02033da:	4789                	li	a5,2
ffffffffc02033dc:	6ef71e63          	bne	a4,a5,ffffffffc0203ad8 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02033e0:	00004597          	auipc	a1,0x4
ffffffffc02033e4:	ba058593          	addi	a1,a1,-1120 # ffffffffc0206f80 <default_pmm_manager+0x5b8>
ffffffffc02033e8:	10000513          	li	a0,256
ffffffffc02033ec:	741010ef          	jal	ra,ffffffffc020532c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02033f0:	10040593          	addi	a1,s0,256
ffffffffc02033f4:	10000513          	li	a0,256
ffffffffc02033f8:	747010ef          	jal	ra,ffffffffc020533e <strcmp>
ffffffffc02033fc:	6a051e63          	bnez	a0,ffffffffc0203ab8 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0203400:	000bb683          	ld	a3,0(s7)
ffffffffc0203404:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0203408:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc020340a:	40da06b3          	sub	a3,s4,a3
ffffffffc020340e:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203410:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0203412:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0203414:	8031                	srli	s0,s0,0xc
ffffffffc0203416:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc020341a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020341c:	30f77d63          	bgeu	a4,a5,ffffffffc0203736 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203420:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203424:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0203428:	96be                	add	a3,a3,a5
ffffffffc020342a:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020342e:	6c9010ef          	jal	ra,ffffffffc02052f6 <strlen>
ffffffffc0203432:	66051363          	bnez	a0,ffffffffc0203a98 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0203436:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020343a:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020343c:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd543e4>
ffffffffc0203440:	068a                	slli	a3,a3,0x2
ffffffffc0203442:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0203444:	26f6f563          	bgeu	a3,a5,ffffffffc02036ae <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0203448:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020344a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020344c:	2ef47563          	bgeu	s0,a5,ffffffffc0203736 <pmm_init+0x7ee>
ffffffffc0203450:	0009b403          	ld	s0,0(s3)
ffffffffc0203454:	9436                	add	s0,s0,a3
ffffffffc0203456:	100027f3          	csrr	a5,sstatus
ffffffffc020345a:	8b89                	andi	a5,a5,2
ffffffffc020345c:	1e079163          	bnez	a5,ffffffffc020363e <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0203460:	000b3783          	ld	a5,0(s6)
ffffffffc0203464:	4585                	li	a1,1
ffffffffc0203466:	8552                	mv	a0,s4
ffffffffc0203468:	739c                	ld	a5,32(a5)
ffffffffc020346a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020346c:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc020346e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203470:	078a                	slli	a5,a5,0x2
ffffffffc0203472:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203474:	22e7fd63          	bgeu	a5,a4,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0203478:	000bb503          	ld	a0,0(s7)
ffffffffc020347c:	fff80737          	lui	a4,0xfff80
ffffffffc0203480:	97ba                	add	a5,a5,a4
ffffffffc0203482:	079a                	slli	a5,a5,0x6
ffffffffc0203484:	953e                	add	a0,a0,a5
ffffffffc0203486:	100027f3          	csrr	a5,sstatus
ffffffffc020348a:	8b89                	andi	a5,a5,2
ffffffffc020348c:	18079d63          	bnez	a5,ffffffffc0203626 <pmm_init+0x6de>
ffffffffc0203490:	000b3783          	ld	a5,0(s6)
ffffffffc0203494:	4585                	li	a1,1
ffffffffc0203496:	739c                	ld	a5,32(a5)
ffffffffc0203498:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020349a:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc020349e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02034a0:	078a                	slli	a5,a5,0x2
ffffffffc02034a2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02034a4:	20e7f563          	bgeu	a5,a4,ffffffffc02036ae <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02034a8:	000bb503          	ld	a0,0(s7)
ffffffffc02034ac:	fff80737          	lui	a4,0xfff80
ffffffffc02034b0:	97ba                	add	a5,a5,a4
ffffffffc02034b2:	079a                	slli	a5,a5,0x6
ffffffffc02034b4:	953e                	add	a0,a0,a5
ffffffffc02034b6:	100027f3          	csrr	a5,sstatus
ffffffffc02034ba:	8b89                	andi	a5,a5,2
ffffffffc02034bc:	14079963          	bnez	a5,ffffffffc020360e <pmm_init+0x6c6>
ffffffffc02034c0:	000b3783          	ld	a5,0(s6)
ffffffffc02034c4:	4585                	li	a1,1
ffffffffc02034c6:	739c                	ld	a5,32(a5)
ffffffffc02034c8:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02034ca:	00093783          	ld	a5,0(s2)
ffffffffc02034ce:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc02034d2:	12000073          	sfence.vma
ffffffffc02034d6:	100027f3          	csrr	a5,sstatus
ffffffffc02034da:	8b89                	andi	a5,a5,2
ffffffffc02034dc:	10079f63          	bnez	a5,ffffffffc02035fa <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc02034e0:	000b3783          	ld	a5,0(s6)
ffffffffc02034e4:	779c                	ld	a5,40(a5)
ffffffffc02034e6:	9782                	jalr	a5
ffffffffc02034e8:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02034ea:	4c8c1e63          	bne	s8,s0,ffffffffc02039c6 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02034ee:	00004517          	auipc	a0,0x4
ffffffffc02034f2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc0206ff8 <default_pmm_manager+0x630>
ffffffffc02034f6:	bebfc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc02034fa:	7406                	ld	s0,96(sp)
ffffffffc02034fc:	70a6                	ld	ra,104(sp)
ffffffffc02034fe:	64e6                	ld	s1,88(sp)
ffffffffc0203500:	6946                	ld	s2,80(sp)
ffffffffc0203502:	69a6                	ld	s3,72(sp)
ffffffffc0203504:	6a06                	ld	s4,64(sp)
ffffffffc0203506:	7ae2                	ld	s5,56(sp)
ffffffffc0203508:	7b42                	ld	s6,48(sp)
ffffffffc020350a:	7ba2                	ld	s7,40(sp)
ffffffffc020350c:	7c02                	ld	s8,32(sp)
ffffffffc020350e:	6ce2                	ld	s9,24(sp)
ffffffffc0203510:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0203512:	ce8fe06f          	j	ffffffffc02019fa <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0203516:	c80007b7          	lui	a5,0xc8000
ffffffffc020351a:	bc7d                	j	ffffffffc0202fd8 <pmm_init+0x90>
        intr_disable();
ffffffffc020351c:	c9efd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203520:	000b3783          	ld	a5,0(s6)
ffffffffc0203524:	4505                	li	a0,1
ffffffffc0203526:	6f9c                	ld	a5,24(a5)
ffffffffc0203528:	9782                	jalr	a5
ffffffffc020352a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020352c:	c88fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203530:	b9a9                	j	ffffffffc020318a <pmm_init+0x242>
        intr_disable();
ffffffffc0203532:	c88fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0203536:	000b3783          	ld	a5,0(s6)
ffffffffc020353a:	4505                	li	a0,1
ffffffffc020353c:	6f9c                	ld	a5,24(a5)
ffffffffc020353e:	9782                	jalr	a5
ffffffffc0203540:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203542:	c72fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203546:	b645                	j	ffffffffc02030e6 <pmm_init+0x19e>
        intr_disable();
ffffffffc0203548:	c72fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020354c:	000b3783          	ld	a5,0(s6)
ffffffffc0203550:	779c                	ld	a5,40(a5)
ffffffffc0203552:	9782                	jalr	a5
ffffffffc0203554:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203556:	c5efd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020355a:	b6b9                	j	ffffffffc02030a8 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020355c:	6705                	lui	a4,0x1
ffffffffc020355e:	177d                	addi	a4,a4,-1
ffffffffc0203560:	96ba                	add	a3,a3,a4
ffffffffc0203562:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0203564:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203568:	14a77363          	bgeu	a4,a0,ffffffffc02036ae <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc020356c:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0203570:	fff80537          	lui	a0,0xfff80
ffffffffc0203574:	972a                	add	a4,a4,a0
ffffffffc0203576:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0203578:	8c1d                	sub	s0,s0,a5
ffffffffc020357a:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc020357e:	00c45593          	srli	a1,s0,0xc
ffffffffc0203582:	9532                	add	a0,a0,a2
ffffffffc0203584:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0203586:	0009b583          	ld	a1,0(s3)
}
ffffffffc020358a:	b4c1                	j	ffffffffc020304a <pmm_init+0x102>
        intr_disable();
ffffffffc020358c:	c2efd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0203590:	000b3783          	ld	a5,0(s6)
ffffffffc0203594:	779c                	ld	a5,40(a5)
ffffffffc0203596:	9782                	jalr	a5
ffffffffc0203598:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020359a:	c1afd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020359e:	bb79                	j	ffffffffc020333c <pmm_init+0x3f4>
        intr_disable();
ffffffffc02035a0:	c1afd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc02035a4:	000b3783          	ld	a5,0(s6)
ffffffffc02035a8:	779c                	ld	a5,40(a5)
ffffffffc02035aa:	9782                	jalr	a5
ffffffffc02035ac:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02035ae:	c06fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02035b2:	b39d                	j	ffffffffc0203318 <pmm_init+0x3d0>
ffffffffc02035b4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035b6:	c04fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02035ba:	000b3783          	ld	a5,0(s6)
ffffffffc02035be:	6522                	ld	a0,8(sp)
ffffffffc02035c0:	4585                	li	a1,1
ffffffffc02035c2:	739c                	ld	a5,32(a5)
ffffffffc02035c4:	9782                	jalr	a5
        intr_enable();
ffffffffc02035c6:	beefd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02035ca:	b33d                	j	ffffffffc02032f8 <pmm_init+0x3b0>
ffffffffc02035cc:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035ce:	becfd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc02035d2:	000b3783          	ld	a5,0(s6)
ffffffffc02035d6:	6522                	ld	a0,8(sp)
ffffffffc02035d8:	4585                	li	a1,1
ffffffffc02035da:	739c                	ld	a5,32(a5)
ffffffffc02035dc:	9782                	jalr	a5
        intr_enable();
ffffffffc02035de:	bd6fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02035e2:	b1dd                	j	ffffffffc02032c8 <pmm_init+0x380>
        intr_disable();
ffffffffc02035e4:	bd6fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035e8:	000b3783          	ld	a5,0(s6)
ffffffffc02035ec:	4505                	li	a0,1
ffffffffc02035ee:	6f9c                	ld	a5,24(a5)
ffffffffc02035f0:	9782                	jalr	a5
ffffffffc02035f2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02035f4:	bc0fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02035f8:	b36d                	j	ffffffffc02033a2 <pmm_init+0x45a>
        intr_disable();
ffffffffc02035fa:	bc0fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02035fe:	000b3783          	ld	a5,0(s6)
ffffffffc0203602:	779c                	ld	a5,40(a5)
ffffffffc0203604:	9782                	jalr	a5
ffffffffc0203606:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203608:	bacfd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020360c:	bdf9                	j	ffffffffc02034ea <pmm_init+0x5a2>
ffffffffc020360e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203610:	baafd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0203614:	000b3783          	ld	a5,0(s6)
ffffffffc0203618:	6522                	ld	a0,8(sp)
ffffffffc020361a:	4585                	li	a1,1
ffffffffc020361c:	739c                	ld	a5,32(a5)
ffffffffc020361e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203620:	b94fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203624:	b55d                	j	ffffffffc02034ca <pmm_init+0x582>
ffffffffc0203626:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203628:	b92fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc020362c:	000b3783          	ld	a5,0(s6)
ffffffffc0203630:	6522                	ld	a0,8(sp)
ffffffffc0203632:	4585                	li	a1,1
ffffffffc0203634:	739c                	ld	a5,32(a5)
ffffffffc0203636:	9782                	jalr	a5
        intr_enable();
ffffffffc0203638:	b7cfd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020363c:	bdb9                	j	ffffffffc020349a <pmm_init+0x552>
        intr_disable();
ffffffffc020363e:	b7cfd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0203642:	000b3783          	ld	a5,0(s6)
ffffffffc0203646:	4585                	li	a1,1
ffffffffc0203648:	8552                	mv	a0,s4
ffffffffc020364a:	739c                	ld	a5,32(a5)
ffffffffc020364c:	9782                	jalr	a5
        intr_enable();
ffffffffc020364e:	b66fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203652:	bd29                	j	ffffffffc020346c <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203654:	86a2                	mv	a3,s0
ffffffffc0203656:	00003617          	auipc	a2,0x3
ffffffffc020365a:	eda60613          	addi	a2,a2,-294 # ffffffffc0206530 <commands+0xac0>
ffffffffc020365e:	24f00593          	li	a1,591
ffffffffc0203662:	00003517          	auipc	a0,0x3
ffffffffc0203666:	3c650513          	addi	a0,a0,966 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020366a:	bb5fc0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020366e:	00004697          	auipc	a3,0x4
ffffffffc0203672:	82a68693          	addi	a3,a3,-2006 # ffffffffc0206e98 <default_pmm_manager+0x4d0>
ffffffffc0203676:	00003617          	auipc	a2,0x3
ffffffffc020367a:	c4260613          	addi	a2,a2,-958 # ffffffffc02062b8 <commands+0x848>
ffffffffc020367e:	25000593          	li	a1,592
ffffffffc0203682:	00003517          	auipc	a0,0x3
ffffffffc0203686:	3a650513          	addi	a0,a0,934 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020368a:	b95fc0ef          	jal	ra,ffffffffc020021e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020368e:	00003697          	auipc	a3,0x3
ffffffffc0203692:	7ca68693          	addi	a3,a3,1994 # ffffffffc0206e58 <default_pmm_manager+0x490>
ffffffffc0203696:	00003617          	auipc	a2,0x3
ffffffffc020369a:	c2260613          	addi	a2,a2,-990 # ffffffffc02062b8 <commands+0x848>
ffffffffc020369e:	24f00593          	li	a1,591
ffffffffc02036a2:	00003517          	auipc	a0,0x3
ffffffffc02036a6:	38650513          	addi	a0,a0,902 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02036aa:	b75fc0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc02036ae:	fc5fe0ef          	jal	ra,ffffffffc0202672 <pa2page.part.0>
ffffffffc02036b2:	fddfe0ef          	jal	ra,ffffffffc020268e <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02036b6:	00003697          	auipc	a3,0x3
ffffffffc02036ba:	59a68693          	addi	a3,a3,1434 # ffffffffc0206c50 <default_pmm_manager+0x288>
ffffffffc02036be:	00003617          	auipc	a2,0x3
ffffffffc02036c2:	bfa60613          	addi	a2,a2,-1030 # ffffffffc02062b8 <commands+0x848>
ffffffffc02036c6:	21f00593          	li	a1,543
ffffffffc02036ca:	00003517          	auipc	a0,0x3
ffffffffc02036ce:	35e50513          	addi	a0,a0,862 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02036d2:	b4dfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02036d6:	00003697          	auipc	a3,0x3
ffffffffc02036da:	4ba68693          	addi	a3,a3,1210 # ffffffffc0206b90 <default_pmm_manager+0x1c8>
ffffffffc02036de:	00003617          	auipc	a2,0x3
ffffffffc02036e2:	bda60613          	addi	a2,a2,-1062 # ffffffffc02062b8 <commands+0x848>
ffffffffc02036e6:	21200593          	li	a1,530
ffffffffc02036ea:	00003517          	auipc	a0,0x3
ffffffffc02036ee:	33e50513          	addi	a0,a0,830 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02036f2:	b2dfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02036f6:	00003697          	auipc	a3,0x3
ffffffffc02036fa:	45a68693          	addi	a3,a3,1114 # ffffffffc0206b50 <default_pmm_manager+0x188>
ffffffffc02036fe:	00003617          	auipc	a2,0x3
ffffffffc0203702:	bba60613          	addi	a2,a2,-1094 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203706:	21100593          	li	a1,529
ffffffffc020370a:	00003517          	auipc	a0,0x3
ffffffffc020370e:	31e50513          	addi	a0,a0,798 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203712:	b0dfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203716:	00003697          	auipc	a3,0x3
ffffffffc020371a:	41a68693          	addi	a3,a3,1050 # ffffffffc0206b30 <default_pmm_manager+0x168>
ffffffffc020371e:	00003617          	auipc	a2,0x3
ffffffffc0203722:	b9a60613          	addi	a2,a2,-1126 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203726:	21000593          	li	a1,528
ffffffffc020372a:	00003517          	auipc	a0,0x3
ffffffffc020372e:	2fe50513          	addi	a0,a0,766 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203732:	aedfc0ef          	jal	ra,ffffffffc020021e <__panic>
    return KADDR(page2pa(page));
ffffffffc0203736:	00003617          	auipc	a2,0x3
ffffffffc020373a:	dfa60613          	addi	a2,a2,-518 # ffffffffc0206530 <commands+0xac0>
ffffffffc020373e:	07100593          	li	a1,113
ffffffffc0203742:	00003517          	auipc	a0,0x3
ffffffffc0203746:	e1650513          	addi	a0,a0,-490 # ffffffffc0206558 <commands+0xae8>
ffffffffc020374a:	ad5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc020374e:	00003697          	auipc	a3,0x3
ffffffffc0203752:	69268693          	addi	a3,a3,1682 # ffffffffc0206de0 <default_pmm_manager+0x418>
ffffffffc0203756:	00003617          	auipc	a2,0x3
ffffffffc020375a:	b6260613          	addi	a2,a2,-1182 # ffffffffc02062b8 <commands+0x848>
ffffffffc020375e:	23800593          	li	a1,568
ffffffffc0203762:	00003517          	auipc	a0,0x3
ffffffffc0203766:	2c650513          	addi	a0,a0,710 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020376a:	ab5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020376e:	00003697          	auipc	a3,0x3
ffffffffc0203772:	62a68693          	addi	a3,a3,1578 # ffffffffc0206d98 <default_pmm_manager+0x3d0>
ffffffffc0203776:	00003617          	auipc	a2,0x3
ffffffffc020377a:	b4260613          	addi	a2,a2,-1214 # ffffffffc02062b8 <commands+0x848>
ffffffffc020377e:	23600593          	li	a1,566
ffffffffc0203782:	00003517          	auipc	a0,0x3
ffffffffc0203786:	2a650513          	addi	a0,a0,678 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020378a:	a95fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc020378e:	00003697          	auipc	a3,0x3
ffffffffc0203792:	63a68693          	addi	a3,a3,1594 # ffffffffc0206dc8 <default_pmm_manager+0x400>
ffffffffc0203796:	00003617          	auipc	a2,0x3
ffffffffc020379a:	b2260613          	addi	a2,a2,-1246 # ffffffffc02062b8 <commands+0x848>
ffffffffc020379e:	23500593          	li	a1,565
ffffffffc02037a2:	00003517          	auipc	a0,0x3
ffffffffc02037a6:	28650513          	addi	a0,a0,646 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02037aa:	a75fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02037ae:	00003697          	auipc	a3,0x3
ffffffffc02037b2:	70268693          	addi	a3,a3,1794 # ffffffffc0206eb0 <default_pmm_manager+0x4e8>
ffffffffc02037b6:	00003617          	auipc	a2,0x3
ffffffffc02037ba:	b0260613          	addi	a2,a2,-1278 # ffffffffc02062b8 <commands+0x848>
ffffffffc02037be:	25300593          	li	a1,595
ffffffffc02037c2:	00003517          	auipc	a0,0x3
ffffffffc02037c6:	26650513          	addi	a0,a0,614 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02037ca:	a55fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02037ce:	00003697          	auipc	a3,0x3
ffffffffc02037d2:	64268693          	addi	a3,a3,1602 # ffffffffc0206e10 <default_pmm_manager+0x448>
ffffffffc02037d6:	00003617          	auipc	a2,0x3
ffffffffc02037da:	ae260613          	addi	a2,a2,-1310 # ffffffffc02062b8 <commands+0x848>
ffffffffc02037de:	24000593          	li	a1,576
ffffffffc02037e2:	00003517          	auipc	a0,0x3
ffffffffc02037e6:	24650513          	addi	a0,a0,582 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02037ea:	a35fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p) == 1);
ffffffffc02037ee:	00003697          	auipc	a3,0x3
ffffffffc02037f2:	71a68693          	addi	a3,a3,1818 # ffffffffc0206f08 <default_pmm_manager+0x540>
ffffffffc02037f6:	00003617          	auipc	a2,0x3
ffffffffc02037fa:	ac260613          	addi	a2,a2,-1342 # ffffffffc02062b8 <commands+0x848>
ffffffffc02037fe:	25800593          	li	a1,600
ffffffffc0203802:	00003517          	auipc	a0,0x3
ffffffffc0203806:	22650513          	addi	a0,a0,550 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020380a:	a15fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020380e:	00003697          	auipc	a3,0x3
ffffffffc0203812:	6ba68693          	addi	a3,a3,1722 # ffffffffc0206ec8 <default_pmm_manager+0x500>
ffffffffc0203816:	00003617          	auipc	a2,0x3
ffffffffc020381a:	aa260613          	addi	a2,a2,-1374 # ffffffffc02062b8 <commands+0x848>
ffffffffc020381e:	25700593          	li	a1,599
ffffffffc0203822:	00003517          	auipc	a0,0x3
ffffffffc0203826:	20650513          	addi	a0,a0,518 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020382a:	9f5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020382e:	00003697          	auipc	a3,0x3
ffffffffc0203832:	56a68693          	addi	a3,a3,1386 # ffffffffc0206d98 <default_pmm_manager+0x3d0>
ffffffffc0203836:	00003617          	auipc	a2,0x3
ffffffffc020383a:	a8260613          	addi	a2,a2,-1406 # ffffffffc02062b8 <commands+0x848>
ffffffffc020383e:	23200593          	li	a1,562
ffffffffc0203842:	00003517          	auipc	a0,0x3
ffffffffc0203846:	1e650513          	addi	a0,a0,486 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020384a:	9d5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020384e:	00003697          	auipc	a3,0x3
ffffffffc0203852:	3ea68693          	addi	a3,a3,1002 # ffffffffc0206c38 <default_pmm_manager+0x270>
ffffffffc0203856:	00003617          	auipc	a2,0x3
ffffffffc020385a:	a6260613          	addi	a2,a2,-1438 # ffffffffc02062b8 <commands+0x848>
ffffffffc020385e:	23100593          	li	a1,561
ffffffffc0203862:	00003517          	auipc	a0,0x3
ffffffffc0203866:	1c650513          	addi	a0,a0,454 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020386a:	9b5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc020386e:	00003697          	auipc	a3,0x3
ffffffffc0203872:	54268693          	addi	a3,a3,1346 # ffffffffc0206db0 <default_pmm_manager+0x3e8>
ffffffffc0203876:	00003617          	auipc	a2,0x3
ffffffffc020387a:	a4260613          	addi	a2,a2,-1470 # ffffffffc02062b8 <commands+0x848>
ffffffffc020387e:	22e00593          	li	a1,558
ffffffffc0203882:	00003517          	auipc	a0,0x3
ffffffffc0203886:	1a650513          	addi	a0,a0,422 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020388a:	995fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020388e:	00003697          	auipc	a3,0x3
ffffffffc0203892:	39268693          	addi	a3,a3,914 # ffffffffc0206c20 <default_pmm_manager+0x258>
ffffffffc0203896:	00003617          	auipc	a2,0x3
ffffffffc020389a:	a2260613          	addi	a2,a2,-1502 # ffffffffc02062b8 <commands+0x848>
ffffffffc020389e:	22d00593          	li	a1,557
ffffffffc02038a2:	00003517          	auipc	a0,0x3
ffffffffc02038a6:	18650513          	addi	a0,a0,390 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02038aa:	975fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02038ae:	00003697          	auipc	a3,0x3
ffffffffc02038b2:	41268693          	addi	a3,a3,1042 # ffffffffc0206cc0 <default_pmm_manager+0x2f8>
ffffffffc02038b6:	00003617          	auipc	a2,0x3
ffffffffc02038ba:	a0260613          	addi	a2,a2,-1534 # ffffffffc02062b8 <commands+0x848>
ffffffffc02038be:	22c00593          	li	a1,556
ffffffffc02038c2:	00003517          	auipc	a0,0x3
ffffffffc02038c6:	16650513          	addi	a0,a0,358 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02038ca:	955fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02038ce:	00003697          	auipc	a3,0x3
ffffffffc02038d2:	4ca68693          	addi	a3,a3,1226 # ffffffffc0206d98 <default_pmm_manager+0x3d0>
ffffffffc02038d6:	00003617          	auipc	a2,0x3
ffffffffc02038da:	9e260613          	addi	a2,a2,-1566 # ffffffffc02062b8 <commands+0x848>
ffffffffc02038de:	22b00593          	li	a1,555
ffffffffc02038e2:	00003517          	auipc	a0,0x3
ffffffffc02038e6:	14650513          	addi	a0,a0,326 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02038ea:	935fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02038ee:	00003697          	auipc	a3,0x3
ffffffffc02038f2:	49268693          	addi	a3,a3,1170 # ffffffffc0206d80 <default_pmm_manager+0x3b8>
ffffffffc02038f6:	00003617          	auipc	a2,0x3
ffffffffc02038fa:	9c260613          	addi	a2,a2,-1598 # ffffffffc02062b8 <commands+0x848>
ffffffffc02038fe:	22a00593          	li	a1,554
ffffffffc0203902:	00003517          	auipc	a0,0x3
ffffffffc0203906:	12650513          	addi	a0,a0,294 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020390a:	915fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020390e:	00003697          	auipc	a3,0x3
ffffffffc0203912:	44268693          	addi	a3,a3,1090 # ffffffffc0206d50 <default_pmm_manager+0x388>
ffffffffc0203916:	00003617          	auipc	a2,0x3
ffffffffc020391a:	9a260613          	addi	a2,a2,-1630 # ffffffffc02062b8 <commands+0x848>
ffffffffc020391e:	22900593          	li	a1,553
ffffffffc0203922:	00003517          	auipc	a0,0x3
ffffffffc0203926:	10650513          	addi	a0,a0,262 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020392a:	8f5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020392e:	00003697          	auipc	a3,0x3
ffffffffc0203932:	40a68693          	addi	a3,a3,1034 # ffffffffc0206d38 <default_pmm_manager+0x370>
ffffffffc0203936:	00003617          	auipc	a2,0x3
ffffffffc020393a:	98260613          	addi	a2,a2,-1662 # ffffffffc02062b8 <commands+0x848>
ffffffffc020393e:	22700593          	li	a1,551
ffffffffc0203942:	00003517          	auipc	a0,0x3
ffffffffc0203946:	0e650513          	addi	a0,a0,230 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020394a:	8d5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020394e:	00003697          	auipc	a3,0x3
ffffffffc0203952:	3ca68693          	addi	a3,a3,970 # ffffffffc0206d18 <default_pmm_manager+0x350>
ffffffffc0203956:	00003617          	auipc	a2,0x3
ffffffffc020395a:	96260613          	addi	a2,a2,-1694 # ffffffffc02062b8 <commands+0x848>
ffffffffc020395e:	22600593          	li	a1,550
ffffffffc0203962:	00003517          	auipc	a0,0x3
ffffffffc0203966:	0c650513          	addi	a0,a0,198 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020396a:	8b5fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(*ptep & PTE_W);
ffffffffc020396e:	00003697          	auipc	a3,0x3
ffffffffc0203972:	39a68693          	addi	a3,a3,922 # ffffffffc0206d08 <default_pmm_manager+0x340>
ffffffffc0203976:	00003617          	auipc	a2,0x3
ffffffffc020397a:	94260613          	addi	a2,a2,-1726 # ffffffffc02062b8 <commands+0x848>
ffffffffc020397e:	22500593          	li	a1,549
ffffffffc0203982:	00003517          	auipc	a0,0x3
ffffffffc0203986:	0a650513          	addi	a0,a0,166 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc020398a:	895fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(*ptep & PTE_U);
ffffffffc020398e:	00003697          	auipc	a3,0x3
ffffffffc0203992:	36a68693          	addi	a3,a3,874 # ffffffffc0206cf8 <default_pmm_manager+0x330>
ffffffffc0203996:	00003617          	auipc	a2,0x3
ffffffffc020399a:	92260613          	addi	a2,a2,-1758 # ffffffffc02062b8 <commands+0x848>
ffffffffc020399e:	22400593          	li	a1,548
ffffffffc02039a2:	00003517          	auipc	a0,0x3
ffffffffc02039a6:	08650513          	addi	a0,a0,134 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02039aa:	875fc0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("DTB memory info not available");
ffffffffc02039ae:	00003617          	auipc	a2,0x3
ffffffffc02039b2:	0ea60613          	addi	a2,a2,234 # ffffffffc0206a98 <default_pmm_manager+0xd0>
ffffffffc02039b6:	06500593          	li	a1,101
ffffffffc02039ba:	00003517          	auipc	a0,0x3
ffffffffc02039be:	06e50513          	addi	a0,a0,110 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02039c2:	85dfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02039c6:	00003697          	auipc	a3,0x3
ffffffffc02039ca:	44a68693          	addi	a3,a3,1098 # ffffffffc0206e10 <default_pmm_manager+0x448>
ffffffffc02039ce:	00003617          	auipc	a2,0x3
ffffffffc02039d2:	8ea60613          	addi	a2,a2,-1814 # ffffffffc02062b8 <commands+0x848>
ffffffffc02039d6:	26a00593          	li	a1,618
ffffffffc02039da:	00003517          	auipc	a0,0x3
ffffffffc02039de:	04e50513          	addi	a0,a0,78 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc02039e2:	83dfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02039e6:	00003697          	auipc	a3,0x3
ffffffffc02039ea:	2da68693          	addi	a3,a3,730 # ffffffffc0206cc0 <default_pmm_manager+0x2f8>
ffffffffc02039ee:	00003617          	auipc	a2,0x3
ffffffffc02039f2:	8ca60613          	addi	a2,a2,-1846 # ffffffffc02062b8 <commands+0x848>
ffffffffc02039f6:	22300593          	li	a1,547
ffffffffc02039fa:	00003517          	auipc	a0,0x3
ffffffffc02039fe:	02e50513          	addi	a0,a0,46 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203a02:	81dfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203a06:	00003697          	auipc	a3,0x3
ffffffffc0203a0a:	27a68693          	addi	a3,a3,634 # ffffffffc0206c80 <default_pmm_manager+0x2b8>
ffffffffc0203a0e:	00003617          	auipc	a2,0x3
ffffffffc0203a12:	8aa60613          	addi	a2,a2,-1878 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203a16:	22200593          	li	a1,546
ffffffffc0203a1a:	00003517          	auipc	a0,0x3
ffffffffc0203a1e:	00e50513          	addi	a0,a0,14 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203a22:	ffcfc0ef          	jal	ra,ffffffffc020021e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203a26:	86d6                	mv	a3,s5
ffffffffc0203a28:	00003617          	auipc	a2,0x3
ffffffffc0203a2c:	b0860613          	addi	a2,a2,-1272 # ffffffffc0206530 <commands+0xac0>
ffffffffc0203a30:	21e00593          	li	a1,542
ffffffffc0203a34:	00003517          	auipc	a0,0x3
ffffffffc0203a38:	ff450513          	addi	a0,a0,-12 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203a3c:	fe2fc0ef          	jal	ra,ffffffffc020021e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0203a40:	00003617          	auipc	a2,0x3
ffffffffc0203a44:	af060613          	addi	a2,a2,-1296 # ffffffffc0206530 <commands+0xac0>
ffffffffc0203a48:	21d00593          	li	a1,541
ffffffffc0203a4c:	00003517          	auipc	a0,0x3
ffffffffc0203a50:	fdc50513          	addi	a0,a0,-36 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203a54:	fcafc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203a58:	00003697          	auipc	a3,0x3
ffffffffc0203a5c:	1e068693          	addi	a3,a3,480 # ffffffffc0206c38 <default_pmm_manager+0x270>
ffffffffc0203a60:	00003617          	auipc	a2,0x3
ffffffffc0203a64:	85860613          	addi	a2,a2,-1960 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203a68:	21b00593          	li	a1,539
ffffffffc0203a6c:	00003517          	auipc	a0,0x3
ffffffffc0203a70:	fbc50513          	addi	a0,a0,-68 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203a74:	faafc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203a78:	00003697          	auipc	a3,0x3
ffffffffc0203a7c:	1a868693          	addi	a3,a3,424 # ffffffffc0206c20 <default_pmm_manager+0x258>
ffffffffc0203a80:	00003617          	auipc	a2,0x3
ffffffffc0203a84:	83860613          	addi	a2,a2,-1992 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203a88:	21a00593          	li	a1,538
ffffffffc0203a8c:	00003517          	auipc	a0,0x3
ffffffffc0203a90:	f9c50513          	addi	a0,a0,-100 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203a94:	f8afc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203a98:	00003697          	auipc	a3,0x3
ffffffffc0203a9c:	53868693          	addi	a3,a3,1336 # ffffffffc0206fd0 <default_pmm_manager+0x608>
ffffffffc0203aa0:	00003617          	auipc	a2,0x3
ffffffffc0203aa4:	81860613          	addi	a2,a2,-2024 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203aa8:	26100593          	li	a1,609
ffffffffc0203aac:	00003517          	auipc	a0,0x3
ffffffffc0203ab0:	f7c50513          	addi	a0,a0,-132 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203ab4:	f6afc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203ab8:	00003697          	auipc	a3,0x3
ffffffffc0203abc:	4e068693          	addi	a3,a3,1248 # ffffffffc0206f98 <default_pmm_manager+0x5d0>
ffffffffc0203ac0:	00002617          	auipc	a2,0x2
ffffffffc0203ac4:	7f860613          	addi	a2,a2,2040 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203ac8:	25e00593          	li	a1,606
ffffffffc0203acc:	00003517          	auipc	a0,0x3
ffffffffc0203ad0:	f5c50513          	addi	a0,a0,-164 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203ad4:	f4afc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203ad8:	00003697          	auipc	a3,0x3
ffffffffc0203adc:	49068693          	addi	a3,a3,1168 # ffffffffc0206f68 <default_pmm_manager+0x5a0>
ffffffffc0203ae0:	00002617          	auipc	a2,0x2
ffffffffc0203ae4:	7d860613          	addi	a2,a2,2008 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203ae8:	25a00593          	li	a1,602
ffffffffc0203aec:	00003517          	auipc	a0,0x3
ffffffffc0203af0:	f3c50513          	addi	a0,a0,-196 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203af4:	f2afc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203af8:	00003697          	auipc	a3,0x3
ffffffffc0203afc:	42868693          	addi	a3,a3,1064 # ffffffffc0206f20 <default_pmm_manager+0x558>
ffffffffc0203b00:	00002617          	auipc	a2,0x2
ffffffffc0203b04:	7b860613          	addi	a2,a2,1976 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203b08:	25900593          	li	a1,601
ffffffffc0203b0c:	00003517          	auipc	a0,0x3
ffffffffc0203b10:	f1c50513          	addi	a0,a0,-228 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203b14:	f0afc0ef          	jal	ra,ffffffffc020021e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203b18:	00003617          	auipc	a2,0x3
ffffffffc0203b1c:	ac060613          	addi	a2,a2,-1344 # ffffffffc02065d8 <commands+0xb68>
ffffffffc0203b20:	0c900593          	li	a1,201
ffffffffc0203b24:	00003517          	auipc	a0,0x3
ffffffffc0203b28:	f0450513          	addi	a0,a0,-252 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203b2c:	ef2fc0ef          	jal	ra,ffffffffc020021e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203b30:	00003617          	auipc	a2,0x3
ffffffffc0203b34:	aa860613          	addi	a2,a2,-1368 # ffffffffc02065d8 <commands+0xb68>
ffffffffc0203b38:	08100593          	li	a1,129
ffffffffc0203b3c:	00003517          	auipc	a0,0x3
ffffffffc0203b40:	eec50513          	addi	a0,a0,-276 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203b44:	edafc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203b48:	00003697          	auipc	a3,0x3
ffffffffc0203b4c:	0a868693          	addi	a3,a3,168 # ffffffffc0206bf0 <default_pmm_manager+0x228>
ffffffffc0203b50:	00002617          	auipc	a2,0x2
ffffffffc0203b54:	76860613          	addi	a2,a2,1896 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203b58:	21900593          	li	a1,537
ffffffffc0203b5c:	00003517          	auipc	a0,0x3
ffffffffc0203b60:	ecc50513          	addi	a0,a0,-308 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203b64:	ebafc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203b68:	00003697          	auipc	a3,0x3
ffffffffc0203b6c:	05868693          	addi	a3,a3,88 # ffffffffc0206bc0 <default_pmm_manager+0x1f8>
ffffffffc0203b70:	00002617          	auipc	a2,0x2
ffffffffc0203b74:	74860613          	addi	a2,a2,1864 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203b78:	21600593          	li	a1,534
ffffffffc0203b7c:	00003517          	auipc	a0,0x3
ffffffffc0203b80:	eac50513          	addi	a0,a0,-340 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203b84:	e9afc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203b88 <copy_range>:
{
ffffffffc0203b88:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203b8a:	00d667b3          	or	a5,a2,a3
{
ffffffffc0203b8e:	f486                	sd	ra,104(sp)
ffffffffc0203b90:	f0a2                	sd	s0,96(sp)
ffffffffc0203b92:	eca6                	sd	s1,88(sp)
ffffffffc0203b94:	e8ca                	sd	s2,80(sp)
ffffffffc0203b96:	e4ce                	sd	s3,72(sp)
ffffffffc0203b98:	e0d2                	sd	s4,64(sp)
ffffffffc0203b9a:	fc56                	sd	s5,56(sp)
ffffffffc0203b9c:	f85a                	sd	s6,48(sp)
ffffffffc0203b9e:	f45e                	sd	s7,40(sp)
ffffffffc0203ba0:	f062                	sd	s8,32(sp)
ffffffffc0203ba2:	ec66                	sd	s9,24(sp)
ffffffffc0203ba4:	e86a                	sd	s10,16(sp)
ffffffffc0203ba6:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203ba8:	17d2                	slli	a5,a5,0x34
ffffffffc0203baa:	20079f63          	bnez	a5,ffffffffc0203dc8 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc0203bae:	002007b7          	lui	a5,0x200
ffffffffc0203bb2:	8432                	mv	s0,a2
ffffffffc0203bb4:	1af66263          	bltu	a2,a5,ffffffffc0203d58 <copy_range+0x1d0>
ffffffffc0203bb8:	8936                	mv	s2,a3
ffffffffc0203bba:	18d67f63          	bgeu	a2,a3,ffffffffc0203d58 <copy_range+0x1d0>
ffffffffc0203bbe:	4785                	li	a5,1
ffffffffc0203bc0:	07fe                	slli	a5,a5,0x1f
ffffffffc0203bc2:	18d7eb63          	bltu	a5,a3,ffffffffc0203d58 <copy_range+0x1d0>
ffffffffc0203bc6:	5b7d                	li	s6,-1
ffffffffc0203bc8:	8aaa                	mv	s5,a0
ffffffffc0203bca:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc0203bcc:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0203bce:	000a7c17          	auipc	s8,0xa7
ffffffffc0203bd2:	012c0c13          	addi	s8,s8,18 # ffffffffc02aabe0 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203bd6:	000a7b97          	auipc	s7,0xa7
ffffffffc0203bda:	012b8b93          	addi	s7,s7,18 # ffffffffc02aabe8 <pages>
    return KADDR(page2pa(page));
ffffffffc0203bde:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc0203be2:	000a7c97          	auipc	s9,0xa7
ffffffffc0203be6:	00ec8c93          	addi	s9,s9,14 # ffffffffc02aabf0 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203bea:	4601                	li	a2,0
ffffffffc0203bec:	85a2                	mv	a1,s0
ffffffffc0203bee:	854e                	mv	a0,s3
ffffffffc0203bf0:	b73fe0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc0203bf4:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0203bf6:	0e050c63          	beqz	a0,ffffffffc0203cee <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc0203bfa:	611c                	ld	a5,0(a0)
ffffffffc0203bfc:	8b85                	andi	a5,a5,1
ffffffffc0203bfe:	e785                	bnez	a5,ffffffffc0203c26 <copy_range+0x9e>
        start += PGSIZE;
ffffffffc0203c00:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0203c02:	ff2464e3          	bltu	s0,s2,ffffffffc0203bea <copy_range+0x62>
    return 0;
ffffffffc0203c06:	4501                	li	a0,0
}
ffffffffc0203c08:	70a6                	ld	ra,104(sp)
ffffffffc0203c0a:	7406                	ld	s0,96(sp)
ffffffffc0203c0c:	64e6                	ld	s1,88(sp)
ffffffffc0203c0e:	6946                	ld	s2,80(sp)
ffffffffc0203c10:	69a6                	ld	s3,72(sp)
ffffffffc0203c12:	6a06                	ld	s4,64(sp)
ffffffffc0203c14:	7ae2                	ld	s5,56(sp)
ffffffffc0203c16:	7b42                	ld	s6,48(sp)
ffffffffc0203c18:	7ba2                	ld	s7,40(sp)
ffffffffc0203c1a:	7c02                	ld	s8,32(sp)
ffffffffc0203c1c:	6ce2                	ld	s9,24(sp)
ffffffffc0203c1e:	6d42                	ld	s10,16(sp)
ffffffffc0203c20:	6da2                	ld	s11,8(sp)
ffffffffc0203c22:	6165                	addi	sp,sp,112
ffffffffc0203c24:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203c26:	4605                	li	a2,1
ffffffffc0203c28:	85a2                	mv	a1,s0
ffffffffc0203c2a:	8556                	mv	a0,s5
ffffffffc0203c2c:	b37fe0ef          	jal	ra,ffffffffc0202762 <get_pte>
ffffffffc0203c30:	c56d                	beqz	a0,ffffffffc0203d1a <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203c32:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc0203c34:	0017f713          	andi	a4,a5,1
ffffffffc0203c38:	01f7f493          	andi	s1,a5,31
ffffffffc0203c3c:	16070a63          	beqz	a4,ffffffffc0203db0 <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc0203c40:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203c44:	078a                	slli	a5,a5,0x2
ffffffffc0203c46:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0203c4a:	14d77763          	bgeu	a4,a3,ffffffffc0203d98 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0203c4e:	000bb783          	ld	a5,0(s7)
ffffffffc0203c52:	fff806b7          	lui	a3,0xfff80
ffffffffc0203c56:	9736                	add	a4,a4,a3
ffffffffc0203c58:	071a                	slli	a4,a4,0x6
ffffffffc0203c5a:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203c5e:	10002773          	csrr	a4,sstatus
ffffffffc0203c62:	8b09                	andi	a4,a4,2
ffffffffc0203c64:	e345                	bnez	a4,ffffffffc0203d04 <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203c66:	000cb703          	ld	a4,0(s9)
ffffffffc0203c6a:	4505                	li	a0,1
ffffffffc0203c6c:	6f18                	ld	a4,24(a4)
ffffffffc0203c6e:	9702                	jalr	a4
ffffffffc0203c70:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0203c72:	0c0d8363          	beqz	s11,ffffffffc0203d38 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc0203c76:	100d0163          	beqz	s10,ffffffffc0203d78 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc0203c7a:	000bb703          	ld	a4,0(s7)
ffffffffc0203c7e:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc0203c82:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0203c86:	40ed86b3          	sub	a3,s11,a4
ffffffffc0203c8a:	8699                	srai	a3,a3,0x6
ffffffffc0203c8c:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0203c8e:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0203c92:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203c94:	08c7f663          	bgeu	a5,a2,ffffffffc0203d20 <copy_range+0x198>
    return page - pages + nbase;
ffffffffc0203c98:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc0203c9c:	000a7717          	auipc	a4,0xa7
ffffffffc0203ca0:	f5c70713          	addi	a4,a4,-164 # ffffffffc02aabf8 <va_pa_offset>
ffffffffc0203ca4:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0203ca6:	8799                	srai	a5,a5,0x6
ffffffffc0203ca8:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc0203caa:	0167f733          	and	a4,a5,s6
ffffffffc0203cae:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203cb2:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203cb4:	06c77563          	bgeu	a4,a2,ffffffffc0203d1e <copy_range+0x196>
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203cb8:	6605                	lui	a2,0x1
ffffffffc0203cba:	953e                	add	a0,a0,a5
ffffffffc0203cbc:	6ee010ef          	jal	ra,ffffffffc02053aa <memcpy>
            int ret = page_insert(to, npage, start, perm);
ffffffffc0203cc0:	86a6                	mv	a3,s1
ffffffffc0203cc2:	8622                	mv	a2,s0
ffffffffc0203cc4:	85ea                	mv	a1,s10
ffffffffc0203cc6:	8556                	mv	a0,s5
ffffffffc0203cc8:	98aff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
            assert(ret == 0);
ffffffffc0203ccc:	d915                	beqz	a0,ffffffffc0203c00 <copy_range+0x78>
ffffffffc0203cce:	00003697          	auipc	a3,0x3
ffffffffc0203cd2:	36a68693          	addi	a3,a3,874 # ffffffffc0207038 <default_pmm_manager+0x670>
ffffffffc0203cd6:	00002617          	auipc	a2,0x2
ffffffffc0203cda:	5e260613          	addi	a2,a2,1506 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203cde:	1ae00593          	li	a1,430
ffffffffc0203ce2:	00003517          	auipc	a0,0x3
ffffffffc0203ce6:	d4650513          	addi	a0,a0,-698 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203cea:	d34fc0ef          	jal	ra,ffffffffc020021e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203cee:	00200637          	lui	a2,0x200
ffffffffc0203cf2:	9432                	add	s0,s0,a2
ffffffffc0203cf4:	ffe00637          	lui	a2,0xffe00
ffffffffc0203cf8:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc0203cfa:	f00406e3          	beqz	s0,ffffffffc0203c06 <copy_range+0x7e>
ffffffffc0203cfe:	ef2466e3          	bltu	s0,s2,ffffffffc0203bea <copy_range+0x62>
ffffffffc0203d02:	b711                	j	ffffffffc0203c06 <copy_range+0x7e>
        intr_disable();
ffffffffc0203d04:	cb7fc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203d08:	000cb703          	ld	a4,0(s9)
ffffffffc0203d0c:	4505                	li	a0,1
ffffffffc0203d0e:	6f18                	ld	a4,24(a4)
ffffffffc0203d10:	9702                	jalr	a4
ffffffffc0203d12:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc0203d14:	ca1fc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203d18:	bfa9                	j	ffffffffc0203c72 <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0203d1a:	5571                	li	a0,-4
ffffffffc0203d1c:	b5f5                	j	ffffffffc0203c08 <copy_range+0x80>
ffffffffc0203d1e:	86be                	mv	a3,a5
ffffffffc0203d20:	00003617          	auipc	a2,0x3
ffffffffc0203d24:	81060613          	addi	a2,a2,-2032 # ffffffffc0206530 <commands+0xac0>
ffffffffc0203d28:	07100593          	li	a1,113
ffffffffc0203d2c:	00003517          	auipc	a0,0x3
ffffffffc0203d30:	82c50513          	addi	a0,a0,-2004 # ffffffffc0206558 <commands+0xae8>
ffffffffc0203d34:	ceafc0ef          	jal	ra,ffffffffc020021e <__panic>
            assert(page != NULL);
ffffffffc0203d38:	00003697          	auipc	a3,0x3
ffffffffc0203d3c:	2e068693          	addi	a3,a3,736 # ffffffffc0207018 <default_pmm_manager+0x650>
ffffffffc0203d40:	00002617          	auipc	a2,0x2
ffffffffc0203d44:	57860613          	addi	a2,a2,1400 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203d48:	19400593          	li	a1,404
ffffffffc0203d4c:	00003517          	auipc	a0,0x3
ffffffffc0203d50:	cdc50513          	addi	a0,a0,-804 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203d54:	ccafc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203d58:	00003697          	auipc	a3,0x3
ffffffffc0203d5c:	d1068693          	addi	a3,a3,-752 # ffffffffc0206a68 <default_pmm_manager+0xa0>
ffffffffc0203d60:	00002617          	auipc	a2,0x2
ffffffffc0203d64:	55860613          	addi	a2,a2,1368 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203d68:	17c00593          	li	a1,380
ffffffffc0203d6c:	00003517          	auipc	a0,0x3
ffffffffc0203d70:	cbc50513          	addi	a0,a0,-836 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203d74:	caafc0ef          	jal	ra,ffffffffc020021e <__panic>
            assert(npage != NULL);
ffffffffc0203d78:	00003697          	auipc	a3,0x3
ffffffffc0203d7c:	2b068693          	addi	a3,a3,688 # ffffffffc0207028 <default_pmm_manager+0x660>
ffffffffc0203d80:	00002617          	auipc	a2,0x2
ffffffffc0203d84:	53860613          	addi	a2,a2,1336 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203d88:	19500593          	li	a1,405
ffffffffc0203d8c:	00003517          	auipc	a0,0x3
ffffffffc0203d90:	c9c50513          	addi	a0,a0,-868 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203d94:	c8afc0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203d98:	00003617          	auipc	a2,0x3
ffffffffc0203d9c:	86860613          	addi	a2,a2,-1944 # ffffffffc0206600 <commands+0xb90>
ffffffffc0203da0:	06900593          	li	a1,105
ffffffffc0203da4:	00002517          	auipc	a0,0x2
ffffffffc0203da8:	7b450513          	addi	a0,a0,1972 # ffffffffc0206558 <commands+0xae8>
ffffffffc0203dac:	c72fc0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203db0:	00003617          	auipc	a2,0x3
ffffffffc0203db4:	c5060613          	addi	a2,a2,-944 # ffffffffc0206a00 <default_pmm_manager+0x38>
ffffffffc0203db8:	07f00593          	li	a1,127
ffffffffc0203dbc:	00002517          	auipc	a0,0x2
ffffffffc0203dc0:	79c50513          	addi	a0,a0,1948 # ffffffffc0206558 <commands+0xae8>
ffffffffc0203dc4:	c5afc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203dc8:	00003697          	auipc	a3,0x3
ffffffffc0203dcc:	c7068693          	addi	a3,a3,-912 # ffffffffc0206a38 <default_pmm_manager+0x70>
ffffffffc0203dd0:	00002617          	auipc	a2,0x2
ffffffffc0203dd4:	4e860613          	addi	a2,a2,1256 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203dd8:	17b00593          	li	a1,379
ffffffffc0203ddc:	00003517          	auipc	a0,0x3
ffffffffc0203de0:	c4c50513          	addi	a0,a0,-948 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203de4:	c3afc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203de8 <pgdir_alloc_page>:
{
ffffffffc0203de8:	7179                	addi	sp,sp,-48
ffffffffc0203dea:	ec26                	sd	s1,24(sp)
ffffffffc0203dec:	e84a                	sd	s2,16(sp)
ffffffffc0203dee:	e052                	sd	s4,0(sp)
ffffffffc0203df0:	f406                	sd	ra,40(sp)
ffffffffc0203df2:	f022                	sd	s0,32(sp)
ffffffffc0203df4:	e44e                	sd	s3,8(sp)
ffffffffc0203df6:	8a2a                	mv	s4,a0
ffffffffc0203df8:	84ae                	mv	s1,a1
ffffffffc0203dfa:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203dfc:	100027f3          	csrr	a5,sstatus
ffffffffc0203e00:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203e02:	000a7997          	auipc	s3,0xa7
ffffffffc0203e06:	dee98993          	addi	s3,s3,-530 # ffffffffc02aabf0 <pmm_manager>
ffffffffc0203e0a:	ef8d                	bnez	a5,ffffffffc0203e44 <pgdir_alloc_page+0x5c>
ffffffffc0203e0c:	0009b783          	ld	a5,0(s3)
ffffffffc0203e10:	4505                	li	a0,1
ffffffffc0203e12:	6f9c                	ld	a5,24(a5)
ffffffffc0203e14:	9782                	jalr	a5
ffffffffc0203e16:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203e18:	cc09                	beqz	s0,ffffffffc0203e32 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203e1a:	86ca                	mv	a3,s2
ffffffffc0203e1c:	8626                	mv	a2,s1
ffffffffc0203e1e:	85a2                	mv	a1,s0
ffffffffc0203e20:	8552                	mv	a0,s4
ffffffffc0203e22:	830ff0ef          	jal	ra,ffffffffc0202e52 <page_insert>
ffffffffc0203e26:	e915                	bnez	a0,ffffffffc0203e5a <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203e28:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203e2a:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0203e2c:	4785                	li	a5,1
ffffffffc0203e2e:	04f71e63          	bne	a4,a5,ffffffffc0203e8a <pgdir_alloc_page+0xa2>
}
ffffffffc0203e32:	70a2                	ld	ra,40(sp)
ffffffffc0203e34:	8522                	mv	a0,s0
ffffffffc0203e36:	7402                	ld	s0,32(sp)
ffffffffc0203e38:	64e2                	ld	s1,24(sp)
ffffffffc0203e3a:	6942                	ld	s2,16(sp)
ffffffffc0203e3c:	69a2                	ld	s3,8(sp)
ffffffffc0203e3e:	6a02                	ld	s4,0(sp)
ffffffffc0203e40:	6145                	addi	sp,sp,48
ffffffffc0203e42:	8082                	ret
        intr_disable();
ffffffffc0203e44:	b77fc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203e48:	0009b783          	ld	a5,0(s3)
ffffffffc0203e4c:	4505                	li	a0,1
ffffffffc0203e4e:	6f9c                	ld	a5,24(a5)
ffffffffc0203e50:	9782                	jalr	a5
ffffffffc0203e52:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203e54:	b61fc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203e58:	b7c1                	j	ffffffffc0203e18 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203e5a:	100027f3          	csrr	a5,sstatus
ffffffffc0203e5e:	8b89                	andi	a5,a5,2
ffffffffc0203e60:	eb89                	bnez	a5,ffffffffc0203e72 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203e62:	0009b783          	ld	a5,0(s3)
ffffffffc0203e66:	8522                	mv	a0,s0
ffffffffc0203e68:	4585                	li	a1,1
ffffffffc0203e6a:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203e6c:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203e6e:	9782                	jalr	a5
    if (flag)
ffffffffc0203e70:	b7c9                	j	ffffffffc0203e32 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203e72:	b49fc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0203e76:	0009b783          	ld	a5,0(s3)
ffffffffc0203e7a:	8522                	mv	a0,s0
ffffffffc0203e7c:	4585                	li	a1,1
ffffffffc0203e7e:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203e80:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203e82:	9782                	jalr	a5
        intr_enable();
ffffffffc0203e84:	b31fc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0203e88:	b76d                	j	ffffffffc0203e32 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203e8a:	00003697          	auipc	a3,0x3
ffffffffc0203e8e:	1be68693          	addi	a3,a3,446 # ffffffffc0207048 <default_pmm_manager+0x680>
ffffffffc0203e92:	00002617          	auipc	a2,0x2
ffffffffc0203e96:	42660613          	addi	a2,a2,1062 # ffffffffc02062b8 <commands+0x848>
ffffffffc0203e9a:	1f700593          	li	a1,503
ffffffffc0203e9e:	00003517          	auipc	a0,0x3
ffffffffc0203ea2:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0206a28 <default_pmm_manager+0x60>
ffffffffc0203ea6:	b78fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203eaa <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203eaa:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203eae:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203eb2:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0203eb4:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203eb6:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203eba:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203ebe:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203ec2:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203ec6:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203eca:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203ece:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203ed2:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203ed6:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203eda:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203ede:	0005b083          	ld	ra,0(a1) # 80000 <_binary_obj___user_exit_out_size+0x74e90>
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0203ee2:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0203ee6:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203ee8:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203eea:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203eee:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0203ef2:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0203ef6:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203efa:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203efe:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0203f02:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0203f06:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203f0a:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203f0e:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0203f12:	8082                	ret

ffffffffc0203f14 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203f14:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203f16:	9402                	jalr	s0

	jal do_exit
ffffffffc0203f18:	61e000ef          	jal	ra,ffffffffc0204536 <do_exit>

ffffffffc0203f1c <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203f1c:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203f1e:	10800513          	li	a0,264
{
ffffffffc0203f22:	e022                	sd	s0,0(sp)
ffffffffc0203f24:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203f26:	af9fd0ef          	jal	ra,ffffffffc0201a1e <kmalloc>
ffffffffc0203f2a:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203f2c:	c525                	beqz	a0,ffffffffc0203f94 <alloc_proc+0x78>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        // LAB4原有
        proc->state = PROC_UNINIT;
ffffffffc0203f2e:	57fd                	li	a5,-1
ffffffffc0203f30:	1782                	slli	a5,a5,0x20
ffffffffc0203f32:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203f34:	07000613          	li	a2,112
ffffffffc0203f38:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203f3a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203f3e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203f42:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203f46:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203f4a:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203f4e:	03050513          	addi	a0,a0,48
ffffffffc0203f52:	446010ef          	jal	ra,ffffffffc0205398 <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203f56:	000a7797          	auipc	a5,0xa7
ffffffffc0203f5a:	c7a7b783          	ld	a5,-902(a5) # ffffffffc02aabd0 <boot_pgdir_pa>
ffffffffc0203f5e:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203f60:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc0203f64:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN+1);
ffffffffc0203f68:	4641                	li	a2,16
ffffffffc0203f6a:	4581                	li	a1,0
ffffffffc0203f6c:	0b440513          	addi	a0,s0,180
ffffffffc0203f70:	428010ef          	jal	ra,ffffffffc0205398 <memset>
        list_init(&(proc->list_link));
ffffffffc0203f74:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203f78:	0d840793          	addi	a5,s0,216
    elm->prev = elm->next = elm;
ffffffffc0203f7c:	e878                	sd	a4,208(s0)
ffffffffc0203f7e:	e478                	sd	a4,200(s0)
ffffffffc0203f80:	f07c                	sd	a5,224(s0)
ffffffffc0203f82:	ec7c                	sd	a5,216(s0)
     
        // LAB5新增     
        proc->wait_state = 0;
ffffffffc0203f84:	0e042623          	sw	zero,236(s0)
        proc->cptr = NULL;
ffffffffc0203f88:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc0203f8c:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0203f90:	0e043c23          	sd	zero,248(s0)
    }
    return proc;
}
ffffffffc0203f94:	60a2                	ld	ra,8(sp)
ffffffffc0203f96:	8522                	mv	a0,s0
ffffffffc0203f98:	6402                	ld	s0,0(sp)
ffffffffc0203f9a:	0141                	addi	sp,sp,16
ffffffffc0203f9c:	8082                	ret

ffffffffc0203f9e <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203f9e:	000a7797          	auipc	a5,0xa7
ffffffffc0203fa2:	c627b783          	ld	a5,-926(a5) # ffffffffc02aac00 <current>
ffffffffc0203fa6:	73c8                	ld	a0,160(a5)
ffffffffc0203fa8:	86afd06f          	j	ffffffffc0201012 <forkrets>

ffffffffc0203fac <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203fac:	000a7797          	auipc	a5,0xa7
ffffffffc0203fb0:	c547b783          	ld	a5,-940(a5) # ffffffffc02aac00 <current>
ffffffffc0203fb4:	43cc                	lw	a1,4(a5)
{
ffffffffc0203fb6:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203fb8:	00003617          	auipc	a2,0x3
ffffffffc0203fbc:	0a860613          	addi	a2,a2,168 # ffffffffc0207060 <default_pmm_manager+0x698>
ffffffffc0203fc0:	00003517          	auipc	a0,0x3
ffffffffc0203fc4:	0b050513          	addi	a0,a0,176 # ffffffffc0207070 <default_pmm_manager+0x6a8>
{
ffffffffc0203fc8:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0203fca:	916fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0203fce:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0203fd2:	9ea78793          	addi	a5,a5,-1558 # a9b8 <_binary_obj___user_forktest_out_size>
ffffffffc0203fd6:	e43e                	sd	a5,8(sp)
ffffffffc0203fd8:	00003517          	auipc	a0,0x3
ffffffffc0203fdc:	08850513          	addi	a0,a0,136 # ffffffffc0207060 <default_pmm_manager+0x698>
ffffffffc0203fe0:	00098797          	auipc	a5,0x98
ffffffffc0203fe4:	dc078793          	addi	a5,a5,-576 # ffffffffc029bda0 <_binary_obj___user_forktest_out_start>
ffffffffc0203fe8:	f03e                	sd	a5,32(sp)
ffffffffc0203fea:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203fec:	e802                	sd	zero,16(sp)
ffffffffc0203fee:	308010ef          	jal	ra,ffffffffc02052f6 <strlen>
ffffffffc0203ff2:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203ff4:	4511                	li	a0,4
ffffffffc0203ff6:	55a2                	lw	a1,40(sp)
ffffffffc0203ff8:	4662                	lw	a2,24(sp)
ffffffffc0203ffa:	5682                	lw	a3,32(sp)
ffffffffc0203ffc:	4722                	lw	a4,8(sp)
ffffffffc0203ffe:	48a9                	li	a7,10
ffffffffc0204000:	9002                	ebreak
ffffffffc0204002:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204004:	65c2                	ld	a1,16(sp)
ffffffffc0204006:	00003517          	auipc	a0,0x3
ffffffffc020400a:	09250513          	addi	a0,a0,146 # ffffffffc0207098 <default_pmm_manager+0x6d0>
ffffffffc020400e:	8d2fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0204012:	00003617          	auipc	a2,0x3
ffffffffc0204016:	09660613          	addi	a2,a2,150 # ffffffffc02070a8 <default_pmm_manager+0x6e0>
ffffffffc020401a:	3b900593          	li	a1,953
ffffffffc020401e:	00003517          	auipc	a0,0x3
ffffffffc0204022:	0aa50513          	addi	a0,a0,170 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204026:	9f8fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020402a <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc020402a:	6d14                	ld	a3,24(a0)
{
ffffffffc020402c:	1141                	addi	sp,sp,-16
ffffffffc020402e:	e406                	sd	ra,8(sp)
ffffffffc0204030:	c02007b7          	lui	a5,0xc0200
ffffffffc0204034:	02f6ee63          	bltu	a3,a5,ffffffffc0204070 <put_pgdir+0x46>
ffffffffc0204038:	000a7517          	auipc	a0,0xa7
ffffffffc020403c:	bc053503          	ld	a0,-1088(a0) # ffffffffc02aabf8 <va_pa_offset>
ffffffffc0204040:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0204042:	82b1                	srli	a3,a3,0xc
ffffffffc0204044:	000a7797          	auipc	a5,0xa7
ffffffffc0204048:	b9c7b783          	ld	a5,-1124(a5) # ffffffffc02aabe0 <npage>
ffffffffc020404c:	02f6fe63          	bgeu	a3,a5,ffffffffc0204088 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0204050:	00004517          	auipc	a0,0x4
ffffffffc0204054:	93053503          	ld	a0,-1744(a0) # ffffffffc0207980 <nbase>
}
ffffffffc0204058:	60a2                	ld	ra,8(sp)
ffffffffc020405a:	8e89                	sub	a3,a3,a0
ffffffffc020405c:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc020405e:	000a7517          	auipc	a0,0xa7
ffffffffc0204062:	b8a53503          	ld	a0,-1142(a0) # ffffffffc02aabe8 <pages>
ffffffffc0204066:	4585                	li	a1,1
ffffffffc0204068:	9536                	add	a0,a0,a3
}
ffffffffc020406a:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc020406c:	e7cfe06f          	j	ffffffffc02026e8 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204070:	00002617          	auipc	a2,0x2
ffffffffc0204074:	56860613          	addi	a2,a2,1384 # ffffffffc02065d8 <commands+0xb68>
ffffffffc0204078:	07700593          	li	a1,119
ffffffffc020407c:	00002517          	auipc	a0,0x2
ffffffffc0204080:	4dc50513          	addi	a0,a0,1244 # ffffffffc0206558 <commands+0xae8>
ffffffffc0204084:	99afc0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204088:	00002617          	auipc	a2,0x2
ffffffffc020408c:	57860613          	addi	a2,a2,1400 # ffffffffc0206600 <commands+0xb90>
ffffffffc0204090:	06900593          	li	a1,105
ffffffffc0204094:	00002517          	auipc	a0,0x2
ffffffffc0204098:	4c450513          	addi	a0,a0,1220 # ffffffffc0206558 <commands+0xae8>
ffffffffc020409c:	982fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02040a0 <proc_run>:
{
ffffffffc02040a0:	7179                	addi	sp,sp,-48
ffffffffc02040a2:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc02040a4:	000a7917          	auipc	s2,0xa7
ffffffffc02040a8:	b5c90913          	addi	s2,s2,-1188 # ffffffffc02aac00 <current>
{
ffffffffc02040ac:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc02040ae:	00093483          	ld	s1,0(s2)
{
ffffffffc02040b2:	f406                	sd	ra,40(sp)
ffffffffc02040b4:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc02040b6:	02a48d63          	beq	s1,a0,ffffffffc02040f0 <proc_run+0x50>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040ba:	100027f3          	csrr	a5,sstatus
ffffffffc02040be:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02040c0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040c2:	e7a1                	bnez	a5,ffffffffc020410a <proc_run+0x6a>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc02040c4:	755c                	ld	a5,168(a0)
ffffffffc02040c6:	577d                	li	a4,-1
ffffffffc02040c8:	177e                	slli	a4,a4,0x3f
ffffffffc02040ca:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc02040cc:	00a93023          	sd	a0,0(s2)
ffffffffc02040d0:	8fd9                	or	a5,a5,a4
ffffffffc02040d2:	18079073          	csrw	satp,a5
        proc->runs++;
ffffffffc02040d6:	451c                	lw	a5,8(a0)
        proc->need_resched = 0;
ffffffffc02040d8:	00053c23          	sd	zero,24(a0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc02040dc:	03050593          	addi	a1,a0,48
        proc->runs++;
ffffffffc02040e0:	2785                	addiw	a5,a5,1
ffffffffc02040e2:	c51c                	sw	a5,8(a0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc02040e4:	03048513          	addi	a0,s1,48
ffffffffc02040e8:	dc3ff0ef          	jal	ra,ffffffffc0203eaa <switch_to>
    if (flag)
ffffffffc02040ec:	00099863          	bnez	s3,ffffffffc02040fc <proc_run+0x5c>
}
ffffffffc02040f0:	70a2                	ld	ra,40(sp)
ffffffffc02040f2:	7482                	ld	s1,32(sp)
ffffffffc02040f4:	6962                	ld	s2,24(sp)
ffffffffc02040f6:	69c2                	ld	s3,16(sp)
ffffffffc02040f8:	6145                	addi	sp,sp,48
ffffffffc02040fa:	8082                	ret
ffffffffc02040fc:	70a2                	ld	ra,40(sp)
ffffffffc02040fe:	7482                	ld	s1,32(sp)
ffffffffc0204100:	6962                	ld	s2,24(sp)
ffffffffc0204102:	69c2                	ld	s3,16(sp)
ffffffffc0204104:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0204106:	8affc06f          	j	ffffffffc02009b4 <intr_enable>
ffffffffc020410a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020410c:	8affc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0204110:	6522                	ld	a0,8(sp)
ffffffffc0204112:	4985                	li	s3,1
ffffffffc0204114:	bf45                	j	ffffffffc02040c4 <proc_run+0x24>

ffffffffc0204116 <do_fork>:
{
ffffffffc0204116:	7119                	addi	sp,sp,-128
ffffffffc0204118:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020411a:	000a7917          	auipc	s2,0xa7
ffffffffc020411e:	afe90913          	addi	s2,s2,-1282 # ffffffffc02aac18 <nr_process>
ffffffffc0204122:	00092703          	lw	a4,0(s2)
{
ffffffffc0204126:	fc86                	sd	ra,120(sp)
ffffffffc0204128:	f8a2                	sd	s0,112(sp)
ffffffffc020412a:	f4a6                	sd	s1,104(sp)
ffffffffc020412c:	ecce                	sd	s3,88(sp)
ffffffffc020412e:	e8d2                	sd	s4,80(sp)
ffffffffc0204130:	e4d6                	sd	s5,72(sp)
ffffffffc0204132:	e0da                	sd	s6,64(sp)
ffffffffc0204134:	fc5e                	sd	s7,56(sp)
ffffffffc0204136:	f862                	sd	s8,48(sp)
ffffffffc0204138:	f466                	sd	s9,40(sp)
ffffffffc020413a:	f06a                	sd	s10,32(sp)
ffffffffc020413c:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020413e:	6785                	lui	a5,0x1
ffffffffc0204140:	30f75163          	bge	a4,a5,ffffffffc0204442 <do_fork+0x32c>
ffffffffc0204144:	8a2a                	mv	s4,a0
ffffffffc0204146:	89ae                	mv	s3,a1
ffffffffc0204148:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc020414a:	dd3ff0ef          	jal	ra,ffffffffc0203f1c <alloc_proc>
ffffffffc020414e:	84aa                	mv	s1,a0
    if(proc==NULL)
ffffffffc0204150:	2c050d63          	beqz	a0,ffffffffc020442a <do_fork+0x314>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204154:	4509                	li	a0,2
ffffffffc0204156:	d54fe0ef          	jal	ra,ffffffffc02026aa <alloc_pages>
    if (page != NULL)
ffffffffc020415a:	2c050563          	beqz	a0,ffffffffc0204424 <do_fork+0x30e>
    return page - pages + nbase;
ffffffffc020415e:	000a7a97          	auipc	s5,0xa7
ffffffffc0204162:	a8aa8a93          	addi	s5,s5,-1398 # ffffffffc02aabe8 <pages>
ffffffffc0204166:	000ab683          	ld	a3,0(s5)
ffffffffc020416a:	00004797          	auipc	a5,0x4
ffffffffc020416e:	81678793          	addi	a5,a5,-2026 # ffffffffc0207980 <nbase>
ffffffffc0204172:	6398                	ld	a4,0(a5)
ffffffffc0204174:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204178:	000a7b97          	auipc	s7,0xa7
ffffffffc020417c:	a68b8b93          	addi	s7,s7,-1432 # ffffffffc02aabe0 <npage>
    return page - pages + nbase;
ffffffffc0204180:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204182:	57fd                	li	a5,-1
ffffffffc0204184:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc0204188:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc020418a:	00c7db13          	srli	s6,a5,0xc
ffffffffc020418e:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0204192:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204194:	2ac5fc63          	bgeu	a1,a2,ffffffffc020444c <do_fork+0x336>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204198:	000a7c97          	auipc	s9,0xa7
ffffffffc020419c:	a68c8c93          	addi	s9,s9,-1432 # ffffffffc02aac00 <current>
ffffffffc02041a0:	000cb303          	ld	t1,0(s9)
ffffffffc02041a4:	000a7c17          	auipc	s8,0xa7
ffffffffc02041a8:	a54c0c13          	addi	s8,s8,-1452 # ffffffffc02aabf8 <va_pa_offset>
ffffffffc02041ac:	000c3603          	ld	a2,0(s8)
ffffffffc02041b0:	02833d83          	ld	s11,40(t1) # 80028 <_binary_obj___user_exit_out_size+0x74eb8>
ffffffffc02041b4:	e43a                	sd	a4,8(sp)
ffffffffc02041b6:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02041b8:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc02041ba:	020d8a63          	beqz	s11,ffffffffc02041ee <do_fork+0xd8>
    if (clone_flags & CLONE_VM)
ffffffffc02041be:	100a7a13          	andi	s4,s4,256
ffffffffc02041c2:	1a0a0063          	beqz	s4,ffffffffc0204362 <do_fork+0x24c>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc02041c6:	030da703          	lw	a4,48(s11)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041ca:	018db783          	ld	a5,24(s11)
ffffffffc02041ce:	c02006b7          	lui	a3,0xc0200
ffffffffc02041d2:	2705                	addiw	a4,a4,1
ffffffffc02041d4:	02eda823          	sw	a4,48(s11)
    proc->mm = mm;
ffffffffc02041d8:	03b4b423          	sd	s11,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041dc:	2cd7ec63          	bltu	a5,a3,ffffffffc02044b4 <do_fork+0x39e>
ffffffffc02041e0:	000c3703          	ld	a4,0(s8)
    proc->parent = current;
ffffffffc02041e4:	000cb303          	ld	t1,0(s9)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02041e8:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02041ea:	8f99                	sub	a5,a5,a4
ffffffffc02041ec:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02041ee:	6789                	lui	a5,0x2
ffffffffc02041f0:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7d20>
ffffffffc02041f4:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02041f6:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02041f8:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02041fa:	87b6                	mv	a5,a3
ffffffffc02041fc:	12040893          	addi	a7,s0,288
ffffffffc0204200:	00063803          	ld	a6,0(a2)
ffffffffc0204204:	6608                	ld	a0,8(a2)
ffffffffc0204206:	6a0c                	ld	a1,16(a2)
ffffffffc0204208:	6e18                	ld	a4,24(a2)
ffffffffc020420a:	0107b023          	sd	a6,0(a5)
ffffffffc020420e:	e788                	sd	a0,8(a5)
ffffffffc0204210:	eb8c                	sd	a1,16(a5)
ffffffffc0204212:	ef98                	sd	a4,24(a5)
ffffffffc0204214:	02060613          	addi	a2,a2,32
ffffffffc0204218:	02078793          	addi	a5,a5,32
ffffffffc020421c:	ff1612e3          	bne	a2,a7,ffffffffc0204200 <do_fork+0xea>
    proc->tf->gpr.a0 = 0;
ffffffffc0204220:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204224:	12098d63          	beqz	s3,ffffffffc020435e <do_fork+0x248>
    assert(current->wait_state == 0);
ffffffffc0204228:	0ec32783          	lw	a5,236(t1)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020422c:	00000717          	auipc	a4,0x0
ffffffffc0204230:	d7270713          	addi	a4,a4,-654 # ffffffffc0203f9e <forkret>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204234:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204238:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020423a:	fc94                	sd	a3,56(s1)
    proc->parent = current;
ffffffffc020423c:	0264b023          	sd	t1,32(s1)
    assert(current->wait_state == 0);
ffffffffc0204240:	22079263          	bnez	a5,ffffffffc0204464 <do_fork+0x34e>
    if (++last_pid >= MAX_PID)
ffffffffc0204244:	000a2817          	auipc	a6,0xa2
ffffffffc0204248:	52c80813          	addi	a6,a6,1324 # ffffffffc02a6770 <last_pid.1>
ffffffffc020424c:	00082783          	lw	a5,0(a6)
ffffffffc0204250:	6709                	lui	a4,0x2
ffffffffc0204252:	0017851b          	addiw	a0,a5,1
ffffffffc0204256:	00a82023          	sw	a0,0(a6)
ffffffffc020425a:	08e55b63          	bge	a0,a4,ffffffffc02042f0 <do_fork+0x1da>
    if (last_pid >= next_safe)
ffffffffc020425e:	000a2317          	auipc	t1,0xa2
ffffffffc0204262:	51630313          	addi	t1,t1,1302 # ffffffffc02a6774 <next_safe.0>
ffffffffc0204266:	00032783          	lw	a5,0(t1)
ffffffffc020426a:	000a7417          	auipc	s0,0xa7
ffffffffc020426e:	92640413          	addi	s0,s0,-1754 # ffffffffc02aab90 <proc_list>
ffffffffc0204272:	08f55763          	bge	a0,a5,ffffffffc0204300 <do_fork+0x1ea>
    proc->pid = get_pid();
ffffffffc0204276:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204278:	45a9                	li	a1,10
ffffffffc020427a:	2501                	sext.w	a0,a0
ffffffffc020427c:	534010ef          	jal	ra,ffffffffc02057b0 <hash32>
ffffffffc0204280:	02051793          	slli	a5,a0,0x20
ffffffffc0204284:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204288:	000a3797          	auipc	a5,0xa3
ffffffffc020428c:	90878793          	addi	a5,a5,-1784 # ffffffffc02a6b90 <hash_list>
ffffffffc0204290:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204292:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204294:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204296:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020429a:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020429c:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc020429e:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02042a0:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02042a2:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc02042a6:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc02042a8:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc02042aa:	e21c                	sd	a5,0(a2)
ffffffffc02042ac:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc02042ae:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc02042b0:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc02042b2:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02042b6:	10e4b023          	sd	a4,256(s1)
ffffffffc02042ba:	c311                	beqz	a4,ffffffffc02042be <do_fork+0x1a8>
        proc->optr->yptr = proc;
ffffffffc02042bc:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc02042be:	00092783          	lw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02042c2:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc02042c4:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc02042c6:	2785                	addiw	a5,a5,1
ffffffffc02042c8:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02042cc:	63f000ef          	jal	ra,ffffffffc020510a <wakeup_proc>
    ret = proc->pid;
ffffffffc02042d0:	40c8                	lw	a0,4(s1)
}
ffffffffc02042d2:	70e6                	ld	ra,120(sp)
ffffffffc02042d4:	7446                	ld	s0,112(sp)
ffffffffc02042d6:	74a6                	ld	s1,104(sp)
ffffffffc02042d8:	7906                	ld	s2,96(sp)
ffffffffc02042da:	69e6                	ld	s3,88(sp)
ffffffffc02042dc:	6a46                	ld	s4,80(sp)
ffffffffc02042de:	6aa6                	ld	s5,72(sp)
ffffffffc02042e0:	6b06                	ld	s6,64(sp)
ffffffffc02042e2:	7be2                	ld	s7,56(sp)
ffffffffc02042e4:	7c42                	ld	s8,48(sp)
ffffffffc02042e6:	7ca2                	ld	s9,40(sp)
ffffffffc02042e8:	7d02                	ld	s10,32(sp)
ffffffffc02042ea:	6de2                	ld	s11,24(sp)
ffffffffc02042ec:	6109                	addi	sp,sp,128
ffffffffc02042ee:	8082                	ret
        last_pid = 1;
ffffffffc02042f0:	4785                	li	a5,1
ffffffffc02042f2:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02042f6:	4505                	li	a0,1
ffffffffc02042f8:	000a2317          	auipc	t1,0xa2
ffffffffc02042fc:	47c30313          	addi	t1,t1,1148 # ffffffffc02a6774 <next_safe.0>
    return listelm->next;
ffffffffc0204300:	000a7417          	auipc	s0,0xa7
ffffffffc0204304:	89040413          	addi	s0,s0,-1904 # ffffffffc02aab90 <proc_list>
ffffffffc0204308:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc020430c:	6789                	lui	a5,0x2
ffffffffc020430e:	00f32023          	sw	a5,0(t1)
ffffffffc0204312:	86aa                	mv	a3,a0
ffffffffc0204314:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204316:	6e89                	lui	t4,0x2
ffffffffc0204318:	128e0063          	beq	t3,s0,ffffffffc0204438 <do_fork+0x322>
ffffffffc020431c:	88ae                	mv	a7,a1
ffffffffc020431e:	87f2                	mv	a5,t3
ffffffffc0204320:	6609                	lui	a2,0x2
ffffffffc0204322:	a811                	j	ffffffffc0204336 <do_fork+0x220>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204324:	00e6d663          	bge	a3,a4,ffffffffc0204330 <do_fork+0x21a>
ffffffffc0204328:	00c75463          	bge	a4,a2,ffffffffc0204330 <do_fork+0x21a>
ffffffffc020432c:	863a                	mv	a2,a4
ffffffffc020432e:	4885                	li	a7,1
ffffffffc0204330:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204332:	00878d63          	beq	a5,s0,ffffffffc020434c <do_fork+0x236>
            if (proc->pid == last_pid)
ffffffffc0204336:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7cc4>
ffffffffc020433a:	fed715e3          	bne	a4,a3,ffffffffc0204324 <do_fork+0x20e>
                if (++last_pid >= next_safe)
ffffffffc020433e:	2685                	addiw	a3,a3,1
ffffffffc0204340:	0ec6d763          	bge	a3,a2,ffffffffc020442e <do_fork+0x318>
ffffffffc0204344:	679c                	ld	a5,8(a5)
ffffffffc0204346:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204348:	fe8797e3          	bne	a5,s0,ffffffffc0204336 <do_fork+0x220>
ffffffffc020434c:	c581                	beqz	a1,ffffffffc0204354 <do_fork+0x23e>
ffffffffc020434e:	00d82023          	sw	a3,0(a6)
ffffffffc0204352:	8536                	mv	a0,a3
ffffffffc0204354:	f20881e3          	beqz	a7,ffffffffc0204276 <do_fork+0x160>
ffffffffc0204358:	00c32023          	sw	a2,0(t1)
ffffffffc020435c:	bf29                	j	ffffffffc0204276 <do_fork+0x160>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020435e:	89b6                	mv	s3,a3
ffffffffc0204360:	b5e1                	j	ffffffffc0204228 <do_fork+0x112>
    if ((mm = mm_create()) == NULL)
ffffffffc0204362:	d81fc0ef          	jal	ra,ffffffffc02010e2 <mm_create>
ffffffffc0204366:	8d2a                	mv	s10,a0
ffffffffc0204368:	c159                	beqz	a0,ffffffffc02043ee <do_fork+0x2d8>
    if ((page = alloc_page()) == NULL)
ffffffffc020436a:	4505                	li	a0,1
ffffffffc020436c:	b3efe0ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0204370:	cd25                	beqz	a0,ffffffffc02043e8 <do_fork+0x2d2>
    return page - pages + nbase;
ffffffffc0204372:	000ab683          	ld	a3,0(s5)
ffffffffc0204376:	6722                	ld	a4,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204378:	000bb603          	ld	a2,0(s7)
    return page - pages + nbase;
ffffffffc020437c:	40d506b3          	sub	a3,a0,a3
ffffffffc0204380:	8699                	srai	a3,a3,0x6
ffffffffc0204382:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0204384:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0204388:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020438a:	0cc7f163          	bgeu	a5,a2,ffffffffc020444c <do_fork+0x336>
ffffffffc020438e:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204392:	6605                	lui	a2,0x1
ffffffffc0204394:	000a7597          	auipc	a1,0xa7
ffffffffc0204398:	8445b583          	ld	a1,-1980(a1) # ffffffffc02aabd8 <boot_pgdir_va>
ffffffffc020439c:	9a36                	add	s4,s4,a3
ffffffffc020439e:	8552                	mv	a0,s4
ffffffffc02043a0:	00a010ef          	jal	ra,ffffffffc02053aa <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc02043a4:	038d8b13          	addi	s6,s11,56
    mm->pgdir = pgdir;
ffffffffc02043a8:	014d3c23          	sd	s4,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02043ac:	4785                	li	a5,1
ffffffffc02043ae:	40fb37af          	amoor.d	a5,a5,(s6)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02043b2:	8b85                	andi	a5,a5,1
ffffffffc02043b4:	4a05                	li	s4,1
ffffffffc02043b6:	c799                	beqz	a5,ffffffffc02043c4 <do_fork+0x2ae>
    {
        schedule();
ffffffffc02043b8:	5d3000ef          	jal	ra,ffffffffc020518a <schedule>
ffffffffc02043bc:	414b37af          	amoor.d	a5,s4,(s6)
    while (!try_lock(lock))
ffffffffc02043c0:	8b85                	andi	a5,a5,1
ffffffffc02043c2:	fbfd                	bnez	a5,ffffffffc02043b8 <do_fork+0x2a2>
        ret = dup_mmap(mm, oldmm);
ffffffffc02043c4:	85ee                	mv	a1,s11
ffffffffc02043c6:	856a                	mv	a0,s10
ffffffffc02043c8:	f5dfc0ef          	jal	ra,ffffffffc0201324 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02043cc:	57f9                	li	a5,-2
ffffffffc02043ce:	60fb37af          	amoand.d	a5,a5,(s6)
ffffffffc02043d2:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02043d4:	c7e1                	beqz	a5,ffffffffc020449c <do_fork+0x386>
good_mm:
ffffffffc02043d6:	8dea                	mv	s11,s10
    if (ret != 0)
ffffffffc02043d8:	de0507e3          	beqz	a0,ffffffffc02041c6 <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc02043dc:	856a                	mv	a0,s10
ffffffffc02043de:	fe1fc0ef          	jal	ra,ffffffffc02013be <exit_mmap>
    put_pgdir(mm);
ffffffffc02043e2:	856a                	mv	a0,s10
ffffffffc02043e4:	c47ff0ef          	jal	ra,ffffffffc020402a <put_pgdir>
    mm_destroy(mm);
ffffffffc02043e8:	856a                	mv	a0,s10
ffffffffc02043ea:	e39fc0ef          	jal	ra,ffffffffc0201222 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02043ee:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02043f0:	c02007b7          	lui	a5,0xc0200
ffffffffc02043f4:	0cf6ed63          	bltu	a3,a5,ffffffffc02044ce <do_fork+0x3b8>
ffffffffc02043f8:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02043fc:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204400:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204404:	83b1                	srli	a5,a5,0xc
ffffffffc0204406:	06e7ff63          	bgeu	a5,a4,ffffffffc0204484 <do_fork+0x36e>
    return &pages[PPN(pa) - nbase];
ffffffffc020440a:	00003717          	auipc	a4,0x3
ffffffffc020440e:	57670713          	addi	a4,a4,1398 # ffffffffc0207980 <nbase>
ffffffffc0204412:	6318                	ld	a4,0(a4)
ffffffffc0204414:	000ab503          	ld	a0,0(s5)
ffffffffc0204418:	4589                	li	a1,2
ffffffffc020441a:	8f99                	sub	a5,a5,a4
ffffffffc020441c:	079a                	slli	a5,a5,0x6
ffffffffc020441e:	953e                	add	a0,a0,a5
ffffffffc0204420:	ac8fe0ef          	jal	ra,ffffffffc02026e8 <free_pages>
    kfree(proc);
ffffffffc0204424:	8526                	mv	a0,s1
ffffffffc0204426:	ea8fd0ef          	jal	ra,ffffffffc0201ace <kfree>
    ret = -E_NO_MEM;
ffffffffc020442a:	5571                	li	a0,-4
    return ret;
ffffffffc020442c:	b55d                	j	ffffffffc02042d2 <do_fork+0x1bc>
                    if (last_pid >= MAX_PID)
ffffffffc020442e:	01d6c363          	blt	a3,t4,ffffffffc0204434 <do_fork+0x31e>
                        last_pid = 1;
ffffffffc0204432:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204434:	4585                	li	a1,1
ffffffffc0204436:	b5cd                	j	ffffffffc0204318 <do_fork+0x202>
ffffffffc0204438:	c599                	beqz	a1,ffffffffc0204446 <do_fork+0x330>
ffffffffc020443a:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020443e:	8536                	mv	a0,a3
ffffffffc0204440:	bd1d                	j	ffffffffc0204276 <do_fork+0x160>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204442:	556d                	li	a0,-5
ffffffffc0204444:	b579                	j	ffffffffc02042d2 <do_fork+0x1bc>
    return last_pid;
ffffffffc0204446:	00082503          	lw	a0,0(a6)
ffffffffc020444a:	b535                	j	ffffffffc0204276 <do_fork+0x160>
    return KADDR(page2pa(page));
ffffffffc020444c:	00002617          	auipc	a2,0x2
ffffffffc0204450:	0e460613          	addi	a2,a2,228 # ffffffffc0206530 <commands+0xac0>
ffffffffc0204454:	07100593          	li	a1,113
ffffffffc0204458:	00002517          	auipc	a0,0x2
ffffffffc020445c:	10050513          	addi	a0,a0,256 # ffffffffc0206558 <commands+0xae8>
ffffffffc0204460:	dbffb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(current->wait_state == 0);
ffffffffc0204464:	00003697          	auipc	a3,0x3
ffffffffc0204468:	ca468693          	addi	a3,a3,-860 # ffffffffc0207108 <default_pmm_manager+0x740>
ffffffffc020446c:	00002617          	auipc	a2,0x2
ffffffffc0204470:	e4c60613          	addi	a2,a2,-436 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204474:	1e800593          	li	a1,488
ffffffffc0204478:	00003517          	auipc	a0,0x3
ffffffffc020447c:	c5050513          	addi	a0,a0,-944 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204480:	d9ffb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204484:	00002617          	auipc	a2,0x2
ffffffffc0204488:	17c60613          	addi	a2,a2,380 # ffffffffc0206600 <commands+0xb90>
ffffffffc020448c:	06900593          	li	a1,105
ffffffffc0204490:	00002517          	auipc	a0,0x2
ffffffffc0204494:	0c850513          	addi	a0,a0,200 # ffffffffc0206558 <commands+0xae8>
ffffffffc0204498:	d87fb0ef          	jal	ra,ffffffffc020021e <__panic>
    {
        panic("Unlock failed.\n");
ffffffffc020449c:	00003617          	auipc	a2,0x3
ffffffffc02044a0:	c4460613          	addi	a2,a2,-956 # ffffffffc02070e0 <default_pmm_manager+0x718>
ffffffffc02044a4:	03f00593          	li	a1,63
ffffffffc02044a8:	00003517          	auipc	a0,0x3
ffffffffc02044ac:	c4850513          	addi	a0,a0,-952 # ffffffffc02070f0 <default_pmm_manager+0x728>
ffffffffc02044b0:	d6ffb0ef          	jal	ra,ffffffffc020021e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02044b4:	86be                	mv	a3,a5
ffffffffc02044b6:	00002617          	auipc	a2,0x2
ffffffffc02044ba:	12260613          	addi	a2,a2,290 # ffffffffc02065d8 <commands+0xb68>
ffffffffc02044be:	19300593          	li	a1,403
ffffffffc02044c2:	00003517          	auipc	a0,0x3
ffffffffc02044c6:	c0650513          	addi	a0,a0,-1018 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc02044ca:	d55fb0ef          	jal	ra,ffffffffc020021e <__panic>
    return pa2page(PADDR(kva));
ffffffffc02044ce:	00002617          	auipc	a2,0x2
ffffffffc02044d2:	10a60613          	addi	a2,a2,266 # ffffffffc02065d8 <commands+0xb68>
ffffffffc02044d6:	07700593          	li	a1,119
ffffffffc02044da:	00002517          	auipc	a0,0x2
ffffffffc02044de:	07e50513          	addi	a0,a0,126 # ffffffffc0206558 <commands+0xae8>
ffffffffc02044e2:	d3dfb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02044e6 <kernel_thread>:
{
ffffffffc02044e6:	7129                	addi	sp,sp,-320
ffffffffc02044e8:	fa22                	sd	s0,304(sp)
ffffffffc02044ea:	f626                	sd	s1,296(sp)
ffffffffc02044ec:	f24a                	sd	s2,288(sp)
ffffffffc02044ee:	84ae                	mv	s1,a1
ffffffffc02044f0:	892a                	mv	s2,a0
ffffffffc02044f2:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02044f4:	4581                	li	a1,0
ffffffffc02044f6:	12000613          	li	a2,288
ffffffffc02044fa:	850a                	mv	a0,sp
{
ffffffffc02044fc:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02044fe:	69b000ef          	jal	ra,ffffffffc0205398 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0204502:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0204504:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204506:	100027f3          	csrr	a5,sstatus
ffffffffc020450a:	edd7f793          	andi	a5,a5,-291
ffffffffc020450e:	1207e793          	ori	a5,a5,288
ffffffffc0204512:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204514:	860a                	mv	a2,sp
ffffffffc0204516:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020451a:	00000797          	auipc	a5,0x0
ffffffffc020451e:	9fa78793          	addi	a5,a5,-1542 # ffffffffc0203f14 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204522:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204524:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204526:	bf1ff0ef          	jal	ra,ffffffffc0204116 <do_fork>
}
ffffffffc020452a:	70f2                	ld	ra,312(sp)
ffffffffc020452c:	7452                	ld	s0,304(sp)
ffffffffc020452e:	74b2                	ld	s1,296(sp)
ffffffffc0204530:	7912                	ld	s2,288(sp)
ffffffffc0204532:	6131                	addi	sp,sp,320
ffffffffc0204534:	8082                	ret

ffffffffc0204536 <do_exit>:
{
ffffffffc0204536:	7179                	addi	sp,sp,-48
ffffffffc0204538:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc020453a:	000a6417          	auipc	s0,0xa6
ffffffffc020453e:	6c640413          	addi	s0,s0,1734 # ffffffffc02aac00 <current>
ffffffffc0204542:	601c                	ld	a5,0(s0)
{
ffffffffc0204544:	f406                	sd	ra,40(sp)
ffffffffc0204546:	ec26                	sd	s1,24(sp)
ffffffffc0204548:	e84a                	sd	s2,16(sp)
ffffffffc020454a:	e44e                	sd	s3,8(sp)
ffffffffc020454c:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020454e:	000a6717          	auipc	a4,0xa6
ffffffffc0204552:	6ba73703          	ld	a4,1722(a4) # ffffffffc02aac08 <idleproc>
ffffffffc0204556:	0ce78c63          	beq	a5,a4,ffffffffc020462e <do_exit+0xf8>
    if (current == initproc)
ffffffffc020455a:	000a6497          	auipc	s1,0xa6
ffffffffc020455e:	6b648493          	addi	s1,s1,1718 # ffffffffc02aac10 <initproc>
ffffffffc0204562:	6098                	ld	a4,0(s1)
ffffffffc0204564:	0ee78b63          	beq	a5,a4,ffffffffc020465a <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204568:	0287b983          	ld	s3,40(a5)
ffffffffc020456c:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020456e:	02098663          	beqz	s3,ffffffffc020459a <do_exit+0x64>
ffffffffc0204572:	000a6797          	auipc	a5,0xa6
ffffffffc0204576:	65e7b783          	ld	a5,1630(a5) # ffffffffc02aabd0 <boot_pgdir_pa>
ffffffffc020457a:	577d                	li	a4,-1
ffffffffc020457c:	177e                	slli	a4,a4,0x3f
ffffffffc020457e:	83b1                	srli	a5,a5,0xc
ffffffffc0204580:	8fd9                	or	a5,a5,a4
ffffffffc0204582:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204586:	0309a783          	lw	a5,48(s3)
ffffffffc020458a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020458e:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204592:	cb55                	beqz	a4,ffffffffc0204646 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204594:	601c                	ld	a5,0(s0)
ffffffffc0204596:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020459a:	601c                	ld	a5,0(s0)
ffffffffc020459c:	470d                	li	a4,3
ffffffffc020459e:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02045a0:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045a4:	100027f3          	csrr	a5,sstatus
ffffffffc02045a8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02045aa:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02045ac:	e3f9                	bnez	a5,ffffffffc0204672 <do_exit+0x13c>
        proc = current->parent;
ffffffffc02045ae:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02045b0:	800007b7          	lui	a5,0x80000
ffffffffc02045b4:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02045b6:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc02045b8:	0ec52703          	lw	a4,236(a0)
ffffffffc02045bc:	0af70f63          	beq	a4,a5,ffffffffc020467a <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc02045c0:	6018                	ld	a4,0(s0)
ffffffffc02045c2:	7b7c                	ld	a5,240(a4)
ffffffffc02045c4:	c3a1                	beqz	a5,ffffffffc0204604 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02045c6:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045ca:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02045cc:	0985                	addi	s3,s3,1
ffffffffc02045ce:	a021                	j	ffffffffc02045d6 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02045d0:	6018                	ld	a4,0(s0)
ffffffffc02045d2:	7b7c                	ld	a5,240(a4)
ffffffffc02045d4:	cb85                	beqz	a5,ffffffffc0204604 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02045d6:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4f90>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045da:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02045dc:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045de:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02045e0:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02045e4:	10e7b023          	sd	a4,256(a5)
ffffffffc02045e8:	c311                	beqz	a4,ffffffffc02045ec <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02045ea:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045ec:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02045ee:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02045f0:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045f2:	fd271fe3          	bne	a4,s2,ffffffffc02045d0 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02045f6:	0ec52783          	lw	a5,236(a0)
ffffffffc02045fa:	fd379be3          	bne	a5,s3,ffffffffc02045d0 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02045fe:	30d000ef          	jal	ra,ffffffffc020510a <wakeup_proc>
ffffffffc0204602:	b7f9                	j	ffffffffc02045d0 <do_exit+0x9a>
    if (flag)
ffffffffc0204604:	020a1263          	bnez	s4,ffffffffc0204628 <do_exit+0xf2>
    schedule();
ffffffffc0204608:	383000ef          	jal	ra,ffffffffc020518a <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc020460c:	601c                	ld	a5,0(s0)
ffffffffc020460e:	00003617          	auipc	a2,0x3
ffffffffc0204612:	b3a60613          	addi	a2,a2,-1222 # ffffffffc0207148 <default_pmm_manager+0x780>
ffffffffc0204616:	23800593          	li	a1,568
ffffffffc020461a:	43d4                	lw	a3,4(a5)
ffffffffc020461c:	00003517          	auipc	a0,0x3
ffffffffc0204620:	aac50513          	addi	a0,a0,-1364 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204624:	bfbfb0ef          	jal	ra,ffffffffc020021e <__panic>
        intr_enable();
ffffffffc0204628:	b8cfc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020462c:	bff1                	j	ffffffffc0204608 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc020462e:	00003617          	auipc	a2,0x3
ffffffffc0204632:	afa60613          	addi	a2,a2,-1286 # ffffffffc0207128 <default_pmm_manager+0x760>
ffffffffc0204636:	20400593          	li	a1,516
ffffffffc020463a:	00003517          	auipc	a0,0x3
ffffffffc020463e:	a8e50513          	addi	a0,a0,-1394 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204642:	bddfb0ef          	jal	ra,ffffffffc020021e <__panic>
            exit_mmap(mm);
ffffffffc0204646:	854e                	mv	a0,s3
ffffffffc0204648:	d77fc0ef          	jal	ra,ffffffffc02013be <exit_mmap>
            put_pgdir(mm);
ffffffffc020464c:	854e                	mv	a0,s3
ffffffffc020464e:	9ddff0ef          	jal	ra,ffffffffc020402a <put_pgdir>
            mm_destroy(mm);
ffffffffc0204652:	854e                	mv	a0,s3
ffffffffc0204654:	bcffc0ef          	jal	ra,ffffffffc0201222 <mm_destroy>
ffffffffc0204658:	bf35                	j	ffffffffc0204594 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc020465a:	00003617          	auipc	a2,0x3
ffffffffc020465e:	ade60613          	addi	a2,a2,-1314 # ffffffffc0207138 <default_pmm_manager+0x770>
ffffffffc0204662:	20800593          	li	a1,520
ffffffffc0204666:	00003517          	auipc	a0,0x3
ffffffffc020466a:	a6250513          	addi	a0,a0,-1438 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc020466e:	bb1fb0ef          	jal	ra,ffffffffc020021e <__panic>
        intr_disable();
ffffffffc0204672:	b48fc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0204676:	4a05                	li	s4,1
ffffffffc0204678:	bf1d                	j	ffffffffc02045ae <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc020467a:	291000ef          	jal	ra,ffffffffc020510a <wakeup_proc>
ffffffffc020467e:	b789                	j	ffffffffc02045c0 <do_exit+0x8a>

ffffffffc0204680 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204680:	715d                	addi	sp,sp,-80
ffffffffc0204682:	f84a                	sd	s2,48(sp)
ffffffffc0204684:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204686:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc020468a:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc020468c:	fc26                	sd	s1,56(sp)
ffffffffc020468e:	f052                	sd	s4,32(sp)
ffffffffc0204690:	ec56                	sd	s5,24(sp)
ffffffffc0204692:	e85a                	sd	s6,16(sp)
ffffffffc0204694:	e45e                	sd	s7,8(sp)
ffffffffc0204696:	e486                	sd	ra,72(sp)
ffffffffc0204698:	e0a2                	sd	s0,64(sp)
ffffffffc020469a:	84aa                	mv	s1,a0
ffffffffc020469c:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020469e:	000a6b97          	auipc	s7,0xa6
ffffffffc02046a2:	562b8b93          	addi	s7,s7,1378 # ffffffffc02aac00 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc02046a6:	00050b1b          	sext.w	s6,a0
ffffffffc02046aa:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02046ae:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc02046b0:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc02046b2:	ccbd                	beqz	s1,ffffffffc0204730 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc02046b4:	0359e863          	bltu	s3,s5,ffffffffc02046e4 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02046b8:	45a9                	li	a1,10
ffffffffc02046ba:	855a                	mv	a0,s6
ffffffffc02046bc:	0f4010ef          	jal	ra,ffffffffc02057b0 <hash32>
ffffffffc02046c0:	02051793          	slli	a5,a0,0x20
ffffffffc02046c4:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02046c8:	000a2797          	auipc	a5,0xa2
ffffffffc02046cc:	4c878793          	addi	a5,a5,1224 # ffffffffc02a6b90 <hash_list>
ffffffffc02046d0:	953e                	add	a0,a0,a5
ffffffffc02046d2:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02046d4:	a029                	j	ffffffffc02046de <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02046d6:	f2c42783          	lw	a5,-212(s0)
ffffffffc02046da:	02978163          	beq	a5,s1,ffffffffc02046fc <do_wait.part.0+0x7c>
ffffffffc02046de:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02046e0:	fe851be3          	bne	a0,s0,ffffffffc02046d6 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02046e4:	5579                	li	a0,-2
}
ffffffffc02046e6:	60a6                	ld	ra,72(sp)
ffffffffc02046e8:	6406                	ld	s0,64(sp)
ffffffffc02046ea:	74e2                	ld	s1,56(sp)
ffffffffc02046ec:	7942                	ld	s2,48(sp)
ffffffffc02046ee:	79a2                	ld	s3,40(sp)
ffffffffc02046f0:	7a02                	ld	s4,32(sp)
ffffffffc02046f2:	6ae2                	ld	s5,24(sp)
ffffffffc02046f4:	6b42                	ld	s6,16(sp)
ffffffffc02046f6:	6ba2                	ld	s7,8(sp)
ffffffffc02046f8:	6161                	addi	sp,sp,80
ffffffffc02046fa:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02046fc:	000bb683          	ld	a3,0(s7)
ffffffffc0204700:	f4843783          	ld	a5,-184(s0)
ffffffffc0204704:	fed790e3          	bne	a5,a3,ffffffffc02046e4 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204708:	f2842703          	lw	a4,-216(s0)
ffffffffc020470c:	478d                	li	a5,3
ffffffffc020470e:	0ef70b63          	beq	a4,a5,ffffffffc0204804 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0204712:	4785                	li	a5,1
ffffffffc0204714:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204716:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc020471a:	271000ef          	jal	ra,ffffffffc020518a <schedule>
        if (current->flags & PF_EXITING)
ffffffffc020471e:	000bb783          	ld	a5,0(s7)
ffffffffc0204722:	0b07a783          	lw	a5,176(a5)
ffffffffc0204726:	8b85                	andi	a5,a5,1
ffffffffc0204728:	d7c9                	beqz	a5,ffffffffc02046b2 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc020472a:	555d                	li	a0,-9
ffffffffc020472c:	e0bff0ef          	jal	ra,ffffffffc0204536 <do_exit>
        proc = current->cptr;
ffffffffc0204730:	000bb683          	ld	a3,0(s7)
ffffffffc0204734:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204736:	d45d                	beqz	s0,ffffffffc02046e4 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204738:	470d                	li	a4,3
ffffffffc020473a:	a021                	j	ffffffffc0204742 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc020473c:	10043403          	ld	s0,256(s0)
ffffffffc0204740:	d869                	beqz	s0,ffffffffc0204712 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204742:	401c                	lw	a5,0(s0)
ffffffffc0204744:	fee79ce3          	bne	a5,a4,ffffffffc020473c <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204748:	000a6797          	auipc	a5,0xa6
ffffffffc020474c:	4c07b783          	ld	a5,1216(a5) # ffffffffc02aac08 <idleproc>
ffffffffc0204750:	0c878963          	beq	a5,s0,ffffffffc0204822 <do_wait.part.0+0x1a2>
ffffffffc0204754:	000a6797          	auipc	a5,0xa6
ffffffffc0204758:	4bc7b783          	ld	a5,1212(a5) # ffffffffc02aac10 <initproc>
ffffffffc020475c:	0cf40363          	beq	s0,a5,ffffffffc0204822 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204760:	000a0663          	beqz	s4,ffffffffc020476c <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204764:	0e842783          	lw	a5,232(s0)
ffffffffc0204768:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8c00>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020476c:	100027f3          	csrr	a5,sstatus
ffffffffc0204770:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204772:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204774:	e7c1                	bnez	a5,ffffffffc02047fc <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204776:	6c70                	ld	a2,216(s0)
ffffffffc0204778:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc020477a:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020477e:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204780:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204782:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204784:	6470                	ld	a2,200(s0)
ffffffffc0204786:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204788:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020478a:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc020478c:	c319                	beqz	a4,ffffffffc0204792 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020478e:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204790:	7c7c                	ld	a5,248(s0)
ffffffffc0204792:	c3b5                	beqz	a5,ffffffffc02047f6 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204794:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204798:	000a6717          	auipc	a4,0xa6
ffffffffc020479c:	48070713          	addi	a4,a4,1152 # ffffffffc02aac18 <nr_process>
ffffffffc02047a0:	431c                	lw	a5,0(a4)
ffffffffc02047a2:	37fd                	addiw	a5,a5,-1
ffffffffc02047a4:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02047a6:	e5a9                	bnez	a1,ffffffffc02047f0 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02047a8:	6814                	ld	a3,16(s0)
ffffffffc02047aa:	c02007b7          	lui	a5,0xc0200
ffffffffc02047ae:	04f6ee63          	bltu	a3,a5,ffffffffc020480a <do_wait.part.0+0x18a>
ffffffffc02047b2:	000a6797          	auipc	a5,0xa6
ffffffffc02047b6:	4467b783          	ld	a5,1094(a5) # ffffffffc02aabf8 <va_pa_offset>
ffffffffc02047ba:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02047bc:	82b1                	srli	a3,a3,0xc
ffffffffc02047be:	000a6797          	auipc	a5,0xa6
ffffffffc02047c2:	4227b783          	ld	a5,1058(a5) # ffffffffc02aabe0 <npage>
ffffffffc02047c6:	06f6fa63          	bgeu	a3,a5,ffffffffc020483a <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02047ca:	00003517          	auipc	a0,0x3
ffffffffc02047ce:	1b653503          	ld	a0,438(a0) # ffffffffc0207980 <nbase>
ffffffffc02047d2:	8e89                	sub	a3,a3,a0
ffffffffc02047d4:	069a                	slli	a3,a3,0x6
ffffffffc02047d6:	000a6517          	auipc	a0,0xa6
ffffffffc02047da:	41253503          	ld	a0,1042(a0) # ffffffffc02aabe8 <pages>
ffffffffc02047de:	9536                	add	a0,a0,a3
ffffffffc02047e0:	4589                	li	a1,2
ffffffffc02047e2:	f07fd0ef          	jal	ra,ffffffffc02026e8 <free_pages>
    kfree(proc);
ffffffffc02047e6:	8522                	mv	a0,s0
ffffffffc02047e8:	ae6fd0ef          	jal	ra,ffffffffc0201ace <kfree>
    return 0;
ffffffffc02047ec:	4501                	li	a0,0
ffffffffc02047ee:	bde5                	j	ffffffffc02046e6 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02047f0:	9c4fc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02047f4:	bf55                	j	ffffffffc02047a8 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02047f6:	701c                	ld	a5,32(s0)
ffffffffc02047f8:	fbf8                	sd	a4,240(a5)
ffffffffc02047fa:	bf79                	j	ffffffffc0204798 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02047fc:	9befc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0204800:	4585                	li	a1,1
ffffffffc0204802:	bf95                	j	ffffffffc0204776 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204804:	f2840413          	addi	s0,s0,-216
ffffffffc0204808:	b781                	j	ffffffffc0204748 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc020480a:	00002617          	auipc	a2,0x2
ffffffffc020480e:	dce60613          	addi	a2,a2,-562 # ffffffffc02065d8 <commands+0xb68>
ffffffffc0204812:	07700593          	li	a1,119
ffffffffc0204816:	00002517          	auipc	a0,0x2
ffffffffc020481a:	d4250513          	addi	a0,a0,-702 # ffffffffc0206558 <commands+0xae8>
ffffffffc020481e:	a01fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0204822:	00003617          	auipc	a2,0x3
ffffffffc0204826:	94660613          	addi	a2,a2,-1722 # ffffffffc0207168 <default_pmm_manager+0x7a0>
ffffffffc020482a:	36100593          	li	a1,865
ffffffffc020482e:	00003517          	auipc	a0,0x3
ffffffffc0204832:	89a50513          	addi	a0,a0,-1894 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204836:	9e9fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020483a:	00002617          	auipc	a2,0x2
ffffffffc020483e:	dc660613          	addi	a2,a2,-570 # ffffffffc0206600 <commands+0xb90>
ffffffffc0204842:	06900593          	li	a1,105
ffffffffc0204846:	00002517          	auipc	a0,0x2
ffffffffc020484a:	d1250513          	addi	a0,a0,-750 # ffffffffc0206558 <commands+0xae8>
ffffffffc020484e:	9d1fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0204852 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204852:	1141                	addi	sp,sp,-16
ffffffffc0204854:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204856:	ed3fd0ef          	jal	ra,ffffffffc0202728 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc020485a:	9c0fd0ef          	jal	ra,ffffffffc0201a1a <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020485e:	4601                	li	a2,0
ffffffffc0204860:	4581                	li	a1,0
ffffffffc0204862:	fffff517          	auipc	a0,0xfffff
ffffffffc0204866:	74a50513          	addi	a0,a0,1866 # ffffffffc0203fac <user_main>
ffffffffc020486a:	c7dff0ef          	jal	ra,ffffffffc02044e6 <kernel_thread>
    if (pid <= 0)
ffffffffc020486e:	00a04563          	bgtz	a0,ffffffffc0204878 <init_main+0x26>
ffffffffc0204872:	a071                	j	ffffffffc02048fe <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204874:	117000ef          	jal	ra,ffffffffc020518a <schedule>
    if (code_store != NULL)
ffffffffc0204878:	4581                	li	a1,0
ffffffffc020487a:	4501                	li	a0,0
ffffffffc020487c:	e05ff0ef          	jal	ra,ffffffffc0204680 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204880:	d975                	beqz	a0,ffffffffc0204874 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204882:	00003517          	auipc	a0,0x3
ffffffffc0204886:	92650513          	addi	a0,a0,-1754 # ffffffffc02071a8 <default_pmm_manager+0x7e0>
ffffffffc020488a:	857fb0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020488e:	000a6797          	auipc	a5,0xa6
ffffffffc0204892:	3827b783          	ld	a5,898(a5) # ffffffffc02aac10 <initproc>
ffffffffc0204896:	7bf8                	ld	a4,240(a5)
ffffffffc0204898:	e339                	bnez	a4,ffffffffc02048de <init_main+0x8c>
ffffffffc020489a:	7ff8                	ld	a4,248(a5)
ffffffffc020489c:	e329                	bnez	a4,ffffffffc02048de <init_main+0x8c>
ffffffffc020489e:	1007b703          	ld	a4,256(a5)
ffffffffc02048a2:	ef15                	bnez	a4,ffffffffc02048de <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02048a4:	000a6697          	auipc	a3,0xa6
ffffffffc02048a8:	3746a683          	lw	a3,884(a3) # ffffffffc02aac18 <nr_process>
ffffffffc02048ac:	4709                	li	a4,2
ffffffffc02048ae:	0ae69463          	bne	a3,a4,ffffffffc0204956 <init_main+0x104>
    return listelm->next;
ffffffffc02048b2:	000a6697          	auipc	a3,0xa6
ffffffffc02048b6:	2de68693          	addi	a3,a3,734 # ffffffffc02aab90 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02048ba:	6698                	ld	a4,8(a3)
ffffffffc02048bc:	0c878793          	addi	a5,a5,200
ffffffffc02048c0:	06f71b63          	bne	a4,a5,ffffffffc0204936 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02048c4:	629c                	ld	a5,0(a3)
ffffffffc02048c6:	04f71863          	bne	a4,a5,ffffffffc0204916 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02048ca:	00003517          	auipc	a0,0x3
ffffffffc02048ce:	9c650513          	addi	a0,a0,-1594 # ffffffffc0207290 <default_pmm_manager+0x8c8>
ffffffffc02048d2:	80ffb0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
}
ffffffffc02048d6:	60a2                	ld	ra,8(sp)
ffffffffc02048d8:	4501                	li	a0,0
ffffffffc02048da:	0141                	addi	sp,sp,16
ffffffffc02048dc:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02048de:	00003697          	auipc	a3,0x3
ffffffffc02048e2:	8f268693          	addi	a3,a3,-1806 # ffffffffc02071d0 <default_pmm_manager+0x808>
ffffffffc02048e6:	00002617          	auipc	a2,0x2
ffffffffc02048ea:	9d260613          	addi	a2,a2,-1582 # ffffffffc02062b8 <commands+0x848>
ffffffffc02048ee:	3cf00593          	li	a1,975
ffffffffc02048f2:	00002517          	auipc	a0,0x2
ffffffffc02048f6:	7d650513          	addi	a0,a0,2006 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc02048fa:	925fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("create user_main failed.\n");
ffffffffc02048fe:	00003617          	auipc	a2,0x3
ffffffffc0204902:	88a60613          	addi	a2,a2,-1910 # ffffffffc0207188 <default_pmm_manager+0x7c0>
ffffffffc0204906:	3c600593          	li	a1,966
ffffffffc020490a:	00002517          	auipc	a0,0x2
ffffffffc020490e:	7be50513          	addi	a0,a0,1982 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204912:	90dfb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204916:	00003697          	auipc	a3,0x3
ffffffffc020491a:	94a68693          	addi	a3,a3,-1718 # ffffffffc0207260 <default_pmm_manager+0x898>
ffffffffc020491e:	00002617          	auipc	a2,0x2
ffffffffc0204922:	99a60613          	addi	a2,a2,-1638 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204926:	3d200593          	li	a1,978
ffffffffc020492a:	00002517          	auipc	a0,0x2
ffffffffc020492e:	79e50513          	addi	a0,a0,1950 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204932:	8edfb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204936:	00003697          	auipc	a3,0x3
ffffffffc020493a:	8fa68693          	addi	a3,a3,-1798 # ffffffffc0207230 <default_pmm_manager+0x868>
ffffffffc020493e:	00002617          	auipc	a2,0x2
ffffffffc0204942:	97a60613          	addi	a2,a2,-1670 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204946:	3d100593          	li	a1,977
ffffffffc020494a:	00002517          	auipc	a0,0x2
ffffffffc020494e:	77e50513          	addi	a0,a0,1918 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204952:	8cdfb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_process == 2);
ffffffffc0204956:	00003697          	auipc	a3,0x3
ffffffffc020495a:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0207220 <default_pmm_manager+0x858>
ffffffffc020495e:	00002617          	auipc	a2,0x2
ffffffffc0204962:	95a60613          	addi	a2,a2,-1702 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204966:	3d000593          	li	a1,976
ffffffffc020496a:	00002517          	auipc	a0,0x2
ffffffffc020496e:	75e50513          	addi	a0,a0,1886 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204972:	8adfb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0204976 <do_execve>:
{
ffffffffc0204976:	7171                	addi	sp,sp,-176
ffffffffc0204978:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc020497a:	000a6d97          	auipc	s11,0xa6
ffffffffc020497e:	286d8d93          	addi	s11,s11,646 # ffffffffc02aac00 <current>
ffffffffc0204982:	000db783          	ld	a5,0(s11)
{
ffffffffc0204986:	e54e                	sd	s3,136(sp)
ffffffffc0204988:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc020498a:	0287b983          	ld	s3,40(a5)
{
ffffffffc020498e:	e94a                	sd	s2,144(sp)
ffffffffc0204990:	f4de                	sd	s7,104(sp)
ffffffffc0204992:	892a                	mv	s2,a0
ffffffffc0204994:	8bb2                	mv	s7,a2
ffffffffc0204996:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204998:	862e                	mv	a2,a1
ffffffffc020499a:	4681                	li	a3,0
ffffffffc020499c:	85aa                	mv	a1,a0
ffffffffc020499e:	854e                	mv	a0,s3
{
ffffffffc02049a0:	f506                	sd	ra,168(sp)
ffffffffc02049a2:	f122                	sd	s0,160(sp)
ffffffffc02049a4:	e152                	sd	s4,128(sp)
ffffffffc02049a6:	fcd6                	sd	s5,120(sp)
ffffffffc02049a8:	f8da                	sd	s6,112(sp)
ffffffffc02049aa:	f0e2                	sd	s8,96(sp)
ffffffffc02049ac:	ece6                	sd	s9,88(sp)
ffffffffc02049ae:	e8ea                	sd	s10,80(sp)
ffffffffc02049b0:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc02049b2:	da7fc0ef          	jal	ra,ffffffffc0201758 <user_mem_check>
ffffffffc02049b6:	40050c63          	beqz	a0,ffffffffc0204dce <do_execve+0x458>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02049ba:	4641                	li	a2,16
ffffffffc02049bc:	4581                	li	a1,0
ffffffffc02049be:	1808                	addi	a0,sp,48
ffffffffc02049c0:	1d9000ef          	jal	ra,ffffffffc0205398 <memset>
    memcpy(local_name, name, len);
ffffffffc02049c4:	47bd                	li	a5,15
ffffffffc02049c6:	8626                	mv	a2,s1
ffffffffc02049c8:	1e97e463          	bltu	a5,s1,ffffffffc0204bb0 <do_execve+0x23a>
ffffffffc02049cc:	85ca                	mv	a1,s2
ffffffffc02049ce:	1808                	addi	a0,sp,48
ffffffffc02049d0:	1db000ef          	jal	ra,ffffffffc02053aa <memcpy>
    if (mm != NULL)
ffffffffc02049d4:	1e098563          	beqz	s3,ffffffffc0204bbe <do_execve+0x248>
        cputs("mm != NULL");
ffffffffc02049d8:	00002517          	auipc	a0,0x2
ffffffffc02049dc:	98050513          	addi	a0,a0,-1664 # ffffffffc0206358 <commands+0x8e8>
ffffffffc02049e0:	f3afb0ef          	jal	ra,ffffffffc020011a <cputs>
ffffffffc02049e4:	000a6797          	auipc	a5,0xa6
ffffffffc02049e8:	1ec7b783          	ld	a5,492(a5) # ffffffffc02aabd0 <boot_pgdir_pa>
ffffffffc02049ec:	577d                	li	a4,-1
ffffffffc02049ee:	177e                	slli	a4,a4,0x3f
ffffffffc02049f0:	83b1                	srli	a5,a5,0xc
ffffffffc02049f2:	8fd9                	or	a5,a5,a4
ffffffffc02049f4:	18079073          	csrw	satp,a5
ffffffffc02049f8:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7bd0>
ffffffffc02049fc:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204a00:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204a04:	2c070663          	beqz	a4,ffffffffc0204cd0 <do_execve+0x35a>
        current->mm = NULL;
ffffffffc0204a08:	000db783          	ld	a5,0(s11)
ffffffffc0204a0c:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204a10:	ed2fc0ef          	jal	ra,ffffffffc02010e2 <mm_create>
ffffffffc0204a14:	84aa                	mv	s1,a0
ffffffffc0204a16:	1c050f63          	beqz	a0,ffffffffc0204bf4 <do_execve+0x27e>
    if ((page = alloc_page()) == NULL)
ffffffffc0204a1a:	4505                	li	a0,1
ffffffffc0204a1c:	c8ffd0ef          	jal	ra,ffffffffc02026aa <alloc_pages>
ffffffffc0204a20:	3a050b63          	beqz	a0,ffffffffc0204dd6 <do_execve+0x460>
    return page - pages + nbase;
ffffffffc0204a24:	000a6c97          	auipc	s9,0xa6
ffffffffc0204a28:	1c4c8c93          	addi	s9,s9,452 # ffffffffc02aabe8 <pages>
ffffffffc0204a2c:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204a30:	000a6c17          	auipc	s8,0xa6
ffffffffc0204a34:	1b0c0c13          	addi	s8,s8,432 # ffffffffc02aabe0 <npage>
    return page - pages + nbase;
ffffffffc0204a38:	00003717          	auipc	a4,0x3
ffffffffc0204a3c:	f4873703          	ld	a4,-184(a4) # ffffffffc0207980 <nbase>
ffffffffc0204a40:	40d506b3          	sub	a3,a0,a3
ffffffffc0204a44:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204a46:	5afd                	li	s5,-1
ffffffffc0204a48:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204a4c:	96ba                	add	a3,a3,a4
ffffffffc0204a4e:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204a50:	00cad713          	srli	a4,s5,0xc
ffffffffc0204a54:	ec3a                	sd	a4,24(sp)
ffffffffc0204a56:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204a58:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204a5a:	38f77263          	bgeu	a4,a5,ffffffffc0204dde <do_execve+0x468>
ffffffffc0204a5e:	000a6b17          	auipc	s6,0xa6
ffffffffc0204a62:	19ab0b13          	addi	s6,s6,410 # ffffffffc02aabf8 <va_pa_offset>
ffffffffc0204a66:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204a6a:	6605                	lui	a2,0x1
ffffffffc0204a6c:	000a6597          	auipc	a1,0xa6
ffffffffc0204a70:	16c5b583          	ld	a1,364(a1) # ffffffffc02aabd8 <boot_pgdir_va>
ffffffffc0204a74:	9936                	add	s2,s2,a3
ffffffffc0204a76:	854a                	mv	a0,s2
ffffffffc0204a78:	133000ef          	jal	ra,ffffffffc02053aa <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a7c:	7782                	ld	a5,32(sp)
ffffffffc0204a7e:	4398                	lw	a4,0(a5)
ffffffffc0204a80:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204a84:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204a88:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b940f>
ffffffffc0204a8c:	14f71a63          	bne	a4,a5,ffffffffc0204be0 <do_execve+0x26a>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204a90:	7682                	ld	a3,32(sp)
ffffffffc0204a92:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204a96:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204a9a:	00371793          	slli	a5,a4,0x3
ffffffffc0204a9e:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204aa0:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204aa2:	078e                	slli	a5,a5,0x3
ffffffffc0204aa4:	97ce                	add	a5,a5,s3
ffffffffc0204aa6:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204aa8:	00f9fc63          	bgeu	s3,a5,ffffffffc0204ac0 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204aac:	0009a783          	lw	a5,0(s3)
ffffffffc0204ab0:	4705                	li	a4,1
ffffffffc0204ab2:	14e78363          	beq	a5,a4,ffffffffc0204bf8 <do_execve+0x282>
    for (; ph < ph_end; ph++)
ffffffffc0204ab6:	77a2                	ld	a5,40(sp)
ffffffffc0204ab8:	03898993          	addi	s3,s3,56
ffffffffc0204abc:	fef9e8e3          	bltu	s3,a5,ffffffffc0204aac <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204ac0:	4701                	li	a4,0
ffffffffc0204ac2:	46ad                	li	a3,11
ffffffffc0204ac4:	00100637          	lui	a2,0x100
ffffffffc0204ac8:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204acc:	8526                	mv	a0,s1
ffffffffc0204ace:	fa6fc0ef          	jal	ra,ffffffffc0201274 <mm_map>
ffffffffc0204ad2:	8a2a                	mv	s4,a0
ffffffffc0204ad4:	1e051463          	bnez	a0,ffffffffc0204cbc <do_execve+0x346>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204ad8:	6c88                	ld	a0,24(s1)
ffffffffc0204ada:	467d                	li	a2,31
ffffffffc0204adc:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204ae0:	b08ff0ef          	jal	ra,ffffffffc0203de8 <pgdir_alloc_page>
ffffffffc0204ae4:	38050563          	beqz	a0,ffffffffc0204e6e <do_execve+0x4f8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ae8:	6c88                	ld	a0,24(s1)
ffffffffc0204aea:	467d                	li	a2,31
ffffffffc0204aec:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204af0:	af8ff0ef          	jal	ra,ffffffffc0203de8 <pgdir_alloc_page>
ffffffffc0204af4:	34050d63          	beqz	a0,ffffffffc0204e4e <do_execve+0x4d8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204af8:	6c88                	ld	a0,24(s1)
ffffffffc0204afa:	467d                	li	a2,31
ffffffffc0204afc:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204b00:	ae8ff0ef          	jal	ra,ffffffffc0203de8 <pgdir_alloc_page>
ffffffffc0204b04:	32050563          	beqz	a0,ffffffffc0204e2e <do_execve+0x4b8>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204b08:	6c88                	ld	a0,24(s1)
ffffffffc0204b0a:	467d                	li	a2,31
ffffffffc0204b0c:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204b10:	ad8ff0ef          	jal	ra,ffffffffc0203de8 <pgdir_alloc_page>
ffffffffc0204b14:	2e050d63          	beqz	a0,ffffffffc0204e0e <do_execve+0x498>
    mm->mm_count += 1;
ffffffffc0204b18:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204b1a:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b1e:	6c94                	ld	a3,24(s1)
ffffffffc0204b20:	2785                	addiw	a5,a5,1
ffffffffc0204b22:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204b24:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204b26:	c02007b7          	lui	a5,0xc0200
ffffffffc0204b2a:	2cf6e663          	bltu	a3,a5,ffffffffc0204df6 <do_execve+0x480>
ffffffffc0204b2e:	000b3783          	ld	a5,0(s6)
ffffffffc0204b32:	577d                	li	a4,-1
ffffffffc0204b34:	177e                	slli	a4,a4,0x3f
ffffffffc0204b36:	8e9d                	sub	a3,a3,a5
ffffffffc0204b38:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204b3c:	f654                	sd	a3,168(a2)
ffffffffc0204b3e:	8fd9                	or	a5,a5,a4
ffffffffc0204b40:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204b44:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204b46:	4581                	li	a1,0
ffffffffc0204b48:	12000613          	li	a2,288
ffffffffc0204b4c:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204b4e:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204b52:	047000ef          	jal	ra,ffffffffc0205398 <memset>
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0204b56:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b58:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204b5c:	edf4f493          	andi	s1,s1,-289
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0204b60:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0204b62:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b64:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f44>
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0204b68:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204b6a:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b6e:	4641                	li	a2,16
ffffffffc0204b70:	4581                	li	a1,0
    tf->gpr.sp = (uintptr_t)USTACKTOP;
ffffffffc0204b72:	e81c                	sd	a5,16(s0)
    tf->epc = (uintptr_t)elf->e_entry;
ffffffffc0204b74:	10e43423          	sd	a4,264(s0)
    tf->gpr.a0 = 0;
ffffffffc0204b78:	04043823          	sd	zero,80(s0)
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
ffffffffc0204b7c:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204b80:	854a                	mv	a0,s2
ffffffffc0204b82:	017000ef          	jal	ra,ffffffffc0205398 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204b86:	463d                	li	a2,15
ffffffffc0204b88:	180c                	addi	a1,sp,48
ffffffffc0204b8a:	854a                	mv	a0,s2
ffffffffc0204b8c:	01f000ef          	jal	ra,ffffffffc02053aa <memcpy>
}
ffffffffc0204b90:	70aa                	ld	ra,168(sp)
ffffffffc0204b92:	740a                	ld	s0,160(sp)
ffffffffc0204b94:	64ea                	ld	s1,152(sp)
ffffffffc0204b96:	694a                	ld	s2,144(sp)
ffffffffc0204b98:	69aa                	ld	s3,136(sp)
ffffffffc0204b9a:	7ae6                	ld	s5,120(sp)
ffffffffc0204b9c:	7b46                	ld	s6,112(sp)
ffffffffc0204b9e:	7ba6                	ld	s7,104(sp)
ffffffffc0204ba0:	7c06                	ld	s8,96(sp)
ffffffffc0204ba2:	6ce6                	ld	s9,88(sp)
ffffffffc0204ba4:	6d46                	ld	s10,80(sp)
ffffffffc0204ba6:	6da6                	ld	s11,72(sp)
ffffffffc0204ba8:	8552                	mv	a0,s4
ffffffffc0204baa:	6a0a                	ld	s4,128(sp)
ffffffffc0204bac:	614d                	addi	sp,sp,176
ffffffffc0204bae:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204bb0:	463d                	li	a2,15
ffffffffc0204bb2:	85ca                	mv	a1,s2
ffffffffc0204bb4:	1808                	addi	a0,sp,48
ffffffffc0204bb6:	7f4000ef          	jal	ra,ffffffffc02053aa <memcpy>
    if (mm != NULL)
ffffffffc0204bba:	e0099fe3          	bnez	s3,ffffffffc02049d8 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204bbe:	000db783          	ld	a5,0(s11)
ffffffffc0204bc2:	779c                	ld	a5,40(a5)
ffffffffc0204bc4:	e40786e3          	beqz	a5,ffffffffc0204a10 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204bc8:	00002617          	auipc	a2,0x2
ffffffffc0204bcc:	6e860613          	addi	a2,a2,1768 # ffffffffc02072b0 <default_pmm_manager+0x8e8>
ffffffffc0204bd0:	24400593          	li	a1,580
ffffffffc0204bd4:	00002517          	auipc	a0,0x2
ffffffffc0204bd8:	4f450513          	addi	a0,a0,1268 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204bdc:	e42fb0ef          	jal	ra,ffffffffc020021e <__panic>
    put_pgdir(mm);
ffffffffc0204be0:	8526                	mv	a0,s1
ffffffffc0204be2:	c48ff0ef          	jal	ra,ffffffffc020402a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204be6:	8526                	mv	a0,s1
ffffffffc0204be8:	e3afc0ef          	jal	ra,ffffffffc0201222 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204bec:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204bee:	8552                	mv	a0,s4
ffffffffc0204bf0:	947ff0ef          	jal	ra,ffffffffc0204536 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204bf4:	5a71                	li	s4,-4
ffffffffc0204bf6:	bfe5                	j	ffffffffc0204bee <do_execve+0x278>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204bf8:	0289b603          	ld	a2,40(s3)
ffffffffc0204bfc:	0209b783          	ld	a5,32(s3)
ffffffffc0204c00:	1cf66d63          	bltu	a2,a5,ffffffffc0204dda <do_execve+0x464>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204c04:	0049a783          	lw	a5,4(s3)
ffffffffc0204c08:	0017f693          	andi	a3,a5,1
ffffffffc0204c0c:	c291                	beqz	a3,ffffffffc0204c10 <do_execve+0x29a>
            vm_flags |= VM_EXEC;
ffffffffc0204c0e:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204c10:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c14:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204c16:	e779                	bnez	a4,ffffffffc0204ce4 <do_execve+0x36e>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204c18:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204c1a:	c781                	beqz	a5,ffffffffc0204c22 <do_execve+0x2ac>
            vm_flags |= VM_READ;
ffffffffc0204c1c:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204c20:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204c22:	0026f793          	andi	a5,a3,2
ffffffffc0204c26:	e3f1                	bnez	a5,ffffffffc0204cea <do_execve+0x374>
        if (vm_flags & VM_EXEC)
ffffffffc0204c28:	0046f793          	andi	a5,a3,4
ffffffffc0204c2c:	c399                	beqz	a5,ffffffffc0204c32 <do_execve+0x2bc>
            perm |= PTE_X;
ffffffffc0204c2e:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204c32:	0109b583          	ld	a1,16(s3)
ffffffffc0204c36:	4701                	li	a4,0
ffffffffc0204c38:	8526                	mv	a0,s1
ffffffffc0204c3a:	e3afc0ef          	jal	ra,ffffffffc0201274 <mm_map>
ffffffffc0204c3e:	8a2a                	mv	s4,a0
ffffffffc0204c40:	ed35                	bnez	a0,ffffffffc0204cbc <do_execve+0x346>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c42:	0109bb83          	ld	s7,16(s3)
ffffffffc0204c46:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c48:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204c4c:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204c50:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204c54:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204c56:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204c58:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204c5a:	054be963          	bltu	s7,s4,ffffffffc0204cac <do_execve+0x336>
ffffffffc0204c5e:	aa95                	j	ffffffffc0204dd2 <do_execve+0x45c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c60:	6785                	lui	a5,0x1
ffffffffc0204c62:	415b8533          	sub	a0,s7,s5
ffffffffc0204c66:	9abe                	add	s5,s5,a5
ffffffffc0204c68:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204c6c:	015a7463          	bgeu	s4,s5,ffffffffc0204c74 <do_execve+0x2fe>
                size -= la - end;
ffffffffc0204c70:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204c74:	000cb683          	ld	a3,0(s9)
ffffffffc0204c78:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c7a:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c7e:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c82:	8699                	srai	a3,a3,0x6
ffffffffc0204c84:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c86:	67e2                	ld	a5,24(sp)
ffffffffc0204c88:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c8c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c8e:	14b87863          	bgeu	a6,a1,ffffffffc0204dde <do_execve+0x468>
ffffffffc0204c92:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204c96:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204c98:	9bb2                	add	s7,s7,a2
ffffffffc0204c9a:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204c9c:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204c9e:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204ca0:	70a000ef          	jal	ra,ffffffffc02053aa <memcpy>
            start += size, from += size;
ffffffffc0204ca4:	6622                	ld	a2,8(sp)
ffffffffc0204ca6:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204ca8:	054bf363          	bgeu	s7,s4,ffffffffc0204cee <do_execve+0x378>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204cac:	6c88                	ld	a0,24(s1)
ffffffffc0204cae:	866a                	mv	a2,s10
ffffffffc0204cb0:	85d6                	mv	a1,s5
ffffffffc0204cb2:	936ff0ef          	jal	ra,ffffffffc0203de8 <pgdir_alloc_page>
ffffffffc0204cb6:	842a                	mv	s0,a0
ffffffffc0204cb8:	f545                	bnez	a0,ffffffffc0204c60 <do_execve+0x2ea>
        ret = -E_NO_MEM;
ffffffffc0204cba:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204cbc:	8526                	mv	a0,s1
ffffffffc0204cbe:	f00fc0ef          	jal	ra,ffffffffc02013be <exit_mmap>
    put_pgdir(mm);
ffffffffc0204cc2:	8526                	mv	a0,s1
ffffffffc0204cc4:	b66ff0ef          	jal	ra,ffffffffc020402a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204cc8:	8526                	mv	a0,s1
ffffffffc0204cca:	d58fc0ef          	jal	ra,ffffffffc0201222 <mm_destroy>
    return ret;
ffffffffc0204cce:	b705                	j	ffffffffc0204bee <do_execve+0x278>
            exit_mmap(mm);
ffffffffc0204cd0:	854e                	mv	a0,s3
ffffffffc0204cd2:	eecfc0ef          	jal	ra,ffffffffc02013be <exit_mmap>
            put_pgdir(mm);
ffffffffc0204cd6:	854e                	mv	a0,s3
ffffffffc0204cd8:	b52ff0ef          	jal	ra,ffffffffc020402a <put_pgdir>
            mm_destroy(mm);
ffffffffc0204cdc:	854e                	mv	a0,s3
ffffffffc0204cde:	d44fc0ef          	jal	ra,ffffffffc0201222 <mm_destroy>
ffffffffc0204ce2:	b31d                	j	ffffffffc0204a08 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204ce4:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ce8:	fb95                	bnez	a5,ffffffffc0204c1c <do_execve+0x2a6>
            perm |= (PTE_W | PTE_R);
ffffffffc0204cea:	4d5d                	li	s10,23
ffffffffc0204cec:	bf35                	j	ffffffffc0204c28 <do_execve+0x2b2>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204cee:	0109b683          	ld	a3,16(s3)
ffffffffc0204cf2:	0289b903          	ld	s2,40(s3)
ffffffffc0204cf6:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204cf8:	075bfd63          	bgeu	s7,s5,ffffffffc0204d72 <do_execve+0x3fc>
            if (start == end)
ffffffffc0204cfc:	db790de3          	beq	s2,s7,ffffffffc0204ab6 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204d00:	6785                	lui	a5,0x1
ffffffffc0204d02:	00fb8533          	add	a0,s7,a5
ffffffffc0204d06:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204d0a:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204d0e:	0b597d63          	bgeu	s2,s5,ffffffffc0204dc8 <do_execve+0x452>
    return page - pages + nbase;
ffffffffc0204d12:	000cb683          	ld	a3,0(s9)
ffffffffc0204d16:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204d18:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204d1c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204d20:	8699                	srai	a3,a3,0x6
ffffffffc0204d22:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204d24:	67e2                	ld	a5,24(sp)
ffffffffc0204d26:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204d2a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204d2c:	0ac5f963          	bgeu	a1,a2,ffffffffc0204dde <do_execve+0x468>
ffffffffc0204d30:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204d34:	8652                	mv	a2,s4
ffffffffc0204d36:	4581                	li	a1,0
ffffffffc0204d38:	96c2                	add	a3,a3,a6
ffffffffc0204d3a:	9536                	add	a0,a0,a3
ffffffffc0204d3c:	65c000ef          	jal	ra,ffffffffc0205398 <memset>
            start += size;
ffffffffc0204d40:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204d44:	03597463          	bgeu	s2,s5,ffffffffc0204d6c <do_execve+0x3f6>
ffffffffc0204d48:	d6e907e3          	beq	s2,a4,ffffffffc0204ab6 <do_execve+0x140>
ffffffffc0204d4c:	00002697          	auipc	a3,0x2
ffffffffc0204d50:	58c68693          	addi	a3,a3,1420 # ffffffffc02072d8 <default_pmm_manager+0x910>
ffffffffc0204d54:	00001617          	auipc	a2,0x1
ffffffffc0204d58:	56460613          	addi	a2,a2,1380 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204d5c:	2ad00593          	li	a1,685
ffffffffc0204d60:	00002517          	auipc	a0,0x2
ffffffffc0204d64:	36850513          	addi	a0,a0,872 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204d68:	cb6fb0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0204d6c:	ff5710e3          	bne	a4,s5,ffffffffc0204d4c <do_execve+0x3d6>
ffffffffc0204d70:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204d72:	d52bf2e3          	bgeu	s7,s2,ffffffffc0204ab6 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204d76:	6c88                	ld	a0,24(s1)
ffffffffc0204d78:	866a                	mv	a2,s10
ffffffffc0204d7a:	85d6                	mv	a1,s5
ffffffffc0204d7c:	86cff0ef          	jal	ra,ffffffffc0203de8 <pgdir_alloc_page>
ffffffffc0204d80:	842a                	mv	s0,a0
ffffffffc0204d82:	dd05                	beqz	a0,ffffffffc0204cba <do_execve+0x344>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204d84:	6785                	lui	a5,0x1
ffffffffc0204d86:	415b8533          	sub	a0,s7,s5
ffffffffc0204d8a:	9abe                	add	s5,s5,a5
ffffffffc0204d8c:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204d90:	01597463          	bgeu	s2,s5,ffffffffc0204d98 <do_execve+0x422>
                size -= la - end;
ffffffffc0204d94:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204d98:	000cb683          	ld	a3,0(s9)
ffffffffc0204d9c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204d9e:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204da2:	40d406b3          	sub	a3,s0,a3
ffffffffc0204da6:	8699                	srai	a3,a3,0x6
ffffffffc0204da8:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204daa:	67e2                	ld	a5,24(sp)
ffffffffc0204dac:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204db0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204db2:	02b87663          	bgeu	a6,a1,ffffffffc0204dde <do_execve+0x468>
ffffffffc0204db6:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204dba:	4581                	li	a1,0
            start += size;
ffffffffc0204dbc:	9bb2                	add	s7,s7,a2
ffffffffc0204dbe:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204dc0:	9536                	add	a0,a0,a3
ffffffffc0204dc2:	5d6000ef          	jal	ra,ffffffffc0205398 <memset>
ffffffffc0204dc6:	b775                	j	ffffffffc0204d72 <do_execve+0x3fc>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204dc8:	417a8a33          	sub	s4,s5,s7
ffffffffc0204dcc:	b799                	j	ffffffffc0204d12 <do_execve+0x39c>
        return -E_INVAL;
ffffffffc0204dce:	5a75                	li	s4,-3
ffffffffc0204dd0:	b3c1                	j	ffffffffc0204b90 <do_execve+0x21a>
        while (start < end)
ffffffffc0204dd2:	86de                	mv	a3,s7
ffffffffc0204dd4:	bf39                	j	ffffffffc0204cf2 <do_execve+0x37c>
    int ret = -E_NO_MEM;
ffffffffc0204dd6:	5a71                	li	s4,-4
ffffffffc0204dd8:	bdc5                	j	ffffffffc0204cc8 <do_execve+0x352>
            ret = -E_INVAL_ELF;
ffffffffc0204dda:	5a61                	li	s4,-8
ffffffffc0204ddc:	b5c5                	j	ffffffffc0204cbc <do_execve+0x346>
ffffffffc0204dde:	00001617          	auipc	a2,0x1
ffffffffc0204de2:	75260613          	addi	a2,a2,1874 # ffffffffc0206530 <commands+0xac0>
ffffffffc0204de6:	07100593          	li	a1,113
ffffffffc0204dea:	00001517          	auipc	a0,0x1
ffffffffc0204dee:	76e50513          	addi	a0,a0,1902 # ffffffffc0206558 <commands+0xae8>
ffffffffc0204df2:	c2cfb0ef          	jal	ra,ffffffffc020021e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204df6:	00001617          	auipc	a2,0x1
ffffffffc0204dfa:	7e260613          	addi	a2,a2,2018 # ffffffffc02065d8 <commands+0xb68>
ffffffffc0204dfe:	2cc00593          	li	a1,716
ffffffffc0204e02:	00002517          	auipc	a0,0x2
ffffffffc0204e06:	2c650513          	addi	a0,a0,710 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204e0a:	c14fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e0e:	00002697          	auipc	a3,0x2
ffffffffc0204e12:	5e268693          	addi	a3,a3,1506 # ffffffffc02073f0 <default_pmm_manager+0xa28>
ffffffffc0204e16:	00001617          	auipc	a2,0x1
ffffffffc0204e1a:	4a260613          	addi	a2,a2,1186 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204e1e:	2c700593          	li	a1,711
ffffffffc0204e22:	00002517          	auipc	a0,0x2
ffffffffc0204e26:	2a650513          	addi	a0,a0,678 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204e2a:	bf4fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e2e:	00002697          	auipc	a3,0x2
ffffffffc0204e32:	57a68693          	addi	a3,a3,1402 # ffffffffc02073a8 <default_pmm_manager+0x9e0>
ffffffffc0204e36:	00001617          	auipc	a2,0x1
ffffffffc0204e3a:	48260613          	addi	a2,a2,1154 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204e3e:	2c600593          	li	a1,710
ffffffffc0204e42:	00002517          	auipc	a0,0x2
ffffffffc0204e46:	28650513          	addi	a0,a0,646 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204e4a:	bd4fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204e4e:	00002697          	auipc	a3,0x2
ffffffffc0204e52:	51268693          	addi	a3,a3,1298 # ffffffffc0207360 <default_pmm_manager+0x998>
ffffffffc0204e56:	00001617          	auipc	a2,0x1
ffffffffc0204e5a:	46260613          	addi	a2,a2,1122 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204e5e:	2c500593          	li	a1,709
ffffffffc0204e62:	00002517          	auipc	a0,0x2
ffffffffc0204e66:	26650513          	addi	a0,a0,614 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204e6a:	bb4fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204e6e:	00002697          	auipc	a3,0x2
ffffffffc0204e72:	4aa68693          	addi	a3,a3,1194 # ffffffffc0207318 <default_pmm_manager+0x950>
ffffffffc0204e76:	00001617          	auipc	a2,0x1
ffffffffc0204e7a:	44260613          	addi	a2,a2,1090 # ffffffffc02062b8 <commands+0x848>
ffffffffc0204e7e:	2c400593          	li	a1,708
ffffffffc0204e82:	00002517          	auipc	a0,0x2
ffffffffc0204e86:	24650513          	addi	a0,a0,582 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0204e8a:	b94fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0204e8e <do_yield>:
    current->need_resched = 1;
ffffffffc0204e8e:	000a6797          	auipc	a5,0xa6
ffffffffc0204e92:	d727b783          	ld	a5,-654(a5) # ffffffffc02aac00 <current>
ffffffffc0204e96:	4705                	li	a4,1
ffffffffc0204e98:	ef98                	sd	a4,24(a5)
}
ffffffffc0204e9a:	4501                	li	a0,0
ffffffffc0204e9c:	8082                	ret

ffffffffc0204e9e <do_wait>:
{
ffffffffc0204e9e:	1101                	addi	sp,sp,-32
ffffffffc0204ea0:	e822                	sd	s0,16(sp)
ffffffffc0204ea2:	e426                	sd	s1,8(sp)
ffffffffc0204ea4:	ec06                	sd	ra,24(sp)
ffffffffc0204ea6:	842e                	mv	s0,a1
ffffffffc0204ea8:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204eaa:	c999                	beqz	a1,ffffffffc0204ec0 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204eac:	000a6797          	auipc	a5,0xa6
ffffffffc0204eb0:	d547b783          	ld	a5,-684(a5) # ffffffffc02aac00 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204eb4:	7788                	ld	a0,40(a5)
ffffffffc0204eb6:	4685                	li	a3,1
ffffffffc0204eb8:	4611                	li	a2,4
ffffffffc0204eba:	89ffc0ef          	jal	ra,ffffffffc0201758 <user_mem_check>
ffffffffc0204ebe:	c909                	beqz	a0,ffffffffc0204ed0 <do_wait+0x32>
ffffffffc0204ec0:	85a2                	mv	a1,s0
}
ffffffffc0204ec2:	6442                	ld	s0,16(sp)
ffffffffc0204ec4:	60e2                	ld	ra,24(sp)
ffffffffc0204ec6:	8526                	mv	a0,s1
ffffffffc0204ec8:	64a2                	ld	s1,8(sp)
ffffffffc0204eca:	6105                	addi	sp,sp,32
ffffffffc0204ecc:	fb4ff06f          	j	ffffffffc0204680 <do_wait.part.0>
ffffffffc0204ed0:	60e2                	ld	ra,24(sp)
ffffffffc0204ed2:	6442                	ld	s0,16(sp)
ffffffffc0204ed4:	64a2                	ld	s1,8(sp)
ffffffffc0204ed6:	5575                	li	a0,-3
ffffffffc0204ed8:	6105                	addi	sp,sp,32
ffffffffc0204eda:	8082                	ret

ffffffffc0204edc <do_kill>:
{
ffffffffc0204edc:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ede:	6789                	lui	a5,0x2
{
ffffffffc0204ee0:	e406                	sd	ra,8(sp)
ffffffffc0204ee2:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ee4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204ee8:	17f9                	addi	a5,a5,-2
ffffffffc0204eea:	02e7e963          	bltu	a5,a4,ffffffffc0204f1c <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204eee:	842a                	mv	s0,a0
ffffffffc0204ef0:	45a9                	li	a1,10
ffffffffc0204ef2:	2501                	sext.w	a0,a0
ffffffffc0204ef4:	0bd000ef          	jal	ra,ffffffffc02057b0 <hash32>
ffffffffc0204ef8:	02051793          	slli	a5,a0,0x20
ffffffffc0204efc:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204f00:	000a2797          	auipc	a5,0xa2
ffffffffc0204f04:	c9078793          	addi	a5,a5,-880 # ffffffffc02a6b90 <hash_list>
ffffffffc0204f08:	953e                	add	a0,a0,a5
ffffffffc0204f0a:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204f0c:	a029                	j	ffffffffc0204f16 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204f0e:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204f12:	00870b63          	beq	a4,s0,ffffffffc0204f28 <do_kill+0x4c>
ffffffffc0204f16:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204f18:	fef51be3          	bne	a0,a5,ffffffffc0204f0e <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204f1c:	5475                	li	s0,-3
}
ffffffffc0204f1e:	60a2                	ld	ra,8(sp)
ffffffffc0204f20:	8522                	mv	a0,s0
ffffffffc0204f22:	6402                	ld	s0,0(sp)
ffffffffc0204f24:	0141                	addi	sp,sp,16
ffffffffc0204f26:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204f28:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204f2c:	00177693          	andi	a3,a4,1
ffffffffc0204f30:	e295                	bnez	a3,ffffffffc0204f54 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204f32:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204f34:	00176713          	ori	a4,a4,1
ffffffffc0204f38:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204f3c:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204f3e:	fe06d0e3          	bgez	a3,ffffffffc0204f1e <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204f42:	f2878513          	addi	a0,a5,-216
ffffffffc0204f46:	1c4000ef          	jal	ra,ffffffffc020510a <wakeup_proc>
}
ffffffffc0204f4a:	60a2                	ld	ra,8(sp)
ffffffffc0204f4c:	8522                	mv	a0,s0
ffffffffc0204f4e:	6402                	ld	s0,0(sp)
ffffffffc0204f50:	0141                	addi	sp,sp,16
ffffffffc0204f52:	8082                	ret
        return -E_KILLED;
ffffffffc0204f54:	545d                	li	s0,-9
ffffffffc0204f56:	b7e1                	j	ffffffffc0204f1e <do_kill+0x42>

ffffffffc0204f58 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204f58:	1101                	addi	sp,sp,-32
ffffffffc0204f5a:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204f5c:	000a6797          	auipc	a5,0xa6
ffffffffc0204f60:	c3478793          	addi	a5,a5,-972 # ffffffffc02aab90 <proc_list>
ffffffffc0204f64:	ec06                	sd	ra,24(sp)
ffffffffc0204f66:	e822                	sd	s0,16(sp)
ffffffffc0204f68:	e04a                	sd	s2,0(sp)
ffffffffc0204f6a:	000a2497          	auipc	s1,0xa2
ffffffffc0204f6e:	c2648493          	addi	s1,s1,-986 # ffffffffc02a6b90 <hash_list>
ffffffffc0204f72:	e79c                	sd	a5,8(a5)
ffffffffc0204f74:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204f76:	000a6717          	auipc	a4,0xa6
ffffffffc0204f7a:	c1a70713          	addi	a4,a4,-998 # ffffffffc02aab90 <proc_list>
ffffffffc0204f7e:	87a6                	mv	a5,s1
ffffffffc0204f80:	e79c                	sd	a5,8(a5)
ffffffffc0204f82:	e39c                	sd	a5,0(a5)
ffffffffc0204f84:	07c1                	addi	a5,a5,16
ffffffffc0204f86:	fef71de3          	bne	a4,a5,ffffffffc0204f80 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204f8a:	f93fe0ef          	jal	ra,ffffffffc0203f1c <alloc_proc>
ffffffffc0204f8e:	000a6917          	auipc	s2,0xa6
ffffffffc0204f92:	c7a90913          	addi	s2,s2,-902 # ffffffffc02aac08 <idleproc>
ffffffffc0204f96:	00a93023          	sd	a0,0(s2)
ffffffffc0204f9a:	0e050f63          	beqz	a0,ffffffffc0205098 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204f9e:	4789                	li	a5,2
ffffffffc0204fa0:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204fa2:	00003797          	auipc	a5,0x3
ffffffffc0204fa6:	05e78793          	addi	a5,a5,94 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204faa:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204fae:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204fb0:	4785                	li	a5,1
ffffffffc0204fb2:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204fb4:	4641                	li	a2,16
ffffffffc0204fb6:	4581                	li	a1,0
ffffffffc0204fb8:	8522                	mv	a0,s0
ffffffffc0204fba:	3de000ef          	jal	ra,ffffffffc0205398 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204fbe:	463d                	li	a2,15
ffffffffc0204fc0:	00002597          	auipc	a1,0x2
ffffffffc0204fc4:	49058593          	addi	a1,a1,1168 # ffffffffc0207450 <default_pmm_manager+0xa88>
ffffffffc0204fc8:	8522                	mv	a0,s0
ffffffffc0204fca:	3e0000ef          	jal	ra,ffffffffc02053aa <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204fce:	000a6717          	auipc	a4,0xa6
ffffffffc0204fd2:	c4a70713          	addi	a4,a4,-950 # ffffffffc02aac18 <nr_process>
ffffffffc0204fd6:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204fd8:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204fdc:	4601                	li	a2,0
    nr_process++;
ffffffffc0204fde:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204fe0:	4581                	li	a1,0
ffffffffc0204fe2:	00000517          	auipc	a0,0x0
ffffffffc0204fe6:	87050513          	addi	a0,a0,-1936 # ffffffffc0204852 <init_main>
    nr_process++;
ffffffffc0204fea:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204fec:	000a6797          	auipc	a5,0xa6
ffffffffc0204ff0:	c0d7ba23          	sd	a3,-1004(a5) # ffffffffc02aac00 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ff4:	cf2ff0ef          	jal	ra,ffffffffc02044e6 <kernel_thread>
ffffffffc0204ff8:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ffa:	08a05363          	blez	a0,ffffffffc0205080 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ffe:	6789                	lui	a5,0x2
ffffffffc0205000:	fff5071b          	addiw	a4,a0,-1
ffffffffc0205004:	17f9                	addi	a5,a5,-2
ffffffffc0205006:	2501                	sext.w	a0,a0
ffffffffc0205008:	02e7e363          	bltu	a5,a4,ffffffffc020502e <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020500c:	45a9                	li	a1,10
ffffffffc020500e:	7a2000ef          	jal	ra,ffffffffc02057b0 <hash32>
ffffffffc0205012:	02051793          	slli	a5,a0,0x20
ffffffffc0205016:	01c7d693          	srli	a3,a5,0x1c
ffffffffc020501a:	96a6                	add	a3,a3,s1
ffffffffc020501c:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc020501e:	a029                	j	ffffffffc0205028 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0205020:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7cd4>
ffffffffc0205024:	04870b63          	beq	a4,s0,ffffffffc020507a <proc_init+0x122>
    return listelm->next;
ffffffffc0205028:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020502a:	fef69be3          	bne	a3,a5,ffffffffc0205020 <proc_init+0xc8>
    return NULL;
ffffffffc020502e:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205030:	0b478493          	addi	s1,a5,180
ffffffffc0205034:	4641                	li	a2,16
ffffffffc0205036:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205038:	000a6417          	auipc	s0,0xa6
ffffffffc020503c:	bd840413          	addi	s0,s0,-1064 # ffffffffc02aac10 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205040:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205042:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205044:	354000ef          	jal	ra,ffffffffc0205398 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205048:	463d                	li	a2,15
ffffffffc020504a:	00002597          	auipc	a1,0x2
ffffffffc020504e:	42e58593          	addi	a1,a1,1070 # ffffffffc0207478 <default_pmm_manager+0xab0>
ffffffffc0205052:	8526                	mv	a0,s1
ffffffffc0205054:	356000ef          	jal	ra,ffffffffc02053aa <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205058:	00093783          	ld	a5,0(s2)
ffffffffc020505c:	cbb5                	beqz	a5,ffffffffc02050d0 <proc_init+0x178>
ffffffffc020505e:	43dc                	lw	a5,4(a5)
ffffffffc0205060:	eba5                	bnez	a5,ffffffffc02050d0 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205062:	601c                	ld	a5,0(s0)
ffffffffc0205064:	c7b1                	beqz	a5,ffffffffc02050b0 <proc_init+0x158>
ffffffffc0205066:	43d8                	lw	a4,4(a5)
ffffffffc0205068:	4785                	li	a5,1
ffffffffc020506a:	04f71363          	bne	a4,a5,ffffffffc02050b0 <proc_init+0x158>
}
ffffffffc020506e:	60e2                	ld	ra,24(sp)
ffffffffc0205070:	6442                	ld	s0,16(sp)
ffffffffc0205072:	64a2                	ld	s1,8(sp)
ffffffffc0205074:	6902                	ld	s2,0(sp)
ffffffffc0205076:	6105                	addi	sp,sp,32
ffffffffc0205078:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020507a:	f2878793          	addi	a5,a5,-216
ffffffffc020507e:	bf4d                	j	ffffffffc0205030 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0205080:	00002617          	auipc	a2,0x2
ffffffffc0205084:	3d860613          	addi	a2,a2,984 # ffffffffc0207458 <default_pmm_manager+0xa90>
ffffffffc0205088:	3f500593          	li	a1,1013
ffffffffc020508c:	00002517          	auipc	a0,0x2
ffffffffc0205090:	03c50513          	addi	a0,a0,60 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc0205094:	98afb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205098:	00002617          	auipc	a2,0x2
ffffffffc020509c:	3a060613          	addi	a2,a2,928 # ffffffffc0207438 <default_pmm_manager+0xa70>
ffffffffc02050a0:	3e600593          	li	a1,998
ffffffffc02050a4:	00002517          	auipc	a0,0x2
ffffffffc02050a8:	02450513          	addi	a0,a0,36 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc02050ac:	972fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02050b0:	00002697          	auipc	a3,0x2
ffffffffc02050b4:	3f868693          	addi	a3,a3,1016 # ffffffffc02074a8 <default_pmm_manager+0xae0>
ffffffffc02050b8:	00001617          	auipc	a2,0x1
ffffffffc02050bc:	20060613          	addi	a2,a2,512 # ffffffffc02062b8 <commands+0x848>
ffffffffc02050c0:	3fc00593          	li	a1,1020
ffffffffc02050c4:	00002517          	auipc	a0,0x2
ffffffffc02050c8:	00450513          	addi	a0,a0,4 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc02050cc:	952fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02050d0:	00002697          	auipc	a3,0x2
ffffffffc02050d4:	3b068693          	addi	a3,a3,944 # ffffffffc0207480 <default_pmm_manager+0xab8>
ffffffffc02050d8:	00001617          	auipc	a2,0x1
ffffffffc02050dc:	1e060613          	addi	a2,a2,480 # ffffffffc02062b8 <commands+0x848>
ffffffffc02050e0:	3fb00593          	li	a1,1019
ffffffffc02050e4:	00002517          	auipc	a0,0x2
ffffffffc02050e8:	fe450513          	addi	a0,a0,-28 # ffffffffc02070c8 <default_pmm_manager+0x700>
ffffffffc02050ec:	932fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02050f0 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02050f0:	1141                	addi	sp,sp,-16
ffffffffc02050f2:	e022                	sd	s0,0(sp)
ffffffffc02050f4:	e406                	sd	ra,8(sp)
ffffffffc02050f6:	000a6417          	auipc	s0,0xa6
ffffffffc02050fa:	b0a40413          	addi	s0,s0,-1270 # ffffffffc02aac00 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02050fe:	6018                	ld	a4,0(s0)
ffffffffc0205100:	6f1c                	ld	a5,24(a4)
ffffffffc0205102:	dffd                	beqz	a5,ffffffffc0205100 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0205104:	086000ef          	jal	ra,ffffffffc020518a <schedule>
ffffffffc0205108:	bfdd                	j	ffffffffc02050fe <cpu_idle+0xe>

ffffffffc020510a <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020510a:	4118                	lw	a4,0(a0)
{
ffffffffc020510c:	1101                	addi	sp,sp,-32
ffffffffc020510e:	ec06                	sd	ra,24(sp)
ffffffffc0205110:	e822                	sd	s0,16(sp)
ffffffffc0205112:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205114:	478d                	li	a5,3
ffffffffc0205116:	04f70b63          	beq	a4,a5,ffffffffc020516c <wakeup_proc+0x62>
ffffffffc020511a:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020511c:	100027f3          	csrr	a5,sstatus
ffffffffc0205120:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205122:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205124:	ef9d                	bnez	a5,ffffffffc0205162 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205126:	4789                	li	a5,2
ffffffffc0205128:	02f70163          	beq	a4,a5,ffffffffc020514a <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc020512c:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc020512e:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205132:	e491                	bnez	s1,ffffffffc020513e <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205134:	60e2                	ld	ra,24(sp)
ffffffffc0205136:	6442                	ld	s0,16(sp)
ffffffffc0205138:	64a2                	ld	s1,8(sp)
ffffffffc020513a:	6105                	addi	sp,sp,32
ffffffffc020513c:	8082                	ret
ffffffffc020513e:	6442                	ld	s0,16(sp)
ffffffffc0205140:	60e2                	ld	ra,24(sp)
ffffffffc0205142:	64a2                	ld	s1,8(sp)
ffffffffc0205144:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205146:	86ffb06f          	j	ffffffffc02009b4 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc020514a:	00002617          	auipc	a2,0x2
ffffffffc020514e:	3be60613          	addi	a2,a2,958 # ffffffffc0207508 <default_pmm_manager+0xb40>
ffffffffc0205152:	45d1                	li	a1,20
ffffffffc0205154:	00002517          	auipc	a0,0x2
ffffffffc0205158:	39c50513          	addi	a0,a0,924 # ffffffffc02074f0 <default_pmm_manager+0xb28>
ffffffffc020515c:	92afb0ef          	jal	ra,ffffffffc0200286 <__warn>
ffffffffc0205160:	bfc9                	j	ffffffffc0205132 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205162:	859fb0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205166:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205168:	4485                	li	s1,1
ffffffffc020516a:	bf75                	j	ffffffffc0205126 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020516c:	00002697          	auipc	a3,0x2
ffffffffc0205170:	36468693          	addi	a3,a3,868 # ffffffffc02074d0 <default_pmm_manager+0xb08>
ffffffffc0205174:	00001617          	auipc	a2,0x1
ffffffffc0205178:	14460613          	addi	a2,a2,324 # ffffffffc02062b8 <commands+0x848>
ffffffffc020517c:	45a5                	li	a1,9
ffffffffc020517e:	00002517          	auipc	a0,0x2
ffffffffc0205182:	37250513          	addi	a0,a0,882 # ffffffffc02074f0 <default_pmm_manager+0xb28>
ffffffffc0205186:	898fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020518a <schedule>:

void schedule(void)
{
ffffffffc020518a:	1141                	addi	sp,sp,-16
ffffffffc020518c:	e406                	sd	ra,8(sp)
ffffffffc020518e:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205190:	100027f3          	csrr	a5,sstatus
ffffffffc0205194:	8b89                	andi	a5,a5,2
ffffffffc0205196:	4401                	li	s0,0
ffffffffc0205198:	efbd                	bnez	a5,ffffffffc0205216 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020519a:	000a6897          	auipc	a7,0xa6
ffffffffc020519e:	a668b883          	ld	a7,-1434(a7) # ffffffffc02aac00 <current>
ffffffffc02051a2:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02051a6:	000a6517          	auipc	a0,0xa6
ffffffffc02051aa:	a6253503          	ld	a0,-1438(a0) # ffffffffc02aac08 <idleproc>
ffffffffc02051ae:	04a88e63          	beq	a7,a0,ffffffffc020520a <schedule+0x80>
ffffffffc02051b2:	0c888693          	addi	a3,a7,200
ffffffffc02051b6:	000a6617          	auipc	a2,0xa6
ffffffffc02051ba:	9da60613          	addi	a2,a2,-1574 # ffffffffc02aab90 <proc_list>
        le = last;
ffffffffc02051be:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02051c0:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02051c2:	4809                	li	a6,2
ffffffffc02051c4:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02051c6:	00c78863          	beq	a5,a2,ffffffffc02051d6 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc02051ca:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02051ce:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02051d2:	03070163          	beq	a4,a6,ffffffffc02051f4 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02051d6:	fef697e3          	bne	a3,a5,ffffffffc02051c4 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02051da:	ed89                	bnez	a1,ffffffffc02051f4 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02051dc:	451c                	lw	a5,8(a0)
ffffffffc02051de:	2785                	addiw	a5,a5,1
ffffffffc02051e0:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02051e2:	00a88463          	beq	a7,a0,ffffffffc02051ea <schedule+0x60>
        {
            proc_run(next);
ffffffffc02051e6:	ebbfe0ef          	jal	ra,ffffffffc02040a0 <proc_run>
    if (flag)
ffffffffc02051ea:	e819                	bnez	s0,ffffffffc0205200 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02051ec:	60a2                	ld	ra,8(sp)
ffffffffc02051ee:	6402                	ld	s0,0(sp)
ffffffffc02051f0:	0141                	addi	sp,sp,16
ffffffffc02051f2:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02051f4:	4198                	lw	a4,0(a1)
ffffffffc02051f6:	4789                	li	a5,2
ffffffffc02051f8:	fef712e3          	bne	a4,a5,ffffffffc02051dc <schedule+0x52>
ffffffffc02051fc:	852e                	mv	a0,a1
ffffffffc02051fe:	bff9                	j	ffffffffc02051dc <schedule+0x52>
}
ffffffffc0205200:	6402                	ld	s0,0(sp)
ffffffffc0205202:	60a2                	ld	ra,8(sp)
ffffffffc0205204:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205206:	faefb06f          	j	ffffffffc02009b4 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020520a:	000a6617          	auipc	a2,0xa6
ffffffffc020520e:	98660613          	addi	a2,a2,-1658 # ffffffffc02aab90 <proc_list>
ffffffffc0205212:	86b2                	mv	a3,a2
ffffffffc0205214:	b76d                	j	ffffffffc02051be <schedule+0x34>
        intr_disable();
ffffffffc0205216:	fa4fb0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc020521a:	4405                	li	s0,1
ffffffffc020521c:	bfbd                	j	ffffffffc020519a <schedule+0x10>

ffffffffc020521e <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020521e:	000a6797          	auipc	a5,0xa6
ffffffffc0205222:	9e27b783          	ld	a5,-1566(a5) # ffffffffc02aac00 <current>
}
ffffffffc0205226:	43c8                	lw	a0,4(a5)
ffffffffc0205228:	8082                	ret

ffffffffc020522a <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc020522a:	4501                	li	a0,0
ffffffffc020522c:	8082                	ret

ffffffffc020522e <sys_putc>:
    cputchar(c);
ffffffffc020522e:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205230:	1141                	addi	sp,sp,-16
ffffffffc0205232:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205234:	ee3fa0ef          	jal	ra,ffffffffc0200116 <cputchar>
}
ffffffffc0205238:	60a2                	ld	ra,8(sp)
ffffffffc020523a:	4501                	li	a0,0
ffffffffc020523c:	0141                	addi	sp,sp,16
ffffffffc020523e:	8082                	ret

ffffffffc0205240 <sys_kill>:
    return do_kill(pid);
ffffffffc0205240:	4108                	lw	a0,0(a0)
ffffffffc0205242:	c9bff06f          	j	ffffffffc0204edc <do_kill>

ffffffffc0205246 <sys_yield>:
    return do_yield();
ffffffffc0205246:	c49ff06f          	j	ffffffffc0204e8e <do_yield>

ffffffffc020524a <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020524a:	6d14                	ld	a3,24(a0)
ffffffffc020524c:	6910                	ld	a2,16(a0)
ffffffffc020524e:	650c                	ld	a1,8(a0)
ffffffffc0205250:	6108                	ld	a0,0(a0)
ffffffffc0205252:	f24ff06f          	j	ffffffffc0204976 <do_execve>

ffffffffc0205256 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205256:	650c                	ld	a1,8(a0)
ffffffffc0205258:	4108                	lw	a0,0(a0)
ffffffffc020525a:	c45ff06f          	j	ffffffffc0204e9e <do_wait>

ffffffffc020525e <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020525e:	000a6797          	auipc	a5,0xa6
ffffffffc0205262:	9a27b783          	ld	a5,-1630(a5) # ffffffffc02aac00 <current>
ffffffffc0205266:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205268:	4501                	li	a0,0
ffffffffc020526a:	6a0c                	ld	a1,16(a2)
ffffffffc020526c:	eabfe06f          	j	ffffffffc0204116 <do_fork>

ffffffffc0205270 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205270:	4108                	lw	a0,0(a0)
ffffffffc0205272:	ac4ff06f          	j	ffffffffc0204536 <do_exit>

ffffffffc0205276 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205276:	715d                	addi	sp,sp,-80
ffffffffc0205278:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020527a:	000a6497          	auipc	s1,0xa6
ffffffffc020527e:	98648493          	addi	s1,s1,-1658 # ffffffffc02aac00 <current>
ffffffffc0205282:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205284:	e0a2                	sd	s0,64(sp)
ffffffffc0205286:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205288:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020528a:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020528c:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc020528e:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205292:	0327ee63          	bltu	a5,s2,ffffffffc02052ce <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc0205296:	00391713          	slli	a4,s2,0x3
ffffffffc020529a:	00002797          	auipc	a5,0x2
ffffffffc020529e:	2d678793          	addi	a5,a5,726 # ffffffffc0207570 <syscalls>
ffffffffc02052a2:	97ba                	add	a5,a5,a4
ffffffffc02052a4:	639c                	ld	a5,0(a5)
ffffffffc02052a6:	c785                	beqz	a5,ffffffffc02052ce <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02052a8:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02052aa:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02052ac:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02052ae:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02052b0:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02052b2:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02052b4:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02052b6:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02052b8:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02052ba:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02052bc:	0028                	addi	a0,sp,8
ffffffffc02052be:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02052c0:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02052c2:	e828                	sd	a0,80(s0)
}
ffffffffc02052c4:	6406                	ld	s0,64(sp)
ffffffffc02052c6:	74e2                	ld	s1,56(sp)
ffffffffc02052c8:	7942                	ld	s2,48(sp)
ffffffffc02052ca:	6161                	addi	sp,sp,80
ffffffffc02052cc:	8082                	ret
    print_trapframe(tf);
ffffffffc02052ce:	8522                	mv	a0,s0
ffffffffc02052d0:	8d9fb0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02052d4:	609c                	ld	a5,0(s1)
ffffffffc02052d6:	86ca                	mv	a3,s2
ffffffffc02052d8:	00002617          	auipc	a2,0x2
ffffffffc02052dc:	25060613          	addi	a2,a2,592 # ffffffffc0207528 <default_pmm_manager+0xb60>
ffffffffc02052e0:	43d8                	lw	a4,4(a5)
ffffffffc02052e2:	06200593          	li	a1,98
ffffffffc02052e6:	0b478793          	addi	a5,a5,180
ffffffffc02052ea:	00002517          	auipc	a0,0x2
ffffffffc02052ee:	26e50513          	addi	a0,a0,622 # ffffffffc0207558 <default_pmm_manager+0xb90>
ffffffffc02052f2:	f2dfa0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02052f6 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02052f6:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02052fa:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02052fc:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02052fe:	cb81                	beqz	a5,ffffffffc020530e <strlen+0x18>
        cnt ++;
ffffffffc0205300:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205302:	00a707b3          	add	a5,a4,a0
ffffffffc0205306:	0007c783          	lbu	a5,0(a5)
ffffffffc020530a:	fbfd                	bnez	a5,ffffffffc0205300 <strlen+0xa>
ffffffffc020530c:	8082                	ret
    }
    return cnt;
}
ffffffffc020530e:	8082                	ret

ffffffffc0205310 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205310:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205312:	e589                	bnez	a1,ffffffffc020531c <strnlen+0xc>
ffffffffc0205314:	a811                	j	ffffffffc0205328 <strnlen+0x18>
        cnt ++;
ffffffffc0205316:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205318:	00f58863          	beq	a1,a5,ffffffffc0205328 <strnlen+0x18>
ffffffffc020531c:	00f50733          	add	a4,a0,a5
ffffffffc0205320:	00074703          	lbu	a4,0(a4)
ffffffffc0205324:	fb6d                	bnez	a4,ffffffffc0205316 <strnlen+0x6>
ffffffffc0205326:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205328:	852e                	mv	a0,a1
ffffffffc020532a:	8082                	ret

ffffffffc020532c <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020532c:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020532e:	0005c703          	lbu	a4,0(a1)
ffffffffc0205332:	0785                	addi	a5,a5,1
ffffffffc0205334:	0585                	addi	a1,a1,1
ffffffffc0205336:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020533a:	fb75                	bnez	a4,ffffffffc020532e <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020533c:	8082                	ret

ffffffffc020533e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020533e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205342:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205346:	cb89                	beqz	a5,ffffffffc0205358 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205348:	0505                	addi	a0,a0,1
ffffffffc020534a:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020534c:	fee789e3          	beq	a5,a4,ffffffffc020533e <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205350:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205354:	9d19                	subw	a0,a0,a4
ffffffffc0205356:	8082                	ret
ffffffffc0205358:	4501                	li	a0,0
ffffffffc020535a:	bfed                	j	ffffffffc0205354 <strcmp+0x16>

ffffffffc020535c <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020535c:	c20d                	beqz	a2,ffffffffc020537e <strncmp+0x22>
ffffffffc020535e:	962e                	add	a2,a2,a1
ffffffffc0205360:	a031                	j	ffffffffc020536c <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205362:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205364:	00e79a63          	bne	a5,a4,ffffffffc0205378 <strncmp+0x1c>
ffffffffc0205368:	00b60b63          	beq	a2,a1,ffffffffc020537e <strncmp+0x22>
ffffffffc020536c:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205370:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205372:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0205376:	f7f5                	bnez	a5,ffffffffc0205362 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205378:	40e7853b          	subw	a0,a5,a4
}
ffffffffc020537c:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020537e:	4501                	li	a0,0
ffffffffc0205380:	8082                	ret

ffffffffc0205382 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205382:	00054783          	lbu	a5,0(a0)
ffffffffc0205386:	c799                	beqz	a5,ffffffffc0205394 <strchr+0x12>
        if (*s == c) {
ffffffffc0205388:	00f58763          	beq	a1,a5,ffffffffc0205396 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020538c:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0205390:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205392:	fbfd                	bnez	a5,ffffffffc0205388 <strchr+0x6>
    }
    return NULL;
ffffffffc0205394:	4501                	li	a0,0
}
ffffffffc0205396:	8082                	ret

ffffffffc0205398 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0205398:	ca01                	beqz	a2,ffffffffc02053a8 <memset+0x10>
ffffffffc020539a:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020539c:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020539e:	0785                	addi	a5,a5,1
ffffffffc02053a0:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02053a4:	fec79de3          	bne	a5,a2,ffffffffc020539e <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02053a8:	8082                	ret

ffffffffc02053aa <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02053aa:	ca19                	beqz	a2,ffffffffc02053c0 <memcpy+0x16>
ffffffffc02053ac:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02053ae:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02053b0:	0005c703          	lbu	a4,0(a1)
ffffffffc02053b4:	0585                	addi	a1,a1,1
ffffffffc02053b6:	0785                	addi	a5,a5,1
ffffffffc02053b8:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02053bc:	fec59ae3          	bne	a1,a2,ffffffffc02053b0 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02053c0:	8082                	ret

ffffffffc02053c2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02053c2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053c6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02053c8:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053cc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02053ce:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02053d2:	f022                	sd	s0,32(sp)
ffffffffc02053d4:	ec26                	sd	s1,24(sp)
ffffffffc02053d6:	e84a                	sd	s2,16(sp)
ffffffffc02053d8:	f406                	sd	ra,40(sp)
ffffffffc02053da:	e44e                	sd	s3,8(sp)
ffffffffc02053dc:	84aa                	mv	s1,a0
ffffffffc02053de:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02053e0:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02053e4:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02053e6:	03067e63          	bgeu	a2,a6,ffffffffc0205422 <printnum+0x60>
ffffffffc02053ea:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02053ec:	00805763          	blez	s0,ffffffffc02053fa <printnum+0x38>
ffffffffc02053f0:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02053f2:	85ca                	mv	a1,s2
ffffffffc02053f4:	854e                	mv	a0,s3
ffffffffc02053f6:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02053f8:	fc65                	bnez	s0,ffffffffc02053f0 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02053fa:	1a02                	slli	s4,s4,0x20
ffffffffc02053fc:	00002797          	auipc	a5,0x2
ffffffffc0205400:	27478793          	addi	a5,a5,628 # ffffffffc0207670 <syscalls+0x100>
ffffffffc0205404:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205408:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020540a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020540c:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205410:	70a2                	ld	ra,40(sp)
ffffffffc0205412:	69a2                	ld	s3,8(sp)
ffffffffc0205414:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205416:	85ca                	mv	a1,s2
ffffffffc0205418:	87a6                	mv	a5,s1
}
ffffffffc020541a:	6942                	ld	s2,16(sp)
ffffffffc020541c:	64e2                	ld	s1,24(sp)
ffffffffc020541e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205420:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205422:	03065633          	divu	a2,a2,a6
ffffffffc0205426:	8722                	mv	a4,s0
ffffffffc0205428:	f9bff0ef          	jal	ra,ffffffffc02053c2 <printnum>
ffffffffc020542c:	b7f9                	j	ffffffffc02053fa <printnum+0x38>

ffffffffc020542e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020542e:	7119                	addi	sp,sp,-128
ffffffffc0205430:	f4a6                	sd	s1,104(sp)
ffffffffc0205432:	f0ca                	sd	s2,96(sp)
ffffffffc0205434:	ecce                	sd	s3,88(sp)
ffffffffc0205436:	e8d2                	sd	s4,80(sp)
ffffffffc0205438:	e4d6                	sd	s5,72(sp)
ffffffffc020543a:	e0da                	sd	s6,64(sp)
ffffffffc020543c:	fc5e                	sd	s7,56(sp)
ffffffffc020543e:	f06a                	sd	s10,32(sp)
ffffffffc0205440:	fc86                	sd	ra,120(sp)
ffffffffc0205442:	f8a2                	sd	s0,112(sp)
ffffffffc0205444:	f862                	sd	s8,48(sp)
ffffffffc0205446:	f466                	sd	s9,40(sp)
ffffffffc0205448:	ec6e                	sd	s11,24(sp)
ffffffffc020544a:	892a                	mv	s2,a0
ffffffffc020544c:	84ae                	mv	s1,a1
ffffffffc020544e:	8d32                	mv	s10,a2
ffffffffc0205450:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205452:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0205456:	5b7d                	li	s6,-1
ffffffffc0205458:	00002a97          	auipc	s5,0x2
ffffffffc020545c:	244a8a93          	addi	s5,s5,580 # ffffffffc020769c <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205460:	00002b97          	auipc	s7,0x2
ffffffffc0205464:	458b8b93          	addi	s7,s7,1112 # ffffffffc02078b8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205468:	000d4503          	lbu	a0,0(s10)
ffffffffc020546c:	001d0413          	addi	s0,s10,1
ffffffffc0205470:	01350a63          	beq	a0,s3,ffffffffc0205484 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0205474:	c121                	beqz	a0,ffffffffc02054b4 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0205476:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205478:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020547a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020547c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205480:	ff351ae3          	bne	a0,s3,ffffffffc0205474 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205484:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205488:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020548c:	4c81                	li	s9,0
ffffffffc020548e:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205490:	5c7d                	li	s8,-1
ffffffffc0205492:	5dfd                	li	s11,-1
ffffffffc0205494:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205498:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020549a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020549e:	0ff5f593          	zext.b	a1,a1
ffffffffc02054a2:	00140d13          	addi	s10,s0,1
ffffffffc02054a6:	04b56263          	bltu	a0,a1,ffffffffc02054ea <vprintfmt+0xbc>
ffffffffc02054aa:	058a                	slli	a1,a1,0x2
ffffffffc02054ac:	95d6                	add	a1,a1,s5
ffffffffc02054ae:	4194                	lw	a3,0(a1)
ffffffffc02054b0:	96d6                	add	a3,a3,s5
ffffffffc02054b2:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02054b4:	70e6                	ld	ra,120(sp)
ffffffffc02054b6:	7446                	ld	s0,112(sp)
ffffffffc02054b8:	74a6                	ld	s1,104(sp)
ffffffffc02054ba:	7906                	ld	s2,96(sp)
ffffffffc02054bc:	69e6                	ld	s3,88(sp)
ffffffffc02054be:	6a46                	ld	s4,80(sp)
ffffffffc02054c0:	6aa6                	ld	s5,72(sp)
ffffffffc02054c2:	6b06                	ld	s6,64(sp)
ffffffffc02054c4:	7be2                	ld	s7,56(sp)
ffffffffc02054c6:	7c42                	ld	s8,48(sp)
ffffffffc02054c8:	7ca2                	ld	s9,40(sp)
ffffffffc02054ca:	7d02                	ld	s10,32(sp)
ffffffffc02054cc:	6de2                	ld	s11,24(sp)
ffffffffc02054ce:	6109                	addi	sp,sp,128
ffffffffc02054d0:	8082                	ret
            padc = '0';
ffffffffc02054d2:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02054d4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02054d8:	846a                	mv	s0,s10
ffffffffc02054da:	00140d13          	addi	s10,s0,1
ffffffffc02054de:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02054e2:	0ff5f593          	zext.b	a1,a1
ffffffffc02054e6:	fcb572e3          	bgeu	a0,a1,ffffffffc02054aa <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02054ea:	85a6                	mv	a1,s1
ffffffffc02054ec:	02500513          	li	a0,37
ffffffffc02054f0:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02054f2:	fff44783          	lbu	a5,-1(s0)
ffffffffc02054f6:	8d22                	mv	s10,s0
ffffffffc02054f8:	f73788e3          	beq	a5,s3,ffffffffc0205468 <vprintfmt+0x3a>
ffffffffc02054fc:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205500:	1d7d                	addi	s10,s10,-1
ffffffffc0205502:	ff379de3          	bne	a5,s3,ffffffffc02054fc <vprintfmt+0xce>
ffffffffc0205506:	b78d                	j	ffffffffc0205468 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205508:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020550c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205510:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205512:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205516:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020551a:	02d86463          	bltu	a6,a3,ffffffffc0205542 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc020551e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205522:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205526:	0186873b          	addw	a4,a3,s8
ffffffffc020552a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020552e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0205530:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0205534:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205536:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020553a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020553e:	fed870e3          	bgeu	a6,a3,ffffffffc020551e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0205542:	f40ddce3          	bgez	s11,ffffffffc020549a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0205546:	8de2                	mv	s11,s8
ffffffffc0205548:	5c7d                	li	s8,-1
ffffffffc020554a:	bf81                	j	ffffffffc020549a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc020554c:	fffdc693          	not	a3,s11
ffffffffc0205550:	96fd                	srai	a3,a3,0x3f
ffffffffc0205552:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205556:	00144603          	lbu	a2,1(s0)
ffffffffc020555a:	2d81                	sext.w	s11,s11
ffffffffc020555c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020555e:	bf35                	j	ffffffffc020549a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0205560:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205564:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0205568:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020556a:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020556c:	bfd9                	j	ffffffffc0205542 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020556e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205570:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205574:	01174463          	blt	a4,a7,ffffffffc020557c <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205578:	1a088e63          	beqz	a7,ffffffffc0205734 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020557c:	000a3603          	ld	a2,0(s4)
ffffffffc0205580:	46c1                	li	a3,16
ffffffffc0205582:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205584:	2781                	sext.w	a5,a5
ffffffffc0205586:	876e                	mv	a4,s11
ffffffffc0205588:	85a6                	mv	a1,s1
ffffffffc020558a:	854a                	mv	a0,s2
ffffffffc020558c:	e37ff0ef          	jal	ra,ffffffffc02053c2 <printnum>
            break;
ffffffffc0205590:	bde1                	j	ffffffffc0205468 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205592:	000a2503          	lw	a0,0(s4)
ffffffffc0205596:	85a6                	mv	a1,s1
ffffffffc0205598:	0a21                	addi	s4,s4,8
ffffffffc020559a:	9902                	jalr	s2
            break;
ffffffffc020559c:	b5f1                	j	ffffffffc0205468 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020559e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055a0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055a4:	01174463          	blt	a4,a7,ffffffffc02055ac <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02055a8:	18088163          	beqz	a7,ffffffffc020572a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02055ac:	000a3603          	ld	a2,0(s4)
ffffffffc02055b0:	46a9                	li	a3,10
ffffffffc02055b2:	8a2e                	mv	s4,a1
ffffffffc02055b4:	bfc1                	j	ffffffffc0205584 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055b6:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02055ba:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055bc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02055be:	bdf1                	j	ffffffffc020549a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02055c0:	85a6                	mv	a1,s1
ffffffffc02055c2:	02500513          	li	a0,37
ffffffffc02055c6:	9902                	jalr	s2
            break;
ffffffffc02055c8:	b545                	j	ffffffffc0205468 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055ca:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02055ce:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055d0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02055d2:	b5e1                	j	ffffffffc020549a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02055d4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02055d6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02055da:	01174463          	blt	a4,a7,ffffffffc02055e2 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02055de:	14088163          	beqz	a7,ffffffffc0205720 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02055e2:	000a3603          	ld	a2,0(s4)
ffffffffc02055e6:	46a1                	li	a3,8
ffffffffc02055e8:	8a2e                	mv	s4,a1
ffffffffc02055ea:	bf69                	j	ffffffffc0205584 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02055ec:	03000513          	li	a0,48
ffffffffc02055f0:	85a6                	mv	a1,s1
ffffffffc02055f2:	e03e                	sd	a5,0(sp)
ffffffffc02055f4:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02055f6:	85a6                	mv	a1,s1
ffffffffc02055f8:	07800513          	li	a0,120
ffffffffc02055fc:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02055fe:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205600:	6782                	ld	a5,0(sp)
ffffffffc0205602:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205604:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205608:	bfb5                	j	ffffffffc0205584 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020560a:	000a3403          	ld	s0,0(s4)
ffffffffc020560e:	008a0713          	addi	a4,s4,8
ffffffffc0205612:	e03a                	sd	a4,0(sp)
ffffffffc0205614:	14040263          	beqz	s0,ffffffffc0205758 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205618:	0fb05763          	blez	s11,ffffffffc0205706 <vprintfmt+0x2d8>
ffffffffc020561c:	02d00693          	li	a3,45
ffffffffc0205620:	0cd79163          	bne	a5,a3,ffffffffc02056e2 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205624:	00044783          	lbu	a5,0(s0)
ffffffffc0205628:	0007851b          	sext.w	a0,a5
ffffffffc020562c:	cf85                	beqz	a5,ffffffffc0205664 <vprintfmt+0x236>
ffffffffc020562e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205632:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205636:	000c4563          	bltz	s8,ffffffffc0205640 <vprintfmt+0x212>
ffffffffc020563a:	3c7d                	addiw	s8,s8,-1
ffffffffc020563c:	036c0263          	beq	s8,s6,ffffffffc0205660 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0205640:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205642:	0e0c8e63          	beqz	s9,ffffffffc020573e <vprintfmt+0x310>
ffffffffc0205646:	3781                	addiw	a5,a5,-32
ffffffffc0205648:	0ef47b63          	bgeu	s0,a5,ffffffffc020573e <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc020564c:	03f00513          	li	a0,63
ffffffffc0205650:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205652:	000a4783          	lbu	a5,0(s4)
ffffffffc0205656:	3dfd                	addiw	s11,s11,-1
ffffffffc0205658:	0a05                	addi	s4,s4,1
ffffffffc020565a:	0007851b          	sext.w	a0,a5
ffffffffc020565e:	ffe1                	bnez	a5,ffffffffc0205636 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0205660:	01b05963          	blez	s11,ffffffffc0205672 <vprintfmt+0x244>
ffffffffc0205664:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0205666:	85a6                	mv	a1,s1
ffffffffc0205668:	02000513          	li	a0,32
ffffffffc020566c:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020566e:	fe0d9be3          	bnez	s11,ffffffffc0205664 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205672:	6a02                	ld	s4,0(sp)
ffffffffc0205674:	bbd5                	j	ffffffffc0205468 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205676:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205678:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020567c:	01174463          	blt	a4,a7,ffffffffc0205684 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205680:	08088d63          	beqz	a7,ffffffffc020571a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205684:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205688:	0a044d63          	bltz	s0,ffffffffc0205742 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020568c:	8622                	mv	a2,s0
ffffffffc020568e:	8a66                	mv	s4,s9
ffffffffc0205690:	46a9                	li	a3,10
ffffffffc0205692:	bdcd                	j	ffffffffc0205584 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205694:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205698:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc020569a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020569c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02056a0:	8fb5                	xor	a5,a5,a3
ffffffffc02056a2:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02056a6:	02d74163          	blt	a4,a3,ffffffffc02056c8 <vprintfmt+0x29a>
ffffffffc02056aa:	00369793          	slli	a5,a3,0x3
ffffffffc02056ae:	97de                	add	a5,a5,s7
ffffffffc02056b0:	639c                	ld	a5,0(a5)
ffffffffc02056b2:	cb99                	beqz	a5,ffffffffc02056c8 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02056b4:	86be                	mv	a3,a5
ffffffffc02056b6:	00000617          	auipc	a2,0x0
ffffffffc02056ba:	13a60613          	addi	a2,a2,314 # ffffffffc02057f0 <etext+0x2a>
ffffffffc02056be:	85a6                	mv	a1,s1
ffffffffc02056c0:	854a                	mv	a0,s2
ffffffffc02056c2:	0ce000ef          	jal	ra,ffffffffc0205790 <printfmt>
ffffffffc02056c6:	b34d                	j	ffffffffc0205468 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02056c8:	00002617          	auipc	a2,0x2
ffffffffc02056cc:	fc860613          	addi	a2,a2,-56 # ffffffffc0207690 <syscalls+0x120>
ffffffffc02056d0:	85a6                	mv	a1,s1
ffffffffc02056d2:	854a                	mv	a0,s2
ffffffffc02056d4:	0bc000ef          	jal	ra,ffffffffc0205790 <printfmt>
ffffffffc02056d8:	bb41                	j	ffffffffc0205468 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02056da:	00002417          	auipc	s0,0x2
ffffffffc02056de:	fae40413          	addi	s0,s0,-82 # ffffffffc0207688 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02056e2:	85e2                	mv	a1,s8
ffffffffc02056e4:	8522                	mv	a0,s0
ffffffffc02056e6:	e43e                	sd	a5,8(sp)
ffffffffc02056e8:	c29ff0ef          	jal	ra,ffffffffc0205310 <strnlen>
ffffffffc02056ec:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02056f0:	01b05b63          	blez	s11,ffffffffc0205706 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02056f4:	67a2                	ld	a5,8(sp)
ffffffffc02056f6:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02056fa:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02056fc:	85a6                	mv	a1,s1
ffffffffc02056fe:	8552                	mv	a0,s4
ffffffffc0205700:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205702:	fe0d9ce3          	bnez	s11,ffffffffc02056fa <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205706:	00044783          	lbu	a5,0(s0)
ffffffffc020570a:	00140a13          	addi	s4,s0,1
ffffffffc020570e:	0007851b          	sext.w	a0,a5
ffffffffc0205712:	d3a5                	beqz	a5,ffffffffc0205672 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205714:	05e00413          	li	s0,94
ffffffffc0205718:	bf39                	j	ffffffffc0205636 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020571a:	000a2403          	lw	s0,0(s4)
ffffffffc020571e:	b7ad                	j	ffffffffc0205688 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205720:	000a6603          	lwu	a2,0(s4)
ffffffffc0205724:	46a1                	li	a3,8
ffffffffc0205726:	8a2e                	mv	s4,a1
ffffffffc0205728:	bdb1                	j	ffffffffc0205584 <vprintfmt+0x156>
ffffffffc020572a:	000a6603          	lwu	a2,0(s4)
ffffffffc020572e:	46a9                	li	a3,10
ffffffffc0205730:	8a2e                	mv	s4,a1
ffffffffc0205732:	bd89                	j	ffffffffc0205584 <vprintfmt+0x156>
ffffffffc0205734:	000a6603          	lwu	a2,0(s4)
ffffffffc0205738:	46c1                	li	a3,16
ffffffffc020573a:	8a2e                	mv	s4,a1
ffffffffc020573c:	b5a1                	j	ffffffffc0205584 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc020573e:	9902                	jalr	s2
ffffffffc0205740:	bf09                	j	ffffffffc0205652 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0205742:	85a6                	mv	a1,s1
ffffffffc0205744:	02d00513          	li	a0,45
ffffffffc0205748:	e03e                	sd	a5,0(sp)
ffffffffc020574a:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020574c:	6782                	ld	a5,0(sp)
ffffffffc020574e:	8a66                	mv	s4,s9
ffffffffc0205750:	40800633          	neg	a2,s0
ffffffffc0205754:	46a9                	li	a3,10
ffffffffc0205756:	b53d                	j	ffffffffc0205584 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0205758:	03b05163          	blez	s11,ffffffffc020577a <vprintfmt+0x34c>
ffffffffc020575c:	02d00693          	li	a3,45
ffffffffc0205760:	f6d79de3          	bne	a5,a3,ffffffffc02056da <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0205764:	00002417          	auipc	s0,0x2
ffffffffc0205768:	f2440413          	addi	s0,s0,-220 # ffffffffc0207688 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020576c:	02800793          	li	a5,40
ffffffffc0205770:	02800513          	li	a0,40
ffffffffc0205774:	00140a13          	addi	s4,s0,1
ffffffffc0205778:	bd6d                	j	ffffffffc0205632 <vprintfmt+0x204>
ffffffffc020577a:	00002a17          	auipc	s4,0x2
ffffffffc020577e:	f0fa0a13          	addi	s4,s4,-241 # ffffffffc0207689 <syscalls+0x119>
ffffffffc0205782:	02800513          	li	a0,40
ffffffffc0205786:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020578a:	05e00413          	li	s0,94
ffffffffc020578e:	b565                	j	ffffffffc0205636 <vprintfmt+0x208>

ffffffffc0205790 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205790:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205792:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205796:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205798:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020579a:	ec06                	sd	ra,24(sp)
ffffffffc020579c:	f83a                	sd	a4,48(sp)
ffffffffc020579e:	fc3e                	sd	a5,56(sp)
ffffffffc02057a0:	e0c2                	sd	a6,64(sp)
ffffffffc02057a2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02057a4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02057a6:	c89ff0ef          	jal	ra,ffffffffc020542e <vprintfmt>
}
ffffffffc02057aa:	60e2                	ld	ra,24(sp)
ffffffffc02057ac:	6161                	addi	sp,sp,80
ffffffffc02057ae:	8082                	ret

ffffffffc02057b0 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02057b0:	9e3707b7          	lui	a5,0x9e370
ffffffffc02057b4:	2785                	addiw	a5,a5,1
ffffffffc02057b6:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02057ba:	02000793          	li	a5,32
ffffffffc02057be:	9f8d                	subw	a5,a5,a1
}
ffffffffc02057c0:	00f5553b          	srlw	a0,a0,a5
ffffffffc02057c4:	8082                	ret
