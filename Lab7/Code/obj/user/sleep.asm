
obj/__user_sleep.out:     file format elf64-littleriscv


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
  800034:	5e050513          	addi	a0,a0,1504 # 800610 <main+0x70>
__panic(const char *file, int line, const char *fmt, ...) {
  800038:	ec06                	sd	ra,24(sp)
  80003a:	f436                	sd	a3,40(sp)
  80003c:	f83a                	sd	a4,48(sp)
  80003e:	e0c2                	sd	a6,64(sp)
  800040:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800042:	e43e                	sd	a5,8(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  800044:	0da000ef          	jal	ra,80011e <cprintf>
    vcprintf(fmt, ap);
  800048:	65a2                	ld	a1,8(sp)
  80004a:	8522                	mv	a0,s0
  80004c:	0b2000ef          	jal	ra,8000fe <vcprintf>
    cprintf("\n");
  800050:	00000517          	auipc	a0,0x0
  800054:	5e050513          	addi	a0,a0,1504 # 800630 <main+0x90>
  800058:	0c6000ef          	jal	ra,80011e <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  80005c:	5559                	li	a0,-10
  80005e:	05e000ef          	jal	ra,8000bc <exit>

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

00000000008000a4 <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000a4:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000a6:	85aa                	mv	a1,a0
  8000a8:	450d                	li	a0,3
  8000aa:	bf65                	j	800062 <syscall>

00000000008000ac <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000ac:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000ae:	4579                	li	a0,30
  8000b0:	bf4d                	j	800062 <syscall>

00000000008000b2 <sys_gettime>:
    return syscall(SYS_pgdir);
}

int
sys_gettime(void) {
    return syscall(SYS_gettime);
  8000b2:	4545                	li	a0,17
  8000b4:	b77d                	j	800062 <syscall>

00000000008000b6 <sys_sleep>:
{
    syscall(SYS_lab6_set_priority, priority);
}

int
sys_sleep(uint64_t time) {
  8000b6:	85aa                	mv	a1,a0
    return syscall(SYS_sleep, time);
  8000b8:	452d                	li	a0,11
  8000ba:	b765                	j	800062 <syscall>

00000000008000bc <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000bc:	1141                	addi	sp,sp,-16
  8000be:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000c0:	fdbff0ef          	jal	ra,80009a <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000c4:	00000517          	auipc	a0,0x0
  8000c8:	57450513          	addi	a0,a0,1396 # 800638 <main+0x98>
  8000cc:	052000ef          	jal	ra,80011e <cprintf>
    while (1);
  8000d0:	a001                	j	8000d0 <exit+0x14>

00000000008000d2 <fork>:
}

int
fork(void) {
    return sys_fork();
  8000d2:	b7f9                	j	8000a0 <sys_fork>

00000000008000d4 <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  8000d4:	bfc1                	j	8000a4 <sys_wait>

00000000008000d6 <gettime_msec>:
    sys_pgdir();
}

unsigned int
gettime_msec(void) {
    return (unsigned int)sys_gettime();
  8000d6:	bff1                	j	8000b2 <sys_gettime>

00000000008000d8 <sleep>:
    sys_lab6_set_priority(priority);
}

int
sleep(unsigned int time) {
    return sys_sleep(time);
  8000d8:	1502                	slli	a0,a0,0x20
  8000da:	9101                	srli	a0,a0,0x20
  8000dc:	bfe9                	j	8000b6 <sys_sleep>

00000000008000de <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  8000de:	076000ef          	jal	ra,800154 <umain>
1:  j 1b
  8000e2:	a001                	j	8000e2 <_start+0x4>

00000000008000e4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  8000e4:	1141                	addi	sp,sp,-16
  8000e6:	e022                	sd	s0,0(sp)
  8000e8:	e406                	sd	ra,8(sp)
  8000ea:	842e                	mv	s0,a1
    sys_putc(c);
  8000ec:	fc1ff0ef          	jal	ra,8000ac <sys_putc>
    (*cnt) ++;
  8000f0:	401c                	lw	a5,0(s0)
}
  8000f2:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  8000f4:	2785                	addiw	a5,a5,1
  8000f6:	c01c                	sw	a5,0(s0)
}
  8000f8:	6402                	ld	s0,0(sp)
  8000fa:	0141                	addi	sp,sp,16
  8000fc:	8082                	ret

00000000008000fe <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8000fe:	1101                	addi	sp,sp,-32
  800100:	862a                	mv	a2,a0
  800102:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800104:	00000517          	auipc	a0,0x0
  800108:	fe050513          	addi	a0,a0,-32 # 8000e4 <cputch>
  80010c:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
  80010e:	ec06                	sd	ra,24(sp)
    int cnt = 0;
  800110:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800112:	0d6000ef          	jal	ra,8001e8 <vprintfmt>
    return cnt;
}
  800116:	60e2                	ld	ra,24(sp)
  800118:	4532                	lw	a0,12(sp)
  80011a:	6105                	addi	sp,sp,32
  80011c:	8082                	ret

000000000080011e <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  80011e:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800120:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800124:	8e2a                	mv	t3,a0
  800126:	f42e                	sd	a1,40(sp)
  800128:	f832                	sd	a2,48(sp)
  80012a:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80012c:	00000517          	auipc	a0,0x0
  800130:	fb850513          	addi	a0,a0,-72 # 8000e4 <cputch>
  800134:	004c                	addi	a1,sp,4
  800136:	869a                	mv	a3,t1
  800138:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80013a:	ec06                	sd	ra,24(sp)
  80013c:	e0ba                	sd	a4,64(sp)
  80013e:	e4be                	sd	a5,72(sp)
  800140:	e8c2                	sd	a6,80(sp)
  800142:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800144:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800146:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800148:	0a0000ef          	jal	ra,8001e8 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80014c:	60e2                	ld	ra,24(sp)
  80014e:	4512                	lw	a0,4(sp)
  800150:	6125                	addi	sp,sp,96
  800152:	8082                	ret

0000000000800154 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800154:	1141                	addi	sp,sp,-16
  800156:	e406                	sd	ra,8(sp)
    int ret = main();
  800158:	448000ef          	jal	ra,8005a0 <main>
    exit(ret);
  80015c:	f61ff0ef          	jal	ra,8000bc <exit>

0000000000800160 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800160:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800162:	e589                	bnez	a1,80016c <strnlen+0xc>
  800164:	a811                	j	800178 <strnlen+0x18>
        cnt ++;
  800166:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800168:	00f58863          	beq	a1,a5,800178 <strnlen+0x18>
  80016c:	00f50733          	add	a4,a0,a5
  800170:	00074703          	lbu	a4,0(a4)
  800174:	fb6d                	bnez	a4,800166 <strnlen+0x6>
  800176:	85be                	mv	a1,a5
    }
    return cnt;
}
  800178:	852e                	mv	a0,a1
  80017a:	8082                	ret

000000000080017c <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  80017c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800180:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  800182:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800186:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  800188:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  80018c:	f022                	sd	s0,32(sp)
  80018e:	ec26                	sd	s1,24(sp)
  800190:	e84a                	sd	s2,16(sp)
  800192:	f406                	sd	ra,40(sp)
  800194:	e44e                	sd	s3,8(sp)
  800196:	84aa                	mv	s1,a0
  800198:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80019a:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  80019e:	2a01                	sext.w	s4,s4
    if (num >= base) {
  8001a0:	03067e63          	bgeu	a2,a6,8001dc <printnum+0x60>
  8001a4:	89be                	mv	s3,a5
        while (-- width > 0)
  8001a6:	00805763          	blez	s0,8001b4 <printnum+0x38>
  8001aa:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  8001ac:	85ca                	mv	a1,s2
  8001ae:	854e                	mv	a0,s3
  8001b0:	9482                	jalr	s1
        while (-- width > 0)
  8001b2:	fc65                	bnez	s0,8001aa <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001b4:	1a02                	slli	s4,s4,0x20
  8001b6:	00000797          	auipc	a5,0x0
  8001ba:	49a78793          	addi	a5,a5,1178 # 800650 <main+0xb0>
  8001be:	020a5a13          	srli	s4,s4,0x20
  8001c2:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001c4:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001c6:	000a4503          	lbu	a0,0(s4)
}
  8001ca:	70a2                	ld	ra,40(sp)
  8001cc:	69a2                	ld	s3,8(sp)
  8001ce:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001d0:	85ca                	mv	a1,s2
  8001d2:	87a6                	mv	a5,s1
}
  8001d4:	6942                	ld	s2,16(sp)
  8001d6:	64e2                	ld	s1,24(sp)
  8001d8:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001da:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001dc:	03065633          	divu	a2,a2,a6
  8001e0:	8722                	mv	a4,s0
  8001e2:	f9bff0ef          	jal	ra,80017c <printnum>
  8001e6:	b7f9                	j	8001b4 <printnum+0x38>

00000000008001e8 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001e8:	7119                	addi	sp,sp,-128
  8001ea:	f4a6                	sd	s1,104(sp)
  8001ec:	f0ca                	sd	s2,96(sp)
  8001ee:	ecce                	sd	s3,88(sp)
  8001f0:	e8d2                	sd	s4,80(sp)
  8001f2:	e4d6                	sd	s5,72(sp)
  8001f4:	e0da                	sd	s6,64(sp)
  8001f6:	fc5e                	sd	s7,56(sp)
  8001f8:	f06a                	sd	s10,32(sp)
  8001fa:	fc86                	sd	ra,120(sp)
  8001fc:	f8a2                	sd	s0,112(sp)
  8001fe:	f862                	sd	s8,48(sp)
  800200:	f466                	sd	s9,40(sp)
  800202:	ec6e                	sd	s11,24(sp)
  800204:	892a                	mv	s2,a0
  800206:	84ae                	mv	s1,a1
  800208:	8d32                	mv	s10,a2
  80020a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80020c:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800210:	5b7d                	li	s6,-1
  800212:	00000a97          	auipc	s5,0x0
  800216:	472a8a93          	addi	s5,s5,1138 # 800684 <main+0xe4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80021a:	00000b97          	auipc	s7,0x0
  80021e:	686b8b93          	addi	s7,s7,1670 # 8008a0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800222:	000d4503          	lbu	a0,0(s10)
  800226:	001d0413          	addi	s0,s10,1
  80022a:	01350a63          	beq	a0,s3,80023e <vprintfmt+0x56>
            if (ch == '\0') {
  80022e:	c121                	beqz	a0,80026e <vprintfmt+0x86>
            putch(ch, putdat);
  800230:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800232:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  800234:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800236:	fff44503          	lbu	a0,-1(s0)
  80023a:	ff351ae3          	bne	a0,s3,80022e <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  80023e:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  800242:	02000793          	li	a5,32
        lflag = altflag = 0;
  800246:	4c81                	li	s9,0
  800248:	4881                	li	a7,0
        width = precision = -1;
  80024a:	5c7d                	li	s8,-1
  80024c:	5dfd                	li	s11,-1
  80024e:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  800252:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  800254:	fdd6059b          	addiw	a1,a2,-35
  800258:	0ff5f593          	zext.b	a1,a1
  80025c:	00140d13          	addi	s10,s0,1
  800260:	04b56263          	bltu	a0,a1,8002a4 <vprintfmt+0xbc>
  800264:	058a                	slli	a1,a1,0x2
  800266:	95d6                	add	a1,a1,s5
  800268:	4194                	lw	a3,0(a1)
  80026a:	96d6                	add	a3,a3,s5
  80026c:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80026e:	70e6                	ld	ra,120(sp)
  800270:	7446                	ld	s0,112(sp)
  800272:	74a6                	ld	s1,104(sp)
  800274:	7906                	ld	s2,96(sp)
  800276:	69e6                	ld	s3,88(sp)
  800278:	6a46                	ld	s4,80(sp)
  80027a:	6aa6                	ld	s5,72(sp)
  80027c:	6b06                	ld	s6,64(sp)
  80027e:	7be2                	ld	s7,56(sp)
  800280:	7c42                	ld	s8,48(sp)
  800282:	7ca2                	ld	s9,40(sp)
  800284:	7d02                	ld	s10,32(sp)
  800286:	6de2                	ld	s11,24(sp)
  800288:	6109                	addi	sp,sp,128
  80028a:	8082                	ret
            padc = '0';
  80028c:	87b2                	mv	a5,a2
            goto reswitch;
  80028e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800292:	846a                	mv	s0,s10
  800294:	00140d13          	addi	s10,s0,1
  800298:	fdd6059b          	addiw	a1,a2,-35
  80029c:	0ff5f593          	zext.b	a1,a1
  8002a0:	fcb572e3          	bgeu	a0,a1,800264 <vprintfmt+0x7c>
            putch('%', putdat);
  8002a4:	85a6                	mv	a1,s1
  8002a6:	02500513          	li	a0,37
  8002aa:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  8002ac:	fff44783          	lbu	a5,-1(s0)
  8002b0:	8d22                	mv	s10,s0
  8002b2:	f73788e3          	beq	a5,s3,800222 <vprintfmt+0x3a>
  8002b6:	ffed4783          	lbu	a5,-2(s10)
  8002ba:	1d7d                	addi	s10,s10,-1
  8002bc:	ff379de3          	bne	a5,s3,8002b6 <vprintfmt+0xce>
  8002c0:	b78d                	j	800222 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  8002c2:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  8002c6:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002ca:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  8002cc:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  8002d0:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002d4:	02d86463          	bltu	a6,a3,8002fc <vprintfmt+0x114>
                ch = *fmt;
  8002d8:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  8002dc:	002c169b          	slliw	a3,s8,0x2
  8002e0:	0186873b          	addw	a4,a3,s8
  8002e4:	0017171b          	slliw	a4,a4,0x1
  8002e8:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  8002ea:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  8002ee:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002f0:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002f4:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002f8:	fed870e3          	bgeu	a6,a3,8002d8 <vprintfmt+0xf0>
            if (width < 0)
  8002fc:	f40ddce3          	bgez	s11,800254 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800300:	8de2                	mv	s11,s8
  800302:	5c7d                	li	s8,-1
  800304:	bf81                	j	800254 <vprintfmt+0x6c>
            if (width < 0)
  800306:	fffdc693          	not	a3,s11
  80030a:	96fd                	srai	a3,a3,0x3f
  80030c:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  800310:	00144603          	lbu	a2,1(s0)
  800314:	2d81                	sext.w	s11,s11
  800316:	846a                	mv	s0,s10
            goto reswitch;
  800318:	bf35                	j	800254 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80031a:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  80031e:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  800322:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800324:	846a                	mv	s0,s10
            goto process_precision;
  800326:	bfd9                	j	8002fc <vprintfmt+0x114>
    if (lflag >= 2) {
  800328:	4705                	li	a4,1
            precision = va_arg(ap, int);
  80032a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  80032e:	01174463          	blt	a4,a7,800336 <vprintfmt+0x14e>
    else if (lflag) {
  800332:	1a088e63          	beqz	a7,8004ee <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  800336:	000a3603          	ld	a2,0(s4)
  80033a:	46c1                	li	a3,16
  80033c:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  80033e:	2781                	sext.w	a5,a5
  800340:	876e                	mv	a4,s11
  800342:	85a6                	mv	a1,s1
  800344:	854a                	mv	a0,s2
  800346:	e37ff0ef          	jal	ra,80017c <printnum>
            break;
  80034a:	bde1                	j	800222 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  80034c:	000a2503          	lw	a0,0(s4)
  800350:	85a6                	mv	a1,s1
  800352:	0a21                	addi	s4,s4,8
  800354:	9902                	jalr	s2
            break;
  800356:	b5f1                	j	800222 <vprintfmt+0x3a>
    if (lflag >= 2) {
  800358:	4705                	li	a4,1
            precision = va_arg(ap, int);
  80035a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  80035e:	01174463          	blt	a4,a7,800366 <vprintfmt+0x17e>
    else if (lflag) {
  800362:	18088163          	beqz	a7,8004e4 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  800366:	000a3603          	ld	a2,0(s4)
  80036a:	46a9                	li	a3,10
  80036c:	8a2e                	mv	s4,a1
  80036e:	bfc1                	j	80033e <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  800370:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  800374:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  800376:	846a                	mv	s0,s10
            goto reswitch;
  800378:	bdf1                	j	800254 <vprintfmt+0x6c>
            putch(ch, putdat);
  80037a:	85a6                	mv	a1,s1
  80037c:	02500513          	li	a0,37
  800380:	9902                	jalr	s2
            break;
  800382:	b545                	j	800222 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  800384:	00144603          	lbu	a2,1(s0)
            lflag ++;
  800388:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  80038a:	846a                	mv	s0,s10
            goto reswitch;
  80038c:	b5e1                	j	800254 <vprintfmt+0x6c>
    if (lflag >= 2) {
  80038e:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800390:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800394:	01174463          	blt	a4,a7,80039c <vprintfmt+0x1b4>
    else if (lflag) {
  800398:	14088163          	beqz	a7,8004da <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  80039c:	000a3603          	ld	a2,0(s4)
  8003a0:	46a1                	li	a3,8
  8003a2:	8a2e                	mv	s4,a1
  8003a4:	bf69                	j	80033e <vprintfmt+0x156>
            putch('0', putdat);
  8003a6:	03000513          	li	a0,48
  8003aa:	85a6                	mv	a1,s1
  8003ac:	e03e                	sd	a5,0(sp)
  8003ae:	9902                	jalr	s2
            putch('x', putdat);
  8003b0:	85a6                	mv	a1,s1
  8003b2:	07800513          	li	a0,120
  8003b6:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003b8:	0a21                	addi	s4,s4,8
            goto number;
  8003ba:	6782                	ld	a5,0(sp)
  8003bc:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003be:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  8003c2:	bfb5                	j	80033e <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003c4:	000a3403          	ld	s0,0(s4)
  8003c8:	008a0713          	addi	a4,s4,8
  8003cc:	e03a                	sd	a4,0(sp)
  8003ce:	14040263          	beqz	s0,800512 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  8003d2:	0fb05763          	blez	s11,8004c0 <vprintfmt+0x2d8>
  8003d6:	02d00693          	li	a3,45
  8003da:	0cd79163          	bne	a5,a3,80049c <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003de:	00044783          	lbu	a5,0(s0)
  8003e2:	0007851b          	sext.w	a0,a5
  8003e6:	cf85                	beqz	a5,80041e <vprintfmt+0x236>
  8003e8:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003ec:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003f0:	000c4563          	bltz	s8,8003fa <vprintfmt+0x212>
  8003f4:	3c7d                	addiw	s8,s8,-1
  8003f6:	036c0263          	beq	s8,s6,80041a <vprintfmt+0x232>
                    putch('?', putdat);
  8003fa:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003fc:	0e0c8e63          	beqz	s9,8004f8 <vprintfmt+0x310>
  800400:	3781                	addiw	a5,a5,-32
  800402:	0ef47b63          	bgeu	s0,a5,8004f8 <vprintfmt+0x310>
                    putch('?', putdat);
  800406:	03f00513          	li	a0,63
  80040a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80040c:	000a4783          	lbu	a5,0(s4)
  800410:	3dfd                	addiw	s11,s11,-1
  800412:	0a05                	addi	s4,s4,1
  800414:	0007851b          	sext.w	a0,a5
  800418:	ffe1                	bnez	a5,8003f0 <vprintfmt+0x208>
            for (; width > 0; width --) {
  80041a:	01b05963          	blez	s11,80042c <vprintfmt+0x244>
  80041e:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  800420:	85a6                	mv	a1,s1
  800422:	02000513          	li	a0,32
  800426:	9902                	jalr	s2
            for (; width > 0; width --) {
  800428:	fe0d9be3          	bnez	s11,80041e <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  80042c:	6a02                	ld	s4,0(sp)
  80042e:	bbd5                	j	800222 <vprintfmt+0x3a>
    if (lflag >= 2) {
  800430:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800432:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  800436:	01174463          	blt	a4,a7,80043e <vprintfmt+0x256>
    else if (lflag) {
  80043a:	08088d63          	beqz	a7,8004d4 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  80043e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800442:	0a044d63          	bltz	s0,8004fc <vprintfmt+0x314>
            num = getint(&ap, lflag);
  800446:	8622                	mv	a2,s0
  800448:	8a66                	mv	s4,s9
  80044a:	46a9                	li	a3,10
  80044c:	bdcd                	j	80033e <vprintfmt+0x156>
            err = va_arg(ap, int);
  80044e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800452:	4761                	li	a4,24
            err = va_arg(ap, int);
  800454:	0a21                	addi	s4,s4,8
            if (err < 0) {
  800456:	41f7d69b          	sraiw	a3,a5,0x1f
  80045a:	8fb5                	xor	a5,a5,a3
  80045c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800460:	02d74163          	blt	a4,a3,800482 <vprintfmt+0x29a>
  800464:	00369793          	slli	a5,a3,0x3
  800468:	97de                	add	a5,a5,s7
  80046a:	639c                	ld	a5,0(a5)
  80046c:	cb99                	beqz	a5,800482 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  80046e:	86be                	mv	a3,a5
  800470:	00000617          	auipc	a2,0x0
  800474:	21060613          	addi	a2,a2,528 # 800680 <main+0xe0>
  800478:	85a6                	mv	a1,s1
  80047a:	854a                	mv	a0,s2
  80047c:	0ce000ef          	jal	ra,80054a <printfmt>
  800480:	b34d                	j	800222 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800482:	00000617          	auipc	a2,0x0
  800486:	1ee60613          	addi	a2,a2,494 # 800670 <main+0xd0>
  80048a:	85a6                	mv	a1,s1
  80048c:	854a                	mv	a0,s2
  80048e:	0bc000ef          	jal	ra,80054a <printfmt>
  800492:	bb41                	j	800222 <vprintfmt+0x3a>
                p = "(null)";
  800494:	00000417          	auipc	s0,0x0
  800498:	1d440413          	addi	s0,s0,468 # 800668 <main+0xc8>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80049c:	85e2                	mv	a1,s8
  80049e:	8522                	mv	a0,s0
  8004a0:	e43e                	sd	a5,8(sp)
  8004a2:	cbfff0ef          	jal	ra,800160 <strnlen>
  8004a6:	40ad8dbb          	subw	s11,s11,a0
  8004aa:	01b05b63          	blez	s11,8004c0 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  8004ae:	67a2                	ld	a5,8(sp)
  8004b0:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004b4:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  8004b6:	85a6                	mv	a1,s1
  8004b8:	8552                	mv	a0,s4
  8004ba:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004bc:	fe0d9ce3          	bnez	s11,8004b4 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004c0:	00044783          	lbu	a5,0(s0)
  8004c4:	00140a13          	addi	s4,s0,1
  8004c8:	0007851b          	sext.w	a0,a5
  8004cc:	d3a5                	beqz	a5,80042c <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004ce:	05e00413          	li	s0,94
  8004d2:	bf39                	j	8003f0 <vprintfmt+0x208>
        return va_arg(*ap, int);
  8004d4:	000a2403          	lw	s0,0(s4)
  8004d8:	b7ad                	j	800442 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  8004da:	000a6603          	lwu	a2,0(s4)
  8004de:	46a1                	li	a3,8
  8004e0:	8a2e                	mv	s4,a1
  8004e2:	bdb1                	j	80033e <vprintfmt+0x156>
  8004e4:	000a6603          	lwu	a2,0(s4)
  8004e8:	46a9                	li	a3,10
  8004ea:	8a2e                	mv	s4,a1
  8004ec:	bd89                	j	80033e <vprintfmt+0x156>
  8004ee:	000a6603          	lwu	a2,0(s4)
  8004f2:	46c1                	li	a3,16
  8004f4:	8a2e                	mv	s4,a1
  8004f6:	b5a1                	j	80033e <vprintfmt+0x156>
                    putch(ch, putdat);
  8004f8:	9902                	jalr	s2
  8004fa:	bf09                	j	80040c <vprintfmt+0x224>
                putch('-', putdat);
  8004fc:	85a6                	mv	a1,s1
  8004fe:	02d00513          	li	a0,45
  800502:	e03e                	sd	a5,0(sp)
  800504:	9902                	jalr	s2
                num = -(long long)num;
  800506:	6782                	ld	a5,0(sp)
  800508:	8a66                	mv	s4,s9
  80050a:	40800633          	neg	a2,s0
  80050e:	46a9                	li	a3,10
  800510:	b53d                	j	80033e <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  800512:	03b05163          	blez	s11,800534 <vprintfmt+0x34c>
  800516:	02d00693          	li	a3,45
  80051a:	f6d79de3          	bne	a5,a3,800494 <vprintfmt+0x2ac>
                p = "(null)";
  80051e:	00000417          	auipc	s0,0x0
  800522:	14a40413          	addi	s0,s0,330 # 800668 <main+0xc8>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800526:	02800793          	li	a5,40
  80052a:	02800513          	li	a0,40
  80052e:	00140a13          	addi	s4,s0,1
  800532:	bd6d                	j	8003ec <vprintfmt+0x204>
  800534:	00000a17          	auipc	s4,0x0
  800538:	135a0a13          	addi	s4,s4,309 # 800669 <main+0xc9>
  80053c:	02800513          	li	a0,40
  800540:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  800544:	05e00413          	li	s0,94
  800548:	b565                	j	8003f0 <vprintfmt+0x208>

000000000080054a <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80054a:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  80054c:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800550:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800552:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800554:	ec06                	sd	ra,24(sp)
  800556:	f83a                	sd	a4,48(sp)
  800558:	fc3e                	sd	a5,56(sp)
  80055a:	e0c2                	sd	a6,64(sp)
  80055c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  80055e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800560:	c89ff0ef          	jal	ra,8001e8 <vprintfmt>
}
  800564:	60e2                	ld	ra,24(sp)
  800566:	6161                	addi	sp,sp,80
  800568:	8082                	ret

000000000080056a <sleepy>:
#include <stdio.h>
#include <ulib.h>

void
sleepy(int pid) {
  80056a:	1101                	addi	sp,sp,-32
  80056c:	e822                	sd	s0,16(sp)
  80056e:	e426                	sd	s1,8(sp)
  800570:	e04a                	sd	s2,0(sp)
  800572:	ec06                	sd	ra,24(sp)
    int i, time = 100;
    for (i = 0; i < 10; i ++) {
  800574:	4401                	li	s0,0
        sleep(time);
        cprintf("sleep %d x %d slices.\n", i + 1, time);
  800576:	00000917          	auipc	s2,0x0
  80057a:	3f290913          	addi	s2,s2,1010 # 800968 <error_string+0xc8>
    for (i = 0; i < 10; i ++) {
  80057e:	44a9                	li	s1,10
        sleep(time);
  800580:	06400513          	li	a0,100
  800584:	b55ff0ef          	jal	ra,8000d8 <sleep>
        cprintf("sleep %d x %d slices.\n", i + 1, time);
  800588:	2405                	addiw	s0,s0,1
  80058a:	06400613          	li	a2,100
  80058e:	85a2                	mv	a1,s0
  800590:	854a                	mv	a0,s2
  800592:	b8dff0ef          	jal	ra,80011e <cprintf>
    for (i = 0; i < 10; i ++) {
  800596:	fe9415e3          	bne	s0,s1,800580 <sleepy+0x16>
    }
    exit(0);
  80059a:	4501                	li	a0,0
  80059c:	b21ff0ef          	jal	ra,8000bc <exit>

00000000008005a0 <main>:
}

int
main(void) {
  8005a0:	1101                	addi	sp,sp,-32
  8005a2:	e822                	sd	s0,16(sp)
  8005a4:	ec06                	sd	ra,24(sp)
    unsigned int time = gettime_msec();
  8005a6:	b31ff0ef          	jal	ra,8000d6 <gettime_msec>
  8005aa:	0005041b          	sext.w	s0,a0
    int pid1, exit_code;

    if ((pid1 = fork()) == 0) {
  8005ae:	b25ff0ef          	jal	ra,8000d2 <fork>
  8005b2:	cd21                	beqz	a0,80060a <main+0x6a>
        sleepy(pid1);
    }
    
    assert(waitpid(pid1, &exit_code) == 0 && exit_code == 0);
  8005b4:	006c                	addi	a1,sp,12
  8005b6:	b1fff0ef          	jal	ra,8000d4 <waitpid>
  8005ba:	47b2                	lw	a5,12(sp)
  8005bc:	8fc9                	or	a5,a5,a0
  8005be:	2781                	sext.w	a5,a5
  8005c0:	e795                	bnez	a5,8005ec <main+0x4c>
    cprintf("use %04d msecs.\n", gettime_msec() - time);
  8005c2:	b15ff0ef          	jal	ra,8000d6 <gettime_msec>
  8005c6:	408505bb          	subw	a1,a0,s0
  8005ca:	00000517          	auipc	a0,0x0
  8005ce:	41650513          	addi	a0,a0,1046 # 8009e0 <error_string+0x140>
  8005d2:	b4dff0ef          	jal	ra,80011e <cprintf>
    cprintf("sleep pass.\n");
  8005d6:	00000517          	auipc	a0,0x0
  8005da:	42250513          	addi	a0,a0,1058 # 8009f8 <error_string+0x158>
  8005de:	b41ff0ef          	jal	ra,80011e <cprintf>
    return 0;
}
  8005e2:	60e2                	ld	ra,24(sp)
  8005e4:	6442                	ld	s0,16(sp)
  8005e6:	4501                	li	a0,0
  8005e8:	6105                	addi	sp,sp,32
  8005ea:	8082                	ret
    assert(waitpid(pid1, &exit_code) == 0 && exit_code == 0);
  8005ec:	00000697          	auipc	a3,0x0
  8005f0:	39468693          	addi	a3,a3,916 # 800980 <error_string+0xe0>
  8005f4:	00000617          	auipc	a2,0x0
  8005f8:	3c460613          	addi	a2,a2,964 # 8009b8 <error_string+0x118>
  8005fc:	45dd                	li	a1,23
  8005fe:	00000517          	auipc	a0,0x0
  800602:	3d250513          	addi	a0,a0,978 # 8009d0 <error_string+0x130>
  800606:	a1bff0ef          	jal	ra,800020 <__panic>
        sleepy(pid1);
  80060a:	f61ff0ef          	jal	ra,80056a <sleepy>
