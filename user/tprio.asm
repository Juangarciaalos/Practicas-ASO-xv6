
tprio:     file format elf32-i386


Disassembly of section .text:

00000000 <do_calc>:
#include "types.h"
#include "user.h"

void
do_calc (char* nombre)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int r = 0;

  for (int i = 0; i < 3000; ++i)
   c:	be 00 00 00 00       	mov    $0x0,%esi
  int r = 0;
  11:	bb 00 00 00 00       	mov    $0x0,%ebx
  for (int i = 0; i < 3000; ++i)
  16:	eb 0e                	jmp    26 <do_calc+0x26>
  { printf(1, nombre);
    for (int j = 0; j < 1000000; ++j)
      {  
        r += i + j;
  18:	8d 14 06             	lea    (%esi,%eax,1),%edx
  1b:	01 d3                	add    %edx,%ebx
    for (int j = 0; j < 1000000; ++j)
  1d:	40                   	inc    %eax
  1e:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
  23:	7e f3                	jle    18 <do_calc+0x18>
  for (int i = 0; i < 3000; ++i)
  25:	46                   	inc    %esi
  26:	81 fe b7 0b 00 00    	cmp    $0xbb7,%esi
  2c:	7f 15                	jg     43 <do_calc+0x43>
  { printf(1, nombre);
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	57                   	push   %edi
  32:	6a 01                	push   $0x1
  34:	e8 25 03 00 00       	call   35e <printf>
    for (int j = 0; j < 1000000; ++j)
  39:	83 c4 10             	add    $0x10,%esp
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
  41:	eb db                	jmp    1e <do_calc+0x1e>
      }
  }
  // Imprime el resultado
  printf (1, "\n\n%s: %d prioridad: %d\n\n", nombre, r, getprio(getpid()));
  43:	e8 4b 02 00 00       	call   293 <getpid>
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	50                   	push   %eax
  4c:	e8 6a 02 00 00       	call   2bb <getprio>
  51:	89 04 24             	mov    %eax,(%esp)
  54:	53                   	push   %ebx
  55:	57                   	push   %edi
  56:	68 c0 04 00 00       	push   $0x4c0
  5b:	6a 01                	push   $0x1
  5d:	e8 fc 02 00 00       	call   35e <printf>
}
  62:	83 c4 20             	add    $0x20,%esp
  65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  68:	5b                   	pop    %ebx
  69:	5e                   	pop    %esi
  6a:	5f                   	pop    %edi
  6b:	5d                   	pop    %ebp
  6c:	c3                   	ret    

0000006d <main>:


int
main(int argc, char *argv[])
{
  6d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  71:	83 e4 f0             	and    $0xfffffff0,%esp
  74:	ff 71 fc             	push   -0x4(%ecx)
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	51                   	push   %ecx
  7b:	83 ec 04             	sub    $0x4,%esp
  if (fork())
  7e:	e8 80 01 00 00       	call   203 <fork>
  83:	85 c0                	test   %eax,%eax
  85:	74 0a                	je     91 <main+0x24>
    exit(0);
  87:	83 ec 0c             	sub    $0xc,%esp
  8a:	6a 00                	push   $0x0
  8c:	e8 7a 01 00 00       	call   20b <exit>

  // El proceso se inicia en baja prioridad.
  // Genera otro proceso hijo que a su vez genera dos
  printf(1, "Hay 4 procesos de minima prioridad ejecutandose, asi que deberian verse intercalados.\n");
  91:	83 ec 08             	sub    $0x8,%esp
  94:	68 e8 04 00 00       	push   $0x4e8
  99:	6a 01                	push   $0x1
  9b:	e8 be 02 00 00       	call   35e <printf>

  if (fork() == 0)
  a0:	e8 5e 01 00 00       	call   203 <fork>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	85 c0                	test   %eax,%eax
  aa:	75 53                	jne    ff <main+0x92>
  {
    if (fork())  // Ambos ejecutan:
  ac:	e8 52 01 00 00       	call   203 <fork>
  b1:	85 c0                	test   %eax,%eax
  b3:	74 29                	je     de <main+0x71>
    {  setprio(getpid(), 9); do_calc("-"); }
  b5:	e8 d9 01 00 00       	call   293 <getpid>
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	6a 09                	push   $0x9
  bf:	50                   	push   %eax
  c0:	e8 fe 01 00 00       	call   2c3 <setprio>
  c5:	c7 04 24 d9 04 00 00 	movl   $0x4d9,(%esp)
  cc:	e8 2f ff ff ff       	call   0 <do_calc>
  d1:	83 c4 10             	add    $0x10,%esp
    else
    {  setprio(getpid(), 9); do_calc("+");}
    
    exit(0);
  d4:	83 ec 0c             	sub    $0xc,%esp
  d7:	6a 00                	push   $0x0
  d9:	e8 2d 01 00 00       	call   20b <exit>
    {  setprio(getpid(), 9); do_calc("+");}
  de:	e8 b0 01 00 00       	call   293 <getpid>
  e3:	83 ec 08             	sub    $0x8,%esp
  e6:	6a 09                	push   $0x9
  e8:	50                   	push   %eax
  e9:	e8 d5 01 00 00       	call   2c3 <setprio>
  ee:	c7 04 24 db 04 00 00 	movl   $0x4db,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <do_calc>
  fa:	83 c4 10             	add    $0x10,%esp
  fd:	eb d5                	jmp    d4 <main+0x67>
  }

  if (fork() == 0)
  ff:	e8 ff 00 00 00       	call   203 <fork>
 104:	85 c0                	test   %eax,%eax
 106:	75 53                	jne    15b <main+0xee>
  {
    if (fork())  // Ambos ejecutan:
 108:	e8 f6 00 00 00       	call   203 <fork>
 10d:	85 c0                	test   %eax,%eax
 10f:	74 29                	je     13a <main+0xcd>
    {  setprio(getpid(), 5); do_calc("*"); }
 111:	e8 7d 01 00 00       	call   293 <getpid>
 116:	83 ec 08             	sub    $0x8,%esp
 119:	6a 05                	push   $0x5
 11b:	50                   	push   %eax
 11c:	e8 a2 01 00 00       	call   2c3 <setprio>
 121:	c7 04 24 dd 04 00 00 	movl   $0x4dd,(%esp)
 128:	e8 d3 fe ff ff       	call   0 <do_calc>
 12d:	83 c4 10             	add    $0x10,%esp
    else
    {  setprio(getpid(), 9); do_calc("^");}
    
    exit(0);
 130:	83 ec 0c             	sub    $0xc,%esp
 133:	6a 00                	push   $0x0
 135:	e8 d1 00 00 00       	call   20b <exit>
    {  setprio(getpid(), 9); do_calc("^");}
 13a:	e8 54 01 00 00       	call   293 <getpid>
 13f:	83 ec 08             	sub    $0x8,%esp
 142:	6a 09                	push   $0x9
 144:	50                   	push   %eax
 145:	e8 79 01 00 00       	call   2c3 <setprio>
 14a:	c7 04 24 df 04 00 00 	movl   $0x4df,(%esp)
 151:	e8 aa fe ff ff       	call   0 <do_calc>
 156:	83 c4 10             	add    $0x10,%esp
 159:	eb d5                	jmp    130 <main+0xc3>
  }
  
  printf(1, "Me voy a dormir 10 segundos para que puedas interactuar con el shell. \
 15b:	83 ec 08             	sub    $0x8,%esp
 15e:	68 40 05 00 00       	push   $0x540
 163:	6a 01                	push   $0x1
 165:	e8 f4 01 00 00       	call   35e <printf>
  Como el shell tiene mÃ¡s prioridad que estos dos procesos, imprimirÃ¡ sin ser interrumpido por ellos.\n");
  sleep(500);
 16a:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
 171:	e8 2d 01 00 00       	call   2a3 <sleep>


  printf(1, "Y ahora se lanzan dos de alta prioridad. DeberÃ­an mostrarse las prioridades \
 176:	83 c4 08             	add    $0x8,%esp
 179:	68 f4 05 00 00       	push   $0x5f4
 17e:	6a 01                	push   $0x1
 180:	e8 d9 01 00 00       	call   35e <printf>
  en orden creciente conforme acaban los procesos, y el shell no deberÃ­a tener interacciÃ³n.\n");
  printf(1, "Cuando terminen los dos de alta prioridad, deberian seguir los de baja hasta terminar.\n");
 185:	83 c4 08             	add    $0x8,%esp
 188:	68 a8 06 00 00       	push   $0x6a8
 18d:	6a 01                	push   $0x1
 18f:	e8 ca 01 00 00       	call   35e <printf>
  if (fork() == 0)
 194:	e8 6a 00 00 00       	call   203 <fork>
 199:	83 c4 10             	add    $0x10,%esp
 19c:	85 c0                	test   %eax,%eax
 19e:	75 59                	jne    1f9 <main+0x18c>
  {
    if (fork())  // Ambos ejecutan
 1a0:	e8 5e 00 00 00       	call   203 <fork>
 1a5:	85 c0                	test   %eax,%eax
 1a7:	74 28                	je     1d1 <main+0x164>
    {  
      setprio (getpid(), 0); 
 1a9:	e8 e5 00 00 00       	call   293 <getpid>
 1ae:	83 ec 08             	sub    $0x8,%esp
 1b1:	6a 00                	push   $0x0
 1b3:	50                   	push   %eax
 1b4:	e8 0a 01 00 00       	call   2c3 <setprio>
      do_calc("0");
 1b9:	c7 04 24 e1 04 00 00 	movl   $0x4e1,(%esp)
 1c0:	e8 3b fe ff ff       	call   0 <do_calc>
      exit(0);
 1c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1cc:	e8 3a 00 00 00       	call   20b <exit>
    }
    else
    {  
      setprio (getpid(), 0+1); 
 1d1:	e8 bd 00 00 00       	call   293 <getpid>
 1d6:	83 ec 08             	sub    $0x8,%esp
 1d9:	6a 01                	push   $0x1
 1db:	50                   	push   %eax
 1dc:	e8 e2 00 00 00       	call   2c3 <setprio>
      do_calc("1"); 
 1e1:	c7 04 24 e3 04 00 00 	movl   $0x4e3,(%esp)
 1e8:	e8 13 fe ff ff       	call   0 <do_calc>
      exit(0);}
 1ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f4:	e8 12 00 00 00       	call   20b <exit>
  }

  exit(0);
 1f9:	83 ec 0c             	sub    $0xc,%esp
 1fc:	6a 00                	push   $0x0
 1fe:	e8 08 00 00 00       	call   20b <exit>

00000203 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 203:	b8 01 00 00 00       	mov    $0x1,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <exit>:
SYSCALL(exit)
 20b:	b8 02 00 00 00       	mov    $0x2,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <wait>:
SYSCALL(wait)
 213:	b8 03 00 00 00       	mov    $0x3,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <pipe>:
SYSCALL(pipe)
 21b:	b8 04 00 00 00       	mov    $0x4,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <read>:
SYSCALL(read)
 223:	b8 05 00 00 00       	mov    $0x5,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <write>:
SYSCALL(write)
 22b:	b8 10 00 00 00       	mov    $0x10,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <close>:
SYSCALL(close)
 233:	b8 15 00 00 00       	mov    $0x15,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <kill>:
SYSCALL(kill)
 23b:	b8 06 00 00 00       	mov    $0x6,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <exec>:
SYSCALL(exec)
 243:	b8 07 00 00 00       	mov    $0x7,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <open>:
SYSCALL(open)
 24b:	b8 0f 00 00 00       	mov    $0xf,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <mknod>:
SYSCALL(mknod)
 253:	b8 11 00 00 00       	mov    $0x11,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <unlink>:
SYSCALL(unlink)
 25b:	b8 12 00 00 00       	mov    $0x12,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <fstat>:
SYSCALL(fstat)
 263:	b8 08 00 00 00       	mov    $0x8,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <link>:
SYSCALL(link)
 26b:	b8 13 00 00 00       	mov    $0x13,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <mkdir>:
SYSCALL(mkdir)
 273:	b8 14 00 00 00       	mov    $0x14,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <chdir>:
SYSCALL(chdir)
 27b:	b8 09 00 00 00       	mov    $0x9,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <dup>:
SYSCALL(dup)
 283:	b8 0a 00 00 00       	mov    $0xa,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <dup2>:
SYSCALL(dup2)
 28b:	b8 17 00 00 00       	mov    $0x17,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <getpid>:
SYSCALL(getpid)
 293:	b8 0b 00 00 00       	mov    $0xb,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <sbrk>:
SYSCALL(sbrk)
 29b:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <sleep>:
SYSCALL(sleep)
 2a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <uptime>:
SYSCALL(uptime)
 2ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <date>:
SYSCALL(date)
 2b3:	b8 16 00 00 00       	mov    $0x16,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <getprio>:
SYSCALL(getprio)
 2bb:	b8 18 00 00 00       	mov    $0x18,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <setprio>:
SYSCALL(setprio)
 2c3:	b8 19 00 00 00       	mov    $0x19,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	83 ec 1c             	sub    $0x1c,%esp
 2d1:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2d4:	6a 01                	push   $0x1
 2d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d9:	52                   	push   %edx
 2da:	50                   	push   %eax
 2db:	e8 4b ff ff ff       	call   22b <write>
}
 2e0:	83 c4 10             	add    $0x10,%esp
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	57                   	push   %edi
 2e9:	56                   	push   %esi
 2ea:	53                   	push   %ebx
 2eb:	83 ec 2c             	sub    $0x2c,%esp
 2ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2f1:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f7:	74 04                	je     2fd <printint+0x18>
 2f9:	85 d2                	test   %edx,%edx
 2fb:	78 3c                	js     339 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2fd:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2ff:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 306:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 30b:	89 c8                	mov    %ecx,%eax
 30d:	ba 00 00 00 00       	mov    $0x0,%edx
 312:	f7 f6                	div    %esi
 314:	89 df                	mov    %ebx,%edi
 316:	43                   	inc    %ebx
 317:	8a 92 60 07 00 00    	mov    0x760(%edx),%dl
 31d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 321:	89 ca                	mov    %ecx,%edx
 323:	89 c1                	mov    %eax,%ecx
 325:	39 d6                	cmp    %edx,%esi
 327:	76 e2                	jbe    30b <printint+0x26>
  if(neg)
 329:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 32d:	74 24                	je     353 <printint+0x6e>
    buf[i++] = '-';
 32f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 334:	8d 5f 02             	lea    0x2(%edi),%ebx
 337:	eb 1a                	jmp    353 <printint+0x6e>
    x = -xx;
 339:	89 d1                	mov    %edx,%ecx
 33b:	f7 d9                	neg    %ecx
    neg = 1;
 33d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 344:	eb c0                	jmp    306 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 346:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 34b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 34e:	e8 78 ff ff ff       	call   2cb <putc>
  while(--i >= 0)
 353:	4b                   	dec    %ebx
 354:	79 f0                	jns    346 <printint+0x61>
}
 356:	83 c4 2c             	add    $0x2c,%esp
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5f                   	pop    %edi
 35c:	5d                   	pop    %ebp
 35d:	c3                   	ret    

0000035e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	57                   	push   %edi
 362:	56                   	push   %esi
 363:	53                   	push   %ebx
 364:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 367:	8d 45 10             	lea    0x10(%ebp),%eax
 36a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 36d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 372:	bb 00 00 00 00       	mov    $0x0,%ebx
 377:	eb 12                	jmp    38b <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 379:	89 fa                	mov    %edi,%edx
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	e8 48 ff ff ff       	call   2cb <putc>
 383:	eb 05                	jmp    38a <printf+0x2c>
      }
    } else if(state == '%'){
 385:	83 fe 25             	cmp    $0x25,%esi
 388:	74 22                	je     3ac <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 38a:	43                   	inc    %ebx
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	8a 04 18             	mov    (%eax,%ebx,1),%al
 391:	84 c0                	test   %al,%al
 393:	0f 84 1d 01 00 00    	je     4b6 <printf+0x158>
    c = fmt[i] & 0xff;
 399:	0f be f8             	movsbl %al,%edi
 39c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 39f:	85 f6                	test   %esi,%esi
 3a1:	75 e2                	jne    385 <printf+0x27>
      if(c == '%'){
 3a3:	83 f8 25             	cmp    $0x25,%eax
 3a6:	75 d1                	jne    379 <printf+0x1b>
        state = '%';
 3a8:	89 c6                	mov    %eax,%esi
 3aa:	eb de                	jmp    38a <printf+0x2c>
      if(c == 'd'){
 3ac:	83 f8 25             	cmp    $0x25,%eax
 3af:	0f 84 cc 00 00 00    	je     481 <printf+0x123>
 3b5:	0f 8c da 00 00 00    	jl     495 <printf+0x137>
 3bb:	83 f8 78             	cmp    $0x78,%eax
 3be:	0f 8f d1 00 00 00    	jg     495 <printf+0x137>
 3c4:	83 f8 63             	cmp    $0x63,%eax
 3c7:	0f 8c c8 00 00 00    	jl     495 <printf+0x137>
 3cd:	83 e8 63             	sub    $0x63,%eax
 3d0:	83 f8 15             	cmp    $0x15,%eax
 3d3:	0f 87 bc 00 00 00    	ja     495 <printf+0x137>
 3d9:	ff 24 85 08 07 00 00 	jmp    *0x708(,%eax,4)
        printint(fd, *ap, 10, 1);
 3e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3e3:	8b 17                	mov    (%edi),%edx
 3e5:	83 ec 0c             	sub    $0xc,%esp
 3e8:	6a 01                	push   $0x1
 3ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	e8 ee fe ff ff       	call   2e5 <printint>
        ap++;
 3f7:	83 c7 04             	add    $0x4,%edi
 3fa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3fd:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 400:	be 00 00 00 00       	mov    $0x0,%esi
 405:	eb 83                	jmp    38a <printf+0x2c>
        printint(fd, *ap, 16, 0);
 407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 40a:	8b 17                	mov    (%edi),%edx
 40c:	83 ec 0c             	sub    $0xc,%esp
 40f:	6a 00                	push   $0x0
 411:	b9 10 00 00 00       	mov    $0x10,%ecx
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	e8 c7 fe ff ff       	call   2e5 <printint>
        ap++;
 41e:	83 c7 04             	add    $0x4,%edi
 421:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 424:	83 c4 10             	add    $0x10,%esp
      state = 0;
 427:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 42c:	e9 59 ff ff ff       	jmp    38a <printf+0x2c>
        s = (char*)*ap;
 431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 434:	8b 30                	mov    (%eax),%esi
        ap++;
 436:	83 c0 04             	add    $0x4,%eax
 439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 43c:	85 f6                	test   %esi,%esi
 43e:	75 13                	jne    453 <printf+0xf5>
          s = "(null)";
 440:	be 00 07 00 00       	mov    $0x700,%esi
 445:	eb 0c                	jmp    453 <printf+0xf5>
          putc(fd, *s);
 447:	0f be d2             	movsbl %dl,%edx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	e8 79 fe ff ff       	call   2cb <putc>
          s++;
 452:	46                   	inc    %esi
        while(*s != 0){
 453:	8a 16                	mov    (%esi),%dl
 455:	84 d2                	test   %dl,%dl
 457:	75 ee                	jne    447 <printf+0xe9>
      state = 0;
 459:	be 00 00 00 00       	mov    $0x0,%esi
 45e:	e9 27 ff ff ff       	jmp    38a <printf+0x2c>
        putc(fd, *ap);
 463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 466:	0f be 17             	movsbl (%edi),%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	e8 5a fe ff ff       	call   2cb <putc>
        ap++;
 471:	83 c7 04             	add    $0x4,%edi
 474:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 477:	be 00 00 00 00       	mov    $0x0,%esi
 47c:	e9 09 ff ff ff       	jmp    38a <printf+0x2c>
        putc(fd, c);
 481:	89 fa                	mov    %edi,%edx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	e8 40 fe ff ff       	call   2cb <putc>
      state = 0;
 48b:	be 00 00 00 00       	mov    $0x0,%esi
 490:	e9 f5 fe ff ff       	jmp    38a <printf+0x2c>
        putc(fd, '%');
 495:	ba 25 00 00 00       	mov    $0x25,%edx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	e8 29 fe ff ff       	call   2cb <putc>
        putc(fd, c);
 4a2:	89 fa                	mov    %edi,%edx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	e8 1f fe ff ff       	call   2cb <putc>
      state = 0;
 4ac:	be 00 00 00 00       	mov    $0x0,%esi
 4b1:	e9 d4 fe ff ff       	jmp    38a <printf+0x2c>
    }
  }
}
 4b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b9:	5b                   	pop    %ebx
 4ba:	5e                   	pop    %esi
 4bb:	5f                   	pop    %edi
 4bc:	5d                   	pop    %ebp
 4bd:	c3                   	ret    
