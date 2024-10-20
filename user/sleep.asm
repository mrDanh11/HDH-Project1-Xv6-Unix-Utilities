
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2){
   8:	4789                	li	a5,2
   a:	00f50563          	beq	a0,a5,14 <main+0x14>
        exit(1);
   e:	4505                	li	a0,1
  10:	296000ef          	jal	2a6 <exit>
    }

    int ticks = atoi(argv[1]);
  14:	6588                	ld	a0,8(a1)
  16:	19a000ef          	jal	1b0 <atoi>
    if (ticks <=0){
  1a:	00a05763          	blez	a0,28 <main+0x28>
        fprintf(2, "Invalid argument: Please specify a positive number of ticks.\n");
        exit(1);
    }

    sleep(ticks);
  1e:	318000ef          	jal	336 <sleep>

    exit(0);
  22:	4501                	li	a0,0
  24:	282000ef          	jal	2a6 <exit>
        fprintf(2, "Invalid argument: Please specify a positive number of ticks.\n");
  28:	00001597          	auipc	a1,0x1
  2c:	84858593          	addi	a1,a1,-1976 # 870 <malloc+0xfe>
  30:	4509                	li	a0,2
  32:	662000ef          	jal	694 <fprintf>
        exit(1);
  36:	4505                	li	a0,1
  38:	26e000ef          	jal	2a6 <exit>

000000000000003c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
  extern int main();
  main();
  44:	fbdff0ef          	jal	0 <main>
  exit(0);
  48:	4501                	li	a0,0
  4a:	25c000ef          	jal	2a6 <exit>

000000000000004e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e422                	sd	s0,8(sp)
  52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  54:	87aa                	mv	a5,a0
  56:	0585                	addi	a1,a1,1
  58:	0785                	addi	a5,a5,1
  5a:	fff5c703          	lbu	a4,-1(a1)
  5e:	fee78fa3          	sb	a4,-1(a5)
  62:	fb75                	bnez	a4,56 <strcpy+0x8>
    ;
  return os;
}
  64:	6422                	ld	s0,8(sp)
  66:	0141                	addi	sp,sp,16
  68:	8082                	ret

000000000000006a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e422                	sd	s0,8(sp)
  6e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	cb91                	beqz	a5,88 <strcmp+0x1e>
  76:	0005c703          	lbu	a4,0(a1)
  7a:	00f71763          	bne	a4,a5,88 <strcmp+0x1e>
    p++, q++;
  7e:	0505                	addi	a0,a0,1
  80:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	fbe5                	bnez	a5,76 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  88:	0005c503          	lbu	a0,0(a1)
}
  8c:	40a7853b          	subw	a0,a5,a0
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strlen>:

uint
strlen(const char *s)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cf91                	beqz	a5,bc <strlen+0x26>
  a2:	0505                	addi	a0,a0,1
  a4:	87aa                	mv	a5,a0
  a6:	86be                	mv	a3,a5
  a8:	0785                	addi	a5,a5,1
  aa:	fff7c703          	lbu	a4,-1(a5)
  ae:	ff65                	bnez	a4,a6 <strlen+0x10>
  b0:	40a6853b          	subw	a0,a3,a0
  b4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret
  for(n = 0; s[n]; n++)
  bc:	4501                	li	a0,0
  be:	bfe5                	j	b6 <strlen+0x20>

00000000000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c6:	ca19                	beqz	a2,dc <memset+0x1c>
  c8:	87aa                	mv	a5,a0
  ca:	1602                	slli	a2,a2,0x20
  cc:	9201                	srli	a2,a2,0x20
  ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d6:	0785                	addi	a5,a5,1
  d8:	fee79de3          	bne	a5,a4,d2 <memset+0x12>
  }
  return dst;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strchr>:

char*
strchr(const char *s, char c)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cb99                	beqz	a5,102 <strchr+0x20>
    if(*s == c)
  ee:	00f58763          	beq	a1,a5,fc <strchr+0x1a>
  for(; *s; s++)
  f2:	0505                	addi	a0,a0,1
  f4:	00054783          	lbu	a5,0(a0)
  f8:	fbfd                	bnez	a5,ee <strchr+0xc>
      return (char*)s;
  return 0;
  fa:	4501                	li	a0,0
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  return 0;
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strchr+0x1a>

0000000000000106 <gets>:

char*
gets(char *buf, int max)
{
 106:	711d                	addi	sp,sp,-96
 108:	ec86                	sd	ra,88(sp)
 10a:	e8a2                	sd	s0,80(sp)
 10c:	e4a6                	sd	s1,72(sp)
 10e:	e0ca                	sd	s2,64(sp)
 110:	fc4e                	sd	s3,56(sp)
 112:	f852                	sd	s4,48(sp)
 114:	f456                	sd	s5,40(sp)
 116:	f05a                	sd	s6,32(sp)
 118:	ec5e                	sd	s7,24(sp)
 11a:	1080                	addi	s0,sp,96
 11c:	8baa                	mv	s7,a0
 11e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 120:	892a                	mv	s2,a0
 122:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 124:	4aa9                	li	s5,10
 126:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 128:	89a6                	mv	s3,s1
 12a:	2485                	addiw	s1,s1,1
 12c:	0344d663          	bge	s1,s4,158 <gets+0x52>
    cc = read(0, &c, 1);
 130:	4605                	li	a2,1
 132:	faf40593          	addi	a1,s0,-81
 136:	4501                	li	a0,0
 138:	186000ef          	jal	2be <read>
    if(cc < 1)
 13c:	00a05e63          	blez	a0,158 <gets+0x52>
    buf[i++] = c;
 140:	faf44783          	lbu	a5,-81(s0)
 144:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 148:	01578763          	beq	a5,s5,156 <gets+0x50>
 14c:	0905                	addi	s2,s2,1
 14e:	fd679de3          	bne	a5,s6,128 <gets+0x22>
    buf[i++] = c;
 152:	89a6                	mv	s3,s1
 154:	a011                	j	158 <gets+0x52>
 156:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 158:	99de                	add	s3,s3,s7
 15a:	00098023          	sb	zero,0(s3)
  return buf;
}
 15e:	855e                	mv	a0,s7
 160:	60e6                	ld	ra,88(sp)
 162:	6446                	ld	s0,80(sp)
 164:	64a6                	ld	s1,72(sp)
 166:	6906                	ld	s2,64(sp)
 168:	79e2                	ld	s3,56(sp)
 16a:	7a42                	ld	s4,48(sp)
 16c:	7aa2                	ld	s5,40(sp)
 16e:	7b02                	ld	s6,32(sp)
 170:	6be2                	ld	s7,24(sp)
 172:	6125                	addi	sp,sp,96
 174:	8082                	ret

0000000000000176 <stat>:

int
stat(const char *n, struct stat *st)
{
 176:	1101                	addi	sp,sp,-32
 178:	ec06                	sd	ra,24(sp)
 17a:	e822                	sd	s0,16(sp)
 17c:	e04a                	sd	s2,0(sp)
 17e:	1000                	addi	s0,sp,32
 180:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 182:	4581                	li	a1,0
 184:	162000ef          	jal	2e6 <open>
  if(fd < 0)
 188:	02054263          	bltz	a0,1ac <stat+0x36>
 18c:	e426                	sd	s1,8(sp)
 18e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 190:	85ca                	mv	a1,s2
 192:	16c000ef          	jal	2fe <fstat>
 196:	892a                	mv	s2,a0
  close(fd);
 198:	8526                	mv	a0,s1
 19a:	134000ef          	jal	2ce <close>
  return r;
 19e:	64a2                	ld	s1,8(sp)
}
 1a0:	854a                	mv	a0,s2
 1a2:	60e2                	ld	ra,24(sp)
 1a4:	6442                	ld	s0,16(sp)
 1a6:	6902                	ld	s2,0(sp)
 1a8:	6105                	addi	sp,sp,32
 1aa:	8082                	ret
    return -1;
 1ac:	597d                	li	s2,-1
 1ae:	bfcd                	j	1a0 <stat+0x2a>

00000000000001b0 <atoi>:

int
atoi(const char *s)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b6:	00054683          	lbu	a3,0(a0)
 1ba:	fd06879b          	addiw	a5,a3,-48
 1be:	0ff7f793          	zext.b	a5,a5
 1c2:	4625                	li	a2,9
 1c4:	02f66863          	bltu	a2,a5,1f4 <atoi+0x44>
 1c8:	872a                	mv	a4,a0
  n = 0;
 1ca:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1cc:	0705                	addi	a4,a4,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb5                	addw	a5,a5,a3
 1da:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1de:	00074683          	lbu	a3,0(a4)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	fef671e3          	bgeu	a2,a5,1cc <atoi+0x1c>
  return n;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <atoi+0x3e>

00000000000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57463          	bgeu	a0,a1,226 <memmove+0x2e>
    while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x28>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20e:	872a                	mv	a4,a0
      *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0705                	addi	a4,a4,1
 214:	fff5c683          	lbu	a3,-1(a1)
 218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21c:	fef71ae3          	bne	a4,a5,210 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
    dst += n;
 226:	00c50733          	add	a4,a0,a2
    src += n;
 22a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 22c:	fec05ae3          	blez	a2,220 <memmove+0x28>
 230:	fff6079b          	addiw	a5,a2,-1
 234:	1782                	slli	a5,a5,0x20
 236:	9381                	srli	a5,a5,0x20
 238:	fff7c793          	not	a5,a5
 23c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 23e:	15fd                	addi	a1,a1,-1
 240:	177d                	addi	a4,a4,-1
 242:	0005c683          	lbu	a3,0(a1)
 246:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24a:	fee79ae3          	bne	a5,a4,23e <memmove+0x46>
 24e:	bfc9                	j	220 <memmove+0x28>

0000000000000250 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 256:	ca05                	beqz	a2,286 <memcmp+0x36>
 258:	fff6069b          	addiw	a3,a2,-1
 25c:	1682                	slli	a3,a3,0x20
 25e:	9281                	srli	a3,a3,0x20
 260:	0685                	addi	a3,a3,1
 262:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 264:	00054783          	lbu	a5,0(a0)
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00e79863          	bne	a5,a4,27c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 270:	0505                	addi	a0,a0,1
    p2++;
 272:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 274:	fed518e3          	bne	a0,a3,264 <memcmp+0x14>
  }
  return 0;
 278:	4501                	li	a0,0
 27a:	a019                	j	280 <memcmp+0x30>
      return *p1 - *p2;
 27c:	40e7853b          	subw	a0,a5,a4
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
  return 0;
 286:	4501                	li	a0,0
 288:	bfe5                	j	280 <memcmp+0x30>

000000000000028a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 292:	f67ff0ef          	jal	1f8 <memmove>
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret

000000000000029e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 29e:	4885                	li	a7,1
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a6:	4889                	li	a7,2
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ae:	488d                	li	a7,3
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b6:	4891                	li	a7,4
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <read>:
.global read
read:
 li a7, SYS_read
 2be:	4895                	li	a7,5
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <write>:
.global write
write:
 li a7, SYS_write
 2c6:	48c1                	li	a7,16
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <close>:
.global close
close:
 li a7, SYS_close
 2ce:	48d5                	li	a7,21
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d6:	4899                	li	a7,6
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <exec>:
.global exec
exec:
 li a7, SYS_exec
 2de:	489d                	li	a7,7
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <open>:
.global open
open:
 li a7, SYS_open
 2e6:	48bd                	li	a7,15
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ee:	48c5                	li	a7,17
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f6:	48c9                	li	a7,18
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2fe:	48a1                	li	a7,8
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <link>:
.global link
link:
 li a7, SYS_link
 306:	48cd                	li	a7,19
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 30e:	48d1                	li	a7,20
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 316:	48a5                	li	a7,9
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <dup>:
.global dup
dup:
 li a7, SYS_dup
 31e:	48a9                	li	a7,10
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 326:	48ad                	li	a7,11
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 32e:	48b1                	li	a7,12
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 336:	48b5                	li	a7,13
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 33e:	48b9                	li	a7,14
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 346:	1101                	addi	sp,sp,-32
 348:	ec06                	sd	ra,24(sp)
 34a:	e822                	sd	s0,16(sp)
 34c:	1000                	addi	s0,sp,32
 34e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 352:	4605                	li	a2,1
 354:	fef40593          	addi	a1,s0,-17
 358:	f6fff0ef          	jal	2c6 <write>
}
 35c:	60e2                	ld	ra,24(sp)
 35e:	6442                	ld	s0,16(sp)
 360:	6105                	addi	sp,sp,32
 362:	8082                	ret

0000000000000364 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 364:	7139                	addi	sp,sp,-64
 366:	fc06                	sd	ra,56(sp)
 368:	f822                	sd	s0,48(sp)
 36a:	f426                	sd	s1,40(sp)
 36c:	0080                	addi	s0,sp,64
 36e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 370:	c299                	beqz	a3,376 <printint+0x12>
 372:	0805c963          	bltz	a1,404 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 376:	2581                	sext.w	a1,a1
  neg = 0;
 378:	4881                	li	a7,0
 37a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 380:	2601                	sext.w	a2,a2
 382:	00000517          	auipc	a0,0x0
 386:	53650513          	addi	a0,a0,1334 # 8b8 <digits>
 38a:	883a                	mv	a6,a4
 38c:	2705                	addiw	a4,a4,1
 38e:	02c5f7bb          	remuw	a5,a1,a2
 392:	1782                	slli	a5,a5,0x20
 394:	9381                	srli	a5,a5,0x20
 396:	97aa                	add	a5,a5,a0
 398:	0007c783          	lbu	a5,0(a5)
 39c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a0:	0005879b          	sext.w	a5,a1
 3a4:	02c5d5bb          	divuw	a1,a1,a2
 3a8:	0685                	addi	a3,a3,1
 3aa:	fec7f0e3          	bgeu	a5,a2,38a <printint+0x26>
  if(neg)
 3ae:	00088c63          	beqz	a7,3c6 <printint+0x62>
    buf[i++] = '-';
 3b2:	fd070793          	addi	a5,a4,-48
 3b6:	00878733          	add	a4,a5,s0
 3ba:	02d00793          	li	a5,45
 3be:	fef70823          	sb	a5,-16(a4)
 3c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c6:	02e05a63          	blez	a4,3fa <printint+0x96>
 3ca:	f04a                	sd	s2,32(sp)
 3cc:	ec4e                	sd	s3,24(sp)
 3ce:	fc040793          	addi	a5,s0,-64
 3d2:	00e78933          	add	s2,a5,a4
 3d6:	fff78993          	addi	s3,a5,-1
 3da:	99ba                	add	s3,s3,a4
 3dc:	377d                	addiw	a4,a4,-1
 3de:	1702                	slli	a4,a4,0x20
 3e0:	9301                	srli	a4,a4,0x20
 3e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e6:	fff94583          	lbu	a1,-1(s2)
 3ea:	8526                	mv	a0,s1
 3ec:	f5bff0ef          	jal	346 <putc>
  while(--i >= 0)
 3f0:	197d                	addi	s2,s2,-1
 3f2:	ff391ae3          	bne	s2,s3,3e6 <printint+0x82>
 3f6:	7902                	ld	s2,32(sp)
 3f8:	69e2                	ld	s3,24(sp)
}
 3fa:	70e2                	ld	ra,56(sp)
 3fc:	7442                	ld	s0,48(sp)
 3fe:	74a2                	ld	s1,40(sp)
 400:	6121                	addi	sp,sp,64
 402:	8082                	ret
    x = -xx;
 404:	40b005bb          	negw	a1,a1
    neg = 1;
 408:	4885                	li	a7,1
    x = -xx;
 40a:	bf85                	j	37a <printint+0x16>

000000000000040c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 40c:	711d                	addi	sp,sp,-96
 40e:	ec86                	sd	ra,88(sp)
 410:	e8a2                	sd	s0,80(sp)
 412:	e0ca                	sd	s2,64(sp)
 414:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 416:	0005c903          	lbu	s2,0(a1)
 41a:	26090863          	beqz	s2,68a <vprintf+0x27e>
 41e:	e4a6                	sd	s1,72(sp)
 420:	fc4e                	sd	s3,56(sp)
 422:	f852                	sd	s4,48(sp)
 424:	f456                	sd	s5,40(sp)
 426:	f05a                	sd	s6,32(sp)
 428:	ec5e                	sd	s7,24(sp)
 42a:	e862                	sd	s8,16(sp)
 42c:	e466                	sd	s9,8(sp)
 42e:	8b2a                	mv	s6,a0
 430:	8a2e                	mv	s4,a1
 432:	8bb2                	mv	s7,a2
  state = 0;
 434:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 436:	4481                	li	s1,0
 438:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 43a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 43e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 442:	06c00c93          	li	s9,108
 446:	a005                	j	466 <vprintf+0x5a>
        putc(fd, c0);
 448:	85ca                	mv	a1,s2
 44a:	855a                	mv	a0,s6
 44c:	efbff0ef          	jal	346 <putc>
 450:	a019                	j	456 <vprintf+0x4a>
    } else if(state == '%'){
 452:	03598263          	beq	s3,s5,476 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 456:	2485                	addiw	s1,s1,1
 458:	8726                	mv	a4,s1
 45a:	009a07b3          	add	a5,s4,s1
 45e:	0007c903          	lbu	s2,0(a5)
 462:	20090c63          	beqz	s2,67a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 466:	0009079b          	sext.w	a5,s2
    if(state == 0){
 46a:	fe0994e3          	bnez	s3,452 <vprintf+0x46>
      if(c0 == '%'){
 46e:	fd579de3          	bne	a5,s5,448 <vprintf+0x3c>
        state = '%';
 472:	89be                	mv	s3,a5
 474:	b7cd                	j	456 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 476:	00ea06b3          	add	a3,s4,a4
 47a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 47e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 480:	c681                	beqz	a3,488 <vprintf+0x7c>
 482:	9752                	add	a4,a4,s4
 484:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 488:	03878f63          	beq	a5,s8,4c6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 48c:	05978963          	beq	a5,s9,4de <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 490:	07500713          	li	a4,117
 494:	0ee78363          	beq	a5,a4,57a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 498:	07800713          	li	a4,120
 49c:	12e78563          	beq	a5,a4,5c6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4a0:	07000713          	li	a4,112
 4a4:	14e78a63          	beq	a5,a4,5f8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4a8:	07300713          	li	a4,115
 4ac:	18e78a63          	beq	a5,a4,640 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4b0:	02500713          	li	a4,37
 4b4:	04e79563          	bne	a5,a4,4fe <vprintf+0xf2>
        putc(fd, '%');
 4b8:	02500593          	li	a1,37
 4bc:	855a                	mv	a0,s6
 4be:	e89ff0ef          	jal	346 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4c2:	4981                	li	s3,0
 4c4:	bf49                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4c6:	008b8913          	addi	s2,s7,8
 4ca:	4685                	li	a3,1
 4cc:	4629                	li	a2,10
 4ce:	000ba583          	lw	a1,0(s7)
 4d2:	855a                	mv	a0,s6
 4d4:	e91ff0ef          	jal	364 <printint>
 4d8:	8bca                	mv	s7,s2
      state = 0;
 4da:	4981                	li	s3,0
 4dc:	bfad                	j	456 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4de:	06400793          	li	a5,100
 4e2:	02f68963          	beq	a3,a5,514 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4e6:	06c00793          	li	a5,108
 4ea:	04f68263          	beq	a3,a5,52e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4ee:	07500793          	li	a5,117
 4f2:	0af68063          	beq	a3,a5,592 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4f6:	07800793          	li	a5,120
 4fa:	0ef68263          	beq	a3,a5,5de <vprintf+0x1d2>
        putc(fd, '%');
 4fe:	02500593          	li	a1,37
 502:	855a                	mv	a0,s6
 504:	e43ff0ef          	jal	346 <putc>
        putc(fd, c0);
 508:	85ca                	mv	a1,s2
 50a:	855a                	mv	a0,s6
 50c:	e3bff0ef          	jal	346 <putc>
      state = 0;
 510:	4981                	li	s3,0
 512:	b791                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 514:	008b8913          	addi	s2,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000ba583          	lw	a1,0(s7)
 520:	855a                	mv	a0,s6
 522:	e43ff0ef          	jal	364 <printint>
        i += 1;
 526:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 528:	8bca                	mv	s7,s2
      state = 0;
 52a:	4981                	li	s3,0
        i += 1;
 52c:	b72d                	j	456 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52e:	06400793          	li	a5,100
 532:	02f60763          	beq	a2,a5,560 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 536:	07500793          	li	a5,117
 53a:	06f60963          	beq	a2,a5,5ac <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 53e:	07800793          	li	a5,120
 542:	faf61ee3          	bne	a2,a5,4fe <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 546:	008b8913          	addi	s2,s7,8
 54a:	4681                	li	a3,0
 54c:	4641                	li	a2,16
 54e:	000ba583          	lw	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	e11ff0ef          	jal	364 <printint>
        i += 2;
 558:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
        i += 2;
 55e:	bde5                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 560:	008b8913          	addi	s2,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	df7ff0ef          	jal	364 <printint>
        i += 2;
 572:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 574:	8bca                	mv	s7,s2
      state = 0;
 576:	4981                	li	s3,0
        i += 2;
 578:	bdf9                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 57a:	008b8913          	addi	s2,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	dddff0ef          	jal	364 <printint>
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	b5d9                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	008b8913          	addi	s2,s7,8
 596:	4681                	li	a3,0
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	dc5ff0ef          	jal	364 <printint>
        i += 1;
 5a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 1;
 5aa:	b575                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	dabff0ef          	jal	364 <printint>
        i += 2;
 5be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
        i += 2;
 5c4:	bd49                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	d91ff0ef          	jal	364 <printint>
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bdad                	j	456 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4641                	li	a2,16
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	d79ff0ef          	jal	364 <printint>
        i += 1;
 5f0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 1;
 5f6:	b585                	j	456 <vprintf+0x4a>
 5f8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5fa:	008b8d13          	addi	s10,s7,8
 5fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 602:	03000593          	li	a1,48
 606:	855a                	mv	a0,s6
 608:	d3fff0ef          	jal	346 <putc>
  putc(fd, 'x');
 60c:	07800593          	li	a1,120
 610:	855a                	mv	a0,s6
 612:	d35ff0ef          	jal	346 <putc>
 616:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 618:	00000b97          	auipc	s7,0x0
 61c:	2a0b8b93          	addi	s7,s7,672 # 8b8 <digits>
 620:	03c9d793          	srli	a5,s3,0x3c
 624:	97de                	add	a5,a5,s7
 626:	0007c583          	lbu	a1,0(a5)
 62a:	855a                	mv	a0,s6
 62c:	d1bff0ef          	jal	346 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 630:	0992                	slli	s3,s3,0x4
 632:	397d                	addiw	s2,s2,-1
 634:	fe0916e3          	bnez	s2,620 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 638:	8bea                	mv	s7,s10
      state = 0;
 63a:	4981                	li	s3,0
 63c:	6d02                	ld	s10,0(sp)
 63e:	bd21                	j	456 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 640:	008b8993          	addi	s3,s7,8
 644:	000bb903          	ld	s2,0(s7)
 648:	00090f63          	beqz	s2,666 <vprintf+0x25a>
        for(; *s; s++)
 64c:	00094583          	lbu	a1,0(s2)
 650:	c195                	beqz	a1,674 <vprintf+0x268>
          putc(fd, *s);
 652:	855a                	mv	a0,s6
 654:	cf3ff0ef          	jal	346 <putc>
        for(; *s; s++)
 658:	0905                	addi	s2,s2,1
 65a:	00094583          	lbu	a1,0(s2)
 65e:	f9f5                	bnez	a1,652 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 660:	8bce                	mv	s7,s3
      state = 0;
 662:	4981                	li	s3,0
 664:	bbcd                	j	456 <vprintf+0x4a>
          s = "(null)";
 666:	00000917          	auipc	s2,0x0
 66a:	24a90913          	addi	s2,s2,586 # 8b0 <malloc+0x13e>
        for(; *s; s++)
 66e:	02800593          	li	a1,40
 672:	b7c5                	j	652 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	bbf9                	j	456 <vprintf+0x4a>
 67a:	64a6                	ld	s1,72(sp)
 67c:	79e2                	ld	s3,56(sp)
 67e:	7a42                	ld	s4,48(sp)
 680:	7aa2                	ld	s5,40(sp)
 682:	7b02                	ld	s6,32(sp)
 684:	6be2                	ld	s7,24(sp)
 686:	6c42                	ld	s8,16(sp)
 688:	6ca2                	ld	s9,8(sp)
    }
  }
}
 68a:	60e6                	ld	ra,88(sp)
 68c:	6446                	ld	s0,80(sp)
 68e:	6906                	ld	s2,64(sp)
 690:	6125                	addi	sp,sp,96
 692:	8082                	ret

0000000000000694 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 694:	715d                	addi	sp,sp,-80
 696:	ec06                	sd	ra,24(sp)
 698:	e822                	sd	s0,16(sp)
 69a:	1000                	addi	s0,sp,32
 69c:	e010                	sd	a2,0(s0)
 69e:	e414                	sd	a3,8(s0)
 6a0:	e818                	sd	a4,16(s0)
 6a2:	ec1c                	sd	a5,24(s0)
 6a4:	03043023          	sd	a6,32(s0)
 6a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b0:	8622                	mv	a2,s0
 6b2:	d5bff0ef          	jal	40c <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6161                	addi	sp,sp,80
 6bc:	8082                	ret

00000000000006be <printf>:

void
printf(const char *fmt, ...)
{
 6be:	711d                	addi	sp,sp,-96
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e40c                	sd	a1,8(s0)
 6c8:	e810                	sd	a2,16(s0)
 6ca:	ec14                	sd	a3,24(s0)
 6cc:	f018                	sd	a4,32(s0)
 6ce:	f41c                	sd	a5,40(s0)
 6d0:	03043823          	sd	a6,48(s0)
 6d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	00840613          	addi	a2,s0,8
 6dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e0:	85aa                	mv	a1,a0
 6e2:	4505                	li	a0,1
 6e4:	d29ff0ef          	jal	40c <vprintf>
}
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6442                	ld	s0,16(sp)
 6ec:	6125                	addi	sp,sp,96
 6ee:	8082                	ret

00000000000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	1141                	addi	sp,sp,-16
 6f2:	e422                	sd	s0,8(sp)
 6f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	00001797          	auipc	a5,0x1
 6fe:	9067b783          	ld	a5,-1786(a5) # 1000 <freep>
 702:	a02d                	j	72c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 704:	4618                	lw	a4,8(a2)
 706:	9f2d                	addw	a4,a4,a1
 708:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 70c:	6398                	ld	a4,0(a5)
 70e:	6310                	ld	a2,0(a4)
 710:	a83d                	j	74e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 712:	ff852703          	lw	a4,-8(a0)
 716:	9f31                	addw	a4,a4,a2
 718:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 71a:	ff053683          	ld	a3,-16(a0)
 71e:	a091                	j	762 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	6398                	ld	a4,0(a5)
 722:	00e7e463          	bltu	a5,a4,72a <free+0x3a>
 726:	00e6ea63          	bltu	a3,a4,73a <free+0x4a>
{
 72a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	fed7fae3          	bgeu	a5,a3,720 <free+0x30>
 730:	6398                	ld	a4,0(a5)
 732:	00e6e463          	bltu	a3,a4,73a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	fee7eae3          	bltu	a5,a4,72a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 73a:	ff852583          	lw	a1,-8(a0)
 73e:	6390                	ld	a2,0(a5)
 740:	02059813          	slli	a6,a1,0x20
 744:	01c85713          	srli	a4,a6,0x1c
 748:	9736                	add	a4,a4,a3
 74a:	fae60de3          	beq	a2,a4,704 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 74e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 752:	4790                	lw	a2,8(a5)
 754:	02061593          	slli	a1,a2,0x20
 758:	01c5d713          	srli	a4,a1,0x1c
 75c:	973e                	add	a4,a4,a5
 75e:	fae68ae3          	beq	a3,a4,712 <free+0x22>
    p->s.ptr = bp->s.ptr;
 762:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 764:	00001717          	auipc	a4,0x1
 768:	88f73e23          	sd	a5,-1892(a4) # 1000 <freep>
}
 76c:	6422                	ld	s0,8(sp)
 76e:	0141                	addi	sp,sp,16
 770:	8082                	ret

0000000000000772 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 772:	7139                	addi	sp,sp,-64
 774:	fc06                	sd	ra,56(sp)
 776:	f822                	sd	s0,48(sp)
 778:	f426                	sd	s1,40(sp)
 77a:	ec4e                	sd	s3,24(sp)
 77c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	02051493          	slli	s1,a0,0x20
 782:	9081                	srli	s1,s1,0x20
 784:	04bd                	addi	s1,s1,15
 786:	8091                	srli	s1,s1,0x4
 788:	0014899b          	addiw	s3,s1,1
 78c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 78e:	00001517          	auipc	a0,0x1
 792:	87253503          	ld	a0,-1934(a0) # 1000 <freep>
 796:	c915                	beqz	a0,7ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79a:	4798                	lw	a4,8(a5)
 79c:	08977a63          	bgeu	a4,s1,830 <malloc+0xbe>
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	e852                	sd	s4,16(sp)
 7a4:	e456                	sd	s5,8(sp)
 7a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7a8:	8a4e                	mv	s4,s3
 7aa:	0009871b          	sext.w	a4,s3
 7ae:	6685                	lui	a3,0x1
 7b0:	00d77363          	bgeu	a4,a3,7b6 <malloc+0x44>
 7b4:	6a05                	lui	s4,0x1
 7b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7be:	00001917          	auipc	s2,0x1
 7c2:	84290913          	addi	s2,s2,-1982 # 1000 <freep>
  if(p == (char*)-1)
 7c6:	5afd                	li	s5,-1
 7c8:	a081                	j	808 <malloc+0x96>
 7ca:	f04a                	sd	s2,32(sp)
 7cc:	e852                	sd	s4,16(sp)
 7ce:	e456                	sd	s5,8(sp)
 7d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d2:	00001797          	auipc	a5,0x1
 7d6:	83e78793          	addi	a5,a5,-1986 # 1010 <base>
 7da:	00001717          	auipc	a4,0x1
 7de:	82f73323          	sd	a5,-2010(a4) # 1000 <freep>
 7e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e8:	b7c1                	j	7a8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7ea:	6398                	ld	a4,0(a5)
 7ec:	e118                	sd	a4,0(a0)
 7ee:	a8a9                	j	848 <malloc+0xd6>
  hp->s.size = nu;
 7f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7f4:	0541                	addi	a0,a0,16
 7f6:	efbff0ef          	jal	6f0 <free>
  return freep;
 7fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7fe:	c12d                	beqz	a0,860 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 802:	4798                	lw	a4,8(a5)
 804:	02977263          	bgeu	a4,s1,828 <malloc+0xb6>
    if(p == freep)
 808:	00093703          	ld	a4,0(s2)
 80c:	853e                	mv	a0,a5
 80e:	fef719e3          	bne	a4,a5,800 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 812:	8552                	mv	a0,s4
 814:	b1bff0ef          	jal	32e <sbrk>
  if(p == (char*)-1)
 818:	fd551ce3          	bne	a0,s5,7f0 <malloc+0x7e>
        return 0;
 81c:	4501                	li	a0,0
 81e:	7902                	ld	s2,32(sp)
 820:	6a42                	ld	s4,16(sp)
 822:	6aa2                	ld	s5,8(sp)
 824:	6b02                	ld	s6,0(sp)
 826:	a03d                	j	854 <malloc+0xe2>
 828:	7902                	ld	s2,32(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 830:	fae48de3          	beq	s1,a4,7ea <malloc+0x78>
        p->s.size -= nunits;
 834:	4137073b          	subw	a4,a4,s3
 838:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83a:	02071693          	slli	a3,a4,0x20
 83e:	01c6d713          	srli	a4,a3,0x1c
 842:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 844:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 848:	00000717          	auipc	a4,0x0
 84c:	7aa73c23          	sd	a0,1976(a4) # 1000 <freep>
      return (void*)(p + 1);
 850:	01078513          	addi	a0,a5,16
  }
}
 854:	70e2                	ld	ra,56(sp)
 856:	7442                	ld	s0,48(sp)
 858:	74a2                	ld	s1,40(sp)
 85a:	69e2                	ld	s3,24(sp)
 85c:	6121                	addi	sp,sp,64
 85e:	8082                	ret
 860:	7902                	ld	s2,32(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
 868:	b7f5                	j	854 <malloc+0xe2>
