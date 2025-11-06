
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

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
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49260613          	addi	a2,a2,1170 # ffffffffc020d4e4 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	1db030ef          	jal	ra,ffffffffc0203a3c <memset>
    dtb_init();
ffffffffc0200066:	452000ef          	jal	ra,ffffffffc02004b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	053000ef          	jal	ra,ffffffffc02008bc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e2258593          	addi	a1,a1,-478 # ffffffffc0203e90 <etext+0x2>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	e3a50513          	addi	a0,a0,-454 # ffffffffc0203eb0 <etext+0x22>
ffffffffc020007e:	062000ef          	jal	ra,ffffffffc02000e0 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1b8000ef          	jal	ra,ffffffffc020023a <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	54a020ef          	jal	ra,ffffffffc02025d0 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	0a5000ef          	jal	ra,ffffffffc020092e <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	0af000ef          	jal	ra,ffffffffc020093c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	689000ef          	jal	ra,ffffffffc0200f1a <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	5d4030ef          	jal	ra,ffffffffc020366a <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	7ce000ef          	jal	ra,ffffffffc0200868 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	093000ef          	jal	ra,ffffffffc0200930 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	017030ef          	jal	ra,ffffffffc02038b8 <cpu_idle>

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
ffffffffc02000ae:	011000ef          	jal	ra,ffffffffc02008be <cons_putc>
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
ffffffffc02000d4:	223030ef          	jal	ra,ffffffffc0203af6 <vprintfmt>
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
ffffffffc02000e2:	02810313          	addi	t1,sp,40 # ffffffffc0208028 <boot_page_table_sv39+0x28>
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
ffffffffc020010a:	1ed030ef          	jal	ra,ffffffffc0203af6 <vprintfmt>
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
ffffffffc0200116:	7a80006f          	j	ffffffffc02008be <cons_putc>

ffffffffc020011a <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020011a:	1141                	addi	sp,sp,-16
ffffffffc020011c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020011e:	7d4000ef          	jal	ra,ffffffffc02008f2 <cons_getc>
ffffffffc0200122:	dd75                	beqz	a0,ffffffffc020011e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200124:	60a2                	ld	ra,8(sp)
ffffffffc0200126:	0141                	addi	sp,sp,16
ffffffffc0200128:	8082                	ret

ffffffffc020012a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020012a:	715d                	addi	sp,sp,-80
ffffffffc020012c:	e486                	sd	ra,72(sp)
ffffffffc020012e:	e0a6                	sd	s1,64(sp)
ffffffffc0200130:	fc4a                	sd	s2,56(sp)
ffffffffc0200132:	f84e                	sd	s3,48(sp)
ffffffffc0200134:	f452                	sd	s4,40(sp)
ffffffffc0200136:	f056                	sd	s5,32(sp)
ffffffffc0200138:	ec5a                	sd	s6,24(sp)
ffffffffc020013a:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc020013c:	c901                	beqz	a0,ffffffffc020014c <readline+0x22>
ffffffffc020013e:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0200140:	00004517          	auipc	a0,0x4
ffffffffc0200144:	d7850513          	addi	a0,a0,-648 # ffffffffc0203eb8 <etext+0x2a>
ffffffffc0200148:	f99ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
readline(const char *prompt) {
ffffffffc020014c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020014e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200150:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200152:	4aa9                	li	s5,10
ffffffffc0200154:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0200156:	00009b97          	auipc	s7,0x9
ffffffffc020015a:	edab8b93          	addi	s7,s7,-294 # ffffffffc0209030 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020015e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0200162:	fb9ff0ef          	jal	ra,ffffffffc020011a <getchar>
        if (c < 0) {
ffffffffc0200166:	00054a63          	bltz	a0,ffffffffc020017a <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020016a:	00a95a63          	bge	s2,a0,ffffffffc020017e <readline+0x54>
ffffffffc020016e:	029a5263          	bge	s4,s1,ffffffffc0200192 <readline+0x68>
        c = getchar();
ffffffffc0200172:	fa9ff0ef          	jal	ra,ffffffffc020011a <getchar>
        if (c < 0) {
ffffffffc0200176:	fe055ae3          	bgez	a0,ffffffffc020016a <readline+0x40>
            return NULL;
ffffffffc020017a:	4501                	li	a0,0
ffffffffc020017c:	a091                	j	ffffffffc02001c0 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc020017e:	03351463          	bne	a0,s3,ffffffffc02001a6 <readline+0x7c>
ffffffffc0200182:	e8a9                	bnez	s1,ffffffffc02001d4 <readline+0xaa>
        c = getchar();
ffffffffc0200184:	f97ff0ef          	jal	ra,ffffffffc020011a <getchar>
        if (c < 0) {
ffffffffc0200188:	fe0549e3          	bltz	a0,ffffffffc020017a <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020018c:	fea959e3          	bge	s2,a0,ffffffffc020017e <readline+0x54>
ffffffffc0200190:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200192:	e42a                	sd	a0,8(sp)
ffffffffc0200194:	f83ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i ++] = c;
ffffffffc0200198:	6522                	ld	a0,8(sp)
ffffffffc020019a:	009b87b3          	add	a5,s7,s1
ffffffffc020019e:	2485                	addiw	s1,s1,1
ffffffffc02001a0:	00a78023          	sb	a0,0(a5)
ffffffffc02001a4:	bf7d                	j	ffffffffc0200162 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02001a6:	01550463          	beq	a0,s5,ffffffffc02001ae <readline+0x84>
ffffffffc02001aa:	fb651ce3          	bne	a0,s6,ffffffffc0200162 <readline+0x38>
            cputchar(c);
ffffffffc02001ae:	f69ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i] = '\0';
ffffffffc02001b2:	00009517          	auipc	a0,0x9
ffffffffc02001b6:	e7e50513          	addi	a0,a0,-386 # ffffffffc0209030 <buf>
ffffffffc02001ba:	94aa                	add	s1,s1,a0
ffffffffc02001bc:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02001c0:	60a6                	ld	ra,72(sp)
ffffffffc02001c2:	6486                	ld	s1,64(sp)
ffffffffc02001c4:	7962                	ld	s2,56(sp)
ffffffffc02001c6:	79c2                	ld	s3,48(sp)
ffffffffc02001c8:	7a22                	ld	s4,40(sp)
ffffffffc02001ca:	7a82                	ld	s5,32(sp)
ffffffffc02001cc:	6b62                	ld	s6,24(sp)
ffffffffc02001ce:	6bc2                	ld	s7,16(sp)
ffffffffc02001d0:	6161                	addi	sp,sp,80
ffffffffc02001d2:	8082                	ret
            cputchar(c);
ffffffffc02001d4:	4521                	li	a0,8
ffffffffc02001d6:	f41ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            i --;
ffffffffc02001da:	34fd                	addiw	s1,s1,-1
ffffffffc02001dc:	b759                	j	ffffffffc0200162 <readline+0x38>

ffffffffc02001de <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001de:	0000d317          	auipc	t1,0xd
ffffffffc02001e2:	28a30313          	addi	t1,t1,650 # ffffffffc020d468 <is_panic>
ffffffffc02001e6:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ea:	715d                	addi	sp,sp,-80
ffffffffc02001ec:	ec06                	sd	ra,24(sp)
ffffffffc02001ee:	e822                	sd	s0,16(sp)
ffffffffc02001f0:	f436                	sd	a3,40(sp)
ffffffffc02001f2:	f83a                	sd	a4,48(sp)
ffffffffc02001f4:	fc3e                	sd	a5,56(sp)
ffffffffc02001f6:	e0c2                	sd	a6,64(sp)
ffffffffc02001f8:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001fa:	020e1a63          	bnez	t3,ffffffffc020022e <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02001fe:	4785                	li	a5,1
ffffffffc0200200:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200204:	8432                	mv	s0,a2
ffffffffc0200206:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200208:	862e                	mv	a2,a1
ffffffffc020020a:	85aa                	mv	a1,a0
ffffffffc020020c:	00004517          	auipc	a0,0x4
ffffffffc0200210:	cb450513          	addi	a0,a0,-844 # ffffffffc0203ec0 <etext+0x32>
    va_start(ap, fmt);
ffffffffc0200214:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200216:	ecbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020021a:	65a2                	ld	a1,8(sp)
ffffffffc020021c:	8522                	mv	a0,s0
ffffffffc020021e:	ea3ff0ef          	jal	ra,ffffffffc02000c0 <vcprintf>
    cprintf("\n");
ffffffffc0200222:	00005517          	auipc	a0,0x5
ffffffffc0200226:	1f650513          	addi	a0,a0,502 # ffffffffc0205418 <default_pmm_manager+0x440>
ffffffffc020022a:	eb7ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020022e:	708000ef          	jal	ra,ffffffffc0200936 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200232:	4501                	li	a0,0
ffffffffc0200234:	130000ef          	jal	ra,ffffffffc0200364 <kmonitor>
    while (1) {
ffffffffc0200238:	bfed                	j	ffffffffc0200232 <__panic+0x54>

ffffffffc020023a <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020023a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020023c:	00004517          	auipc	a0,0x4
ffffffffc0200240:	ca450513          	addi	a0,a0,-860 # ffffffffc0203ee0 <etext+0x52>
{
ffffffffc0200244:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200246:	e9bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020024a:	00000597          	auipc	a1,0x0
ffffffffc020024e:	e0058593          	addi	a1,a1,-512 # ffffffffc020004a <kern_init>
ffffffffc0200252:	00004517          	auipc	a0,0x4
ffffffffc0200256:	cae50513          	addi	a0,a0,-850 # ffffffffc0203f00 <etext+0x72>
ffffffffc020025a:	e87ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020025e:	00004597          	auipc	a1,0x4
ffffffffc0200262:	c3058593          	addi	a1,a1,-976 # ffffffffc0203e8e <etext>
ffffffffc0200266:	00004517          	auipc	a0,0x4
ffffffffc020026a:	cba50513          	addi	a0,a0,-838 # ffffffffc0203f20 <etext+0x92>
ffffffffc020026e:	e73ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200272:	00009597          	auipc	a1,0x9
ffffffffc0200276:	dbe58593          	addi	a1,a1,-578 # ffffffffc0209030 <buf>
ffffffffc020027a:	00004517          	auipc	a0,0x4
ffffffffc020027e:	cc650513          	addi	a0,a0,-826 # ffffffffc0203f40 <etext+0xb2>
ffffffffc0200282:	e5fff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200286:	0000d597          	auipc	a1,0xd
ffffffffc020028a:	25e58593          	addi	a1,a1,606 # ffffffffc020d4e4 <end>
ffffffffc020028e:	00004517          	auipc	a0,0x4
ffffffffc0200292:	cd250513          	addi	a0,a0,-814 # ffffffffc0203f60 <etext+0xd2>
ffffffffc0200296:	e4bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020029a:	0000d597          	auipc	a1,0xd
ffffffffc020029e:	64958593          	addi	a1,a1,1609 # ffffffffc020d8e3 <end+0x3ff>
ffffffffc02002a2:	00000797          	auipc	a5,0x0
ffffffffc02002a6:	da878793          	addi	a5,a5,-600 # ffffffffc020004a <kern_init>
ffffffffc02002aa:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002ae:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02002b2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002b8:	95be                	add	a1,a1,a5
ffffffffc02002ba:	85a9                	srai	a1,a1,0xa
ffffffffc02002bc:	00004517          	auipc	a0,0x4
ffffffffc02002c0:	cc450513          	addi	a0,a0,-828 # ffffffffc0203f80 <etext+0xf2>
}
ffffffffc02002c4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002c6:	bd29                	j	ffffffffc02000e0 <cprintf>

ffffffffc02002c8 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002c8:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ca:	00004617          	auipc	a2,0x4
ffffffffc02002ce:	ce660613          	addi	a2,a2,-794 # ffffffffc0203fb0 <etext+0x122>
ffffffffc02002d2:	04900593          	li	a1,73
ffffffffc02002d6:	00004517          	auipc	a0,0x4
ffffffffc02002da:	cf250513          	addi	a0,a0,-782 # ffffffffc0203fc8 <etext+0x13a>
{
ffffffffc02002de:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002e0:	effff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02002e4 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e4:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	00004617          	auipc	a2,0x4
ffffffffc02002ea:	cfa60613          	addi	a2,a2,-774 # ffffffffc0203fe0 <etext+0x152>
ffffffffc02002ee:	00004597          	auipc	a1,0x4
ffffffffc02002f2:	d1258593          	addi	a1,a1,-750 # ffffffffc0204000 <etext+0x172>
ffffffffc02002f6:	00004517          	auipc	a0,0x4
ffffffffc02002fa:	d1250513          	addi	a0,a0,-750 # ffffffffc0204008 <etext+0x17a>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002fe:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200300:	de1ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0200304:	00004617          	auipc	a2,0x4
ffffffffc0200308:	d1460613          	addi	a2,a2,-748 # ffffffffc0204018 <etext+0x18a>
ffffffffc020030c:	00004597          	auipc	a1,0x4
ffffffffc0200310:	d3458593          	addi	a1,a1,-716 # ffffffffc0204040 <etext+0x1b2>
ffffffffc0200314:	00004517          	auipc	a0,0x4
ffffffffc0200318:	cf450513          	addi	a0,a0,-780 # ffffffffc0204008 <etext+0x17a>
ffffffffc020031c:	dc5ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0200320:	00004617          	auipc	a2,0x4
ffffffffc0200324:	d3060613          	addi	a2,a2,-720 # ffffffffc0204050 <etext+0x1c2>
ffffffffc0200328:	00004597          	auipc	a1,0x4
ffffffffc020032c:	d4858593          	addi	a1,a1,-696 # ffffffffc0204070 <etext+0x1e2>
ffffffffc0200330:	00004517          	auipc	a0,0x4
ffffffffc0200334:	cd850513          	addi	a0,a0,-808 # ffffffffc0204008 <etext+0x17a>
ffffffffc0200338:	da9ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    return 0;
}
ffffffffc020033c:	60a2                	ld	ra,8(sp)
ffffffffc020033e:	4501                	li	a0,0
ffffffffc0200340:	0141                	addi	sp,sp,16
ffffffffc0200342:	8082                	ret

ffffffffc0200344 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200344:	1141                	addi	sp,sp,-16
ffffffffc0200346:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200348:	ef3ff0ef          	jal	ra,ffffffffc020023a <print_kerninfo>
    return 0;
}
ffffffffc020034c:	60a2                	ld	ra,8(sp)
ffffffffc020034e:	4501                	li	a0,0
ffffffffc0200350:	0141                	addi	sp,sp,16
ffffffffc0200352:	8082                	ret

ffffffffc0200354 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200354:	1141                	addi	sp,sp,-16
ffffffffc0200356:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200358:	f71ff0ef          	jal	ra,ffffffffc02002c8 <print_stackframe>
    return 0;
}
ffffffffc020035c:	60a2                	ld	ra,8(sp)
ffffffffc020035e:	4501                	li	a0,0
ffffffffc0200360:	0141                	addi	sp,sp,16
ffffffffc0200362:	8082                	ret

ffffffffc0200364 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200364:	7115                	addi	sp,sp,-224
ffffffffc0200366:	ed5e                	sd	s7,152(sp)
ffffffffc0200368:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	00004517          	auipc	a0,0x4
ffffffffc020036e:	d1650513          	addi	a0,a0,-746 # ffffffffc0204080 <etext+0x1f2>
kmonitor(struct trapframe *tf) {
ffffffffc0200372:	ed86                	sd	ra,216(sp)
ffffffffc0200374:	e9a2                	sd	s0,208(sp)
ffffffffc0200376:	e5a6                	sd	s1,200(sp)
ffffffffc0200378:	e1ca                	sd	s2,192(sp)
ffffffffc020037a:	fd4e                	sd	s3,184(sp)
ffffffffc020037c:	f952                	sd	s4,176(sp)
ffffffffc020037e:	f556                	sd	s5,168(sp)
ffffffffc0200380:	f15a                	sd	s6,160(sp)
ffffffffc0200382:	e962                	sd	s8,144(sp)
ffffffffc0200384:	e566                	sd	s9,136(sp)
ffffffffc0200386:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200388:	d59ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020038c:	00004517          	auipc	a0,0x4
ffffffffc0200390:	d1c50513          	addi	a0,a0,-740 # ffffffffc02040a8 <etext+0x21a>
ffffffffc0200394:	d4dff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    if (tf != NULL) {
ffffffffc0200398:	000b8563          	beqz	s7,ffffffffc02003a2 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020039c:	855e                	mv	a0,s7
ffffffffc020039e:	786000ef          	jal	ra,ffffffffc0200b24 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02003a2:	4501                	li	a0,0
ffffffffc02003a4:	4581                	li	a1,0
ffffffffc02003a6:	4601                	li	a2,0
ffffffffc02003a8:	48a1                	li	a7,8
ffffffffc02003aa:	00000073          	ecall
ffffffffc02003ae:	00004c17          	auipc	s8,0x4
ffffffffc02003b2:	d6ac0c13          	addi	s8,s8,-662 # ffffffffc0204118 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003b6:	00004917          	auipc	s2,0x4
ffffffffc02003ba:	d1a90913          	addi	s2,s2,-742 # ffffffffc02040d0 <etext+0x242>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003be:	00004497          	auipc	s1,0x4
ffffffffc02003c2:	d1a48493          	addi	s1,s1,-742 # ffffffffc02040d8 <etext+0x24a>
        if (argc == MAXARGS - 1) {
ffffffffc02003c6:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003c8:	00004b17          	auipc	s6,0x4
ffffffffc02003cc:	d18b0b13          	addi	s6,s6,-744 # ffffffffc02040e0 <etext+0x252>
        argv[argc ++] = buf;
ffffffffc02003d0:	00004a17          	auipc	s4,0x4
ffffffffc02003d4:	c30a0a13          	addi	s4,s4,-976 # ffffffffc0204000 <etext+0x172>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d8:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003da:	854a                	mv	a0,s2
ffffffffc02003dc:	d4fff0ef          	jal	ra,ffffffffc020012a <readline>
ffffffffc02003e0:	842a                	mv	s0,a0
ffffffffc02003e2:	dd65                	beqz	a0,ffffffffc02003da <kmonitor+0x76>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003e4:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003e8:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ea:	e1bd                	bnez	a1,ffffffffc0200450 <kmonitor+0xec>
    if (argc == 0) {
ffffffffc02003ec:	fe0c87e3          	beqz	s9,ffffffffc02003da <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003f0:	6582                	ld	a1,0(sp)
ffffffffc02003f2:	00004d17          	auipc	s10,0x4
ffffffffc02003f6:	d26d0d13          	addi	s10,s10,-730 # ffffffffc0204118 <commands>
        argv[argc ++] = buf;
ffffffffc02003fa:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003fc:	4401                	li	s0,0
ffffffffc02003fe:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200400:	5e2030ef          	jal	ra,ffffffffc02039e2 <strcmp>
ffffffffc0200404:	c919                	beqz	a0,ffffffffc020041a <kmonitor+0xb6>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200406:	2405                	addiw	s0,s0,1
ffffffffc0200408:	0b540063          	beq	s0,s5,ffffffffc02004a8 <kmonitor+0x144>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020040c:	000d3503          	ld	a0,0(s10)
ffffffffc0200410:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200412:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200414:	5ce030ef          	jal	ra,ffffffffc02039e2 <strcmp>
ffffffffc0200418:	f57d                	bnez	a0,ffffffffc0200406 <kmonitor+0xa2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020041a:	00141793          	slli	a5,s0,0x1
ffffffffc020041e:	97a2                	add	a5,a5,s0
ffffffffc0200420:	078e                	slli	a5,a5,0x3
ffffffffc0200422:	97e2                	add	a5,a5,s8
ffffffffc0200424:	6b9c                	ld	a5,16(a5)
ffffffffc0200426:	865e                	mv	a2,s7
ffffffffc0200428:	002c                	addi	a1,sp,8
ffffffffc020042a:	fffc851b          	addiw	a0,s9,-1
ffffffffc020042e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200430:	fa0555e3          	bgez	a0,ffffffffc02003da <kmonitor+0x76>
}
ffffffffc0200434:	60ee                	ld	ra,216(sp)
ffffffffc0200436:	644e                	ld	s0,208(sp)
ffffffffc0200438:	64ae                	ld	s1,200(sp)
ffffffffc020043a:	690e                	ld	s2,192(sp)
ffffffffc020043c:	79ea                	ld	s3,184(sp)
ffffffffc020043e:	7a4a                	ld	s4,176(sp)
ffffffffc0200440:	7aaa                	ld	s5,168(sp)
ffffffffc0200442:	7b0a                	ld	s6,160(sp)
ffffffffc0200444:	6bea                	ld	s7,152(sp)
ffffffffc0200446:	6c4a                	ld	s8,144(sp)
ffffffffc0200448:	6caa                	ld	s9,136(sp)
ffffffffc020044a:	6d0a                	ld	s10,128(sp)
ffffffffc020044c:	612d                	addi	sp,sp,224
ffffffffc020044e:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200450:	8526                	mv	a0,s1
ffffffffc0200452:	5d4030ef          	jal	ra,ffffffffc0203a26 <strchr>
ffffffffc0200456:	c901                	beqz	a0,ffffffffc0200466 <kmonitor+0x102>
ffffffffc0200458:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc020045c:	00040023          	sb	zero,0(s0)
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200462:	d5c9                	beqz	a1,ffffffffc02003ec <kmonitor+0x88>
ffffffffc0200464:	b7f5                	j	ffffffffc0200450 <kmonitor+0xec>
        if (*buf == '\0') {
ffffffffc0200466:	00044783          	lbu	a5,0(s0)
ffffffffc020046a:	d3c9                	beqz	a5,ffffffffc02003ec <kmonitor+0x88>
        if (argc == MAXARGS - 1) {
ffffffffc020046c:	033c8963          	beq	s9,s3,ffffffffc020049e <kmonitor+0x13a>
        argv[argc ++] = buf;
ffffffffc0200470:	003c9793          	slli	a5,s9,0x3
ffffffffc0200474:	0118                	addi	a4,sp,128
ffffffffc0200476:	97ba                	add	a5,a5,a4
ffffffffc0200478:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200480:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200482:	e591                	bnez	a1,ffffffffc020048e <kmonitor+0x12a>
ffffffffc0200484:	b7b5                	j	ffffffffc02003f0 <kmonitor+0x8c>
ffffffffc0200486:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020048a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020048c:	d1a5                	beqz	a1,ffffffffc02003ec <kmonitor+0x88>
ffffffffc020048e:	8526                	mv	a0,s1
ffffffffc0200490:	596030ef          	jal	ra,ffffffffc0203a26 <strchr>
ffffffffc0200494:	d96d                	beqz	a0,ffffffffc0200486 <kmonitor+0x122>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200496:	00044583          	lbu	a1,0(s0)
ffffffffc020049a:	d9a9                	beqz	a1,ffffffffc02003ec <kmonitor+0x88>
ffffffffc020049c:	bf55                	j	ffffffffc0200450 <kmonitor+0xec>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020049e:	45c1                	li	a1,16
ffffffffc02004a0:	855a                	mv	a0,s6
ffffffffc02004a2:	c3fff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc02004a6:	b7e9                	j	ffffffffc0200470 <kmonitor+0x10c>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02004a8:	6582                	ld	a1,0(sp)
ffffffffc02004aa:	00004517          	auipc	a0,0x4
ffffffffc02004ae:	c5650513          	addi	a0,a0,-938 # ffffffffc0204100 <etext+0x272>
ffffffffc02004b2:	c2fff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
ffffffffc02004b6:	b715                	j	ffffffffc02003da <kmonitor+0x76>

ffffffffc02004b8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02004b8:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc02004ba:	00004517          	auipc	a0,0x4
ffffffffc02004be:	ca650513          	addi	a0,a0,-858 # ffffffffc0204160 <commands+0x48>
void dtb_init(void) {
ffffffffc02004c2:	fc86                	sd	ra,120(sp)
ffffffffc02004c4:	f8a2                	sd	s0,112(sp)
ffffffffc02004c6:	e8d2                	sd	s4,80(sp)
ffffffffc02004c8:	f4a6                	sd	s1,104(sp)
ffffffffc02004ca:	f0ca                	sd	s2,96(sp)
ffffffffc02004cc:	ecce                	sd	s3,88(sp)
ffffffffc02004ce:	e4d6                	sd	s5,72(sp)
ffffffffc02004d0:	e0da                	sd	s6,64(sp)
ffffffffc02004d2:	fc5e                	sd	s7,56(sp)
ffffffffc02004d4:	f862                	sd	s8,48(sp)
ffffffffc02004d6:	f466                	sd	s9,40(sp)
ffffffffc02004d8:	f06a                	sd	s10,32(sp)
ffffffffc02004da:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc02004dc:	c05ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02004e0:	00009597          	auipc	a1,0x9
ffffffffc02004e4:	b205b583          	ld	a1,-1248(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc02004e8:	00004517          	auipc	a0,0x4
ffffffffc02004ec:	c8850513          	addi	a0,a0,-888 # ffffffffc0204170 <commands+0x58>
ffffffffc02004f0:	bf1ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004f4:	00009417          	auipc	s0,0x9
ffffffffc02004f8:	b1440413          	addi	s0,s0,-1260 # ffffffffc0209008 <boot_dtb>
ffffffffc02004fc:	600c                	ld	a1,0(s0)
ffffffffc02004fe:	00004517          	auipc	a0,0x4
ffffffffc0200502:	c8250513          	addi	a0,a0,-894 # ffffffffc0204180 <commands+0x68>
ffffffffc0200506:	bdbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020050a:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020050e:	00004517          	auipc	a0,0x4
ffffffffc0200512:	c8a50513          	addi	a0,a0,-886 # ffffffffc0204198 <commands+0x80>
    if (boot_dtb == 0) {
ffffffffc0200516:	120a0463          	beqz	s4,ffffffffc020063e <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020051a:	57f5                	li	a5,-3
ffffffffc020051c:	07fa                	slli	a5,a5,0x1e
ffffffffc020051e:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200522:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200524:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200528:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020052e:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200532:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200536:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020053a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053e:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200540:	8ec9                	or	a3,a3,a0
ffffffffc0200542:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200546:	1b7d                	addi	s6,s6,-1
ffffffffc0200548:	0167f7b3          	and	a5,a5,s6
ffffffffc020054c:	8dd5                	or	a1,a1,a3
ffffffffc020054e:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200550:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200554:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200556:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed2a09>
ffffffffc020055a:	10f59163          	bne	a1,a5,ffffffffc020065c <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020055e:	471c                	lw	a5,8(a4)
ffffffffc0200560:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc0200562:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200564:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200568:	0086d51b          	srliw	a0,a3,0x8
ffffffffc020056c:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200570:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200574:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200578:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020057c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200580:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200584:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200588:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020058c:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020058e:	01146433          	or	s0,s0,a7
ffffffffc0200592:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200596:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020059a:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020059c:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005a0:	8c49                	or	s0,s0,a0
ffffffffc02005a2:	0166f6b3          	and	a3,a3,s6
ffffffffc02005a6:	00ca6a33          	or	s4,s4,a2
ffffffffc02005aa:	0167f7b3          	and	a5,a5,s6
ffffffffc02005ae:	8c55                	or	s0,s0,a3
ffffffffc02005b0:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b4:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005b6:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b8:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005ba:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005be:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005c0:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc02005c6:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02005c8:	00004917          	auipc	s2,0x4
ffffffffc02005cc:	c2090913          	addi	s2,s2,-992 # ffffffffc02041e8 <commands+0xd0>
ffffffffc02005d0:	49bd                	li	s3,15
        switch (token) {
ffffffffc02005d2:	4d91                	li	s11,4
ffffffffc02005d4:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005d6:	00004497          	auipc	s1,0x4
ffffffffc02005da:	c0a48493          	addi	s1,s1,-1014 # ffffffffc02041e0 <commands+0xc8>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005de:	000a2703          	lw	a4,0(s4)
ffffffffc02005e2:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e6:	0087569b          	srliw	a3,a4,0x8
ffffffffc02005ea:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ee:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f2:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f6:	0107571b          	srliw	a4,a4,0x10
ffffffffc02005fa:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005fc:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200600:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200604:	8fd5                	or	a5,a5,a3
ffffffffc0200606:	00eb7733          	and	a4,s6,a4
ffffffffc020060a:	8fd9                	or	a5,a5,a4
ffffffffc020060c:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020060e:	09778c63          	beq	a5,s7,ffffffffc02006a6 <dtb_init+0x1ee>
ffffffffc0200612:	00fbea63          	bltu	s7,a5,ffffffffc0200626 <dtb_init+0x16e>
ffffffffc0200616:	07a78663          	beq	a5,s10,ffffffffc0200682 <dtb_init+0x1ca>
ffffffffc020061a:	4709                	li	a4,2
ffffffffc020061c:	00e79763          	bne	a5,a4,ffffffffc020062a <dtb_init+0x172>
ffffffffc0200620:	4c81                	li	s9,0
ffffffffc0200622:	8a56                	mv	s4,s5
ffffffffc0200624:	bf6d                	j	ffffffffc02005de <dtb_init+0x126>
ffffffffc0200626:	ffb78ee3          	beq	a5,s11,ffffffffc0200622 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc020062a:	00004517          	auipc	a0,0x4
ffffffffc020062e:	c3650513          	addi	a0,a0,-970 # ffffffffc0204260 <commands+0x148>
ffffffffc0200632:	aafff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200636:	00004517          	auipc	a0,0x4
ffffffffc020063a:	c6250513          	addi	a0,a0,-926 # ffffffffc0204298 <commands+0x180>
}
ffffffffc020063e:	7446                	ld	s0,112(sp)
ffffffffc0200640:	70e6                	ld	ra,120(sp)
ffffffffc0200642:	74a6                	ld	s1,104(sp)
ffffffffc0200644:	7906                	ld	s2,96(sp)
ffffffffc0200646:	69e6                	ld	s3,88(sp)
ffffffffc0200648:	6a46                	ld	s4,80(sp)
ffffffffc020064a:	6aa6                	ld	s5,72(sp)
ffffffffc020064c:	6b06                	ld	s6,64(sp)
ffffffffc020064e:	7be2                	ld	s7,56(sp)
ffffffffc0200650:	7c42                	ld	s8,48(sp)
ffffffffc0200652:	7ca2                	ld	s9,40(sp)
ffffffffc0200654:	7d02                	ld	s10,32(sp)
ffffffffc0200656:	6de2                	ld	s11,24(sp)
ffffffffc0200658:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020065a:	b459                	j	ffffffffc02000e0 <cprintf>
}
ffffffffc020065c:	7446                	ld	s0,112(sp)
ffffffffc020065e:	70e6                	ld	ra,120(sp)
ffffffffc0200660:	74a6                	ld	s1,104(sp)
ffffffffc0200662:	7906                	ld	s2,96(sp)
ffffffffc0200664:	69e6                	ld	s3,88(sp)
ffffffffc0200666:	6a46                	ld	s4,80(sp)
ffffffffc0200668:	6aa6                	ld	s5,72(sp)
ffffffffc020066a:	6b06                	ld	s6,64(sp)
ffffffffc020066c:	7be2                	ld	s7,56(sp)
ffffffffc020066e:	7c42                	ld	s8,48(sp)
ffffffffc0200670:	7ca2                	ld	s9,40(sp)
ffffffffc0200672:	7d02                	ld	s10,32(sp)
ffffffffc0200674:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200676:	00004517          	auipc	a0,0x4
ffffffffc020067a:	b4250513          	addi	a0,a0,-1214 # ffffffffc02041b8 <commands+0xa0>
}
ffffffffc020067e:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200680:	b485                	j	ffffffffc02000e0 <cprintf>
                int name_len = strlen(name);
ffffffffc0200682:	8556                	mv	a0,s5
ffffffffc0200684:	316030ef          	jal	ra,ffffffffc020399a <strlen>
ffffffffc0200688:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020068a:	4619                	li	a2,6
ffffffffc020068c:	85a6                	mv	a1,s1
ffffffffc020068e:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200690:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200692:	36e030ef          	jal	ra,ffffffffc0203a00 <strncmp>
ffffffffc0200696:	e111                	bnez	a0,ffffffffc020069a <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200698:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020069a:	0a91                	addi	s5,s5,4
ffffffffc020069c:	9ad2                	add	s5,s5,s4
ffffffffc020069e:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02006a2:	8a56                	mv	s4,s5
ffffffffc02006a4:	bf2d                	j	ffffffffc02005de <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a6:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006aa:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ae:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02006b2:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006c2:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c6:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ca:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006ce:	00eaeab3          	or	s5,s5,a4
ffffffffc02006d2:	00fb77b3          	and	a5,s6,a5
ffffffffc02006d6:	00faeab3          	or	s5,s5,a5
ffffffffc02006da:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006dc:	000c9c63          	bnez	s9,ffffffffc02006f4 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006e0:	1a82                	slli	s5,s5,0x20
ffffffffc02006e2:	00368793          	addi	a5,a3,3
ffffffffc02006e6:	020ada93          	srli	s5,s5,0x20
ffffffffc02006ea:	9abe                	add	s5,s5,a5
ffffffffc02006ec:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02006f0:	8a56                	mv	s4,s5
ffffffffc02006f2:	b5f5                	j	ffffffffc02005de <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006f4:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f8:	85ca                	mv	a1,s2
ffffffffc02006fa:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006fc:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200700:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200704:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200708:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020070c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200710:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200712:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200716:	0087979b          	slliw	a5,a5,0x8
ffffffffc020071a:	8d59                	or	a0,a0,a4
ffffffffc020071c:	00fb77b3          	and	a5,s6,a5
ffffffffc0200720:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200722:	1502                	slli	a0,a0,0x20
ffffffffc0200724:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200726:	9522                	add	a0,a0,s0
ffffffffc0200728:	2ba030ef          	jal	ra,ffffffffc02039e2 <strcmp>
ffffffffc020072c:	66a2                	ld	a3,8(sp)
ffffffffc020072e:	f94d                	bnez	a0,ffffffffc02006e0 <dtb_init+0x228>
ffffffffc0200730:	fb59f8e3          	bgeu	s3,s5,ffffffffc02006e0 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200734:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200738:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020073c:	00004517          	auipc	a0,0x4
ffffffffc0200740:	ab450513          	addi	a0,a0,-1356 # ffffffffc02041f0 <commands+0xd8>
           fdt32_to_cpu(x >> 32);
ffffffffc0200744:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200748:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020074c:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200750:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200754:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200758:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020075c:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200760:	0187d693          	srli	a3,a5,0x18
ffffffffc0200764:	01861f1b          	slliw	t5,a2,0x18
ffffffffc0200768:	0087579b          	srliw	a5,a4,0x8
ffffffffc020076c:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200770:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200774:	010f6f33          	or	t5,t5,a6
ffffffffc0200778:	0187529b          	srliw	t0,a4,0x18
ffffffffc020077c:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200780:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200784:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	0186f6b3          	and	a3,a3,s8
ffffffffc020078c:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200790:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200794:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200798:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020079c:	8361                	srli	a4,a4,0x18
ffffffffc020079e:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02007a6:	01e6e6b3          	or	a3,a3,t5
ffffffffc02007aa:	00cb7633          	and	a2,s6,a2
ffffffffc02007ae:	0088181b          	slliw	a6,a6,0x8
ffffffffc02007b2:	0085959b          	slliw	a1,a1,0x8
ffffffffc02007b6:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ba:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007be:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c2:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c6:	0088989b          	slliw	a7,a7,0x8
ffffffffc02007ca:	011b78b3          	and	a7,s6,a7
ffffffffc02007ce:	005eeeb3          	or	t4,t4,t0
ffffffffc02007d2:	00c6e733          	or	a4,a3,a2
ffffffffc02007d6:	006c6c33          	or	s8,s8,t1
ffffffffc02007da:	010b76b3          	and	a3,s6,a6
ffffffffc02007de:	00bb7b33          	and	s6,s6,a1
ffffffffc02007e2:	01d7e7b3          	or	a5,a5,t4
ffffffffc02007e6:	016c6b33          	or	s6,s8,s6
ffffffffc02007ea:	01146433          	or	s0,s0,a7
ffffffffc02007ee:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc02007f0:	1702                	slli	a4,a4,0x20
ffffffffc02007f2:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007f4:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007f6:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007f8:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007fa:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007fe:	0167eb33          	or	s6,a5,s6
ffffffffc0200802:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200804:	8ddff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200808:	85a2                	mv	a1,s0
ffffffffc020080a:	00004517          	auipc	a0,0x4
ffffffffc020080e:	a0650513          	addi	a0,a0,-1530 # ffffffffc0204210 <commands+0xf8>
ffffffffc0200812:	8cfff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200816:	014b5613          	srli	a2,s6,0x14
ffffffffc020081a:	85da                	mv	a1,s6
ffffffffc020081c:	00004517          	auipc	a0,0x4
ffffffffc0200820:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0204228 <commands+0x110>
ffffffffc0200824:	8bdff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200828:	008b05b3          	add	a1,s6,s0
ffffffffc020082c:	15fd                	addi	a1,a1,-1
ffffffffc020082e:	00004517          	auipc	a0,0x4
ffffffffc0200832:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0204248 <commands+0x130>
ffffffffc0200836:	8abff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc020083a:	00004517          	auipc	a0,0x4
ffffffffc020083e:	a5e50513          	addi	a0,a0,-1442 # ffffffffc0204298 <commands+0x180>
        memory_base = mem_base;
ffffffffc0200842:	0000d797          	auipc	a5,0xd
ffffffffc0200846:	c287b723          	sd	s0,-978(a5) # ffffffffc020d470 <memory_base>
        memory_size = mem_size;
ffffffffc020084a:	0000d797          	auipc	a5,0xd
ffffffffc020084e:	c367b723          	sd	s6,-978(a5) # ffffffffc020d478 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200852:	b3f5                	j	ffffffffc020063e <dtb_init+0x186>

ffffffffc0200854 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200854:	0000d517          	auipc	a0,0xd
ffffffffc0200858:	c1c53503          	ld	a0,-996(a0) # ffffffffc020d470 <memory_base>
ffffffffc020085c:	8082                	ret

ffffffffc020085e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc020085e:	0000d517          	auipc	a0,0xd
ffffffffc0200862:	c1a53503          	ld	a0,-998(a0) # ffffffffc020d478 <memory_size>
ffffffffc0200866:	8082                	ret

ffffffffc0200868 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200868:	67e1                	lui	a5,0x18
ffffffffc020086a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020086e:	0000d717          	auipc	a4,0xd
ffffffffc0200872:	c0f73d23          	sd	a5,-998(a4) # ffffffffc020d488 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200876:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020087a:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020087c:	953e                	add	a0,a0,a5
ffffffffc020087e:	4601                	li	a2,0
ffffffffc0200880:	4881                	li	a7,0
ffffffffc0200882:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200886:	02000793          	li	a5,32
ffffffffc020088a:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020088e:	00004517          	auipc	a0,0x4
ffffffffc0200892:	a2250513          	addi	a0,a0,-1502 # ffffffffc02042b0 <commands+0x198>
    ticks = 0;
ffffffffc0200896:	0000d797          	auipc	a5,0xd
ffffffffc020089a:	be07b523          	sd	zero,-1046(a5) # ffffffffc020d480 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020089e:	843ff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc02008a2 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02008a2:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02008a6:	0000d797          	auipc	a5,0xd
ffffffffc02008aa:	be27b783          	ld	a5,-1054(a5) # ffffffffc020d488 <timebase>
ffffffffc02008ae:	953e                	add	a0,a0,a5
ffffffffc02008b0:	4581                	li	a1,0
ffffffffc02008b2:	4601                	li	a2,0
ffffffffc02008b4:	4881                	li	a7,0
ffffffffc02008b6:	00000073          	ecall
ffffffffc02008ba:	8082                	ret

ffffffffc02008bc <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02008bc:	8082                	ret

ffffffffc02008be <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008be:	100027f3          	csrr	a5,sstatus
ffffffffc02008c2:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02008c4:	0ff57513          	zext.b	a0,a0
ffffffffc02008c8:	e799                	bnez	a5,ffffffffc02008d6 <cons_putc+0x18>
ffffffffc02008ca:	4581                	li	a1,0
ffffffffc02008cc:	4601                	li	a2,0
ffffffffc02008ce:	4885                	li	a7,1
ffffffffc02008d0:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02008d4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02008d6:	1101                	addi	sp,sp,-32
ffffffffc02008d8:	ec06                	sd	ra,24(sp)
ffffffffc02008da:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02008dc:	05a000ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02008e0:	6522                	ld	a0,8(sp)
ffffffffc02008e2:	4581                	li	a1,0
ffffffffc02008e4:	4601                	li	a2,0
ffffffffc02008e6:	4885                	li	a7,1
ffffffffc02008e8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02008ec:	60e2                	ld	ra,24(sp)
ffffffffc02008ee:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02008f0:	a081                	j	ffffffffc0200930 <intr_enable>

ffffffffc02008f2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008f2:	100027f3          	csrr	a5,sstatus
ffffffffc02008f6:	8b89                	andi	a5,a5,2
ffffffffc02008f8:	eb89                	bnez	a5,ffffffffc020090a <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02008fa:	4501                	li	a0,0
ffffffffc02008fc:	4581                	li	a1,0
ffffffffc02008fe:	4601                	li	a2,0
ffffffffc0200900:	4889                	li	a7,2
ffffffffc0200902:	00000073          	ecall
ffffffffc0200906:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200908:	8082                	ret
int cons_getc(void) {
ffffffffc020090a:	1101                	addi	sp,sp,-32
ffffffffc020090c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020090e:	028000ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0200912:	4501                	li	a0,0
ffffffffc0200914:	4581                	li	a1,0
ffffffffc0200916:	4601                	li	a2,0
ffffffffc0200918:	4889                	li	a7,2
ffffffffc020091a:	00000073          	ecall
ffffffffc020091e:	2501                	sext.w	a0,a0
ffffffffc0200920:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200922:	00e000ef          	jal	ra,ffffffffc0200930 <intr_enable>
}
ffffffffc0200926:	60e2                	ld	ra,24(sp)
ffffffffc0200928:	6522                	ld	a0,8(sp)
ffffffffc020092a:	6105                	addi	sp,sp,32
ffffffffc020092c:	8082                	ret

ffffffffc020092e <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020092e:	8082                	ret

ffffffffc0200930 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200930:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200934:	8082                	ret

ffffffffc0200936 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200936:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020093a:	8082                	ret

ffffffffc020093c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020093c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200940:	00000797          	auipc	a5,0x0
ffffffffc0200944:	3ec78793          	addi	a5,a5,1004 # ffffffffc0200d2c <__alltraps>
ffffffffc0200948:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020094c:	000407b7          	lui	a5,0x40
ffffffffc0200950:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200954:	8082                	ret

ffffffffc0200956 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200956:	610c                	ld	a1,0(a0)
{
ffffffffc0200958:	1141                	addi	sp,sp,-16
ffffffffc020095a:	e022                	sd	s0,0(sp)
ffffffffc020095c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020095e:	00004517          	auipc	a0,0x4
ffffffffc0200962:	97250513          	addi	a0,a0,-1678 # ffffffffc02042d0 <commands+0x1b8>
{
ffffffffc0200966:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200968:	f78ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020096c:	640c                	ld	a1,8(s0)
ffffffffc020096e:	00004517          	auipc	a0,0x4
ffffffffc0200972:	97a50513          	addi	a0,a0,-1670 # ffffffffc02042e8 <commands+0x1d0>
ffffffffc0200976:	f6aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020097a:	680c                	ld	a1,16(s0)
ffffffffc020097c:	00004517          	auipc	a0,0x4
ffffffffc0200980:	98450513          	addi	a0,a0,-1660 # ffffffffc0204300 <commands+0x1e8>
ffffffffc0200984:	f5cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200988:	6c0c                	ld	a1,24(s0)
ffffffffc020098a:	00004517          	auipc	a0,0x4
ffffffffc020098e:	98e50513          	addi	a0,a0,-1650 # ffffffffc0204318 <commands+0x200>
ffffffffc0200992:	f4eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200996:	700c                	ld	a1,32(s0)
ffffffffc0200998:	00004517          	auipc	a0,0x4
ffffffffc020099c:	99850513          	addi	a0,a0,-1640 # ffffffffc0204330 <commands+0x218>
ffffffffc02009a0:	f40ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02009a4:	740c                	ld	a1,40(s0)
ffffffffc02009a6:	00004517          	auipc	a0,0x4
ffffffffc02009aa:	9a250513          	addi	a0,a0,-1630 # ffffffffc0204348 <commands+0x230>
ffffffffc02009ae:	f32ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02009b2:	780c                	ld	a1,48(s0)
ffffffffc02009b4:	00004517          	auipc	a0,0x4
ffffffffc02009b8:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0204360 <commands+0x248>
ffffffffc02009bc:	f24ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02009c0:	7c0c                	ld	a1,56(s0)
ffffffffc02009c2:	00004517          	auipc	a0,0x4
ffffffffc02009c6:	9b650513          	addi	a0,a0,-1610 # ffffffffc0204378 <commands+0x260>
ffffffffc02009ca:	f16ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02009ce:	602c                	ld	a1,64(s0)
ffffffffc02009d0:	00004517          	auipc	a0,0x4
ffffffffc02009d4:	9c050513          	addi	a0,a0,-1600 # ffffffffc0204390 <commands+0x278>
ffffffffc02009d8:	f08ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009dc:	642c                	ld	a1,72(s0)
ffffffffc02009de:	00004517          	auipc	a0,0x4
ffffffffc02009e2:	9ca50513          	addi	a0,a0,-1590 # ffffffffc02043a8 <commands+0x290>
ffffffffc02009e6:	efaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ea:	682c                	ld	a1,80(s0)
ffffffffc02009ec:	00004517          	auipc	a0,0x4
ffffffffc02009f0:	9d450513          	addi	a0,a0,-1580 # ffffffffc02043c0 <commands+0x2a8>
ffffffffc02009f4:	eecff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009f8:	6c2c                	ld	a1,88(s0)
ffffffffc02009fa:	00004517          	auipc	a0,0x4
ffffffffc02009fe:	9de50513          	addi	a0,a0,-1570 # ffffffffc02043d8 <commands+0x2c0>
ffffffffc0200a02:	edeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a06:	702c                	ld	a1,96(s0)
ffffffffc0200a08:	00004517          	auipc	a0,0x4
ffffffffc0200a0c:	9e850513          	addi	a0,a0,-1560 # ffffffffc02043f0 <commands+0x2d8>
ffffffffc0200a10:	ed0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a14:	742c                	ld	a1,104(s0)
ffffffffc0200a16:	00004517          	auipc	a0,0x4
ffffffffc0200a1a:	9f250513          	addi	a0,a0,-1550 # ffffffffc0204408 <commands+0x2f0>
ffffffffc0200a1e:	ec2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a22:	782c                	ld	a1,112(s0)
ffffffffc0200a24:	00004517          	auipc	a0,0x4
ffffffffc0200a28:	9fc50513          	addi	a0,a0,-1540 # ffffffffc0204420 <commands+0x308>
ffffffffc0200a2c:	eb4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a30:	7c2c                	ld	a1,120(s0)
ffffffffc0200a32:	00004517          	auipc	a0,0x4
ffffffffc0200a36:	a0650513          	addi	a0,a0,-1530 # ffffffffc0204438 <commands+0x320>
ffffffffc0200a3a:	ea6ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a3e:	604c                	ld	a1,128(s0)
ffffffffc0200a40:	00004517          	auipc	a0,0x4
ffffffffc0200a44:	a1050513          	addi	a0,a0,-1520 # ffffffffc0204450 <commands+0x338>
ffffffffc0200a48:	e98ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a4c:	644c                	ld	a1,136(s0)
ffffffffc0200a4e:	00004517          	auipc	a0,0x4
ffffffffc0200a52:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0204468 <commands+0x350>
ffffffffc0200a56:	e8aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a5a:	684c                	ld	a1,144(s0)
ffffffffc0200a5c:	00004517          	auipc	a0,0x4
ffffffffc0200a60:	a2450513          	addi	a0,a0,-1500 # ffffffffc0204480 <commands+0x368>
ffffffffc0200a64:	e7cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a68:	6c4c                	ld	a1,152(s0)
ffffffffc0200a6a:	00004517          	auipc	a0,0x4
ffffffffc0200a6e:	a2e50513          	addi	a0,a0,-1490 # ffffffffc0204498 <commands+0x380>
ffffffffc0200a72:	e6eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a76:	704c                	ld	a1,160(s0)
ffffffffc0200a78:	00004517          	auipc	a0,0x4
ffffffffc0200a7c:	a3850513          	addi	a0,a0,-1480 # ffffffffc02044b0 <commands+0x398>
ffffffffc0200a80:	e60ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a84:	744c                	ld	a1,168(s0)
ffffffffc0200a86:	00004517          	auipc	a0,0x4
ffffffffc0200a8a:	a4250513          	addi	a0,a0,-1470 # ffffffffc02044c8 <commands+0x3b0>
ffffffffc0200a8e:	e52ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a92:	784c                	ld	a1,176(s0)
ffffffffc0200a94:	00004517          	auipc	a0,0x4
ffffffffc0200a98:	a4c50513          	addi	a0,a0,-1460 # ffffffffc02044e0 <commands+0x3c8>
ffffffffc0200a9c:	e44ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200aa0:	7c4c                	ld	a1,184(s0)
ffffffffc0200aa2:	00004517          	auipc	a0,0x4
ffffffffc0200aa6:	a5650513          	addi	a0,a0,-1450 # ffffffffc02044f8 <commands+0x3e0>
ffffffffc0200aaa:	e36ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200aae:	606c                	ld	a1,192(s0)
ffffffffc0200ab0:	00004517          	auipc	a0,0x4
ffffffffc0200ab4:	a6050513          	addi	a0,a0,-1440 # ffffffffc0204510 <commands+0x3f8>
ffffffffc0200ab8:	e28ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200abc:	646c                	ld	a1,200(s0)
ffffffffc0200abe:	00004517          	auipc	a0,0x4
ffffffffc0200ac2:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0204528 <commands+0x410>
ffffffffc0200ac6:	e1aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200aca:	686c                	ld	a1,208(s0)
ffffffffc0200acc:	00004517          	auipc	a0,0x4
ffffffffc0200ad0:	a7450513          	addi	a0,a0,-1420 # ffffffffc0204540 <commands+0x428>
ffffffffc0200ad4:	e0cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200ad8:	6c6c                	ld	a1,216(s0)
ffffffffc0200ada:	00004517          	auipc	a0,0x4
ffffffffc0200ade:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0204558 <commands+0x440>
ffffffffc0200ae2:	dfeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ae6:	706c                	ld	a1,224(s0)
ffffffffc0200ae8:	00004517          	auipc	a0,0x4
ffffffffc0200aec:	a8850513          	addi	a0,a0,-1400 # ffffffffc0204570 <commands+0x458>
ffffffffc0200af0:	df0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200af4:	746c                	ld	a1,232(s0)
ffffffffc0200af6:	00004517          	auipc	a0,0x4
ffffffffc0200afa:	a9250513          	addi	a0,a0,-1390 # ffffffffc0204588 <commands+0x470>
ffffffffc0200afe:	de2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b02:	786c                	ld	a1,240(s0)
ffffffffc0200b04:	00004517          	auipc	a0,0x4
ffffffffc0200b08:	a9c50513          	addi	a0,a0,-1380 # ffffffffc02045a0 <commands+0x488>
ffffffffc0200b0c:	dd4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b10:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b12:	6402                	ld	s0,0(sp)
ffffffffc0200b14:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b16:	00004517          	auipc	a0,0x4
ffffffffc0200b1a:	aa250513          	addi	a0,a0,-1374 # ffffffffc02045b8 <commands+0x4a0>
}
ffffffffc0200b1e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b20:	dc0ff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200b24 <print_trapframe>:
{
ffffffffc0200b24:	1141                	addi	sp,sp,-16
ffffffffc0200b26:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b28:	85aa                	mv	a1,a0
{
ffffffffc0200b2a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b2c:	00004517          	auipc	a0,0x4
ffffffffc0200b30:	aa450513          	addi	a0,a0,-1372 # ffffffffc02045d0 <commands+0x4b8>
{
ffffffffc0200b34:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b36:	daaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b3a:	8522                	mv	a0,s0
ffffffffc0200b3c:	e1bff0ef          	jal	ra,ffffffffc0200956 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b40:	10043583          	ld	a1,256(s0)
ffffffffc0200b44:	00004517          	auipc	a0,0x4
ffffffffc0200b48:	aa450513          	addi	a0,a0,-1372 # ffffffffc02045e8 <commands+0x4d0>
ffffffffc0200b4c:	d94ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b50:	10843583          	ld	a1,264(s0)
ffffffffc0200b54:	00004517          	auipc	a0,0x4
ffffffffc0200b58:	aac50513          	addi	a0,a0,-1364 # ffffffffc0204600 <commands+0x4e8>
ffffffffc0200b5c:	d84ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200b60:	11043583          	ld	a1,272(s0)
ffffffffc0200b64:	00004517          	auipc	a0,0x4
ffffffffc0200b68:	ab450513          	addi	a0,a0,-1356 # ffffffffc0204618 <commands+0x500>
ffffffffc0200b6c:	d74ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b70:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b74:	6402                	ld	s0,0(sp)
ffffffffc0200b76:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b78:	00004517          	auipc	a0,0x4
ffffffffc0200b7c:	ab850513          	addi	a0,a0,-1352 # ffffffffc0204630 <commands+0x518>
}
ffffffffc0200b80:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b82:	d5eff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200b86 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200b86:	11853783          	ld	a5,280(a0)
ffffffffc0200b8a:	472d                	li	a4,11
ffffffffc0200b8c:	0786                	slli	a5,a5,0x1
ffffffffc0200b8e:	8385                	srli	a5,a5,0x1
ffffffffc0200b90:	0af76d63          	bltu	a4,a5,ffffffffc0200c4a <interrupt_handler+0xc4>
ffffffffc0200b94:	00004717          	auipc	a4,0x4
ffffffffc0200b98:	b6470713          	addi	a4,a4,-1180 # ffffffffc02046f8 <commands+0x5e0>
ffffffffc0200b9c:	078a                	slli	a5,a5,0x2
ffffffffc0200b9e:	97ba                	add	a5,a5,a4
ffffffffc0200ba0:	439c                	lw	a5,0(a5)
ffffffffc0200ba2:	97ba                	add	a5,a5,a4
ffffffffc0200ba4:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200ba6:	00004517          	auipc	a0,0x4
ffffffffc0200baa:	b0250513          	addi	a0,a0,-1278 # ffffffffc02046a8 <commands+0x590>
ffffffffc0200bae:	d32ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bb2:	00004517          	auipc	a0,0x4
ffffffffc0200bb6:	ad650513          	addi	a0,a0,-1322 # ffffffffc0204688 <commands+0x570>
ffffffffc0200bba:	d26ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200bbe:	00004517          	auipc	a0,0x4
ffffffffc0200bc2:	a8a50513          	addi	a0,a0,-1398 # ffffffffc0204648 <commands+0x530>
ffffffffc0200bc6:	d1aff06f          	j	ffffffffc02000e0 <cprintf>
{
ffffffffc0200bca:	7179                	addi	sp,sp,-48
ffffffffc0200bcc:	f022                	sd	s0,32(sp)
ffffffffc0200bce:	ec26                	sd	s1,24(sp)
ffffffffc0200bd0:	e84a                	sd	s2,16(sp)
ffffffffc0200bd2:	e44e                	sd	s3,8(sp)
ffffffffc0200bd4:	e052                	sd	s4,0(sp)
ffffffffc0200bd6:	f406                	sd	ra,40(sp)
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200bd8:	4481                	li	s1,0
ffffffffc0200bda:	0000d417          	auipc	s0,0xd
ffffffffc0200bde:	8a640413          	addi	s0,s0,-1882 # ffffffffc020d480 <ticks>
        int num = 0;
            while(1)
            {
                clock_set_next_event();
                ticks++;
                if(ticks==TICK_NUM)
ffffffffc0200be2:	06400993          	li	s3,100
                {
                    cprintf("100ticks\n");
ffffffffc0200be6:	00004a17          	auipc	s4,0x4
ffffffffc0200bea:	ae2a0a13          	addi	s4,s4,-1310 # ffffffffc02046c8 <commands+0x5b0>
                    ticks = 0;
                    num++;
                }
                if(num == 10)
ffffffffc0200bee:	4929                	li	s2,10
                clock_set_next_event();
ffffffffc0200bf0:	cb3ff0ef          	jal	ra,ffffffffc02008a2 <clock_set_next_event>
                ticks++;
ffffffffc0200bf4:	601c                	ld	a5,0(s0)
ffffffffc0200bf6:	0785                	addi	a5,a5,1
ffffffffc0200bf8:	e01c                	sd	a5,0(s0)
                if(ticks==TICK_NUM)
ffffffffc0200bfa:	601c                	ld	a5,0(s0)
ffffffffc0200bfc:	03378263          	beq	a5,s3,ffffffffc0200c20 <interrupt_handler+0x9a>
                if(num == 10)
ffffffffc0200c00:	ff2498e3          	bne	s1,s2,ffffffffc0200bf0 <interrupt_handler+0x6a>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c04:	4501                	li	a0,0
ffffffffc0200c06:	4581                	li	a1,0
ffffffffc0200c08:	4601                	li	a2,0
ffffffffc0200c0a:	48a1                	li	a7,8
ffffffffc0200c0c:	00000073          	ecall
                clock_set_next_event();
ffffffffc0200c10:	c93ff0ef          	jal	ra,ffffffffc02008a2 <clock_set_next_event>
                ticks++;
ffffffffc0200c14:	601c                	ld	a5,0(s0)
ffffffffc0200c16:	0785                	addi	a5,a5,1
ffffffffc0200c18:	e01c                	sd	a5,0(s0)
                if(ticks==TICK_NUM)
ffffffffc0200c1a:	601c                	ld	a5,0(s0)
ffffffffc0200c1c:	ff3792e3          	bne	a5,s3,ffffffffc0200c00 <interrupt_handler+0x7a>
                    cprintf("100ticks\n");
ffffffffc0200c20:	8552                	mv	a0,s4
ffffffffc0200c22:	cbeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
                    num++;
ffffffffc0200c26:	2485                	addiw	s1,s1,1
                    ticks = 0;
ffffffffc0200c28:	0000d797          	auipc	a5,0xd
ffffffffc0200c2c:	8407bc23          	sd	zero,-1960(a5) # ffffffffc020d480 <ticks>
                    num++;
ffffffffc0200c30:	bfc1                	j	ffffffffc0200c00 <interrupt_handler+0x7a>
        break;
    case IRQ_U_EXT:
        cprintf("User software interrupt\n");
        break;
    case IRQ_S_EXT:
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c32:	00004517          	auipc	a0,0x4
ffffffffc0200c36:	aa650513          	addi	a0,a0,-1370 # ffffffffc02046d8 <commands+0x5c0>
ffffffffc0200c3a:	ca6ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c3e:	00004517          	auipc	a0,0x4
ffffffffc0200c42:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0204668 <commands+0x550>
ffffffffc0200c46:	c9aff06f          	j	ffffffffc02000e0 <cprintf>
        break;
    case IRQ_M_EXT:
        cprintf("Machine software interrupt\n");
        break;
    default:
        print_trapframe(tf);
ffffffffc0200c4a:	bde9                	j	ffffffffc0200b24 <print_trapframe>

ffffffffc0200c4c <exception_handler>:
}

void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c4c:	11853783          	ld	a5,280(a0)
ffffffffc0200c50:	473d                	li	a4,15
ffffffffc0200c52:	0cf76563          	bltu	a4,a5,ffffffffc0200d1c <exception_handler+0xd0>
ffffffffc0200c56:	00004717          	auipc	a4,0x4
ffffffffc0200c5a:	c6a70713          	addi	a4,a4,-918 # ffffffffc02048c0 <commands+0x7a8>
ffffffffc0200c5e:	078a                	slli	a5,a5,0x2
ffffffffc0200c60:	97ba                	add	a5,a5,a4
ffffffffc0200c62:	439c                	lw	a5,0(a5)
ffffffffc0200c64:	97ba                	add	a5,a5,a4
ffffffffc0200c66:	8782                	jr	a5
        break;
    case CAUSE_LOAD_PAGE_FAULT:
        cprintf("Load page fault\n");
        break;
    case CAUSE_STORE_PAGE_FAULT:
        cprintf("Store/AMO page fault\n");
ffffffffc0200c68:	00004517          	auipc	a0,0x4
ffffffffc0200c6c:	c4050513          	addi	a0,a0,-960 # ffffffffc02048a8 <commands+0x790>
ffffffffc0200c70:	c70ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Instruction address misaligned\n");
ffffffffc0200c74:	00004517          	auipc	a0,0x4
ffffffffc0200c78:	ab450513          	addi	a0,a0,-1356 # ffffffffc0204728 <commands+0x610>
ffffffffc0200c7c:	c64ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Instruction access fault\n");
ffffffffc0200c80:	00004517          	auipc	a0,0x4
ffffffffc0200c84:	ac850513          	addi	a0,a0,-1336 # ffffffffc0204748 <commands+0x630>
ffffffffc0200c88:	c58ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Illegal instruction\n");
ffffffffc0200c8c:	00004517          	auipc	a0,0x4
ffffffffc0200c90:	adc50513          	addi	a0,a0,-1316 # ffffffffc0204768 <commands+0x650>
ffffffffc0200c94:	c4cff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Breakpoint\n");
ffffffffc0200c98:	00004517          	auipc	a0,0x4
ffffffffc0200c9c:	ae850513          	addi	a0,a0,-1304 # ffffffffc0204780 <commands+0x668>
ffffffffc0200ca0:	c40ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Load address misaligned\n");
ffffffffc0200ca4:	00004517          	auipc	a0,0x4
ffffffffc0200ca8:	aec50513          	addi	a0,a0,-1300 # ffffffffc0204790 <commands+0x678>
ffffffffc0200cac:	c34ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Load access fault\n");
ffffffffc0200cb0:	00004517          	auipc	a0,0x4
ffffffffc0200cb4:	b0050513          	addi	a0,a0,-1280 # ffffffffc02047b0 <commands+0x698>
ffffffffc0200cb8:	c28ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("AMO address misaligned\n");
ffffffffc0200cbc:	00004517          	auipc	a0,0x4
ffffffffc0200cc0:	b0c50513          	addi	a0,a0,-1268 # ffffffffc02047c8 <commands+0x6b0>
ffffffffc0200cc4:	c1cff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Store/AMO access fault\n");
ffffffffc0200cc8:	00004517          	auipc	a0,0x4
ffffffffc0200ccc:	b1850513          	addi	a0,a0,-1256 # ffffffffc02047e0 <commands+0x6c8>
ffffffffc0200cd0:	c10ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from U-mode\n");
ffffffffc0200cd4:	00004517          	auipc	a0,0x4
ffffffffc0200cd8:	b2450513          	addi	a0,a0,-1244 # ffffffffc02047f8 <commands+0x6e0>
ffffffffc0200cdc:	c04ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from S-mode\n");
ffffffffc0200ce0:	00004517          	auipc	a0,0x4
ffffffffc0200ce4:	b3850513          	addi	a0,a0,-1224 # ffffffffc0204818 <commands+0x700>
ffffffffc0200ce8:	bf8ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cec:	00004517          	auipc	a0,0x4
ffffffffc0200cf0:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0204838 <commands+0x720>
ffffffffc0200cf4:	becff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200cf8:	00004517          	auipc	a0,0x4
ffffffffc0200cfc:	b6050513          	addi	a0,a0,-1184 # ffffffffc0204858 <commands+0x740>
ffffffffc0200d00:	be0ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Instruction page fault\n");
ffffffffc0200d04:	00004517          	auipc	a0,0x4
ffffffffc0200d08:	b7450513          	addi	a0,a0,-1164 # ffffffffc0204878 <commands+0x760>
ffffffffc0200d0c:	bd4ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Load page fault\n");
ffffffffc0200d10:	00004517          	auipc	a0,0x4
ffffffffc0200d14:	b8050513          	addi	a0,a0,-1152 # ffffffffc0204890 <commands+0x778>
ffffffffc0200d18:	bc8ff06f          	j	ffffffffc02000e0 <cprintf>
        break;
    default:
        print_trapframe(tf);
ffffffffc0200d1c:	b521                	j	ffffffffc0200b24 <print_trapframe>

ffffffffc0200d1e <trap>:
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d1e:	11853783          	ld	a5,280(a0)
ffffffffc0200d22:	0007c363          	bltz	a5,ffffffffc0200d28 <trap+0xa>
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
ffffffffc0200d26:	b71d                	j	ffffffffc0200c4c <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d28:	bdb9                	j	ffffffffc0200b86 <interrupt_handler>
	...

ffffffffc0200d2c <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d2c:	14011073          	csrw	sscratch,sp
ffffffffc0200d30:	712d                	addi	sp,sp,-288
ffffffffc0200d32:	e406                	sd	ra,8(sp)
ffffffffc0200d34:	ec0e                	sd	gp,24(sp)
ffffffffc0200d36:	f012                	sd	tp,32(sp)
ffffffffc0200d38:	f416                	sd	t0,40(sp)
ffffffffc0200d3a:	f81a                	sd	t1,48(sp)
ffffffffc0200d3c:	fc1e                	sd	t2,56(sp)
ffffffffc0200d3e:	e0a2                	sd	s0,64(sp)
ffffffffc0200d40:	e4a6                	sd	s1,72(sp)
ffffffffc0200d42:	e8aa                	sd	a0,80(sp)
ffffffffc0200d44:	ecae                	sd	a1,88(sp)
ffffffffc0200d46:	f0b2                	sd	a2,96(sp)
ffffffffc0200d48:	f4b6                	sd	a3,104(sp)
ffffffffc0200d4a:	f8ba                	sd	a4,112(sp)
ffffffffc0200d4c:	fcbe                	sd	a5,120(sp)
ffffffffc0200d4e:	e142                	sd	a6,128(sp)
ffffffffc0200d50:	e546                	sd	a7,136(sp)
ffffffffc0200d52:	e94a                	sd	s2,144(sp)
ffffffffc0200d54:	ed4e                	sd	s3,152(sp)
ffffffffc0200d56:	f152                	sd	s4,160(sp)
ffffffffc0200d58:	f556                	sd	s5,168(sp)
ffffffffc0200d5a:	f95a                	sd	s6,176(sp)
ffffffffc0200d5c:	fd5e                	sd	s7,184(sp)
ffffffffc0200d5e:	e1e2                	sd	s8,192(sp)
ffffffffc0200d60:	e5e6                	sd	s9,200(sp)
ffffffffc0200d62:	e9ea                	sd	s10,208(sp)
ffffffffc0200d64:	edee                	sd	s11,216(sp)
ffffffffc0200d66:	f1f2                	sd	t3,224(sp)
ffffffffc0200d68:	f5f6                	sd	t4,232(sp)
ffffffffc0200d6a:	f9fa                	sd	t5,240(sp)
ffffffffc0200d6c:	fdfe                	sd	t6,248(sp)
ffffffffc0200d6e:	14002473          	csrr	s0,sscratch
ffffffffc0200d72:	100024f3          	csrr	s1,sstatus
ffffffffc0200d76:	14102973          	csrr	s2,sepc
ffffffffc0200d7a:	143029f3          	csrr	s3,stval
ffffffffc0200d7e:	14202a73          	csrr	s4,scause
ffffffffc0200d82:	e822                	sd	s0,16(sp)
ffffffffc0200d84:	e226                	sd	s1,256(sp)
ffffffffc0200d86:	e64a                	sd	s2,264(sp)
ffffffffc0200d88:	ea4e                	sd	s3,272(sp)
ffffffffc0200d8a:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d8c:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d8e:	f91ff0ef          	jal	ra,ffffffffc0200d1e <trap>

ffffffffc0200d92 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d92:	6492                	ld	s1,256(sp)
ffffffffc0200d94:	6932                	ld	s2,264(sp)
ffffffffc0200d96:	10049073          	csrw	sstatus,s1
ffffffffc0200d9a:	14191073          	csrw	sepc,s2
ffffffffc0200d9e:	60a2                	ld	ra,8(sp)
ffffffffc0200da0:	61e2                	ld	gp,24(sp)
ffffffffc0200da2:	7202                	ld	tp,32(sp)
ffffffffc0200da4:	72a2                	ld	t0,40(sp)
ffffffffc0200da6:	7342                	ld	t1,48(sp)
ffffffffc0200da8:	73e2                	ld	t2,56(sp)
ffffffffc0200daa:	6406                	ld	s0,64(sp)
ffffffffc0200dac:	64a6                	ld	s1,72(sp)
ffffffffc0200dae:	6546                	ld	a0,80(sp)
ffffffffc0200db0:	65e6                	ld	a1,88(sp)
ffffffffc0200db2:	7606                	ld	a2,96(sp)
ffffffffc0200db4:	76a6                	ld	a3,104(sp)
ffffffffc0200db6:	7746                	ld	a4,112(sp)
ffffffffc0200db8:	77e6                	ld	a5,120(sp)
ffffffffc0200dba:	680a                	ld	a6,128(sp)
ffffffffc0200dbc:	68aa                	ld	a7,136(sp)
ffffffffc0200dbe:	694a                	ld	s2,144(sp)
ffffffffc0200dc0:	69ea                	ld	s3,152(sp)
ffffffffc0200dc2:	7a0a                	ld	s4,160(sp)
ffffffffc0200dc4:	7aaa                	ld	s5,168(sp)
ffffffffc0200dc6:	7b4a                	ld	s6,176(sp)
ffffffffc0200dc8:	7bea                	ld	s7,184(sp)
ffffffffc0200dca:	6c0e                	ld	s8,192(sp)
ffffffffc0200dcc:	6cae                	ld	s9,200(sp)
ffffffffc0200dce:	6d4e                	ld	s10,208(sp)
ffffffffc0200dd0:	6dee                	ld	s11,216(sp)
ffffffffc0200dd2:	7e0e                	ld	t3,224(sp)
ffffffffc0200dd4:	7eae                	ld	t4,232(sp)
ffffffffc0200dd6:	7f4e                	ld	t5,240(sp)
ffffffffc0200dd8:	7fee                	ld	t6,248(sp)
ffffffffc0200dda:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200ddc:	10200073          	sret

ffffffffc0200de0 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200de0:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200de2:	bf45                	j	ffffffffc0200d92 <__trapret>
	...

ffffffffc0200de6 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0200de6:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0200de8:	00004697          	auipc	a3,0x4
ffffffffc0200dec:	b1868693          	addi	a3,a3,-1256 # ffffffffc0204900 <commands+0x7e8>
ffffffffc0200df0:	00004617          	auipc	a2,0x4
ffffffffc0200df4:	b3060613          	addi	a2,a2,-1232 # ffffffffc0204920 <commands+0x808>
ffffffffc0200df8:	08800593          	li	a1,136
ffffffffc0200dfc:	00004517          	auipc	a0,0x4
ffffffffc0200e00:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0204938 <commands+0x820>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0200e04:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0200e06:	bd8ff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0200e0a <find_vma>:
{
ffffffffc0200e0a:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0200e0c:	c505                	beqz	a0,ffffffffc0200e34 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0200e0e:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0200e10:	c501                	beqz	a0,ffffffffc0200e18 <find_vma+0xe>
ffffffffc0200e12:	651c                	ld	a5,8(a0)
ffffffffc0200e14:	02f5f263          	bgeu	a1,a5,ffffffffc0200e38 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200e18:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0200e1a:	00f68d63          	beq	a3,a5,ffffffffc0200e34 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0200e1e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200e22:	00e5e663          	bltu	a1,a4,ffffffffc0200e2e <find_vma+0x24>
ffffffffc0200e26:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200e2a:	00e5ec63          	bltu	a1,a4,ffffffffc0200e42 <find_vma+0x38>
ffffffffc0200e2e:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0200e30:	fef697e3          	bne	a3,a5,ffffffffc0200e1e <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0200e34:	4501                	li	a0,0
}
ffffffffc0200e36:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0200e38:	691c                	ld	a5,16(a0)
ffffffffc0200e3a:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0200e18 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0200e3e:	ea88                	sd	a0,16(a3)
ffffffffc0200e40:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0200e42:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0200e46:	ea88                	sd	a0,16(a3)
ffffffffc0200e48:	8082                	ret

ffffffffc0200e4a <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200e4a:	6590                	ld	a2,8(a1)
ffffffffc0200e4c:	0105b803          	ld	a6,16(a1)
{
ffffffffc0200e50:	1141                	addi	sp,sp,-16
ffffffffc0200e52:	e406                	sd	ra,8(sp)
ffffffffc0200e54:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200e56:	01066763          	bltu	a2,a6,ffffffffc0200e64 <insert_vma_struct+0x1a>
ffffffffc0200e5a:	a085                	j	ffffffffc0200eba <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0200e5c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200e60:	04e66863          	bltu	a2,a4,ffffffffc0200eb0 <insert_vma_struct+0x66>
ffffffffc0200e64:	86be                	mv	a3,a5
ffffffffc0200e66:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0200e68:	fef51ae3          	bne	a0,a5,ffffffffc0200e5c <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0200e6c:	02a68463          	beq	a3,a0,ffffffffc0200e94 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0200e70:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200e74:	fe86b883          	ld	a7,-24(a3)
ffffffffc0200e78:	08e8f163          	bgeu	a7,a4,ffffffffc0200efa <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200e7c:	04e66f63          	bltu	a2,a4,ffffffffc0200eda <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0200e80:	00f50a63          	beq	a0,a5,ffffffffc0200e94 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0200e84:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200e88:	05076963          	bltu	a4,a6,ffffffffc0200eda <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0200e8c:	ff07b603          	ld	a2,-16(a5)
ffffffffc0200e90:	02c77363          	bgeu	a4,a2,ffffffffc0200eb6 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0200e94:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0200e96:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0200e98:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200e9c:	e390                	sd	a2,0(a5)
ffffffffc0200e9e:	e690                	sd	a2,8(a3)
}
ffffffffc0200ea0:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0200ea2:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0200ea4:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0200ea6:	0017079b          	addiw	a5,a4,1
ffffffffc0200eaa:	d11c                	sw	a5,32(a0)
}
ffffffffc0200eac:	0141                	addi	sp,sp,16
ffffffffc0200eae:	8082                	ret
    if (le_prev != list)
ffffffffc0200eb0:	fca690e3          	bne	a3,a0,ffffffffc0200e70 <insert_vma_struct+0x26>
ffffffffc0200eb4:	bfd1                	j	ffffffffc0200e88 <insert_vma_struct+0x3e>
ffffffffc0200eb6:	f31ff0ef          	jal	ra,ffffffffc0200de6 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200eba:	00004697          	auipc	a3,0x4
ffffffffc0200ebe:	a8e68693          	addi	a3,a3,-1394 # ffffffffc0204948 <commands+0x830>
ffffffffc0200ec2:	00004617          	auipc	a2,0x4
ffffffffc0200ec6:	a5e60613          	addi	a2,a2,-1442 # ffffffffc0204920 <commands+0x808>
ffffffffc0200eca:	08e00593          	li	a1,142
ffffffffc0200ece:	00004517          	auipc	a0,0x4
ffffffffc0200ed2:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0204938 <commands+0x820>
ffffffffc0200ed6:	b08ff0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200eda:	00004697          	auipc	a3,0x4
ffffffffc0200ede:	aae68693          	addi	a3,a3,-1362 # ffffffffc0204988 <commands+0x870>
ffffffffc0200ee2:	00004617          	auipc	a2,0x4
ffffffffc0200ee6:	a3e60613          	addi	a2,a2,-1474 # ffffffffc0204920 <commands+0x808>
ffffffffc0200eea:	08700593          	li	a1,135
ffffffffc0200eee:	00004517          	auipc	a0,0x4
ffffffffc0200ef2:	a4a50513          	addi	a0,a0,-1462 # ffffffffc0204938 <commands+0x820>
ffffffffc0200ef6:	ae8ff0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200efa:	00004697          	auipc	a3,0x4
ffffffffc0200efe:	a6e68693          	addi	a3,a3,-1426 # ffffffffc0204968 <commands+0x850>
ffffffffc0200f02:	00004617          	auipc	a2,0x4
ffffffffc0200f06:	a1e60613          	addi	a2,a2,-1506 # ffffffffc0204920 <commands+0x808>
ffffffffc0200f0a:	08600593          	li	a1,134
ffffffffc0200f0e:	00004517          	auipc	a0,0x4
ffffffffc0200f12:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0204938 <commands+0x820>
ffffffffc0200f16:	ac8ff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0200f1a <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0200f1a:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200f1c:	03000513          	li	a0,48
{
ffffffffc0200f20:	fc06                	sd	ra,56(sp)
ffffffffc0200f22:	f822                	sd	s0,48(sp)
ffffffffc0200f24:	f426                	sd	s1,40(sp)
ffffffffc0200f26:	f04a                	sd	s2,32(sp)
ffffffffc0200f28:	ec4e                	sd	s3,24(sp)
ffffffffc0200f2a:	e852                	sd	s4,16(sp)
ffffffffc0200f2c:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200f2e:	550000ef          	jal	ra,ffffffffc020147e <kmalloc>
    if (mm != NULL)
ffffffffc0200f32:	2e050f63          	beqz	a0,ffffffffc0201230 <vmm_init+0x316>
ffffffffc0200f36:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0200f38:	e508                	sd	a0,8(a0)
ffffffffc0200f3a:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0200f3c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200f40:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200f44:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0200f48:	02053423          	sd	zero,40(a0)
ffffffffc0200f4c:	03200413          	li	s0,50
ffffffffc0200f50:	a811                	j	ffffffffc0200f64 <vmm_init+0x4a>
        vma->vm_start = vm_start;
ffffffffc0200f52:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200f54:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200f56:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0200f5a:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0200f5c:	8526                	mv	a0,s1
ffffffffc0200f5e:	eedff0ef          	jal	ra,ffffffffc0200e4a <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0200f62:	c80d                	beqz	s0,ffffffffc0200f94 <vmm_init+0x7a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200f64:	03000513          	li	a0,48
ffffffffc0200f68:	516000ef          	jal	ra,ffffffffc020147e <kmalloc>
ffffffffc0200f6c:	85aa                	mv	a1,a0
ffffffffc0200f6e:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0200f72:	f165                	bnez	a0,ffffffffc0200f52 <vmm_init+0x38>
        assert(vma != NULL);
ffffffffc0200f74:	00004697          	auipc	a3,0x4
ffffffffc0200f78:	bac68693          	addi	a3,a3,-1108 # ffffffffc0204b20 <commands+0xa08>
ffffffffc0200f7c:	00004617          	auipc	a2,0x4
ffffffffc0200f80:	9a460613          	addi	a2,a2,-1628 # ffffffffc0204920 <commands+0x808>
ffffffffc0200f84:	0da00593          	li	a1,218
ffffffffc0200f88:	00004517          	auipc	a0,0x4
ffffffffc0200f8c:	9b050513          	addi	a0,a0,-1616 # ffffffffc0204938 <commands+0x820>
ffffffffc0200f90:	a4eff0ef          	jal	ra,ffffffffc02001de <__panic>
ffffffffc0200f94:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0200f98:	1f900913          	li	s2,505
ffffffffc0200f9c:	a819                	j	ffffffffc0200fb2 <vmm_init+0x98>
        vma->vm_start = vm_start;
ffffffffc0200f9e:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200fa0:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200fa2:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0200fa6:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0200fa8:	8526                	mv	a0,s1
ffffffffc0200faa:	ea1ff0ef          	jal	ra,ffffffffc0200e4a <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0200fae:	03240a63          	beq	s0,s2,ffffffffc0200fe2 <vmm_init+0xc8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200fb2:	03000513          	li	a0,48
ffffffffc0200fb6:	4c8000ef          	jal	ra,ffffffffc020147e <kmalloc>
ffffffffc0200fba:	85aa                	mv	a1,a0
ffffffffc0200fbc:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0200fc0:	fd79                	bnez	a0,ffffffffc0200f9e <vmm_init+0x84>
        assert(vma != NULL);
ffffffffc0200fc2:	00004697          	auipc	a3,0x4
ffffffffc0200fc6:	b5e68693          	addi	a3,a3,-1186 # ffffffffc0204b20 <commands+0xa08>
ffffffffc0200fca:	00004617          	auipc	a2,0x4
ffffffffc0200fce:	95660613          	addi	a2,a2,-1706 # ffffffffc0204920 <commands+0x808>
ffffffffc0200fd2:	0e100593          	li	a1,225
ffffffffc0200fd6:	00004517          	auipc	a0,0x4
ffffffffc0200fda:	96250513          	addi	a0,a0,-1694 # ffffffffc0204938 <commands+0x820>
ffffffffc0200fde:	a00ff0ef          	jal	ra,ffffffffc02001de <__panic>
    return listelm->next;
ffffffffc0200fe2:	649c                	ld	a5,8(s1)
ffffffffc0200fe4:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0200fe6:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0200fea:	18f48363          	beq	s1,a5,ffffffffc0201170 <vmm_init+0x256>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0200fee:	fe87b603          	ld	a2,-24(a5)
ffffffffc0200ff2:	ffe70693          	addi	a3,a4,-2
ffffffffc0200ff6:	10d61d63          	bne	a2,a3,ffffffffc0201110 <vmm_init+0x1f6>
ffffffffc0200ffa:	ff07b683          	ld	a3,-16(a5)
ffffffffc0200ffe:	10e69963          	bne	a3,a4,ffffffffc0201110 <vmm_init+0x1f6>
    for (i = 1; i <= step2; i++)
ffffffffc0201002:	0715                	addi	a4,a4,5
ffffffffc0201004:	679c                	ld	a5,8(a5)
ffffffffc0201006:	feb712e3          	bne	a4,a1,ffffffffc0200fea <vmm_init+0xd0>
ffffffffc020100a:	4a1d                	li	s4,7
ffffffffc020100c:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc020100e:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0201012:	85a2                	mv	a1,s0
ffffffffc0201014:	8526                	mv	a0,s1
ffffffffc0201016:	df5ff0ef          	jal	ra,ffffffffc0200e0a <find_vma>
ffffffffc020101a:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc020101c:	18050a63          	beqz	a0,ffffffffc02011b0 <vmm_init+0x296>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0201020:	00140593          	addi	a1,s0,1
ffffffffc0201024:	8526                	mv	a0,s1
ffffffffc0201026:	de5ff0ef          	jal	ra,ffffffffc0200e0a <find_vma>
ffffffffc020102a:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc020102c:	16050263          	beqz	a0,ffffffffc0201190 <vmm_init+0x276>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0201030:	85d2                	mv	a1,s4
ffffffffc0201032:	8526                	mv	a0,s1
ffffffffc0201034:	dd7ff0ef          	jal	ra,ffffffffc0200e0a <find_vma>
        assert(vma3 == NULL);
ffffffffc0201038:	18051c63          	bnez	a0,ffffffffc02011d0 <vmm_init+0x2b6>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc020103c:	00340593          	addi	a1,s0,3
ffffffffc0201040:	8526                	mv	a0,s1
ffffffffc0201042:	dc9ff0ef          	jal	ra,ffffffffc0200e0a <find_vma>
        assert(vma4 == NULL);
ffffffffc0201046:	1c051563          	bnez	a0,ffffffffc0201210 <vmm_init+0x2f6>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc020104a:	00440593          	addi	a1,s0,4
ffffffffc020104e:	8526                	mv	a0,s1
ffffffffc0201050:	dbbff0ef          	jal	ra,ffffffffc0200e0a <find_vma>
        assert(vma5 == NULL);
ffffffffc0201054:	18051e63          	bnez	a0,ffffffffc02011f0 <vmm_init+0x2d6>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0201058:	00893783          	ld	a5,8(s2)
ffffffffc020105c:	0c879a63          	bne	a5,s0,ffffffffc0201130 <vmm_init+0x216>
ffffffffc0201060:	01093783          	ld	a5,16(s2)
ffffffffc0201064:	0d479663          	bne	a5,s4,ffffffffc0201130 <vmm_init+0x216>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0201068:	0089b783          	ld	a5,8(s3)
ffffffffc020106c:	0e879263          	bne	a5,s0,ffffffffc0201150 <vmm_init+0x236>
ffffffffc0201070:	0109b783          	ld	a5,16(s3)
ffffffffc0201074:	0d479e63          	bne	a5,s4,ffffffffc0201150 <vmm_init+0x236>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0201078:	0415                	addi	s0,s0,5
ffffffffc020107a:	0a15                	addi	s4,s4,5
ffffffffc020107c:	f9541be3          	bne	s0,s5,ffffffffc0201012 <vmm_init+0xf8>
ffffffffc0201080:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0201082:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0201084:	85a2                	mv	a1,s0
ffffffffc0201086:	8526                	mv	a0,s1
ffffffffc0201088:	d83ff0ef          	jal	ra,ffffffffc0200e0a <find_vma>
ffffffffc020108c:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0201090:	c90d                	beqz	a0,ffffffffc02010c2 <vmm_init+0x1a8>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0201092:	6914                	ld	a3,16(a0)
ffffffffc0201094:	6510                	ld	a2,8(a0)
ffffffffc0201096:	00004517          	auipc	a0,0x4
ffffffffc020109a:	a1250513          	addi	a0,a0,-1518 # ffffffffc0204aa8 <commands+0x990>
ffffffffc020109e:	842ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc02010a2:	00004697          	auipc	a3,0x4
ffffffffc02010a6:	a2e68693          	addi	a3,a3,-1490 # ffffffffc0204ad0 <commands+0x9b8>
ffffffffc02010aa:	00004617          	auipc	a2,0x4
ffffffffc02010ae:	87660613          	addi	a2,a2,-1930 # ffffffffc0204920 <commands+0x808>
ffffffffc02010b2:	10700593          	li	a1,263
ffffffffc02010b6:	00004517          	auipc	a0,0x4
ffffffffc02010ba:	88250513          	addi	a0,a0,-1918 # ffffffffc0204938 <commands+0x820>
ffffffffc02010be:	920ff0ef          	jal	ra,ffffffffc02001de <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc02010c2:	147d                	addi	s0,s0,-1
ffffffffc02010c4:	fd2410e3          	bne	s0,s2,ffffffffc0201084 <vmm_init+0x16a>
ffffffffc02010c8:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc02010ca:	00a48c63          	beq	s1,a0,ffffffffc02010e2 <vmm_init+0x1c8>
    __list_del(listelm->prev, listelm->next);
ffffffffc02010ce:	6118                	ld	a4,0(a0)
ffffffffc02010d0:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02010d2:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02010d4:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02010d6:	e398                	sd	a4,0(a5)
ffffffffc02010d8:	456000ef          	jal	ra,ffffffffc020152e <kfree>
    return listelm->next;
ffffffffc02010dc:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc02010de:	fea498e3          	bne	s1,a0,ffffffffc02010ce <vmm_init+0x1b4>
    kfree(mm); // kfree mm
ffffffffc02010e2:	8526                	mv	a0,s1
ffffffffc02010e4:	44a000ef          	jal	ra,ffffffffc020152e <kfree>
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02010e8:	00004517          	auipc	a0,0x4
ffffffffc02010ec:	a0050513          	addi	a0,a0,-1536 # ffffffffc0204ae8 <commands+0x9d0>
ffffffffc02010f0:	ff1fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc02010f4:	7442                	ld	s0,48(sp)
ffffffffc02010f6:	70e2                	ld	ra,56(sp)
ffffffffc02010f8:	74a2                	ld	s1,40(sp)
ffffffffc02010fa:	7902                	ld	s2,32(sp)
ffffffffc02010fc:	69e2                	ld	s3,24(sp)
ffffffffc02010fe:	6a42                	ld	s4,16(sp)
ffffffffc0201100:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0201102:	00004517          	auipc	a0,0x4
ffffffffc0201106:	a0650513          	addi	a0,a0,-1530 # ffffffffc0204b08 <commands+0x9f0>
}
ffffffffc020110a:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc020110c:	fd5fe06f          	j	ffffffffc02000e0 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201110:	00004697          	auipc	a3,0x4
ffffffffc0201114:	8b068693          	addi	a3,a3,-1872 # ffffffffc02049c0 <commands+0x8a8>
ffffffffc0201118:	00004617          	auipc	a2,0x4
ffffffffc020111c:	80860613          	addi	a2,a2,-2040 # ffffffffc0204920 <commands+0x808>
ffffffffc0201120:	0eb00593          	li	a1,235
ffffffffc0201124:	00004517          	auipc	a0,0x4
ffffffffc0201128:	81450513          	addi	a0,a0,-2028 # ffffffffc0204938 <commands+0x820>
ffffffffc020112c:	8b2ff0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0201130:	00004697          	auipc	a3,0x4
ffffffffc0201134:	91868693          	addi	a3,a3,-1768 # ffffffffc0204a48 <commands+0x930>
ffffffffc0201138:	00003617          	auipc	a2,0x3
ffffffffc020113c:	7e860613          	addi	a2,a2,2024 # ffffffffc0204920 <commands+0x808>
ffffffffc0201140:	0fc00593          	li	a1,252
ffffffffc0201144:	00003517          	auipc	a0,0x3
ffffffffc0201148:	7f450513          	addi	a0,a0,2036 # ffffffffc0204938 <commands+0x820>
ffffffffc020114c:	892ff0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0201150:	00004697          	auipc	a3,0x4
ffffffffc0201154:	92868693          	addi	a3,a3,-1752 # ffffffffc0204a78 <commands+0x960>
ffffffffc0201158:	00003617          	auipc	a2,0x3
ffffffffc020115c:	7c860613          	addi	a2,a2,1992 # ffffffffc0204920 <commands+0x808>
ffffffffc0201160:	0fd00593          	li	a1,253
ffffffffc0201164:	00003517          	auipc	a0,0x3
ffffffffc0201168:	7d450513          	addi	a0,a0,2004 # ffffffffc0204938 <commands+0x820>
ffffffffc020116c:	872ff0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0201170:	00004697          	auipc	a3,0x4
ffffffffc0201174:	83868693          	addi	a3,a3,-1992 # ffffffffc02049a8 <commands+0x890>
ffffffffc0201178:	00003617          	auipc	a2,0x3
ffffffffc020117c:	7a860613          	addi	a2,a2,1960 # ffffffffc0204920 <commands+0x808>
ffffffffc0201180:	0e900593          	li	a1,233
ffffffffc0201184:	00003517          	auipc	a0,0x3
ffffffffc0201188:	7b450513          	addi	a0,a0,1972 # ffffffffc0204938 <commands+0x820>
ffffffffc020118c:	852ff0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma2 != NULL);
ffffffffc0201190:	00004697          	auipc	a3,0x4
ffffffffc0201194:	87868693          	addi	a3,a3,-1928 # ffffffffc0204a08 <commands+0x8f0>
ffffffffc0201198:	00003617          	auipc	a2,0x3
ffffffffc020119c:	78860613          	addi	a2,a2,1928 # ffffffffc0204920 <commands+0x808>
ffffffffc02011a0:	0f400593          	li	a1,244
ffffffffc02011a4:	00003517          	auipc	a0,0x3
ffffffffc02011a8:	79450513          	addi	a0,a0,1940 # ffffffffc0204938 <commands+0x820>
ffffffffc02011ac:	832ff0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma1 != NULL);
ffffffffc02011b0:	00004697          	auipc	a3,0x4
ffffffffc02011b4:	84868693          	addi	a3,a3,-1976 # ffffffffc02049f8 <commands+0x8e0>
ffffffffc02011b8:	00003617          	auipc	a2,0x3
ffffffffc02011bc:	76860613          	addi	a2,a2,1896 # ffffffffc0204920 <commands+0x808>
ffffffffc02011c0:	0f200593          	li	a1,242
ffffffffc02011c4:	00003517          	auipc	a0,0x3
ffffffffc02011c8:	77450513          	addi	a0,a0,1908 # ffffffffc0204938 <commands+0x820>
ffffffffc02011cc:	812ff0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma3 == NULL);
ffffffffc02011d0:	00004697          	auipc	a3,0x4
ffffffffc02011d4:	84868693          	addi	a3,a3,-1976 # ffffffffc0204a18 <commands+0x900>
ffffffffc02011d8:	00003617          	auipc	a2,0x3
ffffffffc02011dc:	74860613          	addi	a2,a2,1864 # ffffffffc0204920 <commands+0x808>
ffffffffc02011e0:	0f600593          	li	a1,246
ffffffffc02011e4:	00003517          	auipc	a0,0x3
ffffffffc02011e8:	75450513          	addi	a0,a0,1876 # ffffffffc0204938 <commands+0x820>
ffffffffc02011ec:	ff3fe0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma5 == NULL);
ffffffffc02011f0:	00004697          	auipc	a3,0x4
ffffffffc02011f4:	84868693          	addi	a3,a3,-1976 # ffffffffc0204a38 <commands+0x920>
ffffffffc02011f8:	00003617          	auipc	a2,0x3
ffffffffc02011fc:	72860613          	addi	a2,a2,1832 # ffffffffc0204920 <commands+0x808>
ffffffffc0201200:	0fa00593          	li	a1,250
ffffffffc0201204:	00003517          	auipc	a0,0x3
ffffffffc0201208:	73450513          	addi	a0,a0,1844 # ffffffffc0204938 <commands+0x820>
ffffffffc020120c:	fd3fe0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma4 == NULL);
ffffffffc0201210:	00004697          	auipc	a3,0x4
ffffffffc0201214:	81868693          	addi	a3,a3,-2024 # ffffffffc0204a28 <commands+0x910>
ffffffffc0201218:	00003617          	auipc	a2,0x3
ffffffffc020121c:	70860613          	addi	a2,a2,1800 # ffffffffc0204920 <commands+0x808>
ffffffffc0201220:	0f800593          	li	a1,248
ffffffffc0201224:	00003517          	auipc	a0,0x3
ffffffffc0201228:	71450513          	addi	a0,a0,1812 # ffffffffc0204938 <commands+0x820>
ffffffffc020122c:	fb3fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(mm != NULL);
ffffffffc0201230:	00004697          	auipc	a3,0x4
ffffffffc0201234:	90068693          	addi	a3,a3,-1792 # ffffffffc0204b30 <commands+0xa18>
ffffffffc0201238:	00003617          	auipc	a2,0x3
ffffffffc020123c:	6e860613          	addi	a2,a2,1768 # ffffffffc0204920 <commands+0x808>
ffffffffc0201240:	0d200593          	li	a1,210
ffffffffc0201244:	00003517          	auipc	a0,0x3
ffffffffc0201248:	6f450513          	addi	a0,a0,1780 # ffffffffc0204938 <commands+0x820>
ffffffffc020124c:	f93fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201250 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201250:	c94d                	beqz	a0,ffffffffc0201302 <slob_free+0xb2>
{
ffffffffc0201252:	1141                	addi	sp,sp,-16
ffffffffc0201254:	e022                	sd	s0,0(sp)
ffffffffc0201256:	e406                	sd	ra,8(sp)
ffffffffc0201258:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc020125a:	e9c1                	bnez	a1,ffffffffc02012ea <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020125c:	100027f3          	csrr	a5,sstatus
ffffffffc0201260:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201262:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201264:	ebd9                	bnez	a5,ffffffffc02012fa <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201266:	00008617          	auipc	a2,0x8
ffffffffc020126a:	dba60613          	addi	a2,a2,-582 # ffffffffc0209020 <slobfree>
ffffffffc020126e:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201270:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201272:	679c                	ld	a5,8(a5)
ffffffffc0201274:	02877a63          	bgeu	a4,s0,ffffffffc02012a8 <slob_free+0x58>
ffffffffc0201278:	00f46463          	bltu	s0,a5,ffffffffc0201280 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020127c:	fef76ae3          	bltu	a4,a5,ffffffffc0201270 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201280:	400c                	lw	a1,0(s0)
ffffffffc0201282:	00459693          	slli	a3,a1,0x4
ffffffffc0201286:	96a2                	add	a3,a3,s0
ffffffffc0201288:	02d78a63          	beq	a5,a3,ffffffffc02012bc <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc020128c:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc020128e:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201290:	00469793          	slli	a5,a3,0x4
ffffffffc0201294:	97ba                	add	a5,a5,a4
ffffffffc0201296:	02f40e63          	beq	s0,a5,ffffffffc02012d2 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc020129a:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc020129c:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc020129e:	e129                	bnez	a0,ffffffffc02012e0 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02012a0:	60a2                	ld	ra,8(sp)
ffffffffc02012a2:	6402                	ld	s0,0(sp)
ffffffffc02012a4:	0141                	addi	sp,sp,16
ffffffffc02012a6:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02012a8:	fcf764e3          	bltu	a4,a5,ffffffffc0201270 <slob_free+0x20>
ffffffffc02012ac:	fcf472e3          	bgeu	s0,a5,ffffffffc0201270 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc02012b0:	400c                	lw	a1,0(s0)
ffffffffc02012b2:	00459693          	slli	a3,a1,0x4
ffffffffc02012b6:	96a2                	add	a3,a3,s0
ffffffffc02012b8:	fcd79ae3          	bne	a5,a3,ffffffffc020128c <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc02012bc:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02012be:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02012c0:	9db5                	addw	a1,a1,a3
ffffffffc02012c2:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc02012c4:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02012c6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02012c8:	00469793          	slli	a5,a3,0x4
ffffffffc02012cc:	97ba                	add	a5,a5,a4
ffffffffc02012ce:	fcf416e3          	bne	s0,a5,ffffffffc020129a <slob_free+0x4a>
		cur->units += b->units;
ffffffffc02012d2:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc02012d4:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc02012d6:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc02012d8:	9ebd                	addw	a3,a3,a5
ffffffffc02012da:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc02012dc:	e70c                	sd	a1,8(a4)
ffffffffc02012de:	d169                	beqz	a0,ffffffffc02012a0 <slob_free+0x50>
}
ffffffffc02012e0:	6402                	ld	s0,0(sp)
ffffffffc02012e2:	60a2                	ld	ra,8(sp)
ffffffffc02012e4:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02012e6:	e4aff06f          	j	ffffffffc0200930 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc02012ea:	25bd                	addiw	a1,a1,15
ffffffffc02012ec:	8191                	srli	a1,a1,0x4
ffffffffc02012ee:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02012f0:	100027f3          	csrr	a5,sstatus
ffffffffc02012f4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02012f6:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02012f8:	d7bd                	beqz	a5,ffffffffc0201266 <slob_free+0x16>
        intr_disable();
ffffffffc02012fa:	e3cff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc02012fe:	4505                	li	a0,1
ffffffffc0201300:	b79d                	j	ffffffffc0201266 <slob_free+0x16>
ffffffffc0201302:	8082                	ret

ffffffffc0201304 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201304:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201306:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201308:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020130c:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc020130e:	5fd000ef          	jal	ra,ffffffffc020210a <alloc_pages>
	if (!page)
ffffffffc0201312:	c91d                	beqz	a0,ffffffffc0201348 <__slob_get_free_pages.constprop.0+0x44>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201314:	0000c697          	auipc	a3,0xc
ffffffffc0201318:	19c6b683          	ld	a3,412(a3) # ffffffffc020d4b0 <pages>
ffffffffc020131c:	8d15                	sub	a0,a0,a3
ffffffffc020131e:	8519                	srai	a0,a0,0x6
ffffffffc0201320:	00004697          	auipc	a3,0x4
ffffffffc0201324:	6b86b683          	ld	a3,1720(a3) # ffffffffc02059d8 <nbase>
ffffffffc0201328:	9536                	add	a0,a0,a3
}

static inline void *
page2kva(struct Page *page)
{
    return KADDR(page2pa(page));
ffffffffc020132a:	00c51793          	slli	a5,a0,0xc
ffffffffc020132e:	83b1                	srli	a5,a5,0xc
ffffffffc0201330:	0000c717          	auipc	a4,0xc
ffffffffc0201334:	17873703          	ld	a4,376(a4) # ffffffffc020d4a8 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201338:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020133a:	00e7fa63          	bgeu	a5,a4,ffffffffc020134e <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc020133e:	0000c697          	auipc	a3,0xc
ffffffffc0201342:	1826b683          	ld	a3,386(a3) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201346:	9536                	add	a0,a0,a3
}
ffffffffc0201348:	60a2                	ld	ra,8(sp)
ffffffffc020134a:	0141                	addi	sp,sp,16
ffffffffc020134c:	8082                	ret
ffffffffc020134e:	86aa                	mv	a3,a0
ffffffffc0201350:	00003617          	auipc	a2,0x3
ffffffffc0201354:	7f060613          	addi	a2,a2,2032 # ffffffffc0204b40 <commands+0xa28>
ffffffffc0201358:	07100593          	li	a1,113
ffffffffc020135c:	00004517          	auipc	a0,0x4
ffffffffc0201360:	80c50513          	addi	a0,a0,-2036 # ffffffffc0204b68 <commands+0xa50>
ffffffffc0201364:	e7bfe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201368 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201368:	1101                	addi	sp,sp,-32
ffffffffc020136a:	ec06                	sd	ra,24(sp)
ffffffffc020136c:	e822                	sd	s0,16(sp)
ffffffffc020136e:	e426                	sd	s1,8(sp)
ffffffffc0201370:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201372:	01050713          	addi	a4,a0,16
ffffffffc0201376:	6785                	lui	a5,0x1
ffffffffc0201378:	0cf77363          	bgeu	a4,a5,ffffffffc020143e <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc020137c:	00f50493          	addi	s1,a0,15
ffffffffc0201380:	8091                	srli	s1,s1,0x4
ffffffffc0201382:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201384:	10002673          	csrr	a2,sstatus
ffffffffc0201388:	8a09                	andi	a2,a2,2
ffffffffc020138a:	e25d                	bnez	a2,ffffffffc0201430 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc020138c:	00008917          	auipc	s2,0x8
ffffffffc0201390:	c9490913          	addi	s2,s2,-876 # ffffffffc0209020 <slobfree>
ffffffffc0201394:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201398:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc020139a:	4398                	lw	a4,0(a5)
ffffffffc020139c:	08975e63          	bge	a4,s1,ffffffffc0201438 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc02013a0:	00d78b63          	beq	a5,a3,ffffffffc02013b6 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02013a4:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02013a6:	4018                	lw	a4,0(s0)
ffffffffc02013a8:	02975a63          	bge	a4,s1,ffffffffc02013dc <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc02013ac:	00093683          	ld	a3,0(s2)
ffffffffc02013b0:	87a2                	mv	a5,s0
ffffffffc02013b2:	fed799e3          	bne	a5,a3,ffffffffc02013a4 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc02013b6:	ee31                	bnez	a2,ffffffffc0201412 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc02013b8:	4501                	li	a0,0
ffffffffc02013ba:	f4bff0ef          	jal	ra,ffffffffc0201304 <__slob_get_free_pages.constprop.0>
ffffffffc02013be:	842a                	mv	s0,a0
			if (!cur)
ffffffffc02013c0:	cd05                	beqz	a0,ffffffffc02013f8 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc02013c2:	6585                	lui	a1,0x1
ffffffffc02013c4:	e8dff0ef          	jal	ra,ffffffffc0201250 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02013c8:	10002673          	csrr	a2,sstatus
ffffffffc02013cc:	8a09                	andi	a2,a2,2
ffffffffc02013ce:	ee05                	bnez	a2,ffffffffc0201406 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc02013d0:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02013d4:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02013d6:	4018                	lw	a4,0(s0)
ffffffffc02013d8:	fc974ae3          	blt	a4,s1,ffffffffc02013ac <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc02013dc:	04e48763          	beq	s1,a4,ffffffffc020142a <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc02013e0:	00449693          	slli	a3,s1,0x4
ffffffffc02013e4:	96a2                	add	a3,a3,s0
ffffffffc02013e6:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc02013e8:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc02013ea:	9f05                	subw	a4,a4,s1
ffffffffc02013ec:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc02013ee:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc02013f0:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc02013f2:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc02013f6:	e20d                	bnez	a2,ffffffffc0201418 <slob_alloc.constprop.0+0xb0>
}
ffffffffc02013f8:	60e2                	ld	ra,24(sp)
ffffffffc02013fa:	8522                	mv	a0,s0
ffffffffc02013fc:	6442                	ld	s0,16(sp)
ffffffffc02013fe:	64a2                	ld	s1,8(sp)
ffffffffc0201400:	6902                	ld	s2,0(sp)
ffffffffc0201402:	6105                	addi	sp,sp,32
ffffffffc0201404:	8082                	ret
        intr_disable();
ffffffffc0201406:	d30ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
			cur = slobfree;
ffffffffc020140a:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc020140e:	4605                	li	a2,1
ffffffffc0201410:	b7d1                	j	ffffffffc02013d4 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201412:	d1eff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0201416:	b74d                	j	ffffffffc02013b8 <slob_alloc.constprop.0+0x50>
ffffffffc0201418:	d18ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
}
ffffffffc020141c:	60e2                	ld	ra,24(sp)
ffffffffc020141e:	8522                	mv	a0,s0
ffffffffc0201420:	6442                	ld	s0,16(sp)
ffffffffc0201422:	64a2                	ld	s1,8(sp)
ffffffffc0201424:	6902                	ld	s2,0(sp)
ffffffffc0201426:	6105                	addi	sp,sp,32
ffffffffc0201428:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc020142a:	6418                	ld	a4,8(s0)
ffffffffc020142c:	e798                	sd	a4,8(a5)
ffffffffc020142e:	b7d1                	j	ffffffffc02013f2 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201430:	d06ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc0201434:	4605                	li	a2,1
ffffffffc0201436:	bf99                	j	ffffffffc020138c <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201438:	843e                	mv	s0,a5
ffffffffc020143a:	87b6                	mv	a5,a3
ffffffffc020143c:	b745                	j	ffffffffc02013dc <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020143e:	00003697          	auipc	a3,0x3
ffffffffc0201442:	73a68693          	addi	a3,a3,1850 # ffffffffc0204b78 <commands+0xa60>
ffffffffc0201446:	00003617          	auipc	a2,0x3
ffffffffc020144a:	4da60613          	addi	a2,a2,1242 # ffffffffc0204920 <commands+0x808>
ffffffffc020144e:	06300593          	li	a1,99
ffffffffc0201452:	00003517          	auipc	a0,0x3
ffffffffc0201456:	74650513          	addi	a0,a0,1862 # ffffffffc0204b98 <commands+0xa80>
ffffffffc020145a:	d85fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020145e <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc020145e:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201460:	00003517          	auipc	a0,0x3
ffffffffc0201464:	75050513          	addi	a0,a0,1872 # ffffffffc0204bb0 <commands+0xa98>
{
ffffffffc0201468:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc020146a:	c77fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc020146e:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201470:	00003517          	auipc	a0,0x3
ffffffffc0201474:	75850513          	addi	a0,a0,1880 # ffffffffc0204bc8 <commands+0xab0>
}
ffffffffc0201478:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc020147a:	c67fe06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc020147e <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc020147e:	1101                	addi	sp,sp,-32
ffffffffc0201480:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201482:	6905                	lui	s2,0x1
{
ffffffffc0201484:	e822                	sd	s0,16(sp)
ffffffffc0201486:	ec06                	sd	ra,24(sp)
ffffffffc0201488:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc020148a:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
{
ffffffffc020148e:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201490:	04a7f963          	bgeu	a5,a0,ffffffffc02014e2 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201494:	4561                	li	a0,24
ffffffffc0201496:	ed3ff0ef          	jal	ra,ffffffffc0201368 <slob_alloc.constprop.0>
ffffffffc020149a:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc020149c:	c929                	beqz	a0,ffffffffc02014ee <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc020149e:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc02014a2:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc02014a4:	00f95763          	bge	s2,a5,ffffffffc02014b2 <kmalloc+0x34>
ffffffffc02014a8:	6705                	lui	a4,0x1
ffffffffc02014aa:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc02014ac:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc02014ae:	fef74ee3          	blt	a4,a5,ffffffffc02014aa <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc02014b2:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc02014b4:	e51ff0ef          	jal	ra,ffffffffc0201304 <__slob_get_free_pages.constprop.0>
ffffffffc02014b8:	e488                	sd	a0,8(s1)
ffffffffc02014ba:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc02014bc:	c525                	beqz	a0,ffffffffc0201524 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02014be:	100027f3          	csrr	a5,sstatus
ffffffffc02014c2:	8b89                	andi	a5,a5,2
ffffffffc02014c4:	ef8d                	bnez	a5,ffffffffc02014fe <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc02014c6:	0000c797          	auipc	a5,0xc
ffffffffc02014ca:	fca78793          	addi	a5,a5,-54 # ffffffffc020d490 <bigblocks>
ffffffffc02014ce:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02014d0:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02014d2:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc02014d4:	60e2                	ld	ra,24(sp)
ffffffffc02014d6:	8522                	mv	a0,s0
ffffffffc02014d8:	6442                	ld	s0,16(sp)
ffffffffc02014da:	64a2                	ld	s1,8(sp)
ffffffffc02014dc:	6902                	ld	s2,0(sp)
ffffffffc02014de:	6105                	addi	sp,sp,32
ffffffffc02014e0:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc02014e2:	0541                	addi	a0,a0,16
ffffffffc02014e4:	e85ff0ef          	jal	ra,ffffffffc0201368 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc02014e8:	01050413          	addi	s0,a0,16
ffffffffc02014ec:	f565                	bnez	a0,ffffffffc02014d4 <kmalloc+0x56>
ffffffffc02014ee:	4401                	li	s0,0
}
ffffffffc02014f0:	60e2                	ld	ra,24(sp)
ffffffffc02014f2:	8522                	mv	a0,s0
ffffffffc02014f4:	6442                	ld	s0,16(sp)
ffffffffc02014f6:	64a2                	ld	s1,8(sp)
ffffffffc02014f8:	6902                	ld	s2,0(sp)
ffffffffc02014fa:	6105                	addi	sp,sp,32
ffffffffc02014fc:	8082                	ret
        intr_disable();
ffffffffc02014fe:	c38ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201502:	0000c797          	auipc	a5,0xc
ffffffffc0201506:	f8e78793          	addi	a5,a5,-114 # ffffffffc020d490 <bigblocks>
ffffffffc020150a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc020150c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc020150e:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201510:	c20ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
		return bb->pages;
ffffffffc0201514:	6480                	ld	s0,8(s1)
}
ffffffffc0201516:	60e2                	ld	ra,24(sp)
ffffffffc0201518:	64a2                	ld	s1,8(sp)
ffffffffc020151a:	8522                	mv	a0,s0
ffffffffc020151c:	6442                	ld	s0,16(sp)
ffffffffc020151e:	6902                	ld	s2,0(sp)
ffffffffc0201520:	6105                	addi	sp,sp,32
ffffffffc0201522:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201524:	45e1                	li	a1,24
ffffffffc0201526:	8526                	mv	a0,s1
ffffffffc0201528:	d29ff0ef          	jal	ra,ffffffffc0201250 <slob_free>
	return __kmalloc(size, 0);
ffffffffc020152c:	b765                	j	ffffffffc02014d4 <kmalloc+0x56>

ffffffffc020152e <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc020152e:	c169                	beqz	a0,ffffffffc02015f0 <kfree+0xc2>
{
ffffffffc0201530:	1101                	addi	sp,sp,-32
ffffffffc0201532:	e822                	sd	s0,16(sp)
ffffffffc0201534:	ec06                	sd	ra,24(sp)
ffffffffc0201536:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201538:	03451793          	slli	a5,a0,0x34
ffffffffc020153c:	842a                	mv	s0,a0
ffffffffc020153e:	e3d9                	bnez	a5,ffffffffc02015c4 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201540:	100027f3          	csrr	a5,sstatus
ffffffffc0201544:	8b89                	andi	a5,a5,2
ffffffffc0201546:	e7d9                	bnez	a5,ffffffffc02015d4 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201548:	0000c797          	auipc	a5,0xc
ffffffffc020154c:	f487b783          	ld	a5,-184(a5) # ffffffffc020d490 <bigblocks>
    return 0;
ffffffffc0201550:	4601                	li	a2,0
ffffffffc0201552:	cbad                	beqz	a5,ffffffffc02015c4 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201554:	0000c697          	auipc	a3,0xc
ffffffffc0201558:	f3c68693          	addi	a3,a3,-196 # ffffffffc020d490 <bigblocks>
ffffffffc020155c:	a021                	j	ffffffffc0201564 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc020155e:	01048693          	addi	a3,s1,16
ffffffffc0201562:	c3a5                	beqz	a5,ffffffffc02015c2 <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201564:	6798                	ld	a4,8(a5)
ffffffffc0201566:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201568:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc020156a:	fe871ae3          	bne	a4,s0,ffffffffc020155e <kfree+0x30>
				*last = bb->next;
ffffffffc020156e:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201570:	ee2d                	bnez	a2,ffffffffc02015ea <kfree+0xbc>
}

static inline struct Page *
kva2page(void *kva)
{
    return pa2page(PADDR(kva));
ffffffffc0201572:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201576:	4098                	lw	a4,0(s1)
ffffffffc0201578:	08f46963          	bltu	s0,a5,ffffffffc020160a <kfree+0xdc>
ffffffffc020157c:	0000c697          	auipc	a3,0xc
ffffffffc0201580:	f446b683          	ld	a3,-188(a3) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0201584:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201586:	8031                	srli	s0,s0,0xc
ffffffffc0201588:	0000c797          	auipc	a5,0xc
ffffffffc020158c:	f207b783          	ld	a5,-224(a5) # ffffffffc020d4a8 <npage>
ffffffffc0201590:	06f47163          	bgeu	s0,a5,ffffffffc02015f2 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201594:	00004517          	auipc	a0,0x4
ffffffffc0201598:	44453503          	ld	a0,1092(a0) # ffffffffc02059d8 <nbase>
ffffffffc020159c:	8c09                	sub	s0,s0,a0
ffffffffc020159e:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc02015a0:	0000c517          	auipc	a0,0xc
ffffffffc02015a4:	f1053503          	ld	a0,-240(a0) # ffffffffc020d4b0 <pages>
ffffffffc02015a8:	4585                	li	a1,1
ffffffffc02015aa:	9522                	add	a0,a0,s0
ffffffffc02015ac:	00e595bb          	sllw	a1,a1,a4
ffffffffc02015b0:	399000ef          	jal	ra,ffffffffc0202148 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc02015b4:	6442                	ld	s0,16(sp)
ffffffffc02015b6:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02015b8:	8526                	mv	a0,s1
}
ffffffffc02015ba:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02015bc:	45e1                	li	a1,24
}
ffffffffc02015be:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02015c0:	b941                	j	ffffffffc0201250 <slob_free>
ffffffffc02015c2:	e20d                	bnez	a2,ffffffffc02015e4 <kfree+0xb6>
ffffffffc02015c4:	ff040513          	addi	a0,s0,-16
}
ffffffffc02015c8:	6442                	ld	s0,16(sp)
ffffffffc02015ca:	60e2                	ld	ra,24(sp)
ffffffffc02015cc:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02015ce:	4581                	li	a1,0
}
ffffffffc02015d0:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02015d2:	b9bd                	j	ffffffffc0201250 <slob_free>
        intr_disable();
ffffffffc02015d4:	b62ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc02015d8:	0000c797          	auipc	a5,0xc
ffffffffc02015dc:	eb87b783          	ld	a5,-328(a5) # ffffffffc020d490 <bigblocks>
        return 1;
ffffffffc02015e0:	4605                	li	a2,1
ffffffffc02015e2:	fbad                	bnez	a5,ffffffffc0201554 <kfree+0x26>
        intr_enable();
ffffffffc02015e4:	b4cff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02015e8:	bff1                	j	ffffffffc02015c4 <kfree+0x96>
ffffffffc02015ea:	b46ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02015ee:	b751                	j	ffffffffc0201572 <kfree+0x44>
ffffffffc02015f0:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02015f2:	00003617          	auipc	a2,0x3
ffffffffc02015f6:	61e60613          	addi	a2,a2,1566 # ffffffffc0204c10 <commands+0xaf8>
ffffffffc02015fa:	06900593          	li	a1,105
ffffffffc02015fe:	00003517          	auipc	a0,0x3
ffffffffc0201602:	56a50513          	addi	a0,a0,1386 # ffffffffc0204b68 <commands+0xa50>
ffffffffc0201606:	bd9fe0ef          	jal	ra,ffffffffc02001de <__panic>
    return pa2page(PADDR(kva));
ffffffffc020160a:	86a2                	mv	a3,s0
ffffffffc020160c:	00003617          	auipc	a2,0x3
ffffffffc0201610:	5dc60613          	addi	a2,a2,1500 # ffffffffc0204be8 <commands+0xad0>
ffffffffc0201614:	07700593          	li	a1,119
ffffffffc0201618:	00003517          	auipc	a0,0x3
ffffffffc020161c:	55050513          	addi	a0,a0,1360 # ffffffffc0204b68 <commands+0xa50>
ffffffffc0201620:	bbffe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201624 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201624:	00008797          	auipc	a5,0x8
ffffffffc0201628:	e0c78793          	addi	a5,a5,-500 # ffffffffc0209430 <free_area>
ffffffffc020162c:	e79c                	sd	a5,8(a5)
ffffffffc020162e:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201630:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201634:	8082                	ret

ffffffffc0201636 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201636:	00008517          	auipc	a0,0x8
ffffffffc020163a:	e0a56503          	lwu	a0,-502(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc020163e:	8082                	ret

ffffffffc0201640 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201640:	715d                	addi	sp,sp,-80
ffffffffc0201642:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201644:	00008417          	auipc	s0,0x8
ffffffffc0201648:	dec40413          	addi	s0,s0,-532 # ffffffffc0209430 <free_area>
ffffffffc020164c:	641c                	ld	a5,8(s0)
ffffffffc020164e:	e486                	sd	ra,72(sp)
ffffffffc0201650:	fc26                	sd	s1,56(sp)
ffffffffc0201652:	f84a                	sd	s2,48(sp)
ffffffffc0201654:	f44e                	sd	s3,40(sp)
ffffffffc0201656:	f052                	sd	s4,32(sp)
ffffffffc0201658:	ec56                	sd	s5,24(sp)
ffffffffc020165a:	e85a                	sd	s6,16(sp)
ffffffffc020165c:	e45e                	sd	s7,8(sp)
ffffffffc020165e:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201660:	2a878d63          	beq	a5,s0,ffffffffc020191a <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0201664:	4481                	li	s1,0
ffffffffc0201666:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201668:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc020166c:	8b09                	andi	a4,a4,2
ffffffffc020166e:	2a070a63          	beqz	a4,ffffffffc0201922 <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0201672:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201676:	679c                	ld	a5,8(a5)
ffffffffc0201678:	2905                	addiw	s2,s2,1
ffffffffc020167a:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020167c:	fe8796e3          	bne	a5,s0,ffffffffc0201668 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201680:	89a6                	mv	s3,s1
ffffffffc0201682:	307000ef          	jal	ra,ffffffffc0202188 <nr_free_pages>
ffffffffc0201686:	6f351e63          	bne	a0,s3,ffffffffc0201d82 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020168a:	4505                	li	a0,1
ffffffffc020168c:	27f000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201690:	8aaa                	mv	s5,a0
ffffffffc0201692:	42050863          	beqz	a0,ffffffffc0201ac2 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201696:	4505                	li	a0,1
ffffffffc0201698:	273000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc020169c:	89aa                	mv	s3,a0
ffffffffc020169e:	70050263          	beqz	a0,ffffffffc0201da2 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02016a2:	4505                	li	a0,1
ffffffffc02016a4:	267000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02016a8:	8a2a                	mv	s4,a0
ffffffffc02016aa:	48050c63          	beqz	a0,ffffffffc0201b42 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02016ae:	293a8a63          	beq	s5,s3,ffffffffc0201942 <default_check+0x302>
ffffffffc02016b2:	28aa8863          	beq	s5,a0,ffffffffc0201942 <default_check+0x302>
ffffffffc02016b6:	28a98663          	beq	s3,a0,ffffffffc0201942 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02016ba:	000aa783          	lw	a5,0(s5)
ffffffffc02016be:	2a079263          	bnez	a5,ffffffffc0201962 <default_check+0x322>
ffffffffc02016c2:	0009a783          	lw	a5,0(s3)
ffffffffc02016c6:	28079e63          	bnez	a5,ffffffffc0201962 <default_check+0x322>
ffffffffc02016ca:	411c                	lw	a5,0(a0)
ffffffffc02016cc:	28079b63          	bnez	a5,ffffffffc0201962 <default_check+0x322>
    return page - pages + nbase;
ffffffffc02016d0:	0000c797          	auipc	a5,0xc
ffffffffc02016d4:	de07b783          	ld	a5,-544(a5) # ffffffffc020d4b0 <pages>
ffffffffc02016d8:	40fa8733          	sub	a4,s5,a5
ffffffffc02016dc:	00004617          	auipc	a2,0x4
ffffffffc02016e0:	2fc63603          	ld	a2,764(a2) # ffffffffc02059d8 <nbase>
ffffffffc02016e4:	8719                	srai	a4,a4,0x6
ffffffffc02016e6:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02016e8:	0000c697          	auipc	a3,0xc
ffffffffc02016ec:	dc06b683          	ld	a3,-576(a3) # ffffffffc020d4a8 <npage>
ffffffffc02016f0:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02016f2:	0732                	slli	a4,a4,0xc
ffffffffc02016f4:	28d77763          	bgeu	a4,a3,ffffffffc0201982 <default_check+0x342>
    return page - pages + nbase;
ffffffffc02016f8:	40f98733          	sub	a4,s3,a5
ffffffffc02016fc:	8719                	srai	a4,a4,0x6
ffffffffc02016fe:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201700:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201702:	4cd77063          	bgeu	a4,a3,ffffffffc0201bc2 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201706:	40f507b3          	sub	a5,a0,a5
ffffffffc020170a:	8799                	srai	a5,a5,0x6
ffffffffc020170c:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020170e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201710:	30d7f963          	bgeu	a5,a3,ffffffffc0201a22 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201714:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201716:	00043c03          	ld	s8,0(s0)
ffffffffc020171a:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc020171e:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201722:	e400                	sd	s0,8(s0)
ffffffffc0201724:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201726:	00008797          	auipc	a5,0x8
ffffffffc020172a:	d007ad23          	sw	zero,-742(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc020172e:	1dd000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201732:	2c051863          	bnez	a0,ffffffffc0201a02 <default_check+0x3c2>
    free_page(p0);
ffffffffc0201736:	4585                	li	a1,1
ffffffffc0201738:	8556                	mv	a0,s5
ffffffffc020173a:	20f000ef          	jal	ra,ffffffffc0202148 <free_pages>
    free_page(p1);
ffffffffc020173e:	4585                	li	a1,1
ffffffffc0201740:	854e                	mv	a0,s3
ffffffffc0201742:	207000ef          	jal	ra,ffffffffc0202148 <free_pages>
    free_page(p2);
ffffffffc0201746:	4585                	li	a1,1
ffffffffc0201748:	8552                	mv	a0,s4
ffffffffc020174a:	1ff000ef          	jal	ra,ffffffffc0202148 <free_pages>
    assert(nr_free == 3);
ffffffffc020174e:	4818                	lw	a4,16(s0)
ffffffffc0201750:	478d                	li	a5,3
ffffffffc0201752:	28f71863          	bne	a4,a5,ffffffffc02019e2 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201756:	4505                	li	a0,1
ffffffffc0201758:	1b3000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc020175c:	89aa                	mv	s3,a0
ffffffffc020175e:	26050263          	beqz	a0,ffffffffc02019c2 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201762:	4505                	li	a0,1
ffffffffc0201764:	1a7000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201768:	8aaa                	mv	s5,a0
ffffffffc020176a:	3a050c63          	beqz	a0,ffffffffc0201b22 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020176e:	4505                	li	a0,1
ffffffffc0201770:	19b000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201774:	8a2a                	mv	s4,a0
ffffffffc0201776:	38050663          	beqz	a0,ffffffffc0201b02 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc020177a:	4505                	li	a0,1
ffffffffc020177c:	18f000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201780:	36051163          	bnez	a0,ffffffffc0201ae2 <default_check+0x4a2>
    free_page(p0);
ffffffffc0201784:	4585                	li	a1,1
ffffffffc0201786:	854e                	mv	a0,s3
ffffffffc0201788:	1c1000ef          	jal	ra,ffffffffc0202148 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020178c:	641c                	ld	a5,8(s0)
ffffffffc020178e:	20878a63          	beq	a5,s0,ffffffffc02019a2 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201792:	4505                	li	a0,1
ffffffffc0201794:	177000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201798:	30a99563          	bne	s3,a0,ffffffffc0201aa2 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc020179c:	4505                	li	a0,1
ffffffffc020179e:	16d000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02017a2:	2e051063          	bnez	a0,ffffffffc0201a82 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc02017a6:	481c                	lw	a5,16(s0)
ffffffffc02017a8:	2a079d63          	bnez	a5,ffffffffc0201a62 <default_check+0x422>
    free_page(p);
ffffffffc02017ac:	854e                	mv	a0,s3
ffffffffc02017ae:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02017b0:	01843023          	sd	s8,0(s0)
ffffffffc02017b4:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02017b8:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02017bc:	18d000ef          	jal	ra,ffffffffc0202148 <free_pages>
    free_page(p1);
ffffffffc02017c0:	4585                	li	a1,1
ffffffffc02017c2:	8556                	mv	a0,s5
ffffffffc02017c4:	185000ef          	jal	ra,ffffffffc0202148 <free_pages>
    free_page(p2);
ffffffffc02017c8:	4585                	li	a1,1
ffffffffc02017ca:	8552                	mv	a0,s4
ffffffffc02017cc:	17d000ef          	jal	ra,ffffffffc0202148 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02017d0:	4515                	li	a0,5
ffffffffc02017d2:	139000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02017d6:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02017d8:	26050563          	beqz	a0,ffffffffc0201a42 <default_check+0x402>
ffffffffc02017dc:	651c                	ld	a5,8(a0)
ffffffffc02017de:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc02017e0:	8b85                	andi	a5,a5,1
ffffffffc02017e2:	54079063          	bnez	a5,ffffffffc0201d22 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02017e6:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02017e8:	00043b03          	ld	s6,0(s0)
ffffffffc02017ec:	00843a83          	ld	s5,8(s0)
ffffffffc02017f0:	e000                	sd	s0,0(s0)
ffffffffc02017f2:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02017f4:	117000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02017f8:	50051563          	bnez	a0,ffffffffc0201d02 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02017fc:	08098a13          	addi	s4,s3,128
ffffffffc0201800:	8552                	mv	a0,s4
ffffffffc0201802:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201804:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201808:	00008797          	auipc	a5,0x8
ffffffffc020180c:	c207ac23          	sw	zero,-968(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201810:	139000ef          	jal	ra,ffffffffc0202148 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201814:	4511                	li	a0,4
ffffffffc0201816:	0f5000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc020181a:	4c051463          	bnez	a0,ffffffffc0201ce2 <default_check+0x6a2>
ffffffffc020181e:	0889b783          	ld	a5,136(s3)
ffffffffc0201822:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201824:	8b85                	andi	a5,a5,1
ffffffffc0201826:	48078e63          	beqz	a5,ffffffffc0201cc2 <default_check+0x682>
ffffffffc020182a:	0909a703          	lw	a4,144(s3)
ffffffffc020182e:	478d                	li	a5,3
ffffffffc0201830:	48f71963          	bne	a4,a5,ffffffffc0201cc2 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201834:	450d                	li	a0,3
ffffffffc0201836:	0d5000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc020183a:	8c2a                	mv	s8,a0
ffffffffc020183c:	46050363          	beqz	a0,ffffffffc0201ca2 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201840:	4505                	li	a0,1
ffffffffc0201842:	0c9000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201846:	42051e63          	bnez	a0,ffffffffc0201c82 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc020184a:	418a1c63          	bne	s4,s8,ffffffffc0201c62 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc020184e:	4585                	li	a1,1
ffffffffc0201850:	854e                	mv	a0,s3
ffffffffc0201852:	0f7000ef          	jal	ra,ffffffffc0202148 <free_pages>
    free_pages(p1, 3);
ffffffffc0201856:	458d                	li	a1,3
ffffffffc0201858:	8552                	mv	a0,s4
ffffffffc020185a:	0ef000ef          	jal	ra,ffffffffc0202148 <free_pages>
ffffffffc020185e:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201862:	04098c13          	addi	s8,s3,64
ffffffffc0201866:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201868:	8b85                	andi	a5,a5,1
ffffffffc020186a:	3c078c63          	beqz	a5,ffffffffc0201c42 <default_check+0x602>
ffffffffc020186e:	0109a703          	lw	a4,16(s3)
ffffffffc0201872:	4785                	li	a5,1
ffffffffc0201874:	3cf71763          	bne	a4,a5,ffffffffc0201c42 <default_check+0x602>
ffffffffc0201878:	008a3783          	ld	a5,8(s4)
ffffffffc020187c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020187e:	8b85                	andi	a5,a5,1
ffffffffc0201880:	3a078163          	beqz	a5,ffffffffc0201c22 <default_check+0x5e2>
ffffffffc0201884:	010a2703          	lw	a4,16(s4)
ffffffffc0201888:	478d                	li	a5,3
ffffffffc020188a:	38f71c63          	bne	a4,a5,ffffffffc0201c22 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020188e:	4505                	li	a0,1
ffffffffc0201890:	07b000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc0201894:	36a99763          	bne	s3,a0,ffffffffc0201c02 <default_check+0x5c2>
    free_page(p0);
ffffffffc0201898:	4585                	li	a1,1
ffffffffc020189a:	0af000ef          	jal	ra,ffffffffc0202148 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020189e:	4509                	li	a0,2
ffffffffc02018a0:	06b000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02018a4:	32aa1f63          	bne	s4,a0,ffffffffc0201be2 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc02018a8:	4589                	li	a1,2
ffffffffc02018aa:	09f000ef          	jal	ra,ffffffffc0202148 <free_pages>
    free_page(p2);
ffffffffc02018ae:	4585                	li	a1,1
ffffffffc02018b0:	8562                	mv	a0,s8
ffffffffc02018b2:	097000ef          	jal	ra,ffffffffc0202148 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02018b6:	4515                	li	a0,5
ffffffffc02018b8:	053000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02018bc:	89aa                	mv	s3,a0
ffffffffc02018be:	48050263          	beqz	a0,ffffffffc0201d42 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc02018c2:	4505                	li	a0,1
ffffffffc02018c4:	047000ef          	jal	ra,ffffffffc020210a <alloc_pages>
ffffffffc02018c8:	2c051d63          	bnez	a0,ffffffffc0201ba2 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc02018cc:	481c                	lw	a5,16(s0)
ffffffffc02018ce:	2a079a63          	bnez	a5,ffffffffc0201b82 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02018d2:	4595                	li	a1,5
ffffffffc02018d4:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02018d6:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02018da:	01643023          	sd	s6,0(s0)
ffffffffc02018de:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02018e2:	067000ef          	jal	ra,ffffffffc0202148 <free_pages>
    return listelm->next;
ffffffffc02018e6:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02018e8:	00878963          	beq	a5,s0,ffffffffc02018fa <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc02018ec:	ff87a703          	lw	a4,-8(a5)
ffffffffc02018f0:	679c                	ld	a5,8(a5)
ffffffffc02018f2:	397d                	addiw	s2,s2,-1
ffffffffc02018f4:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02018f6:	fe879be3          	bne	a5,s0,ffffffffc02018ec <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02018fa:	26091463          	bnez	s2,ffffffffc0201b62 <default_check+0x522>
    assert(total == 0);
ffffffffc02018fe:	46049263          	bnez	s1,ffffffffc0201d62 <default_check+0x722>
}
ffffffffc0201902:	60a6                	ld	ra,72(sp)
ffffffffc0201904:	6406                	ld	s0,64(sp)
ffffffffc0201906:	74e2                	ld	s1,56(sp)
ffffffffc0201908:	7942                	ld	s2,48(sp)
ffffffffc020190a:	79a2                	ld	s3,40(sp)
ffffffffc020190c:	7a02                	ld	s4,32(sp)
ffffffffc020190e:	6ae2                	ld	s5,24(sp)
ffffffffc0201910:	6b42                	ld	s6,16(sp)
ffffffffc0201912:	6ba2                	ld	s7,8(sp)
ffffffffc0201914:	6c02                	ld	s8,0(sp)
ffffffffc0201916:	6161                	addi	sp,sp,80
ffffffffc0201918:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc020191a:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020191c:	4481                	li	s1,0
ffffffffc020191e:	4901                	li	s2,0
ffffffffc0201920:	b38d                	j	ffffffffc0201682 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201922:	00003697          	auipc	a3,0x3
ffffffffc0201926:	30e68693          	addi	a3,a3,782 # ffffffffc0204c30 <commands+0xb18>
ffffffffc020192a:	00003617          	auipc	a2,0x3
ffffffffc020192e:	ff660613          	addi	a2,a2,-10 # ffffffffc0204920 <commands+0x808>
ffffffffc0201932:	0f000593          	li	a1,240
ffffffffc0201936:	00003517          	auipc	a0,0x3
ffffffffc020193a:	30a50513          	addi	a0,a0,778 # ffffffffc0204c40 <commands+0xb28>
ffffffffc020193e:	8a1fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201942:	00003697          	auipc	a3,0x3
ffffffffc0201946:	39668693          	addi	a3,a3,918 # ffffffffc0204cd8 <commands+0xbc0>
ffffffffc020194a:	00003617          	auipc	a2,0x3
ffffffffc020194e:	fd660613          	addi	a2,a2,-42 # ffffffffc0204920 <commands+0x808>
ffffffffc0201952:	0bd00593          	li	a1,189
ffffffffc0201956:	00003517          	auipc	a0,0x3
ffffffffc020195a:	2ea50513          	addi	a0,a0,746 # ffffffffc0204c40 <commands+0xb28>
ffffffffc020195e:	881fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201962:	00003697          	auipc	a3,0x3
ffffffffc0201966:	39e68693          	addi	a3,a3,926 # ffffffffc0204d00 <commands+0xbe8>
ffffffffc020196a:	00003617          	auipc	a2,0x3
ffffffffc020196e:	fb660613          	addi	a2,a2,-74 # ffffffffc0204920 <commands+0x808>
ffffffffc0201972:	0be00593          	li	a1,190
ffffffffc0201976:	00003517          	auipc	a0,0x3
ffffffffc020197a:	2ca50513          	addi	a0,a0,714 # ffffffffc0204c40 <commands+0xb28>
ffffffffc020197e:	861fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201982:	00003697          	auipc	a3,0x3
ffffffffc0201986:	3be68693          	addi	a3,a3,958 # ffffffffc0204d40 <commands+0xc28>
ffffffffc020198a:	00003617          	auipc	a2,0x3
ffffffffc020198e:	f9660613          	addi	a2,a2,-106 # ffffffffc0204920 <commands+0x808>
ffffffffc0201992:	0c000593          	li	a1,192
ffffffffc0201996:	00003517          	auipc	a0,0x3
ffffffffc020199a:	2aa50513          	addi	a0,a0,682 # ffffffffc0204c40 <commands+0xb28>
ffffffffc020199e:	841fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(!list_empty(&free_list));
ffffffffc02019a2:	00003697          	auipc	a3,0x3
ffffffffc02019a6:	42668693          	addi	a3,a3,1062 # ffffffffc0204dc8 <commands+0xcb0>
ffffffffc02019aa:	00003617          	auipc	a2,0x3
ffffffffc02019ae:	f7660613          	addi	a2,a2,-138 # ffffffffc0204920 <commands+0x808>
ffffffffc02019b2:	0d900593          	li	a1,217
ffffffffc02019b6:	00003517          	auipc	a0,0x3
ffffffffc02019ba:	28a50513          	addi	a0,a0,650 # ffffffffc0204c40 <commands+0xb28>
ffffffffc02019be:	821fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02019c2:	00003697          	auipc	a3,0x3
ffffffffc02019c6:	2b668693          	addi	a3,a3,694 # ffffffffc0204c78 <commands+0xb60>
ffffffffc02019ca:	00003617          	auipc	a2,0x3
ffffffffc02019ce:	f5660613          	addi	a2,a2,-170 # ffffffffc0204920 <commands+0x808>
ffffffffc02019d2:	0d200593          	li	a1,210
ffffffffc02019d6:	00003517          	auipc	a0,0x3
ffffffffc02019da:	26a50513          	addi	a0,a0,618 # ffffffffc0204c40 <commands+0xb28>
ffffffffc02019de:	801fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free == 3);
ffffffffc02019e2:	00003697          	auipc	a3,0x3
ffffffffc02019e6:	3d668693          	addi	a3,a3,982 # ffffffffc0204db8 <commands+0xca0>
ffffffffc02019ea:	00003617          	auipc	a2,0x3
ffffffffc02019ee:	f3660613          	addi	a2,a2,-202 # ffffffffc0204920 <commands+0x808>
ffffffffc02019f2:	0d000593          	li	a1,208
ffffffffc02019f6:	00003517          	auipc	a0,0x3
ffffffffc02019fa:	24a50513          	addi	a0,a0,586 # ffffffffc0204c40 <commands+0xb28>
ffffffffc02019fe:	fe0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201a02:	00003697          	auipc	a3,0x3
ffffffffc0201a06:	39e68693          	addi	a3,a3,926 # ffffffffc0204da0 <commands+0xc88>
ffffffffc0201a0a:	00003617          	auipc	a2,0x3
ffffffffc0201a0e:	f1660613          	addi	a2,a2,-234 # ffffffffc0204920 <commands+0x808>
ffffffffc0201a12:	0cb00593          	li	a1,203
ffffffffc0201a16:	00003517          	auipc	a0,0x3
ffffffffc0201a1a:	22a50513          	addi	a0,a0,554 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201a1e:	fc0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201a22:	00003697          	auipc	a3,0x3
ffffffffc0201a26:	35e68693          	addi	a3,a3,862 # ffffffffc0204d80 <commands+0xc68>
ffffffffc0201a2a:	00003617          	auipc	a2,0x3
ffffffffc0201a2e:	ef660613          	addi	a2,a2,-266 # ffffffffc0204920 <commands+0x808>
ffffffffc0201a32:	0c200593          	li	a1,194
ffffffffc0201a36:	00003517          	auipc	a0,0x3
ffffffffc0201a3a:	20a50513          	addi	a0,a0,522 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201a3e:	fa0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(p0 != NULL);
ffffffffc0201a42:	00003697          	auipc	a3,0x3
ffffffffc0201a46:	3ce68693          	addi	a3,a3,974 # ffffffffc0204e10 <commands+0xcf8>
ffffffffc0201a4a:	00003617          	auipc	a2,0x3
ffffffffc0201a4e:	ed660613          	addi	a2,a2,-298 # ffffffffc0204920 <commands+0x808>
ffffffffc0201a52:	0f800593          	li	a1,248
ffffffffc0201a56:	00003517          	auipc	a0,0x3
ffffffffc0201a5a:	1ea50513          	addi	a0,a0,490 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201a5e:	f80fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free == 0);
ffffffffc0201a62:	00003697          	auipc	a3,0x3
ffffffffc0201a66:	39e68693          	addi	a3,a3,926 # ffffffffc0204e00 <commands+0xce8>
ffffffffc0201a6a:	00003617          	auipc	a2,0x3
ffffffffc0201a6e:	eb660613          	addi	a2,a2,-330 # ffffffffc0204920 <commands+0x808>
ffffffffc0201a72:	0df00593          	li	a1,223
ffffffffc0201a76:	00003517          	auipc	a0,0x3
ffffffffc0201a7a:	1ca50513          	addi	a0,a0,458 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201a7e:	f60fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201a82:	00003697          	auipc	a3,0x3
ffffffffc0201a86:	31e68693          	addi	a3,a3,798 # ffffffffc0204da0 <commands+0xc88>
ffffffffc0201a8a:	00003617          	auipc	a2,0x3
ffffffffc0201a8e:	e9660613          	addi	a2,a2,-362 # ffffffffc0204920 <commands+0x808>
ffffffffc0201a92:	0dd00593          	li	a1,221
ffffffffc0201a96:	00003517          	auipc	a0,0x3
ffffffffc0201a9a:	1aa50513          	addi	a0,a0,426 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201a9e:	f40fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201aa2:	00003697          	auipc	a3,0x3
ffffffffc0201aa6:	33e68693          	addi	a3,a3,830 # ffffffffc0204de0 <commands+0xcc8>
ffffffffc0201aaa:	00003617          	auipc	a2,0x3
ffffffffc0201aae:	e7660613          	addi	a2,a2,-394 # ffffffffc0204920 <commands+0x808>
ffffffffc0201ab2:	0dc00593          	li	a1,220
ffffffffc0201ab6:	00003517          	auipc	a0,0x3
ffffffffc0201aba:	18a50513          	addi	a0,a0,394 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201abe:	f20fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201ac2:	00003697          	auipc	a3,0x3
ffffffffc0201ac6:	1b668693          	addi	a3,a3,438 # ffffffffc0204c78 <commands+0xb60>
ffffffffc0201aca:	00003617          	auipc	a2,0x3
ffffffffc0201ace:	e5660613          	addi	a2,a2,-426 # ffffffffc0204920 <commands+0x808>
ffffffffc0201ad2:	0b900593          	li	a1,185
ffffffffc0201ad6:	00003517          	auipc	a0,0x3
ffffffffc0201ada:	16a50513          	addi	a0,a0,362 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201ade:	f00fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201ae2:	00003697          	auipc	a3,0x3
ffffffffc0201ae6:	2be68693          	addi	a3,a3,702 # ffffffffc0204da0 <commands+0xc88>
ffffffffc0201aea:	00003617          	auipc	a2,0x3
ffffffffc0201aee:	e3660613          	addi	a2,a2,-458 # ffffffffc0204920 <commands+0x808>
ffffffffc0201af2:	0d600593          	li	a1,214
ffffffffc0201af6:	00003517          	auipc	a0,0x3
ffffffffc0201afa:	14a50513          	addi	a0,a0,330 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201afe:	ee0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201b02:	00003697          	auipc	a3,0x3
ffffffffc0201b06:	1b668693          	addi	a3,a3,438 # ffffffffc0204cb8 <commands+0xba0>
ffffffffc0201b0a:	00003617          	auipc	a2,0x3
ffffffffc0201b0e:	e1660613          	addi	a2,a2,-490 # ffffffffc0204920 <commands+0x808>
ffffffffc0201b12:	0d400593          	li	a1,212
ffffffffc0201b16:	00003517          	auipc	a0,0x3
ffffffffc0201b1a:	12a50513          	addi	a0,a0,298 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201b1e:	ec0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201b22:	00003697          	auipc	a3,0x3
ffffffffc0201b26:	17668693          	addi	a3,a3,374 # ffffffffc0204c98 <commands+0xb80>
ffffffffc0201b2a:	00003617          	auipc	a2,0x3
ffffffffc0201b2e:	df660613          	addi	a2,a2,-522 # ffffffffc0204920 <commands+0x808>
ffffffffc0201b32:	0d300593          	li	a1,211
ffffffffc0201b36:	00003517          	auipc	a0,0x3
ffffffffc0201b3a:	10a50513          	addi	a0,a0,266 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201b3e:	ea0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201b42:	00003697          	auipc	a3,0x3
ffffffffc0201b46:	17668693          	addi	a3,a3,374 # ffffffffc0204cb8 <commands+0xba0>
ffffffffc0201b4a:	00003617          	auipc	a2,0x3
ffffffffc0201b4e:	dd660613          	addi	a2,a2,-554 # ffffffffc0204920 <commands+0x808>
ffffffffc0201b52:	0bb00593          	li	a1,187
ffffffffc0201b56:	00003517          	auipc	a0,0x3
ffffffffc0201b5a:	0ea50513          	addi	a0,a0,234 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201b5e:	e80fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(count == 0);
ffffffffc0201b62:	00003697          	auipc	a3,0x3
ffffffffc0201b66:	3fe68693          	addi	a3,a3,1022 # ffffffffc0204f60 <commands+0xe48>
ffffffffc0201b6a:	00003617          	auipc	a2,0x3
ffffffffc0201b6e:	db660613          	addi	a2,a2,-586 # ffffffffc0204920 <commands+0x808>
ffffffffc0201b72:	12500593          	li	a1,293
ffffffffc0201b76:	00003517          	auipc	a0,0x3
ffffffffc0201b7a:	0ca50513          	addi	a0,a0,202 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201b7e:	e60fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free == 0);
ffffffffc0201b82:	00003697          	auipc	a3,0x3
ffffffffc0201b86:	27e68693          	addi	a3,a3,638 # ffffffffc0204e00 <commands+0xce8>
ffffffffc0201b8a:	00003617          	auipc	a2,0x3
ffffffffc0201b8e:	d9660613          	addi	a2,a2,-618 # ffffffffc0204920 <commands+0x808>
ffffffffc0201b92:	11a00593          	li	a1,282
ffffffffc0201b96:	00003517          	auipc	a0,0x3
ffffffffc0201b9a:	0aa50513          	addi	a0,a0,170 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201b9e:	e40fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201ba2:	00003697          	auipc	a3,0x3
ffffffffc0201ba6:	1fe68693          	addi	a3,a3,510 # ffffffffc0204da0 <commands+0xc88>
ffffffffc0201baa:	00003617          	auipc	a2,0x3
ffffffffc0201bae:	d7660613          	addi	a2,a2,-650 # ffffffffc0204920 <commands+0x808>
ffffffffc0201bb2:	11800593          	li	a1,280
ffffffffc0201bb6:	00003517          	auipc	a0,0x3
ffffffffc0201bba:	08a50513          	addi	a0,a0,138 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201bbe:	e20fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201bc2:	00003697          	auipc	a3,0x3
ffffffffc0201bc6:	19e68693          	addi	a3,a3,414 # ffffffffc0204d60 <commands+0xc48>
ffffffffc0201bca:	00003617          	auipc	a2,0x3
ffffffffc0201bce:	d5660613          	addi	a2,a2,-682 # ffffffffc0204920 <commands+0x808>
ffffffffc0201bd2:	0c100593          	li	a1,193
ffffffffc0201bd6:	00003517          	auipc	a0,0x3
ffffffffc0201bda:	06a50513          	addi	a0,a0,106 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201bde:	e00fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201be2:	00003697          	auipc	a3,0x3
ffffffffc0201be6:	33e68693          	addi	a3,a3,830 # ffffffffc0204f20 <commands+0xe08>
ffffffffc0201bea:	00003617          	auipc	a2,0x3
ffffffffc0201bee:	d3660613          	addi	a2,a2,-714 # ffffffffc0204920 <commands+0x808>
ffffffffc0201bf2:	11200593          	li	a1,274
ffffffffc0201bf6:	00003517          	auipc	a0,0x3
ffffffffc0201bfa:	04a50513          	addi	a0,a0,74 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201bfe:	de0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201c02:	00003697          	auipc	a3,0x3
ffffffffc0201c06:	2fe68693          	addi	a3,a3,766 # ffffffffc0204f00 <commands+0xde8>
ffffffffc0201c0a:	00003617          	auipc	a2,0x3
ffffffffc0201c0e:	d1660613          	addi	a2,a2,-746 # ffffffffc0204920 <commands+0x808>
ffffffffc0201c12:	11000593          	li	a1,272
ffffffffc0201c16:	00003517          	auipc	a0,0x3
ffffffffc0201c1a:	02a50513          	addi	a0,a0,42 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201c1e:	dc0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201c22:	00003697          	auipc	a3,0x3
ffffffffc0201c26:	2b668693          	addi	a3,a3,694 # ffffffffc0204ed8 <commands+0xdc0>
ffffffffc0201c2a:	00003617          	auipc	a2,0x3
ffffffffc0201c2e:	cf660613          	addi	a2,a2,-778 # ffffffffc0204920 <commands+0x808>
ffffffffc0201c32:	10e00593          	li	a1,270
ffffffffc0201c36:	00003517          	auipc	a0,0x3
ffffffffc0201c3a:	00a50513          	addi	a0,a0,10 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201c3e:	da0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201c42:	00003697          	auipc	a3,0x3
ffffffffc0201c46:	26e68693          	addi	a3,a3,622 # ffffffffc0204eb0 <commands+0xd98>
ffffffffc0201c4a:	00003617          	auipc	a2,0x3
ffffffffc0201c4e:	cd660613          	addi	a2,a2,-810 # ffffffffc0204920 <commands+0x808>
ffffffffc0201c52:	10d00593          	li	a1,269
ffffffffc0201c56:	00003517          	auipc	a0,0x3
ffffffffc0201c5a:	fea50513          	addi	a0,a0,-22 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201c5e:	d80fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201c62:	00003697          	auipc	a3,0x3
ffffffffc0201c66:	23e68693          	addi	a3,a3,574 # ffffffffc0204ea0 <commands+0xd88>
ffffffffc0201c6a:	00003617          	auipc	a2,0x3
ffffffffc0201c6e:	cb660613          	addi	a2,a2,-842 # ffffffffc0204920 <commands+0x808>
ffffffffc0201c72:	10800593          	li	a1,264
ffffffffc0201c76:	00003517          	auipc	a0,0x3
ffffffffc0201c7a:	fca50513          	addi	a0,a0,-54 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201c7e:	d60fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201c82:	00003697          	auipc	a3,0x3
ffffffffc0201c86:	11e68693          	addi	a3,a3,286 # ffffffffc0204da0 <commands+0xc88>
ffffffffc0201c8a:	00003617          	auipc	a2,0x3
ffffffffc0201c8e:	c9660613          	addi	a2,a2,-874 # ffffffffc0204920 <commands+0x808>
ffffffffc0201c92:	10700593          	li	a1,263
ffffffffc0201c96:	00003517          	auipc	a0,0x3
ffffffffc0201c9a:	faa50513          	addi	a0,a0,-86 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201c9e:	d40fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201ca2:	00003697          	auipc	a3,0x3
ffffffffc0201ca6:	1de68693          	addi	a3,a3,478 # ffffffffc0204e80 <commands+0xd68>
ffffffffc0201caa:	00003617          	auipc	a2,0x3
ffffffffc0201cae:	c7660613          	addi	a2,a2,-906 # ffffffffc0204920 <commands+0x808>
ffffffffc0201cb2:	10600593          	li	a1,262
ffffffffc0201cb6:	00003517          	auipc	a0,0x3
ffffffffc0201cba:	f8a50513          	addi	a0,a0,-118 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201cbe:	d20fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201cc2:	00003697          	auipc	a3,0x3
ffffffffc0201cc6:	18e68693          	addi	a3,a3,398 # ffffffffc0204e50 <commands+0xd38>
ffffffffc0201cca:	00003617          	auipc	a2,0x3
ffffffffc0201cce:	c5660613          	addi	a2,a2,-938 # ffffffffc0204920 <commands+0x808>
ffffffffc0201cd2:	10500593          	li	a1,261
ffffffffc0201cd6:	00003517          	auipc	a0,0x3
ffffffffc0201cda:	f6a50513          	addi	a0,a0,-150 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201cde:	d00fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201ce2:	00003697          	auipc	a3,0x3
ffffffffc0201ce6:	15668693          	addi	a3,a3,342 # ffffffffc0204e38 <commands+0xd20>
ffffffffc0201cea:	00003617          	auipc	a2,0x3
ffffffffc0201cee:	c3660613          	addi	a2,a2,-970 # ffffffffc0204920 <commands+0x808>
ffffffffc0201cf2:	10400593          	li	a1,260
ffffffffc0201cf6:	00003517          	auipc	a0,0x3
ffffffffc0201cfa:	f4a50513          	addi	a0,a0,-182 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201cfe:	ce0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201d02:	00003697          	auipc	a3,0x3
ffffffffc0201d06:	09e68693          	addi	a3,a3,158 # ffffffffc0204da0 <commands+0xc88>
ffffffffc0201d0a:	00003617          	auipc	a2,0x3
ffffffffc0201d0e:	c1660613          	addi	a2,a2,-1002 # ffffffffc0204920 <commands+0x808>
ffffffffc0201d12:	0fe00593          	li	a1,254
ffffffffc0201d16:	00003517          	auipc	a0,0x3
ffffffffc0201d1a:	f2a50513          	addi	a0,a0,-214 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201d1e:	cc0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(!PageProperty(p0));
ffffffffc0201d22:	00003697          	auipc	a3,0x3
ffffffffc0201d26:	0fe68693          	addi	a3,a3,254 # ffffffffc0204e20 <commands+0xd08>
ffffffffc0201d2a:	00003617          	auipc	a2,0x3
ffffffffc0201d2e:	bf660613          	addi	a2,a2,-1034 # ffffffffc0204920 <commands+0x808>
ffffffffc0201d32:	0f900593          	li	a1,249
ffffffffc0201d36:	00003517          	auipc	a0,0x3
ffffffffc0201d3a:	f0a50513          	addi	a0,a0,-246 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201d3e:	ca0fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201d42:	00003697          	auipc	a3,0x3
ffffffffc0201d46:	1fe68693          	addi	a3,a3,510 # ffffffffc0204f40 <commands+0xe28>
ffffffffc0201d4a:	00003617          	auipc	a2,0x3
ffffffffc0201d4e:	bd660613          	addi	a2,a2,-1066 # ffffffffc0204920 <commands+0x808>
ffffffffc0201d52:	11700593          	li	a1,279
ffffffffc0201d56:	00003517          	auipc	a0,0x3
ffffffffc0201d5a:	eea50513          	addi	a0,a0,-278 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201d5e:	c80fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(total == 0);
ffffffffc0201d62:	00003697          	auipc	a3,0x3
ffffffffc0201d66:	20e68693          	addi	a3,a3,526 # ffffffffc0204f70 <commands+0xe58>
ffffffffc0201d6a:	00003617          	auipc	a2,0x3
ffffffffc0201d6e:	bb660613          	addi	a2,a2,-1098 # ffffffffc0204920 <commands+0x808>
ffffffffc0201d72:	12600593          	li	a1,294
ffffffffc0201d76:	00003517          	auipc	a0,0x3
ffffffffc0201d7a:	eca50513          	addi	a0,a0,-310 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201d7e:	c60fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(total == nr_free_pages());
ffffffffc0201d82:	00003697          	auipc	a3,0x3
ffffffffc0201d86:	ed668693          	addi	a3,a3,-298 # ffffffffc0204c58 <commands+0xb40>
ffffffffc0201d8a:	00003617          	auipc	a2,0x3
ffffffffc0201d8e:	b9660613          	addi	a2,a2,-1130 # ffffffffc0204920 <commands+0x808>
ffffffffc0201d92:	0f300593          	li	a1,243
ffffffffc0201d96:	00003517          	auipc	a0,0x3
ffffffffc0201d9a:	eaa50513          	addi	a0,a0,-342 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201d9e:	c40fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201da2:	00003697          	auipc	a3,0x3
ffffffffc0201da6:	ef668693          	addi	a3,a3,-266 # ffffffffc0204c98 <commands+0xb80>
ffffffffc0201daa:	00003617          	auipc	a2,0x3
ffffffffc0201dae:	b7660613          	addi	a2,a2,-1162 # ffffffffc0204920 <commands+0x808>
ffffffffc0201db2:	0ba00593          	li	a1,186
ffffffffc0201db6:	00003517          	auipc	a0,0x3
ffffffffc0201dba:	e8a50513          	addi	a0,a0,-374 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201dbe:	c20fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201dc2 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201dc2:	1141                	addi	sp,sp,-16
ffffffffc0201dc4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201dc6:	14058463          	beqz	a1,ffffffffc0201f0e <default_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0201dca:	00659693          	slli	a3,a1,0x6
ffffffffc0201dce:	96aa                	add	a3,a3,a0
ffffffffc0201dd0:	87aa                	mv	a5,a0
ffffffffc0201dd2:	02d50263          	beq	a0,a3,ffffffffc0201df6 <default_free_pages+0x34>
ffffffffc0201dd6:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201dd8:	8b05                	andi	a4,a4,1
ffffffffc0201dda:	10071a63          	bnez	a4,ffffffffc0201eee <default_free_pages+0x12c>
ffffffffc0201dde:	6798                	ld	a4,8(a5)
ffffffffc0201de0:	8b09                	andi	a4,a4,2
ffffffffc0201de2:	10071663          	bnez	a4,ffffffffc0201eee <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201de6:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201dea:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201dee:	04078793          	addi	a5,a5,64
ffffffffc0201df2:	fed792e3          	bne	a5,a3,ffffffffc0201dd6 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201df6:	2581                	sext.w	a1,a1
ffffffffc0201df8:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201dfa:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201dfe:	4789                	li	a5,2
ffffffffc0201e00:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201e04:	00007697          	auipc	a3,0x7
ffffffffc0201e08:	62c68693          	addi	a3,a3,1580 # ffffffffc0209430 <free_area>
ffffffffc0201e0c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201e0e:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201e10:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201e14:	9db9                	addw	a1,a1,a4
ffffffffc0201e16:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201e18:	0ad78463          	beq	a5,a3,ffffffffc0201ec0 <default_free_pages+0xfe>
            struct Page* page = le2page(le, page_link);
ffffffffc0201e1c:	fe878713          	addi	a4,a5,-24
ffffffffc0201e20:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201e24:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201e26:	00e56a63          	bltu	a0,a4,ffffffffc0201e3a <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201e2a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201e2c:	04d70c63          	beq	a4,a3,ffffffffc0201e84 <default_free_pages+0xc2>
    for (; p != base + n; p ++) {
ffffffffc0201e30:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201e32:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201e36:	fee57ae3          	bgeu	a0,a4,ffffffffc0201e2a <default_free_pages+0x68>
ffffffffc0201e3a:	c199                	beqz	a1,ffffffffc0201e40 <default_free_pages+0x7e>
ffffffffc0201e3c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201e40:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0201e42:	e390                	sd	a2,0(a5)
ffffffffc0201e44:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201e46:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201e48:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201e4a:	00d70d63          	beq	a4,a3,ffffffffc0201e64 <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc0201e4e:	ff872583          	lw	a1,-8(a4) # ff8 <kern_entry-0xffffffffc01ff008>
        p = le2page(le, page_link);
ffffffffc0201e52:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0201e56:	02059813          	slli	a6,a1,0x20
ffffffffc0201e5a:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201e5e:	97b2                	add	a5,a5,a2
ffffffffc0201e60:	02f50c63          	beq	a0,a5,ffffffffc0201e98 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201e64:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201e66:	00d78c63          	beq	a5,a3,ffffffffc0201e7e <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0201e6a:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201e6c:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0201e70:	02061593          	slli	a1,a2,0x20
ffffffffc0201e74:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201e78:	972a                	add	a4,a4,a0
ffffffffc0201e7a:	04e68a63          	beq	a3,a4,ffffffffc0201ece <default_free_pages+0x10c>
}
ffffffffc0201e7e:	60a2                	ld	ra,8(sp)
ffffffffc0201e80:	0141                	addi	sp,sp,16
ffffffffc0201e82:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201e84:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201e86:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201e88:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201e8a:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201e8c:	02d70763          	beq	a4,a3,ffffffffc0201eba <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201e90:	8832                	mv	a6,a2
ffffffffc0201e92:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201e94:	87ba                	mv	a5,a4
ffffffffc0201e96:	bf71                	j	ffffffffc0201e32 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0201e98:	491c                	lw	a5,16(a0)
ffffffffc0201e9a:	9dbd                	addw	a1,a1,a5
ffffffffc0201e9c:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201ea0:	57f5                	li	a5,-3
ffffffffc0201ea2:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201ea6:	01853803          	ld	a6,24(a0)
ffffffffc0201eaa:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201eac:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc0201eae:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201eb2:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201eb4:	0105b023          	sd	a6,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201eb8:	b77d                	j	ffffffffc0201e66 <default_free_pages+0xa4>
ffffffffc0201eba:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201ebc:	873e                	mv	a4,a5
ffffffffc0201ebe:	bf41                	j	ffffffffc0201e4e <default_free_pages+0x8c>
}
ffffffffc0201ec0:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201ec2:	e390                	sd	a2,0(a5)
ffffffffc0201ec4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201ec6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201ec8:	ed1c                	sd	a5,24(a0)
ffffffffc0201eca:	0141                	addi	sp,sp,16
ffffffffc0201ecc:	8082                	ret
            base->property += p->property;
ffffffffc0201ece:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201ed2:	ff078693          	addi	a3,a5,-16
ffffffffc0201ed6:	9e39                	addw	a2,a2,a4
ffffffffc0201ed8:	c910                	sw	a2,16(a0)
ffffffffc0201eda:	5775                	li	a4,-3
ffffffffc0201edc:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201ee0:	6398                	ld	a4,0(a5)
ffffffffc0201ee2:	679c                	ld	a5,8(a5)
}
ffffffffc0201ee4:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201ee6:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201ee8:	e398                	sd	a4,0(a5)
ffffffffc0201eea:	0141                	addi	sp,sp,16
ffffffffc0201eec:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201eee:	00003697          	auipc	a3,0x3
ffffffffc0201ef2:	09a68693          	addi	a3,a3,154 # ffffffffc0204f88 <commands+0xe70>
ffffffffc0201ef6:	00003617          	auipc	a2,0x3
ffffffffc0201efa:	a2a60613          	addi	a2,a2,-1494 # ffffffffc0204920 <commands+0x808>
ffffffffc0201efe:	08300593          	li	a1,131
ffffffffc0201f02:	00003517          	auipc	a0,0x3
ffffffffc0201f06:	d3e50513          	addi	a0,a0,-706 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201f0a:	ad4fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(n > 0);
ffffffffc0201f0e:	00003697          	auipc	a3,0x3
ffffffffc0201f12:	07268693          	addi	a3,a3,114 # ffffffffc0204f80 <commands+0xe68>
ffffffffc0201f16:	00003617          	auipc	a2,0x3
ffffffffc0201f1a:	a0a60613          	addi	a2,a2,-1526 # ffffffffc0204920 <commands+0x808>
ffffffffc0201f1e:	08000593          	li	a1,128
ffffffffc0201f22:	00003517          	auipc	a0,0x3
ffffffffc0201f26:	d1e50513          	addi	a0,a0,-738 # ffffffffc0204c40 <commands+0xb28>
ffffffffc0201f2a:	ab4fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201f2e <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201f2e:	c941                	beqz	a0,ffffffffc0201fbe <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc0201f30:	00007597          	auipc	a1,0x7
ffffffffc0201f34:	50058593          	addi	a1,a1,1280 # ffffffffc0209430 <free_area>
ffffffffc0201f38:	0105a803          	lw	a6,16(a1)
ffffffffc0201f3c:	872a                	mv	a4,a0
ffffffffc0201f3e:	02081793          	slli	a5,a6,0x20
ffffffffc0201f42:	9381                	srli	a5,a5,0x20
ffffffffc0201f44:	00a7ee63          	bltu	a5,a0,ffffffffc0201f60 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201f48:	87ae                	mv	a5,a1
ffffffffc0201f4a:	a801                	j	ffffffffc0201f5a <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201f4c:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201f50:	02069613          	slli	a2,a3,0x20
ffffffffc0201f54:	9201                	srli	a2,a2,0x20
ffffffffc0201f56:	00e67763          	bgeu	a2,a4,ffffffffc0201f64 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201f5a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201f5c:	feb798e3          	bne	a5,a1,ffffffffc0201f4c <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201f60:	4501                	li	a0,0
}
ffffffffc0201f62:	8082                	ret
    return listelm->prev;
ffffffffc0201f64:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201f68:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201f6c:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201f70:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201f74:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201f78:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0201f7c:	02c77863          	bgeu	a4,a2,ffffffffc0201fac <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201f80:	071a                	slli	a4,a4,0x6
ffffffffc0201f82:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201f84:	41c686bb          	subw	a3,a3,t3
ffffffffc0201f88:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201f8a:	00870613          	addi	a2,a4,8
ffffffffc0201f8e:	4689                	li	a3,2
ffffffffc0201f90:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201f94:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0201f98:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201f9c:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201fa0:	e290                	sd	a2,0(a3)
ffffffffc0201fa2:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0201fa6:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0201fa8:	01173c23          	sd	a7,24(a4)
ffffffffc0201fac:	41c8083b          	subw	a6,a6,t3
ffffffffc0201fb0:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201fb4:	5775                	li	a4,-3
ffffffffc0201fb6:	17c1                	addi	a5,a5,-16
ffffffffc0201fb8:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201fbc:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0201fbe:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201fc0:	00003697          	auipc	a3,0x3
ffffffffc0201fc4:	fc068693          	addi	a3,a3,-64 # ffffffffc0204f80 <commands+0xe68>
ffffffffc0201fc8:	00003617          	auipc	a2,0x3
ffffffffc0201fcc:	95860613          	addi	a2,a2,-1704 # ffffffffc0204920 <commands+0x808>
ffffffffc0201fd0:	06200593          	li	a1,98
ffffffffc0201fd4:	00003517          	auipc	a0,0x3
ffffffffc0201fd8:	c6c50513          	addi	a0,a0,-916 # ffffffffc0204c40 <commands+0xb28>
default_alloc_pages(size_t n) {
ffffffffc0201fdc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201fde:	a00fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201fe2 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201fe2:	1141                	addi	sp,sp,-16
ffffffffc0201fe4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201fe6:	c5f1                	beqz	a1,ffffffffc02020b2 <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc0201fe8:	00659693          	slli	a3,a1,0x6
ffffffffc0201fec:	96aa                	add	a3,a3,a0
ffffffffc0201fee:	87aa                	mv	a5,a0
ffffffffc0201ff0:	00d50f63          	beq	a0,a3,ffffffffc020200e <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201ff4:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201ff6:	8b05                	andi	a4,a4,1
ffffffffc0201ff8:	cf49                	beqz	a4,ffffffffc0202092 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201ffa:	0007a823          	sw	zero,16(a5)
ffffffffc0201ffe:	0007b423          	sd	zero,8(a5)
ffffffffc0202002:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0202006:	04078793          	addi	a5,a5,64
ffffffffc020200a:	fed795e3          	bne	a5,a3,ffffffffc0201ff4 <default_init_memmap+0x12>
    base->property = n;
ffffffffc020200e:	2581                	sext.w	a1,a1
ffffffffc0202010:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202012:	4789                	li	a5,2
ffffffffc0202014:	00850713          	addi	a4,a0,8
ffffffffc0202018:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020201c:	00007697          	auipc	a3,0x7
ffffffffc0202020:	41468693          	addi	a3,a3,1044 # ffffffffc0209430 <free_area>
ffffffffc0202024:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0202026:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0202028:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020202c:	9db9                	addw	a1,a1,a4
ffffffffc020202e:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0202030:	04d78a63          	beq	a5,a3,ffffffffc0202084 <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc0202034:	fe878713          	addi	a4,a5,-24
ffffffffc0202038:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020203c:	4581                	li	a1,0
            if (base < page) {
ffffffffc020203e:	00e56a63          	bltu	a0,a4,ffffffffc0202052 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0202042:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0202044:	02d70263          	beq	a4,a3,ffffffffc0202068 <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc0202048:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020204a:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc020204e:	fee57ae3          	bgeu	a0,a4,ffffffffc0202042 <default_init_memmap+0x60>
ffffffffc0202052:	c199                	beqz	a1,ffffffffc0202058 <default_init_memmap+0x76>
ffffffffc0202054:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202058:	6398                	ld	a4,0(a5)
}
ffffffffc020205a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020205c:	e390                	sd	a2,0(a5)
ffffffffc020205e:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202060:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202062:	ed18                	sd	a4,24(a0)
ffffffffc0202064:	0141                	addi	sp,sp,16
ffffffffc0202066:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202068:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020206a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020206c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020206e:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202070:	00d70663          	beq	a4,a3,ffffffffc020207c <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0202074:	8832                	mv	a6,a2
ffffffffc0202076:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202078:	87ba                	mv	a5,a4
ffffffffc020207a:	bfc1                	j	ffffffffc020204a <default_init_memmap+0x68>
}
ffffffffc020207c:	60a2                	ld	ra,8(sp)
ffffffffc020207e:	e290                	sd	a2,0(a3)
ffffffffc0202080:	0141                	addi	sp,sp,16
ffffffffc0202082:	8082                	ret
ffffffffc0202084:	60a2                	ld	ra,8(sp)
ffffffffc0202086:	e390                	sd	a2,0(a5)
ffffffffc0202088:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020208a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020208c:	ed1c                	sd	a5,24(a0)
ffffffffc020208e:	0141                	addi	sp,sp,16
ffffffffc0202090:	8082                	ret
        assert(PageReserved(p));
ffffffffc0202092:	00003697          	auipc	a3,0x3
ffffffffc0202096:	f1e68693          	addi	a3,a3,-226 # ffffffffc0204fb0 <commands+0xe98>
ffffffffc020209a:	00003617          	auipc	a2,0x3
ffffffffc020209e:	88660613          	addi	a2,a2,-1914 # ffffffffc0204920 <commands+0x808>
ffffffffc02020a2:	04900593          	li	a1,73
ffffffffc02020a6:	00003517          	auipc	a0,0x3
ffffffffc02020aa:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0204c40 <commands+0xb28>
ffffffffc02020ae:	930fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(n > 0);
ffffffffc02020b2:	00003697          	auipc	a3,0x3
ffffffffc02020b6:	ece68693          	addi	a3,a3,-306 # ffffffffc0204f80 <commands+0xe68>
ffffffffc02020ba:	00003617          	auipc	a2,0x3
ffffffffc02020be:	86660613          	addi	a2,a2,-1946 # ffffffffc0204920 <commands+0x808>
ffffffffc02020c2:	04600593          	li	a1,70
ffffffffc02020c6:	00003517          	auipc	a0,0x3
ffffffffc02020ca:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0204c40 <commands+0xb28>
ffffffffc02020ce:	910fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02020d2 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc02020d2:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02020d4:	00003617          	auipc	a2,0x3
ffffffffc02020d8:	b3c60613          	addi	a2,a2,-1220 # ffffffffc0204c10 <commands+0xaf8>
ffffffffc02020dc:	06900593          	li	a1,105
ffffffffc02020e0:	00003517          	auipc	a0,0x3
ffffffffc02020e4:	a8850513          	addi	a0,a0,-1400 # ffffffffc0204b68 <commands+0xa50>
pa2page(uintptr_t pa)
ffffffffc02020e8:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc02020ea:	8f4fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02020ee <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc02020ee:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc02020f0:	00003617          	auipc	a2,0x3
ffffffffc02020f4:	f2060613          	addi	a2,a2,-224 # ffffffffc0205010 <default_pmm_manager+0x38>
ffffffffc02020f8:	07f00593          	li	a1,127
ffffffffc02020fc:	00003517          	auipc	a0,0x3
ffffffffc0202100:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0204b68 <commands+0xa50>
pte2page(pte_t pte)
ffffffffc0202104:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202106:	8d8fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020210a <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020210a:	100027f3          	csrr	a5,sstatus
ffffffffc020210e:	8b89                	andi	a5,a5,2
ffffffffc0202110:	e799                	bnez	a5,ffffffffc020211e <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0202112:	0000b797          	auipc	a5,0xb
ffffffffc0202116:	3a67b783          	ld	a5,934(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc020211a:	6f9c                	ld	a5,24(a5)
ffffffffc020211c:	8782                	jr	a5
{
ffffffffc020211e:	1141                	addi	sp,sp,-16
ffffffffc0202120:	e406                	sd	ra,8(sp)
ffffffffc0202122:	e022                	sd	s0,0(sp)
ffffffffc0202124:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0202126:	811fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020212a:	0000b797          	auipc	a5,0xb
ffffffffc020212e:	38e7b783          	ld	a5,910(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0202132:	6f9c                	ld	a5,24(a5)
ffffffffc0202134:	8522                	mv	a0,s0
ffffffffc0202136:	9782                	jalr	a5
ffffffffc0202138:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020213a:	ff6fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020213e:	60a2                	ld	ra,8(sp)
ffffffffc0202140:	8522                	mv	a0,s0
ffffffffc0202142:	6402                	ld	s0,0(sp)
ffffffffc0202144:	0141                	addi	sp,sp,16
ffffffffc0202146:	8082                	ret

ffffffffc0202148 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202148:	100027f3          	csrr	a5,sstatus
ffffffffc020214c:	8b89                	andi	a5,a5,2
ffffffffc020214e:	e799                	bnez	a5,ffffffffc020215c <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0202150:	0000b797          	auipc	a5,0xb
ffffffffc0202154:	3687b783          	ld	a5,872(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0202158:	739c                	ld	a5,32(a5)
ffffffffc020215a:	8782                	jr	a5
{
ffffffffc020215c:	1101                	addi	sp,sp,-32
ffffffffc020215e:	ec06                	sd	ra,24(sp)
ffffffffc0202160:	e822                	sd	s0,16(sp)
ffffffffc0202162:	e426                	sd	s1,8(sp)
ffffffffc0202164:	842a                	mv	s0,a0
ffffffffc0202166:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202168:	fcefe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020216c:	0000b797          	auipc	a5,0xb
ffffffffc0202170:	34c7b783          	ld	a5,844(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0202174:	739c                	ld	a5,32(a5)
ffffffffc0202176:	85a6                	mv	a1,s1
ffffffffc0202178:	8522                	mv	a0,s0
ffffffffc020217a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc020217c:	6442                	ld	s0,16(sp)
ffffffffc020217e:	60e2                	ld	ra,24(sp)
ffffffffc0202180:	64a2                	ld	s1,8(sp)
ffffffffc0202182:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202184:	facfe06f          	j	ffffffffc0200930 <intr_enable>

ffffffffc0202188 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202188:	100027f3          	csrr	a5,sstatus
ffffffffc020218c:	8b89                	andi	a5,a5,2
ffffffffc020218e:	e799                	bnez	a5,ffffffffc020219c <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0202190:	0000b797          	auipc	a5,0xb
ffffffffc0202194:	3287b783          	ld	a5,808(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0202198:	779c                	ld	a5,40(a5)
ffffffffc020219a:	8782                	jr	a5
{
ffffffffc020219c:	1141                	addi	sp,sp,-16
ffffffffc020219e:	e406                	sd	ra,8(sp)
ffffffffc02021a0:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02021a2:	f94fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02021a6:	0000b797          	auipc	a5,0xb
ffffffffc02021aa:	3127b783          	ld	a5,786(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02021ae:	779c                	ld	a5,40(a5)
ffffffffc02021b0:	9782                	jalr	a5
ffffffffc02021b2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02021b4:	f7cfe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02021b8:	60a2                	ld	ra,8(sp)
ffffffffc02021ba:	8522                	mv	a0,s0
ffffffffc02021bc:	6402                	ld	s0,0(sp)
ffffffffc02021be:	0141                	addi	sp,sp,16
ffffffffc02021c0:	8082                	ret

ffffffffc02021c2 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02021c2:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02021c6:	1ff7f793          	andi	a5,a5,511
{
ffffffffc02021ca:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02021cc:	078e                	slli	a5,a5,0x3
{
ffffffffc02021ce:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02021d0:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc02021d4:	6094                	ld	a3,0(s1)
{
ffffffffc02021d6:	f04a                	sd	s2,32(sp)
ffffffffc02021d8:	ec4e                	sd	s3,24(sp)
ffffffffc02021da:	e852                	sd	s4,16(sp)
ffffffffc02021dc:	fc06                	sd	ra,56(sp)
ffffffffc02021de:	f822                	sd	s0,48(sp)
ffffffffc02021e0:	e456                	sd	s5,8(sp)
ffffffffc02021e2:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc02021e4:	0016f793          	andi	a5,a3,1
{
ffffffffc02021e8:	892e                	mv	s2,a1
ffffffffc02021ea:	8a32                	mv	s4,a2
ffffffffc02021ec:	0000b997          	auipc	s3,0xb
ffffffffc02021f0:	2bc98993          	addi	s3,s3,700 # ffffffffc020d4a8 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc02021f4:	efbd                	bnez	a5,ffffffffc0202272 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02021f6:	14060c63          	beqz	a2,ffffffffc020234e <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02021fa:	100027f3          	csrr	a5,sstatus
ffffffffc02021fe:	8b89                	andi	a5,a5,2
ffffffffc0202200:	14079963          	bnez	a5,ffffffffc0202352 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202204:	0000b797          	auipc	a5,0xb
ffffffffc0202208:	2b47b783          	ld	a5,692(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc020220c:	6f9c                	ld	a5,24(a5)
ffffffffc020220e:	4505                	li	a0,1
ffffffffc0202210:	9782                	jalr	a5
ffffffffc0202212:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202214:	12040d63          	beqz	s0,ffffffffc020234e <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202218:	0000bb17          	auipc	s6,0xb
ffffffffc020221c:	298b0b13          	addi	s6,s6,664 # ffffffffc020d4b0 <pages>
ffffffffc0202220:	000b3503          	ld	a0,0(s6)
ffffffffc0202224:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202228:	0000b997          	auipc	s3,0xb
ffffffffc020222c:	28098993          	addi	s3,s3,640 # ffffffffc020d4a8 <npage>
ffffffffc0202230:	40a40533          	sub	a0,s0,a0
ffffffffc0202234:	8519                	srai	a0,a0,0x6
ffffffffc0202236:	9556                	add	a0,a0,s5
ffffffffc0202238:	0009b703          	ld	a4,0(s3)
ffffffffc020223c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202240:	4685                	li	a3,1
ffffffffc0202242:	c014                	sw	a3,0(s0)
ffffffffc0202244:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202246:	0532                	slli	a0,a0,0xc
ffffffffc0202248:	16e7f763          	bgeu	a5,a4,ffffffffc02023b6 <get_pte+0x1f4>
ffffffffc020224c:	0000b797          	auipc	a5,0xb
ffffffffc0202250:	2747b783          	ld	a5,628(a5) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0202254:	6605                	lui	a2,0x1
ffffffffc0202256:	4581                	li	a1,0
ffffffffc0202258:	953e                	add	a0,a0,a5
ffffffffc020225a:	7e2010ef          	jal	ra,ffffffffc0203a3c <memset>
    return page - pages + nbase;
ffffffffc020225e:	000b3683          	ld	a3,0(s6)
ffffffffc0202262:	40d406b3          	sub	a3,s0,a3
ffffffffc0202266:	8699                	srai	a3,a3,0x6
ffffffffc0202268:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020226a:	06aa                	slli	a3,a3,0xa
ffffffffc020226c:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202270:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202272:	77fd                	lui	a5,0xfffff
ffffffffc0202274:	068a                	slli	a3,a3,0x2
ffffffffc0202276:	0009b703          	ld	a4,0(s3)
ffffffffc020227a:	8efd                	and	a3,a3,a5
ffffffffc020227c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202280:	10e7ff63          	bgeu	a5,a4,ffffffffc020239e <get_pte+0x1dc>
ffffffffc0202284:	0000ba97          	auipc	s5,0xb
ffffffffc0202288:	23ca8a93          	addi	s5,s5,572 # ffffffffc020d4c0 <va_pa_offset>
ffffffffc020228c:	000ab403          	ld	s0,0(s5)
ffffffffc0202290:	01595793          	srli	a5,s2,0x15
ffffffffc0202294:	1ff7f793          	andi	a5,a5,511
ffffffffc0202298:	96a2                	add	a3,a3,s0
ffffffffc020229a:	00379413          	slli	s0,a5,0x3
ffffffffc020229e:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02022a0:	6014                	ld	a3,0(s0)
ffffffffc02022a2:	0016f793          	andi	a5,a3,1
ffffffffc02022a6:	ebad                	bnez	a5,ffffffffc0202318 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02022a8:	0a0a0363          	beqz	s4,ffffffffc020234e <get_pte+0x18c>
ffffffffc02022ac:	100027f3          	csrr	a5,sstatus
ffffffffc02022b0:	8b89                	andi	a5,a5,2
ffffffffc02022b2:	efcd                	bnez	a5,ffffffffc020236c <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022b4:	0000b797          	auipc	a5,0xb
ffffffffc02022b8:	2047b783          	ld	a5,516(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02022bc:	6f9c                	ld	a5,24(a5)
ffffffffc02022be:	4505                	li	a0,1
ffffffffc02022c0:	9782                	jalr	a5
ffffffffc02022c2:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02022c4:	c4c9                	beqz	s1,ffffffffc020234e <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02022c6:	0000bb17          	auipc	s6,0xb
ffffffffc02022ca:	1eab0b13          	addi	s6,s6,490 # ffffffffc020d4b0 <pages>
ffffffffc02022ce:	000b3503          	ld	a0,0(s6)
ffffffffc02022d2:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02022d6:	0009b703          	ld	a4,0(s3)
ffffffffc02022da:	40a48533          	sub	a0,s1,a0
ffffffffc02022de:	8519                	srai	a0,a0,0x6
ffffffffc02022e0:	9552                	add	a0,a0,s4
ffffffffc02022e2:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02022e6:	4685                	li	a3,1
ffffffffc02022e8:	c094                	sw	a3,0(s1)
ffffffffc02022ea:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02022ec:	0532                	slli	a0,a0,0xc
ffffffffc02022ee:	0ee7f163          	bgeu	a5,a4,ffffffffc02023d0 <get_pte+0x20e>
ffffffffc02022f2:	000ab783          	ld	a5,0(s5)
ffffffffc02022f6:	6605                	lui	a2,0x1
ffffffffc02022f8:	4581                	li	a1,0
ffffffffc02022fa:	953e                	add	a0,a0,a5
ffffffffc02022fc:	740010ef          	jal	ra,ffffffffc0203a3c <memset>
    return page - pages + nbase;
ffffffffc0202300:	000b3683          	ld	a3,0(s6)
ffffffffc0202304:	40d486b3          	sub	a3,s1,a3
ffffffffc0202308:	8699                	srai	a3,a3,0x6
ffffffffc020230a:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020230c:	06aa                	slli	a3,a3,0xa
ffffffffc020230e:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202312:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202314:	0009b703          	ld	a4,0(s3)
ffffffffc0202318:	068a                	slli	a3,a3,0x2
ffffffffc020231a:	757d                	lui	a0,0xfffff
ffffffffc020231c:	8ee9                	and	a3,a3,a0
ffffffffc020231e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202322:	06e7f263          	bgeu	a5,a4,ffffffffc0202386 <get_pte+0x1c4>
ffffffffc0202326:	000ab503          	ld	a0,0(s5)
ffffffffc020232a:	00c95913          	srli	s2,s2,0xc
ffffffffc020232e:	1ff97913          	andi	s2,s2,511
ffffffffc0202332:	96aa                	add	a3,a3,a0
ffffffffc0202334:	00391513          	slli	a0,s2,0x3
ffffffffc0202338:	9536                	add	a0,a0,a3
}
ffffffffc020233a:	70e2                	ld	ra,56(sp)
ffffffffc020233c:	7442                	ld	s0,48(sp)
ffffffffc020233e:	74a2                	ld	s1,40(sp)
ffffffffc0202340:	7902                	ld	s2,32(sp)
ffffffffc0202342:	69e2                	ld	s3,24(sp)
ffffffffc0202344:	6a42                	ld	s4,16(sp)
ffffffffc0202346:	6aa2                	ld	s5,8(sp)
ffffffffc0202348:	6b02                	ld	s6,0(sp)
ffffffffc020234a:	6121                	addi	sp,sp,64
ffffffffc020234c:	8082                	ret
            return NULL;
ffffffffc020234e:	4501                	li	a0,0
ffffffffc0202350:	b7ed                	j	ffffffffc020233a <get_pte+0x178>
        intr_disable();
ffffffffc0202352:	de4fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202356:	0000b797          	auipc	a5,0xb
ffffffffc020235a:	1627b783          	ld	a5,354(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc020235e:	6f9c                	ld	a5,24(a5)
ffffffffc0202360:	4505                	li	a0,1
ffffffffc0202362:	9782                	jalr	a5
ffffffffc0202364:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202366:	dcafe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc020236a:	b56d                	j	ffffffffc0202214 <get_pte+0x52>
        intr_disable();
ffffffffc020236c:	dcafe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0202370:	0000b797          	auipc	a5,0xb
ffffffffc0202374:	1487b783          	ld	a5,328(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0202378:	6f9c                	ld	a5,24(a5)
ffffffffc020237a:	4505                	li	a0,1
ffffffffc020237c:	9782                	jalr	a5
ffffffffc020237e:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0202380:	db0fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202384:	b781                	j	ffffffffc02022c4 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202386:	00002617          	auipc	a2,0x2
ffffffffc020238a:	7ba60613          	addi	a2,a2,1978 # ffffffffc0204b40 <commands+0xa28>
ffffffffc020238e:	0fb00593          	li	a1,251
ffffffffc0202392:	00003517          	auipc	a0,0x3
ffffffffc0202396:	ca650513          	addi	a0,a0,-858 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020239a:	e45fd0ef          	jal	ra,ffffffffc02001de <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020239e:	00002617          	auipc	a2,0x2
ffffffffc02023a2:	7a260613          	addi	a2,a2,1954 # ffffffffc0204b40 <commands+0xa28>
ffffffffc02023a6:	0ee00593          	li	a1,238
ffffffffc02023aa:	00003517          	auipc	a0,0x3
ffffffffc02023ae:	c8e50513          	addi	a0,a0,-882 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02023b2:	e2dfd0ef          	jal	ra,ffffffffc02001de <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02023b6:	86aa                	mv	a3,a0
ffffffffc02023b8:	00002617          	auipc	a2,0x2
ffffffffc02023bc:	78860613          	addi	a2,a2,1928 # ffffffffc0204b40 <commands+0xa28>
ffffffffc02023c0:	0eb00593          	li	a1,235
ffffffffc02023c4:	00003517          	auipc	a0,0x3
ffffffffc02023c8:	c7450513          	addi	a0,a0,-908 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02023cc:	e13fd0ef          	jal	ra,ffffffffc02001de <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02023d0:	86aa                	mv	a3,a0
ffffffffc02023d2:	00002617          	auipc	a2,0x2
ffffffffc02023d6:	76e60613          	addi	a2,a2,1902 # ffffffffc0204b40 <commands+0xa28>
ffffffffc02023da:	0f800593          	li	a1,248
ffffffffc02023de:	00003517          	auipc	a0,0x3
ffffffffc02023e2:	c5a50513          	addi	a0,a0,-934 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02023e6:	df9fd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02023ea <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02023ea:	1141                	addi	sp,sp,-16
ffffffffc02023ec:	e022                	sd	s0,0(sp)
ffffffffc02023ee:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02023f0:	4601                	li	a2,0
{
ffffffffc02023f2:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02023f4:	dcfff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
    if (ptep_store != NULL)
ffffffffc02023f8:	c011                	beqz	s0,ffffffffc02023fc <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02023fa:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02023fc:	c511                	beqz	a0,ffffffffc0202408 <get_page+0x1e>
ffffffffc02023fe:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202400:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202402:	0017f713          	andi	a4,a5,1
ffffffffc0202406:	e709                	bnez	a4,ffffffffc0202410 <get_page+0x26>
}
ffffffffc0202408:	60a2                	ld	ra,8(sp)
ffffffffc020240a:	6402                	ld	s0,0(sp)
ffffffffc020240c:	0141                	addi	sp,sp,16
ffffffffc020240e:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202410:	078a                	slli	a5,a5,0x2
ffffffffc0202412:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202414:	0000b717          	auipc	a4,0xb
ffffffffc0202418:	09473703          	ld	a4,148(a4) # ffffffffc020d4a8 <npage>
ffffffffc020241c:	00e7ff63          	bgeu	a5,a4,ffffffffc020243a <get_page+0x50>
ffffffffc0202420:	60a2                	ld	ra,8(sp)
ffffffffc0202422:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0202424:	fff80537          	lui	a0,0xfff80
ffffffffc0202428:	97aa                	add	a5,a5,a0
ffffffffc020242a:	079a                	slli	a5,a5,0x6
ffffffffc020242c:	0000b517          	auipc	a0,0xb
ffffffffc0202430:	08453503          	ld	a0,132(a0) # ffffffffc020d4b0 <pages>
ffffffffc0202434:	953e                	add	a0,a0,a5
ffffffffc0202436:	0141                	addi	sp,sp,16
ffffffffc0202438:	8082                	ret
ffffffffc020243a:	c99ff0ef          	jal	ra,ffffffffc02020d2 <pa2page.part.0>

ffffffffc020243e <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc020243e:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202440:	4601                	li	a2,0
{
ffffffffc0202442:	ec26                	sd	s1,24(sp)
ffffffffc0202444:	f406                	sd	ra,40(sp)
ffffffffc0202446:	f022                	sd	s0,32(sp)
ffffffffc0202448:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020244a:	d79ff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
    if (ptep != NULL)
ffffffffc020244e:	c511                	beqz	a0,ffffffffc020245a <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202450:	611c                	ld	a5,0(a0)
ffffffffc0202452:	842a                	mv	s0,a0
ffffffffc0202454:	0017f713          	andi	a4,a5,1
ffffffffc0202458:	e711                	bnez	a4,ffffffffc0202464 <page_remove+0x26>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc020245a:	70a2                	ld	ra,40(sp)
ffffffffc020245c:	7402                	ld	s0,32(sp)
ffffffffc020245e:	64e2                	ld	s1,24(sp)
ffffffffc0202460:	6145                	addi	sp,sp,48
ffffffffc0202462:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202464:	078a                	slli	a5,a5,0x2
ffffffffc0202466:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202468:	0000b717          	auipc	a4,0xb
ffffffffc020246c:	04073703          	ld	a4,64(a4) # ffffffffc020d4a8 <npage>
ffffffffc0202470:	06e7f363          	bgeu	a5,a4,ffffffffc02024d6 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202474:	fff80537          	lui	a0,0xfff80
ffffffffc0202478:	97aa                	add	a5,a5,a0
ffffffffc020247a:	079a                	slli	a5,a5,0x6
ffffffffc020247c:	0000b517          	auipc	a0,0xb
ffffffffc0202480:	03453503          	ld	a0,52(a0) # ffffffffc020d4b0 <pages>
ffffffffc0202484:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202486:	411c                	lw	a5,0(a0)
ffffffffc0202488:	fff7871b          	addiw	a4,a5,-1
ffffffffc020248c:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc020248e:	cb11                	beqz	a4,ffffffffc02024a2 <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202490:	00043023          	sd	zero,0(s0)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202494:	12048073          	sfence.vma	s1
}
ffffffffc0202498:	70a2                	ld	ra,40(sp)
ffffffffc020249a:	7402                	ld	s0,32(sp)
ffffffffc020249c:	64e2                	ld	s1,24(sp)
ffffffffc020249e:	6145                	addi	sp,sp,48
ffffffffc02024a0:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02024a2:	100027f3          	csrr	a5,sstatus
ffffffffc02024a6:	8b89                	andi	a5,a5,2
ffffffffc02024a8:	eb89                	bnez	a5,ffffffffc02024ba <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02024aa:	0000b797          	auipc	a5,0xb
ffffffffc02024ae:	00e7b783          	ld	a5,14(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02024b2:	739c                	ld	a5,32(a5)
ffffffffc02024b4:	4585                	li	a1,1
ffffffffc02024b6:	9782                	jalr	a5
    if (flag) {
ffffffffc02024b8:	bfe1                	j	ffffffffc0202490 <page_remove+0x52>
        intr_disable();
ffffffffc02024ba:	e42a                	sd	a0,8(sp)
ffffffffc02024bc:	c7afe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02024c0:	0000b797          	auipc	a5,0xb
ffffffffc02024c4:	ff87b783          	ld	a5,-8(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02024c8:	739c                	ld	a5,32(a5)
ffffffffc02024ca:	6522                	ld	a0,8(sp)
ffffffffc02024cc:	4585                	li	a1,1
ffffffffc02024ce:	9782                	jalr	a5
        intr_enable();
ffffffffc02024d0:	c60fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02024d4:	bf75                	j	ffffffffc0202490 <page_remove+0x52>
ffffffffc02024d6:	bfdff0ef          	jal	ra,ffffffffc02020d2 <pa2page.part.0>

ffffffffc02024da <page_insert>:
{
ffffffffc02024da:	7139                	addi	sp,sp,-64
ffffffffc02024dc:	e852                	sd	s4,16(sp)
ffffffffc02024de:	8a32                	mv	s4,a2
ffffffffc02024e0:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02024e2:	4605                	li	a2,1
{
ffffffffc02024e4:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02024e6:	85d2                	mv	a1,s4
{
ffffffffc02024e8:	f426                	sd	s1,40(sp)
ffffffffc02024ea:	fc06                	sd	ra,56(sp)
ffffffffc02024ec:	f04a                	sd	s2,32(sp)
ffffffffc02024ee:	ec4e                	sd	s3,24(sp)
ffffffffc02024f0:	e456                	sd	s5,8(sp)
ffffffffc02024f2:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02024f4:	ccfff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
    if (ptep == NULL)
ffffffffc02024f8:	c961                	beqz	a0,ffffffffc02025c8 <page_insert+0xee>
    page->ref += 1;
ffffffffc02024fa:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02024fc:	611c                	ld	a5,0(a0)
ffffffffc02024fe:	89aa                	mv	s3,a0
ffffffffc0202500:	0016871b          	addiw	a4,a3,1
ffffffffc0202504:	c018                	sw	a4,0(s0)
ffffffffc0202506:	0017f713          	andi	a4,a5,1
ffffffffc020250a:	ef05                	bnez	a4,ffffffffc0202542 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc020250c:	0000b717          	auipc	a4,0xb
ffffffffc0202510:	fa473703          	ld	a4,-92(a4) # ffffffffc020d4b0 <pages>
ffffffffc0202514:	8c19                	sub	s0,s0,a4
ffffffffc0202516:	000807b7          	lui	a5,0x80
ffffffffc020251a:	8419                	srai	s0,s0,0x6
ffffffffc020251c:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020251e:	042a                	slli	s0,s0,0xa
ffffffffc0202520:	8cc1                	or	s1,s1,s0
ffffffffc0202522:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202526:	0099b023          	sd	s1,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020252a:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc020252e:	4501                	li	a0,0
}
ffffffffc0202530:	70e2                	ld	ra,56(sp)
ffffffffc0202532:	7442                	ld	s0,48(sp)
ffffffffc0202534:	74a2                	ld	s1,40(sp)
ffffffffc0202536:	7902                	ld	s2,32(sp)
ffffffffc0202538:	69e2                	ld	s3,24(sp)
ffffffffc020253a:	6a42                	ld	s4,16(sp)
ffffffffc020253c:	6aa2                	ld	s5,8(sp)
ffffffffc020253e:	6121                	addi	sp,sp,64
ffffffffc0202540:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202542:	078a                	slli	a5,a5,0x2
ffffffffc0202544:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202546:	0000b717          	auipc	a4,0xb
ffffffffc020254a:	f6273703          	ld	a4,-158(a4) # ffffffffc020d4a8 <npage>
ffffffffc020254e:	06e7ff63          	bgeu	a5,a4,ffffffffc02025cc <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202552:	0000ba97          	auipc	s5,0xb
ffffffffc0202556:	f5ea8a93          	addi	s5,s5,-162 # ffffffffc020d4b0 <pages>
ffffffffc020255a:	000ab703          	ld	a4,0(s5)
ffffffffc020255e:	fff80937          	lui	s2,0xfff80
ffffffffc0202562:	993e                	add	s2,s2,a5
ffffffffc0202564:	091a                	slli	s2,s2,0x6
ffffffffc0202566:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0202568:	01240c63          	beq	s0,s2,ffffffffc0202580 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020256c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd72b1c>
ffffffffc0202570:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202574:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0202578:	c691                	beqz	a3,ffffffffc0202584 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020257a:	120a0073          	sfence.vma	s4
}
ffffffffc020257e:	bf59                	j	ffffffffc0202514 <page_insert+0x3a>
ffffffffc0202580:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202582:	bf49                	j	ffffffffc0202514 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202584:	100027f3          	csrr	a5,sstatus
ffffffffc0202588:	8b89                	andi	a5,a5,2
ffffffffc020258a:	ef91                	bnez	a5,ffffffffc02025a6 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020258c:	0000b797          	auipc	a5,0xb
ffffffffc0202590:	f2c7b783          	ld	a5,-212(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0202594:	739c                	ld	a5,32(a5)
ffffffffc0202596:	4585                	li	a1,1
ffffffffc0202598:	854a                	mv	a0,s2
ffffffffc020259a:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020259c:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025a0:	120a0073          	sfence.vma	s4
ffffffffc02025a4:	bf85                	j	ffffffffc0202514 <page_insert+0x3a>
        intr_disable();
ffffffffc02025a6:	b90fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025aa:	0000b797          	auipc	a5,0xb
ffffffffc02025ae:	f0e7b783          	ld	a5,-242(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02025b2:	739c                	ld	a5,32(a5)
ffffffffc02025b4:	4585                	li	a1,1
ffffffffc02025b6:	854a                	mv	a0,s2
ffffffffc02025b8:	9782                	jalr	a5
        intr_enable();
ffffffffc02025ba:	b76fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02025be:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025c2:	120a0073          	sfence.vma	s4
ffffffffc02025c6:	b7b9                	j	ffffffffc0202514 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc02025c8:	5571                	li	a0,-4
ffffffffc02025ca:	b79d                	j	ffffffffc0202530 <page_insert+0x56>
ffffffffc02025cc:	b07ff0ef          	jal	ra,ffffffffc02020d2 <pa2page.part.0>

ffffffffc02025d0 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02025d0:	00003797          	auipc	a5,0x3
ffffffffc02025d4:	a0878793          	addi	a5,a5,-1528 # ffffffffc0204fd8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02025d8:	638c                	ld	a1,0(a5)
{
ffffffffc02025da:	7159                	addi	sp,sp,-112
ffffffffc02025dc:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02025de:	00003517          	auipc	a0,0x3
ffffffffc02025e2:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0205048 <default_pmm_manager+0x70>
    pmm_manager = &default_pmm_manager;
ffffffffc02025e6:	0000bb17          	auipc	s6,0xb
ffffffffc02025ea:	ed2b0b13          	addi	s6,s6,-302 # ffffffffc020d4b8 <pmm_manager>
{
ffffffffc02025ee:	f486                	sd	ra,104(sp)
ffffffffc02025f0:	e8ca                	sd	s2,80(sp)
ffffffffc02025f2:	e4ce                	sd	s3,72(sp)
ffffffffc02025f4:	f0a2                	sd	s0,96(sp)
ffffffffc02025f6:	eca6                	sd	s1,88(sp)
ffffffffc02025f8:	e0d2                	sd	s4,64(sp)
ffffffffc02025fa:	fc56                	sd	s5,56(sp)
ffffffffc02025fc:	f45e                	sd	s7,40(sp)
ffffffffc02025fe:	f062                	sd	s8,32(sp)
ffffffffc0202600:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202602:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202606:	adbfd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    pmm_manager->init();
ffffffffc020260a:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020260e:	0000b997          	auipc	s3,0xb
ffffffffc0202612:	eb298993          	addi	s3,s3,-334 # ffffffffc020d4c0 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202616:	679c                	ld	a5,8(a5)
ffffffffc0202618:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020261a:	57f5                	li	a5,-3
ffffffffc020261c:	07fa                	slli	a5,a5,0x1e
ffffffffc020261e:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202622:	a32fe0ef          	jal	ra,ffffffffc0200854 <get_memory_base>
ffffffffc0202626:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0202628:	a36fe0ef          	jal	ra,ffffffffc020085e <get_memory_size>
    if (mem_size == 0) {
ffffffffc020262c:	200505e3          	beqz	a0,ffffffffc0203036 <pmm_init+0xa66>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0202630:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202632:	00003517          	auipc	a0,0x3
ffffffffc0202636:	a4e50513          	addi	a0,a0,-1458 # ffffffffc0205080 <default_pmm_manager+0xa8>
ffffffffc020263a:	aa7fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020263e:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202642:	fff40693          	addi	a3,s0,-1
ffffffffc0202646:	864a                	mv	a2,s2
ffffffffc0202648:	85a6                	mv	a1,s1
ffffffffc020264a:	00003517          	auipc	a0,0x3
ffffffffc020264e:	a4e50513          	addi	a0,a0,-1458 # ffffffffc0205098 <default_pmm_manager+0xc0>
ffffffffc0202652:	a8ffd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202656:	c8000737          	lui	a4,0xc8000
ffffffffc020265a:	87a2                	mv	a5,s0
ffffffffc020265c:	54876163          	bltu	a4,s0,ffffffffc0202b9e <pmm_init+0x5ce>
ffffffffc0202660:	757d                	lui	a0,0xfffff
ffffffffc0202662:	0000c617          	auipc	a2,0xc
ffffffffc0202666:	e8160613          	addi	a2,a2,-383 # ffffffffc020e4e3 <end+0xfff>
ffffffffc020266a:	8e69                	and	a2,a2,a0
ffffffffc020266c:	0000b497          	auipc	s1,0xb
ffffffffc0202670:	e3c48493          	addi	s1,s1,-452 # ffffffffc020d4a8 <npage>
ffffffffc0202674:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202678:	0000bb97          	auipc	s7,0xb
ffffffffc020267c:	e38b8b93          	addi	s7,s7,-456 # ffffffffc020d4b0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202680:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202682:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202686:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020268a:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020268c:	02f50863          	beq	a0,a5,ffffffffc02026bc <pmm_init+0xec>
ffffffffc0202690:	4781                	li	a5,0
ffffffffc0202692:	4585                	li	a1,1
ffffffffc0202694:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202698:	00679513          	slli	a0,a5,0x6
ffffffffc020269c:	9532                	add	a0,a0,a2
ffffffffc020269e:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fdf1b24>
ffffffffc02026a2:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026a6:	6088                	ld	a0,0(s1)
ffffffffc02026a8:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc02026aa:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02026ae:	00d50733          	add	a4,a0,a3
ffffffffc02026b2:	fee7e3e3          	bltu	a5,a4,ffffffffc0202698 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02026b6:	071a                	slli	a4,a4,0x6
ffffffffc02026b8:	00e606b3          	add	a3,a2,a4
ffffffffc02026bc:	c02007b7          	lui	a5,0xc0200
ffffffffc02026c0:	2ef6ece3          	bltu	a3,a5,ffffffffc02031b8 <pmm_init+0xbe8>
ffffffffc02026c4:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02026c8:	77fd                	lui	a5,0xfffff
ffffffffc02026ca:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02026cc:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02026ce:	5086eb63          	bltu	a3,s0,ffffffffc0202be4 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02026d2:	00003517          	auipc	a0,0x3
ffffffffc02026d6:	9ee50513          	addi	a0,a0,-1554 # ffffffffc02050c0 <default_pmm_manager+0xe8>
ffffffffc02026da:	a07fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02026de:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02026e2:	0000b917          	auipc	s2,0xb
ffffffffc02026e6:	dbe90913          	addi	s2,s2,-578 # ffffffffc020d4a0 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02026ea:	7b9c                	ld	a5,48(a5)
ffffffffc02026ec:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02026ee:	00003517          	auipc	a0,0x3
ffffffffc02026f2:	9ea50513          	addi	a0,a0,-1558 # ffffffffc02050d8 <default_pmm_manager+0x100>
ffffffffc02026f6:	9ebfd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02026fa:	00006697          	auipc	a3,0x6
ffffffffc02026fe:	90668693          	addi	a3,a3,-1786 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202702:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202706:	c02007b7          	lui	a5,0xc0200
ffffffffc020270a:	28f6ebe3          	bltu	a3,a5,ffffffffc02031a0 <pmm_init+0xbd0>
ffffffffc020270e:	0009b783          	ld	a5,0(s3)
ffffffffc0202712:	8e9d                	sub	a3,a3,a5
ffffffffc0202714:	0000b797          	auipc	a5,0xb
ffffffffc0202718:	d8d7b223          	sd	a3,-636(a5) # ffffffffc020d498 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020271c:	100027f3          	csrr	a5,sstatus
ffffffffc0202720:	8b89                	andi	a5,a5,2
ffffffffc0202722:	4a079763          	bnez	a5,ffffffffc0202bd0 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202726:	000b3783          	ld	a5,0(s6)
ffffffffc020272a:	779c                	ld	a5,40(a5)
ffffffffc020272c:	9782                	jalr	a5
ffffffffc020272e:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202730:	6098                	ld	a4,0(s1)
ffffffffc0202732:	c80007b7          	lui	a5,0xc8000
ffffffffc0202736:	83b1                	srli	a5,a5,0xc
ffffffffc0202738:	66e7e363          	bltu	a5,a4,ffffffffc0202d9e <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020273c:	00093503          	ld	a0,0(s2)
ffffffffc0202740:	62050f63          	beqz	a0,ffffffffc0202d7e <pmm_init+0x7ae>
ffffffffc0202744:	03451793          	slli	a5,a0,0x34
ffffffffc0202748:	62079b63          	bnez	a5,ffffffffc0202d7e <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020274c:	4601                	li	a2,0
ffffffffc020274e:	4581                	li	a1,0
ffffffffc0202750:	c9bff0ef          	jal	ra,ffffffffc02023ea <get_page>
ffffffffc0202754:	60051563          	bnez	a0,ffffffffc0202d5e <pmm_init+0x78e>
ffffffffc0202758:	100027f3          	csrr	a5,sstatus
ffffffffc020275c:	8b89                	andi	a5,a5,2
ffffffffc020275e:	44079e63          	bnez	a5,ffffffffc0202bba <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202762:	000b3783          	ld	a5,0(s6)
ffffffffc0202766:	4505                	li	a0,1
ffffffffc0202768:	6f9c                	ld	a5,24(a5)
ffffffffc020276a:	9782                	jalr	a5
ffffffffc020276c:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc020276e:	00093503          	ld	a0,0(s2)
ffffffffc0202772:	4681                	li	a3,0
ffffffffc0202774:	4601                	li	a2,0
ffffffffc0202776:	85d2                	mv	a1,s4
ffffffffc0202778:	d63ff0ef          	jal	ra,ffffffffc02024da <page_insert>
ffffffffc020277c:	26051ae3          	bnez	a0,ffffffffc02031f0 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202780:	00093503          	ld	a0,0(s2)
ffffffffc0202784:	4601                	li	a2,0
ffffffffc0202786:	4581                	li	a1,0
ffffffffc0202788:	a3bff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
ffffffffc020278c:	240502e3          	beqz	a0,ffffffffc02031d0 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202790:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202792:	0017f713          	andi	a4,a5,1
ffffffffc0202796:	5a070263          	beqz	a4,ffffffffc0202d3a <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020279a:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020279c:	078a                	slli	a5,a5,0x2
ffffffffc020279e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027a0:	58e7fb63          	bgeu	a5,a4,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02027a4:	000bb683          	ld	a3,0(s7)
ffffffffc02027a8:	fff80637          	lui	a2,0xfff80
ffffffffc02027ac:	97b2                	add	a5,a5,a2
ffffffffc02027ae:	079a                	slli	a5,a5,0x6
ffffffffc02027b0:	97b6                	add	a5,a5,a3
ffffffffc02027b2:	14fa17e3          	bne	s4,a5,ffffffffc0203100 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc02027b6:	000a2683          	lw	a3,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc02027ba:	4785                	li	a5,1
ffffffffc02027bc:	12f692e3          	bne	a3,a5,ffffffffc02030e0 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02027c0:	00093503          	ld	a0,0(s2)
ffffffffc02027c4:	77fd                	lui	a5,0xfffff
ffffffffc02027c6:	6114                	ld	a3,0(a0)
ffffffffc02027c8:	068a                	slli	a3,a3,0x2
ffffffffc02027ca:	8efd                	and	a3,a3,a5
ffffffffc02027cc:	00c6d613          	srli	a2,a3,0xc
ffffffffc02027d0:	0ee67ce3          	bgeu	a2,a4,ffffffffc02030c8 <pmm_init+0xaf8>
ffffffffc02027d4:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02027d8:	96e2                	add	a3,a3,s8
ffffffffc02027da:	0006ba83          	ld	s5,0(a3)
ffffffffc02027de:	0a8a                	slli	s5,s5,0x2
ffffffffc02027e0:	00fafab3          	and	s5,s5,a5
ffffffffc02027e4:	00cad793          	srli	a5,s5,0xc
ffffffffc02027e8:	0ce7f3e3          	bgeu	a5,a4,ffffffffc02030ae <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02027ec:	4601                	li	a2,0
ffffffffc02027ee:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02027f0:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02027f2:	9d1ff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02027f6:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02027f8:	55551363          	bne	a0,s5,ffffffffc0202d3e <pmm_init+0x76e>
ffffffffc02027fc:	100027f3          	csrr	a5,sstatus
ffffffffc0202800:	8b89                	andi	a5,a5,2
ffffffffc0202802:	3a079163          	bnez	a5,ffffffffc0202ba4 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202806:	000b3783          	ld	a5,0(s6)
ffffffffc020280a:	4505                	li	a0,1
ffffffffc020280c:	6f9c                	ld	a5,24(a5)
ffffffffc020280e:	9782                	jalr	a5
ffffffffc0202810:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202812:	00093503          	ld	a0,0(s2)
ffffffffc0202816:	46d1                	li	a3,20
ffffffffc0202818:	6605                	lui	a2,0x1
ffffffffc020281a:	85e2                	mv	a1,s8
ffffffffc020281c:	cbfff0ef          	jal	ra,ffffffffc02024da <page_insert>
ffffffffc0202820:	060517e3          	bnez	a0,ffffffffc020308e <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202824:	00093503          	ld	a0,0(s2)
ffffffffc0202828:	4601                	li	a2,0
ffffffffc020282a:	6585                	lui	a1,0x1
ffffffffc020282c:	997ff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
ffffffffc0202830:	02050fe3          	beqz	a0,ffffffffc020306e <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202834:	611c                	ld	a5,0(a0)
ffffffffc0202836:	0107f713          	andi	a4,a5,16
ffffffffc020283a:	7c070e63          	beqz	a4,ffffffffc0203016 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc020283e:	8b91                	andi	a5,a5,4
ffffffffc0202840:	7a078b63          	beqz	a5,ffffffffc0202ff6 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202844:	00093503          	ld	a0,0(s2)
ffffffffc0202848:	611c                	ld	a5,0(a0)
ffffffffc020284a:	8bc1                	andi	a5,a5,16
ffffffffc020284c:	78078563          	beqz	a5,ffffffffc0202fd6 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202850:	000c2703          	lw	a4,0(s8) # ff0000 <kern_entry-0xffffffffbf210000>
ffffffffc0202854:	4785                	li	a5,1
ffffffffc0202856:	76f71063          	bne	a4,a5,ffffffffc0202fb6 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc020285a:	4681                	li	a3,0
ffffffffc020285c:	6605                	lui	a2,0x1
ffffffffc020285e:	85d2                	mv	a1,s4
ffffffffc0202860:	c7bff0ef          	jal	ra,ffffffffc02024da <page_insert>
ffffffffc0202864:	72051963          	bnez	a0,ffffffffc0202f96 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202868:	000a2703          	lw	a4,0(s4)
ffffffffc020286c:	4789                	li	a5,2
ffffffffc020286e:	70f71463          	bne	a4,a5,ffffffffc0202f76 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202872:	000c2783          	lw	a5,0(s8)
ffffffffc0202876:	6e079063          	bnez	a5,ffffffffc0202f56 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020287a:	00093503          	ld	a0,0(s2)
ffffffffc020287e:	4601                	li	a2,0
ffffffffc0202880:	6585                	lui	a1,0x1
ffffffffc0202882:	941ff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
ffffffffc0202886:	6a050863          	beqz	a0,ffffffffc0202f36 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc020288a:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc020288c:	00177793          	andi	a5,a4,1
ffffffffc0202890:	4a078563          	beqz	a5,ffffffffc0202d3a <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202894:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202896:	00271793          	slli	a5,a4,0x2
ffffffffc020289a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020289c:	48d7fd63          	bgeu	a5,a3,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02028a0:	000bb683          	ld	a3,0(s7)
ffffffffc02028a4:	fff80ab7          	lui	s5,0xfff80
ffffffffc02028a8:	97d6                	add	a5,a5,s5
ffffffffc02028aa:	079a                	slli	a5,a5,0x6
ffffffffc02028ac:	97b6                	add	a5,a5,a3
ffffffffc02028ae:	66fa1463          	bne	s4,a5,ffffffffc0202f16 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc02028b2:	8b41                	andi	a4,a4,16
ffffffffc02028b4:	64071163          	bnez	a4,ffffffffc0202ef6 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc02028b8:	00093503          	ld	a0,0(s2)
ffffffffc02028bc:	4581                	li	a1,0
ffffffffc02028be:	b81ff0ef          	jal	ra,ffffffffc020243e <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02028c2:	000a2c83          	lw	s9,0(s4)
ffffffffc02028c6:	4785                	li	a5,1
ffffffffc02028c8:	60fc9763          	bne	s9,a5,ffffffffc0202ed6 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc02028cc:	000c2783          	lw	a5,0(s8)
ffffffffc02028d0:	5e079363          	bnez	a5,ffffffffc0202eb6 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc02028d4:	00093503          	ld	a0,0(s2)
ffffffffc02028d8:	6585                	lui	a1,0x1
ffffffffc02028da:	b65ff0ef          	jal	ra,ffffffffc020243e <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc02028de:	000a2783          	lw	a5,0(s4)
ffffffffc02028e2:	52079a63          	bnez	a5,ffffffffc0202e16 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc02028e6:	000c2783          	lw	a5,0(s8)
ffffffffc02028ea:	50079663          	bnez	a5,ffffffffc0202df6 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02028ee:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc02028f2:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02028f4:	000a3683          	ld	a3,0(s4)
ffffffffc02028f8:	068a                	slli	a3,a3,0x2
ffffffffc02028fa:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc02028fc:	42b6fd63          	bgeu	a3,a1,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202900:	000bb503          	ld	a0,0(s7)
ffffffffc0202904:	96d6                	add	a3,a3,s5
ffffffffc0202906:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202908:	00d507b3          	add	a5,a0,a3
ffffffffc020290c:	439c                	lw	a5,0(a5)
ffffffffc020290e:	4d979463          	bne	a5,s9,ffffffffc0202dd6 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202912:	8699                	srai	a3,a3,0x6
ffffffffc0202914:	00080637          	lui	a2,0x80
ffffffffc0202918:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc020291a:	00c69713          	slli	a4,a3,0xc
ffffffffc020291e:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202920:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202922:	48b77e63          	bgeu	a4,a1,ffffffffc0202dbe <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202926:	0009b703          	ld	a4,0(s3)
ffffffffc020292a:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc020292c:	629c                	ld	a5,0(a3)
ffffffffc020292e:	078a                	slli	a5,a5,0x2
ffffffffc0202930:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202932:	40b7f263          	bgeu	a5,a1,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202936:	8f91                	sub	a5,a5,a2
ffffffffc0202938:	079a                	slli	a5,a5,0x6
ffffffffc020293a:	953e                	add	a0,a0,a5
ffffffffc020293c:	100027f3          	csrr	a5,sstatus
ffffffffc0202940:	8b89                	andi	a5,a5,2
ffffffffc0202942:	30079963          	bnez	a5,ffffffffc0202c54 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202946:	000b3783          	ld	a5,0(s6)
ffffffffc020294a:	4585                	li	a1,1
ffffffffc020294c:	739c                	ld	a5,32(a5)
ffffffffc020294e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202950:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202954:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202956:	078a                	slli	a5,a5,0x2
ffffffffc0202958:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020295a:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020295e:	000bb503          	ld	a0,0(s7)
ffffffffc0202962:	fff80737          	lui	a4,0xfff80
ffffffffc0202966:	97ba                	add	a5,a5,a4
ffffffffc0202968:	079a                	slli	a5,a5,0x6
ffffffffc020296a:	953e                	add	a0,a0,a5
ffffffffc020296c:	100027f3          	csrr	a5,sstatus
ffffffffc0202970:	8b89                	andi	a5,a5,2
ffffffffc0202972:	2c079563          	bnez	a5,ffffffffc0202c3c <pmm_init+0x66c>
ffffffffc0202976:	000b3783          	ld	a5,0(s6)
ffffffffc020297a:	4585                	li	a1,1
ffffffffc020297c:	739c                	ld	a5,32(a5)
ffffffffc020297e:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202980:	00093783          	ld	a5,0(s2)
ffffffffc0202984:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b1c>
    asm volatile("sfence.vma");
ffffffffc0202988:	12000073          	sfence.vma
ffffffffc020298c:	100027f3          	csrr	a5,sstatus
ffffffffc0202990:	8b89                	andi	a5,a5,2
ffffffffc0202992:	28079b63          	bnez	a5,ffffffffc0202c28 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202996:	000b3783          	ld	a5,0(s6)
ffffffffc020299a:	779c                	ld	a5,40(a5)
ffffffffc020299c:	9782                	jalr	a5
ffffffffc020299e:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02029a0:	4b441b63          	bne	s0,s4,ffffffffc0202e56 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02029a4:	00003517          	auipc	a0,0x3
ffffffffc02029a8:	a5c50513          	addi	a0,a0,-1444 # ffffffffc0205400 <default_pmm_manager+0x428>
ffffffffc02029ac:	f34fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc02029b0:	100027f3          	csrr	a5,sstatus
ffffffffc02029b4:	8b89                	andi	a5,a5,2
ffffffffc02029b6:	24079f63          	bnez	a5,ffffffffc0202c14 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc02029ba:	000b3783          	ld	a5,0(s6)
ffffffffc02029be:	779c                	ld	a5,40(a5)
ffffffffc02029c0:	9782                	jalr	a5
ffffffffc02029c2:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02029c4:	6098                	ld	a4,0(s1)
ffffffffc02029c6:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02029ca:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02029cc:	00c71793          	slli	a5,a4,0xc
ffffffffc02029d0:	6a05                	lui	s4,0x1
ffffffffc02029d2:	02f47c63          	bgeu	s0,a5,ffffffffc0202a0a <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02029d6:	00c45793          	srli	a5,s0,0xc
ffffffffc02029da:	00093503          	ld	a0,0(s2)
ffffffffc02029de:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202cdc <pmm_init+0x70c>
ffffffffc02029e2:	0009b583          	ld	a1,0(s3)
ffffffffc02029e6:	4601                	li	a2,0
ffffffffc02029e8:	95a2                	add	a1,a1,s0
ffffffffc02029ea:	fd8ff0ef          	jal	ra,ffffffffc02021c2 <get_pte>
ffffffffc02029ee:	32050463          	beqz	a0,ffffffffc0202d16 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02029f2:	611c                	ld	a5,0(a0)
ffffffffc02029f4:	078a                	slli	a5,a5,0x2
ffffffffc02029f6:	0157f7b3          	and	a5,a5,s5
ffffffffc02029fa:	2e879e63          	bne	a5,s0,ffffffffc0202cf6 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02029fe:	6098                	ld	a4,0(s1)
ffffffffc0202a00:	9452                	add	s0,s0,s4
ffffffffc0202a02:	00c71793          	slli	a5,a4,0xc
ffffffffc0202a06:	fcf468e3          	bltu	s0,a5,ffffffffc02029d6 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202a0a:	00093783          	ld	a5,0(s2)
ffffffffc0202a0e:	639c                	ld	a5,0(a5)
ffffffffc0202a10:	42079363          	bnez	a5,ffffffffc0202e36 <pmm_init+0x866>
ffffffffc0202a14:	100027f3          	csrr	a5,sstatus
ffffffffc0202a18:	8b89                	andi	a5,a5,2
ffffffffc0202a1a:	24079963          	bnez	a5,ffffffffc0202c6c <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a1e:	000b3783          	ld	a5,0(s6)
ffffffffc0202a22:	4505                	li	a0,1
ffffffffc0202a24:	6f9c                	ld	a5,24(a5)
ffffffffc0202a26:	9782                	jalr	a5
ffffffffc0202a28:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a2a:	00093503          	ld	a0,0(s2)
ffffffffc0202a2e:	4699                	li	a3,6
ffffffffc0202a30:	10000613          	li	a2,256
ffffffffc0202a34:	85d2                	mv	a1,s4
ffffffffc0202a36:	aa5ff0ef          	jal	ra,ffffffffc02024da <page_insert>
ffffffffc0202a3a:	44051e63          	bnez	a0,ffffffffc0202e96 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202a3e:	000a2703          	lw	a4,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202a42:	4785                	li	a5,1
ffffffffc0202a44:	42f71963          	bne	a4,a5,ffffffffc0202e76 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202a48:	00093503          	ld	a0,0(s2)
ffffffffc0202a4c:	6405                	lui	s0,0x1
ffffffffc0202a4e:	4699                	li	a3,6
ffffffffc0202a50:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0202a54:	85d2                	mv	a1,s4
ffffffffc0202a56:	a85ff0ef          	jal	ra,ffffffffc02024da <page_insert>
ffffffffc0202a5a:	72051363          	bnez	a0,ffffffffc0203180 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202a5e:	000a2703          	lw	a4,0(s4)
ffffffffc0202a62:	4789                	li	a5,2
ffffffffc0202a64:	6ef71e63          	bne	a4,a5,ffffffffc0203160 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202a68:	00003597          	auipc	a1,0x3
ffffffffc0202a6c:	ae058593          	addi	a1,a1,-1312 # ffffffffc0205548 <default_pmm_manager+0x570>
ffffffffc0202a70:	10000513          	li	a0,256
ffffffffc0202a74:	75d000ef          	jal	ra,ffffffffc02039d0 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202a78:	10040593          	addi	a1,s0,256
ffffffffc0202a7c:	10000513          	li	a0,256
ffffffffc0202a80:	763000ef          	jal	ra,ffffffffc02039e2 <strcmp>
ffffffffc0202a84:	6a051e63          	bnez	a0,ffffffffc0203140 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202a88:	000bb683          	ld	a3,0(s7)
ffffffffc0202a8c:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202a90:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202a92:	40da06b3          	sub	a3,s4,a3
ffffffffc0202a96:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202a98:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202a9a:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202a9c:	8031                	srli	s0,s0,0xc
ffffffffc0202a9e:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202aa2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202aa4:	30f77d63          	bgeu	a4,a5,ffffffffc0202dbe <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202aa8:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202aac:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202ab0:	96be                	add	a3,a3,a5
ffffffffc0202ab2:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202ab6:	6e5000ef          	jal	ra,ffffffffc020399a <strlen>
ffffffffc0202aba:	66051363          	bnez	a0,ffffffffc0203120 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202abe:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202ac2:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ac4:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fdf1b1c>
ffffffffc0202ac8:	068a                	slli	a3,a3,0x2
ffffffffc0202aca:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202acc:	26f6f563          	bgeu	a3,a5,ffffffffc0202d36 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202ad0:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ad2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ad4:	2ef47563          	bgeu	s0,a5,ffffffffc0202dbe <pmm_init+0x7ee>
ffffffffc0202ad8:	0009b403          	ld	s0,0(s3)
ffffffffc0202adc:	9436                	add	s0,s0,a3
ffffffffc0202ade:	100027f3          	csrr	a5,sstatus
ffffffffc0202ae2:	8b89                	andi	a5,a5,2
ffffffffc0202ae4:	1e079163          	bnez	a5,ffffffffc0202cc6 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202ae8:	000b3783          	ld	a5,0(s6)
ffffffffc0202aec:	4585                	li	a1,1
ffffffffc0202aee:	8552                	mv	a0,s4
ffffffffc0202af0:	739c                	ld	a5,32(a5)
ffffffffc0202af2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202af4:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202af6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202af8:	078a                	slli	a5,a5,0x2
ffffffffc0202afa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202afc:	22e7fd63          	bgeu	a5,a4,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b00:	000bb503          	ld	a0,0(s7)
ffffffffc0202b04:	fff80737          	lui	a4,0xfff80
ffffffffc0202b08:	97ba                	add	a5,a5,a4
ffffffffc0202b0a:	079a                	slli	a5,a5,0x6
ffffffffc0202b0c:	953e                	add	a0,a0,a5
ffffffffc0202b0e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b12:	8b89                	andi	a5,a5,2
ffffffffc0202b14:	18079d63          	bnez	a5,ffffffffc0202cae <pmm_init+0x6de>
ffffffffc0202b18:	000b3783          	ld	a5,0(s6)
ffffffffc0202b1c:	4585                	li	a1,1
ffffffffc0202b1e:	739c                	ld	a5,32(a5)
ffffffffc0202b20:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b22:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202b26:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b28:	078a                	slli	a5,a5,0x2
ffffffffc0202b2a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b2c:	20e7f563          	bgeu	a5,a4,ffffffffc0202d36 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b30:	000bb503          	ld	a0,0(s7)
ffffffffc0202b34:	fff80737          	lui	a4,0xfff80
ffffffffc0202b38:	97ba                	add	a5,a5,a4
ffffffffc0202b3a:	079a                	slli	a5,a5,0x6
ffffffffc0202b3c:	953e                	add	a0,a0,a5
ffffffffc0202b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b42:	8b89                	andi	a5,a5,2
ffffffffc0202b44:	14079963          	bnez	a5,ffffffffc0202c96 <pmm_init+0x6c6>
ffffffffc0202b48:	000b3783          	ld	a5,0(s6)
ffffffffc0202b4c:	4585                	li	a1,1
ffffffffc0202b4e:	739c                	ld	a5,32(a5)
ffffffffc0202b50:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b52:	00093783          	ld	a5,0(s2)
ffffffffc0202b56:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202b5a:	12000073          	sfence.vma
ffffffffc0202b5e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b62:	8b89                	andi	a5,a5,2
ffffffffc0202b64:	10079f63          	bnez	a5,ffffffffc0202c82 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b68:	000b3783          	ld	a5,0(s6)
ffffffffc0202b6c:	779c                	ld	a5,40(a5)
ffffffffc0202b6e:	9782                	jalr	a5
ffffffffc0202b70:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b72:	4c8c1e63          	bne	s8,s0,ffffffffc020304e <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202b76:	00003517          	auipc	a0,0x3
ffffffffc0202b7a:	a4a50513          	addi	a0,a0,-1462 # ffffffffc02055c0 <default_pmm_manager+0x5e8>
ffffffffc0202b7e:	d62fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc0202b82:	7406                	ld	s0,96(sp)
ffffffffc0202b84:	70a6                	ld	ra,104(sp)
ffffffffc0202b86:	64e6                	ld	s1,88(sp)
ffffffffc0202b88:	6946                	ld	s2,80(sp)
ffffffffc0202b8a:	69a6                	ld	s3,72(sp)
ffffffffc0202b8c:	6a06                	ld	s4,64(sp)
ffffffffc0202b8e:	7ae2                	ld	s5,56(sp)
ffffffffc0202b90:	7b42                	ld	s6,48(sp)
ffffffffc0202b92:	7ba2                	ld	s7,40(sp)
ffffffffc0202b94:	7c02                	ld	s8,32(sp)
ffffffffc0202b96:	6ce2                	ld	s9,24(sp)
ffffffffc0202b98:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202b9a:	8c5fe06f          	j	ffffffffc020145e <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202b9e:	c80007b7          	lui	a5,0xc8000
ffffffffc0202ba2:	bc7d                	j	ffffffffc0202660 <pmm_init+0x90>
        intr_disable();
ffffffffc0202ba4:	d93fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202ba8:	000b3783          	ld	a5,0(s6)
ffffffffc0202bac:	4505                	li	a0,1
ffffffffc0202bae:	6f9c                	ld	a5,24(a5)
ffffffffc0202bb0:	9782                	jalr	a5
ffffffffc0202bb2:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202bb4:	d7dfd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202bb8:	b9a9                	j	ffffffffc0202812 <pmm_init+0x242>
        intr_disable();
ffffffffc0202bba:	d7dfd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0202bbe:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc2:	4505                	li	a0,1
ffffffffc0202bc4:	6f9c                	ld	a5,24(a5)
ffffffffc0202bc6:	9782                	jalr	a5
ffffffffc0202bc8:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202bca:	d67fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202bce:	b645                	j	ffffffffc020276e <pmm_init+0x19e>
        intr_disable();
ffffffffc0202bd0:	d67fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bd4:	000b3783          	ld	a5,0(s6)
ffffffffc0202bd8:	779c                	ld	a5,40(a5)
ffffffffc0202bda:	9782                	jalr	a5
ffffffffc0202bdc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202bde:	d53fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202be2:	b6b9                	j	ffffffffc0202730 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202be4:	6705                	lui	a4,0x1
ffffffffc0202be6:	177d                	addi	a4,a4,-1
ffffffffc0202be8:	96ba                	add	a3,a3,a4
ffffffffc0202bea:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202bec:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202bf0:	14a77363          	bgeu	a4,a0,ffffffffc0202d36 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202bf4:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202bf8:	fff80537          	lui	a0,0xfff80
ffffffffc0202bfc:	972a                	add	a4,a4,a0
ffffffffc0202bfe:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202c00:	8c1d                	sub	s0,s0,a5
ffffffffc0202c02:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202c06:	00c45593          	srli	a1,s0,0xc
ffffffffc0202c0a:	9532                	add	a0,a0,a2
ffffffffc0202c0c:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202c0e:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202c12:	b4c1                	j	ffffffffc02026d2 <pmm_init+0x102>
        intr_disable();
ffffffffc0202c14:	d23fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c18:	000b3783          	ld	a5,0(s6)
ffffffffc0202c1c:	779c                	ld	a5,40(a5)
ffffffffc0202c1e:	9782                	jalr	a5
ffffffffc0202c20:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202c22:	d0ffd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202c26:	bb79                	j	ffffffffc02029c4 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202c28:	d0ffd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0202c2c:	000b3783          	ld	a5,0(s6)
ffffffffc0202c30:	779c                	ld	a5,40(a5)
ffffffffc0202c32:	9782                	jalr	a5
ffffffffc0202c34:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c36:	cfbfd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202c3a:	b39d                	j	ffffffffc02029a0 <pmm_init+0x3d0>
ffffffffc0202c3c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202c3e:	cf9fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c42:	000b3783          	ld	a5,0(s6)
ffffffffc0202c46:	6522                	ld	a0,8(sp)
ffffffffc0202c48:	4585                	li	a1,1
ffffffffc0202c4a:	739c                	ld	a5,32(a5)
ffffffffc0202c4c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c4e:	ce3fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202c52:	b33d                	j	ffffffffc0202980 <pmm_init+0x3b0>
ffffffffc0202c54:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202c56:	ce1fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0202c5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c5e:	6522                	ld	a0,8(sp)
ffffffffc0202c60:	4585                	li	a1,1
ffffffffc0202c62:	739c                	ld	a5,32(a5)
ffffffffc0202c64:	9782                	jalr	a5
        intr_enable();
ffffffffc0202c66:	ccbfd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202c6a:	b1dd                	j	ffffffffc0202950 <pmm_init+0x380>
        intr_disable();
ffffffffc0202c6c:	ccbfd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c70:	000b3783          	ld	a5,0(s6)
ffffffffc0202c74:	4505                	li	a0,1
ffffffffc0202c76:	6f9c                	ld	a5,24(a5)
ffffffffc0202c78:	9782                	jalr	a5
ffffffffc0202c7a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202c7c:	cb5fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202c80:	b36d                	j	ffffffffc0202a2a <pmm_init+0x45a>
        intr_disable();
ffffffffc0202c82:	cb5fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202c86:	000b3783          	ld	a5,0(s6)
ffffffffc0202c8a:	779c                	ld	a5,40(a5)
ffffffffc0202c8c:	9782                	jalr	a5
ffffffffc0202c8e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202c90:	ca1fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202c94:	bdf9                	j	ffffffffc0202b72 <pmm_init+0x5a2>
ffffffffc0202c96:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202c98:	c9ffd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202c9c:	000b3783          	ld	a5,0(s6)
ffffffffc0202ca0:	6522                	ld	a0,8(sp)
ffffffffc0202ca2:	4585                	li	a1,1
ffffffffc0202ca4:	739c                	ld	a5,32(a5)
ffffffffc0202ca6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ca8:	c89fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202cac:	b55d                	j	ffffffffc0202b52 <pmm_init+0x582>
ffffffffc0202cae:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202cb0:	c87fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0202cb4:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb8:	6522                	ld	a0,8(sp)
ffffffffc0202cba:	4585                	li	a1,1
ffffffffc0202cbc:	739c                	ld	a5,32(a5)
ffffffffc0202cbe:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cc0:	c71fd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202cc4:	bdb9                	j	ffffffffc0202b22 <pmm_init+0x552>
        intr_disable();
ffffffffc0202cc6:	c71fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0202cca:	000b3783          	ld	a5,0(s6)
ffffffffc0202cce:	4585                	li	a1,1
ffffffffc0202cd0:	8552                	mv	a0,s4
ffffffffc0202cd2:	739c                	ld	a5,32(a5)
ffffffffc0202cd4:	9782                	jalr	a5
        intr_enable();
ffffffffc0202cd6:	c5bfd0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202cda:	bd29                	j	ffffffffc0202af4 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202cdc:	86a2                	mv	a3,s0
ffffffffc0202cde:	00002617          	auipc	a2,0x2
ffffffffc0202ce2:	e6260613          	addi	a2,a2,-414 # ffffffffc0204b40 <commands+0xa28>
ffffffffc0202ce6:	1a400593          	li	a1,420
ffffffffc0202cea:	00002517          	auipc	a0,0x2
ffffffffc0202cee:	34e50513          	addi	a0,a0,846 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202cf2:	cecfd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202cf6:	00002697          	auipc	a3,0x2
ffffffffc0202cfa:	76a68693          	addi	a3,a3,1898 # ffffffffc0205460 <default_pmm_manager+0x488>
ffffffffc0202cfe:	00002617          	auipc	a2,0x2
ffffffffc0202d02:	c2260613          	addi	a2,a2,-990 # ffffffffc0204920 <commands+0x808>
ffffffffc0202d06:	1a500593          	li	a1,421
ffffffffc0202d0a:	00002517          	auipc	a0,0x2
ffffffffc0202d0e:	32e50513          	addi	a0,a0,814 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202d12:	cccfd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202d16:	00002697          	auipc	a3,0x2
ffffffffc0202d1a:	70a68693          	addi	a3,a3,1802 # ffffffffc0205420 <default_pmm_manager+0x448>
ffffffffc0202d1e:	00002617          	auipc	a2,0x2
ffffffffc0202d22:	c0260613          	addi	a2,a2,-1022 # ffffffffc0204920 <commands+0x808>
ffffffffc0202d26:	1a400593          	li	a1,420
ffffffffc0202d2a:	00002517          	auipc	a0,0x2
ffffffffc0202d2e:	30e50513          	addi	a0,a0,782 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202d32:	cacfd0ef          	jal	ra,ffffffffc02001de <__panic>
ffffffffc0202d36:	b9cff0ef          	jal	ra,ffffffffc02020d2 <pa2page.part.0>
ffffffffc0202d3a:	bb4ff0ef          	jal	ra,ffffffffc02020ee <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202d3e:	00002697          	auipc	a3,0x2
ffffffffc0202d42:	4da68693          	addi	a3,a3,1242 # ffffffffc0205218 <default_pmm_manager+0x240>
ffffffffc0202d46:	00002617          	auipc	a2,0x2
ffffffffc0202d4a:	bda60613          	addi	a2,a2,-1062 # ffffffffc0204920 <commands+0x808>
ffffffffc0202d4e:	17400593          	li	a1,372
ffffffffc0202d52:	00002517          	auipc	a0,0x2
ffffffffc0202d56:	2e650513          	addi	a0,a0,742 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202d5a:	c84fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202d5e:	00002697          	auipc	a3,0x2
ffffffffc0202d62:	3fa68693          	addi	a3,a3,1018 # ffffffffc0205158 <default_pmm_manager+0x180>
ffffffffc0202d66:	00002617          	auipc	a2,0x2
ffffffffc0202d6a:	bba60613          	addi	a2,a2,-1094 # ffffffffc0204920 <commands+0x808>
ffffffffc0202d6e:	16700593          	li	a1,359
ffffffffc0202d72:	00002517          	auipc	a0,0x2
ffffffffc0202d76:	2c650513          	addi	a0,a0,710 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202d7a:	c64fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202d7e:	00002697          	auipc	a3,0x2
ffffffffc0202d82:	39a68693          	addi	a3,a3,922 # ffffffffc0205118 <default_pmm_manager+0x140>
ffffffffc0202d86:	00002617          	auipc	a2,0x2
ffffffffc0202d8a:	b9a60613          	addi	a2,a2,-1126 # ffffffffc0204920 <commands+0x808>
ffffffffc0202d8e:	16600593          	li	a1,358
ffffffffc0202d92:	00002517          	auipc	a0,0x2
ffffffffc0202d96:	2a650513          	addi	a0,a0,678 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202d9a:	c44fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202d9e:	00002697          	auipc	a3,0x2
ffffffffc0202da2:	35a68693          	addi	a3,a3,858 # ffffffffc02050f8 <default_pmm_manager+0x120>
ffffffffc0202da6:	00002617          	auipc	a2,0x2
ffffffffc0202daa:	b7a60613          	addi	a2,a2,-1158 # ffffffffc0204920 <commands+0x808>
ffffffffc0202dae:	16500593          	li	a1,357
ffffffffc0202db2:	00002517          	auipc	a0,0x2
ffffffffc0202db6:	28650513          	addi	a0,a0,646 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202dba:	c24fd0ef          	jal	ra,ffffffffc02001de <__panic>
    return KADDR(page2pa(page));
ffffffffc0202dbe:	00002617          	auipc	a2,0x2
ffffffffc0202dc2:	d8260613          	addi	a2,a2,-638 # ffffffffc0204b40 <commands+0xa28>
ffffffffc0202dc6:	07100593          	li	a1,113
ffffffffc0202dca:	00002517          	auipc	a0,0x2
ffffffffc0202dce:	d9e50513          	addi	a0,a0,-610 # ffffffffc0204b68 <commands+0xa50>
ffffffffc0202dd2:	c0cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202dd6:	00002697          	auipc	a3,0x2
ffffffffc0202dda:	5d268693          	addi	a3,a3,1490 # ffffffffc02053a8 <default_pmm_manager+0x3d0>
ffffffffc0202dde:	00002617          	auipc	a2,0x2
ffffffffc0202de2:	b4260613          	addi	a2,a2,-1214 # ffffffffc0204920 <commands+0x808>
ffffffffc0202de6:	18d00593          	li	a1,397
ffffffffc0202dea:	00002517          	auipc	a0,0x2
ffffffffc0202dee:	24e50513          	addi	a0,a0,590 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202df2:	becfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202df6:	00002697          	auipc	a3,0x2
ffffffffc0202dfa:	56a68693          	addi	a3,a3,1386 # ffffffffc0205360 <default_pmm_manager+0x388>
ffffffffc0202dfe:	00002617          	auipc	a2,0x2
ffffffffc0202e02:	b2260613          	addi	a2,a2,-1246 # ffffffffc0204920 <commands+0x808>
ffffffffc0202e06:	18b00593          	li	a1,395
ffffffffc0202e0a:	00002517          	auipc	a0,0x2
ffffffffc0202e0e:	22e50513          	addi	a0,a0,558 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202e12:	bccfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202e16:	00002697          	auipc	a3,0x2
ffffffffc0202e1a:	57a68693          	addi	a3,a3,1402 # ffffffffc0205390 <default_pmm_manager+0x3b8>
ffffffffc0202e1e:	00002617          	auipc	a2,0x2
ffffffffc0202e22:	b0260613          	addi	a2,a2,-1278 # ffffffffc0204920 <commands+0x808>
ffffffffc0202e26:	18a00593          	li	a1,394
ffffffffc0202e2a:	00002517          	auipc	a0,0x2
ffffffffc0202e2e:	20e50513          	addi	a0,a0,526 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202e32:	bacfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202e36:	00002697          	auipc	a3,0x2
ffffffffc0202e3a:	64268693          	addi	a3,a3,1602 # ffffffffc0205478 <default_pmm_manager+0x4a0>
ffffffffc0202e3e:	00002617          	auipc	a2,0x2
ffffffffc0202e42:	ae260613          	addi	a2,a2,-1310 # ffffffffc0204920 <commands+0x808>
ffffffffc0202e46:	1a800593          	li	a1,424
ffffffffc0202e4a:	00002517          	auipc	a0,0x2
ffffffffc0202e4e:	1ee50513          	addi	a0,a0,494 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202e52:	b8cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202e56:	00002697          	auipc	a3,0x2
ffffffffc0202e5a:	58268693          	addi	a3,a3,1410 # ffffffffc02053d8 <default_pmm_manager+0x400>
ffffffffc0202e5e:	00002617          	auipc	a2,0x2
ffffffffc0202e62:	ac260613          	addi	a2,a2,-1342 # ffffffffc0204920 <commands+0x808>
ffffffffc0202e66:	19500593          	li	a1,405
ffffffffc0202e6a:	00002517          	auipc	a0,0x2
ffffffffc0202e6e:	1ce50513          	addi	a0,a0,462 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202e72:	b6cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202e76:	00002697          	auipc	a3,0x2
ffffffffc0202e7a:	65a68693          	addi	a3,a3,1626 # ffffffffc02054d0 <default_pmm_manager+0x4f8>
ffffffffc0202e7e:	00002617          	auipc	a2,0x2
ffffffffc0202e82:	aa260613          	addi	a2,a2,-1374 # ffffffffc0204920 <commands+0x808>
ffffffffc0202e86:	1ad00593          	li	a1,429
ffffffffc0202e8a:	00002517          	auipc	a0,0x2
ffffffffc0202e8e:	1ae50513          	addi	a0,a0,430 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202e92:	b4cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202e96:	00002697          	auipc	a3,0x2
ffffffffc0202e9a:	5fa68693          	addi	a3,a3,1530 # ffffffffc0205490 <default_pmm_manager+0x4b8>
ffffffffc0202e9e:	00002617          	auipc	a2,0x2
ffffffffc0202ea2:	a8260613          	addi	a2,a2,-1406 # ffffffffc0204920 <commands+0x808>
ffffffffc0202ea6:	1ac00593          	li	a1,428
ffffffffc0202eaa:	00002517          	auipc	a0,0x2
ffffffffc0202eae:	18e50513          	addi	a0,a0,398 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202eb2:	b2cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202eb6:	00002697          	auipc	a3,0x2
ffffffffc0202eba:	4aa68693          	addi	a3,a3,1194 # ffffffffc0205360 <default_pmm_manager+0x388>
ffffffffc0202ebe:	00002617          	auipc	a2,0x2
ffffffffc0202ec2:	a6260613          	addi	a2,a2,-1438 # ffffffffc0204920 <commands+0x808>
ffffffffc0202ec6:	18700593          	li	a1,391
ffffffffc0202eca:	00002517          	auipc	a0,0x2
ffffffffc0202ece:	16e50513          	addi	a0,a0,366 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202ed2:	b0cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202ed6:	00002697          	auipc	a3,0x2
ffffffffc0202eda:	32a68693          	addi	a3,a3,810 # ffffffffc0205200 <default_pmm_manager+0x228>
ffffffffc0202ede:	00002617          	auipc	a2,0x2
ffffffffc0202ee2:	a4260613          	addi	a2,a2,-1470 # ffffffffc0204920 <commands+0x808>
ffffffffc0202ee6:	18600593          	li	a1,390
ffffffffc0202eea:	00002517          	auipc	a0,0x2
ffffffffc0202eee:	14e50513          	addi	a0,a0,334 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202ef2:	aecfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202ef6:	00002697          	auipc	a3,0x2
ffffffffc0202efa:	48268693          	addi	a3,a3,1154 # ffffffffc0205378 <default_pmm_manager+0x3a0>
ffffffffc0202efe:	00002617          	auipc	a2,0x2
ffffffffc0202f02:	a2260613          	addi	a2,a2,-1502 # ffffffffc0204920 <commands+0x808>
ffffffffc0202f06:	18300593          	li	a1,387
ffffffffc0202f0a:	00002517          	auipc	a0,0x2
ffffffffc0202f0e:	12e50513          	addi	a0,a0,302 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202f12:	accfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202f16:	00002697          	auipc	a3,0x2
ffffffffc0202f1a:	2d268693          	addi	a3,a3,722 # ffffffffc02051e8 <default_pmm_manager+0x210>
ffffffffc0202f1e:	00002617          	auipc	a2,0x2
ffffffffc0202f22:	a0260613          	addi	a2,a2,-1534 # ffffffffc0204920 <commands+0x808>
ffffffffc0202f26:	18200593          	li	a1,386
ffffffffc0202f2a:	00002517          	auipc	a0,0x2
ffffffffc0202f2e:	10e50513          	addi	a0,a0,270 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202f32:	aacfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202f36:	00002697          	auipc	a3,0x2
ffffffffc0202f3a:	35268693          	addi	a3,a3,850 # ffffffffc0205288 <default_pmm_manager+0x2b0>
ffffffffc0202f3e:	00002617          	auipc	a2,0x2
ffffffffc0202f42:	9e260613          	addi	a2,a2,-1566 # ffffffffc0204920 <commands+0x808>
ffffffffc0202f46:	18100593          	li	a1,385
ffffffffc0202f4a:	00002517          	auipc	a0,0x2
ffffffffc0202f4e:	0ee50513          	addi	a0,a0,238 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202f52:	a8cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f56:	00002697          	auipc	a3,0x2
ffffffffc0202f5a:	40a68693          	addi	a3,a3,1034 # ffffffffc0205360 <default_pmm_manager+0x388>
ffffffffc0202f5e:	00002617          	auipc	a2,0x2
ffffffffc0202f62:	9c260613          	addi	a2,a2,-1598 # ffffffffc0204920 <commands+0x808>
ffffffffc0202f66:	18000593          	li	a1,384
ffffffffc0202f6a:	00002517          	auipc	a0,0x2
ffffffffc0202f6e:	0ce50513          	addi	a0,a0,206 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202f72:	a6cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202f76:	00002697          	auipc	a3,0x2
ffffffffc0202f7a:	3d268693          	addi	a3,a3,978 # ffffffffc0205348 <default_pmm_manager+0x370>
ffffffffc0202f7e:	00002617          	auipc	a2,0x2
ffffffffc0202f82:	9a260613          	addi	a2,a2,-1630 # ffffffffc0204920 <commands+0x808>
ffffffffc0202f86:	17f00593          	li	a1,383
ffffffffc0202f8a:	00002517          	auipc	a0,0x2
ffffffffc0202f8e:	0ae50513          	addi	a0,a0,174 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202f92:	a4cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202f96:	00002697          	auipc	a3,0x2
ffffffffc0202f9a:	38268693          	addi	a3,a3,898 # ffffffffc0205318 <default_pmm_manager+0x340>
ffffffffc0202f9e:	00002617          	auipc	a2,0x2
ffffffffc0202fa2:	98260613          	addi	a2,a2,-1662 # ffffffffc0204920 <commands+0x808>
ffffffffc0202fa6:	17e00593          	li	a1,382
ffffffffc0202faa:	00002517          	auipc	a0,0x2
ffffffffc0202fae:	08e50513          	addi	a0,a0,142 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202fb2:	a2cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202fb6:	00002697          	auipc	a3,0x2
ffffffffc0202fba:	34a68693          	addi	a3,a3,842 # ffffffffc0205300 <default_pmm_manager+0x328>
ffffffffc0202fbe:	00002617          	auipc	a2,0x2
ffffffffc0202fc2:	96260613          	addi	a2,a2,-1694 # ffffffffc0204920 <commands+0x808>
ffffffffc0202fc6:	17c00593          	li	a1,380
ffffffffc0202fca:	00002517          	auipc	a0,0x2
ffffffffc0202fce:	06e50513          	addi	a0,a0,110 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202fd2:	a0cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202fd6:	00002697          	auipc	a3,0x2
ffffffffc0202fda:	30a68693          	addi	a3,a3,778 # ffffffffc02052e0 <default_pmm_manager+0x308>
ffffffffc0202fde:	00002617          	auipc	a2,0x2
ffffffffc0202fe2:	94260613          	addi	a2,a2,-1726 # ffffffffc0204920 <commands+0x808>
ffffffffc0202fe6:	17b00593          	li	a1,379
ffffffffc0202fea:	00002517          	auipc	a0,0x2
ffffffffc0202fee:	04e50513          	addi	a0,a0,78 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0202ff2:	9ecfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202ff6:	00002697          	auipc	a3,0x2
ffffffffc0202ffa:	2da68693          	addi	a3,a3,730 # ffffffffc02052d0 <default_pmm_manager+0x2f8>
ffffffffc0202ffe:	00002617          	auipc	a2,0x2
ffffffffc0203002:	92260613          	addi	a2,a2,-1758 # ffffffffc0204920 <commands+0x808>
ffffffffc0203006:	17a00593          	li	a1,378
ffffffffc020300a:	00002517          	auipc	a0,0x2
ffffffffc020300e:	02e50513          	addi	a0,a0,46 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0203012:	9ccfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203016:	00002697          	auipc	a3,0x2
ffffffffc020301a:	2aa68693          	addi	a3,a3,682 # ffffffffc02052c0 <default_pmm_manager+0x2e8>
ffffffffc020301e:	00002617          	auipc	a2,0x2
ffffffffc0203022:	90260613          	addi	a2,a2,-1790 # ffffffffc0204920 <commands+0x808>
ffffffffc0203026:	17900593          	li	a1,377
ffffffffc020302a:	00002517          	auipc	a0,0x2
ffffffffc020302e:	00e50513          	addi	a0,a0,14 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc0203032:	9acfd0ef          	jal	ra,ffffffffc02001de <__panic>
        panic("DTB memory info not available");
ffffffffc0203036:	00002617          	auipc	a2,0x2
ffffffffc020303a:	02a60613          	addi	a2,a2,42 # ffffffffc0205060 <default_pmm_manager+0x88>
ffffffffc020303e:	06400593          	li	a1,100
ffffffffc0203042:	00002517          	auipc	a0,0x2
ffffffffc0203046:	ff650513          	addi	a0,a0,-10 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020304a:	994fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020304e:	00002697          	auipc	a3,0x2
ffffffffc0203052:	38a68693          	addi	a3,a3,906 # ffffffffc02053d8 <default_pmm_manager+0x400>
ffffffffc0203056:	00002617          	auipc	a2,0x2
ffffffffc020305a:	8ca60613          	addi	a2,a2,-1846 # ffffffffc0204920 <commands+0x808>
ffffffffc020305e:	1bf00593          	li	a1,447
ffffffffc0203062:	00002517          	auipc	a0,0x2
ffffffffc0203066:	fd650513          	addi	a0,a0,-42 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020306a:	974fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020306e:	00002697          	auipc	a3,0x2
ffffffffc0203072:	21a68693          	addi	a3,a3,538 # ffffffffc0205288 <default_pmm_manager+0x2b0>
ffffffffc0203076:	00002617          	auipc	a2,0x2
ffffffffc020307a:	8aa60613          	addi	a2,a2,-1878 # ffffffffc0204920 <commands+0x808>
ffffffffc020307e:	17800593          	li	a1,376
ffffffffc0203082:	00002517          	auipc	a0,0x2
ffffffffc0203086:	fb650513          	addi	a0,a0,-74 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020308a:	954fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020308e:	00002697          	auipc	a3,0x2
ffffffffc0203092:	1ba68693          	addi	a3,a3,442 # ffffffffc0205248 <default_pmm_manager+0x270>
ffffffffc0203096:	00002617          	auipc	a2,0x2
ffffffffc020309a:	88a60613          	addi	a2,a2,-1910 # ffffffffc0204920 <commands+0x808>
ffffffffc020309e:	17700593          	li	a1,375
ffffffffc02030a2:	00002517          	auipc	a0,0x2
ffffffffc02030a6:	f9650513          	addi	a0,a0,-106 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02030aa:	934fd0ef          	jal	ra,ffffffffc02001de <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02030ae:	86d6                	mv	a3,s5
ffffffffc02030b0:	00002617          	auipc	a2,0x2
ffffffffc02030b4:	a9060613          	addi	a2,a2,-1392 # ffffffffc0204b40 <commands+0xa28>
ffffffffc02030b8:	17300593          	li	a1,371
ffffffffc02030bc:	00002517          	auipc	a0,0x2
ffffffffc02030c0:	f7c50513          	addi	a0,a0,-132 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02030c4:	91afd0ef          	jal	ra,ffffffffc02001de <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02030c8:	00002617          	auipc	a2,0x2
ffffffffc02030cc:	a7860613          	addi	a2,a2,-1416 # ffffffffc0204b40 <commands+0xa28>
ffffffffc02030d0:	17200593          	li	a1,370
ffffffffc02030d4:	00002517          	auipc	a0,0x2
ffffffffc02030d8:	f6450513          	addi	a0,a0,-156 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02030dc:	902fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02030e0:	00002697          	auipc	a3,0x2
ffffffffc02030e4:	12068693          	addi	a3,a3,288 # ffffffffc0205200 <default_pmm_manager+0x228>
ffffffffc02030e8:	00002617          	auipc	a2,0x2
ffffffffc02030ec:	83860613          	addi	a2,a2,-1992 # ffffffffc0204920 <commands+0x808>
ffffffffc02030f0:	17000593          	li	a1,368
ffffffffc02030f4:	00002517          	auipc	a0,0x2
ffffffffc02030f8:	f4450513          	addi	a0,a0,-188 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02030fc:	8e2fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203100:	00002697          	auipc	a3,0x2
ffffffffc0203104:	0e868693          	addi	a3,a3,232 # ffffffffc02051e8 <default_pmm_manager+0x210>
ffffffffc0203108:	00002617          	auipc	a2,0x2
ffffffffc020310c:	81860613          	addi	a2,a2,-2024 # ffffffffc0204920 <commands+0x808>
ffffffffc0203110:	16f00593          	li	a1,367
ffffffffc0203114:	00002517          	auipc	a0,0x2
ffffffffc0203118:	f2450513          	addi	a0,a0,-220 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020311c:	8c2fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203120:	00002697          	auipc	a3,0x2
ffffffffc0203124:	47868693          	addi	a3,a3,1144 # ffffffffc0205598 <default_pmm_manager+0x5c0>
ffffffffc0203128:	00001617          	auipc	a2,0x1
ffffffffc020312c:	7f860613          	addi	a2,a2,2040 # ffffffffc0204920 <commands+0x808>
ffffffffc0203130:	1b600593          	li	a1,438
ffffffffc0203134:	00002517          	auipc	a0,0x2
ffffffffc0203138:	f0450513          	addi	a0,a0,-252 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020313c:	8a2fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203140:	00002697          	auipc	a3,0x2
ffffffffc0203144:	42068693          	addi	a3,a3,1056 # ffffffffc0205560 <default_pmm_manager+0x588>
ffffffffc0203148:	00001617          	auipc	a2,0x1
ffffffffc020314c:	7d860613          	addi	a2,a2,2008 # ffffffffc0204920 <commands+0x808>
ffffffffc0203150:	1b300593          	li	a1,435
ffffffffc0203154:	00002517          	auipc	a0,0x2
ffffffffc0203158:	ee450513          	addi	a0,a0,-284 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020315c:	882fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203160:	00002697          	auipc	a3,0x2
ffffffffc0203164:	3d068693          	addi	a3,a3,976 # ffffffffc0205530 <default_pmm_manager+0x558>
ffffffffc0203168:	00001617          	auipc	a2,0x1
ffffffffc020316c:	7b860613          	addi	a2,a2,1976 # ffffffffc0204920 <commands+0x808>
ffffffffc0203170:	1af00593          	li	a1,431
ffffffffc0203174:	00002517          	auipc	a0,0x2
ffffffffc0203178:	ec450513          	addi	a0,a0,-316 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020317c:	862fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203180:	00002697          	auipc	a3,0x2
ffffffffc0203184:	36868693          	addi	a3,a3,872 # ffffffffc02054e8 <default_pmm_manager+0x510>
ffffffffc0203188:	00001617          	auipc	a2,0x1
ffffffffc020318c:	79860613          	addi	a2,a2,1944 # ffffffffc0204920 <commands+0x808>
ffffffffc0203190:	1ae00593          	li	a1,430
ffffffffc0203194:	00002517          	auipc	a0,0x2
ffffffffc0203198:	ea450513          	addi	a0,a0,-348 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020319c:	842fd0ef          	jal	ra,ffffffffc02001de <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02031a0:	00002617          	auipc	a2,0x2
ffffffffc02031a4:	a4860613          	addi	a2,a2,-1464 # ffffffffc0204be8 <commands+0xad0>
ffffffffc02031a8:	0cb00593          	li	a1,203
ffffffffc02031ac:	00002517          	auipc	a0,0x2
ffffffffc02031b0:	e8c50513          	addi	a0,a0,-372 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02031b4:	82afd0ef          	jal	ra,ffffffffc02001de <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02031b8:	00002617          	auipc	a2,0x2
ffffffffc02031bc:	a3060613          	addi	a2,a2,-1488 # ffffffffc0204be8 <commands+0xad0>
ffffffffc02031c0:	08000593          	li	a1,128
ffffffffc02031c4:	00002517          	auipc	a0,0x2
ffffffffc02031c8:	e7450513          	addi	a0,a0,-396 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02031cc:	812fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02031d0:	00002697          	auipc	a3,0x2
ffffffffc02031d4:	fe868693          	addi	a3,a3,-24 # ffffffffc02051b8 <default_pmm_manager+0x1e0>
ffffffffc02031d8:	00001617          	auipc	a2,0x1
ffffffffc02031dc:	74860613          	addi	a2,a2,1864 # ffffffffc0204920 <commands+0x808>
ffffffffc02031e0:	16e00593          	li	a1,366
ffffffffc02031e4:	00002517          	auipc	a0,0x2
ffffffffc02031e8:	e5450513          	addi	a0,a0,-428 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc02031ec:	ff3fc0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02031f0:	00002697          	auipc	a3,0x2
ffffffffc02031f4:	f9868693          	addi	a3,a3,-104 # ffffffffc0205188 <default_pmm_manager+0x1b0>
ffffffffc02031f8:	00001617          	auipc	a2,0x1
ffffffffc02031fc:	72860613          	addi	a2,a2,1832 # ffffffffc0204920 <commands+0x808>
ffffffffc0203200:	16b00593          	li	a1,363
ffffffffc0203204:	00002517          	auipc	a0,0x2
ffffffffc0203208:	e3450513          	addi	a0,a0,-460 # ffffffffc0205038 <default_pmm_manager+0x60>
ffffffffc020320c:	fd3fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0203210 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203210:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203214:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203218:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020321a:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020321c:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203220:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203224:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203228:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020322c:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203230:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203234:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203238:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020323c:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203240:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203244:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0203248:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020324c:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020324e:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203250:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203254:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0203258:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020325c:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203260:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203264:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0203268:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020326c:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203270:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203274:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0203278:	8082                	ret

ffffffffc020327a <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc020327a:	8526                	mv	a0,s1
	jalr s0
ffffffffc020327c:	9402                	jalr	s0

	jal do_exit
ffffffffc020327e:	3d0000ef          	jal	ra,ffffffffc020364e <do_exit>

ffffffffc0203282 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203282:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203284:	0e800513          	li	a0,232
{
ffffffffc0203288:	e022                	sd	s0,0(sp)
ffffffffc020328a:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020328c:	9f2fe0ef          	jal	ra,ffffffffc020147e <kmalloc>
ffffffffc0203290:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203292:	c521                	beqz	a0,ffffffffc02032da <alloc_proc+0x58>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;
ffffffffc0203294:	57fd                	li	a5,-1
ffffffffc0203296:	1782                	slli	a5,a5,0x20
ffffffffc0203298:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020329a:	07000613          	li	a2,112
ffffffffc020329e:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc02032a0:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc02032a4:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02032a8:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;
ffffffffc02032ac:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02032b0:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02032b4:	03050513          	addi	a0,a0,48
ffffffffc02032b8:	784000ef          	jal	ra,ffffffffc0203a3c <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc02032bc:	0000a797          	auipc	a5,0xa
ffffffffc02032c0:	1dc7b783          	ld	a5,476(a5) # ffffffffc020d498 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc02032c4:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc02032c8:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc02032ca:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN+1);
ffffffffc02032ce:	4641                	li	a2,16
ffffffffc02032d0:	4581                	li	a1,0
ffffffffc02032d2:	0b440513          	addi	a0,s0,180
ffffffffc02032d6:	766000ef          	jal	ra,ffffffffc0203a3c <memset>
    }
    return proc;
}
ffffffffc02032da:	60a2                	ld	ra,8(sp)
ffffffffc02032dc:	8522                	mv	a0,s0
ffffffffc02032de:	6402                	ld	s0,0(sp)
ffffffffc02032e0:	0141                	addi	sp,sp,16
ffffffffc02032e2:	8082                	ret

ffffffffc02032e4 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc02032e4:	0000a797          	auipc	a5,0xa
ffffffffc02032e8:	1e47b783          	ld	a5,484(a5) # ffffffffc020d4c8 <current>
ffffffffc02032ec:	73c8                	ld	a0,160(a5)
ffffffffc02032ee:	af3fd06f          	j	ffffffffc0200de0 <forkrets>

ffffffffc02032f2 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02032f2:	7179                	addi	sp,sp,-48
ffffffffc02032f4:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc02032f6:	0000a497          	auipc	s1,0xa
ffffffffc02032fa:	15248493          	addi	s1,s1,338 # ffffffffc020d448 <name.2>
{
ffffffffc02032fe:	f022                	sd	s0,32(sp)
ffffffffc0203300:	e84a                	sd	s2,16(sp)
ffffffffc0203302:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203304:	0000a917          	auipc	s2,0xa
ffffffffc0203308:	1c493903          	ld	s2,452(s2) # ffffffffc020d4c8 <current>
    memset(name, 0, sizeof(name));
ffffffffc020330c:	4641                	li	a2,16
ffffffffc020330e:	4581                	li	a1,0
ffffffffc0203310:	8526                	mv	a0,s1
{
ffffffffc0203312:	f406                	sd	ra,40(sp)
ffffffffc0203314:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203316:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc020331a:	722000ef          	jal	ra,ffffffffc0203a3c <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc020331e:	0b490593          	addi	a1,s2,180
ffffffffc0203322:	463d                	li	a2,15
ffffffffc0203324:	8526                	mv	a0,s1
ffffffffc0203326:	728000ef          	jal	ra,ffffffffc0203a4e <memcpy>
ffffffffc020332a:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020332c:	85ce                	mv	a1,s3
ffffffffc020332e:	00002517          	auipc	a0,0x2
ffffffffc0203332:	2b250513          	addi	a0,a0,690 # ffffffffc02055e0 <default_pmm_manager+0x608>
ffffffffc0203336:	dabfc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc020333a:	85a2                	mv	a1,s0
ffffffffc020333c:	00002517          	auipc	a0,0x2
ffffffffc0203340:	2cc50513          	addi	a0,a0,716 # ffffffffc0205608 <default_pmm_manager+0x630>
ffffffffc0203344:	d9dfc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc0203348:	00002517          	auipc	a0,0x2
ffffffffc020334c:	2d050513          	addi	a0,a0,720 # ffffffffc0205618 <default_pmm_manager+0x640>
ffffffffc0203350:	d91fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
}
ffffffffc0203354:	70a2                	ld	ra,40(sp)
ffffffffc0203356:	7402                	ld	s0,32(sp)
ffffffffc0203358:	64e2                	ld	s1,24(sp)
ffffffffc020335a:	6942                	ld	s2,16(sp)
ffffffffc020335c:	69a2                	ld	s3,8(sp)
ffffffffc020335e:	4501                	li	a0,0
ffffffffc0203360:	6145                	addi	sp,sp,48
ffffffffc0203362:	8082                	ret

ffffffffc0203364 <proc_run>:
{
ffffffffc0203364:	7179                	addi	sp,sp,-48
ffffffffc0203366:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203368:	0000a917          	auipc	s2,0xa
ffffffffc020336c:	16090913          	addi	s2,s2,352 # ffffffffc020d4c8 <current>
{
ffffffffc0203370:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203372:	00093483          	ld	s1,0(s2)
{
ffffffffc0203376:	f406                	sd	ra,40(sp)
ffffffffc0203378:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc020337a:	02a48e63          	beq	s1,a0,ffffffffc02033b6 <proc_run+0x52>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020337e:	100027f3          	csrr	a5,sstatus
ffffffffc0203382:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203384:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203386:	e7a9                	bnez	a5,ffffffffc02033d0 <proc_run+0x6c>
        lsatp(proc->pgdir);
ffffffffc0203388:	755c                	ld	a5,168(a0)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned int pgdir)
{
  write_csr(satp, SATP32_MODE | (pgdir >> RISCV_PGSHIFT));
ffffffffc020338a:	80000737          	lui	a4,0x80000
        current = proc;
ffffffffc020338e:	00a93023          	sd	a0,0(s2)
ffffffffc0203392:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc0203396:	8fd9                	or	a5,a5,a4
ffffffffc0203398:	18079073          	csrw	satp,a5
        proc->runs++;
ffffffffc020339c:	451c                	lw	a5,8(a0)
        proc->need_resched = 0;
ffffffffc020339e:	00052c23          	sw	zero,24(a0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc02033a2:	03050593          	addi	a1,a0,48
        proc->runs++;
ffffffffc02033a6:	2785                	addiw	a5,a5,1
ffffffffc02033a8:	c51c                	sw	a5,8(a0)
        switch_to(&(prev->context), &(proc->context));
ffffffffc02033aa:	03048513          	addi	a0,s1,48
ffffffffc02033ae:	e63ff0ef          	jal	ra,ffffffffc0203210 <switch_to>
    if (flag) {
ffffffffc02033b2:	00099863          	bnez	s3,ffffffffc02033c2 <proc_run+0x5e>
}
ffffffffc02033b6:	70a2                	ld	ra,40(sp)
ffffffffc02033b8:	7482                	ld	s1,32(sp)
ffffffffc02033ba:	6962                	ld	s2,24(sp)
ffffffffc02033bc:	69c2                	ld	s3,16(sp)
ffffffffc02033be:	6145                	addi	sp,sp,48
ffffffffc02033c0:	8082                	ret
ffffffffc02033c2:	70a2                	ld	ra,40(sp)
ffffffffc02033c4:	7482                	ld	s1,32(sp)
ffffffffc02033c6:	6962                	ld	s2,24(sp)
ffffffffc02033c8:	69c2                	ld	s3,16(sp)
ffffffffc02033ca:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02033cc:	d64fd06f          	j	ffffffffc0200930 <intr_enable>
ffffffffc02033d0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02033d2:	d64fd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc02033d6:	6522                	ld	a0,8(sp)
ffffffffc02033d8:	4985                	li	s3,1
ffffffffc02033da:	b77d                	j	ffffffffc0203388 <proc_run+0x24>

ffffffffc02033dc <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc02033dc:	0000a717          	auipc	a4,0xa
ffffffffc02033e0:	10472703          	lw	a4,260(a4) # ffffffffc020d4e0 <nr_process>
ffffffffc02033e4:	6785                	lui	a5,0x1
ffffffffc02033e6:	1cf75963          	bge	a4,a5,ffffffffc02035b8 <do_fork+0x1dc>
{
ffffffffc02033ea:	1101                	addi	sp,sp,-32
ffffffffc02033ec:	e822                	sd	s0,16(sp)
ffffffffc02033ee:	e426                	sd	s1,8(sp)
ffffffffc02033f0:	e04a                	sd	s2,0(sp)
ffffffffc02033f2:	ec06                	sd	ra,24(sp)
ffffffffc02033f4:	892e                	mv	s2,a1
ffffffffc02033f6:	8432                	mv	s0,a2
    proc = alloc_proc();
ffffffffc02033f8:	e8bff0ef          	jal	ra,ffffffffc0203282 <alloc_proc>
ffffffffc02033fc:	84aa                	mv	s1,a0
    if(proc==NULL)
ffffffffc02033fe:	1c050263          	beqz	a0,ffffffffc02035c2 <do_fork+0x1e6>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203402:	4509                	li	a0,2
ffffffffc0203404:	d07fe0ef          	jal	ra,ffffffffc020210a <alloc_pages>
    if (page != NULL)
ffffffffc0203408:	1a050363          	beqz	a0,ffffffffc02035ae <do_fork+0x1d2>
    return page - pages + nbase;
ffffffffc020340c:	0000a697          	auipc	a3,0xa
ffffffffc0203410:	0a46b683          	ld	a3,164(a3) # ffffffffc020d4b0 <pages>
ffffffffc0203414:	40d506b3          	sub	a3,a0,a3
ffffffffc0203418:	8699                	srai	a3,a3,0x6
ffffffffc020341a:	00002517          	auipc	a0,0x2
ffffffffc020341e:	5be53503          	ld	a0,1470(a0) # ffffffffc02059d8 <nbase>
ffffffffc0203422:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc0203424:	00c69793          	slli	a5,a3,0xc
ffffffffc0203428:	83b1                	srli	a5,a5,0xc
ffffffffc020342a:	0000a717          	auipc	a4,0xa
ffffffffc020342e:	07e73703          	ld	a4,126(a4) # ffffffffc020d4a8 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0203432:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203434:	1ae7f963          	bgeu	a5,a4,ffffffffc02035e6 <do_fork+0x20a>
    assert(current->mm == NULL);
ffffffffc0203438:	0000a317          	auipc	t1,0xa
ffffffffc020343c:	09033303          	ld	t1,144(t1) # ffffffffc020d4c8 <current>
ffffffffc0203440:	02833783          	ld	a5,40(t1)
ffffffffc0203444:	0000a717          	auipc	a4,0xa
ffffffffc0203448:	07c73703          	ld	a4,124(a4) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc020344c:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020344e:	e894                	sd	a3,16(s1)
    assert(current->mm == NULL);
ffffffffc0203450:	16079b63          	bnez	a5,ffffffffc02035c6 <do_fork+0x1ea>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0203454:	6789                	lui	a5,0x2
ffffffffc0203456:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc020345a:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020345c:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc020345e:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0203460:	87b6                	mv	a5,a3
ffffffffc0203462:	12040893          	addi	a7,s0,288
ffffffffc0203466:	00063803          	ld	a6,0(a2)
ffffffffc020346a:	6608                	ld	a0,8(a2)
ffffffffc020346c:	6a0c                	ld	a1,16(a2)
ffffffffc020346e:	6e18                	ld	a4,24(a2)
ffffffffc0203470:	0107b023          	sd	a6,0(a5)
ffffffffc0203474:	e788                	sd	a0,8(a5)
ffffffffc0203476:	eb8c                	sd	a1,16(a5)
ffffffffc0203478:	ef98                	sd	a4,24(a5)
ffffffffc020347a:	02060613          	addi	a2,a2,32
ffffffffc020347e:	02078793          	addi	a5,a5,32
ffffffffc0203482:	ff1612e3          	bne	a2,a7,ffffffffc0203466 <do_fork+0x8a>
    proc->tf->gpr.a0 = 0;
ffffffffc0203486:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020348a:	10090663          	beqz	s2,ffffffffc0203596 <do_fork+0x1ba>
    if (++last_pid >= MAX_PID)
ffffffffc020348e:	00006817          	auipc	a6,0x6
ffffffffc0203492:	b9a80813          	addi	a6,a6,-1126 # ffffffffc0209028 <last_pid.1>
ffffffffc0203496:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020349a:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020349e:	00000717          	auipc	a4,0x0
ffffffffc02034a2:	e4670713          	addi	a4,a4,-442 # ffffffffc02032e4 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02034a6:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02034aa:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02034ac:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc02034ae:	00a82023          	sw	a0,0(a6)
ffffffffc02034b2:	6789                	lui	a5,0x2
ffffffffc02034b4:	06f55a63          	bge	a0,a5,ffffffffc0203528 <do_fork+0x14c>
    if (last_pid >= next_safe)
ffffffffc02034b8:	00006e17          	auipc	t3,0x6
ffffffffc02034bc:	b74e0e13          	addi	t3,t3,-1164 # ffffffffc020902c <next_safe.0>
ffffffffc02034c0:	000e2783          	lw	a5,0(t3)
ffffffffc02034c4:	0000a417          	auipc	s0,0xa
ffffffffc02034c8:	f9440413          	addi	s0,s0,-108 # ffffffffc020d458 <proc_list>
ffffffffc02034cc:	06f55663          	bge	a0,a5,ffffffffc0203538 <do_fork+0x15c>
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02034d0:	45a9                	li	a1,10
    proc->pid = get_pid();
ffffffffc02034d2:	c0c8                	sw	a0,4(s1)
    proc->parent = current;
ffffffffc02034d4:	0264b023          	sd	t1,32(s1)
    proc->state = PROC_UNINIT;
ffffffffc02034d8:	0004a023          	sw	zero,0(s1)
    proc->runs = 0;
ffffffffc02034dc:	0004a423          	sw	zero,8(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02034e0:	2501                	sext.w	a0,a0
ffffffffc02034e2:	197000ef          	jal	ra,ffffffffc0203e78 <hash32>
ffffffffc02034e6:	02051793          	slli	a5,a0,0x20
ffffffffc02034ea:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02034ee:	00006797          	auipc	a5,0x6
ffffffffc02034f2:	f5a78793          	addi	a5,a5,-166 # ffffffffc0209448 <hash_list>
ffffffffc02034f6:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02034f8:	651c                	ld	a5,8(a0)
ffffffffc02034fa:	0d848693          	addi	a3,s1,216
ffffffffc02034fe:	6418                	ld	a4,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203500:	e394                	sd	a3,0(a5)
ffffffffc0203502:	e514                	sd	a3,8(a0)
    elm->next = next;
ffffffffc0203504:	f0fc                	sd	a5,224(s1)
    elm->prev = prev;
ffffffffc0203506:	ece8                	sd	a0,216(s1)
    list_add(&proc_list, &proc->list_link);
ffffffffc0203508:	0c848793          	addi	a5,s1,200
    prev->next = next->prev = elm;
ffffffffc020350c:	e31c                	sd	a5,0(a4)
    wakeup_proc(proc);
ffffffffc020350e:	8526                	mv	a0,s1
    elm->next = next;
ffffffffc0203510:	e8f8                	sd	a4,208(s1)
    elm->prev = prev;
ffffffffc0203512:	e4e0                	sd	s0,200(s1)
    prev->next = next->prev = elm;
ffffffffc0203514:	e41c                	sd	a5,8(s0)
ffffffffc0203516:	3be000ef          	jal	ra,ffffffffc02038d4 <wakeup_proc>
    ret = proc->pid;
ffffffffc020351a:	40c8                	lw	a0,4(s1)
}
ffffffffc020351c:	60e2                	ld	ra,24(sp)
ffffffffc020351e:	6442                	ld	s0,16(sp)
ffffffffc0203520:	64a2                	ld	s1,8(sp)
ffffffffc0203522:	6902                	ld	s2,0(sp)
ffffffffc0203524:	6105                	addi	sp,sp,32
ffffffffc0203526:	8082                	ret
        last_pid = 1;
ffffffffc0203528:	4785                	li	a5,1
ffffffffc020352a:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc020352e:	4505                	li	a0,1
ffffffffc0203530:	00006e17          	auipc	t3,0x6
ffffffffc0203534:	afce0e13          	addi	t3,t3,-1284 # ffffffffc020902c <next_safe.0>
    return listelm->next;
ffffffffc0203538:	0000a417          	auipc	s0,0xa
ffffffffc020353c:	f2040413          	addi	s0,s0,-224 # ffffffffc020d458 <proc_list>
ffffffffc0203540:	00843e83          	ld	t4,8(s0)
        next_safe = MAX_PID;
ffffffffc0203544:	6789                	lui	a5,0x2
ffffffffc0203546:	00fe2023          	sw	a5,0(t3)
ffffffffc020354a:	86aa                	mv	a3,a0
ffffffffc020354c:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc020354e:	6f09                	lui	t5,0x2
ffffffffc0203550:	048e8a63          	beq	t4,s0,ffffffffc02035a4 <do_fork+0x1c8>
ffffffffc0203554:	88ae                	mv	a7,a1
ffffffffc0203556:	87f6                	mv	a5,t4
ffffffffc0203558:	6609                	lui	a2,0x2
ffffffffc020355a:	a811                	j	ffffffffc020356e <do_fork+0x192>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020355c:	00e6d663          	bge	a3,a4,ffffffffc0203568 <do_fork+0x18c>
ffffffffc0203560:	00c75463          	bge	a4,a2,ffffffffc0203568 <do_fork+0x18c>
ffffffffc0203564:	863a                	mv	a2,a4
ffffffffc0203566:	4885                	li	a7,1
ffffffffc0203568:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020356a:	00878d63          	beq	a5,s0,ffffffffc0203584 <do_fork+0x1a8>
            if (proc->pid == last_pid)
ffffffffc020356e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc0203572:	fed715e3          	bne	a4,a3,ffffffffc020355c <do_fork+0x180>
                if (++last_pid >= next_safe)
ffffffffc0203576:	2685                	addiw	a3,a3,1
ffffffffc0203578:	02c6d163          	bge	a3,a2,ffffffffc020359a <do_fork+0x1be>
ffffffffc020357c:	679c                	ld	a5,8(a5)
ffffffffc020357e:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0203580:	fe8797e3          	bne	a5,s0,ffffffffc020356e <do_fork+0x192>
ffffffffc0203584:	c581                	beqz	a1,ffffffffc020358c <do_fork+0x1b0>
ffffffffc0203586:	00d82023          	sw	a3,0(a6)
ffffffffc020358a:	8536                	mv	a0,a3
ffffffffc020358c:	f40882e3          	beqz	a7,ffffffffc02034d0 <do_fork+0xf4>
ffffffffc0203590:	00ce2023          	sw	a2,0(t3)
ffffffffc0203594:	bf35                	j	ffffffffc02034d0 <do_fork+0xf4>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203596:	8936                	mv	s2,a3
ffffffffc0203598:	bddd                	j	ffffffffc020348e <do_fork+0xb2>
                    if (last_pid >= MAX_PID)
ffffffffc020359a:	01e6c363          	blt	a3,t5,ffffffffc02035a0 <do_fork+0x1c4>
                        last_pid = 1;
ffffffffc020359e:	4685                	li	a3,1
                    goto repeat;
ffffffffc02035a0:	4585                	li	a1,1
ffffffffc02035a2:	b77d                	j	ffffffffc0203550 <do_fork+0x174>
ffffffffc02035a4:	cd81                	beqz	a1,ffffffffc02035bc <do_fork+0x1e0>
ffffffffc02035a6:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc02035aa:	8536                	mv	a0,a3
ffffffffc02035ac:	b715                	j	ffffffffc02034d0 <do_fork+0xf4>
    kfree(proc);
ffffffffc02035ae:	8526                	mv	a0,s1
ffffffffc02035b0:	f7ffd0ef          	jal	ra,ffffffffc020152e <kfree>
    ret = -E_NO_MEM;
ffffffffc02035b4:	5571                	li	a0,-4
    goto fork_out;
ffffffffc02035b6:	b79d                	j	ffffffffc020351c <do_fork+0x140>
    int ret = -E_NO_FREE_PROC;
ffffffffc02035b8:	556d                	li	a0,-5
}
ffffffffc02035ba:	8082                	ret
    return last_pid;
ffffffffc02035bc:	00082503          	lw	a0,0(a6)
ffffffffc02035c0:	bf01                	j	ffffffffc02034d0 <do_fork+0xf4>
    ret = -E_NO_MEM;
ffffffffc02035c2:	5571                	li	a0,-4
    return ret;
ffffffffc02035c4:	bfa1                	j	ffffffffc020351c <do_fork+0x140>
    assert(current->mm == NULL);
ffffffffc02035c6:	00002697          	auipc	a3,0x2
ffffffffc02035ca:	07268693          	addi	a3,a3,114 # ffffffffc0205638 <default_pmm_manager+0x660>
ffffffffc02035ce:	00001617          	auipc	a2,0x1
ffffffffc02035d2:	35260613          	addi	a2,a2,850 # ffffffffc0204920 <commands+0x808>
ffffffffc02035d6:	11f00593          	li	a1,287
ffffffffc02035da:	00002517          	auipc	a0,0x2
ffffffffc02035de:	07650513          	addi	a0,a0,118 # ffffffffc0205650 <default_pmm_manager+0x678>
ffffffffc02035e2:	bfdfc0ef          	jal	ra,ffffffffc02001de <__panic>
ffffffffc02035e6:	00001617          	auipc	a2,0x1
ffffffffc02035ea:	55a60613          	addi	a2,a2,1370 # ffffffffc0204b40 <commands+0xa28>
ffffffffc02035ee:	07100593          	li	a1,113
ffffffffc02035f2:	00001517          	auipc	a0,0x1
ffffffffc02035f6:	57650513          	addi	a0,a0,1398 # ffffffffc0204b68 <commands+0xa50>
ffffffffc02035fa:	be5fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02035fe <kernel_thread>:
{
ffffffffc02035fe:	7129                	addi	sp,sp,-320
ffffffffc0203600:	fa22                	sd	s0,304(sp)
ffffffffc0203602:	f626                	sd	s1,296(sp)
ffffffffc0203604:	f24a                	sd	s2,288(sp)
ffffffffc0203606:	84ae                	mv	s1,a1
ffffffffc0203608:	892a                	mv	s2,a0
ffffffffc020360a:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020360c:	4581                	li	a1,0
ffffffffc020360e:	12000613          	li	a2,288
ffffffffc0203612:	850a                	mv	a0,sp
{
ffffffffc0203614:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203616:	426000ef          	jal	ra,ffffffffc0203a3c <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020361a:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020361c:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020361e:	100027f3          	csrr	a5,sstatus
ffffffffc0203622:	edd7f793          	andi	a5,a5,-291
ffffffffc0203626:	1207e793          	ori	a5,a5,288
ffffffffc020362a:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020362c:	860a                	mv	a2,sp
ffffffffc020362e:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203632:	00000797          	auipc	a5,0x0
ffffffffc0203636:	c4878793          	addi	a5,a5,-952 # ffffffffc020327a <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020363a:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020363c:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020363e:	d9fff0ef          	jal	ra,ffffffffc02033dc <do_fork>
}
ffffffffc0203642:	70f2                	ld	ra,312(sp)
ffffffffc0203644:	7452                	ld	s0,304(sp)
ffffffffc0203646:	74b2                	ld	s1,296(sp)
ffffffffc0203648:	7912                	ld	s2,288(sp)
ffffffffc020364a:	6131                	addi	sp,sp,320
ffffffffc020364c:	8082                	ret

ffffffffc020364e <do_exit>:
{
ffffffffc020364e:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc0203650:	00002617          	auipc	a2,0x2
ffffffffc0203654:	01860613          	addi	a2,a2,24 # ffffffffc0205668 <default_pmm_manager+0x690>
ffffffffc0203658:	18100593          	li	a1,385
ffffffffc020365c:	00002517          	auipc	a0,0x2
ffffffffc0203660:	ff450513          	addi	a0,a0,-12 # ffffffffc0205650 <default_pmm_manager+0x678>
{
ffffffffc0203664:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc0203666:	b79fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020366a <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc020366a:	7179                	addi	sp,sp,-48
ffffffffc020366c:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc020366e:	0000a797          	auipc	a5,0xa
ffffffffc0203672:	dea78793          	addi	a5,a5,-534 # ffffffffc020d458 <proc_list>
ffffffffc0203676:	f406                	sd	ra,40(sp)
ffffffffc0203678:	f022                	sd	s0,32(sp)
ffffffffc020367a:	e84a                	sd	s2,16(sp)
ffffffffc020367c:	e44e                	sd	s3,8(sp)
ffffffffc020367e:	00006497          	auipc	s1,0x6
ffffffffc0203682:	dca48493          	addi	s1,s1,-566 # ffffffffc0209448 <hash_list>
ffffffffc0203686:	e79c                	sd	a5,8(a5)
ffffffffc0203688:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020368a:	0000a717          	auipc	a4,0xa
ffffffffc020368e:	dbe70713          	addi	a4,a4,-578 # ffffffffc020d448 <name.2>
ffffffffc0203692:	87a6                	mv	a5,s1
ffffffffc0203694:	e79c                	sd	a5,8(a5)
ffffffffc0203696:	e39c                	sd	a5,0(a5)
ffffffffc0203698:	07c1                	addi	a5,a5,16
ffffffffc020369a:	fef71de3          	bne	a4,a5,ffffffffc0203694 <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc020369e:	be5ff0ef          	jal	ra,ffffffffc0203282 <alloc_proc>
ffffffffc02036a2:	0000a917          	auipc	s2,0xa
ffffffffc02036a6:	e2e90913          	addi	s2,s2,-466 # ffffffffc020d4d0 <idleproc>
ffffffffc02036aa:	00a93023          	sd	a0,0(s2)
ffffffffc02036ae:	18050d63          	beqz	a0,ffffffffc0203848 <proc_init+0x1de>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc02036b2:	07000513          	li	a0,112
ffffffffc02036b6:	dc9fd0ef          	jal	ra,ffffffffc020147e <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02036ba:	07000613          	li	a2,112
ffffffffc02036be:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc02036c0:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02036c2:	37a000ef          	jal	ra,ffffffffc0203a3c <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc02036c6:	00093503          	ld	a0,0(s2)
ffffffffc02036ca:	85a2                	mv	a1,s0
ffffffffc02036cc:	07000613          	li	a2,112
ffffffffc02036d0:	03050513          	addi	a0,a0,48
ffffffffc02036d4:	392000ef          	jal	ra,ffffffffc0203a66 <memcmp>
ffffffffc02036d8:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc02036da:	453d                	li	a0,15
ffffffffc02036dc:	da3fd0ef          	jal	ra,ffffffffc020147e <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02036e0:	463d                	li	a2,15
ffffffffc02036e2:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc02036e4:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02036e6:	356000ef          	jal	ra,ffffffffc0203a3c <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc02036ea:	00093503          	ld	a0,0(s2)
ffffffffc02036ee:	463d                	li	a2,15
ffffffffc02036f0:	85a2                	mv	a1,s0
ffffffffc02036f2:	0b450513          	addi	a0,a0,180
ffffffffc02036f6:	370000ef          	jal	ra,ffffffffc0203a66 <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc02036fa:	00093783          	ld	a5,0(s2)
ffffffffc02036fe:	0000a717          	auipc	a4,0xa
ffffffffc0203702:	d9a73703          	ld	a4,-614(a4) # ffffffffc020d498 <boot_pgdir_pa>
ffffffffc0203706:	77d4                	ld	a3,168(a5)
ffffffffc0203708:	0ee68463          	beq	a3,a4,ffffffffc02037f0 <proc_init+0x186>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020370c:	4709                	li	a4,2
ffffffffc020370e:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203710:	00003717          	auipc	a4,0x3
ffffffffc0203714:	8f070713          	addi	a4,a4,-1808 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203718:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020371c:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc020371e:	4705                	li	a4,1
ffffffffc0203720:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203722:	4641                	li	a2,16
ffffffffc0203724:	4581                	li	a1,0
ffffffffc0203726:	8522                	mv	a0,s0
ffffffffc0203728:	314000ef          	jal	ra,ffffffffc0203a3c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020372c:	463d                	li	a2,15
ffffffffc020372e:	00002597          	auipc	a1,0x2
ffffffffc0203732:	f8258593          	addi	a1,a1,-126 # ffffffffc02056b0 <default_pmm_manager+0x6d8>
ffffffffc0203736:	8522                	mv	a0,s0
ffffffffc0203738:	316000ef          	jal	ra,ffffffffc0203a4e <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc020373c:	0000a717          	auipc	a4,0xa
ffffffffc0203740:	da470713          	addi	a4,a4,-604 # ffffffffc020d4e0 <nr_process>
ffffffffc0203744:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0203746:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020374a:	4601                	li	a2,0
    nr_process++;
ffffffffc020374c:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020374e:	00002597          	auipc	a1,0x2
ffffffffc0203752:	f6a58593          	addi	a1,a1,-150 # ffffffffc02056b8 <default_pmm_manager+0x6e0>
ffffffffc0203756:	00000517          	auipc	a0,0x0
ffffffffc020375a:	b9c50513          	addi	a0,a0,-1124 # ffffffffc02032f2 <init_main>
    nr_process++;
ffffffffc020375e:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0203760:	0000a797          	auipc	a5,0xa
ffffffffc0203764:	d6d7b423          	sd	a3,-664(a5) # ffffffffc020d4c8 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203768:	e97ff0ef          	jal	ra,ffffffffc02035fe <kernel_thread>
ffffffffc020376c:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc020376e:	0ea05963          	blez	a0,ffffffffc0203860 <proc_init+0x1f6>
    if (0 < pid && pid < MAX_PID)
ffffffffc0203772:	6789                	lui	a5,0x2
ffffffffc0203774:	fff5071b          	addiw	a4,a0,-1
ffffffffc0203778:	17f9                	addi	a5,a5,-2
ffffffffc020377a:	2501                	sext.w	a0,a0
ffffffffc020377c:	02e7e363          	bltu	a5,a4,ffffffffc02037a2 <proc_init+0x138>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203780:	45a9                	li	a1,10
ffffffffc0203782:	6f6000ef          	jal	ra,ffffffffc0203e78 <hash32>
ffffffffc0203786:	02051793          	slli	a5,a0,0x20
ffffffffc020378a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc020378e:	96a6                	add	a3,a3,s1
ffffffffc0203790:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0203792:	a029                	j	ffffffffc020379c <proc_init+0x132>
            if (proc->pid == pid)
ffffffffc0203794:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc0203798:	0a870563          	beq	a4,s0,ffffffffc0203842 <proc_init+0x1d8>
    return listelm->next;
ffffffffc020379c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020379e:	fef69be3          	bne	a3,a5,ffffffffc0203794 <proc_init+0x12a>
    return NULL;
ffffffffc02037a2:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037a4:	0b478493          	addi	s1,a5,180
ffffffffc02037a8:	4641                	li	a2,16
ffffffffc02037aa:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02037ac:	0000a417          	auipc	s0,0xa
ffffffffc02037b0:	d2c40413          	addi	s0,s0,-724 # ffffffffc020d4d8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037b4:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc02037b6:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037b8:	284000ef          	jal	ra,ffffffffc0203a3c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02037bc:	463d                	li	a2,15
ffffffffc02037be:	00002597          	auipc	a1,0x2
ffffffffc02037c2:	f2a58593          	addi	a1,a1,-214 # ffffffffc02056e8 <default_pmm_manager+0x710>
ffffffffc02037c6:	8526                	mv	a0,s1
ffffffffc02037c8:	286000ef          	jal	ra,ffffffffc0203a4e <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02037cc:	00093783          	ld	a5,0(s2)
ffffffffc02037d0:	c7e1                	beqz	a5,ffffffffc0203898 <proc_init+0x22e>
ffffffffc02037d2:	43dc                	lw	a5,4(a5)
ffffffffc02037d4:	e3f1                	bnez	a5,ffffffffc0203898 <proc_init+0x22e>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02037d6:	601c                	ld	a5,0(s0)
ffffffffc02037d8:	c3c5                	beqz	a5,ffffffffc0203878 <proc_init+0x20e>
ffffffffc02037da:	43d8                	lw	a4,4(a5)
ffffffffc02037dc:	4785                	li	a5,1
ffffffffc02037de:	08f71d63          	bne	a4,a5,ffffffffc0203878 <proc_init+0x20e>
}
ffffffffc02037e2:	70a2                	ld	ra,40(sp)
ffffffffc02037e4:	7402                	ld	s0,32(sp)
ffffffffc02037e6:	64e2                	ld	s1,24(sp)
ffffffffc02037e8:	6942                	ld	s2,16(sp)
ffffffffc02037ea:	69a2                	ld	s3,8(sp)
ffffffffc02037ec:	6145                	addi	sp,sp,48
ffffffffc02037ee:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc02037f0:	73d8                	ld	a4,160(a5)
ffffffffc02037f2:	ff09                	bnez	a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc02037f4:	f0099ce3          	bnez	s3,ffffffffc020370c <proc_init+0xa2>
ffffffffc02037f8:	6394                	ld	a3,0(a5)
ffffffffc02037fa:	577d                	li	a4,-1
ffffffffc02037fc:	1702                	slli	a4,a4,0x20
ffffffffc02037fe:	f0e697e3          	bne	a3,a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc0203802:	4798                	lw	a4,8(a5)
ffffffffc0203804:	f00714e3          	bnez	a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc0203808:	6b98                	ld	a4,16(a5)
ffffffffc020380a:	f00711e3          	bnez	a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc020380e:	4f98                	lw	a4,24(a5)
ffffffffc0203810:	2701                	sext.w	a4,a4
ffffffffc0203812:	ee071de3          	bnez	a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc0203816:	7398                	ld	a4,32(a5)
ffffffffc0203818:	ee071ae3          	bnez	a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc020381c:	7798                	ld	a4,40(a5)
ffffffffc020381e:	ee0717e3          	bnez	a4,ffffffffc020370c <proc_init+0xa2>
ffffffffc0203822:	0b07a703          	lw	a4,176(a5)
ffffffffc0203826:	8d59                	or	a0,a0,a4
ffffffffc0203828:	0005071b          	sext.w	a4,a0
ffffffffc020382c:	ee0710e3          	bnez	a4,ffffffffc020370c <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc0203830:	00002517          	auipc	a0,0x2
ffffffffc0203834:	e6850513          	addi	a0,a0,-408 # ffffffffc0205698 <default_pmm_manager+0x6c0>
ffffffffc0203838:	8a9fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    idleproc->pid = 0;
ffffffffc020383c:	00093783          	ld	a5,0(s2)
ffffffffc0203840:	b5f1                	j	ffffffffc020370c <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0203842:	f2878793          	addi	a5,a5,-216
ffffffffc0203846:	bfb9                	j	ffffffffc02037a4 <proc_init+0x13a>
        panic("cannot alloc idleproc.\n");
ffffffffc0203848:	00002617          	auipc	a2,0x2
ffffffffc020384c:	e3860613          	addi	a2,a2,-456 # ffffffffc0205680 <default_pmm_manager+0x6a8>
ffffffffc0203850:	19c00593          	li	a1,412
ffffffffc0203854:	00002517          	auipc	a0,0x2
ffffffffc0203858:	dfc50513          	addi	a0,a0,-516 # ffffffffc0205650 <default_pmm_manager+0x678>
ffffffffc020385c:	983fc0ef          	jal	ra,ffffffffc02001de <__panic>
        panic("create init_main failed.\n");
ffffffffc0203860:	00002617          	auipc	a2,0x2
ffffffffc0203864:	e6860613          	addi	a2,a2,-408 # ffffffffc02056c8 <default_pmm_manager+0x6f0>
ffffffffc0203868:	1b900593          	li	a1,441
ffffffffc020386c:	00002517          	auipc	a0,0x2
ffffffffc0203870:	de450513          	addi	a0,a0,-540 # ffffffffc0205650 <default_pmm_manager+0x678>
ffffffffc0203874:	96bfc0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203878:	00002697          	auipc	a3,0x2
ffffffffc020387c:	ea068693          	addi	a3,a3,-352 # ffffffffc0205718 <default_pmm_manager+0x740>
ffffffffc0203880:	00001617          	auipc	a2,0x1
ffffffffc0203884:	0a060613          	addi	a2,a2,160 # ffffffffc0204920 <commands+0x808>
ffffffffc0203888:	1c000593          	li	a1,448
ffffffffc020388c:	00002517          	auipc	a0,0x2
ffffffffc0203890:	dc450513          	addi	a0,a0,-572 # ffffffffc0205650 <default_pmm_manager+0x678>
ffffffffc0203894:	94bfc0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203898:	00002697          	auipc	a3,0x2
ffffffffc020389c:	e5868693          	addi	a3,a3,-424 # ffffffffc02056f0 <default_pmm_manager+0x718>
ffffffffc02038a0:	00001617          	auipc	a2,0x1
ffffffffc02038a4:	08060613          	addi	a2,a2,128 # ffffffffc0204920 <commands+0x808>
ffffffffc02038a8:	1bf00593          	li	a1,447
ffffffffc02038ac:	00002517          	auipc	a0,0x2
ffffffffc02038b0:	da450513          	addi	a0,a0,-604 # ffffffffc0205650 <default_pmm_manager+0x678>
ffffffffc02038b4:	92bfc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02038b8 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02038b8:	1141                	addi	sp,sp,-16
ffffffffc02038ba:	e022                	sd	s0,0(sp)
ffffffffc02038bc:	e406                	sd	ra,8(sp)
ffffffffc02038be:	0000a417          	auipc	s0,0xa
ffffffffc02038c2:	c0a40413          	addi	s0,s0,-1014 # ffffffffc020d4c8 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02038c6:	6018                	ld	a4,0(s0)
ffffffffc02038c8:	4f1c                	lw	a5,24(a4)
ffffffffc02038ca:	2781                	sext.w	a5,a5
ffffffffc02038cc:	dff5                	beqz	a5,ffffffffc02038c8 <cpu_idle+0x10>
        {
            schedule();
ffffffffc02038ce:	038000ef          	jal	ra,ffffffffc0203906 <schedule>
ffffffffc02038d2:	bfd5                	j	ffffffffc02038c6 <cpu_idle+0xe>

ffffffffc02038d4 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038d4:	411c                	lw	a5,0(a0)
ffffffffc02038d6:	4705                	li	a4,1
ffffffffc02038d8:	37f9                	addiw	a5,a5,-2
ffffffffc02038da:	00f77563          	bgeu	a4,a5,ffffffffc02038e4 <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc02038de:	4789                	li	a5,2
ffffffffc02038e0:	c11c                	sw	a5,0(a0)
ffffffffc02038e2:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038e4:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038e6:	00002697          	auipc	a3,0x2
ffffffffc02038ea:	e5a68693          	addi	a3,a3,-422 # ffffffffc0205740 <default_pmm_manager+0x768>
ffffffffc02038ee:	00001617          	auipc	a2,0x1
ffffffffc02038f2:	03260613          	addi	a2,a2,50 # ffffffffc0204920 <commands+0x808>
ffffffffc02038f6:	45a5                	li	a1,9
ffffffffc02038f8:	00002517          	auipc	a0,0x2
ffffffffc02038fc:	e8850513          	addi	a0,a0,-376 # ffffffffc0205780 <default_pmm_manager+0x7a8>
wakeup_proc(struct proc_struct *proc) {
ffffffffc0203900:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0203902:	8ddfc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0203906 <schedule>:
}

void
schedule(void) {
ffffffffc0203906:	1141                	addi	sp,sp,-16
ffffffffc0203908:	e406                	sd	ra,8(sp)
ffffffffc020390a:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020390c:	100027f3          	csrr	a5,sstatus
ffffffffc0203910:	8b89                	andi	a5,a5,2
ffffffffc0203912:	4401                	li	s0,0
ffffffffc0203914:	efbd                	bnez	a5,ffffffffc0203992 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0203916:	0000a897          	auipc	a7,0xa
ffffffffc020391a:	bb28b883          	ld	a7,-1102(a7) # ffffffffc020d4c8 <current>
ffffffffc020391e:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203922:	0000a517          	auipc	a0,0xa
ffffffffc0203926:	bae53503          	ld	a0,-1106(a0) # ffffffffc020d4d0 <idleproc>
ffffffffc020392a:	04a88e63          	beq	a7,a0,ffffffffc0203986 <schedule+0x80>
ffffffffc020392e:	0c888693          	addi	a3,a7,200
ffffffffc0203932:	0000a617          	auipc	a2,0xa
ffffffffc0203936:	b2660613          	addi	a2,a2,-1242 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc020393a:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc020393c:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc020393e:	4809                	li	a6,2
ffffffffc0203940:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc0203942:	00c78863          	beq	a5,a2,ffffffffc0203952 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203946:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020394a:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc020394e:	03070163          	beq	a4,a6,ffffffffc0203970 <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc0203952:	fef697e3          	bne	a3,a5,ffffffffc0203940 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203956:	ed89                	bnez	a1,ffffffffc0203970 <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc0203958:	451c                	lw	a5,8(a0)
ffffffffc020395a:	2785                	addiw	a5,a5,1
ffffffffc020395c:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc020395e:	00a88463          	beq	a7,a0,ffffffffc0203966 <schedule+0x60>
            proc_run(next);
ffffffffc0203962:	a03ff0ef          	jal	ra,ffffffffc0203364 <proc_run>
    if (flag) {
ffffffffc0203966:	e819                	bnez	s0,ffffffffc020397c <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0203968:	60a2                	ld	ra,8(sp)
ffffffffc020396a:	6402                	ld	s0,0(sp)
ffffffffc020396c:	0141                	addi	sp,sp,16
ffffffffc020396e:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203970:	4198                	lw	a4,0(a1)
ffffffffc0203972:	4789                	li	a5,2
ffffffffc0203974:	fef712e3          	bne	a4,a5,ffffffffc0203958 <schedule+0x52>
ffffffffc0203978:	852e                	mv	a0,a1
ffffffffc020397a:	bff9                	j	ffffffffc0203958 <schedule+0x52>
}
ffffffffc020397c:	6402                	ld	s0,0(sp)
ffffffffc020397e:	60a2                	ld	ra,8(sp)
ffffffffc0203980:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0203982:	faffc06f          	j	ffffffffc0200930 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203986:	0000a617          	auipc	a2,0xa
ffffffffc020398a:	ad260613          	addi	a2,a2,-1326 # ffffffffc020d458 <proc_list>
ffffffffc020398e:	86b2                	mv	a3,a2
ffffffffc0203990:	b76d                	j	ffffffffc020393a <schedule+0x34>
        intr_disable();
ffffffffc0203992:	fa5fc0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc0203996:	4405                	li	s0,1
ffffffffc0203998:	bfbd                	j	ffffffffc0203916 <schedule+0x10>

ffffffffc020399a <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020399a:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020399e:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02039a0:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02039a2:	cb81                	beqz	a5,ffffffffc02039b2 <strlen+0x18>
        cnt ++;
ffffffffc02039a4:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02039a6:	00a707b3          	add	a5,a4,a0
ffffffffc02039aa:	0007c783          	lbu	a5,0(a5)
ffffffffc02039ae:	fbfd                	bnez	a5,ffffffffc02039a4 <strlen+0xa>
ffffffffc02039b0:	8082                	ret
    }
    return cnt;
}
ffffffffc02039b2:	8082                	ret

ffffffffc02039b4 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02039b4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02039b6:	e589                	bnez	a1,ffffffffc02039c0 <strnlen+0xc>
ffffffffc02039b8:	a811                	j	ffffffffc02039cc <strnlen+0x18>
        cnt ++;
ffffffffc02039ba:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02039bc:	00f58863          	beq	a1,a5,ffffffffc02039cc <strnlen+0x18>
ffffffffc02039c0:	00f50733          	add	a4,a0,a5
ffffffffc02039c4:	00074703          	lbu	a4,0(a4)
ffffffffc02039c8:	fb6d                	bnez	a4,ffffffffc02039ba <strnlen+0x6>
ffffffffc02039ca:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02039cc:	852e                	mv	a0,a1
ffffffffc02039ce:	8082                	ret

ffffffffc02039d0 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02039d0:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02039d2:	0005c703          	lbu	a4,0(a1)
ffffffffc02039d6:	0785                	addi	a5,a5,1
ffffffffc02039d8:	0585                	addi	a1,a1,1
ffffffffc02039da:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02039de:	fb75                	bnez	a4,ffffffffc02039d2 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02039e0:	8082                	ret

ffffffffc02039e2 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02039e2:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02039e6:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02039ea:	cb89                	beqz	a5,ffffffffc02039fc <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02039ec:	0505                	addi	a0,a0,1
ffffffffc02039ee:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02039f0:	fee789e3          	beq	a5,a4,ffffffffc02039e2 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02039f4:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02039f8:	9d19                	subw	a0,a0,a4
ffffffffc02039fa:	8082                	ret
ffffffffc02039fc:	4501                	li	a0,0
ffffffffc02039fe:	bfed                	j	ffffffffc02039f8 <strcmp+0x16>

ffffffffc0203a00 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203a00:	c20d                	beqz	a2,ffffffffc0203a22 <strncmp+0x22>
ffffffffc0203a02:	962e                	add	a2,a2,a1
ffffffffc0203a04:	a031                	j	ffffffffc0203a10 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0203a06:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203a08:	00e79a63          	bne	a5,a4,ffffffffc0203a1c <strncmp+0x1c>
ffffffffc0203a0c:	00b60b63          	beq	a2,a1,ffffffffc0203a22 <strncmp+0x22>
ffffffffc0203a10:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203a14:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203a16:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203a1a:	f7f5                	bnez	a5,ffffffffc0203a06 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a1c:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0203a20:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a22:	4501                	li	a0,0
ffffffffc0203a24:	8082                	ret

ffffffffc0203a26 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203a26:	00054783          	lbu	a5,0(a0)
ffffffffc0203a2a:	c799                	beqz	a5,ffffffffc0203a38 <strchr+0x12>
        if (*s == c) {
ffffffffc0203a2c:	00f58763          	beq	a1,a5,ffffffffc0203a3a <strchr+0x14>
    while (*s != '\0') {
ffffffffc0203a30:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0203a34:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203a36:	fbfd                	bnez	a5,ffffffffc0203a2c <strchr+0x6>
    }
    return NULL;
ffffffffc0203a38:	4501                	li	a0,0
}
ffffffffc0203a3a:	8082                	ret

ffffffffc0203a3c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203a3c:	ca01                	beqz	a2,ffffffffc0203a4c <memset+0x10>
ffffffffc0203a3e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203a40:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203a42:	0785                	addi	a5,a5,1
ffffffffc0203a44:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203a48:	fec79de3          	bne	a5,a2,ffffffffc0203a42 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203a4c:	8082                	ret

ffffffffc0203a4e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203a4e:	ca19                	beqz	a2,ffffffffc0203a64 <memcpy+0x16>
ffffffffc0203a50:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203a52:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203a54:	0005c703          	lbu	a4,0(a1)
ffffffffc0203a58:	0585                	addi	a1,a1,1
ffffffffc0203a5a:	0785                	addi	a5,a5,1
ffffffffc0203a5c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203a60:	fec59ae3          	bne	a1,a2,ffffffffc0203a54 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203a64:	8082                	ret

ffffffffc0203a66 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203a66:	c205                	beqz	a2,ffffffffc0203a86 <memcmp+0x20>
ffffffffc0203a68:	962e                	add	a2,a2,a1
ffffffffc0203a6a:	a019                	j	ffffffffc0203a70 <memcmp+0xa>
ffffffffc0203a6c:	00c58d63          	beq	a1,a2,ffffffffc0203a86 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203a70:	00054783          	lbu	a5,0(a0)
ffffffffc0203a74:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203a78:	0505                	addi	a0,a0,1
ffffffffc0203a7a:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203a7c:	fee788e3          	beq	a5,a4,ffffffffc0203a6c <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a80:	40e7853b          	subw	a0,a5,a4
ffffffffc0203a84:	8082                	ret
    }
    return 0;
ffffffffc0203a86:	4501                	li	a0,0
}
ffffffffc0203a88:	8082                	ret

ffffffffc0203a8a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203a8a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a8e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203a90:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a94:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203a96:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203a9a:	f022                	sd	s0,32(sp)
ffffffffc0203a9c:	ec26                	sd	s1,24(sp)
ffffffffc0203a9e:	e84a                	sd	s2,16(sp)
ffffffffc0203aa0:	f406                	sd	ra,40(sp)
ffffffffc0203aa2:	e44e                	sd	s3,8(sp)
ffffffffc0203aa4:	84aa                	mv	s1,a0
ffffffffc0203aa6:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203aa8:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203aac:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203aae:	03067e63          	bgeu	a2,a6,ffffffffc0203aea <printnum+0x60>
ffffffffc0203ab2:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203ab4:	00805763          	blez	s0,ffffffffc0203ac2 <printnum+0x38>
ffffffffc0203ab8:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203aba:	85ca                	mv	a1,s2
ffffffffc0203abc:	854e                	mv	a0,s3
ffffffffc0203abe:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203ac0:	fc65                	bnez	s0,ffffffffc0203ab8 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ac2:	1a02                	slli	s4,s4,0x20
ffffffffc0203ac4:	00002797          	auipc	a5,0x2
ffffffffc0203ac8:	cd478793          	addi	a5,a5,-812 # ffffffffc0205798 <default_pmm_manager+0x7c0>
ffffffffc0203acc:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203ad0:	9a3e                	add	s4,s4,a5
}
ffffffffc0203ad2:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ad4:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203ad8:	70a2                	ld	ra,40(sp)
ffffffffc0203ada:	69a2                	ld	s3,8(sp)
ffffffffc0203adc:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ade:	85ca                	mv	a1,s2
ffffffffc0203ae0:	87a6                	mv	a5,s1
}
ffffffffc0203ae2:	6942                	ld	s2,16(sp)
ffffffffc0203ae4:	64e2                	ld	s1,24(sp)
ffffffffc0203ae6:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ae8:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203aea:	03065633          	divu	a2,a2,a6
ffffffffc0203aee:	8722                	mv	a4,s0
ffffffffc0203af0:	f9bff0ef          	jal	ra,ffffffffc0203a8a <printnum>
ffffffffc0203af4:	b7f9                	j	ffffffffc0203ac2 <printnum+0x38>

ffffffffc0203af6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203af6:	7119                	addi	sp,sp,-128
ffffffffc0203af8:	f4a6                	sd	s1,104(sp)
ffffffffc0203afa:	f0ca                	sd	s2,96(sp)
ffffffffc0203afc:	ecce                	sd	s3,88(sp)
ffffffffc0203afe:	e8d2                	sd	s4,80(sp)
ffffffffc0203b00:	e4d6                	sd	s5,72(sp)
ffffffffc0203b02:	e0da                	sd	s6,64(sp)
ffffffffc0203b04:	fc5e                	sd	s7,56(sp)
ffffffffc0203b06:	f06a                	sd	s10,32(sp)
ffffffffc0203b08:	fc86                	sd	ra,120(sp)
ffffffffc0203b0a:	f8a2                	sd	s0,112(sp)
ffffffffc0203b0c:	f862                	sd	s8,48(sp)
ffffffffc0203b0e:	f466                	sd	s9,40(sp)
ffffffffc0203b10:	ec6e                	sd	s11,24(sp)
ffffffffc0203b12:	892a                	mv	s2,a0
ffffffffc0203b14:	84ae                	mv	s1,a1
ffffffffc0203b16:	8d32                	mv	s10,a2
ffffffffc0203b18:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b1a:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0203b1e:	5b7d                	li	s6,-1
ffffffffc0203b20:	00002a97          	auipc	s5,0x2
ffffffffc0203b24:	ca4a8a93          	addi	s5,s5,-860 # ffffffffc02057c4 <default_pmm_manager+0x7ec>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203b28:	00002b97          	auipc	s7,0x2
ffffffffc0203b2c:	e78b8b93          	addi	s7,s7,-392 # ffffffffc02059a0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b30:	000d4503          	lbu	a0,0(s10)
ffffffffc0203b34:	001d0413          	addi	s0,s10,1
ffffffffc0203b38:	01350a63          	beq	a0,s3,ffffffffc0203b4c <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203b3c:	c121                	beqz	a0,ffffffffc0203b7c <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203b3e:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b40:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203b42:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b44:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203b48:	ff351ae3          	bne	a0,s3,ffffffffc0203b3c <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b4c:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203b50:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203b54:	4c81                	li	s9,0
ffffffffc0203b56:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203b58:	5c7d                	li	s8,-1
ffffffffc0203b5a:	5dfd                	li	s11,-1
ffffffffc0203b5c:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203b60:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b62:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203b66:	0ff5f593          	zext.b	a1,a1
ffffffffc0203b6a:	00140d13          	addi	s10,s0,1
ffffffffc0203b6e:	04b56263          	bltu	a0,a1,ffffffffc0203bb2 <vprintfmt+0xbc>
ffffffffc0203b72:	058a                	slli	a1,a1,0x2
ffffffffc0203b74:	95d6                	add	a1,a1,s5
ffffffffc0203b76:	4194                	lw	a3,0(a1)
ffffffffc0203b78:	96d6                	add	a3,a3,s5
ffffffffc0203b7a:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203b7c:	70e6                	ld	ra,120(sp)
ffffffffc0203b7e:	7446                	ld	s0,112(sp)
ffffffffc0203b80:	74a6                	ld	s1,104(sp)
ffffffffc0203b82:	7906                	ld	s2,96(sp)
ffffffffc0203b84:	69e6                	ld	s3,88(sp)
ffffffffc0203b86:	6a46                	ld	s4,80(sp)
ffffffffc0203b88:	6aa6                	ld	s5,72(sp)
ffffffffc0203b8a:	6b06                	ld	s6,64(sp)
ffffffffc0203b8c:	7be2                	ld	s7,56(sp)
ffffffffc0203b8e:	7c42                	ld	s8,48(sp)
ffffffffc0203b90:	7ca2                	ld	s9,40(sp)
ffffffffc0203b92:	7d02                	ld	s10,32(sp)
ffffffffc0203b94:	6de2                	ld	s11,24(sp)
ffffffffc0203b96:	6109                	addi	sp,sp,128
ffffffffc0203b98:	8082                	ret
            padc = '0';
ffffffffc0203b9a:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203b9c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ba0:	846a                	mv	s0,s10
ffffffffc0203ba2:	00140d13          	addi	s10,s0,1
ffffffffc0203ba6:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203baa:	0ff5f593          	zext.b	a1,a1
ffffffffc0203bae:	fcb572e3          	bgeu	a0,a1,ffffffffc0203b72 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203bb2:	85a6                	mv	a1,s1
ffffffffc0203bb4:	02500513          	li	a0,37
ffffffffc0203bb8:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203bba:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203bbe:	8d22                	mv	s10,s0
ffffffffc0203bc0:	f73788e3          	beq	a5,s3,ffffffffc0203b30 <vprintfmt+0x3a>
ffffffffc0203bc4:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203bc8:	1d7d                	addi	s10,s10,-1
ffffffffc0203bca:	ff379de3          	bne	a5,s3,ffffffffc0203bc4 <vprintfmt+0xce>
ffffffffc0203bce:	b78d                	j	ffffffffc0203b30 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0203bd0:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0203bd4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bd8:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0203bda:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0203bde:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203be2:	02d86463          	bltu	a6,a3,ffffffffc0203c0a <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0203be6:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203bea:	002c169b          	slliw	a3,s8,0x2
ffffffffc0203bee:	0186873b          	addw	a4,a3,s8
ffffffffc0203bf2:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203bf6:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0203bf8:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203bfc:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203bfe:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0203c02:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203c06:	fed870e3          	bgeu	a6,a3,ffffffffc0203be6 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0203c0a:	f40ddce3          	bgez	s11,ffffffffc0203b62 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0203c0e:	8de2                	mv	s11,s8
ffffffffc0203c10:	5c7d                	li	s8,-1
ffffffffc0203c12:	bf81                	j	ffffffffc0203b62 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0203c14:	fffdc693          	not	a3,s11
ffffffffc0203c18:	96fd                	srai	a3,a3,0x3f
ffffffffc0203c1a:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c1e:	00144603          	lbu	a2,1(s0)
ffffffffc0203c22:	2d81                	sext.w	s11,s11
ffffffffc0203c24:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203c26:	bf35                	j	ffffffffc0203b62 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0203c28:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c2c:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0203c30:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c32:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0203c34:	bfd9                	j	ffffffffc0203c0a <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0203c36:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c38:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c3c:	01174463          	blt	a4,a7,ffffffffc0203c44 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0203c40:	1a088e63          	beqz	a7,ffffffffc0203dfc <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0203c44:	000a3603          	ld	a2,0(s4)
ffffffffc0203c48:	46c1                	li	a3,16
ffffffffc0203c4a:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203c4c:	2781                	sext.w	a5,a5
ffffffffc0203c4e:	876e                	mv	a4,s11
ffffffffc0203c50:	85a6                	mv	a1,s1
ffffffffc0203c52:	854a                	mv	a0,s2
ffffffffc0203c54:	e37ff0ef          	jal	ra,ffffffffc0203a8a <printnum>
            break;
ffffffffc0203c58:	bde1                	j	ffffffffc0203b30 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0203c5a:	000a2503          	lw	a0,0(s4)
ffffffffc0203c5e:	85a6                	mv	a1,s1
ffffffffc0203c60:	0a21                	addi	s4,s4,8
ffffffffc0203c62:	9902                	jalr	s2
            break;
ffffffffc0203c64:	b5f1                	j	ffffffffc0203b30 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203c66:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c68:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c6c:	01174463          	blt	a4,a7,ffffffffc0203c74 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0203c70:	18088163          	beqz	a7,ffffffffc0203df2 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0203c74:	000a3603          	ld	a2,0(s4)
ffffffffc0203c78:	46a9                	li	a3,10
ffffffffc0203c7a:	8a2e                	mv	s4,a1
ffffffffc0203c7c:	bfc1                	j	ffffffffc0203c4c <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c7e:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0203c82:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c84:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203c86:	bdf1                	j	ffffffffc0203b62 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0203c88:	85a6                	mv	a1,s1
ffffffffc0203c8a:	02500513          	li	a0,37
ffffffffc0203c8e:	9902                	jalr	s2
            break;
ffffffffc0203c90:	b545                	j	ffffffffc0203b30 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c92:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0203c96:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c98:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203c9a:	b5e1                	j	ffffffffc0203b62 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0203c9c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c9e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203ca2:	01174463          	blt	a4,a7,ffffffffc0203caa <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0203ca6:	14088163          	beqz	a7,ffffffffc0203de8 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0203caa:	000a3603          	ld	a2,0(s4)
ffffffffc0203cae:	46a1                	li	a3,8
ffffffffc0203cb0:	8a2e                	mv	s4,a1
ffffffffc0203cb2:	bf69                	j	ffffffffc0203c4c <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0203cb4:	03000513          	li	a0,48
ffffffffc0203cb8:	85a6                	mv	a1,s1
ffffffffc0203cba:	e03e                	sd	a5,0(sp)
ffffffffc0203cbc:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0203cbe:	85a6                	mv	a1,s1
ffffffffc0203cc0:	07800513          	li	a0,120
ffffffffc0203cc4:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203cc6:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203cc8:	6782                	ld	a5,0(sp)
ffffffffc0203cca:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203ccc:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0203cd0:	bfb5                	j	ffffffffc0203c4c <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203cd2:	000a3403          	ld	s0,0(s4)
ffffffffc0203cd6:	008a0713          	addi	a4,s4,8
ffffffffc0203cda:	e03a                	sd	a4,0(sp)
ffffffffc0203cdc:	14040263          	beqz	s0,ffffffffc0203e20 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0203ce0:	0fb05763          	blez	s11,ffffffffc0203dce <vprintfmt+0x2d8>
ffffffffc0203ce4:	02d00693          	li	a3,45
ffffffffc0203ce8:	0cd79163          	bne	a5,a3,ffffffffc0203daa <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cec:	00044783          	lbu	a5,0(s0)
ffffffffc0203cf0:	0007851b          	sext.w	a0,a5
ffffffffc0203cf4:	cf85                	beqz	a5,ffffffffc0203d2c <vprintfmt+0x236>
ffffffffc0203cf6:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203cfa:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cfe:	000c4563          	bltz	s8,ffffffffc0203d08 <vprintfmt+0x212>
ffffffffc0203d02:	3c7d                	addiw	s8,s8,-1
ffffffffc0203d04:	036c0263          	beq	s8,s6,ffffffffc0203d28 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0203d08:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d0a:	0e0c8e63          	beqz	s9,ffffffffc0203e06 <vprintfmt+0x310>
ffffffffc0203d0e:	3781                	addiw	a5,a5,-32
ffffffffc0203d10:	0ef47b63          	bgeu	s0,a5,ffffffffc0203e06 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0203d14:	03f00513          	li	a0,63
ffffffffc0203d18:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d1a:	000a4783          	lbu	a5,0(s4)
ffffffffc0203d1e:	3dfd                	addiw	s11,s11,-1
ffffffffc0203d20:	0a05                	addi	s4,s4,1
ffffffffc0203d22:	0007851b          	sext.w	a0,a5
ffffffffc0203d26:	ffe1                	bnez	a5,ffffffffc0203cfe <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0203d28:	01b05963          	blez	s11,ffffffffc0203d3a <vprintfmt+0x244>
ffffffffc0203d2c:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0203d2e:	85a6                	mv	a1,s1
ffffffffc0203d30:	02000513          	li	a0,32
ffffffffc0203d34:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0203d36:	fe0d9be3          	bnez	s11,ffffffffc0203d2c <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203d3a:	6a02                	ld	s4,0(sp)
ffffffffc0203d3c:	bbd5                	j	ffffffffc0203b30 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203d3e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203d40:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0203d44:	01174463          	blt	a4,a7,ffffffffc0203d4c <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0203d48:	08088d63          	beqz	a7,ffffffffc0203de2 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0203d4c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203d50:	0a044d63          	bltz	s0,ffffffffc0203e0a <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0203d54:	8622                	mv	a2,s0
ffffffffc0203d56:	8a66                	mv	s4,s9
ffffffffc0203d58:	46a9                	li	a3,10
ffffffffc0203d5a:	bdcd                	j	ffffffffc0203c4c <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0203d5c:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203d60:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0203d62:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203d64:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203d68:	8fb5                	xor	a5,a5,a3
ffffffffc0203d6a:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203d6e:	02d74163          	blt	a4,a3,ffffffffc0203d90 <vprintfmt+0x29a>
ffffffffc0203d72:	00369793          	slli	a5,a3,0x3
ffffffffc0203d76:	97de                	add	a5,a5,s7
ffffffffc0203d78:	639c                	ld	a5,0(a5)
ffffffffc0203d7a:	cb99                	beqz	a5,ffffffffc0203d90 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203d7c:	86be                	mv	a3,a5
ffffffffc0203d7e:	00000617          	auipc	a2,0x0
ffffffffc0203d82:	13a60613          	addi	a2,a2,314 # ffffffffc0203eb8 <etext+0x2a>
ffffffffc0203d86:	85a6                	mv	a1,s1
ffffffffc0203d88:	854a                	mv	a0,s2
ffffffffc0203d8a:	0ce000ef          	jal	ra,ffffffffc0203e58 <printfmt>
ffffffffc0203d8e:	b34d                	j	ffffffffc0203b30 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203d90:	00002617          	auipc	a2,0x2
ffffffffc0203d94:	a2860613          	addi	a2,a2,-1496 # ffffffffc02057b8 <default_pmm_manager+0x7e0>
ffffffffc0203d98:	85a6                	mv	a1,s1
ffffffffc0203d9a:	854a                	mv	a0,s2
ffffffffc0203d9c:	0bc000ef          	jal	ra,ffffffffc0203e58 <printfmt>
ffffffffc0203da0:	bb41                	j	ffffffffc0203b30 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0203da2:	00002417          	auipc	s0,0x2
ffffffffc0203da6:	a0e40413          	addi	s0,s0,-1522 # ffffffffc02057b0 <default_pmm_manager+0x7d8>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203daa:	85e2                	mv	a1,s8
ffffffffc0203dac:	8522                	mv	a0,s0
ffffffffc0203dae:	e43e                	sd	a5,8(sp)
ffffffffc0203db0:	c05ff0ef          	jal	ra,ffffffffc02039b4 <strnlen>
ffffffffc0203db4:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0203db8:	01b05b63          	blez	s11,ffffffffc0203dce <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0203dbc:	67a2                	ld	a5,8(sp)
ffffffffc0203dbe:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203dc2:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0203dc4:	85a6                	mv	a1,s1
ffffffffc0203dc6:	8552                	mv	a0,s4
ffffffffc0203dc8:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203dca:	fe0d9ce3          	bnez	s11,ffffffffc0203dc2 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203dce:	00044783          	lbu	a5,0(s0)
ffffffffc0203dd2:	00140a13          	addi	s4,s0,1
ffffffffc0203dd6:	0007851b          	sext.w	a0,a5
ffffffffc0203dda:	d3a5                	beqz	a5,ffffffffc0203d3a <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203ddc:	05e00413          	li	s0,94
ffffffffc0203de0:	bf39                	j	ffffffffc0203cfe <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0203de2:	000a2403          	lw	s0,0(s4)
ffffffffc0203de6:	b7ad                	j	ffffffffc0203d50 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0203de8:	000a6603          	lwu	a2,0(s4)
ffffffffc0203dec:	46a1                	li	a3,8
ffffffffc0203dee:	8a2e                	mv	s4,a1
ffffffffc0203df0:	bdb1                	j	ffffffffc0203c4c <vprintfmt+0x156>
ffffffffc0203df2:	000a6603          	lwu	a2,0(s4)
ffffffffc0203df6:	46a9                	li	a3,10
ffffffffc0203df8:	8a2e                	mv	s4,a1
ffffffffc0203dfa:	bd89                	j	ffffffffc0203c4c <vprintfmt+0x156>
ffffffffc0203dfc:	000a6603          	lwu	a2,0(s4)
ffffffffc0203e00:	46c1                	li	a3,16
ffffffffc0203e02:	8a2e                	mv	s4,a1
ffffffffc0203e04:	b5a1                	j	ffffffffc0203c4c <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0203e06:	9902                	jalr	s2
ffffffffc0203e08:	bf09                	j	ffffffffc0203d1a <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0203e0a:	85a6                	mv	a1,s1
ffffffffc0203e0c:	02d00513          	li	a0,45
ffffffffc0203e10:	e03e                	sd	a5,0(sp)
ffffffffc0203e12:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0203e14:	6782                	ld	a5,0(sp)
ffffffffc0203e16:	8a66                	mv	s4,s9
ffffffffc0203e18:	40800633          	neg	a2,s0
ffffffffc0203e1c:	46a9                	li	a3,10
ffffffffc0203e1e:	b53d                	j	ffffffffc0203c4c <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0203e20:	03b05163          	blez	s11,ffffffffc0203e42 <vprintfmt+0x34c>
ffffffffc0203e24:	02d00693          	li	a3,45
ffffffffc0203e28:	f6d79de3          	bne	a5,a3,ffffffffc0203da2 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0203e2c:	00002417          	auipc	s0,0x2
ffffffffc0203e30:	98440413          	addi	s0,s0,-1660 # ffffffffc02057b0 <default_pmm_manager+0x7d8>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203e34:	02800793          	li	a5,40
ffffffffc0203e38:	02800513          	li	a0,40
ffffffffc0203e3c:	00140a13          	addi	s4,s0,1
ffffffffc0203e40:	bd6d                	j	ffffffffc0203cfa <vprintfmt+0x204>
ffffffffc0203e42:	00002a17          	auipc	s4,0x2
ffffffffc0203e46:	96fa0a13          	addi	s4,s4,-1681 # ffffffffc02057b1 <default_pmm_manager+0x7d9>
ffffffffc0203e4a:	02800513          	li	a0,40
ffffffffc0203e4e:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203e52:	05e00413          	li	s0,94
ffffffffc0203e56:	b565                	j	ffffffffc0203cfe <vprintfmt+0x208>

ffffffffc0203e58 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e58:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203e5a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e5e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203e60:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e62:	ec06                	sd	ra,24(sp)
ffffffffc0203e64:	f83a                	sd	a4,48(sp)
ffffffffc0203e66:	fc3e                	sd	a5,56(sp)
ffffffffc0203e68:	e0c2                	sd	a6,64(sp)
ffffffffc0203e6a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203e6c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203e6e:	c89ff0ef          	jal	ra,ffffffffc0203af6 <vprintfmt>
}
ffffffffc0203e72:	60e2                	ld	ra,24(sp)
ffffffffc0203e74:	6161                	addi	sp,sp,80
ffffffffc0203e76:	8082                	ret

ffffffffc0203e78 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203e78:	9e3707b7          	lui	a5,0x9e370
ffffffffc0203e7c:	2785                	addiw	a5,a5,1
ffffffffc0203e7e:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0203e82:	02000793          	li	a5,32
ffffffffc0203e86:	9f8d                	subw	a5,a5,a1
}
ffffffffc0203e88:	00f5553b          	srlw	a0,a0,a5
ffffffffc0203e8c:	8082                	ret
