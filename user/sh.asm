
sh:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
   c:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 e0 0f 00 00       	push   $0xfe0
  17:	6a 02                	push   $0x2
  19:	e8 19 0d 00 00       	call   d37 <printf>
  memset(buf, 0, nbuf);
  1e:	83 c4 0c             	add    $0xc,%esp
  21:	56                   	push   %esi
  22:	6a 00                	push   $0x0
  24:	53                   	push   %ebx
  25:	e8 81 0a 00 00       	call   aab <memset>
  gets(buf, nbuf);
  2a:	83 c4 08             	add    $0x8,%esp
  2d:	56                   	push   %esi
  2e:	53                   	push   %ebx
  2f:	e8 b2 0a 00 00       	call   ae6 <gets>
  if(buf[0] == 0) // EOF
  34:	83 c4 10             	add    $0x10,%esp
  37:	80 3b 00             	cmpb   $0x0,(%ebx)
  3a:	74 0c                	je     48 <getcmd+0x48>
    return -1;
  return 0;
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  44:	5b                   	pop    %ebx
  45:	5e                   	pop    %esi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
    return -1;
  48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4d:	eb f2                	jmp    41 <getcmd+0x41>

0000004f <panic>:
  exit(0);
}

void
panic(char *s)
{
  4f:	f3 0f 1e fb          	endbr32 
  53:	55                   	push   %ebp
  54:	89 e5                	mov    %esp,%ebp
  56:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
  59:	ff 75 08             	pushl  0x8(%ebp)
  5c:	68 7d 10 00 00       	push   $0x107d
  61:	6a 02                	push   $0x2
  63:	e8 cf 0c 00 00       	call   d37 <printf>
  exit(0);
  68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6f:	e8 74 0b 00 00       	call   be8 <exit>

00000074 <fork1>:
}

int
fork1(void)
{
  74:	f3 0f 1e fb          	endbr32 
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
  7e:	e8 5d 0b 00 00       	call   be0 <fork>
  if(pid == -1)
  83:	83 f8 ff             	cmp    $0xffffffff,%eax
  86:	74 02                	je     8a <fork1+0x16>
    panic("fork");
  return pid;
}
  88:	c9                   	leave  
  89:	c3                   	ret    
    panic("fork");
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	68 e3 0f 00 00       	push   $0xfe3
  92:	e8 b8 ff ff ff       	call   4f <panic>

00000097 <runcmd>:
{
  97:	f3 0f 1e fb          	endbr32 
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	53                   	push   %ebx
  9f:	83 ec 14             	sub    $0x14,%esp
  a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
  a5:	85 db                	test   %ebx,%ebx
  a7:	74 0f                	je     b8 <runcmd+0x21>
  switch(cmd->type){
  a9:	8b 03                	mov    (%ebx),%eax
  ab:	83 f8 05             	cmp    $0x5,%eax
  ae:	77 12                	ja     c2 <runcmd+0x2b>
  b0:	3e ff 24 85 a8 10 00 	notrack jmp *0x10a8(,%eax,4)
  b7:	00 
    exit(0);
  b8:	83 ec 0c             	sub    $0xc,%esp
  bb:	6a 00                	push   $0x0
  bd:	e8 26 0b 00 00       	call   be8 <exit>
    panic("runcmd");
  c2:	83 ec 0c             	sub    $0xc,%esp
  c5:	68 e8 0f 00 00       	push   $0xfe8
  ca:	e8 80 ff ff ff       	call   4f <panic>
    if(ecmd->argv[0] == 0)
  cf:	8b 43 04             	mov    0x4(%ebx),%eax
  d2:	85 c0                	test   %eax,%eax
  d4:	74 2c                	je     102 <runcmd+0x6b>
    exec(ecmd->argv[0], ecmd->argv);
  d6:	8d 53 04             	lea    0x4(%ebx),%edx
  d9:	83 ec 08             	sub    $0x8,%esp
  dc:	52                   	push   %edx
  dd:	50                   	push   %eax
  de:	e8 3d 0b 00 00       	call   c20 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
  e3:	83 c4 0c             	add    $0xc,%esp
  e6:	ff 73 04             	pushl  0x4(%ebx)
  e9:	68 ef 0f 00 00       	push   $0xfef
  ee:	6a 02                	push   $0x2
  f0:	e8 42 0c 00 00       	call   d37 <printf>
    break;
  f5:	83 c4 10             	add    $0x10,%esp
  exit(0);
  f8:	83 ec 0c             	sub    $0xc,%esp
  fb:	6a 00                	push   $0x0
  fd:	e8 e6 0a 00 00       	call   be8 <exit>
      exit(0);
 102:	83 ec 0c             	sub    $0xc,%esp
 105:	6a 00                	push   $0x0
 107:	e8 dc 0a 00 00       	call   be8 <exit>
    close(rcmd->fd);
 10c:	83 ec 0c             	sub    $0xc,%esp
 10f:	ff 73 14             	pushl  0x14(%ebx)
 112:	e8 f9 0a 00 00       	call   c10 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
 117:	83 c4 08             	add    $0x8,%esp
 11a:	ff 73 10             	pushl  0x10(%ebx)
 11d:	ff 73 08             	pushl  0x8(%ebx)
 120:	e8 03 0b 00 00       	call   c28 <open>
 125:	83 c4 10             	add    $0x10,%esp
 128:	85 c0                	test   %eax,%eax
 12a:	78 0b                	js     137 <runcmd+0xa0>
    runcmd(rcmd->cmd);
 12c:	83 ec 0c             	sub    $0xc,%esp
 12f:	ff 73 04             	pushl  0x4(%ebx)
 132:	e8 60 ff ff ff       	call   97 <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
 137:	83 ec 04             	sub    $0x4,%esp
 13a:	ff 73 08             	pushl  0x8(%ebx)
 13d:	68 ff 0f 00 00       	push   $0xfff
 142:	6a 02                	push   $0x2
 144:	e8 ee 0b 00 00       	call   d37 <printf>
      exit(0);
 149:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 150:	e8 93 0a 00 00       	call   be8 <exit>
    if(fork1() == 0)
 155:	e8 1a ff ff ff       	call   74 <fork1>
 15a:	85 c0                	test   %eax,%eax
 15c:	74 15                	je     173 <runcmd+0xdc>
    wait(NULL);
 15e:	83 ec 0c             	sub    $0xc,%esp
 161:	6a 00                	push   $0x0
 163:	e8 88 0a 00 00       	call   bf0 <wait>
    runcmd(lcmd->right);
 168:	83 c4 04             	add    $0x4,%esp
 16b:	ff 73 08             	pushl  0x8(%ebx)
 16e:	e8 24 ff ff ff       	call   97 <runcmd>
      runcmd(lcmd->left);
 173:	83 ec 0c             	sub    $0xc,%esp
 176:	ff 73 04             	pushl  0x4(%ebx)
 179:	e8 19 ff ff ff       	call   97 <runcmd>
    if(pipe(p) < 0)
 17e:	83 ec 0c             	sub    $0xc,%esp
 181:	8d 45 f0             	lea    -0x10(%ebp),%eax
 184:	50                   	push   %eax
 185:	e8 6e 0a 00 00       	call   bf8 <pipe>
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	85 c0                	test   %eax,%eax
 18f:	78 48                	js     1d9 <runcmd+0x142>
    if(fork1() == 0){
 191:	e8 de fe ff ff       	call   74 <fork1>
 196:	85 c0                	test   %eax,%eax
 198:	74 4c                	je     1e6 <runcmd+0x14f>
    if(fork1() == 0){
 19a:	e8 d5 fe ff ff       	call   74 <fork1>
 19f:	85 c0                	test   %eax,%eax
 1a1:	74 7b                	je     21e <runcmd+0x187>
    close(p[0]);
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 62 0a 00 00       	call   c10 <close>
    close(p[1]);
 1ae:	83 c4 04             	add    $0x4,%esp
 1b1:	ff 75 f4             	pushl  -0xc(%ebp)
 1b4:	e8 57 0a 00 00       	call   c10 <close>
    wait(NULL);
 1b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c0:	e8 2b 0a 00 00       	call   bf0 <wait>
    wait(NULL);
 1c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1cc:	e8 1f 0a 00 00       	call   bf0 <wait>
    break;
 1d1:	83 c4 10             	add    $0x10,%esp
 1d4:	e9 1f ff ff ff       	jmp    f8 <runcmd+0x61>
      panic("pipe");
 1d9:	83 ec 0c             	sub    $0xc,%esp
 1dc:	68 0f 10 00 00       	push   $0x100f
 1e1:	e8 69 fe ff ff       	call   4f <panic>
      close(1);
 1e6:	83 ec 0c             	sub    $0xc,%esp
 1e9:	6a 01                	push   $0x1
 1eb:	e8 20 0a 00 00       	call   c10 <close>
      dup2(p[1],1);
 1f0:	83 c4 08             	add    $0x8,%esp
 1f3:	6a 01                	push   $0x1
 1f5:	ff 75 f4             	pushl  -0xc(%ebp)
 1f8:	e8 6b 0a 00 00       	call   c68 <dup2>
      close(p[0]);
 1fd:	83 c4 04             	add    $0x4,%esp
 200:	ff 75 f0             	pushl  -0x10(%ebp)
 203:	e8 08 0a 00 00       	call   c10 <close>
      close(p[1]);
 208:	83 c4 04             	add    $0x4,%esp
 20b:	ff 75 f4             	pushl  -0xc(%ebp)
 20e:	e8 fd 09 00 00       	call   c10 <close>
      runcmd(pcmd->left);
 213:	83 c4 04             	add    $0x4,%esp
 216:	ff 73 04             	pushl  0x4(%ebx)
 219:	e8 79 fe ff ff       	call   97 <runcmd>
      close(0);
 21e:	83 ec 0c             	sub    $0xc,%esp
 221:	6a 00                	push   $0x0
 223:	e8 e8 09 00 00       	call   c10 <close>
      dup2(p[0],0);
 228:	83 c4 08             	add    $0x8,%esp
 22b:	6a 00                	push   $0x0
 22d:	ff 75 f0             	pushl  -0x10(%ebp)
 230:	e8 33 0a 00 00       	call   c68 <dup2>
      close(p[0]);
 235:	83 c4 04             	add    $0x4,%esp
 238:	ff 75 f0             	pushl  -0x10(%ebp)
 23b:	e8 d0 09 00 00       	call   c10 <close>
      close(p[1]);
 240:	83 c4 04             	add    $0x4,%esp
 243:	ff 75 f4             	pushl  -0xc(%ebp)
 246:	e8 c5 09 00 00       	call   c10 <close>
      runcmd(pcmd->right);
 24b:	83 c4 04             	add    $0x4,%esp
 24e:	ff 73 08             	pushl  0x8(%ebx)
 251:	e8 41 fe ff ff       	call   97 <runcmd>
    if(fork1() == 0)
 256:	e8 19 fe ff ff       	call   74 <fork1>
 25b:	85 c0                	test   %eax,%eax
 25d:	0f 85 95 fe ff ff    	jne    f8 <runcmd+0x61>
      runcmd(bcmd->cmd);
 263:	83 ec 0c             	sub    $0xc,%esp
 266:	ff 73 04             	pushl  0x4(%ebx)
 269:	e8 29 fe ff ff       	call   97 <runcmd>

0000026e <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 26e:	f3 0f 1e fb          	endbr32 
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 279:	6a 54                	push   $0x54
 27b:	e8 d5 0c 00 00       	call   f55 <malloc>
 280:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 282:	83 c4 0c             	add    $0xc,%esp
 285:	6a 54                	push   $0x54
 287:	6a 00                	push   $0x0
 289:	50                   	push   %eax
 28a:	e8 1c 08 00 00       	call   aab <memset>
  cmd->type = EXEC;
 28f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
 295:	89 d8                	mov    %ebx,%eax
 297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 29c:	f3 0f 1e fb          	endbr32 
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2a7:	6a 18                	push   $0x18
 2a9:	e8 a7 0c 00 00       	call   f55 <malloc>
 2ae:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2b0:	83 c4 0c             	add    $0xc,%esp
 2b3:	6a 18                	push   $0x18
 2b5:	6a 00                	push   $0x0
 2b7:	50                   	push   %eax
 2b8:	e8 ee 07 00 00       	call   aab <memset>
  cmd->type = REDIR;
 2bd:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
 2cf:	8b 45 10             	mov    0x10(%ebp),%eax
 2d2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
 2d5:	8b 45 14             	mov    0x14(%ebp),%eax
 2d8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
 2db:	8b 45 18             	mov    0x18(%ebp),%eax
 2de:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
 2e1:	89 d8                	mov    %ebx,%eax
 2e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e6:	c9                   	leave  
 2e7:	c3                   	ret    

000002e8 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 2e8:	f3 0f 1e fb          	endbr32 
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2f3:	6a 0c                	push   $0xc
 2f5:	e8 5b 0c 00 00       	call   f55 <malloc>
 2fa:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2fc:	83 c4 0c             	add    $0xc,%esp
 2ff:	6a 0c                	push   $0xc
 301:	6a 00                	push   $0x0
 303:	50                   	push   %eax
 304:	e8 a2 07 00 00       	call   aab <memset>
  cmd->type = PIPE;
 309:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 31b:	89 d8                	mov    %ebx,%eax
 31d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 322:	f3 0f 1e fb          	endbr32 
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	53                   	push   %ebx
 32a:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 32d:	6a 0c                	push   $0xc
 32f:	e8 21 0c 00 00       	call   f55 <malloc>
 334:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 336:	83 c4 0c             	add    $0xc,%esp
 339:	6a 0c                	push   $0xc
 33b:	6a 00                	push   $0x0
 33d:	50                   	push   %eax
 33e:	e8 68 07 00 00       	call   aab <memset>
  cmd->type = LIST;
 343:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 355:	89 d8                	mov    %ebx,%eax
 357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 35a:	c9                   	leave  
 35b:	c3                   	ret    

0000035c <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 35c:	f3 0f 1e fb          	endbr32 
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 367:	6a 08                	push   $0x8
 369:	e8 e7 0b 00 00       	call   f55 <malloc>
 36e:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 370:	83 c4 0c             	add    $0xc,%esp
 373:	6a 08                	push   $0x8
 375:	6a 00                	push   $0x0
 377:	50                   	push   %eax
 378:	e8 2e 07 00 00       	call   aab <memset>
  cmd->type = BACK;
 37d:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
 389:	89 d8                	mov    %ebx,%eax
 38b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	57                   	push   %edi
 398:	56                   	push   %esi
 399:	53                   	push   %ebx
 39a:	83 ec 0c             	sub    $0xc,%esp
 39d:	8b 75 0c             	mov    0xc(%ebp),%esi
 3a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
 3a8:	39 f3                	cmp    %esi,%ebx
 3aa:	73 1b                	jae    3c7 <gettoken+0x37>
 3ac:	83 ec 08             	sub    $0x8,%esp
 3af:	0f be 03             	movsbl (%ebx),%eax
 3b2:	50                   	push   %eax
 3b3:	68 70 16 00 00       	push   $0x1670
 3b8:	e8 08 07 00 00       	call   ac5 <strchr>
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	85 c0                	test   %eax,%eax
 3c2:	74 03                	je     3c7 <gettoken+0x37>
    s++;
 3c4:	43                   	inc    %ebx
 3c5:	eb e1                	jmp    3a8 <gettoken+0x18>
  if(q)
 3c7:	85 ff                	test   %edi,%edi
 3c9:	74 02                	je     3cd <gettoken+0x3d>
    *q = s;
 3cb:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
 3cd:	8a 03                	mov    (%ebx),%al
 3cf:	0f be f8             	movsbl %al,%edi
  switch(*s){
 3d2:	3c 3c                	cmp    $0x3c,%al
 3d4:	7f 25                	jg     3fb <gettoken+0x6b>
 3d6:	3c 3b                	cmp    $0x3b,%al
 3d8:	7d 13                	jge    3ed <gettoken+0x5d>
 3da:	84 c0                	test   %al,%al
 3dc:	74 10                	je     3ee <gettoken+0x5e>
 3de:	78 3d                	js     41d <gettoken+0x8d>
 3e0:	3c 26                	cmp    $0x26,%al
 3e2:	74 09                	je     3ed <gettoken+0x5d>
 3e4:	7c 37                	jl     41d <gettoken+0x8d>
 3e6:	83 e8 28             	sub    $0x28,%eax
 3e9:	3c 01                	cmp    $0x1,%al
 3eb:	77 30                	ja     41d <gettoken+0x8d>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
 3ed:	43                   	inc    %ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 3ee:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f2:	74 73                	je     467 <gettoken+0xd7>
    *eq = s;
 3f4:	8b 45 14             	mov    0x14(%ebp),%eax
 3f7:	89 18                	mov    %ebx,(%eax)
 3f9:	eb 6c                	jmp    467 <gettoken+0xd7>
  switch(*s){
 3fb:	3c 3e                	cmp    $0x3e,%al
 3fd:	75 0d                	jne    40c <gettoken+0x7c>
    s++;
 3ff:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
 402:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
 406:	74 0a                	je     412 <gettoken+0x82>
    s++;
 408:	89 c3                	mov    %eax,%ebx
 40a:	eb e2                	jmp    3ee <gettoken+0x5e>
  switch(*s){
 40c:	3c 7c                	cmp    $0x7c,%al
 40e:	75 0d                	jne    41d <gettoken+0x8d>
 410:	eb db                	jmp    3ed <gettoken+0x5d>
      s++;
 412:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
 415:	bf 2b 00 00 00       	mov    $0x2b,%edi
 41a:	eb d2                	jmp    3ee <gettoken+0x5e>
      s++;
 41c:	43                   	inc    %ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 41d:	39 f3                	cmp    %esi,%ebx
 41f:	73 37                	jae    458 <gettoken+0xc8>
 421:	83 ec 08             	sub    $0x8,%esp
 424:	0f be 03             	movsbl (%ebx),%eax
 427:	50                   	push   %eax
 428:	68 70 16 00 00       	push   $0x1670
 42d:	e8 93 06 00 00       	call   ac5 <strchr>
 432:	83 c4 10             	add    $0x10,%esp
 435:	85 c0                	test   %eax,%eax
 437:	75 26                	jne    45f <gettoken+0xcf>
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	0f be 03             	movsbl (%ebx),%eax
 43f:	50                   	push   %eax
 440:	68 68 16 00 00       	push   $0x1668
 445:	e8 7b 06 00 00       	call   ac5 <strchr>
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	85 c0                	test   %eax,%eax
 44f:	74 cb                	je     41c <gettoken+0x8c>
    ret = 'a';
 451:	bf 61 00 00 00       	mov    $0x61,%edi
 456:	eb 96                	jmp    3ee <gettoken+0x5e>
 458:	bf 61 00 00 00       	mov    $0x61,%edi
 45d:	eb 8f                	jmp    3ee <gettoken+0x5e>
 45f:	bf 61 00 00 00       	mov    $0x61,%edi
 464:	eb 88                	jmp    3ee <gettoken+0x5e>

  while(s < es && strchr(whitespace, *s))
    s++;
 466:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
 467:	39 f3                	cmp    %esi,%ebx
 469:	73 18                	jae    483 <gettoken+0xf3>
 46b:	83 ec 08             	sub    $0x8,%esp
 46e:	0f be 03             	movsbl (%ebx),%eax
 471:	50                   	push   %eax
 472:	68 70 16 00 00       	push   $0x1670
 477:	e8 49 06 00 00       	call   ac5 <strchr>
 47c:	83 c4 10             	add    $0x10,%esp
 47f:	85 c0                	test   %eax,%eax
 481:	75 e3                	jne    466 <gettoken+0xd6>
  *ps = s;
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	89 18                	mov    %ebx,(%eax)
  return ret;
}
 488:	89 f8                	mov    %edi,%eax
 48a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48d:	5b                   	pop    %ebx
 48e:	5e                   	pop    %esi
 48f:	5f                   	pop    %edi
 490:	5d                   	pop    %ebp
 491:	c3                   	ret    

00000492 <peek>:

int
peek(char **ps, char *es, char *toks)
{
 492:	f3 0f 1e fb          	endbr32 
 496:	55                   	push   %ebp
 497:	89 e5                	mov    %esp,%ebp
 499:	57                   	push   %edi
 49a:	56                   	push   %esi
 49b:	53                   	push   %ebx
 49c:	83 ec 0c             	sub    $0xc,%esp
 49f:	8b 7d 08             	mov    0x8(%ebp),%edi
 4a2:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 4a5:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 4a7:	39 f3                	cmp    %esi,%ebx
 4a9:	73 1b                	jae    4c6 <peek+0x34>
 4ab:	83 ec 08             	sub    $0x8,%esp
 4ae:	0f be 03             	movsbl (%ebx),%eax
 4b1:	50                   	push   %eax
 4b2:	68 70 16 00 00       	push   $0x1670
 4b7:	e8 09 06 00 00       	call   ac5 <strchr>
 4bc:	83 c4 10             	add    $0x10,%esp
 4bf:	85 c0                	test   %eax,%eax
 4c1:	74 03                	je     4c6 <peek+0x34>
    s++;
 4c3:	43                   	inc    %ebx
 4c4:	eb e1                	jmp    4a7 <peek+0x15>
  *ps = s;
 4c6:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 4c8:	8a 03                	mov    (%ebx),%al
 4ca:	84 c0                	test   %al,%al
 4cc:	75 0d                	jne    4db <peek+0x49>
 4ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret    
  return *s && strchr(toks, *s);
 4db:	83 ec 08             	sub    $0x8,%esp
 4de:	0f be c0             	movsbl %al,%eax
 4e1:	50                   	push   %eax
 4e2:	ff 75 10             	pushl  0x10(%ebp)
 4e5:	e8 db 05 00 00       	call   ac5 <strchr>
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	85 c0                	test   %eax,%eax
 4ef:	74 07                	je     4f8 <peek+0x66>
 4f1:	b8 01 00 00 00       	mov    $0x1,%eax
 4f6:	eb db                	jmp    4d3 <peek+0x41>
 4f8:	b8 00 00 00 00       	mov    $0x0,%eax
 4fd:	eb d4                	jmp    4d3 <peek+0x41>

000004ff <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 4ff:	f3 0f 1e fb          	endbr32 
 503:	55                   	push   %ebp
 504:	89 e5                	mov    %esp,%ebp
 506:	57                   	push   %edi
 507:	56                   	push   %esi
 508:	53                   	push   %ebx
 509:	83 ec 1c             	sub    $0x1c,%esp
 50c:	8b 7d 0c             	mov    0xc(%ebp),%edi
 50f:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 512:	eb 28                	jmp    53c <parseredirs+0x3d>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
 514:	83 ec 0c             	sub    $0xc,%esp
 517:	68 14 10 00 00       	push   $0x1014
 51c:	e8 2e fb ff ff       	call   4f <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 521:	83 ec 0c             	sub    $0xc,%esp
 524:	6a 00                	push   $0x0
 526:	6a 00                	push   $0x0
 528:	ff 75 e0             	pushl  -0x20(%ebp)
 52b:	ff 75 e4             	pushl  -0x1c(%ebp)
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 66 fd ff ff       	call   29c <redircmd>
 536:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 539:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
 53c:	83 ec 04             	sub    $0x4,%esp
 53f:	68 31 10 00 00       	push   $0x1031
 544:	56                   	push   %esi
 545:	57                   	push   %edi
 546:	e8 47 ff ff ff       	call   492 <peek>
 54b:	83 c4 10             	add    $0x10,%esp
 54e:	85 c0                	test   %eax,%eax
 550:	74 76                	je     5c8 <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
 552:	6a 00                	push   $0x0
 554:	6a 00                	push   $0x0
 556:	56                   	push   %esi
 557:	57                   	push   %edi
 558:	e8 33 fe ff ff       	call   390 <gettoken>
 55d:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
 55f:	8d 45 e0             	lea    -0x20(%ebp),%eax
 562:	50                   	push   %eax
 563:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 566:	50                   	push   %eax
 567:	56                   	push   %esi
 568:	57                   	push   %edi
 569:	e8 22 fe ff ff       	call   390 <gettoken>
 56e:	83 c4 20             	add    $0x20,%esp
 571:	83 f8 61             	cmp    $0x61,%eax
 574:	75 9e                	jne    514 <parseredirs+0x15>
    switch(tok){
 576:	83 fb 3c             	cmp    $0x3c,%ebx
 579:	74 a6                	je     521 <parseredirs+0x22>
 57b:	83 fb 3e             	cmp    $0x3e,%ebx
 57e:	74 25                	je     5a5 <parseredirs+0xa6>
 580:	83 fb 2b             	cmp    $0x2b,%ebx
 583:	75 b7                	jne    53c <parseredirs+0x3d>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 585:	83 ec 0c             	sub    $0xc,%esp
 588:	6a 01                	push   $0x1
 58a:	68 01 02 00 00       	push   $0x201
 58f:	ff 75 e0             	pushl  -0x20(%ebp)
 592:	ff 75 e4             	pushl  -0x1c(%ebp)
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 ff fc ff ff       	call   29c <redircmd>
 59d:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 5a0:	83 c4 20             	add    $0x20,%esp
 5a3:	eb 97                	jmp    53c <parseredirs+0x3d>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 5a5:	83 ec 0c             	sub    $0xc,%esp
 5a8:	6a 01                	push   $0x1
 5aa:	68 01 02 00 00       	push   $0x201
 5af:	ff 75 e0             	pushl  -0x20(%ebp)
 5b2:	ff 75 e4             	pushl  -0x1c(%ebp)
 5b5:	ff 75 08             	pushl  0x8(%ebp)
 5b8:	e8 df fc ff ff       	call   29c <redircmd>
 5bd:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 5c0:	83 c4 20             	add    $0x20,%esp
 5c3:	e9 74 ff ff ff       	jmp    53c <parseredirs+0x3d>
    }
  }
  return cmd;
}
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ce:	5b                   	pop    %ebx
 5cf:	5e                   	pop    %esi
 5d0:	5f                   	pop    %edi
 5d1:	5d                   	pop    %ebp
 5d2:	c3                   	ret    

000005d3 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 5d3:	f3 0f 1e fb          	endbr32 
 5d7:	55                   	push   %ebp
 5d8:	89 e5                	mov    %esp,%ebp
 5da:	57                   	push   %edi
 5db:	56                   	push   %esi
 5dc:	53                   	push   %ebx
 5dd:	83 ec 30             	sub    $0x30,%esp
 5e0:	8b 75 08             	mov    0x8(%ebp),%esi
 5e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
 5e6:	68 34 10 00 00       	push   $0x1034
 5eb:	57                   	push   %edi
 5ec:	56                   	push   %esi
 5ed:	e8 a0 fe ff ff       	call   492 <peek>
 5f2:	83 c4 10             	add    $0x10,%esp
 5f5:	85 c0                	test   %eax,%eax
 5f7:	75 1d                	jne    616 <parseexec+0x43>
 5f9:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
 5fb:	e8 6e fc ff ff       	call   26e <execcmd>
 600:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	57                   	push   %edi
 607:	56                   	push   %esi
 608:	50                   	push   %eax
 609:	e8 f1 fe ff ff       	call   4ff <parseredirs>
 60e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
 611:	83 c4 10             	add    $0x10,%esp
 614:	eb 3b                	jmp    651 <parseexec+0x7e>
    return parseblock(ps, es);
 616:	83 ec 08             	sub    $0x8,%esp
 619:	57                   	push   %edi
 61a:	56                   	push   %esi
 61b:	e8 95 01 00 00       	call   7b5 <parseblock>
 620:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 623:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
 626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 629:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62c:	5b                   	pop    %ebx
 62d:	5e                   	pop    %esi
 62e:	5f                   	pop    %edi
 62f:	5d                   	pop    %ebp
 630:	c3                   	ret    
      panic("syntax");
 631:	83 ec 0c             	sub    $0xc,%esp
 634:	68 36 10 00 00       	push   $0x1036
 639:	e8 11 fa ff ff       	call   4f <panic>
    ret = parseredirs(ret, ps, es);
 63e:	83 ec 04             	sub    $0x4,%esp
 641:	57                   	push   %edi
 642:	56                   	push   %esi
 643:	ff 75 d4             	pushl  -0x2c(%ebp)
 646:	e8 b4 fe ff ff       	call   4ff <parseredirs>
 64b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 64e:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
 651:	83 ec 04             	sub    $0x4,%esp
 654:	68 4b 10 00 00       	push   $0x104b
 659:	57                   	push   %edi
 65a:	56                   	push   %esi
 65b:	e8 32 fe ff ff       	call   492 <peek>
 660:	83 c4 10             	add    $0x10,%esp
 663:	85 c0                	test   %eax,%eax
 665:	75 3f                	jne    6a6 <parseexec+0xd3>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 667:	8d 45 e0             	lea    -0x20(%ebp),%eax
 66a:	50                   	push   %eax
 66b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 66e:	50                   	push   %eax
 66f:	57                   	push   %edi
 670:	56                   	push   %esi
 671:	e8 1a fd ff ff       	call   390 <gettoken>
 676:	83 c4 10             	add    $0x10,%esp
 679:	85 c0                	test   %eax,%eax
 67b:	74 29                	je     6a6 <parseexec+0xd3>
    if(tok != 'a')
 67d:	83 f8 61             	cmp    $0x61,%eax
 680:	75 af                	jne    631 <parseexec+0x5e>
    cmd->argv[argc] = q;
 682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 685:	8b 55 d0             	mov    -0x30(%ebp),%edx
 688:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
 68c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 68f:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
 693:	43                   	inc    %ebx
    if(argc >= MAXARGS)
 694:	83 fb 09             	cmp    $0x9,%ebx
 697:	7e a5                	jle    63e <parseexec+0x6b>
      panic("too many args");
 699:	83 ec 0c             	sub    $0xc,%esp
 69c:	68 3d 10 00 00       	push   $0x103d
 6a1:	e8 a9 f9 ff ff       	call   4f <panic>
  cmd->argv[argc] = 0;
 6a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6a9:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
 6b0:	00 
  cmd->eargv[argc] = 0;
 6b1:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
 6b8:	00 
  return ret;
 6b9:	e9 68 ff ff ff       	jmp    626 <parseexec+0x53>

000006be <parsepipe>:
{
 6be:	f3 0f 1e fb          	endbr32 
 6c2:	55                   	push   %ebp
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	57                   	push   %edi
 6c6:	56                   	push   %esi
 6c7:	53                   	push   %ebx
 6c8:	83 ec 14             	sub    $0x14,%esp
 6cb:	8b 75 08             	mov    0x8(%ebp),%esi
 6ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
 6d1:	57                   	push   %edi
 6d2:	56                   	push   %esi
 6d3:	e8 fb fe ff ff       	call   5d3 <parseexec>
 6d8:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
 6da:	83 c4 0c             	add    $0xc,%esp
 6dd:	68 50 10 00 00       	push   $0x1050
 6e2:	57                   	push   %edi
 6e3:	56                   	push   %esi
 6e4:	e8 a9 fd ff ff       	call   492 <peek>
 6e9:	83 c4 10             	add    $0x10,%esp
 6ec:	85 c0                	test   %eax,%eax
 6ee:	75 0a                	jne    6fa <parsepipe+0x3c>
}
 6f0:	89 d8                	mov    %ebx,%eax
 6f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f5:	5b                   	pop    %ebx
 6f6:	5e                   	pop    %esi
 6f7:	5f                   	pop    %edi
 6f8:	5d                   	pop    %ebp
 6f9:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 6fa:	6a 00                	push   $0x0
 6fc:	6a 00                	push   $0x0
 6fe:	57                   	push   %edi
 6ff:	56                   	push   %esi
 700:	e8 8b fc ff ff       	call   390 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 705:	83 c4 08             	add    $0x8,%esp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	e8 af ff ff ff       	call   6be <parsepipe>
 70f:	83 c4 08             	add    $0x8,%esp
 712:	50                   	push   %eax
 713:	53                   	push   %ebx
 714:	e8 cf fb ff ff       	call   2e8 <pipecmd>
 719:	89 c3                	mov    %eax,%ebx
 71b:	83 c4 10             	add    $0x10,%esp
  return cmd;
 71e:	eb d0                	jmp    6f0 <parsepipe+0x32>

00000720 <parseline>:
{
 720:	f3 0f 1e fb          	endbr32 
 724:	55                   	push   %ebp
 725:	89 e5                	mov    %esp,%ebp
 727:	57                   	push   %edi
 728:	56                   	push   %esi
 729:	53                   	push   %ebx
 72a:	83 ec 14             	sub    $0x14,%esp
 72d:	8b 75 08             	mov    0x8(%ebp),%esi
 730:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	e8 84 ff ff ff       	call   6be <parsepipe>
 73a:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
 73c:	83 c4 10             	add    $0x10,%esp
 73f:	83 ec 04             	sub    $0x4,%esp
 742:	68 52 10 00 00       	push   $0x1052
 747:	57                   	push   %edi
 748:	56                   	push   %esi
 749:	e8 44 fd ff ff       	call   492 <peek>
 74e:	83 c4 10             	add    $0x10,%esp
 751:	85 c0                	test   %eax,%eax
 753:	74 1a                	je     76f <parseline+0x4f>
    gettoken(ps, es, 0, 0);
 755:	6a 00                	push   $0x0
 757:	6a 00                	push   $0x0
 759:	57                   	push   %edi
 75a:	56                   	push   %esi
 75b:	e8 30 fc ff ff       	call   390 <gettoken>
    cmd = backcmd(cmd);
 760:	89 1c 24             	mov    %ebx,(%esp)
 763:	e8 f4 fb ff ff       	call   35c <backcmd>
 768:	89 c3                	mov    %eax,%ebx
 76a:	83 c4 10             	add    $0x10,%esp
 76d:	eb d0                	jmp    73f <parseline+0x1f>
  if(peek(ps, es, ";")){
 76f:	83 ec 04             	sub    $0x4,%esp
 772:	68 4e 10 00 00       	push   $0x104e
 777:	57                   	push   %edi
 778:	56                   	push   %esi
 779:	e8 14 fd ff ff       	call   492 <peek>
 77e:	83 c4 10             	add    $0x10,%esp
 781:	85 c0                	test   %eax,%eax
 783:	75 0a                	jne    78f <parseline+0x6f>
}
 785:	89 d8                	mov    %ebx,%eax
 787:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78a:	5b                   	pop    %ebx
 78b:	5e                   	pop    %esi
 78c:	5f                   	pop    %edi
 78d:	5d                   	pop    %ebp
 78e:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 78f:	6a 00                	push   $0x0
 791:	6a 00                	push   $0x0
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	e8 f6 fb ff ff       	call   390 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 79a:	83 c4 08             	add    $0x8,%esp
 79d:	57                   	push   %edi
 79e:	56                   	push   %esi
 79f:	e8 7c ff ff ff       	call   720 <parseline>
 7a4:	83 c4 08             	add    $0x8,%esp
 7a7:	50                   	push   %eax
 7a8:	53                   	push   %ebx
 7a9:	e8 74 fb ff ff       	call   322 <listcmd>
 7ae:	89 c3                	mov    %eax,%ebx
 7b0:	83 c4 10             	add    $0x10,%esp
  return cmd;
 7b3:	eb d0                	jmp    785 <parseline+0x65>

000007b5 <parseblock>:
{
 7b5:	f3 0f 1e fb          	endbr32 
 7b9:	55                   	push   %ebp
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	57                   	push   %edi
 7bd:	56                   	push   %esi
 7be:	53                   	push   %ebx
 7bf:	83 ec 10             	sub    $0x10,%esp
 7c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
 7c8:	68 34 10 00 00       	push   $0x1034
 7cd:	56                   	push   %esi
 7ce:	53                   	push   %ebx
 7cf:	e8 be fc ff ff       	call   492 <peek>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	85 c0                	test   %eax,%eax
 7d9:	74 4b                	je     826 <parseblock+0x71>
  gettoken(ps, es, 0, 0);
 7db:	6a 00                	push   $0x0
 7dd:	6a 00                	push   $0x0
 7df:	56                   	push   %esi
 7e0:	53                   	push   %ebx
 7e1:	e8 aa fb ff ff       	call   390 <gettoken>
  cmd = parseline(ps, es);
 7e6:	83 c4 08             	add    $0x8,%esp
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	e8 30 ff ff ff       	call   720 <parseline>
 7f0:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
 7f2:	83 c4 0c             	add    $0xc,%esp
 7f5:	68 70 10 00 00       	push   $0x1070
 7fa:	56                   	push   %esi
 7fb:	53                   	push   %ebx
 7fc:	e8 91 fc ff ff       	call   492 <peek>
 801:	83 c4 10             	add    $0x10,%esp
 804:	85 c0                	test   %eax,%eax
 806:	74 2b                	je     833 <parseblock+0x7e>
  gettoken(ps, es, 0, 0);
 808:	6a 00                	push   $0x0
 80a:	6a 00                	push   $0x0
 80c:	56                   	push   %esi
 80d:	53                   	push   %ebx
 80e:	e8 7d fb ff ff       	call   390 <gettoken>
  cmd = parseredirs(cmd, ps, es);
 813:	83 c4 0c             	add    $0xc,%esp
 816:	56                   	push   %esi
 817:	53                   	push   %ebx
 818:	57                   	push   %edi
 819:	e8 e1 fc ff ff       	call   4ff <parseredirs>
}
 81e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 821:	5b                   	pop    %ebx
 822:	5e                   	pop    %esi
 823:	5f                   	pop    %edi
 824:	5d                   	pop    %ebp
 825:	c3                   	ret    
    panic("parseblock");
 826:	83 ec 0c             	sub    $0xc,%esp
 829:	68 54 10 00 00       	push   $0x1054
 82e:	e8 1c f8 ff ff       	call   4f <panic>
    panic("syntax - missing )");
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	68 5f 10 00 00       	push   $0x105f
 83b:	e8 0f f8 ff ff       	call   4f <panic>

00000840 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 840:	f3 0f 1e fb          	endbr32 
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	53                   	push   %ebx
 848:	83 ec 04             	sub    $0x4,%esp
 84b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 84e:	85 db                	test   %ebx,%ebx
 850:	74 39                	je     88b <nulterminate+0x4b>
    return 0;

  switch(cmd->type){
 852:	8b 03                	mov    (%ebx),%eax
 854:	83 f8 05             	cmp    $0x5,%eax
 857:	77 32                	ja     88b <nulterminate+0x4b>
 859:	3e ff 24 85 c0 10 00 	notrack jmp *0x10c0(,%eax,4)
 860:	00 
 861:	b8 00 00 00 00       	mov    $0x0,%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
 866:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
 86b:	74 1e                	je     88b <nulterminate+0x4b>
      *ecmd->eargv[i] = 0;
 86d:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
 871:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
 874:	40                   	inc    %eax
 875:	eb ef                	jmp    866 <nulterminate+0x26>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
 877:	83 ec 0c             	sub    $0xc,%esp
 87a:	ff 73 04             	pushl  0x4(%ebx)
 87d:	e8 be ff ff ff       	call   840 <nulterminate>
    *rcmd->efile = 0;
 882:	8b 43 0c             	mov    0xc(%ebx),%eax
 885:	c6 00 00             	movb   $0x0,(%eax)
    break;
 888:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
 88b:	89 d8                	mov    %ebx,%eax
 88d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 890:	c9                   	leave  
 891:	c3                   	ret    
    nulterminate(pcmd->left);
 892:	83 ec 0c             	sub    $0xc,%esp
 895:	ff 73 04             	pushl  0x4(%ebx)
 898:	e8 a3 ff ff ff       	call   840 <nulterminate>
    nulterminate(pcmd->right);
 89d:	83 c4 04             	add    $0x4,%esp
 8a0:	ff 73 08             	pushl  0x8(%ebx)
 8a3:	e8 98 ff ff ff       	call   840 <nulterminate>
    break;
 8a8:	83 c4 10             	add    $0x10,%esp
 8ab:	eb de                	jmp    88b <nulterminate+0x4b>
    nulterminate(lcmd->left);
 8ad:	83 ec 0c             	sub    $0xc,%esp
 8b0:	ff 73 04             	pushl  0x4(%ebx)
 8b3:	e8 88 ff ff ff       	call   840 <nulterminate>
    nulterminate(lcmd->right);
 8b8:	83 c4 04             	add    $0x4,%esp
 8bb:	ff 73 08             	pushl  0x8(%ebx)
 8be:	e8 7d ff ff ff       	call   840 <nulterminate>
    break;
 8c3:	83 c4 10             	add    $0x10,%esp
 8c6:	eb c3                	jmp    88b <nulterminate+0x4b>
    nulterminate(bcmd->cmd);
 8c8:	83 ec 0c             	sub    $0xc,%esp
 8cb:	ff 73 04             	pushl  0x4(%ebx)
 8ce:	e8 6d ff ff ff       	call   840 <nulterminate>
    break;
 8d3:	83 c4 10             	add    $0x10,%esp
 8d6:	eb b3                	jmp    88b <nulterminate+0x4b>

000008d8 <parsecmd>:
{
 8d8:	f3 0f 1e fb          	endbr32 
 8dc:	55                   	push   %ebp
 8dd:	89 e5                	mov    %esp,%ebp
 8df:	56                   	push   %esi
 8e0:	53                   	push   %ebx
  es = s + strlen(s);
 8e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8e4:	83 ec 0c             	sub    $0xc,%esp
 8e7:	53                   	push   %ebx
 8e8:	e8 a4 01 00 00       	call   a91 <strlen>
 8ed:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
 8ef:	83 c4 08             	add    $0x8,%esp
 8f2:	53                   	push   %ebx
 8f3:	8d 45 08             	lea    0x8(%ebp),%eax
 8f6:	50                   	push   %eax
 8f7:	e8 24 fe ff ff       	call   720 <parseline>
 8fc:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 8fe:	83 c4 0c             	add    $0xc,%esp
 901:	68 a7 10 00 00       	push   $0x10a7
 906:	53                   	push   %ebx
 907:	8d 45 08             	lea    0x8(%ebp),%eax
 90a:	50                   	push   %eax
 90b:	e8 82 fb ff ff       	call   492 <peek>
  if(s != es){
 910:	8b 45 08             	mov    0x8(%ebp),%eax
 913:	83 c4 10             	add    $0x10,%esp
 916:	39 d8                	cmp    %ebx,%eax
 918:	75 12                	jne    92c <parsecmd+0x54>
  nulterminate(cmd);
 91a:	83 ec 0c             	sub    $0xc,%esp
 91d:	56                   	push   %esi
 91e:	e8 1d ff ff ff       	call   840 <nulterminate>
}
 923:	89 f0                	mov    %esi,%eax
 925:	8d 65 f8             	lea    -0x8(%ebp),%esp
 928:	5b                   	pop    %ebx
 929:	5e                   	pop    %esi
 92a:	5d                   	pop    %ebp
 92b:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 92c:	83 ec 04             	sub    $0x4,%esp
 92f:	50                   	push   %eax
 930:	68 72 10 00 00       	push   $0x1072
 935:	6a 02                	push   $0x2
 937:	e8 fb 03 00 00       	call   d37 <printf>
    panic("syntax");
 93c:	c7 04 24 36 10 00 00 	movl   $0x1036,(%esp)
 943:	e8 07 f7 ff ff       	call   4f <panic>

00000948 <main>:
{
 948:	f3 0f 1e fb          	endbr32 
 94c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 950:	83 e4 f0             	and    $0xfffffff0,%esp
 953:	ff 71 fc             	pushl  -0x4(%ecx)
 956:	55                   	push   %ebp
 957:	89 e5                	mov    %esp,%ebp
 959:	51                   	push   %ecx
 95a:	83 ec 14             	sub    $0x14,%esp
  while((fd = open("console", O_RDWR)) >= 0){
 95d:	83 ec 08             	sub    $0x8,%esp
 960:	6a 02                	push   $0x2
 962:	68 81 10 00 00       	push   $0x1081
 967:	e8 bc 02 00 00       	call   c28 <open>
 96c:	83 c4 10             	add    $0x10,%esp
 96f:	85 c0                	test   %eax,%eax
 971:	78 41                	js     9b4 <main+0x6c>
    if(fd >= 3){
 973:	83 f8 02             	cmp    $0x2,%eax
 976:	7e e5                	jle    95d <main+0x15>
      close(fd);
 978:	83 ec 0c             	sub    $0xc,%esp
 97b:	50                   	push   %eax
 97c:	e8 8f 02 00 00       	call   c10 <close>
      break;
 981:	83 c4 10             	add    $0x10,%esp
 984:	eb 2e                	jmp    9b4 <main+0x6c>
    if(fork1() == 0)
 986:	e8 e9 f6 ff ff       	call   74 <fork1>
 98b:	85 c0                	test   %eax,%eax
 98d:	0f 84 92 00 00 00    	je     a25 <main+0xdd>
    wait(&status);
 993:	83 ec 0c             	sub    $0xc,%esp
 996:	8d 45 f4             	lea    -0xc(%ebp),%eax
 999:	50                   	push   %eax
 99a:	e8 51 02 00 00       	call   bf0 <wait>
    printf(1, "Output code: %d\n", status);
 99f:	83 c4 0c             	add    $0xc,%esp
 9a2:	ff 75 f4             	pushl  -0xc(%ebp)
 9a5:	68 97 10 00 00       	push   $0x1097
 9aa:	6a 01                	push   $0x1
 9ac:	e8 86 03 00 00       	call   d37 <printf>
 9b1:	83 c4 10             	add    $0x10,%esp
  while(getcmd(buf, sizeof(buf)) >= 0){
 9b4:	83 ec 08             	sub    $0x8,%esp
 9b7:	6a 64                	push   $0x64
 9b9:	68 80 16 00 00       	push   $0x1680
 9be:	e8 3d f6 ff ff       	call   0 <getcmd>
 9c3:	83 c4 10             	add    $0x10,%esp
 9c6:	85 c0                	test   %eax,%eax
 9c8:	78 70                	js     a3a <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 9ca:	80 3d 80 16 00 00 63 	cmpb   $0x63,0x1680
 9d1:	75 b3                	jne    986 <main+0x3e>
 9d3:	80 3d 81 16 00 00 64 	cmpb   $0x64,0x1681
 9da:	75 aa                	jne    986 <main+0x3e>
 9dc:	80 3d 82 16 00 00 20 	cmpb   $0x20,0x1682
 9e3:	75 a1                	jne    986 <main+0x3e>
      buf[strlen(buf)-1] = 0;  // chop \n
 9e5:	83 ec 0c             	sub    $0xc,%esp
 9e8:	68 80 16 00 00       	push   $0x1680
 9ed:	e8 9f 00 00 00       	call   a91 <strlen>
 9f2:	c6 80 7f 16 00 00 00 	movb   $0x0,0x167f(%eax)
      if(chdir(buf+3) < 0)
 9f9:	c7 04 24 83 16 00 00 	movl   $0x1683,(%esp)
 a00:	e8 53 02 00 00       	call   c58 <chdir>
 a05:	83 c4 10             	add    $0x10,%esp
 a08:	85 c0                	test   %eax,%eax
 a0a:	79 a8                	jns    9b4 <main+0x6c>
        printf(2, "cannot cd %s\n", buf+3);
 a0c:	83 ec 04             	sub    $0x4,%esp
 a0f:	68 83 16 00 00       	push   $0x1683
 a14:	68 89 10 00 00       	push   $0x1089
 a19:	6a 02                	push   $0x2
 a1b:	e8 17 03 00 00       	call   d37 <printf>
 a20:	83 c4 10             	add    $0x10,%esp
      continue;
 a23:	eb 8f                	jmp    9b4 <main+0x6c>
      runcmd(parsecmd(buf));
 a25:	83 ec 0c             	sub    $0xc,%esp
 a28:	68 80 16 00 00       	push   $0x1680
 a2d:	e8 a6 fe ff ff       	call   8d8 <parsecmd>
 a32:	89 04 24             	mov    %eax,(%esp)
 a35:	e8 5d f6 ff ff       	call   97 <runcmd>
  exit(0);
 a3a:	83 ec 0c             	sub    $0xc,%esp
 a3d:	6a 00                	push   $0x0
 a3f:	e8 a4 01 00 00       	call   be8 <exit>

00000a44 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 a44:	f3 0f 1e fb          	endbr32 
}
 a48:	c3                   	ret    

00000a49 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 a49:	f3 0f 1e fb          	endbr32 
 a4d:	55                   	push   %ebp
 a4e:	89 e5                	mov    %esp,%ebp
 a50:	56                   	push   %esi
 a51:	53                   	push   %ebx
 a52:	8b 45 08             	mov    0x8(%ebp),%eax
 a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 a58:	89 c2                	mov    %eax,%edx
 a5a:	89 cb                	mov    %ecx,%ebx
 a5c:	41                   	inc    %ecx
 a5d:	89 d6                	mov    %edx,%esi
 a5f:	42                   	inc    %edx
 a60:	8a 1b                	mov    (%ebx),%bl
 a62:	88 1e                	mov    %bl,(%esi)
 a64:	84 db                	test   %bl,%bl
 a66:	75 f2                	jne    a5a <strcpy+0x11>
    ;
  return os;
}
 a68:	5b                   	pop    %ebx
 a69:	5e                   	pop    %esi
 a6a:	5d                   	pop    %ebp
 a6b:	c3                   	ret    

00000a6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 a6c:	f3 0f 1e fb          	endbr32 
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 a79:	8a 01                	mov    (%ecx),%al
 a7b:	84 c0                	test   %al,%al
 a7d:	74 08                	je     a87 <strcmp+0x1b>
 a7f:	3a 02                	cmp    (%edx),%al
 a81:	75 04                	jne    a87 <strcmp+0x1b>
    p++, q++;
 a83:	41                   	inc    %ecx
 a84:	42                   	inc    %edx
 a85:	eb f2                	jmp    a79 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 a87:	0f b6 c0             	movzbl %al,%eax
 a8a:	0f b6 12             	movzbl (%edx),%edx
 a8d:	29 d0                	sub    %edx,%eax
}
 a8f:	5d                   	pop    %ebp
 a90:	c3                   	ret    

00000a91 <strlen>:

uint
strlen(const char *s)
{
 a91:	f3 0f 1e fb          	endbr32 
 a95:	55                   	push   %ebp
 a96:	89 e5                	mov    %esp,%ebp
 a98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 a9b:	b8 00 00 00 00       	mov    $0x0,%eax
 aa0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 aa4:	74 03                	je     aa9 <strlen+0x18>
 aa6:	40                   	inc    %eax
 aa7:	eb f7                	jmp    aa0 <strlen+0xf>
    ;
  return n;
}
 aa9:	5d                   	pop    %ebp
 aaa:	c3                   	ret    

00000aab <memset>:

void*
memset(void *dst, int c, uint n)
{
 aab:	f3 0f 1e fb          	endbr32 
 aaf:	55                   	push   %ebp
 ab0:	89 e5                	mov    %esp,%ebp
 ab2:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 ab3:	8b 7d 08             	mov    0x8(%ebp),%edi
 ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
 abc:	fc                   	cld    
 abd:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 abf:	8b 45 08             	mov    0x8(%ebp),%eax
 ac2:	5f                   	pop    %edi
 ac3:	5d                   	pop    %ebp
 ac4:	c3                   	ret    

00000ac5 <strchr>:

char*
strchr(const char *s, char c)
{
 ac5:	f3 0f 1e fb          	endbr32 
 ac9:	55                   	push   %ebp
 aca:	89 e5                	mov    %esp,%ebp
 acc:	8b 45 08             	mov    0x8(%ebp),%eax
 acf:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 ad2:	8a 10                	mov    (%eax),%dl
 ad4:	84 d2                	test   %dl,%dl
 ad6:	74 07                	je     adf <strchr+0x1a>
    if(*s == c)
 ad8:	38 ca                	cmp    %cl,%dl
 ada:	74 08                	je     ae4 <strchr+0x1f>
  for(; *s; s++)
 adc:	40                   	inc    %eax
 add:	eb f3                	jmp    ad2 <strchr+0xd>
      return (char*)s;
  return 0;
 adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 ae4:	5d                   	pop    %ebp
 ae5:	c3                   	ret    

00000ae6 <gets>:

char*
gets(char *buf, int max)
{
 ae6:	f3 0f 1e fb          	endbr32 
 aea:	55                   	push   %ebp
 aeb:	89 e5                	mov    %esp,%ebp
 aed:	57                   	push   %edi
 aee:	56                   	push   %esi
 aef:	53                   	push   %ebx
 af0:	83 ec 1c             	sub    $0x1c,%esp
 af3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 af6:	bb 00 00 00 00       	mov    $0x0,%ebx
 afb:	89 de                	mov    %ebx,%esi
 afd:	43                   	inc    %ebx
 afe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 b01:	7d 2b                	jge    b2e <gets+0x48>
    cc = read(0, &c, 1);
 b03:	83 ec 04             	sub    $0x4,%esp
 b06:	6a 01                	push   $0x1
 b08:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b0b:	50                   	push   %eax
 b0c:	6a 00                	push   $0x0
 b0e:	e8 ed 00 00 00       	call   c00 <read>
    if(cc < 1)
 b13:	83 c4 10             	add    $0x10,%esp
 b16:	85 c0                	test   %eax,%eax
 b18:	7e 14                	jle    b2e <gets+0x48>
      break;
    buf[i++] = c;
 b1a:	8a 45 e7             	mov    -0x19(%ebp),%al
 b1d:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 b20:	3c 0a                	cmp    $0xa,%al
 b22:	74 08                	je     b2c <gets+0x46>
 b24:	3c 0d                	cmp    $0xd,%al
 b26:	75 d3                	jne    afb <gets+0x15>
    buf[i++] = c;
 b28:	89 de                	mov    %ebx,%esi
 b2a:	eb 02                	jmp    b2e <gets+0x48>
 b2c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 b2e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 b32:	89 f8                	mov    %edi,%eax
 b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b37:	5b                   	pop    %ebx
 b38:	5e                   	pop    %esi
 b39:	5f                   	pop    %edi
 b3a:	5d                   	pop    %ebp
 b3b:	c3                   	ret    

00000b3c <stat>:

int
stat(const char *n, struct stat *st)
{
 b3c:	f3 0f 1e fb          	endbr32 
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	56                   	push   %esi
 b44:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 b45:	83 ec 08             	sub    $0x8,%esp
 b48:	6a 00                	push   $0x0
 b4a:	ff 75 08             	pushl  0x8(%ebp)
 b4d:	e8 d6 00 00 00       	call   c28 <open>
  if(fd < 0)
 b52:	83 c4 10             	add    $0x10,%esp
 b55:	85 c0                	test   %eax,%eax
 b57:	78 24                	js     b7d <stat+0x41>
 b59:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 b5b:	83 ec 08             	sub    $0x8,%esp
 b5e:	ff 75 0c             	pushl  0xc(%ebp)
 b61:	50                   	push   %eax
 b62:	e8 d9 00 00 00       	call   c40 <fstat>
 b67:	89 c6                	mov    %eax,%esi
  close(fd);
 b69:	89 1c 24             	mov    %ebx,(%esp)
 b6c:	e8 9f 00 00 00       	call   c10 <close>
  return r;
 b71:	83 c4 10             	add    $0x10,%esp
}
 b74:	89 f0                	mov    %esi,%eax
 b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
 b79:	5b                   	pop    %ebx
 b7a:	5e                   	pop    %esi
 b7b:	5d                   	pop    %ebp
 b7c:	c3                   	ret    
    return -1;
 b7d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 b82:	eb f0                	jmp    b74 <stat+0x38>

00000b84 <atoi>:

int
atoi(const char *s)
{
 b84:	f3 0f 1e fb          	endbr32 
 b88:	55                   	push   %ebp
 b89:	89 e5                	mov    %esp,%ebp
 b8b:	53                   	push   %ebx
 b8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 b8f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 b94:	8a 01                	mov    (%ecx),%al
 b96:	8d 58 d0             	lea    -0x30(%eax),%ebx
 b99:	80 fb 09             	cmp    $0x9,%bl
 b9c:	77 10                	ja     bae <atoi+0x2a>
    n = n*10 + *s++ - '0';
 b9e:	8d 14 92             	lea    (%edx,%edx,4),%edx
 ba1:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 ba4:	41                   	inc    %ecx
 ba5:	0f be c0             	movsbl %al,%eax
 ba8:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 bac:	eb e6                	jmp    b94 <atoi+0x10>
  return n;
}
 bae:	89 d0                	mov    %edx,%eax
 bb0:	5b                   	pop    %ebx
 bb1:	5d                   	pop    %ebp
 bb2:	c3                   	ret    

00000bb3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 bb3:	f3 0f 1e fb          	endbr32 
 bb7:	55                   	push   %ebp
 bb8:	89 e5                	mov    %esp,%ebp
 bba:	56                   	push   %esi
 bbb:	53                   	push   %ebx
 bbc:	8b 45 08             	mov    0x8(%ebp),%eax
 bbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 bc2:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 bc5:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 bc7:	8d 72 ff             	lea    -0x1(%edx),%esi
 bca:	85 d2                	test   %edx,%edx
 bcc:	7e 0e                	jle    bdc <memmove+0x29>
    *dst++ = *src++;
 bce:	8a 13                	mov    (%ebx),%dl
 bd0:	88 11                	mov    %dl,(%ecx)
 bd2:	8d 5b 01             	lea    0x1(%ebx),%ebx
 bd5:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 bd8:	89 f2                	mov    %esi,%edx
 bda:	eb eb                	jmp    bc7 <memmove+0x14>
  return vdst;
}
 bdc:	5b                   	pop    %ebx
 bdd:	5e                   	pop    %esi
 bde:	5d                   	pop    %ebp
 bdf:	c3                   	ret    

00000be0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 be0:	b8 01 00 00 00       	mov    $0x1,%eax
 be5:	cd 40                	int    $0x40
 be7:	c3                   	ret    

00000be8 <exit>:
SYSCALL(exit)
 be8:	b8 02 00 00 00       	mov    $0x2,%eax
 bed:	cd 40                	int    $0x40
 bef:	c3                   	ret    

00000bf0 <wait>:
SYSCALL(wait)
 bf0:	b8 03 00 00 00       	mov    $0x3,%eax
 bf5:	cd 40                	int    $0x40
 bf7:	c3                   	ret    

00000bf8 <pipe>:
SYSCALL(pipe)
 bf8:	b8 04 00 00 00       	mov    $0x4,%eax
 bfd:	cd 40                	int    $0x40
 bff:	c3                   	ret    

00000c00 <read>:
SYSCALL(read)
 c00:	b8 05 00 00 00       	mov    $0x5,%eax
 c05:	cd 40                	int    $0x40
 c07:	c3                   	ret    

00000c08 <write>:
SYSCALL(write)
 c08:	b8 10 00 00 00       	mov    $0x10,%eax
 c0d:	cd 40                	int    $0x40
 c0f:	c3                   	ret    

00000c10 <close>:
SYSCALL(close)
 c10:	b8 15 00 00 00       	mov    $0x15,%eax
 c15:	cd 40                	int    $0x40
 c17:	c3                   	ret    

00000c18 <kill>:
SYSCALL(kill)
 c18:	b8 06 00 00 00       	mov    $0x6,%eax
 c1d:	cd 40                	int    $0x40
 c1f:	c3                   	ret    

00000c20 <exec>:
SYSCALL(exec)
 c20:	b8 07 00 00 00       	mov    $0x7,%eax
 c25:	cd 40                	int    $0x40
 c27:	c3                   	ret    

00000c28 <open>:
SYSCALL(open)
 c28:	b8 0f 00 00 00       	mov    $0xf,%eax
 c2d:	cd 40                	int    $0x40
 c2f:	c3                   	ret    

00000c30 <mknod>:
SYSCALL(mknod)
 c30:	b8 11 00 00 00       	mov    $0x11,%eax
 c35:	cd 40                	int    $0x40
 c37:	c3                   	ret    

00000c38 <unlink>:
SYSCALL(unlink)
 c38:	b8 12 00 00 00       	mov    $0x12,%eax
 c3d:	cd 40                	int    $0x40
 c3f:	c3                   	ret    

00000c40 <fstat>:
SYSCALL(fstat)
 c40:	b8 08 00 00 00       	mov    $0x8,%eax
 c45:	cd 40                	int    $0x40
 c47:	c3                   	ret    

00000c48 <link>:
SYSCALL(link)
 c48:	b8 13 00 00 00       	mov    $0x13,%eax
 c4d:	cd 40                	int    $0x40
 c4f:	c3                   	ret    

00000c50 <mkdir>:
SYSCALL(mkdir)
 c50:	b8 14 00 00 00       	mov    $0x14,%eax
 c55:	cd 40                	int    $0x40
 c57:	c3                   	ret    

00000c58 <chdir>:
SYSCALL(chdir)
 c58:	b8 09 00 00 00       	mov    $0x9,%eax
 c5d:	cd 40                	int    $0x40
 c5f:	c3                   	ret    

00000c60 <dup>:
SYSCALL(dup)
 c60:	b8 0a 00 00 00       	mov    $0xa,%eax
 c65:	cd 40                	int    $0x40
 c67:	c3                   	ret    

00000c68 <dup2>:
SYSCALL(dup2)
 c68:	b8 17 00 00 00       	mov    $0x17,%eax
 c6d:	cd 40                	int    $0x40
 c6f:	c3                   	ret    

00000c70 <getpid>:
SYSCALL(getpid)
 c70:	b8 0b 00 00 00       	mov    $0xb,%eax
 c75:	cd 40                	int    $0x40
 c77:	c3                   	ret    

00000c78 <sbrk>:
SYSCALL(sbrk)
 c78:	b8 0c 00 00 00       	mov    $0xc,%eax
 c7d:	cd 40                	int    $0x40
 c7f:	c3                   	ret    

00000c80 <sleep>:
SYSCALL(sleep)
 c80:	b8 0d 00 00 00       	mov    $0xd,%eax
 c85:	cd 40                	int    $0x40
 c87:	c3                   	ret    

00000c88 <uptime>:
SYSCALL(uptime)
 c88:	b8 0e 00 00 00       	mov    $0xe,%eax
 c8d:	cd 40                	int    $0x40
 c8f:	c3                   	ret    

00000c90 <date>:
SYSCALL(date)
 c90:	b8 16 00 00 00       	mov    $0x16,%eax
 c95:	cd 40                	int    $0x40
 c97:	c3                   	ret    

00000c98 <getprio>:
SYSCALL(getprio)
 c98:	b8 18 00 00 00       	mov    $0x18,%eax
 c9d:	cd 40                	int    $0x40
 c9f:	c3                   	ret    

00000ca0 <setprio>:
SYSCALL(setprio)
 ca0:	b8 19 00 00 00       	mov    $0x19,%eax
 ca5:	cd 40                	int    $0x40
 ca7:	c3                   	ret    

00000ca8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 ca8:	55                   	push   %ebp
 ca9:	89 e5                	mov    %esp,%ebp
 cab:	83 ec 1c             	sub    $0x1c,%esp
 cae:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 cb1:	6a 01                	push   $0x1
 cb3:	8d 55 f4             	lea    -0xc(%ebp),%edx
 cb6:	52                   	push   %edx
 cb7:	50                   	push   %eax
 cb8:	e8 4b ff ff ff       	call   c08 <write>
}
 cbd:	83 c4 10             	add    $0x10,%esp
 cc0:	c9                   	leave  
 cc1:	c3                   	ret    

00000cc2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 cc2:	55                   	push   %ebp
 cc3:	89 e5                	mov    %esp,%ebp
 cc5:	57                   	push   %edi
 cc6:	56                   	push   %esi
 cc7:	53                   	push   %ebx
 cc8:	83 ec 2c             	sub    $0x2c,%esp
 ccb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 cce:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 cd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cd4:	74 04                	je     cda <printint+0x18>
 cd6:	85 d2                	test   %edx,%edx
 cd8:	78 3a                	js     d14 <printint+0x52>
  neg = 0;
 cda:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 ce1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 ce6:	89 f0                	mov    %esi,%eax
 ce8:	ba 00 00 00 00       	mov    $0x0,%edx
 ced:	f7 f1                	div    %ecx
 cef:	89 df                	mov    %ebx,%edi
 cf1:	43                   	inc    %ebx
 cf2:	8a 92 e0 10 00 00    	mov    0x10e0(%edx),%dl
 cf8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 cfc:	89 f2                	mov    %esi,%edx
 cfe:	89 c6                	mov    %eax,%esi
 d00:	39 d1                	cmp    %edx,%ecx
 d02:	76 e2                	jbe    ce6 <printint+0x24>
  if(neg)
 d04:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 d08:	74 22                	je     d2c <printint+0x6a>
    buf[i++] = '-';
 d0a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 d0f:	8d 5f 02             	lea    0x2(%edi),%ebx
 d12:	eb 18                	jmp    d2c <printint+0x6a>
    x = -xx;
 d14:	f7 de                	neg    %esi
    neg = 1;
 d16:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 d1d:	eb c2                	jmp    ce1 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 d1f:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 d24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 d27:	e8 7c ff ff ff       	call   ca8 <putc>
  while(--i >= 0)
 d2c:	4b                   	dec    %ebx
 d2d:	79 f0                	jns    d1f <printint+0x5d>
}
 d2f:	83 c4 2c             	add    $0x2c,%esp
 d32:	5b                   	pop    %ebx
 d33:	5e                   	pop    %esi
 d34:	5f                   	pop    %edi
 d35:	5d                   	pop    %ebp
 d36:	c3                   	ret    

00000d37 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 d37:	f3 0f 1e fb          	endbr32 
 d3b:	55                   	push   %ebp
 d3c:	89 e5                	mov    %esp,%ebp
 d3e:	57                   	push   %edi
 d3f:	56                   	push   %esi
 d40:	53                   	push   %ebx
 d41:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 d44:	8d 45 10             	lea    0x10(%ebp),%eax
 d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 d4a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 d4f:	bb 00 00 00 00       	mov    $0x0,%ebx
 d54:	eb 12                	jmp    d68 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 d56:	89 fa                	mov    %edi,%edx
 d58:	8b 45 08             	mov    0x8(%ebp),%eax
 d5b:	e8 48 ff ff ff       	call   ca8 <putc>
 d60:	eb 05                	jmp    d67 <printf+0x30>
      }
    } else if(state == '%'){
 d62:	83 fe 25             	cmp    $0x25,%esi
 d65:	74 22                	je     d89 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 d67:	43                   	inc    %ebx
 d68:	8b 45 0c             	mov    0xc(%ebp),%eax
 d6b:	8a 04 18             	mov    (%eax,%ebx,1),%al
 d6e:	84 c0                	test   %al,%al
 d70:	0f 84 13 01 00 00    	je     e89 <printf+0x152>
    c = fmt[i] & 0xff;
 d76:	0f be f8             	movsbl %al,%edi
 d79:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 d7c:	85 f6                	test   %esi,%esi
 d7e:	75 e2                	jne    d62 <printf+0x2b>
      if(c == '%'){
 d80:	83 f8 25             	cmp    $0x25,%eax
 d83:	75 d1                	jne    d56 <printf+0x1f>
        state = '%';
 d85:	89 c6                	mov    %eax,%esi
 d87:	eb de                	jmp    d67 <printf+0x30>
      if(c == 'd'){
 d89:	83 f8 64             	cmp    $0x64,%eax
 d8c:	74 43                	je     dd1 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 d8e:	83 f8 78             	cmp    $0x78,%eax
 d91:	74 68                	je     dfb <printf+0xc4>
 d93:	83 f8 70             	cmp    $0x70,%eax
 d96:	74 63                	je     dfb <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 d98:	83 f8 73             	cmp    $0x73,%eax
 d9b:	0f 84 84 00 00 00    	je     e25 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 da1:	83 f8 63             	cmp    $0x63,%eax
 da4:	0f 84 ad 00 00 00    	je     e57 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 daa:	83 f8 25             	cmp    $0x25,%eax
 dad:	0f 84 c2 00 00 00    	je     e75 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 db3:	ba 25 00 00 00       	mov    $0x25,%edx
 db8:	8b 45 08             	mov    0x8(%ebp),%eax
 dbb:	e8 e8 fe ff ff       	call   ca8 <putc>
        putc(fd, c);
 dc0:	89 fa                	mov    %edi,%edx
 dc2:	8b 45 08             	mov    0x8(%ebp),%eax
 dc5:	e8 de fe ff ff       	call   ca8 <putc>
      }
      state = 0;
 dca:	be 00 00 00 00       	mov    $0x0,%esi
 dcf:	eb 96                	jmp    d67 <printf+0x30>
        printint(fd, *ap, 10, 1);
 dd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 dd4:	8b 17                	mov    (%edi),%edx
 dd6:	83 ec 0c             	sub    $0xc,%esp
 dd9:	6a 01                	push   $0x1
 ddb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 de0:	8b 45 08             	mov    0x8(%ebp),%eax
 de3:	e8 da fe ff ff       	call   cc2 <printint>
        ap++;
 de8:	83 c7 04             	add    $0x4,%edi
 deb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 dee:	83 c4 10             	add    $0x10,%esp
      state = 0;
 df1:	be 00 00 00 00       	mov    $0x0,%esi
 df6:	e9 6c ff ff ff       	jmp    d67 <printf+0x30>
        printint(fd, *ap, 16, 0);
 dfb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 dfe:	8b 17                	mov    (%edi),%edx
 e00:	83 ec 0c             	sub    $0xc,%esp
 e03:	6a 00                	push   $0x0
 e05:	b9 10 00 00 00       	mov    $0x10,%ecx
 e0a:	8b 45 08             	mov    0x8(%ebp),%eax
 e0d:	e8 b0 fe ff ff       	call   cc2 <printint>
        ap++;
 e12:	83 c7 04             	add    $0x4,%edi
 e15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 e18:	83 c4 10             	add    $0x10,%esp
      state = 0;
 e1b:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 e20:	e9 42 ff ff ff       	jmp    d67 <printf+0x30>
        s = (char*)*ap;
 e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 e28:	8b 30                	mov    (%eax),%esi
        ap++;
 e2a:	83 c0 04             	add    $0x4,%eax
 e2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 e30:	85 f6                	test   %esi,%esi
 e32:	75 13                	jne    e47 <printf+0x110>
          s = "(null)";
 e34:	be d8 10 00 00       	mov    $0x10d8,%esi
 e39:	eb 0c                	jmp    e47 <printf+0x110>
          putc(fd, *s);
 e3b:	0f be d2             	movsbl %dl,%edx
 e3e:	8b 45 08             	mov    0x8(%ebp),%eax
 e41:	e8 62 fe ff ff       	call   ca8 <putc>
          s++;
 e46:	46                   	inc    %esi
        while(*s != 0){
 e47:	8a 16                	mov    (%esi),%dl
 e49:	84 d2                	test   %dl,%dl
 e4b:	75 ee                	jne    e3b <printf+0x104>
      state = 0;
 e4d:	be 00 00 00 00       	mov    $0x0,%esi
 e52:	e9 10 ff ff ff       	jmp    d67 <printf+0x30>
        putc(fd, *ap);
 e57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 e5a:	0f be 17             	movsbl (%edi),%edx
 e5d:	8b 45 08             	mov    0x8(%ebp),%eax
 e60:	e8 43 fe ff ff       	call   ca8 <putc>
        ap++;
 e65:	83 c7 04             	add    $0x4,%edi
 e68:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 e6b:	be 00 00 00 00       	mov    $0x0,%esi
 e70:	e9 f2 fe ff ff       	jmp    d67 <printf+0x30>
        putc(fd, c);
 e75:	89 fa                	mov    %edi,%edx
 e77:	8b 45 08             	mov    0x8(%ebp),%eax
 e7a:	e8 29 fe ff ff       	call   ca8 <putc>
      state = 0;
 e7f:	be 00 00 00 00       	mov    $0x0,%esi
 e84:	e9 de fe ff ff       	jmp    d67 <printf+0x30>
    }
  }
}
 e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
 e8c:	5b                   	pop    %ebx
 e8d:	5e                   	pop    %esi
 e8e:	5f                   	pop    %edi
 e8f:	5d                   	pop    %ebp
 e90:	c3                   	ret    

00000e91 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e91:	f3 0f 1e fb          	endbr32 
 e95:	55                   	push   %ebp
 e96:	89 e5                	mov    %esp,%ebp
 e98:	57                   	push   %edi
 e99:	56                   	push   %esi
 e9a:	53                   	push   %ebx
 e9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e9e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ea1:	a1 e4 16 00 00       	mov    0x16e4,%eax
 ea6:	eb 02                	jmp    eaa <free+0x19>
 ea8:	89 d0                	mov    %edx,%eax
 eaa:	39 c8                	cmp    %ecx,%eax
 eac:	73 04                	jae    eb2 <free+0x21>
 eae:	39 08                	cmp    %ecx,(%eax)
 eb0:	77 12                	ja     ec4 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 eb2:	8b 10                	mov    (%eax),%edx
 eb4:	39 c2                	cmp    %eax,%edx
 eb6:	77 f0                	ja     ea8 <free+0x17>
 eb8:	39 c8                	cmp    %ecx,%eax
 eba:	72 08                	jb     ec4 <free+0x33>
 ebc:	39 ca                	cmp    %ecx,%edx
 ebe:	77 04                	ja     ec4 <free+0x33>
 ec0:	89 d0                	mov    %edx,%eax
 ec2:	eb e6                	jmp    eaa <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ec4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 ec7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 eca:	8b 10                	mov    (%eax),%edx
 ecc:	39 d7                	cmp    %edx,%edi
 ece:	74 19                	je     ee9 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ed0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ed3:	8b 50 04             	mov    0x4(%eax),%edx
 ed6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ed9:	39 ce                	cmp    %ecx,%esi
 edb:	74 1b                	je     ef8 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 edd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 edf:	a3 e4 16 00 00       	mov    %eax,0x16e4
}
 ee4:	5b                   	pop    %ebx
 ee5:	5e                   	pop    %esi
 ee6:	5f                   	pop    %edi
 ee7:	5d                   	pop    %ebp
 ee8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 ee9:	03 72 04             	add    0x4(%edx),%esi
 eec:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 eef:	8b 10                	mov    (%eax),%edx
 ef1:	8b 12                	mov    (%edx),%edx
 ef3:	89 53 f8             	mov    %edx,-0x8(%ebx)
 ef6:	eb db                	jmp    ed3 <free+0x42>
    p->s.size += bp->s.size;
 ef8:	03 53 fc             	add    -0x4(%ebx),%edx
 efb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 efe:	8b 53 f8             	mov    -0x8(%ebx),%edx
 f01:	89 10                	mov    %edx,(%eax)
 f03:	eb da                	jmp    edf <free+0x4e>

00000f05 <morecore>:

static Header*
morecore(uint nu)
{
 f05:	55                   	push   %ebp
 f06:	89 e5                	mov    %esp,%ebp
 f08:	53                   	push   %ebx
 f09:	83 ec 04             	sub    $0x4,%esp
 f0c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 f0e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 f13:	77 05                	ja     f1a <morecore+0x15>
    nu = 4096;
 f15:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 f1a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 f21:	83 ec 0c             	sub    $0xc,%esp
 f24:	50                   	push   %eax
 f25:	e8 4e fd ff ff       	call   c78 <sbrk>
  if(p == (char*)-1)
 f2a:	83 c4 10             	add    $0x10,%esp
 f2d:	83 f8 ff             	cmp    $0xffffffff,%eax
 f30:	74 1c                	je     f4e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 f32:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 f35:	83 c0 08             	add    $0x8,%eax
 f38:	83 ec 0c             	sub    $0xc,%esp
 f3b:	50                   	push   %eax
 f3c:	e8 50 ff ff ff       	call   e91 <free>
  return freep;
 f41:	a1 e4 16 00 00       	mov    0x16e4,%eax
 f46:	83 c4 10             	add    $0x10,%esp
}
 f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 f4c:	c9                   	leave  
 f4d:	c3                   	ret    
    return 0;
 f4e:	b8 00 00 00 00       	mov    $0x0,%eax
 f53:	eb f4                	jmp    f49 <morecore+0x44>

00000f55 <malloc>:

void*
malloc(uint nbytes)
{
 f55:	f3 0f 1e fb          	endbr32 
 f59:	55                   	push   %ebp
 f5a:	89 e5                	mov    %esp,%ebp
 f5c:	53                   	push   %ebx
 f5d:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 f60:	8b 45 08             	mov    0x8(%ebp),%eax
 f63:	8d 58 07             	lea    0x7(%eax),%ebx
 f66:	c1 eb 03             	shr    $0x3,%ebx
 f69:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 f6a:	8b 0d e4 16 00 00    	mov    0x16e4,%ecx
 f70:	85 c9                	test   %ecx,%ecx
 f72:	74 04                	je     f78 <malloc+0x23>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f74:	8b 01                	mov    (%ecx),%eax
 f76:	eb 4b                	jmp    fc3 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 f78:	c7 05 e4 16 00 00 e8 	movl   $0x16e8,0x16e4
 f7f:	16 00 00 
 f82:	c7 05 e8 16 00 00 e8 	movl   $0x16e8,0x16e8
 f89:	16 00 00 
    base.s.size = 0;
 f8c:	c7 05 ec 16 00 00 00 	movl   $0x0,0x16ec
 f93:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 f96:	b9 e8 16 00 00       	mov    $0x16e8,%ecx
 f9b:	eb d7                	jmp    f74 <malloc+0x1f>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 f9d:	74 1a                	je     fb9 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f9f:	29 da                	sub    %ebx,%edx
 fa1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 fa4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 fa7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 faa:	89 0d e4 16 00 00    	mov    %ecx,0x16e4
      return (void*)(p + 1);
 fb0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 fb3:	83 c4 04             	add    $0x4,%esp
 fb6:	5b                   	pop    %ebx
 fb7:	5d                   	pop    %ebp
 fb8:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 fb9:	8b 10                	mov    (%eax),%edx
 fbb:	89 11                	mov    %edx,(%ecx)
 fbd:	eb eb                	jmp    faa <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 fbf:	89 c1                	mov    %eax,%ecx
 fc1:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 fc3:	8b 50 04             	mov    0x4(%eax),%edx
 fc6:	39 da                	cmp    %ebx,%edx
 fc8:	73 d3                	jae    f9d <malloc+0x48>
    if(p == freep)
 fca:	39 05 e4 16 00 00    	cmp    %eax,0x16e4
 fd0:	75 ed                	jne    fbf <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 fd2:	89 d8                	mov    %ebx,%eax
 fd4:	e8 2c ff ff ff       	call   f05 <morecore>
 fd9:	85 c0                	test   %eax,%eax
 fdb:	75 e2                	jne    fbf <malloc+0x6a>
 fdd:	eb d4                	jmp    fb3 <malloc+0x5e>
