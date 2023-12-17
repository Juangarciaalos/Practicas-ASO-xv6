
date:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"

int
main(int argc, char *argv[]){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 30             	sub    $0x30,%esp
    struct rtcdate r;

    if (date(&r)) {
  15:	8d 45 e0             	lea    -0x20(%ebp),%eax
  18:	50                   	push   %eax
  19:	e8 fa 00 00 00       	call   118 <date>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	74 1b                	je     40 <main+0x40>
        printf(2, "date failed\n"); //Proporcionado por xv6, por lo que funciona como fprintf
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 1c 03 00 00       	push   $0x31c
  2d:	6a 02                	push   $0x2
  2f:	e8 8b 01 00 00       	call   1bf <printf>
        exit(0);
  34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3b:	e8 30 00 00 00       	call   70 <exit>
    }

    printf(1, "%d/%d/%d - %d:%d:%d\n", r.day, r.month, r.year, r.hour, r.minute, r.second);
  40:	ff 75 e0             	pushl  -0x20(%ebp)
  43:	ff 75 e4             	pushl  -0x1c(%ebp)
  46:	ff 75 e8             	pushl  -0x18(%ebp)
  49:	ff 75 f4             	pushl  -0xc(%ebp)
  4c:	ff 75 f0             	pushl  -0x10(%ebp)
  4f:	ff 75 ec             	pushl  -0x14(%ebp)
  52:	68 29 03 00 00       	push   $0x329
  57:	6a 01                	push   $0x1
  59:	e8 61 01 00 00       	call   1bf <printf>

    exit(0);
  5e:	83 c4 14             	add    $0x14,%esp
  61:	6a 00                	push   $0x0
  63:	e8 08 00 00 00       	call   70 <exit>

00000068 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  68:	b8 01 00 00 00       	mov    $0x1,%eax
  6d:	cd 40                	int    $0x40
  6f:	c3                   	ret    

00000070 <exit>:
SYSCALL(exit)
  70:	b8 02 00 00 00       	mov    $0x2,%eax
  75:	cd 40                	int    $0x40
  77:	c3                   	ret    

00000078 <wait>:
SYSCALL(wait)
  78:	b8 03 00 00 00       	mov    $0x3,%eax
  7d:	cd 40                	int    $0x40
  7f:	c3                   	ret    

00000080 <pipe>:
SYSCALL(pipe)
  80:	b8 04 00 00 00       	mov    $0x4,%eax
  85:	cd 40                	int    $0x40
  87:	c3                   	ret    

00000088 <read>:
SYSCALL(read)
  88:	b8 05 00 00 00       	mov    $0x5,%eax
  8d:	cd 40                	int    $0x40
  8f:	c3                   	ret    

00000090 <write>:
SYSCALL(write)
  90:	b8 10 00 00 00       	mov    $0x10,%eax
  95:	cd 40                	int    $0x40
  97:	c3                   	ret    

00000098 <close>:
SYSCALL(close)
  98:	b8 15 00 00 00       	mov    $0x15,%eax
  9d:	cd 40                	int    $0x40
  9f:	c3                   	ret    

000000a0 <kill>:
SYSCALL(kill)
  a0:	b8 06 00 00 00       	mov    $0x6,%eax
  a5:	cd 40                	int    $0x40
  a7:	c3                   	ret    

000000a8 <exec>:
SYSCALL(exec)
  a8:	b8 07 00 00 00       	mov    $0x7,%eax
  ad:	cd 40                	int    $0x40
  af:	c3                   	ret    

000000b0 <open>:
SYSCALL(open)
  b0:	b8 0f 00 00 00       	mov    $0xf,%eax
  b5:	cd 40                	int    $0x40
  b7:	c3                   	ret    

000000b8 <mknod>:
SYSCALL(mknod)
  b8:	b8 11 00 00 00       	mov    $0x11,%eax
  bd:	cd 40                	int    $0x40
  bf:	c3                   	ret    

000000c0 <unlink>:
SYSCALL(unlink)
  c0:	b8 12 00 00 00       	mov    $0x12,%eax
  c5:	cd 40                	int    $0x40
  c7:	c3                   	ret    

000000c8 <fstat>:
SYSCALL(fstat)
  c8:	b8 08 00 00 00       	mov    $0x8,%eax
  cd:	cd 40                	int    $0x40
  cf:	c3                   	ret    

000000d0 <link>:
SYSCALL(link)
  d0:	b8 13 00 00 00       	mov    $0x13,%eax
  d5:	cd 40                	int    $0x40
  d7:	c3                   	ret    

000000d8 <mkdir>:
SYSCALL(mkdir)
  d8:	b8 14 00 00 00       	mov    $0x14,%eax
  dd:	cd 40                	int    $0x40
  df:	c3                   	ret    

000000e0 <chdir>:
SYSCALL(chdir)
  e0:	b8 09 00 00 00       	mov    $0x9,%eax
  e5:	cd 40                	int    $0x40
  e7:	c3                   	ret    

000000e8 <dup>:
SYSCALL(dup)
  e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  ed:	cd 40                	int    $0x40
  ef:	c3                   	ret    

000000f0 <dup2>:
SYSCALL(dup2)
  f0:	b8 17 00 00 00       	mov    $0x17,%eax
  f5:	cd 40                	int    $0x40
  f7:	c3                   	ret    

000000f8 <getpid>:
SYSCALL(getpid)
  f8:	b8 0b 00 00 00       	mov    $0xb,%eax
  fd:	cd 40                	int    $0x40
  ff:	c3                   	ret    

00000100 <sbrk>:
SYSCALL(sbrk)
 100:	b8 0c 00 00 00       	mov    $0xc,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <sleep>:
SYSCALL(sleep)
 108:	b8 0d 00 00 00       	mov    $0xd,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <uptime>:
SYSCALL(uptime)
 110:	b8 0e 00 00 00       	mov    $0xe,%eax
 115:	cd 40                	int    $0x40
 117:	c3                   	ret    

00000118 <date>:
SYSCALL(date)
 118:	b8 16 00 00 00       	mov    $0x16,%eax
 11d:	cd 40                	int    $0x40
 11f:	c3                   	ret    

00000120 <getprio>:
SYSCALL(getprio)
 120:	b8 18 00 00 00       	mov    $0x18,%eax
 125:	cd 40                	int    $0x40
 127:	c3                   	ret    

00000128 <setprio>:
SYSCALL(setprio)
 128:	b8 19 00 00 00       	mov    $0x19,%eax
 12d:	cd 40                	int    $0x40
 12f:	c3                   	ret    

00000130 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 1c             	sub    $0x1c,%esp
 136:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 139:	6a 01                	push   $0x1
 13b:	8d 55 f4             	lea    -0xc(%ebp),%edx
 13e:	52                   	push   %edx
 13f:	50                   	push   %eax
 140:	e8 4b ff ff ff       	call   90 <write>
}
 145:	83 c4 10             	add    $0x10,%esp
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	57                   	push   %edi
 14e:	56                   	push   %esi
 14f:	53                   	push   %ebx
 150:	83 ec 2c             	sub    $0x2c,%esp
 153:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 156:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 158:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 15c:	74 04                	je     162 <printint+0x18>
 15e:	85 d2                	test   %edx,%edx
 160:	78 3a                	js     19c <printint+0x52>
  neg = 0;
 162:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 169:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 16e:	89 f0                	mov    %esi,%eax
 170:	ba 00 00 00 00       	mov    $0x0,%edx
 175:	f7 f1                	div    %ecx
 177:	89 df                	mov    %ebx,%edi
 179:	43                   	inc    %ebx
 17a:	8a 92 48 03 00 00    	mov    0x348(%edx),%dl
 180:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 184:	89 f2                	mov    %esi,%edx
 186:	89 c6                	mov    %eax,%esi
 188:	39 d1                	cmp    %edx,%ecx
 18a:	76 e2                	jbe    16e <printint+0x24>
  if(neg)
 18c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 190:	74 22                	je     1b4 <printint+0x6a>
    buf[i++] = '-';
 192:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 197:	8d 5f 02             	lea    0x2(%edi),%ebx
 19a:	eb 18                	jmp    1b4 <printint+0x6a>
    x = -xx;
 19c:	f7 de                	neg    %esi
    neg = 1;
 19e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1a5:	eb c2                	jmp    169 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1a7:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1af:	e8 7c ff ff ff       	call   130 <putc>
  while(--i >= 0)
 1b4:	4b                   	dec    %ebx
 1b5:	79 f0                	jns    1a7 <printint+0x5d>
}
 1b7:	83 c4 2c             	add    $0x2c,%esp
 1ba:	5b                   	pop    %ebx
 1bb:	5e                   	pop    %esi
 1bc:	5f                   	pop    %edi
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    

000001bf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1bf:	f3 0f 1e fb          	endbr32 
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	57                   	push   %edi
 1c7:	56                   	push   %esi
 1c8:	53                   	push   %ebx
 1c9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1cc:	8d 45 10             	lea    0x10(%ebp),%eax
 1cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1d2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1d7:	bb 00 00 00 00       	mov    $0x0,%ebx
 1dc:	eb 12                	jmp    1f0 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1de:	89 fa                	mov    %edi,%edx
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	e8 48 ff ff ff       	call   130 <putc>
 1e8:	eb 05                	jmp    1ef <printf+0x30>
      }
    } else if(state == '%'){
 1ea:	83 fe 25             	cmp    $0x25,%esi
 1ed:	74 22                	je     211 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1ef:	43                   	inc    %ebx
 1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f3:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1f6:	84 c0                	test   %al,%al
 1f8:	0f 84 13 01 00 00    	je     311 <printf+0x152>
    c = fmt[i] & 0xff;
 1fe:	0f be f8             	movsbl %al,%edi
 201:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 204:	85 f6                	test   %esi,%esi
 206:	75 e2                	jne    1ea <printf+0x2b>
      if(c == '%'){
 208:	83 f8 25             	cmp    $0x25,%eax
 20b:	75 d1                	jne    1de <printf+0x1f>
        state = '%';
 20d:	89 c6                	mov    %eax,%esi
 20f:	eb de                	jmp    1ef <printf+0x30>
      if(c == 'd'){
 211:	83 f8 64             	cmp    $0x64,%eax
 214:	74 43                	je     259 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 216:	83 f8 78             	cmp    $0x78,%eax
 219:	74 68                	je     283 <printf+0xc4>
 21b:	83 f8 70             	cmp    $0x70,%eax
 21e:	74 63                	je     283 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 220:	83 f8 73             	cmp    $0x73,%eax
 223:	0f 84 84 00 00 00    	je     2ad <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 229:	83 f8 63             	cmp    $0x63,%eax
 22c:	0f 84 ad 00 00 00    	je     2df <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 232:	83 f8 25             	cmp    $0x25,%eax
 235:	0f 84 c2 00 00 00    	je     2fd <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 23b:	ba 25 00 00 00       	mov    $0x25,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	e8 e8 fe ff ff       	call   130 <putc>
        putc(fd, c);
 248:	89 fa                	mov    %edi,%edx
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	e8 de fe ff ff       	call   130 <putc>
      }
      state = 0;
 252:	be 00 00 00 00       	mov    $0x0,%esi
 257:	eb 96                	jmp    1ef <printf+0x30>
        printint(fd, *ap, 10, 1);
 259:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 25c:	8b 17                	mov    (%edi),%edx
 25e:	83 ec 0c             	sub    $0xc,%esp
 261:	6a 01                	push   $0x1
 263:	b9 0a 00 00 00       	mov    $0xa,%ecx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	e8 da fe ff ff       	call   14a <printint>
        ap++;
 270:	83 c7 04             	add    $0x4,%edi
 273:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 276:	83 c4 10             	add    $0x10,%esp
      state = 0;
 279:	be 00 00 00 00       	mov    $0x0,%esi
 27e:	e9 6c ff ff ff       	jmp    1ef <printf+0x30>
        printint(fd, *ap, 16, 0);
 283:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 286:	8b 17                	mov    (%edi),%edx
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	6a 00                	push   $0x0
 28d:	b9 10 00 00 00       	mov    $0x10,%ecx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	e8 b0 fe ff ff       	call   14a <printint>
        ap++;
 29a:	83 c7 04             	add    $0x4,%edi
 29d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2a0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2a3:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2a8:	e9 42 ff ff ff       	jmp    1ef <printf+0x30>
        s = (char*)*ap;
 2ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2b0:	8b 30                	mov    (%eax),%esi
        ap++;
 2b2:	83 c0 04             	add    $0x4,%eax
 2b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2b8:	85 f6                	test   %esi,%esi
 2ba:	75 13                	jne    2cf <printf+0x110>
          s = "(null)";
 2bc:	be 3e 03 00 00       	mov    $0x33e,%esi
 2c1:	eb 0c                	jmp    2cf <printf+0x110>
          putc(fd, *s);
 2c3:	0f be d2             	movsbl %dl,%edx
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	e8 62 fe ff ff       	call   130 <putc>
          s++;
 2ce:	46                   	inc    %esi
        while(*s != 0){
 2cf:	8a 16                	mov    (%esi),%dl
 2d1:	84 d2                	test   %dl,%dl
 2d3:	75 ee                	jne    2c3 <printf+0x104>
      state = 0;
 2d5:	be 00 00 00 00       	mov    $0x0,%esi
 2da:	e9 10 ff ff ff       	jmp    1ef <printf+0x30>
        putc(fd, *ap);
 2df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e2:	0f be 17             	movsbl (%edi),%edx
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	e8 43 fe ff ff       	call   130 <putc>
        ap++;
 2ed:	83 c7 04             	add    $0x4,%edi
 2f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2f3:	be 00 00 00 00       	mov    $0x0,%esi
 2f8:	e9 f2 fe ff ff       	jmp    1ef <printf+0x30>
        putc(fd, c);
 2fd:	89 fa                	mov    %edi,%edx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	e8 29 fe ff ff       	call   130 <putc>
      state = 0;
 307:	be 00 00 00 00       	mov    $0x0,%esi
 30c:	e9 de fe ff ff       	jmp    1ef <printf+0x30>
    }
  }
}
 311:	8d 65 f4             	lea    -0xc(%ebp),%esp
 314:	5b                   	pop    %ebx
 315:	5e                   	pop    %esi
 316:	5f                   	pop    %edi
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
