
tsbrk3:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "fcntl.h"
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
  14:	83 ec 14             	sub    $0x14,%esp
  int fh = open ("README", O_RDONLY);
  17:	6a 00                	push   $0x0
  19:	68 28 03 00 00       	push   $0x328
  1e:	e8 9b 00 00 00       	call   be <open>
  23:	89 c3                	mov    %eax,%ebx

  char* a = sbrk (15000);
  25:	c7 04 24 98 3a 00 00 	movl   $0x3a98,(%esp)
  2c:	e8 dd 00 00 00       	call   10e <sbrk>

  read (fh, a+8192, 50);
  31:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  37:	83 c4 0c             	add    $0xc,%esp
  3a:	6a 32                	push   $0x32
  3c:	56                   	push   %esi
  3d:	53                   	push   %ebx
  3e:	e8 53 00 00 00       	call   96 <read>

  // Debe imprimir los 50 primeros caracteres de README
  printf (1, "Debe imprimir los 50 primeros caracteres de README:\n");
  43:	83 c4 08             	add    $0x8,%esp
  46:	68 34 03 00 00       	push   $0x334
  4b:	6a 01                	push   $0x1
  4d:	e8 7b 01 00 00       	call   1cd <printf>
  printf (1, "%s\n", a+8192);
  52:	83 c4 0c             	add    $0xc,%esp
  55:	56                   	push   %esi
  56:	68 2f 03 00 00       	push   $0x32f
  5b:	6a 01                	push   $0x1
  5d:	e8 6b 01 00 00       	call   1cd <printf>

  close (fh);
  62:	89 1c 24             	mov    %ebx,(%esp)
  65:	e8 3c 00 00 00       	call   a6 <close>

  exit(0);
  6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  71:	e8 08 00 00 00       	call   7e <exit>

00000076 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  76:	b8 01 00 00 00       	mov    $0x1,%eax
  7b:	cd 40                	int    $0x40
  7d:	c3                   	ret    

0000007e <exit>:
SYSCALL(exit)
  7e:	b8 02 00 00 00       	mov    $0x2,%eax
  83:	cd 40                	int    $0x40
  85:	c3                   	ret    

00000086 <wait>:
SYSCALL(wait)
  86:	b8 03 00 00 00       	mov    $0x3,%eax
  8b:	cd 40                	int    $0x40
  8d:	c3                   	ret    

0000008e <pipe>:
SYSCALL(pipe)
  8e:	b8 04 00 00 00       	mov    $0x4,%eax
  93:	cd 40                	int    $0x40
  95:	c3                   	ret    

00000096 <read>:
SYSCALL(read)
  96:	b8 05 00 00 00       	mov    $0x5,%eax
  9b:	cd 40                	int    $0x40
  9d:	c3                   	ret    

0000009e <write>:
SYSCALL(write)
  9e:	b8 10 00 00 00       	mov    $0x10,%eax
  a3:	cd 40                	int    $0x40
  a5:	c3                   	ret    

000000a6 <close>:
SYSCALL(close)
  a6:	b8 15 00 00 00       	mov    $0x15,%eax
  ab:	cd 40                	int    $0x40
  ad:	c3                   	ret    

000000ae <kill>:
SYSCALL(kill)
  ae:	b8 06 00 00 00       	mov    $0x6,%eax
  b3:	cd 40                	int    $0x40
  b5:	c3                   	ret    

000000b6 <exec>:
SYSCALL(exec)
  b6:	b8 07 00 00 00       	mov    $0x7,%eax
  bb:	cd 40                	int    $0x40
  bd:	c3                   	ret    

000000be <open>:
SYSCALL(open)
  be:	b8 0f 00 00 00       	mov    $0xf,%eax
  c3:	cd 40                	int    $0x40
  c5:	c3                   	ret    

000000c6 <mknod>:
SYSCALL(mknod)
  c6:	b8 11 00 00 00       	mov    $0x11,%eax
  cb:	cd 40                	int    $0x40
  cd:	c3                   	ret    

000000ce <unlink>:
SYSCALL(unlink)
  ce:	b8 12 00 00 00       	mov    $0x12,%eax
  d3:	cd 40                	int    $0x40
  d5:	c3                   	ret    

000000d6 <fstat>:
SYSCALL(fstat)
  d6:	b8 08 00 00 00       	mov    $0x8,%eax
  db:	cd 40                	int    $0x40
  dd:	c3                   	ret    

000000de <link>:
SYSCALL(link)
  de:	b8 13 00 00 00       	mov    $0x13,%eax
  e3:	cd 40                	int    $0x40
  e5:	c3                   	ret    

000000e6 <mkdir>:
SYSCALL(mkdir)
  e6:	b8 14 00 00 00       	mov    $0x14,%eax
  eb:	cd 40                	int    $0x40
  ed:	c3                   	ret    

000000ee <chdir>:
SYSCALL(chdir)
  ee:	b8 09 00 00 00       	mov    $0x9,%eax
  f3:	cd 40                	int    $0x40
  f5:	c3                   	ret    

000000f6 <dup>:
SYSCALL(dup)
  f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  fb:	cd 40                	int    $0x40
  fd:	c3                   	ret    

000000fe <dup2>:
SYSCALL(dup2)
  fe:	b8 17 00 00 00       	mov    $0x17,%eax
 103:	cd 40                	int    $0x40
 105:	c3                   	ret    

00000106 <getpid>:
SYSCALL(getpid)
 106:	b8 0b 00 00 00       	mov    $0xb,%eax
 10b:	cd 40                	int    $0x40
 10d:	c3                   	ret    

0000010e <sbrk>:
SYSCALL(sbrk)
 10e:	b8 0c 00 00 00       	mov    $0xc,%eax
 113:	cd 40                	int    $0x40
 115:	c3                   	ret    

00000116 <sleep>:
SYSCALL(sleep)
 116:	b8 0d 00 00 00       	mov    $0xd,%eax
 11b:	cd 40                	int    $0x40
 11d:	c3                   	ret    

0000011e <uptime>:
SYSCALL(uptime)
 11e:	b8 0e 00 00 00       	mov    $0xe,%eax
 123:	cd 40                	int    $0x40
 125:	c3                   	ret    

00000126 <date>:
SYSCALL(date)
 126:	b8 16 00 00 00       	mov    $0x16,%eax
 12b:	cd 40                	int    $0x40
 12d:	c3                   	ret    

0000012e <getprio>:
SYSCALL(getprio)
 12e:	b8 18 00 00 00       	mov    $0x18,%eax
 133:	cd 40                	int    $0x40
 135:	c3                   	ret    

00000136 <setprio>:
SYSCALL(setprio)
 136:	b8 19 00 00 00       	mov    $0x19,%eax
 13b:	cd 40                	int    $0x40
 13d:	c3                   	ret    

0000013e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 1c             	sub    $0x1c,%esp
 144:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 147:	6a 01                	push   $0x1
 149:	8d 55 f4             	lea    -0xc(%ebp),%edx
 14c:	52                   	push   %edx
 14d:	50                   	push   %eax
 14e:	e8 4b ff ff ff       	call   9e <write>
}
 153:	83 c4 10             	add    $0x10,%esp
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	57                   	push   %edi
 15c:	56                   	push   %esi
 15d:	53                   	push   %ebx
 15e:	83 ec 2c             	sub    $0x2c,%esp
 161:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 164:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 16a:	74 04                	je     170 <printint+0x18>
 16c:	85 d2                	test   %edx,%edx
 16e:	78 3a                	js     1aa <printint+0x52>
  neg = 0;
 170:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 177:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 17c:	89 f0                	mov    %esi,%eax
 17e:	ba 00 00 00 00       	mov    $0x0,%edx
 183:	f7 f1                	div    %ecx
 185:	89 df                	mov    %ebx,%edi
 187:	43                   	inc    %ebx
 188:	8a 92 70 03 00 00    	mov    0x370(%edx),%dl
 18e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 192:	89 f2                	mov    %esi,%edx
 194:	89 c6                	mov    %eax,%esi
 196:	39 d1                	cmp    %edx,%ecx
 198:	76 e2                	jbe    17c <printint+0x24>
  if(neg)
 19a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 19e:	74 22                	je     1c2 <printint+0x6a>
    buf[i++] = '-';
 1a0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1a5:	8d 5f 02             	lea    0x2(%edi),%ebx
 1a8:	eb 18                	jmp    1c2 <printint+0x6a>
    x = -xx;
 1aa:	f7 de                	neg    %esi
    neg = 1;
 1ac:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1b3:	eb c2                	jmp    177 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1b5:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1bd:	e8 7c ff ff ff       	call   13e <putc>
  while(--i >= 0)
 1c2:	4b                   	dec    %ebx
 1c3:	79 f0                	jns    1b5 <printint+0x5d>
}
 1c5:	83 c4 2c             	add    $0x2c,%esp
 1c8:	5b                   	pop    %ebx
 1c9:	5e                   	pop    %esi
 1ca:	5f                   	pop    %edi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    

000001cd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1cd:	f3 0f 1e fb          	endbr32 
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	57                   	push   %edi
 1d5:	56                   	push   %esi
 1d6:	53                   	push   %ebx
 1d7:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1da:	8d 45 10             	lea    0x10(%ebp),%eax
 1dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e0:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1e5:	bb 00 00 00 00       	mov    $0x0,%ebx
 1ea:	eb 12                	jmp    1fe <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1ec:	89 fa                	mov    %edi,%edx
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	e8 48 ff ff ff       	call   13e <putc>
 1f6:	eb 05                	jmp    1fd <printf+0x30>
      }
    } else if(state == '%'){
 1f8:	83 fe 25             	cmp    $0x25,%esi
 1fb:	74 22                	je     21f <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1fd:	43                   	inc    %ebx
 1fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 201:	8a 04 18             	mov    (%eax,%ebx,1),%al
 204:	84 c0                	test   %al,%al
 206:	0f 84 13 01 00 00    	je     31f <printf+0x152>
    c = fmt[i] & 0xff;
 20c:	0f be f8             	movsbl %al,%edi
 20f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 212:	85 f6                	test   %esi,%esi
 214:	75 e2                	jne    1f8 <printf+0x2b>
      if(c == '%'){
 216:	83 f8 25             	cmp    $0x25,%eax
 219:	75 d1                	jne    1ec <printf+0x1f>
        state = '%';
 21b:	89 c6                	mov    %eax,%esi
 21d:	eb de                	jmp    1fd <printf+0x30>
      if(c == 'd'){
 21f:	83 f8 64             	cmp    $0x64,%eax
 222:	74 43                	je     267 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 224:	83 f8 78             	cmp    $0x78,%eax
 227:	74 68                	je     291 <printf+0xc4>
 229:	83 f8 70             	cmp    $0x70,%eax
 22c:	74 63                	je     291 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 22e:	83 f8 73             	cmp    $0x73,%eax
 231:	0f 84 84 00 00 00    	je     2bb <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 237:	83 f8 63             	cmp    $0x63,%eax
 23a:	0f 84 ad 00 00 00    	je     2ed <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 240:	83 f8 25             	cmp    $0x25,%eax
 243:	0f 84 c2 00 00 00    	je     30b <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 249:	ba 25 00 00 00       	mov    $0x25,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	e8 e8 fe ff ff       	call   13e <putc>
        putc(fd, c);
 256:	89 fa                	mov    %edi,%edx
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	e8 de fe ff ff       	call   13e <putc>
      }
      state = 0;
 260:	be 00 00 00 00       	mov    $0x0,%esi
 265:	eb 96                	jmp    1fd <printf+0x30>
        printint(fd, *ap, 10, 1);
 267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 26a:	8b 17                	mov    (%edi),%edx
 26c:	83 ec 0c             	sub    $0xc,%esp
 26f:	6a 01                	push   $0x1
 271:	b9 0a 00 00 00       	mov    $0xa,%ecx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	e8 da fe ff ff       	call   158 <printint>
        ap++;
 27e:	83 c7 04             	add    $0x4,%edi
 281:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 284:	83 c4 10             	add    $0x10,%esp
      state = 0;
 287:	be 00 00 00 00       	mov    $0x0,%esi
 28c:	e9 6c ff ff ff       	jmp    1fd <printf+0x30>
        printint(fd, *ap, 16, 0);
 291:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 294:	8b 17                	mov    (%edi),%edx
 296:	83 ec 0c             	sub    $0xc,%esp
 299:	6a 00                	push   $0x0
 29b:	b9 10 00 00 00       	mov    $0x10,%ecx
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	e8 b0 fe ff ff       	call   158 <printint>
        ap++;
 2a8:	83 c7 04             	add    $0x4,%edi
 2ab:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ae:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2b1:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2b6:	e9 42 ff ff ff       	jmp    1fd <printf+0x30>
        s = (char*)*ap;
 2bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2be:	8b 30                	mov    (%eax),%esi
        ap++;
 2c0:	83 c0 04             	add    $0x4,%eax
 2c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2c6:	85 f6                	test   %esi,%esi
 2c8:	75 13                	jne    2dd <printf+0x110>
          s = "(null)";
 2ca:	be 69 03 00 00       	mov    $0x369,%esi
 2cf:	eb 0c                	jmp    2dd <printf+0x110>
          putc(fd, *s);
 2d1:	0f be d2             	movsbl %dl,%edx
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	e8 62 fe ff ff       	call   13e <putc>
          s++;
 2dc:	46                   	inc    %esi
        while(*s != 0){
 2dd:	8a 16                	mov    (%esi),%dl
 2df:	84 d2                	test   %dl,%dl
 2e1:	75 ee                	jne    2d1 <printf+0x104>
      state = 0;
 2e3:	be 00 00 00 00       	mov    $0x0,%esi
 2e8:	e9 10 ff ff ff       	jmp    1fd <printf+0x30>
        putc(fd, *ap);
 2ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f0:	0f be 17             	movsbl (%edi),%edx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	e8 43 fe ff ff       	call   13e <putc>
        ap++;
 2fb:	83 c7 04             	add    $0x4,%edi
 2fe:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 301:	be 00 00 00 00       	mov    $0x0,%esi
 306:	e9 f2 fe ff ff       	jmp    1fd <printf+0x30>
        putc(fd, c);
 30b:	89 fa                	mov    %edi,%edx
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	e8 29 fe ff ff       	call   13e <putc>
      state = 0;
 315:	be 00 00 00 00       	mov    $0x0,%esi
 31a:	e9 de fe ff ff       	jmp    1fd <printf+0x30>
    }
  }
}
 31f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 322:	5b                   	pop    %ebx
 323:	5e                   	pop    %esi
 324:	5f                   	pop    %edi
 325:	5d                   	pop    %ebp
 326:	c3                   	ret    
