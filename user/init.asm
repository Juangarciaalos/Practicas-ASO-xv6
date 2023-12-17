
init:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 02                	push   $0x2
  18:	68 ac 03 00 00       	push   $0x3ac
  1d:	e8 20 01 00 00       	call   142 <open>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	78 61                	js     8a <main+0x8a>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 47 01 00 00       	call   17a <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 3b 01 00 00       	call   17a <dup>
  3f:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  42:	83 ec 08             	sub    $0x8,%esp
  45:	68 b4 03 00 00       	push   $0x3b4
  4a:	6a 01                	push   $0x1
  4c:	e8 00 02 00 00       	call   251 <printf>
    pid = fork();
  51:	e8 a4 00 00 00       	call   fa <fork>
  56:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  58:	83 c4 10             	add    $0x10,%esp
  5b:	85 c0                	test   %eax,%eax
  5d:	78 53                	js     b2 <main+0xb2>
      printf(1, "init: fork failed\n");
      exit(0);
    }
    if(pid == 0){
  5f:	74 6c                	je     cd <main+0xcd>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit(0);
    }
    while((wpid=wait(NULL)) >= 0 && wpid != pid)
  61:	83 ec 0c             	sub    $0xc,%esp
  64:	6a 00                	push   $0x0
  66:	e8 9f 00 00 00       	call   10a <wait>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	85 c0                	test   %eax,%eax
  70:	78 d0                	js     42 <main+0x42>
  72:	39 c3                	cmp    %eax,%ebx
  74:	74 cc                	je     42 <main+0x42>
      printf(1, "zombie!\n");
  76:	83 ec 08             	sub    $0x8,%esp
  79:	68 f3 03 00 00       	push   $0x3f3
  7e:	6a 01                	push   $0x1
  80:	e8 cc 01 00 00       	call   251 <printf>
  85:	83 c4 10             	add    $0x10,%esp
  88:	eb d7                	jmp    61 <main+0x61>
    mknod("console", 1, 1);
  8a:	83 ec 04             	sub    $0x4,%esp
  8d:	6a 01                	push   $0x1
  8f:	6a 01                	push   $0x1
  91:	68 ac 03 00 00       	push   $0x3ac
  96:	e8 af 00 00 00       	call   14a <mknod>
    open("console", O_RDWR);
  9b:	83 c4 08             	add    $0x8,%esp
  9e:	6a 02                	push   $0x2
  a0:	68 ac 03 00 00       	push   $0x3ac
  a5:	e8 98 00 00 00       	call   142 <open>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	e9 77 ff ff ff       	jmp    29 <main+0x29>
      printf(1, "init: fork failed\n");
  b2:	83 ec 08             	sub    $0x8,%esp
  b5:	68 c7 03 00 00       	push   $0x3c7
  ba:	6a 01                	push   $0x1
  bc:	e8 90 01 00 00       	call   251 <printf>
      exit(0);
  c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c8:	e8 35 00 00 00       	call   102 <exit>
      exec("sh", argv);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 d4 04 00 00       	push   $0x4d4
  d5:	68 da 03 00 00       	push   $0x3da
  da:	e8 5b 00 00 00       	call   13a <exec>
      printf(1, "init: exec sh failed\n");
  df:	83 c4 08             	add    $0x8,%esp
  e2:	68 dd 03 00 00       	push   $0x3dd
  e7:	6a 01                	push   $0x1
  e9:	e8 63 01 00 00       	call   251 <printf>
      exit(0);
  ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f5:	e8 08 00 00 00       	call   102 <exit>

000000fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  fa:	b8 01 00 00 00       	mov    $0x1,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <exit>:
SYSCALL(exit)
 102:	b8 02 00 00 00       	mov    $0x2,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <wait>:
SYSCALL(wait)
 10a:	b8 03 00 00 00       	mov    $0x3,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <pipe>:
SYSCALL(pipe)
 112:	b8 04 00 00 00       	mov    $0x4,%eax
 117:	cd 40                	int    $0x40
 119:	c3                   	ret    

0000011a <read>:
SYSCALL(read)
 11a:	b8 05 00 00 00       	mov    $0x5,%eax
 11f:	cd 40                	int    $0x40
 121:	c3                   	ret    

00000122 <write>:
SYSCALL(write)
 122:	b8 10 00 00 00       	mov    $0x10,%eax
 127:	cd 40                	int    $0x40
 129:	c3                   	ret    

0000012a <close>:
SYSCALL(close)
 12a:	b8 15 00 00 00       	mov    $0x15,%eax
 12f:	cd 40                	int    $0x40
 131:	c3                   	ret    

00000132 <kill>:
SYSCALL(kill)
 132:	b8 06 00 00 00       	mov    $0x6,%eax
 137:	cd 40                	int    $0x40
 139:	c3                   	ret    

0000013a <exec>:
SYSCALL(exec)
 13a:	b8 07 00 00 00       	mov    $0x7,%eax
 13f:	cd 40                	int    $0x40
 141:	c3                   	ret    

00000142 <open>:
SYSCALL(open)
 142:	b8 0f 00 00 00       	mov    $0xf,%eax
 147:	cd 40                	int    $0x40
 149:	c3                   	ret    

0000014a <mknod>:
SYSCALL(mknod)
 14a:	b8 11 00 00 00       	mov    $0x11,%eax
 14f:	cd 40                	int    $0x40
 151:	c3                   	ret    

00000152 <unlink>:
SYSCALL(unlink)
 152:	b8 12 00 00 00       	mov    $0x12,%eax
 157:	cd 40                	int    $0x40
 159:	c3                   	ret    

0000015a <fstat>:
SYSCALL(fstat)
 15a:	b8 08 00 00 00       	mov    $0x8,%eax
 15f:	cd 40                	int    $0x40
 161:	c3                   	ret    

00000162 <link>:
SYSCALL(link)
 162:	b8 13 00 00 00       	mov    $0x13,%eax
 167:	cd 40                	int    $0x40
 169:	c3                   	ret    

0000016a <mkdir>:
SYSCALL(mkdir)
 16a:	b8 14 00 00 00       	mov    $0x14,%eax
 16f:	cd 40                	int    $0x40
 171:	c3                   	ret    

00000172 <chdir>:
SYSCALL(chdir)
 172:	b8 09 00 00 00       	mov    $0x9,%eax
 177:	cd 40                	int    $0x40
 179:	c3                   	ret    

0000017a <dup>:
SYSCALL(dup)
 17a:	b8 0a 00 00 00       	mov    $0xa,%eax
 17f:	cd 40                	int    $0x40
 181:	c3                   	ret    

00000182 <dup2>:
SYSCALL(dup2)
 182:	b8 17 00 00 00       	mov    $0x17,%eax
 187:	cd 40                	int    $0x40
 189:	c3                   	ret    

0000018a <getpid>:
SYSCALL(getpid)
 18a:	b8 0b 00 00 00       	mov    $0xb,%eax
 18f:	cd 40                	int    $0x40
 191:	c3                   	ret    

00000192 <sbrk>:
SYSCALL(sbrk)
 192:	b8 0c 00 00 00       	mov    $0xc,%eax
 197:	cd 40                	int    $0x40
 199:	c3                   	ret    

0000019a <sleep>:
SYSCALL(sleep)
 19a:	b8 0d 00 00 00       	mov    $0xd,%eax
 19f:	cd 40                	int    $0x40
 1a1:	c3                   	ret    

000001a2 <uptime>:
SYSCALL(uptime)
 1a2:	b8 0e 00 00 00       	mov    $0xe,%eax
 1a7:	cd 40                	int    $0x40
 1a9:	c3                   	ret    

000001aa <date>:
SYSCALL(date)
 1aa:	b8 16 00 00 00       	mov    $0x16,%eax
 1af:	cd 40                	int    $0x40
 1b1:	c3                   	ret    

000001b2 <getprio>:
SYSCALL(getprio)
 1b2:	b8 18 00 00 00       	mov    $0x18,%eax
 1b7:	cd 40                	int    $0x40
 1b9:	c3                   	ret    

000001ba <setprio>:
SYSCALL(setprio)
 1ba:	b8 19 00 00 00       	mov    $0x19,%eax
 1bf:	cd 40                	int    $0x40
 1c1:	c3                   	ret    

000001c2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	83 ec 1c             	sub    $0x1c,%esp
 1c8:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 1cb:	6a 01                	push   $0x1
 1cd:	8d 55 f4             	lea    -0xc(%ebp),%edx
 1d0:	52                   	push   %edx
 1d1:	50                   	push   %eax
 1d2:	e8 4b ff ff ff       	call   122 <write>
}
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	57                   	push   %edi
 1e0:	56                   	push   %esi
 1e1:	53                   	push   %ebx
 1e2:	83 ec 2c             	sub    $0x2c,%esp
 1e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1e8:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1ee:	74 04                	je     1f4 <printint+0x18>
 1f0:	85 d2                	test   %edx,%edx
 1f2:	78 3a                	js     22e <printint+0x52>
  neg = 0;
 1f4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 200:	89 f0                	mov    %esi,%eax
 202:	ba 00 00 00 00       	mov    $0x0,%edx
 207:	f7 f1                	div    %ecx
 209:	89 df                	mov    %ebx,%edi
 20b:	43                   	inc    %ebx
 20c:	8a 92 04 04 00 00    	mov    0x404(%edx),%dl
 212:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 216:	89 f2                	mov    %esi,%edx
 218:	89 c6                	mov    %eax,%esi
 21a:	39 d1                	cmp    %edx,%ecx
 21c:	76 e2                	jbe    200 <printint+0x24>
  if(neg)
 21e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 222:	74 22                	je     246 <printint+0x6a>
    buf[i++] = '-';
 224:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 229:	8d 5f 02             	lea    0x2(%edi),%ebx
 22c:	eb 18                	jmp    246 <printint+0x6a>
    x = -xx;
 22e:	f7 de                	neg    %esi
    neg = 1;
 230:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 237:	eb c2                	jmp    1fb <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 239:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 23e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 241:	e8 7c ff ff ff       	call   1c2 <putc>
  while(--i >= 0)
 246:	4b                   	dec    %ebx
 247:	79 f0                	jns    239 <printint+0x5d>
}
 249:	83 c4 2c             	add    $0x2c,%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 251:	f3 0f 1e fb          	endbr32 
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	57                   	push   %edi
 259:	56                   	push   %esi
 25a:	53                   	push   %ebx
 25b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 25e:	8d 45 10             	lea    0x10(%ebp),%eax
 261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 264:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 269:	bb 00 00 00 00       	mov    $0x0,%ebx
 26e:	eb 12                	jmp    282 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 270:	89 fa                	mov    %edi,%edx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	e8 48 ff ff ff       	call   1c2 <putc>
 27a:	eb 05                	jmp    281 <printf+0x30>
      }
    } else if(state == '%'){
 27c:	83 fe 25             	cmp    $0x25,%esi
 27f:	74 22                	je     2a3 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 281:	43                   	inc    %ebx
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	8a 04 18             	mov    (%eax,%ebx,1),%al
 288:	84 c0                	test   %al,%al
 28a:	0f 84 13 01 00 00    	je     3a3 <printf+0x152>
    c = fmt[i] & 0xff;
 290:	0f be f8             	movsbl %al,%edi
 293:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 296:	85 f6                	test   %esi,%esi
 298:	75 e2                	jne    27c <printf+0x2b>
      if(c == '%'){
 29a:	83 f8 25             	cmp    $0x25,%eax
 29d:	75 d1                	jne    270 <printf+0x1f>
        state = '%';
 29f:	89 c6                	mov    %eax,%esi
 2a1:	eb de                	jmp    281 <printf+0x30>
      if(c == 'd'){
 2a3:	83 f8 64             	cmp    $0x64,%eax
 2a6:	74 43                	je     2eb <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2a8:	83 f8 78             	cmp    $0x78,%eax
 2ab:	74 68                	je     315 <printf+0xc4>
 2ad:	83 f8 70             	cmp    $0x70,%eax
 2b0:	74 63                	je     315 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 2b2:	83 f8 73             	cmp    $0x73,%eax
 2b5:	0f 84 84 00 00 00    	je     33f <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 2bb:	83 f8 63             	cmp    $0x63,%eax
 2be:	0f 84 ad 00 00 00    	je     371 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 2c4:	83 f8 25             	cmp    $0x25,%eax
 2c7:	0f 84 c2 00 00 00    	je     38f <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 2cd:	ba 25 00 00 00       	mov    $0x25,%edx
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	e8 e8 fe ff ff       	call   1c2 <putc>
        putc(fd, c);
 2da:	89 fa                	mov    %edi,%edx
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	e8 de fe ff ff       	call   1c2 <putc>
      }
      state = 0;
 2e4:	be 00 00 00 00       	mov    $0x0,%esi
 2e9:	eb 96                	jmp    281 <printf+0x30>
        printint(fd, *ap, 10, 1);
 2eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ee:	8b 17                	mov    (%edi),%edx
 2f0:	83 ec 0c             	sub    $0xc,%esp
 2f3:	6a 01                	push   $0x1
 2f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	e8 da fe ff ff       	call   1dc <printint>
        ap++;
 302:	83 c7 04             	add    $0x4,%edi
 305:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 308:	83 c4 10             	add    $0x10,%esp
      state = 0;
 30b:	be 00 00 00 00       	mov    $0x0,%esi
 310:	e9 6c ff ff ff       	jmp    281 <printf+0x30>
        printint(fd, *ap, 16, 0);
 315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 318:	8b 17                	mov    (%edi),%edx
 31a:	83 ec 0c             	sub    $0xc,%esp
 31d:	6a 00                	push   $0x0
 31f:	b9 10 00 00 00       	mov    $0x10,%ecx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	e8 b0 fe ff ff       	call   1dc <printint>
        ap++;
 32c:	83 c7 04             	add    $0x4,%edi
 32f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 332:	83 c4 10             	add    $0x10,%esp
      state = 0;
 335:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 33a:	e9 42 ff ff ff       	jmp    281 <printf+0x30>
        s = (char*)*ap;
 33f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 342:	8b 30                	mov    (%eax),%esi
        ap++;
 344:	83 c0 04             	add    $0x4,%eax
 347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 34a:	85 f6                	test   %esi,%esi
 34c:	75 13                	jne    361 <printf+0x110>
          s = "(null)";
 34e:	be fc 03 00 00       	mov    $0x3fc,%esi
 353:	eb 0c                	jmp    361 <printf+0x110>
          putc(fd, *s);
 355:	0f be d2             	movsbl %dl,%edx
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	e8 62 fe ff ff       	call   1c2 <putc>
          s++;
 360:	46                   	inc    %esi
        while(*s != 0){
 361:	8a 16                	mov    (%esi),%dl
 363:	84 d2                	test   %dl,%dl
 365:	75 ee                	jne    355 <printf+0x104>
      state = 0;
 367:	be 00 00 00 00       	mov    $0x0,%esi
 36c:	e9 10 ff ff ff       	jmp    281 <printf+0x30>
        putc(fd, *ap);
 371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 374:	0f be 17             	movsbl (%edi),%edx
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	e8 43 fe ff ff       	call   1c2 <putc>
        ap++;
 37f:	83 c7 04             	add    $0x4,%edi
 382:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 385:	be 00 00 00 00       	mov    $0x0,%esi
 38a:	e9 f2 fe ff ff       	jmp    281 <printf+0x30>
        putc(fd, c);
 38f:	89 fa                	mov    %edi,%edx
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	e8 29 fe ff ff       	call   1c2 <putc>
      state = 0;
 399:	be 00 00 00 00       	mov    $0x0,%esi
 39e:	e9 de fe ff ff       	jmp    281 <printf+0x30>
    }
  }
}
 3a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a6:	5b                   	pop    %ebx
 3a7:	5e                   	pop    %esi
 3a8:	5f                   	pop    %edi
 3a9:	5d                   	pop    %ebp
 3aa:	c3                   	ret    
