
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ping>:

// khởi tạo bộ nhớ đệm để write và read 1 byte
char buffer[1];

// write 1 byte
void ping(int p[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    char byte = 'a';
   8:	06100793          	li	a5,97
   c:	fef407a3          	sb	a5,-17(s0)
    int rs = write(p[1], &byte, 1);      // ghi 1 byte vào p[1] của pipe
  10:	4605                	li	a2,1
  12:	fef40593          	addi	a1,s0,-17
  16:	4148                	lw	a0,4(a0)
  18:	3d2000ef          	jal	3ea <write>

    if(rs == -1){
  1c:	57fd                	li	a5,-1
  1e:	00f50663          	beq	a0,a5,2a <ping+0x2a>
        fprintf(2, "write failed!!\n");
        exit(1);
    }

}
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	6105                	addi	sp,sp,32
  28:	8082                	ret
        fprintf(2, "write failed!!\n");
  2a:	00001597          	auipc	a1,0x1
  2e:	96658593          	addi	a1,a1,-1690 # 990 <malloc+0xfa>
  32:	4509                	li	a0,2
  34:	784000ef          	jal	7b8 <fprintf>
        exit(1);
  38:	4505                	li	a0,1
  3a:	390000ef          	jal	3ca <exit>

000000000000003e <pong>:

// read 1 byte 
void pong(int p[]){
  3e:	1141                	addi	sp,sp,-16
  40:	e406                	sd	ra,8(sp)
  42:	e022                	sd	s0,0(sp)
  44:	0800                	addi	s0,sp,16
    int rs = read(p[0], buffer, 1);      // đọc 1 byte từ p[0] của pipe ra buffer
  46:	4605                	li	a2,1
  48:	00001597          	auipc	a1,0x1
  4c:	fb858593          	addi	a1,a1,-72 # 1000 <buffer>
  50:	4108                	lw	a0,0(a0)
  52:	390000ef          	jal	3e2 <read>
    if(rs == -1){
  56:	57fd                	li	a5,-1
  58:	00f50f63          	beq	a0,a5,76 <pong+0x38>
        fprintf(2, "read failed!!\n");
        exit(1);
    }
    printf("%d: received ping\n", getpid());    // hàm getpid() để lấy process id của tiến trình đó
  5c:	3ee000ef          	jal	44a <getpid>
  60:	85aa                	mv	a1,a0
  62:	00001517          	auipc	a0,0x1
  66:	95650513          	addi	a0,a0,-1706 # 9b8 <malloc+0x122>
  6a:	778000ef          	jal	7e2 <printf>
}
  6e:	60a2                	ld	ra,8(sp)
  70:	6402                	ld	s0,0(sp)
  72:	0141                	addi	sp,sp,16
  74:	8082                	ret
        fprintf(2, "read failed!!\n");
  76:	00001597          	auipc	a1,0x1
  7a:	92a58593          	addi	a1,a1,-1750 # 9a0 <malloc+0x10a>
  7e:	4509                	li	a0,2
  80:	738000ef          	jal	7b8 <fprintf>
        exit(1);
  84:	4505                	li	a0,1
  86:	344000ef          	jal	3ca <exit>

000000000000008a <pingpong>:

void pingpong(int p[]){
  8a:	1101                	addi	sp,sp,-32
  8c:	ec06                	sd	ra,24(sp)
  8e:	e822                	sd	s0,16(sp)
  90:	e426                	sd	s1,8(sp)
  92:	1000                	addi	s0,sp,32
  94:	84aa                	mv	s1,a0
    int pid;

    // tạo pipe bằng hàm pipe();
    if(pipe(p) < 0){
  96:	344000ef          	jal	3da <pipe>
  9a:	02054b63          	bltz	a0,d0 <pingpong+0x46>
        fprintf(2, "pingpong: pipe failed!!\n");
        exit(1);
    }

    // tạo tiến trình con
    pid = fork();
  9e:	324000ef          	jal	3c2 <fork>

    if(pid < 0){
  a2:	04054163          	bltz	a0,e4 <pingpong+0x5a>
        fprintf(2, "pingpong: fork failed!!\n");
        exit(1);
    }       
    else if(pid == 0){      // tiến trình con
  a6:	e929                	bnez	a0,f8 <pingpong+0x6e>
        close(p[1]);    // đóng đầu ghi lại
  a8:	40c8                	lw	a0,4(s1)
  aa:	348000ef          	jal	3f2 <close>
        pong(p);        // nhận byte từ cha
  ae:	8526                	mv	a0,s1
  b0:	f8fff0ef          	jal	3e <pong>
        write(p[1], buffer, 1); // Gửi lại byte cho cha
  b4:	4605                	li	a2,1
  b6:	00001597          	auipc	a1,0x1
  ba:	f4a58593          	addi	a1,a1,-182 # 1000 <buffer>
  be:	40c8                	lw	a0,4(s1)
  c0:	32a000ef          	jal	3ea <write>
        close(p[0]);    // đóng đầu đọc
  c4:	4088                	lw	a0,0(s1)
  c6:	32c000ef          	jal	3f2 <close>
        exit(0);
  ca:	4501                	li	a0,0
  cc:	2fe000ef          	jal	3ca <exit>
        fprintf(2, "pingpong: pipe failed!!\n");
  d0:	00001597          	auipc	a1,0x1
  d4:	90058593          	addi	a1,a1,-1792 # 9d0 <malloc+0x13a>
  d8:	4509                	li	a0,2
  da:	6de000ef          	jal	7b8 <fprintf>
        exit(1);
  de:	4505                	li	a0,1
  e0:	2ea000ef          	jal	3ca <exit>
        fprintf(2, "pingpong: fork failed!!\n");
  e4:	00001597          	auipc	a1,0x1
  e8:	90c58593          	addi	a1,a1,-1780 # 9f0 <malloc+0x15a>
  ec:	4509                	li	a0,2
  ee:	6ca000ef          	jal	7b8 <fprintf>
        exit(1);
  f2:	4505                	li	a0,1
  f4:	2d6000ef          	jal	3ca <exit>
    }
    else{       // tiến trình cha
        close(p[0]);    // đóng đầu đọc
  f8:	4088                	lw	a0,0(s1)
  fa:	2f8000ef          	jal	3f2 <close>
        ping(p);       // gửi 1 byte cho con
  fe:	8526                	mv	a0,s1
 100:	f01ff0ef          	jal	0 <ping>
        wait(0);    // chờ tiến trình con kết thúc
 104:	4501                	li	a0,0
 106:	2cc000ef          	jal	3d2 <wait>
        read(p[0], buffer, 1);  // đọc byte từ tiến trình con
 10a:	4605                	li	a2,1
 10c:	00001597          	auipc	a1,0x1
 110:	ef458593          	addi	a1,a1,-268 # 1000 <buffer>
 114:	4088                	lw	a0,0(s1)
 116:	2cc000ef          	jal	3e2 <read>
        printf("%d: received pong\n", getpid());
 11a:	330000ef          	jal	44a <getpid>
 11e:	85aa                	mv	a1,a0
 120:	00001517          	auipc	a0,0x1
 124:	8f050513          	addi	a0,a0,-1808 # a10 <malloc+0x17a>
 128:	6ba000ef          	jal	7e2 <printf>
        close(p[1]);    // đóng đầu ghi
 12c:	40c8                	lw	a0,4(s1)
 12e:	2c4000ef          	jal	3f2 <close>
        exit(0);
 132:	4501                	li	a0,0
 134:	296000ef          	jal	3ca <exit>

0000000000000138 <main>:
    }

}

int main(int argc, char *argv[]) {
 138:	1101                	addi	sp,sp,-32
 13a:	ec06                	sd	ra,24(sp)
 13c:	e822                	sd	s0,16(sp)
 13e:	1000                	addi	s0,sp,32
    if(argc < 1){
 140:	00a05663          	blez	a0,14c <main+0x14>
        fprintf(2, "Usage: pingpong\n");
        exit(1);
    }

    int p[2]; // tạo mảng đề lưu pipe, p[0]: pipe để đọc, p[1]: pipe để ghi
    pingpong(p);
 144:	fe840513          	addi	a0,s0,-24
 148:	f43ff0ef          	jal	8a <pingpong>
        fprintf(2, "Usage: pingpong\n");
 14c:	00001597          	auipc	a1,0x1
 150:	8dc58593          	addi	a1,a1,-1828 # a28 <malloc+0x192>
 154:	4509                	li	a0,2
 156:	662000ef          	jal	7b8 <fprintf>
        exit(1);
 15a:	4505                	li	a0,1
 15c:	26e000ef          	jal	3ca <exit>

0000000000000160 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 160:	1141                	addi	sp,sp,-16
 162:	e406                	sd	ra,8(sp)
 164:	e022                	sd	s0,0(sp)
 166:	0800                	addi	s0,sp,16
  extern int main();
  main();
 168:	fd1ff0ef          	jal	138 <main>
  exit(0);
 16c:	4501                	li	a0,0
 16e:	25c000ef          	jal	3ca <exit>

0000000000000172 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 178:	87aa                	mv	a5,a0
 17a:	0585                	addi	a1,a1,1
 17c:	0785                	addi	a5,a5,1
 17e:	fff5c703          	lbu	a4,-1(a1)
 182:	fee78fa3          	sb	a4,-1(a5)
 186:	fb75                	bnez	a4,17a <strcpy+0x8>
    ;
  return os;
}
 188:	6422                	ld	s0,8(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb91                	beqz	a5,1ac <strcmp+0x1e>
 19a:	0005c703          	lbu	a4,0(a1)
 19e:	00f71763          	bne	a4,a5,1ac <strcmp+0x1e>
    p++, q++;
 1a2:	0505                	addi	a0,a0,1
 1a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbe5                	bnez	a5,19a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ac:	0005c503          	lbu	a0,0(a1)
}
 1b0:	40a7853b          	subw	a0,a5,a0
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strlen>:

uint
strlen(const char *s)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cf91                	beqz	a5,1e0 <strlen+0x26>
 1c6:	0505                	addi	a0,a0,1
 1c8:	87aa                	mv	a5,a0
 1ca:	86be                	mv	a3,a5
 1cc:	0785                	addi	a5,a5,1
 1ce:	fff7c703          	lbu	a4,-1(a5)
 1d2:	ff65                	bnez	a4,1ca <strlen+0x10>
 1d4:	40a6853b          	subw	a0,a3,a0
 1d8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  for(n = 0; s[n]; n++)
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <strlen+0x20>

00000000000001e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ea:	ca19                	beqz	a2,200 <memset+0x1c>
 1ec:	87aa                	mv	a5,a0
 1ee:	1602                	slli	a2,a2,0x20
 1f0:	9201                	srli	a2,a2,0x20
 1f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fa:	0785                	addi	a5,a5,1
 1fc:	fee79de3          	bne	a5,a4,1f6 <memset+0x12>
  }
  return dst;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strchr>:

char*
strchr(const char *s, char c)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 20c:	00054783          	lbu	a5,0(a0)
 210:	cb99                	beqz	a5,226 <strchr+0x20>
    if(*s == c)
 212:	00f58763          	beq	a1,a5,220 <strchr+0x1a>
  for(; *s; s++)
 216:	0505                	addi	a0,a0,1
 218:	00054783          	lbu	a5,0(a0)
 21c:	fbfd                	bnez	a5,212 <strchr+0xc>
      return (char*)s;
  return 0;
 21e:	4501                	li	a0,0
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  return 0;
 226:	4501                	li	a0,0
 228:	bfe5                	j	220 <strchr+0x1a>

000000000000022a <gets>:

char*
gets(char *buf, int max)
{
 22a:	711d                	addi	sp,sp,-96
 22c:	ec86                	sd	ra,88(sp)
 22e:	e8a2                	sd	s0,80(sp)
 230:	e4a6                	sd	s1,72(sp)
 232:	e0ca                	sd	s2,64(sp)
 234:	fc4e                	sd	s3,56(sp)
 236:	f852                	sd	s4,48(sp)
 238:	f456                	sd	s5,40(sp)
 23a:	f05a                	sd	s6,32(sp)
 23c:	ec5e                	sd	s7,24(sp)
 23e:	1080                	addi	s0,sp,96
 240:	8baa                	mv	s7,a0
 242:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 244:	892a                	mv	s2,a0
 246:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 248:	4aa9                	li	s5,10
 24a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24c:	89a6                	mv	s3,s1
 24e:	2485                	addiw	s1,s1,1
 250:	0344d663          	bge	s1,s4,27c <gets+0x52>
    cc = read(0, &c, 1);
 254:	4605                	li	a2,1
 256:	faf40593          	addi	a1,s0,-81
 25a:	4501                	li	a0,0
 25c:	186000ef          	jal	3e2 <read>
    if(cc < 1)
 260:	00a05e63          	blez	a0,27c <gets+0x52>
    buf[i++] = c;
 264:	faf44783          	lbu	a5,-81(s0)
 268:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26c:	01578763          	beq	a5,s5,27a <gets+0x50>
 270:	0905                	addi	s2,s2,1
 272:	fd679de3          	bne	a5,s6,24c <gets+0x22>
    buf[i++] = c;
 276:	89a6                	mv	s3,s1
 278:	a011                	j	27c <gets+0x52>
 27a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27c:	99de                	add	s3,s3,s7
 27e:	00098023          	sb	zero,0(s3)
  return buf;
}
 282:	855e                	mv	a0,s7
 284:	60e6                	ld	ra,88(sp)
 286:	6446                	ld	s0,80(sp)
 288:	64a6                	ld	s1,72(sp)
 28a:	6906                	ld	s2,64(sp)
 28c:	79e2                	ld	s3,56(sp)
 28e:	7a42                	ld	s4,48(sp)
 290:	7aa2                	ld	s5,40(sp)
 292:	7b02                	ld	s6,32(sp)
 294:	6be2                	ld	s7,24(sp)
 296:	6125                	addi	sp,sp,96
 298:	8082                	ret

000000000000029a <stat>:

int
stat(const char *n, struct stat *st)
{
 29a:	1101                	addi	sp,sp,-32
 29c:	ec06                	sd	ra,24(sp)
 29e:	e822                	sd	s0,16(sp)
 2a0:	e04a                	sd	s2,0(sp)
 2a2:	1000                	addi	s0,sp,32
 2a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	4581                	li	a1,0
 2a8:	162000ef          	jal	40a <open>
  if(fd < 0)
 2ac:	02054263          	bltz	a0,2d0 <stat+0x36>
 2b0:	e426                	sd	s1,8(sp)
 2b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b4:	85ca                	mv	a1,s2
 2b6:	16c000ef          	jal	422 <fstat>
 2ba:	892a                	mv	s2,a0
  close(fd);
 2bc:	8526                	mv	a0,s1
 2be:	134000ef          	jal	3f2 <close>
  return r;
 2c2:	64a2                	ld	s1,8(sp)
}
 2c4:	854a                	mv	a0,s2
 2c6:	60e2                	ld	ra,24(sp)
 2c8:	6442                	ld	s0,16(sp)
 2ca:	6902                	ld	s2,0(sp)
 2cc:	6105                	addi	sp,sp,32
 2ce:	8082                	ret
    return -1;
 2d0:	597d                	li	s2,-1
 2d2:	bfcd                	j	2c4 <stat+0x2a>

00000000000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e422                	sd	s0,8(sp)
 2d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2da:	00054683          	lbu	a3,0(a0)
 2de:	fd06879b          	addiw	a5,a3,-48
 2e2:	0ff7f793          	zext.b	a5,a5
 2e6:	4625                	li	a2,9
 2e8:	02f66863          	bltu	a2,a5,318 <atoi+0x44>
 2ec:	872a                	mv	a4,a0
  n = 0;
 2ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f0:	0705                	addi	a4,a4,1
 2f2:	0025179b          	slliw	a5,a0,0x2
 2f6:	9fa9                	addw	a5,a5,a0
 2f8:	0017979b          	slliw	a5,a5,0x1
 2fc:	9fb5                	addw	a5,a5,a3
 2fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 302:	00074683          	lbu	a3,0(a4)
 306:	fd06879b          	addiw	a5,a3,-48
 30a:	0ff7f793          	zext.b	a5,a5
 30e:	fef671e3          	bgeu	a2,a5,2f0 <atoi+0x1c>
  return n;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret
  n = 0;
 318:	4501                	li	a0,0
 31a:	bfe5                	j	312 <atoi+0x3e>

000000000000031c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 322:	02b57463          	bgeu	a0,a1,34a <memmove+0x2e>
    while(n-- > 0)
 326:	00c05f63          	blez	a2,344 <memmove+0x28>
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 332:	872a                	mv	a4,a0
      *dst++ = *src++;
 334:	0585                	addi	a1,a1,1
 336:	0705                	addi	a4,a4,1
 338:	fff5c683          	lbu	a3,-1(a1)
 33c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 340:	fef71ae3          	bne	a4,a5,334 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
    dst += n;
 34a:	00c50733          	add	a4,a0,a2
    src += n;
 34e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 350:	fec05ae3          	blez	a2,344 <memmove+0x28>
 354:	fff6079b          	addiw	a5,a2,-1
 358:	1782                	slli	a5,a5,0x20
 35a:	9381                	srli	a5,a5,0x20
 35c:	fff7c793          	not	a5,a5
 360:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 362:	15fd                	addi	a1,a1,-1
 364:	177d                	addi	a4,a4,-1
 366:	0005c683          	lbu	a3,0(a1)
 36a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36e:	fee79ae3          	bne	a5,a4,362 <memmove+0x46>
 372:	bfc9                	j	344 <memmove+0x28>

0000000000000374 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37a:	ca05                	beqz	a2,3aa <memcmp+0x36>
 37c:	fff6069b          	addiw	a3,a2,-1
 380:	1682                	slli	a3,a3,0x20
 382:	9281                	srli	a3,a3,0x20
 384:	0685                	addi	a3,a3,1
 386:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 388:	00054783          	lbu	a5,0(a0)
 38c:	0005c703          	lbu	a4,0(a1)
 390:	00e79863          	bne	a5,a4,3a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 394:	0505                	addi	a0,a0,1
    p2++;
 396:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 398:	fed518e3          	bne	a0,a3,388 <memcmp+0x14>
  }
  return 0;
 39c:	4501                	li	a0,0
 39e:	a019                	j	3a4 <memcmp+0x30>
      return *p1 - *p2;
 3a0:	40e7853b          	subw	a0,a5,a4
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <memcmp+0x30>

00000000000003ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e406                	sd	ra,8(sp)
 3b2:	e022                	sd	s0,0(sp)
 3b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b6:	f67ff0ef          	jal	31c <memmove>
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c2:	4885                	li	a7,1
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ca:	4889                	li	a7,2
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d2:	488d                	li	a7,3
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3da:	4891                	li	a7,4
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <read>:
.global read
read:
 li a7, SYS_read
 3e2:	4895                	li	a7,5
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <write>:
.global write
write:
 li a7, SYS_write
 3ea:	48c1                	li	a7,16
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <close>:
.global close
close:
 li a7, SYS_close
 3f2:	48d5                	li	a7,21
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fa:	4899                	li	a7,6
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exec>:
.global exec
exec:
 li a7, SYS_exec
 402:	489d                	li	a7,7
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <open>:
.global open
open:
 li a7, SYS_open
 40a:	48bd                	li	a7,15
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 412:	48c5                	li	a7,17
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41a:	48c9                	li	a7,18
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 422:	48a1                	li	a7,8
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <link>:
.global link
link:
 li a7, SYS_link
 42a:	48cd                	li	a7,19
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 432:	48d1                	li	a7,20
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43a:	48a5                	li	a7,9
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <dup>:
.global dup
dup:
 li a7, SYS_dup
 442:	48a9                	li	a7,10
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44a:	48ad                	li	a7,11
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 452:	48b1                	li	a7,12
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45a:	48b5                	li	a7,13
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 462:	48b9                	li	a7,14
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46a:	1101                	addi	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	1000                	addi	s0,sp,32
 472:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 476:	4605                	li	a2,1
 478:	fef40593          	addi	a1,s0,-17
 47c:	f6fff0ef          	jal	3ea <write>
}
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	6105                	addi	sp,sp,32
 486:	8082                	ret

0000000000000488 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 488:	7139                	addi	sp,sp,-64
 48a:	fc06                	sd	ra,56(sp)
 48c:	f822                	sd	s0,48(sp)
 48e:	f426                	sd	s1,40(sp)
 490:	0080                	addi	s0,sp,64
 492:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 494:	c299                	beqz	a3,49a <printint+0x12>
 496:	0805c963          	bltz	a1,528 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 49a:	2581                	sext.w	a1,a1
  neg = 0;
 49c:	4881                	li	a7,0
 49e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a4:	2601                	sext.w	a2,a2
 4a6:	00000517          	auipc	a0,0x0
 4aa:	5a250513          	addi	a0,a0,1442 # a48 <digits>
 4ae:	883a                	mv	a6,a4
 4b0:	2705                	addiw	a4,a4,1
 4b2:	02c5f7bb          	remuw	a5,a1,a2
 4b6:	1782                	slli	a5,a5,0x20
 4b8:	9381                	srli	a5,a5,0x20
 4ba:	97aa                	add	a5,a5,a0
 4bc:	0007c783          	lbu	a5,0(a5)
 4c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c4:	0005879b          	sext.w	a5,a1
 4c8:	02c5d5bb          	divuw	a1,a1,a2
 4cc:	0685                	addi	a3,a3,1
 4ce:	fec7f0e3          	bgeu	a5,a2,4ae <printint+0x26>
  if(neg)
 4d2:	00088c63          	beqz	a7,4ea <printint+0x62>
    buf[i++] = '-';
 4d6:	fd070793          	addi	a5,a4,-48
 4da:	00878733          	add	a4,a5,s0
 4de:	02d00793          	li	a5,45
 4e2:	fef70823          	sb	a5,-16(a4)
 4e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ea:	02e05a63          	blez	a4,51e <printint+0x96>
 4ee:	f04a                	sd	s2,32(sp)
 4f0:	ec4e                	sd	s3,24(sp)
 4f2:	fc040793          	addi	a5,s0,-64
 4f6:	00e78933          	add	s2,a5,a4
 4fa:	fff78993          	addi	s3,a5,-1
 4fe:	99ba                	add	s3,s3,a4
 500:	377d                	addiw	a4,a4,-1
 502:	1702                	slli	a4,a4,0x20
 504:	9301                	srli	a4,a4,0x20
 506:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50a:	fff94583          	lbu	a1,-1(s2)
 50e:	8526                	mv	a0,s1
 510:	f5bff0ef          	jal	46a <putc>
  while(--i >= 0)
 514:	197d                	addi	s2,s2,-1
 516:	ff391ae3          	bne	s2,s3,50a <printint+0x82>
 51a:	7902                	ld	s2,32(sp)
 51c:	69e2                	ld	s3,24(sp)
}
 51e:	70e2                	ld	ra,56(sp)
 520:	7442                	ld	s0,48(sp)
 522:	74a2                	ld	s1,40(sp)
 524:	6121                	addi	sp,sp,64
 526:	8082                	ret
    x = -xx;
 528:	40b005bb          	negw	a1,a1
    neg = 1;
 52c:	4885                	li	a7,1
    x = -xx;
 52e:	bf85                	j	49e <printint+0x16>

0000000000000530 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 530:	711d                	addi	sp,sp,-96
 532:	ec86                	sd	ra,88(sp)
 534:	e8a2                	sd	s0,80(sp)
 536:	e0ca                	sd	s2,64(sp)
 538:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53a:	0005c903          	lbu	s2,0(a1)
 53e:	26090863          	beqz	s2,7ae <vprintf+0x27e>
 542:	e4a6                	sd	s1,72(sp)
 544:	fc4e                	sd	s3,56(sp)
 546:	f852                	sd	s4,48(sp)
 548:	f456                	sd	s5,40(sp)
 54a:	f05a                	sd	s6,32(sp)
 54c:	ec5e                	sd	s7,24(sp)
 54e:	e862                	sd	s8,16(sp)
 550:	e466                	sd	s9,8(sp)
 552:	8b2a                	mv	s6,a0
 554:	8a2e                	mv	s4,a1
 556:	8bb2                	mv	s7,a2
  state = 0;
 558:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 55a:	4481                	li	s1,0
 55c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 55e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 562:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 566:	06c00c93          	li	s9,108
 56a:	a005                	j	58a <vprintf+0x5a>
        putc(fd, c0);
 56c:	85ca                	mv	a1,s2
 56e:	855a                	mv	a0,s6
 570:	efbff0ef          	jal	46a <putc>
 574:	a019                	j	57a <vprintf+0x4a>
    } else if(state == '%'){
 576:	03598263          	beq	s3,s5,59a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 57a:	2485                	addiw	s1,s1,1
 57c:	8726                	mv	a4,s1
 57e:	009a07b3          	add	a5,s4,s1
 582:	0007c903          	lbu	s2,0(a5)
 586:	20090c63          	beqz	s2,79e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 58a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 58e:	fe0994e3          	bnez	s3,576 <vprintf+0x46>
      if(c0 == '%'){
 592:	fd579de3          	bne	a5,s5,56c <vprintf+0x3c>
        state = '%';
 596:	89be                	mv	s3,a5
 598:	b7cd                	j	57a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 59a:	00ea06b3          	add	a3,s4,a4
 59e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5a2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5a4:	c681                	beqz	a3,5ac <vprintf+0x7c>
 5a6:	9752                	add	a4,a4,s4
 5a8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ac:	03878f63          	beq	a5,s8,5ea <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5b0:	05978963          	beq	a5,s9,602 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5b4:	07500713          	li	a4,117
 5b8:	0ee78363          	beq	a5,a4,69e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5bc:	07800713          	li	a4,120
 5c0:	12e78563          	beq	a5,a4,6ea <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5c4:	07000713          	li	a4,112
 5c8:	14e78a63          	beq	a5,a4,71c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5cc:	07300713          	li	a4,115
 5d0:	18e78a63          	beq	a5,a4,764 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5d4:	02500713          	li	a4,37
 5d8:	04e79563          	bne	a5,a4,622 <vprintf+0xf2>
        putc(fd, '%');
 5dc:	02500593          	li	a1,37
 5e0:	855a                	mv	a0,s6
 5e2:	e89ff0ef          	jal	46a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bf49                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4685                	li	a3,1
 5f0:	4629                	li	a2,10
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	e91ff0ef          	jal	488 <printint>
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bfad                	j	57a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 602:	06400793          	li	a5,100
 606:	02f68963          	beq	a3,a5,638 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60a:	06c00793          	li	a5,108
 60e:	04f68263          	beq	a3,a5,652 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 612:	07500793          	li	a5,117
 616:	0af68063          	beq	a3,a5,6b6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 61a:	07800793          	li	a5,120
 61e:	0ef68263          	beq	a3,a5,702 <vprintf+0x1d2>
        putc(fd, '%');
 622:	02500593          	li	a1,37
 626:	855a                	mv	a0,s6
 628:	e43ff0ef          	jal	46a <putc>
        putc(fd, c0);
 62c:	85ca                	mv	a1,s2
 62e:	855a                	mv	a0,s6
 630:	e3bff0ef          	jal	46a <putc>
      state = 0;
 634:	4981                	li	s3,0
 636:	b791                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 638:	008b8913          	addi	s2,s7,8
 63c:	4685                	li	a3,1
 63e:	4629                	li	a2,10
 640:	000ba583          	lw	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e43ff0ef          	jal	488 <printint>
        i += 1;
 64a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
        i += 1;
 650:	b72d                	j	57a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 652:	06400793          	li	a5,100
 656:	02f60763          	beq	a2,a5,684 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65a:	07500793          	li	a5,117
 65e:	06f60963          	beq	a2,a5,6d0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 662:	07800793          	li	a5,120
 666:	faf61ee3          	bne	a2,a5,622 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e11ff0ef          	jal	488 <printint>
        i += 2;
 67c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8bca                	mv	s7,s2
      state = 0;
 680:	4981                	li	s3,0
        i += 2;
 682:	bde5                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 684:	008b8913          	addi	s2,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	df7ff0ef          	jal	488 <printint>
        i += 2;
 696:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
        i += 2;
 69c:	bdf9                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4629                	li	a2,10
 6a6:	000ba583          	lw	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	dddff0ef          	jal	488 <printint>
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b5d9                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	dc5ff0ef          	jal	488 <printint>
        i += 1;
 6c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
        i += 1;
 6ce:	b575                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	008b8913          	addi	s2,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4629                	li	a2,10
 6d8:	000ba583          	lw	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	dabff0ef          	jal	488 <printint>
        i += 2;
 6e2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
        i += 2;
 6e8:	bd49                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d91ff0ef          	jal	488 <printint>
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bdad                	j	57a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 702:	008b8913          	addi	s2,s7,8
 706:	4681                	li	a3,0
 708:	4641                	li	a2,16
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d79ff0ef          	jal	488 <printint>
        i += 1;
 714:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
        i += 1;
 71a:	b585                	j	57a <vprintf+0x4a>
 71c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 71e:	008b8d13          	addi	s10,s7,8
 722:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 726:	03000593          	li	a1,48
 72a:	855a                	mv	a0,s6
 72c:	d3fff0ef          	jal	46a <putc>
  putc(fd, 'x');
 730:	07800593          	li	a1,120
 734:	855a                	mv	a0,s6
 736:	d35ff0ef          	jal	46a <putc>
 73a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73c:	00000b97          	auipc	s7,0x0
 740:	30cb8b93          	addi	s7,s7,780 # a48 <digits>
 744:	03c9d793          	srli	a5,s3,0x3c
 748:	97de                	add	a5,a5,s7
 74a:	0007c583          	lbu	a1,0(a5)
 74e:	855a                	mv	a0,s6
 750:	d1bff0ef          	jal	46a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 754:	0992                	slli	s3,s3,0x4
 756:	397d                	addiw	s2,s2,-1
 758:	fe0916e3          	bnez	s2,744 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 75c:	8bea                	mv	s7,s10
      state = 0;
 75e:	4981                	li	s3,0
 760:	6d02                	ld	s10,0(sp)
 762:	bd21                	j	57a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 764:	008b8993          	addi	s3,s7,8
 768:	000bb903          	ld	s2,0(s7)
 76c:	00090f63          	beqz	s2,78a <vprintf+0x25a>
        for(; *s; s++)
 770:	00094583          	lbu	a1,0(s2)
 774:	c195                	beqz	a1,798 <vprintf+0x268>
          putc(fd, *s);
 776:	855a                	mv	a0,s6
 778:	cf3ff0ef          	jal	46a <putc>
        for(; *s; s++)
 77c:	0905                	addi	s2,s2,1
 77e:	00094583          	lbu	a1,0(s2)
 782:	f9f5                	bnez	a1,776 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 784:	8bce                	mv	s7,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	bbcd                	j	57a <vprintf+0x4a>
          s = "(null)";
 78a:	00000917          	auipc	s2,0x0
 78e:	2b690913          	addi	s2,s2,694 # a40 <malloc+0x1aa>
        for(; *s; s++)
 792:	02800593          	li	a1,40
 796:	b7c5                	j	776 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	bbf9                	j	57a <vprintf+0x4a>
 79e:	64a6                	ld	s1,72(sp)
 7a0:	79e2                	ld	s3,56(sp)
 7a2:	7a42                	ld	s4,48(sp)
 7a4:	7aa2                	ld	s5,40(sp)
 7a6:	7b02                	ld	s6,32(sp)
 7a8:	6be2                	ld	s7,24(sp)
 7aa:	6c42                	ld	s8,16(sp)
 7ac:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7ae:	60e6                	ld	ra,88(sp)
 7b0:	6446                	ld	s0,80(sp)
 7b2:	6906                	ld	s2,64(sp)
 7b4:	6125                	addi	sp,sp,96
 7b6:	8082                	ret

00000000000007b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b8:	715d                	addi	sp,sp,-80
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e010                	sd	a2,0(s0)
 7c2:	e414                	sd	a3,8(s0)
 7c4:	e818                	sd	a4,16(s0)
 7c6:	ec1c                	sd	a5,24(s0)
 7c8:	03043023          	sd	a6,32(s0)
 7cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d4:	8622                	mv	a2,s0
 7d6:	d5bff0ef          	jal	530 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	addi	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	addi	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	addi	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	d29ff0ef          	jal	530 <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6125                	addi	sp,sp,96
 812:	8082                	ret

0000000000000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	1141                	addi	sp,sp,-16
 816:	e422                	sd	s0,8(sp)
 818:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	00000797          	auipc	a5,0x0
 822:	7ea7b783          	ld	a5,2026(a5) # 1008 <freep>
 826:	a02d                	j	850 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 828:	4618                	lw	a4,8(a2)
 82a:	9f2d                	addw	a4,a4,a1
 82c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	6398                	ld	a4,0(a5)
 832:	6310                	ld	a2,0(a4)
 834:	a83d                	j	872 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 836:	ff852703          	lw	a4,-8(a0)
 83a:	9f31                	addw	a4,a4,a2
 83c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83e:	ff053683          	ld	a3,-16(a0)
 842:	a091                	j	886 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 844:	6398                	ld	a4,0(a5)
 846:	00e7e463          	bltu	a5,a4,84e <free+0x3a>
 84a:	00e6ea63          	bltu	a3,a4,85e <free+0x4a>
{
 84e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 850:	fed7fae3          	bgeu	a5,a3,844 <free+0x30>
 854:	6398                	ld	a4,0(a5)
 856:	00e6e463          	bltu	a3,a4,85e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85a:	fee7eae3          	bltu	a5,a4,84e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 85e:	ff852583          	lw	a1,-8(a0)
 862:	6390                	ld	a2,0(a5)
 864:	02059813          	slli	a6,a1,0x20
 868:	01c85713          	srli	a4,a6,0x1c
 86c:	9736                	add	a4,a4,a3
 86e:	fae60de3          	beq	a2,a4,828 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 872:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 876:	4790                	lw	a2,8(a5)
 878:	02061593          	slli	a1,a2,0x20
 87c:	01c5d713          	srli	a4,a1,0x1c
 880:	973e                	add	a4,a4,a5
 882:	fae68ae3          	beq	a3,a4,836 <free+0x22>
    p->s.ptr = bp->s.ptr;
 886:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 888:	00000717          	auipc	a4,0x0
 88c:	78f73023          	sd	a5,1920(a4) # 1008 <freep>
}
 890:	6422                	ld	s0,8(sp)
 892:	0141                	addi	sp,sp,16
 894:	8082                	ret

0000000000000896 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 896:	7139                	addi	sp,sp,-64
 898:	fc06                	sd	ra,56(sp)
 89a:	f822                	sd	s0,48(sp)
 89c:	f426                	sd	s1,40(sp)
 89e:	ec4e                	sd	s3,24(sp)
 8a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	02051493          	slli	s1,a0,0x20
 8a6:	9081                	srli	s1,s1,0x20
 8a8:	04bd                	addi	s1,s1,15
 8aa:	8091                	srli	s1,s1,0x4
 8ac:	0014899b          	addiw	s3,s1,1
 8b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b2:	00000517          	auipc	a0,0x0
 8b6:	75653503          	ld	a0,1878(a0) # 1008 <freep>
 8ba:	c915                	beqz	a0,8ee <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8be:	4798                	lw	a4,8(a5)
 8c0:	08977a63          	bgeu	a4,s1,954 <malloc+0xbe>
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	e852                	sd	s4,16(sp)
 8c8:	e456                	sd	s5,8(sp)
 8ca:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8cc:	8a4e                	mv	s4,s3
 8ce:	0009871b          	sext.w	a4,s3
 8d2:	6685                	lui	a3,0x1
 8d4:	00d77363          	bgeu	a4,a3,8da <malloc+0x44>
 8d8:	6a05                	lui	s4,0x1
 8da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e2:	00000917          	auipc	s2,0x0
 8e6:	72690913          	addi	s2,s2,1830 # 1008 <freep>
  if(p == (char*)-1)
 8ea:	5afd                	li	s5,-1
 8ec:	a081                	j	92c <malloc+0x96>
 8ee:	f04a                	sd	s2,32(sp)
 8f0:	e852                	sd	s4,16(sp)
 8f2:	e456                	sd	s5,8(sp)
 8f4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f6:	00000797          	auipc	a5,0x0
 8fa:	71a78793          	addi	a5,a5,1818 # 1010 <base>
 8fe:	00000717          	auipc	a4,0x0
 902:	70f73523          	sd	a5,1802(a4) # 1008 <freep>
 906:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 908:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90c:	b7c1                	j	8cc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 90e:	6398                	ld	a4,0(a5)
 910:	e118                	sd	a4,0(a0)
 912:	a8a9                	j	96c <malloc+0xd6>
  hp->s.size = nu;
 914:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 918:	0541                	addi	a0,a0,16
 91a:	efbff0ef          	jal	814 <free>
  return freep;
 91e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 922:	c12d                	beqz	a0,984 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 926:	4798                	lw	a4,8(a5)
 928:	02977263          	bgeu	a4,s1,94c <malloc+0xb6>
    if(p == freep)
 92c:	00093703          	ld	a4,0(s2)
 930:	853e                	mv	a0,a5
 932:	fef719e3          	bne	a4,a5,924 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 936:	8552                	mv	a0,s4
 938:	b1bff0ef          	jal	452 <sbrk>
  if(p == (char*)-1)
 93c:	fd551ce3          	bne	a0,s5,914 <malloc+0x7e>
        return 0;
 940:	4501                	li	a0,0
 942:	7902                	ld	s2,32(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	a03d                	j	978 <malloc+0xe2>
 94c:	7902                	ld	s2,32(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 954:	fae48de3          	beq	s1,a4,90e <malloc+0x78>
        p->s.size -= nunits;
 958:	4137073b          	subw	a4,a4,s3
 95c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95e:	02071693          	slli	a3,a4,0x20
 962:	01c6d713          	srli	a4,a3,0x1c
 966:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 968:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96c:	00000717          	auipc	a4,0x0
 970:	68a73e23          	sd	a0,1692(a4) # 1008 <freep>
      return (void*)(p + 1);
 974:	01078513          	addi	a0,a5,16
  }
}
 978:	70e2                	ld	ra,56(sp)
 97a:	7442                	ld	s0,48(sp)
 97c:	74a2                	ld	s1,40(sp)
 97e:	69e2                	ld	s3,24(sp)
 980:	6121                	addi	sp,sp,64
 982:	8082                	ret
 984:	7902                	ld	s2,32(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	b7f5                	j	978 <malloc+0xe2>
