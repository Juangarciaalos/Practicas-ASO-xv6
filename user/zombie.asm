
zombie:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  15:	e8 1d 00 00 00       	call   37 <fork>
  1a:	85 c0                	test   %eax,%eax
  1c:	7f 0a                	jg     28 <main+0x28>
    sleep(5);  // Let child exit before parent.
  exit(0);
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	6a 00                	push   $0x0
  23:	e8 17 00 00 00       	call   3f <exit>
    sleep(5);  // Let child exit before parent.
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	6a 05                	push   $0x5
  2d:	e8 a5 00 00 00       	call   d7 <sleep>
  32:	83 c4 10             	add    $0x10,%esp
  35:	eb e7                	jmp    1e <main+0x1e>

00000037 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  37:	b8 01 00 00 00       	mov    $0x1,%eax
  3c:	cd 40                	int    $0x40
  3e:	c3                   	ret    

0000003f <exit>:
SYSCALL(exit)
  3f:	b8 02 00 00 00       	mov    $0x2,%eax
  44:	cd 40                	int    $0x40
  46:	c3                   	ret    

00000047 <wait>:
SYSCALL(wait)
  47:	b8 03 00 00 00       	mov    $0x3,%eax
  4c:	cd 40                	int    $0x40
  4e:	c3                   	ret    

0000004f <pipe>:
SYSCALL(pipe)
  4f:	b8 04 00 00 00       	mov    $0x4,%eax
  54:	cd 40                	int    $0x40
  56:	c3                   	ret    

00000057 <read>:
SYSCALL(read)
  57:	b8 05 00 00 00       	mov    $0x5,%eax
  5c:	cd 40                	int    $0x40
  5e:	c3                   	ret    

0000005f <write>:
SYSCALL(write)
  5f:	b8 10 00 00 00       	mov    $0x10,%eax
  64:	cd 40                	int    $0x40
  66:	c3                   	ret    

00000067 <close>:
SYSCALL(close)
  67:	b8 15 00 00 00       	mov    $0x15,%eax
  6c:	cd 40                	int    $0x40
  6e:	c3                   	ret    

0000006f <kill>:
SYSCALL(kill)
  6f:	b8 06 00 00 00       	mov    $0x6,%eax
  74:	cd 40                	int    $0x40
  76:	c3                   	ret    

00000077 <exec>:
SYSCALL(exec)
  77:	b8 07 00 00 00       	mov    $0x7,%eax
  7c:	cd 40                	int    $0x40
  7e:	c3                   	ret    

0000007f <open>:
SYSCALL(open)
  7f:	b8 0f 00 00 00       	mov    $0xf,%eax
  84:	cd 40                	int    $0x40
  86:	c3                   	ret    

00000087 <mknod>:
SYSCALL(mknod)
  87:	b8 11 00 00 00       	mov    $0x11,%eax
  8c:	cd 40                	int    $0x40
  8e:	c3                   	ret    

0000008f <unlink>:
SYSCALL(unlink)
  8f:	b8 12 00 00 00       	mov    $0x12,%eax
  94:	cd 40                	int    $0x40
  96:	c3                   	ret    

00000097 <fstat>:
SYSCALL(fstat)
  97:	b8 08 00 00 00       	mov    $0x8,%eax
  9c:	cd 40                	int    $0x40
  9e:	c3                   	ret    

0000009f <link>:
SYSCALL(link)
  9f:	b8 13 00 00 00       	mov    $0x13,%eax
  a4:	cd 40                	int    $0x40
  a6:	c3                   	ret    

000000a7 <mkdir>:
SYSCALL(mkdir)
  a7:	b8 14 00 00 00       	mov    $0x14,%eax
  ac:	cd 40                	int    $0x40
  ae:	c3                   	ret    

000000af <chdir>:
SYSCALL(chdir)
  af:	b8 09 00 00 00       	mov    $0x9,%eax
  b4:	cd 40                	int    $0x40
  b6:	c3                   	ret    

000000b7 <dup>:
SYSCALL(dup)
  b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  bc:	cd 40                	int    $0x40
  be:	c3                   	ret    

000000bf <dup2>:
SYSCALL(dup2)
  bf:	b8 17 00 00 00       	mov    $0x17,%eax
  c4:	cd 40                	int    $0x40
  c6:	c3                   	ret    

000000c7 <getpid>:
SYSCALL(getpid)
  c7:	b8 0b 00 00 00       	mov    $0xb,%eax
  cc:	cd 40                	int    $0x40
  ce:	c3                   	ret    

000000cf <sbrk>:
SYSCALL(sbrk)
  cf:	b8 0c 00 00 00       	mov    $0xc,%eax
  d4:	cd 40                	int    $0x40
  d6:	c3                   	ret    

000000d7 <sleep>:
SYSCALL(sleep)
  d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  dc:	cd 40                	int    $0x40
  de:	c3                   	ret    

000000df <uptime>:
SYSCALL(uptime)
  df:	b8 0e 00 00 00       	mov    $0xe,%eax
  e4:	cd 40                	int    $0x40
  e6:	c3                   	ret    

000000e7 <date>:
SYSCALL(date)
  e7:	b8 16 00 00 00       	mov    $0x16,%eax
  ec:	cd 40                	int    $0x40
  ee:	c3                   	ret    

000000ef <getprio>:
SYSCALL(getprio)
  ef:	b8 18 00 00 00       	mov    $0x18,%eax
  f4:	cd 40                	int    $0x40
  f6:	c3                   	ret    

000000f7 <setprio>:
SYSCALL(setprio)
  f7:	b8 19 00 00 00       	mov    $0x19,%eax
  fc:	cd 40                	int    $0x40
  fe:	c3                   	ret    
