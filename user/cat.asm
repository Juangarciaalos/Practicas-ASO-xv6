
cat:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   c:	83 ec 04             	sub    $0x4,%esp
   f:	68 00 02 00 00       	push   $0x200
  14:	68 20 05 00 00       	push   $0x520
  19:	56                   	push   %esi
  1a:	e8 20 01 00 00       	call   13f <read>
  1f:	89 c3                	mov    %eax,%ebx
  21:	83 c4 10             	add    $0x10,%esp
  24:	85 c0                	test   %eax,%eax
  26:	7e 32                	jle    5a <cat+0x5a>
    if (write(1, buf, n) != n) {
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	53                   	push   %ebx
  2c:	68 20 05 00 00       	push   $0x520
  31:	6a 01                	push   $0x1
  33:	e8 0f 01 00 00       	call   147 <write>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 d8                	cmp    %ebx,%eax
  3d:	74 cd                	je     c <cat+0xc>
      printf(1, "cat: write error\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 d0 03 00 00       	push   $0x3d0
  47:	6a 01                	push   $0x1
  49:	e8 28 02 00 00       	call   276 <printf>
      exit(0);
  4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  55:	e8 cd 00 00 00       	call   127 <exit>
    }
  }
  if(n < 0){
  5a:	78 07                	js     63 <cat+0x63>
    printf(1, "cat: read error\n");
    exit(0);
  }
}
  5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  5f:	5b                   	pop    %ebx
  60:	5e                   	pop    %esi
  61:	5d                   	pop    %ebp
  62:	c3                   	ret    
    printf(1, "cat: read error\n");
  63:	83 ec 08             	sub    $0x8,%esp
  66:	68 e2 03 00 00       	push   $0x3e2
  6b:	6a 01                	push   $0x1
  6d:	e8 04 02 00 00       	call   276 <printf>
    exit(0);
  72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  79:	e8 a9 00 00 00       	call   127 <exit>

0000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	f3 0f 1e fb          	endbr32 
  82:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  86:	83 e4 f0             	and    $0xfffffff0,%esp
  89:	ff 71 fc             	pushl  -0x4(%ecx)
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	57                   	push   %edi
  90:	56                   	push   %esi
  91:	53                   	push   %ebx
  92:	51                   	push   %ecx
  93:	83 ec 18             	sub    $0x18,%esp
  96:	8b 01                	mov    (%ecx),%eax
  98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  9b:	8b 51 04             	mov    0x4(%ecx),%edx
  9e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  a1:	83 f8 01             	cmp    $0x1,%eax
  a4:	7e 3c                	jle    e2 <main+0x64>
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
  a6:	be 01 00 00 00       	mov    $0x1,%esi
  ab:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  ae:	7d 65                	jge    115 <main+0x97>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b3:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	6a 00                	push   $0x0
  bb:	ff 37                	pushl  (%edi)
  bd:	e8 a5 00 00 00       	call   167 <open>
  c2:	89 c3                	mov    %eax,%ebx
  c4:	83 c4 10             	add    $0x10,%esp
  c7:	85 c0                	test   %eax,%eax
  c9:	78 2d                	js     f8 <main+0x7a>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(fd);
  cb:	83 ec 0c             	sub    $0xc,%esp
  ce:	50                   	push   %eax
  cf:	e8 2c ff ff ff       	call   0 <cat>
    close(fd);
  d4:	89 1c 24             	mov    %ebx,(%esp)
  d7:	e8 73 00 00 00       	call   14f <close>
  for(i = 1; i < argc; i++){
  dc:	46                   	inc    %esi
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	eb c9                	jmp    ab <main+0x2d>
    cat(0);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	6a 00                	push   $0x0
  e7:	e8 14 ff ff ff       	call   0 <cat>
    exit(0);
  ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f3:	e8 2f 00 00 00       	call   127 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  f8:	83 ec 04             	sub    $0x4,%esp
  fb:	ff 37                	pushl  (%edi)
  fd:	68 f3 03 00 00       	push   $0x3f3
 102:	6a 01                	push   $0x1
 104:	e8 6d 01 00 00       	call   276 <printf>
      exit(0);
 109:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 110:	e8 12 00 00 00       	call   127 <exit>
  }
  exit(0);
 115:	83 ec 0c             	sub    $0xc,%esp
 118:	6a 00                	push   $0x0
 11a:	e8 08 00 00 00       	call   127 <exit>

0000011f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 11f:	b8 01 00 00 00       	mov    $0x1,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <exit>:
SYSCALL(exit)
 127:	b8 02 00 00 00       	mov    $0x2,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <wait>:
SYSCALL(wait)
 12f:	b8 03 00 00 00       	mov    $0x3,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    

00000137 <pipe>:
SYSCALL(pipe)
 137:	b8 04 00 00 00       	mov    $0x4,%eax
 13c:	cd 40                	int    $0x40
 13e:	c3                   	ret    

0000013f <read>:
SYSCALL(read)
 13f:	b8 05 00 00 00       	mov    $0x5,%eax
 144:	cd 40                	int    $0x40
 146:	c3                   	ret    

00000147 <write>:
SYSCALL(write)
 147:	b8 10 00 00 00       	mov    $0x10,%eax
 14c:	cd 40                	int    $0x40
 14e:	c3                   	ret    

0000014f <close>:
SYSCALL(close)
 14f:	b8 15 00 00 00       	mov    $0x15,%eax
 154:	cd 40                	int    $0x40
 156:	c3                   	ret    

00000157 <kill>:
SYSCALL(kill)
 157:	b8 06 00 00 00       	mov    $0x6,%eax
 15c:	cd 40                	int    $0x40
 15e:	c3                   	ret    

0000015f <exec>:
SYSCALL(exec)
 15f:	b8 07 00 00 00       	mov    $0x7,%eax
 164:	cd 40                	int    $0x40
 166:	c3                   	ret    

00000167 <open>:
SYSCALL(open)
 167:	b8 0f 00 00 00       	mov    $0xf,%eax
 16c:	cd 40                	int    $0x40
 16e:	c3                   	ret    

0000016f <mknod>:
SYSCALL(mknod)
 16f:	b8 11 00 00 00       	mov    $0x11,%eax
 174:	cd 40                	int    $0x40
 176:	c3                   	ret    

00000177 <unlink>:
SYSCALL(unlink)
 177:	b8 12 00 00 00       	mov    $0x12,%eax
 17c:	cd 40                	int    $0x40
 17e:	c3                   	ret    

0000017f <fstat>:
SYSCALL(fstat)
 17f:	b8 08 00 00 00       	mov    $0x8,%eax
 184:	cd 40                	int    $0x40
 186:	c3                   	ret    

00000187 <link>:
SYSCALL(link)
 187:	b8 13 00 00 00       	mov    $0x13,%eax
 18c:	cd 40                	int    $0x40
 18e:	c3                   	ret    

0000018f <mkdir>:
SYSCALL(mkdir)
 18f:	b8 14 00 00 00       	mov    $0x14,%eax
 194:	cd 40                	int    $0x40
 196:	c3                   	ret    

00000197 <chdir>:
SYSCALL(chdir)
 197:	b8 09 00 00 00       	mov    $0x9,%eax
 19c:	cd 40                	int    $0x40
 19e:	c3                   	ret    

0000019f <dup>:
SYSCALL(dup)
 19f:	b8 0a 00 00 00       	mov    $0xa,%eax
 1a4:	cd 40                	int    $0x40
 1a6:	c3                   	ret    

000001a7 <dup2>:
SYSCALL(dup2)
 1a7:	b8 17 00 00 00       	mov    $0x17,%eax
 1ac:	cd 40                	int    $0x40
 1ae:	c3                   	ret    

000001af <getpid>:
SYSCALL(getpid)
 1af:	b8 0b 00 00 00       	mov    $0xb,%eax
 1b4:	cd 40                	int    $0x40
 1b6:	c3                   	ret    

000001b7 <sbrk>:
SYSCALL(sbrk)
 1b7:	b8 0c 00 00 00       	mov    $0xc,%eax
 1bc:	cd 40                	int    $0x40
 1be:	c3                   	ret    

000001bf <sleep>:
SYSCALL(sleep)
 1bf:	b8 0d 00 00 00       	mov    $0xd,%eax
 1c4:	cd 40                	int    $0x40
 1c6:	c3                   	ret    

000001c7 <uptime>:
SYSCALL(uptime)
 1c7:	b8 0e 00 00 00       	mov    $0xe,%eax
 1cc:	cd 40                	int    $0x40
 1ce:	c3                   	ret    

000001cf <date>:
SYSCALL(date)
 1cf:	b8 16 00 00 00       	mov    $0x16,%eax
 1d4:	cd 40                	int    $0x40
 1d6:	c3                   	ret    

000001d7 <getprio>:
SYSCALL(getprio)
 1d7:	b8 18 00 00 00       	mov    $0x18,%eax
 1dc:	cd 40                	int    $0x40
 1de:	c3                   	ret    

000001df <setprio>:
SYSCALL(setprio)
 1df:	b8 19 00 00 00       	mov    $0x19,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 1c             	sub    $0x1c,%esp
 1ed:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1f0:	6a 01                	push   $0x1
 1f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1f5:	52                   	push   %edx
 1f6:	50                   	push   %eax
 1f7:	e8 4b ff ff ff       	call   147 <write>
}
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	57                   	push   %edi
 205:	56                   	push   %esi
 206:	53                   	push   %ebx
 207:	83 ec 2c             	sub    $0x2c,%esp
 20a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 20d:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 20f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 213:	74 04                	je     219 <printint+0x18>
 215:	85 d2                	test   %edx,%edx
 217:	78 3a                	js     253 <printint+0x52>
  neg = 0;
 219:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 220:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 225:	89 f0                	mov    %esi,%eax
 227:	ba 00 00 00 00       	mov    $0x0,%edx
 22c:	f7 f1                	div    %ecx
 22e:	89 df                	mov    %ebx,%edi
 230:	43                   	inc    %ebx
 231:	8a 92 10 04 00 00    	mov    0x410(%edx),%dl
 237:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 23b:	89 f2                	mov    %esi,%edx
 23d:	89 c6                	mov    %eax,%esi
 23f:	39 d1                	cmp    %edx,%ecx
 241:	76 e2                	jbe    225 <printint+0x24>
  if(neg)
 243:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 247:	74 22                	je     26b <printint+0x6a>
    buf[i++] = '-';
 249:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 24e:	8d 5f 02             	lea    0x2(%edi),%ebx
 251:	eb 18                	jmp    26b <printint+0x6a>
    x = -xx;
 253:	f7 de                	neg    %esi
    neg = 1;
 255:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 25c:	eb c2                	jmp    220 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 25e:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 263:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 266:	e8 7c ff ff ff       	call   1e7 <putc>
  while(--i >= 0)
 26b:	4b                   	dec    %ebx
 26c:	79 f0                	jns    25e <printint+0x5d>
}
 26e:	83 c4 2c             	add    $0x2c,%esp
 271:	5b                   	pop    %ebx
 272:	5e                   	pop    %esi
 273:	5f                   	pop    %edi
 274:	5d                   	pop    %ebp
 275:	c3                   	ret    

00000276 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 276:	f3 0f 1e fb          	endbr32 
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	57                   	push   %edi
 27e:	56                   	push   %esi
 27f:	53                   	push   %ebx
 280:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 283:	8d 45 10             	lea    0x10(%ebp),%eax
 286:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 289:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 28e:	bb 00 00 00 00       	mov    $0x0,%ebx
 293:	eb 12                	jmp    2a7 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 295:	89 fa                	mov    %edi,%edx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	e8 48 ff ff ff       	call   1e7 <putc>
 29f:	eb 05                	jmp    2a6 <printf+0x30>
      }
    } else if(state == '%'){
 2a1:	83 fe 25             	cmp    $0x25,%esi
 2a4:	74 22                	je     2c8 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 2a6:	43                   	inc    %ebx
 2a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2aa:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2ad:	84 c0                	test   %al,%al
 2af:	0f 84 13 01 00 00    	je     3c8 <printf+0x152>
    c = fmt[i] & 0xff;
 2b5:	0f be f8             	movsbl %al,%edi
 2b8:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2bb:	85 f6                	test   %esi,%esi
 2bd:	75 e2                	jne    2a1 <printf+0x2b>
      if(c == '%'){
 2bf:	83 f8 25             	cmp    $0x25,%eax
 2c2:	75 d1                	jne    295 <printf+0x1f>
        state = '%';
 2c4:	89 c6                	mov    %eax,%esi
 2c6:	eb de                	jmp    2a6 <printf+0x30>
      if(c == 'd'){
 2c8:	83 f8 64             	cmp    $0x64,%eax
 2cb:	74 43                	je     310 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2cd:	83 f8 78             	cmp    $0x78,%eax
 2d0:	74 68                	je     33a <printf+0xc4>
 2d2:	83 f8 70             	cmp    $0x70,%eax
 2d5:	74 63                	je     33a <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2d7:	83 f8 73             	cmp    $0x73,%eax
 2da:	0f 84 84 00 00 00    	je     364 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2e0:	83 f8 63             	cmp    $0x63,%eax
 2e3:	0f 84 ad 00 00 00    	je     396 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2e9:	83 f8 25             	cmp    $0x25,%eax
 2ec:	0f 84 c2 00 00 00    	je     3b4 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2f2:	ba 25 00 00 00       	mov    $0x25,%edx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	e8 e8 fe ff ff       	call   1e7 <putc>
        putc(fd, c);
 2ff:	89 fa                	mov    %edi,%edx
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	e8 de fe ff ff       	call   1e7 <putc>
      }
      state = 0;
 309:	be 00 00 00 00       	mov    $0x0,%esi
 30e:	eb 96                	jmp    2a6 <printf+0x30>
        printint(fd, *ap, 10, 1);
 310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 313:	8b 17                	mov    (%edi),%edx
 315:	83 ec 0c             	sub    $0xc,%esp
 318:	6a 01                	push   $0x1
 31a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	e8 da fe ff ff       	call   201 <printint>
        ap++;
 327:	83 c7 04             	add    $0x4,%edi
 32a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 32d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 330:	be 00 00 00 00       	mov    $0x0,%esi
 335:	e9 6c ff ff ff       	jmp    2a6 <printf+0x30>
        printint(fd, *ap, 16, 0);
 33a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 33d:	8b 17                	mov    (%edi),%edx
 33f:	83 ec 0c             	sub    $0xc,%esp
 342:	6a 00                	push   $0x0
 344:	b9 10 00 00 00       	mov    $0x10,%ecx
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	e8 b0 fe ff ff       	call   201 <printint>
        ap++;
 351:	83 c7 04             	add    $0x4,%edi
 354:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 357:	83 c4 10             	add    $0x10,%esp
      state = 0;
 35a:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 35f:	e9 42 ff ff ff       	jmp    2a6 <printf+0x30>
        s = (char*)*ap;
 364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 367:	8b 30                	mov    (%eax),%esi
        ap++;
 369:	83 c0 04             	add    $0x4,%eax
 36c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 36f:	85 f6                	test   %esi,%esi
 371:	75 13                	jne    386 <printf+0x110>
          s = "(null)";
 373:	be 08 04 00 00       	mov    $0x408,%esi
 378:	eb 0c                	jmp    386 <printf+0x110>
          putc(fd, *s);
 37a:	0f be d2             	movsbl %dl,%edx
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	e8 62 fe ff ff       	call   1e7 <putc>
          s++;
 385:	46                   	inc    %esi
        while(*s != 0){
 386:	8a 16                	mov    (%esi),%dl
 388:	84 d2                	test   %dl,%dl
 38a:	75 ee                	jne    37a <printf+0x104>
      state = 0;
 38c:	be 00 00 00 00       	mov    $0x0,%esi
 391:	e9 10 ff ff ff       	jmp    2a6 <printf+0x30>
        putc(fd, *ap);
 396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 399:	0f be 17             	movsbl (%edi),%edx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	e8 43 fe ff ff       	call   1e7 <putc>
        ap++;
 3a4:	83 c7 04             	add    $0x4,%edi
 3a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3aa:	be 00 00 00 00       	mov    $0x0,%esi
 3af:	e9 f2 fe ff ff       	jmp    2a6 <printf+0x30>
        putc(fd, c);
 3b4:	89 fa                	mov    %edi,%edx
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	e8 29 fe ff ff       	call   1e7 <putc>
      state = 0;
 3be:	be 00 00 00 00       	mov    $0x0,%esi
 3c3:	e9 de fe ff ff       	jmp    2a6 <printf+0x30>
    }
  }
}
 3c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3cb:	5b                   	pop    %ebx
 3cc:	5e                   	pop    %esi
 3cd:	5f                   	pop    %edi
 3ce:	5d                   	pop    %ebp
 3cf:	c3                   	ret    
