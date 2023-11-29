
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
80100028:	bc 30 56 11 80       	mov    $0x80115630,%esp
8010002d:	b8 92 29 10 80       	mov    $0x80102992,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 95 3a 00 00       	call   80103ae0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 20 a5 10 80       	push   $0x8010a520
8010007a:	e8 c6 3a 00 00       	call   80103b45 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 47 38 00 00       	call   801038d1 <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
      b->dev = dev;
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 78 3a 00 00       	call   80103b45 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 f9 37 00 00       	call   801038d1 <acquiresleep>
      return b;
801000d8:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
  panic("bget: no buffers");
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 00 67 10 80       	push   $0x80106700
801000ed:	e8 4f 02 00 00       	call   80100341 <panic>

801000f2 <binit>:
{
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000f9:	68 11 67 10 80       	push   $0x80106711
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 a1 38 00 00       	call   801039a9 <initlock>
  bcache.head.prev = &bcache.head;
80100108:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010010f:	ec 10 80 
  bcache.head.next = &bcache.head;
80100112:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100119:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011c:	83 c4 10             	add    $0x10,%esp
8010011f:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100124:	eb 37                	jmp    8010015d <binit+0x6b>
    b->next = bcache.head.next;
80100126:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010012e:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100135:	83 ec 08             	sub    $0x8,%esp
80100138:	68 18 67 10 80       	push   $0x80106718
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 58 37 00 00       	call   8010389e <initsleeplock>
    bcache.head.next->prev = b;
80100146:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010014e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100154:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015a:	83 c4 10             	add    $0x10,%esp
8010015d:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100163:	72 c1                	jb     80100126 <binit+0x34>
}
80100165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100168:	c9                   	leave  
80100169:	c3                   	ret    

8010016a <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016a:	55                   	push   %ebp
8010016b:	89 e5                	mov    %esp,%ebp
8010016d:	53                   	push   %ebx
8010016e:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	8b 45 08             	mov    0x8(%ebp),%eax
80100177:	e8 b8 fe ff ff       	call   80100034 <bget>
8010017c:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
8010017e:	f6 00 02             	testb  $0x2,(%eax)
80100181:	74 07                	je     8010018a <bread+0x20>
    iderw(b);
  }
  return b;
}
80100183:	89 d8                	mov    %ebx,%eax
80100185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100188:	c9                   	leave  
80100189:	c3                   	ret    
    iderw(b);
8010018a:	83 ec 0c             	sub    $0xc,%esp
8010018d:	50                   	push   %eax
8010018e:	e8 ea 1b 00 00       	call   80101d7d <iderw>
80100193:	83 c4 10             	add    $0x10,%esp
  return b;
80100196:	eb eb                	jmp    80100183 <bread+0x19>

80100198 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100198:	55                   	push   %ebp
80100199:	89 e5                	mov    %esp,%ebp
8010019b:	53                   	push   %ebx
8010019c:	83 ec 10             	sub    $0x10,%esp
8010019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a5:	50                   	push   %eax
801001a6:	e8 b0 37 00 00       	call   8010395b <holdingsleep>
801001ab:	83 c4 10             	add    $0x10,%esp
801001ae:	85 c0                	test   %eax,%eax
801001b0:	74 14                	je     801001c6 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b2:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b5:	83 ec 0c             	sub    $0xc,%esp
801001b8:	53                   	push   %ebx
801001b9:	e8 bf 1b 00 00       	call   80101d7d <iderw>
}
801001be:	83 c4 10             	add    $0x10,%esp
801001c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c4:	c9                   	leave  
801001c5:	c3                   	ret    
    panic("bwrite");
801001c6:	83 ec 0c             	sub    $0xc,%esp
801001c9:	68 1f 67 10 80       	push   $0x8010671f
801001ce:	e8 6e 01 00 00       	call   80100341 <panic>

801001d3 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d3:	55                   	push   %ebp
801001d4:	89 e5                	mov    %esp,%ebp
801001d6:	56                   	push   %esi
801001d7:	53                   	push   %ebx
801001d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001db:	8d 73 0c             	lea    0xc(%ebx),%esi
801001de:	83 ec 0c             	sub    $0xc,%esp
801001e1:	56                   	push   %esi
801001e2:	e8 74 37 00 00       	call   8010395b <holdingsleep>
801001e7:	83 c4 10             	add    $0x10,%esp
801001ea:	85 c0                	test   %eax,%eax
801001ec:	74 69                	je     80100257 <brelse+0x84>
    panic("brelse");

  releasesleep(&b->lock);
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 29 37 00 00       	call   80103920 <releasesleep>

  acquire(&bcache.lock);
801001f7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001fe:	e8 dd 38 00 00       	call   80103ae0 <acquire>
  b->refcnt--;
80100203:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100206:	48                   	dec    %eax
80100207:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020a:	83 c4 10             	add    $0x10,%esp
8010020d:	85 c0                	test   %eax,%eax
8010020f:	75 2f                	jne    80100240 <brelse+0x6d>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100211:	8b 43 54             	mov    0x54(%ebx),%eax
80100214:	8b 53 50             	mov    0x50(%ebx),%edx
80100217:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021a:	8b 43 50             	mov    0x50(%ebx),%eax
8010021d:	8b 53 54             	mov    0x54(%ebx),%edx
80100220:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100223:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100228:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100232:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100237:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023a:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 20 a5 10 80       	push   $0x8010a520
80100248:	e8 f8 38 00 00       	call   80103b45 <release>
}
8010024d:	83 c4 10             	add    $0x10,%esp
80100250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100253:	5b                   	pop    %ebx
80100254:	5e                   	pop    %esi
80100255:	5d                   	pop    %ebp
80100256:	c3                   	ret    
    panic("brelse");
80100257:	83 ec 0c             	sub    $0xc,%esp
8010025a:	68 26 67 10 80       	push   $0x80106726
8010025f:	e8 dd 00 00 00       	call   80100341 <panic>

80100264 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100264:	55                   	push   %ebp
80100265:	89 e5                	mov    %esp,%ebp
80100267:	57                   	push   %edi
80100268:	56                   	push   %esi
80100269:	53                   	push   %ebx
8010026a:	83 ec 28             	sub    $0x28,%esp
8010026d:	8b 7d 08             	mov    0x8(%ebp),%edi
80100270:	8b 75 0c             	mov    0xc(%ebp),%esi
80100273:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100276:	57                   	push   %edi
80100277:	e8 4a 13 00 00       	call   801015c6 <iunlock>
  target = n;
8010027c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
8010027f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100286:	e8 55 38 00 00       	call   80103ae0 <acquire>
  while(n > 0){
8010028b:	83 c4 10             	add    $0x10,%esp
8010028e:	85 db                	test   %ebx,%ebx
80100290:	0f 8e 8c 00 00 00    	jle    80100322 <consoleread+0xbe>
    while(input.r == input.w){
80100296:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a1:	75 47                	jne    801002ea <consoleread+0x86>
      if(myproc()->killed){
801002a3:	e8 75 2e 00 00       	call   8010311d <myproc>
801002a8:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002ac:	75 17                	jne    801002c5 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002ae:	83 ec 08             	sub    $0x8,%esp
801002b1:	68 20 ef 10 80       	push   $0x8010ef20
801002b6:	68 00 ef 10 80       	push   $0x8010ef00
801002bb:	e8 0f 33 00 00       	call   801035cf <sleep>
801002c0:	83 c4 10             	add    $0x10,%esp
801002c3:	eb d1                	jmp    80100296 <consoleread+0x32>
        release(&cons.lock);
801002c5:	83 ec 0c             	sub    $0xc,%esp
801002c8:	68 20 ef 10 80       	push   $0x8010ef20
801002cd:	e8 73 38 00 00       	call   80103b45 <release>
        ilock(ip);
801002d2:	89 3c 24             	mov    %edi,(%esp)
801002d5:	e8 2c 12 00 00       	call   80101506 <ilock>
        return -1;
801002da:	83 c4 10             	add    $0x10,%esp
801002dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e5:	5b                   	pop    %ebx
801002e6:	5e                   	pop    %esi
801002e7:	5f                   	pop    %edi
801002e8:	5d                   	pop    %ebp
801002e9:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002ea:	8d 50 01             	lea    0x1(%eax),%edx
801002ed:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f3:	89 c2                	mov    %eax,%edx
801002f5:	83 e2 7f             	and    $0x7f,%edx
801002f8:	8a 92 80 ee 10 80    	mov    -0x7fef1180(%edx),%dl
801002fe:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100301:	80 fa 04             	cmp    $0x4,%dl
80100304:	74 12                	je     80100318 <consoleread+0xb4>
    *dst++ = c;
80100306:	8d 46 01             	lea    0x1(%esi),%eax
80100309:	88 16                	mov    %dl,(%esi)
    --n;
8010030b:	4b                   	dec    %ebx
    if(c == '\n')
8010030c:	83 f9 0a             	cmp    $0xa,%ecx
8010030f:	74 11                	je     80100322 <consoleread+0xbe>
    *dst++ = c;
80100311:	89 c6                	mov    %eax,%esi
80100313:	e9 76 ff ff ff       	jmp    8010028e <consoleread+0x2a>
      if(n < target){
80100318:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010031b:	73 05                	jae    80100322 <consoleread+0xbe>
        input.r--;
8010031d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
  release(&cons.lock);
80100322:	83 ec 0c             	sub    $0xc,%esp
80100325:	68 20 ef 10 80       	push   $0x8010ef20
8010032a:	e8 16 38 00 00       	call   80103b45 <release>
  ilock(ip);
8010032f:	89 3c 24             	mov    %edi,(%esp)
80100332:	e8 cf 11 00 00       	call   80101506 <ilock>
  return target - n;
80100337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033a:	29 d8                	sub    %ebx,%eax
8010033c:	83 c4 10             	add    $0x10,%esp
8010033f:	eb a1                	jmp    801002e2 <consoleread+0x7e>

80100341 <panic>:
{
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
80100344:	53                   	push   %ebx
80100345:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100348:	fa                   	cli    
  cons.locking = 0;
80100349:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100350:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100353:	e8 8b 1f 00 00       	call   801022e3 <lapicid>
80100358:	83 ec 08             	sub    $0x8,%esp
8010035b:	50                   	push   %eax
8010035c:	68 2d 67 10 80       	push   $0x8010672d
80100361:	e8 74 02 00 00       	call   801005da <cprintf>
  cprintf(s);
80100366:	83 c4 04             	add    $0x4,%esp
80100369:	ff 75 08             	push   0x8(%ebp)
8010036c:	e8 69 02 00 00       	call   801005da <cprintf>
  cprintf("\n");
80100371:	c7 04 24 d7 70 10 80 	movl   $0x801070d7,(%esp)
80100378:	e8 5d 02 00 00       	call   801005da <cprintf>
  getcallerpcs(&s, pcs);
8010037d:	83 c4 08             	add    $0x8,%esp
80100380:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100383:	50                   	push   %eax
80100384:	8d 45 08             	lea    0x8(%ebp),%eax
80100387:	50                   	push   %eax
80100388:	e8 37 36 00 00       	call   801039c4 <getcallerpcs>
  for(i=0; i<10; i++)
8010038d:	83 c4 10             	add    $0x10,%esp
80100390:	bb 00 00 00 00       	mov    $0x0,%ebx
80100395:	eb 15                	jmp    801003ac <panic+0x6b>
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
8010039e:	68 41 67 10 80       	push   $0x80106741
801003a3:	e8 32 02 00 00       	call   801005da <cprintf>
  for(i=0; i<10; i++)
801003a8:	43                   	inc    %ebx
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	83 fb 09             	cmp    $0x9,%ebx
801003af:	7e e6                	jle    80100397 <panic+0x56>
  panicked = 1; // freeze other CPU
801003b1:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003b8:	00 00 00 
  for(;;)
801003bb:	eb fe                	jmp    801003bb <panic+0x7a>

801003bd <cgaputc>:
{
801003bd:	55                   	push   %ebp
801003be:	89 e5                	mov    %esp,%ebp
801003c0:	57                   	push   %edi
801003c1:	56                   	push   %esi
801003c2:	53                   	push   %ebx
801003c3:	83 ec 0c             	sub    $0xc,%esp
801003c6:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003c8:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003cd:	b0 0e                	mov    $0xe,%al
801003cf:	89 fa                	mov    %edi,%edx
801003d1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d2:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003d7:	89 ca                	mov    %ecx,%edx
801003d9:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003da:	0f b6 f0             	movzbl %al,%esi
801003dd:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e0:	b0 0f                	mov    $0xf,%al
801003e2:	89 fa                	mov    %edi,%edx
801003e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e5:	89 ca                	mov    %ecx,%edx
801003e7:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003e8:	0f b6 c8             	movzbl %al,%ecx
801003eb:	09 f1                	or     %esi,%ecx
  if(c == '\n')
801003ed:	83 fb 0a             	cmp    $0xa,%ebx
801003f0:	74 5a                	je     8010044c <cgaputc+0x8f>
  else if(c == BACKSPACE){
801003f2:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801003f8:	74 62                	je     8010045c <cgaputc+0x9f>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801003fa:	0f b6 c3             	movzbl %bl,%eax
801003fd:	8d 59 01             	lea    0x1(%ecx),%ebx
80100400:	80 cc 07             	or     $0x7,%ah
80100403:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
8010040a:	80 
  if(pos < 0 || pos > 25*80)
8010040b:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100411:	77 56                	ja     80100469 <cgaputc+0xac>
  if((pos/80) >= 24){  // Scroll up.
80100413:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100419:	7f 5b                	jg     80100476 <cgaputc+0xb9>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100420:	b0 0e                	mov    $0xe,%al
80100422:	89 f2                	mov    %esi,%edx
80100424:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
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
  crt[pos] = ' ' | 0x0700;
8010043a:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100441:	80 20 07 
}
80100444:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100447:	5b                   	pop    %ebx
80100448:	5e                   	pop    %esi
80100449:	5f                   	pop    %edi
8010044a:	5d                   	pop    %ebp
8010044b:	c3                   	ret    
    pos += 80 - pos%80;
8010044c:	bb 50 00 00 00       	mov    $0x50,%ebx
80100451:	89 c8                	mov    %ecx,%eax
80100453:	99                   	cltd   
80100454:	f7 fb                	idiv   %ebx
80100456:	29 d3                	sub    %edx,%ebx
80100458:	01 cb                	add    %ecx,%ebx
8010045a:	eb af                	jmp    8010040b <cgaputc+0x4e>
    if(pos > 0) --pos;
8010045c:	85 c9                	test   %ecx,%ecx
8010045e:	7e 05                	jle    80100465 <cgaputc+0xa8>
80100460:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100463:	eb a6                	jmp    8010040b <cgaputc+0x4e>
  pos |= inb(CRTPORT+1);
80100465:	89 cb                	mov    %ecx,%ebx
80100467:	eb a2                	jmp    8010040b <cgaputc+0x4e>
    panic("pos under/overflow");
80100469:	83 ec 0c             	sub    $0xc,%esp
8010046c:	68 45 67 10 80       	push   $0x80106745
80100471:	e8 cb fe ff ff       	call   80100341 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100476:	83 ec 04             	sub    $0x4,%esp
80100479:	68 60 0e 00 00       	push   $0xe60
8010047e:	68 a0 80 0b 80       	push   $0x800b80a0
80100483:	68 00 80 0b 80       	push   $0x800b8000
80100488:	e8 7d 37 00 00       	call   80103c0a <memmove>
    pos -= 80;
8010048d:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100490:	b8 80 07 00 00       	mov    $0x780,%eax
80100495:	29 d8                	sub    %ebx,%eax
80100497:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
8010049e:	83 c4 0c             	add    $0xc,%esp
801004a1:	01 c0                	add    %eax,%eax
801004a3:	50                   	push   %eax
801004a4:	6a 00                	push   $0x0
801004a6:	52                   	push   %edx
801004a7:	e8 e0 36 00 00       	call   80103b8c <memset>
801004ac:	83 c4 10             	add    $0x10,%esp
801004af:	e9 67 ff ff ff       	jmp    8010041b <cgaputc+0x5e>

801004b4 <consputc>:
  if(panicked){
801004b4:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004bb:	74 03                	je     801004c0 <consputc+0xc>
  asm volatile("cli");
801004bd:	fa                   	cli    
    for(;;)
801004be:	eb fe                	jmp    801004be <consputc+0xa>
{
801004c0:	55                   	push   %ebp
801004c1:	89 e5                	mov    %esp,%ebp
801004c3:	53                   	push   %ebx
801004c4:	83 ec 04             	sub    $0x4,%esp
801004c7:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004c9:	3d 00 01 00 00       	cmp    $0x100,%eax
801004ce:	74 18                	je     801004e8 <consputc+0x34>
    uartputc(c);
801004d0:	83 ec 0c             	sub    $0xc,%esp
801004d3:	50                   	push   %eax
801004d4:	e8 52 4c 00 00       	call   8010512b <uartputc>
801004d9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004dc:	89 d8                	mov    %ebx,%eax
801004de:	e8 da fe ff ff       	call   801003bd <cgaputc>
}
801004e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801004e6:	c9                   	leave  
801004e7:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e8:	83 ec 0c             	sub    $0xc,%esp
801004eb:	6a 08                	push   $0x8
801004ed:	e8 39 4c 00 00       	call   8010512b <uartputc>
801004f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f9:	e8 2d 4c 00 00       	call   8010512b <uartputc>
801004fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100505:	e8 21 4c 00 00       	call   8010512b <uartputc>
8010050a:	83 c4 10             	add    $0x10,%esp
8010050d:	eb cd                	jmp    801004dc <consputc+0x28>

8010050f <printint>:
{
8010050f:	55                   	push   %ebp
80100510:	89 e5                	mov    %esp,%ebp
80100512:	57                   	push   %edi
80100513:	56                   	push   %esi
80100514:	53                   	push   %ebx
80100515:	83 ec 2c             	sub    $0x2c,%esp
80100518:	89 d6                	mov    %edx,%esi
8010051a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010051d:	85 c9                	test   %ecx,%ecx
8010051f:	74 0c                	je     8010052d <printint+0x1e>
80100521:	89 c7                	mov    %eax,%edi
80100523:	c1 ef 1f             	shr    $0x1f,%edi
80100526:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100529:	85 c0                	test   %eax,%eax
8010052b:	78 35                	js     80100562 <printint+0x53>
    x = xx;
8010052d:	89 c1                	mov    %eax,%ecx
  i = 0;
8010052f:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100534:	89 c8                	mov    %ecx,%eax
80100536:	ba 00 00 00 00       	mov    $0x0,%edx
8010053b:	f7 f6                	div    %esi
8010053d:	89 df                	mov    %ebx,%edi
8010053f:	43                   	inc    %ebx
80100540:	8a 92 70 67 10 80    	mov    -0x7fef9890(%edx),%dl
80100546:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
8010054a:	89 ca                	mov    %ecx,%edx
8010054c:	89 c1                	mov    %eax,%ecx
8010054e:	39 d6                	cmp    %edx,%esi
80100550:	76 e2                	jbe    80100534 <printint+0x25>
  if(sign)
80100552:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100556:	74 1a                	je     80100572 <printint+0x63>
    buf[i++] = '-';
80100558:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010055d:	8d 5f 02             	lea    0x2(%edi),%ebx
80100560:	eb 10                	jmp    80100572 <printint+0x63>
    x = -xx;
80100562:	f7 d8                	neg    %eax
80100564:	89 c1                	mov    %eax,%ecx
80100566:	eb c7                	jmp    8010052f <printint+0x20>
    consputc(buf[i]);
80100568:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010056d:	e8 42 ff ff ff       	call   801004b4 <consputc>
  while(--i >= 0)
80100572:	4b                   	dec    %ebx
80100573:	79 f3                	jns    80100568 <printint+0x59>
}
80100575:	83 c4 2c             	add    $0x2c,%esp
80100578:	5b                   	pop    %ebx
80100579:	5e                   	pop    %esi
8010057a:	5f                   	pop    %edi
8010057b:	5d                   	pop    %ebp
8010057c:	c3                   	ret    

8010057d <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010057d:	55                   	push   %ebp
8010057e:	89 e5                	mov    %esp,%ebp
80100580:	57                   	push   %edi
80100581:	56                   	push   %esi
80100582:	53                   	push   %ebx
80100583:	83 ec 18             	sub    $0x18,%esp
80100586:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100589:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010058c:	ff 75 08             	push   0x8(%ebp)
8010058f:	e8 32 10 00 00       	call   801015c6 <iunlock>
  acquire(&cons.lock);
80100594:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010059b:	e8 40 35 00 00       	call   80103ae0 <acquire>
  for(i = 0; i < n; i++)
801005a0:	83 c4 10             	add    $0x10,%esp
801005a3:	bb 00 00 00 00       	mov    $0x0,%ebx
801005a8:	eb 0a                	jmp    801005b4 <consolewrite+0x37>
    consputc(buf[i] & 0xff);
801005aa:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005ae:	e8 01 ff ff ff       	call   801004b4 <consputc>
  for(i = 0; i < n; i++)
801005b3:	43                   	inc    %ebx
801005b4:	39 f3                	cmp    %esi,%ebx
801005b6:	7c f2                	jl     801005aa <consolewrite+0x2d>
  release(&cons.lock);
801005b8:	83 ec 0c             	sub    $0xc,%esp
801005bb:	68 20 ef 10 80       	push   $0x8010ef20
801005c0:	e8 80 35 00 00       	call   80103b45 <release>
  ilock(ip);
801005c5:	83 c4 04             	add    $0x4,%esp
801005c8:	ff 75 08             	push   0x8(%ebp)
801005cb:	e8 36 0f 00 00       	call   80101506 <ilock>

  return n;
}
801005d0:	89 f0                	mov    %esi,%eax
801005d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    

801005da <cprintf>:
{
801005da:	55                   	push   %ebp
801005db:	89 e5                	mov    %esp,%ebp
801005dd:	57                   	push   %edi
801005de:	56                   	push   %esi
801005df:	53                   	push   %ebx
801005e0:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005e3:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005eb:	85 c0                	test   %eax,%eax
801005ed:	75 10                	jne    801005ff <cprintf+0x25>
  if (fmt == 0)
801005ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801005f3:	74 1c                	je     80100611 <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
801005f5:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005f8:	be 00 00 00 00       	mov    $0x0,%esi
801005fd:	eb 25                	jmp    80100624 <cprintf+0x4a>
    acquire(&cons.lock);
801005ff:	83 ec 0c             	sub    $0xc,%esp
80100602:	68 20 ef 10 80       	push   $0x8010ef20
80100607:	e8 d4 34 00 00       	call   80103ae0 <acquire>
8010060c:	83 c4 10             	add    $0x10,%esp
8010060f:	eb de                	jmp    801005ef <cprintf+0x15>
    panic("null fmt");
80100611:	83 ec 0c             	sub    $0xc,%esp
80100614:	68 5f 67 10 80       	push   $0x8010675f
80100619:	e8 23 fd ff ff       	call   80100341 <panic>
      consputc(c);
8010061e:	e8 91 fe ff ff       	call   801004b4 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100623:	46                   	inc    %esi
80100624:	8b 55 08             	mov    0x8(%ebp),%edx
80100627:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
8010062b:	85 c0                	test   %eax,%eax
8010062d:	0f 84 ac 00 00 00    	je     801006df <cprintf+0x105>
    if(c != '%'){
80100633:	83 f8 25             	cmp    $0x25,%eax
80100636:	75 e6                	jne    8010061e <cprintf+0x44>
    c = fmt[++i] & 0xff;
80100638:	46                   	inc    %esi
80100639:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
8010063d:	85 db                	test   %ebx,%ebx
8010063f:	0f 84 9a 00 00 00    	je     801006df <cprintf+0x105>
    switch(c){
80100645:	83 fb 70             	cmp    $0x70,%ebx
80100648:	74 2e                	je     80100678 <cprintf+0x9e>
8010064a:	7f 22                	jg     8010066e <cprintf+0x94>
8010064c:	83 fb 25             	cmp    $0x25,%ebx
8010064f:	74 69                	je     801006ba <cprintf+0xe0>
80100651:	83 fb 64             	cmp    $0x64,%ebx
80100654:	75 73                	jne    801006c9 <cprintf+0xef>
      printint(*argp++, 10, 1);
80100656:	8d 5f 04             	lea    0x4(%edi),%ebx
80100659:	8b 07                	mov    (%edi),%eax
8010065b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100660:	ba 0a 00 00 00       	mov    $0xa,%edx
80100665:	e8 a5 fe ff ff       	call   8010050f <printint>
8010066a:	89 df                	mov    %ebx,%edi
      break;
8010066c:	eb b5                	jmp    80100623 <cprintf+0x49>
    switch(c){
8010066e:	83 fb 73             	cmp    $0x73,%ebx
80100671:	74 1d                	je     80100690 <cprintf+0xb6>
80100673:	83 fb 78             	cmp    $0x78,%ebx
80100676:	75 51                	jne    801006c9 <cprintf+0xef>
      printint(*argp++, 16, 0);
80100678:	8d 5f 04             	lea    0x4(%edi),%ebx
8010067b:	8b 07                	mov    (%edi),%eax
8010067d:	b9 00 00 00 00       	mov    $0x0,%ecx
80100682:	ba 10 00 00 00       	mov    $0x10,%edx
80100687:	e8 83 fe ff ff       	call   8010050f <printint>
8010068c:	89 df                	mov    %ebx,%edi
      break;
8010068e:	eb 93                	jmp    80100623 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
80100690:	8d 47 04             	lea    0x4(%edi),%eax
80100693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100696:	8b 1f                	mov    (%edi),%ebx
80100698:	85 db                	test   %ebx,%ebx
8010069a:	75 10                	jne    801006ac <cprintf+0xd2>
        s = "(null)";
8010069c:	bb 58 67 10 80       	mov    $0x80106758,%ebx
801006a1:	eb 09                	jmp    801006ac <cprintf+0xd2>
        consputc(*s);
801006a3:	0f be c0             	movsbl %al,%eax
801006a6:	e8 09 fe ff ff       	call   801004b4 <consputc>
      for(; *s; s++)
801006ab:	43                   	inc    %ebx
801006ac:	8a 03                	mov    (%ebx),%al
801006ae:	84 c0                	test   %al,%al
801006b0:	75 f1                	jne    801006a3 <cprintf+0xc9>
      if((s = (char*)*argp++) == 0)
801006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006b5:	e9 69 ff ff ff       	jmp    80100623 <cprintf+0x49>
      consputc('%');
801006ba:	b8 25 00 00 00       	mov    $0x25,%eax
801006bf:	e8 f0 fd ff ff       	call   801004b4 <consputc>
      break;
801006c4:	e9 5a ff ff ff       	jmp    80100623 <cprintf+0x49>
      consputc('%');
801006c9:	b8 25 00 00 00       	mov    $0x25,%eax
801006ce:	e8 e1 fd ff ff       	call   801004b4 <consputc>
      consputc(c);
801006d3:	89 d8                	mov    %ebx,%eax
801006d5:	e8 da fd ff ff       	call   801004b4 <consputc>
      break;
801006da:	e9 44 ff ff ff       	jmp    80100623 <cprintf+0x49>
  if(locking)
801006df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801006e3:	75 08                	jne    801006ed <cprintf+0x113>
}
801006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e8:	5b                   	pop    %ebx
801006e9:	5e                   	pop    %esi
801006ea:	5f                   	pop    %edi
801006eb:	5d                   	pop    %ebp
801006ec:	c3                   	ret    
    release(&cons.lock);
801006ed:	83 ec 0c             	sub    $0xc,%esp
801006f0:	68 20 ef 10 80       	push   $0x8010ef20
801006f5:	e8 4b 34 00 00       	call   80103b45 <release>
801006fa:	83 c4 10             	add    $0x10,%esp
}
801006fd:	eb e6                	jmp    801006e5 <cprintf+0x10b>

801006ff <consoleintr>:
{
801006ff:	55                   	push   %ebp
80100700:	89 e5                	mov    %esp,%ebp
80100702:	57                   	push   %edi
80100703:	56                   	push   %esi
80100704:	53                   	push   %ebx
80100705:	83 ec 18             	sub    $0x18,%esp
80100708:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010070b:	68 20 ef 10 80       	push   $0x8010ef20
80100710:	e8 cb 33 00 00       	call   80103ae0 <acquire>
  while((c = getc()) >= 0){
80100715:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100718:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010071d:	eb 13                	jmp    80100732 <consoleintr+0x33>
    switch(c){
8010071f:	83 ff 08             	cmp    $0x8,%edi
80100722:	0f 84 d1 00 00 00    	je     801007f9 <consoleintr+0xfa>
80100728:	83 ff 10             	cmp    $0x10,%edi
8010072b:	75 25                	jne    80100752 <consoleintr+0x53>
8010072d:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100732:	ff d3                	call   *%ebx
80100734:	89 c7                	mov    %eax,%edi
80100736:	85 c0                	test   %eax,%eax
80100738:	0f 88 eb 00 00 00    	js     80100829 <consoleintr+0x12a>
    switch(c){
8010073e:	83 ff 15             	cmp    $0x15,%edi
80100741:	0f 84 8d 00 00 00    	je     801007d4 <consoleintr+0xd5>
80100747:	7e d6                	jle    8010071f <consoleintr+0x20>
80100749:	83 ff 7f             	cmp    $0x7f,%edi
8010074c:	0f 84 a7 00 00 00    	je     801007f9 <consoleintr+0xfa>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100752:	85 ff                	test   %edi,%edi
80100754:	74 dc                	je     80100732 <consoleintr+0x33>
80100756:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010075b:	89 c2                	mov    %eax,%edx
8010075d:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100763:	83 fa 7f             	cmp    $0x7f,%edx
80100766:	77 ca                	ja     80100732 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
80100768:	83 ff 0d             	cmp    $0xd,%edi
8010076b:	0f 84 ae 00 00 00    	je     8010081f <consoleintr+0x120>
        input.buf[input.e++ % INPUT_BUF] = c;
80100771:	8d 50 01             	lea    0x1(%eax),%edx
80100774:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
8010077a:	83 e0 7f             	and    $0x7f,%eax
8010077d:	89 f9                	mov    %edi,%ecx
8010077f:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
        consputc(c);
80100785:	89 f8                	mov    %edi,%eax
80100787:	e8 28 fd ff ff       	call   801004b4 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010078c:	83 ff 0a             	cmp    $0xa,%edi
8010078f:	74 15                	je     801007a6 <consoleintr+0xa7>
80100791:	83 ff 04             	cmp    $0x4,%edi
80100794:	74 10                	je     801007a6 <consoleintr+0xa7>
80100796:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010079b:	83 e8 80             	sub    $0xffffff80,%eax
8010079e:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801007a4:	75 8c                	jne    80100732 <consoleintr+0x33>
          input.w = input.e;
801007a6:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007ab:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801007b0:	83 ec 0c             	sub    $0xc,%esp
801007b3:	68 00 ef 10 80       	push   $0x8010ef00
801007b8:	e8 94 2f 00 00       	call   80103751 <wakeup>
801007bd:	83 c4 10             	add    $0x10,%esp
801007c0:	e9 6d ff ff ff       	jmp    80100732 <consoleintr+0x33>
        input.e--;
801007c5:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
801007ca:	b8 00 01 00 00       	mov    $0x100,%eax
801007cf:	e8 e0 fc ff ff       	call   801004b4 <consputc>
      while(input.e != input.w &&
801007d4:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007d9:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801007df:	0f 84 4d ff ff ff    	je     80100732 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007e5:	48                   	dec    %eax
801007e6:	89 c2                	mov    %eax,%edx
801007e8:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007eb:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801007f2:	75 d1                	jne    801007c5 <consoleintr+0xc6>
801007f4:	e9 39 ff ff ff       	jmp    80100732 <consoleintr+0x33>
      if(input.e != input.w){
801007f9:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007fe:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100804:	0f 84 28 ff ff ff    	je     80100732 <consoleintr+0x33>
        input.e--;
8010080a:	48                   	dec    %eax
8010080b:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
80100810:	b8 00 01 00 00       	mov    $0x100,%eax
80100815:	e8 9a fc ff ff       	call   801004b4 <consputc>
8010081a:	e9 13 ff ff ff       	jmp    80100732 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010081f:	bf 0a 00 00 00       	mov    $0xa,%edi
80100824:	e9 48 ff ff ff       	jmp    80100771 <consoleintr+0x72>
  release(&cons.lock);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 20 ef 10 80       	push   $0x8010ef20
80100831:	e8 0f 33 00 00       	call   80103b45 <release>
  if(doprocdump) {
80100836:	83 c4 10             	add    $0x10,%esp
80100839:	85 f6                	test   %esi,%esi
8010083b:	75 08                	jne    80100845 <consoleintr+0x146>
}
8010083d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100840:	5b                   	pop    %ebx
80100841:	5e                   	pop    %esi
80100842:	5f                   	pop    %edi
80100843:	5d                   	pop    %ebp
80100844:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100845:	e8 a4 2f 00 00       	call   801037ee <procdump>
}
8010084a:	eb f1                	jmp    8010083d <consoleintr+0x13e>

8010084c <consoleinit>:

void
consoleinit(void)
{
8010084c:	55                   	push   %ebp
8010084d:	89 e5                	mov    %esp,%ebp
8010084f:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100852:	68 68 67 10 80       	push   $0x80106768
80100857:	68 20 ef 10 80       	push   $0x8010ef20
8010085c:	e8 48 31 00 00       	call   801039a9 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100861:	c7 05 0c f9 10 80 7d 	movl   $0x8010057d,0x8010f90c
80100868:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010086b:	c7 05 08 f9 10 80 64 	movl   $0x80100264,0x8010f908
80100872:	02 10 80 
  cons.locking = 1;
80100875:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
8010087c:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
8010087f:	83 c4 08             	add    $0x8,%esp
80100882:	6a 00                	push   $0x0
80100884:	6a 01                	push   $0x1
80100886:	e8 5a 16 00 00       	call   80101ee5 <ioapicenable>
}
8010088b:	83 c4 10             	add    $0x10,%esp
8010088e:	c9                   	leave  
8010088f:	c3                   	ret    

80100890 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100890:	55                   	push   %ebp
80100891:	89 e5                	mov    %esp,%ebp
80100893:	57                   	push   %edi
80100894:	56                   	push   %esi
80100895:	53                   	push   %ebx
80100896:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010089c:	e8 7c 28 00 00       	call   8010311d <myproc>
801008a1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008a7:	e8 30 1e 00 00       	call   801026dc <begin_op>

  if((ip = namei(path)) == 0){
801008ac:	83 ec 0c             	sub    $0xc,%esp
801008af:	ff 75 08             	push   0x8(%ebp)
801008b2:	e8 b3 12 00 00       	call   80101b6a <namei>
801008b7:	83 c4 10             	add    $0x10,%esp
801008ba:	85 c0                	test   %eax,%eax
801008bc:	74 56                	je     80100914 <exec+0x84>
801008be:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	50                   	push   %eax
801008c4:	e8 3d 0c 00 00       	call   80101506 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008c9:	6a 34                	push   $0x34
801008cb:	6a 00                	push   $0x0
801008cd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801008d3:	50                   	push   %eax
801008d4:	53                   	push   %ebx
801008d5:	e8 19 0e 00 00       	call   801016f3 <readi>
801008da:	83 c4 20             	add    $0x20,%esp
801008dd:	83 f8 34             	cmp    $0x34,%eax
801008e0:	75 0c                	jne    801008ee <exec+0x5e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801008e2:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801008e9:	45 4c 46 
801008ec:	74 42                	je     80100930 <exec+0xa0>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir, 1);
  if(ip){
801008ee:	85 db                	test   %ebx,%ebx
801008f0:	0f 84 cc 02 00 00    	je     80100bc2 <exec+0x332>
    iunlockput(ip);
801008f6:	83 ec 0c             	sub    $0xc,%esp
801008f9:	53                   	push   %ebx
801008fa:	e8 aa 0d 00 00       	call   801016a9 <iunlockput>
    end_op();
801008ff:	e8 54 1e 00 00       	call   80102758 <end_op>
80100904:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010090c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010090f:	5b                   	pop    %ebx
80100910:	5e                   	pop    %esi
80100911:	5f                   	pop    %edi
80100912:	5d                   	pop    %ebp
80100913:	c3                   	ret    
    end_op();
80100914:	e8 3f 1e 00 00       	call   80102758 <end_op>
    cprintf("exec: fail\n");
80100919:	83 ec 0c             	sub    $0xc,%esp
8010091c:	68 81 67 10 80       	push   $0x80106781
80100921:	e8 b4 fc ff ff       	call   801005da <cprintf>
    return -1;
80100926:	83 c4 10             	add    $0x10,%esp
80100929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010092e:	eb dc                	jmp    8010090c <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
80100930:	e8 66 5b 00 00       	call   8010649b <setupkvm>
80100935:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010093b:	85 c0                	test   %eax,%eax
8010093d:	0f 84 14 01 00 00    	je     80100a57 <exec+0x1c7>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100943:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
80100949:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100950:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100953:	be 00 00 00 00       	mov    $0x0,%esi
80100958:	eb 04                	jmp    8010095e <exec+0xce>
8010095a:	46                   	inc    %esi
8010095b:	8d 47 20             	lea    0x20(%edi),%eax
8010095e:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100965:	39 f2                	cmp    %esi,%edx
80100967:	0f 8e a1 00 00 00    	jle    80100a0e <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
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
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
8010098b:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100992:	75 c6                	jne    8010095a <exec+0xca>
80100994:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010099a:	85 c0                	test   %eax,%eax
8010099c:	74 bc                	je     8010095a <exec+0xca>
    if(ph.memsz < ph.filesz)
8010099e:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009a4:	0f 82 ad 00 00 00    	jb     80100a57 <exec+0x1c7>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009aa:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009b0:	0f 82 a1 00 00 00    	jb     80100a57 <exec+0x1c7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009b6:	83 ec 04             	sub    $0x4,%esp
801009b9:	50                   	push   %eax
801009ba:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801009c0:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009c6:	e8 6d 59 00 00       	call   80106338 <allocuvm>
801009cb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009d1:	83 c4 10             	add    $0x10,%esp
801009d4:	85 c0                	test   %eax,%eax
801009d6:	74 7f                	je     80100a57 <exec+0x1c7>
    if(ph.vaddr % PGSIZE != 0)
801009d8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801009de:	a9 ff 0f 00 00       	test   $0xfff,%eax
801009e3:	75 72                	jne    80100a57 <exec+0x1c7>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801009e5:	83 ec 0c             	sub    $0xc,%esp
801009e8:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
801009ee:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
801009f4:	53                   	push   %ebx
801009f5:	50                   	push   %eax
801009f6:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801009fc:	e8 0d 58 00 00       	call   8010620e <loaduvm>
80100a01:	83 c4 20             	add    $0x20,%esp
80100a04:	85 c0                	test   %eax,%eax
80100a06:	0f 89 4e ff ff ff    	jns    8010095a <exec+0xca>
80100a0c:	eb 49                	jmp    80100a57 <exec+0x1c7>
  iunlockput(ip);
80100a0e:	83 ec 0c             	sub    $0xc,%esp
80100a11:	53                   	push   %ebx
80100a12:	e8 92 0c 00 00       	call   801016a9 <iunlockput>
  end_op();
80100a17:	e8 3c 1d 00 00       	call   80102758 <end_op>
  sz = PGROUNDUP(sz);
80100a1c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a22:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a2c:	83 c4 0c             	add    $0xc,%esp
80100a2f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a35:	52                   	push   %edx
80100a36:	50                   	push   %eax
80100a37:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100a3d:	57                   	push   %edi
80100a3e:	e8 f5 58 00 00       	call   80106338 <allocuvm>
80100a43:	89 c6                	mov    %eax,%esi
80100a45:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a4b:	83 c4 10             	add    $0x10,%esp
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	75 26                	jne    80100a78 <exec+0x1e8>
  ip = 0;
80100a52:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a57:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a5d:	85 c0                	test   %eax,%eax
80100a5f:	0f 84 89 fe ff ff    	je     801008ee <exec+0x5e>
    freevm(pgdir, 1);
80100a65:	83 ec 08             	sub    $0x8,%esp
80100a68:	6a 01                	push   $0x1
80100a6a:	50                   	push   %eax
80100a6b:	e8 b5 59 00 00       	call   80106425 <freevm>
80100a70:	83 c4 10             	add    $0x10,%esp
80100a73:	e9 76 fe ff ff       	jmp    801008ee <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100a78:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a7e:	83 ec 08             	sub    $0x8,%esp
80100a81:	50                   	push   %eax
80100a82:	57                   	push   %edi
80100a83:	e8 9a 5a 00 00       	call   80106522 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100a88:	83 c4 10             	add    $0x10,%esp
80100a8b:	bf 00 00 00 00       	mov    $0x0,%edi
80100a90:	eb 08                	jmp    80100a9a <exec+0x20a>
    ustack[3+argc] = sp;
80100a92:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100a99:	47                   	inc    %edi
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100aa0:	8b 03                	mov    (%ebx),%eax
80100aa2:	85 c0                	test   %eax,%eax
80100aa4:	74 43                	je     80100ae9 <exec+0x259>
    if(argc >= MAXARG)
80100aa6:	83 ff 1f             	cmp    $0x1f,%edi
80100aa9:	0f 87 09 01 00 00    	ja     80100bb8 <exec+0x328>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100aaf:	83 ec 0c             	sub    $0xc,%esp
80100ab2:	50                   	push   %eax
80100ab3:	e8 7c 32 00 00       	call   80103d34 <strlen>
80100ab8:	29 c6                	sub    %eax,%esi
80100aba:	4e                   	dec    %esi
80100abb:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100abe:	83 c4 04             	add    $0x4,%esp
80100ac1:	ff 33                	push   (%ebx)
80100ac3:	e8 6c 32 00 00       	call   80103d34 <strlen>
80100ac8:	40                   	inc    %eax
80100ac9:	50                   	push   %eax
80100aca:	ff 33                	push   (%ebx)
80100acc:	56                   	push   %esi
80100acd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ad3:	e8 9a 5b 00 00       	call   80106672 <copyout>
80100ad8:	83 c4 20             	add    $0x20,%esp
80100adb:	85 c0                	test   %eax,%eax
80100add:	79 b3                	jns    80100a92 <exec+0x202>
  ip = 0;
80100adf:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ae4:	e9 6e ff ff ff       	jmp    80100a57 <exec+0x1c7>
  ustack[3+argc] = 0;
80100ae9:	89 f1                	mov    %esi,%ecx
80100aeb:	89 c3                	mov    %eax,%ebx
80100aed:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100af4:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100af8:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100aff:	ff ff ff 
  ustack[1] = argc;
80100b02:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b08:	8d 14 bd 04 00 00 00 	lea    0x4(,%edi,4),%edx
80100b0f:	89 f0                	mov    %esi,%eax
80100b11:	29 d0                	sub    %edx,%eax
80100b13:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b19:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b20:	29 c1                	sub    %eax,%ecx
80100b22:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b24:	50                   	push   %eax
80100b25:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b2b:	50                   	push   %eax
80100b2c:	51                   	push   %ecx
80100b2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b33:	e8 3a 5b 00 00       	call   80106672 <copyout>
80100b38:	83 c4 10             	add    $0x10,%esp
80100b3b:	85 c0                	test   %eax,%eax
80100b3d:	0f 88 14 ff ff ff    	js     80100a57 <exec+0x1c7>
  for(last=s=path; *s; s++)
80100b43:	8b 55 08             	mov    0x8(%ebp),%edx
80100b46:	89 d0                	mov    %edx,%eax
80100b48:	eb 01                	jmp    80100b4b <exec+0x2bb>
80100b4a:	40                   	inc    %eax
80100b4b:	8a 08                	mov    (%eax),%cl
80100b4d:	84 c9                	test   %cl,%cl
80100b4f:	74 0a                	je     80100b5b <exec+0x2cb>
    if(*s == '/')
80100b51:	80 f9 2f             	cmp    $0x2f,%cl
80100b54:	75 f4                	jne    80100b4a <exec+0x2ba>
      last = s+1;
80100b56:	8d 50 01             	lea    0x1(%eax),%edx
80100b59:	eb ef                	jmp    80100b4a <exec+0x2ba>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b5b:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b61:	89 f8                	mov    %edi,%eax
80100b63:	83 c0 6c             	add    $0x6c,%eax
80100b66:	83 ec 04             	sub    $0x4,%esp
80100b69:	6a 10                	push   $0x10
80100b6b:	52                   	push   %edx
80100b6c:	50                   	push   %eax
80100b6d:	e8 86 31 00 00       	call   80103cf8 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100b72:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100b75:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100b7b:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100b7e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100b84:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100b86:	8b 47 18             	mov    0x18(%edi),%eax
80100b89:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100b8f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100b92:	8b 47 18             	mov    0x18(%edi),%eax
80100b95:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100b98:	89 3c 24             	mov    %edi,(%esp)
80100b9b:	e8 aa 54 00 00       	call   8010604a <switchuvm>
  freevm(oldpgdir, 1);
80100ba0:	83 c4 08             	add    $0x8,%esp
80100ba3:	6a 01                	push   $0x1
80100ba5:	53                   	push   %ebx
80100ba6:	e8 7a 58 00 00       	call   80106425 <freevm>
  return 0;
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	b8 00 00 00 00       	mov    $0x0,%eax
80100bb3:	e9 54 fd ff ff       	jmp    8010090c <exec+0x7c>
  ip = 0;
80100bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bbd:	e9 95 fe ff ff       	jmp    80100a57 <exec+0x1c7>
  return -1;
80100bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc7:	e9 40 fd ff ff       	jmp    8010090c <exec+0x7c>

80100bcc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100bcc:	55                   	push   %ebp
80100bcd:	89 e5                	mov    %esp,%ebp
80100bcf:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100bd2:	68 8d 67 10 80       	push   $0x8010678d
80100bd7:	68 60 ef 10 80       	push   $0x8010ef60
80100bdc:	e8 c8 2d 00 00       	call   801039a9 <initlock>
}
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	c9                   	leave  
80100be5:	c3                   	ret    

80100be6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100be6:	55                   	push   %ebp
80100be7:	89 e5                	mov    %esp,%ebp
80100be9:	53                   	push   %ebx
80100bea:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100bed:	68 60 ef 10 80       	push   $0x8010ef60
80100bf2:	e8 e9 2e 00 00       	call   80103ae0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100bff:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c05:	73 29                	jae    80100c30 <filealloc+0x4a>
    if(f->ref == 0){
80100c07:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c0b:	74 05                	je     80100c12 <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c0d:	83 c3 18             	add    $0x18,%ebx
80100c10:	eb ed                	jmp    80100bff <filealloc+0x19>
      f->ref = 1;
80100c12:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c19:	83 ec 0c             	sub    $0xc,%esp
80100c1c:	68 60 ef 10 80       	push   $0x8010ef60
80100c21:	e8 1f 2f 00 00       	call   80103b45 <release>
      return f;
80100c26:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c29:	89 d8                	mov    %ebx,%eax
80100c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c2e:	c9                   	leave  
80100c2f:	c3                   	ret    
  release(&ftable.lock);
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	68 60 ef 10 80       	push   $0x8010ef60
80100c38:	e8 08 2f 00 00       	call   80103b45 <release>
  return 0;
80100c3d:	83 c4 10             	add    $0x10,%esp
80100c40:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c45:	eb e2                	jmp    80100c29 <filealloc+0x43>

80100c47 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c47:	55                   	push   %ebp
80100c48:	89 e5                	mov    %esp,%ebp
80100c4a:	53                   	push   %ebx
80100c4b:	83 ec 10             	sub    $0x10,%esp
80100c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c51:	68 60 ef 10 80       	push   $0x8010ef60
80100c56:	e8 85 2e 00 00       	call   80103ae0 <acquire>
  if(f->ref < 1)
80100c5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	85 c0                	test   %eax,%eax
80100c63:	7e 18                	jle    80100c7d <filedup+0x36>
    panic("filedup");
  f->ref++;
80100c65:	40                   	inc    %eax
80100c66:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100c69:	83 ec 0c             	sub    $0xc,%esp
80100c6c:	68 60 ef 10 80       	push   $0x8010ef60
80100c71:	e8 cf 2e 00 00       	call   80103b45 <release>
  return f;
}
80100c76:	89 d8                	mov    %ebx,%eax
80100c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7b:	c9                   	leave  
80100c7c:	c3                   	ret    
    panic("filedup");
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	68 94 67 10 80       	push   $0x80106794
80100c85:	e8 b7 f6 ff ff       	call   80100341 <panic>

80100c8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100c8a:	55                   	push   %ebp
80100c8b:	89 e5                	mov    %esp,%ebp
80100c8d:	57                   	push   %edi
80100c8e:	56                   	push   %esi
80100c8f:	53                   	push   %ebx
80100c90:	83 ec 38             	sub    $0x38,%esp
80100c93:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100c96:	68 60 ef 10 80       	push   $0x8010ef60
80100c9b:	e8 40 2e 00 00       	call   80103ae0 <acquire>
  if(f->ref < 1)
80100ca0:	8b 43 04             	mov    0x4(%ebx),%eax
80100ca3:	83 c4 10             	add    $0x10,%esp
80100ca6:	85 c0                	test   %eax,%eax
80100ca8:	7e 58                	jle    80100d02 <fileclose+0x78>
    panic("fileclose");
  if(--f->ref > 0){
80100caa:	48                   	dec    %eax
80100cab:	89 43 04             	mov    %eax,0x4(%ebx)
80100cae:	85 c0                	test   %eax,%eax
80100cb0:	7f 5d                	jg     80100d0f <fileclose+0x85>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100cb2:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cb5:	b9 06 00 00 00       	mov    $0x6,%ecx
80100cba:	89 de                	mov    %ebx,%esi
80100cbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100cbe:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100cc5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100ccb:	83 ec 0c             	sub    $0xc,%esp
80100cce:	68 60 ef 10 80       	push   $0x8010ef60
80100cd3:	e8 6d 2e 00 00       	call   80103b45 <release>

  if(ff.type == FD_PIPE)
80100cd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100cdb:	83 c4 10             	add    $0x10,%esp
80100cde:	83 f8 01             	cmp    $0x1,%eax
80100ce1:	74 44                	je     80100d27 <fileclose+0x9d>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ce3:	83 f8 02             	cmp    $0x2,%eax
80100ce6:	75 37                	jne    80100d1f <fileclose+0x95>
    begin_op();
80100ce8:	e8 ef 19 00 00       	call   801026dc <begin_op>
    iput(ff.ip);
80100ced:	83 ec 0c             	sub    $0xc,%esp
80100cf0:	ff 75 e0             	push   -0x20(%ebp)
80100cf3:	e8 13 09 00 00       	call   8010160b <iput>
    end_op();
80100cf8:	e8 5b 1a 00 00       	call   80102758 <end_op>
80100cfd:	83 c4 10             	add    $0x10,%esp
80100d00:	eb 1d                	jmp    80100d1f <fileclose+0x95>
    panic("fileclose");
80100d02:	83 ec 0c             	sub    $0xc,%esp
80100d05:	68 9c 67 10 80       	push   $0x8010679c
80100d0a:	e8 32 f6 ff ff       	call   80100341 <panic>
    release(&ftable.lock);
80100d0f:	83 ec 0c             	sub    $0xc,%esp
80100d12:	68 60 ef 10 80       	push   $0x8010ef60
80100d17:	e8 29 2e 00 00       	call   80103b45 <release>
    return;
80100d1c:	83 c4 10             	add    $0x10,%esp
  }
}
80100d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d22:	5b                   	pop    %ebx
80100d23:	5e                   	pop    %esi
80100d24:	5f                   	pop    %edi
80100d25:	5d                   	pop    %ebp
80100d26:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d27:	83 ec 08             	sub    $0x8,%esp
80100d2a:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d2e:	50                   	push   %eax
80100d2f:	ff 75 dc             	push   -0x24(%ebp)
80100d32:	e8 0a 20 00 00       	call   80102d41 <pipeclose>
80100d37:	83 c4 10             	add    $0x10,%esp
80100d3a:	eb e3                	jmp    80100d1f <fileclose+0x95>

80100d3c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d3c:	55                   	push   %ebp
80100d3d:	89 e5                	mov    %esp,%ebp
80100d3f:	53                   	push   %ebx
80100d40:	83 ec 04             	sub    $0x4,%esp
80100d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d46:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d49:	75 31                	jne    80100d7c <filestat+0x40>
    ilock(f->ip);
80100d4b:	83 ec 0c             	sub    $0xc,%esp
80100d4e:	ff 73 10             	push   0x10(%ebx)
80100d51:	e8 b0 07 00 00       	call   80101506 <ilock>
    stati(f->ip, st);
80100d56:	83 c4 08             	add    $0x8,%esp
80100d59:	ff 75 0c             	push   0xc(%ebp)
80100d5c:	ff 73 10             	push   0x10(%ebx)
80100d5f:	e8 65 09 00 00       	call   801016c9 <stati>
    iunlock(f->ip);
80100d64:	83 c4 04             	add    $0x4,%esp
80100d67:	ff 73 10             	push   0x10(%ebx)
80100d6a:	e8 57 08 00 00       	call   801015c6 <iunlock>
    return 0;
80100d6f:	83 c4 10             	add    $0x10,%esp
80100d72:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
  return -1;
80100d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d81:	eb f4                	jmp    80100d77 <filestat+0x3b>

80100d83 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100d83:	55                   	push   %ebp
80100d84:	89 e5                	mov    %esp,%ebp
80100d86:	56                   	push   %esi
80100d87:	53                   	push   %ebx
80100d88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100d8b:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100d8f:	74 70                	je     80100e01 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100d91:	8b 03                	mov    (%ebx),%eax
80100d93:	83 f8 01             	cmp    $0x1,%eax
80100d96:	74 44                	je     80100ddc <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100d98:	83 f8 02             	cmp    $0x2,%eax
80100d9b:	75 57                	jne    80100df4 <fileread+0x71>
    ilock(f->ip);
80100d9d:	83 ec 0c             	sub    $0xc,%esp
80100da0:	ff 73 10             	push   0x10(%ebx)
80100da3:	e8 5e 07 00 00       	call   80101506 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100da8:	ff 75 10             	push   0x10(%ebp)
80100dab:	ff 73 14             	push   0x14(%ebx)
80100dae:	ff 75 0c             	push   0xc(%ebp)
80100db1:	ff 73 10             	push   0x10(%ebx)
80100db4:	e8 3a 09 00 00       	call   801016f3 <readi>
80100db9:	89 c6                	mov    %eax,%esi
80100dbb:	83 c4 20             	add    $0x20,%esp
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	7e 03                	jle    80100dc5 <fileread+0x42>
      f->off += r;
80100dc2:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	ff 73 10             	push   0x10(%ebx)
80100dcb:	e8 f6 07 00 00       	call   801015c6 <iunlock>
    return r;
80100dd0:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100dd3:	89 f0                	mov    %esi,%eax
80100dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100dd8:	5b                   	pop    %ebx
80100dd9:	5e                   	pop    %esi
80100dda:	5d                   	pop    %ebp
80100ddb:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ddc:	83 ec 04             	sub    $0x4,%esp
80100ddf:	ff 75 10             	push   0x10(%ebp)
80100de2:	ff 75 0c             	push   0xc(%ebp)
80100de5:	ff 73 0c             	push   0xc(%ebx)
80100de8:	e8 a2 20 00 00       	call   80102e8f <piperead>
80100ded:	89 c6                	mov    %eax,%esi
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	eb df                	jmp    80100dd3 <fileread+0x50>
  panic("fileread");
80100df4:	83 ec 0c             	sub    $0xc,%esp
80100df7:	68 a6 67 10 80       	push   $0x801067a6
80100dfc:	e8 40 f5 ff ff       	call   80100341 <panic>
    return -1;
80100e01:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e06:	eb cb                	jmp    80100dd3 <fileread+0x50>

80100e08 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e08:	55                   	push   %ebp
80100e09:	89 e5                	mov    %esp,%ebp
80100e0b:	57                   	push   %edi
80100e0c:	56                   	push   %esi
80100e0d:	53                   	push   %ebx
80100e0e:	83 ec 1c             	sub    $0x1c,%esp
80100e11:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e14:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e18:	0f 84 cc 00 00 00    	je     80100eea <filewrite+0xe2>
    return -1;
  if(f->type == FD_PIPE)
80100e1e:	8b 06                	mov    (%esi),%eax
80100e20:	83 f8 01             	cmp    $0x1,%eax
80100e23:	74 10                	je     80100e35 <filewrite+0x2d>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e25:	83 f8 02             	cmp    $0x2,%eax
80100e28:	0f 85 af 00 00 00    	jne    80100edd <filewrite+0xd5>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e2e:	bf 00 00 00 00       	mov    $0x0,%edi
80100e33:	eb 67                	jmp    80100e9c <filewrite+0x94>
    return pipewrite(f->pipe, addr, n);
80100e35:	83 ec 04             	sub    $0x4,%esp
80100e38:	ff 75 10             	push   0x10(%ebp)
80100e3b:	ff 75 0c             	push   0xc(%ebp)
80100e3e:	ff 76 0c             	push   0xc(%esi)
80100e41:	e8 87 1f 00 00       	call   80102dcd <pipewrite>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	e9 82 00 00 00       	jmp    80100ed0 <filewrite+0xc8>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100e4e:	e8 89 18 00 00       	call   801026dc <begin_op>
      ilock(f->ip);
80100e53:	83 ec 0c             	sub    $0xc,%esp
80100e56:	ff 76 10             	push   0x10(%esi)
80100e59:	e8 a8 06 00 00       	call   80101506 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
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
        f->off += r;
80100e7b:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
80100e81:	ff 76 10             	push   0x10(%esi)
80100e84:	e8 3d 07 00 00       	call   801015c6 <iunlock>
      end_op();
80100e89:	e8 ca 18 00 00       	call   80102758 <end_op>

      if(r < 0)
80100e8e:	83 c4 10             	add    $0x10,%esp
80100e91:	85 db                	test   %ebx,%ebx
80100e93:	78 31                	js     80100ec6 <filewrite+0xbe>
        break;
      if(r != n1)
80100e95:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100e98:	75 1f                	jne    80100eb9 <filewrite+0xb1>
        panic("short filewrite");
      i += r;
80100e9a:	01 df                	add    %ebx,%edi
    while(i < n){
80100e9c:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100e9f:	7d 25                	jge    80100ec6 <filewrite+0xbe>
      int n1 = n - i;
80100ea1:	8b 45 10             	mov    0x10(%ebp),%eax
80100ea4:	29 f8                	sub    %edi,%eax
80100ea6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100ea9:	3d 00 06 00 00       	cmp    $0x600,%eax
80100eae:	7e 9e                	jle    80100e4e <filewrite+0x46>
        n1 = max;
80100eb0:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100eb7:	eb 95                	jmp    80100e4e <filewrite+0x46>
        panic("short filewrite");
80100eb9:	83 ec 0c             	sub    $0xc,%esp
80100ebc:	68 af 67 10 80       	push   $0x801067af
80100ec1:	e8 7b f4 ff ff       	call   80100341 <panic>
    }
    return i == n ? n : -1;
80100ec6:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ec9:	74 0d                	je     80100ed8 <filewrite+0xd0>
80100ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
80100ed7:	c3                   	ret    
    return i == n ? n : -1;
80100ed8:	8b 45 10             	mov    0x10(%ebp),%eax
80100edb:	eb f3                	jmp    80100ed0 <filewrite+0xc8>
  panic("filewrite");
80100edd:	83 ec 0c             	sub    $0xc,%esp
80100ee0:	68 b5 67 10 80       	push   $0x801067b5
80100ee5:	e8 57 f4 ff ff       	call   80100341 <panic>
    return -1;
80100eea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eef:	eb df                	jmp    80100ed0 <filewrite+0xc8>

80100ef1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100ef1:	55                   	push   %ebp
80100ef2:	89 e5                	mov    %esp,%ebp
80100ef4:	57                   	push   %edi
80100ef5:	56                   	push   %esi
80100ef6:	53                   	push   %ebx
80100ef7:	83 ec 0c             	sub    $0xc,%esp
80100efa:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100efc:	eb 01                	jmp    80100eff <skipelem+0xe>
    path++;
80100efe:	40                   	inc    %eax
  while(*path == '/')
80100eff:	8a 10                	mov    (%eax),%dl
80100f01:	80 fa 2f             	cmp    $0x2f,%dl
80100f04:	74 f8                	je     80100efe <skipelem+0xd>
  if(*path == 0)
80100f06:	84 d2                	test   %dl,%dl
80100f08:	74 4e                	je     80100f58 <skipelem+0x67>
80100f0a:	89 c3                	mov    %eax,%ebx
80100f0c:	eb 01                	jmp    80100f0f <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f0e:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f0f:	8a 13                	mov    (%ebx),%dl
80100f11:	80 fa 2f             	cmp    $0x2f,%dl
80100f14:	74 04                	je     80100f1a <skipelem+0x29>
80100f16:	84 d2                	test   %dl,%dl
80100f18:	75 f4                	jne    80100f0e <skipelem+0x1d>
  len = path - s;
80100f1a:	89 df                	mov    %ebx,%edi
80100f1c:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f1e:	83 ff 0d             	cmp    $0xd,%edi
80100f21:	7e 11                	jle    80100f34 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f23:	83 ec 04             	sub    $0x4,%esp
80100f26:	6a 0e                	push   $0xe
80100f28:	50                   	push   %eax
80100f29:	56                   	push   %esi
80100f2a:	e8 db 2c 00 00       	call   80103c0a <memmove>
80100f2f:	83 c4 10             	add    $0x10,%esp
80100f32:	eb 15                	jmp    80100f49 <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	57                   	push   %edi
80100f38:	50                   	push   %eax
80100f39:	56                   	push   %esi
80100f3a:	e8 cb 2c 00 00       	call   80103c0a <memmove>
    name[len] = 0;
80100f3f:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f43:	83 c4 10             	add    $0x10,%esp
80100f46:	eb 01                	jmp    80100f49 <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100f48:	43                   	inc    %ebx
  while(*path == '/')
80100f49:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100f4c:	74 fa                	je     80100f48 <skipelem+0x57>
  return path;
}
80100f4e:	89 d8                	mov    %ebx,%eax
80100f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f53:	5b                   	pop    %ebx
80100f54:	5e                   	pop    %esi
80100f55:	5f                   	pop    %edi
80100f56:	5d                   	pop    %ebp
80100f57:	c3                   	ret    
    return 0;
80100f58:	bb 00 00 00 00       	mov    $0x0,%ebx
80100f5d:	eb ef                	jmp    80100f4e <skipelem+0x5d>

80100f5f <bzero>:
{
80100f5f:	55                   	push   %ebp
80100f60:	89 e5                	mov    %esp,%ebp
80100f62:	53                   	push   %ebx
80100f63:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100f66:	52                   	push   %edx
80100f67:	50                   	push   %eax
80100f68:	e8 fd f1 ff ff       	call   8010016a <bread>
80100f6d:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100f6f:	8d 40 5c             	lea    0x5c(%eax),%eax
80100f72:	83 c4 0c             	add    $0xc,%esp
80100f75:	68 00 02 00 00       	push   $0x200
80100f7a:	6a 00                	push   $0x0
80100f7c:	50                   	push   %eax
80100f7d:	e8 0a 2c 00 00       	call   80103b8c <memset>
  log_write(bp);
80100f82:	89 1c 24             	mov    %ebx,(%esp)
80100f85:	e8 7b 18 00 00       	call   80102805 <log_write>
  brelse(bp);
80100f8a:	89 1c 24             	mov    %ebx,(%esp)
80100f8d:	e8 41 f2 ff ff       	call   801001d3 <brelse>
}
80100f92:	83 c4 10             	add    $0x10,%esp
80100f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f98:	c9                   	leave  
80100f99:	c3                   	ret    

80100f9a <balloc>:
{
80100f9a:	55                   	push   %ebp
80100f9b:	89 e5                	mov    %esp,%ebp
80100f9d:	57                   	push   %edi
80100f9e:	56                   	push   %esi
80100f9f:	53                   	push   %ebx
80100fa0:	83 ec 1c             	sub    $0x1c,%esp
80100fa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80100fa6:	be 00 00 00 00       	mov    $0x0,%esi
80100fab:	eb 5b                	jmp    80101008 <balloc+0x6e>
    bp = bread(dev, BBLOCK(b, sb));
80100fad:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80100fb3:	eb 61                	jmp    80101016 <balloc+0x7c>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80100fb5:	c1 fa 03             	sar    $0x3,%edx
80100fb8:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100fbb:	8a 4c 17 5c          	mov    0x5c(%edi,%edx,1),%cl
80100fbf:	0f b6 f9             	movzbl %cl,%edi
80100fc2:	85 7d e4             	test   %edi,-0x1c(%ebp)
80100fc5:	74 7e                	je     80101045 <balloc+0xab>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80100fc7:	40                   	inc    %eax
80100fc8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80100fcd:	7f 25                	jg     80100ff4 <balloc+0x5a>
80100fcf:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80100fd2:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
80100fd8:	73 1a                	jae    80100ff4 <balloc+0x5a>
      m = 1 << (bi % 8);
80100fda:	89 c1                	mov    %eax,%ecx
80100fdc:	83 e1 07             	and    $0x7,%ecx
80100fdf:	ba 01 00 00 00       	mov    $0x1,%edx
80100fe4:	d3 e2                	shl    %cl,%edx
80100fe6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80100fe9:	89 c2                	mov    %eax,%edx
80100feb:	85 c0                	test   %eax,%eax
80100fed:	79 c6                	jns    80100fb5 <balloc+0x1b>
80100fef:	8d 50 07             	lea    0x7(%eax),%edx
80100ff2:	eb c1                	jmp    80100fb5 <balloc+0x1b>
    brelse(bp);
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	ff 75 e0             	push   -0x20(%ebp)
80100ffa:	e8 d4 f1 ff ff       	call   801001d3 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80100fff:	81 c6 00 10 00 00    	add    $0x1000,%esi
80101005:	83 c4 10             	add    $0x10,%esp
80101008:	39 35 b4 15 11 80    	cmp    %esi,0x801115b4
8010100e:	76 28                	jbe    80101038 <balloc+0x9e>
    bp = bread(dev, BBLOCK(b, sb));
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
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	b8 00 00 00 00       	mov    $0x0,%eax
80101036:	eb 90                	jmp    80100fc8 <balloc+0x2e>
  panic("balloc: out of blocks");
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	68 bf 67 10 80       	push   $0x801067bf
80101040:	e8 fc f2 ff ff       	call   80100341 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101045:	0b 4d e4             	or     -0x1c(%ebp),%ecx
80101048:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010104b:	88 4c 16 5c          	mov    %cl,0x5c(%esi,%edx,1)
        log_write(bp);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	56                   	push   %esi
80101053:	e8 ad 17 00 00       	call   80102805 <log_write>
        brelse(bp);
80101058:	89 34 24             	mov    %esi,(%esp)
8010105b:	e8 73 f1 ff ff       	call   801001d3 <brelse>
        bzero(dev, b + bi);
80101060:	89 da                	mov    %ebx,%edx
80101062:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101065:	e8 f5 fe ff ff       	call   80100f5f <bzero>
}
8010106a:	89 d8                	mov    %ebx,%eax
8010106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106f:	5b                   	pop    %ebx
80101070:	5e                   	pop    %esi
80101071:	5f                   	pop    %edi
80101072:	5d                   	pop    %ebp
80101073:	c3                   	ret    

80101074 <bmap>:
{
80101074:	55                   	push   %ebp
80101075:	89 e5                	mov    %esp,%ebp
80101077:	57                   	push   %edi
80101078:	56                   	push   %esi
80101079:	53                   	push   %ebx
8010107a:	83 ec 1c             	sub    $0x1c,%esp
8010107d:	89 c3                	mov    %eax,%ebx
8010107f:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
80101081:	83 fa 0b             	cmp    $0xb,%edx
80101084:	76 45                	jbe    801010cb <bmap+0x57>
  bn -= NDIRECT;
80101086:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101089:	83 fe 7f             	cmp    $0x7f,%esi
8010108c:	77 7f                	ja     8010110d <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
8010108e:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101094:	85 c0                	test   %eax,%eax
80101096:	74 4a                	je     801010e2 <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101098:	83 ec 08             	sub    $0x8,%esp
8010109b:	50                   	push   %eax
8010109c:	ff 33                	push   (%ebx)
8010109e:	e8 c7 f0 ff ff       	call   8010016a <bread>
801010a3:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801010a5:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801010a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010ac:	8b 30                	mov    (%eax),%esi
801010ae:	83 c4 10             	add    $0x10,%esp
801010b1:	85 f6                	test   %esi,%esi
801010b3:	74 3c                	je     801010f1 <bmap+0x7d>
    brelse(bp);
801010b5:	83 ec 0c             	sub    $0xc,%esp
801010b8:	57                   	push   %edi
801010b9:	e8 15 f1 ff ff       	call   801001d3 <brelse>
    return addr;
801010be:	83 c4 10             	add    $0x10,%esp
}
801010c1:	89 f0                	mov    %esi,%eax
801010c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801010cb:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801010cf:	85 f6                	test   %esi,%esi
801010d1:	75 ee                	jne    801010c1 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801010d3:	8b 00                	mov    (%eax),%eax
801010d5:	e8 c0 fe ff ff       	call   80100f9a <balloc>
801010da:	89 c6                	mov    %eax,%esi
801010dc:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
801010e0:	eb df                	jmp    801010c1 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801010e2:	8b 03                	mov    (%ebx),%eax
801010e4:	e8 b1 fe ff ff       	call   80100f9a <balloc>
801010e9:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801010ef:	eb a7                	jmp    80101098 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801010f1:	8b 03                	mov    (%ebx),%eax
801010f3:	e8 a2 fe ff ff       	call   80100f9a <balloc>
801010f8:	89 c6                	mov    %eax,%esi
801010fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010fd:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	57                   	push   %edi
80101103:	e8 fd 16 00 00       	call   80102805 <log_write>
80101108:	83 c4 10             	add    $0x10,%esp
8010110b:	eb a8                	jmp    801010b5 <bmap+0x41>
  panic("bmap: out of range");
8010110d:	83 ec 0c             	sub    $0xc,%esp
80101110:	68 d5 67 10 80       	push   $0x801067d5
80101115:	e8 27 f2 ff ff       	call   80100341 <panic>

8010111a <iget>:
{
8010111a:	55                   	push   %ebp
8010111b:	89 e5                	mov    %esp,%ebp
8010111d:	57                   	push   %edi
8010111e:	56                   	push   %esi
8010111f:	53                   	push   %ebx
80101120:	83 ec 28             	sub    $0x28,%esp
80101123:	89 c7                	mov    %eax,%edi
80101125:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101128:	68 60 f9 10 80       	push   $0x8010f960
8010112d:	e8 ae 29 00 00       	call   80103ae0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101132:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101135:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010113a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
8010113f:	eb 0a                	jmp    8010114b <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101141:	85 f6                	test   %esi,%esi
80101143:	74 39                	je     8010117e <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101145:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010114b:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101151:	73 33                	jae    80101186 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101153:	8b 43 08             	mov    0x8(%ebx),%eax
80101156:	85 c0                	test   %eax,%eax
80101158:	7e e7                	jle    80101141 <iget+0x27>
8010115a:	39 3b                	cmp    %edi,(%ebx)
8010115c:	75 e3                	jne    80101141 <iget+0x27>
8010115e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101161:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101164:	75 db                	jne    80101141 <iget+0x27>
      ip->ref++;
80101166:	40                   	inc    %eax
80101167:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010116a:	83 ec 0c             	sub    $0xc,%esp
8010116d:	68 60 f9 10 80       	push   $0x8010f960
80101172:	e8 ce 29 00 00       	call   80103b45 <release>
      return ip;
80101177:	83 c4 10             	add    $0x10,%esp
8010117a:	89 de                	mov    %ebx,%esi
8010117c:	eb 32                	jmp    801011b0 <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010117e:	85 c0                	test   %eax,%eax
80101180:	75 c3                	jne    80101145 <iget+0x2b>
      empty = ip;
80101182:	89 de                	mov    %ebx,%esi
80101184:	eb bf                	jmp    80101145 <iget+0x2b>
  if(empty == 0)
80101186:	85 f6                	test   %esi,%esi
80101188:	74 30                	je     801011ba <iget+0xa0>
  ip->dev = dev;
8010118a:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010118c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010118f:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101192:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101199:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 60 f9 10 80       	push   $0x8010f960
801011a8:	e8 98 29 00 00       	call   80103b45 <release>
  return ip;
801011ad:	83 c4 10             	add    $0x10,%esp
}
801011b0:	89 f0                	mov    %esi,%eax
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	5b                   	pop    %ebx
801011b6:	5e                   	pop    %esi
801011b7:	5f                   	pop    %edi
801011b8:	5d                   	pop    %ebp
801011b9:	c3                   	ret    
    panic("iget: no inodes");
801011ba:	83 ec 0c             	sub    $0xc,%esp
801011bd:	68 e8 67 10 80       	push   $0x801067e8
801011c2:	e8 7a f1 ff ff       	call   80100341 <panic>

801011c7 <readsb>:
{
801011c7:	55                   	push   %ebp
801011c8:	89 e5                	mov    %esp,%ebp
801011ca:	53                   	push   %ebx
801011cb:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801011ce:	6a 01                	push   $0x1
801011d0:	ff 75 08             	push   0x8(%ebp)
801011d3:	e8 92 ef ff ff       	call   8010016a <bread>
801011d8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801011da:	8d 40 5c             	lea    0x5c(%eax),%eax
801011dd:	83 c4 0c             	add    $0xc,%esp
801011e0:	6a 1c                	push   $0x1c
801011e2:	50                   	push   %eax
801011e3:	ff 75 0c             	push   0xc(%ebp)
801011e6:	e8 1f 2a 00 00       	call   80103c0a <memmove>
  brelse(bp);
801011eb:	89 1c 24             	mov    %ebx,(%esp)
801011ee:	e8 e0 ef ff ff       	call   801001d3 <brelse>
}
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011f9:	c9                   	leave  
801011fa:	c3                   	ret    

801011fb <bfree>:
{
801011fb:	55                   	push   %ebp
801011fc:	89 e5                	mov    %esp,%ebp
801011fe:	56                   	push   %esi
801011ff:	53                   	push   %ebx
80101200:	89 c3                	mov    %eax,%ebx
80101202:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	68 b4 15 11 80       	push   $0x801115b4
8010120c:	50                   	push   %eax
8010120d:	e8 b5 ff ff ff       	call   801011c7 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101212:	89 f0                	mov    %esi,%eax
80101214:	c1 e8 0c             	shr    $0xc,%eax
80101217:	83 c4 08             	add    $0x8,%esp
8010121a:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101220:	50                   	push   %eax
80101221:	53                   	push   %ebx
80101222:	e8 43 ef ff ff       	call   8010016a <bread>
80101227:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101229:	89 f2                	mov    %esi,%edx
8010122b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
80101231:	89 f1                	mov    %esi,%ecx
80101233:	83 e1 07             	and    $0x7,%ecx
80101236:	b8 01 00 00 00       	mov    $0x1,%eax
8010123b:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
8010123d:	83 c4 10             	add    $0x10,%esp
80101240:	c1 fa 03             	sar    $0x3,%edx
80101243:	8a 4c 13 5c          	mov    0x5c(%ebx,%edx,1),%cl
80101247:	0f b6 f1             	movzbl %cl,%esi
8010124a:	85 c6                	test   %eax,%esi
8010124c:	74 23                	je     80101271 <bfree+0x76>
  bp->data[bi/8] &= ~m;
8010124e:	f7 d0                	not    %eax
80101250:	21 c8                	and    %ecx,%eax
80101252:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
  log_write(bp);
80101256:	83 ec 0c             	sub    $0xc,%esp
80101259:	53                   	push   %ebx
8010125a:	e8 a6 15 00 00       	call   80102805 <log_write>
  brelse(bp);
8010125f:	89 1c 24             	mov    %ebx,(%esp)
80101262:	e8 6c ef ff ff       	call   801001d3 <brelse>
}
80101267:	83 c4 10             	add    $0x10,%esp
8010126a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010126d:	5b                   	pop    %ebx
8010126e:	5e                   	pop    %esi
8010126f:	5d                   	pop    %ebp
80101270:	c3                   	ret    
    panic("freeing free block");
80101271:	83 ec 0c             	sub    $0xc,%esp
80101274:	68 f8 67 10 80       	push   $0x801067f8
80101279:	e8 c3 f0 ff ff       	call   80100341 <panic>

8010127e <iinit>:
{
8010127e:	55                   	push   %ebp
8010127f:	89 e5                	mov    %esp,%ebp
80101281:	53                   	push   %ebx
80101282:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101285:	68 0b 68 10 80       	push   $0x8010680b
8010128a:	68 60 f9 10 80       	push   $0x8010f960
8010128f:	e8 15 27 00 00       	call   801039a9 <initlock>
  for(i = 0; i < NINODE; i++) {
80101294:	83 c4 10             	add    $0x10,%esp
80101297:	bb 00 00 00 00       	mov    $0x0,%ebx
8010129c:	eb 1f                	jmp    801012bd <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
8010129e:	83 ec 08             	sub    $0x8,%esp
801012a1:	68 12 68 10 80       	push   $0x80106812
801012a6:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
801012a9:	89 d0                	mov    %edx,%eax
801012ab:	c1 e0 04             	shl    $0x4,%eax
801012ae:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
801012b3:	50                   	push   %eax
801012b4:	e8 e5 25 00 00       	call   8010389e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801012b9:	43                   	inc    %ebx
801012ba:	83 c4 10             	add    $0x10,%esp
801012bd:	83 fb 31             	cmp    $0x31,%ebx
801012c0:	7e dc                	jle    8010129e <iinit+0x20>
  readsb(dev, &sb);
801012c2:	83 ec 08             	sub    $0x8,%esp
801012c5:	68 b4 15 11 80       	push   $0x801115b4
801012ca:	ff 75 08             	push   0x8(%ebp)
801012cd:	e8 f5 fe ff ff       	call   801011c7 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801012d2:	ff 35 cc 15 11 80    	push   0x801115cc
801012d8:	ff 35 c8 15 11 80    	push   0x801115c8
801012de:	ff 35 c4 15 11 80    	push   0x801115c4
801012e4:	ff 35 c0 15 11 80    	push   0x801115c0
801012ea:	ff 35 bc 15 11 80    	push   0x801115bc
801012f0:	ff 35 b8 15 11 80    	push   0x801115b8
801012f6:	ff 35 b4 15 11 80    	push   0x801115b4
801012fc:	68 78 68 10 80       	push   $0x80106878
80101301:	e8 d4 f2 ff ff       	call   801005da <cprintf>
}
80101306:	83 c4 30             	add    $0x30,%esp
80101309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010130c:	c9                   	leave  
8010130d:	c3                   	ret    

8010130e <ialloc>:
{
8010130e:	55                   	push   %ebp
8010130f:	89 e5                	mov    %esp,%ebp
80101311:	57                   	push   %edi
80101312:	56                   	push   %esi
80101313:	53                   	push   %ebx
80101314:	83 ec 1c             	sub    $0x1c,%esp
80101317:	8b 45 0c             	mov    0xc(%ebp),%eax
8010131a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010131d:	bb 01 00 00 00       	mov    $0x1,%ebx
80101322:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101325:	39 1d bc 15 11 80    	cmp    %ebx,0x801115bc
8010132b:	76 3d                	jbe    8010136a <ialloc+0x5c>
    bp = bread(dev, IBLOCK(inum, sb));
8010132d:	89 d8                	mov    %ebx,%eax
8010132f:	c1 e8 03             	shr    $0x3,%eax
80101332:	83 ec 08             	sub    $0x8,%esp
80101335:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010133b:	50                   	push   %eax
8010133c:	ff 75 08             	push   0x8(%ebp)
8010133f:	e8 26 ee ff ff       	call   8010016a <bread>
80101344:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101346:	89 d8                	mov    %ebx,%eax
80101348:	83 e0 07             	and    $0x7,%eax
8010134b:	c1 e0 06             	shl    $0x6,%eax
8010134e:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	66 83 3f 00          	cmpw   $0x0,(%edi)
80101359:	74 1c                	je     80101377 <ialloc+0x69>
    brelse(bp);
8010135b:	83 ec 0c             	sub    $0xc,%esp
8010135e:	56                   	push   %esi
8010135f:	e8 6f ee ff ff       	call   801001d3 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101364:	43                   	inc    %ebx
80101365:	83 c4 10             	add    $0x10,%esp
80101368:	eb b8                	jmp    80101322 <ialloc+0x14>
  panic("ialloc: no inodes");
8010136a:	83 ec 0c             	sub    $0xc,%esp
8010136d:	68 18 68 10 80       	push   $0x80106818
80101372:	e8 ca ef ff ff       	call   80100341 <panic>
      memset(dip, 0, sizeof(*dip));
80101377:	83 ec 04             	sub    $0x4,%esp
8010137a:	6a 40                	push   $0x40
8010137c:	6a 00                	push   $0x0
8010137e:	57                   	push   %edi
8010137f:	e8 08 28 00 00       	call   80103b8c <memset>
      dip->type = type;
80101384:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101387:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
8010138a:	89 34 24             	mov    %esi,(%esp)
8010138d:	e8 73 14 00 00       	call   80102805 <log_write>
      brelse(bp);
80101392:	89 34 24             	mov    %esi,(%esp)
80101395:	e8 39 ee ff ff       	call   801001d3 <brelse>
      return iget(dev, inum);
8010139a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010139d:	8b 45 08             	mov    0x8(%ebp),%eax
801013a0:	e8 75 fd ff ff       	call   8010111a <iget>
}
801013a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a8:	5b                   	pop    %ebx
801013a9:	5e                   	pop    %esi
801013aa:	5f                   	pop    %edi
801013ab:	5d                   	pop    %ebp
801013ac:	c3                   	ret    

801013ad <iupdate>:
{
801013ad:	55                   	push   %ebp
801013ae:	89 e5                	mov    %esp,%ebp
801013b0:	56                   	push   %esi
801013b1:	53                   	push   %ebx
801013b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801013b5:	8b 43 04             	mov    0x4(%ebx),%eax
801013b8:	c1 e8 03             	shr    $0x3,%eax
801013bb:	83 ec 08             	sub    $0x8,%esp
801013be:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801013c4:	50                   	push   %eax
801013c5:	ff 33                	push   (%ebx)
801013c7:	e8 9e ed ff ff       	call   8010016a <bread>
801013cc:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801013ce:	8b 43 04             	mov    0x4(%ebx),%eax
801013d1:	83 e0 07             	and    $0x7,%eax
801013d4:	c1 e0 06             	shl    $0x6,%eax
801013d7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801013db:	8b 53 50             	mov    0x50(%ebx),%edx
801013de:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801013e1:	66 8b 53 52          	mov    0x52(%ebx),%dx
801013e5:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801013e9:	8b 53 54             	mov    0x54(%ebx),%edx
801013ec:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801013f0:	66 8b 53 56          	mov    0x56(%ebx),%dx
801013f4:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801013f8:	8b 53 58             	mov    0x58(%ebx),%edx
801013fb:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801013fe:	83 c3 5c             	add    $0x5c,%ebx
80101401:	83 c0 0c             	add    $0xc,%eax
80101404:	83 c4 0c             	add    $0xc,%esp
80101407:	6a 34                	push   $0x34
80101409:	53                   	push   %ebx
8010140a:	50                   	push   %eax
8010140b:	e8 fa 27 00 00       	call   80103c0a <memmove>
  log_write(bp);
80101410:	89 34 24             	mov    %esi,(%esp)
80101413:	e8 ed 13 00 00       	call   80102805 <log_write>
  brelse(bp);
80101418:	89 34 24             	mov    %esi,(%esp)
8010141b:	e8 b3 ed ff ff       	call   801001d3 <brelse>
}
80101420:	83 c4 10             	add    $0x10,%esp
80101423:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101426:	5b                   	pop    %ebx
80101427:	5e                   	pop    %esi
80101428:	5d                   	pop    %ebp
80101429:	c3                   	ret    

8010142a <itrunc>:
{
8010142a:	55                   	push   %ebp
8010142b:	89 e5                	mov    %esp,%ebp
8010142d:	57                   	push   %edi
8010142e:	56                   	push   %esi
8010142f:	53                   	push   %ebx
80101430:	83 ec 1c             	sub    $0x1c,%esp
80101433:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
80101435:	bb 00 00 00 00       	mov    $0x0,%ebx
8010143a:	eb 01                	jmp    8010143d <itrunc+0x13>
8010143c:	43                   	inc    %ebx
8010143d:	83 fb 0b             	cmp    $0xb,%ebx
80101440:	7f 19                	jg     8010145b <itrunc+0x31>
    if(ip->addrs[i]){
80101442:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101446:	85 d2                	test   %edx,%edx
80101448:	74 f2                	je     8010143c <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
8010144a:	8b 06                	mov    (%esi),%eax
8010144c:	e8 aa fd ff ff       	call   801011fb <bfree>
      ip->addrs[i] = 0;
80101451:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101458:	00 
80101459:	eb e1                	jmp    8010143c <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
8010145b:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101461:	85 c0                	test   %eax,%eax
80101463:	75 1b                	jne    80101480 <itrunc+0x56>
  ip->size = 0;
80101465:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
8010146c:	83 ec 0c             	sub    $0xc,%esp
8010146f:	56                   	push   %esi
80101470:	e8 38 ff ff ff       	call   801013ad <iupdate>
}
80101475:	83 c4 10             	add    $0x10,%esp
80101478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147b:	5b                   	pop    %ebx
8010147c:	5e                   	pop    %esi
8010147d:	5f                   	pop    %edi
8010147e:	5d                   	pop    %ebp
8010147f:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	50                   	push   %eax
80101484:	ff 36                	push   (%esi)
80101486:	e8 df ec ff ff       	call   8010016a <bread>
8010148b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010148e:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
80101491:	83 c4 10             	add    $0x10,%esp
80101494:	bb 00 00 00 00       	mov    $0x0,%ebx
80101499:	eb 01                	jmp    8010149c <itrunc+0x72>
8010149b:	43                   	inc    %ebx
8010149c:	83 fb 7f             	cmp    $0x7f,%ebx
8010149f:	77 10                	ja     801014b1 <itrunc+0x87>
      if(a[j])
801014a1:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
801014a4:	85 d2                	test   %edx,%edx
801014a6:	74 f3                	je     8010149b <itrunc+0x71>
        bfree(ip->dev, a[j]);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 4c fd ff ff       	call   801011fb <bfree>
801014af:	eb ea                	jmp    8010149b <itrunc+0x71>
    brelse(bp);
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	ff 75 e4             	push   -0x1c(%ebp)
801014b7:	e8 17 ed ff ff       	call   801001d3 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801014bc:	8b 06                	mov    (%esi),%eax
801014be:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801014c4:	e8 32 fd ff ff       	call   801011fb <bfree>
    ip->addrs[NDIRECT] = 0;
801014c9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801014d0:	00 00 00 
801014d3:	83 c4 10             	add    $0x10,%esp
801014d6:	eb 8d                	jmp    80101465 <itrunc+0x3b>

801014d8 <idup>:
{
801014d8:	55                   	push   %ebp
801014d9:	89 e5                	mov    %esp,%ebp
801014db:	53                   	push   %ebx
801014dc:	83 ec 10             	sub    $0x10,%esp
801014df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801014e2:	68 60 f9 10 80       	push   $0x8010f960
801014e7:	e8 f4 25 00 00       	call   80103ae0 <acquire>
  ip->ref++;
801014ec:	8b 43 08             	mov    0x8(%ebx),%eax
801014ef:	40                   	inc    %eax
801014f0:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801014f3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801014fa:	e8 46 26 00 00       	call   80103b45 <release>
}
801014ff:	89 d8                	mov    %ebx,%eax
80101501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101504:	c9                   	leave  
80101505:	c3                   	ret    

80101506 <ilock>:
{
80101506:	55                   	push   %ebp
80101507:	89 e5                	mov    %esp,%ebp
80101509:	56                   	push   %esi
8010150a:	53                   	push   %ebx
8010150b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010150e:	85 db                	test   %ebx,%ebx
80101510:	74 22                	je     80101534 <ilock+0x2e>
80101512:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101516:	7e 1c                	jle    80101534 <ilock+0x2e>
  acquiresleep(&ip->lock);
80101518:	83 ec 0c             	sub    $0xc,%esp
8010151b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010151e:	50                   	push   %eax
8010151f:	e8 ad 23 00 00       	call   801038d1 <acquiresleep>
  if(ip->valid == 0){
80101524:	83 c4 10             	add    $0x10,%esp
80101527:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010152b:	74 14                	je     80101541 <ilock+0x3b>
}
8010152d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101530:	5b                   	pop    %ebx
80101531:	5e                   	pop    %esi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
    panic("ilock");
80101534:	83 ec 0c             	sub    $0xc,%esp
80101537:	68 2a 68 10 80       	push   $0x8010682a
8010153c:	e8 00 ee ff ff       	call   80100341 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101541:	8b 43 04             	mov    0x4(%ebx),%eax
80101544:	c1 e8 03             	shr    $0x3,%eax
80101547:	83 ec 08             	sub    $0x8,%esp
8010154a:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101550:	50                   	push   %eax
80101551:	ff 33                	push   (%ebx)
80101553:	e8 12 ec ff ff       	call   8010016a <bread>
80101558:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010155a:	8b 43 04             	mov    0x4(%ebx),%eax
8010155d:	83 e0 07             	and    $0x7,%eax
80101560:	c1 e0 06             	shl    $0x6,%eax
80101563:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101567:	8b 10                	mov    (%eax),%edx
80101569:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010156d:	66 8b 50 02          	mov    0x2(%eax),%dx
80101571:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101575:	8b 50 04             	mov    0x4(%eax),%edx
80101578:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010157c:	66 8b 50 06          	mov    0x6(%eax),%dx
80101580:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101584:	8b 50 08             	mov    0x8(%eax),%edx
80101587:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010158a:	83 c0 0c             	add    $0xc,%eax
8010158d:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101590:	83 c4 0c             	add    $0xc,%esp
80101593:	6a 34                	push   $0x34
80101595:	50                   	push   %eax
80101596:	52                   	push   %edx
80101597:	e8 6e 26 00 00       	call   80103c0a <memmove>
    brelse(bp);
8010159c:	89 34 24             	mov    %esi,(%esp)
8010159f:	e8 2f ec ff ff       	call   801001d3 <brelse>
    ip->valid = 1;
801015a4:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015ab:	83 c4 10             	add    $0x10,%esp
801015ae:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015b3:	0f 85 74 ff ff ff    	jne    8010152d <ilock+0x27>
      panic("ilock: no type");
801015b9:	83 ec 0c             	sub    $0xc,%esp
801015bc:	68 30 68 10 80       	push   $0x80106830
801015c1:	e8 7b ed ff ff       	call   80100341 <panic>

801015c6 <iunlock>:
{
801015c6:	55                   	push   %ebp
801015c7:	89 e5                	mov    %esp,%ebp
801015c9:	56                   	push   %esi
801015ca:	53                   	push   %ebx
801015cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015ce:	85 db                	test   %ebx,%ebx
801015d0:	74 2c                	je     801015fe <iunlock+0x38>
801015d2:	8d 73 0c             	lea    0xc(%ebx),%esi
801015d5:	83 ec 0c             	sub    $0xc,%esp
801015d8:	56                   	push   %esi
801015d9:	e8 7d 23 00 00       	call   8010395b <holdingsleep>
801015de:	83 c4 10             	add    $0x10,%esp
801015e1:	85 c0                	test   %eax,%eax
801015e3:	74 19                	je     801015fe <iunlock+0x38>
801015e5:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015e9:	7e 13                	jle    801015fe <iunlock+0x38>
  releasesleep(&ip->lock);
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	56                   	push   %esi
801015ef:	e8 2c 23 00 00       	call   80103920 <releasesleep>
}
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015fa:	5b                   	pop    %ebx
801015fb:	5e                   	pop    %esi
801015fc:	5d                   	pop    %ebp
801015fd:	c3                   	ret    
    panic("iunlock");
801015fe:	83 ec 0c             	sub    $0xc,%esp
80101601:	68 3f 68 10 80       	push   $0x8010683f
80101606:	e8 36 ed ff ff       	call   80100341 <panic>

8010160b <iput>:
{
8010160b:	55                   	push   %ebp
8010160c:	89 e5                	mov    %esp,%ebp
8010160e:	57                   	push   %edi
8010160f:	56                   	push   %esi
80101610:	53                   	push   %ebx
80101611:	83 ec 18             	sub    $0x18,%esp
80101614:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101617:	8d 73 0c             	lea    0xc(%ebx),%esi
8010161a:	56                   	push   %esi
8010161b:	e8 b1 22 00 00       	call   801038d1 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101620:	83 c4 10             	add    $0x10,%esp
80101623:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101627:	74 07                	je     80101630 <iput+0x25>
80101629:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010162e:	74 33                	je     80101663 <iput+0x58>
  releasesleep(&ip->lock);
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	56                   	push   %esi
80101634:	e8 e7 22 00 00       	call   80103920 <releasesleep>
  acquire(&icache.lock);
80101639:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101640:	e8 9b 24 00 00       	call   80103ae0 <acquire>
  ip->ref--;
80101645:	8b 43 08             	mov    0x8(%ebx),%eax
80101648:	48                   	dec    %eax
80101649:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010164c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101653:	e8 ed 24 00 00       	call   80103b45 <release>
}
80101658:	83 c4 10             	add    $0x10,%esp
8010165b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165e:	5b                   	pop    %ebx
8010165f:	5e                   	pop    %esi
80101660:	5f                   	pop    %edi
80101661:	5d                   	pop    %ebp
80101662:	c3                   	ret    
    acquire(&icache.lock);
80101663:	83 ec 0c             	sub    $0xc,%esp
80101666:	68 60 f9 10 80       	push   $0x8010f960
8010166b:	e8 70 24 00 00       	call   80103ae0 <acquire>
    int r = ip->ref;
80101670:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101673:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010167a:	e8 c6 24 00 00       	call   80103b45 <release>
    if(r == 1){
8010167f:	83 c4 10             	add    $0x10,%esp
80101682:	83 ff 01             	cmp    $0x1,%edi
80101685:	75 a9                	jne    80101630 <iput+0x25>
      itrunc(ip);
80101687:	89 d8                	mov    %ebx,%eax
80101689:	e8 9c fd ff ff       	call   8010142a <itrunc>
      ip->type = 0;
8010168e:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101694:	83 ec 0c             	sub    $0xc,%esp
80101697:	53                   	push   %ebx
80101698:	e8 10 fd ff ff       	call   801013ad <iupdate>
      ip->valid = 0;
8010169d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	eb 87                	jmp    80101630 <iput+0x25>

801016a9 <iunlockput>:
{
801016a9:	55                   	push   %ebp
801016aa:	89 e5                	mov    %esp,%ebp
801016ac:	53                   	push   %ebx
801016ad:	83 ec 10             	sub    $0x10,%esp
801016b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801016b3:	53                   	push   %ebx
801016b4:	e8 0d ff ff ff       	call   801015c6 <iunlock>
  iput(ip);
801016b9:	89 1c 24             	mov    %ebx,(%esp)
801016bc:	e8 4a ff ff ff       	call   8010160b <iput>
}
801016c1:	83 c4 10             	add    $0x10,%esp
801016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016c7:	c9                   	leave  
801016c8:	c3                   	ret    

801016c9 <stati>:
{
801016c9:	55                   	push   %ebp
801016ca:	89 e5                	mov    %esp,%ebp
801016cc:	8b 55 08             	mov    0x8(%ebp),%edx
801016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801016d2:	8b 0a                	mov    (%edx),%ecx
801016d4:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801016d7:	8b 4a 04             	mov    0x4(%edx),%ecx
801016da:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801016dd:	8b 4a 50             	mov    0x50(%edx),%ecx
801016e0:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801016e3:	66 8b 4a 56          	mov    0x56(%edx),%cx
801016e7:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801016eb:	8b 52 58             	mov    0x58(%edx),%edx
801016ee:	89 50 10             	mov    %edx,0x10(%eax)
}
801016f1:	5d                   	pop    %ebp
801016f2:	c3                   	ret    

801016f3 <readi>:
{
801016f3:	55                   	push   %ebp
801016f4:	89 e5                	mov    %esp,%ebp
801016f6:	57                   	push   %edi
801016f7:	56                   	push   %esi
801016f8:	53                   	push   %ebx
801016f9:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801016fc:	8b 45 08             	mov    0x8(%ebp),%eax
801016ff:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101704:	74 2c                	je     80101732 <readi+0x3f>
  if(off > ip->size || off + n < off)
80101706:	8b 45 08             	mov    0x8(%ebp),%eax
80101709:	8b 40 58             	mov    0x58(%eax),%eax
8010170c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010170f:	0f 82 d0 00 00 00    	jb     801017e5 <readi+0xf2>
80101715:	8b 55 10             	mov    0x10(%ebp),%edx
80101718:	03 55 14             	add    0x14(%ebp),%edx
8010171b:	0f 82 cb 00 00 00    	jb     801017ec <readi+0xf9>
  if(off + n > ip->size)
80101721:	39 d0                	cmp    %edx,%eax
80101723:	73 06                	jae    8010172b <readi+0x38>
    n = ip->size - off;
80101725:	2b 45 10             	sub    0x10(%ebp),%eax
80101728:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010172b:	bf 00 00 00 00       	mov    $0x0,%edi
80101730:	eb 55                	jmp    80101787 <readi+0x94>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101732:	66 8b 40 52          	mov    0x52(%eax),%ax
80101736:	66 83 f8 09          	cmp    $0x9,%ax
8010173a:	0f 87 97 00 00 00    	ja     801017d7 <readi+0xe4>
80101740:	98                   	cwtl   
80101741:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101748:	85 c0                	test   %eax,%eax
8010174a:	0f 84 8e 00 00 00    	je     801017de <readi+0xeb>
    return devsw[ip->major].read(ip, dst, n);
80101750:	83 ec 04             	sub    $0x4,%esp
80101753:	ff 75 14             	push   0x14(%ebp)
80101756:	ff 75 0c             	push   0xc(%ebp)
80101759:	ff 75 08             	push   0x8(%ebp)
8010175c:	ff d0                	call   *%eax
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	eb 6c                	jmp    801017cf <readi+0xdc>
    memmove(dst, bp->data + off%BSIZE, m);
80101763:	83 ec 04             	sub    $0x4,%esp
80101766:	53                   	push   %ebx
80101767:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
8010176b:	50                   	push   %eax
8010176c:	ff 75 0c             	push   0xc(%ebp)
8010176f:	e8 96 24 00 00       	call   80103c0a <memmove>
    brelse(bp);
80101774:	89 34 24             	mov    %esi,(%esp)
80101777:	e8 57 ea ff ff       	call   801001d3 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010177c:	01 df                	add    %ebx,%edi
8010177e:	01 5d 10             	add    %ebx,0x10(%ebp)
80101781:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101784:	83 c4 10             	add    $0x10,%esp
80101787:	39 7d 14             	cmp    %edi,0x14(%ebp)
8010178a:	76 40                	jbe    801017cc <readi+0xd9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
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
    m = min(n - tot, BSIZE - off%BSIZE);
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
  return n;
801017cc:	8b 45 14             	mov    0x14(%ebp),%eax
}
801017cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d2:	5b                   	pop    %ebx
801017d3:	5e                   	pop    %esi
801017d4:	5f                   	pop    %edi
801017d5:	5d                   	pop    %ebp
801017d6:	c3                   	ret    
      return -1;
801017d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017dc:	eb f1                	jmp    801017cf <readi+0xdc>
801017de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017e3:	eb ea                	jmp    801017cf <readi+0xdc>
    return -1;
801017e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017ea:	eb e3                	jmp    801017cf <readi+0xdc>
801017ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017f1:	eb dc                	jmp    801017cf <readi+0xdc>

801017f3 <writei>:
{
801017f3:	55                   	push   %ebp
801017f4:	89 e5                	mov    %esp,%ebp
801017f6:	57                   	push   %edi
801017f7:	56                   	push   %esi
801017f8:	53                   	push   %ebx
801017f9:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801017fc:	8b 45 08             	mov    0x8(%ebp),%eax
801017ff:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101804:	74 2c                	je     80101832 <writei+0x3f>
  if(off > ip->size || off + n < off)
80101806:	8b 45 08             	mov    0x8(%ebp),%eax
80101809:	8b 7d 10             	mov    0x10(%ebp),%edi
8010180c:	39 78 58             	cmp    %edi,0x58(%eax)
8010180f:	0f 82 fd 00 00 00    	jb     80101912 <writei+0x11f>
80101815:	89 f8                	mov    %edi,%eax
80101817:	03 45 14             	add    0x14(%ebp),%eax
8010181a:	0f 82 f9 00 00 00    	jb     80101919 <writei+0x126>
  if(off + n > MAXFILE*BSIZE)
80101820:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101825:	0f 87 f5 00 00 00    	ja     80101920 <writei+0x12d>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010182b:	bf 00 00 00 00       	mov    $0x0,%edi
80101830:	eb 60                	jmp    80101892 <writei+0x9f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101832:	66 8b 40 52          	mov    0x52(%eax),%ax
80101836:	66 83 f8 09          	cmp    $0x9,%ax
8010183a:	0f 87 c4 00 00 00    	ja     80101904 <writei+0x111>
80101840:	98                   	cwtl   
80101841:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101848:	85 c0                	test   %eax,%eax
8010184a:	0f 84 bb 00 00 00    	je     8010190b <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101850:	83 ec 04             	sub    $0x4,%esp
80101853:	ff 75 14             	push   0x14(%ebp)
80101856:	ff 75 0c             	push   0xc(%ebp)
80101859:	ff 75 08             	push   0x8(%ebp)
8010185c:	ff d0                	call   *%eax
8010185e:	83 c4 10             	add    $0x10,%esp
80101861:	e9 85 00 00 00       	jmp    801018eb <writei+0xf8>
    memmove(bp->data + off%BSIZE, src, m);
80101866:	83 ec 04             	sub    $0x4,%esp
80101869:	56                   	push   %esi
8010186a:	ff 75 0c             	push   0xc(%ebp)
8010186d:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
80101871:	50                   	push   %eax
80101872:	e8 93 23 00 00       	call   80103c0a <memmove>
    log_write(bp);
80101877:	89 1c 24             	mov    %ebx,(%esp)
8010187a:	e8 86 0f 00 00       	call   80102805 <log_write>
    brelse(bp);
8010187f:	89 1c 24             	mov    %ebx,(%esp)
80101882:	e8 4c e9 ff ff       	call   801001d3 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101887:	01 f7                	add    %esi,%edi
80101889:	01 75 10             	add    %esi,0x10(%ebp)
8010188c:	01 75 0c             	add    %esi,0xc(%ebp)
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101895:	73 40                	jae    801018d7 <writei+0xe4>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
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
    m = min(n - tot, BSIZE - off%BSIZE);
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
  if(n > 0 && off > ip->size){
801018d7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018db:	74 0b                	je     801018e8 <writei+0xf5>
801018dd:	8b 45 08             	mov    0x8(%ebp),%eax
801018e0:	8b 7d 10             	mov    0x10(%ebp),%edi
801018e3:	39 78 58             	cmp    %edi,0x58(%eax)
801018e6:	72 0b                	jb     801018f3 <writei+0x100>
  return n;
801018e8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ee:	5b                   	pop    %ebx
801018ef:	5e                   	pop    %esi
801018f0:	5f                   	pop    %edi
801018f1:	5d                   	pop    %ebp
801018f2:	c3                   	ret    
    ip->size = off;
801018f3:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	50                   	push   %eax
801018fa:	e8 ae fa ff ff       	call   801013ad <iupdate>
801018ff:	83 c4 10             	add    $0x10,%esp
80101902:	eb e4                	jmp    801018e8 <writei+0xf5>
      return -1;
80101904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101909:	eb e0                	jmp    801018eb <writei+0xf8>
8010190b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101910:	eb d9                	jmp    801018eb <writei+0xf8>
    return -1;
80101912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101917:	eb d2                	jmp    801018eb <writei+0xf8>
80101919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010191e:	eb cb                	jmp    801018eb <writei+0xf8>
    return -1;
80101920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101925:	eb c4                	jmp    801018eb <writei+0xf8>

80101927 <namecmp>:
{
80101927:	55                   	push   %ebp
80101928:	89 e5                	mov    %esp,%ebp
8010192a:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010192d:	6a 0e                	push   $0xe
8010192f:	ff 75 0c             	push   0xc(%ebp)
80101932:	ff 75 08             	push   0x8(%ebp)
80101935:	e8 3c 23 00 00       	call   80103c76 <strncmp>
}
8010193a:	c9                   	leave  
8010193b:	c3                   	ret    

8010193c <dirlookup>:
{
8010193c:	55                   	push   %ebp
8010193d:	89 e5                	mov    %esp,%ebp
8010193f:	57                   	push   %edi
80101940:	56                   	push   %esi
80101941:	53                   	push   %ebx
80101942:	83 ec 1c             	sub    $0x1c,%esp
80101945:	8b 75 08             	mov    0x8(%ebp),%esi
80101948:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
8010194b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101950:	75 07                	jne    80101959 <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101952:	bb 00 00 00 00       	mov    $0x0,%ebx
80101957:	eb 1d                	jmp    80101976 <dirlookup+0x3a>
    panic("dirlookup not DIR");
80101959:	83 ec 0c             	sub    $0xc,%esp
8010195c:	68 47 68 10 80       	push   $0x80106847
80101961:	e8 db e9 ff ff       	call   80100341 <panic>
      panic("dirlookup read");
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	68 59 68 10 80       	push   $0x80106859
8010196e:	e8 ce e9 ff ff       	call   80100341 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101973:	83 c3 10             	add    $0x10,%ebx
80101976:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101979:	76 48                	jbe    801019c3 <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010197b:	6a 10                	push   $0x10
8010197d:	53                   	push   %ebx
8010197e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101981:	50                   	push   %eax
80101982:	56                   	push   %esi
80101983:	e8 6b fd ff ff       	call   801016f3 <readi>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	83 f8 10             	cmp    $0x10,%eax
8010198e:	75 d6                	jne    80101966 <dirlookup+0x2a>
    if(de.inum == 0)
80101990:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101995:	74 dc                	je     80101973 <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
80101997:	83 ec 08             	sub    $0x8,%esp
8010199a:	8d 45 da             	lea    -0x26(%ebp),%eax
8010199d:	50                   	push   %eax
8010199e:	57                   	push   %edi
8010199f:	e8 83 ff ff ff       	call   80101927 <namecmp>
801019a4:	83 c4 10             	add    $0x10,%esp
801019a7:	85 c0                	test   %eax,%eax
801019a9:	75 c8                	jne    80101973 <dirlookup+0x37>
      if(poff)
801019ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801019af:	74 05                	je     801019b6 <dirlookup+0x7a>
        *poff = off;
801019b1:	8b 45 10             	mov    0x10(%ebp),%eax
801019b4:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
801019b6:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801019ba:	8b 06                	mov    (%esi),%eax
801019bc:	e8 59 f7 ff ff       	call   8010111a <iget>
801019c1:	eb 05                	jmp    801019c8 <dirlookup+0x8c>
  return 0;
801019c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801019c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cb:	5b                   	pop    %ebx
801019cc:	5e                   	pop    %esi
801019cd:	5f                   	pop    %edi
801019ce:	5d                   	pop    %ebp
801019cf:	c3                   	ret    

801019d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	89 c3                	mov    %eax,%ebx
801019db:	89 55 e0             	mov    %edx,-0x20(%ebp)
801019de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
801019e1:	80 38 2f             	cmpb   $0x2f,(%eax)
801019e4:	74 17                	je     801019fd <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801019e6:	e8 32 17 00 00       	call   8010311d <myproc>
801019eb:	83 ec 0c             	sub    $0xc,%esp
801019ee:	ff 70 68             	push   0x68(%eax)
801019f1:	e8 e2 fa ff ff       	call   801014d8 <idup>
801019f6:	89 c6                	mov    %eax,%esi
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	eb 53                	jmp    80101a50 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
801019fd:	ba 01 00 00 00       	mov    $0x1,%edx
80101a02:	b8 01 00 00 00       	mov    $0x1,%eax
80101a07:	e8 0e f7 ff ff       	call   8010111a <iget>
80101a0c:	89 c6                	mov    %eax,%esi
80101a0e:	eb 40                	jmp    80101a50 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	56                   	push   %esi
80101a14:	e8 90 fc ff ff       	call   801016a9 <iunlockput>
      return 0;
80101a19:	83 c4 10             	add    $0x10,%esp
80101a1c:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a21:	89 f0                	mov    %esi,%eax
80101a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101a2b:	83 ec 04             	sub    $0x4,%esp
80101a2e:	6a 00                	push   $0x0
80101a30:	ff 75 e4             	push   -0x1c(%ebp)
80101a33:	56                   	push   %esi
80101a34:	e8 03 ff ff ff       	call   8010193c <dirlookup>
80101a39:	89 c7                	mov    %eax,%edi
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	85 c0                	test   %eax,%eax
80101a40:	74 4a                	je     80101a8c <namex+0xbc>
    iunlockput(ip);
80101a42:	83 ec 0c             	sub    $0xc,%esp
80101a45:	56                   	push   %esi
80101a46:	e8 5e fc ff ff       	call   801016a9 <iunlockput>
80101a4b:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101a4e:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a53:	89 d8                	mov    %ebx,%eax
80101a55:	e8 97 f4 ff ff       	call   80100ef1 <skipelem>
80101a5a:	89 c3                	mov    %eax,%ebx
80101a5c:	85 c0                	test   %eax,%eax
80101a5e:	74 3c                	je     80101a9c <namex+0xcc>
    ilock(ip);
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	56                   	push   %esi
80101a64:	e8 9d fa ff ff       	call   80101506 <ilock>
    if(ip->type != T_DIR){
80101a69:	83 c4 10             	add    $0x10,%esp
80101a6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a71:	75 9d                	jne    80101a10 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101a73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101a77:	74 b2                	je     80101a2b <namex+0x5b>
80101a79:	80 3b 00             	cmpb   $0x0,(%ebx)
80101a7c:	75 ad                	jne    80101a2b <namex+0x5b>
      iunlock(ip);
80101a7e:	83 ec 0c             	sub    $0xc,%esp
80101a81:	56                   	push   %esi
80101a82:	e8 3f fb ff ff       	call   801015c6 <iunlock>
      return ip;
80101a87:	83 c4 10             	add    $0x10,%esp
80101a8a:	eb 95                	jmp    80101a21 <namex+0x51>
      iunlockput(ip);
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	56                   	push   %esi
80101a90:	e8 14 fc ff ff       	call   801016a9 <iunlockput>
      return 0;
80101a95:	83 c4 10             	add    $0x10,%esp
80101a98:	89 fe                	mov    %edi,%esi
80101a9a:	eb 85                	jmp    80101a21 <namex+0x51>
  if(nameiparent){
80101a9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101aa0:	0f 84 7b ff ff ff    	je     80101a21 <namex+0x51>
    iput(ip);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 5c fb ff ff       	call   8010160b <iput>
    return 0;
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	89 de                	mov    %ebx,%esi
80101ab4:	e9 68 ff ff ff       	jmp    80101a21 <namex+0x51>

80101ab9 <dirlink>:
{
80101ab9:	55                   	push   %ebp
80101aba:	89 e5                	mov    %esp,%ebp
80101abc:	57                   	push   %edi
80101abd:	56                   	push   %esi
80101abe:	53                   	push   %ebx
80101abf:	83 ec 20             	sub    $0x20,%esp
80101ac2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101ac5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ac8:	6a 00                	push   $0x0
80101aca:	57                   	push   %edi
80101acb:	53                   	push   %ebx
80101acc:	e8 6b fe ff ff       	call   8010193c <dirlookup>
80101ad1:	83 c4 10             	add    $0x10,%esp
80101ad4:	85 c0                	test   %eax,%eax
80101ad6:	75 2d                	jne    80101b05 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ad8:	b8 00 00 00 00       	mov    $0x0,%eax
80101add:	89 c6                	mov    %eax,%esi
80101adf:	39 43 58             	cmp    %eax,0x58(%ebx)
80101ae2:	76 41                	jbe    80101b25 <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ae4:	6a 10                	push   $0x10
80101ae6:	50                   	push   %eax
80101ae7:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101aea:	50                   	push   %eax
80101aeb:	53                   	push   %ebx
80101aec:	e8 02 fc ff ff       	call   801016f3 <readi>
80101af1:	83 c4 10             	add    $0x10,%esp
80101af4:	83 f8 10             	cmp    $0x10,%eax
80101af7:	75 1f                	jne    80101b18 <dirlink+0x5f>
    if(de.inum == 0)
80101af9:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101afe:	74 25                	je     80101b25 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b00:	8d 46 10             	lea    0x10(%esi),%eax
80101b03:	eb d8                	jmp    80101add <dirlink+0x24>
    iput(ip);
80101b05:	83 ec 0c             	sub    $0xc,%esp
80101b08:	50                   	push   %eax
80101b09:	e8 fd fa ff ff       	call   8010160b <iput>
    return -1;
80101b0e:	83 c4 10             	add    $0x10,%esp
80101b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b16:	eb 3d                	jmp    80101b55 <dirlink+0x9c>
      panic("dirlink read");
80101b18:	83 ec 0c             	sub    $0xc,%esp
80101b1b:	68 68 68 10 80       	push   $0x80106868
80101b20:	e8 1c e8 ff ff       	call   80100341 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b25:	83 ec 04             	sub    $0x4,%esp
80101b28:	6a 0e                	push   $0xe
80101b2a:	57                   	push   %edi
80101b2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b2e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b31:	50                   	push   %eax
80101b32:	e8 79 21 00 00       	call   80103cb0 <strncpy>
  de.inum = inum;
80101b37:	8b 45 10             	mov    0x10(%ebp),%eax
80101b3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b3e:	6a 10                	push   $0x10
80101b40:	56                   	push   %esi
80101b41:	57                   	push   %edi
80101b42:	53                   	push   %ebx
80101b43:	e8 ab fc ff ff       	call   801017f3 <writei>
80101b48:	83 c4 20             	add    $0x20,%esp
80101b4b:	83 f8 10             	cmp    $0x10,%eax
80101b4e:	75 0d                	jne    80101b5d <dirlink+0xa4>
  return 0;
80101b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
    panic("dirlink");
80101b5d:	83 ec 0c             	sub    $0xc,%esp
80101b60:	68 58 6e 10 80       	push   $0x80106e58
80101b65:	e8 d7 e7 ff ff       	call   80100341 <panic>

80101b6a <namei>:

struct inode*
namei(char *path)
{
80101b6a:	55                   	push   %ebp
80101b6b:	89 e5                	mov    %esp,%ebp
80101b6d:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101b70:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101b73:	ba 00 00 00 00       	mov    $0x0,%edx
80101b78:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7b:	e8 50 fe ff ff       	call   801019d0 <namex>
}
80101b80:	c9                   	leave  
80101b81:	c3                   	ret    

80101b82 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101b82:	55                   	push   %ebp
80101b83:	89 e5                	mov    %esp,%ebp
80101b85:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101b8b:	ba 01 00 00 00       	mov    $0x1,%edx
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	e8 38 fe ff ff       	call   801019d0 <namex>
}
80101b98:	c9                   	leave  
80101b99:	c3                   	ret    

80101b9a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101b9a:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101b9c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ba1:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ba2:	88 c2                	mov    %al,%dl
80101ba4:	83 e2 c0             	and    $0xffffffc0,%edx
80101ba7:	80 fa 40             	cmp    $0x40,%dl
80101baa:	75 f0                	jne    80101b9c <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101bac:	85 c9                	test   %ecx,%ecx
80101bae:	74 09                	je     80101bb9 <idewait+0x1f>
80101bb0:	a8 21                	test   $0x21,%al
80101bb2:	75 08                	jne    80101bbc <idewait+0x22>
    return -1;
  return 0;
80101bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101bb9:	89 c8                	mov    %ecx,%eax
80101bbb:	c3                   	ret    
    return -1;
80101bbc:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101bc1:	eb f6                	jmp    80101bb9 <idewait+0x1f>

80101bc3 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101bc3:	55                   	push   %ebp
80101bc4:	89 e5                	mov    %esp,%ebp
80101bc6:	56                   	push   %esi
80101bc7:	53                   	push   %ebx
  if(b == 0)
80101bc8:	85 c0                	test   %eax,%eax
80101bca:	0f 84 85 00 00 00    	je     80101c55 <idestart+0x92>
80101bd0:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101bd2:	8b 58 08             	mov    0x8(%eax),%ebx
80101bd5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101bdb:	0f 87 81 00 00 00    	ja     80101c62 <idestart+0x9f>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101be1:	b8 00 00 00 00       	mov    $0x0,%eax
80101be6:	e8 af ff ff ff       	call   80101b9a <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101beb:	b0 00                	mov    $0x0,%al
80101bed:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101bf2:	ee                   	out    %al,(%dx)
80101bf3:	b0 01                	mov    $0x1,%al
80101bf5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101bfa:	ee                   	out    %al,(%dx)
80101bfb:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c00:	88 d8                	mov    %bl,%al
80101c02:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101c03:	0f b6 c7             	movzbl %bh,%eax
80101c06:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c0b:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101c0c:	89 d8                	mov    %ebx,%eax
80101c0e:	c1 f8 10             	sar    $0x10,%eax
80101c11:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c16:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101c17:	8a 46 04             	mov    0x4(%esi),%al
80101c1a:	c1 e0 04             	shl    $0x4,%eax
80101c1d:	83 e0 10             	and    $0x10,%eax
80101c20:	c1 fb 18             	sar    $0x18,%ebx
80101c23:	83 e3 0f             	and    $0xf,%ebx
80101c26:	09 d8                	or     %ebx,%eax
80101c28:	83 c8 e0             	or     $0xffffffe0,%eax
80101c2b:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101c30:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101c31:	f6 06 04             	testb  $0x4,(%esi)
80101c34:	74 39                	je     80101c6f <idestart+0xac>
80101c36:	b0 30                	mov    $0x30,%al
80101c38:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c3d:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101c3e:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101c41:	b9 80 00 00 00       	mov    $0x80,%ecx
80101c46:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101c4b:	fc                   	cld    
80101c4c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101c4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c51:	5b                   	pop    %ebx
80101c52:	5e                   	pop    %esi
80101c53:	5d                   	pop    %ebp
80101c54:	c3                   	ret    
    panic("idestart");
80101c55:	83 ec 0c             	sub    $0xc,%esp
80101c58:	68 cb 68 10 80       	push   $0x801068cb
80101c5d:	e8 df e6 ff ff       	call   80100341 <panic>
    panic("incorrect blockno");
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	68 d4 68 10 80       	push   $0x801068d4
80101c6a:	e8 d2 e6 ff ff       	call   80100341 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c6f:	b0 20                	mov    $0x20,%al
80101c71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c76:	ee                   	out    %al,(%dx)
}
80101c77:	eb d5                	jmp    80101c4e <idestart+0x8b>

80101c79 <ideinit>:
{
80101c79:	55                   	push   %ebp
80101c7a:	89 e5                	mov    %esp,%ebp
80101c7c:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101c7f:	68 e6 68 10 80       	push   $0x801068e6
80101c84:	68 00 16 11 80       	push   $0x80111600
80101c89:	e8 1b 1d 00 00       	call   801039a9 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101c8e:	83 c4 08             	add    $0x8,%esp
80101c91:	a1 84 17 11 80       	mov    0x80111784,%eax
80101c96:	48                   	dec    %eax
80101c97:	50                   	push   %eax
80101c98:	6a 0e                	push   $0xe
80101c9a:	e8 46 02 00 00       	call   80101ee5 <ioapicenable>
  idewait(0);
80101c9f:	b8 00 00 00 00       	mov    $0x0,%eax
80101ca4:	e8 f1 fe ff ff       	call   80101b9a <idewait>
80101ca9:	b0 f0                	mov    $0xf0,%al
80101cab:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cb0:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101cb1:	83 c4 10             	add    $0x10,%esp
80101cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
80101cb9:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101cbf:	7f 17                	jg     80101cd8 <ideinit+0x5f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cc1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cc6:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101cc7:	84 c0                	test   %al,%al
80101cc9:	75 03                	jne    80101cce <ideinit+0x55>
  for(i=0; i<1000; i++){
80101ccb:	41                   	inc    %ecx
80101ccc:	eb eb                	jmp    80101cb9 <ideinit+0x40>
      havedisk1 = 1;
80101cce:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101cd5:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cd8:	b0 e0                	mov    $0xe0,%al
80101cda:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cdf:	ee                   	out    %al,(%dx)
}
80101ce0:	c9                   	leave  
80101ce1:	c3                   	ret    

80101ce2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101ce2:	55                   	push   %ebp
80101ce3:	89 e5                	mov    %esp,%ebp
80101ce5:	57                   	push   %edi
80101ce6:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	68 00 16 11 80       	push   $0x80111600
80101cef:	e8 ec 1d 00 00       	call   80103ae0 <acquire>

  if((b = idequeue) == 0){
80101cf4:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	85 db                	test   %ebx,%ebx
80101cff:	74 4a                	je     80101d4b <ideintr+0x69>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101d01:	8b 43 58             	mov    0x58(%ebx),%eax
80101d04:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d09:	f6 03 04             	testb  $0x4,(%ebx)
80101d0c:	74 4f                	je     80101d5d <ideintr+0x7b>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101d0e:	8b 03                	mov    (%ebx),%eax
80101d10:	83 c8 02             	or     $0x2,%eax
80101d13:	89 03                	mov    %eax,(%ebx)
  b->flags &= ~B_DIRTY;
80101d15:	83 e0 fb             	and    $0xfffffffb,%eax
80101d18:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101d1a:	83 ec 0c             	sub    $0xc,%esp
80101d1d:	53                   	push   %ebx
80101d1e:	e8 2e 1a 00 00       	call   80103751 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101d23:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101d28:	83 c4 10             	add    $0x10,%esp
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <ideintr+0x52>
    idestart(idequeue);
80101d2f:	e8 8f fe ff ff       	call   80101bc3 <idestart>

  release(&idelock);
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 00 16 11 80       	push   $0x80111600
80101d3c:	e8 04 1e 00 00       	call   80103b45 <release>
80101d41:	83 c4 10             	add    $0x10,%esp
}
80101d44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d47:	5b                   	pop    %ebx
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
    release(&idelock);
80101d4b:	83 ec 0c             	sub    $0xc,%esp
80101d4e:	68 00 16 11 80       	push   $0x80111600
80101d53:	e8 ed 1d 00 00       	call   80103b45 <release>
    return;
80101d58:	83 c4 10             	add    $0x10,%esp
80101d5b:	eb e7                	jmp    80101d44 <ideintr+0x62>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101d62:	e8 33 fe ff ff       	call   80101b9a <idewait>
80101d67:	85 c0                	test   %eax,%eax
80101d69:	78 a3                	js     80101d0e <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101d6b:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101d6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d73:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d78:	fc                   	cld    
80101d79:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101d7b:	eb 91                	jmp    80101d0e <ideintr+0x2c>

80101d7d <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101d7d:	55                   	push   %ebp
80101d7e:	89 e5                	mov    %esp,%ebp
80101d80:	53                   	push   %ebx
80101d81:	83 ec 10             	sub    $0x10,%esp
80101d84:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101d87:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d8a:	50                   	push   %eax
80101d8b:	e8 cb 1b 00 00       	call   8010395b <holdingsleep>
80101d90:	83 c4 10             	add    $0x10,%esp
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 37                	je     80101dce <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101d97:	8b 03                	mov    (%ebx),%eax
80101d99:	83 e0 06             	and    $0x6,%eax
80101d9c:	83 f8 02             	cmp    $0x2,%eax
80101d9f:	74 3a                	je     80101ddb <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101da1:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101da5:	74 09                	je     80101db0 <iderw+0x33>
80101da7:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101dae:	74 38                	je     80101de8 <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	68 00 16 11 80       	push   $0x80111600
80101db8:	e8 23 1d 00 00       	call   80103ae0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101dbd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101dcc:	eb 2a                	jmp    80101df8 <iderw+0x7b>
    panic("iderw: buf not locked");
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	68 ea 68 10 80       	push   $0x801068ea
80101dd6:	e8 66 e5 ff ff       	call   80100341 <panic>
    panic("iderw: nothing to do");
80101ddb:	83 ec 0c             	sub    $0xc,%esp
80101dde:	68 00 69 10 80       	push   $0x80106900
80101de3:	e8 59 e5 ff ff       	call   80100341 <panic>
    panic("iderw: ide disk 1 not present");
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	68 15 69 10 80       	push   $0x80106915
80101df0:	e8 4c e5 ff ff       	call   80100341 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101df5:	8d 50 58             	lea    0x58(%eax),%edx
80101df8:	8b 02                	mov    (%edx),%eax
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	75 f7                	jne    80101df5 <iderw+0x78>
    ;
  *pp = b;
80101dfe:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101e00:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e06:	75 1a                	jne    80101e22 <iderw+0xa5>
    idestart(b);
80101e08:	89 d8                	mov    %ebx,%eax
80101e0a:	e8 b4 fd ff ff       	call   80101bc3 <idestart>
80101e0f:	eb 11                	jmp    80101e22 <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101e11:	83 ec 08             	sub    $0x8,%esp
80101e14:	68 00 16 11 80       	push   $0x80111600
80101e19:	53                   	push   %ebx
80101e1a:	e8 b0 17 00 00       	call   801035cf <sleep>
80101e1f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101e22:	8b 03                	mov    (%ebx),%eax
80101e24:	83 e0 06             	and    $0x6,%eax
80101e27:	83 f8 02             	cmp    $0x2,%eax
80101e2a:	75 e5                	jne    80101e11 <iderw+0x94>
  }


  release(&idelock);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	68 00 16 11 80       	push   $0x80111600
80101e34:	e8 0c 1d 00 00       	call   80103b45 <release>
}
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e3f:	c9                   	leave  
80101e40:	c3                   	ret    

80101e41 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101e41:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101e47:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101e49:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e4e:	8b 40 10             	mov    0x10(%eax),%eax
}
80101e51:	c3                   	ret    

80101e52 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101e52:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101e58:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101e5a:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e5f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e62:	c3                   	ret    

80101e63 <ioapicinit>:

void
ioapicinit(void)
{
80101e63:	55                   	push   %ebp
80101e64:	89 e5                	mov    %esp,%ebp
80101e66:	57                   	push   %edi
80101e67:	56                   	push   %esi
80101e68:	53                   	push   %ebx
80101e69:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101e6c:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101e73:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101e76:	b8 01 00 00 00       	mov    $0x1,%eax
80101e7b:	e8 c1 ff ff ff       	call   80101e41 <ioapicread>
80101e80:	c1 e8 10             	shr    $0x10,%eax
80101e83:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101e86:	b8 00 00 00 00       	mov    $0x0,%eax
80101e8b:	e8 b1 ff ff ff       	call   80101e41 <ioapicread>
80101e90:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101e93:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101e9a:	39 c2                	cmp    %eax,%edx
80101e9c:	75 07                	jne    80101ea5 <ioapicinit+0x42>
{
80101e9e:	bb 00 00 00 00       	mov    $0x0,%ebx
80101ea3:	eb 34                	jmp    80101ed9 <ioapicinit+0x76>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 34 69 10 80       	push   $0x80106934
80101ead:	e8 28 e7 ff ff       	call   801005da <cprintf>
80101eb2:	83 c4 10             	add    $0x10,%esp
80101eb5:	eb e7                	jmp    80101e9e <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101eb7:	8d 53 20             	lea    0x20(%ebx),%edx
80101eba:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101ec0:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101ec4:	89 f0                	mov    %esi,%eax
80101ec6:	e8 87 ff ff ff       	call   80101e52 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101ecb:	8d 46 01             	lea    0x1(%esi),%eax
80101ece:	ba 00 00 00 00       	mov    $0x0,%edx
80101ed3:	e8 7a ff ff ff       	call   80101e52 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101ed8:	43                   	inc    %ebx
80101ed9:	39 fb                	cmp    %edi,%ebx
80101edb:	7e da                	jle    80101eb7 <ioapicinit+0x54>
  }
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    

80101ee5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101ee5:	55                   	push   %ebp
80101ee6:	89 e5                	mov    %esp,%ebp
80101ee8:	53                   	push   %ebx
80101ee9:	83 ec 04             	sub    $0x4,%esp
80101eec:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101eef:	8d 50 20             	lea    0x20(%eax),%edx
80101ef2:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101ef6:	89 d8                	mov    %ebx,%eax
80101ef8:	e8 55 ff ff ff       	call   80101e52 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101efd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f00:	c1 e2 18             	shl    $0x18,%edx
80101f03:	8d 43 01             	lea    0x1(%ebx),%eax
80101f06:	e8 47 ff ff ff       	call   80101e52 <ioapicwrite>
}
80101f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f0e:	c9                   	leave  
80101f0f:	c3                   	ret    

80101f10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	53                   	push   %ebx
80101f14:	83 ec 04             	sub    $0x4,%esp
80101f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101f1a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101f20:	75 4c                	jne    80101f6e <kfree+0x5e>
80101f22:	81 fb 30 56 11 80    	cmp    $0x80115630,%ebx
80101f28:	72 44                	jb     80101f6e <kfree+0x5e>
80101f2a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101f30:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101f35:	77 37                	ja     80101f6e <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101f37:	83 ec 04             	sub    $0x4,%esp
80101f3a:	68 00 10 00 00       	push   $0x1000
80101f3f:	6a 01                	push   $0x1
80101f41:	53                   	push   %ebx
80101f42:	e8 45 1c 00 00       	call   80103b8c <memset>

  if(kmem.use_lock)
80101f47:	83 c4 10             	add    $0x10,%esp
80101f4a:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f51:	75 28                	jne    80101f7b <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80101f53:	a1 78 16 11 80       	mov    0x80111678,%eax
80101f58:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80101f5a:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80101f60:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f67:	75 24                	jne    80101f8d <kfree+0x7d>
    release(&kmem.lock);
}
80101f69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f6c:	c9                   	leave  
80101f6d:	c3                   	ret    
    panic("kfree");
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	68 66 69 10 80       	push   $0x80106966
80101f76:	e8 c6 e3 ff ff       	call   80100341 <panic>
    acquire(&kmem.lock);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	68 40 16 11 80       	push   $0x80111640
80101f83:	e8 58 1b 00 00       	call   80103ae0 <acquire>
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	eb c6                	jmp    80101f53 <kfree+0x43>
    release(&kmem.lock);
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 40 16 11 80       	push   $0x80111640
80101f95:	e8 ab 1b 00 00       	call   80103b45 <release>
80101f9a:	83 c4 10             	add    $0x10,%esp
}
80101f9d:	eb ca                	jmp    80101f69 <kfree+0x59>

80101f9f <freerange>:
{
80101f9f:	55                   	push   %ebp
80101fa0:	89 e5                	mov    %esp,%ebp
80101fa2:	56                   	push   %esi
80101fa3:	53                   	push   %ebx
80101fa4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	05 ff 0f 00 00       	add    $0xfff,%eax
80101faf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80101fb4:	eb 0e                	jmp    80101fc4 <freerange+0x25>
    kfree(p);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	50                   	push   %eax
80101fba:	e8 51 ff ff ff       	call   80101f10 <kfree>
80101fbf:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80101fc2:	89 f0                	mov    %esi,%eax
80101fc4:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80101fca:	39 de                	cmp    %ebx,%esi
80101fcc:	76 e8                	jbe    80101fb6 <freerange+0x17>
}
80101fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    

80101fd5 <kinit1>:
{
80101fd5:	55                   	push   %ebp
80101fd6:	89 e5                	mov    %esp,%ebp
80101fd8:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80101fdb:	68 6c 69 10 80       	push   $0x8010696c
80101fe0:	68 40 16 11 80       	push   $0x80111640
80101fe5:	e8 bf 19 00 00       	call   801039a9 <initlock>
  kmem.use_lock = 0;
80101fea:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80101ff1:	00 00 00 
  freerange(vstart, vend);
80101ff4:	83 c4 08             	add    $0x8,%esp
80101ff7:	ff 75 0c             	push   0xc(%ebp)
80101ffa:	ff 75 08             	push   0x8(%ebp)
80101ffd:	e8 9d ff ff ff       	call   80101f9f <freerange>
}
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	c9                   	leave  
80102006:	c3                   	ret    

80102007 <kinit2>:
{
80102007:	55                   	push   %ebp
80102008:	89 e5                	mov    %esp,%ebp
8010200a:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
8010200d:	ff 75 0c             	push   0xc(%ebp)
80102010:	ff 75 08             	push   0x8(%ebp)
80102013:	e8 87 ff ff ff       	call   80101f9f <freerange>
  kmem.use_lock = 1;
80102018:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010201f:	00 00 00 
}
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	c9                   	leave  
80102026:	c3                   	ret    

80102027 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102027:	55                   	push   %ebp
80102028:	89 e5                	mov    %esp,%ebp
8010202a:	53                   	push   %ebx
8010202b:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
8010202e:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102035:	75 21                	jne    80102058 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102037:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
8010203d:	85 db                	test   %ebx,%ebx
8010203f:	74 07                	je     80102048 <kalloc+0x21>
    kmem.freelist = r->next;
80102041:	8b 03                	mov    (%ebx),%eax
80102043:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
80102048:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010204f:	75 19                	jne    8010206a <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
80102051:	89 d8                	mov    %ebx,%eax
80102053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102056:	c9                   	leave  
80102057:	c3                   	ret    
    acquire(&kmem.lock);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 40 16 11 80       	push   $0x80111640
80102060:	e8 7b 1a 00 00       	call   80103ae0 <acquire>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	eb cd                	jmp    80102037 <kalloc+0x10>
    release(&kmem.lock);
8010206a:	83 ec 0c             	sub    $0xc,%esp
8010206d:	68 40 16 11 80       	push   $0x80111640
80102072:	e8 ce 1a 00 00       	call   80103b45 <release>
80102077:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
8010207a:	eb d5                	jmp    80102051 <kalloc+0x2a>

8010207c <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010207c:	ba 64 00 00 00       	mov    $0x64,%edx
80102081:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102082:	a8 01                	test   $0x1,%al
80102084:	0f 84 b3 00 00 00    	je     8010213d <kbdgetc+0xc1>
8010208a:	ba 60 00 00 00       	mov    $0x60,%edx
8010208f:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102090:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102093:	3c e0                	cmp    $0xe0,%al
80102095:	74 61                	je     801020f8 <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102097:	84 c0                	test   %al,%al
80102099:	78 6a                	js     80102105 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010209b:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
801020a1:	f6 c2 40             	test   $0x40,%dl
801020a4:	74 0f                	je     801020b5 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801020a6:	83 c8 80             	or     $0xffffff80,%eax
801020a9:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
801020ac:	83 e2 bf             	and    $0xffffffbf,%edx
801020af:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  }

  shift |= shiftcode[data];
801020b5:	0f b6 91 a0 6a 10 80 	movzbl -0x7fef9560(%ecx),%edx
801020bc:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
801020c2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
801020c8:	0f b6 81 a0 69 10 80 	movzbl -0x7fef9660(%ecx),%eax
801020cf:	31 c2                	xor    %eax,%edx
801020d1:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801020d7:	89 d0                	mov    %edx,%eax
801020d9:	83 e0 03             	and    $0x3,%eax
801020dc:	8b 04 85 80 69 10 80 	mov    -0x7fef9680(,%eax,4),%eax
801020e3:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801020e7:	f6 c2 08             	test   $0x8,%dl
801020ea:	74 56                	je     80102142 <kbdgetc+0xc6>
    if('a' <= c && c <= 'z')
801020ec:	8d 50 9f             	lea    -0x61(%eax),%edx
801020ef:	83 fa 19             	cmp    $0x19,%edx
801020f2:	77 3d                	ja     80102131 <kbdgetc+0xb5>
      c += 'A' - 'a';
801020f4:	83 e8 20             	sub    $0x20,%eax
801020f7:	c3                   	ret    
    shift |= E0ESC;
801020f8:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
    return 0;
801020ff:	b8 00 00 00 00       	mov    $0x0,%eax
80102104:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102105:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010210b:	f6 c2 40             	test   $0x40,%dl
8010210e:	75 05                	jne    80102115 <kbdgetc+0x99>
80102110:	89 c1                	mov    %eax,%ecx
80102112:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102115:	8a 81 a0 6a 10 80    	mov    -0x7fef9560(%ecx),%al
8010211b:	83 c8 40             	or     $0x40,%eax
8010211e:	0f b6 c0             	movzbl %al,%eax
80102121:	f7 d0                	not    %eax
80102123:	21 c2                	and    %eax,%edx
80102125:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
    return 0;
8010212b:	b8 00 00 00 00       	mov    $0x0,%eax
80102130:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102131:	8d 50 bf             	lea    -0x41(%eax),%edx
80102134:	83 fa 19             	cmp    $0x19,%edx
80102137:	77 09                	ja     80102142 <kbdgetc+0xc6>
      c += 'a' - 'A';
80102139:	83 c0 20             	add    $0x20,%eax
  }
  return c;
8010213c:	c3                   	ret    
    return -1;
8010213d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102142:	c3                   	ret    

80102143 <kbdintr>:

void
kbdintr(void)
{
80102143:	55                   	push   %ebp
80102144:	89 e5                	mov    %esp,%ebp
80102146:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102149:	68 7c 20 10 80       	push   $0x8010207c
8010214e:	e8 ac e5 ff ff       	call   801006ff <consoleintr>
}
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	c9                   	leave  
80102157:	c3                   	ret    

80102158 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102158:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
8010215e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102161:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102163:	a1 80 16 11 80       	mov    0x80111680,%eax
80102168:	8b 40 20             	mov    0x20(%eax),%eax
}
8010216b:	c3                   	ret    

8010216c <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010216c:	ba 70 00 00 00       	mov    $0x70,%edx
80102171:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102172:	ba 71 00 00 00       	mov    $0x71,%edx
80102177:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102178:	0f b6 c0             	movzbl %al,%eax
}
8010217b:	c3                   	ret    

8010217c <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
8010217c:	55                   	push   %ebp
8010217d:	89 e5                	mov    %esp,%ebp
8010217f:	53                   	push   %ebx
80102180:	83 ec 04             	sub    $0x4,%esp
80102183:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102185:	b8 00 00 00 00       	mov    $0x0,%eax
8010218a:	e8 dd ff ff ff       	call   8010216c <cmos_read>
8010218f:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102191:	b8 02 00 00 00       	mov    $0x2,%eax
80102196:	e8 d1 ff ff ff       	call   8010216c <cmos_read>
8010219b:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
8010219e:	b8 04 00 00 00       	mov    $0x4,%eax
801021a3:	e8 c4 ff ff ff       	call   8010216c <cmos_read>
801021a8:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
801021ab:	b8 07 00 00 00       	mov    $0x7,%eax
801021b0:	e8 b7 ff ff ff       	call   8010216c <cmos_read>
801021b5:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801021b8:	b8 08 00 00 00       	mov    $0x8,%eax
801021bd:	e8 aa ff ff ff       	call   8010216c <cmos_read>
801021c2:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801021c5:	b8 09 00 00 00       	mov    $0x9,%eax
801021ca:	e8 9d ff ff ff       	call   8010216c <cmos_read>
801021cf:	89 43 14             	mov    %eax,0x14(%ebx)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
801021d6:	c3                   	ret    

801021d7 <lapicinit>:
  if(!lapic)
801021d7:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
801021de:	0f 84 fe 00 00 00    	je     801022e2 <lapicinit+0x10b>
{
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801021ea:	ba 3f 01 00 00       	mov    $0x13f,%edx
801021ef:	b8 3c 00 00 00       	mov    $0x3c,%eax
801021f4:	e8 5f ff ff ff       	call   80102158 <lapicw>
  lapicw(TDCR, X1);
801021f9:	ba 0b 00 00 00       	mov    $0xb,%edx
801021fe:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102203:	e8 50 ff ff ff       	call   80102158 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102208:	ba 20 00 02 00       	mov    $0x20020,%edx
8010220d:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102212:	e8 41 ff ff ff       	call   80102158 <lapicw>
  lapicw(TICR, 10000000);
80102217:	ba 80 96 98 00       	mov    $0x989680,%edx
8010221c:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102221:	e8 32 ff ff ff       	call   80102158 <lapicw>
  lapicw(LINT0, MASKED);
80102226:	ba 00 00 01 00       	mov    $0x10000,%edx
8010222b:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102230:	e8 23 ff ff ff       	call   80102158 <lapicw>
  lapicw(LINT1, MASKED);
80102235:	ba 00 00 01 00       	mov    $0x10000,%edx
8010223a:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010223f:	e8 14 ff ff ff       	call   80102158 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102244:	a1 80 16 11 80       	mov    0x80111680,%eax
80102249:	8b 40 30             	mov    0x30(%eax),%eax
8010224c:	c1 e8 10             	shr    $0x10,%eax
8010224f:	a8 fc                	test   $0xfc,%al
80102251:	75 7b                	jne    801022ce <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102253:	ba 33 00 00 00       	mov    $0x33,%edx
80102258:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010225d:	e8 f6 fe ff ff       	call   80102158 <lapicw>
  lapicw(ESR, 0);
80102262:	ba 00 00 00 00       	mov    $0x0,%edx
80102267:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010226c:	e8 e7 fe ff ff       	call   80102158 <lapicw>
  lapicw(ESR, 0);
80102271:	ba 00 00 00 00       	mov    $0x0,%edx
80102276:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010227b:	e8 d8 fe ff ff       	call   80102158 <lapicw>
  lapicw(EOI, 0);
80102280:	ba 00 00 00 00       	mov    $0x0,%edx
80102285:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010228a:	e8 c9 fe ff ff       	call   80102158 <lapicw>
  lapicw(ICRHI, 0);
8010228f:	ba 00 00 00 00       	mov    $0x0,%edx
80102294:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102299:	e8 ba fe ff ff       	call   80102158 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010229e:	ba 00 85 08 00       	mov    $0x88500,%edx
801022a3:	b8 c0 00 00 00       	mov    $0xc0,%eax
801022a8:	e8 ab fe ff ff       	call   80102158 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801022ad:	a1 80 16 11 80       	mov    0x80111680,%eax
801022b2:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801022b8:	f6 c4 10             	test   $0x10,%ah
801022bb:	75 f0                	jne    801022ad <lapicinit+0xd6>
  lapicw(TPR, 0);
801022bd:	ba 00 00 00 00       	mov    $0x0,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	e8 8c fe ff ff       	call   80102158 <lapicw>
}
801022cc:	c9                   	leave  
801022cd:	c3                   	ret    
    lapicw(PCINT, MASKED);
801022ce:	ba 00 00 01 00       	mov    $0x10000,%edx
801022d3:	b8 d0 00 00 00       	mov    $0xd0,%eax
801022d8:	e8 7b fe ff ff       	call   80102158 <lapicw>
801022dd:	e9 71 ff ff ff       	jmp    80102253 <lapicinit+0x7c>
801022e2:	c3                   	ret    

801022e3 <lapicid>:
  if (!lapic)
801022e3:	a1 80 16 11 80       	mov    0x80111680,%eax
801022e8:	85 c0                	test   %eax,%eax
801022ea:	74 07                	je     801022f3 <lapicid+0x10>
  return lapic[ID] >> 24;
801022ec:	8b 40 20             	mov    0x20(%eax),%eax
801022ef:	c1 e8 18             	shr    $0x18,%eax
801022f2:	c3                   	ret    
    return 0;
801022f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022f8:	c3                   	ret    

801022f9 <lapiceoi>:
  if(lapic)
801022f9:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
80102300:	74 17                	je     80102319 <lapiceoi+0x20>
{
80102302:	55                   	push   %ebp
80102303:	89 e5                	mov    %esp,%ebp
80102305:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102308:	ba 00 00 00 00       	mov    $0x0,%edx
8010230d:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102312:	e8 41 fe ff ff       	call   80102158 <lapicw>
}
80102317:	c9                   	leave  
80102318:	c3                   	ret    
80102319:	c3                   	ret    

8010231a <microdelay>:
}
8010231a:	c3                   	ret    

8010231b <lapicstartap>:
{
8010231b:	55                   	push   %ebp
8010231c:	89 e5                	mov    %esp,%ebp
8010231e:	57                   	push   %edi
8010231f:	56                   	push   %esi
80102320:	53                   	push   %ebx
80102321:	83 ec 0c             	sub    $0xc,%esp
80102324:	8b 75 08             	mov    0x8(%ebp),%esi
80102327:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	b0 0f                	mov    $0xf,%al
8010232c:	ba 70 00 00 00       	mov    $0x70,%edx
80102331:	ee                   	out    %al,(%dx)
80102332:	b0 0a                	mov    $0xa,%al
80102334:	ba 71 00 00 00       	mov    $0x71,%edx
80102339:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010233a:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102341:	00 00 
  wrv[1] = addr >> 4;
80102343:	89 f8                	mov    %edi,%eax
80102345:	c1 e8 04             	shr    $0x4,%eax
80102348:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010234e:	c1 e6 18             	shl    $0x18,%esi
80102351:	89 f2                	mov    %esi,%edx
80102353:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102358:	e8 fb fd ff ff       	call   80102158 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010235d:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102362:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102367:	e8 ec fd ff ff       	call   80102158 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010236c:	ba 00 85 00 00       	mov    $0x8500,%edx
80102371:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102376:	e8 dd fd ff ff       	call   80102158 <lapicw>
  for(i = 0; i < 2; i++){
8010237b:	bb 00 00 00 00       	mov    $0x0,%ebx
80102380:	eb 1f                	jmp    801023a1 <lapicstartap+0x86>
    lapicw(ICRHI, apicid<<24);
80102382:	89 f2                	mov    %esi,%edx
80102384:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102389:	e8 ca fd ff ff       	call   80102158 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010238e:	89 fa                	mov    %edi,%edx
80102390:	c1 ea 0c             	shr    $0xc,%edx
80102393:	80 ce 06             	or     $0x6,%dh
80102396:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010239b:	e8 b8 fd ff ff       	call   80102158 <lapicw>
  for(i = 0; i < 2; i++){
801023a0:	43                   	inc    %ebx
801023a1:	83 fb 01             	cmp    $0x1,%ebx
801023a4:	7e dc                	jle    80102382 <lapicstartap+0x67>
}
801023a6:	83 c4 0c             	add    $0xc,%esp
801023a9:	5b                   	pop    %ebx
801023aa:	5e                   	pop    %esi
801023ab:	5f                   	pop    %edi
801023ac:	5d                   	pop    %ebp
801023ad:	c3                   	ret    

801023ae <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801023ae:	55                   	push   %ebp
801023af:	89 e5                	mov    %esp,%ebp
801023b1:	57                   	push   %edi
801023b2:	56                   	push   %esi
801023b3:	53                   	push   %ebx
801023b4:	83 ec 3c             	sub    $0x3c,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801023ba:	b8 0b 00 00 00       	mov    $0xb,%eax
801023bf:	e8 a8 fd ff ff       	call   8010216c <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801023c4:	83 e0 04             	and    $0x4,%eax
801023c7:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801023c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801023cc:	e8 ab fd ff ff       	call   8010217c <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801023d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801023d6:	e8 91 fd ff ff       	call   8010216c <cmos_read>
801023db:	a8 80                	test   $0x80,%al
801023dd:	75 ea                	jne    801023c9 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
801023df:	8d 75 b8             	lea    -0x48(%ebp),%esi
801023e2:	89 f0                	mov    %esi,%eax
801023e4:	e8 93 fd ff ff       	call   8010217c <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801023e9:	83 ec 04             	sub    $0x4,%esp
801023ec:	6a 18                	push   $0x18
801023ee:	56                   	push   %esi
801023ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801023f2:	50                   	push   %eax
801023f3:	e8 df 17 00 00       	call   80103bd7 <memcmp>
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	85 c0                	test   %eax,%eax
801023fd:	75 ca                	jne    801023c9 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
801023ff:	85 ff                	test   %edi,%edi
80102401:	75 7e                	jne    80102481 <cmostime+0xd3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102403:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102406:	89 d0                	mov    %edx,%eax
80102408:	c1 e8 04             	shr    $0x4,%eax
8010240b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010240e:	01 c0                	add    %eax,%eax
80102410:	83 e2 0f             	and    $0xf,%edx
80102413:	01 d0                	add    %edx,%eax
80102415:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102418:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010241b:	89 d0                	mov    %edx,%eax
8010241d:	c1 e8 04             	shr    $0x4,%eax
80102420:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102423:	01 c0                	add    %eax,%eax
80102425:	83 e2 0f             	and    $0xf,%edx
80102428:	01 d0                	add    %edx,%eax
8010242a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010242d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102430:	89 d0                	mov    %edx,%eax
80102432:	c1 e8 04             	shr    $0x4,%eax
80102435:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102438:	01 c0                	add    %eax,%eax
8010243a:	83 e2 0f             	and    $0xf,%edx
8010243d:	01 d0                	add    %edx,%eax
8010243f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102442:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102445:	89 d0                	mov    %edx,%eax
80102447:	c1 e8 04             	shr    $0x4,%eax
8010244a:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010244d:	01 c0                	add    %eax,%eax
8010244f:	83 e2 0f             	and    $0xf,%edx
80102452:	01 d0                	add    %edx,%eax
80102454:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102457:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010245a:	89 d0                	mov    %edx,%eax
8010245c:	c1 e8 04             	shr    $0x4,%eax
8010245f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102462:	01 c0                	add    %eax,%eax
80102464:	83 e2 0f             	and    $0xf,%edx
80102467:	01 d0                	add    %edx,%eax
80102469:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010246c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010246f:	89 d0                	mov    %edx,%eax
80102471:	c1 e8 04             	shr    $0x4,%eax
80102474:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102477:	01 c0                	add    %eax,%eax
80102479:	83 e2 0f             	and    $0xf,%edx
8010247c:	01 d0                	add    %edx,%eax
8010247e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102481:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102484:	b9 06 00 00 00       	mov    $0x6,%ecx
80102489:	89 df                	mov    %ebx,%edi
8010248b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
8010248d:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102497:	5b                   	pop    %ebx
80102498:	5e                   	pop    %esi
80102499:	5f                   	pop    %edi
8010249a:	5d                   	pop    %ebp
8010249b:	c3                   	ret    

8010249c <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010249c:	55                   	push   %ebp
8010249d:	89 e5                	mov    %esp,%ebp
8010249f:	53                   	push   %ebx
801024a0:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801024a3:	ff 35 d4 16 11 80    	push   0x801116d4
801024a9:	ff 35 e4 16 11 80    	push   0x801116e4
801024af:	e8 b6 dc ff ff       	call   8010016a <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801024b4:	8b 58 5c             	mov    0x5c(%eax),%ebx
801024b7:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	ba 00 00 00 00       	mov    $0x0,%edx
801024c5:	eb 0c                	jmp    801024d3 <read_head+0x37>
    log.lh.block[i] = lh->block[i];
801024c7:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801024cb:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801024d2:	42                   	inc    %edx
801024d3:	39 d3                	cmp    %edx,%ebx
801024d5:	7f f0                	jg     801024c7 <read_head+0x2b>
  }
  brelse(buf);
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	50                   	push   %eax
801024db:	e8 f3 dc ff ff       	call   801001d3 <brelse>
}
801024e0:	83 c4 10             	add    $0x10,%esp
801024e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e6:	c9                   	leave  
801024e7:	c3                   	ret    

801024e8 <install_trans>:
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	57                   	push   %edi
801024ec:	56                   	push   %esi
801024ed:	53                   	push   %ebx
801024ee:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801024f1:	be 00 00 00 00       	mov    $0x0,%esi
801024f6:	eb 62                	jmp    8010255a <install_trans+0x72>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102500:	40                   	inc    %eax
80102501:	83 ec 08             	sub    $0x8,%esp
80102504:	50                   	push   %eax
80102505:	ff 35 e4 16 11 80    	push   0x801116e4
8010250b:	e8 5a dc ff ff       	call   8010016a <bread>
80102510:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102512:	83 c4 08             	add    $0x8,%esp
80102515:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
8010251c:	ff 35 e4 16 11 80    	push   0x801116e4
80102522:	e8 43 dc ff ff       	call   8010016a <bread>
80102527:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102529:	8d 57 5c             	lea    0x5c(%edi),%edx
8010252c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010252f:	83 c4 0c             	add    $0xc,%esp
80102532:	68 00 02 00 00       	push   $0x200
80102537:	52                   	push   %edx
80102538:	50                   	push   %eax
80102539:	e8 cc 16 00 00       	call   80103c0a <memmove>
    bwrite(dbuf);  // write dst to disk
8010253e:	89 1c 24             	mov    %ebx,(%esp)
80102541:	e8 52 dc ff ff       	call   80100198 <bwrite>
    brelse(lbuf);
80102546:	89 3c 24             	mov    %edi,(%esp)
80102549:	e8 85 dc ff ff       	call   801001d3 <brelse>
    brelse(dbuf);
8010254e:	89 1c 24             	mov    %ebx,(%esp)
80102551:	e8 7d dc ff ff       	call   801001d3 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102556:	46                   	inc    %esi
80102557:	83 c4 10             	add    $0x10,%esp
8010255a:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102560:	7f 96                	jg     801024f8 <install_trans+0x10>
}
80102562:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102565:	5b                   	pop    %ebx
80102566:	5e                   	pop    %esi
80102567:	5f                   	pop    %edi
80102568:	5d                   	pop    %ebp
80102569:	c3                   	ret    

8010256a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010256a:	55                   	push   %ebp
8010256b:	89 e5                	mov    %esp,%ebp
8010256d:	53                   	push   %ebx
8010256e:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102571:	ff 35 d4 16 11 80    	push   0x801116d4
80102577:	ff 35 e4 16 11 80    	push   0x801116e4
8010257d:	e8 e8 db ff ff       	call   8010016a <bread>
80102582:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102584:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
8010258a:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	b8 00 00 00 00       	mov    $0x0,%eax
80102595:	eb 0c                	jmp    801025a3 <write_head+0x39>
    hb->block[i] = log.lh.block[i];
80102597:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
8010259e:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801025a2:	40                   	inc    %eax
801025a3:	39 c1                	cmp    %eax,%ecx
801025a5:	7f f0                	jg     80102597 <write_head+0x2d>
  }
  bwrite(buf);
801025a7:	83 ec 0c             	sub    $0xc,%esp
801025aa:	53                   	push   %ebx
801025ab:	e8 e8 db ff ff       	call   80100198 <bwrite>
  brelse(buf);
801025b0:	89 1c 24             	mov    %ebx,(%esp)
801025b3:	e8 1b dc ff ff       	call   801001d3 <brelse>
}
801025b8:	83 c4 10             	add    $0x10,%esp
801025bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025be:	c9                   	leave  
801025bf:	c3                   	ret    

801025c0 <recover_from_log>:

static void
recover_from_log(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 08             	sub    $0x8,%esp
  read_head();
801025c6:	e8 d1 fe ff ff       	call   8010249c <read_head>
  install_trans(); // if committed, copy from log to disk
801025cb:	e8 18 ff ff ff       	call   801024e8 <install_trans>
  log.lh.n = 0;
801025d0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801025d7:	00 00 00 
  write_head(); // clear the log
801025da:	e8 8b ff ff ff       	call   8010256a <write_head>
}
801025df:	c9                   	leave  
801025e0:	c3                   	ret    

801025e1 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801025e1:	55                   	push   %ebp
801025e2:	89 e5                	mov    %esp,%ebp
801025e4:	57                   	push   %edi
801025e5:	56                   	push   %esi
801025e6:	53                   	push   %ebx
801025e7:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801025ea:	be 00 00 00 00       	mov    $0x0,%esi
801025ef:	eb 62                	jmp    80102653 <write_log+0x72>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801025f1:	89 f0                	mov    %esi,%eax
801025f3:	03 05 d4 16 11 80    	add    0x801116d4,%eax
801025f9:	40                   	inc    %eax
801025fa:	83 ec 08             	sub    $0x8,%esp
801025fd:	50                   	push   %eax
801025fe:	ff 35 e4 16 11 80    	push   0x801116e4
80102604:	e8 61 db ff ff       	call   8010016a <bread>
80102609:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010260b:	83 c4 08             	add    $0x8,%esp
8010260e:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
80102615:	ff 35 e4 16 11 80    	push   0x801116e4
8010261b:	e8 4a db ff ff       	call   8010016a <bread>
80102620:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102622:	8d 50 5c             	lea    0x5c(%eax),%edx
80102625:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102628:	83 c4 0c             	add    $0xc,%esp
8010262b:	68 00 02 00 00       	push   $0x200
80102630:	52                   	push   %edx
80102631:	50                   	push   %eax
80102632:	e8 d3 15 00 00       	call   80103c0a <memmove>
    bwrite(to);  // write the log
80102637:	89 1c 24             	mov    %ebx,(%esp)
8010263a:	e8 59 db ff ff       	call   80100198 <bwrite>
    brelse(from);
8010263f:	89 3c 24             	mov    %edi,(%esp)
80102642:	e8 8c db ff ff       	call   801001d3 <brelse>
    brelse(to);
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 84 db ff ff       	call   801001d3 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010264f:	46                   	inc    %esi
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102659:	7f 96                	jg     801025f1 <write_log+0x10>
  }
}
8010265b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010265e:	5b                   	pop    %ebx
8010265f:	5e                   	pop    %esi
80102660:	5f                   	pop    %edi
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    

80102663 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102663:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
8010266a:	7f 01                	jg     8010266d <commit+0xa>
8010266c:	c3                   	ret    
{
8010266d:	55                   	push   %ebp
8010266e:	89 e5                	mov    %esp,%ebp
80102670:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102673:	e8 69 ff ff ff       	call   801025e1 <write_log>
    write_head();    // Write header to disk -- the real commit
80102678:	e8 ed fe ff ff       	call   8010256a <write_head>
    install_trans(); // Now install writes to home locations
8010267d:	e8 66 fe ff ff       	call   801024e8 <install_trans>
    log.lh.n = 0;
80102682:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102689:	00 00 00 
    write_head();    // Erase the transaction from the log
8010268c:	e8 d9 fe ff ff       	call   8010256a <write_head>
  }
}
80102691:	c9                   	leave  
80102692:	c3                   	ret    

80102693 <initlog>:
{
80102693:	55                   	push   %ebp
80102694:	89 e5                	mov    %esp,%ebp
80102696:	53                   	push   %ebx
80102697:	83 ec 2c             	sub    $0x2c,%esp
8010269a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010269d:	68 a0 6b 10 80       	push   $0x80106ba0
801026a2:	68 a0 16 11 80       	push   $0x801116a0
801026a7:	e8 fd 12 00 00       	call   801039a9 <initlock>
  readsb(dev, &sb);
801026ac:	83 c4 08             	add    $0x8,%esp
801026af:	8d 45 dc             	lea    -0x24(%ebp),%eax
801026b2:	50                   	push   %eax
801026b3:	53                   	push   %ebx
801026b4:	e8 0e eb ff ff       	call   801011c7 <readsb>
  log.start = sb.logstart;
801026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801026bc:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
801026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801026c4:	a3 d8 16 11 80       	mov    %eax,0x801116d8
  log.dev = dev;
801026c9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  recover_from_log();
801026cf:	e8 ec fe ff ff       	call   801025c0 <recover_from_log>
}
801026d4:	83 c4 10             	add    $0x10,%esp
801026d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026da:	c9                   	leave  
801026db:	c3                   	ret    

801026dc <begin_op>:
{
801026dc:	55                   	push   %ebp
801026dd:	89 e5                	mov    %esp,%ebp
801026df:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801026e2:	68 a0 16 11 80       	push   $0x801116a0
801026e7:	e8 f4 13 00 00       	call   80103ae0 <acquire>
801026ec:	83 c4 10             	add    $0x10,%esp
801026ef:	eb 15                	jmp    80102706 <begin_op+0x2a>
      sleep(&log, &log.lock);
801026f1:	83 ec 08             	sub    $0x8,%esp
801026f4:	68 a0 16 11 80       	push   $0x801116a0
801026f9:	68 a0 16 11 80       	push   $0x801116a0
801026fe:	e8 cc 0e 00 00       	call   801035cf <sleep>
80102703:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102706:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
8010270d:	75 e2                	jne    801026f1 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010270f:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102714:	8d 48 01             	lea    0x1(%eax),%ecx
80102717:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
8010271b:	8d 04 12             	lea    (%edx,%edx,1),%eax
8010271e:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102724:	83 f8 1e             	cmp    $0x1e,%eax
80102727:	7e 17                	jle    80102740 <begin_op+0x64>
      sleep(&log, &log.lock);
80102729:	83 ec 08             	sub    $0x8,%esp
8010272c:	68 a0 16 11 80       	push   $0x801116a0
80102731:	68 a0 16 11 80       	push   $0x801116a0
80102736:	e8 94 0e 00 00       	call   801035cf <sleep>
8010273b:	83 c4 10             	add    $0x10,%esp
8010273e:	eb c6                	jmp    80102706 <begin_op+0x2a>
      log.outstanding += 1;
80102740:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
      release(&log.lock);
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	68 a0 16 11 80       	push   $0x801116a0
8010274e:	e8 f2 13 00 00       	call   80103b45 <release>
}
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	c9                   	leave  
80102757:	c3                   	ret    

80102758 <end_op>:
{
80102758:	55                   	push   %ebp
80102759:	89 e5                	mov    %esp,%ebp
8010275b:	53                   	push   %ebx
8010275c:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010275f:	68 a0 16 11 80       	push   $0x801116a0
80102764:	e8 77 13 00 00       	call   80103ae0 <acquire>
  log.outstanding -= 1;
80102769:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010276e:	48                   	dec    %eax
8010276f:	a3 dc 16 11 80       	mov    %eax,0x801116dc
  if(log.committing)
80102774:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
8010277a:	83 c4 10             	add    $0x10,%esp
8010277d:	85 db                	test   %ebx,%ebx
8010277f:	75 2c                	jne    801027ad <end_op+0x55>
  if(log.outstanding == 0){
80102781:	85 c0                	test   %eax,%eax
80102783:	75 35                	jne    801027ba <end_op+0x62>
    log.committing = 1;
80102785:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
8010278c:	00 00 00 
    do_commit = 1;
8010278f:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 a0 16 11 80       	push   $0x801116a0
8010279c:	e8 a4 13 00 00       	call   80103b45 <release>
  if(do_commit){
801027a1:	83 c4 10             	add    $0x10,%esp
801027a4:	85 db                	test   %ebx,%ebx
801027a6:	75 24                	jne    801027cc <end_op+0x74>
}
801027a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ab:	c9                   	leave  
801027ac:	c3                   	ret    
    panic("log.committing");
801027ad:	83 ec 0c             	sub    $0xc,%esp
801027b0:	68 a4 6b 10 80       	push   $0x80106ba4
801027b5:	e8 87 db ff ff       	call   80100341 <panic>
    wakeup(&log);
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	68 a0 16 11 80       	push   $0x801116a0
801027c2:	e8 8a 0f 00 00       	call   80103751 <wakeup>
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	eb c8                	jmp    80102794 <end_op+0x3c>
    commit();
801027cc:	e8 92 fe ff ff       	call   80102663 <commit>
    acquire(&log.lock);
801027d1:	83 ec 0c             	sub    $0xc,%esp
801027d4:	68 a0 16 11 80       	push   $0x801116a0
801027d9:	e8 02 13 00 00       	call   80103ae0 <acquire>
    log.committing = 0;
801027de:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
801027e5:	00 00 00 
    wakeup(&log);
801027e8:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027ef:	e8 5d 0f 00 00       	call   80103751 <wakeup>
    release(&log.lock);
801027f4:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027fb:	e8 45 13 00 00       	call   80103b45 <release>
80102800:	83 c4 10             	add    $0x10,%esp
}
80102803:	eb a3                	jmp    801027a8 <end_op+0x50>

80102805 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
80102808:	53                   	push   %ebx
80102809:	83 ec 04             	sub    $0x4,%esp
8010280c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010280f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102815:	83 fa 1d             	cmp    $0x1d,%edx
80102818:	7f 2a                	jg     80102844 <log_write+0x3f>
8010281a:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010281f:	48                   	dec    %eax
80102820:	39 c2                	cmp    %eax,%edx
80102822:	7d 20                	jge    80102844 <log_write+0x3f>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102824:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
8010282b:	7e 24                	jle    80102851 <log_write+0x4c>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010282d:	83 ec 0c             	sub    $0xc,%esp
80102830:	68 a0 16 11 80       	push   $0x801116a0
80102835:	e8 a6 12 00 00       	call   80103ae0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010283a:	83 c4 10             	add    $0x10,%esp
8010283d:	b8 00 00 00 00       	mov    $0x0,%eax
80102842:	eb 1b                	jmp    8010285f <log_write+0x5a>
    panic("too big a transaction");
80102844:	83 ec 0c             	sub    $0xc,%esp
80102847:	68 b3 6b 10 80       	push   $0x80106bb3
8010284c:	e8 f0 da ff ff       	call   80100341 <panic>
    panic("log_write outside of trans");
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 c9 6b 10 80       	push   $0x80106bc9
80102859:	e8 e3 da ff ff       	call   80100341 <panic>
  for (i = 0; i < log.lh.n; i++) {
8010285e:	40                   	inc    %eax
8010285f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102865:	39 c2                	cmp    %eax,%edx
80102867:	7e 0c                	jle    80102875 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102869:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010286c:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102873:	75 e9                	jne    8010285e <log_write+0x59>
      break;
  }
  log.lh.block[i] = b->blockno;
80102875:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102878:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
8010287f:	39 c2                	cmp    %eax,%edx
80102881:	74 18                	je     8010289b <log_write+0x96>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102883:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	68 a0 16 11 80       	push   $0x801116a0
8010288e:	e8 b2 12 00 00       	call   80103b45 <release>
}
80102893:	83 c4 10             	add    $0x10,%esp
80102896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102899:	c9                   	leave  
8010289a:	c3                   	ret    
    log.lh.n++;
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
801028ba:	e8 4b 13 00 00       	call   80103c0a <memmove>

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
801028e8:	e8 9b 07 00 00       	call   80103088 <mycpu>
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
80102900:	c7 05 f8 6f 00 80 78 	movl   $0x80102978,0x80006ff8
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
80102940:	e8 a7 07 00 00       	call   801030ec <cpuid>
80102945:	89 c3                	mov    %eax,%ebx
80102947:	e8 a0 07 00 00       	call   801030ec <cpuid>
8010294c:	83 ec 04             	sub    $0x4,%esp
8010294f:	53                   	push   %ebx
80102950:	50                   	push   %eax
80102951:	68 e4 6b 10 80       	push   $0x80106be4
80102956:	e8 7f dc ff ff       	call   801005da <cprintf>
  idtinit();       // load idt register
8010295b:	e8 73 24 00 00       	call   80104dd3 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102960:	e8 23 07 00 00       	call   80103088 <mycpu>
80102965:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102967:	b8 01 00 00 00       	mov    $0x1,%eax
8010296c:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102973:	e8 1d 0a 00 00       	call   80103395 <scheduler>

80102978 <mpenter>:
{
80102978:	55                   	push   %ebp
80102979:	89 e5                	mov    %esp,%ebp
8010297b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010297e:	e8 b9 36 00 00       	call   8010603c <switchkvm>
  seginit();
80102983:	e8 6e 33 00 00       	call   80105cf6 <seginit>
  lapicinit();
80102988:	e8 4a f8 ff ff       	call   801021d7 <lapicinit>
  mpmain();
8010298d:	e8 a7 ff ff ff       	call   80102939 <mpmain>

80102992 <main>:
{
80102992:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102996:	83 e4 f0             	and    $0xfffffff0,%esp
80102999:	ff 71 fc             	push   -0x4(%ecx)
8010299c:	55                   	push   %ebp
8010299d:	89 e5                	mov    %esp,%ebp
8010299f:	51                   	push   %ecx
801029a0:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801029a3:	68 00 00 40 80       	push   $0x80400000
801029a8:	68 30 56 11 80       	push   $0x80115630
801029ad:	e8 23 f6 ff ff       	call   80101fd5 <kinit1>
  kvmalloc();      // kernel page table
801029b2:	e8 54 3b 00 00       	call   8010650b <kvmalloc>
  mpinit();        // detect other processors
801029b7:	e8 b8 01 00 00       	call   80102b74 <mpinit>
  lapicinit();     // interrupt controller
801029bc:	e8 16 f8 ff ff       	call   801021d7 <lapicinit>
  seginit();       // segment descriptors
801029c1:	e8 30 33 00 00       	call   80105cf6 <seginit>
  picinit();       // disable pic
801029c6:	e8 79 02 00 00       	call   80102c44 <picinit>
  ioapicinit();    // another interrupt controller
801029cb:	e8 93 f4 ff ff       	call   80101e63 <ioapicinit>
  consoleinit();   // console hardware
801029d0:	e8 77 de ff ff       	call   8010084c <consoleinit>
  uartinit();      // serial port
801029d5:	e8 94 27 00 00       	call   8010516e <uartinit>
  pinit();         // process table
801029da:	e8 8f 06 00 00       	call   8010306e <pinit>
  tvinit();        // trap vectors
801029df:	e8 f2 22 00 00       	call   80104cd6 <tvinit>
  binit();         // buffer cache
801029e4:	e8 09 d7 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
801029e9:	e8 de e1 ff ff       	call   80100bcc <fileinit>
  ideinit();       // disk 
801029ee:	e8 86 f2 ff ff       	call   80101c79 <ideinit>
  startothers();   // start other processors
801029f3:	e8 ac fe ff ff       	call   801028a4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801029f8:	83 c4 08             	add    $0x8,%esp
801029fb:	68 00 00 00 8e       	push   $0x8e000000
80102a00:	68 00 00 40 80       	push   $0x80400000
80102a05:	e8 fd f5 ff ff       	call   80102007 <kinit2>
  userinit();      // first user process
80102a0a:	e8 31 07 00 00       	call   80103140 <userinit>
  mpmain();        // finish this processor's setup
80102a0f:	e8 25 ff ff ff       	call   80102939 <mpmain>

80102a14 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102a14:	55                   	push   %ebp
80102a15:	89 e5                	mov    %esp,%ebp
80102a17:	56                   	push   %esi
80102a18:	53                   	push   %ebx
80102a19:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102a20:	b9 00 00 00 00       	mov    $0x0,%ecx
80102a25:	eb 07                	jmp    80102a2e <sum+0x1a>
    sum += addr[i];
80102a27:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102a2b:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102a2d:	41                   	inc    %ecx
80102a2e:	39 d1                	cmp    %edx,%ecx
80102a30:	7c f5                	jl     80102a27 <sum+0x13>
  return sum;
}
80102a32:	5b                   	pop    %ebx
80102a33:	5e                   	pop    %esi
80102a34:	5d                   	pop    %ebp
80102a35:	c3                   	ret    

80102a36 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102a36:	55                   	push   %ebp
80102a37:	89 e5                	mov    %esp,%ebp
80102a39:	56                   	push   %esi
80102a3a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102a3b:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102a41:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102a43:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102a45:	eb 03                	jmp    80102a4a <mpsearch1+0x14>
80102a47:	83 c3 10             	add    $0x10,%ebx
80102a4a:	39 f3                	cmp    %esi,%ebx
80102a4c:	73 29                	jae    80102a77 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102a4e:	83 ec 04             	sub    $0x4,%esp
80102a51:	6a 04                	push   $0x4
80102a53:	68 f8 6b 10 80       	push   $0x80106bf8
80102a58:	53                   	push   %ebx
80102a59:	e8 79 11 00 00       	call   80103bd7 <memcmp>
80102a5e:	83 c4 10             	add    $0x10,%esp
80102a61:	85 c0                	test   %eax,%eax
80102a63:	75 e2                	jne    80102a47 <mpsearch1+0x11>
80102a65:	ba 10 00 00 00       	mov    $0x10,%edx
80102a6a:	89 d8                	mov    %ebx,%eax
80102a6c:	e8 a3 ff ff ff       	call   80102a14 <sum>
80102a71:	84 c0                	test   %al,%al
80102a73:	75 d2                	jne    80102a47 <mpsearch1+0x11>
80102a75:	eb 05                	jmp    80102a7c <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102a77:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102a7c:	89 d8                	mov    %ebx,%eax
80102a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a81:	5b                   	pop    %ebx
80102a82:	5e                   	pop    %esi
80102a83:	5d                   	pop    %ebp
80102a84:	c3                   	ret    

80102a85 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
80102a88:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102a8b:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102a92:	c1 e0 08             	shl    $0x8,%eax
80102a95:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102a9c:	09 d0                	or     %edx,%eax
80102a9e:	c1 e0 04             	shl    $0x4,%eax
80102aa1:	74 1f                	je     80102ac2 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102aa3:	ba 00 04 00 00       	mov    $0x400,%edx
80102aa8:	e8 89 ff ff ff       	call   80102a36 <mpsearch1>
80102aad:	85 c0                	test   %eax,%eax
80102aaf:	75 0f                	jne    80102ac0 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102ab1:	ba 00 00 01 00       	mov    $0x10000,%edx
80102ab6:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102abb:	e8 76 ff ff ff       	call   80102a36 <mpsearch1>
}
80102ac0:	c9                   	leave  
80102ac1:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102ac2:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ac9:	c1 e0 08             	shl    $0x8,%eax
80102acc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ad3:	09 d0                	or     %edx,%eax
80102ad5:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102ad8:	2d 00 04 00 00       	sub    $0x400,%eax
80102add:	ba 00 04 00 00       	mov    $0x400,%edx
80102ae2:	e8 4f ff ff ff       	call   80102a36 <mpsearch1>
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	75 d5                	jne    80102ac0 <mpsearch+0x3b>
80102aeb:	eb c4                	jmp    80102ab1 <mpsearch+0x2c>

80102aed <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102aed:	55                   	push   %ebp
80102aee:	89 e5                	mov    %esp,%ebp
80102af0:	57                   	push   %edi
80102af1:	56                   	push   %esi
80102af2:	53                   	push   %ebx
80102af3:	83 ec 1c             	sub    $0x1c,%esp
80102af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102af9:	e8 87 ff ff ff       	call   80102a85 <mpsearch>
80102afe:	89 c3                	mov    %eax,%ebx
80102b00:	85 c0                	test   %eax,%eax
80102b02:	74 53                	je     80102b57 <mpconfig+0x6a>
80102b04:	8b 70 04             	mov    0x4(%eax),%esi
80102b07:	85 f6                	test   %esi,%esi
80102b09:	74 50                	je     80102b5b <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102b0b:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102b11:	83 ec 04             	sub    $0x4,%esp
80102b14:	6a 04                	push   $0x4
80102b16:	68 fd 6b 10 80       	push   $0x80106bfd
80102b1b:	57                   	push   %edi
80102b1c:	e8 b6 10 00 00       	call   80103bd7 <memcmp>
80102b21:	83 c4 10             	add    $0x10,%esp
80102b24:	85 c0                	test   %eax,%eax
80102b26:	75 37                	jne    80102b5f <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102b28:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102b2e:	3c 01                	cmp    $0x1,%al
80102b30:	74 04                	je     80102b36 <mpconfig+0x49>
80102b32:	3c 04                	cmp    $0x4,%al
80102b34:	75 30                	jne    80102b66 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102b36:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102b3d:	89 f8                	mov    %edi,%eax
80102b3f:	e8 d0 fe ff ff       	call   80102a14 <sum>
80102b44:	84 c0                	test   %al,%al
80102b46:	75 25                	jne    80102b6d <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102b4b:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102b4d:	89 f8                	mov    %edi,%eax
80102b4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b52:	5b                   	pop    %ebx
80102b53:	5e                   	pop    %esi
80102b54:	5f                   	pop    %edi
80102b55:	5d                   	pop    %ebp
80102b56:	c3                   	ret    
    return 0;
80102b57:	89 c7                	mov    %eax,%edi
80102b59:	eb f2                	jmp    80102b4d <mpconfig+0x60>
80102b5b:	89 f7                	mov    %esi,%edi
80102b5d:	eb ee                	jmp    80102b4d <mpconfig+0x60>
    return 0;
80102b5f:	bf 00 00 00 00       	mov    $0x0,%edi
80102b64:	eb e7                	jmp    80102b4d <mpconfig+0x60>
    return 0;
80102b66:	bf 00 00 00 00       	mov    $0x0,%edi
80102b6b:	eb e0                	jmp    80102b4d <mpconfig+0x60>
    return 0;
80102b6d:	bf 00 00 00 00       	mov    $0x0,%edi
80102b72:	eb d9                	jmp    80102b4d <mpconfig+0x60>

80102b74 <mpinit>:

void
mpinit(void)
{
80102b74:	55                   	push   %ebp
80102b75:	89 e5                	mov    %esp,%ebp
80102b77:	57                   	push   %edi
80102b78:	56                   	push   %esi
80102b79:	53                   	push   %ebx
80102b7a:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102b7d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102b80:	e8 68 ff ff ff       	call   80102aed <mpconfig>
80102b85:	85 c0                	test   %eax,%eax
80102b87:	74 19                	je     80102ba2 <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102b89:	8b 50 24             	mov    0x24(%eax),%edx
80102b8c:	89 15 80 16 11 80    	mov    %edx,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102b92:	8d 50 2c             	lea    0x2c(%eax),%edx
80102b95:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102b99:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102b9b:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ba0:	eb 20                	jmp    80102bc2 <mpinit+0x4e>
    panic("Expect to run on an SMP");
80102ba2:	83 ec 0c             	sub    $0xc,%esp
80102ba5:	68 02 6c 10 80       	push   $0x80106c02
80102baa:	e8 92 d7 ff ff       	call   80100341 <panic>
    switch(*p){
80102baf:	bf 00 00 00 00       	mov    $0x0,%edi
80102bb4:	eb 0c                	jmp    80102bc2 <mpinit+0x4e>
80102bb6:	83 e8 03             	sub    $0x3,%eax
80102bb9:	3c 01                	cmp    $0x1,%al
80102bbb:	76 19                	jbe    80102bd6 <mpinit+0x62>
80102bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102bc2:	39 ca                	cmp    %ecx,%edx
80102bc4:	73 4a                	jae    80102c10 <mpinit+0x9c>
    switch(*p){
80102bc6:	8a 02                	mov    (%edx),%al
80102bc8:	3c 02                	cmp    $0x2,%al
80102bca:	74 37                	je     80102c03 <mpinit+0x8f>
80102bcc:	77 e8                	ja     80102bb6 <mpinit+0x42>
80102bce:	84 c0                	test   %al,%al
80102bd0:	74 09                	je     80102bdb <mpinit+0x67>
80102bd2:	3c 01                	cmp    $0x1,%al
80102bd4:	75 d9                	jne    80102baf <mpinit+0x3b>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102bd6:	83 c2 08             	add    $0x8,%edx
      continue;
80102bd9:	eb e7                	jmp    80102bc2 <mpinit+0x4e>
      if(ncpu < NCPU) {
80102bdb:	a1 84 17 11 80       	mov    0x80111784,%eax
80102be0:	83 f8 07             	cmp    $0x7,%eax
80102be3:	7f 19                	jg     80102bfe <mpinit+0x8a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102be5:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102be8:	01 f6                	add    %esi,%esi
80102bea:	01 c6                	add    %eax,%esi
80102bec:	c1 e6 04             	shl    $0x4,%esi
80102bef:	8a 5a 01             	mov    0x1(%edx),%bl
80102bf2:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80102bf8:	40                   	inc    %eax
80102bf9:	a3 84 17 11 80       	mov    %eax,0x80111784
      p += sizeof(struct mpproc);
80102bfe:	83 c2 14             	add    $0x14,%edx
      continue;
80102c01:	eb bf                	jmp    80102bc2 <mpinit+0x4e>
      ioapicid = ioapic->apicno;
80102c03:	8a 42 01             	mov    0x1(%edx),%al
80102c06:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102c0b:	83 c2 08             	add    $0x8,%edx
      continue;
80102c0e:	eb b2                	jmp    80102bc2 <mpinit+0x4e>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102c10:	85 ff                	test   %edi,%edi
80102c12:	74 23                	je     80102c37 <mpinit+0xc3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c17:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102c1b:	74 12                	je     80102c2f <mpinit+0xbb>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1d:	b0 70                	mov    $0x70,%al
80102c1f:	ba 22 00 00 00       	mov    $0x22,%edx
80102c24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c25:	ba 23 00 00 00       	mov    $0x23,%edx
80102c2a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102c2b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2e:	ee                   	out    %al,(%dx)
  }
}
80102c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c32:	5b                   	pop    %ebx
80102c33:	5e                   	pop    %esi
80102c34:	5f                   	pop    %edi
80102c35:	5d                   	pop    %ebp
80102c36:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102c37:	83 ec 0c             	sub    $0xc,%esp
80102c3a:	68 1c 6c 10 80       	push   $0x80106c1c
80102c3f:	e8 fd d6 ff ff       	call   80100341 <panic>

80102c44 <picinit>:
80102c44:	f3 0f 1e fb          	endbr32 
80102c48:	b0 ff                	mov    $0xff,%al
80102c4a:	ba 21 00 00 00       	mov    $0x21,%edx
80102c4f:	ee                   	out    %al,(%dx)
80102c50:	ba a1 00 00 00       	mov    $0xa1,%edx
80102c55:	ee                   	out    %al,(%dx)
80102c56:	c3                   	ret    

80102c57 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102c57:	55                   	push   %ebp
80102c58:	89 e5                	mov    %esp,%ebp
80102c5a:	57                   	push   %edi
80102c5b:	56                   	push   %esi
80102c5c:	53                   	push   %ebx
80102c5d:	83 ec 0c             	sub    $0xc,%esp
80102c60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c63:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102c66:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102c6c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102c72:	e8 6f df ff ff       	call   80100be6 <filealloc>
80102c77:	89 03                	mov    %eax,(%ebx)
80102c79:	85 c0                	test   %eax,%eax
80102c7b:	0f 84 88 00 00 00    	je     80102d09 <pipealloc+0xb2>
80102c81:	e8 60 df ff ff       	call   80100be6 <filealloc>
80102c86:	89 06                	mov    %eax,(%esi)
80102c88:	85 c0                	test   %eax,%eax
80102c8a:	74 7d                	je     80102d09 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102c8c:	e8 96 f3 ff ff       	call   80102027 <kalloc>
80102c91:	89 c7                	mov    %eax,%edi
80102c93:	85 c0                	test   %eax,%eax
80102c95:	74 72                	je     80102d09 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102c97:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102c9e:	00 00 00 
  p->writeopen = 1;
80102ca1:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102ca8:	00 00 00 
  p->nwrite = 0;
80102cab:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102cb2:	00 00 00 
  p->nread = 0;
80102cb5:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102cbc:	00 00 00 
  initlock(&p->lock, "pipe");
80102cbf:	83 ec 08             	sub    $0x8,%esp
80102cc2:	68 3b 6c 10 80       	push   $0x80106c3b
80102cc7:	50                   	push   %eax
80102cc8:	e8 dc 0c 00 00       	call   801039a9 <initlock>
  (*f0)->type = FD_PIPE;
80102ccd:	8b 03                	mov    (%ebx),%eax
80102ccf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102cd5:	8b 03                	mov    (%ebx),%eax
80102cd7:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102cdb:	8b 03                	mov    (%ebx),%eax
80102cdd:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102ce1:	8b 03                	mov    (%ebx),%eax
80102ce3:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ce6:	8b 06                	mov    (%esi),%eax
80102ce8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102cee:	8b 06                	mov    (%esi),%eax
80102cf0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102cf4:	8b 06                	mov    (%esi),%eax
80102cf6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102cfa:	8b 06                	mov    (%esi),%eax
80102cfc:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102cff:	83 c4 10             	add    $0x10,%esp
80102d02:	b8 00 00 00 00       	mov    $0x0,%eax
80102d07:	eb 29                	jmp    80102d32 <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102d09:	8b 03                	mov    (%ebx),%eax
80102d0b:	85 c0                	test   %eax,%eax
80102d0d:	74 0c                	je     80102d1b <pipealloc+0xc4>
    fileclose(*f0);
80102d0f:	83 ec 0c             	sub    $0xc,%esp
80102d12:	50                   	push   %eax
80102d13:	e8 72 df ff ff       	call   80100c8a <fileclose>
80102d18:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102d1b:	8b 06                	mov    (%esi),%eax
80102d1d:	85 c0                	test   %eax,%eax
80102d1f:	74 19                	je     80102d3a <pipealloc+0xe3>
    fileclose(*f1);
80102d21:	83 ec 0c             	sub    $0xc,%esp
80102d24:	50                   	push   %eax
80102d25:	e8 60 df ff ff       	call   80100c8a <fileclose>
80102d2a:	83 c4 10             	add    $0x10,%esp
  return -1;
80102d2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d35:	5b                   	pop    %ebx
80102d36:	5e                   	pop    %esi
80102d37:	5f                   	pop    %edi
80102d38:	5d                   	pop    %ebp
80102d39:	c3                   	ret    
  return -1;
80102d3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d3f:	eb f1                	jmp    80102d32 <pipealloc+0xdb>

80102d41 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102d41:	55                   	push   %ebp
80102d42:	89 e5                	mov    %esp,%ebp
80102d44:	53                   	push   %ebx
80102d45:	83 ec 10             	sub    $0x10,%esp
80102d48:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102d4b:	53                   	push   %ebx
80102d4c:	e8 8f 0d 00 00       	call   80103ae0 <acquire>
  if(writable){
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102d58:	74 3f                	je     80102d99 <pipeclose+0x58>
    p->writeopen = 0;
80102d5a:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102d61:	00 00 00 
    wakeup(&p->nread);
80102d64:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102d6a:	83 ec 0c             	sub    $0xc,%esp
80102d6d:	50                   	push   %eax
80102d6e:	e8 de 09 00 00       	call   80103751 <wakeup>
80102d73:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102d76:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102d7d:	75 09                	jne    80102d88 <pipeclose+0x47>
80102d7f:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102d86:	74 2f                	je     80102db7 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102d88:	83 ec 0c             	sub    $0xc,%esp
80102d8b:	53                   	push   %ebx
80102d8c:	e8 b4 0d 00 00       	call   80103b45 <release>
80102d91:	83 c4 10             	add    $0x10,%esp
}
80102d94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d97:	c9                   	leave  
80102d98:	c3                   	ret    
    p->readopen = 0;
80102d99:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102da0:	00 00 00 
    wakeup(&p->nwrite);
80102da3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102da9:	83 ec 0c             	sub    $0xc,%esp
80102dac:	50                   	push   %eax
80102dad:	e8 9f 09 00 00       	call   80103751 <wakeup>
80102db2:	83 c4 10             	add    $0x10,%esp
80102db5:	eb bf                	jmp    80102d76 <pipeclose+0x35>
    release(&p->lock);
80102db7:	83 ec 0c             	sub    $0xc,%esp
80102dba:	53                   	push   %ebx
80102dbb:	e8 85 0d 00 00       	call   80103b45 <release>
    kfree((char*)p);
80102dc0:	89 1c 24             	mov    %ebx,(%esp)
80102dc3:	e8 48 f1 ff ff       	call   80101f10 <kfree>
80102dc8:	83 c4 10             	add    $0x10,%esp
80102dcb:	eb c7                	jmp    80102d94 <pipeclose+0x53>

80102dcd <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102dcd:	55                   	push   %ebp
80102dce:	89 e5                	mov    %esp,%ebp
80102dd0:	56                   	push   %esi
80102dd1:	53                   	push   %ebx
80102dd2:	83 ec 1c             	sub    $0x1c,%esp
80102dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102dd8:	53                   	push   %ebx
80102dd9:	e8 02 0d 00 00       	call   80103ae0 <acquire>
  for(i = 0; i < n; i++){
80102dde:	83 c4 10             	add    $0x10,%esp
80102de1:	be 00 00 00 00       	mov    $0x0,%esi
80102de6:	3b 75 10             	cmp    0x10(%ebp),%esi
80102de9:	7c 41                	jl     80102e2c <pipewrite+0x5f>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102deb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102df1:	83 ec 0c             	sub    $0xc,%esp
80102df4:	50                   	push   %eax
80102df5:	e8 57 09 00 00       	call   80103751 <wakeup>
  release(&p->lock);
80102dfa:	89 1c 24             	mov    %ebx,(%esp)
80102dfd:	e8 43 0d 00 00       	call   80103b45 <release>
  return n;
80102e02:	83 c4 10             	add    $0x10,%esp
80102e05:	8b 45 10             	mov    0x10(%ebp),%eax
80102e08:	eb 5c                	jmp    80102e66 <pipewrite+0x99>
      wakeup(&p->nread);
80102e0a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e10:	83 ec 0c             	sub    $0xc,%esp
80102e13:	50                   	push   %eax
80102e14:	e8 38 09 00 00       	call   80103751 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102e19:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e1f:	83 c4 08             	add    $0x8,%esp
80102e22:	53                   	push   %ebx
80102e23:	50                   	push   %eax
80102e24:	e8 a6 07 00 00       	call   801035cf <sleep>
80102e29:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102e2c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102e32:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102e38:	05 00 02 00 00       	add    $0x200,%eax
80102e3d:	39 c2                	cmp    %eax,%edx
80102e3f:	75 2c                	jne    80102e6d <pipewrite+0xa0>
      if(p->readopen == 0 || myproc()->killed){
80102e41:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e48:	74 0b                	je     80102e55 <pipewrite+0x88>
80102e4a:	e8 ce 02 00 00       	call   8010311d <myproc>
80102e4f:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102e53:	74 b5                	je     80102e0a <pipewrite+0x3d>
        release(&p->lock);
80102e55:	83 ec 0c             	sub    $0xc,%esp
80102e58:	53                   	push   %ebx
80102e59:	e8 e7 0c 00 00       	call   80103b45 <release>
        return -1;
80102e5e:	83 c4 10             	add    $0x10,%esp
80102e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e69:	5b                   	pop    %ebx
80102e6a:	5e                   	pop    %esi
80102e6b:	5d                   	pop    %ebp
80102e6c:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102e6d:	8d 42 01             	lea    0x1(%edx),%eax
80102e70:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102e76:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e7f:	8a 04 30             	mov    (%eax,%esi,1),%al
80102e82:	88 45 f7             	mov    %al,-0x9(%ebp)
80102e85:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102e89:	46                   	inc    %esi
80102e8a:	e9 57 ff ff ff       	jmp    80102de6 <pipewrite+0x19>

80102e8f <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102e8f:	55                   	push   %ebp
80102e90:	89 e5                	mov    %esp,%ebp
80102e92:	57                   	push   %edi
80102e93:	56                   	push   %esi
80102e94:	53                   	push   %ebx
80102e95:	83 ec 18             	sub    $0x18,%esp
80102e98:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e9b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80102e9e:	53                   	push   %ebx
80102e9f:	e8 3c 0c 00 00       	call   80103ae0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ea4:	83 c4 10             	add    $0x10,%esp
80102ea7:	eb 13                	jmp    80102ebc <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102ea9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	53                   	push   %ebx
80102eb3:	50                   	push   %eax
80102eb4:	e8 16 07 00 00       	call   801035cf <sleep>
80102eb9:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ebc:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102ec2:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102ec8:	75 75                	jne    80102f3f <piperead+0xb0>
80102eca:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102ed0:	85 f6                	test   %esi,%esi
80102ed2:	74 34                	je     80102f08 <piperead+0x79>
    if(myproc()->killed){
80102ed4:	e8 44 02 00 00       	call   8010311d <myproc>
80102ed9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102edd:	74 ca                	je     80102ea9 <piperead+0x1a>
      release(&p->lock);
80102edf:	83 ec 0c             	sub    $0xc,%esp
80102ee2:	53                   	push   %ebx
80102ee3:	e8 5d 0c 00 00       	call   80103b45 <release>
      return -1;
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102ef0:	eb 43                	jmp    80102f35 <piperead+0xa6>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102ef2:	8d 50 01             	lea    0x1(%eax),%edx
80102ef5:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102efb:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f00:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80102f04:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102f07:	46                   	inc    %esi
80102f08:	3b 75 10             	cmp    0x10(%ebp),%esi
80102f0b:	7d 0e                	jge    80102f1b <piperead+0x8c>
    if(p->nread == p->nwrite)
80102f0d:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f13:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102f19:	75 d7                	jne    80102ef2 <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102f1b:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f21:	83 ec 0c             	sub    $0xc,%esp
80102f24:	50                   	push   %eax
80102f25:	e8 27 08 00 00       	call   80103751 <wakeup>
  release(&p->lock);
80102f2a:	89 1c 24             	mov    %ebx,(%esp)
80102f2d:	e8 13 0c 00 00       	call   80103b45 <release>
  return i;
80102f32:	83 c4 10             	add    $0x10,%esp
}
80102f35:	89 f0                	mov    %esi,%eax
80102f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3a:	5b                   	pop    %ebx
80102f3b:	5e                   	pop    %esi
80102f3c:	5f                   	pop    %edi
80102f3d:	5d                   	pop    %ebp
80102f3e:	c3                   	ret    
80102f3f:	be 00 00 00 00       	mov    $0x0,%esi
80102f44:	eb c2                	jmp    80102f08 <piperead+0x79>

80102f46 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102f46:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80102f4b:	eb 03                	jmp    80102f50 <wakeup1+0xa>
80102f4d:	83 ea 80             	sub    $0xffffff80,%edx
80102f50:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
80102f56:	73 14                	jae    80102f6c <wakeup1+0x26>
    if(p->state == SLEEPING && p->chan == chan)
80102f58:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80102f5c:	75 ef                	jne    80102f4d <wakeup1+0x7>
80102f5e:	39 42 20             	cmp    %eax,0x20(%edx)
80102f61:	75 ea                	jne    80102f4d <wakeup1+0x7>
      p->state = RUNNABLE;
80102f63:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80102f6a:	eb e1                	jmp    80102f4d <wakeup1+0x7>
}
80102f6c:	c3                   	ret    

80102f6d <allocproc>:
{
80102f6d:	55                   	push   %ebp
80102f6e:	89 e5                	mov    %esp,%ebp
80102f70:	53                   	push   %ebx
80102f71:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); //Cerrojo para exclusion mutua
80102f74:	68 20 1d 11 80       	push   $0x80111d20
80102f79:	e8 62 0b 00 00       	call   80103ae0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) //Busca el primer proceso(PID) libre
80102f7e:	83 c4 10             	add    $0x10,%esp
80102f81:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80102f86:	eb 03                	jmp    80102f8b <allocproc+0x1e>
80102f88:	83 eb 80             	sub    $0xffffff80,%ebx
80102f8b:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80102f91:	73 76                	jae    80103009 <allocproc+0x9c>
    if(p->state == UNUSED)
80102f93:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80102f97:	75 ef                	jne    80102f88 <allocproc+0x1b>
  p->state = EMBRYO; //Pone el estado del nuevo proceso en embrion
80102f99:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++; //nextpid almacena el último PID usado
80102fa0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80102fa5:	8d 50 01             	lea    0x1(%eax),%edx
80102fa8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80102fae:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80102fb1:	83 ec 0c             	sub    $0xc,%esp
80102fb4:	68 20 1d 11 80       	push   $0x80111d20
80102fb9:	e8 87 0b 00 00       	call   80103b45 <release>
  if((p->kstack = kalloc()) == 0){ //Busca una pagina libre en el kernel
80102fbe:	e8 64 f0 ff ff       	call   80102027 <kalloc>
80102fc3:	89 43 08             	mov    %eax,0x8(%ebx)
80102fc6:	83 c4 10             	add    $0x10,%esp
80102fc9:	85 c0                	test   %eax,%eax
80102fcb:	74 53                	je     80103020 <allocproc+0xb3>
  sp -= sizeof *p->tf; //puntero para el trap frame
80102fcd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp; //Guarda el puntero en tf
80102fd3:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret; //Trapret es la llamada para vaciar le trapframe
80102fd6:	c7 80 b0 0f 00 00 cb 	movl   $0x80104ccb,0xfb0(%eax)
80102fdd:	4c 10 80 
  sp -= sizeof *p->context; //Puntero para el contexto(para movernos dentro de los hilos del kernel)
80102fe0:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80102fe5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80102fe8:	83 ec 04             	sub    $0x4,%esp
80102feb:	6a 14                	push   $0x14
80102fed:	6a 00                	push   $0x0
80102fef:	50                   	push   %eax
80102ff0:	e8 97 0b 00 00       	call   80103b8c <memset>
  p->context->eip = (uint)forkret;
80102ff5:	8b 43 1c             	mov    0x1c(%ebx),%eax
80102ff8:	c7 40 10 2b 30 10 80 	movl   $0x8010302b,0x10(%eax)
  return p;
80102fff:	83 c4 10             	add    $0x10,%esp
}
80103002:	89 d8                	mov    %ebx,%eax
80103004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103007:	c9                   	leave  
80103008:	c3                   	ret    
  release(&ptable.lock);
80103009:	83 ec 0c             	sub    $0xc,%esp
8010300c:	68 20 1d 11 80       	push   $0x80111d20
80103011:	e8 2f 0b 00 00       	call   80103b45 <release>
  return 0;
80103016:	83 c4 10             	add    $0x10,%esp
80103019:	bb 00 00 00 00       	mov    $0x0,%ebx
8010301e:	eb e2                	jmp    80103002 <allocproc+0x95>
    p->state = UNUSED;
80103020:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103027:	89 c3                	mov    %eax,%ebx
80103029:	eb d7                	jmp    80103002 <allocproc+0x95>

8010302b <forkret>:
{
8010302b:	55                   	push   %ebp
8010302c:	89 e5                	mov    %esp,%ebp
8010302e:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103031:	68 20 1d 11 80       	push   $0x80111d20
80103036:	e8 0a 0b 00 00       	call   80103b45 <release>
  if (first) {
8010303b:	83 c4 10             	add    $0x10,%esp
8010303e:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103045:	75 02                	jne    80103049 <forkret+0x1e>
}
80103047:	c9                   	leave  
80103048:	c3                   	ret    
    first = 0;
80103049:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103050:	00 00 00 
    iinit(ROOTDEV);
80103053:	83 ec 0c             	sub    $0xc,%esp
80103056:	6a 01                	push   $0x1
80103058:	e8 21 e2 ff ff       	call   8010127e <iinit>
    initlog(ROOTDEV);
8010305d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103064:	e8 2a f6 ff ff       	call   80102693 <initlog>
80103069:	83 c4 10             	add    $0x10,%esp
}
8010306c:	eb d9                	jmp    80103047 <forkret+0x1c>

8010306e <pinit>:
{
8010306e:	55                   	push   %ebp
8010306f:	89 e5                	mov    %esp,%ebp
80103071:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103074:	68 40 6c 10 80       	push   $0x80106c40
80103079:	68 20 1d 11 80       	push   $0x80111d20
8010307e:	e8 26 09 00 00       	call   801039a9 <initlock>
}
80103083:	83 c4 10             	add    $0x10,%esp
80103086:	c9                   	leave  
80103087:	c3                   	ret    

80103088 <mycpu>:
{
80103088:	55                   	push   %ebp
80103089:	89 e5                	mov    %esp,%ebp
8010308b:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010308e:	9c                   	pushf  
8010308f:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103090:	f6 c4 02             	test   $0x2,%ah
80103093:	75 2c                	jne    801030c1 <mycpu+0x39>
  apicid = lapicid();
80103095:	e8 49 f2 ff ff       	call   801022e3 <lapicid>
8010309a:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
8010309c:	ba 00 00 00 00       	mov    $0x0,%edx
801030a1:	39 15 84 17 11 80    	cmp    %edx,0x80111784
801030a7:	7e 25                	jle    801030ce <mycpu+0x46>
    if (cpus[i].apicid == apicid)
801030a9:	8d 04 92             	lea    (%edx,%edx,4),%eax
801030ac:	01 c0                	add    %eax,%eax
801030ae:	01 d0                	add    %edx,%eax
801030b0:	c1 e0 04             	shl    $0x4,%eax
801030b3:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
801030ba:	39 c8                	cmp    %ecx,%eax
801030bc:	74 1d                	je     801030db <mycpu+0x53>
  for (i = 0; i < ncpu; ++i) {
801030be:	42                   	inc    %edx
801030bf:	eb e0                	jmp    801030a1 <mycpu+0x19>
    panic("mycpu called with interrupts enabled\n");
801030c1:	83 ec 0c             	sub    $0xc,%esp
801030c4:	68 24 6d 10 80       	push   $0x80106d24
801030c9:	e8 73 d2 ff ff       	call   80100341 <panic>
  panic("unknown apicid\n");
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 47 6c 10 80       	push   $0x80106c47
801030d6:	e8 66 d2 ff ff       	call   80100341 <panic>
      return &cpus[i];
801030db:	8d 04 92             	lea    (%edx,%edx,4),%eax
801030de:	01 c0                	add    %eax,%eax
801030e0:	01 d0                	add    %edx,%eax
801030e2:	c1 e0 04             	shl    $0x4,%eax
801030e5:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801030ea:	c9                   	leave  
801030eb:	c3                   	ret    

801030ec <cpuid>:
cpuid() {
801030ec:	55                   	push   %ebp
801030ed:	89 e5                	mov    %esp,%ebp
801030ef:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801030f2:	e8 91 ff ff ff       	call   80103088 <mycpu>
801030f7:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801030fc:	c1 f8 04             	sar    $0x4,%eax
801030ff:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103102:	89 ca                	mov    %ecx,%edx
80103104:	c1 e2 05             	shl    $0x5,%edx
80103107:	29 ca                	sub    %ecx,%edx
80103109:	8d 14 90             	lea    (%eax,%edx,4),%edx
8010310c:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010310f:	89 ca                	mov    %ecx,%edx
80103111:	c1 e2 0f             	shl    $0xf,%edx
80103114:	29 ca                	sub    %ecx,%edx
80103116:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103119:	f7 d8                	neg    %eax
}
8010311b:	c9                   	leave  
8010311c:	c3                   	ret    

8010311d <myproc>:
myproc(void) {
8010311d:	55                   	push   %ebp
8010311e:	89 e5                	mov    %esp,%ebp
80103120:	53                   	push   %ebx
80103121:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103124:	e8 dd 08 00 00       	call   80103a06 <pushcli>
  c = mycpu();
80103129:	e8 5a ff ff ff       	call   80103088 <mycpu>
  p = c->proc;
8010312e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103134:	e8 08 09 00 00       	call   80103a41 <popcli>
}
80103139:	89 d8                	mov    %ebx,%eax
8010313b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010313e:	c9                   	leave  
8010313f:	c3                   	ret    

80103140 <userinit>:
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	53                   	push   %ebx
80103144:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103147:	e8 21 fe ff ff       	call   80102f6d <allocproc>
8010314c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010314e:	a3 a4 3d 11 80       	mov    %eax,0x80113da4
  if((p->pgdir = setupkvm()) == 0)
80103153:	e8 43 33 00 00       	call   8010649b <setupkvm>
80103158:	89 43 04             	mov    %eax,0x4(%ebx)
8010315b:	85 c0                	test   %eax,%eax
8010315d:	0f 84 b6 00 00 00    	je     80103219 <userinit+0xd9>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103163:	83 ec 04             	sub    $0x4,%esp
80103166:	68 2c 00 00 00       	push   $0x2c
8010316b:	68 60 a4 10 80       	push   $0x8010a460
80103170:	50                   	push   %eax
80103171:	e8 30 30 00 00       	call   801061a6 <inituvm>
  p->sz = PGSIZE;
80103176:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010317c:	8b 43 18             	mov    0x18(%ebx),%eax
8010317f:	83 c4 0c             	add    $0xc,%esp
80103182:	6a 4c                	push   $0x4c
80103184:	6a 00                	push   $0x0
80103186:	50                   	push   %eax
80103187:	e8 00 0a 00 00       	call   80103b8c <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010318c:	8b 43 18             	mov    0x18(%ebx),%eax
8010318f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103195:	8b 43 18             	mov    0x18(%ebx),%eax
80103198:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010319e:	8b 43 18             	mov    0x18(%ebx),%eax
801031a1:	8b 50 2c             	mov    0x2c(%eax),%edx
801031a4:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801031a8:	8b 43 18             	mov    0x18(%ebx),%eax
801031ab:	8b 50 2c             	mov    0x2c(%eax),%edx
801031ae:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801031b2:	8b 43 18             	mov    0x18(%ebx),%eax
801031b5:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801031bc:	8b 43 18             	mov    0x18(%ebx),%eax
801031bf:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801031c6:	8b 43 18             	mov    0x18(%ebx),%eax
801031c9:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801031d0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801031d3:	83 c4 0c             	add    $0xc,%esp
801031d6:	6a 10                	push   $0x10
801031d8:	68 70 6c 10 80       	push   $0x80106c70
801031dd:	50                   	push   %eax
801031de:	e8 15 0b 00 00       	call   80103cf8 <safestrcpy>
  p->cwd = namei("/");
801031e3:	c7 04 24 79 6c 10 80 	movl   $0x80106c79,(%esp)
801031ea:	e8 7b e9 ff ff       	call   80101b6a <namei>
801031ef:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801031f2:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801031f9:	e8 e2 08 00 00       	call   80103ae0 <acquire>
  p->state = RUNNABLE;
801031fe:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103205:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010320c:	e8 34 09 00 00       	call   80103b45 <release>
}
80103211:	83 c4 10             	add    $0x10,%esp
80103214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103217:	c9                   	leave  
80103218:	c3                   	ret    
    panic("userinit: out of memory?");
80103219:	83 ec 0c             	sub    $0xc,%esp
8010321c:	68 57 6c 10 80       	push   $0x80106c57
80103221:	e8 1b d1 ff ff       	call   80100341 <panic>

80103226 <growproc>:
{
80103226:	55                   	push   %ebp
80103227:	89 e5                	mov    %esp,%ebp
80103229:	56                   	push   %esi
8010322a:	53                   	push   %ebx
8010322b:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010322e:	e8 ea fe ff ff       	call   8010311d <myproc>
80103233:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103235:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103237:	85 f6                	test   %esi,%esi
80103239:	7f 1b                	jg     80103256 <growproc+0x30>
  } else if(n < 0){
8010323b:	78 36                	js     80103273 <growproc+0x4d>
  curproc->sz = sz;
8010323d:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
8010323f:	8b 43 04             	mov    0x4(%ebx),%eax
80103242:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80103247:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010324a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010324f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103252:	5b                   	pop    %ebx
80103253:	5e                   	pop    %esi
80103254:	5d                   	pop    %ebp
80103255:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103256:	83 ec 04             	sub    $0x4,%esp
80103259:	01 c6                	add    %eax,%esi
8010325b:	56                   	push   %esi
8010325c:	50                   	push   %eax
8010325d:	ff 73 04             	push   0x4(%ebx)
80103260:	e8 d3 30 00 00       	call   80106338 <allocuvm>
80103265:	83 c4 10             	add    $0x10,%esp
80103268:	85 c0                	test   %eax,%eax
8010326a:	75 d1                	jne    8010323d <growproc+0x17>
      return -1;
8010326c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103271:	eb dc                	jmp    8010324f <growproc+0x29>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103273:	83 ec 04             	sub    $0x4,%esp
80103276:	01 c6                	add    %eax,%esi
80103278:	56                   	push   %esi
80103279:	50                   	push   %eax
8010327a:	ff 73 04             	push   0x4(%ebx)
8010327d:	e8 26 30 00 00       	call   801062a8 <deallocuvm>
80103282:	83 c4 10             	add    $0x10,%esp
80103285:	85 c0                	test   %eax,%eax
80103287:	75 b4                	jne    8010323d <growproc+0x17>
      return -1;
80103289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010328e:	eb bf                	jmp    8010324f <growproc+0x29>

80103290 <fork>:
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103299:	e8 7f fe ff ff       	call   8010311d <myproc>
8010329e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801032a0:	e8 c8 fc ff ff       	call   80102f6d <allocproc>
801032a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032a8:	85 c0                	test   %eax,%eax
801032aa:	0f 84 de 00 00 00    	je     8010338e <fork+0xfe>
801032b0:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801032b2:	83 ec 08             	sub    $0x8,%esp
801032b5:	ff 33                	push   (%ebx)
801032b7:	ff 73 04             	push   0x4(%ebx)
801032ba:	e8 8f 32 00 00       	call   8010654e <copyuvm>
801032bf:	89 47 04             	mov    %eax,0x4(%edi)
801032c2:	83 c4 10             	add    $0x10,%esp
801032c5:	85 c0                	test   %eax,%eax
801032c7:	74 2a                	je     801032f3 <fork+0x63>
  np->sz = curproc->sz;
801032c9:	8b 03                	mov    (%ebx),%eax
801032cb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801032ce:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801032d0:	89 c8                	mov    %ecx,%eax
801032d2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801032d5:	8b 73 18             	mov    0x18(%ebx),%esi
801032d8:	8b 79 18             	mov    0x18(%ecx),%edi
801032db:	b9 13 00 00 00       	mov    $0x13,%ecx
801032e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801032e2:	8b 40 18             	mov    0x18(%eax),%eax
801032e5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801032ec:	be 00 00 00 00       	mov    $0x0,%esi
801032f1:	eb 27                	jmp    8010331a <fork+0x8a>
    kfree(np->kstack);
801032f3:	83 ec 0c             	sub    $0xc,%esp
801032f6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032f9:	ff 73 08             	push   0x8(%ebx)
801032fc:	e8 0f ec ff ff       	call   80101f10 <kfree>
    np->kstack = 0;
80103301:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103308:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010330f:	83 c4 10             	add    $0x10,%esp
80103312:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103317:	eb 6b                	jmp    80103384 <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
80103319:	46                   	inc    %esi
8010331a:	83 fe 0f             	cmp    $0xf,%esi
8010331d:	7f 1d                	jg     8010333c <fork+0xac>
    if(curproc->ofile[i])
8010331f:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103323:	85 c0                	test   %eax,%eax
80103325:	74 f2                	je     80103319 <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103327:	83 ec 0c             	sub    $0xc,%esp
8010332a:	50                   	push   %eax
8010332b:	e8 17 d9 ff ff       	call   80100c47 <filedup>
80103330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103333:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103337:	83 c4 10             	add    $0x10,%esp
8010333a:	eb dd                	jmp    80103319 <fork+0x89>
  np->cwd = idup(curproc->cwd);
8010333c:	83 ec 0c             	sub    $0xc,%esp
8010333f:	ff 73 68             	push   0x68(%ebx)
80103342:	e8 91 e1 ff ff       	call   801014d8 <idup>
80103347:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010334a:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010334d:	83 c3 6c             	add    $0x6c,%ebx
80103350:	8d 47 6c             	lea    0x6c(%edi),%eax
80103353:	83 c4 0c             	add    $0xc,%esp
80103356:	6a 10                	push   $0x10
80103358:	53                   	push   %ebx
80103359:	50                   	push   %eax
8010335a:	e8 99 09 00 00       	call   80103cf8 <safestrcpy>
  pid = np->pid;
8010335f:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103362:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103369:	e8 72 07 00 00       	call   80103ae0 <acquire>
  np->state = RUNNABLE;
8010336e:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103375:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010337c:	e8 c4 07 00 00       	call   80103b45 <release>
  return pid;
80103381:	83 c4 10             	add    $0x10,%esp
}
80103384:	89 d8                	mov    %ebx,%eax
80103386:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103389:	5b                   	pop    %ebx
8010338a:	5e                   	pop    %esi
8010338b:	5f                   	pop    %edi
8010338c:	5d                   	pop    %ebp
8010338d:	c3                   	ret    
    return -1;
8010338e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103393:	eb ef                	jmp    80103384 <fork+0xf4>

80103395 <scheduler>:
{
80103395:	55                   	push   %ebp
80103396:	89 e5                	mov    %esp,%ebp
80103398:	56                   	push   %esi
80103399:	53                   	push   %ebx
  struct cpu *c = mycpu();
8010339a:	e8 e9 fc ff ff       	call   80103088 <mycpu>
8010339f:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801033a1:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801033a8:	00 00 00 
801033ab:	eb 5a                	jmp    80103407 <scheduler+0x72>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801033ad:	83 eb 80             	sub    $0xffffff80,%ebx
801033b0:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
801033b6:	73 3f                	jae    801033f7 <scheduler+0x62>
      if(p->state != RUNNABLE)
801033b8:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801033bc:	75 ef                	jne    801033ad <scheduler+0x18>
      c->proc = p;
801033be:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801033c4:	83 ec 0c             	sub    $0xc,%esp
801033c7:	53                   	push   %ebx
801033c8:	e8 7d 2c 00 00       	call   8010604a <switchuvm>
      p->state = RUNNING;
801033cd:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context); //Esta funcion continúa por el mismo sitio pero en otro proceso, es decir entras por una pila, pero restauras otra
801033d4:	83 c4 08             	add    $0x8,%esp
801033d7:	ff 73 1c             	push   0x1c(%ebx)
801033da:	8d 46 04             	lea    0x4(%esi),%eax
801033dd:	50                   	push   %eax
801033de:	e8 6b 09 00 00       	call   80103d4e <swtch>
      switchkvm();
801033e3:	e8 54 2c 00 00       	call   8010603c <switchkvm>
      c->proc = 0;
801033e8:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801033ef:	00 00 00 
801033f2:	83 c4 10             	add    $0x10,%esp
801033f5:	eb b6                	jmp    801033ad <scheduler+0x18>
    release(&ptable.lock);
801033f7:	83 ec 0c             	sub    $0xc,%esp
801033fa:	68 20 1d 11 80       	push   $0x80111d20
801033ff:	e8 41 07 00 00       	call   80103b45 <release>
    sti();
80103404:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103407:	fb                   	sti    
    acquire(&ptable.lock);
80103408:	83 ec 0c             	sub    $0xc,%esp
8010340b:	68 20 1d 11 80       	push   $0x80111d20
80103410:	e8 cb 06 00 00       	call   80103ae0 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010341d:	eb 91                	jmp    801033b0 <scheduler+0x1b>

8010341f <sched>:
{
8010341f:	55                   	push   %ebp
80103420:	89 e5                	mov    %esp,%ebp
80103422:	56                   	push   %esi
80103423:	53                   	push   %ebx
  struct proc *p = myproc();
80103424:	e8 f4 fc ff ff       	call   8010311d <myproc>
80103429:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010342b:	83 ec 0c             	sub    $0xc,%esp
8010342e:	68 20 1d 11 80       	push   $0x80111d20
80103433:	e8 69 06 00 00       	call   80103aa1 <holding>
80103438:	83 c4 10             	add    $0x10,%esp
8010343b:	85 c0                	test   %eax,%eax
8010343d:	74 4f                	je     8010348e <sched+0x6f>
  if(mycpu()->ncli != 1)
8010343f:	e8 44 fc ff ff       	call   80103088 <mycpu>
80103444:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010344b:	75 4e                	jne    8010349b <sched+0x7c>
  if(p->state == RUNNING)
8010344d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103451:	74 55                	je     801034a8 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103453:	9c                   	pushf  
80103454:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103455:	f6 c4 02             	test   $0x2,%ah
80103458:	75 5b                	jne    801034b5 <sched+0x96>
  intena = mycpu()->intena;
8010345a:	e8 29 fc ff ff       	call   80103088 <mycpu>
8010345f:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103465:	e8 1e fc ff ff       	call   80103088 <mycpu>
8010346a:	83 ec 08             	sub    $0x8,%esp
8010346d:	ff 70 04             	push   0x4(%eax)
80103470:	83 c3 1c             	add    $0x1c,%ebx
80103473:	53                   	push   %ebx
80103474:	e8 d5 08 00 00       	call   80103d4e <swtch>
  mycpu()->intena = intena;
80103479:	e8 0a fc ff ff       	call   80103088 <mycpu>
8010347e:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010348a:	5b                   	pop    %ebx
8010348b:	5e                   	pop    %esi
8010348c:	5d                   	pop    %ebp
8010348d:	c3                   	ret    
    panic("sched ptable.lock");
8010348e:	83 ec 0c             	sub    $0xc,%esp
80103491:	68 7b 6c 10 80       	push   $0x80106c7b
80103496:	e8 a6 ce ff ff       	call   80100341 <panic>
    panic("sched locks");
8010349b:	83 ec 0c             	sub    $0xc,%esp
8010349e:	68 8d 6c 10 80       	push   $0x80106c8d
801034a3:	e8 99 ce ff ff       	call   80100341 <panic>
    panic("sched running");
801034a8:	83 ec 0c             	sub    $0xc,%esp
801034ab:	68 99 6c 10 80       	push   $0x80106c99
801034b0:	e8 8c ce ff ff       	call   80100341 <panic>
    panic("sched interruptible");
801034b5:	83 ec 0c             	sub    $0xc,%esp
801034b8:	68 a7 6c 10 80       	push   $0x80106ca7
801034bd:	e8 7f ce ff ff       	call   80100341 <panic>

801034c2 <exit>:
{
801034c2:	55                   	push   %ebp
801034c3:	89 e5                	mov    %esp,%ebp
801034c5:	56                   	push   %esi
801034c6:	53                   	push   %ebx
  struct proc *curproc = myproc();
801034c7:	e8 51 fc ff ff       	call   8010311d <myproc>
  if(curproc == initproc)
801034cc:	39 05 a4 3d 11 80    	cmp    %eax,0x80113da4
801034d2:	74 09                	je     801034dd <exit+0x1b>
801034d4:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
801034d6:	bb 00 00 00 00       	mov    $0x0,%ebx
801034db:	eb 22                	jmp    801034ff <exit+0x3d>
    panic("init exiting");
801034dd:	83 ec 0c             	sub    $0xc,%esp
801034e0:	68 bb 6c 10 80       	push   $0x80106cbb
801034e5:	e8 57 ce ff ff       	call   80100341 <panic>
      fileclose(curproc->ofile[fd]);
801034ea:	83 ec 0c             	sub    $0xc,%esp
801034ed:	50                   	push   %eax
801034ee:	e8 97 d7 ff ff       	call   80100c8a <fileclose>
      curproc->ofile[fd] = 0;
801034f3:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801034fa:	00 
801034fb:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801034fe:	43                   	inc    %ebx
801034ff:	83 fb 0f             	cmp    $0xf,%ebx
80103502:	7f 0a                	jg     8010350e <exit+0x4c>
    if(curproc->ofile[fd]){
80103504:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103508:	85 c0                	test   %eax,%eax
8010350a:	75 de                	jne    801034ea <exit+0x28>
8010350c:	eb f0                	jmp    801034fe <exit+0x3c>
  begin_op();
8010350e:	e8 c9 f1 ff ff       	call   801026dc <begin_op>
  iput(curproc->cwd);
80103513:	83 ec 0c             	sub    $0xc,%esp
80103516:	ff 76 68             	push   0x68(%esi)
80103519:	e8 ed e0 ff ff       	call   8010160b <iput>
  end_op();
8010351e:	e8 35 f2 ff ff       	call   80102758 <end_op>
  curproc->cwd = 0;
80103523:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010352a:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103531:	e8 aa 05 00 00       	call   80103ae0 <acquire>
  wakeup1(curproc->parent);
80103536:	8b 46 14             	mov    0x14(%esi),%eax
80103539:	e8 08 fa ff ff       	call   80102f46 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010353e:	83 c4 10             	add    $0x10,%esp
80103541:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103546:	eb 03                	jmp    8010354b <exit+0x89>
80103548:	83 eb 80             	sub    $0xffffff80,%ebx
8010354b:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103551:	73 1a                	jae    8010356d <exit+0xab>
    if(p->parent == curproc){
80103553:	39 73 14             	cmp    %esi,0x14(%ebx)
80103556:	75 f0                	jne    80103548 <exit+0x86>
      p->parent = initproc;
80103558:	a1 a4 3d 11 80       	mov    0x80113da4,%eax
8010355d:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103560:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103564:	75 e2                	jne    80103548 <exit+0x86>
        wakeup1(initproc);
80103566:	e8 db f9 ff ff       	call   80102f46 <wakeup1>
8010356b:	eb db                	jmp    80103548 <exit+0x86>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
8010356d:	83 ec 04             	sub    $0x4,%esp
80103570:	6a 00                	push   $0x0
80103572:	68 00 00 00 80       	push   $0x80000000
80103577:	ff 76 04             	push   0x4(%esi)
8010357a:	e8 29 2d 00 00       	call   801062a8 <deallocuvm>
  curproc->exit_status = exit_status;
8010357f:	8b 45 08             	mov    0x8(%ebp),%eax
80103582:	89 46 7c             	mov    %eax,0x7c(%esi)
  curproc->state = ZOMBIE;
80103585:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010358c:	e8 8e fe ff ff       	call   8010341f <sched>
  panic("zombie exit");
80103591:	c7 04 24 c8 6c 10 80 	movl   $0x80106cc8,(%esp)
80103598:	e8 a4 cd ff ff       	call   80100341 <panic>

8010359d <yield>:
{
8010359d:	55                   	push   %ebp
8010359e:	89 e5                	mov    %esp,%ebp
801035a0:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801035a3:	68 20 1d 11 80       	push   $0x80111d20
801035a8:	e8 33 05 00 00       	call   80103ae0 <acquire>
  myproc()->state = RUNNABLE;
801035ad:	e8 6b fb ff ff       	call   8010311d <myproc>
801035b2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801035b9:	e8 61 fe ff ff       	call   8010341f <sched>
  release(&ptable.lock);
801035be:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801035c5:	e8 7b 05 00 00       	call   80103b45 <release>
}
801035ca:	83 c4 10             	add    $0x10,%esp
801035cd:	c9                   	leave  
801035ce:	c3                   	ret    

801035cf <sleep>:
{
801035cf:	55                   	push   %ebp
801035d0:	89 e5                	mov    %esp,%ebp
801035d2:	56                   	push   %esi
801035d3:	53                   	push   %ebx
801035d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801035d7:	e8 41 fb ff ff       	call   8010311d <myproc>
  if(p == 0)
801035dc:	85 c0                	test   %eax,%eax
801035de:	74 66                	je     80103646 <sleep+0x77>
801035e0:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
801035e2:	85 f6                	test   %esi,%esi
801035e4:	74 6d                	je     80103653 <sleep+0x84>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801035e6:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801035ec:	74 18                	je     80103606 <sleep+0x37>
    acquire(&ptable.lock);  //DOC: sleeplock1
801035ee:	83 ec 0c             	sub    $0xc,%esp
801035f1:	68 20 1d 11 80       	push   $0x80111d20
801035f6:	e8 e5 04 00 00       	call   80103ae0 <acquire>
    release(lk);
801035fb:	89 34 24             	mov    %esi,(%esp)
801035fe:	e8 42 05 00 00       	call   80103b45 <release>
80103603:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103606:	8b 45 08             	mov    0x8(%ebp),%eax
80103609:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010360c:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103613:	e8 07 fe ff ff       	call   8010341f <sched>
  p->chan = 0;
80103618:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010361f:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103625:	74 18                	je     8010363f <sleep+0x70>
    release(&ptable.lock);
80103627:	83 ec 0c             	sub    $0xc,%esp
8010362a:	68 20 1d 11 80       	push   $0x80111d20
8010362f:	e8 11 05 00 00       	call   80103b45 <release>
    acquire(lk);
80103634:	89 34 24             	mov    %esi,(%esp)
80103637:	e8 a4 04 00 00       	call   80103ae0 <acquire>
8010363c:	83 c4 10             	add    $0x10,%esp
}
8010363f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103642:	5b                   	pop    %ebx
80103643:	5e                   	pop    %esi
80103644:	5d                   	pop    %ebp
80103645:	c3                   	ret    
    panic("sleep");
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	68 d4 6c 10 80       	push   $0x80106cd4
8010364e:	e8 ee cc ff ff       	call   80100341 <panic>
    panic("sleep without lk");
80103653:	83 ec 0c             	sub    $0xc,%esp
80103656:	68 da 6c 10 80       	push   $0x80106cda
8010365b:	e8 e1 cc ff ff       	call   80100341 <panic>

80103660 <wait>:
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103665:	e8 b3 fa ff ff       	call   8010311d <myproc>
8010366a:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010366c:	83 ec 0c             	sub    $0xc,%esp
8010366f:	68 20 1d 11 80       	push   $0x80111d20
80103674:	e8 67 04 00 00       	call   80103ae0 <acquire>
80103679:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010367c:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103681:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103686:	eb 74                	jmp    801036fc <wait+0x9c>
        pid = p->pid;
80103688:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	ff 73 08             	push   0x8(%ebx)
80103691:	e8 7a e8 ff ff       	call   80101f10 <kfree>
        p->kstack = 0;
80103696:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
8010369d:	83 c4 08             	add    $0x8,%esp
801036a0:	6a 00                	push   $0x0
801036a2:	ff 73 04             	push   0x4(%ebx)
801036a5:	e8 7b 2d 00 00       	call   80106425 <freevm>
        p->pid = 0;
801036aa:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801036b1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801036b8:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801036bc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801036c3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        if (p->exit_status != 0) {
801036ca:	8b 43 7c             	mov    0x7c(%ebx),%eax
801036cd:	83 c4 10             	add    $0x10,%esp
801036d0:	85 c0                	test   %eax,%eax
801036d2:	74 05                	je     801036d9 <wait+0x79>
          *exit_status = p->exit_status;
801036d4:	8b 55 08             	mov    0x8(%ebp),%edx
801036d7:	89 02                	mov    %eax,(%edx)
        p->exit_status = 0;
801036d9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        release(&ptable.lock);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	68 20 1d 11 80       	push   $0x80111d20
801036e8:	e8 58 04 00 00       	call   80103b45 <release>
        return pid;
801036ed:	83 c4 10             	add    $0x10,%esp
}
801036f0:	89 f0                	mov    %esi,%eax
801036f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f5:	5b                   	pop    %ebx
801036f6:	5e                   	pop    %esi
801036f7:	5d                   	pop    %ebp
801036f8:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036f9:	83 eb 80             	sub    $0xffffff80,%ebx
801036fc:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103702:	73 16                	jae    8010371a <wait+0xba>
      if(p->parent != curproc)
80103704:	39 73 14             	cmp    %esi,0x14(%ebx)
80103707:	75 f0                	jne    801036f9 <wait+0x99>
      if(p->state == ZOMBIE){
80103709:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010370d:	0f 84 75 ff ff ff    	je     80103688 <wait+0x28>
      havekids = 1;
80103713:	b8 01 00 00 00       	mov    $0x1,%eax
80103718:	eb df                	jmp    801036f9 <wait+0x99>
    if(!havekids || curproc->killed){
8010371a:	85 c0                	test   %eax,%eax
8010371c:	74 06                	je     80103724 <wait+0xc4>
8010371e:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103722:	74 17                	je     8010373b <wait+0xdb>
      release(&ptable.lock);
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	68 20 1d 11 80       	push   $0x80111d20
8010372c:	e8 14 04 00 00       	call   80103b45 <release>
      return -1;
80103731:	83 c4 10             	add    $0x10,%esp
80103734:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103739:	eb b5                	jmp    801036f0 <wait+0x90>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010373b:	83 ec 08             	sub    $0x8,%esp
8010373e:	68 20 1d 11 80       	push   $0x80111d20
80103743:	56                   	push   %esi
80103744:	e8 86 fe ff ff       	call   801035cf <sleep>
    havekids = 0;
80103749:	83 c4 10             	add    $0x10,%esp
8010374c:	e9 2b ff ff ff       	jmp    8010367c <wait+0x1c>

80103751 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103751:	55                   	push   %ebp
80103752:	89 e5                	mov    %esp,%ebp
80103754:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103757:	68 20 1d 11 80       	push   $0x80111d20
8010375c:	e8 7f 03 00 00       	call   80103ae0 <acquire>
  wakeup1(chan);
80103761:	8b 45 08             	mov    0x8(%ebp),%eax
80103764:	e8 dd f7 ff ff       	call   80102f46 <wakeup1>
  release(&ptable.lock);
80103769:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103770:	e8 d0 03 00 00       	call   80103b45 <release>
}
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	c9                   	leave  
80103779:	c3                   	ret    

8010377a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010377a:	55                   	push   %ebp
8010377b:	89 e5                	mov    %esp,%ebp
8010377d:	53                   	push   %ebx
8010377e:	83 ec 10             	sub    $0x10,%esp
80103781:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103784:	68 20 1d 11 80       	push   $0x80111d20
80103789:	e8 52 03 00 00       	call   80103ae0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010378e:	83 c4 10             	add    $0x10,%esp
80103791:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103796:	eb 0c                	jmp    801037a4 <kill+0x2a>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103798:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010379f:	eb 1c                	jmp    801037bd <kill+0x43>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037a1:	83 e8 80             	sub    $0xffffff80,%eax
801037a4:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
801037a9:	73 2c                	jae    801037d7 <kill+0x5d>
    if(p->pid == pid){
801037ab:	39 58 10             	cmp    %ebx,0x10(%eax)
801037ae:	75 f1                	jne    801037a1 <kill+0x27>
      p->killed = 1;
801037b0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801037b7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801037bb:	74 db                	je     80103798 <kill+0x1e>
      release(&ptable.lock);
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	68 20 1d 11 80       	push   $0x80111d20
801037c5:	e8 7b 03 00 00       	call   80103b45 <release>
      return 0;
801037ca:	83 c4 10             	add    $0x10,%esp
801037cd:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801037d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037d5:	c9                   	leave  
801037d6:	c3                   	ret    
  release(&ptable.lock);
801037d7:	83 ec 0c             	sub    $0xc,%esp
801037da:	68 20 1d 11 80       	push   $0x80111d20
801037df:	e8 61 03 00 00       	call   80103b45 <release>
  return -1;
801037e4:	83 c4 10             	add    $0x10,%esp
801037e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037ec:	eb e4                	jmp    801037d2 <kill+0x58>

801037ee <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801037ee:	55                   	push   %ebp
801037ef:	89 e5                	mov    %esp,%ebp
801037f1:	56                   	push   %esi
801037f2:	53                   	push   %ebx
801037f3:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037f6:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801037fb:	eb 33                	jmp    80103830 <procdump+0x42>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801037fd:	b8 eb 6c 10 80       	mov    $0x80106ceb,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103802:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103805:	52                   	push   %edx
80103806:	50                   	push   %eax
80103807:	ff 73 10             	push   0x10(%ebx)
8010380a:	68 ef 6c 10 80       	push   $0x80106cef
8010380f:	e8 c6 cd ff ff       	call   801005da <cprintf>
    if(p->state == SLEEPING){
80103814:	83 c4 10             	add    $0x10,%esp
80103817:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010381b:	74 39                	je     80103856 <procdump+0x68>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010381d:	83 ec 0c             	sub    $0xc,%esp
80103820:	68 d7 70 10 80       	push   $0x801070d7
80103825:	e8 b0 cd ff ff       	call   801005da <cprintf>
8010382a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010382d:	83 eb 80             	sub    $0xffffff80,%ebx
80103830:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103836:	73 5f                	jae    80103897 <procdump+0xa9>
    if(p->state == UNUSED)
80103838:	8b 43 0c             	mov    0xc(%ebx),%eax
8010383b:	85 c0                	test   %eax,%eax
8010383d:	74 ee                	je     8010382d <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010383f:	83 f8 05             	cmp    $0x5,%eax
80103842:	77 b9                	ja     801037fd <procdump+0xf>
80103844:	8b 04 85 4c 6d 10 80 	mov    -0x7fef92b4(,%eax,4),%eax
8010384b:	85 c0                	test   %eax,%eax
8010384d:	75 b3                	jne    80103802 <procdump+0x14>
      state = "???";
8010384f:	b8 eb 6c 10 80       	mov    $0x80106ceb,%eax
80103854:	eb ac                	jmp    80103802 <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103856:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103859:	8b 40 0c             	mov    0xc(%eax),%eax
8010385c:	83 c0 08             	add    $0x8,%eax
8010385f:	83 ec 08             	sub    $0x8,%esp
80103862:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103865:	52                   	push   %edx
80103866:	50                   	push   %eax
80103867:	e8 58 01 00 00       	call   801039c4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	be 00 00 00 00       	mov    $0x0,%esi
80103874:	eb 12                	jmp    80103888 <procdump+0x9a>
        cprintf(" %p", pc[i]);
80103876:	83 ec 08             	sub    $0x8,%esp
80103879:	50                   	push   %eax
8010387a:	68 41 67 10 80       	push   $0x80106741
8010387f:	e8 56 cd ff ff       	call   801005da <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103884:	46                   	inc    %esi
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	83 fe 09             	cmp    $0x9,%esi
8010388b:	7f 90                	jg     8010381d <procdump+0x2f>
8010388d:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103891:	85 c0                	test   %eax,%eax
80103893:	75 e1                	jne    80103876 <procdump+0x88>
80103895:	eb 86                	jmp    8010381d <procdump+0x2f>
  }
}
80103897:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010389a:	5b                   	pop    %ebx
8010389b:	5e                   	pop    %esi
8010389c:	5d                   	pop    %ebp
8010389d:	c3                   	ret    

8010389e <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010389e:	55                   	push   %ebp
8010389f:	89 e5                	mov    %esp,%ebp
801038a1:	53                   	push   %ebx
801038a2:	83 ec 0c             	sub    $0xc,%esp
801038a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801038a8:	68 64 6d 10 80       	push   $0x80106d64
801038ad:	8d 43 04             	lea    0x4(%ebx),%eax
801038b0:	50                   	push   %eax
801038b1:	e8 f3 00 00 00       	call   801039a9 <initlock>
  lk->name = name;
801038b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801038b9:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
801038bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801038c2:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038cf:	c9                   	leave  
801038d0:	c3                   	ret    

801038d1 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801038d1:	55                   	push   %ebp
801038d2:	89 e5                	mov    %esp,%ebp
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801038d9:	8d 73 04             	lea    0x4(%ebx),%esi
801038dc:	83 ec 0c             	sub    $0xc,%esp
801038df:	56                   	push   %esi
801038e0:	e8 fb 01 00 00       	call   80103ae0 <acquire>
  while (lk->locked) {
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	eb 0d                	jmp    801038f7 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
801038ea:	83 ec 08             	sub    $0x8,%esp
801038ed:	56                   	push   %esi
801038ee:	53                   	push   %ebx
801038ef:	e8 db fc ff ff       	call   801035cf <sleep>
801038f4:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
801038f7:	83 3b 00             	cmpl   $0x0,(%ebx)
801038fa:	75 ee                	jne    801038ea <acquiresleep+0x19>
  }
  lk->locked = 1;
801038fc:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103902:	e8 16 f8 ff ff       	call   8010311d <myproc>
80103907:	8b 40 10             	mov    0x10(%eax),%eax
8010390a:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010390d:	83 ec 0c             	sub    $0xc,%esp
80103910:	56                   	push   %esi
80103911:	e8 2f 02 00 00       	call   80103b45 <release>
}
80103916:	83 c4 10             	add    $0x10,%esp
80103919:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010391c:	5b                   	pop    %ebx
8010391d:	5e                   	pop    %esi
8010391e:	5d                   	pop    %ebp
8010391f:	c3                   	ret    

80103920 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
80103925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103928:	8d 73 04             	lea    0x4(%ebx),%esi
8010392b:	83 ec 0c             	sub    $0xc,%esp
8010392e:	56                   	push   %esi
8010392f:	e8 ac 01 00 00       	call   80103ae0 <acquire>
  lk->locked = 0;
80103934:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010393a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103941:	89 1c 24             	mov    %ebx,(%esp)
80103944:	e8 08 fe ff ff       	call   80103751 <wakeup>
  release(&lk->lk);
80103949:	89 34 24             	mov    %esi,(%esp)
8010394c:	e8 f4 01 00 00       	call   80103b45 <release>
}
80103951:	83 c4 10             	add    $0x10,%esp
80103954:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103957:	5b                   	pop    %ebx
80103958:	5e                   	pop    %esi
80103959:	5d                   	pop    %ebp
8010395a:	c3                   	ret    

8010395b <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010395b:	55                   	push   %ebp
8010395c:	89 e5                	mov    %esp,%ebp
8010395e:	56                   	push   %esi
8010395f:	53                   	push   %ebx
80103960:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103963:	8d 73 04             	lea    0x4(%ebx),%esi
80103966:	83 ec 0c             	sub    $0xc,%esp
80103969:	56                   	push   %esi
8010396a:	e8 71 01 00 00       	call   80103ae0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010396f:	83 c4 10             	add    $0x10,%esp
80103972:	83 3b 00             	cmpl   $0x0,(%ebx)
80103975:	75 17                	jne    8010398e <holdingsleep+0x33>
80103977:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
8010397c:	83 ec 0c             	sub    $0xc,%esp
8010397f:	56                   	push   %esi
80103980:	e8 c0 01 00 00       	call   80103b45 <release>
  return r;
}
80103985:	89 d8                	mov    %ebx,%eax
80103987:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010398a:	5b                   	pop    %ebx
8010398b:	5e                   	pop    %esi
8010398c:	5d                   	pop    %ebp
8010398d:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
8010398e:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103991:	e8 87 f7 ff ff       	call   8010311d <myproc>
80103996:	3b 58 10             	cmp    0x10(%eax),%ebx
80103999:	74 07                	je     801039a2 <holdingsleep+0x47>
8010399b:	bb 00 00 00 00       	mov    $0x0,%ebx
801039a0:	eb da                	jmp    8010397c <holdingsleep+0x21>
801039a2:	bb 01 00 00 00       	mov    $0x1,%ebx
801039a7:	eb d3                	jmp    8010397c <holdingsleep+0x21>

801039a9 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801039a9:	55                   	push   %ebp
801039aa:	89 e5                	mov    %esp,%ebp
801039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801039af:	8b 55 0c             	mov    0xc(%ebp),%edx
801039b2:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801039b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801039bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801039c2:	5d                   	pop    %ebp
801039c3:	c3                   	ret    

801039c4 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	53                   	push   %ebx
801039c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801039cb:	8b 45 08             	mov    0x8(%ebp),%eax
801039ce:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801039d1:	b8 00 00 00 00       	mov    $0x0,%eax
801039d6:	83 f8 09             	cmp    $0x9,%eax
801039d9:	7f 21                	jg     801039fc <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801039db:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801039e1:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801039e7:	77 13                	ja     801039fc <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801039e9:	8b 5a 04             	mov    0x4(%edx),%ebx
801039ec:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801039ef:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801039f1:	40                   	inc    %eax
801039f2:	eb e2                	jmp    801039d6 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801039f4:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801039fb:	40                   	inc    %eax
801039fc:	83 f8 09             	cmp    $0x9,%eax
801039ff:	7e f3                	jle    801039f4 <getcallerpcs+0x30>
}
80103a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a04:	c9                   	leave  
80103a05:	c3                   	ret    

80103a06 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103a06:	55                   	push   %ebp
80103a07:	89 e5                	mov    %esp,%ebp
80103a09:	53                   	push   %ebx
80103a0a:	83 ec 04             	sub    $0x4,%esp
80103a0d:	9c                   	pushf  
80103a0e:	5b                   	pop    %ebx
  asm volatile("cli");
80103a0f:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103a10:	e8 73 f6 ff ff       	call   80103088 <mycpu>
80103a15:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103a1c:	74 10                	je     80103a2e <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103a1e:	e8 65 f6 ff ff       	call   80103088 <mycpu>
80103a23:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103a29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2c:	c9                   	leave  
80103a2d:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103a2e:	e8 55 f6 ff ff       	call   80103088 <mycpu>
80103a33:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103a39:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103a3f:	eb dd                	jmp    80103a1e <pushcli+0x18>

80103a41 <popcli>:

void
popcli(void)
{
80103a41:	55                   	push   %ebp
80103a42:	89 e5                	mov    %esp,%ebp
80103a44:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a47:	9c                   	pushf  
80103a48:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a49:	f6 c4 02             	test   $0x2,%ah
80103a4c:	75 28                	jne    80103a76 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103a4e:	e8 35 f6 ff ff       	call   80103088 <mycpu>
80103a53:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103a59:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103a5c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103a62:	85 d2                	test   %edx,%edx
80103a64:	78 1d                	js     80103a83 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103a66:	e8 1d f6 ff ff       	call   80103088 <mycpu>
80103a6b:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103a72:	74 1c                	je     80103a90 <popcli+0x4f>
    sti();
}
80103a74:	c9                   	leave  
80103a75:	c3                   	ret    
    panic("popcli - interruptible");
80103a76:	83 ec 0c             	sub    $0xc,%esp
80103a79:	68 6f 6d 10 80       	push   $0x80106d6f
80103a7e:	e8 be c8 ff ff       	call   80100341 <panic>
    panic("popcli");
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	68 86 6d 10 80       	push   $0x80106d86
80103a8b:	e8 b1 c8 ff ff       	call   80100341 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103a90:	e8 f3 f5 ff ff       	call   80103088 <mycpu>
80103a95:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103a9c:	74 d6                	je     80103a74 <popcli+0x33>
  asm volatile("sti");
80103a9e:	fb                   	sti    
}
80103a9f:	eb d3                	jmp    80103a74 <popcli+0x33>

80103aa1 <holding>:
{
80103aa1:	55                   	push   %ebp
80103aa2:	89 e5                	mov    %esp,%ebp
80103aa4:	53                   	push   %ebx
80103aa5:	83 ec 04             	sub    $0x4,%esp
80103aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103aab:	e8 56 ff ff ff       	call   80103a06 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103ab0:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ab3:	75 11                	jne    80103ac6 <holding+0x25>
80103ab5:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103aba:	e8 82 ff ff ff       	call   80103a41 <popcli>
}
80103abf:	89 d8                	mov    %ebx,%eax
80103ac1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac4:	c9                   	leave  
80103ac5:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103ac6:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103ac9:	e8 ba f5 ff ff       	call   80103088 <mycpu>
80103ace:	39 c3                	cmp    %eax,%ebx
80103ad0:	74 07                	je     80103ad9 <holding+0x38>
80103ad2:	bb 00 00 00 00       	mov    $0x0,%ebx
80103ad7:	eb e1                	jmp    80103aba <holding+0x19>
80103ad9:	bb 01 00 00 00       	mov    $0x1,%ebx
80103ade:	eb da                	jmp    80103aba <holding+0x19>

80103ae0 <acquire>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103ae7:	e8 1a ff ff ff       	call   80103a06 <pushcli>
  if(holding(lk))
80103aec:	83 ec 0c             	sub    $0xc,%esp
80103aef:	ff 75 08             	push   0x8(%ebp)
80103af2:	e8 aa ff ff ff       	call   80103aa1 <holding>
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	85 c0                	test   %eax,%eax
80103afc:	75 3a                	jne    80103b38 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103afe:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103b01:	b8 01 00 00 00       	mov    $0x1,%eax
80103b06:	f0 87 02             	lock xchg %eax,(%edx)
80103b09:	85 c0                	test   %eax,%eax
80103b0b:	75 f1                	jne    80103afe <acquire+0x1e>
  __sync_synchronize();
80103b0d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103b12:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b15:	e8 6e f5 ff ff       	call   80103088 <mycpu>
80103b1a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b20:	83 c0 0c             	add    $0xc,%eax
80103b23:	83 ec 08             	sub    $0x8,%esp
80103b26:	50                   	push   %eax
80103b27:	8d 45 08             	lea    0x8(%ebp),%eax
80103b2a:	50                   	push   %eax
80103b2b:	e8 94 fe ff ff       	call   801039c4 <getcallerpcs>
}
80103b30:	83 c4 10             	add    $0x10,%esp
80103b33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b36:	c9                   	leave  
80103b37:	c3                   	ret    
    panic("acquire");
80103b38:	83 ec 0c             	sub    $0xc,%esp
80103b3b:	68 8d 6d 10 80       	push   $0x80106d8d
80103b40:	e8 fc c7 ff ff       	call   80100341 <panic>

80103b45 <release>:
{
80103b45:	55                   	push   %ebp
80103b46:	89 e5                	mov    %esp,%ebp
80103b48:	53                   	push   %ebx
80103b49:	83 ec 10             	sub    $0x10,%esp
80103b4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103b4f:	53                   	push   %ebx
80103b50:	e8 4c ff ff ff       	call   80103aa1 <holding>
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	85 c0                	test   %eax,%eax
80103b5a:	74 23                	je     80103b7f <release+0x3a>
  lk->pcs[0] = 0;
80103b5c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103b63:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103b6a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103b6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103b75:	e8 c7 fe ff ff       	call   80103a41 <popcli>
}
80103b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b7d:	c9                   	leave  
80103b7e:	c3                   	ret    
    panic("release");
80103b7f:	83 ec 0c             	sub    $0xc,%esp
80103b82:	68 95 6d 10 80       	push   $0x80106d95
80103b87:	e8 b5 c7 ff ff       	call   80100341 <panic>

80103b8c <memset>:
80103b8c:	f3 0f 1e fb          	endbr32 
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	53                   	push   %ebx
80103b95:	8b 55 08             	mov    0x8(%ebp),%edx
80103b98:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b9b:	f6 c2 03             	test   $0x3,%dl
80103b9e:	75 29                	jne    80103bc9 <memset+0x3d>
80103ba0:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103ba4:	75 23                	jne    80103bc9 <memset+0x3d>
80103ba6:	0f b6 f8             	movzbl %al,%edi
80103ba9:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103bac:	c1 e9 02             	shr    $0x2,%ecx
80103baf:	c1 e0 18             	shl    $0x18,%eax
80103bb2:	89 fb                	mov    %edi,%ebx
80103bb4:	c1 e3 10             	shl    $0x10,%ebx
80103bb7:	09 d8                	or     %ebx,%eax
80103bb9:	89 fb                	mov    %edi,%ebx
80103bbb:	c1 e3 08             	shl    $0x8,%ebx
80103bbe:	09 d8                	or     %ebx,%eax
80103bc0:	09 f8                	or     %edi,%eax
80103bc2:	89 d7                	mov    %edx,%edi
80103bc4:	fc                   	cld    
80103bc5:	f3 ab                	rep stos %eax,%es:(%edi)
80103bc7:	eb 08                	jmp    80103bd1 <memset+0x45>
80103bc9:	89 d7                	mov    %edx,%edi
80103bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103bce:	fc                   	cld    
80103bcf:	f3 aa                	rep stos %al,%es:(%edi)
80103bd1:	89 d0                	mov    %edx,%eax
80103bd3:	5b                   	pop    %ebx
80103bd4:	5f                   	pop    %edi
80103bd5:	5d                   	pop    %ebp
80103bd6:	c3                   	ret    

80103bd7 <memcmp>:
80103bd7:	f3 0f 1e fb          	endbr32 
80103bdb:	55                   	push   %ebp
80103bdc:	89 e5                	mov    %esp,%ebp
80103bde:	56                   	push   %esi
80103bdf:	53                   	push   %ebx
80103be0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80103be6:	8b 45 10             	mov    0x10(%ebp),%eax
80103be9:	8d 70 ff             	lea    -0x1(%eax),%esi
80103bec:	85 c0                	test   %eax,%eax
80103bee:	74 16                	je     80103c06 <memcmp+0x2f>
80103bf0:	8a 01                	mov    (%ecx),%al
80103bf2:	8a 1a                	mov    (%edx),%bl
80103bf4:	38 d8                	cmp    %bl,%al
80103bf6:	75 06                	jne    80103bfe <memcmp+0x27>
80103bf8:	41                   	inc    %ecx
80103bf9:	42                   	inc    %edx
80103bfa:	89 f0                	mov    %esi,%eax
80103bfc:	eb eb                	jmp    80103be9 <memcmp+0x12>
80103bfe:	0f b6 c0             	movzbl %al,%eax
80103c01:	0f b6 db             	movzbl %bl,%ebx
80103c04:	29 d8                	sub    %ebx,%eax
80103c06:	5b                   	pop    %ebx
80103c07:	5e                   	pop    %esi
80103c08:	5d                   	pop    %ebp
80103c09:	c3                   	ret    

80103c0a <memmove>:
80103c0a:	f3 0f 1e fb          	endbr32 
80103c0e:	55                   	push   %ebp
80103c0f:	89 e5                	mov    %esp,%ebp
80103c11:	56                   	push   %esi
80103c12:	53                   	push   %ebx
80103c13:	8b 75 08             	mov    0x8(%ebp),%esi
80103c16:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c19:	8b 45 10             	mov    0x10(%ebp),%eax
80103c1c:	39 f2                	cmp    %esi,%edx
80103c1e:	73 34                	jae    80103c54 <memmove+0x4a>
80103c20:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103c23:	39 f1                	cmp    %esi,%ecx
80103c25:	76 31                	jbe    80103c58 <memmove+0x4e>
80103c27:	8d 14 06             	lea    (%esi,%eax,1),%edx
80103c2a:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103c2d:	85 c0                	test   %eax,%eax
80103c2f:	74 1d                	je     80103c4e <memmove+0x44>
80103c31:	49                   	dec    %ecx
80103c32:	4a                   	dec    %edx
80103c33:	8a 01                	mov    (%ecx),%al
80103c35:	88 02                	mov    %al,(%edx)
80103c37:	89 d8                	mov    %ebx,%eax
80103c39:	eb ef                	jmp    80103c2a <memmove+0x20>
80103c3b:	8a 02                	mov    (%edx),%al
80103c3d:	88 01                	mov    %al,(%ecx)
80103c3f:	8d 49 01             	lea    0x1(%ecx),%ecx
80103c42:	8d 52 01             	lea    0x1(%edx),%edx
80103c45:	89 d8                	mov    %ebx,%eax
80103c47:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103c4a:	85 c0                	test   %eax,%eax
80103c4c:	75 ed                	jne    80103c3b <memmove+0x31>
80103c4e:	89 f0                	mov    %esi,%eax
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5d                   	pop    %ebp
80103c53:	c3                   	ret    
80103c54:	89 f1                	mov    %esi,%ecx
80103c56:	eb ef                	jmp    80103c47 <memmove+0x3d>
80103c58:	89 f1                	mov    %esi,%ecx
80103c5a:	eb eb                	jmp    80103c47 <memmove+0x3d>

80103c5c <memcpy>:
80103c5c:	f3 0f 1e fb          	endbr32 
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	83 ec 0c             	sub    $0xc,%esp
80103c66:	ff 75 10             	push   0x10(%ebp)
80103c69:	ff 75 0c             	push   0xc(%ebp)
80103c6c:	ff 75 08             	push   0x8(%ebp)
80103c6f:	e8 96 ff ff ff       	call   80103c0a <memmove>
80103c74:	c9                   	leave  
80103c75:	c3                   	ret    

80103c76 <strncmp>:
80103c76:	f3 0f 1e fb          	endbr32 
80103c7a:	55                   	push   %ebp
80103c7b:	89 e5                	mov    %esp,%ebp
80103c7d:	53                   	push   %ebx
80103c7e:	8b 55 08             	mov    0x8(%ebp),%edx
80103c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c84:	8b 45 10             	mov    0x10(%ebp),%eax
80103c87:	eb 03                	jmp    80103c8c <strncmp+0x16>
80103c89:	48                   	dec    %eax
80103c8a:	42                   	inc    %edx
80103c8b:	41                   	inc    %ecx
80103c8c:	85 c0                	test   %eax,%eax
80103c8e:	74 0a                	je     80103c9a <strncmp+0x24>
80103c90:	8a 1a                	mov    (%edx),%bl
80103c92:	84 db                	test   %bl,%bl
80103c94:	74 04                	je     80103c9a <strncmp+0x24>
80103c96:	3a 19                	cmp    (%ecx),%bl
80103c98:	74 ef                	je     80103c89 <strncmp+0x13>
80103c9a:	85 c0                	test   %eax,%eax
80103c9c:	74 0b                	je     80103ca9 <strncmp+0x33>
80103c9e:	0f b6 02             	movzbl (%edx),%eax
80103ca1:	0f b6 11             	movzbl (%ecx),%edx
80103ca4:	29 d0                	sub    %edx,%eax
80103ca6:	5b                   	pop    %ebx
80103ca7:	5d                   	pop    %ebp
80103ca8:	c3                   	ret    
80103ca9:	b8 00 00 00 00       	mov    $0x0,%eax
80103cae:	eb f6                	jmp    80103ca6 <strncmp+0x30>

80103cb0 <strncpy>:
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	57                   	push   %edi
80103cb8:	56                   	push   %esi
80103cb9:	53                   	push   %ebx
80103cba:	8b 45 08             	mov    0x8(%ebp),%eax
80103cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103cc0:	8b 55 10             	mov    0x10(%ebp),%edx
80103cc3:	89 c1                	mov    %eax,%ecx
80103cc5:	eb 04                	jmp    80103ccb <strncpy+0x1b>
80103cc7:	89 fb                	mov    %edi,%ebx
80103cc9:	89 f1                	mov    %esi,%ecx
80103ccb:	89 d6                	mov    %edx,%esi
80103ccd:	4a                   	dec    %edx
80103cce:	85 f6                	test   %esi,%esi
80103cd0:	7e 1a                	jle    80103cec <strncpy+0x3c>
80103cd2:	8d 7b 01             	lea    0x1(%ebx),%edi
80103cd5:	8d 71 01             	lea    0x1(%ecx),%esi
80103cd8:	8a 1b                	mov    (%ebx),%bl
80103cda:	88 19                	mov    %bl,(%ecx)
80103cdc:	84 db                	test   %bl,%bl
80103cde:	75 e7                	jne    80103cc7 <strncpy+0x17>
80103ce0:	89 f1                	mov    %esi,%ecx
80103ce2:	eb 08                	jmp    80103cec <strncpy+0x3c>
80103ce4:	c6 01 00             	movb   $0x0,(%ecx)
80103ce7:	89 da                	mov    %ebx,%edx
80103ce9:	8d 49 01             	lea    0x1(%ecx),%ecx
80103cec:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103cef:	85 d2                	test   %edx,%edx
80103cf1:	7f f1                	jg     80103ce4 <strncpy+0x34>
80103cf3:	5b                   	pop    %ebx
80103cf4:	5e                   	pop    %esi
80103cf5:	5f                   	pop    %edi
80103cf6:	5d                   	pop    %ebp
80103cf7:	c3                   	ret    

80103cf8 <safestrcpy>:
80103cf8:	f3 0f 1e fb          	endbr32 
80103cfc:	55                   	push   %ebp
80103cfd:	89 e5                	mov    %esp,%ebp
80103cff:	57                   	push   %edi
80103d00:	56                   	push   %esi
80103d01:	53                   	push   %ebx
80103d02:	8b 45 08             	mov    0x8(%ebp),%eax
80103d05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103d08:	8b 55 10             	mov    0x10(%ebp),%edx
80103d0b:	85 d2                	test   %edx,%edx
80103d0d:	7e 20                	jle    80103d2f <safestrcpy+0x37>
80103d0f:	89 c1                	mov    %eax,%ecx
80103d11:	eb 04                	jmp    80103d17 <safestrcpy+0x1f>
80103d13:	89 fb                	mov    %edi,%ebx
80103d15:	89 f1                	mov    %esi,%ecx
80103d17:	4a                   	dec    %edx
80103d18:	85 d2                	test   %edx,%edx
80103d1a:	7e 10                	jle    80103d2c <safestrcpy+0x34>
80103d1c:	8d 7b 01             	lea    0x1(%ebx),%edi
80103d1f:	8d 71 01             	lea    0x1(%ecx),%esi
80103d22:	8a 1b                	mov    (%ebx),%bl
80103d24:	88 19                	mov    %bl,(%ecx)
80103d26:	84 db                	test   %bl,%bl
80103d28:	75 e9                	jne    80103d13 <safestrcpy+0x1b>
80103d2a:	89 f1                	mov    %esi,%ecx
80103d2c:	c6 01 00             	movb   $0x0,(%ecx)
80103d2f:	5b                   	pop    %ebx
80103d30:	5e                   	pop    %esi
80103d31:	5f                   	pop    %edi
80103d32:	5d                   	pop    %ebp
80103d33:	c3                   	ret    

80103d34 <strlen>:
80103d34:	f3 0f 1e fb          	endbr32 
80103d38:	55                   	push   %ebp
80103d39:	89 e5                	mov    %esp,%ebp
80103d3b:	8b 55 08             	mov    0x8(%ebp),%edx
80103d3e:	b8 00 00 00 00       	mov    $0x0,%eax
80103d43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103d47:	74 03                	je     80103d4c <strlen+0x18>
80103d49:	40                   	inc    %eax
80103d4a:	eb f7                	jmp    80103d43 <strlen+0xf>
80103d4c:	5d                   	pop    %ebp
80103d4d:	c3                   	ret    

80103d4e <swtch>:
80103d4e:	8b 44 24 04          	mov    0x4(%esp),%eax
80103d52:	8b 54 24 08          	mov    0x8(%esp),%edx
80103d56:	55                   	push   %ebp
80103d57:	53                   	push   %ebx
80103d58:	56                   	push   %esi
80103d59:	57                   	push   %edi
80103d5a:	89 20                	mov    %esp,(%eax)
80103d5c:	89 d4                	mov    %edx,%esp
80103d5e:	5f                   	pop    %edi
80103d5f:	5e                   	pop    %esi
80103d60:	5b                   	pop    %ebx
80103d61:	5d                   	pop    %ebp
80103d62:	c3                   	ret    

80103d63 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103d63:	55                   	push   %ebp
80103d64:	89 e5                	mov    %esp,%ebp
80103d66:	53                   	push   %ebx
80103d67:	83 ec 04             	sub    $0x4,%esp
80103d6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103d6d:	e8 ab f3 ff ff       	call   8010311d <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103d72:	8b 00                	mov    (%eax),%eax
80103d74:	39 d8                	cmp    %ebx,%eax
80103d76:	76 18                	jbe    80103d90 <fetchint+0x2d>
80103d78:	8d 53 04             	lea    0x4(%ebx),%edx
80103d7b:	39 d0                	cmp    %edx,%eax
80103d7d:	72 18                	jb     80103d97 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103d7f:	8b 13                	mov    (%ebx),%edx
80103d81:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d84:	89 10                	mov    %edx,(%eax)
  return 0;
80103d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d8e:	c9                   	leave  
80103d8f:	c3                   	ret    
    return -1;
80103d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d95:	eb f4                	jmp    80103d8b <fetchint+0x28>
80103d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d9c:	eb ed                	jmp    80103d8b <fetchint+0x28>

80103d9e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103d9e:	55                   	push   %ebp
80103d9f:	89 e5                	mov    %esp,%ebp
80103da1:	53                   	push   %ebx
80103da2:	83 ec 04             	sub    $0x4,%esp
80103da5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103da8:	e8 70 f3 ff ff       	call   8010311d <myproc>

  if(addr >= curproc->sz)
80103dad:	39 18                	cmp    %ebx,(%eax)
80103daf:	76 23                	jbe    80103dd4 <fetchstr+0x36>
    return -1;
  *pp = (char*)addr;
80103db1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103db4:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103db6:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103db8:	89 d8                	mov    %ebx,%eax
80103dba:	eb 01                	jmp    80103dbd <fetchstr+0x1f>
80103dbc:	40                   	inc    %eax
80103dbd:	39 d0                	cmp    %edx,%eax
80103dbf:	73 09                	jae    80103dca <fetchstr+0x2c>
    if(*s == 0)
80103dc1:	80 38 00             	cmpb   $0x0,(%eax)
80103dc4:	75 f6                	jne    80103dbc <fetchstr+0x1e>
      return s - *pp;
80103dc6:	29 d8                	sub    %ebx,%eax
80103dc8:	eb 05                	jmp    80103dcf <fetchstr+0x31>
  }
  return -1;
80103dca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dd2:	c9                   	leave  
80103dd3:	c3                   	ret    
    return -1;
80103dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dd9:	eb f4                	jmp    80103dcf <fetchstr+0x31>

80103ddb <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103ddb:	55                   	push   %ebp
80103ddc:	89 e5                	mov    %esp,%ebp
80103dde:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103de1:	e8 37 f3 ff ff       	call   8010311d <myproc>
80103de6:	8b 50 18             	mov    0x18(%eax),%edx
80103de9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dec:	c1 e0 02             	shl    $0x2,%eax
80103def:	03 42 44             	add    0x44(%edx),%eax
80103df2:	83 ec 08             	sub    $0x8,%esp
80103df5:	ff 75 0c             	push   0xc(%ebp)
80103df8:	83 c0 04             	add    $0x4,%eax
80103dfb:	50                   	push   %eax
80103dfc:	e8 62 ff ff ff       	call   80103d63 <fetchint>
}
80103e01:	c9                   	leave  
80103e02:	c3                   	ret    

80103e03 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80103e03:	55                   	push   %ebp
80103e04:	89 e5                	mov    %esp,%ebp
80103e06:	56                   	push   %esi
80103e07:	53                   	push   %ebx
80103e08:	83 ec 10             	sub    $0x10,%esp
80103e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103e0e:	e8 0a f3 ff ff       	call   8010311d <myproc>
80103e13:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80103e15:	83 ec 08             	sub    $0x8,%esp
80103e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103e1b:	50                   	push   %eax
80103e1c:	ff 75 08             	push   0x8(%ebp)
80103e1f:	e8 b7 ff ff ff       	call   80103ddb <argint>
80103e24:	83 c4 10             	add    $0x10,%esp
80103e27:	85 c0                	test   %eax,%eax
80103e29:	78 24                	js     80103e4f <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80103e2b:	85 db                	test   %ebx,%ebx
80103e2d:	78 27                	js     80103e56 <argptr+0x53>
80103e2f:	8b 16                	mov    (%esi),%edx
80103e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e34:	39 c2                	cmp    %eax,%edx
80103e36:	76 25                	jbe    80103e5d <argptr+0x5a>
80103e38:	01 c3                	add    %eax,%ebx
80103e3a:	39 da                	cmp    %ebx,%edx
80103e3c:	72 26                	jb     80103e64 <argptr+0x61>
    return -1;
  *pp = (void*)i;
80103e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e41:	89 02                	mov    %eax,(%edx)
  return 0;
80103e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e48:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e4b:	5b                   	pop    %ebx
80103e4c:	5e                   	pop    %esi
80103e4d:	5d                   	pop    %ebp
80103e4e:	c3                   	ret    
    return -1;
80103e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e54:	eb f2                	jmp    80103e48 <argptr+0x45>
    return -1;
80103e56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e5b:	eb eb                	jmp    80103e48 <argptr+0x45>
80103e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e62:	eb e4                	jmp    80103e48 <argptr+0x45>
80103e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e69:	eb dd                	jmp    80103e48 <argptr+0x45>

80103e6b <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80103e6b:	55                   	push   %ebp
80103e6c:	89 e5                	mov    %esp,%ebp
80103e6e:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80103e71:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103e74:	50                   	push   %eax
80103e75:	ff 75 08             	push   0x8(%ebp)
80103e78:	e8 5e ff ff ff       	call   80103ddb <argint>
80103e7d:	83 c4 10             	add    $0x10,%esp
80103e80:	85 c0                	test   %eax,%eax
80103e82:	78 13                	js     80103e97 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80103e84:	83 ec 08             	sub    $0x8,%esp
80103e87:	ff 75 0c             	push   0xc(%ebp)
80103e8a:	ff 75 f4             	push   -0xc(%ebp)
80103e8d:	e8 0c ff ff ff       	call   80103d9e <fetchstr>
80103e92:	83 c4 10             	add    $0x10,%esp
}
80103e95:	c9                   	leave  
80103e96:	c3                   	ret    
    return -1;
80103e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e9c:	eb f7                	jmp    80103e95 <argstr+0x2a>

80103e9e <syscall>:
[SYS_dup2]    sys_dup2,
};

void
syscall(void)
{
80103e9e:	55                   	push   %ebp
80103e9f:	89 e5                	mov    %esp,%ebp
80103ea1:	53                   	push   %ebx
80103ea2:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80103ea5:	e8 73 f2 ff ff       	call   8010311d <myproc>
80103eaa:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80103eac:	8b 40 18             	mov    0x18(%eax),%eax
80103eaf:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80103eb2:	8d 50 ff             	lea    -0x1(%eax),%edx
80103eb5:	83 fa 16             	cmp    $0x16,%edx
80103eb8:	77 17                	ja     80103ed1 <syscall+0x33>
80103eba:	8b 14 85 c0 6d 10 80 	mov    -0x7fef9240(,%eax,4),%edx
80103ec1:	85 d2                	test   %edx,%edx
80103ec3:	74 0c                	je     80103ed1 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
80103ec5:	ff d2                	call   *%edx
80103ec7:	89 c2                	mov    %eax,%edx
80103ec9:	8b 43 18             	mov    0x18(%ebx),%eax
80103ecc:	89 50 1c             	mov    %edx,0x1c(%eax)
80103ecf:	eb 1f                	jmp    80103ef0 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80103ed1:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80103ed4:	50                   	push   %eax
80103ed5:	52                   	push   %edx
80103ed6:	ff 73 10             	push   0x10(%ebx)
80103ed9:	68 9d 6d 10 80       	push   $0x80106d9d
80103ede:	e8 f7 c6 ff ff       	call   801005da <cprintf>
    curproc->tf->eax = -1;
80103ee3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80103eed:	83 c4 10             	add    $0x10,%esp
  }
}
80103ef0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef3:	c9                   	leave  
80103ef4:	c3                   	ret    

80103ef5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80103ef5:	55                   	push   %ebp
80103ef6:	89 e5                	mov    %esp,%ebp
80103ef8:	56                   	push   %esi
80103ef9:	53                   	push   %ebx
80103efa:	83 ec 18             	sub    $0x18,%esp
80103efd:	89 d6                	mov    %edx,%esi
80103eff:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80103f01:	8d 55 f4             	lea    -0xc(%ebp),%edx
80103f04:	52                   	push   %edx
80103f05:	50                   	push   %eax
80103f06:	e8 d0 fe ff ff       	call   80103ddb <argint>
80103f0b:	83 c4 10             	add    $0x10,%esp
80103f0e:	85 c0                	test   %eax,%eax
80103f10:	78 35                	js     80103f47 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80103f12:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80103f16:	77 28                	ja     80103f40 <argfd+0x4b>
80103f18:	e8 00 f2 ff ff       	call   8010311d <myproc>
80103f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f20:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	74 18                	je     80103f40 <argfd+0x4b>
    return -1;
  if(pfd)
80103f28:	85 f6                	test   %esi,%esi
80103f2a:	74 02                	je     80103f2e <argfd+0x39>
    *pfd = fd;
80103f2c:	89 16                	mov    %edx,(%esi)
  if(pf)
80103f2e:	85 db                	test   %ebx,%ebx
80103f30:	74 1c                	je     80103f4e <argfd+0x59>
    *pf = f;
80103f32:	89 03                	mov    %eax,(%ebx)
  return 0;
80103f34:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f3c:	5b                   	pop    %ebx
80103f3d:	5e                   	pop    %esi
80103f3e:	5d                   	pop    %ebp
80103f3f:	c3                   	ret    
    return -1;
80103f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f45:	eb f2                	jmp    80103f39 <argfd+0x44>
    return -1;
80103f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f4c:	eb eb                	jmp    80103f39 <argfd+0x44>
  return 0;
80103f4e:	b8 00 00 00 00       	mov    $0x0,%eax
80103f53:	eb e4                	jmp    80103f39 <argfd+0x44>

80103f55 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80103f55:	55                   	push   %ebp
80103f56:	89 e5                	mov    %esp,%ebp
80103f58:	53                   	push   %ebx
80103f59:	83 ec 04             	sub    $0x4,%esp
80103f5c:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80103f5e:	e8 ba f1 ff ff       	call   8010311d <myproc>
80103f63:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
80103f65:	b8 00 00 00 00       	mov    $0x0,%eax
80103f6a:	83 f8 0f             	cmp    $0xf,%eax
80103f6d:	7f 10                	jg     80103f7f <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
80103f6f:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80103f74:	74 03                	je     80103f79 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
80103f76:	40                   	inc    %eax
80103f77:	eb f1                	jmp    80103f6a <fdalloc+0x15>
      curproc->ofile[fd] = f;
80103f79:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80103f7d:	eb 05                	jmp    80103f84 <fdalloc+0x2f>
    }
  }
  return -1;
80103f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f87:	c9                   	leave  
80103f88:	c3                   	ret    

80103f89 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80103f89:	55                   	push   %ebp
80103f8a:	89 e5                	mov    %esp,%ebp
80103f8c:	56                   	push   %esi
80103f8d:	53                   	push   %ebx
80103f8e:	83 ec 10             	sub    $0x10,%esp
80103f91:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80103f93:	b8 20 00 00 00       	mov    $0x20,%eax
80103f98:	89 c6                	mov    %eax,%esi
80103f9a:	39 43 58             	cmp    %eax,0x58(%ebx)
80103f9d:	76 2e                	jbe    80103fcd <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103f9f:	6a 10                	push   $0x10
80103fa1:	50                   	push   %eax
80103fa2:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103fa5:	50                   	push   %eax
80103fa6:	53                   	push   %ebx
80103fa7:	e8 47 d7 ff ff       	call   801016f3 <readi>
80103fac:	83 c4 10             	add    $0x10,%esp
80103faf:	83 f8 10             	cmp    $0x10,%eax
80103fb2:	75 0c                	jne    80103fc0 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80103fb4:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80103fb9:	75 1e                	jne    80103fd9 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80103fbb:	8d 46 10             	lea    0x10(%esi),%eax
80103fbe:	eb d8                	jmp    80103f98 <isdirempty+0xf>
      panic("isdirempty: readi");
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	68 20 6e 10 80       	push   $0x80106e20
80103fc8:	e8 74 c3 ff ff       	call   80100341 <panic>
      return 0;
  }
  return 1;
80103fcd:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd5:	5b                   	pop    %ebx
80103fd6:	5e                   	pop    %esi
80103fd7:	5d                   	pop    %ebp
80103fd8:	c3                   	ret    
      return 0;
80103fd9:	b8 00 00 00 00       	mov    $0x0,%eax
80103fde:	eb f2                	jmp    80103fd2 <isdirempty+0x49>

80103fe0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 44             	sub    $0x44,%esp
80103fe9:	89 d7                	mov    %edx,%edi
80103feb:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80103fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103ff1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80103ff4:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80103ff7:	52                   	push   %edx
80103ff8:	50                   	push   %eax
80103ff9:	e8 84 db ff ff       	call   80101b82 <nameiparent>
80103ffe:	89 c6                	mov    %eax,%esi
80104000:	83 c4 10             	add    $0x10,%esp
80104003:	85 c0                	test   %eax,%eax
80104005:	0f 84 32 01 00 00    	je     8010413d <create+0x15d>
    return 0;
  ilock(dp);
8010400b:	83 ec 0c             	sub    $0xc,%esp
8010400e:	50                   	push   %eax
8010400f:	e8 f2 d4 ff ff       	call   80101506 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104014:	83 c4 0c             	add    $0xc,%esp
80104017:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010401a:	50                   	push   %eax
8010401b:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010401e:	50                   	push   %eax
8010401f:	56                   	push   %esi
80104020:	e8 17 d9 ff ff       	call   8010193c <dirlookup>
80104025:	89 c3                	mov    %eax,%ebx
80104027:	83 c4 10             	add    $0x10,%esp
8010402a:	85 c0                	test   %eax,%eax
8010402c:	74 3c                	je     8010406a <create+0x8a>
    iunlockput(dp);
8010402e:	83 ec 0c             	sub    $0xc,%esp
80104031:	56                   	push   %esi
80104032:	e8 72 d6 ff ff       	call   801016a9 <iunlockput>
    ilock(ip);
80104037:	89 1c 24             	mov    %ebx,(%esp)
8010403a:	e8 c7 d4 ff ff       	call   80101506 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010403f:	83 c4 10             	add    $0x10,%esp
80104042:	66 83 ff 02          	cmp    $0x2,%di
80104046:	75 07                	jne    8010404f <create+0x6f>
80104048:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010404d:	74 11                	je     80104060 <create+0x80>
      return ip;
    iunlockput(ip);
8010404f:	83 ec 0c             	sub    $0xc,%esp
80104052:	53                   	push   %ebx
80104053:	e8 51 d6 ff ff       	call   801016a9 <iunlockput>
    return 0;
80104058:	83 c4 10             	add    $0x10,%esp
8010405b:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104060:	89 d8                	mov    %ebx,%eax
80104062:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104065:	5b                   	pop    %ebx
80104066:	5e                   	pop    %esi
80104067:	5f                   	pop    %edi
80104068:	5d                   	pop    %ebp
80104069:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
8010406a:	83 ec 08             	sub    $0x8,%esp
8010406d:	0f bf c7             	movswl %di,%eax
80104070:	50                   	push   %eax
80104071:	ff 36                	push   (%esi)
80104073:	e8 96 d2 ff ff       	call   8010130e <ialloc>
80104078:	89 c3                	mov    %eax,%ebx
8010407a:	83 c4 10             	add    $0x10,%esp
8010407d:	85 c0                	test   %eax,%eax
8010407f:	74 53                	je     801040d4 <create+0xf4>
  ilock(ip);
80104081:	83 ec 0c             	sub    $0xc,%esp
80104084:	50                   	push   %eax
80104085:	e8 7c d4 ff ff       	call   80101506 <ilock>
  ip->major = major;
8010408a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010408d:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104091:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104094:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104098:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010409e:	89 1c 24             	mov    %ebx,(%esp)
801040a1:	e8 07 d3 ff ff       	call   801013ad <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801040a6:	83 c4 10             	add    $0x10,%esp
801040a9:	66 83 ff 01          	cmp    $0x1,%di
801040ad:	74 32                	je     801040e1 <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
801040af:	83 ec 04             	sub    $0x4,%esp
801040b2:	ff 73 04             	push   0x4(%ebx)
801040b5:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801040b8:	50                   	push   %eax
801040b9:	56                   	push   %esi
801040ba:	e8 fa d9 ff ff       	call   80101ab9 <dirlink>
801040bf:	83 c4 10             	add    $0x10,%esp
801040c2:	85 c0                	test   %eax,%eax
801040c4:	78 6a                	js     80104130 <create+0x150>
  iunlockput(dp);
801040c6:	83 ec 0c             	sub    $0xc,%esp
801040c9:	56                   	push   %esi
801040ca:	e8 da d5 ff ff       	call   801016a9 <iunlockput>
  return ip;
801040cf:	83 c4 10             	add    $0x10,%esp
801040d2:	eb 8c                	jmp    80104060 <create+0x80>
    panic("create: ialloc");
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	68 32 6e 10 80       	push   $0x80106e32
801040dc:	e8 60 c2 ff ff       	call   80100341 <panic>
    dp->nlink++;  // for ".."
801040e1:	66 8b 46 56          	mov    0x56(%esi),%ax
801040e5:	40                   	inc    %eax
801040e6:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	56                   	push   %esi
801040ee:	e8 ba d2 ff ff       	call   801013ad <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801040f3:	83 c4 0c             	add    $0xc,%esp
801040f6:	ff 73 04             	push   0x4(%ebx)
801040f9:	68 42 6e 10 80       	push   $0x80106e42
801040fe:	53                   	push   %ebx
801040ff:	e8 b5 d9 ff ff       	call   80101ab9 <dirlink>
80104104:	83 c4 10             	add    $0x10,%esp
80104107:	85 c0                	test   %eax,%eax
80104109:	78 18                	js     80104123 <create+0x143>
8010410b:	83 ec 04             	sub    $0x4,%esp
8010410e:	ff 76 04             	push   0x4(%esi)
80104111:	68 41 6e 10 80       	push   $0x80106e41
80104116:	53                   	push   %ebx
80104117:	e8 9d d9 ff ff       	call   80101ab9 <dirlink>
8010411c:	83 c4 10             	add    $0x10,%esp
8010411f:	85 c0                	test   %eax,%eax
80104121:	79 8c                	jns    801040af <create+0xcf>
      panic("create dots");
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	68 44 6e 10 80       	push   $0x80106e44
8010412b:	e8 11 c2 ff ff       	call   80100341 <panic>
    panic("create: dirlink");
80104130:	83 ec 0c             	sub    $0xc,%esp
80104133:	68 50 6e 10 80       	push   $0x80106e50
80104138:	e8 04 c2 ff ff       	call   80100341 <panic>
    return 0;
8010413d:	89 c3                	mov    %eax,%ebx
8010413f:	e9 1c ff ff ff       	jmp    80104060 <create+0x80>

80104144 <sys_dup>:
{
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	53                   	push   %ebx
80104148:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010414b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010414e:	ba 00 00 00 00       	mov    $0x0,%edx
80104153:	b8 00 00 00 00       	mov    $0x0,%eax
80104158:	e8 98 fd ff ff       	call   80103ef5 <argfd>
8010415d:	85 c0                	test   %eax,%eax
8010415f:	78 23                	js     80104184 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104164:	e8 ec fd ff ff       	call   80103f55 <fdalloc>
80104169:	89 c3                	mov    %eax,%ebx
8010416b:	85 c0                	test   %eax,%eax
8010416d:	78 1c                	js     8010418b <sys_dup+0x47>
  filedup(f);
8010416f:	83 ec 0c             	sub    $0xc,%esp
80104172:	ff 75 f4             	push   -0xc(%ebp)
80104175:	e8 cd ca ff ff       	call   80100c47 <filedup>
  return fd;
8010417a:	83 c4 10             	add    $0x10,%esp
}
8010417d:	89 d8                	mov    %ebx,%eax
8010417f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104182:	c9                   	leave  
80104183:	c3                   	ret    
    return -1;
80104184:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104189:	eb f2                	jmp    8010417d <sys_dup+0x39>
    return -1;
8010418b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104190:	eb eb                	jmp    8010417d <sys_dup+0x39>

80104192 <sys_dup2>:
{
80104192:	55                   	push   %ebp
80104193:	89 e5                	mov    %esp,%ebp
80104195:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &oldfd, &f) < 0)
80104198:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010419b:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010419e:	b8 00 00 00 00       	mov    $0x0,%eax
801041a3:	e8 4d fd ff ff       	call   80103ef5 <argfd>
801041a8:	85 c0                	test   %eax,%eax
801041aa:	78 59                	js     80104205 <sys_dup2+0x73>
  if (argint(0, &newfd) < 0)
801041ac:	83 ec 08             	sub    $0x8,%esp
801041af:	8d 45 ec             	lea    -0x14(%ebp),%eax
801041b2:	50                   	push   %eax
801041b3:	6a 00                	push   $0x0
801041b5:	e8 21 fc ff ff       	call   80103ddb <argint>
801041ba:	83 c4 10             	add    $0x10,%esp
801041bd:	85 c0                	test   %eax,%eax
801041bf:	78 4b                	js     8010420c <sys_dup2+0x7a>
  if (oldfd == newfd) {
801041c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801041c4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801041c7:	74 3a                	je     80104203 <sys_dup2+0x71>
  if ((newf = myproc()->ofile[newfd]))
801041c9:	e8 4f ef ff ff       	call   8010311d <myproc>
801041ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
801041d1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801041d5:	85 c0                	test   %eax,%eax
801041d7:	74 0c                	je     801041e5 <sys_dup2+0x53>
    fileclose(newf);
801041d9:	83 ec 0c             	sub    $0xc,%esp
801041dc:	50                   	push   %eax
801041dd:	e8 a8 ca ff ff       	call   80100c8a <fileclose>
801041e2:	83 c4 10             	add    $0x10,%esp
  myproc()->ofile[newfd] = f;
801041e5:	e8 33 ef ff ff       	call   8010311d <myproc>
801041ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ed:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801041f0:	89 54 88 28          	mov    %edx,0x28(%eax,%ecx,4)
  filedup(f);
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	52                   	push   %edx
801041f8:	e8 4a ca ff ff       	call   80100c47 <filedup>
  return newfd;
801041fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104200:	83 c4 10             	add    $0x10,%esp
}
80104203:	c9                   	leave  
80104204:	c3                   	ret    
    return -1;
80104205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010420a:	eb f7                	jmp    80104203 <sys_dup2+0x71>
    return -1;
8010420c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104211:	eb f0                	jmp    80104203 <sys_dup2+0x71>

80104213 <sys_read>:
{
80104213:	55                   	push   %ebp
80104214:	89 e5                	mov    %esp,%ebp
80104216:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104219:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010421c:	ba 00 00 00 00       	mov    $0x0,%edx
80104221:	b8 00 00 00 00       	mov    $0x0,%eax
80104226:	e8 ca fc ff ff       	call   80103ef5 <argfd>
8010422b:	85 c0                	test   %eax,%eax
8010422d:	78 43                	js     80104272 <sys_read+0x5f>
8010422f:	83 ec 08             	sub    $0x8,%esp
80104232:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104235:	50                   	push   %eax
80104236:	6a 02                	push   $0x2
80104238:	e8 9e fb ff ff       	call   80103ddb <argint>
8010423d:	83 c4 10             	add    $0x10,%esp
80104240:	85 c0                	test   %eax,%eax
80104242:	78 2e                	js     80104272 <sys_read+0x5f>
80104244:	83 ec 04             	sub    $0x4,%esp
80104247:	ff 75 f0             	push   -0x10(%ebp)
8010424a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010424d:	50                   	push   %eax
8010424e:	6a 01                	push   $0x1
80104250:	e8 ae fb ff ff       	call   80103e03 <argptr>
80104255:	83 c4 10             	add    $0x10,%esp
80104258:	85 c0                	test   %eax,%eax
8010425a:	78 16                	js     80104272 <sys_read+0x5f>
  return fileread(f, p, n);
8010425c:	83 ec 04             	sub    $0x4,%esp
8010425f:	ff 75 f0             	push   -0x10(%ebp)
80104262:	ff 75 ec             	push   -0x14(%ebp)
80104265:	ff 75 f4             	push   -0xc(%ebp)
80104268:	e8 16 cb ff ff       	call   80100d83 <fileread>
8010426d:	83 c4 10             	add    $0x10,%esp
}
80104270:	c9                   	leave  
80104271:	c3                   	ret    
    return -1;
80104272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104277:	eb f7                	jmp    80104270 <sys_read+0x5d>

80104279 <sys_write>:
{
80104279:	55                   	push   %ebp
8010427a:	89 e5                	mov    %esp,%ebp
8010427c:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
8010427f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104282:	ba 00 00 00 00       	mov    $0x0,%edx
80104287:	b8 00 00 00 00       	mov    $0x0,%eax
8010428c:	e8 64 fc ff ff       	call   80103ef5 <argfd>
80104291:	85 c0                	test   %eax,%eax
80104293:	78 43                	js     801042d8 <sys_write+0x5f>
80104295:	83 ec 08             	sub    $0x8,%esp
80104298:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010429b:	50                   	push   %eax
8010429c:	6a 02                	push   $0x2
8010429e:	e8 38 fb ff ff       	call   80103ddb <argint>
801042a3:	83 c4 10             	add    $0x10,%esp
801042a6:	85 c0                	test   %eax,%eax
801042a8:	78 2e                	js     801042d8 <sys_write+0x5f>
801042aa:	83 ec 04             	sub    $0x4,%esp
801042ad:	ff 75 f0             	push   -0x10(%ebp)
801042b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801042b3:	50                   	push   %eax
801042b4:	6a 01                	push   $0x1
801042b6:	e8 48 fb ff ff       	call   80103e03 <argptr>
801042bb:	83 c4 10             	add    $0x10,%esp
801042be:	85 c0                	test   %eax,%eax
801042c0:	78 16                	js     801042d8 <sys_write+0x5f>
  return filewrite(f, p, n);
801042c2:	83 ec 04             	sub    $0x4,%esp
801042c5:	ff 75 f0             	push   -0x10(%ebp)
801042c8:	ff 75 ec             	push   -0x14(%ebp)
801042cb:	ff 75 f4             	push   -0xc(%ebp)
801042ce:	e8 35 cb ff ff       	call   80100e08 <filewrite>
801042d3:	83 c4 10             	add    $0x10,%esp
}
801042d6:	c9                   	leave  
801042d7:	c3                   	ret    
    return -1;
801042d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042dd:	eb f7                	jmp    801042d6 <sys_write+0x5d>

801042df <sys_close>:
{
801042df:	55                   	push   %ebp
801042e0:	89 e5                	mov    %esp,%ebp
801042e2:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801042e5:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801042e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
801042eb:	b8 00 00 00 00       	mov    $0x0,%eax
801042f0:	e8 00 fc ff ff       	call   80103ef5 <argfd>
801042f5:	85 c0                	test   %eax,%eax
801042f7:	78 25                	js     8010431e <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801042f9:	e8 1f ee ff ff       	call   8010311d <myproc>
801042fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104301:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104308:	00 
  fileclose(f);
80104309:	83 ec 0c             	sub    $0xc,%esp
8010430c:	ff 75 f0             	push   -0x10(%ebp)
8010430f:	e8 76 c9 ff ff       	call   80100c8a <fileclose>
  return 0;
80104314:	83 c4 10             	add    $0x10,%esp
80104317:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010431c:	c9                   	leave  
8010431d:	c3                   	ret    
    return -1;
8010431e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104323:	eb f7                	jmp    8010431c <sys_close+0x3d>

80104325 <sys_fstat>:
{
80104325:	55                   	push   %ebp
80104326:	89 e5                	mov    %esp,%ebp
80104328:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010432b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010432e:	ba 00 00 00 00       	mov    $0x0,%edx
80104333:	b8 00 00 00 00       	mov    $0x0,%eax
80104338:	e8 b8 fb ff ff       	call   80103ef5 <argfd>
8010433d:	85 c0                	test   %eax,%eax
8010433f:	78 2a                	js     8010436b <sys_fstat+0x46>
80104341:	83 ec 04             	sub    $0x4,%esp
80104344:	6a 14                	push   $0x14
80104346:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104349:	50                   	push   %eax
8010434a:	6a 01                	push   $0x1
8010434c:	e8 b2 fa ff ff       	call   80103e03 <argptr>
80104351:	83 c4 10             	add    $0x10,%esp
80104354:	85 c0                	test   %eax,%eax
80104356:	78 13                	js     8010436b <sys_fstat+0x46>
  return filestat(f, st);
80104358:	83 ec 08             	sub    $0x8,%esp
8010435b:	ff 75 f0             	push   -0x10(%ebp)
8010435e:	ff 75 f4             	push   -0xc(%ebp)
80104361:	e8 d6 c9 ff ff       	call   80100d3c <filestat>
80104366:	83 c4 10             	add    $0x10,%esp
}
80104369:	c9                   	leave  
8010436a:	c3                   	ret    
    return -1;
8010436b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104370:	eb f7                	jmp    80104369 <sys_fstat+0x44>

80104372 <sys_link>:
{
80104372:	55                   	push   %ebp
80104373:	89 e5                	mov    %esp,%ebp
80104375:	56                   	push   %esi
80104376:	53                   	push   %ebx
80104377:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010437a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010437d:	50                   	push   %eax
8010437e:	6a 00                	push   $0x0
80104380:	e8 e6 fa ff ff       	call   80103e6b <argstr>
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	85 c0                	test   %eax,%eax
8010438a:	0f 88 d1 00 00 00    	js     80104461 <sys_link+0xef>
80104390:	83 ec 08             	sub    $0x8,%esp
80104393:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104396:	50                   	push   %eax
80104397:	6a 01                	push   $0x1
80104399:	e8 cd fa ff ff       	call   80103e6b <argstr>
8010439e:	83 c4 10             	add    $0x10,%esp
801043a1:	85 c0                	test   %eax,%eax
801043a3:	0f 88 b8 00 00 00    	js     80104461 <sys_link+0xef>
  begin_op();
801043a9:	e8 2e e3 ff ff       	call   801026dc <begin_op>
  if((ip = namei(old)) == 0){
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	ff 75 e0             	push   -0x20(%ebp)
801043b4:	e8 b1 d7 ff ff       	call   80101b6a <namei>
801043b9:	89 c3                	mov    %eax,%ebx
801043bb:	83 c4 10             	add    $0x10,%esp
801043be:	85 c0                	test   %eax,%eax
801043c0:	0f 84 a2 00 00 00    	je     80104468 <sys_link+0xf6>
  ilock(ip);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	50                   	push   %eax
801043ca:	e8 37 d1 ff ff       	call   80101506 <ilock>
  if(ip->type == T_DIR){
801043cf:	83 c4 10             	add    $0x10,%esp
801043d2:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801043d7:	0f 84 97 00 00 00    	je     80104474 <sys_link+0x102>
  ip->nlink++;
801043dd:	66 8b 43 56          	mov    0x56(%ebx),%ax
801043e1:	40                   	inc    %eax
801043e2:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801043e6:	83 ec 0c             	sub    $0xc,%esp
801043e9:	53                   	push   %ebx
801043ea:	e8 be cf ff ff       	call   801013ad <iupdate>
  iunlock(ip);
801043ef:	89 1c 24             	mov    %ebx,(%esp)
801043f2:	e8 cf d1 ff ff       	call   801015c6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801043f7:	83 c4 08             	add    $0x8,%esp
801043fa:	8d 45 ea             	lea    -0x16(%ebp),%eax
801043fd:	50                   	push   %eax
801043fe:	ff 75 e4             	push   -0x1c(%ebp)
80104401:	e8 7c d7 ff ff       	call   80101b82 <nameiparent>
80104406:	89 c6                	mov    %eax,%esi
80104408:	83 c4 10             	add    $0x10,%esp
8010440b:	85 c0                	test   %eax,%eax
8010440d:	0f 84 85 00 00 00    	je     80104498 <sys_link+0x126>
  ilock(dp);
80104413:	83 ec 0c             	sub    $0xc,%esp
80104416:	50                   	push   %eax
80104417:	e8 ea d0 ff ff       	call   80101506 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010441c:	83 c4 10             	add    $0x10,%esp
8010441f:	8b 03                	mov    (%ebx),%eax
80104421:	39 06                	cmp    %eax,(%esi)
80104423:	75 67                	jne    8010448c <sys_link+0x11a>
80104425:	83 ec 04             	sub    $0x4,%esp
80104428:	ff 73 04             	push   0x4(%ebx)
8010442b:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010442e:	50                   	push   %eax
8010442f:	56                   	push   %esi
80104430:	e8 84 d6 ff ff       	call   80101ab9 <dirlink>
80104435:	83 c4 10             	add    $0x10,%esp
80104438:	85 c0                	test   %eax,%eax
8010443a:	78 50                	js     8010448c <sys_link+0x11a>
  iunlockput(dp);
8010443c:	83 ec 0c             	sub    $0xc,%esp
8010443f:	56                   	push   %esi
80104440:	e8 64 d2 ff ff       	call   801016a9 <iunlockput>
  iput(ip);
80104445:	89 1c 24             	mov    %ebx,(%esp)
80104448:	e8 be d1 ff ff       	call   8010160b <iput>
  end_op();
8010444d:	e8 06 e3 ff ff       	call   80102758 <end_op>
  return 0;
80104452:	83 c4 10             	add    $0x10,%esp
80104455:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010445a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445d:	5b                   	pop    %ebx
8010445e:	5e                   	pop    %esi
8010445f:	5d                   	pop    %ebp
80104460:	c3                   	ret    
    return -1;
80104461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104466:	eb f2                	jmp    8010445a <sys_link+0xe8>
    end_op();
80104468:	e8 eb e2 ff ff       	call   80102758 <end_op>
    return -1;
8010446d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104472:	eb e6                	jmp    8010445a <sys_link+0xe8>
    iunlockput(ip);
80104474:	83 ec 0c             	sub    $0xc,%esp
80104477:	53                   	push   %ebx
80104478:	e8 2c d2 ff ff       	call   801016a9 <iunlockput>
    end_op();
8010447d:	e8 d6 e2 ff ff       	call   80102758 <end_op>
    return -1;
80104482:	83 c4 10             	add    $0x10,%esp
80104485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010448a:	eb ce                	jmp    8010445a <sys_link+0xe8>
    iunlockput(dp);
8010448c:	83 ec 0c             	sub    $0xc,%esp
8010448f:	56                   	push   %esi
80104490:	e8 14 d2 ff ff       	call   801016a9 <iunlockput>
    goto bad;
80104495:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	53                   	push   %ebx
8010449c:	e8 65 d0 ff ff       	call   80101506 <ilock>
  ip->nlink--;
801044a1:	66 8b 43 56          	mov    0x56(%ebx),%ax
801044a5:	48                   	dec    %eax
801044a6:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801044aa:	89 1c 24             	mov    %ebx,(%esp)
801044ad:	e8 fb ce ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
801044b2:	89 1c 24             	mov    %ebx,(%esp)
801044b5:	e8 ef d1 ff ff       	call   801016a9 <iunlockput>
  end_op();
801044ba:	e8 99 e2 ff ff       	call   80102758 <end_op>
  return -1;
801044bf:	83 c4 10             	add    $0x10,%esp
801044c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044c7:	eb 91                	jmp    8010445a <sys_link+0xe8>

801044c9 <sys_unlink>:
{
801044c9:	55                   	push   %ebp
801044ca:	89 e5                	mov    %esp,%ebp
801044cc:	57                   	push   %edi
801044cd:	56                   	push   %esi
801044ce:	53                   	push   %ebx
801044cf:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801044d2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801044d5:	50                   	push   %eax
801044d6:	6a 00                	push   $0x0
801044d8:	e8 8e f9 ff ff       	call   80103e6b <argstr>
801044dd:	83 c4 10             	add    $0x10,%esp
801044e0:	85 c0                	test   %eax,%eax
801044e2:	0f 88 7f 01 00 00    	js     80104667 <sys_unlink+0x19e>
  begin_op();
801044e8:	e8 ef e1 ff ff       	call   801026dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801044ed:	83 ec 08             	sub    $0x8,%esp
801044f0:	8d 45 ca             	lea    -0x36(%ebp),%eax
801044f3:	50                   	push   %eax
801044f4:	ff 75 c4             	push   -0x3c(%ebp)
801044f7:	e8 86 d6 ff ff       	call   80101b82 <nameiparent>
801044fc:	89 c6                	mov    %eax,%esi
801044fe:	83 c4 10             	add    $0x10,%esp
80104501:	85 c0                	test   %eax,%eax
80104503:	0f 84 eb 00 00 00    	je     801045f4 <sys_unlink+0x12b>
  ilock(dp);
80104509:	83 ec 0c             	sub    $0xc,%esp
8010450c:	50                   	push   %eax
8010450d:	e8 f4 cf ff ff       	call   80101506 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104512:	83 c4 08             	add    $0x8,%esp
80104515:	68 42 6e 10 80       	push   $0x80106e42
8010451a:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010451d:	50                   	push   %eax
8010451e:	e8 04 d4 ff ff       	call   80101927 <namecmp>
80104523:	83 c4 10             	add    $0x10,%esp
80104526:	85 c0                	test   %eax,%eax
80104528:	0f 84 fa 00 00 00    	je     80104628 <sys_unlink+0x15f>
8010452e:	83 ec 08             	sub    $0x8,%esp
80104531:	68 41 6e 10 80       	push   $0x80106e41
80104536:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104539:	50                   	push   %eax
8010453a:	e8 e8 d3 ff ff       	call   80101927 <namecmp>
8010453f:	83 c4 10             	add    $0x10,%esp
80104542:	85 c0                	test   %eax,%eax
80104544:	0f 84 de 00 00 00    	je     80104628 <sys_unlink+0x15f>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010454a:	83 ec 04             	sub    $0x4,%esp
8010454d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104550:	50                   	push   %eax
80104551:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104554:	50                   	push   %eax
80104555:	56                   	push   %esi
80104556:	e8 e1 d3 ff ff       	call   8010193c <dirlookup>
8010455b:	89 c3                	mov    %eax,%ebx
8010455d:	83 c4 10             	add    $0x10,%esp
80104560:	85 c0                	test   %eax,%eax
80104562:	0f 84 c0 00 00 00    	je     80104628 <sys_unlink+0x15f>
  ilock(ip);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	50                   	push   %eax
8010456c:	e8 95 cf ff ff       	call   80101506 <ilock>
  if(ip->nlink < 1)
80104571:	83 c4 10             	add    $0x10,%esp
80104574:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104579:	0f 8e 81 00 00 00    	jle    80104600 <sys_unlink+0x137>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010457f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104584:	0f 84 83 00 00 00    	je     8010460d <sys_unlink+0x144>
  memset(&de, 0, sizeof(de));
8010458a:	83 ec 04             	sub    $0x4,%esp
8010458d:	6a 10                	push   $0x10
8010458f:	6a 00                	push   $0x0
80104591:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104594:	57                   	push   %edi
80104595:	e8 f2 f5 ff ff       	call   80103b8c <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010459a:	6a 10                	push   $0x10
8010459c:	ff 75 c0             	push   -0x40(%ebp)
8010459f:	57                   	push   %edi
801045a0:	56                   	push   %esi
801045a1:	e8 4d d2 ff ff       	call   801017f3 <writei>
801045a6:	83 c4 20             	add    $0x20,%esp
801045a9:	83 f8 10             	cmp    $0x10,%eax
801045ac:	0f 85 8e 00 00 00    	jne    80104640 <sys_unlink+0x177>
  if(ip->type == T_DIR){
801045b2:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045b7:	0f 84 90 00 00 00    	je     8010464d <sys_unlink+0x184>
  iunlockput(dp);
801045bd:	83 ec 0c             	sub    $0xc,%esp
801045c0:	56                   	push   %esi
801045c1:	e8 e3 d0 ff ff       	call   801016a9 <iunlockput>
  ip->nlink--;
801045c6:	66 8b 43 56          	mov    0x56(%ebx),%ax
801045ca:	48                   	dec    %eax
801045cb:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801045cf:	89 1c 24             	mov    %ebx,(%esp)
801045d2:	e8 d6 cd ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
801045d7:	89 1c 24             	mov    %ebx,(%esp)
801045da:	e8 ca d0 ff ff       	call   801016a9 <iunlockput>
  end_op();
801045df:	e8 74 e1 ff ff       	call   80102758 <end_op>
  return 0;
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045ef:	5b                   	pop    %ebx
801045f0:	5e                   	pop    %esi
801045f1:	5f                   	pop    %edi
801045f2:	5d                   	pop    %ebp
801045f3:	c3                   	ret    
    end_op();
801045f4:	e8 5f e1 ff ff       	call   80102758 <end_op>
    return -1;
801045f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fe:	eb ec                	jmp    801045ec <sys_unlink+0x123>
    panic("unlink: nlink < 1");
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	68 60 6e 10 80       	push   $0x80106e60
80104608:	e8 34 bd ff ff       	call   80100341 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010460d:	89 d8                	mov    %ebx,%eax
8010460f:	e8 75 f9 ff ff       	call   80103f89 <isdirempty>
80104614:	85 c0                	test   %eax,%eax
80104616:	0f 85 6e ff ff ff    	jne    8010458a <sys_unlink+0xc1>
    iunlockput(ip);
8010461c:	83 ec 0c             	sub    $0xc,%esp
8010461f:	53                   	push   %ebx
80104620:	e8 84 d0 ff ff       	call   801016a9 <iunlockput>
    goto bad;
80104625:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	56                   	push   %esi
8010462c:	e8 78 d0 ff ff       	call   801016a9 <iunlockput>
  end_op();
80104631:	e8 22 e1 ff ff       	call   80102758 <end_op>
  return -1;
80104636:	83 c4 10             	add    $0x10,%esp
80104639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463e:	eb ac                	jmp    801045ec <sys_unlink+0x123>
    panic("unlink: writei");
80104640:	83 ec 0c             	sub    $0xc,%esp
80104643:	68 72 6e 10 80       	push   $0x80106e72
80104648:	e8 f4 bc ff ff       	call   80100341 <panic>
    dp->nlink--;
8010464d:	66 8b 46 56          	mov    0x56(%esi),%ax
80104651:	48                   	dec    %eax
80104652:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	56                   	push   %esi
8010465a:	e8 4e cd ff ff       	call   801013ad <iupdate>
8010465f:	83 c4 10             	add    $0x10,%esp
80104662:	e9 56 ff ff ff       	jmp    801045bd <sys_unlink+0xf4>
    return -1;
80104667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010466c:	e9 7b ff ff ff       	jmp    801045ec <sys_unlink+0x123>

80104671 <sys_open>:

int
sys_open(void)
{
80104671:	55                   	push   %ebp
80104672:	89 e5                	mov    %esp,%ebp
80104674:	57                   	push   %edi
80104675:	56                   	push   %esi
80104676:	53                   	push   %ebx
80104677:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010467a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010467d:	50                   	push   %eax
8010467e:	6a 00                	push   $0x0
80104680:	e8 e6 f7 ff ff       	call   80103e6b <argstr>
80104685:	83 c4 10             	add    $0x10,%esp
80104688:	85 c0                	test   %eax,%eax
8010468a:	0f 88 a0 00 00 00    	js     80104730 <sys_open+0xbf>
80104690:	83 ec 08             	sub    $0x8,%esp
80104693:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104696:	50                   	push   %eax
80104697:	6a 01                	push   $0x1
80104699:	e8 3d f7 ff ff       	call   80103ddb <argint>
8010469e:	83 c4 10             	add    $0x10,%esp
801046a1:	85 c0                	test   %eax,%eax
801046a3:	0f 88 87 00 00 00    	js     80104730 <sys_open+0xbf>
    return -1;

  begin_op();
801046a9:	e8 2e e0 ff ff       	call   801026dc <begin_op>

  if(omode & O_CREATE){
801046ae:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801046b2:	0f 84 8b 00 00 00    	je     80104743 <sys_open+0xd2>
    ip = create(path, T_FILE, 0, 0);
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	6a 00                	push   $0x0
801046bd:	b9 00 00 00 00       	mov    $0x0,%ecx
801046c2:	ba 02 00 00 00       	mov    $0x2,%edx
801046c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801046ca:	e8 11 f9 ff ff       	call   80103fe0 <create>
801046cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801046d1:	83 c4 10             	add    $0x10,%esp
801046d4:	85 c0                	test   %eax,%eax
801046d6:	74 5f                	je     80104737 <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801046d8:	e8 09 c5 ff ff       	call   80100be6 <filealloc>
801046dd:	89 c3                	mov    %eax,%ebx
801046df:	85 c0                	test   %eax,%eax
801046e1:	0f 84 b5 00 00 00    	je     8010479c <sys_open+0x12b>
801046e7:	e8 69 f8 ff ff       	call   80103f55 <fdalloc>
801046ec:	89 c7                	mov    %eax,%edi
801046ee:	85 c0                	test   %eax,%eax
801046f0:	0f 88 a6 00 00 00    	js     8010479c <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801046f6:	83 ec 0c             	sub    $0xc,%esp
801046f9:	56                   	push   %esi
801046fa:	e8 c7 ce ff ff       	call   801015c6 <iunlock>
  end_op();
801046ff:	e8 54 e0 ff ff       	call   80102758 <end_op>

  f->type = FD_INODE;
80104704:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
8010470a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010470d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104714:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104717:	83 c4 10             	add    $0x10,%esp
8010471a:	a8 01                	test   $0x1,%al
8010471c:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104720:	a8 03                	test   $0x3,%al
80104722:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104726:	89 f8                	mov    %edi,%eax
80104728:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010472b:	5b                   	pop    %ebx
8010472c:	5e                   	pop    %esi
8010472d:	5f                   	pop    %edi
8010472e:	5d                   	pop    %ebp
8010472f:	c3                   	ret    
    return -1;
80104730:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104735:	eb ef                	jmp    80104726 <sys_open+0xb5>
      end_op();
80104737:	e8 1c e0 ff ff       	call   80102758 <end_op>
      return -1;
8010473c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104741:	eb e3                	jmp    80104726 <sys_open+0xb5>
    if((ip = namei(path)) == 0){
80104743:	83 ec 0c             	sub    $0xc,%esp
80104746:	ff 75 e4             	push   -0x1c(%ebp)
80104749:	e8 1c d4 ff ff       	call   80101b6a <namei>
8010474e:	89 c6                	mov    %eax,%esi
80104750:	83 c4 10             	add    $0x10,%esp
80104753:	85 c0                	test   %eax,%eax
80104755:	74 39                	je     80104790 <sys_open+0x11f>
    ilock(ip);
80104757:	83 ec 0c             	sub    $0xc,%esp
8010475a:	50                   	push   %eax
8010475b:	e8 a6 cd ff ff       	call   80101506 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104760:	83 c4 10             	add    $0x10,%esp
80104763:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104768:	0f 85 6a ff ff ff    	jne    801046d8 <sys_open+0x67>
8010476e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104772:	0f 84 60 ff ff ff    	je     801046d8 <sys_open+0x67>
      iunlockput(ip);
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	56                   	push   %esi
8010477c:	e8 28 cf ff ff       	call   801016a9 <iunlockput>
      end_op();
80104781:	e8 d2 df ff ff       	call   80102758 <end_op>
      return -1;
80104786:	83 c4 10             	add    $0x10,%esp
80104789:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010478e:	eb 96                	jmp    80104726 <sys_open+0xb5>
      end_op();
80104790:	e8 c3 df ff ff       	call   80102758 <end_op>
      return -1;
80104795:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010479a:	eb 8a                	jmp    80104726 <sys_open+0xb5>
    if(f)
8010479c:	85 db                	test   %ebx,%ebx
8010479e:	74 0c                	je     801047ac <sys_open+0x13b>
      fileclose(f);
801047a0:	83 ec 0c             	sub    $0xc,%esp
801047a3:	53                   	push   %ebx
801047a4:	e8 e1 c4 ff ff       	call   80100c8a <fileclose>
801047a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801047ac:	83 ec 0c             	sub    $0xc,%esp
801047af:	56                   	push   %esi
801047b0:	e8 f4 ce ff ff       	call   801016a9 <iunlockput>
    end_op();
801047b5:	e8 9e df ff ff       	call   80102758 <end_op>
    return -1;
801047ba:	83 c4 10             	add    $0x10,%esp
801047bd:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801047c2:	e9 5f ff ff ff       	jmp    80104726 <sys_open+0xb5>

801047c7 <sys_mkdir>:

int
sys_mkdir(void)
{
801047c7:	55                   	push   %ebp
801047c8:	89 e5                	mov    %esp,%ebp
801047ca:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801047cd:	e8 0a df ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801047d2:	83 ec 08             	sub    $0x8,%esp
801047d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047d8:	50                   	push   %eax
801047d9:	6a 00                	push   $0x0
801047db:	e8 8b f6 ff ff       	call   80103e6b <argstr>
801047e0:	83 c4 10             	add    $0x10,%esp
801047e3:	85 c0                	test   %eax,%eax
801047e5:	78 36                	js     8010481d <sys_mkdir+0x56>
801047e7:	83 ec 0c             	sub    $0xc,%esp
801047ea:	6a 00                	push   $0x0
801047ec:	b9 00 00 00 00       	mov    $0x0,%ecx
801047f1:	ba 01 00 00 00       	mov    $0x1,%edx
801047f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f9:	e8 e2 f7 ff ff       	call   80103fe0 <create>
801047fe:	83 c4 10             	add    $0x10,%esp
80104801:	85 c0                	test   %eax,%eax
80104803:	74 18                	je     8010481d <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	50                   	push   %eax
80104809:	e8 9b ce ff ff       	call   801016a9 <iunlockput>
  end_op();
8010480e:	e8 45 df ff ff       	call   80102758 <end_op>
  return 0;
80104813:	83 c4 10             	add    $0x10,%esp
80104816:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010481b:	c9                   	leave  
8010481c:	c3                   	ret    
    end_op();
8010481d:	e8 36 df ff ff       	call   80102758 <end_op>
    return -1;
80104822:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104827:	eb f2                	jmp    8010481b <sys_mkdir+0x54>

80104829 <sys_mknod>:

int
sys_mknod(void)
{
80104829:	55                   	push   %ebp
8010482a:	89 e5                	mov    %esp,%ebp
8010482c:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010482f:	e8 a8 de ff ff       	call   801026dc <begin_op>
  if((argstr(0, &path)) < 0 ||
80104834:	83 ec 08             	sub    $0x8,%esp
80104837:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010483a:	50                   	push   %eax
8010483b:	6a 00                	push   $0x0
8010483d:	e8 29 f6 ff ff       	call   80103e6b <argstr>
80104842:	83 c4 10             	add    $0x10,%esp
80104845:	85 c0                	test   %eax,%eax
80104847:	78 62                	js     801048ab <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104849:	83 ec 08             	sub    $0x8,%esp
8010484c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010484f:	50                   	push   %eax
80104850:	6a 01                	push   $0x1
80104852:	e8 84 f5 ff ff       	call   80103ddb <argint>
  if((argstr(0, &path)) < 0 ||
80104857:	83 c4 10             	add    $0x10,%esp
8010485a:	85 c0                	test   %eax,%eax
8010485c:	78 4d                	js     801048ab <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
8010485e:	83 ec 08             	sub    $0x8,%esp
80104861:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104864:	50                   	push   %eax
80104865:	6a 02                	push   $0x2
80104867:	e8 6f f5 ff ff       	call   80103ddb <argint>
     argint(1, &major) < 0 ||
8010486c:	83 c4 10             	add    $0x10,%esp
8010486f:	85 c0                	test   %eax,%eax
80104871:	78 38                	js     801048ab <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104873:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104877:	83 ec 0c             	sub    $0xc,%esp
8010487a:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
8010487e:	50                   	push   %eax
8010487f:	ba 03 00 00 00       	mov    $0x3,%edx
80104884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104887:	e8 54 f7 ff ff       	call   80103fe0 <create>
     argint(2, &minor) < 0 ||
8010488c:	83 c4 10             	add    $0x10,%esp
8010488f:	85 c0                	test   %eax,%eax
80104891:	74 18                	je     801048ab <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104893:	83 ec 0c             	sub    $0xc,%esp
80104896:	50                   	push   %eax
80104897:	e8 0d ce ff ff       	call   801016a9 <iunlockput>
  end_op();
8010489c:	e8 b7 de ff ff       	call   80102758 <end_op>
  return 0;
801048a1:	83 c4 10             	add    $0x10,%esp
801048a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801048a9:	c9                   	leave  
801048aa:	c3                   	ret    
    end_op();
801048ab:	e8 a8 de ff ff       	call   80102758 <end_op>
    return -1;
801048b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048b5:	eb f2                	jmp    801048a9 <sys_mknod+0x80>

801048b7 <sys_chdir>:

int
sys_chdir(void)
{
801048b7:	55                   	push   %ebp
801048b8:	89 e5                	mov    %esp,%ebp
801048ba:	56                   	push   %esi
801048bb:	53                   	push   %ebx
801048bc:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801048bf:	e8 59 e8 ff ff       	call   8010311d <myproc>
801048c4:	89 c6                	mov    %eax,%esi
  
  begin_op();
801048c6:	e8 11 de ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801048cb:	83 ec 08             	sub    $0x8,%esp
801048ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048d1:	50                   	push   %eax
801048d2:	6a 00                	push   $0x0
801048d4:	e8 92 f5 ff ff       	call   80103e6b <argstr>
801048d9:	83 c4 10             	add    $0x10,%esp
801048dc:	85 c0                	test   %eax,%eax
801048de:	78 52                	js     80104932 <sys_chdir+0x7b>
801048e0:	83 ec 0c             	sub    $0xc,%esp
801048e3:	ff 75 f4             	push   -0xc(%ebp)
801048e6:	e8 7f d2 ff ff       	call   80101b6a <namei>
801048eb:	89 c3                	mov    %eax,%ebx
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	85 c0                	test   %eax,%eax
801048f2:	74 3e                	je     80104932 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
801048f4:	83 ec 0c             	sub    $0xc,%esp
801048f7:	50                   	push   %eax
801048f8:	e8 09 cc ff ff       	call   80101506 <ilock>
  if(ip->type != T_DIR){
801048fd:	83 c4 10             	add    $0x10,%esp
80104900:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104905:	75 37                	jne    8010493e <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104907:	83 ec 0c             	sub    $0xc,%esp
8010490a:	53                   	push   %ebx
8010490b:	e8 b6 cc ff ff       	call   801015c6 <iunlock>
  iput(curproc->cwd);
80104910:	83 c4 04             	add    $0x4,%esp
80104913:	ff 76 68             	push   0x68(%esi)
80104916:	e8 f0 cc ff ff       	call   8010160b <iput>
  end_op();
8010491b:	e8 38 de ff ff       	call   80102758 <end_op>
  curproc->cwd = ip;
80104920:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010492b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010492e:	5b                   	pop    %ebx
8010492f:	5e                   	pop    %esi
80104930:	5d                   	pop    %ebp
80104931:	c3                   	ret    
    end_op();
80104932:	e8 21 de ff ff       	call   80102758 <end_op>
    return -1;
80104937:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010493c:	eb ed                	jmp    8010492b <sys_chdir+0x74>
    iunlockput(ip);
8010493e:	83 ec 0c             	sub    $0xc,%esp
80104941:	53                   	push   %ebx
80104942:	e8 62 cd ff ff       	call   801016a9 <iunlockput>
    end_op();
80104947:	e8 0c de ff ff       	call   80102758 <end_op>
    return -1;
8010494c:	83 c4 10             	add    $0x10,%esp
8010494f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104954:	eb d5                	jmp    8010492b <sys_chdir+0x74>

80104956 <sys_exec>:

int
sys_exec(void)
{
80104956:	55                   	push   %ebp
80104957:	89 e5                	mov    %esp,%ebp
80104959:	53                   	push   %ebx
8010495a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104960:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104963:	50                   	push   %eax
80104964:	6a 00                	push   $0x0
80104966:	e8 00 f5 ff ff       	call   80103e6b <argstr>
8010496b:	83 c4 10             	add    $0x10,%esp
8010496e:	85 c0                	test   %eax,%eax
80104970:	78 38                	js     801049aa <sys_exec+0x54>
80104972:	83 ec 08             	sub    $0x8,%esp
80104975:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010497b:	50                   	push   %eax
8010497c:	6a 01                	push   $0x1
8010497e:	e8 58 f4 ff ff       	call   80103ddb <argint>
80104983:	83 c4 10             	add    $0x10,%esp
80104986:	85 c0                	test   %eax,%eax
80104988:	78 20                	js     801049aa <sys_exec+0x54>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010498a:	83 ec 04             	sub    $0x4,%esp
8010498d:	68 80 00 00 00       	push   $0x80
80104992:	6a 00                	push   $0x0
80104994:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
8010499a:	50                   	push   %eax
8010499b:	e8 ec f1 ff ff       	call   80103b8c <memset>
801049a0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801049a3:	bb 00 00 00 00       	mov    $0x0,%ebx
801049a8:	eb 2a                	jmp    801049d4 <sys_exec+0x7e>
    return -1;
801049aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049af:	eb 76                	jmp    80104a27 <sys_exec+0xd1>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801049b1:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
801049b8:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801049bc:	83 ec 08             	sub    $0x8,%esp
801049bf:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
801049c5:	50                   	push   %eax
801049c6:	ff 75 f4             	push   -0xc(%ebp)
801049c9:	e8 c2 be ff ff       	call   80100890 <exec>
801049ce:	83 c4 10             	add    $0x10,%esp
801049d1:	eb 54                	jmp    80104a27 <sys_exec+0xd1>
  for(i=0;; i++){
801049d3:	43                   	inc    %ebx
    if(i >= NELEM(argv))
801049d4:	83 fb 1f             	cmp    $0x1f,%ebx
801049d7:	77 49                	ja     80104a22 <sys_exec+0xcc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801049d9:	83 ec 08             	sub    $0x8,%esp
801049dc:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801049e2:	50                   	push   %eax
801049e3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
801049e9:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801049ec:	50                   	push   %eax
801049ed:	e8 71 f3 ff ff       	call   80103d63 <fetchint>
801049f2:	83 c4 10             	add    $0x10,%esp
801049f5:	85 c0                	test   %eax,%eax
801049f7:	78 33                	js     80104a2c <sys_exec+0xd6>
    if(uarg == 0){
801049f9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801049ff:	85 c0                	test   %eax,%eax
80104a01:	74 ae                	je     801049b1 <sys_exec+0x5b>
    if(fetchstr(uarg, &argv[i]) < 0)
80104a03:	83 ec 08             	sub    $0x8,%esp
80104a06:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104a0d:	52                   	push   %edx
80104a0e:	50                   	push   %eax
80104a0f:	e8 8a f3 ff ff       	call   80103d9e <fetchstr>
80104a14:	83 c4 10             	add    $0x10,%esp
80104a17:	85 c0                	test   %eax,%eax
80104a19:	79 b8                	jns    801049d3 <sys_exec+0x7d>
      return -1;
80104a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a20:	eb 05                	jmp    80104a27 <sys_exec+0xd1>
      return -1;
80104a22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a2a:	c9                   	leave  
80104a2b:	c3                   	ret    
      return -1;
80104a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a31:	eb f4                	jmp    80104a27 <sys_exec+0xd1>

80104a33 <sys_pipe>:

int
sys_pipe(void)
{
80104a33:	55                   	push   %ebp
80104a34:	89 e5                	mov    %esp,%ebp
80104a36:	53                   	push   %ebx
80104a37:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104a3a:	6a 08                	push   $0x8
80104a3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a3f:	50                   	push   %eax
80104a40:	6a 00                	push   $0x0
80104a42:	e8 bc f3 ff ff       	call   80103e03 <argptr>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	78 79                	js     80104ac7 <sys_pipe+0x94>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104a4e:	83 ec 08             	sub    $0x8,%esp
80104a51:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a54:	50                   	push   %eax
80104a55:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a58:	50                   	push   %eax
80104a59:	e8 f9 e1 ff ff       	call   80102c57 <pipealloc>
80104a5e:	83 c4 10             	add    $0x10,%esp
80104a61:	85 c0                	test   %eax,%eax
80104a63:	78 69                	js     80104ace <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a68:	e8 e8 f4 ff ff       	call   80103f55 <fdalloc>
80104a6d:	89 c3                	mov    %eax,%ebx
80104a6f:	85 c0                	test   %eax,%eax
80104a71:	78 21                	js     80104a94 <sys_pipe+0x61>
80104a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a76:	e8 da f4 ff ff       	call   80103f55 <fdalloc>
80104a7b:	85 c0                	test   %eax,%eax
80104a7d:	78 15                	js     80104a94 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104a7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a82:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a87:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a92:	c9                   	leave  
80104a93:	c3                   	ret    
    if(fd0 >= 0)
80104a94:	85 db                	test   %ebx,%ebx
80104a96:	79 20                	jns    80104ab8 <sys_pipe+0x85>
    fileclose(rf);
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	ff 75 f0             	push   -0x10(%ebp)
80104a9e:	e8 e7 c1 ff ff       	call   80100c8a <fileclose>
    fileclose(wf);
80104aa3:	83 c4 04             	add    $0x4,%esp
80104aa6:	ff 75 ec             	push   -0x14(%ebp)
80104aa9:	e8 dc c1 ff ff       	call   80100c8a <fileclose>
    return -1;
80104aae:	83 c4 10             	add    $0x10,%esp
80104ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab6:	eb d7                	jmp    80104a8f <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104ab8:	e8 60 e6 ff ff       	call   8010311d <myproc>
80104abd:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104ac4:	00 
80104ac5:	eb d1                	jmp    80104a98 <sys_pipe+0x65>
    return -1;
80104ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104acc:	eb c1                	jmp    80104a8f <sys_pipe+0x5c>
    return -1;
80104ace:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad3:	eb ba                	jmp    80104a8f <sys_pipe+0x5c>

80104ad5 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104ad5:	55                   	push   %ebp
80104ad6:	89 e5                	mov    %esp,%ebp
80104ad8:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104adb:	e8 b0 e7 ff ff       	call   80103290 <fork>
}
80104ae0:	c9                   	leave  
80104ae1:	c3                   	ret    

80104ae2 <sys_exit>:

int
sys_exit(void)
{
80104ae2:	55                   	push   %ebp
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	83 ec 20             	sub    $0x20,%esp
  int e;

  if(argint(0, &e) < 0)
80104ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aeb:	50                   	push   %eax
80104aec:	6a 00                	push   $0x0
80104aee:	e8 e8 f2 ff ff       	call   80103ddb <argint>
80104af3:	83 c4 10             	add    $0x10,%esp
80104af6:	85 c0                	test   %eax,%eax
80104af8:	78 15                	js     80104b0f <sys_exit+0x2d>
    return -1;
  exit(e);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	ff 75 f4             	push   -0xc(%ebp)
80104b00:	e8 bd e9 ff ff       	call   801034c2 <exit>
  return 0;  // not reached
80104b05:	83 c4 10             	add    $0x10,%esp
80104b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b0d:	c9                   	leave  
80104b0e:	c3                   	ret    
    return -1;
80104b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b14:	eb f7                	jmp    80104b0d <sys_exit+0x2b>

80104b16 <sys_wait>:

int
sys_wait(void)
{
80104b16:	55                   	push   %ebp
80104b17:	89 e5                	mov    %esp,%ebp
80104b19:	83 ec 1c             	sub    $0x1c,%esp
  int *w;
  int child;


  if(argptr(0, (void **)&w, sizeof(int)) < 0)
80104b1c:	6a 04                	push   $0x4
80104b1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b21:	50                   	push   %eax
80104b22:	6a 00                	push   $0x0
80104b24:	e8 da f2 ff ff       	call   80103e03 <argptr>
80104b29:	83 c4 10             	add    $0x10,%esp
80104b2c:	85 c0                	test   %eax,%eax
80104b2e:	78 10                	js     80104b40 <sys_wait+0x2a>
    return -1;
  child = wait(w);
80104b30:	83 ec 0c             	sub    $0xc,%esp
80104b33:	ff 75 f4             	push   -0xc(%ebp)
80104b36:	e8 25 eb ff ff       	call   80103660 <wait>
  return child;
80104b3b:	83 c4 10             	add    $0x10,%esp
}
80104b3e:	c9                   	leave  
80104b3f:	c3                   	ret    
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b45:	eb f7                	jmp    80104b3e <sys_wait+0x28>

80104b47 <sys_kill>:

int
sys_kill(void)
{
80104b47:	55                   	push   %ebp
80104b48:	89 e5                	mov    %esp,%ebp
80104b4a:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104b4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b50:	50                   	push   %eax
80104b51:	6a 00                	push   $0x0
80104b53:	e8 83 f2 ff ff       	call   80103ddb <argint>
80104b58:	83 c4 10             	add    $0x10,%esp
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	78 10                	js     80104b6f <sys_kill+0x28>
    return -1;
  return kill(pid);
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	ff 75 f4             	push   -0xc(%ebp)
80104b65:	e8 10 ec ff ff       	call   8010377a <kill>
80104b6a:	83 c4 10             	add    $0x10,%esp
}
80104b6d:	c9                   	leave  
80104b6e:	c3                   	ret    
    return -1;
80104b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b74:	eb f7                	jmp    80104b6d <sys_kill+0x26>

80104b76 <sys_getpid>:

int
sys_getpid(void)
{
80104b76:	55                   	push   %ebp
80104b77:	89 e5                	mov    %esp,%ebp
80104b79:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104b7c:	e8 9c e5 ff ff       	call   8010311d <myproc>
80104b81:	8b 40 10             	mov    0x10(%eax),%eax
}
80104b84:	c9                   	leave  
80104b85:	c3                   	ret    

80104b86 <sys_sbrk>:

int
sys_sbrk(void)
{
80104b86:	55                   	push   %ebp
80104b87:	89 e5                	mov    %esp,%ebp
80104b89:	53                   	push   %ebx
80104b8a:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104b8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b90:	50                   	push   %eax
80104b91:	6a 00                	push   $0x0
80104b93:	e8 43 f2 ff ff       	call   80103ddb <argint>
80104b98:	83 c4 10             	add    $0x10,%esp
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	78 18                	js     80104bb7 <sys_sbrk+0x31>
    return -1;
  addr = myproc()->sz;
80104b9f:	e8 79 e5 ff ff       	call   8010311d <myproc>
80104ba4:	8b 18                	mov    (%eax),%ebx
  myproc()->sz +=n;
80104ba6:	e8 72 e5 ff ff       	call   8010311d <myproc>
80104bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bae:	01 10                	add    %edx,(%eax)
  // if(growproc(n) < 0)
  //   return -1;
  return addr;
}
80104bb0:	89 d8                	mov    %ebx,%eax
80104bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
    return -1;
80104bb7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104bbc:	eb f2                	jmp    80104bb0 <sys_sbrk+0x2a>

80104bbe <sys_sleep>:

int
sys_sleep(void)
{
80104bbe:	55                   	push   %ebp
80104bbf:	89 e5                	mov    %esp,%ebp
80104bc1:	53                   	push   %ebx
80104bc2:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104bc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bc8:	50                   	push   %eax
80104bc9:	6a 00                	push   $0x0
80104bcb:	e8 0b f2 ff ff       	call   80103ddb <argint>
80104bd0:	83 c4 10             	add    $0x10,%esp
80104bd3:	85 c0                	test   %eax,%eax
80104bd5:	78 75                	js     80104c4c <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104bd7:	83 ec 0c             	sub    $0xc,%esp
80104bda:	68 e0 3d 11 80       	push   $0x80113de0
80104bdf:	e8 fc ee ff ff       	call   80103ae0 <acquire>
  ticks0 = ticks;
80104be4:	8b 1d c0 3d 11 80    	mov    0x80113dc0,%ebx
  while(ticks - ticks0 < n){
80104bea:	83 c4 10             	add    $0x10,%esp
80104bed:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80104bf2:	29 d8                	sub    %ebx,%eax
80104bf4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104bf7:	73 39                	jae    80104c32 <sys_sleep+0x74>
    if(myproc()->killed){
80104bf9:	e8 1f e5 ff ff       	call   8010311d <myproc>
80104bfe:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104c02:	75 17                	jne    80104c1b <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104c04:	83 ec 08             	sub    $0x8,%esp
80104c07:	68 e0 3d 11 80       	push   $0x80113de0
80104c0c:	68 c0 3d 11 80       	push   $0x80113dc0
80104c11:	e8 b9 e9 ff ff       	call   801035cf <sleep>
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	eb d2                	jmp    80104bed <sys_sleep+0x2f>
      release(&tickslock);
80104c1b:	83 ec 0c             	sub    $0xc,%esp
80104c1e:	68 e0 3d 11 80       	push   $0x80113de0
80104c23:	e8 1d ef ff ff       	call   80103b45 <release>
      return -1;
80104c28:	83 c4 10             	add    $0x10,%esp
80104c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c30:	eb 15                	jmp    80104c47 <sys_sleep+0x89>
  }
  release(&tickslock);
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	68 e0 3d 11 80       	push   $0x80113de0
80104c3a:	e8 06 ef ff ff       	call   80103b45 <release>
  return 0;
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c4a:	c9                   	leave  
80104c4b:	c3                   	ret    
    return -1;
80104c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c51:	eb f4                	jmp    80104c47 <sys_sleep+0x89>

80104c53 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104c53:	55                   	push   %ebp
80104c54:	89 e5                	mov    %esp,%ebp
80104c56:	53                   	push   %ebx
80104c57:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104c5a:	68 e0 3d 11 80       	push   $0x80113de0
80104c5f:	e8 7c ee ff ff       	call   80103ae0 <acquire>
  xticks = ticks;
80104c64:	8b 1d c0 3d 11 80    	mov    0x80113dc0,%ebx
  release(&tickslock);
80104c6a:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104c71:	e8 cf ee ff ff       	call   80103b45 <release>
  return xticks;
}
80104c76:	89 d8                	mov    %ebx,%eax
80104c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c7b:	c9                   	leave  
80104c7c:	c3                   	ret    

80104c7d <sys_date>:

int
sys_date(void)
{
80104c7d:	55                   	push   %ebp
80104c7e:	89 e5                	mov    %esp,%ebp
80104c80:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;

  if(argptr(0, (void **)&r, sizeof(struct rtcdate)) < 0)
80104c83:	6a 18                	push   $0x18
80104c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c88:	50                   	push   %eax
80104c89:	6a 00                	push   $0x0
80104c8b:	e8 73 f1 ff ff       	call   80103e03 <argptr>
80104c90:	83 c4 10             	add    $0x10,%esp
80104c93:	85 c0                	test   %eax,%eax
80104c95:	78 15                	js     80104cac <sys_date+0x2f>
    return -1;
  cmostime(r);
80104c97:	83 ec 0c             	sub    $0xc,%esp
80104c9a:	ff 75 f4             	push   -0xc(%ebp)
80104c9d:	e8 0c d7 ff ff       	call   801023ae <cmostime>
  return 0;
80104ca2:	83 c4 10             	add    $0x10,%esp
80104ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104caa:	c9                   	leave  
80104cab:	c3                   	ret    
    return -1;
80104cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb1:	eb f7                	jmp    80104caa <sys_date+0x2d>

80104cb3 <alltraps>:
80104cb3:	1e                   	push   %ds
80104cb4:	06                   	push   %es
80104cb5:	0f a0                	push   %fs
80104cb7:	0f a8                	push   %gs
80104cb9:	60                   	pusha  
80104cba:	66 b8 10 00          	mov    $0x10,%ax
80104cbe:	8e d8                	mov    %eax,%ds
80104cc0:	8e c0                	mov    %eax,%es
80104cc2:	54                   	push   %esp
80104cc3:	e8 2f 01 00 00       	call   80104df7 <trap>
80104cc8:	83 c4 04             	add    $0x4,%esp

80104ccb <trapret>:
80104ccb:	61                   	popa   
80104ccc:	0f a9                	pop    %gs
80104cce:	0f a1                	pop    %fs
80104cd0:	07                   	pop    %es
80104cd1:	1f                   	pop    %ds
80104cd2:	83 c4 08             	add    $0x8,%esp
80104cd5:	cf                   	iret   

80104cd6 <tvinit>:
int 
mappages(pde_t *pdgir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
80104cd6:	55                   	push   %ebp
80104cd7:	89 e5                	mov    %esp,%ebp
80104cd9:	53                   	push   %ebx
80104cda:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80104cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80104ce2:	eb 72                	jmp    80104d56 <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104ce4:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104ceb:	66 89 0c c5 20 3e 11 	mov    %cx,-0x7feec1e0(,%eax,8)
80104cf2:	80 
80104cf3:	66 c7 04 c5 22 3e 11 	movw   $0x8,-0x7feec1de(,%eax,8)
80104cfa:	80 08 00 
80104cfd:	8a 14 c5 24 3e 11 80 	mov    -0x7feec1dc(,%eax,8),%dl
80104d04:	83 e2 e0             	and    $0xffffffe0,%edx
80104d07:	88 14 c5 24 3e 11 80 	mov    %dl,-0x7feec1dc(,%eax,8)
80104d0e:	c6 04 c5 24 3e 11 80 	movb   $0x0,-0x7feec1dc(,%eax,8)
80104d15:	00 
80104d16:	8a 14 c5 25 3e 11 80 	mov    -0x7feec1db(,%eax,8),%dl
80104d1d:	83 e2 f0             	and    $0xfffffff0,%edx
80104d20:	83 ca 0e             	or     $0xe,%edx
80104d23:	88 14 c5 25 3e 11 80 	mov    %dl,-0x7feec1db(,%eax,8)
80104d2a:	88 d3                	mov    %dl,%bl
80104d2c:	83 e3 ef             	and    $0xffffffef,%ebx
80104d2f:	88 1c c5 25 3e 11 80 	mov    %bl,-0x7feec1db(,%eax,8)
80104d36:	83 e2 8f             	and    $0xffffff8f,%edx
80104d39:	88 14 c5 25 3e 11 80 	mov    %dl,-0x7feec1db(,%eax,8)
80104d40:	83 ca 80             	or     $0xffffff80,%edx
80104d43:	88 14 c5 25 3e 11 80 	mov    %dl,-0x7feec1db(,%eax,8)
80104d4a:	c1 e9 10             	shr    $0x10,%ecx
80104d4d:	66 89 0c c5 26 3e 11 	mov    %cx,-0x7feec1da(,%eax,8)
80104d54:	80 
  for(i = 0; i < 256; i++)
80104d55:	40                   	inc    %eax
80104d56:	3d ff 00 00 00       	cmp    $0xff,%eax
80104d5b:	7e 87                	jle    80104ce4 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104d5d:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104d63:	66 89 15 20 40 11 80 	mov    %dx,0x80114020
80104d6a:	66 c7 05 22 40 11 80 	movw   $0x8,0x80114022
80104d71:	08 00 
80104d73:	a0 24 40 11 80       	mov    0x80114024,%al
80104d78:	83 e0 e0             	and    $0xffffffe0,%eax
80104d7b:	a2 24 40 11 80       	mov    %al,0x80114024
80104d80:	c6 05 24 40 11 80 00 	movb   $0x0,0x80114024
80104d87:	a0 25 40 11 80       	mov    0x80114025,%al
80104d8c:	83 c8 0f             	or     $0xf,%eax
80104d8f:	a2 25 40 11 80       	mov    %al,0x80114025
80104d94:	83 e0 ef             	and    $0xffffffef,%eax
80104d97:	a2 25 40 11 80       	mov    %al,0x80114025
80104d9c:	88 c1                	mov    %al,%cl
80104d9e:	83 c9 60             	or     $0x60,%ecx
80104da1:	88 0d 25 40 11 80    	mov    %cl,0x80114025
80104da7:	83 c8 e0             	or     $0xffffffe0,%eax
80104daa:	a2 25 40 11 80       	mov    %al,0x80114025
80104daf:	c1 ea 10             	shr    $0x10,%edx
80104db2:	66 89 15 26 40 11 80 	mov    %dx,0x80114026

  initlock(&tickslock, "time");
80104db9:	83 ec 08             	sub    $0x8,%esp
80104dbc:	68 81 6e 10 80       	push   $0x80106e81
80104dc1:	68 e0 3d 11 80       	push   $0x80113de0
80104dc6:	e8 de eb ff ff       	call   801039a9 <initlock>
}
80104dcb:	83 c4 10             	add    $0x10,%esp
80104dce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd1:	c9                   	leave  
80104dd2:	c3                   	ret    

80104dd3 <idtinit>:

void
idtinit(void)
{
80104dd3:	55                   	push   %ebp
80104dd4:	89 e5                	mov    %esp,%ebp
80104dd6:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104dd9:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104ddf:	b8 20 3e 11 80       	mov    $0x80113e20,%eax
80104de4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104de8:	c1 e8 10             	shr    $0x10,%eax
80104deb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104def:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104df2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    

80104df7 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104df7:	55                   	push   %ebp
80104df8:	89 e5                	mov    %esp,%ebp
80104dfa:	57                   	push   %edi
80104dfb:	56                   	push   %esi
80104dfc:	53                   	push   %ebx
80104dfd:	83 ec 1c             	sub    $0x1c,%esp
80104e00:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104e03:	8b 43 30             	mov    0x30(%ebx),%eax
80104e06:	83 f8 40             	cmp    $0x40,%eax
80104e09:	74 13                	je     80104e1e <trap+0x27>
    if(myproc()->killed)
      exit(tf->trapno);
    return;
  }

  switch(tf->trapno){
80104e0b:	83 e8 0e             	sub    $0xe,%eax
80104e0e:	83 f8 31             	cmp    $0x31,%eax
80104e11:	0f 87 1e 02 00 00    	ja     80105035 <trap+0x23e>
80104e17:	ff 24 85 58 6f 10 80 	jmp    *-0x7fef90a8(,%eax,4)
    if(myproc()->killed)
80104e1e:	e8 fa e2 ff ff       	call   8010311d <myproc>
80104e23:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e27:	75 2c                	jne    80104e55 <trap+0x5e>
    myproc()->tf = tf;
80104e29:	e8 ef e2 ff ff       	call   8010311d <myproc>
80104e2e:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104e31:	e8 68 f0 ff ff       	call   80103e9e <syscall>
    if(myproc()->killed)
80104e36:	e8 e2 e2 ff ff       	call   8010311d <myproc>
80104e3b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e3f:	0f 84 8e 00 00 00    	je     80104ed3 <trap+0xdc>
      exit(tf->trapno);
80104e45:	83 ec 0c             	sub    $0xc,%esp
80104e48:	ff 73 30             	push   0x30(%ebx)
80104e4b:	e8 72 e6 ff ff       	call   801034c2 <exit>
80104e50:	83 c4 10             	add    $0x10,%esp
    return;
80104e53:	eb 7e                	jmp    80104ed3 <trap+0xdc>
      exit(tf->trapno);
80104e55:	83 ec 0c             	sub    $0xc,%esp
80104e58:	ff 73 30             	push   0x30(%ebx)
80104e5b:	e8 62 e6 ff ff       	call   801034c2 <exit>
80104e60:	83 c4 10             	add    $0x10,%esp
80104e63:	eb c4                	jmp    80104e29 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104e65:	e8 82 e2 ff ff       	call   801030ec <cpuid>
80104e6a:	85 c0                	test   %eax,%eax
80104e6c:	74 6d                	je     80104edb <trap+0xe4>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80104e6e:	e8 86 d4 ff ff       	call   801022f9 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104e73:	e8 a5 e2 ff ff       	call   8010311d <myproc>
80104e78:	85 c0                	test   %eax,%eax
80104e7a:	74 1b                	je     80104e97 <trap+0xa0>
80104e7c:	e8 9c e2 ff ff       	call   8010311d <myproc>
80104e81:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e85:	74 10                	je     80104e97 <trap+0xa0>
80104e87:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104e8a:	83 e0 03             	and    $0x3,%eax
80104e8d:	66 83 f8 03          	cmp    $0x3,%ax
80104e91:	0f 84 31 02 00 00    	je     801050c8 <trap+0x2d1>
    exit(tf->trapno);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104e97:	e8 81 e2 ff ff       	call   8010311d <myproc>
80104e9c:	85 c0                	test   %eax,%eax
80104e9e:	74 0f                	je     80104eaf <trap+0xb8>
80104ea0:	e8 78 e2 ff ff       	call   8010311d <myproc>
80104ea5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104ea9:	0f 84 2c 02 00 00    	je     801050db <trap+0x2e4>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104eaf:	e8 69 e2 ff ff       	call   8010311d <myproc>
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	74 1b                	je     80104ed3 <trap+0xdc>
80104eb8:	e8 60 e2 ff ff       	call   8010311d <myproc>
80104ebd:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104ec1:	74 10                	je     80104ed3 <trap+0xdc>
80104ec3:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104ec6:	83 e0 03             	and    $0x3,%eax
80104ec9:	66 83 f8 03          	cmp    $0x3,%ax
80104ecd:	0f 84 1c 02 00 00    	je     801050ef <trap+0x2f8>
    exit(tf->trapno);
}
80104ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed6:	5b                   	pop    %ebx
80104ed7:	5e                   	pop    %esi
80104ed8:	5f                   	pop    %edi
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    
      acquire(&tickslock);
80104edb:	83 ec 0c             	sub    $0xc,%esp
80104ede:	68 e0 3d 11 80       	push   $0x80113de0
80104ee3:	e8 f8 eb ff ff       	call   80103ae0 <acquire>
      ticks++;
80104ee8:	ff 05 c0 3d 11 80    	incl   0x80113dc0
      wakeup(&ticks);
80104eee:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104ef5:	e8 57 e8 ff ff       	call   80103751 <wakeup>
      release(&tickslock);
80104efa:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104f01:	e8 3f ec ff ff       	call   80103b45 <release>
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	e9 60 ff ff ff       	jmp    80104e6e <trap+0x77>
    ideintr();
80104f0e:	e8 cf cd ff ff       	call   80101ce2 <ideintr>
    lapiceoi();
80104f13:	e8 e1 d3 ff ff       	call   801022f9 <lapiceoi>
    break;
80104f18:	e9 56 ff ff ff       	jmp    80104e73 <trap+0x7c>
    kbdintr();
80104f1d:	e8 21 d2 ff ff       	call   80102143 <kbdintr>
    lapiceoi();
80104f22:	e8 d2 d3 ff ff       	call   801022f9 <lapiceoi>
    break;
80104f27:	e9 47 ff ff ff       	jmp    80104e73 <trap+0x7c>
    uartintr();
80104f2c:	e8 cd 02 00 00       	call   801051fe <uartintr>
    lapiceoi();
80104f31:	e8 c3 d3 ff ff       	call   801022f9 <lapiceoi>
    break;
80104f36:	e9 38 ff ff ff       	jmp    80104e73 <trap+0x7c>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80104f3b:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80104f3e:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80104f41:	e8 a6 e1 ff ff       	call   801030ec <cpuid>
80104f46:	57                   	push   %edi
80104f47:	0f b7 f6             	movzwl %si,%esi
80104f4a:	56                   	push   %esi
80104f4b:	50                   	push   %eax
80104f4c:	68 bc 6e 10 80       	push   $0x80106ebc
80104f51:	e8 84 b6 ff ff       	call   801005da <cprintf>
    lapiceoi();
80104f56:	e8 9e d3 ff ff       	call   801022f9 <lapiceoi>
    break;
80104f5b:	83 c4 10             	add    $0x10,%esp
80104f5e:	e9 10 ff ff ff       	jmp    80104e73 <trap+0x7c>
    if(myproc() == 0){
80104f63:	e8 b5 e1 ff ff       	call   8010311d <myproc>
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	74 7d                	je     80104fe9 <trap+0x1f2>
    mem = kalloc();
80104f6c:	e8 b6 d0 ff ff       	call   80102027 <kalloc>
80104f71:	89 c6                	mov    %eax,%esi
    if (mem == 0) {
80104f73:	85 c0                	test   %eax,%eax
80104f75:	0f 84 99 00 00 00    	je     80105014 <trap+0x21d>
    memset(mem, 0, PGSIZE);
80104f7b:	83 ec 04             	sub    $0x4,%esp
80104f7e:	68 00 10 00 00       	push   $0x1000
80104f83:	6a 00                	push   $0x0
80104f85:	56                   	push   %esi
80104f86:	e8 01 ec ff ff       	call   80103b8c <memset>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80104f8b:	0f 20 d7             	mov    %cr2,%edi
    if (mappages(myproc()->pgdir, (char*)PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80104f8e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80104f94:	e8 84 e1 ff ff       	call   8010311d <myproc>
80104f99:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80104fa0:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80104fa6:	52                   	push   %edx
80104fa7:	68 00 10 00 00       	push   $0x1000
80104fac:	57                   	push   %edi
80104fad:	ff 70 04             	push   0x4(%eax)
80104fb0:	e8 11 10 00 00       	call   80105fc6 <mappages>
80104fb5:	83 c4 20             	add    $0x20,%esp
80104fb8:	85 c0                	test   %eax,%eax
80104fba:	0f 89 b3 fe ff ff    	jns    80104e73 <trap+0x7c>
      cprintf("page mapping failed\n");
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	68 a5 6e 10 80       	push   $0x80106ea5
80104fc8:	e8 0d b6 ff ff       	call   801005da <cprintf>
      kfree(mem);
80104fcd:	89 34 24             	mov    %esi,(%esp)
80104fd0:	e8 3b cf ff ff       	call   80101f10 <kfree>
      myproc()->killed = 1;
80104fd5:	e8 43 e1 ff ff       	call   8010311d <myproc>
80104fda:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104fe1:	83 c4 10             	add    $0x10,%esp
80104fe4:	e9 8a fe ff ff       	jmp    80104e73 <trap+0x7c>
80104fe9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80104fec:	8b 73 38             	mov    0x38(%ebx),%esi
80104fef:	e8 f8 e0 ff ff       	call   801030ec <cpuid>
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	57                   	push   %edi
80104ff8:	56                   	push   %esi
80104ff9:	50                   	push   %eax
80104ffa:	ff 73 30             	push   0x30(%ebx)
80104ffd:	68 e0 6e 10 80       	push   $0x80106ee0
80105002:	e8 d3 b5 ff ff       	call   801005da <cprintf>
      panic("trap");
80105007:	83 c4 14             	add    $0x14,%esp
8010500a:	68 86 6e 10 80       	push   $0x80106e86
8010500f:	e8 2d b3 ff ff       	call   80100341 <panic>
      cprintf("page fault out of memory\n");
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	68 8b 6e 10 80       	push   $0x80106e8b
8010501c:	e8 b9 b5 ff ff       	call   801005da <cprintf>
      myproc()->killed = 1;
80105021:	e8 f7 e0 ff ff       	call   8010311d <myproc>
80105026:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	e9 46 ff ff ff       	jmp    80104f7b <trap+0x184>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105035:	e8 e3 e0 ff ff       	call   8010311d <myproc>
8010503a:	85 c0                	test   %eax,%eax
8010503c:	74 5f                	je     8010509d <trap+0x2a6>
8010503e:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105042:	74 59                	je     8010509d <trap+0x2a6>
80105044:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105047:	8b 43 38             	mov    0x38(%ebx),%eax
8010504a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010504d:	e8 9a e0 ff ff       	call   801030ec <cpuid>
80105052:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105055:	8b 4b 34             	mov    0x34(%ebx),%ecx
80105058:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010505b:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
8010505e:	e8 ba e0 ff ff       	call   8010311d <myproc>
80105063:	8d 50 6c             	lea    0x6c(%eax),%edx
80105066:	89 55 d8             	mov    %edx,-0x28(%ebp)
80105069:	e8 af e0 ff ff       	call   8010311d <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010506e:	57                   	push   %edi
8010506f:	ff 75 e4             	push   -0x1c(%ebp)
80105072:	ff 75 e0             	push   -0x20(%ebp)
80105075:	ff 75 dc             	push   -0x24(%ebp)
80105078:	56                   	push   %esi
80105079:	ff 75 d8             	push   -0x28(%ebp)
8010507c:	ff 70 10             	push   0x10(%eax)
8010507f:	68 14 6f 10 80       	push   $0x80106f14
80105084:	e8 51 b5 ff ff       	call   801005da <cprintf>
    myproc()->killed = 1;
80105089:	83 c4 20             	add    $0x20,%esp
8010508c:	e8 8c e0 ff ff       	call   8010311d <myproc>
80105091:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105098:	e9 d6 fd ff ff       	jmp    80104e73 <trap+0x7c>
8010509d:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801050a0:	8b 73 38             	mov    0x38(%ebx),%esi
801050a3:	e8 44 e0 ff ff       	call   801030ec <cpuid>
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	57                   	push   %edi
801050ac:	56                   	push   %esi
801050ad:	50                   	push   %eax
801050ae:	ff 73 30             	push   0x30(%ebx)
801050b1:	68 e0 6e 10 80       	push   $0x80106ee0
801050b6:	e8 1f b5 ff ff       	call   801005da <cprintf>
      panic("trap");
801050bb:	83 c4 14             	add    $0x14,%esp
801050be:	68 86 6e 10 80       	push   $0x80106e86
801050c3:	e8 79 b2 ff ff       	call   80100341 <panic>
    exit(tf->trapno);
801050c8:	83 ec 0c             	sub    $0xc,%esp
801050cb:	ff 73 30             	push   0x30(%ebx)
801050ce:	e8 ef e3 ff ff       	call   801034c2 <exit>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	e9 bc fd ff ff       	jmp    80104e97 <trap+0xa0>
  if(myproc() && myproc()->state == RUNNING &&
801050db:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801050df:	0f 85 ca fd ff ff    	jne    80104eaf <trap+0xb8>
    yield();
801050e5:	e8 b3 e4 ff ff       	call   8010359d <yield>
801050ea:	e9 c0 fd ff ff       	jmp    80104eaf <trap+0xb8>
    exit(tf->trapno);
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	ff 73 30             	push   0x30(%ebx)
801050f5:	e8 c8 e3 ff ff       	call   801034c2 <exit>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	e9 d1 fd ff ff       	jmp    80104ed3 <trap+0xdc>

80105102 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105102:	83 3d 20 46 11 80 00 	cmpl   $0x0,0x80114620
80105109:	74 14                	je     8010511f <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010510b:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105110:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105111:	a8 01                	test   $0x1,%al
80105113:	74 10                	je     80105125 <uartgetc+0x23>
80105115:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010511a:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010511b:	0f b6 c0             	movzbl %al,%eax
8010511e:	c3                   	ret    
    return -1;
8010511f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105124:	c3                   	ret    
    return -1;
80105125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010512a:	c3                   	ret    

8010512b <uartputc>:
  if(!uart)
8010512b:	83 3d 20 46 11 80 00 	cmpl   $0x0,0x80114620
80105132:	74 39                	je     8010516d <uartputc+0x42>
{
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	53                   	push   %ebx
80105138:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010513b:	bb 00 00 00 00       	mov    $0x0,%ebx
80105140:	eb 0e                	jmp    80105150 <uartputc+0x25>
    microdelay(10);
80105142:	83 ec 0c             	sub    $0xc,%esp
80105145:	6a 0a                	push   $0xa
80105147:	e8 ce d1 ff ff       	call   8010231a <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010514c:	43                   	inc    %ebx
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	83 fb 7f             	cmp    $0x7f,%ebx
80105153:	7f 0a                	jg     8010515f <uartputc+0x34>
80105155:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010515a:	ec                   	in     (%dx),%al
8010515b:	a8 20                	test   $0x20,%al
8010515d:	74 e3                	je     80105142 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010515f:	8b 45 08             	mov    0x8(%ebp),%eax
80105162:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105167:	ee                   	out    %al,(%dx)
}
80105168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010516b:	c9                   	leave  
8010516c:	c3                   	ret    
8010516d:	c3                   	ret    

8010516e <uartinit>:
{
8010516e:	55                   	push   %ebp
8010516f:	89 e5                	mov    %esp,%ebp
80105171:	56                   	push   %esi
80105172:	53                   	push   %ebx
80105173:	b1 00                	mov    $0x0,%cl
80105175:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010517a:	88 c8                	mov    %cl,%al
8010517c:	ee                   	out    %al,(%dx)
8010517d:	be fb 03 00 00       	mov    $0x3fb,%esi
80105182:	b0 80                	mov    $0x80,%al
80105184:	89 f2                	mov    %esi,%edx
80105186:	ee                   	out    %al,(%dx)
80105187:	b0 0c                	mov    $0xc,%al
80105189:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010518e:	ee                   	out    %al,(%dx)
8010518f:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105194:	88 c8                	mov    %cl,%al
80105196:	89 da                	mov    %ebx,%edx
80105198:	ee                   	out    %al,(%dx)
80105199:	b0 03                	mov    $0x3,%al
8010519b:	89 f2                	mov    %esi,%edx
8010519d:	ee                   	out    %al,(%dx)
8010519e:	ba fc 03 00 00       	mov    $0x3fc,%edx
801051a3:	88 c8                	mov    %cl,%al
801051a5:	ee                   	out    %al,(%dx)
801051a6:	b0 01                	mov    $0x1,%al
801051a8:	89 da                	mov    %ebx,%edx
801051aa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801051ab:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051b0:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801051b1:	3c ff                	cmp    $0xff,%al
801051b3:	74 42                	je     801051f7 <uartinit+0x89>
  uart = 1;
801051b5:	c7 05 20 46 11 80 01 	movl   $0x1,0x80114620
801051bc:	00 00 00 
801051bf:	ba fa 03 00 00       	mov    $0x3fa,%edx
801051c4:	ec                   	in     (%dx),%al
801051c5:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051ca:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801051cb:	83 ec 08             	sub    $0x8,%esp
801051ce:	6a 00                	push   $0x0
801051d0:	6a 04                	push   $0x4
801051d2:	e8 0e cd ff ff       	call   80101ee5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801051d7:	83 c4 10             	add    $0x10,%esp
801051da:	bb 20 70 10 80       	mov    $0x80107020,%ebx
801051df:	eb 10                	jmp    801051f1 <uartinit+0x83>
    uartputc(*p);
801051e1:	83 ec 0c             	sub    $0xc,%esp
801051e4:	0f be c0             	movsbl %al,%eax
801051e7:	50                   	push   %eax
801051e8:	e8 3e ff ff ff       	call   8010512b <uartputc>
  for(p="xv6...\n"; *p; p++)
801051ed:	43                   	inc    %ebx
801051ee:	83 c4 10             	add    $0x10,%esp
801051f1:	8a 03                	mov    (%ebx),%al
801051f3:	84 c0                	test   %al,%al
801051f5:	75 ea                	jne    801051e1 <uartinit+0x73>
}
801051f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051fa:	5b                   	pop    %ebx
801051fb:	5e                   	pop    %esi
801051fc:	5d                   	pop    %ebp
801051fd:	c3                   	ret    

801051fe <uartintr>:

void
uartintr(void)
{
801051fe:	55                   	push   %ebp
801051ff:	89 e5                	mov    %esp,%ebp
80105201:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105204:	68 02 51 10 80       	push   $0x80105102
80105209:	e8 f1 b4 ff ff       	call   801006ff <consoleintr>
}
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	c9                   	leave  
80105212:	c3                   	ret    

80105213 <vector0>:
80105213:	6a 00                	push   $0x0
80105215:	6a 00                	push   $0x0
80105217:	e9 97 fa ff ff       	jmp    80104cb3 <alltraps>

8010521c <vector1>:
8010521c:	6a 00                	push   $0x0
8010521e:	6a 01                	push   $0x1
80105220:	e9 8e fa ff ff       	jmp    80104cb3 <alltraps>

80105225 <vector2>:
80105225:	6a 00                	push   $0x0
80105227:	6a 02                	push   $0x2
80105229:	e9 85 fa ff ff       	jmp    80104cb3 <alltraps>

8010522e <vector3>:
8010522e:	6a 00                	push   $0x0
80105230:	6a 03                	push   $0x3
80105232:	e9 7c fa ff ff       	jmp    80104cb3 <alltraps>

80105237 <vector4>:
80105237:	6a 00                	push   $0x0
80105239:	6a 04                	push   $0x4
8010523b:	e9 73 fa ff ff       	jmp    80104cb3 <alltraps>

80105240 <vector5>:
80105240:	6a 00                	push   $0x0
80105242:	6a 05                	push   $0x5
80105244:	e9 6a fa ff ff       	jmp    80104cb3 <alltraps>

80105249 <vector6>:
80105249:	6a 00                	push   $0x0
8010524b:	6a 06                	push   $0x6
8010524d:	e9 61 fa ff ff       	jmp    80104cb3 <alltraps>

80105252 <vector7>:
80105252:	6a 00                	push   $0x0
80105254:	6a 07                	push   $0x7
80105256:	e9 58 fa ff ff       	jmp    80104cb3 <alltraps>

8010525b <vector8>:
8010525b:	6a 08                	push   $0x8
8010525d:	e9 51 fa ff ff       	jmp    80104cb3 <alltraps>

80105262 <vector9>:
80105262:	6a 00                	push   $0x0
80105264:	6a 09                	push   $0x9
80105266:	e9 48 fa ff ff       	jmp    80104cb3 <alltraps>

8010526b <vector10>:
8010526b:	6a 0a                	push   $0xa
8010526d:	e9 41 fa ff ff       	jmp    80104cb3 <alltraps>

80105272 <vector11>:
80105272:	6a 0b                	push   $0xb
80105274:	e9 3a fa ff ff       	jmp    80104cb3 <alltraps>

80105279 <vector12>:
80105279:	6a 0c                	push   $0xc
8010527b:	e9 33 fa ff ff       	jmp    80104cb3 <alltraps>

80105280 <vector13>:
80105280:	6a 0d                	push   $0xd
80105282:	e9 2c fa ff ff       	jmp    80104cb3 <alltraps>

80105287 <vector14>:
80105287:	6a 0e                	push   $0xe
80105289:	e9 25 fa ff ff       	jmp    80104cb3 <alltraps>

8010528e <vector15>:
8010528e:	6a 00                	push   $0x0
80105290:	6a 0f                	push   $0xf
80105292:	e9 1c fa ff ff       	jmp    80104cb3 <alltraps>

80105297 <vector16>:
80105297:	6a 00                	push   $0x0
80105299:	6a 10                	push   $0x10
8010529b:	e9 13 fa ff ff       	jmp    80104cb3 <alltraps>

801052a0 <vector17>:
801052a0:	6a 11                	push   $0x11
801052a2:	e9 0c fa ff ff       	jmp    80104cb3 <alltraps>

801052a7 <vector18>:
801052a7:	6a 00                	push   $0x0
801052a9:	6a 12                	push   $0x12
801052ab:	e9 03 fa ff ff       	jmp    80104cb3 <alltraps>

801052b0 <vector19>:
801052b0:	6a 00                	push   $0x0
801052b2:	6a 13                	push   $0x13
801052b4:	e9 fa f9 ff ff       	jmp    80104cb3 <alltraps>

801052b9 <vector20>:
801052b9:	6a 00                	push   $0x0
801052bb:	6a 14                	push   $0x14
801052bd:	e9 f1 f9 ff ff       	jmp    80104cb3 <alltraps>

801052c2 <vector21>:
801052c2:	6a 00                	push   $0x0
801052c4:	6a 15                	push   $0x15
801052c6:	e9 e8 f9 ff ff       	jmp    80104cb3 <alltraps>

801052cb <vector22>:
801052cb:	6a 00                	push   $0x0
801052cd:	6a 16                	push   $0x16
801052cf:	e9 df f9 ff ff       	jmp    80104cb3 <alltraps>

801052d4 <vector23>:
801052d4:	6a 00                	push   $0x0
801052d6:	6a 17                	push   $0x17
801052d8:	e9 d6 f9 ff ff       	jmp    80104cb3 <alltraps>

801052dd <vector24>:
801052dd:	6a 00                	push   $0x0
801052df:	6a 18                	push   $0x18
801052e1:	e9 cd f9 ff ff       	jmp    80104cb3 <alltraps>

801052e6 <vector25>:
801052e6:	6a 00                	push   $0x0
801052e8:	6a 19                	push   $0x19
801052ea:	e9 c4 f9 ff ff       	jmp    80104cb3 <alltraps>

801052ef <vector26>:
801052ef:	6a 00                	push   $0x0
801052f1:	6a 1a                	push   $0x1a
801052f3:	e9 bb f9 ff ff       	jmp    80104cb3 <alltraps>

801052f8 <vector27>:
801052f8:	6a 00                	push   $0x0
801052fa:	6a 1b                	push   $0x1b
801052fc:	e9 b2 f9 ff ff       	jmp    80104cb3 <alltraps>

80105301 <vector28>:
80105301:	6a 00                	push   $0x0
80105303:	6a 1c                	push   $0x1c
80105305:	e9 a9 f9 ff ff       	jmp    80104cb3 <alltraps>

8010530a <vector29>:
8010530a:	6a 00                	push   $0x0
8010530c:	6a 1d                	push   $0x1d
8010530e:	e9 a0 f9 ff ff       	jmp    80104cb3 <alltraps>

80105313 <vector30>:
80105313:	6a 00                	push   $0x0
80105315:	6a 1e                	push   $0x1e
80105317:	e9 97 f9 ff ff       	jmp    80104cb3 <alltraps>

8010531c <vector31>:
8010531c:	6a 00                	push   $0x0
8010531e:	6a 1f                	push   $0x1f
80105320:	e9 8e f9 ff ff       	jmp    80104cb3 <alltraps>

80105325 <vector32>:
80105325:	6a 00                	push   $0x0
80105327:	6a 20                	push   $0x20
80105329:	e9 85 f9 ff ff       	jmp    80104cb3 <alltraps>

8010532e <vector33>:
8010532e:	6a 00                	push   $0x0
80105330:	6a 21                	push   $0x21
80105332:	e9 7c f9 ff ff       	jmp    80104cb3 <alltraps>

80105337 <vector34>:
80105337:	6a 00                	push   $0x0
80105339:	6a 22                	push   $0x22
8010533b:	e9 73 f9 ff ff       	jmp    80104cb3 <alltraps>

80105340 <vector35>:
80105340:	6a 00                	push   $0x0
80105342:	6a 23                	push   $0x23
80105344:	e9 6a f9 ff ff       	jmp    80104cb3 <alltraps>

80105349 <vector36>:
80105349:	6a 00                	push   $0x0
8010534b:	6a 24                	push   $0x24
8010534d:	e9 61 f9 ff ff       	jmp    80104cb3 <alltraps>

80105352 <vector37>:
80105352:	6a 00                	push   $0x0
80105354:	6a 25                	push   $0x25
80105356:	e9 58 f9 ff ff       	jmp    80104cb3 <alltraps>

8010535b <vector38>:
8010535b:	6a 00                	push   $0x0
8010535d:	6a 26                	push   $0x26
8010535f:	e9 4f f9 ff ff       	jmp    80104cb3 <alltraps>

80105364 <vector39>:
80105364:	6a 00                	push   $0x0
80105366:	6a 27                	push   $0x27
80105368:	e9 46 f9 ff ff       	jmp    80104cb3 <alltraps>

8010536d <vector40>:
8010536d:	6a 00                	push   $0x0
8010536f:	6a 28                	push   $0x28
80105371:	e9 3d f9 ff ff       	jmp    80104cb3 <alltraps>

80105376 <vector41>:
80105376:	6a 00                	push   $0x0
80105378:	6a 29                	push   $0x29
8010537a:	e9 34 f9 ff ff       	jmp    80104cb3 <alltraps>

8010537f <vector42>:
8010537f:	6a 00                	push   $0x0
80105381:	6a 2a                	push   $0x2a
80105383:	e9 2b f9 ff ff       	jmp    80104cb3 <alltraps>

80105388 <vector43>:
80105388:	6a 00                	push   $0x0
8010538a:	6a 2b                	push   $0x2b
8010538c:	e9 22 f9 ff ff       	jmp    80104cb3 <alltraps>

80105391 <vector44>:
80105391:	6a 00                	push   $0x0
80105393:	6a 2c                	push   $0x2c
80105395:	e9 19 f9 ff ff       	jmp    80104cb3 <alltraps>

8010539a <vector45>:
8010539a:	6a 00                	push   $0x0
8010539c:	6a 2d                	push   $0x2d
8010539e:	e9 10 f9 ff ff       	jmp    80104cb3 <alltraps>

801053a3 <vector46>:
801053a3:	6a 00                	push   $0x0
801053a5:	6a 2e                	push   $0x2e
801053a7:	e9 07 f9 ff ff       	jmp    80104cb3 <alltraps>

801053ac <vector47>:
801053ac:	6a 00                	push   $0x0
801053ae:	6a 2f                	push   $0x2f
801053b0:	e9 fe f8 ff ff       	jmp    80104cb3 <alltraps>

801053b5 <vector48>:
801053b5:	6a 00                	push   $0x0
801053b7:	6a 30                	push   $0x30
801053b9:	e9 f5 f8 ff ff       	jmp    80104cb3 <alltraps>

801053be <vector49>:
801053be:	6a 00                	push   $0x0
801053c0:	6a 31                	push   $0x31
801053c2:	e9 ec f8 ff ff       	jmp    80104cb3 <alltraps>

801053c7 <vector50>:
801053c7:	6a 00                	push   $0x0
801053c9:	6a 32                	push   $0x32
801053cb:	e9 e3 f8 ff ff       	jmp    80104cb3 <alltraps>

801053d0 <vector51>:
801053d0:	6a 00                	push   $0x0
801053d2:	6a 33                	push   $0x33
801053d4:	e9 da f8 ff ff       	jmp    80104cb3 <alltraps>

801053d9 <vector52>:
801053d9:	6a 00                	push   $0x0
801053db:	6a 34                	push   $0x34
801053dd:	e9 d1 f8 ff ff       	jmp    80104cb3 <alltraps>

801053e2 <vector53>:
801053e2:	6a 00                	push   $0x0
801053e4:	6a 35                	push   $0x35
801053e6:	e9 c8 f8 ff ff       	jmp    80104cb3 <alltraps>

801053eb <vector54>:
801053eb:	6a 00                	push   $0x0
801053ed:	6a 36                	push   $0x36
801053ef:	e9 bf f8 ff ff       	jmp    80104cb3 <alltraps>

801053f4 <vector55>:
801053f4:	6a 00                	push   $0x0
801053f6:	6a 37                	push   $0x37
801053f8:	e9 b6 f8 ff ff       	jmp    80104cb3 <alltraps>

801053fd <vector56>:
801053fd:	6a 00                	push   $0x0
801053ff:	6a 38                	push   $0x38
80105401:	e9 ad f8 ff ff       	jmp    80104cb3 <alltraps>

80105406 <vector57>:
80105406:	6a 00                	push   $0x0
80105408:	6a 39                	push   $0x39
8010540a:	e9 a4 f8 ff ff       	jmp    80104cb3 <alltraps>

8010540f <vector58>:
8010540f:	6a 00                	push   $0x0
80105411:	6a 3a                	push   $0x3a
80105413:	e9 9b f8 ff ff       	jmp    80104cb3 <alltraps>

80105418 <vector59>:
80105418:	6a 00                	push   $0x0
8010541a:	6a 3b                	push   $0x3b
8010541c:	e9 92 f8 ff ff       	jmp    80104cb3 <alltraps>

80105421 <vector60>:
80105421:	6a 00                	push   $0x0
80105423:	6a 3c                	push   $0x3c
80105425:	e9 89 f8 ff ff       	jmp    80104cb3 <alltraps>

8010542a <vector61>:
8010542a:	6a 00                	push   $0x0
8010542c:	6a 3d                	push   $0x3d
8010542e:	e9 80 f8 ff ff       	jmp    80104cb3 <alltraps>

80105433 <vector62>:
80105433:	6a 00                	push   $0x0
80105435:	6a 3e                	push   $0x3e
80105437:	e9 77 f8 ff ff       	jmp    80104cb3 <alltraps>

8010543c <vector63>:
8010543c:	6a 00                	push   $0x0
8010543e:	6a 3f                	push   $0x3f
80105440:	e9 6e f8 ff ff       	jmp    80104cb3 <alltraps>

80105445 <vector64>:
80105445:	6a 00                	push   $0x0
80105447:	6a 40                	push   $0x40
80105449:	e9 65 f8 ff ff       	jmp    80104cb3 <alltraps>

8010544e <vector65>:
8010544e:	6a 00                	push   $0x0
80105450:	6a 41                	push   $0x41
80105452:	e9 5c f8 ff ff       	jmp    80104cb3 <alltraps>

80105457 <vector66>:
80105457:	6a 00                	push   $0x0
80105459:	6a 42                	push   $0x42
8010545b:	e9 53 f8 ff ff       	jmp    80104cb3 <alltraps>

80105460 <vector67>:
80105460:	6a 00                	push   $0x0
80105462:	6a 43                	push   $0x43
80105464:	e9 4a f8 ff ff       	jmp    80104cb3 <alltraps>

80105469 <vector68>:
80105469:	6a 00                	push   $0x0
8010546b:	6a 44                	push   $0x44
8010546d:	e9 41 f8 ff ff       	jmp    80104cb3 <alltraps>

80105472 <vector69>:
80105472:	6a 00                	push   $0x0
80105474:	6a 45                	push   $0x45
80105476:	e9 38 f8 ff ff       	jmp    80104cb3 <alltraps>

8010547b <vector70>:
8010547b:	6a 00                	push   $0x0
8010547d:	6a 46                	push   $0x46
8010547f:	e9 2f f8 ff ff       	jmp    80104cb3 <alltraps>

80105484 <vector71>:
80105484:	6a 00                	push   $0x0
80105486:	6a 47                	push   $0x47
80105488:	e9 26 f8 ff ff       	jmp    80104cb3 <alltraps>

8010548d <vector72>:
8010548d:	6a 00                	push   $0x0
8010548f:	6a 48                	push   $0x48
80105491:	e9 1d f8 ff ff       	jmp    80104cb3 <alltraps>

80105496 <vector73>:
80105496:	6a 00                	push   $0x0
80105498:	6a 49                	push   $0x49
8010549a:	e9 14 f8 ff ff       	jmp    80104cb3 <alltraps>

8010549f <vector74>:
8010549f:	6a 00                	push   $0x0
801054a1:	6a 4a                	push   $0x4a
801054a3:	e9 0b f8 ff ff       	jmp    80104cb3 <alltraps>

801054a8 <vector75>:
801054a8:	6a 00                	push   $0x0
801054aa:	6a 4b                	push   $0x4b
801054ac:	e9 02 f8 ff ff       	jmp    80104cb3 <alltraps>

801054b1 <vector76>:
801054b1:	6a 00                	push   $0x0
801054b3:	6a 4c                	push   $0x4c
801054b5:	e9 f9 f7 ff ff       	jmp    80104cb3 <alltraps>

801054ba <vector77>:
801054ba:	6a 00                	push   $0x0
801054bc:	6a 4d                	push   $0x4d
801054be:	e9 f0 f7 ff ff       	jmp    80104cb3 <alltraps>

801054c3 <vector78>:
801054c3:	6a 00                	push   $0x0
801054c5:	6a 4e                	push   $0x4e
801054c7:	e9 e7 f7 ff ff       	jmp    80104cb3 <alltraps>

801054cc <vector79>:
801054cc:	6a 00                	push   $0x0
801054ce:	6a 4f                	push   $0x4f
801054d0:	e9 de f7 ff ff       	jmp    80104cb3 <alltraps>

801054d5 <vector80>:
801054d5:	6a 00                	push   $0x0
801054d7:	6a 50                	push   $0x50
801054d9:	e9 d5 f7 ff ff       	jmp    80104cb3 <alltraps>

801054de <vector81>:
801054de:	6a 00                	push   $0x0
801054e0:	6a 51                	push   $0x51
801054e2:	e9 cc f7 ff ff       	jmp    80104cb3 <alltraps>

801054e7 <vector82>:
801054e7:	6a 00                	push   $0x0
801054e9:	6a 52                	push   $0x52
801054eb:	e9 c3 f7 ff ff       	jmp    80104cb3 <alltraps>

801054f0 <vector83>:
801054f0:	6a 00                	push   $0x0
801054f2:	6a 53                	push   $0x53
801054f4:	e9 ba f7 ff ff       	jmp    80104cb3 <alltraps>

801054f9 <vector84>:
801054f9:	6a 00                	push   $0x0
801054fb:	6a 54                	push   $0x54
801054fd:	e9 b1 f7 ff ff       	jmp    80104cb3 <alltraps>

80105502 <vector85>:
80105502:	6a 00                	push   $0x0
80105504:	6a 55                	push   $0x55
80105506:	e9 a8 f7 ff ff       	jmp    80104cb3 <alltraps>

8010550b <vector86>:
8010550b:	6a 00                	push   $0x0
8010550d:	6a 56                	push   $0x56
8010550f:	e9 9f f7 ff ff       	jmp    80104cb3 <alltraps>

80105514 <vector87>:
80105514:	6a 00                	push   $0x0
80105516:	6a 57                	push   $0x57
80105518:	e9 96 f7 ff ff       	jmp    80104cb3 <alltraps>

8010551d <vector88>:
8010551d:	6a 00                	push   $0x0
8010551f:	6a 58                	push   $0x58
80105521:	e9 8d f7 ff ff       	jmp    80104cb3 <alltraps>

80105526 <vector89>:
80105526:	6a 00                	push   $0x0
80105528:	6a 59                	push   $0x59
8010552a:	e9 84 f7 ff ff       	jmp    80104cb3 <alltraps>

8010552f <vector90>:
8010552f:	6a 00                	push   $0x0
80105531:	6a 5a                	push   $0x5a
80105533:	e9 7b f7 ff ff       	jmp    80104cb3 <alltraps>

80105538 <vector91>:
80105538:	6a 00                	push   $0x0
8010553a:	6a 5b                	push   $0x5b
8010553c:	e9 72 f7 ff ff       	jmp    80104cb3 <alltraps>

80105541 <vector92>:
80105541:	6a 00                	push   $0x0
80105543:	6a 5c                	push   $0x5c
80105545:	e9 69 f7 ff ff       	jmp    80104cb3 <alltraps>

8010554a <vector93>:
8010554a:	6a 00                	push   $0x0
8010554c:	6a 5d                	push   $0x5d
8010554e:	e9 60 f7 ff ff       	jmp    80104cb3 <alltraps>

80105553 <vector94>:
80105553:	6a 00                	push   $0x0
80105555:	6a 5e                	push   $0x5e
80105557:	e9 57 f7 ff ff       	jmp    80104cb3 <alltraps>

8010555c <vector95>:
8010555c:	6a 00                	push   $0x0
8010555e:	6a 5f                	push   $0x5f
80105560:	e9 4e f7 ff ff       	jmp    80104cb3 <alltraps>

80105565 <vector96>:
80105565:	6a 00                	push   $0x0
80105567:	6a 60                	push   $0x60
80105569:	e9 45 f7 ff ff       	jmp    80104cb3 <alltraps>

8010556e <vector97>:
8010556e:	6a 00                	push   $0x0
80105570:	6a 61                	push   $0x61
80105572:	e9 3c f7 ff ff       	jmp    80104cb3 <alltraps>

80105577 <vector98>:
80105577:	6a 00                	push   $0x0
80105579:	6a 62                	push   $0x62
8010557b:	e9 33 f7 ff ff       	jmp    80104cb3 <alltraps>

80105580 <vector99>:
80105580:	6a 00                	push   $0x0
80105582:	6a 63                	push   $0x63
80105584:	e9 2a f7 ff ff       	jmp    80104cb3 <alltraps>

80105589 <vector100>:
80105589:	6a 00                	push   $0x0
8010558b:	6a 64                	push   $0x64
8010558d:	e9 21 f7 ff ff       	jmp    80104cb3 <alltraps>

80105592 <vector101>:
80105592:	6a 00                	push   $0x0
80105594:	6a 65                	push   $0x65
80105596:	e9 18 f7 ff ff       	jmp    80104cb3 <alltraps>

8010559b <vector102>:
8010559b:	6a 00                	push   $0x0
8010559d:	6a 66                	push   $0x66
8010559f:	e9 0f f7 ff ff       	jmp    80104cb3 <alltraps>

801055a4 <vector103>:
801055a4:	6a 00                	push   $0x0
801055a6:	6a 67                	push   $0x67
801055a8:	e9 06 f7 ff ff       	jmp    80104cb3 <alltraps>

801055ad <vector104>:
801055ad:	6a 00                	push   $0x0
801055af:	6a 68                	push   $0x68
801055b1:	e9 fd f6 ff ff       	jmp    80104cb3 <alltraps>

801055b6 <vector105>:
801055b6:	6a 00                	push   $0x0
801055b8:	6a 69                	push   $0x69
801055ba:	e9 f4 f6 ff ff       	jmp    80104cb3 <alltraps>

801055bf <vector106>:
801055bf:	6a 00                	push   $0x0
801055c1:	6a 6a                	push   $0x6a
801055c3:	e9 eb f6 ff ff       	jmp    80104cb3 <alltraps>

801055c8 <vector107>:
801055c8:	6a 00                	push   $0x0
801055ca:	6a 6b                	push   $0x6b
801055cc:	e9 e2 f6 ff ff       	jmp    80104cb3 <alltraps>

801055d1 <vector108>:
801055d1:	6a 00                	push   $0x0
801055d3:	6a 6c                	push   $0x6c
801055d5:	e9 d9 f6 ff ff       	jmp    80104cb3 <alltraps>

801055da <vector109>:
801055da:	6a 00                	push   $0x0
801055dc:	6a 6d                	push   $0x6d
801055de:	e9 d0 f6 ff ff       	jmp    80104cb3 <alltraps>

801055e3 <vector110>:
801055e3:	6a 00                	push   $0x0
801055e5:	6a 6e                	push   $0x6e
801055e7:	e9 c7 f6 ff ff       	jmp    80104cb3 <alltraps>

801055ec <vector111>:
801055ec:	6a 00                	push   $0x0
801055ee:	6a 6f                	push   $0x6f
801055f0:	e9 be f6 ff ff       	jmp    80104cb3 <alltraps>

801055f5 <vector112>:
801055f5:	6a 00                	push   $0x0
801055f7:	6a 70                	push   $0x70
801055f9:	e9 b5 f6 ff ff       	jmp    80104cb3 <alltraps>

801055fe <vector113>:
801055fe:	6a 00                	push   $0x0
80105600:	6a 71                	push   $0x71
80105602:	e9 ac f6 ff ff       	jmp    80104cb3 <alltraps>

80105607 <vector114>:
80105607:	6a 00                	push   $0x0
80105609:	6a 72                	push   $0x72
8010560b:	e9 a3 f6 ff ff       	jmp    80104cb3 <alltraps>

80105610 <vector115>:
80105610:	6a 00                	push   $0x0
80105612:	6a 73                	push   $0x73
80105614:	e9 9a f6 ff ff       	jmp    80104cb3 <alltraps>

80105619 <vector116>:
80105619:	6a 00                	push   $0x0
8010561b:	6a 74                	push   $0x74
8010561d:	e9 91 f6 ff ff       	jmp    80104cb3 <alltraps>

80105622 <vector117>:
80105622:	6a 00                	push   $0x0
80105624:	6a 75                	push   $0x75
80105626:	e9 88 f6 ff ff       	jmp    80104cb3 <alltraps>

8010562b <vector118>:
8010562b:	6a 00                	push   $0x0
8010562d:	6a 76                	push   $0x76
8010562f:	e9 7f f6 ff ff       	jmp    80104cb3 <alltraps>

80105634 <vector119>:
80105634:	6a 00                	push   $0x0
80105636:	6a 77                	push   $0x77
80105638:	e9 76 f6 ff ff       	jmp    80104cb3 <alltraps>

8010563d <vector120>:
8010563d:	6a 00                	push   $0x0
8010563f:	6a 78                	push   $0x78
80105641:	e9 6d f6 ff ff       	jmp    80104cb3 <alltraps>

80105646 <vector121>:
80105646:	6a 00                	push   $0x0
80105648:	6a 79                	push   $0x79
8010564a:	e9 64 f6 ff ff       	jmp    80104cb3 <alltraps>

8010564f <vector122>:
8010564f:	6a 00                	push   $0x0
80105651:	6a 7a                	push   $0x7a
80105653:	e9 5b f6 ff ff       	jmp    80104cb3 <alltraps>

80105658 <vector123>:
80105658:	6a 00                	push   $0x0
8010565a:	6a 7b                	push   $0x7b
8010565c:	e9 52 f6 ff ff       	jmp    80104cb3 <alltraps>

80105661 <vector124>:
80105661:	6a 00                	push   $0x0
80105663:	6a 7c                	push   $0x7c
80105665:	e9 49 f6 ff ff       	jmp    80104cb3 <alltraps>

8010566a <vector125>:
8010566a:	6a 00                	push   $0x0
8010566c:	6a 7d                	push   $0x7d
8010566e:	e9 40 f6 ff ff       	jmp    80104cb3 <alltraps>

80105673 <vector126>:
80105673:	6a 00                	push   $0x0
80105675:	6a 7e                	push   $0x7e
80105677:	e9 37 f6 ff ff       	jmp    80104cb3 <alltraps>

8010567c <vector127>:
8010567c:	6a 00                	push   $0x0
8010567e:	6a 7f                	push   $0x7f
80105680:	e9 2e f6 ff ff       	jmp    80104cb3 <alltraps>

80105685 <vector128>:
80105685:	6a 00                	push   $0x0
80105687:	68 80 00 00 00       	push   $0x80
8010568c:	e9 22 f6 ff ff       	jmp    80104cb3 <alltraps>

80105691 <vector129>:
80105691:	6a 00                	push   $0x0
80105693:	68 81 00 00 00       	push   $0x81
80105698:	e9 16 f6 ff ff       	jmp    80104cb3 <alltraps>

8010569d <vector130>:
8010569d:	6a 00                	push   $0x0
8010569f:	68 82 00 00 00       	push   $0x82
801056a4:	e9 0a f6 ff ff       	jmp    80104cb3 <alltraps>

801056a9 <vector131>:
801056a9:	6a 00                	push   $0x0
801056ab:	68 83 00 00 00       	push   $0x83
801056b0:	e9 fe f5 ff ff       	jmp    80104cb3 <alltraps>

801056b5 <vector132>:
801056b5:	6a 00                	push   $0x0
801056b7:	68 84 00 00 00       	push   $0x84
801056bc:	e9 f2 f5 ff ff       	jmp    80104cb3 <alltraps>

801056c1 <vector133>:
801056c1:	6a 00                	push   $0x0
801056c3:	68 85 00 00 00       	push   $0x85
801056c8:	e9 e6 f5 ff ff       	jmp    80104cb3 <alltraps>

801056cd <vector134>:
801056cd:	6a 00                	push   $0x0
801056cf:	68 86 00 00 00       	push   $0x86
801056d4:	e9 da f5 ff ff       	jmp    80104cb3 <alltraps>

801056d9 <vector135>:
801056d9:	6a 00                	push   $0x0
801056db:	68 87 00 00 00       	push   $0x87
801056e0:	e9 ce f5 ff ff       	jmp    80104cb3 <alltraps>

801056e5 <vector136>:
801056e5:	6a 00                	push   $0x0
801056e7:	68 88 00 00 00       	push   $0x88
801056ec:	e9 c2 f5 ff ff       	jmp    80104cb3 <alltraps>

801056f1 <vector137>:
801056f1:	6a 00                	push   $0x0
801056f3:	68 89 00 00 00       	push   $0x89
801056f8:	e9 b6 f5 ff ff       	jmp    80104cb3 <alltraps>

801056fd <vector138>:
801056fd:	6a 00                	push   $0x0
801056ff:	68 8a 00 00 00       	push   $0x8a
80105704:	e9 aa f5 ff ff       	jmp    80104cb3 <alltraps>

80105709 <vector139>:
80105709:	6a 00                	push   $0x0
8010570b:	68 8b 00 00 00       	push   $0x8b
80105710:	e9 9e f5 ff ff       	jmp    80104cb3 <alltraps>

80105715 <vector140>:
80105715:	6a 00                	push   $0x0
80105717:	68 8c 00 00 00       	push   $0x8c
8010571c:	e9 92 f5 ff ff       	jmp    80104cb3 <alltraps>

80105721 <vector141>:
80105721:	6a 00                	push   $0x0
80105723:	68 8d 00 00 00       	push   $0x8d
80105728:	e9 86 f5 ff ff       	jmp    80104cb3 <alltraps>

8010572d <vector142>:
8010572d:	6a 00                	push   $0x0
8010572f:	68 8e 00 00 00       	push   $0x8e
80105734:	e9 7a f5 ff ff       	jmp    80104cb3 <alltraps>

80105739 <vector143>:
80105739:	6a 00                	push   $0x0
8010573b:	68 8f 00 00 00       	push   $0x8f
80105740:	e9 6e f5 ff ff       	jmp    80104cb3 <alltraps>

80105745 <vector144>:
80105745:	6a 00                	push   $0x0
80105747:	68 90 00 00 00       	push   $0x90
8010574c:	e9 62 f5 ff ff       	jmp    80104cb3 <alltraps>

80105751 <vector145>:
80105751:	6a 00                	push   $0x0
80105753:	68 91 00 00 00       	push   $0x91
80105758:	e9 56 f5 ff ff       	jmp    80104cb3 <alltraps>

8010575d <vector146>:
8010575d:	6a 00                	push   $0x0
8010575f:	68 92 00 00 00       	push   $0x92
80105764:	e9 4a f5 ff ff       	jmp    80104cb3 <alltraps>

80105769 <vector147>:
80105769:	6a 00                	push   $0x0
8010576b:	68 93 00 00 00       	push   $0x93
80105770:	e9 3e f5 ff ff       	jmp    80104cb3 <alltraps>

80105775 <vector148>:
80105775:	6a 00                	push   $0x0
80105777:	68 94 00 00 00       	push   $0x94
8010577c:	e9 32 f5 ff ff       	jmp    80104cb3 <alltraps>

80105781 <vector149>:
80105781:	6a 00                	push   $0x0
80105783:	68 95 00 00 00       	push   $0x95
80105788:	e9 26 f5 ff ff       	jmp    80104cb3 <alltraps>

8010578d <vector150>:
8010578d:	6a 00                	push   $0x0
8010578f:	68 96 00 00 00       	push   $0x96
80105794:	e9 1a f5 ff ff       	jmp    80104cb3 <alltraps>

80105799 <vector151>:
80105799:	6a 00                	push   $0x0
8010579b:	68 97 00 00 00       	push   $0x97
801057a0:	e9 0e f5 ff ff       	jmp    80104cb3 <alltraps>

801057a5 <vector152>:
801057a5:	6a 00                	push   $0x0
801057a7:	68 98 00 00 00       	push   $0x98
801057ac:	e9 02 f5 ff ff       	jmp    80104cb3 <alltraps>

801057b1 <vector153>:
801057b1:	6a 00                	push   $0x0
801057b3:	68 99 00 00 00       	push   $0x99
801057b8:	e9 f6 f4 ff ff       	jmp    80104cb3 <alltraps>

801057bd <vector154>:
801057bd:	6a 00                	push   $0x0
801057bf:	68 9a 00 00 00       	push   $0x9a
801057c4:	e9 ea f4 ff ff       	jmp    80104cb3 <alltraps>

801057c9 <vector155>:
801057c9:	6a 00                	push   $0x0
801057cb:	68 9b 00 00 00       	push   $0x9b
801057d0:	e9 de f4 ff ff       	jmp    80104cb3 <alltraps>

801057d5 <vector156>:
801057d5:	6a 00                	push   $0x0
801057d7:	68 9c 00 00 00       	push   $0x9c
801057dc:	e9 d2 f4 ff ff       	jmp    80104cb3 <alltraps>

801057e1 <vector157>:
801057e1:	6a 00                	push   $0x0
801057e3:	68 9d 00 00 00       	push   $0x9d
801057e8:	e9 c6 f4 ff ff       	jmp    80104cb3 <alltraps>

801057ed <vector158>:
801057ed:	6a 00                	push   $0x0
801057ef:	68 9e 00 00 00       	push   $0x9e
801057f4:	e9 ba f4 ff ff       	jmp    80104cb3 <alltraps>

801057f9 <vector159>:
801057f9:	6a 00                	push   $0x0
801057fb:	68 9f 00 00 00       	push   $0x9f
80105800:	e9 ae f4 ff ff       	jmp    80104cb3 <alltraps>

80105805 <vector160>:
80105805:	6a 00                	push   $0x0
80105807:	68 a0 00 00 00       	push   $0xa0
8010580c:	e9 a2 f4 ff ff       	jmp    80104cb3 <alltraps>

80105811 <vector161>:
80105811:	6a 00                	push   $0x0
80105813:	68 a1 00 00 00       	push   $0xa1
80105818:	e9 96 f4 ff ff       	jmp    80104cb3 <alltraps>

8010581d <vector162>:
8010581d:	6a 00                	push   $0x0
8010581f:	68 a2 00 00 00       	push   $0xa2
80105824:	e9 8a f4 ff ff       	jmp    80104cb3 <alltraps>

80105829 <vector163>:
80105829:	6a 00                	push   $0x0
8010582b:	68 a3 00 00 00       	push   $0xa3
80105830:	e9 7e f4 ff ff       	jmp    80104cb3 <alltraps>

80105835 <vector164>:
80105835:	6a 00                	push   $0x0
80105837:	68 a4 00 00 00       	push   $0xa4
8010583c:	e9 72 f4 ff ff       	jmp    80104cb3 <alltraps>

80105841 <vector165>:
80105841:	6a 00                	push   $0x0
80105843:	68 a5 00 00 00       	push   $0xa5
80105848:	e9 66 f4 ff ff       	jmp    80104cb3 <alltraps>

8010584d <vector166>:
8010584d:	6a 00                	push   $0x0
8010584f:	68 a6 00 00 00       	push   $0xa6
80105854:	e9 5a f4 ff ff       	jmp    80104cb3 <alltraps>

80105859 <vector167>:
80105859:	6a 00                	push   $0x0
8010585b:	68 a7 00 00 00       	push   $0xa7
80105860:	e9 4e f4 ff ff       	jmp    80104cb3 <alltraps>

80105865 <vector168>:
80105865:	6a 00                	push   $0x0
80105867:	68 a8 00 00 00       	push   $0xa8
8010586c:	e9 42 f4 ff ff       	jmp    80104cb3 <alltraps>

80105871 <vector169>:
80105871:	6a 00                	push   $0x0
80105873:	68 a9 00 00 00       	push   $0xa9
80105878:	e9 36 f4 ff ff       	jmp    80104cb3 <alltraps>

8010587d <vector170>:
8010587d:	6a 00                	push   $0x0
8010587f:	68 aa 00 00 00       	push   $0xaa
80105884:	e9 2a f4 ff ff       	jmp    80104cb3 <alltraps>

80105889 <vector171>:
80105889:	6a 00                	push   $0x0
8010588b:	68 ab 00 00 00       	push   $0xab
80105890:	e9 1e f4 ff ff       	jmp    80104cb3 <alltraps>

80105895 <vector172>:
80105895:	6a 00                	push   $0x0
80105897:	68 ac 00 00 00       	push   $0xac
8010589c:	e9 12 f4 ff ff       	jmp    80104cb3 <alltraps>

801058a1 <vector173>:
801058a1:	6a 00                	push   $0x0
801058a3:	68 ad 00 00 00       	push   $0xad
801058a8:	e9 06 f4 ff ff       	jmp    80104cb3 <alltraps>

801058ad <vector174>:
801058ad:	6a 00                	push   $0x0
801058af:	68 ae 00 00 00       	push   $0xae
801058b4:	e9 fa f3 ff ff       	jmp    80104cb3 <alltraps>

801058b9 <vector175>:
801058b9:	6a 00                	push   $0x0
801058bb:	68 af 00 00 00       	push   $0xaf
801058c0:	e9 ee f3 ff ff       	jmp    80104cb3 <alltraps>

801058c5 <vector176>:
801058c5:	6a 00                	push   $0x0
801058c7:	68 b0 00 00 00       	push   $0xb0
801058cc:	e9 e2 f3 ff ff       	jmp    80104cb3 <alltraps>

801058d1 <vector177>:
801058d1:	6a 00                	push   $0x0
801058d3:	68 b1 00 00 00       	push   $0xb1
801058d8:	e9 d6 f3 ff ff       	jmp    80104cb3 <alltraps>

801058dd <vector178>:
801058dd:	6a 00                	push   $0x0
801058df:	68 b2 00 00 00       	push   $0xb2
801058e4:	e9 ca f3 ff ff       	jmp    80104cb3 <alltraps>

801058e9 <vector179>:
801058e9:	6a 00                	push   $0x0
801058eb:	68 b3 00 00 00       	push   $0xb3
801058f0:	e9 be f3 ff ff       	jmp    80104cb3 <alltraps>

801058f5 <vector180>:
801058f5:	6a 00                	push   $0x0
801058f7:	68 b4 00 00 00       	push   $0xb4
801058fc:	e9 b2 f3 ff ff       	jmp    80104cb3 <alltraps>

80105901 <vector181>:
80105901:	6a 00                	push   $0x0
80105903:	68 b5 00 00 00       	push   $0xb5
80105908:	e9 a6 f3 ff ff       	jmp    80104cb3 <alltraps>

8010590d <vector182>:
8010590d:	6a 00                	push   $0x0
8010590f:	68 b6 00 00 00       	push   $0xb6
80105914:	e9 9a f3 ff ff       	jmp    80104cb3 <alltraps>

80105919 <vector183>:
80105919:	6a 00                	push   $0x0
8010591b:	68 b7 00 00 00       	push   $0xb7
80105920:	e9 8e f3 ff ff       	jmp    80104cb3 <alltraps>

80105925 <vector184>:
80105925:	6a 00                	push   $0x0
80105927:	68 b8 00 00 00       	push   $0xb8
8010592c:	e9 82 f3 ff ff       	jmp    80104cb3 <alltraps>

80105931 <vector185>:
80105931:	6a 00                	push   $0x0
80105933:	68 b9 00 00 00       	push   $0xb9
80105938:	e9 76 f3 ff ff       	jmp    80104cb3 <alltraps>

8010593d <vector186>:
8010593d:	6a 00                	push   $0x0
8010593f:	68 ba 00 00 00       	push   $0xba
80105944:	e9 6a f3 ff ff       	jmp    80104cb3 <alltraps>

80105949 <vector187>:
80105949:	6a 00                	push   $0x0
8010594b:	68 bb 00 00 00       	push   $0xbb
80105950:	e9 5e f3 ff ff       	jmp    80104cb3 <alltraps>

80105955 <vector188>:
80105955:	6a 00                	push   $0x0
80105957:	68 bc 00 00 00       	push   $0xbc
8010595c:	e9 52 f3 ff ff       	jmp    80104cb3 <alltraps>

80105961 <vector189>:
80105961:	6a 00                	push   $0x0
80105963:	68 bd 00 00 00       	push   $0xbd
80105968:	e9 46 f3 ff ff       	jmp    80104cb3 <alltraps>

8010596d <vector190>:
8010596d:	6a 00                	push   $0x0
8010596f:	68 be 00 00 00       	push   $0xbe
80105974:	e9 3a f3 ff ff       	jmp    80104cb3 <alltraps>

80105979 <vector191>:
80105979:	6a 00                	push   $0x0
8010597b:	68 bf 00 00 00       	push   $0xbf
80105980:	e9 2e f3 ff ff       	jmp    80104cb3 <alltraps>

80105985 <vector192>:
80105985:	6a 00                	push   $0x0
80105987:	68 c0 00 00 00       	push   $0xc0
8010598c:	e9 22 f3 ff ff       	jmp    80104cb3 <alltraps>

80105991 <vector193>:
80105991:	6a 00                	push   $0x0
80105993:	68 c1 00 00 00       	push   $0xc1
80105998:	e9 16 f3 ff ff       	jmp    80104cb3 <alltraps>

8010599d <vector194>:
8010599d:	6a 00                	push   $0x0
8010599f:	68 c2 00 00 00       	push   $0xc2
801059a4:	e9 0a f3 ff ff       	jmp    80104cb3 <alltraps>

801059a9 <vector195>:
801059a9:	6a 00                	push   $0x0
801059ab:	68 c3 00 00 00       	push   $0xc3
801059b0:	e9 fe f2 ff ff       	jmp    80104cb3 <alltraps>

801059b5 <vector196>:
801059b5:	6a 00                	push   $0x0
801059b7:	68 c4 00 00 00       	push   $0xc4
801059bc:	e9 f2 f2 ff ff       	jmp    80104cb3 <alltraps>

801059c1 <vector197>:
801059c1:	6a 00                	push   $0x0
801059c3:	68 c5 00 00 00       	push   $0xc5
801059c8:	e9 e6 f2 ff ff       	jmp    80104cb3 <alltraps>

801059cd <vector198>:
801059cd:	6a 00                	push   $0x0
801059cf:	68 c6 00 00 00       	push   $0xc6
801059d4:	e9 da f2 ff ff       	jmp    80104cb3 <alltraps>

801059d9 <vector199>:
801059d9:	6a 00                	push   $0x0
801059db:	68 c7 00 00 00       	push   $0xc7
801059e0:	e9 ce f2 ff ff       	jmp    80104cb3 <alltraps>

801059e5 <vector200>:
801059e5:	6a 00                	push   $0x0
801059e7:	68 c8 00 00 00       	push   $0xc8
801059ec:	e9 c2 f2 ff ff       	jmp    80104cb3 <alltraps>

801059f1 <vector201>:
801059f1:	6a 00                	push   $0x0
801059f3:	68 c9 00 00 00       	push   $0xc9
801059f8:	e9 b6 f2 ff ff       	jmp    80104cb3 <alltraps>

801059fd <vector202>:
801059fd:	6a 00                	push   $0x0
801059ff:	68 ca 00 00 00       	push   $0xca
80105a04:	e9 aa f2 ff ff       	jmp    80104cb3 <alltraps>

80105a09 <vector203>:
80105a09:	6a 00                	push   $0x0
80105a0b:	68 cb 00 00 00       	push   $0xcb
80105a10:	e9 9e f2 ff ff       	jmp    80104cb3 <alltraps>

80105a15 <vector204>:
80105a15:	6a 00                	push   $0x0
80105a17:	68 cc 00 00 00       	push   $0xcc
80105a1c:	e9 92 f2 ff ff       	jmp    80104cb3 <alltraps>

80105a21 <vector205>:
80105a21:	6a 00                	push   $0x0
80105a23:	68 cd 00 00 00       	push   $0xcd
80105a28:	e9 86 f2 ff ff       	jmp    80104cb3 <alltraps>

80105a2d <vector206>:
80105a2d:	6a 00                	push   $0x0
80105a2f:	68 ce 00 00 00       	push   $0xce
80105a34:	e9 7a f2 ff ff       	jmp    80104cb3 <alltraps>

80105a39 <vector207>:
80105a39:	6a 00                	push   $0x0
80105a3b:	68 cf 00 00 00       	push   $0xcf
80105a40:	e9 6e f2 ff ff       	jmp    80104cb3 <alltraps>

80105a45 <vector208>:
80105a45:	6a 00                	push   $0x0
80105a47:	68 d0 00 00 00       	push   $0xd0
80105a4c:	e9 62 f2 ff ff       	jmp    80104cb3 <alltraps>

80105a51 <vector209>:
80105a51:	6a 00                	push   $0x0
80105a53:	68 d1 00 00 00       	push   $0xd1
80105a58:	e9 56 f2 ff ff       	jmp    80104cb3 <alltraps>

80105a5d <vector210>:
80105a5d:	6a 00                	push   $0x0
80105a5f:	68 d2 00 00 00       	push   $0xd2
80105a64:	e9 4a f2 ff ff       	jmp    80104cb3 <alltraps>

80105a69 <vector211>:
80105a69:	6a 00                	push   $0x0
80105a6b:	68 d3 00 00 00       	push   $0xd3
80105a70:	e9 3e f2 ff ff       	jmp    80104cb3 <alltraps>

80105a75 <vector212>:
80105a75:	6a 00                	push   $0x0
80105a77:	68 d4 00 00 00       	push   $0xd4
80105a7c:	e9 32 f2 ff ff       	jmp    80104cb3 <alltraps>

80105a81 <vector213>:
80105a81:	6a 00                	push   $0x0
80105a83:	68 d5 00 00 00       	push   $0xd5
80105a88:	e9 26 f2 ff ff       	jmp    80104cb3 <alltraps>

80105a8d <vector214>:
80105a8d:	6a 00                	push   $0x0
80105a8f:	68 d6 00 00 00       	push   $0xd6
80105a94:	e9 1a f2 ff ff       	jmp    80104cb3 <alltraps>

80105a99 <vector215>:
80105a99:	6a 00                	push   $0x0
80105a9b:	68 d7 00 00 00       	push   $0xd7
80105aa0:	e9 0e f2 ff ff       	jmp    80104cb3 <alltraps>

80105aa5 <vector216>:
80105aa5:	6a 00                	push   $0x0
80105aa7:	68 d8 00 00 00       	push   $0xd8
80105aac:	e9 02 f2 ff ff       	jmp    80104cb3 <alltraps>

80105ab1 <vector217>:
80105ab1:	6a 00                	push   $0x0
80105ab3:	68 d9 00 00 00       	push   $0xd9
80105ab8:	e9 f6 f1 ff ff       	jmp    80104cb3 <alltraps>

80105abd <vector218>:
80105abd:	6a 00                	push   $0x0
80105abf:	68 da 00 00 00       	push   $0xda
80105ac4:	e9 ea f1 ff ff       	jmp    80104cb3 <alltraps>

80105ac9 <vector219>:
80105ac9:	6a 00                	push   $0x0
80105acb:	68 db 00 00 00       	push   $0xdb
80105ad0:	e9 de f1 ff ff       	jmp    80104cb3 <alltraps>

80105ad5 <vector220>:
80105ad5:	6a 00                	push   $0x0
80105ad7:	68 dc 00 00 00       	push   $0xdc
80105adc:	e9 d2 f1 ff ff       	jmp    80104cb3 <alltraps>

80105ae1 <vector221>:
80105ae1:	6a 00                	push   $0x0
80105ae3:	68 dd 00 00 00       	push   $0xdd
80105ae8:	e9 c6 f1 ff ff       	jmp    80104cb3 <alltraps>

80105aed <vector222>:
80105aed:	6a 00                	push   $0x0
80105aef:	68 de 00 00 00       	push   $0xde
80105af4:	e9 ba f1 ff ff       	jmp    80104cb3 <alltraps>

80105af9 <vector223>:
80105af9:	6a 00                	push   $0x0
80105afb:	68 df 00 00 00       	push   $0xdf
80105b00:	e9 ae f1 ff ff       	jmp    80104cb3 <alltraps>

80105b05 <vector224>:
80105b05:	6a 00                	push   $0x0
80105b07:	68 e0 00 00 00       	push   $0xe0
80105b0c:	e9 a2 f1 ff ff       	jmp    80104cb3 <alltraps>

80105b11 <vector225>:
80105b11:	6a 00                	push   $0x0
80105b13:	68 e1 00 00 00       	push   $0xe1
80105b18:	e9 96 f1 ff ff       	jmp    80104cb3 <alltraps>

80105b1d <vector226>:
80105b1d:	6a 00                	push   $0x0
80105b1f:	68 e2 00 00 00       	push   $0xe2
80105b24:	e9 8a f1 ff ff       	jmp    80104cb3 <alltraps>

80105b29 <vector227>:
80105b29:	6a 00                	push   $0x0
80105b2b:	68 e3 00 00 00       	push   $0xe3
80105b30:	e9 7e f1 ff ff       	jmp    80104cb3 <alltraps>

80105b35 <vector228>:
80105b35:	6a 00                	push   $0x0
80105b37:	68 e4 00 00 00       	push   $0xe4
80105b3c:	e9 72 f1 ff ff       	jmp    80104cb3 <alltraps>

80105b41 <vector229>:
80105b41:	6a 00                	push   $0x0
80105b43:	68 e5 00 00 00       	push   $0xe5
80105b48:	e9 66 f1 ff ff       	jmp    80104cb3 <alltraps>

80105b4d <vector230>:
80105b4d:	6a 00                	push   $0x0
80105b4f:	68 e6 00 00 00       	push   $0xe6
80105b54:	e9 5a f1 ff ff       	jmp    80104cb3 <alltraps>

80105b59 <vector231>:
80105b59:	6a 00                	push   $0x0
80105b5b:	68 e7 00 00 00       	push   $0xe7
80105b60:	e9 4e f1 ff ff       	jmp    80104cb3 <alltraps>

80105b65 <vector232>:
80105b65:	6a 00                	push   $0x0
80105b67:	68 e8 00 00 00       	push   $0xe8
80105b6c:	e9 42 f1 ff ff       	jmp    80104cb3 <alltraps>

80105b71 <vector233>:
80105b71:	6a 00                	push   $0x0
80105b73:	68 e9 00 00 00       	push   $0xe9
80105b78:	e9 36 f1 ff ff       	jmp    80104cb3 <alltraps>

80105b7d <vector234>:
80105b7d:	6a 00                	push   $0x0
80105b7f:	68 ea 00 00 00       	push   $0xea
80105b84:	e9 2a f1 ff ff       	jmp    80104cb3 <alltraps>

80105b89 <vector235>:
80105b89:	6a 00                	push   $0x0
80105b8b:	68 eb 00 00 00       	push   $0xeb
80105b90:	e9 1e f1 ff ff       	jmp    80104cb3 <alltraps>

80105b95 <vector236>:
80105b95:	6a 00                	push   $0x0
80105b97:	68 ec 00 00 00       	push   $0xec
80105b9c:	e9 12 f1 ff ff       	jmp    80104cb3 <alltraps>

80105ba1 <vector237>:
80105ba1:	6a 00                	push   $0x0
80105ba3:	68 ed 00 00 00       	push   $0xed
80105ba8:	e9 06 f1 ff ff       	jmp    80104cb3 <alltraps>

80105bad <vector238>:
80105bad:	6a 00                	push   $0x0
80105baf:	68 ee 00 00 00       	push   $0xee
80105bb4:	e9 fa f0 ff ff       	jmp    80104cb3 <alltraps>

80105bb9 <vector239>:
80105bb9:	6a 00                	push   $0x0
80105bbb:	68 ef 00 00 00       	push   $0xef
80105bc0:	e9 ee f0 ff ff       	jmp    80104cb3 <alltraps>

80105bc5 <vector240>:
80105bc5:	6a 00                	push   $0x0
80105bc7:	68 f0 00 00 00       	push   $0xf0
80105bcc:	e9 e2 f0 ff ff       	jmp    80104cb3 <alltraps>

80105bd1 <vector241>:
80105bd1:	6a 00                	push   $0x0
80105bd3:	68 f1 00 00 00       	push   $0xf1
80105bd8:	e9 d6 f0 ff ff       	jmp    80104cb3 <alltraps>

80105bdd <vector242>:
80105bdd:	6a 00                	push   $0x0
80105bdf:	68 f2 00 00 00       	push   $0xf2
80105be4:	e9 ca f0 ff ff       	jmp    80104cb3 <alltraps>

80105be9 <vector243>:
80105be9:	6a 00                	push   $0x0
80105beb:	68 f3 00 00 00       	push   $0xf3
80105bf0:	e9 be f0 ff ff       	jmp    80104cb3 <alltraps>

80105bf5 <vector244>:
80105bf5:	6a 00                	push   $0x0
80105bf7:	68 f4 00 00 00       	push   $0xf4
80105bfc:	e9 b2 f0 ff ff       	jmp    80104cb3 <alltraps>

80105c01 <vector245>:
80105c01:	6a 00                	push   $0x0
80105c03:	68 f5 00 00 00       	push   $0xf5
80105c08:	e9 a6 f0 ff ff       	jmp    80104cb3 <alltraps>

80105c0d <vector246>:
80105c0d:	6a 00                	push   $0x0
80105c0f:	68 f6 00 00 00       	push   $0xf6
80105c14:	e9 9a f0 ff ff       	jmp    80104cb3 <alltraps>

80105c19 <vector247>:
80105c19:	6a 00                	push   $0x0
80105c1b:	68 f7 00 00 00       	push   $0xf7
80105c20:	e9 8e f0 ff ff       	jmp    80104cb3 <alltraps>

80105c25 <vector248>:
80105c25:	6a 00                	push   $0x0
80105c27:	68 f8 00 00 00       	push   $0xf8
80105c2c:	e9 82 f0 ff ff       	jmp    80104cb3 <alltraps>

80105c31 <vector249>:
80105c31:	6a 00                	push   $0x0
80105c33:	68 f9 00 00 00       	push   $0xf9
80105c38:	e9 76 f0 ff ff       	jmp    80104cb3 <alltraps>

80105c3d <vector250>:
80105c3d:	6a 00                	push   $0x0
80105c3f:	68 fa 00 00 00       	push   $0xfa
80105c44:	e9 6a f0 ff ff       	jmp    80104cb3 <alltraps>

80105c49 <vector251>:
80105c49:	6a 00                	push   $0x0
80105c4b:	68 fb 00 00 00       	push   $0xfb
80105c50:	e9 5e f0 ff ff       	jmp    80104cb3 <alltraps>

80105c55 <vector252>:
80105c55:	6a 00                	push   $0x0
80105c57:	68 fc 00 00 00       	push   $0xfc
80105c5c:	e9 52 f0 ff ff       	jmp    80104cb3 <alltraps>

80105c61 <vector253>:
80105c61:	6a 00                	push   $0x0
80105c63:	68 fd 00 00 00       	push   $0xfd
80105c68:	e9 46 f0 ff ff       	jmp    80104cb3 <alltraps>

80105c6d <vector254>:
80105c6d:	6a 00                	push   $0x0
80105c6f:	68 fe 00 00 00       	push   $0xfe
80105c74:	e9 3a f0 ff ff       	jmp    80104cb3 <alltraps>

80105c79 <vector255>:
80105c79:	6a 00                	push   $0x0
80105c7b:	68 ff 00 00 00       	push   $0xff
80105c80:	e9 2e f0 ff ff       	jmp    80104cb3 <alltraps>

80105c85 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105c85:	55                   	push   %ebp
80105c86:	89 e5                	mov    %esp,%ebp
80105c88:	57                   	push   %edi
80105c89:	56                   	push   %esi
80105c8a:	53                   	push   %ebx
80105c8b:	83 ec 0c             	sub    $0xc,%esp
80105c8e:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105c90:	c1 ea 16             	shr    $0x16,%edx
80105c93:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105c96:	8b 37                	mov    (%edi),%esi
80105c98:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105c9e:	74 20                	je     80105cc0 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105ca0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105ca6:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105cac:	c1 eb 0c             	shr    $0xc,%ebx
80105caf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105cb5:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cbb:	5b                   	pop    %ebx
80105cbc:	5e                   	pop    %esi
80105cbd:	5f                   	pop    %edi
80105cbe:	5d                   	pop    %ebp
80105cbf:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105cc0:	85 c9                	test   %ecx,%ecx
80105cc2:	74 2b                	je     80105cef <walkpgdir+0x6a>
80105cc4:	e8 5e c3 ff ff       	call   80102027 <kalloc>
80105cc9:	89 c6                	mov    %eax,%esi
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	74 20                	je     80105cef <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105ccf:	83 ec 04             	sub    $0x4,%esp
80105cd2:	68 00 10 00 00       	push   $0x1000
80105cd7:	6a 00                	push   $0x0
80105cd9:	50                   	push   %eax
80105cda:	e8 ad de ff ff       	call   80103b8c <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105cdf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105ce5:	83 c8 07             	or     $0x7,%eax
80105ce8:	89 07                	mov    %eax,(%edi)
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	eb bd                	jmp    80105cac <walkpgdir+0x27>
      return 0;
80105cef:	b8 00 00 00 00       	mov    $0x0,%eax
80105cf4:	eb c2                	jmp    80105cb8 <walkpgdir+0x33>

80105cf6 <seginit>:
{
80105cf6:	55                   	push   %ebp
80105cf7:	89 e5                	mov    %esp,%ebp
80105cf9:	57                   	push   %edi
80105cfa:	56                   	push   %esi
80105cfb:	53                   	push   %ebx
80105cfc:	83 ec 2c             	sub    $0x2c,%esp
  c = &cpus[cpuid()];
80105cff:	e8 e8 d3 ff ff       	call   801030ec <cpuid>
80105d04:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105d06:	8d 14 80             	lea    (%eax,%eax,4),%edx
80105d09:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
80105d0c:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80105d0f:	c1 e0 04             	shl    $0x4,%eax
80105d12:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
80105d19:	ff ff 
80105d1b:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
80105d22:	00 00 
80105d24:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
80105d2b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80105d2e:	01 d9                	add    %ebx,%ecx
80105d30:	c1 e1 04             	shl    $0x4,%ecx
80105d33:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
80105d3a:	83 e6 f0             	and    $0xfffffff0,%esi
80105d3d:	89 f7                	mov    %esi,%edi
80105d3f:	83 cf 0a             	or     $0xa,%edi
80105d42:	89 fa                	mov    %edi,%edx
80105d44:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105d4a:	83 ce 1a             	or     $0x1a,%esi
80105d4d:	89 f2                	mov    %esi,%edx
80105d4f:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105d55:	83 e6 9f             	and    $0xffffff9f,%esi
80105d58:	89 f2                	mov    %esi,%edx
80105d5a:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105d60:	83 ce 80             	or     $0xffffff80,%esi
80105d63:	89 f2                	mov    %esi,%edx
80105d65:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105d6b:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
80105d72:	83 ce 0f             	or     $0xf,%esi
80105d75:	89 f2                	mov    %esi,%edx
80105d77:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105d7d:	89 f7                	mov    %esi,%edi
80105d7f:	83 e7 ef             	and    $0xffffffef,%edi
80105d82:	89 fa                	mov    %edi,%edx
80105d84:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105d8a:	83 e6 cf             	and    $0xffffffcf,%esi
80105d8d:	89 f2                	mov    %esi,%edx
80105d8f:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105d95:	89 f7                	mov    %esi,%edi
80105d97:	83 cf 40             	or     $0x40,%edi
80105d9a:	89 fa                	mov    %edi,%edx
80105d9c:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105da2:	83 ce c0             	or     $0xffffffc0,%esi
80105da5:	89 f2                	mov    %esi,%edx
80105da7:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105dad:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105db4:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
80105dbb:	ff ff 
80105dbd:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
80105dc4:	00 00 
80105dc6:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
80105dcd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105dd0:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80105dd3:	c1 e1 04             	shl    $0x4,%ecx
80105dd6:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
80105ddd:	83 e6 f0             	and    $0xfffffff0,%esi
80105de0:	89 f7                	mov    %esi,%edi
80105de2:	83 cf 02             	or     $0x2,%edi
80105de5:	89 fa                	mov    %edi,%edx
80105de7:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105ded:	83 ce 12             	or     $0x12,%esi
80105df0:	89 f2                	mov    %esi,%edx
80105df2:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105df8:	83 e6 9f             	and    $0xffffff9f,%esi
80105dfb:	89 f2                	mov    %esi,%edx
80105dfd:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105e03:	83 ce 80             	or     $0xffffff80,%esi
80105e06:	89 f2                	mov    %esi,%edx
80105e08:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105e0e:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
80105e15:	83 ce 0f             	or     $0xf,%esi
80105e18:	89 f2                	mov    %esi,%edx
80105e1a:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105e20:	89 f7                	mov    %esi,%edi
80105e22:	83 e7 ef             	and    $0xffffffef,%edi
80105e25:	89 fa                	mov    %edi,%edx
80105e27:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105e2d:	83 e6 cf             	and    $0xffffffcf,%esi
80105e30:	89 f2                	mov    %esi,%edx
80105e32:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105e38:	89 f7                	mov    %esi,%edi
80105e3a:	83 cf 40             	or     $0x40,%edi
80105e3d:	89 fa                	mov    %edi,%edx
80105e3f:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105e45:	83 ce c0             	or     $0xffffffc0,%esi
80105e48:	89 f2                	mov    %esi,%edx
80105e4a:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105e50:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105e57:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
80105e5e:	ff ff 
80105e60:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
80105e67:	00 00 
80105e69:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
80105e70:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105e73:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80105e76:	c1 e1 04             	shl    $0x4,%ecx
80105e79:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
80105e80:	83 e6 f0             	and    $0xfffffff0,%esi
80105e83:	89 f7                	mov    %esi,%edi
80105e85:	83 cf 0a             	or     $0xa,%edi
80105e88:	89 fa                	mov    %edi,%edx
80105e8a:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80105e90:	89 f7                	mov    %esi,%edi
80105e92:	83 cf 1a             	or     $0x1a,%edi
80105e95:	89 fa                	mov    %edi,%edx
80105e97:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80105e9d:	83 ce 7a             	or     $0x7a,%esi
80105ea0:	89 f2                	mov    %esi,%edx
80105ea2:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80105ea8:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
80105eaf:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
80105eb6:	83 ce 0f             	or     $0xf,%esi
80105eb9:	89 f2                	mov    %esi,%edx
80105ebb:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80105ec1:	89 f7                	mov    %esi,%edi
80105ec3:	83 e7 ef             	and    $0xffffffef,%edi
80105ec6:	89 fa                	mov    %edi,%edx
80105ec8:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80105ece:	83 e6 cf             	and    $0xffffffcf,%esi
80105ed1:	89 f2                	mov    %esi,%edx
80105ed3:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80105ed9:	89 f7                	mov    %esi,%edi
80105edb:	83 cf 40             	or     $0x40,%edi
80105ede:	89 fa                	mov    %edi,%edx
80105ee0:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80105ee6:	83 ce c0             	or     $0xffffffc0,%esi
80105ee9:	89 f2                	mov    %esi,%edx
80105eeb:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80105ef1:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105ef8:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
80105eff:	ff ff 
80105f01:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
80105f08:	00 00 
80105f0a:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
80105f11:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105f14:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80105f17:	c1 e1 04             	shl    $0x4,%ecx
80105f1a:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
80105f21:	83 e6 f0             	and    $0xfffffff0,%esi
80105f24:	89 f7                	mov    %esi,%edi
80105f26:	83 cf 02             	or     $0x2,%edi
80105f29:	89 fa                	mov    %edi,%edx
80105f2b:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80105f31:	89 f7                	mov    %esi,%edi
80105f33:	83 cf 12             	or     $0x12,%edi
80105f36:	89 fa                	mov    %edi,%edx
80105f38:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80105f3e:	83 ce 72             	or     $0x72,%esi
80105f41:	89 f2                	mov    %esi,%edx
80105f43:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
80105f49:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
80105f50:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
80105f57:	83 ce 0f             	or     $0xf,%esi
80105f5a:	89 f2                	mov    %esi,%edx
80105f5c:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80105f62:	89 f7                	mov    %esi,%edi
80105f64:	83 e7 ef             	and    $0xffffffef,%edi
80105f67:	89 fa                	mov    %edi,%edx
80105f69:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80105f6f:	83 e6 cf             	and    $0xffffffcf,%esi
80105f72:	89 f2                	mov    %esi,%edx
80105f74:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80105f7a:	89 f7                	mov    %esi,%edi
80105f7c:	83 cf 40             	or     $0x40,%edi
80105f7f:	89 fa                	mov    %edi,%edx
80105f81:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80105f87:	83 ce c0             	or     $0xffffffc0,%esi
80105f8a:	89 f2                	mov    %esi,%edx
80105f8c:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80105f92:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105f99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105f9c:	01 da                	add    %ebx,%edx
80105f9e:	c1 e2 04             	shl    $0x4,%edx
80105fa1:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
80105fa7:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80105fad:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
80105fb1:	c1 ea 10             	shr    $0x10,%edx
80105fb4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105fb8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105fbb:	0f 01 10             	lgdtl  (%eax)
}
80105fbe:	83 c4 2c             	add    $0x2c,%esp
80105fc1:	5b                   	pop    %ebx
80105fc2:	5e                   	pop    %esi
80105fc3:	5f                   	pop    %edi
80105fc4:	5d                   	pop    %ebp
80105fc5:	c3                   	ret    

80105fc6 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105fc6:	55                   	push   %ebp
80105fc7:	89 e5                	mov    %esp,%ebp
80105fc9:	57                   	push   %edi
80105fca:	56                   	push   %esi
80105fcb:	53                   	push   %ebx
80105fcc:	83 ec 0c             	sub    $0xc,%esp
80105fcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105fd2:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105fd5:	89 fb                	mov    %edi,%ebx
80105fd7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105fdd:	03 7d 10             	add    0x10(%ebp),%edi
80105fe0:	4f                   	dec    %edi
80105fe1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105fe7:	b9 01 00 00 00       	mov    $0x1,%ecx
80105fec:	89 da                	mov    %ebx,%edx
80105fee:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff1:	e8 8f fc ff ff       	call   80105c85 <walkpgdir>
80105ff6:	85 c0                	test   %eax,%eax
80105ff8:	74 2e                	je     80106028 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105ffa:	f6 00 01             	testb  $0x1,(%eax)
80105ffd:	75 1c                	jne    8010601b <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105fff:	89 f2                	mov    %esi,%edx
80106001:	0b 55 18             	or     0x18(%ebp),%edx
80106004:	83 ca 01             	or     $0x1,%edx
80106007:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106009:	39 fb                	cmp    %edi,%ebx
8010600b:	74 28                	je     80106035 <mappages+0x6f>
      break;
    a += PGSIZE;
8010600d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80106013:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106019:	eb cc                	jmp    80105fe7 <mappages+0x21>
      panic("remap");
8010601b:	83 ec 0c             	sub    $0xc,%esp
8010601e:	68 28 70 10 80       	push   $0x80107028
80106023:	e8 19 a3 ff ff       	call   80100341 <panic>
      return -1;
80106028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010602d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106030:	5b                   	pop    %ebx
80106031:	5e                   	pop    %esi
80106032:	5f                   	pop    %edi
80106033:	5d                   	pop    %ebp
80106034:	c3                   	ret    
  return 0;
80106035:	b8 00 00 00 00       	mov    $0x0,%eax
8010603a:	eb f1                	jmp    8010602d <mappages+0x67>

8010603c <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010603c:	a1 24 46 11 80       	mov    0x80114624,%eax
80106041:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106046:	0f 22 d8             	mov    %eax,%cr3
}
80106049:	c3                   	ret    

8010604a <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010604a:	55                   	push   %ebp
8010604b:	89 e5                	mov    %esp,%ebp
8010604d:	57                   	push   %edi
8010604e:	56                   	push   %esi
8010604f:	53                   	push   %ebx
80106050:	83 ec 1c             	sub    $0x1c,%esp
80106053:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106056:	85 f6                	test   %esi,%esi
80106058:	0f 84 21 01 00 00    	je     8010617f <switchuvm+0x135>
    panic("switchuvm: no process");
  if(p->kstack == 0)
8010605e:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106062:	0f 84 24 01 00 00    	je     8010618c <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106068:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
8010606c:	0f 84 27 01 00 00    	je     80106199 <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
80106072:	e8 8f d9 ff ff       	call   80103a06 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106077:	e8 0c d0 ff ff       	call   80103088 <mycpu>
8010607c:	89 c3                	mov    %eax,%ebx
8010607e:	e8 05 d0 ff ff       	call   80103088 <mycpu>
80106083:	8d 78 08             	lea    0x8(%eax),%edi
80106086:	e8 fd cf ff ff       	call   80103088 <mycpu>
8010608b:	83 c0 08             	add    $0x8,%eax
8010608e:	c1 e8 10             	shr    $0x10,%eax
80106091:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106094:	e8 ef cf ff ff       	call   80103088 <mycpu>
80106099:	83 c0 08             	add    $0x8,%eax
8010609c:	c1 e8 18             	shr    $0x18,%eax
8010609f:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801060a6:	67 00 
801060a8:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801060af:	8a 4d e4             	mov    -0x1c(%ebp),%cl
801060b2:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801060b8:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801060be:	83 e2 f0             	and    $0xfffffff0,%edx
801060c1:	88 d1                	mov    %dl,%cl
801060c3:	83 c9 09             	or     $0x9,%ecx
801060c6:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
801060cc:	83 ca 19             	or     $0x19,%edx
801060cf:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801060d5:	83 e2 9f             	and    $0xffffff9f,%edx
801060d8:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801060de:	83 ca 80             	or     $0xffffff80,%edx
801060e1:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801060e7:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
801060ed:	88 d1                	mov    %dl,%cl
801060ef:	83 e1 f0             	and    $0xfffffff0,%ecx
801060f2:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
801060f8:	88 d1                	mov    %dl,%cl
801060fa:	83 e1 e0             	and    $0xffffffe0,%ecx
801060fd:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106103:	83 e2 c0             	and    $0xffffffc0,%edx
80106106:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010610c:	83 ca 40             	or     $0x40,%edx
8010610f:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106115:	83 e2 7f             	and    $0x7f,%edx
80106118:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010611e:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106124:	e8 5f cf ff ff       	call   80103088 <mycpu>
80106129:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010612f:	83 e2 ef             	and    $0xffffffef,%edx
80106132:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106138:	e8 4b cf ff ff       	call   80103088 <mycpu>
8010613d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106143:	8b 5e 08             	mov    0x8(%esi),%ebx
80106146:	e8 3d cf ff ff       	call   80103088 <mycpu>
8010614b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106151:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106154:	e8 2f cf ff ff       	call   80103088 <mycpu>
80106159:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010615f:	b8 28 00 00 00       	mov    $0x28,%eax
80106164:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106167:	8b 46 04             	mov    0x4(%esi),%eax
8010616a:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010616f:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106172:	e8 ca d8 ff ff       	call   80103a41 <popcli>
}
80106177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010617a:	5b                   	pop    %ebx
8010617b:	5e                   	pop    %esi
8010617c:	5f                   	pop    %edi
8010617d:	5d                   	pop    %ebp
8010617e:	c3                   	ret    
    panic("switchuvm: no process");
8010617f:	83 ec 0c             	sub    $0xc,%esp
80106182:	68 2e 70 10 80       	push   $0x8010702e
80106187:	e8 b5 a1 ff ff       	call   80100341 <panic>
    panic("switchuvm: no kstack");
8010618c:	83 ec 0c             	sub    $0xc,%esp
8010618f:	68 44 70 10 80       	push   $0x80107044
80106194:	e8 a8 a1 ff ff       	call   80100341 <panic>
    panic("switchuvm: no pgdir");
80106199:	83 ec 0c             	sub    $0xc,%esp
8010619c:	68 59 70 10 80       	push   $0x80107059
801061a1:	e8 9b a1 ff ff       	call   80100341 <panic>

801061a6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801061a6:	55                   	push   %ebp
801061a7:	89 e5                	mov    %esp,%ebp
801061a9:	56                   	push   %esi
801061aa:	53                   	push   %ebx
801061ab:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801061ae:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801061b4:	77 4b                	ja     80106201 <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
801061b6:	e8 6c be ff ff       	call   80102027 <kalloc>
801061bb:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801061bd:	83 ec 04             	sub    $0x4,%esp
801061c0:	68 00 10 00 00       	push   $0x1000
801061c5:	6a 00                	push   $0x0
801061c7:	50                   	push   %eax
801061c8:	e8 bf d9 ff ff       	call   80103b8c <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801061cd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801061d4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801061da:	50                   	push   %eax
801061db:	68 00 10 00 00       	push   $0x1000
801061e0:	6a 00                	push   $0x0
801061e2:	ff 75 08             	push   0x8(%ebp)
801061e5:	e8 dc fd ff ff       	call   80105fc6 <mappages>
  memmove(mem, init, sz);
801061ea:	83 c4 1c             	add    $0x1c,%esp
801061ed:	56                   	push   %esi
801061ee:	ff 75 0c             	push   0xc(%ebp)
801061f1:	53                   	push   %ebx
801061f2:	e8 13 da ff ff       	call   80103c0a <memmove>
}
801061f7:	83 c4 10             	add    $0x10,%esp
801061fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061fd:	5b                   	pop    %ebx
801061fe:	5e                   	pop    %esi
801061ff:	5d                   	pop    %ebp
80106200:	c3                   	ret    
    panic("inituvm: more than a page");
80106201:	83 ec 0c             	sub    $0xc,%esp
80106204:	68 6d 70 10 80       	push   $0x8010706d
80106209:	e8 33 a1 ff ff       	call   80100341 <panic>

8010620e <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010620e:	55                   	push   %ebp
8010620f:	89 e5                	mov    %esp,%ebp
80106211:	57                   	push   %edi
80106212:	56                   	push   %esi
80106213:	53                   	push   %ebx
80106214:	83 ec 0c             	sub    $0xc,%esp
80106217:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010621a:	89 fb                	mov    %edi,%ebx
8010621c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106222:	74 3c                	je     80106260 <loaduvm+0x52>
    panic("loaduvm: addr must be page aligned");
80106224:	83 ec 0c             	sub    $0xc,%esp
80106227:	68 28 71 10 80       	push   $0x80107128
8010622c:	e8 10 a1 ff ff       	call   80100341 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106231:	83 ec 0c             	sub    $0xc,%esp
80106234:	68 87 70 10 80       	push   $0x80107087
80106239:	e8 03 a1 ff ff       	call   80100341 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010623e:	05 00 00 00 80       	add    $0x80000000,%eax
80106243:	56                   	push   %esi
80106244:	89 da                	mov    %ebx,%edx
80106246:	03 55 14             	add    0x14(%ebp),%edx
80106249:	52                   	push   %edx
8010624a:	50                   	push   %eax
8010624b:	ff 75 10             	push   0x10(%ebp)
8010624e:	e8 a0 b4 ff ff       	call   801016f3 <readi>
80106253:	83 c4 10             	add    $0x10,%esp
80106256:	39 f0                	cmp    %esi,%eax
80106258:	75 47                	jne    801062a1 <loaduvm+0x93>
  for(i = 0; i < sz; i += PGSIZE){
8010625a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106260:	3b 5d 18             	cmp    0x18(%ebp),%ebx
80106263:	73 2f                	jae    80106294 <loaduvm+0x86>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106265:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80106268:	b9 00 00 00 00       	mov    $0x0,%ecx
8010626d:	8b 45 08             	mov    0x8(%ebp),%eax
80106270:	e8 10 fa ff ff       	call   80105c85 <walkpgdir>
80106275:	85 c0                	test   %eax,%eax
80106277:	74 b8                	je     80106231 <loaduvm+0x23>
    pa = PTE_ADDR(*pte);
80106279:	8b 00                	mov    (%eax),%eax
8010627b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106280:	8b 75 18             	mov    0x18(%ebp),%esi
80106283:	29 de                	sub    %ebx,%esi
80106285:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010628b:	76 b1                	jbe    8010623e <loaduvm+0x30>
      n = PGSIZE;
8010628d:	be 00 10 00 00       	mov    $0x1000,%esi
80106292:	eb aa                	jmp    8010623e <loaduvm+0x30>
      return -1;
  }
  return 0;
80106294:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106299:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010629c:	5b                   	pop    %ebx
8010629d:	5e                   	pop    %esi
8010629e:	5f                   	pop    %edi
8010629f:	5d                   	pop    %ebp
801062a0:	c3                   	ret    
      return -1;
801062a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a6:	eb f1                	jmp    80106299 <loaduvm+0x8b>

801062a8 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801062a8:	55                   	push   %ebp
801062a9:	89 e5                	mov    %esp,%ebp
801062ab:	57                   	push   %edi
801062ac:	56                   	push   %esi
801062ad:	53                   	push   %ebx
801062ae:	83 ec 0c             	sub    $0xc,%esp
801062b1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801062b4:	39 7d 10             	cmp    %edi,0x10(%ebp)
801062b7:	73 11                	jae    801062ca <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
801062b9:	8b 45 10             	mov    0x10(%ebp),%eax
801062bc:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801062c2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801062c8:	eb 17                	jmp    801062e1 <deallocuvm+0x39>
    return oldsz;
801062ca:	89 f8                	mov    %edi,%eax
801062cc:	eb 62                	jmp    80106330 <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801062ce:	c1 eb 16             	shr    $0x16,%ebx
801062d1:	43                   	inc    %ebx
801062d2:	c1 e3 16             	shl    $0x16,%ebx
801062d5:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801062db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801062e1:	39 fb                	cmp    %edi,%ebx
801062e3:	73 48                	jae    8010632d <deallocuvm+0x85>
    pte = walkpgdir(pgdir, (char*)a, 0);
801062e5:	b9 00 00 00 00       	mov    $0x0,%ecx
801062ea:	89 da                	mov    %ebx,%edx
801062ec:	8b 45 08             	mov    0x8(%ebp),%eax
801062ef:	e8 91 f9 ff ff       	call   80105c85 <walkpgdir>
801062f4:	89 c6                	mov    %eax,%esi
    if(!pte)
801062f6:	85 c0                	test   %eax,%eax
801062f8:	74 d4                	je     801062ce <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
801062fa:	8b 00                	mov    (%eax),%eax
801062fc:	a8 01                	test   $0x1,%al
801062fe:	74 db                	je     801062db <deallocuvm+0x33>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106300:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106305:	74 19                	je     80106320 <deallocuvm+0x78>
        panic("kfree");
      char *v = P2V(pa);
80106307:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010630c:	83 ec 0c             	sub    $0xc,%esp
8010630f:	50                   	push   %eax
80106310:	e8 fb bb ff ff       	call   80101f10 <kfree>
      *pte = 0;
80106315:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010631b:	83 c4 10             	add    $0x10,%esp
8010631e:	eb bb                	jmp    801062db <deallocuvm+0x33>
        panic("kfree");
80106320:	83 ec 0c             	sub    $0xc,%esp
80106323:	68 66 69 10 80       	push   $0x80106966
80106328:	e8 14 a0 ff ff       	call   80100341 <panic>
    }
  }
  return newsz;
8010632d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106333:	5b                   	pop    %ebx
80106334:	5e                   	pop    %esi
80106335:	5f                   	pop    %edi
80106336:	5d                   	pop    %ebp
80106337:	c3                   	ret    

80106338 <allocuvm>:
{
80106338:	55                   	push   %ebp
80106339:	89 e5                	mov    %esp,%ebp
8010633b:	57                   	push   %edi
8010633c:	56                   	push   %esi
8010633d:	53                   	push   %ebx
8010633e:	83 ec 1c             	sub    $0x1c,%esp
80106341:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106344:	8b 45 10             	mov    0x10(%ebp),%eax
80106347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010634a:	85 c0                	test   %eax,%eax
8010634c:	0f 88 c1 00 00 00    	js     80106413 <allocuvm+0xdb>
  if(newsz < oldsz)
80106352:	8b 45 0c             	mov    0xc(%ebp),%eax
80106355:	39 45 10             	cmp    %eax,0x10(%ebp)
80106358:	72 5c                	jb     801063b6 <allocuvm+0x7e>
  a = PGROUNDUP(oldsz);
8010635a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010635d:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106363:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106369:	3b 75 10             	cmp    0x10(%ebp),%esi
8010636c:	0f 83 a8 00 00 00    	jae    8010641a <allocuvm+0xe2>
    mem = kalloc();
80106372:	e8 b0 bc ff ff       	call   80102027 <kalloc>
80106377:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106379:	85 c0                	test   %eax,%eax
8010637b:	74 3e                	je     801063bb <allocuvm+0x83>
    memset(mem, 0, PGSIZE);
8010637d:	83 ec 04             	sub    $0x4,%esp
80106380:	68 00 10 00 00       	push   $0x1000
80106385:	6a 00                	push   $0x0
80106387:	50                   	push   %eax
80106388:	e8 ff d7 ff ff       	call   80103b8c <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010638d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106394:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010639a:	50                   	push   %eax
8010639b:	68 00 10 00 00       	push   $0x1000
801063a0:	56                   	push   %esi
801063a1:	57                   	push   %edi
801063a2:	e8 1f fc ff ff       	call   80105fc6 <mappages>
801063a7:	83 c4 20             	add    $0x20,%esp
801063aa:	85 c0                	test   %eax,%eax
801063ac:	78 35                	js     801063e3 <allocuvm+0xab>
  for(; a < newsz; a += PGSIZE){
801063ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801063b4:	eb b3                	jmp    80106369 <allocuvm+0x31>
    return oldsz;
801063b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063b9:	eb 5f                	jmp    8010641a <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
801063bb:	83 ec 0c             	sub    $0xc,%esp
801063be:	68 a5 70 10 80       	push   $0x801070a5
801063c3:	e8 12 a2 ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801063c8:	83 c4 0c             	add    $0xc,%esp
801063cb:	ff 75 0c             	push   0xc(%ebp)
801063ce:	ff 75 10             	push   0x10(%ebp)
801063d1:	57                   	push   %edi
801063d2:	e8 d1 fe ff ff       	call   801062a8 <deallocuvm>
      return 0;
801063d7:	83 c4 10             	add    $0x10,%esp
801063da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801063e1:	eb 37                	jmp    8010641a <allocuvm+0xe2>
      cprintf("allocuvm out of memory (2)\n");
801063e3:	83 ec 0c             	sub    $0xc,%esp
801063e6:	68 bd 70 10 80       	push   $0x801070bd
801063eb:	e8 ea a1 ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801063f0:	83 c4 0c             	add    $0xc,%esp
801063f3:	ff 75 0c             	push   0xc(%ebp)
801063f6:	ff 75 10             	push   0x10(%ebp)
801063f9:	57                   	push   %edi
801063fa:	e8 a9 fe ff ff       	call   801062a8 <deallocuvm>
      kfree(mem);
801063ff:	89 1c 24             	mov    %ebx,(%esp)
80106402:	e8 09 bb ff ff       	call   80101f10 <kfree>
      return 0;
80106407:	83 c4 10             	add    $0x10,%esp
8010640a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106411:	eb 07                	jmp    8010641a <allocuvm+0xe2>
    return 0;
80106413:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010641a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010641d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106420:	5b                   	pop    %ebx
80106421:	5e                   	pop    %esi
80106422:	5f                   	pop    %edi
80106423:	5d                   	pop    %ebp
80106424:	c3                   	ret    

80106425 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
80106425:	55                   	push   %ebp
80106426:	89 e5                	mov    %esp,%ebp
80106428:	56                   	push   %esi
80106429:	53                   	push   %ebx
8010642a:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010642d:	85 f6                	test   %esi,%esi
8010642f:	74 0d                	je     8010643e <freevm+0x19>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
80106431:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106435:	75 14                	jne    8010644b <freevm+0x26>
{
80106437:	bb 00 00 00 00       	mov    $0x0,%ebx
8010643c:	eb 23                	jmp    80106461 <freevm+0x3c>
    panic("freevm: no pgdir");
8010643e:	83 ec 0c             	sub    $0xc,%esp
80106441:	68 d9 70 10 80       	push   $0x801070d9
80106446:	e8 f6 9e ff ff       	call   80100341 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
8010644b:	83 ec 04             	sub    $0x4,%esp
8010644e:	6a 00                	push   $0x0
80106450:	68 00 00 00 80       	push   $0x80000000
80106455:	56                   	push   %esi
80106456:	e8 4d fe ff ff       	call   801062a8 <deallocuvm>
8010645b:	83 c4 10             	add    $0x10,%esp
8010645e:	eb d7                	jmp    80106437 <freevm+0x12>
  for(i = 0; i < NPDENTRIES; i++){
80106460:	43                   	inc    %ebx
80106461:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
80106467:	77 1f                	ja     80106488 <freevm+0x63>
    if(pgdir[i] & PTE_P){
80106469:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
8010646c:	a8 01                	test   $0x1,%al
8010646e:	74 f0                	je     80106460 <freevm+0x3b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106470:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106475:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010647a:	83 ec 0c             	sub    $0xc,%esp
8010647d:	50                   	push   %eax
8010647e:	e8 8d ba ff ff       	call   80101f10 <kfree>
80106483:	83 c4 10             	add    $0x10,%esp
80106486:	eb d8                	jmp    80106460 <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
80106488:	83 ec 0c             	sub    $0xc,%esp
8010648b:	56                   	push   %esi
8010648c:	e8 7f ba ff ff       	call   80101f10 <kfree>
}
80106491:	83 c4 10             	add    $0x10,%esp
80106494:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106497:	5b                   	pop    %ebx
80106498:	5e                   	pop    %esi
80106499:	5d                   	pop    %ebp
8010649a:	c3                   	ret    

8010649b <setupkvm>:
{
8010649b:	55                   	push   %ebp
8010649c:	89 e5                	mov    %esp,%ebp
8010649e:	56                   	push   %esi
8010649f:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801064a0:	e8 82 bb ff ff       	call   80102027 <kalloc>
801064a5:	89 c6                	mov    %eax,%esi
801064a7:	85 c0                	test   %eax,%eax
801064a9:	74 57                	je     80106502 <setupkvm+0x67>
  memset(pgdir, 0, PGSIZE);
801064ab:	83 ec 04             	sub    $0x4,%esp
801064ae:	68 00 10 00 00       	push   $0x1000
801064b3:	6a 00                	push   $0x0
801064b5:	50                   	push   %eax
801064b6:	e8 d1 d6 ff ff       	call   80103b8c <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801064bb:	83 c4 10             	add    $0x10,%esp
801064be:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801064c3:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801064c9:	73 37                	jae    80106502 <setupkvm+0x67>
                (uint)k->phys_start, k->perm) < 0) {
801064cb:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801064ce:	83 ec 0c             	sub    $0xc,%esp
801064d1:	ff 73 0c             	push   0xc(%ebx)
801064d4:	52                   	push   %edx
801064d5:	8b 43 08             	mov    0x8(%ebx),%eax
801064d8:	29 d0                	sub    %edx,%eax
801064da:	50                   	push   %eax
801064db:	ff 33                	push   (%ebx)
801064dd:	56                   	push   %esi
801064de:	e8 e3 fa ff ff       	call   80105fc6 <mappages>
801064e3:	83 c4 20             	add    $0x20,%esp
801064e6:	85 c0                	test   %eax,%eax
801064e8:	78 05                	js     801064ef <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801064ea:	83 c3 10             	add    $0x10,%ebx
801064ed:	eb d4                	jmp    801064c3 <setupkvm+0x28>
      freevm(pgdir, 0);
801064ef:	83 ec 08             	sub    $0x8,%esp
801064f2:	6a 00                	push   $0x0
801064f4:	56                   	push   %esi
801064f5:	e8 2b ff ff ff       	call   80106425 <freevm>
      return 0;
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	be 00 00 00 00       	mov    $0x0,%esi
}
80106502:	89 f0                	mov    %esi,%eax
80106504:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106507:	5b                   	pop    %ebx
80106508:	5e                   	pop    %esi
80106509:	5d                   	pop    %ebp
8010650a:	c3                   	ret    

8010650b <kvmalloc>:
{
8010650b:	55                   	push   %ebp
8010650c:	89 e5                	mov    %esp,%ebp
8010650e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106511:	e8 85 ff ff ff       	call   8010649b <setupkvm>
80106516:	a3 24 46 11 80       	mov    %eax,0x80114624
  switchkvm();
8010651b:	e8 1c fb ff ff       	call   8010603c <switchkvm>
}
80106520:	c9                   	leave  
80106521:	c3                   	ret    

80106522 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106522:	55                   	push   %ebp
80106523:	89 e5                	mov    %esp,%ebp
80106525:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106528:	b9 00 00 00 00       	mov    $0x0,%ecx
8010652d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106530:	8b 45 08             	mov    0x8(%ebp),%eax
80106533:	e8 4d f7 ff ff       	call   80105c85 <walkpgdir>
  if(pte == 0)
80106538:	85 c0                	test   %eax,%eax
8010653a:	74 05                	je     80106541 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010653c:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010653f:	c9                   	leave  
80106540:	c3                   	ret    
    panic("clearpteu");
80106541:	83 ec 0c             	sub    $0xc,%esp
80106544:	68 ea 70 10 80       	push   $0x801070ea
80106549:	e8 f3 9d ff ff       	call   80100341 <panic>

8010654e <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010654e:	55                   	push   %ebp
8010654f:	89 e5                	mov    %esp,%ebp
80106551:	57                   	push   %edi
80106552:	56                   	push   %esi
80106553:	53                   	push   %ebx
80106554:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106557:	e8 3f ff ff ff       	call   8010649b <setupkvm>
8010655c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010655f:	85 c0                	test   %eax,%eax
80106561:	0f 84 c6 00 00 00    	je     8010662d <copyuvm+0xdf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106567:	bb 00 00 00 00       	mov    $0x0,%ebx
8010656c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
8010656f:	0f 83 b8 00 00 00    	jae    8010662d <copyuvm+0xdf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106575:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106578:	b9 00 00 00 00       	mov    $0x0,%ecx
8010657d:	89 da                	mov    %ebx,%edx
8010657f:	8b 45 08             	mov    0x8(%ebp),%eax
80106582:	e8 fe f6 ff ff       	call   80105c85 <walkpgdir>
80106587:	85 c0                	test   %eax,%eax
80106589:	74 65                	je     801065f0 <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
8010658b:	8b 00                	mov    (%eax),%eax
8010658d:	a8 01                	test   $0x1,%al
8010658f:	74 6c                	je     801065fd <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106591:	89 c6                	mov    %eax,%esi
80106593:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106599:	25 ff 0f 00 00       	and    $0xfff,%eax
8010659e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801065a1:	e8 81 ba ff ff       	call   80102027 <kalloc>
801065a6:	89 c7                	mov    %eax,%edi
801065a8:	85 c0                	test   %eax,%eax
801065aa:	74 6a                	je     80106616 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801065ac:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801065b2:	83 ec 04             	sub    $0x4,%esp
801065b5:	68 00 10 00 00       	push   $0x1000
801065ba:	56                   	push   %esi
801065bb:	50                   	push   %eax
801065bc:	e8 49 d6 ff ff       	call   80103c0a <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801065c1:	83 c4 04             	add    $0x4,%esp
801065c4:	ff 75 e0             	push   -0x20(%ebp)
801065c7:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801065cd:	50                   	push   %eax
801065ce:	68 00 10 00 00       	push   $0x1000
801065d3:	ff 75 e4             	push   -0x1c(%ebp)
801065d6:	ff 75 dc             	push   -0x24(%ebp)
801065d9:	e8 e8 f9 ff ff       	call   80105fc6 <mappages>
801065de:	83 c4 20             	add    $0x20,%esp
801065e1:	85 c0                	test   %eax,%eax
801065e3:	78 25                	js     8010660a <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
801065e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065eb:	e9 7c ff ff ff       	jmp    8010656c <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	68 f4 70 10 80       	push   $0x801070f4
801065f8:	e8 44 9d ff ff       	call   80100341 <panic>
      panic("copyuvm: page not present");
801065fd:	83 ec 0c             	sub    $0xc,%esp
80106600:	68 0e 71 10 80       	push   $0x8010710e
80106605:	e8 37 9d ff ff       	call   80100341 <panic>
      kfree(mem);
8010660a:	83 ec 0c             	sub    $0xc,%esp
8010660d:	57                   	push   %edi
8010660e:	e8 fd b8 ff ff       	call   80101f10 <kfree>
      goto bad;
80106613:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
80106616:	83 ec 08             	sub    $0x8,%esp
80106619:	6a 01                	push   $0x1
8010661b:	ff 75 dc             	push   -0x24(%ebp)
8010661e:	e8 02 fe ff ff       	call   80106425 <freevm>
  return 0;
80106623:	83 c4 10             	add    $0x10,%esp
80106626:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
8010662d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106630:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106633:	5b                   	pop    %ebx
80106634:	5e                   	pop    %esi
80106635:	5f                   	pop    %edi
80106636:	5d                   	pop    %ebp
80106637:	c3                   	ret    

80106638 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106638:	55                   	push   %ebp
80106639:	89 e5                	mov    %esp,%ebp
8010663b:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010663e:	b9 00 00 00 00       	mov    $0x0,%ecx
80106643:	8b 55 0c             	mov    0xc(%ebp),%edx
80106646:	8b 45 08             	mov    0x8(%ebp),%eax
80106649:	e8 37 f6 ff ff       	call   80105c85 <walkpgdir>
  if((*pte & PTE_P) == 0)
8010664e:	8b 00                	mov    (%eax),%eax
80106650:	a8 01                	test   $0x1,%al
80106652:	74 10                	je     80106664 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106654:	a8 04                	test   $0x4,%al
80106656:	74 13                	je     8010666b <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106658:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010665d:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106662:	c9                   	leave  
80106663:	c3                   	ret    
    return 0;
80106664:	b8 00 00 00 00       	mov    $0x0,%eax
80106669:	eb f7                	jmp    80106662 <uva2ka+0x2a>
    return 0;
8010666b:	b8 00 00 00 00       	mov    $0x0,%eax
80106670:	eb f0                	jmp    80106662 <uva2ka+0x2a>

80106672 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106672:	55                   	push   %ebp
80106673:	89 e5                	mov    %esp,%ebp
80106675:	57                   	push   %edi
80106676:	56                   	push   %esi
80106677:	53                   	push   %ebx
80106678:	83 ec 0c             	sub    $0xc,%esp
8010667b:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010667e:	eb 25                	jmp    801066a5 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106680:	8b 55 0c             	mov    0xc(%ebp),%edx
80106683:	29 f2                	sub    %esi,%edx
80106685:	01 d0                	add    %edx,%eax
80106687:	83 ec 04             	sub    $0x4,%esp
8010668a:	53                   	push   %ebx
8010668b:	ff 75 10             	push   0x10(%ebp)
8010668e:	50                   	push   %eax
8010668f:	e8 76 d5 ff ff       	call   80103c0a <memmove>
    len -= n;
80106694:	29 df                	sub    %ebx,%edi
    buf += n;
80106696:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106699:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
8010669f:	89 45 0c             	mov    %eax,0xc(%ebp)
801066a2:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801066a5:	85 ff                	test   %edi,%edi
801066a7:	74 2f                	je     801066d8 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
801066a9:	8b 75 0c             	mov    0xc(%ebp),%esi
801066ac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801066b2:	83 ec 08             	sub    $0x8,%esp
801066b5:	56                   	push   %esi
801066b6:	ff 75 08             	push   0x8(%ebp)
801066b9:	e8 7a ff ff ff       	call   80106638 <uva2ka>
    if(pa0 == 0)
801066be:	83 c4 10             	add    $0x10,%esp
801066c1:	85 c0                	test   %eax,%eax
801066c3:	74 20                	je     801066e5 <copyout+0x73>
    n = PGSIZE - (va - va0);
801066c5:	89 f3                	mov    %esi,%ebx
801066c7:	2b 5d 0c             	sub    0xc(%ebp),%ebx
801066ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801066d0:	39 df                	cmp    %ebx,%edi
801066d2:	73 ac                	jae    80106680 <copyout+0xe>
      n = len;
801066d4:	89 fb                	mov    %edi,%ebx
801066d6:	eb a8                	jmp    80106680 <copyout+0xe>
  }
  return 0;
801066d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066e0:	5b                   	pop    %ebx
801066e1:	5e                   	pop    %esi
801066e2:	5f                   	pop    %edi
801066e3:	5d                   	pop    %ebp
801066e4:	c3                   	ret    
      return -1;
801066e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ea:	eb f1                	jmp    801066dd <copyout+0x6b>
