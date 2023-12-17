
tsbrk2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <recursive>:
#include "user.h"

char a[4096] = {0};

int recursive(int v)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 1c             	sub    $0x1c,%esp
  printf (1, ".");
   b:	68 40 03 00 00       	push   $0x340
  10:	6a 01                	push   $0x1
  12:	e8 cd 01 00 00       	call   1e4 <printf>
  volatile int q = v;
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (q > 0)
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	7f 0a                	jg     31 <recursive+0x31>
    return recursive (q+1)+recursive (q+2);
  return 0;
  27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2f:	c9                   	leave  
  30:	c3                   	ret    
    return recursive (q+1)+recursive (q+2);
  31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  34:	83 ec 0c             	sub    $0xc,%esp
  37:	40                   	inc    %eax
  38:	50                   	push   %eax
  39:	e8 c2 ff ff ff       	call   0 <recursive>
  3e:	89 c3                	mov    %eax,%ebx
  40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  43:	83 c0 02             	add    $0x2,%eax
  46:	89 04 24             	mov    %eax,(%esp)
  49:	e8 b2 ff ff ff       	call   0 <recursive>
  4e:	01 d8                	add    %ebx,%eax
  50:	83 c4 10             	add    $0x10,%esp
  53:	eb d7                	jmp    2c <recursive+0x2c>

00000055 <main>:


int
main(int argc, char *argv[])
{
  55:	f3 0f 1e fb          	endbr32 
  59:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  5d:	83 e4 f0             	and    $0xfffffff0,%esp
  60:	ff 71 fc             	pushl  -0x4(%ecx)
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	51                   	push   %ecx
  67:	83 ec 10             	sub    $0x10,%esp
  int i = 1;

  // Llamar recursivamente a recursive
  printf (1, ": %d\n", recursive (i));
  6a:	6a 01                	push   $0x1
  6c:	e8 8f ff ff ff       	call   0 <recursive>
  71:	83 c4 0c             	add    $0xc,%esp
  74:	50                   	push   %eax
  75:	68 42 03 00 00       	push   $0x342
  7a:	6a 01                	push   $0x1
  7c:	e8 63 01 00 00       	call   1e4 <printf>

  exit(0);
  81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  88:	e8 08 00 00 00       	call   95 <exit>

0000008d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  8d:	b8 01 00 00 00       	mov    $0x1,%eax
  92:	cd 40                	int    $0x40
  94:	c3                   	ret    

00000095 <exit>:
SYSCALL(exit)
  95:	b8 02 00 00 00       	mov    $0x2,%eax
  9a:	cd 40                	int    $0x40
  9c:	c3                   	ret    

0000009d <wait>:
SYSCALL(wait)
  9d:	b8 03 00 00 00       	mov    $0x3,%eax
  a2:	cd 40                	int    $0x40
  a4:	c3                   	ret    

000000a5 <pipe>:
SYSCALL(pipe)
  a5:	b8 04 00 00 00       	mov    $0x4,%eax
  aa:	cd 40                	int    $0x40
  ac:	c3                   	ret    

000000ad <read>:
SYSCALL(read)
  ad:	b8 05 00 00 00       	mov    $0x5,%eax
  b2:	cd 40                	int    $0x40
  b4:	c3                   	ret    

000000b5 <write>:
SYSCALL(write)
  b5:	b8 10 00 00 00       	mov    $0x10,%eax
  ba:	cd 40                	int    $0x40
  bc:	c3                   	ret    

000000bd <close>:
SYSCALL(close)
  bd:	b8 15 00 00 00       	mov    $0x15,%eax
  c2:	cd 40                	int    $0x40
  c4:	c3                   	ret    

000000c5 <kill>:
SYSCALL(kill)
  c5:	b8 06 00 00 00       	mov    $0x6,%eax
  ca:	cd 40                	int    $0x40
  cc:	c3                   	ret    

000000cd <exec>:
SYSCALL(exec)
  cd:	b8 07 00 00 00       	mov    $0x7,%eax
  d2:	cd 40                	int    $0x40
  d4:	c3                   	ret    

000000d5 <open>:
SYSCALL(open)
  d5:	b8 0f 00 00 00       	mov    $0xf,%eax
  da:	cd 40                	int    $0x40
  dc:	c3                   	ret    

000000dd <mknod>:
SYSCALL(mknod)
  dd:	b8 11 00 00 00       	mov    $0x11,%eax
  e2:	cd 40                	int    $0x40
  e4:	c3                   	ret    

000000e5 <unlink>:
SYSCALL(unlink)
  e5:	b8 12 00 00 00       	mov    $0x12,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <fstat>:
SYSCALL(fstat)
  ed:	b8 08 00 00 00       	mov    $0x8,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <link>:
SYSCALL(link)
  f5:	b8 13 00 00 00       	mov    $0x13,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <mkdir>:
SYSCALL(mkdir)
  fd:	b8 14 00 00 00       	mov    $0x14,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <chdir>:
SYSCALL(chdir)
 105:	b8 09 00 00 00       	mov    $0x9,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <dup>:
SYSCALL(dup)
 10d:	b8 0a 00 00 00       	mov    $0xa,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret    

00000115 <dup2>:
SYSCALL(dup2)
 115:	b8 17 00 00 00       	mov    $0x17,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret    

0000011d <getpid>:
SYSCALL(getpid)
 11d:	b8 0b 00 00 00       	mov    $0xb,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret    

00000125 <sbrk>:
SYSCALL(sbrk)
 125:	b8 0c 00 00 00       	mov    $0xc,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret    

0000012d <sleep>:
SYSCALL(sleep)
 12d:	b8 0d 00 00 00       	mov    $0xd,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret    

00000135 <uptime>:
SYSCALL(uptime)
 135:	b8 0e 00 00 00       	mov    $0xe,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret    

0000013d <date>:
SYSCALL(date)
 13d:	b8 16 00 00 00       	mov    $0x16,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret    

00000145 <getprio>:
SYSCALL(getprio)
 145:	b8 18 00 00 00       	mov    $0x18,%eax
 14a:	cd 40                	int    $0x40
 14c:	c3                   	ret    

0000014d <setprio>:
SYSCALL(setprio)
 14d:	b8 19 00 00 00       	mov    $0x19,%eax
 152:	cd 40                	int    $0x40
 154:	c3                   	ret    

00000155 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
 158:	83 ec 1c             	sub    $0x1c,%esp
 15b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 15e:	6a 01                	push   $0x1
 160:	8d 55 f4             	lea    -0xc(%ebp),%edx
 163:	52                   	push   %edx
 164:	50                   	push   %eax
 165:	e8 4b ff ff ff       	call   b5 <write>
}
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	c9                   	leave  
 16e:	c3                   	ret    

0000016f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	57                   	push   %edi
 173:	56                   	push   %esi
 174:	53                   	push   %ebx
 175:	83 ec 2c             	sub    $0x2c,%esp
 178:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 17b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 17d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 181:	74 04                	je     187 <printint+0x18>
 183:	85 d2                	test   %edx,%edx
 185:	78 3a                	js     1c1 <printint+0x52>
  neg = 0;
 187:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 18e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 193:	89 f0                	mov    %esi,%eax
 195:	ba 00 00 00 00       	mov    $0x0,%edx
 19a:	f7 f1                	div    %ecx
 19c:	89 df                	mov    %ebx,%edi
 19e:	43                   	inc    %ebx
 19f:	8a 92 50 03 00 00    	mov    0x350(%edx),%dl
 1a5:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1a9:	89 f2                	mov    %esi,%edx
 1ab:	89 c6                	mov    %eax,%esi
 1ad:	39 d1                	cmp    %edx,%ecx
 1af:	76 e2                	jbe    193 <printint+0x24>
  if(neg)
 1b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1b5:	74 22                	je     1d9 <printint+0x6a>
    buf[i++] = '-';
 1b7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1bc:	8d 5f 02             	lea    0x2(%edi),%ebx
 1bf:	eb 18                	jmp    1d9 <printint+0x6a>
    x = -xx;
 1c1:	f7 de                	neg    %esi
    neg = 1;
 1c3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1ca:	eb c2                	jmp    18e <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1cc:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1d4:	e8 7c ff ff ff       	call   155 <putc>
  while(--i >= 0)
 1d9:	4b                   	dec    %ebx
 1da:	79 f0                	jns    1cc <printint+0x5d>
}
 1dc:	83 c4 2c             	add    $0x2c,%esp
 1df:	5b                   	pop    %ebx
 1e0:	5e                   	pop    %esi
 1e1:	5f                   	pop    %edi
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    

000001e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1e4:	f3 0f 1e fb          	endbr32 
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	57                   	push   %edi
 1ec:	56                   	push   %esi
 1ed:	53                   	push   %ebx
 1ee:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1f1:	8d 45 10             	lea    0x10(%ebp),%eax
 1f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1f7:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1fc:	bb 00 00 00 00       	mov    $0x0,%ebx
 201:	eb 12                	jmp    215 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 203:	89 fa                	mov    %edi,%edx
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	e8 48 ff ff ff       	call   155 <putc>
 20d:	eb 05                	jmp    214 <printf+0x30>
      }
    } else if(state == '%'){
 20f:	83 fe 25             	cmp    $0x25,%esi
 212:	74 22                	je     236 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 214:	43                   	inc    %ebx
 215:	8b 45 0c             	mov    0xc(%ebp),%eax
 218:	8a 04 18             	mov    (%eax,%ebx,1),%al
 21b:	84 c0                	test   %al,%al
 21d:	0f 84 13 01 00 00    	je     336 <printf+0x152>
    c = fmt[i] & 0xff;
 223:	0f be f8             	movsbl %al,%edi
 226:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 229:	85 f6                	test   %esi,%esi
 22b:	75 e2                	jne    20f <printf+0x2b>
      if(c == '%'){
 22d:	83 f8 25             	cmp    $0x25,%eax
 230:	75 d1                	jne    203 <printf+0x1f>
        state = '%';
 232:	89 c6                	mov    %eax,%esi
 234:	eb de                	jmp    214 <printf+0x30>
      if(c == 'd'){
 236:	83 f8 64             	cmp    $0x64,%eax
 239:	74 43                	je     27e <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 23b:	83 f8 78             	cmp    $0x78,%eax
 23e:	74 68                	je     2a8 <printf+0xc4>
 240:	83 f8 70             	cmp    $0x70,%eax
 243:	74 63                	je     2a8 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 245:	83 f8 73             	cmp    $0x73,%eax
 248:	0f 84 84 00 00 00    	je     2d2 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 24e:	83 f8 63             	cmp    $0x63,%eax
 251:	0f 84 ad 00 00 00    	je     304 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 257:	83 f8 25             	cmp    $0x25,%eax
 25a:	0f 84 c2 00 00 00    	je     322 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 260:	ba 25 00 00 00       	mov    $0x25,%edx
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	e8 e8 fe ff ff       	call   155 <putc>
        putc(fd, c);
 26d:	89 fa                	mov    %edi,%edx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	e8 de fe ff ff       	call   155 <putc>
      }
      state = 0;
 277:	be 00 00 00 00       	mov    $0x0,%esi
 27c:	eb 96                	jmp    214 <printf+0x30>
        printint(fd, *ap, 10, 1);
 27e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 281:	8b 17                	mov    (%edi),%edx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	6a 01                	push   $0x1
 288:	b9 0a 00 00 00       	mov    $0xa,%ecx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	e8 da fe ff ff       	call   16f <printint>
        ap++;
 295:	83 c7 04             	add    $0x4,%edi
 298:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 29b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 29e:	be 00 00 00 00       	mov    $0x0,%esi
 2a3:	e9 6c ff ff ff       	jmp    214 <printf+0x30>
        printint(fd, *ap, 16, 0);
 2a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2ab:	8b 17                	mov    (%edi),%edx
 2ad:	83 ec 0c             	sub    $0xc,%esp
 2b0:	6a 00                	push   $0x0
 2b2:	b9 10 00 00 00       	mov    $0x10,%ecx
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	e8 b0 fe ff ff       	call   16f <printint>
        ap++;
 2bf:	83 c7 04             	add    $0x4,%edi
 2c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2c5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2c8:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2cd:	e9 42 ff ff ff       	jmp    214 <printf+0x30>
        s = (char*)*ap;
 2d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2d5:	8b 30                	mov    (%eax),%esi
        ap++;
 2d7:	83 c0 04             	add    $0x4,%eax
 2da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2dd:	85 f6                	test   %esi,%esi
 2df:	75 13                	jne    2f4 <printf+0x110>
          s = "(null)";
 2e1:	be 48 03 00 00       	mov    $0x348,%esi
 2e6:	eb 0c                	jmp    2f4 <printf+0x110>
          putc(fd, *s);
 2e8:	0f be d2             	movsbl %dl,%edx
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	e8 62 fe ff ff       	call   155 <putc>
          s++;
 2f3:	46                   	inc    %esi
        while(*s != 0){
 2f4:	8a 16                	mov    (%esi),%dl
 2f6:	84 d2                	test   %dl,%dl
 2f8:	75 ee                	jne    2e8 <printf+0x104>
      state = 0;
 2fa:	be 00 00 00 00       	mov    $0x0,%esi
 2ff:	e9 10 ff ff ff       	jmp    214 <printf+0x30>
        putc(fd, *ap);
 304:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 307:	0f be 17             	movsbl (%edi),%edx
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	e8 43 fe ff ff       	call   155 <putc>
        ap++;
 312:	83 c7 04             	add    $0x4,%edi
 315:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 318:	be 00 00 00 00       	mov    $0x0,%esi
 31d:	e9 f2 fe ff ff       	jmp    214 <printf+0x30>
        putc(fd, c);
 322:	89 fa                	mov    %edi,%edx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	e8 29 fe ff ff       	call   155 <putc>
      state = 0;
 32c:	be 00 00 00 00       	mov    $0x0,%esi
 331:	e9 de fe ff ff       	jmp    214 <printf+0x30>
    }
  }
}
 336:	8d 65 f4             	lea    -0xc(%ebp),%esp
 339:	5b                   	pop    %ebx
 33a:	5e                   	pop    %esi
 33b:	5f                   	pop    %edi
 33c:	5d                   	pop    %ebp
 33d:	c3                   	ret    
