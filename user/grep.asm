
grep:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	8b 75 08             	mov    0x8(%ebp),%esi
  10:	8b 7d 0c             	mov    0xc(%ebp),%edi
  13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  16:	83 ec 08             	sub    $0x8,%esp
  19:	53                   	push   %ebx
  1a:	57                   	push   %edi
  1b:	e8 29 00 00 00       	call   49 <matchhere>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	75 15                	jne    3c <matchstar+0x3c>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  27:	8a 13                	mov    (%ebx),%dl
  29:	84 d2                	test   %dl,%dl
  2b:	74 14                	je     41 <matchstar+0x41>
  2d:	43                   	inc    %ebx
  2e:	0f be d2             	movsbl %dl,%edx
  31:	39 f2                	cmp    %esi,%edx
  33:	74 e1                	je     16 <matchstar+0x16>
  35:	83 fe 2e             	cmp    $0x2e,%esi
  38:	74 dc                	je     16 <matchstar+0x16>
  3a:	eb 05                	jmp    41 <matchstar+0x41>
      return 1;
  3c:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  44:	5b                   	pop    %ebx
  45:	5e                   	pop    %esi
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <matchhere>:
{
  49:	f3 0f 1e fb          	endbr32 
  4d:	55                   	push   %ebp
  4e:	89 e5                	mov    %esp,%ebp
  50:	83 ec 08             	sub    $0x8,%esp
  53:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  56:	8a 02                	mov    (%edx),%al
  58:	84 c0                	test   %al,%al
  5a:	74 62                	je     be <matchhere+0x75>
  if(re[1] == '*')
  5c:	8a 4a 01             	mov    0x1(%edx),%cl
  5f:	80 f9 2a             	cmp    $0x2a,%cl
  62:	74 1c                	je     80 <matchhere+0x37>
  if(re[0] == '$' && re[1] == '\0')
  64:	3c 24                	cmp    $0x24,%al
  66:	74 30                	je     98 <matchhere+0x4f>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  6b:	8a 09                	mov    (%ecx),%cl
  6d:	84 c9                	test   %cl,%cl
  6f:	74 54                	je     c5 <matchhere+0x7c>
  71:	3c 2e                	cmp    $0x2e,%al
  73:	74 35                	je     aa <matchhere+0x61>
  75:	38 c8                	cmp    %cl,%al
  77:	74 31                	je     aa <matchhere+0x61>
  return 0;
  79:	b8 00 00 00 00       	mov    $0x0,%eax
  7e:	eb 43                	jmp    c3 <matchhere+0x7a>
    return matchstar(re[0], re+2, text);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	ff 75 0c             	pushl  0xc(%ebp)
  86:	83 c2 02             	add    $0x2,%edx
  89:	52                   	push   %edx
  8a:	0f be c0             	movsbl %al,%eax
  8d:	50                   	push   %eax
  8e:	e8 6d ff ff ff       	call   0 <matchstar>
  93:	83 c4 10             	add    $0x10,%esp
  96:	eb 2b                	jmp    c3 <matchhere+0x7a>
  if(re[0] == '$' && re[1] == '\0')
  98:	84 c9                	test   %cl,%cl
  9a:	75 cc                	jne    68 <matchhere+0x1f>
    return *text == '\0';
  9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  9f:	80 38 00             	cmpb   $0x0,(%eax)
  a2:	0f 94 c0             	sete   %al
  a5:	0f b6 c0             	movzbl %al,%eax
  a8:	eb 19                	jmp    c3 <matchhere+0x7a>
    return matchhere(re+1, text+1);
  aa:	83 ec 08             	sub    $0x8,%esp
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	40                   	inc    %eax
  b1:	50                   	push   %eax
  b2:	42                   	inc    %edx
  b3:	52                   	push   %edx
  b4:	e8 90 ff ff ff       	call   49 <matchhere>
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	eb 05                	jmp    c3 <matchhere+0x7a>
    return 1;
  be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  c3:	c9                   	leave  
  c4:	c3                   	ret    
  return 0;
  c5:	b8 00 00 00 00       	mov    $0x0,%eax
  ca:	eb f7                	jmp    c3 <matchhere+0x7a>

000000cc <match>:
{
  cc:	f3 0f 1e fb          	endbr32 
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	56                   	push   %esi
  d4:	53                   	push   %ebx
  d5:	8b 75 08             	mov    0x8(%ebp),%esi
  d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  db:	80 3e 5e             	cmpb   $0x5e,(%esi)
  de:	75 12                	jne    f2 <match+0x26>
    return matchhere(re+1, text);
  e0:	83 ec 08             	sub    $0x8,%esp
  e3:	53                   	push   %ebx
  e4:	46                   	inc    %esi
  e5:	56                   	push   %esi
  e6:	e8 5e ff ff ff       	call   49 <matchhere>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	eb 22                	jmp    112 <match+0x46>
  }while(*text++ != '\0');
  f0:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  f2:	83 ec 08             	sub    $0x8,%esp
  f5:	53                   	push   %ebx
  f6:	56                   	push   %esi
  f7:	e8 4d ff ff ff       	call   49 <matchhere>
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	85 c0                	test   %eax,%eax
 101:	75 0a                	jne    10d <match+0x41>
  }while(*text++ != '\0');
 103:	8d 53 01             	lea    0x1(%ebx),%edx
 106:	80 3b 00             	cmpb   $0x0,(%ebx)
 109:	75 e5                	jne    f0 <match+0x24>
 10b:	eb 05                	jmp    112 <match+0x46>
      return 1;
 10d:	b8 01 00 00 00       	mov    $0x1,%eax
}
 112:	8d 65 f8             	lea    -0x8(%ebp),%esp
 115:	5b                   	pop    %ebx
 116:	5e                   	pop    %esi
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <grep>:
{
 119:	f3 0f 1e fb          	endbr32 
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	56                   	push   %esi
 122:	53                   	push   %ebx
 123:	83 ec 1c             	sub    $0x1c,%esp
 126:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 129:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 130:	eb 53                	jmp    185 <grep+0x6c>
        *q = '\n';
 132:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 135:	8d 43 01             	lea    0x1(%ebx),%eax
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	29 f0                	sub    %esi,%eax
 13d:	50                   	push   %eax
 13e:	56                   	push   %esi
 13f:	6a 01                	push   $0x1
 141:	e8 3f 03 00 00       	call   485 <write>
 146:	83 c4 10             	add    $0x10,%esp
      p = q+1;
 149:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 14c:	83 ec 08             	sub    $0x8,%esp
 14f:	6a 0a                	push   $0xa
 151:	56                   	push   %esi
 152:	e8 eb 01 00 00       	call   342 <strchr>
 157:	89 c3                	mov    %eax,%ebx
 159:	83 c4 10             	add    $0x10,%esp
 15c:	85 c0                	test   %eax,%eax
 15e:	74 16                	je     176 <grep+0x5d>
      *q = 0;
 160:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 163:	83 ec 08             	sub    $0x8,%esp
 166:	56                   	push   %esi
 167:	57                   	push   %edi
 168:	e8 5f ff ff ff       	call   cc <match>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	74 d5                	je     149 <grep+0x30>
 174:	eb bc                	jmp    132 <grep+0x19>
    if(p == buf)
 176:	81 fe 40 0a 00 00    	cmp    $0xa40,%esi
 17c:	74 5f                	je     1dd <grep+0xc4>
    if(m > 0){
 17e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 181:	85 c9                	test   %ecx,%ecx
 183:	7f 38                	jg     1bd <grep+0xa4>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 185:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 18a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 18d:	29 c8                	sub    %ecx,%eax
 18f:	83 ec 04             	sub    $0x4,%esp
 192:	50                   	push   %eax
 193:	8d 81 40 0a 00 00    	lea    0xa40(%ecx),%eax
 199:	50                   	push   %eax
 19a:	ff 75 0c             	pushl  0xc(%ebp)
 19d:	e8 db 02 00 00       	call   47d <read>
 1a2:	83 c4 10             	add    $0x10,%esp
 1a5:	85 c0                	test   %eax,%eax
 1a7:	7e 3d                	jle    1e6 <grep+0xcd>
    m += n;
 1a9:	01 45 e4             	add    %eax,-0x1c(%ebp)
 1ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 1af:	c6 82 40 0a 00 00 00 	movb   $0x0,0xa40(%edx)
    p = buf;
 1b6:	be 40 0a 00 00       	mov    $0xa40,%esi
    while((q = strchr(p, '\n')) != 0){
 1bb:	eb 8f                	jmp    14c <grep+0x33>
      m -= p - buf;
 1bd:	89 f0                	mov    %esi,%eax
 1bf:	2d 40 0a 00 00       	sub    $0xa40,%eax
 1c4:	29 c1                	sub    %eax,%ecx
 1c6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 1c9:	83 ec 04             	sub    $0x4,%esp
 1cc:	51                   	push   %ecx
 1cd:	56                   	push   %esi
 1ce:	68 40 0a 00 00       	push   $0xa40
 1d3:	e8 58 02 00 00       	call   430 <memmove>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	eb a8                	jmp    185 <grep+0x6c>
      m = 0;
 1dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1e4:	eb 9f                	jmp    185 <grep+0x6c>
}
 1e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e9:	5b                   	pop    %ebx
 1ea:	5e                   	pop    %esi
 1eb:	5f                   	pop    %edi
 1ec:	5d                   	pop    %ebp
 1ed:	c3                   	ret    

000001ee <main>:
{
 1ee:	f3 0f 1e fb          	endbr32 
 1f2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1f6:	83 e4 f0             	and    $0xfffffff0,%esp
 1f9:	ff 71 fc             	pushl  -0x4(%ecx)
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	57                   	push   %edi
 200:	56                   	push   %esi
 201:	53                   	push   %ebx
 202:	51                   	push   %ecx
 203:	83 ec 18             	sub    $0x18,%esp
 206:	8b 01                	mov    (%ecx),%eax
 208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 20b:	8b 51 04             	mov    0x4(%ecx),%edx
 20e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 211:	83 f8 01             	cmp    $0x1,%eax
 214:	7e 52                	jle    268 <main+0x7a>
  pattern = argv[1];
 216:	8b 45 e0             	mov    -0x20(%ebp),%eax
 219:	8b 40 04             	mov    0x4(%eax),%eax
 21c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 21f:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 223:	7e 5e                	jle    283 <main+0x95>
  for(i = 2; i < argc; i++){
 225:	be 02 00 00 00       	mov    $0x2,%esi
 22a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 22d:	0f 8d 84 00 00 00    	jge    2b7 <main+0xc9>
    if((fd = open(argv[i], 0)) < 0){
 233:	8b 45 e0             	mov    -0x20(%ebp),%eax
 236:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	6a 00                	push   $0x0
 23e:	ff 37                	pushl  (%edi)
 240:	e8 60 02 00 00       	call   4a5 <open>
 245:	89 c3                	mov    %eax,%ebx
 247:	83 c4 10             	add    $0x10,%esp
 24a:	85 c0                	test   %eax,%eax
 24c:	78 4c                	js     29a <main+0xac>
    grep(pattern, fd);
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	50                   	push   %eax
 252:	ff 75 dc             	pushl  -0x24(%ebp)
 255:	e8 bf fe ff ff       	call   119 <grep>
    close(fd);
 25a:	89 1c 24             	mov    %ebx,(%esp)
 25d:	e8 2b 02 00 00       	call   48d <close>
  for(i = 2; i < argc; i++){
 262:	46                   	inc    %esi
 263:	83 c4 10             	add    $0x10,%esp
 266:	eb c2                	jmp    22a <main+0x3c>
    printf(2, "usage: grep pattern [file ...]\n");
 268:	83 ec 08             	sub    $0x8,%esp
 26b:	68 10 07 00 00       	push   $0x710
 270:	6a 02                	push   $0x2
 272:	e8 3d 03 00 00       	call   5b4 <printf>
    exit(0);
 277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 27e:	e8 e2 01 00 00       	call   465 <exit>
    grep(pattern, 0);
 283:	83 ec 08             	sub    $0x8,%esp
 286:	6a 00                	push   $0x0
 288:	50                   	push   %eax
 289:	e8 8b fe ff ff       	call   119 <grep>
    exit(0);
 28e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 295:	e8 cb 01 00 00       	call   465 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 29a:	83 ec 04             	sub    $0x4,%esp
 29d:	ff 37                	pushl  (%edi)
 29f:	68 30 07 00 00       	push   $0x730
 2a4:	6a 01                	push   $0x1
 2a6:	e8 09 03 00 00       	call   5b4 <printf>
      exit(0);
 2ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2b2:	e8 ae 01 00 00       	call   465 <exit>
  exit(0);
 2b7:	83 ec 0c             	sub    $0xc,%esp
 2ba:	6a 00                	push   $0x0
 2bc:	e8 a4 01 00 00       	call   465 <exit>

000002c1 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 2c1:	f3 0f 1e fb          	endbr32 
}
 2c5:	c3                   	ret    

000002c6 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 2c6:	f3 0f 1e fb          	endbr32 
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	56                   	push   %esi
 2ce:	53                   	push   %ebx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d5:	89 c2                	mov    %eax,%edx
 2d7:	89 cb                	mov    %ecx,%ebx
 2d9:	41                   	inc    %ecx
 2da:	89 d6                	mov    %edx,%esi
 2dc:	42                   	inc    %edx
 2dd:	8a 1b                	mov    (%ebx),%bl
 2df:	88 1e                	mov    %bl,(%esi)
 2e1:	84 db                	test   %bl,%bl
 2e3:	75 f2                	jne    2d7 <strcpy+0x11>
    ;
  return os;
}
 2e5:	5b                   	pop    %ebx
 2e6:	5e                   	pop    %esi
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    

000002e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e9:	f3 0f 1e fb          	endbr32 
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2f6:	8a 01                	mov    (%ecx),%al
 2f8:	84 c0                	test   %al,%al
 2fa:	74 08                	je     304 <strcmp+0x1b>
 2fc:	3a 02                	cmp    (%edx),%al
 2fe:	75 04                	jne    304 <strcmp+0x1b>
    p++, q++;
 300:	41                   	inc    %ecx
 301:	42                   	inc    %edx
 302:	eb f2                	jmp    2f6 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 304:	0f b6 c0             	movzbl %al,%eax
 307:	0f b6 12             	movzbl (%edx),%edx
 30a:	29 d0                	sub    %edx,%eax
}
 30c:	5d                   	pop    %ebp
 30d:	c3                   	ret    

0000030e <strlen>:

uint
strlen(const char *s)
{
 30e:	f3 0f 1e fb          	endbr32 
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 318:	b8 00 00 00 00       	mov    $0x0,%eax
 31d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 321:	74 03                	je     326 <strlen+0x18>
 323:	40                   	inc    %eax
 324:	eb f7                	jmp    31d <strlen+0xf>
    ;
  return n;
}
 326:	5d                   	pop    %ebp
 327:	c3                   	ret    

00000328 <memset>:

void*
memset(void *dst, int c, uint n)
{
 328:	f3 0f 1e fb          	endbr32 
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 330:	8b 7d 08             	mov    0x8(%ebp),%edi
 333:	8b 4d 10             	mov    0x10(%ebp),%ecx
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	fc                   	cld    
 33a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	5f                   	pop    %edi
 340:	5d                   	pop    %ebp
 341:	c3                   	ret    

00000342 <strchr>:

char*
strchr(const char *s, char c)
{
 342:	f3 0f 1e fb          	endbr32 
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 34f:	8a 10                	mov    (%eax),%dl
 351:	84 d2                	test   %dl,%dl
 353:	74 07                	je     35c <strchr+0x1a>
    if(*s == c)
 355:	38 ca                	cmp    %cl,%dl
 357:	74 08                	je     361 <strchr+0x1f>
  for(; *s; s++)
 359:	40                   	inc    %eax
 35a:	eb f3                	jmp    34f <strchr+0xd>
      return (char*)s;
  return 0;
 35c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 361:	5d                   	pop    %ebp
 362:	c3                   	ret    

00000363 <gets>:

char*
gets(char *buf, int max)
{
 363:	f3 0f 1e fb          	endbr32 
 367:	55                   	push   %ebp
 368:	89 e5                	mov    %esp,%ebp
 36a:	57                   	push   %edi
 36b:	56                   	push   %esi
 36c:	53                   	push   %ebx
 36d:	83 ec 1c             	sub    $0x1c,%esp
 370:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 373:	bb 00 00 00 00       	mov    $0x0,%ebx
 378:	89 de                	mov    %ebx,%esi
 37a:	43                   	inc    %ebx
 37b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 37e:	7d 2b                	jge    3ab <gets+0x48>
    cc = read(0, &c, 1);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	6a 01                	push   $0x1
 385:	8d 45 e7             	lea    -0x19(%ebp),%eax
 388:	50                   	push   %eax
 389:	6a 00                	push   $0x0
 38b:	e8 ed 00 00 00       	call   47d <read>
    if(cc < 1)
 390:	83 c4 10             	add    $0x10,%esp
 393:	85 c0                	test   %eax,%eax
 395:	7e 14                	jle    3ab <gets+0x48>
      break;
    buf[i++] = c;
 397:	8a 45 e7             	mov    -0x19(%ebp),%al
 39a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 39d:	3c 0a                	cmp    $0xa,%al
 39f:	74 08                	je     3a9 <gets+0x46>
 3a1:	3c 0d                	cmp    $0xd,%al
 3a3:	75 d3                	jne    378 <gets+0x15>
    buf[i++] = c;
 3a5:	89 de                	mov    %ebx,%esi
 3a7:	eb 02                	jmp    3ab <gets+0x48>
 3a9:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3ab:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3af:	89 f8                	mov    %edi,%eax
 3b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b4:	5b                   	pop    %ebx
 3b5:	5e                   	pop    %esi
 3b6:	5f                   	pop    %edi
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    

000003b9 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b9:	f3 0f 1e fb          	endbr32 
 3bd:	55                   	push   %ebp
 3be:	89 e5                	mov    %esp,%ebp
 3c0:	56                   	push   %esi
 3c1:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c2:	83 ec 08             	sub    $0x8,%esp
 3c5:	6a 00                	push   $0x0
 3c7:	ff 75 08             	pushl  0x8(%ebp)
 3ca:	e8 d6 00 00 00       	call   4a5 <open>
  if(fd < 0)
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	85 c0                	test   %eax,%eax
 3d4:	78 24                	js     3fa <stat+0x41>
 3d6:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3d8:	83 ec 08             	sub    $0x8,%esp
 3db:	ff 75 0c             	pushl  0xc(%ebp)
 3de:	50                   	push   %eax
 3df:	e8 d9 00 00 00       	call   4bd <fstat>
 3e4:	89 c6                	mov    %eax,%esi
  close(fd);
 3e6:	89 1c 24             	mov    %ebx,(%esp)
 3e9:	e8 9f 00 00 00       	call   48d <close>
  return r;
 3ee:	83 c4 10             	add    $0x10,%esp
}
 3f1:	89 f0                	mov    %esi,%eax
 3f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    
    return -1;
 3fa:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ff:	eb f0                	jmp    3f1 <stat+0x38>

00000401 <atoi>:

int
atoi(const char *s)
{
 401:	f3 0f 1e fb          	endbr32 
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	53                   	push   %ebx
 409:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 411:	8a 01                	mov    (%ecx),%al
 413:	8d 58 d0             	lea    -0x30(%eax),%ebx
 416:	80 fb 09             	cmp    $0x9,%bl
 419:	77 10                	ja     42b <atoi+0x2a>
    n = n*10 + *s++ - '0';
 41b:	8d 14 92             	lea    (%edx,%edx,4),%edx
 41e:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 421:	41                   	inc    %ecx
 422:	0f be c0             	movsbl %al,%eax
 425:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 429:	eb e6                	jmp    411 <atoi+0x10>
  return n;
}
 42b:	89 d0                	mov    %edx,%eax
 42d:	5b                   	pop    %ebx
 42e:	5d                   	pop    %ebp
 42f:	c3                   	ret    

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	56                   	push   %esi
 438:	53                   	push   %ebx
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 43f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 442:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 444:	8d 72 ff             	lea    -0x1(%edx),%esi
 447:	85 d2                	test   %edx,%edx
 449:	7e 0e                	jle    459 <memmove+0x29>
    *dst++ = *src++;
 44b:	8a 13                	mov    (%ebx),%dl
 44d:	88 11                	mov    %dl,(%ecx)
 44f:	8d 5b 01             	lea    0x1(%ebx),%ebx
 452:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 455:	89 f2                	mov    %esi,%edx
 457:	eb eb                	jmp    444 <memmove+0x14>
  return vdst;
}
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    

0000045d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45d:	b8 01 00 00 00       	mov    $0x1,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <exit>:
SYSCALL(exit)
 465:	b8 02 00 00 00       	mov    $0x2,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <wait>:
SYSCALL(wait)
 46d:	b8 03 00 00 00       	mov    $0x3,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <pipe>:
SYSCALL(pipe)
 475:	b8 04 00 00 00       	mov    $0x4,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <read>:
SYSCALL(read)
 47d:	b8 05 00 00 00       	mov    $0x5,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <write>:
SYSCALL(write)
 485:	b8 10 00 00 00       	mov    $0x10,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <close>:
SYSCALL(close)
 48d:	b8 15 00 00 00       	mov    $0x15,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <kill>:
SYSCALL(kill)
 495:	b8 06 00 00 00       	mov    $0x6,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <exec>:
SYSCALL(exec)
 49d:	b8 07 00 00 00       	mov    $0x7,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <open>:
SYSCALL(open)
 4a5:	b8 0f 00 00 00       	mov    $0xf,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <mknod>:
SYSCALL(mknod)
 4ad:	b8 11 00 00 00       	mov    $0x11,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <unlink>:
SYSCALL(unlink)
 4b5:	b8 12 00 00 00       	mov    $0x12,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <fstat>:
SYSCALL(fstat)
 4bd:	b8 08 00 00 00       	mov    $0x8,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <link>:
SYSCALL(link)
 4c5:	b8 13 00 00 00       	mov    $0x13,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <mkdir>:
SYSCALL(mkdir)
 4cd:	b8 14 00 00 00       	mov    $0x14,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <chdir>:
SYSCALL(chdir)
 4d5:	b8 09 00 00 00       	mov    $0x9,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <dup>:
SYSCALL(dup)
 4dd:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <dup2>:
SYSCALL(dup2)
 4e5:	b8 17 00 00 00       	mov    $0x17,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <getpid>:
SYSCALL(getpid)
 4ed:	b8 0b 00 00 00       	mov    $0xb,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <sbrk>:
SYSCALL(sbrk)
 4f5:	b8 0c 00 00 00       	mov    $0xc,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <sleep>:
SYSCALL(sleep)
 4fd:	b8 0d 00 00 00       	mov    $0xd,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <uptime>:
SYSCALL(uptime)
 505:	b8 0e 00 00 00       	mov    $0xe,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <date>:
SYSCALL(date)
 50d:	b8 16 00 00 00       	mov    $0x16,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <getprio>:
SYSCALL(getprio)
 515:	b8 18 00 00 00       	mov    $0x18,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <setprio>:
SYSCALL(setprio)
 51d:	b8 19 00 00 00       	mov    $0x19,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 525:	55                   	push   %ebp
 526:	89 e5                	mov    %esp,%ebp
 528:	83 ec 1c             	sub    $0x1c,%esp
 52b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 52e:	6a 01                	push   $0x1
 530:	8d 55 f4             	lea    -0xc(%ebp),%edx
 533:	52                   	push   %edx
 534:	50                   	push   %eax
 535:	e8 4b ff ff ff       	call   485 <write>
}
 53a:	83 c4 10             	add    $0x10,%esp
 53d:	c9                   	leave  
 53e:	c3                   	ret    

0000053f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53f:	55                   	push   %ebp
 540:	89 e5                	mov    %esp,%ebp
 542:	57                   	push   %edi
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
 545:	83 ec 2c             	sub    $0x2c,%esp
 548:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 54b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 54d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 551:	74 04                	je     557 <printint+0x18>
 553:	85 d2                	test   %edx,%edx
 555:	78 3a                	js     591 <printint+0x52>
  neg = 0;
 557:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 55e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 563:	89 f0                	mov    %esi,%eax
 565:	ba 00 00 00 00       	mov    $0x0,%edx
 56a:	f7 f1                	div    %ecx
 56c:	89 df                	mov    %ebx,%edi
 56e:	43                   	inc    %ebx
 56f:	8a 92 50 07 00 00    	mov    0x750(%edx),%dl
 575:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 579:	89 f2                	mov    %esi,%edx
 57b:	89 c6                	mov    %eax,%esi
 57d:	39 d1                	cmp    %edx,%ecx
 57f:	76 e2                	jbe    563 <printint+0x24>
  if(neg)
 581:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 585:	74 22                	je     5a9 <printint+0x6a>
    buf[i++] = '-';
 587:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 58c:	8d 5f 02             	lea    0x2(%edi),%ebx
 58f:	eb 18                	jmp    5a9 <printint+0x6a>
    x = -xx;
 591:	f7 de                	neg    %esi
    neg = 1;
 593:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 59a:	eb c2                	jmp    55e <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 59c:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 5a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5a4:	e8 7c ff ff ff       	call   525 <putc>
  while(--i >= 0)
 5a9:	4b                   	dec    %ebx
 5aa:	79 f0                	jns    59c <printint+0x5d>
}
 5ac:	83 c4 2c             	add    $0x2c,%esp
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    

000005b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b4:	f3 0f 1e fb          	endbr32 
 5b8:	55                   	push   %ebp
 5b9:	89 e5                	mov    %esp,%ebp
 5bb:	57                   	push   %edi
 5bc:	56                   	push   %esi
 5bd:	53                   	push   %ebx
 5be:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5c1:	8d 45 10             	lea    0x10(%ebp),%eax
 5c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5c7:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5cc:	bb 00 00 00 00       	mov    $0x0,%ebx
 5d1:	eb 12                	jmp    5e5 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5d3:	89 fa                	mov    %edi,%edx
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	e8 48 ff ff ff       	call   525 <putc>
 5dd:	eb 05                	jmp    5e4 <printf+0x30>
      }
    } else if(state == '%'){
 5df:	83 fe 25             	cmp    $0x25,%esi
 5e2:	74 22                	je     606 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 5e4:	43                   	inc    %ebx
 5e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e8:	8a 04 18             	mov    (%eax,%ebx,1),%al
 5eb:	84 c0                	test   %al,%al
 5ed:	0f 84 13 01 00 00    	je     706 <printf+0x152>
    c = fmt[i] & 0xff;
 5f3:	0f be f8             	movsbl %al,%edi
 5f6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5f9:	85 f6                	test   %esi,%esi
 5fb:	75 e2                	jne    5df <printf+0x2b>
      if(c == '%'){
 5fd:	83 f8 25             	cmp    $0x25,%eax
 600:	75 d1                	jne    5d3 <printf+0x1f>
        state = '%';
 602:	89 c6                	mov    %eax,%esi
 604:	eb de                	jmp    5e4 <printf+0x30>
      if(c == 'd'){
 606:	83 f8 64             	cmp    $0x64,%eax
 609:	74 43                	je     64e <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 60b:	83 f8 78             	cmp    $0x78,%eax
 60e:	74 68                	je     678 <printf+0xc4>
 610:	83 f8 70             	cmp    $0x70,%eax
 613:	74 63                	je     678 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 615:	83 f8 73             	cmp    $0x73,%eax
 618:	0f 84 84 00 00 00    	je     6a2 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61e:	83 f8 63             	cmp    $0x63,%eax
 621:	0f 84 ad 00 00 00    	je     6d4 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 627:	83 f8 25             	cmp    $0x25,%eax
 62a:	0f 84 c2 00 00 00    	je     6f2 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 630:	ba 25 00 00 00       	mov    $0x25,%edx
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	e8 e8 fe ff ff       	call   525 <putc>
        putc(fd, c);
 63d:	89 fa                	mov    %edi,%edx
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	e8 de fe ff ff       	call   525 <putc>
      }
      state = 0;
 647:	be 00 00 00 00       	mov    $0x0,%esi
 64c:	eb 96                	jmp    5e4 <printf+0x30>
        printint(fd, *ap, 10, 1);
 64e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 651:	8b 17                	mov    (%edi),%edx
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	6a 01                	push   $0x1
 658:	b9 0a 00 00 00       	mov    $0xa,%ecx
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	e8 da fe ff ff       	call   53f <printint>
        ap++;
 665:	83 c7 04             	add    $0x4,%edi
 668:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 66b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66e:	be 00 00 00 00       	mov    $0x0,%esi
 673:	e9 6c ff ff ff       	jmp    5e4 <printf+0x30>
        printint(fd, *ap, 16, 0);
 678:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 67b:	8b 17                	mov    (%edi),%edx
 67d:	83 ec 0c             	sub    $0xc,%esp
 680:	6a 00                	push   $0x0
 682:	b9 10 00 00 00       	mov    $0x10,%ecx
 687:	8b 45 08             	mov    0x8(%ebp),%eax
 68a:	e8 b0 fe ff ff       	call   53f <printint>
        ap++;
 68f:	83 c7 04             	add    $0x4,%edi
 692:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 695:	83 c4 10             	add    $0x10,%esp
      state = 0;
 698:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 69d:	e9 42 ff ff ff       	jmp    5e4 <printf+0x30>
        s = (char*)*ap;
 6a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a5:	8b 30                	mov    (%eax),%esi
        ap++;
 6a7:	83 c0 04             	add    $0x4,%eax
 6aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6ad:	85 f6                	test   %esi,%esi
 6af:	75 13                	jne    6c4 <printf+0x110>
          s = "(null)";
 6b1:	be 46 07 00 00       	mov    $0x746,%esi
 6b6:	eb 0c                	jmp    6c4 <printf+0x110>
          putc(fd, *s);
 6b8:	0f be d2             	movsbl %dl,%edx
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	e8 62 fe ff ff       	call   525 <putc>
          s++;
 6c3:	46                   	inc    %esi
        while(*s != 0){
 6c4:	8a 16                	mov    (%esi),%dl
 6c6:	84 d2                	test   %dl,%dl
 6c8:	75 ee                	jne    6b8 <printf+0x104>
      state = 0;
 6ca:	be 00 00 00 00       	mov    $0x0,%esi
 6cf:	e9 10 ff ff ff       	jmp    5e4 <printf+0x30>
        putc(fd, *ap);
 6d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6d7:	0f be 17             	movsbl (%edi),%edx
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	e8 43 fe ff ff       	call   525 <putc>
        ap++;
 6e2:	83 c7 04             	add    $0x4,%edi
 6e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6e8:	be 00 00 00 00       	mov    $0x0,%esi
 6ed:	e9 f2 fe ff ff       	jmp    5e4 <printf+0x30>
        putc(fd, c);
 6f2:	89 fa                	mov    %edi,%edx
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	e8 29 fe ff ff       	call   525 <putc>
      state = 0;
 6fc:	be 00 00 00 00       	mov    $0x0,%esi
 701:	e9 de fe ff ff       	jmp    5e4 <printf+0x30>
    }
  }
}
 706:	8d 65 f4             	lea    -0xc(%ebp),%esp
 709:	5b                   	pop    %ebx
 70a:	5e                   	pop    %esi
 70b:	5f                   	pop    %edi
 70c:	5d                   	pop    %ebp
 70d:	c3                   	ret    
