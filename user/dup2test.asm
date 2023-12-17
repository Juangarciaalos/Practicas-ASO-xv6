
dup2test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char* argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  int fd;

  // Ejemplo de dup2 con un fd incorrecto
  if (dup2 (-1,8) >= 0)
  13:	83 ec 08             	sub    $0x8,%esp
  16:	6a 08                	push   $0x8
  18:	6a ff                	push   $0xffffffff
  1a:	e8 c2 03 00 00       	call   3e1 <dup2>
  1f:	83 c4 10             	add    $0x10,%esp
  22:	85 c0                	test   %eax,%eax
  24:	0f 89 ed 01 00 00    	jns    217 <main+0x217>
    printf (2, "dup2 no funciona con fd incorrecto.\n");

  // Ejemplo de dup2 con un newfd incorrecto
  if (dup2 (1,-1) >= 0)
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	6a ff                	push   $0xffffffff
  2f:	6a 01                	push   $0x1
  31:	e8 ab 03 00 00       	call   3e1 <dup2>
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	0f 89 ed 01 00 00    	jns    22e <main+0x22e>
    printf (2, "dup2 no funciona con fd incorrecto (2).\n");

  // Ejemplo de dup2 con un fd no mapeado
  if (dup2 (6,8) >= 0)
  41:	83 ec 08             	sub    $0x8,%esp
  44:	6a 08                	push   $0x8
  46:	6a 06                	push   $0x6
  48:	e8 94 03 00 00       	call   3e1 <dup2>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 c0                	test   %eax,%eax
  52:	0f 89 ed 01 00 00    	jns    245 <main+0x245>
    printf (2, "dup2 no funciona con fd no mapeado.\n");

  // Ejemplo de dup2 con un fd no mapeado (2)
  if (dup2 (8,1) >= 0)
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	6a 01                	push   $0x1
  5d:	6a 08                	push   $0x8
  5f:	e8 7d 03 00 00       	call   3e1 <dup2>
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 c0                	test   %eax,%eax
  69:	0f 89 ed 01 00 00    	jns    25c <main+0x25c>
    printf (2, "dup2 no funciona con fd no mapeado (2).\n");

  if (dup2 (1,25) >= 0)
  6f:	83 ec 08             	sub    $0x8,%esp
  72:	6a 19                	push   $0x19
  74:	6a 01                	push   $0x1
  76:	e8 66 03 00 00       	call   3e1 <dup2>
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	85 c0                	test   %eax,%eax
  80:	0f 89 ed 01 00 00    	jns    273 <main+0x273>
    printf (2, "dup2 no funciona con fd superior a NOFILE.\n");

  // Ejemplo de dup2 con fd existente
  if (dup2 (1,4) != 4)
  86:	83 ec 08             	sub    $0x8,%esp
  89:	6a 04                	push   $0x4
  8b:	6a 01                	push   $0x1
  8d:	e8 4f 03 00 00       	call   3e1 <dup2>
  92:	83 c4 10             	add    $0x10,%esp
  95:	83 f8 04             	cmp    $0x4,%eax
  98:	0f 85 ec 01 00 00    	jne    28a <main+0x28a>
    printf (2, "dup2 no funciona con fd existente.\n");

  printf (4, "Este mensaje debe salir por terminal.\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 04 07 00 00       	push   $0x704
  a6:	6a 04                	push   $0x4
  a8:	e8 03 04 00 00       	call   4b0 <printf>

  if (dup2 (4,6) != 6)
  ad:	83 c4 08             	add    $0x8,%esp
  b0:	6a 06                	push   $0x6
  b2:	6a 04                	push   $0x4
  b4:	e8 28 03 00 00       	call   3e1 <dup2>
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	83 f8 06             	cmp    $0x6,%eax
  bf:	0f 85 dc 01 00 00    	jne    2a1 <main+0x2a1>
    printf (2, "dup2 no funciona con fd existente (2).\n");

  printf (6, "Este mensaje debe salir por terminal (2).\n");
  c5:	83 ec 08             	sub    $0x8,%esp
  c8:	68 54 07 00 00       	push   $0x754
  cd:	6a 06                	push   $0x6
  cf:	e8 dc 03 00 00       	call   4b0 <printf>

  if (close (4) != 0)
  d4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  db:	e8 a9 02 00 00       	call   389 <close>
  e0:	83 c4 10             	add    $0x10,%esp
  e3:	85 c0                	test   %eax,%eax
  e5:	0f 85 cd 01 00 00    	jne    2b8 <main+0x2b8>
    printf (2, "Error en close (4)\n");
  printf (6, "Este mensaje debe salir por terminal (3).\n");
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	68 80 07 00 00       	push   $0x780
  f3:	6a 06                	push   $0x6
  f5:	e8 b6 03 00 00       	call   4b0 <printf>
  if (close (6) != 0)
  fa:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
 101:	e8 83 02 00 00       	call   389 <close>
 106:	83 c4 10             	add    $0x10,%esp
 109:	85 c0                	test   %eax,%eax
 10b:	0f 85 be 01 00 00    	jne    2cf <main+0x2cf>
    printf (2, "Error en close (6)\n");
  if (close (6) == 0)
 111:	83 ec 0c             	sub    $0xc,%esp
 114:	6a 06                	push   $0x6
 116:	e8 6e 02 00 00       	call   389 <close>
 11b:	83 c4 10             	add    $0x10,%esp
 11e:	85 c0                	test   %eax,%eax
 120:	0f 84 c0 01 00 00    	je     2e6 <main+0x2e6>
    printf (2, "Error en close (6) (2)\n");

  fd = open ("fichero_salida.txt", O_CREATE|O_RDWR);
 126:	83 ec 08             	sub    $0x8,%esp
 129:	68 02 02 00 00       	push   $0x202
 12e:	68 60 08 00 00       	push   $0x860
 133:	e8 69 02 00 00       	call   3a1 <open>
 138:	89 c3                	mov    %eax,%ebx
  printf (fd, "Salida a fichero\n");
 13a:	83 c4 08             	add    $0x8,%esp
 13d:	68 73 08 00 00       	push   $0x873
 142:	50                   	push   %eax
 143:	e8 68 03 00 00       	call   4b0 <printf>

  if (dup2 (fd, 9) != 9)
 148:	83 c4 08             	add    $0x8,%esp
 14b:	6a 09                	push   $0x9
 14d:	53                   	push   %ebx
 14e:	e8 8e 02 00 00       	call   3e1 <dup2>
 153:	83 c4 10             	add    $0x10,%esp
 156:	83 f8 09             	cmp    $0x9,%eax
 159:	0f 85 9e 01 00 00    	jne    2fd <main+0x2fd>
    printf (2, "dup2 no funciona con fd existente (3).\n");

  printf (9, "Salida tambiÃ©n a fichero.\n");
 15f:	83 ec 08             	sub    $0x8,%esp
 162:	68 85 08 00 00       	push   $0x885
 167:	6a 09                	push   $0x9
 169:	e8 42 03 00 00       	call   4b0 <printf>

  if (dup2 (9, 9) != 9)
 16e:	83 c4 08             	add    $0x8,%esp
 171:	6a 09                	push   $0x9
 173:	6a 09                	push   $0x9
 175:	e8 67 02 00 00       	call   3e1 <dup2>
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	83 f8 09             	cmp    $0x9,%eax
 180:	0f 85 8e 01 00 00    	jne    314 <main+0x314>
    printf (2, "dup2 no funciona con newfd=oldfd.\n");

  printf (9, "Salida tambiÃ©n a fichero.\n");
 186:	83 ec 08             	sub    $0x8,%esp
 189:	68 85 08 00 00       	push   $0x885
 18e:	6a 09                	push   $0x9
 190:	e8 1b 03 00 00       	call   4b0 <printf>

  close (9);
 195:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
 19c:	e8 e8 01 00 00       	call   389 <close>

  dup2 (1, 6);
 1a1:	83 c4 08             	add    $0x8,%esp
 1a4:	6a 06                	push   $0x6
 1a6:	6a 01                	push   $0x1
 1a8:	e8 34 02 00 00       	call   3e1 <dup2>

  if (dup2 (fd, 1) != 1)
 1ad:	83 c4 08             	add    $0x8,%esp
 1b0:	6a 01                	push   $0x1
 1b2:	53                   	push   %ebx
 1b3:	e8 29 02 00 00       	call   3e1 <dup2>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	83 f8 01             	cmp    $0x1,%eax
 1be:	0f 85 67 01 00 00    	jne    32b <main+0x32b>
    printf (2, "dup2 no funciona con fd existente (4).\n");

  printf (1, "Cuarta salida a fichero.\n");
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	68 a3 08 00 00       	push   $0x8a3
 1cc:	6a 01                	push   $0x1
 1ce:	e8 dd 02 00 00       	call   4b0 <printf>
  if (close (1) != 0)
 1d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1da:	e8 aa 01 00 00       	call   389 <close>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	85 c0                	test   %eax,%eax
 1e4:	0f 85 58 01 00 00    	jne    342 <main+0x342>
    printf (2, "Error en close (1).\n");

  dup2 (6,fd);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	53                   	push   %ebx
 1ee:	6a 06                	push   $0x6
 1f0:	e8 ec 01 00 00       	call   3e1 <dup2>

  printf (fd, "Este mensaje debe salir por terminal.\n");
 1f5:	83 c4 08             	add    $0x8,%esp
 1f8:	68 04 07 00 00       	push   $0x704
 1fd:	53                   	push   %ebx
 1fe:	e8 ad 02 00 00       	call   4b0 <printf>
  close (fd);
 203:	89 1c 24             	mov    %ebx,(%esp)
 206:	e8 7e 01 00 00       	call   389 <close>

  exit(0);
 20b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 212:	e8 4a 01 00 00       	call   361 <exit>
    printf (2, "dup2 no funciona con fd incorrecto.\n");
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	68 0c 06 00 00       	push   $0x60c
 21f:	6a 02                	push   $0x2
 221:	e8 8a 02 00 00       	call   4b0 <printf>
 226:	83 c4 10             	add    $0x10,%esp
 229:	e9 fc fd ff ff       	jmp    2a <main+0x2a>
    printf (2, "dup2 no funciona con fd incorrecto (2).\n");
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	68 34 06 00 00       	push   $0x634
 236:	6a 02                	push   $0x2
 238:	e8 73 02 00 00       	call   4b0 <printf>
 23d:	83 c4 10             	add    $0x10,%esp
 240:	e9 fc fd ff ff       	jmp    41 <main+0x41>
    printf (2, "dup2 no funciona con fd no mapeado.\n");
 245:	83 ec 08             	sub    $0x8,%esp
 248:	68 60 06 00 00       	push   $0x660
 24d:	6a 02                	push   $0x2
 24f:	e8 5c 02 00 00       	call   4b0 <printf>
 254:	83 c4 10             	add    $0x10,%esp
 257:	e9 fc fd ff ff       	jmp    58 <main+0x58>
    printf (2, "dup2 no funciona con fd no mapeado (2).\n");
 25c:	83 ec 08             	sub    $0x8,%esp
 25f:	68 88 06 00 00       	push   $0x688
 264:	6a 02                	push   $0x2
 266:	e8 45 02 00 00       	call   4b0 <printf>
 26b:	83 c4 10             	add    $0x10,%esp
 26e:	e9 fc fd ff ff       	jmp    6f <main+0x6f>
    printf (2, "dup2 no funciona con fd superior a NOFILE.\n");
 273:	83 ec 08             	sub    $0x8,%esp
 276:	68 b4 06 00 00       	push   $0x6b4
 27b:	6a 02                	push   $0x2
 27d:	e8 2e 02 00 00       	call   4b0 <printf>
 282:	83 c4 10             	add    $0x10,%esp
 285:	e9 fc fd ff ff       	jmp    86 <main+0x86>
    printf (2, "dup2 no funciona con fd existente.\n");
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	68 e0 06 00 00       	push   $0x6e0
 292:	6a 02                	push   $0x2
 294:	e8 17 02 00 00       	call   4b0 <printf>
 299:	83 c4 10             	add    $0x10,%esp
 29c:	e9 fd fd ff ff       	jmp    9e <main+0x9e>
    printf (2, "dup2 no funciona con fd existente (2).\n");
 2a1:	83 ec 08             	sub    $0x8,%esp
 2a4:	68 2c 07 00 00       	push   $0x72c
 2a9:	6a 02                	push   $0x2
 2ab:	e8 00 02 00 00       	call   4b0 <printf>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	e9 0d fe ff ff       	jmp    c5 <main+0xc5>
    printf (2, "Error en close (4)\n");
 2b8:	83 ec 08             	sub    $0x8,%esp
 2bb:	68 20 08 00 00       	push   $0x820
 2c0:	6a 02                	push   $0x2
 2c2:	e8 e9 01 00 00       	call   4b0 <printf>
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	e9 1c fe ff ff       	jmp    eb <main+0xeb>
    printf (2, "Error en close (6)\n");
 2cf:	83 ec 08             	sub    $0x8,%esp
 2d2:	68 34 08 00 00       	push   $0x834
 2d7:	6a 02                	push   $0x2
 2d9:	e8 d2 01 00 00       	call   4b0 <printf>
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	e9 2b fe ff ff       	jmp    111 <main+0x111>
    printf (2, "Error en close (6) (2)\n");
 2e6:	83 ec 08             	sub    $0x8,%esp
 2e9:	68 48 08 00 00       	push   $0x848
 2ee:	6a 02                	push   $0x2
 2f0:	e8 bb 01 00 00       	call   4b0 <printf>
 2f5:	83 c4 10             	add    $0x10,%esp
 2f8:	e9 29 fe ff ff       	jmp    126 <main+0x126>
    printf (2, "dup2 no funciona con fd existente (3).\n");
 2fd:	83 ec 08             	sub    $0x8,%esp
 300:	68 ac 07 00 00       	push   $0x7ac
 305:	6a 02                	push   $0x2
 307:	e8 a4 01 00 00       	call   4b0 <printf>
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	e9 4b fe ff ff       	jmp    15f <main+0x15f>
    printf (2, "dup2 no funciona con newfd=oldfd.\n");
 314:	83 ec 08             	sub    $0x8,%esp
 317:	68 d4 07 00 00       	push   $0x7d4
 31c:	6a 02                	push   $0x2
 31e:	e8 8d 01 00 00       	call   4b0 <printf>
 323:	83 c4 10             	add    $0x10,%esp
 326:	e9 5b fe ff ff       	jmp    186 <main+0x186>
    printf (2, "dup2 no funciona con fd existente (4).\n");
 32b:	83 ec 08             	sub    $0x8,%esp
 32e:	68 f8 07 00 00       	push   $0x7f8
 333:	6a 02                	push   $0x2
 335:	e8 76 01 00 00       	call   4b0 <printf>
 33a:	83 c4 10             	add    $0x10,%esp
 33d:	e9 82 fe ff ff       	jmp    1c4 <main+0x1c4>
    printf (2, "Error en close (1).\n");
 342:	83 ec 08             	sub    $0x8,%esp
 345:	68 bd 08 00 00       	push   $0x8bd
 34a:	6a 02                	push   $0x2
 34c:	e8 5f 01 00 00       	call   4b0 <printf>
 351:	83 c4 10             	add    $0x10,%esp
 354:	e9 91 fe ff ff       	jmp    1ea <main+0x1ea>

00000359 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 359:	b8 01 00 00 00       	mov    $0x1,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <exit>:
SYSCALL(exit)
 361:	b8 02 00 00 00       	mov    $0x2,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <wait>:
SYSCALL(wait)
 369:	b8 03 00 00 00       	mov    $0x3,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <pipe>:
SYSCALL(pipe)
 371:	b8 04 00 00 00       	mov    $0x4,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <read>:
SYSCALL(read)
 379:	b8 05 00 00 00       	mov    $0x5,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <write>:
SYSCALL(write)
 381:	b8 10 00 00 00       	mov    $0x10,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <close>:
SYSCALL(close)
 389:	b8 15 00 00 00       	mov    $0x15,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <kill>:
SYSCALL(kill)
 391:	b8 06 00 00 00       	mov    $0x6,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <exec>:
SYSCALL(exec)
 399:	b8 07 00 00 00       	mov    $0x7,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <open>:
SYSCALL(open)
 3a1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <mknod>:
SYSCALL(mknod)
 3a9:	b8 11 00 00 00       	mov    $0x11,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <unlink>:
SYSCALL(unlink)
 3b1:	b8 12 00 00 00       	mov    $0x12,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <fstat>:
SYSCALL(fstat)
 3b9:	b8 08 00 00 00       	mov    $0x8,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <link>:
SYSCALL(link)
 3c1:	b8 13 00 00 00       	mov    $0x13,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <mkdir>:
SYSCALL(mkdir)
 3c9:	b8 14 00 00 00       	mov    $0x14,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <chdir>:
SYSCALL(chdir)
 3d1:	b8 09 00 00 00       	mov    $0x9,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <dup>:
SYSCALL(dup)
 3d9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <dup2>:
SYSCALL(dup2)
 3e1:	b8 17 00 00 00       	mov    $0x17,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <getpid>:
SYSCALL(getpid)
 3e9:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <sbrk>:
SYSCALL(sbrk)
 3f1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <sleep>:
SYSCALL(sleep)
 3f9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <uptime>:
SYSCALL(uptime)
 401:	b8 0e 00 00 00       	mov    $0xe,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <date>:
SYSCALL(date)
 409:	b8 16 00 00 00       	mov    $0x16,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <getprio>:
SYSCALL(getprio)
 411:	b8 18 00 00 00       	mov    $0x18,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <setprio>:
SYSCALL(setprio)
 419:	b8 19 00 00 00       	mov    $0x19,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	83 ec 1c             	sub    $0x1c,%esp
 427:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 42a:	6a 01                	push   $0x1
 42c:	8d 55 f4             	lea    -0xc(%ebp),%edx
 42f:	52                   	push   %edx
 430:	50                   	push   %eax
 431:	e8 4b ff ff ff       	call   381 <write>
}
 436:	83 c4 10             	add    $0x10,%esp
 439:	c9                   	leave  
 43a:	c3                   	ret    

0000043b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	57                   	push   %edi
 43f:	56                   	push   %esi
 440:	53                   	push   %ebx
 441:	83 ec 2c             	sub    $0x2c,%esp
 444:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 447:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 44d:	74 04                	je     453 <printint+0x18>
 44f:	85 d2                	test   %edx,%edx
 451:	78 3a                	js     48d <printint+0x52>
  neg = 0;
 453:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 45a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 45f:	89 f0                	mov    %esi,%eax
 461:	ba 00 00 00 00       	mov    $0x0,%edx
 466:	f7 f1                	div    %ecx
 468:	89 df                	mov    %ebx,%edi
 46a:	43                   	inc    %ebx
 46b:	8a 92 dc 08 00 00    	mov    0x8dc(%edx),%dl
 471:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 475:	89 f2                	mov    %esi,%edx
 477:	89 c6                	mov    %eax,%esi
 479:	39 d1                	cmp    %edx,%ecx
 47b:	76 e2                	jbe    45f <printint+0x24>
  if(neg)
 47d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 481:	74 22                	je     4a5 <printint+0x6a>
    buf[i++] = '-';
 483:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 488:	8d 5f 02             	lea    0x2(%edi),%ebx
 48b:	eb 18                	jmp    4a5 <printint+0x6a>
    x = -xx;
 48d:	f7 de                	neg    %esi
    neg = 1;
 48f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 496:	eb c2                	jmp    45a <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 498:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 49d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4a0:	e8 7c ff ff ff       	call   421 <putc>
  while(--i >= 0)
 4a5:	4b                   	dec    %ebx
 4a6:	79 f0                	jns    498 <printint+0x5d>
}
 4a8:	83 c4 2c             	add    $0x2c,%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b0:	f3 0f 1e fb          	endbr32 
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	57                   	push   %edi
 4b8:	56                   	push   %esi
 4b9:	53                   	push   %ebx
 4ba:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4bd:	8d 45 10             	lea    0x10(%ebp),%eax
 4c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4c3:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4c8:	bb 00 00 00 00       	mov    $0x0,%ebx
 4cd:	eb 12                	jmp    4e1 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4cf:	89 fa                	mov    %edi,%edx
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	e8 48 ff ff ff       	call   421 <putc>
 4d9:	eb 05                	jmp    4e0 <printf+0x30>
      }
    } else if(state == '%'){
 4db:	83 fe 25             	cmp    $0x25,%esi
 4de:	74 22                	je     502 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 4e0:	43                   	inc    %ebx
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	8a 04 18             	mov    (%eax,%ebx,1),%al
 4e7:	84 c0                	test   %al,%al
 4e9:	0f 84 13 01 00 00    	je     602 <printf+0x152>
    c = fmt[i] & 0xff;
 4ef:	0f be f8             	movsbl %al,%edi
 4f2:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4f5:	85 f6                	test   %esi,%esi
 4f7:	75 e2                	jne    4db <printf+0x2b>
      if(c == '%'){
 4f9:	83 f8 25             	cmp    $0x25,%eax
 4fc:	75 d1                	jne    4cf <printf+0x1f>
        state = '%';
 4fe:	89 c6                	mov    %eax,%esi
 500:	eb de                	jmp    4e0 <printf+0x30>
      if(c == 'd'){
 502:	83 f8 64             	cmp    $0x64,%eax
 505:	74 43                	je     54a <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 507:	83 f8 78             	cmp    $0x78,%eax
 50a:	74 68                	je     574 <printf+0xc4>
 50c:	83 f8 70             	cmp    $0x70,%eax
 50f:	74 63                	je     574 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 511:	83 f8 73             	cmp    $0x73,%eax
 514:	0f 84 84 00 00 00    	je     59e <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51a:	83 f8 63             	cmp    $0x63,%eax
 51d:	0f 84 ad 00 00 00    	je     5d0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 523:	83 f8 25             	cmp    $0x25,%eax
 526:	0f 84 c2 00 00 00    	je     5ee <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 52c:	ba 25 00 00 00       	mov    $0x25,%edx
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	e8 e8 fe ff ff       	call   421 <putc>
        putc(fd, c);
 539:	89 fa                	mov    %edi,%edx
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	e8 de fe ff ff       	call   421 <putc>
      }
      state = 0;
 543:	be 00 00 00 00       	mov    $0x0,%esi
 548:	eb 96                	jmp    4e0 <printf+0x30>
        printint(fd, *ap, 10, 1);
 54a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 54d:	8b 17                	mov    (%edi),%edx
 54f:	83 ec 0c             	sub    $0xc,%esp
 552:	6a 01                	push   $0x1
 554:	b9 0a 00 00 00       	mov    $0xa,%ecx
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	e8 da fe ff ff       	call   43b <printint>
        ap++;
 561:	83 c7 04             	add    $0x4,%edi
 564:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 567:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56a:	be 00 00 00 00       	mov    $0x0,%esi
 56f:	e9 6c ff ff ff       	jmp    4e0 <printf+0x30>
        printint(fd, *ap, 16, 0);
 574:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 577:	8b 17                	mov    (%edi),%edx
 579:	83 ec 0c             	sub    $0xc,%esp
 57c:	6a 00                	push   $0x0
 57e:	b9 10 00 00 00       	mov    $0x10,%ecx
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	e8 b0 fe ff ff       	call   43b <printint>
        ap++;
 58b:	83 c7 04             	add    $0x4,%edi
 58e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 591:	83 c4 10             	add    $0x10,%esp
      state = 0;
 594:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 599:	e9 42 ff ff ff       	jmp    4e0 <printf+0x30>
        s = (char*)*ap;
 59e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a1:	8b 30                	mov    (%eax),%esi
        ap++;
 5a3:	83 c0 04             	add    $0x4,%eax
 5a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5a9:	85 f6                	test   %esi,%esi
 5ab:	75 13                	jne    5c0 <printf+0x110>
          s = "(null)";
 5ad:	be d2 08 00 00       	mov    $0x8d2,%esi
 5b2:	eb 0c                	jmp    5c0 <printf+0x110>
          putc(fd, *s);
 5b4:	0f be d2             	movsbl %dl,%edx
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	e8 62 fe ff ff       	call   421 <putc>
          s++;
 5bf:	46                   	inc    %esi
        while(*s != 0){
 5c0:	8a 16                	mov    (%esi),%dl
 5c2:	84 d2                	test   %dl,%dl
 5c4:	75 ee                	jne    5b4 <printf+0x104>
      state = 0;
 5c6:	be 00 00 00 00       	mov    $0x0,%esi
 5cb:	e9 10 ff ff ff       	jmp    4e0 <printf+0x30>
        putc(fd, *ap);
 5d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5d3:	0f be 17             	movsbl (%edi),%edx
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	e8 43 fe ff ff       	call   421 <putc>
        ap++;
 5de:	83 c7 04             	add    $0x4,%edi
 5e1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e4:	be 00 00 00 00       	mov    $0x0,%esi
 5e9:	e9 f2 fe ff ff       	jmp    4e0 <printf+0x30>
        putc(fd, c);
 5ee:	89 fa                	mov    %edi,%edx
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	e8 29 fe ff ff       	call   421 <putc>
      state = 0;
 5f8:	be 00 00 00 00       	mov    $0x0,%esi
 5fd:	e9 de fe ff ff       	jmp    4e0 <printf+0x30>
    }
  }
}
 602:	8d 65 f4             	lea    -0xc(%ebp),%esp
 605:	5b                   	pop    %ebx
 606:	5e                   	pop    %esi
 607:	5f                   	pop    %edi
 608:	5d                   	pop    %ebp
 609:	c3                   	ret    
