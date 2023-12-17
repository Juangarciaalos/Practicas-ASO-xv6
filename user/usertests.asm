
usertests:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
       7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       a:	68 8a 41 00 00       	push   $0x418a
       f:	ff 35 40 61 00 00    	pushl  0x6140
      15:	e8 2b 3e 00 00       	call   3e45 <printf>

  if(mkdir("iputdir") < 0){
      1a:	c7 04 24 1d 41 00 00 	movl   $0x411d,(%esp)
      21:	e8 38 3d 00 00       	call   3d5e <mkdir>
      26:	83 c4 10             	add    $0x10,%esp
      29:	85 c0                	test   %eax,%eax
      2b:	78 54                	js     81 <iputtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit(0);
  }
  if(chdir("iputdir") < 0){
      2d:	83 ec 0c             	sub    $0xc,%esp
      30:	68 1d 41 00 00       	push   $0x411d
      35:	e8 2c 3d 00 00       	call   3d66 <chdir>
      3a:	83 c4 10             	add    $0x10,%esp
      3d:	85 c0                	test   %eax,%eax
      3f:	78 5f                	js     a0 <iputtest+0xa0>
    printf(stdout, "chdir iputdir failed\n");
    exit(0);
  }
  if(unlink("../iputdir") < 0){
      41:	83 ec 0c             	sub    $0xc,%esp
      44:	68 1a 41 00 00       	push   $0x411a
      49:	e8 f8 3c 00 00       	call   3d46 <unlink>
      4e:	83 c4 10             	add    $0x10,%esp
      51:	85 c0                	test   %eax,%eax
      53:	78 6a                	js     bf <iputtest+0xbf>
    printf(stdout, "unlink ../iputdir failed\n");
    exit(0);
  }
  if(chdir("/") < 0){
      55:	83 ec 0c             	sub    $0xc,%esp
      58:	68 3f 41 00 00       	push   $0x413f
      5d:	e8 04 3d 00 00       	call   3d66 <chdir>
      62:	83 c4 10             	add    $0x10,%esp
      65:	85 c0                	test   %eax,%eax
      67:	78 75                	js     de <iputtest+0xde>
    printf(stdout, "chdir / failed\n");
    exit(0);
  }
  printf(stdout, "iput test ok\n");
      69:	83 ec 08             	sub    $0x8,%esp
      6c:	68 c2 41 00 00       	push   $0x41c2
      71:	ff 35 40 61 00 00    	pushl  0x6140
      77:	e8 c9 3d 00 00       	call   3e45 <printf>
}
      7c:	83 c4 10             	add    $0x10,%esp
      7f:	c9                   	leave  
      80:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      81:	83 ec 08             	sub    $0x8,%esp
      84:	68 f6 40 00 00       	push   $0x40f6
      89:	ff 35 40 61 00 00    	pushl  0x6140
      8f:	e8 b1 3d 00 00       	call   3e45 <printf>
    exit(0);
      94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      9b:	e8 56 3c 00 00       	call   3cf6 <exit>
    printf(stdout, "chdir iputdir failed\n");
      a0:	83 ec 08             	sub    $0x8,%esp
      a3:	68 04 41 00 00       	push   $0x4104
      a8:	ff 35 40 61 00 00    	pushl  0x6140
      ae:	e8 92 3d 00 00       	call   3e45 <printf>
    exit(0);
      b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      ba:	e8 37 3c 00 00       	call   3cf6 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      bf:	83 ec 08             	sub    $0x8,%esp
      c2:	68 25 41 00 00       	push   $0x4125
      c7:	ff 35 40 61 00 00    	pushl  0x6140
      cd:	e8 73 3d 00 00       	call   3e45 <printf>
    exit(0);
      d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      d9:	e8 18 3c 00 00       	call   3cf6 <exit>
    printf(stdout, "chdir / failed\n");
      de:	83 ec 08             	sub    $0x8,%esp
      e1:	68 41 41 00 00       	push   $0x4141
      e6:	ff 35 40 61 00 00    	pushl  0x6140
      ec:	e8 54 3d 00 00       	call   3e45 <printf>
    exit(0);
      f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      f8:	e8 f9 3b 00 00       	call   3cf6 <exit>

000000fd <exitiputtest>:

// does exit(0) call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      fd:	f3 0f 1e fb          	endbr32 
     101:	55                   	push   %ebp
     102:	89 e5                	mov    %esp,%ebp
     104:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
     107:	68 51 41 00 00       	push   $0x4151
     10c:	ff 35 40 61 00 00    	pushl  0x6140
     112:	e8 2e 3d 00 00       	call   3e45 <printf>

  pid = fork();
     117:	e8 d2 3b 00 00       	call   3cee <fork>
  if(pid < 0){
     11c:	83 c4 10             	add    $0x10,%esp
     11f:	85 c0                	test   %eax,%eax
     121:	78 4c                	js     16f <exitiputtest+0x72>
    printf(stdout, "fork failed\n");
    exit(0);
  }
  if(pid == 0){
     123:	0f 85 c2 00 00 00    	jne    1eb <exitiputtest+0xee>
    if(mkdir("iputdir") < 0){
     129:	83 ec 0c             	sub    $0xc,%esp
     12c:	68 1d 41 00 00       	push   $0x411d
     131:	e8 28 3c 00 00       	call   3d5e <mkdir>
     136:	83 c4 10             	add    $0x10,%esp
     139:	85 c0                	test   %eax,%eax
     13b:	78 51                	js     18e <exitiputtest+0x91>
      printf(stdout, "mkdir failed\n");
      exit(0);
    }
    if(chdir("iputdir") < 0){
     13d:	83 ec 0c             	sub    $0xc,%esp
     140:	68 1d 41 00 00       	push   $0x411d
     145:	e8 1c 3c 00 00       	call   3d66 <chdir>
     14a:	83 c4 10             	add    $0x10,%esp
     14d:	85 c0                	test   %eax,%eax
     14f:	78 5c                	js     1ad <exitiputtest+0xb0>
      printf(stdout, "child chdir failed\n");
      exit(0);
    }
    if(unlink("../iputdir") < 0){
     151:	83 ec 0c             	sub    $0xc,%esp
     154:	68 1a 41 00 00       	push   $0x411a
     159:	e8 e8 3b 00 00       	call   3d46 <unlink>
     15e:	83 c4 10             	add    $0x10,%esp
     161:	85 c0                	test   %eax,%eax
     163:	78 67                	js     1cc <exitiputtest+0xcf>
      printf(stdout, "unlink ../iputdir failed\n");
      exit(0);
    }
    exit(0);
     165:	83 ec 0c             	sub    $0xc,%esp
     168:	6a 00                	push   $0x0
     16a:	e8 87 3b 00 00       	call   3cf6 <exit>
    printf(stdout, "fork failed\n");
     16f:	83 ec 08             	sub    $0x8,%esp
     172:	68 31 50 00 00       	push   $0x5031
     177:	ff 35 40 61 00 00    	pushl  0x6140
     17d:	e8 c3 3c 00 00       	call   3e45 <printf>
    exit(0);
     182:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     189:	e8 68 3b 00 00       	call   3cf6 <exit>
      printf(stdout, "mkdir failed\n");
     18e:	83 ec 08             	sub    $0x8,%esp
     191:	68 f6 40 00 00       	push   $0x40f6
     196:	ff 35 40 61 00 00    	pushl  0x6140
     19c:	e8 a4 3c 00 00       	call   3e45 <printf>
      exit(0);
     1a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1a8:	e8 49 3b 00 00       	call   3cf6 <exit>
      printf(stdout, "child chdir failed\n");
     1ad:	83 ec 08             	sub    $0x8,%esp
     1b0:	68 60 41 00 00       	push   $0x4160
     1b5:	ff 35 40 61 00 00    	pushl  0x6140
     1bb:	e8 85 3c 00 00       	call   3e45 <printf>
      exit(0);
     1c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1c7:	e8 2a 3b 00 00       	call   3cf6 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     1cc:	83 ec 08             	sub    $0x8,%esp
     1cf:	68 25 41 00 00       	push   $0x4125
     1d4:	ff 35 40 61 00 00    	pushl  0x6140
     1da:	e8 66 3c 00 00       	call   3e45 <printf>
      exit(0);
     1df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1e6:	e8 0b 3b 00 00       	call   3cf6 <exit>
  }
  wait(NULL);
     1eb:	83 ec 0c             	sub    $0xc,%esp
     1ee:	6a 00                	push   $0x0
     1f0:	e8 09 3b 00 00       	call   3cfe <wait>
  printf(stdout, "exitiput test ok\n");
     1f5:	83 c4 08             	add    $0x8,%esp
     1f8:	68 74 41 00 00       	push   $0x4174
     1fd:	ff 35 40 61 00 00    	pushl  0x6140
     203:	e8 3d 3c 00 00       	call   3e45 <printf>
}
     208:	83 c4 10             	add    $0x10,%esp
     20b:	c9                   	leave  
     20c:	c3                   	ret    

0000020d <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     20d:	f3 0f 1e fb          	endbr32 
     211:	55                   	push   %ebp
     212:	89 e5                	mov    %esp,%ebp
     214:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     217:	68 86 41 00 00       	push   $0x4186
     21c:	ff 35 40 61 00 00    	pushl  0x6140
     222:	e8 1e 3c 00 00       	call   3e45 <printf>
  if(mkdir("oidir") < 0){
     227:	c7 04 24 95 41 00 00 	movl   $0x4195,(%esp)
     22e:	e8 2b 3b 00 00       	call   3d5e <mkdir>
     233:	83 c4 10             	add    $0x10,%esp
     236:	85 c0                	test   %eax,%eax
     238:	78 40                	js     27a <openiputtest+0x6d>
    printf(stdout, "mkdir oidir failed\n");
    exit(0);
  }
  pid = fork();
     23a:	e8 af 3a 00 00       	call   3cee <fork>
  if(pid < 0){
     23f:	85 c0                	test   %eax,%eax
     241:	78 56                	js     299 <openiputtest+0x8c>
    printf(stdout, "fork failed\n");
    exit(0);
  }
  if(pid == 0){
     243:	75 7d                	jne    2c2 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     245:	83 ec 08             	sub    $0x8,%esp
     248:	6a 02                	push   $0x2
     24a:	68 95 41 00 00       	push   $0x4195
     24f:	e8 e2 3a 00 00       	call   3d36 <open>
    if(fd >= 0){
     254:	83 c4 10             	add    $0x10,%esp
     257:	85 c0                	test   %eax,%eax
     259:	78 5d                	js     2b8 <openiputtest+0xab>
      printf(stdout, "open directory for write succeeded\n");
     25b:	83 ec 08             	sub    $0x8,%esp
     25e:	68 14 51 00 00       	push   $0x5114
     263:	ff 35 40 61 00 00    	pushl  0x6140
     269:	e8 d7 3b 00 00       	call   3e45 <printf>
      exit(0);
     26e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     275:	e8 7c 3a 00 00       	call   3cf6 <exit>
    printf(stdout, "mkdir oidir failed\n");
     27a:	83 ec 08             	sub    $0x8,%esp
     27d:	68 9b 41 00 00       	push   $0x419b
     282:	ff 35 40 61 00 00    	pushl  0x6140
     288:	e8 b8 3b 00 00       	call   3e45 <printf>
    exit(0);
     28d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     294:	e8 5d 3a 00 00       	call   3cf6 <exit>
    printf(stdout, "fork failed\n");
     299:	83 ec 08             	sub    $0x8,%esp
     29c:	68 31 50 00 00       	push   $0x5031
     2a1:	ff 35 40 61 00 00    	pushl  0x6140
     2a7:	e8 99 3b 00 00       	call   3e45 <printf>
    exit(0);
     2ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2b3:	e8 3e 3a 00 00       	call   3cf6 <exit>
    }
    exit(0);
     2b8:	83 ec 0c             	sub    $0xc,%esp
     2bb:	6a 00                	push   $0x0
     2bd:	e8 34 3a 00 00       	call   3cf6 <exit>
  }
  sleep(1);
     2c2:	83 ec 0c             	sub    $0xc,%esp
     2c5:	6a 01                	push   $0x1
     2c7:	e8 c2 3a 00 00       	call   3d8e <sleep>
  if(unlink("oidir") != 0){
     2cc:	c7 04 24 95 41 00 00 	movl   $0x4195,(%esp)
     2d3:	e8 6e 3a 00 00       	call   3d46 <unlink>
     2d8:	83 c4 10             	add    $0x10,%esp
     2db:	85 c0                	test   %eax,%eax
     2dd:	75 22                	jne    301 <openiputtest+0xf4>
    printf(stdout, "unlink failed\n");
    exit(0);
  }
  wait(NULL);
     2df:	83 ec 0c             	sub    $0xc,%esp
     2e2:	6a 00                	push   $0x0
     2e4:	e8 15 3a 00 00       	call   3cfe <wait>
  printf(stdout, "openiput test ok\n");
     2e9:	83 c4 08             	add    $0x8,%esp
     2ec:	68 be 41 00 00       	push   $0x41be
     2f1:	ff 35 40 61 00 00    	pushl  0x6140
     2f7:	e8 49 3b 00 00       	call   3e45 <printf>
}
     2fc:	83 c4 10             	add    $0x10,%esp
     2ff:	c9                   	leave  
     300:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     301:	83 ec 08             	sub    $0x8,%esp
     304:	68 af 41 00 00       	push   $0x41af
     309:	ff 35 40 61 00 00    	pushl  0x6140
     30f:	e8 31 3b 00 00       	call   3e45 <printf>
    exit(0);
     314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     31b:	e8 d6 39 00 00       	call   3cf6 <exit>

00000320 <opentest>:

// simple file system tests

void
opentest(void)
{
     320:	f3 0f 1e fb          	endbr32 
     324:	55                   	push   %ebp
     325:	89 e5                	mov    %esp,%ebp
     327:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     32a:	68 d0 41 00 00       	push   $0x41d0
     32f:	ff 35 40 61 00 00    	pushl  0x6140
     335:	e8 0b 3b 00 00       	call   3e45 <printf>
  fd = open("echo", 0);
     33a:	83 c4 08             	add    $0x8,%esp
     33d:	6a 00                	push   $0x0
     33f:	68 db 41 00 00       	push   $0x41db
     344:	e8 ed 39 00 00       	call   3d36 <open>
  if(fd < 0){
     349:	83 c4 10             	add    $0x10,%esp
     34c:	85 c0                	test   %eax,%eax
     34e:	78 37                	js     387 <opentest+0x67>
    printf(stdout, "open echo failed!\n");
    exit(0);
  }
  close(fd);
     350:	83 ec 0c             	sub    $0xc,%esp
     353:	50                   	push   %eax
     354:	e8 c5 39 00 00       	call   3d1e <close>
  fd = open("doesnotexist", 0);
     359:	83 c4 08             	add    $0x8,%esp
     35c:	6a 00                	push   $0x0
     35e:	68 f3 41 00 00       	push   $0x41f3
     363:	e8 ce 39 00 00       	call   3d36 <open>
  if(fd >= 0){
     368:	83 c4 10             	add    $0x10,%esp
     36b:	85 c0                	test   %eax,%eax
     36d:	79 37                	jns    3a6 <opentest+0x86>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit(0);
  }
  printf(stdout, "open test ok\n");
     36f:	83 ec 08             	sub    $0x8,%esp
     372:	68 1e 42 00 00       	push   $0x421e
     377:	ff 35 40 61 00 00    	pushl  0x6140
     37d:	e8 c3 3a 00 00       	call   3e45 <printf>
}
     382:	83 c4 10             	add    $0x10,%esp
     385:	c9                   	leave  
     386:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     387:	83 ec 08             	sub    $0x8,%esp
     38a:	68 e0 41 00 00       	push   $0x41e0
     38f:	ff 35 40 61 00 00    	pushl  0x6140
     395:	e8 ab 3a 00 00       	call   3e45 <printf>
    exit(0);
     39a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3a1:	e8 50 39 00 00       	call   3cf6 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     3a6:	83 ec 08             	sub    $0x8,%esp
     3a9:	68 00 42 00 00       	push   $0x4200
     3ae:	ff 35 40 61 00 00    	pushl  0x6140
     3b4:	e8 8c 3a 00 00       	call   3e45 <printf>
    exit(0);
     3b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3c0:	e8 31 39 00 00       	call   3cf6 <exit>

000003c5 <writetest>:

void
writetest(void)
{
     3c5:	f3 0f 1e fb          	endbr32 
     3c9:	55                   	push   %ebp
     3ca:	89 e5                	mov    %esp,%ebp
     3cc:	56                   	push   %esi
     3cd:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3ce:	83 ec 08             	sub    $0x8,%esp
     3d1:	68 2c 42 00 00       	push   $0x422c
     3d6:	ff 35 40 61 00 00    	pushl  0x6140
     3dc:	e8 64 3a 00 00       	call   3e45 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     3e1:	83 c4 08             	add    $0x8,%esp
     3e4:	68 02 02 00 00       	push   $0x202
     3e9:	68 3d 42 00 00       	push   $0x423d
     3ee:	e8 43 39 00 00       	call   3d36 <open>
  if(fd >= 0){
     3f3:	83 c4 10             	add    $0x10,%esp
     3f6:	85 c0                	test   %eax,%eax
     3f8:	78 59                	js     453 <writetest+0x8e>
     3fa:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     3fc:	83 ec 08             	sub    $0x8,%esp
     3ff:	68 43 42 00 00       	push   $0x4243
     404:	ff 35 40 61 00 00    	pushl  0x6140
     40a:	e8 36 3a 00 00       	call   3e45 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit(0);
  }
  for(i = 0; i < 100; i++){
     40f:	83 c4 10             	add    $0x10,%esp
     412:	bb 00 00 00 00       	mov    $0x0,%ebx
     417:	83 fb 63             	cmp    $0x63,%ebx
     41a:	0f 8f 92 00 00 00    	jg     4b2 <writetest+0xed>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     420:	83 ec 04             	sub    $0x4,%esp
     423:	6a 0a                	push   $0xa
     425:	68 7a 42 00 00       	push   $0x427a
     42a:	56                   	push   %esi
     42b:	e8 e6 38 00 00       	call   3d16 <write>
     430:	83 c4 10             	add    $0x10,%esp
     433:	83 f8 0a             	cmp    $0xa,%eax
     436:	75 3a                	jne    472 <writetest+0xad>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit(0);
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     438:	83 ec 04             	sub    $0x4,%esp
     43b:	6a 0a                	push   $0xa
     43d:	68 85 42 00 00       	push   $0x4285
     442:	56                   	push   %esi
     443:	e8 ce 38 00 00       	call   3d16 <write>
     448:	83 c4 10             	add    $0x10,%esp
     44b:	83 f8 0a             	cmp    $0xa,%eax
     44e:	75 42                	jne    492 <writetest+0xcd>
  for(i = 0; i < 100; i++){
     450:	43                   	inc    %ebx
     451:	eb c4                	jmp    417 <writetest+0x52>
    printf(stdout, "error: creat small failed!\n");
     453:	83 ec 08             	sub    $0x8,%esp
     456:	68 5e 42 00 00       	push   $0x425e
     45b:	ff 35 40 61 00 00    	pushl  0x6140
     461:	e8 df 39 00 00       	call   3e45 <printf>
    exit(0);
     466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     46d:	e8 84 38 00 00       	call   3cf6 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     472:	83 ec 04             	sub    $0x4,%esp
     475:	53                   	push   %ebx
     476:	68 38 51 00 00       	push   $0x5138
     47b:	ff 35 40 61 00 00    	pushl  0x6140
     481:	e8 bf 39 00 00       	call   3e45 <printf>
      exit(0);
     486:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     48d:	e8 64 38 00 00       	call   3cf6 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     492:	83 ec 04             	sub    $0x4,%esp
     495:	53                   	push   %ebx
     496:	68 5c 51 00 00       	push   $0x515c
     49b:	ff 35 40 61 00 00    	pushl  0x6140
     4a1:	e8 9f 39 00 00       	call   3e45 <printf>
      exit(0);
     4a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4ad:	e8 44 38 00 00       	call   3cf6 <exit>
    }
  }
  printf(stdout, "writes ok\n");
     4b2:	83 ec 08             	sub    $0x8,%esp
     4b5:	68 90 42 00 00       	push   $0x4290
     4ba:	ff 35 40 61 00 00    	pushl  0x6140
     4c0:	e8 80 39 00 00       	call   3e45 <printf>
  close(fd);
     4c5:	89 34 24             	mov    %esi,(%esp)
     4c8:	e8 51 38 00 00       	call   3d1e <close>
  fd = open("small", O_RDONLY);
     4cd:	83 c4 08             	add    $0x8,%esp
     4d0:	6a 00                	push   $0x0
     4d2:	68 3d 42 00 00       	push   $0x423d
     4d7:	e8 5a 38 00 00       	call   3d36 <open>
     4dc:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     4de:	83 c4 10             	add    $0x10,%esp
     4e1:	85 c0                	test   %eax,%eax
     4e3:	78 7b                	js     560 <writetest+0x19b>
    printf(stdout, "open small succeeded ok\n");
     4e5:	83 ec 08             	sub    $0x8,%esp
     4e8:	68 9b 42 00 00       	push   $0x429b
     4ed:	ff 35 40 61 00 00    	pushl  0x6140
     4f3:	e8 4d 39 00 00       	call   3e45 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit(0);
  }
  i = read(fd, buf, 2000);
     4f8:	83 c4 0c             	add    $0xc,%esp
     4fb:	68 d0 07 00 00       	push   $0x7d0
     500:	68 20 89 00 00       	push   $0x8920
     505:	53                   	push   %ebx
     506:	e8 03 38 00 00       	call   3d0e <read>
  if(i == 2000){
     50b:	83 c4 10             	add    $0x10,%esp
     50e:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     513:	75 6a                	jne    57f <writetest+0x1ba>
    printf(stdout, "read succeeded ok\n");
     515:	83 ec 08             	sub    $0x8,%esp
     518:	68 cf 42 00 00       	push   $0x42cf
     51d:	ff 35 40 61 00 00    	pushl  0x6140
     523:	e8 1d 39 00 00       	call   3e45 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit(0);
  }
  close(fd);
     528:	89 1c 24             	mov    %ebx,(%esp)
     52b:	e8 ee 37 00 00       	call   3d1e <close>

  if(unlink("small") < 0){
     530:	c7 04 24 3d 42 00 00 	movl   $0x423d,(%esp)
     537:	e8 0a 38 00 00       	call   3d46 <unlink>
     53c:	83 c4 10             	add    $0x10,%esp
     53f:	85 c0                	test   %eax,%eax
     541:	78 5b                	js     59e <writetest+0x1d9>
    printf(stdout, "unlink small failed\n");
    exit(0);
  }
  printf(stdout, "small file test ok\n");
     543:	83 ec 08             	sub    $0x8,%esp
     546:	68 f7 42 00 00       	push   $0x42f7
     54b:	ff 35 40 61 00 00    	pushl  0x6140
     551:	e8 ef 38 00 00       	call   3e45 <printf>
}
     556:	83 c4 10             	add    $0x10,%esp
     559:	8d 65 f8             	lea    -0x8(%ebp),%esp
     55c:	5b                   	pop    %ebx
     55d:	5e                   	pop    %esi
     55e:	5d                   	pop    %ebp
     55f:	c3                   	ret    
    printf(stdout, "error: open small failed!\n");
     560:	83 ec 08             	sub    $0x8,%esp
     563:	68 b4 42 00 00       	push   $0x42b4
     568:	ff 35 40 61 00 00    	pushl  0x6140
     56e:	e8 d2 38 00 00       	call   3e45 <printf>
    exit(0);
     573:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     57a:	e8 77 37 00 00       	call   3cf6 <exit>
    printf(stdout, "read failed\n");
     57f:	83 ec 08             	sub    $0x8,%esp
     582:	68 f5 45 00 00       	push   $0x45f5
     587:	ff 35 40 61 00 00    	pushl  0x6140
     58d:	e8 b3 38 00 00       	call   3e45 <printf>
    exit(0);
     592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     599:	e8 58 37 00 00       	call   3cf6 <exit>
    printf(stdout, "unlink small failed\n");
     59e:	83 ec 08             	sub    $0x8,%esp
     5a1:	68 e2 42 00 00       	push   $0x42e2
     5a6:	ff 35 40 61 00 00    	pushl  0x6140
     5ac:	e8 94 38 00 00       	call   3e45 <printf>
    exit(0);
     5b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5b8:	e8 39 37 00 00       	call   3cf6 <exit>

000005bd <writetest1>:

void
writetest1(void)
{
     5bd:	f3 0f 1e fb          	endbr32 
     5c1:	55                   	push   %ebp
     5c2:	89 e5                	mov    %esp,%ebp
     5c4:	56                   	push   %esi
     5c5:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     5c6:	83 ec 08             	sub    $0x8,%esp
     5c9:	68 0b 43 00 00       	push   $0x430b
     5ce:	ff 35 40 61 00 00    	pushl  0x6140
     5d4:	e8 6c 38 00 00       	call   3e45 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5d9:	83 c4 08             	add    $0x8,%esp
     5dc:	68 02 02 00 00       	push   $0x202
     5e1:	68 85 43 00 00       	push   $0x4385
     5e6:	e8 4b 37 00 00       	call   3d36 <open>
  if(fd < 0){
     5eb:	83 c4 10             	add    $0x10,%esp
     5ee:	85 c0                	test   %eax,%eax
     5f0:	78 35                	js     627 <writetest1+0x6a>
     5f2:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit(0);
  }

  for(i = 0; i < MAXFILE; i++){
     5f4:	bb 00 00 00 00       	mov    $0x0,%ebx
     5f9:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     5ff:	77 65                	ja     666 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     601:	89 1d 20 89 00 00    	mov    %ebx,0x8920
    if(write(fd, buf, 512) != 512){
     607:	83 ec 04             	sub    $0x4,%esp
     60a:	68 00 02 00 00       	push   $0x200
     60f:	68 20 89 00 00       	push   $0x8920
     614:	56                   	push   %esi
     615:	e8 fc 36 00 00       	call   3d16 <write>
     61a:	83 c4 10             	add    $0x10,%esp
     61d:	3d 00 02 00 00       	cmp    $0x200,%eax
     622:	75 22                	jne    646 <writetest1+0x89>
  for(i = 0; i < MAXFILE; i++){
     624:	43                   	inc    %ebx
     625:	eb d2                	jmp    5f9 <writetest1+0x3c>
    printf(stdout, "error: creat big failed!\n");
     627:	83 ec 08             	sub    $0x8,%esp
     62a:	68 1b 43 00 00       	push   $0x431b
     62f:	ff 35 40 61 00 00    	pushl  0x6140
     635:	e8 0b 38 00 00       	call   3e45 <printf>
    exit(0);
     63a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     641:	e8 b0 36 00 00       	call   3cf6 <exit>
      printf(stdout, "error: write big file failed\n", i);
     646:	83 ec 04             	sub    $0x4,%esp
     649:	53                   	push   %ebx
     64a:	68 35 43 00 00       	push   $0x4335
     64f:	ff 35 40 61 00 00    	pushl  0x6140
     655:	e8 eb 37 00 00       	call   3e45 <printf>
      exit(0);
     65a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     661:	e8 90 36 00 00       	call   3cf6 <exit>
    }
  }

  close(fd);
     666:	83 ec 0c             	sub    $0xc,%esp
     669:	56                   	push   %esi
     66a:	e8 af 36 00 00       	call   3d1e <close>

  fd = open("big", O_RDONLY);
     66f:	83 c4 08             	add    $0x8,%esp
     672:	6a 00                	push   $0x0
     674:	68 85 43 00 00       	push   $0x4385
     679:	e8 b8 36 00 00       	call   3d36 <open>
     67e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     680:	83 c4 10             	add    $0x10,%esp
     683:	85 c0                	test   %eax,%eax
     685:	78 3a                	js     6c1 <writetest1+0x104>
    printf(stdout, "error: open big failed!\n");
    exit(0);
  }

  n = 0;
     687:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     68c:	83 ec 04             	sub    $0x4,%esp
     68f:	68 00 02 00 00       	push   $0x200
     694:	68 20 89 00 00       	push   $0x8920
     699:	56                   	push   %esi
     69a:	e8 6f 36 00 00       	call   3d0e <read>
    if(i == 0){
     69f:	83 c4 10             	add    $0x10,%esp
     6a2:	85 c0                	test   %eax,%eax
     6a4:	74 3a                	je     6e0 <writetest1+0x123>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit(0);
      }
      break;
    } else if(i != 512){
     6a6:	3d 00 02 00 00       	cmp    $0x200,%eax
     6ab:	0f 85 90 00 00 00    	jne    741 <writetest1+0x184>
      printf(stdout, "read failed %d\n", i);
      exit(0);
    }
    if(((int*)buf)[0] != n){
     6b1:	a1 20 89 00 00       	mov    0x8920,%eax
     6b6:	39 d8                	cmp    %ebx,%eax
     6b8:	0f 85 a3 00 00 00    	jne    761 <writetest1+0x1a4>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit(0);
    }
    n++;
     6be:	43                   	inc    %ebx
    i = read(fd, buf, 512);
     6bf:	eb cb                	jmp    68c <writetest1+0xcf>
    printf(stdout, "error: open big failed!\n");
     6c1:	83 ec 08             	sub    $0x8,%esp
     6c4:	68 53 43 00 00       	push   $0x4353
     6c9:	ff 35 40 61 00 00    	pushl  0x6140
     6cf:	e8 71 37 00 00       	call   3e45 <printf>
    exit(0);
     6d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6db:	e8 16 36 00 00       	call   3cf6 <exit>
      if(n == MAXFILE - 1){
     6e0:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     6e6:	74 39                	je     721 <writetest1+0x164>
  }
  close(fd);
     6e8:	83 ec 0c             	sub    $0xc,%esp
     6eb:	56                   	push   %esi
     6ec:	e8 2d 36 00 00       	call   3d1e <close>
  if(unlink("big") < 0){
     6f1:	c7 04 24 85 43 00 00 	movl   $0x4385,(%esp)
     6f8:	e8 49 36 00 00       	call   3d46 <unlink>
     6fd:	83 c4 10             	add    $0x10,%esp
     700:	85 c0                	test   %eax,%eax
     702:	78 7b                	js     77f <writetest1+0x1c2>
    printf(stdout, "unlink big failed\n");
    exit(0);
  }
  printf(stdout, "big files ok\n");
     704:	83 ec 08             	sub    $0x8,%esp
     707:	68 ac 43 00 00       	push   $0x43ac
     70c:	ff 35 40 61 00 00    	pushl  0x6140
     712:	e8 2e 37 00 00       	call   3e45 <printf>
}
     717:	83 c4 10             	add    $0x10,%esp
     71a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     71d:	5b                   	pop    %ebx
     71e:	5e                   	pop    %esi
     71f:	5d                   	pop    %ebp
     720:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     721:	83 ec 04             	sub    $0x4,%esp
     724:	53                   	push   %ebx
     725:	68 6c 43 00 00       	push   $0x436c
     72a:	ff 35 40 61 00 00    	pushl  0x6140
     730:	e8 10 37 00 00       	call   3e45 <printf>
        exit(0);
     735:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     73c:	e8 b5 35 00 00       	call   3cf6 <exit>
      printf(stdout, "read failed %d\n", i);
     741:	83 ec 04             	sub    $0x4,%esp
     744:	50                   	push   %eax
     745:	68 89 43 00 00       	push   $0x4389
     74a:	ff 35 40 61 00 00    	pushl  0x6140
     750:	e8 f0 36 00 00       	call   3e45 <printf>
      exit(0);
     755:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     75c:	e8 95 35 00 00       	call   3cf6 <exit>
      printf(stdout, "read content of block %d is %d\n",
     761:	50                   	push   %eax
     762:	53                   	push   %ebx
     763:	68 80 51 00 00       	push   $0x5180
     768:	ff 35 40 61 00 00    	pushl  0x6140
     76e:	e8 d2 36 00 00       	call   3e45 <printf>
      exit(0);
     773:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     77a:	e8 77 35 00 00       	call   3cf6 <exit>
    printf(stdout, "unlink big failed\n");
     77f:	83 ec 08             	sub    $0x8,%esp
     782:	68 99 43 00 00       	push   $0x4399
     787:	ff 35 40 61 00 00    	pushl  0x6140
     78d:	e8 b3 36 00 00       	call   3e45 <printf>
    exit(0);
     792:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     799:	e8 58 35 00 00       	call   3cf6 <exit>

0000079e <createtest>:

void
createtest(void)
{
     79e:	f3 0f 1e fb          	endbr32 
     7a2:	55                   	push   %ebp
     7a3:	89 e5                	mov    %esp,%ebp
     7a5:	53                   	push   %ebx
     7a6:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7a9:	68 a0 51 00 00       	push   $0x51a0
     7ae:	ff 35 40 61 00 00    	pushl  0x6140
     7b4:	e8 8c 36 00 00       	call   3e45 <printf>

  name[0] = 'a';
     7b9:	c6 05 20 a9 00 00 61 	movb   $0x61,0xa920
  name[2] = '\0';
     7c0:	c6 05 22 a9 00 00 00 	movb   $0x0,0xa922
  for(i = 0; i < 52; i++){
     7c7:	83 c4 10             	add    $0x10,%esp
     7ca:	bb 00 00 00 00       	mov    $0x0,%ebx
     7cf:	eb 26                	jmp    7f7 <createtest+0x59>
    name[1] = '0' + i;
     7d1:	8d 43 30             	lea    0x30(%ebx),%eax
     7d4:	a2 21 a9 00 00       	mov    %al,0xa921
    fd = open(name, O_CREATE|O_RDWR);
     7d9:	83 ec 08             	sub    $0x8,%esp
     7dc:	68 02 02 00 00       	push   $0x202
     7e1:	68 20 a9 00 00       	push   $0xa920
     7e6:	e8 4b 35 00 00       	call   3d36 <open>
    close(fd);
     7eb:	89 04 24             	mov    %eax,(%esp)
     7ee:	e8 2b 35 00 00       	call   3d1e <close>
  for(i = 0; i < 52; i++){
     7f3:	43                   	inc    %ebx
     7f4:	83 c4 10             	add    $0x10,%esp
     7f7:	83 fb 33             	cmp    $0x33,%ebx
     7fa:	7e d5                	jle    7d1 <createtest+0x33>
  }
  name[0] = 'a';
     7fc:	c6 05 20 a9 00 00 61 	movb   $0x61,0xa920
  name[2] = '\0';
     803:	c6 05 22 a9 00 00 00 	movb   $0x0,0xa922
  for(i = 0; i < 52; i++){
     80a:	bb 00 00 00 00       	mov    $0x0,%ebx
     80f:	eb 19                	jmp    82a <createtest+0x8c>
    name[1] = '0' + i;
     811:	8d 43 30             	lea    0x30(%ebx),%eax
     814:	a2 21 a9 00 00       	mov    %al,0xa921
    unlink(name);
     819:	83 ec 0c             	sub    $0xc,%esp
     81c:	68 20 a9 00 00       	push   $0xa920
     821:	e8 20 35 00 00       	call   3d46 <unlink>
  for(i = 0; i < 52; i++){
     826:	43                   	inc    %ebx
     827:	83 c4 10             	add    $0x10,%esp
     82a:	83 fb 33             	cmp    $0x33,%ebx
     82d:	7e e2                	jle    811 <createtest+0x73>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     82f:	83 ec 08             	sub    $0x8,%esp
     832:	68 c8 51 00 00       	push   $0x51c8
     837:	ff 35 40 61 00 00    	pushl  0x6140
     83d:	e8 03 36 00 00       	call   3e45 <printf>
}
     842:	83 c4 10             	add    $0x10,%esp
     845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     848:	c9                   	leave  
     849:	c3                   	ret    

0000084a <dirtest>:

void dirtest(void)
{
     84a:	f3 0f 1e fb          	endbr32 
     84e:	55                   	push   %ebp
     84f:	89 e5                	mov    %esp,%ebp
     851:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     854:	68 ba 43 00 00       	push   $0x43ba
     859:	ff 35 40 61 00 00    	pushl  0x6140
     85f:	e8 e1 35 00 00       	call   3e45 <printf>

  if(mkdir("dir0") < 0){
     864:	c7 04 24 c6 43 00 00 	movl   $0x43c6,(%esp)
     86b:	e8 ee 34 00 00       	call   3d5e <mkdir>
     870:	83 c4 10             	add    $0x10,%esp
     873:	85 c0                	test   %eax,%eax
     875:	78 54                	js     8cb <dirtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit(0);
  }

  if(chdir("dir0") < 0){
     877:	83 ec 0c             	sub    $0xc,%esp
     87a:	68 c6 43 00 00       	push   $0x43c6
     87f:	e8 e2 34 00 00       	call   3d66 <chdir>
     884:	83 c4 10             	add    $0x10,%esp
     887:	85 c0                	test   %eax,%eax
     889:	78 5f                	js     8ea <dirtest+0xa0>
    printf(stdout, "chdir dir0 failed\n");
    exit(0);
  }

  if(chdir("..") < 0){
     88b:	83 ec 0c             	sub    $0xc,%esp
     88e:	68 65 49 00 00       	push   $0x4965
     893:	e8 ce 34 00 00       	call   3d66 <chdir>
     898:	83 c4 10             	add    $0x10,%esp
     89b:	85 c0                	test   %eax,%eax
     89d:	78 6a                	js     909 <dirtest+0xbf>
    printf(stdout, "chdir .. failed\n");
    exit(0);
  }

  if(unlink("dir0") < 0){
     89f:	83 ec 0c             	sub    $0xc,%esp
     8a2:	68 c6 43 00 00       	push   $0x43c6
     8a7:	e8 9a 34 00 00       	call   3d46 <unlink>
     8ac:	83 c4 10             	add    $0x10,%esp
     8af:	85 c0                	test   %eax,%eax
     8b1:	78 75                	js     928 <dirtest+0xde>
    printf(stdout, "unlink dir0 failed\n");
    exit(0);
  }
  printf(stdout, "mkdir test ok\n");
     8b3:	83 ec 08             	sub    $0x8,%esp
     8b6:	68 03 44 00 00       	push   $0x4403
     8bb:	ff 35 40 61 00 00    	pushl  0x6140
     8c1:	e8 7f 35 00 00       	call   3e45 <printf>
}
     8c6:	83 c4 10             	add    $0x10,%esp
     8c9:	c9                   	leave  
     8ca:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     8cb:	83 ec 08             	sub    $0x8,%esp
     8ce:	68 f6 40 00 00       	push   $0x40f6
     8d3:	ff 35 40 61 00 00    	pushl  0x6140
     8d9:	e8 67 35 00 00       	call   3e45 <printf>
    exit(0);
     8de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     8e5:	e8 0c 34 00 00       	call   3cf6 <exit>
    printf(stdout, "chdir dir0 failed\n");
     8ea:	83 ec 08             	sub    $0x8,%esp
     8ed:	68 cb 43 00 00       	push   $0x43cb
     8f2:	ff 35 40 61 00 00    	pushl  0x6140
     8f8:	e8 48 35 00 00       	call   3e45 <printf>
    exit(0);
     8fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     904:	e8 ed 33 00 00       	call   3cf6 <exit>
    printf(stdout, "chdir .. failed\n");
     909:	83 ec 08             	sub    $0x8,%esp
     90c:	68 de 43 00 00       	push   $0x43de
     911:	ff 35 40 61 00 00    	pushl  0x6140
     917:	e8 29 35 00 00       	call   3e45 <printf>
    exit(0);
     91c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     923:	e8 ce 33 00 00       	call   3cf6 <exit>
    printf(stdout, "unlink dir0 failed\n");
     928:	83 ec 08             	sub    $0x8,%esp
     92b:	68 ef 43 00 00       	push   $0x43ef
     930:	ff 35 40 61 00 00    	pushl  0x6140
     936:	e8 0a 35 00 00       	call   3e45 <printf>
    exit(0);
     93b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     942:	e8 af 33 00 00       	call   3cf6 <exit>

00000947 <exectest>:

void
exectest(void)
{
     947:	f3 0f 1e fb          	endbr32 
     94b:	55                   	push   %ebp
     94c:	89 e5                	mov    %esp,%ebp
     94e:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     951:	68 12 44 00 00       	push   $0x4412
     956:	ff 35 40 61 00 00    	pushl  0x6140
     95c:	e8 e4 34 00 00       	call   3e45 <printf>
  if(exec("echo", echoargv) < 0){
     961:	83 c4 08             	add    $0x8,%esp
     964:	68 44 61 00 00       	push   $0x6144
     969:	68 db 41 00 00       	push   $0x41db
     96e:	e8 bb 33 00 00       	call   3d2e <exec>
     973:	83 c4 10             	add    $0x10,%esp
     976:	85 c0                	test   %eax,%eax
     978:	78 02                	js     97c <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit(0);
  }
}
     97a:	c9                   	leave  
     97b:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     97c:	83 ec 08             	sub    $0x8,%esp
     97f:	68 1d 44 00 00       	push   $0x441d
     984:	ff 35 40 61 00 00    	pushl  0x6140
     98a:	e8 b6 34 00 00       	call   3e45 <printf>
    exit(0);
     98f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     996:	e8 5b 33 00 00       	call   3cf6 <exit>

0000099b <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     99b:	f3 0f 1e fb          	endbr32 
     99f:	55                   	push   %ebp
     9a0:	89 e5                	mov    %esp,%ebp
     9a2:	57                   	push   %edi
     9a3:	56                   	push   %esi
     9a4:	53                   	push   %ebx
     9a5:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
     9ab:	50                   	push   %eax
     9ac:	e8 55 33 00 00       	call   3d06 <pipe>
     9b1:	83 c4 10             	add    $0x10,%esp
     9b4:	85 c0                	test   %eax,%eax
     9b6:	75 76                	jne    a2e <pipe1+0x93>
     9b8:	89 c6                	mov    %eax,%esi
    printf(1, "pipe() failed\n");
    exit(0);
  }
  pid = fork();
     9ba:	e8 2f 33 00 00       	call   3cee <fork>
     9bf:	89 c7                	mov    %eax,%edi
  seq = 0;
  if(pid == 0){
     9c1:	85 c0                	test   %eax,%eax
     9c3:	0f 84 80 00 00 00    	je     a49 <pipe1+0xae>
        printf(1, "pipe1 oops 1\n");
        exit(0);
      }
    }
    exit(0);
  } else if(pid > 0){
     9c9:	0f 8e 7d 01 00 00    	jle    b4c <pipe1+0x1b1>
    close(fds[1]);
     9cf:	83 ec 0c             	sub    $0xc,%esp
     9d2:	ff 75 e4             	pushl  -0x1c(%ebp)
     9d5:	e8 44 33 00 00       	call   3d1e <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     9da:	83 c4 10             	add    $0x10,%esp
    total = 0;
     9dd:	89 75 d0             	mov    %esi,-0x30(%ebp)
  seq = 0;
     9e0:	89 f3                	mov    %esi,%ebx
    cc = 1;
     9e2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     9e9:	83 ec 04             	sub    $0x4,%esp
     9ec:	ff 75 d4             	pushl  -0x2c(%ebp)
     9ef:	68 20 89 00 00       	push   $0x8920
     9f4:	ff 75 e0             	pushl  -0x20(%ebp)
     9f7:	e8 12 33 00 00       	call   3d0e <read>
     9fc:	89 c7                	mov    %eax,%edi
     9fe:	83 c4 10             	add    $0x10,%esp
     a01:	85 c0                	test   %eax,%eax
     a03:	0f 8e f1 00 00 00    	jle    afa <pipe1+0x15f>
      for(i = 0; i < n; i++){
     a09:	89 f0                	mov    %esi,%eax
     a0b:	89 d9                	mov    %ebx,%ecx
     a0d:	39 f8                	cmp    %edi,%eax
     a0f:	0f 8d c1 00 00 00    	jge    ad6 <pipe1+0x13b>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a15:	0f be 98 20 89 00 00 	movsbl 0x8920(%eax),%ebx
     a1c:	8d 51 01             	lea    0x1(%ecx),%edx
     a1f:	31 cb                	xor    %ecx,%ebx
     a21:	84 db                	test   %bl,%bl
     a23:	0f 85 93 00 00 00    	jne    abc <pipe1+0x121>
      for(i = 0; i < n; i++){
     a29:	40                   	inc    %eax
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a2a:	89 d1                	mov    %edx,%ecx
     a2c:	eb df                	jmp    a0d <pipe1+0x72>
    printf(1, "pipe() failed\n");
     a2e:	83 ec 08             	sub    $0x8,%esp
     a31:	68 2f 44 00 00       	push   $0x442f
     a36:	6a 01                	push   $0x1
     a38:	e8 08 34 00 00       	call   3e45 <printf>
    exit(0);
     a3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a44:	e8 ad 32 00 00       	call   3cf6 <exit>
    close(fds[0]);
     a49:	83 ec 0c             	sub    $0xc,%esp
     a4c:	ff 75 e0             	pushl  -0x20(%ebp)
     a4f:	e8 ca 32 00 00       	call   3d1e <close>
    for(n = 0; n < 5; n++){
     a54:	83 c4 10             	add    $0x10,%esp
     a57:	89 fe                	mov    %edi,%esi
  seq = 0;
     a59:	89 fb                	mov    %edi,%ebx
    for(n = 0; n < 5; n++){
     a5b:	eb 20                	jmp    a7d <pipe1+0xe2>
      if(write(fds[1], buf, 1033) != 1033){
     a5d:	83 ec 04             	sub    $0x4,%esp
     a60:	68 09 04 00 00       	push   $0x409
     a65:	68 20 89 00 00       	push   $0x8920
     a6a:	ff 75 e4             	pushl  -0x1c(%ebp)
     a6d:	e8 a4 32 00 00       	call   3d16 <write>
     a72:	83 c4 10             	add    $0x10,%esp
     a75:	3d 09 04 00 00       	cmp    $0x409,%eax
     a7a:	75 1b                	jne    a97 <pipe1+0xfc>
    for(n = 0; n < 5; n++){
     a7c:	46                   	inc    %esi
     a7d:	83 fe 04             	cmp    $0x4,%esi
     a80:	7f 30                	jg     ab2 <pipe1+0x117>
      for(i = 0; i < 1033; i++)
     a82:	89 f8                	mov    %edi,%eax
     a84:	3d 08 04 00 00       	cmp    $0x408,%eax
     a89:	7f d2                	jg     a5d <pipe1+0xc2>
        buf[i] = seq++;
     a8b:	88 98 20 89 00 00    	mov    %bl,0x8920(%eax)
      for(i = 0; i < 1033; i++)
     a91:	40                   	inc    %eax
        buf[i] = seq++;
     a92:	8d 5b 01             	lea    0x1(%ebx),%ebx
     a95:	eb ed                	jmp    a84 <pipe1+0xe9>
        printf(1, "pipe1 oops 1\n");
     a97:	83 ec 08             	sub    $0x8,%esp
     a9a:	68 3e 44 00 00       	push   $0x443e
     a9f:	6a 01                	push   $0x1
     aa1:	e8 9f 33 00 00       	call   3e45 <printf>
        exit(0);
     aa6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     aad:	e8 44 32 00 00       	call   3cf6 <exit>
    exit(0);
     ab2:	83 ec 0c             	sub    $0xc,%esp
     ab5:	6a 00                	push   $0x0
     ab7:	e8 3a 32 00 00       	call   3cf6 <exit>
          printf(1, "pipe1 oops 2\n");
     abc:	83 ec 08             	sub    $0x8,%esp
     abf:	68 4c 44 00 00       	push   $0x444c
     ac4:	6a 01                	push   $0x1
     ac6:	e8 7a 33 00 00       	call   3e45 <printf>
          return;
     acb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit(0);
  }
  printf(1, "pipe1 ok\n");
}
     ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ad1:	5b                   	pop    %ebx
     ad2:	5e                   	pop    %esi
     ad3:	5f                   	pop    %edi
     ad4:	5d                   	pop    %ebp
     ad5:	c3                   	ret    
     ad6:	89 cb                	mov    %ecx,%ebx
      total += n;
     ad8:	01 7d d0             	add    %edi,-0x30(%ebp)
      cc = cc * 2;
     adb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     ade:	01 c0                	add    %eax,%eax
     ae0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      if(cc > sizeof(buf))
     ae3:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ae8:	0f 86 fb fe ff ff    	jbe    9e9 <pipe1+0x4e>
        cc = sizeof(buf);
     aee:	c7 45 d4 00 20 00 00 	movl   $0x2000,-0x2c(%ebp)
     af5:	e9 ef fe ff ff       	jmp    9e9 <pipe1+0x4e>
    if(total != 5 * 1033){
     afa:	81 7d d0 2d 14 00 00 	cmpl   $0x142d,-0x30(%ebp)
     b01:	75 2b                	jne    b2e <pipe1+0x193>
    close(fds[0]);
     b03:	83 ec 0c             	sub    $0xc,%esp
     b06:	ff 75 e0             	pushl  -0x20(%ebp)
     b09:	e8 10 32 00 00       	call   3d1e <close>
    wait(NULL);
     b0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b15:	e8 e4 31 00 00       	call   3cfe <wait>
  printf(1, "pipe1 ok\n");
     b1a:	83 c4 08             	add    $0x8,%esp
     b1d:	68 71 44 00 00       	push   $0x4471
     b22:	6a 01                	push   $0x1
     b24:	e8 1c 33 00 00       	call   3e45 <printf>
     b29:	83 c4 10             	add    $0x10,%esp
     b2c:	eb a0                	jmp    ace <pipe1+0x133>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b2e:	83 ec 04             	sub    $0x4,%esp
     b31:	ff 75 d0             	pushl  -0x30(%ebp)
     b34:	68 5a 44 00 00       	push   $0x445a
     b39:	6a 01                	push   $0x1
     b3b:	e8 05 33 00 00       	call   3e45 <printf>
      exit(0);
     b40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b47:	e8 aa 31 00 00       	call   3cf6 <exit>
    printf(1, "fork() failed\n");
     b4c:	83 ec 08             	sub    $0x8,%esp
     b4f:	68 7b 44 00 00       	push   $0x447b
     b54:	6a 01                	push   $0x1
     b56:	e8 ea 32 00 00       	call   3e45 <printf>
    exit(0);
     b5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b62:	e8 8f 31 00 00       	call   3cf6 <exit>

00000b67 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b67:	f3 0f 1e fb          	endbr32 
     b6b:	55                   	push   %ebp
     b6c:	89 e5                	mov    %esp,%ebp
     b6e:	57                   	push   %edi
     b6f:	56                   	push   %esi
     b70:	53                   	push   %ebx
     b71:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b74:	68 8a 44 00 00       	push   $0x448a
     b79:	6a 01                	push   $0x1
     b7b:	e8 c5 32 00 00       	call   3e45 <printf>
  pid1 = fork();
     b80:	e8 69 31 00 00       	call   3cee <fork>
  if(pid1 == 0)
     b85:	83 c4 10             	add    $0x10,%esp
     b88:	85 c0                	test   %eax,%eax
     b8a:	75 02                	jne    b8e <preempt+0x27>
    for(;;)
     b8c:	eb fe                	jmp    b8c <preempt+0x25>
     b8e:	89 c7                	mov    %eax,%edi
      ;

  pid2 = fork();
     b90:	e8 59 31 00 00       	call   3cee <fork>
     b95:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     b97:	85 c0                	test   %eax,%eax
     b99:	75 02                	jne    b9d <preempt+0x36>
    for(;;)
     b9b:	eb fe                	jmp    b9b <preempt+0x34>
      ;

  pipe(pfds);
     b9d:	83 ec 0c             	sub    $0xc,%esp
     ba0:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ba3:	50                   	push   %eax
     ba4:	e8 5d 31 00 00       	call   3d06 <pipe>
  pid3 = fork();
     ba9:	e8 40 31 00 00       	call   3cee <fork>
     bae:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     bb0:	83 c4 10             	add    $0x10,%esp
     bb3:	85 c0                	test   %eax,%eax
     bb5:	75 49                	jne    c00 <preempt+0x99>
    close(pfds[0]);
     bb7:	83 ec 0c             	sub    $0xc,%esp
     bba:	ff 75 e0             	pushl  -0x20(%ebp)
     bbd:	e8 5c 31 00 00       	call   3d1e <close>
    if(write(pfds[1], "x", 1) != 1)
     bc2:	83 c4 0c             	add    $0xc,%esp
     bc5:	6a 01                	push   $0x1
     bc7:	68 49 4a 00 00       	push   $0x4a49
     bcc:	ff 75 e4             	pushl  -0x1c(%ebp)
     bcf:	e8 42 31 00 00       	call   3d16 <write>
     bd4:	83 c4 10             	add    $0x10,%esp
     bd7:	83 f8 01             	cmp    $0x1,%eax
     bda:	75 10                	jne    bec <preempt+0x85>
      printf(1, "preempt write error");
    close(pfds[1]);
     bdc:	83 ec 0c             	sub    $0xc,%esp
     bdf:	ff 75 e4             	pushl  -0x1c(%ebp)
     be2:	e8 37 31 00 00       	call   3d1e <close>
     be7:	83 c4 10             	add    $0x10,%esp
    for(;;)
     bea:	eb fe                	jmp    bea <preempt+0x83>
      printf(1, "preempt write error");
     bec:	83 ec 08             	sub    $0x8,%esp
     bef:	68 94 44 00 00       	push   $0x4494
     bf4:	6a 01                	push   $0x1
     bf6:	e8 4a 32 00 00       	call   3e45 <printf>
     bfb:	83 c4 10             	add    $0x10,%esp
     bfe:	eb dc                	jmp    bdc <preempt+0x75>
      ;
  }

  close(pfds[1]);
     c00:	83 ec 0c             	sub    $0xc,%esp
     c03:	ff 75 e4             	pushl  -0x1c(%ebp)
     c06:	e8 13 31 00 00       	call   3d1e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c0b:	83 c4 0c             	add    $0xc,%esp
     c0e:	68 00 20 00 00       	push   $0x2000
     c13:	68 20 89 00 00       	push   $0x8920
     c18:	ff 75 e0             	pushl  -0x20(%ebp)
     c1b:	e8 ee 30 00 00       	call   3d0e <read>
     c20:	83 c4 10             	add    $0x10,%esp
     c23:	83 f8 01             	cmp    $0x1,%eax
     c26:	74 1a                	je     c42 <preempt+0xdb>
    printf(1, "preempt read error");
     c28:	83 ec 08             	sub    $0x8,%esp
     c2b:	68 a8 44 00 00       	push   $0x44a8
     c30:	6a 01                	push   $0x1
     c32:	e8 0e 32 00 00       	call   3e45 <printf>
    return;
     c37:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait(NULL);
  wait(NULL);
  wait(NULL);
  printf(1, "preempt ok\n");
}
     c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c3d:	5b                   	pop    %ebx
     c3e:	5e                   	pop    %esi
     c3f:	5f                   	pop    %edi
     c40:	5d                   	pop    %ebp
     c41:	c3                   	ret    
  close(pfds[0]);
     c42:	83 ec 0c             	sub    $0xc,%esp
     c45:	ff 75 e0             	pushl  -0x20(%ebp)
     c48:	e8 d1 30 00 00       	call   3d1e <close>
  printf(1, "kill... ");
     c4d:	83 c4 08             	add    $0x8,%esp
     c50:	68 bb 44 00 00       	push   $0x44bb
     c55:	6a 01                	push   $0x1
     c57:	e8 e9 31 00 00       	call   3e45 <printf>
  kill(pid1);
     c5c:	89 3c 24             	mov    %edi,(%esp)
     c5f:	e8 c2 30 00 00       	call   3d26 <kill>
  kill(pid2);
     c64:	89 34 24             	mov    %esi,(%esp)
     c67:	e8 ba 30 00 00       	call   3d26 <kill>
  kill(pid3);
     c6c:	89 1c 24             	mov    %ebx,(%esp)
     c6f:	e8 b2 30 00 00       	call   3d26 <kill>
  printf(1, "wait... ");
     c74:	83 c4 08             	add    $0x8,%esp
     c77:	68 c4 44 00 00       	push   $0x44c4
     c7c:	6a 01                	push   $0x1
     c7e:	e8 c2 31 00 00       	call   3e45 <printf>
  wait(NULL);
     c83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c8a:	e8 6f 30 00 00       	call   3cfe <wait>
  wait(NULL);
     c8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c96:	e8 63 30 00 00       	call   3cfe <wait>
  wait(NULL);
     c9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ca2:	e8 57 30 00 00       	call   3cfe <wait>
  printf(1, "preempt ok\n");
     ca7:	83 c4 08             	add    $0x8,%esp
     caa:	68 cd 44 00 00       	push   $0x44cd
     caf:	6a 01                	push   $0x1
     cb1:	e8 8f 31 00 00       	call   3e45 <printf>
     cb6:	83 c4 10             	add    $0x10,%esp
     cb9:	e9 7c ff ff ff       	jmp    c3a <preempt+0xd3>

00000cbe <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cbe:	f3 0f 1e fb          	endbr32 
     cc2:	55                   	push   %ebp
     cc3:	89 e5                	mov    %esp,%ebp
     cc5:	56                   	push   %esi
     cc6:	53                   	push   %ebx
  int i, pid;

  for(i = 0; i < 100; i++){
     cc7:	be 00 00 00 00       	mov    $0x0,%esi
     ccc:	eb 24                	jmp    cf2 <exitwait+0x34>
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
     cce:	83 ec 08             	sub    $0x8,%esp
     cd1:	68 31 50 00 00       	push   $0x5031
     cd6:	6a 01                	push   $0x1
     cd8:	e8 68 31 00 00       	call   3e45 <printf>
      return;
     cdd:	83 c4 10             	add    $0x10,%esp
    } else {
      exit(0);
    }
  }
  printf(1, "exitwait ok\n");
}
     ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ce3:	5b                   	pop    %ebx
     ce4:	5e                   	pop    %esi
     ce5:	5d                   	pop    %ebp
     ce6:	c3                   	ret    
      exit(0);
     ce7:	83 ec 0c             	sub    $0xc,%esp
     cea:	6a 00                	push   $0x0
     cec:	e8 05 30 00 00       	call   3cf6 <exit>
  for(i = 0; i < 100; i++){
     cf1:	46                   	inc    %esi
     cf2:	83 fe 63             	cmp    $0x63,%esi
     cf5:	7f 32                	jg     d29 <exitwait+0x6b>
    pid = fork();
     cf7:	e8 f2 2f 00 00       	call   3cee <fork>
     cfc:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     cfe:	85 c0                	test   %eax,%eax
     d00:	78 cc                	js     cce <exitwait+0x10>
    if(pid){
     d02:	74 e3                	je     ce7 <exitwait+0x29>
      if(wait(NULL) != pid){
     d04:	83 ec 0c             	sub    $0xc,%esp
     d07:	6a 00                	push   $0x0
     d09:	e8 f0 2f 00 00       	call   3cfe <wait>
     d0e:	83 c4 10             	add    $0x10,%esp
     d11:	39 d8                	cmp    %ebx,%eax
     d13:	74 dc                	je     cf1 <exitwait+0x33>
        printf(1, "wait wrong pid\n");
     d15:	83 ec 08             	sub    $0x8,%esp
     d18:	68 d9 44 00 00       	push   $0x44d9
     d1d:	6a 01                	push   $0x1
     d1f:	e8 21 31 00 00       	call   3e45 <printf>
        return;
     d24:	83 c4 10             	add    $0x10,%esp
     d27:	eb b7                	jmp    ce0 <exitwait+0x22>
  printf(1, "exitwait ok\n");
     d29:	83 ec 08             	sub    $0x8,%esp
     d2c:	68 e9 44 00 00       	push   $0x44e9
     d31:	6a 01                	push   $0x1
     d33:	e8 0d 31 00 00       	call   3e45 <printf>
     d38:	83 c4 10             	add    $0x10,%esp
     d3b:	eb a3                	jmp    ce0 <exitwait+0x22>

00000d3d <mem>:

void
mem(void)
{
     d3d:	f3 0f 1e fb          	endbr32 
     d41:	55                   	push   %ebp
     d42:	89 e5                	mov    %esp,%ebp
     d44:	57                   	push   %edi
     d45:	56                   	push   %esi
     d46:	53                   	push   %ebx
     d47:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d4a:	68 f6 44 00 00       	push   $0x44f6
     d4f:	6a 01                	push   $0x1
     d51:	e8 ef 30 00 00       	call   3e45 <printf>
  ppid = getpid();
     d56:	e8 23 30 00 00       	call   3d7e <getpid>
     d5b:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     d5d:	e8 8c 2f 00 00       	call   3cee <fork>
     d62:	83 c4 10             	add    $0x10,%esp
     d65:	85 c0                	test   %eax,%eax
     d67:	0f 85 8e 00 00 00    	jne    dfb <mem+0xbe>
    m1 = 0;
     d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
    while((m2 = malloc(10001)) != 0){
     d72:	83 ec 0c             	sub    $0xc,%esp
     d75:	68 11 27 00 00       	push   $0x2711
     d7a:	e8 e4 32 00 00       	call   4063 <malloc>
     d7f:	83 c4 10             	add    $0x10,%esp
     d82:	85 c0                	test   %eax,%eax
     d84:	74 16                	je     d9c <mem+0x5f>
      *(char**)m2 = m1;
     d86:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     d88:	89 c3                	mov    %eax,%ebx
     d8a:	eb e6                	jmp    d72 <mem+0x35>
    }
    while(m1){
      m2 = *(char**)m1;
     d8c:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     d8e:	83 ec 0c             	sub    $0xc,%esp
     d91:	53                   	push   %ebx
     d92:	e8 08 32 00 00       	call   3f9f <free>
     d97:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     d9a:	89 fb                	mov    %edi,%ebx
    while(m1){
     d9c:	85 db                	test   %ebx,%ebx
     d9e:	75 ec                	jne    d8c <mem+0x4f>
    }
    m1 = malloc(1024*20);
     da0:	83 ec 0c             	sub    $0xc,%esp
     da3:	68 00 50 00 00       	push   $0x5000
     da8:	e8 b6 32 00 00       	call   4063 <malloc>
    if(m1 == 0){
     dad:	83 c4 10             	add    $0x10,%esp
     db0:	85 c0                	test   %eax,%eax
     db2:	74 24                	je     dd8 <mem+0x9b>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit(0);
    }
    free(m1);
     db4:	83 ec 0c             	sub    $0xc,%esp
     db7:	50                   	push   %eax
     db8:	e8 e2 31 00 00       	call   3f9f <free>
    printf(1, "mem ok\n");
     dbd:	83 c4 08             	add    $0x8,%esp
     dc0:	68 1a 45 00 00       	push   $0x451a
     dc5:	6a 01                	push   $0x1
     dc7:	e8 79 30 00 00       	call   3e45 <printf>
    exit(0);
     dcc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     dd3:	e8 1e 2f 00 00       	call   3cf6 <exit>
      printf(1, "couldn't allocate mem?!!\n");
     dd8:	83 ec 08             	sub    $0x8,%esp
     ddb:	68 00 45 00 00       	push   $0x4500
     de0:	6a 01                	push   $0x1
     de2:	e8 5e 30 00 00       	call   3e45 <printf>
      kill(ppid);
     de7:	89 34 24             	mov    %esi,(%esp)
     dea:	e8 37 2f 00 00       	call   3d26 <kill>
      exit(0);
     def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     df6:	e8 fb 2e 00 00       	call   3cf6 <exit>
  } else {
    wait(NULL);
     dfb:	83 ec 0c             	sub    $0xc,%esp
     dfe:	6a 00                	push   $0x0
     e00:	e8 f9 2e 00 00       	call   3cfe <wait>
  }
}
     e05:	83 c4 10             	add    $0x10,%esp
     e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e0b:	5b                   	pop    %ebx
     e0c:	5e                   	pop    %esi
     e0d:	5f                   	pop    %edi
     e0e:	5d                   	pop    %ebp
     e0f:	c3                   	ret    

00000e10 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e10:	f3 0f 1e fb          	endbr32 
     e14:	55                   	push   %ebp
     e15:	89 e5                	mov    %esp,%ebp
     e17:	57                   	push   %edi
     e18:	56                   	push   %esi
     e19:	53                   	push   %ebx
     e1a:	83 ec 24             	sub    $0x24,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e1d:	68 22 45 00 00       	push   $0x4522
     e22:	6a 01                	push   $0x1
     e24:	e8 1c 30 00 00       	call   3e45 <printf>

  unlink("sharedfd");
     e29:	c7 04 24 31 45 00 00 	movl   $0x4531,(%esp)
     e30:	e8 11 2f 00 00       	call   3d46 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e35:	83 c4 08             	add    $0x8,%esp
     e38:	68 02 02 00 00       	push   $0x202
     e3d:	68 31 45 00 00       	push   $0x4531
     e42:	e8 ef 2e 00 00       	call   3d36 <open>
  if(fd < 0){
     e47:	83 c4 10             	add    $0x10,%esp
     e4a:	85 c0                	test   %eax,%eax
     e4c:	78 4b                	js     e99 <sharedfd+0x89>
     e4e:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     e50:	e8 99 2e 00 00       	call   3cee <fork>
     e55:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e57:	85 c0                	test   %eax,%eax
     e59:	75 55                	jne    eb0 <sharedfd+0xa0>
     e5b:	b8 63 00 00 00       	mov    $0x63,%eax
     e60:	83 ec 04             	sub    $0x4,%esp
     e63:	6a 0a                	push   $0xa
     e65:	50                   	push   %eax
     e66:	8d 45 de             	lea    -0x22(%ebp),%eax
     e69:	50                   	push   %eax
     e6a:	e8 4a 2d 00 00       	call   3bb9 <memset>
  for(i = 0; i < 1000; i++){
     e6f:	83 c4 10             	add    $0x10,%esp
     e72:	bb 00 00 00 00       	mov    $0x0,%ebx
     e77:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
     e7d:	7f 4a                	jg     ec9 <sharedfd+0xb9>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     e7f:	83 ec 04             	sub    $0x4,%esp
     e82:	6a 0a                	push   $0xa
     e84:	8d 45 de             	lea    -0x22(%ebp),%eax
     e87:	50                   	push   %eax
     e88:	56                   	push   %esi
     e89:	e8 88 2e 00 00       	call   3d16 <write>
     e8e:	83 c4 10             	add    $0x10,%esp
     e91:	83 f8 0a             	cmp    $0xa,%eax
     e94:	75 21                	jne    eb7 <sharedfd+0xa7>
  for(i = 0; i < 1000; i++){
     e96:	43                   	inc    %ebx
     e97:	eb de                	jmp    e77 <sharedfd+0x67>
    printf(1, "fstests: cannot open sharedfd for writing");
     e99:	83 ec 08             	sub    $0x8,%esp
     e9c:	68 f0 51 00 00       	push   $0x51f0
     ea1:	6a 01                	push   $0x1
     ea3:	e8 9d 2f 00 00       	call   3e45 <printf>
    return;
     ea8:	83 c4 10             	add    $0x10,%esp
     eab:	e9 de 00 00 00       	jmp    f8e <sharedfd+0x17e>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     eb0:	b8 70 00 00 00       	mov    $0x70,%eax
     eb5:	eb a9                	jmp    e60 <sharedfd+0x50>
      printf(1, "fstests: write sharedfd failed\n");
     eb7:	83 ec 08             	sub    $0x8,%esp
     eba:	68 1c 52 00 00       	push   $0x521c
     ebf:	6a 01                	push   $0x1
     ec1:	e8 7f 2f 00 00       	call   3e45 <printf>
      break;
     ec6:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     ec9:	85 ff                	test   %edi,%edi
     ecb:	74 51                	je     f1e <sharedfd+0x10e>
    exit(0);
  else
    wait(NULL);
     ecd:	83 ec 0c             	sub    $0xc,%esp
     ed0:	6a 00                	push   $0x0
     ed2:	e8 27 2e 00 00       	call   3cfe <wait>
  close(fd);
     ed7:	89 34 24             	mov    %esi,(%esp)
     eda:	e8 3f 2e 00 00       	call   3d1e <close>
  fd = open("sharedfd", 0);
     edf:	83 c4 08             	add    $0x8,%esp
     ee2:	6a 00                	push   $0x0
     ee4:	68 31 45 00 00       	push   $0x4531
     ee9:	e8 48 2e 00 00       	call   3d36 <open>
     eee:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     ef0:	83 c4 10             	add    $0x10,%esp
     ef3:	85 c0                	test   %eax,%eax
     ef5:	78 31                	js     f28 <sharedfd+0x118>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     ef7:	be 00 00 00 00       	mov    $0x0,%esi
     efc:	bb 00 00 00 00       	mov    $0x0,%ebx
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f01:	83 ec 04             	sub    $0x4,%esp
     f04:	6a 0a                	push   $0xa
     f06:	8d 45 de             	lea    -0x22(%ebp),%eax
     f09:	50                   	push   %eax
     f0a:	57                   	push   %edi
     f0b:	e8 fe 2d 00 00       	call   3d0e <read>
     f10:	83 c4 10             	add    $0x10,%esp
     f13:	85 c0                	test   %eax,%eax
     f15:	7e 3d                	jle    f54 <sharedfd+0x144>
    for(i = 0; i < sizeof(buf); i++){
     f17:	ba 00 00 00 00       	mov    $0x0,%edx
     f1c:	eb 22                	jmp    f40 <sharedfd+0x130>
    exit(0);
     f1e:	83 ec 0c             	sub    $0xc,%esp
     f21:	6a 00                	push   $0x0
     f23:	e8 ce 2d 00 00       	call   3cf6 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f28:	83 ec 08             	sub    $0x8,%esp
     f2b:	68 3c 52 00 00       	push   $0x523c
     f30:	6a 01                	push   $0x1
     f32:	e8 0e 2f 00 00       	call   3e45 <printf>
    return;
     f37:	83 c4 10             	add    $0x10,%esp
     f3a:	eb 52                	jmp    f8e <sharedfd+0x17e>
      if(buf[i] == 'c')
        nc++;
     f3c:	43                   	inc    %ebx
     f3d:	eb 0e                	jmp    f4d <sharedfd+0x13d>
    for(i = 0; i < sizeof(buf); i++){
     f3f:	42                   	inc    %edx
     f40:	83 fa 09             	cmp    $0x9,%edx
     f43:	77 bc                	ja     f01 <sharedfd+0xf1>
      if(buf[i] == 'c')
     f45:	8a 44 15 de          	mov    -0x22(%ebp,%edx,1),%al
     f49:	3c 63                	cmp    $0x63,%al
     f4b:	74 ef                	je     f3c <sharedfd+0x12c>
      if(buf[i] == 'p')
     f4d:	3c 70                	cmp    $0x70,%al
     f4f:	75 ee                	jne    f3f <sharedfd+0x12f>
        np++;
     f51:	46                   	inc    %esi
     f52:	eb eb                	jmp    f3f <sharedfd+0x12f>
    }
  }
  close(fd);
     f54:	83 ec 0c             	sub    $0xc,%esp
     f57:	57                   	push   %edi
     f58:	e8 c1 2d 00 00       	call   3d1e <close>
  unlink("sharedfd");
     f5d:	c7 04 24 31 45 00 00 	movl   $0x4531,(%esp)
     f64:	e8 dd 2d 00 00       	call   3d46 <unlink>
  if(nc == 10000 && np == 10000){
     f69:	83 c4 10             	add    $0x10,%esp
     f6c:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     f72:	75 22                	jne    f96 <sharedfd+0x186>
     f74:	81 fe 10 27 00 00    	cmp    $0x2710,%esi
     f7a:	75 1a                	jne    f96 <sharedfd+0x186>
    printf(1, "sharedfd ok\n");
     f7c:	83 ec 08             	sub    $0x8,%esp
     f7f:	68 3a 45 00 00       	push   $0x453a
     f84:	6a 01                	push   $0x1
     f86:	e8 ba 2e 00 00       	call   3e45 <printf>
     f8b:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit(0);
  }
}
     f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f91:	5b                   	pop    %ebx
     f92:	5e                   	pop    %esi
     f93:	5f                   	pop    %edi
     f94:	5d                   	pop    %ebp
     f95:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
     f96:	56                   	push   %esi
     f97:	53                   	push   %ebx
     f98:	68 47 45 00 00       	push   $0x4547
     f9d:	6a 01                	push   $0x1
     f9f:	e8 a1 2e 00 00       	call   3e45 <printf>
    exit(0);
     fa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     fab:	e8 46 2d 00 00       	call   3cf6 <exit>

00000fb0 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     fb0:	f3 0f 1e fb          	endbr32 
     fb4:	55                   	push   %ebp
     fb5:	89 e5                	mov    %esp,%ebp
     fb7:	57                   	push   %edi
     fb8:	56                   	push   %esi
     fb9:	53                   	push   %ebx
     fba:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     fbd:	8d 7d d8             	lea    -0x28(%ebp),%edi
     fc0:	be 88 58 00 00       	mov    $0x5888,%esi
     fc5:	b9 04 00 00 00       	mov    $0x4,%ecx
     fca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  char *fname;

  printf(1, "fourfiles test\n");
     fcc:	68 5c 45 00 00       	push   $0x455c
     fd1:	6a 01                	push   $0x1
     fd3:	e8 6d 2e 00 00       	call   3e45 <printf>

  for(pi = 0; pi < 4; pi++){
     fd8:	83 c4 10             	add    $0x10,%esp
     fdb:	be 00 00 00 00       	mov    $0x0,%esi
     fe0:	83 fe 03             	cmp    $0x3,%esi
     fe3:	0f 8f d1 00 00 00    	jg     10ba <fourfiles+0x10a>
    fname = names[pi];
     fe9:	8b 7c b5 d8          	mov    -0x28(%ebp,%esi,4),%edi
    unlink(fname);
     fed:	83 ec 0c             	sub    $0xc,%esp
     ff0:	57                   	push   %edi
     ff1:	e8 50 2d 00 00       	call   3d46 <unlink>

    pid = fork();
     ff6:	e8 f3 2c 00 00       	call   3cee <fork>
    if(pid < 0){
     ffb:	83 c4 10             	add    $0x10,%esp
     ffe:	85 c0                	test   %eax,%eax
    1000:	78 05                	js     1007 <fourfiles+0x57>
      printf(1, "fork failed\n");
      exit(0);
    }

    if(pid == 0){
    1002:	74 1e                	je     1022 <fourfiles+0x72>
  for(pi = 0; pi < 4; pi++){
    1004:	46                   	inc    %esi
    1005:	eb d9                	jmp    fe0 <fourfiles+0x30>
      printf(1, "fork failed\n");
    1007:	83 ec 08             	sub    $0x8,%esp
    100a:	68 31 50 00 00       	push   $0x5031
    100f:	6a 01                	push   $0x1
    1011:	e8 2f 2e 00 00       	call   3e45 <printf>
      exit(0);
    1016:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    101d:	e8 d4 2c 00 00       	call   3cf6 <exit>
    1022:	89 c3                	mov    %eax,%ebx
      fd = open(fname, O_CREATE | O_RDWR);
    1024:	83 ec 08             	sub    $0x8,%esp
    1027:	68 02 02 00 00       	push   $0x202
    102c:	57                   	push   %edi
    102d:	e8 04 2d 00 00       	call   3d36 <open>
    1032:	89 c7                	mov    %eax,%edi
      if(fd < 0){
    1034:	83 c4 10             	add    $0x10,%esp
    1037:	85 c0                	test   %eax,%eax
    1039:	78 3e                	js     1079 <fourfiles+0xc9>
        printf(1, "create failed\n");
        exit(0);
      }

      memset(buf, '0'+pi, 512);
    103b:	83 ec 04             	sub    $0x4,%esp
    103e:	68 00 02 00 00       	push   $0x200
    1043:	83 c6 30             	add    $0x30,%esi
    1046:	56                   	push   %esi
    1047:	68 20 89 00 00       	push   $0x8920
    104c:	e8 68 2b 00 00       	call   3bb9 <memset>
      for(i = 0; i < 12; i++){
    1051:	83 c4 10             	add    $0x10,%esp
    1054:	83 fb 0b             	cmp    $0xb,%ebx
    1057:	7f 57                	jg     10b0 <fourfiles+0x100>
        if((n = write(fd, buf, 500)) != 500){
    1059:	83 ec 04             	sub    $0x4,%esp
    105c:	68 f4 01 00 00       	push   $0x1f4
    1061:	68 20 89 00 00       	push   $0x8920
    1066:	57                   	push   %edi
    1067:	e8 aa 2c 00 00       	call   3d16 <write>
    106c:	83 c4 10             	add    $0x10,%esp
    106f:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1074:	75 1e                	jne    1094 <fourfiles+0xe4>
      for(i = 0; i < 12; i++){
    1076:	43                   	inc    %ebx
    1077:	eb db                	jmp    1054 <fourfiles+0xa4>
        printf(1, "create failed\n");
    1079:	83 ec 08             	sub    $0x8,%esp
    107c:	68 f7 47 00 00       	push   $0x47f7
    1081:	6a 01                	push   $0x1
    1083:	e8 bd 2d 00 00       	call   3e45 <printf>
        exit(0);
    1088:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    108f:	e8 62 2c 00 00       	call   3cf6 <exit>
          printf(1, "write failed %d\n", n);
    1094:	83 ec 04             	sub    $0x4,%esp
    1097:	50                   	push   %eax
    1098:	68 6c 45 00 00       	push   $0x456c
    109d:	6a 01                	push   $0x1
    109f:	e8 a1 2d 00 00       	call   3e45 <printf>
          exit(0);
    10a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10ab:	e8 46 2c 00 00       	call   3cf6 <exit>
        }
      }
      exit(0);
    10b0:	83 ec 0c             	sub    $0xc,%esp
    10b3:	6a 00                	push   $0x0
    10b5:	e8 3c 2c 00 00       	call   3cf6 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
    10ba:	bb 00 00 00 00       	mov    $0x0,%ebx
    10bf:	eb 0e                	jmp    10cf <fourfiles+0x11f>
    wait(NULL);
    10c1:	83 ec 0c             	sub    $0xc,%esp
    10c4:	6a 00                	push   $0x0
    10c6:	e8 33 2c 00 00       	call   3cfe <wait>
  for(pi = 0; pi < 4; pi++){
    10cb:	43                   	inc    %ebx
    10cc:	83 c4 10             	add    $0x10,%esp
    10cf:	83 fb 03             	cmp    $0x3,%ebx
    10d2:	7e ed                	jle    10c1 <fourfiles+0x111>
  }

  for(i = 0; i < 2; i++){
    10d4:	bb 00 00 00 00       	mov    $0x0,%ebx
    10d9:	eb 76                	jmp    1151 <fourfiles+0x1a1>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
    10db:	83 ec 08             	sub    $0x8,%esp
    10de:	68 7d 45 00 00       	push   $0x457d
    10e3:	6a 01                	push   $0x1
    10e5:	e8 5b 2d 00 00       	call   3e45 <printf>
          exit(0);
    10ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10f1:	e8 00 2c 00 00       	call   3cf6 <exit>
        }
      }
      total += n;
    10f6:	01 45 d4             	add    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10f9:	83 ec 04             	sub    $0x4,%esp
    10fc:	68 00 20 00 00       	push   $0x2000
    1101:	68 20 89 00 00       	push   $0x8920
    1106:	56                   	push   %esi
    1107:	e8 02 2c 00 00       	call   3d0e <read>
    110c:	83 c4 10             	add    $0x10,%esp
    110f:	85 c0                	test   %eax,%eax
    1111:	7e 1a                	jle    112d <fourfiles+0x17d>
      for(j = 0; j < n; j++){
    1113:	ba 00 00 00 00       	mov    $0x0,%edx
    1118:	39 c2                	cmp    %eax,%edx
    111a:	7d da                	jge    10f6 <fourfiles+0x146>
        if(buf[j] != '0'+i){
    111c:	0f be ba 20 89 00 00 	movsbl 0x8920(%edx),%edi
    1123:	8d 4b 30             	lea    0x30(%ebx),%ecx
    1126:	39 cf                	cmp    %ecx,%edi
    1128:	75 b1                	jne    10db <fourfiles+0x12b>
      for(j = 0; j < n; j++){
    112a:	42                   	inc    %edx
    112b:	eb eb                	jmp    1118 <fourfiles+0x168>
    }
    close(fd);
    112d:	83 ec 0c             	sub    $0xc,%esp
    1130:	56                   	push   %esi
    1131:	e8 e8 2b 00 00       	call   3d1e <close>
    if(total != 12*500){
    1136:	83 c4 10             	add    $0x10,%esp
    1139:	81 7d d4 70 17 00 00 	cmpl   $0x1770,-0x2c(%ebp)
    1140:	75 34                	jne    1176 <fourfiles+0x1c6>
      printf(1, "wrong length %d\n", total);
      exit(0);
    }
    unlink(fname);
    1142:	83 ec 0c             	sub    $0xc,%esp
    1145:	ff 75 d0             	pushl  -0x30(%ebp)
    1148:	e8 f9 2b 00 00       	call   3d46 <unlink>
  for(i = 0; i < 2; i++){
    114d:	43                   	inc    %ebx
    114e:	83 c4 10             	add    $0x10,%esp
    1151:	83 fb 01             	cmp    $0x1,%ebx
    1154:	7f 3e                	jg     1194 <fourfiles+0x1e4>
    fname = names[i];
    1156:	8b 44 9d d8          	mov    -0x28(%ebp,%ebx,4),%eax
    115a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
    115d:	83 ec 08             	sub    $0x8,%esp
    1160:	6a 00                	push   $0x0
    1162:	50                   	push   %eax
    1163:	e8 ce 2b 00 00       	call   3d36 <open>
    1168:	89 c6                	mov    %eax,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    116a:	83 c4 10             	add    $0x10,%esp
    total = 0;
    116d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1174:	eb 83                	jmp    10f9 <fourfiles+0x149>
      printf(1, "wrong length %d\n", total);
    1176:	83 ec 04             	sub    $0x4,%esp
    1179:	ff 75 d4             	pushl  -0x2c(%ebp)
    117c:	68 89 45 00 00       	push   $0x4589
    1181:	6a 01                	push   $0x1
    1183:	e8 bd 2c 00 00       	call   3e45 <printf>
      exit(0);
    1188:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    118f:	e8 62 2b 00 00       	call   3cf6 <exit>
  }

  printf(1, "fourfiles ok\n");
    1194:	83 ec 08             	sub    $0x8,%esp
    1197:	68 9a 45 00 00       	push   $0x459a
    119c:	6a 01                	push   $0x1
    119e:	e8 a2 2c 00 00       	call   3e45 <printf>
}
    11a3:	83 c4 10             	add    $0x10,%esp
    11a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11a9:	5b                   	pop    %ebx
    11aa:	5e                   	pop    %esi
    11ab:	5f                   	pop    %edi
    11ac:	5d                   	pop    %ebp
    11ad:	c3                   	ret    

000011ae <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    11ae:	f3 0f 1e fb          	endbr32 
    11b2:	55                   	push   %ebp
    11b3:	89 e5                	mov    %esp,%ebp
    11b5:	56                   	push   %esi
    11b6:	53                   	push   %ebx
    11b7:	83 ec 28             	sub    $0x28,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    11ba:	68 a8 45 00 00       	push   $0x45a8
    11bf:	6a 01                	push   $0x1
    11c1:	e8 7f 2c 00 00       	call   3e45 <printf>

  for(pi = 0; pi < 4; pi++){
    11c6:	83 c4 10             	add    $0x10,%esp
    11c9:	be 00 00 00 00       	mov    $0x0,%esi
    11ce:	83 fe 03             	cmp    $0x3,%esi
    11d1:	0f 8f d2 00 00 00    	jg     12a9 <createdelete+0xfb>
    pid = fork();
    11d7:	e8 12 2b 00 00       	call   3cee <fork>
    11dc:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    11de:	85 c0                	test   %eax,%eax
    11e0:	78 05                	js     11e7 <createdelete+0x39>
      printf(1, "fork failed\n");
      exit(0);
    }

    if(pid == 0){
    11e2:	74 1e                	je     1202 <createdelete+0x54>
  for(pi = 0; pi < 4; pi++){
    11e4:	46                   	inc    %esi
    11e5:	eb e7                	jmp    11ce <createdelete+0x20>
      printf(1, "fork failed\n");
    11e7:	83 ec 08             	sub    $0x8,%esp
    11ea:	68 31 50 00 00       	push   $0x5031
    11ef:	6a 01                	push   $0x1
    11f1:	e8 4f 2c 00 00       	call   3e45 <printf>
      exit(0);
    11f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11fd:	e8 f4 2a 00 00       	call   3cf6 <exit>
      name[0] = 'p' + pi;
    1202:	8d 46 70             	lea    0x70(%esi),%eax
    1205:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[2] = '\0';
    1208:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
      for(i = 0; i < N; i++){
    120c:	eb 1c                	jmp    122a <createdelete+0x7c>
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
    120e:	83 ec 08             	sub    $0x8,%esp
    1211:	68 f7 47 00 00       	push   $0x47f7
    1216:	6a 01                	push   $0x1
    1218:	e8 28 2c 00 00       	call   3e45 <printf>
          exit(0);
    121d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1224:	e8 cd 2a 00 00       	call   3cf6 <exit>
      for(i = 0; i < N; i++){
    1229:	43                   	inc    %ebx
    122a:	83 fb 13             	cmp    $0x13,%ebx
    122d:	7f 70                	jg     129f <createdelete+0xf1>
        name[1] = '0' + i;
    122f:	8d 43 30             	lea    0x30(%ebx),%eax
    1232:	88 45 d9             	mov    %al,-0x27(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1235:	83 ec 08             	sub    $0x8,%esp
    1238:	68 02 02 00 00       	push   $0x202
    123d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1240:	50                   	push   %eax
    1241:	e8 f0 2a 00 00       	call   3d36 <open>
        if(fd < 0){
    1246:	83 c4 10             	add    $0x10,%esp
    1249:	85 c0                	test   %eax,%eax
    124b:	78 c1                	js     120e <createdelete+0x60>
        }
        close(fd);
    124d:	83 ec 0c             	sub    $0xc,%esp
    1250:	50                   	push   %eax
    1251:	e8 c8 2a 00 00       	call   3d1e <close>
        if(i > 0 && (i % 2 ) == 0){
    1256:	83 c4 10             	add    $0x10,%esp
    1259:	85 db                	test   %ebx,%ebx
    125b:	7e cc                	jle    1229 <createdelete+0x7b>
    125d:	f6 c3 01             	test   $0x1,%bl
    1260:	75 c7                	jne    1229 <createdelete+0x7b>
          name[1] = '0' + (i / 2);
    1262:	89 d8                	mov    %ebx,%eax
    1264:	c1 e8 1f             	shr    $0x1f,%eax
    1267:	01 d8                	add    %ebx,%eax
    1269:	d1 f8                	sar    %eax
    126b:	83 c0 30             	add    $0x30,%eax
    126e:	88 45 d9             	mov    %al,-0x27(%ebp)
          if(unlink(name) < 0){
    1271:	83 ec 0c             	sub    $0xc,%esp
    1274:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1277:	50                   	push   %eax
    1278:	e8 c9 2a 00 00       	call   3d46 <unlink>
    127d:	83 c4 10             	add    $0x10,%esp
    1280:	85 c0                	test   %eax,%eax
    1282:	79 a5                	jns    1229 <createdelete+0x7b>
            printf(1, "unlink failed\n");
    1284:	83 ec 08             	sub    $0x8,%esp
    1287:	68 af 41 00 00       	push   $0x41af
    128c:	6a 01                	push   $0x1
    128e:	e8 b2 2b 00 00       	call   3e45 <printf>
            exit(0);
    1293:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    129a:	e8 57 2a 00 00       	call   3cf6 <exit>
          }
        }
      }
      exit(0);
    129f:	83 ec 0c             	sub    $0xc,%esp
    12a2:	6a 00                	push   $0x0
    12a4:	e8 4d 2a 00 00       	call   3cf6 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
    12a9:	bb 00 00 00 00       	mov    $0x0,%ebx
    12ae:	eb 0e                	jmp    12be <createdelete+0x110>
    wait(NULL);
    12b0:	83 ec 0c             	sub    $0xc,%esp
    12b3:	6a 00                	push   $0x0
    12b5:	e8 44 2a 00 00       	call   3cfe <wait>
  for(pi = 0; pi < 4; pi++){
    12ba:	43                   	inc    %ebx
    12bb:	83 c4 10             	add    $0x10,%esp
    12be:	83 fb 03             	cmp    $0x3,%ebx
    12c1:	7e ed                	jle    12b0 <createdelete+0x102>
  }

  name[0] = name[1] = name[2] = 0;
    12c3:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
    12c7:	c6 45 d9 00          	movb   $0x0,-0x27(%ebp)
    12cb:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
  for(i = 0; i < N; i++){
    12cf:	be 00 00 00 00       	mov    $0x0,%esi
    12d4:	e9 8f 00 00 00       	jmp    1368 <createdelete+0x1ba>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
    12d9:	85 c0                	test   %eax,%eax
    12db:	78 3a                	js     1317 <createdelete+0x169>
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit(0);
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12dd:	8d 56 ff             	lea    -0x1(%esi),%edx
    12e0:	83 fa 08             	cmp    $0x8,%edx
    12e3:	76 51                	jbe    1336 <createdelete+0x188>
        printf(1, "oops createdelete %s did exist\n", name);
        exit(0);
      }
      if(fd >= 0)
    12e5:	85 c0                	test   %eax,%eax
    12e7:	79 70                	jns    1359 <createdelete+0x1ab>
    for(pi = 0; pi < 4; pi++){
    12e9:	43                   	inc    %ebx
    12ea:	83 fb 03             	cmp    $0x3,%ebx
    12ed:	7f 78                	jg     1367 <createdelete+0x1b9>
      name[0] = 'p' + pi;
    12ef:	8d 43 70             	lea    0x70(%ebx),%eax
    12f2:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    12f5:	8d 46 30             	lea    0x30(%esi),%eax
    12f8:	88 45 d9             	mov    %al,-0x27(%ebp)
      fd = open(name, 0);
    12fb:	83 ec 08             	sub    $0x8,%esp
    12fe:	6a 00                	push   $0x0
    1300:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1303:	50                   	push   %eax
    1304:	e8 2d 2a 00 00       	call   3d36 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1309:	83 c4 10             	add    $0x10,%esp
    130c:	85 f6                	test   %esi,%esi
    130e:	74 c9                	je     12d9 <createdelete+0x12b>
    1310:	83 fe 09             	cmp    $0x9,%esi
    1313:	7e c8                	jle    12dd <createdelete+0x12f>
    1315:	eb c2                	jmp    12d9 <createdelete+0x12b>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1317:	83 ec 04             	sub    $0x4,%esp
    131a:	8d 45 d8             	lea    -0x28(%ebp),%eax
    131d:	50                   	push   %eax
    131e:	68 68 52 00 00       	push   $0x5268
    1323:	6a 01                	push   $0x1
    1325:	e8 1b 2b 00 00       	call   3e45 <printf>
        exit(0);
    132a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1331:	e8 c0 29 00 00       	call   3cf6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1336:	85 c0                	test   %eax,%eax
    1338:	78 ab                	js     12e5 <createdelete+0x137>
        printf(1, "oops createdelete %s did exist\n", name);
    133a:	83 ec 04             	sub    $0x4,%esp
    133d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1340:	50                   	push   %eax
    1341:	68 8c 52 00 00       	push   $0x528c
    1346:	6a 01                	push   $0x1
    1348:	e8 f8 2a 00 00       	call   3e45 <printf>
        exit(0);
    134d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1354:	e8 9d 29 00 00       	call   3cf6 <exit>
        close(fd);
    1359:	83 ec 0c             	sub    $0xc,%esp
    135c:	50                   	push   %eax
    135d:	e8 bc 29 00 00       	call   3d1e <close>
    1362:	83 c4 10             	add    $0x10,%esp
    1365:	eb 82                	jmp    12e9 <createdelete+0x13b>
  for(i = 0; i < N; i++){
    1367:	46                   	inc    %esi
    1368:	83 fe 13             	cmp    $0x13,%esi
    136b:	7f 0a                	jg     1377 <createdelete+0x1c9>
    for(pi = 0; pi < 4; pi++){
    136d:	bb 00 00 00 00       	mov    $0x0,%ebx
    1372:	e9 73 ff ff ff       	jmp    12ea <createdelete+0x13c>
    }
  }

  for(i = 0; i < N; i++){
    1377:	be 00 00 00 00       	mov    $0x0,%esi
    137c:	eb 22                	jmp    13a0 <createdelete+0x1f2>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    137e:	8d 46 70             	lea    0x70(%esi),%eax
    1381:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    1384:	8d 46 30             	lea    0x30(%esi),%eax
    1387:	88 45 d9             	mov    %al,-0x27(%ebp)
      unlink(name);
    138a:	83 ec 0c             	sub    $0xc,%esp
    138d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1390:	50                   	push   %eax
    1391:	e8 b0 29 00 00       	call   3d46 <unlink>
    for(pi = 0; pi < 4; pi++){
    1396:	43                   	inc    %ebx
    1397:	83 c4 10             	add    $0x10,%esp
    139a:	83 fb 03             	cmp    $0x3,%ebx
    139d:	7e df                	jle    137e <createdelete+0x1d0>
  for(i = 0; i < N; i++){
    139f:	46                   	inc    %esi
    13a0:	83 fe 13             	cmp    $0x13,%esi
    13a3:	7f 07                	jg     13ac <createdelete+0x1fe>
    for(pi = 0; pi < 4; pi++){
    13a5:	bb 00 00 00 00       	mov    $0x0,%ebx
    13aa:	eb ee                	jmp    139a <createdelete+0x1ec>
    }
  }

  printf(1, "createdelete ok\n");
    13ac:	83 ec 08             	sub    $0x8,%esp
    13af:	68 bb 45 00 00       	push   $0x45bb
    13b4:	6a 01                	push   $0x1
    13b6:	e8 8a 2a 00 00       	call   3e45 <printf>
}
    13bb:	83 c4 10             	add    $0x10,%esp
    13be:	8d 65 f8             	lea    -0x8(%ebp),%esp
    13c1:	5b                   	pop    %ebx
    13c2:	5e                   	pop    %esi
    13c3:	5d                   	pop    %ebp
    13c4:	c3                   	ret    

000013c5 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    13c5:	f3 0f 1e fb          	endbr32 
    13c9:	55                   	push   %ebp
    13ca:	89 e5                	mov    %esp,%ebp
    13cc:	56                   	push   %esi
    13cd:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    13ce:	83 ec 08             	sub    $0x8,%esp
    13d1:	68 cc 45 00 00       	push   $0x45cc
    13d6:	6a 01                	push   $0x1
    13d8:	e8 68 2a 00 00       	call   3e45 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    13dd:	83 c4 08             	add    $0x8,%esp
    13e0:	68 02 02 00 00       	push   $0x202
    13e5:	68 dd 45 00 00       	push   $0x45dd
    13ea:	e8 47 29 00 00       	call   3d36 <open>
  if(fd < 0){
    13ef:	83 c4 10             	add    $0x10,%esp
    13f2:	85 c0                	test   %eax,%eax
    13f4:	0f 88 f0 00 00 00    	js     14ea <unlinkread+0x125>
    13fa:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit(0);
  }
  write(fd, "hello", 5);
    13fc:	83 ec 04             	sub    $0x4,%esp
    13ff:	6a 05                	push   $0x5
    1401:	68 02 46 00 00       	push   $0x4602
    1406:	50                   	push   %eax
    1407:	e8 0a 29 00 00       	call   3d16 <write>
  close(fd);
    140c:	89 1c 24             	mov    %ebx,(%esp)
    140f:	e8 0a 29 00 00       	call   3d1e <close>

  fd = open("unlinkread", O_RDWR);
    1414:	83 c4 08             	add    $0x8,%esp
    1417:	6a 02                	push   $0x2
    1419:	68 dd 45 00 00       	push   $0x45dd
    141e:	e8 13 29 00 00       	call   3d36 <open>
    1423:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1425:	83 c4 10             	add    $0x10,%esp
    1428:	85 c0                	test   %eax,%eax
    142a:	0f 88 d5 00 00 00    	js     1505 <unlinkread+0x140>
    printf(1, "open unlinkread failed\n");
    exit(0);
  }
  if(unlink("unlinkread") != 0){
    1430:	83 ec 0c             	sub    $0xc,%esp
    1433:	68 dd 45 00 00       	push   $0x45dd
    1438:	e8 09 29 00 00       	call   3d46 <unlink>
    143d:	83 c4 10             	add    $0x10,%esp
    1440:	85 c0                	test   %eax,%eax
    1442:	0f 85 d8 00 00 00    	jne    1520 <unlinkread+0x15b>
    printf(1, "unlink unlinkread failed\n");
    exit(0);
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1448:	83 ec 08             	sub    $0x8,%esp
    144b:	68 02 02 00 00       	push   $0x202
    1450:	68 dd 45 00 00       	push   $0x45dd
    1455:	e8 dc 28 00 00       	call   3d36 <open>
    145a:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    145c:	83 c4 0c             	add    $0xc,%esp
    145f:	6a 03                	push   $0x3
    1461:	68 3a 46 00 00       	push   $0x463a
    1466:	50                   	push   %eax
    1467:	e8 aa 28 00 00       	call   3d16 <write>
  close(fd1);
    146c:	89 34 24             	mov    %esi,(%esp)
    146f:	e8 aa 28 00 00       	call   3d1e <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1474:	83 c4 0c             	add    $0xc,%esp
    1477:	68 00 20 00 00       	push   $0x2000
    147c:	68 20 89 00 00       	push   $0x8920
    1481:	53                   	push   %ebx
    1482:	e8 87 28 00 00       	call   3d0e <read>
    1487:	83 c4 10             	add    $0x10,%esp
    148a:	83 f8 05             	cmp    $0x5,%eax
    148d:	0f 85 a8 00 00 00    	jne    153b <unlinkread+0x176>
    printf(1, "unlinkread read failed");
    exit(0);
  }
  if(buf[0] != 'h'){
    1493:	80 3d 20 89 00 00 68 	cmpb   $0x68,0x8920
    149a:	0f 85 b6 00 00 00    	jne    1556 <unlinkread+0x191>
    printf(1, "unlinkread wrong data\n");
    exit(0);
  }
  if(write(fd, buf, 10) != 10){
    14a0:	83 ec 04             	sub    $0x4,%esp
    14a3:	6a 0a                	push   $0xa
    14a5:	68 20 89 00 00       	push   $0x8920
    14aa:	53                   	push   %ebx
    14ab:	e8 66 28 00 00       	call   3d16 <write>
    14b0:	83 c4 10             	add    $0x10,%esp
    14b3:	83 f8 0a             	cmp    $0xa,%eax
    14b6:	0f 85 b5 00 00 00    	jne    1571 <unlinkread+0x1ac>
    printf(1, "unlinkread write failed\n");
    exit(0);
  }
  close(fd);
    14bc:	83 ec 0c             	sub    $0xc,%esp
    14bf:	53                   	push   %ebx
    14c0:	e8 59 28 00 00       	call   3d1e <close>
  unlink("unlinkread");
    14c5:	c7 04 24 dd 45 00 00 	movl   $0x45dd,(%esp)
    14cc:	e8 75 28 00 00       	call   3d46 <unlink>
  printf(1, "unlinkread ok\n");
    14d1:	83 c4 08             	add    $0x8,%esp
    14d4:	68 85 46 00 00       	push   $0x4685
    14d9:	6a 01                	push   $0x1
    14db:	e8 65 29 00 00       	call   3e45 <printf>
}
    14e0:	83 c4 10             	add    $0x10,%esp
    14e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    14e6:	5b                   	pop    %ebx
    14e7:	5e                   	pop    %esi
    14e8:	5d                   	pop    %ebp
    14e9:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    14ea:	83 ec 08             	sub    $0x8,%esp
    14ed:	68 e8 45 00 00       	push   $0x45e8
    14f2:	6a 01                	push   $0x1
    14f4:	e8 4c 29 00 00       	call   3e45 <printf>
    exit(0);
    14f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1500:	e8 f1 27 00 00       	call   3cf6 <exit>
    printf(1, "open unlinkread failed\n");
    1505:	83 ec 08             	sub    $0x8,%esp
    1508:	68 08 46 00 00       	push   $0x4608
    150d:	6a 01                	push   $0x1
    150f:	e8 31 29 00 00       	call   3e45 <printf>
    exit(0);
    1514:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    151b:	e8 d6 27 00 00       	call   3cf6 <exit>
    printf(1, "unlink unlinkread failed\n");
    1520:	83 ec 08             	sub    $0x8,%esp
    1523:	68 20 46 00 00       	push   $0x4620
    1528:	6a 01                	push   $0x1
    152a:	e8 16 29 00 00       	call   3e45 <printf>
    exit(0);
    152f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1536:	e8 bb 27 00 00       	call   3cf6 <exit>
    printf(1, "unlinkread read failed");
    153b:	83 ec 08             	sub    $0x8,%esp
    153e:	68 3e 46 00 00       	push   $0x463e
    1543:	6a 01                	push   $0x1
    1545:	e8 fb 28 00 00       	call   3e45 <printf>
    exit(0);
    154a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1551:	e8 a0 27 00 00       	call   3cf6 <exit>
    printf(1, "unlinkread wrong data\n");
    1556:	83 ec 08             	sub    $0x8,%esp
    1559:	68 55 46 00 00       	push   $0x4655
    155e:	6a 01                	push   $0x1
    1560:	e8 e0 28 00 00       	call   3e45 <printf>
    exit(0);
    1565:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    156c:	e8 85 27 00 00       	call   3cf6 <exit>
    printf(1, "unlinkread write failed\n");
    1571:	83 ec 08             	sub    $0x8,%esp
    1574:	68 6c 46 00 00       	push   $0x466c
    1579:	6a 01                	push   $0x1
    157b:	e8 c5 28 00 00       	call   3e45 <printf>
    exit(0);
    1580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1587:	e8 6a 27 00 00       	call   3cf6 <exit>

0000158c <linktest>:

void
linktest(void)
{
    158c:	f3 0f 1e fb          	endbr32 
    1590:	55                   	push   %ebp
    1591:	89 e5                	mov    %esp,%ebp
    1593:	53                   	push   %ebx
    1594:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    1597:	68 94 46 00 00       	push   $0x4694
    159c:	6a 01                	push   $0x1
    159e:	e8 a2 28 00 00       	call   3e45 <printf>

  unlink("lf1");
    15a3:	c7 04 24 9e 46 00 00 	movl   $0x469e,(%esp)
    15aa:	e8 97 27 00 00       	call   3d46 <unlink>
  unlink("lf2");
    15af:	c7 04 24 a2 46 00 00 	movl   $0x46a2,(%esp)
    15b6:	e8 8b 27 00 00       	call   3d46 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    15bb:	83 c4 08             	add    $0x8,%esp
    15be:	68 02 02 00 00       	push   $0x202
    15c3:	68 9e 46 00 00       	push   $0x469e
    15c8:	e8 69 27 00 00       	call   3d36 <open>
  if(fd < 0){
    15cd:	83 c4 10             	add    $0x10,%esp
    15d0:	85 c0                	test   %eax,%eax
    15d2:	0f 88 2a 01 00 00    	js     1702 <linktest+0x176>
    15d8:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit(0);
  }
  if(write(fd, "hello", 5) != 5){
    15da:	83 ec 04             	sub    $0x4,%esp
    15dd:	6a 05                	push   $0x5
    15df:	68 02 46 00 00       	push   $0x4602
    15e4:	50                   	push   %eax
    15e5:	e8 2c 27 00 00       	call   3d16 <write>
    15ea:	83 c4 10             	add    $0x10,%esp
    15ed:	83 f8 05             	cmp    $0x5,%eax
    15f0:	0f 85 27 01 00 00    	jne    171d <linktest+0x191>
    printf(1, "write lf1 failed\n");
    exit(0);
  }
  close(fd);
    15f6:	83 ec 0c             	sub    $0xc,%esp
    15f9:	53                   	push   %ebx
    15fa:	e8 1f 27 00 00       	call   3d1e <close>

  if(link("lf1", "lf2") < 0){
    15ff:	83 c4 08             	add    $0x8,%esp
    1602:	68 a2 46 00 00       	push   $0x46a2
    1607:	68 9e 46 00 00       	push   $0x469e
    160c:	e8 45 27 00 00       	call   3d56 <link>
    1611:	83 c4 10             	add    $0x10,%esp
    1614:	85 c0                	test   %eax,%eax
    1616:	0f 88 1c 01 00 00    	js     1738 <linktest+0x1ac>
    printf(1, "link lf1 lf2 failed\n");
    exit(0);
  }
  unlink("lf1");
    161c:	83 ec 0c             	sub    $0xc,%esp
    161f:	68 9e 46 00 00       	push   $0x469e
    1624:	e8 1d 27 00 00       	call   3d46 <unlink>

  if(open("lf1", 0) >= 0){
    1629:	83 c4 08             	add    $0x8,%esp
    162c:	6a 00                	push   $0x0
    162e:	68 9e 46 00 00       	push   $0x469e
    1633:	e8 fe 26 00 00       	call   3d36 <open>
    1638:	83 c4 10             	add    $0x10,%esp
    163b:	85 c0                	test   %eax,%eax
    163d:	0f 89 10 01 00 00    	jns    1753 <linktest+0x1c7>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit(0);
  }

  fd = open("lf2", 0);
    1643:	83 ec 08             	sub    $0x8,%esp
    1646:	6a 00                	push   $0x0
    1648:	68 a2 46 00 00       	push   $0x46a2
    164d:	e8 e4 26 00 00       	call   3d36 <open>
    1652:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1654:	83 c4 10             	add    $0x10,%esp
    1657:	85 c0                	test   %eax,%eax
    1659:	0f 88 0f 01 00 00    	js     176e <linktest+0x1e2>
    printf(1, "open lf2 failed\n");
    exit(0);
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    165f:	83 ec 04             	sub    $0x4,%esp
    1662:	68 00 20 00 00       	push   $0x2000
    1667:	68 20 89 00 00       	push   $0x8920
    166c:	50                   	push   %eax
    166d:	e8 9c 26 00 00       	call   3d0e <read>
    1672:	83 c4 10             	add    $0x10,%esp
    1675:	83 f8 05             	cmp    $0x5,%eax
    1678:	0f 85 0b 01 00 00    	jne    1789 <linktest+0x1fd>
    printf(1, "read lf2 failed\n");
    exit(0);
  }
  close(fd);
    167e:	83 ec 0c             	sub    $0xc,%esp
    1681:	53                   	push   %ebx
    1682:	e8 97 26 00 00       	call   3d1e <close>

  if(link("lf2", "lf2") >= 0){
    1687:	83 c4 08             	add    $0x8,%esp
    168a:	68 a2 46 00 00       	push   $0x46a2
    168f:	68 a2 46 00 00       	push   $0x46a2
    1694:	e8 bd 26 00 00       	call   3d56 <link>
    1699:	83 c4 10             	add    $0x10,%esp
    169c:	85 c0                	test   %eax,%eax
    169e:	0f 89 00 01 00 00    	jns    17a4 <linktest+0x218>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit(0);
  }

  unlink("lf2");
    16a4:	83 ec 0c             	sub    $0xc,%esp
    16a7:	68 a2 46 00 00       	push   $0x46a2
    16ac:	e8 95 26 00 00       	call   3d46 <unlink>
  if(link("lf2", "lf1") >= 0){
    16b1:	83 c4 08             	add    $0x8,%esp
    16b4:	68 9e 46 00 00       	push   $0x469e
    16b9:	68 a2 46 00 00       	push   $0x46a2
    16be:	e8 93 26 00 00       	call   3d56 <link>
    16c3:	83 c4 10             	add    $0x10,%esp
    16c6:	85 c0                	test   %eax,%eax
    16c8:	0f 89 f1 00 00 00    	jns    17bf <linktest+0x233>
    printf(1, "link non-existant succeeded! oops\n");
    exit(0);
  }

  if(link(".", "lf1") >= 0){
    16ce:	83 ec 08             	sub    $0x8,%esp
    16d1:	68 9e 46 00 00       	push   $0x469e
    16d6:	68 66 49 00 00       	push   $0x4966
    16db:	e8 76 26 00 00       	call   3d56 <link>
    16e0:	83 c4 10             	add    $0x10,%esp
    16e3:	85 c0                	test   %eax,%eax
    16e5:	0f 89 ef 00 00 00    	jns    17da <linktest+0x24e>
    printf(1, "link . lf1 succeeded! oops\n");
    exit(0);
  }

  printf(1, "linktest ok\n");
    16eb:	83 ec 08             	sub    $0x8,%esp
    16ee:	68 3c 47 00 00       	push   $0x473c
    16f3:	6a 01                	push   $0x1
    16f5:	e8 4b 27 00 00       	call   3e45 <printf>
}
    16fa:	83 c4 10             	add    $0x10,%esp
    16fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1700:	c9                   	leave  
    1701:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1702:	83 ec 08             	sub    $0x8,%esp
    1705:	68 a6 46 00 00       	push   $0x46a6
    170a:	6a 01                	push   $0x1
    170c:	e8 34 27 00 00       	call   3e45 <printf>
    exit(0);
    1711:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1718:	e8 d9 25 00 00       	call   3cf6 <exit>
    printf(1, "write lf1 failed\n");
    171d:	83 ec 08             	sub    $0x8,%esp
    1720:	68 b9 46 00 00       	push   $0x46b9
    1725:	6a 01                	push   $0x1
    1727:	e8 19 27 00 00       	call   3e45 <printf>
    exit(0);
    172c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1733:	e8 be 25 00 00       	call   3cf6 <exit>
    printf(1, "link lf1 lf2 failed\n");
    1738:	83 ec 08             	sub    $0x8,%esp
    173b:	68 cb 46 00 00       	push   $0x46cb
    1740:	6a 01                	push   $0x1
    1742:	e8 fe 26 00 00       	call   3e45 <printf>
    exit(0);
    1747:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    174e:	e8 a3 25 00 00       	call   3cf6 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1753:	83 ec 08             	sub    $0x8,%esp
    1756:	68 ac 52 00 00       	push   $0x52ac
    175b:	6a 01                	push   $0x1
    175d:	e8 e3 26 00 00       	call   3e45 <printf>
    exit(0);
    1762:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1769:	e8 88 25 00 00       	call   3cf6 <exit>
    printf(1, "open lf2 failed\n");
    176e:	83 ec 08             	sub    $0x8,%esp
    1771:	68 e0 46 00 00       	push   $0x46e0
    1776:	6a 01                	push   $0x1
    1778:	e8 c8 26 00 00       	call   3e45 <printf>
    exit(0);
    177d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1784:	e8 6d 25 00 00       	call   3cf6 <exit>
    printf(1, "read lf2 failed\n");
    1789:	83 ec 08             	sub    $0x8,%esp
    178c:	68 f1 46 00 00       	push   $0x46f1
    1791:	6a 01                	push   $0x1
    1793:	e8 ad 26 00 00       	call   3e45 <printf>
    exit(0);
    1798:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    179f:	e8 52 25 00 00       	call   3cf6 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    17a4:	83 ec 08             	sub    $0x8,%esp
    17a7:	68 02 47 00 00       	push   $0x4702
    17ac:	6a 01                	push   $0x1
    17ae:	e8 92 26 00 00       	call   3e45 <printf>
    exit(0);
    17b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    17ba:	e8 37 25 00 00       	call   3cf6 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    17bf:	83 ec 08             	sub    $0x8,%esp
    17c2:	68 d4 52 00 00       	push   $0x52d4
    17c7:	6a 01                	push   $0x1
    17c9:	e8 77 26 00 00       	call   3e45 <printf>
    exit(0);
    17ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    17d5:	e8 1c 25 00 00       	call   3cf6 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    17da:	83 ec 08             	sub    $0x8,%esp
    17dd:	68 20 47 00 00       	push   $0x4720
    17e2:	6a 01                	push   $0x1
    17e4:	e8 5c 26 00 00       	call   3e45 <printf>
    exit(0);
    17e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    17f0:	e8 01 25 00 00       	call   3cf6 <exit>

000017f5 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    17f5:	f3 0f 1e fb          	endbr32 
    17f9:	55                   	push   %ebp
    17fa:	89 e5                	mov    %esp,%ebp
    17fc:	57                   	push   %edi
    17fd:	56                   	push   %esi
    17fe:	53                   	push   %ebx
    17ff:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1802:	68 49 47 00 00       	push   $0x4749
    1807:	6a 01                	push   $0x1
    1809:	e8 37 26 00 00       	call   3e45 <printf>
  file[0] = 'C';
    180e:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1812:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1816:	83 c4 10             	add    $0x10,%esp
    1819:	bb 00 00 00 00       	mov    $0x0,%ebx
    181e:	eb 55                	jmp    1875 <concreate+0x80>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    1820:	85 f6                	test   %esi,%esi
    1822:	75 13                	jne    1837 <concreate+0x42>
    1824:	b9 05 00 00 00       	mov    $0x5,%ecx
    1829:	89 d8                	mov    %ebx,%eax
    182b:	99                   	cltd   
    182c:	f7 f9                	idiv   %ecx
    182e:	83 fa 01             	cmp    $0x1,%edx
    1831:	0f 84 90 00 00 00    	je     18c7 <concreate+0xd2>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1837:	83 ec 08             	sub    $0x8,%esp
    183a:	68 02 02 00 00       	push   $0x202
    183f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1842:	50                   	push   %eax
    1843:	e8 ee 24 00 00       	call   3d36 <open>
      if(fd < 0){
    1848:	83 c4 10             	add    $0x10,%esp
    184b:	85 c0                	test   %eax,%eax
    184d:	0f 88 8a 00 00 00    	js     18dd <concreate+0xe8>
        printf(1, "concreate create %s failed\n", file);
        exit(0);
      }
      close(fd);
    1853:	83 ec 0c             	sub    $0xc,%esp
    1856:	50                   	push   %eax
    1857:	e8 c2 24 00 00       	call   3d1e <close>
    185c:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    185f:	85 f6                	test   %esi,%esi
    1861:	0f 84 95 00 00 00    	je     18fc <concreate+0x107>
      exit(0);
    else
      wait(NULL);
    1867:	83 ec 0c             	sub    $0xc,%esp
    186a:	6a 00                	push   $0x0
    186c:	e8 8d 24 00 00       	call   3cfe <wait>
  for(i = 0; i < 40; i++){
    1871:	43                   	inc    %ebx
    1872:	83 c4 10             	add    $0x10,%esp
    1875:	83 fb 27             	cmp    $0x27,%ebx
    1878:	0f 8f 88 00 00 00    	jg     1906 <concreate+0x111>
    file[1] = '0' + i;
    187e:	8d 43 30             	lea    0x30(%ebx),%eax
    1881:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1884:	83 ec 0c             	sub    $0xc,%esp
    1887:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    188a:	50                   	push   %eax
    188b:	e8 b6 24 00 00       	call   3d46 <unlink>
    pid = fork();
    1890:	e8 59 24 00 00       	call   3cee <fork>
    1895:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    1897:	83 c4 10             	add    $0x10,%esp
    189a:	85 c0                	test   %eax,%eax
    189c:	74 82                	je     1820 <concreate+0x2b>
    189e:	b9 03 00 00 00       	mov    $0x3,%ecx
    18a3:	89 d8                	mov    %ebx,%eax
    18a5:	99                   	cltd   
    18a6:	f7 f9                	idiv   %ecx
    18a8:	83 fa 01             	cmp    $0x1,%edx
    18ab:	0f 85 6f ff ff ff    	jne    1820 <concreate+0x2b>
      link("C0", file);
    18b1:	83 ec 08             	sub    $0x8,%esp
    18b4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    18b7:	50                   	push   %eax
    18b8:	68 59 47 00 00       	push   $0x4759
    18bd:	e8 94 24 00 00       	call   3d56 <link>
    18c2:	83 c4 10             	add    $0x10,%esp
    18c5:	eb 98                	jmp    185f <concreate+0x6a>
      link("C0", file);
    18c7:	83 ec 08             	sub    $0x8,%esp
    18ca:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    18cd:	50                   	push   %eax
    18ce:	68 59 47 00 00       	push   $0x4759
    18d3:	e8 7e 24 00 00       	call   3d56 <link>
    18d8:	83 c4 10             	add    $0x10,%esp
    18db:	eb 82                	jmp    185f <concreate+0x6a>
        printf(1, "concreate create %s failed\n", file);
    18dd:	83 ec 04             	sub    $0x4,%esp
    18e0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    18e3:	50                   	push   %eax
    18e4:	68 5c 47 00 00       	push   $0x475c
    18e9:	6a 01                	push   $0x1
    18eb:	e8 55 25 00 00       	call   3e45 <printf>
        exit(0);
    18f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    18f7:	e8 fa 23 00 00       	call   3cf6 <exit>
      exit(0);
    18fc:	83 ec 0c             	sub    $0xc,%esp
    18ff:	6a 00                	push   $0x0
    1901:	e8 f0 23 00 00       	call   3cf6 <exit>
  }

  memset(fa, 0, sizeof(fa));
    1906:	83 ec 04             	sub    $0x4,%esp
    1909:	6a 28                	push   $0x28
    190b:	6a 00                	push   $0x0
    190d:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1910:	50                   	push   %eax
    1911:	e8 a3 22 00 00       	call   3bb9 <memset>
  fd = open(".", 0);
    1916:	83 c4 08             	add    $0x8,%esp
    1919:	6a 00                	push   $0x0
    191b:	68 66 49 00 00       	push   $0x4966
    1920:	e8 11 24 00 00       	call   3d36 <open>
    1925:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1927:	83 c4 10             	add    $0x10,%esp
  n = 0;
    192a:	be 00 00 00 00       	mov    $0x0,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    192f:	83 ec 04             	sub    $0x4,%esp
    1932:	6a 10                	push   $0x10
    1934:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1937:	50                   	push   %eax
    1938:	53                   	push   %ebx
    1939:	e8 d0 23 00 00       	call   3d0e <read>
    193e:	83 c4 10             	add    $0x10,%esp
    1941:	85 c0                	test   %eax,%eax
    1943:	7e 6c                	jle    19b1 <concreate+0x1bc>
    if(de.inum == 0)
    1945:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    194a:	74 e3                	je     192f <concreate+0x13a>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    194c:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    1950:	75 dd                	jne    192f <concreate+0x13a>
    1952:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    1956:	75 d7                	jne    192f <concreate+0x13a>
      i = de.name[1] - '0';
    1958:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    195c:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    195f:	83 f8 27             	cmp    $0x27,%eax
    1962:	77 0f                	ja     1973 <concreate+0x17e>
        printf(1, "concreate weird file %s\n", de.name);
        exit(0);
      }
      if(fa[i]){
    1964:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    1969:	75 27                	jne    1992 <concreate+0x19d>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit(0);
      }
      fa[i] = 1;
    196b:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    1970:	46                   	inc    %esi
    1971:	eb bc                	jmp    192f <concreate+0x13a>
        printf(1, "concreate weird file %s\n", de.name);
    1973:	83 ec 04             	sub    $0x4,%esp
    1976:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1979:	50                   	push   %eax
    197a:	68 78 47 00 00       	push   $0x4778
    197f:	6a 01                	push   $0x1
    1981:	e8 bf 24 00 00       	call   3e45 <printf>
        exit(0);
    1986:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    198d:	e8 64 23 00 00       	call   3cf6 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1992:	83 ec 04             	sub    $0x4,%esp
    1995:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1998:	50                   	push   %eax
    1999:	68 91 47 00 00       	push   $0x4791
    199e:	6a 01                	push   $0x1
    19a0:	e8 a0 24 00 00       	call   3e45 <printf>
        exit(0);
    19a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19ac:	e8 45 23 00 00       	call   3cf6 <exit>
    }
  }
  close(fd);
    19b1:	83 ec 0c             	sub    $0xc,%esp
    19b4:	53                   	push   %ebx
    19b5:	e8 64 23 00 00       	call   3d1e <close>

  if(n != 40){
    19ba:	83 c4 10             	add    $0x10,%esp
    19bd:	83 fe 28             	cmp    $0x28,%esi
    19c0:	75 07                	jne    19c9 <concreate+0x1d4>
    printf(1, "concreate not enough files in directory listing\n");
    exit(0);
  }

  for(i = 0; i < 40; i++){
    19c2:	bb 00 00 00 00       	mov    $0x0,%ebx
    19c7:	eb 73                	jmp    1a3c <concreate+0x247>
    printf(1, "concreate not enough files in directory listing\n");
    19c9:	83 ec 08             	sub    $0x8,%esp
    19cc:	68 f8 52 00 00       	push   $0x52f8
    19d1:	6a 01                	push   $0x1
    19d3:	e8 6d 24 00 00       	call   3e45 <printf>
    exit(0);
    19d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19df:	e8 12 23 00 00       	call   3cf6 <exit>
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    19e4:	83 ec 08             	sub    $0x8,%esp
    19e7:	68 31 50 00 00       	push   $0x5031
    19ec:	6a 01                	push   $0x1
    19ee:	e8 52 24 00 00       	call   3e45 <printf>
      exit(0);
    19f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    19fa:	e8 f7 22 00 00       	call   3cf6 <exit>
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
    } else {
      unlink(file);
    19ff:	83 ec 0c             	sub    $0xc,%esp
    1a02:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1a05:	57                   	push   %edi
    1a06:	e8 3b 23 00 00       	call   3d46 <unlink>
      unlink(file);
    1a0b:	89 3c 24             	mov    %edi,(%esp)
    1a0e:	e8 33 23 00 00       	call   3d46 <unlink>
      unlink(file);
    1a13:	89 3c 24             	mov    %edi,(%esp)
    1a16:	e8 2b 23 00 00       	call   3d46 <unlink>
      unlink(file);
    1a1b:	89 3c 24             	mov    %edi,(%esp)
    1a1e:	e8 23 23 00 00       	call   3d46 <unlink>
    1a23:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a26:	85 f6                	test   %esi,%esi
    1a28:	0f 84 9a 00 00 00    	je     1ac8 <concreate+0x2d3>
      exit(0);
    else
      wait(NULL);
    1a2e:	83 ec 0c             	sub    $0xc,%esp
    1a31:	6a 00                	push   $0x0
    1a33:	e8 c6 22 00 00       	call   3cfe <wait>
  for(i = 0; i < 40; i++){
    1a38:	43                   	inc    %ebx
    1a39:	83 c4 10             	add    $0x10,%esp
    1a3c:	83 fb 27             	cmp    $0x27,%ebx
    1a3f:	0f 8f 8d 00 00 00    	jg     1ad2 <concreate+0x2dd>
    file[1] = '0' + i;
    1a45:	8d 43 30             	lea    0x30(%ebx),%eax
    1a48:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1a4b:	e8 9e 22 00 00       	call   3cee <fork>
    1a50:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    1a52:	85 c0                	test   %eax,%eax
    1a54:	78 8e                	js     19e4 <concreate+0x1ef>
    if(((i % 3) == 0 && pid == 0) ||
    1a56:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a5b:	89 d8                	mov    %ebx,%eax
    1a5d:	99                   	cltd   
    1a5e:	f7 f9                	idiv   %ecx
    1a60:	85 d2                	test   %edx,%edx
    1a62:	75 04                	jne    1a68 <concreate+0x273>
    1a64:	85 f6                	test   %esi,%esi
    1a66:	74 09                	je     1a71 <concreate+0x27c>
    1a68:	83 fa 01             	cmp    $0x1,%edx
    1a6b:	75 92                	jne    19ff <concreate+0x20a>
       ((i % 3) == 1 && pid != 0)){
    1a6d:	85 f6                	test   %esi,%esi
    1a6f:	74 8e                	je     19ff <concreate+0x20a>
      close(open(file, 0));
    1a71:	83 ec 08             	sub    $0x8,%esp
    1a74:	6a 00                	push   $0x0
    1a76:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1a79:	57                   	push   %edi
    1a7a:	e8 b7 22 00 00       	call   3d36 <open>
    1a7f:	89 04 24             	mov    %eax,(%esp)
    1a82:	e8 97 22 00 00       	call   3d1e <close>
      close(open(file, 0));
    1a87:	83 c4 08             	add    $0x8,%esp
    1a8a:	6a 00                	push   $0x0
    1a8c:	57                   	push   %edi
    1a8d:	e8 a4 22 00 00       	call   3d36 <open>
    1a92:	89 04 24             	mov    %eax,(%esp)
    1a95:	e8 84 22 00 00       	call   3d1e <close>
      close(open(file, 0));
    1a9a:	83 c4 08             	add    $0x8,%esp
    1a9d:	6a 00                	push   $0x0
    1a9f:	57                   	push   %edi
    1aa0:	e8 91 22 00 00       	call   3d36 <open>
    1aa5:	89 04 24             	mov    %eax,(%esp)
    1aa8:	e8 71 22 00 00       	call   3d1e <close>
      close(open(file, 0));
    1aad:	83 c4 08             	add    $0x8,%esp
    1ab0:	6a 00                	push   $0x0
    1ab2:	57                   	push   %edi
    1ab3:	e8 7e 22 00 00       	call   3d36 <open>
    1ab8:	89 04 24             	mov    %eax,(%esp)
    1abb:	e8 5e 22 00 00       	call   3d1e <close>
    1ac0:	83 c4 10             	add    $0x10,%esp
    1ac3:	e9 5e ff ff ff       	jmp    1a26 <concreate+0x231>
      exit(0);
    1ac8:	83 ec 0c             	sub    $0xc,%esp
    1acb:	6a 00                	push   $0x0
    1acd:	e8 24 22 00 00       	call   3cf6 <exit>
  }

  printf(1, "concreate ok\n");
    1ad2:	83 ec 08             	sub    $0x8,%esp
    1ad5:	68 ae 47 00 00       	push   $0x47ae
    1ada:	6a 01                	push   $0x1
    1adc:	e8 64 23 00 00       	call   3e45 <printf>
}
    1ae1:	83 c4 10             	add    $0x10,%esp
    1ae4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ae7:	5b                   	pop    %ebx
    1ae8:	5e                   	pop    %esi
    1ae9:	5f                   	pop    %edi
    1aea:	5d                   	pop    %ebp
    1aeb:	c3                   	ret    

00001aec <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1aec:	f3 0f 1e fb          	endbr32 
    1af0:	55                   	push   %ebp
    1af1:	89 e5                	mov    %esp,%ebp
    1af3:	57                   	push   %edi
    1af4:	56                   	push   %esi
    1af5:	53                   	push   %ebx
    1af6:	83 ec 14             	sub    $0x14,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1af9:	68 bc 47 00 00       	push   $0x47bc
    1afe:	6a 01                	push   $0x1
    1b00:	e8 40 23 00 00       	call   3e45 <printf>

  unlink("x");
    1b05:	c7 04 24 49 4a 00 00 	movl   $0x4a49,(%esp)
    1b0c:	e8 35 22 00 00       	call   3d46 <unlink>
  pid = fork();
    1b11:	e8 d8 21 00 00       	call   3cee <fork>
  if(pid < 0){
    1b16:	83 c4 10             	add    $0x10,%esp
    1b19:	85 c0                	test   %eax,%eax
    1b1b:	78 10                	js     1b2d <linkunlink+0x41>
    1b1d:	89 c7                	mov    %eax,%edi
    printf(1, "fork failed\n");
    exit(0);
  }

  unsigned int x = (pid ? 1 : 97);
    1b1f:	74 27                	je     1b48 <linkunlink+0x5c>
    1b21:	bb 01 00 00 00       	mov    $0x1,%ebx
    1b26:	be 00 00 00 00       	mov    $0x0,%esi
    1b2b:	eb 52                	jmp    1b7f <linkunlink+0x93>
    printf(1, "fork failed\n");
    1b2d:	83 ec 08             	sub    $0x8,%esp
    1b30:	68 31 50 00 00       	push   $0x5031
    1b35:	6a 01                	push   $0x1
    1b37:	e8 09 23 00 00       	call   3e45 <printf>
    exit(0);
    1b3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1b43:	e8 ae 21 00 00       	call   3cf6 <exit>
  unsigned int x = (pid ? 1 : 97);
    1b48:	bb 61 00 00 00       	mov    $0x61,%ebx
    1b4d:	eb d7                	jmp    1b26 <linkunlink+0x3a>
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    1b4f:	83 ec 08             	sub    $0x8,%esp
    1b52:	68 02 02 00 00       	push   $0x202
    1b57:	68 49 4a 00 00       	push   $0x4a49
    1b5c:	e8 d5 21 00 00       	call   3d36 <open>
    1b61:	89 04 24             	mov    %eax,(%esp)
    1b64:	e8 b5 21 00 00       	call   3d1e <close>
    1b69:	83 c4 10             	add    $0x10,%esp
    1b6c:	eb 10                	jmp    1b7e <linkunlink+0x92>
    } else if((x % 3) == 1){
      link("cat", "x");
    } else {
      unlink("x");
    1b6e:	83 ec 0c             	sub    $0xc,%esp
    1b71:	68 49 4a 00 00       	push   $0x4a49
    1b76:	e8 cb 21 00 00       	call   3d46 <unlink>
    1b7b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b7e:	46                   	inc    %esi
    1b7f:	83 fe 63             	cmp    $0x63,%esi
    1b82:	7f 56                	jg     1bda <linkunlink+0xee>
    x = x * 1103515245 + 12345;
    1b84:	89 d8                	mov    %ebx,%eax
    1b86:	c1 e0 09             	shl    $0x9,%eax
    1b89:	29 d8                	sub    %ebx,%eax
    1b8b:	8d 14 83             	lea    (%ebx,%eax,4),%edx
    1b8e:	89 d0                	mov    %edx,%eax
    1b90:	c1 e0 09             	shl    $0x9,%eax
    1b93:	29 d0                	sub    %edx,%eax
    1b95:	01 c0                	add    %eax,%eax
    1b97:	01 d8                	add    %ebx,%eax
    1b99:	89 c2                	mov    %eax,%edx
    1b9b:	c1 e2 05             	shl    $0x5,%edx
    1b9e:	01 d0                	add    %edx,%eax
    1ba0:	c1 e0 02             	shl    $0x2,%eax
    1ba3:	29 d8                	sub    %ebx,%eax
    1ba5:	8d 9c 83 39 30 00 00 	lea    0x3039(%ebx,%eax,4),%ebx
    if((x % 3) == 0){
    1bac:	b9 03 00 00 00       	mov    $0x3,%ecx
    1bb1:	89 d8                	mov    %ebx,%eax
    1bb3:	ba 00 00 00 00       	mov    $0x0,%edx
    1bb8:	f7 f1                	div    %ecx
    1bba:	85 d2                	test   %edx,%edx
    1bbc:	74 91                	je     1b4f <linkunlink+0x63>
    } else if((x % 3) == 1){
    1bbe:	83 fa 01             	cmp    $0x1,%edx
    1bc1:	75 ab                	jne    1b6e <linkunlink+0x82>
      link("cat", "x");
    1bc3:	83 ec 08             	sub    $0x8,%esp
    1bc6:	68 49 4a 00 00       	push   $0x4a49
    1bcb:	68 cd 47 00 00       	push   $0x47cd
    1bd0:	e8 81 21 00 00       	call   3d56 <link>
    1bd5:	83 c4 10             	add    $0x10,%esp
    1bd8:	eb a4                	jmp    1b7e <linkunlink+0x92>
    }
  }

  if(pid)
    1bda:	85 ff                	test   %edi,%edi
    1bdc:	74 21                	je     1bff <linkunlink+0x113>
    wait(NULL);
    1bde:	83 ec 0c             	sub    $0xc,%esp
    1be1:	6a 00                	push   $0x0
    1be3:	e8 16 21 00 00       	call   3cfe <wait>
  else
    exit(0);

  printf(1, "linkunlink ok\n");
    1be8:	83 c4 08             	add    $0x8,%esp
    1beb:	68 d1 47 00 00       	push   $0x47d1
    1bf0:	6a 01                	push   $0x1
    1bf2:	e8 4e 22 00 00       	call   3e45 <printf>
}
    1bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1bfa:	5b                   	pop    %ebx
    1bfb:	5e                   	pop    %esi
    1bfc:	5f                   	pop    %edi
    1bfd:	5d                   	pop    %ebp
    1bfe:	c3                   	ret    
    exit(0);
    1bff:	83 ec 0c             	sub    $0xc,%esp
    1c02:	6a 00                	push   $0x0
    1c04:	e8 ed 20 00 00       	call   3cf6 <exit>

00001c09 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1c09:	f3 0f 1e fb          	endbr32 
    1c0d:	55                   	push   %ebp
    1c0e:	89 e5                	mov    %esp,%ebp
    1c10:	53                   	push   %ebx
    1c11:	83 ec 1c             	sub    $0x1c,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1c14:	68 e0 47 00 00       	push   $0x47e0
    1c19:	6a 01                	push   $0x1
    1c1b:	e8 25 22 00 00       	call   3e45 <printf>
  unlink("bd");
    1c20:	c7 04 24 ed 47 00 00 	movl   $0x47ed,(%esp)
    1c27:	e8 1a 21 00 00       	call   3d46 <unlink>

  fd = open("bd", O_CREATE);
    1c2c:	83 c4 08             	add    $0x8,%esp
    1c2f:	68 00 02 00 00       	push   $0x200
    1c34:	68 ed 47 00 00       	push   $0x47ed
    1c39:	e8 f8 20 00 00       	call   3d36 <open>
  if(fd < 0){
    1c3e:	83 c4 10             	add    $0x10,%esp
    1c41:	85 c0                	test   %eax,%eax
    1c43:	78 13                	js     1c58 <bigdir+0x4f>
    printf(1, "bigdir create failed\n");
    exit(0);
  }
  close(fd);
    1c45:	83 ec 0c             	sub    $0xc,%esp
    1c48:	50                   	push   %eax
    1c49:	e8 d0 20 00 00       	call   3d1e <close>

  for(i = 0; i < 500; i++){
    1c4e:	83 c4 10             	add    $0x10,%esp
    1c51:	bb 00 00 00 00       	mov    $0x0,%ebx
    1c56:	eb 43                	jmp    1c9b <bigdir+0x92>
    printf(1, "bigdir create failed\n");
    1c58:	83 ec 08             	sub    $0x8,%esp
    1c5b:	68 f0 47 00 00       	push   $0x47f0
    1c60:	6a 01                	push   $0x1
    1c62:	e8 de 21 00 00       	call   3e45 <printf>
    exit(0);
    1c67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1c6e:	e8 83 20 00 00       	call   3cf6 <exit>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1c73:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1c76:	eb 35                	jmp    1cad <bigdir+0xa4>
    name[2] = '0' + (i % 64);
    1c78:	83 c0 30             	add    $0x30,%eax
    1c7b:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1c7e:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1c82:	83 ec 08             	sub    $0x8,%esp
    1c85:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1c88:	50                   	push   %eax
    1c89:	68 ed 47 00 00       	push   $0x47ed
    1c8e:	e8 c3 20 00 00       	call   3d56 <link>
    1c93:	83 c4 10             	add    $0x10,%esp
    1c96:	85 c0                	test   %eax,%eax
    1c98:	75 2c                	jne    1cc6 <bigdir+0xbd>
  for(i = 0; i < 500; i++){
    1c9a:	43                   	inc    %ebx
    1c9b:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1ca1:	7f 3e                	jg     1ce1 <bigdir+0xd8>
    name[0] = 'x';
    1ca3:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1ca7:	89 d8                	mov    %ebx,%eax
    1ca9:	85 db                	test   %ebx,%ebx
    1cab:	78 c6                	js     1c73 <bigdir+0x6a>
    1cad:	c1 f8 06             	sar    $0x6,%eax
    1cb0:	83 c0 30             	add    $0x30,%eax
    1cb3:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1cb6:	89 d8                	mov    %ebx,%eax
    1cb8:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1cbd:	79 b9                	jns    1c78 <bigdir+0x6f>
    1cbf:	48                   	dec    %eax
    1cc0:	83 c8 c0             	or     $0xffffffc0,%eax
    1cc3:	40                   	inc    %eax
    1cc4:	eb b2                	jmp    1c78 <bigdir+0x6f>
      printf(1, "bigdir link failed\n");
    1cc6:	83 ec 08             	sub    $0x8,%esp
    1cc9:	68 06 48 00 00       	push   $0x4806
    1cce:	6a 01                	push   $0x1
    1cd0:	e8 70 21 00 00       	call   3e45 <printf>
      exit(0);
    1cd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1cdc:	e8 15 20 00 00       	call   3cf6 <exit>
    }
  }

  unlink("bd");
    1ce1:	83 ec 0c             	sub    $0xc,%esp
    1ce4:	68 ed 47 00 00       	push   $0x47ed
    1ce9:	e8 58 20 00 00       	call   3d46 <unlink>
  for(i = 0; i < 500; i++){
    1cee:	83 c4 10             	add    $0x10,%esp
    1cf1:	bb 00 00 00 00       	mov    $0x0,%ebx
    1cf6:	eb 23                	jmp    1d1b <bigdir+0x112>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1cf8:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1cfb:	eb 30                	jmp    1d2d <bigdir+0x124>
    name[2] = '0' + (i % 64);
    1cfd:	83 c0 30             	add    $0x30,%eax
    1d00:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1d03:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1d07:	83 ec 0c             	sub    $0xc,%esp
    1d0a:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1d0d:	50                   	push   %eax
    1d0e:	e8 33 20 00 00       	call   3d46 <unlink>
    1d13:	83 c4 10             	add    $0x10,%esp
    1d16:	85 c0                	test   %eax,%eax
    1d18:	75 2c                	jne    1d46 <bigdir+0x13d>
  for(i = 0; i < 500; i++){
    1d1a:	43                   	inc    %ebx
    1d1b:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1d21:	7f 3e                	jg     1d61 <bigdir+0x158>
    name[0] = 'x';
    1d23:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1d27:	89 d8                	mov    %ebx,%eax
    1d29:	85 db                	test   %ebx,%ebx
    1d2b:	78 cb                	js     1cf8 <bigdir+0xef>
    1d2d:	c1 f8 06             	sar    $0x6,%eax
    1d30:	83 c0 30             	add    $0x30,%eax
    1d33:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1d36:	89 d8                	mov    %ebx,%eax
    1d38:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1d3d:	79 be                	jns    1cfd <bigdir+0xf4>
    1d3f:	48                   	dec    %eax
    1d40:	83 c8 c0             	or     $0xffffffc0,%eax
    1d43:	40                   	inc    %eax
    1d44:	eb b7                	jmp    1cfd <bigdir+0xf4>
      printf(1, "bigdir unlink failed");
    1d46:	83 ec 08             	sub    $0x8,%esp
    1d49:	68 1a 48 00 00       	push   $0x481a
    1d4e:	6a 01                	push   $0x1
    1d50:	e8 f0 20 00 00       	call   3e45 <printf>
      exit(0);
    1d55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1d5c:	e8 95 1f 00 00       	call   3cf6 <exit>
    }
  }

  printf(1, "bigdir ok\n");
    1d61:	83 ec 08             	sub    $0x8,%esp
    1d64:	68 2f 48 00 00       	push   $0x482f
    1d69:	6a 01                	push   $0x1
    1d6b:	e8 d5 20 00 00       	call   3e45 <printf>
}
    1d70:	83 c4 10             	add    $0x10,%esp
    1d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1d76:	c9                   	leave  
    1d77:	c3                   	ret    

00001d78 <subdir>:

void
subdir(void)
{
    1d78:	f3 0f 1e fb          	endbr32 
    1d7c:	55                   	push   %ebp
    1d7d:	89 e5                	mov    %esp,%ebp
    1d7f:	53                   	push   %ebx
    1d80:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1d83:	68 3a 48 00 00       	push   $0x483a
    1d88:	6a 01                	push   $0x1
    1d8a:	e8 b6 20 00 00       	call   3e45 <printf>

  unlink("ff");
    1d8f:	c7 04 24 c3 48 00 00 	movl   $0x48c3,(%esp)
    1d96:	e8 ab 1f 00 00       	call   3d46 <unlink>
  if(mkdir("dd") != 0){
    1d9b:	c7 04 24 60 49 00 00 	movl   $0x4960,(%esp)
    1da2:	e8 b7 1f 00 00       	call   3d5e <mkdir>
    1da7:	83 c4 10             	add    $0x10,%esp
    1daa:	85 c0                	test   %eax,%eax
    1dac:	0f 85 14 04 00 00    	jne    21c6 <subdir+0x44e>
    printf(1, "subdir mkdir dd failed\n");
    exit(0);
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1db2:	83 ec 08             	sub    $0x8,%esp
    1db5:	68 02 02 00 00       	push   $0x202
    1dba:	68 99 48 00 00       	push   $0x4899
    1dbf:	e8 72 1f 00 00       	call   3d36 <open>
    1dc4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1dc6:	83 c4 10             	add    $0x10,%esp
    1dc9:	85 c0                	test   %eax,%eax
    1dcb:	0f 88 10 04 00 00    	js     21e1 <subdir+0x469>
    printf(1, "create dd/ff failed\n");
    exit(0);
  }
  write(fd, "ff", 2);
    1dd1:	83 ec 04             	sub    $0x4,%esp
    1dd4:	6a 02                	push   $0x2
    1dd6:	68 c3 48 00 00       	push   $0x48c3
    1ddb:	50                   	push   %eax
    1ddc:	e8 35 1f 00 00       	call   3d16 <write>
  close(fd);
    1de1:	89 1c 24             	mov    %ebx,(%esp)
    1de4:	e8 35 1f 00 00       	call   3d1e <close>

  if(unlink("dd") >= 0){
    1de9:	c7 04 24 60 49 00 00 	movl   $0x4960,(%esp)
    1df0:	e8 51 1f 00 00       	call   3d46 <unlink>
    1df5:	83 c4 10             	add    $0x10,%esp
    1df8:	85 c0                	test   %eax,%eax
    1dfa:	0f 89 fc 03 00 00    	jns    21fc <subdir+0x484>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit(0);
  }

  if(mkdir("/dd/dd") != 0){
    1e00:	83 ec 0c             	sub    $0xc,%esp
    1e03:	68 74 48 00 00       	push   $0x4874
    1e08:	e8 51 1f 00 00       	call   3d5e <mkdir>
    1e0d:	83 c4 10             	add    $0x10,%esp
    1e10:	85 c0                	test   %eax,%eax
    1e12:	0f 85 ff 03 00 00    	jne    2217 <subdir+0x49f>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit(0);
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e18:	83 ec 08             	sub    $0x8,%esp
    1e1b:	68 02 02 00 00       	push   $0x202
    1e20:	68 96 48 00 00       	push   $0x4896
    1e25:	e8 0c 1f 00 00       	call   3d36 <open>
    1e2a:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e2c:	83 c4 10             	add    $0x10,%esp
    1e2f:	85 c0                	test   %eax,%eax
    1e31:	0f 88 fb 03 00 00    	js     2232 <subdir+0x4ba>
    printf(1, "create dd/dd/ff failed\n");
    exit(0);
  }
  write(fd, "FF", 2);
    1e37:	83 ec 04             	sub    $0x4,%esp
    1e3a:	6a 02                	push   $0x2
    1e3c:	68 b7 48 00 00       	push   $0x48b7
    1e41:	50                   	push   %eax
    1e42:	e8 cf 1e 00 00       	call   3d16 <write>
  close(fd);
    1e47:	89 1c 24             	mov    %ebx,(%esp)
    1e4a:	e8 cf 1e 00 00       	call   3d1e <close>

  fd = open("dd/dd/../ff", 0);
    1e4f:	83 c4 08             	add    $0x8,%esp
    1e52:	6a 00                	push   $0x0
    1e54:	68 ba 48 00 00       	push   $0x48ba
    1e59:	e8 d8 1e 00 00       	call   3d36 <open>
    1e5e:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e60:	83 c4 10             	add    $0x10,%esp
    1e63:	85 c0                	test   %eax,%eax
    1e65:	0f 88 e2 03 00 00    	js     224d <subdir+0x4d5>
    printf(1, "open dd/dd/../ff failed\n");
    exit(0);
  }
  cc = read(fd, buf, sizeof(buf));
    1e6b:	83 ec 04             	sub    $0x4,%esp
    1e6e:	68 00 20 00 00       	push   $0x2000
    1e73:	68 20 89 00 00       	push   $0x8920
    1e78:	50                   	push   %eax
    1e79:	e8 90 1e 00 00       	call   3d0e <read>
  if(cc != 2 || buf[0] != 'f'){
    1e7e:	83 c4 10             	add    $0x10,%esp
    1e81:	83 f8 02             	cmp    $0x2,%eax
    1e84:	0f 85 de 03 00 00    	jne    2268 <subdir+0x4f0>
    1e8a:	80 3d 20 89 00 00 66 	cmpb   $0x66,0x8920
    1e91:	0f 85 d1 03 00 00    	jne    2268 <subdir+0x4f0>
    printf(1, "dd/dd/../ff wrong content\n");
    exit(0);
  }
  close(fd);
    1e97:	83 ec 0c             	sub    $0xc,%esp
    1e9a:	53                   	push   %ebx
    1e9b:	e8 7e 1e 00 00       	call   3d1e <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1ea0:	83 c4 08             	add    $0x8,%esp
    1ea3:	68 fa 48 00 00       	push   $0x48fa
    1ea8:	68 96 48 00 00       	push   $0x4896
    1ead:	e8 a4 1e 00 00       	call   3d56 <link>
    1eb2:	83 c4 10             	add    $0x10,%esp
    1eb5:	85 c0                	test   %eax,%eax
    1eb7:	0f 85 c6 03 00 00    	jne    2283 <subdir+0x50b>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit(0);
  }

  if(unlink("dd/dd/ff") != 0){
    1ebd:	83 ec 0c             	sub    $0xc,%esp
    1ec0:	68 96 48 00 00       	push   $0x4896
    1ec5:	e8 7c 1e 00 00       	call   3d46 <unlink>
    1eca:	83 c4 10             	add    $0x10,%esp
    1ecd:	85 c0                	test   %eax,%eax
    1ecf:	0f 85 c9 03 00 00    	jne    229e <subdir+0x526>
    printf(1, "unlink dd/dd/ff failed\n");
    exit(0);
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ed5:	83 ec 08             	sub    $0x8,%esp
    1ed8:	6a 00                	push   $0x0
    1eda:	68 96 48 00 00       	push   $0x4896
    1edf:	e8 52 1e 00 00       	call   3d36 <open>
    1ee4:	83 c4 10             	add    $0x10,%esp
    1ee7:	85 c0                	test   %eax,%eax
    1ee9:	0f 89 ca 03 00 00    	jns    22b9 <subdir+0x541>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit(0);
  }

  if(chdir("dd") != 0){
    1eef:	83 ec 0c             	sub    $0xc,%esp
    1ef2:	68 60 49 00 00       	push   $0x4960
    1ef7:	e8 6a 1e 00 00       	call   3d66 <chdir>
    1efc:	83 c4 10             	add    $0x10,%esp
    1eff:	85 c0                	test   %eax,%eax
    1f01:	0f 85 cd 03 00 00    	jne    22d4 <subdir+0x55c>
    printf(1, "chdir dd failed\n");
    exit(0);
  }
  if(chdir("dd/../../dd") != 0){
    1f07:	83 ec 0c             	sub    $0xc,%esp
    1f0a:	68 2e 49 00 00       	push   $0x492e
    1f0f:	e8 52 1e 00 00       	call   3d66 <chdir>
    1f14:	83 c4 10             	add    $0x10,%esp
    1f17:	85 c0                	test   %eax,%eax
    1f19:	0f 85 d0 03 00 00    	jne    22ef <subdir+0x577>
    printf(1, "chdir dd/../../dd failed\n");
    exit(0);
  }
  if(chdir("dd/../../../dd") != 0){
    1f1f:	83 ec 0c             	sub    $0xc,%esp
    1f22:	68 54 49 00 00       	push   $0x4954
    1f27:	e8 3a 1e 00 00       	call   3d66 <chdir>
    1f2c:	83 c4 10             	add    $0x10,%esp
    1f2f:	85 c0                	test   %eax,%eax
    1f31:	0f 85 d3 03 00 00    	jne    230a <subdir+0x592>
    printf(1, "chdir dd/../../dd failed\n");
    exit(0);
  }
  if(chdir("./..") != 0){
    1f37:	83 ec 0c             	sub    $0xc,%esp
    1f3a:	68 63 49 00 00       	push   $0x4963
    1f3f:	e8 22 1e 00 00       	call   3d66 <chdir>
    1f44:	83 c4 10             	add    $0x10,%esp
    1f47:	85 c0                	test   %eax,%eax
    1f49:	0f 85 d6 03 00 00    	jne    2325 <subdir+0x5ad>
    printf(1, "chdir ./.. failed\n");
    exit(0);
  }

  fd = open("dd/dd/ffff", 0);
    1f4f:	83 ec 08             	sub    $0x8,%esp
    1f52:	6a 00                	push   $0x0
    1f54:	68 fa 48 00 00       	push   $0x48fa
    1f59:	e8 d8 1d 00 00       	call   3d36 <open>
    1f5e:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1f60:	83 c4 10             	add    $0x10,%esp
    1f63:	85 c0                	test   %eax,%eax
    1f65:	0f 88 d5 03 00 00    	js     2340 <subdir+0x5c8>
    printf(1, "open dd/dd/ffff failed\n");
    exit(0);
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1f6b:	83 ec 04             	sub    $0x4,%esp
    1f6e:	68 00 20 00 00       	push   $0x2000
    1f73:	68 20 89 00 00       	push   $0x8920
    1f78:	50                   	push   %eax
    1f79:	e8 90 1d 00 00       	call   3d0e <read>
    1f7e:	83 c4 10             	add    $0x10,%esp
    1f81:	83 f8 02             	cmp    $0x2,%eax
    1f84:	0f 85 d1 03 00 00    	jne    235b <subdir+0x5e3>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit(0);
  }
  close(fd);
    1f8a:	83 ec 0c             	sub    $0xc,%esp
    1f8d:	53                   	push   %ebx
    1f8e:	e8 8b 1d 00 00       	call   3d1e <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f93:	83 c4 08             	add    $0x8,%esp
    1f96:	6a 00                	push   $0x0
    1f98:	68 96 48 00 00       	push   $0x4896
    1f9d:	e8 94 1d 00 00       	call   3d36 <open>
    1fa2:	83 c4 10             	add    $0x10,%esp
    1fa5:	85 c0                	test   %eax,%eax
    1fa7:	0f 89 c9 03 00 00    	jns    2376 <subdir+0x5fe>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit(0);
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1fad:	83 ec 08             	sub    $0x8,%esp
    1fb0:	68 02 02 00 00       	push   $0x202
    1fb5:	68 ae 49 00 00       	push   $0x49ae
    1fba:	e8 77 1d 00 00       	call   3d36 <open>
    1fbf:	83 c4 10             	add    $0x10,%esp
    1fc2:	85 c0                	test   %eax,%eax
    1fc4:	0f 89 c7 03 00 00    	jns    2391 <subdir+0x619>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1fca:	83 ec 08             	sub    $0x8,%esp
    1fcd:	68 02 02 00 00       	push   $0x202
    1fd2:	68 d3 49 00 00       	push   $0x49d3
    1fd7:	e8 5a 1d 00 00       	call   3d36 <open>
    1fdc:	83 c4 10             	add    $0x10,%esp
    1fdf:	85 c0                	test   %eax,%eax
    1fe1:	0f 89 c5 03 00 00    	jns    23ac <subdir+0x634>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(open("dd", O_CREATE) >= 0){
    1fe7:	83 ec 08             	sub    $0x8,%esp
    1fea:	68 00 02 00 00       	push   $0x200
    1fef:	68 60 49 00 00       	push   $0x4960
    1ff4:	e8 3d 1d 00 00       	call   3d36 <open>
    1ff9:	83 c4 10             	add    $0x10,%esp
    1ffc:	85 c0                	test   %eax,%eax
    1ffe:	0f 89 c3 03 00 00    	jns    23c7 <subdir+0x64f>
    printf(1, "create dd succeeded!\n");
    exit(0);
  }
  if(open("dd", O_RDWR) >= 0){
    2004:	83 ec 08             	sub    $0x8,%esp
    2007:	6a 02                	push   $0x2
    2009:	68 60 49 00 00       	push   $0x4960
    200e:	e8 23 1d 00 00       	call   3d36 <open>
    2013:	83 c4 10             	add    $0x10,%esp
    2016:	85 c0                	test   %eax,%eax
    2018:	0f 89 c4 03 00 00    	jns    23e2 <subdir+0x66a>
    printf(1, "open dd rdwr succeeded!\n");
    exit(0);
  }
  if(open("dd", O_WRONLY) >= 0){
    201e:	83 ec 08             	sub    $0x8,%esp
    2021:	6a 01                	push   $0x1
    2023:	68 60 49 00 00       	push   $0x4960
    2028:	e8 09 1d 00 00       	call   3d36 <open>
    202d:	83 c4 10             	add    $0x10,%esp
    2030:	85 c0                	test   %eax,%eax
    2032:	0f 89 c5 03 00 00    	jns    23fd <subdir+0x685>
    printf(1, "open dd wronly succeeded!\n");
    exit(0);
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2038:	83 ec 08             	sub    $0x8,%esp
    203b:	68 42 4a 00 00       	push   $0x4a42
    2040:	68 ae 49 00 00       	push   $0x49ae
    2045:	e8 0c 1d 00 00       	call   3d56 <link>
    204a:	83 c4 10             	add    $0x10,%esp
    204d:	85 c0                	test   %eax,%eax
    204f:	0f 84 c3 03 00 00    	je     2418 <subdir+0x6a0>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit(0);
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2055:	83 ec 08             	sub    $0x8,%esp
    2058:	68 42 4a 00 00       	push   $0x4a42
    205d:	68 d3 49 00 00       	push   $0x49d3
    2062:	e8 ef 1c 00 00       	call   3d56 <link>
    2067:	83 c4 10             	add    $0x10,%esp
    206a:	85 c0                	test   %eax,%eax
    206c:	0f 84 c1 03 00 00    	je     2433 <subdir+0x6bb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit(0);
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2072:	83 ec 08             	sub    $0x8,%esp
    2075:	68 fa 48 00 00       	push   $0x48fa
    207a:	68 99 48 00 00       	push   $0x4899
    207f:	e8 d2 1c 00 00       	call   3d56 <link>
    2084:	83 c4 10             	add    $0x10,%esp
    2087:	85 c0                	test   %eax,%eax
    2089:	0f 84 bf 03 00 00    	je     244e <subdir+0x6d6>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/ff/ff") == 0){
    208f:	83 ec 0c             	sub    $0xc,%esp
    2092:	68 ae 49 00 00       	push   $0x49ae
    2097:	e8 c2 1c 00 00       	call   3d5e <mkdir>
    209c:	83 c4 10             	add    $0x10,%esp
    209f:	85 c0                	test   %eax,%eax
    20a1:	0f 84 c2 03 00 00    	je     2469 <subdir+0x6f1>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/xx/ff") == 0){
    20a7:	83 ec 0c             	sub    $0xc,%esp
    20aa:	68 d3 49 00 00       	push   $0x49d3
    20af:	e8 aa 1c 00 00       	call   3d5e <mkdir>
    20b4:	83 c4 10             	add    $0x10,%esp
    20b7:	85 c0                	test   %eax,%eax
    20b9:	0f 84 c5 03 00 00    	je     2484 <subdir+0x70c>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(mkdir("dd/dd/ffff") == 0){
    20bf:	83 ec 0c             	sub    $0xc,%esp
    20c2:	68 fa 48 00 00       	push   $0x48fa
    20c7:	e8 92 1c 00 00       	call   3d5e <mkdir>
    20cc:	83 c4 10             	add    $0x10,%esp
    20cf:	85 c0                	test   %eax,%eax
    20d1:	0f 84 c8 03 00 00    	je     249f <subdir+0x727>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit(0);
  }
  if(unlink("dd/xx/ff") == 0){
    20d7:	83 ec 0c             	sub    $0xc,%esp
    20da:	68 d3 49 00 00       	push   $0x49d3
    20df:	e8 62 1c 00 00       	call   3d46 <unlink>
    20e4:	83 c4 10             	add    $0x10,%esp
    20e7:	85 c0                	test   %eax,%eax
    20e9:	0f 84 cb 03 00 00    	je     24ba <subdir+0x742>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit(0);
  }
  if(unlink("dd/ff/ff") == 0){
    20ef:	83 ec 0c             	sub    $0xc,%esp
    20f2:	68 ae 49 00 00       	push   $0x49ae
    20f7:	e8 4a 1c 00 00       	call   3d46 <unlink>
    20fc:	83 c4 10             	add    $0x10,%esp
    20ff:	85 c0                	test   %eax,%eax
    2101:	0f 84 ce 03 00 00    	je     24d5 <subdir+0x75d>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit(0);
  }
  if(chdir("dd/ff") == 0){
    2107:	83 ec 0c             	sub    $0xc,%esp
    210a:	68 99 48 00 00       	push   $0x4899
    210f:	e8 52 1c 00 00       	call   3d66 <chdir>
    2114:	83 c4 10             	add    $0x10,%esp
    2117:	85 c0                	test   %eax,%eax
    2119:	0f 84 d1 03 00 00    	je     24f0 <subdir+0x778>
    printf(1, "chdir dd/ff succeeded!\n");
    exit(0);
  }
  if(chdir("dd/xx") == 0){
    211f:	83 ec 0c             	sub    $0xc,%esp
    2122:	68 45 4a 00 00       	push   $0x4a45
    2127:	e8 3a 1c 00 00       	call   3d66 <chdir>
    212c:	83 c4 10             	add    $0x10,%esp
    212f:	85 c0                	test   %eax,%eax
    2131:	0f 84 d4 03 00 00    	je     250b <subdir+0x793>
    printf(1, "chdir dd/xx succeeded!\n");
    exit(0);
  }

  if(unlink("dd/dd/ffff") != 0){
    2137:	83 ec 0c             	sub    $0xc,%esp
    213a:	68 fa 48 00 00       	push   $0x48fa
    213f:	e8 02 1c 00 00       	call   3d46 <unlink>
    2144:	83 c4 10             	add    $0x10,%esp
    2147:	85 c0                	test   %eax,%eax
    2149:	0f 85 d7 03 00 00    	jne    2526 <subdir+0x7ae>
    printf(1, "unlink dd/dd/ff failed\n");
    exit(0);
  }
  if(unlink("dd/ff") != 0){
    214f:	83 ec 0c             	sub    $0xc,%esp
    2152:	68 99 48 00 00       	push   $0x4899
    2157:	e8 ea 1b 00 00       	call   3d46 <unlink>
    215c:	83 c4 10             	add    $0x10,%esp
    215f:	85 c0                	test   %eax,%eax
    2161:	0f 85 da 03 00 00    	jne    2541 <subdir+0x7c9>
    printf(1, "unlink dd/ff failed\n");
    exit(0);
  }
  if(unlink("dd") == 0){
    2167:	83 ec 0c             	sub    $0xc,%esp
    216a:	68 60 49 00 00       	push   $0x4960
    216f:	e8 d2 1b 00 00       	call   3d46 <unlink>
    2174:	83 c4 10             	add    $0x10,%esp
    2177:	85 c0                	test   %eax,%eax
    2179:	0f 84 dd 03 00 00    	je     255c <subdir+0x7e4>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit(0);
  }
  if(unlink("dd/dd") < 0){
    217f:	83 ec 0c             	sub    $0xc,%esp
    2182:	68 75 48 00 00       	push   $0x4875
    2187:	e8 ba 1b 00 00       	call   3d46 <unlink>
    218c:	83 c4 10             	add    $0x10,%esp
    218f:	85 c0                	test   %eax,%eax
    2191:	0f 88 e0 03 00 00    	js     2577 <subdir+0x7ff>
    printf(1, "unlink dd/dd failed\n");
    exit(0);
  }
  if(unlink("dd") < 0){
    2197:	83 ec 0c             	sub    $0xc,%esp
    219a:	68 60 49 00 00       	push   $0x4960
    219f:	e8 a2 1b 00 00       	call   3d46 <unlink>
    21a4:	83 c4 10             	add    $0x10,%esp
    21a7:	85 c0                	test   %eax,%eax
    21a9:	0f 88 e3 03 00 00    	js     2592 <subdir+0x81a>
    printf(1, "unlink dd failed\n");
    exit(0);
  }

  printf(1, "subdir ok\n");
    21af:	83 ec 08             	sub    $0x8,%esp
    21b2:	68 42 4b 00 00       	push   $0x4b42
    21b7:	6a 01                	push   $0x1
    21b9:	e8 87 1c 00 00       	call   3e45 <printf>
}
    21be:	83 c4 10             	add    $0x10,%esp
    21c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    21c4:	c9                   	leave  
    21c5:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    21c6:	83 ec 08             	sub    $0x8,%esp
    21c9:	68 47 48 00 00       	push   $0x4847
    21ce:	6a 01                	push   $0x1
    21d0:	e8 70 1c 00 00       	call   3e45 <printf>
    exit(0);
    21d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    21dc:	e8 15 1b 00 00       	call   3cf6 <exit>
    printf(1, "create dd/ff failed\n");
    21e1:	83 ec 08             	sub    $0x8,%esp
    21e4:	68 5f 48 00 00       	push   $0x485f
    21e9:	6a 01                	push   $0x1
    21eb:	e8 55 1c 00 00       	call   3e45 <printf>
    exit(0);
    21f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    21f7:	e8 fa 1a 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    21fc:	83 ec 08             	sub    $0x8,%esp
    21ff:	68 2c 53 00 00       	push   $0x532c
    2204:	6a 01                	push   $0x1
    2206:	e8 3a 1c 00 00       	call   3e45 <printf>
    exit(0);
    220b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2212:	e8 df 1a 00 00       	call   3cf6 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2217:	83 ec 08             	sub    $0x8,%esp
    221a:	68 7b 48 00 00       	push   $0x487b
    221f:	6a 01                	push   $0x1
    2221:	e8 1f 1c 00 00       	call   3e45 <printf>
    exit(0);
    2226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    222d:	e8 c4 1a 00 00       	call   3cf6 <exit>
    printf(1, "create dd/dd/ff failed\n");
    2232:	83 ec 08             	sub    $0x8,%esp
    2235:	68 9f 48 00 00       	push   $0x489f
    223a:	6a 01                	push   $0x1
    223c:	e8 04 1c 00 00       	call   3e45 <printf>
    exit(0);
    2241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2248:	e8 a9 1a 00 00       	call   3cf6 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    224d:	83 ec 08             	sub    $0x8,%esp
    2250:	68 c6 48 00 00       	push   $0x48c6
    2255:	6a 01                	push   $0x1
    2257:	e8 e9 1b 00 00       	call   3e45 <printf>
    exit(0);
    225c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2263:	e8 8e 1a 00 00       	call   3cf6 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    2268:	83 ec 08             	sub    $0x8,%esp
    226b:	68 df 48 00 00       	push   $0x48df
    2270:	6a 01                	push   $0x1
    2272:	e8 ce 1b 00 00       	call   3e45 <printf>
    exit(0);
    2277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    227e:	e8 73 1a 00 00       	call   3cf6 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2283:	83 ec 08             	sub    $0x8,%esp
    2286:	68 54 53 00 00       	push   $0x5354
    228b:	6a 01                	push   $0x1
    228d:	e8 b3 1b 00 00       	call   3e45 <printf>
    exit(0);
    2292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2299:	e8 58 1a 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    229e:	83 ec 08             	sub    $0x8,%esp
    22a1:	68 05 49 00 00       	push   $0x4905
    22a6:	6a 01                	push   $0x1
    22a8:	e8 98 1b 00 00       	call   3e45 <printf>
    exit(0);
    22ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22b4:	e8 3d 1a 00 00       	call   3cf6 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    22b9:	83 ec 08             	sub    $0x8,%esp
    22bc:	68 78 53 00 00       	push   $0x5378
    22c1:	6a 01                	push   $0x1
    22c3:	e8 7d 1b 00 00       	call   3e45 <printf>
    exit(0);
    22c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22cf:	e8 22 1a 00 00       	call   3cf6 <exit>
    printf(1, "chdir dd failed\n");
    22d4:	83 ec 08             	sub    $0x8,%esp
    22d7:	68 1d 49 00 00       	push   $0x491d
    22dc:	6a 01                	push   $0x1
    22de:	e8 62 1b 00 00       	call   3e45 <printf>
    exit(0);
    22e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    22ea:	e8 07 1a 00 00       	call   3cf6 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    22ef:	83 ec 08             	sub    $0x8,%esp
    22f2:	68 3a 49 00 00       	push   $0x493a
    22f7:	6a 01                	push   $0x1
    22f9:	e8 47 1b 00 00       	call   3e45 <printf>
    exit(0);
    22fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2305:	e8 ec 19 00 00       	call   3cf6 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    230a:	83 ec 08             	sub    $0x8,%esp
    230d:	68 3a 49 00 00       	push   $0x493a
    2312:	6a 01                	push   $0x1
    2314:	e8 2c 1b 00 00       	call   3e45 <printf>
    exit(0);
    2319:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2320:	e8 d1 19 00 00       	call   3cf6 <exit>
    printf(1, "chdir ./.. failed\n");
    2325:	83 ec 08             	sub    $0x8,%esp
    2328:	68 68 49 00 00       	push   $0x4968
    232d:	6a 01                	push   $0x1
    232f:	e8 11 1b 00 00       	call   3e45 <printf>
    exit(0);
    2334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    233b:	e8 b6 19 00 00       	call   3cf6 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    2340:	83 ec 08             	sub    $0x8,%esp
    2343:	68 7b 49 00 00       	push   $0x497b
    2348:	6a 01                	push   $0x1
    234a:	e8 f6 1a 00 00       	call   3e45 <printf>
    exit(0);
    234f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2356:	e8 9b 19 00 00       	call   3cf6 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    235b:	83 ec 08             	sub    $0x8,%esp
    235e:	68 93 49 00 00       	push   $0x4993
    2363:	6a 01                	push   $0x1
    2365:	e8 db 1a 00 00       	call   3e45 <printf>
    exit(0);
    236a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2371:	e8 80 19 00 00       	call   3cf6 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2376:	83 ec 08             	sub    $0x8,%esp
    2379:	68 9c 53 00 00       	push   $0x539c
    237e:	6a 01                	push   $0x1
    2380:	e8 c0 1a 00 00       	call   3e45 <printf>
    exit(0);
    2385:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    238c:	e8 65 19 00 00       	call   3cf6 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2391:	83 ec 08             	sub    $0x8,%esp
    2394:	68 b7 49 00 00       	push   $0x49b7
    2399:	6a 01                	push   $0x1
    239b:	e8 a5 1a 00 00       	call   3e45 <printf>
    exit(0);
    23a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23a7:	e8 4a 19 00 00       	call   3cf6 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    23ac:	83 ec 08             	sub    $0x8,%esp
    23af:	68 dc 49 00 00       	push   $0x49dc
    23b4:	6a 01                	push   $0x1
    23b6:	e8 8a 1a 00 00       	call   3e45 <printf>
    exit(0);
    23bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23c2:	e8 2f 19 00 00       	call   3cf6 <exit>
    printf(1, "create dd succeeded!\n");
    23c7:	83 ec 08             	sub    $0x8,%esp
    23ca:	68 f8 49 00 00       	push   $0x49f8
    23cf:	6a 01                	push   $0x1
    23d1:	e8 6f 1a 00 00       	call   3e45 <printf>
    exit(0);
    23d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23dd:	e8 14 19 00 00       	call   3cf6 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    23e2:	83 ec 08             	sub    $0x8,%esp
    23e5:	68 0e 4a 00 00       	push   $0x4a0e
    23ea:	6a 01                	push   $0x1
    23ec:	e8 54 1a 00 00       	call   3e45 <printf>
    exit(0);
    23f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    23f8:	e8 f9 18 00 00       	call   3cf6 <exit>
    printf(1, "open dd wronly succeeded!\n");
    23fd:	83 ec 08             	sub    $0x8,%esp
    2400:	68 27 4a 00 00       	push   $0x4a27
    2405:	6a 01                	push   $0x1
    2407:	e8 39 1a 00 00       	call   3e45 <printf>
    exit(0);
    240c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2413:	e8 de 18 00 00       	call   3cf6 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2418:	83 ec 08             	sub    $0x8,%esp
    241b:	68 c4 53 00 00       	push   $0x53c4
    2420:	6a 01                	push   $0x1
    2422:	e8 1e 1a 00 00       	call   3e45 <printf>
    exit(0);
    2427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    242e:	e8 c3 18 00 00       	call   3cf6 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2433:	83 ec 08             	sub    $0x8,%esp
    2436:	68 e8 53 00 00       	push   $0x53e8
    243b:	6a 01                	push   $0x1
    243d:	e8 03 1a 00 00       	call   3e45 <printf>
    exit(0);
    2442:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2449:	e8 a8 18 00 00       	call   3cf6 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    244e:	83 ec 08             	sub    $0x8,%esp
    2451:	68 0c 54 00 00       	push   $0x540c
    2456:	6a 01                	push   $0x1
    2458:	e8 e8 19 00 00       	call   3e45 <printf>
    exit(0);
    245d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2464:	e8 8d 18 00 00       	call   3cf6 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2469:	83 ec 08             	sub    $0x8,%esp
    246c:	68 4b 4a 00 00       	push   $0x4a4b
    2471:	6a 01                	push   $0x1
    2473:	e8 cd 19 00 00       	call   3e45 <printf>
    exit(0);
    2478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    247f:	e8 72 18 00 00       	call   3cf6 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2484:	83 ec 08             	sub    $0x8,%esp
    2487:	68 66 4a 00 00       	push   $0x4a66
    248c:	6a 01                	push   $0x1
    248e:	e8 b2 19 00 00       	call   3e45 <printf>
    exit(0);
    2493:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    249a:	e8 57 18 00 00       	call   3cf6 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    249f:	83 ec 08             	sub    $0x8,%esp
    24a2:	68 81 4a 00 00       	push   $0x4a81
    24a7:	6a 01                	push   $0x1
    24a9:	e8 97 19 00 00       	call   3e45 <printf>
    exit(0);
    24ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24b5:	e8 3c 18 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    24ba:	83 ec 08             	sub    $0x8,%esp
    24bd:	68 9e 4a 00 00       	push   $0x4a9e
    24c2:	6a 01                	push   $0x1
    24c4:	e8 7c 19 00 00       	call   3e45 <printf>
    exit(0);
    24c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24d0:	e8 21 18 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    24d5:	83 ec 08             	sub    $0x8,%esp
    24d8:	68 ba 4a 00 00       	push   $0x4aba
    24dd:	6a 01                	push   $0x1
    24df:	e8 61 19 00 00       	call   3e45 <printf>
    exit(0);
    24e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    24eb:	e8 06 18 00 00       	call   3cf6 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    24f0:	83 ec 08             	sub    $0x8,%esp
    24f3:	68 d6 4a 00 00       	push   $0x4ad6
    24f8:	6a 01                	push   $0x1
    24fa:	e8 46 19 00 00       	call   3e45 <printf>
    exit(0);
    24ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2506:	e8 eb 17 00 00       	call   3cf6 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    250b:	83 ec 08             	sub    $0x8,%esp
    250e:	68 ee 4a 00 00       	push   $0x4aee
    2513:	6a 01                	push   $0x1
    2515:	e8 2b 19 00 00       	call   3e45 <printf>
    exit(0);
    251a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2521:	e8 d0 17 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2526:	83 ec 08             	sub    $0x8,%esp
    2529:	68 05 49 00 00       	push   $0x4905
    252e:	6a 01                	push   $0x1
    2530:	e8 10 19 00 00       	call   3e45 <printf>
    exit(0);
    2535:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    253c:	e8 b5 17 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd/ff failed\n");
    2541:	83 ec 08             	sub    $0x8,%esp
    2544:	68 06 4b 00 00       	push   $0x4b06
    2549:	6a 01                	push   $0x1
    254b:	e8 f5 18 00 00       	call   3e45 <printf>
    exit(0);
    2550:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2557:	e8 9a 17 00 00       	call   3cf6 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    255c:	83 ec 08             	sub    $0x8,%esp
    255f:	68 30 54 00 00       	push   $0x5430
    2564:	6a 01                	push   $0x1
    2566:	e8 da 18 00 00       	call   3e45 <printf>
    exit(0);
    256b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2572:	e8 7f 17 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd/dd failed\n");
    2577:	83 ec 08             	sub    $0x8,%esp
    257a:	68 1b 4b 00 00       	push   $0x4b1b
    257f:	6a 01                	push   $0x1
    2581:	e8 bf 18 00 00       	call   3e45 <printf>
    exit(0);
    2586:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    258d:	e8 64 17 00 00       	call   3cf6 <exit>
    printf(1, "unlink dd failed\n");
    2592:	83 ec 08             	sub    $0x8,%esp
    2595:	68 30 4b 00 00       	push   $0x4b30
    259a:	6a 01                	push   $0x1
    259c:	e8 a4 18 00 00       	call   3e45 <printf>
    exit(0);
    25a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    25a8:	e8 49 17 00 00       	call   3cf6 <exit>

000025ad <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    25ad:	f3 0f 1e fb          	endbr32 
    25b1:	55                   	push   %ebp
    25b2:	89 e5                	mov    %esp,%ebp
    25b4:	57                   	push   %edi
    25b5:	56                   	push   %esi
    25b6:	53                   	push   %ebx
    25b7:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    25ba:	68 4d 4b 00 00       	push   $0x4b4d
    25bf:	6a 01                	push   $0x1
    25c1:	e8 7f 18 00 00       	call   3e45 <printf>

  unlink("bigwrite");
    25c6:	c7 04 24 5c 4b 00 00 	movl   $0x4b5c,(%esp)
    25cd:	e8 74 17 00 00       	call   3d46 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    25d2:	83 c4 10             	add    $0x10,%esp
    25d5:	be f3 01 00 00       	mov    $0x1f3,%esi
    25da:	eb 53                	jmp    262f <bigwrite+0x82>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    25dc:	83 ec 08             	sub    $0x8,%esp
    25df:	68 65 4b 00 00       	push   $0x4b65
    25e4:	6a 01                	push   $0x1
    25e6:	e8 5a 18 00 00       	call   3e45 <printf>
      exit(0);
    25eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    25f2:	e8 ff 16 00 00       	call   3cf6 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
    25f7:	50                   	push   %eax
    25f8:	56                   	push   %esi
    25f9:	68 7d 4b 00 00       	push   $0x4b7d
    25fe:	6a 01                	push   $0x1
    2600:	e8 40 18 00 00       	call   3e45 <printf>
        exit(0);
    2605:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    260c:	e8 e5 16 00 00       	call   3cf6 <exit>
      }
    }
    close(fd);
    2611:	83 ec 0c             	sub    $0xc,%esp
    2614:	57                   	push   %edi
    2615:	e8 04 17 00 00       	call   3d1e <close>
    unlink("bigwrite");
    261a:	c7 04 24 5c 4b 00 00 	movl   $0x4b5c,(%esp)
    2621:	e8 20 17 00 00       	call   3d46 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2626:	81 c6 d7 01 00 00    	add    $0x1d7,%esi
    262c:	83 c4 10             	add    $0x10,%esp
    262f:	81 fe ff 17 00 00    	cmp    $0x17ff,%esi
    2635:	7f 3e                	jg     2675 <bigwrite+0xc8>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2637:	83 ec 08             	sub    $0x8,%esp
    263a:	68 02 02 00 00       	push   $0x202
    263f:	68 5c 4b 00 00       	push   $0x4b5c
    2644:	e8 ed 16 00 00       	call   3d36 <open>
    2649:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    264b:	83 c4 10             	add    $0x10,%esp
    264e:	85 c0                	test   %eax,%eax
    2650:	78 8a                	js     25dc <bigwrite+0x2f>
    for(i = 0; i < 2; i++){
    2652:	bb 00 00 00 00       	mov    $0x0,%ebx
    2657:	83 fb 01             	cmp    $0x1,%ebx
    265a:	7f b5                	jg     2611 <bigwrite+0x64>
      int cc = write(fd, buf, sz);
    265c:	83 ec 04             	sub    $0x4,%esp
    265f:	56                   	push   %esi
    2660:	68 20 89 00 00       	push   $0x8920
    2665:	57                   	push   %edi
    2666:	e8 ab 16 00 00       	call   3d16 <write>
      if(cc != sz){
    266b:	83 c4 10             	add    $0x10,%esp
    266e:	39 c6                	cmp    %eax,%esi
    2670:	75 85                	jne    25f7 <bigwrite+0x4a>
    for(i = 0; i < 2; i++){
    2672:	43                   	inc    %ebx
    2673:	eb e2                	jmp    2657 <bigwrite+0xaa>
  }

  printf(1, "bigwrite ok\n");
    2675:	83 ec 08             	sub    $0x8,%esp
    2678:	68 8f 4b 00 00       	push   $0x4b8f
    267d:	6a 01                	push   $0x1
    267f:	e8 c1 17 00 00       	call   3e45 <printf>
}
    2684:	83 c4 10             	add    $0x10,%esp
    2687:	8d 65 f4             	lea    -0xc(%ebp),%esp
    268a:	5b                   	pop    %ebx
    268b:	5e                   	pop    %esi
    268c:	5f                   	pop    %edi
    268d:	5d                   	pop    %ebp
    268e:	c3                   	ret    

0000268f <bigfile>:

void
bigfile(void)
{
    268f:	f3 0f 1e fb          	endbr32 
    2693:	55                   	push   %ebp
    2694:	89 e5                	mov    %esp,%ebp
    2696:	57                   	push   %edi
    2697:	56                   	push   %esi
    2698:	53                   	push   %ebx
    2699:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    269c:	68 9c 4b 00 00       	push   $0x4b9c
    26a1:	6a 01                	push   $0x1
    26a3:	e8 9d 17 00 00       	call   3e45 <printf>

  unlink("bigfile");
    26a8:	c7 04 24 b8 4b 00 00 	movl   $0x4bb8,(%esp)
    26af:	e8 92 16 00 00       	call   3d46 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    26b4:	83 c4 08             	add    $0x8,%esp
    26b7:	68 02 02 00 00       	push   $0x202
    26bc:	68 b8 4b 00 00       	push   $0x4bb8
    26c1:	e8 70 16 00 00       	call   3d36 <open>
  if(fd < 0){
    26c6:	83 c4 10             	add    $0x10,%esp
    26c9:	85 c0                	test   %eax,%eax
    26cb:	78 3f                	js     270c <bigfile+0x7d>
    26cd:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit(0);
  }
  for(i = 0; i < 20; i++){
    26cf:	bb 00 00 00 00       	mov    $0x0,%ebx
    26d4:	83 fb 13             	cmp    $0x13,%ebx
    26d7:	7f 69                	jg     2742 <bigfile+0xb3>
    memset(buf, i, 600);
    26d9:	83 ec 04             	sub    $0x4,%esp
    26dc:	68 58 02 00 00       	push   $0x258
    26e1:	53                   	push   %ebx
    26e2:	68 20 89 00 00       	push   $0x8920
    26e7:	e8 cd 14 00 00       	call   3bb9 <memset>
    if(write(fd, buf, 600) != 600){
    26ec:	83 c4 0c             	add    $0xc,%esp
    26ef:	68 58 02 00 00       	push   $0x258
    26f4:	68 20 89 00 00       	push   $0x8920
    26f9:	56                   	push   %esi
    26fa:	e8 17 16 00 00       	call   3d16 <write>
    26ff:	83 c4 10             	add    $0x10,%esp
    2702:	3d 58 02 00 00       	cmp    $0x258,%eax
    2707:	75 1e                	jne    2727 <bigfile+0x98>
  for(i = 0; i < 20; i++){
    2709:	43                   	inc    %ebx
    270a:	eb c8                	jmp    26d4 <bigfile+0x45>
    printf(1, "cannot create bigfile");
    270c:	83 ec 08             	sub    $0x8,%esp
    270f:	68 aa 4b 00 00       	push   $0x4baa
    2714:	6a 01                	push   $0x1
    2716:	e8 2a 17 00 00       	call   3e45 <printf>
    exit(0);
    271b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2722:	e8 cf 15 00 00       	call   3cf6 <exit>
      printf(1, "write bigfile failed\n");
    2727:	83 ec 08             	sub    $0x8,%esp
    272a:	68 c0 4b 00 00       	push   $0x4bc0
    272f:	6a 01                	push   $0x1
    2731:	e8 0f 17 00 00       	call   3e45 <printf>
      exit(0);
    2736:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    273d:	e8 b4 15 00 00       	call   3cf6 <exit>
    }
  }
  close(fd);
    2742:	83 ec 0c             	sub    $0xc,%esp
    2745:	56                   	push   %esi
    2746:	e8 d3 15 00 00       	call   3d1e <close>

  fd = open("bigfile", 0);
    274b:	83 c4 08             	add    $0x8,%esp
    274e:	6a 00                	push   $0x0
    2750:	68 b8 4b 00 00       	push   $0x4bb8
    2755:	e8 dc 15 00 00       	call   3d36 <open>
    275a:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    275c:	83 c4 10             	add    $0x10,%esp
    275f:	85 c0                	test   %eax,%eax
    2761:	78 55                	js     27b8 <bigfile+0x129>
    printf(1, "cannot open bigfile\n");
    exit(0);
  }
  total = 0;
    2763:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    2768:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    276d:	83 ec 04             	sub    $0x4,%esp
    2770:	68 2c 01 00 00       	push   $0x12c
    2775:	68 20 89 00 00       	push   $0x8920
    277a:	57                   	push   %edi
    277b:	e8 8e 15 00 00       	call   3d0e <read>
    if(cc < 0){
    2780:	83 c4 10             	add    $0x10,%esp
    2783:	85 c0                	test   %eax,%eax
    2785:	78 4c                	js     27d3 <bigfile+0x144>
      printf(1, "read bigfile failed\n");
      exit(0);
    }
    if(cc == 0)
    2787:	0f 84 97 00 00 00    	je     2824 <bigfile+0x195>
      break;
    if(cc != 300){
    278d:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2792:	75 5a                	jne    27ee <bigfile+0x15f>
      printf(1, "short read bigfile\n");
      exit(0);
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2794:	0f be 0d 20 89 00 00 	movsbl 0x8920,%ecx
    279b:	89 da                	mov    %ebx,%edx
    279d:	c1 ea 1f             	shr    $0x1f,%edx
    27a0:	01 da                	add    %ebx,%edx
    27a2:	d1 fa                	sar    %edx
    27a4:	39 d1                	cmp    %edx,%ecx
    27a6:	75 61                	jne    2809 <bigfile+0x17a>
    27a8:	0f be 0d 4b 8a 00 00 	movsbl 0x8a4b,%ecx
    27af:	39 ca                	cmp    %ecx,%edx
    27b1:	75 56                	jne    2809 <bigfile+0x17a>
      printf(1, "read bigfile wrong data\n");
      exit(0);
    }
    total += cc;
    27b3:	01 c6                	add    %eax,%esi
  for(i = 0; ; i++){
    27b5:	43                   	inc    %ebx
    cc = read(fd, buf, 300);
    27b6:	eb b5                	jmp    276d <bigfile+0xde>
    printf(1, "cannot open bigfile\n");
    27b8:	83 ec 08             	sub    $0x8,%esp
    27bb:	68 d6 4b 00 00       	push   $0x4bd6
    27c0:	6a 01                	push   $0x1
    27c2:	e8 7e 16 00 00       	call   3e45 <printf>
    exit(0);
    27c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27ce:	e8 23 15 00 00       	call   3cf6 <exit>
      printf(1, "read bigfile failed\n");
    27d3:	83 ec 08             	sub    $0x8,%esp
    27d6:	68 eb 4b 00 00       	push   $0x4beb
    27db:	6a 01                	push   $0x1
    27dd:	e8 63 16 00 00       	call   3e45 <printf>
      exit(0);
    27e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    27e9:	e8 08 15 00 00       	call   3cf6 <exit>
      printf(1, "short read bigfile\n");
    27ee:	83 ec 08             	sub    $0x8,%esp
    27f1:	68 00 4c 00 00       	push   $0x4c00
    27f6:	6a 01                	push   $0x1
    27f8:	e8 48 16 00 00       	call   3e45 <printf>
      exit(0);
    27fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2804:	e8 ed 14 00 00       	call   3cf6 <exit>
      printf(1, "read bigfile wrong data\n");
    2809:	83 ec 08             	sub    $0x8,%esp
    280c:	68 14 4c 00 00       	push   $0x4c14
    2811:	6a 01                	push   $0x1
    2813:	e8 2d 16 00 00       	call   3e45 <printf>
      exit(0);
    2818:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    281f:	e8 d2 14 00 00       	call   3cf6 <exit>
  }
  close(fd);
    2824:	83 ec 0c             	sub    $0xc,%esp
    2827:	57                   	push   %edi
    2828:	e8 f1 14 00 00       	call   3d1e <close>
  if(total != 20*600){
    282d:	83 c4 10             	add    $0x10,%esp
    2830:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    2836:	75 27                	jne    285f <bigfile+0x1d0>
    printf(1, "read bigfile wrong total\n");
    exit(0);
  }
  unlink("bigfile");
    2838:	83 ec 0c             	sub    $0xc,%esp
    283b:	68 b8 4b 00 00       	push   $0x4bb8
    2840:	e8 01 15 00 00       	call   3d46 <unlink>

  printf(1, "bigfile test ok\n");
    2845:	83 c4 08             	add    $0x8,%esp
    2848:	68 47 4c 00 00       	push   $0x4c47
    284d:	6a 01                	push   $0x1
    284f:	e8 f1 15 00 00       	call   3e45 <printf>
}
    2854:	83 c4 10             	add    $0x10,%esp
    2857:	8d 65 f4             	lea    -0xc(%ebp),%esp
    285a:	5b                   	pop    %ebx
    285b:	5e                   	pop    %esi
    285c:	5f                   	pop    %edi
    285d:	5d                   	pop    %ebp
    285e:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    285f:	83 ec 08             	sub    $0x8,%esp
    2862:	68 2d 4c 00 00       	push   $0x4c2d
    2867:	6a 01                	push   $0x1
    2869:	e8 d7 15 00 00       	call   3e45 <printf>
    exit(0);
    286e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2875:	e8 7c 14 00 00       	call   3cf6 <exit>

0000287a <fourteen>:

void
fourteen(void)
{
    287a:	f3 0f 1e fb          	endbr32 
    287e:	55                   	push   %ebp
    287f:	89 e5                	mov    %esp,%ebp
    2881:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2884:	68 58 4c 00 00       	push   $0x4c58
    2889:	6a 01                	push   $0x1
    288b:	e8 b5 15 00 00       	call   3e45 <printf>

  if(mkdir("12345678901234") != 0){
    2890:	c7 04 24 93 4c 00 00 	movl   $0x4c93,(%esp)
    2897:	e8 c2 14 00 00       	call   3d5e <mkdir>
    289c:	83 c4 10             	add    $0x10,%esp
    289f:	85 c0                	test   %eax,%eax
    28a1:	0f 85 a4 00 00 00    	jne    294b <fourteen+0xd1>
    printf(1, "mkdir 12345678901234 failed\n");
    exit(0);
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    28a7:	83 ec 0c             	sub    $0xc,%esp
    28aa:	68 50 54 00 00       	push   $0x5450
    28af:	e8 aa 14 00 00       	call   3d5e <mkdir>
    28b4:	83 c4 10             	add    $0x10,%esp
    28b7:	85 c0                	test   %eax,%eax
    28b9:	0f 85 a7 00 00 00    	jne    2966 <fourteen+0xec>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit(0);
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    28bf:	83 ec 08             	sub    $0x8,%esp
    28c2:	68 00 02 00 00       	push   $0x200
    28c7:	68 a0 54 00 00       	push   $0x54a0
    28cc:	e8 65 14 00 00       	call   3d36 <open>
  if(fd < 0){
    28d1:	83 c4 10             	add    $0x10,%esp
    28d4:	85 c0                	test   %eax,%eax
    28d6:	0f 88 a5 00 00 00    	js     2981 <fourteen+0x107>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit(0);
  }
  close(fd);
    28dc:	83 ec 0c             	sub    $0xc,%esp
    28df:	50                   	push   %eax
    28e0:	e8 39 14 00 00       	call   3d1e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    28e5:	83 c4 08             	add    $0x8,%esp
    28e8:	6a 00                	push   $0x0
    28ea:	68 10 55 00 00       	push   $0x5510
    28ef:	e8 42 14 00 00       	call   3d36 <open>
  if(fd < 0){
    28f4:	83 c4 10             	add    $0x10,%esp
    28f7:	85 c0                	test   %eax,%eax
    28f9:	0f 88 9d 00 00 00    	js     299c <fourteen+0x122>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit(0);
  }
  close(fd);
    28ff:	83 ec 0c             	sub    $0xc,%esp
    2902:	50                   	push   %eax
    2903:	e8 16 14 00 00       	call   3d1e <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2908:	c7 04 24 84 4c 00 00 	movl   $0x4c84,(%esp)
    290f:	e8 4a 14 00 00       	call   3d5e <mkdir>
    2914:	83 c4 10             	add    $0x10,%esp
    2917:	85 c0                	test   %eax,%eax
    2919:	0f 84 98 00 00 00    	je     29b7 <fourteen+0x13d>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit(0);
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    291f:	83 ec 0c             	sub    $0xc,%esp
    2922:	68 ac 55 00 00       	push   $0x55ac
    2927:	e8 32 14 00 00       	call   3d5e <mkdir>
    292c:	83 c4 10             	add    $0x10,%esp
    292f:	85 c0                	test   %eax,%eax
    2931:	0f 84 9b 00 00 00    	je     29d2 <fourteen+0x158>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit(0);
  }

  printf(1, "fourteen ok\n");
    2937:	83 ec 08             	sub    $0x8,%esp
    293a:	68 a2 4c 00 00       	push   $0x4ca2
    293f:	6a 01                	push   $0x1
    2941:	e8 ff 14 00 00       	call   3e45 <printf>
}
    2946:	83 c4 10             	add    $0x10,%esp
    2949:	c9                   	leave  
    294a:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    294b:	83 ec 08             	sub    $0x8,%esp
    294e:	68 67 4c 00 00       	push   $0x4c67
    2953:	6a 01                	push   $0x1
    2955:	e8 eb 14 00 00       	call   3e45 <printf>
    exit(0);
    295a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2961:	e8 90 13 00 00       	call   3cf6 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2966:	83 ec 08             	sub    $0x8,%esp
    2969:	68 70 54 00 00       	push   $0x5470
    296e:	6a 01                	push   $0x1
    2970:	e8 d0 14 00 00       	call   3e45 <printf>
    exit(0);
    2975:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    297c:	e8 75 13 00 00       	call   3cf6 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2981:	83 ec 08             	sub    $0x8,%esp
    2984:	68 d0 54 00 00       	push   $0x54d0
    2989:	6a 01                	push   $0x1
    298b:	e8 b5 14 00 00       	call   3e45 <printf>
    exit(0);
    2990:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2997:	e8 5a 13 00 00       	call   3cf6 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    299c:	83 ec 08             	sub    $0x8,%esp
    299f:	68 40 55 00 00       	push   $0x5540
    29a4:	6a 01                	push   $0x1
    29a6:	e8 9a 14 00 00       	call   3e45 <printf>
    exit(0);
    29ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    29b2:	e8 3f 13 00 00       	call   3cf6 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    29b7:	83 ec 08             	sub    $0x8,%esp
    29ba:	68 7c 55 00 00       	push   $0x557c
    29bf:	6a 01                	push   $0x1
    29c1:	e8 7f 14 00 00       	call   3e45 <printf>
    exit(0);
    29c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    29cd:	e8 24 13 00 00       	call   3cf6 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    29d2:	83 ec 08             	sub    $0x8,%esp
    29d5:	68 cc 55 00 00       	push   $0x55cc
    29da:	6a 01                	push   $0x1
    29dc:	e8 64 14 00 00       	call   3e45 <printf>
    exit(0);
    29e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    29e8:	e8 09 13 00 00       	call   3cf6 <exit>

000029ed <rmdot>:

void
rmdot(void)
{
    29ed:	f3 0f 1e fb          	endbr32 
    29f1:	55                   	push   %ebp
    29f2:	89 e5                	mov    %esp,%ebp
    29f4:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    29f7:	68 af 4c 00 00       	push   $0x4caf
    29fc:	6a 01                	push   $0x1
    29fe:	e8 42 14 00 00       	call   3e45 <printf>
  if(mkdir("dots") != 0){
    2a03:	c7 04 24 bb 4c 00 00 	movl   $0x4cbb,(%esp)
    2a0a:	e8 4f 13 00 00       	call   3d5e <mkdir>
    2a0f:	83 c4 10             	add    $0x10,%esp
    2a12:	85 c0                	test   %eax,%eax
    2a14:	0f 85 bc 00 00 00    	jne    2ad6 <rmdot+0xe9>
    printf(1, "mkdir dots failed\n");
    exit(0);
  }
  if(chdir("dots") != 0){
    2a1a:	83 ec 0c             	sub    $0xc,%esp
    2a1d:	68 bb 4c 00 00       	push   $0x4cbb
    2a22:	e8 3f 13 00 00       	call   3d66 <chdir>
    2a27:	83 c4 10             	add    $0x10,%esp
    2a2a:	85 c0                	test   %eax,%eax
    2a2c:	0f 85 bf 00 00 00    	jne    2af1 <rmdot+0x104>
    printf(1, "chdir dots failed\n");
    exit(0);
  }
  if(unlink(".") == 0){
    2a32:	83 ec 0c             	sub    $0xc,%esp
    2a35:	68 66 49 00 00       	push   $0x4966
    2a3a:	e8 07 13 00 00       	call   3d46 <unlink>
    2a3f:	83 c4 10             	add    $0x10,%esp
    2a42:	85 c0                	test   %eax,%eax
    2a44:	0f 84 c2 00 00 00    	je     2b0c <rmdot+0x11f>
    printf(1, "rm . worked!\n");
    exit(0);
  }
  if(unlink("..") == 0){
    2a4a:	83 ec 0c             	sub    $0xc,%esp
    2a4d:	68 65 49 00 00       	push   $0x4965
    2a52:	e8 ef 12 00 00       	call   3d46 <unlink>
    2a57:	83 c4 10             	add    $0x10,%esp
    2a5a:	85 c0                	test   %eax,%eax
    2a5c:	0f 84 c5 00 00 00    	je     2b27 <rmdot+0x13a>
    printf(1, "rm .. worked!\n");
    exit(0);
  }
  if(chdir("/") != 0){
    2a62:	83 ec 0c             	sub    $0xc,%esp
    2a65:	68 3f 41 00 00       	push   $0x413f
    2a6a:	e8 f7 12 00 00       	call   3d66 <chdir>
    2a6f:	83 c4 10             	add    $0x10,%esp
    2a72:	85 c0                	test   %eax,%eax
    2a74:	0f 85 c8 00 00 00    	jne    2b42 <rmdot+0x155>
    printf(1, "chdir / failed\n");
    exit(0);
  }
  if(unlink("dots/.") == 0){
    2a7a:	83 ec 0c             	sub    $0xc,%esp
    2a7d:	68 03 4d 00 00       	push   $0x4d03
    2a82:	e8 bf 12 00 00       	call   3d46 <unlink>
    2a87:	83 c4 10             	add    $0x10,%esp
    2a8a:	85 c0                	test   %eax,%eax
    2a8c:	0f 84 cb 00 00 00    	je     2b5d <rmdot+0x170>
    printf(1, "unlink dots/. worked!\n");
    exit(0);
  }
  if(unlink("dots/..") == 0){
    2a92:	83 ec 0c             	sub    $0xc,%esp
    2a95:	68 21 4d 00 00       	push   $0x4d21
    2a9a:	e8 a7 12 00 00       	call   3d46 <unlink>
    2a9f:	83 c4 10             	add    $0x10,%esp
    2aa2:	85 c0                	test   %eax,%eax
    2aa4:	0f 84 ce 00 00 00    	je     2b78 <rmdot+0x18b>
    printf(1, "unlink dots/.. worked!\n");
    exit(0);
  }
  if(unlink("dots") != 0){
    2aaa:	83 ec 0c             	sub    $0xc,%esp
    2aad:	68 bb 4c 00 00       	push   $0x4cbb
    2ab2:	e8 8f 12 00 00       	call   3d46 <unlink>
    2ab7:	83 c4 10             	add    $0x10,%esp
    2aba:	85 c0                	test   %eax,%eax
    2abc:	0f 85 d1 00 00 00    	jne    2b93 <rmdot+0x1a6>
    printf(1, "unlink dots failed!\n");
    exit(0);
  }
  printf(1, "rmdot ok\n");
    2ac2:	83 ec 08             	sub    $0x8,%esp
    2ac5:	68 56 4d 00 00       	push   $0x4d56
    2aca:	6a 01                	push   $0x1
    2acc:	e8 74 13 00 00       	call   3e45 <printf>
}
    2ad1:	83 c4 10             	add    $0x10,%esp
    2ad4:	c9                   	leave  
    2ad5:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2ad6:	83 ec 08             	sub    $0x8,%esp
    2ad9:	68 c0 4c 00 00       	push   $0x4cc0
    2ade:	6a 01                	push   $0x1
    2ae0:	e8 60 13 00 00       	call   3e45 <printf>
    exit(0);
    2ae5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2aec:	e8 05 12 00 00       	call   3cf6 <exit>
    printf(1, "chdir dots failed\n");
    2af1:	83 ec 08             	sub    $0x8,%esp
    2af4:	68 d3 4c 00 00       	push   $0x4cd3
    2af9:	6a 01                	push   $0x1
    2afb:	e8 45 13 00 00       	call   3e45 <printf>
    exit(0);
    2b00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b07:	e8 ea 11 00 00       	call   3cf6 <exit>
    printf(1, "rm . worked!\n");
    2b0c:	83 ec 08             	sub    $0x8,%esp
    2b0f:	68 e6 4c 00 00       	push   $0x4ce6
    2b14:	6a 01                	push   $0x1
    2b16:	e8 2a 13 00 00       	call   3e45 <printf>
    exit(0);
    2b1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b22:	e8 cf 11 00 00       	call   3cf6 <exit>
    printf(1, "rm .. worked!\n");
    2b27:	83 ec 08             	sub    $0x8,%esp
    2b2a:	68 f4 4c 00 00       	push   $0x4cf4
    2b2f:	6a 01                	push   $0x1
    2b31:	e8 0f 13 00 00       	call   3e45 <printf>
    exit(0);
    2b36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b3d:	e8 b4 11 00 00       	call   3cf6 <exit>
    printf(1, "chdir / failed\n");
    2b42:	83 ec 08             	sub    $0x8,%esp
    2b45:	68 41 41 00 00       	push   $0x4141
    2b4a:	6a 01                	push   $0x1
    2b4c:	e8 f4 12 00 00       	call   3e45 <printf>
    exit(0);
    2b51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b58:	e8 99 11 00 00       	call   3cf6 <exit>
    printf(1, "unlink dots/. worked!\n");
    2b5d:	83 ec 08             	sub    $0x8,%esp
    2b60:	68 0a 4d 00 00       	push   $0x4d0a
    2b65:	6a 01                	push   $0x1
    2b67:	e8 d9 12 00 00       	call   3e45 <printf>
    exit(0);
    2b6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b73:	e8 7e 11 00 00       	call   3cf6 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2b78:	83 ec 08             	sub    $0x8,%esp
    2b7b:	68 29 4d 00 00       	push   $0x4d29
    2b80:	6a 01                	push   $0x1
    2b82:	e8 be 12 00 00       	call   3e45 <printf>
    exit(0);
    2b87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b8e:	e8 63 11 00 00       	call   3cf6 <exit>
    printf(1, "unlink dots failed!\n");
    2b93:	83 ec 08             	sub    $0x8,%esp
    2b96:	68 41 4d 00 00       	push   $0x4d41
    2b9b:	6a 01                	push   $0x1
    2b9d:	e8 a3 12 00 00       	call   3e45 <printf>
    exit(0);
    2ba2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ba9:	e8 48 11 00 00       	call   3cf6 <exit>

00002bae <dirfile>:

void
dirfile(void)
{
    2bae:	f3 0f 1e fb          	endbr32 
    2bb2:	55                   	push   %ebp
    2bb3:	89 e5                	mov    %esp,%ebp
    2bb5:	53                   	push   %ebx
    2bb6:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    2bb9:	68 60 4d 00 00       	push   $0x4d60
    2bbe:	6a 01                	push   $0x1
    2bc0:	e8 80 12 00 00       	call   3e45 <printf>

  fd = open("dirfile", O_CREATE);
    2bc5:	83 c4 08             	add    $0x8,%esp
    2bc8:	68 00 02 00 00       	push   $0x200
    2bcd:	68 6d 4d 00 00       	push   $0x4d6d
    2bd2:	e8 5f 11 00 00       	call   3d36 <open>
  if(fd < 0){
    2bd7:	83 c4 10             	add    $0x10,%esp
    2bda:	85 c0                	test   %eax,%eax
    2bdc:	0f 88 22 01 00 00    	js     2d04 <dirfile+0x156>
    printf(1, "create dirfile failed\n");
    exit(0);
  }
  close(fd);
    2be2:	83 ec 0c             	sub    $0xc,%esp
    2be5:	50                   	push   %eax
    2be6:	e8 33 11 00 00       	call   3d1e <close>
  if(chdir("dirfile") == 0){
    2beb:	c7 04 24 6d 4d 00 00 	movl   $0x4d6d,(%esp)
    2bf2:	e8 6f 11 00 00       	call   3d66 <chdir>
    2bf7:	83 c4 10             	add    $0x10,%esp
    2bfa:	85 c0                	test   %eax,%eax
    2bfc:	0f 84 1d 01 00 00    	je     2d1f <dirfile+0x171>
    printf(1, "chdir dirfile succeeded!\n");
    exit(0);
  }
  fd = open("dirfile/xx", 0);
    2c02:	83 ec 08             	sub    $0x8,%esp
    2c05:	6a 00                	push   $0x0
    2c07:	68 a6 4d 00 00       	push   $0x4da6
    2c0c:	e8 25 11 00 00       	call   3d36 <open>
  if(fd >= 0){
    2c11:	83 c4 10             	add    $0x10,%esp
    2c14:	85 c0                	test   %eax,%eax
    2c16:	0f 89 1e 01 00 00    	jns    2d3a <dirfile+0x18c>
    printf(1, "create dirfile/xx succeeded!\n");
    exit(0);
  }
  fd = open("dirfile/xx", O_CREATE);
    2c1c:	83 ec 08             	sub    $0x8,%esp
    2c1f:	68 00 02 00 00       	push   $0x200
    2c24:	68 a6 4d 00 00       	push   $0x4da6
    2c29:	e8 08 11 00 00       	call   3d36 <open>
  if(fd >= 0){
    2c2e:	83 c4 10             	add    $0x10,%esp
    2c31:	85 c0                	test   %eax,%eax
    2c33:	0f 89 1c 01 00 00    	jns    2d55 <dirfile+0x1a7>
    printf(1, "create dirfile/xx succeeded!\n");
    exit(0);
  }
  if(mkdir("dirfile/xx") == 0){
    2c39:	83 ec 0c             	sub    $0xc,%esp
    2c3c:	68 a6 4d 00 00       	push   $0x4da6
    2c41:	e8 18 11 00 00       	call   3d5e <mkdir>
    2c46:	83 c4 10             	add    $0x10,%esp
    2c49:	85 c0                	test   %eax,%eax
    2c4b:	0f 84 1f 01 00 00    	je     2d70 <dirfile+0x1c2>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit(0);
  }
  if(unlink("dirfile/xx") == 0){
    2c51:	83 ec 0c             	sub    $0xc,%esp
    2c54:	68 a6 4d 00 00       	push   $0x4da6
    2c59:	e8 e8 10 00 00       	call   3d46 <unlink>
    2c5e:	83 c4 10             	add    $0x10,%esp
    2c61:	85 c0                	test   %eax,%eax
    2c63:	0f 84 22 01 00 00    	je     2d8b <dirfile+0x1dd>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit(0);
  }
  if(link("README", "dirfile/xx") == 0){
    2c69:	83 ec 08             	sub    $0x8,%esp
    2c6c:	68 a6 4d 00 00       	push   $0x4da6
    2c71:	68 0a 4e 00 00       	push   $0x4e0a
    2c76:	e8 db 10 00 00       	call   3d56 <link>
    2c7b:	83 c4 10             	add    $0x10,%esp
    2c7e:	85 c0                	test   %eax,%eax
    2c80:	0f 84 20 01 00 00    	je     2da6 <dirfile+0x1f8>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit(0);
  }
  if(unlink("dirfile") != 0){
    2c86:	83 ec 0c             	sub    $0xc,%esp
    2c89:	68 6d 4d 00 00       	push   $0x4d6d
    2c8e:	e8 b3 10 00 00       	call   3d46 <unlink>
    2c93:	83 c4 10             	add    $0x10,%esp
    2c96:	85 c0                	test   %eax,%eax
    2c98:	0f 85 23 01 00 00    	jne    2dc1 <dirfile+0x213>
    printf(1, "unlink dirfile failed!\n");
    exit(0);
  }

  fd = open(".", O_RDWR);
    2c9e:	83 ec 08             	sub    $0x8,%esp
    2ca1:	6a 02                	push   $0x2
    2ca3:	68 66 49 00 00       	push   $0x4966
    2ca8:	e8 89 10 00 00       	call   3d36 <open>
  if(fd >= 0){
    2cad:	83 c4 10             	add    $0x10,%esp
    2cb0:	85 c0                	test   %eax,%eax
    2cb2:	0f 89 24 01 00 00    	jns    2ddc <dirfile+0x22e>
    printf(1, "open . for writing succeeded!\n");
    exit(0);
  }
  fd = open(".", 0);
    2cb8:	83 ec 08             	sub    $0x8,%esp
    2cbb:	6a 00                	push   $0x0
    2cbd:	68 66 49 00 00       	push   $0x4966
    2cc2:	e8 6f 10 00 00       	call   3d36 <open>
    2cc7:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2cc9:	83 c4 0c             	add    $0xc,%esp
    2ccc:	6a 01                	push   $0x1
    2cce:	68 49 4a 00 00       	push   $0x4a49
    2cd3:	50                   	push   %eax
    2cd4:	e8 3d 10 00 00       	call   3d16 <write>
    2cd9:	83 c4 10             	add    $0x10,%esp
    2cdc:	85 c0                	test   %eax,%eax
    2cde:	0f 8f 13 01 00 00    	jg     2df7 <dirfile+0x249>
    printf(1, "write . succeeded!\n");
    exit(0);
  }
  close(fd);
    2ce4:	83 ec 0c             	sub    $0xc,%esp
    2ce7:	53                   	push   %ebx
    2ce8:	e8 31 10 00 00       	call   3d1e <close>

  printf(1, "dir vs file OK\n");
    2ced:	83 c4 08             	add    $0x8,%esp
    2cf0:	68 3d 4e 00 00       	push   $0x4e3d
    2cf5:	6a 01                	push   $0x1
    2cf7:	e8 49 11 00 00       	call   3e45 <printf>
}
    2cfc:	83 c4 10             	add    $0x10,%esp
    2cff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2d02:	c9                   	leave  
    2d03:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    2d04:	83 ec 08             	sub    $0x8,%esp
    2d07:	68 75 4d 00 00       	push   $0x4d75
    2d0c:	6a 01                	push   $0x1
    2d0e:	e8 32 11 00 00       	call   3e45 <printf>
    exit(0);
    2d13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d1a:	e8 d7 0f 00 00       	call   3cf6 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2d1f:	83 ec 08             	sub    $0x8,%esp
    2d22:	68 8c 4d 00 00       	push   $0x4d8c
    2d27:	6a 01                	push   $0x1
    2d29:	e8 17 11 00 00       	call   3e45 <printf>
    exit(0);
    2d2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d35:	e8 bc 0f 00 00       	call   3cf6 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2d3a:	83 ec 08             	sub    $0x8,%esp
    2d3d:	68 b1 4d 00 00       	push   $0x4db1
    2d42:	6a 01                	push   $0x1
    2d44:	e8 fc 10 00 00       	call   3e45 <printf>
    exit(0);
    2d49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d50:	e8 a1 0f 00 00       	call   3cf6 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2d55:	83 ec 08             	sub    $0x8,%esp
    2d58:	68 b1 4d 00 00       	push   $0x4db1
    2d5d:	6a 01                	push   $0x1
    2d5f:	e8 e1 10 00 00       	call   3e45 <printf>
    exit(0);
    2d64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d6b:	e8 86 0f 00 00       	call   3cf6 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2d70:	83 ec 08             	sub    $0x8,%esp
    2d73:	68 cf 4d 00 00       	push   $0x4dcf
    2d78:	6a 01                	push   $0x1
    2d7a:	e8 c6 10 00 00       	call   3e45 <printf>
    exit(0);
    2d7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d86:	e8 6b 0f 00 00       	call   3cf6 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2d8b:	83 ec 08             	sub    $0x8,%esp
    2d8e:	68 ec 4d 00 00       	push   $0x4dec
    2d93:	6a 01                	push   $0x1
    2d95:	e8 ab 10 00 00       	call   3e45 <printf>
    exit(0);
    2d9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2da1:	e8 50 0f 00 00       	call   3cf6 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2da6:	83 ec 08             	sub    $0x8,%esp
    2da9:	68 00 56 00 00       	push   $0x5600
    2dae:	6a 01                	push   $0x1
    2db0:	e8 90 10 00 00       	call   3e45 <printf>
    exit(0);
    2db5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2dbc:	e8 35 0f 00 00       	call   3cf6 <exit>
    printf(1, "unlink dirfile failed!\n");
    2dc1:	83 ec 08             	sub    $0x8,%esp
    2dc4:	68 11 4e 00 00       	push   $0x4e11
    2dc9:	6a 01                	push   $0x1
    2dcb:	e8 75 10 00 00       	call   3e45 <printf>
    exit(0);
    2dd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2dd7:	e8 1a 0f 00 00       	call   3cf6 <exit>
    printf(1, "open . for writing succeeded!\n");
    2ddc:	83 ec 08             	sub    $0x8,%esp
    2ddf:	68 20 56 00 00       	push   $0x5620
    2de4:	6a 01                	push   $0x1
    2de6:	e8 5a 10 00 00       	call   3e45 <printf>
    exit(0);
    2deb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2df2:	e8 ff 0e 00 00       	call   3cf6 <exit>
    printf(1, "write . succeeded!\n");
    2df7:	83 ec 08             	sub    $0x8,%esp
    2dfa:	68 29 4e 00 00       	push   $0x4e29
    2dff:	6a 01                	push   $0x1
    2e01:	e8 3f 10 00 00       	call   3e45 <printf>
    exit(0);
    2e06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e0d:	e8 e4 0e 00 00       	call   3cf6 <exit>

00002e12 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2e12:	f3 0f 1e fb          	endbr32 
    2e16:	55                   	push   %ebp
    2e17:	89 e5                	mov    %esp,%ebp
    2e19:	53                   	push   %ebx
    2e1a:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2e1d:	68 4d 4e 00 00       	push   $0x4e4d
    2e22:	6a 01                	push   $0x1
    2e24:	e8 1c 10 00 00       	call   3e45 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2e29:	83 c4 10             	add    $0x10,%esp
    2e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
    2e31:	eb 55                	jmp    2e88 <iref+0x76>
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    2e33:	83 ec 08             	sub    $0x8,%esp
    2e36:	68 64 4e 00 00       	push   $0x4e64
    2e3b:	6a 01                	push   $0x1
    2e3d:	e8 03 10 00 00       	call   3e45 <printf>
      exit(0);
    2e42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e49:	e8 a8 0e 00 00       	call   3cf6 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    2e4e:	83 ec 08             	sub    $0x8,%esp
    2e51:	68 78 4e 00 00       	push   $0x4e78
    2e56:	6a 01                	push   $0x1
    2e58:	e8 e8 0f 00 00       	call   3e45 <printf>
      exit(0);
    2e5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e64:	e8 8d 0e 00 00       	call   3cf6 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    2e69:	83 ec 0c             	sub    $0xc,%esp
    2e6c:	50                   	push   %eax
    2e6d:	e8 ac 0e 00 00       	call   3d1e <close>
    2e72:	83 c4 10             	add    $0x10,%esp
    2e75:	eb 7e                	jmp    2ef5 <iref+0xe3>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2e77:	83 ec 0c             	sub    $0xc,%esp
    2e7a:	68 48 4a 00 00       	push   $0x4a48
    2e7f:	e8 c2 0e 00 00       	call   3d46 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2e84:	43                   	inc    %ebx
    2e85:	83 c4 10             	add    $0x10,%esp
    2e88:	83 fb 32             	cmp    $0x32,%ebx
    2e8b:	0f 8f 92 00 00 00    	jg     2f23 <iref+0x111>
    if(mkdir("irefd") != 0){
    2e91:	83 ec 0c             	sub    $0xc,%esp
    2e94:	68 5e 4e 00 00       	push   $0x4e5e
    2e99:	e8 c0 0e 00 00       	call   3d5e <mkdir>
    2e9e:	83 c4 10             	add    $0x10,%esp
    2ea1:	85 c0                	test   %eax,%eax
    2ea3:	75 8e                	jne    2e33 <iref+0x21>
    if(chdir("irefd") != 0){
    2ea5:	83 ec 0c             	sub    $0xc,%esp
    2ea8:	68 5e 4e 00 00       	push   $0x4e5e
    2ead:	e8 b4 0e 00 00       	call   3d66 <chdir>
    2eb2:	83 c4 10             	add    $0x10,%esp
    2eb5:	85 c0                	test   %eax,%eax
    2eb7:	75 95                	jne    2e4e <iref+0x3c>
    mkdir("");
    2eb9:	83 ec 0c             	sub    $0xc,%esp
    2ebc:	68 19 45 00 00       	push   $0x4519
    2ec1:	e8 98 0e 00 00       	call   3d5e <mkdir>
    link("README", "");
    2ec6:	83 c4 08             	add    $0x8,%esp
    2ec9:	68 19 45 00 00       	push   $0x4519
    2ece:	68 0a 4e 00 00       	push   $0x4e0a
    2ed3:	e8 7e 0e 00 00       	call   3d56 <link>
    fd = open("", O_CREATE);
    2ed8:	83 c4 08             	add    $0x8,%esp
    2edb:	68 00 02 00 00       	push   $0x200
    2ee0:	68 19 45 00 00       	push   $0x4519
    2ee5:	e8 4c 0e 00 00       	call   3d36 <open>
    if(fd >= 0)
    2eea:	83 c4 10             	add    $0x10,%esp
    2eed:	85 c0                	test   %eax,%eax
    2eef:	0f 89 74 ff ff ff    	jns    2e69 <iref+0x57>
    fd = open("xx", O_CREATE);
    2ef5:	83 ec 08             	sub    $0x8,%esp
    2ef8:	68 00 02 00 00       	push   $0x200
    2efd:	68 48 4a 00 00       	push   $0x4a48
    2f02:	e8 2f 0e 00 00       	call   3d36 <open>
    if(fd >= 0)
    2f07:	83 c4 10             	add    $0x10,%esp
    2f0a:	85 c0                	test   %eax,%eax
    2f0c:	0f 88 65 ff ff ff    	js     2e77 <iref+0x65>
      close(fd);
    2f12:	83 ec 0c             	sub    $0xc,%esp
    2f15:	50                   	push   %eax
    2f16:	e8 03 0e 00 00       	call   3d1e <close>
    2f1b:	83 c4 10             	add    $0x10,%esp
    2f1e:	e9 54 ff ff ff       	jmp    2e77 <iref+0x65>
  }

  chdir("/");
    2f23:	83 ec 0c             	sub    $0xc,%esp
    2f26:	68 3f 41 00 00       	push   $0x413f
    2f2b:	e8 36 0e 00 00       	call   3d66 <chdir>
  printf(1, "empty file name OK\n");
    2f30:	83 c4 08             	add    $0x8,%esp
    2f33:	68 8c 4e 00 00       	push   $0x4e8c
    2f38:	6a 01                	push   $0x1
    2f3a:	e8 06 0f 00 00       	call   3e45 <printf>
}
    2f3f:	83 c4 10             	add    $0x10,%esp
    2f42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2f45:	c9                   	leave  
    2f46:	c3                   	ret    

00002f47 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2f47:	f3 0f 1e fb          	endbr32 
    2f4b:	55                   	push   %ebp
    2f4c:	89 e5                	mov    %esp,%ebp
    2f4e:	53                   	push   %ebx
    2f4f:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2f52:	68 a0 4e 00 00       	push   $0x4ea0
    2f57:	6a 01                	push   $0x1
    2f59:	e8 e7 0e 00 00       	call   3e45 <printf>

  for(n=0; n<1000; n++){
    2f5e:	83 c4 10             	add    $0x10,%esp
    2f61:	bb 00 00 00 00       	mov    $0x0,%ebx
    2f66:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    2f6c:	7f 18                	jg     2f86 <forktest+0x3f>
    pid = fork();
    2f6e:	e8 7b 0d 00 00       	call   3cee <fork>
    if(pid < 0)
    2f73:	85 c0                	test   %eax,%eax
    2f75:	78 0f                	js     2f86 <forktest+0x3f>
      break;
    if(pid == 0)
    2f77:	74 03                	je     2f7c <forktest+0x35>
  for(n=0; n<1000; n++){
    2f79:	43                   	inc    %ebx
    2f7a:	eb ea                	jmp    2f66 <forktest+0x1f>
      exit(0);
    2f7c:	83 ec 0c             	sub    $0xc,%esp
    2f7f:	6a 00                	push   $0x0
    2f81:	e8 70 0d 00 00       	call   3cf6 <exit>
  }

  if(n == 1000){
    2f86:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2f8c:	74 18                	je     2fa6 <forktest+0x5f>
    printf(1, "fork claimed to work 1000 times!\n");
    exit(0);
  }

  for(; n > 0; n--){
    2f8e:	85 db                	test   %ebx,%ebx
    2f90:	7e 4a                	jle    2fdc <forktest+0x95>
    if(wait(NULL) < 0){
    2f92:	83 ec 0c             	sub    $0xc,%esp
    2f95:	6a 00                	push   $0x0
    2f97:	e8 62 0d 00 00       	call   3cfe <wait>
    2f9c:	83 c4 10             	add    $0x10,%esp
    2f9f:	85 c0                	test   %eax,%eax
    2fa1:	78 1e                	js     2fc1 <forktest+0x7a>
  for(; n > 0; n--){
    2fa3:	4b                   	dec    %ebx
    2fa4:	eb e8                	jmp    2f8e <forktest+0x47>
    printf(1, "fork claimed to work 1000 times!\n");
    2fa6:	83 ec 08             	sub    $0x8,%esp
    2fa9:	68 40 56 00 00       	push   $0x5640
    2fae:	6a 01                	push   $0x1
    2fb0:	e8 90 0e 00 00       	call   3e45 <printf>
    exit(0);
    2fb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fbc:	e8 35 0d 00 00       	call   3cf6 <exit>
      printf(1, "wait stopped early\n");
    2fc1:	83 ec 08             	sub    $0x8,%esp
    2fc4:	68 ab 4e 00 00       	push   $0x4eab
    2fc9:	6a 01                	push   $0x1
    2fcb:	e8 75 0e 00 00       	call   3e45 <printf>
      exit(0);
    2fd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fd7:	e8 1a 0d 00 00       	call   3cf6 <exit>
    }
  }

  if(wait(NULL) != -1){
    2fdc:	83 ec 0c             	sub    $0xc,%esp
    2fdf:	6a 00                	push   $0x0
    2fe1:	e8 18 0d 00 00       	call   3cfe <wait>
    2fe6:	83 c4 10             	add    $0x10,%esp
    2fe9:	83 f8 ff             	cmp    $0xffffffff,%eax
    2fec:	75 17                	jne    3005 <forktest+0xbe>
    printf(1, "wait got too many\n");
    exit(0);
  }

  printf(1, "fork test OK\n");
    2fee:	83 ec 08             	sub    $0x8,%esp
    2ff1:	68 d2 4e 00 00       	push   $0x4ed2
    2ff6:	6a 01                	push   $0x1
    2ff8:	e8 48 0e 00 00       	call   3e45 <printf>
}
    2ffd:	83 c4 10             	add    $0x10,%esp
    3000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3003:	c9                   	leave  
    3004:	c3                   	ret    
    printf(1, "wait got too many\n");
    3005:	83 ec 08             	sub    $0x8,%esp
    3008:	68 bf 4e 00 00       	push   $0x4ebf
    300d:	6a 01                	push   $0x1
    300f:	e8 31 0e 00 00       	call   3e45 <printf>
    exit(0);
    3014:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    301b:	e8 d6 0c 00 00       	call   3cf6 <exit>

00003020 <sbrktest>:

void
sbrktest(void)
{
    3020:	f3 0f 1e fb          	endbr32 
    3024:	55                   	push   %ebp
    3025:	89 e5                	mov    %esp,%ebp
    3027:	57                   	push   %edi
    3028:	56                   	push   %esi
    3029:	53                   	push   %ebx
    302a:	83 ec 54             	sub    $0x54,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    302d:	68 e0 4e 00 00       	push   $0x4ee0
    3032:	ff 35 40 61 00 00    	pushl  0x6140
    3038:	e8 08 0e 00 00       	call   3e45 <printf>
  oldbrk = sbrk(0);
    303d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3044:	e8 3d 0d 00 00       	call   3d86 <sbrk>
    3049:	89 c7                	mov    %eax,%edi

  // can one sbrk() less than a page?
  a = sbrk(0);
    304b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3052:	e8 2f 0d 00 00       	call   3d86 <sbrk>
    3057:	89 c6                	mov    %eax,%esi
  int i;
  for(i = 0; i < 5000; i++){
    3059:	83 c4 10             	add    $0x10,%esp
    305c:	bb 00 00 00 00       	mov    $0x0,%ebx
    3061:	81 fb 87 13 00 00    	cmp    $0x1387,%ebx
    3067:	7f 3a                	jg     30a3 <sbrktest+0x83>
    b = sbrk(1);
    3069:	83 ec 0c             	sub    $0xc,%esp
    306c:	6a 01                	push   $0x1
    306e:	e8 13 0d 00 00       	call   3d86 <sbrk>
    if(b != a){
    3073:	83 c4 10             	add    $0x10,%esp
    3076:	39 c6                	cmp    %eax,%esi
    3078:	75 09                	jne    3083 <sbrktest+0x63>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit(0);
    }
    *b = 1;
    307a:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    307d:	8d 70 01             	lea    0x1(%eax),%esi
  for(i = 0; i < 5000; i++){
    3080:	43                   	inc    %ebx
    3081:	eb de                	jmp    3061 <sbrktest+0x41>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3083:	83 ec 0c             	sub    $0xc,%esp
    3086:	50                   	push   %eax
    3087:	56                   	push   %esi
    3088:	53                   	push   %ebx
    3089:	68 eb 4e 00 00       	push   $0x4eeb
    308e:	ff 35 40 61 00 00    	pushl  0x6140
    3094:	e8 ac 0d 00 00       	call   3e45 <printf>
      exit(0);
    3099:	83 c4 14             	add    $0x14,%esp
    309c:	6a 00                	push   $0x0
    309e:	e8 53 0c 00 00       	call   3cf6 <exit>
  }
  pid = fork();
    30a3:	e8 46 0c 00 00       	call   3cee <fork>
    30a8:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
    30aa:	85 c0                	test   %eax,%eax
    30ac:	0f 88 5e 01 00 00    	js     3210 <sbrktest+0x1f0>
    printf(stdout, "sbrk test fork failed\n");
    exit(0);
  }
  c = sbrk(1);
    30b2:	83 ec 0c             	sub    $0xc,%esp
    30b5:	6a 01                	push   $0x1
    30b7:	e8 ca 0c 00 00       	call   3d86 <sbrk>
  c = sbrk(1);
    30bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30c3:	e8 be 0c 00 00       	call   3d86 <sbrk>
  if(c != a + 1){
    30c8:	46                   	inc    %esi
    30c9:	83 c4 10             	add    $0x10,%esp
    30cc:	39 c6                	cmp    %eax,%esi
    30ce:	0f 85 5b 01 00 00    	jne    322f <sbrktest+0x20f>
    printf(stdout, "sbrk test failed post-fork\n");
    exit(0);
  }
  if(pid == 0)
    30d4:	85 db                	test   %ebx,%ebx
    30d6:	0f 84 72 01 00 00    	je     324e <sbrktest+0x22e>
    exit(0);
  wait(NULL);
    30dc:	83 ec 0c             	sub    $0xc,%esp
    30df:	6a 00                	push   $0x0
    30e1:	e8 18 0c 00 00       	call   3cfe <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    30e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30ed:	e8 94 0c 00 00       	call   3d86 <sbrk>
    30f2:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    30f4:	b8 00 00 40 06       	mov    $0x6400000,%eax
    30f9:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    30fb:	89 04 24             	mov    %eax,(%esp)
    30fe:	e8 83 0c 00 00       	call   3d86 <sbrk>
  if (p != a) {
    3103:	83 c4 10             	add    $0x10,%esp
    3106:	39 c3                	cmp    %eax,%ebx
    3108:	0f 85 4a 01 00 00    	jne    3258 <sbrktest+0x238>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit(0);
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    310e:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    3115:	83 ec 0c             	sub    $0xc,%esp
    3118:	6a 00                	push   $0x0
    311a:	e8 67 0c 00 00       	call   3d86 <sbrk>
    311f:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    3121:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3128:	e8 59 0c 00 00       	call   3d86 <sbrk>
  if(c == (char*)0xffffffff){
    312d:	83 c4 10             	add    $0x10,%esp
    3130:	83 f8 ff             	cmp    $0xffffffff,%eax
    3133:	0f 84 3e 01 00 00    	je     3277 <sbrktest+0x257>
    printf(stdout, "sbrk could not deallocate\n");
    exit(0);
  }
  c = sbrk(0);
    3139:	83 ec 0c             	sub    $0xc,%esp
    313c:	6a 00                	push   $0x0
    313e:	e8 43 0c 00 00       	call   3d86 <sbrk>
  if(c != a - 4096){
    3143:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    3149:	83 c4 10             	add    $0x10,%esp
    314c:	39 c2                	cmp    %eax,%edx
    314e:	0f 85 42 01 00 00    	jne    3296 <sbrktest+0x276>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit(0);
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3154:	83 ec 0c             	sub    $0xc,%esp
    3157:	6a 00                	push   $0x0
    3159:	e8 28 0c 00 00       	call   3d86 <sbrk>
    315e:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    3160:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3167:	e8 1a 0c 00 00       	call   3d86 <sbrk>
    316c:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    316e:	83 c4 10             	add    $0x10,%esp
    3171:	39 c3                	cmp    %eax,%ebx
    3173:	0f 85 3b 01 00 00    	jne    32b4 <sbrktest+0x294>
    3179:	83 ec 0c             	sub    $0xc,%esp
    317c:	6a 00                	push   $0x0
    317e:	e8 03 0c 00 00       	call   3d86 <sbrk>
    3183:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    3189:	83 c4 10             	add    $0x10,%esp
    318c:	39 c2                	cmp    %eax,%edx
    318e:	0f 85 20 01 00 00    	jne    32b4 <sbrktest+0x294>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit(0);
  }
  if(*lastaddr == 99){
    3194:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    319b:	0f 84 31 01 00 00    	je     32d2 <sbrktest+0x2b2>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit(0);
  }

  a = sbrk(0);
    31a1:	83 ec 0c             	sub    $0xc,%esp
    31a4:	6a 00                	push   $0x0
    31a6:	e8 db 0b 00 00       	call   3d86 <sbrk>
    31ab:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    31ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31b4:	e8 cd 0b 00 00       	call   3d86 <sbrk>
    31b9:	89 f9                	mov    %edi,%ecx
    31bb:	29 c1                	sub    %eax,%ecx
    31bd:	89 0c 24             	mov    %ecx,(%esp)
    31c0:	e8 c1 0b 00 00       	call   3d86 <sbrk>
  if(c != a){
    31c5:	83 c4 10             	add    $0x10,%esp
    31c8:	39 c3                	cmp    %eax,%ebx
    31ca:	0f 85 21 01 00 00    	jne    32f1 <sbrktest+0x2d1>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit(0);
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    31d0:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    31d5:	81 fb 7f 84 1e 80    	cmp    $0x801e847f,%ebx
    31db:	0f 87 76 01 00 00    	ja     3357 <sbrktest+0x337>
    ppid = getpid();
    31e1:	e8 98 0b 00 00       	call   3d7e <getpid>
    31e6:	89 c6                	mov    %eax,%esi
    pid = fork();
    31e8:	e8 01 0b 00 00       	call   3cee <fork>
    if(pid < 0){
    31ed:	85 c0                	test   %eax,%eax
    31ef:	0f 88 1a 01 00 00    	js     330f <sbrktest+0x2ef>
      printf(stdout, "fork failed\n");
      exit(0);
    }
    if(pid == 0){
    31f5:	0f 84 33 01 00 00    	je     332e <sbrktest+0x30e>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit(0);
    }
    wait(NULL);
    31fb:	83 ec 0c             	sub    $0xc,%esp
    31fe:	6a 00                	push   $0x0
    3200:	e8 f9 0a 00 00       	call   3cfe <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3205:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    320b:	83 c4 10             	add    $0x10,%esp
    320e:	eb c5                	jmp    31d5 <sbrktest+0x1b5>
    printf(stdout, "sbrk test fork failed\n");
    3210:	83 ec 08             	sub    $0x8,%esp
    3213:	68 06 4f 00 00       	push   $0x4f06
    3218:	ff 35 40 61 00 00    	pushl  0x6140
    321e:	e8 22 0c 00 00       	call   3e45 <printf>
    exit(0);
    3223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    322a:	e8 c7 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    322f:	83 ec 08             	sub    $0x8,%esp
    3232:	68 1d 4f 00 00       	push   $0x4f1d
    3237:	ff 35 40 61 00 00    	pushl  0x6140
    323d:	e8 03 0c 00 00       	call   3e45 <printf>
    exit(0);
    3242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3249:	e8 a8 0a 00 00       	call   3cf6 <exit>
    exit(0);
    324e:	83 ec 0c             	sub    $0xc,%esp
    3251:	6a 00                	push   $0x0
    3253:	e8 9e 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3258:	83 ec 08             	sub    $0x8,%esp
    325b:	68 64 56 00 00       	push   $0x5664
    3260:	ff 35 40 61 00 00    	pushl  0x6140
    3266:	e8 da 0b 00 00       	call   3e45 <printf>
    exit(0);
    326b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3272:	e8 7f 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    3277:	83 ec 08             	sub    $0x8,%esp
    327a:	68 39 4f 00 00       	push   $0x4f39
    327f:	ff 35 40 61 00 00    	pushl  0x6140
    3285:	e8 bb 0b 00 00       	call   3e45 <printf>
    exit(0);
    328a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3291:	e8 60 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3296:	50                   	push   %eax
    3297:	53                   	push   %ebx
    3298:	68 a4 56 00 00       	push   $0x56a4
    329d:	ff 35 40 61 00 00    	pushl  0x6140
    32a3:	e8 9d 0b 00 00       	call   3e45 <printf>
    exit(0);
    32a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32af:	e8 42 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    32b4:	56                   	push   %esi
    32b5:	53                   	push   %ebx
    32b6:	68 dc 56 00 00       	push   $0x56dc
    32bb:	ff 35 40 61 00 00    	pushl  0x6140
    32c1:	e8 7f 0b 00 00       	call   3e45 <printf>
    exit(0);
    32c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32cd:	e8 24 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    32d2:	83 ec 08             	sub    $0x8,%esp
    32d5:	68 04 57 00 00       	push   $0x5704
    32da:	ff 35 40 61 00 00    	pushl  0x6140
    32e0:	e8 60 0b 00 00       	call   3e45 <printf>
    exit(0);
    32e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32ec:	e8 05 0a 00 00       	call   3cf6 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    32f1:	50                   	push   %eax
    32f2:	53                   	push   %ebx
    32f3:	68 34 57 00 00       	push   $0x5734
    32f8:	ff 35 40 61 00 00    	pushl  0x6140
    32fe:	e8 42 0b 00 00       	call   3e45 <printf>
    exit(0);
    3303:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    330a:	e8 e7 09 00 00       	call   3cf6 <exit>
      printf(stdout, "fork failed\n");
    330f:	83 ec 08             	sub    $0x8,%esp
    3312:	68 31 50 00 00       	push   $0x5031
    3317:	ff 35 40 61 00 00    	pushl  0x6140
    331d:	e8 23 0b 00 00       	call   3e45 <printf>
      exit(0);
    3322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3329:	e8 c8 09 00 00       	call   3cf6 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    332e:	0f be 03             	movsbl (%ebx),%eax
    3331:	50                   	push   %eax
    3332:	53                   	push   %ebx
    3333:	68 54 4f 00 00       	push   $0x4f54
    3338:	ff 35 40 61 00 00    	pushl  0x6140
    333e:	e8 02 0b 00 00       	call   3e45 <printf>
      kill(ppid);
    3343:	89 34 24             	mov    %esi,(%esp)
    3346:	e8 db 09 00 00       	call   3d26 <kill>
      exit(0);
    334b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3352:	e8 9f 09 00 00       	call   3cf6 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3357:	83 ec 0c             	sub    $0xc,%esp
    335a:	8d 45 e0             	lea    -0x20(%ebp),%eax
    335d:	50                   	push   %eax
    335e:	e8 a3 09 00 00       	call   3d06 <pipe>
    3363:	89 c3                	mov    %eax,%ebx
    3365:	83 c4 10             	add    $0x10,%esp
    3368:	85 c0                	test   %eax,%eax
    336a:	75 04                	jne    3370 <sbrktest+0x350>
    printf(1, "pipe() failed\n");
    exit(0);
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    336c:	89 c6                	mov    %eax,%esi
    336e:	eb 5e                	jmp    33ce <sbrktest+0x3ae>
    printf(1, "pipe() failed\n");
    3370:	83 ec 08             	sub    $0x8,%esp
    3373:	68 2f 44 00 00       	push   $0x442f
    3378:	6a 01                	push   $0x1
    337a:	e8 c6 0a 00 00       	call   3e45 <printf>
    exit(0);
    337f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3386:	e8 6b 09 00 00       	call   3cf6 <exit>
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    338b:	83 ec 0c             	sub    $0xc,%esp
    338e:	6a 00                	push   $0x0
    3390:	e8 f1 09 00 00       	call   3d86 <sbrk>
    3395:	89 c2                	mov    %eax,%edx
    3397:	b8 00 00 40 06       	mov    $0x6400000,%eax
    339c:	29 d0                	sub    %edx,%eax
    339e:	89 04 24             	mov    %eax,(%esp)
    33a1:	e8 e0 09 00 00       	call   3d86 <sbrk>
      write(fds[1], "x", 1);
    33a6:	83 c4 0c             	add    $0xc,%esp
    33a9:	6a 01                	push   $0x1
    33ab:	68 49 4a 00 00       	push   $0x4a49
    33b0:	ff 75 e4             	pushl  -0x1c(%ebp)
    33b3:	e8 5e 09 00 00       	call   3d16 <write>
    33b8:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    33bb:	83 ec 0c             	sub    $0xc,%esp
    33be:	68 e8 03 00 00       	push   $0x3e8
    33c3:	e8 c6 09 00 00       	call   3d8e <sleep>
    33c8:	83 c4 10             	add    $0x10,%esp
    33cb:	eb ee                	jmp    33bb <sbrktest+0x39b>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    33cd:	46                   	inc    %esi
    33ce:	83 fe 09             	cmp    $0x9,%esi
    33d1:	77 28                	ja     33fb <sbrktest+0x3db>
    if((pids[i] = fork()) == 0){
    33d3:	e8 16 09 00 00       	call   3cee <fork>
    33d8:	89 44 b5 b8          	mov    %eax,-0x48(%ebp,%esi,4)
    33dc:	85 c0                	test   %eax,%eax
    33de:	74 ab                	je     338b <sbrktest+0x36b>
    }
    if(pids[i] != -1)
    33e0:	83 f8 ff             	cmp    $0xffffffff,%eax
    33e3:	74 e8                	je     33cd <sbrktest+0x3ad>
      read(fds[0], &scratch, 1);
    33e5:	83 ec 04             	sub    $0x4,%esp
    33e8:	6a 01                	push   $0x1
    33ea:	8d 45 b7             	lea    -0x49(%ebp),%eax
    33ed:	50                   	push   %eax
    33ee:	ff 75 e0             	pushl  -0x20(%ebp)
    33f1:	e8 18 09 00 00       	call   3d0e <read>
    33f6:	83 c4 10             	add    $0x10,%esp
    33f9:	eb d2                	jmp    33cd <sbrktest+0x3ad>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    33fb:	83 ec 0c             	sub    $0xc,%esp
    33fe:	68 00 10 00 00       	push   $0x1000
    3403:	e8 7e 09 00 00       	call   3d86 <sbrk>
    3408:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    340a:	83 c4 10             	add    $0x10,%esp
    340d:	eb 01                	jmp    3410 <sbrktest+0x3f0>
    340f:	43                   	inc    %ebx
    3410:	83 fb 09             	cmp    $0x9,%ebx
    3413:	77 23                	ja     3438 <sbrktest+0x418>
    if(pids[i] == -1)
    3415:	8b 44 9d b8          	mov    -0x48(%ebp,%ebx,4),%eax
    3419:	83 f8 ff             	cmp    $0xffffffff,%eax
    341c:	74 f1                	je     340f <sbrktest+0x3ef>
      continue;
    kill(pids[i]);
    341e:	83 ec 0c             	sub    $0xc,%esp
    3421:	50                   	push   %eax
    3422:	e8 ff 08 00 00       	call   3d26 <kill>
    wait(NULL);
    3427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    342e:	e8 cb 08 00 00       	call   3cfe <wait>
    3433:	83 c4 10             	add    $0x10,%esp
    3436:	eb d7                	jmp    340f <sbrktest+0x3ef>
  }
  if(c == (char*)0xffffffff){
    3438:	83 fe ff             	cmp    $0xffffffff,%esi
    343b:	74 2f                	je     346c <sbrktest+0x44c>
    printf(stdout, "failed sbrk leaked memory\n");
    exit(0);
  }

  if(sbrk(0) > oldbrk)
    343d:	83 ec 0c             	sub    $0xc,%esp
    3440:	6a 00                	push   $0x0
    3442:	e8 3f 09 00 00       	call   3d86 <sbrk>
    3447:	83 c4 10             	add    $0x10,%esp
    344a:	39 c7                	cmp    %eax,%edi
    344c:	72 3d                	jb     348b <sbrktest+0x46b>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    344e:	83 ec 08             	sub    $0x8,%esp
    3451:	68 88 4f 00 00       	push   $0x4f88
    3456:	ff 35 40 61 00 00    	pushl  0x6140
    345c:	e8 e4 09 00 00       	call   3e45 <printf>
}
    3461:	83 c4 10             	add    $0x10,%esp
    3464:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3467:	5b                   	pop    %ebx
    3468:	5e                   	pop    %esi
    3469:	5f                   	pop    %edi
    346a:	5d                   	pop    %ebp
    346b:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    346c:	83 ec 08             	sub    $0x8,%esp
    346f:	68 6d 4f 00 00       	push   $0x4f6d
    3474:	ff 35 40 61 00 00    	pushl  0x6140
    347a:	e8 c6 09 00 00       	call   3e45 <printf>
    exit(0);
    347f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3486:	e8 6b 08 00 00       	call   3cf6 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    348b:	83 ec 0c             	sub    $0xc,%esp
    348e:	6a 00                	push   $0x0
    3490:	e8 f1 08 00 00       	call   3d86 <sbrk>
    3495:	29 c7                	sub    %eax,%edi
    3497:	89 3c 24             	mov    %edi,(%esp)
    349a:	e8 e7 08 00 00       	call   3d86 <sbrk>
    349f:	83 c4 10             	add    $0x10,%esp
    34a2:	eb aa                	jmp    344e <sbrktest+0x42e>

000034a4 <validateint>:

void
validateint(int *p)
{
    34a4:	f3 0f 1e fb          	endbr32 
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    34a8:	c3                   	ret    

000034a9 <validatetest>:

void
validatetest(void)
{
    34a9:	f3 0f 1e fb          	endbr32 
    34ad:	55                   	push   %ebp
    34ae:	89 e5                	mov    %esp,%ebp
    34b0:	56                   	push   %esi
    34b1:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    34b2:	83 ec 08             	sub    $0x8,%esp
    34b5:	68 96 4f 00 00       	push   $0x4f96
    34ba:	ff 35 40 61 00 00    	pushl  0x6140
    34c0:	e8 80 09 00 00       	call   3e45 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    34c5:	83 c4 10             	add    $0x10,%esp
    34c8:	be 00 00 00 00       	mov    $0x0,%esi
    34cd:	eb 10                	jmp    34df <validatetest+0x36>
    if((pid = fork()) == 0){
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit(0);
    34cf:	83 ec 0c             	sub    $0xc,%esp
    34d2:	6a 00                	push   $0x0
    34d4:	e8 1d 08 00 00       	call   3cf6 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    34d9:	81 c6 00 10 00 00    	add    $0x1000,%esi
    34df:	81 fe 00 30 11 00    	cmp    $0x113000,%esi
    34e5:	77 6a                	ja     3551 <validatetest+0xa8>
    if((pid = fork()) == 0){
    34e7:	e8 02 08 00 00       	call   3cee <fork>
    34ec:	89 c3                	mov    %eax,%ebx
    34ee:	85 c0                	test   %eax,%eax
    34f0:	74 dd                	je     34cf <validatetest+0x26>
    }
    sleep(0);
    34f2:	83 ec 0c             	sub    $0xc,%esp
    34f5:	6a 00                	push   $0x0
    34f7:	e8 92 08 00 00       	call   3d8e <sleep>
    sleep(0);
    34fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3503:	e8 86 08 00 00       	call   3d8e <sleep>
    kill(pid);
    3508:	89 1c 24             	mov    %ebx,(%esp)
    350b:	e8 16 08 00 00       	call   3d26 <kill>
    wait(NULL);
    3510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3517:	e8 e2 07 00 00       	call   3cfe <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    351c:	83 c4 08             	add    $0x8,%esp
    351f:	56                   	push   %esi
    3520:	68 a5 4f 00 00       	push   $0x4fa5
    3525:	e8 2c 08 00 00       	call   3d56 <link>
    352a:	83 c4 10             	add    $0x10,%esp
    352d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3530:	74 a7                	je     34d9 <validatetest+0x30>
      printf(stdout, "link should not succeed\n");
    3532:	83 ec 08             	sub    $0x8,%esp
    3535:	68 b0 4f 00 00       	push   $0x4fb0
    353a:	ff 35 40 61 00 00    	pushl  0x6140
    3540:	e8 00 09 00 00       	call   3e45 <printf>
      exit(0);
    3545:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    354c:	e8 a5 07 00 00       	call   3cf6 <exit>
    }
  }

  printf(stdout, "validate ok\n");
    3551:	83 ec 08             	sub    $0x8,%esp
    3554:	68 c9 4f 00 00       	push   $0x4fc9
    3559:	ff 35 40 61 00 00    	pushl  0x6140
    355f:	e8 e1 08 00 00       	call   3e45 <printf>
}
    3564:	83 c4 10             	add    $0x10,%esp
    3567:	8d 65 f8             	lea    -0x8(%ebp),%esp
    356a:	5b                   	pop    %ebx
    356b:	5e                   	pop    %esi
    356c:	5d                   	pop    %ebp
    356d:	c3                   	ret    

0000356e <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    356e:	f3 0f 1e fb          	endbr32 
    3572:	55                   	push   %ebp
    3573:	89 e5                	mov    %esp,%ebp
    3575:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    3578:	68 d6 4f 00 00       	push   $0x4fd6
    357d:	ff 35 40 61 00 00    	pushl  0x6140
    3583:	e8 bd 08 00 00       	call   3e45 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3588:	83 c4 10             	add    $0x10,%esp
    358b:	b8 00 00 00 00       	mov    $0x0,%eax
    3590:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3595:	77 2b                	ja     35c2 <bsstest+0x54>
    if(uninit[i] != '\0'){
    3597:	80 b8 00 62 00 00 00 	cmpb   $0x0,0x6200(%eax)
    359e:	75 03                	jne    35a3 <bsstest+0x35>
  for(i = 0; i < sizeof(uninit); i++){
    35a0:	40                   	inc    %eax
    35a1:	eb ed                	jmp    3590 <bsstest+0x22>
      printf(stdout, "bss test failed\n");
    35a3:	83 ec 08             	sub    $0x8,%esp
    35a6:	68 e0 4f 00 00       	push   $0x4fe0
    35ab:	ff 35 40 61 00 00    	pushl  0x6140
    35b1:	e8 8f 08 00 00       	call   3e45 <printf>
      exit(0);
    35b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35bd:	e8 34 07 00 00       	call   3cf6 <exit>
    }
  }
  printf(stdout, "bss test ok\n");
    35c2:	83 ec 08             	sub    $0x8,%esp
    35c5:	68 f1 4f 00 00       	push   $0x4ff1
    35ca:	ff 35 40 61 00 00    	pushl  0x6140
    35d0:	e8 70 08 00 00       	call   3e45 <printf>
}
    35d5:	83 c4 10             	add    $0x10,%esp
    35d8:	c9                   	leave  
    35d9:	c3                   	ret    

000035da <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    35da:	f3 0f 1e fb          	endbr32 
    35de:	55                   	push   %ebp
    35df:	89 e5                	mov    %esp,%ebp
    35e1:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    35e4:	68 fe 4f 00 00       	push   $0x4ffe
    35e9:	e8 58 07 00 00       	call   3d46 <unlink>
  pid = fork();
    35ee:	e8 fb 06 00 00       	call   3cee <fork>
  if(pid == 0){
    35f3:	83 c4 10             	add    $0x10,%esp
    35f6:	85 c0                	test   %eax,%eax
    35f8:	74 50                	je     364a <bigargtest+0x70>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit(0);
  } else if(pid < 0){
    35fa:	0f 88 b7 00 00 00    	js     36b7 <bigargtest+0xdd>
    printf(stdout, "bigargtest: fork failed\n");
    exit(0);
  }
  wait(NULL);
    3600:	83 ec 0c             	sub    $0xc,%esp
    3603:	6a 00                	push   $0x0
    3605:	e8 f4 06 00 00       	call   3cfe <wait>
  fd = open("bigarg-ok", 0);
    360a:	83 c4 08             	add    $0x8,%esp
    360d:	6a 00                	push   $0x0
    360f:	68 fe 4f 00 00       	push   $0x4ffe
    3614:	e8 1d 07 00 00       	call   3d36 <open>
  if(fd < 0){
    3619:	83 c4 10             	add    $0x10,%esp
    361c:	85 c0                	test   %eax,%eax
    361e:	0f 88 b2 00 00 00    	js     36d6 <bigargtest+0xfc>
    printf(stdout, "bigarg test failed!\n");
    exit(0);
  }
  close(fd);
    3624:	83 ec 0c             	sub    $0xc,%esp
    3627:	50                   	push   %eax
    3628:	e8 f1 06 00 00       	call   3d1e <close>
  unlink("bigarg-ok");
    362d:	c7 04 24 fe 4f 00 00 	movl   $0x4ffe,(%esp)
    3634:	e8 0d 07 00 00       	call   3d46 <unlink>
}
    3639:	83 c4 10             	add    $0x10,%esp
    363c:	c9                   	leave  
    363d:	c3                   	ret    
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    363e:	c7 04 85 60 61 00 00 	movl   $0x5758,0x6160(,%eax,4)
    3645:	58 57 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3649:	40                   	inc    %eax
    364a:	83 f8 1e             	cmp    $0x1e,%eax
    364d:	7e ef                	jle    363e <bigargtest+0x64>
    args[MAXARG-1] = 0;
    364f:	c7 05 dc 61 00 00 00 	movl   $0x0,0x61dc
    3656:	00 00 00 
    printf(stdout, "bigarg test\n");
    3659:	83 ec 08             	sub    $0x8,%esp
    365c:	68 08 50 00 00       	push   $0x5008
    3661:	ff 35 40 61 00 00    	pushl  0x6140
    3667:	e8 d9 07 00 00       	call   3e45 <printf>
    exec("echo", args);
    366c:	83 c4 08             	add    $0x8,%esp
    366f:	68 60 61 00 00       	push   $0x6160
    3674:	68 db 41 00 00       	push   $0x41db
    3679:	e8 b0 06 00 00       	call   3d2e <exec>
    printf(stdout, "bigarg test ok\n");
    367e:	83 c4 08             	add    $0x8,%esp
    3681:	68 15 50 00 00       	push   $0x5015
    3686:	ff 35 40 61 00 00    	pushl  0x6140
    368c:	e8 b4 07 00 00       	call   3e45 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3691:	83 c4 08             	add    $0x8,%esp
    3694:	68 00 02 00 00       	push   $0x200
    3699:	68 fe 4f 00 00       	push   $0x4ffe
    369e:	e8 93 06 00 00       	call   3d36 <open>
    close(fd);
    36a3:	89 04 24             	mov    %eax,(%esp)
    36a6:	e8 73 06 00 00       	call   3d1e <close>
    exit(0);
    36ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36b2:	e8 3f 06 00 00       	call   3cf6 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    36b7:	83 ec 08             	sub    $0x8,%esp
    36ba:	68 25 50 00 00       	push   $0x5025
    36bf:	ff 35 40 61 00 00    	pushl  0x6140
    36c5:	e8 7b 07 00 00       	call   3e45 <printf>
    exit(0);
    36ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36d1:	e8 20 06 00 00       	call   3cf6 <exit>
    printf(stdout, "bigarg test failed!\n");
    36d6:	83 ec 08             	sub    $0x8,%esp
    36d9:	68 3e 50 00 00       	push   $0x503e
    36de:	ff 35 40 61 00 00    	pushl  0x6140
    36e4:	e8 5c 07 00 00       	call   3e45 <printf>
    exit(0);
    36e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    36f0:	e8 01 06 00 00       	call   3cf6 <exit>

000036f5 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    36f5:	f3 0f 1e fb          	endbr32 
    36f9:	55                   	push   %ebp
    36fa:	89 e5                	mov    %esp,%ebp
    36fc:	57                   	push   %edi
    36fd:	56                   	push   %esi
    36fe:	53                   	push   %ebx
    36ff:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    3702:	68 53 50 00 00       	push   $0x5053
    3707:	6a 01                	push   $0x1
    3709:	e8 37 07 00 00       	call   3e45 <printf>
    370e:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3711:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    3716:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    371a:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    371f:	f7 eb                	imul   %ebx
    3721:	89 d0                	mov    %edx,%eax
    3723:	c1 f8 06             	sar    $0x6,%eax
    3726:	89 de                	mov    %ebx,%esi
    3728:	c1 fe 1f             	sar    $0x1f,%esi
    372b:	29 f0                	sub    %esi,%eax
    372d:	8d 50 30             	lea    0x30(%eax),%edx
    3730:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3733:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3736:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3739:	8d 04 80             	lea    (%eax,%eax,4),%eax
    373c:	c1 e0 03             	shl    $0x3,%eax
    373f:	89 df                	mov    %ebx,%edi
    3741:	29 c7                	sub    %eax,%edi
    3743:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3748:	89 f8                	mov    %edi,%eax
    374a:	f7 e9                	imul   %ecx
    374c:	c1 fa 05             	sar    $0x5,%edx
    374f:	c1 ff 1f             	sar    $0x1f,%edi
    3752:	29 fa                	sub    %edi,%edx
    3754:	83 c2 30             	add    $0x30,%edx
    3757:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    375a:	89 c8                	mov    %ecx,%eax
    375c:	f7 eb                	imul   %ebx
    375e:	89 d1                	mov    %edx,%ecx
    3760:	c1 f9 05             	sar    $0x5,%ecx
    3763:	29 f1                	sub    %esi,%ecx
    3765:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    3768:	8d 04 80             	lea    (%eax,%eax,4),%eax
    376b:	c1 e0 02             	shl    $0x2,%eax
    376e:	89 d9                	mov    %ebx,%ecx
    3770:	29 c1                	sub    %eax,%ecx
    3772:	bf 67 66 66 66       	mov    $0x66666667,%edi
    3777:	89 c8                	mov    %ecx,%eax
    3779:	f7 ef                	imul   %edi
    377b:	89 d0                	mov    %edx,%eax
    377d:	c1 f8 02             	sar    $0x2,%eax
    3780:	c1 f9 1f             	sar    $0x1f,%ecx
    3783:	29 c8                	sub    %ecx,%eax
    3785:	83 c0 30             	add    $0x30,%eax
    3788:	88 45 ab             	mov    %al,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    378b:	89 f8                	mov    %edi,%eax
    378d:	f7 eb                	imul   %ebx
    378f:	89 d0                	mov    %edx,%eax
    3791:	c1 f8 02             	sar    $0x2,%eax
    3794:	29 f0                	sub    %esi,%eax
    3796:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3799:	01 c0                	add    %eax,%eax
    379b:	89 de                	mov    %ebx,%esi
    379d:	29 c6                	sub    %eax,%esi
    379f:	89 f0                	mov    %esi,%eax
    37a1:	83 c0 30             	add    $0x30,%eax
    37a4:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    37a7:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    37ab:	83 ec 04             	sub    $0x4,%esp
    37ae:	8d 75 a8             	lea    -0x58(%ebp),%esi
    37b1:	56                   	push   %esi
    37b2:	68 60 50 00 00       	push   $0x5060
    37b7:	6a 01                	push   $0x1
    37b9:	e8 87 06 00 00       	call   3e45 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    37be:	83 c4 08             	add    $0x8,%esp
    37c1:	68 02 02 00 00       	push   $0x202
    37c6:	56                   	push   %esi
    37c7:	e8 6a 05 00 00       	call   3d36 <open>
    37cc:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    37ce:	83 c4 10             	add    $0x10,%esp
    37d1:	85 c0                	test   %eax,%eax
    37d3:	79 1b                	jns    37f0 <fsfull+0xfb>
      printf(1, "open %s failed\n", name);
    37d5:	83 ec 04             	sub    $0x4,%esp
    37d8:	8d 45 a8             	lea    -0x58(%ebp),%eax
    37db:	50                   	push   %eax
    37dc:	68 6c 50 00 00       	push   $0x506c
    37e1:	6a 01                	push   $0x1
    37e3:	e8 5d 06 00 00       	call   3e45 <printf>
      break;
    37e8:	83 c4 10             	add    $0x10,%esp
    37eb:	e9 f4 00 00 00       	jmp    38e4 <fsfull+0x1ef>
    }
    int total = 0;
    37f0:	bf 00 00 00 00       	mov    $0x0,%edi
    while(1){
      int cc = write(fd, buf, 512);
    37f5:	83 ec 04             	sub    $0x4,%esp
    37f8:	68 00 02 00 00       	push   $0x200
    37fd:	68 20 89 00 00       	push   $0x8920
    3802:	56                   	push   %esi
    3803:	e8 0e 05 00 00       	call   3d16 <write>
      if(cc < 512)
    3808:	83 c4 10             	add    $0x10,%esp
    380b:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3810:	7e 04                	jle    3816 <fsfull+0x121>
        break;
      total += cc;
    3812:	01 c7                	add    %eax,%edi
    while(1){
    3814:	eb df                	jmp    37f5 <fsfull+0x100>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3816:	83 ec 04             	sub    $0x4,%esp
    3819:	57                   	push   %edi
    381a:	68 7c 50 00 00       	push   $0x507c
    381f:	6a 01                	push   $0x1
    3821:	e8 1f 06 00 00       	call   3e45 <printf>
    close(fd);
    3826:	89 34 24             	mov    %esi,(%esp)
    3829:	e8 f0 04 00 00       	call   3d1e <close>
    if(total == 0)
    382e:	83 c4 10             	add    $0x10,%esp
    3831:	85 ff                	test   %edi,%edi
    3833:	0f 84 ab 00 00 00    	je     38e4 <fsfull+0x1ef>
  for(nfiles = 0; ; nfiles++){
    3839:	43                   	inc    %ebx
    383a:	e9 d7 fe ff ff       	jmp    3716 <fsfull+0x21>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    383f:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3843:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3848:	f7 eb                	imul   %ebx
    384a:	89 d0                	mov    %edx,%eax
    384c:	c1 f8 06             	sar    $0x6,%eax
    384f:	89 de                	mov    %ebx,%esi
    3851:	c1 fe 1f             	sar    $0x1f,%esi
    3854:	29 f0                	sub    %esi,%eax
    3856:	8d 50 30             	lea    0x30(%eax),%edx
    3859:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    385c:	8d 04 80             	lea    (%eax,%eax,4),%eax
    385f:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3862:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3865:	c1 e0 03             	shl    $0x3,%eax
    3868:	89 df                	mov    %ebx,%edi
    386a:	29 c7                	sub    %eax,%edi
    386c:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3871:	89 f8                	mov    %edi,%eax
    3873:	f7 e9                	imul   %ecx
    3875:	c1 fa 05             	sar    $0x5,%edx
    3878:	c1 ff 1f             	sar    $0x1f,%edi
    387b:	29 fa                	sub    %edi,%edx
    387d:	83 c2 30             	add    $0x30,%edx
    3880:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3883:	89 c8                	mov    %ecx,%eax
    3885:	f7 eb                	imul   %ebx
    3887:	89 d1                	mov    %edx,%ecx
    3889:	c1 f9 05             	sar    $0x5,%ecx
    388c:	29 f1                	sub    %esi,%ecx
    388e:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
    3891:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3894:	c1 e0 02             	shl    $0x2,%eax
    3897:	89 d9                	mov    %ebx,%ecx
    3899:	29 c1                	sub    %eax,%ecx
    389b:	bf 67 66 66 66       	mov    $0x66666667,%edi
    38a0:	89 c8                	mov    %ecx,%eax
    38a2:	f7 ef                	imul   %edi
    38a4:	89 d0                	mov    %edx,%eax
    38a6:	c1 f8 02             	sar    $0x2,%eax
    38a9:	c1 f9 1f             	sar    $0x1f,%ecx
    38ac:	29 c8                	sub    %ecx,%eax
    38ae:	83 c0 30             	add    $0x30,%eax
    38b1:	88 45 ab             	mov    %al,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    38b4:	89 f8                	mov    %edi,%eax
    38b6:	f7 eb                	imul   %ebx
    38b8:	89 d0                	mov    %edx,%eax
    38ba:	c1 f8 02             	sar    $0x2,%eax
    38bd:	29 f0                	sub    %esi,%eax
    38bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
    38c2:	01 c0                	add    %eax,%eax
    38c4:	89 de                	mov    %ebx,%esi
    38c6:	29 c6                	sub    %eax,%esi
    38c8:	89 f0                	mov    %esi,%eax
    38ca:	83 c0 30             	add    $0x30,%eax
    38cd:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    38d0:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    38d4:	83 ec 0c             	sub    $0xc,%esp
    38d7:	8d 45 a8             	lea    -0x58(%ebp),%eax
    38da:	50                   	push   %eax
    38db:	e8 66 04 00 00       	call   3d46 <unlink>
    nfiles--;
    38e0:	4b                   	dec    %ebx
    38e1:	83 c4 10             	add    $0x10,%esp
  while(nfiles >= 0){
    38e4:	85 db                	test   %ebx,%ebx
    38e6:	0f 89 53 ff ff ff    	jns    383f <fsfull+0x14a>
  }

  printf(1, "fsfull test finished\n");
    38ec:	83 ec 08             	sub    $0x8,%esp
    38ef:	68 8c 50 00 00       	push   $0x508c
    38f4:	6a 01                	push   $0x1
    38f6:	e8 4a 05 00 00       	call   3e45 <printf>
}
    38fb:	83 c4 10             	add    $0x10,%esp
    38fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3901:	5b                   	pop    %ebx
    3902:	5e                   	pop    %esi
    3903:	5f                   	pop    %edi
    3904:	5d                   	pop    %ebp
    3905:	c3                   	ret    

00003906 <uio>:

void
uio()
{
    3906:	f3 0f 1e fb          	endbr32 
    390a:	55                   	push   %ebp
    390b:	89 e5                	mov    %esp,%ebp
    390d:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    3910:	68 a2 50 00 00       	push   $0x50a2
    3915:	6a 01                	push   $0x1
    3917:	e8 29 05 00 00       	call   3e45 <printf>
  pid = fork();
    391c:	e8 cd 03 00 00       	call   3cee <fork>
  if(pid == 0){
    3921:	83 c4 10             	add    $0x10,%esp
    3924:	85 c0                	test   %eax,%eax
    3926:	74 20                	je     3948 <uio+0x42>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit(0);
  } else if(pid < 0){
    3928:	78 47                	js     3971 <uio+0x6b>
    printf (1, "fork failed\n");
    exit(0);
  }
  wait(NULL);
    392a:	83 ec 0c             	sub    $0xc,%esp
    392d:	6a 00                	push   $0x0
    392f:	e8 ca 03 00 00       	call   3cfe <wait>
  printf(1, "uio test done\n");
    3934:	83 c4 08             	add    $0x8,%esp
    3937:	68 ac 50 00 00       	push   $0x50ac
    393c:	6a 01                	push   $0x1
    393e:	e8 02 05 00 00       	call   3e45 <printf>
}
    3943:	83 c4 10             	add    $0x10,%esp
    3946:	c9                   	leave  
    3947:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3948:	b0 09                	mov    $0x9,%al
    394a:	ba 70 00 00 00       	mov    $0x70,%edx
    394f:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3950:	ba 71 00 00 00       	mov    $0x71,%edx
    3955:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3956:	83 ec 08             	sub    $0x8,%esp
    3959:	68 38 58 00 00       	push   $0x5838
    395e:	6a 01                	push   $0x1
    3960:	e8 e0 04 00 00       	call   3e45 <printf>
    exit(0);
    3965:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    396c:	e8 85 03 00 00       	call   3cf6 <exit>
    printf (1, "fork failed\n");
    3971:	83 ec 08             	sub    $0x8,%esp
    3974:	68 31 50 00 00       	push   $0x5031
    3979:	6a 01                	push   $0x1
    397b:	e8 c5 04 00 00       	call   3e45 <printf>
    exit(0);
    3980:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3987:	e8 6a 03 00 00       	call   3cf6 <exit>

0000398c <argptest>:

void argptest()
{
    398c:	f3 0f 1e fb          	endbr32 
    3990:	55                   	push   %ebp
    3991:	89 e5                	mov    %esp,%ebp
    3993:	53                   	push   %ebx
    3994:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3997:	6a 00                	push   $0x0
    3999:	68 bb 50 00 00       	push   $0x50bb
    399e:	e8 93 03 00 00       	call   3d36 <open>
  if (fd < 0) {
    39a3:	83 c4 10             	add    $0x10,%esp
    39a6:	85 c0                	test   %eax,%eax
    39a8:	78 38                	js     39e2 <argptest+0x56>
    39aa:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit(0);
  }
  read(fd, sbrk(0) - 1, -1);
    39ac:	83 ec 0c             	sub    $0xc,%esp
    39af:	6a 00                	push   $0x0
    39b1:	e8 d0 03 00 00       	call   3d86 <sbrk>
    39b6:	48                   	dec    %eax
    39b7:	83 c4 0c             	add    $0xc,%esp
    39ba:	6a ff                	push   $0xffffffff
    39bc:	50                   	push   %eax
    39bd:	53                   	push   %ebx
    39be:	e8 4b 03 00 00       	call   3d0e <read>
  close(fd);
    39c3:	89 1c 24             	mov    %ebx,(%esp)
    39c6:	e8 53 03 00 00       	call   3d1e <close>
  printf(1, "arg test passed\n");
    39cb:	83 c4 08             	add    $0x8,%esp
    39ce:	68 cd 50 00 00       	push   $0x50cd
    39d3:	6a 01                	push   $0x1
    39d5:	e8 6b 04 00 00       	call   3e45 <printf>
}
    39da:	83 c4 10             	add    $0x10,%esp
    39dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    39e0:	c9                   	leave  
    39e1:	c3                   	ret    
    printf(2, "open failed\n");
    39e2:	83 ec 08             	sub    $0x8,%esp
    39e5:	68 c0 50 00 00       	push   $0x50c0
    39ea:	6a 02                	push   $0x2
    39ec:	e8 54 04 00 00       	call   3e45 <printf>
    exit(0);
    39f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    39f8:	e8 f9 02 00 00       	call   3cf6 <exit>

000039fd <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    39fd:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    3a01:	a1 3c 61 00 00       	mov    0x613c,%eax
    3a06:	8d 14 00             	lea    (%eax,%eax,1),%edx
    3a09:	01 c2                	add    %eax,%edx
    3a0b:	8d 0c 90             	lea    (%eax,%edx,4),%ecx
    3a0e:	c1 e1 08             	shl    $0x8,%ecx
    3a11:	89 ca                	mov    %ecx,%edx
    3a13:	01 c2                	add    %eax,%edx
    3a15:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3a18:	8d 04 90             	lea    (%eax,%edx,4),%eax
    3a1b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3a1e:	8d 84 80 5f f3 6e 3c 	lea    0x3c6ef35f(%eax,%eax,4),%eax
    3a25:	a3 3c 61 00 00       	mov    %eax,0x613c
  return randstate;
}
    3a2a:	c3                   	ret    

00003a2b <main>:

int
main(int argc, char *argv[])
{
    3a2b:	f3 0f 1e fb          	endbr32 
    3a2f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3a33:	83 e4 f0             	and    $0xfffffff0,%esp
    3a36:	ff 71 fc             	pushl  -0x4(%ecx)
    3a39:	55                   	push   %ebp
    3a3a:	89 e5                	mov    %esp,%ebp
    3a3c:	51                   	push   %ecx
    3a3d:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    3a40:	68 de 50 00 00       	push   $0x50de
    3a45:	6a 01                	push   $0x1
    3a47:	e8 f9 03 00 00       	call   3e45 <printf>

  if(open("usertests.ran", 0) >= 0){
    3a4c:	83 c4 08             	add    $0x8,%esp
    3a4f:	6a 00                	push   $0x0
    3a51:	68 f2 50 00 00       	push   $0x50f2
    3a56:	e8 db 02 00 00       	call   3d36 <open>
    3a5b:	83 c4 10             	add    $0x10,%esp
    3a5e:	85 c0                	test   %eax,%eax
    3a60:	78 1b                	js     3a7d <main+0x52>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3a62:	83 ec 08             	sub    $0x8,%esp
    3a65:	68 5c 58 00 00       	push   $0x585c
    3a6a:	6a 01                	push   $0x1
    3a6c:	e8 d4 03 00 00       	call   3e45 <printf>
    exit(0);
    3a71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3a78:	e8 79 02 00 00       	call   3cf6 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3a7d:	83 ec 08             	sub    $0x8,%esp
    3a80:	68 00 02 00 00       	push   $0x200
    3a85:	68 f2 50 00 00       	push   $0x50f2
    3a8a:	e8 a7 02 00 00       	call   3d36 <open>
    3a8f:	89 04 24             	mov    %eax,(%esp)
    3a92:	e8 87 02 00 00       	call   3d1e <close>

  argptest();
    3a97:	e8 f0 fe ff ff       	call   398c <argptest>
  createdelete();
    3a9c:	e8 0d d7 ff ff       	call   11ae <createdelete>
  linkunlink();
    3aa1:	e8 46 e0 ff ff       	call   1aec <linkunlink>
  concreate();
    3aa6:	e8 4a dd ff ff       	call   17f5 <concreate>
  fourfiles();
    3aab:	e8 00 d5 ff ff       	call   fb0 <fourfiles>
  sharedfd();
    3ab0:	e8 5b d3 ff ff       	call   e10 <sharedfd>

  bigargtest();
    3ab5:	e8 20 fb ff ff       	call   35da <bigargtest>
  bigwrite();
    3aba:	e8 ee ea ff ff       	call   25ad <bigwrite>
  bigargtest();
    3abf:	e8 16 fb ff ff       	call   35da <bigargtest>
  bsstest();
    3ac4:	e8 a5 fa ff ff       	call   356e <bsstest>
  sbrktest();
    3ac9:	e8 52 f5 ff ff       	call   3020 <sbrktest>
  validatetest();
    3ace:	e8 d6 f9 ff ff       	call   34a9 <validatetest>

  opentest();
    3ad3:	e8 48 c8 ff ff       	call   320 <opentest>
  writetest();
    3ad8:	e8 e8 c8 ff ff       	call   3c5 <writetest>
  writetest1();
    3add:	e8 db ca ff ff       	call   5bd <writetest1>
  createtest();
    3ae2:	e8 b7 cc ff ff       	call   79e <createtest>

  openiputtest();
    3ae7:	e8 21 c7 ff ff       	call   20d <openiputtest>
  exitiputtest();
    3aec:	e8 0c c6 ff ff       	call   fd <exitiputtest>
  iputtest();
    3af1:	e8 0a c5 ff ff       	call   0 <iputtest>

  mem();
    3af6:	e8 42 d2 ff ff       	call   d3d <mem>
  pipe1();
    3afb:	e8 9b ce ff ff       	call   99b <pipe1>
  preempt();
    3b00:	e8 62 d0 ff ff       	call   b67 <preempt>
  exitwait();
    3b05:	e8 b4 d1 ff ff       	call   cbe <exitwait>

  rmdot();
    3b0a:	e8 de ee ff ff       	call   29ed <rmdot>
  fourteen();
    3b0f:	e8 66 ed ff ff       	call   287a <fourteen>
  bigfile();
    3b14:	e8 76 eb ff ff       	call   268f <bigfile>
  subdir();
    3b19:	e8 5a e2 ff ff       	call   1d78 <subdir>
  linktest();
    3b1e:	e8 69 da ff ff       	call   158c <linktest>
  unlinkread();
    3b23:	e8 9d d8 ff ff       	call   13c5 <unlinkread>
  dirfile();
    3b28:	e8 81 f0 ff ff       	call   2bae <dirfile>
  iref();
    3b2d:	e8 e0 f2 ff ff       	call   2e12 <iref>
  forktest();
    3b32:	e8 10 f4 ff ff       	call   2f47 <forktest>
  bigdir(); // slow
    3b37:	e8 cd e0 ff ff       	call   1c09 <bigdir>

  uio();
    3b3c:	e8 c5 fd ff ff       	call   3906 <uio>

  exectest();
    3b41:	e8 01 ce ff ff       	call   947 <exectest>

  exit(0);
    3b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b4d:	e8 a4 01 00 00       	call   3cf6 <exit>

00003b52 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
    3b52:	f3 0f 1e fb          	endbr32 
}
    3b56:	c3                   	ret    

00003b57 <strcpy>:

char*
strcpy(char *s, const char *t)
{
    3b57:	f3 0f 1e fb          	endbr32 
    3b5b:	55                   	push   %ebp
    3b5c:	89 e5                	mov    %esp,%ebp
    3b5e:	56                   	push   %esi
    3b5f:	53                   	push   %ebx
    3b60:	8b 45 08             	mov    0x8(%ebp),%eax
    3b63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3b66:	89 c2                	mov    %eax,%edx
    3b68:	89 cb                	mov    %ecx,%ebx
    3b6a:	41                   	inc    %ecx
    3b6b:	89 d6                	mov    %edx,%esi
    3b6d:	42                   	inc    %edx
    3b6e:	8a 1b                	mov    (%ebx),%bl
    3b70:	88 1e                	mov    %bl,(%esi)
    3b72:	84 db                	test   %bl,%bl
    3b74:	75 f2                	jne    3b68 <strcpy+0x11>
    ;
  return os;
}
    3b76:	5b                   	pop    %ebx
    3b77:	5e                   	pop    %esi
    3b78:	5d                   	pop    %ebp
    3b79:	c3                   	ret    

00003b7a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3b7a:	f3 0f 1e fb          	endbr32 
    3b7e:	55                   	push   %ebp
    3b7f:	89 e5                	mov    %esp,%ebp
    3b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    3b87:	8a 01                	mov    (%ecx),%al
    3b89:	84 c0                	test   %al,%al
    3b8b:	74 08                	je     3b95 <strcmp+0x1b>
    3b8d:	3a 02                	cmp    (%edx),%al
    3b8f:	75 04                	jne    3b95 <strcmp+0x1b>
    p++, q++;
    3b91:	41                   	inc    %ecx
    3b92:	42                   	inc    %edx
    3b93:	eb f2                	jmp    3b87 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
    3b95:	0f b6 c0             	movzbl %al,%eax
    3b98:	0f b6 12             	movzbl (%edx),%edx
    3b9b:	29 d0                	sub    %edx,%eax
}
    3b9d:	5d                   	pop    %ebp
    3b9e:	c3                   	ret    

00003b9f <strlen>:

uint
strlen(const char *s)
{
    3b9f:	f3 0f 1e fb          	endbr32 
    3ba3:	55                   	push   %ebp
    3ba4:	89 e5                	mov    %esp,%ebp
    3ba6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3ba9:	b8 00 00 00 00       	mov    $0x0,%eax
    3bae:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
    3bb2:	74 03                	je     3bb7 <strlen+0x18>
    3bb4:	40                   	inc    %eax
    3bb5:	eb f7                	jmp    3bae <strlen+0xf>
    ;
  return n;
}
    3bb7:	5d                   	pop    %ebp
    3bb8:	c3                   	ret    

00003bb9 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3bb9:	f3 0f 1e fb          	endbr32 
    3bbd:	55                   	push   %ebp
    3bbe:	89 e5                	mov    %esp,%ebp
    3bc0:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3bc1:	8b 7d 08             	mov    0x8(%ebp),%edi
    3bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
    3bca:	fc                   	cld    
    3bcb:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3bcd:	8b 45 08             	mov    0x8(%ebp),%eax
    3bd0:	5f                   	pop    %edi
    3bd1:	5d                   	pop    %ebp
    3bd2:	c3                   	ret    

00003bd3 <strchr>:

char*
strchr(const char *s, char c)
{
    3bd3:	f3 0f 1e fb          	endbr32 
    3bd7:	55                   	push   %ebp
    3bd8:	89 e5                	mov    %esp,%ebp
    3bda:	8b 45 08             	mov    0x8(%ebp),%eax
    3bdd:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
    3be0:	8a 10                	mov    (%eax),%dl
    3be2:	84 d2                	test   %dl,%dl
    3be4:	74 07                	je     3bed <strchr+0x1a>
    if(*s == c)
    3be6:	38 ca                	cmp    %cl,%dl
    3be8:	74 08                	je     3bf2 <strchr+0x1f>
  for(; *s; s++)
    3bea:	40                   	inc    %eax
    3beb:	eb f3                	jmp    3be0 <strchr+0xd>
      return (char*)s;
  return 0;
    3bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3bf2:	5d                   	pop    %ebp
    3bf3:	c3                   	ret    

00003bf4 <gets>:

char*
gets(char *buf, int max)
{
    3bf4:	f3 0f 1e fb          	endbr32 
    3bf8:	55                   	push   %ebp
    3bf9:	89 e5                	mov    %esp,%ebp
    3bfb:	57                   	push   %edi
    3bfc:	56                   	push   %esi
    3bfd:	53                   	push   %ebx
    3bfe:	83 ec 1c             	sub    $0x1c,%esp
    3c01:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3c04:	bb 00 00 00 00       	mov    $0x0,%ebx
    3c09:	89 de                	mov    %ebx,%esi
    3c0b:	43                   	inc    %ebx
    3c0c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3c0f:	7d 2b                	jge    3c3c <gets+0x48>
    cc = read(0, &c, 1);
    3c11:	83 ec 04             	sub    $0x4,%esp
    3c14:	6a 01                	push   $0x1
    3c16:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3c19:	50                   	push   %eax
    3c1a:	6a 00                	push   $0x0
    3c1c:	e8 ed 00 00 00       	call   3d0e <read>
    if(cc < 1)
    3c21:	83 c4 10             	add    $0x10,%esp
    3c24:	85 c0                	test   %eax,%eax
    3c26:	7e 14                	jle    3c3c <gets+0x48>
      break;
    buf[i++] = c;
    3c28:	8a 45 e7             	mov    -0x19(%ebp),%al
    3c2b:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    3c2e:	3c 0a                	cmp    $0xa,%al
    3c30:	74 08                	je     3c3a <gets+0x46>
    3c32:	3c 0d                	cmp    $0xd,%al
    3c34:	75 d3                	jne    3c09 <gets+0x15>
    buf[i++] = c;
    3c36:	89 de                	mov    %ebx,%esi
    3c38:	eb 02                	jmp    3c3c <gets+0x48>
    3c3a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    3c3c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    3c40:	89 f8                	mov    %edi,%eax
    3c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3c45:	5b                   	pop    %ebx
    3c46:	5e                   	pop    %esi
    3c47:	5f                   	pop    %edi
    3c48:	5d                   	pop    %ebp
    3c49:	c3                   	ret    

00003c4a <stat>:

int
stat(const char *n, struct stat *st)
{
    3c4a:	f3 0f 1e fb          	endbr32 
    3c4e:	55                   	push   %ebp
    3c4f:	89 e5                	mov    %esp,%ebp
    3c51:	56                   	push   %esi
    3c52:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3c53:	83 ec 08             	sub    $0x8,%esp
    3c56:	6a 00                	push   $0x0
    3c58:	ff 75 08             	pushl  0x8(%ebp)
    3c5b:	e8 d6 00 00 00       	call   3d36 <open>
  if(fd < 0)
    3c60:	83 c4 10             	add    $0x10,%esp
    3c63:	85 c0                	test   %eax,%eax
    3c65:	78 24                	js     3c8b <stat+0x41>
    3c67:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    3c69:	83 ec 08             	sub    $0x8,%esp
    3c6c:	ff 75 0c             	pushl  0xc(%ebp)
    3c6f:	50                   	push   %eax
    3c70:	e8 d9 00 00 00       	call   3d4e <fstat>
    3c75:	89 c6                	mov    %eax,%esi
  close(fd);
    3c77:	89 1c 24             	mov    %ebx,(%esp)
    3c7a:	e8 9f 00 00 00       	call   3d1e <close>
  return r;
    3c7f:	83 c4 10             	add    $0x10,%esp
}
    3c82:	89 f0                	mov    %esi,%eax
    3c84:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3c87:	5b                   	pop    %ebx
    3c88:	5e                   	pop    %esi
    3c89:	5d                   	pop    %ebp
    3c8a:	c3                   	ret    
    return -1;
    3c8b:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3c90:	eb f0                	jmp    3c82 <stat+0x38>

00003c92 <atoi>:

int
atoi(const char *s)
{
    3c92:	f3 0f 1e fb          	endbr32 
    3c96:	55                   	push   %ebp
    3c97:	89 e5                	mov    %esp,%ebp
    3c99:	53                   	push   %ebx
    3c9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    3c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    3ca2:	8a 01                	mov    (%ecx),%al
    3ca4:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3ca7:	80 fb 09             	cmp    $0x9,%bl
    3caa:	77 10                	ja     3cbc <atoi+0x2a>
    n = n*10 + *s++ - '0';
    3cac:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3caf:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
    3cb2:	41                   	inc    %ecx
    3cb3:	0f be c0             	movsbl %al,%eax
    3cb6:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
    3cba:	eb e6                	jmp    3ca2 <atoi+0x10>
  return n;
}
    3cbc:	89 d0                	mov    %edx,%eax
    3cbe:	5b                   	pop    %ebx
    3cbf:	5d                   	pop    %ebp
    3cc0:	c3                   	ret    

00003cc1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3cc1:	f3 0f 1e fb          	endbr32 
    3cc5:	55                   	push   %ebp
    3cc6:	89 e5                	mov    %esp,%ebp
    3cc8:	56                   	push   %esi
    3cc9:	53                   	push   %ebx
    3cca:	8b 45 08             	mov    0x8(%ebp),%eax
    3ccd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    3cd0:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
    3cd3:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
    3cd5:	8d 72 ff             	lea    -0x1(%edx),%esi
    3cd8:	85 d2                	test   %edx,%edx
    3cda:	7e 0e                	jle    3cea <memmove+0x29>
    *dst++ = *src++;
    3cdc:	8a 13                	mov    (%ebx),%dl
    3cde:	88 11                	mov    %dl,(%ecx)
    3ce0:	8d 5b 01             	lea    0x1(%ebx),%ebx
    3ce3:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
    3ce6:	89 f2                	mov    %esi,%edx
    3ce8:	eb eb                	jmp    3cd5 <memmove+0x14>
  return vdst;
}
    3cea:	5b                   	pop    %ebx
    3ceb:	5e                   	pop    %esi
    3cec:	5d                   	pop    %ebp
    3ced:	c3                   	ret    

00003cee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3cee:	b8 01 00 00 00       	mov    $0x1,%eax
    3cf3:	cd 40                	int    $0x40
    3cf5:	c3                   	ret    

00003cf6 <exit>:
SYSCALL(exit)
    3cf6:	b8 02 00 00 00       	mov    $0x2,%eax
    3cfb:	cd 40                	int    $0x40
    3cfd:	c3                   	ret    

00003cfe <wait>:
SYSCALL(wait)
    3cfe:	b8 03 00 00 00       	mov    $0x3,%eax
    3d03:	cd 40                	int    $0x40
    3d05:	c3                   	ret    

00003d06 <pipe>:
SYSCALL(pipe)
    3d06:	b8 04 00 00 00       	mov    $0x4,%eax
    3d0b:	cd 40                	int    $0x40
    3d0d:	c3                   	ret    

00003d0e <read>:
SYSCALL(read)
    3d0e:	b8 05 00 00 00       	mov    $0x5,%eax
    3d13:	cd 40                	int    $0x40
    3d15:	c3                   	ret    

00003d16 <write>:
SYSCALL(write)
    3d16:	b8 10 00 00 00       	mov    $0x10,%eax
    3d1b:	cd 40                	int    $0x40
    3d1d:	c3                   	ret    

00003d1e <close>:
SYSCALL(close)
    3d1e:	b8 15 00 00 00       	mov    $0x15,%eax
    3d23:	cd 40                	int    $0x40
    3d25:	c3                   	ret    

00003d26 <kill>:
SYSCALL(kill)
    3d26:	b8 06 00 00 00       	mov    $0x6,%eax
    3d2b:	cd 40                	int    $0x40
    3d2d:	c3                   	ret    

00003d2e <exec>:
SYSCALL(exec)
    3d2e:	b8 07 00 00 00       	mov    $0x7,%eax
    3d33:	cd 40                	int    $0x40
    3d35:	c3                   	ret    

00003d36 <open>:
SYSCALL(open)
    3d36:	b8 0f 00 00 00       	mov    $0xf,%eax
    3d3b:	cd 40                	int    $0x40
    3d3d:	c3                   	ret    

00003d3e <mknod>:
SYSCALL(mknod)
    3d3e:	b8 11 00 00 00       	mov    $0x11,%eax
    3d43:	cd 40                	int    $0x40
    3d45:	c3                   	ret    

00003d46 <unlink>:
SYSCALL(unlink)
    3d46:	b8 12 00 00 00       	mov    $0x12,%eax
    3d4b:	cd 40                	int    $0x40
    3d4d:	c3                   	ret    

00003d4e <fstat>:
SYSCALL(fstat)
    3d4e:	b8 08 00 00 00       	mov    $0x8,%eax
    3d53:	cd 40                	int    $0x40
    3d55:	c3                   	ret    

00003d56 <link>:
SYSCALL(link)
    3d56:	b8 13 00 00 00       	mov    $0x13,%eax
    3d5b:	cd 40                	int    $0x40
    3d5d:	c3                   	ret    

00003d5e <mkdir>:
SYSCALL(mkdir)
    3d5e:	b8 14 00 00 00       	mov    $0x14,%eax
    3d63:	cd 40                	int    $0x40
    3d65:	c3                   	ret    

00003d66 <chdir>:
SYSCALL(chdir)
    3d66:	b8 09 00 00 00       	mov    $0x9,%eax
    3d6b:	cd 40                	int    $0x40
    3d6d:	c3                   	ret    

00003d6e <dup>:
SYSCALL(dup)
    3d6e:	b8 0a 00 00 00       	mov    $0xa,%eax
    3d73:	cd 40                	int    $0x40
    3d75:	c3                   	ret    

00003d76 <dup2>:
SYSCALL(dup2)
    3d76:	b8 17 00 00 00       	mov    $0x17,%eax
    3d7b:	cd 40                	int    $0x40
    3d7d:	c3                   	ret    

00003d7e <getpid>:
SYSCALL(getpid)
    3d7e:	b8 0b 00 00 00       	mov    $0xb,%eax
    3d83:	cd 40                	int    $0x40
    3d85:	c3                   	ret    

00003d86 <sbrk>:
SYSCALL(sbrk)
    3d86:	b8 0c 00 00 00       	mov    $0xc,%eax
    3d8b:	cd 40                	int    $0x40
    3d8d:	c3                   	ret    

00003d8e <sleep>:
SYSCALL(sleep)
    3d8e:	b8 0d 00 00 00       	mov    $0xd,%eax
    3d93:	cd 40                	int    $0x40
    3d95:	c3                   	ret    

00003d96 <uptime>:
SYSCALL(uptime)
    3d96:	b8 0e 00 00 00       	mov    $0xe,%eax
    3d9b:	cd 40                	int    $0x40
    3d9d:	c3                   	ret    

00003d9e <date>:
SYSCALL(date)
    3d9e:	b8 16 00 00 00       	mov    $0x16,%eax
    3da3:	cd 40                	int    $0x40
    3da5:	c3                   	ret    

00003da6 <getprio>:
SYSCALL(getprio)
    3da6:	b8 18 00 00 00       	mov    $0x18,%eax
    3dab:	cd 40                	int    $0x40
    3dad:	c3                   	ret    

00003dae <setprio>:
SYSCALL(setprio)
    3dae:	b8 19 00 00 00       	mov    $0x19,%eax
    3db3:	cd 40                	int    $0x40
    3db5:	c3                   	ret    

00003db6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3db6:	55                   	push   %ebp
    3db7:	89 e5                	mov    %esp,%ebp
    3db9:	83 ec 1c             	sub    $0x1c,%esp
    3dbc:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    3dbf:	6a 01                	push   $0x1
    3dc1:	8d 55 f4             	lea    -0xc(%ebp),%edx
    3dc4:	52                   	push   %edx
    3dc5:	50                   	push   %eax
    3dc6:	e8 4b ff ff ff       	call   3d16 <write>
}
    3dcb:	83 c4 10             	add    $0x10,%esp
    3dce:	c9                   	leave  
    3dcf:	c3                   	ret    

00003dd0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3dd0:	55                   	push   %ebp
    3dd1:	89 e5                	mov    %esp,%ebp
    3dd3:	57                   	push   %edi
    3dd4:	56                   	push   %esi
    3dd5:	53                   	push   %ebx
    3dd6:	83 ec 2c             	sub    $0x2c,%esp
    3dd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3ddc:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    3de2:	74 04                	je     3de8 <printint+0x18>
    3de4:	85 d2                	test   %edx,%edx
    3de6:	78 3a                	js     3e22 <printint+0x52>
  neg = 0;
    3de8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    3def:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    3df4:	89 f0                	mov    %esi,%eax
    3df6:	ba 00 00 00 00       	mov    $0x0,%edx
    3dfb:	f7 f1                	div    %ecx
    3dfd:	89 df                	mov    %ebx,%edi
    3dff:	43                   	inc    %ebx
    3e00:	8a 92 a0 58 00 00    	mov    0x58a0(%edx),%dl
    3e06:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
    3e0a:	89 f2                	mov    %esi,%edx
    3e0c:	89 c6                	mov    %eax,%esi
    3e0e:	39 d1                	cmp    %edx,%ecx
    3e10:	76 e2                	jbe    3df4 <printint+0x24>
  if(neg)
    3e12:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    3e16:	74 22                	je     3e3a <printint+0x6a>
    buf[i++] = '-';
    3e18:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    3e1d:	8d 5f 02             	lea    0x2(%edi),%ebx
    3e20:	eb 18                	jmp    3e3a <printint+0x6a>
    x = -xx;
    3e22:	f7 de                	neg    %esi
    neg = 1;
    3e24:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
    3e2b:	eb c2                	jmp    3def <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
    3e2d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    3e32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3e35:	e8 7c ff ff ff       	call   3db6 <putc>
  while(--i >= 0)
    3e3a:	4b                   	dec    %ebx
    3e3b:	79 f0                	jns    3e2d <printint+0x5d>
}
    3e3d:	83 c4 2c             	add    $0x2c,%esp
    3e40:	5b                   	pop    %ebx
    3e41:	5e                   	pop    %esi
    3e42:	5f                   	pop    %edi
    3e43:	5d                   	pop    %ebp
    3e44:	c3                   	ret    

00003e45 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3e45:	f3 0f 1e fb          	endbr32 
    3e49:	55                   	push   %ebp
    3e4a:	89 e5                	mov    %esp,%ebp
    3e4c:	57                   	push   %edi
    3e4d:	56                   	push   %esi
    3e4e:	53                   	push   %ebx
    3e4f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    3e52:	8d 45 10             	lea    0x10(%ebp),%eax
    3e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    3e58:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    3e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
    3e62:	eb 12                	jmp    3e76 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    3e64:	89 fa                	mov    %edi,%edx
    3e66:	8b 45 08             	mov    0x8(%ebp),%eax
    3e69:	e8 48 ff ff ff       	call   3db6 <putc>
    3e6e:	eb 05                	jmp    3e75 <printf+0x30>
      }
    } else if(state == '%'){
    3e70:	83 fe 25             	cmp    $0x25,%esi
    3e73:	74 22                	je     3e97 <printf+0x52>
  for(i = 0; fmt[i]; i++){
    3e75:	43                   	inc    %ebx
    3e76:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e79:	8a 04 18             	mov    (%eax,%ebx,1),%al
    3e7c:	84 c0                	test   %al,%al
    3e7e:	0f 84 13 01 00 00    	je     3f97 <printf+0x152>
    c = fmt[i] & 0xff;
    3e84:	0f be f8             	movsbl %al,%edi
    3e87:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    3e8a:	85 f6                	test   %esi,%esi
    3e8c:	75 e2                	jne    3e70 <printf+0x2b>
      if(c == '%'){
    3e8e:	83 f8 25             	cmp    $0x25,%eax
    3e91:	75 d1                	jne    3e64 <printf+0x1f>
        state = '%';
    3e93:	89 c6                	mov    %eax,%esi
    3e95:	eb de                	jmp    3e75 <printf+0x30>
      if(c == 'd'){
    3e97:	83 f8 64             	cmp    $0x64,%eax
    3e9a:	74 43                	je     3edf <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3e9c:	83 f8 78             	cmp    $0x78,%eax
    3e9f:	74 68                	je     3f09 <printf+0xc4>
    3ea1:	83 f8 70             	cmp    $0x70,%eax
    3ea4:	74 63                	je     3f09 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3ea6:	83 f8 73             	cmp    $0x73,%eax
    3ea9:	0f 84 84 00 00 00    	je     3f33 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3eaf:	83 f8 63             	cmp    $0x63,%eax
    3eb2:	0f 84 ad 00 00 00    	je     3f65 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3eb8:	83 f8 25             	cmp    $0x25,%eax
    3ebb:	0f 84 c2 00 00 00    	je     3f83 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3ec1:	ba 25 00 00 00       	mov    $0x25,%edx
    3ec6:	8b 45 08             	mov    0x8(%ebp),%eax
    3ec9:	e8 e8 fe ff ff       	call   3db6 <putc>
        putc(fd, c);
    3ece:	89 fa                	mov    %edi,%edx
    3ed0:	8b 45 08             	mov    0x8(%ebp),%eax
    3ed3:	e8 de fe ff ff       	call   3db6 <putc>
      }
      state = 0;
    3ed8:	be 00 00 00 00       	mov    $0x0,%esi
    3edd:	eb 96                	jmp    3e75 <printf+0x30>
        printint(fd, *ap, 10, 1);
    3edf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3ee2:	8b 17                	mov    (%edi),%edx
    3ee4:	83 ec 0c             	sub    $0xc,%esp
    3ee7:	6a 01                	push   $0x1
    3ee9:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3eee:	8b 45 08             	mov    0x8(%ebp),%eax
    3ef1:	e8 da fe ff ff       	call   3dd0 <printint>
        ap++;
    3ef6:	83 c7 04             	add    $0x4,%edi
    3ef9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3efc:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3eff:	be 00 00 00 00       	mov    $0x0,%esi
    3f04:	e9 6c ff ff ff       	jmp    3e75 <printf+0x30>
        printint(fd, *ap, 16, 0);
    3f09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3f0c:	8b 17                	mov    (%edi),%edx
    3f0e:	83 ec 0c             	sub    $0xc,%esp
    3f11:	6a 00                	push   $0x0
    3f13:	b9 10 00 00 00       	mov    $0x10,%ecx
    3f18:	8b 45 08             	mov    0x8(%ebp),%eax
    3f1b:	e8 b0 fe ff ff       	call   3dd0 <printint>
        ap++;
    3f20:	83 c7 04             	add    $0x4,%edi
    3f23:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3f26:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3f29:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
    3f2e:	e9 42 ff ff ff       	jmp    3e75 <printf+0x30>
        s = (char*)*ap;
    3f33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f36:	8b 30                	mov    (%eax),%esi
        ap++;
    3f38:	83 c0 04             	add    $0x4,%eax
    3f3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    3f3e:	85 f6                	test   %esi,%esi
    3f40:	75 13                	jne    3f55 <printf+0x110>
          s = "(null)";
    3f42:	be 98 58 00 00       	mov    $0x5898,%esi
    3f47:	eb 0c                	jmp    3f55 <printf+0x110>
          putc(fd, *s);
    3f49:	0f be d2             	movsbl %dl,%edx
    3f4c:	8b 45 08             	mov    0x8(%ebp),%eax
    3f4f:	e8 62 fe ff ff       	call   3db6 <putc>
          s++;
    3f54:	46                   	inc    %esi
        while(*s != 0){
    3f55:	8a 16                	mov    (%esi),%dl
    3f57:	84 d2                	test   %dl,%dl
    3f59:	75 ee                	jne    3f49 <printf+0x104>
      state = 0;
    3f5b:	be 00 00 00 00       	mov    $0x0,%esi
    3f60:	e9 10 ff ff ff       	jmp    3e75 <printf+0x30>
        putc(fd, *ap);
    3f65:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3f68:	0f be 17             	movsbl (%edi),%edx
    3f6b:	8b 45 08             	mov    0x8(%ebp),%eax
    3f6e:	e8 43 fe ff ff       	call   3db6 <putc>
        ap++;
    3f73:	83 c7 04             	add    $0x4,%edi
    3f76:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    3f79:	be 00 00 00 00       	mov    $0x0,%esi
    3f7e:	e9 f2 fe ff ff       	jmp    3e75 <printf+0x30>
        putc(fd, c);
    3f83:	89 fa                	mov    %edi,%edx
    3f85:	8b 45 08             	mov    0x8(%ebp),%eax
    3f88:	e8 29 fe ff ff       	call   3db6 <putc>
      state = 0;
    3f8d:	be 00 00 00 00       	mov    $0x0,%esi
    3f92:	e9 de fe ff ff       	jmp    3e75 <printf+0x30>
    }
  }
}
    3f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3f9a:	5b                   	pop    %ebx
    3f9b:	5e                   	pop    %esi
    3f9c:	5f                   	pop    %edi
    3f9d:	5d                   	pop    %ebp
    3f9e:	c3                   	ret    

00003f9f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3f9f:	f3 0f 1e fb          	endbr32 
    3fa3:	55                   	push   %ebp
    3fa4:	89 e5                	mov    %esp,%ebp
    3fa6:	57                   	push   %edi
    3fa7:	56                   	push   %esi
    3fa8:	53                   	push   %ebx
    3fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3fac:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3faf:	a1 e0 61 00 00       	mov    0x61e0,%eax
    3fb4:	eb 02                	jmp    3fb8 <free+0x19>
    3fb6:	89 d0                	mov    %edx,%eax
    3fb8:	39 c8                	cmp    %ecx,%eax
    3fba:	73 04                	jae    3fc0 <free+0x21>
    3fbc:	39 08                	cmp    %ecx,(%eax)
    3fbe:	77 12                	ja     3fd2 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3fc0:	8b 10                	mov    (%eax),%edx
    3fc2:	39 c2                	cmp    %eax,%edx
    3fc4:	77 f0                	ja     3fb6 <free+0x17>
    3fc6:	39 c8                	cmp    %ecx,%eax
    3fc8:	72 08                	jb     3fd2 <free+0x33>
    3fca:	39 ca                	cmp    %ecx,%edx
    3fcc:	77 04                	ja     3fd2 <free+0x33>
    3fce:	89 d0                	mov    %edx,%eax
    3fd0:	eb e6                	jmp    3fb8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3fd2:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3fd5:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3fd8:	8b 10                	mov    (%eax),%edx
    3fda:	39 d7                	cmp    %edx,%edi
    3fdc:	74 19                	je     3ff7 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3fde:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3fe1:	8b 50 04             	mov    0x4(%eax),%edx
    3fe4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3fe7:	39 ce                	cmp    %ecx,%esi
    3fe9:	74 1b                	je     4006 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3feb:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3fed:	a3 e0 61 00 00       	mov    %eax,0x61e0
}
    3ff2:	5b                   	pop    %ebx
    3ff3:	5e                   	pop    %esi
    3ff4:	5f                   	pop    %edi
    3ff5:	5d                   	pop    %ebp
    3ff6:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    3ff7:	03 72 04             	add    0x4(%edx),%esi
    3ffa:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3ffd:	8b 10                	mov    (%eax),%edx
    3fff:	8b 12                	mov    (%edx),%edx
    4001:	89 53 f8             	mov    %edx,-0x8(%ebx)
    4004:	eb db                	jmp    3fe1 <free+0x42>
    p->s.size += bp->s.size;
    4006:	03 53 fc             	add    -0x4(%ebx),%edx
    4009:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    400c:	8b 53 f8             	mov    -0x8(%ebx),%edx
    400f:	89 10                	mov    %edx,(%eax)
    4011:	eb da                	jmp    3fed <free+0x4e>

00004013 <morecore>:

static Header*
morecore(uint nu)
{
    4013:	55                   	push   %ebp
    4014:	89 e5                	mov    %esp,%ebp
    4016:	53                   	push   %ebx
    4017:	83 ec 04             	sub    $0x4,%esp
    401a:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    401c:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    4021:	77 05                	ja     4028 <morecore+0x15>
    nu = 4096;
    4023:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    4028:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    402f:	83 ec 0c             	sub    $0xc,%esp
    4032:	50                   	push   %eax
    4033:	e8 4e fd ff ff       	call   3d86 <sbrk>
  if(p == (char*)-1)
    4038:	83 c4 10             	add    $0x10,%esp
    403b:	83 f8 ff             	cmp    $0xffffffff,%eax
    403e:	74 1c                	je     405c <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    4040:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    4043:	83 c0 08             	add    $0x8,%eax
    4046:	83 ec 0c             	sub    $0xc,%esp
    4049:	50                   	push   %eax
    404a:	e8 50 ff ff ff       	call   3f9f <free>
  return freep;
    404f:	a1 e0 61 00 00       	mov    0x61e0,%eax
    4054:	83 c4 10             	add    $0x10,%esp
}
    4057:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    405a:	c9                   	leave  
    405b:	c3                   	ret    
    return 0;
    405c:	b8 00 00 00 00       	mov    $0x0,%eax
    4061:	eb f4                	jmp    4057 <morecore+0x44>

00004063 <malloc>:

void*
malloc(uint nbytes)
{
    4063:	f3 0f 1e fb          	endbr32 
    4067:	55                   	push   %ebp
    4068:	89 e5                	mov    %esp,%ebp
    406a:	53                   	push   %ebx
    406b:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    406e:	8b 45 08             	mov    0x8(%ebp),%eax
    4071:	8d 58 07             	lea    0x7(%eax),%ebx
    4074:	c1 eb 03             	shr    $0x3,%ebx
    4077:	43                   	inc    %ebx
  if((prevp = freep) == 0){
    4078:	8b 0d e0 61 00 00    	mov    0x61e0,%ecx
    407e:	85 c9                	test   %ecx,%ecx
    4080:	74 04                	je     4086 <malloc+0x23>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4082:	8b 01                	mov    (%ecx),%eax
    4084:	eb 4b                	jmp    40d1 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
    4086:	c7 05 e0 61 00 00 e4 	movl   $0x61e4,0x61e0
    408d:	61 00 00 
    4090:	c7 05 e4 61 00 00 e4 	movl   $0x61e4,0x61e4
    4097:	61 00 00 
    base.s.size = 0;
    409a:	c7 05 e8 61 00 00 00 	movl   $0x0,0x61e8
    40a1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    40a4:	b9 e4 61 00 00       	mov    $0x61e4,%ecx
    40a9:	eb d7                	jmp    4082 <malloc+0x1f>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    40ab:	74 1a                	je     40c7 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    40ad:	29 da                	sub    %ebx,%edx
    40af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    40b2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    40b5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    40b8:	89 0d e0 61 00 00    	mov    %ecx,0x61e0
      return (void*)(p + 1);
    40be:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    40c1:	83 c4 04             	add    $0x4,%esp
    40c4:	5b                   	pop    %ebx
    40c5:	5d                   	pop    %ebp
    40c6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    40c7:	8b 10                	mov    (%eax),%edx
    40c9:	89 11                	mov    %edx,(%ecx)
    40cb:	eb eb                	jmp    40b8 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40cd:	89 c1                	mov    %eax,%ecx
    40cf:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    40d1:	8b 50 04             	mov    0x4(%eax),%edx
    40d4:	39 da                	cmp    %ebx,%edx
    40d6:	73 d3                	jae    40ab <malloc+0x48>
    if(p == freep)
    40d8:	39 05 e0 61 00 00    	cmp    %eax,0x61e0
    40de:	75 ed                	jne    40cd <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
    40e0:	89 d8                	mov    %ebx,%eax
    40e2:	e8 2c ff ff ff       	call   4013 <morecore>
    40e7:	85 c0                	test   %eax,%eax
    40e9:	75 e2                	jne    40cd <malloc+0x6a>
    40eb:	eb d4                	jmp    40c1 <malloc+0x5e>
