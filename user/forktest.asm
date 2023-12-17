
forktest:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 10             	sub    $0x10,%esp
   b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   e:	53                   	push   %ebx
   f:	e8 64 01 00 00       	call   178 <strlen>
  14:	83 c4 0c             	add    $0xc,%esp
  17:	50                   	push   %eax
  18:	53                   	push   %ebx
  19:	ff 75 08             	pushl  0x8(%ebp)
  1c:	e8 ce 02 00 00       	call   2ef <write>
}
  21:	83 c4 10             	add    $0x10,%esp
  24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	f3 0f 1e fb          	endbr32 
  2d:	55                   	push   %ebp
  2e:	89 e5                	mov    %esp,%ebp
  30:	53                   	push   %ebx
  31:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
  34:	68 90 03 00 00       	push   $0x390
  39:	6a 01                	push   $0x1
  3b:	e8 c0 ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  40:	83 c4 10             	add    $0x10,%esp
  43:	bb 00 00 00 00       	mov    $0x0,%ebx
  48:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  4e:	7f 18                	jg     68 <forktest+0x3f>
    pid = fork();
  50:	e8 72 02 00 00       	call   2c7 <fork>
    if(pid < 0)
  55:	85 c0                	test   %eax,%eax
  57:	78 0f                	js     68 <forktest+0x3f>
      break;
    if(pid == 0)
  59:	74 03                	je     5e <forktest+0x35>
  for(n=0; n<N; n++){
  5b:	43                   	inc    %ebx
  5c:	eb ea                	jmp    48 <forktest+0x1f>
      exit(0);
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	6a 00                	push   $0x0
  63:	e8 67 02 00 00       	call   2cf <exit>
  }

  if(n == N){
  68:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  6e:	74 18                	je     88 <forktest+0x5f>
    printf(1, "fork claimed to work N times!\n", N);
    exit(0);
  }

  for(; n > 0; n--){
  70:	85 db                	test   %ebx,%ebx
  72:	7e 4f                	jle    c3 <forktest+0x9a>
    if(wait(NULL) < 0){
  74:	83 ec 0c             	sub    $0xc,%esp
  77:	6a 00                	push   $0x0
  79:	e8 59 02 00 00       	call   2d7 <wait>
  7e:	83 c4 10             	add    $0x10,%esp
  81:	85 c0                	test   %eax,%eax
  83:	78 23                	js     a8 <forktest+0x7f>
  for(; n > 0; n--){
  85:	4b                   	dec    %ebx
  86:	eb e8                	jmp    70 <forktest+0x47>
    printf(1, "fork claimed to work N times!\n", N);
  88:	83 ec 04             	sub    $0x4,%esp
  8b:	68 e8 03 00 00       	push   $0x3e8
  90:	68 d0 03 00 00       	push   $0x3d0
  95:	6a 01                	push   $0x1
  97:	e8 64 ff ff ff       	call   0 <printf>
    exit(0);
  9c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a3:	e8 27 02 00 00       	call   2cf <exit>
      printf(1, "wait stopped early\n");
  a8:	83 ec 08             	sub    $0x8,%esp
  ab:	68 9b 03 00 00       	push   $0x39b
  b0:	6a 01                	push   $0x1
  b2:	e8 49 ff ff ff       	call   0 <printf>
      exit(0);
  b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  be:	e8 0c 02 00 00       	call   2cf <exit>
    }
  }

  if(wait(NULL) != -1){
  c3:	83 ec 0c             	sub    $0xc,%esp
  c6:	6a 00                	push   $0x0
  c8:	e8 0a 02 00 00       	call   2d7 <wait>
  cd:	83 c4 10             	add    $0x10,%esp
  d0:	83 f8 ff             	cmp    $0xffffffff,%eax
  d3:	75 17                	jne    ec <forktest+0xc3>
    printf(1, "wait got too many\n");
    exit(0);
  }

  printf(1, "fork test OK\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 c2 03 00 00       	push   $0x3c2
  dd:	6a 01                	push   $0x1
  df:	e8 1c ff ff ff       	call   0 <printf>
}
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ea:	c9                   	leave  
  eb:	c3                   	ret    
    printf(1, "wait got too many\n");
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	68 af 03 00 00       	push   $0x3af
  f4:	6a 01                	push   $0x1
  f6:	e8 05 ff ff ff       	call   0 <printf>
    exit(0);
  fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 102:	e8 c8 01 00 00       	call   2cf <exit>

00000107 <main>:

int
main(void)
{
 107:	f3 0f 1e fb          	endbr32 
 10b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 10f:	83 e4 f0             	and    $0xfffffff0,%esp
 112:	ff 71 fc             	pushl  -0x4(%ecx)
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	51                   	push   %ecx
 119:	83 ec 04             	sub    $0x4,%esp
  forktest();
 11c:	e8 08 ff ff ff       	call   29 <forktest>
  exit(0);
 121:	83 ec 0c             	sub    $0xc,%esp
 124:	6a 00                	push   $0x0
 126:	e8 a4 01 00 00       	call   2cf <exit>

0000012b <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 12b:	f3 0f 1e fb          	endbr32 
}
 12f:	c3                   	ret    

00000130 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	56                   	push   %esi
 138:	53                   	push   %ebx
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13f:	89 c2                	mov    %eax,%edx
 141:	89 cb                	mov    %ecx,%ebx
 143:	41                   	inc    %ecx
 144:	89 d6                	mov    %edx,%esi
 146:	42                   	inc    %edx
 147:	8a 1b                	mov    (%ebx),%bl
 149:	88 1e                	mov    %bl,(%esi)
 14b:	84 db                	test   %bl,%bl
 14d:	75 f2                	jne    141 <strcpy+0x11>
    ;
  return os;
}
 14f:	5b                   	pop    %ebx
 150:	5e                   	pop    %esi
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    

00000153 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 153:	f3 0f 1e fb          	endbr32 
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 160:	8a 01                	mov    (%ecx),%al
 162:	84 c0                	test   %al,%al
 164:	74 08                	je     16e <strcmp+0x1b>
 166:	3a 02                	cmp    (%edx),%al
 168:	75 04                	jne    16e <strcmp+0x1b>
    p++, q++;
 16a:	41                   	inc    %ecx
 16b:	42                   	inc    %edx
 16c:	eb f2                	jmp    160 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 16e:	0f b6 c0             	movzbl %al,%eax
 171:	0f b6 12             	movzbl (%edx),%edx
 174:	29 d0                	sub    %edx,%eax
}
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strlen>:

uint
strlen(const char *s)
{
 178:	f3 0f 1e fb          	endbr32 
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 182:	b8 00 00 00 00       	mov    $0x0,%eax
 187:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 18b:	74 03                	je     190 <strlen+0x18>
 18d:	40                   	inc    %eax
 18e:	eb f7                	jmp    187 <strlen+0xf>
    ;
  return n;
}
 190:	5d                   	pop    %ebp
 191:	c3                   	ret    

00000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	f3 0f 1e fb          	endbr32 
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19a:	8b 7d 08             	mov    0x8(%ebp),%edi
 19d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	fc                   	cld    
 1a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	5f                   	pop    %edi
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    

000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	f3 0f 1e fb          	endbr32 
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	74 07                	je     1c6 <strchr+0x1a>
    if(*s == c)
 1bf:	38 ca                	cmp    %cl,%dl
 1c1:	74 08                	je     1cb <strchr+0x1f>
  for(; *s; s++)
 1c3:	40                   	inc    %eax
 1c4:	eb f3                	jmp    1b9 <strchr+0xd>
      return (char*)s;
  return 0;
 1c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    

000001cd <gets>:

char*
gets(char *buf, int max)
{
 1cd:	f3 0f 1e fb          	endbr32 
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	57                   	push   %edi
 1d5:	56                   	push   %esi
 1d6:	53                   	push   %ebx
 1d7:	83 ec 1c             	sub    $0x1c,%esp
 1da:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dd:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e2:	89 de                	mov    %ebx,%esi
 1e4:	43                   	inc    %ebx
 1e5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e8:	7d 2b                	jge    215 <gets+0x48>
    cc = read(0, &c, 1);
 1ea:	83 ec 04             	sub    $0x4,%esp
 1ed:	6a 01                	push   $0x1
 1ef:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1f2:	50                   	push   %eax
 1f3:	6a 00                	push   $0x0
 1f5:	e8 ed 00 00 00       	call   2e7 <read>
    if(cc < 1)
 1fa:	83 c4 10             	add    $0x10,%esp
 1fd:	85 c0                	test   %eax,%eax
 1ff:	7e 14                	jle    215 <gets+0x48>
      break;
    buf[i++] = c;
 201:	8a 45 e7             	mov    -0x19(%ebp),%al
 204:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 207:	3c 0a                	cmp    $0xa,%al
 209:	74 08                	je     213 <gets+0x46>
 20b:	3c 0d                	cmp    $0xd,%al
 20d:	75 d3                	jne    1e2 <gets+0x15>
    buf[i++] = c;
 20f:	89 de                	mov    %ebx,%esi
 211:	eb 02                	jmp    215 <gets+0x48>
 213:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 215:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 219:	89 f8                	mov    %edi,%eax
 21b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    

00000223 <stat>:

int
stat(const char *n, struct stat *st)
{
 223:	f3 0f 1e fb          	endbr32 
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	56                   	push   %esi
 22b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	6a 00                	push   $0x0
 231:	ff 75 08             	pushl  0x8(%ebp)
 234:	e8 d6 00 00 00       	call   30f <open>
  if(fd < 0)
 239:	83 c4 10             	add    $0x10,%esp
 23c:	85 c0                	test   %eax,%eax
 23e:	78 24                	js     264 <stat+0x41>
 240:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 242:	83 ec 08             	sub    $0x8,%esp
 245:	ff 75 0c             	pushl  0xc(%ebp)
 248:	50                   	push   %eax
 249:	e8 d9 00 00 00       	call   327 <fstat>
 24e:	89 c6                	mov    %eax,%esi
  close(fd);
 250:	89 1c 24             	mov    %ebx,(%esp)
 253:	e8 9f 00 00 00       	call   2f7 <close>
  return r;
 258:	83 c4 10             	add    $0x10,%esp
}
 25b:	89 f0                	mov    %esi,%eax
 25d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 260:	5b                   	pop    %ebx
 261:	5e                   	pop    %esi
 262:	5d                   	pop    %ebp
 263:	c3                   	ret    
    return -1;
 264:	be ff ff ff ff       	mov    $0xffffffff,%esi
 269:	eb f0                	jmp    25b <stat+0x38>

0000026b <atoi>:

int
atoi(const char *s)
{
 26b:	f3 0f 1e fb          	endbr32 
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	53                   	push   %ebx
 273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 276:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 27b:	8a 01                	mov    (%ecx),%al
 27d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	77 10                	ja     295 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 285:	8d 14 92             	lea    (%edx,%edx,4),%edx
 288:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 28b:	41                   	inc    %ecx
 28c:	0f be c0             	movsbl %al,%eax
 28f:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 293:	eb e6                	jmp    27b <atoi+0x10>
  return n;
}
 295:	89 d0                	mov    %edx,%eax
 297:	5b                   	pop    %ebx
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	f3 0f 1e fb          	endbr32 
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	56                   	push   %esi
 2a2:	53                   	push   %ebx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2a9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2ac:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2ae:	8d 72 ff             	lea    -0x1(%edx),%esi
 2b1:	85 d2                	test   %edx,%edx
 2b3:	7e 0e                	jle    2c3 <memmove+0x29>
    *dst++ = *src++;
 2b5:	8a 13                	mov    (%ebx),%dl
 2b7:	88 11                	mov    %dl,(%ecx)
 2b9:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2bc:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2bf:	89 f2                	mov    %esi,%edx
 2c1:	eb eb                	jmp    2ae <memmove+0x14>
  return vdst;
}
 2c3:	5b                   	pop    %ebx
 2c4:	5e                   	pop    %esi
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    

000002c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c7:	b8 01 00 00 00       	mov    $0x1,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <exit>:
SYSCALL(exit)
 2cf:	b8 02 00 00 00       	mov    $0x2,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <wait>:
SYSCALL(wait)
 2d7:	b8 03 00 00 00       	mov    $0x3,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <pipe>:
SYSCALL(pipe)
 2df:	b8 04 00 00 00       	mov    $0x4,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <read>:
SYSCALL(read)
 2e7:	b8 05 00 00 00       	mov    $0x5,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <write>:
SYSCALL(write)
 2ef:	b8 10 00 00 00       	mov    $0x10,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <close>:
SYSCALL(close)
 2f7:	b8 15 00 00 00       	mov    $0x15,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <kill>:
SYSCALL(kill)
 2ff:	b8 06 00 00 00       	mov    $0x6,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <exec>:
SYSCALL(exec)
 307:	b8 07 00 00 00       	mov    $0x7,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <open>:
SYSCALL(open)
 30f:	b8 0f 00 00 00       	mov    $0xf,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mknod>:
SYSCALL(mknod)
 317:	b8 11 00 00 00       	mov    $0x11,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <unlink>:
SYSCALL(unlink)
 31f:	b8 12 00 00 00       	mov    $0x12,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <fstat>:
SYSCALL(fstat)
 327:	b8 08 00 00 00       	mov    $0x8,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <link>:
SYSCALL(link)
 32f:	b8 13 00 00 00       	mov    $0x13,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <mkdir>:
SYSCALL(mkdir)
 337:	b8 14 00 00 00       	mov    $0x14,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <chdir>:
SYSCALL(chdir)
 33f:	b8 09 00 00 00       	mov    $0x9,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <dup>:
SYSCALL(dup)
 347:	b8 0a 00 00 00       	mov    $0xa,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <dup2>:
SYSCALL(dup2)
 34f:	b8 17 00 00 00       	mov    $0x17,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <getpid>:
SYSCALL(getpid)
 357:	b8 0b 00 00 00       	mov    $0xb,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sbrk>:
SYSCALL(sbrk)
 35f:	b8 0c 00 00 00       	mov    $0xc,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <sleep>:
SYSCALL(sleep)
 367:	b8 0d 00 00 00       	mov    $0xd,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <uptime>:
SYSCALL(uptime)
 36f:	b8 0e 00 00 00       	mov    $0xe,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <date>:
SYSCALL(date)
 377:	b8 16 00 00 00       	mov    $0x16,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <getprio>:
SYSCALL(getprio)
 37f:	b8 18 00 00 00       	mov    $0x18,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <setprio>:
SYSCALL(setprio)
 387:	b8 19 00 00 00       	mov    $0x19,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    
