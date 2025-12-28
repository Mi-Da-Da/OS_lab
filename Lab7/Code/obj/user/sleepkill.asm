
obj/__user_sleepkill.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800020:	715d                	addi	sp,sp,-80
  800022:	8e2e                	mv	t3,a1
  800024:	e822                	sd	s0,16(sp)
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("user panic at %s:%d:\n    ", file, line);
  800026:	85aa                	mv	a1,a0
__panic(const char *file, int line, const char *fmt, ...) {
  800028:	8432                	mv	s0,a2
  80002a:	fc3e                	sd	a5,56(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80002c:	8672                	mv	a2,t3
    va_start(ap, fmt);
  80002e:	103c                	addi	a5,sp,40
    cprintf("user panic at %s:%d:\n    ", file, line);
  800030:	00000517          	auipc	a0,0x0
  800034:	5b850513          	addi	a0,a0,1464 # 8005e8 <main+0x86>
__panic(const char *file, int line, const char *fmt, ...) {
  800038:	ec06                	sd	ra,24(sp)
  80003a:	f436                	sd	a3,40(sp)
  80003c:	f83a                	sd	a4,48(sp)
  80003e:	e0c2                	sd	a6,64(sp)
  800040:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800042:	e43e                	sd	a5,8(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  800044:	0d2000ef          	jal	ra,800116 <cprintf>
    vcprintf(fmt, ap);
  800048:	65a2                	ld	a1,8(sp)
  80004a:	8522                	mv	a0,s0
  80004c:	0aa000ef          	jal	ra,8000f6 <vcprintf>
    cprintf("\n");
  800050:	00000517          	auipc	a0,0x0
  800054:	5b850513          	addi	a0,a0,1464 # 800608 <main+0xa6>
  800058:	0be000ef          	jal	ra,800116 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  80005c:	5559                	li	a0,-10
  80005e:	058000ef          	jal	ra,8000b6 <exit>

0000000000800062 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800062:	7175                	addi	sp,sp,-144
  800064:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  800066:	e0ba                	sd	a4,64(sp)
  800068:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  80006a:	e42a                	sd	a0,8(sp)
  80006c:	ecae                	sd	a1,88(sp)
  80006e:	f0b2                	sd	a2,96(sp)
  800070:	f4b6                	sd	a3,104(sp)
  800072:	fcbe                	sd	a5,120(sp)
  800074:	e142                	sd	a6,128(sp)
  800076:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  800078:	f42e                	sd	a1,40(sp)
  80007a:	f832                	sd	a2,48(sp)
  80007c:	fc36                	sd	a3,56(sp)
  80007e:	f03a                	sd	a4,32(sp)
  800080:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);

    asm volatile (
  800082:	4522                	lw	a0,8(sp)
  800084:	55a2                	lw	a1,40(sp)
  800086:	5642                	lw	a2,48(sp)
  800088:	56e2                	lw	a3,56(sp)
  80008a:	4706                	lw	a4,64(sp)
  80008c:	47a6                	lw	a5,72(sp)
  80008e:	00000073          	ecall
  800092:	ce2a                	sw	a0,28(sp)
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
    return ret;
}
  800094:	4572                	lw	a0,28(sp)
  800096:	6149                	addi	sp,sp,144
  800098:	8082                	ret

000000000080009a <sys_exit>:

int
sys_exit(int64_t error_code) {
  80009a:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  80009c:	4505                	li	a0,1
  80009e:	b7d1                	j	800062 <syscall>

00000000008000a0 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000a0:	4509                	li	a0,2
  8000a2:	b7c1                	j	800062 <syscall>

00000000008000a4 <sys_kill>:
sys_yield(void) {
    return syscall(SYS_yield);
}

int
sys_kill(int64_t pid) {
  8000a4:	85aa                	mv	a1,a0
    return syscall(SYS_kill, pid);
  8000a6:	4531                	li	a0,12
  8000a8:	bf6d                	j	800062 <syscall>

00000000008000aa <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000aa:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000ac:	4579                	li	a0,30
  8000ae:	bf55                	j	800062 <syscall>

00000000008000b0 <sys_sleep>:
{
    syscall(SYS_lab6_set_priority, priority);
}

int
sys_sleep(uint64_t time) {
  8000b0:	85aa                	mv	a1,a0
    return syscall(SYS_sleep, time);
  8000b2:	452d                	li	a0,11
  8000b4:	b77d                	j	800062 <syscall>

00000000008000b6 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000b6:	1141                	addi	sp,sp,-16
  8000b8:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000ba:	fe1ff0ef          	jal	ra,80009a <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000be:	00000517          	auipc	a0,0x0
  8000c2:	55250513          	addi	a0,a0,1362 # 800610 <main+0xae>
  8000c6:	050000ef          	jal	ra,800116 <cprintf>
    while (1);
  8000ca:	a001                	j	8000ca <exit+0x14>

00000000008000cc <fork>:
}

int
fork(void) {
    return sys_fork();
  8000cc:	bfd1                	j	8000a0 <sys_fork>

00000000008000ce <kill>:
    sys_yield();
}

int
kill(int pid) {
    return sys_kill(pid);
  8000ce:	bfd9                	j	8000a4 <sys_kill>

00000000008000d0 <sleep>:
    sys_lab6_set_priority(priority);
}

int
sleep(unsigned int time) {
    return sys_sleep(time);
  8000d0:	1502                	slli	a0,a0,0x20
  8000d2:	9101                	srli	a0,a0,0x20
  8000d4:	bff1                	j	8000b0 <sys_sleep>

00000000008000d6 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  8000d6:	076000ef          	jal	ra,80014c <umain>
1:  j 1b
  8000da:	a001                	j	8000da <_start+0x4>

00000000008000dc <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  8000dc:	1141                	addi	sp,sp,-16
  8000de:	e022                	sd	s0,0(sp)
  8000e0:	e406                	sd	ra,8(sp)
  8000e2:	842e                	mv	s0,a1
    sys_putc(c);
  8000e4:	fc7ff0ef          	jal	ra,8000aa <sys_putc>
    (*cnt) ++;
  8000e8:	401c                	lw	a5,0(s0)
}
  8000ea:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  8000ec:	2785                	addiw	a5,a5,1
  8000ee:	c01c                	sw	a5,0(s0)
}
  8000f0:	6402                	ld	s0,0(sp)
  8000f2:	0141                	addi	sp,sp,16
  8000f4:	8082                	ret

00000000008000f6 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8000f6:	1101                	addi	sp,sp,-32
  8000f8:	862a                	mv	a2,a0
  8000fa:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000fc:	00000517          	auipc	a0,0x0
  800100:	fe050513          	addi	a0,a0,-32 # 8000dc <cputch>
  800104:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
  800106:	ec06                	sd	ra,24(sp)
    int cnt = 0;
  800108:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80010a:	0d6000ef          	jal	ra,8001e0 <vprintfmt>
    return cnt;
}
  80010e:	60e2                	ld	ra,24(sp)
  800110:	4532                	lw	a0,12(sp)
  800112:	6105                	addi	sp,sp,32
  800114:	8082                	ret

0000000000800116 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800116:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800118:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  80011c:	8e2a                	mv	t3,a0
  80011e:	f42e                	sd	a1,40(sp)
  800120:	f832                	sd	a2,48(sp)
  800122:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800124:	00000517          	auipc	a0,0x0
  800128:	fb850513          	addi	a0,a0,-72 # 8000dc <cputch>
  80012c:	004c                	addi	a1,sp,4
  80012e:	869a                	mv	a3,t1
  800130:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  800132:	ec06                	sd	ra,24(sp)
  800134:	e0ba                	sd	a4,64(sp)
  800136:	e4be                	sd	a5,72(sp)
  800138:	e8c2                	sd	a6,80(sp)
  80013a:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  80013c:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  80013e:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800140:	0a0000ef          	jal	ra,8001e0 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  800144:	60e2                	ld	ra,24(sp)
  800146:	4512                	lw	a0,4(sp)
  800148:	6125                	addi	sp,sp,96
  80014a:	8082                	ret

000000000080014c <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  80014c:	1141                	addi	sp,sp,-16
  80014e:	e406                	sd	ra,8(sp)
    int ret = main();
  800150:	412000ef          	jal	ra,800562 <main>
    exit(ret);
  800154:	f63ff0ef          	jal	ra,8000b6 <exit>

0000000000800158 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800158:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  80015a:	e589                	bnez	a1,800164 <strnlen+0xc>
  80015c:	a811                	j	800170 <strnlen+0x18>
        cnt ++;
  80015e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800160:	00f58863          	beq	a1,a5,800170 <strnlen+0x18>
  800164:	00f50733          	add	a4,a0,a5
  800168:	00074703          	lbu	a4,0(a4)
  80016c:	fb6d                	bnez	a4,80015e <strnlen+0x6>
  80016e:	85be                	mv	a1,a5
    }
    return cnt;
}
  800170:	852e                	mv	a0,a1
  800172:	8082                	ret

0000000000800174 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800174:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800178:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  80017a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80017e:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  800180:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800184:	f022                	sd	s0,32(sp)
  800186:	ec26                	sd	s1,24(sp)
  800188:	e84a                	sd	s2,16(sp)
  80018a:	f406                	sd	ra,40(sp)
  80018c:	e44e                	sd	s3,8(sp)
  80018e:	84aa                	mv	s1,a0
  800190:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800192:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800196:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800198:	03067e63          	bgeu	a2,a6,8001d4 <printnum+0x60>
  80019c:	89be                	mv	s3,a5
        while (-- width > 0)
  80019e:	00805763          	blez	s0,8001ac <printnum+0x38>
  8001a2:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001a4:	85ca                	mv	a1,s2
  8001a6:	854e                	mv	a0,s3
  8001a8:	9482                	jalr	s1
        while (-- width > 0)
  8001aa:	fc65                	bnez	s0,8001a2 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001ac:	1a02                	slli	s4,s4,0x20
  8001ae:	00000797          	auipc	a5,0x0
  8001b2:	47a78793          	addi	a5,a5,1146 # 800628 <main+0xc6>
  8001b6:	020a5a13          	srli	s4,s4,0x20
  8001ba:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001bc:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001be:	000a4503          	lbu	a0,0(s4)
}
  8001c2:	70a2                	ld	ra,40(sp)
  8001c4:	69a2                	ld	s3,8(sp)
  8001c6:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001c8:	85ca                	mv	a1,s2
  8001ca:	87a6                	mv	a5,s1
}
  8001cc:	6942                	ld	s2,16(sp)
  8001ce:	64e2                	ld	s1,24(sp)
  8001d0:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001d2:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001d4:	03065633          	divu	a2,a2,a6
  8001d8:	8722                	mv	a4,s0
  8001da:	f9bff0ef          	jal	ra,800174 <printnum>
  8001de:	b7f9                	j	8001ac <printnum+0x38>

00000000008001e0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001e0:	7119                	addi	sp,sp,-128
  8001e2:	f4a6                	sd	s1,104(sp)
  8001e4:	f0ca                	sd	s2,96(sp)
  8001e6:	ecce                	sd	s3,88(sp)
  8001e8:	e8d2                	sd	s4,80(sp)
  8001ea:	e4d6                	sd	s5,72(sp)
  8001ec:	e0da                	sd	s6,64(sp)
  8001ee:	fc5e                	sd	s7,56(sp)
  8001f0:	f06a                	sd	s10,32(sp)
  8001f2:	fc86                	sd	ra,120(sp)
  8001f4:	f8a2                	sd	s0,112(sp)
  8001f6:	f862                	sd	s8,48(sp)
  8001f8:	f466                	sd	s9,40(sp)
  8001fa:	ec6e                	sd	s11,24(sp)
  8001fc:	892a                	mv	s2,a0
  8001fe:	84ae                	mv	s1,a1
  800200:	8d32                	mv	s10,a2
  800202:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800204:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800208:	5b7d                	li	s6,-1
  80020a:	00000a97          	auipc	s5,0x0
  80020e:	452a8a93          	addi	s5,s5,1106 # 80065c <main+0xfa>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800212:	00000b97          	auipc	s7,0x0
  800216:	666b8b93          	addi	s7,s7,1638 # 800878 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80021a:	000d4503          	lbu	a0,0(s10)
  80021e:	001d0413          	addi	s0,s10,1
  800222:	01350a63          	beq	a0,s3,800236 <vprintfmt+0x56>
            if (ch == '\0') {
  800226:	c121                	beqz	a0,800266 <vprintfmt+0x86>
            putch(ch, putdat);
  800228:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80022a:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80022c:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80022e:	fff44503          	lbu	a0,-1(s0)
  800232:	ff351ae3          	bne	a0,s3,800226 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  800236:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  80023a:	02000793          	li	a5,32
        lflag = altflag = 0;
  80023e:	4c81                	li	s9,0
  800240:	4881                	li	a7,0
        width = precision = -1;
  800242:	5c7d                	li	s8,-1
  800244:	5dfd                	li	s11,-1
  800246:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  80024a:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  80024c:	fdd6059b          	addiw	a1,a2,-35
  800250:	0ff5f593          	zext.b	a1,a1
  800254:	00140d13          	addi	s10,s0,1
  800258:	04b56263          	bltu	a0,a1,80029c <vprintfmt+0xbc>
  80025c:	058a                	slli	a1,a1,0x2
  80025e:	95d6                	add	a1,a1,s5
  800260:	4194                	lw	a3,0(a1)
  800262:	96d6                	add	a3,a3,s5
  800264:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800266:	70e6                	ld	ra,120(sp)
  800268:	7446                	ld	s0,112(sp)
  80026a:	74a6                	ld	s1,104(sp)
  80026c:	7906                	ld	s2,96(sp)
  80026e:	69e6                	ld	s3,88(sp)
  800270:	6a46                	ld	s4,80(sp)
  800272:	6aa6                	ld	s5,72(sp)
  800274:	6b06                	ld	s6,64(sp)
  800276:	7be2                	ld	s7,56(sp)
  800278:	7c42                	ld	s8,48(sp)
  80027a:	7ca2                	ld	s9,40(sp)
  80027c:	7d02                	ld	s10,32(sp)
  80027e:	6de2                	ld	s11,24(sp)
  800280:	6109                	addi	sp,sp,128
  800282:	8082                	ret
            padc = '0';
  800284:	87b2                	mv	a5,a2
            goto reswitch;
  800286:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80028a:	846a                	mv	s0,s10
  80028c:	00140d13          	addi	s10,s0,1
  800290:	fdd6059b          	addiw	a1,a2,-35
  800294:	0ff5f593          	zext.b	a1,a1
  800298:	fcb572e3          	bgeu	a0,a1,80025c <vprintfmt+0x7c>
            putch('%', putdat);
  80029c:	85a6                	mv	a1,s1
  80029e:	02500513          	li	a0,37
  8002a2:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  8002a4:	fff44783          	lbu	a5,-1(s0)
  8002a8:	8d22                	mv	s10,s0
  8002aa:	f73788e3          	beq	a5,s3,80021a <vprintfmt+0x3a>
  8002ae:	ffed4783          	lbu	a5,-2(s10)
  8002b2:	1d7d                	addi	s10,s10,-1
  8002b4:	ff379de3          	bne	a5,s3,8002ae <vprintfmt+0xce>
  8002b8:	b78d                	j	80021a <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  8002ba:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  8002be:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002c2:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  8002c4:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  8002c8:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002cc:	02d86463          	bltu	a6,a3,8002f4 <vprintfmt+0x114>
                ch = *fmt;
  8002d0:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  8002d4:	002c169b          	slliw	a3,s8,0x2
  8002d8:	0186873b          	addw	a4,a3,s8
  8002dc:	0017171b          	slliw	a4,a4,0x1
  8002e0:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  8002e2:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  8002e6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002e8:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002ec:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002f0:	fed870e3          	bgeu	a6,a3,8002d0 <vprintfmt+0xf0>
            if (width < 0)
  8002f4:	f40ddce3          	bgez	s11,80024c <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002f8:	8de2                	mv	s11,s8
  8002fa:	5c7d                	li	s8,-1
  8002fc:	bf81                	j	80024c <vprintfmt+0x6c>
            if (width < 0)
  8002fe:	fffdc693          	not	a3,s11
  800302:	96fd                	srai	a3,a3,0x3f
  800304:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  800308:	00144603          	lbu	a2,1(s0)
  80030c:	2d81                	sext.w	s11,s11
  80030e:	846a                	mv	s0,s10
            goto reswitch;
  800310:	bf35                	j	80024c <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800312:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800316:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  80031a:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  80031c:	846a                	mv	s0,s10
            goto process_precision;
  80031e:	bfd9                	j	8002f4 <vprintfmt+0x114>
    if (lflag >= 2) {
  800320:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800322:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800326:	01174463          	blt	a4,a7,80032e <vprintfmt+0x14e>
    else if (lflag) {
  80032a:	1a088e63          	beqz	a7,8004e6 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  80032e:	000a3603          	ld	a2,0(s4)
  800332:	46c1                	li	a3,16
  800334:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  800336:	2781                	sext.w	a5,a5
  800338:	876e                	mv	a4,s11
  80033a:	85a6                	mv	a1,s1
  80033c:	854a                	mv	a0,s2
  80033e:	e37ff0ef          	jal	ra,800174 <printnum>
            break;
  800342:	bde1                	j	80021a <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  800344:	000a2503          	lw	a0,0(s4)
  800348:	85a6                	mv	a1,s1
  80034a:	0a21                	addi	s4,s4,8
  80034c:	9902                	jalr	s2
            break;
  80034e:	b5f1                	j	80021a <vprintfmt+0x3a>
    if (lflag >= 2) {
  800350:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800352:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800356:	01174463          	blt	a4,a7,80035e <vprintfmt+0x17e>
    else if (lflag) {
  80035a:	18088163          	beqz	a7,8004dc <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  80035e:	000a3603          	ld	a2,0(s4)
  800362:	46a9                	li	a3,10
  800364:	8a2e                	mv	s4,a1
  800366:	bfc1                	j	800336 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  800368:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  80036c:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  80036e:	846a                	mv	s0,s10
            goto reswitch;
  800370:	bdf1                	j	80024c <vprintfmt+0x6c>
            putch(ch, putdat);
  800372:	85a6                	mv	a1,s1
  800374:	02500513          	li	a0,37
  800378:	9902                	jalr	s2
            break;
  80037a:	b545                	j	80021a <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  80037c:	00144603          	lbu	a2,1(s0)
            lflag ++;
  800380:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  800382:	846a                	mv	s0,s10
            goto reswitch;
  800384:	b5e1                	j	80024c <vprintfmt+0x6c>
    if (lflag >= 2) {
  800386:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800388:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  80038c:	01174463          	blt	a4,a7,800394 <vprintfmt+0x1b4>
    else if (lflag) {
  800390:	14088163          	beqz	a7,8004d2 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800394:	000a3603          	ld	a2,0(s4)
  800398:	46a1                	li	a3,8
  80039a:	8a2e                	mv	s4,a1
  80039c:	bf69                	j	800336 <vprintfmt+0x156>
            putch('0', putdat);
  80039e:	03000513          	li	a0,48
  8003a2:	85a6                	mv	a1,s1
  8003a4:	e03e                	sd	a5,0(sp)
  8003a6:	9902                	jalr	s2
            putch('x', putdat);
  8003a8:	85a6                	mv	a1,s1
  8003aa:	07800513          	li	a0,120
  8003ae:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003b0:	0a21                	addi	s4,s4,8
            goto number;
  8003b2:	6782                	ld	a5,0(sp)
  8003b4:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003b6:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  8003ba:	bfb5                	j	800336 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003bc:	000a3403          	ld	s0,0(s4)
  8003c0:	008a0713          	addi	a4,s4,8
  8003c4:	e03a                	sd	a4,0(sp)
  8003c6:	14040263          	beqz	s0,80050a <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  8003ca:	0fb05763          	blez	s11,8004b8 <vprintfmt+0x2d8>
  8003ce:	02d00693          	li	a3,45
  8003d2:	0cd79163          	bne	a5,a3,800494 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003d6:	00044783          	lbu	a5,0(s0)
  8003da:	0007851b          	sext.w	a0,a5
  8003de:	cf85                	beqz	a5,800416 <vprintfmt+0x236>
  8003e0:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003e4:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003e8:	000c4563          	bltz	s8,8003f2 <vprintfmt+0x212>
  8003ec:	3c7d                	addiw	s8,s8,-1
  8003ee:	036c0263          	beq	s8,s6,800412 <vprintfmt+0x232>
                    putch('?', putdat);
  8003f2:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003f4:	0e0c8e63          	beqz	s9,8004f0 <vprintfmt+0x310>
  8003f8:	3781                	addiw	a5,a5,-32
  8003fa:	0ef47b63          	bgeu	s0,a5,8004f0 <vprintfmt+0x310>
                    putch('?', putdat);
  8003fe:	03f00513          	li	a0,63
  800402:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800404:	000a4783          	lbu	a5,0(s4)
  800408:	3dfd                	addiw	s11,s11,-1
  80040a:	0a05                	addi	s4,s4,1
  80040c:	0007851b          	sext.w	a0,a5
  800410:	ffe1                	bnez	a5,8003e8 <vprintfmt+0x208>
            for (; width > 0; width --) {
  800412:	01b05963          	blez	s11,800424 <vprintfmt+0x244>
  800416:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  800418:	85a6                	mv	a1,s1
  80041a:	02000513          	li	a0,32
  80041e:	9902                	jalr	s2
            for (; width > 0; width --) {
  800420:	fe0d9be3          	bnez	s11,800416 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  800424:	6a02                	ld	s4,0(sp)
  800426:	bbd5                	j	80021a <vprintfmt+0x3a>
    if (lflag >= 2) {
  800428:	4705                	li	a4,1
            precision = va_arg(ap, int);
  80042a:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  80042e:	01174463          	blt	a4,a7,800436 <vprintfmt+0x256>
    else if (lflag) {
  800432:	08088d63          	beqz	a7,8004cc <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  800436:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  80043a:	0a044d63          	bltz	s0,8004f4 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  80043e:	8622                	mv	a2,s0
  800440:	8a66                	mv	s4,s9
  800442:	46a9                	li	a3,10
  800444:	bdcd                	j	800336 <vprintfmt+0x156>
            err = va_arg(ap, int);
  800446:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80044a:	4761                	li	a4,24
            err = va_arg(ap, int);
  80044c:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80044e:	41f7d69b          	sraiw	a3,a5,0x1f
  800452:	8fb5                	xor	a5,a5,a3
  800454:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800458:	02d74163          	blt	a4,a3,80047a <vprintfmt+0x29a>
  80045c:	00369793          	slli	a5,a3,0x3
  800460:	97de                	add	a5,a5,s7
  800462:	639c                	ld	a5,0(a5)
  800464:	cb99                	beqz	a5,80047a <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  800466:	86be                	mv	a3,a5
  800468:	00000617          	auipc	a2,0x0
  80046c:	1f060613          	addi	a2,a2,496 # 800658 <main+0xf6>
  800470:	85a6                	mv	a1,s1
  800472:	854a                	mv	a0,s2
  800474:	0ce000ef          	jal	ra,800542 <printfmt>
  800478:	b34d                	j	80021a <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  80047a:	00000617          	auipc	a2,0x0
  80047e:	1ce60613          	addi	a2,a2,462 # 800648 <main+0xe6>
  800482:	85a6                	mv	a1,s1
  800484:	854a                	mv	a0,s2
  800486:	0bc000ef          	jal	ra,800542 <printfmt>
  80048a:	bb41                	j	80021a <vprintfmt+0x3a>
                p = "(null)";
  80048c:	00000417          	auipc	s0,0x0
  800490:	1b440413          	addi	s0,s0,436 # 800640 <main+0xde>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800494:	85e2                	mv	a1,s8
  800496:	8522                	mv	a0,s0
  800498:	e43e                	sd	a5,8(sp)
  80049a:	cbfff0ef          	jal	ra,800158 <strnlen>
  80049e:	40ad8dbb          	subw	s11,s11,a0
  8004a2:	01b05b63          	blez	s11,8004b8 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  8004a6:	67a2                	ld	a5,8(sp)
  8004a8:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004ac:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  8004ae:	85a6                	mv	a1,s1
  8004b0:	8552                	mv	a0,s4
  8004b2:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004b4:	fe0d9ce3          	bnez	s11,8004ac <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004b8:	00044783          	lbu	a5,0(s0)
  8004bc:	00140a13          	addi	s4,s0,1
  8004c0:	0007851b          	sext.w	a0,a5
  8004c4:	d3a5                	beqz	a5,800424 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004c6:	05e00413          	li	s0,94
  8004ca:	bf39                	j	8003e8 <vprintfmt+0x208>
        return va_arg(*ap, int);
  8004cc:	000a2403          	lw	s0,0(s4)
  8004d0:	b7ad                	j	80043a <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  8004d2:	000a6603          	lwu	a2,0(s4)
  8004d6:	46a1                	li	a3,8
  8004d8:	8a2e                	mv	s4,a1
  8004da:	bdb1                	j	800336 <vprintfmt+0x156>
  8004dc:	000a6603          	lwu	a2,0(s4)
  8004e0:	46a9                	li	a3,10
  8004e2:	8a2e                	mv	s4,a1
  8004e4:	bd89                	j	800336 <vprintfmt+0x156>
  8004e6:	000a6603          	lwu	a2,0(s4)
  8004ea:	46c1                	li	a3,16
  8004ec:	8a2e                	mv	s4,a1
  8004ee:	b5a1                	j	800336 <vprintfmt+0x156>
                    putch(ch, putdat);
  8004f0:	9902                	jalr	s2
  8004f2:	bf09                	j	800404 <vprintfmt+0x224>
                putch('-', putdat);
  8004f4:	85a6                	mv	a1,s1
  8004f6:	02d00513          	li	a0,45
  8004fa:	e03e                	sd	a5,0(sp)
  8004fc:	9902                	jalr	s2
                num = -(long long)num;
  8004fe:	6782                	ld	a5,0(sp)
  800500:	8a66                	mv	s4,s9
  800502:	40800633          	neg	a2,s0
  800506:	46a9                	li	a3,10
  800508:	b53d                	j	800336 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  80050a:	03b05163          	blez	s11,80052c <vprintfmt+0x34c>
  80050e:	02d00693          	li	a3,45
  800512:	f6d79de3          	bne	a5,a3,80048c <vprintfmt+0x2ac>
                p = "(null)";
  800516:	00000417          	auipc	s0,0x0
  80051a:	12a40413          	addi	s0,s0,298 # 800640 <main+0xde>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80051e:	02800793          	li	a5,40
  800522:	02800513          	li	a0,40
  800526:	00140a13          	addi	s4,s0,1
  80052a:	bd6d                	j	8003e4 <vprintfmt+0x204>
  80052c:	00000a17          	auipc	s4,0x0
  800530:	115a0a13          	addi	s4,s4,277 # 800641 <main+0xdf>
  800534:	02800513          	li	a0,40
  800538:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  80053c:	05e00413          	li	s0,94
  800540:	b565                	j	8003e8 <vprintfmt+0x208>

0000000000800542 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800542:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  800544:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800548:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  80054a:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80054c:	ec06                	sd	ra,24(sp)
  80054e:	f83a                	sd	a4,48(sp)
  800550:	fc3e                	sd	a5,56(sp)
  800552:	e0c2                	sd	a6,64(sp)
  800554:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800556:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800558:	c89ff0ef          	jal	ra,8001e0 <vprintfmt>
}
  80055c:	60e2                	ld	ra,24(sp)
  80055e:	6161                	addi	sp,sp,80
  800560:	8082                	ret

0000000000800562 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  800562:	1141                	addi	sp,sp,-16
  800564:	e406                	sd	ra,8(sp)
  800566:	e022                	sd	s0,0(sp)
    int pid;
    if ((pid = fork()) == 0) {
  800568:	b65ff0ef          	jal	ra,8000cc <fork>
  80056c:	c51d                	beqz	a0,80059a <main+0x38>
  80056e:	842a                	mv	s0,a0
        sleep(~0);
        exit(0xdead);
    }
    assert(pid > 0);
  800570:	04a05c63          	blez	a0,8005c8 <main+0x66>

    sleep(100);
  800574:	06400513          	li	a0,100
  800578:	b59ff0ef          	jal	ra,8000d0 <sleep>
    assert(kill(pid) == 0);
  80057c:	8522                	mv	a0,s0
  80057e:	b51ff0ef          	jal	ra,8000ce <kill>
  800582:	e505                	bnez	a0,8005aa <main+0x48>
    cprintf("sleepkill pass.\n");
  800584:	00000517          	auipc	a0,0x0
  800588:	40450513          	addi	a0,a0,1028 # 800988 <error_string+0x110>
  80058c:	b8bff0ef          	jal	ra,800116 <cprintf>
    return 0;
}
  800590:	60a2                	ld	ra,8(sp)
  800592:	6402                	ld	s0,0(sp)
  800594:	4501                	li	a0,0
  800596:	0141                	addi	sp,sp,16
  800598:	8082                	ret
        sleep(~0);
  80059a:	557d                	li	a0,-1
  80059c:	b35ff0ef          	jal	ra,8000d0 <sleep>
        exit(0xdead);
  8005a0:	6539                	lui	a0,0xe
  8005a2:	ead50513          	addi	a0,a0,-339 # dead <__panic-0x7f2173>
  8005a6:	b11ff0ef          	jal	ra,8000b6 <exit>
    assert(kill(pid) == 0);
  8005aa:	00000697          	auipc	a3,0x0
  8005ae:	3ce68693          	addi	a3,a3,974 # 800978 <error_string+0x100>
  8005b2:	00000617          	auipc	a2,0x0
  8005b6:	39660613          	addi	a2,a2,918 # 800948 <error_string+0xd0>
  8005ba:	45b9                	li	a1,14
  8005bc:	00000517          	auipc	a0,0x0
  8005c0:	3a450513          	addi	a0,a0,932 # 800960 <error_string+0xe8>
  8005c4:	a5dff0ef          	jal	ra,800020 <__panic>
    assert(pid > 0);
  8005c8:	00000697          	auipc	a3,0x0
  8005cc:	37868693          	addi	a3,a3,888 # 800940 <error_string+0xc8>
  8005d0:	00000617          	auipc	a2,0x0
  8005d4:	37860613          	addi	a2,a2,888 # 800948 <error_string+0xd0>
  8005d8:	45ad                	li	a1,11
  8005da:	00000517          	auipc	a0,0x0
  8005de:	38650513          	addi	a0,a0,902 # 800960 <error_string+0xe8>
  8005e2:	a3fff0ef          	jal	ra,800020 <__panic>
