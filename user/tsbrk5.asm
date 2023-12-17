
tsbrk5:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test1>:
#include "user.h"

int i = 1;

void test1()
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 10             	sub    $0x10,%esp
  char* a = sbrk (0);
   b:	6a 00                	push   $0x0
   d:	e8 49 01 00 00       	call   15b <sbrk>
  12:	89 c3                	mov    %eax,%ebx

  printf (1, "Debe fallar ahora:\n");
  14:	83 c4 08             	add    $0x8,%esp
  17:	68 74 03 00 00       	push   $0x374
  1c:	6a 01                	push   $0x1
  1e:	e8 f7 01 00 00       	call   21a <printf>
  *(a+1) = 1;  // Debe fallar
  23:	c6 43 01 01          	movb   $0x1,0x1(%ebx)
}
  27:	83 c4 10             	add    $0x10,%esp
  2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2d:	c9                   	leave  
  2e:	c3                   	ret    

0000002f <test2>:

void test2()
{
  2f:	f3 0f 1e fb          	endbr32 
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	83 ec 10             	sub    $0x10,%esp
  // PÃ¡gina de guarda:
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  39:	68 8c 03 00 00       	push   $0x38c
  3e:	6a 01                	push   $0x1
  40:	e8 d5 01 00 00       	call   21a <printf>
  char* a = (char*)((int)&i + 4095);
  printf (1, "%d\n", a);
  45:	83 c4 0c             	add    $0xc,%esp
  48:	68 33 15 00 00       	push   $0x1533
  4d:	68 88 03 00 00       	push   $0x388
  52:	6a 01                	push   $0x1
  54:	e8 c1 01 00 00       	call   21a <printf>
  *a = 1;
  59:	c6 05 33 15 00 00 01 	movb   $0x1,0x1533
}
  60:	83 c4 10             	add    $0x10,%esp
  63:	c9                   	leave  
  64:	c3                   	ret    

00000065 <test3>:

void test3()
{
  65:	f3 0f 1e fb          	endbr32 
  69:	55                   	push   %ebp
  6a:	89 e5                	mov    %esp,%ebp
  6c:	83 ec 10             	sub    $0x10,%esp
  // Acceder al nÃºcleo
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  6f:	68 8c 03 00 00       	push   $0x38c
  74:	6a 01                	push   $0x1
  76:	e8 9f 01 00 00       	call   21a <printf>
  char* a = (char*)0x80000001;
  *(a+1) = 1;  // Debe fallar (si lo anterior no ha fallado)
  7b:	c6 05 02 00 00 80 01 	movb   $0x1,0x80000002
}
  82:	83 c4 10             	add    $0x10,%esp
  85:	c9                   	leave  
  86:	c3                   	ret    

00000087 <main>:


int
main(int argc, char *argv[])
{
  87:	f3 0f 1e fb          	endbr32 
  8b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  8f:	83 e4 f0             	and    $0xfffffff0,%esp
  92:	ff 71 fc             	pushl  -0x4(%ecx)
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	51                   	push   %ecx
  99:	83 ec 0c             	sub    $0xc,%esp
  printf (1, "Este programa primero intenta acceder mas alla de sz.\n");
  9c:	68 c4 03 00 00       	push   $0x3c4
  a1:	6a 01                	push   $0x1
  a3:	e8 72 01 00 00       	call   21a <printf>

  // MÃ¡s allÃ¡ de sz
  test1();
  a8:	e8 53 ff ff ff       	call   0 <test1>

  // Guarda
  test2();
  ad:	e8 7d ff ff ff       	call   2f <test2>

  // NÃºcleo
  test3();
  b2:	e8 ae ff ff ff       	call   65 <test3>

  exit (0);
  b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  be:	e8 08 00 00 00       	call   cb <exit>

000000c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  c3:	b8 01 00 00 00       	mov    $0x1,%eax
  c8:	cd 40                	int    $0x40
  ca:	c3                   	ret    

000000cb <exit>:
SYSCALL(exit)
  cb:	b8 02 00 00 00       	mov    $0x2,%eax
  d0:	cd 40                	int    $0x40
  d2:	c3                   	ret    

000000d3 <wait>:
SYSCALL(wait)
  d3:	b8 03 00 00 00       	mov    $0x3,%eax
  d8:	cd 40                	int    $0x40
  da:	c3                   	ret    

000000db <pipe>:
SYSCALL(pipe)
  db:	b8 04 00 00 00       	mov    $0x4,%eax
  e0:	cd 40                	int    $0x40
  e2:	c3                   	ret    

000000e3 <read>:
SYSCALL(read)
  e3:	b8 05 00 00 00       	mov    $0x5,%eax
  e8:	cd 40                	int    $0x40
  ea:	c3                   	ret    

000000eb <write>:
SYSCALL(write)
  eb:	b8 10 00 00 00       	mov    $0x10,%eax
  f0:	cd 40                	int    $0x40
  f2:	c3                   	ret    

000000f3 <close>:
SYSCALL(close)
  f3:	b8 15 00 00 00       	mov    $0x15,%eax
  f8:	cd 40                	int    $0x40
  fa:	c3                   	ret    

000000fb <kill>:
SYSCALL(kill)
  fb:	b8 06 00 00 00       	mov    $0x6,%eax
 100:	cd 40                	int    $0x40
 102:	c3                   	ret    

00000103 <exec>:
SYSCALL(exec)
 103:	b8 07 00 00 00       	mov    $0x7,%eax
 108:	cd 40                	int    $0x40
 10a:	c3                   	ret    

0000010b <open>:
SYSCALL(open)
 10b:	b8 0f 00 00 00       	mov    $0xf,%eax
 110:	cd 40                	int    $0x40
 112:	c3                   	ret    

00000113 <mknod>:
SYSCALL(mknod)
 113:	b8 11 00 00 00       	mov    $0x11,%eax
 118:	cd 40                	int    $0x40
 11a:	c3                   	ret    

0000011b <unlink>:
SYSCALL(unlink)
 11b:	b8 12 00 00 00       	mov    $0x12,%eax
 120:	cd 40                	int    $0x40
 122:	c3                   	ret    

00000123 <fstat>:
SYSCALL(fstat)
 123:	b8 08 00 00 00       	mov    $0x8,%eax
 128:	cd 40                	int    $0x40
 12a:	c3                   	ret    

0000012b <link>:
SYSCALL(link)
 12b:	b8 13 00 00 00       	mov    $0x13,%eax
 130:	cd 40                	int    $0x40
 132:	c3                   	ret    

00000133 <mkdir>:
SYSCALL(mkdir)
 133:	b8 14 00 00 00       	mov    $0x14,%eax
 138:	cd 40                	int    $0x40
 13a:	c3                   	ret    

0000013b <chdir>:
SYSCALL(chdir)
 13b:	b8 09 00 00 00       	mov    $0x9,%eax
 140:	cd 40                	int    $0x40
 142:	c3                   	ret    

00000143 <dup>:
SYSCALL(dup)
 143:	b8 0a 00 00 00       	mov    $0xa,%eax
 148:	cd 40                	int    $0x40
 14a:	c3                   	ret    

0000014b <dup2>:
SYSCALL(dup2)
 14b:	b8 17 00 00 00       	mov    $0x17,%eax
 150:	cd 40                	int    $0x40
 152:	c3                   	ret    

00000153 <getpid>:
SYSCALL(getpid)
 153:	b8 0b 00 00 00       	mov    $0xb,%eax
 158:	cd 40                	int    $0x40
 15a:	c3                   	ret    

0000015b <sbrk>:
SYSCALL(sbrk)
 15b:	b8 0c 00 00 00       	mov    $0xc,%eax
 160:	cd 40                	int    $0x40
 162:	c3                   	ret    

00000163 <sleep>:
SYSCALL(sleep)
 163:	b8 0d 00 00 00       	mov    $0xd,%eax
 168:	cd 40                	int    $0x40
 16a:	c3                   	ret    

0000016b <uptime>:
SYSCALL(uptime)
 16b:	b8 0e 00 00 00       	mov    $0xe,%eax
 170:	cd 40                	int    $0x40
 172:	c3                   	ret    

00000173 <date>:
SYSCALL(date)
 173:	b8 16 00 00 00       	mov    $0x16,%eax
 178:	cd 40                	int    $0x40
 17a:	c3                   	ret    

0000017b <getprio>:
SYSCALL(getprio)
 17b:	b8 18 00 00 00       	mov    $0x18,%eax
 180:	cd 40                	int    $0x40
 182:	c3                   	ret    

00000183 <setprio>:
SYSCALL(setprio)
 183:	b8 19 00 00 00       	mov    $0x19,%eax
 188:	cd 40                	int    $0x40
 18a:	c3                   	ret    

0000018b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	83 ec 1c             	sub    $0x1c,%esp
 191:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 194:	6a 01                	push   $0x1
 196:	8d 55 f4             	lea    -0xc(%ebp),%edx
 199:	52                   	push   %edx
 19a:	50                   	push   %eax
 19b:	e8 4b ff ff ff       	call   eb <write>
}
 1a0:	83 c4 10             	add    $0x10,%esp
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    

000001a5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	57                   	push   %edi
 1a9:	56                   	push   %esi
 1aa:	53                   	push   %ebx
 1ab:	83 ec 2c             	sub    $0x2c,%esp
 1ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1b1:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1b7:	74 04                	je     1bd <printint+0x18>
 1b9:	85 d2                	test   %edx,%edx
 1bb:	78 3a                	js     1f7 <printint+0x52>
  neg = 0;
 1bd:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1c9:	89 f0                	mov    %esi,%eax
 1cb:	ba 00 00 00 00       	mov    $0x0,%edx
 1d0:	f7 f1                	div    %ecx
 1d2:	89 df                	mov    %ebx,%edi
 1d4:	43                   	inc    %ebx
 1d5:	8a 92 04 04 00 00    	mov    0x404(%edx),%dl
 1db:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1df:	89 f2                	mov    %esi,%edx
 1e1:	89 c6                	mov    %eax,%esi
 1e3:	39 d1                	cmp    %edx,%ecx
 1e5:	76 e2                	jbe    1c9 <printint+0x24>
  if(neg)
 1e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1eb:	74 22                	je     20f <printint+0x6a>
    buf[i++] = '-';
 1ed:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1f2:	8d 5f 02             	lea    0x2(%edi),%ebx
 1f5:	eb 18                	jmp    20f <printint+0x6a>
    x = -xx;
 1f7:	f7 de                	neg    %esi
    neg = 1;
 1f9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 200:	eb c2                	jmp    1c4 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 202:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 207:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 20a:	e8 7c ff ff ff       	call   18b <putc>
  while(--i >= 0)
 20f:	4b                   	dec    %ebx
 210:	79 f0                	jns    202 <printint+0x5d>
}
 212:	83 c4 2c             	add    $0x2c,%esp
 215:	5b                   	pop    %ebx
 216:	5e                   	pop    %esi
 217:	5f                   	pop    %edi
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 21a:	f3 0f 1e fb          	endbr32 
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	57                   	push   %edi
 222:	56                   	push   %esi
 223:	53                   	push   %ebx
 224:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 227:	8d 45 10             	lea    0x10(%ebp),%eax
 22a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 22d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 232:	bb 00 00 00 00       	mov    $0x0,%ebx
 237:	eb 12                	jmp    24b <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 239:	89 fa                	mov    %edi,%edx
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	e8 48 ff ff ff       	call   18b <putc>
 243:	eb 05                	jmp    24a <printf+0x30>
      }
    } else if(state == '%'){
 245:	83 fe 25             	cmp    $0x25,%esi
 248:	74 22                	je     26c <printf+0x52>
  for(i = 0; fmt[i]; i++){
 24a:	43                   	inc    %ebx
 24b:	8b 45 0c             	mov    0xc(%ebp),%eax
 24e:	8a 04 18             	mov    (%eax,%ebx,1),%al
 251:	84 c0                	test   %al,%al
 253:	0f 84 13 01 00 00    	je     36c <printf+0x152>
    c = fmt[i] & 0xff;
 259:	0f be f8             	movsbl %al,%edi
 25c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 25f:	85 f6                	test   %esi,%esi
 261:	75 e2                	jne    245 <printf+0x2b>
      if(c == '%'){
 263:	83 f8 25             	cmp    $0x25,%eax
 266:	75 d1                	jne    239 <printf+0x1f>
        state = '%';
 268:	89 c6                	mov    %eax,%esi
 26a:	eb de                	jmp    24a <printf+0x30>
      if(c == 'd'){
 26c:	83 f8 64             	cmp    $0x64,%eax
 26f:	74 43                	je     2b4 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 271:	83 f8 78             	cmp    $0x78,%eax
 274:	74 68                	je     2de <printf+0xc4>
 276:	83 f8 70             	cmp    $0x70,%eax
 279:	74 63                	je     2de <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 27b:	83 f8 73             	cmp    $0x73,%eax
 27e:	0f 84 84 00 00 00    	je     308 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 284:	83 f8 63             	cmp    $0x63,%eax
 287:	0f 84 ad 00 00 00    	je     33a <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 28d:	83 f8 25             	cmp    $0x25,%eax
 290:	0f 84 c2 00 00 00    	je     358 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 296:	ba 25 00 00 00       	mov    $0x25,%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	e8 e8 fe ff ff       	call   18b <putc>
        putc(fd, c);
 2a3:	89 fa                	mov    %edi,%edx
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	e8 de fe ff ff       	call   18b <putc>
      }
      state = 0;
 2ad:	be 00 00 00 00       	mov    $0x0,%esi
 2b2:	eb 96                	jmp    24a <printf+0x30>
        printint(fd, *ap, 10, 1);
 2b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2b7:	8b 17                	mov    (%edi),%edx
 2b9:	83 ec 0c             	sub    $0xc,%esp
 2bc:	6a 01                	push   $0x1
 2be:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	e8 da fe ff ff       	call   1a5 <printint>
        ap++;
 2cb:	83 c7 04             	add    $0x4,%edi
 2ce:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2d4:	be 00 00 00 00       	mov    $0x0,%esi
 2d9:	e9 6c ff ff ff       	jmp    24a <printf+0x30>
        printint(fd, *ap, 16, 0);
 2de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2e1:	8b 17                	mov    (%edi),%edx
 2e3:	83 ec 0c             	sub    $0xc,%esp
 2e6:	6a 00                	push   $0x0
 2e8:	b9 10 00 00 00       	mov    $0x10,%ecx
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	e8 b0 fe ff ff       	call   1a5 <printint>
        ap++;
 2f5:	83 c7 04             	add    $0x4,%edi
 2f8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2fb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2fe:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 303:	e9 42 ff ff ff       	jmp    24a <printf+0x30>
        s = (char*)*ap;
 308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 30b:	8b 30                	mov    (%eax),%esi
        ap++;
 30d:	83 c0 04             	add    $0x4,%eax
 310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 313:	85 f6                	test   %esi,%esi
 315:	75 13                	jne    32a <printf+0x110>
          s = "(null)";
 317:	be fb 03 00 00       	mov    $0x3fb,%esi
 31c:	eb 0c                	jmp    32a <printf+0x110>
          putc(fd, *s);
 31e:	0f be d2             	movsbl %dl,%edx
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	e8 62 fe ff ff       	call   18b <putc>
          s++;
 329:	46                   	inc    %esi
        while(*s != 0){
 32a:	8a 16                	mov    (%esi),%dl
 32c:	84 d2                	test   %dl,%dl
 32e:	75 ee                	jne    31e <printf+0x104>
      state = 0;
 330:	be 00 00 00 00       	mov    $0x0,%esi
 335:	e9 10 ff ff ff       	jmp    24a <printf+0x30>
        putc(fd, *ap);
 33a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 33d:	0f be 17             	movsbl (%edi),%edx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	e8 43 fe ff ff       	call   18b <putc>
        ap++;
 348:	83 c7 04             	add    $0x4,%edi
 34b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 34e:	be 00 00 00 00       	mov    $0x0,%esi
 353:	e9 f2 fe ff ff       	jmp    24a <printf+0x30>
        putc(fd, c);
 358:	89 fa                	mov    %edi,%edx
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	e8 29 fe ff ff       	call   18b <putc>
      state = 0;
 362:	be 00 00 00 00       	mov    $0x0,%esi
 367:	e9 de fe ff ff       	jmp    24a <printf+0x30>
    }
  }
}
 36c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36f:	5b                   	pop    %ebx
 370:	5e                   	pop    %esi
 371:	5f                   	pop    %edi
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    
