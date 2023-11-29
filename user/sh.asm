
sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
   8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
   b:	83 ec 08             	sub    $0x8,%esp
   e:	68 60 0f 00 00       	push   $0xf60
  13:	6a 02                	push   $0x2
  15:	e8 9f 0c 00 00       	call   cb9 <printf>
  memset(buf, 0, nbuf);
  1a:	83 c4 0c             	add    $0xc,%esp
  1d:	56                   	push   %esi
  1e:	6a 00                	push   $0x0
  20:	53                   	push   %ebx
  21:	e8 15 0a 00 00       	call   a3b <memset>
  gets(buf, nbuf);
  26:	83 c4 08             	add    $0x8,%esp
  29:	56                   	push   %esi
  2a:	53                   	push   %ebx
  2b:	e8 42 0a 00 00       	call   a72 <gets>
  if(buf[0] == 0) // EOF
  30:	83 c4 10             	add    $0x10,%esp
  33:	80 3b 00             	cmpb   $0x0,(%ebx)
  36:	74 0c                	je     44 <getcmd+0x44>
    return -1;
  return 0;
  38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  40:	5b                   	pop    %ebx
  41:	5e                   	pop    %esi
  42:	5d                   	pop    %ebp
  43:	c3                   	ret    
    return -1;
  44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  49:	eb f2                	jmp    3d <getcmd+0x3d>

0000004b <panic>:
  exit(0);
}

void
panic(char *s)
{
  4b:	55                   	push   %ebp
  4c:	89 e5                	mov    %esp,%ebp
  4e:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
  51:	ff 75 08             	push   0x8(%ebp)
  54:	68 fd 0f 00 00       	push   $0xffd
  59:	6a 02                	push   $0x2
  5b:	e8 59 0c 00 00       	call   cb9 <printf>
  exit(0);
  60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  67:	e8 fa 0a 00 00       	call   b66 <exit>

0000006c <fork1>:
}

int
fork1(void)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
  72:	e8 e7 0a 00 00       	call   b5e <fork>
  if(pid == -1)
  77:	83 f8 ff             	cmp    $0xffffffff,%eax
  7a:	74 02                	je     7e <fork1+0x12>
    panic("fork");
  return pid;
}
  7c:	c9                   	leave  
  7d:	c3                   	ret    
    panic("fork");
  7e:	83 ec 0c             	sub    $0xc,%esp
  81:	68 63 0f 00 00       	push   $0xf63
  86:	e8 c0 ff ff ff       	call   4b <panic>

0000008b <runcmd>:
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	53                   	push   %ebx
  8f:	83 ec 14             	sub    $0x14,%esp
  92:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
  95:	85 db                	test   %ebx,%ebx
  97:	74 0e                	je     a7 <runcmd+0x1c>
  switch(cmd->type){
  99:	8b 03                	mov    (%ebx),%eax
  9b:	83 f8 05             	cmp    $0x5,%eax
  9e:	77 11                	ja     b1 <runcmd+0x26>
  a0:	ff 24 85 28 10 00 00 	jmp    *0x1028(,%eax,4)
    exit(0);
  a7:	83 ec 0c             	sub    $0xc,%esp
  aa:	6a 00                	push   $0x0
  ac:	e8 b5 0a 00 00       	call   b66 <exit>
    panic("runcmd");
  b1:	83 ec 0c             	sub    $0xc,%esp
  b4:	68 68 0f 00 00       	push   $0xf68
  b9:	e8 8d ff ff ff       	call   4b <panic>
    if(ecmd->argv[0] == 0)
  be:	8b 43 04             	mov    0x4(%ebx),%eax
  c1:	85 c0                	test   %eax,%eax
  c3:	74 2c                	je     f1 <runcmd+0x66>
    exec(ecmd->argv[0], ecmd->argv);
  c5:	8d 53 04             	lea    0x4(%ebx),%edx
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	52                   	push   %edx
  cc:	50                   	push   %eax
  cd:	e8 cc 0a 00 00       	call   b9e <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
  d2:	83 c4 0c             	add    $0xc,%esp
  d5:	ff 73 04             	push   0x4(%ebx)
  d8:	68 6f 0f 00 00       	push   $0xf6f
  dd:	6a 02                	push   $0x2
  df:	e8 d5 0b 00 00       	call   cb9 <printf>
    break;
  e4:	83 c4 10             	add    $0x10,%esp
  exit(0);
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	6a 00                	push   $0x0
  ec:	e8 75 0a 00 00       	call   b66 <exit>
      exit(0);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	6a 00                	push   $0x0
  f6:	e8 6b 0a 00 00       	call   b66 <exit>
    close(rcmd->fd);
  fb:	83 ec 0c             	sub    $0xc,%esp
  fe:	ff 73 14             	push   0x14(%ebx)
 101:	e8 88 0a 00 00       	call   b8e <close>
    if(open(rcmd->file, rcmd->mode) < 0){
 106:	83 c4 08             	add    $0x8,%esp
 109:	ff 73 10             	push   0x10(%ebx)
 10c:	ff 73 08             	push   0x8(%ebx)
 10f:	e8 92 0a 00 00       	call   ba6 <open>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	78 0b                	js     126 <runcmd+0x9b>
    runcmd(rcmd->cmd);
 11b:	83 ec 0c             	sub    $0xc,%esp
 11e:	ff 73 04             	push   0x4(%ebx)
 121:	e8 65 ff ff ff       	call   8b <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
 126:	83 ec 04             	sub    $0x4,%esp
 129:	ff 73 08             	push   0x8(%ebx)
 12c:	68 7f 0f 00 00       	push   $0xf7f
 131:	6a 02                	push   $0x2
 133:	e8 81 0b 00 00       	call   cb9 <printf>
      exit(0);
 138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 13f:	e8 22 0a 00 00       	call   b66 <exit>
    if(fork1() == 0)
 144:	e8 23 ff ff ff       	call   6c <fork1>
 149:	85 c0                	test   %eax,%eax
 14b:	74 15                	je     162 <runcmd+0xd7>
    wait(NULL);
 14d:	83 ec 0c             	sub    $0xc,%esp
 150:	6a 00                	push   $0x0
 152:	e8 17 0a 00 00       	call   b6e <wait>
    runcmd(lcmd->right);
 157:	83 c4 04             	add    $0x4,%esp
 15a:	ff 73 08             	push   0x8(%ebx)
 15d:	e8 29 ff ff ff       	call   8b <runcmd>
      runcmd(lcmd->left);
 162:	83 ec 0c             	sub    $0xc,%esp
 165:	ff 73 04             	push   0x4(%ebx)
 168:	e8 1e ff ff ff       	call   8b <runcmd>
    if(pipe(p) < 0)
 16d:	83 ec 0c             	sub    $0xc,%esp
 170:	8d 45 f0             	lea    -0x10(%ebp),%eax
 173:	50                   	push   %eax
 174:	e8 fd 09 00 00       	call   b76 <pipe>
 179:	83 c4 10             	add    $0x10,%esp
 17c:	85 c0                	test   %eax,%eax
 17e:	78 48                	js     1c8 <runcmd+0x13d>
    if(fork1() == 0){
 180:	e8 e7 fe ff ff       	call   6c <fork1>
 185:	85 c0                	test   %eax,%eax
 187:	74 4c                	je     1d5 <runcmd+0x14a>
    if(fork1() == 0){
 189:	e8 de fe ff ff       	call   6c <fork1>
 18e:	85 c0                	test   %eax,%eax
 190:	74 71                	je     203 <runcmd+0x178>
    close(p[0]);
 192:	83 ec 0c             	sub    $0xc,%esp
 195:	ff 75 f0             	push   -0x10(%ebp)
 198:	e8 f1 09 00 00       	call   b8e <close>
    close(p[1]);
 19d:	83 c4 04             	add    $0x4,%esp
 1a0:	ff 75 f4             	push   -0xc(%ebp)
 1a3:	e8 e6 09 00 00       	call   b8e <close>
    wait(NULL);
 1a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1af:	e8 ba 09 00 00       	call   b6e <wait>
    wait(NULL);
 1b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bb:	e8 ae 09 00 00       	call   b6e <wait>
    break;
 1c0:	83 c4 10             	add    $0x10,%esp
 1c3:	e9 1f ff ff ff       	jmp    e7 <runcmd+0x5c>
      panic("pipe");
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	68 8f 0f 00 00       	push   $0xf8f
 1d0:	e8 76 fe ff ff       	call   4b <panic>
      dup2(p[1],1);
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	6a 01                	push   $0x1
 1da:	ff 75 f4             	push   -0xc(%ebp)
 1dd:	e8 04 0a 00 00       	call   be6 <dup2>
      close(p[0]);
 1e2:	83 c4 04             	add    $0x4,%esp
 1e5:	ff 75 f0             	push   -0x10(%ebp)
 1e8:	e8 a1 09 00 00       	call   b8e <close>
      close(p[1]);
 1ed:	83 c4 04             	add    $0x4,%esp
 1f0:	ff 75 f4             	push   -0xc(%ebp)
 1f3:	e8 96 09 00 00       	call   b8e <close>
      runcmd(pcmd->left);
 1f8:	83 c4 04             	add    $0x4,%esp
 1fb:	ff 73 04             	push   0x4(%ebx)
 1fe:	e8 88 fe ff ff       	call   8b <runcmd>
      dup2(p[0],0);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	6a 00                	push   $0x0
 208:	ff 75 f0             	push   -0x10(%ebp)
 20b:	e8 d6 09 00 00       	call   be6 <dup2>
      close(p[0]);
 210:	83 c4 04             	add    $0x4,%esp
 213:	ff 75 f0             	push   -0x10(%ebp)
 216:	e8 73 09 00 00       	call   b8e <close>
      close(p[1]);
 21b:	83 c4 04             	add    $0x4,%esp
 21e:	ff 75 f4             	push   -0xc(%ebp)
 221:	e8 68 09 00 00       	call   b8e <close>
      runcmd(pcmd->right);
 226:	83 c4 04             	add    $0x4,%esp
 229:	ff 73 08             	push   0x8(%ebx)
 22c:	e8 5a fe ff ff       	call   8b <runcmd>
    if(fork1() == 0)
 231:	e8 36 fe ff ff       	call   6c <fork1>
 236:	85 c0                	test   %eax,%eax
 238:	0f 85 a9 fe ff ff    	jne    e7 <runcmd+0x5c>
      runcmd(bcmd->cmd);
 23e:	83 ec 0c             	sub    $0xc,%esp
 241:	ff 73 04             	push   0x4(%ebx)
 244:	e8 42 fe ff ff       	call   8b <runcmd>

00000249 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	53                   	push   %ebx
 24d:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 250:	6a 54                	push   $0x54
 252:	e8 82 0c 00 00       	call   ed9 <malloc>
 257:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 259:	83 c4 0c             	add    $0xc,%esp
 25c:	6a 54                	push   $0x54
 25e:	6a 00                	push   $0x0
 260:	50                   	push   %eax
 261:	e8 d5 07 00 00       	call   a3b <memset>
  cmd->type = EXEC;
 266:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
 26c:	89 d8                	mov    %ebx,%eax
 26e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	53                   	push   %ebx
 277:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 27a:	6a 18                	push   $0x18
 27c:	e8 58 0c 00 00       	call   ed9 <malloc>
 281:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 283:	83 c4 0c             	add    $0xc,%esp
 286:	6a 18                	push   $0x18
 288:	6a 00                	push   $0x0
 28a:	50                   	push   %eax
 28b:	e8 ab 07 00 00       	call   a3b <memset>
  cmd->type = REDIR;
 290:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
 2a8:	8b 45 14             	mov    0x14(%ebp),%eax
 2ab:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
 2ae:	8b 45 18             	mov    0x18(%ebp),%eax
 2b1:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
 2b4:	89 d8                	mov    %ebx,%eax
 2b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b9:	c9                   	leave  
 2ba:	c3                   	ret    

000002bb <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
 2be:	53                   	push   %ebx
 2bf:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2c2:	6a 0c                	push   $0xc
 2c4:	e8 10 0c 00 00       	call   ed9 <malloc>
 2c9:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2cb:	83 c4 0c             	add    $0xc,%esp
 2ce:	6a 0c                	push   $0xc
 2d0:	6a 00                	push   $0x0
 2d2:	50                   	push   %eax
 2d3:	e8 63 07 00 00       	call   a3b <memset>
  cmd->type = PIPE;
 2d8:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 2e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e7:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 2ea:	89 d8                	mov    %ebx,%eax
 2ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	53                   	push   %ebx
 2f5:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2f8:	6a 0c                	push   $0xc
 2fa:	e8 da 0b 00 00       	call   ed9 <malloc>
 2ff:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 301:	83 c4 0c             	add    $0xc,%esp
 304:	6a 0c                	push   $0xc
 306:	6a 00                	push   $0x0
 308:	50                   	push   %eax
 309:	e8 2d 07 00 00       	call   a3b <memset>
  cmd->type = LIST;
 30e:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 31a:	8b 45 0c             	mov    0xc(%ebp),%eax
 31d:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 320:	89 d8                	mov    %ebx,%eax
 322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	53                   	push   %ebx
 32b:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 32e:	6a 08                	push   $0x8
 330:	e8 a4 0b 00 00       	call   ed9 <malloc>
 335:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 337:	83 c4 0c             	add    $0xc,%esp
 33a:	6a 08                	push   $0x8
 33c:	6a 00                	push   $0x0
 33e:	50                   	push   %eax
 33f:	e8 f7 06 00 00       	call   a3b <memset>
  cmd->type = BACK;
 344:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
 350:	89 d8                	mov    %ebx,%eax
 352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 355:	c9                   	leave  
 356:	c3                   	ret    

00000357 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	57                   	push   %edi
 35b:	56                   	push   %esi
 35c:	53                   	push   %ebx
 35d:	83 ec 0c             	sub    $0xc,%esp
 360:	8b 75 0c             	mov    0xc(%ebp),%esi
 363:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
 366:	8b 45 08             	mov    0x8(%ebp),%eax
 369:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
 36b:	eb 01                	jmp    36e <gettoken+0x17>
    s++;
 36d:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
 36e:	39 f3                	cmp    %esi,%ebx
 370:	73 18                	jae    38a <gettoken+0x33>
 372:	83 ec 08             	sub    $0x8,%esp
 375:	0f be 03             	movsbl (%ebx),%eax
 378:	50                   	push   %eax
 379:	68 48 16 00 00       	push   $0x1648
 37e:	e8 d0 06 00 00       	call   a53 <strchr>
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	75 e3                	jne    36d <gettoken+0x16>
  if(q)
 38a:	85 ff                	test   %edi,%edi
 38c:	74 02                	je     390 <gettoken+0x39>
    *q = s;
 38e:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
 390:	8a 03                	mov    (%ebx),%al
 392:	0f be f8             	movsbl %al,%edi
  switch(*s){
 395:	3c 3c                	cmp    $0x3c,%al
 397:	7f 25                	jg     3be <gettoken+0x67>
 399:	3c 3b                	cmp    $0x3b,%al
 39b:	7d 13                	jge    3b0 <gettoken+0x59>
 39d:	84 c0                	test   %al,%al
 39f:	74 10                	je     3b1 <gettoken+0x5a>
 3a1:	78 3d                	js     3e0 <gettoken+0x89>
 3a3:	3c 26                	cmp    $0x26,%al
 3a5:	74 09                	je     3b0 <gettoken+0x59>
 3a7:	7c 37                	jl     3e0 <gettoken+0x89>
 3a9:	83 e8 28             	sub    $0x28,%eax
 3ac:	3c 01                	cmp    $0x1,%al
 3ae:	77 30                	ja     3e0 <gettoken+0x89>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
 3b0:	43                   	inc    %ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 3b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b5:	74 73                	je     42a <gettoken+0xd3>
    *eq = s;
 3b7:	8b 45 14             	mov    0x14(%ebp),%eax
 3ba:	89 18                	mov    %ebx,(%eax)
 3bc:	eb 6c                	jmp    42a <gettoken+0xd3>
  switch(*s){
 3be:	3c 3e                	cmp    $0x3e,%al
 3c0:	75 0d                	jne    3cf <gettoken+0x78>
    s++;
 3c2:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
 3c5:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
 3c9:	74 0a                	je     3d5 <gettoken+0x7e>
    s++;
 3cb:	89 c3                	mov    %eax,%ebx
 3cd:	eb e2                	jmp    3b1 <gettoken+0x5a>
  switch(*s){
 3cf:	3c 7c                	cmp    $0x7c,%al
 3d1:	75 0d                	jne    3e0 <gettoken+0x89>
 3d3:	eb db                	jmp    3b0 <gettoken+0x59>
      s++;
 3d5:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
 3d8:	bf 2b 00 00 00       	mov    $0x2b,%edi
 3dd:	eb d2                	jmp    3b1 <gettoken+0x5a>
      s++;
 3df:	43                   	inc    %ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 3e0:	39 f3                	cmp    %esi,%ebx
 3e2:	73 37                	jae    41b <gettoken+0xc4>
 3e4:	83 ec 08             	sub    $0x8,%esp
 3e7:	0f be 03             	movsbl (%ebx),%eax
 3ea:	50                   	push   %eax
 3eb:	68 48 16 00 00       	push   $0x1648
 3f0:	e8 5e 06 00 00       	call   a53 <strchr>
 3f5:	83 c4 10             	add    $0x10,%esp
 3f8:	85 c0                	test   %eax,%eax
 3fa:	75 26                	jne    422 <gettoken+0xcb>
 3fc:	83 ec 08             	sub    $0x8,%esp
 3ff:	0f be 03             	movsbl (%ebx),%eax
 402:	50                   	push   %eax
 403:	68 40 16 00 00       	push   $0x1640
 408:	e8 46 06 00 00       	call   a53 <strchr>
 40d:	83 c4 10             	add    $0x10,%esp
 410:	85 c0                	test   %eax,%eax
 412:	74 cb                	je     3df <gettoken+0x88>
    ret = 'a';
 414:	bf 61 00 00 00       	mov    $0x61,%edi
 419:	eb 96                	jmp    3b1 <gettoken+0x5a>
 41b:	bf 61 00 00 00       	mov    $0x61,%edi
 420:	eb 8f                	jmp    3b1 <gettoken+0x5a>
 422:	bf 61 00 00 00       	mov    $0x61,%edi
 427:	eb 88                	jmp    3b1 <gettoken+0x5a>

  while(s < es && strchr(whitespace, *s))
    s++;
 429:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
 42a:	39 f3                	cmp    %esi,%ebx
 42c:	73 18                	jae    446 <gettoken+0xef>
 42e:	83 ec 08             	sub    $0x8,%esp
 431:	0f be 03             	movsbl (%ebx),%eax
 434:	50                   	push   %eax
 435:	68 48 16 00 00       	push   $0x1648
 43a:	e8 14 06 00 00       	call   a53 <strchr>
 43f:	83 c4 10             	add    $0x10,%esp
 442:	85 c0                	test   %eax,%eax
 444:	75 e3                	jne    429 <gettoken+0xd2>
  *ps = s;
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	89 18                	mov    %ebx,(%eax)
  return ret;
}
 44b:	89 f8                	mov    %edi,%eax
 44d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 450:	5b                   	pop    %ebx
 451:	5e                   	pop    %esi
 452:	5f                   	pop    %edi
 453:	5d                   	pop    %ebp
 454:	c3                   	ret    

00000455 <peek>:

int
peek(char **ps, char *es, char *toks)
{
 455:	55                   	push   %ebp
 456:	89 e5                	mov    %esp,%ebp
 458:	57                   	push   %edi
 459:	56                   	push   %esi
 45a:	53                   	push   %ebx
 45b:	83 ec 0c             	sub    $0xc,%esp
 45e:	8b 7d 08             	mov    0x8(%ebp),%edi
 461:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 464:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 466:	eb 01                	jmp    469 <peek+0x14>
    s++;
 468:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
 469:	39 f3                	cmp    %esi,%ebx
 46b:	73 18                	jae    485 <peek+0x30>
 46d:	83 ec 08             	sub    $0x8,%esp
 470:	0f be 03             	movsbl (%ebx),%eax
 473:	50                   	push   %eax
 474:	68 48 16 00 00       	push   $0x1648
 479:	e8 d5 05 00 00       	call   a53 <strchr>
 47e:	83 c4 10             	add    $0x10,%esp
 481:	85 c0                	test   %eax,%eax
 483:	75 e3                	jne    468 <peek+0x13>
  *ps = s;
 485:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 487:	8a 03                	mov    (%ebx),%al
 489:	84 c0                	test   %al,%al
 48b:	75 0d                	jne    49a <peek+0x45>
 48d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 492:	8d 65 f4             	lea    -0xc(%ebp),%esp
 495:	5b                   	pop    %ebx
 496:	5e                   	pop    %esi
 497:	5f                   	pop    %edi
 498:	5d                   	pop    %ebp
 499:	c3                   	ret    
  return *s && strchr(toks, *s);
 49a:	83 ec 08             	sub    $0x8,%esp
 49d:	0f be c0             	movsbl %al,%eax
 4a0:	50                   	push   %eax
 4a1:	ff 75 10             	push   0x10(%ebp)
 4a4:	e8 aa 05 00 00       	call   a53 <strchr>
 4a9:	83 c4 10             	add    $0x10,%esp
 4ac:	85 c0                	test   %eax,%eax
 4ae:	74 07                	je     4b7 <peek+0x62>
 4b0:	b8 01 00 00 00       	mov    $0x1,%eax
 4b5:	eb db                	jmp    492 <peek+0x3d>
 4b7:	b8 00 00 00 00       	mov    $0x0,%eax
 4bc:	eb d4                	jmp    492 <peek+0x3d>

000004be <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	57                   	push   %edi
 4c2:	56                   	push   %esi
 4c3:	53                   	push   %ebx
 4c4:	83 ec 1c             	sub    $0x1c,%esp
 4c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
 4ca:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 4cd:	eb 28                	jmp    4f7 <parseredirs+0x39>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
 4cf:	83 ec 0c             	sub    $0xc,%esp
 4d2:	68 94 0f 00 00       	push   $0xf94
 4d7:	e8 6f fb ff ff       	call   4b <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 4dc:	83 ec 0c             	sub    $0xc,%esp
 4df:	6a 00                	push   $0x0
 4e1:	6a 00                	push   $0x0
 4e3:	ff 75 e0             	push   -0x20(%ebp)
 4e6:	ff 75 e4             	push   -0x1c(%ebp)
 4e9:	ff 75 08             	push   0x8(%ebp)
 4ec:	e8 82 fd ff ff       	call   273 <redircmd>
 4f1:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 4f4:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
 4f7:	83 ec 04             	sub    $0x4,%esp
 4fa:	68 b1 0f 00 00       	push   $0xfb1
 4ff:	56                   	push   %esi
 500:	57                   	push   %edi
 501:	e8 4f ff ff ff       	call   455 <peek>
 506:	83 c4 10             	add    $0x10,%esp
 509:	85 c0                	test   %eax,%eax
 50b:	74 76                	je     583 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
 50d:	6a 00                	push   $0x0
 50f:	6a 00                	push   $0x0
 511:	56                   	push   %esi
 512:	57                   	push   %edi
 513:	e8 3f fe ff ff       	call   357 <gettoken>
 518:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
 51a:	8d 45 e0             	lea    -0x20(%ebp),%eax
 51d:	50                   	push   %eax
 51e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 521:	50                   	push   %eax
 522:	56                   	push   %esi
 523:	57                   	push   %edi
 524:	e8 2e fe ff ff       	call   357 <gettoken>
 529:	83 c4 20             	add    $0x20,%esp
 52c:	83 f8 61             	cmp    $0x61,%eax
 52f:	75 9e                	jne    4cf <parseredirs+0x11>
    switch(tok){
 531:	83 fb 3c             	cmp    $0x3c,%ebx
 534:	74 a6                	je     4dc <parseredirs+0x1e>
 536:	83 fb 3e             	cmp    $0x3e,%ebx
 539:	74 25                	je     560 <parseredirs+0xa2>
 53b:	83 fb 2b             	cmp    $0x2b,%ebx
 53e:	75 b7                	jne    4f7 <parseredirs+0x39>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	6a 01                	push   $0x1
 545:	68 01 02 00 00       	push   $0x201
 54a:	ff 75 e0             	push   -0x20(%ebp)
 54d:	ff 75 e4             	push   -0x1c(%ebp)
 550:	ff 75 08             	push   0x8(%ebp)
 553:	e8 1b fd ff ff       	call   273 <redircmd>
 558:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 55b:	83 c4 20             	add    $0x20,%esp
 55e:	eb 97                	jmp    4f7 <parseredirs+0x39>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 560:	83 ec 0c             	sub    $0xc,%esp
 563:	6a 01                	push   $0x1
 565:	68 01 02 00 00       	push   $0x201
 56a:	ff 75 e0             	push   -0x20(%ebp)
 56d:	ff 75 e4             	push   -0x1c(%ebp)
 570:	ff 75 08             	push   0x8(%ebp)
 573:	e8 fb fc ff ff       	call   273 <redircmd>
 578:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 57b:	83 c4 20             	add    $0x20,%esp
 57e:	e9 74 ff ff ff       	jmp    4f7 <parseredirs+0x39>
    }
  }
  return cmd;
}
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	8d 65 f4             	lea    -0xc(%ebp),%esp
 589:	5b                   	pop    %ebx
 58a:	5e                   	pop    %esi
 58b:	5f                   	pop    %edi
 58c:	5d                   	pop    %ebp
 58d:	c3                   	ret    

0000058e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	57                   	push   %edi
 592:	56                   	push   %esi
 593:	53                   	push   %ebx
 594:	83 ec 30             	sub    $0x30,%esp
 597:	8b 75 08             	mov    0x8(%ebp),%esi
 59a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
 59d:	68 b4 0f 00 00       	push   $0xfb4
 5a2:	57                   	push   %edi
 5a3:	56                   	push   %esi
 5a4:	e8 ac fe ff ff       	call   455 <peek>
 5a9:	83 c4 10             	add    $0x10,%esp
 5ac:	85 c0                	test   %eax,%eax
 5ae:	75 1d                	jne    5cd <parseexec+0x3f>
 5b0:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
 5b2:	e8 92 fc ff ff       	call   249 <execcmd>
 5b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 5ba:	83 ec 04             	sub    $0x4,%esp
 5bd:	57                   	push   %edi
 5be:	56                   	push   %esi
 5bf:	50                   	push   %eax
 5c0:	e8 f9 fe ff ff       	call   4be <parseredirs>
 5c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	eb 3b                	jmp    608 <parseexec+0x7a>
    return parseblock(ps, es);
 5cd:	83 ec 08             	sub    $0x8,%esp
 5d0:	57                   	push   %edi
 5d1:	56                   	push   %esi
 5d2:	e8 8d 01 00 00       	call   764 <parseblock>
 5d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5da:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
 5dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e3:	5b                   	pop    %ebx
 5e4:	5e                   	pop    %esi
 5e5:	5f                   	pop    %edi
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    
      panic("syntax");
 5e8:	83 ec 0c             	sub    $0xc,%esp
 5eb:	68 b6 0f 00 00       	push   $0xfb6
 5f0:	e8 56 fa ff ff       	call   4b <panic>
    ret = parseredirs(ret, ps, es);
 5f5:	83 ec 04             	sub    $0x4,%esp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	ff 75 d4             	push   -0x2c(%ebp)
 5fd:	e8 bc fe ff ff       	call   4be <parseredirs>
 602:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 605:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
 608:	83 ec 04             	sub    $0x4,%esp
 60b:	68 cb 0f 00 00       	push   $0xfcb
 610:	57                   	push   %edi
 611:	56                   	push   %esi
 612:	e8 3e fe ff ff       	call   455 <peek>
 617:	83 c4 10             	add    $0x10,%esp
 61a:	85 c0                	test   %eax,%eax
 61c:	75 3f                	jne    65d <parseexec+0xcf>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 61e:	8d 45 e0             	lea    -0x20(%ebp),%eax
 621:	50                   	push   %eax
 622:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 625:	50                   	push   %eax
 626:	57                   	push   %edi
 627:	56                   	push   %esi
 628:	e8 2a fd ff ff       	call   357 <gettoken>
 62d:	83 c4 10             	add    $0x10,%esp
 630:	85 c0                	test   %eax,%eax
 632:	74 29                	je     65d <parseexec+0xcf>
    if(tok != 'a')
 634:	83 f8 61             	cmp    $0x61,%eax
 637:	75 af                	jne    5e8 <parseexec+0x5a>
    cmd->argv[argc] = q;
 639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63c:	8b 55 d0             	mov    -0x30(%ebp),%edx
 63f:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
 643:	8b 45 e0             	mov    -0x20(%ebp),%eax
 646:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
 64a:	43                   	inc    %ebx
    if(argc >= MAXARGS)
 64b:	83 fb 09             	cmp    $0x9,%ebx
 64e:	7e a5                	jle    5f5 <parseexec+0x67>
      panic("too many args");
 650:	83 ec 0c             	sub    $0xc,%esp
 653:	68 bd 0f 00 00       	push   $0xfbd
 658:	e8 ee f9 ff ff       	call   4b <panic>
  cmd->argv[argc] = 0;
 65d:	8b 45 d0             	mov    -0x30(%ebp),%eax
 660:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
 667:	00 
  cmd->eargv[argc] = 0;
 668:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
 66f:	00 
  return ret;
 670:	e9 68 ff ff ff       	jmp    5dd <parseexec+0x4f>

00000675 <parsepipe>:
{
 675:	55                   	push   %ebp
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	83 ec 14             	sub    $0x14,%esp
 67e:	8b 75 08             	mov    0x8(%ebp),%esi
 681:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
 684:	57                   	push   %edi
 685:	56                   	push   %esi
 686:	e8 03 ff ff ff       	call   58e <parseexec>
 68b:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
 68d:	83 c4 0c             	add    $0xc,%esp
 690:	68 d0 0f 00 00       	push   $0xfd0
 695:	57                   	push   %edi
 696:	56                   	push   %esi
 697:	e8 b9 fd ff ff       	call   455 <peek>
 69c:	83 c4 10             	add    $0x10,%esp
 69f:	85 c0                	test   %eax,%eax
 6a1:	75 0a                	jne    6ad <parsepipe+0x38>
}
 6a3:	89 d8                	mov    %ebx,%eax
 6a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a8:	5b                   	pop    %ebx
 6a9:	5e                   	pop    %esi
 6aa:	5f                   	pop    %edi
 6ab:	5d                   	pop    %ebp
 6ac:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 6ad:	6a 00                	push   $0x0
 6af:	6a 00                	push   $0x0
 6b1:	57                   	push   %edi
 6b2:	56                   	push   %esi
 6b3:	e8 9f fc ff ff       	call   357 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 6b8:	83 c4 08             	add    $0x8,%esp
 6bb:	57                   	push   %edi
 6bc:	56                   	push   %esi
 6bd:	e8 b3 ff ff ff       	call   675 <parsepipe>
 6c2:	83 c4 08             	add    $0x8,%esp
 6c5:	50                   	push   %eax
 6c6:	53                   	push   %ebx
 6c7:	e8 ef fb ff ff       	call   2bb <pipecmd>
 6cc:	89 c3                	mov    %eax,%ebx
 6ce:	83 c4 10             	add    $0x10,%esp
  return cmd;
 6d1:	eb d0                	jmp    6a3 <parsepipe+0x2e>

000006d3 <parseline>:
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	57                   	push   %edi
 6d7:	56                   	push   %esi
 6d8:	53                   	push   %ebx
 6d9:	83 ec 14             	sub    $0x14,%esp
 6dc:	8b 75 08             	mov    0x8(%ebp),%esi
 6df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
 6e2:	57                   	push   %edi
 6e3:	56                   	push   %esi
 6e4:	e8 8c ff ff ff       	call   675 <parsepipe>
 6e9:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
 6eb:	83 c4 10             	add    $0x10,%esp
 6ee:	eb 18                	jmp    708 <parseline+0x35>
    gettoken(ps, es, 0, 0);
 6f0:	6a 00                	push   $0x0
 6f2:	6a 00                	push   $0x0
 6f4:	57                   	push   %edi
 6f5:	56                   	push   %esi
 6f6:	e8 5c fc ff ff       	call   357 <gettoken>
    cmd = backcmd(cmd);
 6fb:	89 1c 24             	mov    %ebx,(%esp)
 6fe:	e8 24 fc ff ff       	call   327 <backcmd>
 703:	89 c3                	mov    %eax,%ebx
 705:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
 708:	83 ec 04             	sub    $0x4,%esp
 70b:	68 d2 0f 00 00       	push   $0xfd2
 710:	57                   	push   %edi
 711:	56                   	push   %esi
 712:	e8 3e fd ff ff       	call   455 <peek>
 717:	83 c4 10             	add    $0x10,%esp
 71a:	85 c0                	test   %eax,%eax
 71c:	75 d2                	jne    6f0 <parseline+0x1d>
  if(peek(ps, es, ";")){
 71e:	83 ec 04             	sub    $0x4,%esp
 721:	68 ce 0f 00 00       	push   $0xfce
 726:	57                   	push   %edi
 727:	56                   	push   %esi
 728:	e8 28 fd ff ff       	call   455 <peek>
 72d:	83 c4 10             	add    $0x10,%esp
 730:	85 c0                	test   %eax,%eax
 732:	75 0a                	jne    73e <parseline+0x6b>
}
 734:	89 d8                	mov    %ebx,%eax
 736:	8d 65 f4             	lea    -0xc(%ebp),%esp
 739:	5b                   	pop    %ebx
 73a:	5e                   	pop    %esi
 73b:	5f                   	pop    %edi
 73c:	5d                   	pop    %ebp
 73d:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 73e:	6a 00                	push   $0x0
 740:	6a 00                	push   $0x0
 742:	57                   	push   %edi
 743:	56                   	push   %esi
 744:	e8 0e fc ff ff       	call   357 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 749:	83 c4 08             	add    $0x8,%esp
 74c:	57                   	push   %edi
 74d:	56                   	push   %esi
 74e:	e8 80 ff ff ff       	call   6d3 <parseline>
 753:	83 c4 08             	add    $0x8,%esp
 756:	50                   	push   %eax
 757:	53                   	push   %ebx
 758:	e8 94 fb ff ff       	call   2f1 <listcmd>
 75d:	89 c3                	mov    %eax,%ebx
 75f:	83 c4 10             	add    $0x10,%esp
  return cmd;
 762:	eb d0                	jmp    734 <parseline+0x61>

00000764 <parseblock>:
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	57                   	push   %edi
 768:	56                   	push   %esi
 769:	53                   	push   %ebx
 76a:	83 ec 10             	sub    $0x10,%esp
 76d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 770:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
 773:	68 b4 0f 00 00       	push   $0xfb4
 778:	56                   	push   %esi
 779:	53                   	push   %ebx
 77a:	e8 d6 fc ff ff       	call   455 <peek>
 77f:	83 c4 10             	add    $0x10,%esp
 782:	85 c0                	test   %eax,%eax
 784:	74 4b                	je     7d1 <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
 786:	6a 00                	push   $0x0
 788:	6a 00                	push   $0x0
 78a:	56                   	push   %esi
 78b:	53                   	push   %ebx
 78c:	e8 c6 fb ff ff       	call   357 <gettoken>
  cmd = parseline(ps, es);
 791:	83 c4 08             	add    $0x8,%esp
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	e8 38 ff ff ff       	call   6d3 <parseline>
 79b:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
 79d:	83 c4 0c             	add    $0xc,%esp
 7a0:	68 f0 0f 00 00       	push   $0xff0
 7a5:	56                   	push   %esi
 7a6:	53                   	push   %ebx
 7a7:	e8 a9 fc ff ff       	call   455 <peek>
 7ac:	83 c4 10             	add    $0x10,%esp
 7af:	85 c0                	test   %eax,%eax
 7b1:	74 2b                	je     7de <parseblock+0x7a>
  gettoken(ps, es, 0, 0);
 7b3:	6a 00                	push   $0x0
 7b5:	6a 00                	push   $0x0
 7b7:	56                   	push   %esi
 7b8:	53                   	push   %ebx
 7b9:	e8 99 fb ff ff       	call   357 <gettoken>
  cmd = parseredirs(cmd, ps, es);
 7be:	83 c4 0c             	add    $0xc,%esp
 7c1:	56                   	push   %esi
 7c2:	53                   	push   %ebx
 7c3:	57                   	push   %edi
 7c4:	e8 f5 fc ff ff       	call   4be <parseredirs>
}
 7c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7cc:	5b                   	pop    %ebx
 7cd:	5e                   	pop    %esi
 7ce:	5f                   	pop    %edi
 7cf:	5d                   	pop    %ebp
 7d0:	c3                   	ret    
    panic("parseblock");
 7d1:	83 ec 0c             	sub    $0xc,%esp
 7d4:	68 d4 0f 00 00       	push   $0xfd4
 7d9:	e8 6d f8 ff ff       	call   4b <panic>
    panic("syntax - missing )");
 7de:	83 ec 0c             	sub    $0xc,%esp
 7e1:	68 df 0f 00 00       	push   $0xfdf
 7e6:	e8 60 f8 ff ff       	call   4b <panic>

000007eb <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	53                   	push   %ebx
 7ef:	83 ec 04             	sub    $0x4,%esp
 7f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 7f5:	85 db                	test   %ebx,%ebx
 7f7:	74 1d                	je     816 <nulterminate+0x2b>
    return 0;

  switch(cmd->type){
 7f9:	8b 03                	mov    (%ebx),%eax
 7fb:	83 f8 05             	cmp    $0x5,%eax
 7fe:	77 16                	ja     816 <nulterminate+0x2b>
 800:	ff 24 85 40 10 00 00 	jmp    *0x1040(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
 807:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
 80b:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
 80e:	40                   	inc    %eax
 80f:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
 814:	75 f1                	jne    807 <nulterminate+0x1c>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
 816:	89 d8                	mov    %ebx,%eax
 818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 81b:	c9                   	leave  
 81c:	c3                   	ret    
  switch(cmd->type){
 81d:	b8 00 00 00 00       	mov    $0x0,%eax
 822:	eb eb                	jmp    80f <nulterminate+0x24>
    nulterminate(rcmd->cmd);
 824:	83 ec 0c             	sub    $0xc,%esp
 827:	ff 73 04             	push   0x4(%ebx)
 82a:	e8 bc ff ff ff       	call   7eb <nulterminate>
    *rcmd->efile = 0;
 82f:	8b 43 0c             	mov    0xc(%ebx),%eax
 832:	c6 00 00             	movb   $0x0,(%eax)
    break;
 835:	83 c4 10             	add    $0x10,%esp
 838:	eb dc                	jmp    816 <nulterminate+0x2b>
    nulterminate(pcmd->left);
 83a:	83 ec 0c             	sub    $0xc,%esp
 83d:	ff 73 04             	push   0x4(%ebx)
 840:	e8 a6 ff ff ff       	call   7eb <nulterminate>
    nulterminate(pcmd->right);
 845:	83 c4 04             	add    $0x4,%esp
 848:	ff 73 08             	push   0x8(%ebx)
 84b:	e8 9b ff ff ff       	call   7eb <nulterminate>
    break;
 850:	83 c4 10             	add    $0x10,%esp
 853:	eb c1                	jmp    816 <nulterminate+0x2b>
    nulterminate(lcmd->left);
 855:	83 ec 0c             	sub    $0xc,%esp
 858:	ff 73 04             	push   0x4(%ebx)
 85b:	e8 8b ff ff ff       	call   7eb <nulterminate>
    nulterminate(lcmd->right);
 860:	83 c4 04             	add    $0x4,%esp
 863:	ff 73 08             	push   0x8(%ebx)
 866:	e8 80 ff ff ff       	call   7eb <nulterminate>
    break;
 86b:	83 c4 10             	add    $0x10,%esp
 86e:	eb a6                	jmp    816 <nulterminate+0x2b>
    nulterminate(bcmd->cmd);
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	ff 73 04             	push   0x4(%ebx)
 876:	e8 70 ff ff ff       	call   7eb <nulterminate>
    break;
 87b:	83 c4 10             	add    $0x10,%esp
 87e:	eb 96                	jmp    816 <nulterminate+0x2b>

00000880 <parsecmd>:
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	56                   	push   %esi
 884:	53                   	push   %ebx
  es = s + strlen(s);
 885:	8b 5d 08             	mov    0x8(%ebp),%ebx
 888:	83 ec 0c             	sub    $0xc,%esp
 88b:	53                   	push   %ebx
 88c:	e8 94 01 00 00       	call   a25 <strlen>
 891:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
 893:	83 c4 08             	add    $0x8,%esp
 896:	53                   	push   %ebx
 897:	8d 45 08             	lea    0x8(%ebp),%eax
 89a:	50                   	push   %eax
 89b:	e8 33 fe ff ff       	call   6d3 <parseline>
 8a0:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 8a2:	83 c4 0c             	add    $0xc,%esp
 8a5:	68 27 10 00 00       	push   $0x1027
 8aa:	53                   	push   %ebx
 8ab:	8d 45 08             	lea    0x8(%ebp),%eax
 8ae:	50                   	push   %eax
 8af:	e8 a1 fb ff ff       	call   455 <peek>
  if(s != es){
 8b4:	8b 45 08             	mov    0x8(%ebp),%eax
 8b7:	83 c4 10             	add    $0x10,%esp
 8ba:	39 d8                	cmp    %ebx,%eax
 8bc:	75 12                	jne    8d0 <parsecmd+0x50>
  nulterminate(cmd);
 8be:	83 ec 0c             	sub    $0xc,%esp
 8c1:	56                   	push   %esi
 8c2:	e8 24 ff ff ff       	call   7eb <nulterminate>
}
 8c7:	89 f0                	mov    %esi,%eax
 8c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8cc:	5b                   	pop    %ebx
 8cd:	5e                   	pop    %esi
 8ce:	5d                   	pop    %ebp
 8cf:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 8d0:	83 ec 04             	sub    $0x4,%esp
 8d3:	50                   	push   %eax
 8d4:	68 f2 0f 00 00       	push   $0xff2
 8d9:	6a 02                	push   $0x2
 8db:	e8 d9 03 00 00       	call   cb9 <printf>
    panic("syntax");
 8e0:	c7 04 24 b6 0f 00 00 	movl   $0xfb6,(%esp)
 8e7:	e8 5f f7 ff ff       	call   4b <panic>

000008ec <main>:
{
 8ec:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8f0:	83 e4 f0             	and    $0xfffffff0,%esp
 8f3:	ff 71 fc             	push   -0x4(%ecx)
 8f6:	55                   	push   %ebp
 8f7:	89 e5                	mov    %esp,%ebp
 8f9:	51                   	push   %ecx
 8fa:	83 ec 14             	sub    $0x14,%esp
  while((fd = open("console", O_RDWR)) >= 0){
 8fd:	83 ec 08             	sub    $0x8,%esp
 900:	6a 02                	push   $0x2
 902:	68 01 10 00 00       	push   $0x1001
 907:	e8 9a 02 00 00       	call   ba6 <open>
 90c:	83 c4 10             	add    $0x10,%esp
 90f:	85 c0                	test   %eax,%eax
 911:	78 41                	js     954 <main+0x68>
    if(fd >= 3){
 913:	83 f8 02             	cmp    $0x2,%eax
 916:	7e e5                	jle    8fd <main+0x11>
      close(fd);
 918:	83 ec 0c             	sub    $0xc,%esp
 91b:	50                   	push   %eax
 91c:	e8 6d 02 00 00       	call   b8e <close>
      break;
 921:	83 c4 10             	add    $0x10,%esp
 924:	eb 2e                	jmp    954 <main+0x68>
    if(fork1() == 0)
 926:	e8 41 f7 ff ff       	call   6c <fork1>
 92b:	85 c0                	test   %eax,%eax
 92d:	0f 84 92 00 00 00    	je     9c5 <main+0xd9>
    wait(&status);
 933:	83 ec 0c             	sub    $0xc,%esp
 936:	8d 45 f4             	lea    -0xc(%ebp),%eax
 939:	50                   	push   %eax
 93a:	e8 2f 02 00 00       	call   b6e <wait>
    printf(1, "Output code: %d\n", status);
 93f:	83 c4 0c             	add    $0xc,%esp
 942:	ff 75 f4             	push   -0xc(%ebp)
 945:	68 17 10 00 00       	push   $0x1017
 94a:	6a 01                	push   $0x1
 94c:	e8 68 03 00 00       	call   cb9 <printf>
 951:	83 c4 10             	add    $0x10,%esp
  while(getcmd(buf, sizeof(buf)) >= 0){
 954:	83 ec 08             	sub    $0x8,%esp
 957:	6a 64                	push   $0x64
 959:	68 60 16 00 00       	push   $0x1660
 95e:	e8 9d f6 ff ff       	call   0 <getcmd>
 963:	83 c4 10             	add    $0x10,%esp
 966:	85 c0                	test   %eax,%eax
 968:	78 70                	js     9da <main+0xee>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 96a:	80 3d 60 16 00 00 63 	cmpb   $0x63,0x1660
 971:	75 b3                	jne    926 <main+0x3a>
 973:	80 3d 61 16 00 00 64 	cmpb   $0x64,0x1661
 97a:	75 aa                	jne    926 <main+0x3a>
 97c:	80 3d 62 16 00 00 20 	cmpb   $0x20,0x1662
 983:	75 a1                	jne    926 <main+0x3a>
      buf[strlen(buf)-1] = 0;  // chop \n
 985:	83 ec 0c             	sub    $0xc,%esp
 988:	68 60 16 00 00       	push   $0x1660
 98d:	e8 93 00 00 00       	call   a25 <strlen>
 992:	c6 80 5f 16 00 00 00 	movb   $0x0,0x165f(%eax)
      if(chdir(buf+3) < 0)
 999:	c7 04 24 63 16 00 00 	movl   $0x1663,(%esp)
 9a0:	e8 31 02 00 00       	call   bd6 <chdir>
 9a5:	83 c4 10             	add    $0x10,%esp
 9a8:	85 c0                	test   %eax,%eax
 9aa:	79 a8                	jns    954 <main+0x68>
        printf(2, "cannot cd %s\n", buf+3);
 9ac:	83 ec 04             	sub    $0x4,%esp
 9af:	68 63 16 00 00       	push   $0x1663
 9b4:	68 09 10 00 00       	push   $0x1009
 9b9:	6a 02                	push   $0x2
 9bb:	e8 f9 02 00 00       	call   cb9 <printf>
 9c0:	83 c4 10             	add    $0x10,%esp
      continue;
 9c3:	eb 8f                	jmp    954 <main+0x68>
      runcmd(parsecmd(buf));
 9c5:	83 ec 0c             	sub    $0xc,%esp
 9c8:	68 60 16 00 00       	push   $0x1660
 9cd:	e8 ae fe ff ff       	call   880 <parsecmd>
 9d2:	89 04 24             	mov    %eax,(%esp)
 9d5:	e8 b1 f6 ff ff       	call   8b <runcmd>
  exit(0);
 9da:	83 ec 0c             	sub    $0xc,%esp
 9dd:	6a 00                	push   $0x0
 9df:	e8 82 01 00 00       	call   b66 <exit>

000009e4 <start>:

// Entry point of the library	
void
start()
{
}
 9e4:	c3                   	ret    

000009e5 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 9e5:	55                   	push   %ebp
 9e6:	89 e5                	mov    %esp,%ebp
 9e8:	56                   	push   %esi
 9e9:	53                   	push   %ebx
 9ea:	8b 45 08             	mov    0x8(%ebp),%eax
 9ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 9f0:	89 c2                	mov    %eax,%edx
 9f2:	89 cb                	mov    %ecx,%ebx
 9f4:	41                   	inc    %ecx
 9f5:	89 d6                	mov    %edx,%esi
 9f7:	42                   	inc    %edx
 9f8:	8a 1b                	mov    (%ebx),%bl
 9fa:	88 1e                	mov    %bl,(%esi)
 9fc:	84 db                	test   %bl,%bl
 9fe:	75 f2                	jne    9f2 <strcpy+0xd>
    ;
  return os;
}
 a00:	5b                   	pop    %ebx
 a01:	5e                   	pop    %esi
 a02:	5d                   	pop    %ebp
 a03:	c3                   	ret    

00000a04 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 a04:	55                   	push   %ebp
 a05:	89 e5                	mov    %esp,%ebp
 a07:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 a0d:	eb 02                	jmp    a11 <strcmp+0xd>
    p++, q++;
 a0f:	41                   	inc    %ecx
 a10:	42                   	inc    %edx
  while(*p && *p == *q)
 a11:	8a 01                	mov    (%ecx),%al
 a13:	84 c0                	test   %al,%al
 a15:	74 04                	je     a1b <strcmp+0x17>
 a17:	3a 02                	cmp    (%edx),%al
 a19:	74 f4                	je     a0f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 a1b:	0f b6 c0             	movzbl %al,%eax
 a1e:	0f b6 12             	movzbl (%edx),%edx
 a21:	29 d0                	sub    %edx,%eax
}
 a23:	5d                   	pop    %ebp
 a24:	c3                   	ret    

00000a25 <strlen>:

uint
strlen(const char *s)
{
 a25:	55                   	push   %ebp
 a26:	89 e5                	mov    %esp,%ebp
 a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 a2b:	b8 00 00 00 00       	mov    $0x0,%eax
 a30:	eb 01                	jmp    a33 <strlen+0xe>
 a32:	40                   	inc    %eax
 a33:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 a37:	75 f9                	jne    a32 <strlen+0xd>
    ;
  return n;
}
 a39:	5d                   	pop    %ebp
 a3a:	c3                   	ret    

00000a3b <memset>:

void*
memset(void *dst, int c, uint n)
{
 a3b:	55                   	push   %ebp
 a3c:	89 e5                	mov    %esp,%ebp
 a3e:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 a3f:	8b 7d 08             	mov    0x8(%ebp),%edi
 a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a45:	8b 45 0c             	mov    0xc(%ebp),%eax
 a48:	fc                   	cld    
 a49:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 a4b:	8b 45 08             	mov    0x8(%ebp),%eax
 a4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
 a51:	c9                   	leave  
 a52:	c3                   	ret    

00000a53 <strchr>:

char*
strchr(const char *s, char c)
{
 a53:	55                   	push   %ebp
 a54:	89 e5                	mov    %esp,%ebp
 a56:	8b 45 08             	mov    0x8(%ebp),%eax
 a59:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 a5c:	eb 01                	jmp    a5f <strchr+0xc>
 a5e:	40                   	inc    %eax
 a5f:	8a 10                	mov    (%eax),%dl
 a61:	84 d2                	test   %dl,%dl
 a63:	74 06                	je     a6b <strchr+0x18>
    if(*s == c)
 a65:	38 ca                	cmp    %cl,%dl
 a67:	75 f5                	jne    a5e <strchr+0xb>
 a69:	eb 05                	jmp    a70 <strchr+0x1d>
      return (char*)s;
  return 0;
 a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a70:	5d                   	pop    %ebp
 a71:	c3                   	ret    

00000a72 <gets>:

char*
gets(char *buf, int max)
{
 a72:	55                   	push   %ebp
 a73:	89 e5                	mov    %esp,%ebp
 a75:	57                   	push   %edi
 a76:	56                   	push   %esi
 a77:	53                   	push   %ebx
 a78:	83 ec 1c             	sub    $0x1c,%esp
 a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a7e:	bb 00 00 00 00       	mov    $0x0,%ebx
 a83:	89 de                	mov    %ebx,%esi
 a85:	43                   	inc    %ebx
 a86:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a89:	7d 2b                	jge    ab6 <gets+0x44>
    cc = read(0, &c, 1);
 a8b:	83 ec 04             	sub    $0x4,%esp
 a8e:	6a 01                	push   $0x1
 a90:	8d 45 e7             	lea    -0x19(%ebp),%eax
 a93:	50                   	push   %eax
 a94:	6a 00                	push   $0x0
 a96:	e8 e3 00 00 00       	call   b7e <read>
    if(cc < 1)
 a9b:	83 c4 10             	add    $0x10,%esp
 a9e:	85 c0                	test   %eax,%eax
 aa0:	7e 14                	jle    ab6 <gets+0x44>
      break;
    buf[i++] = c;
 aa2:	8a 45 e7             	mov    -0x19(%ebp),%al
 aa5:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 aa8:	3c 0a                	cmp    $0xa,%al
 aaa:	74 08                	je     ab4 <gets+0x42>
 aac:	3c 0d                	cmp    $0xd,%al
 aae:	75 d3                	jne    a83 <gets+0x11>
    buf[i++] = c;
 ab0:	89 de                	mov    %ebx,%esi
 ab2:	eb 02                	jmp    ab6 <gets+0x44>
 ab4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 ab6:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 aba:	89 f8                	mov    %edi,%eax
 abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 abf:	5b                   	pop    %ebx
 ac0:	5e                   	pop    %esi
 ac1:	5f                   	pop    %edi
 ac2:	5d                   	pop    %ebp
 ac3:	c3                   	ret    

00000ac4 <stat>:

int
stat(const char *n, struct stat *st)
{
 ac4:	55                   	push   %ebp
 ac5:	89 e5                	mov    %esp,%ebp
 ac7:	56                   	push   %esi
 ac8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 ac9:	83 ec 08             	sub    $0x8,%esp
 acc:	6a 00                	push   $0x0
 ace:	ff 75 08             	push   0x8(%ebp)
 ad1:	e8 d0 00 00 00       	call   ba6 <open>
  if(fd < 0)
 ad6:	83 c4 10             	add    $0x10,%esp
 ad9:	85 c0                	test   %eax,%eax
 adb:	78 24                	js     b01 <stat+0x3d>
 add:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 adf:	83 ec 08             	sub    $0x8,%esp
 ae2:	ff 75 0c             	push   0xc(%ebp)
 ae5:	50                   	push   %eax
 ae6:	e8 d3 00 00 00       	call   bbe <fstat>
 aeb:	89 c6                	mov    %eax,%esi
  close(fd);
 aed:	89 1c 24             	mov    %ebx,(%esp)
 af0:	e8 99 00 00 00       	call   b8e <close>
  return r;
 af5:	83 c4 10             	add    $0x10,%esp
}
 af8:	89 f0                	mov    %esi,%eax
 afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
 afd:	5b                   	pop    %ebx
 afe:	5e                   	pop    %esi
 aff:	5d                   	pop    %ebp
 b00:	c3                   	ret    
    return -1;
 b01:	be ff ff ff ff       	mov    $0xffffffff,%esi
 b06:	eb f0                	jmp    af8 <stat+0x34>

00000b08 <atoi>:

int
atoi(const char *s)
{
 b08:	55                   	push   %ebp
 b09:	89 e5                	mov    %esp,%ebp
 b0b:	53                   	push   %ebx
 b0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 b14:	eb 0e                	jmp    b24 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 b16:	8d 14 92             	lea    (%edx,%edx,4),%edx
 b19:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 b1c:	41                   	inc    %ecx
 b1d:	0f be c0             	movsbl %al,%eax
 b20:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 b24:	8a 01                	mov    (%ecx),%al
 b26:	8d 58 d0             	lea    -0x30(%eax),%ebx
 b29:	80 fb 09             	cmp    $0x9,%bl
 b2c:	76 e8                	jbe    b16 <atoi+0xe>
  return n;
}
 b2e:	89 d0                	mov    %edx,%eax
 b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b33:	c9                   	leave  
 b34:	c3                   	ret    

00000b35 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 b35:	55                   	push   %ebp
 b36:	89 e5                	mov    %esp,%ebp
 b38:	56                   	push   %esi
 b39:	53                   	push   %ebx
 b3a:	8b 45 08             	mov    0x8(%ebp),%eax
 b3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 b40:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 b43:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 b45:	eb 0c                	jmp    b53 <memmove+0x1e>
    *dst++ = *src++;
 b47:	8a 13                	mov    (%ebx),%dl
 b49:	88 11                	mov    %dl,(%ecx)
 b4b:	8d 5b 01             	lea    0x1(%ebx),%ebx
 b4e:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 b51:	89 f2                	mov    %esi,%edx
 b53:	8d 72 ff             	lea    -0x1(%edx),%esi
 b56:	85 d2                	test   %edx,%edx
 b58:	7f ed                	jg     b47 <memmove+0x12>
  return vdst;
}
 b5a:	5b                   	pop    %ebx
 b5b:	5e                   	pop    %esi
 b5c:	5d                   	pop    %ebp
 b5d:	c3                   	ret    

00000b5e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 b5e:	b8 01 00 00 00       	mov    $0x1,%eax
 b63:	cd 40                	int    $0x40
 b65:	c3                   	ret    

00000b66 <exit>:
SYSCALL(exit)
 b66:	b8 02 00 00 00       	mov    $0x2,%eax
 b6b:	cd 40                	int    $0x40
 b6d:	c3                   	ret    

00000b6e <wait>:
SYSCALL(wait)
 b6e:	b8 03 00 00 00       	mov    $0x3,%eax
 b73:	cd 40                	int    $0x40
 b75:	c3                   	ret    

00000b76 <pipe>:
SYSCALL(pipe)
 b76:	b8 04 00 00 00       	mov    $0x4,%eax
 b7b:	cd 40                	int    $0x40
 b7d:	c3                   	ret    

00000b7e <read>:
SYSCALL(read)
 b7e:	b8 05 00 00 00       	mov    $0x5,%eax
 b83:	cd 40                	int    $0x40
 b85:	c3                   	ret    

00000b86 <write>:
SYSCALL(write)
 b86:	b8 10 00 00 00       	mov    $0x10,%eax
 b8b:	cd 40                	int    $0x40
 b8d:	c3                   	ret    

00000b8e <close>:
SYSCALL(close)
 b8e:	b8 15 00 00 00       	mov    $0x15,%eax
 b93:	cd 40                	int    $0x40
 b95:	c3                   	ret    

00000b96 <kill>:
SYSCALL(kill)
 b96:	b8 06 00 00 00       	mov    $0x6,%eax
 b9b:	cd 40                	int    $0x40
 b9d:	c3                   	ret    

00000b9e <exec>:
SYSCALL(exec)
 b9e:	b8 07 00 00 00       	mov    $0x7,%eax
 ba3:	cd 40                	int    $0x40
 ba5:	c3                   	ret    

00000ba6 <open>:
SYSCALL(open)
 ba6:	b8 0f 00 00 00       	mov    $0xf,%eax
 bab:	cd 40                	int    $0x40
 bad:	c3                   	ret    

00000bae <mknod>:
SYSCALL(mknod)
 bae:	b8 11 00 00 00       	mov    $0x11,%eax
 bb3:	cd 40                	int    $0x40
 bb5:	c3                   	ret    

00000bb6 <unlink>:
SYSCALL(unlink)
 bb6:	b8 12 00 00 00       	mov    $0x12,%eax
 bbb:	cd 40                	int    $0x40
 bbd:	c3                   	ret    

00000bbe <fstat>:
SYSCALL(fstat)
 bbe:	b8 08 00 00 00       	mov    $0x8,%eax
 bc3:	cd 40                	int    $0x40
 bc5:	c3                   	ret    

00000bc6 <link>:
SYSCALL(link)
 bc6:	b8 13 00 00 00       	mov    $0x13,%eax
 bcb:	cd 40                	int    $0x40
 bcd:	c3                   	ret    

00000bce <mkdir>:
SYSCALL(mkdir)
 bce:	b8 14 00 00 00       	mov    $0x14,%eax
 bd3:	cd 40                	int    $0x40
 bd5:	c3                   	ret    

00000bd6 <chdir>:
SYSCALL(chdir)
 bd6:	b8 09 00 00 00       	mov    $0x9,%eax
 bdb:	cd 40                	int    $0x40
 bdd:	c3                   	ret    

00000bde <dup>:
SYSCALL(dup)
 bde:	b8 0a 00 00 00       	mov    $0xa,%eax
 be3:	cd 40                	int    $0x40
 be5:	c3                   	ret    

00000be6 <dup2>:
SYSCALL(dup2)
 be6:	b8 17 00 00 00       	mov    $0x17,%eax
 beb:	cd 40                	int    $0x40
 bed:	c3                   	ret    

00000bee <getpid>:
SYSCALL(getpid)
 bee:	b8 0b 00 00 00       	mov    $0xb,%eax
 bf3:	cd 40                	int    $0x40
 bf5:	c3                   	ret    

00000bf6 <sbrk>:
SYSCALL(sbrk)
 bf6:	b8 0c 00 00 00       	mov    $0xc,%eax
 bfb:	cd 40                	int    $0x40
 bfd:	c3                   	ret    

00000bfe <sleep>:
SYSCALL(sleep)
 bfe:	b8 0d 00 00 00       	mov    $0xd,%eax
 c03:	cd 40                	int    $0x40
 c05:	c3                   	ret    

00000c06 <uptime>:
SYSCALL(uptime)
 c06:	b8 0e 00 00 00       	mov    $0xe,%eax
 c0b:	cd 40                	int    $0x40
 c0d:	c3                   	ret    

00000c0e <date>:
SYSCALL(date)
 c0e:	b8 16 00 00 00       	mov    $0x16,%eax
 c13:	cd 40                	int    $0x40
 c15:	c3                   	ret    

00000c16 <getprio>:
SYSCALL(getprio)
 c16:	b8 18 00 00 00       	mov    $0x18,%eax
 c1b:	cd 40                	int    $0x40
 c1d:	c3                   	ret    

00000c1e <setprio>:
SYSCALL(setprio)
 c1e:	b8 19 00 00 00       	mov    $0x19,%eax
 c23:	cd 40                	int    $0x40
 c25:	c3                   	ret    

00000c26 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 c26:	55                   	push   %ebp
 c27:	89 e5                	mov    %esp,%ebp
 c29:	83 ec 1c             	sub    $0x1c,%esp
 c2c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 c2f:	6a 01                	push   $0x1
 c31:	8d 55 f4             	lea    -0xc(%ebp),%edx
 c34:	52                   	push   %edx
 c35:	50                   	push   %eax
 c36:	e8 4b ff ff ff       	call   b86 <write>
}
 c3b:	83 c4 10             	add    $0x10,%esp
 c3e:	c9                   	leave  
 c3f:	c3                   	ret    

00000c40 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 c40:	55                   	push   %ebp
 c41:	89 e5                	mov    %esp,%ebp
 c43:	57                   	push   %edi
 c44:	56                   	push   %esi
 c45:	53                   	push   %ebx
 c46:	83 ec 2c             	sub    $0x2c,%esp
 c49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 c4c:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c52:	74 04                	je     c58 <printint+0x18>
 c54:	85 d2                	test   %edx,%edx
 c56:	78 3c                	js     c94 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 c58:	89 d1                	mov    %edx,%ecx
  neg = 0;
 c5a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 c61:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 c66:	89 c8                	mov    %ecx,%eax
 c68:	ba 00 00 00 00       	mov    $0x0,%edx
 c6d:	f7 f6                	div    %esi
 c6f:	89 df                	mov    %ebx,%edi
 c71:	43                   	inc    %ebx
 c72:	8a 92 b8 10 00 00    	mov    0x10b8(%edx),%dl
 c78:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 c7c:	89 ca                	mov    %ecx,%edx
 c7e:	89 c1                	mov    %eax,%ecx
 c80:	39 d6                	cmp    %edx,%esi
 c82:	76 e2                	jbe    c66 <printint+0x26>
  if(neg)
 c84:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 c88:	74 24                	je     cae <printint+0x6e>
    buf[i++] = '-';
 c8a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 c8f:	8d 5f 02             	lea    0x2(%edi),%ebx
 c92:	eb 1a                	jmp    cae <printint+0x6e>
    x = -xx;
 c94:	89 d1                	mov    %edx,%ecx
 c96:	f7 d9                	neg    %ecx
    neg = 1;
 c98:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 c9f:	eb c0                	jmp    c61 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 ca1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 ca6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 ca9:	e8 78 ff ff ff       	call   c26 <putc>
  while(--i >= 0)
 cae:	4b                   	dec    %ebx
 caf:	79 f0                	jns    ca1 <printint+0x61>
}
 cb1:	83 c4 2c             	add    $0x2c,%esp
 cb4:	5b                   	pop    %ebx
 cb5:	5e                   	pop    %esi
 cb6:	5f                   	pop    %edi
 cb7:	5d                   	pop    %ebp
 cb8:	c3                   	ret    

00000cb9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 cb9:	55                   	push   %ebp
 cba:	89 e5                	mov    %esp,%ebp
 cbc:	57                   	push   %edi
 cbd:	56                   	push   %esi
 cbe:	53                   	push   %ebx
 cbf:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 cc2:	8d 45 10             	lea    0x10(%ebp),%eax
 cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 cc8:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
 cd2:	eb 12                	jmp    ce6 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 cd4:	89 fa                	mov    %edi,%edx
 cd6:	8b 45 08             	mov    0x8(%ebp),%eax
 cd9:	e8 48 ff ff ff       	call   c26 <putc>
 cde:	eb 05                	jmp    ce5 <printf+0x2c>
      }
    } else if(state == '%'){
 ce0:	83 fe 25             	cmp    $0x25,%esi
 ce3:	74 22                	je     d07 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 ce5:	43                   	inc    %ebx
 ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
 ce9:	8a 04 18             	mov    (%eax,%ebx,1),%al
 cec:	84 c0                	test   %al,%al
 cee:	0f 84 1d 01 00 00    	je     e11 <printf+0x158>
    c = fmt[i] & 0xff;
 cf4:	0f be f8             	movsbl %al,%edi
 cf7:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 cfa:	85 f6                	test   %esi,%esi
 cfc:	75 e2                	jne    ce0 <printf+0x27>
      if(c == '%'){
 cfe:	83 f8 25             	cmp    $0x25,%eax
 d01:	75 d1                	jne    cd4 <printf+0x1b>
        state = '%';
 d03:	89 c6                	mov    %eax,%esi
 d05:	eb de                	jmp    ce5 <printf+0x2c>
      if(c == 'd'){
 d07:	83 f8 25             	cmp    $0x25,%eax
 d0a:	0f 84 cc 00 00 00    	je     ddc <printf+0x123>
 d10:	0f 8c da 00 00 00    	jl     df0 <printf+0x137>
 d16:	83 f8 78             	cmp    $0x78,%eax
 d19:	0f 8f d1 00 00 00    	jg     df0 <printf+0x137>
 d1f:	83 f8 63             	cmp    $0x63,%eax
 d22:	0f 8c c8 00 00 00    	jl     df0 <printf+0x137>
 d28:	83 e8 63             	sub    $0x63,%eax
 d2b:	83 f8 15             	cmp    $0x15,%eax
 d2e:	0f 87 bc 00 00 00    	ja     df0 <printf+0x137>
 d34:	ff 24 85 60 10 00 00 	jmp    *0x1060(,%eax,4)
        printint(fd, *ap, 10, 1);
 d3b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 d3e:	8b 17                	mov    (%edi),%edx
 d40:	83 ec 0c             	sub    $0xc,%esp
 d43:	6a 01                	push   $0x1
 d45:	b9 0a 00 00 00       	mov    $0xa,%ecx
 d4a:	8b 45 08             	mov    0x8(%ebp),%eax
 d4d:	e8 ee fe ff ff       	call   c40 <printint>
        ap++;
 d52:	83 c7 04             	add    $0x4,%edi
 d55:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 d58:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d5b:	be 00 00 00 00       	mov    $0x0,%esi
 d60:	eb 83                	jmp    ce5 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 d62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 d65:	8b 17                	mov    (%edi),%edx
 d67:	83 ec 0c             	sub    $0xc,%esp
 d6a:	6a 00                	push   $0x0
 d6c:	b9 10 00 00 00       	mov    $0x10,%ecx
 d71:	8b 45 08             	mov    0x8(%ebp),%eax
 d74:	e8 c7 fe ff ff       	call   c40 <printint>
        ap++;
 d79:	83 c7 04             	add    $0x4,%edi
 d7c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 d7f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d82:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 d87:	e9 59 ff ff ff       	jmp    ce5 <printf+0x2c>
        s = (char*)*ap;
 d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 d8f:	8b 30                	mov    (%eax),%esi
        ap++;
 d91:	83 c0 04             	add    $0x4,%eax
 d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 d97:	85 f6                	test   %esi,%esi
 d99:	75 13                	jne    dae <printf+0xf5>
          s = "(null)";
 d9b:	be 58 10 00 00       	mov    $0x1058,%esi
 da0:	eb 0c                	jmp    dae <printf+0xf5>
          putc(fd, *s);
 da2:	0f be d2             	movsbl %dl,%edx
 da5:	8b 45 08             	mov    0x8(%ebp),%eax
 da8:	e8 79 fe ff ff       	call   c26 <putc>
          s++;
 dad:	46                   	inc    %esi
        while(*s != 0){
 dae:	8a 16                	mov    (%esi),%dl
 db0:	84 d2                	test   %dl,%dl
 db2:	75 ee                	jne    da2 <printf+0xe9>
      state = 0;
 db4:	be 00 00 00 00       	mov    $0x0,%esi
 db9:	e9 27 ff ff ff       	jmp    ce5 <printf+0x2c>
        putc(fd, *ap);
 dbe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 dc1:	0f be 17             	movsbl (%edi),%edx
 dc4:	8b 45 08             	mov    0x8(%ebp),%eax
 dc7:	e8 5a fe ff ff       	call   c26 <putc>
        ap++;
 dcc:	83 c7 04             	add    $0x4,%edi
 dcf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 dd2:	be 00 00 00 00       	mov    $0x0,%esi
 dd7:	e9 09 ff ff ff       	jmp    ce5 <printf+0x2c>
        putc(fd, c);
 ddc:	89 fa                	mov    %edi,%edx
 dde:	8b 45 08             	mov    0x8(%ebp),%eax
 de1:	e8 40 fe ff ff       	call   c26 <putc>
      state = 0;
 de6:	be 00 00 00 00       	mov    $0x0,%esi
 deb:	e9 f5 fe ff ff       	jmp    ce5 <printf+0x2c>
        putc(fd, '%');
 df0:	ba 25 00 00 00       	mov    $0x25,%edx
 df5:	8b 45 08             	mov    0x8(%ebp),%eax
 df8:	e8 29 fe ff ff       	call   c26 <putc>
        putc(fd, c);
 dfd:	89 fa                	mov    %edi,%edx
 dff:	8b 45 08             	mov    0x8(%ebp),%eax
 e02:	e8 1f fe ff ff       	call   c26 <putc>
      state = 0;
 e07:	be 00 00 00 00       	mov    $0x0,%esi
 e0c:	e9 d4 fe ff ff       	jmp    ce5 <printf+0x2c>
    }
  }
}
 e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
 e14:	5b                   	pop    %ebx
 e15:	5e                   	pop    %esi
 e16:	5f                   	pop    %edi
 e17:	5d                   	pop    %ebp
 e18:	c3                   	ret    

00000e19 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e19:	55                   	push   %ebp
 e1a:	89 e5                	mov    %esp,%ebp
 e1c:	57                   	push   %edi
 e1d:	56                   	push   %esi
 e1e:	53                   	push   %ebx
 e1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e22:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e25:	a1 c4 16 00 00       	mov    0x16c4,%eax
 e2a:	eb 02                	jmp    e2e <free+0x15>
 e2c:	89 d0                	mov    %edx,%eax
 e2e:	39 c8                	cmp    %ecx,%eax
 e30:	73 04                	jae    e36 <free+0x1d>
 e32:	39 08                	cmp    %ecx,(%eax)
 e34:	77 12                	ja     e48 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e36:	8b 10                	mov    (%eax),%edx
 e38:	39 c2                	cmp    %eax,%edx
 e3a:	77 f0                	ja     e2c <free+0x13>
 e3c:	39 c8                	cmp    %ecx,%eax
 e3e:	72 08                	jb     e48 <free+0x2f>
 e40:	39 ca                	cmp    %ecx,%edx
 e42:	77 04                	ja     e48 <free+0x2f>
 e44:	89 d0                	mov    %edx,%eax
 e46:	eb e6                	jmp    e2e <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 e48:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e4b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e4e:	8b 10                	mov    (%eax),%edx
 e50:	39 d7                	cmp    %edx,%edi
 e52:	74 19                	je     e6d <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 e54:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e57:	8b 50 04             	mov    0x4(%eax),%edx
 e5a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e5d:	39 ce                	cmp    %ecx,%esi
 e5f:	74 1b                	je     e7c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 e61:	89 08                	mov    %ecx,(%eax)
  freep = p;
 e63:	a3 c4 16 00 00       	mov    %eax,0x16c4
}
 e68:	5b                   	pop    %ebx
 e69:	5e                   	pop    %esi
 e6a:	5f                   	pop    %edi
 e6b:	5d                   	pop    %ebp
 e6c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 e6d:	03 72 04             	add    0x4(%edx),%esi
 e70:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e73:	8b 10                	mov    (%eax),%edx
 e75:	8b 12                	mov    (%edx),%edx
 e77:	89 53 f8             	mov    %edx,-0x8(%ebx)
 e7a:	eb db                	jmp    e57 <free+0x3e>
    p->s.size += bp->s.size;
 e7c:	03 53 fc             	add    -0x4(%ebx),%edx
 e7f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e82:	8b 53 f8             	mov    -0x8(%ebx),%edx
 e85:	89 10                	mov    %edx,(%eax)
 e87:	eb da                	jmp    e63 <free+0x4a>

00000e89 <morecore>:

static Header*
morecore(uint nu)
{
 e89:	55                   	push   %ebp
 e8a:	89 e5                	mov    %esp,%ebp
 e8c:	53                   	push   %ebx
 e8d:	83 ec 04             	sub    $0x4,%esp
 e90:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 e92:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 e97:	77 05                	ja     e9e <morecore+0x15>
    nu = 4096;
 e99:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 e9e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 ea5:	83 ec 0c             	sub    $0xc,%esp
 ea8:	50                   	push   %eax
 ea9:	e8 48 fd ff ff       	call   bf6 <sbrk>
  if(p == (char*)-1)
 eae:	83 c4 10             	add    $0x10,%esp
 eb1:	83 f8 ff             	cmp    $0xffffffff,%eax
 eb4:	74 1c                	je     ed2 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 eb6:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 eb9:	83 c0 08             	add    $0x8,%eax
 ebc:	83 ec 0c             	sub    $0xc,%esp
 ebf:	50                   	push   %eax
 ec0:	e8 54 ff ff ff       	call   e19 <free>
  return freep;
 ec5:	a1 c4 16 00 00       	mov    0x16c4,%eax
 eca:	83 c4 10             	add    $0x10,%esp
}
 ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 ed0:	c9                   	leave  
 ed1:	c3                   	ret    
    return 0;
 ed2:	b8 00 00 00 00       	mov    $0x0,%eax
 ed7:	eb f4                	jmp    ecd <morecore+0x44>

00000ed9 <malloc>:

void*
malloc(uint nbytes)
{
 ed9:	55                   	push   %ebp
 eda:	89 e5                	mov    %esp,%ebp
 edc:	53                   	push   %ebx
 edd:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ee0:	8b 45 08             	mov    0x8(%ebp),%eax
 ee3:	8d 58 07             	lea    0x7(%eax),%ebx
 ee6:	c1 eb 03             	shr    $0x3,%ebx
 ee9:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 eea:	8b 0d c4 16 00 00    	mov    0x16c4,%ecx
 ef0:	85 c9                	test   %ecx,%ecx
 ef2:	74 04                	je     ef8 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ef4:	8b 01                	mov    (%ecx),%eax
 ef6:	eb 4a                	jmp    f42 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 ef8:	c7 05 c4 16 00 00 c8 	movl   $0x16c8,0x16c4
 eff:	16 00 00 
 f02:	c7 05 c8 16 00 00 c8 	movl   $0x16c8,0x16c8
 f09:	16 00 00 
    base.s.size = 0;
 f0c:	c7 05 cc 16 00 00 00 	movl   $0x0,0x16cc
 f13:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 f16:	b9 c8 16 00 00       	mov    $0x16c8,%ecx
 f1b:	eb d7                	jmp    ef4 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 f1d:	74 19                	je     f38 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f1f:	29 da                	sub    %ebx,%edx
 f21:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 f24:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 f27:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 f2a:	89 0d c4 16 00 00    	mov    %ecx,0x16c4
      return (void*)(p + 1);
 f30:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 f36:	c9                   	leave  
 f37:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 f38:	8b 10                	mov    (%eax),%edx
 f3a:	89 11                	mov    %edx,(%ecx)
 f3c:	eb ec                	jmp    f2a <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f3e:	89 c1                	mov    %eax,%ecx
 f40:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 f42:	8b 50 04             	mov    0x4(%eax),%edx
 f45:	39 da                	cmp    %ebx,%edx
 f47:	73 d4                	jae    f1d <malloc+0x44>
    if(p == freep)
 f49:	39 05 c4 16 00 00    	cmp    %eax,0x16c4
 f4f:	75 ed                	jne    f3e <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 f51:	89 d8                	mov    %ebx,%eax
 f53:	e8 31 ff ff ff       	call   e89 <morecore>
 f58:	85 c0                	test   %eax,%eax
 f5a:	75 e2                	jne    f3e <malloc+0x65>
 f5c:	eb d5                	jmp    f33 <malloc+0x5a>
