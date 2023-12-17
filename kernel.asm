
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a9 2a 10 80       	mov    $0x80102aa9,%eax
  jmp *%eax
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
80100041:	68 c0 b5 10 80       	push   $0x8010b5c0
80100046:	e8 2c 3e 00 00       	call   80103e77 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100075:	68 c0 b5 10 80       	push   $0x8010b5c0
8010007a:	e8 61 3e 00 00       	call   80103ee0 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 be 3b 00 00       	call   80103c48 <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
801000c3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c8:	e8 13 3e 00 00       	call   80103ee0 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 70 3b 00 00       	call   80103c48 <acquiresleep>
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
801000e8:	68 a0 6a 10 80       	push   $0x80106aa0
801000ed:	e8 63 02 00 00       	call   80100355 <panic>

801000f2 <binit>:
{
801000f2:	f3 0f 1e fb          	endbr32 
801000f6:	55                   	push   %ebp
801000f7:	89 e5                	mov    %esp,%ebp
801000f9:	53                   	push   %ebx
801000fa:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fd:	68 b1 6a 10 80       	push   $0x80106ab1
80100102:	68 c0 b5 10 80       	push   $0x8010b5c0
80100107:	e8 20 3c 00 00       	call   80103d2c <initlock>
  bcache.head.prev = &bcache.head;
8010010c:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100113:	fc 10 80 
  bcache.head.next = &bcache.head;
80100116:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010011d:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100128:	eb 37                	jmp    80100161 <binit+0x6f>
    b->next = bcache.head.next;
8010012a:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010012f:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100132:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100139:	83 ec 08             	sub    $0x8,%esp
8010013c:	68 b8 6a 10 80       	push   $0x80106ab8
80100141:	8d 43 0c             	lea    0xc(%ebx),%eax
80100144:	50                   	push   %eax
80100145:	e8 c7 3a 00 00       	call   80103c11 <initsleeplock>
    bcache.head.next->prev = b;
8010014a:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010014f:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100152:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100158:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015e:	83 c4 10             	add    $0x10,%esp
80100161:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100167:	72 c1                	jb     8010012a <binit+0x38>
}
80100169:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016c:	c9                   	leave  
8010016d:	c3                   	ret    

8010016e <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016e:	f3 0f 1e fb          	endbr32 
80100172:	55                   	push   %ebp
80100173:	89 e5                	mov    %esp,%ebp
80100175:	53                   	push   %ebx
80100176:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017c:	8b 45 08             	mov    0x8(%ebp),%eax
8010017f:	e8 b0 fe ff ff       	call   80100034 <bget>
80100184:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100186:	f6 00 02             	testb  $0x2,(%eax)
80100189:	74 07                	je     80100192 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018b:	89 d8                	mov    %ebx,%eax
8010018d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100190:	c9                   	leave  
80100191:	c3                   	ret    
    iderw(b);
80100192:	83 ec 0c             	sub    $0xc,%esp
80100195:	50                   	push   %eax
80100196:	e8 aa 1c 00 00       	call   80101e45 <iderw>
8010019b:	83 c4 10             	add    $0x10,%esp
  return b;
8010019e:	eb eb                	jmp    8010018b <bread+0x1d>

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	f3 0f 1e fb          	endbr32 
801001a4:	55                   	push   %ebp
801001a5:	89 e5                	mov    %esp,%ebp
801001a7:	53                   	push   %ebx
801001a8:	83 ec 10             	sub    $0x10,%esp
801001ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b1:	50                   	push   %eax
801001b2:	e8 23 3b 00 00       	call   80103cda <holdingsleep>
801001b7:	83 c4 10             	add    $0x10,%esp
801001ba:	85 c0                	test   %eax,%eax
801001bc:	74 14                	je     801001d2 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001be:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c1:	83 ec 0c             	sub    $0xc,%esp
801001c4:	53                   	push   %ebx
801001c5:	e8 7b 1c 00 00       	call   80101e45 <iderw>
}
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d0:	c9                   	leave  
801001d1:	c3                   	ret    
    panic("bwrite");
801001d2:	83 ec 0c             	sub    $0xc,%esp
801001d5:	68 bf 6a 10 80       	push   $0x80106abf
801001da:	e8 76 01 00 00       	call   80100355 <panic>

801001df <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001df:	f3 0f 1e fb          	endbr32 
801001e3:	55                   	push   %ebp
801001e4:	89 e5                	mov    %esp,%ebp
801001e6:	56                   	push   %esi
801001e7:	53                   	push   %ebx
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 e3 3a 00 00       	call   80103cda <holdingsleep>
801001f7:	83 c4 10             	add    $0x10,%esp
801001fa:	85 c0                	test   %eax,%eax
801001fc:	74 69                	je     80100267 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
801001fe:	83 ec 0c             	sub    $0xc,%esp
80100201:	56                   	push   %esi
80100202:	e8 94 3a 00 00       	call   80103c9b <releasesleep>

  acquire(&bcache.lock);
80100207:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020e:	e8 64 3c 00 00       	call   80103e77 <acquire>
  b->refcnt--;
80100213:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100216:	48                   	dec    %eax
80100217:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021a:	83 c4 10             	add    $0x10,%esp
8010021d:	85 c0                	test   %eax,%eax
8010021f:	75 2f                	jne    80100250 <brelse+0x71>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100221:	8b 43 54             	mov    0x54(%ebx),%eax
80100224:	8b 53 50             	mov    0x50(%ebx),%edx
80100227:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022a:	8b 43 50             	mov    0x50(%ebx),%eax
8010022d:	8b 53 54             	mov    0x54(%ebx),%edx
80100230:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100233:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100238:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100247:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024a:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	68 c0 b5 10 80       	push   $0x8010b5c0
80100258:	e8 83 3c 00 00       	call   80103ee0 <release>
}
8010025d:	83 c4 10             	add    $0x10,%esp
80100260:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100263:	5b                   	pop    %ebx
80100264:	5e                   	pop    %esi
80100265:	5d                   	pop    %ebp
80100266:	c3                   	ret    
    panic("brelse");
80100267:	83 ec 0c             	sub    $0xc,%esp
8010026a:	68 c6 6a 10 80       	push   $0x80106ac6
8010026f:	e8 e1 00 00 00       	call   80100355 <panic>

80100274 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100274:	f3 0f 1e fb          	endbr32 
80100278:	55                   	push   %ebp
80100279:	89 e5                	mov    %esp,%ebp
8010027b:	57                   	push   %edi
8010027c:	56                   	push   %esi
8010027d:	53                   	push   %ebx
8010027e:	83 ec 28             	sub    $0x28,%esp
80100281:	8b 7d 08             	mov    0x8(%ebp),%edi
80100284:	8b 75 0c             	mov    0xc(%ebp),%esi
80100287:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028a:	57                   	push   %edi
8010028b:	e8 ca 13 00 00       	call   8010165a <iunlock>
  target = n;
80100290:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100293:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029a:	e8 d8 3b 00 00       	call   80103e77 <acquire>
  while(n > 0){
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	85 db                	test   %ebx,%ebx
801002a4:	0f 8e 8c 00 00 00    	jle    80100336 <consoleread+0xc2>
    while(input.r == input.w){
801002aa:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002af:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b5:	75 47                	jne    801002fe <consoleread+0x8a>
      if(myproc()->killed){
801002b7:	e8 8f 2f 00 00       	call   8010324b <myproc>
801002bc:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c0:	75 17                	jne    801002d9 <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c2:	83 ec 08             	sub    $0x8,%esp
801002c5:	68 20 a5 10 80       	push   $0x8010a520
801002ca:	68 a0 ff 10 80       	push   $0x8010ffa0
801002cf:	e8 46 36 00 00       	call   8010391a <sleep>
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	eb d1                	jmp    801002aa <consoleread+0x36>
        release(&cons.lock);
801002d9:	83 ec 0c             	sub    $0xc,%esp
801002dc:	68 20 a5 10 80       	push   $0x8010a520
801002e1:	e8 fa 3b 00 00       	call   80103ee0 <release>
        ilock(ip);
801002e6:	89 3c 24             	mov    %edi,(%esp)
801002e9:	e8 a8 12 00 00       	call   80101596 <ilock>
        return -1;
801002ee:	83 c4 10             	add    $0x10,%esp
801002f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002f9:	5b                   	pop    %ebx
801002fa:	5e                   	pop    %esi
801002fb:	5f                   	pop    %edi
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002fe:	8d 50 01             	lea    0x1(%eax),%edx
80100301:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100307:	89 c2                	mov    %eax,%edx
80100309:	83 e2 7f             	and    $0x7f,%edx
8010030c:	8a 92 20 ff 10 80    	mov    -0x7fef00e0(%edx),%dl
80100312:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100315:	80 fa 04             	cmp    $0x4,%dl
80100318:	74 12                	je     8010032c <consoleread+0xb8>
    *dst++ = c;
8010031a:	8d 46 01             	lea    0x1(%esi),%eax
8010031d:	88 16                	mov    %dl,(%esi)
    --n;
8010031f:	4b                   	dec    %ebx
    if(c == '\n')
80100320:	83 f9 0a             	cmp    $0xa,%ecx
80100323:	74 11                	je     80100336 <consoleread+0xc2>
    *dst++ = c;
80100325:	89 c6                	mov    %eax,%esi
80100327:	e9 76 ff ff ff       	jmp    801002a2 <consoleread+0x2e>
      if(n < target){
8010032c:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010032f:	73 05                	jae    80100336 <consoleread+0xc2>
        input.r--;
80100331:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
  release(&cons.lock);
80100336:	83 ec 0c             	sub    $0xc,%esp
80100339:	68 20 a5 10 80       	push   $0x8010a520
8010033e:	e8 9d 3b 00 00       	call   80103ee0 <release>
  ilock(ip);
80100343:	89 3c 24             	mov    %edi,(%esp)
80100346:	e8 4b 12 00 00       	call   80101596 <ilock>
  return target - n;
8010034b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010034e:	29 d8                	sub    %ebx,%eax
80100350:	83 c4 10             	add    $0x10,%esp
80100353:	eb a1                	jmp    801002f6 <consoleread+0x82>

80100355 <panic>:
{
80100355:	f3 0f 1e fb          	endbr32 
80100359:	55                   	push   %ebp
8010035a:	89 e5                	mov    %esp,%ebp
8010035c:	53                   	push   %ebx
8010035d:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100360:	fa                   	cli    
  cons.locking = 0;
80100361:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100368:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010036b:	e8 62 20 00 00       	call   801023d2 <lapicid>
80100370:	83 ec 08             	sub    $0x8,%esp
80100373:	50                   	push   %eax
80100374:	68 cd 6a 10 80       	push   $0x80106acd
80100379:	e8 7f 02 00 00       	call   801005fd <cprintf>
  cprintf(s);
8010037e:	83 c4 04             	add    $0x4,%esp
80100381:	ff 75 08             	pushl  0x8(%ebp)
80100384:	e8 74 02 00 00       	call   801005fd <cprintf>
  cprintf("\n");
80100389:	c7 04 24 eb 74 10 80 	movl   $0x801074eb,(%esp)
80100390:	e8 68 02 00 00       	call   801005fd <cprintf>
  getcallerpcs(&s, pcs);
80100395:	83 c4 08             	add    $0x8,%esp
80100398:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010039b:	50                   	push   %eax
8010039c:	8d 45 08             	lea    0x8(%ebp),%eax
8010039f:	50                   	push   %eax
801003a0:	e8 a6 39 00 00       	call   80103d4b <getcallerpcs>
  for(i=0; i<10; i++)
801003a5:	83 c4 10             	add    $0x10,%esp
801003a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801003ad:	eb 15                	jmp    801003c4 <panic+0x6f>
    cprintf(" %p", pcs[i]);
801003af:	83 ec 08             	sub    $0x8,%esp
801003b2:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003b6:	68 e1 6a 10 80       	push   $0x80106ae1
801003bb:	e8 3d 02 00 00       	call   801005fd <cprintf>
  for(i=0; i<10; i++)
801003c0:	43                   	inc    %ebx
801003c1:	83 c4 10             	add    $0x10,%esp
801003c4:	83 fb 09             	cmp    $0x9,%ebx
801003c7:	7e e6                	jle    801003af <panic+0x5a>
  panicked = 1; // freeze other CPU
801003c9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d0:	00 00 00 
  for(;;)
801003d3:	eb fe                	jmp    801003d3 <panic+0x7e>

801003d5 <cgaputc>:
{
801003d5:	55                   	push   %ebp
801003d6:	89 e5                	mov    %esp,%ebp
801003d8:	57                   	push   %edi
801003d9:	56                   	push   %esi
801003da:	53                   	push   %ebx
801003db:	83 ec 0c             	sub    $0xc,%esp
801003de:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e0:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003e5:	b0 0e                	mov    $0xe,%al
801003e7:	89 fa                	mov    %edi,%edx
801003e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003ea:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003ef:	89 da                	mov    %ebx,%edx
801003f1:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003f2:	0f b6 c8             	movzbl %al,%ecx
801003f5:	c1 e1 08             	shl    $0x8,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003f8:	b0 0f                	mov    $0xf,%al
801003fa:	89 fa                	mov    %edi,%edx
801003fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003fd:	89 da                	mov    %ebx,%edx
801003ff:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100400:	0f b6 c0             	movzbl %al,%eax
80100403:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100405:	83 fe 0a             	cmp    $0xa,%esi
80100408:	74 61                	je     8010046b <cgaputc+0x96>
  else if(c == BACKSPACE){
8010040a:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100410:	74 69                	je     8010047b <cgaputc+0xa6>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100412:	89 f0                	mov    %esi,%eax
80100414:	0f b6 f0             	movzbl %al,%esi
80100417:	8d 59 01             	lea    0x1(%ecx),%ebx
8010041a:	81 ce 00 07 00 00    	or     $0x700,%esi
80100420:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100427:	80 
  if(pos < 0 || pos > 25*80)
80100428:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010042e:	77 58                	ja     80100488 <cgaputc+0xb3>
  if((pos/80) >= 24){  // Scroll up.
80100430:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100436:	7f 5d                	jg     80100495 <cgaputc+0xc0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100438:	be d4 03 00 00       	mov    $0x3d4,%esi
8010043d:	b0 0e                	mov    $0xe,%al
8010043f:	89 f2                	mov    %esi,%edx
80100441:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100442:	89 d8                	mov    %ebx,%eax
80100444:	c1 f8 08             	sar    $0x8,%eax
80100447:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010044c:	89 ca                	mov    %ecx,%edx
8010044e:	ee                   	out    %al,(%dx)
8010044f:	b0 0f                	mov    $0xf,%al
80100451:	89 f2                	mov    %esi,%edx
80100453:	ee                   	out    %al,(%dx)
80100454:	88 d8                	mov    %bl,%al
80100456:	89 ca                	mov    %ecx,%edx
80100458:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100459:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100460:	80 20 07 
}
80100463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100466:	5b                   	pop    %ebx
80100467:	5e                   	pop    %esi
80100468:	5f                   	pop    %edi
80100469:	5d                   	pop    %ebp
8010046a:	c3                   	ret    
    pos += 80 - pos%80;
8010046b:	bb 50 00 00 00       	mov    $0x50,%ebx
80100470:	89 c8                	mov    %ecx,%eax
80100472:	99                   	cltd   
80100473:	f7 fb                	idiv   %ebx
80100475:	29 d3                	sub    %edx,%ebx
80100477:	01 cb                	add    %ecx,%ebx
80100479:	eb ad                	jmp    80100428 <cgaputc+0x53>
    if(pos > 0) --pos;
8010047b:	85 c9                	test   %ecx,%ecx
8010047d:	7e 05                	jle    80100484 <cgaputc+0xaf>
8010047f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100482:	eb a4                	jmp    80100428 <cgaputc+0x53>
  pos |= inb(CRTPORT+1);
80100484:	89 cb                	mov    %ecx,%ebx
80100486:	eb a0                	jmp    80100428 <cgaputc+0x53>
    panic("pos under/overflow");
80100488:	83 ec 0c             	sub    $0xc,%esp
8010048b:	68 e5 6a 10 80       	push   $0x80106ae5
80100490:	e8 c0 fe ff ff       	call   80100355 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100495:	83 ec 04             	sub    $0x4,%esp
80100498:	68 60 0e 00 00       	push   $0xe60
8010049d:	68 a0 80 0b 80       	push   $0x800b80a0
801004a2:	68 00 80 0b 80       	push   $0x800b8000
801004a7:	e8 fd 3a 00 00       	call   80103fa9 <memmove>
    pos -= 80;
801004ac:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004af:	b8 80 07 00 00       	mov    $0x780,%eax
801004b4:	29 d8                	sub    %ebx,%eax
801004b6:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004bd:	83 c4 0c             	add    $0xc,%esp
801004c0:	01 c0                	add    %eax,%eax
801004c2:	50                   	push   %eax
801004c3:	6a 00                	push   $0x0
801004c5:	52                   	push   %edx
801004c6:	e8 60 3a 00 00       	call   80103f2b <memset>
801004cb:	83 c4 10             	add    $0x10,%esp
801004ce:	e9 65 ff ff ff       	jmp    80100438 <cgaputc+0x63>

801004d3 <consputc>:
  if(panicked){
801004d3:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004da:	74 03                	je     801004df <consputc+0xc>
  asm volatile("cli");
801004dc:	fa                   	cli    
    for(;;)
801004dd:	eb fe                	jmp    801004dd <consputc+0xa>
{
801004df:	55                   	push   %ebp
801004e0:	89 e5                	mov    %esp,%ebp
801004e2:	53                   	push   %ebx
801004e3:	83 ec 04             	sub    $0x4,%esp
801004e6:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801004ed:	74 18                	je     80100507 <consputc+0x34>
    uartputc(c);
801004ef:	83 ec 0c             	sub    $0xc,%esp
801004f2:	50                   	push   %eax
801004f3:	e8 4a 51 00 00       	call   80105642 <uartputc>
801004f8:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004fb:	89 d8                	mov    %ebx,%eax
801004fd:	e8 d3 fe ff ff       	call   801003d5 <cgaputc>
}
80100502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100505:	c9                   	leave  
80100506:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100507:	83 ec 0c             	sub    $0xc,%esp
8010050a:	6a 08                	push   $0x8
8010050c:	e8 31 51 00 00       	call   80105642 <uartputc>
80100511:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100518:	e8 25 51 00 00       	call   80105642 <uartputc>
8010051d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100524:	e8 19 51 00 00       	call   80105642 <uartputc>
80100529:	83 c4 10             	add    $0x10,%esp
8010052c:	eb cd                	jmp    801004fb <consputc+0x28>

8010052e <printint>:
{
8010052e:	55                   	push   %ebp
8010052f:	89 e5                	mov    %esp,%ebp
80100531:	57                   	push   %edi
80100532:	56                   	push   %esi
80100533:	53                   	push   %ebx
80100534:	83 ec 2c             	sub    $0x2c,%esp
80100537:	89 d6                	mov    %edx,%esi
80100539:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010053c:	85 c9                	test   %ecx,%ecx
8010053e:	74 0c                	je     8010054c <printint+0x1e>
80100540:	89 c7                	mov    %eax,%edi
80100542:	c1 ef 1f             	shr    $0x1f,%edi
80100545:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100548:	85 c0                	test   %eax,%eax
8010054a:	78 35                	js     80100581 <printint+0x53>
    x = xx;
8010054c:	89 c1                	mov    %eax,%ecx
  i = 0;
8010054e:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100553:	89 c8                	mov    %ecx,%eax
80100555:	ba 00 00 00 00       	mov    $0x0,%edx
8010055a:	f7 f6                	div    %esi
8010055c:	89 df                	mov    %ebx,%edi
8010055e:	43                   	inc    %ebx
8010055f:	8a 92 10 6b 10 80    	mov    -0x7fef94f0(%edx),%dl
80100565:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100569:	89 ca                	mov    %ecx,%edx
8010056b:	89 c1                	mov    %eax,%ecx
8010056d:	39 d6                	cmp    %edx,%esi
8010056f:	76 e2                	jbe    80100553 <printint+0x25>
  if(sign)
80100571:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100575:	74 1a                	je     80100591 <printint+0x63>
    buf[i++] = '-';
80100577:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010057c:	8d 5f 02             	lea    0x2(%edi),%ebx
8010057f:	eb 10                	jmp    80100591 <printint+0x63>
    x = -xx;
80100581:	f7 d8                	neg    %eax
80100583:	89 c1                	mov    %eax,%ecx
80100585:	eb c7                	jmp    8010054e <printint+0x20>
    consputc(buf[i]);
80100587:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010058c:	e8 42 ff ff ff       	call   801004d3 <consputc>
  while(--i >= 0)
80100591:	4b                   	dec    %ebx
80100592:	79 f3                	jns    80100587 <printint+0x59>
}
80100594:	83 c4 2c             	add    $0x2c,%esp
80100597:	5b                   	pop    %ebx
80100598:	5e                   	pop    %esi
80100599:	5f                   	pop    %edi
8010059a:	5d                   	pop    %ebp
8010059b:	c3                   	ret    

8010059c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010059c:	f3 0f 1e fb          	endbr32 
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 18             	sub    $0x18,%esp
801005a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005ac:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 a3 10 00 00       	call   8010165a <iunlock>
  acquire(&cons.lock);
801005b7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005be:	e8 b4 38 00 00       	call   80103e77 <acquire>
  for(i = 0; i < n; i++)
801005c3:	83 c4 10             	add    $0x10,%esp
801005c6:	bb 00 00 00 00       	mov    $0x0,%ebx
801005cb:	39 f3                	cmp    %esi,%ebx
801005cd:	7d 0c                	jge    801005db <consolewrite+0x3f>
    consputc(buf[i] & 0xff);
801005cf:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005d3:	e8 fb fe ff ff       	call   801004d3 <consputc>
  for(i = 0; i < n; i++)
801005d8:	43                   	inc    %ebx
801005d9:	eb f0                	jmp    801005cb <consolewrite+0x2f>
  release(&cons.lock);
801005db:	83 ec 0c             	sub    $0xc,%esp
801005de:	68 20 a5 10 80       	push   $0x8010a520
801005e3:	e8 f8 38 00 00       	call   80103ee0 <release>
  ilock(ip);
801005e8:	83 c4 04             	add    $0x4,%esp
801005eb:	ff 75 08             	pushl  0x8(%ebp)
801005ee:	e8 a3 0f 00 00       	call   80101596 <ilock>

  return n;
}
801005f3:	89 f0                	mov    %esi,%eax
801005f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f8:	5b                   	pop    %ebx
801005f9:	5e                   	pop    %esi
801005fa:	5f                   	pop    %edi
801005fb:	5d                   	pop    %ebp
801005fc:	c3                   	ret    

801005fd <cprintf>:
{
801005fd:	f3 0f 1e fb          	endbr32 
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	57                   	push   %edi
80100605:	56                   	push   %esi
80100606:	53                   	push   %ebx
80100607:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010060a:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010060f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100612:	85 c0                	test   %eax,%eax
80100614:	75 10                	jne    80100626 <cprintf+0x29>
  if (fmt == 0)
80100616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010061a:	74 1c                	je     80100638 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
8010061c:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010061f:	be 00 00 00 00       	mov    $0x0,%esi
80100624:	eb 25                	jmp    8010064b <cprintf+0x4e>
    acquire(&cons.lock);
80100626:	83 ec 0c             	sub    $0xc,%esp
80100629:	68 20 a5 10 80       	push   $0x8010a520
8010062e:	e8 44 38 00 00       	call   80103e77 <acquire>
80100633:	83 c4 10             	add    $0x10,%esp
80100636:	eb de                	jmp    80100616 <cprintf+0x19>
    panic("null fmt");
80100638:	83 ec 0c             	sub    $0xc,%esp
8010063b:	68 ff 6a 10 80       	push   $0x80106aff
80100640:	e8 10 fd ff ff       	call   80100355 <panic>
      consputc(c);
80100645:	e8 89 fe ff ff       	call   801004d3 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064a:	46                   	inc    %esi
8010064b:	8b 55 08             	mov    0x8(%ebp),%edx
8010064e:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100652:	85 c0                	test   %eax,%eax
80100654:	0f 84 ac 00 00 00    	je     80100706 <cprintf+0x109>
    if(c != '%'){
8010065a:	83 f8 25             	cmp    $0x25,%eax
8010065d:	75 e6                	jne    80100645 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010065f:	46                   	inc    %esi
80100660:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100664:	85 db                	test   %ebx,%ebx
80100666:	0f 84 9a 00 00 00    	je     80100706 <cprintf+0x109>
    switch(c){
8010066c:	83 fb 70             	cmp    $0x70,%ebx
8010066f:	74 2e                	je     8010069f <cprintf+0xa2>
80100671:	7f 22                	jg     80100695 <cprintf+0x98>
80100673:	83 fb 25             	cmp    $0x25,%ebx
80100676:	74 69                	je     801006e1 <cprintf+0xe4>
80100678:	83 fb 64             	cmp    $0x64,%ebx
8010067b:	75 73                	jne    801006f0 <cprintf+0xf3>
      printint(*argp++, 10, 1);
8010067d:	8d 5f 04             	lea    0x4(%edi),%ebx
80100680:	8b 07                	mov    (%edi),%eax
80100682:	b9 01 00 00 00       	mov    $0x1,%ecx
80100687:	ba 0a 00 00 00       	mov    $0xa,%edx
8010068c:	e8 9d fe ff ff       	call   8010052e <printint>
80100691:	89 df                	mov    %ebx,%edi
      break;
80100693:	eb b5                	jmp    8010064a <cprintf+0x4d>
    switch(c){
80100695:	83 fb 73             	cmp    $0x73,%ebx
80100698:	74 1d                	je     801006b7 <cprintf+0xba>
8010069a:	83 fb 78             	cmp    $0x78,%ebx
8010069d:	75 51                	jne    801006f0 <cprintf+0xf3>
      printint(*argp++, 16, 0);
8010069f:	8d 5f 04             	lea    0x4(%edi),%ebx
801006a2:	8b 07                	mov    (%edi),%eax
801006a4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006a9:	ba 10 00 00 00       	mov    $0x10,%edx
801006ae:	e8 7b fe ff ff       	call   8010052e <printint>
801006b3:	89 df                	mov    %ebx,%edi
      break;
801006b5:	eb 93                	jmp    8010064a <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006b7:	8d 47 04             	lea    0x4(%edi),%eax
801006ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006bd:	8b 1f                	mov    (%edi),%ebx
801006bf:	85 db                	test   %ebx,%ebx
801006c1:	75 05                	jne    801006c8 <cprintf+0xcb>
        s = "(null)";
801006c3:	bb f8 6a 10 80       	mov    $0x80106af8,%ebx
      for(; *s; s++)
801006c8:	8a 03                	mov    (%ebx),%al
801006ca:	84 c0                	test   %al,%al
801006cc:	74 0b                	je     801006d9 <cprintf+0xdc>
        consputc(*s);
801006ce:	0f be c0             	movsbl %al,%eax
801006d1:	e8 fd fd ff ff       	call   801004d3 <consputc>
      for(; *s; s++)
801006d6:	43                   	inc    %ebx
801006d7:	eb ef                	jmp    801006c8 <cprintf+0xcb>
      if((s = (char*)*argp++) == 0)
801006d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006dc:	e9 69 ff ff ff       	jmp    8010064a <cprintf+0x4d>
      consputc('%');
801006e1:	b8 25 00 00 00       	mov    $0x25,%eax
801006e6:	e8 e8 fd ff ff       	call   801004d3 <consputc>
      break;
801006eb:	e9 5a ff ff ff       	jmp    8010064a <cprintf+0x4d>
      consputc('%');
801006f0:	b8 25 00 00 00       	mov    $0x25,%eax
801006f5:	e8 d9 fd ff ff       	call   801004d3 <consputc>
      consputc(c);
801006fa:	89 d8                	mov    %ebx,%eax
801006fc:	e8 d2 fd ff ff       	call   801004d3 <consputc>
      break;
80100701:	e9 44 ff ff ff       	jmp    8010064a <cprintf+0x4d>
  if(locking)
80100706:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010070a:	75 08                	jne    80100714 <cprintf+0x117>
}
8010070c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070f:	5b                   	pop    %ebx
80100710:	5e                   	pop    %esi
80100711:	5f                   	pop    %edi
80100712:	5d                   	pop    %ebp
80100713:	c3                   	ret    
    release(&cons.lock);
80100714:	83 ec 0c             	sub    $0xc,%esp
80100717:	68 20 a5 10 80       	push   $0x8010a520
8010071c:	e8 bf 37 00 00       	call   80103ee0 <release>
80100721:	83 c4 10             	add    $0x10,%esp
}
80100724:	eb e6                	jmp    8010070c <cprintf+0x10f>

80100726 <consoleintr>:
{
80100726:	f3 0f 1e fb          	endbr32 
8010072a:	55                   	push   %ebp
8010072b:	89 e5                	mov    %esp,%ebp
8010072d:	57                   	push   %edi
8010072e:	56                   	push   %esi
8010072f:	53                   	push   %ebx
80100730:	83 ec 18             	sub    $0x18,%esp
80100733:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100736:	68 20 a5 10 80       	push   $0x8010a520
8010073b:	e8 37 37 00 00       	call   80103e77 <acquire>
  while((c = getc()) >= 0){
80100740:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100743:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100748:	eb 13                	jmp    8010075d <consoleintr+0x37>
    switch(c){
8010074a:	83 ff 08             	cmp    $0x8,%edi
8010074d:	0f 84 d1 00 00 00    	je     80100824 <consoleintr+0xfe>
80100753:	83 ff 10             	cmp    $0x10,%edi
80100756:	75 25                	jne    8010077d <consoleintr+0x57>
80100758:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010075d:	ff d3                	call   *%ebx
8010075f:	89 c7                	mov    %eax,%edi
80100761:	85 c0                	test   %eax,%eax
80100763:	0f 88 eb 00 00 00    	js     80100854 <consoleintr+0x12e>
    switch(c){
80100769:	83 ff 15             	cmp    $0x15,%edi
8010076c:	0f 84 8d 00 00 00    	je     801007ff <consoleintr+0xd9>
80100772:	7e d6                	jle    8010074a <consoleintr+0x24>
80100774:	83 ff 7f             	cmp    $0x7f,%edi
80100777:	0f 84 a7 00 00 00    	je     80100824 <consoleintr+0xfe>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010077d:	85 ff                	test   %edi,%edi
8010077f:	74 dc                	je     8010075d <consoleintr+0x37>
80100781:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100786:	89 c2                	mov    %eax,%edx
80100788:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
8010078e:	83 fa 7f             	cmp    $0x7f,%edx
80100791:	77 ca                	ja     8010075d <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
80100793:	83 ff 0d             	cmp    $0xd,%edi
80100796:	0f 84 ae 00 00 00    	je     8010084a <consoleintr+0x124>
        input.buf[input.e++ % INPUT_BUF] = c;
8010079c:	8d 50 01             	lea    0x1(%eax),%edx
8010079f:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
801007a5:	83 e0 7f             	and    $0x7f,%eax
801007a8:	89 f9                	mov    %edi,%ecx
801007aa:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801007b0:	89 f8                	mov    %edi,%eax
801007b2:	e8 1c fd ff ff       	call   801004d3 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007b7:	83 ff 0a             	cmp    $0xa,%edi
801007ba:	74 15                	je     801007d1 <consoleintr+0xab>
801007bc:	83 ff 04             	cmp    $0x4,%edi
801007bf:	74 10                	je     801007d1 <consoleintr+0xab>
801007c1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801007c6:	83 e8 80             	sub    $0xffffff80,%eax
801007c9:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801007cf:	75 8c                	jne    8010075d <consoleintr+0x37>
          input.w = input.e;
801007d1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007d6:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801007db:	83 ec 0c             	sub    $0xc,%esp
801007de:	68 a0 ff 10 80       	push   $0x8010ffa0
801007e3:	e8 bf 32 00 00       	call   80103aa7 <wakeup>
801007e8:	83 c4 10             	add    $0x10,%esp
801007eb:	e9 6d ff ff ff       	jmp    8010075d <consoleintr+0x37>
        input.e--;
801007f0:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801007f5:	b8 00 01 00 00       	mov    $0x100,%eax
801007fa:	e8 d4 fc ff ff       	call   801004d3 <consputc>
      while(input.e != input.w &&
801007ff:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100804:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010080a:	0f 84 4d ff ff ff    	je     8010075d <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100810:	48                   	dec    %eax
80100811:	89 c2                	mov    %eax,%edx
80100813:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100816:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010081d:	75 d1                	jne    801007f0 <consoleintr+0xca>
8010081f:	e9 39 ff ff ff       	jmp    8010075d <consoleintr+0x37>
      if(input.e != input.w){
80100824:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100829:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010082f:	0f 84 28 ff ff ff    	je     8010075d <consoleintr+0x37>
        input.e--;
80100835:	48                   	dec    %eax
80100836:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010083b:	b8 00 01 00 00       	mov    $0x100,%eax
80100840:	e8 8e fc ff ff       	call   801004d3 <consputc>
80100845:	e9 13 ff ff ff       	jmp    8010075d <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
8010084a:	bf 0a 00 00 00       	mov    $0xa,%edi
8010084f:	e9 48 ff ff ff       	jmp    8010079c <consoleintr+0x76>
  release(&cons.lock);
80100854:	83 ec 0c             	sub    $0xc,%esp
80100857:	68 20 a5 10 80       	push   $0x8010a520
8010085c:	e8 7f 36 00 00       	call   80103ee0 <release>
  if(doprocdump) {
80100861:	83 c4 10             	add    $0x10,%esp
80100864:	85 f6                	test   %esi,%esi
80100866:	75 08                	jne    80100870 <consoleintr+0x14a>
}
80100868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086b:	5b                   	pop    %ebx
8010086c:	5e                   	pop    %esi
8010086d:	5f                   	pop    %edi
8010086e:	5d                   	pop    %ebp
8010086f:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100870:	e8 e5 32 00 00       	call   80103b5a <procdump>
}
80100875:	eb f1                	jmp    80100868 <consoleintr+0x142>

80100877 <consoleinit>:

void
consoleinit(void)
{
80100877:	f3 0f 1e fb          	endbr32 
8010087b:	55                   	push   %ebp
8010087c:	89 e5                	mov    %esp,%ebp
8010087e:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100881:	68 08 6b 10 80       	push   $0x80106b08
80100886:	68 20 a5 10 80       	push   $0x8010a520
8010088b:	e8 9c 34 00 00       	call   80103d2c <initlock>

  devsw[CONSOLE].write = consolewrite;
80100890:	c7 05 6c 09 11 80 9c 	movl   $0x8010059c,0x8011096c
80100897:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010089a:	c7 05 68 09 11 80 74 	movl   $0x80100274,0x80110968
801008a1:	02 10 80 
  cons.locking = 1;
801008a4:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008ab:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008ae:	83 c4 08             	add    $0x8,%esp
801008b1:	6a 00                	push   $0x0
801008b3:	6a 01                	push   $0x1
801008b5:	e8 fb 16 00 00       	call   80101fb5 <ioapicenable>
}
801008ba:	83 c4 10             	add    $0x10,%esp
801008bd:	c9                   	leave  
801008be:	c3                   	ret    

801008bf <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008bf:	f3 0f 1e fb          	endbr32 
801008c3:	55                   	push   %ebp
801008c4:	89 e5                	mov    %esp,%ebp
801008c6:	57                   	push   %edi
801008c7:	56                   	push   %esi
801008c8:	53                   	push   %ebx
801008c9:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801008cf:	e8 77 29 00 00       	call   8010324b <myproc>
801008d4:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008da:	e8 04 1f 00 00       	call   801027e3 <begin_op>

  if((ip = namei(path)) == 0){
801008df:	83 ec 0c             	sub    $0xc,%esp
801008e2:	ff 75 08             	pushl  0x8(%ebp)
801008e5:	e8 38 13 00 00       	call   80101c22 <namei>
801008ea:	83 c4 10             	add    $0x10,%esp
801008ed:	85 c0                	test   %eax,%eax
801008ef:	74 56                	je     80100947 <exec+0x88>
801008f1:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	50                   	push   %eax
801008f7:	e8 9a 0c 00 00       	call   80101596 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008fc:	6a 34                	push   $0x34
801008fe:	6a 00                	push   $0x0
80100900:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100906:	50                   	push   %eax
80100907:	53                   	push   %ebx
80100908:	e8 8a 0e 00 00       	call   80101797 <readi>
8010090d:	83 c4 20             	add    $0x20,%esp
80100910:	83 f8 34             	cmp    $0x34,%eax
80100913:	75 0c                	jne    80100921 <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100915:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010091c:	45 4c 46 
8010091f:	74 42                	je     80100963 <exec+0xa4>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir, 1);
  if(ip){
80100921:	85 db                	test   %ebx,%ebx
80100923:	0f 84 e0 02 00 00    	je     80100c09 <exec+0x34a>
    iunlockput(ip);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	53                   	push   %ebx
8010092d:	e8 13 0e 00 00       	call   80101745 <iunlockput>
    end_op();
80100932:	e8 2c 1f 00 00       	call   80102863 <end_op>
80100937:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010093a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010093f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100942:	5b                   	pop    %ebx
80100943:	5e                   	pop    %esi
80100944:	5f                   	pop    %edi
80100945:	5d                   	pop    %ebp
80100946:	c3                   	ret    
    end_op();
80100947:	e8 17 1f 00 00       	call   80102863 <end_op>
    cprintf("exec: fail\n");
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 21 6b 10 80       	push   $0x80106b21
80100954:	e8 a4 fc ff ff       	call   801005fd <cprintf>
    return -1;
80100959:	83 c4 10             	add    $0x10,%esp
8010095c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100961:	eb dc                	jmp    8010093f <exec+0x80>
  if((pgdir = setupkvm()) == 0)
80100963:	e8 d7 5e 00 00       	call   8010683f <setupkvm>
80100968:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010096e:	85 c0                	test   %eax,%eax
80100970:	0f 84 24 01 00 00    	je     80100a9a <exec+0x1db>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100976:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
8010097c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100983:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100986:	be 00 00 00 00       	mov    $0x0,%esi
8010098b:	eb 04                	jmp    80100991 <exec+0xd2>
8010098d:	46                   	inc    %esi
8010098e:	8d 47 20             	lea    0x20(%edi),%eax
80100991:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100998:	39 f2                	cmp    %esi,%edx
8010099a:	0f 8e a5 00 00 00    	jle    80100a45 <exec+0x186>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009a0:	89 c7                	mov    %eax,%edi
801009a2:	6a 20                	push   $0x20
801009a4:	50                   	push   %eax
801009a5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ab:	50                   	push   %eax
801009ac:	53                   	push   %ebx
801009ad:	e8 e5 0d 00 00       	call   80101797 <readi>
801009b2:	83 c4 10             	add    $0x10,%esp
801009b5:	83 f8 20             	cmp    $0x20,%eax
801009b8:	0f 85 dc 00 00 00    	jne    80100a9a <exec+0x1db>
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
801009be:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009c5:	75 c6                	jne    8010098d <exec+0xce>
801009c7:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009cd:	85 c0                	test   %eax,%eax
801009cf:	74 bc                	je     8010098d <exec+0xce>
    if(ph.memsz < ph.filesz)
801009d1:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009d7:	0f 82 bd 00 00 00    	jb     80100a9a <exec+0x1db>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009dd:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009e3:	0f 82 b1 00 00 00    	jb     80100a9a <exec+0x1db>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009e9:	83 ec 04             	sub    $0x4,%esp
801009ec:	50                   	push   %eax
801009ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801009f3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801009f9:	e8 d7 5c 00 00       	call   801066d5 <allocuvm>
801009fe:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a04:	83 c4 10             	add    $0x10,%esp
80100a07:	85 c0                	test   %eax,%eax
80100a09:	0f 84 8b 00 00 00    	je     80100a9a <exec+0x1db>
    if(ph.vaddr % PGSIZE != 0)
80100a0f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a15:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a1a:	75 7e                	jne    80100a9a <exec+0x1db>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a1c:	83 ec 0c             	sub    $0xc,%esp
80100a1f:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a25:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a2b:	53                   	push   %ebx
80100a2c:	50                   	push   %eax
80100a2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100a33:	e8 6b 5b 00 00       	call   801065a3 <loaduvm>
80100a38:	83 c4 20             	add    $0x20,%esp
80100a3b:	85 c0                	test   %eax,%eax
80100a3d:	0f 89 4a ff ff ff    	jns    8010098d <exec+0xce>
80100a43:	eb 55                	jmp    80100a9a <exec+0x1db>
  iunlockput(ip);
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	53                   	push   %ebx
80100a49:	e8 f7 0c 00 00       	call   80101745 <iunlockput>
  end_op();
80100a4e:	e8 10 1e 00 00       	call   80102863 <end_op>
  sz = PGROUNDUP(sz);
80100a53:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a59:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  curproc->pagina_guarda = sz;
80100a63:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100a69:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a6f:	83 c4 0c             	add    $0xc,%esp
80100a72:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a78:	52                   	push   %edx
80100a79:	50                   	push   %eax
80100a7a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100a80:	56                   	push   %esi
80100a81:	e8 4f 5c 00 00       	call   801066d5 <allocuvm>
80100a86:	89 c7                	mov    %eax,%edi
80100a88:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a8e:	83 c4 10             	add    $0x10,%esp
80100a91:	85 c0                	test   %eax,%eax
80100a93:	75 26                	jne    80100abb <exec+0x1fc>
  ip = 0;
80100a95:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a9a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100aa0:	85 c0                	test   %eax,%eax
80100aa2:	0f 84 79 fe ff ff    	je     80100921 <exec+0x62>
    freevm(pgdir, 1);
80100aa8:	83 ec 08             	sub    $0x8,%esp
80100aab:	6a 01                	push   $0x1
80100aad:	50                   	push   %eax
80100aae:	e8 12 5d 00 00       	call   801067c5 <freevm>
80100ab3:	83 c4 10             	add    $0x10,%esp
80100ab6:	e9 66 fe ff ff       	jmp    80100921 <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100abb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ac1:	83 ec 08             	sub    $0x8,%esp
80100ac4:	50                   	push   %eax
80100ac5:	56                   	push   %esi
80100ac6:	e8 03 5e 00 00       	call   801068ce <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100acb:	83 c4 10             	add    $0x10,%esp
80100ace:	be 00 00 00 00       	mov    $0x0,%esi
80100ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad6:	8d 1c b0             	lea    (%eax,%esi,4),%ebx
80100ad9:	8b 03                	mov    (%ebx),%eax
80100adb:	85 c0                	test   %eax,%eax
80100add:	74 47                	je     80100b26 <exec+0x267>
    if(argc >= MAXARG)
80100adf:	83 fe 1f             	cmp    $0x1f,%esi
80100ae2:	0f 87 0d 01 00 00    	ja     80100bf5 <exec+0x336>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ae8:	83 ec 0c             	sub    $0xc,%esp
80100aeb:	50                   	push   %eax
80100aec:	e8 e2 35 00 00       	call   801040d3 <strlen>
80100af1:	29 c7                	sub    %eax,%edi
80100af3:	4f                   	dec    %edi
80100af4:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100af7:	83 c4 04             	add    $0x4,%esp
80100afa:	ff 33                	pushl  (%ebx)
80100afc:	e8 d2 35 00 00       	call   801040d3 <strlen>
80100b01:	40                   	inc    %eax
80100b02:	50                   	push   %eax
80100b03:	ff 33                	pushl  (%ebx)
80100b05:	57                   	push   %edi
80100b06:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b0c:	e8 fc 5e 00 00       	call   80106a0d <copyout>
80100b11:	83 c4 20             	add    $0x20,%esp
80100b14:	85 c0                	test   %eax,%eax
80100b16:	0f 88 e3 00 00 00    	js     80100bff <exec+0x340>
    ustack[3+argc] = sp;
80100b1c:	89 bc b5 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b23:	46                   	inc    %esi
80100b24:	eb ad                	jmp    80100ad3 <exec+0x214>
80100b26:	89 f9                	mov    %edi,%ecx
80100b28:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b2a:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b31:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b35:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b3c:	ff ff ff 
  ustack[1] = argc;
80100b3f:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b45:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100b4c:	89 fa                	mov    %edi,%edx
80100b4e:	29 c2                	sub    %eax,%edx
80100b50:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b56:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100b5d:	29 c1                	sub    %eax,%ecx
80100b5f:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b61:	50                   	push   %eax
80100b62:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b68:	50                   	push   %eax
80100b69:	51                   	push   %ecx
80100b6a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b70:	e8 98 5e 00 00       	call   80106a0d <copyout>
80100b75:	83 c4 10             	add    $0x10,%esp
80100b78:	85 c0                	test   %eax,%eax
80100b7a:	0f 88 1a ff ff ff    	js     80100a9a <exec+0x1db>
  for(last=s=path; *s; s++)
80100b80:	8b 55 08             	mov    0x8(%ebp),%edx
80100b83:	89 d0                	mov    %edx,%eax
80100b85:	eb 01                	jmp    80100b88 <exec+0x2c9>
80100b87:	40                   	inc    %eax
80100b88:	8a 08                	mov    (%eax),%cl
80100b8a:	84 c9                	test   %cl,%cl
80100b8c:	74 0a                	je     80100b98 <exec+0x2d9>
    if(*s == '/')
80100b8e:	80 f9 2f             	cmp    $0x2f,%cl
80100b91:	75 f4                	jne    80100b87 <exec+0x2c8>
      last = s+1;
80100b93:	8d 50 01             	lea    0x1(%eax),%edx
80100b96:	eb ef                	jmp    80100b87 <exec+0x2c8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b98:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b9e:	89 f8                	mov    %edi,%eax
80100ba0:	83 c0 6c             	add    $0x6c,%eax
80100ba3:	83 ec 04             	sub    $0x4,%esp
80100ba6:	6a 10                	push   $0x10
80100ba8:	52                   	push   %edx
80100ba9:	50                   	push   %eax
80100baa:	e8 e8 34 00 00       	call   80104097 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100baf:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100bb2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bb8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bbb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bc1:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bc3:	8b 47 18             	mov    0x18(%edi),%eax
80100bc6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bcc:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bcf:	8b 47 18             	mov    0x18(%edi),%eax
80100bd2:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bd5:	89 3c 24             	mov    %edi,(%esp)
80100bd8:	e8 41 58 00 00       	call   8010641e <switchuvm>
  freevm(oldpgdir, 1);
80100bdd:	83 c4 08             	add    $0x8,%esp
80100be0:	6a 01                	push   $0x1
80100be2:	53                   	push   %ebx
80100be3:	e8 dd 5b 00 00       	call   801067c5 <freevm>
  return 0;
80100be8:	83 c4 10             	add    $0x10,%esp
80100beb:	b8 00 00 00 00       	mov    $0x0,%eax
80100bf0:	e9 4a fd ff ff       	jmp    8010093f <exec+0x80>
  ip = 0;
80100bf5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bfa:	e9 9b fe ff ff       	jmp    80100a9a <exec+0x1db>
80100bff:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c04:	e9 91 fe ff ff       	jmp    80100a9a <exec+0x1db>
  return -1;
80100c09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0e:	e9 2c fd ff ff       	jmp    8010093f <exec+0x80>

80100c13 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c13:	f3 0f 1e fb          	endbr32 
80100c17:	55                   	push   %ebp
80100c18:	89 e5                	mov    %esp,%ebp
80100c1a:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c1d:	68 2d 6b 10 80       	push   $0x80106b2d
80100c22:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c27:	e8 00 31 00 00       	call   80103d2c <initlock>
}
80100c2c:	83 c4 10             	add    $0x10,%esp
80100c2f:	c9                   	leave  
80100c30:	c3                   	ret    

80100c31 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c31:	f3 0f 1e fb          	endbr32 
80100c35:	55                   	push   %ebp
80100c36:	89 e5                	mov    %esp,%ebp
80100c38:	53                   	push   %ebx
80100c39:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c41:	e8 31 32 00 00       	call   80103e77 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c46:	83 c4 10             	add    $0x10,%esp
80100c49:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c4e:	eb 03                	jmp    80100c53 <filealloc+0x22>
80100c50:	83 c3 18             	add    $0x18,%ebx
80100c53:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c59:	73 24                	jae    80100c7f <filealloc+0x4e>
    if(f->ref == 0){
80100c5b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c5f:	75 ef                	jne    80100c50 <filealloc+0x1f>
      f->ref = 1;
80100c61:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c68:	83 ec 0c             	sub    $0xc,%esp
80100c6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c70:	e8 6b 32 00 00       	call   80103ee0 <release>
      return f;
80100c75:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c78:	89 d8                	mov    %ebx,%eax
80100c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7d:	c9                   	leave  
80100c7e:	c3                   	ret    
  release(&ftable.lock);
80100c7f:	83 ec 0c             	sub    $0xc,%esp
80100c82:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c87:	e8 54 32 00 00       	call   80103ee0 <release>
  return 0;
80100c8c:	83 c4 10             	add    $0x10,%esp
80100c8f:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c94:	eb e2                	jmp    80100c78 <filealloc+0x47>

80100c96 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c96:	f3 0f 1e fb          	endbr32 
80100c9a:	55                   	push   %ebp
80100c9b:	89 e5                	mov    %esp,%ebp
80100c9d:	53                   	push   %ebx
80100c9e:	83 ec 10             	sub    $0x10,%esp
80100ca1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ca4:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ca9:	e8 c9 31 00 00       	call   80103e77 <acquire>
  if(f->ref < 1)
80100cae:	8b 43 04             	mov    0x4(%ebx),%eax
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	85 c0                	test   %eax,%eax
80100cb6:	7e 18                	jle    80100cd0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
80100cb8:	40                   	inc    %eax
80100cb9:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100cbc:	83 ec 0c             	sub    $0xc,%esp
80100cbf:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cc4:	e8 17 32 00 00       	call   80103ee0 <release>
  return f;
}
80100cc9:	89 d8                	mov    %ebx,%eax
80100ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cce:	c9                   	leave  
80100ccf:	c3                   	ret    
    panic("filedup");
80100cd0:	83 ec 0c             	sub    $0xc,%esp
80100cd3:	68 34 6b 10 80       	push   $0x80106b34
80100cd8:	e8 78 f6 ff ff       	call   80100355 <panic>

80100cdd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100cdd:	f3 0f 1e fb          	endbr32 
80100ce1:	55                   	push   %ebp
80100ce2:	89 e5                	mov    %esp,%ebp
80100ce4:	57                   	push   %edi
80100ce5:	56                   	push   %esi
80100ce6:	53                   	push   %ebx
80100ce7:	83 ec 38             	sub    $0x38,%esp
80100cea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ced:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cf2:	e8 80 31 00 00       	call   80103e77 <acquire>
  if(f->ref < 1)
80100cf7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cfa:	83 c4 10             	add    $0x10,%esp
80100cfd:	85 c0                	test   %eax,%eax
80100cff:	7e 58                	jle    80100d59 <fileclose+0x7c>
    panic("fileclose");
  if(--f->ref > 0){
80100d01:	48                   	dec    %eax
80100d02:	89 43 04             	mov    %eax,0x4(%ebx)
80100d05:	85 c0                	test   %eax,%eax
80100d07:	7f 5d                	jg     80100d66 <fileclose+0x89>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d09:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100d0c:	b9 06 00 00 00       	mov    $0x6,%ecx
80100d11:	89 de                	mov    %ebx,%esi
80100d13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100d15:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d22:	83 ec 0c             	sub    $0xc,%esp
80100d25:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d2a:	e8 b1 31 00 00       	call   80103ee0 <release>

  if(ff.type == FD_PIPE)
80100d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d32:	83 c4 10             	add    $0x10,%esp
80100d35:	83 f8 01             	cmp    $0x1,%eax
80100d38:	74 44                	je     80100d7e <fileclose+0xa1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d3a:	83 f8 02             	cmp    $0x2,%eax
80100d3d:	75 37                	jne    80100d76 <fileclose+0x99>
    begin_op();
80100d3f:	e8 9f 1a 00 00       	call   801027e3 <begin_op>
    iput(ff.ip);
80100d44:	83 ec 0c             	sub    $0xc,%esp
80100d47:	ff 75 e0             	pushl  -0x20(%ebp)
80100d4a:	e8 54 09 00 00       	call   801016a3 <iput>
    end_op();
80100d4f:	e8 0f 1b 00 00       	call   80102863 <end_op>
80100d54:	83 c4 10             	add    $0x10,%esp
80100d57:	eb 1d                	jmp    80100d76 <fileclose+0x99>
    panic("fileclose");
80100d59:	83 ec 0c             	sub    $0xc,%esp
80100d5c:	68 3c 6b 10 80       	push   $0x80106b3c
80100d61:	e8 ef f5 ff ff       	call   80100355 <panic>
    release(&ftable.lock);
80100d66:	83 ec 0c             	sub    $0xc,%esp
80100d69:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d6e:	e8 6d 31 00 00       	call   80103ee0 <release>
    return;
80100d73:	83 c4 10             	add    $0x10,%esp
  }
}
80100d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d79:	5b                   	pop    %ebx
80100d7a:	5e                   	pop    %esi
80100d7b:	5f                   	pop    %edi
80100d7c:	5d                   	pop    %ebp
80100d7d:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d7e:	83 ec 08             	sub    $0x8,%esp
80100d81:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d85:	50                   	push   %eax
80100d86:	ff 75 dc             	pushl  -0x24(%ebp)
80100d89:	e8 d6 20 00 00       	call   80102e64 <pipeclose>
80100d8e:	83 c4 10             	add    $0x10,%esp
80100d91:	eb e3                	jmp    80100d76 <fileclose+0x99>

80100d93 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d93:	f3 0f 1e fb          	endbr32 
80100d97:	55                   	push   %ebp
80100d98:	89 e5                	mov    %esp,%ebp
80100d9a:	53                   	push   %ebx
80100d9b:	83 ec 04             	sub    $0x4,%esp
80100d9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100da1:	83 3b 02             	cmpl   $0x2,(%ebx)
80100da4:	75 31                	jne    80100dd7 <filestat+0x44>
    ilock(f->ip);
80100da6:	83 ec 0c             	sub    $0xc,%esp
80100da9:	ff 73 10             	pushl  0x10(%ebx)
80100dac:	e8 e5 07 00 00       	call   80101596 <ilock>
    stati(f->ip, st);
80100db1:	83 c4 08             	add    $0x8,%esp
80100db4:	ff 75 0c             	pushl  0xc(%ebp)
80100db7:	ff 73 10             	pushl  0x10(%ebx)
80100dba:	e8 aa 09 00 00       	call   80101769 <stati>
    iunlock(f->ip);
80100dbf:	83 c4 04             	add    $0x4,%esp
80100dc2:	ff 73 10             	pushl  0x10(%ebx)
80100dc5:	e8 90 08 00 00       	call   8010165a <iunlock>
    return 0;
80100dca:	83 c4 10             	add    $0x10,%esp
80100dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
  return -1;
80100dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ddc:	eb f4                	jmp    80100dd2 <filestat+0x3f>

80100dde <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dde:	f3 0f 1e fb          	endbr32 
80100de2:	55                   	push   %ebp
80100de3:	89 e5                	mov    %esp,%ebp
80100de5:	56                   	push   %esi
80100de6:	53                   	push   %ebx
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dea:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100dee:	74 70                	je     80100e60 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100df0:	8b 03                	mov    (%ebx),%eax
80100df2:	83 f8 01             	cmp    $0x1,%eax
80100df5:	74 44                	je     80100e3b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100df7:	83 f8 02             	cmp    $0x2,%eax
80100dfa:	75 57                	jne    80100e53 <fileread+0x75>
    ilock(f->ip);
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	ff 73 10             	pushl  0x10(%ebx)
80100e02:	e8 8f 07 00 00       	call   80101596 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e07:	ff 75 10             	pushl  0x10(%ebp)
80100e0a:	ff 73 14             	pushl  0x14(%ebx)
80100e0d:	ff 75 0c             	pushl  0xc(%ebp)
80100e10:	ff 73 10             	pushl  0x10(%ebx)
80100e13:	e8 7f 09 00 00       	call   80101797 <readi>
80100e18:	89 c6                	mov    %eax,%esi
80100e1a:	83 c4 20             	add    $0x20,%esp
80100e1d:	85 c0                	test   %eax,%eax
80100e1f:	7e 03                	jle    80100e24 <fileread+0x46>
      f->off += r;
80100e21:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e24:	83 ec 0c             	sub    $0xc,%esp
80100e27:	ff 73 10             	pushl  0x10(%ebx)
80100e2a:	e8 2b 08 00 00       	call   8010165a <iunlock>
    return r;
80100e2f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e32:	89 f0                	mov    %esi,%eax
80100e34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e37:	5b                   	pop    %ebx
80100e38:	5e                   	pop    %esi
80100e39:	5d                   	pop    %ebp
80100e3a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e3b:	83 ec 04             	sub    $0x4,%esp
80100e3e:	ff 75 10             	pushl  0x10(%ebp)
80100e41:	ff 75 0c             	pushl  0xc(%ebp)
80100e44:	ff 73 0c             	pushl  0xc(%ebx)
80100e47:	e8 72 21 00 00       	call   80102fbe <piperead>
80100e4c:	89 c6                	mov    %eax,%esi
80100e4e:	83 c4 10             	add    $0x10,%esp
80100e51:	eb df                	jmp    80100e32 <fileread+0x54>
  panic("fileread");
80100e53:	83 ec 0c             	sub    $0xc,%esp
80100e56:	68 46 6b 10 80       	push   $0x80106b46
80100e5b:	e8 f5 f4 ff ff       	call   80100355 <panic>
    return -1;
80100e60:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e65:	eb cb                	jmp    80100e32 <fileread+0x54>

80100e67 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e67:	f3 0f 1e fb          	endbr32 
80100e6b:	55                   	push   %ebp
80100e6c:	89 e5                	mov    %esp,%ebp
80100e6e:	57                   	push   %edi
80100e6f:	56                   	push   %esi
80100e70:	53                   	push   %ebx
80100e71:	83 ec 1c             	sub    $0x1c,%esp
80100e74:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e77:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e7b:	0f 84 cc 00 00 00    	je     80100f4d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100e81:	8b 06                	mov    (%esi),%eax
80100e83:	83 f8 01             	cmp    $0x1,%eax
80100e86:	74 10                	je     80100e98 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e88:	83 f8 02             	cmp    $0x2,%eax
80100e8b:	0f 85 af 00 00 00    	jne    80100f40 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e91:	bf 00 00 00 00       	mov    $0x0,%edi
80100e96:	eb 67                	jmp    80100eff <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100e98:	83 ec 04             	sub    $0x4,%esp
80100e9b:	ff 75 10             	pushl  0x10(%ebp)
80100e9e:	ff 75 0c             	pushl  0xc(%ebp)
80100ea1:	ff 76 0c             	pushl  0xc(%esi)
80100ea4:	e8 4b 20 00 00       	call   80102ef4 <pipewrite>
80100ea9:	83 c4 10             	add    $0x10,%esp
80100eac:	e9 82 00 00 00       	jmp    80100f33 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100eb1:	e8 2d 19 00 00       	call   801027e3 <begin_op>
      ilock(f->ip);
80100eb6:	83 ec 0c             	sub    $0xc,%esp
80100eb9:	ff 76 10             	pushl  0x10(%esi)
80100ebc:	e8 d5 06 00 00       	call   80101596 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ec1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100ec4:	ff 76 14             	pushl  0x14(%esi)
80100ec7:	89 f8                	mov    %edi,%eax
80100ec9:	03 45 0c             	add    0xc(%ebp),%eax
80100ecc:	50                   	push   %eax
80100ecd:	ff 76 10             	pushl  0x10(%esi)
80100ed0:	e8 c6 09 00 00       	call   8010189b <writei>
80100ed5:	89 c3                	mov    %eax,%ebx
80100ed7:	83 c4 20             	add    $0x20,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 03                	jle    80100ee1 <filewrite+0x7a>
        f->off += r;
80100ede:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
80100ee4:	ff 76 10             	pushl  0x10(%esi)
80100ee7:	e8 6e 07 00 00       	call   8010165a <iunlock>
      end_op();
80100eec:	e8 72 19 00 00       	call   80102863 <end_op>

      if(r < 0)
80100ef1:	83 c4 10             	add    $0x10,%esp
80100ef4:	85 db                	test   %ebx,%ebx
80100ef6:	78 31                	js     80100f29 <filewrite+0xc2>
        break;
      if(r != n1)
80100ef8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100efb:	75 1f                	jne    80100f1c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100efd:	01 df                	add    %ebx,%edi
    while(i < n){
80100eff:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f02:	7d 25                	jge    80100f29 <filewrite+0xc2>
      int n1 = n - i;
80100f04:	8b 45 10             	mov    0x10(%ebp),%eax
80100f07:	29 f8                	sub    %edi,%eax
80100f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f0c:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f11:	7e 9e                	jle    80100eb1 <filewrite+0x4a>
        n1 = max;
80100f13:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f1a:	eb 95                	jmp    80100eb1 <filewrite+0x4a>
        panic("short filewrite");
80100f1c:	83 ec 0c             	sub    $0xc,%esp
80100f1f:	68 4f 6b 10 80       	push   $0x80106b4f
80100f24:	e8 2c f4 ff ff       	call   80100355 <panic>
    }
    return i == n ? n : -1;
80100f29:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f2c:	74 0d                	je     80100f3b <filewrite+0xd4>
80100f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f36:	5b                   	pop    %ebx
80100f37:	5e                   	pop    %esi
80100f38:	5f                   	pop    %edi
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
    return i == n ? n : -1;
80100f3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f3e:	eb f3                	jmp    80100f33 <filewrite+0xcc>
  panic("filewrite");
80100f40:	83 ec 0c             	sub    $0xc,%esp
80100f43:	68 55 6b 10 80       	push   $0x80106b55
80100f48:	e8 08 f4 ff ff       	call   80100355 <panic>
    return -1;
80100f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f52:	eb df                	jmp    80100f33 <filewrite+0xcc>

80100f54 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f54:	55                   	push   %ebp
80100f55:	89 e5                	mov    %esp,%ebp
80100f57:	57                   	push   %edi
80100f58:	56                   	push   %esi
80100f59:	53                   	push   %ebx
80100f5a:	83 ec 0c             	sub    $0xc,%esp
80100f5d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f5f:	8a 10                	mov    (%eax),%dl
80100f61:	80 fa 2f             	cmp    $0x2f,%dl
80100f64:	75 03                	jne    80100f69 <skipelem+0x15>
    path++;
80100f66:	40                   	inc    %eax
80100f67:	eb f6                	jmp    80100f5f <skipelem+0xb>
  if(*path == 0)
80100f69:	84 d2                	test   %dl,%dl
80100f6b:	74 4e                	je     80100fbb <skipelem+0x67>
80100f6d:	89 c3                	mov    %eax,%ebx
80100f6f:	eb 01                	jmp    80100f72 <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f71:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f72:	8a 13                	mov    (%ebx),%dl
80100f74:	80 fa 2f             	cmp    $0x2f,%dl
80100f77:	74 04                	je     80100f7d <skipelem+0x29>
80100f79:	84 d2                	test   %dl,%dl
80100f7b:	75 f4                	jne    80100f71 <skipelem+0x1d>
  len = path - s;
80100f7d:	89 df                	mov    %ebx,%edi
80100f7f:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f81:	83 ff 0d             	cmp    $0xd,%edi
80100f84:	7e 11                	jle    80100f97 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f86:	83 ec 04             	sub    $0x4,%esp
80100f89:	6a 0e                	push   $0xe
80100f8b:	50                   	push   %eax
80100f8c:	56                   	push   %esi
80100f8d:	e8 17 30 00 00       	call   80103fa9 <memmove>
80100f92:	83 c4 10             	add    $0x10,%esp
80100f95:	eb 15                	jmp    80100fac <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f97:	83 ec 04             	sub    $0x4,%esp
80100f9a:	57                   	push   %edi
80100f9b:	50                   	push   %eax
80100f9c:	56                   	push   %esi
80100f9d:	e8 07 30 00 00       	call   80103fa9 <memmove>
    name[len] = 0;
80100fa2:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fa6:	83 c4 10             	add    $0x10,%esp
80100fa9:	eb 01                	jmp    80100fac <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100fab:	43                   	inc    %ebx
  while(*path == '/')
80100fac:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100faf:	74 fa                	je     80100fab <skipelem+0x57>
  return path;
}
80100fb1:	89 d8                	mov    %ebx,%eax
80100fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb6:	5b                   	pop    %ebx
80100fb7:	5e                   	pop    %esi
80100fb8:	5f                   	pop    %edi
80100fb9:	5d                   	pop    %ebp
80100fba:	c3                   	ret    
    return 0;
80100fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fc0:	eb ef                	jmp    80100fb1 <skipelem+0x5d>

80100fc2 <bzero>:
{
80100fc2:	55                   	push   %ebp
80100fc3:	89 e5                	mov    %esp,%ebp
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fc9:	52                   	push   %edx
80100fca:	50                   	push   %eax
80100fcb:	e8 9e f1 ff ff       	call   8010016e <bread>
80100fd0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fd2:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fd5:	83 c4 0c             	add    $0xc,%esp
80100fd8:	68 00 02 00 00       	push   $0x200
80100fdd:	6a 00                	push   $0x0
80100fdf:	50                   	push   %eax
80100fe0:	e8 46 2f 00 00       	call   80103f2b <memset>
  log_write(bp);
80100fe5:	89 1c 24             	mov    %ebx,(%esp)
80100fe8:	e8 27 19 00 00       	call   80102914 <log_write>
  brelse(bp);
80100fed:	89 1c 24             	mov    %ebx,(%esp)
80100ff0:	e8 ea f1 ff ff       	call   801001df <brelse>
}
80100ff5:	83 c4 10             	add    $0x10,%esp
80100ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ffb:	c9                   	leave  
80100ffc:	c3                   	ret    

80100ffd <balloc>:
{
80100ffd:	55                   	push   %ebp
80100ffe:	89 e5                	mov    %esp,%ebp
80101000:	57                   	push   %edi
80101001:	56                   	push   %esi
80101002:	53                   	push   %ebx
80101003:	83 ec 1c             	sub    $0x1c,%esp
80101006:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101009:	bf 00 00 00 00       	mov    $0x0,%edi
8010100e:	eb 6d                	jmp    8010107d <balloc+0x80>
    bp = bread(dev, BBLOCK(b, sb));
80101010:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80101016:	eb 73                	jmp    8010108b <balloc+0x8e>
      m = 1 << (bi % 8);
80101018:	49                   	dec    %ecx
80101019:	83 c9 f8             	or     $0xfffffff8,%ecx
8010101c:	41                   	inc    %ecx
8010101d:	eb 38                	jmp    80101057 <balloc+0x5a>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010101f:	c1 f9 03             	sar    $0x3,%ecx
80101022:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101025:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101028:	8a 4c 0e 5c          	mov    0x5c(%esi,%ecx,1),%cl
8010102c:	0f b6 f1             	movzbl %cl,%esi
8010102f:	85 d6                	test   %edx,%esi
80101031:	0f 84 83 00 00 00    	je     801010ba <balloc+0xbd>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101037:	40                   	inc    %eax
80101038:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010103d:	7f 2a                	jg     80101069 <balloc+0x6c>
8010103f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80101042:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101045:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
8010104b:	73 1c                	jae    80101069 <balloc+0x6c>
      m = 1 << (bi % 8);
8010104d:	89 c1                	mov    %eax,%ecx
8010104f:	81 e1 07 00 00 80    	and    $0x80000007,%ecx
80101055:	78 c1                	js     80101018 <balloc+0x1b>
80101057:	ba 01 00 00 00       	mov    $0x1,%edx
8010105c:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010105e:	89 c1                	mov    %eax,%ecx
80101060:	85 c0                	test   %eax,%eax
80101062:	79 bb                	jns    8010101f <balloc+0x22>
80101064:	8d 48 07             	lea    0x7(%eax),%ecx
80101067:	eb b6                	jmp    8010101f <balloc+0x22>
    brelse(bp);
80101069:	83 ec 0c             	sub    $0xc,%esp
8010106c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010106f:	e8 6b f1 ff ff       	call   801001df <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101074:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010107a:	83 c4 10             	add    $0x10,%esp
8010107d:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
80101083:	76 28                	jbe    801010ad <balloc+0xb0>
    bp = bread(dev, BBLOCK(b, sb));
80101085:	89 f8                	mov    %edi,%eax
80101087:	85 ff                	test   %edi,%edi
80101089:	78 85                	js     80101010 <balloc+0x13>
8010108b:	c1 f8 0c             	sar    $0xc,%eax
8010108e:	83 ec 08             	sub    $0x8,%esp
80101091:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101097:	50                   	push   %eax
80101098:	ff 75 d8             	pushl  -0x28(%ebp)
8010109b:	e8 ce f0 ff ff       	call   8010016e <bread>
801010a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010a3:	83 c4 10             	add    $0x10,%esp
801010a6:	b8 00 00 00 00       	mov    $0x0,%eax
801010ab:	eb 8b                	jmp    80101038 <balloc+0x3b>
  panic("balloc: out of blocks");
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	68 5f 6b 10 80       	push   $0x80106b5f
801010b5:	e8 9b f2 ff ff       	call   80100355 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010ba:	09 ca                	or     %ecx,%edx
801010bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010bf:	8b 7d dc             	mov    -0x24(%ebp),%edi
801010c2:	88 54 38 5c          	mov    %dl,0x5c(%eax,%edi,1)
        log_write(bp);
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	89 c7                	mov    %eax,%edi
801010cb:	50                   	push   %eax
801010cc:	e8 43 18 00 00       	call   80102914 <log_write>
        brelse(bp);
801010d1:	89 3c 24             	mov    %edi,(%esp)
801010d4:	e8 06 f1 ff ff       	call   801001df <brelse>
        bzero(dev, b + bi);
801010d9:	89 da                	mov    %ebx,%edx
801010db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010de:	e8 df fe ff ff       	call   80100fc2 <bzero>
}
801010e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
801010ed:	c3                   	ret    

801010ee <bmap>:
{
801010ee:	55                   	push   %ebp
801010ef:	89 e5                	mov    %esp,%ebp
801010f1:	57                   	push   %edi
801010f2:	56                   	push   %esi
801010f3:	53                   	push   %ebx
801010f4:	83 ec 1c             	sub    $0x1c,%esp
801010f7:	89 c3                	mov    %eax,%ebx
801010f9:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801010fb:	83 fa 0b             	cmp    $0xb,%edx
801010fe:	76 45                	jbe    80101145 <bmap+0x57>
  bn -= NDIRECT;
80101100:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101103:	83 fe 7f             	cmp    $0x7f,%esi
80101106:	77 7f                	ja     80101187 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101108:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010110e:	85 c0                	test   %eax,%eax
80101110:	74 4a                	je     8010115c <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101112:	83 ec 08             	sub    $0x8,%esp
80101115:	50                   	push   %eax
80101116:	ff 33                	pushl  (%ebx)
80101118:	e8 51 f0 ff ff       	call   8010016e <bread>
8010111d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010111f:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101123:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101126:	8b 30                	mov    (%eax),%esi
80101128:	83 c4 10             	add    $0x10,%esp
8010112b:	85 f6                	test   %esi,%esi
8010112d:	74 3c                	je     8010116b <bmap+0x7d>
    brelse(bp);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	57                   	push   %edi
80101133:	e8 a7 f0 ff ff       	call   801001df <brelse>
    return addr;
80101138:	83 c4 10             	add    $0x10,%esp
}
8010113b:	89 f0                	mov    %esi,%eax
8010113d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101140:	5b                   	pop    %ebx
80101141:	5e                   	pop    %esi
80101142:	5f                   	pop    %edi
80101143:	5d                   	pop    %ebp
80101144:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
80101145:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
80101149:	85 f6                	test   %esi,%esi
8010114b:	75 ee                	jne    8010113b <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010114d:	8b 00                	mov    (%eax),%eax
8010114f:	e8 a9 fe ff ff       	call   80100ffd <balloc>
80101154:	89 c6                	mov    %eax,%esi
80101156:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
8010115a:	eb df                	jmp    8010113b <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010115c:	8b 03                	mov    (%ebx),%eax
8010115e:	e8 9a fe ff ff       	call   80100ffd <balloc>
80101163:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101169:	eb a7                	jmp    80101112 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
8010116b:	8b 03                	mov    (%ebx),%eax
8010116d:	e8 8b fe ff ff       	call   80100ffd <balloc>
80101172:	89 c6                	mov    %eax,%esi
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101179:	83 ec 0c             	sub    $0xc,%esp
8010117c:	57                   	push   %edi
8010117d:	e8 92 17 00 00       	call   80102914 <log_write>
80101182:	83 c4 10             	add    $0x10,%esp
80101185:	eb a8                	jmp    8010112f <bmap+0x41>
  panic("bmap: out of range");
80101187:	83 ec 0c             	sub    $0xc,%esp
8010118a:	68 75 6b 10 80       	push   $0x80106b75
8010118f:	e8 c1 f1 ff ff       	call   80100355 <panic>

80101194 <iget>:
{
80101194:	55                   	push   %ebp
80101195:	89 e5                	mov    %esp,%ebp
80101197:	57                   	push   %edi
80101198:	56                   	push   %esi
80101199:	53                   	push   %ebx
8010119a:	83 ec 28             	sub    $0x28,%esp
8010119d:	89 c7                	mov    %eax,%edi
8010119f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801011a2:	68 e0 09 11 80       	push   $0x801109e0
801011a7:	e8 cb 2c 00 00       	call   80103e77 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ac:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011af:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011b4:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801011b9:	eb 0a                	jmp    801011c5 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011bb:	85 f6                	test   %esi,%esi
801011bd:	74 39                	je     801011f8 <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011bf:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011c5:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011cb:	73 33                	jae    80101200 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011cd:	8b 43 08             	mov    0x8(%ebx),%eax
801011d0:	85 c0                	test   %eax,%eax
801011d2:	7e e7                	jle    801011bb <iget+0x27>
801011d4:	39 3b                	cmp    %edi,(%ebx)
801011d6:	75 e3                	jne    801011bb <iget+0x27>
801011d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011db:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011de:	75 db                	jne    801011bb <iget+0x27>
      ip->ref++;
801011e0:	40                   	inc    %eax
801011e1:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 e0 09 11 80       	push   $0x801109e0
801011ec:	e8 ef 2c 00 00       	call   80103ee0 <release>
      return ip;
801011f1:	83 c4 10             	add    $0x10,%esp
801011f4:	89 de                	mov    %ebx,%esi
801011f6:	eb 32                	jmp    8010122a <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011f8:	85 c0                	test   %eax,%eax
801011fa:	75 c3                	jne    801011bf <iget+0x2b>
      empty = ip;
801011fc:	89 de                	mov    %ebx,%esi
801011fe:	eb bf                	jmp    801011bf <iget+0x2b>
  if(empty == 0)
80101200:	85 f6                	test   %esi,%esi
80101202:	74 30                	je     80101234 <iget+0xa0>
  ip->dev = dev;
80101204:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101209:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
8010120c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101213:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010121a:	83 ec 0c             	sub    $0xc,%esp
8010121d:	68 e0 09 11 80       	push   $0x801109e0
80101222:	e8 b9 2c 00 00       	call   80103ee0 <release>
  return ip;
80101227:	83 c4 10             	add    $0x10,%esp
}
8010122a:	89 f0                	mov    %esi,%eax
8010122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122f:	5b                   	pop    %ebx
80101230:	5e                   	pop    %esi
80101231:	5f                   	pop    %edi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("iget: no inodes");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 88 6b 10 80       	push   $0x80106b88
8010123c:	e8 14 f1 ff ff       	call   80100355 <panic>

80101241 <readsb>:
{
80101241:	f3 0f 1e fb          	endbr32 
80101245:	55                   	push   %ebp
80101246:	89 e5                	mov    %esp,%ebp
80101248:	53                   	push   %ebx
80101249:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010124c:	6a 01                	push   $0x1
8010124e:	ff 75 08             	pushl  0x8(%ebp)
80101251:	e8 18 ef ff ff       	call   8010016e <bread>
80101256:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101258:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125b:	83 c4 0c             	add    $0xc,%esp
8010125e:	6a 1c                	push   $0x1c
80101260:	50                   	push   %eax
80101261:	ff 75 0c             	pushl  0xc(%ebp)
80101264:	e8 40 2d 00 00       	call   80103fa9 <memmove>
  brelse(bp);
80101269:	89 1c 24             	mov    %ebx,(%esp)
8010126c:	e8 6e ef ff ff       	call   801001df <brelse>
}
80101271:	83 c4 10             	add    $0x10,%esp
80101274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101277:	c9                   	leave  
80101278:	c3                   	ret    

80101279 <bfree>:
{
80101279:	55                   	push   %ebp
8010127a:	89 e5                	mov    %esp,%ebp
8010127c:	57                   	push   %edi
8010127d:	56                   	push   %esi
8010127e:	53                   	push   %ebx
8010127f:	83 ec 14             	sub    $0x14,%esp
80101282:	89 c3                	mov    %eax,%ebx
80101284:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101286:	68 c0 09 11 80       	push   $0x801109c0
8010128b:	50                   	push   %eax
8010128c:	e8 b0 ff ff ff       	call   80101241 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101291:	89 f0                	mov    %esi,%eax
80101293:	c1 e8 0c             	shr    $0xc,%eax
80101296:	83 c4 08             	add    $0x8,%esp
80101299:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010129f:	50                   	push   %eax
801012a0:	53                   	push   %ebx
801012a1:	e8 c8 ee ff ff       	call   8010016e <bread>
801012a6:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
801012a8:	89 f7                	mov    %esi,%edi
801012aa:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
801012b0:	89 f1                	mov    %esi,%ecx
801012b2:	83 e1 07             	and    $0x7,%ecx
801012b5:	b8 01 00 00 00       	mov    $0x1,%eax
801012ba:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012bc:	83 c4 10             	add    $0x10,%esp
801012bf:	c1 ff 03             	sar    $0x3,%edi
801012c2:	8a 54 3b 5c          	mov    0x5c(%ebx,%edi,1),%dl
801012c6:	0f b6 ca             	movzbl %dl,%ecx
801012c9:	85 c1                	test   %eax,%ecx
801012cb:	74 24                	je     801012f1 <bfree+0x78>
  bp->data[bi/8] &= ~m;
801012cd:	f7 d0                	not    %eax
801012cf:	21 d0                	and    %edx,%eax
801012d1:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
801012d5:	83 ec 0c             	sub    $0xc,%esp
801012d8:	53                   	push   %ebx
801012d9:	e8 36 16 00 00       	call   80102914 <log_write>
  brelse(bp);
801012de:	89 1c 24             	mov    %ebx,(%esp)
801012e1:	e8 f9 ee ff ff       	call   801001df <brelse>
}
801012e6:	83 c4 10             	add    $0x10,%esp
801012e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ec:	5b                   	pop    %ebx
801012ed:	5e                   	pop    %esi
801012ee:	5f                   	pop    %edi
801012ef:	5d                   	pop    %ebp
801012f0:	c3                   	ret    
    panic("freeing free block");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 98 6b 10 80       	push   $0x80106b98
801012f9:	e8 57 f0 ff ff       	call   80100355 <panic>

801012fe <iinit>:
{
801012fe:	f3 0f 1e fb          	endbr32 
80101302:	55                   	push   %ebp
80101303:	89 e5                	mov    %esp,%ebp
80101305:	53                   	push   %ebx
80101306:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101309:	68 ab 6b 10 80       	push   $0x80106bab
8010130e:	68 e0 09 11 80       	push   $0x801109e0
80101313:	e8 14 2a 00 00       	call   80103d2c <initlock>
  for(i = 0; i < NINODE; i++) {
80101318:	83 c4 10             	add    $0x10,%esp
8010131b:	bb 00 00 00 00       	mov    $0x0,%ebx
80101320:	83 fb 31             	cmp    $0x31,%ebx
80101323:	7f 21                	jg     80101346 <iinit+0x48>
    initsleeplock(&icache.inode[i].lock, "inode");
80101325:	83 ec 08             	sub    $0x8,%esp
80101328:	68 b2 6b 10 80       	push   $0x80106bb2
8010132d:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101330:	89 d0                	mov    %edx,%eax
80101332:	c1 e0 04             	shl    $0x4,%eax
80101335:	05 20 0a 11 80       	add    $0x80110a20,%eax
8010133a:	50                   	push   %eax
8010133b:	e8 d1 28 00 00       	call   80103c11 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101340:	43                   	inc    %ebx
80101341:	83 c4 10             	add    $0x10,%esp
80101344:	eb da                	jmp    80101320 <iinit+0x22>
  readsb(dev, &sb);
80101346:	83 ec 08             	sub    $0x8,%esp
80101349:	68 c0 09 11 80       	push   $0x801109c0
8010134e:	ff 75 08             	pushl  0x8(%ebp)
80101351:	e8 eb fe ff ff       	call   80101241 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101356:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010135c:	ff 35 d4 09 11 80    	pushl  0x801109d4
80101362:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101368:	ff 35 cc 09 11 80    	pushl  0x801109cc
8010136e:	ff 35 c8 09 11 80    	pushl  0x801109c8
80101374:	ff 35 c4 09 11 80    	pushl  0x801109c4
8010137a:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101380:	68 18 6c 10 80       	push   $0x80106c18
80101385:	e8 73 f2 ff ff       	call   801005fd <cprintf>
}
8010138a:	83 c4 30             	add    $0x30,%esp
8010138d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101390:	c9                   	leave  
80101391:	c3                   	ret    

80101392 <ialloc>:
{
80101392:	f3 0f 1e fb          	endbr32 
80101396:	55                   	push   %ebp
80101397:	89 e5                	mov    %esp,%ebp
80101399:	57                   	push   %edi
8010139a:	56                   	push   %esi
8010139b:	53                   	push   %ebx
8010139c:	83 ec 1c             	sub    $0x1c,%esp
8010139f:	8b 45 0c             	mov    0xc(%ebp),%eax
801013a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013a5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013aa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013ad:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013b3:	76 73                	jbe    80101428 <ialloc+0x96>
    bp = bread(dev, IBLOCK(inum, sb));
801013b5:	89 d8                	mov    %ebx,%eax
801013b7:	c1 e8 03             	shr    $0x3,%eax
801013ba:	83 ec 08             	sub    $0x8,%esp
801013bd:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013c3:	50                   	push   %eax
801013c4:	ff 75 08             	pushl  0x8(%ebp)
801013c7:	e8 a2 ed ff ff       	call   8010016e <bread>
801013cc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013ce:	89 d8                	mov    %ebx,%eax
801013d0:	83 e0 07             	and    $0x7,%eax
801013d3:	c1 e0 06             	shl    $0x6,%eax
801013d6:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013e1:	74 0f                	je     801013f2 <ialloc+0x60>
    brelse(bp);
801013e3:	83 ec 0c             	sub    $0xc,%esp
801013e6:	56                   	push   %esi
801013e7:	e8 f3 ed ff ff       	call   801001df <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013ec:	43                   	inc    %ebx
801013ed:	83 c4 10             	add    $0x10,%esp
801013f0:	eb b8                	jmp    801013aa <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
801013f2:	83 ec 04             	sub    $0x4,%esp
801013f5:	6a 40                	push   $0x40
801013f7:	6a 00                	push   $0x0
801013f9:	57                   	push   %edi
801013fa:	e8 2c 2b 00 00       	call   80103f2b <memset>
      dip->type = type;
801013ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101402:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101405:	89 34 24             	mov    %esi,(%esp)
80101408:	e8 07 15 00 00       	call   80102914 <log_write>
      brelse(bp);
8010140d:	89 34 24             	mov    %esi,(%esp)
80101410:	e8 ca ed ff ff       	call   801001df <brelse>
      return iget(dev, inum);
80101415:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101418:	8b 45 08             	mov    0x8(%ebp),%eax
8010141b:	e8 74 fd ff ff       	call   80101194 <iget>
}
80101420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101423:	5b                   	pop    %ebx
80101424:	5e                   	pop    %esi
80101425:	5f                   	pop    %edi
80101426:	5d                   	pop    %ebp
80101427:	c3                   	ret    
  panic("ialloc: no inodes");
80101428:	83 ec 0c             	sub    $0xc,%esp
8010142b:	68 b8 6b 10 80       	push   $0x80106bb8
80101430:	e8 20 ef ff ff       	call   80100355 <panic>

80101435 <iupdate>:
{
80101435:	f3 0f 1e fb          	endbr32 
80101439:	55                   	push   %ebp
8010143a:	89 e5                	mov    %esp,%ebp
8010143c:	56                   	push   %esi
8010143d:	53                   	push   %ebx
8010143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101441:	8b 43 04             	mov    0x4(%ebx),%eax
80101444:	c1 e8 03             	shr    $0x3,%eax
80101447:	83 ec 08             	sub    $0x8,%esp
8010144a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101450:	50                   	push   %eax
80101451:	ff 33                	pushl  (%ebx)
80101453:	e8 16 ed ff ff       	call   8010016e <bread>
80101458:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010145a:	8b 43 04             	mov    0x4(%ebx),%eax
8010145d:	83 e0 07             	and    $0x7,%eax
80101460:	c1 e0 06             	shl    $0x6,%eax
80101463:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101467:	8b 53 50             	mov    0x50(%ebx),%edx
8010146a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010146d:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101471:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101475:	8b 53 54             	mov    0x54(%ebx),%edx
80101478:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010147c:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101480:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101484:	8b 53 58             	mov    0x58(%ebx),%edx
80101487:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010148a:	83 c3 5c             	add    $0x5c,%ebx
8010148d:	83 c0 0c             	add    $0xc,%eax
80101490:	83 c4 0c             	add    $0xc,%esp
80101493:	6a 34                	push   $0x34
80101495:	53                   	push   %ebx
80101496:	50                   	push   %eax
80101497:	e8 0d 2b 00 00       	call   80103fa9 <memmove>
  log_write(bp);
8010149c:	89 34 24             	mov    %esi,(%esp)
8010149f:	e8 70 14 00 00       	call   80102914 <log_write>
  brelse(bp);
801014a4:	89 34 24             	mov    %esi,(%esp)
801014a7:	e8 33 ed ff ff       	call   801001df <brelse>
}
801014ac:	83 c4 10             	add    $0x10,%esp
801014af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b2:	5b                   	pop    %ebx
801014b3:	5e                   	pop    %esi
801014b4:	5d                   	pop    %ebp
801014b5:	c3                   	ret    

801014b6 <itrunc>:
{
801014b6:	55                   	push   %ebp
801014b7:	89 e5                	mov    %esp,%ebp
801014b9:	57                   	push   %edi
801014ba:	56                   	push   %esi
801014bb:	53                   	push   %ebx
801014bc:	83 ec 1c             	sub    $0x1c,%esp
801014bf:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014c1:	bb 00 00 00 00       	mov    $0x0,%ebx
801014c6:	eb 01                	jmp    801014c9 <itrunc+0x13>
801014c8:	43                   	inc    %ebx
801014c9:	83 fb 0b             	cmp    $0xb,%ebx
801014cc:	7f 19                	jg     801014e7 <itrunc+0x31>
    if(ip->addrs[i]){
801014ce:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014d2:	85 d2                	test   %edx,%edx
801014d4:	74 f2                	je     801014c8 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014d6:	8b 06                	mov    (%esi),%eax
801014d8:	e8 9c fd ff ff       	call   80101279 <bfree>
      ip->addrs[i] = 0;
801014dd:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014e4:	00 
801014e5:	eb e1                	jmp    801014c8 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014e7:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014ed:	85 c0                	test   %eax,%eax
801014ef:	75 1b                	jne    8010150c <itrunc+0x56>
  ip->size = 0;
801014f1:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	56                   	push   %esi
801014fc:	e8 34 ff ff ff       	call   80101435 <iupdate>
}
80101501:	83 c4 10             	add    $0x10,%esp
80101504:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101507:	5b                   	pop    %ebx
80101508:	5e                   	pop    %esi
80101509:	5f                   	pop    %edi
8010150a:	5d                   	pop    %ebp
8010150b:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	50                   	push   %eax
80101510:	ff 36                	pushl  (%esi)
80101512:	e8 57 ec ff ff       	call   8010016e <bread>
80101517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010151a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	bb 00 00 00 00       	mov    $0x0,%ebx
80101525:	eb 08                	jmp    8010152f <itrunc+0x79>
        bfree(ip->dev, a[j]);
80101527:	8b 06                	mov    (%esi),%eax
80101529:	e8 4b fd ff ff       	call   80101279 <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010152e:	43                   	inc    %ebx
8010152f:	83 fb 7f             	cmp    $0x7f,%ebx
80101532:	77 09                	ja     8010153d <itrunc+0x87>
      if(a[j])
80101534:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101537:	85 d2                	test   %edx,%edx
80101539:	74 f3                	je     8010152e <itrunc+0x78>
8010153b:	eb ea                	jmp    80101527 <itrunc+0x71>
    brelse(bp);
8010153d:	83 ec 0c             	sub    $0xc,%esp
80101540:	ff 75 e4             	pushl  -0x1c(%ebp)
80101543:	e8 97 ec ff ff       	call   801001df <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101548:	8b 06                	mov    (%esi),%eax
8010154a:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101550:	e8 24 fd ff ff       	call   80101279 <bfree>
    ip->addrs[NDIRECT] = 0;
80101555:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010155c:	00 00 00 
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	eb 8d                	jmp    801014f1 <itrunc+0x3b>

80101564 <idup>:
{
80101564:	f3 0f 1e fb          	endbr32 
80101568:	55                   	push   %ebp
80101569:	89 e5                	mov    %esp,%ebp
8010156b:	53                   	push   %ebx
8010156c:	83 ec 10             	sub    $0x10,%esp
8010156f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101572:	68 e0 09 11 80       	push   $0x801109e0
80101577:	e8 fb 28 00 00       	call   80103e77 <acquire>
  ip->ref++;
8010157c:	8b 43 08             	mov    0x8(%ebx),%eax
8010157f:	40                   	inc    %eax
80101580:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101583:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010158a:	e8 51 29 00 00       	call   80103ee0 <release>
}
8010158f:	89 d8                	mov    %ebx,%eax
80101591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101594:	c9                   	leave  
80101595:	c3                   	ret    

80101596 <ilock>:
{
80101596:	f3 0f 1e fb          	endbr32 
8010159a:	55                   	push   %ebp
8010159b:	89 e5                	mov    %esp,%ebp
8010159d:	56                   	push   %esi
8010159e:	53                   	push   %ebx
8010159f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015a2:	85 db                	test   %ebx,%ebx
801015a4:	74 22                	je     801015c8 <ilock+0x32>
801015a6:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015aa:	7e 1c                	jle    801015c8 <ilock+0x32>
  acquiresleep(&ip->lock);
801015ac:	83 ec 0c             	sub    $0xc,%esp
801015af:	8d 43 0c             	lea    0xc(%ebx),%eax
801015b2:	50                   	push   %eax
801015b3:	e8 90 26 00 00       	call   80103c48 <acquiresleep>
  if(ip->valid == 0){
801015b8:	83 c4 10             	add    $0x10,%esp
801015bb:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015bf:	74 14                	je     801015d5 <ilock+0x3f>
}
801015c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c4:	5b                   	pop    %ebx
801015c5:	5e                   	pop    %esi
801015c6:	5d                   	pop    %ebp
801015c7:	c3                   	ret    
    panic("ilock");
801015c8:	83 ec 0c             	sub    $0xc,%esp
801015cb:	68 ca 6b 10 80       	push   $0x80106bca
801015d0:	e8 80 ed ff ff       	call   80100355 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d5:	8b 43 04             	mov    0x4(%ebx),%eax
801015d8:	c1 e8 03             	shr    $0x3,%eax
801015db:	83 ec 08             	sub    $0x8,%esp
801015de:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015e4:	50                   	push   %eax
801015e5:	ff 33                	pushl  (%ebx)
801015e7:	e8 82 eb ff ff       	call   8010016e <bread>
801015ec:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ee:	8b 43 04             	mov    0x4(%ebx),%eax
801015f1:	83 e0 07             	and    $0x7,%eax
801015f4:	c1 e0 06             	shl    $0x6,%eax
801015f7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015fb:	8b 10                	mov    (%eax),%edx
801015fd:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101601:	66 8b 50 02          	mov    0x2(%eax),%dx
80101605:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101609:	8b 50 04             	mov    0x4(%eax),%edx
8010160c:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101610:	66 8b 50 06          	mov    0x6(%eax),%dx
80101614:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101618:	8b 50 08             	mov    0x8(%eax),%edx
8010161b:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010161e:	83 c0 0c             	add    $0xc,%eax
80101621:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101624:	83 c4 0c             	add    $0xc,%esp
80101627:	6a 34                	push   $0x34
80101629:	50                   	push   %eax
8010162a:	52                   	push   %edx
8010162b:	e8 79 29 00 00       	call   80103fa9 <memmove>
    brelse(bp);
80101630:	89 34 24             	mov    %esi,(%esp)
80101633:	e8 a7 eb ff ff       	call   801001df <brelse>
    ip->valid = 1;
80101638:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010163f:	83 c4 10             	add    $0x10,%esp
80101642:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101647:	0f 85 74 ff ff ff    	jne    801015c1 <ilock+0x2b>
      panic("ilock: no type");
8010164d:	83 ec 0c             	sub    $0xc,%esp
80101650:	68 d0 6b 10 80       	push   $0x80106bd0
80101655:	e8 fb ec ff ff       	call   80100355 <panic>

8010165a <iunlock>:
{
8010165a:	f3 0f 1e fb          	endbr32 
8010165e:	55                   	push   %ebp
8010165f:	89 e5                	mov    %esp,%ebp
80101661:	56                   	push   %esi
80101662:	53                   	push   %ebx
80101663:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101666:	85 db                	test   %ebx,%ebx
80101668:	74 2c                	je     80101696 <iunlock+0x3c>
8010166a:	8d 73 0c             	lea    0xc(%ebx),%esi
8010166d:	83 ec 0c             	sub    $0xc,%esp
80101670:	56                   	push   %esi
80101671:	e8 64 26 00 00       	call   80103cda <holdingsleep>
80101676:	83 c4 10             	add    $0x10,%esp
80101679:	85 c0                	test   %eax,%eax
8010167b:	74 19                	je     80101696 <iunlock+0x3c>
8010167d:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101681:	7e 13                	jle    80101696 <iunlock+0x3c>
  releasesleep(&ip->lock);
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	56                   	push   %esi
80101687:	e8 0f 26 00 00       	call   80103c9b <releasesleep>
}
8010168c:	83 c4 10             	add    $0x10,%esp
8010168f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101692:	5b                   	pop    %ebx
80101693:	5e                   	pop    %esi
80101694:	5d                   	pop    %ebp
80101695:	c3                   	ret    
    panic("iunlock");
80101696:	83 ec 0c             	sub    $0xc,%esp
80101699:	68 df 6b 10 80       	push   $0x80106bdf
8010169e:	e8 b2 ec ff ff       	call   80100355 <panic>

801016a3 <iput>:
{
801016a3:	f3 0f 1e fb          	endbr32 
801016a7:	55                   	push   %ebp
801016a8:	89 e5                	mov    %esp,%ebp
801016aa:	57                   	push   %edi
801016ab:	56                   	push   %esi
801016ac:	53                   	push   %ebx
801016ad:	83 ec 18             	sub    $0x18,%esp
801016b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016b3:	8d 73 0c             	lea    0xc(%ebx),%esi
801016b6:	56                   	push   %esi
801016b7:	e8 8c 25 00 00       	call   80103c48 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016c3:	74 07                	je     801016cc <iput+0x29>
801016c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016ca:	74 33                	je     801016ff <iput+0x5c>
  releasesleep(&ip->lock);
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	56                   	push   %esi
801016d0:	e8 c6 25 00 00       	call   80103c9b <releasesleep>
  acquire(&icache.lock);
801016d5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016dc:	e8 96 27 00 00       	call   80103e77 <acquire>
  ip->ref--;
801016e1:	8b 43 08             	mov    0x8(%ebx),%eax
801016e4:	48                   	dec    %eax
801016e5:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016e8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016ef:	e8 ec 27 00 00       	call   80103ee0 <release>
}
801016f4:	83 c4 10             	add    $0x10,%esp
801016f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fa:	5b                   	pop    %ebx
801016fb:	5e                   	pop    %esi
801016fc:	5f                   	pop    %edi
801016fd:	5d                   	pop    %ebp
801016fe:	c3                   	ret    
    acquire(&icache.lock);
801016ff:	83 ec 0c             	sub    $0xc,%esp
80101702:	68 e0 09 11 80       	push   $0x801109e0
80101707:	e8 6b 27 00 00       	call   80103e77 <acquire>
    int r = ip->ref;
8010170c:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
8010170f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101716:	e8 c5 27 00 00       	call   80103ee0 <release>
    if(r == 1){
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	83 ff 01             	cmp    $0x1,%edi
80101721:	75 a9                	jne    801016cc <iput+0x29>
      itrunc(ip);
80101723:	89 d8                	mov    %ebx,%eax
80101725:	e8 8c fd ff ff       	call   801014b6 <itrunc>
      ip->type = 0;
8010172a:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	53                   	push   %ebx
80101734:	e8 fc fc ff ff       	call   80101435 <iupdate>
      ip->valid = 0;
80101739:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101740:	83 c4 10             	add    $0x10,%esp
80101743:	eb 87                	jmp    801016cc <iput+0x29>

80101745 <iunlockput>:
{
80101745:	f3 0f 1e fb          	endbr32 
80101749:	55                   	push   %ebp
8010174a:	89 e5                	mov    %esp,%ebp
8010174c:	53                   	push   %ebx
8010174d:	83 ec 10             	sub    $0x10,%esp
80101750:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101753:	53                   	push   %ebx
80101754:	e8 01 ff ff ff       	call   8010165a <iunlock>
  iput(ip);
80101759:	89 1c 24             	mov    %ebx,(%esp)
8010175c:	e8 42 ff ff ff       	call   801016a3 <iput>
}
80101761:	83 c4 10             	add    $0x10,%esp
80101764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101767:	c9                   	leave  
80101768:	c3                   	ret    

80101769 <stati>:
{
80101769:	f3 0f 1e fb          	endbr32 
8010176d:	55                   	push   %ebp
8010176e:	89 e5                	mov    %esp,%ebp
80101770:	8b 55 08             	mov    0x8(%ebp),%edx
80101773:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101776:	8b 0a                	mov    (%edx),%ecx
80101778:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010177b:	8b 4a 04             	mov    0x4(%edx),%ecx
8010177e:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101781:	8b 4a 50             	mov    0x50(%edx),%ecx
80101784:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101787:	66 8b 4a 56          	mov    0x56(%edx),%cx
8010178b:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010178f:	8b 52 58             	mov    0x58(%edx),%edx
80101792:	89 50 10             	mov    %edx,0x10(%eax)
}
80101795:	5d                   	pop    %ebp
80101796:	c3                   	ret    

80101797 <readi>:
{
80101797:	f3 0f 1e fb          	endbr32 
8010179b:	55                   	push   %ebp
8010179c:	89 e5                	mov    %esp,%ebp
8010179e:	57                   	push   %edi
8010179f:	56                   	push   %esi
801017a0:	53                   	push   %ebx
801017a1:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801017a4:	8b 45 08             	mov    0x8(%ebp),%eax
801017a7:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017ac:	74 2c                	je     801017da <readi+0x43>
  if(off > ip->size || off + n < off)
801017ae:	8b 45 08             	mov    0x8(%ebp),%eax
801017b1:	8b 40 58             	mov    0x58(%eax),%eax
801017b4:	3b 45 10             	cmp    0x10(%ebp),%eax
801017b7:	0f 82 d0 00 00 00    	jb     8010188d <readi+0xf6>
801017bd:	8b 55 10             	mov    0x10(%ebp),%edx
801017c0:	03 55 14             	add    0x14(%ebp),%edx
801017c3:	0f 82 cb 00 00 00    	jb     80101894 <readi+0xfd>
  if(off + n > ip->size)
801017c9:	39 d0                	cmp    %edx,%eax
801017cb:	73 06                	jae    801017d3 <readi+0x3c>
    n = ip->size - off;
801017cd:	2b 45 10             	sub    0x10(%ebp),%eax
801017d0:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017d3:	bf 00 00 00 00       	mov    $0x0,%edi
801017d8:	eb 55                	jmp    8010182f <readi+0x98>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017da:	66 8b 40 52          	mov    0x52(%eax),%ax
801017de:	66 83 f8 09          	cmp    $0x9,%ax
801017e2:	0f 87 97 00 00 00    	ja     8010187f <readi+0xe8>
801017e8:	98                   	cwtl   
801017e9:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801017f0:	85 c0                	test   %eax,%eax
801017f2:	0f 84 8e 00 00 00    	je     80101886 <readi+0xef>
    return devsw[ip->major].read(ip, dst, n);
801017f8:	83 ec 04             	sub    $0x4,%esp
801017fb:	ff 75 14             	pushl  0x14(%ebp)
801017fe:	ff 75 0c             	pushl  0xc(%ebp)
80101801:	ff 75 08             	pushl  0x8(%ebp)
80101804:	ff d0                	call   *%eax
80101806:	83 c4 10             	add    $0x10,%esp
80101809:	eb 6c                	jmp    80101877 <readi+0xe0>
    memmove(dst, bp->data + off%BSIZE, m);
8010180b:	83 ec 04             	sub    $0x4,%esp
8010180e:	53                   	push   %ebx
8010180f:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
80101813:	50                   	push   %eax
80101814:	ff 75 0c             	pushl  0xc(%ebp)
80101817:	e8 8d 27 00 00       	call   80103fa9 <memmove>
    brelse(bp);
8010181c:	89 34 24             	mov    %esi,(%esp)
8010181f:	e8 bb e9 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101824:	01 df                	add    %ebx,%edi
80101826:	01 5d 10             	add    %ebx,0x10(%ebp)
80101829:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010182c:	83 c4 10             	add    $0x10,%esp
8010182f:	39 7d 14             	cmp    %edi,0x14(%ebp)
80101832:	76 40                	jbe    80101874 <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101834:	8b 55 10             	mov    0x10(%ebp),%edx
80101837:	c1 ea 09             	shr    $0x9,%edx
8010183a:	8b 45 08             	mov    0x8(%ebp),%eax
8010183d:	e8 ac f8 ff ff       	call   801010ee <bmap>
80101842:	83 ec 08             	sub    $0x8,%esp
80101845:	50                   	push   %eax
80101846:	8b 45 08             	mov    0x8(%ebp),%eax
80101849:	ff 30                	pushl  (%eax)
8010184b:	e8 1e e9 ff ff       	call   8010016e <bread>
80101850:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101852:	8b 55 10             	mov    0x10(%ebp),%edx
80101855:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010185b:	b8 00 02 00 00       	mov    $0x200,%eax
80101860:	29 d0                	sub    %edx,%eax
80101862:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101865:	29 f9                	sub    %edi,%ecx
80101867:	89 c3                	mov    %eax,%ebx
80101869:	83 c4 10             	add    $0x10,%esp
8010186c:	39 c8                	cmp    %ecx,%eax
8010186e:	76 9b                	jbe    8010180b <readi+0x74>
80101870:	89 cb                	mov    %ecx,%ebx
80101872:	eb 97                	jmp    8010180b <readi+0x74>
  return n;
80101874:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101877:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010187a:	5b                   	pop    %ebx
8010187b:	5e                   	pop    %esi
8010187c:	5f                   	pop    %edi
8010187d:	5d                   	pop    %ebp
8010187e:	c3                   	ret    
      return -1;
8010187f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101884:	eb f1                	jmp    80101877 <readi+0xe0>
80101886:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010188b:	eb ea                	jmp    80101877 <readi+0xe0>
    return -1;
8010188d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101892:	eb e3                	jmp    80101877 <readi+0xe0>
80101894:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101899:	eb dc                	jmp    80101877 <readi+0xe0>

8010189b <writei>:
{
8010189b:	f3 0f 1e fb          	endbr32 
8010189f:	55                   	push   %ebp
801018a0:	89 e5                	mov    %esp,%ebp
801018a2:	57                   	push   %edi
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
801018a8:	8b 45 08             	mov    0x8(%ebp),%eax
801018ab:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018b0:	74 2c                	je     801018de <writei+0x43>
  if(off > ip->size || off + n < off)
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
801018b5:	8b 7d 10             	mov    0x10(%ebp),%edi
801018b8:	39 78 58             	cmp    %edi,0x58(%eax)
801018bb:	0f 82 fd 00 00 00    	jb     801019be <writei+0x123>
801018c1:	89 f8                	mov    %edi,%eax
801018c3:	03 45 14             	add    0x14(%ebp),%eax
801018c6:	0f 82 f9 00 00 00    	jb     801019c5 <writei+0x12a>
  if(off + n > MAXFILE*BSIZE)
801018cc:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018d1:	0f 87 f5 00 00 00    	ja     801019cc <writei+0x131>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018d7:	bf 00 00 00 00       	mov    $0x0,%edi
801018dc:	eb 60                	jmp    8010193e <writei+0xa3>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018de:	66 8b 40 52          	mov    0x52(%eax),%ax
801018e2:	66 83 f8 09          	cmp    $0x9,%ax
801018e6:	0f 87 c4 00 00 00    	ja     801019b0 <writei+0x115>
801018ec:	98                   	cwtl   
801018ed:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801018f4:	85 c0                	test   %eax,%eax
801018f6:	0f 84 bb 00 00 00    	je     801019b7 <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801018fc:	83 ec 04             	sub    $0x4,%esp
801018ff:	ff 75 14             	pushl  0x14(%ebp)
80101902:	ff 75 0c             	pushl  0xc(%ebp)
80101905:	ff 75 08             	pushl  0x8(%ebp)
80101908:	ff d0                	call   *%eax
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	e9 85 00 00 00       	jmp    80101997 <writei+0xfc>
    memmove(bp->data + off%BSIZE, src, m);
80101912:	83 ec 04             	sub    $0x4,%esp
80101915:	56                   	push   %esi
80101916:	ff 75 0c             	pushl  0xc(%ebp)
80101919:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
8010191d:	50                   	push   %eax
8010191e:	e8 86 26 00 00       	call   80103fa9 <memmove>
    log_write(bp);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 e9 0f 00 00       	call   80102914 <log_write>
    brelse(bp);
8010192b:	89 1c 24             	mov    %ebx,(%esp)
8010192e:	e8 ac e8 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101933:	01 f7                	add    %esi,%edi
80101935:	01 75 10             	add    %esi,0x10(%ebp)
80101938:	01 75 0c             	add    %esi,0xc(%ebp)
8010193b:	83 c4 10             	add    $0x10,%esp
8010193e:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101941:	73 40                	jae    80101983 <writei+0xe8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101943:	8b 55 10             	mov    0x10(%ebp),%edx
80101946:	c1 ea 09             	shr    $0x9,%edx
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	e8 9d f7 ff ff       	call   801010ee <bmap>
80101951:	83 ec 08             	sub    $0x8,%esp
80101954:	50                   	push   %eax
80101955:	8b 45 08             	mov    0x8(%ebp),%eax
80101958:	ff 30                	pushl  (%eax)
8010195a:	e8 0f e8 ff ff       	call   8010016e <bread>
8010195f:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
80101961:	8b 55 10             	mov    0x10(%ebp),%edx
80101964:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010196a:	b8 00 02 00 00       	mov    $0x200,%eax
8010196f:	29 d0                	sub    %edx,%eax
80101971:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101974:	29 f9                	sub    %edi,%ecx
80101976:	89 c6                	mov    %eax,%esi
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	39 c8                	cmp    %ecx,%eax
8010197d:	76 93                	jbe    80101912 <writei+0x77>
8010197f:	89 ce                	mov    %ecx,%esi
80101981:	eb 8f                	jmp    80101912 <writei+0x77>
  if(n > 0 && off > ip->size){
80101983:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101987:	74 0b                	je     80101994 <writei+0xf9>
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010198f:	39 78 58             	cmp    %edi,0x58(%eax)
80101992:	72 0b                	jb     8010199f <writei+0x104>
  return n;
80101994:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101997:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010199a:	5b                   	pop    %ebx
8010199b:	5e                   	pop    %esi
8010199c:	5f                   	pop    %edi
8010199d:	5d                   	pop    %ebp
8010199e:	c3                   	ret    
    ip->size = off;
8010199f:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801019a2:	83 ec 0c             	sub    $0xc,%esp
801019a5:	50                   	push   %eax
801019a6:	e8 8a fa ff ff       	call   80101435 <iupdate>
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	eb e4                	jmp    80101994 <writei+0xf9>
      return -1;
801019b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b5:	eb e0                	jmp    80101997 <writei+0xfc>
801019b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019bc:	eb d9                	jmp    80101997 <writei+0xfc>
    return -1;
801019be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019c3:	eb d2                	jmp    80101997 <writei+0xfc>
801019c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ca:	eb cb                	jmp    80101997 <writei+0xfc>
    return -1;
801019cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019d1:	eb c4                	jmp    80101997 <writei+0xfc>

801019d3 <namecmp>:
{
801019d3:	f3 0f 1e fb          	endbr32 
801019d7:	55                   	push   %ebp
801019d8:	89 e5                	mov    %esp,%ebp
801019da:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019dd:	6a 0e                	push   $0xe
801019df:	ff 75 0c             	pushl  0xc(%ebp)
801019e2:	ff 75 08             	pushl  0x8(%ebp)
801019e5:	e8 2b 26 00 00       	call   80104015 <strncmp>
}
801019ea:	c9                   	leave  
801019eb:	c3                   	ret    

801019ec <dirlookup>:
{
801019ec:	f3 0f 1e fb          	endbr32 
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 75 08             	mov    0x8(%ebp),%esi
801019fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019ff:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a04:	75 07                	jne    80101a0d <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a06:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a0b:	eb 1d                	jmp    80101a2a <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101a0d:	83 ec 0c             	sub    $0xc,%esp
80101a10:	68 e7 6b 10 80       	push   $0x80106be7
80101a15:	e8 3b e9 ff ff       	call   80100355 <panic>
      panic("dirlookup read");
80101a1a:	83 ec 0c             	sub    $0xc,%esp
80101a1d:	68 f9 6b 10 80       	push   $0x80106bf9
80101a22:	e8 2e e9 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a27:	83 c3 10             	add    $0x10,%ebx
80101a2a:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a2d:	76 48                	jbe    80101a77 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a2f:	6a 10                	push   $0x10
80101a31:	53                   	push   %ebx
80101a32:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a35:	50                   	push   %eax
80101a36:	56                   	push   %esi
80101a37:	e8 5b fd ff ff       	call   80101797 <readi>
80101a3c:	83 c4 10             	add    $0x10,%esp
80101a3f:	83 f8 10             	cmp    $0x10,%eax
80101a42:	75 d6                	jne    80101a1a <dirlookup+0x2e>
    if(de.inum == 0)
80101a44:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a49:	74 dc                	je     80101a27 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a4b:	83 ec 08             	sub    $0x8,%esp
80101a4e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a51:	50                   	push   %eax
80101a52:	57                   	push   %edi
80101a53:	e8 7b ff ff ff       	call   801019d3 <namecmp>
80101a58:	83 c4 10             	add    $0x10,%esp
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	75 c8                	jne    80101a27 <dirlookup+0x3b>
      if(poff)
80101a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a63:	74 05                	je     80101a6a <dirlookup+0x7e>
        *poff = off;
80101a65:	8b 45 10             	mov    0x10(%ebp),%eax
80101a68:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a6a:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a6e:	8b 06                	mov    (%esi),%eax
80101a70:	e8 1f f7 ff ff       	call   80101194 <iget>
80101a75:	eb 05                	jmp    80101a7c <dirlookup+0x90>
  return 0;
80101a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7f:	5b                   	pop    %ebx
80101a80:	5e                   	pop    %esi
80101a81:	5f                   	pop    %edi
80101a82:	5d                   	pop    %ebp
80101a83:	c3                   	ret    

80101a84 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	57                   	push   %edi
80101a88:	56                   	push   %esi
80101a89:	53                   	push   %ebx
80101a8a:	83 ec 1c             	sub    $0x1c,%esp
80101a8d:	89 c3                	mov    %eax,%ebx
80101a8f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a95:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a98:	74 17                	je     80101ab1 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a9a:	e8 ac 17 00 00       	call   8010324b <myproc>
80101a9f:	83 ec 0c             	sub    $0xc,%esp
80101aa2:	ff 70 68             	pushl  0x68(%eax)
80101aa5:	e8 ba fa ff ff       	call   80101564 <idup>
80101aaa:	89 c6                	mov    %eax,%esi
80101aac:	83 c4 10             	add    $0x10,%esp
80101aaf:	eb 53                	jmp    80101b04 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101ab1:	ba 01 00 00 00       	mov    $0x1,%edx
80101ab6:	b8 01 00 00 00       	mov    $0x1,%eax
80101abb:	e8 d4 f6 ff ff       	call   80101194 <iget>
80101ac0:	89 c6                	mov    %eax,%esi
80101ac2:	eb 40                	jmp    80101b04 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101ac4:	83 ec 0c             	sub    $0xc,%esp
80101ac7:	56                   	push   %esi
80101ac8:	e8 78 fc ff ff       	call   80101745 <iunlockput>
      return 0;
80101acd:	83 c4 10             	add    $0x10,%esp
80101ad0:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ada:	5b                   	pop    %ebx
80101adb:	5e                   	pop    %esi
80101adc:	5f                   	pop    %edi
80101add:	5d                   	pop    %ebp
80101ade:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101adf:	83 ec 04             	sub    $0x4,%esp
80101ae2:	6a 00                	push   $0x0
80101ae4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ae7:	56                   	push   %esi
80101ae8:	e8 ff fe ff ff       	call   801019ec <dirlookup>
80101aed:	89 c7                	mov    %eax,%edi
80101aef:	83 c4 10             	add    $0x10,%esp
80101af2:	85 c0                	test   %eax,%eax
80101af4:	74 4a                	je     80101b40 <namex+0xbc>
    iunlockput(ip);
80101af6:	83 ec 0c             	sub    $0xc,%esp
80101af9:	56                   	push   %esi
80101afa:	e8 46 fc ff ff       	call   80101745 <iunlockput>
80101aff:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b02:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b07:	89 d8                	mov    %ebx,%eax
80101b09:	e8 46 f4 ff ff       	call   80100f54 <skipelem>
80101b0e:	89 c3                	mov    %eax,%ebx
80101b10:	85 c0                	test   %eax,%eax
80101b12:	74 3c                	je     80101b50 <namex+0xcc>
    ilock(ip);
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	56                   	push   %esi
80101b18:	e8 79 fa ff ff       	call   80101596 <ilock>
    if(ip->type != T_DIR){
80101b1d:	83 c4 10             	add    $0x10,%esp
80101b20:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b25:	75 9d                	jne    80101ac4 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b27:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b2b:	74 b2                	je     80101adf <namex+0x5b>
80101b2d:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b30:	75 ad                	jne    80101adf <namex+0x5b>
      iunlock(ip);
80101b32:	83 ec 0c             	sub    $0xc,%esp
80101b35:	56                   	push   %esi
80101b36:	e8 1f fb ff ff       	call   8010165a <iunlock>
      return ip;
80101b3b:	83 c4 10             	add    $0x10,%esp
80101b3e:	eb 95                	jmp    80101ad5 <namex+0x51>
      iunlockput(ip);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	56                   	push   %esi
80101b44:	e8 fc fb ff ff       	call   80101745 <iunlockput>
      return 0;
80101b49:	83 c4 10             	add    $0x10,%esp
80101b4c:	89 fe                	mov    %edi,%esi
80101b4e:	eb 85                	jmp    80101ad5 <namex+0x51>
  if(nameiparent){
80101b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b54:	0f 84 7b ff ff ff    	je     80101ad5 <namex+0x51>
    iput(ip);
80101b5a:	83 ec 0c             	sub    $0xc,%esp
80101b5d:	56                   	push   %esi
80101b5e:	e8 40 fb ff ff       	call   801016a3 <iput>
    return 0;
80101b63:	83 c4 10             	add    $0x10,%esp
80101b66:	89 de                	mov    %ebx,%esi
80101b68:	e9 68 ff ff ff       	jmp    80101ad5 <namex+0x51>

80101b6d <dirlink>:
{
80101b6d:	f3 0f 1e fb          	endbr32 
80101b71:	55                   	push   %ebp
80101b72:	89 e5                	mov    %esp,%ebp
80101b74:	57                   	push   %edi
80101b75:	56                   	push   %esi
80101b76:	53                   	push   %ebx
80101b77:	83 ec 20             	sub    $0x20,%esp
80101b7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b80:	6a 00                	push   $0x0
80101b82:	57                   	push   %edi
80101b83:	53                   	push   %ebx
80101b84:	e8 63 fe ff ff       	call   801019ec <dirlookup>
80101b89:	83 c4 10             	add    $0x10,%esp
80101b8c:	85 c0                	test   %eax,%eax
80101b8e:	75 07                	jne    80101b97 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b90:	b8 00 00 00 00       	mov    $0x0,%eax
80101b95:	eb 23                	jmp    80101bba <dirlink+0x4d>
    iput(ip);
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	50                   	push   %eax
80101b9b:	e8 03 fb ff ff       	call   801016a3 <iput>
    return -1;
80101ba0:	83 c4 10             	add    $0x10,%esp
80101ba3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba8:	eb 63                	jmp    80101c0d <dirlink+0xa0>
      panic("dirlink read");
80101baa:	83 ec 0c             	sub    $0xc,%esp
80101bad:	68 08 6c 10 80       	push   $0x80106c08
80101bb2:	e8 9e e7 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8d 46 10             	lea    0x10(%esi),%eax
80101bba:	89 c6                	mov    %eax,%esi
80101bbc:	39 43 58             	cmp    %eax,0x58(%ebx)
80101bbf:	76 1c                	jbe    80101bdd <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc1:	6a 10                	push   $0x10
80101bc3:	50                   	push   %eax
80101bc4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bc7:	50                   	push   %eax
80101bc8:	53                   	push   %ebx
80101bc9:	e8 c9 fb ff ff       	call   80101797 <readi>
80101bce:	83 c4 10             	add    $0x10,%esp
80101bd1:	83 f8 10             	cmp    $0x10,%eax
80101bd4:	75 d4                	jne    80101baa <dirlink+0x3d>
    if(de.inum == 0)
80101bd6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bdb:	75 da                	jne    80101bb7 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101bdd:	83 ec 04             	sub    $0x4,%esp
80101be0:	6a 0e                	push   $0xe
80101be2:	57                   	push   %edi
80101be3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101be6:	8d 45 da             	lea    -0x26(%ebp),%eax
80101be9:	50                   	push   %eax
80101bea:	e8 60 24 00 00       	call   8010404f <strncpy>
  de.inum = inum;
80101bef:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf6:	6a 10                	push   $0x10
80101bf8:	56                   	push   %esi
80101bf9:	57                   	push   %edi
80101bfa:	53                   	push   %ebx
80101bfb:	e8 9b fc ff ff       	call   8010189b <writei>
80101c00:	83 c4 20             	add    $0x20,%esp
80101c03:	83 f8 10             	cmp    $0x10,%eax
80101c06:	75 0d                	jne    80101c15 <dirlink+0xa8>
  return 0;
80101c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c10:	5b                   	pop    %ebx
80101c11:	5e                   	pop    %esi
80101c12:	5f                   	pop    %edi
80101c13:	5d                   	pop    %ebp
80101c14:	c3                   	ret    
    panic("dirlink");
80101c15:	83 ec 0c             	sub    $0xc,%esp
80101c18:	68 20 72 10 80       	push   $0x80107220
80101c1d:	e8 33 e7 ff ff       	call   80100355 <panic>

80101c22 <namei>:

struct inode*
namei(char *path)
{
80101c22:	f3 0f 1e fb          	endbr32 
80101c26:	55                   	push   %ebp
80101c27:	89 e5                	mov    %esp,%ebp
80101c29:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c2c:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c2f:	ba 00 00 00 00       	mov    $0x0,%edx
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	e8 48 fe ff ff       	call   80101a84 <namex>
}
80101c3c:	c9                   	leave  
80101c3d:	c3                   	ret    

80101c3e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c3e:	f3 0f 1e fb          	endbr32 
80101c42:	55                   	push   %ebp
80101c43:	89 e5                	mov    %esp,%ebp
80101c45:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c4b:	ba 01 00 00 00       	mov    $0x1,%edx
80101c50:	8b 45 08             	mov    0x8(%ebp),%eax
80101c53:	e8 2c fe ff ff       	call   80101a84 <namex>
}
80101c58:	c9                   	leave  
80101c59:	c3                   	ret    

80101c5a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c5a:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c5c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c61:	ec                   	in     (%dx),%al
80101c62:	88 c2                	mov    %al,%dl
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c64:	83 e0 c0             	and    $0xffffffc0,%eax
80101c67:	3c 40                	cmp    $0x40,%al
80101c69:	75 f1                	jne    80101c5c <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c6b:	85 c9                	test   %ecx,%ecx
80101c6d:	74 0a                	je     80101c79 <idewait+0x1f>
80101c6f:	f6 c2 21             	test   $0x21,%dl
80101c72:	75 08                	jne    80101c7c <idewait+0x22>
    return -1;
  return 0;
80101c74:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c79:	89 c8                	mov    %ecx,%eax
80101c7b:	c3                   	ret    
    return -1;
80101c7c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c81:	eb f6                	jmp    80101c79 <idewait+0x1f>

80101c83 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c83:	55                   	push   %ebp
80101c84:	89 e5                	mov    %esp,%ebp
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
  if(b == 0)
80101c88:	85 c0                	test   %eax,%eax
80101c8a:	0f 84 87 00 00 00    	je     80101d17 <idestart+0x94>
80101c90:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c92:	8b 58 08             	mov    0x8(%eax),%ebx
80101c95:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c9b:	0f 87 83 00 00 00    	ja     80101d24 <idestart+0xa1>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101ca1:	b8 00 00 00 00       	mov    $0x0,%eax
80101ca6:	e8 af ff ff ff       	call   80101c5a <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cab:	b0 00                	mov    $0x0,%al
80101cad:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101cb2:	ee                   	out    %al,(%dx)
80101cb3:	b0 01                	mov    $0x1,%al
80101cb5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101cba:	ee                   	out    %al,(%dx)
80101cbb:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cc0:	88 d8                	mov    %bl,%al
80101cc2:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cc3:	89 d8                	mov    %ebx,%eax
80101cc5:	c1 f8 08             	sar    $0x8,%eax
80101cc8:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ccd:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101cce:	89 d8                	mov    %ebx,%eax
80101cd0:	c1 f8 10             	sar    $0x10,%eax
80101cd3:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101cd8:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101cd9:	8a 46 04             	mov    0x4(%esi),%al
80101cdc:	c1 e0 04             	shl    $0x4,%eax
80101cdf:	83 e0 10             	and    $0x10,%eax
80101ce2:	c1 fb 18             	sar    $0x18,%ebx
80101ce5:	83 e3 0f             	and    $0xf,%ebx
80101ce8:	09 d8                	or     %ebx,%eax
80101cea:	83 c8 e0             	or     $0xffffffe0,%eax
80101ced:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cf2:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101cf3:	f6 06 04             	testb  $0x4,(%esi)
80101cf6:	74 39                	je     80101d31 <idestart+0xae>
80101cf8:	b0 30                	mov    $0x30,%al
80101cfa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cff:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d00:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d03:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d08:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d0d:	fc                   	cld    
80101d0e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d13:	5b                   	pop    %ebx
80101d14:	5e                   	pop    %esi
80101d15:	5d                   	pop    %ebp
80101d16:	c3                   	ret    
    panic("idestart");
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 6b 6c 10 80       	push   $0x80106c6b
80101d1f:	e8 31 e6 ff ff       	call   80100355 <panic>
    panic("incorrect blockno");
80101d24:	83 ec 0c             	sub    $0xc,%esp
80101d27:	68 74 6c 10 80       	push   $0x80106c74
80101d2c:	e8 24 e6 ff ff       	call   80100355 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d31:	b0 20                	mov    $0x20,%al
80101d33:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d38:	ee                   	out    %al,(%dx)
}
80101d39:	eb d5                	jmp    80101d10 <idestart+0x8d>

80101d3b <ideinit>:
{
80101d3b:	f3 0f 1e fb          	endbr32 
80101d3f:	55                   	push   %ebp
80101d40:	89 e5                	mov    %esp,%ebp
80101d42:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d45:	68 86 6c 10 80       	push   $0x80106c86
80101d4a:	68 80 a5 10 80       	push   $0x8010a580
80101d4f:	e8 d8 1f 00 00       	call   80103d2c <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d54:	83 c4 08             	add    $0x8,%esp
80101d57:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d5c:	48                   	dec    %eax
80101d5d:	50                   	push   %eax
80101d5e:	6a 0e                	push   $0xe
80101d60:	e8 50 02 00 00       	call   80101fb5 <ioapicenable>
  idewait(0);
80101d65:	b8 00 00 00 00       	mov    $0x0,%eax
80101d6a:	e8 eb fe ff ff       	call   80101c5a <idewait>
80101d6f:	b0 f0                	mov    $0xf0,%al
80101d71:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d76:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d77:	83 c4 10             	add    $0x10,%esp
80101d7a:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d7f:	eb 01                	jmp    80101d82 <ideinit+0x47>
80101d81:	41                   	inc    %ecx
80101d82:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d88:	7f 14                	jg     80101d9e <ideinit+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d8a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d8f:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d90:	84 c0                	test   %al,%al
80101d92:	74 ed                	je     80101d81 <ideinit+0x46>
      havedisk1 = 1;
80101d94:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101d9b:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d9e:	b0 e0                	mov    $0xe0,%al
80101da0:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101da5:	ee                   	out    %al,(%dx)
}
80101da6:	c9                   	leave  
80101da7:	c3                   	ret    

80101da8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101da8:	f3 0f 1e fb          	endbr32 
80101dac:	55                   	push   %ebp
80101dad:	89 e5                	mov    %esp,%ebp
80101daf:	57                   	push   %edi
80101db0:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101db1:	83 ec 0c             	sub    $0xc,%esp
80101db4:	68 80 a5 10 80       	push   $0x8010a580
80101db9:	e8 b9 20 00 00       	call   80103e77 <acquire>

  if((b = idequeue) == 0){
80101dbe:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	85 db                	test   %ebx,%ebx
80101dc9:	74 48                	je     80101e13 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101dcb:	8b 43 58             	mov    0x58(%ebx),%eax
80101dce:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dd3:	f6 03 04             	testb  $0x4,(%ebx)
80101dd6:	74 4d                	je     80101e25 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101dd8:	8b 03                	mov    (%ebx),%eax
80101dda:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101ddd:	83 e0 fb             	and    $0xfffffffb,%eax
80101de0:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	53                   	push   %ebx
80101de6:	e8 bc 1c 00 00       	call   80103aa7 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101deb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101df0:	83 c4 10             	add    $0x10,%esp
80101df3:	85 c0                	test   %eax,%eax
80101df5:	74 05                	je     80101dfc <ideintr+0x54>
    idestart(idequeue);
80101df7:	e8 87 fe ff ff       	call   80101c83 <idestart>

  release(&idelock);
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 80 a5 10 80       	push   $0x8010a580
80101e04:	e8 d7 20 00 00       	call   80103ee0 <release>
80101e09:	83 c4 10             	add    $0x10,%esp
}
80101e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e0f:	5b                   	pop    %ebx
80101e10:	5f                   	pop    %edi
80101e11:	5d                   	pop    %ebp
80101e12:	c3                   	ret    
    release(&idelock);
80101e13:	83 ec 0c             	sub    $0xc,%esp
80101e16:	68 80 a5 10 80       	push   $0x8010a580
80101e1b:	e8 c0 20 00 00       	call   80103ee0 <release>
    return;
80101e20:	83 c4 10             	add    $0x10,%esp
80101e23:	eb e7                	jmp    80101e0c <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 2b fe ff ff       	call   80101c5a <idewait>
80101e2f:	85 c0                	test   %eax,%eax
80101e31:	78 a5                	js     80101dd8 <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e33:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e36:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e3b:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e40:	fc                   	cld    
80101e41:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e43:	eb 93                	jmp    80101dd8 <ideintr+0x30>

80101e45 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e45:	f3 0f 1e fb          	endbr32 
80101e49:	55                   	push   %ebp
80101e4a:	89 e5                	mov    %esp,%ebp
80101e4c:	53                   	push   %ebx
80101e4d:	83 ec 10             	sub    $0x10,%esp
80101e50:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e53:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e56:	50                   	push   %eax
80101e57:	e8 7e 1e 00 00       	call   80103cda <holdingsleep>
80101e5c:	83 c4 10             	add    $0x10,%esp
80101e5f:	85 c0                	test   %eax,%eax
80101e61:	74 37                	je     80101e9a <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e63:	8b 03                	mov    (%ebx),%eax
80101e65:	83 e0 06             	and    $0x6,%eax
80101e68:	83 f8 02             	cmp    $0x2,%eax
80101e6b:	74 3a                	je     80101ea7 <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e6d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e71:	74 09                	je     80101e7c <iderw+0x37>
80101e73:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101e7a:	74 38                	je     80101eb4 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	68 80 a5 10 80       	push   $0x8010a580
80101e84:	e8 ee 1f 00 00       	call   80103e77 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e89:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e90:	83 c4 10             	add    $0x10,%esp
80101e93:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101e98:	eb 2a                	jmp    80101ec4 <iderw+0x7f>
    panic("iderw: buf not locked");
80101e9a:	83 ec 0c             	sub    $0xc,%esp
80101e9d:	68 8a 6c 10 80       	push   $0x80106c8a
80101ea2:	e8 ae e4 ff ff       	call   80100355 <panic>
    panic("iderw: nothing to do");
80101ea7:	83 ec 0c             	sub    $0xc,%esp
80101eaa:	68 a0 6c 10 80       	push   $0x80106ca0
80101eaf:	e8 a1 e4 ff ff       	call   80100355 <panic>
    panic("iderw: ide disk 1 not present");
80101eb4:	83 ec 0c             	sub    $0xc,%esp
80101eb7:	68 b5 6c 10 80       	push   $0x80106cb5
80101ebc:	e8 94 e4 ff ff       	call   80100355 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ec1:	8d 50 58             	lea    0x58(%eax),%edx
80101ec4:	8b 02                	mov    (%edx),%eax
80101ec6:	85 c0                	test   %eax,%eax
80101ec8:	75 f7                	jne    80101ec1 <iderw+0x7c>
    ;
  *pp = b;
80101eca:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101ecc:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101ed2:	75 1a                	jne    80101eee <iderw+0xa9>
    idestart(b);
80101ed4:	89 d8                	mov    %ebx,%eax
80101ed6:	e8 a8 fd ff ff       	call   80101c83 <idestart>
80101edb:	eb 11                	jmp    80101eee <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101edd:	83 ec 08             	sub    $0x8,%esp
80101ee0:	68 80 a5 10 80       	push   $0x8010a580
80101ee5:	53                   	push   %ebx
80101ee6:	e8 2f 1a 00 00       	call   8010391a <sleep>
80101eeb:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101eee:	8b 03                	mov    (%ebx),%eax
80101ef0:	83 e0 06             	and    $0x6,%eax
80101ef3:	83 f8 02             	cmp    $0x2,%eax
80101ef6:	75 e5                	jne    80101edd <iderw+0x98>
  }


  release(&idelock);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 80 a5 10 80       	push   $0x8010a580
80101f00:	e8 db 1f 00 00       	call   80103ee0 <release>
}
80101f05:	83 c4 10             	add    $0x10,%esp
80101f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f0b:	c9                   	leave  
80101f0c:	c3                   	ret    

80101f0d <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f0d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101f13:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f15:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f1a:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f1d:	c3                   	ret    

80101f1e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f1e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f24:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f26:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f2b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f2e:	c3                   	ret    

80101f2f <ioapicinit>:

void
ioapicinit(void)
{
80101f2f:	f3 0f 1e fb          	endbr32 
80101f33:	55                   	push   %ebp
80101f34:	89 e5                	mov    %esp,%ebp
80101f36:	57                   	push   %edi
80101f37:	56                   	push   %esi
80101f38:	53                   	push   %ebx
80101f39:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f3c:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f43:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f46:	b8 01 00 00 00       	mov    $0x1,%eax
80101f4b:	e8 bd ff ff ff       	call   80101f0d <ioapicread>
80101f50:	c1 e8 10             	shr    $0x10,%eax
80101f53:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f56:	b8 00 00 00 00       	mov    $0x0,%eax
80101f5b:	e8 ad ff ff ff       	call   80101f0d <ioapicread>
80101f60:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f63:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101f6a:	39 c2                	cmp    %eax,%edx
80101f6c:	75 2d                	jne    80101f9b <ioapicinit+0x6c>
{
80101f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101f73:	39 fb                	cmp    %edi,%ebx
80101f75:	7f 36                	jg     80101fad <ioapicinit+0x7e>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f77:	8d 53 20             	lea    0x20(%ebx),%edx
80101f7a:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f80:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f84:	89 f0                	mov    %esi,%eax
80101f86:	e8 93 ff ff ff       	call   80101f1e <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f8b:	8d 46 01             	lea    0x1(%esi),%eax
80101f8e:	ba 00 00 00 00       	mov    $0x0,%edx
80101f93:	e8 86 ff ff ff       	call   80101f1e <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f98:	43                   	inc    %ebx
80101f99:	eb d8                	jmp    80101f73 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f9b:	83 ec 0c             	sub    $0xc,%esp
80101f9e:	68 d4 6c 10 80       	push   $0x80106cd4
80101fa3:	e8 55 e6 ff ff       	call   801005fd <cprintf>
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	eb c1                	jmp    80101f6e <ioapicinit+0x3f>
  }
}
80101fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb0:	5b                   	pop    %ebx
80101fb1:	5e                   	pop    %esi
80101fb2:	5f                   	pop    %edi
80101fb3:	5d                   	pop    %ebp
80101fb4:	c3                   	ret    

80101fb5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fb5:	f3 0f 1e fb          	endbr32 
80101fb9:	55                   	push   %ebp
80101fba:	89 e5                	mov    %esp,%ebp
80101fbc:	53                   	push   %ebx
80101fbd:	83 ec 04             	sub    $0x4,%esp
80101fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fc3:	8d 50 20             	lea    0x20(%eax),%edx
80101fc6:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101fca:	89 d8                	mov    %ebx,%eax
80101fcc:	e8 4d ff ff ff       	call   80101f1e <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fd4:	c1 e2 18             	shl    $0x18,%edx
80101fd7:	8d 43 01             	lea    0x1(%ebx),%eax
80101fda:	e8 3f ff ff ff       	call   80101f1e <ioapicwrite>
}
80101fdf:	83 c4 04             	add    $0x4,%esp
80101fe2:	5b                   	pop    %ebx
80101fe3:	5d                   	pop    %ebp
80101fe4:	c3                   	ret    

80101fe5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101fe5:	f3 0f 1e fb          	endbr32 
80101fe9:	55                   	push   %ebp
80101fea:	89 e5                	mov    %esp,%ebp
80101fec:	53                   	push   %ebx
80101fed:	83 ec 04             	sub    $0x4,%esp
80101ff0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101ff3:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101ff9:	75 4c                	jne    80102047 <kfree+0x62>
80101ffb:	81 fb 08 59 11 80    	cmp    $0x80115908,%ebx
80102001:	72 44                	jb     80102047 <kfree+0x62>
80102003:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102009:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010200e:	77 37                	ja     80102047 <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102010:	83 ec 04             	sub    $0x4,%esp
80102013:	68 00 10 00 00       	push   $0x1000
80102018:	6a 01                	push   $0x1
8010201a:	53                   	push   %ebx
8010201b:	e8 0b 1f 00 00       	call   80103f2b <memset>

  if(kmem.use_lock)
80102020:	83 c4 10             	add    $0x10,%esp
80102023:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010202a:	75 28                	jne    80102054 <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010202c:	a1 78 26 11 80       	mov    0x80112678,%eax
80102031:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102033:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102039:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102040:	75 24                	jne    80102066 <kfree+0x81>
    release(&kmem.lock);
}
80102042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102045:	c9                   	leave  
80102046:	c3                   	ret    
    panic("kfree");
80102047:	83 ec 0c             	sub    $0xc,%esp
8010204a:	68 06 6d 10 80       	push   $0x80106d06
8010204f:	e8 01 e3 ff ff       	call   80100355 <panic>
    acquire(&kmem.lock);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	68 40 26 11 80       	push   $0x80112640
8010205c:	e8 16 1e 00 00       	call   80103e77 <acquire>
80102061:	83 c4 10             	add    $0x10,%esp
80102064:	eb c6                	jmp    8010202c <kfree+0x47>
    release(&kmem.lock);
80102066:	83 ec 0c             	sub    $0xc,%esp
80102069:	68 40 26 11 80       	push   $0x80112640
8010206e:	e8 6d 1e 00 00       	call   80103ee0 <release>
80102073:	83 c4 10             	add    $0x10,%esp
}
80102076:	eb ca                	jmp    80102042 <kfree+0x5d>

80102078 <freerange>:
{
80102078:	f3 0f 1e fb          	endbr32 
8010207c:	55                   	push   %ebp
8010207d:	89 e5                	mov    %esp,%ebp
8010207f:	56                   	push   %esi
80102080:	53                   	push   %ebx
80102081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102084:	8b 45 08             	mov    0x8(%ebp),%eax
80102087:	05 ff 0f 00 00       	add    $0xfff,%eax
8010208c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102091:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102097:	39 de                	cmp    %ebx,%esi
80102099:	77 10                	ja     801020ab <freerange+0x33>
    kfree(p);
8010209b:	83 ec 0c             	sub    $0xc,%esp
8010209e:	50                   	push   %eax
8010209f:	e8 41 ff ff ff       	call   80101fe5 <kfree>
801020a4:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020a7:	89 f0                	mov    %esi,%eax
801020a9:	eb e6                	jmp    80102091 <freerange+0x19>
}
801020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020ae:	5b                   	pop    %ebx
801020af:	5e                   	pop    %esi
801020b0:	5d                   	pop    %ebp
801020b1:	c3                   	ret    

801020b2 <kinit1>:
{
801020b2:	f3 0f 1e fb          	endbr32 
801020b6:	55                   	push   %ebp
801020b7:	89 e5                	mov    %esp,%ebp
801020b9:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801020bc:	68 0c 6d 10 80       	push   $0x80106d0c
801020c1:	68 40 26 11 80       	push   $0x80112640
801020c6:	e8 61 1c 00 00       	call   80103d2c <initlock>
  kmem.use_lock = 0;
801020cb:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801020d2:	00 00 00 
  freerange(vstart, vend);
801020d5:	83 c4 08             	add    $0x8,%esp
801020d8:	ff 75 0c             	pushl  0xc(%ebp)
801020db:	ff 75 08             	pushl  0x8(%ebp)
801020de:	e8 95 ff ff ff       	call   80102078 <freerange>
}
801020e3:	83 c4 10             	add    $0x10,%esp
801020e6:	c9                   	leave  
801020e7:	c3                   	ret    

801020e8 <kinit2>:
{
801020e8:	f3 0f 1e fb          	endbr32 
801020ec:	55                   	push   %ebp
801020ed:	89 e5                	mov    %esp,%ebp
801020ef:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801020f2:	ff 75 0c             	pushl  0xc(%ebp)
801020f5:	ff 75 08             	pushl  0x8(%ebp)
801020f8:	e8 7b ff ff ff       	call   80102078 <freerange>
  kmem.use_lock = 1;
801020fd:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102104:	00 00 00 
}
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	c9                   	leave  
8010210b:	c3                   	ret    

8010210c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010210c:	f3 0f 1e fb          	endbr32 
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102117:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010211e:	75 21                	jne    80102141 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102120:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102126:	85 db                	test   %ebx,%ebx
80102128:	74 07                	je     80102131 <kalloc+0x25>
    kmem.freelist = r->next;
8010212a:	8b 03                	mov    (%ebx),%eax
8010212c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
80102131:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102138:	75 19                	jne    80102153 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
8010213a:	89 d8                	mov    %ebx,%eax
8010213c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010213f:	c9                   	leave  
80102140:	c3                   	ret    
    acquire(&kmem.lock);
80102141:	83 ec 0c             	sub    $0xc,%esp
80102144:	68 40 26 11 80       	push   $0x80112640
80102149:	e8 29 1d 00 00       	call   80103e77 <acquire>
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	eb cd                	jmp    80102120 <kalloc+0x14>
    release(&kmem.lock);
80102153:	83 ec 0c             	sub    $0xc,%esp
80102156:	68 40 26 11 80       	push   $0x80112640
8010215b:	e8 80 1d 00 00       	call   80103ee0 <release>
80102160:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102163:	eb d5                	jmp    8010213a <kalloc+0x2e>

80102165 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102165:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102169:	ba 64 00 00 00       	mov    $0x64,%edx
8010216e:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010216f:	a8 01                	test   $0x1,%al
80102171:	0f 84 ac 00 00 00    	je     80102223 <kbdgetc+0xbe>
80102177:	ba 60 00 00 00       	mov    $0x60,%edx
8010217c:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010217d:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102180:	3c e0                	cmp    $0xe0,%al
80102182:	74 5b                	je     801021df <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102184:	84 c0                	test   %al,%al
80102186:	78 64                	js     801021ec <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102188:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010218e:	f6 c1 40             	test   $0x40,%cl
80102191:	74 0f                	je     801021a2 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102193:	83 c8 80             	or     $0xffffff80,%eax
80102196:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102199:	83 e1 bf             	and    $0xffffffbf,%ecx
8010219c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
801021a2:	0f b6 8a 40 6e 10 80 	movzbl -0x7fef91c0(%edx),%ecx
801021a9:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
801021af:	0f b6 82 40 6d 10 80 	movzbl -0x7fef92c0(%edx),%eax
801021b6:	31 c1                	xor    %eax,%ecx
801021b8:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801021be:	89 c8                	mov    %ecx,%eax
801021c0:	83 e0 03             	and    $0x3,%eax
801021c3:	8b 04 85 20 6d 10 80 	mov    -0x7fef92e0(,%eax,4),%eax
801021ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801021ce:	f6 c1 08             	test   $0x8,%cl
801021d1:	74 55                	je     80102228 <kbdgetc+0xc3>
    if('a' <= c && c <= 'z')
801021d3:	8d 50 9f             	lea    -0x61(%eax),%edx
801021d6:	83 fa 19             	cmp    $0x19,%edx
801021d9:	77 3c                	ja     80102217 <kbdgetc+0xb2>
      c += 'A' - 'a';
801021db:	83 e8 20             	sub    $0x20,%eax
801021de:	c3                   	ret    
    shift |= E0ESC;
801021df:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801021e6:	b8 00 00 00 00       	mov    $0x0,%eax
801021eb:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801021ec:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021f2:	f6 c1 40             	test   $0x40,%cl
801021f5:	75 05                	jne    801021fc <kbdgetc+0x97>
801021f7:	89 c2                	mov    %eax,%edx
801021f9:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801021fc:	8a 82 40 6e 10 80    	mov    -0x7fef91c0(%edx),%al
80102202:	83 c8 40             	or     $0x40,%eax
80102205:	0f b6 c0             	movzbl %al,%eax
80102208:	f7 d0                	not    %eax
8010220a:	21 c8                	and    %ecx,%eax
8010220c:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102211:	b8 00 00 00 00       	mov    $0x0,%eax
80102216:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102217:	8d 50 bf             	lea    -0x41(%eax),%edx
8010221a:	83 fa 19             	cmp    $0x19,%edx
8010221d:	77 09                	ja     80102228 <kbdgetc+0xc3>
      c += 'a' - 'A';
8010221f:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102222:	c3                   	ret    
    return -1;
80102223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102228:	c3                   	ret    

80102229 <kbdintr>:

void
kbdintr(void)
{
80102229:	f3 0f 1e fb          	endbr32 
8010222d:	55                   	push   %ebp
8010222e:	89 e5                	mov    %esp,%ebp
80102230:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102233:	68 65 21 10 80       	push   $0x80102165
80102238:	e8 e9 e4 ff ff       	call   80100726 <consoleintr>
}
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	c9                   	leave  
80102241:	c3                   	ret    

80102242 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102242:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
80102248:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010224b:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010224d:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102252:	8b 40 20             	mov    0x20(%eax),%eax
}
80102255:	c3                   	ret    

80102256 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102256:	ba 70 00 00 00       	mov    $0x70,%edx
8010225b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010225c:	ba 71 00 00 00       	mov    $0x71,%edx
80102261:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102262:	0f b6 c0             	movzbl %al,%eax
}
80102265:	c3                   	ret    

80102266 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
80102266:	55                   	push   %ebp
80102267:	89 e5                	mov    %esp,%ebp
80102269:	53                   	push   %ebx
8010226a:	83 ec 04             	sub    $0x4,%esp
8010226d:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
8010226f:	b8 00 00 00 00       	mov    $0x0,%eax
80102274:	e8 dd ff ff ff       	call   80102256 <cmos_read>
80102279:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
8010227b:	b8 02 00 00 00       	mov    $0x2,%eax
80102280:	e8 d1 ff ff ff       	call   80102256 <cmos_read>
80102285:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102288:	b8 04 00 00 00       	mov    $0x4,%eax
8010228d:	e8 c4 ff ff ff       	call   80102256 <cmos_read>
80102292:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102295:	b8 07 00 00 00       	mov    $0x7,%eax
8010229a:	e8 b7 ff ff ff       	call   80102256 <cmos_read>
8010229f:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801022a2:	b8 08 00 00 00       	mov    $0x8,%eax
801022a7:	e8 aa ff ff ff       	call   80102256 <cmos_read>
801022ac:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801022af:	b8 09 00 00 00       	mov    $0x9,%eax
801022b4:	e8 9d ff ff ff       	call   80102256 <cmos_read>
801022b9:	89 43 14             	mov    %eax,0x14(%ebx)
}
801022bc:	83 c4 04             	add    $0x4,%esp
801022bf:	5b                   	pop    %ebx
801022c0:	5d                   	pop    %ebp
801022c1:	c3                   	ret    

801022c2 <lapicinit>:
{
801022c2:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801022c6:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801022cd:	0f 84 fe 00 00 00    	je     801023d1 <lapicinit+0x10f>
{
801022d3:	55                   	push   %ebp
801022d4:	89 e5                	mov    %esp,%ebp
801022d6:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801022d9:	ba 3f 01 00 00       	mov    $0x13f,%edx
801022de:	b8 3c 00 00 00       	mov    $0x3c,%eax
801022e3:	e8 5a ff ff ff       	call   80102242 <lapicw>
  lapicw(TDCR, X1);
801022e8:	ba 0b 00 00 00       	mov    $0xb,%edx
801022ed:	b8 f8 00 00 00       	mov    $0xf8,%eax
801022f2:	e8 4b ff ff ff       	call   80102242 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801022f7:	ba 20 00 02 00       	mov    $0x20020,%edx
801022fc:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102301:	e8 3c ff ff ff       	call   80102242 <lapicw>
  lapicw(TICR, 10000000);
80102306:	ba 80 96 98 00       	mov    $0x989680,%edx
8010230b:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102310:	e8 2d ff ff ff       	call   80102242 <lapicw>
  lapicw(LINT0, MASKED);
80102315:	ba 00 00 01 00       	mov    $0x10000,%edx
8010231a:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010231f:	e8 1e ff ff ff       	call   80102242 <lapicw>
  lapicw(LINT1, MASKED);
80102324:	ba 00 00 01 00       	mov    $0x10000,%edx
80102329:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010232e:	e8 0f ff ff ff       	call   80102242 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102333:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102338:	8b 40 30             	mov    0x30(%eax),%eax
8010233b:	c1 e8 10             	shr    $0x10,%eax
8010233e:	a8 fc                	test   $0xfc,%al
80102340:	75 7b                	jne    801023bd <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102342:	ba 33 00 00 00       	mov    $0x33,%edx
80102347:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010234c:	e8 f1 fe ff ff       	call   80102242 <lapicw>
  lapicw(ESR, 0);
80102351:	ba 00 00 00 00       	mov    $0x0,%edx
80102356:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010235b:	e8 e2 fe ff ff       	call   80102242 <lapicw>
  lapicw(ESR, 0);
80102360:	ba 00 00 00 00       	mov    $0x0,%edx
80102365:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010236a:	e8 d3 fe ff ff       	call   80102242 <lapicw>
  lapicw(EOI, 0);
8010236f:	ba 00 00 00 00       	mov    $0x0,%edx
80102374:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102379:	e8 c4 fe ff ff       	call   80102242 <lapicw>
  lapicw(ICRHI, 0);
8010237e:	ba 00 00 00 00       	mov    $0x0,%edx
80102383:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102388:	e8 b5 fe ff ff       	call   80102242 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010238d:	ba 00 85 08 00       	mov    $0x88500,%edx
80102392:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102397:	e8 a6 fe ff ff       	call   80102242 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010239c:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023a1:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801023a7:	f6 c4 10             	test   $0x10,%ah
801023aa:	75 f0                	jne    8010239c <lapicinit+0xda>
  lapicw(TPR, 0);
801023ac:	ba 00 00 00 00       	mov    $0x0,%edx
801023b1:	b8 20 00 00 00       	mov    $0x20,%eax
801023b6:	e8 87 fe ff ff       	call   80102242 <lapicw>
}
801023bb:	c9                   	leave  
801023bc:	c3                   	ret    
    lapicw(PCINT, MASKED);
801023bd:	ba 00 00 01 00       	mov    $0x10000,%edx
801023c2:	b8 d0 00 00 00       	mov    $0xd0,%eax
801023c7:	e8 76 fe ff ff       	call   80102242 <lapicw>
801023cc:	e9 71 ff ff ff       	jmp    80102342 <lapicinit+0x80>
801023d1:	c3                   	ret    

801023d2 <lapicid>:
{
801023d2:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801023d6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023db:	85 c0                	test   %eax,%eax
801023dd:	74 07                	je     801023e6 <lapicid+0x14>
  return lapic[ID] >> 24;
801023df:	8b 40 20             	mov    0x20(%eax),%eax
801023e2:	c1 e8 18             	shr    $0x18,%eax
801023e5:	c3                   	ret    
    return 0;
801023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023eb:	c3                   	ret    

801023ec <lapiceoi>:
{
801023ec:	f3 0f 1e fb          	endbr32 
  if(lapic)
801023f0:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801023f7:	74 17                	je     80102410 <lapiceoi+0x24>
{
801023f9:	55                   	push   %ebp
801023fa:	89 e5                	mov    %esp,%ebp
801023fc:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
801023ff:	ba 00 00 00 00       	mov    $0x0,%edx
80102404:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102409:	e8 34 fe ff ff       	call   80102242 <lapicw>
}
8010240e:	c9                   	leave  
8010240f:	c3                   	ret    
80102410:	c3                   	ret    

80102411 <microdelay>:
{
80102411:	f3 0f 1e fb          	endbr32 
}
80102415:	c3                   	ret    

80102416 <lapicstartap>:
{
80102416:	f3 0f 1e fb          	endbr32 
8010241a:	55                   	push   %ebp
8010241b:	89 e5                	mov    %esp,%ebp
8010241d:	57                   	push   %edi
8010241e:	56                   	push   %esi
8010241f:	53                   	push   %ebx
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	8b 75 08             	mov    0x8(%ebp),%esi
80102426:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102429:	b0 0f                	mov    $0xf,%al
8010242b:	ba 70 00 00 00       	mov    $0x70,%edx
80102430:	ee                   	out    %al,(%dx)
80102431:	b0 0a                	mov    $0xa,%al
80102433:	ba 71 00 00 00       	mov    $0x71,%edx
80102438:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102439:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102440:	00 00 
  wrv[1] = addr >> 4;
80102442:	89 f8                	mov    %edi,%eax
80102444:	c1 e8 04             	shr    $0x4,%eax
80102447:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010244d:	c1 e6 18             	shl    $0x18,%esi
80102450:	89 f2                	mov    %esi,%edx
80102452:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102457:	e8 e6 fd ff ff       	call   80102242 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010245c:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102461:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102466:	e8 d7 fd ff ff       	call   80102242 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010246b:	ba 00 85 00 00       	mov    $0x8500,%edx
80102470:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102475:	e8 c8 fd ff ff       	call   80102242 <lapicw>
  for(i = 0; i < 2; i++){
8010247a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010247f:	eb 1f                	jmp    801024a0 <lapicstartap+0x8a>
    lapicw(ICRHI, apicid<<24);
80102481:	89 f2                	mov    %esi,%edx
80102483:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102488:	e8 b5 fd ff ff       	call   80102242 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010248d:	89 fa                	mov    %edi,%edx
8010248f:	c1 ea 0c             	shr    $0xc,%edx
80102492:	80 ce 06             	or     $0x6,%dh
80102495:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010249a:	e8 a3 fd ff ff       	call   80102242 <lapicw>
  for(i = 0; i < 2; i++){
8010249f:	43                   	inc    %ebx
801024a0:	83 fb 01             	cmp    $0x1,%ebx
801024a3:	7e dc                	jle    80102481 <lapicstartap+0x6b>
}
801024a5:	83 c4 0c             	add    $0xc,%esp
801024a8:	5b                   	pop    %ebx
801024a9:	5e                   	pop    %esi
801024aa:	5f                   	pop    %edi
801024ab:	5d                   	pop    %ebp
801024ac:	c3                   	ret    

801024ad <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801024ad:	f3 0f 1e fb          	endbr32 
801024b1:	55                   	push   %ebp
801024b2:	89 e5                	mov    %esp,%ebp
801024b4:	57                   	push   %edi
801024b5:	56                   	push   %esi
801024b6:	53                   	push   %ebx
801024b7:	83 ec 3c             	sub    $0x3c,%esp
801024ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801024bd:	b8 0b 00 00 00       	mov    $0xb,%eax
801024c2:	e8 8f fd ff ff       	call   80102256 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801024c7:	83 e0 04             	and    $0x4,%eax
801024ca:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801024cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024cf:	e8 92 fd ff ff       	call   80102266 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801024d4:	b8 0a 00 00 00       	mov    $0xa,%eax
801024d9:	e8 78 fd ff ff       	call   80102256 <cmos_read>
801024de:	a8 80                	test   $0x80,%al
801024e0:	75 ea                	jne    801024cc <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
801024e2:	8d 75 b8             	lea    -0x48(%ebp),%esi
801024e5:	89 f0                	mov    %esi,%eax
801024e7:	e8 7a fd ff ff       	call   80102266 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801024ec:	83 ec 04             	sub    $0x4,%esp
801024ef:	6a 18                	push   $0x18
801024f1:	56                   	push   %esi
801024f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024f5:	50                   	push   %eax
801024f6:	e8 7b 1a 00 00       	call   80103f76 <memcmp>
801024fb:	83 c4 10             	add    $0x10,%esp
801024fe:	85 c0                	test   %eax,%eax
80102500:	75 ca                	jne    801024cc <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
80102502:	85 ff                	test   %edi,%edi
80102504:	75 7e                	jne    80102584 <cmostime+0xd7>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102506:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102509:	89 d0                	mov    %edx,%eax
8010250b:	c1 e8 04             	shr    $0x4,%eax
8010250e:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102511:	01 c0                	add    %eax,%eax
80102513:	83 e2 0f             	and    $0xf,%edx
80102516:	01 d0                	add    %edx,%eax
80102518:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010251b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010251e:	89 d0                	mov    %edx,%eax
80102520:	c1 e8 04             	shr    $0x4,%eax
80102523:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102526:	01 c0                	add    %eax,%eax
80102528:	83 e2 0f             	and    $0xf,%edx
8010252b:	01 d0                	add    %edx,%eax
8010252d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102530:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102533:	89 d0                	mov    %edx,%eax
80102535:	c1 e8 04             	shr    $0x4,%eax
80102538:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010253b:	01 c0                	add    %eax,%eax
8010253d:	83 e2 0f             	and    $0xf,%edx
80102540:	01 d0                	add    %edx,%eax
80102542:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102545:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102548:	89 d0                	mov    %edx,%eax
8010254a:	c1 e8 04             	shr    $0x4,%eax
8010254d:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102550:	01 c0                	add    %eax,%eax
80102552:	83 e2 0f             	and    $0xf,%edx
80102555:	01 d0                	add    %edx,%eax
80102557:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
8010255a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010255d:	89 d0                	mov    %edx,%eax
8010255f:	c1 e8 04             	shr    $0x4,%eax
80102562:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102565:	01 c0                	add    %eax,%eax
80102567:	83 e2 0f             	and    $0xf,%edx
8010256a:	01 d0                	add    %edx,%eax
8010256c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010256f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102572:	89 d0                	mov    %edx,%eax
80102574:	c1 e8 04             	shr    $0x4,%eax
80102577:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010257a:	01 c0                	add    %eax,%eax
8010257c:	83 e2 0f             	and    $0xf,%edx
8010257f:	01 d0                	add    %edx,%eax
80102581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102584:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102587:	b9 06 00 00 00       	mov    $0x6,%ecx
8010258c:	89 df                	mov    %ebx,%edi
8010258e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102590:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010259a:	5b                   	pop    %ebx
8010259b:	5e                   	pop    %esi
8010259c:	5f                   	pop    %edi
8010259d:	5d                   	pop    %ebp
8010259e:	c3                   	ret    

8010259f <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010259f:	55                   	push   %ebp
801025a0:	89 e5                	mov    %esp,%ebp
801025a2:	53                   	push   %ebx
801025a3:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801025a6:	ff 35 b4 26 11 80    	pushl  0x801126b4
801025ac:	ff 35 c4 26 11 80    	pushl  0x801126c4
801025b2:	e8 b7 db ff ff       	call   8010016e <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801025b7:	8b 58 5c             	mov    0x5c(%eax),%ebx
801025ba:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	ba 00 00 00 00       	mov    $0x0,%edx
801025c8:	39 d3                	cmp    %edx,%ebx
801025ca:	7e 0e                	jle    801025da <read_head+0x3b>
    log.lh.block[i] = lh->block[i];
801025cc:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801025d0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801025d7:	42                   	inc    %edx
801025d8:	eb ee                	jmp    801025c8 <read_head+0x29>
  }
  brelse(buf);
801025da:	83 ec 0c             	sub    $0xc,%esp
801025dd:	50                   	push   %eax
801025de:	e8 fc db ff ff       	call   801001df <brelse>
}
801025e3:	83 c4 10             	add    $0x10,%esp
801025e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025e9:	c9                   	leave  
801025ea:	c3                   	ret    

801025eb <install_trans>:
{
801025eb:	55                   	push   %ebp
801025ec:	89 e5                	mov    %esp,%ebp
801025ee:	57                   	push   %edi
801025ef:	56                   	push   %esi
801025f0:	53                   	push   %ebx
801025f1:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801025f4:	be 00 00 00 00       	mov    $0x0,%esi
801025f9:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801025ff:	7e 64                	jle    80102665 <install_trans+0x7a>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102601:	89 f0                	mov    %esi,%eax
80102603:	03 05 b4 26 11 80    	add    0x801126b4,%eax
80102609:	40                   	inc    %eax
8010260a:	83 ec 08             	sub    $0x8,%esp
8010260d:	50                   	push   %eax
8010260e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102614:	e8 55 db ff ff       	call   8010016e <bread>
80102619:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010261b:	83 c4 08             	add    $0x8,%esp
8010261e:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102625:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010262b:	e8 3e db ff ff       	call   8010016e <bread>
80102630:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102632:	8d 57 5c             	lea    0x5c(%edi),%edx
80102635:	8d 40 5c             	lea    0x5c(%eax),%eax
80102638:	83 c4 0c             	add    $0xc,%esp
8010263b:	68 00 02 00 00       	push   $0x200
80102640:	52                   	push   %edx
80102641:	50                   	push   %eax
80102642:	e8 62 19 00 00       	call   80103fa9 <memmove>
    bwrite(dbuf);  // write dst to disk
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 51 db ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
8010264f:	89 3c 24             	mov    %edi,(%esp)
80102652:	e8 88 db ff ff       	call   801001df <brelse>
    brelse(dbuf);
80102657:	89 1c 24             	mov    %ebx,(%esp)
8010265a:	e8 80 db ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010265f:	46                   	inc    %esi
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	eb 94                	jmp    801025f9 <install_trans+0xe>
}
80102665:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102668:	5b                   	pop    %ebx
80102669:	5e                   	pop    %esi
8010266a:	5f                   	pop    %edi
8010266b:	5d                   	pop    %ebp
8010266c:	c3                   	ret    

8010266d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010266d:	55                   	push   %ebp
8010266e:	89 e5                	mov    %esp,%ebp
80102670:	53                   	push   %ebx
80102671:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102674:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010267a:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102680:	e8 e9 da ff ff       	call   8010016e <bread>
80102685:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102687:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
8010268d:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102690:	83 c4 10             	add    $0x10,%esp
80102693:	b8 00 00 00 00       	mov    $0x0,%eax
80102698:	39 c1                	cmp    %eax,%ecx
8010269a:	7e 0e                	jle    801026aa <write_head+0x3d>
    hb->block[i] = log.lh.block[i];
8010269c:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
801026a3:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801026a7:	40                   	inc    %eax
801026a8:	eb ee                	jmp    80102698 <write_head+0x2b>
  }
  bwrite(buf);
801026aa:	83 ec 0c             	sub    $0xc,%esp
801026ad:	53                   	push   %ebx
801026ae:	e8 ed da ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801026b3:	89 1c 24             	mov    %ebx,(%esp)
801026b6:	e8 24 db ff ff       	call   801001df <brelse>
}
801026bb:	83 c4 10             	add    $0x10,%esp
801026be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026c1:	c9                   	leave  
801026c2:	c3                   	ret    

801026c3 <recover_from_log>:

static void
recover_from_log(void)
{
801026c3:	55                   	push   %ebp
801026c4:	89 e5                	mov    %esp,%ebp
801026c6:	83 ec 08             	sub    $0x8,%esp
  read_head();
801026c9:	e8 d1 fe ff ff       	call   8010259f <read_head>
  install_trans(); // if committed, copy from log to disk
801026ce:	e8 18 ff ff ff       	call   801025eb <install_trans>
  log.lh.n = 0;
801026d3:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801026da:	00 00 00 
  write_head(); // clear the log
801026dd:	e8 8b ff ff ff       	call   8010266d <write_head>
}
801026e2:	c9                   	leave  
801026e3:	c3                   	ret    

801026e4 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801026e4:	55                   	push   %ebp
801026e5:	89 e5                	mov    %esp,%ebp
801026e7:	57                   	push   %edi
801026e8:	56                   	push   %esi
801026e9:	53                   	push   %ebx
801026ea:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026ed:	be 00 00 00 00       	mov    $0x0,%esi
801026f2:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801026f8:	7e 64                	jle    8010275e <write_log+0x7a>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801026fa:	89 f0                	mov    %esi,%eax
801026fc:	03 05 b4 26 11 80    	add    0x801126b4,%eax
80102702:	40                   	inc    %eax
80102703:	83 ec 08             	sub    $0x8,%esp
80102706:	50                   	push   %eax
80102707:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010270d:	e8 5c da ff ff       	call   8010016e <bread>
80102712:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102714:	83 c4 08             	add    $0x8,%esp
80102717:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
8010271e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102724:	e8 45 da ff ff       	call   8010016e <bread>
80102729:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010272b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010272e:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102731:	83 c4 0c             	add    $0xc,%esp
80102734:	68 00 02 00 00       	push   $0x200
80102739:	52                   	push   %edx
8010273a:	50                   	push   %eax
8010273b:	e8 69 18 00 00       	call   80103fa9 <memmove>
    bwrite(to);  // write the log
80102740:	89 1c 24             	mov    %ebx,(%esp)
80102743:	e8 58 da ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102748:	89 3c 24             	mov    %edi,(%esp)
8010274b:	e8 8f da ff ff       	call   801001df <brelse>
    brelse(to);
80102750:	89 1c 24             	mov    %ebx,(%esp)
80102753:	e8 87 da ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102758:	46                   	inc    %esi
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	eb 94                	jmp    801026f2 <write_log+0xe>
  }
}
8010275e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102761:	5b                   	pop    %ebx
80102762:	5e                   	pop    %esi
80102763:	5f                   	pop    %edi
80102764:	5d                   	pop    %ebp
80102765:	c3                   	ret    

80102766 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102766:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010276d:	7f 01                	jg     80102770 <commit+0xa>
8010276f:	c3                   	ret    
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102776:	e8 69 ff ff ff       	call   801026e4 <write_log>
    write_head();    // Write header to disk -- the real commit
8010277b:	e8 ed fe ff ff       	call   8010266d <write_head>
    install_trans(); // Now install writes to home locations
80102780:	e8 66 fe ff ff       	call   801025eb <install_trans>
    log.lh.n = 0;
80102785:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010278c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010278f:	e8 d9 fe ff ff       	call   8010266d <write_head>
  }
}
80102794:	c9                   	leave  
80102795:	c3                   	ret    

80102796 <initlog>:
{
80102796:	f3 0f 1e fb          	endbr32 
8010279a:	55                   	push   %ebp
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	83 ec 2c             	sub    $0x2c,%esp
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027a4:	68 40 6f 10 80       	push   $0x80106f40
801027a9:	68 80 26 11 80       	push   $0x80112680
801027ae:	e8 79 15 00 00       	call   80103d2c <initlock>
  readsb(dev, &sb);
801027b3:	83 c4 08             	add    $0x8,%esp
801027b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027b9:	50                   	push   %eax
801027ba:	53                   	push   %ebx
801027bb:	e8 81 ea ff ff       	call   80101241 <readsb>
  log.start = sb.logstart;
801027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027c3:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027cb:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
801027d0:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
801027d6:	e8 e8 fe ff ff       	call   801026c3 <recover_from_log>
}
801027db:	83 c4 10             	add    $0x10,%esp
801027de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e1:	c9                   	leave  
801027e2:	c3                   	ret    

801027e3 <begin_op>:
{
801027e3:	f3 0f 1e fb          	endbr32 
801027e7:	55                   	push   %ebp
801027e8:	89 e5                	mov    %esp,%ebp
801027ea:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027ed:	68 80 26 11 80       	push   $0x80112680
801027f2:	e8 80 16 00 00       	call   80103e77 <acquire>
801027f7:	83 c4 10             	add    $0x10,%esp
801027fa:	eb 15                	jmp    80102811 <begin_op+0x2e>
      sleep(&log, &log.lock);
801027fc:	83 ec 08             	sub    $0x8,%esp
801027ff:	68 80 26 11 80       	push   $0x80112680
80102804:	68 80 26 11 80       	push   $0x80112680
80102809:	e8 0c 11 00 00       	call   8010391a <sleep>
8010280e:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102811:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102818:	75 e2                	jne    801027fc <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010281a:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010281f:	8d 48 01             	lea    0x1(%eax),%ecx
80102822:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80102826:	8d 04 12             	lea    (%edx,%edx,1),%eax
80102829:	03 05 c8 26 11 80    	add    0x801126c8,%eax
8010282f:	83 f8 1e             	cmp    $0x1e,%eax
80102832:	7e 17                	jle    8010284b <begin_op+0x68>
      sleep(&log, &log.lock);
80102834:	83 ec 08             	sub    $0x8,%esp
80102837:	68 80 26 11 80       	push   $0x80112680
8010283c:	68 80 26 11 80       	push   $0x80112680
80102841:	e8 d4 10 00 00       	call   8010391a <sleep>
80102846:	83 c4 10             	add    $0x10,%esp
80102849:	eb c6                	jmp    80102811 <begin_op+0x2e>
      log.outstanding += 1;
8010284b:	89 0d bc 26 11 80    	mov    %ecx,0x801126bc
      release(&log.lock);
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 80 26 11 80       	push   $0x80112680
80102859:	e8 82 16 00 00       	call   80103ee0 <release>
}
8010285e:	83 c4 10             	add    $0x10,%esp
80102861:	c9                   	leave  
80102862:	c3                   	ret    

80102863 <end_op>:
{
80102863:	f3 0f 1e fb          	endbr32 
80102867:	55                   	push   %ebp
80102868:	89 e5                	mov    %esp,%ebp
8010286a:	53                   	push   %ebx
8010286b:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010286e:	68 80 26 11 80       	push   $0x80112680
80102873:	e8 ff 15 00 00       	call   80103e77 <acquire>
  log.outstanding -= 1;
80102878:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010287d:	48                   	dec    %eax
8010287e:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102883:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102889:	83 c4 10             	add    $0x10,%esp
8010288c:	85 db                	test   %ebx,%ebx
8010288e:	75 2c                	jne    801028bc <end_op+0x59>
  if(log.outstanding == 0){
80102890:	85 c0                	test   %eax,%eax
80102892:	75 35                	jne    801028c9 <end_op+0x66>
    log.committing = 1;
80102894:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
8010289b:	00 00 00 
    do_commit = 1;
8010289e:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
801028a3:	83 ec 0c             	sub    $0xc,%esp
801028a6:	68 80 26 11 80       	push   $0x80112680
801028ab:	e8 30 16 00 00       	call   80103ee0 <release>
  if(do_commit){
801028b0:	83 c4 10             	add    $0x10,%esp
801028b3:	85 db                	test   %ebx,%ebx
801028b5:	75 24                	jne    801028db <end_op+0x78>
}
801028b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ba:	c9                   	leave  
801028bb:	c3                   	ret    
    panic("log.committing");
801028bc:	83 ec 0c             	sub    $0xc,%esp
801028bf:	68 44 6f 10 80       	push   $0x80106f44
801028c4:	e8 8c da ff ff       	call   80100355 <panic>
    wakeup(&log);
801028c9:	83 ec 0c             	sub    $0xc,%esp
801028cc:	68 80 26 11 80       	push   $0x80112680
801028d1:	e8 d1 11 00 00       	call   80103aa7 <wakeup>
801028d6:	83 c4 10             	add    $0x10,%esp
801028d9:	eb c8                	jmp    801028a3 <end_op+0x40>
    commit();
801028db:	e8 86 fe ff ff       	call   80102766 <commit>
    acquire(&log.lock);
801028e0:	83 ec 0c             	sub    $0xc,%esp
801028e3:	68 80 26 11 80       	push   $0x80112680
801028e8:	e8 8a 15 00 00       	call   80103e77 <acquire>
    log.committing = 0;
801028ed:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028f4:	00 00 00 
    wakeup(&log);
801028f7:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028fe:	e8 a4 11 00 00       	call   80103aa7 <wakeup>
    release(&log.lock);
80102903:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010290a:	e8 d1 15 00 00       	call   80103ee0 <release>
8010290f:	83 c4 10             	add    $0x10,%esp
}
80102912:	eb a3                	jmp    801028b7 <end_op+0x54>

80102914 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102914:	f3 0f 1e fb          	endbr32 
80102918:	55                   	push   %ebp
80102919:	89 e5                	mov    %esp,%ebp
8010291b:	53                   	push   %ebx
8010291c:	83 ec 04             	sub    $0x4,%esp
8010291f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102922:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102928:	83 fa 1d             	cmp    $0x1d,%edx
8010292b:	7f 41                	jg     8010296e <log_write+0x5a>
8010292d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102932:	48                   	dec    %eax
80102933:	39 c2                	cmp    %eax,%edx
80102935:	7d 37                	jge    8010296e <log_write+0x5a>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102937:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
8010293e:	7e 3b                	jle    8010297b <log_write+0x67>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	68 80 26 11 80       	push   $0x80112680
80102948:	e8 2a 15 00 00       	call   80103e77 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010294d:	83 c4 10             	add    $0x10,%esp
80102950:	b8 00 00 00 00       	mov    $0x0,%eax
80102955:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010295b:	39 c2                	cmp    %eax,%edx
8010295d:	7e 29                	jle    80102988 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010295f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102962:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102969:	74 1d                	je     80102988 <log_write+0x74>
  for (i = 0; i < log.lh.n; i++) {
8010296b:	40                   	inc    %eax
8010296c:	eb e7                	jmp    80102955 <log_write+0x41>
    panic("too big a transaction");
8010296e:	83 ec 0c             	sub    $0xc,%esp
80102971:	68 53 6f 10 80       	push   $0x80106f53
80102976:	e8 da d9 ff ff       	call   80100355 <panic>
    panic("log_write outside of trans");
8010297b:	83 ec 0c             	sub    $0xc,%esp
8010297e:	68 69 6f 10 80       	push   $0x80106f69
80102983:	e8 cd d9 ff ff       	call   80100355 <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102988:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010298b:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102992:	39 c2                	cmp    %eax,%edx
80102994:	74 18                	je     801029ae <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102996:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	68 80 26 11 80       	push   $0x80112680
801029a1:	e8 3a 15 00 00       	call   80103ee0 <release>
}
801029a6:	83 c4 10             	add    $0x10,%esp
801029a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ac:	c9                   	leave  
801029ad:	c3                   	ret    
    log.lh.n++;
801029ae:	42                   	inc    %edx
801029af:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
801029b5:	eb df                	jmp    80102996 <log_write+0x82>

801029b7 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801029b7:	55                   	push   %ebp
801029b8:	89 e5                	mov    %esp,%ebp
801029ba:	53                   	push   %ebx
801029bb:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801029be:	68 8e 00 00 00       	push   $0x8e
801029c3:	68 8c a4 10 80       	push   $0x8010a48c
801029c8:	68 00 70 00 80       	push   $0x80007000
801029cd:	e8 d7 15 00 00       	call   80103fa9 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801029d2:	83 c4 10             	add    $0x10,%esp
801029d5:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801029da:	eb 47                	jmp    80102a23 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801029dc:	e8 2b f7 ff ff       	call   8010210c <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801029e1:	05 00 10 00 00       	add    $0x1000,%eax
801029e6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029eb:	c7 05 f8 6f 00 80 8b 	movl   $0x80102a8b,0x80006ff8
801029f2:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029f5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801029fc:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801029ff:	83 ec 08             	sub    $0x8,%esp
80102a02:	68 00 70 00 00       	push   $0x7000
80102a07:	0f b6 03             	movzbl (%ebx),%eax
80102a0a:	50                   	push   %eax
80102a0b:	e8 06 fa ff ff       	call   80102416 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a10:	83 c4 10             	add    $0x10,%esp
80102a13:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a19:	85 c0                	test   %eax,%eax
80102a1b:	74 f6                	je     80102a13 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102a1d:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a23:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102a29:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102a2c:	01 c0                	add    %eax,%eax
80102a2e:	01 d0                	add    %edx,%eax
80102a30:	c1 e0 04             	shl    $0x4,%eax
80102a33:	05 80 27 11 80       	add    $0x80112780,%eax
80102a38:	39 d8                	cmp    %ebx,%eax
80102a3a:	76 0b                	jbe    80102a47 <startothers+0x90>
    if(c == mycpu())  // We've started already.
80102a3c:	e8 6e 07 00 00       	call   801031af <mycpu>
80102a41:	39 c3                	cmp    %eax,%ebx
80102a43:	74 d8                	je     80102a1d <startothers+0x66>
80102a45:	eb 95                	jmp    801029dc <startothers+0x25>
      ;
  }
}
80102a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a4a:	c9                   	leave  
80102a4b:	c3                   	ret    

80102a4c <mpmain>:
{
80102a4c:	55                   	push   %ebp
80102a4d:	89 e5                	mov    %esp,%ebp
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a53:	e8 be 07 00 00       	call   80103216 <cpuid>
80102a58:	89 c3                	mov    %eax,%ebx
80102a5a:	e8 b7 07 00 00       	call   80103216 <cpuid>
80102a5f:	83 ec 04             	sub    $0x4,%esp
80102a62:	53                   	push   %ebx
80102a63:	50                   	push   %eax
80102a64:	68 84 6f 10 80       	push   $0x80106f84
80102a69:	e8 8f db ff ff       	call   801005fd <cprintf>
  idtinit();       // load idt register
80102a6e:	e8 f5 27 00 00       	call   80105268 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a73:	e8 37 07 00 00       	call   801031af <mycpu>
80102a78:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a7a:	b8 01 00 00 00       	mov    $0x1,%eax
80102a7f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a86:	e8 29 0c 00 00       	call   801036b4 <scheduler>

80102a8b <mpenter>:
{
80102a8b:	f3 0f 1e fb          	endbr32 
80102a8f:	55                   	push   %ebp
80102a90:	89 e5                	mov    %esp,%ebp
80102a92:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a95:	e8 72 39 00 00       	call   8010640c <switchkvm>
  seginit();
80102a9a:	e8 7a 37 00 00       	call   80106219 <seginit>
  lapicinit();
80102a9f:	e8 1e f8 ff ff       	call   801022c2 <lapicinit>
  mpmain();
80102aa4:	e8 a3 ff ff ff       	call   80102a4c <mpmain>

80102aa9 <main>:
{
80102aa9:	f3 0f 1e fb          	endbr32 
80102aad:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ab1:	83 e4 f0             	and    $0xfffffff0,%esp
80102ab4:	ff 71 fc             	pushl  -0x4(%ecx)
80102ab7:	55                   	push   %ebp
80102ab8:	89 e5                	mov    %esp,%ebp
80102aba:	51                   	push   %ecx
80102abb:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102abe:	68 00 00 40 80       	push   $0x80400000
80102ac3:	68 08 59 11 80       	push   $0x80115908
80102ac8:	e8 e5 f5 ff ff       	call   801020b2 <kinit1>
  kvmalloc();      // kernel page table
80102acd:	e8 e1 3d 00 00       	call   801068b3 <kvmalloc>
  mpinit();        // detect other processors
80102ad2:	e8 b8 01 00 00       	call   80102c8f <mpinit>
  lapicinit();     // interrupt controller
80102ad7:	e8 e6 f7 ff ff       	call   801022c2 <lapicinit>
  seginit();       // segment descriptors
80102adc:	e8 38 37 00 00       	call   80106219 <seginit>
  picinit();       // disable pic
80102ae1:	e8 7d 02 00 00       	call   80102d63 <picinit>
  ioapicinit();    // another interrupt controller
80102ae6:	e8 44 f4 ff ff       	call   80101f2f <ioapicinit>
  consoleinit();   // console hardware
80102aeb:	e8 87 dd ff ff       	call   80100877 <consoleinit>
  uartinit();      // serial port
80102af0:	e8 94 2b 00 00       	call   80105689 <uartinit>
  pinit();         // process table
80102af5:	e8 97 06 00 00       	call   80103191 <pinit>
  tvinit();        // trap vectors
80102afa:	e8 b9 26 00 00       	call   801051b8 <tvinit>
  binit();         // buffer cache
80102aff:	e8 ee d5 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102b04:	e8 0a e1 ff ff       	call   80100c13 <fileinit>
  ideinit();       // disk 
80102b09:	e8 2d f2 ff ff       	call   80101d3b <ideinit>
  startothers();   // start other processors
80102b0e:	e8 a4 fe ff ff       	call   801029b7 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b13:	83 c4 08             	add    $0x8,%esp
80102b16:	68 00 00 00 8e       	push   $0x8e000000
80102b1b:	68 00 00 40 80       	push   $0x80400000
80102b20:	e8 c3 f5 ff ff       	call   801020e8 <kinit2>
  userinit();      // first user process
80102b25:	e8 af 08 00 00       	call   801033d9 <userinit>
  mpmain();        // finish this processor's setup
80102b2a:	e8 1d ff ff ff       	call   80102a4c <mpmain>

80102b2f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b2f:	55                   	push   %ebp
80102b30:	89 e5                	mov    %esp,%ebp
80102b32:	56                   	push   %esi
80102b33:	53                   	push   %ebx
80102b34:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102b36:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
80102b40:	39 d1                	cmp    %edx,%ecx
80102b42:	7d 09                	jge    80102b4d <sum+0x1e>
    sum += addr[i];
80102b44:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102b48:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102b4a:	41                   	inc    %ecx
80102b4b:	eb f3                	jmp    80102b40 <sum+0x11>
  return sum;
}
80102b4d:	5b                   	pop    %ebx
80102b4e:	5e                   	pop    %esi
80102b4f:	5d                   	pop    %ebp
80102b50:	c3                   	ret    

80102b51 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b51:	55                   	push   %ebp
80102b52:	89 e5                	mov    %esp,%ebp
80102b54:	56                   	push   %esi
80102b55:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b56:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102b5c:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102b5e:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b60:	eb 03                	jmp    80102b65 <mpsearch1+0x14>
80102b62:	83 c3 10             	add    $0x10,%ebx
80102b65:	39 f3                	cmp    %esi,%ebx
80102b67:	73 29                	jae    80102b92 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b69:	83 ec 04             	sub    $0x4,%esp
80102b6c:	6a 04                	push   $0x4
80102b6e:	68 98 6f 10 80       	push   $0x80106f98
80102b73:	53                   	push   %ebx
80102b74:	e8 fd 13 00 00       	call   80103f76 <memcmp>
80102b79:	83 c4 10             	add    $0x10,%esp
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	75 e2                	jne    80102b62 <mpsearch1+0x11>
80102b80:	ba 10 00 00 00       	mov    $0x10,%edx
80102b85:	89 d8                	mov    %ebx,%eax
80102b87:	e8 a3 ff ff ff       	call   80102b2f <sum>
80102b8c:	84 c0                	test   %al,%al
80102b8e:	75 d2                	jne    80102b62 <mpsearch1+0x11>
80102b90:	eb 05                	jmp    80102b97 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b92:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b97:	89 d8                	mov    %ebx,%eax
80102b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b9c:	5b                   	pop    %ebx
80102b9d:	5e                   	pop    %esi
80102b9e:	5d                   	pop    %ebp
80102b9f:	c3                   	ret    

80102ba0 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ba6:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102bad:	c1 e0 08             	shl    $0x8,%eax
80102bb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102bb7:	09 d0                	or     %edx,%eax
80102bb9:	c1 e0 04             	shl    $0x4,%eax
80102bbc:	74 1f                	je     80102bdd <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102bbe:	ba 00 04 00 00       	mov    $0x400,%edx
80102bc3:	e8 89 ff ff ff       	call   80102b51 <mpsearch1>
80102bc8:	85 c0                	test   %eax,%eax
80102bca:	75 0f                	jne    80102bdb <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102bcc:	ba 00 00 01 00       	mov    $0x10000,%edx
80102bd1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102bd6:	e8 76 ff ff ff       	call   80102b51 <mpsearch1>
}
80102bdb:	c9                   	leave  
80102bdc:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bdd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102be4:	c1 e0 08             	shl    $0x8,%eax
80102be7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bee:	09 d0                	or     %edx,%eax
80102bf0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102bf3:	2d 00 04 00 00       	sub    $0x400,%eax
80102bf8:	ba 00 04 00 00       	mov    $0x400,%edx
80102bfd:	e8 4f ff ff ff       	call   80102b51 <mpsearch1>
80102c02:	85 c0                	test   %eax,%eax
80102c04:	75 d5                	jne    80102bdb <mpsearch+0x3b>
80102c06:	eb c4                	jmp    80102bcc <mpsearch+0x2c>

80102c08 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102c08:	55                   	push   %ebp
80102c09:	89 e5                	mov    %esp,%ebp
80102c0b:	57                   	push   %edi
80102c0c:	56                   	push   %esi
80102c0d:	53                   	push   %ebx
80102c0e:	83 ec 1c             	sub    $0x1c,%esp
80102c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c14:	e8 87 ff ff ff       	call   80102ba0 <mpsearch>
80102c19:	89 c3                	mov    %eax,%ebx
80102c1b:	85 c0                	test   %eax,%eax
80102c1d:	74 53                	je     80102c72 <mpconfig+0x6a>
80102c1f:	8b 70 04             	mov    0x4(%eax),%esi
80102c22:	85 f6                	test   %esi,%esi
80102c24:	74 50                	je     80102c76 <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c26:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c2c:	83 ec 04             	sub    $0x4,%esp
80102c2f:	6a 04                	push   $0x4
80102c31:	68 9d 6f 10 80       	push   $0x80106f9d
80102c36:	57                   	push   %edi
80102c37:	e8 3a 13 00 00       	call   80103f76 <memcmp>
80102c3c:	83 c4 10             	add    $0x10,%esp
80102c3f:	85 c0                	test   %eax,%eax
80102c41:	75 37                	jne    80102c7a <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102c43:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102c49:	3c 01                	cmp    $0x1,%al
80102c4b:	74 04                	je     80102c51 <mpconfig+0x49>
80102c4d:	3c 04                	cmp    $0x4,%al
80102c4f:	75 30                	jne    80102c81 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102c51:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102c58:	89 f8                	mov    %edi,%eax
80102c5a:	e8 d0 fe ff ff       	call   80102b2f <sum>
80102c5f:	84 c0                	test   %al,%al
80102c61:	75 25                	jne    80102c88 <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c66:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102c68:	89 f8                	mov    %edi,%eax
80102c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6d:	5b                   	pop    %ebx
80102c6e:	5e                   	pop    %esi
80102c6f:	5f                   	pop    %edi
80102c70:	5d                   	pop    %ebp
80102c71:	c3                   	ret    
    return 0;
80102c72:	89 c7                	mov    %eax,%edi
80102c74:	eb f2                	jmp    80102c68 <mpconfig+0x60>
80102c76:	89 f7                	mov    %esi,%edi
80102c78:	eb ee                	jmp    80102c68 <mpconfig+0x60>
    return 0;
80102c7a:	bf 00 00 00 00       	mov    $0x0,%edi
80102c7f:	eb e7                	jmp    80102c68 <mpconfig+0x60>
    return 0;
80102c81:	bf 00 00 00 00       	mov    $0x0,%edi
80102c86:	eb e0                	jmp    80102c68 <mpconfig+0x60>
    return 0;
80102c88:	bf 00 00 00 00       	mov    $0x0,%edi
80102c8d:	eb d9                	jmp    80102c68 <mpconfig+0x60>

80102c8f <mpinit>:

void
mpinit(void)
{
80102c8f:	f3 0f 1e fb          	endbr32 
80102c93:	55                   	push   %ebp
80102c94:	89 e5                	mov    %esp,%ebp
80102c96:	57                   	push   %edi
80102c97:	56                   	push   %esi
80102c98:	53                   	push   %ebx
80102c99:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c9f:	e8 64 ff ff ff       	call   80102c08 <mpconfig>
80102ca4:	85 c0                	test   %eax,%eax
80102ca6:	74 19                	je     80102cc1 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102ca8:	8b 50 24             	mov    0x24(%eax),%edx
80102cab:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cb1:	8d 50 2c             	lea    0x2c(%eax),%edx
80102cb4:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102cb8:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102cba:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cbf:	eb 20                	jmp    80102ce1 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102cc1:	83 ec 0c             	sub    $0xc,%esp
80102cc4:	68 a2 6f 10 80       	push   $0x80106fa2
80102cc9:	e8 87 d6 ff ff       	call   80100355 <panic>
    switch(*p){
80102cce:	bf 00 00 00 00       	mov    $0x0,%edi
80102cd3:	eb 0c                	jmp    80102ce1 <mpinit+0x52>
80102cd5:	83 e8 03             	sub    $0x3,%eax
80102cd8:	3c 01                	cmp    $0x1,%al
80102cda:	76 19                	jbe    80102cf5 <mpinit+0x66>
80102cdc:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ce1:	39 ca                	cmp    %ecx,%edx
80102ce3:	73 4a                	jae    80102d2f <mpinit+0xa0>
    switch(*p){
80102ce5:	8a 02                	mov    (%edx),%al
80102ce7:	3c 02                	cmp    $0x2,%al
80102ce9:	74 37                	je     80102d22 <mpinit+0x93>
80102ceb:	77 e8                	ja     80102cd5 <mpinit+0x46>
80102ced:	84 c0                	test   %al,%al
80102cef:	74 09                	je     80102cfa <mpinit+0x6b>
80102cf1:	3c 01                	cmp    $0x1,%al
80102cf3:	75 d9                	jne    80102cce <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102cf5:	83 c2 08             	add    $0x8,%edx
      continue;
80102cf8:	eb e7                	jmp    80102ce1 <mpinit+0x52>
      if(ncpu < NCPU) {
80102cfa:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102cff:	83 f8 07             	cmp    $0x7,%eax
80102d02:	7f 19                	jg     80102d1d <mpinit+0x8e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d04:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102d07:	01 f6                	add    %esi,%esi
80102d09:	01 c6                	add    %eax,%esi
80102d0b:	c1 e6 04             	shl    $0x4,%esi
80102d0e:	8a 5a 01             	mov    0x1(%edx),%bl
80102d11:	88 9e 80 27 11 80    	mov    %bl,-0x7feed880(%esi)
        ncpu++;
80102d17:	40                   	inc    %eax
80102d18:	a3 00 2d 11 80       	mov    %eax,0x80112d00
      p += sizeof(struct mpproc);
80102d1d:	83 c2 14             	add    $0x14,%edx
      continue;
80102d20:	eb bf                	jmp    80102ce1 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102d22:	8a 42 01             	mov    0x1(%edx),%al
80102d25:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102d2a:	83 c2 08             	add    $0x8,%edx
      continue;
80102d2d:	eb b2                	jmp    80102ce1 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d2f:	85 ff                	test   %edi,%edi
80102d31:	74 23                	je     80102d56 <mpinit+0xc7>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d36:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d3a:	74 12                	je     80102d4e <mpinit+0xbf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	b0 70                	mov    $0x70,%al
80102d3e:	ba 22 00 00 00       	mov    $0x22,%edx
80102d43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	ba 23 00 00 00       	mov    $0x23,%edx
80102d49:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d4a:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4d:	ee                   	out    %al,(%dx)
  }
}
80102d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d51:	5b                   	pop    %ebx
80102d52:	5e                   	pop    %esi
80102d53:	5f                   	pop    %edi
80102d54:	5d                   	pop    %ebp
80102d55:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 bc 6f 10 80       	push   $0x80106fbc
80102d5e:	e8 f2 d5 ff ff       	call   80100355 <panic>

80102d63 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d63:	f3 0f 1e fb          	endbr32 
80102d67:	b0 ff                	mov    $0xff,%al
80102d69:	ba 21 00 00 00       	mov    $0x21,%edx
80102d6e:	ee                   	out    %al,(%dx)
80102d6f:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d74:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d75:	c3                   	ret    

80102d76 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d76:	f3 0f 1e fb          	endbr32 
80102d7a:	55                   	push   %ebp
80102d7b:	89 e5                	mov    %esp,%ebp
80102d7d:	57                   	push   %edi
80102d7e:	56                   	push   %esi
80102d7f:	53                   	push   %ebx
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d86:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d89:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d95:	e8 97 de ff ff       	call   80100c31 <filealloc>
80102d9a:	89 03                	mov    %eax,(%ebx)
80102d9c:	85 c0                	test   %eax,%eax
80102d9e:	0f 84 88 00 00 00    	je     80102e2c <pipealloc+0xb6>
80102da4:	e8 88 de ff ff       	call   80100c31 <filealloc>
80102da9:	89 06                	mov    %eax,(%esi)
80102dab:	85 c0                	test   %eax,%eax
80102dad:	74 7d                	je     80102e2c <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102daf:	e8 58 f3 ff ff       	call   8010210c <kalloc>
80102db4:	89 c7                	mov    %eax,%edi
80102db6:	85 c0                	test   %eax,%eax
80102db8:	74 72                	je     80102e2c <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102dba:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102dc1:	00 00 00 
  p->writeopen = 1;
80102dc4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102dcb:	00 00 00 
  p->nwrite = 0;
80102dce:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102dd5:	00 00 00 
  p->nread = 0;
80102dd8:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ddf:	00 00 00 
  initlock(&p->lock, "pipe");
80102de2:	83 ec 08             	sub    $0x8,%esp
80102de5:	68 db 6f 10 80       	push   $0x80106fdb
80102dea:	50                   	push   %eax
80102deb:	e8 3c 0f 00 00       	call   80103d2c <initlock>
  (*f0)->type = FD_PIPE;
80102df0:	8b 03                	mov    (%ebx),%eax
80102df2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102df8:	8b 03                	mov    (%ebx),%eax
80102dfa:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102dfe:	8b 03                	mov    (%ebx),%eax
80102e00:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e04:	8b 03                	mov    (%ebx),%eax
80102e06:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e09:	8b 06                	mov    (%esi),%eax
80102e0b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e11:	8b 06                	mov    (%esi),%eax
80102e13:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e17:	8b 06                	mov    (%esi),%eax
80102e19:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e1d:	8b 06                	mov    (%esi),%eax
80102e1f:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e22:	83 c4 10             	add    $0x10,%esp
80102e25:	b8 00 00 00 00       	mov    $0x0,%eax
80102e2a:	eb 29                	jmp    80102e55 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e2c:	8b 03                	mov    (%ebx),%eax
80102e2e:	85 c0                	test   %eax,%eax
80102e30:	74 0c                	je     80102e3e <pipealloc+0xc8>
    fileclose(*f0);
80102e32:	83 ec 0c             	sub    $0xc,%esp
80102e35:	50                   	push   %eax
80102e36:	e8 a2 de ff ff       	call   80100cdd <fileclose>
80102e3b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102e3e:	8b 06                	mov    (%esi),%eax
80102e40:	85 c0                	test   %eax,%eax
80102e42:	74 19                	je     80102e5d <pipealloc+0xe7>
    fileclose(*f1);
80102e44:	83 ec 0c             	sub    $0xc,%esp
80102e47:	50                   	push   %eax
80102e48:	e8 90 de ff ff       	call   80100cdd <fileclose>
80102e4d:	83 c4 10             	add    $0x10,%esp
  return -1;
80102e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e58:	5b                   	pop    %ebx
80102e59:	5e                   	pop    %esi
80102e5a:	5f                   	pop    %edi
80102e5b:	5d                   	pop    %ebp
80102e5c:	c3                   	ret    
  return -1;
80102e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e62:	eb f1                	jmp    80102e55 <pipealloc+0xdf>

80102e64 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e64:	f3 0f 1e fb          	endbr32 
80102e68:	55                   	push   %ebp
80102e69:	89 e5                	mov    %esp,%ebp
80102e6b:	53                   	push   %ebx
80102e6c:	83 ec 10             	sub    $0x10,%esp
80102e6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102e72:	53                   	push   %ebx
80102e73:	e8 ff 0f 00 00       	call   80103e77 <acquire>
  if(writable){
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e7f:	74 3f                	je     80102ec0 <pipeclose+0x5c>
    p->writeopen = 0;
80102e81:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e88:	00 00 00 
    wakeup(&p->nread);
80102e8b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e91:	83 ec 0c             	sub    $0xc,%esp
80102e94:	50                   	push   %eax
80102e95:	e8 0d 0c 00 00       	call   80103aa7 <wakeup>
80102e9a:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e9d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ea4:	75 09                	jne    80102eaf <pipeclose+0x4b>
80102ea6:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102ead:	74 2f                	je     80102ede <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102eaf:	83 ec 0c             	sub    $0xc,%esp
80102eb2:	53                   	push   %ebx
80102eb3:	e8 28 10 00 00       	call   80103ee0 <release>
80102eb8:	83 c4 10             	add    $0x10,%esp
}
80102ebb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ebe:	c9                   	leave  
80102ebf:	c3                   	ret    
    p->readopen = 0;
80102ec0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102ec7:	00 00 00 
    wakeup(&p->nwrite);
80102eca:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	50                   	push   %eax
80102ed4:	e8 ce 0b 00 00       	call   80103aa7 <wakeup>
80102ed9:	83 c4 10             	add    $0x10,%esp
80102edc:	eb bf                	jmp    80102e9d <pipeclose+0x39>
    release(&p->lock);
80102ede:	83 ec 0c             	sub    $0xc,%esp
80102ee1:	53                   	push   %ebx
80102ee2:	e8 f9 0f 00 00       	call   80103ee0 <release>
    kfree((char*)p);
80102ee7:	89 1c 24             	mov    %ebx,(%esp)
80102eea:	e8 f6 f0 ff ff       	call   80101fe5 <kfree>
80102eef:	83 c4 10             	add    $0x10,%esp
80102ef2:	eb c7                	jmp    80102ebb <pipeclose+0x57>

80102ef4 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102ef4:	f3 0f 1e fb          	endbr32 
80102ef8:	55                   	push   %ebp
80102ef9:	89 e5                	mov    %esp,%ebp
80102efb:	57                   	push   %edi
80102efc:	56                   	push   %esi
80102efd:	53                   	push   %ebx
80102efe:	83 ec 28             	sub    $0x28,%esp
80102f01:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102f04:	89 de                	mov    %ebx,%esi
80102f06:	53                   	push   %ebx
80102f07:	e8 6b 0f 00 00       	call   80103e77 <acquire>
  for(i = 0; i < n; i++){
80102f0c:	83 c4 10             	add    $0x10,%esp
80102f0f:	bf 00 00 00 00       	mov    $0x0,%edi
80102f14:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f17:	7c 41                	jl     80102f5a <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f19:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f1f:	83 ec 0c             	sub    $0xc,%esp
80102f22:	50                   	push   %eax
80102f23:	e8 7f 0b 00 00       	call   80103aa7 <wakeup>
  release(&p->lock);
80102f28:	89 1c 24             	mov    %ebx,(%esp)
80102f2b:	e8 b0 0f 00 00       	call   80103ee0 <release>
  return n;
80102f30:	83 c4 10             	add    $0x10,%esp
80102f33:	8b 45 10             	mov    0x10(%ebp),%eax
80102f36:	eb 5c                	jmp    80102f94 <pipewrite+0xa0>
      wakeup(&p->nread);
80102f38:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	50                   	push   %eax
80102f42:	e8 60 0b 00 00       	call   80103aa7 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f47:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f4d:	83 c4 08             	add    $0x8,%esp
80102f50:	56                   	push   %esi
80102f51:	50                   	push   %eax
80102f52:	e8 c3 09 00 00       	call   8010391a <sleep>
80102f57:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f5a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102f60:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f66:	05 00 02 00 00       	add    $0x200,%eax
80102f6b:	39 c2                	cmp    %eax,%edx
80102f6d:	75 2d                	jne    80102f9c <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80102f6f:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f76:	74 0b                	je     80102f83 <pipewrite+0x8f>
80102f78:	e8 ce 02 00 00       	call   8010324b <myproc>
80102f7d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f81:	74 b5                	je     80102f38 <pipewrite+0x44>
        release(&p->lock);
80102f83:	83 ec 0c             	sub    $0xc,%esp
80102f86:	53                   	push   %ebx
80102f87:	e8 54 0f 00 00       	call   80103ee0 <release>
        return -1;
80102f8c:	83 c4 10             	add    $0x10,%esp
80102f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f97:	5b                   	pop    %ebx
80102f98:	5e                   	pop    %esi
80102f99:	5f                   	pop    %edi
80102f9a:	5d                   	pop    %ebp
80102f9b:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f9c:	8d 42 01             	lea    0x1(%edx),%eax
80102f9f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102fa5:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102fab:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fae:	8a 04 38             	mov    (%eax,%edi,1),%al
80102fb1:	88 45 e7             	mov    %al,-0x19(%ebp)
80102fb4:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102fb8:	47                   	inc    %edi
80102fb9:	e9 56 ff ff ff       	jmp    80102f14 <pipewrite+0x20>

80102fbe <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102fbe:	f3 0f 1e fb          	endbr32 
80102fc2:	55                   	push   %ebp
80102fc3:	89 e5                	mov    %esp,%ebp
80102fc5:	57                   	push   %edi
80102fc6:	56                   	push   %esi
80102fc7:	53                   	push   %ebx
80102fc8:	83 ec 18             	sub    $0x18,%esp
80102fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fce:	89 df                	mov    %ebx,%edi
80102fd0:	53                   	push   %ebx
80102fd1:	e8 a1 0e 00 00       	call   80103e77 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fd6:	83 c4 10             	add    $0x10,%esp
80102fd9:	eb 13                	jmp    80102fee <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fdb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fe1:	83 ec 08             	sub    $0x8,%esp
80102fe4:	57                   	push   %edi
80102fe5:	50                   	push   %eax
80102fe6:	e8 2f 09 00 00       	call   8010391a <sleep>
80102feb:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fee:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102ff4:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102ffa:	75 28                	jne    80103024 <piperead+0x66>
80102ffc:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103002:	85 f6                	test   %esi,%esi
80103004:	74 23                	je     80103029 <piperead+0x6b>
    if(myproc()->killed){
80103006:	e8 40 02 00 00       	call   8010324b <myproc>
8010300b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010300f:	74 ca                	je     80102fdb <piperead+0x1d>
      release(&p->lock);
80103011:	83 ec 0c             	sub    $0xc,%esp
80103014:	53                   	push   %ebx
80103015:	e8 c6 0e 00 00       	call   80103ee0 <release>
      return -1;
8010301a:	83 c4 10             	add    $0x10,%esp
8010301d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103022:	eb 4d                	jmp    80103071 <piperead+0xb3>
80103024:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103029:	3b 75 10             	cmp    0x10(%ebp),%esi
8010302c:	7d 29                	jge    80103057 <piperead+0x99>
    if(p->nread == p->nwrite)
8010302e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103034:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010303a:	74 1b                	je     80103057 <piperead+0x99>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010303c:	8d 50 01             	lea    0x1(%eax),%edx
8010303f:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103045:	25 ff 01 00 00       	and    $0x1ff,%eax
8010304a:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
8010304e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103051:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103054:	46                   	inc    %esi
80103055:	eb d2                	jmp    80103029 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103057:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010305d:	83 ec 0c             	sub    $0xc,%esp
80103060:	50                   	push   %eax
80103061:	e8 41 0a 00 00       	call   80103aa7 <wakeup>
  release(&p->lock);
80103066:	89 1c 24             	mov    %ebx,(%esp)
80103069:	e8 72 0e 00 00       	call   80103ee0 <release>
  return i;
8010306e:	83 c4 10             	add    $0x10,%esp
}
80103071:	89 f0                	mov    %esi,%eax
80103073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103076:	5b                   	pop    %ebx
80103077:	5e                   	pop    %esi
80103078:	5f                   	pop    %edi
80103079:	5d                   	pop    %ebp
8010307a:	c3                   	ret    

8010307b <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010307b:	55                   	push   %ebp
8010307c:	89 e5                	mov    %esp,%ebp
8010307e:	53                   	push   %ebx
8010307f:	83 ec 10             	sub    $0x10,%esp
  //ptable no solo contiene la tabla de procesos, es un struct que tiene un lock y la propia tabla
  struct proc *p;
  char *sp;

  acquire(&ptable.lock); //Cerrojo para exclusion mutua
80103082:	68 20 2d 11 80       	push   $0x80112d20
80103087:	e8 eb 0d 00 00       	call   80103e77 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) //Busca el primer proceso(PID) libre
8010308c:	83 c4 10             	add    $0x10,%esp
8010308f:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103094:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010309a:	0f 83 88 00 00 00    	jae    80103128 <allocproc+0xad>
    if(p->state == UNUSED)
801030a0:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801030a4:	74 08                	je     801030ae <allocproc+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) //Busca el primer proceso(PID) libre
801030a6:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801030ac:	eb e6                	jmp    80103094 <allocproc+0x19>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO; //Pone el estado del nuevo proceso en embrion
801030ae:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++; //nextpid almacena el último PID usado
801030b5:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801030ba:	8d 50 01             	lea    0x1(%eax),%edx
801030bd:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801030c3:	89 43 10             	mov    %eax,0x10(%ebx)
  p->prio_level = 5; // Asigna prioridad 5 al nuevo proceso
801030c6:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
801030cd:	00 00 00 

  release(&ptable.lock);
801030d0:	83 ec 0c             	sub    $0xc,%esp
801030d3:	68 20 2d 11 80       	push   $0x80112d20
801030d8:	e8 03 0e 00 00       	call   80103ee0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){ //Busca una pagina libre en el kernel
801030dd:	e8 2a f0 ff ff       	call   8010210c <kalloc>
801030e2:	89 43 08             	mov    %eax,0x8(%ebx)
801030e5:	83 c4 10             	add    $0x10,%esp
801030e8:	85 c0                	test   %eax,%eax
801030ea:	74 53                	je     8010313f <allocproc+0xc4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE; //Final de la pagina del kernel

  // Leave room for trap frame.
  sp -= sizeof *p->tf; //puntero para el trap frame
801030ec:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp; //Guarda el puntero en tf
801030f2:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret; //Trapret es la llamada para vaciar le trapframe
801030f5:	c7 80 b0 0f 00 00 ad 	movl   $0x801051ad,0xfb0(%eax)
801030fc:	51 10 80 

  sp -= sizeof *p->context; //Puntero para el contexto(para movernos dentro de los hilos del kernel)
801030ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103104:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103107:	83 ec 04             	sub    $0x4,%esp
8010310a:	6a 14                	push   $0x14
8010310c:	6a 00                	push   $0x0
8010310e:	50                   	push   %eax
8010310f:	e8 17 0e 00 00       	call   80103f2b <memset>
  p->context->eip = (uint)forkret;
80103114:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103117:	c7 40 10 4a 31 10 80 	movl   $0x8010314a,0x10(%eax)

  return p;
8010311e:	83 c4 10             	add    $0x10,%esp
}
80103121:	89 d8                	mov    %ebx,%eax
80103123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103126:	c9                   	leave  
80103127:	c3                   	ret    
  release(&ptable.lock);
80103128:	83 ec 0c             	sub    $0xc,%esp
8010312b:	68 20 2d 11 80       	push   $0x80112d20
80103130:	e8 ab 0d 00 00       	call   80103ee0 <release>
  return 0;
80103135:	83 c4 10             	add    $0x10,%esp
80103138:	bb 00 00 00 00       	mov    $0x0,%ebx
8010313d:	eb e2                	jmp    80103121 <allocproc+0xa6>
    p->state = UNUSED;
8010313f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103146:	89 c3                	mov    %eax,%ebx
80103148:	eb d7                	jmp    80103121 <allocproc+0xa6>

8010314a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010314a:	f3 0f 1e fb          	endbr32 
8010314e:	55                   	push   %ebp
8010314f:	89 e5                	mov    %esp,%ebp
80103151:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103154:	68 20 2d 11 80       	push   $0x80112d20
80103159:	e8 82 0d 00 00       	call   80103ee0 <release>

  if (first) {
8010315e:	83 c4 10             	add    $0x10,%esp
80103161:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103168:	75 02                	jne    8010316c <forkret+0x22>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010316a:	c9                   	leave  
8010316b:	c3                   	ret    
    first = 0;
8010316c:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103173:	00 00 00 
    iinit(ROOTDEV);
80103176:	83 ec 0c             	sub    $0xc,%esp
80103179:	6a 01                	push   $0x1
8010317b:	e8 7e e1 ff ff       	call   801012fe <iinit>
    initlog(ROOTDEV);
80103180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103187:	e8 0a f6 ff ff       	call   80102796 <initlog>
8010318c:	83 c4 10             	add    $0x10,%esp
}
8010318f:	eb d9                	jmp    8010316a <forkret+0x20>

80103191 <pinit>:
{
80103191:	f3 0f 1e fb          	endbr32 
80103195:	55                   	push   %ebp
80103196:	89 e5                	mov    %esp,%ebp
80103198:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010319b:	68 e0 6f 10 80       	push   $0x80106fe0
801031a0:	68 20 2d 11 80       	push   $0x80112d20
801031a5:	e8 82 0b 00 00       	call   80103d2c <initlock>
}
801031aa:	83 c4 10             	add    $0x10,%esp
801031ad:	c9                   	leave  
801031ae:	c3                   	ret    

801031af <mycpu>:
{
801031af:	f3 0f 1e fb          	endbr32 
801031b3:	55                   	push   %ebp
801031b4:	89 e5                	mov    %esp,%ebp
801031b6:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031b9:	9c                   	pushf  
801031ba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801031bb:	f6 c4 02             	test   $0x2,%ah
801031be:	75 2a                	jne    801031ea <mycpu+0x3b>
  apicid = lapicid();
801031c0:	e8 0d f2 ff ff       	call   801023d2 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801031c5:	b9 00 00 00 00       	mov    $0x0,%ecx
801031ca:	39 0d 00 2d 11 80    	cmp    %ecx,0x80112d00
801031d0:	7e 37                	jle    80103209 <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801031d2:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801031d5:	01 d2                	add    %edx,%edx
801031d7:	01 ca                	add    %ecx,%edx
801031d9:	c1 e2 04             	shl    $0x4,%edx
801031dc:	0f b6 92 80 27 11 80 	movzbl -0x7feed880(%edx),%edx
801031e3:	39 c2                	cmp    %eax,%edx
801031e5:	74 10                	je     801031f7 <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
801031e7:	41                   	inc    %ecx
801031e8:	eb e0                	jmp    801031ca <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
801031ea:	83 ec 0c             	sub    $0xc,%esp
801031ed:	68 d4 70 10 80       	push   $0x801070d4
801031f2:	e8 5e d1 ff ff       	call   80100355 <panic>
      return &cpus[i];
801031f7:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
801031fa:	01 c0                	add    %eax,%eax
801031fc:	01 c8                	add    %ecx,%eax
801031fe:	c1 e0 04             	shl    $0x4,%eax
80103201:	8d 80 80 27 11 80    	lea    -0x7feed880(%eax),%eax
}
80103207:	c9                   	leave  
80103208:	c3                   	ret    
  panic("unknown apicid\n");
80103209:	83 ec 0c             	sub    $0xc,%esp
8010320c:	68 e7 6f 10 80       	push   $0x80106fe7
80103211:	e8 3f d1 ff ff       	call   80100355 <panic>

80103216 <cpuid>:
cpuid() {
80103216:	f3 0f 1e fb          	endbr32 
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103220:	e8 8a ff ff ff       	call   801031af <mycpu>
80103225:	2d 80 27 11 80       	sub    $0x80112780,%eax
8010322a:	c1 f8 04             	sar    $0x4,%eax
8010322d:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103230:	89 ca                	mov    %ecx,%edx
80103232:	c1 e2 05             	shl    $0x5,%edx
80103235:	29 ca                	sub    %ecx,%edx
80103237:	8d 14 90             	lea    (%eax,%edx,4),%edx
8010323a:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010323d:	89 ca                	mov    %ecx,%edx
8010323f:	c1 e2 0f             	shl    $0xf,%edx
80103242:	29 ca                	sub    %ecx,%edx
80103244:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103247:	f7 d8                	neg    %eax
}
80103249:	c9                   	leave  
8010324a:	c3                   	ret    

8010324b <myproc>:
myproc(void) {
8010324b:	f3 0f 1e fb          	endbr32 
8010324f:	55                   	push   %ebp
80103250:	89 e5                	mov    %esp,%ebp
80103252:	53                   	push   %ebx
80103253:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103256:	e8 34 0b 00 00       	call   80103d8f <pushcli>
  c = mycpu();
8010325b:	e8 4f ff ff ff       	call   801031af <mycpu>
  p = c->proc;
80103260:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103266:	e8 64 0b 00 00       	call   80103dcf <popcli>
}
8010326b:	89 d8                	mov    %ebx,%eax
8010326d:	83 c4 04             	add    $0x4,%esp
80103270:	5b                   	pop    %ebx
80103271:	5d                   	pop    %ebp
80103272:	c3                   	ret    

80103273 <remove_beggining>:
{
80103273:	f3 0f 1e fb          	endbr32 
80103277:	55                   	push   %ebp
80103278:	89 e5                	mov    %esp,%ebp
8010327a:	8b 45 08             	mov    0x8(%ebp),%eax
  if (ptable.priority_list[level].first_proc->pid == ptable.priority_list[level].last_proc->pid) { // There was only one process in queue, now is empty
8010327d:	8d 90 66 04 00 00    	lea    0x466(%eax),%edx
80103283:	8b 0c d5 24 2d 11 80 	mov    -0x7feed2dc(,%edx,8),%ecx
8010328a:	8b 14 d5 28 2d 11 80 	mov    -0x7feed2d8(,%edx,8),%edx
80103291:	8b 52 10             	mov    0x10(%edx),%edx
80103294:	39 51 10             	cmp    %edx,0x10(%ecx)
80103297:	74 0f                	je     801032a8 <remove_beggining+0x35>
    ptable.priority_list[level].first_proc = ptable.priority_list[level].first_proc->next_proc;
80103299:	8b 91 84 00 00 00    	mov    0x84(%ecx),%edx
8010329f:	89 14 c5 54 50 11 80 	mov    %edx,-0x7feeafac(,%eax,8)
}
801032a6:	5d                   	pop    %ebp
801032a7:	c3                   	ret    
    ptable.priority_list[level].first_proc = NULL;
801032a8:	05 66 04 00 00       	add    $0x466,%eax
801032ad:	c7 04 c5 24 2d 11 80 	movl   $0x0,-0x7feed2dc(,%eax,8)
801032b4:	00 00 00 00 
    ptable.priority_list[level].last_proc  = NULL;
801032b8:	c7 04 c5 28 2d 11 80 	movl   $0x0,-0x7feed2d8(,%eax,8)
801032bf:	00 00 00 00 
801032c3:	eb e1                	jmp    801032a6 <remove_beggining+0x33>

801032c5 <insert_end>:
{
801032c5:	f3 0f 1e fb          	endbr32 
801032c9:	55                   	push   %ebp
801032ca:	89 e5                	mov    %esp,%ebp
801032cc:	8b 55 08             	mov    0x8(%ebp),%edx
  int level = p->prio_level;
801032cf:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  if (ptable.priority_list[level].first_proc == NULL) { //Queue is empty
801032d5:	83 3c c5 54 50 11 80 	cmpl   $0x0,-0x7feeafac(,%eax,8)
801032dc:	00 
801032dd:	74 25                	je     80103304 <insert_end+0x3f>
    ptable.priority_list[level].last_proc->next_proc = p;
801032df:	05 66 04 00 00       	add    $0x466,%eax
801032e4:	8b 0c c5 28 2d 11 80 	mov    -0x7feed2d8(,%eax,8),%ecx
801032eb:	89 91 84 00 00 00    	mov    %edx,0x84(%ecx)
    p->next_proc = NULL;
801032f1:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801032f8:	00 00 00 
    ptable.priority_list[level].last_proc = p;
801032fb:	89 14 c5 28 2d 11 80 	mov    %edx,-0x7feed2d8(,%eax,8)
}
80103302:	5d                   	pop    %ebp
80103303:	c3                   	ret    
    ptable.priority_list[level].first_proc = p;
80103304:	05 66 04 00 00       	add    $0x466,%eax
80103309:	89 14 c5 24 2d 11 80 	mov    %edx,-0x7feed2dc(,%eax,8)
    ptable.priority_list[level].last_proc = p;
80103310:	89 14 c5 28 2d 11 80 	mov    %edx,-0x7feed2d8(,%eax,8)
    p->next_proc = NULL;
80103317:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
8010331e:	00 00 00 
80103321:	eb df                	jmp    80103302 <insert_end+0x3d>

80103323 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103323:	55                   	push   %ebp
80103324:	89 e5                	mov    %esp,%ebp
80103326:	56                   	push   %esi
80103327:	53                   	push   %ebx
80103328:	89 c6                	mov    %eax,%esi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010332a:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010332f:	eb 06                	jmp    80103337 <wakeup1+0x14>
80103331:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103337:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010333d:	73 20                	jae    8010335f <wakeup1+0x3c>
    if(p->state == SLEEPING && p->chan == chan){
8010333f:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103343:	75 ec                	jne    80103331 <wakeup1+0xe>
80103345:	39 73 20             	cmp    %esi,0x20(%ebx)
80103348:	75 e7                	jne    80103331 <wakeup1+0xe>
      p->state = RUNNABLE;
8010334a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      insert_end(p);
80103351:	83 ec 0c             	sub    $0xc,%esp
80103354:	53                   	push   %ebx
80103355:	e8 6b ff ff ff       	call   801032c5 <insert_end>
8010335a:	83 c4 10             	add    $0x10,%esp
8010335d:	eb d2                	jmp    80103331 <wakeup1+0xe>
    }
}
8010335f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103362:	5b                   	pop    %ebx
80103363:	5e                   	pop    %esi
80103364:	5d                   	pop    %ebp
80103365:	c3                   	ret    

80103366 <getprio>:
{
80103366:	f3 0f 1e fb          	endbr32 
8010336a:	55                   	push   %ebp
8010336b:	89 e5                	mov    %esp,%ebp
8010336d:	8b 55 08             	mov    0x8(%ebp),%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103370:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103375:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010337a:	73 14                	jae    80103390 <getprio+0x2a>
    if (p->pid == pid)
8010337c:	39 50 10             	cmp    %edx,0x10(%eax)
8010337f:	74 07                	je     80103388 <getprio+0x22>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103381:	05 8c 00 00 00       	add    $0x8c,%eax
80103386:	eb ed                	jmp    80103375 <getprio+0xf>
      return p->prio_level;
80103388:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010338e:	5d                   	pop    %ebp
8010338f:	c3                   	ret    
  return -1;
80103390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103395:	eb f7                	jmp    8010338e <getprio+0x28>

80103397 <setprio>:
{
80103397:	f3 0f 1e fb          	endbr32 
8010339b:	55                   	push   %ebp
8010339c:	89 e5                	mov    %esp,%ebp
8010339e:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (proc_prio < 0 || proc_prio > 9)
801033a4:	83 f8 09             	cmp    $0x9,%eax
801033a7:	77 29                	ja     801033d2 <setprio+0x3b>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801033a9:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801033ae:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
801033b4:	73 15                	jae    801033cb <setprio+0x34>
    if (p->pid == pid){
801033b6:	39 4a 10             	cmp    %ecx,0x10(%edx)
801033b9:	74 08                	je     801033c3 <setprio+0x2c>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801033bb:	81 c2 8c 00 00 00    	add    $0x8c,%edx
801033c1:	eb eb                	jmp    801033ae <setprio+0x17>
      p->prio_level = proc_prio;
801033c3:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
}
801033c9:	5d                   	pop    %ebp
801033ca:	c3                   	ret    
  return -1;
801033cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d0:	eb f7                	jmp    801033c9 <setprio+0x32>
    return -1;
801033d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d7:	eb f0                	jmp    801033c9 <setprio+0x32>

801033d9 <userinit>:
{
801033d9:	f3 0f 1e fb          	endbr32 
801033dd:	55                   	push   %ebp
801033de:	89 e5                	mov    %esp,%ebp
801033e0:	53                   	push   %ebx
801033e1:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801033e4:	e8 92 fc ff ff       	call   8010307b <allocproc>
801033e9:	89 c3                	mov    %eax,%ebx
  initproc = p;
801033eb:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801033f0:	e8 4a 34 00 00       	call   8010683f <setupkvm>
801033f5:	89 43 04             	mov    %eax,0x4(%ebx)
801033f8:	85 c0                	test   %eax,%eax
801033fa:	0f 84 db 00 00 00    	je     801034db <userinit+0x102>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103400:	83 ec 04             	sub    $0x4,%esp
80103403:	68 2c 00 00 00       	push   $0x2c
80103408:	68 60 a4 10 80       	push   $0x8010a460
8010340d:	50                   	push   %eax
8010340e:	e8 24 31 00 00       	call   80106537 <inituvm>
  p->sz = PGSIZE;
80103413:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103419:	8b 43 18             	mov    0x18(%ebx),%eax
8010341c:	83 c4 0c             	add    $0xc,%esp
8010341f:	6a 4c                	push   $0x4c
80103421:	6a 00                	push   $0x0
80103423:	50                   	push   %eax
80103424:	e8 02 0b 00 00       	call   80103f2b <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103429:	8b 43 18             	mov    0x18(%ebx),%eax
8010342c:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103432:	8b 43 18             	mov    0x18(%ebx),%eax
80103435:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010343b:	8b 43 18             	mov    0x18(%ebx),%eax
8010343e:	8b 50 2c             	mov    0x2c(%eax),%edx
80103441:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103445:	8b 43 18             	mov    0x18(%ebx),%eax
80103448:	8b 50 2c             	mov    0x2c(%eax),%edx
8010344b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010344f:	8b 43 18             	mov    0x18(%ebx),%eax
80103452:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103459:	8b 43 18             	mov    0x18(%ebx),%eax
8010345c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103463:	8b 43 18             	mov    0x18(%ebx),%eax
80103466:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010346d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103470:	83 c4 0c             	add    $0xc,%esp
80103473:	6a 10                	push   $0x10
80103475:	68 10 70 10 80       	push   $0x80107010
8010347a:	50                   	push   %eax
8010347b:	e8 17 0c 00 00       	call   80104097 <safestrcpy>
  p->cwd = namei("/");
80103480:	c7 04 24 19 70 10 80 	movl   $0x80107019,(%esp)
80103487:	e8 96 e7 ff ff       	call   80101c22 <namei>
8010348c:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010348f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103496:	e8 dc 09 00 00       	call   80103e77 <acquire>
  p->state = RUNNABLE;
8010349b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  insert_end(p);
801034a2:	89 1c 24             	mov    %ebx,(%esp)
801034a5:	e8 1b fe ff ff       	call   801032c5 <insert_end>
  if (ptable.priority_list[5].first_proc != NULL)
801034aa:	83 c4 10             	add    $0x10,%esp
801034ad:	83 3d 7c 50 11 80 00 	cmpl   $0x0,0x8011507c
801034b4:	74 10                	je     801034c6 <userinit+0xed>
    cprintf("out of memory?\n");
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	68 1b 70 10 80       	push   $0x8010701b
801034be:	e8 3a d1 ff ff       	call   801005fd <cprintf>
801034c3:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	68 20 2d 11 80       	push   $0x80112d20
801034ce:	e8 0d 0a 00 00       	call   80103ee0 <release>
}
801034d3:	83 c4 10             	add    $0x10,%esp
801034d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034d9:	c9                   	leave  
801034da:	c3                   	ret    
    panic("userinit: out of memory?");
801034db:	83 ec 0c             	sub    $0xc,%esp
801034de:	68 f7 6f 10 80       	push   $0x80106ff7
801034e3:	e8 6d ce ff ff       	call   80100355 <panic>

801034e8 <growproc>:
{
801034e8:	f3 0f 1e fb          	endbr32 
801034ec:	55                   	push   %ebp
801034ed:	89 e5                	mov    %esp,%ebp
801034ef:	56                   	push   %esi
801034f0:	53                   	push   %ebx
801034f1:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801034f4:	e8 52 fd ff ff       	call   8010324b <myproc>
801034f9:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801034fb:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801034fd:	85 f6                	test   %esi,%esi
801034ff:	7f 1b                	jg     8010351c <growproc+0x34>
  } else if(n < 0){
80103501:	78 36                	js     80103539 <growproc+0x51>
  curproc->sz = sz;
80103503:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
80103505:	8b 43 04             	mov    0x4(%ebx),%eax
80103508:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010350d:	0f 22 d8             	mov    %eax,%cr3
  return 0;
80103510:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103515:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103518:	5b                   	pop    %ebx
80103519:	5e                   	pop    %esi
8010351a:	5d                   	pop    %ebp
8010351b:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010351c:	83 ec 04             	sub    $0x4,%esp
8010351f:	01 c6                	add    %eax,%esi
80103521:	56                   	push   %esi
80103522:	50                   	push   %eax
80103523:	ff 73 04             	pushl  0x4(%ebx)
80103526:	e8 aa 31 00 00       	call   801066d5 <allocuvm>
8010352b:	83 c4 10             	add    $0x10,%esp
8010352e:	85 c0                	test   %eax,%eax
80103530:	75 d1                	jne    80103503 <growproc+0x1b>
      return -1;
80103532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103537:	eb dc                	jmp    80103515 <growproc+0x2d>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103539:	83 ec 04             	sub    $0x4,%esp
8010353c:	01 c6                	add    %eax,%esi
8010353e:	56                   	push   %esi
8010353f:	50                   	push   %eax
80103540:	ff 73 04             	pushl  0x4(%ebx)
80103543:	e8 f9 30 00 00       	call   80106641 <deallocuvm>
80103548:	83 c4 10             	add    $0x10,%esp
8010354b:	85 c0                	test   %eax,%eax
8010354d:	75 b4                	jne    80103503 <growproc+0x1b>
      return -1;
8010354f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103554:	eb bf                	jmp    80103515 <growproc+0x2d>

80103556 <fork>:
{
80103556:	f3 0f 1e fb          	endbr32 
8010355a:	55                   	push   %ebp
8010355b:	89 e5                	mov    %esp,%ebp
8010355d:	57                   	push   %edi
8010355e:	56                   	push   %esi
8010355f:	53                   	push   %ebx
80103560:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103563:	e8 e3 fc ff ff       	call   8010324b <myproc>
80103568:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
8010356a:	e8 0c fb ff ff       	call   8010307b <allocproc>
8010356f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103572:	85 c0                	test   %eax,%eax
80103574:	0f 84 f2 00 00 00    	je     8010366c <fork+0x116>
8010357a:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010357c:	83 ec 08             	sub    $0x8,%esp
8010357f:	ff 33                	pushl  (%ebx)
80103581:	ff 73 04             	pushl  0x4(%ebx)
80103584:	e8 75 33 00 00       	call   801068fe <copyuvm>
80103589:	89 47 04             	mov    %eax,0x4(%edi)
8010358c:	83 c4 10             	add    $0x10,%esp
8010358f:	85 c0                	test   %eax,%eax
80103591:	74 2a                	je     801035bd <fork+0x67>
  np->sz = curproc->sz;
80103593:	8b 03                	mov    (%ebx),%eax
80103595:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103598:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010359a:	89 c8                	mov    %ecx,%eax
8010359c:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010359f:	8b 73 18             	mov    0x18(%ebx),%esi
801035a2:	8b 79 18             	mov    0x18(%ecx),%edi
801035a5:	b9 13 00 00 00       	mov    $0x13,%ecx
801035aa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801035ac:	8b 40 18             	mov    0x18(%eax),%eax
801035af:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801035b6:	be 00 00 00 00       	mov    $0x0,%esi
801035bb:	eb 3a                	jmp    801035f7 <fork+0xa1>
    kfree(np->kstack);
801035bd:	83 ec 0c             	sub    $0xc,%esp
801035c0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801035c3:	ff 73 08             	pushl  0x8(%ebx)
801035c6:	e8 1a ea ff ff       	call   80101fe5 <kfree>
    np->kstack = 0;
801035cb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801035d2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	be ff ff ff ff       	mov    $0xffffffff,%esi
801035e1:	eb 7f                	jmp    80103662 <fork+0x10c>
      np->ofile[i] = filedup(curproc->ofile[i]);
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 aa d6 ff ff       	call   80100c96 <filedup>
801035ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801035ef:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801035f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801035f6:	46                   	inc    %esi
801035f7:	83 fe 0f             	cmp    $0xf,%esi
801035fa:	7f 0a                	jg     80103606 <fork+0xb0>
    if(curproc->ofile[i])
801035fc:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103600:	85 c0                	test   %eax,%eax
80103602:	75 df                	jne    801035e3 <fork+0x8d>
80103604:	eb f0                	jmp    801035f6 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	ff 73 68             	pushl  0x68(%ebx)
8010360c:	e8 53 df ff ff       	call   80101564 <idup>
80103611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103614:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103617:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010361a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010361d:	83 c4 0c             	add    $0xc,%esp
80103620:	6a 10                	push   $0x10
80103622:	52                   	push   %edx
80103623:	50                   	push   %eax
80103624:	e8 6e 0a 00 00       	call   80104097 <safestrcpy>
  pid = np->pid;
80103629:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
8010362c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103633:	e8 3f 08 00 00       	call   80103e77 <acquire>
  np->state = RUNNABLE;
80103638:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->prio_level = curproc->prio_level;
8010363f:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103645:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  insert_end(np);
8010364b:	89 3c 24             	mov    %edi,(%esp)
8010364e:	e8 72 fc ff ff       	call   801032c5 <insert_end>
  release(&ptable.lock);
80103653:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010365a:	e8 81 08 00 00       	call   80103ee0 <release>
  return pid;
8010365f:	83 c4 10             	add    $0x10,%esp
}
80103662:	89 f0                	mov    %esi,%eax
80103664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103667:	5b                   	pop    %ebx
80103668:	5e                   	pop    %esi
80103669:	5f                   	pop    %edi
8010366a:	5d                   	pop    %ebp
8010366b:	c3                   	ret    
    return -1;
8010366c:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103671:	eb ef                	jmp    80103662 <fork+0x10c>

80103673 <proc_prio>:
{
80103673:	f3 0f 1e fb          	endbr32 
80103677:	55                   	push   %ebp
80103678:	89 e5                	mov    %esp,%ebp
8010367a:	53                   	push   %ebx
8010367b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for (q = 0; q < PRIO_LEVELS; q++){
8010367e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103683:	83 fb 09             	cmp    $0x9,%ebx
80103686:	7f 25                	jg     801036ad <proc_prio+0x3a>
    p = ptable.priority_list[q].first_proc;
80103688:	8b 04 dd 54 50 11 80 	mov    -0x7feeafac(,%ebx,8),%eax
    while (p->next_proc != NULL) {
8010368f:	89 c2                	mov    %eax,%edx
80103691:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80103697:	85 c0                	test   %eax,%eax
80103699:	74 0a                	je     801036a5 <proc_prio+0x32>
      if (p->pid == pid) 
8010369b:	39 4a 10             	cmp    %ecx,0x10(%edx)
8010369e:	75 ef                	jne    8010368f <proc_prio+0x1c>
}
801036a0:	89 d8                	mov    %ebx,%eax
801036a2:	5b                   	pop    %ebx
801036a3:	5d                   	pop    %ebp
801036a4:	c3                   	ret    
    if (p->pid == pid) 
801036a5:	39 4a 10             	cmp    %ecx,0x10(%edx)
801036a8:	74 f6                	je     801036a0 <proc_prio+0x2d>
  for (q = 0; q < PRIO_LEVELS; q++){
801036aa:	43                   	inc    %ebx
801036ab:	eb d6                	jmp    80103683 <proc_prio+0x10>
  return -1;
801036ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801036b2:	eb ec                	jmp    801036a0 <proc_prio+0x2d>

801036b4 <scheduler>:
{
801036b4:	f3 0f 1e fb          	endbr32 
801036b8:	55                   	push   %ebp
801036b9:	89 e5                	mov    %esp,%ebp
801036bb:	57                   	push   %edi
801036bc:	56                   	push   %esi
801036bd:	53                   	push   %ebx
801036be:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801036c1:	e8 e9 fa ff ff       	call   801031af <mycpu>
801036c6:	89 c7                	mov    %eax,%edi
  c->proc = 0;
801036c8:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801036cf:	00 00 00 
801036d2:	eb 13                	jmp    801036e7 <scheduler+0x33>
    for (level = 0; level < PRIO_LEVELS; level++){
801036d4:	46                   	inc    %esi
801036d5:	eb 26                	jmp    801036fd <scheduler+0x49>
    release(&ptable.lock);
801036d7:	83 ec 0c             	sub    $0xc,%esp
801036da:	68 20 2d 11 80       	push   $0x80112d20
801036df:	e8 fc 07 00 00       	call   80103ee0 <release>
    sti();
801036e4:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801036e7:	fb                   	sti    
    acquire(&ptable.lock);
801036e8:	83 ec 0c             	sub    $0xc,%esp
801036eb:	68 20 2d 11 80       	push   $0x80112d20
801036f0:	e8 82 07 00 00       	call   80103e77 <acquire>
    for (level = 0; level < PRIO_LEVELS; level++){
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	be 00 00 00 00       	mov    $0x0,%esi
801036fd:	83 fe 09             	cmp    $0x9,%esi
80103700:	7f d5                	jg     801036d7 <scheduler+0x23>
      if ((p = ptable.priority_list[level].first_proc) == NULL)
80103702:	8b 1c f5 54 50 11 80 	mov    -0x7feeafac(,%esi,8),%ebx
80103709:	85 db                	test   %ebx,%ebx
8010370b:	74 c7                	je     801036d4 <scheduler+0x20>
      c->proc = p;
8010370d:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
      switchuvm(p);
80103713:	83 ec 0c             	sub    $0xc,%esp
80103716:	53                   	push   %ebx
80103717:	e8 02 2d 00 00       	call   8010641e <switchuvm>
      remove_beggining(level);
8010371c:	89 34 24             	mov    %esi,(%esp)
8010371f:	e8 4f fb ff ff       	call   80103273 <remove_beggining>
      p->state = RUNNING;
80103724:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context); //Esta funcion continúa por el mismo sitio pero en otro proceso, es decir entras por una pila, pero restauras otra
8010372b:	83 c4 08             	add    $0x8,%esp
8010372e:	ff 73 1c             	pushl  0x1c(%ebx)
80103731:	8d 47 04             	lea    0x4(%edi),%eax
80103734:	50                   	push   %eax
80103735:	e8 b3 09 00 00       	call   801040ed <swtch>
      switchkvm();
8010373a:	e8 cd 2c 00 00       	call   8010640c <switchkvm>
      c->proc = 0;
8010373f:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103746:	00 00 00 
      break;
80103749:	83 c4 10             	add    $0x10,%esp
8010374c:	eb 89                	jmp    801036d7 <scheduler+0x23>

8010374e <sched>:
{
8010374e:	f3 0f 1e fb          	endbr32 
80103752:	55                   	push   %ebp
80103753:	89 e5                	mov    %esp,%ebp
80103755:	56                   	push   %esi
80103756:	53                   	push   %ebx
  struct proc *p = myproc();
80103757:	e8 ef fa ff ff       	call   8010324b <myproc>
8010375c:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010375e:	83 ec 0c             	sub    $0xc,%esp
80103761:	68 20 2d 11 80       	push   $0x80112d20
80103766:	e8 c8 06 00 00       	call   80103e33 <holding>
8010376b:	83 c4 10             	add    $0x10,%esp
8010376e:	85 c0                	test   %eax,%eax
80103770:	74 4f                	je     801037c1 <sched+0x73>
  if(mycpu()->ncli != 1)
80103772:	e8 38 fa ff ff       	call   801031af <mycpu>
80103777:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010377e:	75 4e                	jne    801037ce <sched+0x80>
  if(p->state == RUNNING)
80103780:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103784:	74 55                	je     801037db <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103786:	9c                   	pushf  
80103787:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103788:	f6 c4 02             	test   $0x2,%ah
8010378b:	75 5b                	jne    801037e8 <sched+0x9a>
  intena = mycpu()->intena;
8010378d:	e8 1d fa ff ff       	call   801031af <mycpu>
80103792:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103798:	e8 12 fa ff ff       	call   801031af <mycpu>
8010379d:	83 ec 08             	sub    $0x8,%esp
801037a0:	ff 70 04             	pushl  0x4(%eax)
801037a3:	83 c3 1c             	add    $0x1c,%ebx
801037a6:	53                   	push   %ebx
801037a7:	e8 41 09 00 00       	call   801040ed <swtch>
  mycpu()->intena = intena;
801037ac:	e8 fe f9 ff ff       	call   801031af <mycpu>
801037b1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801037b7:	83 c4 10             	add    $0x10,%esp
801037ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037bd:	5b                   	pop    %ebx
801037be:	5e                   	pop    %esi
801037bf:	5d                   	pop    %ebp
801037c0:	c3                   	ret    
    panic("sched ptable.lock");
801037c1:	83 ec 0c             	sub    $0xc,%esp
801037c4:	68 2b 70 10 80       	push   $0x8010702b
801037c9:	e8 87 cb ff ff       	call   80100355 <panic>
    panic("sched locks");
801037ce:	83 ec 0c             	sub    $0xc,%esp
801037d1:	68 3d 70 10 80       	push   $0x8010703d
801037d6:	e8 7a cb ff ff       	call   80100355 <panic>
    panic("sched running");
801037db:	83 ec 0c             	sub    $0xc,%esp
801037de:	68 49 70 10 80       	push   $0x80107049
801037e3:	e8 6d cb ff ff       	call   80100355 <panic>
    panic("sched interruptible");
801037e8:	83 ec 0c             	sub    $0xc,%esp
801037eb:	68 57 70 10 80       	push   $0x80107057
801037f0:	e8 60 cb ff ff       	call   80100355 <panic>

801037f5 <exit>:
{
801037f5:	f3 0f 1e fb          	endbr32 
801037f9:	55                   	push   %ebp
801037fa:	89 e5                	mov    %esp,%ebp
801037fc:	56                   	push   %esi
801037fd:	53                   	push   %ebx
  struct proc *curproc = myproc();
801037fe:	e8 48 fa ff ff       	call   8010324b <myproc>
  if(curproc == initproc)
80103803:	39 05 b8 a5 10 80    	cmp    %eax,0x8010a5b8
80103809:	74 09                	je     80103814 <exit+0x1f>
8010380b:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010380d:	bb 00 00 00 00       	mov    $0x0,%ebx
80103812:	eb 22                	jmp    80103836 <exit+0x41>
    panic("init exiting");
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	68 6b 70 10 80       	push   $0x8010706b
8010381c:	e8 34 cb ff ff       	call   80100355 <panic>
      fileclose(curproc->ofile[fd]);
80103821:	83 ec 0c             	sub    $0xc,%esp
80103824:	50                   	push   %eax
80103825:	e8 b3 d4 ff ff       	call   80100cdd <fileclose>
      curproc->ofile[fd] = 0;
8010382a:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103831:	00 
80103832:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103835:	43                   	inc    %ebx
80103836:	83 fb 0f             	cmp    $0xf,%ebx
80103839:	7f 0a                	jg     80103845 <exit+0x50>
    if(curproc->ofile[fd]){
8010383b:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
8010383f:	85 c0                	test   %eax,%eax
80103841:	75 de                	jne    80103821 <exit+0x2c>
80103843:	eb f0                	jmp    80103835 <exit+0x40>
  begin_op();
80103845:	e8 99 ef ff ff       	call   801027e3 <begin_op>
  iput(curproc->cwd);
8010384a:	83 ec 0c             	sub    $0xc,%esp
8010384d:	ff 76 68             	pushl  0x68(%esi)
80103850:	e8 4e de ff ff       	call   801016a3 <iput>
  end_op();
80103855:	e8 09 f0 ff ff       	call   80102863 <end_op>
  curproc->cwd = 0;
8010385a:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103861:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103868:	e8 0a 06 00 00       	call   80103e77 <acquire>
  wakeup1(curproc->parent);
8010386d:	8b 46 14             	mov    0x14(%esi),%eax
80103870:	e8 ae fa ff ff       	call   80103323 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010387d:	eb 06                	jmp    80103885 <exit+0x90>
8010387f:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103885:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010388b:	73 1a                	jae    801038a7 <exit+0xb2>
    if(p->parent == curproc){
8010388d:	39 73 14             	cmp    %esi,0x14(%ebx)
80103890:	75 ed                	jne    8010387f <exit+0x8a>
      p->parent = initproc;
80103892:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103897:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010389a:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010389e:	75 df                	jne    8010387f <exit+0x8a>
        wakeup1(initproc);
801038a0:	e8 7e fa ff ff       	call   80103323 <wakeup1>
801038a5:	eb d8                	jmp    8010387f <exit+0x8a>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
801038a7:	83 ec 04             	sub    $0x4,%esp
801038aa:	6a 00                	push   $0x0
801038ac:	68 00 00 00 80       	push   $0x80000000
801038b1:	ff 76 04             	pushl  0x4(%esi)
801038b4:	e8 88 2d 00 00       	call   80106641 <deallocuvm>
  curproc->exit_status = exit_status;
801038b9:	8b 45 08             	mov    0x8(%ebp),%eax
801038bc:	89 46 7c             	mov    %eax,0x7c(%esi)
  curproc->state = ZOMBIE;
801038bf:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801038c6:	e8 83 fe ff ff       	call   8010374e <sched>
  panic("zombie exit");
801038cb:	c7 04 24 78 70 10 80 	movl   $0x80107078,(%esp)
801038d2:	e8 7e ca ff ff       	call   80100355 <panic>

801038d7 <yield>:
{
801038d7:	f3 0f 1e fb          	endbr32 
801038db:	55                   	push   %ebp
801038dc:	89 e5                	mov    %esp,%ebp
801038de:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801038e1:	68 20 2d 11 80       	push   $0x80112d20
801038e6:	e8 8c 05 00 00       	call   80103e77 <acquire>
  myproc()->state = RUNNABLE;
801038eb:	e8 5b f9 ff ff       	call   8010324b <myproc>
801038f0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insert_end(myproc());
801038f7:	e8 4f f9 ff ff       	call   8010324b <myproc>
801038fc:	89 04 24             	mov    %eax,(%esp)
801038ff:	e8 c1 f9 ff ff       	call   801032c5 <insert_end>
  sched();
80103904:	e8 45 fe ff ff       	call   8010374e <sched>
  release(&ptable.lock);
80103909:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103910:	e8 cb 05 00 00       	call   80103ee0 <release>
}
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	c9                   	leave  
80103919:	c3                   	ret    

8010391a <sleep>:
{
8010391a:	f3 0f 1e fb          	endbr32 
8010391e:	55                   	push   %ebp
8010391f:	89 e5                	mov    %esp,%ebp
80103921:	56                   	push   %esi
80103922:	53                   	push   %ebx
80103923:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103926:	e8 20 f9 ff ff       	call   8010324b <myproc>
  if(p == 0)
8010392b:	85 c0                	test   %eax,%eax
8010392d:	74 66                	je     80103995 <sleep+0x7b>
8010392f:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103931:	85 f6                	test   %esi,%esi
80103933:	74 6d                	je     801039a2 <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103935:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010393b:	74 18                	je     80103955 <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 20 2d 11 80       	push   $0x80112d20
80103945:	e8 2d 05 00 00       	call   80103e77 <acquire>
    release(lk);
8010394a:	89 34 24             	mov    %esi,(%esp)
8010394d:	e8 8e 05 00 00       	call   80103ee0 <release>
80103952:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103955:	8b 45 08             	mov    0x8(%ebp),%eax
80103958:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010395b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103962:	e8 e7 fd ff ff       	call   8010374e <sched>
  p->chan = 0;
80103967:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010396e:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103974:	74 18                	je     8010398e <sleep+0x74>
    release(&ptable.lock);
80103976:	83 ec 0c             	sub    $0xc,%esp
80103979:	68 20 2d 11 80       	push   $0x80112d20
8010397e:	e8 5d 05 00 00       	call   80103ee0 <release>
    acquire(lk);
80103983:	89 34 24             	mov    %esi,(%esp)
80103986:	e8 ec 04 00 00       	call   80103e77 <acquire>
8010398b:	83 c4 10             	add    $0x10,%esp
}
8010398e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103991:	5b                   	pop    %ebx
80103992:	5e                   	pop    %esi
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret    
    panic("sleep");
80103995:	83 ec 0c             	sub    $0xc,%esp
80103998:	68 84 70 10 80       	push   $0x80107084
8010399d:	e8 b3 c9 ff ff       	call   80100355 <panic>
    panic("sleep without lk");
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	68 8a 70 10 80       	push   $0x8010708a
801039aa:	e8 a6 c9 ff ff       	call   80100355 <panic>

801039af <wait>:
{
801039af:	f3 0f 1e fb          	endbr32 
801039b3:	55                   	push   %ebp
801039b4:	89 e5                	mov    %esp,%ebp
801039b6:	56                   	push   %esi
801039b7:	53                   	push   %ebx
  struct proc *curproc = myproc();
801039b8:	e8 8e f8 ff ff       	call   8010324b <myproc>
801039bd:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801039bf:	83 ec 0c             	sub    $0xc,%esp
801039c2:	68 20 2d 11 80       	push   $0x80112d20
801039c7:	e8 ab 04 00 00       	call   80103e77 <acquire>
801039cc:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801039cf:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801039d9:	eb 77                	jmp    80103a52 <wait+0xa3>
        pid = p->pid;
801039db:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801039de:	83 ec 0c             	sub    $0xc,%esp
801039e1:	ff 73 08             	pushl  0x8(%ebx)
801039e4:	e8 fc e5 ff ff       	call   80101fe5 <kfree>
        p->kstack = 0;
801039e9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
801039f0:	83 c4 08             	add    $0x8,%esp
801039f3:	6a 00                	push   $0x0
801039f5:	ff 73 04             	pushl  0x4(%ebx)
801039f8:	e8 c8 2d 00 00       	call   801067c5 <freevm>
        p->pid = 0;
801039fd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103a04:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103a0b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103a0f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103a16:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        if (p->exit_status != 0) {
80103a1d:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	85 c0                	test   %eax,%eax
80103a25:	74 05                	je     80103a2c <wait+0x7d>
          *exit_status = p->exit_status;
80103a27:	8b 55 08             	mov    0x8(%ebp),%edx
80103a2a:	89 02                	mov    %eax,(%edx)
        p->exit_status = 0;
80103a2c:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        release(&ptable.lock);
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	68 20 2d 11 80       	push   $0x80112d20
80103a3b:	e8 a0 04 00 00       	call   80103ee0 <release>
        return pid;
80103a40:	83 c4 10             	add    $0x10,%esp
}
80103a43:	89 f0                	mov    %esi,%eax
80103a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a48:	5b                   	pop    %ebx
80103a49:	5e                   	pop    %esi
80103a4a:	5d                   	pop    %ebp
80103a4b:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a4c:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103a52:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103a58:	73 16                	jae    80103a70 <wait+0xc1>
      if(p->parent != curproc)
80103a5a:	39 73 14             	cmp    %esi,0x14(%ebx)
80103a5d:	75 ed                	jne    80103a4c <wait+0x9d>
      if(p->state == ZOMBIE){
80103a5f:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103a63:	0f 84 72 ff ff ff    	je     801039db <wait+0x2c>
      havekids = 1;
80103a69:	b8 01 00 00 00       	mov    $0x1,%eax
80103a6e:	eb dc                	jmp    80103a4c <wait+0x9d>
    if(!havekids || curproc->killed){
80103a70:	85 c0                	test   %eax,%eax
80103a72:	74 06                	je     80103a7a <wait+0xcb>
80103a74:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103a78:	74 17                	je     80103a91 <wait+0xe2>
      release(&ptable.lock);
80103a7a:	83 ec 0c             	sub    $0xc,%esp
80103a7d:	68 20 2d 11 80       	push   $0x80112d20
80103a82:	e8 59 04 00 00       	call   80103ee0 <release>
      return -1;
80103a87:	83 c4 10             	add    $0x10,%esp
80103a8a:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103a8f:	eb b2                	jmp    80103a43 <wait+0x94>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103a91:	83 ec 08             	sub    $0x8,%esp
80103a94:	68 20 2d 11 80       	push   $0x80112d20
80103a99:	56                   	push   %esi
80103a9a:	e8 7b fe ff ff       	call   8010391a <sleep>
    havekids = 0;
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	e9 28 ff ff ff       	jmp    801039cf <wait+0x20>

80103aa7 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103aa7:	f3 0f 1e fb          	endbr32 
80103aab:	55                   	push   %ebp
80103aac:	89 e5                	mov    %esp,%ebp
80103aae:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103ab1:	68 20 2d 11 80       	push   $0x80112d20
80103ab6:	e8 bc 03 00 00       	call   80103e77 <acquire>
  wakeup1(chan);
80103abb:	8b 45 08             	mov    0x8(%ebp),%eax
80103abe:	e8 60 f8 ff ff       	call   80103323 <wakeup1>
  release(&ptable.lock);
80103ac3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aca:	e8 11 04 00 00       	call   80103ee0 <release>
}
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	c9                   	leave  
80103ad3:	c3                   	ret    

80103ad4 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ad4:	f3 0f 1e fb          	endbr32 
80103ad8:	55                   	push   %ebp
80103ad9:	89 e5                	mov    %esp,%ebp
80103adb:	53                   	push   %ebx
80103adc:	83 ec 10             	sub    $0x10,%esp
80103adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103ae2:	68 20 2d 11 80       	push   $0x80112d20
80103ae7:	e8 8b 03 00 00       	call   80103e77 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aec:	83 c4 10             	add    $0x10,%esp
80103aef:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103af4:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103af9:	73 48                	jae    80103b43 <kill+0x6f>
    if(p->pid == pid){
80103afb:	39 58 10             	cmp    %ebx,0x10(%eax)
80103afe:	74 07                	je     80103b07 <kill+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b00:	05 8c 00 00 00       	add    $0x8c,%eax
80103b05:	eb ed                	jmp    80103af4 <kill+0x20>
      p->killed = 1;
80103b07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80103b0e:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103b12:	74 1a                	je     80103b2e <kill+0x5a>
        p->state = RUNNABLE;
        insert_end(p);
      }
      release(&ptable.lock);
80103b14:	83 ec 0c             	sub    $0xc,%esp
80103b17:	68 20 2d 11 80       	push   $0x80112d20
80103b1c:	e8 bf 03 00 00       	call   80103ee0 <release>
      return 0;
80103b21:	83 c4 10             	add    $0x10,%esp
80103b24:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2c:	c9                   	leave  
80103b2d:	c3                   	ret    
        p->state = RUNNABLE;
80103b2e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        insert_end(p);
80103b35:	83 ec 0c             	sub    $0xc,%esp
80103b38:	50                   	push   %eax
80103b39:	e8 87 f7 ff ff       	call   801032c5 <insert_end>
80103b3e:	83 c4 10             	add    $0x10,%esp
80103b41:	eb d1                	jmp    80103b14 <kill+0x40>
  release(&ptable.lock);
80103b43:	83 ec 0c             	sub    $0xc,%esp
80103b46:	68 20 2d 11 80       	push   $0x80112d20
80103b4b:	e8 90 03 00 00       	call   80103ee0 <release>
  return -1;
80103b50:	83 c4 10             	add    $0x10,%esp
80103b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b58:	eb cf                	jmp    80103b29 <kill+0x55>

80103b5a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103b5a:	f3 0f 1e fb          	endbr32 
80103b5e:	55                   	push   %ebp
80103b5f:	89 e5                	mov    %esp,%ebp
80103b61:	56                   	push   %esi
80103b62:	53                   	push   %ebx
80103b63:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b66:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103b6b:	eb 36                	jmp    80103ba3 <procdump+0x49>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103b6d:	b8 9b 70 10 80       	mov    $0x8010709b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103b72:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103b75:	52                   	push   %edx
80103b76:	50                   	push   %eax
80103b77:	ff 73 10             	pushl  0x10(%ebx)
80103b7a:	68 9f 70 10 80       	push   $0x8010709f
80103b7f:	e8 79 ca ff ff       	call   801005fd <cprintf>
    if(p->state == SLEEPING){
80103b84:	83 c4 10             	add    $0x10,%esp
80103b87:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103b8b:	74 3c                	je     80103bc9 <procdump+0x6f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103b8d:	83 ec 0c             	sub    $0xc,%esp
80103b90:	68 eb 74 10 80       	push   $0x801074eb
80103b95:	e8 63 ca ff ff       	call   801005fd <cprintf>
80103b9a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b9d:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ba3:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103ba9:	73 5f                	jae    80103c0a <procdump+0xb0>
    if(p->state == UNUSED)
80103bab:	8b 43 0c             	mov    0xc(%ebx),%eax
80103bae:	85 c0                	test   %eax,%eax
80103bb0:	74 eb                	je     80103b9d <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103bb2:	83 f8 05             	cmp    $0x5,%eax
80103bb5:	77 b6                	ja     80103b6d <procdump+0x13>
80103bb7:	8b 04 85 fc 70 10 80 	mov    -0x7fef8f04(,%eax,4),%eax
80103bbe:	85 c0                	test   %eax,%eax
80103bc0:	75 b0                	jne    80103b72 <procdump+0x18>
      state = "???";
80103bc2:	b8 9b 70 10 80       	mov    $0x8010709b,%eax
80103bc7:	eb a9                	jmp    80103b72 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103bc9:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bcc:	8b 40 0c             	mov    0xc(%eax),%eax
80103bcf:	83 c0 08             	add    $0x8,%eax
80103bd2:	83 ec 08             	sub    $0x8,%esp
80103bd5:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103bd8:	52                   	push   %edx
80103bd9:	50                   	push   %eax
80103bda:	e8 6c 01 00 00       	call   80103d4b <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	be 00 00 00 00       	mov    $0x0,%esi
80103be7:	eb 12                	jmp    80103bfb <procdump+0xa1>
        cprintf(" %p", pc[i]);
80103be9:	83 ec 08             	sub    $0x8,%esp
80103bec:	50                   	push   %eax
80103bed:	68 e1 6a 10 80       	push   $0x80106ae1
80103bf2:	e8 06 ca ff ff       	call   801005fd <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103bf7:	46                   	inc    %esi
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	83 fe 09             	cmp    $0x9,%esi
80103bfe:	7f 8d                	jg     80103b8d <procdump+0x33>
80103c00:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103c04:	85 c0                	test   %eax,%eax
80103c06:	75 e1                	jne    80103be9 <procdump+0x8f>
80103c08:	eb 83                	jmp    80103b8d <procdump+0x33>
  }
}
80103c0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c0d:	5b                   	pop    %ebx
80103c0e:	5e                   	pop    %esi
80103c0f:	5d                   	pop    %ebp
80103c10:	c3                   	ret    

80103c11 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103c11:	f3 0f 1e fb          	endbr32 
80103c15:	55                   	push   %ebp
80103c16:	89 e5                	mov    %esp,%ebp
80103c18:	53                   	push   %ebx
80103c19:	83 ec 0c             	sub    $0xc,%esp
80103c1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103c1f:	68 14 71 10 80       	push   $0x80107114
80103c24:	8d 43 04             	lea    0x4(%ebx),%eax
80103c27:	50                   	push   %eax
80103c28:	e8 ff 00 00 00       	call   80103d2c <initlock>
  lk->name = name;
80103c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c30:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103c33:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103c39:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103c40:	83 c4 10             	add    $0x10,%esp
80103c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c46:	c9                   	leave  
80103c47:	c3                   	ret    

80103c48 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103c48:	f3 0f 1e fb          	endbr32 
80103c4c:	55                   	push   %ebp
80103c4d:	89 e5                	mov    %esp,%ebp
80103c4f:	56                   	push   %esi
80103c50:	53                   	push   %ebx
80103c51:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103c54:	8d 73 04             	lea    0x4(%ebx),%esi
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	56                   	push   %esi
80103c5b:	e8 17 02 00 00       	call   80103e77 <acquire>
  while (lk->locked) {
80103c60:	83 c4 10             	add    $0x10,%esp
80103c63:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c66:	74 0f                	je     80103c77 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103c68:	83 ec 08             	sub    $0x8,%esp
80103c6b:	56                   	push   %esi
80103c6c:	53                   	push   %ebx
80103c6d:	e8 a8 fc ff ff       	call   8010391a <sleep>
80103c72:	83 c4 10             	add    $0x10,%esp
80103c75:	eb ec                	jmp    80103c63 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103c77:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103c7d:	e8 c9 f5 ff ff       	call   8010324b <myproc>
80103c82:	8b 40 10             	mov    0x10(%eax),%eax
80103c85:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103c88:	83 ec 0c             	sub    $0xc,%esp
80103c8b:	56                   	push   %esi
80103c8c:	e8 4f 02 00 00       	call   80103ee0 <release>
}
80103c91:	83 c4 10             	add    $0x10,%esp
80103c94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c97:	5b                   	pop    %ebx
80103c98:	5e                   	pop    %esi
80103c99:	5d                   	pop    %ebp
80103c9a:	c3                   	ret    

80103c9b <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103c9b:	f3 0f 1e fb          	endbr32 
80103c9f:	55                   	push   %ebp
80103ca0:	89 e5                	mov    %esp,%ebp
80103ca2:	56                   	push   %esi
80103ca3:	53                   	push   %ebx
80103ca4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ca7:	8d 73 04             	lea    0x4(%ebx),%esi
80103caa:	83 ec 0c             	sub    $0xc,%esp
80103cad:	56                   	push   %esi
80103cae:	e8 c4 01 00 00       	call   80103e77 <acquire>
  lk->locked = 0;
80103cb3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103cb9:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103cc0:	89 1c 24             	mov    %ebx,(%esp)
80103cc3:	e8 df fd ff ff       	call   80103aa7 <wakeup>
  release(&lk->lk);
80103cc8:	89 34 24             	mov    %esi,(%esp)
80103ccb:	e8 10 02 00 00       	call   80103ee0 <release>
}
80103cd0:	83 c4 10             	add    $0x10,%esp
80103cd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cd6:	5b                   	pop    %ebx
80103cd7:	5e                   	pop    %esi
80103cd8:	5d                   	pop    %ebp
80103cd9:	c3                   	ret    

80103cda <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103cda:	f3 0f 1e fb          	endbr32 
80103cde:	55                   	push   %ebp
80103cdf:	89 e5                	mov    %esp,%ebp
80103ce1:	56                   	push   %esi
80103ce2:	53                   	push   %ebx
80103ce3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103ce6:	8d 73 04             	lea    0x4(%ebx),%esi
80103ce9:	83 ec 0c             	sub    $0xc,%esp
80103cec:	56                   	push   %esi
80103ced:	e8 85 01 00 00       	call   80103e77 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103cf2:	83 c4 10             	add    $0x10,%esp
80103cf5:	83 3b 00             	cmpl   $0x0,(%ebx)
80103cf8:	75 17                	jne    80103d11 <holdingsleep+0x37>
80103cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	56                   	push   %esi
80103d03:	e8 d8 01 00 00       	call   80103ee0 <release>
  return r;
}
80103d08:	89 d8                	mov    %ebx,%eax
80103d0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d0d:	5b                   	pop    %ebx
80103d0e:	5e                   	pop    %esi
80103d0f:	5d                   	pop    %ebp
80103d10:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103d11:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103d14:	e8 32 f5 ff ff       	call   8010324b <myproc>
80103d19:	3b 58 10             	cmp    0x10(%eax),%ebx
80103d1c:	74 07                	je     80103d25 <holdingsleep+0x4b>
80103d1e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d23:	eb da                	jmp    80103cff <holdingsleep+0x25>
80103d25:	bb 01 00 00 00       	mov    $0x1,%ebx
80103d2a:	eb d3                	jmp    80103cff <holdingsleep+0x25>

80103d2c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103d2c:	f3 0f 1e fb          	endbr32 
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103d36:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d39:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103d3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103d49:	5d                   	pop    %ebp
80103d4a:	c3                   	ret    

80103d4b <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103d4b:	f3 0f 1e fb          	endbr32 
80103d4f:	55                   	push   %ebp
80103d50:	89 e5                	mov    %esp,%ebp
80103d52:	53                   	push   %ebx
80103d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103d56:	8b 45 08             	mov    0x8(%ebp),%eax
80103d59:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103d5c:	b8 00 00 00 00       	mov    $0x0,%eax
80103d61:	83 f8 09             	cmp    $0x9,%eax
80103d64:	7f 21                	jg     80103d87 <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103d66:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103d6c:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103d72:	77 13                	ja     80103d87 <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103d74:	8b 5a 04             	mov    0x4(%edx),%ebx
80103d77:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103d7a:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103d7c:	40                   	inc    %eax
80103d7d:	eb e2                	jmp    80103d61 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103d7f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103d86:	40                   	inc    %eax
80103d87:	83 f8 09             	cmp    $0x9,%eax
80103d8a:	7e f3                	jle    80103d7f <getcallerpcs+0x34>
}
80103d8c:	5b                   	pop    %ebx
80103d8d:	5d                   	pop    %ebp
80103d8e:	c3                   	ret    

80103d8f <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103d8f:	f3 0f 1e fb          	endbr32 
80103d93:	55                   	push   %ebp
80103d94:	89 e5                	mov    %esp,%ebp
80103d96:	53                   	push   %ebx
80103d97:	83 ec 04             	sub    $0x4,%esp
80103d9a:	9c                   	pushf  
80103d9b:	5b                   	pop    %ebx
  asm volatile("cli");
80103d9c:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103d9d:	e8 0d f4 ff ff       	call   801031af <mycpu>
80103da2:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103da9:	74 11                	je     80103dbc <pushcli+0x2d>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103dab:	e8 ff f3 ff ff       	call   801031af <mycpu>
80103db0:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103db6:	83 c4 04             	add    $0x4,%esp
80103db9:	5b                   	pop    %ebx
80103dba:	5d                   	pop    %ebp
80103dbb:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103dbc:	e8 ee f3 ff ff       	call   801031af <mycpu>
80103dc1:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103dc7:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103dcd:	eb dc                	jmp    80103dab <pushcli+0x1c>

80103dcf <popcli>:

void
popcli(void)
{
80103dcf:	f3 0f 1e fb          	endbr32 
80103dd3:	55                   	push   %ebp
80103dd4:	89 e5                	mov    %esp,%ebp
80103dd6:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dd9:	9c                   	pushf  
80103dda:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ddb:	f6 c4 02             	test   $0x2,%ah
80103dde:	75 28                	jne    80103e08 <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103de0:	e8 ca f3 ff ff       	call   801031af <mycpu>
80103de5:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103deb:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103dee:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103df4:	85 d2                	test   %edx,%edx
80103df6:	78 1d                	js     80103e15 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103df8:	e8 b2 f3 ff ff       	call   801031af <mycpu>
80103dfd:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103e04:	74 1c                	je     80103e22 <popcli+0x53>
    sti();
}
80103e06:	c9                   	leave  
80103e07:	c3                   	ret    
    panic("popcli - interruptible");
80103e08:	83 ec 0c             	sub    $0xc,%esp
80103e0b:	68 1f 71 10 80       	push   $0x8010711f
80103e10:	e8 40 c5 ff ff       	call   80100355 <panic>
    panic("popcli");
80103e15:	83 ec 0c             	sub    $0xc,%esp
80103e18:	68 36 71 10 80       	push   $0x80107136
80103e1d:	e8 33 c5 ff ff       	call   80100355 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103e22:	e8 88 f3 ff ff       	call   801031af <mycpu>
80103e27:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103e2e:	74 d6                	je     80103e06 <popcli+0x37>
  asm volatile("sti");
80103e30:	fb                   	sti    
}
80103e31:	eb d3                	jmp    80103e06 <popcli+0x37>

80103e33 <holding>:
{
80103e33:	f3 0f 1e fb          	endbr32 
80103e37:	55                   	push   %ebp
80103e38:	89 e5                	mov    %esp,%ebp
80103e3a:	53                   	push   %ebx
80103e3b:	83 ec 04             	sub    $0x4,%esp
80103e3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103e41:	e8 49 ff ff ff       	call   80103d8f <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103e46:	83 3b 00             	cmpl   $0x0,(%ebx)
80103e49:	75 12                	jne    80103e5d <holding+0x2a>
80103e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103e50:	e8 7a ff ff ff       	call   80103dcf <popcli>
}
80103e55:	89 d8                	mov    %ebx,%eax
80103e57:	83 c4 04             	add    $0x4,%esp
80103e5a:	5b                   	pop    %ebx
80103e5b:	5d                   	pop    %ebp
80103e5c:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103e5d:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103e60:	e8 4a f3 ff ff       	call   801031af <mycpu>
80103e65:	39 c3                	cmp    %eax,%ebx
80103e67:	74 07                	je     80103e70 <holding+0x3d>
80103e69:	bb 00 00 00 00       	mov    $0x0,%ebx
80103e6e:	eb e0                	jmp    80103e50 <holding+0x1d>
80103e70:	bb 01 00 00 00       	mov    $0x1,%ebx
80103e75:	eb d9                	jmp    80103e50 <holding+0x1d>

80103e77 <acquire>:
{
80103e77:	f3 0f 1e fb          	endbr32 
80103e7b:	55                   	push   %ebp
80103e7c:	89 e5                	mov    %esp,%ebp
80103e7e:	53                   	push   %ebx
80103e7f:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103e82:	e8 08 ff ff ff       	call   80103d8f <pushcli>
  if(holding(lk))
80103e87:	83 ec 0c             	sub    $0xc,%esp
80103e8a:	ff 75 08             	pushl  0x8(%ebp)
80103e8d:	e8 a1 ff ff ff       	call   80103e33 <holding>
80103e92:	83 c4 10             	add    $0x10,%esp
80103e95:	85 c0                	test   %eax,%eax
80103e97:	75 3a                	jne    80103ed3 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103e99:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103e9c:	b8 01 00 00 00       	mov    $0x1,%eax
80103ea1:	f0 87 02             	lock xchg %eax,(%edx)
80103ea4:	85 c0                	test   %eax,%eax
80103ea6:	75 f1                	jne    80103e99 <acquire+0x22>
  __sync_synchronize();
80103ea8:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103ead:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103eb0:	e8 fa f2 ff ff       	call   801031af <mycpu>
80103eb5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebb:	83 c0 0c             	add    $0xc,%eax
80103ebe:	83 ec 08             	sub    $0x8,%esp
80103ec1:	50                   	push   %eax
80103ec2:	8d 45 08             	lea    0x8(%ebp),%eax
80103ec5:	50                   	push   %eax
80103ec6:	e8 80 fe ff ff       	call   80103d4b <getcallerpcs>
}
80103ecb:	83 c4 10             	add    $0x10,%esp
80103ece:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed1:	c9                   	leave  
80103ed2:	c3                   	ret    
    panic("acquire");
80103ed3:	83 ec 0c             	sub    $0xc,%esp
80103ed6:	68 3d 71 10 80       	push   $0x8010713d
80103edb:	e8 75 c4 ff ff       	call   80100355 <panic>

80103ee0 <release>:
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	53                   	push   %ebx
80103ee8:	83 ec 10             	sub    $0x10,%esp
80103eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103eee:	53                   	push   %ebx
80103eef:	e8 3f ff ff ff       	call   80103e33 <holding>
80103ef4:	83 c4 10             	add    $0x10,%esp
80103ef7:	85 c0                	test   %eax,%eax
80103ef9:	74 23                	je     80103f1e <release+0x3e>
  lk->pcs[0] = 0;
80103efb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103f02:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103f09:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103f0e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103f14:	e8 b6 fe ff ff       	call   80103dcf <popcli>
}
80103f19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f1c:	c9                   	leave  
80103f1d:	c3                   	ret    
    panic("release");
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	68 45 71 10 80       	push   $0x80107145
80103f26:	e8 2a c4 ff ff       	call   80100355 <panic>

80103f2b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103f2b:	f3 0f 1e fb          	endbr32 
80103f2f:	55                   	push   %ebp
80103f30:	89 e5                	mov    %esp,%ebp
80103f32:	57                   	push   %edi
80103f33:	53                   	push   %ebx
80103f34:	8b 55 08             	mov    0x8(%ebp),%edx
80103f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103f3a:	f6 c2 03             	test   $0x3,%dl
80103f3d:	75 29                	jne    80103f68 <memset+0x3d>
80103f3f:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103f43:	75 23                	jne    80103f68 <memset+0x3d>
    c &= 0xFF;
80103f45:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103f48:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103f4b:	c1 e9 02             	shr    $0x2,%ecx
80103f4e:	c1 e0 18             	shl    $0x18,%eax
80103f51:	89 fb                	mov    %edi,%ebx
80103f53:	c1 e3 10             	shl    $0x10,%ebx
80103f56:	09 d8                	or     %ebx,%eax
80103f58:	89 fb                	mov    %edi,%ebx
80103f5a:	c1 e3 08             	shl    $0x8,%ebx
80103f5d:	09 d8                	or     %ebx,%eax
80103f5f:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103f61:	89 d7                	mov    %edx,%edi
80103f63:	fc                   	cld    
80103f64:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103f66:	eb 08                	jmp    80103f70 <memset+0x45>
  asm volatile("cld; rep stosb" :
80103f68:	89 d7                	mov    %edx,%edi
80103f6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103f6d:	fc                   	cld    
80103f6e:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103f70:	89 d0                	mov    %edx,%eax
80103f72:	5b                   	pop    %ebx
80103f73:	5f                   	pop    %edi
80103f74:	5d                   	pop    %ebp
80103f75:	c3                   	ret    

80103f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103f76:	f3 0f 1e fb          	endbr32 
80103f7a:	55                   	push   %ebp
80103f7b:	89 e5                	mov    %esp,%ebp
80103f7d:	56                   	push   %esi
80103f7e:	53                   	push   %ebx
80103f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103f82:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f85:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103f88:	8d 70 ff             	lea    -0x1(%eax),%esi
80103f8b:	85 c0                	test   %eax,%eax
80103f8d:	74 16                	je     80103fa5 <memcmp+0x2f>
    if(*s1 != *s2)
80103f8f:	8a 01                	mov    (%ecx),%al
80103f91:	8a 1a                	mov    (%edx),%bl
80103f93:	38 d8                	cmp    %bl,%al
80103f95:	75 06                	jne    80103f9d <memcmp+0x27>
      return *s1 - *s2;
    s1++, s2++;
80103f97:	41                   	inc    %ecx
80103f98:	42                   	inc    %edx
  while(n-- > 0){
80103f99:	89 f0                	mov    %esi,%eax
80103f9b:	eb eb                	jmp    80103f88 <memcmp+0x12>
      return *s1 - *s2;
80103f9d:	0f b6 c0             	movzbl %al,%eax
80103fa0:	0f b6 db             	movzbl %bl,%ebx
80103fa3:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103fa5:	5b                   	pop    %ebx
80103fa6:	5e                   	pop    %esi
80103fa7:	5d                   	pop    %ebp
80103fa8:	c3                   	ret    

80103fa9 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103fa9:	f3 0f 1e fb          	endbr32 
80103fad:	55                   	push   %ebp
80103fae:	89 e5                	mov    %esp,%ebp
80103fb0:	56                   	push   %esi
80103fb1:	53                   	push   %ebx
80103fb2:	8b 75 08             	mov    0x8(%ebp),%esi
80103fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103fbb:	39 f2                	cmp    %esi,%edx
80103fbd:	73 34                	jae    80103ff3 <memmove+0x4a>
80103fbf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103fc2:	39 f1                	cmp    %esi,%ecx
80103fc4:	76 31                	jbe    80103ff7 <memmove+0x4e>
    s += n;
    d += n;
80103fc6:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103fc9:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103fcc:	85 c0                	test   %eax,%eax
80103fce:	74 1d                	je     80103fed <memmove+0x44>
      *--d = *--s;
80103fd0:	49                   	dec    %ecx
80103fd1:	4a                   	dec    %edx
80103fd2:	8a 01                	mov    (%ecx),%al
80103fd4:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103fd6:	89 d8                	mov    %ebx,%eax
80103fd8:	eb ef                	jmp    80103fc9 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103fda:	8a 02                	mov    (%edx),%al
80103fdc:	88 01                	mov    %al,(%ecx)
80103fde:	8d 49 01             	lea    0x1(%ecx),%ecx
80103fe1:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103fe4:	89 d8                	mov    %ebx,%eax
80103fe6:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103fe9:	85 c0                	test   %eax,%eax
80103feb:	75 ed                	jne    80103fda <memmove+0x31>

  return dst;
}
80103fed:	89 f0                	mov    %esi,%eax
80103fef:	5b                   	pop    %ebx
80103ff0:	5e                   	pop    %esi
80103ff1:	5d                   	pop    %ebp
80103ff2:	c3                   	ret    
80103ff3:	89 f1                	mov    %esi,%ecx
80103ff5:	eb ef                	jmp    80103fe6 <memmove+0x3d>
80103ff7:	89 f1                	mov    %esi,%ecx
80103ff9:	eb eb                	jmp    80103fe6 <memmove+0x3d>

80103ffb <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103ffb:	f3 0f 1e fb          	endbr32 
80103fff:	55                   	push   %ebp
80104000:	89 e5                	mov    %esp,%ebp
80104002:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104005:	ff 75 10             	pushl  0x10(%ebp)
80104008:	ff 75 0c             	pushl  0xc(%ebp)
8010400b:	ff 75 08             	pushl  0x8(%ebp)
8010400e:	e8 96 ff ff ff       	call   80103fa9 <memmove>
}
80104013:	c9                   	leave  
80104014:	c3                   	ret    

80104015 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104015:	f3 0f 1e fb          	endbr32 
80104019:	55                   	push   %ebp
8010401a:	89 e5                	mov    %esp,%ebp
8010401c:	53                   	push   %ebx
8010401d:	8b 55 08             	mov    0x8(%ebp),%edx
80104020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104023:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104026:	eb 03                	jmp    8010402b <strncmp+0x16>
    n--, p++, q++;
80104028:	48                   	dec    %eax
80104029:	42                   	inc    %edx
8010402a:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
8010402b:	85 c0                	test   %eax,%eax
8010402d:	74 0a                	je     80104039 <strncmp+0x24>
8010402f:	8a 1a                	mov    (%edx),%bl
80104031:	84 db                	test   %bl,%bl
80104033:	74 04                	je     80104039 <strncmp+0x24>
80104035:	3a 19                	cmp    (%ecx),%bl
80104037:	74 ef                	je     80104028 <strncmp+0x13>
  if(n == 0)
80104039:	85 c0                	test   %eax,%eax
8010403b:	74 0b                	je     80104048 <strncmp+0x33>
    return 0;
  return (uchar)*p - (uchar)*q;
8010403d:	0f b6 02             	movzbl (%edx),%eax
80104040:	0f b6 11             	movzbl (%ecx),%edx
80104043:	29 d0                	sub    %edx,%eax
}
80104045:	5b                   	pop    %ebx
80104046:	5d                   	pop    %ebp
80104047:	c3                   	ret    
    return 0;
80104048:	b8 00 00 00 00       	mov    $0x0,%eax
8010404d:	eb f6                	jmp    80104045 <strncmp+0x30>

8010404f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010404f:	f3 0f 1e fb          	endbr32 
80104053:	55                   	push   %ebp
80104054:	89 e5                	mov    %esp,%ebp
80104056:	57                   	push   %edi
80104057:	56                   	push   %esi
80104058:	53                   	push   %ebx
80104059:	8b 45 08             	mov    0x8(%ebp),%eax
8010405c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010405f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104062:	89 c1                	mov    %eax,%ecx
80104064:	eb 04                	jmp    8010406a <strncpy+0x1b>
80104066:	89 fb                	mov    %edi,%ebx
80104068:	89 f1                	mov    %esi,%ecx
8010406a:	89 d6                	mov    %edx,%esi
8010406c:	4a                   	dec    %edx
8010406d:	85 f6                	test   %esi,%esi
8010406f:	7e 1a                	jle    8010408b <strncpy+0x3c>
80104071:	8d 7b 01             	lea    0x1(%ebx),%edi
80104074:	8d 71 01             	lea    0x1(%ecx),%esi
80104077:	8a 1b                	mov    (%ebx),%bl
80104079:	88 19                	mov    %bl,(%ecx)
8010407b:	84 db                	test   %bl,%bl
8010407d:	75 e7                	jne    80104066 <strncpy+0x17>
8010407f:	89 f1                	mov    %esi,%ecx
80104081:	eb 08                	jmp    8010408b <strncpy+0x3c>
    ;
  while(n-- > 0)
    *s++ = 0;
80104083:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
80104086:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80104088:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
8010408b:	8d 5a ff             	lea    -0x1(%edx),%ebx
8010408e:	85 d2                	test   %edx,%edx
80104090:	7f f1                	jg     80104083 <strncpy+0x34>
  return os;
}
80104092:	5b                   	pop    %ebx
80104093:	5e                   	pop    %esi
80104094:	5f                   	pop    %edi
80104095:	5d                   	pop    %ebp
80104096:	c3                   	ret    

80104097 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104097:	f3 0f 1e fb          	endbr32 
8010409b:	55                   	push   %ebp
8010409c:	89 e5                	mov    %esp,%ebp
8010409e:	57                   	push   %edi
8010409f:	56                   	push   %esi
801040a0:	53                   	push   %ebx
801040a1:	8b 45 08             	mov    0x8(%ebp),%eax
801040a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801040a7:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801040aa:	85 d2                	test   %edx,%edx
801040ac:	7e 20                	jle    801040ce <safestrcpy+0x37>
801040ae:	89 c1                	mov    %eax,%ecx
801040b0:	eb 04                	jmp    801040b6 <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801040b2:	89 fb                	mov    %edi,%ebx
801040b4:	89 f1                	mov    %esi,%ecx
801040b6:	4a                   	dec    %edx
801040b7:	85 d2                	test   %edx,%edx
801040b9:	7e 10                	jle    801040cb <safestrcpy+0x34>
801040bb:	8d 7b 01             	lea    0x1(%ebx),%edi
801040be:	8d 71 01             	lea    0x1(%ecx),%esi
801040c1:	8a 1b                	mov    (%ebx),%bl
801040c3:	88 19                	mov    %bl,(%ecx)
801040c5:	84 db                	test   %bl,%bl
801040c7:	75 e9                	jne    801040b2 <safestrcpy+0x1b>
801040c9:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
801040cb:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801040ce:	5b                   	pop    %ebx
801040cf:	5e                   	pop    %esi
801040d0:	5f                   	pop    %edi
801040d1:	5d                   	pop    %ebp
801040d2:	c3                   	ret    

801040d3 <strlen>:

int
strlen(const char *s)
{
801040d3:	f3 0f 1e fb          	endbr32 
801040d7:	55                   	push   %ebp
801040d8:	89 e5                	mov    %esp,%ebp
801040da:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801040dd:	b8 00 00 00 00       	mov    $0x0,%eax
801040e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801040e6:	74 03                	je     801040eb <strlen+0x18>
801040e8:	40                   	inc    %eax
801040e9:	eb f7                	jmp    801040e2 <strlen+0xf>
    ;
  return n;
}
801040eb:	5d                   	pop    %ebp
801040ec:	c3                   	ret    

801040ed <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801040ed:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801040f1:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801040f5:	55                   	push   %ebp
  pushl %ebx
801040f6:	53                   	push   %ebx
  pushl %esi
801040f7:	56                   	push   %esi
  pushl %edi
801040f8:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801040f9:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801040fb:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801040fd:	5f                   	pop    %edi
  popl %esi
801040fe:	5e                   	pop    %esi
  popl %ebx
801040ff:	5b                   	pop    %ebx
  popl %ebp
80104100:	5d                   	pop    %ebp
  ret
80104101:	c3                   	ret    

80104102 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104102:	f3 0f 1e fb          	endbr32 
80104106:	55                   	push   %ebp
80104107:	89 e5                	mov    %esp,%ebp
80104109:	53                   	push   %ebx
8010410a:	83 ec 04             	sub    $0x4,%esp
8010410d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104110:	e8 36 f1 ff ff       	call   8010324b <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104115:	8b 00                	mov    (%eax),%eax
80104117:	39 d8                	cmp    %ebx,%eax
80104119:	76 19                	jbe    80104134 <fetchint+0x32>
8010411b:	8d 53 04             	lea    0x4(%ebx),%edx
8010411e:	39 d0                	cmp    %edx,%eax
80104120:	72 19                	jb     8010413b <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80104122:	8b 13                	mov    (%ebx),%edx
80104124:	8b 45 0c             	mov    0xc(%ebp),%eax
80104127:	89 10                	mov    %edx,(%eax)
  return 0;
80104129:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010412e:	83 c4 04             	add    $0x4,%esp
80104131:	5b                   	pop    %ebx
80104132:	5d                   	pop    %ebp
80104133:	c3                   	ret    
    return -1;
80104134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104139:	eb f3                	jmp    8010412e <fetchint+0x2c>
8010413b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104140:	eb ec                	jmp    8010412e <fetchint+0x2c>

80104142 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104142:	f3 0f 1e fb          	endbr32 
80104146:	55                   	push   %ebp
80104147:	89 e5                	mov    %esp,%ebp
80104149:	53                   	push   %ebx
8010414a:	83 ec 04             	sub    $0x4,%esp
8010414d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104150:	e8 f6 f0 ff ff       	call   8010324b <myproc>

  if(addr >= curproc->sz)
80104155:	39 18                	cmp    %ebx,(%eax)
80104157:	76 24                	jbe    8010417d <fetchstr+0x3b>
    return -1;
  *pp = (char*)addr;
80104159:	8b 55 0c             	mov    0xc(%ebp),%edx
8010415c:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010415e:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104160:	89 d8                	mov    %ebx,%eax
80104162:	39 d0                	cmp    %edx,%eax
80104164:	73 0c                	jae    80104172 <fetchstr+0x30>
    if(*s == 0)
80104166:	80 38 00             	cmpb   $0x0,(%eax)
80104169:	74 03                	je     8010416e <fetchstr+0x2c>
  for(s = *pp; s < ep; s++){
8010416b:	40                   	inc    %eax
8010416c:	eb f4                	jmp    80104162 <fetchstr+0x20>
      return s - *pp;
8010416e:	29 d8                	sub    %ebx,%eax
80104170:	eb 05                	jmp    80104177 <fetchstr+0x35>
  }
  return -1;
80104172:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104177:	83 c4 04             	add    $0x4,%esp
8010417a:	5b                   	pop    %ebx
8010417b:	5d                   	pop    %ebp
8010417c:	c3                   	ret    
    return -1;
8010417d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104182:	eb f3                	jmp    80104177 <fetchstr+0x35>

80104184 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104184:	f3 0f 1e fb          	endbr32 
80104188:	55                   	push   %ebp
80104189:	89 e5                	mov    %esp,%ebp
8010418b:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010418e:	e8 b8 f0 ff ff       	call   8010324b <myproc>
80104193:	8b 50 18             	mov    0x18(%eax),%edx
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	c1 e0 02             	shl    $0x2,%eax
8010419c:	03 42 44             	add    0x44(%edx),%eax
8010419f:	83 ec 08             	sub    $0x8,%esp
801041a2:	ff 75 0c             	pushl  0xc(%ebp)
801041a5:	83 c0 04             	add    $0x4,%eax
801041a8:	50                   	push   %eax
801041a9:	e8 54 ff ff ff       	call   80104102 <fetchint>
}
801041ae:	c9                   	leave  
801041af:	c3                   	ret    

801041b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
801041b9:	83 ec 10             	sub    $0x10,%esp
801041bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801041bf:	e8 87 f0 ff ff       	call   8010324b <myproc>
801041c4:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801041c6:	83 ec 08             	sub    $0x8,%esp
801041c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801041cc:	50                   	push   %eax
801041cd:	ff 75 08             	pushl  0x8(%ebp)
801041d0:	e8 af ff ff ff       	call   80104184 <argint>
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	85 c0                	test   %eax,%eax
801041da:	78 24                	js     80104200 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801041dc:	85 db                	test   %ebx,%ebx
801041de:	78 27                	js     80104207 <argptr+0x57>
801041e0:	8b 16                	mov    (%esi),%edx
801041e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e5:	39 c2                	cmp    %eax,%edx
801041e7:	76 25                	jbe    8010420e <argptr+0x5e>
801041e9:	01 c3                	add    %eax,%ebx
801041eb:	39 da                	cmp    %ebx,%edx
801041ed:	72 26                	jb     80104215 <argptr+0x65>
    return -1;
  *pp = (void*)i;
801041ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801041f2:	89 02                	mov    %eax,(%edx)
  return 0;
801041f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801041f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041fc:	5b                   	pop    %ebx
801041fd:	5e                   	pop    %esi
801041fe:	5d                   	pop    %ebp
801041ff:	c3                   	ret    
    return -1;
80104200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104205:	eb f2                	jmp    801041f9 <argptr+0x49>
    return -1;
80104207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010420c:	eb eb                	jmp    801041f9 <argptr+0x49>
8010420e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104213:	eb e4                	jmp    801041f9 <argptr+0x49>
80104215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010421a:	eb dd                	jmp    801041f9 <argptr+0x49>

8010421c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010421c:	f3 0f 1e fb          	endbr32 
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104226:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104229:	50                   	push   %eax
8010422a:	ff 75 08             	pushl  0x8(%ebp)
8010422d:	e8 52 ff ff ff       	call   80104184 <argint>
80104232:	83 c4 10             	add    $0x10,%esp
80104235:	85 c0                	test   %eax,%eax
80104237:	78 13                	js     8010424c <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104239:	83 ec 08             	sub    $0x8,%esp
8010423c:	ff 75 0c             	pushl  0xc(%ebp)
8010423f:	ff 75 f4             	pushl  -0xc(%ebp)
80104242:	e8 fb fe ff ff       	call   80104142 <fetchstr>
80104247:	83 c4 10             	add    $0x10,%esp
}
8010424a:	c9                   	leave  
8010424b:	c3                   	ret    
    return -1;
8010424c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104251:	eb f7                	jmp    8010424a <argstr+0x2e>

80104253 <syscall>:
[SYS_setprio] sys_setprio,
};

void
syscall(void)
{
80104253:	f3 0f 1e fb          	endbr32 
80104257:	55                   	push   %ebp
80104258:	89 e5                	mov    %esp,%ebp
8010425a:	53                   	push   %ebx
8010425b:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010425e:	e8 e8 ef ff ff       	call   8010324b <myproc>
80104263:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104265:	8b 40 18             	mov    0x18(%eax),%eax
80104268:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010426b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010426e:	83 fa 18             	cmp    $0x18,%edx
80104271:	77 17                	ja     8010428a <syscall+0x37>
80104273:	8b 14 85 80 71 10 80 	mov    -0x7fef8e80(,%eax,4),%edx
8010427a:	85 d2                	test   %edx,%edx
8010427c:	74 0c                	je     8010428a <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
8010427e:	ff d2                	call   *%edx
80104280:	89 c2                	mov    %eax,%edx
80104282:	8b 43 18             	mov    0x18(%ebx),%eax
80104285:	89 50 1c             	mov    %edx,0x1c(%eax)
80104288:	eb 1f                	jmp    801042a9 <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010428a:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010428d:	50                   	push   %eax
8010428e:	52                   	push   %edx
8010428f:	ff 73 10             	pushl  0x10(%ebx)
80104292:	68 4d 71 10 80       	push   $0x8010714d
80104297:	e8 61 c3 ff ff       	call   801005fd <cprintf>
    curproc->tf->eax = -1;
8010429c:	8b 43 18             	mov    0x18(%ebx),%eax
8010429f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801042a6:	83 c4 10             	add    $0x10,%esp
  }
}
801042a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ac:	c9                   	leave  
801042ad:	c3                   	ret    

801042ae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801042ae:	55                   	push   %ebp
801042af:	89 e5                	mov    %esp,%ebp
801042b1:	56                   	push   %esi
801042b2:	53                   	push   %ebx
801042b3:	83 ec 18             	sub    $0x18,%esp
801042b6:	89 d6                	mov    %edx,%esi
801042b8:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801042ba:	8d 55 f4             	lea    -0xc(%ebp),%edx
801042bd:	52                   	push   %edx
801042be:	50                   	push   %eax
801042bf:	e8 c0 fe ff ff       	call   80104184 <argint>
801042c4:	83 c4 10             	add    $0x10,%esp
801042c7:	85 c0                	test   %eax,%eax
801042c9:	78 35                	js     80104300 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801042cb:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801042cf:	77 28                	ja     801042f9 <argfd+0x4b>
801042d1:	e8 75 ef ff ff       	call   8010324b <myproc>
801042d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042d9:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801042dd:	85 c0                	test   %eax,%eax
801042df:	74 18                	je     801042f9 <argfd+0x4b>
    return -1;
  if(pfd)
801042e1:	85 f6                	test   %esi,%esi
801042e3:	74 02                	je     801042e7 <argfd+0x39>
    *pfd = fd;
801042e5:	89 16                	mov    %edx,(%esi)
  if(pf)
801042e7:	85 db                	test   %ebx,%ebx
801042e9:	74 1c                	je     80104307 <argfd+0x59>
    *pf = f;
801042eb:	89 03                	mov    %eax,(%ebx)
  return 0;
801042ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042f5:	5b                   	pop    %ebx
801042f6:	5e                   	pop    %esi
801042f7:	5d                   	pop    %ebp
801042f8:	c3                   	ret    
    return -1;
801042f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042fe:	eb f2                	jmp    801042f2 <argfd+0x44>
    return -1;
80104300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104305:	eb eb                	jmp    801042f2 <argfd+0x44>
  return 0;
80104307:	b8 00 00 00 00       	mov    $0x0,%eax
8010430c:	eb e4                	jmp    801042f2 <argfd+0x44>

8010430e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010430e:	55                   	push   %ebp
8010430f:	89 e5                	mov    %esp,%ebp
80104311:	53                   	push   %ebx
80104312:	83 ec 04             	sub    $0x4,%esp
80104315:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104317:	e8 2f ef ff ff       	call   8010324b <myproc>
8010431c:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010431e:	b8 00 00 00 00       	mov    $0x0,%eax
80104323:	83 f8 0f             	cmp    $0xf,%eax
80104326:	7f 10                	jg     80104338 <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
80104328:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
8010432d:	74 03                	je     80104332 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
8010432f:	40                   	inc    %eax
80104330:	eb f1                	jmp    80104323 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80104332:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104336:	eb 05                	jmp    8010433d <fdalloc+0x2f>
    }
  }
  return -1;
80104338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010433d:	83 c4 04             	add    $0x4,%esp
80104340:	5b                   	pop    %ebx
80104341:	5d                   	pop    %ebp
80104342:	c3                   	ret    

80104343 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80104343:	55                   	push   %ebp
80104344:	89 e5                	mov    %esp,%ebp
80104346:	56                   	push   %esi
80104347:	53                   	push   %ebx
80104348:	83 ec 10             	sub    $0x10,%esp
8010434b:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010434d:	b8 20 00 00 00       	mov    $0x20,%eax
80104352:	89 c6                	mov    %eax,%esi
80104354:	39 43 58             	cmp    %eax,0x58(%ebx)
80104357:	76 2e                	jbe    80104387 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104359:	6a 10                	push   $0x10
8010435b:	50                   	push   %eax
8010435c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010435f:	50                   	push   %eax
80104360:	53                   	push   %ebx
80104361:	e8 31 d4 ff ff       	call   80101797 <readi>
80104366:	83 c4 10             	add    $0x10,%esp
80104369:	83 f8 10             	cmp    $0x10,%eax
8010436c:	75 0c                	jne    8010437a <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010436e:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104373:	75 1e                	jne    80104393 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104375:	8d 46 10             	lea    0x10(%esi),%eax
80104378:	eb d8                	jmp    80104352 <isdirempty+0xf>
      panic("isdirempty: readi");
8010437a:	83 ec 0c             	sub    $0xc,%esp
8010437d:	68 e8 71 10 80       	push   $0x801071e8
80104382:	e8 ce bf ff ff       	call   80100355 <panic>
      return 0;
  }
  return 1;
80104387:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010438c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010438f:	5b                   	pop    %ebx
80104390:	5e                   	pop    %esi
80104391:	5d                   	pop    %ebp
80104392:	c3                   	ret    
      return 0;
80104393:	b8 00 00 00 00       	mov    $0x0,%eax
80104398:	eb f2                	jmp    8010438c <isdirempty+0x49>

8010439a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010439a:	55                   	push   %ebp
8010439b:	89 e5                	mov    %esp,%ebp
8010439d:	57                   	push   %edi
8010439e:	56                   	push   %esi
8010439f:	53                   	push   %ebx
801043a0:	83 ec 44             	sub    $0x44,%esp
801043a3:	89 d7                	mov    %edx,%edi
801043a5:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
801043a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043ab:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801043ae:	8d 55 d6             	lea    -0x2a(%ebp),%edx
801043b1:	52                   	push   %edx
801043b2:	50                   	push   %eax
801043b3:	e8 86 d8 ff ff       	call   80101c3e <nameiparent>
801043b8:	89 c6                	mov    %eax,%esi
801043ba:	83 c4 10             	add    $0x10,%esp
801043bd:	85 c0                	test   %eax,%eax
801043bf:	0f 84 32 01 00 00    	je     801044f7 <create+0x15d>
    return 0;
  ilock(dp);
801043c5:	83 ec 0c             	sub    $0xc,%esp
801043c8:	50                   	push   %eax
801043c9:	e8 c8 d1 ff ff       	call   80101596 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801043ce:	83 c4 0c             	add    $0xc,%esp
801043d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801043d4:	50                   	push   %eax
801043d5:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801043d8:	50                   	push   %eax
801043d9:	56                   	push   %esi
801043da:	e8 0d d6 ff ff       	call   801019ec <dirlookup>
801043df:	89 c3                	mov    %eax,%ebx
801043e1:	83 c4 10             	add    $0x10,%esp
801043e4:	85 c0                	test   %eax,%eax
801043e6:	74 3c                	je     80104424 <create+0x8a>
    iunlockput(dp);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	56                   	push   %esi
801043ec:	e8 54 d3 ff ff       	call   80101745 <iunlockput>
    ilock(ip);
801043f1:	89 1c 24             	mov    %ebx,(%esp)
801043f4:	e8 9d d1 ff ff       	call   80101596 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801043f9:	83 c4 10             	add    $0x10,%esp
801043fc:	66 83 ff 02          	cmp    $0x2,%di
80104400:	75 07                	jne    80104409 <create+0x6f>
80104402:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104407:	74 11                	je     8010441a <create+0x80>
      return ip;
    iunlockput(ip);
80104409:	83 ec 0c             	sub    $0xc,%esp
8010440c:	53                   	push   %ebx
8010440d:	e8 33 d3 ff ff       	call   80101745 <iunlockput>
    return 0;
80104412:	83 c4 10             	add    $0x10,%esp
80104415:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010441a:	89 d8                	mov    %ebx,%eax
8010441c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010441f:	5b                   	pop    %ebx
80104420:	5e                   	pop    %esi
80104421:	5f                   	pop    %edi
80104422:	5d                   	pop    %ebp
80104423:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104424:	83 ec 08             	sub    $0x8,%esp
80104427:	0f bf c7             	movswl %di,%eax
8010442a:	50                   	push   %eax
8010442b:	ff 36                	pushl  (%esi)
8010442d:	e8 60 cf ff ff       	call   80101392 <ialloc>
80104432:	89 c3                	mov    %eax,%ebx
80104434:	83 c4 10             	add    $0x10,%esp
80104437:	85 c0                	test   %eax,%eax
80104439:	74 53                	je     8010448e <create+0xf4>
  ilock(ip);
8010443b:	83 ec 0c             	sub    $0xc,%esp
8010443e:	50                   	push   %eax
8010443f:	e8 52 d1 ff ff       	call   80101596 <ilock>
  ip->major = major;
80104444:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104447:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010444b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010444e:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104452:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104458:	89 1c 24             	mov    %ebx,(%esp)
8010445b:	e8 d5 cf ff ff       	call   80101435 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104460:	83 c4 10             	add    $0x10,%esp
80104463:	66 83 ff 01          	cmp    $0x1,%di
80104467:	74 32                	je     8010449b <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
80104469:	83 ec 04             	sub    $0x4,%esp
8010446c:	ff 73 04             	pushl  0x4(%ebx)
8010446f:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104472:	50                   	push   %eax
80104473:	56                   	push   %esi
80104474:	e8 f4 d6 ff ff       	call   80101b6d <dirlink>
80104479:	83 c4 10             	add    $0x10,%esp
8010447c:	85 c0                	test   %eax,%eax
8010447e:	78 6a                	js     801044ea <create+0x150>
  iunlockput(dp);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	56                   	push   %esi
80104484:	e8 bc d2 ff ff       	call   80101745 <iunlockput>
  return ip;
80104489:	83 c4 10             	add    $0x10,%esp
8010448c:	eb 8c                	jmp    8010441a <create+0x80>
    panic("create: ialloc");
8010448e:	83 ec 0c             	sub    $0xc,%esp
80104491:	68 fa 71 10 80       	push   $0x801071fa
80104496:	e8 ba be ff ff       	call   80100355 <panic>
    dp->nlink++;  // for ".."
8010449b:	66 8b 46 56          	mov    0x56(%esi),%ax
8010449f:	40                   	inc    %eax
801044a0:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801044a4:	83 ec 0c             	sub    $0xc,%esp
801044a7:	56                   	push   %esi
801044a8:	e8 88 cf ff ff       	call   80101435 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801044ad:	83 c4 0c             	add    $0xc,%esp
801044b0:	ff 73 04             	pushl  0x4(%ebx)
801044b3:	68 0a 72 10 80       	push   $0x8010720a
801044b8:	53                   	push   %ebx
801044b9:	e8 af d6 ff ff       	call   80101b6d <dirlink>
801044be:	83 c4 10             	add    $0x10,%esp
801044c1:	85 c0                	test   %eax,%eax
801044c3:	78 18                	js     801044dd <create+0x143>
801044c5:	83 ec 04             	sub    $0x4,%esp
801044c8:	ff 76 04             	pushl  0x4(%esi)
801044cb:	68 09 72 10 80       	push   $0x80107209
801044d0:	53                   	push   %ebx
801044d1:	e8 97 d6 ff ff       	call   80101b6d <dirlink>
801044d6:	83 c4 10             	add    $0x10,%esp
801044d9:	85 c0                	test   %eax,%eax
801044db:	79 8c                	jns    80104469 <create+0xcf>
      panic("create dots");
801044dd:	83 ec 0c             	sub    $0xc,%esp
801044e0:	68 0c 72 10 80       	push   $0x8010720c
801044e5:	e8 6b be ff ff       	call   80100355 <panic>
    panic("create: dirlink");
801044ea:	83 ec 0c             	sub    $0xc,%esp
801044ed:	68 18 72 10 80       	push   $0x80107218
801044f2:	e8 5e be ff ff       	call   80100355 <panic>
    return 0;
801044f7:	89 c3                	mov    %eax,%ebx
801044f9:	e9 1c ff ff ff       	jmp    8010441a <create+0x80>

801044fe <sys_dup>:
{
801044fe:	f3 0f 1e fb          	endbr32 
80104502:	55                   	push   %ebp
80104503:	89 e5                	mov    %esp,%ebp
80104505:	53                   	push   %ebx
80104506:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104509:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010450c:	ba 00 00 00 00       	mov    $0x0,%edx
80104511:	b8 00 00 00 00       	mov    $0x0,%eax
80104516:	e8 93 fd ff ff       	call   801042ae <argfd>
8010451b:	85 c0                	test   %eax,%eax
8010451d:	78 23                	js     80104542 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
8010451f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104522:	e8 e7 fd ff ff       	call   8010430e <fdalloc>
80104527:	89 c3                	mov    %eax,%ebx
80104529:	85 c0                	test   %eax,%eax
8010452b:	78 1c                	js     80104549 <sys_dup+0x4b>
  filedup(f);
8010452d:	83 ec 0c             	sub    $0xc,%esp
80104530:	ff 75 f4             	pushl  -0xc(%ebp)
80104533:	e8 5e c7 ff ff       	call   80100c96 <filedup>
  return fd;
80104538:	83 c4 10             	add    $0x10,%esp
}
8010453b:	89 d8                	mov    %ebx,%eax
8010453d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104540:	c9                   	leave  
80104541:	c3                   	ret    
    return -1;
80104542:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104547:	eb f2                	jmp    8010453b <sys_dup+0x3d>
    return -1;
80104549:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010454e:	eb eb                	jmp    8010453b <sys_dup+0x3d>

80104550 <sys_dup2>:
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	56                   	push   %esi
80104558:	53                   	push   %ebx
80104559:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, &oldfd, &f) < 0)
8010455c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010455f:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104562:	b8 00 00 00 00       	mov    $0x0,%eax
80104567:	e8 42 fd ff ff       	call   801042ae <argfd>
8010456c:	85 c0                	test   %eax,%eax
8010456e:	78 79                	js     801045e9 <sys_dup2+0x99>
  if (argint(1, &newfd) < 0)
80104570:	83 ec 08             	sub    $0x8,%esp
80104573:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104576:	50                   	push   %eax
80104577:	6a 01                	push   $0x1
80104579:	e8 06 fc ff ff       	call   80104184 <argint>
8010457e:	83 c4 10             	add    $0x10,%esp
80104581:	85 c0                	test   %eax,%eax
80104583:	78 6b                	js     801045f0 <sys_dup2+0xa0>
  if (newfd < 0 || newfd >= NOFILE)
80104585:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104588:	83 f8 0f             	cmp    $0xf,%eax
8010458b:	77 6a                	ja     801045f7 <sys_dup2+0xa7>
  if (oldfd == newfd) {
8010458d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104590:	74 40                	je     801045d2 <sys_dup2+0x82>
  if (argfd(1, 0, &newf) == 0)
80104592:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104595:	ba 00 00 00 00       	mov    $0x0,%edx
8010459a:	b8 01 00 00 00       	mov    $0x1,%eax
8010459f:	e8 0a fd ff ff       	call   801042ae <argfd>
801045a4:	85 c0                	test   %eax,%eax
801045a6:	74 31                	je     801045d9 <sys_dup2+0x89>
  filedup(f);
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	ff 75 f4             	pushl  -0xc(%ebp)
801045ae:	e8 e3 c6 ff ff       	call   80100c96 <filedup>
  myproc()->ofile[newfd] = myproc()->ofile[oldfd]; 
801045b3:	e8 93 ec ff ff       	call   8010324b <myproc>
801045b8:	89 c3                	mov    %eax,%ebx
801045ba:	8b 75 ec             	mov    -0x14(%ebp),%esi
801045bd:	e8 89 ec ff ff       	call   8010324b <myproc>
801045c2:	89 c2                	mov    %eax,%edx
801045c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801045c7:	8b 4c b3 28          	mov    0x28(%ebx,%esi,4),%ecx
801045cb:	89 4c 82 28          	mov    %ecx,0x28(%edx,%eax,4)
  return newfd;
801045cf:	83 c4 10             	add    $0x10,%esp
}
801045d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045d5:	5b                   	pop    %ebx
801045d6:	5e                   	pop    %esi
801045d7:	5d                   	pop    %ebp
801045d8:	c3                   	ret    
          fileclose(newf);
801045d9:	83 ec 0c             	sub    $0xc,%esp
801045dc:	ff 75 f0             	pushl  -0x10(%ebp)
801045df:	e8 f9 c6 ff ff       	call   80100cdd <fileclose>
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	eb bf                	jmp    801045a8 <sys_dup2+0x58>
    return -1;
801045e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ee:	eb e2                	jmp    801045d2 <sys_dup2+0x82>
    return -1;
801045f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f5:	eb db                	jmp    801045d2 <sys_dup2+0x82>
         return -1;
801045f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fc:	eb d4                	jmp    801045d2 <sys_dup2+0x82>

801045fe <sys_read>:
{
801045fe:	f3 0f 1e fb          	endbr32 
80104602:	55                   	push   %ebp
80104603:	89 e5                	mov    %esp,%ebp
80104605:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104608:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010460b:	ba 00 00 00 00       	mov    $0x0,%edx
80104610:	b8 00 00 00 00       	mov    $0x0,%eax
80104615:	e8 94 fc ff ff       	call   801042ae <argfd>
8010461a:	85 c0                	test   %eax,%eax
8010461c:	78 43                	js     80104661 <sys_read+0x63>
8010461e:	83 ec 08             	sub    $0x8,%esp
80104621:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104624:	50                   	push   %eax
80104625:	6a 02                	push   $0x2
80104627:	e8 58 fb ff ff       	call   80104184 <argint>
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	85 c0                	test   %eax,%eax
80104631:	78 2e                	js     80104661 <sys_read+0x63>
80104633:	83 ec 04             	sub    $0x4,%esp
80104636:	ff 75 f0             	pushl  -0x10(%ebp)
80104639:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010463c:	50                   	push   %eax
8010463d:	6a 01                	push   $0x1
8010463f:	e8 6c fb ff ff       	call   801041b0 <argptr>
80104644:	83 c4 10             	add    $0x10,%esp
80104647:	85 c0                	test   %eax,%eax
80104649:	78 16                	js     80104661 <sys_read+0x63>
  return fileread(f, p, n);
8010464b:	83 ec 04             	sub    $0x4,%esp
8010464e:	ff 75 f0             	pushl  -0x10(%ebp)
80104651:	ff 75 ec             	pushl  -0x14(%ebp)
80104654:	ff 75 f4             	pushl  -0xc(%ebp)
80104657:	e8 82 c7 ff ff       	call   80100dde <fileread>
8010465c:	83 c4 10             	add    $0x10,%esp
}
8010465f:	c9                   	leave  
80104660:	c3                   	ret    
    return -1;
80104661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104666:	eb f7                	jmp    8010465f <sys_read+0x61>

80104668 <sys_write>:
{
80104668:	f3 0f 1e fb          	endbr32 
8010466c:	55                   	push   %ebp
8010466d:	89 e5                	mov    %esp,%ebp
8010466f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104672:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104675:	ba 00 00 00 00       	mov    $0x0,%edx
8010467a:	b8 00 00 00 00       	mov    $0x0,%eax
8010467f:	e8 2a fc ff ff       	call   801042ae <argfd>
80104684:	85 c0                	test   %eax,%eax
80104686:	78 43                	js     801046cb <sys_write+0x63>
80104688:	83 ec 08             	sub    $0x8,%esp
8010468b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010468e:	50                   	push   %eax
8010468f:	6a 02                	push   $0x2
80104691:	e8 ee fa ff ff       	call   80104184 <argint>
80104696:	83 c4 10             	add    $0x10,%esp
80104699:	85 c0                	test   %eax,%eax
8010469b:	78 2e                	js     801046cb <sys_write+0x63>
8010469d:	83 ec 04             	sub    $0x4,%esp
801046a0:	ff 75 f0             	pushl  -0x10(%ebp)
801046a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801046a6:	50                   	push   %eax
801046a7:	6a 01                	push   $0x1
801046a9:	e8 02 fb ff ff       	call   801041b0 <argptr>
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	85 c0                	test   %eax,%eax
801046b3:	78 16                	js     801046cb <sys_write+0x63>
  return filewrite(f, p, n);
801046b5:	83 ec 04             	sub    $0x4,%esp
801046b8:	ff 75 f0             	pushl  -0x10(%ebp)
801046bb:	ff 75 ec             	pushl  -0x14(%ebp)
801046be:	ff 75 f4             	pushl  -0xc(%ebp)
801046c1:	e8 a1 c7 ff ff       	call   80100e67 <filewrite>
801046c6:	83 c4 10             	add    $0x10,%esp
}
801046c9:	c9                   	leave  
801046ca:	c3                   	ret    
    return -1;
801046cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d0:	eb f7                	jmp    801046c9 <sys_write+0x61>

801046d2 <sys_close>:
{
801046d2:	f3 0f 1e fb          	endbr32 
801046d6:	55                   	push   %ebp
801046d7:	89 e5                	mov    %esp,%ebp
801046d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801046dc:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801046df:	8d 55 f4             	lea    -0xc(%ebp),%edx
801046e2:	b8 00 00 00 00       	mov    $0x0,%eax
801046e7:	e8 c2 fb ff ff       	call   801042ae <argfd>
801046ec:	85 c0                	test   %eax,%eax
801046ee:	78 25                	js     80104715 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
801046f0:	e8 56 eb ff ff       	call   8010324b <myproc>
801046f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046f8:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801046ff:	00 
  fileclose(f);
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	ff 75 f0             	pushl  -0x10(%ebp)
80104706:	e8 d2 c5 ff ff       	call   80100cdd <fileclose>
  return 0;
8010470b:	83 c4 10             	add    $0x10,%esp
8010470e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104713:	c9                   	leave  
80104714:	c3                   	ret    
    return -1;
80104715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010471a:	eb f7                	jmp    80104713 <sys_close+0x41>

8010471c <sys_fstat>:
{
8010471c:	f3 0f 1e fb          	endbr32 
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104726:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104729:	ba 00 00 00 00       	mov    $0x0,%edx
8010472e:	b8 00 00 00 00       	mov    $0x0,%eax
80104733:	e8 76 fb ff ff       	call   801042ae <argfd>
80104738:	85 c0                	test   %eax,%eax
8010473a:	78 2a                	js     80104766 <sys_fstat+0x4a>
8010473c:	83 ec 04             	sub    $0x4,%esp
8010473f:	6a 14                	push   $0x14
80104741:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104744:	50                   	push   %eax
80104745:	6a 01                	push   $0x1
80104747:	e8 64 fa ff ff       	call   801041b0 <argptr>
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	85 c0                	test   %eax,%eax
80104751:	78 13                	js     80104766 <sys_fstat+0x4a>
  return filestat(f, st);
80104753:	83 ec 08             	sub    $0x8,%esp
80104756:	ff 75 f0             	pushl  -0x10(%ebp)
80104759:	ff 75 f4             	pushl  -0xc(%ebp)
8010475c:	e8 32 c6 ff ff       	call   80100d93 <filestat>
80104761:	83 c4 10             	add    $0x10,%esp
}
80104764:	c9                   	leave  
80104765:	c3                   	ret    
    return -1;
80104766:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476b:	eb f7                	jmp    80104764 <sys_fstat+0x48>

8010476d <sys_link>:
{
8010476d:	f3 0f 1e fb          	endbr32 
80104771:	55                   	push   %ebp
80104772:	89 e5                	mov    %esp,%ebp
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104779:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010477c:	50                   	push   %eax
8010477d:	6a 00                	push   $0x0
8010477f:	e8 98 fa ff ff       	call   8010421c <argstr>
80104784:	83 c4 10             	add    $0x10,%esp
80104787:	85 c0                	test   %eax,%eax
80104789:	0f 88 d1 00 00 00    	js     80104860 <sys_link+0xf3>
8010478f:	83 ec 08             	sub    $0x8,%esp
80104792:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104795:	50                   	push   %eax
80104796:	6a 01                	push   $0x1
80104798:	e8 7f fa ff ff       	call   8010421c <argstr>
8010479d:	83 c4 10             	add    $0x10,%esp
801047a0:	85 c0                	test   %eax,%eax
801047a2:	0f 88 b8 00 00 00    	js     80104860 <sys_link+0xf3>
  begin_op();
801047a8:	e8 36 e0 ff ff       	call   801027e3 <begin_op>
  if((ip = namei(old)) == 0){
801047ad:	83 ec 0c             	sub    $0xc,%esp
801047b0:	ff 75 e0             	pushl  -0x20(%ebp)
801047b3:	e8 6a d4 ff ff       	call   80101c22 <namei>
801047b8:	89 c3                	mov    %eax,%ebx
801047ba:	83 c4 10             	add    $0x10,%esp
801047bd:	85 c0                	test   %eax,%eax
801047bf:	0f 84 a2 00 00 00    	je     80104867 <sys_link+0xfa>
  ilock(ip);
801047c5:	83 ec 0c             	sub    $0xc,%esp
801047c8:	50                   	push   %eax
801047c9:	e8 c8 cd ff ff       	call   80101596 <ilock>
  if(ip->type == T_DIR){
801047ce:	83 c4 10             	add    $0x10,%esp
801047d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047d6:	0f 84 97 00 00 00    	je     80104873 <sys_link+0x106>
  ip->nlink++;
801047dc:	66 8b 43 56          	mov    0x56(%ebx),%ax
801047e0:	40                   	inc    %eax
801047e1:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801047e5:	83 ec 0c             	sub    $0xc,%esp
801047e8:	53                   	push   %ebx
801047e9:	e8 47 cc ff ff       	call   80101435 <iupdate>
  iunlock(ip);
801047ee:	89 1c 24             	mov    %ebx,(%esp)
801047f1:	e8 64 ce ff ff       	call   8010165a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801047f6:	83 c4 08             	add    $0x8,%esp
801047f9:	8d 45 ea             	lea    -0x16(%ebp),%eax
801047fc:	50                   	push   %eax
801047fd:	ff 75 e4             	pushl  -0x1c(%ebp)
80104800:	e8 39 d4 ff ff       	call   80101c3e <nameiparent>
80104805:	89 c6                	mov    %eax,%esi
80104807:	83 c4 10             	add    $0x10,%esp
8010480a:	85 c0                	test   %eax,%eax
8010480c:	0f 84 85 00 00 00    	je     80104897 <sys_link+0x12a>
  ilock(dp);
80104812:	83 ec 0c             	sub    $0xc,%esp
80104815:	50                   	push   %eax
80104816:	e8 7b cd ff ff       	call   80101596 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010481b:	83 c4 10             	add    $0x10,%esp
8010481e:	8b 03                	mov    (%ebx),%eax
80104820:	39 06                	cmp    %eax,(%esi)
80104822:	75 67                	jne    8010488b <sys_link+0x11e>
80104824:	83 ec 04             	sub    $0x4,%esp
80104827:	ff 73 04             	pushl  0x4(%ebx)
8010482a:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010482d:	50                   	push   %eax
8010482e:	56                   	push   %esi
8010482f:	e8 39 d3 ff ff       	call   80101b6d <dirlink>
80104834:	83 c4 10             	add    $0x10,%esp
80104837:	85 c0                	test   %eax,%eax
80104839:	78 50                	js     8010488b <sys_link+0x11e>
  iunlockput(dp);
8010483b:	83 ec 0c             	sub    $0xc,%esp
8010483e:	56                   	push   %esi
8010483f:	e8 01 cf ff ff       	call   80101745 <iunlockput>
  iput(ip);
80104844:	89 1c 24             	mov    %ebx,(%esp)
80104847:	e8 57 ce ff ff       	call   801016a3 <iput>
  end_op();
8010484c:	e8 12 e0 ff ff       	call   80102863 <end_op>
  return 0;
80104851:	83 c4 10             	add    $0x10,%esp
80104854:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104859:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010485c:	5b                   	pop    %ebx
8010485d:	5e                   	pop    %esi
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    
    return -1;
80104860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104865:	eb f2                	jmp    80104859 <sys_link+0xec>
    end_op();
80104867:	e8 f7 df ff ff       	call   80102863 <end_op>
    return -1;
8010486c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104871:	eb e6                	jmp    80104859 <sys_link+0xec>
    iunlockput(ip);
80104873:	83 ec 0c             	sub    $0xc,%esp
80104876:	53                   	push   %ebx
80104877:	e8 c9 ce ff ff       	call   80101745 <iunlockput>
    end_op();
8010487c:	e8 e2 df ff ff       	call   80102863 <end_op>
    return -1;
80104881:	83 c4 10             	add    $0x10,%esp
80104884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104889:	eb ce                	jmp    80104859 <sys_link+0xec>
    iunlockput(dp);
8010488b:	83 ec 0c             	sub    $0xc,%esp
8010488e:	56                   	push   %esi
8010488f:	e8 b1 ce ff ff       	call   80101745 <iunlockput>
    goto bad;
80104894:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104897:	83 ec 0c             	sub    $0xc,%esp
8010489a:	53                   	push   %ebx
8010489b:	e8 f6 cc ff ff       	call   80101596 <ilock>
  ip->nlink--;
801048a0:	66 8b 43 56          	mov    0x56(%ebx),%ax
801048a4:	48                   	dec    %eax
801048a5:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801048a9:	89 1c 24             	mov    %ebx,(%esp)
801048ac:	e8 84 cb ff ff       	call   80101435 <iupdate>
  iunlockput(ip);
801048b1:	89 1c 24             	mov    %ebx,(%esp)
801048b4:	e8 8c ce ff ff       	call   80101745 <iunlockput>
  end_op();
801048b9:	e8 a5 df ff ff       	call   80102863 <end_op>
  return -1;
801048be:	83 c4 10             	add    $0x10,%esp
801048c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c6:	eb 91                	jmp    80104859 <sys_link+0xec>

801048c8 <sys_unlink>:
{
801048c8:	f3 0f 1e fb          	endbr32 
801048cc:	55                   	push   %ebp
801048cd:	89 e5                	mov    %esp,%ebp
801048cf:	57                   	push   %edi
801048d0:	56                   	push   %esi
801048d1:	53                   	push   %ebx
801048d2:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801048d5:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801048d8:	50                   	push   %eax
801048d9:	6a 00                	push   $0x0
801048db:	e8 3c f9 ff ff       	call   8010421c <argstr>
801048e0:	83 c4 10             	add    $0x10,%esp
801048e3:	85 c0                	test   %eax,%eax
801048e5:	0f 88 7f 01 00 00    	js     80104a6a <sys_unlink+0x1a2>
  begin_op();
801048eb:	e8 f3 de ff ff       	call   801027e3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801048f0:	83 ec 08             	sub    $0x8,%esp
801048f3:	8d 45 ca             	lea    -0x36(%ebp),%eax
801048f6:	50                   	push   %eax
801048f7:	ff 75 c4             	pushl  -0x3c(%ebp)
801048fa:	e8 3f d3 ff ff       	call   80101c3e <nameiparent>
801048ff:	89 c6                	mov    %eax,%esi
80104901:	83 c4 10             	add    $0x10,%esp
80104904:	85 c0                	test   %eax,%eax
80104906:	0f 84 eb 00 00 00    	je     801049f7 <sys_unlink+0x12f>
  ilock(dp);
8010490c:	83 ec 0c             	sub    $0xc,%esp
8010490f:	50                   	push   %eax
80104910:	e8 81 cc ff ff       	call   80101596 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104915:	83 c4 08             	add    $0x8,%esp
80104918:	68 0a 72 10 80       	push   $0x8010720a
8010491d:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104920:	50                   	push   %eax
80104921:	e8 ad d0 ff ff       	call   801019d3 <namecmp>
80104926:	83 c4 10             	add    $0x10,%esp
80104929:	85 c0                	test   %eax,%eax
8010492b:	0f 84 fa 00 00 00    	je     80104a2b <sys_unlink+0x163>
80104931:	83 ec 08             	sub    $0x8,%esp
80104934:	68 09 72 10 80       	push   $0x80107209
80104939:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010493c:	50                   	push   %eax
8010493d:	e8 91 d0 ff ff       	call   801019d3 <namecmp>
80104942:	83 c4 10             	add    $0x10,%esp
80104945:	85 c0                	test   %eax,%eax
80104947:	0f 84 de 00 00 00    	je     80104a2b <sys_unlink+0x163>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010494d:	83 ec 04             	sub    $0x4,%esp
80104950:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104953:	50                   	push   %eax
80104954:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104957:	50                   	push   %eax
80104958:	56                   	push   %esi
80104959:	e8 8e d0 ff ff       	call   801019ec <dirlookup>
8010495e:	89 c3                	mov    %eax,%ebx
80104960:	83 c4 10             	add    $0x10,%esp
80104963:	85 c0                	test   %eax,%eax
80104965:	0f 84 c0 00 00 00    	je     80104a2b <sys_unlink+0x163>
  ilock(ip);
8010496b:	83 ec 0c             	sub    $0xc,%esp
8010496e:	50                   	push   %eax
8010496f:	e8 22 cc ff ff       	call   80101596 <ilock>
  if(ip->nlink < 1)
80104974:	83 c4 10             	add    $0x10,%esp
80104977:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010497c:	0f 8e 81 00 00 00    	jle    80104a03 <sys_unlink+0x13b>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104982:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104987:	0f 84 83 00 00 00    	je     80104a10 <sys_unlink+0x148>
  memset(&de, 0, sizeof(de));
8010498d:	83 ec 04             	sub    $0x4,%esp
80104990:	6a 10                	push   $0x10
80104992:	6a 00                	push   $0x0
80104994:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104997:	57                   	push   %edi
80104998:	e8 8e f5 ff ff       	call   80103f2b <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010499d:	6a 10                	push   $0x10
8010499f:	ff 75 c0             	pushl  -0x40(%ebp)
801049a2:	57                   	push   %edi
801049a3:	56                   	push   %esi
801049a4:	e8 f2 ce ff ff       	call   8010189b <writei>
801049a9:	83 c4 20             	add    $0x20,%esp
801049ac:	83 f8 10             	cmp    $0x10,%eax
801049af:	0f 85 8e 00 00 00    	jne    80104a43 <sys_unlink+0x17b>
  if(ip->type == T_DIR){
801049b5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801049ba:	0f 84 90 00 00 00    	je     80104a50 <sys_unlink+0x188>
  iunlockput(dp);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	56                   	push   %esi
801049c4:	e8 7c cd ff ff       	call   80101745 <iunlockput>
  ip->nlink--;
801049c9:	66 8b 43 56          	mov    0x56(%ebx),%ax
801049cd:	48                   	dec    %eax
801049ce:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049d2:	89 1c 24             	mov    %ebx,(%esp)
801049d5:	e8 5b ca ff ff       	call   80101435 <iupdate>
  iunlockput(ip);
801049da:	89 1c 24             	mov    %ebx,(%esp)
801049dd:	e8 63 cd ff ff       	call   80101745 <iunlockput>
  end_op();
801049e2:	e8 7c de ff ff       	call   80102863 <end_op>
  return 0;
801049e7:	83 c4 10             	add    $0x10,%esp
801049ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049f2:	5b                   	pop    %ebx
801049f3:	5e                   	pop    %esi
801049f4:	5f                   	pop    %edi
801049f5:	5d                   	pop    %ebp
801049f6:	c3                   	ret    
    end_op();
801049f7:	e8 67 de ff ff       	call   80102863 <end_op>
    return -1;
801049fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a01:	eb ec                	jmp    801049ef <sys_unlink+0x127>
    panic("unlink: nlink < 1");
80104a03:	83 ec 0c             	sub    $0xc,%esp
80104a06:	68 28 72 10 80       	push   $0x80107228
80104a0b:	e8 45 b9 ff ff       	call   80100355 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104a10:	89 d8                	mov    %ebx,%eax
80104a12:	e8 2c f9 ff ff       	call   80104343 <isdirempty>
80104a17:	85 c0                	test   %eax,%eax
80104a19:	0f 85 6e ff ff ff    	jne    8010498d <sys_unlink+0xc5>
    iunlockput(ip);
80104a1f:	83 ec 0c             	sub    $0xc,%esp
80104a22:	53                   	push   %ebx
80104a23:	e8 1d cd ff ff       	call   80101745 <iunlockput>
    goto bad;
80104a28:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104a2b:	83 ec 0c             	sub    $0xc,%esp
80104a2e:	56                   	push   %esi
80104a2f:	e8 11 cd ff ff       	call   80101745 <iunlockput>
  end_op();
80104a34:	e8 2a de ff ff       	call   80102863 <end_op>
  return -1;
80104a39:	83 c4 10             	add    $0x10,%esp
80104a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a41:	eb ac                	jmp    801049ef <sys_unlink+0x127>
    panic("unlink: writei");
80104a43:	83 ec 0c             	sub    $0xc,%esp
80104a46:	68 3a 72 10 80       	push   $0x8010723a
80104a4b:	e8 05 b9 ff ff       	call   80100355 <panic>
    dp->nlink--;
80104a50:	66 8b 46 56          	mov    0x56(%esi),%ax
80104a54:	48                   	dec    %eax
80104a55:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	56                   	push   %esi
80104a5d:	e8 d3 c9 ff ff       	call   80101435 <iupdate>
80104a62:	83 c4 10             	add    $0x10,%esp
80104a65:	e9 56 ff ff ff       	jmp    801049c0 <sys_unlink+0xf8>
    return -1;
80104a6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a6f:	e9 7b ff ff ff       	jmp    801049ef <sys_unlink+0x127>

80104a74 <sys_open>:

int
sys_open(void)
{
80104a74:	f3 0f 1e fb          	endbr32 
80104a78:	55                   	push   %ebp
80104a79:	89 e5                	mov    %esp,%ebp
80104a7b:	57                   	push   %edi
80104a7c:	56                   	push   %esi
80104a7d:	53                   	push   %ebx
80104a7e:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104a81:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104a84:	50                   	push   %eax
80104a85:	6a 00                	push   $0x0
80104a87:	e8 90 f7 ff ff       	call   8010421c <argstr>
80104a8c:	83 c4 10             	add    $0x10,%esp
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	0f 88 a0 00 00 00    	js     80104b37 <sys_open+0xc3>
80104a97:	83 ec 08             	sub    $0x8,%esp
80104a9a:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104a9d:	50                   	push   %eax
80104a9e:	6a 01                	push   $0x1
80104aa0:	e8 df f6 ff ff       	call   80104184 <argint>
80104aa5:	83 c4 10             	add    $0x10,%esp
80104aa8:	85 c0                	test   %eax,%eax
80104aaa:	0f 88 87 00 00 00    	js     80104b37 <sys_open+0xc3>
    return -1;

  begin_op();
80104ab0:	e8 2e dd ff ff       	call   801027e3 <begin_op>

  if(omode & O_CREATE){
80104ab5:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104ab9:	0f 84 8b 00 00 00    	je     80104b4a <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
80104abf:	83 ec 0c             	sub    $0xc,%esp
80104ac2:	6a 00                	push   $0x0
80104ac4:	b9 00 00 00 00       	mov    $0x0,%ecx
80104ac9:	ba 02 00 00 00       	mov    $0x2,%edx
80104ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ad1:	e8 c4 f8 ff ff       	call   8010439a <create>
80104ad6:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104ad8:	83 c4 10             	add    $0x10,%esp
80104adb:	85 c0                	test   %eax,%eax
80104add:	74 5f                	je     80104b3e <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104adf:	e8 4d c1 ff ff       	call   80100c31 <filealloc>
80104ae4:	89 c3                	mov    %eax,%ebx
80104ae6:	85 c0                	test   %eax,%eax
80104ae8:	0f 84 b5 00 00 00    	je     80104ba3 <sys_open+0x12f>
80104aee:	e8 1b f8 ff ff       	call   8010430e <fdalloc>
80104af3:	89 c7                	mov    %eax,%edi
80104af5:	85 c0                	test   %eax,%eax
80104af7:	0f 88 a6 00 00 00    	js     80104ba3 <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104afd:	83 ec 0c             	sub    $0xc,%esp
80104b00:	56                   	push   %esi
80104b01:	e8 54 cb ff ff       	call   8010165a <iunlock>
  end_op();
80104b06:	e8 58 dd ff ff       	call   80102863 <end_op>

  f->type = FD_INODE;
80104b0b:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104b11:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104b14:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b1e:	83 c4 10             	add    $0x10,%esp
80104b21:	a8 01                	test   $0x1,%al
80104b23:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104b27:	a8 03                	test   $0x3,%al
80104b29:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104b2d:	89 f8                	mov    %edi,%eax
80104b2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b32:	5b                   	pop    %ebx
80104b33:	5e                   	pop    %esi
80104b34:	5f                   	pop    %edi
80104b35:	5d                   	pop    %ebp
80104b36:	c3                   	ret    
    return -1;
80104b37:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b3c:	eb ef                	jmp    80104b2d <sys_open+0xb9>
      end_op();
80104b3e:	e8 20 dd ff ff       	call   80102863 <end_op>
      return -1;
80104b43:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b48:	eb e3                	jmp    80104b2d <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	ff 75 e4             	pushl  -0x1c(%ebp)
80104b50:	e8 cd d0 ff ff       	call   80101c22 <namei>
80104b55:	89 c6                	mov    %eax,%esi
80104b57:	83 c4 10             	add    $0x10,%esp
80104b5a:	85 c0                	test   %eax,%eax
80104b5c:	74 39                	je     80104b97 <sys_open+0x123>
    ilock(ip);
80104b5e:	83 ec 0c             	sub    $0xc,%esp
80104b61:	50                   	push   %eax
80104b62:	e8 2f ca ff ff       	call   80101596 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104b67:	83 c4 10             	add    $0x10,%esp
80104b6a:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104b6f:	0f 85 6a ff ff ff    	jne    80104adf <sys_open+0x6b>
80104b75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104b79:	0f 84 60 ff ff ff    	je     80104adf <sys_open+0x6b>
      iunlockput(ip);
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	56                   	push   %esi
80104b83:	e8 bd cb ff ff       	call   80101745 <iunlockput>
      end_op();
80104b88:	e8 d6 dc ff ff       	call   80102863 <end_op>
      return -1;
80104b8d:	83 c4 10             	add    $0x10,%esp
80104b90:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104b95:	eb 96                	jmp    80104b2d <sys_open+0xb9>
      end_op();
80104b97:	e8 c7 dc ff ff       	call   80102863 <end_op>
      return -1;
80104b9c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ba1:	eb 8a                	jmp    80104b2d <sys_open+0xb9>
    if(f)
80104ba3:	85 db                	test   %ebx,%ebx
80104ba5:	74 0c                	je     80104bb3 <sys_open+0x13f>
      fileclose(f);
80104ba7:	83 ec 0c             	sub    $0xc,%esp
80104baa:	53                   	push   %ebx
80104bab:	e8 2d c1 ff ff       	call   80100cdd <fileclose>
80104bb0:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104bb3:	83 ec 0c             	sub    $0xc,%esp
80104bb6:	56                   	push   %esi
80104bb7:	e8 89 cb ff ff       	call   80101745 <iunlockput>
    end_op();
80104bbc:	e8 a2 dc ff ff       	call   80102863 <end_op>
    return -1;
80104bc1:	83 c4 10             	add    $0x10,%esp
80104bc4:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104bc9:	e9 5f ff ff ff       	jmp    80104b2d <sys_open+0xb9>

80104bce <sys_mkdir>:

int
sys_mkdir(void)
{
80104bce:	f3 0f 1e fb          	endbr32 
80104bd2:	55                   	push   %ebp
80104bd3:	89 e5                	mov    %esp,%ebp
80104bd5:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104bd8:	e8 06 dc ff ff       	call   801027e3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104bdd:	83 ec 08             	sub    $0x8,%esp
80104be0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104be3:	50                   	push   %eax
80104be4:	6a 00                	push   $0x0
80104be6:	e8 31 f6 ff ff       	call   8010421c <argstr>
80104beb:	83 c4 10             	add    $0x10,%esp
80104bee:	85 c0                	test   %eax,%eax
80104bf0:	78 36                	js     80104c28 <sys_mkdir+0x5a>
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	6a 00                	push   $0x0
80104bf7:	b9 00 00 00 00       	mov    $0x0,%ecx
80104bfc:	ba 01 00 00 00       	mov    $0x1,%edx
80104c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c04:	e8 91 f7 ff ff       	call   8010439a <create>
80104c09:	83 c4 10             	add    $0x10,%esp
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	74 18                	je     80104c28 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c10:	83 ec 0c             	sub    $0xc,%esp
80104c13:	50                   	push   %eax
80104c14:	e8 2c cb ff ff       	call   80101745 <iunlockput>
  end_op();
80104c19:	e8 45 dc ff ff       	call   80102863 <end_op>
  return 0;
80104c1e:	83 c4 10             	add    $0x10,%esp
80104c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c26:	c9                   	leave  
80104c27:	c3                   	ret    
    end_op();
80104c28:	e8 36 dc ff ff       	call   80102863 <end_op>
    return -1;
80104c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c32:	eb f2                	jmp    80104c26 <sys_mkdir+0x58>

80104c34 <sys_mknod>:

int
sys_mknod(void)
{
80104c34:	f3 0f 1e fb          	endbr32 
80104c38:	55                   	push   %ebp
80104c39:	89 e5                	mov    %esp,%ebp
80104c3b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104c3e:	e8 a0 db ff ff       	call   801027e3 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104c43:	83 ec 08             	sub    $0x8,%esp
80104c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c49:	50                   	push   %eax
80104c4a:	6a 00                	push   $0x0
80104c4c:	e8 cb f5 ff ff       	call   8010421c <argstr>
80104c51:	83 c4 10             	add    $0x10,%esp
80104c54:	85 c0                	test   %eax,%eax
80104c56:	78 62                	js     80104cba <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104c58:	83 ec 08             	sub    $0x8,%esp
80104c5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5e:	50                   	push   %eax
80104c5f:	6a 01                	push   $0x1
80104c61:	e8 1e f5 ff ff       	call   80104184 <argint>
  if((argstr(0, &path)) < 0 ||
80104c66:	83 c4 10             	add    $0x10,%esp
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	78 4d                	js     80104cba <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104c6d:	83 ec 08             	sub    $0x8,%esp
80104c70:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c73:	50                   	push   %eax
80104c74:	6a 02                	push   $0x2
80104c76:	e8 09 f5 ff ff       	call   80104184 <argint>
     argint(1, &major) < 0 ||
80104c7b:	83 c4 10             	add    $0x10,%esp
80104c7e:	85 c0                	test   %eax,%eax
80104c80:	78 38                	js     80104cba <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104c82:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104c86:	83 ec 0c             	sub    $0xc,%esp
80104c89:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104c8d:	50                   	push   %eax
80104c8e:	ba 03 00 00 00       	mov    $0x3,%edx
80104c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c96:	e8 ff f6 ff ff       	call   8010439a <create>
     argint(2, &minor) < 0 ||
80104c9b:	83 c4 10             	add    $0x10,%esp
80104c9e:	85 c0                	test   %eax,%eax
80104ca0:	74 18                	je     80104cba <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ca2:	83 ec 0c             	sub    $0xc,%esp
80104ca5:	50                   	push   %eax
80104ca6:	e8 9a ca ff ff       	call   80101745 <iunlockput>
  end_op();
80104cab:	e8 b3 db ff ff       	call   80102863 <end_op>
  return 0;
80104cb0:	83 c4 10             	add    $0x10,%esp
80104cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cb8:	c9                   	leave  
80104cb9:	c3                   	ret    
    end_op();
80104cba:	e8 a4 db ff ff       	call   80102863 <end_op>
    return -1;
80104cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc4:	eb f2                	jmp    80104cb8 <sys_mknod+0x84>

80104cc6 <sys_chdir>:

int
sys_chdir(void)
{
80104cc6:	f3 0f 1e fb          	endbr32 
80104cca:	55                   	push   %ebp
80104ccb:	89 e5                	mov    %esp,%ebp
80104ccd:	56                   	push   %esi
80104cce:	53                   	push   %ebx
80104ccf:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104cd2:	e8 74 e5 ff ff       	call   8010324b <myproc>
80104cd7:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104cd9:	e8 05 db ff ff       	call   801027e3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104cde:	83 ec 08             	sub    $0x8,%esp
80104ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce4:	50                   	push   %eax
80104ce5:	6a 00                	push   $0x0
80104ce7:	e8 30 f5 ff ff       	call   8010421c <argstr>
80104cec:	83 c4 10             	add    $0x10,%esp
80104cef:	85 c0                	test   %eax,%eax
80104cf1:	78 52                	js     80104d45 <sys_chdir+0x7f>
80104cf3:	83 ec 0c             	sub    $0xc,%esp
80104cf6:	ff 75 f4             	pushl  -0xc(%ebp)
80104cf9:	e8 24 cf ff ff       	call   80101c22 <namei>
80104cfe:	89 c3                	mov    %eax,%ebx
80104d00:	83 c4 10             	add    $0x10,%esp
80104d03:	85 c0                	test   %eax,%eax
80104d05:	74 3e                	je     80104d45 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104d07:	83 ec 0c             	sub    $0xc,%esp
80104d0a:	50                   	push   %eax
80104d0b:	e8 86 c8 ff ff       	call   80101596 <ilock>
  if(ip->type != T_DIR){
80104d10:	83 c4 10             	add    $0x10,%esp
80104d13:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d18:	75 37                	jne    80104d51 <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104d1a:	83 ec 0c             	sub    $0xc,%esp
80104d1d:	53                   	push   %ebx
80104d1e:	e8 37 c9 ff ff       	call   8010165a <iunlock>
  iput(curproc->cwd);
80104d23:	83 c4 04             	add    $0x4,%esp
80104d26:	ff 76 68             	pushl  0x68(%esi)
80104d29:	e8 75 c9 ff ff       	call   801016a3 <iput>
  end_op();
80104d2e:	e8 30 db ff ff       	call   80102863 <end_op>
  curproc->cwd = ip;
80104d33:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104d36:	83 c4 10             	add    $0x10,%esp
80104d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d41:	5b                   	pop    %ebx
80104d42:	5e                   	pop    %esi
80104d43:	5d                   	pop    %ebp
80104d44:	c3                   	ret    
    end_op();
80104d45:	e8 19 db ff ff       	call   80102863 <end_op>
    return -1;
80104d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d4f:	eb ed                	jmp    80104d3e <sys_chdir+0x78>
    iunlockput(ip);
80104d51:	83 ec 0c             	sub    $0xc,%esp
80104d54:	53                   	push   %ebx
80104d55:	e8 eb c9 ff ff       	call   80101745 <iunlockput>
    end_op();
80104d5a:	e8 04 db ff ff       	call   80102863 <end_op>
    return -1;
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d67:	eb d5                	jmp    80104d3e <sys_chdir+0x78>

80104d69 <sys_exec>:

int
sys_exec(void)
{
80104d69:	f3 0f 1e fb          	endbr32 
80104d6d:	55                   	push   %ebp
80104d6e:	89 e5                	mov    %esp,%ebp
80104d70:	53                   	push   %ebx
80104d71:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d7a:	50                   	push   %eax
80104d7b:	6a 00                	push   $0x0
80104d7d:	e8 9a f4 ff ff       	call   8010421c <argstr>
80104d82:	83 c4 10             	add    $0x10,%esp
80104d85:	85 c0                	test   %eax,%eax
80104d87:	78 38                	js     80104dc1 <sys_exec+0x58>
80104d89:	83 ec 08             	sub    $0x8,%esp
80104d8c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104d92:	50                   	push   %eax
80104d93:	6a 01                	push   $0x1
80104d95:	e8 ea f3 ff ff       	call   80104184 <argint>
80104d9a:	83 c4 10             	add    $0x10,%esp
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	78 20                	js     80104dc1 <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104da1:	83 ec 04             	sub    $0x4,%esp
80104da4:	68 80 00 00 00       	push   $0x80
80104da9:	6a 00                	push   $0x0
80104dab:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104db1:	50                   	push   %eax
80104db2:	e8 74 f1 ff ff       	call   80103f2b <memset>
80104db7:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104dba:	bb 00 00 00 00       	mov    $0x0,%ebx
80104dbf:	eb 2a                	jmp    80104deb <sys_exec+0x82>
    return -1;
80104dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc6:	eb 76                	jmp    80104e3e <sys_exec+0xd5>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104dc8:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104dcf:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104dd3:	83 ec 08             	sub    $0x8,%esp
80104dd6:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104ddc:	50                   	push   %eax
80104ddd:	ff 75 f4             	pushl  -0xc(%ebp)
80104de0:	e8 da ba ff ff       	call   801008bf <exec>
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	eb 54                	jmp    80104e3e <sys_exec+0xd5>
  for(i=0;; i++){
80104dea:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104deb:	83 fb 1f             	cmp    $0x1f,%ebx
80104dee:	77 49                	ja     80104e39 <sys_exec+0xd0>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104df0:	83 ec 08             	sub    $0x8,%esp
80104df3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104df9:	50                   	push   %eax
80104dfa:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104e00:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104e03:	50                   	push   %eax
80104e04:	e8 f9 f2 ff ff       	call   80104102 <fetchint>
80104e09:	83 c4 10             	add    $0x10,%esp
80104e0c:	85 c0                	test   %eax,%eax
80104e0e:	78 33                	js     80104e43 <sys_exec+0xda>
    if(uarg == 0){
80104e10:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104e16:	85 c0                	test   %eax,%eax
80104e18:	74 ae                	je     80104dc8 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104e1a:	83 ec 08             	sub    $0x8,%esp
80104e1d:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104e24:	52                   	push   %edx
80104e25:	50                   	push   %eax
80104e26:	e8 17 f3 ff ff       	call   80104142 <fetchstr>
80104e2b:	83 c4 10             	add    $0x10,%esp
80104e2e:	85 c0                	test   %eax,%eax
80104e30:	79 b8                	jns    80104dea <sys_exec+0x81>
      return -1;
80104e32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e37:	eb 05                	jmp    80104e3e <sys_exec+0xd5>
      return -1;
80104e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    
      return -1;
80104e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e48:	eb f4                	jmp    80104e3e <sys_exec+0xd5>

80104e4a <sys_pipe>:

int
sys_pipe(void)
{
80104e4a:	f3 0f 1e fb          	endbr32 
80104e4e:	55                   	push   %ebp
80104e4f:	89 e5                	mov    %esp,%ebp
80104e51:	53                   	push   %ebx
80104e52:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104e55:	6a 08                	push   $0x8
80104e57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e5a:	50                   	push   %eax
80104e5b:	6a 00                	push   $0x0
80104e5d:	e8 4e f3 ff ff       	call   801041b0 <argptr>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 79                	js     80104ee2 <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104e69:	83 ec 08             	sub    $0x8,%esp
80104e6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e6f:	50                   	push   %eax
80104e70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e73:	50                   	push   %eax
80104e74:	e8 fd de ff ff       	call   80102d76 <pipealloc>
80104e79:	83 c4 10             	add    $0x10,%esp
80104e7c:	85 c0                	test   %eax,%eax
80104e7e:	78 69                	js     80104ee9 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e83:	e8 86 f4 ff ff       	call   8010430e <fdalloc>
80104e88:	89 c3                	mov    %eax,%ebx
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	78 21                	js     80104eaf <sys_pipe+0x65>
80104e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e91:	e8 78 f4 ff ff       	call   8010430e <fdalloc>
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 15                	js     80104eaf <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e9d:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea2:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104eaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ead:	c9                   	leave  
80104eae:	c3                   	ret    
    if(fd0 >= 0)
80104eaf:	85 db                	test   %ebx,%ebx
80104eb1:	79 20                	jns    80104ed3 <sys_pipe+0x89>
    fileclose(rf);
80104eb3:	83 ec 0c             	sub    $0xc,%esp
80104eb6:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb9:	e8 1f be ff ff       	call   80100cdd <fileclose>
    fileclose(wf);
80104ebe:	83 c4 04             	add    $0x4,%esp
80104ec1:	ff 75 ec             	pushl  -0x14(%ebp)
80104ec4:	e8 14 be ff ff       	call   80100cdd <fileclose>
    return -1;
80104ec9:	83 c4 10             	add    $0x10,%esp
80104ecc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed1:	eb d7                	jmp    80104eaa <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104ed3:	e8 73 e3 ff ff       	call   8010324b <myproc>
80104ed8:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104edf:	00 
80104ee0:	eb d1                	jmp    80104eb3 <sys_pipe+0x69>
    return -1;
80104ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee7:	eb c1                	jmp    80104eaa <sys_pipe+0x60>
    return -1;
80104ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eee:	eb ba                	jmp    80104eaa <sys_pipe+0x60>

80104ef0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104efa:	e8 57 e6 ff ff       	call   80103556 <fork>
}
80104eff:	c9                   	leave  
80104f00:	c3                   	ret    

80104f01 <sys_exit>:

int
sys_exit(void)
{
80104f01:	f3 0f 1e fb          	endbr32 
80104f05:	55                   	push   %ebp
80104f06:	89 e5                	mov    %esp,%ebp
80104f08:	83 ec 20             	sub    $0x20,%esp
  int e;

  if(argint(0, &e) < 0)
80104f0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f0e:	50                   	push   %eax
80104f0f:	6a 00                	push   $0x0
80104f11:	e8 6e f2 ff ff       	call   80104184 <argint>
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	85 c0                	test   %eax,%eax
80104f1b:	78 15                	js     80104f32 <sys_exit+0x31>
    return -1;
  exit(e);
80104f1d:	83 ec 0c             	sub    $0xc,%esp
80104f20:	ff 75 f4             	pushl  -0xc(%ebp)
80104f23:	e8 cd e8 ff ff       	call   801037f5 <exit>
  return 0;  // not reached
80104f28:	83 c4 10             	add    $0x10,%esp
80104f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f30:	c9                   	leave  
80104f31:	c3                   	ret    
    return -1;
80104f32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f37:	eb f7                	jmp    80104f30 <sys_exit+0x2f>

80104f39 <sys_wait>:

int
sys_wait(void)
{
80104f39:	f3 0f 1e fb          	endbr32 
80104f3d:	55                   	push   %ebp
80104f3e:	89 e5                	mov    %esp,%ebp
80104f40:	83 ec 1c             	sub    $0x1c,%esp
  int *w;
  int child;


  if(argptr(0, (void **)&w, sizeof(int)) < 0)
80104f43:	6a 04                	push   $0x4
80104f45:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f48:	50                   	push   %eax
80104f49:	6a 00                	push   $0x0
80104f4b:	e8 60 f2 ff ff       	call   801041b0 <argptr>
80104f50:	83 c4 10             	add    $0x10,%esp
80104f53:	85 c0                	test   %eax,%eax
80104f55:	78 10                	js     80104f67 <sys_wait+0x2e>
    return -1;
  child = wait(w);
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	ff 75 f4             	pushl  -0xc(%ebp)
80104f5d:	e8 4d ea ff ff       	call   801039af <wait>
  return child;
80104f62:	83 c4 10             	add    $0x10,%esp
}
80104f65:	c9                   	leave  
80104f66:	c3                   	ret    
    return -1;
80104f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6c:	eb f7                	jmp    80104f65 <sys_wait+0x2c>

80104f6e <sys_kill>:

int
sys_kill(void)
{
80104f6e:	f3 0f 1e fb          	endbr32 
80104f72:	55                   	push   %ebp
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104f78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7b:	50                   	push   %eax
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 01 f2 ff ff       	call   80104184 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 10                	js     80104f9a <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104f8a:	83 ec 0c             	sub    $0xc,%esp
80104f8d:	ff 75 f4             	pushl  -0xc(%ebp)
80104f90:	e8 3f eb ff ff       	call   80103ad4 <kill>
80104f95:	83 c4 10             	add    $0x10,%esp
}
80104f98:	c9                   	leave  
80104f99:	c3                   	ret    
    return -1;
80104f9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9f:	eb f7                	jmp    80104f98 <sys_kill+0x2a>

80104fa1 <sys_getpid>:

int
sys_getpid(void)
{
80104fa1:	f3 0f 1e fb          	endbr32 
80104fa5:	55                   	push   %ebp
80104fa6:	89 e5                	mov    %esp,%ebp
80104fa8:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104fab:	e8 9b e2 ff ff       	call   8010324b <myproc>
80104fb0:	8b 40 10             	mov    0x10(%eax),%eax
}
80104fb3:	c9                   	leave  
80104fb4:	c3                   	ret    

80104fb5 <sys_sbrk>:

int
sys_sbrk(void)
{
80104fb5:	f3 0f 1e fb          	endbr32 
80104fb9:	55                   	push   %ebp
80104fba:	89 e5                	mov    %esp,%ebp
80104fbc:	53                   	push   %ebx
80104fbd:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104fc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fc3:	50                   	push   %eax
80104fc4:	6a 00                	push   $0x0
80104fc6:	e8 b9 f1 ff ff       	call   80104184 <argint>
80104fcb:	83 c4 10             	add    $0x10,%esp
80104fce:	85 c0                	test   %eax,%eax
80104fd0:	78 36                	js     80105008 <sys_sbrk+0x53>
    return -1;
  addr = myproc()->sz;
80104fd2:	e8 74 e2 ff ff       	call   8010324b <myproc>
80104fd7:	8b 18                	mov    (%eax),%ebx

  if (n > 0) {
80104fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	7e 11                	jle    80104ff1 <sys_sbrk+0x3c>
    myproc()->sz +=n;
80104fe0:	e8 66 e2 ff ff       	call   8010324b <myproc>
80104fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe8:	01 10                	add    %edx,(%eax)
  else {
    if(growproc(n) < 0)
      return -1;
  }
  return addr;
}
80104fea:	89 d8                	mov    %ebx,%eax
80104fec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fef:	c9                   	leave  
80104ff0:	c3                   	ret    
    if(growproc(n) < 0)
80104ff1:	83 ec 0c             	sub    $0xc,%esp
80104ff4:	50                   	push   %eax
80104ff5:	e8 ee e4 ff ff       	call   801034e8 <growproc>
80104ffa:	83 c4 10             	add    $0x10,%esp
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	79 e9                	jns    80104fea <sys_sbrk+0x35>
      return -1;
80105001:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105006:	eb e2                	jmp    80104fea <sys_sbrk+0x35>
    return -1;
80105008:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010500d:	eb db                	jmp    80104fea <sys_sbrk+0x35>

8010500f <sys_sleep>:

int
sys_sleep(void)
{
8010500f:	f3 0f 1e fb          	endbr32 
80105013:	55                   	push   %ebp
80105014:	89 e5                	mov    %esp,%ebp
80105016:	53                   	push   %ebx
80105017:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010501a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010501d:	50                   	push   %eax
8010501e:	6a 00                	push   $0x0
80105020:	e8 5f f1 ff ff       	call   80104184 <argint>
80105025:	83 c4 10             	add    $0x10,%esp
80105028:	85 c0                	test   %eax,%eax
8010502a:	78 75                	js     801050a1 <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	68 c0 50 11 80       	push   $0x801150c0
80105034:	e8 3e ee ff ff       	call   80103e77 <acquire>
  ticks0 = ticks;
80105039:	8b 1d 00 59 11 80    	mov    0x80115900,%ebx
  while(ticks - ticks0 < n){
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	a1 00 59 11 80       	mov    0x80115900,%eax
80105047:	29 d8                	sub    %ebx,%eax
80105049:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010504c:	73 39                	jae    80105087 <sys_sleep+0x78>
    if(myproc()->killed){
8010504e:	e8 f8 e1 ff ff       	call   8010324b <myproc>
80105053:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105057:	75 17                	jne    80105070 <sys_sleep+0x61>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	68 c0 50 11 80       	push   $0x801150c0
80105061:	68 00 59 11 80       	push   $0x80115900
80105066:	e8 af e8 ff ff       	call   8010391a <sleep>
8010506b:	83 c4 10             	add    $0x10,%esp
8010506e:	eb d2                	jmp    80105042 <sys_sleep+0x33>
      release(&tickslock);
80105070:	83 ec 0c             	sub    $0xc,%esp
80105073:	68 c0 50 11 80       	push   $0x801150c0
80105078:	e8 63 ee ff ff       	call   80103ee0 <release>
      return -1;
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105085:	eb 15                	jmp    8010509c <sys_sleep+0x8d>
  }
  release(&tickslock);
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	68 c0 50 11 80       	push   $0x801150c0
8010508f:	e8 4c ee ff ff       	call   80103ee0 <release>
  return 0;
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010509c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010509f:	c9                   	leave  
801050a0:	c3                   	ret    
    return -1;
801050a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a6:	eb f4                	jmp    8010509c <sys_sleep+0x8d>

801050a8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801050a8:	f3 0f 1e fb          	endbr32 
801050ac:	55                   	push   %ebp
801050ad:	89 e5                	mov    %esp,%ebp
801050af:	53                   	push   %ebx
801050b0:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801050b3:	68 c0 50 11 80       	push   $0x801150c0
801050b8:	e8 ba ed ff ff       	call   80103e77 <acquire>
  xticks = ticks;
801050bd:	8b 1d 00 59 11 80    	mov    0x80115900,%ebx
  release(&tickslock);
801050c3:	c7 04 24 c0 50 11 80 	movl   $0x801150c0,(%esp)
801050ca:	e8 11 ee ff ff       	call   80103ee0 <release>
  return xticks;
}
801050cf:	89 d8                	mov    %ebx,%eax
801050d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d4:	c9                   	leave  
801050d5:	c3                   	ret    

801050d6 <sys_date>:

int
sys_date(void)
{
801050d6:	f3 0f 1e fb          	endbr32 
801050da:	55                   	push   %ebp
801050db:	89 e5                	mov    %esp,%ebp
801050dd:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;

  if(argptr(0, (void **)&r, sizeof(struct rtcdate)) < 0)
801050e0:	6a 18                	push   $0x18
801050e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050e5:	50                   	push   %eax
801050e6:	6a 00                	push   $0x0
801050e8:	e8 c3 f0 ff ff       	call   801041b0 <argptr>
801050ed:	83 c4 10             	add    $0x10,%esp
801050f0:	85 c0                	test   %eax,%eax
801050f2:	78 15                	js     80105109 <sys_date+0x33>
    return -1;
  cmostime(r);
801050f4:	83 ec 0c             	sub    $0xc,%esp
801050f7:	ff 75 f4             	pushl  -0xc(%ebp)
801050fa:	e8 ae d3 ff ff       	call   801024ad <cmostime>
  return 0;
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105107:	c9                   	leave  
80105108:	c3                   	ret    
    return -1;
80105109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510e:	eb f7                	jmp    80105107 <sys_date+0x31>

80105110 <sys_getprio>:

int 
sys_getprio(void)
{
80105110:	f3 0f 1e fb          	endbr32 
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	83 ec 20             	sub    $0x20,%esp
  int n;

  if(argint(0, &n) < 0)
8010511a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010511d:	50                   	push   %eax
8010511e:	6a 00                	push   $0x0
80105120:	e8 5f f0 ff ff       	call   80104184 <argint>
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	85 c0                	test   %eax,%eax
8010512a:	78 10                	js     8010513c <sys_getprio+0x2c>
    return -1;

  return getprio(n);
8010512c:	83 ec 0c             	sub    $0xc,%esp
8010512f:	ff 75 f4             	pushl  -0xc(%ebp)
80105132:	e8 2f e2 ff ff       	call   80103366 <getprio>
80105137:	83 c4 10             	add    $0x10,%esp
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    
    return -1;
8010513c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105141:	eb f7                	jmp    8010513a <sys_getprio+0x2a>

80105143 <sys_setprio>:

int 
sys_setprio(void)
{
80105143:	f3 0f 1e fb          	endbr32 
80105147:	55                   	push   %ebp
80105148:	89 e5                	mov    %esp,%ebp
8010514a:	83 ec 20             	sub    $0x20,%esp
  int n, m;
  if(argint(0, &n) < 0)
8010514d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105150:	50                   	push   %eax
80105151:	6a 00                	push   $0x0
80105153:	e8 2c f0 ff ff       	call   80104184 <argint>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	78 28                	js     80105187 <sys_setprio+0x44>
    return -1;

  if(argint(1, &m) < 0)
8010515f:	83 ec 08             	sub    $0x8,%esp
80105162:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105165:	50                   	push   %eax
80105166:	6a 01                	push   $0x1
80105168:	e8 17 f0 ff ff       	call   80104184 <argint>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	78 1a                	js     8010518e <sys_setprio+0x4b>
    return -1;

  return setprio(n, m);
80105174:	83 ec 08             	sub    $0x8,%esp
80105177:	ff 75 f0             	pushl  -0x10(%ebp)
8010517a:	ff 75 f4             	pushl  -0xc(%ebp)
8010517d:	e8 15 e2 ff ff       	call   80103397 <setprio>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	c9                   	leave  
80105186:	c3                   	ret    
    return -1;
80105187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518c:	eb f7                	jmp    80105185 <sys_setprio+0x42>
    return -1;
8010518e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105193:	eb f0                	jmp    80105185 <sys_setprio+0x42>

80105195 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105195:	1e                   	push   %ds
  pushl %es
80105196:	06                   	push   %es
  pushl %fs
80105197:	0f a0                	push   %fs
  pushl %gs
80105199:	0f a8                	push   %gs
  pushal
8010519b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010519c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801051a0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801051a2:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801051a4:	54                   	push   %esp
  call trap
801051a5:	e8 e6 00 00 00       	call   80105290 <trap>
  addl $4, %esp
801051aa:	83 c4 04             	add    $0x4,%esp

801051ad <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801051ad:	61                   	popa   
  popl %gs
801051ae:	0f a9                	pop    %gs
  popl %fs
801051b0:	0f a1                	pop    %fs
  popl %es
801051b2:	07                   	pop    %es
  popl %ds
801051b3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801051b4:	83 c4 08             	add    $0x8,%esp
  iret
801051b7:	cf                   	iret   

801051b8 <tvinit>:
int 
mappages(pde_t *pdgir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
801051b8:	f3 0f 1e fb          	endbr32 
801051bc:	55                   	push   %ebp
801051bd:	89 e5                	mov    %esp,%ebp
801051bf:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
801051c2:	b8 00 00 00 00       	mov    $0x0,%eax
801051c7:	3d ff 00 00 00       	cmp    $0xff,%eax
801051cc:	7f 49                	jg     80105217 <tvinit+0x5f>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801051ce:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
801051d5:	66 89 0c c5 00 51 11 	mov    %cx,-0x7feeaf00(,%eax,8)
801051dc:	80 
801051dd:	66 c7 04 c5 02 51 11 	movw   $0x8,-0x7feeaefe(,%eax,8)
801051e4:	80 08 00 
801051e7:	c6 04 c5 04 51 11 80 	movb   $0x0,-0x7feeaefc(,%eax,8)
801051ee:	00 
801051ef:	8a 14 c5 05 51 11 80 	mov    -0x7feeaefb(,%eax,8),%dl
801051f6:	83 e2 f0             	and    $0xfffffff0,%edx
801051f9:	83 ca 0e             	or     $0xe,%edx
801051fc:	83 e2 8f             	and    $0xffffff8f,%edx
801051ff:	83 ca 80             	or     $0xffffff80,%edx
80105202:	88 14 c5 05 51 11 80 	mov    %dl,-0x7feeaefb(,%eax,8)
80105209:	c1 e9 10             	shr    $0x10,%ecx
8010520c:	66 89 0c c5 06 51 11 	mov    %cx,-0x7feeaefa(,%eax,8)
80105213:	80 
  for(i = 0; i < 256; i++)
80105214:	40                   	inc    %eax
80105215:	eb b0                	jmp    801051c7 <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105217:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
8010521d:	66 89 15 00 53 11 80 	mov    %dx,0x80115300
80105224:	66 c7 05 02 53 11 80 	movw   $0x8,0x80115302
8010522b:	08 00 
8010522d:	c6 05 04 53 11 80 00 	movb   $0x0,0x80115304
80105234:	a0 05 53 11 80       	mov    0x80115305,%al
80105239:	83 c8 0f             	or     $0xf,%eax
8010523c:	83 e0 ef             	and    $0xffffffef,%eax
8010523f:	83 c8 e0             	or     $0xffffffe0,%eax
80105242:	a2 05 53 11 80       	mov    %al,0x80115305
80105247:	c1 ea 10             	shr    $0x10,%edx
8010524a:	66 89 15 06 53 11 80 	mov    %dx,0x80115306

  initlock(&tickslock, "time");
80105251:	83 ec 08             	sub    $0x8,%esp
80105254:	68 49 72 10 80       	push   $0x80107249
80105259:	68 c0 50 11 80       	push   $0x801150c0
8010525e:	e8 c9 ea ff ff       	call   80103d2c <initlock>
}
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	c9                   	leave  
80105267:	c3                   	ret    

80105268 <idtinit>:

void
idtinit(void)
{
80105268:	f3 0f 1e fb          	endbr32 
8010526c:	55                   	push   %ebp
8010526d:	89 e5                	mov    %esp,%ebp
8010526f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105272:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105278:	b8 00 51 11 80       	mov    $0x80115100,%eax
8010527d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105281:	c1 e8 10             	shr    $0x10,%eax
80105284:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105288:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010528b:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
8010528e:	c9                   	leave  
8010528f:	c3                   	ret    

80105290 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105290:	f3 0f 1e fb          	endbr32 
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	57                   	push   %edi
80105298:	56                   	push   %esi
80105299:	53                   	push   %ebx
8010529a:	83 ec 1c             	sub    $0x1c,%esp
8010529d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801052a0:	8b 43 30             	mov    0x30(%ebx),%eax
801052a3:	83 f8 40             	cmp    $0x40,%eax
801052a6:	74 14                	je     801052bc <trap+0x2c>
    if(myproc()->killed)
      exit(tf->trapno + 1);
    return;
  }

  switch(tf->trapno){
801052a8:	83 e8 0e             	sub    $0xe,%eax
801052ab:	83 f8 31             	cmp    $0x31,%eax
801052ae:	0f 87 90 02 00 00    	ja     80105544 <trap+0x2b4>
801052b4:	3e ff 24 85 6c 73 10 	notrack jmp *-0x7fef8c94(,%eax,4)
801052bb:	80 
    if(myproc()->killed)
801052bc:	e8 8a df ff ff       	call   8010324b <myproc>
801052c1:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052c5:	75 31                	jne    801052f8 <trap+0x68>
    myproc()->tf = tf;
801052c7:	e8 7f df ff ff       	call   8010324b <myproc>
801052cc:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801052cf:	e8 7f ef ff ff       	call   80104253 <syscall>
    if(myproc()->killed)
801052d4:	e8 72 df ff ff       	call   8010324b <myproc>
801052d9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801052dd:	0f 84 95 00 00 00    	je     80105378 <trap+0xe8>
      exit(tf->trapno + 1);
801052e3:	8b 43 30             	mov    0x30(%ebx),%eax
801052e6:	40                   	inc    %eax
801052e7:	83 ec 0c             	sub    $0xc,%esp
801052ea:	50                   	push   %eax
801052eb:	e8 05 e5 ff ff       	call   801037f5 <exit>
801052f0:	83 c4 10             	add    $0x10,%esp
    return;
801052f3:	e9 80 00 00 00       	jmp    80105378 <trap+0xe8>
      exit(tf->trapno + 1);
801052f8:	8b 43 30             	mov    0x30(%ebx),%eax
801052fb:	40                   	inc    %eax
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	50                   	push   %eax
80105300:	e8 f0 e4 ff ff       	call   801037f5 <exit>
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	eb bd                	jmp    801052c7 <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010530a:	e8 07 df ff ff       	call   80103216 <cpuid>
8010530f:	85 c0                	test   %eax,%eax
80105311:	74 6d                	je     80105380 <trap+0xf0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105313:	e8 d4 d0 ff ff       	call   801023ec <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105318:	e8 2e df ff ff       	call   8010324b <myproc>
8010531d:	85 c0                	test   %eax,%eax
8010531f:	74 1b                	je     8010533c <trap+0xac>
80105321:	e8 25 df ff ff       	call   8010324b <myproc>
80105326:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010532a:	74 10                	je     8010533c <trap+0xac>
8010532c:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010532f:	83 e0 03             	and    $0x3,%eax
80105332:	66 83 f8 03          	cmp    $0x3,%ax
80105336:	0f 84 9b 02 00 00    	je     801055d7 <trap+0x347>
    exit(tf->trapno + 1);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010533c:	e8 0a df ff ff       	call   8010324b <myproc>
80105341:	85 c0                	test   %eax,%eax
80105343:	74 0f                	je     80105354 <trap+0xc4>
80105345:	e8 01 df ff ff       	call   8010324b <myproc>
8010534a:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010534e:	0f 84 98 02 00 00    	je     801055ec <trap+0x35c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105354:	e8 f2 de ff ff       	call   8010324b <myproc>
80105359:	85 c0                	test   %eax,%eax
8010535b:	74 1b                	je     80105378 <trap+0xe8>
8010535d:	e8 e9 de ff ff       	call   8010324b <myproc>
80105362:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105366:	74 10                	je     80105378 <trap+0xe8>
80105368:	8b 43 3c             	mov    0x3c(%ebx),%eax
8010536b:	83 e0 03             	and    $0x3,%eax
8010536e:	66 83 f8 03          	cmp    $0x3,%ax
80105372:	0f 84 88 02 00 00    	je     80105600 <trap+0x370>
    exit(tf->trapno + 1);
}
80105378:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537b:	5b                   	pop    %ebx
8010537c:	5e                   	pop    %esi
8010537d:	5f                   	pop    %edi
8010537e:	5d                   	pop    %ebp
8010537f:	c3                   	ret    
      acquire(&tickslock);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	68 c0 50 11 80       	push   $0x801150c0
80105388:	e8 ea ea ff ff       	call   80103e77 <acquire>
      ticks++;
8010538d:	ff 05 00 59 11 80    	incl   0x80115900
      wakeup(&ticks);
80105393:	c7 04 24 00 59 11 80 	movl   $0x80115900,(%esp)
8010539a:	e8 08 e7 ff ff       	call   80103aa7 <wakeup>
      release(&tickslock);
8010539f:	c7 04 24 c0 50 11 80 	movl   $0x801150c0,(%esp)
801053a6:	e8 35 eb ff ff       	call   80103ee0 <release>
801053ab:	83 c4 10             	add    $0x10,%esp
801053ae:	e9 60 ff ff ff       	jmp    80105313 <trap+0x83>
    ideintr();
801053b3:	e8 f0 c9 ff ff       	call   80101da8 <ideintr>
    lapiceoi();
801053b8:	e8 2f d0 ff ff       	call   801023ec <lapiceoi>
    break;
801053bd:	e9 56 ff ff ff       	jmp    80105318 <trap+0x88>
    kbdintr();
801053c2:	e8 62 ce ff ff       	call   80102229 <kbdintr>
    lapiceoi();
801053c7:	e8 20 d0 ff ff       	call   801023ec <lapiceoi>
    break;
801053cc:	e9 47 ff ff ff       	jmp    80105318 <trap+0x88>
    uartintr();
801053d1:	e8 47 03 00 00       	call   8010571d <uartintr>
    lapiceoi();
801053d6:	e8 11 d0 ff ff       	call   801023ec <lapiceoi>
    break;
801053db:	e9 38 ff ff ff       	jmp    80105318 <trap+0x88>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801053e0:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801053e3:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801053e6:	e8 2b de ff ff       	call   80103216 <cpuid>
801053eb:	57                   	push   %edi
801053ec:	0f b7 f6             	movzwl %si,%esi
801053ef:	56                   	push   %esi
801053f0:	50                   	push   %eax
801053f1:	68 84 72 10 80       	push   $0x80107284
801053f6:	e8 02 b2 ff ff       	call   801005fd <cprintf>
    lapiceoi();
801053fb:	e8 ec cf ff ff       	call   801023ec <lapiceoi>
    break;
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	e9 10 ff ff ff       	jmp    80105318 <trap+0x88>
    if(myproc() == 0){
80105408:	e8 3e de ff ff       	call   8010324b <myproc>
8010540d:	85 c0                	test   %eax,%eax
8010540f:	74 41                	je     80105452 <trap+0x1c2>
    if ((tf->err & 1) == 0x01) {
80105411:	f6 43 34 01          	testb  $0x1,0x34(%ebx)
80105415:	74 66                	je     8010547d <trap+0x1ed>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105417:	0f 20 d6             	mov    %cr2,%esi
      uint direccion = PGROUNDDOWN(rcr2());
8010541a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      if (myproc()->pagina_guarda <= direccion) { 
80105420:	e8 26 de ff ff       	call   8010324b <myproc>
80105425:	39 b0 88 00 00 00    	cmp    %esi,0x88(%eax)
8010542b:	0f 87 e7 fe ff ff    	ja     80105318 <trap+0x88>
        cprintf("page fault, page-protection violation\n");
80105431:	83 ec 0c             	sub    $0xc,%esp
80105434:	68 dc 72 10 80       	push   $0x801072dc
80105439:	e8 bf b1 ff ff       	call   801005fd <cprintf>
        myproc()->killed = 1;
8010543e:	e8 08 de ff ff       	call   8010324b <myproc>
80105443:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	e9 c6 fe ff ff       	jmp    80105318 <trap+0x88>
80105452:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105455:	8b 73 38             	mov    0x38(%ebx),%esi
80105458:	e8 b9 dd ff ff       	call   80103216 <cpuid>
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	57                   	push   %edi
80105461:	56                   	push   %esi
80105462:	50                   	push   %eax
80105463:	ff 73 30             	pushl  0x30(%ebx)
80105466:	68 a8 72 10 80       	push   $0x801072a8
8010546b:	e8 8d b1 ff ff       	call   801005fd <cprintf>
      panic("trap");
80105470:	83 c4 14             	add    $0x14,%esp
80105473:	68 4e 72 10 80       	push   $0x8010724e
80105478:	e8 d8 ae ff ff       	call   80100355 <panic>
8010547d:	0f 20 d6             	mov    %cr2,%esi
      if (rcr2() >= myproc()->sz){
80105480:	e8 c6 dd ff ff       	call   8010324b <myproc>
80105485:	39 30                	cmp    %esi,(%eax)
80105487:	77 21                	ja     801054aa <trap+0x21a>
        cprintf("intento de acceso mas alla de sz\n");
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	68 04 73 10 80       	push   $0x80107304
80105491:	e8 67 b1 ff ff       	call   801005fd <cprintf>
        myproc()->killed = 1;
80105496:	e8 b0 dd ff ff       	call   8010324b <myproc>
8010549b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
	      break;
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	e9 6e fe ff ff       	jmp    80105318 <trap+0x88>
      mem = kalloc();
801054aa:	e8 5d cc ff ff       	call   8010210c <kalloc>
801054af:	89 c6                	mov    %eax,%esi
      if (mem == 0) {
801054b1:	85 c0                	test   %eax,%eax
801054b3:	74 6e                	je     80105523 <trap+0x293>
      memset(mem, 0, PGSIZE);
801054b5:	83 ec 04             	sub    $0x4,%esp
801054b8:	68 00 10 00 00       	push   $0x1000
801054bd:	6a 00                	push   $0x0
801054bf:	50                   	push   %eax
801054c0:	e8 66 ea ff ff       	call   80103f2b <memset>
801054c5:	0f 20 d7             	mov    %cr2,%edi
      if (mappages(myproc()->pgdir, (char*)PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801054c8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801054ce:	e8 78 dd ff ff       	call   8010324b <myproc>
801054d3:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801054da:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801054e0:	52                   	push   %edx
801054e1:	68 00 10 00 00       	push   $0x1000
801054e6:	57                   	push   %edi
801054e7:	ff 70 04             	pushl  0x4(%eax)
801054ea:	e8 a3 0e 00 00       	call   80106392 <mappages>
801054ef:	83 c4 20             	add    $0x20,%esp
801054f2:	85 c0                	test   %eax,%eax
801054f4:	0f 89 1e fe ff ff    	jns    80105318 <trap+0x88>
        cprintf("page mapping failed\n");
801054fa:	83 ec 0c             	sub    $0xc,%esp
801054fd:	68 6d 72 10 80       	push   $0x8010726d
80105502:	e8 f6 b0 ff ff       	call   801005fd <cprintf>
        kfree(mem);
80105507:	89 34 24             	mov    %esi,(%esp)
8010550a:	e8 d6 ca ff ff       	call   80101fe5 <kfree>
        myproc()->killed = 1;
8010550f:	e8 37 dd ff ff       	call   8010324b <myproc>
80105514:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
8010551b:	83 c4 10             	add    $0x10,%esp
8010551e:	e9 f5 fd ff ff       	jmp    80105318 <trap+0x88>
        cprintf("page fault out of memory\n");
80105523:	83 ec 0c             	sub    $0xc,%esp
80105526:	68 53 72 10 80       	push   $0x80107253
8010552b:	e8 cd b0 ff ff       	call   801005fd <cprintf>
        myproc()->killed = 1;
80105530:	e8 16 dd ff ff       	call   8010324b <myproc>
80105535:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        break;
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	e9 d4 fd ff ff       	jmp    80105318 <trap+0x88>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105544:	e8 02 dd ff ff       	call   8010324b <myproc>
80105549:	85 c0                	test   %eax,%eax
8010554b:	74 5f                	je     801055ac <trap+0x31c>
8010554d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105551:	74 59                	je     801055ac <trap+0x31c>
80105553:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105556:	8b 43 38             	mov    0x38(%ebx),%eax
80105559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010555c:	e8 b5 dc ff ff       	call   80103216 <cpuid>
80105561:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105564:	8b 4b 34             	mov    0x34(%ebx),%ecx
80105567:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010556a:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
8010556d:	e8 d9 dc ff ff       	call   8010324b <myproc>
80105572:	8d 50 6c             	lea    0x6c(%eax),%edx
80105575:	89 55 d8             	mov    %edx,-0x28(%ebp)
80105578:	e8 ce dc ff ff       	call   8010324b <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010557d:	57                   	push   %edi
8010557e:	ff 75 e4             	pushl  -0x1c(%ebp)
80105581:	ff 75 e0             	pushl  -0x20(%ebp)
80105584:	ff 75 dc             	pushl  -0x24(%ebp)
80105587:	56                   	push   %esi
80105588:	ff 75 d8             	pushl  -0x28(%ebp)
8010558b:	ff 70 10             	pushl  0x10(%eax)
8010558e:	68 28 73 10 80       	push   $0x80107328
80105593:	e8 65 b0 ff ff       	call   801005fd <cprintf>
    myproc()->killed = 1;
80105598:	83 c4 20             	add    $0x20,%esp
8010559b:	e8 ab dc ff ff       	call   8010324b <myproc>
801055a0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055a7:	e9 6c fd ff ff       	jmp    80105318 <trap+0x88>
801055ac:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801055af:	8b 73 38             	mov    0x38(%ebx),%esi
801055b2:	e8 5f dc ff ff       	call   80103216 <cpuid>
801055b7:	83 ec 0c             	sub    $0xc,%esp
801055ba:	57                   	push   %edi
801055bb:	56                   	push   %esi
801055bc:	50                   	push   %eax
801055bd:	ff 73 30             	pushl  0x30(%ebx)
801055c0:	68 a8 72 10 80       	push   $0x801072a8
801055c5:	e8 33 b0 ff ff       	call   801005fd <cprintf>
      panic("trap");
801055ca:	83 c4 14             	add    $0x14,%esp
801055cd:	68 4e 72 10 80       	push   $0x8010724e
801055d2:	e8 7e ad ff ff       	call   80100355 <panic>
    exit(tf->trapno + 1);
801055d7:	8b 43 30             	mov    0x30(%ebx),%eax
801055da:	40                   	inc    %eax
801055db:	83 ec 0c             	sub    $0xc,%esp
801055de:	50                   	push   %eax
801055df:	e8 11 e2 ff ff       	call   801037f5 <exit>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	e9 50 fd ff ff       	jmp    8010533c <trap+0xac>
  if(myproc() && myproc()->state == RUNNING &&
801055ec:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801055f0:	0f 85 5e fd ff ff    	jne    80105354 <trap+0xc4>
    yield();
801055f6:	e8 dc e2 ff ff       	call   801038d7 <yield>
801055fb:	e9 54 fd ff ff       	jmp    80105354 <trap+0xc4>
    exit(tf->trapno + 1);
80105600:	8b 43 30             	mov    0x30(%ebx),%eax
80105603:	40                   	inc    %eax
80105604:	83 ec 0c             	sub    $0xc,%esp
80105607:	50                   	push   %eax
80105608:	e8 e8 e1 ff ff       	call   801037f5 <exit>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	e9 63 fd ff ff       	jmp    80105378 <trap+0xe8>

80105615 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105615:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105619:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105620:	74 14                	je     80105636 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105622:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105627:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105628:	a8 01                	test   $0x1,%al
8010562a:	74 10                	je     8010563c <uartgetc+0x27>
8010562c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105631:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105632:	0f b6 c0             	movzbl %al,%eax
80105635:	c3                   	ret    
    return -1;
80105636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563b:	c3                   	ret    
    return -1;
8010563c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105641:	c3                   	ret    

80105642 <uartputc>:
{
80105642:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105646:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
8010564d:	74 39                	je     80105688 <uartputc+0x46>
{
8010564f:	55                   	push   %ebp
80105650:	89 e5                	mov    %esp,%ebp
80105652:	53                   	push   %ebx
80105653:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105656:	bb 00 00 00 00       	mov    $0x0,%ebx
8010565b:	83 fb 7f             	cmp    $0x7f,%ebx
8010565e:	7f 1a                	jg     8010567a <uartputc+0x38>
80105660:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105665:	ec                   	in     (%dx),%al
80105666:	a8 20                	test   $0x20,%al
80105668:	75 10                	jne    8010567a <uartputc+0x38>
    microdelay(10);
8010566a:	83 ec 0c             	sub    $0xc,%esp
8010566d:	6a 0a                	push   $0xa
8010566f:	e8 9d cd ff ff       	call   80102411 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105674:	43                   	inc    %ebx
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	eb e1                	jmp    8010565b <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010567a:	8b 45 08             	mov    0x8(%ebp),%eax
8010567d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105682:	ee                   	out    %al,(%dx)
}
80105683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105686:	c9                   	leave  
80105687:	c3                   	ret    
80105688:	c3                   	ret    

80105689 <uartinit>:
{
80105689:	f3 0f 1e fb          	endbr32 
8010568d:	55                   	push   %ebp
8010568e:	89 e5                	mov    %esp,%ebp
80105690:	56                   	push   %esi
80105691:	53                   	push   %ebx
80105692:	b1 00                	mov    $0x0,%cl
80105694:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105699:	88 c8                	mov    %cl,%al
8010569b:	ee                   	out    %al,(%dx)
8010569c:	be fb 03 00 00       	mov    $0x3fb,%esi
801056a1:	b0 80                	mov    $0x80,%al
801056a3:	89 f2                	mov    %esi,%edx
801056a5:	ee                   	out    %al,(%dx)
801056a6:	b0 0c                	mov    $0xc,%al
801056a8:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056ad:	ee                   	out    %al,(%dx)
801056ae:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801056b3:	88 c8                	mov    %cl,%al
801056b5:	89 da                	mov    %ebx,%edx
801056b7:	ee                   	out    %al,(%dx)
801056b8:	b0 03                	mov    $0x3,%al
801056ba:	89 f2                	mov    %esi,%edx
801056bc:	ee                   	out    %al,(%dx)
801056bd:	ba fc 03 00 00       	mov    $0x3fc,%edx
801056c2:	88 c8                	mov    %cl,%al
801056c4:	ee                   	out    %al,(%dx)
801056c5:	b0 01                	mov    $0x1,%al
801056c7:	89 da                	mov    %ebx,%edx
801056c9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056ca:	ba fd 03 00 00       	mov    $0x3fd,%edx
801056cf:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801056d0:	3c ff                	cmp    $0xff,%al
801056d2:	74 42                	je     80105716 <uartinit+0x8d>
  uart = 1;
801056d4:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801056db:	00 00 00 
801056de:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056e3:	ec                   	in     (%dx),%al
801056e4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056e9:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801056ea:	83 ec 08             	sub    $0x8,%esp
801056ed:	6a 00                	push   $0x0
801056ef:	6a 04                	push   $0x4
801056f1:	e8 bf c8 ff ff       	call   80101fb5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	bb 34 74 10 80       	mov    $0x80107434,%ebx
801056fe:	eb 10                	jmp    80105710 <uartinit+0x87>
    uartputc(*p);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	0f be c0             	movsbl %al,%eax
80105706:	50                   	push   %eax
80105707:	e8 36 ff ff ff       	call   80105642 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010570c:	43                   	inc    %ebx
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	8a 03                	mov    (%ebx),%al
80105712:	84 c0                	test   %al,%al
80105714:	75 ea                	jne    80105700 <uartinit+0x77>
}
80105716:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105719:	5b                   	pop    %ebx
8010571a:	5e                   	pop    %esi
8010571b:	5d                   	pop    %ebp
8010571c:	c3                   	ret    

8010571d <uartintr>:

void
uartintr(void)
{
8010571d:	f3 0f 1e fb          	endbr32 
80105721:	55                   	push   %ebp
80105722:	89 e5                	mov    %esp,%ebp
80105724:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105727:	68 15 56 10 80       	push   $0x80105615
8010572c:	e8 f5 af ff ff       	call   80100726 <consoleintr>
}
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	c9                   	leave  
80105735:	c3                   	ret    

80105736 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105736:	6a 00                	push   $0x0
  pushl $0
80105738:	6a 00                	push   $0x0
  jmp alltraps
8010573a:	e9 56 fa ff ff       	jmp    80105195 <alltraps>

8010573f <vector1>:
.globl vector1
vector1:
  pushl $0
8010573f:	6a 00                	push   $0x0
  pushl $1
80105741:	6a 01                	push   $0x1
  jmp alltraps
80105743:	e9 4d fa ff ff       	jmp    80105195 <alltraps>

80105748 <vector2>:
.globl vector2
vector2:
  pushl $0
80105748:	6a 00                	push   $0x0
  pushl $2
8010574a:	6a 02                	push   $0x2
  jmp alltraps
8010574c:	e9 44 fa ff ff       	jmp    80105195 <alltraps>

80105751 <vector3>:
.globl vector3
vector3:
  pushl $0
80105751:	6a 00                	push   $0x0
  pushl $3
80105753:	6a 03                	push   $0x3
  jmp alltraps
80105755:	e9 3b fa ff ff       	jmp    80105195 <alltraps>

8010575a <vector4>:
.globl vector4
vector4:
  pushl $0
8010575a:	6a 00                	push   $0x0
  pushl $4
8010575c:	6a 04                	push   $0x4
  jmp alltraps
8010575e:	e9 32 fa ff ff       	jmp    80105195 <alltraps>

80105763 <vector5>:
.globl vector5
vector5:
  pushl $0
80105763:	6a 00                	push   $0x0
  pushl $5
80105765:	6a 05                	push   $0x5
  jmp alltraps
80105767:	e9 29 fa ff ff       	jmp    80105195 <alltraps>

8010576c <vector6>:
.globl vector6
vector6:
  pushl $0
8010576c:	6a 00                	push   $0x0
  pushl $6
8010576e:	6a 06                	push   $0x6
  jmp alltraps
80105770:	e9 20 fa ff ff       	jmp    80105195 <alltraps>

80105775 <vector7>:
.globl vector7
vector7:
  pushl $0
80105775:	6a 00                	push   $0x0
  pushl $7
80105777:	6a 07                	push   $0x7
  jmp alltraps
80105779:	e9 17 fa ff ff       	jmp    80105195 <alltraps>

8010577e <vector8>:
.globl vector8
vector8:
  pushl $8
8010577e:	6a 08                	push   $0x8
  jmp alltraps
80105780:	e9 10 fa ff ff       	jmp    80105195 <alltraps>

80105785 <vector9>:
.globl vector9
vector9:
  pushl $0
80105785:	6a 00                	push   $0x0
  pushl $9
80105787:	6a 09                	push   $0x9
  jmp alltraps
80105789:	e9 07 fa ff ff       	jmp    80105195 <alltraps>

8010578e <vector10>:
.globl vector10
vector10:
  pushl $10
8010578e:	6a 0a                	push   $0xa
  jmp alltraps
80105790:	e9 00 fa ff ff       	jmp    80105195 <alltraps>

80105795 <vector11>:
.globl vector11
vector11:
  pushl $11
80105795:	6a 0b                	push   $0xb
  jmp alltraps
80105797:	e9 f9 f9 ff ff       	jmp    80105195 <alltraps>

8010579c <vector12>:
.globl vector12
vector12:
  pushl $12
8010579c:	6a 0c                	push   $0xc
  jmp alltraps
8010579e:	e9 f2 f9 ff ff       	jmp    80105195 <alltraps>

801057a3 <vector13>:
.globl vector13
vector13:
  pushl $13
801057a3:	6a 0d                	push   $0xd
  jmp alltraps
801057a5:	e9 eb f9 ff ff       	jmp    80105195 <alltraps>

801057aa <vector14>:
.globl vector14
vector14:
  pushl $14
801057aa:	6a 0e                	push   $0xe
  jmp alltraps
801057ac:	e9 e4 f9 ff ff       	jmp    80105195 <alltraps>

801057b1 <vector15>:
.globl vector15
vector15:
  pushl $0
801057b1:	6a 00                	push   $0x0
  pushl $15
801057b3:	6a 0f                	push   $0xf
  jmp alltraps
801057b5:	e9 db f9 ff ff       	jmp    80105195 <alltraps>

801057ba <vector16>:
.globl vector16
vector16:
  pushl $0
801057ba:	6a 00                	push   $0x0
  pushl $16
801057bc:	6a 10                	push   $0x10
  jmp alltraps
801057be:	e9 d2 f9 ff ff       	jmp    80105195 <alltraps>

801057c3 <vector17>:
.globl vector17
vector17:
  pushl $17
801057c3:	6a 11                	push   $0x11
  jmp alltraps
801057c5:	e9 cb f9 ff ff       	jmp    80105195 <alltraps>

801057ca <vector18>:
.globl vector18
vector18:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $18
801057cc:	6a 12                	push   $0x12
  jmp alltraps
801057ce:	e9 c2 f9 ff ff       	jmp    80105195 <alltraps>

801057d3 <vector19>:
.globl vector19
vector19:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $19
801057d5:	6a 13                	push   $0x13
  jmp alltraps
801057d7:	e9 b9 f9 ff ff       	jmp    80105195 <alltraps>

801057dc <vector20>:
.globl vector20
vector20:
  pushl $0
801057dc:	6a 00                	push   $0x0
  pushl $20
801057de:	6a 14                	push   $0x14
  jmp alltraps
801057e0:	e9 b0 f9 ff ff       	jmp    80105195 <alltraps>

801057e5 <vector21>:
.globl vector21
vector21:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $21
801057e7:	6a 15                	push   $0x15
  jmp alltraps
801057e9:	e9 a7 f9 ff ff       	jmp    80105195 <alltraps>

801057ee <vector22>:
.globl vector22
vector22:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $22
801057f0:	6a 16                	push   $0x16
  jmp alltraps
801057f2:	e9 9e f9 ff ff       	jmp    80105195 <alltraps>

801057f7 <vector23>:
.globl vector23
vector23:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $23
801057f9:	6a 17                	push   $0x17
  jmp alltraps
801057fb:	e9 95 f9 ff ff       	jmp    80105195 <alltraps>

80105800 <vector24>:
.globl vector24
vector24:
  pushl $0
80105800:	6a 00                	push   $0x0
  pushl $24
80105802:	6a 18                	push   $0x18
  jmp alltraps
80105804:	e9 8c f9 ff ff       	jmp    80105195 <alltraps>

80105809 <vector25>:
.globl vector25
vector25:
  pushl $0
80105809:	6a 00                	push   $0x0
  pushl $25
8010580b:	6a 19                	push   $0x19
  jmp alltraps
8010580d:	e9 83 f9 ff ff       	jmp    80105195 <alltraps>

80105812 <vector26>:
.globl vector26
vector26:
  pushl $0
80105812:	6a 00                	push   $0x0
  pushl $26
80105814:	6a 1a                	push   $0x1a
  jmp alltraps
80105816:	e9 7a f9 ff ff       	jmp    80105195 <alltraps>

8010581b <vector27>:
.globl vector27
vector27:
  pushl $0
8010581b:	6a 00                	push   $0x0
  pushl $27
8010581d:	6a 1b                	push   $0x1b
  jmp alltraps
8010581f:	e9 71 f9 ff ff       	jmp    80105195 <alltraps>

80105824 <vector28>:
.globl vector28
vector28:
  pushl $0
80105824:	6a 00                	push   $0x0
  pushl $28
80105826:	6a 1c                	push   $0x1c
  jmp alltraps
80105828:	e9 68 f9 ff ff       	jmp    80105195 <alltraps>

8010582d <vector29>:
.globl vector29
vector29:
  pushl $0
8010582d:	6a 00                	push   $0x0
  pushl $29
8010582f:	6a 1d                	push   $0x1d
  jmp alltraps
80105831:	e9 5f f9 ff ff       	jmp    80105195 <alltraps>

80105836 <vector30>:
.globl vector30
vector30:
  pushl $0
80105836:	6a 00                	push   $0x0
  pushl $30
80105838:	6a 1e                	push   $0x1e
  jmp alltraps
8010583a:	e9 56 f9 ff ff       	jmp    80105195 <alltraps>

8010583f <vector31>:
.globl vector31
vector31:
  pushl $0
8010583f:	6a 00                	push   $0x0
  pushl $31
80105841:	6a 1f                	push   $0x1f
  jmp alltraps
80105843:	e9 4d f9 ff ff       	jmp    80105195 <alltraps>

80105848 <vector32>:
.globl vector32
vector32:
  pushl $0
80105848:	6a 00                	push   $0x0
  pushl $32
8010584a:	6a 20                	push   $0x20
  jmp alltraps
8010584c:	e9 44 f9 ff ff       	jmp    80105195 <alltraps>

80105851 <vector33>:
.globl vector33
vector33:
  pushl $0
80105851:	6a 00                	push   $0x0
  pushl $33
80105853:	6a 21                	push   $0x21
  jmp alltraps
80105855:	e9 3b f9 ff ff       	jmp    80105195 <alltraps>

8010585a <vector34>:
.globl vector34
vector34:
  pushl $0
8010585a:	6a 00                	push   $0x0
  pushl $34
8010585c:	6a 22                	push   $0x22
  jmp alltraps
8010585e:	e9 32 f9 ff ff       	jmp    80105195 <alltraps>

80105863 <vector35>:
.globl vector35
vector35:
  pushl $0
80105863:	6a 00                	push   $0x0
  pushl $35
80105865:	6a 23                	push   $0x23
  jmp alltraps
80105867:	e9 29 f9 ff ff       	jmp    80105195 <alltraps>

8010586c <vector36>:
.globl vector36
vector36:
  pushl $0
8010586c:	6a 00                	push   $0x0
  pushl $36
8010586e:	6a 24                	push   $0x24
  jmp alltraps
80105870:	e9 20 f9 ff ff       	jmp    80105195 <alltraps>

80105875 <vector37>:
.globl vector37
vector37:
  pushl $0
80105875:	6a 00                	push   $0x0
  pushl $37
80105877:	6a 25                	push   $0x25
  jmp alltraps
80105879:	e9 17 f9 ff ff       	jmp    80105195 <alltraps>

8010587e <vector38>:
.globl vector38
vector38:
  pushl $0
8010587e:	6a 00                	push   $0x0
  pushl $38
80105880:	6a 26                	push   $0x26
  jmp alltraps
80105882:	e9 0e f9 ff ff       	jmp    80105195 <alltraps>

80105887 <vector39>:
.globl vector39
vector39:
  pushl $0
80105887:	6a 00                	push   $0x0
  pushl $39
80105889:	6a 27                	push   $0x27
  jmp alltraps
8010588b:	e9 05 f9 ff ff       	jmp    80105195 <alltraps>

80105890 <vector40>:
.globl vector40
vector40:
  pushl $0
80105890:	6a 00                	push   $0x0
  pushl $40
80105892:	6a 28                	push   $0x28
  jmp alltraps
80105894:	e9 fc f8 ff ff       	jmp    80105195 <alltraps>

80105899 <vector41>:
.globl vector41
vector41:
  pushl $0
80105899:	6a 00                	push   $0x0
  pushl $41
8010589b:	6a 29                	push   $0x29
  jmp alltraps
8010589d:	e9 f3 f8 ff ff       	jmp    80105195 <alltraps>

801058a2 <vector42>:
.globl vector42
vector42:
  pushl $0
801058a2:	6a 00                	push   $0x0
  pushl $42
801058a4:	6a 2a                	push   $0x2a
  jmp alltraps
801058a6:	e9 ea f8 ff ff       	jmp    80105195 <alltraps>

801058ab <vector43>:
.globl vector43
vector43:
  pushl $0
801058ab:	6a 00                	push   $0x0
  pushl $43
801058ad:	6a 2b                	push   $0x2b
  jmp alltraps
801058af:	e9 e1 f8 ff ff       	jmp    80105195 <alltraps>

801058b4 <vector44>:
.globl vector44
vector44:
  pushl $0
801058b4:	6a 00                	push   $0x0
  pushl $44
801058b6:	6a 2c                	push   $0x2c
  jmp alltraps
801058b8:	e9 d8 f8 ff ff       	jmp    80105195 <alltraps>

801058bd <vector45>:
.globl vector45
vector45:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $45
801058bf:	6a 2d                	push   $0x2d
  jmp alltraps
801058c1:	e9 cf f8 ff ff       	jmp    80105195 <alltraps>

801058c6 <vector46>:
.globl vector46
vector46:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $46
801058c8:	6a 2e                	push   $0x2e
  jmp alltraps
801058ca:	e9 c6 f8 ff ff       	jmp    80105195 <alltraps>

801058cf <vector47>:
.globl vector47
vector47:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $47
801058d1:	6a 2f                	push   $0x2f
  jmp alltraps
801058d3:	e9 bd f8 ff ff       	jmp    80105195 <alltraps>

801058d8 <vector48>:
.globl vector48
vector48:
  pushl $0
801058d8:	6a 00                	push   $0x0
  pushl $48
801058da:	6a 30                	push   $0x30
  jmp alltraps
801058dc:	e9 b4 f8 ff ff       	jmp    80105195 <alltraps>

801058e1 <vector49>:
.globl vector49
vector49:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $49
801058e3:	6a 31                	push   $0x31
  jmp alltraps
801058e5:	e9 ab f8 ff ff       	jmp    80105195 <alltraps>

801058ea <vector50>:
.globl vector50
vector50:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $50
801058ec:	6a 32                	push   $0x32
  jmp alltraps
801058ee:	e9 a2 f8 ff ff       	jmp    80105195 <alltraps>

801058f3 <vector51>:
.globl vector51
vector51:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $51
801058f5:	6a 33                	push   $0x33
  jmp alltraps
801058f7:	e9 99 f8 ff ff       	jmp    80105195 <alltraps>

801058fc <vector52>:
.globl vector52
vector52:
  pushl $0
801058fc:	6a 00                	push   $0x0
  pushl $52
801058fe:	6a 34                	push   $0x34
  jmp alltraps
80105900:	e9 90 f8 ff ff       	jmp    80105195 <alltraps>

80105905 <vector53>:
.globl vector53
vector53:
  pushl $0
80105905:	6a 00                	push   $0x0
  pushl $53
80105907:	6a 35                	push   $0x35
  jmp alltraps
80105909:	e9 87 f8 ff ff       	jmp    80105195 <alltraps>

8010590e <vector54>:
.globl vector54
vector54:
  pushl $0
8010590e:	6a 00                	push   $0x0
  pushl $54
80105910:	6a 36                	push   $0x36
  jmp alltraps
80105912:	e9 7e f8 ff ff       	jmp    80105195 <alltraps>

80105917 <vector55>:
.globl vector55
vector55:
  pushl $0
80105917:	6a 00                	push   $0x0
  pushl $55
80105919:	6a 37                	push   $0x37
  jmp alltraps
8010591b:	e9 75 f8 ff ff       	jmp    80105195 <alltraps>

80105920 <vector56>:
.globl vector56
vector56:
  pushl $0
80105920:	6a 00                	push   $0x0
  pushl $56
80105922:	6a 38                	push   $0x38
  jmp alltraps
80105924:	e9 6c f8 ff ff       	jmp    80105195 <alltraps>

80105929 <vector57>:
.globl vector57
vector57:
  pushl $0
80105929:	6a 00                	push   $0x0
  pushl $57
8010592b:	6a 39                	push   $0x39
  jmp alltraps
8010592d:	e9 63 f8 ff ff       	jmp    80105195 <alltraps>

80105932 <vector58>:
.globl vector58
vector58:
  pushl $0
80105932:	6a 00                	push   $0x0
  pushl $58
80105934:	6a 3a                	push   $0x3a
  jmp alltraps
80105936:	e9 5a f8 ff ff       	jmp    80105195 <alltraps>

8010593b <vector59>:
.globl vector59
vector59:
  pushl $0
8010593b:	6a 00                	push   $0x0
  pushl $59
8010593d:	6a 3b                	push   $0x3b
  jmp alltraps
8010593f:	e9 51 f8 ff ff       	jmp    80105195 <alltraps>

80105944 <vector60>:
.globl vector60
vector60:
  pushl $0
80105944:	6a 00                	push   $0x0
  pushl $60
80105946:	6a 3c                	push   $0x3c
  jmp alltraps
80105948:	e9 48 f8 ff ff       	jmp    80105195 <alltraps>

8010594d <vector61>:
.globl vector61
vector61:
  pushl $0
8010594d:	6a 00                	push   $0x0
  pushl $61
8010594f:	6a 3d                	push   $0x3d
  jmp alltraps
80105951:	e9 3f f8 ff ff       	jmp    80105195 <alltraps>

80105956 <vector62>:
.globl vector62
vector62:
  pushl $0
80105956:	6a 00                	push   $0x0
  pushl $62
80105958:	6a 3e                	push   $0x3e
  jmp alltraps
8010595a:	e9 36 f8 ff ff       	jmp    80105195 <alltraps>

8010595f <vector63>:
.globl vector63
vector63:
  pushl $0
8010595f:	6a 00                	push   $0x0
  pushl $63
80105961:	6a 3f                	push   $0x3f
  jmp alltraps
80105963:	e9 2d f8 ff ff       	jmp    80105195 <alltraps>

80105968 <vector64>:
.globl vector64
vector64:
  pushl $0
80105968:	6a 00                	push   $0x0
  pushl $64
8010596a:	6a 40                	push   $0x40
  jmp alltraps
8010596c:	e9 24 f8 ff ff       	jmp    80105195 <alltraps>

80105971 <vector65>:
.globl vector65
vector65:
  pushl $0
80105971:	6a 00                	push   $0x0
  pushl $65
80105973:	6a 41                	push   $0x41
  jmp alltraps
80105975:	e9 1b f8 ff ff       	jmp    80105195 <alltraps>

8010597a <vector66>:
.globl vector66
vector66:
  pushl $0
8010597a:	6a 00                	push   $0x0
  pushl $66
8010597c:	6a 42                	push   $0x42
  jmp alltraps
8010597e:	e9 12 f8 ff ff       	jmp    80105195 <alltraps>

80105983 <vector67>:
.globl vector67
vector67:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $67
80105985:	6a 43                	push   $0x43
  jmp alltraps
80105987:	e9 09 f8 ff ff       	jmp    80105195 <alltraps>

8010598c <vector68>:
.globl vector68
vector68:
  pushl $0
8010598c:	6a 00                	push   $0x0
  pushl $68
8010598e:	6a 44                	push   $0x44
  jmp alltraps
80105990:	e9 00 f8 ff ff       	jmp    80105195 <alltraps>

80105995 <vector69>:
.globl vector69
vector69:
  pushl $0
80105995:	6a 00                	push   $0x0
  pushl $69
80105997:	6a 45                	push   $0x45
  jmp alltraps
80105999:	e9 f7 f7 ff ff       	jmp    80105195 <alltraps>

8010599e <vector70>:
.globl vector70
vector70:
  pushl $0
8010599e:	6a 00                	push   $0x0
  pushl $70
801059a0:	6a 46                	push   $0x46
  jmp alltraps
801059a2:	e9 ee f7 ff ff       	jmp    80105195 <alltraps>

801059a7 <vector71>:
.globl vector71
vector71:
  pushl $0
801059a7:	6a 00                	push   $0x0
  pushl $71
801059a9:	6a 47                	push   $0x47
  jmp alltraps
801059ab:	e9 e5 f7 ff ff       	jmp    80105195 <alltraps>

801059b0 <vector72>:
.globl vector72
vector72:
  pushl $0
801059b0:	6a 00                	push   $0x0
  pushl $72
801059b2:	6a 48                	push   $0x48
  jmp alltraps
801059b4:	e9 dc f7 ff ff       	jmp    80105195 <alltraps>

801059b9 <vector73>:
.globl vector73
vector73:
  pushl $0
801059b9:	6a 00                	push   $0x0
  pushl $73
801059bb:	6a 49                	push   $0x49
  jmp alltraps
801059bd:	e9 d3 f7 ff ff       	jmp    80105195 <alltraps>

801059c2 <vector74>:
.globl vector74
vector74:
  pushl $0
801059c2:	6a 00                	push   $0x0
  pushl $74
801059c4:	6a 4a                	push   $0x4a
  jmp alltraps
801059c6:	e9 ca f7 ff ff       	jmp    80105195 <alltraps>

801059cb <vector75>:
.globl vector75
vector75:
  pushl $0
801059cb:	6a 00                	push   $0x0
  pushl $75
801059cd:	6a 4b                	push   $0x4b
  jmp alltraps
801059cf:	e9 c1 f7 ff ff       	jmp    80105195 <alltraps>

801059d4 <vector76>:
.globl vector76
vector76:
  pushl $0
801059d4:	6a 00                	push   $0x0
  pushl $76
801059d6:	6a 4c                	push   $0x4c
  jmp alltraps
801059d8:	e9 b8 f7 ff ff       	jmp    80105195 <alltraps>

801059dd <vector77>:
.globl vector77
vector77:
  pushl $0
801059dd:	6a 00                	push   $0x0
  pushl $77
801059df:	6a 4d                	push   $0x4d
  jmp alltraps
801059e1:	e9 af f7 ff ff       	jmp    80105195 <alltraps>

801059e6 <vector78>:
.globl vector78
vector78:
  pushl $0
801059e6:	6a 00                	push   $0x0
  pushl $78
801059e8:	6a 4e                	push   $0x4e
  jmp alltraps
801059ea:	e9 a6 f7 ff ff       	jmp    80105195 <alltraps>

801059ef <vector79>:
.globl vector79
vector79:
  pushl $0
801059ef:	6a 00                	push   $0x0
  pushl $79
801059f1:	6a 4f                	push   $0x4f
  jmp alltraps
801059f3:	e9 9d f7 ff ff       	jmp    80105195 <alltraps>

801059f8 <vector80>:
.globl vector80
vector80:
  pushl $0
801059f8:	6a 00                	push   $0x0
  pushl $80
801059fa:	6a 50                	push   $0x50
  jmp alltraps
801059fc:	e9 94 f7 ff ff       	jmp    80105195 <alltraps>

80105a01 <vector81>:
.globl vector81
vector81:
  pushl $0
80105a01:	6a 00                	push   $0x0
  pushl $81
80105a03:	6a 51                	push   $0x51
  jmp alltraps
80105a05:	e9 8b f7 ff ff       	jmp    80105195 <alltraps>

80105a0a <vector82>:
.globl vector82
vector82:
  pushl $0
80105a0a:	6a 00                	push   $0x0
  pushl $82
80105a0c:	6a 52                	push   $0x52
  jmp alltraps
80105a0e:	e9 82 f7 ff ff       	jmp    80105195 <alltraps>

80105a13 <vector83>:
.globl vector83
vector83:
  pushl $0
80105a13:	6a 00                	push   $0x0
  pushl $83
80105a15:	6a 53                	push   $0x53
  jmp alltraps
80105a17:	e9 79 f7 ff ff       	jmp    80105195 <alltraps>

80105a1c <vector84>:
.globl vector84
vector84:
  pushl $0
80105a1c:	6a 00                	push   $0x0
  pushl $84
80105a1e:	6a 54                	push   $0x54
  jmp alltraps
80105a20:	e9 70 f7 ff ff       	jmp    80105195 <alltraps>

80105a25 <vector85>:
.globl vector85
vector85:
  pushl $0
80105a25:	6a 00                	push   $0x0
  pushl $85
80105a27:	6a 55                	push   $0x55
  jmp alltraps
80105a29:	e9 67 f7 ff ff       	jmp    80105195 <alltraps>

80105a2e <vector86>:
.globl vector86
vector86:
  pushl $0
80105a2e:	6a 00                	push   $0x0
  pushl $86
80105a30:	6a 56                	push   $0x56
  jmp alltraps
80105a32:	e9 5e f7 ff ff       	jmp    80105195 <alltraps>

80105a37 <vector87>:
.globl vector87
vector87:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $87
80105a39:	6a 57                	push   $0x57
  jmp alltraps
80105a3b:	e9 55 f7 ff ff       	jmp    80105195 <alltraps>

80105a40 <vector88>:
.globl vector88
vector88:
  pushl $0
80105a40:	6a 00                	push   $0x0
  pushl $88
80105a42:	6a 58                	push   $0x58
  jmp alltraps
80105a44:	e9 4c f7 ff ff       	jmp    80105195 <alltraps>

80105a49 <vector89>:
.globl vector89
vector89:
  pushl $0
80105a49:	6a 00                	push   $0x0
  pushl $89
80105a4b:	6a 59                	push   $0x59
  jmp alltraps
80105a4d:	e9 43 f7 ff ff       	jmp    80105195 <alltraps>

80105a52 <vector90>:
.globl vector90
vector90:
  pushl $0
80105a52:	6a 00                	push   $0x0
  pushl $90
80105a54:	6a 5a                	push   $0x5a
  jmp alltraps
80105a56:	e9 3a f7 ff ff       	jmp    80105195 <alltraps>

80105a5b <vector91>:
.globl vector91
vector91:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $91
80105a5d:	6a 5b                	push   $0x5b
  jmp alltraps
80105a5f:	e9 31 f7 ff ff       	jmp    80105195 <alltraps>

80105a64 <vector92>:
.globl vector92
vector92:
  pushl $0
80105a64:	6a 00                	push   $0x0
  pushl $92
80105a66:	6a 5c                	push   $0x5c
  jmp alltraps
80105a68:	e9 28 f7 ff ff       	jmp    80105195 <alltraps>

80105a6d <vector93>:
.globl vector93
vector93:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $93
80105a6f:	6a 5d                	push   $0x5d
  jmp alltraps
80105a71:	e9 1f f7 ff ff       	jmp    80105195 <alltraps>

80105a76 <vector94>:
.globl vector94
vector94:
  pushl $0
80105a76:	6a 00                	push   $0x0
  pushl $94
80105a78:	6a 5e                	push   $0x5e
  jmp alltraps
80105a7a:	e9 16 f7 ff ff       	jmp    80105195 <alltraps>

80105a7f <vector95>:
.globl vector95
vector95:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $95
80105a81:	6a 5f                	push   $0x5f
  jmp alltraps
80105a83:	e9 0d f7 ff ff       	jmp    80105195 <alltraps>

80105a88 <vector96>:
.globl vector96
vector96:
  pushl $0
80105a88:	6a 00                	push   $0x0
  pushl $96
80105a8a:	6a 60                	push   $0x60
  jmp alltraps
80105a8c:	e9 04 f7 ff ff       	jmp    80105195 <alltraps>

80105a91 <vector97>:
.globl vector97
vector97:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $97
80105a93:	6a 61                	push   $0x61
  jmp alltraps
80105a95:	e9 fb f6 ff ff       	jmp    80105195 <alltraps>

80105a9a <vector98>:
.globl vector98
vector98:
  pushl $0
80105a9a:	6a 00                	push   $0x0
  pushl $98
80105a9c:	6a 62                	push   $0x62
  jmp alltraps
80105a9e:	e9 f2 f6 ff ff       	jmp    80105195 <alltraps>

80105aa3 <vector99>:
.globl vector99
vector99:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $99
80105aa5:	6a 63                	push   $0x63
  jmp alltraps
80105aa7:	e9 e9 f6 ff ff       	jmp    80105195 <alltraps>

80105aac <vector100>:
.globl vector100
vector100:
  pushl $0
80105aac:	6a 00                	push   $0x0
  pushl $100
80105aae:	6a 64                	push   $0x64
  jmp alltraps
80105ab0:	e9 e0 f6 ff ff       	jmp    80105195 <alltraps>

80105ab5 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $101
80105ab7:	6a 65                	push   $0x65
  jmp alltraps
80105ab9:	e9 d7 f6 ff ff       	jmp    80105195 <alltraps>

80105abe <vector102>:
.globl vector102
vector102:
  pushl $0
80105abe:	6a 00                	push   $0x0
  pushl $102
80105ac0:	6a 66                	push   $0x66
  jmp alltraps
80105ac2:	e9 ce f6 ff ff       	jmp    80105195 <alltraps>

80105ac7 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $103
80105ac9:	6a 67                	push   $0x67
  jmp alltraps
80105acb:	e9 c5 f6 ff ff       	jmp    80105195 <alltraps>

80105ad0 <vector104>:
.globl vector104
vector104:
  pushl $0
80105ad0:	6a 00                	push   $0x0
  pushl $104
80105ad2:	6a 68                	push   $0x68
  jmp alltraps
80105ad4:	e9 bc f6 ff ff       	jmp    80105195 <alltraps>

80105ad9 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $105
80105adb:	6a 69                	push   $0x69
  jmp alltraps
80105add:	e9 b3 f6 ff ff       	jmp    80105195 <alltraps>

80105ae2 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ae2:	6a 00                	push   $0x0
  pushl $106
80105ae4:	6a 6a                	push   $0x6a
  jmp alltraps
80105ae6:	e9 aa f6 ff ff       	jmp    80105195 <alltraps>

80105aeb <vector107>:
.globl vector107
vector107:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $107
80105aed:	6a 6b                	push   $0x6b
  jmp alltraps
80105aef:	e9 a1 f6 ff ff       	jmp    80105195 <alltraps>

80105af4 <vector108>:
.globl vector108
vector108:
  pushl $0
80105af4:	6a 00                	push   $0x0
  pushl $108
80105af6:	6a 6c                	push   $0x6c
  jmp alltraps
80105af8:	e9 98 f6 ff ff       	jmp    80105195 <alltraps>

80105afd <vector109>:
.globl vector109
vector109:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $109
80105aff:	6a 6d                	push   $0x6d
  jmp alltraps
80105b01:	e9 8f f6 ff ff       	jmp    80105195 <alltraps>

80105b06 <vector110>:
.globl vector110
vector110:
  pushl $0
80105b06:	6a 00                	push   $0x0
  pushl $110
80105b08:	6a 6e                	push   $0x6e
  jmp alltraps
80105b0a:	e9 86 f6 ff ff       	jmp    80105195 <alltraps>

80105b0f <vector111>:
.globl vector111
vector111:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $111
80105b11:	6a 6f                	push   $0x6f
  jmp alltraps
80105b13:	e9 7d f6 ff ff       	jmp    80105195 <alltraps>

80105b18 <vector112>:
.globl vector112
vector112:
  pushl $0
80105b18:	6a 00                	push   $0x0
  pushl $112
80105b1a:	6a 70                	push   $0x70
  jmp alltraps
80105b1c:	e9 74 f6 ff ff       	jmp    80105195 <alltraps>

80105b21 <vector113>:
.globl vector113
vector113:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $113
80105b23:	6a 71                	push   $0x71
  jmp alltraps
80105b25:	e9 6b f6 ff ff       	jmp    80105195 <alltraps>

80105b2a <vector114>:
.globl vector114
vector114:
  pushl $0
80105b2a:	6a 00                	push   $0x0
  pushl $114
80105b2c:	6a 72                	push   $0x72
  jmp alltraps
80105b2e:	e9 62 f6 ff ff       	jmp    80105195 <alltraps>

80105b33 <vector115>:
.globl vector115
vector115:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $115
80105b35:	6a 73                	push   $0x73
  jmp alltraps
80105b37:	e9 59 f6 ff ff       	jmp    80105195 <alltraps>

80105b3c <vector116>:
.globl vector116
vector116:
  pushl $0
80105b3c:	6a 00                	push   $0x0
  pushl $116
80105b3e:	6a 74                	push   $0x74
  jmp alltraps
80105b40:	e9 50 f6 ff ff       	jmp    80105195 <alltraps>

80105b45 <vector117>:
.globl vector117
vector117:
  pushl $0
80105b45:	6a 00                	push   $0x0
  pushl $117
80105b47:	6a 75                	push   $0x75
  jmp alltraps
80105b49:	e9 47 f6 ff ff       	jmp    80105195 <alltraps>

80105b4e <vector118>:
.globl vector118
vector118:
  pushl $0
80105b4e:	6a 00                	push   $0x0
  pushl $118
80105b50:	6a 76                	push   $0x76
  jmp alltraps
80105b52:	e9 3e f6 ff ff       	jmp    80105195 <alltraps>

80105b57 <vector119>:
.globl vector119
vector119:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $119
80105b59:	6a 77                	push   $0x77
  jmp alltraps
80105b5b:	e9 35 f6 ff ff       	jmp    80105195 <alltraps>

80105b60 <vector120>:
.globl vector120
vector120:
  pushl $0
80105b60:	6a 00                	push   $0x0
  pushl $120
80105b62:	6a 78                	push   $0x78
  jmp alltraps
80105b64:	e9 2c f6 ff ff       	jmp    80105195 <alltraps>

80105b69 <vector121>:
.globl vector121
vector121:
  pushl $0
80105b69:	6a 00                	push   $0x0
  pushl $121
80105b6b:	6a 79                	push   $0x79
  jmp alltraps
80105b6d:	e9 23 f6 ff ff       	jmp    80105195 <alltraps>

80105b72 <vector122>:
.globl vector122
vector122:
  pushl $0
80105b72:	6a 00                	push   $0x0
  pushl $122
80105b74:	6a 7a                	push   $0x7a
  jmp alltraps
80105b76:	e9 1a f6 ff ff       	jmp    80105195 <alltraps>

80105b7b <vector123>:
.globl vector123
vector123:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $123
80105b7d:	6a 7b                	push   $0x7b
  jmp alltraps
80105b7f:	e9 11 f6 ff ff       	jmp    80105195 <alltraps>

80105b84 <vector124>:
.globl vector124
vector124:
  pushl $0
80105b84:	6a 00                	push   $0x0
  pushl $124
80105b86:	6a 7c                	push   $0x7c
  jmp alltraps
80105b88:	e9 08 f6 ff ff       	jmp    80105195 <alltraps>

80105b8d <vector125>:
.globl vector125
vector125:
  pushl $0
80105b8d:	6a 00                	push   $0x0
  pushl $125
80105b8f:	6a 7d                	push   $0x7d
  jmp alltraps
80105b91:	e9 ff f5 ff ff       	jmp    80105195 <alltraps>

80105b96 <vector126>:
.globl vector126
vector126:
  pushl $0
80105b96:	6a 00                	push   $0x0
  pushl $126
80105b98:	6a 7e                	push   $0x7e
  jmp alltraps
80105b9a:	e9 f6 f5 ff ff       	jmp    80105195 <alltraps>

80105b9f <vector127>:
.globl vector127
vector127:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $127
80105ba1:	6a 7f                	push   $0x7f
  jmp alltraps
80105ba3:	e9 ed f5 ff ff       	jmp    80105195 <alltraps>

80105ba8 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ba8:	6a 00                	push   $0x0
  pushl $128
80105baa:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105baf:	e9 e1 f5 ff ff       	jmp    80105195 <alltraps>

80105bb4 <vector129>:
.globl vector129
vector129:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $129
80105bb6:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105bbb:	e9 d5 f5 ff ff       	jmp    80105195 <alltraps>

80105bc0 <vector130>:
.globl vector130
vector130:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $130
80105bc2:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105bc7:	e9 c9 f5 ff ff       	jmp    80105195 <alltraps>

80105bcc <vector131>:
.globl vector131
vector131:
  pushl $0
80105bcc:	6a 00                	push   $0x0
  pushl $131
80105bce:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105bd3:	e9 bd f5 ff ff       	jmp    80105195 <alltraps>

80105bd8 <vector132>:
.globl vector132
vector132:
  pushl $0
80105bd8:	6a 00                	push   $0x0
  pushl $132
80105bda:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105bdf:	e9 b1 f5 ff ff       	jmp    80105195 <alltraps>

80105be4 <vector133>:
.globl vector133
vector133:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $133
80105be6:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105beb:	e9 a5 f5 ff ff       	jmp    80105195 <alltraps>

80105bf0 <vector134>:
.globl vector134
vector134:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $134
80105bf2:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105bf7:	e9 99 f5 ff ff       	jmp    80105195 <alltraps>

80105bfc <vector135>:
.globl vector135
vector135:
  pushl $0
80105bfc:	6a 00                	push   $0x0
  pushl $135
80105bfe:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105c03:	e9 8d f5 ff ff       	jmp    80105195 <alltraps>

80105c08 <vector136>:
.globl vector136
vector136:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $136
80105c0a:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105c0f:	e9 81 f5 ff ff       	jmp    80105195 <alltraps>

80105c14 <vector137>:
.globl vector137
vector137:
  pushl $0
80105c14:	6a 00                	push   $0x0
  pushl $137
80105c16:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105c1b:	e9 75 f5 ff ff       	jmp    80105195 <alltraps>

80105c20 <vector138>:
.globl vector138
vector138:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $138
80105c22:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c27:	e9 69 f5 ff ff       	jmp    80105195 <alltraps>

80105c2c <vector139>:
.globl vector139
vector139:
  pushl $0
80105c2c:	6a 00                	push   $0x0
  pushl $139
80105c2e:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c33:	e9 5d f5 ff ff       	jmp    80105195 <alltraps>

80105c38 <vector140>:
.globl vector140
vector140:
  pushl $0
80105c38:	6a 00                	push   $0x0
  pushl $140
80105c3a:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c3f:	e9 51 f5 ff ff       	jmp    80105195 <alltraps>

80105c44 <vector141>:
.globl vector141
vector141:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $141
80105c46:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105c4b:	e9 45 f5 ff ff       	jmp    80105195 <alltraps>

80105c50 <vector142>:
.globl vector142
vector142:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $142
80105c52:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105c57:	e9 39 f5 ff ff       	jmp    80105195 <alltraps>

80105c5c <vector143>:
.globl vector143
vector143:
  pushl $0
80105c5c:	6a 00                	push   $0x0
  pushl $143
80105c5e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105c63:	e9 2d f5 ff ff       	jmp    80105195 <alltraps>

80105c68 <vector144>:
.globl vector144
vector144:
  pushl $0
80105c68:	6a 00                	push   $0x0
  pushl $144
80105c6a:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105c6f:	e9 21 f5 ff ff       	jmp    80105195 <alltraps>

80105c74 <vector145>:
.globl vector145
vector145:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $145
80105c76:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c7b:	e9 15 f5 ff ff       	jmp    80105195 <alltraps>

80105c80 <vector146>:
.globl vector146
vector146:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $146
80105c82:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c87:	e9 09 f5 ff ff       	jmp    80105195 <alltraps>

80105c8c <vector147>:
.globl vector147
vector147:
  pushl $0
80105c8c:	6a 00                	push   $0x0
  pushl $147
80105c8e:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105c93:	e9 fd f4 ff ff       	jmp    80105195 <alltraps>

80105c98 <vector148>:
.globl vector148
vector148:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $148
80105c9a:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105c9f:	e9 f1 f4 ff ff       	jmp    80105195 <alltraps>

80105ca4 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $149
80105ca6:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105cab:	e9 e5 f4 ff ff       	jmp    80105195 <alltraps>

80105cb0 <vector150>:
.globl vector150
vector150:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $150
80105cb2:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105cb7:	e9 d9 f4 ff ff       	jmp    80105195 <alltraps>

80105cbc <vector151>:
.globl vector151
vector151:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $151
80105cbe:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105cc3:	e9 cd f4 ff ff       	jmp    80105195 <alltraps>

80105cc8 <vector152>:
.globl vector152
vector152:
  pushl $0
80105cc8:	6a 00                	push   $0x0
  pushl $152
80105cca:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ccf:	e9 c1 f4 ff ff       	jmp    80105195 <alltraps>

80105cd4 <vector153>:
.globl vector153
vector153:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $153
80105cd6:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105cdb:	e9 b5 f4 ff ff       	jmp    80105195 <alltraps>

80105ce0 <vector154>:
.globl vector154
vector154:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $154
80105ce2:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ce7:	e9 a9 f4 ff ff       	jmp    80105195 <alltraps>

80105cec <vector155>:
.globl vector155
vector155:
  pushl $0
80105cec:	6a 00                	push   $0x0
  pushl $155
80105cee:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105cf3:	e9 9d f4 ff ff       	jmp    80105195 <alltraps>

80105cf8 <vector156>:
.globl vector156
vector156:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $156
80105cfa:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105cff:	e9 91 f4 ff ff       	jmp    80105195 <alltraps>

80105d04 <vector157>:
.globl vector157
vector157:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $157
80105d06:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105d0b:	e9 85 f4 ff ff       	jmp    80105195 <alltraps>

80105d10 <vector158>:
.globl vector158
vector158:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $158
80105d12:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105d17:	e9 79 f4 ff ff       	jmp    80105195 <alltraps>

80105d1c <vector159>:
.globl vector159
vector159:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $159
80105d1e:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105d23:	e9 6d f4 ff ff       	jmp    80105195 <alltraps>

80105d28 <vector160>:
.globl vector160
vector160:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $160
80105d2a:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d2f:	e9 61 f4 ff ff       	jmp    80105195 <alltraps>

80105d34 <vector161>:
.globl vector161
vector161:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $161
80105d36:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105d3b:	e9 55 f4 ff ff       	jmp    80105195 <alltraps>

80105d40 <vector162>:
.globl vector162
vector162:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $162
80105d42:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d47:	e9 49 f4 ff ff       	jmp    80105195 <alltraps>

80105d4c <vector163>:
.globl vector163
vector163:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $163
80105d4e:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105d53:	e9 3d f4 ff ff       	jmp    80105195 <alltraps>

80105d58 <vector164>:
.globl vector164
vector164:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $164
80105d5a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105d5f:	e9 31 f4 ff ff       	jmp    80105195 <alltraps>

80105d64 <vector165>:
.globl vector165
vector165:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $165
80105d66:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105d6b:	e9 25 f4 ff ff       	jmp    80105195 <alltraps>

80105d70 <vector166>:
.globl vector166
vector166:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $166
80105d72:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d77:	e9 19 f4 ff ff       	jmp    80105195 <alltraps>

80105d7c <vector167>:
.globl vector167
vector167:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $167
80105d7e:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d83:	e9 0d f4 ff ff       	jmp    80105195 <alltraps>

80105d88 <vector168>:
.globl vector168
vector168:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $168
80105d8a:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105d8f:	e9 01 f4 ff ff       	jmp    80105195 <alltraps>

80105d94 <vector169>:
.globl vector169
vector169:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $169
80105d96:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105d9b:	e9 f5 f3 ff ff       	jmp    80105195 <alltraps>

80105da0 <vector170>:
.globl vector170
vector170:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $170
80105da2:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105da7:	e9 e9 f3 ff ff       	jmp    80105195 <alltraps>

80105dac <vector171>:
.globl vector171
vector171:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $171
80105dae:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105db3:	e9 dd f3 ff ff       	jmp    80105195 <alltraps>

80105db8 <vector172>:
.globl vector172
vector172:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $172
80105dba:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105dbf:	e9 d1 f3 ff ff       	jmp    80105195 <alltraps>

80105dc4 <vector173>:
.globl vector173
vector173:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $173
80105dc6:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105dcb:	e9 c5 f3 ff ff       	jmp    80105195 <alltraps>

80105dd0 <vector174>:
.globl vector174
vector174:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $174
80105dd2:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105dd7:	e9 b9 f3 ff ff       	jmp    80105195 <alltraps>

80105ddc <vector175>:
.globl vector175
vector175:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $175
80105dde:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105de3:	e9 ad f3 ff ff       	jmp    80105195 <alltraps>

80105de8 <vector176>:
.globl vector176
vector176:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $176
80105dea:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105def:	e9 a1 f3 ff ff       	jmp    80105195 <alltraps>

80105df4 <vector177>:
.globl vector177
vector177:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $177
80105df6:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105dfb:	e9 95 f3 ff ff       	jmp    80105195 <alltraps>

80105e00 <vector178>:
.globl vector178
vector178:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $178
80105e02:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105e07:	e9 89 f3 ff ff       	jmp    80105195 <alltraps>

80105e0c <vector179>:
.globl vector179
vector179:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $179
80105e0e:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105e13:	e9 7d f3 ff ff       	jmp    80105195 <alltraps>

80105e18 <vector180>:
.globl vector180
vector180:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $180
80105e1a:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105e1f:	e9 71 f3 ff ff       	jmp    80105195 <alltraps>

80105e24 <vector181>:
.globl vector181
vector181:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $181
80105e26:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e2b:	e9 65 f3 ff ff       	jmp    80105195 <alltraps>

80105e30 <vector182>:
.globl vector182
vector182:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $182
80105e32:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e37:	e9 59 f3 ff ff       	jmp    80105195 <alltraps>

80105e3c <vector183>:
.globl vector183
vector183:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $183
80105e3e:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e43:	e9 4d f3 ff ff       	jmp    80105195 <alltraps>

80105e48 <vector184>:
.globl vector184
vector184:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $184
80105e4a:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105e4f:	e9 41 f3 ff ff       	jmp    80105195 <alltraps>

80105e54 <vector185>:
.globl vector185
vector185:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $185
80105e56:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105e5b:	e9 35 f3 ff ff       	jmp    80105195 <alltraps>

80105e60 <vector186>:
.globl vector186
vector186:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $186
80105e62:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105e67:	e9 29 f3 ff ff       	jmp    80105195 <alltraps>

80105e6c <vector187>:
.globl vector187
vector187:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $187
80105e6e:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105e73:	e9 1d f3 ff ff       	jmp    80105195 <alltraps>

80105e78 <vector188>:
.globl vector188
vector188:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $188
80105e7a:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e7f:	e9 11 f3 ff ff       	jmp    80105195 <alltraps>

80105e84 <vector189>:
.globl vector189
vector189:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $189
80105e86:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105e8b:	e9 05 f3 ff ff       	jmp    80105195 <alltraps>

80105e90 <vector190>:
.globl vector190
vector190:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $190
80105e92:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105e97:	e9 f9 f2 ff ff       	jmp    80105195 <alltraps>

80105e9c <vector191>:
.globl vector191
vector191:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $191
80105e9e:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105ea3:	e9 ed f2 ff ff       	jmp    80105195 <alltraps>

80105ea8 <vector192>:
.globl vector192
vector192:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $192
80105eaa:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105eaf:	e9 e1 f2 ff ff       	jmp    80105195 <alltraps>

80105eb4 <vector193>:
.globl vector193
vector193:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $193
80105eb6:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105ebb:	e9 d5 f2 ff ff       	jmp    80105195 <alltraps>

80105ec0 <vector194>:
.globl vector194
vector194:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $194
80105ec2:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ec7:	e9 c9 f2 ff ff       	jmp    80105195 <alltraps>

80105ecc <vector195>:
.globl vector195
vector195:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $195
80105ece:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105ed3:	e9 bd f2 ff ff       	jmp    80105195 <alltraps>

80105ed8 <vector196>:
.globl vector196
vector196:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $196
80105eda:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105edf:	e9 b1 f2 ff ff       	jmp    80105195 <alltraps>

80105ee4 <vector197>:
.globl vector197
vector197:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $197
80105ee6:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105eeb:	e9 a5 f2 ff ff       	jmp    80105195 <alltraps>

80105ef0 <vector198>:
.globl vector198
vector198:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $198
80105ef2:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105ef7:	e9 99 f2 ff ff       	jmp    80105195 <alltraps>

80105efc <vector199>:
.globl vector199
vector199:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $199
80105efe:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105f03:	e9 8d f2 ff ff       	jmp    80105195 <alltraps>

80105f08 <vector200>:
.globl vector200
vector200:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $200
80105f0a:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105f0f:	e9 81 f2 ff ff       	jmp    80105195 <alltraps>

80105f14 <vector201>:
.globl vector201
vector201:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $201
80105f16:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105f1b:	e9 75 f2 ff ff       	jmp    80105195 <alltraps>

80105f20 <vector202>:
.globl vector202
vector202:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $202
80105f22:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f27:	e9 69 f2 ff ff       	jmp    80105195 <alltraps>

80105f2c <vector203>:
.globl vector203
vector203:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $203
80105f2e:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f33:	e9 5d f2 ff ff       	jmp    80105195 <alltraps>

80105f38 <vector204>:
.globl vector204
vector204:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $204
80105f3a:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f3f:	e9 51 f2 ff ff       	jmp    80105195 <alltraps>

80105f44 <vector205>:
.globl vector205
vector205:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $205
80105f46:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105f4b:	e9 45 f2 ff ff       	jmp    80105195 <alltraps>

80105f50 <vector206>:
.globl vector206
vector206:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $206
80105f52:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105f57:	e9 39 f2 ff ff       	jmp    80105195 <alltraps>

80105f5c <vector207>:
.globl vector207
vector207:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $207
80105f5e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105f63:	e9 2d f2 ff ff       	jmp    80105195 <alltraps>

80105f68 <vector208>:
.globl vector208
vector208:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $208
80105f6a:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105f6f:	e9 21 f2 ff ff       	jmp    80105195 <alltraps>

80105f74 <vector209>:
.globl vector209
vector209:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $209
80105f76:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f7b:	e9 15 f2 ff ff       	jmp    80105195 <alltraps>

80105f80 <vector210>:
.globl vector210
vector210:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $210
80105f82:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f87:	e9 09 f2 ff ff       	jmp    80105195 <alltraps>

80105f8c <vector211>:
.globl vector211
vector211:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $211
80105f8e:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105f93:	e9 fd f1 ff ff       	jmp    80105195 <alltraps>

80105f98 <vector212>:
.globl vector212
vector212:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $212
80105f9a:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105f9f:	e9 f1 f1 ff ff       	jmp    80105195 <alltraps>

80105fa4 <vector213>:
.globl vector213
vector213:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $213
80105fa6:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105fab:	e9 e5 f1 ff ff       	jmp    80105195 <alltraps>

80105fb0 <vector214>:
.globl vector214
vector214:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $214
80105fb2:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105fb7:	e9 d9 f1 ff ff       	jmp    80105195 <alltraps>

80105fbc <vector215>:
.globl vector215
vector215:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $215
80105fbe:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105fc3:	e9 cd f1 ff ff       	jmp    80105195 <alltraps>

80105fc8 <vector216>:
.globl vector216
vector216:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $216
80105fca:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105fcf:	e9 c1 f1 ff ff       	jmp    80105195 <alltraps>

80105fd4 <vector217>:
.globl vector217
vector217:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $217
80105fd6:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105fdb:	e9 b5 f1 ff ff       	jmp    80105195 <alltraps>

80105fe0 <vector218>:
.globl vector218
vector218:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $218
80105fe2:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105fe7:	e9 a9 f1 ff ff       	jmp    80105195 <alltraps>

80105fec <vector219>:
.globl vector219
vector219:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $219
80105fee:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105ff3:	e9 9d f1 ff ff       	jmp    80105195 <alltraps>

80105ff8 <vector220>:
.globl vector220
vector220:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $220
80105ffa:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105fff:	e9 91 f1 ff ff       	jmp    80105195 <alltraps>

80106004 <vector221>:
.globl vector221
vector221:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $221
80106006:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010600b:	e9 85 f1 ff ff       	jmp    80105195 <alltraps>

80106010 <vector222>:
.globl vector222
vector222:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $222
80106012:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106017:	e9 79 f1 ff ff       	jmp    80105195 <alltraps>

8010601c <vector223>:
.globl vector223
vector223:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $223
8010601e:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106023:	e9 6d f1 ff ff       	jmp    80105195 <alltraps>

80106028 <vector224>:
.globl vector224
vector224:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $224
8010602a:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010602f:	e9 61 f1 ff ff       	jmp    80105195 <alltraps>

80106034 <vector225>:
.globl vector225
vector225:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $225
80106036:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010603b:	e9 55 f1 ff ff       	jmp    80105195 <alltraps>

80106040 <vector226>:
.globl vector226
vector226:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $226
80106042:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106047:	e9 49 f1 ff ff       	jmp    80105195 <alltraps>

8010604c <vector227>:
.globl vector227
vector227:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $227
8010604e:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106053:	e9 3d f1 ff ff       	jmp    80105195 <alltraps>

80106058 <vector228>:
.globl vector228
vector228:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $228
8010605a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010605f:	e9 31 f1 ff ff       	jmp    80105195 <alltraps>

80106064 <vector229>:
.globl vector229
vector229:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $229
80106066:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010606b:	e9 25 f1 ff ff       	jmp    80105195 <alltraps>

80106070 <vector230>:
.globl vector230
vector230:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $230
80106072:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106077:	e9 19 f1 ff ff       	jmp    80105195 <alltraps>

8010607c <vector231>:
.globl vector231
vector231:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $231
8010607e:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106083:	e9 0d f1 ff ff       	jmp    80105195 <alltraps>

80106088 <vector232>:
.globl vector232
vector232:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $232
8010608a:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010608f:	e9 01 f1 ff ff       	jmp    80105195 <alltraps>

80106094 <vector233>:
.globl vector233
vector233:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $233
80106096:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010609b:	e9 f5 f0 ff ff       	jmp    80105195 <alltraps>

801060a0 <vector234>:
.globl vector234
vector234:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $234
801060a2:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801060a7:	e9 e9 f0 ff ff       	jmp    80105195 <alltraps>

801060ac <vector235>:
.globl vector235
vector235:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $235
801060ae:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801060b3:	e9 dd f0 ff ff       	jmp    80105195 <alltraps>

801060b8 <vector236>:
.globl vector236
vector236:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $236
801060ba:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801060bf:	e9 d1 f0 ff ff       	jmp    80105195 <alltraps>

801060c4 <vector237>:
.globl vector237
vector237:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $237
801060c6:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801060cb:	e9 c5 f0 ff ff       	jmp    80105195 <alltraps>

801060d0 <vector238>:
.globl vector238
vector238:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $238
801060d2:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801060d7:	e9 b9 f0 ff ff       	jmp    80105195 <alltraps>

801060dc <vector239>:
.globl vector239
vector239:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $239
801060de:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801060e3:	e9 ad f0 ff ff       	jmp    80105195 <alltraps>

801060e8 <vector240>:
.globl vector240
vector240:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $240
801060ea:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801060ef:	e9 a1 f0 ff ff       	jmp    80105195 <alltraps>

801060f4 <vector241>:
.globl vector241
vector241:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $241
801060f6:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801060fb:	e9 95 f0 ff ff       	jmp    80105195 <alltraps>

80106100 <vector242>:
.globl vector242
vector242:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $242
80106102:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106107:	e9 89 f0 ff ff       	jmp    80105195 <alltraps>

8010610c <vector243>:
.globl vector243
vector243:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $243
8010610e:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106113:	e9 7d f0 ff ff       	jmp    80105195 <alltraps>

80106118 <vector244>:
.globl vector244
vector244:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $244
8010611a:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010611f:	e9 71 f0 ff ff       	jmp    80105195 <alltraps>

80106124 <vector245>:
.globl vector245
vector245:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $245
80106126:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010612b:	e9 65 f0 ff ff       	jmp    80105195 <alltraps>

80106130 <vector246>:
.globl vector246
vector246:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $246
80106132:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106137:	e9 59 f0 ff ff       	jmp    80105195 <alltraps>

8010613c <vector247>:
.globl vector247
vector247:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $247
8010613e:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106143:	e9 4d f0 ff ff       	jmp    80105195 <alltraps>

80106148 <vector248>:
.globl vector248
vector248:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $248
8010614a:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010614f:	e9 41 f0 ff ff       	jmp    80105195 <alltraps>

80106154 <vector249>:
.globl vector249
vector249:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $249
80106156:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010615b:	e9 35 f0 ff ff       	jmp    80105195 <alltraps>

80106160 <vector250>:
.globl vector250
vector250:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $250
80106162:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106167:	e9 29 f0 ff ff       	jmp    80105195 <alltraps>

8010616c <vector251>:
.globl vector251
vector251:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $251
8010616e:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106173:	e9 1d f0 ff ff       	jmp    80105195 <alltraps>

80106178 <vector252>:
.globl vector252
vector252:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $252
8010617a:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010617f:	e9 11 f0 ff ff       	jmp    80105195 <alltraps>

80106184 <vector253>:
.globl vector253
vector253:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $253
80106186:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010618b:	e9 05 f0 ff ff       	jmp    80105195 <alltraps>

80106190 <vector254>:
.globl vector254
vector254:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $254
80106192:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106197:	e9 f9 ef ff ff       	jmp    80105195 <alltraps>

8010619c <vector255>:
.globl vector255
vector255:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $255
8010619e:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801061a3:	e9 ed ef ff ff       	jmp    80105195 <alltraps>

801061a8 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801061a8:	55                   	push   %ebp
801061a9:	89 e5                	mov    %esp,%ebp
801061ab:	57                   	push   %edi
801061ac:	56                   	push   %esi
801061ad:	53                   	push   %ebx
801061ae:	83 ec 0c             	sub    $0xc,%esp
801061b1:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801061b3:	c1 ea 16             	shr    $0x16,%edx
801061b6:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801061b9:	8b 37                	mov    (%edi),%esi
801061bb:	f7 c6 01 00 00 00    	test   $0x1,%esi
801061c1:	74 20                	je     801061e3 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801061c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801061c9:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801061cf:	c1 eb 0c             	shr    $0xc,%ebx
801061d2:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
801061d8:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
801061db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061de:	5b                   	pop    %ebx
801061df:	5e                   	pop    %esi
801061e0:	5f                   	pop    %edi
801061e1:	5d                   	pop    %ebp
801061e2:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801061e3:	85 c9                	test   %ecx,%ecx
801061e5:	74 2b                	je     80106212 <walkpgdir+0x6a>
801061e7:	e8 20 bf ff ff       	call   8010210c <kalloc>
801061ec:	89 c6                	mov    %eax,%esi
801061ee:	85 c0                	test   %eax,%eax
801061f0:	74 20                	je     80106212 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
801061f2:	83 ec 04             	sub    $0x4,%esp
801061f5:	68 00 10 00 00       	push   $0x1000
801061fa:	6a 00                	push   $0x0
801061fc:	50                   	push   %eax
801061fd:	e8 29 dd ff ff       	call   80103f2b <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106202:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106208:	83 c8 07             	or     $0x7,%eax
8010620b:	89 07                	mov    %eax,(%edi)
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	eb bd                	jmp    801061cf <walkpgdir+0x27>
      return 0;
80106212:	b8 00 00 00 00       	mov    $0x0,%eax
80106217:	eb c2                	jmp    801061db <walkpgdir+0x33>

80106219 <seginit>:
{
80106219:	f3 0f 1e fb          	endbr32 
8010621d:	55                   	push   %ebp
8010621e:	89 e5                	mov    %esp,%ebp
80106220:	57                   	push   %edi
80106221:	56                   	push   %esi
80106222:	53                   	push   %ebx
80106223:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80106226:	e8 eb cf ff ff       	call   80103216 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010622b:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010622e:	8d 3c 09             	lea    (%ecx,%ecx,1),%edi
80106231:	8d 14 07             	lea    (%edi,%eax,1),%edx
80106234:	c1 e2 04             	shl    $0x4,%edx
80106237:	66 c7 82 f8 27 11 80 	movw   $0xffff,-0x7feed808(%edx)
8010623e:	ff ff 
80106240:	66 c7 82 fa 27 11 80 	movw   $0x0,-0x7feed806(%edx)
80106247:	00 00 
80106249:	c6 82 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%edx)
80106250:	8d 34 07             	lea    (%edi,%eax,1),%esi
80106253:	c1 e6 04             	shl    $0x4,%esi
80106256:	8a 9e fd 27 11 80    	mov    -0x7feed803(%esi),%bl
8010625c:	83 e3 f0             	and    $0xfffffff0,%ebx
8010625f:	83 cb 1a             	or     $0x1a,%ebx
80106262:	83 e3 9f             	and    $0xffffff9f,%ebx
80106265:	83 cb 80             	or     $0xffffff80,%ebx
80106268:	88 9e fd 27 11 80    	mov    %bl,-0x7feed803(%esi)
8010626e:	8a 9e fe 27 11 80    	mov    -0x7feed802(%esi),%bl
80106274:	83 cb 0f             	or     $0xf,%ebx
80106277:	83 e3 cf             	and    $0xffffffcf,%ebx
8010627a:	83 cb c0             	or     $0xffffffc0,%ebx
8010627d:	88 9e fe 27 11 80    	mov    %bl,-0x7feed802(%esi)
80106283:	c6 82 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010628a:	66 c7 82 00 28 11 80 	movw   $0xffff,-0x7feed800(%edx)
80106291:	ff ff 
80106293:	66 c7 82 02 28 11 80 	movw   $0x0,-0x7feed7fe(%edx)
8010629a:	00 00 
8010629c:	c6 82 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%edx)
801062a3:	8d 34 07             	lea    (%edi,%eax,1),%esi
801062a6:	c1 e6 04             	shl    $0x4,%esi
801062a9:	8a 9e 05 28 11 80    	mov    -0x7feed7fb(%esi),%bl
801062af:	83 e3 f0             	and    $0xfffffff0,%ebx
801062b2:	83 cb 12             	or     $0x12,%ebx
801062b5:	83 e3 9f             	and    $0xffffff9f,%ebx
801062b8:	83 cb 80             	or     $0xffffff80,%ebx
801062bb:	88 9e 05 28 11 80    	mov    %bl,-0x7feed7fb(%esi)
801062c1:	8a 9e 06 28 11 80    	mov    -0x7feed7fa(%esi),%bl
801062c7:	83 cb 0f             	or     $0xf,%ebx
801062ca:	83 e3 cf             	and    $0xffffffcf,%ebx
801062cd:	83 cb c0             	or     $0xffffffc0,%ebx
801062d0:	88 9e 06 28 11 80    	mov    %bl,-0x7feed7fa(%esi)
801062d6:	c6 82 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801062dd:	66 c7 82 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%edx)
801062e4:	ff ff 
801062e6:	66 c7 82 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%edx)
801062ed:	00 00 
801062ef:	c6 82 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%edx)
801062f6:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
801062f9:	c1 e3 04             	shl    $0x4,%ebx
801062fc:	c6 83 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%ebx)
80106303:	0f b6 b3 0e 28 11 80 	movzbl -0x7feed7f2(%ebx),%esi
8010630a:	83 ce 0f             	or     $0xf,%esi
8010630d:	83 e6 cf             	and    $0xffffffcf,%esi
80106310:	83 ce c0             	or     $0xffffffc0,%esi
80106313:	89 f1                	mov    %esi,%ecx
80106315:	88 8b 0e 28 11 80    	mov    %cl,-0x7feed7f2(%ebx)
8010631b:	c6 82 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106322:	66 c7 82 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%edx)
80106329:	ff ff 
8010632b:	66 c7 82 12 28 11 80 	movw   $0x0,-0x7feed7ee(%edx)
80106332:	00 00 
80106334:	c6 82 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%edx)
8010633b:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
8010633e:	c1 e3 04             	shl    $0x4,%ebx
80106341:	c6 83 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%ebx)
80106348:	0f b6 b3 16 28 11 80 	movzbl -0x7feed7ea(%ebx),%esi
8010634f:	83 ce 0f             	or     $0xf,%esi
80106352:	83 e6 cf             	and    $0xffffffcf,%esi
80106355:	83 ce c0             	or     $0xffffffc0,%esi
80106358:	89 f1                	mov    %esi,%ecx
8010635a:	88 8b 16 28 11 80    	mov    %cl,-0x7feed7ea(%ebx)
80106360:	c6 82 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%edx)
  lgdt(c->gdt, sizeof(c->gdt));
80106367:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
8010636a:	c1 e1 04             	shl    $0x4,%ecx
8010636d:	81 c1 f0 27 11 80    	add    $0x801127f0,%ecx
  pd[0] = size-1;
80106373:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80106379:	66 89 4d e4          	mov    %cx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
8010637d:	c1 e9 10             	shr    $0x10,%ecx
80106380:	66 89 4d e6          	mov    %cx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106384:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106387:	0f 01 10             	lgdtl  (%eax)
}
8010638a:	83 c4 1c             	add    $0x1c,%esp
8010638d:	5b                   	pop    %ebx
8010638e:	5e                   	pop    %esi
8010638f:	5f                   	pop    %edi
80106390:	5d                   	pop    %ebp
80106391:	c3                   	ret    

80106392 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106392:	f3 0f 1e fb          	endbr32 
80106396:	55                   	push   %ebp
80106397:	89 e5                	mov    %esp,%ebp
80106399:	57                   	push   %edi
8010639a:	56                   	push   %esi
8010639b:	53                   	push   %ebx
8010639c:	83 ec 0c             	sub    $0xc,%esp
8010639f:	8b 7d 0c             	mov    0xc(%ebp),%edi
801063a2:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801063a5:	89 fb                	mov    %edi,%ebx
801063a7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801063ad:	03 7d 10             	add    0x10(%ebp),%edi
801063b0:	4f                   	dec    %edi
801063b1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801063b7:	b9 01 00 00 00       	mov    $0x1,%ecx
801063bc:	89 da                	mov    %ebx,%edx
801063be:	8b 45 08             	mov    0x8(%ebp),%eax
801063c1:	e8 e2 fd ff ff       	call   801061a8 <walkpgdir>
801063c6:	85 c0                	test   %eax,%eax
801063c8:	74 2e                	je     801063f8 <mappages+0x66>
      return -1;
    if(*pte & PTE_P)
801063ca:	f6 00 01             	testb  $0x1,(%eax)
801063cd:	75 1c                	jne    801063eb <mappages+0x59>
      panic("remap");
    *pte = pa | perm | PTE_P;
801063cf:	89 f2                	mov    %esi,%edx
801063d1:	0b 55 18             	or     0x18(%ebp),%edx
801063d4:	83 ca 01             	or     $0x1,%edx
801063d7:	89 10                	mov    %edx,(%eax)
    if(a == last)
801063d9:	39 fb                	cmp    %edi,%ebx
801063db:	74 28                	je     80106405 <mappages+0x73>
      break;
    a += PGSIZE;
801063dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801063e3:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801063e9:	eb cc                	jmp    801063b7 <mappages+0x25>
      panic("remap");
801063eb:	83 ec 0c             	sub    $0xc,%esp
801063ee:	68 3c 74 10 80       	push   $0x8010743c
801063f3:	e8 5d 9f ff ff       	call   80100355 <panic>
      return -1;
801063f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801063fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106400:	5b                   	pop    %ebx
80106401:	5e                   	pop    %esi
80106402:	5f                   	pop    %edi
80106403:	5d                   	pop    %ebp
80106404:	c3                   	ret    
  return 0;
80106405:	b8 00 00 00 00       	mov    $0x0,%eax
8010640a:	eb f1                	jmp    801063fd <mappages+0x6b>

8010640c <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010640c:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106410:	a1 04 59 11 80       	mov    0x80115904,%eax
80106415:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010641a:	0f 22 d8             	mov    %eax,%cr3
}
8010641d:	c3                   	ret    

8010641e <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010641e:	f3 0f 1e fb          	endbr32 
80106422:	55                   	push   %ebp
80106423:	89 e5                	mov    %esp,%ebp
80106425:	57                   	push   %edi
80106426:	56                   	push   %esi
80106427:	53                   	push   %ebx
80106428:	83 ec 1c             	sub    $0x1c,%esp
8010642b:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010642e:	85 f6                	test   %esi,%esi
80106430:	0f 84 da 00 00 00    	je     80106510 <switchuvm+0xf2>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106436:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
8010643a:	0f 84 dd 00 00 00    	je     8010651d <switchuvm+0xff>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106440:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106444:	0f 84 e0 00 00 00    	je     8010652a <switchuvm+0x10c>
    panic("switchuvm: no pgdir");

  pushcli();
8010644a:	e8 40 d9 ff ff       	call   80103d8f <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010644f:	e8 5b cd ff ff       	call   801031af <mycpu>
80106454:	89 c3                	mov    %eax,%ebx
80106456:	e8 54 cd ff ff       	call   801031af <mycpu>
8010645b:	8d 78 08             	lea    0x8(%eax),%edi
8010645e:	e8 4c cd ff ff       	call   801031af <mycpu>
80106463:	83 c0 08             	add    $0x8,%eax
80106466:	c1 e8 10             	shr    $0x10,%eax
80106469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010646c:	e8 3e cd ff ff       	call   801031af <mycpu>
80106471:	83 c0 08             	add    $0x8,%eax
80106474:	c1 e8 18             	shr    $0x18,%eax
80106477:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010647e:	67 00 
80106480:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106487:	8a 4d e4             	mov    -0x1c(%ebp),%cl
8010648a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106490:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80106496:	83 e2 f0             	and    $0xfffffff0,%edx
80106499:	83 ca 19             	or     $0x19,%edx
8010649c:	83 e2 9f             	and    $0xffffff9f,%edx
8010649f:	83 ca 80             	or     $0xffffff80,%edx
801064a2:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801064a8:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801064af:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801064b5:	e8 f5 cc ff ff       	call   801031af <mycpu>
801064ba:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801064c0:	83 e2 ef             	and    $0xffffffef,%edx
801064c3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801064c9:	e8 e1 cc ff ff       	call   801031af <mycpu>
801064ce:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801064d4:	8b 5e 08             	mov    0x8(%esi),%ebx
801064d7:	e8 d3 cc ff ff       	call   801031af <mycpu>
801064dc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064e2:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801064e5:	e8 c5 cc ff ff       	call   801031af <mycpu>
801064ea:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801064f0:	b8 28 00 00 00       	mov    $0x28,%eax
801064f5:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801064f8:	8b 46 04             	mov    0x4(%esi),%eax
801064fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106500:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106503:	e8 c7 d8 ff ff       	call   80103dcf <popcli>
}
80106508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010650b:	5b                   	pop    %ebx
8010650c:	5e                   	pop    %esi
8010650d:	5f                   	pop    %edi
8010650e:	5d                   	pop    %ebp
8010650f:	c3                   	ret    
    panic("switchuvm: no process");
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	68 42 74 10 80       	push   $0x80107442
80106518:	e8 38 9e ff ff       	call   80100355 <panic>
    panic("switchuvm: no kstack");
8010651d:	83 ec 0c             	sub    $0xc,%esp
80106520:	68 58 74 10 80       	push   $0x80107458
80106525:	e8 2b 9e ff ff       	call   80100355 <panic>
    panic("switchuvm: no pgdir");
8010652a:	83 ec 0c             	sub    $0xc,%esp
8010652d:	68 6d 74 10 80       	push   $0x8010746d
80106532:	e8 1e 9e ff ff       	call   80100355 <panic>

80106537 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106537:	f3 0f 1e fb          	endbr32 
8010653b:	55                   	push   %ebp
8010653c:	89 e5                	mov    %esp,%ebp
8010653e:	56                   	push   %esi
8010653f:	53                   	push   %ebx
80106540:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106543:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106549:	77 4b                	ja     80106596 <inituvm+0x5f>
    panic("inituvm: more than a page");
  mem = kalloc();
8010654b:	e8 bc bb ff ff       	call   8010210c <kalloc>
80106550:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106552:	83 ec 04             	sub    $0x4,%esp
80106555:	68 00 10 00 00       	push   $0x1000
8010655a:	6a 00                	push   $0x0
8010655c:	50                   	push   %eax
8010655d:	e8 c9 d9 ff ff       	call   80103f2b <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106562:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106569:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010656f:	50                   	push   %eax
80106570:	68 00 10 00 00       	push   $0x1000
80106575:	6a 00                	push   $0x0
80106577:	ff 75 08             	pushl  0x8(%ebp)
8010657a:	e8 13 fe ff ff       	call   80106392 <mappages>
  memmove(mem, init, sz);
8010657f:	83 c4 1c             	add    $0x1c,%esp
80106582:	56                   	push   %esi
80106583:	ff 75 0c             	pushl  0xc(%ebp)
80106586:	53                   	push   %ebx
80106587:	e8 1d da ff ff       	call   80103fa9 <memmove>
}
8010658c:	83 c4 10             	add    $0x10,%esp
8010658f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106592:	5b                   	pop    %ebx
80106593:	5e                   	pop    %esi
80106594:	5d                   	pop    %ebp
80106595:	c3                   	ret    
    panic("inituvm: more than a page");
80106596:	83 ec 0c             	sub    $0xc,%esp
80106599:	68 81 74 10 80       	push   $0x80107481
8010659e:	e8 b2 9d ff ff       	call   80100355 <panic>

801065a3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801065a3:	f3 0f 1e fb          	endbr32 
801065a7:	55                   	push   %ebp
801065a8:	89 e5                	mov    %esp,%ebp
801065aa:	57                   	push   %edi
801065ab:	56                   	push   %esi
801065ac:	53                   	push   %ebx
801065ad:	83 ec 0c             	sub    $0xc,%esp
801065b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801065b3:	89 fb                	mov    %edi,%ebx
801065b5:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801065bb:	74 3c                	je     801065f9 <loaduvm+0x56>
    panic("loaduvm: addr must be page aligned");
801065bd:	83 ec 0c             	sub    $0xc,%esp
801065c0:	68 08 75 10 80       	push   $0x80107508
801065c5:	e8 8b 9d ff ff       	call   80100355 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801065ca:	83 ec 0c             	sub    $0xc,%esp
801065cd:	68 9b 74 10 80       	push   $0x8010749b
801065d2:	e8 7e 9d ff ff       	call   80100355 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801065d7:	05 00 00 00 80       	add    $0x80000000,%eax
801065dc:	56                   	push   %esi
801065dd:	89 da                	mov    %ebx,%edx
801065df:	03 55 14             	add    0x14(%ebp),%edx
801065e2:	52                   	push   %edx
801065e3:	50                   	push   %eax
801065e4:	ff 75 10             	pushl  0x10(%ebp)
801065e7:	e8 ab b1 ff ff       	call   80101797 <readi>
801065ec:	83 c4 10             	add    $0x10,%esp
801065ef:	39 f0                	cmp    %esi,%eax
801065f1:	75 47                	jne    8010663a <loaduvm+0x97>
  for(i = 0; i < sz; i += PGSIZE){
801065f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065f9:	3b 5d 18             	cmp    0x18(%ebp),%ebx
801065fc:	73 2f                	jae    8010662d <loaduvm+0x8a>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801065fe:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80106601:	b9 00 00 00 00       	mov    $0x0,%ecx
80106606:	8b 45 08             	mov    0x8(%ebp),%eax
80106609:	e8 9a fb ff ff       	call   801061a8 <walkpgdir>
8010660e:	85 c0                	test   %eax,%eax
80106610:	74 b8                	je     801065ca <loaduvm+0x27>
    pa = PTE_ADDR(*pte);
80106612:	8b 00                	mov    (%eax),%eax
80106614:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106619:	8b 75 18             	mov    0x18(%ebp),%esi
8010661c:	29 de                	sub    %ebx,%esi
8010661e:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106624:	76 b1                	jbe    801065d7 <loaduvm+0x34>
      n = PGSIZE;
80106626:	be 00 10 00 00       	mov    $0x1000,%esi
8010662b:	eb aa                	jmp    801065d7 <loaduvm+0x34>
      return -1;
  }
  return 0;
8010662d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106632:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106635:	5b                   	pop    %ebx
80106636:	5e                   	pop    %esi
80106637:	5f                   	pop    %edi
80106638:	5d                   	pop    %ebp
80106639:	c3                   	ret    
      return -1;
8010663a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663f:	eb f1                	jmp    80106632 <loaduvm+0x8f>

80106641 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106641:	f3 0f 1e fb          	endbr32 
80106645:	55                   	push   %ebp
80106646:	89 e5                	mov    %esp,%ebp
80106648:	57                   	push   %edi
80106649:	56                   	push   %esi
8010664a:	53                   	push   %ebx
8010664b:	83 ec 0c             	sub    $0xc,%esp
8010664e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106651:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106654:	73 11                	jae    80106667 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
80106656:	8b 45 10             	mov    0x10(%ebp),%eax
80106659:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010665f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106665:	eb 17                	jmp    8010667e <deallocuvm+0x3d>
    return oldsz;
80106667:	89 f8                	mov    %edi,%eax
80106669:	eb 62                	jmp    801066cd <deallocuvm+0x8c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010666b:	c1 eb 16             	shr    $0x16,%ebx
8010666e:	43                   	inc    %ebx
8010666f:	c1 e3 16             	shl    $0x16,%ebx
80106672:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106678:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010667e:	39 fb                	cmp    %edi,%ebx
80106680:	73 48                	jae    801066ca <deallocuvm+0x89>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106682:	b9 00 00 00 00       	mov    $0x0,%ecx
80106687:	89 da                	mov    %ebx,%edx
80106689:	8b 45 08             	mov    0x8(%ebp),%eax
8010668c:	e8 17 fb ff ff       	call   801061a8 <walkpgdir>
80106691:	89 c6                	mov    %eax,%esi
    if(!pte)
80106693:	85 c0                	test   %eax,%eax
80106695:	74 d4                	je     8010666b <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
80106697:	8b 00                	mov    (%eax),%eax
80106699:	a8 01                	test   $0x1,%al
8010669b:	74 db                	je     80106678 <deallocuvm+0x37>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010669d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066a2:	74 19                	je     801066bd <deallocuvm+0x7c>
        panic("kfree");
      char *v = P2V(pa);
801066a4:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801066a9:	83 ec 0c             	sub    $0xc,%esp
801066ac:	50                   	push   %eax
801066ad:	e8 33 b9 ff ff       	call   80101fe5 <kfree>
      *pte = 0;
801066b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801066b8:	83 c4 10             	add    $0x10,%esp
801066bb:	eb bb                	jmp    80106678 <deallocuvm+0x37>
        panic("kfree");
801066bd:	83 ec 0c             	sub    $0xc,%esp
801066c0:	68 06 6d 10 80       	push   $0x80106d06
801066c5:	e8 8b 9c ff ff       	call   80100355 <panic>
    }
  }
  return newsz;
801066ca:	8b 45 10             	mov    0x10(%ebp),%eax
}
801066cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066d0:	5b                   	pop    %ebx
801066d1:	5e                   	pop    %esi
801066d2:	5f                   	pop    %edi
801066d3:	5d                   	pop    %ebp
801066d4:	c3                   	ret    

801066d5 <allocuvm>:
{
801066d5:	f3 0f 1e fb          	endbr32 
801066d9:	55                   	push   %ebp
801066da:	89 e5                	mov    %esp,%ebp
801066dc:	57                   	push   %edi
801066dd:	56                   	push   %esi
801066de:	53                   	push   %ebx
801066df:	83 ec 1c             	sub    $0x1c,%esp
801066e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801066e5:	8b 45 10             	mov    0x10(%ebp),%eax
801066e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066eb:	85 c0                	test   %eax,%eax
801066ed:	0f 88 c0 00 00 00    	js     801067b3 <allocuvm+0xde>
  if(newsz < oldsz)
801066f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801066f6:	39 45 10             	cmp    %eax,0x10(%ebp)
801066f9:	72 11                	jb     8010670c <allocuvm+0x37>
  a = PGROUNDUP(oldsz);
801066fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801066fe:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106704:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
8010670a:	eb 36                	jmp    80106742 <allocuvm+0x6d>
    return oldsz;
8010670c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010670f:	e9 a6 00 00 00       	jmp    801067ba <allocuvm+0xe5>
      cprintf("allocuvm out of memory\n");
80106714:	83 ec 0c             	sub    $0xc,%esp
80106717:	68 b9 74 10 80       	push   $0x801074b9
8010671c:	e8 dc 9e ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106721:	83 c4 0c             	add    $0xc,%esp
80106724:	ff 75 0c             	pushl  0xc(%ebp)
80106727:	ff 75 10             	pushl  0x10(%ebp)
8010672a:	57                   	push   %edi
8010672b:	e8 11 ff ff ff       	call   80106641 <deallocuvm>
      return 0;
80106730:	83 c4 10             	add    $0x10,%esp
80106733:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010673a:	eb 7e                	jmp    801067ba <allocuvm+0xe5>
  for(; a < newsz; a += PGSIZE){
8010673c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106742:	3b 75 10             	cmp    0x10(%ebp),%esi
80106745:	73 73                	jae    801067ba <allocuvm+0xe5>
    mem = kalloc();
80106747:	e8 c0 b9 ff ff       	call   8010210c <kalloc>
8010674c:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010674e:	85 c0                	test   %eax,%eax
80106750:	74 c2                	je     80106714 <allocuvm+0x3f>
    memset(mem, 0, PGSIZE);
80106752:	83 ec 04             	sub    $0x4,%esp
80106755:	68 00 10 00 00       	push   $0x1000
8010675a:	6a 00                	push   $0x0
8010675c:	50                   	push   %eax
8010675d:	e8 c9 d7 ff ff       	call   80103f2b <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106762:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106769:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010676f:	50                   	push   %eax
80106770:	68 00 10 00 00       	push   $0x1000
80106775:	56                   	push   %esi
80106776:	57                   	push   %edi
80106777:	e8 16 fc ff ff       	call   80106392 <mappages>
8010677c:	83 c4 20             	add    $0x20,%esp
8010677f:	85 c0                	test   %eax,%eax
80106781:	79 b9                	jns    8010673c <allocuvm+0x67>
      cprintf("allocuvm out of memory (2)\n");
80106783:	83 ec 0c             	sub    $0xc,%esp
80106786:	68 d1 74 10 80       	push   $0x801074d1
8010678b:	e8 6d 9e ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106790:	83 c4 0c             	add    $0xc,%esp
80106793:	ff 75 0c             	pushl  0xc(%ebp)
80106796:	ff 75 10             	pushl  0x10(%ebp)
80106799:	57                   	push   %edi
8010679a:	e8 a2 fe ff ff       	call   80106641 <deallocuvm>
      kfree(mem);
8010679f:	89 1c 24             	mov    %ebx,(%esp)
801067a2:	e8 3e b8 ff ff       	call   80101fe5 <kfree>
      return 0;
801067a7:	83 c4 10             	add    $0x10,%esp
801067aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801067b1:	eb 07                	jmp    801067ba <allocuvm+0xe5>
    return 0;
801067b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801067ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067c0:	5b                   	pop    %ebx
801067c1:	5e                   	pop    %esi
801067c2:	5f                   	pop    %edi
801067c3:	5d                   	pop    %ebp
801067c4:	c3                   	ret    

801067c5 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
801067c5:	f3 0f 1e fb          	endbr32 
801067c9:	55                   	push   %ebp
801067ca:	89 e5                	mov    %esp,%ebp
801067cc:	56                   	push   %esi
801067cd:	53                   	push   %ebx
801067ce:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801067d1:	85 f6                	test   %esi,%esi
801067d3:	74 0d                	je     801067e2 <freevm+0x1d>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
801067d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801067d9:	75 14                	jne    801067ef <freevm+0x2a>
{
801067db:	bb 00 00 00 00       	mov    $0x0,%ebx
801067e0:	eb 39                	jmp    8010681b <freevm+0x56>
    panic("freevm: no pgdir");
801067e2:	83 ec 0c             	sub    $0xc,%esp
801067e5:	68 ed 74 10 80       	push   $0x801074ed
801067ea:	e8 66 9b ff ff       	call   80100355 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801067ef:	83 ec 04             	sub    $0x4,%esp
801067f2:	6a 00                	push   $0x0
801067f4:	68 00 00 00 80       	push   $0x80000000
801067f9:	56                   	push   %esi
801067fa:	e8 42 fe ff ff       	call   80106641 <deallocuvm>
801067ff:	83 c4 10             	add    $0x10,%esp
80106802:	eb d7                	jmp    801067db <freevm+0x16>
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106804:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106809:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010680e:	83 ec 0c             	sub    $0xc,%esp
80106811:	50                   	push   %eax
80106812:	e8 ce b7 ff ff       	call   80101fe5 <kfree>
80106817:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010681a:	43                   	inc    %ebx
8010681b:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
80106821:	77 09                	ja     8010682c <freevm+0x67>
    if(pgdir[i] & PTE_P){
80106823:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106826:	a8 01                	test   $0x1,%al
80106828:	74 f0                	je     8010681a <freevm+0x55>
8010682a:	eb d8                	jmp    80106804 <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
8010682c:	83 ec 0c             	sub    $0xc,%esp
8010682f:	56                   	push   %esi
80106830:	e8 b0 b7 ff ff       	call   80101fe5 <kfree>
}
80106835:	83 c4 10             	add    $0x10,%esp
80106838:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010683b:	5b                   	pop    %ebx
8010683c:	5e                   	pop    %esi
8010683d:	5d                   	pop    %ebp
8010683e:	c3                   	ret    

8010683f <setupkvm>:
{
8010683f:	f3 0f 1e fb          	endbr32 
80106843:	55                   	push   %ebp
80106844:	89 e5                	mov    %esp,%ebp
80106846:	56                   	push   %esi
80106847:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106848:	e8 bf b8 ff ff       	call   8010210c <kalloc>
8010684d:	89 c6                	mov    %eax,%esi
8010684f:	85 c0                	test   %eax,%eax
80106851:	74 57                	je     801068aa <setupkvm+0x6b>
  memset(pgdir, 0, PGSIZE);
80106853:	83 ec 04             	sub    $0x4,%esp
80106856:	68 00 10 00 00       	push   $0x1000
8010685b:	6a 00                	push   $0x0
8010685d:	50                   	push   %eax
8010685e:	e8 c8 d6 ff ff       	call   80103f2b <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106863:	83 c4 10             	add    $0x10,%esp
80106866:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
8010686b:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106871:	73 37                	jae    801068aa <setupkvm+0x6b>
                (uint)k->phys_start, k->perm) < 0) {
80106873:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106876:	83 ec 0c             	sub    $0xc,%esp
80106879:	ff 73 0c             	pushl  0xc(%ebx)
8010687c:	50                   	push   %eax
8010687d:	8b 53 08             	mov    0x8(%ebx),%edx
80106880:	29 c2                	sub    %eax,%edx
80106882:	52                   	push   %edx
80106883:	ff 33                	pushl  (%ebx)
80106885:	56                   	push   %esi
80106886:	e8 07 fb ff ff       	call   80106392 <mappages>
8010688b:	83 c4 20             	add    $0x20,%esp
8010688e:	85 c0                	test   %eax,%eax
80106890:	78 05                	js     80106897 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106892:	83 c3 10             	add    $0x10,%ebx
80106895:	eb d4                	jmp    8010686b <setupkvm+0x2c>
      freevm(pgdir, 0);
80106897:	83 ec 08             	sub    $0x8,%esp
8010689a:	6a 00                	push   $0x0
8010689c:	56                   	push   %esi
8010689d:	e8 23 ff ff ff       	call   801067c5 <freevm>
      return 0;
801068a2:	83 c4 10             	add    $0x10,%esp
801068a5:	be 00 00 00 00       	mov    $0x0,%esi
}
801068aa:	89 f0                	mov    %esi,%eax
801068ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068af:	5b                   	pop    %ebx
801068b0:	5e                   	pop    %esi
801068b1:	5d                   	pop    %ebp
801068b2:	c3                   	ret    

801068b3 <kvmalloc>:
{
801068b3:	f3 0f 1e fb          	endbr32 
801068b7:	55                   	push   %ebp
801068b8:	89 e5                	mov    %esp,%ebp
801068ba:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801068bd:	e8 7d ff ff ff       	call   8010683f <setupkvm>
801068c2:	a3 04 59 11 80       	mov    %eax,0x80115904
  switchkvm();
801068c7:	e8 40 fb ff ff       	call   8010640c <switchkvm>
}
801068cc:	c9                   	leave  
801068cd:	c3                   	ret    

801068ce <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801068ce:	f3 0f 1e fb          	endbr32 
801068d2:	55                   	push   %ebp
801068d3:	89 e5                	mov    %esp,%ebp
801068d5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801068d8:	b9 00 00 00 00       	mov    $0x0,%ecx
801068dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801068e0:	8b 45 08             	mov    0x8(%ebp),%eax
801068e3:	e8 c0 f8 ff ff       	call   801061a8 <walkpgdir>
  if(pte == 0)
801068e8:	85 c0                	test   %eax,%eax
801068ea:	74 05                	je     801068f1 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801068ec:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801068ef:	c9                   	leave  
801068f0:	c3                   	ret    
    panic("clearpteu");
801068f1:	83 ec 0c             	sub    $0xc,%esp
801068f4:	68 fe 74 10 80       	push   $0x801074fe
801068f9:	e8 57 9a ff ff       	call   80100355 <panic>

801068fe <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801068fe:	f3 0f 1e fb          	endbr32 
80106902:	55                   	push   %ebp
80106903:	89 e5                	mov    %esp,%ebp
80106905:	57                   	push   %edi
80106906:	56                   	push   %esi
80106907:	53                   	push   %ebx
80106908:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010690b:	e8 2f ff ff ff       	call   8010683f <setupkvm>
80106910:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106913:	85 c0                	test   %eax,%eax
80106915:	0f 84 a9 00 00 00    	je     801069c4 <copyuvm+0xc6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010691b:	be 00 00 00 00       	mov    $0x0,%esi
80106920:	eb 06                	jmp    80106928 <copyuvm+0x2a>
80106922:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106928:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010692b:	0f 83 93 00 00 00    	jae    801069c4 <copyuvm+0xc6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106931:	b9 00 00 00 00       	mov    $0x0,%ecx
80106936:	89 f2                	mov    %esi,%edx
80106938:	8b 45 08             	mov    0x8(%ebp),%eax
8010693b:	e8 68 f8 ff ff       	call   801061a8 <walkpgdir>
80106940:	85 c0                	test   %eax,%eax
80106942:	74 de                	je     80106922 <copyuvm+0x24>
      continue;
      //panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106944:	8b 00                	mov    (%eax),%eax
80106946:	a8 01                	test   $0x1,%al
80106948:	74 d8                	je     80106922 <copyuvm+0x24>
      continue;
      //panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010694a:	89 c2                	mov    %eax,%edx
8010694c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106952:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106955:	25 ff 0f 00 00       	and    $0xfff,%eax
8010695a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
8010695d:	e8 aa b7 ff ff       	call   8010210c <kalloc>
80106962:	89 c7                	mov    %eax,%edi
80106964:	85 c0                	test   %eax,%eax
80106966:	74 45                	je     801069ad <copyuvm+0xaf>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010696b:	05 00 00 00 80       	add    $0x80000000,%eax
80106970:	83 ec 04             	sub    $0x4,%esp
80106973:	68 00 10 00 00       	push   $0x1000
80106978:	50                   	push   %eax
80106979:	57                   	push   %edi
8010697a:	e8 2a d6 ff ff       	call   80103fa9 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010697f:	83 c4 04             	add    $0x4,%esp
80106982:	ff 75 e0             	pushl  -0x20(%ebp)
80106985:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010698b:	50                   	push   %eax
8010698c:	68 00 10 00 00       	push   $0x1000
80106991:	56                   	push   %esi
80106992:	ff 75 dc             	pushl  -0x24(%ebp)
80106995:	e8 f8 f9 ff ff       	call   80106392 <mappages>
8010699a:	83 c4 20             	add    $0x20,%esp
8010699d:	85 c0                	test   %eax,%eax
8010699f:	79 81                	jns    80106922 <copyuvm+0x24>
      kfree(mem);
801069a1:	83 ec 0c             	sub    $0xc,%esp
801069a4:	57                   	push   %edi
801069a5:	e8 3b b6 ff ff       	call   80101fe5 <kfree>
      goto bad;
801069aa:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
801069ad:	83 ec 08             	sub    $0x8,%esp
801069b0:	6a 01                	push   $0x1
801069b2:	ff 75 dc             	pushl  -0x24(%ebp)
801069b5:	e8 0b fe ff ff       	call   801067c5 <freevm>
  return 0;
801069ba:	83 c4 10             	add    $0x10,%esp
801069bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801069c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801069c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069ca:	5b                   	pop    %ebx
801069cb:	5e                   	pop    %esi
801069cc:	5f                   	pop    %edi
801069cd:	5d                   	pop    %ebp
801069ce:	c3                   	ret    

801069cf <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801069cf:	f3 0f 1e fb          	endbr32 
801069d3:	55                   	push   %ebp
801069d4:	89 e5                	mov    %esp,%ebp
801069d6:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801069d9:	b9 00 00 00 00       	mov    $0x0,%ecx
801069de:	8b 55 0c             	mov    0xc(%ebp),%edx
801069e1:	8b 45 08             	mov    0x8(%ebp),%eax
801069e4:	e8 bf f7 ff ff       	call   801061a8 <walkpgdir>
  if((*pte & PTE_P) == 0)
801069e9:	8b 00                	mov    (%eax),%eax
801069eb:	a8 01                	test   $0x1,%al
801069ed:	74 10                	je     801069ff <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
801069ef:	a8 04                	test   $0x4,%al
801069f1:	74 13                	je     80106a06 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801069f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069f8:	05 00 00 00 80       	add    $0x80000000,%eax
}
801069fd:	c9                   	leave  
801069fe:	c3                   	ret    
    return 0;
801069ff:	b8 00 00 00 00       	mov    $0x0,%eax
80106a04:	eb f7                	jmp    801069fd <uva2ka+0x2e>
    return 0;
80106a06:	b8 00 00 00 00       	mov    $0x0,%eax
80106a0b:	eb f0                	jmp    801069fd <uva2ka+0x2e>

80106a0d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106a0d:	f3 0f 1e fb          	endbr32 
80106a11:	55                   	push   %ebp
80106a12:	89 e5                	mov    %esp,%ebp
80106a14:	57                   	push   %edi
80106a15:	56                   	push   %esi
80106a16:	53                   	push   %ebx
80106a17:	83 ec 0c             	sub    $0xc,%esp
80106a1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106a1d:	eb 25                	jmp    80106a44 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a22:	29 f2                	sub    %esi,%edx
80106a24:	01 d0                	add    %edx,%eax
80106a26:	83 ec 04             	sub    $0x4,%esp
80106a29:	53                   	push   %ebx
80106a2a:	ff 75 10             	pushl  0x10(%ebp)
80106a2d:	50                   	push   %eax
80106a2e:	e8 76 d5 ff ff       	call   80103fa9 <memmove>
    len -= n;
80106a33:	29 df                	sub    %ebx,%edi
    buf += n;
80106a35:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106a38:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106a3e:	89 45 0c             	mov    %eax,0xc(%ebp)
80106a41:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106a44:	85 ff                	test   %edi,%edi
80106a46:	74 2f                	je     80106a77 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
80106a48:	8b 75 0c             	mov    0xc(%ebp),%esi
80106a4b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106a51:	83 ec 08             	sub    $0x8,%esp
80106a54:	56                   	push   %esi
80106a55:	ff 75 08             	pushl  0x8(%ebp)
80106a58:	e8 72 ff ff ff       	call   801069cf <uva2ka>
    if(pa0 == 0)
80106a5d:	83 c4 10             	add    $0x10,%esp
80106a60:	85 c0                	test   %eax,%eax
80106a62:	74 20                	je     80106a84 <copyout+0x77>
    n = PGSIZE - (va - va0);
80106a64:	89 f3                	mov    %esi,%ebx
80106a66:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106a69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106a6f:	39 df                	cmp    %ebx,%edi
80106a71:	73 ac                	jae    80106a1f <copyout+0x12>
      n = len;
80106a73:	89 fb                	mov    %edi,%ebx
80106a75:	eb a8                	jmp    80106a1f <copyout+0x12>
  }
  return 0;
80106a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7f:	5b                   	pop    %ebx
80106a80:	5e                   	pop    %esi
80106a81:	5f                   	pop    %edi
80106a82:	5d                   	pop    %ebp
80106a83:	c3                   	ret    
      return -1;
80106a84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a89:	eb f1                	jmp    80106a7c <copyout+0x6f>
