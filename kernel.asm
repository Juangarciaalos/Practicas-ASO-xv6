
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 30 58 11 80       	mov    $0x80115830,%esp
8010002d:	b8 ad 29 10 80       	mov    $0x801029ad,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 96 3b 00 00       	call   80103be1 <acquire>
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 20 a5 10 80       	push   $0x8010a520
8010007a:	e8 c7 3b 00 00       	call   80103c46 <release>
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 48 39 00 00       	call   801039d2 <acquiresleep>
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
8010008f:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 79 3b 00 00       	call   80103c46 <release>
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 fa 38 00 00       	call   801039d2 <acquiresleep>
801000d8:	83 c4 10             	add    $0x10,%esp
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 40 68 10 80       	push   $0x80106840
801000ed:	e8 4f 02 00 00       	call   80100341 <panic>

801000f2 <binit>:
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
801000f9:	68 51 68 10 80       	push   $0x80106851
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 a2 39 00 00       	call   80103aaa <initlock>
80100108:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010010f:	ec 10 80 
80100112:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100119:	ec 10 80 
8010011c:	83 c4 10             	add    $0x10,%esp
8010011f:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100124:	eb 37                	jmp    8010015d <binit+0x6b>
80100126:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012b:	89 43 54             	mov    %eax,0x54(%ebx)
8010012e:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
80100135:	83 ec 08             	sub    $0x8,%esp
80100138:	68 58 68 10 80       	push   $0x80106858
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 59 38 00 00       	call   8010399f <initsleeplock>
80100146:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014b:	89 58 50             	mov    %ebx,0x50(%eax)
8010014e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
80100154:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015a:	83 c4 10             	add    $0x10,%esp
8010015d:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100163:	72 c1                	jb     80100126 <binit+0x34>
80100165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100168:	c9                   	leave  
80100169:	c3                   	ret    

8010016a <bread>:
8010016a:	55                   	push   %ebp
8010016b:	89 e5                	mov    %esp,%ebp
8010016d:	53                   	push   %ebx
8010016e:	83 ec 04             	sub    $0x4,%esp
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	8b 45 08             	mov    0x8(%ebp),%eax
80100177:	e8 b8 fe ff ff       	call   80100034 <bget>
8010017c:	89 c3                	mov    %eax,%ebx
8010017e:	f6 00 02             	testb  $0x2,(%eax)
80100181:	74 07                	je     8010018a <bread+0x20>
80100183:	89 d8                	mov    %ebx,%eax
80100185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100188:	c9                   	leave  
80100189:	c3                   	ret    
8010018a:	83 ec 0c             	sub    $0xc,%esp
8010018d:	50                   	push   %eax
8010018e:	e8 ea 1b 00 00       	call   80101d7d <iderw>
80100193:	83 c4 10             	add    $0x10,%esp
80100196:	eb eb                	jmp    80100183 <bread+0x19>

80100198 <bwrite>:
80100198:	55                   	push   %ebp
80100199:	89 e5                	mov    %esp,%ebp
8010019b:	53                   	push   %ebx
8010019c:	83 ec 10             	sub    $0x10,%esp
8010019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a5:	50                   	push   %eax
801001a6:	e8 b1 38 00 00       	call   80103a5c <holdingsleep>
801001ab:	83 c4 10             	add    $0x10,%esp
801001ae:	85 c0                	test   %eax,%eax
801001b0:	74 14                	je     801001c6 <bwrite+0x2e>
801001b2:	83 0b 04             	orl    $0x4,(%ebx)
801001b5:	83 ec 0c             	sub    $0xc,%esp
801001b8:	53                   	push   %ebx
801001b9:	e8 bf 1b 00 00       	call   80101d7d <iderw>
801001be:	83 c4 10             	add    $0x10,%esp
801001c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c4:	c9                   	leave  
801001c5:	c3                   	ret    
801001c6:	83 ec 0c             	sub    $0xc,%esp
801001c9:	68 5f 68 10 80       	push   $0x8010685f
801001ce:	e8 6e 01 00 00       	call   80100341 <panic>

801001d3 <brelse>:
801001d3:	55                   	push   %ebp
801001d4:	89 e5                	mov    %esp,%ebp
801001d6:	56                   	push   %esi
801001d7:	53                   	push   %ebx
801001d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001db:	8d 73 0c             	lea    0xc(%ebx),%esi
801001de:	83 ec 0c             	sub    $0xc,%esp
801001e1:	56                   	push   %esi
801001e2:	e8 75 38 00 00       	call   80103a5c <holdingsleep>
801001e7:	83 c4 10             	add    $0x10,%esp
801001ea:	85 c0                	test   %eax,%eax
801001ec:	74 69                	je     80100257 <brelse+0x84>
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 2a 38 00 00       	call   80103a21 <releasesleep>
801001f7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001fe:	e8 de 39 00 00       	call   80103be1 <acquire>
80100203:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100206:	48                   	dec    %eax
80100207:	89 43 4c             	mov    %eax,0x4c(%ebx)
8010020a:	83 c4 10             	add    $0x10,%esp
8010020d:	85 c0                	test   %eax,%eax
8010020f:	75 2f                	jne    80100240 <brelse+0x6d>
80100211:	8b 43 54             	mov    0x54(%ebx),%eax
80100214:	8b 53 50             	mov    0x50(%ebx),%edx
80100217:	89 50 50             	mov    %edx,0x50(%eax)
8010021a:	8b 43 50             	mov    0x50(%ebx),%eax
8010021d:	8b 53 54             	mov    0x54(%ebx),%edx
80100220:	89 50 54             	mov    %edx,0x54(%eax)
80100223:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100228:	89 43 54             	mov    %eax,0x54(%ebx)
8010022b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
80100232:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100237:	89 58 50             	mov    %ebx,0x50(%eax)
8010023a:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 20 a5 10 80       	push   $0x8010a520
80100248:	e8 f9 39 00 00       	call   80103c46 <release>
8010024d:	83 c4 10             	add    $0x10,%esp
80100250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100253:	5b                   	pop    %ebx
80100254:	5e                   	pop    %esi
80100255:	5d                   	pop    %ebp
80100256:	c3                   	ret    
80100257:	83 ec 0c             	sub    $0xc,%esp
8010025a:	68 66 68 10 80       	push   $0x80106866
8010025f:	e8 dd 00 00 00       	call   80100341 <panic>

80100264 <consoleread>:
80100264:	55                   	push   %ebp
80100265:	89 e5                	mov    %esp,%ebp
80100267:	57                   	push   %edi
80100268:	56                   	push   %esi
80100269:	53                   	push   %ebx
8010026a:	83 ec 28             	sub    $0x28,%esp
8010026d:	8b 7d 08             	mov    0x8(%ebp),%edi
80100270:	8b 75 0c             	mov    0xc(%ebp),%esi
80100273:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100276:	57                   	push   %edi
80100277:	e8 4a 13 00 00       	call   801015c6 <iunlock>
8010027c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010027f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100286:	e8 56 39 00 00       	call   80103be1 <acquire>
8010028b:	83 c4 10             	add    $0x10,%esp
8010028e:	85 db                	test   %ebx,%ebx
80100290:	0f 8e 8c 00 00 00    	jle    80100322 <consoleread+0xbe>
80100296:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a1:	75 47                	jne    801002ea <consoleread+0x86>
801002a3:	e8 7a 2e 00 00       	call   80103122 <myproc>
801002a8:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002ac:	75 17                	jne    801002c5 <consoleread+0x61>
801002ae:	83 ec 08             	sub    $0x8,%esp
801002b1:	68 20 ef 10 80       	push   $0x8010ef20
801002b6:	68 00 ef 10 80       	push   $0x8010ef00
801002bb:	e8 fc 33 00 00       	call   801036bc <sleep>
801002c0:	83 c4 10             	add    $0x10,%esp
801002c3:	eb d1                	jmp    80100296 <consoleread+0x32>
801002c5:	83 ec 0c             	sub    $0xc,%esp
801002c8:	68 20 ef 10 80       	push   $0x8010ef20
801002cd:	e8 74 39 00 00       	call   80103c46 <release>
801002d2:	89 3c 24             	mov    %edi,(%esp)
801002d5:	e8 2c 12 00 00       	call   80101506 <ilock>
801002da:	83 c4 10             	add    $0x10,%esp
801002dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e5:	5b                   	pop    %ebx
801002e6:	5e                   	pop    %esi
801002e7:	5f                   	pop    %edi
801002e8:	5d                   	pop    %ebp
801002e9:	c3                   	ret    
801002ea:	8d 50 01             	lea    0x1(%eax),%edx
801002ed:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f3:	89 c2                	mov    %eax,%edx
801002f5:	83 e2 7f             	and    $0x7f,%edx
801002f8:	8a 92 80 ee 10 80    	mov    -0x7fef1180(%edx),%dl
801002fe:	0f be ca             	movsbl %dl,%ecx
80100301:	80 fa 04             	cmp    $0x4,%dl
80100304:	74 12                	je     80100318 <consoleread+0xb4>
80100306:	8d 46 01             	lea    0x1(%esi),%eax
80100309:	88 16                	mov    %dl,(%esi)
8010030b:	4b                   	dec    %ebx
8010030c:	83 f9 0a             	cmp    $0xa,%ecx
8010030f:	74 11                	je     80100322 <consoleread+0xbe>
80100311:	89 c6                	mov    %eax,%esi
80100313:	e9 76 ff ff ff       	jmp    8010028e <consoleread+0x2a>
80100318:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010031b:	73 05                	jae    80100322 <consoleread+0xbe>
8010031d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100322:	83 ec 0c             	sub    $0xc,%esp
80100325:	68 20 ef 10 80       	push   $0x8010ef20
8010032a:	e8 17 39 00 00       	call   80103c46 <release>
8010032f:	89 3c 24             	mov    %edi,(%esp)
80100332:	e8 cf 11 00 00       	call   80101506 <ilock>
80100337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033a:	29 d8                	sub    %ebx,%eax
8010033c:	83 c4 10             	add    $0x10,%esp
8010033f:	eb a1                	jmp    801002e2 <consoleread+0x7e>

80100341 <panic>:
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
80100344:	53                   	push   %ebx
80100345:	83 ec 34             	sub    $0x34,%esp
80100348:	fa                   	cli    
80100349:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100350:	00 00 00 
80100353:	e8 8b 1f 00 00       	call   801022e3 <lapicid>
80100358:	83 ec 08             	sub    $0x8,%esp
8010035b:	50                   	push   %eax
8010035c:	68 6d 68 10 80       	push   $0x8010686d
80100361:	e8 74 02 00 00       	call   801005da <cprintf>
80100366:	83 c4 04             	add    $0x4,%esp
80100369:	ff 75 08             	push   0x8(%ebp)
8010036c:	e8 69 02 00 00       	call   801005da <cprintf>
80100371:	c7 04 24 2f 72 10 80 	movl   $0x8010722f,(%esp)
80100378:	e8 5d 02 00 00       	call   801005da <cprintf>
8010037d:	83 c4 08             	add    $0x8,%esp
80100380:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100383:	50                   	push   %eax
80100384:	8d 45 08             	lea    0x8(%ebp),%eax
80100387:	50                   	push   %eax
80100388:	e8 38 37 00 00       	call   80103ac5 <getcallerpcs>
8010038d:	83 c4 10             	add    $0x10,%esp
80100390:	bb 00 00 00 00       	mov    $0x0,%ebx
80100395:	eb 15                	jmp    801003ac <panic+0x6b>
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
8010039e:	68 81 68 10 80       	push   $0x80106881
801003a3:	e8 32 02 00 00       	call   801005da <cprintf>
801003a8:	43                   	inc    %ebx
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	83 fb 09             	cmp    $0x9,%ebx
801003af:	7e e6                	jle    80100397 <panic+0x56>
801003b1:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003b8:	00 00 00 
801003bb:	eb fe                	jmp    801003bb <panic+0x7a>

801003bd <cgaputc>:
801003bd:	55                   	push   %ebp
801003be:	89 e5                	mov    %esp,%ebp
801003c0:	57                   	push   %edi
801003c1:	56                   	push   %esi
801003c2:	53                   	push   %ebx
801003c3:	83 ec 0c             	sub    $0xc,%esp
801003c6:	89 c3                	mov    %eax,%ebx
801003c8:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003cd:	b0 0e                	mov    $0xe,%al
801003cf:	89 fa                	mov    %edi,%edx
801003d1:	ee                   	out    %al,(%dx)
801003d2:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003d7:	89 ca                	mov    %ecx,%edx
801003d9:	ec                   	in     (%dx),%al
801003da:	0f b6 f0             	movzbl %al,%esi
801003dd:	c1 e6 08             	shl    $0x8,%esi
801003e0:	b0 0f                	mov    $0xf,%al
801003e2:	89 fa                	mov    %edi,%edx
801003e4:	ee                   	out    %al,(%dx)
801003e5:	89 ca                	mov    %ecx,%edx
801003e7:	ec                   	in     (%dx),%al
801003e8:	0f b6 c8             	movzbl %al,%ecx
801003eb:	09 f1                	or     %esi,%ecx
801003ed:	83 fb 0a             	cmp    $0xa,%ebx
801003f0:	74 5a                	je     8010044c <cgaputc+0x8f>
801003f2:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801003f8:	74 62                	je     8010045c <cgaputc+0x9f>
801003fa:	0f b6 c3             	movzbl %bl,%eax
801003fd:	8d 59 01             	lea    0x1(%ecx),%ebx
80100400:	80 cc 07             	or     $0x7,%ah
80100403:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
8010040a:	80 
8010040b:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100411:	77 56                	ja     80100469 <cgaputc+0xac>
80100413:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100419:	7f 5b                	jg     80100476 <cgaputc+0xb9>
8010041b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100420:	b0 0e                	mov    $0xe,%al
80100422:	89 f2                	mov    %esi,%edx
80100424:	ee                   	out    %al,(%dx)
80100425:	0f b6 c7             	movzbl %bh,%eax
80100428:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010042d:	89 ca                	mov    %ecx,%edx
8010042f:	ee                   	out    %al,(%dx)
80100430:	b0 0f                	mov    $0xf,%al
80100432:	89 f2                	mov    %esi,%edx
80100434:	ee                   	out    %al,(%dx)
80100435:	88 d8                	mov    %bl,%al
80100437:	89 ca                	mov    %ecx,%edx
80100439:	ee                   	out    %al,(%dx)
8010043a:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100441:	80 20 07 
80100444:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100447:	5b                   	pop    %ebx
80100448:	5e                   	pop    %esi
80100449:	5f                   	pop    %edi
8010044a:	5d                   	pop    %ebp
8010044b:	c3                   	ret    
8010044c:	bb 50 00 00 00       	mov    $0x50,%ebx
80100451:	89 c8                	mov    %ecx,%eax
80100453:	99                   	cltd   
80100454:	f7 fb                	idiv   %ebx
80100456:	29 d3                	sub    %edx,%ebx
80100458:	01 cb                	add    %ecx,%ebx
8010045a:	eb af                	jmp    8010040b <cgaputc+0x4e>
8010045c:	85 c9                	test   %ecx,%ecx
8010045e:	7e 05                	jle    80100465 <cgaputc+0xa8>
80100460:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100463:	eb a6                	jmp    8010040b <cgaputc+0x4e>
80100465:	89 cb                	mov    %ecx,%ebx
80100467:	eb a2                	jmp    8010040b <cgaputc+0x4e>
80100469:	83 ec 0c             	sub    $0xc,%esp
8010046c:	68 85 68 10 80       	push   $0x80106885
80100471:	e8 cb fe ff ff       	call   80100341 <panic>
80100476:	83 ec 04             	sub    $0x4,%esp
80100479:	68 60 0e 00 00       	push   $0xe60
8010047e:	68 a0 80 0b 80       	push   $0x800b80a0
80100483:	68 00 80 0b 80       	push   $0x800b8000
80100488:	e8 7e 38 00 00       	call   80103d0b <memmove>
8010048d:	83 eb 50             	sub    $0x50,%ebx
80100490:	b8 80 07 00 00       	mov    $0x780,%eax
80100495:	29 d8                	sub    %ebx,%eax
80100497:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
8010049e:	83 c4 0c             	add    $0xc,%esp
801004a1:	01 c0                	add    %eax,%eax
801004a3:	50                   	push   %eax
801004a4:	6a 00                	push   $0x0
801004a6:	52                   	push   %edx
801004a7:	e8 e1 37 00 00       	call   80103c8d <memset>
801004ac:	83 c4 10             	add    $0x10,%esp
801004af:	e9 67 ff ff ff       	jmp    8010041b <cgaputc+0x5e>

801004b4 <consputc>:
801004b4:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004bb:	74 03                	je     801004c0 <consputc+0xc>
801004bd:	fa                   	cli    
801004be:	eb fe                	jmp    801004be <consputc+0xa>
801004c0:	55                   	push   %ebp
801004c1:	89 e5                	mov    %esp,%ebp
801004c3:	53                   	push   %ebx
801004c4:	83 ec 04             	sub    $0x4,%esp
801004c7:	89 c3                	mov    %eax,%ebx
801004c9:	3d 00 01 00 00       	cmp    $0x100,%eax
801004ce:	74 18                	je     801004e8 <consputc+0x34>
801004d0:	83 ec 0c             	sub    $0xc,%esp
801004d3:	50                   	push   %eax
801004d4:	e8 9d 4d 00 00       	call   80105276 <uartputc>
801004d9:	83 c4 10             	add    $0x10,%esp
801004dc:	89 d8                	mov    %ebx,%eax
801004de:	e8 da fe ff ff       	call   801003bd <cgaputc>
801004e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801004e6:	c9                   	leave  
801004e7:	c3                   	ret    
801004e8:	83 ec 0c             	sub    $0xc,%esp
801004eb:	6a 08                	push   $0x8
801004ed:	e8 84 4d 00 00       	call   80105276 <uartputc>
801004f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f9:	e8 78 4d 00 00       	call   80105276 <uartputc>
801004fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100505:	e8 6c 4d 00 00       	call   80105276 <uartputc>
8010050a:	83 c4 10             	add    $0x10,%esp
8010050d:	eb cd                	jmp    801004dc <consputc+0x28>

8010050f <printint>:
8010050f:	55                   	push   %ebp
80100510:	89 e5                	mov    %esp,%ebp
80100512:	57                   	push   %edi
80100513:	56                   	push   %esi
80100514:	53                   	push   %ebx
80100515:	83 ec 2c             	sub    $0x2c,%esp
80100518:	89 d6                	mov    %edx,%esi
8010051a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
8010051d:	85 c9                	test   %ecx,%ecx
8010051f:	74 0c                	je     8010052d <printint+0x1e>
80100521:	89 c7                	mov    %eax,%edi
80100523:	c1 ef 1f             	shr    $0x1f,%edi
80100526:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100529:	85 c0                	test   %eax,%eax
8010052b:	78 35                	js     80100562 <printint+0x53>
8010052d:	89 c1                	mov    %eax,%ecx
8010052f:	bb 00 00 00 00       	mov    $0x0,%ebx
80100534:	89 c8                	mov    %ecx,%eax
80100536:	ba 00 00 00 00       	mov    $0x0,%edx
8010053b:	f7 f6                	div    %esi
8010053d:	89 df                	mov    %ebx,%edi
8010053f:	43                   	inc    %ebx
80100540:	8a 92 b0 68 10 80    	mov    -0x7fef9750(%edx),%dl
80100546:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
8010054a:	89 ca                	mov    %ecx,%edx
8010054c:	89 c1                	mov    %eax,%ecx
8010054e:	39 d6                	cmp    %edx,%esi
80100550:	76 e2                	jbe    80100534 <printint+0x25>
80100552:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100556:	74 1a                	je     80100572 <printint+0x63>
80100558:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010055d:	8d 5f 02             	lea    0x2(%edi),%ebx
80100560:	eb 10                	jmp    80100572 <printint+0x63>
80100562:	f7 d8                	neg    %eax
80100564:	89 c1                	mov    %eax,%ecx
80100566:	eb c7                	jmp    8010052f <printint+0x20>
80100568:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010056d:	e8 42 ff ff ff       	call   801004b4 <consputc>
80100572:	4b                   	dec    %ebx
80100573:	79 f3                	jns    80100568 <printint+0x59>
80100575:	83 c4 2c             	add    $0x2c,%esp
80100578:	5b                   	pop    %ebx
80100579:	5e                   	pop    %esi
8010057a:	5f                   	pop    %edi
8010057b:	5d                   	pop    %ebp
8010057c:	c3                   	ret    

8010057d <consolewrite>:
8010057d:	55                   	push   %ebp
8010057e:	89 e5                	mov    %esp,%ebp
80100580:	57                   	push   %edi
80100581:	56                   	push   %esi
80100582:	53                   	push   %ebx
80100583:	83 ec 18             	sub    $0x18,%esp
80100586:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100589:	8b 75 10             	mov    0x10(%ebp),%esi
8010058c:	ff 75 08             	push   0x8(%ebp)
8010058f:	e8 32 10 00 00       	call   801015c6 <iunlock>
80100594:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010059b:	e8 41 36 00 00       	call   80103be1 <acquire>
801005a0:	83 c4 10             	add    $0x10,%esp
801005a3:	bb 00 00 00 00       	mov    $0x0,%ebx
801005a8:	eb 0a                	jmp    801005b4 <consolewrite+0x37>
801005aa:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005ae:	e8 01 ff ff ff       	call   801004b4 <consputc>
801005b3:	43                   	inc    %ebx
801005b4:	39 f3                	cmp    %esi,%ebx
801005b6:	7c f2                	jl     801005aa <consolewrite+0x2d>
801005b8:	83 ec 0c             	sub    $0xc,%esp
801005bb:	68 20 ef 10 80       	push   $0x8010ef20
801005c0:	e8 81 36 00 00       	call   80103c46 <release>
801005c5:	83 c4 04             	add    $0x4,%esp
801005c8:	ff 75 08             	push   0x8(%ebp)
801005cb:	e8 36 0f 00 00       	call   80101506 <ilock>
801005d0:	89 f0                	mov    %esi,%eax
801005d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    

801005da <cprintf>:
801005da:	55                   	push   %ebp
801005db:	89 e5                	mov    %esp,%ebp
801005dd:	57                   	push   %edi
801005de:	56                   	push   %esi
801005df:	53                   	push   %ebx
801005e0:	83 ec 1c             	sub    $0x1c,%esp
801005e3:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801005eb:	85 c0                	test   %eax,%eax
801005ed:	75 10                	jne    801005ff <cprintf+0x25>
801005ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801005f3:	74 1c                	je     80100611 <cprintf+0x37>
801005f5:	8d 7d 0c             	lea    0xc(%ebp),%edi
801005f8:	be 00 00 00 00       	mov    $0x0,%esi
801005fd:	eb 25                	jmp    80100624 <cprintf+0x4a>
801005ff:	83 ec 0c             	sub    $0xc,%esp
80100602:	68 20 ef 10 80       	push   $0x8010ef20
80100607:	e8 d5 35 00 00       	call   80103be1 <acquire>
8010060c:	83 c4 10             	add    $0x10,%esp
8010060f:	eb de                	jmp    801005ef <cprintf+0x15>
80100611:	83 ec 0c             	sub    $0xc,%esp
80100614:	68 9f 68 10 80       	push   $0x8010689f
80100619:	e8 23 fd ff ff       	call   80100341 <panic>
8010061e:	e8 91 fe ff ff       	call   801004b4 <consputc>
80100623:	46                   	inc    %esi
80100624:	8b 55 08             	mov    0x8(%ebp),%edx
80100627:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
8010062b:	85 c0                	test   %eax,%eax
8010062d:	0f 84 ac 00 00 00    	je     801006df <cprintf+0x105>
80100633:	83 f8 25             	cmp    $0x25,%eax
80100636:	75 e6                	jne    8010061e <cprintf+0x44>
80100638:	46                   	inc    %esi
80100639:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
8010063d:	85 db                	test   %ebx,%ebx
8010063f:	0f 84 9a 00 00 00    	je     801006df <cprintf+0x105>
80100645:	83 fb 70             	cmp    $0x70,%ebx
80100648:	74 2e                	je     80100678 <cprintf+0x9e>
8010064a:	7f 22                	jg     8010066e <cprintf+0x94>
8010064c:	83 fb 25             	cmp    $0x25,%ebx
8010064f:	74 69                	je     801006ba <cprintf+0xe0>
80100651:	83 fb 64             	cmp    $0x64,%ebx
80100654:	75 73                	jne    801006c9 <cprintf+0xef>
80100656:	8d 5f 04             	lea    0x4(%edi),%ebx
80100659:	8b 07                	mov    (%edi),%eax
8010065b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100660:	ba 0a 00 00 00       	mov    $0xa,%edx
80100665:	e8 a5 fe ff ff       	call   8010050f <printint>
8010066a:	89 df                	mov    %ebx,%edi
8010066c:	eb b5                	jmp    80100623 <cprintf+0x49>
8010066e:	83 fb 73             	cmp    $0x73,%ebx
80100671:	74 1d                	je     80100690 <cprintf+0xb6>
80100673:	83 fb 78             	cmp    $0x78,%ebx
80100676:	75 51                	jne    801006c9 <cprintf+0xef>
80100678:	8d 5f 04             	lea    0x4(%edi),%ebx
8010067b:	8b 07                	mov    (%edi),%eax
8010067d:	b9 00 00 00 00       	mov    $0x0,%ecx
80100682:	ba 10 00 00 00       	mov    $0x10,%edx
80100687:	e8 83 fe ff ff       	call   8010050f <printint>
8010068c:	89 df                	mov    %ebx,%edi
8010068e:	eb 93                	jmp    80100623 <cprintf+0x49>
80100690:	8d 47 04             	lea    0x4(%edi),%eax
80100693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100696:	8b 1f                	mov    (%edi),%ebx
80100698:	85 db                	test   %ebx,%ebx
8010069a:	75 10                	jne    801006ac <cprintf+0xd2>
8010069c:	bb 98 68 10 80       	mov    $0x80106898,%ebx
801006a1:	eb 09                	jmp    801006ac <cprintf+0xd2>
801006a3:	0f be c0             	movsbl %al,%eax
801006a6:	e8 09 fe ff ff       	call   801004b4 <consputc>
801006ab:	43                   	inc    %ebx
801006ac:	8a 03                	mov    (%ebx),%al
801006ae:	84 c0                	test   %al,%al
801006b0:	75 f1                	jne    801006a3 <cprintf+0xc9>
801006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006b5:	e9 69 ff ff ff       	jmp    80100623 <cprintf+0x49>
801006ba:	b8 25 00 00 00       	mov    $0x25,%eax
801006bf:	e8 f0 fd ff ff       	call   801004b4 <consputc>
801006c4:	e9 5a ff ff ff       	jmp    80100623 <cprintf+0x49>
801006c9:	b8 25 00 00 00       	mov    $0x25,%eax
801006ce:	e8 e1 fd ff ff       	call   801004b4 <consputc>
801006d3:	89 d8                	mov    %ebx,%eax
801006d5:	e8 da fd ff ff       	call   801004b4 <consputc>
801006da:	e9 44 ff ff ff       	jmp    80100623 <cprintf+0x49>
801006df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801006e3:	75 08                	jne    801006ed <cprintf+0x113>
801006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e8:	5b                   	pop    %ebx
801006e9:	5e                   	pop    %esi
801006ea:	5f                   	pop    %edi
801006eb:	5d                   	pop    %ebp
801006ec:	c3                   	ret    
801006ed:	83 ec 0c             	sub    $0xc,%esp
801006f0:	68 20 ef 10 80       	push   $0x8010ef20
801006f5:	e8 4c 35 00 00       	call   80103c46 <release>
801006fa:	83 c4 10             	add    $0x10,%esp
801006fd:	eb e6                	jmp    801006e5 <cprintf+0x10b>

801006ff <consoleintr>:
801006ff:	55                   	push   %ebp
80100700:	89 e5                	mov    %esp,%ebp
80100702:	57                   	push   %edi
80100703:	56                   	push   %esi
80100704:	53                   	push   %ebx
80100705:	83 ec 18             	sub    $0x18,%esp
80100708:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010070b:	68 20 ef 10 80       	push   $0x8010ef20
80100710:	e8 cc 34 00 00       	call   80103be1 <acquire>
80100715:	83 c4 10             	add    $0x10,%esp
80100718:	be 00 00 00 00       	mov    $0x0,%esi
8010071d:	eb 13                	jmp    80100732 <consoleintr+0x33>
8010071f:	83 ff 08             	cmp    $0x8,%edi
80100722:	0f 84 d1 00 00 00    	je     801007f9 <consoleintr+0xfa>
80100728:	83 ff 10             	cmp    $0x10,%edi
8010072b:	75 25                	jne    80100752 <consoleintr+0x53>
8010072d:	be 01 00 00 00       	mov    $0x1,%esi
80100732:	ff d3                	call   *%ebx
80100734:	89 c7                	mov    %eax,%edi
80100736:	85 c0                	test   %eax,%eax
80100738:	0f 88 eb 00 00 00    	js     80100829 <consoleintr+0x12a>
8010073e:	83 ff 15             	cmp    $0x15,%edi
80100741:	0f 84 8d 00 00 00    	je     801007d4 <consoleintr+0xd5>
80100747:	7e d6                	jle    8010071f <consoleintr+0x20>
80100749:	83 ff 7f             	cmp    $0x7f,%edi
8010074c:	0f 84 a7 00 00 00    	je     801007f9 <consoleintr+0xfa>
80100752:	85 ff                	test   %edi,%edi
80100754:	74 dc                	je     80100732 <consoleintr+0x33>
80100756:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010075b:	89 c2                	mov    %eax,%edx
8010075d:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100763:	83 fa 7f             	cmp    $0x7f,%edx
80100766:	77 ca                	ja     80100732 <consoleintr+0x33>
80100768:	83 ff 0d             	cmp    $0xd,%edi
8010076b:	0f 84 ae 00 00 00    	je     8010081f <consoleintr+0x120>
80100771:	8d 50 01             	lea    0x1(%eax),%edx
80100774:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
8010077a:	83 e0 7f             	and    $0x7f,%eax
8010077d:	89 f9                	mov    %edi,%ecx
8010077f:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
80100785:	89 f8                	mov    %edi,%eax
80100787:	e8 28 fd ff ff       	call   801004b4 <consputc>
8010078c:	83 ff 0a             	cmp    $0xa,%edi
8010078f:	74 15                	je     801007a6 <consoleintr+0xa7>
80100791:	83 ff 04             	cmp    $0x4,%edi
80100794:	74 10                	je     801007a6 <consoleintr+0xa7>
80100796:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010079b:	83 e8 80             	sub    $0xffffff80,%eax
8010079e:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801007a4:	75 8c                	jne    80100732 <consoleintr+0x33>
801007a6:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007ab:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
801007b0:	83 ec 0c             	sub    $0xc,%esp
801007b3:	68 00 ef 10 80       	push   $0x8010ef00
801007b8:	e8 84 30 00 00       	call   80103841 <wakeup>
801007bd:	83 c4 10             	add    $0x10,%esp
801007c0:	e9 6d ff ff ff       	jmp    80100732 <consoleintr+0x33>
801007c5:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
801007ca:	b8 00 01 00 00       	mov    $0x100,%eax
801007cf:	e8 e0 fc ff ff       	call   801004b4 <consputc>
801007d4:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007d9:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801007df:	0f 84 4d ff ff ff    	je     80100732 <consoleintr+0x33>
801007e5:	48                   	dec    %eax
801007e6:	89 c2                	mov    %eax,%edx
801007e8:	83 e2 7f             	and    $0x7f,%edx
801007eb:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801007f2:	75 d1                	jne    801007c5 <consoleintr+0xc6>
801007f4:	e9 39 ff ff ff       	jmp    80100732 <consoleintr+0x33>
801007f9:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007fe:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100804:	0f 84 28 ff ff ff    	je     80100732 <consoleintr+0x33>
8010080a:	48                   	dec    %eax
8010080b:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
80100810:	b8 00 01 00 00       	mov    $0x100,%eax
80100815:	e8 9a fc ff ff       	call   801004b4 <consputc>
8010081a:	e9 13 ff ff ff       	jmp    80100732 <consoleintr+0x33>
8010081f:	bf 0a 00 00 00       	mov    $0xa,%edi
80100824:	e9 48 ff ff ff       	jmp    80100771 <consoleintr+0x72>
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 20 ef 10 80       	push   $0x8010ef20
80100831:	e8 10 34 00 00       	call   80103c46 <release>
80100836:	83 c4 10             	add    $0x10,%esp
80100839:	85 f6                	test   %esi,%esi
8010083b:	75 08                	jne    80100845 <consoleintr+0x146>
8010083d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100840:	5b                   	pop    %ebx
80100841:	5e                   	pop    %esi
80100842:	5f                   	pop    %edi
80100843:	5d                   	pop    %ebp
80100844:	c3                   	ret    
80100845:	e8 a2 30 00 00       	call   801038ec <procdump>
8010084a:	eb f1                	jmp    8010083d <consoleintr+0x13e>

8010084c <consoleinit>:
8010084c:	55                   	push   %ebp
8010084d:	89 e5                	mov    %esp,%ebp
8010084f:	83 ec 10             	sub    $0x10,%esp
80100852:	68 a8 68 10 80       	push   $0x801068a8
80100857:	68 20 ef 10 80       	push   $0x8010ef20
8010085c:	e8 49 32 00 00       	call   80103aaa <initlock>
80100861:	c7 05 0c f9 10 80 7d 	movl   $0x8010057d,0x8010f90c
80100868:	05 10 80 
8010086b:	c7 05 08 f9 10 80 64 	movl   $0x80100264,0x8010f908
80100872:	02 10 80 
80100875:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
8010087c:	00 00 00 
8010087f:	83 c4 08             	add    $0x8,%esp
80100882:	6a 00                	push   $0x0
80100884:	6a 01                	push   $0x1
80100886:	e8 5a 16 00 00       	call   80101ee5 <ioapicenable>
8010088b:	83 c4 10             	add    $0x10,%esp
8010088e:	c9                   	leave  
8010088f:	c3                   	ret    

80100890 <exec>:
80100890:	55                   	push   %ebp
80100891:	89 e5                	mov    %esp,%ebp
80100893:	57                   	push   %edi
80100894:	56                   	push   %esi
80100895:	53                   	push   %ebx
80100896:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
8010089c:	e8 81 28 00 00       	call   80103122 <myproc>
801008a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
801008a7:	e8 30 1e 00 00       	call   801026dc <begin_op>
801008ac:	83 ec 0c             	sub    $0xc,%esp
801008af:	ff 75 08             	push   0x8(%ebp)
801008b2:	e8 b3 12 00 00       	call   80101b6a <namei>
801008b7:	83 c4 10             	add    $0x10,%esp
801008ba:	85 c0                	test   %eax,%eax
801008bc:	74 56                	je     80100914 <exec+0x84>
801008be:	89 c3                	mov    %eax,%ebx
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	50                   	push   %eax
801008c4:	e8 3d 0c 00 00       	call   80101506 <ilock>
801008c9:	6a 34                	push   $0x34
801008cb:	6a 00                	push   $0x0
801008cd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801008d3:	50                   	push   %eax
801008d4:	53                   	push   %ebx
801008d5:	e8 19 0e 00 00       	call   801016f3 <readi>
801008da:	83 c4 20             	add    $0x20,%esp
801008dd:	83 f8 34             	cmp    $0x34,%eax
801008e0:	75 0c                	jne    801008ee <exec+0x5e>
801008e2:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801008e9:	45 4c 46 
801008ec:	74 42                	je     80100930 <exec+0xa0>
801008ee:	85 db                	test   %ebx,%ebx
801008f0:	0f 84 cc 02 00 00    	je     80100bc2 <exec+0x332>
801008f6:	83 ec 0c             	sub    $0xc,%esp
801008f9:	53                   	push   %ebx
801008fa:	e8 aa 0d 00 00       	call   801016a9 <iunlockput>
801008ff:	e8 54 1e 00 00       	call   80102758 <end_op>
80100904:	83 c4 10             	add    $0x10,%esp
80100907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010090c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010090f:	5b                   	pop    %ebx
80100910:	5e                   	pop    %esi
80100911:	5f                   	pop    %edi
80100912:	5d                   	pop    %ebp
80100913:	c3                   	ret    
80100914:	e8 3f 1e 00 00       	call   80102758 <end_op>
80100919:	83 ec 0c             	sub    $0xc,%esp
8010091c:	68 c1 68 10 80       	push   $0x801068c1
80100921:	e8 b4 fc ff ff       	call   801005da <cprintf>
80100926:	83 c4 10             	add    $0x10,%esp
80100929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010092e:	eb dc                	jmp    8010090c <exec+0x7c>
80100930:	e8 b1 5c 00 00       	call   801065e6 <setupkvm>
80100935:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010093b:	85 c0                	test   %eax,%eax
8010093d:	0f 84 14 01 00 00    	je     80100a57 <exec+0x1c7>
80100943:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100949:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100950:	00 00 00 
80100953:	be 00 00 00 00       	mov    $0x0,%esi
80100958:	eb 04                	jmp    8010095e <exec+0xce>
8010095a:	46                   	inc    %esi
8010095b:	8d 47 20             	lea    0x20(%edi),%eax
8010095e:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100965:	39 f2                	cmp    %esi,%edx
80100967:	0f 8e a1 00 00 00    	jle    80100a0e <exec+0x17e>
8010096d:	89 c7                	mov    %eax,%edi
8010096f:	6a 20                	push   $0x20
80100971:	50                   	push   %eax
80100972:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100978:	50                   	push   %eax
80100979:	53                   	push   %ebx
8010097a:	e8 74 0d 00 00       	call   801016f3 <readi>
8010097f:	83 c4 10             	add    $0x10,%esp
80100982:	83 f8 20             	cmp    $0x20,%eax
80100985:	0f 85 cc 00 00 00    	jne    80100a57 <exec+0x1c7>
8010098b:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100992:	75 c6                	jne    8010095a <exec+0xca>
80100994:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010099a:	85 c0                	test   %eax,%eax
8010099c:	74 bc                	je     8010095a <exec+0xca>
8010099e:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009a4:	0f 82 ad 00 00 00    	jb     80100a57 <exec+0x1c7>
801009aa:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009b0:	0f 82 a1 00 00 00    	jb     80100a57 <exec+0x1c7>
801009b6:	83 ec 04             	sub    $0x4,%esp
801009b9:	50                   	push   %eax
801009ba:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801009c0:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009c6:	e8 b8 5a 00 00       	call   80106483 <allocuvm>
801009cb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009d1:	83 c4 10             	add    $0x10,%esp
801009d4:	85 c0                	test   %eax,%eax
801009d6:	74 7f                	je     80100a57 <exec+0x1c7>
801009d8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801009de:	a9 ff 0f 00 00       	test   $0xfff,%eax
801009e3:	75 72                	jne    80100a57 <exec+0x1c7>
801009e5:	83 ec 0c             	sub    $0xc,%esp
801009e8:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
801009ee:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
801009f4:	53                   	push   %ebx
801009f5:	50                   	push   %eax
801009f6:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009fc:	e8 58 59 00 00       	call   80106359 <loaduvm>
80100a01:	83 c4 20             	add    $0x20,%esp
80100a04:	85 c0                	test   %eax,%eax
80100a06:	0f 89 4e ff ff ff    	jns    8010095a <exec+0xca>
80100a0c:	eb 49                	jmp    80100a57 <exec+0x1c7>
80100a0e:	83 ec 0c             	sub    $0xc,%esp
80100a11:	53                   	push   %ebx
80100a12:	e8 92 0c 00 00       	call   801016a9 <iunlockput>
80100a17:	e8 3c 1d 00 00       	call   80102758 <end_op>
80100a1c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a22:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100a2c:	83 c4 0c             	add    $0xc,%esp
80100a2f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a35:	52                   	push   %edx
80100a36:	50                   	push   %eax
80100a37:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100a3d:	57                   	push   %edi
80100a3e:	e8 40 5a 00 00       	call   80106483 <allocuvm>
80100a43:	89 c6                	mov    %eax,%esi
80100a45:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a4b:	83 c4 10             	add    $0x10,%esp
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	75 26                	jne    80100a78 <exec+0x1e8>
80100a52:	bb 00 00 00 00       	mov    $0x0,%ebx
80100a57:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a5d:	85 c0                	test   %eax,%eax
80100a5f:	0f 84 89 fe ff ff    	je     801008ee <exec+0x5e>
80100a65:	83 ec 08             	sub    $0x8,%esp
80100a68:	6a 01                	push   $0x1
80100a6a:	50                   	push   %eax
80100a6b:	e8 00 5b 00 00       	call   80106570 <freevm>
80100a70:	83 c4 10             	add    $0x10,%esp
80100a73:	e9 76 fe ff ff       	jmp    801008ee <exec+0x5e>
80100a78:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a7e:	83 ec 08             	sub    $0x8,%esp
80100a81:	50                   	push   %eax
80100a82:	57                   	push   %edi
80100a83:	e8 e5 5b 00 00       	call   8010666d <clearpteu>
80100a88:	83 c4 10             	add    $0x10,%esp
80100a8b:	bf 00 00 00 00       	mov    $0x0,%edi
80100a90:	eb 08                	jmp    80100a9a <exec+0x20a>
80100a92:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
80100a99:	47                   	inc    %edi
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100aa0:	8b 03                	mov    (%ebx),%eax
80100aa2:	85 c0                	test   %eax,%eax
80100aa4:	74 43                	je     80100ae9 <exec+0x259>
80100aa6:	83 ff 1f             	cmp    $0x1f,%edi
80100aa9:	0f 87 09 01 00 00    	ja     80100bb8 <exec+0x328>
80100aaf:	83 ec 0c             	sub    $0xc,%esp
80100ab2:	50                   	push   %eax
80100ab3:	e8 7d 33 00 00       	call   80103e35 <strlen>
80100ab8:	29 c6                	sub    %eax,%esi
80100aba:	4e                   	dec    %esi
80100abb:	83 e6 fc             	and    $0xfffffffc,%esi
80100abe:	83 c4 04             	add    $0x4,%esp
80100ac1:	ff 33                	push   (%ebx)
80100ac3:	e8 6d 33 00 00       	call   80103e35 <strlen>
80100ac8:	40                   	inc    %eax
80100ac9:	50                   	push   %eax
80100aca:	ff 33                	push   (%ebx)
80100acc:	56                   	push   %esi
80100acd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ad3:	e8 e5 5c 00 00       	call   801067bd <copyout>
80100ad8:	83 c4 20             	add    $0x20,%esp
80100adb:	85 c0                	test   %eax,%eax
80100add:	79 b3                	jns    80100a92 <exec+0x202>
80100adf:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ae4:	e9 6e ff ff ff       	jmp    80100a57 <exec+0x1c7>
80100ae9:	89 f1                	mov    %esi,%ecx
80100aeb:	89 c3                	mov    %eax,%ebx
80100aed:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100af4:	00 00 00 00 
80100af8:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100aff:	ff ff ff 
80100b02:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
80100b08:	8d 14 bd 04 00 00 00 	lea    0x4(,%edi,4),%edx
80100b0f:	89 f0                	mov    %esi,%eax
80100b11:	29 d0                	sub    %edx,%eax
80100b13:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
80100b19:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b20:	29 c1                	sub    %eax,%ecx
80100b22:	89 ce                	mov    %ecx,%esi
80100b24:	50                   	push   %eax
80100b25:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b2b:	50                   	push   %eax
80100b2c:	51                   	push   %ecx
80100b2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b33:	e8 85 5c 00 00       	call   801067bd <copyout>
80100b38:	83 c4 10             	add    $0x10,%esp
80100b3b:	85 c0                	test   %eax,%eax
80100b3d:	0f 88 14 ff ff ff    	js     80100a57 <exec+0x1c7>
80100b43:	8b 55 08             	mov    0x8(%ebp),%edx
80100b46:	89 d0                	mov    %edx,%eax
80100b48:	eb 01                	jmp    80100b4b <exec+0x2bb>
80100b4a:	40                   	inc    %eax
80100b4b:	8a 08                	mov    (%eax),%cl
80100b4d:	84 c9                	test   %cl,%cl
80100b4f:	74 0a                	je     80100b5b <exec+0x2cb>
80100b51:	80 f9 2f             	cmp    $0x2f,%cl
80100b54:	75 f4                	jne    80100b4a <exec+0x2ba>
80100b56:	8d 50 01             	lea    0x1(%eax),%edx
80100b59:	eb ef                	jmp    80100b4a <exec+0x2ba>
80100b5b:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b61:	89 f8                	mov    %edi,%eax
80100b63:	83 c0 6c             	add    $0x6c,%eax
80100b66:	83 ec 04             	sub    $0x4,%esp
80100b69:	6a 10                	push   $0x10
80100b6b:	52                   	push   %edx
80100b6c:	50                   	push   %eax
80100b6d:	e8 87 32 00 00       	call   80103df9 <safestrcpy>
80100b72:	8b 5f 04             	mov    0x4(%edi),%ebx
80100b75:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100b7b:	89 4f 04             	mov    %ecx,0x4(%edi)
80100b7e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100b84:	89 0f                	mov    %ecx,(%edi)
80100b86:	8b 47 18             	mov    0x18(%edi),%eax
80100b89:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100b8f:	89 50 38             	mov    %edx,0x38(%eax)
80100b92:	8b 47 18             	mov    0x18(%edi),%eax
80100b95:	89 70 44             	mov    %esi,0x44(%eax)
80100b98:	89 3c 24             	mov    %edi,(%esp)
80100b9b:	e8 f5 55 00 00       	call   80106195 <switchuvm>
80100ba0:	83 c4 08             	add    $0x8,%esp
80100ba3:	6a 01                	push   $0x1
80100ba5:	53                   	push   %ebx
80100ba6:	e8 c5 59 00 00       	call   80106570 <freevm>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	b8 00 00 00 00       	mov    $0x0,%eax
80100bb3:	e9 54 fd ff ff       	jmp    8010090c <exec+0x7c>
80100bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bbd:	e9 95 fe ff ff       	jmp    80100a57 <exec+0x1c7>
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 40 fd ff ff       	jmp    8010090c <exec+0x7c>

80100bcc <fileinit>:
80100bcc:	55                   	push   %ebp
80100bcd:	89 e5                	mov    %esp,%ebp
80100bcf:	83 ec 10             	sub    $0x10,%esp
80100bd2:	68 cd 68 10 80       	push   $0x801068cd
80100bd7:	68 60 ef 10 80       	push   $0x8010ef60
80100bdc:	e8 c9 2e 00 00       	call   80103aaa <initlock>
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	c9                   	leave  
80100be5:	c3                   	ret    

80100be6 <filealloc>:
80100be6:	55                   	push   %ebp
80100be7:	89 e5                	mov    %esp,%ebp
80100be9:	53                   	push   %ebx
80100bea:	83 ec 10             	sub    $0x10,%esp
80100bed:	68 60 ef 10 80       	push   $0x8010ef60
80100bf2:	e8 ea 2f 00 00       	call   80103be1 <acquire>
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100bff:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c05:	73 29                	jae    80100c30 <filealloc+0x4a>
80100c07:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c0b:	74 05                	je     80100c12 <filealloc+0x2c>
80100c0d:	83 c3 18             	add    $0x18,%ebx
80100c10:	eb ed                	jmp    80100bff <filealloc+0x19>
80100c12:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100c19:	83 ec 0c             	sub    $0xc,%esp
80100c1c:	68 60 ef 10 80       	push   $0x8010ef60
80100c21:	e8 20 30 00 00       	call   80103c46 <release>
80100c26:	83 c4 10             	add    $0x10,%esp
80100c29:	89 d8                	mov    %ebx,%eax
80100c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c2e:	c9                   	leave  
80100c2f:	c3                   	ret    
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	68 60 ef 10 80       	push   $0x8010ef60
80100c38:	e8 09 30 00 00       	call   80103c46 <release>
80100c3d:	83 c4 10             	add    $0x10,%esp
80100c40:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c45:	eb e2                	jmp    80100c29 <filealloc+0x43>

80100c47 <filedup>:
80100c47:	55                   	push   %ebp
80100c48:	89 e5                	mov    %esp,%ebp
80100c4a:	53                   	push   %ebx
80100c4b:	83 ec 10             	sub    $0x10,%esp
80100c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100c51:	68 60 ef 10 80       	push   $0x8010ef60
80100c56:	e8 86 2f 00 00       	call   80103be1 <acquire>
80100c5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	85 c0                	test   %eax,%eax
80100c63:	7e 18                	jle    80100c7d <filedup+0x36>
80100c65:	40                   	inc    %eax
80100c66:	89 43 04             	mov    %eax,0x4(%ebx)
80100c69:	83 ec 0c             	sub    $0xc,%esp
80100c6c:	68 60 ef 10 80       	push   $0x8010ef60
80100c71:	e8 d0 2f 00 00       	call   80103c46 <release>
80100c76:	89 d8                	mov    %ebx,%eax
80100c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7b:	c9                   	leave  
80100c7c:	c3                   	ret    
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	68 d4 68 10 80       	push   $0x801068d4
80100c85:	e8 b7 f6 ff ff       	call   80100341 <panic>

80100c8a <fileclose>:
80100c8a:	55                   	push   %ebp
80100c8b:	89 e5                	mov    %esp,%ebp
80100c8d:	57                   	push   %edi
80100c8e:	56                   	push   %esi
80100c8f:	53                   	push   %ebx
80100c90:	83 ec 38             	sub    $0x38,%esp
80100c93:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100c96:	68 60 ef 10 80       	push   $0x8010ef60
80100c9b:	e8 41 2f 00 00       	call   80103be1 <acquire>
80100ca0:	8b 43 04             	mov    0x4(%ebx),%eax
80100ca3:	83 c4 10             	add    $0x10,%esp
80100ca6:	85 c0                	test   %eax,%eax
80100ca8:	7e 58                	jle    80100d02 <fileclose+0x78>
80100caa:	48                   	dec    %eax
80100cab:	89 43 04             	mov    %eax,0x4(%ebx)
80100cae:	85 c0                	test   %eax,%eax
80100cb0:	7f 5d                	jg     80100d0f <fileclose+0x85>
80100cb2:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cb5:	b9 06 00 00 00       	mov    $0x6,%ecx
80100cba:	89 de                	mov    %ebx,%esi
80100cbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80100cbe:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
80100cc5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100ccb:	83 ec 0c             	sub    $0xc,%esp
80100cce:	68 60 ef 10 80       	push   $0x8010ef60
80100cd3:	e8 6e 2f 00 00       	call   80103c46 <release>
80100cd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cdb:	83 c4 10             	add    $0x10,%esp
80100cde:	83 f8 01             	cmp    $0x1,%eax
80100ce1:	74 44                	je     80100d27 <fileclose+0x9d>
80100ce3:	83 f8 02             	cmp    $0x2,%eax
80100ce6:	75 37                	jne    80100d1f <fileclose+0x95>
80100ce8:	e8 ef 19 00 00       	call   801026dc <begin_op>
80100ced:	83 ec 0c             	sub    $0xc,%esp
80100cf0:	ff 75 e0             	push   -0x20(%ebp)
80100cf3:	e8 13 09 00 00       	call   8010160b <iput>
80100cf8:	e8 5b 1a 00 00       	call   80102758 <end_op>
80100cfd:	83 c4 10             	add    $0x10,%esp
80100d00:	eb 1d                	jmp    80100d1f <fileclose+0x95>
80100d02:	83 ec 0c             	sub    $0xc,%esp
80100d05:	68 dc 68 10 80       	push   $0x801068dc
80100d0a:	e8 32 f6 ff ff       	call   80100341 <panic>
80100d0f:	83 ec 0c             	sub    $0xc,%esp
80100d12:	68 60 ef 10 80       	push   $0x8010ef60
80100d17:	e8 2a 2f 00 00       	call   80103c46 <release>
80100d1c:	83 c4 10             	add    $0x10,%esp
80100d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d22:	5b                   	pop    %ebx
80100d23:	5e                   	pop    %esi
80100d24:	5f                   	pop    %edi
80100d25:	5d                   	pop    %ebp
80100d26:	c3                   	ret    
80100d27:	83 ec 08             	sub    $0x8,%esp
80100d2a:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d2e:	50                   	push   %eax
80100d2f:	ff 75 dc             	push   -0x24(%ebp)
80100d32:	e8 25 20 00 00       	call   80102d5c <pipeclose>
80100d37:	83 c4 10             	add    $0x10,%esp
80100d3a:	eb e3                	jmp    80100d1f <fileclose+0x95>

80100d3c <filestat>:
80100d3c:	55                   	push   %ebp
80100d3d:	89 e5                	mov    %esp,%ebp
80100d3f:	53                   	push   %ebx
80100d40:	83 ec 04             	sub    $0x4,%esp
80100d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d46:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d49:	75 31                	jne    80100d7c <filestat+0x40>
80100d4b:	83 ec 0c             	sub    $0xc,%esp
80100d4e:	ff 73 10             	push   0x10(%ebx)
80100d51:	e8 b0 07 00 00       	call   80101506 <ilock>
80100d56:	83 c4 08             	add    $0x8,%esp
80100d59:	ff 75 0c             	push   0xc(%ebp)
80100d5c:	ff 73 10             	push   0x10(%ebx)
80100d5f:	e8 65 09 00 00       	call   801016c9 <stati>
80100d64:	83 c4 04             	add    $0x4,%esp
80100d67:	ff 73 10             	push   0x10(%ebx)
80100d6a:	e8 57 08 00 00       	call   801015c6 <iunlock>
80100d6f:	83 c4 10             	add    $0x10,%esp
80100d72:	b8 00 00 00 00       	mov    $0x0,%eax
80100d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
80100d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d81:	eb f4                	jmp    80100d77 <filestat+0x3b>

80100d83 <fileread>:
80100d83:	55                   	push   %ebp
80100d84:	89 e5                	mov    %esp,%ebp
80100d86:	56                   	push   %esi
80100d87:	53                   	push   %ebx
80100d88:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d8b:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100d8f:	74 70                	je     80100e01 <fileread+0x7e>
80100d91:	8b 03                	mov    (%ebx),%eax
80100d93:	83 f8 01             	cmp    $0x1,%eax
80100d96:	74 44                	je     80100ddc <fileread+0x59>
80100d98:	83 f8 02             	cmp    $0x2,%eax
80100d9b:	75 57                	jne    80100df4 <fileread+0x71>
80100d9d:	83 ec 0c             	sub    $0xc,%esp
80100da0:	ff 73 10             	push   0x10(%ebx)
80100da3:	e8 5e 07 00 00       	call   80101506 <ilock>
80100da8:	ff 75 10             	push   0x10(%ebp)
80100dab:	ff 73 14             	push   0x14(%ebx)
80100dae:	ff 75 0c             	push   0xc(%ebp)
80100db1:	ff 73 10             	push   0x10(%ebx)
80100db4:	e8 3a 09 00 00       	call   801016f3 <readi>
80100db9:	89 c6                	mov    %eax,%esi
80100dbb:	83 c4 20             	add    $0x20,%esp
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	7e 03                	jle    80100dc5 <fileread+0x42>
80100dc2:	01 43 14             	add    %eax,0x14(%ebx)
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	ff 73 10             	push   0x10(%ebx)
80100dcb:	e8 f6 07 00 00       	call   801015c6 <iunlock>
80100dd0:	83 c4 10             	add    $0x10,%esp
80100dd3:	89 f0                	mov    %esi,%eax
80100dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100dd8:	5b                   	pop    %ebx
80100dd9:	5e                   	pop    %esi
80100dda:	5d                   	pop    %ebp
80100ddb:	c3                   	ret    
80100ddc:	83 ec 04             	sub    $0x4,%esp
80100ddf:	ff 75 10             	push   0x10(%ebp)
80100de2:	ff 75 0c             	push   0xc(%ebp)
80100de5:	ff 73 0c             	push   0xc(%ebx)
80100de8:	e8 bd 20 00 00       	call   80102eaa <piperead>
80100ded:	89 c6                	mov    %eax,%esi
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	eb df                	jmp    80100dd3 <fileread+0x50>
80100df4:	83 ec 0c             	sub    $0xc,%esp
80100df7:	68 e6 68 10 80       	push   $0x801068e6
80100dfc:	e8 40 f5 ff ff       	call   80100341 <panic>
80100e01:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e06:	eb cb                	jmp    80100dd3 <fileread+0x50>

80100e08 <filewrite>:
80100e08:	55                   	push   %ebp
80100e09:	89 e5                	mov    %esp,%ebp
80100e0b:	57                   	push   %edi
80100e0c:	56                   	push   %esi
80100e0d:	53                   	push   %ebx
80100e0e:	83 ec 1c             	sub    $0x1c,%esp
80100e11:	8b 75 08             	mov    0x8(%ebp),%esi
80100e14:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e18:	0f 84 cc 00 00 00    	je     80100eea <filewrite+0xe2>
80100e1e:	8b 06                	mov    (%esi),%eax
80100e20:	83 f8 01             	cmp    $0x1,%eax
80100e23:	74 10                	je     80100e35 <filewrite+0x2d>
80100e25:	83 f8 02             	cmp    $0x2,%eax
80100e28:	0f 85 af 00 00 00    	jne    80100edd <filewrite+0xd5>
80100e2e:	bf 00 00 00 00       	mov    $0x0,%edi
80100e33:	eb 67                	jmp    80100e9c <filewrite+0x94>
80100e35:	83 ec 04             	sub    $0x4,%esp
80100e38:	ff 75 10             	push   0x10(%ebp)
80100e3b:	ff 75 0c             	push   0xc(%ebp)
80100e3e:	ff 76 0c             	push   0xc(%esi)
80100e41:	e8 a2 1f 00 00       	call   80102de8 <pipewrite>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	e9 82 00 00 00       	jmp    80100ed0 <filewrite+0xc8>
80100e4e:	e8 89 18 00 00       	call   801026dc <begin_op>
80100e53:	83 ec 0c             	sub    $0xc,%esp
80100e56:	ff 76 10             	push   0x10(%esi)
80100e59:	e8 a8 06 00 00       	call   80101506 <ilock>
80100e5e:	ff 75 e4             	push   -0x1c(%ebp)
80100e61:	ff 76 14             	push   0x14(%esi)
80100e64:	89 f8                	mov    %edi,%eax
80100e66:	03 45 0c             	add    0xc(%ebp),%eax
80100e69:	50                   	push   %eax
80100e6a:	ff 76 10             	push   0x10(%esi)
80100e6d:	e8 81 09 00 00       	call   801017f3 <writei>
80100e72:	89 c3                	mov    %eax,%ebx
80100e74:	83 c4 20             	add    $0x20,%esp
80100e77:	85 c0                	test   %eax,%eax
80100e79:	7e 03                	jle    80100e7e <filewrite+0x76>
80100e7b:	01 46 14             	add    %eax,0x14(%esi)
80100e7e:	83 ec 0c             	sub    $0xc,%esp
80100e81:	ff 76 10             	push   0x10(%esi)
80100e84:	e8 3d 07 00 00       	call   801015c6 <iunlock>
80100e89:	e8 ca 18 00 00       	call   80102758 <end_op>
80100e8e:	83 c4 10             	add    $0x10,%esp
80100e91:	85 db                	test   %ebx,%ebx
80100e93:	78 31                	js     80100ec6 <filewrite+0xbe>
80100e95:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100e98:	75 1f                	jne    80100eb9 <filewrite+0xb1>
80100e9a:	01 df                	add    %ebx,%edi
80100e9c:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100e9f:	7d 25                	jge    80100ec6 <filewrite+0xbe>
80100ea1:	8b 45 10             	mov    0x10(%ebp),%eax
80100ea4:	29 f8                	sub    %edi,%eax
80100ea6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ea9:	3d 00 06 00 00       	cmp    $0x600,%eax
80100eae:	7e 9e                	jle    80100e4e <filewrite+0x46>
80100eb0:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100eb7:	eb 95                	jmp    80100e4e <filewrite+0x46>
80100eb9:	83 ec 0c             	sub    $0xc,%esp
80100ebc:	68 ef 68 10 80       	push   $0x801068ef
80100ec1:	e8 7b f4 ff ff       	call   80100341 <panic>
80100ec6:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ec9:	74 0d                	je     80100ed8 <filewrite+0xd0>
80100ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
80100ed7:	c3                   	ret    
80100ed8:	8b 45 10             	mov    0x10(%ebp),%eax
80100edb:	eb f3                	jmp    80100ed0 <filewrite+0xc8>
80100edd:	83 ec 0c             	sub    $0xc,%esp
80100ee0:	68 f5 68 10 80       	push   $0x801068f5
80100ee5:	e8 57 f4 ff ff       	call   80100341 <panic>
80100eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eef:	eb df                	jmp    80100ed0 <filewrite+0xc8>

80100ef1 <skipelem>:
80100ef1:	55                   	push   %ebp
80100ef2:	89 e5                	mov    %esp,%ebp
80100ef4:	57                   	push   %edi
80100ef5:	56                   	push   %esi
80100ef6:	53                   	push   %ebx
80100ef7:	83 ec 0c             	sub    $0xc,%esp
80100efa:	89 d6                	mov    %edx,%esi
80100efc:	eb 01                	jmp    80100eff <skipelem+0xe>
80100efe:	40                   	inc    %eax
80100eff:	8a 10                	mov    (%eax),%dl
80100f01:	80 fa 2f             	cmp    $0x2f,%dl
80100f04:	74 f8                	je     80100efe <skipelem+0xd>
80100f06:	84 d2                	test   %dl,%dl
80100f08:	74 4e                	je     80100f58 <skipelem+0x67>
80100f0a:	89 c3                	mov    %eax,%ebx
80100f0c:	eb 01                	jmp    80100f0f <skipelem+0x1e>
80100f0e:	43                   	inc    %ebx
80100f0f:	8a 13                	mov    (%ebx),%dl
80100f11:	80 fa 2f             	cmp    $0x2f,%dl
80100f14:	74 04                	je     80100f1a <skipelem+0x29>
80100f16:	84 d2                	test   %dl,%dl
80100f18:	75 f4                	jne    80100f0e <skipelem+0x1d>
80100f1a:	89 df                	mov    %ebx,%edi
80100f1c:	29 c7                	sub    %eax,%edi
80100f1e:	83 ff 0d             	cmp    $0xd,%edi
80100f21:	7e 11                	jle    80100f34 <skipelem+0x43>
80100f23:	83 ec 04             	sub    $0x4,%esp
80100f26:	6a 0e                	push   $0xe
80100f28:	50                   	push   %eax
80100f29:	56                   	push   %esi
80100f2a:	e8 dc 2d 00 00       	call   80103d0b <memmove>
80100f2f:	83 c4 10             	add    $0x10,%esp
80100f32:	eb 15                	jmp    80100f49 <skipelem+0x58>
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	57                   	push   %edi
80100f38:	50                   	push   %eax
80100f39:	56                   	push   %esi
80100f3a:	e8 cc 2d 00 00       	call   80103d0b <memmove>
80100f3f:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f43:	83 c4 10             	add    $0x10,%esp
80100f46:	eb 01                	jmp    80100f49 <skipelem+0x58>
80100f48:	43                   	inc    %ebx
80100f49:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100f4c:	74 fa                	je     80100f48 <skipelem+0x57>
80100f4e:	89 d8                	mov    %ebx,%eax
80100f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f53:	5b                   	pop    %ebx
80100f54:	5e                   	pop    %esi
80100f55:	5f                   	pop    %edi
80100f56:	5d                   	pop    %ebp
80100f57:	c3                   	ret    
80100f58:	bb 00 00 00 00       	mov    $0x0,%ebx
80100f5d:	eb ef                	jmp    80100f4e <skipelem+0x5d>

80100f5f <bzero>:
80100f5f:	55                   	push   %ebp
80100f60:	89 e5                	mov    %esp,%ebp
80100f62:	53                   	push   %ebx
80100f63:	83 ec 0c             	sub    $0xc,%esp
80100f66:	52                   	push   %edx
80100f67:	50                   	push   %eax
80100f68:	e8 fd f1 ff ff       	call   8010016a <bread>
80100f6d:	89 c3                	mov    %eax,%ebx
80100f6f:	8d 40 5c             	lea    0x5c(%eax),%eax
80100f72:	83 c4 0c             	add    $0xc,%esp
80100f75:	68 00 02 00 00       	push   $0x200
80100f7a:	6a 00                	push   $0x0
80100f7c:	50                   	push   %eax
80100f7d:	e8 0b 2d 00 00       	call   80103c8d <memset>
80100f82:	89 1c 24             	mov    %ebx,(%esp)
80100f85:	e8 7b 18 00 00       	call   80102805 <log_write>
80100f8a:	89 1c 24             	mov    %ebx,(%esp)
80100f8d:	e8 41 f2 ff ff       	call   801001d3 <brelse>
80100f92:	83 c4 10             	add    $0x10,%esp
80100f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f98:	c9                   	leave  
80100f99:	c3                   	ret    

80100f9a <balloc>:
80100f9a:	55                   	push   %ebp
80100f9b:	89 e5                	mov    %esp,%ebp
80100f9d:	57                   	push   %edi
80100f9e:	56                   	push   %esi
80100f9f:	53                   	push   %ebx
80100fa0:	83 ec 1c             	sub    $0x1c,%esp
80100fa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fa6:	be 00 00 00 00       	mov    $0x0,%esi
80100fab:	eb 5b                	jmp    80101008 <balloc+0x6e>
80100fad:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80100fb3:	eb 61                	jmp    80101016 <balloc+0x7c>
80100fb5:	c1 fa 03             	sar    $0x3,%edx
80100fb8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100fbb:	8a 4c 17 5c          	mov    0x5c(%edi,%edx,1),%cl
80100fbf:	0f b6 f9             	movzbl %cl,%edi
80100fc2:	85 7d e4             	test   %edi,-0x1c(%ebp)
80100fc5:	74 7e                	je     80101045 <balloc+0xab>
80100fc7:	40                   	inc    %eax
80100fc8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80100fcd:	7f 25                	jg     80100ff4 <balloc+0x5a>
80100fcf:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80100fd2:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
80100fd8:	73 1a                	jae    80100ff4 <balloc+0x5a>
80100fda:	89 c1                	mov    %eax,%ecx
80100fdc:	83 e1 07             	and    $0x7,%ecx
80100fdf:	ba 01 00 00 00       	mov    $0x1,%edx
80100fe4:	d3 e2                	shl    %cl,%edx
80100fe6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100fe9:	89 c2                	mov    %eax,%edx
80100feb:	85 c0                	test   %eax,%eax
80100fed:	79 c6                	jns    80100fb5 <balloc+0x1b>
80100fef:	8d 50 07             	lea    0x7(%eax),%edx
80100ff2:	eb c1                	jmp    80100fb5 <balloc+0x1b>
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	ff 75 e0             	push   -0x20(%ebp)
80100ffa:	e8 d4 f1 ff ff       	call   801001d3 <brelse>
80100fff:	81 c6 00 10 00 00    	add    $0x1000,%esi
80101005:	83 c4 10             	add    $0x10,%esp
80101008:	39 35 b4 15 11 80    	cmp    %esi,0x801115b4
8010100e:	76 28                	jbe    80101038 <balloc+0x9e>
80101010:	89 f0                	mov    %esi,%eax
80101012:	85 f6                	test   %esi,%esi
80101014:	78 97                	js     80100fad <balloc+0x13>
80101016:	c1 f8 0c             	sar    $0xc,%eax
80101019:	83 ec 08             	sub    $0x8,%esp
8010101c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101022:	50                   	push   %eax
80101023:	ff 75 dc             	push   -0x24(%ebp)
80101026:	e8 3f f1 ff ff       	call   8010016a <bread>
8010102b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	b8 00 00 00 00       	mov    $0x0,%eax
80101036:	eb 90                	jmp    80100fc8 <balloc+0x2e>
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	68 ff 68 10 80       	push   $0x801068ff
80101040:	e8 fc f2 ff ff       	call   80100341 <panic>
80101045:	0b 4d e4             	or     -0x1c(%ebp),%ecx
80101048:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010104b:	88 4c 16 5c          	mov    %cl,0x5c(%esi,%edx,1)
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	56                   	push   %esi
80101053:	e8 ad 17 00 00       	call   80102805 <log_write>
80101058:	89 34 24             	mov    %esi,(%esp)
8010105b:	e8 73 f1 ff ff       	call   801001d3 <brelse>
80101060:	89 da                	mov    %ebx,%edx
80101062:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101065:	e8 f5 fe ff ff       	call   80100f5f <bzero>
8010106a:	89 d8                	mov    %ebx,%eax
8010106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106f:	5b                   	pop    %ebx
80101070:	5e                   	pop    %esi
80101071:	5f                   	pop    %edi
80101072:	5d                   	pop    %ebp
80101073:	c3                   	ret    

80101074 <bmap>:
80101074:	55                   	push   %ebp
80101075:	89 e5                	mov    %esp,%ebp
80101077:	57                   	push   %edi
80101078:	56                   	push   %esi
80101079:	53                   	push   %ebx
8010107a:	83 ec 1c             	sub    $0x1c,%esp
8010107d:	89 c3                	mov    %eax,%ebx
8010107f:	89 d7                	mov    %edx,%edi
80101081:	83 fa 0b             	cmp    $0xb,%edx
80101084:	76 45                	jbe    801010cb <bmap+0x57>
80101086:	8d 72 f4             	lea    -0xc(%edx),%esi
80101089:	83 fe 7f             	cmp    $0x7f,%esi
8010108c:	77 7f                	ja     8010110d <bmap+0x99>
8010108e:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101094:	85 c0                	test   %eax,%eax
80101096:	74 4a                	je     801010e2 <bmap+0x6e>
80101098:	83 ec 08             	sub    $0x8,%esp
8010109b:	50                   	push   %eax
8010109c:	ff 33                	push   (%ebx)
8010109e:	e8 c7 f0 ff ff       	call   8010016a <bread>
801010a3:	89 c7                	mov    %eax,%edi
801010a5:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801010a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010ac:	8b 30                	mov    (%eax),%esi
801010ae:	83 c4 10             	add    $0x10,%esp
801010b1:	85 f6                	test   %esi,%esi
801010b3:	74 3c                	je     801010f1 <bmap+0x7d>
801010b5:	83 ec 0c             	sub    $0xc,%esp
801010b8:	57                   	push   %edi
801010b9:	e8 15 f1 ff ff       	call   801001d3 <brelse>
801010be:	83 c4 10             	add    $0x10,%esp
801010c1:	89 f0                	mov    %esi,%eax
801010c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801010cf:	85 f6                	test   %esi,%esi
801010d1:	75 ee                	jne    801010c1 <bmap+0x4d>
801010d3:	8b 00                	mov    (%eax),%eax
801010d5:	e8 c0 fe ff ff       	call   80100f9a <balloc>
801010da:	89 c6                	mov    %eax,%esi
801010dc:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
801010e0:	eb df                	jmp    801010c1 <bmap+0x4d>
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	e8 b1 fe ff ff       	call   80100f9a <balloc>
801010e9:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801010ef:	eb a7                	jmp    80101098 <bmap+0x24>
801010f1:	8b 03                	mov    (%ebx),%eax
801010f3:	e8 a2 fe ff ff       	call   80100f9a <balloc>
801010f8:	89 c6                	mov    %eax,%esi
801010fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010fd:	89 30                	mov    %esi,(%eax)
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	57                   	push   %edi
80101103:	e8 fd 16 00 00       	call   80102805 <log_write>
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	eb a8                	jmp    801010b5 <bmap+0x41>
8010110d:	83 ec 0c             	sub    $0xc,%esp
80101110:	68 15 69 10 80       	push   $0x80106915
80101115:	e8 27 f2 ff ff       	call   80100341 <panic>

8010111a <iget>:
8010111a:	55                   	push   %ebp
8010111b:	89 e5                	mov    %esp,%ebp
8010111d:	57                   	push   %edi
8010111e:	56                   	push   %esi
8010111f:	53                   	push   %ebx
80101120:	83 ec 28             	sub    $0x28,%esp
80101123:	89 c7                	mov    %eax,%edi
80101125:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101128:	68 60 f9 10 80       	push   $0x8010f960
8010112d:	e8 af 2a 00 00       	call   80103be1 <acquire>
80101132:	83 c4 10             	add    $0x10,%esp
80101135:	be 00 00 00 00       	mov    $0x0,%esi
8010113a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
8010113f:	eb 0a                	jmp    8010114b <iget+0x31>
80101141:	85 f6                	test   %esi,%esi
80101143:	74 39                	je     8010117e <iget+0x64>
80101145:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010114b:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101151:	73 33                	jae    80101186 <iget+0x6c>
80101153:	8b 43 08             	mov    0x8(%ebx),%eax
80101156:	85 c0                	test   %eax,%eax
80101158:	7e e7                	jle    80101141 <iget+0x27>
8010115a:	39 3b                	cmp    %edi,(%ebx)
8010115c:	75 e3                	jne    80101141 <iget+0x27>
8010115e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101161:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101164:	75 db                	jne    80101141 <iget+0x27>
80101166:	40                   	inc    %eax
80101167:	89 43 08             	mov    %eax,0x8(%ebx)
8010116a:	83 ec 0c             	sub    $0xc,%esp
8010116d:	68 60 f9 10 80       	push   $0x8010f960
80101172:	e8 cf 2a 00 00       	call   80103c46 <release>
80101177:	83 c4 10             	add    $0x10,%esp
8010117a:	89 de                	mov    %ebx,%esi
8010117c:	eb 32                	jmp    801011b0 <iget+0x96>
8010117e:	85 c0                	test   %eax,%eax
80101180:	75 c3                	jne    80101145 <iget+0x2b>
80101182:	89 de                	mov    %ebx,%esi
80101184:	eb bf                	jmp    80101145 <iget+0x2b>
80101186:	85 f6                	test   %esi,%esi
80101188:	74 30                	je     801011ba <iget+0xa0>
8010118a:	89 3e                	mov    %edi,(%esi)
8010118c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010118f:	89 46 04             	mov    %eax,0x4(%esi)
80101192:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
80101199:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 60 f9 10 80       	push   $0x8010f960
801011a8:	e8 99 2a 00 00       	call   80103c46 <release>
801011ad:	83 c4 10             	add    $0x10,%esp
801011b0:	89 f0                	mov    %esi,%eax
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
801011b9:	c3                   	ret    
801011ba:	83 ec 0c             	sub    $0xc,%esp
801011bd:	68 28 69 10 80       	push   $0x80106928
801011c2:	e8 7a f1 ff ff       	call   80100341 <panic>

801011c7 <readsb>:
801011c7:	55                   	push   %ebp
801011c8:	89 e5                	mov    %esp,%ebp
801011ca:	53                   	push   %ebx
801011cb:	83 ec 0c             	sub    $0xc,%esp
801011ce:	6a 01                	push   $0x1
801011d0:	ff 75 08             	push   0x8(%ebp)
801011d3:	e8 92 ef ff ff       	call   8010016a <bread>
801011d8:	89 c3                	mov    %eax,%ebx
801011da:	8d 40 5c             	lea    0x5c(%eax),%eax
801011dd:	83 c4 0c             	add    $0xc,%esp
801011e0:	6a 1c                	push   $0x1c
801011e2:	50                   	push   %eax
801011e3:	ff 75 0c             	push   0xc(%ebp)
801011e6:	e8 20 2b 00 00       	call   80103d0b <memmove>
801011eb:	89 1c 24             	mov    %ebx,(%esp)
801011ee:	e8 e0 ef ff ff       	call   801001d3 <brelse>
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011f9:	c9                   	leave  
801011fa:	c3                   	ret    

801011fb <bfree>:
801011fb:	55                   	push   %ebp
801011fc:	89 e5                	mov    %esp,%ebp
801011fe:	56                   	push   %esi
801011ff:	53                   	push   %ebx
80101200:	89 c3                	mov    %eax,%ebx
80101202:	89 d6                	mov    %edx,%esi
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	68 b4 15 11 80       	push   $0x801115b4
8010120c:	50                   	push   %eax
8010120d:	e8 b5 ff ff ff       	call   801011c7 <readsb>
80101212:	89 f0                	mov    %esi,%eax
80101214:	c1 e8 0c             	shr    $0xc,%eax
80101217:	83 c4 08             	add    $0x8,%esp
8010121a:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101220:	50                   	push   %eax
80101221:	53                   	push   %ebx
80101222:	e8 43 ef ff ff       	call   8010016a <bread>
80101227:	89 c3                	mov    %eax,%ebx
80101229:	89 f2                	mov    %esi,%edx
8010122b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80101231:	89 f1                	mov    %esi,%ecx
80101233:	83 e1 07             	and    $0x7,%ecx
80101236:	b8 01 00 00 00       	mov    $0x1,%eax
8010123b:	d3 e0                	shl    %cl,%eax
8010123d:	83 c4 10             	add    $0x10,%esp
80101240:	c1 fa 03             	sar    $0x3,%edx
80101243:	8a 4c 13 5c          	mov    0x5c(%ebx,%edx,1),%cl
80101247:	0f b6 f1             	movzbl %cl,%esi
8010124a:	85 c6                	test   %eax,%esi
8010124c:	74 23                	je     80101271 <bfree+0x76>
8010124e:	f7 d0                	not    %eax
80101250:	21 c8                	and    %ecx,%eax
80101252:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
80101256:	83 ec 0c             	sub    $0xc,%esp
80101259:	53                   	push   %ebx
8010125a:	e8 a6 15 00 00       	call   80102805 <log_write>
8010125f:	89 1c 24             	mov    %ebx,(%esp)
80101262:	e8 6c ef ff ff       	call   801001d3 <brelse>
80101267:	83 c4 10             	add    $0x10,%esp
8010126a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010126d:	5b                   	pop    %ebx
8010126e:	5e                   	pop    %esi
8010126f:	5d                   	pop    %ebp
80101270:	c3                   	ret    
80101271:	83 ec 0c             	sub    $0xc,%esp
80101274:	68 38 69 10 80       	push   $0x80106938
80101279:	e8 c3 f0 ff ff       	call   80100341 <panic>

8010127e <iinit>:
8010127e:	55                   	push   %ebp
8010127f:	89 e5                	mov    %esp,%ebp
80101281:	53                   	push   %ebx
80101282:	83 ec 0c             	sub    $0xc,%esp
80101285:	68 4b 69 10 80       	push   $0x8010694b
8010128a:	68 60 f9 10 80       	push   $0x8010f960
8010128f:	e8 16 28 00 00       	call   80103aaa <initlock>
80101294:	83 c4 10             	add    $0x10,%esp
80101297:	bb 00 00 00 00       	mov    $0x0,%ebx
8010129c:	eb 1f                	jmp    801012bd <iinit+0x3f>
8010129e:	83 ec 08             	sub    $0x8,%esp
801012a1:	68 52 69 10 80       	push   $0x80106952
801012a6:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
801012a9:	89 d0                	mov    %edx,%eax
801012ab:	c1 e0 04             	shl    $0x4,%eax
801012ae:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
801012b3:	50                   	push   %eax
801012b4:	e8 e6 26 00 00       	call   8010399f <initsleeplock>
801012b9:	43                   	inc    %ebx
801012ba:	83 c4 10             	add    $0x10,%esp
801012bd:	83 fb 31             	cmp    $0x31,%ebx
801012c0:	7e dc                	jle    8010129e <iinit+0x20>
801012c2:	83 ec 08             	sub    $0x8,%esp
801012c5:	68 b4 15 11 80       	push   $0x801115b4
801012ca:	ff 75 08             	push   0x8(%ebp)
801012cd:	e8 f5 fe ff ff       	call   801011c7 <readsb>
801012d2:	ff 35 cc 15 11 80    	push   0x801115cc
801012d8:	ff 35 c8 15 11 80    	push   0x801115c8
801012de:	ff 35 c4 15 11 80    	push   0x801115c4
801012e4:	ff 35 c0 15 11 80    	push   0x801115c0
801012ea:	ff 35 bc 15 11 80    	push   0x801115bc
801012f0:	ff 35 b8 15 11 80    	push   0x801115b8
801012f6:	ff 35 b4 15 11 80    	push   0x801115b4
801012fc:	68 b8 69 10 80       	push   $0x801069b8
80101301:	e8 d4 f2 ff ff       	call   801005da <cprintf>
80101306:	83 c4 30             	add    $0x30,%esp
80101309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010130c:	c9                   	leave  
8010130d:	c3                   	ret    

8010130e <ialloc>:
8010130e:	55                   	push   %ebp
8010130f:	89 e5                	mov    %esp,%ebp
80101311:	57                   	push   %edi
80101312:	56                   	push   %esi
80101313:	53                   	push   %ebx
80101314:	83 ec 1c             	sub    $0x1c,%esp
80101317:	8b 45 0c             	mov    0xc(%ebp),%eax
8010131a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010131d:	bb 01 00 00 00       	mov    $0x1,%ebx
80101322:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101325:	39 1d bc 15 11 80    	cmp    %ebx,0x801115bc
8010132b:	76 3d                	jbe    8010136a <ialloc+0x5c>
8010132d:	89 d8                	mov    %ebx,%eax
8010132f:	c1 e8 03             	shr    $0x3,%eax
80101332:	83 ec 08             	sub    $0x8,%esp
80101335:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010133b:	50                   	push   %eax
8010133c:	ff 75 08             	push   0x8(%ebp)
8010133f:	e8 26 ee ff ff       	call   8010016a <bread>
80101344:	89 c6                	mov    %eax,%esi
80101346:	89 d8                	mov    %ebx,%eax
80101348:	83 e0 07             	and    $0x7,%eax
8010134b:	c1 e0 06             	shl    $0x6,%eax
8010134e:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	66 83 3f 00          	cmpw   $0x0,(%edi)
80101359:	74 1c                	je     80101377 <ialloc+0x69>
8010135b:	83 ec 0c             	sub    $0xc,%esp
8010135e:	56                   	push   %esi
8010135f:	e8 6f ee ff ff       	call   801001d3 <brelse>
80101364:	43                   	inc    %ebx
80101365:	83 c4 10             	add    $0x10,%esp
80101368:	eb b8                	jmp    80101322 <ialloc+0x14>
8010136a:	83 ec 0c             	sub    $0xc,%esp
8010136d:	68 58 69 10 80       	push   $0x80106958
80101372:	e8 ca ef ff ff       	call   80100341 <panic>
80101377:	83 ec 04             	sub    $0x4,%esp
8010137a:	6a 40                	push   $0x40
8010137c:	6a 00                	push   $0x0
8010137e:	57                   	push   %edi
8010137f:	e8 09 29 00 00       	call   80103c8d <memset>
80101384:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101387:	66 89 07             	mov    %ax,(%edi)
8010138a:	89 34 24             	mov    %esi,(%esp)
8010138d:	e8 73 14 00 00       	call   80102805 <log_write>
80101392:	89 34 24             	mov    %esi,(%esp)
80101395:	e8 39 ee ff ff       	call   801001d3 <brelse>
8010139a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010139d:	8b 45 08             	mov    0x8(%ebp),%eax
801013a0:	e8 75 fd ff ff       	call   8010111a <iget>
801013a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a8:	5b                   	pop    %ebx
801013a9:	5e                   	pop    %esi
801013aa:	5f                   	pop    %edi
801013ab:	5d                   	pop    %ebp
801013ac:	c3                   	ret    

801013ad <iupdate>:
801013ad:	55                   	push   %ebp
801013ae:	89 e5                	mov    %esp,%ebp
801013b0:	56                   	push   %esi
801013b1:	53                   	push   %ebx
801013b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013b5:	8b 43 04             	mov    0x4(%ebx),%eax
801013b8:	c1 e8 03             	shr    $0x3,%eax
801013bb:	83 ec 08             	sub    $0x8,%esp
801013be:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801013c4:	50                   	push   %eax
801013c5:	ff 33                	push   (%ebx)
801013c7:	e8 9e ed ff ff       	call   8010016a <bread>
801013cc:	89 c6                	mov    %eax,%esi
801013ce:	8b 43 04             	mov    0x4(%ebx),%eax
801013d1:	83 e0 07             	and    $0x7,%eax
801013d4:	c1 e0 06             	shl    $0x6,%eax
801013d7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
801013db:	8b 53 50             	mov    0x50(%ebx),%edx
801013de:	66 89 10             	mov    %dx,(%eax)
801013e1:	66 8b 53 52          	mov    0x52(%ebx),%dx
801013e5:	66 89 50 02          	mov    %dx,0x2(%eax)
801013e9:	8b 53 54             	mov    0x54(%ebx),%edx
801013ec:	66 89 50 04          	mov    %dx,0x4(%eax)
801013f0:	66 8b 53 56          	mov    0x56(%ebx),%dx
801013f4:	66 89 50 06          	mov    %dx,0x6(%eax)
801013f8:	8b 53 58             	mov    0x58(%ebx),%edx
801013fb:	89 50 08             	mov    %edx,0x8(%eax)
801013fe:	83 c3 5c             	add    $0x5c,%ebx
80101401:	83 c0 0c             	add    $0xc,%eax
80101404:	83 c4 0c             	add    $0xc,%esp
80101407:	6a 34                	push   $0x34
80101409:	53                   	push   %ebx
8010140a:	50                   	push   %eax
8010140b:	e8 fb 28 00 00       	call   80103d0b <memmove>
80101410:	89 34 24             	mov    %esi,(%esp)
80101413:	e8 ed 13 00 00       	call   80102805 <log_write>
80101418:	89 34 24             	mov    %esi,(%esp)
8010141b:	e8 b3 ed ff ff       	call   801001d3 <brelse>
80101420:	83 c4 10             	add    $0x10,%esp
80101423:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101426:	5b                   	pop    %ebx
80101427:	5e                   	pop    %esi
80101428:	5d                   	pop    %ebp
80101429:	c3                   	ret    

8010142a <itrunc>:
8010142a:	55                   	push   %ebp
8010142b:	89 e5                	mov    %esp,%ebp
8010142d:	57                   	push   %edi
8010142e:	56                   	push   %esi
8010142f:	53                   	push   %ebx
80101430:	83 ec 1c             	sub    $0x1c,%esp
80101433:	89 c6                	mov    %eax,%esi
80101435:	bb 00 00 00 00       	mov    $0x0,%ebx
8010143a:	eb 01                	jmp    8010143d <itrunc+0x13>
8010143c:	43                   	inc    %ebx
8010143d:	83 fb 0b             	cmp    $0xb,%ebx
80101440:	7f 19                	jg     8010145b <itrunc+0x31>
80101442:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101446:	85 d2                	test   %edx,%edx
80101448:	74 f2                	je     8010143c <itrunc+0x12>
8010144a:	8b 06                	mov    (%esi),%eax
8010144c:	e8 aa fd ff ff       	call   801011fb <bfree>
80101451:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101458:	00 
80101459:	eb e1                	jmp    8010143c <itrunc+0x12>
8010145b:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101461:	85 c0                	test   %eax,%eax
80101463:	75 1b                	jne    80101480 <itrunc+0x56>
80101465:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
8010146c:	83 ec 0c             	sub    $0xc,%esp
8010146f:	56                   	push   %esi
80101470:	e8 38 ff ff ff       	call   801013ad <iupdate>
80101475:	83 c4 10             	add    $0x10,%esp
80101478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147b:	5b                   	pop    %ebx
8010147c:	5e                   	pop    %esi
8010147d:	5f                   	pop    %edi
8010147e:	5d                   	pop    %ebp
8010147f:	c3                   	ret    
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	50                   	push   %eax
80101484:	ff 36                	push   (%esi)
80101486:	e8 df ec ff ff       	call   8010016a <bread>
8010148b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010148e:	8d 78 5c             	lea    0x5c(%eax),%edi
80101491:	83 c4 10             	add    $0x10,%esp
80101494:	bb 00 00 00 00       	mov    $0x0,%ebx
80101499:	eb 01                	jmp    8010149c <itrunc+0x72>
8010149b:	43                   	inc    %ebx
8010149c:	83 fb 7f             	cmp    $0x7f,%ebx
8010149f:	77 10                	ja     801014b1 <itrunc+0x87>
801014a1:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
801014a4:	85 d2                	test   %edx,%edx
801014a6:	74 f3                	je     8010149b <itrunc+0x71>
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 4c fd ff ff       	call   801011fb <bfree>
801014af:	eb ea                	jmp    8010149b <itrunc+0x71>
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	ff 75 e4             	push   -0x1c(%ebp)
801014b7:	e8 17 ed ff ff       	call   801001d3 <brelse>
801014bc:	8b 06                	mov    (%esi),%eax
801014be:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801014c4:	e8 32 fd ff ff       	call   801011fb <bfree>
801014c9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801014d0:	00 00 00 
801014d3:	83 c4 10             	add    $0x10,%esp
801014d6:	eb 8d                	jmp    80101465 <itrunc+0x3b>

801014d8 <idup>:
801014d8:	55                   	push   %ebp
801014d9:	89 e5                	mov    %esp,%ebp
801014db:	53                   	push   %ebx
801014dc:	83 ec 10             	sub    $0x10,%esp
801014df:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014e2:	68 60 f9 10 80       	push   $0x8010f960
801014e7:	e8 f5 26 00 00       	call   80103be1 <acquire>
801014ec:	8b 43 08             	mov    0x8(%ebx),%eax
801014ef:	40                   	inc    %eax
801014f0:	89 43 08             	mov    %eax,0x8(%ebx)
801014f3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801014fa:	e8 47 27 00 00       	call   80103c46 <release>
801014ff:	89 d8                	mov    %ebx,%eax
80101501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101504:	c9                   	leave  
80101505:	c3                   	ret    

80101506 <ilock>:
80101506:	55                   	push   %ebp
80101507:	89 e5                	mov    %esp,%ebp
80101509:	56                   	push   %esi
8010150a:	53                   	push   %ebx
8010150b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010150e:	85 db                	test   %ebx,%ebx
80101510:	74 22                	je     80101534 <ilock+0x2e>
80101512:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101516:	7e 1c                	jle    80101534 <ilock+0x2e>
80101518:	83 ec 0c             	sub    $0xc,%esp
8010151b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010151e:	50                   	push   %eax
8010151f:	e8 ae 24 00 00       	call   801039d2 <acquiresleep>
80101524:	83 c4 10             	add    $0x10,%esp
80101527:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010152b:	74 14                	je     80101541 <ilock+0x3b>
8010152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101530:	5b                   	pop    %ebx
80101531:	5e                   	pop    %esi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
80101534:	83 ec 0c             	sub    $0xc,%esp
80101537:	68 6a 69 10 80       	push   $0x8010696a
8010153c:	e8 00 ee ff ff       	call   80100341 <panic>
80101541:	8b 43 04             	mov    0x4(%ebx),%eax
80101544:	c1 e8 03             	shr    $0x3,%eax
80101547:	83 ec 08             	sub    $0x8,%esp
8010154a:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101550:	50                   	push   %eax
80101551:	ff 33                	push   (%ebx)
80101553:	e8 12 ec ff ff       	call   8010016a <bread>
80101558:	89 c6                	mov    %eax,%esi
8010155a:	8b 43 04             	mov    0x4(%ebx),%eax
8010155d:	83 e0 07             	and    $0x7,%eax
80101560:	c1 e0 06             	shl    $0x6,%eax
80101563:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101567:	8b 10                	mov    (%eax),%edx
80101569:	66 89 53 50          	mov    %dx,0x50(%ebx)
8010156d:	66 8b 50 02          	mov    0x2(%eax),%dx
80101571:	66 89 53 52          	mov    %dx,0x52(%ebx)
80101575:	8b 50 04             	mov    0x4(%eax),%edx
80101578:	66 89 53 54          	mov    %dx,0x54(%ebx)
8010157c:	66 8b 50 06          	mov    0x6(%eax),%dx
80101580:	66 89 53 56          	mov    %dx,0x56(%ebx)
80101584:	8b 50 08             	mov    0x8(%eax),%edx
80101587:	89 53 58             	mov    %edx,0x58(%ebx)
8010158a:	83 c0 0c             	add    $0xc,%eax
8010158d:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101590:	83 c4 0c             	add    $0xc,%esp
80101593:	6a 34                	push   $0x34
80101595:	50                   	push   %eax
80101596:	52                   	push   %edx
80101597:	e8 6f 27 00 00       	call   80103d0b <memmove>
8010159c:	89 34 24             	mov    %esi,(%esp)
8010159f:	e8 2f ec ff ff       	call   801001d3 <brelse>
801015a4:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
801015ab:	83 c4 10             	add    $0x10,%esp
801015ae:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015b3:	0f 85 74 ff ff ff    	jne    8010152d <ilock+0x27>
801015b9:	83 ec 0c             	sub    $0xc,%esp
801015bc:	68 70 69 10 80       	push   $0x80106970
801015c1:	e8 7b ed ff ff       	call   80100341 <panic>

801015c6 <iunlock>:
801015c6:	55                   	push   %ebp
801015c7:	89 e5                	mov    %esp,%ebp
801015c9:	56                   	push   %esi
801015ca:	53                   	push   %ebx
801015cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015ce:	85 db                	test   %ebx,%ebx
801015d0:	74 2c                	je     801015fe <iunlock+0x38>
801015d2:	8d 73 0c             	lea    0xc(%ebx),%esi
801015d5:	83 ec 0c             	sub    $0xc,%esp
801015d8:	56                   	push   %esi
801015d9:	e8 7e 24 00 00       	call   80103a5c <holdingsleep>
801015de:	83 c4 10             	add    $0x10,%esp
801015e1:	85 c0                	test   %eax,%eax
801015e3:	74 19                	je     801015fe <iunlock+0x38>
801015e5:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015e9:	7e 13                	jle    801015fe <iunlock+0x38>
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	56                   	push   %esi
801015ef:	e8 2d 24 00 00       	call   80103a21 <releasesleep>
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015fa:	5b                   	pop    %ebx
801015fb:	5e                   	pop    %esi
801015fc:	5d                   	pop    %ebp
801015fd:	c3                   	ret    
801015fe:	83 ec 0c             	sub    $0xc,%esp
80101601:	68 7f 69 10 80       	push   $0x8010697f
80101606:	e8 36 ed ff ff       	call   80100341 <panic>

8010160b <iput>:
8010160b:	55                   	push   %ebp
8010160c:	89 e5                	mov    %esp,%ebp
8010160e:	57                   	push   %edi
8010160f:	56                   	push   %esi
80101610:	53                   	push   %ebx
80101611:	83 ec 18             	sub    $0x18,%esp
80101614:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101617:	8d 73 0c             	lea    0xc(%ebx),%esi
8010161a:	56                   	push   %esi
8010161b:	e8 b2 23 00 00       	call   801039d2 <acquiresleep>
80101620:	83 c4 10             	add    $0x10,%esp
80101623:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101627:	74 07                	je     80101630 <iput+0x25>
80101629:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010162e:	74 33                	je     80101663 <iput+0x58>
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	56                   	push   %esi
80101634:	e8 e8 23 00 00       	call   80103a21 <releasesleep>
80101639:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101640:	e8 9c 25 00 00       	call   80103be1 <acquire>
80101645:	8b 43 08             	mov    0x8(%ebx),%eax
80101648:	48                   	dec    %eax
80101649:	89 43 08             	mov    %eax,0x8(%ebx)
8010164c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101653:	e8 ee 25 00 00       	call   80103c46 <release>
80101658:	83 c4 10             	add    $0x10,%esp
8010165b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165e:	5b                   	pop    %ebx
8010165f:	5e                   	pop    %esi
80101660:	5f                   	pop    %edi
80101661:	5d                   	pop    %ebp
80101662:	c3                   	ret    
80101663:	83 ec 0c             	sub    $0xc,%esp
80101666:	68 60 f9 10 80       	push   $0x8010f960
8010166b:	e8 71 25 00 00       	call   80103be1 <acquire>
80101670:	8b 7b 08             	mov    0x8(%ebx),%edi
80101673:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010167a:	e8 c7 25 00 00       	call   80103c46 <release>
8010167f:	83 c4 10             	add    $0x10,%esp
80101682:	83 ff 01             	cmp    $0x1,%edi
80101685:	75 a9                	jne    80101630 <iput+0x25>
80101687:	89 d8                	mov    %ebx,%eax
80101689:	e8 9c fd ff ff       	call   8010142a <itrunc>
8010168e:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
80101694:	83 ec 0c             	sub    $0xc,%esp
80101697:	53                   	push   %ebx
80101698:	e8 10 fd ff ff       	call   801013ad <iupdate>
8010169d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	eb 87                	jmp    80101630 <iput+0x25>

801016a9 <iunlockput>:
801016a9:	55                   	push   %ebp
801016aa:	89 e5                	mov    %esp,%ebp
801016ac:	53                   	push   %ebx
801016ad:	83 ec 10             	sub    $0x10,%esp
801016b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016b3:	53                   	push   %ebx
801016b4:	e8 0d ff ff ff       	call   801015c6 <iunlock>
801016b9:	89 1c 24             	mov    %ebx,(%esp)
801016bc:	e8 4a ff ff ff       	call   8010160b <iput>
801016c1:	83 c4 10             	add    $0x10,%esp
801016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016c7:	c9                   	leave  
801016c8:	c3                   	ret    

801016c9 <stati>:
801016c9:	55                   	push   %ebp
801016ca:	89 e5                	mov    %esp,%ebp
801016cc:	8b 55 08             	mov    0x8(%ebp),%edx
801016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801016d2:	8b 0a                	mov    (%edx),%ecx
801016d4:	89 48 04             	mov    %ecx,0x4(%eax)
801016d7:	8b 4a 04             	mov    0x4(%edx),%ecx
801016da:	89 48 08             	mov    %ecx,0x8(%eax)
801016dd:	8b 4a 50             	mov    0x50(%edx),%ecx
801016e0:	66 89 08             	mov    %cx,(%eax)
801016e3:	66 8b 4a 56          	mov    0x56(%edx),%cx
801016e7:	66 89 48 0c          	mov    %cx,0xc(%eax)
801016eb:	8b 52 58             	mov    0x58(%edx),%edx
801016ee:	89 50 10             	mov    %edx,0x10(%eax)
801016f1:	5d                   	pop    %ebp
801016f2:	c3                   	ret    

801016f3 <readi>:
801016f3:	55                   	push   %ebp
801016f4:	89 e5                	mov    %esp,%ebp
801016f6:	57                   	push   %edi
801016f7:	56                   	push   %esi
801016f8:	53                   	push   %ebx
801016f9:	83 ec 0c             	sub    $0xc,%esp
801016fc:	8b 45 08             	mov    0x8(%ebp),%eax
801016ff:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101704:	74 2c                	je     80101732 <readi+0x3f>
80101706:	8b 45 08             	mov    0x8(%ebp),%eax
80101709:	8b 40 58             	mov    0x58(%eax),%eax
8010170c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010170f:	0f 82 d0 00 00 00    	jb     801017e5 <readi+0xf2>
80101715:	8b 55 10             	mov    0x10(%ebp),%edx
80101718:	03 55 14             	add    0x14(%ebp),%edx
8010171b:	0f 82 cb 00 00 00    	jb     801017ec <readi+0xf9>
80101721:	39 d0                	cmp    %edx,%eax
80101723:	73 06                	jae    8010172b <readi+0x38>
80101725:	2b 45 10             	sub    0x10(%ebp),%eax
80101728:	89 45 14             	mov    %eax,0x14(%ebp)
8010172b:	bf 00 00 00 00       	mov    $0x0,%edi
80101730:	eb 55                	jmp    80101787 <readi+0x94>
80101732:	66 8b 40 52          	mov    0x52(%eax),%ax
80101736:	66 83 f8 09          	cmp    $0x9,%ax
8010173a:	0f 87 97 00 00 00    	ja     801017d7 <readi+0xe4>
80101740:	98                   	cwtl   
80101741:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101748:	85 c0                	test   %eax,%eax
8010174a:	0f 84 8e 00 00 00    	je     801017de <readi+0xeb>
80101750:	83 ec 04             	sub    $0x4,%esp
80101753:	ff 75 14             	push   0x14(%ebp)
80101756:	ff 75 0c             	push   0xc(%ebp)
80101759:	ff 75 08             	push   0x8(%ebp)
8010175c:	ff d0                	call   *%eax
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	eb 6c                	jmp    801017cf <readi+0xdc>
80101763:	83 ec 04             	sub    $0x4,%esp
80101766:	53                   	push   %ebx
80101767:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
8010176b:	50                   	push   %eax
8010176c:	ff 75 0c             	push   0xc(%ebp)
8010176f:	e8 97 25 00 00       	call   80103d0b <memmove>
80101774:	89 34 24             	mov    %esi,(%esp)
80101777:	e8 57 ea ff ff       	call   801001d3 <brelse>
8010177c:	01 df                	add    %ebx,%edi
8010177e:	01 5d 10             	add    %ebx,0x10(%ebp)
80101781:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101784:	83 c4 10             	add    $0x10,%esp
80101787:	39 7d 14             	cmp    %edi,0x14(%ebp)
8010178a:	76 40                	jbe    801017cc <readi+0xd9>
8010178c:	8b 55 10             	mov    0x10(%ebp),%edx
8010178f:	c1 ea 09             	shr    $0x9,%edx
80101792:	8b 45 08             	mov    0x8(%ebp),%eax
80101795:	e8 da f8 ff ff       	call   80101074 <bmap>
8010179a:	83 ec 08             	sub    $0x8,%esp
8010179d:	50                   	push   %eax
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	ff 30                	push   (%eax)
801017a3:	e8 c2 e9 ff ff       	call   8010016a <bread>
801017a8:	89 c6                	mov    %eax,%esi
801017aa:	8b 55 10             	mov    0x10(%ebp),%edx
801017ad:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801017b3:	b8 00 02 00 00       	mov    $0x200,%eax
801017b8:	29 d0                	sub    %edx,%eax
801017ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
801017bd:	29 f9                	sub    %edi,%ecx
801017bf:	89 c3                	mov    %eax,%ebx
801017c1:	83 c4 10             	add    $0x10,%esp
801017c4:	39 c8                	cmp    %ecx,%eax
801017c6:	76 9b                	jbe    80101763 <readi+0x70>
801017c8:	89 cb                	mov    %ecx,%ebx
801017ca:	eb 97                	jmp    80101763 <readi+0x70>
801017cc:	8b 45 14             	mov    0x14(%ebp),%eax
801017cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d2:	5b                   	pop    %ebx
801017d3:	5e                   	pop    %esi
801017d4:	5f                   	pop    %edi
801017d5:	5d                   	pop    %ebp
801017d6:	c3                   	ret    
801017d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017dc:	eb f1                	jmp    801017cf <readi+0xdc>
801017de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017e3:	eb ea                	jmp    801017cf <readi+0xdc>
801017e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017ea:	eb e3                	jmp    801017cf <readi+0xdc>
801017ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017f1:	eb dc                	jmp    801017cf <readi+0xdc>

801017f3 <writei>:
801017f3:	55                   	push   %ebp
801017f4:	89 e5                	mov    %esp,%ebp
801017f6:	57                   	push   %edi
801017f7:	56                   	push   %esi
801017f8:	53                   	push   %ebx
801017f9:	83 ec 0c             	sub    $0xc,%esp
801017fc:	8b 45 08             	mov    0x8(%ebp),%eax
801017ff:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101804:	74 2c                	je     80101832 <writei+0x3f>
80101806:	8b 45 08             	mov    0x8(%ebp),%eax
80101809:	8b 7d 10             	mov    0x10(%ebp),%edi
8010180c:	39 78 58             	cmp    %edi,0x58(%eax)
8010180f:	0f 82 fd 00 00 00    	jb     80101912 <writei+0x11f>
80101815:	89 f8                	mov    %edi,%eax
80101817:	03 45 14             	add    0x14(%ebp),%eax
8010181a:	0f 82 f9 00 00 00    	jb     80101919 <writei+0x126>
80101820:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101825:	0f 87 f5 00 00 00    	ja     80101920 <writei+0x12d>
8010182b:	bf 00 00 00 00       	mov    $0x0,%edi
80101830:	eb 60                	jmp    80101892 <writei+0x9f>
80101832:	66 8b 40 52          	mov    0x52(%eax),%ax
80101836:	66 83 f8 09          	cmp    $0x9,%ax
8010183a:	0f 87 c4 00 00 00    	ja     80101904 <writei+0x111>
80101840:	98                   	cwtl   
80101841:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101848:	85 c0                	test   %eax,%eax
8010184a:	0f 84 bb 00 00 00    	je     8010190b <writei+0x118>
80101850:	83 ec 04             	sub    $0x4,%esp
80101853:	ff 75 14             	push   0x14(%ebp)
80101856:	ff 75 0c             	push   0xc(%ebp)
80101859:	ff 75 08             	push   0x8(%ebp)
8010185c:	ff d0                	call   *%eax
8010185e:	83 c4 10             	add    $0x10,%esp
80101861:	e9 85 00 00 00       	jmp    801018eb <writei+0xf8>
80101866:	83 ec 04             	sub    $0x4,%esp
80101869:	56                   	push   %esi
8010186a:	ff 75 0c             	push   0xc(%ebp)
8010186d:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
80101871:	50                   	push   %eax
80101872:	e8 94 24 00 00       	call   80103d0b <memmove>
80101877:	89 1c 24             	mov    %ebx,(%esp)
8010187a:	e8 86 0f 00 00       	call   80102805 <log_write>
8010187f:	89 1c 24             	mov    %ebx,(%esp)
80101882:	e8 4c e9 ff ff       	call   801001d3 <brelse>
80101887:	01 f7                	add    %esi,%edi
80101889:	01 75 10             	add    %esi,0x10(%ebp)
8010188c:	01 75 0c             	add    %esi,0xc(%ebp)
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101895:	73 40                	jae    801018d7 <writei+0xe4>
80101897:	8b 55 10             	mov    0x10(%ebp),%edx
8010189a:	c1 ea 09             	shr    $0x9,%edx
8010189d:	8b 45 08             	mov    0x8(%ebp),%eax
801018a0:	e8 cf f7 ff ff       	call   80101074 <bmap>
801018a5:	83 ec 08             	sub    $0x8,%esp
801018a8:	50                   	push   %eax
801018a9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ac:	ff 30                	push   (%eax)
801018ae:	e8 b7 e8 ff ff       	call   8010016a <bread>
801018b3:	89 c3                	mov    %eax,%ebx
801018b5:	8b 55 10             	mov    0x10(%ebp),%edx
801018b8:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801018be:	b8 00 02 00 00       	mov    $0x200,%eax
801018c3:	29 d0                	sub    %edx,%eax
801018c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
801018c8:	29 f9                	sub    %edi,%ecx
801018ca:	89 c6                	mov    %eax,%esi
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	39 c8                	cmp    %ecx,%eax
801018d1:	76 93                	jbe    80101866 <writei+0x73>
801018d3:	89 ce                	mov    %ecx,%esi
801018d5:	eb 8f                	jmp    80101866 <writei+0x73>
801018d7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018db:	74 0b                	je     801018e8 <writei+0xf5>
801018dd:	8b 45 08             	mov    0x8(%ebp),%eax
801018e0:	8b 7d 10             	mov    0x10(%ebp),%edi
801018e3:	39 78 58             	cmp    %edi,0x58(%eax)
801018e6:	72 0b                	jb     801018f3 <writei+0x100>
801018e8:	8b 45 14             	mov    0x14(%ebp),%eax
801018eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ee:	5b                   	pop    %ebx
801018ef:	5e                   	pop    %esi
801018f0:	5f                   	pop    %edi
801018f1:	5d                   	pop    %ebp
801018f2:	c3                   	ret    
801018f3:	89 78 58             	mov    %edi,0x58(%eax)
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	50                   	push   %eax
801018fa:	e8 ae fa ff ff       	call   801013ad <iupdate>
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	eb e4                	jmp    801018e8 <writei+0xf5>
80101904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101909:	eb e0                	jmp    801018eb <writei+0xf8>
8010190b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101910:	eb d9                	jmp    801018eb <writei+0xf8>
80101912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101917:	eb d2                	jmp    801018eb <writei+0xf8>
80101919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010191e:	eb cb                	jmp    801018eb <writei+0xf8>
80101920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101925:	eb c4                	jmp    801018eb <writei+0xf8>

80101927 <namecmp>:
80101927:	55                   	push   %ebp
80101928:	89 e5                	mov    %esp,%ebp
8010192a:	83 ec 0c             	sub    $0xc,%esp
8010192d:	6a 0e                	push   $0xe
8010192f:	ff 75 0c             	push   0xc(%ebp)
80101932:	ff 75 08             	push   0x8(%ebp)
80101935:	e8 3d 24 00 00       	call   80103d77 <strncmp>
8010193a:	c9                   	leave  
8010193b:	c3                   	ret    

8010193c <dirlookup>:
8010193c:	55                   	push   %ebp
8010193d:	89 e5                	mov    %esp,%ebp
8010193f:	57                   	push   %edi
80101940:	56                   	push   %esi
80101941:	53                   	push   %ebx
80101942:	83 ec 1c             	sub    $0x1c,%esp
80101945:	8b 75 08             	mov    0x8(%ebp),%esi
80101948:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010194b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101950:	75 07                	jne    80101959 <dirlookup+0x1d>
80101952:	bb 00 00 00 00       	mov    $0x0,%ebx
80101957:	eb 1d                	jmp    80101976 <dirlookup+0x3a>
80101959:	83 ec 0c             	sub    $0xc,%esp
8010195c:	68 87 69 10 80       	push   $0x80106987
80101961:	e8 db e9 ff ff       	call   80100341 <panic>
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	68 99 69 10 80       	push   $0x80106999
8010196e:	e8 ce e9 ff ff       	call   80100341 <panic>
80101973:	83 c3 10             	add    $0x10,%ebx
80101976:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101979:	76 48                	jbe    801019c3 <dirlookup+0x87>
8010197b:	6a 10                	push   $0x10
8010197d:	53                   	push   %ebx
8010197e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101981:	50                   	push   %eax
80101982:	56                   	push   %esi
80101983:	e8 6b fd ff ff       	call   801016f3 <readi>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	83 f8 10             	cmp    $0x10,%eax
8010198e:	75 d6                	jne    80101966 <dirlookup+0x2a>
80101990:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101995:	74 dc                	je     80101973 <dirlookup+0x37>
80101997:	83 ec 08             	sub    $0x8,%esp
8010199a:	8d 45 da             	lea    -0x26(%ebp),%eax
8010199d:	50                   	push   %eax
8010199e:	57                   	push   %edi
8010199f:	e8 83 ff ff ff       	call   80101927 <namecmp>
801019a4:	83 c4 10             	add    $0x10,%esp
801019a7:	85 c0                	test   %eax,%eax
801019a9:	75 c8                	jne    80101973 <dirlookup+0x37>
801019ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801019af:	74 05                	je     801019b6 <dirlookup+0x7a>
801019b1:	8b 45 10             	mov    0x10(%ebp),%eax
801019b4:	89 18                	mov    %ebx,(%eax)
801019b6:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
801019ba:	8b 06                	mov    (%esi),%eax
801019bc:	e8 59 f7 ff ff       	call   8010111a <iget>
801019c1:	eb 05                	jmp    801019c8 <dirlookup+0x8c>
801019c3:	b8 00 00 00 00       	mov    $0x0,%eax
801019c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cb:	5b                   	pop    %ebx
801019cc:	5e                   	pop    %esi
801019cd:	5f                   	pop    %edi
801019ce:	5d                   	pop    %ebp
801019cf:	c3                   	ret    

801019d0 <namex>:
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	89 c3                	mov    %eax,%ebx
801019db:	89 55 e0             	mov    %edx,-0x20(%ebp)
801019de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801019e1:	80 38 2f             	cmpb   $0x2f,(%eax)
801019e4:	74 17                	je     801019fd <namex+0x2d>
801019e6:	e8 37 17 00 00       	call   80103122 <myproc>
801019eb:	83 ec 0c             	sub    $0xc,%esp
801019ee:	ff 70 68             	push   0x68(%eax)
801019f1:	e8 e2 fa ff ff       	call   801014d8 <idup>
801019f6:	89 c6                	mov    %eax,%esi
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	eb 53                	jmp    80101a50 <namex+0x80>
801019fd:	ba 01 00 00 00       	mov    $0x1,%edx
80101a02:	b8 01 00 00 00       	mov    $0x1,%eax
80101a07:	e8 0e f7 ff ff       	call   8010111a <iget>
80101a0c:	89 c6                	mov    %eax,%esi
80101a0e:	eb 40                	jmp    80101a50 <namex+0x80>
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	56                   	push   %esi
80101a14:	e8 90 fc ff ff       	call   801016a9 <iunlockput>
80101a19:	83 c4 10             	add    $0x10,%esp
80101a1c:	be 00 00 00 00       	mov    $0x0,%esi
80101a21:	89 f0                	mov    %esi,%eax
80101a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	83 ec 04             	sub    $0x4,%esp
80101a2e:	6a 00                	push   $0x0
80101a30:	ff 75 e4             	push   -0x1c(%ebp)
80101a33:	56                   	push   %esi
80101a34:	e8 03 ff ff ff       	call   8010193c <dirlookup>
80101a39:	89 c7                	mov    %eax,%edi
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	85 c0                	test   %eax,%eax
80101a40:	74 4a                	je     80101a8c <namex+0xbc>
80101a42:	83 ec 0c             	sub    $0xc,%esp
80101a45:	56                   	push   %esi
80101a46:	e8 5e fc ff ff       	call   801016a9 <iunlockput>
80101a4b:	83 c4 10             	add    $0x10,%esp
80101a4e:	89 fe                	mov    %edi,%esi
80101a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a53:	89 d8                	mov    %ebx,%eax
80101a55:	e8 97 f4 ff ff       	call   80100ef1 <skipelem>
80101a5a:	89 c3                	mov    %eax,%ebx
80101a5c:	85 c0                	test   %eax,%eax
80101a5e:	74 3c                	je     80101a9c <namex+0xcc>
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	56                   	push   %esi
80101a64:	e8 9d fa ff ff       	call   80101506 <ilock>
80101a69:	83 c4 10             	add    $0x10,%esp
80101a6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a71:	75 9d                	jne    80101a10 <namex+0x40>
80101a73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101a77:	74 b2                	je     80101a2b <namex+0x5b>
80101a79:	80 3b 00             	cmpb   $0x0,(%ebx)
80101a7c:	75 ad                	jne    80101a2b <namex+0x5b>
80101a7e:	83 ec 0c             	sub    $0xc,%esp
80101a81:	56                   	push   %esi
80101a82:	e8 3f fb ff ff       	call   801015c6 <iunlock>
80101a87:	83 c4 10             	add    $0x10,%esp
80101a8a:	eb 95                	jmp    80101a21 <namex+0x51>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	56                   	push   %esi
80101a90:	e8 14 fc ff ff       	call   801016a9 <iunlockput>
80101a95:	83 c4 10             	add    $0x10,%esp
80101a98:	89 fe                	mov    %edi,%esi
80101a9a:	eb 85                	jmp    80101a21 <namex+0x51>
80101a9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101aa0:	0f 84 7b ff ff ff    	je     80101a21 <namex+0x51>
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 5c fb ff ff       	call   8010160b <iput>
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	89 de                	mov    %ebx,%esi
80101ab4:	e9 68 ff ff ff       	jmp    80101a21 <namex+0x51>

80101ab9 <dirlink>:
80101ab9:	55                   	push   %ebp
80101aba:	89 e5                	mov    %esp,%ebp
80101abc:	57                   	push   %edi
80101abd:	56                   	push   %esi
80101abe:	53                   	push   %ebx
80101abf:	83 ec 20             	sub    $0x20,%esp
80101ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101ac5:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ac8:	6a 00                	push   $0x0
80101aca:	57                   	push   %edi
80101acb:	53                   	push   %ebx
80101acc:	e8 6b fe ff ff       	call   8010193c <dirlookup>
80101ad1:	83 c4 10             	add    $0x10,%esp
80101ad4:	85 c0                	test   %eax,%eax
80101ad6:	75 2d                	jne    80101b05 <dirlink+0x4c>
80101ad8:	b8 00 00 00 00       	mov    $0x0,%eax
80101add:	89 c6                	mov    %eax,%esi
80101adf:	39 43 58             	cmp    %eax,0x58(%ebx)
80101ae2:	76 41                	jbe    80101b25 <dirlink+0x6c>
80101ae4:	6a 10                	push   $0x10
80101ae6:	50                   	push   %eax
80101ae7:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101aea:	50                   	push   %eax
80101aeb:	53                   	push   %ebx
80101aec:	e8 02 fc ff ff       	call   801016f3 <readi>
80101af1:	83 c4 10             	add    $0x10,%esp
80101af4:	83 f8 10             	cmp    $0x10,%eax
80101af7:	75 1f                	jne    80101b18 <dirlink+0x5f>
80101af9:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101afe:	74 25                	je     80101b25 <dirlink+0x6c>
80101b00:	8d 46 10             	lea    0x10(%esi),%eax
80101b03:	eb d8                	jmp    80101add <dirlink+0x24>
80101b05:	83 ec 0c             	sub    $0xc,%esp
80101b08:	50                   	push   %eax
80101b09:	e8 fd fa ff ff       	call   8010160b <iput>
80101b0e:	83 c4 10             	add    $0x10,%esp
80101b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b16:	eb 3d                	jmp    80101b55 <dirlink+0x9c>
80101b18:	83 ec 0c             	sub    $0xc,%esp
80101b1b:	68 a8 69 10 80       	push   $0x801069a8
80101b20:	e8 1c e8 ff ff       	call   80100341 <panic>
80101b25:	83 ec 04             	sub    $0x4,%esp
80101b28:	6a 0e                	push   $0xe
80101b2a:	57                   	push   %edi
80101b2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b2e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b31:	50                   	push   %eax
80101b32:	e8 7a 22 00 00       	call   80103db1 <strncpy>
80101b37:	8b 45 10             	mov    0x10(%ebp),%eax
80101b3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101b3e:	6a 10                	push   $0x10
80101b40:	56                   	push   %esi
80101b41:	57                   	push   %edi
80101b42:	53                   	push   %ebx
80101b43:	e8 ab fc ff ff       	call   801017f3 <writei>
80101b48:	83 c4 20             	add    $0x20,%esp
80101b4b:	83 f8 10             	cmp    $0x10,%eax
80101b4e:	75 0d                	jne    80101b5d <dirlink+0xa4>
80101b50:	b8 00 00 00 00       	mov    $0x0,%eax
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	83 ec 0c             	sub    $0xc,%esp
80101b60:	68 98 6f 10 80       	push   $0x80106f98
80101b65:	e8 d7 e7 ff ff       	call   80100341 <panic>

80101b6a <namei>:
80101b6a:	55                   	push   %ebp
80101b6b:	89 e5                	mov    %esp,%ebp
80101b6d:	83 ec 18             	sub    $0x18,%esp
80101b70:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101b73:	ba 00 00 00 00       	mov    $0x0,%edx
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	e8 50 fe ff ff       	call   801019d0 <namex>
80101b80:	c9                   	leave  
80101b81:	c3                   	ret    

80101b82 <nameiparent>:
80101b82:	55                   	push   %ebp
80101b83:	89 e5                	mov    %esp,%ebp
80101b85:	83 ec 08             	sub    $0x8,%esp
80101b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101b8b:	ba 01 00 00 00       	mov    $0x1,%edx
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	e8 38 fe ff ff       	call   801019d0 <namex>
80101b98:	c9                   	leave  
80101b99:	c3                   	ret    

80101b9a <idewait>:
80101b9a:	89 c1                	mov    %eax,%ecx
80101b9c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ba1:	ec                   	in     (%dx),%al
80101ba2:	88 c2                	mov    %al,%dl
80101ba4:	83 e2 c0             	and    $0xffffffc0,%edx
80101ba7:	80 fa 40             	cmp    $0x40,%dl
80101baa:	75 f0                	jne    80101b9c <idewait+0x2>
80101bac:	85 c9                	test   %ecx,%ecx
80101bae:	74 09                	je     80101bb9 <idewait+0x1f>
80101bb0:	a8 21                	test   $0x21,%al
80101bb2:	75 08                	jne    80101bbc <idewait+0x22>
80101bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
80101bb9:	89 c8                	mov    %ecx,%eax
80101bbb:	c3                   	ret    
80101bbc:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101bc1:	eb f6                	jmp    80101bb9 <idewait+0x1f>

80101bc3 <idestart>:
80101bc3:	55                   	push   %ebp
80101bc4:	89 e5                	mov    %esp,%ebp
80101bc6:	56                   	push   %esi
80101bc7:	53                   	push   %ebx
80101bc8:	85 c0                	test   %eax,%eax
80101bca:	0f 84 85 00 00 00    	je     80101c55 <idestart+0x92>
80101bd0:	89 c6                	mov    %eax,%esi
80101bd2:	8b 58 08             	mov    0x8(%eax),%ebx
80101bd5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101bdb:	0f 87 81 00 00 00    	ja     80101c62 <idestart+0x9f>
80101be1:	b8 00 00 00 00       	mov    $0x0,%eax
80101be6:	e8 af ff ff ff       	call   80101b9a <idewait>
80101beb:	b0 00                	mov    $0x0,%al
80101bed:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101bf2:	ee                   	out    %al,(%dx)
80101bf3:	b0 01                	mov    $0x1,%al
80101bf5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101bfa:	ee                   	out    %al,(%dx)
80101bfb:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c00:	88 d8                	mov    %bl,%al
80101c02:	ee                   	out    %al,(%dx)
80101c03:	0f b6 c7             	movzbl %bh,%eax
80101c06:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c0b:	ee                   	out    %al,(%dx)
80101c0c:	89 d8                	mov    %ebx,%eax
80101c0e:	c1 f8 10             	sar    $0x10,%eax
80101c11:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c16:	ee                   	out    %al,(%dx)
80101c17:	8a 46 04             	mov    0x4(%esi),%al
80101c1a:	c1 e0 04             	shl    $0x4,%eax
80101c1d:	83 e0 10             	and    $0x10,%eax
80101c20:	c1 fb 18             	sar    $0x18,%ebx
80101c23:	83 e3 0f             	and    $0xf,%ebx
80101c26:	09 d8                	or     %ebx,%eax
80101c28:	83 c8 e0             	or     $0xffffffe0,%eax
80101c2b:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101c30:	ee                   	out    %al,(%dx)
80101c31:	f6 06 04             	testb  $0x4,(%esi)
80101c34:	74 39                	je     80101c6f <idestart+0xac>
80101c36:	b0 30                	mov    $0x30,%al
80101c38:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c3d:	ee                   	out    %al,(%dx)
80101c3e:	83 c6 5c             	add    $0x5c,%esi
80101c41:	b9 80 00 00 00       	mov    $0x80,%ecx
80101c46:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101c4b:	fc                   	cld    
80101c4c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c51:	5b                   	pop    %ebx
80101c52:	5e                   	pop    %esi
80101c53:	5d                   	pop    %ebp
80101c54:	c3                   	ret    
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	68 0b 6a 10 80       	push   $0x80106a0b
80101c5d:	e8 df e6 ff ff       	call   80100341 <panic>
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	68 14 6a 10 80       	push   $0x80106a14
80101c6a:	e8 d2 e6 ff ff       	call   80100341 <panic>
80101c6f:	b0 20                	mov    $0x20,%al
80101c71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c76:	ee                   	out    %al,(%dx)
80101c77:	eb d5                	jmp    80101c4e <idestart+0x8b>

80101c79 <ideinit>:
80101c79:	55                   	push   %ebp
80101c7a:	89 e5                	mov    %esp,%ebp
80101c7c:	83 ec 10             	sub    $0x10,%esp
80101c7f:	68 26 6a 10 80       	push   $0x80106a26
80101c84:	68 00 16 11 80       	push   $0x80111600
80101c89:	e8 1c 1e 00 00       	call   80103aaa <initlock>
80101c8e:	83 c4 08             	add    $0x8,%esp
80101c91:	a1 84 17 11 80       	mov    0x80111784,%eax
80101c96:	48                   	dec    %eax
80101c97:	50                   	push   %eax
80101c98:	6a 0e                	push   $0xe
80101c9a:	e8 46 02 00 00       	call   80101ee5 <ioapicenable>
80101c9f:	b8 00 00 00 00       	mov    $0x0,%eax
80101ca4:	e8 f1 fe ff ff       	call   80101b9a <idewait>
80101ca9:	b0 f0                	mov    $0xf0,%al
80101cab:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cb0:	ee                   	out    %al,(%dx)
80101cb1:	83 c4 10             	add    $0x10,%esp
80101cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
80101cb9:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101cbf:	7f 17                	jg     80101cd8 <ideinit+0x5f>
80101cc1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cc6:	ec                   	in     (%dx),%al
80101cc7:	84 c0                	test   %al,%al
80101cc9:	75 03                	jne    80101cce <ideinit+0x55>
80101ccb:	41                   	inc    %ecx
80101ccc:	eb eb                	jmp    80101cb9 <ideinit+0x40>
80101cce:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101cd5:	00 00 00 
80101cd8:	b0 e0                	mov    $0xe0,%al
80101cda:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cdf:	ee                   	out    %al,(%dx)
80101ce0:	c9                   	leave  
80101ce1:	c3                   	ret    

80101ce2 <ideintr>:
80101ce2:	55                   	push   %ebp
80101ce3:	89 e5                	mov    %esp,%ebp
80101ce5:	57                   	push   %edi
80101ce6:	53                   	push   %ebx
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	68 00 16 11 80       	push   $0x80111600
80101cef:	e8 ed 1e 00 00       	call   80103be1 <acquire>
80101cf4:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	85 db                	test   %ebx,%ebx
80101cff:	74 4a                	je     80101d4b <ideintr+0x69>
80101d01:	8b 43 58             	mov    0x58(%ebx),%eax
80101d04:	a3 e4 15 11 80       	mov    %eax,0x801115e4
80101d09:	f6 03 04             	testb  $0x4,(%ebx)
80101d0c:	74 4f                	je     80101d5d <ideintr+0x7b>
80101d0e:	8b 03                	mov    (%ebx),%eax
80101d10:	83 c8 02             	or     $0x2,%eax
80101d13:	89 03                	mov    %eax,(%ebx)
80101d15:	83 e0 fb             	and    $0xfffffffb,%eax
80101d18:	89 03                	mov    %eax,(%ebx)
80101d1a:	83 ec 0c             	sub    $0xc,%esp
80101d1d:	53                   	push   %ebx
80101d1e:	e8 1e 1b 00 00       	call   80103841 <wakeup>
80101d23:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101d28:	83 c4 10             	add    $0x10,%esp
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <ideintr+0x52>
80101d2f:	e8 8f fe ff ff       	call   80101bc3 <idestart>
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 00 16 11 80       	push   $0x80111600
80101d3c:	e8 05 1f 00 00       	call   80103c46 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d47:	5b                   	pop    %ebx
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	83 ec 0c             	sub    $0xc,%esp
80101d4e:	68 00 16 11 80       	push   $0x80111600
80101d53:	e8 ee 1e 00 00       	call   80103c46 <release>
80101d58:	83 c4 10             	add    $0x10,%esp
80101d5b:	eb e7                	jmp    80101d44 <ideintr+0x62>
80101d5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101d62:	e8 33 fe ff ff       	call   80101b9a <idewait>
80101d67:	85 c0                	test   %eax,%eax
80101d69:	78 a3                	js     80101d0e <ideintr+0x2c>
80101d6b:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80101d6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d73:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d78:	fc                   	cld    
80101d79:	f3 6d                	rep insl (%dx),%es:(%edi)
80101d7b:	eb 91                	jmp    80101d0e <ideintr+0x2c>

80101d7d <iderw>:
80101d7d:	55                   	push   %ebp
80101d7e:	89 e5                	mov    %esp,%ebp
80101d80:	53                   	push   %ebx
80101d81:	83 ec 10             	sub    $0x10,%esp
80101d84:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101d87:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d8a:	50                   	push   %eax
80101d8b:	e8 cc 1c 00 00       	call   80103a5c <holdingsleep>
80101d90:	83 c4 10             	add    $0x10,%esp
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 37                	je     80101dce <iderw+0x51>
80101d97:	8b 03                	mov    (%ebx),%eax
80101d99:	83 e0 06             	and    $0x6,%eax
80101d9c:	83 f8 02             	cmp    $0x2,%eax
80101d9f:	74 3a                	je     80101ddb <iderw+0x5e>
80101da1:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101da5:	74 09                	je     80101db0 <iderw+0x33>
80101da7:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101dae:	74 38                	je     80101de8 <iderw+0x6b>
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	68 00 16 11 80       	push   $0x80111600
80101db8:	e8 24 1e 00 00       	call   80103be1 <acquire>
80101dbd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101dcc:	eb 2a                	jmp    80101df8 <iderw+0x7b>
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	68 2a 6a 10 80       	push   $0x80106a2a
80101dd6:	e8 66 e5 ff ff       	call   80100341 <panic>
80101ddb:	83 ec 0c             	sub    $0xc,%esp
80101dde:	68 40 6a 10 80       	push   $0x80106a40
80101de3:	e8 59 e5 ff ff       	call   80100341 <panic>
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	68 55 6a 10 80       	push   $0x80106a55
80101df0:	e8 4c e5 ff ff       	call   80100341 <panic>
80101df5:	8d 50 58             	lea    0x58(%eax),%edx
80101df8:	8b 02                	mov    (%edx),%eax
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	75 f7                	jne    80101df5 <iderw+0x78>
80101dfe:	89 1a                	mov    %ebx,(%edx)
80101e00:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e06:	75 1a                	jne    80101e22 <iderw+0xa5>
80101e08:	89 d8                	mov    %ebx,%eax
80101e0a:	e8 b4 fd ff ff       	call   80101bc3 <idestart>
80101e0f:	eb 11                	jmp    80101e22 <iderw+0xa5>
80101e11:	83 ec 08             	sub    $0x8,%esp
80101e14:	68 00 16 11 80       	push   $0x80111600
80101e19:	53                   	push   %ebx
80101e1a:	e8 9d 18 00 00       	call   801036bc <sleep>
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	8b 03                	mov    (%ebx),%eax
80101e24:	83 e0 06             	and    $0x6,%eax
80101e27:	83 f8 02             	cmp    $0x2,%eax
80101e2a:	75 e5                	jne    80101e11 <iderw+0x94>
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	68 00 16 11 80       	push   $0x80111600
80101e34:	e8 0d 1e 00 00       	call   80103c46 <release>
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e3f:	c9                   	leave  
80101e40:	c3                   	ret    

80101e41 <ioapicread>:
80101e41:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101e47:	89 02                	mov    %eax,(%edx)
80101e49:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e4e:	8b 40 10             	mov    0x10(%eax),%eax
80101e51:	c3                   	ret    

80101e52 <ioapicwrite>:
80101e52:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101e58:	89 01                	mov    %eax,(%ecx)
80101e5a:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e5f:	89 50 10             	mov    %edx,0x10(%eax)
80101e62:	c3                   	ret    

80101e63 <ioapicinit>:
80101e63:	55                   	push   %ebp
80101e64:	89 e5                	mov    %esp,%ebp
80101e66:	57                   	push   %edi
80101e67:	56                   	push   %esi
80101e68:	53                   	push   %ebx
80101e69:	83 ec 0c             	sub    $0xc,%esp
80101e6c:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101e73:	00 c0 fe 
80101e76:	b8 01 00 00 00       	mov    $0x1,%eax
80101e7b:	e8 c1 ff ff ff       	call   80101e41 <ioapicread>
80101e80:	c1 e8 10             	shr    $0x10,%eax
80101e83:	0f b6 f8             	movzbl %al,%edi
80101e86:	b8 00 00 00 00       	mov    $0x0,%eax
80101e8b:	e8 b1 ff ff ff       	call   80101e41 <ioapicread>
80101e90:	c1 e8 18             	shr    $0x18,%eax
80101e93:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101e9a:	39 c2                	cmp    %eax,%edx
80101e9c:	75 07                	jne    80101ea5 <ioapicinit+0x42>
80101e9e:	bb 00 00 00 00       	mov    $0x0,%ebx
80101ea3:	eb 34                	jmp    80101ed9 <ioapicinit+0x76>
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 74 6a 10 80       	push   $0x80106a74
80101ead:	e8 28 e7 ff ff       	call   801005da <cprintf>
80101eb2:	83 c4 10             	add    $0x10,%esp
80101eb5:	eb e7                	jmp    80101e9e <ioapicinit+0x3b>
80101eb7:	8d 53 20             	lea    0x20(%ebx),%edx
80101eba:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101ec0:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101ec4:	89 f0                	mov    %esi,%eax
80101ec6:	e8 87 ff ff ff       	call   80101e52 <ioapicwrite>
80101ecb:	8d 46 01             	lea    0x1(%esi),%eax
80101ece:	ba 00 00 00 00       	mov    $0x0,%edx
80101ed3:	e8 7a ff ff ff       	call   80101e52 <ioapicwrite>
80101ed8:	43                   	inc    %ebx
80101ed9:	39 fb                	cmp    %edi,%ebx
80101edb:	7e da                	jle    80101eb7 <ioapicinit+0x54>
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    

80101ee5 <ioapicenable>:
80101ee5:	55                   	push   %ebp
80101ee6:	89 e5                	mov    %esp,%ebp
80101ee8:	53                   	push   %ebx
80101ee9:	83 ec 04             	sub    $0x4,%esp
80101eec:	8b 45 08             	mov    0x8(%ebp),%eax
80101eef:	8d 50 20             	lea    0x20(%eax),%edx
80101ef2:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101ef6:	89 d8                	mov    %ebx,%eax
80101ef8:	e8 55 ff ff ff       	call   80101e52 <ioapicwrite>
80101efd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f00:	c1 e2 18             	shl    $0x18,%edx
80101f03:	8d 43 01             	lea    0x1(%ebx),%eax
80101f06:	e8 47 ff ff ff       	call   80101e52 <ioapicwrite>
80101f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f0e:	c9                   	leave  
80101f0f:	c3                   	ret    

80101f10 <kfree>:
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	53                   	push   %ebx
80101f14:	83 ec 04             	sub    $0x4,%esp
80101f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101f1a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101f20:	75 4c                	jne    80101f6e <kfree+0x5e>
80101f22:	81 fb 30 58 11 80    	cmp    $0x80115830,%ebx
80101f28:	72 44                	jb     80101f6e <kfree+0x5e>
80101f2a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101f30:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101f35:	77 37                	ja     80101f6e <kfree+0x5e>
80101f37:	83 ec 04             	sub    $0x4,%esp
80101f3a:	68 00 10 00 00       	push   $0x1000
80101f3f:	6a 01                	push   $0x1
80101f41:	53                   	push   %ebx
80101f42:	e8 46 1d 00 00       	call   80103c8d <memset>
80101f47:	83 c4 10             	add    $0x10,%esp
80101f4a:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f51:	75 28                	jne    80101f7b <kfree+0x6b>
80101f53:	a1 78 16 11 80       	mov    0x80111678,%eax
80101f58:	89 03                	mov    %eax,(%ebx)
80101f5a:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
80101f60:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f67:	75 24                	jne    80101f8d <kfree+0x7d>
80101f69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f6c:	c9                   	leave  
80101f6d:	c3                   	ret    
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	68 a6 6a 10 80       	push   $0x80106aa6
80101f76:	e8 c6 e3 ff ff       	call   80100341 <panic>
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	68 40 16 11 80       	push   $0x80111640
80101f83:	e8 59 1c 00 00       	call   80103be1 <acquire>
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	eb c6                	jmp    80101f53 <kfree+0x43>
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 40 16 11 80       	push   $0x80111640
80101f95:	e8 ac 1c 00 00       	call   80103c46 <release>
80101f9a:	83 c4 10             	add    $0x10,%esp
80101f9d:	eb ca                	jmp    80101f69 <kfree+0x59>

80101f9f <freerange>:
80101f9f:	55                   	push   %ebp
80101fa0:	89 e5                	mov    %esp,%ebp
80101fa2:	56                   	push   %esi
80101fa3:	53                   	push   %ebx
80101fa4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	05 ff 0f 00 00       	add    $0xfff,%eax
80101faf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80101fb4:	eb 0e                	jmp    80101fc4 <freerange+0x25>
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	50                   	push   %eax
80101fba:	e8 51 ff ff ff       	call   80101f10 <kfree>
80101fbf:	83 c4 10             	add    $0x10,%esp
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80101fca:	39 de                	cmp    %ebx,%esi
80101fcc:	76 e8                	jbe    80101fb6 <freerange+0x17>
80101fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    

80101fd5 <kinit1>:
80101fd5:	55                   	push   %ebp
80101fd6:	89 e5                	mov    %esp,%ebp
80101fd8:	83 ec 10             	sub    $0x10,%esp
80101fdb:	68 ac 6a 10 80       	push   $0x80106aac
80101fe0:	68 40 16 11 80       	push   $0x80111640
80101fe5:	e8 c0 1a 00 00       	call   80103aaa <initlock>
80101fea:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80101ff1:	00 00 00 
80101ff4:	83 c4 08             	add    $0x8,%esp
80101ff7:	ff 75 0c             	push   0xc(%ebp)
80101ffa:	ff 75 08             	push   0x8(%ebp)
80101ffd:	e8 9d ff ff ff       	call   80101f9f <freerange>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	c9                   	leave  
80102006:	c3                   	ret    

80102007 <kinit2>:
80102007:	55                   	push   %ebp
80102008:	89 e5                	mov    %esp,%ebp
8010200a:	83 ec 10             	sub    $0x10,%esp
8010200d:	ff 75 0c             	push   0xc(%ebp)
80102010:	ff 75 08             	push   0x8(%ebp)
80102013:	e8 87 ff ff ff       	call   80101f9f <freerange>
80102018:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010201f:	00 00 00 
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	c9                   	leave  
80102026:	c3                   	ret    

80102027 <kalloc>:
80102027:	55                   	push   %ebp
80102028:	89 e5                	mov    %esp,%ebp
8010202a:	53                   	push   %ebx
8010202b:	83 ec 04             	sub    $0x4,%esp
8010202e:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102035:	75 21                	jne    80102058 <kalloc+0x31>
80102037:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
8010203d:	85 db                	test   %ebx,%ebx
8010203f:	74 07                	je     80102048 <kalloc+0x21>
80102041:	8b 03                	mov    (%ebx),%eax
80102043:	a3 78 16 11 80       	mov    %eax,0x80111678
80102048:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010204f:	75 19                	jne    8010206a <kalloc+0x43>
80102051:	89 d8                	mov    %ebx,%eax
80102053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102056:	c9                   	leave  
80102057:	c3                   	ret    
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 40 16 11 80       	push   $0x80111640
80102060:	e8 7c 1b 00 00       	call   80103be1 <acquire>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	eb cd                	jmp    80102037 <kalloc+0x10>
8010206a:	83 ec 0c             	sub    $0xc,%esp
8010206d:	68 40 16 11 80       	push   $0x80111640
80102072:	e8 cf 1b 00 00       	call   80103c46 <release>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	eb d5                	jmp    80102051 <kalloc+0x2a>

8010207c <kbdgetc>:
8010207c:	ba 64 00 00 00       	mov    $0x64,%edx
80102081:	ec                   	in     (%dx),%al
80102082:	a8 01                	test   $0x1,%al
80102084:	0f 84 b3 00 00 00    	je     8010213d <kbdgetc+0xc1>
8010208a:	ba 60 00 00 00       	mov    $0x60,%edx
8010208f:	ec                   	in     (%dx),%al
80102090:	0f b6 c8             	movzbl %al,%ecx
80102093:	3c e0                	cmp    $0xe0,%al
80102095:	74 61                	je     801020f8 <kbdgetc+0x7c>
80102097:	84 c0                	test   %al,%al
80102099:	78 6a                	js     80102105 <kbdgetc+0x89>
8010209b:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
801020a1:	f6 c2 40             	test   $0x40,%dl
801020a4:	74 0f                	je     801020b5 <kbdgetc+0x39>
801020a6:	83 c8 80             	or     $0xffffff80,%eax
801020a9:	0f b6 c8             	movzbl %al,%ecx
801020ac:	83 e2 bf             	and    $0xffffffbf,%edx
801020af:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
801020b5:	0f b6 91 e0 6b 10 80 	movzbl -0x7fef9420(%ecx),%edx
801020bc:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
801020c2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
801020c8:	0f b6 81 e0 6a 10 80 	movzbl -0x7fef9520(%ecx),%eax
801020cf:	31 c2                	xor    %eax,%edx
801020d1:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
801020d7:	89 d0                	mov    %edx,%eax
801020d9:	83 e0 03             	and    $0x3,%eax
801020dc:	8b 04 85 c0 6a 10 80 	mov    -0x7fef9540(,%eax,4),%eax
801020e3:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
801020e7:	f6 c2 08             	test   $0x8,%dl
801020ea:	74 56                	je     80102142 <kbdgetc+0xc6>
801020ec:	8d 50 9f             	lea    -0x61(%eax),%edx
801020ef:	83 fa 19             	cmp    $0x19,%edx
801020f2:	77 3d                	ja     80102131 <kbdgetc+0xb5>
801020f4:	83 e8 20             	sub    $0x20,%eax
801020f7:	c3                   	ret    
801020f8:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
801020ff:	b8 00 00 00 00       	mov    $0x0,%eax
80102104:	c3                   	ret    
80102105:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010210b:	f6 c2 40             	test   $0x40,%dl
8010210e:	75 05                	jne    80102115 <kbdgetc+0x99>
80102110:	89 c1                	mov    %eax,%ecx
80102112:	83 e1 7f             	and    $0x7f,%ecx
80102115:	8a 81 e0 6b 10 80    	mov    -0x7fef9420(%ecx),%al
8010211b:	83 c8 40             	or     $0x40,%eax
8010211e:	0f b6 c0             	movzbl %al,%eax
80102121:	f7 d0                	not    %eax
80102123:	21 c2                	and    %eax,%edx
80102125:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
8010212b:	b8 00 00 00 00       	mov    $0x0,%eax
80102130:	c3                   	ret    
80102131:	8d 50 bf             	lea    -0x41(%eax),%edx
80102134:	83 fa 19             	cmp    $0x19,%edx
80102137:	77 09                	ja     80102142 <kbdgetc+0xc6>
80102139:	83 c0 20             	add    $0x20,%eax
8010213c:	c3                   	ret    
8010213d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102142:	c3                   	ret    

80102143 <kbdintr>:
80102143:	55                   	push   %ebp
80102144:	89 e5                	mov    %esp,%ebp
80102146:	83 ec 14             	sub    $0x14,%esp
80102149:	68 7c 20 10 80       	push   $0x8010207c
8010214e:	e8 ac e5 ff ff       	call   801006ff <consoleintr>
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	c9                   	leave  
80102157:	c3                   	ret    

80102158 <lapicw>:
80102158:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
8010215e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102161:	89 10                	mov    %edx,(%eax)
80102163:	a1 80 16 11 80       	mov    0x80111680,%eax
80102168:	8b 40 20             	mov    0x20(%eax),%eax
8010216b:	c3                   	ret    

8010216c <cmos_read>:
8010216c:	ba 70 00 00 00       	mov    $0x70,%edx
80102171:	ee                   	out    %al,(%dx)
80102172:	ba 71 00 00 00       	mov    $0x71,%edx
80102177:	ec                   	in     (%dx),%al
80102178:	0f b6 c0             	movzbl %al,%eax
8010217b:	c3                   	ret    

8010217c <fill_rtcdate>:
8010217c:	55                   	push   %ebp
8010217d:	89 e5                	mov    %esp,%ebp
8010217f:	53                   	push   %ebx
80102180:	83 ec 04             	sub    $0x4,%esp
80102183:	89 c3                	mov    %eax,%ebx
80102185:	b8 00 00 00 00       	mov    $0x0,%eax
8010218a:	e8 dd ff ff ff       	call   8010216c <cmos_read>
8010218f:	89 03                	mov    %eax,(%ebx)
80102191:	b8 02 00 00 00       	mov    $0x2,%eax
80102196:	e8 d1 ff ff ff       	call   8010216c <cmos_read>
8010219b:	89 43 04             	mov    %eax,0x4(%ebx)
8010219e:	b8 04 00 00 00       	mov    $0x4,%eax
801021a3:	e8 c4 ff ff ff       	call   8010216c <cmos_read>
801021a8:	89 43 08             	mov    %eax,0x8(%ebx)
801021ab:	b8 07 00 00 00       	mov    $0x7,%eax
801021b0:	e8 b7 ff ff ff       	call   8010216c <cmos_read>
801021b5:	89 43 0c             	mov    %eax,0xc(%ebx)
801021b8:	b8 08 00 00 00       	mov    $0x8,%eax
801021bd:	e8 aa ff ff ff       	call   8010216c <cmos_read>
801021c2:	89 43 10             	mov    %eax,0x10(%ebx)
801021c5:	b8 09 00 00 00       	mov    $0x9,%eax
801021ca:	e8 9d ff ff ff       	call   8010216c <cmos_read>
801021cf:	89 43 14             	mov    %eax,0x14(%ebx)
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
801021d6:	c3                   	ret    

801021d7 <lapicinit>:
801021d7:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
801021de:	0f 84 fe 00 00 00    	je     801022e2 <lapicinit+0x10b>
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	83 ec 08             	sub    $0x8,%esp
801021ea:	ba 3f 01 00 00       	mov    $0x13f,%edx
801021ef:	b8 3c 00 00 00       	mov    $0x3c,%eax
801021f4:	e8 5f ff ff ff       	call   80102158 <lapicw>
801021f9:	ba 0b 00 00 00       	mov    $0xb,%edx
801021fe:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102203:	e8 50 ff ff ff       	call   80102158 <lapicw>
80102208:	ba 20 00 02 00       	mov    $0x20020,%edx
8010220d:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102212:	e8 41 ff ff ff       	call   80102158 <lapicw>
80102217:	ba 80 96 98 00       	mov    $0x989680,%edx
8010221c:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102221:	e8 32 ff ff ff       	call   80102158 <lapicw>
80102226:	ba 00 00 01 00       	mov    $0x10000,%edx
8010222b:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102230:	e8 23 ff ff ff       	call   80102158 <lapicw>
80102235:	ba 00 00 01 00       	mov    $0x10000,%edx
8010223a:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010223f:	e8 14 ff ff ff       	call   80102158 <lapicw>
80102244:	a1 80 16 11 80       	mov    0x80111680,%eax
80102249:	8b 40 30             	mov    0x30(%eax),%eax
8010224c:	c1 e8 10             	shr    $0x10,%eax
8010224f:	a8 fc                	test   $0xfc,%al
80102251:	75 7b                	jne    801022ce <lapicinit+0xf7>
80102253:	ba 33 00 00 00       	mov    $0x33,%edx
80102258:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010225d:	e8 f6 fe ff ff       	call   80102158 <lapicw>
80102262:	ba 00 00 00 00       	mov    $0x0,%edx
80102267:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010226c:	e8 e7 fe ff ff       	call   80102158 <lapicw>
80102271:	ba 00 00 00 00       	mov    $0x0,%edx
80102276:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010227b:	e8 d8 fe ff ff       	call   80102158 <lapicw>
80102280:	ba 00 00 00 00       	mov    $0x0,%edx
80102285:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010228a:	e8 c9 fe ff ff       	call   80102158 <lapicw>
8010228f:	ba 00 00 00 00       	mov    $0x0,%edx
80102294:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102299:	e8 ba fe ff ff       	call   80102158 <lapicw>
8010229e:	ba 00 85 08 00       	mov    $0x88500,%edx
801022a3:	b8 c0 00 00 00       	mov    $0xc0,%eax
801022a8:	e8 ab fe ff ff       	call   80102158 <lapicw>
801022ad:	a1 80 16 11 80       	mov    0x80111680,%eax
801022b2:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801022b8:	f6 c4 10             	test   $0x10,%ah
801022bb:	75 f0                	jne    801022ad <lapicinit+0xd6>
801022bd:	ba 00 00 00 00       	mov    $0x0,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	e8 8c fe ff ff       	call   80102158 <lapicw>
801022cc:	c9                   	leave  
801022cd:	c3                   	ret    
801022ce:	ba 00 00 01 00       	mov    $0x10000,%edx
801022d3:	b8 d0 00 00 00       	mov    $0xd0,%eax
801022d8:	e8 7b fe ff ff       	call   80102158 <lapicw>
801022dd:	e9 71 ff ff ff       	jmp    80102253 <lapicinit+0x7c>
801022e2:	c3                   	ret    

801022e3 <lapicid>:
801022e3:	a1 80 16 11 80       	mov    0x80111680,%eax
801022e8:	85 c0                	test   %eax,%eax
801022ea:	74 07                	je     801022f3 <lapicid+0x10>
801022ec:	8b 40 20             	mov    0x20(%eax),%eax
801022ef:	c1 e8 18             	shr    $0x18,%eax
801022f2:	c3                   	ret    
801022f3:	b8 00 00 00 00       	mov    $0x0,%eax
801022f8:	c3                   	ret    

801022f9 <lapiceoi>:
801022f9:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
80102300:	74 17                	je     80102319 <lapiceoi+0x20>
80102302:	55                   	push   %ebp
80102303:	89 e5                	mov    %esp,%ebp
80102305:	83 ec 08             	sub    $0x8,%esp
80102308:	ba 00 00 00 00       	mov    $0x0,%edx
8010230d:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102312:	e8 41 fe ff ff       	call   80102158 <lapicw>
80102317:	c9                   	leave  
80102318:	c3                   	ret    
80102319:	c3                   	ret    

8010231a <microdelay>:
8010231a:	c3                   	ret    

8010231b <lapicstartap>:
8010231b:	55                   	push   %ebp
8010231c:	89 e5                	mov    %esp,%ebp
8010231e:	57                   	push   %edi
8010231f:	56                   	push   %esi
80102320:	53                   	push   %ebx
80102321:	83 ec 0c             	sub    $0xc,%esp
80102324:	8b 75 08             	mov    0x8(%ebp),%esi
80102327:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010232a:	b0 0f                	mov    $0xf,%al
8010232c:	ba 70 00 00 00       	mov    $0x70,%edx
80102331:	ee                   	out    %al,(%dx)
80102332:	b0 0a                	mov    $0xa,%al
80102334:	ba 71 00 00 00       	mov    $0x71,%edx
80102339:	ee                   	out    %al,(%dx)
8010233a:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102341:	00 00 
80102343:	89 f8                	mov    %edi,%eax
80102345:	c1 e8 04             	shr    $0x4,%eax
80102348:	66 a3 69 04 00 80    	mov    %ax,0x80000469
8010234e:	c1 e6 18             	shl    $0x18,%esi
80102351:	89 f2                	mov    %esi,%edx
80102353:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102358:	e8 fb fd ff ff       	call   80102158 <lapicw>
8010235d:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102362:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102367:	e8 ec fd ff ff       	call   80102158 <lapicw>
8010236c:	ba 00 85 00 00       	mov    $0x8500,%edx
80102371:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102376:	e8 dd fd ff ff       	call   80102158 <lapicw>
8010237b:	bb 00 00 00 00       	mov    $0x0,%ebx
80102380:	eb 1f                	jmp    801023a1 <lapicstartap+0x86>
80102382:	89 f2                	mov    %esi,%edx
80102384:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102389:	e8 ca fd ff ff       	call   80102158 <lapicw>
8010238e:	89 fa                	mov    %edi,%edx
80102390:	c1 ea 0c             	shr    $0xc,%edx
80102393:	80 ce 06             	or     $0x6,%dh
80102396:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010239b:	e8 b8 fd ff ff       	call   80102158 <lapicw>
801023a0:	43                   	inc    %ebx
801023a1:	83 fb 01             	cmp    $0x1,%ebx
801023a4:	7e dc                	jle    80102382 <lapicstartap+0x67>
801023a6:	83 c4 0c             	add    $0xc,%esp
801023a9:	5b                   	pop    %ebx
801023aa:	5e                   	pop    %esi
801023ab:	5f                   	pop    %edi
801023ac:	5d                   	pop    %ebp
801023ad:	c3                   	ret    

801023ae <cmostime>:
801023ae:	55                   	push   %ebp
801023af:	89 e5                	mov    %esp,%ebp
801023b1:	57                   	push   %edi
801023b2:	56                   	push   %esi
801023b3:	53                   	push   %ebx
801023b4:	83 ec 3c             	sub    $0x3c,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801023ba:	b8 0b 00 00 00       	mov    $0xb,%eax
801023bf:	e8 a8 fd ff ff       	call   8010216c <cmos_read>
801023c4:	83 e0 04             	and    $0x4,%eax
801023c7:	89 c7                	mov    %eax,%edi
801023c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801023cc:	e8 ab fd ff ff       	call   8010217c <fill_rtcdate>
801023d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801023d6:	e8 91 fd ff ff       	call   8010216c <cmos_read>
801023db:	a8 80                	test   $0x80,%al
801023dd:	75 ea                	jne    801023c9 <cmostime+0x1b>
801023df:	8d 75 b8             	lea    -0x48(%ebp),%esi
801023e2:	89 f0                	mov    %esi,%eax
801023e4:	e8 93 fd ff ff       	call   8010217c <fill_rtcdate>
801023e9:	83 ec 04             	sub    $0x4,%esp
801023ec:	6a 18                	push   $0x18
801023ee:	56                   	push   %esi
801023ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801023f2:	50                   	push   %eax
801023f3:	e8 e0 18 00 00       	call   80103cd8 <memcmp>
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	85 c0                	test   %eax,%eax
801023fd:	75 ca                	jne    801023c9 <cmostime+0x1b>
801023ff:	85 ff                	test   %edi,%edi
80102401:	75 7e                	jne    80102481 <cmostime+0xd3>
80102403:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102406:	89 d0                	mov    %edx,%eax
80102408:	c1 e8 04             	shr    $0x4,%eax
8010240b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010240e:	01 c0                	add    %eax,%eax
80102410:	83 e2 0f             	and    $0xf,%edx
80102413:	01 d0                	add    %edx,%eax
80102415:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102418:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010241b:	89 d0                	mov    %edx,%eax
8010241d:	c1 e8 04             	shr    $0x4,%eax
80102420:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102423:	01 c0                	add    %eax,%eax
80102425:	83 e2 0f             	and    $0xf,%edx
80102428:	01 d0                	add    %edx,%eax
8010242a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010242d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102430:	89 d0                	mov    %edx,%eax
80102432:	c1 e8 04             	shr    $0x4,%eax
80102435:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102438:	01 c0                	add    %eax,%eax
8010243a:	83 e2 0f             	and    $0xf,%edx
8010243d:	01 d0                	add    %edx,%eax
8010243f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102442:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102445:	89 d0                	mov    %edx,%eax
80102447:	c1 e8 04             	shr    $0x4,%eax
8010244a:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010244d:	01 c0                	add    %eax,%eax
8010244f:	83 e2 0f             	and    $0xf,%edx
80102452:	01 d0                	add    %edx,%eax
80102454:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102457:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010245a:	89 d0                	mov    %edx,%eax
8010245c:	c1 e8 04             	shr    $0x4,%eax
8010245f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102462:	01 c0                	add    %eax,%eax
80102464:	83 e2 0f             	and    $0xf,%edx
80102467:	01 d0                	add    %edx,%eax
80102469:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010246c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010246f:	89 d0                	mov    %edx,%eax
80102471:	c1 e8 04             	shr    $0x4,%eax
80102474:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102477:	01 c0                	add    %eax,%eax
80102479:	83 e2 0f             	and    $0xf,%edx
8010247c:	01 d0                	add    %edx,%eax
8010247e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102481:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102484:	b9 06 00 00 00       	mov    $0x6,%ecx
80102489:	89 df                	mov    %ebx,%edi
8010248b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
8010248d:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
80102494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102497:	5b                   	pop    %ebx
80102498:	5e                   	pop    %esi
80102499:	5f                   	pop    %edi
8010249a:	5d                   	pop    %ebp
8010249b:	c3                   	ret    

8010249c <read_head>:
8010249c:	55                   	push   %ebp
8010249d:	89 e5                	mov    %esp,%ebp
8010249f:	53                   	push   %ebx
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	ff 35 d4 16 11 80    	push   0x801116d4
801024a9:	ff 35 e4 16 11 80    	push   0x801116e4
801024af:	e8 b6 dc ff ff       	call   8010016a <bread>
801024b4:	8b 58 5c             	mov    0x5c(%eax),%ebx
801024b7:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	ba 00 00 00 00       	mov    $0x0,%edx
801024c5:	eb 0c                	jmp    801024d3 <read_head+0x37>
801024c7:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801024cb:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
801024d2:	42                   	inc    %edx
801024d3:	39 d3                	cmp    %edx,%ebx
801024d5:	7f f0                	jg     801024c7 <read_head+0x2b>
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	50                   	push   %eax
801024db:	e8 f3 dc ff ff       	call   801001d3 <brelse>
801024e0:	83 c4 10             	add    $0x10,%esp
801024e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e6:	c9                   	leave  
801024e7:	c3                   	ret    

801024e8 <install_trans>:
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	57                   	push   %edi
801024ec:	56                   	push   %esi
801024ed:	53                   	push   %ebx
801024ee:	83 ec 0c             	sub    $0xc,%esp
801024f1:	be 00 00 00 00       	mov    $0x0,%esi
801024f6:	eb 62                	jmp    8010255a <install_trans+0x72>
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102500:	40                   	inc    %eax
80102501:	83 ec 08             	sub    $0x8,%esp
80102504:	50                   	push   %eax
80102505:	ff 35 e4 16 11 80    	push   0x801116e4
8010250b:	e8 5a dc ff ff       	call   8010016a <bread>
80102510:	89 c7                	mov    %eax,%edi
80102512:	83 c4 08             	add    $0x8,%esp
80102515:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
8010251c:	ff 35 e4 16 11 80    	push   0x801116e4
80102522:	e8 43 dc ff ff       	call   8010016a <bread>
80102527:	89 c3                	mov    %eax,%ebx
80102529:	8d 57 5c             	lea    0x5c(%edi),%edx
8010252c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010252f:	83 c4 0c             	add    $0xc,%esp
80102532:	68 00 02 00 00       	push   $0x200
80102537:	52                   	push   %edx
80102538:	50                   	push   %eax
80102539:	e8 cd 17 00 00       	call   80103d0b <memmove>
8010253e:	89 1c 24             	mov    %ebx,(%esp)
80102541:	e8 52 dc ff ff       	call   80100198 <bwrite>
80102546:	89 3c 24             	mov    %edi,(%esp)
80102549:	e8 85 dc ff ff       	call   801001d3 <brelse>
8010254e:	89 1c 24             	mov    %ebx,(%esp)
80102551:	e8 7d dc ff ff       	call   801001d3 <brelse>
80102556:	46                   	inc    %esi
80102557:	83 c4 10             	add    $0x10,%esp
8010255a:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102560:	7f 96                	jg     801024f8 <install_trans+0x10>
80102562:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102565:	5b                   	pop    %ebx
80102566:	5e                   	pop    %esi
80102567:	5f                   	pop    %edi
80102568:	5d                   	pop    %ebp
80102569:	c3                   	ret    

8010256a <write_head>:
8010256a:	55                   	push   %ebp
8010256b:	89 e5                	mov    %esp,%ebp
8010256d:	53                   	push   %ebx
8010256e:	83 ec 0c             	sub    $0xc,%esp
80102571:	ff 35 d4 16 11 80    	push   0x801116d4
80102577:	ff 35 e4 16 11 80    	push   0x801116e4
8010257d:	e8 e8 db ff ff       	call   8010016a <bread>
80102582:	89 c3                	mov    %eax,%ebx
80102584:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
8010258a:	89 48 5c             	mov    %ecx,0x5c(%eax)
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	b8 00 00 00 00       	mov    $0x0,%eax
80102595:	eb 0c                	jmp    801025a3 <write_head+0x39>
80102597:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
8010259e:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
801025a2:	40                   	inc    %eax
801025a3:	39 c1                	cmp    %eax,%ecx
801025a5:	7f f0                	jg     80102597 <write_head+0x2d>
801025a7:	83 ec 0c             	sub    $0xc,%esp
801025aa:	53                   	push   %ebx
801025ab:	e8 e8 db ff ff       	call   80100198 <bwrite>
801025b0:	89 1c 24             	mov    %ebx,(%esp)
801025b3:	e8 1b dc ff ff       	call   801001d3 <brelse>
801025b8:	83 c4 10             	add    $0x10,%esp
801025bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025be:	c9                   	leave  
801025bf:	c3                   	ret    

801025c0 <recover_from_log>:
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 08             	sub    $0x8,%esp
801025c6:	e8 d1 fe ff ff       	call   8010249c <read_head>
801025cb:	e8 18 ff ff ff       	call   801024e8 <install_trans>
801025d0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801025d7:	00 00 00 
801025da:	e8 8b ff ff ff       	call   8010256a <write_head>
801025df:	c9                   	leave  
801025e0:	c3                   	ret    

801025e1 <write_log>:
801025e1:	55                   	push   %ebp
801025e2:	89 e5                	mov    %esp,%ebp
801025e4:	57                   	push   %edi
801025e5:	56                   	push   %esi
801025e6:	53                   	push   %ebx
801025e7:	83 ec 0c             	sub    $0xc,%esp
801025ea:	be 00 00 00 00       	mov    $0x0,%esi
801025ef:	eb 62                	jmp    80102653 <write_log+0x72>
801025f1:	89 f0                	mov    %esi,%eax
801025f3:	03 05 d4 16 11 80    	add    0x801116d4,%eax
801025f9:	40                   	inc    %eax
801025fa:	83 ec 08             	sub    $0x8,%esp
801025fd:	50                   	push   %eax
801025fe:	ff 35 e4 16 11 80    	push   0x801116e4
80102604:	e8 61 db ff ff       	call   8010016a <bread>
80102609:	89 c3                	mov    %eax,%ebx
8010260b:	83 c4 08             	add    $0x8,%esp
8010260e:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
80102615:	ff 35 e4 16 11 80    	push   0x801116e4
8010261b:	e8 4a db ff ff       	call   8010016a <bread>
80102620:	89 c7                	mov    %eax,%edi
80102622:	8d 50 5c             	lea    0x5c(%eax),%edx
80102625:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102628:	83 c4 0c             	add    $0xc,%esp
8010262b:	68 00 02 00 00       	push   $0x200
80102630:	52                   	push   %edx
80102631:	50                   	push   %eax
80102632:	e8 d4 16 00 00       	call   80103d0b <memmove>
80102637:	89 1c 24             	mov    %ebx,(%esp)
8010263a:	e8 59 db ff ff       	call   80100198 <bwrite>
8010263f:	89 3c 24             	mov    %edi,(%esp)
80102642:	e8 8c db ff ff       	call   801001d3 <brelse>
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 84 db ff ff       	call   801001d3 <brelse>
8010264f:	46                   	inc    %esi
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102659:	7f 96                	jg     801025f1 <write_log+0x10>
8010265b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010265e:	5b                   	pop    %ebx
8010265f:	5e                   	pop    %esi
80102660:	5f                   	pop    %edi
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    

80102663 <commit>:
80102663:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
8010266a:	7f 01                	jg     8010266d <commit+0xa>
8010266c:	c3                   	ret    
8010266d:	55                   	push   %ebp
8010266e:	89 e5                	mov    %esp,%ebp
80102670:	83 ec 08             	sub    $0x8,%esp
80102673:	e8 69 ff ff ff       	call   801025e1 <write_log>
80102678:	e8 ed fe ff ff       	call   8010256a <write_head>
8010267d:	e8 66 fe ff ff       	call   801024e8 <install_trans>
80102682:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102689:	00 00 00 
8010268c:	e8 d9 fe ff ff       	call   8010256a <write_head>
80102691:	c9                   	leave  
80102692:	c3                   	ret    

80102693 <initlog>:
80102693:	55                   	push   %ebp
80102694:	89 e5                	mov    %esp,%ebp
80102696:	53                   	push   %ebx
80102697:	83 ec 2c             	sub    $0x2c,%esp
8010269a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010269d:	68 e0 6c 10 80       	push   $0x80106ce0
801026a2:	68 a0 16 11 80       	push   $0x801116a0
801026a7:	e8 fe 13 00 00       	call   80103aaa <initlock>
801026ac:	83 c4 08             	add    $0x8,%esp
801026af:	8d 45 dc             	lea    -0x24(%ebp),%eax
801026b2:	50                   	push   %eax
801026b3:	53                   	push   %ebx
801026b4:	e8 0e eb ff ff       	call   801011c7 <readsb>
801026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801026bc:	a3 d4 16 11 80       	mov    %eax,0x801116d4
801026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801026c4:	a3 d8 16 11 80       	mov    %eax,0x801116d8
801026c9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
801026cf:	e8 ec fe ff ff       	call   801025c0 <recover_from_log>
801026d4:	83 c4 10             	add    $0x10,%esp
801026d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026da:	c9                   	leave  
801026db:	c3                   	ret    

801026dc <begin_op>:
801026dc:	55                   	push   %ebp
801026dd:	89 e5                	mov    %esp,%ebp
801026df:	83 ec 14             	sub    $0x14,%esp
801026e2:	68 a0 16 11 80       	push   $0x801116a0
801026e7:	e8 f5 14 00 00       	call   80103be1 <acquire>
801026ec:	83 c4 10             	add    $0x10,%esp
801026ef:	eb 15                	jmp    80102706 <begin_op+0x2a>
801026f1:	83 ec 08             	sub    $0x8,%esp
801026f4:	68 a0 16 11 80       	push   $0x801116a0
801026f9:	68 a0 16 11 80       	push   $0x801116a0
801026fe:	e8 b9 0f 00 00       	call   801036bc <sleep>
80102703:	83 c4 10             	add    $0x10,%esp
80102706:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
8010270d:	75 e2                	jne    801026f1 <begin_op+0x15>
8010270f:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102714:	8d 48 01             	lea    0x1(%eax),%ecx
80102717:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
8010271b:	8d 04 12             	lea    (%edx,%edx,1),%eax
8010271e:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102724:	83 f8 1e             	cmp    $0x1e,%eax
80102727:	7e 17                	jle    80102740 <begin_op+0x64>
80102729:	83 ec 08             	sub    $0x8,%esp
8010272c:	68 a0 16 11 80       	push   $0x801116a0
80102731:	68 a0 16 11 80       	push   $0x801116a0
80102736:	e8 81 0f 00 00       	call   801036bc <sleep>
8010273b:	83 c4 10             	add    $0x10,%esp
8010273e:	eb c6                	jmp    80102706 <begin_op+0x2a>
80102740:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	68 a0 16 11 80       	push   $0x801116a0
8010274e:	e8 f3 14 00 00       	call   80103c46 <release>
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	c9                   	leave  
80102757:	c3                   	ret    

80102758 <end_op>:
80102758:	55                   	push   %ebp
80102759:	89 e5                	mov    %esp,%ebp
8010275b:	53                   	push   %ebx
8010275c:	83 ec 10             	sub    $0x10,%esp
8010275f:	68 a0 16 11 80       	push   $0x801116a0
80102764:	e8 78 14 00 00       	call   80103be1 <acquire>
80102769:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010276e:	48                   	dec    %eax
8010276f:	a3 dc 16 11 80       	mov    %eax,0x801116dc
80102774:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
8010277a:	83 c4 10             	add    $0x10,%esp
8010277d:	85 db                	test   %ebx,%ebx
8010277f:	75 2c                	jne    801027ad <end_op+0x55>
80102781:	85 c0                	test   %eax,%eax
80102783:	75 35                	jne    801027ba <end_op+0x62>
80102785:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
8010278c:	00 00 00 
8010278f:	bb 01 00 00 00       	mov    $0x1,%ebx
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 a0 16 11 80       	push   $0x801116a0
8010279c:	e8 a5 14 00 00       	call   80103c46 <release>
801027a1:	83 c4 10             	add    $0x10,%esp
801027a4:	85 db                	test   %ebx,%ebx
801027a6:	75 24                	jne    801027cc <end_op+0x74>
801027a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ab:	c9                   	leave  
801027ac:	c3                   	ret    
801027ad:	83 ec 0c             	sub    $0xc,%esp
801027b0:	68 e4 6c 10 80       	push   $0x80106ce4
801027b5:	e8 87 db ff ff       	call   80100341 <panic>
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	68 a0 16 11 80       	push   $0x801116a0
801027c2:	e8 7a 10 00 00       	call   80103841 <wakeup>
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	eb c8                	jmp    80102794 <end_op+0x3c>
801027cc:	e8 92 fe ff ff       	call   80102663 <commit>
801027d1:	83 ec 0c             	sub    $0xc,%esp
801027d4:	68 a0 16 11 80       	push   $0x801116a0
801027d9:	e8 03 14 00 00       	call   80103be1 <acquire>
801027de:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
801027e5:	00 00 00 
801027e8:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027ef:	e8 4d 10 00 00       	call   80103841 <wakeup>
801027f4:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027fb:	e8 46 14 00 00       	call   80103c46 <release>
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	eb a3                	jmp    801027a8 <end_op+0x50>

80102805 <log_write>:
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
80102808:	53                   	push   %ebx
80102809:	83 ec 04             	sub    $0x4,%esp
8010280c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010280f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102815:	83 fa 1d             	cmp    $0x1d,%edx
80102818:	7f 2a                	jg     80102844 <log_write+0x3f>
8010281a:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010281f:	48                   	dec    %eax
80102820:	39 c2                	cmp    %eax,%edx
80102822:	7d 20                	jge    80102844 <log_write+0x3f>
80102824:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
8010282b:	7e 24                	jle    80102851 <log_write+0x4c>
8010282d:	83 ec 0c             	sub    $0xc,%esp
80102830:	68 a0 16 11 80       	push   $0x801116a0
80102835:	e8 a7 13 00 00       	call   80103be1 <acquire>
8010283a:	83 c4 10             	add    $0x10,%esp
8010283d:	b8 00 00 00 00       	mov    $0x0,%eax
80102842:	eb 1b                	jmp    8010285f <log_write+0x5a>
80102844:	83 ec 0c             	sub    $0xc,%esp
80102847:	68 f3 6c 10 80       	push   $0x80106cf3
8010284c:	e8 f0 da ff ff       	call   80100341 <panic>
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 09 6d 10 80       	push   $0x80106d09
80102859:	e8 e3 da ff ff       	call   80100341 <panic>
8010285e:	40                   	inc    %eax
8010285f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102865:	39 c2                	cmp    %eax,%edx
80102867:	7e 0c                	jle    80102875 <log_write+0x70>
80102869:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010286c:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102873:	75 e9                	jne    8010285e <log_write+0x59>
80102875:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102878:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
8010287f:	39 c2                	cmp    %eax,%edx
80102881:	74 18                	je     8010289b <log_write+0x96>
80102883:	83 0b 04             	orl    $0x4,(%ebx)
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	68 a0 16 11 80       	push   $0x801116a0
8010288e:	e8 b3 13 00 00       	call   80103c46 <release>
80102893:	83 c4 10             	add    $0x10,%esp
80102896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102899:	c9                   	leave  
8010289a:	c3                   	ret    
8010289b:	42                   	inc    %edx
8010289c:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801028a2:	eb df                	jmp    80102883 <log_write+0x7e>

801028a4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801028a4:	55                   	push   %ebp
801028a5:	89 e5                	mov    %esp,%ebp
801028a7:	53                   	push   %ebx
801028a8:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801028ab:	68 8e 00 00 00       	push   $0x8e
801028b0:	68 8c a4 10 80       	push   $0x8010a48c
801028b5:	68 00 70 00 80       	push   $0x80007000
801028ba:	e8 4c 14 00 00       	call   80103d0b <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801028bf:	83 c4 10             	add    $0x10,%esp
801028c2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801028c7:	eb 06                	jmp    801028cf <startothers+0x2b>
801028c9:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801028cf:	8b 15 84 17 11 80    	mov    0x80111784,%edx
801028d5:	8d 04 92             	lea    (%edx,%edx,4),%eax
801028d8:	01 c0                	add    %eax,%eax
801028da:	01 d0                	add    %edx,%eax
801028dc:	c1 e0 04             	shl    $0x4,%eax
801028df:	05 a0 17 11 80       	add    $0x801117a0,%eax
801028e4:	39 d8                	cmp    %ebx,%eax
801028e6:	76 4c                	jbe    80102934 <startothers+0x90>
    if(c == mycpu())  // We've started already.
801028e8:	e8 a0 07 00 00       	call   8010308d <mycpu>
801028ed:	39 c3                	cmp    %eax,%ebx
801028ef:	74 d8                	je     801028c9 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801028f1:	e8 31 f7 ff ff       	call   80102027 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801028f6:	05 00 10 00 00       	add    $0x1000,%eax
801028fb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102900:	c7 05 f8 6f 00 80 93 	movl   $0x80102993,0x80006ff8
80102907:	29 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010290a:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102911:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102914:	83 ec 08             	sub    $0x8,%esp
80102917:	68 00 70 00 00       	push   $0x7000
8010291c:	0f b6 03             	movzbl (%ebx),%eax
8010291f:	50                   	push   %eax
80102920:	e8 f6 f9 ff ff       	call   8010231b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102925:	83 c4 10             	add    $0x10,%esp
80102928:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010292e:	85 c0                	test   %eax,%eax
80102930:	74 f6                	je     80102928 <startothers+0x84>
80102932:	eb 95                	jmp    801028c9 <startothers+0x25>
      ;
  }
}
80102934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102937:	c9                   	leave  
80102938:	c3                   	ret    

80102939 <mpmain>:
{
80102939:	55                   	push   %ebp
8010293a:	89 e5                	mov    %esp,%ebp
8010293c:	53                   	push   %ebx
8010293d:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102940:	e8 ac 07 00 00       	call   801030f1 <cpuid>
80102945:	89 c3                	mov    %eax,%ebx
80102947:	e8 a5 07 00 00       	call   801030f1 <cpuid>
8010294c:	83 ec 04             	sub    $0x4,%esp
8010294f:	53                   	push   %ebx
80102950:	50                   	push   %eax
80102951:	68 24 6d 10 80       	push   $0x80106d24
80102956:	e8 7f dc ff ff       	call   801005da <cprintf>
  idtinit();       // load idt register
8010295b:	e8 92 25 00 00       	call   80104ef2 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102960:	e8 28 07 00 00       	call   8010308d <mycpu>
80102965:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102967:	b8 01 00 00 00       	mov    $0x1,%eax
8010296c:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102973:	e8 79 07 00 00       	call   801030f1 <cpuid>
80102978:	89 c3                	mov    %eax,%ebx
8010297a:	e8 72 07 00 00       	call   801030f1 <cpuid>
8010297f:	83 c4 0c             	add    $0xc,%esp
80102982:	53                   	push   %ebx
80102983:	50                   	push   %eax
80102984:	68 24 6d 10 80       	push   $0x80106d24
80102989:	e8 4c dc ff ff       	call   801005da <cprintf>
  scheduler();     // start running processes
8010298e:	e8 da 0a 00 00       	call   8010346d <scheduler>

80102993 <mpenter>:
{
80102993:	55                   	push   %ebp
80102994:	89 e5                	mov    %esp,%ebp
80102996:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102999:	e8 e9 37 00 00       	call   80106187 <switchkvm>
  seginit();
8010299e:	e8 9e 34 00 00       	call   80105e41 <seginit>
  lapicinit();
801029a3:	e8 2f f8 ff ff       	call   801021d7 <lapicinit>
  mpmain();
801029a8:	e8 8c ff ff ff       	call   80102939 <mpmain>

801029ad <main>:
{
801029ad:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801029b1:	83 e4 f0             	and    $0xfffffff0,%esp
801029b4:	ff 71 fc             	push   -0x4(%ecx)
801029b7:	55                   	push   %ebp
801029b8:	89 e5                	mov    %esp,%ebp
801029ba:	51                   	push   %ecx
801029bb:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801029be:	68 00 00 40 80       	push   $0x80400000
801029c3:	68 30 58 11 80       	push   $0x80115830
801029c8:	e8 08 f6 ff ff       	call   80101fd5 <kinit1>
  kvmalloc();      // kernel page table
801029cd:	e8 84 3c 00 00       	call   80106656 <kvmalloc>
  mpinit();        // detect other processors
801029d2:	e8 b8 01 00 00       	call   80102b8f <mpinit>
  lapicinit();     // interrupt controller
801029d7:	e8 fb f7 ff ff       	call   801021d7 <lapicinit>
  seginit();       // segment descriptors
801029dc:	e8 60 34 00 00       	call   80105e41 <seginit>
  picinit();       // disable pic
801029e1:	e8 79 02 00 00       	call   80102c5f <picinit>
  ioapicinit();    // another interrupt controller
801029e6:	e8 78 f4 ff ff       	call   80101e63 <ioapicinit>
  consoleinit();   // console hardware
801029eb:	e8 5c de ff ff       	call   8010084c <consoleinit>
  uartinit();      // serial port
801029f0:	e8 c4 28 00 00       	call   801052b9 <uartinit>
  pinit();         // process table
801029f5:	e8 79 06 00 00       	call   80103073 <pinit>
  tvinit();        // trap vectors
801029fa:	e8 f6 23 00 00       	call   80104df5 <tvinit>
  binit();         // buffer cache
801029ff:	e8 ee d6 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102a04:	e8 c3 e1 ff ff       	call   80100bcc <fileinit>
  ideinit();       // disk 
80102a09:	e8 6b f2 ff ff       	call   80101c79 <ideinit>
  startothers();   // start other processors
80102a0e:	e8 91 fe ff ff       	call   801028a4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102a13:	83 c4 08             	add    $0x8,%esp
80102a16:	68 00 00 00 8e       	push   $0x8e000000
80102a1b:	68 00 00 40 80       	push   $0x80400000
80102a20:	e8 e2 f5 ff ff       	call   80102007 <kinit2>
  userinit();      // first user process
80102a25:	e8 93 07 00 00       	call   801031bd <userinit>
  mpmain();        // finish this processor's setup
80102a2a:	e8 0a ff ff ff       	call   80102939 <mpmain>

80102a2f <sum>:
80102a2f:	55                   	push   %ebp
80102a30:	89 e5                	mov    %esp,%ebp
80102a32:	56                   	push   %esi
80102a33:	53                   	push   %ebx
80102a34:	89 c6                	mov    %eax,%esi
80102a36:	b8 00 00 00 00       	mov    $0x0,%eax
80102a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
80102a40:	eb 07                	jmp    80102a49 <sum+0x1a>
80102a42:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102a46:	01 d8                	add    %ebx,%eax
80102a48:	41                   	inc    %ecx
80102a49:	39 d1                	cmp    %edx,%ecx
80102a4b:	7c f5                	jl     80102a42 <sum+0x13>
80102a4d:	5b                   	pop    %ebx
80102a4e:	5e                   	pop    %esi
80102a4f:	5d                   	pop    %ebp
80102a50:	c3                   	ret    

80102a51 <mpsearch1>:
80102a51:	55                   	push   %ebp
80102a52:	89 e5                	mov    %esp,%ebp
80102a54:	56                   	push   %esi
80102a55:	53                   	push   %ebx
80102a56:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102a5c:	89 f3                	mov    %esi,%ebx
80102a5e:	01 d6                	add    %edx,%esi
80102a60:	eb 03                	jmp    80102a65 <mpsearch1+0x14>
80102a62:	83 c3 10             	add    $0x10,%ebx
80102a65:	39 f3                	cmp    %esi,%ebx
80102a67:	73 29                	jae    80102a92 <mpsearch1+0x41>
80102a69:	83 ec 04             	sub    $0x4,%esp
80102a6c:	6a 04                	push   $0x4
80102a6e:	68 38 6d 10 80       	push   $0x80106d38
80102a73:	53                   	push   %ebx
80102a74:	e8 5f 12 00 00       	call   80103cd8 <memcmp>
80102a79:	83 c4 10             	add    $0x10,%esp
80102a7c:	85 c0                	test   %eax,%eax
80102a7e:	75 e2                	jne    80102a62 <mpsearch1+0x11>
80102a80:	ba 10 00 00 00       	mov    $0x10,%edx
80102a85:	89 d8                	mov    %ebx,%eax
80102a87:	e8 a3 ff ff ff       	call   80102a2f <sum>
80102a8c:	84 c0                	test   %al,%al
80102a8e:	75 d2                	jne    80102a62 <mpsearch1+0x11>
80102a90:	eb 05                	jmp    80102a97 <mpsearch1+0x46>
80102a92:	bb 00 00 00 00       	mov    $0x0,%ebx
80102a97:	89 d8                	mov    %ebx,%eax
80102a99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a9c:	5b                   	pop    %ebx
80102a9d:	5e                   	pop    %esi
80102a9e:	5d                   	pop    %ebp
80102a9f:	c3                   	ret    

80102aa0 <mpsearch>:
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	83 ec 08             	sub    $0x8,%esp
80102aa6:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102aad:	c1 e0 08             	shl    $0x8,%eax
80102ab0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ab7:	09 d0                	or     %edx,%eax
80102ab9:	c1 e0 04             	shl    $0x4,%eax
80102abc:	74 1f                	je     80102add <mpsearch+0x3d>
80102abe:	ba 00 04 00 00       	mov    $0x400,%edx
80102ac3:	e8 89 ff ff ff       	call   80102a51 <mpsearch1>
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	75 0f                	jne    80102adb <mpsearch+0x3b>
80102acc:	ba 00 00 01 00       	mov    $0x10000,%edx
80102ad1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102ad6:	e8 76 ff ff ff       	call   80102a51 <mpsearch1>
80102adb:	c9                   	leave  
80102adc:	c3                   	ret    
80102add:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ae4:	c1 e0 08             	shl    $0x8,%eax
80102ae7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102aee:	09 d0                	or     %edx,%eax
80102af0:	c1 e0 0a             	shl    $0xa,%eax
80102af3:	2d 00 04 00 00       	sub    $0x400,%eax
80102af8:	ba 00 04 00 00       	mov    $0x400,%edx
80102afd:	e8 4f ff ff ff       	call   80102a51 <mpsearch1>
80102b02:	85 c0                	test   %eax,%eax
80102b04:	75 d5                	jne    80102adb <mpsearch+0x3b>
80102b06:	eb c4                	jmp    80102acc <mpsearch+0x2c>

80102b08 <mpconfig>:
80102b08:	55                   	push   %ebp
80102b09:	89 e5                	mov    %esp,%ebp
80102b0b:	57                   	push   %edi
80102b0c:	56                   	push   %esi
80102b0d:	53                   	push   %ebx
80102b0e:	83 ec 1c             	sub    $0x1c,%esp
80102b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102b14:	e8 87 ff ff ff       	call   80102aa0 <mpsearch>
80102b19:	89 c3                	mov    %eax,%ebx
80102b1b:	85 c0                	test   %eax,%eax
80102b1d:	74 53                	je     80102b72 <mpconfig+0x6a>
80102b1f:	8b 70 04             	mov    0x4(%eax),%esi
80102b22:	85 f6                	test   %esi,%esi
80102b24:	74 50                	je     80102b76 <mpconfig+0x6e>
80102b26:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
80102b2c:	83 ec 04             	sub    $0x4,%esp
80102b2f:	6a 04                	push   $0x4
80102b31:	68 3d 6d 10 80       	push   $0x80106d3d
80102b36:	57                   	push   %edi
80102b37:	e8 9c 11 00 00       	call   80103cd8 <memcmp>
80102b3c:	83 c4 10             	add    $0x10,%esp
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	75 37                	jne    80102b7a <mpconfig+0x72>
80102b43:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102b49:	3c 01                	cmp    $0x1,%al
80102b4b:	74 04                	je     80102b51 <mpconfig+0x49>
80102b4d:	3c 04                	cmp    $0x4,%al
80102b4f:	75 30                	jne    80102b81 <mpconfig+0x79>
80102b51:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102b58:	89 f8                	mov    %edi,%eax
80102b5a:	e8 d0 fe ff ff       	call   80102a2f <sum>
80102b5f:	84 c0                	test   %al,%al
80102b61:	75 25                	jne    80102b88 <mpconfig+0x80>
80102b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102b66:	89 18                	mov    %ebx,(%eax)
80102b68:	89 f8                	mov    %edi,%eax
80102b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b6d:	5b                   	pop    %ebx
80102b6e:	5e                   	pop    %esi
80102b6f:	5f                   	pop    %edi
80102b70:	5d                   	pop    %ebp
80102b71:	c3                   	ret    
80102b72:	89 c7                	mov    %eax,%edi
80102b74:	eb f2                	jmp    80102b68 <mpconfig+0x60>
80102b76:	89 f7                	mov    %esi,%edi
80102b78:	eb ee                	jmp    80102b68 <mpconfig+0x60>
80102b7a:	bf 00 00 00 00       	mov    $0x0,%edi
80102b7f:	eb e7                	jmp    80102b68 <mpconfig+0x60>
80102b81:	bf 00 00 00 00       	mov    $0x0,%edi
80102b86:	eb e0                	jmp    80102b68 <mpconfig+0x60>
80102b88:	bf 00 00 00 00       	mov    $0x0,%edi
80102b8d:	eb d9                	jmp    80102b68 <mpconfig+0x60>

80102b8f <mpinit>:
80102b8f:	55                   	push   %ebp
80102b90:	89 e5                	mov    %esp,%ebp
80102b92:	57                   	push   %edi
80102b93:	56                   	push   %esi
80102b94:	53                   	push   %ebx
80102b95:	83 ec 1c             	sub    $0x1c,%esp
80102b98:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102b9b:	e8 68 ff ff ff       	call   80102b08 <mpconfig>
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	74 19                	je     80102bbd <mpinit+0x2e>
80102ba4:	8b 50 24             	mov    0x24(%eax),%edx
80102ba7:	89 15 80 16 11 80    	mov    %edx,0x80111680
80102bad:	8d 50 2c             	lea    0x2c(%eax),%edx
80102bb0:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102bb4:	01 c1                	add    %eax,%ecx
80102bb6:	bf 01 00 00 00       	mov    $0x1,%edi
80102bbb:	eb 20                	jmp    80102bdd <mpinit+0x4e>
80102bbd:	83 ec 0c             	sub    $0xc,%esp
80102bc0:	68 42 6d 10 80       	push   $0x80106d42
80102bc5:	e8 77 d7 ff ff       	call   80100341 <panic>
80102bca:	bf 00 00 00 00       	mov    $0x0,%edi
80102bcf:	eb 0c                	jmp    80102bdd <mpinit+0x4e>
80102bd1:	83 e8 03             	sub    $0x3,%eax
80102bd4:	3c 01                	cmp    $0x1,%al
80102bd6:	76 19                	jbe    80102bf1 <mpinit+0x62>
80102bd8:	bf 00 00 00 00       	mov    $0x0,%edi
80102bdd:	39 ca                	cmp    %ecx,%edx
80102bdf:	73 4a                	jae    80102c2b <mpinit+0x9c>
80102be1:	8a 02                	mov    (%edx),%al
80102be3:	3c 02                	cmp    $0x2,%al
80102be5:	74 37                	je     80102c1e <mpinit+0x8f>
80102be7:	77 e8                	ja     80102bd1 <mpinit+0x42>
80102be9:	84 c0                	test   %al,%al
80102beb:	74 09                	je     80102bf6 <mpinit+0x67>
80102bed:	3c 01                	cmp    $0x1,%al
80102bef:	75 d9                	jne    80102bca <mpinit+0x3b>
80102bf1:	83 c2 08             	add    $0x8,%edx
80102bf4:	eb e7                	jmp    80102bdd <mpinit+0x4e>
80102bf6:	a1 84 17 11 80       	mov    0x80111784,%eax
80102bfb:	83 f8 07             	cmp    $0x7,%eax
80102bfe:	7f 19                	jg     80102c19 <mpinit+0x8a>
80102c00:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102c03:	01 f6                	add    %esi,%esi
80102c05:	01 c6                	add    %eax,%esi
80102c07:	c1 e6 04             	shl    $0x4,%esi
80102c0a:	8a 5a 01             	mov    0x1(%edx),%bl
80102c0d:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
80102c13:	40                   	inc    %eax
80102c14:	a3 84 17 11 80       	mov    %eax,0x80111784
80102c19:	83 c2 14             	add    $0x14,%edx
80102c1c:	eb bf                	jmp    80102bdd <mpinit+0x4e>
80102c1e:	8a 42 01             	mov    0x1(%edx),%al
80102c21:	a2 80 17 11 80       	mov    %al,0x80111780
80102c26:	83 c2 08             	add    $0x8,%edx
80102c29:	eb b2                	jmp    80102bdd <mpinit+0x4e>
80102c2b:	85 ff                	test   %edi,%edi
80102c2d:	74 23                	je     80102c52 <mpinit+0xc3>
80102c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c32:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102c36:	74 12                	je     80102c4a <mpinit+0xbb>
80102c38:	b0 70                	mov    $0x70,%al
80102c3a:	ba 22 00 00 00       	mov    $0x22,%edx
80102c3f:	ee                   	out    %al,(%dx)
80102c40:	ba 23 00 00 00       	mov    $0x23,%edx
80102c45:	ec                   	in     (%dx),%al
80102c46:	83 c8 01             	or     $0x1,%eax
80102c49:	ee                   	out    %al,(%dx)
80102c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4d:	5b                   	pop    %ebx
80102c4e:	5e                   	pop    %esi
80102c4f:	5f                   	pop    %edi
80102c50:	5d                   	pop    %ebp
80102c51:	c3                   	ret    
80102c52:	83 ec 0c             	sub    $0xc,%esp
80102c55:	68 5c 6d 10 80       	push   $0x80106d5c
80102c5a:	e8 e2 d6 ff ff       	call   80100341 <panic>

80102c5f <picinit>:
80102c5f:	f3 0f 1e fb          	endbr32 
80102c63:	b0 ff                	mov    $0xff,%al
80102c65:	ba 21 00 00 00       	mov    $0x21,%edx
80102c6a:	ee                   	out    %al,(%dx)
80102c6b:	ba a1 00 00 00       	mov    $0xa1,%edx
80102c70:	ee                   	out    %al,(%dx)
80102c71:	c3                   	ret    

80102c72 <pipealloc>:
80102c72:	55                   	push   %ebp
80102c73:	89 e5                	mov    %esp,%ebp
80102c75:	57                   	push   %edi
80102c76:	56                   	push   %esi
80102c77:	53                   	push   %ebx
80102c78:	83 ec 0c             	sub    $0xc,%esp
80102c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c7e:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c81:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102c87:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80102c8d:	e8 54 df ff ff       	call   80100be6 <filealloc>
80102c92:	89 03                	mov    %eax,(%ebx)
80102c94:	85 c0                	test   %eax,%eax
80102c96:	0f 84 88 00 00 00    	je     80102d24 <pipealloc+0xb2>
80102c9c:	e8 45 df ff ff       	call   80100be6 <filealloc>
80102ca1:	89 06                	mov    %eax,(%esi)
80102ca3:	85 c0                	test   %eax,%eax
80102ca5:	74 7d                	je     80102d24 <pipealloc+0xb2>
80102ca7:	e8 7b f3 ff ff       	call   80102027 <kalloc>
80102cac:	89 c7                	mov    %eax,%edi
80102cae:	85 c0                	test   %eax,%eax
80102cb0:	74 72                	je     80102d24 <pipealloc+0xb2>
80102cb2:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102cb9:	00 00 00 
80102cbc:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102cc3:	00 00 00 
80102cc6:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102ccd:	00 00 00 
80102cd0:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102cd7:	00 00 00 
80102cda:	83 ec 08             	sub    $0x8,%esp
80102cdd:	68 7b 6d 10 80       	push   $0x80106d7b
80102ce2:	50                   	push   %eax
80102ce3:	e8 c2 0d 00 00       	call   80103aaa <initlock>
80102ce8:	8b 03                	mov    (%ebx),%eax
80102cea:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80102cf0:	8b 03                	mov    (%ebx),%eax
80102cf2:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80102cf6:	8b 03                	mov    (%ebx),%eax
80102cf8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80102cfc:	8b 03                	mov    (%ebx),%eax
80102cfe:	89 78 0c             	mov    %edi,0xc(%eax)
80102d01:	8b 06                	mov    (%esi),%eax
80102d03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80102d09:	8b 06                	mov    (%esi),%eax
80102d0b:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80102d0f:	8b 06                	mov    (%esi),%eax
80102d11:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80102d15:	8b 06                	mov    (%esi),%eax
80102d17:	89 78 0c             	mov    %edi,0xc(%eax)
80102d1a:	83 c4 10             	add    $0x10,%esp
80102d1d:	b8 00 00 00 00       	mov    $0x0,%eax
80102d22:	eb 29                	jmp    80102d4d <pipealloc+0xdb>
80102d24:	8b 03                	mov    (%ebx),%eax
80102d26:	85 c0                	test   %eax,%eax
80102d28:	74 0c                	je     80102d36 <pipealloc+0xc4>
80102d2a:	83 ec 0c             	sub    $0xc,%esp
80102d2d:	50                   	push   %eax
80102d2e:	e8 57 df ff ff       	call   80100c8a <fileclose>
80102d33:	83 c4 10             	add    $0x10,%esp
80102d36:	8b 06                	mov    (%esi),%eax
80102d38:	85 c0                	test   %eax,%eax
80102d3a:	74 19                	je     80102d55 <pipealloc+0xe3>
80102d3c:	83 ec 0c             	sub    $0xc,%esp
80102d3f:	50                   	push   %eax
80102d40:	e8 45 df ff ff       	call   80100c8a <fileclose>
80102d45:	83 c4 10             	add    $0x10,%esp
80102d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d50:	5b                   	pop    %ebx
80102d51:	5e                   	pop    %esi
80102d52:	5f                   	pop    %edi
80102d53:	5d                   	pop    %ebp
80102d54:	c3                   	ret    
80102d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d5a:	eb f1                	jmp    80102d4d <pipealloc+0xdb>

80102d5c <pipeclose>:
80102d5c:	55                   	push   %ebp
80102d5d:	89 e5                	mov    %esp,%ebp
80102d5f:	53                   	push   %ebx
80102d60:	83 ec 10             	sub    $0x10,%esp
80102d63:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d66:	53                   	push   %ebx
80102d67:	e8 75 0e 00 00       	call   80103be1 <acquire>
80102d6c:	83 c4 10             	add    $0x10,%esp
80102d6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102d73:	74 3f                	je     80102db4 <pipeclose+0x58>
80102d75:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102d7c:	00 00 00 
80102d7f:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102d85:	83 ec 0c             	sub    $0xc,%esp
80102d88:	50                   	push   %eax
80102d89:	e8 b3 0a 00 00       	call   80103841 <wakeup>
80102d8e:	83 c4 10             	add    $0x10,%esp
80102d91:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102d98:	75 09                	jne    80102da3 <pipeclose+0x47>
80102d9a:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102da1:	74 2f                	je     80102dd2 <pipeclose+0x76>
80102da3:	83 ec 0c             	sub    $0xc,%esp
80102da6:	53                   	push   %ebx
80102da7:	e8 9a 0e 00 00       	call   80103c46 <release>
80102dac:	83 c4 10             	add    $0x10,%esp
80102daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102db2:	c9                   	leave  
80102db3:	c3                   	ret    
80102db4:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102dbb:	00 00 00 
80102dbe:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102dc4:	83 ec 0c             	sub    $0xc,%esp
80102dc7:	50                   	push   %eax
80102dc8:	e8 74 0a 00 00       	call   80103841 <wakeup>
80102dcd:	83 c4 10             	add    $0x10,%esp
80102dd0:	eb bf                	jmp    80102d91 <pipeclose+0x35>
80102dd2:	83 ec 0c             	sub    $0xc,%esp
80102dd5:	53                   	push   %ebx
80102dd6:	e8 6b 0e 00 00       	call   80103c46 <release>
80102ddb:	89 1c 24             	mov    %ebx,(%esp)
80102dde:	e8 2d f1 ff ff       	call   80101f10 <kfree>
80102de3:	83 c4 10             	add    $0x10,%esp
80102de6:	eb c7                	jmp    80102daf <pipeclose+0x53>

80102de8 <pipewrite>:
80102de8:	55                   	push   %ebp
80102de9:	89 e5                	mov    %esp,%ebp
80102deb:	56                   	push   %esi
80102dec:	53                   	push   %ebx
80102ded:	83 ec 1c             	sub    $0x1c,%esp
80102df0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102df3:	53                   	push   %ebx
80102df4:	e8 e8 0d 00 00       	call   80103be1 <acquire>
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	be 00 00 00 00       	mov    $0x0,%esi
80102e01:	3b 75 10             	cmp    0x10(%ebp),%esi
80102e04:	7c 41                	jl     80102e47 <pipewrite+0x5f>
80102e06:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e0c:	83 ec 0c             	sub    $0xc,%esp
80102e0f:	50                   	push   %eax
80102e10:	e8 2c 0a 00 00       	call   80103841 <wakeup>
80102e15:	89 1c 24             	mov    %ebx,(%esp)
80102e18:	e8 29 0e 00 00       	call   80103c46 <release>
80102e1d:	83 c4 10             	add    $0x10,%esp
80102e20:	8b 45 10             	mov    0x10(%ebp),%eax
80102e23:	eb 5c                	jmp    80102e81 <pipewrite+0x99>
80102e25:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e2b:	83 ec 0c             	sub    $0xc,%esp
80102e2e:	50                   	push   %eax
80102e2f:	e8 0d 0a 00 00       	call   80103841 <wakeup>
80102e34:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e3a:	83 c4 08             	add    $0x8,%esp
80102e3d:	53                   	push   %ebx
80102e3e:	50                   	push   %eax
80102e3f:	e8 78 08 00 00       	call   801036bc <sleep>
80102e44:	83 c4 10             	add    $0x10,%esp
80102e47:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102e4d:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102e53:	05 00 02 00 00       	add    $0x200,%eax
80102e58:	39 c2                	cmp    %eax,%edx
80102e5a:	75 2c                	jne    80102e88 <pipewrite+0xa0>
80102e5c:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e63:	74 0b                	je     80102e70 <pipewrite+0x88>
80102e65:	e8 b8 02 00 00       	call   80103122 <myproc>
80102e6a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102e6e:	74 b5                	je     80102e25 <pipewrite+0x3d>
80102e70:	83 ec 0c             	sub    $0xc,%esp
80102e73:	53                   	push   %ebx
80102e74:	e8 cd 0d 00 00       	call   80103c46 <release>
80102e79:	83 c4 10             	add    $0x10,%esp
80102e7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e81:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e84:	5b                   	pop    %ebx
80102e85:	5e                   	pop    %esi
80102e86:	5d                   	pop    %ebp
80102e87:	c3                   	ret    
80102e88:	8d 42 01             	lea    0x1(%edx),%eax
80102e8b:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102e91:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102e97:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e9a:	8a 04 30             	mov    (%eax,%esi,1),%al
80102e9d:	88 45 f7             	mov    %al,-0x9(%ebp)
80102ea0:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
80102ea4:	46                   	inc    %esi
80102ea5:	e9 57 ff ff ff       	jmp    80102e01 <pipewrite+0x19>

80102eaa <piperead>:
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	57                   	push   %edi
80102eae:	56                   	push   %esi
80102eaf:	53                   	push   %ebx
80102eb0:	83 ec 18             	sub    $0x18,%esp
80102eb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102eb6:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102eb9:	53                   	push   %ebx
80102eba:	e8 22 0d 00 00       	call   80103be1 <acquire>
80102ebf:	83 c4 10             	add    $0x10,%esp
80102ec2:	eb 13                	jmp    80102ed7 <piperead+0x2d>
80102ec4:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102eca:	83 ec 08             	sub    $0x8,%esp
80102ecd:	53                   	push   %ebx
80102ece:	50                   	push   %eax
80102ecf:	e8 e8 07 00 00       	call   801036bc <sleep>
80102ed4:	83 c4 10             	add    $0x10,%esp
80102ed7:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102edd:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102ee3:	75 75                	jne    80102f5a <piperead+0xb0>
80102ee5:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102eeb:	85 f6                	test   %esi,%esi
80102eed:	74 34                	je     80102f23 <piperead+0x79>
80102eef:	e8 2e 02 00 00       	call   80103122 <myproc>
80102ef4:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102ef8:	74 ca                	je     80102ec4 <piperead+0x1a>
80102efa:	83 ec 0c             	sub    $0xc,%esp
80102efd:	53                   	push   %ebx
80102efe:	e8 43 0d 00 00       	call   80103c46 <release>
80102f03:	83 c4 10             	add    $0x10,%esp
80102f06:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102f0b:	eb 43                	jmp    80102f50 <piperead+0xa6>
80102f0d:	8d 50 01             	lea    0x1(%eax),%edx
80102f10:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102f16:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f1b:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80102f1f:	88 04 37             	mov    %al,(%edi,%esi,1)
80102f22:	46                   	inc    %esi
80102f23:	3b 75 10             	cmp    0x10(%ebp),%esi
80102f26:	7d 0e                	jge    80102f36 <piperead+0x8c>
80102f28:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f2e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102f34:	75 d7                	jne    80102f0d <piperead+0x63>
80102f36:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f3c:	83 ec 0c             	sub    $0xc,%esp
80102f3f:	50                   	push   %eax
80102f40:	e8 fc 08 00 00       	call   80103841 <wakeup>
80102f45:	89 1c 24             	mov    %ebx,(%esp)
80102f48:	e8 f9 0c 00 00       	call   80103c46 <release>
80102f4d:	83 c4 10             	add    $0x10,%esp
80102f50:	89 f0                	mov    %esi,%eax
80102f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f55:	5b                   	pop    %ebx
80102f56:	5e                   	pop    %esi
80102f57:	5f                   	pop    %edi
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    
80102f5a:	be 00 00 00 00       	mov    $0x0,%esi
80102f5f:	eb c2                	jmp    80102f23 <piperead+0x79>

80102f61 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80102f61:	55                   	push   %ebp
80102f62:	89 e5                	mov    %esp,%ebp
80102f64:	53                   	push   %ebx
80102f65:	83 ec 10             	sub    $0x10,%esp
  //ptable no solo contiene la tabla de procesos, es un struct que tiene un lock y la propia tabla
  struct proc *p;
  char *sp;

  acquire(&ptable.lock); //Cerrojo para exclusion mutua
80102f68:	68 20 1d 11 80       	push   $0x80111d20
80102f6d:	e8 6f 0c 00 00       	call   80103be1 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) //Busca el primer proceso(PID) libre
80102f72:	83 c4 10             	add    $0x10,%esp
80102f75:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80102f7a:	eb 06                	jmp    80102f82 <allocproc+0x21>
80102f7c:	81 c3 88 00 00 00    	add    $0x88,%ebx
80102f82:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80102f88:	0f 83 80 00 00 00    	jae    8010300e <allocproc+0xad>
    if(p->state == UNUSED)
80102f8e:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80102f92:	75 e8                	jne    80102f7c <allocproc+0x1b>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO; //Pone el estado del nuevo proceso en embrion
80102f94:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++; //nextpid almacena el último PID usado
80102f9b:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80102fa0:	8d 50 01             	lea    0x1(%eax),%edx
80102fa3:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80102fa9:	89 43 10             	mov    %eax,0x10(%ebx)
  p->prio_level = 5; // Asigna prioridad 5 al nuevo proceso
80102fac:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
80102fb3:	00 00 00 

  release(&ptable.lock);
80102fb6:	83 ec 0c             	sub    $0xc,%esp
80102fb9:	68 20 1d 11 80       	push   $0x80111d20
80102fbe:	e8 83 0c 00 00       	call   80103c46 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){ //Busca una pagina libre en el kernel
80102fc3:	e8 5f f0 ff ff       	call   80102027 <kalloc>
80102fc8:	89 43 08             	mov    %eax,0x8(%ebx)
80102fcb:	83 c4 10             	add    $0x10,%esp
80102fce:	85 c0                	test   %eax,%eax
80102fd0:	74 53                	je     80103025 <allocproc+0xc4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE; //Final de la pagina del kernel

  // Leave room for trap frame.
  sp -= sizeof *p->tf; //puntero para el trap frame
80102fd2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp; //Guarda el puntero en tf
80102fd8:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret; //Trapret es la llamada para vaciar le trapframe
80102fdb:	c7 80 b0 0f 00 00 ea 	movl   $0x80104dea,0xfb0(%eax)
80102fe2:	4d 10 80 

  sp -= sizeof *p->context; //Puntero para el contexto(para movernos dentro de los hilos del kernel)
80102fe5:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80102fea:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80102fed:	83 ec 04             	sub    $0x4,%esp
80102ff0:	6a 14                	push   $0x14
80102ff2:	6a 00                	push   $0x0
80102ff4:	50                   	push   %eax
80102ff5:	e8 93 0c 00 00       	call   80103c8d <memset>
  p->context->eip = (uint)forkret;
80102ffa:	8b 43 1c             	mov    0x1c(%ebx),%eax
80102ffd:	c7 40 10 30 30 10 80 	movl   $0x80103030,0x10(%eax)

  return p;
80103004:	83 c4 10             	add    $0x10,%esp
}
80103007:	89 d8                	mov    %ebx,%eax
80103009:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010300c:	c9                   	leave  
8010300d:	c3                   	ret    
  release(&ptable.lock);
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 20 1d 11 80       	push   $0x80111d20
80103016:	e8 2b 0c 00 00       	call   80103c46 <release>
  return 0;
8010301b:	83 c4 10             	add    $0x10,%esp
8010301e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103023:	eb e2                	jmp    80103007 <allocproc+0xa6>
    p->state = UNUSED;
80103025:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010302c:	89 c3                	mov    %eax,%ebx
8010302e:	eb d7                	jmp    80103007 <allocproc+0xa6>

80103030 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103036:	68 20 1d 11 80       	push   $0x80111d20
8010303b:	e8 06 0c 00 00       	call   80103c46 <release>

  if (first) {
80103040:	83 c4 10             	add    $0x10,%esp
80103043:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010304a:	75 02                	jne    8010304e <forkret+0x1e>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010304c:	c9                   	leave  
8010304d:	c3                   	ret    
    first = 0;
8010304e:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103055:	00 00 00 
    iinit(ROOTDEV);
80103058:	83 ec 0c             	sub    $0xc,%esp
8010305b:	6a 01                	push   $0x1
8010305d:	e8 1c e2 ff ff       	call   8010127e <iinit>
    initlog(ROOTDEV);
80103062:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103069:	e8 25 f6 ff ff       	call   80102693 <initlog>
8010306e:	83 c4 10             	add    $0x10,%esp
}
80103071:	eb d9                	jmp    8010304c <forkret+0x1c>

80103073 <pinit>:
{
80103073:	55                   	push   %ebp
80103074:	89 e5                	mov    %esp,%ebp
80103076:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103079:	68 80 6d 10 80       	push   $0x80106d80
8010307e:	68 20 1d 11 80       	push   $0x80111d20
80103083:	e8 22 0a 00 00       	call   80103aaa <initlock>
}
80103088:	83 c4 10             	add    $0x10,%esp
8010308b:	c9                   	leave  
8010308c:	c3                   	ret    

8010308d <mycpu>:
{
8010308d:	55                   	push   %ebp
8010308e:	89 e5                	mov    %esp,%ebp
80103090:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103093:	9c                   	pushf  
80103094:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103095:	f6 c4 02             	test   $0x2,%ah
80103098:	75 2c                	jne    801030c6 <mycpu+0x39>
  apicid = lapicid();
8010309a:	e8 44 f2 ff ff       	call   801022e3 <lapicid>
8010309f:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
801030a1:	ba 00 00 00 00       	mov    $0x0,%edx
801030a6:	39 15 84 17 11 80    	cmp    %edx,0x80111784
801030ac:	7e 25                	jle    801030d3 <mycpu+0x46>
    if (cpus[i].apicid == apicid)
801030ae:	8d 04 92             	lea    (%edx,%edx,4),%eax
801030b1:	01 c0                	add    %eax,%eax
801030b3:	01 d0                	add    %edx,%eax
801030b5:	c1 e0 04             	shl    $0x4,%eax
801030b8:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
801030bf:	39 c8                	cmp    %ecx,%eax
801030c1:	74 1d                	je     801030e0 <mycpu+0x53>
  for (i = 0; i < ncpu; ++i) {
801030c3:	42                   	inc    %edx
801030c4:	eb e0                	jmp    801030a6 <mycpu+0x19>
    panic("mycpu called with interrupts enabled\n");
801030c6:	83 ec 0c             	sub    $0xc,%esp
801030c9:	68 64 6e 10 80       	push   $0x80106e64
801030ce:	e8 6e d2 ff ff       	call   80100341 <panic>
  panic("unknown apicid\n");
801030d3:	83 ec 0c             	sub    $0xc,%esp
801030d6:	68 87 6d 10 80       	push   $0x80106d87
801030db:	e8 61 d2 ff ff       	call   80100341 <panic>
      return &cpus[i];
801030e0:	8d 04 92             	lea    (%edx,%edx,4),%eax
801030e3:	01 c0                	add    %eax,%eax
801030e5:	01 d0                	add    %edx,%eax
801030e7:	c1 e0 04             	shl    $0x4,%eax
801030ea:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801030ef:	c9                   	leave  
801030f0:	c3                   	ret    

801030f1 <cpuid>:
cpuid() {
801030f1:	55                   	push   %ebp
801030f2:	89 e5                	mov    %esp,%ebp
801030f4:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801030f7:	e8 91 ff ff ff       	call   8010308d <mycpu>
801030fc:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103101:	c1 f8 04             	sar    $0x4,%eax
80103104:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103107:	89 ca                	mov    %ecx,%edx
80103109:	c1 e2 05             	shl    $0x5,%edx
8010310c:	29 ca                	sub    %ecx,%edx
8010310e:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103111:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103114:	89 ca                	mov    %ecx,%edx
80103116:	c1 e2 0f             	shl    $0xf,%edx
80103119:	29 ca                	sub    %ecx,%edx
8010311b:	8d 04 90             	lea    (%eax,%edx,4),%eax
8010311e:	f7 d8                	neg    %eax
}
80103120:	c9                   	leave  
80103121:	c3                   	ret    

80103122 <myproc>:
myproc(void) {
80103122:	55                   	push   %ebp
80103123:	89 e5                	mov    %esp,%ebp
80103125:	53                   	push   %ebx
80103126:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103129:	e8 d9 09 00 00       	call   80103b07 <pushcli>
  c = mycpu();
8010312e:	e8 5a ff ff ff       	call   8010308d <mycpu>
  p = c->proc;
80103133:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103139:	e8 04 0a 00 00       	call   80103b42 <popcli>
}
8010313e:	89 d8                	mov    %ebx,%eax
80103140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103143:	c9                   	leave  
80103144:	c3                   	ret    

80103145 <remove_beggining>:
}
80103145:	c3                   	ret    

80103146 <insert_end>:
{
80103146:	55                   	push   %ebp
80103147:	89 e5                	mov    %esp,%ebp
80103149:	8b 55 08             	mov    0x8(%ebp),%edx
  first = ptable.priority_list[level].first_proc;
8010314c:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
80103152:	05 46 04 00 00       	add    $0x446,%eax
  last = ptable.priority_list[level].last_proc;
80103157:	8b 0c c5 28 1d 11 80 	mov    -0x7feee2d8(,%eax,8),%ecx
  if (first == NULL) { //Queue is empty
8010315e:	83 3c c5 24 1d 11 80 	cmpl   $0x0,-0x7feee2dc(,%eax,8)
80103165:	00 
80103166:	74 10                	je     80103178 <insert_end+0x32>
    last->next_proc = p;
80103168:	89 91 84 00 00 00    	mov    %edx,0x84(%ecx)
    p->next_proc = NULL;
8010316e:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
80103175:	00 00 00 
}
80103178:	5d                   	pop    %ebp
80103179:	c3                   	ret    

8010317a <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010317a:	55                   	push   %ebp
8010317b:	89 e5                	mov    %esp,%ebp
8010317d:	56                   	push   %esi
8010317e:	53                   	push   %ebx
8010317f:	89 c6                	mov    %eax,%esi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103181:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103186:	eb 06                	jmp    8010318e <wakeup1+0x14>
80103188:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010318e:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103194:	73 20                	jae    801031b6 <wakeup1+0x3c>
    if(p->state == SLEEPING && p->chan == chan){
80103196:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010319a:	75 ec                	jne    80103188 <wakeup1+0xe>
8010319c:	39 73 20             	cmp    %esi,0x20(%ebx)
8010319f:	75 e7                	jne    80103188 <wakeup1+0xe>
      p->state = RUNNABLE;
801031a1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      insert_end(p);
801031a8:	83 ec 0c             	sub    $0xc,%esp
801031ab:	53                   	push   %ebx
801031ac:	e8 95 ff ff ff       	call   80103146 <insert_end>
801031b1:	83 c4 10             	add    $0x10,%esp
801031b4:	eb d2                	jmp    80103188 <wakeup1+0xe>
    }
}
801031b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031b9:	5b                   	pop    %ebx
801031ba:	5e                   	pop    %esi
801031bb:	5d                   	pop    %ebp
801031bc:	c3                   	ret    

801031bd <userinit>:
{
801031bd:	55                   	push   %ebp
801031be:	89 e5                	mov    %esp,%ebp
801031c0:	53                   	push   %ebx
801031c1:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801031c4:	e8 98 fd ff ff       	call   80102f61 <allocproc>
801031c9:	89 c3                	mov    %eax,%ebx
  initproc = p;
801031cb:	a3 a4 3f 11 80       	mov    %eax,0x80113fa4
  if((p->pgdir = setupkvm()) == 0)
801031d0:	e8 11 34 00 00       	call   801065e6 <setupkvm>
801031d5:	89 43 04             	mov    %eax,0x4(%ebx)
801031d8:	85 c0                	test   %eax,%eax
801031da:	0f 84 be 00 00 00    	je     8010329e <userinit+0xe1>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801031e0:	83 ec 04             	sub    $0x4,%esp
801031e3:	68 2c 00 00 00       	push   $0x2c
801031e8:	68 60 a4 10 80       	push   $0x8010a460
801031ed:	50                   	push   %eax
801031ee:	e8 fe 30 00 00       	call   801062f1 <inituvm>
  p->sz = PGSIZE;
801031f3:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801031f9:	8b 43 18             	mov    0x18(%ebx),%eax
801031fc:	83 c4 0c             	add    $0xc,%esp
801031ff:	6a 4c                	push   $0x4c
80103201:	6a 00                	push   $0x0
80103203:	50                   	push   %eax
80103204:	e8 84 0a 00 00       	call   80103c8d <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103209:	8b 43 18             	mov    0x18(%ebx),%eax
8010320c:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103212:	8b 43 18             	mov    0x18(%ebx),%eax
80103215:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010321b:	8b 43 18             	mov    0x18(%ebx),%eax
8010321e:	8b 50 2c             	mov    0x2c(%eax),%edx
80103221:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103225:	8b 43 18             	mov    0x18(%ebx),%eax
80103228:	8b 50 2c             	mov    0x2c(%eax),%edx
8010322b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010322f:	8b 43 18             	mov    0x18(%ebx),%eax
80103232:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103239:	8b 43 18             	mov    0x18(%ebx),%eax
8010323c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103243:	8b 43 18             	mov    0x18(%ebx),%eax
80103246:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010324d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103250:	83 c4 0c             	add    $0xc,%esp
80103253:	6a 10                	push   $0x10
80103255:	68 b0 6d 10 80       	push   $0x80106db0
8010325a:	50                   	push   %eax
8010325b:	e8 99 0b 00 00       	call   80103df9 <safestrcpy>
  p->cwd = namei("/");
80103260:	c7 04 24 b9 6d 10 80 	movl   $0x80106db9,(%esp)
80103267:	e8 fe e8 ff ff       	call   80101b6a <namei>
8010326c:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010326f:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103276:	e8 66 09 00 00       	call   80103be1 <acquire>
  p->state = RUNNABLE;
8010327b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  insert_end(p);
80103282:	89 1c 24             	mov    %ebx,(%esp)
80103285:	e8 bc fe ff ff       	call   80103146 <insert_end>
  release(&ptable.lock);
8010328a:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103291:	e8 b0 09 00 00       	call   80103c46 <release>
}
80103296:	83 c4 10             	add    $0x10,%esp
80103299:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010329c:	c9                   	leave  
8010329d:	c3                   	ret    
    panic("userinit: out of memory?");
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	68 97 6d 10 80       	push   $0x80106d97
801032a6:	e8 96 d0 ff ff       	call   80100341 <panic>

801032ab <growproc>:
{
801032ab:	55                   	push   %ebp
801032ac:	89 e5                	mov    %esp,%ebp
801032ae:	56                   	push   %esi
801032af:	53                   	push   %ebx
801032b0:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801032b3:	e8 6a fe ff ff       	call   80103122 <myproc>
801032b8:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801032ba:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801032bc:	85 f6                	test   %esi,%esi
801032be:	7f 1b                	jg     801032db <growproc+0x30>
  } else if(n < 0){
801032c0:	78 36                	js     801032f8 <growproc+0x4d>
  curproc->sz = sz;
801032c2:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
801032c4:	8b 43 04             	mov    0x4(%ebx),%eax
801032c7:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801032cc:	0f 22 d8             	mov    %eax,%cr3
  return 0;
801032cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801032d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032d7:	5b                   	pop    %ebx
801032d8:	5e                   	pop    %esi
801032d9:	5d                   	pop    %ebp
801032da:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801032db:	83 ec 04             	sub    $0x4,%esp
801032de:	01 c6                	add    %eax,%esi
801032e0:	56                   	push   %esi
801032e1:	50                   	push   %eax
801032e2:	ff 73 04             	push   0x4(%ebx)
801032e5:	e8 99 31 00 00       	call   80106483 <allocuvm>
801032ea:	83 c4 10             	add    $0x10,%esp
801032ed:	85 c0                	test   %eax,%eax
801032ef:	75 d1                	jne    801032c2 <growproc+0x17>
      return -1;
801032f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032f6:	eb dc                	jmp    801032d4 <growproc+0x29>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801032f8:	83 ec 04             	sub    $0x4,%esp
801032fb:	01 c6                	add    %eax,%esi
801032fd:	56                   	push   %esi
801032fe:	50                   	push   %eax
801032ff:	ff 73 04             	push   0x4(%ebx)
80103302:	e8 ec 30 00 00       	call   801063f3 <deallocuvm>
80103307:	83 c4 10             	add    $0x10,%esp
8010330a:	85 c0                	test   %eax,%eax
8010330c:	75 b4                	jne    801032c2 <growproc+0x17>
      return -1;
8010330e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103313:	eb bf                	jmp    801032d4 <growproc+0x29>

80103315 <fork>:
{
80103315:	55                   	push   %ebp
80103316:	89 e5                	mov    %esp,%ebp
80103318:	57                   	push   %edi
80103319:	56                   	push   %esi
8010331a:	53                   	push   %ebx
8010331b:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010331e:	e8 ff fd ff ff       	call   80103122 <myproc>
80103323:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103325:	e8 37 fc ff ff       	call   80102f61 <allocproc>
8010332a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010332d:	85 c0                	test   %eax,%eax
8010332f:	0f 84 f2 00 00 00    	je     80103427 <fork+0x112>
80103335:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103337:	83 ec 08             	sub    $0x8,%esp
8010333a:	ff 33                	push   (%ebx)
8010333c:	ff 73 04             	push   0x4(%ebx)
8010333f:	e8 55 33 00 00       	call   80106699 <copyuvm>
80103344:	89 47 04             	mov    %eax,0x4(%edi)
80103347:	83 c4 10             	add    $0x10,%esp
8010334a:	85 c0                	test   %eax,%eax
8010334c:	74 2a                	je     80103378 <fork+0x63>
  np->sz = curproc->sz;
8010334e:	8b 03                	mov    (%ebx),%eax
80103350:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103353:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103355:	89 c8                	mov    %ecx,%eax
80103357:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010335a:	8b 73 18             	mov    0x18(%ebx),%esi
8010335d:	8b 79 18             	mov    0x18(%ecx),%edi
80103360:	b9 13 00 00 00       	mov    $0x13,%ecx
80103365:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103367:	8b 40 18             	mov    0x18(%eax),%eax
8010336a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103371:	be 00 00 00 00       	mov    $0x0,%esi
80103376:	eb 27                	jmp    8010339f <fork+0x8a>
    kfree(np->kstack);
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010337e:	ff 73 08             	push   0x8(%ebx)
80103381:	e8 8a eb ff ff       	call   80101f10 <kfree>
    np->kstack = 0;
80103386:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010338d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010339c:	eb 7f                	jmp    8010341d <fork+0x108>
  for(i = 0; i < NOFILE; i++)
8010339e:	46                   	inc    %esi
8010339f:	83 fe 0f             	cmp    $0xf,%esi
801033a2:	7f 1d                	jg     801033c1 <fork+0xac>
    if(curproc->ofile[i])
801033a4:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801033a8:	85 c0                	test   %eax,%eax
801033aa:	74 f2                	je     8010339e <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
801033ac:	83 ec 0c             	sub    $0xc,%esp
801033af:	50                   	push   %eax
801033b0:	e8 92 d8 ff ff       	call   80100c47 <filedup>
801033b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033b8:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801033bc:	83 c4 10             	add    $0x10,%esp
801033bf:	eb dd                	jmp    8010339e <fork+0x89>
  np->cwd = idup(curproc->cwd);
801033c1:	83 ec 0c             	sub    $0xc,%esp
801033c4:	ff 73 68             	push   0x68(%ebx)
801033c7:	e8 0c e1 ff ff       	call   801014d8 <idup>
801033cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801033cf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801033d2:	8d 53 6c             	lea    0x6c(%ebx),%edx
801033d5:	8d 47 6c             	lea    0x6c(%edi),%eax
801033d8:	83 c4 0c             	add    $0xc,%esp
801033db:	6a 10                	push   $0x10
801033dd:	52                   	push   %edx
801033de:	50                   	push   %eax
801033df:	e8 15 0a 00 00       	call   80103df9 <safestrcpy>
  pid = np->pid;
801033e4:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
801033e7:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801033ee:	e8 ee 07 00 00       	call   80103be1 <acquire>
  np->state = RUNNABLE;
801033f3:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->prio_level = curproc->prio_level;
801033fa:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103400:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  insert_end(np);
80103406:	89 3c 24             	mov    %edi,(%esp)
80103409:	e8 38 fd ff ff       	call   80103146 <insert_end>
  release(&ptable.lock);
8010340e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103415:	e8 2c 08 00 00       	call   80103c46 <release>
  return pid;
8010341a:	83 c4 10             	add    $0x10,%esp
}
8010341d:	89 f0                	mov    %esi,%eax
8010341f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5f                   	pop    %edi
80103425:	5d                   	pop    %ebp
80103426:	c3                   	ret    
    return -1;
80103427:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010342c:	eb ef                	jmp    8010341d <fork+0x108>

8010342e <proc_prio>:
{
8010342e:	55                   	push   %ebp
8010342f:	89 e5                	mov    %esp,%ebp
80103431:	53                   	push   %ebx
80103432:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for (q = 0; q < PRIO_LEVELS; q++){
80103435:	bb 00 00 00 00       	mov    $0x0,%ebx
8010343a:	83 fb 09             	cmp    $0x9,%ebx
8010343d:	7f 27                	jg     80103466 <proc_prio+0x38>
    p = ptable.priority_list[q].first_proc;
8010343f:	8b 04 dd 54 3f 11 80 	mov    -0x7feec0ac(,%ebx,8),%eax
    while (p->next_proc != NULL) {
80103446:	89 c2                	mov    %eax,%edx
80103448:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 0c                	je     8010345e <proc_prio+0x30>
      if (p->pid == pid) 
80103452:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103455:	75 ef                	jne    80103446 <proc_prio+0x18>
}
80103457:	89 d8                	mov    %ebx,%eax
80103459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010345c:	c9                   	leave  
8010345d:	c3                   	ret    
    if (p->pid == pid) 
8010345e:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103461:	74 f4                	je     80103457 <proc_prio+0x29>
  for (q = 0; q < PRIO_LEVELS; q++){
80103463:	43                   	inc    %ebx
80103464:	eb d4                	jmp    8010343a <proc_prio+0xc>
  return -1;
80103466:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010346b:	eb ea                	jmp    80103457 <proc_prio+0x29>

8010346d <scheduler>:
{
8010346d:	55                   	push   %ebp
8010346e:	89 e5                	mov    %esp,%ebp
80103470:	56                   	push   %esi
80103471:	53                   	push   %ebx
  struct cpu *c = mycpu();
80103472:	e8 16 fc ff ff       	call   8010308d <mycpu>
80103477:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103479:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103480:	00 00 00 
  int level = 0;
80103483:	eb 5f                	jmp    801034e4 <scheduler+0x77>
    for (level = 0; level < PRIO_LEVELS; level++){
80103485:	40                   	inc    %eax
80103486:	83 f8 09             	cmp    $0x9,%eax
80103489:	7f 49                	jg     801034d4 <scheduler+0x67>
      if ((p = ptable.priority_list[level].first_proc) == NULL)
8010348b:	8b 1c c5 54 3f 11 80 	mov    -0x7feec0ac(,%eax,8),%ebx
80103492:	85 db                	test   %ebx,%ebx
80103494:	74 ef                	je     80103485 <scheduler+0x18>
      c->proc = p;
80103496:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010349c:	83 ec 0c             	sub    $0xc,%esp
8010349f:	53                   	push   %ebx
801034a0:	e8 f0 2c 00 00       	call   80106195 <switchuvm>
      p->state = RUNNING;
801034a5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context); //Esta funcion continúa por el mismo sitio pero en otro proceso, es decir entras por una pila, pero restauras otra
801034ac:	83 c4 08             	add    $0x8,%esp
801034af:	ff 73 1c             	push   0x1c(%ebx)
801034b2:	8d 46 04             	lea    0x4(%esi),%eax
801034b5:	50                   	push   %eax
801034b6:	e8 94 09 00 00       	call   80103e4f <swtch>
      switchkvm();
801034bb:	e8 c7 2c 00 00       	call   80106187 <switchkvm>
      c->proc = 0;
801034c0:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801034c7:	00 00 00 
801034ca:	83 c4 10             	add    $0x10,%esp
      level = 0;
801034cd:	b8 00 00 00 00       	mov    $0x0,%eax
801034d2:	eb b1                	jmp    80103485 <scheduler+0x18>
    release(&ptable.lock);
801034d4:	83 ec 0c             	sub    $0xc,%esp
801034d7:	68 20 1d 11 80       	push   $0x80111d20
801034dc:	e8 65 07 00 00       	call   80103c46 <release>
    sti();
801034e1:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801034e4:	fb                   	sti    
    acquire(&ptable.lock);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	68 20 1d 11 80       	push   $0x80111d20
801034ed:	e8 ef 06 00 00       	call   80103be1 <acquire>
    for (level = 0; level < PRIO_LEVELS; level++){
801034f2:	83 c4 10             	add    $0x10,%esp
801034f5:	b8 00 00 00 00       	mov    $0x0,%eax
801034fa:	eb 8a                	jmp    80103486 <scheduler+0x19>

801034fc <sched>:
{
801034fc:	55                   	push   %ebp
801034fd:	89 e5                	mov    %esp,%ebp
801034ff:	56                   	push   %esi
80103500:	53                   	push   %ebx
  struct proc *p = myproc();
80103501:	e8 1c fc ff ff       	call   80103122 <myproc>
80103506:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	68 20 1d 11 80       	push   $0x80111d20
80103510:	e8 8d 06 00 00       	call   80103ba2 <holding>
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	85 c0                	test   %eax,%eax
8010351a:	74 4f                	je     8010356b <sched+0x6f>
  if(mycpu()->ncli != 1)
8010351c:	e8 6c fb ff ff       	call   8010308d <mycpu>
80103521:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103528:	75 4e                	jne    80103578 <sched+0x7c>
  if(p->state == RUNNING)
8010352a:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
8010352e:	74 55                	je     80103585 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103530:	9c                   	pushf  
80103531:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103532:	f6 c4 02             	test   $0x2,%ah
80103535:	75 5b                	jne    80103592 <sched+0x96>
  intena = mycpu()->intena;
80103537:	e8 51 fb ff ff       	call   8010308d <mycpu>
8010353c:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103542:	e8 46 fb ff ff       	call   8010308d <mycpu>
80103547:	83 ec 08             	sub    $0x8,%esp
8010354a:	ff 70 04             	push   0x4(%eax)
8010354d:	83 c3 1c             	add    $0x1c,%ebx
80103550:	53                   	push   %ebx
80103551:	e8 f9 08 00 00       	call   80103e4f <swtch>
  mycpu()->intena = intena;
80103556:	e8 32 fb ff ff       	call   8010308d <mycpu>
8010355b:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103561:	83 c4 10             	add    $0x10,%esp
80103564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103567:	5b                   	pop    %ebx
80103568:	5e                   	pop    %esi
80103569:	5d                   	pop    %ebp
8010356a:	c3                   	ret    
    panic("sched ptable.lock");
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	68 bb 6d 10 80       	push   $0x80106dbb
80103573:	e8 c9 cd ff ff       	call   80100341 <panic>
    panic("sched locks");
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	68 cd 6d 10 80       	push   $0x80106dcd
80103580:	e8 bc cd ff ff       	call   80100341 <panic>
    panic("sched running");
80103585:	83 ec 0c             	sub    $0xc,%esp
80103588:	68 d9 6d 10 80       	push   $0x80106dd9
8010358d:	e8 af cd ff ff       	call   80100341 <panic>
    panic("sched interruptible");
80103592:	83 ec 0c             	sub    $0xc,%esp
80103595:	68 e7 6d 10 80       	push   $0x80106de7
8010359a:	e8 a2 cd ff ff       	call   80100341 <panic>

8010359f <exit>:
{
8010359f:	55                   	push   %ebp
801035a0:	89 e5                	mov    %esp,%ebp
801035a2:	56                   	push   %esi
801035a3:	53                   	push   %ebx
  struct proc *curproc = myproc();
801035a4:	e8 79 fb ff ff       	call   80103122 <myproc>
  if(curproc == initproc)
801035a9:	39 05 a4 3f 11 80    	cmp    %eax,0x80113fa4
801035af:	74 09                	je     801035ba <exit+0x1b>
801035b1:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
801035b3:	bb 00 00 00 00       	mov    $0x0,%ebx
801035b8:	eb 22                	jmp    801035dc <exit+0x3d>
    panic("init exiting");
801035ba:	83 ec 0c             	sub    $0xc,%esp
801035bd:	68 fb 6d 10 80       	push   $0x80106dfb
801035c2:	e8 7a cd ff ff       	call   80100341 <panic>
      fileclose(curproc->ofile[fd]);
801035c7:	83 ec 0c             	sub    $0xc,%esp
801035ca:	50                   	push   %eax
801035cb:	e8 ba d6 ff ff       	call   80100c8a <fileclose>
      curproc->ofile[fd] = 0;
801035d0:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801035d7:	00 
801035d8:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801035db:	43                   	inc    %ebx
801035dc:	83 fb 0f             	cmp    $0xf,%ebx
801035df:	7f 0a                	jg     801035eb <exit+0x4c>
    if(curproc->ofile[fd]){
801035e1:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801035e5:	85 c0                	test   %eax,%eax
801035e7:	75 de                	jne    801035c7 <exit+0x28>
801035e9:	eb f0                	jmp    801035db <exit+0x3c>
  begin_op();
801035eb:	e8 ec f0 ff ff       	call   801026dc <begin_op>
  iput(curproc->cwd);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	ff 76 68             	push   0x68(%esi)
801035f6:	e8 10 e0 ff ff       	call   8010160b <iput>
  end_op();
801035fb:	e8 58 f1 ff ff       	call   80102758 <end_op>
  curproc->cwd = 0;
80103600:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103607:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010360e:	e8 ce 05 00 00       	call   80103be1 <acquire>
  wakeup1(curproc->parent);
80103613:	8b 46 14             	mov    0x14(%esi),%eax
80103616:	e8 5f fb ff ff       	call   8010317a <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010361b:	83 c4 10             	add    $0x10,%esp
8010361e:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103623:	eb 06                	jmp    8010362b <exit+0x8c>
80103625:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010362b:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103631:	73 1a                	jae    8010364d <exit+0xae>
    if(p->parent == curproc){
80103633:	39 73 14             	cmp    %esi,0x14(%ebx)
80103636:	75 ed                	jne    80103625 <exit+0x86>
      p->parent = initproc;
80103638:	a1 a4 3f 11 80       	mov    0x80113fa4,%eax
8010363d:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103640:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103644:	75 df                	jne    80103625 <exit+0x86>
        wakeup1(initproc);
80103646:	e8 2f fb ff ff       	call   8010317a <wakeup1>
8010364b:	eb d8                	jmp    80103625 <exit+0x86>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
8010364d:	83 ec 04             	sub    $0x4,%esp
80103650:	6a 00                	push   $0x0
80103652:	68 00 00 00 80       	push   $0x80000000
80103657:	ff 76 04             	push   0x4(%esi)
8010365a:	e8 94 2d 00 00       	call   801063f3 <deallocuvm>
  curproc->exit_status = exit_status;
8010365f:	8b 45 08             	mov    0x8(%ebp),%eax
80103662:	89 46 7c             	mov    %eax,0x7c(%esi)
  curproc->state = ZOMBIE;
80103665:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010366c:	e8 8b fe ff ff       	call   801034fc <sched>
  panic("zombie exit");
80103671:	c7 04 24 08 6e 10 80 	movl   $0x80106e08,(%esp)
80103678:	e8 c4 cc ff ff       	call   80100341 <panic>

8010367d <yield>:
{
8010367d:	55                   	push   %ebp
8010367e:	89 e5                	mov    %esp,%ebp
80103680:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103683:	68 20 1d 11 80       	push   $0x80111d20
80103688:	e8 54 05 00 00       	call   80103be1 <acquire>
  myproc()->state = RUNNABLE;
8010368d:	e8 90 fa ff ff       	call   80103122 <myproc>
80103692:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insert_end(myproc());
80103699:	e8 84 fa ff ff       	call   80103122 <myproc>
8010369e:	89 04 24             	mov    %eax,(%esp)
801036a1:	e8 a0 fa ff ff       	call   80103146 <insert_end>
  sched();
801036a6:	e8 51 fe ff ff       	call   801034fc <sched>
  release(&ptable.lock);
801036ab:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036b2:	e8 8f 05 00 00       	call   80103c46 <release>
}
801036b7:	83 c4 10             	add    $0x10,%esp
801036ba:	c9                   	leave  
801036bb:	c3                   	ret    

801036bc <sleep>:
{
801036bc:	55                   	push   %ebp
801036bd:	89 e5                	mov    %esp,%ebp
801036bf:	56                   	push   %esi
801036c0:	53                   	push   %ebx
801036c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801036c4:	e8 59 fa ff ff       	call   80103122 <myproc>
  if(p == 0)
801036c9:	85 c0                	test   %eax,%eax
801036cb:	74 66                	je     80103733 <sleep+0x77>
801036cd:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
801036cf:	85 f6                	test   %esi,%esi
801036d1:	74 6d                	je     80103740 <sleep+0x84>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801036d3:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801036d9:	74 18                	je     801036f3 <sleep+0x37>
    acquire(&ptable.lock);  //DOC: sleeplock1
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	68 20 1d 11 80       	push   $0x80111d20
801036e3:	e8 f9 04 00 00       	call   80103be1 <acquire>
    release(lk);
801036e8:	89 34 24             	mov    %esi,(%esp)
801036eb:	e8 56 05 00 00       	call   80103c46 <release>
801036f0:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801036f3:	8b 45 08             	mov    0x8(%ebp),%eax
801036f6:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801036f9:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103700:	e8 f7 fd ff ff       	call   801034fc <sched>
  p->chan = 0;
80103705:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010370c:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103712:	74 18                	je     8010372c <sleep+0x70>
    release(&ptable.lock);
80103714:	83 ec 0c             	sub    $0xc,%esp
80103717:	68 20 1d 11 80       	push   $0x80111d20
8010371c:	e8 25 05 00 00       	call   80103c46 <release>
    acquire(lk);
80103721:	89 34 24             	mov    %esi,(%esp)
80103724:	e8 b8 04 00 00       	call   80103be1 <acquire>
80103729:	83 c4 10             	add    $0x10,%esp
}
8010372c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010372f:	5b                   	pop    %ebx
80103730:	5e                   	pop    %esi
80103731:	5d                   	pop    %ebp
80103732:	c3                   	ret    
    panic("sleep");
80103733:	83 ec 0c             	sub    $0xc,%esp
80103736:	68 14 6e 10 80       	push   $0x80106e14
8010373b:	e8 01 cc ff ff       	call   80100341 <panic>
    panic("sleep without lk");
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	68 1a 6e 10 80       	push   $0x80106e1a
80103748:	e8 f4 cb ff ff       	call   80100341 <panic>

8010374d <wait>:
{
8010374d:	55                   	push   %ebp
8010374e:	89 e5                	mov    %esp,%ebp
80103750:	56                   	push   %esi
80103751:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103752:	e8 cb f9 ff ff       	call   80103122 <myproc>
80103757:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	68 20 1d 11 80       	push   $0x80111d20
80103761:	e8 7b 04 00 00       	call   80103be1 <acquire>
80103766:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103769:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010376e:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103773:	eb 77                	jmp    801037ec <wait+0x9f>
        pid = p->pid;
80103775:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	ff 73 08             	push   0x8(%ebx)
8010377e:	e8 8d e7 ff ff       	call   80101f10 <kfree>
        p->kstack = 0;
80103783:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
8010378a:	83 c4 08             	add    $0x8,%esp
8010378d:	6a 00                	push   $0x0
8010378f:	ff 73 04             	push   0x4(%ebx)
80103792:	e8 d9 2d 00 00       	call   80106570 <freevm>
        p->pid = 0;
80103797:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010379e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801037a5:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801037a9:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801037b0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        if (p->exit_status != 0) {
801037b7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801037ba:	83 c4 10             	add    $0x10,%esp
801037bd:	85 c0                	test   %eax,%eax
801037bf:	74 05                	je     801037c6 <wait+0x79>
          *exit_status = p->exit_status;
801037c1:	8b 55 08             	mov    0x8(%ebp),%edx
801037c4:	89 02                	mov    %eax,(%edx)
        p->exit_status = 0;
801037c6:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        release(&ptable.lock);
801037cd:	83 ec 0c             	sub    $0xc,%esp
801037d0:	68 20 1d 11 80       	push   $0x80111d20
801037d5:	e8 6c 04 00 00       	call   80103c46 <release>
        return pid;
801037da:	83 c4 10             	add    $0x10,%esp
}
801037dd:	89 f0                	mov    %esi,%eax
801037df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e2:	5b                   	pop    %ebx
801037e3:	5e                   	pop    %esi
801037e4:	5d                   	pop    %ebp
801037e5:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037e6:	81 c3 88 00 00 00    	add    $0x88,%ebx
801037ec:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801037f2:	73 16                	jae    8010380a <wait+0xbd>
      if(p->parent != curproc)
801037f4:	39 73 14             	cmp    %esi,0x14(%ebx)
801037f7:	75 ed                	jne    801037e6 <wait+0x99>
      if(p->state == ZOMBIE){
801037f9:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037fd:	0f 84 72 ff ff ff    	je     80103775 <wait+0x28>
      havekids = 1;
80103803:	b8 01 00 00 00       	mov    $0x1,%eax
80103808:	eb dc                	jmp    801037e6 <wait+0x99>
    if(!havekids || curproc->killed){
8010380a:	85 c0                	test   %eax,%eax
8010380c:	74 06                	je     80103814 <wait+0xc7>
8010380e:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103812:	74 17                	je     8010382b <wait+0xde>
      release(&ptable.lock);
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	68 20 1d 11 80       	push   $0x80111d20
8010381c:	e8 25 04 00 00       	call   80103c46 <release>
      return -1;
80103821:	83 c4 10             	add    $0x10,%esp
80103824:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103829:	eb b2                	jmp    801037dd <wait+0x90>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010382b:	83 ec 08             	sub    $0x8,%esp
8010382e:	68 20 1d 11 80       	push   $0x80111d20
80103833:	56                   	push   %esi
80103834:	e8 83 fe ff ff       	call   801036bc <sleep>
    havekids = 0;
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	e9 28 ff ff ff       	jmp    80103769 <wait+0x1c>

80103841 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103841:	55                   	push   %ebp
80103842:	89 e5                	mov    %esp,%ebp
80103844:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103847:	68 20 1d 11 80       	push   $0x80111d20
8010384c:	e8 90 03 00 00       	call   80103be1 <acquire>
  wakeup1(chan);
80103851:	8b 45 08             	mov    0x8(%ebp),%eax
80103854:	e8 21 f9 ff ff       	call   8010317a <wakeup1>
  release(&ptable.lock);
80103859:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103860:	e8 e1 03 00 00       	call   80103c46 <release>
}
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	c9                   	leave  
80103869:	c3                   	ret    

8010386a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010386a:	55                   	push   %ebp
8010386b:	89 e5                	mov    %esp,%ebp
8010386d:	53                   	push   %ebx
8010386e:	83 ec 10             	sub    $0x10,%esp
80103871:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103874:	68 20 1d 11 80       	push   $0x80111d20
80103879:	e8 63 03 00 00       	call   80103be1 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010387e:	83 c4 10             	add    $0x10,%esp
80103881:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103886:	eb 1a                	jmp    801038a2 <kill+0x38>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
80103888:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        insert_end(p);
8010388f:	83 ec 0c             	sub    $0xc,%esp
80103892:	50                   	push   %eax
80103893:	e8 ae f8 ff ff       	call   80103146 <insert_end>
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	eb 1e                	jmp    801038bb <kill+0x51>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010389d:	05 88 00 00 00       	add    $0x88,%eax
801038a2:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
801038a7:	73 2c                	jae    801038d5 <kill+0x6b>
    if(p->pid == pid){
801038a9:	39 58 10             	cmp    %ebx,0x10(%eax)
801038ac:	75 ef                	jne    8010389d <kill+0x33>
      p->killed = 1;
801038ae:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
801038b5:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801038b9:	74 cd                	je     80103888 <kill+0x1e>
      }
      release(&ptable.lock);
801038bb:	83 ec 0c             	sub    $0xc,%esp
801038be:	68 20 1d 11 80       	push   $0x80111d20
801038c3:	e8 7e 03 00 00       	call   80103c46 <release>
      return 0;
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801038d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
  release(&ptable.lock);
801038d5:	83 ec 0c             	sub    $0xc,%esp
801038d8:	68 20 1d 11 80       	push   $0x80111d20
801038dd:	e8 64 03 00 00       	call   80103c46 <release>
  return -1;
801038e2:	83 c4 10             	add    $0x10,%esp
801038e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038ea:	eb e4                	jmp    801038d0 <kill+0x66>

801038ec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801038ec:	55                   	push   %ebp
801038ed:	89 e5                	mov    %esp,%ebp
801038ef:	56                   	push   %esi
801038f0:	53                   	push   %ebx
801038f1:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038f4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801038f9:	eb 36                	jmp    80103931 <procdump+0x45>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801038fb:	b8 2b 6e 10 80       	mov    $0x80106e2b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103900:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103903:	52                   	push   %edx
80103904:	50                   	push   %eax
80103905:	ff 73 10             	push   0x10(%ebx)
80103908:	68 2f 6e 10 80       	push   $0x80106e2f
8010390d:	e8 c8 cc ff ff       	call   801005da <cprintf>
    if(p->state == SLEEPING){
80103912:	83 c4 10             	add    $0x10,%esp
80103915:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103919:	74 3c                	je     80103957 <procdump+0x6b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010391b:	83 ec 0c             	sub    $0xc,%esp
8010391e:	68 2f 72 10 80       	push   $0x8010722f
80103923:	e8 b2 cc ff ff       	call   801005da <cprintf>
80103928:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010392b:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103931:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103937:	73 5f                	jae    80103998 <procdump+0xac>
    if(p->state == UNUSED)
80103939:	8b 43 0c             	mov    0xc(%ebx),%eax
8010393c:	85 c0                	test   %eax,%eax
8010393e:	74 eb                	je     8010392b <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103940:	83 f8 05             	cmp    $0x5,%eax
80103943:	77 b6                	ja     801038fb <procdump+0xf>
80103945:	8b 04 85 8c 6e 10 80 	mov    -0x7fef9174(,%eax,4),%eax
8010394c:	85 c0                	test   %eax,%eax
8010394e:	75 b0                	jne    80103900 <procdump+0x14>
      state = "???";
80103950:	b8 2b 6e 10 80       	mov    $0x80106e2b,%eax
80103955:	eb a9                	jmp    80103900 <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103957:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010395a:	8b 40 0c             	mov    0xc(%eax),%eax
8010395d:	83 c0 08             	add    $0x8,%eax
80103960:	83 ec 08             	sub    $0x8,%esp
80103963:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103966:	52                   	push   %edx
80103967:	50                   	push   %eax
80103968:	e8 58 01 00 00       	call   80103ac5 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010396d:	83 c4 10             	add    $0x10,%esp
80103970:	be 00 00 00 00       	mov    $0x0,%esi
80103975:	eb 12                	jmp    80103989 <procdump+0x9d>
        cprintf(" %p", pc[i]);
80103977:	83 ec 08             	sub    $0x8,%esp
8010397a:	50                   	push   %eax
8010397b:	68 81 68 10 80       	push   $0x80106881
80103980:	e8 55 cc ff ff       	call   801005da <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103985:	46                   	inc    %esi
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	83 fe 09             	cmp    $0x9,%esi
8010398c:	7f 8d                	jg     8010391b <procdump+0x2f>
8010398e:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103992:	85 c0                	test   %eax,%eax
80103994:	75 e1                	jne    80103977 <procdump+0x8b>
80103996:	eb 83                	jmp    8010391b <procdump+0x2f>
  }
}
80103998:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010399b:	5b                   	pop    %ebx
8010399c:	5e                   	pop    %esi
8010399d:	5d                   	pop    %ebp
8010399e:	c3                   	ret    

8010399f <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010399f:	55                   	push   %ebp
801039a0:	89 e5                	mov    %esp,%ebp
801039a2:	53                   	push   %ebx
801039a3:	83 ec 0c             	sub    $0xc,%esp
801039a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801039a9:	68 a4 6e 10 80       	push   $0x80106ea4
801039ae:	8d 43 04             	lea    0x4(%ebx),%eax
801039b1:	50                   	push   %eax
801039b2:	e8 f3 00 00 00       	call   80103aaa <initlock>
  lk->name = name;
801039b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801039ba:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
801039bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801039c3:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
801039ca:	83 c4 10             	add    $0x10,%esp
801039cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d0:	c9                   	leave  
801039d1:	c3                   	ret    

801039d2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801039d2:	55                   	push   %ebp
801039d3:	89 e5                	mov    %esp,%ebp
801039d5:	56                   	push   %esi
801039d6:	53                   	push   %ebx
801039d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801039da:	8d 73 04             	lea    0x4(%ebx),%esi
801039dd:	83 ec 0c             	sub    $0xc,%esp
801039e0:	56                   	push   %esi
801039e1:	e8 fb 01 00 00       	call   80103be1 <acquire>
  while (lk->locked) {
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 0d                	jmp    801039f8 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
801039eb:	83 ec 08             	sub    $0x8,%esp
801039ee:	56                   	push   %esi
801039ef:	53                   	push   %ebx
801039f0:	e8 c7 fc ff ff       	call   801036bc <sleep>
801039f5:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801039f8:	83 3b 00             	cmpl   $0x0,(%ebx)
801039fb:	75 ee                	jne    801039eb <acquiresleep+0x19>
  }
  lk->locked = 1;
801039fd:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103a03:	e8 1a f7 ff ff       	call   80103122 <myproc>
80103a08:	8b 40 10             	mov    0x10(%eax),%eax
80103a0b:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103a0e:	83 ec 0c             	sub    $0xc,%esp
80103a11:	56                   	push   %esi
80103a12:	e8 2f 02 00 00       	call   80103c46 <release>
}
80103a17:	83 c4 10             	add    $0x10,%esp
80103a1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a1d:	5b                   	pop    %ebx
80103a1e:	5e                   	pop    %esi
80103a1f:	5d                   	pop    %ebp
80103a20:	c3                   	ret    

80103a21 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103a21:	55                   	push   %ebp
80103a22:	89 e5                	mov    %esp,%ebp
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a29:	8d 73 04             	lea    0x4(%ebx),%esi
80103a2c:	83 ec 0c             	sub    $0xc,%esp
80103a2f:	56                   	push   %esi
80103a30:	e8 ac 01 00 00       	call   80103be1 <acquire>
  lk->locked = 0;
80103a35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a3b:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103a42:	89 1c 24             	mov    %ebx,(%esp)
80103a45:	e8 f7 fd ff ff       	call   80103841 <wakeup>
  release(&lk->lk);
80103a4a:	89 34 24             	mov    %esi,(%esp)
80103a4d:	e8 f4 01 00 00       	call   80103c46 <release>
}
80103a52:	83 c4 10             	add    $0x10,%esp
80103a55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a58:	5b                   	pop    %ebx
80103a59:	5e                   	pop    %esi
80103a5a:	5d                   	pop    %ebp
80103a5b:	c3                   	ret    

80103a5c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103a5c:	55                   	push   %ebp
80103a5d:	89 e5                	mov    %esp,%ebp
80103a5f:	56                   	push   %esi
80103a60:	53                   	push   %ebx
80103a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103a64:	8d 73 04             	lea    0x4(%ebx),%esi
80103a67:	83 ec 0c             	sub    $0xc,%esp
80103a6a:	56                   	push   %esi
80103a6b:	e8 71 01 00 00       	call   80103be1 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	83 3b 00             	cmpl   $0x0,(%ebx)
80103a76:	75 17                	jne    80103a8f <holdingsleep+0x33>
80103a78:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103a7d:	83 ec 0c             	sub    $0xc,%esp
80103a80:	56                   	push   %esi
80103a81:	e8 c0 01 00 00       	call   80103c46 <release>
  return r;
}
80103a86:	89 d8                	mov    %ebx,%eax
80103a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a8b:	5b                   	pop    %ebx
80103a8c:	5e                   	pop    %esi
80103a8d:	5d                   	pop    %ebp
80103a8e:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103a8f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103a92:	e8 8b f6 ff ff       	call   80103122 <myproc>
80103a97:	3b 58 10             	cmp    0x10(%eax),%ebx
80103a9a:	74 07                	je     80103aa3 <holdingsleep+0x47>
80103a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
80103aa1:	eb da                	jmp    80103a7d <holdingsleep+0x21>
80103aa3:	bb 01 00 00 00       	mov    $0x1,%ebx
80103aa8:	eb d3                	jmp    80103a7d <holdingsleep+0x21>

80103aaa <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103aaa:	55                   	push   %ebp
80103aab:	89 e5                	mov    %esp,%ebp
80103aad:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ab3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103ab6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103abc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103ac3:	5d                   	pop    %ebp
80103ac4:	c3                   	ret    

80103ac5 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103ac5:	55                   	push   %ebp
80103ac6:	89 e5                	mov    %esp,%ebp
80103ac8:	53                   	push   %ebx
80103ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103acc:	8b 45 08             	mov    0x8(%ebp),%eax
80103acf:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103ad2:	b8 00 00 00 00       	mov    $0x0,%eax
80103ad7:	83 f8 09             	cmp    $0x9,%eax
80103ada:	7f 21                	jg     80103afd <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103adc:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103ae2:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103ae8:	77 13                	ja     80103afd <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103aea:	8b 5a 04             	mov    0x4(%edx),%ebx
80103aed:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103af0:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103af2:	40                   	inc    %eax
80103af3:	eb e2                	jmp    80103ad7 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103af5:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103afc:	40                   	inc    %eax
80103afd:	83 f8 09             	cmp    $0x9,%eax
80103b00:	7e f3                	jle    80103af5 <getcallerpcs+0x30>
}
80103b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b05:	c9                   	leave  
80103b06:	c3                   	ret    

80103b07 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103b07:	55                   	push   %ebp
80103b08:	89 e5                	mov    %esp,%ebp
80103b0a:	53                   	push   %ebx
80103b0b:	83 ec 04             	sub    $0x4,%esp
80103b0e:	9c                   	pushf  
80103b0f:	5b                   	pop    %ebx
  asm volatile("cli");
80103b10:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103b11:	e8 77 f5 ff ff       	call   8010308d <mycpu>
80103b16:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103b1d:	74 10                	je     80103b2f <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103b1f:	e8 69 f5 ff ff       	call   8010308d <mycpu>
80103b24:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2d:	c9                   	leave  
80103b2e:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103b2f:	e8 59 f5 ff ff       	call   8010308d <mycpu>
80103b34:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103b3a:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103b40:	eb dd                	jmp    80103b1f <pushcli+0x18>

80103b42 <popcli>:

void
popcli(void)
{
80103b42:	55                   	push   %ebp
80103b43:	89 e5                	mov    %esp,%ebp
80103b45:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b48:	9c                   	pushf  
80103b49:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b4a:	f6 c4 02             	test   $0x2,%ah
80103b4d:	75 28                	jne    80103b77 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103b4f:	e8 39 f5 ff ff       	call   8010308d <mycpu>
80103b54:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103b5a:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103b5d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103b63:	85 d2                	test   %edx,%edx
80103b65:	78 1d                	js     80103b84 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103b67:	e8 21 f5 ff ff       	call   8010308d <mycpu>
80103b6c:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103b73:	74 1c                	je     80103b91 <popcli+0x4f>
    sti();
}
80103b75:	c9                   	leave  
80103b76:	c3                   	ret    
    panic("popcli - interruptible");
80103b77:	83 ec 0c             	sub    $0xc,%esp
80103b7a:	68 af 6e 10 80       	push   $0x80106eaf
80103b7f:	e8 bd c7 ff ff       	call   80100341 <panic>
    panic("popcli");
80103b84:	83 ec 0c             	sub    $0xc,%esp
80103b87:	68 c6 6e 10 80       	push   $0x80106ec6
80103b8c:	e8 b0 c7 ff ff       	call   80100341 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103b91:	e8 f7 f4 ff ff       	call   8010308d <mycpu>
80103b96:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103b9d:	74 d6                	je     80103b75 <popcli+0x33>
  asm volatile("sti");
80103b9f:	fb                   	sti    
}
80103ba0:	eb d3                	jmp    80103b75 <popcli+0x33>

80103ba2 <holding>:
{
80103ba2:	55                   	push   %ebp
80103ba3:	89 e5                	mov    %esp,%ebp
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 04             	sub    $0x4,%esp
80103ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103bac:	e8 56 ff ff ff       	call   80103b07 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103bb1:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bb4:	75 11                	jne    80103bc7 <holding+0x25>
80103bb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103bbb:	e8 82 ff ff ff       	call   80103b42 <popcli>
}
80103bc0:	89 d8                	mov    %ebx,%eax
80103bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc5:	c9                   	leave  
80103bc6:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103bc7:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103bca:	e8 be f4 ff ff       	call   8010308d <mycpu>
80103bcf:	39 c3                	cmp    %eax,%ebx
80103bd1:	74 07                	je     80103bda <holding+0x38>
80103bd3:	bb 00 00 00 00       	mov    $0x0,%ebx
80103bd8:	eb e1                	jmp    80103bbb <holding+0x19>
80103bda:	bb 01 00 00 00       	mov    $0x1,%ebx
80103bdf:	eb da                	jmp    80103bbb <holding+0x19>

80103be1 <acquire>:
{
80103be1:	55                   	push   %ebp
80103be2:	89 e5                	mov    %esp,%ebp
80103be4:	53                   	push   %ebx
80103be5:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103be8:	e8 1a ff ff ff       	call   80103b07 <pushcli>
  if(holding(lk))
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	ff 75 08             	push   0x8(%ebp)
80103bf3:	e8 aa ff ff ff       	call   80103ba2 <holding>
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	85 c0                	test   %eax,%eax
80103bfd:	75 3a                	jne    80103c39 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103bff:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103c02:	b8 01 00 00 00       	mov    $0x1,%eax
80103c07:	f0 87 02             	lock xchg %eax,(%edx)
80103c0a:	85 c0                	test   %eax,%eax
80103c0c:	75 f1                	jne    80103bff <acquire+0x1e>
  __sync_synchronize();
80103c0e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103c13:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c16:	e8 72 f4 ff ff       	call   8010308d <mycpu>
80103c1b:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c21:	83 c0 0c             	add    $0xc,%eax
80103c24:	83 ec 08             	sub    $0x8,%esp
80103c27:	50                   	push   %eax
80103c28:	8d 45 08             	lea    0x8(%ebp),%eax
80103c2b:	50                   	push   %eax
80103c2c:	e8 94 fe ff ff       	call   80103ac5 <getcallerpcs>
}
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c37:	c9                   	leave  
80103c38:	c3                   	ret    
    panic("acquire");
80103c39:	83 ec 0c             	sub    $0xc,%esp
80103c3c:	68 cd 6e 10 80       	push   $0x80106ecd
80103c41:	e8 fb c6 ff ff       	call   80100341 <panic>

80103c46 <release>:
{
80103c46:	55                   	push   %ebp
80103c47:	89 e5                	mov    %esp,%ebp
80103c49:	53                   	push   %ebx
80103c4a:	83 ec 10             	sub    $0x10,%esp
80103c4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103c50:	53                   	push   %ebx
80103c51:	e8 4c ff ff ff       	call   80103ba2 <holding>
80103c56:	83 c4 10             	add    $0x10,%esp
80103c59:	85 c0                	test   %eax,%eax
80103c5b:	74 23                	je     80103c80 <release+0x3a>
  lk->pcs[0] = 0;
80103c5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103c64:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103c6b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103c70:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103c76:	e8 c7 fe ff ff       	call   80103b42 <popcli>
}
80103c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7e:	c9                   	leave  
80103c7f:	c3                   	ret    
    panic("release");
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 d5 6e 10 80       	push   $0x80106ed5
80103c88:	e8 b4 c6 ff ff       	call   80100341 <panic>

80103c8d <memset>:
80103c8d:	f3 0f 1e fb          	endbr32 
80103c91:	55                   	push   %ebp
80103c92:	89 e5                	mov    %esp,%ebp
80103c94:	57                   	push   %edi
80103c95:	53                   	push   %ebx
80103c96:	8b 55 08             	mov    0x8(%ebp),%edx
80103c99:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c9c:	f6 c2 03             	test   $0x3,%dl
80103c9f:	75 29                	jne    80103cca <memset+0x3d>
80103ca1:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103ca5:	75 23                	jne    80103cca <memset+0x3d>
80103ca7:	0f b6 f8             	movzbl %al,%edi
80103caa:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103cad:	c1 e9 02             	shr    $0x2,%ecx
80103cb0:	c1 e0 18             	shl    $0x18,%eax
80103cb3:	89 fb                	mov    %edi,%ebx
80103cb5:	c1 e3 10             	shl    $0x10,%ebx
80103cb8:	09 d8                	or     %ebx,%eax
80103cba:	89 fb                	mov    %edi,%ebx
80103cbc:	c1 e3 08             	shl    $0x8,%ebx
80103cbf:	09 d8                	or     %ebx,%eax
80103cc1:	09 f8                	or     %edi,%eax
80103cc3:	89 d7                	mov    %edx,%edi
80103cc5:	fc                   	cld    
80103cc6:	f3 ab                	rep stos %eax,%es:(%edi)
80103cc8:	eb 08                	jmp    80103cd2 <memset+0x45>
80103cca:	89 d7                	mov    %edx,%edi
80103ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103ccf:	fc                   	cld    
80103cd0:	f3 aa                	rep stos %al,%es:(%edi)
80103cd2:	89 d0                	mov    %edx,%eax
80103cd4:	5b                   	pop    %ebx
80103cd5:	5f                   	pop    %edi
80103cd6:	5d                   	pop    %ebp
80103cd7:	c3                   	ret    

80103cd8 <memcmp>:
80103cd8:	f3 0f 1e fb          	endbr32 
80103cdc:	55                   	push   %ebp
80103cdd:	89 e5                	mov    %esp,%ebp
80103cdf:	56                   	push   %esi
80103ce0:	53                   	push   %ebx
80103ce1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ce7:	8b 45 10             	mov    0x10(%ebp),%eax
80103cea:	8d 70 ff             	lea    -0x1(%eax),%esi
80103ced:	85 c0                	test   %eax,%eax
80103cef:	74 16                	je     80103d07 <memcmp+0x2f>
80103cf1:	8a 01                	mov    (%ecx),%al
80103cf3:	8a 1a                	mov    (%edx),%bl
80103cf5:	38 d8                	cmp    %bl,%al
80103cf7:	75 06                	jne    80103cff <memcmp+0x27>
80103cf9:	41                   	inc    %ecx
80103cfa:	42                   	inc    %edx
80103cfb:	89 f0                	mov    %esi,%eax
80103cfd:	eb eb                	jmp    80103cea <memcmp+0x12>
80103cff:	0f b6 c0             	movzbl %al,%eax
80103d02:	0f b6 db             	movzbl %bl,%ebx
80103d05:	29 d8                	sub    %ebx,%eax
80103d07:	5b                   	pop    %ebx
80103d08:	5e                   	pop    %esi
80103d09:	5d                   	pop    %ebp
80103d0a:	c3                   	ret    

80103d0b <memmove>:
80103d0b:	f3 0f 1e fb          	endbr32 
80103d0f:	55                   	push   %ebp
80103d10:	89 e5                	mov    %esp,%ebp
80103d12:	56                   	push   %esi
80103d13:	53                   	push   %ebx
80103d14:	8b 75 08             	mov    0x8(%ebp),%esi
80103d17:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d1a:	8b 45 10             	mov    0x10(%ebp),%eax
80103d1d:	39 f2                	cmp    %esi,%edx
80103d1f:	73 34                	jae    80103d55 <memmove+0x4a>
80103d21:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103d24:	39 f1                	cmp    %esi,%ecx
80103d26:	76 31                	jbe    80103d59 <memmove+0x4e>
80103d28:	8d 14 06             	lea    (%esi,%eax,1),%edx
80103d2b:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103d2e:	85 c0                	test   %eax,%eax
80103d30:	74 1d                	je     80103d4f <memmove+0x44>
80103d32:	49                   	dec    %ecx
80103d33:	4a                   	dec    %edx
80103d34:	8a 01                	mov    (%ecx),%al
80103d36:	88 02                	mov    %al,(%edx)
80103d38:	89 d8                	mov    %ebx,%eax
80103d3a:	eb ef                	jmp    80103d2b <memmove+0x20>
80103d3c:	8a 02                	mov    (%edx),%al
80103d3e:	88 01                	mov    %al,(%ecx)
80103d40:	8d 49 01             	lea    0x1(%ecx),%ecx
80103d43:	8d 52 01             	lea    0x1(%edx),%edx
80103d46:	89 d8                	mov    %ebx,%eax
80103d48:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103d4b:	85 c0                	test   %eax,%eax
80103d4d:	75 ed                	jne    80103d3c <memmove+0x31>
80103d4f:	89 f0                	mov    %esi,%eax
80103d51:	5b                   	pop    %ebx
80103d52:	5e                   	pop    %esi
80103d53:	5d                   	pop    %ebp
80103d54:	c3                   	ret    
80103d55:	89 f1                	mov    %esi,%ecx
80103d57:	eb ef                	jmp    80103d48 <memmove+0x3d>
80103d59:	89 f1                	mov    %esi,%ecx
80103d5b:	eb eb                	jmp    80103d48 <memmove+0x3d>

80103d5d <memcpy>:
80103d5d:	f3 0f 1e fb          	endbr32 
80103d61:	55                   	push   %ebp
80103d62:	89 e5                	mov    %esp,%ebp
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	ff 75 10             	push   0x10(%ebp)
80103d6a:	ff 75 0c             	push   0xc(%ebp)
80103d6d:	ff 75 08             	push   0x8(%ebp)
80103d70:	e8 96 ff ff ff       	call   80103d0b <memmove>
80103d75:	c9                   	leave  
80103d76:	c3                   	ret    

80103d77 <strncmp>:
80103d77:	f3 0f 1e fb          	endbr32 
80103d7b:	55                   	push   %ebp
80103d7c:	89 e5                	mov    %esp,%ebp
80103d7e:	53                   	push   %ebx
80103d7f:	8b 55 08             	mov    0x8(%ebp),%edx
80103d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103d85:	8b 45 10             	mov    0x10(%ebp),%eax
80103d88:	eb 03                	jmp    80103d8d <strncmp+0x16>
80103d8a:	48                   	dec    %eax
80103d8b:	42                   	inc    %edx
80103d8c:	41                   	inc    %ecx
80103d8d:	85 c0                	test   %eax,%eax
80103d8f:	74 0a                	je     80103d9b <strncmp+0x24>
80103d91:	8a 1a                	mov    (%edx),%bl
80103d93:	84 db                	test   %bl,%bl
80103d95:	74 04                	je     80103d9b <strncmp+0x24>
80103d97:	3a 19                	cmp    (%ecx),%bl
80103d99:	74 ef                	je     80103d8a <strncmp+0x13>
80103d9b:	85 c0                	test   %eax,%eax
80103d9d:	74 0b                	je     80103daa <strncmp+0x33>
80103d9f:	0f b6 02             	movzbl (%edx),%eax
80103da2:	0f b6 11             	movzbl (%ecx),%edx
80103da5:	29 d0                	sub    %edx,%eax
80103da7:	5b                   	pop    %ebx
80103da8:	5d                   	pop    %ebp
80103da9:	c3                   	ret    
80103daa:	b8 00 00 00 00       	mov    $0x0,%eax
80103daf:	eb f6                	jmp    80103da7 <strncmp+0x30>

80103db1 <strncpy>:
80103db1:	f3 0f 1e fb          	endbr32 
80103db5:	55                   	push   %ebp
80103db6:	89 e5                	mov    %esp,%ebp
80103db8:	57                   	push   %edi
80103db9:	56                   	push   %esi
80103dba:	53                   	push   %ebx
80103dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103dc1:	8b 55 10             	mov    0x10(%ebp),%edx
80103dc4:	89 c1                	mov    %eax,%ecx
80103dc6:	eb 04                	jmp    80103dcc <strncpy+0x1b>
80103dc8:	89 fb                	mov    %edi,%ebx
80103dca:	89 f1                	mov    %esi,%ecx
80103dcc:	89 d6                	mov    %edx,%esi
80103dce:	4a                   	dec    %edx
80103dcf:	85 f6                	test   %esi,%esi
80103dd1:	7e 1a                	jle    80103ded <strncpy+0x3c>
80103dd3:	8d 7b 01             	lea    0x1(%ebx),%edi
80103dd6:	8d 71 01             	lea    0x1(%ecx),%esi
80103dd9:	8a 1b                	mov    (%ebx),%bl
80103ddb:	88 19                	mov    %bl,(%ecx)
80103ddd:	84 db                	test   %bl,%bl
80103ddf:	75 e7                	jne    80103dc8 <strncpy+0x17>
80103de1:	89 f1                	mov    %esi,%ecx
80103de3:	eb 08                	jmp    80103ded <strncpy+0x3c>
80103de5:	c6 01 00             	movb   $0x0,(%ecx)
80103de8:	89 da                	mov    %ebx,%edx
80103dea:	8d 49 01             	lea    0x1(%ecx),%ecx
80103ded:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103df0:	85 d2                	test   %edx,%edx
80103df2:	7f f1                	jg     80103de5 <strncpy+0x34>
80103df4:	5b                   	pop    %ebx
80103df5:	5e                   	pop    %esi
80103df6:	5f                   	pop    %edi
80103df7:	5d                   	pop    %ebp
80103df8:	c3                   	ret    

80103df9 <safestrcpy>:
80103df9:	f3 0f 1e fb          	endbr32 
80103dfd:	55                   	push   %ebp
80103dfe:	89 e5                	mov    %esp,%ebp
80103e00:	57                   	push   %edi
80103e01:	56                   	push   %esi
80103e02:	53                   	push   %ebx
80103e03:	8b 45 08             	mov    0x8(%ebp),%eax
80103e06:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e09:	8b 55 10             	mov    0x10(%ebp),%edx
80103e0c:	85 d2                	test   %edx,%edx
80103e0e:	7e 20                	jle    80103e30 <safestrcpy+0x37>
80103e10:	89 c1                	mov    %eax,%ecx
80103e12:	eb 04                	jmp    80103e18 <safestrcpy+0x1f>
80103e14:	89 fb                	mov    %edi,%ebx
80103e16:	89 f1                	mov    %esi,%ecx
80103e18:	4a                   	dec    %edx
80103e19:	85 d2                	test   %edx,%edx
80103e1b:	7e 10                	jle    80103e2d <safestrcpy+0x34>
80103e1d:	8d 7b 01             	lea    0x1(%ebx),%edi
80103e20:	8d 71 01             	lea    0x1(%ecx),%esi
80103e23:	8a 1b                	mov    (%ebx),%bl
80103e25:	88 19                	mov    %bl,(%ecx)
80103e27:	84 db                	test   %bl,%bl
80103e29:	75 e9                	jne    80103e14 <safestrcpy+0x1b>
80103e2b:	89 f1                	mov    %esi,%ecx
80103e2d:	c6 01 00             	movb   $0x0,(%ecx)
80103e30:	5b                   	pop    %ebx
80103e31:	5e                   	pop    %esi
80103e32:	5f                   	pop    %edi
80103e33:	5d                   	pop    %ebp
80103e34:	c3                   	ret    

80103e35 <strlen>:
80103e35:	f3 0f 1e fb          	endbr32 
80103e39:	55                   	push   %ebp
80103e3a:	89 e5                	mov    %esp,%ebp
80103e3c:	8b 55 08             	mov    0x8(%ebp),%edx
80103e3f:	b8 00 00 00 00       	mov    $0x0,%eax
80103e44:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103e48:	74 03                	je     80103e4d <strlen+0x18>
80103e4a:	40                   	inc    %eax
80103e4b:	eb f7                	jmp    80103e44 <strlen+0xf>
80103e4d:	5d                   	pop    %ebp
80103e4e:	c3                   	ret    

80103e4f <swtch>:
80103e4f:	8b 44 24 04          	mov    0x4(%esp),%eax
80103e53:	8b 54 24 08          	mov    0x8(%esp),%edx
80103e57:	55                   	push   %ebp
80103e58:	53                   	push   %ebx
80103e59:	56                   	push   %esi
80103e5a:	57                   	push   %edi
80103e5b:	89 20                	mov    %esp,(%eax)
80103e5d:	89 d4                	mov    %edx,%esp
80103e5f:	5f                   	pop    %edi
80103e60:	5e                   	pop    %esi
80103e61:	5b                   	pop    %ebx
80103e62:	5d                   	pop    %ebp
80103e63:	c3                   	ret    

80103e64 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	53                   	push   %ebx
80103e68:	83 ec 04             	sub    $0x4,%esp
80103e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103e6e:	e8 af f2 ff ff       	call   80103122 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103e73:	8b 00                	mov    (%eax),%eax
80103e75:	39 d8                	cmp    %ebx,%eax
80103e77:	76 18                	jbe    80103e91 <fetchint+0x2d>
80103e79:	8d 53 04             	lea    0x4(%ebx),%edx
80103e7c:	39 d0                	cmp    %edx,%eax
80103e7e:	72 18                	jb     80103e98 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103e80:	8b 13                	mov    (%ebx),%edx
80103e82:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e85:	89 10                	mov    %edx,(%eax)
  return 0;
80103e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e8f:	c9                   	leave  
80103e90:	c3                   	ret    
    return -1;
80103e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e96:	eb f4                	jmp    80103e8c <fetchint+0x28>
80103e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e9d:	eb ed                	jmp    80103e8c <fetchint+0x28>

80103e9f <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103e9f:	55                   	push   %ebp
80103ea0:	89 e5                	mov    %esp,%ebp
80103ea2:	53                   	push   %ebx
80103ea3:	83 ec 04             	sub    $0x4,%esp
80103ea6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103ea9:	e8 74 f2 ff ff       	call   80103122 <myproc>

  if(addr >= curproc->sz)
80103eae:	39 18                	cmp    %ebx,(%eax)
80103eb0:	76 23                	jbe    80103ed5 <fetchstr+0x36>
    return -1;
  *pp = (char*)addr;
80103eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eb5:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103eb7:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103eb9:	89 d8                	mov    %ebx,%eax
80103ebb:	eb 01                	jmp    80103ebe <fetchstr+0x1f>
80103ebd:	40                   	inc    %eax
80103ebe:	39 d0                	cmp    %edx,%eax
80103ec0:	73 09                	jae    80103ecb <fetchstr+0x2c>
    if(*s == 0)
80103ec2:	80 38 00             	cmpb   $0x0,(%eax)
80103ec5:	75 f6                	jne    80103ebd <fetchstr+0x1e>
      return s - *pp;
80103ec7:	29 d8                	sub    %ebx,%eax
80103ec9:	eb 05                	jmp    80103ed0 <fetchstr+0x31>
  }
  return -1;
80103ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ed0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed3:	c9                   	leave  
80103ed4:	c3                   	ret    
    return -1;
80103ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eda:	eb f4                	jmp    80103ed0 <fetchstr+0x31>

80103edc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103edc:	55                   	push   %ebp
80103edd:	89 e5                	mov    %esp,%ebp
80103edf:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103ee2:	e8 3b f2 ff ff       	call   80103122 <myproc>
80103ee7:	8b 50 18             	mov    0x18(%eax),%edx
80103eea:	8b 45 08             	mov    0x8(%ebp),%eax
80103eed:	c1 e0 02             	shl    $0x2,%eax
80103ef0:	03 42 44             	add    0x44(%edx),%eax
80103ef3:	83 ec 08             	sub    $0x8,%esp
80103ef6:	ff 75 0c             	push   0xc(%ebp)
80103ef9:	83 c0 04             	add    $0x4,%eax
80103efc:	50                   	push   %eax
80103efd:	e8 62 ff ff ff       	call   80103e64 <fetchint>
}
80103f02:	c9                   	leave  
80103f03:	c3                   	ret    

80103f04 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80103f04:	55                   	push   %ebp
80103f05:	89 e5                	mov    %esp,%ebp
80103f07:	56                   	push   %esi
80103f08:	53                   	push   %ebx
80103f09:	83 ec 10             	sub    $0x10,%esp
80103f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103f0f:	e8 0e f2 ff ff       	call   80103122 <myproc>
80103f14:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80103f16:	83 ec 08             	sub    $0x8,%esp
80103f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103f1c:	50                   	push   %eax
80103f1d:	ff 75 08             	push   0x8(%ebp)
80103f20:	e8 b7 ff ff ff       	call   80103edc <argint>
80103f25:	83 c4 10             	add    $0x10,%esp
80103f28:	85 c0                	test   %eax,%eax
80103f2a:	78 24                	js     80103f50 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80103f2c:	85 db                	test   %ebx,%ebx
80103f2e:	78 27                	js     80103f57 <argptr+0x53>
80103f30:	8b 16                	mov    (%esi),%edx
80103f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f35:	39 c2                	cmp    %eax,%edx
80103f37:	76 25                	jbe    80103f5e <argptr+0x5a>
80103f39:	01 c3                	add    %eax,%ebx
80103f3b:	39 da                	cmp    %ebx,%edx
80103f3d:	72 26                	jb     80103f65 <argptr+0x61>
    return -1;
  *pp = (void*)i;
80103f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f42:	89 02                	mov    %eax,(%edx)
  return 0;
80103f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f4c:	5b                   	pop    %ebx
80103f4d:	5e                   	pop    %esi
80103f4e:	5d                   	pop    %ebp
80103f4f:	c3                   	ret    
    return -1;
80103f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f55:	eb f2                	jmp    80103f49 <argptr+0x45>
    return -1;
80103f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f5c:	eb eb                	jmp    80103f49 <argptr+0x45>
80103f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f63:	eb e4                	jmp    80103f49 <argptr+0x45>
80103f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f6a:	eb dd                	jmp    80103f49 <argptr+0x45>

80103f6c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80103f6c:	55                   	push   %ebp
80103f6d:	89 e5                	mov    %esp,%ebp
80103f6f:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80103f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103f75:	50                   	push   %eax
80103f76:	ff 75 08             	push   0x8(%ebp)
80103f79:	e8 5e ff ff ff       	call   80103edc <argint>
80103f7e:	83 c4 10             	add    $0x10,%esp
80103f81:	85 c0                	test   %eax,%eax
80103f83:	78 13                	js     80103f98 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80103f85:	83 ec 08             	sub    $0x8,%esp
80103f88:	ff 75 0c             	push   0xc(%ebp)
80103f8b:	ff 75 f4             	push   -0xc(%ebp)
80103f8e:	e8 0c ff ff ff       	call   80103e9f <fetchstr>
80103f93:	83 c4 10             	add    $0x10,%esp
}
80103f96:	c9                   	leave  
80103f97:	c3                   	ret    
    return -1;
80103f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f9d:	eb f7                	jmp    80103f96 <argstr+0x2a>

80103f9f <syscall>:
[SYS_dup2]    sys_dup2,
};

void
syscall(void)
{
80103f9f:	55                   	push   %ebp
80103fa0:	89 e5                	mov    %esp,%ebp
80103fa2:	53                   	push   %ebx
80103fa3:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80103fa6:	e8 77 f1 ff ff       	call   80103122 <myproc>
80103fab:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80103fad:	8b 40 18             	mov    0x18(%eax),%eax
80103fb0:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80103fb3:	8d 50 ff             	lea    -0x1(%eax),%edx
80103fb6:	83 fa 16             	cmp    $0x16,%edx
80103fb9:	77 17                	ja     80103fd2 <syscall+0x33>
80103fbb:	8b 14 85 00 6f 10 80 	mov    -0x7fef9100(,%eax,4),%edx
80103fc2:	85 d2                	test   %edx,%edx
80103fc4:	74 0c                	je     80103fd2 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
80103fc6:	ff d2                	call   *%edx
80103fc8:	89 c2                	mov    %eax,%edx
80103fca:	8b 43 18             	mov    0x18(%ebx),%eax
80103fcd:	89 50 1c             	mov    %edx,0x1c(%eax)
80103fd0:	eb 1f                	jmp    80103ff1 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80103fd2:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80103fd5:	50                   	push   %eax
80103fd6:	52                   	push   %edx
80103fd7:	ff 73 10             	push   0x10(%ebx)
80103fda:	68 dd 6e 10 80       	push   $0x80106edd
80103fdf:	e8 f6 c5 ff ff       	call   801005da <cprintf>
    curproc->tf->eax = -1;
80103fe4:	8b 43 18             	mov    0x18(%ebx),%eax
80103fe7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80103fee:	83 c4 10             	add    $0x10,%esp
  }
}
80103ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff4:	c9                   	leave  
80103ff5:	c3                   	ret    

80103ff6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80103ff6:	55                   	push   %ebp
80103ff7:	89 e5                	mov    %esp,%ebp
80103ff9:	56                   	push   %esi
80103ffa:	53                   	push   %ebx
80103ffb:	83 ec 18             	sub    $0x18,%esp
80103ffe:	89 d6                	mov    %edx,%esi
80104000:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104002:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104005:	52                   	push   %edx
80104006:	50                   	push   %eax
80104007:	e8 d0 fe ff ff       	call   80103edc <argint>
8010400c:	83 c4 10             	add    $0x10,%esp
8010400f:	85 c0                	test   %eax,%eax
80104011:	78 35                	js     80104048 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104013:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104017:	77 28                	ja     80104041 <argfd+0x4b>
80104019:	e8 04 f1 ff ff       	call   80103122 <myproc>
8010401e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104021:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104025:	85 c0                	test   %eax,%eax
80104027:	74 18                	je     80104041 <argfd+0x4b>
    return -1;
  if(pfd)
80104029:	85 f6                	test   %esi,%esi
8010402b:	74 02                	je     8010402f <argfd+0x39>
    *pfd = fd;
8010402d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010402f:	85 db                	test   %ebx,%ebx
80104031:	74 1c                	je     8010404f <argfd+0x59>
    *pf = f;
80104033:	89 03                	mov    %eax,(%ebx)
  return 0;
80104035:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010403a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010403d:	5b                   	pop    %ebx
8010403e:	5e                   	pop    %esi
8010403f:	5d                   	pop    %ebp
80104040:	c3                   	ret    
    return -1;
80104041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104046:	eb f2                	jmp    8010403a <argfd+0x44>
    return -1;
80104048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404d:	eb eb                	jmp    8010403a <argfd+0x44>
  return 0;
8010404f:	b8 00 00 00 00       	mov    $0x0,%eax
80104054:	eb e4                	jmp    8010403a <argfd+0x44>

80104056 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104056:	55                   	push   %ebp
80104057:	89 e5                	mov    %esp,%ebp
80104059:	53                   	push   %ebx
8010405a:	83 ec 04             	sub    $0x4,%esp
8010405d:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010405f:	e8 be f0 ff ff       	call   80103122 <myproc>
80104064:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
80104066:	b8 00 00 00 00       	mov    $0x0,%eax
8010406b:	83 f8 0f             	cmp    $0xf,%eax
8010406e:	7f 10                	jg     80104080 <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
80104070:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104075:	74 03                	je     8010407a <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
80104077:	40                   	inc    %eax
80104078:	eb f1                	jmp    8010406b <fdalloc+0x15>
      curproc->ofile[fd] = f;
8010407a:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
8010407e:	eb 05                	jmp    80104085 <fdalloc+0x2f>
    }
  }
  return -1;
80104080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104088:	c9                   	leave  
80104089:	c3                   	ret    

8010408a <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010408a:	55                   	push   %ebp
8010408b:	89 e5                	mov    %esp,%ebp
8010408d:	56                   	push   %esi
8010408e:	53                   	push   %ebx
8010408f:	83 ec 10             	sub    $0x10,%esp
80104092:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104094:	b8 20 00 00 00       	mov    $0x20,%eax
80104099:	89 c6                	mov    %eax,%esi
8010409b:	39 43 58             	cmp    %eax,0x58(%ebx)
8010409e:	76 2e                	jbe    801040ce <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801040a0:	6a 10                	push   $0x10
801040a2:	50                   	push   %eax
801040a3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801040a6:	50                   	push   %eax
801040a7:	53                   	push   %ebx
801040a8:	e8 46 d6 ff ff       	call   801016f3 <readi>
801040ad:	83 c4 10             	add    $0x10,%esp
801040b0:	83 f8 10             	cmp    $0x10,%eax
801040b3:	75 0c                	jne    801040c1 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
801040b5:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801040ba:	75 1e                	jne    801040da <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801040bc:	8d 46 10             	lea    0x10(%esi),%eax
801040bf:	eb d8                	jmp    80104099 <isdirempty+0xf>
      panic("isdirempty: readi");
801040c1:	83 ec 0c             	sub    $0xc,%esp
801040c4:	68 60 6f 10 80       	push   $0x80106f60
801040c9:	e8 73 c2 ff ff       	call   80100341 <panic>
      return 0;
  }
  return 1;
801040ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
801040d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040d6:	5b                   	pop    %ebx
801040d7:	5e                   	pop    %esi
801040d8:	5d                   	pop    %ebp
801040d9:	c3                   	ret    
      return 0;
801040da:	b8 00 00 00 00       	mov    $0x0,%eax
801040df:	eb f2                	jmp    801040d3 <isdirempty+0x49>

801040e1 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801040e1:	55                   	push   %ebp
801040e2:	89 e5                	mov    %esp,%ebp
801040e4:	57                   	push   %edi
801040e5:	56                   	push   %esi
801040e6:	53                   	push   %ebx
801040e7:	83 ec 44             	sub    $0x44,%esp
801040ea:	89 d7                	mov    %edx,%edi
801040ec:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
801040ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
801040f2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801040f5:	8d 55 d6             	lea    -0x2a(%ebp),%edx
801040f8:	52                   	push   %edx
801040f9:	50                   	push   %eax
801040fa:	e8 83 da ff ff       	call   80101b82 <nameiparent>
801040ff:	89 c6                	mov    %eax,%esi
80104101:	83 c4 10             	add    $0x10,%esp
80104104:	85 c0                	test   %eax,%eax
80104106:	0f 84 32 01 00 00    	je     8010423e <create+0x15d>
    return 0;
  ilock(dp);
8010410c:	83 ec 0c             	sub    $0xc,%esp
8010410f:	50                   	push   %eax
80104110:	e8 f1 d3 ff ff       	call   80101506 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104115:	83 c4 0c             	add    $0xc,%esp
80104118:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010411b:	50                   	push   %eax
8010411c:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010411f:	50                   	push   %eax
80104120:	56                   	push   %esi
80104121:	e8 16 d8 ff ff       	call   8010193c <dirlookup>
80104126:	89 c3                	mov    %eax,%ebx
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	85 c0                	test   %eax,%eax
8010412d:	74 3c                	je     8010416b <create+0x8a>
    iunlockput(dp);
8010412f:	83 ec 0c             	sub    $0xc,%esp
80104132:	56                   	push   %esi
80104133:	e8 71 d5 ff ff       	call   801016a9 <iunlockput>
    ilock(ip);
80104138:	89 1c 24             	mov    %ebx,(%esp)
8010413b:	e8 c6 d3 ff ff       	call   80101506 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104140:	83 c4 10             	add    $0x10,%esp
80104143:	66 83 ff 02          	cmp    $0x2,%di
80104147:	75 07                	jne    80104150 <create+0x6f>
80104149:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010414e:	74 11                	je     80104161 <create+0x80>
      return ip;
    iunlockput(ip);
80104150:	83 ec 0c             	sub    $0xc,%esp
80104153:	53                   	push   %ebx
80104154:	e8 50 d5 ff ff       	call   801016a9 <iunlockput>
    return 0;
80104159:	83 c4 10             	add    $0x10,%esp
8010415c:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104161:	89 d8                	mov    %ebx,%eax
80104163:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104166:	5b                   	pop    %ebx
80104167:	5e                   	pop    %esi
80104168:	5f                   	pop    %edi
80104169:	5d                   	pop    %ebp
8010416a:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
8010416b:	83 ec 08             	sub    $0x8,%esp
8010416e:	0f bf c7             	movswl %di,%eax
80104171:	50                   	push   %eax
80104172:	ff 36                	push   (%esi)
80104174:	e8 95 d1 ff ff       	call   8010130e <ialloc>
80104179:	89 c3                	mov    %eax,%ebx
8010417b:	83 c4 10             	add    $0x10,%esp
8010417e:	85 c0                	test   %eax,%eax
80104180:	74 53                	je     801041d5 <create+0xf4>
  ilock(ip);
80104182:	83 ec 0c             	sub    $0xc,%esp
80104185:	50                   	push   %eax
80104186:	e8 7b d3 ff ff       	call   80101506 <ilock>
  ip->major = major;
8010418b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010418e:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104192:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104195:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104199:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010419f:	89 1c 24             	mov    %ebx,(%esp)
801041a2:	e8 06 d2 ff ff       	call   801013ad <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801041a7:	83 c4 10             	add    $0x10,%esp
801041aa:	66 83 ff 01          	cmp    $0x1,%di
801041ae:	74 32                	je     801041e2 <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
801041b0:	83 ec 04             	sub    $0x4,%esp
801041b3:	ff 73 04             	push   0x4(%ebx)
801041b6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801041b9:	50                   	push   %eax
801041ba:	56                   	push   %esi
801041bb:	e8 f9 d8 ff ff       	call   80101ab9 <dirlink>
801041c0:	83 c4 10             	add    $0x10,%esp
801041c3:	85 c0                	test   %eax,%eax
801041c5:	78 6a                	js     80104231 <create+0x150>
  iunlockput(dp);
801041c7:	83 ec 0c             	sub    $0xc,%esp
801041ca:	56                   	push   %esi
801041cb:	e8 d9 d4 ff ff       	call   801016a9 <iunlockput>
  return ip;
801041d0:	83 c4 10             	add    $0x10,%esp
801041d3:	eb 8c                	jmp    80104161 <create+0x80>
    panic("create: ialloc");
801041d5:	83 ec 0c             	sub    $0xc,%esp
801041d8:	68 72 6f 10 80       	push   $0x80106f72
801041dd:	e8 5f c1 ff ff       	call   80100341 <panic>
    dp->nlink++;  // for ".."
801041e2:	66 8b 46 56          	mov    0x56(%esi),%ax
801041e6:	40                   	inc    %eax
801041e7:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	56                   	push   %esi
801041ef:	e8 b9 d1 ff ff       	call   801013ad <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801041f4:	83 c4 0c             	add    $0xc,%esp
801041f7:	ff 73 04             	push   0x4(%ebx)
801041fa:	68 82 6f 10 80       	push   $0x80106f82
801041ff:	53                   	push   %ebx
80104200:	e8 b4 d8 ff ff       	call   80101ab9 <dirlink>
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	85 c0                	test   %eax,%eax
8010420a:	78 18                	js     80104224 <create+0x143>
8010420c:	83 ec 04             	sub    $0x4,%esp
8010420f:	ff 76 04             	push   0x4(%esi)
80104212:	68 81 6f 10 80       	push   $0x80106f81
80104217:	53                   	push   %ebx
80104218:	e8 9c d8 ff ff       	call   80101ab9 <dirlink>
8010421d:	83 c4 10             	add    $0x10,%esp
80104220:	85 c0                	test   %eax,%eax
80104222:	79 8c                	jns    801041b0 <create+0xcf>
      panic("create dots");
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 84 6f 10 80       	push   $0x80106f84
8010422c:	e8 10 c1 ff ff       	call   80100341 <panic>
    panic("create: dirlink");
80104231:	83 ec 0c             	sub    $0xc,%esp
80104234:	68 90 6f 10 80       	push   $0x80106f90
80104239:	e8 03 c1 ff ff       	call   80100341 <panic>
    return 0;
8010423e:	89 c3                	mov    %eax,%ebx
80104240:	e9 1c ff ff ff       	jmp    80104161 <create+0x80>

80104245 <sys_dup>:
{
80104245:	55                   	push   %ebp
80104246:	89 e5                	mov    %esp,%ebp
80104248:	53                   	push   %ebx
80104249:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010424c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010424f:	ba 00 00 00 00       	mov    $0x0,%edx
80104254:	b8 00 00 00 00       	mov    $0x0,%eax
80104259:	e8 98 fd ff ff       	call   80103ff6 <argfd>
8010425e:	85 c0                	test   %eax,%eax
80104260:	78 23                	js     80104285 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104265:	e8 ec fd ff ff       	call   80104056 <fdalloc>
8010426a:	89 c3                	mov    %eax,%ebx
8010426c:	85 c0                	test   %eax,%eax
8010426e:	78 1c                	js     8010428c <sys_dup+0x47>
  filedup(f);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	ff 75 f4             	push   -0xc(%ebp)
80104276:	e8 cc c9 ff ff       	call   80100c47 <filedup>
  return fd;
8010427b:	83 c4 10             	add    $0x10,%esp
}
8010427e:	89 d8                	mov    %ebx,%eax
80104280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104283:	c9                   	leave  
80104284:	c3                   	ret    
    return -1;
80104285:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010428a:	eb f2                	jmp    8010427e <sys_dup+0x39>
    return -1;
8010428c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104291:	eb eb                	jmp    8010427e <sys_dup+0x39>

80104293 <sys_dup2>:
{
80104293:	55                   	push   %ebp
80104294:	89 e5                	mov    %esp,%ebp
80104296:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &oldfd, &f) < 0)
80104299:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010429c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010429f:	b8 00 00 00 00       	mov    $0x0,%eax
801042a4:	e8 4d fd ff ff       	call   80103ff6 <argfd>
801042a9:	85 c0                	test   %eax,%eax
801042ab:	78 59                	js     80104306 <sys_dup2+0x73>
  if (argint(0, &newfd) < 0)
801042ad:	83 ec 08             	sub    $0x8,%esp
801042b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801042b3:	50                   	push   %eax
801042b4:	6a 00                	push   $0x0
801042b6:	e8 21 fc ff ff       	call   80103edc <argint>
801042bb:	83 c4 10             	add    $0x10,%esp
801042be:	85 c0                	test   %eax,%eax
801042c0:	78 4b                	js     8010430d <sys_dup2+0x7a>
  if (oldfd == newfd) {
801042c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801042c5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801042c8:	74 3a                	je     80104304 <sys_dup2+0x71>
  if ((newf = myproc()->ofile[newfd]))
801042ca:	e8 53 ee ff ff       	call   80103122 <myproc>
801042cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
801042d2:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801042d6:	85 c0                	test   %eax,%eax
801042d8:	74 0c                	je     801042e6 <sys_dup2+0x53>
    fileclose(newf);
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	50                   	push   %eax
801042de:	e8 a7 c9 ff ff       	call   80100c8a <fileclose>
801042e3:	83 c4 10             	add    $0x10,%esp
  myproc()->ofile[newfd] = f;
801042e6:	e8 37 ee ff ff       	call   80103122 <myproc>
801042eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ee:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801042f1:	89 54 88 28          	mov    %edx,0x28(%eax,%ecx,4)
  filedup(f);
801042f5:	83 ec 0c             	sub    $0xc,%esp
801042f8:	52                   	push   %edx
801042f9:	e8 49 c9 ff ff       	call   80100c47 <filedup>
  return newfd;
801042fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104301:	83 c4 10             	add    $0x10,%esp
}
80104304:	c9                   	leave  
80104305:	c3                   	ret    
    return -1;
80104306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010430b:	eb f7                	jmp    80104304 <sys_dup2+0x71>
    return -1;
8010430d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104312:	eb f0                	jmp    80104304 <sys_dup2+0x71>

80104314 <sys_read>:
{
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
8010431a:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010431d:	ba 00 00 00 00       	mov    $0x0,%edx
80104322:	b8 00 00 00 00       	mov    $0x0,%eax
80104327:	e8 ca fc ff ff       	call   80103ff6 <argfd>
8010432c:	85 c0                	test   %eax,%eax
8010432e:	78 43                	js     80104373 <sys_read+0x5f>
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104336:	50                   	push   %eax
80104337:	6a 02                	push   $0x2
80104339:	e8 9e fb ff ff       	call   80103edc <argint>
8010433e:	83 c4 10             	add    $0x10,%esp
80104341:	85 c0                	test   %eax,%eax
80104343:	78 2e                	js     80104373 <sys_read+0x5f>
80104345:	83 ec 04             	sub    $0x4,%esp
80104348:	ff 75 f0             	push   -0x10(%ebp)
8010434b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010434e:	50                   	push   %eax
8010434f:	6a 01                	push   $0x1
80104351:	e8 ae fb ff ff       	call   80103f04 <argptr>
80104356:	83 c4 10             	add    $0x10,%esp
80104359:	85 c0                	test   %eax,%eax
8010435b:	78 16                	js     80104373 <sys_read+0x5f>
  return fileread(f, p, n);
8010435d:	83 ec 04             	sub    $0x4,%esp
80104360:	ff 75 f0             	push   -0x10(%ebp)
80104363:	ff 75 ec             	push   -0x14(%ebp)
80104366:	ff 75 f4             	push   -0xc(%ebp)
80104369:	e8 15 ca ff ff       	call   80100d83 <fileread>
8010436e:	83 c4 10             	add    $0x10,%esp
}
80104371:	c9                   	leave  
80104372:	c3                   	ret    
    return -1;
80104373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104378:	eb f7                	jmp    80104371 <sys_read+0x5d>

8010437a <sys_write>:
{
8010437a:	55                   	push   %ebp
8010437b:	89 e5                	mov    %esp,%ebp
8010437d:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104380:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104383:	ba 00 00 00 00       	mov    $0x0,%edx
80104388:	b8 00 00 00 00       	mov    $0x0,%eax
8010438d:	e8 64 fc ff ff       	call   80103ff6 <argfd>
80104392:	85 c0                	test   %eax,%eax
80104394:	78 43                	js     801043d9 <sys_write+0x5f>
80104396:	83 ec 08             	sub    $0x8,%esp
80104399:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010439c:	50                   	push   %eax
8010439d:	6a 02                	push   $0x2
8010439f:	e8 38 fb ff ff       	call   80103edc <argint>
801043a4:	83 c4 10             	add    $0x10,%esp
801043a7:	85 c0                	test   %eax,%eax
801043a9:	78 2e                	js     801043d9 <sys_write+0x5f>
801043ab:	83 ec 04             	sub    $0x4,%esp
801043ae:	ff 75 f0             	push   -0x10(%ebp)
801043b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801043b4:	50                   	push   %eax
801043b5:	6a 01                	push   $0x1
801043b7:	e8 48 fb ff ff       	call   80103f04 <argptr>
801043bc:	83 c4 10             	add    $0x10,%esp
801043bf:	85 c0                	test   %eax,%eax
801043c1:	78 16                	js     801043d9 <sys_write+0x5f>
  return filewrite(f, p, n);
801043c3:	83 ec 04             	sub    $0x4,%esp
801043c6:	ff 75 f0             	push   -0x10(%ebp)
801043c9:	ff 75 ec             	push   -0x14(%ebp)
801043cc:	ff 75 f4             	push   -0xc(%ebp)
801043cf:	e8 34 ca ff ff       	call   80100e08 <filewrite>
801043d4:	83 c4 10             	add    $0x10,%esp
}
801043d7:	c9                   	leave  
801043d8:	c3                   	ret    
    return -1;
801043d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043de:	eb f7                	jmp    801043d7 <sys_write+0x5d>

801043e0 <sys_close>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801043e6:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801043e9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801043ec:	b8 00 00 00 00       	mov    $0x0,%eax
801043f1:	e8 00 fc ff ff       	call   80103ff6 <argfd>
801043f6:	85 c0                	test   %eax,%eax
801043f8:	78 25                	js     8010441f <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801043fa:	e8 23 ed ff ff       	call   80103122 <myproc>
801043ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104402:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104409:	00 
  fileclose(f);
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	ff 75 f0             	push   -0x10(%ebp)
80104410:	e8 75 c8 ff ff       	call   80100c8a <fileclose>
  return 0;
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010441d:	c9                   	leave  
8010441e:	c3                   	ret    
    return -1;
8010441f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104424:	eb f7                	jmp    8010441d <sys_close+0x3d>

80104426 <sys_fstat>:
{
80104426:	55                   	push   %ebp
80104427:	89 e5                	mov    %esp,%ebp
80104429:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010442c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010442f:	ba 00 00 00 00       	mov    $0x0,%edx
80104434:	b8 00 00 00 00       	mov    $0x0,%eax
80104439:	e8 b8 fb ff ff       	call   80103ff6 <argfd>
8010443e:	85 c0                	test   %eax,%eax
80104440:	78 2a                	js     8010446c <sys_fstat+0x46>
80104442:	83 ec 04             	sub    $0x4,%esp
80104445:	6a 14                	push   $0x14
80104447:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010444a:	50                   	push   %eax
8010444b:	6a 01                	push   $0x1
8010444d:	e8 b2 fa ff ff       	call   80103f04 <argptr>
80104452:	83 c4 10             	add    $0x10,%esp
80104455:	85 c0                	test   %eax,%eax
80104457:	78 13                	js     8010446c <sys_fstat+0x46>
  return filestat(f, st);
80104459:	83 ec 08             	sub    $0x8,%esp
8010445c:	ff 75 f0             	push   -0x10(%ebp)
8010445f:	ff 75 f4             	push   -0xc(%ebp)
80104462:	e8 d5 c8 ff ff       	call   80100d3c <filestat>
80104467:	83 c4 10             	add    $0x10,%esp
}
8010446a:	c9                   	leave  
8010446b:	c3                   	ret    
    return -1;
8010446c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104471:	eb f7                	jmp    8010446a <sys_fstat+0x44>

80104473 <sys_link>:
{
80104473:	55                   	push   %ebp
80104474:	89 e5                	mov    %esp,%ebp
80104476:	56                   	push   %esi
80104477:	53                   	push   %ebx
80104478:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010447b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010447e:	50                   	push   %eax
8010447f:	6a 00                	push   $0x0
80104481:	e8 e6 fa ff ff       	call   80103f6c <argstr>
80104486:	83 c4 10             	add    $0x10,%esp
80104489:	85 c0                	test   %eax,%eax
8010448b:	0f 88 d1 00 00 00    	js     80104562 <sys_link+0xef>
80104491:	83 ec 08             	sub    $0x8,%esp
80104494:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104497:	50                   	push   %eax
80104498:	6a 01                	push   $0x1
8010449a:	e8 cd fa ff ff       	call   80103f6c <argstr>
8010449f:	83 c4 10             	add    $0x10,%esp
801044a2:	85 c0                	test   %eax,%eax
801044a4:	0f 88 b8 00 00 00    	js     80104562 <sys_link+0xef>
  begin_op();
801044aa:	e8 2d e2 ff ff       	call   801026dc <begin_op>
  if((ip = namei(old)) == 0){
801044af:	83 ec 0c             	sub    $0xc,%esp
801044b2:	ff 75 e0             	push   -0x20(%ebp)
801044b5:	e8 b0 d6 ff ff       	call   80101b6a <namei>
801044ba:	89 c3                	mov    %eax,%ebx
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	85 c0                	test   %eax,%eax
801044c1:	0f 84 a2 00 00 00    	je     80104569 <sys_link+0xf6>
  ilock(ip);
801044c7:	83 ec 0c             	sub    $0xc,%esp
801044ca:	50                   	push   %eax
801044cb:	e8 36 d0 ff ff       	call   80101506 <ilock>
  if(ip->type == T_DIR){
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801044d8:	0f 84 97 00 00 00    	je     80104575 <sys_link+0x102>
  ip->nlink++;
801044de:	66 8b 43 56          	mov    0x56(%ebx),%ax
801044e2:	40                   	inc    %eax
801044e3:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801044e7:	83 ec 0c             	sub    $0xc,%esp
801044ea:	53                   	push   %ebx
801044eb:	e8 bd ce ff ff       	call   801013ad <iupdate>
  iunlock(ip);
801044f0:	89 1c 24             	mov    %ebx,(%esp)
801044f3:	e8 ce d0 ff ff       	call   801015c6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801044f8:	83 c4 08             	add    $0x8,%esp
801044fb:	8d 45 ea             	lea    -0x16(%ebp),%eax
801044fe:	50                   	push   %eax
801044ff:	ff 75 e4             	push   -0x1c(%ebp)
80104502:	e8 7b d6 ff ff       	call   80101b82 <nameiparent>
80104507:	89 c6                	mov    %eax,%esi
80104509:	83 c4 10             	add    $0x10,%esp
8010450c:	85 c0                	test   %eax,%eax
8010450e:	0f 84 85 00 00 00    	je     80104599 <sys_link+0x126>
  ilock(dp);
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	50                   	push   %eax
80104518:	e8 e9 cf ff ff       	call   80101506 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010451d:	83 c4 10             	add    $0x10,%esp
80104520:	8b 03                	mov    (%ebx),%eax
80104522:	39 06                	cmp    %eax,(%esi)
80104524:	75 67                	jne    8010458d <sys_link+0x11a>
80104526:	83 ec 04             	sub    $0x4,%esp
80104529:	ff 73 04             	push   0x4(%ebx)
8010452c:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010452f:	50                   	push   %eax
80104530:	56                   	push   %esi
80104531:	e8 83 d5 ff ff       	call   80101ab9 <dirlink>
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	85 c0                	test   %eax,%eax
8010453b:	78 50                	js     8010458d <sys_link+0x11a>
  iunlockput(dp);
8010453d:	83 ec 0c             	sub    $0xc,%esp
80104540:	56                   	push   %esi
80104541:	e8 63 d1 ff ff       	call   801016a9 <iunlockput>
  iput(ip);
80104546:	89 1c 24             	mov    %ebx,(%esp)
80104549:	e8 bd d0 ff ff       	call   8010160b <iput>
  end_op();
8010454e:	e8 05 e2 ff ff       	call   80102758 <end_op>
  return 0;
80104553:	83 c4 10             	add    $0x10,%esp
80104556:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010455b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010455e:	5b                   	pop    %ebx
8010455f:	5e                   	pop    %esi
80104560:	5d                   	pop    %ebp
80104561:	c3                   	ret    
    return -1;
80104562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104567:	eb f2                	jmp    8010455b <sys_link+0xe8>
    end_op();
80104569:	e8 ea e1 ff ff       	call   80102758 <end_op>
    return -1;
8010456e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104573:	eb e6                	jmp    8010455b <sys_link+0xe8>
    iunlockput(ip);
80104575:	83 ec 0c             	sub    $0xc,%esp
80104578:	53                   	push   %ebx
80104579:	e8 2b d1 ff ff       	call   801016a9 <iunlockput>
    end_op();
8010457e:	e8 d5 e1 ff ff       	call   80102758 <end_op>
    return -1;
80104583:	83 c4 10             	add    $0x10,%esp
80104586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458b:	eb ce                	jmp    8010455b <sys_link+0xe8>
    iunlockput(dp);
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	56                   	push   %esi
80104591:	e8 13 d1 ff ff       	call   801016a9 <iunlockput>
    goto bad;
80104596:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104599:	83 ec 0c             	sub    $0xc,%esp
8010459c:	53                   	push   %ebx
8010459d:	e8 64 cf ff ff       	call   80101506 <ilock>
  ip->nlink--;
801045a2:	66 8b 43 56          	mov    0x56(%ebx),%ax
801045a6:	48                   	dec    %eax
801045a7:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801045ab:	89 1c 24             	mov    %ebx,(%esp)
801045ae:	e8 fa cd ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
801045b3:	89 1c 24             	mov    %ebx,(%esp)
801045b6:	e8 ee d0 ff ff       	call   801016a9 <iunlockput>
  end_op();
801045bb:	e8 98 e1 ff ff       	call   80102758 <end_op>
  return -1;
801045c0:	83 c4 10             	add    $0x10,%esp
801045c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c8:	eb 91                	jmp    8010455b <sys_link+0xe8>

801045ca <sys_unlink>:
{
801045ca:	55                   	push   %ebp
801045cb:	89 e5                	mov    %esp,%ebp
801045cd:	57                   	push   %edi
801045ce:	56                   	push   %esi
801045cf:	53                   	push   %ebx
801045d0:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801045d3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801045d6:	50                   	push   %eax
801045d7:	6a 00                	push   $0x0
801045d9:	e8 8e f9 ff ff       	call   80103f6c <argstr>
801045de:	83 c4 10             	add    $0x10,%esp
801045e1:	85 c0                	test   %eax,%eax
801045e3:	0f 88 7f 01 00 00    	js     80104768 <sys_unlink+0x19e>
  begin_op();
801045e9:	e8 ee e0 ff ff       	call   801026dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801045ee:	83 ec 08             	sub    $0x8,%esp
801045f1:	8d 45 ca             	lea    -0x36(%ebp),%eax
801045f4:	50                   	push   %eax
801045f5:	ff 75 c4             	push   -0x3c(%ebp)
801045f8:	e8 85 d5 ff ff       	call   80101b82 <nameiparent>
801045fd:	89 c6                	mov    %eax,%esi
801045ff:	83 c4 10             	add    $0x10,%esp
80104602:	85 c0                	test   %eax,%eax
80104604:	0f 84 eb 00 00 00    	je     801046f5 <sys_unlink+0x12b>
  ilock(dp);
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	50                   	push   %eax
8010460e:	e8 f3 ce ff ff       	call   80101506 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104613:	83 c4 08             	add    $0x8,%esp
80104616:	68 82 6f 10 80       	push   $0x80106f82
8010461b:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010461e:	50                   	push   %eax
8010461f:	e8 03 d3 ff ff       	call   80101927 <namecmp>
80104624:	83 c4 10             	add    $0x10,%esp
80104627:	85 c0                	test   %eax,%eax
80104629:	0f 84 fa 00 00 00    	je     80104729 <sys_unlink+0x15f>
8010462f:	83 ec 08             	sub    $0x8,%esp
80104632:	68 81 6f 10 80       	push   $0x80106f81
80104637:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010463a:	50                   	push   %eax
8010463b:	e8 e7 d2 ff ff       	call   80101927 <namecmp>
80104640:	83 c4 10             	add    $0x10,%esp
80104643:	85 c0                	test   %eax,%eax
80104645:	0f 84 de 00 00 00    	je     80104729 <sys_unlink+0x15f>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010464b:	83 ec 04             	sub    $0x4,%esp
8010464e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104651:	50                   	push   %eax
80104652:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104655:	50                   	push   %eax
80104656:	56                   	push   %esi
80104657:	e8 e0 d2 ff ff       	call   8010193c <dirlookup>
8010465c:	89 c3                	mov    %eax,%ebx
8010465e:	83 c4 10             	add    $0x10,%esp
80104661:	85 c0                	test   %eax,%eax
80104663:	0f 84 c0 00 00 00    	je     80104729 <sys_unlink+0x15f>
  ilock(ip);
80104669:	83 ec 0c             	sub    $0xc,%esp
8010466c:	50                   	push   %eax
8010466d:	e8 94 ce ff ff       	call   80101506 <ilock>
  if(ip->nlink < 1)
80104672:	83 c4 10             	add    $0x10,%esp
80104675:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010467a:	0f 8e 81 00 00 00    	jle    80104701 <sys_unlink+0x137>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104680:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104685:	0f 84 83 00 00 00    	je     8010470e <sys_unlink+0x144>
  memset(&de, 0, sizeof(de));
8010468b:	83 ec 04             	sub    $0x4,%esp
8010468e:	6a 10                	push   $0x10
80104690:	6a 00                	push   $0x0
80104692:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104695:	57                   	push   %edi
80104696:	e8 f2 f5 ff ff       	call   80103c8d <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010469b:	6a 10                	push   $0x10
8010469d:	ff 75 c0             	push   -0x40(%ebp)
801046a0:	57                   	push   %edi
801046a1:	56                   	push   %esi
801046a2:	e8 4c d1 ff ff       	call   801017f3 <writei>
801046a7:	83 c4 20             	add    $0x20,%esp
801046aa:	83 f8 10             	cmp    $0x10,%eax
801046ad:	0f 85 8e 00 00 00    	jne    80104741 <sys_unlink+0x177>
  if(ip->type == T_DIR){
801046b3:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801046b8:	0f 84 90 00 00 00    	je     8010474e <sys_unlink+0x184>
  iunlockput(dp);
801046be:	83 ec 0c             	sub    $0xc,%esp
801046c1:	56                   	push   %esi
801046c2:	e8 e2 cf ff ff       	call   801016a9 <iunlockput>
  ip->nlink--;
801046c7:	66 8b 43 56          	mov    0x56(%ebx),%ax
801046cb:	48                   	dec    %eax
801046cc:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801046d0:	89 1c 24             	mov    %ebx,(%esp)
801046d3:	e8 d5 cc ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
801046d8:	89 1c 24             	mov    %ebx,(%esp)
801046db:	e8 c9 cf ff ff       	call   801016a9 <iunlockput>
  end_op();
801046e0:	e8 73 e0 ff ff       	call   80102758 <end_op>
  return 0;
801046e5:	83 c4 10             	add    $0x10,%esp
801046e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046f0:	5b                   	pop    %ebx
801046f1:	5e                   	pop    %esi
801046f2:	5f                   	pop    %edi
801046f3:	5d                   	pop    %ebp
801046f4:	c3                   	ret    
    end_op();
801046f5:	e8 5e e0 ff ff       	call   80102758 <end_op>
    return -1;
801046fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ff:	eb ec                	jmp    801046ed <sys_unlink+0x123>
    panic("unlink: nlink < 1");
80104701:	83 ec 0c             	sub    $0xc,%esp
80104704:	68 a0 6f 10 80       	push   $0x80106fa0
80104709:	e8 33 bc ff ff       	call   80100341 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010470e:	89 d8                	mov    %ebx,%eax
80104710:	e8 75 f9 ff ff       	call   8010408a <isdirempty>
80104715:	85 c0                	test   %eax,%eax
80104717:	0f 85 6e ff ff ff    	jne    8010468b <sys_unlink+0xc1>
    iunlockput(ip);
8010471d:	83 ec 0c             	sub    $0xc,%esp
80104720:	53                   	push   %ebx
80104721:	e8 83 cf ff ff       	call   801016a9 <iunlockput>
    goto bad;
80104726:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104729:	83 ec 0c             	sub    $0xc,%esp
8010472c:	56                   	push   %esi
8010472d:	e8 77 cf ff ff       	call   801016a9 <iunlockput>
  end_op();
80104732:	e8 21 e0 ff ff       	call   80102758 <end_op>
  return -1;
80104737:	83 c4 10             	add    $0x10,%esp
8010473a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010473f:	eb ac                	jmp    801046ed <sys_unlink+0x123>
    panic("unlink: writei");
80104741:	83 ec 0c             	sub    $0xc,%esp
80104744:	68 b2 6f 10 80       	push   $0x80106fb2
80104749:	e8 f3 bb ff ff       	call   80100341 <panic>
    dp->nlink--;
8010474e:	66 8b 46 56          	mov    0x56(%esi),%ax
80104752:	48                   	dec    %eax
80104753:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104757:	83 ec 0c             	sub    $0xc,%esp
8010475a:	56                   	push   %esi
8010475b:	e8 4d cc ff ff       	call   801013ad <iupdate>
80104760:	83 c4 10             	add    $0x10,%esp
80104763:	e9 56 ff ff ff       	jmp    801046be <sys_unlink+0xf4>
    return -1;
80104768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476d:	e9 7b ff ff ff       	jmp    801046ed <sys_unlink+0x123>

80104772 <sys_open>:

int
sys_open(void)
{
80104772:	55                   	push   %ebp
80104773:	89 e5                	mov    %esp,%ebp
80104775:	57                   	push   %edi
80104776:	56                   	push   %esi
80104777:	53                   	push   %ebx
80104778:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010477b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010477e:	50                   	push   %eax
8010477f:	6a 00                	push   $0x0
80104781:	e8 e6 f7 ff ff       	call   80103f6c <argstr>
80104786:	83 c4 10             	add    $0x10,%esp
80104789:	85 c0                	test   %eax,%eax
8010478b:	0f 88 a0 00 00 00    	js     80104831 <sys_open+0xbf>
80104791:	83 ec 08             	sub    $0x8,%esp
80104794:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104797:	50                   	push   %eax
80104798:	6a 01                	push   $0x1
8010479a:	e8 3d f7 ff ff       	call   80103edc <argint>
8010479f:	83 c4 10             	add    $0x10,%esp
801047a2:	85 c0                	test   %eax,%eax
801047a4:	0f 88 87 00 00 00    	js     80104831 <sys_open+0xbf>
    return -1;

  begin_op();
801047aa:	e8 2d df ff ff       	call   801026dc <begin_op>

  if(omode & O_CREATE){
801047af:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801047b3:	0f 84 8b 00 00 00    	je     80104844 <sys_open+0xd2>
    ip = create(path, T_FILE, 0, 0);
801047b9:	83 ec 0c             	sub    $0xc,%esp
801047bc:	6a 00                	push   $0x0
801047be:	b9 00 00 00 00       	mov    $0x0,%ecx
801047c3:	ba 02 00 00 00       	mov    $0x2,%edx
801047c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047cb:	e8 11 f9 ff ff       	call   801040e1 <create>
801047d0:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801047d2:	83 c4 10             	add    $0x10,%esp
801047d5:	85 c0                	test   %eax,%eax
801047d7:	74 5f                	je     80104838 <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801047d9:	e8 08 c4 ff ff       	call   80100be6 <filealloc>
801047de:	89 c3                	mov    %eax,%ebx
801047e0:	85 c0                	test   %eax,%eax
801047e2:	0f 84 b5 00 00 00    	je     8010489d <sys_open+0x12b>
801047e8:	e8 69 f8 ff ff       	call   80104056 <fdalloc>
801047ed:	89 c7                	mov    %eax,%edi
801047ef:	85 c0                	test   %eax,%eax
801047f1:	0f 88 a6 00 00 00    	js     8010489d <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801047f7:	83 ec 0c             	sub    $0xc,%esp
801047fa:	56                   	push   %esi
801047fb:	e8 c6 cd ff ff       	call   801015c6 <iunlock>
  end_op();
80104800:	e8 53 df ff ff       	call   80102758 <end_op>

  f->type = FD_INODE;
80104805:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
8010480b:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010480e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104815:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104818:	83 c4 10             	add    $0x10,%esp
8010481b:	a8 01                	test   $0x1,%al
8010481d:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104821:	a8 03                	test   $0x3,%al
80104823:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104827:	89 f8                	mov    %edi,%eax
80104829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010482c:	5b                   	pop    %ebx
8010482d:	5e                   	pop    %esi
8010482e:	5f                   	pop    %edi
8010482f:	5d                   	pop    %ebp
80104830:	c3                   	ret    
    return -1;
80104831:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104836:	eb ef                	jmp    80104827 <sys_open+0xb5>
      end_op();
80104838:	e8 1b df ff ff       	call   80102758 <end_op>
      return -1;
8010483d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104842:	eb e3                	jmp    80104827 <sys_open+0xb5>
    if((ip = namei(path)) == 0){
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	ff 75 e4             	push   -0x1c(%ebp)
8010484a:	e8 1b d3 ff ff       	call   80101b6a <namei>
8010484f:	89 c6                	mov    %eax,%esi
80104851:	83 c4 10             	add    $0x10,%esp
80104854:	85 c0                	test   %eax,%eax
80104856:	74 39                	je     80104891 <sys_open+0x11f>
    ilock(ip);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	50                   	push   %eax
8010485c:	e8 a5 cc ff ff       	call   80101506 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104861:	83 c4 10             	add    $0x10,%esp
80104864:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104869:	0f 85 6a ff ff ff    	jne    801047d9 <sys_open+0x67>
8010486f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104873:	0f 84 60 ff ff ff    	je     801047d9 <sys_open+0x67>
      iunlockput(ip);
80104879:	83 ec 0c             	sub    $0xc,%esp
8010487c:	56                   	push   %esi
8010487d:	e8 27 ce ff ff       	call   801016a9 <iunlockput>
      end_op();
80104882:	e8 d1 de ff ff       	call   80102758 <end_op>
      return -1;
80104887:	83 c4 10             	add    $0x10,%esp
8010488a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010488f:	eb 96                	jmp    80104827 <sys_open+0xb5>
      end_op();
80104891:	e8 c2 de ff ff       	call   80102758 <end_op>
      return -1;
80104896:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010489b:	eb 8a                	jmp    80104827 <sys_open+0xb5>
    if(f)
8010489d:	85 db                	test   %ebx,%ebx
8010489f:	74 0c                	je     801048ad <sys_open+0x13b>
      fileclose(f);
801048a1:	83 ec 0c             	sub    $0xc,%esp
801048a4:	53                   	push   %ebx
801048a5:	e8 e0 c3 ff ff       	call   80100c8a <fileclose>
801048aa:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801048ad:	83 ec 0c             	sub    $0xc,%esp
801048b0:	56                   	push   %esi
801048b1:	e8 f3 cd ff ff       	call   801016a9 <iunlockput>
    end_op();
801048b6:	e8 9d de ff ff       	call   80102758 <end_op>
    return -1;
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048c3:	e9 5f ff ff ff       	jmp    80104827 <sys_open+0xb5>

801048c8 <sys_mkdir>:

int
sys_mkdir(void)
{
801048c8:	55                   	push   %ebp
801048c9:	89 e5                	mov    %esp,%ebp
801048cb:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801048ce:	e8 09 de ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801048d3:	83 ec 08             	sub    $0x8,%esp
801048d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048d9:	50                   	push   %eax
801048da:	6a 00                	push   $0x0
801048dc:	e8 8b f6 ff ff       	call   80103f6c <argstr>
801048e1:	83 c4 10             	add    $0x10,%esp
801048e4:	85 c0                	test   %eax,%eax
801048e6:	78 36                	js     8010491e <sys_mkdir+0x56>
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	6a 00                	push   $0x0
801048ed:	b9 00 00 00 00       	mov    $0x0,%ecx
801048f2:	ba 01 00 00 00       	mov    $0x1,%edx
801048f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fa:	e8 e2 f7 ff ff       	call   801040e1 <create>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	74 18                	je     8010491e <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104906:	83 ec 0c             	sub    $0xc,%esp
80104909:	50                   	push   %eax
8010490a:	e8 9a cd ff ff       	call   801016a9 <iunlockput>
  end_op();
8010490f:	e8 44 de ff ff       	call   80102758 <end_op>
  return 0;
80104914:	83 c4 10             	add    $0x10,%esp
80104917:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010491c:	c9                   	leave  
8010491d:	c3                   	ret    
    end_op();
8010491e:	e8 35 de ff ff       	call   80102758 <end_op>
    return -1;
80104923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104928:	eb f2                	jmp    8010491c <sys_mkdir+0x54>

8010492a <sys_mknod>:

int
sys_mknod(void)
{
8010492a:	55                   	push   %ebp
8010492b:	89 e5                	mov    %esp,%ebp
8010492d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104930:	e8 a7 dd ff ff       	call   801026dc <begin_op>
  if((argstr(0, &path)) < 0 ||
80104935:	83 ec 08             	sub    $0x8,%esp
80104938:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010493b:	50                   	push   %eax
8010493c:	6a 00                	push   $0x0
8010493e:	e8 29 f6 ff ff       	call   80103f6c <argstr>
80104943:	83 c4 10             	add    $0x10,%esp
80104946:	85 c0                	test   %eax,%eax
80104948:	78 62                	js     801049ac <sys_mknod+0x82>
     argint(1, &major) < 0 ||
8010494a:	83 ec 08             	sub    $0x8,%esp
8010494d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104950:	50                   	push   %eax
80104951:	6a 01                	push   $0x1
80104953:	e8 84 f5 ff ff       	call   80103edc <argint>
  if((argstr(0, &path)) < 0 ||
80104958:	83 c4 10             	add    $0x10,%esp
8010495b:	85 c0                	test   %eax,%eax
8010495d:	78 4d                	js     801049ac <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
8010495f:	83 ec 08             	sub    $0x8,%esp
80104962:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104965:	50                   	push   %eax
80104966:	6a 02                	push   $0x2
80104968:	e8 6f f5 ff ff       	call   80103edc <argint>
     argint(1, &major) < 0 ||
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	85 c0                	test   %eax,%eax
80104972:	78 38                	js     801049ac <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104974:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104978:	83 ec 0c             	sub    $0xc,%esp
8010497b:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
8010497f:	50                   	push   %eax
80104980:	ba 03 00 00 00       	mov    $0x3,%edx
80104985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104988:	e8 54 f7 ff ff       	call   801040e1 <create>
     argint(2, &minor) < 0 ||
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	85 c0                	test   %eax,%eax
80104992:	74 18                	je     801049ac <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	50                   	push   %eax
80104998:	e8 0c cd ff ff       	call   801016a9 <iunlockput>
  end_op();
8010499d:	e8 b6 dd ff ff       	call   80102758 <end_op>
  return 0;
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049aa:	c9                   	leave  
801049ab:	c3                   	ret    
    end_op();
801049ac:	e8 a7 dd ff ff       	call   80102758 <end_op>
    return -1;
801049b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b6:	eb f2                	jmp    801049aa <sys_mknod+0x80>

801049b8 <sys_chdir>:

int
sys_chdir(void)
{
801049b8:	55                   	push   %ebp
801049b9:	89 e5                	mov    %esp,%ebp
801049bb:	56                   	push   %esi
801049bc:	53                   	push   %ebx
801049bd:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801049c0:	e8 5d e7 ff ff       	call   80103122 <myproc>
801049c5:	89 c6                	mov    %eax,%esi
  
  begin_op();
801049c7:	e8 10 dd ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801049cc:	83 ec 08             	sub    $0x8,%esp
801049cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049d2:	50                   	push   %eax
801049d3:	6a 00                	push   $0x0
801049d5:	e8 92 f5 ff ff       	call   80103f6c <argstr>
801049da:	83 c4 10             	add    $0x10,%esp
801049dd:	85 c0                	test   %eax,%eax
801049df:	78 52                	js     80104a33 <sys_chdir+0x7b>
801049e1:	83 ec 0c             	sub    $0xc,%esp
801049e4:	ff 75 f4             	push   -0xc(%ebp)
801049e7:	e8 7e d1 ff ff       	call   80101b6a <namei>
801049ec:	89 c3                	mov    %eax,%ebx
801049ee:	83 c4 10             	add    $0x10,%esp
801049f1:	85 c0                	test   %eax,%eax
801049f3:	74 3e                	je     80104a33 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
801049f5:	83 ec 0c             	sub    $0xc,%esp
801049f8:	50                   	push   %eax
801049f9:	e8 08 cb ff ff       	call   80101506 <ilock>
  if(ip->type != T_DIR){
801049fe:	83 c4 10             	add    $0x10,%esp
80104a01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104a06:	75 37                	jne    80104a3f <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	53                   	push   %ebx
80104a0c:	e8 b5 cb ff ff       	call   801015c6 <iunlock>
  iput(curproc->cwd);
80104a11:	83 c4 04             	add    $0x4,%esp
80104a14:	ff 76 68             	push   0x68(%esi)
80104a17:	e8 ef cb ff ff       	call   8010160b <iput>
  end_op();
80104a1c:	e8 37 dd ff ff       	call   80102758 <end_op>
  curproc->cwd = ip;
80104a21:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104a24:	83 c4 10             	add    $0x10,%esp
80104a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a2f:	5b                   	pop    %ebx
80104a30:	5e                   	pop    %esi
80104a31:	5d                   	pop    %ebp
80104a32:	c3                   	ret    
    end_op();
80104a33:	e8 20 dd ff ff       	call   80102758 <end_op>
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a3d:	eb ed                	jmp    80104a2c <sys_chdir+0x74>
    iunlockput(ip);
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	53                   	push   %ebx
80104a43:	e8 61 cc ff ff       	call   801016a9 <iunlockput>
    end_op();
80104a48:	e8 0b dd ff ff       	call   80102758 <end_op>
    return -1;
80104a4d:	83 c4 10             	add    $0x10,%esp
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb d5                	jmp    80104a2c <sys_chdir+0x74>

80104a57 <sys_exec>:

int
sys_exec(void)
{
80104a57:	55                   	push   %ebp
80104a58:	89 e5                	mov    %esp,%ebp
80104a5a:	53                   	push   %ebx
80104a5b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104a61:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a64:	50                   	push   %eax
80104a65:	6a 00                	push   $0x0
80104a67:	e8 00 f5 ff ff       	call   80103f6c <argstr>
80104a6c:	83 c4 10             	add    $0x10,%esp
80104a6f:	85 c0                	test   %eax,%eax
80104a71:	78 38                	js     80104aab <sys_exec+0x54>
80104a73:	83 ec 08             	sub    $0x8,%esp
80104a76:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104a7c:	50                   	push   %eax
80104a7d:	6a 01                	push   $0x1
80104a7f:	e8 58 f4 ff ff       	call   80103edc <argint>
80104a84:	83 c4 10             	add    $0x10,%esp
80104a87:	85 c0                	test   %eax,%eax
80104a89:	78 20                	js     80104aab <sys_exec+0x54>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104a8b:	83 ec 04             	sub    $0x4,%esp
80104a8e:	68 80 00 00 00       	push   $0x80
80104a93:	6a 00                	push   $0x0
80104a95:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104a9b:	50                   	push   %eax
80104a9c:	e8 ec f1 ff ff       	call   80103c8d <memset>
80104aa1:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104aa4:	bb 00 00 00 00       	mov    $0x0,%ebx
80104aa9:	eb 2a                	jmp    80104ad5 <sys_exec+0x7e>
    return -1;
80104aab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab0:	eb 76                	jmp    80104b28 <sys_exec+0xd1>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104ab2:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104ab9:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104abd:	83 ec 08             	sub    $0x8,%esp
80104ac0:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104ac6:	50                   	push   %eax
80104ac7:	ff 75 f4             	push   -0xc(%ebp)
80104aca:	e8 c1 bd ff ff       	call   80100890 <exec>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	eb 54                	jmp    80104b28 <sys_exec+0xd1>
  for(i=0;; i++){
80104ad4:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104ad5:	83 fb 1f             	cmp    $0x1f,%ebx
80104ad8:	77 49                	ja     80104b23 <sys_exec+0xcc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104ada:	83 ec 08             	sub    $0x8,%esp
80104add:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104ae3:	50                   	push   %eax
80104ae4:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104aea:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104aed:	50                   	push   %eax
80104aee:	e8 71 f3 ff ff       	call   80103e64 <fetchint>
80104af3:	83 c4 10             	add    $0x10,%esp
80104af6:	85 c0                	test   %eax,%eax
80104af8:	78 33                	js     80104b2d <sys_exec+0xd6>
    if(uarg == 0){
80104afa:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104b00:	85 c0                	test   %eax,%eax
80104b02:	74 ae                	je     80104ab2 <sys_exec+0x5b>
    if(fetchstr(uarg, &argv[i]) < 0)
80104b04:	83 ec 08             	sub    $0x8,%esp
80104b07:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104b0e:	52                   	push   %edx
80104b0f:	50                   	push   %eax
80104b10:	e8 8a f3 ff ff       	call   80103e9f <fetchstr>
80104b15:	83 c4 10             	add    $0x10,%esp
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	79 b8                	jns    80104ad4 <sys_exec+0x7d>
      return -1;
80104b1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b21:	eb 05                	jmp    80104b28 <sys_exec+0xd1>
      return -1;
80104b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2b:	c9                   	leave  
80104b2c:	c3                   	ret    
      return -1;
80104b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b32:	eb f4                	jmp    80104b28 <sys_exec+0xd1>

80104b34 <sys_pipe>:

int
sys_pipe(void)
{
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	53                   	push   %ebx
80104b38:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104b3b:	6a 08                	push   $0x8
80104b3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b40:	50                   	push   %eax
80104b41:	6a 00                	push   $0x0
80104b43:	e8 bc f3 ff ff       	call   80103f04 <argptr>
80104b48:	83 c4 10             	add    $0x10,%esp
80104b4b:	85 c0                	test   %eax,%eax
80104b4d:	78 79                	js     80104bc8 <sys_pipe+0x94>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104b4f:	83 ec 08             	sub    $0x8,%esp
80104b52:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104b55:	50                   	push   %eax
80104b56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b59:	50                   	push   %eax
80104b5a:	e8 13 e1 ff ff       	call   80102c72 <pipealloc>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	78 69                	js     80104bcf <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b69:	e8 e8 f4 ff ff       	call   80104056 <fdalloc>
80104b6e:	89 c3                	mov    %eax,%ebx
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 21                	js     80104b95 <sys_pipe+0x61>
80104b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b77:	e8 da f4 ff ff       	call   80104056 <fdalloc>
80104b7c:	85 c0                	test   %eax,%eax
80104b7e:	78 15                	js     80104b95 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b83:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b88:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b93:	c9                   	leave  
80104b94:	c3                   	ret    
    if(fd0 >= 0)
80104b95:	85 db                	test   %ebx,%ebx
80104b97:	79 20                	jns    80104bb9 <sys_pipe+0x85>
    fileclose(rf);
80104b99:	83 ec 0c             	sub    $0xc,%esp
80104b9c:	ff 75 f0             	push   -0x10(%ebp)
80104b9f:	e8 e6 c0 ff ff       	call   80100c8a <fileclose>
    fileclose(wf);
80104ba4:	83 c4 04             	add    $0x4,%esp
80104ba7:	ff 75 ec             	push   -0x14(%ebp)
80104baa:	e8 db c0 ff ff       	call   80100c8a <fileclose>
    return -1;
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb7:	eb d7                	jmp    80104b90 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104bb9:	e8 64 e5 ff ff       	call   80103122 <myproc>
80104bbe:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104bc5:	00 
80104bc6:	eb d1                	jmp    80104b99 <sys_pipe+0x65>
    return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bcd:	eb c1                	jmp    80104b90 <sys_pipe+0x5c>
    return -1;
80104bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd4:	eb ba                	jmp    80104b90 <sys_pipe+0x5c>

80104bd6 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104bd6:	55                   	push   %ebp
80104bd7:	89 e5                	mov    %esp,%ebp
80104bd9:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104bdc:	e8 34 e7 ff ff       	call   80103315 <fork>
}
80104be1:	c9                   	leave  
80104be2:	c3                   	ret    

80104be3 <sys_exit>:

int
sys_exit(void)
{
80104be3:	55                   	push   %ebp
80104be4:	89 e5                	mov    %esp,%ebp
80104be6:	83 ec 20             	sub    $0x20,%esp
  int e;

  if(argint(0, &e) < 0)
80104be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bec:	50                   	push   %eax
80104bed:	6a 00                	push   $0x0
80104bef:	e8 e8 f2 ff ff       	call   80103edc <argint>
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	78 15                	js     80104c10 <sys_exit+0x2d>
    return -1;
  exit(e);
80104bfb:	83 ec 0c             	sub    $0xc,%esp
80104bfe:	ff 75 f4             	push   -0xc(%ebp)
80104c01:	e8 99 e9 ff ff       	call   8010359f <exit>
  return 0;  // not reached
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c0e:	c9                   	leave  
80104c0f:	c3                   	ret    
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb f7                	jmp    80104c0e <sys_exit+0x2b>

80104c17 <sys_wait>:

int
sys_wait(void)
{
80104c17:	55                   	push   %ebp
80104c18:	89 e5                	mov    %esp,%ebp
80104c1a:	83 ec 1c             	sub    $0x1c,%esp
  int *w;
  int child;


  if(argptr(0, (void **)&w, sizeof(int)) < 0)
80104c1d:	6a 04                	push   $0x4
80104c1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c22:	50                   	push   %eax
80104c23:	6a 00                	push   $0x0
80104c25:	e8 da f2 ff ff       	call   80103f04 <argptr>
80104c2a:	83 c4 10             	add    $0x10,%esp
80104c2d:	85 c0                	test   %eax,%eax
80104c2f:	78 10                	js     80104c41 <sys_wait+0x2a>
    return -1;
  child = wait(w);
80104c31:	83 ec 0c             	sub    $0xc,%esp
80104c34:	ff 75 f4             	push   -0xc(%ebp)
80104c37:	e8 11 eb ff ff       	call   8010374d <wait>
  return child;
80104c3c:	83 c4 10             	add    $0x10,%esp
}
80104c3f:	c9                   	leave  
80104c40:	c3                   	ret    
    return -1;
80104c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c46:	eb f7                	jmp    80104c3f <sys_wait+0x28>

80104c48 <sys_kill>:

int
sys_kill(void)
{
80104c48:	55                   	push   %ebp
80104c49:	89 e5                	mov    %esp,%ebp
80104c4b:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104c4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c51:	50                   	push   %eax
80104c52:	6a 00                	push   $0x0
80104c54:	e8 83 f2 ff ff       	call   80103edc <argint>
80104c59:	83 c4 10             	add    $0x10,%esp
80104c5c:	85 c0                	test   %eax,%eax
80104c5e:	78 10                	js     80104c70 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104c60:	83 ec 0c             	sub    $0xc,%esp
80104c63:	ff 75 f4             	push   -0xc(%ebp)
80104c66:	e8 ff eb ff ff       	call   8010386a <kill>
80104c6b:	83 c4 10             	add    $0x10,%esp
}
80104c6e:	c9                   	leave  
80104c6f:	c3                   	ret    
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c75:	eb f7                	jmp    80104c6e <sys_kill+0x26>

80104c77 <sys_getpid>:

int
sys_getpid(void)
{
80104c77:	55                   	push   %ebp
80104c78:	89 e5                	mov    %esp,%ebp
80104c7a:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104c7d:	e8 a0 e4 ff ff       	call   80103122 <myproc>
80104c82:	8b 40 10             	mov    0x10(%eax),%eax
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    

80104c87 <sys_sbrk>:

int
sys_sbrk(void)
{
80104c87:	55                   	push   %ebp
80104c88:	89 e5                	mov    %esp,%ebp
80104c8a:	53                   	push   %ebx
80104c8b:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104c8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c91:	50                   	push   %eax
80104c92:	6a 00                	push   $0x0
80104c94:	e8 43 f2 ff ff       	call   80103edc <argint>
80104c99:	83 c4 10             	add    $0x10,%esp
80104c9c:	85 c0                	test   %eax,%eax
80104c9e:	78 36                	js     80104cd6 <sys_sbrk+0x4f>
    return -1;
  addr = myproc()->sz;
80104ca0:	e8 7d e4 ff ff       	call   80103122 <myproc>
80104ca5:	8b 18                	mov    (%eax),%ebx

  if (n > 0) {
80104ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104caa:	85 c0                	test   %eax,%eax
80104cac:	7e 11                	jle    80104cbf <sys_sbrk+0x38>
    myproc()->sz +=n;
80104cae:	e8 6f e4 ff ff       	call   80103122 <myproc>
80104cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cb6:	01 10                	add    %edx,(%eax)
  else {
    if(growproc(n) < 0)
      return -1;
  }
  return addr;
}
80104cb8:	89 d8                	mov    %ebx,%eax
80104cba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cbd:	c9                   	leave  
80104cbe:	c3                   	ret    
    if(growproc(n) < 0)
80104cbf:	83 ec 0c             	sub    $0xc,%esp
80104cc2:	50                   	push   %eax
80104cc3:	e8 e3 e5 ff ff       	call   801032ab <growproc>
80104cc8:	83 c4 10             	add    $0x10,%esp
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	79 e9                	jns    80104cb8 <sys_sbrk+0x31>
      return -1;
80104ccf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cd4:	eb e2                	jmp    80104cb8 <sys_sbrk+0x31>
    return -1;
80104cd6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cdb:	eb db                	jmp    80104cb8 <sys_sbrk+0x31>

80104cdd <sys_sleep>:

int
sys_sleep(void)
{
80104cdd:	55                   	push   %ebp
80104cde:	89 e5                	mov    %esp,%ebp
80104ce0:	53                   	push   %ebx
80104ce1:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce7:	50                   	push   %eax
80104ce8:	6a 00                	push   $0x0
80104cea:	e8 ed f1 ff ff       	call   80103edc <argint>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 75                	js     80104d6b <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104cf6:	83 ec 0c             	sub    $0xc,%esp
80104cf9:	68 e0 3f 11 80       	push   $0x80113fe0
80104cfe:	e8 de ee ff ff       	call   80103be1 <acquire>
  ticks0 = ticks;
80104d03:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  while(ticks - ticks0 < n){
80104d09:	83 c4 10             	add    $0x10,%esp
80104d0c:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80104d11:	29 d8                	sub    %ebx,%eax
80104d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104d16:	73 39                	jae    80104d51 <sys_sleep+0x74>
    if(myproc()->killed){
80104d18:	e8 05 e4 ff ff       	call   80103122 <myproc>
80104d1d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104d21:	75 17                	jne    80104d3a <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104d23:	83 ec 08             	sub    $0x8,%esp
80104d26:	68 e0 3f 11 80       	push   $0x80113fe0
80104d2b:	68 c0 3f 11 80       	push   $0x80113fc0
80104d30:	e8 87 e9 ff ff       	call   801036bc <sleep>
80104d35:	83 c4 10             	add    $0x10,%esp
80104d38:	eb d2                	jmp    80104d0c <sys_sleep+0x2f>
      release(&tickslock);
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	68 e0 3f 11 80       	push   $0x80113fe0
80104d42:	e8 ff ee ff ff       	call   80103c46 <release>
      return -1;
80104d47:	83 c4 10             	add    $0x10,%esp
80104d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d4f:	eb 15                	jmp    80104d66 <sys_sleep+0x89>
  }
  release(&tickslock);
80104d51:	83 ec 0c             	sub    $0xc,%esp
80104d54:	68 e0 3f 11 80       	push   $0x80113fe0
80104d59:	e8 e8 ee ff ff       	call   80103c46 <release>
  return 0;
80104d5e:	83 c4 10             	add    $0x10,%esp
80104d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d69:	c9                   	leave  
80104d6a:	c3                   	ret    
    return -1;
80104d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d70:	eb f4                	jmp    80104d66 <sys_sleep+0x89>

80104d72 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104d72:	55                   	push   %ebp
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	53                   	push   %ebx
80104d76:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104d79:	68 e0 3f 11 80       	push   $0x80113fe0
80104d7e:	e8 5e ee ff ff       	call   80103be1 <acquire>
  xticks = ticks;
80104d83:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  release(&tickslock);
80104d89:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104d90:	e8 b1 ee ff ff       	call   80103c46 <release>
  return xticks;
}
80104d95:	89 d8                	mov    %ebx,%eax
80104d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d9a:	c9                   	leave  
80104d9b:	c3                   	ret    

80104d9c <sys_date>:

int
sys_date(void)
{
80104d9c:	55                   	push   %ebp
80104d9d:	89 e5                	mov    %esp,%ebp
80104d9f:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;

  if(argptr(0, (void **)&r, sizeof(struct rtcdate)) < 0)
80104da2:	6a 18                	push   $0x18
80104da4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da7:	50                   	push   %eax
80104da8:	6a 00                	push   $0x0
80104daa:	e8 55 f1 ff ff       	call   80103f04 <argptr>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	78 15                	js     80104dcb <sys_date+0x2f>
    return -1;
  cmostime(r);
80104db6:	83 ec 0c             	sub    $0xc,%esp
80104db9:	ff 75 f4             	push   -0xc(%ebp)
80104dbc:	e8 ed d5 ff ff       	call   801023ae <cmostime>
  return 0;
80104dc1:	83 c4 10             	add    $0x10,%esp
80104dc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dc9:	c9                   	leave  
80104dca:	c3                   	ret    
    return -1;
80104dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd0:	eb f7                	jmp    80104dc9 <sys_date+0x2d>

80104dd2 <alltraps>:
80104dd2:	1e                   	push   %ds
80104dd3:	06                   	push   %es
80104dd4:	0f a0                	push   %fs
80104dd6:	0f a8                	push   %gs
80104dd8:	60                   	pusha  
80104dd9:	66 b8 10 00          	mov    $0x10,%ax
80104ddd:	8e d8                	mov    %eax,%ds
80104ddf:	8e c0                	mov    %eax,%es
80104de1:	54                   	push   %esp
80104de2:	e8 2f 01 00 00       	call   80104f16 <trap>
80104de7:	83 c4 04             	add    $0x4,%esp

80104dea <trapret>:
80104dea:	61                   	popa   
80104deb:	0f a9                	pop    %gs
80104ded:	0f a1                	pop    %fs
80104def:	07                   	pop    %es
80104df0:	1f                   	pop    %ds
80104df1:	83 c4 08             	add    $0x8,%esp
80104df4:	cf                   	iret   

80104df5 <tvinit>:
int 
mappages(pde_t *pdgir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
80104df5:	55                   	push   %ebp
80104df6:	89 e5                	mov    %esp,%ebp
80104df8:	53                   	push   %ebx
80104df9:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80104dfc:	b8 00 00 00 00       	mov    $0x0,%eax
80104e01:	eb 72                	jmp    80104e75 <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104e03:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104e0a:	66 89 0c c5 20 40 11 	mov    %cx,-0x7feebfe0(,%eax,8)
80104e11:	80 
80104e12:	66 c7 04 c5 22 40 11 	movw   $0x8,-0x7feebfde(,%eax,8)
80104e19:	80 08 00 
80104e1c:	8a 14 c5 24 40 11 80 	mov    -0x7feebfdc(,%eax,8),%dl
80104e23:	83 e2 e0             	and    $0xffffffe0,%edx
80104e26:	88 14 c5 24 40 11 80 	mov    %dl,-0x7feebfdc(,%eax,8)
80104e2d:	c6 04 c5 24 40 11 80 	movb   $0x0,-0x7feebfdc(,%eax,8)
80104e34:	00 
80104e35:	8a 14 c5 25 40 11 80 	mov    -0x7feebfdb(,%eax,8),%dl
80104e3c:	83 e2 f0             	and    $0xfffffff0,%edx
80104e3f:	83 ca 0e             	or     $0xe,%edx
80104e42:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80104e49:	88 d3                	mov    %dl,%bl
80104e4b:	83 e3 ef             	and    $0xffffffef,%ebx
80104e4e:	88 1c c5 25 40 11 80 	mov    %bl,-0x7feebfdb(,%eax,8)
80104e55:	83 e2 8f             	and    $0xffffff8f,%edx
80104e58:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80104e5f:	83 ca 80             	or     $0xffffff80,%edx
80104e62:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80104e69:	c1 e9 10             	shr    $0x10,%ecx
80104e6c:	66 89 0c c5 26 40 11 	mov    %cx,-0x7feebfda(,%eax,8)
80104e73:	80 
  for(i = 0; i < 256; i++)
80104e74:	40                   	inc    %eax
80104e75:	3d ff 00 00 00       	cmp    $0xff,%eax
80104e7a:	7e 87                	jle    80104e03 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104e7c:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104e82:	66 89 15 20 42 11 80 	mov    %dx,0x80114220
80104e89:	66 c7 05 22 42 11 80 	movw   $0x8,0x80114222
80104e90:	08 00 
80104e92:	a0 24 42 11 80       	mov    0x80114224,%al
80104e97:	83 e0 e0             	and    $0xffffffe0,%eax
80104e9a:	a2 24 42 11 80       	mov    %al,0x80114224
80104e9f:	c6 05 24 42 11 80 00 	movb   $0x0,0x80114224
80104ea6:	a0 25 42 11 80       	mov    0x80114225,%al
80104eab:	83 c8 0f             	or     $0xf,%eax
80104eae:	a2 25 42 11 80       	mov    %al,0x80114225
80104eb3:	83 e0 ef             	and    $0xffffffef,%eax
80104eb6:	a2 25 42 11 80       	mov    %al,0x80114225
80104ebb:	88 c1                	mov    %al,%cl
80104ebd:	83 c9 60             	or     $0x60,%ecx
80104ec0:	88 0d 25 42 11 80    	mov    %cl,0x80114225
80104ec6:	83 c8 e0             	or     $0xffffffe0,%eax
80104ec9:	a2 25 42 11 80       	mov    %al,0x80114225
80104ece:	c1 ea 10             	shr    $0x10,%edx
80104ed1:	66 89 15 26 42 11 80 	mov    %dx,0x80114226

  initlock(&tickslock, "time");
80104ed8:	83 ec 08             	sub    $0x8,%esp
80104edb:	68 c1 6f 10 80       	push   $0x80106fc1
80104ee0:	68 e0 3f 11 80       	push   $0x80113fe0
80104ee5:	e8 c0 eb ff ff       	call   80103aaa <initlock>
}
80104eea:	83 c4 10             	add    $0x10,%esp
80104eed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ef0:	c9                   	leave  
80104ef1:	c3                   	ret    

80104ef2 <idtinit>:

void
idtinit(void)
{
80104ef2:	55                   	push   %ebp
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104ef8:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104efe:	b8 20 40 11 80       	mov    $0x80114020,%eax
80104f03:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104f07:	c1 e8 10             	shr    $0x10,%eax
80104f0a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104f0e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104f11:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104f14:	c9                   	leave  
80104f15:	c3                   	ret    

80104f16 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104f16:	55                   	push   %ebp
80104f17:	89 e5                	mov    %esp,%ebp
80104f19:	57                   	push   %edi
80104f1a:	56                   	push   %esi
80104f1b:	53                   	push   %ebx
80104f1c:	83 ec 1c             	sub    $0x1c,%esp
80104f1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104f22:	8b 43 30             	mov    0x30(%ebx),%eax
80104f25:	83 f8 40             	cmp    $0x40,%eax
80104f28:	74 13                	je     80104f3d <trap+0x27>
    if(myproc()->killed)
      exit(tf->trapno + 1);
    return;
  }

  switch(tf->trapno){
80104f2a:	83 e8 0c             	sub    $0xc,%eax
80104f2d:	83 f8 33             	cmp    $0x33,%eax
80104f30:	0f 87 46 02 00 00    	ja     8010517c <trap+0x266>
80104f36:	ff 24 85 a8 70 10 80 	jmp    *-0x7fef8f58(,%eax,4)
    if(myproc()->killed)
80104f3d:	e8 e0 e1 ff ff       	call   80103122 <myproc>
80104f42:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f46:	75 31                	jne    80104f79 <trap+0x63>
    myproc()->tf = tf;
80104f48:	e8 d5 e1 ff ff       	call   80103122 <myproc>
80104f4d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104f50:	e8 4a f0 ff ff       	call   80103f9f <syscall>
    if(myproc()->killed)
80104f55:	e8 c8 e1 ff ff       	call   80103122 <myproc>
80104f5a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f5e:	0f 84 95 00 00 00    	je     80104ff9 <trap+0xe3>
      exit(tf->trapno + 1);
80104f64:	8b 43 30             	mov    0x30(%ebx),%eax
80104f67:	40                   	inc    %eax
80104f68:	83 ec 0c             	sub    $0xc,%esp
80104f6b:	50                   	push   %eax
80104f6c:	e8 2e e6 ff ff       	call   8010359f <exit>
80104f71:	83 c4 10             	add    $0x10,%esp
    return;
80104f74:	e9 80 00 00 00       	jmp    80104ff9 <trap+0xe3>
      exit(tf->trapno + 1);
80104f79:	8b 43 30             	mov    0x30(%ebx),%eax
80104f7c:	40                   	inc    %eax
80104f7d:	83 ec 0c             	sub    $0xc,%esp
80104f80:	50                   	push   %eax
80104f81:	e8 19 e6 ff ff       	call   8010359f <exit>
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	eb bd                	jmp    80104f48 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104f8b:	e8 61 e1 ff ff       	call   801030f1 <cpuid>
80104f90:	85 c0                	test   %eax,%eax
80104f92:	74 6d                	je     80105001 <trap+0xeb>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80104f94:	e8 60 d3 ff ff       	call   801022f9 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f99:	e8 84 e1 ff ff       	call   80103122 <myproc>
80104f9e:	85 c0                	test   %eax,%eax
80104fa0:	74 1b                	je     80104fbd <trap+0xa7>
80104fa2:	e8 7b e1 ff ff       	call   80103122 <myproc>
80104fa7:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fab:	74 10                	je     80104fbd <trap+0xa7>
80104fad:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104fb0:	83 e0 03             	and    $0x3,%eax
80104fb3:	66 83 f8 03          	cmp    $0x3,%ax
80104fb7:	0f 84 52 02 00 00    	je     8010520f <trap+0x2f9>
    exit(tf->trapno + 1);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104fbd:	e8 60 e1 ff ff       	call   80103122 <myproc>
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	74 0f                	je     80104fd5 <trap+0xbf>
80104fc6:	e8 57 e1 ff ff       	call   80103122 <myproc>
80104fcb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104fcf:	0f 84 4f 02 00 00    	je     80105224 <trap+0x30e>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104fd5:	e8 48 e1 ff ff       	call   80103122 <myproc>
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	74 1b                	je     80104ff9 <trap+0xe3>
80104fde:	e8 3f e1 ff ff       	call   80103122 <myproc>
80104fe3:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fe7:	74 10                	je     80104ff9 <trap+0xe3>
80104fe9:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104fec:	83 e0 03             	and    $0x3,%eax
80104fef:	66 83 f8 03          	cmp    $0x3,%ax
80104ff3:	0f 84 3f 02 00 00    	je     80105238 <trap+0x322>
    exit(tf->trapno + 1);
}
80104ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffc:	5b                   	pop    %ebx
80104ffd:	5e                   	pop    %esi
80104ffe:	5f                   	pop    %edi
80104fff:	5d                   	pop    %ebp
80105000:	c3                   	ret    
      acquire(&tickslock);
80105001:	83 ec 0c             	sub    $0xc,%esp
80105004:	68 e0 3f 11 80       	push   $0x80113fe0
80105009:	e8 d3 eb ff ff       	call   80103be1 <acquire>
      ticks++;
8010500e:	ff 05 c0 3f 11 80    	incl   0x80113fc0
      wakeup(&ticks);
80105014:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
8010501b:	e8 21 e8 ff ff       	call   80103841 <wakeup>
      release(&tickslock);
80105020:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80105027:	e8 1a ec ff ff       	call   80103c46 <release>
8010502c:	83 c4 10             	add    $0x10,%esp
8010502f:	e9 60 ff ff ff       	jmp    80104f94 <trap+0x7e>
    ideintr();
80105034:	e8 a9 cc ff ff       	call   80101ce2 <ideintr>
    lapiceoi();
80105039:	e8 bb d2 ff ff       	call   801022f9 <lapiceoi>
    break;
8010503e:	e9 56 ff ff ff       	jmp    80104f99 <trap+0x83>
    kbdintr();
80105043:	e8 fb d0 ff ff       	call   80102143 <kbdintr>
    lapiceoi();
80105048:	e8 ac d2 ff ff       	call   801022f9 <lapiceoi>
    break;
8010504d:	e9 47 ff ff ff       	jmp    80104f99 <trap+0x83>
    uartintr();
80105052:	e8 f2 02 00 00       	call   80105349 <uartintr>
    lapiceoi();
80105057:	e8 9d d2 ff ff       	call   801022f9 <lapiceoi>
    break;
8010505c:	e9 38 ff ff ff       	jmp    80104f99 <trap+0x83>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105061:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105064:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105067:	e8 85 e0 ff ff       	call   801030f1 <cpuid>
8010506c:	57                   	push   %edi
8010506d:	0f b7 f6             	movzwl %si,%esi
80105070:	56                   	push   %esi
80105071:	50                   	push   %eax
80105072:	68 0c 70 10 80       	push   $0x8010700c
80105077:	e8 5e b5 ff ff       	call   801005da <cprintf>
    lapiceoi();
8010507c:	e8 78 d2 ff ff       	call   801022f9 <lapiceoi>
    break;
80105081:	83 c4 10             	add    $0x10,%esp
80105084:	e9 10 ff ff ff       	jmp    80104f99 <trap+0x83>
    if(myproc() == 0){
80105089:	e8 94 e0 ff ff       	call   80103122 <myproc>
8010508e:	85 c0                	test   %eax,%eax
80105090:	74 7d                	je     8010510f <trap+0x1f9>
    mem = kalloc();
80105092:	e8 90 cf ff ff       	call   80102027 <kalloc>
80105097:	89 c6                	mov    %eax,%esi
    if (mem == 0) {
80105099:	85 c0                	test   %eax,%eax
8010509b:	0f 84 99 00 00 00    	je     8010513a <trap+0x224>
    memset(mem, 0, PGSIZE);
801050a1:	83 ec 04             	sub    $0x4,%esp
801050a4:	68 00 10 00 00       	push   $0x1000
801050a9:	6a 00                	push   $0x0
801050ab:	56                   	push   %esi
801050ac:	e8 dc eb ff ff       	call   80103c8d <memset>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801050b1:	0f 20 d7             	mov    %cr2,%edi
    if (mappages(myproc()->pgdir, (char*)PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801050b4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801050ba:	e8 63 e0 ff ff       	call   80103122 <myproc>
801050bf:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801050c6:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801050cc:	52                   	push   %edx
801050cd:	68 00 10 00 00       	push   $0x1000
801050d2:	57                   	push   %edi
801050d3:	ff 70 04             	push   0x4(%eax)
801050d6:	e8 36 10 00 00       	call   80106111 <mappages>
801050db:	83 c4 20             	add    $0x20,%esp
801050de:	85 c0                	test   %eax,%eax
801050e0:	0f 89 b3 fe ff ff    	jns    80104f99 <trap+0x83>
      cprintf("page mapping failed\n");
801050e6:	83 ec 0c             	sub    $0xc,%esp
801050e9:	68 e5 6f 10 80       	push   $0x80106fe5
801050ee:	e8 e7 b4 ff ff       	call   801005da <cprintf>
      kfree(mem);
801050f3:	89 34 24             	mov    %esi,(%esp)
801050f6:	e8 15 ce ff ff       	call   80101f10 <kfree>
      myproc()->killed = 1;
801050fb:	e8 22 e0 ff ff       	call   80103122 <myproc>
80105100:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	e9 8a fe ff ff       	jmp    80104f99 <trap+0x83>
8010510f:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105112:	8b 73 38             	mov    0x38(%ebx),%esi
80105115:	e8 d7 df ff ff       	call   801030f1 <cpuid>
8010511a:	83 ec 0c             	sub    $0xc,%esp
8010511d:	57                   	push   %edi
8010511e:	56                   	push   %esi
8010511f:	50                   	push   %eax
80105120:	ff 73 30             	push   0x30(%ebx)
80105123:	68 30 70 10 80       	push   $0x80107030
80105128:	e8 ad b4 ff ff       	call   801005da <cprintf>
      panic("trap");
8010512d:	83 c4 14             	add    $0x14,%esp
80105130:	68 c6 6f 10 80       	push   $0x80106fc6
80105135:	e8 07 b2 ff ff       	call   80100341 <panic>
      cprintf("page fault out of memory\n");
8010513a:	83 ec 0c             	sub    $0xc,%esp
8010513d:	68 cb 6f 10 80       	push   $0x80106fcb
80105142:	e8 93 b4 ff ff       	call   801005da <cprintf>
      myproc()->killed = 1;
80105147:	e8 d6 df ff ff       	call   80103122 <myproc>
8010514c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	e9 46 ff ff ff       	jmp    801050a1 <trap+0x18b>
    cprintf("stack overflow\n");
8010515b:	83 ec 0c             	sub    $0xc,%esp
8010515e:	68 fa 6f 10 80       	push   $0x80106ffa
80105163:	e8 72 b4 ff ff       	call   801005da <cprintf>
    myproc()->killed = 1;
80105168:	e8 b5 df ff ff       	call   80103122 <myproc>
8010516d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    break;
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	e9 1d fe ff ff       	jmp    80104f99 <trap+0x83>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010517c:	e8 a1 df ff ff       	call   80103122 <myproc>
80105181:	85 c0                	test   %eax,%eax
80105183:	74 5f                	je     801051e4 <trap+0x2ce>
80105185:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105189:	74 59                	je     801051e4 <trap+0x2ce>
8010518b:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010518e:	8b 43 38             	mov    0x38(%ebx),%eax
80105191:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105194:	e8 58 df ff ff       	call   801030f1 <cpuid>
80105199:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010519c:	8b 4b 34             	mov    0x34(%ebx),%ecx
8010519f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801051a2:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801051a5:	e8 78 df ff ff       	call   80103122 <myproc>
801051aa:	8d 50 6c             	lea    0x6c(%eax),%edx
801051ad:	89 55 d8             	mov    %edx,-0x28(%ebp)
801051b0:	e8 6d df ff ff       	call   80103122 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801051b5:	57                   	push   %edi
801051b6:	ff 75 e4             	push   -0x1c(%ebp)
801051b9:	ff 75 e0             	push   -0x20(%ebp)
801051bc:	ff 75 dc             	push   -0x24(%ebp)
801051bf:	56                   	push   %esi
801051c0:	ff 75 d8             	push   -0x28(%ebp)
801051c3:	ff 70 10             	push   0x10(%eax)
801051c6:	68 64 70 10 80       	push   $0x80107064
801051cb:	e8 0a b4 ff ff       	call   801005da <cprintf>
    myproc()->killed = 1;
801051d0:	83 c4 20             	add    $0x20,%esp
801051d3:	e8 4a df ff ff       	call   80103122 <myproc>
801051d8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801051df:	e9 b5 fd ff ff       	jmp    80104f99 <trap+0x83>
801051e4:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801051e7:	8b 73 38             	mov    0x38(%ebx),%esi
801051ea:	e8 02 df ff ff       	call   801030f1 <cpuid>
801051ef:	83 ec 0c             	sub    $0xc,%esp
801051f2:	57                   	push   %edi
801051f3:	56                   	push   %esi
801051f4:	50                   	push   %eax
801051f5:	ff 73 30             	push   0x30(%ebx)
801051f8:	68 30 70 10 80       	push   $0x80107030
801051fd:	e8 d8 b3 ff ff       	call   801005da <cprintf>
      panic("trap");
80105202:	83 c4 14             	add    $0x14,%esp
80105205:	68 c6 6f 10 80       	push   $0x80106fc6
8010520a:	e8 32 b1 ff ff       	call   80100341 <panic>
    exit(tf->trapno + 1);
8010520f:	8b 43 30             	mov    0x30(%ebx),%eax
80105212:	40                   	inc    %eax
80105213:	83 ec 0c             	sub    $0xc,%esp
80105216:	50                   	push   %eax
80105217:	e8 83 e3 ff ff       	call   8010359f <exit>
8010521c:	83 c4 10             	add    $0x10,%esp
8010521f:	e9 99 fd ff ff       	jmp    80104fbd <trap+0xa7>
  if(myproc() && myproc()->state == RUNNING &&
80105224:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105228:	0f 85 a7 fd ff ff    	jne    80104fd5 <trap+0xbf>
    yield();
8010522e:	e8 4a e4 ff ff       	call   8010367d <yield>
80105233:	e9 9d fd ff ff       	jmp    80104fd5 <trap+0xbf>
    exit(tf->trapno + 1);
80105238:	8b 43 30             	mov    0x30(%ebx),%eax
8010523b:	40                   	inc    %eax
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	50                   	push   %eax
80105240:	e8 5a e3 ff ff       	call   8010359f <exit>
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	e9 ac fd ff ff       	jmp    80104ff9 <trap+0xe3>

8010524d <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
8010524d:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
80105254:	74 14                	je     8010526a <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105256:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010525b:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010525c:	a8 01                	test   $0x1,%al
8010525e:	74 10                	je     80105270 <uartgetc+0x23>
80105260:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105265:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105266:	0f b6 c0             	movzbl %al,%eax
80105269:	c3                   	ret    
    return -1;
8010526a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526f:	c3                   	ret    
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105275:	c3                   	ret    

80105276 <uartputc>:
  if(!uart)
80105276:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
8010527d:	74 39                	je     801052b8 <uartputc+0x42>
{
8010527f:	55                   	push   %ebp
80105280:	89 e5                	mov    %esp,%ebp
80105282:	53                   	push   %ebx
80105283:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105286:	bb 00 00 00 00       	mov    $0x0,%ebx
8010528b:	eb 0e                	jmp    8010529b <uartputc+0x25>
    microdelay(10);
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	6a 0a                	push   $0xa
80105292:	e8 83 d0 ff ff       	call   8010231a <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105297:	43                   	inc    %ebx
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	83 fb 7f             	cmp    $0x7f,%ebx
8010529e:	7f 0a                	jg     801052aa <uartputc+0x34>
801052a0:	ba fd 03 00 00       	mov    $0x3fd,%edx
801052a5:	ec                   	in     (%dx),%al
801052a6:	a8 20                	test   $0x20,%al
801052a8:	74 e3                	je     8010528d <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801052aa:	8b 45 08             	mov    0x8(%ebp),%eax
801052ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052b2:	ee                   	out    %al,(%dx)
}
801052b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b6:	c9                   	leave  
801052b7:	c3                   	ret    
801052b8:	c3                   	ret    

801052b9 <uartinit>:
{
801052b9:	55                   	push   %ebp
801052ba:	89 e5                	mov    %esp,%ebp
801052bc:	56                   	push   %esi
801052bd:	53                   	push   %ebx
801052be:	b1 00                	mov    $0x0,%cl
801052c0:	ba fa 03 00 00       	mov    $0x3fa,%edx
801052c5:	88 c8                	mov    %cl,%al
801052c7:	ee                   	out    %al,(%dx)
801052c8:	be fb 03 00 00       	mov    $0x3fb,%esi
801052cd:	b0 80                	mov    $0x80,%al
801052cf:	89 f2                	mov    %esi,%edx
801052d1:	ee                   	out    %al,(%dx)
801052d2:	b0 0c                	mov    $0xc,%al
801052d4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052d9:	ee                   	out    %al,(%dx)
801052da:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801052df:	88 c8                	mov    %cl,%al
801052e1:	89 da                	mov    %ebx,%edx
801052e3:	ee                   	out    %al,(%dx)
801052e4:	b0 03                	mov    $0x3,%al
801052e6:	89 f2                	mov    %esi,%edx
801052e8:	ee                   	out    %al,(%dx)
801052e9:	ba fc 03 00 00       	mov    $0x3fc,%edx
801052ee:	88 c8                	mov    %cl,%al
801052f0:	ee                   	out    %al,(%dx)
801052f1:	b0 01                	mov    $0x1,%al
801052f3:	89 da                	mov    %ebx,%edx
801052f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801052f6:	ba fd 03 00 00       	mov    $0x3fd,%edx
801052fb:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801052fc:	3c ff                	cmp    $0xff,%al
801052fe:	74 42                	je     80105342 <uartinit+0x89>
  uart = 1;
80105300:	c7 05 20 48 11 80 01 	movl   $0x1,0x80114820
80105307:	00 00 00 
8010530a:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010530f:	ec                   	in     (%dx),%al
80105310:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105315:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105316:	83 ec 08             	sub    $0x8,%esp
80105319:	6a 00                	push   $0x0
8010531b:	6a 04                	push   $0x4
8010531d:	e8 c3 cb ff ff       	call   80101ee5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105322:	83 c4 10             	add    $0x10,%esp
80105325:	bb 78 71 10 80       	mov    $0x80107178,%ebx
8010532a:	eb 10                	jmp    8010533c <uartinit+0x83>
    uartputc(*p);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	0f be c0             	movsbl %al,%eax
80105332:	50                   	push   %eax
80105333:	e8 3e ff ff ff       	call   80105276 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105338:	43                   	inc    %ebx
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	8a 03                	mov    (%ebx),%al
8010533e:	84 c0                	test   %al,%al
80105340:	75 ea                	jne    8010532c <uartinit+0x73>
}
80105342:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105345:	5b                   	pop    %ebx
80105346:	5e                   	pop    %esi
80105347:	5d                   	pop    %ebp
80105348:	c3                   	ret    

80105349 <uartintr>:

void
uartintr(void)
{
80105349:	55                   	push   %ebp
8010534a:	89 e5                	mov    %esp,%ebp
8010534c:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010534f:	68 4d 52 10 80       	push   $0x8010524d
80105354:	e8 a6 b3 ff ff       	call   801006ff <consoleintr>
}
80105359:	83 c4 10             	add    $0x10,%esp
8010535c:	c9                   	leave  
8010535d:	c3                   	ret    

8010535e <vector0>:
8010535e:	6a 00                	push   $0x0
80105360:	6a 00                	push   $0x0
80105362:	e9 6b fa ff ff       	jmp    80104dd2 <alltraps>

80105367 <vector1>:
80105367:	6a 00                	push   $0x0
80105369:	6a 01                	push   $0x1
8010536b:	e9 62 fa ff ff       	jmp    80104dd2 <alltraps>

80105370 <vector2>:
80105370:	6a 00                	push   $0x0
80105372:	6a 02                	push   $0x2
80105374:	e9 59 fa ff ff       	jmp    80104dd2 <alltraps>

80105379 <vector3>:
80105379:	6a 00                	push   $0x0
8010537b:	6a 03                	push   $0x3
8010537d:	e9 50 fa ff ff       	jmp    80104dd2 <alltraps>

80105382 <vector4>:
80105382:	6a 00                	push   $0x0
80105384:	6a 04                	push   $0x4
80105386:	e9 47 fa ff ff       	jmp    80104dd2 <alltraps>

8010538b <vector5>:
8010538b:	6a 00                	push   $0x0
8010538d:	6a 05                	push   $0x5
8010538f:	e9 3e fa ff ff       	jmp    80104dd2 <alltraps>

80105394 <vector6>:
80105394:	6a 00                	push   $0x0
80105396:	6a 06                	push   $0x6
80105398:	e9 35 fa ff ff       	jmp    80104dd2 <alltraps>

8010539d <vector7>:
8010539d:	6a 00                	push   $0x0
8010539f:	6a 07                	push   $0x7
801053a1:	e9 2c fa ff ff       	jmp    80104dd2 <alltraps>

801053a6 <vector8>:
801053a6:	6a 08                	push   $0x8
801053a8:	e9 25 fa ff ff       	jmp    80104dd2 <alltraps>

801053ad <vector9>:
801053ad:	6a 00                	push   $0x0
801053af:	6a 09                	push   $0x9
801053b1:	e9 1c fa ff ff       	jmp    80104dd2 <alltraps>

801053b6 <vector10>:
801053b6:	6a 0a                	push   $0xa
801053b8:	e9 15 fa ff ff       	jmp    80104dd2 <alltraps>

801053bd <vector11>:
801053bd:	6a 0b                	push   $0xb
801053bf:	e9 0e fa ff ff       	jmp    80104dd2 <alltraps>

801053c4 <vector12>:
801053c4:	6a 0c                	push   $0xc
801053c6:	e9 07 fa ff ff       	jmp    80104dd2 <alltraps>

801053cb <vector13>:
801053cb:	6a 0d                	push   $0xd
801053cd:	e9 00 fa ff ff       	jmp    80104dd2 <alltraps>

801053d2 <vector14>:
801053d2:	6a 0e                	push   $0xe
801053d4:	e9 f9 f9 ff ff       	jmp    80104dd2 <alltraps>

801053d9 <vector15>:
801053d9:	6a 00                	push   $0x0
801053db:	6a 0f                	push   $0xf
801053dd:	e9 f0 f9 ff ff       	jmp    80104dd2 <alltraps>

801053e2 <vector16>:
801053e2:	6a 00                	push   $0x0
801053e4:	6a 10                	push   $0x10
801053e6:	e9 e7 f9 ff ff       	jmp    80104dd2 <alltraps>

801053eb <vector17>:
801053eb:	6a 11                	push   $0x11
801053ed:	e9 e0 f9 ff ff       	jmp    80104dd2 <alltraps>

801053f2 <vector18>:
801053f2:	6a 00                	push   $0x0
801053f4:	6a 12                	push   $0x12
801053f6:	e9 d7 f9 ff ff       	jmp    80104dd2 <alltraps>

801053fb <vector19>:
801053fb:	6a 00                	push   $0x0
801053fd:	6a 13                	push   $0x13
801053ff:	e9 ce f9 ff ff       	jmp    80104dd2 <alltraps>

80105404 <vector20>:
80105404:	6a 00                	push   $0x0
80105406:	6a 14                	push   $0x14
80105408:	e9 c5 f9 ff ff       	jmp    80104dd2 <alltraps>

8010540d <vector21>:
8010540d:	6a 00                	push   $0x0
8010540f:	6a 15                	push   $0x15
80105411:	e9 bc f9 ff ff       	jmp    80104dd2 <alltraps>

80105416 <vector22>:
80105416:	6a 00                	push   $0x0
80105418:	6a 16                	push   $0x16
8010541a:	e9 b3 f9 ff ff       	jmp    80104dd2 <alltraps>

8010541f <vector23>:
8010541f:	6a 00                	push   $0x0
80105421:	6a 17                	push   $0x17
80105423:	e9 aa f9 ff ff       	jmp    80104dd2 <alltraps>

80105428 <vector24>:
80105428:	6a 00                	push   $0x0
8010542a:	6a 18                	push   $0x18
8010542c:	e9 a1 f9 ff ff       	jmp    80104dd2 <alltraps>

80105431 <vector25>:
80105431:	6a 00                	push   $0x0
80105433:	6a 19                	push   $0x19
80105435:	e9 98 f9 ff ff       	jmp    80104dd2 <alltraps>

8010543a <vector26>:
8010543a:	6a 00                	push   $0x0
8010543c:	6a 1a                	push   $0x1a
8010543e:	e9 8f f9 ff ff       	jmp    80104dd2 <alltraps>

80105443 <vector27>:
80105443:	6a 00                	push   $0x0
80105445:	6a 1b                	push   $0x1b
80105447:	e9 86 f9 ff ff       	jmp    80104dd2 <alltraps>

8010544c <vector28>:
8010544c:	6a 00                	push   $0x0
8010544e:	6a 1c                	push   $0x1c
80105450:	e9 7d f9 ff ff       	jmp    80104dd2 <alltraps>

80105455 <vector29>:
80105455:	6a 00                	push   $0x0
80105457:	6a 1d                	push   $0x1d
80105459:	e9 74 f9 ff ff       	jmp    80104dd2 <alltraps>

8010545e <vector30>:
8010545e:	6a 00                	push   $0x0
80105460:	6a 1e                	push   $0x1e
80105462:	e9 6b f9 ff ff       	jmp    80104dd2 <alltraps>

80105467 <vector31>:
80105467:	6a 00                	push   $0x0
80105469:	6a 1f                	push   $0x1f
8010546b:	e9 62 f9 ff ff       	jmp    80104dd2 <alltraps>

80105470 <vector32>:
80105470:	6a 00                	push   $0x0
80105472:	6a 20                	push   $0x20
80105474:	e9 59 f9 ff ff       	jmp    80104dd2 <alltraps>

80105479 <vector33>:
80105479:	6a 00                	push   $0x0
8010547b:	6a 21                	push   $0x21
8010547d:	e9 50 f9 ff ff       	jmp    80104dd2 <alltraps>

80105482 <vector34>:
80105482:	6a 00                	push   $0x0
80105484:	6a 22                	push   $0x22
80105486:	e9 47 f9 ff ff       	jmp    80104dd2 <alltraps>

8010548b <vector35>:
8010548b:	6a 00                	push   $0x0
8010548d:	6a 23                	push   $0x23
8010548f:	e9 3e f9 ff ff       	jmp    80104dd2 <alltraps>

80105494 <vector36>:
80105494:	6a 00                	push   $0x0
80105496:	6a 24                	push   $0x24
80105498:	e9 35 f9 ff ff       	jmp    80104dd2 <alltraps>

8010549d <vector37>:
8010549d:	6a 00                	push   $0x0
8010549f:	6a 25                	push   $0x25
801054a1:	e9 2c f9 ff ff       	jmp    80104dd2 <alltraps>

801054a6 <vector38>:
801054a6:	6a 00                	push   $0x0
801054a8:	6a 26                	push   $0x26
801054aa:	e9 23 f9 ff ff       	jmp    80104dd2 <alltraps>

801054af <vector39>:
801054af:	6a 00                	push   $0x0
801054b1:	6a 27                	push   $0x27
801054b3:	e9 1a f9 ff ff       	jmp    80104dd2 <alltraps>

801054b8 <vector40>:
801054b8:	6a 00                	push   $0x0
801054ba:	6a 28                	push   $0x28
801054bc:	e9 11 f9 ff ff       	jmp    80104dd2 <alltraps>

801054c1 <vector41>:
801054c1:	6a 00                	push   $0x0
801054c3:	6a 29                	push   $0x29
801054c5:	e9 08 f9 ff ff       	jmp    80104dd2 <alltraps>

801054ca <vector42>:
801054ca:	6a 00                	push   $0x0
801054cc:	6a 2a                	push   $0x2a
801054ce:	e9 ff f8 ff ff       	jmp    80104dd2 <alltraps>

801054d3 <vector43>:
801054d3:	6a 00                	push   $0x0
801054d5:	6a 2b                	push   $0x2b
801054d7:	e9 f6 f8 ff ff       	jmp    80104dd2 <alltraps>

801054dc <vector44>:
801054dc:	6a 00                	push   $0x0
801054de:	6a 2c                	push   $0x2c
801054e0:	e9 ed f8 ff ff       	jmp    80104dd2 <alltraps>

801054e5 <vector45>:
801054e5:	6a 00                	push   $0x0
801054e7:	6a 2d                	push   $0x2d
801054e9:	e9 e4 f8 ff ff       	jmp    80104dd2 <alltraps>

801054ee <vector46>:
801054ee:	6a 00                	push   $0x0
801054f0:	6a 2e                	push   $0x2e
801054f2:	e9 db f8 ff ff       	jmp    80104dd2 <alltraps>

801054f7 <vector47>:
801054f7:	6a 00                	push   $0x0
801054f9:	6a 2f                	push   $0x2f
801054fb:	e9 d2 f8 ff ff       	jmp    80104dd2 <alltraps>

80105500 <vector48>:
80105500:	6a 00                	push   $0x0
80105502:	6a 30                	push   $0x30
80105504:	e9 c9 f8 ff ff       	jmp    80104dd2 <alltraps>

80105509 <vector49>:
80105509:	6a 00                	push   $0x0
8010550b:	6a 31                	push   $0x31
8010550d:	e9 c0 f8 ff ff       	jmp    80104dd2 <alltraps>

80105512 <vector50>:
80105512:	6a 00                	push   $0x0
80105514:	6a 32                	push   $0x32
80105516:	e9 b7 f8 ff ff       	jmp    80104dd2 <alltraps>

8010551b <vector51>:
8010551b:	6a 00                	push   $0x0
8010551d:	6a 33                	push   $0x33
8010551f:	e9 ae f8 ff ff       	jmp    80104dd2 <alltraps>

80105524 <vector52>:
80105524:	6a 00                	push   $0x0
80105526:	6a 34                	push   $0x34
80105528:	e9 a5 f8 ff ff       	jmp    80104dd2 <alltraps>

8010552d <vector53>:
8010552d:	6a 00                	push   $0x0
8010552f:	6a 35                	push   $0x35
80105531:	e9 9c f8 ff ff       	jmp    80104dd2 <alltraps>

80105536 <vector54>:
80105536:	6a 00                	push   $0x0
80105538:	6a 36                	push   $0x36
8010553a:	e9 93 f8 ff ff       	jmp    80104dd2 <alltraps>

8010553f <vector55>:
8010553f:	6a 00                	push   $0x0
80105541:	6a 37                	push   $0x37
80105543:	e9 8a f8 ff ff       	jmp    80104dd2 <alltraps>

80105548 <vector56>:
80105548:	6a 00                	push   $0x0
8010554a:	6a 38                	push   $0x38
8010554c:	e9 81 f8 ff ff       	jmp    80104dd2 <alltraps>

80105551 <vector57>:
80105551:	6a 00                	push   $0x0
80105553:	6a 39                	push   $0x39
80105555:	e9 78 f8 ff ff       	jmp    80104dd2 <alltraps>

8010555a <vector58>:
8010555a:	6a 00                	push   $0x0
8010555c:	6a 3a                	push   $0x3a
8010555e:	e9 6f f8 ff ff       	jmp    80104dd2 <alltraps>

80105563 <vector59>:
80105563:	6a 00                	push   $0x0
80105565:	6a 3b                	push   $0x3b
80105567:	e9 66 f8 ff ff       	jmp    80104dd2 <alltraps>

8010556c <vector60>:
8010556c:	6a 00                	push   $0x0
8010556e:	6a 3c                	push   $0x3c
80105570:	e9 5d f8 ff ff       	jmp    80104dd2 <alltraps>

80105575 <vector61>:
80105575:	6a 00                	push   $0x0
80105577:	6a 3d                	push   $0x3d
80105579:	e9 54 f8 ff ff       	jmp    80104dd2 <alltraps>

8010557e <vector62>:
8010557e:	6a 00                	push   $0x0
80105580:	6a 3e                	push   $0x3e
80105582:	e9 4b f8 ff ff       	jmp    80104dd2 <alltraps>

80105587 <vector63>:
80105587:	6a 00                	push   $0x0
80105589:	6a 3f                	push   $0x3f
8010558b:	e9 42 f8 ff ff       	jmp    80104dd2 <alltraps>

80105590 <vector64>:
80105590:	6a 00                	push   $0x0
80105592:	6a 40                	push   $0x40
80105594:	e9 39 f8 ff ff       	jmp    80104dd2 <alltraps>

80105599 <vector65>:
80105599:	6a 00                	push   $0x0
8010559b:	6a 41                	push   $0x41
8010559d:	e9 30 f8 ff ff       	jmp    80104dd2 <alltraps>

801055a2 <vector66>:
801055a2:	6a 00                	push   $0x0
801055a4:	6a 42                	push   $0x42
801055a6:	e9 27 f8 ff ff       	jmp    80104dd2 <alltraps>

801055ab <vector67>:
801055ab:	6a 00                	push   $0x0
801055ad:	6a 43                	push   $0x43
801055af:	e9 1e f8 ff ff       	jmp    80104dd2 <alltraps>

801055b4 <vector68>:
801055b4:	6a 00                	push   $0x0
801055b6:	6a 44                	push   $0x44
801055b8:	e9 15 f8 ff ff       	jmp    80104dd2 <alltraps>

801055bd <vector69>:
801055bd:	6a 00                	push   $0x0
801055bf:	6a 45                	push   $0x45
801055c1:	e9 0c f8 ff ff       	jmp    80104dd2 <alltraps>

801055c6 <vector70>:
801055c6:	6a 00                	push   $0x0
801055c8:	6a 46                	push   $0x46
801055ca:	e9 03 f8 ff ff       	jmp    80104dd2 <alltraps>

801055cf <vector71>:
801055cf:	6a 00                	push   $0x0
801055d1:	6a 47                	push   $0x47
801055d3:	e9 fa f7 ff ff       	jmp    80104dd2 <alltraps>

801055d8 <vector72>:
801055d8:	6a 00                	push   $0x0
801055da:	6a 48                	push   $0x48
801055dc:	e9 f1 f7 ff ff       	jmp    80104dd2 <alltraps>

801055e1 <vector73>:
801055e1:	6a 00                	push   $0x0
801055e3:	6a 49                	push   $0x49
801055e5:	e9 e8 f7 ff ff       	jmp    80104dd2 <alltraps>

801055ea <vector74>:
801055ea:	6a 00                	push   $0x0
801055ec:	6a 4a                	push   $0x4a
801055ee:	e9 df f7 ff ff       	jmp    80104dd2 <alltraps>

801055f3 <vector75>:
801055f3:	6a 00                	push   $0x0
801055f5:	6a 4b                	push   $0x4b
801055f7:	e9 d6 f7 ff ff       	jmp    80104dd2 <alltraps>

801055fc <vector76>:
801055fc:	6a 00                	push   $0x0
801055fe:	6a 4c                	push   $0x4c
80105600:	e9 cd f7 ff ff       	jmp    80104dd2 <alltraps>

80105605 <vector77>:
80105605:	6a 00                	push   $0x0
80105607:	6a 4d                	push   $0x4d
80105609:	e9 c4 f7 ff ff       	jmp    80104dd2 <alltraps>

8010560e <vector78>:
8010560e:	6a 00                	push   $0x0
80105610:	6a 4e                	push   $0x4e
80105612:	e9 bb f7 ff ff       	jmp    80104dd2 <alltraps>

80105617 <vector79>:
80105617:	6a 00                	push   $0x0
80105619:	6a 4f                	push   $0x4f
8010561b:	e9 b2 f7 ff ff       	jmp    80104dd2 <alltraps>

80105620 <vector80>:
80105620:	6a 00                	push   $0x0
80105622:	6a 50                	push   $0x50
80105624:	e9 a9 f7 ff ff       	jmp    80104dd2 <alltraps>

80105629 <vector81>:
80105629:	6a 00                	push   $0x0
8010562b:	6a 51                	push   $0x51
8010562d:	e9 a0 f7 ff ff       	jmp    80104dd2 <alltraps>

80105632 <vector82>:
80105632:	6a 00                	push   $0x0
80105634:	6a 52                	push   $0x52
80105636:	e9 97 f7 ff ff       	jmp    80104dd2 <alltraps>

8010563b <vector83>:
8010563b:	6a 00                	push   $0x0
8010563d:	6a 53                	push   $0x53
8010563f:	e9 8e f7 ff ff       	jmp    80104dd2 <alltraps>

80105644 <vector84>:
80105644:	6a 00                	push   $0x0
80105646:	6a 54                	push   $0x54
80105648:	e9 85 f7 ff ff       	jmp    80104dd2 <alltraps>

8010564d <vector85>:
8010564d:	6a 00                	push   $0x0
8010564f:	6a 55                	push   $0x55
80105651:	e9 7c f7 ff ff       	jmp    80104dd2 <alltraps>

80105656 <vector86>:
80105656:	6a 00                	push   $0x0
80105658:	6a 56                	push   $0x56
8010565a:	e9 73 f7 ff ff       	jmp    80104dd2 <alltraps>

8010565f <vector87>:
8010565f:	6a 00                	push   $0x0
80105661:	6a 57                	push   $0x57
80105663:	e9 6a f7 ff ff       	jmp    80104dd2 <alltraps>

80105668 <vector88>:
80105668:	6a 00                	push   $0x0
8010566a:	6a 58                	push   $0x58
8010566c:	e9 61 f7 ff ff       	jmp    80104dd2 <alltraps>

80105671 <vector89>:
80105671:	6a 00                	push   $0x0
80105673:	6a 59                	push   $0x59
80105675:	e9 58 f7 ff ff       	jmp    80104dd2 <alltraps>

8010567a <vector90>:
8010567a:	6a 00                	push   $0x0
8010567c:	6a 5a                	push   $0x5a
8010567e:	e9 4f f7 ff ff       	jmp    80104dd2 <alltraps>

80105683 <vector91>:
80105683:	6a 00                	push   $0x0
80105685:	6a 5b                	push   $0x5b
80105687:	e9 46 f7 ff ff       	jmp    80104dd2 <alltraps>

8010568c <vector92>:
8010568c:	6a 00                	push   $0x0
8010568e:	6a 5c                	push   $0x5c
80105690:	e9 3d f7 ff ff       	jmp    80104dd2 <alltraps>

80105695 <vector93>:
80105695:	6a 00                	push   $0x0
80105697:	6a 5d                	push   $0x5d
80105699:	e9 34 f7 ff ff       	jmp    80104dd2 <alltraps>

8010569e <vector94>:
8010569e:	6a 00                	push   $0x0
801056a0:	6a 5e                	push   $0x5e
801056a2:	e9 2b f7 ff ff       	jmp    80104dd2 <alltraps>

801056a7 <vector95>:
801056a7:	6a 00                	push   $0x0
801056a9:	6a 5f                	push   $0x5f
801056ab:	e9 22 f7 ff ff       	jmp    80104dd2 <alltraps>

801056b0 <vector96>:
801056b0:	6a 00                	push   $0x0
801056b2:	6a 60                	push   $0x60
801056b4:	e9 19 f7 ff ff       	jmp    80104dd2 <alltraps>

801056b9 <vector97>:
801056b9:	6a 00                	push   $0x0
801056bb:	6a 61                	push   $0x61
801056bd:	e9 10 f7 ff ff       	jmp    80104dd2 <alltraps>

801056c2 <vector98>:
801056c2:	6a 00                	push   $0x0
801056c4:	6a 62                	push   $0x62
801056c6:	e9 07 f7 ff ff       	jmp    80104dd2 <alltraps>

801056cb <vector99>:
801056cb:	6a 00                	push   $0x0
801056cd:	6a 63                	push   $0x63
801056cf:	e9 fe f6 ff ff       	jmp    80104dd2 <alltraps>

801056d4 <vector100>:
801056d4:	6a 00                	push   $0x0
801056d6:	6a 64                	push   $0x64
801056d8:	e9 f5 f6 ff ff       	jmp    80104dd2 <alltraps>

801056dd <vector101>:
801056dd:	6a 00                	push   $0x0
801056df:	6a 65                	push   $0x65
801056e1:	e9 ec f6 ff ff       	jmp    80104dd2 <alltraps>

801056e6 <vector102>:
801056e6:	6a 00                	push   $0x0
801056e8:	6a 66                	push   $0x66
801056ea:	e9 e3 f6 ff ff       	jmp    80104dd2 <alltraps>

801056ef <vector103>:
801056ef:	6a 00                	push   $0x0
801056f1:	6a 67                	push   $0x67
801056f3:	e9 da f6 ff ff       	jmp    80104dd2 <alltraps>

801056f8 <vector104>:
801056f8:	6a 00                	push   $0x0
801056fa:	6a 68                	push   $0x68
801056fc:	e9 d1 f6 ff ff       	jmp    80104dd2 <alltraps>

80105701 <vector105>:
80105701:	6a 00                	push   $0x0
80105703:	6a 69                	push   $0x69
80105705:	e9 c8 f6 ff ff       	jmp    80104dd2 <alltraps>

8010570a <vector106>:
8010570a:	6a 00                	push   $0x0
8010570c:	6a 6a                	push   $0x6a
8010570e:	e9 bf f6 ff ff       	jmp    80104dd2 <alltraps>

80105713 <vector107>:
80105713:	6a 00                	push   $0x0
80105715:	6a 6b                	push   $0x6b
80105717:	e9 b6 f6 ff ff       	jmp    80104dd2 <alltraps>

8010571c <vector108>:
8010571c:	6a 00                	push   $0x0
8010571e:	6a 6c                	push   $0x6c
80105720:	e9 ad f6 ff ff       	jmp    80104dd2 <alltraps>

80105725 <vector109>:
80105725:	6a 00                	push   $0x0
80105727:	6a 6d                	push   $0x6d
80105729:	e9 a4 f6 ff ff       	jmp    80104dd2 <alltraps>

8010572e <vector110>:
8010572e:	6a 00                	push   $0x0
80105730:	6a 6e                	push   $0x6e
80105732:	e9 9b f6 ff ff       	jmp    80104dd2 <alltraps>

80105737 <vector111>:
80105737:	6a 00                	push   $0x0
80105739:	6a 6f                	push   $0x6f
8010573b:	e9 92 f6 ff ff       	jmp    80104dd2 <alltraps>

80105740 <vector112>:
80105740:	6a 00                	push   $0x0
80105742:	6a 70                	push   $0x70
80105744:	e9 89 f6 ff ff       	jmp    80104dd2 <alltraps>

80105749 <vector113>:
80105749:	6a 00                	push   $0x0
8010574b:	6a 71                	push   $0x71
8010574d:	e9 80 f6 ff ff       	jmp    80104dd2 <alltraps>

80105752 <vector114>:
80105752:	6a 00                	push   $0x0
80105754:	6a 72                	push   $0x72
80105756:	e9 77 f6 ff ff       	jmp    80104dd2 <alltraps>

8010575b <vector115>:
8010575b:	6a 00                	push   $0x0
8010575d:	6a 73                	push   $0x73
8010575f:	e9 6e f6 ff ff       	jmp    80104dd2 <alltraps>

80105764 <vector116>:
80105764:	6a 00                	push   $0x0
80105766:	6a 74                	push   $0x74
80105768:	e9 65 f6 ff ff       	jmp    80104dd2 <alltraps>

8010576d <vector117>:
8010576d:	6a 00                	push   $0x0
8010576f:	6a 75                	push   $0x75
80105771:	e9 5c f6 ff ff       	jmp    80104dd2 <alltraps>

80105776 <vector118>:
80105776:	6a 00                	push   $0x0
80105778:	6a 76                	push   $0x76
8010577a:	e9 53 f6 ff ff       	jmp    80104dd2 <alltraps>

8010577f <vector119>:
8010577f:	6a 00                	push   $0x0
80105781:	6a 77                	push   $0x77
80105783:	e9 4a f6 ff ff       	jmp    80104dd2 <alltraps>

80105788 <vector120>:
80105788:	6a 00                	push   $0x0
8010578a:	6a 78                	push   $0x78
8010578c:	e9 41 f6 ff ff       	jmp    80104dd2 <alltraps>

80105791 <vector121>:
80105791:	6a 00                	push   $0x0
80105793:	6a 79                	push   $0x79
80105795:	e9 38 f6 ff ff       	jmp    80104dd2 <alltraps>

8010579a <vector122>:
8010579a:	6a 00                	push   $0x0
8010579c:	6a 7a                	push   $0x7a
8010579e:	e9 2f f6 ff ff       	jmp    80104dd2 <alltraps>

801057a3 <vector123>:
801057a3:	6a 00                	push   $0x0
801057a5:	6a 7b                	push   $0x7b
801057a7:	e9 26 f6 ff ff       	jmp    80104dd2 <alltraps>

801057ac <vector124>:
801057ac:	6a 00                	push   $0x0
801057ae:	6a 7c                	push   $0x7c
801057b0:	e9 1d f6 ff ff       	jmp    80104dd2 <alltraps>

801057b5 <vector125>:
801057b5:	6a 00                	push   $0x0
801057b7:	6a 7d                	push   $0x7d
801057b9:	e9 14 f6 ff ff       	jmp    80104dd2 <alltraps>

801057be <vector126>:
801057be:	6a 00                	push   $0x0
801057c0:	6a 7e                	push   $0x7e
801057c2:	e9 0b f6 ff ff       	jmp    80104dd2 <alltraps>

801057c7 <vector127>:
801057c7:	6a 00                	push   $0x0
801057c9:	6a 7f                	push   $0x7f
801057cb:	e9 02 f6 ff ff       	jmp    80104dd2 <alltraps>

801057d0 <vector128>:
801057d0:	6a 00                	push   $0x0
801057d2:	68 80 00 00 00       	push   $0x80
801057d7:	e9 f6 f5 ff ff       	jmp    80104dd2 <alltraps>

801057dc <vector129>:
801057dc:	6a 00                	push   $0x0
801057de:	68 81 00 00 00       	push   $0x81
801057e3:	e9 ea f5 ff ff       	jmp    80104dd2 <alltraps>

801057e8 <vector130>:
801057e8:	6a 00                	push   $0x0
801057ea:	68 82 00 00 00       	push   $0x82
801057ef:	e9 de f5 ff ff       	jmp    80104dd2 <alltraps>

801057f4 <vector131>:
801057f4:	6a 00                	push   $0x0
801057f6:	68 83 00 00 00       	push   $0x83
801057fb:	e9 d2 f5 ff ff       	jmp    80104dd2 <alltraps>

80105800 <vector132>:
80105800:	6a 00                	push   $0x0
80105802:	68 84 00 00 00       	push   $0x84
80105807:	e9 c6 f5 ff ff       	jmp    80104dd2 <alltraps>

8010580c <vector133>:
8010580c:	6a 00                	push   $0x0
8010580e:	68 85 00 00 00       	push   $0x85
80105813:	e9 ba f5 ff ff       	jmp    80104dd2 <alltraps>

80105818 <vector134>:
80105818:	6a 00                	push   $0x0
8010581a:	68 86 00 00 00       	push   $0x86
8010581f:	e9 ae f5 ff ff       	jmp    80104dd2 <alltraps>

80105824 <vector135>:
80105824:	6a 00                	push   $0x0
80105826:	68 87 00 00 00       	push   $0x87
8010582b:	e9 a2 f5 ff ff       	jmp    80104dd2 <alltraps>

80105830 <vector136>:
80105830:	6a 00                	push   $0x0
80105832:	68 88 00 00 00       	push   $0x88
80105837:	e9 96 f5 ff ff       	jmp    80104dd2 <alltraps>

8010583c <vector137>:
8010583c:	6a 00                	push   $0x0
8010583e:	68 89 00 00 00       	push   $0x89
80105843:	e9 8a f5 ff ff       	jmp    80104dd2 <alltraps>

80105848 <vector138>:
80105848:	6a 00                	push   $0x0
8010584a:	68 8a 00 00 00       	push   $0x8a
8010584f:	e9 7e f5 ff ff       	jmp    80104dd2 <alltraps>

80105854 <vector139>:
80105854:	6a 00                	push   $0x0
80105856:	68 8b 00 00 00       	push   $0x8b
8010585b:	e9 72 f5 ff ff       	jmp    80104dd2 <alltraps>

80105860 <vector140>:
80105860:	6a 00                	push   $0x0
80105862:	68 8c 00 00 00       	push   $0x8c
80105867:	e9 66 f5 ff ff       	jmp    80104dd2 <alltraps>

8010586c <vector141>:
8010586c:	6a 00                	push   $0x0
8010586e:	68 8d 00 00 00       	push   $0x8d
80105873:	e9 5a f5 ff ff       	jmp    80104dd2 <alltraps>

80105878 <vector142>:
80105878:	6a 00                	push   $0x0
8010587a:	68 8e 00 00 00       	push   $0x8e
8010587f:	e9 4e f5 ff ff       	jmp    80104dd2 <alltraps>

80105884 <vector143>:
80105884:	6a 00                	push   $0x0
80105886:	68 8f 00 00 00       	push   $0x8f
8010588b:	e9 42 f5 ff ff       	jmp    80104dd2 <alltraps>

80105890 <vector144>:
80105890:	6a 00                	push   $0x0
80105892:	68 90 00 00 00       	push   $0x90
80105897:	e9 36 f5 ff ff       	jmp    80104dd2 <alltraps>

8010589c <vector145>:
8010589c:	6a 00                	push   $0x0
8010589e:	68 91 00 00 00       	push   $0x91
801058a3:	e9 2a f5 ff ff       	jmp    80104dd2 <alltraps>

801058a8 <vector146>:
801058a8:	6a 00                	push   $0x0
801058aa:	68 92 00 00 00       	push   $0x92
801058af:	e9 1e f5 ff ff       	jmp    80104dd2 <alltraps>

801058b4 <vector147>:
801058b4:	6a 00                	push   $0x0
801058b6:	68 93 00 00 00       	push   $0x93
801058bb:	e9 12 f5 ff ff       	jmp    80104dd2 <alltraps>

801058c0 <vector148>:
801058c0:	6a 00                	push   $0x0
801058c2:	68 94 00 00 00       	push   $0x94
801058c7:	e9 06 f5 ff ff       	jmp    80104dd2 <alltraps>

801058cc <vector149>:
801058cc:	6a 00                	push   $0x0
801058ce:	68 95 00 00 00       	push   $0x95
801058d3:	e9 fa f4 ff ff       	jmp    80104dd2 <alltraps>

801058d8 <vector150>:
801058d8:	6a 00                	push   $0x0
801058da:	68 96 00 00 00       	push   $0x96
801058df:	e9 ee f4 ff ff       	jmp    80104dd2 <alltraps>

801058e4 <vector151>:
801058e4:	6a 00                	push   $0x0
801058e6:	68 97 00 00 00       	push   $0x97
801058eb:	e9 e2 f4 ff ff       	jmp    80104dd2 <alltraps>

801058f0 <vector152>:
801058f0:	6a 00                	push   $0x0
801058f2:	68 98 00 00 00       	push   $0x98
801058f7:	e9 d6 f4 ff ff       	jmp    80104dd2 <alltraps>

801058fc <vector153>:
801058fc:	6a 00                	push   $0x0
801058fe:	68 99 00 00 00       	push   $0x99
80105903:	e9 ca f4 ff ff       	jmp    80104dd2 <alltraps>

80105908 <vector154>:
80105908:	6a 00                	push   $0x0
8010590a:	68 9a 00 00 00       	push   $0x9a
8010590f:	e9 be f4 ff ff       	jmp    80104dd2 <alltraps>

80105914 <vector155>:
80105914:	6a 00                	push   $0x0
80105916:	68 9b 00 00 00       	push   $0x9b
8010591b:	e9 b2 f4 ff ff       	jmp    80104dd2 <alltraps>

80105920 <vector156>:
80105920:	6a 00                	push   $0x0
80105922:	68 9c 00 00 00       	push   $0x9c
80105927:	e9 a6 f4 ff ff       	jmp    80104dd2 <alltraps>

8010592c <vector157>:
8010592c:	6a 00                	push   $0x0
8010592e:	68 9d 00 00 00       	push   $0x9d
80105933:	e9 9a f4 ff ff       	jmp    80104dd2 <alltraps>

80105938 <vector158>:
80105938:	6a 00                	push   $0x0
8010593a:	68 9e 00 00 00       	push   $0x9e
8010593f:	e9 8e f4 ff ff       	jmp    80104dd2 <alltraps>

80105944 <vector159>:
80105944:	6a 00                	push   $0x0
80105946:	68 9f 00 00 00       	push   $0x9f
8010594b:	e9 82 f4 ff ff       	jmp    80104dd2 <alltraps>

80105950 <vector160>:
80105950:	6a 00                	push   $0x0
80105952:	68 a0 00 00 00       	push   $0xa0
80105957:	e9 76 f4 ff ff       	jmp    80104dd2 <alltraps>

8010595c <vector161>:
8010595c:	6a 00                	push   $0x0
8010595e:	68 a1 00 00 00       	push   $0xa1
80105963:	e9 6a f4 ff ff       	jmp    80104dd2 <alltraps>

80105968 <vector162>:
80105968:	6a 00                	push   $0x0
8010596a:	68 a2 00 00 00       	push   $0xa2
8010596f:	e9 5e f4 ff ff       	jmp    80104dd2 <alltraps>

80105974 <vector163>:
80105974:	6a 00                	push   $0x0
80105976:	68 a3 00 00 00       	push   $0xa3
8010597b:	e9 52 f4 ff ff       	jmp    80104dd2 <alltraps>

80105980 <vector164>:
80105980:	6a 00                	push   $0x0
80105982:	68 a4 00 00 00       	push   $0xa4
80105987:	e9 46 f4 ff ff       	jmp    80104dd2 <alltraps>

8010598c <vector165>:
8010598c:	6a 00                	push   $0x0
8010598e:	68 a5 00 00 00       	push   $0xa5
80105993:	e9 3a f4 ff ff       	jmp    80104dd2 <alltraps>

80105998 <vector166>:
80105998:	6a 00                	push   $0x0
8010599a:	68 a6 00 00 00       	push   $0xa6
8010599f:	e9 2e f4 ff ff       	jmp    80104dd2 <alltraps>

801059a4 <vector167>:
801059a4:	6a 00                	push   $0x0
801059a6:	68 a7 00 00 00       	push   $0xa7
801059ab:	e9 22 f4 ff ff       	jmp    80104dd2 <alltraps>

801059b0 <vector168>:
801059b0:	6a 00                	push   $0x0
801059b2:	68 a8 00 00 00       	push   $0xa8
801059b7:	e9 16 f4 ff ff       	jmp    80104dd2 <alltraps>

801059bc <vector169>:
801059bc:	6a 00                	push   $0x0
801059be:	68 a9 00 00 00       	push   $0xa9
801059c3:	e9 0a f4 ff ff       	jmp    80104dd2 <alltraps>

801059c8 <vector170>:
801059c8:	6a 00                	push   $0x0
801059ca:	68 aa 00 00 00       	push   $0xaa
801059cf:	e9 fe f3 ff ff       	jmp    80104dd2 <alltraps>

801059d4 <vector171>:
801059d4:	6a 00                	push   $0x0
801059d6:	68 ab 00 00 00       	push   $0xab
801059db:	e9 f2 f3 ff ff       	jmp    80104dd2 <alltraps>

801059e0 <vector172>:
801059e0:	6a 00                	push   $0x0
801059e2:	68 ac 00 00 00       	push   $0xac
801059e7:	e9 e6 f3 ff ff       	jmp    80104dd2 <alltraps>

801059ec <vector173>:
801059ec:	6a 00                	push   $0x0
801059ee:	68 ad 00 00 00       	push   $0xad
801059f3:	e9 da f3 ff ff       	jmp    80104dd2 <alltraps>

801059f8 <vector174>:
801059f8:	6a 00                	push   $0x0
801059fa:	68 ae 00 00 00       	push   $0xae
801059ff:	e9 ce f3 ff ff       	jmp    80104dd2 <alltraps>

80105a04 <vector175>:
80105a04:	6a 00                	push   $0x0
80105a06:	68 af 00 00 00       	push   $0xaf
80105a0b:	e9 c2 f3 ff ff       	jmp    80104dd2 <alltraps>

80105a10 <vector176>:
80105a10:	6a 00                	push   $0x0
80105a12:	68 b0 00 00 00       	push   $0xb0
80105a17:	e9 b6 f3 ff ff       	jmp    80104dd2 <alltraps>

80105a1c <vector177>:
80105a1c:	6a 00                	push   $0x0
80105a1e:	68 b1 00 00 00       	push   $0xb1
80105a23:	e9 aa f3 ff ff       	jmp    80104dd2 <alltraps>

80105a28 <vector178>:
80105a28:	6a 00                	push   $0x0
80105a2a:	68 b2 00 00 00       	push   $0xb2
80105a2f:	e9 9e f3 ff ff       	jmp    80104dd2 <alltraps>

80105a34 <vector179>:
80105a34:	6a 00                	push   $0x0
80105a36:	68 b3 00 00 00       	push   $0xb3
80105a3b:	e9 92 f3 ff ff       	jmp    80104dd2 <alltraps>

80105a40 <vector180>:
80105a40:	6a 00                	push   $0x0
80105a42:	68 b4 00 00 00       	push   $0xb4
80105a47:	e9 86 f3 ff ff       	jmp    80104dd2 <alltraps>

80105a4c <vector181>:
80105a4c:	6a 00                	push   $0x0
80105a4e:	68 b5 00 00 00       	push   $0xb5
80105a53:	e9 7a f3 ff ff       	jmp    80104dd2 <alltraps>

80105a58 <vector182>:
80105a58:	6a 00                	push   $0x0
80105a5a:	68 b6 00 00 00       	push   $0xb6
80105a5f:	e9 6e f3 ff ff       	jmp    80104dd2 <alltraps>

80105a64 <vector183>:
80105a64:	6a 00                	push   $0x0
80105a66:	68 b7 00 00 00       	push   $0xb7
80105a6b:	e9 62 f3 ff ff       	jmp    80104dd2 <alltraps>

80105a70 <vector184>:
80105a70:	6a 00                	push   $0x0
80105a72:	68 b8 00 00 00       	push   $0xb8
80105a77:	e9 56 f3 ff ff       	jmp    80104dd2 <alltraps>

80105a7c <vector185>:
80105a7c:	6a 00                	push   $0x0
80105a7e:	68 b9 00 00 00       	push   $0xb9
80105a83:	e9 4a f3 ff ff       	jmp    80104dd2 <alltraps>

80105a88 <vector186>:
80105a88:	6a 00                	push   $0x0
80105a8a:	68 ba 00 00 00       	push   $0xba
80105a8f:	e9 3e f3 ff ff       	jmp    80104dd2 <alltraps>

80105a94 <vector187>:
80105a94:	6a 00                	push   $0x0
80105a96:	68 bb 00 00 00       	push   $0xbb
80105a9b:	e9 32 f3 ff ff       	jmp    80104dd2 <alltraps>

80105aa0 <vector188>:
80105aa0:	6a 00                	push   $0x0
80105aa2:	68 bc 00 00 00       	push   $0xbc
80105aa7:	e9 26 f3 ff ff       	jmp    80104dd2 <alltraps>

80105aac <vector189>:
80105aac:	6a 00                	push   $0x0
80105aae:	68 bd 00 00 00       	push   $0xbd
80105ab3:	e9 1a f3 ff ff       	jmp    80104dd2 <alltraps>

80105ab8 <vector190>:
80105ab8:	6a 00                	push   $0x0
80105aba:	68 be 00 00 00       	push   $0xbe
80105abf:	e9 0e f3 ff ff       	jmp    80104dd2 <alltraps>

80105ac4 <vector191>:
80105ac4:	6a 00                	push   $0x0
80105ac6:	68 bf 00 00 00       	push   $0xbf
80105acb:	e9 02 f3 ff ff       	jmp    80104dd2 <alltraps>

80105ad0 <vector192>:
80105ad0:	6a 00                	push   $0x0
80105ad2:	68 c0 00 00 00       	push   $0xc0
80105ad7:	e9 f6 f2 ff ff       	jmp    80104dd2 <alltraps>

80105adc <vector193>:
80105adc:	6a 00                	push   $0x0
80105ade:	68 c1 00 00 00       	push   $0xc1
80105ae3:	e9 ea f2 ff ff       	jmp    80104dd2 <alltraps>

80105ae8 <vector194>:
80105ae8:	6a 00                	push   $0x0
80105aea:	68 c2 00 00 00       	push   $0xc2
80105aef:	e9 de f2 ff ff       	jmp    80104dd2 <alltraps>

80105af4 <vector195>:
80105af4:	6a 00                	push   $0x0
80105af6:	68 c3 00 00 00       	push   $0xc3
80105afb:	e9 d2 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b00 <vector196>:
80105b00:	6a 00                	push   $0x0
80105b02:	68 c4 00 00 00       	push   $0xc4
80105b07:	e9 c6 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b0c <vector197>:
80105b0c:	6a 00                	push   $0x0
80105b0e:	68 c5 00 00 00       	push   $0xc5
80105b13:	e9 ba f2 ff ff       	jmp    80104dd2 <alltraps>

80105b18 <vector198>:
80105b18:	6a 00                	push   $0x0
80105b1a:	68 c6 00 00 00       	push   $0xc6
80105b1f:	e9 ae f2 ff ff       	jmp    80104dd2 <alltraps>

80105b24 <vector199>:
80105b24:	6a 00                	push   $0x0
80105b26:	68 c7 00 00 00       	push   $0xc7
80105b2b:	e9 a2 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b30 <vector200>:
80105b30:	6a 00                	push   $0x0
80105b32:	68 c8 00 00 00       	push   $0xc8
80105b37:	e9 96 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b3c <vector201>:
80105b3c:	6a 00                	push   $0x0
80105b3e:	68 c9 00 00 00       	push   $0xc9
80105b43:	e9 8a f2 ff ff       	jmp    80104dd2 <alltraps>

80105b48 <vector202>:
80105b48:	6a 00                	push   $0x0
80105b4a:	68 ca 00 00 00       	push   $0xca
80105b4f:	e9 7e f2 ff ff       	jmp    80104dd2 <alltraps>

80105b54 <vector203>:
80105b54:	6a 00                	push   $0x0
80105b56:	68 cb 00 00 00       	push   $0xcb
80105b5b:	e9 72 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b60 <vector204>:
80105b60:	6a 00                	push   $0x0
80105b62:	68 cc 00 00 00       	push   $0xcc
80105b67:	e9 66 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b6c <vector205>:
80105b6c:	6a 00                	push   $0x0
80105b6e:	68 cd 00 00 00       	push   $0xcd
80105b73:	e9 5a f2 ff ff       	jmp    80104dd2 <alltraps>

80105b78 <vector206>:
80105b78:	6a 00                	push   $0x0
80105b7a:	68 ce 00 00 00       	push   $0xce
80105b7f:	e9 4e f2 ff ff       	jmp    80104dd2 <alltraps>

80105b84 <vector207>:
80105b84:	6a 00                	push   $0x0
80105b86:	68 cf 00 00 00       	push   $0xcf
80105b8b:	e9 42 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b90 <vector208>:
80105b90:	6a 00                	push   $0x0
80105b92:	68 d0 00 00 00       	push   $0xd0
80105b97:	e9 36 f2 ff ff       	jmp    80104dd2 <alltraps>

80105b9c <vector209>:
80105b9c:	6a 00                	push   $0x0
80105b9e:	68 d1 00 00 00       	push   $0xd1
80105ba3:	e9 2a f2 ff ff       	jmp    80104dd2 <alltraps>

80105ba8 <vector210>:
80105ba8:	6a 00                	push   $0x0
80105baa:	68 d2 00 00 00       	push   $0xd2
80105baf:	e9 1e f2 ff ff       	jmp    80104dd2 <alltraps>

80105bb4 <vector211>:
80105bb4:	6a 00                	push   $0x0
80105bb6:	68 d3 00 00 00       	push   $0xd3
80105bbb:	e9 12 f2 ff ff       	jmp    80104dd2 <alltraps>

80105bc0 <vector212>:
80105bc0:	6a 00                	push   $0x0
80105bc2:	68 d4 00 00 00       	push   $0xd4
80105bc7:	e9 06 f2 ff ff       	jmp    80104dd2 <alltraps>

80105bcc <vector213>:
80105bcc:	6a 00                	push   $0x0
80105bce:	68 d5 00 00 00       	push   $0xd5
80105bd3:	e9 fa f1 ff ff       	jmp    80104dd2 <alltraps>

80105bd8 <vector214>:
80105bd8:	6a 00                	push   $0x0
80105bda:	68 d6 00 00 00       	push   $0xd6
80105bdf:	e9 ee f1 ff ff       	jmp    80104dd2 <alltraps>

80105be4 <vector215>:
80105be4:	6a 00                	push   $0x0
80105be6:	68 d7 00 00 00       	push   $0xd7
80105beb:	e9 e2 f1 ff ff       	jmp    80104dd2 <alltraps>

80105bf0 <vector216>:
80105bf0:	6a 00                	push   $0x0
80105bf2:	68 d8 00 00 00       	push   $0xd8
80105bf7:	e9 d6 f1 ff ff       	jmp    80104dd2 <alltraps>

80105bfc <vector217>:
80105bfc:	6a 00                	push   $0x0
80105bfe:	68 d9 00 00 00       	push   $0xd9
80105c03:	e9 ca f1 ff ff       	jmp    80104dd2 <alltraps>

80105c08 <vector218>:
80105c08:	6a 00                	push   $0x0
80105c0a:	68 da 00 00 00       	push   $0xda
80105c0f:	e9 be f1 ff ff       	jmp    80104dd2 <alltraps>

80105c14 <vector219>:
80105c14:	6a 00                	push   $0x0
80105c16:	68 db 00 00 00       	push   $0xdb
80105c1b:	e9 b2 f1 ff ff       	jmp    80104dd2 <alltraps>

80105c20 <vector220>:
80105c20:	6a 00                	push   $0x0
80105c22:	68 dc 00 00 00       	push   $0xdc
80105c27:	e9 a6 f1 ff ff       	jmp    80104dd2 <alltraps>

80105c2c <vector221>:
80105c2c:	6a 00                	push   $0x0
80105c2e:	68 dd 00 00 00       	push   $0xdd
80105c33:	e9 9a f1 ff ff       	jmp    80104dd2 <alltraps>

80105c38 <vector222>:
80105c38:	6a 00                	push   $0x0
80105c3a:	68 de 00 00 00       	push   $0xde
80105c3f:	e9 8e f1 ff ff       	jmp    80104dd2 <alltraps>

80105c44 <vector223>:
80105c44:	6a 00                	push   $0x0
80105c46:	68 df 00 00 00       	push   $0xdf
80105c4b:	e9 82 f1 ff ff       	jmp    80104dd2 <alltraps>

80105c50 <vector224>:
80105c50:	6a 00                	push   $0x0
80105c52:	68 e0 00 00 00       	push   $0xe0
80105c57:	e9 76 f1 ff ff       	jmp    80104dd2 <alltraps>

80105c5c <vector225>:
80105c5c:	6a 00                	push   $0x0
80105c5e:	68 e1 00 00 00       	push   $0xe1
80105c63:	e9 6a f1 ff ff       	jmp    80104dd2 <alltraps>

80105c68 <vector226>:
80105c68:	6a 00                	push   $0x0
80105c6a:	68 e2 00 00 00       	push   $0xe2
80105c6f:	e9 5e f1 ff ff       	jmp    80104dd2 <alltraps>

80105c74 <vector227>:
80105c74:	6a 00                	push   $0x0
80105c76:	68 e3 00 00 00       	push   $0xe3
80105c7b:	e9 52 f1 ff ff       	jmp    80104dd2 <alltraps>

80105c80 <vector228>:
80105c80:	6a 00                	push   $0x0
80105c82:	68 e4 00 00 00       	push   $0xe4
80105c87:	e9 46 f1 ff ff       	jmp    80104dd2 <alltraps>

80105c8c <vector229>:
80105c8c:	6a 00                	push   $0x0
80105c8e:	68 e5 00 00 00       	push   $0xe5
80105c93:	e9 3a f1 ff ff       	jmp    80104dd2 <alltraps>

80105c98 <vector230>:
80105c98:	6a 00                	push   $0x0
80105c9a:	68 e6 00 00 00       	push   $0xe6
80105c9f:	e9 2e f1 ff ff       	jmp    80104dd2 <alltraps>

80105ca4 <vector231>:
80105ca4:	6a 00                	push   $0x0
80105ca6:	68 e7 00 00 00       	push   $0xe7
80105cab:	e9 22 f1 ff ff       	jmp    80104dd2 <alltraps>

80105cb0 <vector232>:
80105cb0:	6a 00                	push   $0x0
80105cb2:	68 e8 00 00 00       	push   $0xe8
80105cb7:	e9 16 f1 ff ff       	jmp    80104dd2 <alltraps>

80105cbc <vector233>:
80105cbc:	6a 00                	push   $0x0
80105cbe:	68 e9 00 00 00       	push   $0xe9
80105cc3:	e9 0a f1 ff ff       	jmp    80104dd2 <alltraps>

80105cc8 <vector234>:
80105cc8:	6a 00                	push   $0x0
80105cca:	68 ea 00 00 00       	push   $0xea
80105ccf:	e9 fe f0 ff ff       	jmp    80104dd2 <alltraps>

80105cd4 <vector235>:
80105cd4:	6a 00                	push   $0x0
80105cd6:	68 eb 00 00 00       	push   $0xeb
80105cdb:	e9 f2 f0 ff ff       	jmp    80104dd2 <alltraps>

80105ce0 <vector236>:
80105ce0:	6a 00                	push   $0x0
80105ce2:	68 ec 00 00 00       	push   $0xec
80105ce7:	e9 e6 f0 ff ff       	jmp    80104dd2 <alltraps>

80105cec <vector237>:
80105cec:	6a 00                	push   $0x0
80105cee:	68 ed 00 00 00       	push   $0xed
80105cf3:	e9 da f0 ff ff       	jmp    80104dd2 <alltraps>

80105cf8 <vector238>:
80105cf8:	6a 00                	push   $0x0
80105cfa:	68 ee 00 00 00       	push   $0xee
80105cff:	e9 ce f0 ff ff       	jmp    80104dd2 <alltraps>

80105d04 <vector239>:
80105d04:	6a 00                	push   $0x0
80105d06:	68 ef 00 00 00       	push   $0xef
80105d0b:	e9 c2 f0 ff ff       	jmp    80104dd2 <alltraps>

80105d10 <vector240>:
80105d10:	6a 00                	push   $0x0
80105d12:	68 f0 00 00 00       	push   $0xf0
80105d17:	e9 b6 f0 ff ff       	jmp    80104dd2 <alltraps>

80105d1c <vector241>:
80105d1c:	6a 00                	push   $0x0
80105d1e:	68 f1 00 00 00       	push   $0xf1
80105d23:	e9 aa f0 ff ff       	jmp    80104dd2 <alltraps>

80105d28 <vector242>:
80105d28:	6a 00                	push   $0x0
80105d2a:	68 f2 00 00 00       	push   $0xf2
80105d2f:	e9 9e f0 ff ff       	jmp    80104dd2 <alltraps>

80105d34 <vector243>:
80105d34:	6a 00                	push   $0x0
80105d36:	68 f3 00 00 00       	push   $0xf3
80105d3b:	e9 92 f0 ff ff       	jmp    80104dd2 <alltraps>

80105d40 <vector244>:
80105d40:	6a 00                	push   $0x0
80105d42:	68 f4 00 00 00       	push   $0xf4
80105d47:	e9 86 f0 ff ff       	jmp    80104dd2 <alltraps>

80105d4c <vector245>:
80105d4c:	6a 00                	push   $0x0
80105d4e:	68 f5 00 00 00       	push   $0xf5
80105d53:	e9 7a f0 ff ff       	jmp    80104dd2 <alltraps>

80105d58 <vector246>:
80105d58:	6a 00                	push   $0x0
80105d5a:	68 f6 00 00 00       	push   $0xf6
80105d5f:	e9 6e f0 ff ff       	jmp    80104dd2 <alltraps>

80105d64 <vector247>:
80105d64:	6a 00                	push   $0x0
80105d66:	68 f7 00 00 00       	push   $0xf7
80105d6b:	e9 62 f0 ff ff       	jmp    80104dd2 <alltraps>

80105d70 <vector248>:
80105d70:	6a 00                	push   $0x0
80105d72:	68 f8 00 00 00       	push   $0xf8
80105d77:	e9 56 f0 ff ff       	jmp    80104dd2 <alltraps>

80105d7c <vector249>:
80105d7c:	6a 00                	push   $0x0
80105d7e:	68 f9 00 00 00       	push   $0xf9
80105d83:	e9 4a f0 ff ff       	jmp    80104dd2 <alltraps>

80105d88 <vector250>:
80105d88:	6a 00                	push   $0x0
80105d8a:	68 fa 00 00 00       	push   $0xfa
80105d8f:	e9 3e f0 ff ff       	jmp    80104dd2 <alltraps>

80105d94 <vector251>:
80105d94:	6a 00                	push   $0x0
80105d96:	68 fb 00 00 00       	push   $0xfb
80105d9b:	e9 32 f0 ff ff       	jmp    80104dd2 <alltraps>

80105da0 <vector252>:
80105da0:	6a 00                	push   $0x0
80105da2:	68 fc 00 00 00       	push   $0xfc
80105da7:	e9 26 f0 ff ff       	jmp    80104dd2 <alltraps>

80105dac <vector253>:
80105dac:	6a 00                	push   $0x0
80105dae:	68 fd 00 00 00       	push   $0xfd
80105db3:	e9 1a f0 ff ff       	jmp    80104dd2 <alltraps>

80105db8 <vector254>:
80105db8:	6a 00                	push   $0x0
80105dba:	68 fe 00 00 00       	push   $0xfe
80105dbf:	e9 0e f0 ff ff       	jmp    80104dd2 <alltraps>

80105dc4 <vector255>:
80105dc4:	6a 00                	push   $0x0
80105dc6:	68 ff 00 00 00       	push   $0xff
80105dcb:	e9 02 f0 ff ff       	jmp    80104dd2 <alltraps>

80105dd0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
80105dd6:	83 ec 0c             	sub    $0xc,%esp
80105dd9:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105ddb:	c1 ea 16             	shr    $0x16,%edx
80105dde:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105de1:	8b 37                	mov    (%edi),%esi
80105de3:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105de9:	74 20                	je     80105e0b <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105deb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105df1:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105df7:	c1 eb 0c             	shr    $0xc,%ebx
80105dfa:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105e00:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e06:	5b                   	pop    %ebx
80105e07:	5e                   	pop    %esi
80105e08:	5f                   	pop    %edi
80105e09:	5d                   	pop    %ebp
80105e0a:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105e0b:	85 c9                	test   %ecx,%ecx
80105e0d:	74 2b                	je     80105e3a <walkpgdir+0x6a>
80105e0f:	e8 13 c2 ff ff       	call   80102027 <kalloc>
80105e14:	89 c6                	mov    %eax,%esi
80105e16:	85 c0                	test   %eax,%eax
80105e18:	74 20                	je     80105e3a <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105e1a:	83 ec 04             	sub    $0x4,%esp
80105e1d:	68 00 10 00 00       	push   $0x1000
80105e22:	6a 00                	push   $0x0
80105e24:	50                   	push   %eax
80105e25:	e8 63 de ff ff       	call   80103c8d <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105e2a:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105e30:	83 c8 07             	or     $0x7,%eax
80105e33:	89 07                	mov    %eax,(%edi)
80105e35:	83 c4 10             	add    $0x10,%esp
80105e38:	eb bd                	jmp    80105df7 <walkpgdir+0x27>
      return 0;
80105e3a:	b8 00 00 00 00       	mov    $0x0,%eax
80105e3f:	eb c2                	jmp    80105e03 <walkpgdir+0x33>

80105e41 <seginit>:
{
80105e41:	55                   	push   %ebp
80105e42:	89 e5                	mov    %esp,%ebp
80105e44:	57                   	push   %edi
80105e45:	56                   	push   %esi
80105e46:	53                   	push   %ebx
80105e47:	83 ec 2c             	sub    $0x2c,%esp
  c = &cpus[cpuid()];
80105e4a:	e8 a2 d2 ff ff       	call   801030f1 <cpuid>
80105e4f:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e51:	8d 14 80             	lea    (%eax,%eax,4),%edx
80105e54:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
80105e57:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80105e5a:	c1 e0 04             	shl    $0x4,%eax
80105e5d:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
80105e64:	ff ff 
80105e66:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
80105e6d:	00 00 
80105e6f:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
80105e76:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80105e79:	01 d9                	add    %ebx,%ecx
80105e7b:	c1 e1 04             	shl    $0x4,%ecx
80105e7e:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
80105e85:	83 e6 f0             	and    $0xfffffff0,%esi
80105e88:	89 f7                	mov    %esi,%edi
80105e8a:	83 cf 0a             	or     $0xa,%edi
80105e8d:	89 fa                	mov    %edi,%edx
80105e8f:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105e95:	83 ce 1a             	or     $0x1a,%esi
80105e98:	89 f2                	mov    %esi,%edx
80105e9a:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105ea0:	83 e6 9f             	and    $0xffffff9f,%esi
80105ea3:	89 f2                	mov    %esi,%edx
80105ea5:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105eab:	83 ce 80             	or     $0xffffff80,%esi
80105eae:	89 f2                	mov    %esi,%edx
80105eb0:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105eb6:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
80105ebd:	83 ce 0f             	or     $0xf,%esi
80105ec0:	89 f2                	mov    %esi,%edx
80105ec2:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105ec8:	89 f7                	mov    %esi,%edi
80105eca:	83 e7 ef             	and    $0xffffffef,%edi
80105ecd:	89 fa                	mov    %edi,%edx
80105ecf:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105ed5:	83 e6 cf             	and    $0xffffffcf,%esi
80105ed8:	89 f2                	mov    %esi,%edx
80105eda:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105ee0:	89 f7                	mov    %esi,%edi
80105ee2:	83 cf 40             	or     $0x40,%edi
80105ee5:	89 fa                	mov    %edi,%edx
80105ee7:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105eed:	83 ce c0             	or     $0xffffffc0,%esi
80105ef0:	89 f2                	mov    %esi,%edx
80105ef2:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105ef8:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105eff:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
80105f06:	ff ff 
80105f08:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
80105f0f:	00 00 
80105f11:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
80105f18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105f1b:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80105f1e:	c1 e1 04             	shl    $0x4,%ecx
80105f21:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
80105f28:	83 e6 f0             	and    $0xfffffff0,%esi
80105f2b:	89 f7                	mov    %esi,%edi
80105f2d:	83 cf 02             	or     $0x2,%edi
80105f30:	89 fa                	mov    %edi,%edx
80105f32:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f38:	83 ce 12             	or     $0x12,%esi
80105f3b:	89 f2                	mov    %esi,%edx
80105f3d:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f43:	83 e6 9f             	and    $0xffffff9f,%esi
80105f46:	89 f2                	mov    %esi,%edx
80105f48:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f4e:	83 ce 80             	or     $0xffffff80,%esi
80105f51:	89 f2                	mov    %esi,%edx
80105f53:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f59:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
80105f60:	83 ce 0f             	or     $0xf,%esi
80105f63:	89 f2                	mov    %esi,%edx
80105f65:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105f6b:	89 f7                	mov    %esi,%edi
80105f6d:	83 e7 ef             	and    $0xffffffef,%edi
80105f70:	89 fa                	mov    %edi,%edx
80105f72:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105f78:	83 e6 cf             	and    $0xffffffcf,%esi
80105f7b:	89 f2                	mov    %esi,%edx
80105f7d:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105f83:	89 f7                	mov    %esi,%edi
80105f85:	83 cf 40             	or     $0x40,%edi
80105f88:	89 fa                	mov    %edi,%edx
80105f8a:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105f90:	83 ce c0             	or     $0xffffffc0,%esi
80105f93:	89 f2                	mov    %esi,%edx
80105f95:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105f9b:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105fa2:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
80105fa9:	ff ff 
80105fab:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
80105fb2:	00 00 
80105fb4:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
80105fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105fbe:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80105fc1:	c1 e1 04             	shl    $0x4,%ecx
80105fc4:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
80105fcb:	83 e6 f0             	and    $0xfffffff0,%esi
80105fce:	89 f7                	mov    %esi,%edi
80105fd0:	83 cf 0a             	or     $0xa,%edi
80105fd3:	89 fa                	mov    %edi,%edx
80105fd5:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80105fdb:	89 f7                	mov    %esi,%edi
80105fdd:	83 cf 1a             	or     $0x1a,%edi
80105fe0:	89 fa                	mov    %edi,%edx
80105fe2:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80105fe8:	83 ce 7a             	or     $0x7a,%esi
80105feb:	89 f2                	mov    %esi,%edx
80105fed:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80105ff3:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
80105ffa:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
80106001:	83 ce 0f             	or     $0xf,%esi
80106004:	89 f2                	mov    %esi,%edx
80106006:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010600c:	89 f7                	mov    %esi,%edi
8010600e:	83 e7 ef             	and    $0xffffffef,%edi
80106011:	89 fa                	mov    %edi,%edx
80106013:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106019:	83 e6 cf             	and    $0xffffffcf,%esi
8010601c:	89 f2                	mov    %esi,%edx
8010601e:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106024:	89 f7                	mov    %esi,%edi
80106026:	83 cf 40             	or     $0x40,%edi
80106029:	89 fa                	mov    %edi,%edx
8010602b:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106031:	83 ce c0             	or     $0xffffffc0,%esi
80106034:	89 f2                	mov    %esi,%edx
80106036:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010603c:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106043:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
8010604a:	ff ff 
8010604c:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
80106053:	00 00 
80106055:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
8010605c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010605f:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106062:	c1 e1 04             	shl    $0x4,%ecx
80106065:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
8010606c:	83 e6 f0             	and    $0xfffffff0,%esi
8010606f:	89 f7                	mov    %esi,%edi
80106071:	83 cf 02             	or     $0x2,%edi
80106074:	89 fa                	mov    %edi,%edx
80106076:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
8010607c:	89 f7                	mov    %esi,%edi
8010607e:	83 cf 12             	or     $0x12,%edi
80106081:	89 fa                	mov    %edi,%edx
80106083:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106089:	83 ce 72             	or     $0x72,%esi
8010608c:	89 f2                	mov    %esi,%edx
8010608e:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80106094:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
8010609b:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
801060a2:	83 ce 0f             	or     $0xf,%esi
801060a5:	89 f2                	mov    %esi,%edx
801060a7:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801060ad:	89 f7                	mov    %esi,%edi
801060af:	83 e7 ef             	and    $0xffffffef,%edi
801060b2:	89 fa                	mov    %edi,%edx
801060b4:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801060ba:	83 e6 cf             	and    $0xffffffcf,%esi
801060bd:	89 f2                	mov    %esi,%edx
801060bf:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801060c5:	89 f7                	mov    %esi,%edi
801060c7:	83 cf 40             	or     $0x40,%edi
801060ca:	89 fa                	mov    %edi,%edx
801060cc:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801060d2:	83 ce c0             	or     $0xffffffc0,%esi
801060d5:	89 f2                	mov    %esi,%edx
801060d7:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801060dd:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801060e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801060e7:	01 da                	add    %ebx,%edx
801060e9:	c1 e2 04             	shl    $0x4,%edx
801060ec:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
801060f2:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
801060f8:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
801060fc:	c1 ea 10             	shr    $0x10,%edx
801060ff:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106103:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106106:	0f 01 10             	lgdtl  (%eax)
}
80106109:	83 c4 2c             	add    $0x2c,%esp
8010610c:	5b                   	pop    %ebx
8010610d:	5e                   	pop    %esi
8010610e:	5f                   	pop    %edi
8010610f:	5d                   	pop    %ebp
80106110:	c3                   	ret    

80106111 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106111:	55                   	push   %ebp
80106112:	89 e5                	mov    %esp,%ebp
80106114:	57                   	push   %edi
80106115:	56                   	push   %esi
80106116:	53                   	push   %ebx
80106117:	83 ec 0c             	sub    $0xc,%esp
8010611a:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010611d:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106120:	89 fb                	mov    %edi,%ebx
80106122:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106128:	03 7d 10             	add    0x10(%ebp),%edi
8010612b:	4f                   	dec    %edi
8010612c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106132:	b9 01 00 00 00       	mov    $0x1,%ecx
80106137:	89 da                	mov    %ebx,%edx
80106139:	8b 45 08             	mov    0x8(%ebp),%eax
8010613c:	e8 8f fc ff ff       	call   80105dd0 <walkpgdir>
80106141:	85 c0                	test   %eax,%eax
80106143:	74 2e                	je     80106173 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80106145:	f6 00 01             	testb  $0x1,(%eax)
80106148:	75 1c                	jne    80106166 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010614a:	89 f2                	mov    %esi,%edx
8010614c:	0b 55 18             	or     0x18(%ebp),%edx
8010614f:	83 ca 01             	or     $0x1,%edx
80106152:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106154:	39 fb                	cmp    %edi,%ebx
80106156:	74 28                	je     80106180 <mappages+0x6f>
      break;
    a += PGSIZE;
80106158:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
8010615e:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106164:	eb cc                	jmp    80106132 <mappages+0x21>
      panic("remap");
80106166:	83 ec 0c             	sub    $0xc,%esp
80106169:	68 80 71 10 80       	push   $0x80107180
8010616e:	e8 ce a1 ff ff       	call   80100341 <panic>
      return -1;
80106173:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010617b:	5b                   	pop    %ebx
8010617c:	5e                   	pop    %esi
8010617d:	5f                   	pop    %edi
8010617e:	5d                   	pop    %ebp
8010617f:	c3                   	ret    
  return 0;
80106180:	b8 00 00 00 00       	mov    $0x0,%eax
80106185:	eb f1                	jmp    80106178 <mappages+0x67>

80106187 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106187:	a1 24 48 11 80       	mov    0x80114824,%eax
8010618c:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106191:	0f 22 d8             	mov    %eax,%cr3
}
80106194:	c3                   	ret    

80106195 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106195:	55                   	push   %ebp
80106196:	89 e5                	mov    %esp,%ebp
80106198:	57                   	push   %edi
80106199:	56                   	push   %esi
8010619a:	53                   	push   %ebx
8010619b:	83 ec 1c             	sub    $0x1c,%esp
8010619e:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801061a1:	85 f6                	test   %esi,%esi
801061a3:	0f 84 21 01 00 00    	je     801062ca <switchuvm+0x135>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801061a9:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801061ad:	0f 84 24 01 00 00    	je     801062d7 <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801061b3:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801061b7:	0f 84 27 01 00 00    	je     801062e4 <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
801061bd:	e8 45 d9 ff ff       	call   80103b07 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801061c2:	e8 c6 ce ff ff       	call   8010308d <mycpu>
801061c7:	89 c3                	mov    %eax,%ebx
801061c9:	e8 bf ce ff ff       	call   8010308d <mycpu>
801061ce:	8d 78 08             	lea    0x8(%eax),%edi
801061d1:	e8 b7 ce ff ff       	call   8010308d <mycpu>
801061d6:	83 c0 08             	add    $0x8,%eax
801061d9:	c1 e8 10             	shr    $0x10,%eax
801061dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061df:	e8 a9 ce ff ff       	call   8010308d <mycpu>
801061e4:	83 c0 08             	add    $0x8,%eax
801061e7:	c1 e8 18             	shr    $0x18,%eax
801061ea:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801061f1:	67 00 
801061f3:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801061fa:	8a 4d e4             	mov    -0x1c(%ebp),%cl
801061fd:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106203:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80106209:	83 e2 f0             	and    $0xfffffff0,%edx
8010620c:	88 d1                	mov    %dl,%cl
8010620e:	83 c9 09             	or     $0x9,%ecx
80106211:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
80106217:	83 ca 19             	or     $0x19,%edx
8010621a:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106220:	83 e2 9f             	and    $0xffffff9f,%edx
80106223:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106229:	83 ca 80             	or     $0xffffff80,%edx
8010622c:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106232:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80106238:	88 d1                	mov    %dl,%cl
8010623a:	83 e1 f0             	and    $0xfffffff0,%ecx
8010623d:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106243:	88 d1                	mov    %dl,%cl
80106245:	83 e1 e0             	and    $0xffffffe0,%ecx
80106248:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010624e:	83 e2 c0             	and    $0xffffffc0,%edx
80106251:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106257:	83 ca 40             	or     $0x40,%edx
8010625a:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106260:	83 e2 7f             	and    $0x7f,%edx
80106263:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106269:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010626f:	e8 19 ce ff ff       	call   8010308d <mycpu>
80106274:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010627a:	83 e2 ef             	and    $0xffffffef,%edx
8010627d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106283:	e8 05 ce ff ff       	call   8010308d <mycpu>
80106288:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010628e:	8b 5e 08             	mov    0x8(%esi),%ebx
80106291:	e8 f7 cd ff ff       	call   8010308d <mycpu>
80106296:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010629c:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010629f:	e8 e9 cd ff ff       	call   8010308d <mycpu>
801062a4:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801062aa:	b8 28 00 00 00       	mov    $0x28,%eax
801062af:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801062b2:	8b 46 04             	mov    0x4(%esi),%eax
801062b5:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801062ba:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801062bd:	e8 80 d8 ff ff       	call   80103b42 <popcli>
}
801062c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c5:	5b                   	pop    %ebx
801062c6:	5e                   	pop    %esi
801062c7:	5f                   	pop    %edi
801062c8:	5d                   	pop    %ebp
801062c9:	c3                   	ret    
    panic("switchuvm: no process");
801062ca:	83 ec 0c             	sub    $0xc,%esp
801062cd:	68 86 71 10 80       	push   $0x80107186
801062d2:	e8 6a a0 ff ff       	call   80100341 <panic>
    panic("switchuvm: no kstack");
801062d7:	83 ec 0c             	sub    $0xc,%esp
801062da:	68 9c 71 10 80       	push   $0x8010719c
801062df:	e8 5d a0 ff ff       	call   80100341 <panic>
    panic("switchuvm: no pgdir");
801062e4:	83 ec 0c             	sub    $0xc,%esp
801062e7:	68 b1 71 10 80       	push   $0x801071b1
801062ec:	e8 50 a0 ff ff       	call   80100341 <panic>

801062f1 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801062f1:	55                   	push   %ebp
801062f2:	89 e5                	mov    %esp,%ebp
801062f4:	56                   	push   %esi
801062f5:	53                   	push   %ebx
801062f6:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801062f9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801062ff:	77 4b                	ja     8010634c <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
80106301:	e8 21 bd ff ff       	call   80102027 <kalloc>
80106306:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106308:	83 ec 04             	sub    $0x4,%esp
8010630b:	68 00 10 00 00       	push   $0x1000
80106310:	6a 00                	push   $0x0
80106312:	50                   	push   %eax
80106313:	e8 75 d9 ff ff       	call   80103c8d <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106318:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010631f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106325:	50                   	push   %eax
80106326:	68 00 10 00 00       	push   $0x1000
8010632b:	6a 00                	push   $0x0
8010632d:	ff 75 08             	push   0x8(%ebp)
80106330:	e8 dc fd ff ff       	call   80106111 <mappages>
  memmove(mem, init, sz);
80106335:	83 c4 1c             	add    $0x1c,%esp
80106338:	56                   	push   %esi
80106339:	ff 75 0c             	push   0xc(%ebp)
8010633c:	53                   	push   %ebx
8010633d:	e8 c9 d9 ff ff       	call   80103d0b <memmove>
}
80106342:	83 c4 10             	add    $0x10,%esp
80106345:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106348:	5b                   	pop    %ebx
80106349:	5e                   	pop    %esi
8010634a:	5d                   	pop    %ebp
8010634b:	c3                   	ret    
    panic("inituvm: more than a page");
8010634c:	83 ec 0c             	sub    $0xc,%esp
8010634f:	68 c5 71 10 80       	push   $0x801071c5
80106354:	e8 e8 9f ff ff       	call   80100341 <panic>

80106359 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106359:	55                   	push   %ebp
8010635a:	89 e5                	mov    %esp,%ebp
8010635c:	57                   	push   %edi
8010635d:	56                   	push   %esi
8010635e:	53                   	push   %ebx
8010635f:	83 ec 0c             	sub    $0xc,%esp
80106362:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106365:	89 fb                	mov    %edi,%ebx
80106367:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010636d:	74 3c                	je     801063ab <loaduvm+0x52>
    panic("loaduvm: addr must be page aligned");
8010636f:	83 ec 0c             	sub    $0xc,%esp
80106372:	68 80 72 10 80       	push   $0x80107280
80106377:	e8 c5 9f ff ff       	call   80100341 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010637c:	83 ec 0c             	sub    $0xc,%esp
8010637f:	68 df 71 10 80       	push   $0x801071df
80106384:	e8 b8 9f ff ff       	call   80100341 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106389:	05 00 00 00 80       	add    $0x80000000,%eax
8010638e:	56                   	push   %esi
8010638f:	89 da                	mov    %ebx,%edx
80106391:	03 55 14             	add    0x14(%ebp),%edx
80106394:	52                   	push   %edx
80106395:	50                   	push   %eax
80106396:	ff 75 10             	push   0x10(%ebp)
80106399:	e8 55 b3 ff ff       	call   801016f3 <readi>
8010639e:	83 c4 10             	add    $0x10,%esp
801063a1:	39 f0                	cmp    %esi,%eax
801063a3:	75 47                	jne    801063ec <loaduvm+0x93>
  for(i = 0; i < sz; i += PGSIZE){
801063a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801063ab:	3b 5d 18             	cmp    0x18(%ebp),%ebx
801063ae:	73 2f                	jae    801063df <loaduvm+0x86>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801063b0:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
801063b3:	b9 00 00 00 00       	mov    $0x0,%ecx
801063b8:	8b 45 08             	mov    0x8(%ebp),%eax
801063bb:	e8 10 fa ff ff       	call   80105dd0 <walkpgdir>
801063c0:	85 c0                	test   %eax,%eax
801063c2:	74 b8                	je     8010637c <loaduvm+0x23>
    pa = PTE_ADDR(*pte);
801063c4:	8b 00                	mov    (%eax),%eax
801063c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801063cb:	8b 75 18             	mov    0x18(%ebp),%esi
801063ce:	29 de                	sub    %ebx,%esi
801063d0:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801063d6:	76 b1                	jbe    80106389 <loaduvm+0x30>
      n = PGSIZE;
801063d8:	be 00 10 00 00       	mov    $0x1000,%esi
801063dd:	eb aa                	jmp    80106389 <loaduvm+0x30>
      return -1;
  }
  return 0;
801063df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e7:	5b                   	pop    %ebx
801063e8:	5e                   	pop    %esi
801063e9:	5f                   	pop    %edi
801063ea:	5d                   	pop    %ebp
801063eb:	c3                   	ret    
      return -1;
801063ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f1:	eb f1                	jmp    801063e4 <loaduvm+0x8b>

801063f3 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801063f3:	55                   	push   %ebp
801063f4:	89 e5                	mov    %esp,%ebp
801063f6:	57                   	push   %edi
801063f7:	56                   	push   %esi
801063f8:	53                   	push   %ebx
801063f9:	83 ec 0c             	sub    $0xc,%esp
801063fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801063ff:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106402:	73 11                	jae    80106415 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
80106404:	8b 45 10             	mov    0x10(%ebp),%eax
80106407:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010640d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106413:	eb 17                	jmp    8010642c <deallocuvm+0x39>
    return oldsz;
80106415:	89 f8                	mov    %edi,%eax
80106417:	eb 62                	jmp    8010647b <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106419:	c1 eb 16             	shr    $0x16,%ebx
8010641c:	43                   	inc    %ebx
8010641d:	c1 e3 16             	shl    $0x16,%ebx
80106420:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010642c:	39 fb                	cmp    %edi,%ebx
8010642e:	73 48                	jae    80106478 <deallocuvm+0x85>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106430:	b9 00 00 00 00       	mov    $0x0,%ecx
80106435:	89 da                	mov    %ebx,%edx
80106437:	8b 45 08             	mov    0x8(%ebp),%eax
8010643a:	e8 91 f9 ff ff       	call   80105dd0 <walkpgdir>
8010643f:	89 c6                	mov    %eax,%esi
    if(!pte)
80106441:	85 c0                	test   %eax,%eax
80106443:	74 d4                	je     80106419 <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
80106445:	8b 00                	mov    (%eax),%eax
80106447:	a8 01                	test   $0x1,%al
80106449:	74 db                	je     80106426 <deallocuvm+0x33>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010644b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106450:	74 19                	je     8010646b <deallocuvm+0x78>
        panic("kfree");
      char *v = P2V(pa);
80106452:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106457:	83 ec 0c             	sub    $0xc,%esp
8010645a:	50                   	push   %eax
8010645b:	e8 b0 ba ff ff       	call   80101f10 <kfree>
      *pte = 0;
80106460:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106466:	83 c4 10             	add    $0x10,%esp
80106469:	eb bb                	jmp    80106426 <deallocuvm+0x33>
        panic("kfree");
8010646b:	83 ec 0c             	sub    $0xc,%esp
8010646e:	68 a6 6a 10 80       	push   $0x80106aa6
80106473:	e8 c9 9e ff ff       	call   80100341 <panic>
    }
  }
  return newsz;
80106478:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010647b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010647e:	5b                   	pop    %ebx
8010647f:	5e                   	pop    %esi
80106480:	5f                   	pop    %edi
80106481:	5d                   	pop    %ebp
80106482:	c3                   	ret    

80106483 <allocuvm>:
{
80106483:	55                   	push   %ebp
80106484:	89 e5                	mov    %esp,%ebp
80106486:	57                   	push   %edi
80106487:	56                   	push   %esi
80106488:	53                   	push   %ebx
80106489:	83 ec 1c             	sub    $0x1c,%esp
8010648c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010648f:	8b 45 10             	mov    0x10(%ebp),%eax
80106492:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106495:	85 c0                	test   %eax,%eax
80106497:	0f 88 c1 00 00 00    	js     8010655e <allocuvm+0xdb>
  if(newsz < oldsz)
8010649d:	8b 45 0c             	mov    0xc(%ebp),%eax
801064a0:	39 45 10             	cmp    %eax,0x10(%ebp)
801064a3:	72 5c                	jb     80106501 <allocuvm+0x7e>
  a = PGROUNDUP(oldsz);
801064a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801064a8:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801064ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801064b4:	3b 75 10             	cmp    0x10(%ebp),%esi
801064b7:	0f 83 a8 00 00 00    	jae    80106565 <allocuvm+0xe2>
    mem = kalloc();
801064bd:	e8 65 bb ff ff       	call   80102027 <kalloc>
801064c2:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801064c4:	85 c0                	test   %eax,%eax
801064c6:	74 3e                	je     80106506 <allocuvm+0x83>
    memset(mem, 0, PGSIZE);
801064c8:	83 ec 04             	sub    $0x4,%esp
801064cb:	68 00 10 00 00       	push   $0x1000
801064d0:	6a 00                	push   $0x0
801064d2:	50                   	push   %eax
801064d3:	e8 b5 d7 ff ff       	call   80103c8d <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801064d8:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801064df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064e5:	50                   	push   %eax
801064e6:	68 00 10 00 00       	push   $0x1000
801064eb:	56                   	push   %esi
801064ec:	57                   	push   %edi
801064ed:	e8 1f fc ff ff       	call   80106111 <mappages>
801064f2:	83 c4 20             	add    $0x20,%esp
801064f5:	85 c0                	test   %eax,%eax
801064f7:	78 35                	js     8010652e <allocuvm+0xab>
  for(; a < newsz; a += PGSIZE){
801064f9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801064ff:	eb b3                	jmp    801064b4 <allocuvm+0x31>
    return oldsz;
80106501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106504:	eb 5f                	jmp    80106565 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
80106506:	83 ec 0c             	sub    $0xc,%esp
80106509:	68 fd 71 10 80       	push   $0x801071fd
8010650e:	e8 c7 a0 ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106513:	83 c4 0c             	add    $0xc,%esp
80106516:	ff 75 0c             	push   0xc(%ebp)
80106519:	ff 75 10             	push   0x10(%ebp)
8010651c:	57                   	push   %edi
8010651d:	e8 d1 fe ff ff       	call   801063f3 <deallocuvm>
      return 0;
80106522:	83 c4 10             	add    $0x10,%esp
80106525:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010652c:	eb 37                	jmp    80106565 <allocuvm+0xe2>
      cprintf("allocuvm out of memory (2)\n");
8010652e:	83 ec 0c             	sub    $0xc,%esp
80106531:	68 15 72 10 80       	push   $0x80107215
80106536:	e8 9f a0 ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010653b:	83 c4 0c             	add    $0xc,%esp
8010653e:	ff 75 0c             	push   0xc(%ebp)
80106541:	ff 75 10             	push   0x10(%ebp)
80106544:	57                   	push   %edi
80106545:	e8 a9 fe ff ff       	call   801063f3 <deallocuvm>
      kfree(mem);
8010654a:	89 1c 24             	mov    %ebx,(%esp)
8010654d:	e8 be b9 ff ff       	call   80101f10 <kfree>
      return 0;
80106552:	83 c4 10             	add    $0x10,%esp
80106555:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010655c:	eb 07                	jmp    80106565 <allocuvm+0xe2>
    return 0;
8010655e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010656b:	5b                   	pop    %ebx
8010656c:	5e                   	pop    %esi
8010656d:	5f                   	pop    %edi
8010656e:	5d                   	pop    %ebp
8010656f:	c3                   	ret    

80106570 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	56                   	push   %esi
80106574:	53                   	push   %ebx
80106575:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106578:	85 f6                	test   %esi,%esi
8010657a:	74 0d                	je     80106589 <freevm+0x19>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
8010657c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106580:	75 14                	jne    80106596 <freevm+0x26>
{
80106582:	bb 00 00 00 00       	mov    $0x0,%ebx
80106587:	eb 23                	jmp    801065ac <freevm+0x3c>
    panic("freevm: no pgdir");
80106589:	83 ec 0c             	sub    $0xc,%esp
8010658c:	68 31 72 10 80       	push   $0x80107231
80106591:	e8 ab 9d ff ff       	call   80100341 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
80106596:	83 ec 04             	sub    $0x4,%esp
80106599:	6a 00                	push   $0x0
8010659b:	68 00 00 00 80       	push   $0x80000000
801065a0:	56                   	push   %esi
801065a1:	e8 4d fe ff ff       	call   801063f3 <deallocuvm>
801065a6:	83 c4 10             	add    $0x10,%esp
801065a9:	eb d7                	jmp    80106582 <freevm+0x12>
  for(i = 0; i < NPDENTRIES; i++){
801065ab:	43                   	inc    %ebx
801065ac:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801065b2:	77 1f                	ja     801065d3 <freevm+0x63>
    if(pgdir[i] & PTE_P){
801065b4:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801065b7:	a8 01                	test   $0x1,%al
801065b9:	74 f0                	je     801065ab <freevm+0x3b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801065bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065c0:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801065c5:	83 ec 0c             	sub    $0xc,%esp
801065c8:	50                   	push   %eax
801065c9:	e8 42 b9 ff ff       	call   80101f10 <kfree>
801065ce:	83 c4 10             	add    $0x10,%esp
801065d1:	eb d8                	jmp    801065ab <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
801065d3:	83 ec 0c             	sub    $0xc,%esp
801065d6:	56                   	push   %esi
801065d7:	e8 34 b9 ff ff       	call   80101f10 <kfree>
}
801065dc:	83 c4 10             	add    $0x10,%esp
801065df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065e2:	5b                   	pop    %ebx
801065e3:	5e                   	pop    %esi
801065e4:	5d                   	pop    %ebp
801065e5:	c3                   	ret    

801065e6 <setupkvm>:
{
801065e6:	55                   	push   %ebp
801065e7:	89 e5                	mov    %esp,%ebp
801065e9:	56                   	push   %esi
801065ea:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801065eb:	e8 37 ba ff ff       	call   80102027 <kalloc>
801065f0:	89 c6                	mov    %eax,%esi
801065f2:	85 c0                	test   %eax,%eax
801065f4:	74 57                	je     8010664d <setupkvm+0x67>
  memset(pgdir, 0, PGSIZE);
801065f6:	83 ec 04             	sub    $0x4,%esp
801065f9:	68 00 10 00 00       	push   $0x1000
801065fe:	6a 00                	push   $0x0
80106600:	50                   	push   %eax
80106601:	e8 87 d6 ff ff       	call   80103c8d <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106606:	83 c4 10             	add    $0x10,%esp
80106609:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
8010660e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106614:	73 37                	jae    8010664d <setupkvm+0x67>
                (uint)k->phys_start, k->perm) < 0) {
80106616:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106619:	83 ec 0c             	sub    $0xc,%esp
8010661c:	ff 73 0c             	push   0xc(%ebx)
8010661f:	52                   	push   %edx
80106620:	8b 43 08             	mov    0x8(%ebx),%eax
80106623:	29 d0                	sub    %edx,%eax
80106625:	50                   	push   %eax
80106626:	ff 33                	push   (%ebx)
80106628:	56                   	push   %esi
80106629:	e8 e3 fa ff ff       	call   80106111 <mappages>
8010662e:	83 c4 20             	add    $0x20,%esp
80106631:	85 c0                	test   %eax,%eax
80106633:	78 05                	js     8010663a <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106635:	83 c3 10             	add    $0x10,%ebx
80106638:	eb d4                	jmp    8010660e <setupkvm+0x28>
      freevm(pgdir, 0);
8010663a:	83 ec 08             	sub    $0x8,%esp
8010663d:	6a 00                	push   $0x0
8010663f:	56                   	push   %esi
80106640:	e8 2b ff ff ff       	call   80106570 <freevm>
      return 0;
80106645:	83 c4 10             	add    $0x10,%esp
80106648:	be 00 00 00 00       	mov    $0x0,%esi
}
8010664d:	89 f0                	mov    %esi,%eax
8010664f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106652:	5b                   	pop    %ebx
80106653:	5e                   	pop    %esi
80106654:	5d                   	pop    %ebp
80106655:	c3                   	ret    

80106656 <kvmalloc>:
{
80106656:	55                   	push   %ebp
80106657:	89 e5                	mov    %esp,%ebp
80106659:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010665c:	e8 85 ff ff ff       	call   801065e6 <setupkvm>
80106661:	a3 24 48 11 80       	mov    %eax,0x80114824
  switchkvm();
80106666:	e8 1c fb ff ff       	call   80106187 <switchkvm>
}
8010666b:	c9                   	leave  
8010666c:	c3                   	ret    

8010666d <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010666d:	55                   	push   %ebp
8010666e:	89 e5                	mov    %esp,%ebp
80106670:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106673:	b9 00 00 00 00       	mov    $0x0,%ecx
80106678:	8b 55 0c             	mov    0xc(%ebp),%edx
8010667b:	8b 45 08             	mov    0x8(%ebp),%eax
8010667e:	e8 4d f7 ff ff       	call   80105dd0 <walkpgdir>
  if(pte == 0)
80106683:	85 c0                	test   %eax,%eax
80106685:	74 05                	je     8010668c <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106687:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010668a:	c9                   	leave  
8010668b:	c3                   	ret    
    panic("clearpteu");
8010668c:	83 ec 0c             	sub    $0xc,%esp
8010668f:	68 42 72 10 80       	push   $0x80107242
80106694:	e8 a8 9c ff ff       	call   80100341 <panic>

80106699 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106699:	55                   	push   %ebp
8010669a:	89 e5                	mov    %esp,%ebp
8010669c:	57                   	push   %edi
8010669d:	56                   	push   %esi
8010669e:	53                   	push   %ebx
8010669f:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801066a2:	e8 3f ff ff ff       	call   801065e6 <setupkvm>
801066a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066aa:	85 c0                	test   %eax,%eax
801066ac:	0f 84 c6 00 00 00    	je     80106778 <copyuvm+0xdf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801066b2:	bb 00 00 00 00       	mov    $0x0,%ebx
801066b7:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
801066ba:	0f 83 b8 00 00 00    	jae    80106778 <copyuvm+0xdf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801066c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801066c3:	b9 00 00 00 00       	mov    $0x0,%ecx
801066c8:	89 da                	mov    %ebx,%edx
801066ca:	8b 45 08             	mov    0x8(%ebp),%eax
801066cd:	e8 fe f6 ff ff       	call   80105dd0 <walkpgdir>
801066d2:	85 c0                	test   %eax,%eax
801066d4:	74 65                	je     8010673b <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801066d6:	8b 00                	mov    (%eax),%eax
801066d8:	a8 01                	test   $0x1,%al
801066da:	74 6c                	je     80106748 <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801066dc:	89 c6                	mov    %eax,%esi
801066de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801066e4:	25 ff 0f 00 00       	and    $0xfff,%eax
801066e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801066ec:	e8 36 b9 ff ff       	call   80102027 <kalloc>
801066f1:	89 c7                	mov    %eax,%edi
801066f3:	85 c0                	test   %eax,%eax
801066f5:	74 6a                	je     80106761 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801066f7:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801066fd:	83 ec 04             	sub    $0x4,%esp
80106700:	68 00 10 00 00       	push   $0x1000
80106705:	56                   	push   %esi
80106706:	50                   	push   %eax
80106707:	e8 ff d5 ff ff       	call   80103d0b <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010670c:	83 c4 04             	add    $0x4,%esp
8010670f:	ff 75 e0             	push   -0x20(%ebp)
80106712:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106718:	50                   	push   %eax
80106719:	68 00 10 00 00       	push   $0x1000
8010671e:	ff 75 e4             	push   -0x1c(%ebp)
80106721:	ff 75 dc             	push   -0x24(%ebp)
80106724:	e8 e8 f9 ff ff       	call   80106111 <mappages>
80106729:	83 c4 20             	add    $0x20,%esp
8010672c:	85 c0                	test   %eax,%eax
8010672e:	78 25                	js     80106755 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
80106730:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106736:	e9 7c ff ff ff       	jmp    801066b7 <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
8010673b:	83 ec 0c             	sub    $0xc,%esp
8010673e:	68 4c 72 10 80       	push   $0x8010724c
80106743:	e8 f9 9b ff ff       	call   80100341 <panic>
      panic("copyuvm: page not present");
80106748:	83 ec 0c             	sub    $0xc,%esp
8010674b:	68 66 72 10 80       	push   $0x80107266
80106750:	e8 ec 9b ff ff       	call   80100341 <panic>
      kfree(mem);
80106755:	83 ec 0c             	sub    $0xc,%esp
80106758:	57                   	push   %edi
80106759:	e8 b2 b7 ff ff       	call   80101f10 <kfree>
      goto bad;
8010675e:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
80106761:	83 ec 08             	sub    $0x8,%esp
80106764:	6a 01                	push   $0x1
80106766:	ff 75 dc             	push   -0x24(%ebp)
80106769:	e8 02 fe ff ff       	call   80106570 <freevm>
  return 0;
8010676e:	83 c4 10             	add    $0x10,%esp
80106771:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106778:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010677b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010677e:	5b                   	pop    %ebx
8010677f:	5e                   	pop    %esi
80106780:	5f                   	pop    %edi
80106781:	5d                   	pop    %ebp
80106782:	c3                   	ret    

80106783 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106783:	55                   	push   %ebp
80106784:	89 e5                	mov    %esp,%ebp
80106786:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106789:	b9 00 00 00 00       	mov    $0x0,%ecx
8010678e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106791:	8b 45 08             	mov    0x8(%ebp),%eax
80106794:	e8 37 f6 ff ff       	call   80105dd0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106799:	8b 00                	mov    (%eax),%eax
8010679b:	a8 01                	test   $0x1,%al
8010679d:	74 10                	je     801067af <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
8010679f:	a8 04                	test   $0x4,%al
801067a1:	74 13                	je     801067b6 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801067a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067a8:	05 00 00 00 80       	add    $0x80000000,%eax
}
801067ad:	c9                   	leave  
801067ae:	c3                   	ret    
    return 0;
801067af:	b8 00 00 00 00       	mov    $0x0,%eax
801067b4:	eb f7                	jmp    801067ad <uva2ka+0x2a>
    return 0;
801067b6:	b8 00 00 00 00       	mov    $0x0,%eax
801067bb:	eb f0                	jmp    801067ad <uva2ka+0x2a>

801067bd <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801067bd:	55                   	push   %ebp
801067be:	89 e5                	mov    %esp,%ebp
801067c0:	57                   	push   %edi
801067c1:	56                   	push   %esi
801067c2:	53                   	push   %ebx
801067c3:	83 ec 0c             	sub    $0xc,%esp
801067c6:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801067c9:	eb 25                	jmp    801067f0 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801067cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801067ce:	29 f2                	sub    %esi,%edx
801067d0:	01 d0                	add    %edx,%eax
801067d2:	83 ec 04             	sub    $0x4,%esp
801067d5:	53                   	push   %ebx
801067d6:	ff 75 10             	push   0x10(%ebp)
801067d9:	50                   	push   %eax
801067da:	e8 2c d5 ff ff       	call   80103d0b <memmove>
    len -= n;
801067df:	29 df                	sub    %ebx,%edi
    buf += n;
801067e1:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801067e4:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801067ea:	89 45 0c             	mov    %eax,0xc(%ebp)
801067ed:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801067f0:	85 ff                	test   %edi,%edi
801067f2:	74 2f                	je     80106823 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
801067f4:	8b 75 0c             	mov    0xc(%ebp),%esi
801067f7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801067fd:	83 ec 08             	sub    $0x8,%esp
80106800:	56                   	push   %esi
80106801:	ff 75 08             	push   0x8(%ebp)
80106804:	e8 7a ff ff ff       	call   80106783 <uva2ka>
    if(pa0 == 0)
80106809:	83 c4 10             	add    $0x10,%esp
8010680c:	85 c0                	test   %eax,%eax
8010680e:	74 20                	je     80106830 <copyout+0x73>
    n = PGSIZE - (va - va0);
80106810:	89 f3                	mov    %esi,%ebx
80106812:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106815:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010681b:	39 df                	cmp    %ebx,%edi
8010681d:	73 ac                	jae    801067cb <copyout+0xe>
      n = len;
8010681f:	89 fb                	mov    %edi,%ebx
80106821:	eb a8                	jmp    801067cb <copyout+0xe>
  }
  return 0;
80106823:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010682b:	5b                   	pop    %ebx
8010682c:	5e                   	pop    %esi
8010682d:	5f                   	pop    %edi
8010682e:	5d                   	pop    %ebp
8010682f:	c3                   	ret    
      return -1;
80106830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106835:	eb f1                	jmp    80106828 <copyout+0x6b>
