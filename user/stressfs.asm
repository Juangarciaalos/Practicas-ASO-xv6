
stressfs:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  1b:	8d 7d de             	lea    -0x22(%ebp),%edi
  1e:	be 97 05 00 00       	mov    $0x597,%esi
  23:	b9 0a 00 00 00       	mov    $0xa,%ecx
  28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  2a:	68 74 05 00 00       	push   $0x574
  2f:	6a 01                	push   $0x1
  31:	e8 e1 03 00 00       	call   417 <printf>
  memset(data, 'a', sizeof(data));
  36:	83 c4 0c             	add    $0xc,%esp
  39:	68 00 02 00 00       	push   $0x200
  3e:	6a 61                	push   $0x61
  40:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  46:	50                   	push   %eax
  47:	e8 3f 01 00 00       	call   18b <memset>

  for(i = 0; i < 4; i++)
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  54:	83 fb 03             	cmp    $0x3,%ebx
  57:	7f 0c                	jg     65 <main+0x65>
    if(fork() > 0)
  59:	e8 62 02 00 00       	call   2c0 <fork>
  5e:	85 c0                	test   %eax,%eax
  60:	7f 03                	jg     65 <main+0x65>
  for(i = 0; i < 4; i++)
  62:	43                   	inc    %ebx
  63:	eb ef                	jmp    54 <main+0x54>
      break;

  printf(1, "write %d\n", i);
  65:	83 ec 04             	sub    $0x4,%esp
  68:	53                   	push   %ebx
  69:	68 87 05 00 00       	push   $0x587
  6e:	6a 01                	push   $0x1
  70:	e8 a2 03 00 00       	call   417 <printf>

  path[8] += i;
  75:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  78:	83 c4 08             	add    $0x8,%esp
  7b:	68 02 02 00 00       	push   $0x202
  80:	8d 45 de             	lea    -0x22(%ebp),%eax
  83:	50                   	push   %eax
  84:	e8 7f 02 00 00       	call   308 <open>
  89:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  93:	eb 19                	jmp    ae <main+0xae>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  95:	83 ec 04             	sub    $0x4,%esp
  98:	68 00 02 00 00       	push   $0x200
  9d:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a3:	50                   	push   %eax
  a4:	56                   	push   %esi
  a5:	e8 3e 02 00 00       	call   2e8 <write>
  for(i = 0; i < 20; i++)
  aa:	43                   	inc    %ebx
  ab:	83 c4 10             	add    $0x10,%esp
  ae:	83 fb 13             	cmp    $0x13,%ebx
  b1:	7e e2                	jle    95 <main+0x95>
  close(fd);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	56                   	push   %esi
  b7:	e8 34 02 00 00       	call   2f0 <close>

  printf(1, "read\n");
  bc:	83 c4 08             	add    $0x8,%esp
  bf:	68 91 05 00 00       	push   $0x591
  c4:	6a 01                	push   $0x1
  c6:	e8 4c 03 00 00       	call   417 <printf>

  fd = open(path, O_RDONLY);
  cb:	83 c4 08             	add    $0x8,%esp
  ce:	6a 00                	push   $0x0
  d0:	8d 45 de             	lea    -0x22(%ebp),%eax
  d3:	50                   	push   %eax
  d4:	e8 2f 02 00 00       	call   308 <open>
  d9:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  db:	83 c4 10             	add    $0x10,%esp
  de:	bb 00 00 00 00       	mov    $0x0,%ebx
  e3:	eb 19                	jmp    fe <main+0xfe>
    read(fd, data, sizeof(data));
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	68 00 02 00 00       	push   $0x200
  ed:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  f3:	50                   	push   %eax
  f4:	56                   	push   %esi
  f5:	e8 e6 01 00 00       	call   2e0 <read>
  for (i = 0; i < 20; i++)
  fa:	43                   	inc    %ebx
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	83 fb 13             	cmp    $0x13,%ebx
 101:	7e e2                	jle    e5 <main+0xe5>
  close(fd);
 103:	83 ec 0c             	sub    $0xc,%esp
 106:	56                   	push   %esi
 107:	e8 e4 01 00 00       	call   2f0 <close>

  wait(NULL);
 10c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 113:	e8 b8 01 00 00       	call   2d0 <wait>

  exit(0);
 118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11f:	e8 a4 01 00 00       	call   2c8 <exit>

00000124 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 124:	f3 0f 1e fb          	endbr32 
}
 128:	c3                   	ret    

00000129 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 129:	f3 0f 1e fb          	endbr32 
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	56                   	push   %esi
 131:	53                   	push   %ebx
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 138:	89 c2                	mov    %eax,%edx
 13a:	89 cb                	mov    %ecx,%ebx
 13c:	41                   	inc    %ecx
 13d:	89 d6                	mov    %edx,%esi
 13f:	42                   	inc    %edx
 140:	8a 1b                	mov    (%ebx),%bl
 142:	88 1e                	mov    %bl,(%esi)
 144:	84 db                	test   %bl,%bl
 146:	75 f2                	jne    13a <strcpy+0x11>
    ;
  return os;
}
 148:	5b                   	pop    %ebx
 149:	5e                   	pop    %esi
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

0000014c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14c:	f3 0f 1e fb          	endbr32 
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 4d 08             	mov    0x8(%ebp),%ecx
 156:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 159:	8a 01                	mov    (%ecx),%al
 15b:	84 c0                	test   %al,%al
 15d:	74 08                	je     167 <strcmp+0x1b>
 15f:	3a 02                	cmp    (%edx),%al
 161:	75 04                	jne    167 <strcmp+0x1b>
    p++, q++;
 163:	41                   	inc    %ecx
 164:	42                   	inc    %edx
 165:	eb f2                	jmp    159 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 167:	0f b6 c0             	movzbl %al,%eax
 16a:	0f b6 12             	movzbl (%edx),%edx
 16d:	29 d0                	sub    %edx,%eax
}
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    

00000171 <strlen>:

uint
strlen(const char *s)
{
 171:	f3 0f 1e fb          	endbr32 
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 17b:	b8 00 00 00 00       	mov    $0x0,%eax
 180:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 184:	74 03                	je     189 <strlen+0x18>
 186:	40                   	inc    %eax
 187:	eb f7                	jmp    180 <strlen+0xf>
    ;
  return n;
}
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    

0000018b <memset>:

void*
memset(void *dst, int c, uint n)
{
 18b:	f3 0f 1e fb          	endbr32 
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 193:	8b 7d 08             	mov    0x8(%ebp),%edi
 196:	8b 4d 10             	mov    0x10(%ebp),%ecx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	fc                   	cld    
 19d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	5f                   	pop    %edi
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    

000001a5 <strchr>:

char*
strchr(const char *s, char c)
{
 1a5:	f3 0f 1e fb          	endbr32 
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1b2:	8a 10                	mov    (%eax),%dl
 1b4:	84 d2                	test   %dl,%dl
 1b6:	74 07                	je     1bf <strchr+0x1a>
    if(*s == c)
 1b8:	38 ca                	cmp    %cl,%dl
 1ba:	74 08                	je     1c4 <strchr+0x1f>
  for(; *s; s++)
 1bc:	40                   	inc    %eax
 1bd:	eb f3                	jmp    1b2 <strchr+0xd>
      return (char*)s;
  return 0;
 1bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <gets>:

char*
gets(char *buf, int max)
{
 1c6:	f3 0f 1e fb          	endbr32 
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	57                   	push   %edi
 1ce:	56                   	push   %esi
 1cf:	53                   	push   %ebx
 1d0:	83 ec 1c             	sub    $0x1c,%esp
 1d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d6:	bb 00 00 00 00       	mov    $0x0,%ebx
 1db:	89 de                	mov    %ebx,%esi
 1dd:	43                   	inc    %ebx
 1de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e1:	7d 2b                	jge    20e <gets+0x48>
    cc = read(0, &c, 1);
 1e3:	83 ec 04             	sub    $0x4,%esp
 1e6:	6a 01                	push   $0x1
 1e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1eb:	50                   	push   %eax
 1ec:	6a 00                	push   $0x0
 1ee:	e8 ed 00 00 00       	call   2e0 <read>
    if(cc < 1)
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	85 c0                	test   %eax,%eax
 1f8:	7e 14                	jle    20e <gets+0x48>
      break;
    buf[i++] = c;
 1fa:	8a 45 e7             	mov    -0x19(%ebp),%al
 1fd:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 200:	3c 0a                	cmp    $0xa,%al
 202:	74 08                	je     20c <gets+0x46>
 204:	3c 0d                	cmp    $0xd,%al
 206:	75 d3                	jne    1db <gets+0x15>
    buf[i++] = c;
 208:	89 de                	mov    %ebx,%esi
 20a:	eb 02                	jmp    20e <gets+0x48>
 20c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 20e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 212:	89 f8                	mov    %edi,%eax
 214:	8d 65 f4             	lea    -0xc(%ebp),%esp
 217:	5b                   	pop    %ebx
 218:	5e                   	pop    %esi
 219:	5f                   	pop    %edi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    

0000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	f3 0f 1e fb          	endbr32 
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	pushl  0x8(%ebp)
 22d:	e8 d6 00 00 00       	call   308 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 24                	js     25d <stat+0x41>
 239:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	ff 75 0c             	pushl  0xc(%ebp)
 241:	50                   	push   %eax
 242:	e8 d9 00 00 00       	call   320 <fstat>
 247:	89 c6                	mov    %eax,%esi
  close(fd);
 249:	89 1c 24             	mov    %ebx,(%esp)
 24c:	e8 9f 00 00 00       	call   2f0 <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	89 f0                	mov    %esi,%eax
 256:	8d 65 f8             	lea    -0x8(%ebp),%esp
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
    return -1;
 25d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 262:	eb f0                	jmp    254 <stat+0x38>

00000264 <atoi>:

int
atoi(const char *s)
{
 264:	f3 0f 1e fb          	endbr32 
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	53                   	push   %ebx
 26c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 26f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 274:	8a 01                	mov    (%ecx),%al
 276:	8d 58 d0             	lea    -0x30(%eax),%ebx
 279:	80 fb 09             	cmp    $0x9,%bl
 27c:	77 10                	ja     28e <atoi+0x2a>
    n = n*10 + *s++ - '0';
 27e:	8d 14 92             	lea    (%edx,%edx,4),%edx
 281:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 284:	41                   	inc    %ecx
 285:	0f be c0             	movsbl %al,%eax
 288:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 28c:	eb e6                	jmp    274 <atoi+0x10>
  return n;
}
 28e:	89 d0                	mov    %edx,%eax
 290:	5b                   	pop    %ebx
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    

00000293 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 293:	f3 0f 1e fb          	endbr32 
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	56                   	push   %esi
 29b:	53                   	push   %ebx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2a2:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2a5:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2a7:	8d 72 ff             	lea    -0x1(%edx),%esi
 2aa:	85 d2                	test   %edx,%edx
 2ac:	7e 0e                	jle    2bc <memmove+0x29>
    *dst++ = *src++;
 2ae:	8a 13                	mov    (%ebx),%dl
 2b0:	88 11                	mov    %dl,(%ecx)
 2b2:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2b5:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2b8:	89 f2                	mov    %esi,%edx
 2ba:	eb eb                	jmp    2a7 <memmove+0x14>
  return vdst;
}
 2bc:	5b                   	pop    %ebx
 2bd:	5e                   	pop    %esi
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <dup2>:
SYSCALL(dup2)
 348:	b8 17 00 00 00       	mov    $0x17,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <getpid>:
SYSCALL(getpid)
 350:	b8 0b 00 00 00       	mov    $0xb,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sbrk>:
SYSCALL(sbrk)
 358:	b8 0c 00 00 00       	mov    $0xc,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <sleep>:
SYSCALL(sleep)
 360:	b8 0d 00 00 00       	mov    $0xd,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <uptime>:
SYSCALL(uptime)
 368:	b8 0e 00 00 00       	mov    $0xe,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <date>:
SYSCALL(date)
 370:	b8 16 00 00 00       	mov    $0x16,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getprio>:
SYSCALL(getprio)
 378:	b8 18 00 00 00       	mov    $0x18,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <setprio>:
SYSCALL(setprio)
 380:	b8 19 00 00 00       	mov    $0x19,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	83 ec 1c             	sub    $0x1c,%esp
 38e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 391:	6a 01                	push   $0x1
 393:	8d 55 f4             	lea    -0xc(%ebp),%edx
 396:	52                   	push   %edx
 397:	50                   	push   %eax
 398:	e8 4b ff ff ff       	call   2e8 <write>
}
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	57                   	push   %edi
 3a6:	56                   	push   %esi
 3a7:	53                   	push   %ebx
 3a8:	83 ec 2c             	sub    $0x2c,%esp
 3ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3ae:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b4:	74 04                	je     3ba <printint+0x18>
 3b6:	85 d2                	test   %edx,%edx
 3b8:	78 3a                	js     3f4 <printint+0x52>
  neg = 0;
 3ba:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3c6:	89 f0                	mov    %esi,%eax
 3c8:	ba 00 00 00 00       	mov    $0x0,%edx
 3cd:	f7 f1                	div    %ecx
 3cf:	89 df                	mov    %ebx,%edi
 3d1:	43                   	inc    %ebx
 3d2:	8a 92 a8 05 00 00    	mov    0x5a8(%edx),%dl
 3d8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3dc:	89 f2                	mov    %esi,%edx
 3de:	89 c6                	mov    %eax,%esi
 3e0:	39 d1                	cmp    %edx,%ecx
 3e2:	76 e2                	jbe    3c6 <printint+0x24>
  if(neg)
 3e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3e8:	74 22                	je     40c <printint+0x6a>
    buf[i++] = '-';
 3ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ef:	8d 5f 02             	lea    0x2(%edi),%ebx
 3f2:	eb 18                	jmp    40c <printint+0x6a>
    x = -xx;
 3f4:	f7 de                	neg    %esi
    neg = 1;
 3f6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3fd:	eb c2                	jmp    3c1 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ff:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 404:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 407:	e8 7c ff ff ff       	call   388 <putc>
  while(--i >= 0)
 40c:	4b                   	dec    %ebx
 40d:	79 f0                	jns    3ff <printint+0x5d>
}
 40f:	83 c4 2c             	add    $0x2c,%esp
 412:	5b                   	pop    %ebx
 413:	5e                   	pop    %esi
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    

00000417 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 417:	f3 0f 1e fb          	endbr32 
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	57                   	push   %edi
 41f:	56                   	push   %esi
 420:	53                   	push   %ebx
 421:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 424:	8d 45 10             	lea    0x10(%ebp),%eax
 427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 42a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 42f:	bb 00 00 00 00       	mov    $0x0,%ebx
 434:	eb 12                	jmp    448 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 436:	89 fa                	mov    %edi,%edx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	e8 48 ff ff ff       	call   388 <putc>
 440:	eb 05                	jmp    447 <printf+0x30>
      }
    } else if(state == '%'){
 442:	83 fe 25             	cmp    $0x25,%esi
 445:	74 22                	je     469 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 447:	43                   	inc    %ebx
 448:	8b 45 0c             	mov    0xc(%ebp),%eax
 44b:	8a 04 18             	mov    (%eax,%ebx,1),%al
 44e:	84 c0                	test   %al,%al
 450:	0f 84 13 01 00 00    	je     569 <printf+0x152>
    c = fmt[i] & 0xff;
 456:	0f be f8             	movsbl %al,%edi
 459:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 45c:	85 f6                	test   %esi,%esi
 45e:	75 e2                	jne    442 <printf+0x2b>
      if(c == '%'){
 460:	83 f8 25             	cmp    $0x25,%eax
 463:	75 d1                	jne    436 <printf+0x1f>
        state = '%';
 465:	89 c6                	mov    %eax,%esi
 467:	eb de                	jmp    447 <printf+0x30>
      if(c == 'd'){
 469:	83 f8 64             	cmp    $0x64,%eax
 46c:	74 43                	je     4b1 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 46e:	83 f8 78             	cmp    $0x78,%eax
 471:	74 68                	je     4db <printf+0xc4>
 473:	83 f8 70             	cmp    $0x70,%eax
 476:	74 63                	je     4db <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 478:	83 f8 73             	cmp    $0x73,%eax
 47b:	0f 84 84 00 00 00    	je     505 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 481:	83 f8 63             	cmp    $0x63,%eax
 484:	0f 84 ad 00 00 00    	je     537 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 48a:	83 f8 25             	cmp    $0x25,%eax
 48d:	0f 84 c2 00 00 00    	je     555 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 493:	ba 25 00 00 00       	mov    $0x25,%edx
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	e8 e8 fe ff ff       	call   388 <putc>
        putc(fd, c);
 4a0:	89 fa                	mov    %edi,%edx
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	e8 de fe ff ff       	call   388 <putc>
      }
      state = 0;
 4aa:	be 00 00 00 00       	mov    $0x0,%esi
 4af:	eb 96                	jmp    447 <printf+0x30>
        printint(fd, *ap, 10, 1);
 4b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b4:	8b 17                	mov    (%edi),%edx
 4b6:	83 ec 0c             	sub    $0xc,%esp
 4b9:	6a 01                	push   $0x1
 4bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	e8 da fe ff ff       	call   3a2 <printint>
        ap++;
 4c8:	83 c7 04             	add    $0x4,%edi
 4cb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ce:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d1:	be 00 00 00 00       	mov    $0x0,%esi
 4d6:	e9 6c ff ff ff       	jmp    447 <printf+0x30>
        printint(fd, *ap, 16, 0);
 4db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4de:	8b 17                	mov    (%edi),%edx
 4e0:	83 ec 0c             	sub    $0xc,%esp
 4e3:	6a 00                	push   $0x0
 4e5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	e8 b0 fe ff ff       	call   3a2 <printint>
        ap++;
 4f2:	83 c7 04             	add    $0x4,%edi
 4f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fb:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 500:	e9 42 ff ff ff       	jmp    447 <printf+0x30>
        s = (char*)*ap;
 505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 508:	8b 30                	mov    (%eax),%esi
        ap++;
 50a:	83 c0 04             	add    $0x4,%eax
 50d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 510:	85 f6                	test   %esi,%esi
 512:	75 13                	jne    527 <printf+0x110>
          s = "(null)";
 514:	be a1 05 00 00       	mov    $0x5a1,%esi
 519:	eb 0c                	jmp    527 <printf+0x110>
          putc(fd, *s);
 51b:	0f be d2             	movsbl %dl,%edx
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	e8 62 fe ff ff       	call   388 <putc>
          s++;
 526:	46                   	inc    %esi
        while(*s != 0){
 527:	8a 16                	mov    (%esi),%dl
 529:	84 d2                	test   %dl,%dl
 52b:	75 ee                	jne    51b <printf+0x104>
      state = 0;
 52d:	be 00 00 00 00       	mov    $0x0,%esi
 532:	e9 10 ff ff ff       	jmp    447 <printf+0x30>
        putc(fd, *ap);
 537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 53a:	0f be 17             	movsbl (%edi),%edx
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	e8 43 fe ff ff       	call   388 <putc>
        ap++;
 545:	83 c7 04             	add    $0x4,%edi
 548:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 54b:	be 00 00 00 00       	mov    $0x0,%esi
 550:	e9 f2 fe ff ff       	jmp    447 <printf+0x30>
        putc(fd, c);
 555:	89 fa                	mov    %edi,%edx
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	e8 29 fe ff ff       	call   388 <putc>
      state = 0;
 55f:	be 00 00 00 00       	mov    $0x0,%esi
 564:	e9 de fe ff ff       	jmp    447 <printf+0x30>
    }
  }
}
 569:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56c:	5b                   	pop    %ebx
 56d:	5e                   	pop    %esi
 56e:	5f                   	pop    %edi
 56f:	5d                   	pop    %ebp
 570:	c3                   	ret    
