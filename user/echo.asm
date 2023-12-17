
echo:     formato del fichero elf32-i386


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
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1d:	b8 01 00 00 00       	mov    $0x1,%eax
  22:	eb 1a                	jmp    3e <main+0x3e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  24:	ba 0c 03 00 00       	mov    $0x30c,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 10 03 00 00       	push   $0x310
  32:	6a 01                	push   $0x1
  34:	e8 78 01 00 00       	call   1b1 <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba 0e 03 00 00       	mov    $0x30e,%edx
  4e:	eb d9                	jmp    29 <main+0x29>
  exit(0);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	6a 00                	push   $0x0
  55:	e8 08 00 00 00       	call   62 <exit>

0000005a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  5a:	b8 01 00 00 00       	mov    $0x1,%eax
  5f:	cd 40                	int    $0x40
  61:	c3                   	ret    

00000062 <exit>:
SYSCALL(exit)
  62:	b8 02 00 00 00       	mov    $0x2,%eax
  67:	cd 40                	int    $0x40
  69:	c3                   	ret    

0000006a <wait>:
SYSCALL(wait)
  6a:	b8 03 00 00 00       	mov    $0x3,%eax
  6f:	cd 40                	int    $0x40
  71:	c3                   	ret    

00000072 <pipe>:
SYSCALL(pipe)
  72:	b8 04 00 00 00       	mov    $0x4,%eax
  77:	cd 40                	int    $0x40
  79:	c3                   	ret    

0000007a <read>:
SYSCALL(read)
  7a:	b8 05 00 00 00       	mov    $0x5,%eax
  7f:	cd 40                	int    $0x40
  81:	c3                   	ret    

00000082 <write>:
SYSCALL(write)
  82:	b8 10 00 00 00       	mov    $0x10,%eax
  87:	cd 40                	int    $0x40
  89:	c3                   	ret    

0000008a <close>:
SYSCALL(close)
  8a:	b8 15 00 00 00       	mov    $0x15,%eax
  8f:	cd 40                	int    $0x40
  91:	c3                   	ret    

00000092 <kill>:
SYSCALL(kill)
  92:	b8 06 00 00 00       	mov    $0x6,%eax
  97:	cd 40                	int    $0x40
  99:	c3                   	ret    

0000009a <exec>:
SYSCALL(exec)
  9a:	b8 07 00 00 00       	mov    $0x7,%eax
  9f:	cd 40                	int    $0x40
  a1:	c3                   	ret    

000000a2 <open>:
SYSCALL(open)
  a2:	b8 0f 00 00 00       	mov    $0xf,%eax
  a7:	cd 40                	int    $0x40
  a9:	c3                   	ret    

000000aa <mknod>:
SYSCALL(mknod)
  aa:	b8 11 00 00 00       	mov    $0x11,%eax
  af:	cd 40                	int    $0x40
  b1:	c3                   	ret    

000000b2 <unlink>:
SYSCALL(unlink)
  b2:	b8 12 00 00 00       	mov    $0x12,%eax
  b7:	cd 40                	int    $0x40
  b9:	c3                   	ret    

000000ba <fstat>:
SYSCALL(fstat)
  ba:	b8 08 00 00 00       	mov    $0x8,%eax
  bf:	cd 40                	int    $0x40
  c1:	c3                   	ret    

000000c2 <link>:
SYSCALL(link)
  c2:	b8 13 00 00 00       	mov    $0x13,%eax
  c7:	cd 40                	int    $0x40
  c9:	c3                   	ret    

000000ca <mkdir>:
SYSCALL(mkdir)
  ca:	b8 14 00 00 00       	mov    $0x14,%eax
  cf:	cd 40                	int    $0x40
  d1:	c3                   	ret    

000000d2 <chdir>:
SYSCALL(chdir)
  d2:	b8 09 00 00 00       	mov    $0x9,%eax
  d7:	cd 40                	int    $0x40
  d9:	c3                   	ret    

000000da <dup>:
SYSCALL(dup)
  da:	b8 0a 00 00 00       	mov    $0xa,%eax
  df:	cd 40                	int    $0x40
  e1:	c3                   	ret    

000000e2 <dup2>:
SYSCALL(dup2)
  e2:	b8 17 00 00 00       	mov    $0x17,%eax
  e7:	cd 40                	int    $0x40
  e9:	c3                   	ret    

000000ea <getpid>:
SYSCALL(getpid)
  ea:	b8 0b 00 00 00       	mov    $0xb,%eax
  ef:	cd 40                	int    $0x40
  f1:	c3                   	ret    

000000f2 <sbrk>:
SYSCALL(sbrk)
  f2:	b8 0c 00 00 00       	mov    $0xc,%eax
  f7:	cd 40                	int    $0x40
  f9:	c3                   	ret    

000000fa <sleep>:
SYSCALL(sleep)
  fa:	b8 0d 00 00 00       	mov    $0xd,%eax
  ff:	cd 40                	int    $0x40
 101:	c3                   	ret    

00000102 <uptime>:
SYSCALL(uptime)
 102:	b8 0e 00 00 00       	mov    $0xe,%eax
 107:	cd 40                	int    $0x40
 109:	c3                   	ret    

0000010a <date>:
SYSCALL(date)
 10a:	b8 16 00 00 00       	mov    $0x16,%eax
 10f:	cd 40                	int    $0x40
 111:	c3                   	ret    

00000112 <getprio>:
SYSCALL(getprio)
 112:	b8 18 00 00 00       	mov    $0x18,%eax
 117:	cd 40                	int    $0x40
 119:	c3                   	ret    

0000011a <setprio>:
SYSCALL(setprio)
 11a:	b8 19 00 00 00       	mov    $0x19,%eax
 11f:	cd 40                	int    $0x40
 121:	c3                   	ret    

00000122 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 1c             	sub    $0x1c,%esp
 128:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 12b:	6a 01                	push   $0x1
 12d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 130:	52                   	push   %edx
 131:	50                   	push   %eax
 132:	e8 4b ff ff ff       	call   82 <write>
}
 137:	83 c4 10             	add    $0x10,%esp
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	56                   	push   %esi
 141:	53                   	push   %ebx
 142:	83 ec 2c             	sub    $0x2c,%esp
 145:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 148:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 14a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 14e:	74 04                	je     154 <printint+0x18>
 150:	85 d2                	test   %edx,%edx
 152:	78 3a                	js     18e <printint+0x52>
  neg = 0;
 154:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 15b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 160:	89 f0                	mov    %esi,%eax
 162:	ba 00 00 00 00       	mov    $0x0,%edx
 167:	f7 f1                	div    %ecx
 169:	89 df                	mov    %ebx,%edi
 16b:	43                   	inc    %ebx
 16c:	8a 92 1c 03 00 00    	mov    0x31c(%edx),%dl
 172:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 176:	89 f2                	mov    %esi,%edx
 178:	89 c6                	mov    %eax,%esi
 17a:	39 d1                	cmp    %edx,%ecx
 17c:	76 e2                	jbe    160 <printint+0x24>
  if(neg)
 17e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 182:	74 22                	je     1a6 <printint+0x6a>
    buf[i++] = '-';
 184:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 189:	8d 5f 02             	lea    0x2(%edi),%ebx
 18c:	eb 18                	jmp    1a6 <printint+0x6a>
    x = -xx;
 18e:	f7 de                	neg    %esi
    neg = 1;
 190:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 197:	eb c2                	jmp    15b <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 199:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 19e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1a1:	e8 7c ff ff ff       	call   122 <putc>
  while(--i >= 0)
 1a6:	4b                   	dec    %ebx
 1a7:	79 f0                	jns    199 <printint+0x5d>
}
 1a9:	83 c4 2c             	add    $0x2c,%esp
 1ac:	5b                   	pop    %ebx
 1ad:	5e                   	pop    %esi
 1ae:	5f                   	pop    %edi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1b1:	f3 0f 1e fb          	endbr32 
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	57                   	push   %edi
 1b9:	56                   	push   %esi
 1ba:	53                   	push   %ebx
 1bb:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1be:	8d 45 10             	lea    0x10(%ebp),%eax
 1c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1c4:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1c9:	bb 00 00 00 00       	mov    $0x0,%ebx
 1ce:	eb 12                	jmp    1e2 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1d0:	89 fa                	mov    %edi,%edx
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
 1d5:	e8 48 ff ff ff       	call   122 <putc>
 1da:	eb 05                	jmp    1e1 <printf+0x30>
      }
    } else if(state == '%'){
 1dc:	83 fe 25             	cmp    $0x25,%esi
 1df:	74 22                	je     203 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1e1:	43                   	inc    %ebx
 1e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e5:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1e8:	84 c0                	test   %al,%al
 1ea:	0f 84 13 01 00 00    	je     303 <printf+0x152>
    c = fmt[i] & 0xff;
 1f0:	0f be f8             	movsbl %al,%edi
 1f3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1f6:	85 f6                	test   %esi,%esi
 1f8:	75 e2                	jne    1dc <printf+0x2b>
      if(c == '%'){
 1fa:	83 f8 25             	cmp    $0x25,%eax
 1fd:	75 d1                	jne    1d0 <printf+0x1f>
        state = '%';
 1ff:	89 c6                	mov    %eax,%esi
 201:	eb de                	jmp    1e1 <printf+0x30>
      if(c == 'd'){
 203:	83 f8 64             	cmp    $0x64,%eax
 206:	74 43                	je     24b <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 208:	83 f8 78             	cmp    $0x78,%eax
 20b:	74 68                	je     275 <printf+0xc4>
 20d:	83 f8 70             	cmp    $0x70,%eax
 210:	74 63                	je     275 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 212:	83 f8 73             	cmp    $0x73,%eax
 215:	0f 84 84 00 00 00    	je     29f <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 21b:	83 f8 63             	cmp    $0x63,%eax
 21e:	0f 84 ad 00 00 00    	je     2d1 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 224:	83 f8 25             	cmp    $0x25,%eax
 227:	0f 84 c2 00 00 00    	je     2ef <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 22d:	ba 25 00 00 00       	mov    $0x25,%edx
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	e8 e8 fe ff ff       	call   122 <putc>
        putc(fd, c);
 23a:	89 fa                	mov    %edi,%edx
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	e8 de fe ff ff       	call   122 <putc>
      }
      state = 0;
 244:	be 00 00 00 00       	mov    $0x0,%esi
 249:	eb 96                	jmp    1e1 <printf+0x30>
        printint(fd, *ap, 10, 1);
 24b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 24e:	8b 17                	mov    (%edi),%edx
 250:	83 ec 0c             	sub    $0xc,%esp
 253:	6a 01                	push   $0x1
 255:	b9 0a 00 00 00       	mov    $0xa,%ecx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	e8 da fe ff ff       	call   13c <printint>
        ap++;
 262:	83 c7 04             	add    $0x4,%edi
 265:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 268:	83 c4 10             	add    $0x10,%esp
      state = 0;
 26b:	be 00 00 00 00       	mov    $0x0,%esi
 270:	e9 6c ff ff ff       	jmp    1e1 <printf+0x30>
        printint(fd, *ap, 16, 0);
 275:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 278:	8b 17                	mov    (%edi),%edx
 27a:	83 ec 0c             	sub    $0xc,%esp
 27d:	6a 00                	push   $0x0
 27f:	b9 10 00 00 00       	mov    $0x10,%ecx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	e8 b0 fe ff ff       	call   13c <printint>
        ap++;
 28c:	83 c7 04             	add    $0x4,%edi
 28f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 292:	83 c4 10             	add    $0x10,%esp
      state = 0;
 295:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 29a:	e9 42 ff ff ff       	jmp    1e1 <printf+0x30>
        s = (char*)*ap;
 29f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a2:	8b 30                	mov    (%eax),%esi
        ap++;
 2a4:	83 c0 04             	add    $0x4,%eax
 2a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2aa:	85 f6                	test   %esi,%esi
 2ac:	75 13                	jne    2c1 <printf+0x110>
          s = "(null)";
 2ae:	be 15 03 00 00       	mov    $0x315,%esi
 2b3:	eb 0c                	jmp    2c1 <printf+0x110>
          putc(fd, *s);
 2b5:	0f be d2             	movsbl %dl,%edx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	e8 62 fe ff ff       	call   122 <putc>
          s++;
 2c0:	46                   	inc    %esi
        while(*s != 0){
 2c1:	8a 16                	mov    (%esi),%dl
 2c3:	84 d2                	test   %dl,%dl
 2c5:	75 ee                	jne    2b5 <printf+0x104>
      state = 0;
 2c7:	be 00 00 00 00       	mov    $0x0,%esi
 2cc:	e9 10 ff ff ff       	jmp    1e1 <printf+0x30>
        putc(fd, *ap);
 2d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d4:	0f be 17             	movsbl (%edi),%edx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	e8 43 fe ff ff       	call   122 <putc>
        ap++;
 2df:	83 c7 04             	add    $0x4,%edi
 2e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2e5:	be 00 00 00 00       	mov    $0x0,%esi
 2ea:	e9 f2 fe ff ff       	jmp    1e1 <printf+0x30>
        putc(fd, c);
 2ef:	89 fa                	mov    %edi,%edx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	e8 29 fe ff ff       	call   122 <putc>
      state = 0;
 2f9:	be 00 00 00 00       	mov    $0x0,%esi
 2fe:	e9 de fe ff ff       	jmp    1e1 <printf+0x30>
    }
  }
}
 303:	8d 65 f4             	lea    -0xc(%ebp),%esp
 306:	5b                   	pop    %ebx
 307:	5e                   	pop    %esi
 308:	5f                   	pop    %edi
 309:	5d                   	pop    %ebp
 30a:	c3                   	ret    
