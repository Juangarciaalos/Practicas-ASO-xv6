
exitwait:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <forktest>:

#define N  1000

void
forktest(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 1c             	sub    $0x1c,%esp
  int n, pid;
  int status;

  printf(1, "exit/wait with status test\n");
   b:	68 04 04 00 00       	push   $0x404
  10:	6a 01                	push   $0x1
  12:	e8 90 02 00 00       	call   2a7 <printf>

  for(n=0; n<N; n++){
  17:	83 c4 10             	add    $0x10,%esp
  1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  1f:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  25:	7f 34                	jg     5b <forktest+0x5b>
    pid = fork();
  27:	e8 24 01 00 00       	call   150 <fork>
    if(pid < 0)
  2c:	85 c0                	test   %eax,%eax
  2e:	78 2b                	js     5b <forktest+0x5b>
      break;
    if(pid == 0)
  30:	74 03                	je     35 <forktest+0x35>
  for(n=0; n<N; n++){
  32:	43                   	inc    %ebx
  33:	eb ea                	jmp    1f <forktest+0x1f>
      exit(n - 1/(n/40));  // Some process will fail with divide by 0
  35:	b8 67 66 66 66       	mov    $0x66666667,%eax
  3a:	f7 eb                	imul   %ebx
  3c:	89 d1                	mov    %edx,%ecx
  3e:	c1 f9 04             	sar    $0x4,%ecx
  41:	89 d8                	mov    %ebx,%eax
  43:	c1 f8 1f             	sar    $0x1f,%eax
  46:	29 c1                	sub    %eax,%ecx
  48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4d:	99                   	cltd   
  4e:	f7 f9                	idiv   %ecx
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	01 d8                	add    %ebx,%eax
  55:	50                   	push   %eax
  56:	e8 fd 00 00 00       	call   158 <exit>
  }

  if(n == N)
  5b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  61:	75 4e                	jne    b1 <forktest+0xb1>
  {
    printf(1, "fork claimed to work %d times!\n", N);
  63:	83 ec 04             	sub    $0x4,%esp
  66:	68 e8 03 00 00       	push   $0x3e8
  6b:	68 74 04 00 00       	push   $0x474
  70:	6a 01                	push   $0x1
  72:	e8 30 02 00 00       	call   2a7 <printf>
    exit(N);
  77:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  7e:	e8 d5 00 00 00       	call   158 <exit>

  for(; n > 0; n--)
  {
    if((pid = wait(&status)) < 0)
    {
      printf(1, "wait stopped early\n");
  83:	83 ec 08             	sub    $0x8,%esp
  86:	68 20 04 00 00       	push   $0x420
  8b:	6a 01                	push   $0x1
  8d:	e8 15 02 00 00       	call   2a7 <printf>
      exit(-1);
  92:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  99:	e8 ba 00 00 00       	call   158 <exit>
    }
    if (WIFEXITED (status))
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
    else if (WIFSIGNALED(status))
      printf (1, "Exited child (failure) %d, trap %d\n", pid, WEXITTRAP (status));
  9e:	49                   	dec    %ecx
  9f:	51                   	push   %ecx
  a0:	50                   	push   %eax
  a1:	68 94 04 00 00       	push   $0x494
  a6:	6a 01                	push   $0x1
  a8:	e8 fa 01 00 00       	call   2a7 <printf>
  ad:	83 c4 10             	add    $0x10,%esp
  for(; n > 0; n--)
  b0:	4b                   	dec    %ebx
  b1:	85 db                	test   %ebx,%ebx
  b3:	7e 33                	jle    e8 <forktest+0xe8>
    if((pid = wait(&status)) < 0)
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  bb:	50                   	push   %eax
  bc:	e8 9f 00 00 00       	call   160 <wait>
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	85 c0                	test   %eax,%eax
  c6:	78 bb                	js     83 <forktest+0x83>
    if (WIFEXITED (status))
  c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  cb:	89 d1                	mov    %edx,%ecx
  cd:	83 e1 7f             	and    $0x7f,%ecx
  d0:	75 cc                	jne    9e <forktest+0x9e>
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
  d2:	0f b6 d6             	movzbl %dh,%edx
  d5:	52                   	push   %edx
  d6:	50                   	push   %eax
  d7:	68 34 04 00 00       	push   $0x434
  dc:	6a 01                	push   $0x1
  de:	e8 c4 01 00 00       	call   2a7 <printf>
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	eb c8                	jmp    b0 <forktest+0xb0>
  }

  if(wait(0) != -1){
  e8:	83 ec 0c             	sub    $0xc,%esp
  eb:	6a 00                	push   $0x0
  ed:	e8 6e 00 00 00       	call   160 <wait>
  f2:	83 c4 10             	add    $0x10,%esp
  f5:	83 f8 ff             	cmp    $0xffffffff,%eax
  f8:	75 17                	jne    111 <forktest+0x111>
    printf(1, "wait got too many\n");
    exit(-1);
  }

  printf(1, "fork test OK\n");
  fa:	83 ec 08             	sub    $0x8,%esp
  fd:	68 65 04 00 00       	push   $0x465
 102:	6a 01                	push   $0x1
 104:	e8 9e 01 00 00       	call   2a7 <printf>
}
 109:	83 c4 10             	add    $0x10,%esp
 10c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10f:	c9                   	leave  
 110:	c3                   	ret    
    printf(1, "wait got too many\n");
 111:	83 ec 08             	sub    $0x8,%esp
 114:	68 52 04 00 00       	push   $0x452
 119:	6a 01                	push   $0x1
 11b:	e8 87 01 00 00       	call   2a7 <printf>
    exit(-1);
 120:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 127:	e8 2c 00 00 00       	call   158 <exit>

0000012c <main>:

int
main(void)
{
 12c:	f3 0f 1e fb          	endbr32 
 130:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 134:	83 e4 f0             	and    $0xfffffff0,%esp
 137:	ff 71 fc             	pushl  -0x4(%ecx)
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	51                   	push   %ecx
 13e:	83 ec 04             	sub    $0x4,%esp
  forktest();
 141:	e8 ba fe ff ff       	call   0 <forktest>
  exit(0);
 146:	83 ec 0c             	sub    $0xc,%esp
 149:	6a 00                	push   $0x0
 14b:	e8 08 00 00 00       	call   158 <exit>

00000150 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 150:	b8 01 00 00 00       	mov    $0x1,%eax
 155:	cd 40                	int    $0x40
 157:	c3                   	ret    

00000158 <exit>:
SYSCALL(exit)
 158:	b8 02 00 00 00       	mov    $0x2,%eax
 15d:	cd 40                	int    $0x40
 15f:	c3                   	ret    

00000160 <wait>:
SYSCALL(wait)
 160:	b8 03 00 00 00       	mov    $0x3,%eax
 165:	cd 40                	int    $0x40
 167:	c3                   	ret    

00000168 <pipe>:
SYSCALL(pipe)
 168:	b8 04 00 00 00       	mov    $0x4,%eax
 16d:	cd 40                	int    $0x40
 16f:	c3                   	ret    

00000170 <read>:
SYSCALL(read)
 170:	b8 05 00 00 00       	mov    $0x5,%eax
 175:	cd 40                	int    $0x40
 177:	c3                   	ret    

00000178 <write>:
SYSCALL(write)
 178:	b8 10 00 00 00       	mov    $0x10,%eax
 17d:	cd 40                	int    $0x40
 17f:	c3                   	ret    

00000180 <close>:
SYSCALL(close)
 180:	b8 15 00 00 00       	mov    $0x15,%eax
 185:	cd 40                	int    $0x40
 187:	c3                   	ret    

00000188 <kill>:
SYSCALL(kill)
 188:	b8 06 00 00 00       	mov    $0x6,%eax
 18d:	cd 40                	int    $0x40
 18f:	c3                   	ret    

00000190 <exec>:
SYSCALL(exec)
 190:	b8 07 00 00 00       	mov    $0x7,%eax
 195:	cd 40                	int    $0x40
 197:	c3                   	ret    

00000198 <open>:
SYSCALL(open)
 198:	b8 0f 00 00 00       	mov    $0xf,%eax
 19d:	cd 40                	int    $0x40
 19f:	c3                   	ret    

000001a0 <mknod>:
SYSCALL(mknod)
 1a0:	b8 11 00 00 00       	mov    $0x11,%eax
 1a5:	cd 40                	int    $0x40
 1a7:	c3                   	ret    

000001a8 <unlink>:
SYSCALL(unlink)
 1a8:	b8 12 00 00 00       	mov    $0x12,%eax
 1ad:	cd 40                	int    $0x40
 1af:	c3                   	ret    

000001b0 <fstat>:
SYSCALL(fstat)
 1b0:	b8 08 00 00 00       	mov    $0x8,%eax
 1b5:	cd 40                	int    $0x40
 1b7:	c3                   	ret    

000001b8 <link>:
SYSCALL(link)
 1b8:	b8 13 00 00 00       	mov    $0x13,%eax
 1bd:	cd 40                	int    $0x40
 1bf:	c3                   	ret    

000001c0 <mkdir>:
SYSCALL(mkdir)
 1c0:	b8 14 00 00 00       	mov    $0x14,%eax
 1c5:	cd 40                	int    $0x40
 1c7:	c3                   	ret    

000001c8 <chdir>:
SYSCALL(chdir)
 1c8:	b8 09 00 00 00       	mov    $0x9,%eax
 1cd:	cd 40                	int    $0x40
 1cf:	c3                   	ret    

000001d0 <dup>:
SYSCALL(dup)
 1d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 1d5:	cd 40                	int    $0x40
 1d7:	c3                   	ret    

000001d8 <dup2>:
SYSCALL(dup2)
 1d8:	b8 17 00 00 00       	mov    $0x17,%eax
 1dd:	cd 40                	int    $0x40
 1df:	c3                   	ret    

000001e0 <getpid>:
SYSCALL(getpid)
 1e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 1e5:	cd 40                	int    $0x40
 1e7:	c3                   	ret    

000001e8 <sbrk>:
SYSCALL(sbrk)
 1e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <sleep>:
SYSCALL(sleep)
 1f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <uptime>:
SYSCALL(uptime)
 1f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <date>:
SYSCALL(date)
 200:	b8 16 00 00 00       	mov    $0x16,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <getprio>:
SYSCALL(getprio)
 208:	b8 18 00 00 00       	mov    $0x18,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <setprio>:
SYSCALL(setprio)
 210:	b8 19 00 00 00       	mov    $0x19,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 1c             	sub    $0x1c,%esp
 21e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 221:	6a 01                	push   $0x1
 223:	8d 55 f4             	lea    -0xc(%ebp),%edx
 226:	52                   	push   %edx
 227:	50                   	push   %eax
 228:	e8 4b ff ff ff       	call   178 <write>
}
 22d:	83 c4 10             	add    $0x10,%esp
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	57                   	push   %edi
 236:	56                   	push   %esi
 237:	53                   	push   %ebx
 238:	83 ec 2c             	sub    $0x2c,%esp
 23b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 23e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 244:	74 04                	je     24a <printint+0x18>
 246:	85 d2                	test   %edx,%edx
 248:	78 3a                	js     284 <printint+0x52>
  neg = 0;
 24a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 251:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 256:	89 f0                	mov    %esi,%eax
 258:	ba 00 00 00 00       	mov    $0x0,%edx
 25d:	f7 f1                	div    %ecx
 25f:	89 df                	mov    %ebx,%edi
 261:	43                   	inc    %ebx
 262:	8a 92 c0 04 00 00    	mov    0x4c0(%edx),%dl
 268:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 26c:	89 f2                	mov    %esi,%edx
 26e:	89 c6                	mov    %eax,%esi
 270:	39 d1                	cmp    %edx,%ecx
 272:	76 e2                	jbe    256 <printint+0x24>
  if(neg)
 274:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 278:	74 22                	je     29c <printint+0x6a>
    buf[i++] = '-';
 27a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 27f:	8d 5f 02             	lea    0x2(%edi),%ebx
 282:	eb 18                	jmp    29c <printint+0x6a>
    x = -xx;
 284:	f7 de                	neg    %esi
    neg = 1;
 286:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 28d:	eb c2                	jmp    251 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 28f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 294:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 297:	e8 7c ff ff ff       	call   218 <putc>
  while(--i >= 0)
 29c:	4b                   	dec    %ebx
 29d:	79 f0                	jns    28f <printint+0x5d>
}
 29f:	83 c4 2c             	add    $0x2c,%esp
 2a2:	5b                   	pop    %ebx
 2a3:	5e                   	pop    %esi
 2a4:	5f                   	pop    %edi
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    

000002a7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 2a7:	f3 0f 1e fb          	endbr32 
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	57                   	push   %edi
 2af:	56                   	push   %esi
 2b0:	53                   	push   %ebx
 2b1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 2b4:	8d 45 10             	lea    0x10(%ebp),%eax
 2b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 2ba:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 2bf:	bb 00 00 00 00       	mov    $0x0,%ebx
 2c4:	eb 12                	jmp    2d8 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 2c6:	89 fa                	mov    %edi,%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	e8 48 ff ff ff       	call   218 <putc>
 2d0:	eb 05                	jmp    2d7 <printf+0x30>
      }
    } else if(state == '%'){
 2d2:	83 fe 25             	cmp    $0x25,%esi
 2d5:	74 22                	je     2f9 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 2d7:	43                   	inc    %ebx
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	8a 04 18             	mov    (%eax,%ebx,1),%al
 2de:	84 c0                	test   %al,%al
 2e0:	0f 84 13 01 00 00    	je     3f9 <printf+0x152>
    c = fmt[i] & 0xff;
 2e6:	0f be f8             	movsbl %al,%edi
 2e9:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 2ec:	85 f6                	test   %esi,%esi
 2ee:	75 e2                	jne    2d2 <printf+0x2b>
      if(c == '%'){
 2f0:	83 f8 25             	cmp    $0x25,%eax
 2f3:	75 d1                	jne    2c6 <printf+0x1f>
        state = '%';
 2f5:	89 c6                	mov    %eax,%esi
 2f7:	eb de                	jmp    2d7 <printf+0x30>
      if(c == 'd'){
 2f9:	83 f8 64             	cmp    $0x64,%eax
 2fc:	74 43                	je     341 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 2fe:	83 f8 78             	cmp    $0x78,%eax
 301:	74 68                	je     36b <printf+0xc4>
 303:	83 f8 70             	cmp    $0x70,%eax
 306:	74 63                	je     36b <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 308:	83 f8 73             	cmp    $0x73,%eax
 30b:	0f 84 84 00 00 00    	je     395 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 311:	83 f8 63             	cmp    $0x63,%eax
 314:	0f 84 ad 00 00 00    	je     3c7 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 31a:	83 f8 25             	cmp    $0x25,%eax
 31d:	0f 84 c2 00 00 00    	je     3e5 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 323:	ba 25 00 00 00       	mov    $0x25,%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	e8 e8 fe ff ff       	call   218 <putc>
        putc(fd, c);
 330:	89 fa                	mov    %edi,%edx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	e8 de fe ff ff       	call   218 <putc>
      }
      state = 0;
 33a:	be 00 00 00 00       	mov    $0x0,%esi
 33f:	eb 96                	jmp    2d7 <printf+0x30>
        printint(fd, *ap, 10, 1);
 341:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 344:	8b 17                	mov    (%edi),%edx
 346:	83 ec 0c             	sub    $0xc,%esp
 349:	6a 01                	push   $0x1
 34b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	e8 da fe ff ff       	call   232 <printint>
        ap++;
 358:	83 c7 04             	add    $0x4,%edi
 35b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 35e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 361:	be 00 00 00 00       	mov    $0x0,%esi
 366:	e9 6c ff ff ff       	jmp    2d7 <printf+0x30>
        printint(fd, *ap, 16, 0);
 36b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 36e:	8b 17                	mov    (%edi),%edx
 370:	83 ec 0c             	sub    $0xc,%esp
 373:	6a 00                	push   $0x0
 375:	b9 10 00 00 00       	mov    $0x10,%ecx
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	e8 b0 fe ff ff       	call   232 <printint>
        ap++;
 382:	83 c7 04             	add    $0x4,%edi
 385:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 388:	83 c4 10             	add    $0x10,%esp
      state = 0;
 38b:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 390:	e9 42 ff ff ff       	jmp    2d7 <printf+0x30>
        s = (char*)*ap;
 395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 398:	8b 30                	mov    (%eax),%esi
        ap++;
 39a:	83 c0 04             	add    $0x4,%eax
 39d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3a0:	85 f6                	test   %esi,%esi
 3a2:	75 13                	jne    3b7 <printf+0x110>
          s = "(null)";
 3a4:	be b8 04 00 00       	mov    $0x4b8,%esi
 3a9:	eb 0c                	jmp    3b7 <printf+0x110>
          putc(fd, *s);
 3ab:	0f be d2             	movsbl %dl,%edx
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
 3b1:	e8 62 fe ff ff       	call   218 <putc>
          s++;
 3b6:	46                   	inc    %esi
        while(*s != 0){
 3b7:	8a 16                	mov    (%esi),%dl
 3b9:	84 d2                	test   %dl,%dl
 3bb:	75 ee                	jne    3ab <printf+0x104>
      state = 0;
 3bd:	be 00 00 00 00       	mov    $0x0,%esi
 3c2:	e9 10 ff ff ff       	jmp    2d7 <printf+0x30>
        putc(fd, *ap);
 3c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ca:	0f be 17             	movsbl (%edi),%edx
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	e8 43 fe ff ff       	call   218 <putc>
        ap++;
 3d5:	83 c7 04             	add    $0x4,%edi
 3d8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 3db:	be 00 00 00 00       	mov    $0x0,%esi
 3e0:	e9 f2 fe ff ff       	jmp    2d7 <printf+0x30>
        putc(fd, c);
 3e5:	89 fa                	mov    %edi,%edx
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	e8 29 fe ff ff       	call   218 <putc>
      state = 0;
 3ef:	be 00 00 00 00       	mov    $0x0,%esi
 3f4:	e9 de fe ff ff       	jmp    2d7 <printf+0x30>
    }
  }
}
 3f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fc:	5b                   	pop    %ebx
 3fd:	5e                   	pop    %esi
 3fe:	5f                   	pop    %edi
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret    
