
date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"

int
main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 30             	sub    $0x30,%esp
    struct rtcdate r;

    if (date(&r)) {
  11:	8d 45 e0             	lea    -0x20(%ebp),%eax
  14:	50                   	push   %eax
  15:	e8 fa 00 00 00       	call   114 <date>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	85 c0                	test   %eax,%eax
  1f:	74 1b                	je     3c <main+0x3c>
        printf(2, "date failed\n"); //Proporcionado por xv6, por lo que funciona como fprintf
  21:	83 ec 08             	sub    $0x8,%esp
  24:	68 20 03 00 00       	push   $0x320
  29:	6a 02                	push   $0x2
  2b:	e8 8f 01 00 00       	call   1bf <printf>
        exit(0);
  30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  37:	e8 30 00 00 00       	call   6c <exit>
    }

    printf(1, "%d/%d/%d - %d:%d:%d\n", r.day, r.month, r.year, r.hour, r.minute, r.second);
  3c:	ff 75 e0             	push   -0x20(%ebp)
  3f:	ff 75 e4             	push   -0x1c(%ebp)
  42:	ff 75 e8             	push   -0x18(%ebp)
  45:	ff 75 f4             	push   -0xc(%ebp)
  48:	ff 75 f0             	push   -0x10(%ebp)
  4b:	ff 75 ec             	push   -0x14(%ebp)
  4e:	68 2d 03 00 00       	push   $0x32d
  53:	6a 01                	push   $0x1
  55:	e8 65 01 00 00       	call   1bf <printf>

    exit(0);
  5a:	83 c4 14             	add    $0x14,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 08 00 00 00       	call   6c <exit>

00000064 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  64:	b8 01 00 00 00       	mov    $0x1,%eax
  69:	cd 40                	int    $0x40
  6b:	c3                   	ret    

0000006c <exit>:
SYSCALL(exit)
  6c:	b8 02 00 00 00       	mov    $0x2,%eax
  71:	cd 40                	int    $0x40
  73:	c3                   	ret    

00000074 <wait>:
SYSCALL(wait)
  74:	b8 03 00 00 00       	mov    $0x3,%eax
  79:	cd 40                	int    $0x40
  7b:	c3                   	ret    

0000007c <pipe>:
SYSCALL(pipe)
  7c:	b8 04 00 00 00       	mov    $0x4,%eax
  81:	cd 40                	int    $0x40
  83:	c3                   	ret    

00000084 <read>:
SYSCALL(read)
  84:	b8 05 00 00 00       	mov    $0x5,%eax
  89:	cd 40                	int    $0x40
  8b:	c3                   	ret    

0000008c <write>:
SYSCALL(write)
  8c:	b8 10 00 00 00       	mov    $0x10,%eax
  91:	cd 40                	int    $0x40
  93:	c3                   	ret    

00000094 <close>:
SYSCALL(close)
  94:	b8 15 00 00 00       	mov    $0x15,%eax
  99:	cd 40                	int    $0x40
  9b:	c3                   	ret    

0000009c <kill>:
SYSCALL(kill)
  9c:	b8 06 00 00 00       	mov    $0x6,%eax
  a1:	cd 40                	int    $0x40
  a3:	c3                   	ret    

000000a4 <exec>:
SYSCALL(exec)
  a4:	b8 07 00 00 00       	mov    $0x7,%eax
  a9:	cd 40                	int    $0x40
  ab:	c3                   	ret    

000000ac <open>:
SYSCALL(open)
  ac:	b8 0f 00 00 00       	mov    $0xf,%eax
  b1:	cd 40                	int    $0x40
  b3:	c3                   	ret    

000000b4 <mknod>:
SYSCALL(mknod)
  b4:	b8 11 00 00 00       	mov    $0x11,%eax
  b9:	cd 40                	int    $0x40
  bb:	c3                   	ret    

000000bc <unlink>:
SYSCALL(unlink)
  bc:	b8 12 00 00 00       	mov    $0x12,%eax
  c1:	cd 40                	int    $0x40
  c3:	c3                   	ret    

000000c4 <fstat>:
SYSCALL(fstat)
  c4:	b8 08 00 00 00       	mov    $0x8,%eax
  c9:	cd 40                	int    $0x40
  cb:	c3                   	ret    

000000cc <link>:
SYSCALL(link)
  cc:	b8 13 00 00 00       	mov    $0x13,%eax
  d1:	cd 40                	int    $0x40
  d3:	c3                   	ret    

000000d4 <mkdir>:
SYSCALL(mkdir)
  d4:	b8 14 00 00 00       	mov    $0x14,%eax
  d9:	cd 40                	int    $0x40
  db:	c3                   	ret    

000000dc <chdir>:
SYSCALL(chdir)
  dc:	b8 09 00 00 00       	mov    $0x9,%eax
  e1:	cd 40                	int    $0x40
  e3:	c3                   	ret    

000000e4 <dup>:
SYSCALL(dup)
  e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  e9:	cd 40                	int    $0x40
  eb:	c3                   	ret    

000000ec <dup2>:
SYSCALL(dup2)
  ec:	b8 17 00 00 00       	mov    $0x17,%eax
  f1:	cd 40                	int    $0x40
  f3:	c3                   	ret    

000000f4 <getpid>:
SYSCALL(getpid)
  f4:	b8 0b 00 00 00       	mov    $0xb,%eax
  f9:	cd 40                	int    $0x40
  fb:	c3                   	ret    

000000fc <sbrk>:
SYSCALL(sbrk)
  fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 101:	cd 40                	int    $0x40
 103:	c3                   	ret    

00000104 <sleep>:
SYSCALL(sleep)
 104:	b8 0d 00 00 00       	mov    $0xd,%eax
 109:	cd 40                	int    $0x40
 10b:	c3                   	ret    

0000010c <uptime>:
SYSCALL(uptime)
 10c:	b8 0e 00 00 00       	mov    $0xe,%eax
 111:	cd 40                	int    $0x40
 113:	c3                   	ret    

00000114 <date>:
SYSCALL(date)
 114:	b8 16 00 00 00       	mov    $0x16,%eax
 119:	cd 40                	int    $0x40
 11b:	c3                   	ret    

0000011c <getprio>:
SYSCALL(getprio)
 11c:	b8 18 00 00 00       	mov    $0x18,%eax
 121:	cd 40                	int    $0x40
 123:	c3                   	ret    

00000124 <setprio>:
SYSCALL(setprio)
 124:	b8 19 00 00 00       	mov    $0x19,%eax
 129:	cd 40                	int    $0x40
 12b:	c3                   	ret    

0000012c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	83 ec 1c             	sub    $0x1c,%esp
 132:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 135:	6a 01                	push   $0x1
 137:	8d 55 f4             	lea    -0xc(%ebp),%edx
 13a:	52                   	push   %edx
 13b:	50                   	push   %eax
 13c:	e8 4b ff ff ff       	call   8c <write>
}
 141:	83 c4 10             	add    $0x10,%esp
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	57                   	push   %edi
 14a:	56                   	push   %esi
 14b:	53                   	push   %ebx
 14c:	83 ec 2c             	sub    $0x2c,%esp
 14f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 152:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 158:	74 04                	je     15e <printint+0x18>
 15a:	85 d2                	test   %edx,%edx
 15c:	78 3c                	js     19a <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 15e:	89 d1                	mov    %edx,%ecx
  neg = 0;
 160:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 167:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 16c:	89 c8                	mov    %ecx,%eax
 16e:	ba 00 00 00 00       	mov    $0x0,%edx
 173:	f7 f6                	div    %esi
 175:	89 df                	mov    %ebx,%edi
 177:	43                   	inc    %ebx
 178:	8a 92 a4 03 00 00    	mov    0x3a4(%edx),%dl
 17e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 182:	89 ca                	mov    %ecx,%edx
 184:	89 c1                	mov    %eax,%ecx
 186:	39 d6                	cmp    %edx,%esi
 188:	76 e2                	jbe    16c <printint+0x26>
  if(neg)
 18a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 18e:	74 24                	je     1b4 <printint+0x6e>
    buf[i++] = '-';
 190:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 195:	8d 5f 02             	lea    0x2(%edi),%ebx
 198:	eb 1a                	jmp    1b4 <printint+0x6e>
    x = -xx;
 19a:	89 d1                	mov    %edx,%ecx
 19c:	f7 d9                	neg    %ecx
    neg = 1;
 19e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1a5:	eb c0                	jmp    167 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 1a7:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1af:	e8 78 ff ff ff       	call   12c <putc>
  while(--i >= 0)
 1b4:	4b                   	dec    %ebx
 1b5:	79 f0                	jns    1a7 <printint+0x61>
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
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	57                   	push   %edi
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
 1c5:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1c8:	8d 45 10             	lea    0x10(%ebp),%eax
 1cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1ce:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1d3:	bb 00 00 00 00       	mov    $0x0,%ebx
 1d8:	eb 12                	jmp    1ec <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1da:	89 fa                	mov    %edi,%edx
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	e8 48 ff ff ff       	call   12c <putc>
 1e4:	eb 05                	jmp    1eb <printf+0x2c>
      }
    } else if(state == '%'){
 1e6:	83 fe 25             	cmp    $0x25,%esi
 1e9:	74 22                	je     20d <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 1eb:	43                   	inc    %ebx
 1ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ef:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1f2:	84 c0                	test   %al,%al
 1f4:	0f 84 1d 01 00 00    	je     317 <printf+0x158>
    c = fmt[i] & 0xff;
 1fa:	0f be f8             	movsbl %al,%edi
 1fd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 200:	85 f6                	test   %esi,%esi
 202:	75 e2                	jne    1e6 <printf+0x27>
      if(c == '%'){
 204:	83 f8 25             	cmp    $0x25,%eax
 207:	75 d1                	jne    1da <printf+0x1b>
        state = '%';
 209:	89 c6                	mov    %eax,%esi
 20b:	eb de                	jmp    1eb <printf+0x2c>
      if(c == 'd'){
 20d:	83 f8 25             	cmp    $0x25,%eax
 210:	0f 84 cc 00 00 00    	je     2e2 <printf+0x123>
 216:	0f 8c da 00 00 00    	jl     2f6 <printf+0x137>
 21c:	83 f8 78             	cmp    $0x78,%eax
 21f:	0f 8f d1 00 00 00    	jg     2f6 <printf+0x137>
 225:	83 f8 63             	cmp    $0x63,%eax
 228:	0f 8c c8 00 00 00    	jl     2f6 <printf+0x137>
 22e:	83 e8 63             	sub    $0x63,%eax
 231:	83 f8 15             	cmp    $0x15,%eax
 234:	0f 87 bc 00 00 00    	ja     2f6 <printf+0x137>
 23a:	ff 24 85 4c 03 00 00 	jmp    *0x34c(,%eax,4)
        printint(fd, *ap, 10, 1);
 241:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 244:	8b 17                	mov    (%edi),%edx
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	6a 01                	push   $0x1
 24b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	e8 ee fe ff ff       	call   146 <printint>
        ap++;
 258:	83 c7 04             	add    $0x4,%edi
 25b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 25e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 261:	be 00 00 00 00       	mov    $0x0,%esi
 266:	eb 83                	jmp    1eb <printf+0x2c>
        printint(fd, *ap, 16, 0);
 268:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 26b:	8b 17                	mov    (%edi),%edx
 26d:	83 ec 0c             	sub    $0xc,%esp
 270:	6a 00                	push   $0x0
 272:	b9 10 00 00 00       	mov    $0x10,%ecx
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	e8 c7 fe ff ff       	call   146 <printint>
        ap++;
 27f:	83 c7 04             	add    $0x4,%edi
 282:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 285:	83 c4 10             	add    $0x10,%esp
      state = 0;
 288:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 28d:	e9 59 ff ff ff       	jmp    1eb <printf+0x2c>
        s = (char*)*ap;
 292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 295:	8b 30                	mov    (%eax),%esi
        ap++;
 297:	83 c0 04             	add    $0x4,%eax
 29a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 29d:	85 f6                	test   %esi,%esi
 29f:	75 13                	jne    2b4 <printf+0xf5>
          s = "(null)";
 2a1:	be 42 03 00 00       	mov    $0x342,%esi
 2a6:	eb 0c                	jmp    2b4 <printf+0xf5>
          putc(fd, *s);
 2a8:	0f be d2             	movsbl %dl,%edx
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	e8 79 fe ff ff       	call   12c <putc>
          s++;
 2b3:	46                   	inc    %esi
        while(*s != 0){
 2b4:	8a 16                	mov    (%esi),%dl
 2b6:	84 d2                	test   %dl,%dl
 2b8:	75 ee                	jne    2a8 <printf+0xe9>
      state = 0;
 2ba:	be 00 00 00 00       	mov    $0x0,%esi
 2bf:	e9 27 ff ff ff       	jmp    1eb <printf+0x2c>
        putc(fd, *ap);
 2c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2c7:	0f be 17             	movsbl (%edi),%edx
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	e8 5a fe ff ff       	call   12c <putc>
        ap++;
 2d2:	83 c7 04             	add    $0x4,%edi
 2d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2d8:	be 00 00 00 00       	mov    $0x0,%esi
 2dd:	e9 09 ff ff ff       	jmp    1eb <printf+0x2c>
        putc(fd, c);
 2e2:	89 fa                	mov    %edi,%edx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	e8 40 fe ff ff       	call   12c <putc>
      state = 0;
 2ec:	be 00 00 00 00       	mov    $0x0,%esi
 2f1:	e9 f5 fe ff ff       	jmp    1eb <printf+0x2c>
        putc(fd, '%');
 2f6:	ba 25 00 00 00       	mov    $0x25,%edx
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	e8 29 fe ff ff       	call   12c <putc>
        putc(fd, c);
 303:	89 fa                	mov    %edi,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	e8 1f fe ff ff       	call   12c <putc>
      state = 0;
 30d:	be 00 00 00 00       	mov    $0x0,%esi
 312:	e9 d4 fe ff ff       	jmp    1eb <printf+0x2c>
    }
  }
}
 317:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31a:	5b                   	pop    %ebx
 31b:	5e                   	pop    %esi
 31c:	5f                   	pop    %edi
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    
