
tsbrk1:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 18             	sub    $0x18,%esp
  char* a = sbrk (15000);
  17:	68 98 3a 00 00       	push   $0x3a98
  1c:	e8 5c 01 00 00       	call   17d <sbrk>
  21:	89 c3                	mov    %eax,%ebx

  a[500] = 1;
  23:	c6 80 f4 01 00 00 01 	movb   $0x1,0x1f4(%eax)

  if ((uint)a + 15000 != (uint) sbrk (-15000))
  2a:	8d b0 98 3a 00 00    	lea    0x3a98(%eax),%esi
  30:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  37:	e8 41 01 00 00       	call   17d <sbrk>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	39 c6                	cmp    %eax,%esi
  41:	74 1b                	je     5e <main+0x5e>
  {
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
  43:	83 ec 08             	sub    $0x8,%esp
  46:	68 98 03 00 00       	push   $0x398
  4b:	6a 01                	push   $0x1
  4d:	e8 ea 01 00 00       	call   23c <printf>
    exit(1);
  52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  59:	e8 8f 00 00 00       	call   ed <exit>
  }

  if (a != sbrk (0))
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 00                	push   $0x0
  63:	e8 15 01 00 00       	call   17d <sbrk>
  68:	83 c4 10             	add    $0x10,%esp
  6b:	39 c3                	cmp    %eax,%ebx
  6d:	74 1b                	je     8a <main+0x8a>
  {
    printf (1, "sbrk() con cero fallÃ³.\n");
  6f:	83 ec 08             	sub    $0x8,%esp
  72:	68 c1 03 00 00       	push   $0x3c1
  77:	6a 01                	push   $0x1
  79:	e8 be 01 00 00       	call   23c <printf>
    exit(2);
  7e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  85:	e8 63 00 00 00       	call   ed <exit>
  }

  if (a != sbrk (15000))
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	68 98 3a 00 00       	push   $0x3a98
  92:	e8 e6 00 00 00       	call   17d <sbrk>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	39 c3                	cmp    %eax,%ebx
  9c:	74 1b                	je     b9 <main+0xb9>
  {
    printf (1, "sbrk() negativo fallÃ³.\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 dc 03 00 00       	push   $0x3dc
  a6:	6a 01                	push   $0x1
  a8:	e8 8f 01 00 00       	call   23c <printf>
    exit(3);
  ad:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  b4:	e8 34 00 00 00       	call   ed <exit>
  }

  printf (1, "Debe imprimir 1: %d.\n", ++a[500]);
  b9:	8a 83 f4 01 00 00    	mov    0x1f4(%ebx),%al
  bf:	40                   	inc    %eax
  c0:	88 83 f4 01 00 00    	mov    %al,0x1f4(%ebx)
  c6:	83 ec 04             	sub    $0x4,%esp
  c9:	0f be c0             	movsbl %al,%eax
  cc:	50                   	push   %eax
  cd:	68 f7 03 00 00       	push   $0x3f7
  d2:	6a 01                	push   $0x1
  d4:	e8 63 01 00 00       	call   23c <printf>

  exit(0);
  d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  e0:	e8 08 00 00 00       	call   ed <exit>

000000e5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  e5:	b8 01 00 00 00       	mov    $0x1,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <exit>:
SYSCALL(exit)
  ed:	b8 02 00 00 00       	mov    $0x2,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <wait>:
SYSCALL(wait)
  f5:	b8 03 00 00 00       	mov    $0x3,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <pipe>:
SYSCALL(pipe)
  fd:	b8 04 00 00 00       	mov    $0x4,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <read>:
SYSCALL(read)
 105:	b8 05 00 00 00       	mov    $0x5,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <write>:
SYSCALL(write)
 10d:	b8 10 00 00 00       	mov    $0x10,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret    

00000115 <close>:
SYSCALL(close)
 115:	b8 15 00 00 00       	mov    $0x15,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret    

0000011d <kill>:
SYSCALL(kill)
 11d:	b8 06 00 00 00       	mov    $0x6,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret    

00000125 <exec>:
SYSCALL(exec)
 125:	b8 07 00 00 00       	mov    $0x7,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret    

0000012d <open>:
SYSCALL(open)
 12d:	b8 0f 00 00 00       	mov    $0xf,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret    

00000135 <mknod>:
SYSCALL(mknod)
 135:	b8 11 00 00 00       	mov    $0x11,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret    

0000013d <unlink>:
SYSCALL(unlink)
 13d:	b8 12 00 00 00       	mov    $0x12,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret    

00000145 <fstat>:
SYSCALL(fstat)
 145:	b8 08 00 00 00       	mov    $0x8,%eax
 14a:	cd 40                	int    $0x40
 14c:	c3                   	ret    

0000014d <link>:
SYSCALL(link)
 14d:	b8 13 00 00 00       	mov    $0x13,%eax
 152:	cd 40                	int    $0x40
 154:	c3                   	ret    

00000155 <mkdir>:
SYSCALL(mkdir)
 155:	b8 14 00 00 00       	mov    $0x14,%eax
 15a:	cd 40                	int    $0x40
 15c:	c3                   	ret    

0000015d <chdir>:
SYSCALL(chdir)
 15d:	b8 09 00 00 00       	mov    $0x9,%eax
 162:	cd 40                	int    $0x40
 164:	c3                   	ret    

00000165 <dup>:
SYSCALL(dup)
 165:	b8 0a 00 00 00       	mov    $0xa,%eax
 16a:	cd 40                	int    $0x40
 16c:	c3                   	ret    

0000016d <dup2>:
SYSCALL(dup2)
 16d:	b8 17 00 00 00       	mov    $0x17,%eax
 172:	cd 40                	int    $0x40
 174:	c3                   	ret    

00000175 <getpid>:
SYSCALL(getpid)
 175:	b8 0b 00 00 00       	mov    $0xb,%eax
 17a:	cd 40                	int    $0x40
 17c:	c3                   	ret    

0000017d <sbrk>:
SYSCALL(sbrk)
 17d:	b8 0c 00 00 00       	mov    $0xc,%eax
 182:	cd 40                	int    $0x40
 184:	c3                   	ret    

00000185 <sleep>:
SYSCALL(sleep)
 185:	b8 0d 00 00 00       	mov    $0xd,%eax
 18a:	cd 40                	int    $0x40
 18c:	c3                   	ret    

0000018d <uptime>:
SYSCALL(uptime)
 18d:	b8 0e 00 00 00       	mov    $0xe,%eax
 192:	cd 40                	int    $0x40
 194:	c3                   	ret    

00000195 <date>:
SYSCALL(date)
 195:	b8 16 00 00 00       	mov    $0x16,%eax
 19a:	cd 40                	int    $0x40
 19c:	c3                   	ret    

0000019d <getprio>:
SYSCALL(getprio)
 19d:	b8 18 00 00 00       	mov    $0x18,%eax
 1a2:	cd 40                	int    $0x40
 1a4:	c3                   	ret    

000001a5 <setprio>:
SYSCALL(setprio)
 1a5:	b8 19 00 00 00       	mov    $0x19,%eax
 1aa:	cd 40                	int    $0x40
 1ac:	c3                   	ret    

000001ad <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
 1b0:	83 ec 1c             	sub    $0x1c,%esp
 1b3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1b6:	6a 01                	push   $0x1
 1b8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1bb:	52                   	push   %edx
 1bc:	50                   	push   %eax
 1bd:	e8 4b ff ff ff       	call   10d <write>
}
 1c2:	83 c4 10             	add    $0x10,%esp
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	57                   	push   %edi
 1cb:	56                   	push   %esi
 1cc:	53                   	push   %ebx
 1cd:	83 ec 2c             	sub    $0x2c,%esp
 1d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1d3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1d9:	74 04                	je     1df <printint+0x18>
 1db:	85 d2                	test   %edx,%edx
 1dd:	78 3a                	js     219 <printint+0x52>
  neg = 0;
 1df:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1eb:	89 f0                	mov    %esi,%eax
 1ed:	ba 00 00 00 00       	mov    $0x0,%edx
 1f2:	f7 f1                	div    %ecx
 1f4:	89 df                	mov    %ebx,%edi
 1f6:	43                   	inc    %ebx
 1f7:	8a 92 14 04 00 00    	mov    0x414(%edx),%dl
 1fd:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 201:	89 f2                	mov    %esi,%edx
 203:	89 c6                	mov    %eax,%esi
 205:	39 d1                	cmp    %edx,%ecx
 207:	76 e2                	jbe    1eb <printint+0x24>
  if(neg)
 209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 20d:	74 22                	je     231 <printint+0x6a>
    buf[i++] = '-';
 20f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 214:	8d 5f 02             	lea    0x2(%edi),%ebx
 217:	eb 18                	jmp    231 <printint+0x6a>
    x = -xx;
 219:	f7 de                	neg    %esi
    neg = 1;
 21b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 222:	eb c2                	jmp    1e6 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 224:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 229:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 22c:	e8 7c ff ff ff       	call   1ad <putc>
  while(--i >= 0)
 231:	4b                   	dec    %ebx
 232:	79 f0                	jns    224 <printint+0x5d>
}
 234:	83 c4 2c             	add    $0x2c,%esp
 237:	5b                   	pop    %ebx
 238:	5e                   	pop    %esi
 239:	5f                   	pop    %edi
 23a:	5d                   	pop    %ebp
 23b:	c3                   	ret    

0000023c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 23c:	f3 0f 1e fb          	endbr32 
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	53                   	push   %ebx
 246:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 249:	8d 45 10             	lea    0x10(%ebp),%eax
 24c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 24f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 254:	bb 00 00 00 00       	mov    $0x0,%ebx
 259:	eb 12                	jmp    26d <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 25b:	89 fa                	mov    %edi,%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	e8 48 ff ff ff       	call   1ad <putc>
 265:	eb 05                	jmp    26c <printf+0x30>
      }
    } else if(state == '%'){
 267:	83 fe 25             	cmp    $0x25,%esi
 26a:	74 22                	je     28e <printf+0x52>
  for(i = 0; fmt[i]; i++){
 26c:	43                   	inc    %ebx
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	8a 04 18             	mov    (%eax,%ebx,1),%al
 273:	84 c0                	test   %al,%al
 275:	0f 84 13 01 00 00    	je     38e <printf+0x152>
    c = fmt[i] & 0xff;
 27b:	0f be f8             	movsbl %al,%edi
 27e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 281:	85 f6                	test   %esi,%esi
 283:	75 e2                	jne    267 <printf+0x2b>
      if(c == '%'){
 285:	83 f8 25             	cmp    $0x25,%eax
 288:	75 d1                	jne    25b <printf+0x1f>
        state = '%';
 28a:	89 c6                	mov    %eax,%esi
 28c:	eb de                	jmp    26c <printf+0x30>
      if(c == 'd'){
 28e:	83 f8 64             	cmp    $0x64,%eax
 291:	74 43                	je     2d6 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 293:	83 f8 78             	cmp    $0x78,%eax
 296:	74 68                	je     300 <printf+0xc4>
 298:	83 f8 70             	cmp    $0x70,%eax
 29b:	74 63                	je     300 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 29d:	83 f8 73             	cmp    $0x73,%eax
 2a0:	0f 84 84 00 00 00    	je     32a <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2a6:	83 f8 63             	cmp    $0x63,%eax
 2a9:	0f 84 ad 00 00 00    	je     35c <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2af:	83 f8 25             	cmp    $0x25,%eax
 2b2:	0f 84 c2 00 00 00    	je     37a <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2b8:	ba 25 00 00 00       	mov    $0x25,%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	e8 e8 fe ff ff       	call   1ad <putc>
        putc(fd, c);
 2c5:	89 fa                	mov    %edi,%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	e8 de fe ff ff       	call   1ad <putc>
      }
      state = 0;
 2cf:	be 00 00 00 00       	mov    $0x0,%esi
 2d4:	eb 96                	jmp    26c <printf+0x30>
        printint(fd, *ap, 10, 1);
 2d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d9:	8b 17                	mov    (%edi),%edx
 2db:	83 ec 0c             	sub    $0xc,%esp
 2de:	6a 01                	push   $0x1
 2e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	e8 da fe ff ff       	call   1c7 <printint>
        ap++;
 2ed:	83 c7 04             	add    $0x4,%edi
 2f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2f6:	be 00 00 00 00       	mov    $0x0,%esi
 2fb:	e9 6c ff ff ff       	jmp    26c <printf+0x30>
        printint(fd, *ap, 16, 0);
 300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 303:	8b 17                	mov    (%edi),%edx
 305:	83 ec 0c             	sub    $0xc,%esp
 308:	6a 00                	push   $0x0
 30a:	b9 10 00 00 00       	mov    $0x10,%ecx
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	e8 b0 fe ff ff       	call   1c7 <printint>
        ap++;
 317:	83 c7 04             	add    $0x4,%edi
 31a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 31d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 320:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 325:	e9 42 ff ff ff       	jmp    26c <printf+0x30>
        s = (char*)*ap;
 32a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 32d:	8b 30                	mov    (%eax),%esi
        ap++;
 32f:	83 c0 04             	add    $0x4,%eax
 332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 335:	85 f6                	test   %esi,%esi
 337:	75 13                	jne    34c <printf+0x110>
          s = "(null)";
 339:	be 0d 04 00 00       	mov    $0x40d,%esi
 33e:	eb 0c                	jmp    34c <printf+0x110>
          putc(fd, *s);
 340:	0f be d2             	movsbl %dl,%edx
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	e8 62 fe ff ff       	call   1ad <putc>
          s++;
 34b:	46                   	inc    %esi
        while(*s != 0){
 34c:	8a 16                	mov    (%esi),%dl
 34e:	84 d2                	test   %dl,%dl
 350:	75 ee                	jne    340 <printf+0x104>
      state = 0;
 352:	be 00 00 00 00       	mov    $0x0,%esi
 357:	e9 10 ff ff ff       	jmp    26c <printf+0x30>
        putc(fd, *ap);
 35c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 35f:	0f be 17             	movsbl (%edi),%edx
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	e8 43 fe ff ff       	call   1ad <putc>
        ap++;
 36a:	83 c7 04             	add    $0x4,%edi
 36d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 370:	be 00 00 00 00       	mov    $0x0,%esi
 375:	e9 f2 fe ff ff       	jmp    26c <printf+0x30>
        putc(fd, c);
 37a:	89 fa                	mov    %edi,%edx
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	e8 29 fe ff ff       	call   1ad <putc>
      state = 0;
 384:	be 00 00 00 00       	mov    $0x0,%esi
 389:	e9 de fe ff ff       	jmp    26c <printf+0x30>
    }
  }
}
 38e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 391:	5b                   	pop    %ebx
 392:	5e                   	pop    %esi
 393:	5f                   	pop    %edi
 394:	5d                   	pop    %ebp
 395:	c3                   	ret    
