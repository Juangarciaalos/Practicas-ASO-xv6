
tprio:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <do_calc>:
#include "types.h"
#include "user.h"

void
do_calc (char* nombre)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int r = 0;

  for (int i = 0; i < 3000; ++i)
  10:	be 00 00 00 00       	mov    $0x0,%esi
  int r = 0;
  15:	bb 00 00 00 00       	mov    $0x0,%ebx
  for (int i = 0; i < 3000; ++i)
  1a:	eb 01                	jmp    1d <do_calc+0x1d>
  1c:	46                   	inc    %esi
  1d:	81 fe b7 0b 00 00    	cmp    $0xbb7,%esi
  23:	7f 22                	jg     47 <do_calc+0x47>
  { printf(1, nombre);
  25:	83 ec 08             	sub    $0x8,%esp
  28:	57                   	push   %edi
  29:	6a 01                	push   $0x1
  2b:	e8 32 03 00 00       	call   362 <printf>
    for (int j = 0; j < 1000000; ++j)
  30:	83 c4 10             	add    $0x10,%esp
  33:	b8 00 00 00 00       	mov    $0x0,%eax
  38:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
  3d:	7f dd                	jg     1c <do_calc+0x1c>
      {  
        r += i + j;
  3f:	8d 14 06             	lea    (%esi,%eax,1),%edx
  42:	01 d3                	add    %edx,%ebx
    for (int j = 0; j < 1000000; ++j)
  44:	40                   	inc    %eax
  45:	eb f1                	jmp    38 <do_calc+0x38>
      }
  }
  // Imprime el resultado
  printf (1, "\n\n%s: %d prioridad: %d\n\n", nombre, r, getprio(getpid()));
  47:	e8 4f 02 00 00       	call   29b <getpid>
  4c:	83 ec 0c             	sub    $0xc,%esp
  4f:	50                   	push   %eax
  50:	e8 6e 02 00 00       	call   2c3 <getprio>
  55:	89 04 24             	mov    %eax,(%esp)
  58:	53                   	push   %ebx
  59:	57                   	push   %edi
  5a:	68 bc 04 00 00       	push   $0x4bc
  5f:	6a 01                	push   $0x1
  61:	e8 fc 02 00 00       	call   362 <printf>
}
  66:	83 c4 20             	add    $0x20,%esp
  69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  6c:	5b                   	pop    %ebx
  6d:	5e                   	pop    %esi
  6e:	5f                   	pop    %edi
  6f:	5d                   	pop    %ebp
  70:	c3                   	ret    

00000071 <main>:


int
main(int argc, char *argv[])
{
  71:	f3 0f 1e fb          	endbr32 
  75:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  79:	83 e4 f0             	and    $0xfffffff0,%esp
  7c:	ff 71 fc             	pushl  -0x4(%ecx)
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  82:	51                   	push   %ecx
  83:	83 ec 04             	sub    $0x4,%esp
  if (fork())
  86:	e8 80 01 00 00       	call   20b <fork>
  8b:	85 c0                	test   %eax,%eax
  8d:	74 0a                	je     99 <main+0x28>
    exit(0);
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	6a 00                	push   $0x0
  94:	e8 7a 01 00 00       	call   213 <exit>

  // El proceso se inicia en baja prioridad.
  // Genera otro proceso hijo que a su vez genera dos
  printf(1, "Hay 4 procesos de minima prioridad ejecutandose, asi que deberian verse intercalados.\n");
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 e4 04 00 00       	push   $0x4e4
  a1:	6a 01                	push   $0x1
  a3:	e8 ba 02 00 00       	call   362 <printf>

  if (fork() == 0)
  a8:	e8 5e 01 00 00       	call   20b <fork>
  ad:	83 c4 10             	add    $0x10,%esp
  b0:	85 c0                	test   %eax,%eax
  b2:	75 53                	jne    107 <main+0x96>
  {
    if (fork())  // Ambos ejecutan:
  b4:	e8 52 01 00 00       	call   20b <fork>
  b9:	85 c0                	test   %eax,%eax
  bb:	74 29                	je     e6 <main+0x75>
    {  setprio(getpid(), 9); do_calc("-"); }
  bd:	e8 d9 01 00 00       	call   29b <getpid>
  c2:	83 ec 08             	sub    $0x8,%esp
  c5:	6a 09                	push   $0x9
  c7:	50                   	push   %eax
  c8:	e8 fe 01 00 00       	call   2cb <setprio>
  cd:	c7 04 24 d5 04 00 00 	movl   $0x4d5,(%esp)
  d4:	e8 27 ff ff ff       	call   0 <do_calc>
  d9:	83 c4 10             	add    $0x10,%esp
    else
    {  setprio(getpid(), 9); do_calc("+");}
    
    exit(0);
  dc:	83 ec 0c             	sub    $0xc,%esp
  df:	6a 00                	push   $0x0
  e1:	e8 2d 01 00 00       	call   213 <exit>
    {  setprio(getpid(), 9); do_calc("+");}
  e6:	e8 b0 01 00 00       	call   29b <getpid>
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	6a 09                	push   $0x9
  f0:	50                   	push   %eax
  f1:	e8 d5 01 00 00       	call   2cb <setprio>
  f6:	c7 04 24 d7 04 00 00 	movl   $0x4d7,(%esp)
  fd:	e8 fe fe ff ff       	call   0 <do_calc>
 102:	83 c4 10             	add    $0x10,%esp
 105:	eb d5                	jmp    dc <main+0x6b>
  }

  if (fork() == 0)
 107:	e8 ff 00 00 00       	call   20b <fork>
 10c:	85 c0                	test   %eax,%eax
 10e:	75 53                	jne    163 <main+0xf2>
  {
    if (fork())  // Ambos ejecutan:
 110:	e8 f6 00 00 00       	call   20b <fork>
 115:	85 c0                	test   %eax,%eax
 117:	74 29                	je     142 <main+0xd1>
    {  setprio(getpid(), 5); do_calc("*"); }
 119:	e8 7d 01 00 00       	call   29b <getpid>
 11e:	83 ec 08             	sub    $0x8,%esp
 121:	6a 05                	push   $0x5
 123:	50                   	push   %eax
 124:	e8 a2 01 00 00       	call   2cb <setprio>
 129:	c7 04 24 d9 04 00 00 	movl   $0x4d9,(%esp)
 130:	e8 cb fe ff ff       	call   0 <do_calc>
 135:	83 c4 10             	add    $0x10,%esp
    else
    {  setprio(getpid(), 9); do_calc("^");}
    
    exit(0);
 138:	83 ec 0c             	sub    $0xc,%esp
 13b:	6a 00                	push   $0x0
 13d:	e8 d1 00 00 00       	call   213 <exit>
    {  setprio(getpid(), 9); do_calc("^");}
 142:	e8 54 01 00 00       	call   29b <getpid>
 147:	83 ec 08             	sub    $0x8,%esp
 14a:	6a 09                	push   $0x9
 14c:	50                   	push   %eax
 14d:	e8 79 01 00 00       	call   2cb <setprio>
 152:	c7 04 24 db 04 00 00 	movl   $0x4db,(%esp)
 159:	e8 a2 fe ff ff       	call   0 <do_calc>
 15e:	83 c4 10             	add    $0x10,%esp
 161:	eb d5                	jmp    138 <main+0xc7>
  }
  
  printf(1, "Me voy a dormir 10 segundos para que puedas interactuar con el shell. \
 163:	83 ec 08             	sub    $0x8,%esp
 166:	68 3c 05 00 00       	push   $0x53c
 16b:	6a 01                	push   $0x1
 16d:	e8 f0 01 00 00       	call   362 <printf>
  Como el shell tiene mÃ¡s prioridad que estos dos procesos, imprimirÃ¡ sin ser interrumpido por ellos.\n");
  sleep(500);
 172:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
 179:	e8 2d 01 00 00       	call   2ab <sleep>


  printf(1, "Y ahora se lanzan dos de alta prioridad. DeberÃ­an mostrarse las prioridades \
 17e:	83 c4 08             	add    $0x8,%esp
 181:	68 f0 05 00 00       	push   $0x5f0
 186:	6a 01                	push   $0x1
 188:	e8 d5 01 00 00       	call   362 <printf>
  en orden creciente conforme acaban los procesos, y el shell no deberÃ­a tener interacciÃ³n.\n");
  printf(1, "Cuando terminen los dos de alta prioridad, deberian seguir los de baja hasta terminar.\n");
 18d:	83 c4 08             	add    $0x8,%esp
 190:	68 a4 06 00 00       	push   $0x6a4
 195:	6a 01                	push   $0x1
 197:	e8 c6 01 00 00       	call   362 <printf>
  if (fork() == 0)
 19c:	e8 6a 00 00 00       	call   20b <fork>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	85 c0                	test   %eax,%eax
 1a6:	75 59                	jne    201 <main+0x190>
  {
    if (fork())  // Ambos ejecutan
 1a8:	e8 5e 00 00 00       	call   20b <fork>
 1ad:	85 c0                	test   %eax,%eax
 1af:	74 28                	je     1d9 <main+0x168>
    {  
      setprio (getpid(), 0); 
 1b1:	e8 e5 00 00 00       	call   29b <getpid>
 1b6:	83 ec 08             	sub    $0x8,%esp
 1b9:	6a 00                	push   $0x0
 1bb:	50                   	push   %eax
 1bc:	e8 0a 01 00 00       	call   2cb <setprio>
      do_calc("0");
 1c1:	c7 04 24 dd 04 00 00 	movl   $0x4dd,(%esp)
 1c8:	e8 33 fe ff ff       	call   0 <do_calc>
      exit(0);
 1cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d4:	e8 3a 00 00 00       	call   213 <exit>
    }
    else
    {  
      setprio (getpid(), 0+1); 
 1d9:	e8 bd 00 00 00       	call   29b <getpid>
 1de:	83 ec 08             	sub    $0x8,%esp
 1e1:	6a 01                	push   $0x1
 1e3:	50                   	push   %eax
 1e4:	e8 e2 00 00 00       	call   2cb <setprio>
      do_calc("1"); 
 1e9:	c7 04 24 df 04 00 00 	movl   $0x4df,(%esp)
 1f0:	e8 0b fe ff ff       	call   0 <do_calc>
      exit(0);}
 1f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1fc:	e8 12 00 00 00       	call   213 <exit>
  }

  exit(0);
 201:	83 ec 0c             	sub    $0xc,%esp
 204:	6a 00                	push   $0x0
 206:	e8 08 00 00 00       	call   213 <exit>

0000020b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20b:	b8 01 00 00 00       	mov    $0x1,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <exit>:
SYSCALL(exit)
 213:	b8 02 00 00 00       	mov    $0x2,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <wait>:
SYSCALL(wait)
 21b:	b8 03 00 00 00       	mov    $0x3,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <pipe>:
SYSCALL(pipe)
 223:	b8 04 00 00 00       	mov    $0x4,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <read>:
SYSCALL(read)
 22b:	b8 05 00 00 00       	mov    $0x5,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <write>:
SYSCALL(write)
 233:	b8 10 00 00 00       	mov    $0x10,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <close>:
SYSCALL(close)
 23b:	b8 15 00 00 00       	mov    $0x15,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <kill>:
SYSCALL(kill)
 243:	b8 06 00 00 00       	mov    $0x6,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <exec>:
SYSCALL(exec)
 24b:	b8 07 00 00 00       	mov    $0x7,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <open>:
SYSCALL(open)
 253:	b8 0f 00 00 00       	mov    $0xf,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <mknod>:
SYSCALL(mknod)
 25b:	b8 11 00 00 00       	mov    $0x11,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <unlink>:
SYSCALL(unlink)
 263:	b8 12 00 00 00       	mov    $0x12,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <fstat>:
SYSCALL(fstat)
 26b:	b8 08 00 00 00       	mov    $0x8,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <link>:
SYSCALL(link)
 273:	b8 13 00 00 00       	mov    $0x13,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <mkdir>:
SYSCALL(mkdir)
 27b:	b8 14 00 00 00       	mov    $0x14,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <chdir>:
SYSCALL(chdir)
 283:	b8 09 00 00 00       	mov    $0x9,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <dup>:
SYSCALL(dup)
 28b:	b8 0a 00 00 00       	mov    $0xa,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <dup2>:
SYSCALL(dup2)
 293:	b8 17 00 00 00       	mov    $0x17,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <getpid>:
SYSCALL(getpid)
 29b:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <sbrk>:
SYSCALL(sbrk)
 2a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <sleep>:
SYSCALL(sleep)
 2ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <uptime>:
SYSCALL(uptime)
 2b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <date>:
SYSCALL(date)
 2bb:	b8 16 00 00 00       	mov    $0x16,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <getprio>:
SYSCALL(getprio)
 2c3:	b8 18 00 00 00       	mov    $0x18,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <setprio>:
SYSCALL(setprio)
 2cb:	b8 19 00 00 00       	mov    $0x19,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 1c             	sub    $0x1c,%esp
 2d9:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2dc:	6a 01                	push   $0x1
 2de:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2e1:	52                   	push   %edx
 2e2:	50                   	push   %eax
 2e3:	e8 4b ff ff ff       	call   233 <write>
}
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	57                   	push   %edi
 2f1:	56                   	push   %esi
 2f2:	53                   	push   %ebx
 2f3:	83 ec 2c             	sub    $0x2c,%esp
 2f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2f9:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2ff:	74 04                	je     305 <printint+0x18>
 301:	85 d2                	test   %edx,%edx
 303:	78 3a                	js     33f <printint+0x52>
  neg = 0;
 305:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 30c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 311:	89 f0                	mov    %esi,%eax
 313:	ba 00 00 00 00       	mov    $0x0,%edx
 318:	f7 f1                	div    %ecx
 31a:	89 df                	mov    %ebx,%edi
 31c:	43                   	inc    %ebx
 31d:	8a 92 04 07 00 00    	mov    0x704(%edx),%dl
 323:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 327:	89 f2                	mov    %esi,%edx
 329:	89 c6                	mov    %eax,%esi
 32b:	39 d1                	cmp    %edx,%ecx
 32d:	76 e2                	jbe    311 <printint+0x24>
  if(neg)
 32f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 333:	74 22                	je     357 <printint+0x6a>
    buf[i++] = '-';
 335:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33a:	8d 5f 02             	lea    0x2(%edi),%ebx
 33d:	eb 18                	jmp    357 <printint+0x6a>
    x = -xx;
 33f:	f7 de                	neg    %esi
    neg = 1;
 341:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 348:	eb c2                	jmp    30c <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 34a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 34f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 352:	e8 7c ff ff ff       	call   2d3 <putc>
  while(--i >= 0)
 357:	4b                   	dec    %ebx
 358:	79 f0                	jns    34a <printint+0x5d>
}
 35a:	83 c4 2c             	add    $0x2c,%esp
 35d:	5b                   	pop    %ebx
 35e:	5e                   	pop    %esi
 35f:	5f                   	pop    %edi
 360:	5d                   	pop    %ebp
 361:	c3                   	ret    

00000362 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 362:	f3 0f 1e fb          	endbr32 
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	57                   	push   %edi
 36a:	56                   	push   %esi
 36b:	53                   	push   %ebx
 36c:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 36f:	8d 45 10             	lea    0x10(%ebp),%eax
 372:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 375:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 37a:	bb 00 00 00 00       	mov    $0x0,%ebx
 37f:	eb 12                	jmp    393 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 381:	89 fa                	mov    %edi,%edx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	e8 48 ff ff ff       	call   2d3 <putc>
 38b:	eb 05                	jmp    392 <printf+0x30>
      }
    } else if(state == '%'){
 38d:	83 fe 25             	cmp    $0x25,%esi
 390:	74 22                	je     3b4 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 392:	43                   	inc    %ebx
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	8a 04 18             	mov    (%eax,%ebx,1),%al
 399:	84 c0                	test   %al,%al
 39b:	0f 84 13 01 00 00    	je     4b4 <printf+0x152>
    c = fmt[i] & 0xff;
 3a1:	0f be f8             	movsbl %al,%edi
 3a4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a7:	85 f6                	test   %esi,%esi
 3a9:	75 e2                	jne    38d <printf+0x2b>
      if(c == '%'){
 3ab:	83 f8 25             	cmp    $0x25,%eax
 3ae:	75 d1                	jne    381 <printf+0x1f>
        state = '%';
 3b0:	89 c6                	mov    %eax,%esi
 3b2:	eb de                	jmp    392 <printf+0x30>
      if(c == 'd'){
 3b4:	83 f8 64             	cmp    $0x64,%eax
 3b7:	74 43                	je     3fc <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3b9:	83 f8 78             	cmp    $0x78,%eax
 3bc:	74 68                	je     426 <printf+0xc4>
 3be:	83 f8 70             	cmp    $0x70,%eax
 3c1:	74 63                	je     426 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3c3:	83 f8 73             	cmp    $0x73,%eax
 3c6:	0f 84 84 00 00 00    	je     450 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3cc:	83 f8 63             	cmp    $0x63,%eax
 3cf:	0f 84 ad 00 00 00    	je     482 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3d5:	83 f8 25             	cmp    $0x25,%eax
 3d8:	0f 84 c2 00 00 00    	je     4a0 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3de:	ba 25 00 00 00       	mov    $0x25,%edx
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	e8 e8 fe ff ff       	call   2d3 <putc>
        putc(fd, c);
 3eb:	89 fa                	mov    %edi,%edx
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	e8 de fe ff ff       	call   2d3 <putc>
      }
      state = 0;
 3f5:	be 00 00 00 00       	mov    $0x0,%esi
 3fa:	eb 96                	jmp    392 <printf+0x30>
        printint(fd, *ap, 10, 1);
 3fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ff:	8b 17                	mov    (%edi),%edx
 401:	83 ec 0c             	sub    $0xc,%esp
 404:	6a 01                	push   $0x1
 406:	b9 0a 00 00 00       	mov    $0xa,%ecx
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	e8 da fe ff ff       	call   2ed <printint>
        ap++;
 413:	83 c7 04             	add    $0x4,%edi
 416:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 419:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41c:	be 00 00 00 00       	mov    $0x0,%esi
 421:	e9 6c ff ff ff       	jmp    392 <printf+0x30>
        printint(fd, *ap, 16, 0);
 426:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 429:	8b 17                	mov    (%edi),%edx
 42b:	83 ec 0c             	sub    $0xc,%esp
 42e:	6a 00                	push   $0x0
 430:	b9 10 00 00 00       	mov    $0x10,%ecx
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	e8 b0 fe ff ff       	call   2ed <printint>
        ap++;
 43d:	83 c7 04             	add    $0x4,%edi
 440:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 443:	83 c4 10             	add    $0x10,%esp
      state = 0;
 446:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 44b:	e9 42 ff ff ff       	jmp    392 <printf+0x30>
        s = (char*)*ap;
 450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 453:	8b 30                	mov    (%eax),%esi
        ap++;
 455:	83 c0 04             	add    $0x4,%eax
 458:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 45b:	85 f6                	test   %esi,%esi
 45d:	75 13                	jne    472 <printf+0x110>
          s = "(null)";
 45f:	be fc 06 00 00       	mov    $0x6fc,%esi
 464:	eb 0c                	jmp    472 <printf+0x110>
          putc(fd, *s);
 466:	0f be d2             	movsbl %dl,%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	e8 62 fe ff ff       	call   2d3 <putc>
          s++;
 471:	46                   	inc    %esi
        while(*s != 0){
 472:	8a 16                	mov    (%esi),%dl
 474:	84 d2                	test   %dl,%dl
 476:	75 ee                	jne    466 <printf+0x104>
      state = 0;
 478:	be 00 00 00 00       	mov    $0x0,%esi
 47d:	e9 10 ff ff ff       	jmp    392 <printf+0x30>
        putc(fd, *ap);
 482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 485:	0f be 17             	movsbl (%edi),%edx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	e8 43 fe ff ff       	call   2d3 <putc>
        ap++;
 490:	83 c7 04             	add    $0x4,%edi
 493:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 496:	be 00 00 00 00       	mov    $0x0,%esi
 49b:	e9 f2 fe ff ff       	jmp    392 <printf+0x30>
        putc(fd, c);
 4a0:	89 fa                	mov    %edi,%edx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	e8 29 fe ff ff       	call   2d3 <putc>
      state = 0;
 4aa:	be 00 00 00 00       	mov    $0x0,%esi
 4af:	e9 de fe ff ff       	jmp    392 <printf+0x30>
    }
  }
}
 4b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b7:	5b                   	pop    %ebx
 4b8:	5e                   	pop    %esi
 4b9:	5f                   	pop    %edi
 4ba:	5d                   	pop    %ebp
 4bb:	c3                   	ret    
