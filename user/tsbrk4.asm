
tsbrk4:     formato del fichero elf32-i386


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
  1c:	e8 c1 01 00 00       	call   1e2 <sbrk>
  21:	89 c3                	mov    %eax,%ebx

  fork();
  23:	e8 22 01 00 00       	call   14a <fork>

  a[500] = 1;
  28:	c6 83 f4 01 00 00 01 	movb   $0x1,0x1f4(%ebx)

  if ((uint)a + 15000 != (uint) sbrk (-15000))
  2f:	8d b3 98 3a 00 00    	lea    0x3a98(%ebx),%esi
  35:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  3c:	e8 a1 01 00 00       	call   1e2 <sbrk>
  41:	83 c4 10             	add    $0x10,%esp
  44:	39 c6                	cmp    %eax,%esi
  46:	74 1b                	je     63 <main+0x63>
  {
    printf (1, "sbrk() con nÃºmero positivo fallÃ³.\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 fc 03 00 00       	push   $0x3fc
  50:	6a 01                	push   $0x1
  52:	e8 4a 02 00 00       	call   2a1 <printf>
    exit(1);
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 ef 00 00 00       	call   152 <exit>
  }

  if (a != sbrk (0))
  63:	83 ec 0c             	sub    $0xc,%esp
  66:	6a 00                	push   $0x0
  68:	e8 75 01 00 00       	call   1e2 <sbrk>
  6d:	83 c4 10             	add    $0x10,%esp
  70:	39 c3                	cmp    %eax,%ebx
  72:	74 1b                	je     8f <main+0x8f>
  {
    printf (1, "sbrk() con cero fallÃ³.\n");
  74:	83 ec 08             	sub    $0x8,%esp
  77:	68 25 04 00 00       	push   $0x425
  7c:	6a 01                	push   $0x1
  7e:	e8 1e 02 00 00       	call   2a1 <printf>
    exit(2);
  83:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8a:	e8 c3 00 00 00       	call   152 <exit>
  }

  if (a != sbrk (15000))
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	68 98 3a 00 00       	push   $0x3a98
  97:	e8 46 01 00 00       	call   1e2 <sbrk>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	39 c3                	cmp    %eax,%ebx
  a1:	74 1b                	je     be <main+0xbe>
  {
    printf (1, "sbrk() negativo fallÃ³.\n");
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	68 40 04 00 00       	push   $0x440
  ab:	6a 01                	push   $0x1
  ad:	e8 ef 01 00 00       	call   2a1 <printf>
    exit(3);
  b2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  b9:	e8 94 00 00 00       	call   152 <exit>
  }

  printf (1, "Debe imprimir 1: %d.\n", ++a[500]);
  be:	8a 83 f4 01 00 00    	mov    0x1f4(%ebx),%al
  c4:	40                   	inc    %eax
  c5:	88 83 f4 01 00 00    	mov    %al,0x1f4(%ebx)
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	0f be c0             	movsbl %al,%eax
  d1:	50                   	push   %eax
  d2:	68 5b 04 00 00       	push   $0x45b
  d7:	6a 01                	push   $0x1
  d9:	e8 c3 01 00 00       	call   2a1 <printf>

  a=sbrk (-15000);
  de:	c7 04 24 68 c5 ff ff 	movl   $0xffffc568,(%esp)
  e5:	e8 f8 00 00 00       	call   1e2 <sbrk>

  a=sbrk(1024*4096*2);
  ea:	c7 04 24 00 00 80 00 	movl   $0x800000,(%esp)
  f1:	e8 ec 00 00 00       	call   1e2 <sbrk>
  f6:	89 c3                	mov    %eax,%ebx

  fork();
  f8:	e8 4d 00 00 00       	call   14a <fork>

  a[600*4096*2] = 1;
  fd:	c6 83 00 00 4b 00 01 	movb   $0x1,0x4b0000(%ebx)

  sbrk(-1024*4096*2);
 104:	c7 04 24 00 00 80 ff 	movl   $0xff800000,(%esp)
 10b:	e8 d2 00 00 00       	call   1e2 <sbrk>

  a=sbrk(1024*4096*2);
 110:	c7 04 24 00 00 80 00 	movl   $0x800000,(%esp)
 117:	e8 c6 00 00 00       	call   1e2 <sbrk>

  printf (1, "Debe imprimir 1: %d.\n", ++a[600*4096*2]);
 11c:	8a 88 00 00 4b 00    	mov    0x4b0000(%eax),%cl
 122:	8d 51 01             	lea    0x1(%ecx),%edx
 125:	88 90 00 00 4b 00    	mov    %dl,0x4b0000(%eax)
 12b:	83 c4 0c             	add    $0xc,%esp
 12e:	0f be d2             	movsbl %dl,%edx
 131:	52                   	push   %edx
 132:	68 5b 04 00 00       	push   $0x45b
 137:	6a 01                	push   $0x1
 139:	e8 63 01 00 00       	call   2a1 <printf>

  exit(0);
 13e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 145:	e8 08 00 00 00       	call   152 <exit>

0000014a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 14a:	b8 01 00 00 00       	mov    $0x1,%eax
 14f:	cd 40                	int    $0x40
 151:	c3                   	ret    

00000152 <exit>:
SYSCALL(exit)
 152:	b8 02 00 00 00       	mov    $0x2,%eax
 157:	cd 40                	int    $0x40
 159:	c3                   	ret    

0000015a <wait>:
SYSCALL(wait)
 15a:	b8 03 00 00 00       	mov    $0x3,%eax
 15f:	cd 40                	int    $0x40
 161:	c3                   	ret    

00000162 <pipe>:
SYSCALL(pipe)
 162:	b8 04 00 00 00       	mov    $0x4,%eax
 167:	cd 40                	int    $0x40
 169:	c3                   	ret    

0000016a <read>:
SYSCALL(read)
 16a:	b8 05 00 00 00       	mov    $0x5,%eax
 16f:	cd 40                	int    $0x40
 171:	c3                   	ret    

00000172 <write>:
SYSCALL(write)
 172:	b8 10 00 00 00       	mov    $0x10,%eax
 177:	cd 40                	int    $0x40
 179:	c3                   	ret    

0000017a <close>:
SYSCALL(close)
 17a:	b8 15 00 00 00       	mov    $0x15,%eax
 17f:	cd 40                	int    $0x40
 181:	c3                   	ret    

00000182 <kill>:
SYSCALL(kill)
 182:	b8 06 00 00 00       	mov    $0x6,%eax
 187:	cd 40                	int    $0x40
 189:	c3                   	ret    

0000018a <exec>:
SYSCALL(exec)
 18a:	b8 07 00 00 00       	mov    $0x7,%eax
 18f:	cd 40                	int    $0x40
 191:	c3                   	ret    

00000192 <open>:
SYSCALL(open)
 192:	b8 0f 00 00 00       	mov    $0xf,%eax
 197:	cd 40                	int    $0x40
 199:	c3                   	ret    

0000019a <mknod>:
SYSCALL(mknod)
 19a:	b8 11 00 00 00       	mov    $0x11,%eax
 19f:	cd 40                	int    $0x40
 1a1:	c3                   	ret    

000001a2 <unlink>:
SYSCALL(unlink)
 1a2:	b8 12 00 00 00       	mov    $0x12,%eax
 1a7:	cd 40                	int    $0x40
 1a9:	c3                   	ret    

000001aa <fstat>:
SYSCALL(fstat)
 1aa:	b8 08 00 00 00       	mov    $0x8,%eax
 1af:	cd 40                	int    $0x40
 1b1:	c3                   	ret    

000001b2 <link>:
SYSCALL(link)
 1b2:	b8 13 00 00 00       	mov    $0x13,%eax
 1b7:	cd 40                	int    $0x40
 1b9:	c3                   	ret    

000001ba <mkdir>:
SYSCALL(mkdir)
 1ba:	b8 14 00 00 00       	mov    $0x14,%eax
 1bf:	cd 40                	int    $0x40
 1c1:	c3                   	ret    

000001c2 <chdir>:
SYSCALL(chdir)
 1c2:	b8 09 00 00 00       	mov    $0x9,%eax
 1c7:	cd 40                	int    $0x40
 1c9:	c3                   	ret    

000001ca <dup>:
SYSCALL(dup)
 1ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 1cf:	cd 40                	int    $0x40
 1d1:	c3                   	ret    

000001d2 <dup2>:
SYSCALL(dup2)
 1d2:	b8 17 00 00 00       	mov    $0x17,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <getpid>:
SYSCALL(getpid)
 1da:	b8 0b 00 00 00       	mov    $0xb,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <sbrk>:
SYSCALL(sbrk)
 1e2:	b8 0c 00 00 00       	mov    $0xc,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <sleep>:
SYSCALL(sleep)
 1ea:	b8 0d 00 00 00       	mov    $0xd,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <uptime>:
SYSCALL(uptime)
 1f2:	b8 0e 00 00 00       	mov    $0xe,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <date>:
SYSCALL(date)
 1fa:	b8 16 00 00 00       	mov    $0x16,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <getprio>:
SYSCALL(getprio)
 202:	b8 18 00 00 00       	mov    $0x18,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <setprio>:
SYSCALL(setprio)
 20a:	b8 19 00 00 00       	mov    $0x19,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	83 ec 1c             	sub    $0x1c,%esp
 218:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 21b:	6a 01                	push   $0x1
 21d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 220:	52                   	push   %edx
 221:	50                   	push   %eax
 222:	e8 4b ff ff ff       	call   172 <write>
}
 227:	83 c4 10             	add    $0x10,%esp
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	57                   	push   %edi
 230:	56                   	push   %esi
 231:	53                   	push   %ebx
 232:	83 ec 2c             	sub    $0x2c,%esp
 235:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 238:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 23a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 23e:	74 04                	je     244 <printint+0x18>
 240:	85 d2                	test   %edx,%edx
 242:	78 3a                	js     27e <printint+0x52>
  neg = 0;
 244:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 24b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 250:	89 f0                	mov    %esi,%eax
 252:	ba 00 00 00 00       	mov    $0x0,%edx
 257:	f7 f1                	div    %ecx
 259:	89 df                	mov    %ebx,%edi
 25b:	43                   	inc    %ebx
 25c:	8a 92 78 04 00 00    	mov    0x478(%edx),%dl
 262:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 266:	89 f2                	mov    %esi,%edx
 268:	89 c6                	mov    %eax,%esi
 26a:	39 d1                	cmp    %edx,%ecx
 26c:	76 e2                	jbe    250 <printint+0x24>
  if(neg)
 26e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 272:	74 22                	je     296 <printint+0x6a>
    buf[i++] = '-';
 274:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 279:	8d 5f 02             	lea    0x2(%edi),%ebx
 27c:	eb 18                	jmp    296 <printint+0x6a>
    x = -xx;
 27e:	f7 de                	neg    %esi
    neg = 1;
 280:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 287:	eb c2                	jmp    24b <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 289:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 28e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 291:	e8 7c ff ff ff       	call   212 <putc>
  while(--i >= 0)
 296:	4b                   	dec    %ebx
 297:	79 f0                	jns    289 <printint+0x5d>
}
 299:	83 c4 2c             	add    $0x2c,%esp
 29c:	5b                   	pop    %ebx
 29d:	5e                   	pop    %esi
 29e:	5f                   	pop    %edi
 29f:	5d                   	pop    %ebp
 2a0:	c3                   	ret    

000002a1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 2a1:	f3 0f 1e fb          	endbr32 
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	57                   	push   %edi
 2a9:	56                   	push   %esi
 2aa:	53                   	push   %ebx
 2ab:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 2ae:	8d 45 10             	lea    0x10(%ebp),%eax
 2b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2b4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2b9:	bb 00 00 00 00       	mov    $0x0,%ebx
 2be:	eb 12                	jmp    2d2 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2c0:	89 fa                	mov    %edi,%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	e8 48 ff ff ff       	call   212 <putc>
 2ca:	eb 05                	jmp    2d1 <printf+0x30>
      }
    } else if(state == '%'){
 2cc:	83 fe 25             	cmp    $0x25,%esi
 2cf:	74 22                	je     2f3 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 2d1:	43                   	inc    %ebx
 2d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d5:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2d8:	84 c0                	test   %al,%al
 2da:	0f 84 13 01 00 00    	je     3f3 <printf+0x152>
    c = fmt[i] & 0xff;
 2e0:	0f be f8             	movsbl %al,%edi
 2e3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2e6:	85 f6                	test   %esi,%esi
 2e8:	75 e2                	jne    2cc <printf+0x2b>
      if(c == '%'){
 2ea:	83 f8 25             	cmp    $0x25,%eax
 2ed:	75 d1                	jne    2c0 <printf+0x1f>
        state = '%';
 2ef:	89 c6                	mov    %eax,%esi
 2f1:	eb de                	jmp    2d1 <printf+0x30>
      if(c == 'd'){
 2f3:	83 f8 64             	cmp    $0x64,%eax
 2f6:	74 43                	je     33b <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2f8:	83 f8 78             	cmp    $0x78,%eax
 2fb:	74 68                	je     365 <printf+0xc4>
 2fd:	83 f8 70             	cmp    $0x70,%eax
 300:	74 63                	je     365 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 302:	83 f8 73             	cmp    $0x73,%eax
 305:	0f 84 84 00 00 00    	je     38f <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 30b:	83 f8 63             	cmp    $0x63,%eax
 30e:	0f 84 ad 00 00 00    	je     3c1 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 314:	83 f8 25             	cmp    $0x25,%eax
 317:	0f 84 c2 00 00 00    	je     3df <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 31d:	ba 25 00 00 00       	mov    $0x25,%edx
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	e8 e8 fe ff ff       	call   212 <putc>
        putc(fd, c);
 32a:	89 fa                	mov    %edi,%edx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	e8 de fe ff ff       	call   212 <putc>
      }
      state = 0;
 334:	be 00 00 00 00       	mov    $0x0,%esi
 339:	eb 96                	jmp    2d1 <printf+0x30>
        printint(fd, *ap, 10, 1);
 33b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 33e:	8b 17                	mov    (%edi),%edx
 340:	83 ec 0c             	sub    $0xc,%esp
 343:	6a 01                	push   $0x1
 345:	b9 0a 00 00 00       	mov    $0xa,%ecx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	e8 da fe ff ff       	call   22c <printint>
        ap++;
 352:	83 c7 04             	add    $0x4,%edi
 355:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 358:	83 c4 10             	add    $0x10,%esp
      state = 0;
 35b:	be 00 00 00 00       	mov    $0x0,%esi
 360:	e9 6c ff ff ff       	jmp    2d1 <printf+0x30>
        printint(fd, *ap, 16, 0);
 365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 368:	8b 17                	mov    (%edi),%edx
 36a:	83 ec 0c             	sub    $0xc,%esp
 36d:	6a 00                	push   $0x0
 36f:	b9 10 00 00 00       	mov    $0x10,%ecx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	e8 b0 fe ff ff       	call   22c <printint>
        ap++;
 37c:	83 c7 04             	add    $0x4,%edi
 37f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 382:	83 c4 10             	add    $0x10,%esp
      state = 0;
 385:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 38a:	e9 42 ff ff ff       	jmp    2d1 <printf+0x30>
        s = (char*)*ap;
 38f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 392:	8b 30                	mov    (%eax),%esi
        ap++;
 394:	83 c0 04             	add    $0x4,%eax
 397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 39a:	85 f6                	test   %esi,%esi
 39c:	75 13                	jne    3b1 <printf+0x110>
          s = "(null)";
 39e:	be 71 04 00 00       	mov    $0x471,%esi
 3a3:	eb 0c                	jmp    3b1 <printf+0x110>
          putc(fd, *s);
 3a5:	0f be d2             	movsbl %dl,%edx
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	e8 62 fe ff ff       	call   212 <putc>
          s++;
 3b0:	46                   	inc    %esi
        while(*s != 0){
 3b1:	8a 16                	mov    (%esi),%dl
 3b3:	84 d2                	test   %dl,%dl
 3b5:	75 ee                	jne    3a5 <printf+0x104>
      state = 0;
 3b7:	be 00 00 00 00       	mov    $0x0,%esi
 3bc:	e9 10 ff ff ff       	jmp    2d1 <printf+0x30>
        putc(fd, *ap);
 3c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3c4:	0f be 17             	movsbl (%edi),%edx
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	e8 43 fe ff ff       	call   212 <putc>
        ap++;
 3cf:	83 c7 04             	add    $0x4,%edi
 3d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3d5:	be 00 00 00 00       	mov    $0x0,%esi
 3da:	e9 f2 fe ff ff       	jmp    2d1 <printf+0x30>
        putc(fd, c);
 3df:	89 fa                	mov    %edi,%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	e8 29 fe ff ff       	call   212 <putc>
      state = 0;
 3e9:	be 00 00 00 00       	mov    $0x0,%esi
 3ee:	e9 de fe ff ff       	jmp    2d1 <printf+0x30>
    }
  }
}
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    
