
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
#include "kernel/fcntl.h"

#define MAX 280

int primes(int in, int prime) 
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
	int num;
	int out_fd[2];
    // Tạo pipe đầu ra
	pipe(out_fd);
  10:	fd040513          	addi	a0,s0,-48
  14:	372000ef          	jal	386 <pipe>

	if (!fork()) {
  18:	356000ef          	jal	36e <fork>
  1c:	c105                	beqz	a0,3c <primes+0x3c>
		close(out_fd[1]);
		
		exit(0);
	}

	close(in);
  1e:	8526                	mv	a0,s1
  20:	37e000ef          	jal	39e <close>
	close(out_fd[1]);
  24:	fd442503          	lw	a0,-44(s0)
  28:	376000ef          	jal	39e <close>

	return out_fd[0];
}
  2c:	fd042503          	lw	a0,-48(s0)
  30:	70a2                	ld	ra,40(sp)
  32:	7402                	ld	s0,32(sp)
  34:	64e2                	ld	s1,24(sp)
  36:	6942                	ld	s2,16(sp)
  38:	6145                	addi	sp,sp,48
  3a:	8082                	ret
		while (read(in, &num, sizeof(int))) {
  3c:	4611                	li	a2,4
  3e:	fdc40593          	addi	a1,s0,-36
  42:	8526                	mv	a0,s1
  44:	34a000ef          	jal	38e <read>
  48:	cd11                	beqz	a0,64 <primes+0x64>
			if (num % prime) {
  4a:	fdc42783          	lw	a5,-36(s0)
  4e:	0327e7bb          	remw	a5,a5,s2
  52:	d7ed                	beqz	a5,3c <primes+0x3c>
				write(out_fd[1], &num, sizeof(int));
  54:	4611                	li	a2,4
  56:	fdc40593          	addi	a1,s0,-36
  5a:	fd442503          	lw	a0,-44(s0)
  5e:	338000ef          	jal	396 <write>
  62:	bfe9                	j	3c <primes+0x3c>
		close(in);
  64:	8526                	mv	a0,s1
  66:	338000ef          	jal	39e <close>
		close(out_fd[1]);
  6a:	fd442503          	lw	a0,-44(s0)
  6e:	330000ef          	jal	39e <close>
		exit(0);
  72:	4501                	li	a0,0
  74:	302000ef          	jal	376 <exit>

0000000000000078 <main>:

int main(int argc, char *argv[]){
  78:	7179                	addi	sp,sp,-48
  7a:	f406                	sd	ra,40(sp)
  7c:	f022                	sd	s0,32(sp)
  7e:	1800                	addi	s0,sp,48
    int fd[2];
    pipe(fd);
  80:	fd840513          	addi	a0,s0,-40
  84:	302000ef          	jal	386 <pipe>

    // Tạo tiến trình con để ghi các số từ 2 tới MAX vào fd
    if (!fork()){
  88:	2e6000ef          	jal	36e <fork>
  8c:	ed1d                	bnez	a0,ca <main+0x52>
  8e:	ec26                	sd	s1,24(sp)
  90:	e84a                	sd	s2,16(sp)
        for (int i = 2; i < MAX; i++){
  92:	4789                	li	a5,2
  94:	fcf42823          	sw	a5,-48(s0)
  98:	11700493          	li	s1,279
            write(fd[1], &i, sizeof(int));
  9c:	4611                	li	a2,4
  9e:	fd040593          	addi	a1,s0,-48
  a2:	fdc42503          	lw	a0,-36(s0)
  a6:	2f0000ef          	jal	396 <write>
        for (int i = 2; i < MAX; i++){
  aa:	fd042783          	lw	a5,-48(s0)
  ae:	2785                	addiw	a5,a5,1
  b0:	0007871b          	sext.w	a4,a5
  b4:	fcf42823          	sw	a5,-48(s0)
  b8:	fee4d2e3          	bge	s1,a4,9c <main+0x24>
        }
        // Đóng pipe và trở lại tiến trình cha
        close(fd[1]);
  bc:	fdc42503          	lw	a0,-36(s0)
  c0:	2de000ef          	jal	39e <close>
        exit(0);
  c4:	4501                	li	a0,0
  c6:	2b0000ef          	jal	376 <exit>
  ca:	ec26                	sd	s1,24(sp)
  cc:	e84a                	sd	s2,16(sp)
    }

    close(fd[1]);
  ce:	fdc42503          	lw	a0,-36(s0)
  d2:	2cc000ef          	jal	39e <close>

    int in = fd[0];
  d6:	fd842483          	lw	s1,-40(s0)
    int prime;
    // Đọc các số từ pipe fd (thông qua biến in)
    while (read(in, &prime, sizeof(int))){
        // In ra màn hình
        printf("prime %d\n", prime);
  da:	00001917          	auipc	s2,0x1
  de:	86690913          	addi	s2,s2,-1946 # 940 <malloc+0xfe>
    while (read(in, &prime, sizeof(int))){
  e2:	a821                	j	fa <main+0x82>
        printf("prime %d\n", prime);
  e4:	fd442583          	lw	a1,-44(s0)
  e8:	854a                	mv	a0,s2
  ea:	6a4000ef          	jal	78e <printf>
        // Lọc các số chia hết cho prime ở trong pipe fd (biến in), trả về số nguyên tố tiếp theo
        in = primes(in, prime);
  ee:	fd442583          	lw	a1,-44(s0)
  f2:	8526                	mv	a0,s1
  f4:	f0dff0ef          	jal	0 <primes>
  f8:	84aa                	mv	s1,a0
    while (read(in, &prime, sizeof(int))){
  fa:	4611                	li	a2,4
  fc:	fd440593          	addi	a1,s0,-44
 100:	8526                	mv	a0,s1
 102:	28c000ef          	jal	38e <read>
 106:	fd79                	bnez	a0,e4 <main+0x6c>
    }
    exit(0);   
 108:	26e000ef          	jal	376 <exit>

000000000000010c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	f65ff0ef          	jal	78 <main>
  exit(0);
 118:	4501                	li	a0,0
 11a:	25c000ef          	jal	376 <exit>

000000000000011e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	86be                	mv	a3,a5
 178:	0785                	addi	a5,a5,1
 17a:	fff7c703          	lbu	a4,-1(a5)
 17e:	ff65                	bnez	a4,176 <strlen+0x10>
 180:	40a6853b          	subw	a0,a3,a0
 184:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
  }
  return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
    if(*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
  for(; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d663          	bge	s1,s4,228 <gets+0x52>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	186000ef          	jal	38e <read>
    if(cc < 1)
 20c:	00a05e63          	blez	a0,228 <gets+0x52>
    buf[i++] = c;
 210:	faf44783          	lbu	a5,-81(s0)
 214:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 218:	01578763          	beq	a5,s5,226 <gets+0x50>
 21c:	0905                	addi	s2,s2,1
 21e:	fd679de3          	bne	a5,s6,1f8 <gets+0x22>
    buf[i++] = c;
 222:	89a6                	mv	s3,s1
 224:	a011                	j	228 <gets+0x52>
 226:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 228:	99de                	add	s3,s3,s7
 22a:	00098023          	sb	zero,0(s3)
  return buf;
}
 22e:	855e                	mv	a0,s7
 230:	60e6                	ld	ra,88(sp)
 232:	6446                	ld	s0,80(sp)
 234:	64a6                	ld	s1,72(sp)
 236:	6906                	ld	s2,64(sp)
 238:	79e2                	ld	s3,56(sp)
 23a:	7a42                	ld	s4,48(sp)
 23c:	7aa2                	ld	s5,40(sp)
 23e:	7b02                	ld	s6,32(sp)
 240:	6be2                	ld	s7,24(sp)
 242:	6125                	addi	sp,sp,96
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	162000ef          	jal	3b6 <open>
  if(fd < 0)
 258:	02054263          	bltz	a0,27c <stat+0x36>
 25c:	e426                	sd	s1,8(sp)
 25e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 260:	85ca                	mv	a1,s2
 262:	16c000ef          	jal	3ce <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	134000ef          	jal	39e <close>
  return r;
 26e:	64a2                	ld	s1,8(sp)
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	6902                	ld	s2,0(sp)
 278:	6105                	addi	sp,sp,32
 27a:	8082                	ret
    return -1;
 27c:	597d                	li	s2,-1
 27e:	bfcd                	j	270 <stat+0x2a>

0000000000000280 <atoi>:

int
atoi(const char *s)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 286:	00054683          	lbu	a3,0(a0)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	4625                	li	a2,9
 294:	02f66863          	bltu	a2,a5,2c4 <atoi+0x44>
 298:	872a                	mv	a4,a0
  n = 0;
 29a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 29c:	0705                	addi	a4,a4,1
 29e:	0025179b          	slliw	a5,a0,0x2
 2a2:	9fa9                	addw	a5,a5,a0
 2a4:	0017979b          	slliw	a5,a5,0x1
 2a8:	9fb5                	addw	a5,a5,a3
 2aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ae:	00074683          	lbu	a3,0(a4)
 2b2:	fd06879b          	addiw	a5,a3,-48
 2b6:	0ff7f793          	zext.b	a5,a5
 2ba:	fef671e3          	bgeu	a2,a5,29c <atoi+0x1c>
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  n = 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <atoi+0x3e>

00000000000002c8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ce:	02b57463          	bgeu	a0,a1,2f6 <memmove+0x2e>
    while(n-- > 0)
 2d2:	00c05f63          	blez	a2,2f0 <memmove+0x28>
 2d6:	1602                	slli	a2,a2,0x20
 2d8:	9201                	srli	a2,a2,0x20
 2da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2de:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e0:	0585                	addi	a1,a1,1
 2e2:	0705                	addi	a4,a4,1
 2e4:	fff5c683          	lbu	a3,-1(a1)
 2e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ec:	fef71ae3          	bne	a4,a5,2e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fc:	fec05ae3          	blez	a2,2f0 <memmove+0x28>
 300:	fff6079b          	addiw	a5,a2,-1
 304:	1782                	slli	a5,a5,0x20
 306:	9381                	srli	a5,a5,0x20
 308:	fff7c793          	not	a5,a5
 30c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30e:	15fd                	addi	a1,a1,-1
 310:	177d                	addi	a4,a4,-1
 312:	0005c683          	lbu	a3,0(a1)
 316:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x46>
 31e:	bfc9                	j	2f0 <memmove+0x28>

0000000000000320 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	ca05                	beqz	a2,356 <memcmp+0x36>
 328:	fff6069b          	addiw	a3,a2,-1
 32c:	1682                	slli	a3,a3,0x20
 32e:	9281                	srli	a3,a3,0x20
 330:	0685                	addi	a3,a3,1
 332:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 334:	00054783          	lbu	a5,0(a0)
 338:	0005c703          	lbu	a4,0(a1)
 33c:	00e79863          	bne	a5,a4,34c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 340:	0505                	addi	a0,a0,1
    p2++;
 342:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 344:	fed518e3          	bne	a0,a3,334 <memcmp+0x14>
  }
  return 0;
 348:	4501                	li	a0,0
 34a:	a019                	j	350 <memcmp+0x30>
      return *p1 - *p2;
 34c:	40e7853b          	subw	a0,a5,a4
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  return 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <memcmp+0x30>

000000000000035a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 362:	f67ff0ef          	jal	2c8 <memmove>
}
 366:	60a2                	ld	ra,8(sp)
 368:	6402                	ld	s0,0(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret

000000000000036e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36e:	4885                	li	a7,1
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <exit>:
.global exit
exit:
 li a7, SYS_exit
 376:	4889                	li	a7,2
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <wait>:
.global wait
wait:
 li a7, SYS_wait
 37e:	488d                	li	a7,3
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 386:	4891                	li	a7,4
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <read>:
.global read
read:
 li a7, SYS_read
 38e:	4895                	li	a7,5
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <write>:
.global write
write:
 li a7, SYS_write
 396:	48c1                	li	a7,16
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <close>:
.global close
close:
 li a7, SYS_close
 39e:	48d5                	li	a7,21
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a6:	4899                	li	a7,6
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ae:	489d                	li	a7,7
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <open>:
.global open
open:
 li a7, SYS_open
 3b6:	48bd                	li	a7,15
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3be:	48c5                	li	a7,17
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c6:	48c9                	li	a7,18
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ce:	48a1                	li	a7,8
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <link>:
.global link
link:
 li a7, SYS_link
 3d6:	48cd                	li	a7,19
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3de:	48d1                	li	a7,20
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e6:	48a5                	li	a7,9
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ee:	48a9                	li	a7,10
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f6:	48ad                	li	a7,11
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3fe:	48b1                	li	a7,12
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 406:	48b5                	li	a7,13
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40e:	48b9                	li	a7,14
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 416:	1101                	addi	sp,sp,-32
 418:	ec06                	sd	ra,24(sp)
 41a:	e822                	sd	s0,16(sp)
 41c:	1000                	addi	s0,sp,32
 41e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 422:	4605                	li	a2,1
 424:	fef40593          	addi	a1,s0,-17
 428:	f6fff0ef          	jal	396 <write>
}
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	6105                	addi	sp,sp,32
 432:	8082                	ret

0000000000000434 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	7139                	addi	sp,sp,-64
 436:	fc06                	sd	ra,56(sp)
 438:	f822                	sd	s0,48(sp)
 43a:	f426                	sd	s1,40(sp)
 43c:	0080                	addi	s0,sp,64
 43e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 440:	c299                	beqz	a3,446 <printint+0x12>
 442:	0805c963          	bltz	a1,4d4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 446:	2581                	sext.w	a1,a1
  neg = 0;
 448:	4881                	li	a7,0
 44a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 44e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 450:	2601                	sext.w	a2,a2
 452:	00000517          	auipc	a0,0x0
 456:	50650513          	addi	a0,a0,1286 # 958 <digits>
 45a:	883a                	mv	a6,a4
 45c:	2705                	addiw	a4,a4,1
 45e:	02c5f7bb          	remuw	a5,a1,a2
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	97aa                	add	a5,a5,a0
 468:	0007c783          	lbu	a5,0(a5)
 46c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 470:	0005879b          	sext.w	a5,a1
 474:	02c5d5bb          	divuw	a1,a1,a2
 478:	0685                	addi	a3,a3,1
 47a:	fec7f0e3          	bgeu	a5,a2,45a <printint+0x26>
  if(neg)
 47e:	00088c63          	beqz	a7,496 <printint+0x62>
    buf[i++] = '-';
 482:	fd070793          	addi	a5,a4,-48
 486:	00878733          	add	a4,a5,s0
 48a:	02d00793          	li	a5,45
 48e:	fef70823          	sb	a5,-16(a4)
 492:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 496:	02e05a63          	blez	a4,4ca <printint+0x96>
 49a:	f04a                	sd	s2,32(sp)
 49c:	ec4e                	sd	s3,24(sp)
 49e:	fc040793          	addi	a5,s0,-64
 4a2:	00e78933          	add	s2,a5,a4
 4a6:	fff78993          	addi	s3,a5,-1
 4aa:	99ba                	add	s3,s3,a4
 4ac:	377d                	addiw	a4,a4,-1
 4ae:	1702                	slli	a4,a4,0x20
 4b0:	9301                	srli	a4,a4,0x20
 4b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b6:	fff94583          	lbu	a1,-1(s2)
 4ba:	8526                	mv	a0,s1
 4bc:	f5bff0ef          	jal	416 <putc>
  while(--i >= 0)
 4c0:	197d                	addi	s2,s2,-1
 4c2:	ff391ae3          	bne	s2,s3,4b6 <printint+0x82>
 4c6:	7902                	ld	s2,32(sp)
 4c8:	69e2                	ld	s3,24(sp)
}
 4ca:	70e2                	ld	ra,56(sp)
 4cc:	7442                	ld	s0,48(sp)
 4ce:	74a2                	ld	s1,40(sp)
 4d0:	6121                	addi	sp,sp,64
 4d2:	8082                	ret
    x = -xx;
 4d4:	40b005bb          	negw	a1,a1
    neg = 1;
 4d8:	4885                	li	a7,1
    x = -xx;
 4da:	bf85                	j	44a <printint+0x16>

00000000000004dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4dc:	711d                	addi	sp,sp,-96
 4de:	ec86                	sd	ra,88(sp)
 4e0:	e8a2                	sd	s0,80(sp)
 4e2:	e0ca                	sd	s2,64(sp)
 4e4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e6:	0005c903          	lbu	s2,0(a1)
 4ea:	26090863          	beqz	s2,75a <vprintf+0x27e>
 4ee:	e4a6                	sd	s1,72(sp)
 4f0:	fc4e                	sd	s3,56(sp)
 4f2:	f852                	sd	s4,48(sp)
 4f4:	f456                	sd	s5,40(sp)
 4f6:	f05a                	sd	s6,32(sp)
 4f8:	ec5e                	sd	s7,24(sp)
 4fa:	e862                	sd	s8,16(sp)
 4fc:	e466                	sd	s9,8(sp)
 4fe:	8b2a                	mv	s6,a0
 500:	8a2e                	mv	s4,a1
 502:	8bb2                	mv	s7,a2
  state = 0;
 504:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 506:	4481                	li	s1,0
 508:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 50a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 50e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 512:	06c00c93          	li	s9,108
 516:	a005                	j	536 <vprintf+0x5a>
        putc(fd, c0);
 518:	85ca                	mv	a1,s2
 51a:	855a                	mv	a0,s6
 51c:	efbff0ef          	jal	416 <putc>
 520:	a019                	j	526 <vprintf+0x4a>
    } else if(state == '%'){
 522:	03598263          	beq	s3,s5,546 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 526:	2485                	addiw	s1,s1,1
 528:	8726                	mv	a4,s1
 52a:	009a07b3          	add	a5,s4,s1
 52e:	0007c903          	lbu	s2,0(a5)
 532:	20090c63          	beqz	s2,74a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 536:	0009079b          	sext.w	a5,s2
    if(state == 0){
 53a:	fe0994e3          	bnez	s3,522 <vprintf+0x46>
      if(c0 == '%'){
 53e:	fd579de3          	bne	a5,s5,518 <vprintf+0x3c>
        state = '%';
 542:	89be                	mv	s3,a5
 544:	b7cd                	j	526 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 546:	00ea06b3          	add	a3,s4,a4
 54a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 550:	c681                	beqz	a3,558 <vprintf+0x7c>
 552:	9752                	add	a4,a4,s4
 554:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 558:	03878f63          	beq	a5,s8,596 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	05978963          	beq	a5,s9,5ae <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 560:	07500713          	li	a4,117
 564:	0ee78363          	beq	a5,a4,64a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 568:	07800713          	li	a4,120
 56c:	12e78563          	beq	a5,a4,696 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 570:	07000713          	li	a4,112
 574:	14e78a63          	beq	a5,a4,6c8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 578:	07300713          	li	a4,115
 57c:	18e78a63          	beq	a5,a4,710 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 580:	02500713          	li	a4,37
 584:	04e79563          	bne	a5,a4,5ce <vprintf+0xf2>
        putc(fd, '%');
 588:	02500593          	li	a1,37
 58c:	855a                	mv	a0,s6
 58e:	e89ff0ef          	jal	416 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 592:	4981                	li	s3,0
 594:	bf49                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 596:	008b8913          	addi	s2,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e91ff0ef          	jal	434 <printint>
 5a8:	8bca                	mv	s7,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bfad                	j	526 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ae:	06400793          	li	a5,100
 5b2:	02f68963          	beq	a3,a5,5e4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b6:	06c00793          	li	a5,108
 5ba:	04f68263          	beq	a3,a5,5fe <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5be:	07500793          	li	a5,117
 5c2:	0af68063          	beq	a3,a5,662 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5c6:	07800793          	li	a5,120
 5ca:	0ef68263          	beq	a3,a5,6ae <vprintf+0x1d2>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	855a                	mv	a0,s6
 5d4:	e43ff0ef          	jal	416 <putc>
        putc(fd, c0);
 5d8:	85ca                	mv	a1,s2
 5da:	855a                	mv	a0,s6
 5dc:	e3bff0ef          	jal	416 <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b791                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e43ff0ef          	jal	434 <printint>
        i += 1;
 5f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
        i += 1;
 5fc:	b72d                	j	526 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fe:	06400793          	li	a5,100
 602:	02f60763          	beq	a2,a5,630 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 606:	07500793          	li	a5,117
 60a:	06f60963          	beq	a2,a5,67c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 60e:	07800793          	li	a5,120
 612:	faf61ee3          	bne	a2,a5,5ce <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8913          	addi	s2,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e11ff0ef          	jal	434 <printint>
        i += 2;
 628:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	bde5                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8913          	addi	s2,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	df7ff0ef          	jal	434 <printint>
        i += 2;
 642:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	bdf9                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000ba583          	lw	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	dddff0ef          	jal	434 <printint>
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	b5d9                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8913          	addi	s2,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000ba583          	lw	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	dc5ff0ef          	jal	434 <printint>
        i += 1;
 674:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 1;
 67a:	b575                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dabff0ef          	jal	434 <printint>
        i += 2;
 68e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	bd49                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	d91ff0ef          	jal	434 <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bdad                	j	526 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000ba583          	lw	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	d79ff0ef          	jal	434 <printint>
        i += 1;
 6c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	b585                	j	526 <vprintf+0x4a>
 6c8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ca:	008b8d13          	addi	s10,s7,8
 6ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d2:	03000593          	li	a1,48
 6d6:	855a                	mv	a0,s6
 6d8:	d3fff0ef          	jal	416 <putc>
  putc(fd, 'x');
 6dc:	07800593          	li	a1,120
 6e0:	855a                	mv	a0,s6
 6e2:	d35ff0ef          	jal	416 <putc>
 6e6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e8:	00000b97          	auipc	s7,0x0
 6ec:	270b8b93          	addi	s7,s7,624 # 958 <digits>
 6f0:	03c9d793          	srli	a5,s3,0x3c
 6f4:	97de                	add	a5,a5,s7
 6f6:	0007c583          	lbu	a1,0(a5)
 6fa:	855a                	mv	a0,s6
 6fc:	d1bff0ef          	jal	416 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 700:	0992                	slli	s3,s3,0x4
 702:	397d                	addiw	s2,s2,-1
 704:	fe0916e3          	bnez	s2,6f0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 708:	8bea                	mv	s7,s10
      state = 0;
 70a:	4981                	li	s3,0
 70c:	6d02                	ld	s10,0(sp)
 70e:	bd21                	j	526 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 710:	008b8993          	addi	s3,s7,8
 714:	000bb903          	ld	s2,0(s7)
 718:	00090f63          	beqz	s2,736 <vprintf+0x25a>
        for(; *s; s++)
 71c:	00094583          	lbu	a1,0(s2)
 720:	c195                	beqz	a1,744 <vprintf+0x268>
          putc(fd, *s);
 722:	855a                	mv	a0,s6
 724:	cf3ff0ef          	jal	416 <putc>
        for(; *s; s++)
 728:	0905                	addi	s2,s2,1
 72a:	00094583          	lbu	a1,0(s2)
 72e:	f9f5                	bnez	a1,722 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 730:	8bce                	mv	s7,s3
      state = 0;
 732:	4981                	li	s3,0
 734:	bbcd                	j	526 <vprintf+0x4a>
          s = "(null)";
 736:	00000917          	auipc	s2,0x0
 73a:	21a90913          	addi	s2,s2,538 # 950 <malloc+0x10e>
        for(; *s; s++)
 73e:	02800593          	li	a1,40
 742:	b7c5                	j	722 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	bbf9                	j	526 <vprintf+0x4a>
 74a:	64a6                	ld	s1,72(sp)
 74c:	79e2                	ld	s3,56(sp)
 74e:	7a42                	ld	s4,48(sp)
 750:	7aa2                	ld	s5,40(sp)
 752:	7b02                	ld	s6,32(sp)
 754:	6be2                	ld	s7,24(sp)
 756:	6c42                	ld	s8,16(sp)
 758:	6ca2                	ld	s9,8(sp)
    }
  }
}
 75a:	60e6                	ld	ra,88(sp)
 75c:	6446                	ld	s0,80(sp)
 75e:	6906                	ld	s2,64(sp)
 760:	6125                	addi	sp,sp,96
 762:	8082                	ret

0000000000000764 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 764:	715d                	addi	sp,sp,-80
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e010                	sd	a2,0(s0)
 76e:	e414                	sd	a3,8(s0)
 770:	e818                	sd	a4,16(s0)
 772:	ec1c                	sd	a5,24(s0)
 774:	03043023          	sd	a6,32(s0)
 778:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	8622                	mv	a2,s0
 782:	d5bff0ef          	jal	4dc <vprintf>
}
 786:	60e2                	ld	ra,24(sp)
 788:	6442                	ld	s0,16(sp)
 78a:	6161                	addi	sp,sp,80
 78c:	8082                	ret

000000000000078e <printf>:

void
printf(const char *fmt, ...)
{
 78e:	711d                	addi	sp,sp,-96
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e40c                	sd	a1,8(s0)
 798:	e810                	sd	a2,16(s0)
 79a:	ec14                	sd	a3,24(s0)
 79c:	f018                	sd	a4,32(s0)
 79e:	f41c                	sd	a5,40(s0)
 7a0:	03043823          	sd	a6,48(s0)
 7a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a8:	00840613          	addi	a2,s0,8
 7ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b0:	85aa                	mv	a1,a0
 7b2:	4505                	li	a0,1
 7b4:	d29ff0ef          	jal	4dc <vprintf>
}
 7b8:	60e2                	ld	ra,24(sp)
 7ba:	6442                	ld	s0,16(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	1141                	addi	sp,sp,-16
 7c2:	e422                	sd	s0,8(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00001797          	auipc	a5,0x1
 7ce:	8367b783          	ld	a5,-1994(a5) # 1000 <freep>
 7d2:	a02d                	j	7fc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d4:	4618                	lw	a4,8(a2)
 7d6:	9f2d                	addw	a4,a4,a1
 7d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	6310                	ld	a2,0(a4)
 7e0:	a83d                	j	81e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e2:	ff852703          	lw	a4,-8(a0)
 7e6:	9f31                	addw	a4,a4,a2
 7e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ea:	ff053683          	ld	a3,-16(a0)
 7ee:	a091                	j	832 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e7e463          	bltu	a5,a4,7fa <free+0x3a>
 7f6:	00e6ea63          	bltu	a3,a4,80a <free+0x4a>
{
 7fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	fed7fae3          	bgeu	a5,a3,7f0 <free+0x30>
 800:	6398                	ld	a4,0(a5)
 802:	00e6e463          	bltu	a3,a4,80a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	fee7eae3          	bltu	a5,a4,7fa <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 80a:	ff852583          	lw	a1,-8(a0)
 80e:	6390                	ld	a2,0(a5)
 810:	02059813          	slli	a6,a1,0x20
 814:	01c85713          	srli	a4,a6,0x1c
 818:	9736                	add	a4,a4,a3
 81a:	fae60de3          	beq	a2,a4,7d4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 81e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 822:	4790                	lw	a2,8(a5)
 824:	02061593          	slli	a1,a2,0x20
 828:	01c5d713          	srli	a4,a1,0x1c
 82c:	973e                	add	a4,a4,a5
 82e:	fae68ae3          	beq	a3,a4,7e2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 832:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
}
 83c:	6422                	ld	s0,8(sp)
 83e:	0141                	addi	sp,sp,16
 840:	8082                	ret

0000000000000842 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 842:	7139                	addi	sp,sp,-64
 844:	fc06                	sd	ra,56(sp)
 846:	f822                	sd	s0,48(sp)
 848:	f426                	sd	s1,40(sp)
 84a:	ec4e                	sd	s3,24(sp)
 84c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	02051493          	slli	s1,a0,0x20
 852:	9081                	srli	s1,s1,0x20
 854:	04bd                	addi	s1,s1,15
 856:	8091                	srli	s1,s1,0x4
 858:	0014899b          	addiw	s3,s1,1
 85c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 85e:	00000517          	auipc	a0,0x0
 862:	7a253503          	ld	a0,1954(a0) # 1000 <freep>
 866:	c915                	beqz	a0,89a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86a:	4798                	lw	a4,8(a5)
 86c:	08977a63          	bgeu	a4,s1,900 <malloc+0xbe>
 870:	f04a                	sd	s2,32(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 878:	8a4e                	mv	s4,s3
 87a:	0009871b          	sext.w	a4,s3
 87e:	6685                	lui	a3,0x1
 880:	00d77363          	bgeu	a4,a3,886 <malloc+0x44>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88e:	00000917          	auipc	s2,0x0
 892:	77290913          	addi	s2,s2,1906 # 1000 <freep>
  if(p == (char*)-1)
 896:	5afd                	li	s5,-1
 898:	a081                	j	8d8 <malloc+0x96>
 89a:	f04a                	sd	s2,32(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e78793          	addi	a5,a5,1902 # 1010 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b8:	b7c1                	j	878 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a8a9                	j	918 <malloc+0xd6>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	efbff0ef          	jal	7c0 <free>
  return freep;
 8ca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ce:	c12d                	beqz	a0,930 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d2:	4798                	lw	a4,8(a5)
 8d4:	02977263          	bgeu	a4,s1,8f8 <malloc+0xb6>
    if(p == freep)
 8d8:	00093703          	ld	a4,0(s2)
 8dc:	853e                	mv	a0,a5
 8de:	fef719e3          	bne	a4,a5,8d0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8e2:	8552                	mv	a0,s4
 8e4:	b1bff0ef          	jal	3fe <sbrk>
  if(p == (char*)-1)
 8e8:	fd551ce3          	bne	a0,s5,8c0 <malloc+0x7e>
        return 0;
 8ec:	4501                	li	a0,0
 8ee:	7902                	ld	s2,32(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
 8f6:	a03d                	j	924 <malloc+0xe2>
 8f8:	7902                	ld	s2,32(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 900:	fae48de3          	beq	s1,a4,8ba <malloc+0x78>
        p->s.size -= nunits;
 904:	4137073b          	subw	a4,a4,s3
 908:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90a:	02071693          	slli	a3,a4,0x20
 90e:	01c6d713          	srli	a4,a3,0x1c
 912:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 914:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 918:	00000717          	auipc	a4,0x0
 91c:	6ea73423          	sd	a0,1768(a4) # 1000 <freep>
      return (void*)(p + 1);
 920:	01078513          	addi	a0,a5,16
  }
}
 924:	70e2                	ld	ra,56(sp)
 926:	7442                	ld	s0,48(sp)
 928:	74a2                	ld	s1,40(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6121                	addi	sp,sp,64
 92e:	8082                	ret
 930:	7902                	ld	s2,32(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	b7f5                	j	924 <malloc+0xe2>
