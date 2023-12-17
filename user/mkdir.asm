
mkdir:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
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
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 01                	mov    (%ecx),%eax
  1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1d:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  20:	83 f8 01             	cmp    $0x1,%eax
  23:	7e 21                	jle    46 <main+0x46>
    printf(2, "Usage: mkdir files...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  25:	bb 01 00 00 00       	mov    $0x1,%ebx
  2a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  2d:	7d 46                	jge    75 <main+0x75>
    if(mkdir(argv[i]) < 0){
  2f:	8d 34 9f             	lea    (%edi,%ebx,4),%esi
  32:	83 ec 0c             	sub    $0xc,%esp
  35:	ff 36                	pushl  (%esi)
  37:	e8 b3 00 00 00       	call   ef <mkdir>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	78 1e                	js     61 <main+0x61>
  for(i = 1; i < argc; i++){
  43:	43                   	inc    %ebx
  44:	eb e4                	jmp    2a <main+0x2a>
    printf(2, "Usage: mkdir files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 30 03 00 00       	push   $0x330
  4e:	6a 02                	push   $0x2
  50:	e8 81 01 00 00       	call   1d6 <printf>
    exit(0);
  55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  5c:	e8 26 00 00 00       	call   87 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  61:	83 ec 04             	sub    $0x4,%esp
  64:	ff 36                	pushl  (%esi)
  66:	68 47 03 00 00       	push   $0x347
  6b:	6a 02                	push   $0x2
  6d:	e8 64 01 00 00       	call   1d6 <printf>
      break;
  72:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit(0);
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	6a 00                	push   $0x0
  7a:	e8 08 00 00 00       	call   87 <exit>

0000007f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  7f:	b8 01 00 00 00       	mov    $0x1,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <exit>:
SYSCALL(exit)
  87:	b8 02 00 00 00       	mov    $0x2,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <wait>:
SYSCALL(wait)
  8f:	b8 03 00 00 00       	mov    $0x3,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <pipe>:
SYSCALL(pipe)
  97:	b8 04 00 00 00       	mov    $0x4,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <read>:
SYSCALL(read)
  9f:	b8 05 00 00 00       	mov    $0x5,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <write>:
SYSCALL(write)
  a7:	b8 10 00 00 00       	mov    $0x10,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <close>:
SYSCALL(close)
  af:	b8 15 00 00 00       	mov    $0x15,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <kill>:
SYSCALL(kill)
  b7:	b8 06 00 00 00       	mov    $0x6,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <exec>:
SYSCALL(exec)
  bf:	b8 07 00 00 00       	mov    $0x7,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <open>:
SYSCALL(open)
  c7:	b8 0f 00 00 00       	mov    $0xf,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <mknod>:
SYSCALL(mknod)
  cf:	b8 11 00 00 00       	mov    $0x11,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <unlink>:
SYSCALL(unlink)
  d7:	b8 12 00 00 00       	mov    $0x12,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <fstat>:
SYSCALL(fstat)
  df:	b8 08 00 00 00       	mov    $0x8,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <link>:
SYSCALL(link)
  e7:	b8 13 00 00 00       	mov    $0x13,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <mkdir>:
SYSCALL(mkdir)
  ef:	b8 14 00 00 00       	mov    $0x14,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <chdir>:
SYSCALL(chdir)
  f7:	b8 09 00 00 00       	mov    $0x9,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    

000000ff <dup>:
SYSCALL(dup)
  ff:	b8 0a 00 00 00       	mov    $0xa,%eax
 104:	cd 40                	int    $0x40
 106:	c3                   	ret    

00000107 <dup2>:
SYSCALL(dup2)
 107:	b8 17 00 00 00       	mov    $0x17,%eax
 10c:	cd 40                	int    $0x40
 10e:	c3                   	ret    

0000010f <getpid>:
SYSCALL(getpid)
 10f:	b8 0b 00 00 00       	mov    $0xb,%eax
 114:	cd 40                	int    $0x40
 116:	c3                   	ret    

00000117 <sbrk>:
SYSCALL(sbrk)
 117:	b8 0c 00 00 00       	mov    $0xc,%eax
 11c:	cd 40                	int    $0x40
 11e:	c3                   	ret    

0000011f <sleep>:
SYSCALL(sleep)
 11f:	b8 0d 00 00 00       	mov    $0xd,%eax
 124:	cd 40                	int    $0x40
 126:	c3                   	ret    

00000127 <uptime>:
SYSCALL(uptime)
 127:	b8 0e 00 00 00       	mov    $0xe,%eax
 12c:	cd 40                	int    $0x40
 12e:	c3                   	ret    

0000012f <date>:
SYSCALL(date)
 12f:	b8 16 00 00 00       	mov    $0x16,%eax
 134:	cd 40                	int    $0x40
 136:	c3                   	ret    

00000137 <getprio>:
SYSCALL(getprio)
 137:	b8 18 00 00 00       	mov    $0x18,%eax
 13c:	cd 40                	int    $0x40
 13e:	c3                   	ret    

0000013f <setprio>:
SYSCALL(setprio)
 13f:	b8 19 00 00 00       	mov    $0x19,%eax
 144:	cd 40                	int    $0x40
 146:	c3                   	ret    

00000147 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 1c             	sub    $0x1c,%esp
 14d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 150:	6a 01                	push   $0x1
 152:	8d 55 f4             	lea    -0xc(%ebp),%edx
 155:	52                   	push   %edx
 156:	50                   	push   %eax
 157:	e8 4b ff ff ff       	call   a7 <write>
}
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	c9                   	leave  
 160:	c3                   	ret    

00000161 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	57                   	push   %edi
 165:	56                   	push   %esi
 166:	53                   	push   %ebx
 167:	83 ec 2c             	sub    $0x2c,%esp
 16a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 16d:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 16f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 173:	74 04                	je     179 <printint+0x18>
 175:	85 d2                	test   %edx,%edx
 177:	78 3a                	js     1b3 <printint+0x52>
  neg = 0;
 179:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 180:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 185:	89 f0                	mov    %esi,%eax
 187:	ba 00 00 00 00       	mov    $0x0,%edx
 18c:	f7 f1                	div    %ecx
 18e:	89 df                	mov    %ebx,%edi
 190:	43                   	inc    %ebx
 191:	8a 92 6c 03 00 00    	mov    0x36c(%edx),%dl
 197:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 19b:	89 f2                	mov    %esi,%edx
 19d:	89 c6                	mov    %eax,%esi
 19f:	39 d1                	cmp    %edx,%ecx
 1a1:	76 e2                	jbe    185 <printint+0x24>
  if(neg)
 1a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1a7:	74 22                	je     1cb <printint+0x6a>
    buf[i++] = '-';
 1a9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1ae:	8d 5f 02             	lea    0x2(%edi),%ebx
 1b1:	eb 18                	jmp    1cb <printint+0x6a>
    x = -xx;
 1b3:	f7 de                	neg    %esi
    neg = 1;
 1b5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1bc:	eb c2                	jmp    180 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1be:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c6:	e8 7c ff ff ff       	call   147 <putc>
  while(--i >= 0)
 1cb:	4b                   	dec    %ebx
 1cc:	79 f0                	jns    1be <printint+0x5d>
}
 1ce:	83 c4 2c             	add    $0x2c,%esp
 1d1:	5b                   	pop    %ebx
 1d2:	5e                   	pop    %esi
 1d3:	5f                   	pop    %edi
 1d4:	5d                   	pop    %ebp
 1d5:	c3                   	ret    

000001d6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1d6:	f3 0f 1e fb          	endbr32 
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	57                   	push   %edi
 1de:	56                   	push   %esi
 1df:	53                   	push   %ebx
 1e0:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1e3:	8d 45 10             	lea    0x10(%ebp),%eax
 1e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e9:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ee:	bb 00 00 00 00       	mov    $0x0,%ebx
 1f3:	eb 12                	jmp    207 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1f5:	89 fa                	mov    %edi,%edx
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	e8 48 ff ff ff       	call   147 <putc>
 1ff:	eb 05                	jmp    206 <printf+0x30>
      }
    } else if(state == '%'){
 201:	83 fe 25             	cmp    $0x25,%esi
 204:	74 22                	je     228 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 206:	43                   	inc    %ebx
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	8a 04 18             	mov    (%eax,%ebx,1),%al
 20d:	84 c0                	test   %al,%al
 20f:	0f 84 13 01 00 00    	je     328 <printf+0x152>
    c = fmt[i] & 0xff;
 215:	0f be f8             	movsbl %al,%edi
 218:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 21b:	85 f6                	test   %esi,%esi
 21d:	75 e2                	jne    201 <printf+0x2b>
      if(c == '%'){
 21f:	83 f8 25             	cmp    $0x25,%eax
 222:	75 d1                	jne    1f5 <printf+0x1f>
        state = '%';
 224:	89 c6                	mov    %eax,%esi
 226:	eb de                	jmp    206 <printf+0x30>
      if(c == 'd'){
 228:	83 f8 64             	cmp    $0x64,%eax
 22b:	74 43                	je     270 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 22d:	83 f8 78             	cmp    $0x78,%eax
 230:	74 68                	je     29a <printf+0xc4>
 232:	83 f8 70             	cmp    $0x70,%eax
 235:	74 63                	je     29a <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 237:	83 f8 73             	cmp    $0x73,%eax
 23a:	0f 84 84 00 00 00    	je     2c4 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 240:	83 f8 63             	cmp    $0x63,%eax
 243:	0f 84 ad 00 00 00    	je     2f6 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 249:	83 f8 25             	cmp    $0x25,%eax
 24c:	0f 84 c2 00 00 00    	je     314 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 252:	ba 25 00 00 00       	mov    $0x25,%edx
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	e8 e8 fe ff ff       	call   147 <putc>
        putc(fd, c);
 25f:	89 fa                	mov    %edi,%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	e8 de fe ff ff       	call   147 <putc>
      }
      state = 0;
 269:	be 00 00 00 00       	mov    $0x0,%esi
 26e:	eb 96                	jmp    206 <printf+0x30>
        printint(fd, *ap, 10, 1);
 270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 273:	8b 17                	mov    (%edi),%edx
 275:	83 ec 0c             	sub    $0xc,%esp
 278:	6a 01                	push   $0x1
 27a:	b9 0a 00 00 00       	mov    $0xa,%ecx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	e8 da fe ff ff       	call   161 <printint>
        ap++;
 287:	83 c7 04             	add    $0x4,%edi
 28a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 28d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 290:	be 00 00 00 00       	mov    $0x0,%esi
 295:	e9 6c ff ff ff       	jmp    206 <printf+0x30>
        printint(fd, *ap, 16, 0);
 29a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29d:	8b 17                	mov    (%edi),%edx
 29f:	83 ec 0c             	sub    $0xc,%esp
 2a2:	6a 00                	push   $0x0
 2a4:	b9 10 00 00 00       	mov    $0x10,%ecx
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	e8 b0 fe ff ff       	call   161 <printint>
        ap++;
 2b1:	83 c7 04             	add    $0x4,%edi
 2b4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2b7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2ba:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2bf:	e9 42 ff ff ff       	jmp    206 <printf+0x30>
        s = (char*)*ap;
 2c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2c7:	8b 30                	mov    (%eax),%esi
        ap++;
 2c9:	83 c0 04             	add    $0x4,%eax
 2cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2cf:	85 f6                	test   %esi,%esi
 2d1:	75 13                	jne    2e6 <printf+0x110>
          s = "(null)";
 2d3:	be 63 03 00 00       	mov    $0x363,%esi
 2d8:	eb 0c                	jmp    2e6 <printf+0x110>
          putc(fd, *s);
 2da:	0f be d2             	movsbl %dl,%edx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	e8 62 fe ff ff       	call   147 <putc>
          s++;
 2e5:	46                   	inc    %esi
        while(*s != 0){
 2e6:	8a 16                	mov    (%esi),%dl
 2e8:	84 d2                	test   %dl,%dl
 2ea:	75 ee                	jne    2da <printf+0x104>
      state = 0;
 2ec:	be 00 00 00 00       	mov    $0x0,%esi
 2f1:	e9 10 ff ff ff       	jmp    206 <printf+0x30>
        putc(fd, *ap);
 2f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f9:	0f be 17             	movsbl (%edi),%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	e8 43 fe ff ff       	call   147 <putc>
        ap++;
 304:	83 c7 04             	add    $0x4,%edi
 307:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 30a:	be 00 00 00 00       	mov    $0x0,%esi
 30f:	e9 f2 fe ff ff       	jmp    206 <printf+0x30>
        putc(fd, c);
 314:	89 fa                	mov    %edi,%edx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	e8 29 fe ff ff       	call   147 <putc>
      state = 0;
 31e:	be 00 00 00 00       	mov    $0x0,%esi
 323:	e9 de fe ff ff       	jmp    206 <printf+0x30>
    }
  }
}
 328:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32b:	5b                   	pop    %ebx
 32c:	5e                   	pop    %esi
 32d:	5f                   	pop    %edi
 32e:	5d                   	pop    %ebp
 32f:	c3                   	ret    
