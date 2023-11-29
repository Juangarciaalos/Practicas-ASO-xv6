
kernel:     file format elf32-i386


Disassembly of section .text:

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
80100028:	bc 30 58 11 80       	mov    $0x80115830,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 92 29 10 80       	mov    $0x80102992,%eax
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
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 79 3c 00 00       	call   80103cc4 <acquire>

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
8010007a:	e8 aa 3c 00 00       	call   80103d29 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 2b 3a 00 00       	call   80103ab5 <acquiresleep>
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
801000c8:	e8 5c 3c 00 00       	call   80103d29 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 dd 39 00 00       	call   80103ab5 <acquiresleep>
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
801000e8:	68 60 69 10 80       	push   $0x80106960
801000ed:	e8 4f 02 00 00       	call   80100341 <panic>

801000f2 <binit>:
{
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000f9:	68 71 69 10 80       	push   $0x80106971
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 85 3a 00 00       	call   80103b8d <initlock>
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
80100138:	68 78 69 10 80       	push   $0x80106978
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 3c 39 00 00       	call   80103a82 <initsleeplock>
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
801001a6:	e8 94 39 00 00       	call   80103b3f <holdingsleep>
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
801001c9:	68 7f 69 10 80       	push   $0x8010697f
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
801001e2:	e8 58 39 00 00       	call   80103b3f <holdingsleep>
801001e7:	83 c4 10             	add    $0x10,%esp
801001ea:	85 c0                	test   %eax,%eax
801001ec:	74 69                	je     80100257 <brelse+0x84>
    panic("brelse");

  releasesleep(&b->lock);
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 0d 39 00 00       	call   80103b04 <releasesleep>

  acquire(&bcache.lock);
801001f7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001fe:	e8 c1 3a 00 00       	call   80103cc4 <acquire>
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
80100248:	e8 dc 3a 00 00       	call   80103d29 <release>
}
8010024d:	83 c4 10             	add    $0x10,%esp
80100250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100253:	5b                   	pop    %ebx
80100254:	5e                   	pop    %esi
80100255:	5d                   	pop    %ebp
80100256:	c3                   	ret    
    panic("brelse");
80100257:	83 ec 0c             	sub    $0xc,%esp
8010025a:	68 86 69 10 80       	push   $0x80106986
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
80100286:	e8 39 3a 00 00       	call   80103cc4 <acquire>
  while(n > 0){
8010028b:	83 c4 10             	add    $0x10,%esp
8010028e:	85 db                	test   %ebx,%ebx
80100290:	0f 8e 8c 00 00 00    	jle    80100322 <consoleread+0xbe>
    while(input.r == input.w){
80100296:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a1:	75 47                	jne    801002ea <consoleread+0x86>
      if(myproc()->killed){
801002a3:	e8 5b 2e 00 00       	call   80103103 <myproc>
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
801002bb:	e8 df 34 00 00       	call   8010379f <sleep>
801002c0:	83 c4 10             	add    $0x10,%esp
801002c3:	eb d1                	jmp    80100296 <consoleread+0x32>
        release(&cons.lock);
801002c5:	83 ec 0c             	sub    $0xc,%esp
801002c8:	68 20 ef 10 80       	push   $0x8010ef20
801002cd:	e8 57 3a 00 00       	call   80103d29 <release>
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
8010032a:	e8 fa 39 00 00       	call   80103d29 <release>
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
8010035c:	68 8d 69 10 80       	push   $0x8010698d
80100361:	e8 74 02 00 00       	call   801005da <cprintf>
  cprintf(s);
80100366:	83 c4 04             	add    $0x4,%esp
80100369:	ff 75 08             	push   0x8(%ebp)
8010036c:	e8 69 02 00 00       	call   801005da <cprintf>
  cprintf("\n");
80100371:	c7 04 24 5f 73 10 80 	movl   $0x8010735f,(%esp)
80100378:	e8 5d 02 00 00       	call   801005da <cprintf>
  getcallerpcs(&s, pcs);
8010037d:	83 c4 08             	add    $0x8,%esp
80100380:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100383:	50                   	push   %eax
80100384:	8d 45 08             	lea    0x8(%ebp),%eax
80100387:	50                   	push   %eax
80100388:	e8 1b 38 00 00       	call   80103ba8 <getcallerpcs>
  for(i=0; i<10; i++)
8010038d:	83 c4 10             	add    $0x10,%esp
80100390:	bb 00 00 00 00       	mov    $0x0,%ebx
80100395:	eb 15                	jmp    801003ac <panic+0x6b>
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
8010039e:	68 a1 69 10 80       	push   $0x801069a1
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
8010046c:	68 a5 69 10 80       	push   $0x801069a5
80100471:	e8 cb fe ff ff       	call   80100341 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100476:	83 ec 04             	sub    $0x4,%esp
80100479:	68 60 0e 00 00       	push   $0xe60
8010047e:	68 a0 80 0b 80       	push   $0x800b80a0
80100483:	68 00 80 0b 80       	push   $0x800b8000
80100488:	e8 59 39 00 00       	call   80103de6 <memmove>
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
801004a7:	e8 c4 38 00 00       	call   80103d70 <memset>
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
801004d4:	e8 c0 4e 00 00       	call   80105399 <uartputc>
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
801004ed:	e8 a7 4e 00 00       	call   80105399 <uartputc>
801004f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f9:	e8 9b 4e 00 00       	call   80105399 <uartputc>
801004fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100505:	e8 8f 4e 00 00       	call   80105399 <uartputc>
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
80100540:	8a 92 d0 69 10 80    	mov    -0x7fef9630(%edx),%dl
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
8010059b:	e8 24 37 00 00       	call   80103cc4 <acquire>
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
801005c0:	e8 64 37 00 00       	call   80103d29 <release>
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
80100607:	e8 b8 36 00 00       	call   80103cc4 <acquire>
8010060c:	83 c4 10             	add    $0x10,%esp
8010060f:	eb de                	jmp    801005ef <cprintf+0x15>
    panic("null fmt");
80100611:	83 ec 0c             	sub    $0xc,%esp
80100614:	68 bf 69 10 80       	push   $0x801069bf
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
8010069c:	bb b8 69 10 80       	mov    $0x801069b8,%ebx
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
801006f5:	e8 2f 36 00 00       	call   80103d29 <release>
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
80100710:	e8 af 35 00 00       	call   80103cc4 <acquire>
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
801007b8:	e8 67 31 00 00       	call   80103924 <wakeup>
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
80100831:	e8 f3 34 00 00       	call   80103d29 <release>
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
80100845:	e8 85 31 00 00       	call   801039cf <procdump>
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
80100852:	68 c8 69 10 80       	push   $0x801069c8
80100857:	68 20 ef 10 80       	push   $0x8010ef20
8010085c:	e8 2c 33 00 00       	call   80103b8d <initlock>

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
8010089c:	e8 62 28 00 00       	call   80103103 <myproc>
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
8010091c:	68 e1 69 10 80       	push   $0x801069e1
80100921:	e8 b4 fc ff ff       	call   801005da <cprintf>
    return -1;
80100926:	83 c4 10             	add    $0x10,%esp
80100929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010092e:	eb dc                	jmp    8010090c <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
80100930:	e8 d4 5d 00 00       	call   80106709 <setupkvm>
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
801009c6:	e8 db 5b 00 00       	call   801065a6 <allocuvm>
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
801009fc:	e8 7b 5a 00 00       	call   8010647c <loaduvm>
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
80100a3e:	e8 63 5b 00 00       	call   801065a6 <allocuvm>
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
80100a6b:	e8 23 5c 00 00       	call   80106693 <freevm>
80100a70:	83 c4 10             	add    $0x10,%esp
80100a73:	e9 76 fe ff ff       	jmp    801008ee <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100a78:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a7e:	83 ec 08             	sub    $0x8,%esp
80100a81:	50                   	push   %eax
80100a82:	57                   	push   %edi
80100a83:	e8 08 5d 00 00       	call   80106790 <clearpteu>
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
80100ab3:	e8 48 34 00 00       	call   80103f00 <strlen>
80100ab8:	29 c6                	sub    %eax,%esi
80100aba:	4e                   	dec    %esi
80100abb:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100abe:	83 c4 04             	add    $0x4,%esp
80100ac1:	ff 33                	push   (%ebx)
80100ac3:	e8 38 34 00 00       	call   80103f00 <strlen>
80100ac8:	40                   	inc    %eax
80100ac9:	50                   	push   %eax
80100aca:	ff 33                	push   (%ebx)
80100acc:	56                   	push   %esi
80100acd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ad3:	e8 08 5e 00 00       	call   801068e0 <copyout>
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
80100b33:	e8 a8 5d 00 00       	call   801068e0 <copyout>
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
80100b6d:	e8 56 33 00 00       	call   80103ec8 <safestrcpy>
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
80100b9b:	e8 18 57 00 00       	call   801062b8 <switchuvm>
  freevm(oldpgdir, 1);
80100ba0:	83 c4 08             	add    $0x8,%esp
80100ba3:	6a 01                	push   $0x1
80100ba5:	53                   	push   %ebx
80100ba6:	e8 e8 5a 00 00       	call   80106693 <freevm>
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
80100bd2:	68 ed 69 10 80       	push   $0x801069ed
80100bd7:	68 60 ef 10 80       	push   $0x8010ef60
80100bdc:	e8 ac 2f 00 00       	call   80103b8d <initlock>
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
80100bf2:	e8 cd 30 00 00       	call   80103cc4 <acquire>
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
80100c21:	e8 03 31 00 00       	call   80103d29 <release>
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
80100c38:	e8 ec 30 00 00       	call   80103d29 <release>
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
80100c56:	e8 69 30 00 00       	call   80103cc4 <acquire>
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
80100c71:	e8 b3 30 00 00       	call   80103d29 <release>
  return f;
}
80100c76:	89 d8                	mov    %ebx,%eax
80100c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c7b:	c9                   	leave  
80100c7c:	c3                   	ret    
    panic("filedup");
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	68 f4 69 10 80       	push   $0x801069f4
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
80100c9b:	e8 24 30 00 00       	call   80103cc4 <acquire>
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
80100cd3:	e8 51 30 00 00       	call   80103d29 <release>

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
80100d05:	68 fc 69 10 80       	push   $0x801069fc
80100d0a:	e8 32 f6 ff ff       	call   80100341 <panic>
    release(&ftable.lock);
80100d0f:	83 ec 0c             	sub    $0xc,%esp
80100d12:	68 60 ef 10 80       	push   $0x8010ef60
80100d17:	e8 0d 30 00 00       	call   80103d29 <release>
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
80100d32:	e8 06 20 00 00       	call   80102d3d <pipeclose>
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
80100de8:	e8 9e 20 00 00       	call   80102e8b <piperead>
80100ded:	89 c6                	mov    %eax,%esi
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	eb df                	jmp    80100dd3 <fileread+0x50>
  panic("fileread");
80100df4:	83 ec 0c             	sub    $0xc,%esp
80100df7:	68 06 6a 10 80       	push   $0x80106a06
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
80100e41:	e8 83 1f 00 00       	call   80102dc9 <pipewrite>
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
80100ebc:	68 0f 6a 10 80       	push   $0x80106a0f
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
80100ee0:	68 15 6a 10 80       	push   $0x80106a15
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
80100f2a:	e8 b7 2e 00 00       	call   80103de6 <memmove>
80100f2f:	83 c4 10             	add    $0x10,%esp
80100f32:	eb 15                	jmp    80100f49 <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	57                   	push   %edi
80100f38:	50                   	push   %eax
80100f39:	56                   	push   %esi
80100f3a:	e8 a7 2e 00 00       	call   80103de6 <memmove>
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
80100f7d:	e8 ee 2d 00 00       	call   80103d70 <memset>
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
8010103b:	68 1f 6a 10 80       	push   $0x80106a1f
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
80101110:	68 35 6a 10 80       	push   $0x80106a35
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
8010112d:	e8 92 2b 00 00       	call   80103cc4 <acquire>
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
80101172:	e8 b2 2b 00 00       	call   80103d29 <release>
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
801011a8:	e8 7c 2b 00 00       	call   80103d29 <release>
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
801011bd:	68 48 6a 10 80       	push   $0x80106a48
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
801011e6:	e8 fb 2b 00 00       	call   80103de6 <memmove>
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
80101274:	68 58 6a 10 80       	push   $0x80106a58
80101279:	e8 c3 f0 ff ff       	call   80100341 <panic>

8010127e <iinit>:
{
8010127e:	55                   	push   %ebp
8010127f:	89 e5                	mov    %esp,%ebp
80101281:	53                   	push   %ebx
80101282:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101285:	68 6b 6a 10 80       	push   $0x80106a6b
8010128a:	68 60 f9 10 80       	push   $0x8010f960
8010128f:	e8 f9 28 00 00       	call   80103b8d <initlock>
  for(i = 0; i < NINODE; i++) {
80101294:	83 c4 10             	add    $0x10,%esp
80101297:	bb 00 00 00 00       	mov    $0x0,%ebx
8010129c:	eb 1f                	jmp    801012bd <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
8010129e:	83 ec 08             	sub    $0x8,%esp
801012a1:	68 72 6a 10 80       	push   $0x80106a72
801012a6:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
801012a9:	89 d0                	mov    %edx,%eax
801012ab:	c1 e0 04             	shl    $0x4,%eax
801012ae:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
801012b3:	50                   	push   %eax
801012b4:	e8 c9 27 00 00       	call   80103a82 <initsleeplock>
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
801012fc:	68 d8 6a 10 80       	push   $0x80106ad8
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
8010136d:	68 78 6a 10 80       	push   $0x80106a78
80101372:	e8 ca ef ff ff       	call   80100341 <panic>
      memset(dip, 0, sizeof(*dip));
80101377:	83 ec 04             	sub    $0x4,%esp
8010137a:	6a 40                	push   $0x40
8010137c:	6a 00                	push   $0x0
8010137e:	57                   	push   %edi
8010137f:	e8 ec 29 00 00       	call   80103d70 <memset>
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
8010140b:	e8 d6 29 00 00       	call   80103de6 <memmove>
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
801014e7:	e8 d8 27 00 00       	call   80103cc4 <acquire>
  ip->ref++;
801014ec:	8b 43 08             	mov    0x8(%ebx),%eax
801014ef:	40                   	inc    %eax
801014f0:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801014f3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801014fa:	e8 2a 28 00 00       	call   80103d29 <release>
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
8010151f:	e8 91 25 00 00       	call   80103ab5 <acquiresleep>
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
80101537:	68 8a 6a 10 80       	push   $0x80106a8a
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
80101597:	e8 4a 28 00 00       	call   80103de6 <memmove>
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
801015bc:	68 90 6a 10 80       	push   $0x80106a90
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
801015d9:	e8 61 25 00 00       	call   80103b3f <holdingsleep>
801015de:	83 c4 10             	add    $0x10,%esp
801015e1:	85 c0                	test   %eax,%eax
801015e3:	74 19                	je     801015fe <iunlock+0x38>
801015e5:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015e9:	7e 13                	jle    801015fe <iunlock+0x38>
  releasesleep(&ip->lock);
801015eb:	83 ec 0c             	sub    $0xc,%esp
801015ee:	56                   	push   %esi
801015ef:	e8 10 25 00 00       	call   80103b04 <releasesleep>
}
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015fa:	5b                   	pop    %ebx
801015fb:	5e                   	pop    %esi
801015fc:	5d                   	pop    %ebp
801015fd:	c3                   	ret    
    panic("iunlock");
801015fe:	83 ec 0c             	sub    $0xc,%esp
80101601:	68 9f 6a 10 80       	push   $0x80106a9f
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
8010161b:	e8 95 24 00 00       	call   80103ab5 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101620:	83 c4 10             	add    $0x10,%esp
80101623:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101627:	74 07                	je     80101630 <iput+0x25>
80101629:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010162e:	74 33                	je     80101663 <iput+0x58>
  releasesleep(&ip->lock);
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	56                   	push   %esi
80101634:	e8 cb 24 00 00       	call   80103b04 <releasesleep>
  acquire(&icache.lock);
80101639:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101640:	e8 7f 26 00 00       	call   80103cc4 <acquire>
  ip->ref--;
80101645:	8b 43 08             	mov    0x8(%ebx),%eax
80101648:	48                   	dec    %eax
80101649:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010164c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101653:	e8 d1 26 00 00       	call   80103d29 <release>
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
8010166b:	e8 54 26 00 00       	call   80103cc4 <acquire>
    int r = ip->ref;
80101670:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101673:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010167a:	e8 aa 26 00 00       	call   80103d29 <release>
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
8010176f:	e8 72 26 00 00       	call   80103de6 <memmove>
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
80101872:	e8 6f 25 00 00       	call   80103de6 <memmove>
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
80101935:	e8 12 25 00 00       	call   80103e4c <strncmp>
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
8010195c:	68 a7 6a 10 80       	push   $0x80106aa7
80101961:	e8 db e9 ff ff       	call   80100341 <panic>
      panic("dirlookup read");
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	68 b9 6a 10 80       	push   $0x80106ab9
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
801019e6:	e8 18 17 00 00       	call   80103103 <myproc>
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
80101b1b:	68 c8 6a 10 80       	push   $0x80106ac8
80101b20:	e8 1c e8 ff ff       	call   80100341 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b25:	83 ec 04             	sub    $0x4,%esp
80101b28:	6a 0e                	push   $0xe
80101b2a:	57                   	push   %edi
80101b2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b2e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b31:	50                   	push   %eax
80101b32:	e8 4d 23 00 00       	call   80103e84 <strncpy>
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
80101b60:	68 e0 70 10 80       	push   $0x801070e0
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
80101c58:	68 2b 6b 10 80       	push   $0x80106b2b
80101c5d:	e8 df e6 ff ff       	call   80100341 <panic>
    panic("incorrect blockno");
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	68 34 6b 10 80       	push   $0x80106b34
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
80101c7f:	68 46 6b 10 80       	push   $0x80106b46
80101c84:	68 00 16 11 80       	push   $0x80111600
80101c89:	e8 ff 1e 00 00       	call   80103b8d <initlock>
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
80101cef:	e8 d0 1f 00 00       	call   80103cc4 <acquire>

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
80101d1e:	e8 01 1c 00 00       	call   80103924 <wakeup>

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
80101d3c:	e8 e8 1f 00 00       	call   80103d29 <release>
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
80101d53:	e8 d1 1f 00 00       	call   80103d29 <release>
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
80101d8b:	e8 af 1d 00 00       	call   80103b3f <holdingsleep>
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
80101db8:	e8 07 1f 00 00       	call   80103cc4 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101dbd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101dcc:	eb 2a                	jmp    80101df8 <iderw+0x7b>
    panic("iderw: buf not locked");
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	68 4a 6b 10 80       	push   $0x80106b4a
80101dd6:	e8 66 e5 ff ff       	call   80100341 <panic>
    panic("iderw: nothing to do");
80101ddb:	83 ec 0c             	sub    $0xc,%esp
80101dde:	68 60 6b 10 80       	push   $0x80106b60
80101de3:	e8 59 e5 ff ff       	call   80100341 <panic>
    panic("iderw: ide disk 1 not present");
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	68 75 6b 10 80       	push   $0x80106b75
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
80101e1a:	e8 80 19 00 00       	call   8010379f <sleep>
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
80101e34:	e8 f0 1e 00 00       	call   80103d29 <release>
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
80101ea8:	68 94 6b 10 80       	push   $0x80106b94
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
80101f22:	81 fb 30 58 11 80    	cmp    $0x80115830,%ebx
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
80101f42:	e8 29 1e 00 00       	call   80103d70 <memset>

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
80101f71:	68 c6 6b 10 80       	push   $0x80106bc6
80101f76:	e8 c6 e3 ff ff       	call   80100341 <panic>
    acquire(&kmem.lock);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
80101f7e:	68 40 16 11 80       	push   $0x80111640
80101f83:	e8 3c 1d 00 00       	call   80103cc4 <acquire>
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	eb c6                	jmp    80101f53 <kfree+0x43>
    release(&kmem.lock);
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 40 16 11 80       	push   $0x80111640
80101f95:	e8 8f 1d 00 00       	call   80103d29 <release>
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
80101fdb:	68 cc 6b 10 80       	push   $0x80106bcc
80101fe0:	68 40 16 11 80       	push   $0x80111640
80101fe5:	e8 a3 1b 00 00       	call   80103b8d <initlock>
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
80102060:	e8 5f 1c 00 00       	call   80103cc4 <acquire>
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	eb cd                	jmp    80102037 <kalloc+0x10>
    release(&kmem.lock);
8010206a:	83 ec 0c             	sub    $0xc,%esp
8010206d:	68 40 16 11 80       	push   $0x80111640
80102072:	e8 b2 1c 00 00       	call   80103d29 <release>
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
801020b5:	0f b6 91 00 6d 10 80 	movzbl -0x7fef9300(%ecx),%edx
801020bc:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
801020c2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
801020c8:	0f b6 81 00 6c 10 80 	movzbl -0x7fef9400(%ecx),%eax
801020cf:	31 c2                	xor    %eax,%edx
801020d1:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801020d7:	89 d0                	mov    %edx,%eax
801020d9:	83 e0 03             	and    $0x3,%eax
801020dc:	8b 04 85 e0 6b 10 80 	mov    -0x7fef9420(,%eax,4),%eax
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
80102115:	8a 81 00 6d 10 80    	mov    -0x7fef9300(%ecx),%al
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
801023f3:	e8 bf 19 00 00       	call   80103db7 <memcmp>
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
80102539:	e8 a8 18 00 00       	call   80103de6 <memmove>
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
80102632:	e8 af 17 00 00       	call   80103de6 <memmove>
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
8010269d:	68 00 6e 10 80       	push   $0x80106e00
801026a2:	68 a0 16 11 80       	push   $0x801116a0
801026a7:	e8 e1 14 00 00       	call   80103b8d <initlock>
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
801026e7:	e8 d8 15 00 00       	call   80103cc4 <acquire>
801026ec:	83 c4 10             	add    $0x10,%esp
801026ef:	eb 15                	jmp    80102706 <begin_op+0x2a>
      sleep(&log, &log.lock);
801026f1:	83 ec 08             	sub    $0x8,%esp
801026f4:	68 a0 16 11 80       	push   $0x801116a0
801026f9:	68 a0 16 11 80       	push   $0x801116a0
801026fe:	e8 9c 10 00 00       	call   8010379f <sleep>
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
80102736:	e8 64 10 00 00       	call   8010379f <sleep>
8010273b:	83 c4 10             	add    $0x10,%esp
8010273e:	eb c6                	jmp    80102706 <begin_op+0x2a>
      log.outstanding += 1;
80102740:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
      release(&log.lock);
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	68 a0 16 11 80       	push   $0x801116a0
8010274e:	e8 d6 15 00 00       	call   80103d29 <release>
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
80102764:	e8 5b 15 00 00       	call   80103cc4 <acquire>
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
8010279c:	e8 88 15 00 00       	call   80103d29 <release>
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
801027b0:	68 04 6e 10 80       	push   $0x80106e04
801027b5:	e8 87 db ff ff       	call   80100341 <panic>
    wakeup(&log);
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	68 a0 16 11 80       	push   $0x801116a0
801027c2:	e8 5d 11 00 00       	call   80103924 <wakeup>
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	eb c8                	jmp    80102794 <end_op+0x3c>
    commit();
801027cc:	e8 92 fe ff ff       	call   80102663 <commit>
    acquire(&log.lock);
801027d1:	83 ec 0c             	sub    $0xc,%esp
801027d4:	68 a0 16 11 80       	push   $0x801116a0
801027d9:	e8 e6 14 00 00       	call   80103cc4 <acquire>
    log.committing = 0;
801027de:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
801027e5:	00 00 00 
    wakeup(&log);
801027e8:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027ef:	e8 30 11 00 00       	call   80103924 <wakeup>
    release(&log.lock);
801027f4:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801027fb:	e8 29 15 00 00       	call   80103d29 <release>
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
80102835:	e8 8a 14 00 00       	call   80103cc4 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010283a:	83 c4 10             	add    $0x10,%esp
8010283d:	b8 00 00 00 00       	mov    $0x0,%eax
80102842:	eb 1b                	jmp    8010285f <log_write+0x5a>
    panic("too big a transaction");
80102844:	83 ec 0c             	sub    $0xc,%esp
80102847:	68 13 6e 10 80       	push   $0x80106e13
8010284c:	e8 f0 da ff ff       	call   80100341 <panic>
    panic("log_write outside of trans");
80102851:	83 ec 0c             	sub    $0xc,%esp
80102854:	68 29 6e 10 80       	push   $0x80106e29
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
8010288e:	e8 96 14 00 00       	call   80103d29 <release>
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
801028ba:	e8 27 15 00 00       	call   80103de6 <memmove>

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
801028e8:	e8 81 07 00 00       	call   8010306e <mycpu>
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
80102940:	e8 8d 07 00 00       	call   801030d2 <cpuid>
80102945:	89 c3                	mov    %eax,%ebx
80102947:	e8 86 07 00 00       	call   801030d2 <cpuid>
8010294c:	83 ec 04             	sub    $0x4,%esp
8010294f:	53                   	push   %ebx
80102950:	50                   	push   %eax
80102951:	68 44 6e 10 80       	push   $0x80106e44
80102956:	e8 7f dc ff ff       	call   801005da <cprintf>
  idtinit();       // load idt register
8010295b:	e8 d6 26 00 00       	call   80105036 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102960:	e8 09 07 00 00       	call   8010306e <mycpu>
80102965:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102967:	b8 01 00 00 00       	mov    $0x1,%eax
8010296c:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102973:	e8 d1 0b 00 00       	call   80103549 <scheduler>

80102978 <mpenter>:
{
80102978:	55                   	push   %ebp
80102979:	89 e5                	mov    %esp,%ebp
8010297b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010297e:	e8 27 39 00 00       	call   801062aa <switchkvm>
  seginit();
80102983:	e8 dc 35 00 00       	call   80105f64 <seginit>
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
801029a8:	68 30 58 11 80       	push   $0x80115830
801029ad:	e8 23 f6 ff ff       	call   80101fd5 <kinit1>
  kvmalloc();      // kernel page table
801029b2:	e8 c2 3d 00 00       	call   80106779 <kvmalloc>
  mpinit();        // detect other processors
801029b7:	e8 b8 01 00 00       	call   80102b74 <mpinit>
  lapicinit();     // interrupt controller
801029bc:	e8 16 f8 ff ff       	call   801021d7 <lapicinit>
  seginit();       // segment descriptors
801029c1:	e8 9e 35 00 00       	call   80105f64 <seginit>
  picinit();       // disable pic
801029c6:	e8 79 02 00 00       	call   80102c44 <picinit>
  ioapicinit();    // another interrupt controller
801029cb:	e8 93 f4 ff ff       	call   80101e63 <ioapicinit>
  consoleinit();   // console hardware
801029d0:	e8 77 de ff ff       	call   8010084c <consoleinit>
  uartinit();      // serial port
801029d5:	e8 02 2a 00 00       	call   801053dc <uartinit>
  pinit();         // process table
801029da:	e8 75 06 00 00       	call   80103054 <pinit>
  tvinit();        // trap vectors
801029df:	e8 55 25 00 00       	call   80104f39 <tvinit>
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
80102a0a:	e8 6d 08 00 00       	call   8010327c <userinit>
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
80102a53:	68 58 6e 10 80       	push   $0x80106e58
80102a58:	53                   	push   %ebx
80102a59:	e8 59 13 00 00       	call   80103db7 <memcmp>
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
80102b16:	68 5d 6e 10 80       	push   $0x80106e5d
80102b1b:	57                   	push   %edi
80102b1c:	e8 96 12 00 00       	call   80103db7 <memcmp>
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
80102ba5:	68 62 6e 10 80       	push   $0x80106e62
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
80102c3a:	68 7c 6e 10 80       	push   $0x80106e7c
80102c3f:	e8 fd d6 ff ff       	call   80100341 <panic>

80102c44 <picinit>:
80102c44:	b0 ff                	mov    $0xff,%al
80102c46:	ba 21 00 00 00       	mov    $0x21,%edx
80102c4b:	ee                   	out    %al,(%dx)
80102c4c:	ba a1 00 00 00       	mov    $0xa1,%edx
80102c51:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102c52:	c3                   	ret    

80102c53 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102c53:	55                   	push   %ebp
80102c54:	89 e5                	mov    %esp,%ebp
80102c56:	57                   	push   %edi
80102c57:	56                   	push   %esi
80102c58:	53                   	push   %ebx
80102c59:	83 ec 0c             	sub    $0xc,%esp
80102c5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102c62:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102c68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102c6e:	e8 73 df ff ff       	call   80100be6 <filealloc>
80102c73:	89 03                	mov    %eax,(%ebx)
80102c75:	85 c0                	test   %eax,%eax
80102c77:	0f 84 88 00 00 00    	je     80102d05 <pipealloc+0xb2>
80102c7d:	e8 64 df ff ff       	call   80100be6 <filealloc>
80102c82:	89 06                	mov    %eax,(%esi)
80102c84:	85 c0                	test   %eax,%eax
80102c86:	74 7d                	je     80102d05 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102c88:	e8 9a f3 ff ff       	call   80102027 <kalloc>
80102c8d:	89 c7                	mov    %eax,%edi
80102c8f:	85 c0                	test   %eax,%eax
80102c91:	74 72                	je     80102d05 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102c93:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102c9a:	00 00 00 
  p->writeopen = 1;
80102c9d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102ca4:	00 00 00 
  p->nwrite = 0;
80102ca7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102cae:	00 00 00 
  p->nread = 0;
80102cb1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102cb8:	00 00 00 
  initlock(&p->lock, "pipe");
80102cbb:	83 ec 08             	sub    $0x8,%esp
80102cbe:	68 9b 6e 10 80       	push   $0x80106e9b
80102cc3:	50                   	push   %eax
80102cc4:	e8 c4 0e 00 00       	call   80103b8d <initlock>
  (*f0)->type = FD_PIPE;
80102cc9:	8b 03                	mov    (%ebx),%eax
80102ccb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102cd1:	8b 03                	mov    (%ebx),%eax
80102cd3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102cd7:	8b 03                	mov    (%ebx),%eax
80102cd9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102cdd:	8b 03                	mov    (%ebx),%eax
80102cdf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ce2:	8b 06                	mov    (%esi),%eax
80102ce4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102cea:	8b 06                	mov    (%esi),%eax
80102cec:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102cf0:	8b 06                	mov    (%esi),%eax
80102cf2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102cf6:	8b 06                	mov    (%esi),%eax
80102cf8:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102cfb:	83 c4 10             	add    $0x10,%esp
80102cfe:	b8 00 00 00 00       	mov    $0x0,%eax
80102d03:	eb 29                	jmp    80102d2e <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102d05:	8b 03                	mov    (%ebx),%eax
80102d07:	85 c0                	test   %eax,%eax
80102d09:	74 0c                	je     80102d17 <pipealloc+0xc4>
    fileclose(*f0);
80102d0b:	83 ec 0c             	sub    $0xc,%esp
80102d0e:	50                   	push   %eax
80102d0f:	e8 76 df ff ff       	call   80100c8a <fileclose>
80102d14:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102d17:	8b 06                	mov    (%esi),%eax
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	74 19                	je     80102d36 <pipealloc+0xe3>
    fileclose(*f1);
80102d1d:	83 ec 0c             	sub    $0xc,%esp
80102d20:	50                   	push   %eax
80102d21:	e8 64 df ff ff       	call   80100c8a <fileclose>
80102d26:	83 c4 10             	add    $0x10,%esp
  return -1;
80102d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d31:	5b                   	pop    %ebx
80102d32:	5e                   	pop    %esi
80102d33:	5f                   	pop    %edi
80102d34:	5d                   	pop    %ebp
80102d35:	c3                   	ret    
  return -1;
80102d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d3b:	eb f1                	jmp    80102d2e <pipealloc+0xdb>

80102d3d <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102d3d:	55                   	push   %ebp
80102d3e:	89 e5                	mov    %esp,%ebp
80102d40:	53                   	push   %ebx
80102d41:	83 ec 10             	sub    $0x10,%esp
80102d44:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102d47:	53                   	push   %ebx
80102d48:	e8 77 0f 00 00       	call   80103cc4 <acquire>
  if(writable){
80102d4d:	83 c4 10             	add    $0x10,%esp
80102d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102d54:	74 3f                	je     80102d95 <pipeclose+0x58>
    p->writeopen = 0;
80102d56:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102d5d:	00 00 00 
    wakeup(&p->nread);
80102d60:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	50                   	push   %eax
80102d6a:	e8 b5 0b 00 00       	call   80103924 <wakeup>
80102d6f:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102d72:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102d79:	75 09                	jne    80102d84 <pipeclose+0x47>
80102d7b:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102d82:	74 2f                	je     80102db3 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102d84:	83 ec 0c             	sub    $0xc,%esp
80102d87:	53                   	push   %ebx
80102d88:	e8 9c 0f 00 00       	call   80103d29 <release>
80102d8d:	83 c4 10             	add    $0x10,%esp
}
80102d90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d93:	c9                   	leave  
80102d94:	c3                   	ret    
    p->readopen = 0;
80102d95:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102d9c:	00 00 00 
    wakeup(&p->nwrite);
80102d9f:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102da5:	83 ec 0c             	sub    $0xc,%esp
80102da8:	50                   	push   %eax
80102da9:	e8 76 0b 00 00       	call   80103924 <wakeup>
80102dae:	83 c4 10             	add    $0x10,%esp
80102db1:	eb bf                	jmp    80102d72 <pipeclose+0x35>
    release(&p->lock);
80102db3:	83 ec 0c             	sub    $0xc,%esp
80102db6:	53                   	push   %ebx
80102db7:	e8 6d 0f 00 00       	call   80103d29 <release>
    kfree((char*)p);
80102dbc:	89 1c 24             	mov    %ebx,(%esp)
80102dbf:	e8 4c f1 ff ff       	call   80101f10 <kfree>
80102dc4:	83 c4 10             	add    $0x10,%esp
80102dc7:	eb c7                	jmp    80102d90 <pipeclose+0x53>

80102dc9 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102dc9:	55                   	push   %ebp
80102dca:	89 e5                	mov    %esp,%ebp
80102dcc:	56                   	push   %esi
80102dcd:	53                   	push   %ebx
80102dce:	83 ec 1c             	sub    $0x1c,%esp
80102dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102dd4:	53                   	push   %ebx
80102dd5:	e8 ea 0e 00 00       	call   80103cc4 <acquire>
  for(i = 0; i < n; i++){
80102dda:	83 c4 10             	add    $0x10,%esp
80102ddd:	be 00 00 00 00       	mov    $0x0,%esi
80102de2:	3b 75 10             	cmp    0x10(%ebp),%esi
80102de5:	7c 41                	jl     80102e28 <pipewrite+0x5f>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102de7:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	50                   	push   %eax
80102df1:	e8 2e 0b 00 00       	call   80103924 <wakeup>
  release(&p->lock);
80102df6:	89 1c 24             	mov    %ebx,(%esp)
80102df9:	e8 2b 0f 00 00       	call   80103d29 <release>
  return n;
80102dfe:	83 c4 10             	add    $0x10,%esp
80102e01:	8b 45 10             	mov    0x10(%ebp),%eax
80102e04:	eb 5c                	jmp    80102e62 <pipewrite+0x99>
      wakeup(&p->nread);
80102e06:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e0c:	83 ec 0c             	sub    $0xc,%esp
80102e0f:	50                   	push   %eax
80102e10:	e8 0f 0b 00 00       	call   80103924 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102e15:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e1b:	83 c4 08             	add    $0x8,%esp
80102e1e:	53                   	push   %ebx
80102e1f:	50                   	push   %eax
80102e20:	e8 7a 09 00 00       	call   8010379f <sleep>
80102e25:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102e28:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102e2e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102e34:	05 00 02 00 00       	add    $0x200,%eax
80102e39:	39 c2                	cmp    %eax,%edx
80102e3b:	75 2c                	jne    80102e69 <pipewrite+0xa0>
      if(p->readopen == 0 || myproc()->killed){
80102e3d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e44:	74 0b                	je     80102e51 <pipewrite+0x88>
80102e46:	e8 b8 02 00 00       	call   80103103 <myproc>
80102e4b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102e4f:	74 b5                	je     80102e06 <pipewrite+0x3d>
        release(&p->lock);
80102e51:	83 ec 0c             	sub    $0xc,%esp
80102e54:	53                   	push   %ebx
80102e55:	e8 cf 0e 00 00       	call   80103d29 <release>
        return -1;
80102e5a:	83 c4 10             	add    $0x10,%esp
80102e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e65:	5b                   	pop    %ebx
80102e66:	5e                   	pop    %esi
80102e67:	5d                   	pop    %ebp
80102e68:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102e69:	8d 42 01             	lea    0x1(%edx),%eax
80102e6c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102e72:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e7b:	8a 04 30             	mov    (%eax,%esi,1),%al
80102e7e:	88 45 f7             	mov    %al,-0x9(%ebp)
80102e81:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102e85:	46                   	inc    %esi
80102e86:	e9 57 ff ff ff       	jmp    80102de2 <pipewrite+0x19>

80102e8b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102e8b:	55                   	push   %ebp
80102e8c:	89 e5                	mov    %esp,%ebp
80102e8e:	57                   	push   %edi
80102e8f:	56                   	push   %esi
80102e90:	53                   	push   %ebx
80102e91:	83 ec 18             	sub    $0x18,%esp
80102e94:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e97:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80102e9a:	53                   	push   %ebx
80102e9b:	e8 24 0e 00 00       	call   80103cc4 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	eb 13                	jmp    80102eb8 <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102ea5:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102eab:	83 ec 08             	sub    $0x8,%esp
80102eae:	53                   	push   %ebx
80102eaf:	50                   	push   %eax
80102eb0:	e8 ea 08 00 00       	call   8010379f <sleep>
80102eb5:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102eb8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102ebe:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102ec4:	75 75                	jne    80102f3b <piperead+0xb0>
80102ec6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102ecc:	85 f6                	test   %esi,%esi
80102ece:	74 34                	je     80102f04 <piperead+0x79>
    if(myproc()->killed){
80102ed0:	e8 2e 02 00 00       	call   80103103 <myproc>
80102ed5:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102ed9:	74 ca                	je     80102ea5 <piperead+0x1a>
      release(&p->lock);
80102edb:	83 ec 0c             	sub    $0xc,%esp
80102ede:	53                   	push   %ebx
80102edf:	e8 45 0e 00 00       	call   80103d29 <release>
      return -1;
80102ee4:	83 c4 10             	add    $0x10,%esp
80102ee7:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102eec:	eb 43                	jmp    80102f31 <piperead+0xa6>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102eee:	8d 50 01             	lea    0x1(%eax),%edx
80102ef1:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102ef7:	25 ff 01 00 00       	and    $0x1ff,%eax
80102efc:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80102f00:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102f03:	46                   	inc    %esi
80102f04:	3b 75 10             	cmp    0x10(%ebp),%esi
80102f07:	7d 0e                	jge    80102f17 <piperead+0x8c>
    if(p->nread == p->nwrite)
80102f09:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f0f:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102f15:	75 d7                	jne    80102eee <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102f17:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	50                   	push   %eax
80102f21:	e8 fe 09 00 00       	call   80103924 <wakeup>
  release(&p->lock);
80102f26:	89 1c 24             	mov    %ebx,(%esp)
80102f29:	e8 fb 0d 00 00       	call   80103d29 <release>
  return i;
80102f2e:	83 c4 10             	add    $0x10,%esp
}
80102f31:	89 f0                	mov    %esi,%eax
80102f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f36:	5b                   	pop    %ebx
80102f37:	5e                   	pop    %esi
80102f38:	5f                   	pop    %edi
80102f39:	5d                   	pop    %ebp
80102f3a:	c3                   	ret    
80102f3b:	be 00 00 00 00       	mov    $0x0,%esi
80102f40:	eb c2                	jmp    80102f04 <piperead+0x79>

80102f42 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80102f42:	55                   	push   %ebp
80102f43:	89 e5                	mov    %esp,%ebp
80102f45:	53                   	push   %ebx
80102f46:	83 ec 10             	sub    $0x10,%esp
  //ptable no solo contiene la tabla de procesos, es un struct que tiene un lock y la propia tabla
  struct proc *p;
  char *sp;

  acquire(&ptable.lock); //Cerrojo para exclusion mutua
80102f49:	68 20 1d 11 80       	push   $0x80111d20
80102f4e:	e8 71 0d 00 00       	call   80103cc4 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) //Busca el primer proceso(PID) libre
80102f53:	83 c4 10             	add    $0x10,%esp
80102f56:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80102f5b:	eb 06                	jmp    80102f63 <allocproc+0x21>
80102f5d:	81 c3 88 00 00 00    	add    $0x88,%ebx
80102f63:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80102f69:	0f 83 80 00 00 00    	jae    80102fef <allocproc+0xad>
    if(p->state == UNUSED)
80102f6f:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80102f73:	75 e8                	jne    80102f5d <allocproc+0x1b>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO; //Pone el estado del nuevo proceso en embrion
80102f75:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++; //nextpid almacena el último PID usado
80102f7c:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80102f81:	8d 50 01             	lea    0x1(%eax),%edx
80102f84:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80102f8a:	89 43 10             	mov    %eax,0x10(%ebx)
  p->prio_level = 5; // Asigna prioridad 5 al nuevo proceso
80102f8d:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
80102f94:	00 00 00 

  release(&ptable.lock);
80102f97:	83 ec 0c             	sub    $0xc,%esp
80102f9a:	68 20 1d 11 80       	push   $0x80111d20
80102f9f:	e8 85 0d 00 00       	call   80103d29 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){ //Busca una pagina libre en el kernel
80102fa4:	e8 7e f0 ff ff       	call   80102027 <kalloc>
80102fa9:	89 43 08             	mov    %eax,0x8(%ebx)
80102fac:	83 c4 10             	add    $0x10,%esp
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	74 53                	je     80103006 <allocproc+0xc4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE; //Final de la pagina del kernel

  // Leave room for trap frame.
  sp -= sizeof *p->tf; //puntero para el trap frame
80102fb3:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp; //Guarda el puntero en tf
80102fb9:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret; //Trapret es la llamada para vaciar le trapframe
80102fbc:	c7 80 b0 0f 00 00 2e 	movl   $0x80104f2e,0xfb0(%eax)
80102fc3:	4f 10 80 

  sp -= sizeof *p->context; //Puntero para el contexto(para movernos dentro de los hilos del kernel)
80102fc6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80102fcb:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80102fce:	83 ec 04             	sub    $0x4,%esp
80102fd1:	6a 14                	push   $0x14
80102fd3:	6a 00                	push   $0x0
80102fd5:	50                   	push   %eax
80102fd6:	e8 95 0d 00 00       	call   80103d70 <memset>
  p->context->eip = (uint)forkret;
80102fdb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80102fde:	c7 40 10 11 30 10 80 	movl   $0x80103011,0x10(%eax)

  return p;
80102fe5:	83 c4 10             	add    $0x10,%esp
}
80102fe8:	89 d8                	mov    %ebx,%eax
80102fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fed:	c9                   	leave  
80102fee:	c3                   	ret    
  release(&ptable.lock);
80102fef:	83 ec 0c             	sub    $0xc,%esp
80102ff2:	68 20 1d 11 80       	push   $0x80111d20
80102ff7:	e8 2d 0d 00 00       	call   80103d29 <release>
  return 0;
80102ffc:	83 c4 10             	add    $0x10,%esp
80102fff:	bb 00 00 00 00       	mov    $0x0,%ebx
80103004:	eb e2                	jmp    80102fe8 <allocproc+0xa6>
    p->state = UNUSED;
80103006:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010300d:	89 c3                	mov    %eax,%ebx
8010300f:	eb d7                	jmp    80102fe8 <allocproc+0xa6>

80103011 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103011:	55                   	push   %ebp
80103012:	89 e5                	mov    %esp,%ebp
80103014:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103017:	68 20 1d 11 80       	push   $0x80111d20
8010301c:	e8 08 0d 00 00       	call   80103d29 <release>

  if (first) {
80103021:	83 c4 10             	add    $0x10,%esp
80103024:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010302b:	75 02                	jne    8010302f <forkret+0x1e>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010302d:	c9                   	leave  
8010302e:	c3                   	ret    
    first = 0;
8010302f:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103036:	00 00 00 
    iinit(ROOTDEV);
80103039:	83 ec 0c             	sub    $0xc,%esp
8010303c:	6a 01                	push   $0x1
8010303e:	e8 3b e2 ff ff       	call   8010127e <iinit>
    initlog(ROOTDEV);
80103043:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010304a:	e8 44 f6 ff ff       	call   80102693 <initlog>
8010304f:	83 c4 10             	add    $0x10,%esp
}
80103052:	eb d9                	jmp    8010302d <forkret+0x1c>

80103054 <pinit>:
{
80103054:	55                   	push   %ebp
80103055:	89 e5                	mov    %esp,%ebp
80103057:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010305a:	68 a0 6e 10 80       	push   $0x80106ea0
8010305f:	68 20 1d 11 80       	push   $0x80111d20
80103064:	e8 24 0b 00 00       	call   80103b8d <initlock>
}
80103069:	83 c4 10             	add    $0x10,%esp
8010306c:	c9                   	leave  
8010306d:	c3                   	ret    

8010306e <mycpu>:
{
8010306e:	55                   	push   %ebp
8010306f:	89 e5                	mov    %esp,%ebp
80103071:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103074:	9c                   	pushf  
80103075:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103076:	f6 c4 02             	test   $0x2,%ah
80103079:	75 2c                	jne    801030a7 <mycpu+0x39>
  apicid = lapicid();
8010307b:	e8 63 f2 ff ff       	call   801022e3 <lapicid>
80103080:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
80103082:	ba 00 00 00 00       	mov    $0x0,%edx
80103087:	39 15 84 17 11 80    	cmp    %edx,0x80111784
8010308d:	7e 25                	jle    801030b4 <mycpu+0x46>
    if (cpus[i].apicid == apicid)
8010308f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103092:	01 c0                	add    %eax,%eax
80103094:	01 d0                	add    %edx,%eax
80103096:	c1 e0 04             	shl    $0x4,%eax
80103099:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
801030a0:	39 c8                	cmp    %ecx,%eax
801030a2:	74 1d                	je     801030c1 <mycpu+0x53>
  for (i = 0; i < ncpu; ++i) {
801030a4:	42                   	inc    %edx
801030a5:	eb e0                	jmp    80103087 <mycpu+0x19>
    panic("mycpu called with interrupts enabled\n");
801030a7:	83 ec 0c             	sub    $0xc,%esp
801030aa:	68 94 6f 10 80       	push   $0x80106f94
801030af:	e8 8d d2 ff ff       	call   80100341 <panic>
  panic("unknown apicid\n");
801030b4:	83 ec 0c             	sub    $0xc,%esp
801030b7:	68 a7 6e 10 80       	push   $0x80106ea7
801030bc:	e8 80 d2 ff ff       	call   80100341 <panic>
      return &cpus[i];
801030c1:	8d 04 92             	lea    (%edx,%edx,4),%eax
801030c4:	01 c0                	add    %eax,%eax
801030c6:	01 d0                	add    %edx,%eax
801030c8:	c1 e0 04             	shl    $0x4,%eax
801030cb:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801030d0:	c9                   	leave  
801030d1:	c3                   	ret    

801030d2 <cpuid>:
cpuid() {
801030d2:	55                   	push   %ebp
801030d3:	89 e5                	mov    %esp,%ebp
801030d5:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801030d8:	e8 91 ff ff ff       	call   8010306e <mycpu>
801030dd:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801030e2:	c1 f8 04             	sar    $0x4,%eax
801030e5:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
801030e8:	89 ca                	mov    %ecx,%edx
801030ea:	c1 e2 05             	shl    $0x5,%edx
801030ed:	29 ca                	sub    %ecx,%edx
801030ef:	8d 14 90             	lea    (%eax,%edx,4),%edx
801030f2:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
801030f5:	89 ca                	mov    %ecx,%edx
801030f7:	c1 e2 0f             	shl    $0xf,%edx
801030fa:	29 ca                	sub    %ecx,%edx
801030fc:	8d 04 90             	lea    (%eax,%edx,4),%eax
801030ff:	f7 d8                	neg    %eax
}
80103101:	c9                   	leave  
80103102:	c3                   	ret    

80103103 <myproc>:
myproc(void) {
80103103:	55                   	push   %ebp
80103104:	89 e5                	mov    %esp,%ebp
80103106:	53                   	push   %ebx
80103107:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010310a:	e8 db 0a 00 00       	call   80103bea <pushcli>
  c = mycpu();
8010310f:	e8 5a ff ff ff       	call   8010306e <mycpu>
  p = c->proc;
80103114:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010311a:	e8 06 0b 00 00       	call   80103c25 <popcli>
}
8010311f:	89 d8                	mov    %ebx,%eax
80103121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103124:	c9                   	leave  
80103125:	c3                   	ret    

80103126 <remove_beggining>:
{
80103126:	55                   	push   %ebp
80103127:	89 e5                	mov    %esp,%ebp
80103129:	8b 45 08             	mov    0x8(%ebp),%eax
  if (ptable.priority_list[level].first_proc->pid == ptable.priority_list[level].last_proc->pid) { // There was only one process in queue, now is empty
8010312c:	8d 90 46 04 00 00    	lea    0x446(%eax),%edx
80103132:	8b 0c d5 24 1d 11 80 	mov    -0x7feee2dc(,%edx,8),%ecx
80103139:	8b 14 d5 28 1d 11 80 	mov    -0x7feee2d8(,%edx,8),%edx
80103140:	8b 52 10             	mov    0x10(%edx),%edx
80103143:	39 51 10             	cmp    %edx,0x10(%ecx)
80103146:	74 0f                	je     80103157 <remove_beggining+0x31>
    ptable.priority_list[level].first_proc = ptable.priority_list[level].first_proc->next_proc;
80103148:	8b 91 84 00 00 00    	mov    0x84(%ecx),%edx
8010314e:	89 14 c5 54 3f 11 80 	mov    %edx,-0x7feec0ac(,%eax,8)
}
80103155:	5d                   	pop    %ebp
80103156:	c3                   	ret    
    ptable.priority_list[level].first_proc = NULL;
80103157:	05 46 04 00 00       	add    $0x446,%eax
8010315c:	c7 04 c5 24 1d 11 80 	movl   $0x0,-0x7feee2dc(,%eax,8)
80103163:	00 00 00 00 
    ptable.priority_list[level].last_proc  = NULL;
80103167:	c7 04 c5 28 1d 11 80 	movl   $0x0,-0x7feee2d8(,%eax,8)
8010316e:	00 00 00 00 
80103172:	eb e1                	jmp    80103155 <remove_beggining+0x2f>

80103174 <insert_end>:
{
80103174:	55                   	push   %ebp
80103175:	89 e5                	mov    %esp,%ebp
80103177:	8b 55 08             	mov    0x8(%ebp),%edx
  int level = p->prio_level;
8010317a:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  if (ptable.priority_list[level].first_proc == NULL) { //Queue is empty
80103180:	83 3c c5 54 3f 11 80 	cmpl   $0x0,-0x7feec0ac(,%eax,8)
80103187:	00 
80103188:	74 25                	je     801031af <insert_end+0x3b>
    ptable.priority_list[level].last_proc->next_proc = p;
8010318a:	05 46 04 00 00       	add    $0x446,%eax
8010318f:	8b 0c c5 28 1d 11 80 	mov    -0x7feee2d8(,%eax,8),%ecx
80103196:	89 91 84 00 00 00    	mov    %edx,0x84(%ecx)
    p->next_proc = NULL;
8010319c:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801031a3:	00 00 00 
    ptable.priority_list[level].last_proc = p;
801031a6:	89 14 c5 28 1d 11 80 	mov    %edx,-0x7feee2d8(,%eax,8)
}
801031ad:	5d                   	pop    %ebp
801031ae:	c3                   	ret    
    ptable.priority_list[level].first_proc = p;
801031af:	05 46 04 00 00       	add    $0x446,%eax
801031b4:	89 14 c5 24 1d 11 80 	mov    %edx,-0x7feee2dc(,%eax,8)
    ptable.priority_list[level].last_proc = p;
801031bb:	89 14 c5 28 1d 11 80 	mov    %edx,-0x7feee2d8(,%eax,8)
    p->next_proc = NULL;
801031c2:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801031c9:	00 00 00 
801031cc:	eb df                	jmp    801031ad <insert_end+0x39>

801031ce <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801031ce:	55                   	push   %ebp
801031cf:	89 e5                	mov    %esp,%ebp
801031d1:	56                   	push   %esi
801031d2:	53                   	push   %ebx
801031d3:	89 c6                	mov    %eax,%esi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031d5:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801031da:	eb 06                	jmp    801031e2 <wakeup1+0x14>
801031dc:	81 c3 88 00 00 00    	add    $0x88,%ebx
801031e2:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801031e8:	73 20                	jae    8010320a <wakeup1+0x3c>
    if(p->state == SLEEPING && p->chan == chan){
801031ea:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801031ee:	75 ec                	jne    801031dc <wakeup1+0xe>
801031f0:	39 73 20             	cmp    %esi,0x20(%ebx)
801031f3:	75 e7                	jne    801031dc <wakeup1+0xe>
      p->state = RUNNABLE;
801031f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      insert_end(p);
801031fc:	83 ec 0c             	sub    $0xc,%esp
801031ff:	53                   	push   %ebx
80103200:	e8 6f ff ff ff       	call   80103174 <insert_end>
80103205:	83 c4 10             	add    $0x10,%esp
80103208:	eb d2                	jmp    801031dc <wakeup1+0xe>
    }
}
8010320a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010320d:	5b                   	pop    %ebx
8010320e:	5e                   	pop    %esi
8010320f:	5d                   	pop    %ebp
80103210:	c3                   	ret    

80103211 <getprio>:
{
80103211:	55                   	push   %ebp
80103212:	89 e5                	mov    %esp,%ebp
80103214:	8b 55 08             	mov    0x8(%ebp),%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103217:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010321c:	eb 05                	jmp    80103223 <getprio+0x12>
8010321e:	05 88 00 00 00       	add    $0x88,%eax
80103223:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
80103228:	73 0d                	jae    80103237 <getprio+0x26>
    if (p->pid == pid)
8010322a:	39 50 10             	cmp    %edx,0x10(%eax)
8010322d:	75 ef                	jne    8010321e <getprio+0xd>
      return p->prio_level;
8010322f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80103235:	5d                   	pop    %ebp
80103236:	c3                   	ret    
  return -1;
80103237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010323c:	eb f7                	jmp    80103235 <getprio+0x24>

8010323e <setprio>:
{
8010323e:	55                   	push   %ebp
8010323f:	89 e5                	mov    %esp,%ebp
80103241:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103244:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (proc_prio < 0 || proc_prio > 9)
80103247:	83 f8 09             	cmp    $0x9,%eax
8010324a:	77 29                	ja     80103275 <setprio+0x37>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010324c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103251:	81 fa 54 3f 11 80    	cmp    $0x80113f54,%edx
80103257:	73 15                	jae    8010326e <setprio+0x30>
    if (p->pid == pid){
80103259:	39 4a 10             	cmp    %ecx,0x10(%edx)
8010325c:	74 08                	je     80103266 <setprio+0x28>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010325e:	81 c2 88 00 00 00    	add    $0x88,%edx
80103264:	eb eb                	jmp    80103251 <setprio+0x13>
      p->prio_level = proc_prio;
80103266:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
}
8010326c:	5d                   	pop    %ebp
8010326d:	c3                   	ret    
  return -1;
8010326e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103273:	eb f7                	jmp    8010326c <setprio+0x2e>
    return -1;
80103275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010327a:	eb f0                	jmp    8010326c <setprio+0x2e>

8010327c <userinit>:
{
8010327c:	55                   	push   %ebp
8010327d:	89 e5                	mov    %esp,%ebp
8010327f:	53                   	push   %ebx
80103280:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103283:	e8 ba fc ff ff       	call   80102f42 <allocproc>
80103288:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010328a:	a3 a4 3f 11 80       	mov    %eax,0x80113fa4
  if((p->pgdir = setupkvm()) == 0)
8010328f:	e8 75 34 00 00       	call   80106709 <setupkvm>
80103294:	89 43 04             	mov    %eax,0x4(%ebx)
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 84 db 00 00 00    	je     8010337a <userinit+0xfe>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010329f:	83 ec 04             	sub    $0x4,%esp
801032a2:	68 2c 00 00 00       	push   $0x2c
801032a7:	68 60 a4 10 80       	push   $0x8010a460
801032ac:	50                   	push   %eax
801032ad:	e8 62 31 00 00       	call   80106414 <inituvm>
  p->sz = PGSIZE;
801032b2:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801032b8:	8b 43 18             	mov    0x18(%ebx),%eax
801032bb:	83 c4 0c             	add    $0xc,%esp
801032be:	6a 4c                	push   $0x4c
801032c0:	6a 00                	push   $0x0
801032c2:	50                   	push   %eax
801032c3:	e8 a8 0a 00 00       	call   80103d70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801032c8:	8b 43 18             	mov    0x18(%ebx),%eax
801032cb:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801032d1:	8b 43 18             	mov    0x18(%ebx),%eax
801032d4:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801032da:	8b 43 18             	mov    0x18(%ebx),%eax
801032dd:	8b 50 2c             	mov    0x2c(%eax),%edx
801032e0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801032e4:	8b 43 18             	mov    0x18(%ebx),%eax
801032e7:	8b 50 2c             	mov    0x2c(%eax),%edx
801032ea:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801032ee:	8b 43 18             	mov    0x18(%ebx),%eax
801032f1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801032f8:	8b 43 18             	mov    0x18(%ebx),%eax
801032fb:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103302:	8b 43 18             	mov    0x18(%ebx),%eax
80103305:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010330c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010330f:	83 c4 0c             	add    $0xc,%esp
80103312:	6a 10                	push   $0x10
80103314:	68 d0 6e 10 80       	push   $0x80106ed0
80103319:	50                   	push   %eax
8010331a:	e8 a9 0b 00 00       	call   80103ec8 <safestrcpy>
  p->cwd = namei("/");
8010331f:	c7 04 24 d9 6e 10 80 	movl   $0x80106ed9,(%esp)
80103326:	e8 3f e8 ff ff       	call   80101b6a <namei>
8010332b:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010332e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103335:	e8 8a 09 00 00       	call   80103cc4 <acquire>
  p->state = RUNNABLE;
8010333a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  insert_end(p);
80103341:	89 1c 24             	mov    %ebx,(%esp)
80103344:	e8 2b fe ff ff       	call   80103174 <insert_end>
  if (ptable.priority_list[5].first_proc != NULL)
80103349:	83 c4 10             	add    $0x10,%esp
8010334c:	83 3d 7c 3f 11 80 00 	cmpl   $0x0,0x80113f7c
80103353:	74 10                	je     80103365 <userinit+0xe9>
    cprintf("out of memory?\n");
80103355:	83 ec 0c             	sub    $0xc,%esp
80103358:	68 db 6e 10 80       	push   $0x80106edb
8010335d:	e8 78 d2 ff ff       	call   801005da <cprintf>
80103362:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80103365:	83 ec 0c             	sub    $0xc,%esp
80103368:	68 20 1d 11 80       	push   $0x80111d20
8010336d:	e8 b7 09 00 00       	call   80103d29 <release>
}
80103372:	83 c4 10             	add    $0x10,%esp
80103375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103378:	c9                   	leave  
80103379:	c3                   	ret    
    panic("userinit: out of memory?");
8010337a:	83 ec 0c             	sub    $0xc,%esp
8010337d:	68 b7 6e 10 80       	push   $0x80106eb7
80103382:	e8 ba cf ff ff       	call   80100341 <panic>

80103387 <growproc>:
{
80103387:	55                   	push   %ebp
80103388:	89 e5                	mov    %esp,%ebp
8010338a:	56                   	push   %esi
8010338b:	53                   	push   %ebx
8010338c:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010338f:	e8 6f fd ff ff       	call   80103103 <myproc>
80103394:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103396:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103398:	85 f6                	test   %esi,%esi
8010339a:	7f 1b                	jg     801033b7 <growproc+0x30>
  } else if(n < 0){
8010339c:	78 36                	js     801033d4 <growproc+0x4d>
  curproc->sz = sz;
8010339e:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
801033a0:	8b 43 04             	mov    0x4(%ebx),%eax
801033a3:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801033a8:	0f 22 d8             	mov    %eax,%cr3
  return 0;
801033ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801033b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b3:	5b                   	pop    %ebx
801033b4:	5e                   	pop    %esi
801033b5:	5d                   	pop    %ebp
801033b6:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033b7:	83 ec 04             	sub    $0x4,%esp
801033ba:	01 c6                	add    %eax,%esi
801033bc:	56                   	push   %esi
801033bd:	50                   	push   %eax
801033be:	ff 73 04             	push   0x4(%ebx)
801033c1:	e8 e0 31 00 00       	call   801065a6 <allocuvm>
801033c6:	83 c4 10             	add    $0x10,%esp
801033c9:	85 c0                	test   %eax,%eax
801033cb:	75 d1                	jne    8010339e <growproc+0x17>
      return -1;
801033cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d2:	eb dc                	jmp    801033b0 <growproc+0x29>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033d4:	83 ec 04             	sub    $0x4,%esp
801033d7:	01 c6                	add    %eax,%esi
801033d9:	56                   	push   %esi
801033da:	50                   	push   %eax
801033db:	ff 73 04             	push   0x4(%ebx)
801033de:	e8 33 31 00 00       	call   80106516 <deallocuvm>
801033e3:	83 c4 10             	add    $0x10,%esp
801033e6:	85 c0                	test   %eax,%eax
801033e8:	75 b4                	jne    8010339e <growproc+0x17>
      return -1;
801033ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033ef:	eb bf                	jmp    801033b0 <growproc+0x29>

801033f1 <fork>:
{
801033f1:	55                   	push   %ebp
801033f2:	89 e5                	mov    %esp,%ebp
801033f4:	57                   	push   %edi
801033f5:	56                   	push   %esi
801033f6:	53                   	push   %ebx
801033f7:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801033fa:	e8 04 fd ff ff       	call   80103103 <myproc>
801033ff:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103401:	e8 3c fb ff ff       	call   80102f42 <allocproc>
80103406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103409:	85 c0                	test   %eax,%eax
8010340b:	0f 84 f2 00 00 00    	je     80103503 <fork+0x112>
80103411:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103413:	83 ec 08             	sub    $0x8,%esp
80103416:	ff 33                	push   (%ebx)
80103418:	ff 73 04             	push   0x4(%ebx)
8010341b:	e8 9c 33 00 00       	call   801067bc <copyuvm>
80103420:	89 47 04             	mov    %eax,0x4(%edi)
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	85 c0                	test   %eax,%eax
80103428:	74 2a                	je     80103454 <fork+0x63>
  np->sz = curproc->sz;
8010342a:	8b 03                	mov    (%ebx),%eax
8010342c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010342f:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103431:	89 c8                	mov    %ecx,%eax
80103433:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103436:	8b 73 18             	mov    0x18(%ebx),%esi
80103439:	8b 79 18             	mov    0x18(%ecx),%edi
8010343c:	b9 13 00 00 00       	mov    $0x13,%ecx
80103441:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103443:	8b 40 18             	mov    0x18(%eax),%eax
80103446:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010344d:	be 00 00 00 00       	mov    $0x0,%esi
80103452:	eb 27                	jmp    8010347b <fork+0x8a>
    kfree(np->kstack);
80103454:	83 ec 0c             	sub    $0xc,%esp
80103457:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010345a:	ff 73 08             	push   0x8(%ebx)
8010345d:	e8 ae ea ff ff       	call   80101f10 <kfree>
    np->kstack = 0;
80103462:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103469:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103470:	83 c4 10             	add    $0x10,%esp
80103473:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103478:	eb 7f                	jmp    801034f9 <fork+0x108>
  for(i = 0; i < NOFILE; i++)
8010347a:	46                   	inc    %esi
8010347b:	83 fe 0f             	cmp    $0xf,%esi
8010347e:	7f 1d                	jg     8010349d <fork+0xac>
    if(curproc->ofile[i])
80103480:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103484:	85 c0                	test   %eax,%eax
80103486:	74 f2                	je     8010347a <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103488:	83 ec 0c             	sub    $0xc,%esp
8010348b:	50                   	push   %eax
8010348c:	e8 b6 d7 ff ff       	call   80100c47 <filedup>
80103491:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103494:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103498:	83 c4 10             	add    $0x10,%esp
8010349b:	eb dd                	jmp    8010347a <fork+0x89>
  np->cwd = idup(curproc->cwd);
8010349d:	83 ec 0c             	sub    $0xc,%esp
801034a0:	ff 73 68             	push   0x68(%ebx)
801034a3:	e8 30 e0 ff ff       	call   801014d8 <idup>
801034a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801034ab:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801034ae:	8d 53 6c             	lea    0x6c(%ebx),%edx
801034b1:	8d 47 6c             	lea    0x6c(%edi),%eax
801034b4:	83 c4 0c             	add    $0xc,%esp
801034b7:	6a 10                	push   $0x10
801034b9:	52                   	push   %edx
801034ba:	50                   	push   %eax
801034bb:	e8 08 0a 00 00       	call   80103ec8 <safestrcpy>
  pid = np->pid;
801034c0:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
801034c3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801034ca:	e8 f5 07 00 00       	call   80103cc4 <acquire>
  np->state = RUNNABLE;
801034cf:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->prio_level = curproc->prio_level;
801034d6:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801034dc:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  insert_end(np);
801034e2:	89 3c 24             	mov    %edi,(%esp)
801034e5:	e8 8a fc ff ff       	call   80103174 <insert_end>
  release(&ptable.lock);
801034ea:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801034f1:	e8 33 08 00 00       	call   80103d29 <release>
  return pid;
801034f6:	83 c4 10             	add    $0x10,%esp
}
801034f9:	89 f0                	mov    %esi,%eax
801034fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034fe:	5b                   	pop    %ebx
801034ff:	5e                   	pop    %esi
80103500:	5f                   	pop    %edi
80103501:	5d                   	pop    %ebp
80103502:	c3                   	ret    
    return -1;
80103503:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103508:	eb ef                	jmp    801034f9 <fork+0x108>

8010350a <proc_prio>:
{
8010350a:	55                   	push   %ebp
8010350b:	89 e5                	mov    %esp,%ebp
8010350d:	53                   	push   %ebx
8010350e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for (q = 0; q < PRIO_LEVELS; q++){
80103511:	bb 00 00 00 00       	mov    $0x0,%ebx
80103516:	83 fb 09             	cmp    $0x9,%ebx
80103519:	7f 27                	jg     80103542 <proc_prio+0x38>
    p = ptable.priority_list[q].first_proc;
8010351b:	8b 04 dd 54 3f 11 80 	mov    -0x7feec0ac(,%ebx,8),%eax
    while (p->next_proc != NULL) {
80103522:	89 c2                	mov    %eax,%edx
80103524:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	74 0c                	je     8010353a <proc_prio+0x30>
      if (p->pid == pid) 
8010352e:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103531:	75 ef                	jne    80103522 <proc_prio+0x18>
}
80103533:	89 d8                	mov    %ebx,%eax
80103535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103538:	c9                   	leave  
80103539:	c3                   	ret    
    if (p->pid == pid) 
8010353a:	39 4a 10             	cmp    %ecx,0x10(%edx)
8010353d:	74 f4                	je     80103533 <proc_prio+0x29>
  for (q = 0; q < PRIO_LEVELS; q++){
8010353f:	43                   	inc    %ebx
80103540:	eb d4                	jmp    80103516 <proc_prio+0xc>
  return -1;
80103542:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103547:	eb ea                	jmp    80103533 <proc_prio+0x29>

80103549 <scheduler>:
{
80103549:	55                   	push   %ebp
8010354a:	89 e5                	mov    %esp,%ebp
8010354c:	57                   	push   %edi
8010354d:	56                   	push   %esi
8010354e:	53                   	push   %ebx
8010354f:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103552:	e8 17 fb ff ff       	call   8010306e <mycpu>
80103557:	89 c7                	mov    %eax,%edi
  c->proc = 0;
80103559:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103560:	00 00 00 
80103563:	eb 13                	jmp    80103578 <scheduler+0x2f>
    for (level = 0; level < PRIO_LEVELS; level++){
80103565:	46                   	inc    %esi
80103566:	eb 26                	jmp    8010358e <scheduler+0x45>
    release(&ptable.lock);
80103568:	83 ec 0c             	sub    $0xc,%esp
8010356b:	68 20 1d 11 80       	push   $0x80111d20
80103570:	e8 b4 07 00 00       	call   80103d29 <release>
    sti();
80103575:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103578:	fb                   	sti    
    acquire(&ptable.lock);
80103579:	83 ec 0c             	sub    $0xc,%esp
8010357c:	68 20 1d 11 80       	push   $0x80111d20
80103581:	e8 3e 07 00 00       	call   80103cc4 <acquire>
    for (level = 0; level < PRIO_LEVELS; level++){
80103586:	83 c4 10             	add    $0x10,%esp
80103589:	be 00 00 00 00       	mov    $0x0,%esi
8010358e:	83 fe 09             	cmp    $0x9,%esi
80103591:	7f d5                	jg     80103568 <scheduler+0x1f>
      if ((p = ptable.priority_list[level].first_proc) == NULL)
80103593:	8b 1c f5 54 3f 11 80 	mov    -0x7feec0ac(,%esi,8),%ebx
8010359a:	85 db                	test   %ebx,%ebx
8010359c:	74 c7                	je     80103565 <scheduler+0x1c>
      c->proc = p;
8010359e:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
      switchuvm(p);
801035a4:	83 ec 0c             	sub    $0xc,%esp
801035a7:	53                   	push   %ebx
801035a8:	e8 0b 2d 00 00       	call   801062b8 <switchuvm>
      remove_beggining(level);
801035ad:	89 34 24             	mov    %esi,(%esp)
801035b0:	e8 71 fb ff ff       	call   80103126 <remove_beggining>
      p->state = RUNNING;
801035b5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context); //Esta funcion continúa por el mismo sitio pero en otro proceso, es decir entras por una pila, pero restauras otra
801035bc:	83 c4 08             	add    $0x8,%esp
801035bf:	ff 73 1c             	push   0x1c(%ebx)
801035c2:	8d 47 04             	lea    0x4(%edi),%eax
801035c5:	50                   	push   %eax
801035c6:	e8 4b 09 00 00       	call   80103f16 <swtch>
      switchkvm();
801035cb:	e8 da 2c 00 00       	call   801062aa <switchkvm>
      c->proc = 0;
801035d0:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801035d7:	00 00 00 
      break;
801035da:	83 c4 10             	add    $0x10,%esp
801035dd:	eb 89                	jmp    80103568 <scheduler+0x1f>

801035df <sched>:
{
801035df:	55                   	push   %ebp
801035e0:	89 e5                	mov    %esp,%ebp
801035e2:	56                   	push   %esi
801035e3:	53                   	push   %ebx
  struct proc *p = myproc();
801035e4:	e8 1a fb ff ff       	call   80103103 <myproc>
801035e9:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801035eb:	83 ec 0c             	sub    $0xc,%esp
801035ee:	68 20 1d 11 80       	push   $0x80111d20
801035f3:	e8 8d 06 00 00       	call   80103c85 <holding>
801035f8:	83 c4 10             	add    $0x10,%esp
801035fb:	85 c0                	test   %eax,%eax
801035fd:	74 4f                	je     8010364e <sched+0x6f>
  if(mycpu()->ncli != 1)
801035ff:	e8 6a fa ff ff       	call   8010306e <mycpu>
80103604:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010360b:	75 4e                	jne    8010365b <sched+0x7c>
  if(p->state == RUNNING)
8010360d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103611:	74 55                	je     80103668 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103613:	9c                   	pushf  
80103614:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103615:	f6 c4 02             	test   $0x2,%ah
80103618:	75 5b                	jne    80103675 <sched+0x96>
  intena = mycpu()->intena;
8010361a:	e8 4f fa ff ff       	call   8010306e <mycpu>
8010361f:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103625:	e8 44 fa ff ff       	call   8010306e <mycpu>
8010362a:	83 ec 08             	sub    $0x8,%esp
8010362d:	ff 70 04             	push   0x4(%eax)
80103630:	83 c3 1c             	add    $0x1c,%ebx
80103633:	53                   	push   %ebx
80103634:	e8 dd 08 00 00       	call   80103f16 <swtch>
  mycpu()->intena = intena;
80103639:	e8 30 fa ff ff       	call   8010306e <mycpu>
8010363e:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103644:	83 c4 10             	add    $0x10,%esp
80103647:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010364a:	5b                   	pop    %ebx
8010364b:	5e                   	pop    %esi
8010364c:	5d                   	pop    %ebp
8010364d:	c3                   	ret    
    panic("sched ptable.lock");
8010364e:	83 ec 0c             	sub    $0xc,%esp
80103651:	68 eb 6e 10 80       	push   $0x80106eeb
80103656:	e8 e6 cc ff ff       	call   80100341 <panic>
    panic("sched locks");
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	68 fd 6e 10 80       	push   $0x80106efd
80103663:	e8 d9 cc ff ff       	call   80100341 <panic>
    panic("sched running");
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	68 09 6f 10 80       	push   $0x80106f09
80103670:	e8 cc cc ff ff       	call   80100341 <panic>
    panic("sched interruptible");
80103675:	83 ec 0c             	sub    $0xc,%esp
80103678:	68 17 6f 10 80       	push   $0x80106f17
8010367d:	e8 bf cc ff ff       	call   80100341 <panic>

80103682 <exit>:
{
80103682:	55                   	push   %ebp
80103683:	89 e5                	mov    %esp,%ebp
80103685:	56                   	push   %esi
80103686:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103687:	e8 77 fa ff ff       	call   80103103 <myproc>
  if(curproc == initproc)
8010368c:	39 05 a4 3f 11 80    	cmp    %eax,0x80113fa4
80103692:	74 09                	je     8010369d <exit+0x1b>
80103694:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
80103696:	bb 00 00 00 00       	mov    $0x0,%ebx
8010369b:	eb 22                	jmp    801036bf <exit+0x3d>
    panic("init exiting");
8010369d:	83 ec 0c             	sub    $0xc,%esp
801036a0:	68 2b 6f 10 80       	push   $0x80106f2b
801036a5:	e8 97 cc ff ff       	call   80100341 <panic>
      fileclose(curproc->ofile[fd]);
801036aa:	83 ec 0c             	sub    $0xc,%esp
801036ad:	50                   	push   %eax
801036ae:	e8 d7 d5 ff ff       	call   80100c8a <fileclose>
      curproc->ofile[fd] = 0;
801036b3:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801036ba:	00 
801036bb:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801036be:	43                   	inc    %ebx
801036bf:	83 fb 0f             	cmp    $0xf,%ebx
801036c2:	7f 0a                	jg     801036ce <exit+0x4c>
    if(curproc->ofile[fd]){
801036c4:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801036c8:	85 c0                	test   %eax,%eax
801036ca:	75 de                	jne    801036aa <exit+0x28>
801036cc:	eb f0                	jmp    801036be <exit+0x3c>
  begin_op();
801036ce:	e8 09 f0 ff ff       	call   801026dc <begin_op>
  iput(curproc->cwd);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	ff 76 68             	push   0x68(%esi)
801036d9:	e8 2d df ff ff       	call   8010160b <iput>
  end_op();
801036de:	e8 75 f0 ff ff       	call   80102758 <end_op>
  curproc->cwd = 0;
801036e3:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801036ea:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036f1:	e8 ce 05 00 00       	call   80103cc4 <acquire>
  wakeup1(curproc->parent);
801036f6:	8b 46 14             	mov    0x14(%esi),%eax
801036f9:	e8 d0 fa ff ff       	call   801031ce <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036fe:	83 c4 10             	add    $0x10,%esp
80103701:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103706:	eb 06                	jmp    8010370e <exit+0x8c>
80103708:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010370e:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103714:	73 1a                	jae    80103730 <exit+0xae>
    if(p->parent == curproc){
80103716:	39 73 14             	cmp    %esi,0x14(%ebx)
80103719:	75 ed                	jne    80103708 <exit+0x86>
      p->parent = initproc;
8010371b:	a1 a4 3f 11 80       	mov    0x80113fa4,%eax
80103720:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103723:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103727:	75 df                	jne    80103708 <exit+0x86>
        wakeup1(initproc);
80103729:	e8 a0 fa ff ff       	call   801031ce <wakeup1>
8010372e:	eb d8                	jmp    80103708 <exit+0x86>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
80103730:	83 ec 04             	sub    $0x4,%esp
80103733:	6a 00                	push   $0x0
80103735:	68 00 00 00 80       	push   $0x80000000
8010373a:	ff 76 04             	push   0x4(%esi)
8010373d:	e8 d4 2d 00 00       	call   80106516 <deallocuvm>
  curproc->exit_status = exit_status;
80103742:	8b 45 08             	mov    0x8(%ebp),%eax
80103745:	89 46 7c             	mov    %eax,0x7c(%esi)
  curproc->state = ZOMBIE;
80103748:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010374f:	e8 8b fe ff ff       	call   801035df <sched>
  panic("zombie exit");
80103754:	c7 04 24 38 6f 10 80 	movl   $0x80106f38,(%esp)
8010375b:	e8 e1 cb ff ff       	call   80100341 <panic>

80103760 <yield>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103766:	68 20 1d 11 80       	push   $0x80111d20
8010376b:	e8 54 05 00 00       	call   80103cc4 <acquire>
  myproc()->state = RUNNABLE;
80103770:	e8 8e f9 ff ff       	call   80103103 <myproc>
80103775:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  insert_end(myproc());
8010377c:	e8 82 f9 ff ff       	call   80103103 <myproc>
80103781:	89 04 24             	mov    %eax,(%esp)
80103784:	e8 eb f9 ff ff       	call   80103174 <insert_end>
  sched();
80103789:	e8 51 fe ff ff       	call   801035df <sched>
  release(&ptable.lock);
8010378e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103795:	e8 8f 05 00 00       	call   80103d29 <release>
}
8010379a:	83 c4 10             	add    $0x10,%esp
8010379d:	c9                   	leave  
8010379e:	c3                   	ret    

8010379f <sleep>:
{
8010379f:	55                   	push   %ebp
801037a0:	89 e5                	mov    %esp,%ebp
801037a2:	56                   	push   %esi
801037a3:	53                   	push   %ebx
801037a4:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801037a7:	e8 57 f9 ff ff       	call   80103103 <myproc>
  if(p == 0)
801037ac:	85 c0                	test   %eax,%eax
801037ae:	74 66                	je     80103816 <sleep+0x77>
801037b0:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
801037b2:	85 f6                	test   %esi,%esi
801037b4:	74 6d                	je     80103823 <sleep+0x84>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801037b6:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801037bc:	74 18                	je     801037d6 <sleep+0x37>
    acquire(&ptable.lock);  //DOC: sleeplock1
801037be:	83 ec 0c             	sub    $0xc,%esp
801037c1:	68 20 1d 11 80       	push   $0x80111d20
801037c6:	e8 f9 04 00 00       	call   80103cc4 <acquire>
    release(lk);
801037cb:	89 34 24             	mov    %esi,(%esp)
801037ce:	e8 56 05 00 00       	call   80103d29 <release>
801037d3:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801037d6:	8b 45 08             	mov    0x8(%ebp),%eax
801037d9:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801037dc:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801037e3:	e8 f7 fd ff ff       	call   801035df <sched>
  p->chan = 0;
801037e8:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
801037ef:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801037f5:	74 18                	je     8010380f <sleep+0x70>
    release(&ptable.lock);
801037f7:	83 ec 0c             	sub    $0xc,%esp
801037fa:	68 20 1d 11 80       	push   $0x80111d20
801037ff:	e8 25 05 00 00       	call   80103d29 <release>
    acquire(lk);
80103804:	89 34 24             	mov    %esi,(%esp)
80103807:	e8 b8 04 00 00       	call   80103cc4 <acquire>
8010380c:	83 c4 10             	add    $0x10,%esp
}
8010380f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103812:	5b                   	pop    %ebx
80103813:	5e                   	pop    %esi
80103814:	5d                   	pop    %ebp
80103815:	c3                   	ret    
    panic("sleep");
80103816:	83 ec 0c             	sub    $0xc,%esp
80103819:	68 44 6f 10 80       	push   $0x80106f44
8010381e:	e8 1e cb ff ff       	call   80100341 <panic>
    panic("sleep without lk");
80103823:	83 ec 0c             	sub    $0xc,%esp
80103826:	68 4a 6f 10 80       	push   $0x80106f4a
8010382b:	e8 11 cb ff ff       	call   80100341 <panic>

80103830 <wait>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103835:	e8 c9 f8 ff ff       	call   80103103 <myproc>
8010383a:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010383c:	83 ec 0c             	sub    $0xc,%esp
8010383f:	68 20 1d 11 80       	push   $0x80111d20
80103844:	e8 7b 04 00 00       	call   80103cc4 <acquire>
80103849:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010384c:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103851:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103856:	eb 77                	jmp    801038cf <wait+0x9f>
        pid = p->pid;
80103858:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	ff 73 08             	push   0x8(%ebx)
80103861:	e8 aa e6 ff ff       	call   80101f10 <kfree>
        p->kstack = 0;
80103866:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
8010386d:	83 c4 08             	add    $0x8,%esp
80103870:	6a 00                	push   $0x0
80103872:	ff 73 04             	push   0x4(%ebx)
80103875:	e8 19 2e 00 00       	call   80106693 <freevm>
        p->pid = 0;
8010387a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103881:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103888:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010388c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103893:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        if (p->exit_status != 0) {
8010389a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010389d:	83 c4 10             	add    $0x10,%esp
801038a0:	85 c0                	test   %eax,%eax
801038a2:	74 05                	je     801038a9 <wait+0x79>
          *exit_status = p->exit_status;
801038a4:	8b 55 08             	mov    0x8(%ebp),%edx
801038a7:	89 02                	mov    %eax,(%edx)
        p->exit_status = 0;
801038a9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	68 20 1d 11 80       	push   $0x80111d20
801038b8:	e8 6c 04 00 00       	call   80103d29 <release>
        return pid;
801038bd:	83 c4 10             	add    $0x10,%esp
}
801038c0:	89 f0                	mov    %esi,%eax
801038c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c5:	5b                   	pop    %ebx
801038c6:	5e                   	pop    %esi
801038c7:	5d                   	pop    %ebp
801038c8:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038c9:	81 c3 88 00 00 00    	add    $0x88,%ebx
801038cf:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
801038d5:	73 16                	jae    801038ed <wait+0xbd>
      if(p->parent != curproc)
801038d7:	39 73 14             	cmp    %esi,0x14(%ebx)
801038da:	75 ed                	jne    801038c9 <wait+0x99>
      if(p->state == ZOMBIE){
801038dc:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038e0:	0f 84 72 ff ff ff    	je     80103858 <wait+0x28>
      havekids = 1;
801038e6:	b8 01 00 00 00       	mov    $0x1,%eax
801038eb:	eb dc                	jmp    801038c9 <wait+0x99>
    if(!havekids || curproc->killed){
801038ed:	85 c0                	test   %eax,%eax
801038ef:	74 06                	je     801038f7 <wait+0xc7>
801038f1:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038f5:	74 17                	je     8010390e <wait+0xde>
      release(&ptable.lock);
801038f7:	83 ec 0c             	sub    $0xc,%esp
801038fa:	68 20 1d 11 80       	push   $0x80111d20
801038ff:	e8 25 04 00 00       	call   80103d29 <release>
      return -1;
80103904:	83 c4 10             	add    $0x10,%esp
80103907:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010390c:	eb b2                	jmp    801038c0 <wait+0x90>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010390e:	83 ec 08             	sub    $0x8,%esp
80103911:	68 20 1d 11 80       	push   $0x80111d20
80103916:	56                   	push   %esi
80103917:	e8 83 fe ff ff       	call   8010379f <sleep>
    havekids = 0;
8010391c:	83 c4 10             	add    $0x10,%esp
8010391f:	e9 28 ff ff ff       	jmp    8010384c <wait+0x1c>

80103924 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010392a:	68 20 1d 11 80       	push   $0x80111d20
8010392f:	e8 90 03 00 00       	call   80103cc4 <acquire>
  wakeup1(chan);
80103934:	8b 45 08             	mov    0x8(%ebp),%eax
80103937:	e8 92 f8 ff ff       	call   801031ce <wakeup1>
  release(&ptable.lock);
8010393c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103943:	e8 e1 03 00 00       	call   80103d29 <release>
}
80103948:	83 c4 10             	add    $0x10,%esp
8010394b:	c9                   	leave  
8010394c:	c3                   	ret    

8010394d <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010394d:	55                   	push   %ebp
8010394e:	89 e5                	mov    %esp,%ebp
80103950:	53                   	push   %ebx
80103951:	83 ec 10             	sub    $0x10,%esp
80103954:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103957:	68 20 1d 11 80       	push   $0x80111d20
8010395c:	e8 63 03 00 00       	call   80103cc4 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103961:	83 c4 10             	add    $0x10,%esp
80103964:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103969:	eb 1a                	jmp    80103985 <kill+0x38>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
8010396b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        insert_end(p);
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	50                   	push   %eax
80103976:	e8 f9 f7 ff ff       	call   80103174 <insert_end>
8010397b:	83 c4 10             	add    $0x10,%esp
8010397e:	eb 1e                	jmp    8010399e <kill+0x51>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103980:	05 88 00 00 00       	add    $0x88,%eax
80103985:	3d 54 3f 11 80       	cmp    $0x80113f54,%eax
8010398a:	73 2c                	jae    801039b8 <kill+0x6b>
    if(p->pid == pid){
8010398c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010398f:	75 ef                	jne    80103980 <kill+0x33>
      p->killed = 1;
80103991:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
80103998:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010399c:	74 cd                	je     8010396b <kill+0x1e>
      }
      release(&ptable.lock);
8010399e:	83 ec 0c             	sub    $0xc,%esp
801039a1:	68 20 1d 11 80       	push   $0x80111d20
801039a6:	e8 7e 03 00 00       	call   80103d29 <release>
      return 0;
801039ab:	83 c4 10             	add    $0x10,%esp
801039ae:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801039b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b6:	c9                   	leave  
801039b7:	c3                   	ret    
  release(&ptable.lock);
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	68 20 1d 11 80       	push   $0x80111d20
801039c0:	e8 64 03 00 00       	call   80103d29 <release>
  return -1;
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039cd:	eb e4                	jmp    801039b3 <kill+0x66>

801039cf <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801039cf:	55                   	push   %ebp
801039d0:	89 e5                	mov    %esp,%ebp
801039d2:	56                   	push   %esi
801039d3:	53                   	push   %ebx
801039d4:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d7:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801039dc:	eb 36                	jmp    80103a14 <procdump+0x45>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801039de:	b8 5b 6f 10 80       	mov    $0x80106f5b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801039e3:	8d 53 6c             	lea    0x6c(%ebx),%edx
801039e6:	52                   	push   %edx
801039e7:	50                   	push   %eax
801039e8:	ff 73 10             	push   0x10(%ebx)
801039eb:	68 5f 6f 10 80       	push   $0x80106f5f
801039f0:	e8 e5 cb ff ff       	call   801005da <cprintf>
    if(p->state == SLEEPING){
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801039fc:	74 3c                	je     80103a3a <procdump+0x6b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801039fe:	83 ec 0c             	sub    $0xc,%esp
80103a01:	68 5f 73 10 80       	push   $0x8010735f
80103a06:	e8 cf cb ff ff       	call   801005da <cprintf>
80103a0b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0e:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a14:	81 fb 54 3f 11 80    	cmp    $0x80113f54,%ebx
80103a1a:	73 5f                	jae    80103a7b <procdump+0xac>
    if(p->state == UNUSED)
80103a1c:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a1f:	85 c0                	test   %eax,%eax
80103a21:	74 eb                	je     80103a0e <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a23:	83 f8 05             	cmp    $0x5,%eax
80103a26:	77 b6                	ja     801039de <procdump+0xf>
80103a28:	8b 04 85 bc 6f 10 80 	mov    -0x7fef9044(,%eax,4),%eax
80103a2f:	85 c0                	test   %eax,%eax
80103a31:	75 b0                	jne    801039e3 <procdump+0x14>
      state = "???";
80103a33:	b8 5b 6f 10 80       	mov    $0x80106f5b,%eax
80103a38:	eb a9                	jmp    801039e3 <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a3a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a3d:	8b 40 0c             	mov    0xc(%eax),%eax
80103a40:	83 c0 08             	add    $0x8,%eax
80103a43:	83 ec 08             	sub    $0x8,%esp
80103a46:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a49:	52                   	push   %edx
80103a4a:	50                   	push   %eax
80103a4b:	e8 58 01 00 00       	call   80103ba8 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a50:	83 c4 10             	add    $0x10,%esp
80103a53:	be 00 00 00 00       	mov    $0x0,%esi
80103a58:	eb 12                	jmp    80103a6c <procdump+0x9d>
        cprintf(" %p", pc[i]);
80103a5a:	83 ec 08             	sub    $0x8,%esp
80103a5d:	50                   	push   %eax
80103a5e:	68 a1 69 10 80       	push   $0x801069a1
80103a63:	e8 72 cb ff ff       	call   801005da <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a68:	46                   	inc    %esi
80103a69:	83 c4 10             	add    $0x10,%esp
80103a6c:	83 fe 09             	cmp    $0x9,%esi
80103a6f:	7f 8d                	jg     801039fe <procdump+0x2f>
80103a71:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103a75:	85 c0                	test   %eax,%eax
80103a77:	75 e1                	jne    80103a5a <procdump+0x8b>
80103a79:	eb 83                	jmp    801039fe <procdump+0x2f>
  }
}
80103a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7e:	5b                   	pop    %ebx
80103a7f:	5e                   	pop    %esi
80103a80:	5d                   	pop    %ebp
80103a81:	c3                   	ret    

80103a82 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103a82:	55                   	push   %ebp
80103a83:	89 e5                	mov    %esp,%ebp
80103a85:	53                   	push   %ebx
80103a86:	83 ec 0c             	sub    $0xc,%esp
80103a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103a8c:	68 d4 6f 10 80       	push   $0x80106fd4
80103a91:	8d 43 04             	lea    0x4(%ebx),%eax
80103a94:	50                   	push   %eax
80103a95:	e8 f3 00 00 00       	call   80103b8d <initlock>
  lk->name = name;
80103a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a9d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103aa0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103aa6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    

80103ab5 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103ab5:	55                   	push   %ebp
80103ab6:	89 e5                	mov    %esp,%ebp
80103ab8:	56                   	push   %esi
80103ab9:	53                   	push   %ebx
80103aba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103abd:	8d 73 04             	lea    0x4(%ebx),%esi
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	56                   	push   %esi
80103ac4:	e8 fb 01 00 00       	call   80103cc4 <acquire>
  while (lk->locked) {
80103ac9:	83 c4 10             	add    $0x10,%esp
80103acc:	eb 0d                	jmp    80103adb <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103ace:	83 ec 08             	sub    $0x8,%esp
80103ad1:	56                   	push   %esi
80103ad2:	53                   	push   %ebx
80103ad3:	e8 c7 fc ff ff       	call   8010379f <sleep>
80103ad8:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103adb:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ade:	75 ee                	jne    80103ace <acquiresleep+0x19>
  }
  lk->locked = 1;
80103ae0:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103ae6:	e8 18 f6 ff ff       	call   80103103 <myproc>
80103aeb:	8b 40 10             	mov    0x10(%eax),%eax
80103aee:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103af1:	83 ec 0c             	sub    $0xc,%esp
80103af4:	56                   	push   %esi
80103af5:	e8 2f 02 00 00       	call   80103d29 <release>
}
80103afa:	83 c4 10             	add    $0x10,%esp
80103afd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b00:	5b                   	pop    %ebx
80103b01:	5e                   	pop    %esi
80103b02:	5d                   	pop    %ebp
80103b03:	c3                   	ret    

80103b04 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b04:	55                   	push   %ebp
80103b05:	89 e5                	mov    %esp,%ebp
80103b07:	56                   	push   %esi
80103b08:	53                   	push   %ebx
80103b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b0c:	8d 73 04             	lea    0x4(%ebx),%esi
80103b0f:	83 ec 0c             	sub    $0xc,%esp
80103b12:	56                   	push   %esi
80103b13:	e8 ac 01 00 00       	call   80103cc4 <acquire>
  lk->locked = 0;
80103b18:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b1e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b25:	89 1c 24             	mov    %ebx,(%esp)
80103b28:	e8 f7 fd ff ff       	call   80103924 <wakeup>
  release(&lk->lk);
80103b2d:	89 34 24             	mov    %esi,(%esp)
80103b30:	e8 f4 01 00 00       	call   80103d29 <release>
}
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b3b:	5b                   	pop    %ebx
80103b3c:	5e                   	pop    %esi
80103b3d:	5d                   	pop    %ebp
80103b3e:	c3                   	ret    

80103b3f <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b3f:	55                   	push   %ebp
80103b40:	89 e5                	mov    %esp,%ebp
80103b42:	56                   	push   %esi
80103b43:	53                   	push   %ebx
80103b44:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b47:	8d 73 04             	lea    0x4(%ebx),%esi
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	56                   	push   %esi
80103b4e:	e8 71 01 00 00       	call   80103cc4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b53:	83 c4 10             	add    $0x10,%esp
80103b56:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b59:	75 17                	jne    80103b72 <holdingsleep+0x33>
80103b5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	56                   	push   %esi
80103b64:	e8 c0 01 00 00       	call   80103d29 <release>
  return r;
}
80103b69:	89 d8                	mov    %ebx,%eax
80103b6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b6e:	5b                   	pop    %ebx
80103b6f:	5e                   	pop    %esi
80103b70:	5d                   	pop    %ebp
80103b71:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103b72:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103b75:	e8 89 f5 ff ff       	call   80103103 <myproc>
80103b7a:	3b 58 10             	cmp    0x10(%eax),%ebx
80103b7d:	74 07                	je     80103b86 <holdingsleep+0x47>
80103b7f:	bb 00 00 00 00       	mov    $0x0,%ebx
80103b84:	eb da                	jmp    80103b60 <holdingsleep+0x21>
80103b86:	bb 01 00 00 00       	mov    $0x1,%ebx
80103b8b:	eb d3                	jmp    80103b60 <holdingsleep+0x21>

80103b8d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103b8d:	55                   	push   %ebp
80103b8e:	89 e5                	mov    %esp,%ebp
80103b90:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103b93:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b96:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103b9f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103ba6:	5d                   	pop    %ebp
80103ba7:	c3                   	ret    

80103ba8 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	53                   	push   %ebx
80103bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103baf:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb2:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103bb5:	b8 00 00 00 00       	mov    $0x0,%eax
80103bba:	83 f8 09             	cmp    $0x9,%eax
80103bbd:	7f 21                	jg     80103be0 <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bbf:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bc5:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103bcb:	77 13                	ja     80103be0 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103bcd:	8b 5a 04             	mov    0x4(%edx),%ebx
80103bd0:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bd3:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103bd5:	40                   	inc    %eax
80103bd6:	eb e2                	jmp    80103bba <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103bd8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103bdf:	40                   	inc    %eax
80103be0:	83 f8 09             	cmp    $0x9,%eax
80103be3:	7e f3                	jle    80103bd8 <getcallerpcs+0x30>
}
80103be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103be8:	c9                   	leave  
80103be9:	c3                   	ret    

80103bea <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103bea:	55                   	push   %ebp
80103beb:	89 e5                	mov    %esp,%ebp
80103bed:	53                   	push   %ebx
80103bee:	83 ec 04             	sub    $0x4,%esp
80103bf1:	9c                   	pushf  
80103bf2:	5b                   	pop    %ebx
  asm volatile("cli");
80103bf3:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103bf4:	e8 75 f4 ff ff       	call   8010306e <mycpu>
80103bf9:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c00:	74 10                	je     80103c12 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c02:	e8 67 f4 ff ff       	call   8010306e <mycpu>
80103c07:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103c0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c10:	c9                   	leave  
80103c11:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c12:	e8 57 f4 ff ff       	call   8010306e <mycpu>
80103c17:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c1d:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c23:	eb dd                	jmp    80103c02 <pushcli+0x18>

80103c25 <popcli>:

void
popcli(void)
{
80103c25:	55                   	push   %ebp
80103c26:	89 e5                	mov    %esp,%ebp
80103c28:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c2b:	9c                   	pushf  
80103c2c:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c2d:	f6 c4 02             	test   $0x2,%ah
80103c30:	75 28                	jne    80103c5a <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c32:	e8 37 f4 ff ff       	call   8010306e <mycpu>
80103c37:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c3d:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c40:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103c46:	85 d2                	test   %edx,%edx
80103c48:	78 1d                	js     80103c67 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c4a:	e8 1f f4 ff ff       	call   8010306e <mycpu>
80103c4f:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c56:	74 1c                	je     80103c74 <popcli+0x4f>
    sti();
}
80103c58:	c9                   	leave  
80103c59:	c3                   	ret    
    panic("popcli - interruptible");
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	68 df 6f 10 80       	push   $0x80106fdf
80103c62:	e8 da c6 ff ff       	call   80100341 <panic>
    panic("popcli");
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	68 f6 6f 10 80       	push   $0x80106ff6
80103c6f:	e8 cd c6 ff ff       	call   80100341 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c74:	e8 f5 f3 ff ff       	call   8010306e <mycpu>
80103c79:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103c80:	74 d6                	je     80103c58 <popcli+0x33>
  asm volatile("sti");
80103c82:	fb                   	sti    
}
80103c83:	eb d3                	jmp    80103c58 <popcli+0x33>

80103c85 <holding>:
{
80103c85:	55                   	push   %ebp
80103c86:	89 e5                	mov    %esp,%ebp
80103c88:	53                   	push   %ebx
80103c89:	83 ec 04             	sub    $0x4,%esp
80103c8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c8f:	e8 56 ff ff ff       	call   80103bea <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103c94:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c97:	75 11                	jne    80103caa <holding+0x25>
80103c99:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103c9e:	e8 82 ff ff ff       	call   80103c25 <popcli>
}
80103ca3:	89 d8                	mov    %ebx,%eax
80103ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ca8:	c9                   	leave  
80103ca9:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103caa:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103cad:	e8 bc f3 ff ff       	call   8010306e <mycpu>
80103cb2:	39 c3                	cmp    %eax,%ebx
80103cb4:	74 07                	je     80103cbd <holding+0x38>
80103cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
80103cbb:	eb e1                	jmp    80103c9e <holding+0x19>
80103cbd:	bb 01 00 00 00       	mov    $0x1,%ebx
80103cc2:	eb da                	jmp    80103c9e <holding+0x19>

80103cc4 <acquire>:
{
80103cc4:	55                   	push   %ebp
80103cc5:	89 e5                	mov    %esp,%ebp
80103cc7:	53                   	push   %ebx
80103cc8:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103ccb:	e8 1a ff ff ff       	call   80103bea <pushcli>
  if(holding(lk))
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	ff 75 08             	push   0x8(%ebp)
80103cd6:	e8 aa ff ff ff       	call   80103c85 <holding>
80103cdb:	83 c4 10             	add    $0x10,%esp
80103cde:	85 c0                	test   %eax,%eax
80103ce0:	75 3a                	jne    80103d1c <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103ce5:	b8 01 00 00 00       	mov    $0x1,%eax
80103cea:	f0 87 02             	lock xchg %eax,(%edx)
80103ced:	85 c0                	test   %eax,%eax
80103cef:	75 f1                	jne    80103ce2 <acquire+0x1e>
  __sync_synchronize();
80103cf1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103cf6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cf9:	e8 70 f3 ff ff       	call   8010306e <mycpu>
80103cfe:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d01:	8b 45 08             	mov    0x8(%ebp),%eax
80103d04:	83 c0 0c             	add    $0xc,%eax
80103d07:	83 ec 08             	sub    $0x8,%esp
80103d0a:	50                   	push   %eax
80103d0b:	8d 45 08             	lea    0x8(%ebp),%eax
80103d0e:	50                   	push   %eax
80103d0f:	e8 94 fe ff ff       	call   80103ba8 <getcallerpcs>
}
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d1a:	c9                   	leave  
80103d1b:	c3                   	ret    
    panic("acquire");
80103d1c:	83 ec 0c             	sub    $0xc,%esp
80103d1f:	68 fd 6f 10 80       	push   $0x80106ffd
80103d24:	e8 18 c6 ff ff       	call   80100341 <panic>

80103d29 <release>:
{
80103d29:	55                   	push   %ebp
80103d2a:	89 e5                	mov    %esp,%ebp
80103d2c:	53                   	push   %ebx
80103d2d:	83 ec 10             	sub    $0x10,%esp
80103d30:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d33:	53                   	push   %ebx
80103d34:	e8 4c ff ff ff       	call   80103c85 <holding>
80103d39:	83 c4 10             	add    $0x10,%esp
80103d3c:	85 c0                	test   %eax,%eax
80103d3e:	74 23                	je     80103d63 <release+0x3a>
  lk->pcs[0] = 0;
80103d40:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d47:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d4e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d53:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103d59:	e8 c7 fe ff ff       	call   80103c25 <popcli>
}
80103d5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d61:	c9                   	leave  
80103d62:	c3                   	ret    
    panic("release");
80103d63:	83 ec 0c             	sub    $0xc,%esp
80103d66:	68 05 70 10 80       	push   $0x80107005
80103d6b:	e8 d1 c5 ff ff       	call   80100341 <panic>

80103d70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	53                   	push   %ebx
80103d75:	8b 55 08             	mov    0x8(%ebp),%edx
80103d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103d7b:	f6 c2 03             	test   $0x3,%dl
80103d7e:	75 29                	jne    80103da9 <memset+0x39>
80103d80:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103d84:	75 23                	jne    80103da9 <memset+0x39>
    c &= 0xFF;
80103d86:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103d89:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103d8c:	c1 e9 02             	shr    $0x2,%ecx
80103d8f:	c1 e0 18             	shl    $0x18,%eax
80103d92:	89 fb                	mov    %edi,%ebx
80103d94:	c1 e3 10             	shl    $0x10,%ebx
80103d97:	09 d8                	or     %ebx,%eax
80103d99:	89 fb                	mov    %edi,%ebx
80103d9b:	c1 e3 08             	shl    $0x8,%ebx
80103d9e:	09 d8                	or     %ebx,%eax
80103da0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103da2:	89 d7                	mov    %edx,%edi
80103da4:	fc                   	cld    
80103da5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103da7:	eb 08                	jmp    80103db1 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103da9:	89 d7                	mov    %edx,%edi
80103dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103dae:	fc                   	cld    
80103daf:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103db1:	89 d0                	mov    %edx,%eax
80103db3:	5b                   	pop    %ebx
80103db4:	5f                   	pop    %edi
80103db5:	5d                   	pop    %ebp
80103db6:	c3                   	ret    

80103db7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103db7:	55                   	push   %ebp
80103db8:	89 e5                	mov    %esp,%ebp
80103dba:	56                   	push   %esi
80103dbb:	53                   	push   %ebx
80103dbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dc2:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103dc5:	eb 04                	jmp    80103dcb <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80103dc7:	41                   	inc    %ecx
80103dc8:	42                   	inc    %edx
  while(n-- > 0){
80103dc9:	89 f0                	mov    %esi,%eax
80103dcb:	8d 70 ff             	lea    -0x1(%eax),%esi
80103dce:	85 c0                	test   %eax,%eax
80103dd0:	74 10                	je     80103de2 <memcmp+0x2b>
    if(*s1 != *s2)
80103dd2:	8a 01                	mov    (%ecx),%al
80103dd4:	8a 1a                	mov    (%edx),%bl
80103dd6:	38 d8                	cmp    %bl,%al
80103dd8:	74 ed                	je     80103dc7 <memcmp+0x10>
      return *s1 - *s2;
80103dda:	0f b6 c0             	movzbl %al,%eax
80103ddd:	0f b6 db             	movzbl %bl,%ebx
80103de0:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103de2:	5b                   	pop    %ebx
80103de3:	5e                   	pop    %esi
80103de4:	5d                   	pop    %ebp
80103de5:	c3                   	ret    

80103de6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103de6:	55                   	push   %ebp
80103de7:	89 e5                	mov    %esp,%ebp
80103de9:	56                   	push   %esi
80103dea:	53                   	push   %ebx
80103deb:	8b 75 08             	mov    0x8(%ebp),%esi
80103dee:	8b 55 0c             	mov    0xc(%ebp),%edx
80103df1:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103df4:	39 f2                	cmp    %esi,%edx
80103df6:	73 36                	jae    80103e2e <memmove+0x48>
80103df8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103dfb:	39 f1                	cmp    %esi,%ecx
80103dfd:	76 33                	jbe    80103e32 <memmove+0x4c>
    s += n;
    d += n;
80103dff:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103e02:	eb 08                	jmp    80103e0c <memmove+0x26>
      *--d = *--s;
80103e04:	49                   	dec    %ecx
80103e05:	4a                   	dec    %edx
80103e06:	8a 01                	mov    (%ecx),%al
80103e08:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103e0a:	89 d8                	mov    %ebx,%eax
80103e0c:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e0f:	85 c0                	test   %eax,%eax
80103e11:	75 f1                	jne    80103e04 <memmove+0x1e>
80103e13:	eb 13                	jmp    80103e28 <memmove+0x42>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103e15:	8a 02                	mov    (%edx),%al
80103e17:	88 01                	mov    %al,(%ecx)
80103e19:	8d 49 01             	lea    0x1(%ecx),%ecx
80103e1c:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103e1f:	89 d8                	mov    %ebx,%eax
80103e21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e24:	85 c0                	test   %eax,%eax
80103e26:	75 ed                	jne    80103e15 <memmove+0x2f>

  return dst;
}
80103e28:	89 f0                	mov    %esi,%eax
80103e2a:	5b                   	pop    %ebx
80103e2b:	5e                   	pop    %esi
80103e2c:	5d                   	pop    %ebp
80103e2d:	c3                   	ret    
80103e2e:	89 f1                	mov    %esi,%ecx
80103e30:	eb ef                	jmp    80103e21 <memmove+0x3b>
80103e32:	89 f1                	mov    %esi,%ecx
80103e34:	eb eb                	jmp    80103e21 <memmove+0x3b>

80103e36 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e36:	55                   	push   %ebp
80103e37:	89 e5                	mov    %esp,%ebp
80103e39:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103e3c:	ff 75 10             	push   0x10(%ebp)
80103e3f:	ff 75 0c             	push   0xc(%ebp)
80103e42:	ff 75 08             	push   0x8(%ebp)
80103e45:	e8 9c ff ff ff       	call   80103de6 <memmove>
}
80103e4a:	c9                   	leave  
80103e4b:	c3                   	ret    

80103e4c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e4c:	55                   	push   %ebp
80103e4d:	89 e5                	mov    %esp,%ebp
80103e4f:	53                   	push   %ebx
80103e50:	8b 55 08             	mov    0x8(%ebp),%edx
80103e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e56:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103e59:	eb 03                	jmp    80103e5e <strncmp+0x12>
    n--, p++, q++;
80103e5b:	48                   	dec    %eax
80103e5c:	42                   	inc    %edx
80103e5d:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80103e5e:	85 c0                	test   %eax,%eax
80103e60:	74 0a                	je     80103e6c <strncmp+0x20>
80103e62:	8a 1a                	mov    (%edx),%bl
80103e64:	84 db                	test   %bl,%bl
80103e66:	74 04                	je     80103e6c <strncmp+0x20>
80103e68:	3a 19                	cmp    (%ecx),%bl
80103e6a:	74 ef                	je     80103e5b <strncmp+0xf>
  if(n == 0)
80103e6c:	85 c0                	test   %eax,%eax
80103e6e:	74 0d                	je     80103e7d <strncmp+0x31>
    return 0;
  return (uchar)*p - (uchar)*q;
80103e70:	0f b6 02             	movzbl (%edx),%eax
80103e73:	0f b6 11             	movzbl (%ecx),%edx
80103e76:	29 d0                	sub    %edx,%eax
}
80103e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e7b:	c9                   	leave  
80103e7c:	c3                   	ret    
    return 0;
80103e7d:	b8 00 00 00 00       	mov    $0x0,%eax
80103e82:	eb f4                	jmp    80103e78 <strncmp+0x2c>

80103e84 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	57                   	push   %edi
80103e88:	56                   	push   %esi
80103e89:	53                   	push   %ebx
80103e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e90:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103e93:	89 c1                	mov    %eax,%ecx
80103e95:	eb 04                	jmp    80103e9b <strncpy+0x17>
80103e97:	89 fb                	mov    %edi,%ebx
80103e99:	89 f1                	mov    %esi,%ecx
80103e9b:	89 d6                	mov    %edx,%esi
80103e9d:	4a                   	dec    %edx
80103e9e:	85 f6                	test   %esi,%esi
80103ea0:	7e 10                	jle    80103eb2 <strncpy+0x2e>
80103ea2:	8d 7b 01             	lea    0x1(%ebx),%edi
80103ea5:	8d 71 01             	lea    0x1(%ecx),%esi
80103ea8:	8a 1b                	mov    (%ebx),%bl
80103eaa:	88 19                	mov    %bl,(%ecx)
80103eac:	84 db                	test   %bl,%bl
80103eae:	75 e7                	jne    80103e97 <strncpy+0x13>
80103eb0:	89 f1                	mov    %esi,%ecx
    ;
  while(n-- > 0)
80103eb2:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103eb5:	85 d2                	test   %edx,%edx
80103eb7:	7e 0a                	jle    80103ec3 <strncpy+0x3f>
    *s++ = 0;
80103eb9:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
80103ebc:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80103ebe:	8d 49 01             	lea    0x1(%ecx),%ecx
80103ec1:	eb ef                	jmp    80103eb2 <strncpy+0x2e>
  return os;
}
80103ec3:	5b                   	pop    %ebx
80103ec4:	5e                   	pop    %esi
80103ec5:	5f                   	pop    %edi
80103ec6:	5d                   	pop    %ebp
80103ec7:	c3                   	ret    

80103ec8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103ec8:	55                   	push   %ebp
80103ec9:	89 e5                	mov    %esp,%ebp
80103ecb:	57                   	push   %edi
80103ecc:	56                   	push   %esi
80103ecd:	53                   	push   %ebx
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103ed4:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103ed7:	85 d2                	test   %edx,%edx
80103ed9:	7e 20                	jle    80103efb <safestrcpy+0x33>
80103edb:	89 c1                	mov    %eax,%ecx
80103edd:	eb 04                	jmp    80103ee3 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103edf:	89 fb                	mov    %edi,%ebx
80103ee1:	89 f1                	mov    %esi,%ecx
80103ee3:	4a                   	dec    %edx
80103ee4:	85 d2                	test   %edx,%edx
80103ee6:	7e 10                	jle    80103ef8 <safestrcpy+0x30>
80103ee8:	8d 7b 01             	lea    0x1(%ebx),%edi
80103eeb:	8d 71 01             	lea    0x1(%ecx),%esi
80103eee:	8a 1b                	mov    (%ebx),%bl
80103ef0:	88 19                	mov    %bl,(%ecx)
80103ef2:	84 db                	test   %bl,%bl
80103ef4:	75 e9                	jne    80103edf <safestrcpy+0x17>
80103ef6:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80103ef8:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103efb:	5b                   	pop    %ebx
80103efc:	5e                   	pop    %esi
80103efd:	5f                   	pop    %edi
80103efe:	5d                   	pop    %ebp
80103eff:	c3                   	ret    

80103f00 <strlen>:

int
strlen(const char *s)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f06:	b8 00 00 00 00       	mov    $0x0,%eax
80103f0b:	eb 01                	jmp    80103f0e <strlen+0xe>
80103f0d:	40                   	inc    %eax
80103f0e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f12:	75 f9                	jne    80103f0d <strlen+0xd>
    ;
  return n;
}
80103f14:	5d                   	pop    %ebp
80103f15:	c3                   	ret    

80103f16 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f16:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f1a:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103f1e:	55                   	push   %ebp
  pushl %ebx
80103f1f:	53                   	push   %ebx
  pushl %esi
80103f20:	56                   	push   %esi
  pushl %edi
80103f21:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f22:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f24:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103f26:	5f                   	pop    %edi
  popl %esi
80103f27:	5e                   	pop    %esi
  popl %ebx
80103f28:	5b                   	pop    %ebx
  popl %ebp
80103f29:	5d                   	pop    %ebp
  ret
80103f2a:	c3                   	ret    

80103f2b <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f2b:	55                   	push   %ebp
80103f2c:	89 e5                	mov    %esp,%ebp
80103f2e:	53                   	push   %ebx
80103f2f:	83 ec 04             	sub    $0x4,%esp
80103f32:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103f35:	e8 c9 f1 ff ff       	call   80103103 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103f3a:	8b 00                	mov    (%eax),%eax
80103f3c:	39 d8                	cmp    %ebx,%eax
80103f3e:	76 18                	jbe    80103f58 <fetchint+0x2d>
80103f40:	8d 53 04             	lea    0x4(%ebx),%edx
80103f43:	39 d0                	cmp    %edx,%eax
80103f45:	72 18                	jb     80103f5f <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103f47:	8b 13                	mov    (%ebx),%edx
80103f49:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f4c:	89 10                	mov    %edx,(%eax)
  return 0;
80103f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f56:	c9                   	leave  
80103f57:	c3                   	ret    
    return -1;
80103f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f5d:	eb f4                	jmp    80103f53 <fetchint+0x28>
80103f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f64:	eb ed                	jmp    80103f53 <fetchint+0x28>

80103f66 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103f66:	55                   	push   %ebp
80103f67:	89 e5                	mov    %esp,%ebp
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 04             	sub    $0x4,%esp
80103f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103f70:	e8 8e f1 ff ff       	call   80103103 <myproc>

  if(addr >= curproc->sz)
80103f75:	39 18                	cmp    %ebx,(%eax)
80103f77:	76 23                	jbe    80103f9c <fetchstr+0x36>
    return -1;
  *pp = (char*)addr;
80103f79:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f7c:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103f7e:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103f80:	89 d8                	mov    %ebx,%eax
80103f82:	eb 01                	jmp    80103f85 <fetchstr+0x1f>
80103f84:	40                   	inc    %eax
80103f85:	39 d0                	cmp    %edx,%eax
80103f87:	73 09                	jae    80103f92 <fetchstr+0x2c>
    if(*s == 0)
80103f89:	80 38 00             	cmpb   $0x0,(%eax)
80103f8c:	75 f6                	jne    80103f84 <fetchstr+0x1e>
      return s - *pp;
80103f8e:	29 d8                	sub    %ebx,%eax
80103f90:	eb 05                	jmp    80103f97 <fetchstr+0x31>
  }
  return -1;
80103f92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f9a:	c9                   	leave  
80103f9b:	c3                   	ret    
    return -1;
80103f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fa1:	eb f4                	jmp    80103f97 <fetchstr+0x31>

80103fa3 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103fa3:	55                   	push   %ebp
80103fa4:	89 e5                	mov    %esp,%ebp
80103fa6:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103fa9:	e8 55 f1 ff ff       	call   80103103 <myproc>
80103fae:	8b 50 18             	mov    0x18(%eax),%edx
80103fb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb4:	c1 e0 02             	shl    $0x2,%eax
80103fb7:	03 42 44             	add    0x44(%edx),%eax
80103fba:	83 ec 08             	sub    $0x8,%esp
80103fbd:	ff 75 0c             	push   0xc(%ebp)
80103fc0:	83 c0 04             	add    $0x4,%eax
80103fc3:	50                   	push   %eax
80103fc4:	e8 62 ff ff ff       	call   80103f2b <fetchint>
}
80103fc9:	c9                   	leave  
80103fca:	c3                   	ret    

80103fcb <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80103fcb:	55                   	push   %ebp
80103fcc:	89 e5                	mov    %esp,%ebp
80103fce:	56                   	push   %esi
80103fcf:	53                   	push   %ebx
80103fd0:	83 ec 10             	sub    $0x10,%esp
80103fd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103fd6:	e8 28 f1 ff ff       	call   80103103 <myproc>
80103fdb:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80103fdd:	83 ec 08             	sub    $0x8,%esp
80103fe0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103fe3:	50                   	push   %eax
80103fe4:	ff 75 08             	push   0x8(%ebp)
80103fe7:	e8 b7 ff ff ff       	call   80103fa3 <argint>
80103fec:	83 c4 10             	add    $0x10,%esp
80103fef:	85 c0                	test   %eax,%eax
80103ff1:	78 24                	js     80104017 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80103ff3:	85 db                	test   %ebx,%ebx
80103ff5:	78 27                	js     8010401e <argptr+0x53>
80103ff7:	8b 16                	mov    (%esi),%edx
80103ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffc:	39 c2                	cmp    %eax,%edx
80103ffe:	76 25                	jbe    80104025 <argptr+0x5a>
80104000:	01 c3                	add    %eax,%ebx
80104002:	39 da                	cmp    %ebx,%edx
80104004:	72 26                	jb     8010402c <argptr+0x61>
    return -1;
  *pp = (void*)i;
80104006:	8b 55 0c             	mov    0xc(%ebp),%edx
80104009:	89 02                	mov    %eax,(%edx)
  return 0;
8010400b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104010:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104013:	5b                   	pop    %ebx
80104014:	5e                   	pop    %esi
80104015:	5d                   	pop    %ebp
80104016:	c3                   	ret    
    return -1;
80104017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010401c:	eb f2                	jmp    80104010 <argptr+0x45>
    return -1;
8010401e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104023:	eb eb                	jmp    80104010 <argptr+0x45>
80104025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010402a:	eb e4                	jmp    80104010 <argptr+0x45>
8010402c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104031:	eb dd                	jmp    80104010 <argptr+0x45>

80104033 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104033:	55                   	push   %ebp
80104034:	89 e5                	mov    %esp,%ebp
80104036:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104039:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010403c:	50                   	push   %eax
8010403d:	ff 75 08             	push   0x8(%ebp)
80104040:	e8 5e ff ff ff       	call   80103fa3 <argint>
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	85 c0                	test   %eax,%eax
8010404a:	78 13                	js     8010405f <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
8010404c:	83 ec 08             	sub    $0x8,%esp
8010404f:	ff 75 0c             	push   0xc(%ebp)
80104052:	ff 75 f4             	push   -0xc(%ebp)
80104055:	e8 0c ff ff ff       	call   80103f66 <fetchstr>
8010405a:	83 c4 10             	add    $0x10,%esp
}
8010405d:	c9                   	leave  
8010405e:	c3                   	ret    
    return -1;
8010405f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104064:	eb f7                	jmp    8010405d <argstr+0x2a>

80104066 <syscall>:
[SYS_setprio] sys_setprio,
};

void
syscall(void)
{
80104066:	55                   	push   %ebp
80104067:	89 e5                	mov    %esp,%ebp
80104069:	53                   	push   %ebx
8010406a:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010406d:	e8 91 f0 ff ff       	call   80103103 <myproc>
80104072:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104074:	8b 40 18             	mov    0x18(%eax),%eax
80104077:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010407a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010407d:	83 fa 18             	cmp    $0x18,%edx
80104080:	77 17                	ja     80104099 <syscall+0x33>
80104082:	8b 14 85 40 70 10 80 	mov    -0x7fef8fc0(,%eax,4),%edx
80104089:	85 d2                	test   %edx,%edx
8010408b:	74 0c                	je     80104099 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
8010408d:	ff d2                	call   *%edx
8010408f:	89 c2                	mov    %eax,%edx
80104091:	8b 43 18             	mov    0x18(%ebx),%eax
80104094:	89 50 1c             	mov    %edx,0x1c(%eax)
80104097:	eb 1f                	jmp    801040b8 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80104099:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010409c:	50                   	push   %eax
8010409d:	52                   	push   %edx
8010409e:	ff 73 10             	push   0x10(%ebx)
801040a1:	68 0d 70 10 80       	push   $0x8010700d
801040a6:	e8 2f c5 ff ff       	call   801005da <cprintf>
    curproc->tf->eax = -1;
801040ab:	8b 43 18             	mov    0x18(%ebx),%eax
801040ae:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801040b5:	83 c4 10             	add    $0x10,%esp
  }
}
801040b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040bb:	c9                   	leave  
801040bc:	c3                   	ret    

801040bd <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801040bd:	55                   	push   %ebp
801040be:	89 e5                	mov    %esp,%ebp
801040c0:	56                   	push   %esi
801040c1:	53                   	push   %ebx
801040c2:	83 ec 18             	sub    $0x18,%esp
801040c5:	89 d6                	mov    %edx,%esi
801040c7:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801040c9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801040cc:	52                   	push   %edx
801040cd:	50                   	push   %eax
801040ce:	e8 d0 fe ff ff       	call   80103fa3 <argint>
801040d3:	83 c4 10             	add    $0x10,%esp
801040d6:	85 c0                	test   %eax,%eax
801040d8:	78 35                	js     8010410f <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801040da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801040de:	77 28                	ja     80104108 <argfd+0x4b>
801040e0:	e8 1e f0 ff ff       	call   80103103 <myproc>
801040e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040e8:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801040ec:	85 c0                	test   %eax,%eax
801040ee:	74 18                	je     80104108 <argfd+0x4b>
    return -1;
  if(pfd)
801040f0:	85 f6                	test   %esi,%esi
801040f2:	74 02                	je     801040f6 <argfd+0x39>
    *pfd = fd;
801040f4:	89 16                	mov    %edx,(%esi)
  if(pf)
801040f6:	85 db                	test   %ebx,%ebx
801040f8:	74 1c                	je     80104116 <argfd+0x59>
    *pf = f;
801040fa:	89 03                	mov    %eax,(%ebx)
  return 0;
801040fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104101:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104104:	5b                   	pop    %ebx
80104105:	5e                   	pop    %esi
80104106:	5d                   	pop    %ebp
80104107:	c3                   	ret    
    return -1;
80104108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010410d:	eb f2                	jmp    80104101 <argfd+0x44>
    return -1;
8010410f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104114:	eb eb                	jmp    80104101 <argfd+0x44>
  return 0;
80104116:	b8 00 00 00 00       	mov    $0x0,%eax
8010411b:	eb e4                	jmp    80104101 <argfd+0x44>

8010411d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010411d:	55                   	push   %ebp
8010411e:	89 e5                	mov    %esp,%ebp
80104120:	53                   	push   %ebx
80104121:	83 ec 04             	sub    $0x4,%esp
80104124:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104126:	e8 d8 ef ff ff       	call   80103103 <myproc>
8010412b:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010412d:	b8 00 00 00 00       	mov    $0x0,%eax
80104132:	83 f8 0f             	cmp    $0xf,%eax
80104135:	7f 10                	jg     80104147 <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
80104137:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
8010413c:	74 03                	je     80104141 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
8010413e:	40                   	inc    %eax
8010413f:	eb f1                	jmp    80104132 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80104141:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104145:	eb 05                	jmp    8010414c <fdalloc+0x2f>
    }
  }
  return -1;
80104147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010414c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010414f:	c9                   	leave  
80104150:	c3                   	ret    

80104151 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80104151:	55                   	push   %ebp
80104152:	89 e5                	mov    %esp,%ebp
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 10             	sub    $0x10,%esp
80104159:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010415b:	b8 20 00 00 00       	mov    $0x20,%eax
80104160:	89 c6                	mov    %eax,%esi
80104162:	39 43 58             	cmp    %eax,0x58(%ebx)
80104165:	76 2e                	jbe    80104195 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104167:	6a 10                	push   $0x10
80104169:	50                   	push   %eax
8010416a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010416d:	50                   	push   %eax
8010416e:	53                   	push   %ebx
8010416f:	e8 7f d5 ff ff       	call   801016f3 <readi>
80104174:	83 c4 10             	add    $0x10,%esp
80104177:	83 f8 10             	cmp    $0x10,%eax
8010417a:	75 0c                	jne    80104188 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010417c:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104181:	75 1e                	jne    801041a1 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104183:	8d 46 10             	lea    0x10(%esi),%eax
80104186:	eb d8                	jmp    80104160 <isdirempty+0xf>
      panic("isdirempty: readi");
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	68 a8 70 10 80       	push   $0x801070a8
80104190:	e8 ac c1 ff ff       	call   80100341 <panic>
      return 0;
  }
  return 1;
80104195:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010419a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010419d:	5b                   	pop    %ebx
8010419e:	5e                   	pop    %esi
8010419f:	5d                   	pop    %ebp
801041a0:	c3                   	ret    
      return 0;
801041a1:	b8 00 00 00 00       	mov    $0x0,%eax
801041a6:	eb f2                	jmp    8010419a <isdirempty+0x49>

801041a8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801041a8:	55                   	push   %ebp
801041a9:	89 e5                	mov    %esp,%ebp
801041ab:	57                   	push   %edi
801041ac:	56                   	push   %esi
801041ad:	53                   	push   %ebx
801041ae:	83 ec 44             	sub    $0x44,%esp
801041b1:	89 d7                	mov    %edx,%edi
801041b3:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
801041b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801041b9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801041bc:	8d 55 d6             	lea    -0x2a(%ebp),%edx
801041bf:	52                   	push   %edx
801041c0:	50                   	push   %eax
801041c1:	e8 bc d9 ff ff       	call   80101b82 <nameiparent>
801041c6:	89 c6                	mov    %eax,%esi
801041c8:	83 c4 10             	add    $0x10,%esp
801041cb:	85 c0                	test   %eax,%eax
801041cd:	0f 84 32 01 00 00    	je     80104305 <create+0x15d>
    return 0;
  ilock(dp);
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	50                   	push   %eax
801041d7:	e8 2a d3 ff ff       	call   80101506 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801041dc:	83 c4 0c             	add    $0xc,%esp
801041df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801041e2:	50                   	push   %eax
801041e3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801041e6:	50                   	push   %eax
801041e7:	56                   	push   %esi
801041e8:	e8 4f d7 ff ff       	call   8010193c <dirlookup>
801041ed:	89 c3                	mov    %eax,%ebx
801041ef:	83 c4 10             	add    $0x10,%esp
801041f2:	85 c0                	test   %eax,%eax
801041f4:	74 3c                	je     80104232 <create+0x8a>
    iunlockput(dp);
801041f6:	83 ec 0c             	sub    $0xc,%esp
801041f9:	56                   	push   %esi
801041fa:	e8 aa d4 ff ff       	call   801016a9 <iunlockput>
    ilock(ip);
801041ff:	89 1c 24             	mov    %ebx,(%esp)
80104202:	e8 ff d2 ff ff       	call   80101506 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104207:	83 c4 10             	add    $0x10,%esp
8010420a:	66 83 ff 02          	cmp    $0x2,%di
8010420e:	75 07                	jne    80104217 <create+0x6f>
80104210:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104215:	74 11                	je     80104228 <create+0x80>
      return ip;
    iunlockput(ip);
80104217:	83 ec 0c             	sub    $0xc,%esp
8010421a:	53                   	push   %ebx
8010421b:	e8 89 d4 ff ff       	call   801016a9 <iunlockput>
    return 0;
80104220:	83 c4 10             	add    $0x10,%esp
80104223:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104228:	89 d8                	mov    %ebx,%eax
8010422a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010422d:	5b                   	pop    %ebx
8010422e:	5e                   	pop    %esi
8010422f:	5f                   	pop    %edi
80104230:	5d                   	pop    %ebp
80104231:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104232:	83 ec 08             	sub    $0x8,%esp
80104235:	0f bf c7             	movswl %di,%eax
80104238:	50                   	push   %eax
80104239:	ff 36                	push   (%esi)
8010423b:	e8 ce d0 ff ff       	call   8010130e <ialloc>
80104240:	89 c3                	mov    %eax,%ebx
80104242:	83 c4 10             	add    $0x10,%esp
80104245:	85 c0                	test   %eax,%eax
80104247:	74 53                	je     8010429c <create+0xf4>
  ilock(ip);
80104249:	83 ec 0c             	sub    $0xc,%esp
8010424c:	50                   	push   %eax
8010424d:	e8 b4 d2 ff ff       	call   80101506 <ilock>
  ip->major = major;
80104252:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104255:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104259:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010425c:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104260:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104266:	89 1c 24             	mov    %ebx,(%esp)
80104269:	e8 3f d1 ff ff       	call   801013ad <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
8010426e:	83 c4 10             	add    $0x10,%esp
80104271:	66 83 ff 01          	cmp    $0x1,%di
80104275:	74 32                	je     801042a9 <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
80104277:	83 ec 04             	sub    $0x4,%esp
8010427a:	ff 73 04             	push   0x4(%ebx)
8010427d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104280:	50                   	push   %eax
80104281:	56                   	push   %esi
80104282:	e8 32 d8 ff ff       	call   80101ab9 <dirlink>
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	85 c0                	test   %eax,%eax
8010428c:	78 6a                	js     801042f8 <create+0x150>
  iunlockput(dp);
8010428e:	83 ec 0c             	sub    $0xc,%esp
80104291:	56                   	push   %esi
80104292:	e8 12 d4 ff ff       	call   801016a9 <iunlockput>
  return ip;
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	eb 8c                	jmp    80104228 <create+0x80>
    panic("create: ialloc");
8010429c:	83 ec 0c             	sub    $0xc,%esp
8010429f:	68 ba 70 10 80       	push   $0x801070ba
801042a4:	e8 98 c0 ff ff       	call   80100341 <panic>
    dp->nlink++;  // for ".."
801042a9:	66 8b 46 56          	mov    0x56(%esi),%ax
801042ad:	40                   	inc    %eax
801042ae:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801042b2:	83 ec 0c             	sub    $0xc,%esp
801042b5:	56                   	push   %esi
801042b6:	e8 f2 d0 ff ff       	call   801013ad <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801042bb:	83 c4 0c             	add    $0xc,%esp
801042be:	ff 73 04             	push   0x4(%ebx)
801042c1:	68 ca 70 10 80       	push   $0x801070ca
801042c6:	53                   	push   %ebx
801042c7:	e8 ed d7 ff ff       	call   80101ab9 <dirlink>
801042cc:	83 c4 10             	add    $0x10,%esp
801042cf:	85 c0                	test   %eax,%eax
801042d1:	78 18                	js     801042eb <create+0x143>
801042d3:	83 ec 04             	sub    $0x4,%esp
801042d6:	ff 76 04             	push   0x4(%esi)
801042d9:	68 c9 70 10 80       	push   $0x801070c9
801042de:	53                   	push   %ebx
801042df:	e8 d5 d7 ff ff       	call   80101ab9 <dirlink>
801042e4:	83 c4 10             	add    $0x10,%esp
801042e7:	85 c0                	test   %eax,%eax
801042e9:	79 8c                	jns    80104277 <create+0xcf>
      panic("create dots");
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	68 cc 70 10 80       	push   $0x801070cc
801042f3:	e8 49 c0 ff ff       	call   80100341 <panic>
    panic("create: dirlink");
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 d8 70 10 80       	push   $0x801070d8
80104300:	e8 3c c0 ff ff       	call   80100341 <panic>
    return 0;
80104305:	89 c3                	mov    %eax,%ebx
80104307:	e9 1c ff ff ff       	jmp    80104228 <create+0x80>

8010430c <sys_dup>:
{
8010430c:	55                   	push   %ebp
8010430d:	89 e5                	mov    %esp,%ebp
8010430f:	53                   	push   %ebx
80104310:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104313:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104316:	ba 00 00 00 00       	mov    $0x0,%edx
8010431b:	b8 00 00 00 00       	mov    $0x0,%eax
80104320:	e8 98 fd ff ff       	call   801040bd <argfd>
80104325:	85 c0                	test   %eax,%eax
80104327:	78 23                	js     8010434c <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432c:	e8 ec fd ff ff       	call   8010411d <fdalloc>
80104331:	89 c3                	mov    %eax,%ebx
80104333:	85 c0                	test   %eax,%eax
80104335:	78 1c                	js     80104353 <sys_dup+0x47>
  filedup(f);
80104337:	83 ec 0c             	sub    $0xc,%esp
8010433a:	ff 75 f4             	push   -0xc(%ebp)
8010433d:	e8 05 c9 ff ff       	call   80100c47 <filedup>
  return fd;
80104342:	83 c4 10             	add    $0x10,%esp
}
80104345:	89 d8                	mov    %ebx,%eax
80104347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010434a:	c9                   	leave  
8010434b:	c3                   	ret    
    return -1;
8010434c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104351:	eb f2                	jmp    80104345 <sys_dup+0x39>
    return -1;
80104353:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104358:	eb eb                	jmp    80104345 <sys_dup+0x39>

8010435a <sys_dup2>:
{
8010435a:	55                   	push   %ebp
8010435b:	89 e5                	mov    %esp,%ebp
8010435d:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &oldfd, &f) < 0)
80104360:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104363:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104366:	b8 00 00 00 00       	mov    $0x0,%eax
8010436b:	e8 4d fd ff ff       	call   801040bd <argfd>
80104370:	85 c0                	test   %eax,%eax
80104372:	78 59                	js     801043cd <sys_dup2+0x73>
  if (argint(0, &newfd) < 0)
80104374:	83 ec 08             	sub    $0x8,%esp
80104377:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010437a:	50                   	push   %eax
8010437b:	6a 00                	push   $0x0
8010437d:	e8 21 fc ff ff       	call   80103fa3 <argint>
80104382:	83 c4 10             	add    $0x10,%esp
80104385:	85 c0                	test   %eax,%eax
80104387:	78 4b                	js     801043d4 <sys_dup2+0x7a>
  if (oldfd == newfd) {
80104389:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010438c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010438f:	74 3a                	je     801043cb <sys_dup2+0x71>
  if ((newf = myproc()->ofile[newfd]))
80104391:	e8 6d ed ff ff       	call   80103103 <myproc>
80104396:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104399:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010439d:	85 c0                	test   %eax,%eax
8010439f:	74 0c                	je     801043ad <sys_dup2+0x53>
    fileclose(newf);
801043a1:	83 ec 0c             	sub    $0xc,%esp
801043a4:	50                   	push   %eax
801043a5:	e8 e0 c8 ff ff       	call   80100c8a <fileclose>
801043aa:	83 c4 10             	add    $0x10,%esp
  myproc()->ofile[newfd] = f;
801043ad:	e8 51 ed ff ff       	call   80103103 <myproc>
801043b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043b5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801043b8:	89 54 88 28          	mov    %edx,0x28(%eax,%ecx,4)
  filedup(f);
801043bc:	83 ec 0c             	sub    $0xc,%esp
801043bf:	52                   	push   %edx
801043c0:	e8 82 c8 ff ff       	call   80100c47 <filedup>
  return newfd;
801043c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043c8:	83 c4 10             	add    $0x10,%esp
}
801043cb:	c9                   	leave  
801043cc:	c3                   	ret    
    return -1;
801043cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d2:	eb f7                	jmp    801043cb <sys_dup2+0x71>
    return -1;
801043d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d9:	eb f0                	jmp    801043cb <sys_dup2+0x71>

801043db <sys_read>:
{
801043db:	55                   	push   %ebp
801043dc:	89 e5                	mov    %esp,%ebp
801043de:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
801043e1:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043e4:	ba 00 00 00 00       	mov    $0x0,%edx
801043e9:	b8 00 00 00 00       	mov    $0x0,%eax
801043ee:	e8 ca fc ff ff       	call   801040bd <argfd>
801043f3:	85 c0                	test   %eax,%eax
801043f5:	78 43                	js     8010443a <sys_read+0x5f>
801043f7:	83 ec 08             	sub    $0x8,%esp
801043fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043fd:	50                   	push   %eax
801043fe:	6a 02                	push   $0x2
80104400:	e8 9e fb ff ff       	call   80103fa3 <argint>
80104405:	83 c4 10             	add    $0x10,%esp
80104408:	85 c0                	test   %eax,%eax
8010440a:	78 2e                	js     8010443a <sys_read+0x5f>
8010440c:	83 ec 04             	sub    $0x4,%esp
8010440f:	ff 75 f0             	push   -0x10(%ebp)
80104412:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104415:	50                   	push   %eax
80104416:	6a 01                	push   $0x1
80104418:	e8 ae fb ff ff       	call   80103fcb <argptr>
8010441d:	83 c4 10             	add    $0x10,%esp
80104420:	85 c0                	test   %eax,%eax
80104422:	78 16                	js     8010443a <sys_read+0x5f>
  return fileread(f, p, n);
80104424:	83 ec 04             	sub    $0x4,%esp
80104427:	ff 75 f0             	push   -0x10(%ebp)
8010442a:	ff 75 ec             	push   -0x14(%ebp)
8010442d:	ff 75 f4             	push   -0xc(%ebp)
80104430:	e8 4e c9 ff ff       	call   80100d83 <fileread>
80104435:	83 c4 10             	add    $0x10,%esp
}
80104438:	c9                   	leave  
80104439:	c3                   	ret    
    return -1;
8010443a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443f:	eb f7                	jmp    80104438 <sys_read+0x5d>

80104441 <sys_write>:
{
80104441:	55                   	push   %ebp
80104442:	89 e5                	mov    %esp,%ebp
80104444:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104447:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010444a:	ba 00 00 00 00       	mov    $0x0,%edx
8010444f:	b8 00 00 00 00       	mov    $0x0,%eax
80104454:	e8 64 fc ff ff       	call   801040bd <argfd>
80104459:	85 c0                	test   %eax,%eax
8010445b:	78 43                	js     801044a0 <sys_write+0x5f>
8010445d:	83 ec 08             	sub    $0x8,%esp
80104460:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104463:	50                   	push   %eax
80104464:	6a 02                	push   $0x2
80104466:	e8 38 fb ff ff       	call   80103fa3 <argint>
8010446b:	83 c4 10             	add    $0x10,%esp
8010446e:	85 c0                	test   %eax,%eax
80104470:	78 2e                	js     801044a0 <sys_write+0x5f>
80104472:	83 ec 04             	sub    $0x4,%esp
80104475:	ff 75 f0             	push   -0x10(%ebp)
80104478:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010447b:	50                   	push   %eax
8010447c:	6a 01                	push   $0x1
8010447e:	e8 48 fb ff ff       	call   80103fcb <argptr>
80104483:	83 c4 10             	add    $0x10,%esp
80104486:	85 c0                	test   %eax,%eax
80104488:	78 16                	js     801044a0 <sys_write+0x5f>
  return filewrite(f, p, n);
8010448a:	83 ec 04             	sub    $0x4,%esp
8010448d:	ff 75 f0             	push   -0x10(%ebp)
80104490:	ff 75 ec             	push   -0x14(%ebp)
80104493:	ff 75 f4             	push   -0xc(%ebp)
80104496:	e8 6d c9 ff ff       	call   80100e08 <filewrite>
8010449b:	83 c4 10             	add    $0x10,%esp
}
8010449e:	c9                   	leave  
8010449f:	c3                   	ret    
    return -1;
801044a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044a5:	eb f7                	jmp    8010449e <sys_write+0x5d>

801044a7 <sys_close>:
{
801044a7:	55                   	push   %ebp
801044a8:	89 e5                	mov    %esp,%ebp
801044aa:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801044ad:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801044b0:	8d 55 f4             	lea    -0xc(%ebp),%edx
801044b3:	b8 00 00 00 00       	mov    $0x0,%eax
801044b8:	e8 00 fc ff ff       	call   801040bd <argfd>
801044bd:	85 c0                	test   %eax,%eax
801044bf:	78 25                	js     801044e6 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
801044c1:	e8 3d ec ff ff       	call   80103103 <myproc>
801044c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c9:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801044d0:	00 
  fileclose(f);
801044d1:	83 ec 0c             	sub    $0xc,%esp
801044d4:	ff 75 f0             	push   -0x10(%ebp)
801044d7:	e8 ae c7 ff ff       	call   80100c8a <fileclose>
  return 0;
801044dc:	83 c4 10             	add    $0x10,%esp
801044df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044e4:	c9                   	leave  
801044e5:	c3                   	ret    
    return -1;
801044e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044eb:	eb f7                	jmp    801044e4 <sys_close+0x3d>

801044ed <sys_fstat>:
{
801044ed:	55                   	push   %ebp
801044ee:	89 e5                	mov    %esp,%ebp
801044f0:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801044f3:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044f6:	ba 00 00 00 00       	mov    $0x0,%edx
801044fb:	b8 00 00 00 00       	mov    $0x0,%eax
80104500:	e8 b8 fb ff ff       	call   801040bd <argfd>
80104505:	85 c0                	test   %eax,%eax
80104507:	78 2a                	js     80104533 <sys_fstat+0x46>
80104509:	83 ec 04             	sub    $0x4,%esp
8010450c:	6a 14                	push   $0x14
8010450e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104511:	50                   	push   %eax
80104512:	6a 01                	push   $0x1
80104514:	e8 b2 fa ff ff       	call   80103fcb <argptr>
80104519:	83 c4 10             	add    $0x10,%esp
8010451c:	85 c0                	test   %eax,%eax
8010451e:	78 13                	js     80104533 <sys_fstat+0x46>
  return filestat(f, st);
80104520:	83 ec 08             	sub    $0x8,%esp
80104523:	ff 75 f0             	push   -0x10(%ebp)
80104526:	ff 75 f4             	push   -0xc(%ebp)
80104529:	e8 0e c8 ff ff       	call   80100d3c <filestat>
8010452e:	83 c4 10             	add    $0x10,%esp
}
80104531:	c9                   	leave  
80104532:	c3                   	ret    
    return -1;
80104533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104538:	eb f7                	jmp    80104531 <sys_fstat+0x44>

8010453a <sys_link>:
{
8010453a:	55                   	push   %ebp
8010453b:	89 e5                	mov    %esp,%ebp
8010453d:	56                   	push   %esi
8010453e:	53                   	push   %ebx
8010453f:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104542:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104545:	50                   	push   %eax
80104546:	6a 00                	push   $0x0
80104548:	e8 e6 fa ff ff       	call   80104033 <argstr>
8010454d:	83 c4 10             	add    $0x10,%esp
80104550:	85 c0                	test   %eax,%eax
80104552:	0f 88 d1 00 00 00    	js     80104629 <sys_link+0xef>
80104558:	83 ec 08             	sub    $0x8,%esp
8010455b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010455e:	50                   	push   %eax
8010455f:	6a 01                	push   $0x1
80104561:	e8 cd fa ff ff       	call   80104033 <argstr>
80104566:	83 c4 10             	add    $0x10,%esp
80104569:	85 c0                	test   %eax,%eax
8010456b:	0f 88 b8 00 00 00    	js     80104629 <sys_link+0xef>
  begin_op();
80104571:	e8 66 e1 ff ff       	call   801026dc <begin_op>
  if((ip = namei(old)) == 0){
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	ff 75 e0             	push   -0x20(%ebp)
8010457c:	e8 e9 d5 ff ff       	call   80101b6a <namei>
80104581:	89 c3                	mov    %eax,%ebx
80104583:	83 c4 10             	add    $0x10,%esp
80104586:	85 c0                	test   %eax,%eax
80104588:	0f 84 a2 00 00 00    	je     80104630 <sys_link+0xf6>
  ilock(ip);
8010458e:	83 ec 0c             	sub    $0xc,%esp
80104591:	50                   	push   %eax
80104592:	e8 6f cf ff ff       	call   80101506 <ilock>
  if(ip->type == T_DIR){
80104597:	83 c4 10             	add    $0x10,%esp
8010459a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010459f:	0f 84 97 00 00 00    	je     8010463c <sys_link+0x102>
  ip->nlink++;
801045a5:	66 8b 43 56          	mov    0x56(%ebx),%ax
801045a9:	40                   	inc    %eax
801045aa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	53                   	push   %ebx
801045b2:	e8 f6 cd ff ff       	call   801013ad <iupdate>
  iunlock(ip);
801045b7:	89 1c 24             	mov    %ebx,(%esp)
801045ba:	e8 07 d0 ff ff       	call   801015c6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801045bf:	83 c4 08             	add    $0x8,%esp
801045c2:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045c5:	50                   	push   %eax
801045c6:	ff 75 e4             	push   -0x1c(%ebp)
801045c9:	e8 b4 d5 ff ff       	call   80101b82 <nameiparent>
801045ce:	89 c6                	mov    %eax,%esi
801045d0:	83 c4 10             	add    $0x10,%esp
801045d3:	85 c0                	test   %eax,%eax
801045d5:	0f 84 85 00 00 00    	je     80104660 <sys_link+0x126>
  ilock(dp);
801045db:	83 ec 0c             	sub    $0xc,%esp
801045de:	50                   	push   %eax
801045df:	e8 22 cf ff ff       	call   80101506 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	8b 03                	mov    (%ebx),%eax
801045e9:	39 06                	cmp    %eax,(%esi)
801045eb:	75 67                	jne    80104654 <sys_link+0x11a>
801045ed:	83 ec 04             	sub    $0x4,%esp
801045f0:	ff 73 04             	push   0x4(%ebx)
801045f3:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045f6:	50                   	push   %eax
801045f7:	56                   	push   %esi
801045f8:	e8 bc d4 ff ff       	call   80101ab9 <dirlink>
801045fd:	83 c4 10             	add    $0x10,%esp
80104600:	85 c0                	test   %eax,%eax
80104602:	78 50                	js     80104654 <sys_link+0x11a>
  iunlockput(dp);
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	56                   	push   %esi
80104608:	e8 9c d0 ff ff       	call   801016a9 <iunlockput>
  iput(ip);
8010460d:	89 1c 24             	mov    %ebx,(%esp)
80104610:	e8 f6 cf ff ff       	call   8010160b <iput>
  end_op();
80104615:	e8 3e e1 ff ff       	call   80102758 <end_op>
  return 0;
8010461a:	83 c4 10             	add    $0x10,%esp
8010461d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104622:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104625:	5b                   	pop    %ebx
80104626:	5e                   	pop    %esi
80104627:	5d                   	pop    %ebp
80104628:	c3                   	ret    
    return -1;
80104629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010462e:	eb f2                	jmp    80104622 <sys_link+0xe8>
    end_op();
80104630:	e8 23 e1 ff ff       	call   80102758 <end_op>
    return -1;
80104635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463a:	eb e6                	jmp    80104622 <sys_link+0xe8>
    iunlockput(ip);
8010463c:	83 ec 0c             	sub    $0xc,%esp
8010463f:	53                   	push   %ebx
80104640:	e8 64 d0 ff ff       	call   801016a9 <iunlockput>
    end_op();
80104645:	e8 0e e1 ff ff       	call   80102758 <end_op>
    return -1;
8010464a:	83 c4 10             	add    $0x10,%esp
8010464d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104652:	eb ce                	jmp    80104622 <sys_link+0xe8>
    iunlockput(dp);
80104654:	83 ec 0c             	sub    $0xc,%esp
80104657:	56                   	push   %esi
80104658:	e8 4c d0 ff ff       	call   801016a9 <iunlockput>
    goto bad;
8010465d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	53                   	push   %ebx
80104664:	e8 9d ce ff ff       	call   80101506 <ilock>
  ip->nlink--;
80104669:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010466d:	48                   	dec    %eax
8010466e:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104672:	89 1c 24             	mov    %ebx,(%esp)
80104675:	e8 33 cd ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
8010467a:	89 1c 24             	mov    %ebx,(%esp)
8010467d:	e8 27 d0 ff ff       	call   801016a9 <iunlockput>
  end_op();
80104682:	e8 d1 e0 ff ff       	call   80102758 <end_op>
  return -1;
80104687:	83 c4 10             	add    $0x10,%esp
8010468a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468f:	eb 91                	jmp    80104622 <sys_link+0xe8>

80104691 <sys_unlink>:
{
80104691:	55                   	push   %ebp
80104692:	89 e5                	mov    %esp,%ebp
80104694:	57                   	push   %edi
80104695:	56                   	push   %esi
80104696:	53                   	push   %ebx
80104697:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010469a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010469d:	50                   	push   %eax
8010469e:	6a 00                	push   $0x0
801046a0:	e8 8e f9 ff ff       	call   80104033 <argstr>
801046a5:	83 c4 10             	add    $0x10,%esp
801046a8:	85 c0                	test   %eax,%eax
801046aa:	0f 88 7f 01 00 00    	js     8010482f <sys_unlink+0x19e>
  begin_op();
801046b0:	e8 27 e0 ff ff       	call   801026dc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801046b5:	83 ec 08             	sub    $0x8,%esp
801046b8:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046bb:	50                   	push   %eax
801046bc:	ff 75 c4             	push   -0x3c(%ebp)
801046bf:	e8 be d4 ff ff       	call   80101b82 <nameiparent>
801046c4:	89 c6                	mov    %eax,%esi
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	85 c0                	test   %eax,%eax
801046cb:	0f 84 eb 00 00 00    	je     801047bc <sys_unlink+0x12b>
  ilock(dp);
801046d1:	83 ec 0c             	sub    $0xc,%esp
801046d4:	50                   	push   %eax
801046d5:	e8 2c ce ff ff       	call   80101506 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801046da:	83 c4 08             	add    $0x8,%esp
801046dd:	68 ca 70 10 80       	push   $0x801070ca
801046e2:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046e5:	50                   	push   %eax
801046e6:	e8 3c d2 ff ff       	call   80101927 <namecmp>
801046eb:	83 c4 10             	add    $0x10,%esp
801046ee:	85 c0                	test   %eax,%eax
801046f0:	0f 84 fa 00 00 00    	je     801047f0 <sys_unlink+0x15f>
801046f6:	83 ec 08             	sub    $0x8,%esp
801046f9:	68 c9 70 10 80       	push   $0x801070c9
801046fe:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104701:	50                   	push   %eax
80104702:	e8 20 d2 ff ff       	call   80101927 <namecmp>
80104707:	83 c4 10             	add    $0x10,%esp
8010470a:	85 c0                	test   %eax,%eax
8010470c:	0f 84 de 00 00 00    	je     801047f0 <sys_unlink+0x15f>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104712:	83 ec 04             	sub    $0x4,%esp
80104715:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104718:	50                   	push   %eax
80104719:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010471c:	50                   	push   %eax
8010471d:	56                   	push   %esi
8010471e:	e8 19 d2 ff ff       	call   8010193c <dirlookup>
80104723:	89 c3                	mov    %eax,%ebx
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	85 c0                	test   %eax,%eax
8010472a:	0f 84 c0 00 00 00    	je     801047f0 <sys_unlink+0x15f>
  ilock(ip);
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	50                   	push   %eax
80104734:	e8 cd cd ff ff       	call   80101506 <ilock>
  if(ip->nlink < 1)
80104739:	83 c4 10             	add    $0x10,%esp
8010473c:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104741:	0f 8e 81 00 00 00    	jle    801047c8 <sys_unlink+0x137>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104747:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010474c:	0f 84 83 00 00 00    	je     801047d5 <sys_unlink+0x144>
  memset(&de, 0, sizeof(de));
80104752:	83 ec 04             	sub    $0x4,%esp
80104755:	6a 10                	push   $0x10
80104757:	6a 00                	push   $0x0
80104759:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010475c:	57                   	push   %edi
8010475d:	e8 0e f6 ff ff       	call   80103d70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104762:	6a 10                	push   $0x10
80104764:	ff 75 c0             	push   -0x40(%ebp)
80104767:	57                   	push   %edi
80104768:	56                   	push   %esi
80104769:	e8 85 d0 ff ff       	call   801017f3 <writei>
8010476e:	83 c4 20             	add    $0x20,%esp
80104771:	83 f8 10             	cmp    $0x10,%eax
80104774:	0f 85 8e 00 00 00    	jne    80104808 <sys_unlink+0x177>
  if(ip->type == T_DIR){
8010477a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010477f:	0f 84 90 00 00 00    	je     80104815 <sys_unlink+0x184>
  iunlockput(dp);
80104785:	83 ec 0c             	sub    $0xc,%esp
80104788:	56                   	push   %esi
80104789:	e8 1b cf ff ff       	call   801016a9 <iunlockput>
  ip->nlink--;
8010478e:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104792:	48                   	dec    %eax
80104793:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104797:	89 1c 24             	mov    %ebx,(%esp)
8010479a:	e8 0e cc ff ff       	call   801013ad <iupdate>
  iunlockput(ip);
8010479f:	89 1c 24             	mov    %ebx,(%esp)
801047a2:	e8 02 cf ff ff       	call   801016a9 <iunlockput>
  end_op();
801047a7:	e8 ac df ff ff       	call   80102758 <end_op>
  return 0;
801047ac:	83 c4 10             	add    $0x10,%esp
801047af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047b7:	5b                   	pop    %ebx
801047b8:	5e                   	pop    %esi
801047b9:	5f                   	pop    %edi
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
    end_op();
801047bc:	e8 97 df ff ff       	call   80102758 <end_op>
    return -1;
801047c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047c6:	eb ec                	jmp    801047b4 <sys_unlink+0x123>
    panic("unlink: nlink < 1");
801047c8:	83 ec 0c             	sub    $0xc,%esp
801047cb:	68 e8 70 10 80       	push   $0x801070e8
801047d0:	e8 6c bb ff ff       	call   80100341 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047d5:	89 d8                	mov    %ebx,%eax
801047d7:	e8 75 f9 ff ff       	call   80104151 <isdirempty>
801047dc:	85 c0                	test   %eax,%eax
801047de:	0f 85 6e ff ff ff    	jne    80104752 <sys_unlink+0xc1>
    iunlockput(ip);
801047e4:	83 ec 0c             	sub    $0xc,%esp
801047e7:	53                   	push   %ebx
801047e8:	e8 bc ce ff ff       	call   801016a9 <iunlockput>
    goto bad;
801047ed:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801047f0:	83 ec 0c             	sub    $0xc,%esp
801047f3:	56                   	push   %esi
801047f4:	e8 b0 ce ff ff       	call   801016a9 <iunlockput>
  end_op();
801047f9:	e8 5a df ff ff       	call   80102758 <end_op>
  return -1;
801047fe:	83 c4 10             	add    $0x10,%esp
80104801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104806:	eb ac                	jmp    801047b4 <sys_unlink+0x123>
    panic("unlink: writei");
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	68 fa 70 10 80       	push   $0x801070fa
80104810:	e8 2c bb ff ff       	call   80100341 <panic>
    dp->nlink--;
80104815:	66 8b 46 56          	mov    0x56(%esi),%ax
80104819:	48                   	dec    %eax
8010481a:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010481e:	83 ec 0c             	sub    $0xc,%esp
80104821:	56                   	push   %esi
80104822:	e8 86 cb ff ff       	call   801013ad <iupdate>
80104827:	83 c4 10             	add    $0x10,%esp
8010482a:	e9 56 ff ff ff       	jmp    80104785 <sys_unlink+0xf4>
    return -1;
8010482f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104834:	e9 7b ff ff ff       	jmp    801047b4 <sys_unlink+0x123>

80104839 <sys_open>:

int
sys_open(void)
{
80104839:	55                   	push   %ebp
8010483a:	89 e5                	mov    %esp,%ebp
8010483c:	57                   	push   %edi
8010483d:	56                   	push   %esi
8010483e:	53                   	push   %ebx
8010483f:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104842:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104845:	50                   	push   %eax
80104846:	6a 00                	push   $0x0
80104848:	e8 e6 f7 ff ff       	call   80104033 <argstr>
8010484d:	83 c4 10             	add    $0x10,%esp
80104850:	85 c0                	test   %eax,%eax
80104852:	0f 88 a0 00 00 00    	js     801048f8 <sys_open+0xbf>
80104858:	83 ec 08             	sub    $0x8,%esp
8010485b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010485e:	50                   	push   %eax
8010485f:	6a 01                	push   $0x1
80104861:	e8 3d f7 ff ff       	call   80103fa3 <argint>
80104866:	83 c4 10             	add    $0x10,%esp
80104869:	85 c0                	test   %eax,%eax
8010486b:	0f 88 87 00 00 00    	js     801048f8 <sys_open+0xbf>
    return -1;

  begin_op();
80104871:	e8 66 de ff ff       	call   801026dc <begin_op>

  if(omode & O_CREATE){
80104876:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
8010487a:	0f 84 8b 00 00 00    	je     8010490b <sys_open+0xd2>
    ip = create(path, T_FILE, 0, 0);
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	6a 00                	push   $0x0
80104885:	b9 00 00 00 00       	mov    $0x0,%ecx
8010488a:	ba 02 00 00 00       	mov    $0x2,%edx
8010488f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104892:	e8 11 f9 ff ff       	call   801041a8 <create>
80104897:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104899:	83 c4 10             	add    $0x10,%esp
8010489c:	85 c0                	test   %eax,%eax
8010489e:	74 5f                	je     801048ff <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801048a0:	e8 41 c3 ff ff       	call   80100be6 <filealloc>
801048a5:	89 c3                	mov    %eax,%ebx
801048a7:	85 c0                	test   %eax,%eax
801048a9:	0f 84 b5 00 00 00    	je     80104964 <sys_open+0x12b>
801048af:	e8 69 f8 ff ff       	call   8010411d <fdalloc>
801048b4:	89 c7                	mov    %eax,%edi
801048b6:	85 c0                	test   %eax,%eax
801048b8:	0f 88 a6 00 00 00    	js     80104964 <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801048be:	83 ec 0c             	sub    $0xc,%esp
801048c1:	56                   	push   %esi
801048c2:	e8 ff cc ff ff       	call   801015c6 <iunlock>
  end_op();
801048c7:	e8 8c de ff ff       	call   80102758 <end_op>

  f->type = FD_INODE;
801048cc:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
801048d2:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801048d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801048dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	a8 01                	test   $0x1,%al
801048e4:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801048e8:	a8 03                	test   $0x3,%al
801048ea:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801048ee:	89 f8                	mov    %edi,%eax
801048f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5f                   	pop    %edi
801048f6:	5d                   	pop    %ebp
801048f7:	c3                   	ret    
    return -1;
801048f8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048fd:	eb ef                	jmp    801048ee <sys_open+0xb5>
      end_op();
801048ff:	e8 54 de ff ff       	call   80102758 <end_op>
      return -1;
80104904:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104909:	eb e3                	jmp    801048ee <sys_open+0xb5>
    if((ip = namei(path)) == 0){
8010490b:	83 ec 0c             	sub    $0xc,%esp
8010490e:	ff 75 e4             	push   -0x1c(%ebp)
80104911:	e8 54 d2 ff ff       	call   80101b6a <namei>
80104916:	89 c6                	mov    %eax,%esi
80104918:	83 c4 10             	add    $0x10,%esp
8010491b:	85 c0                	test   %eax,%eax
8010491d:	74 39                	je     80104958 <sys_open+0x11f>
    ilock(ip);
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	50                   	push   %eax
80104923:	e8 de cb ff ff       	call   80101506 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104928:	83 c4 10             	add    $0x10,%esp
8010492b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104930:	0f 85 6a ff ff ff    	jne    801048a0 <sys_open+0x67>
80104936:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010493a:	0f 84 60 ff ff ff    	je     801048a0 <sys_open+0x67>
      iunlockput(ip);
80104940:	83 ec 0c             	sub    $0xc,%esp
80104943:	56                   	push   %esi
80104944:	e8 60 cd ff ff       	call   801016a9 <iunlockput>
      end_op();
80104949:	e8 0a de ff ff       	call   80102758 <end_op>
      return -1;
8010494e:	83 c4 10             	add    $0x10,%esp
80104951:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104956:	eb 96                	jmp    801048ee <sys_open+0xb5>
      end_op();
80104958:	e8 fb dd ff ff       	call   80102758 <end_op>
      return -1;
8010495d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104962:	eb 8a                	jmp    801048ee <sys_open+0xb5>
    if(f)
80104964:	85 db                	test   %ebx,%ebx
80104966:	74 0c                	je     80104974 <sys_open+0x13b>
      fileclose(f);
80104968:	83 ec 0c             	sub    $0xc,%esp
8010496b:	53                   	push   %ebx
8010496c:	e8 19 c3 ff ff       	call   80100c8a <fileclose>
80104971:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	56                   	push   %esi
80104978:	e8 2c cd ff ff       	call   801016a9 <iunlockput>
    end_op();
8010497d:	e8 d6 dd ff ff       	call   80102758 <end_op>
    return -1;
80104982:	83 c4 10             	add    $0x10,%esp
80104985:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010498a:	e9 5f ff ff ff       	jmp    801048ee <sys_open+0xb5>

8010498f <sys_mkdir>:

int
sys_mkdir(void)
{
8010498f:	55                   	push   %ebp
80104990:	89 e5                	mov    %esp,%ebp
80104992:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104995:	e8 42 dd ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010499a:	83 ec 08             	sub    $0x8,%esp
8010499d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049a0:	50                   	push   %eax
801049a1:	6a 00                	push   $0x0
801049a3:	e8 8b f6 ff ff       	call   80104033 <argstr>
801049a8:	83 c4 10             	add    $0x10,%esp
801049ab:	85 c0                	test   %eax,%eax
801049ad:	78 36                	js     801049e5 <sys_mkdir+0x56>
801049af:	83 ec 0c             	sub    $0xc,%esp
801049b2:	6a 00                	push   $0x0
801049b4:	b9 00 00 00 00       	mov    $0x0,%ecx
801049b9:	ba 01 00 00 00       	mov    $0x1,%edx
801049be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c1:	e8 e2 f7 ff ff       	call   801041a8 <create>
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	85 c0                	test   %eax,%eax
801049cb:	74 18                	je     801049e5 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
801049cd:	83 ec 0c             	sub    $0xc,%esp
801049d0:	50                   	push   %eax
801049d1:	e8 d3 cc ff ff       	call   801016a9 <iunlockput>
  end_op();
801049d6:	e8 7d dd ff ff       	call   80102758 <end_op>
  return 0;
801049db:	83 c4 10             	add    $0x10,%esp
801049de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049e3:	c9                   	leave  
801049e4:	c3                   	ret    
    end_op();
801049e5:	e8 6e dd ff ff       	call   80102758 <end_op>
    return -1;
801049ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ef:	eb f2                	jmp    801049e3 <sys_mkdir+0x54>

801049f1 <sys_mknod>:

int
sys_mknod(void)
{
801049f1:	55                   	push   %ebp
801049f2:	89 e5                	mov    %esp,%ebp
801049f4:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801049f7:	e8 e0 dc ff ff       	call   801026dc <begin_op>
  if((argstr(0, &path)) < 0 ||
801049fc:	83 ec 08             	sub    $0x8,%esp
801049ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a02:	50                   	push   %eax
80104a03:	6a 00                	push   $0x0
80104a05:	e8 29 f6 ff ff       	call   80104033 <argstr>
80104a0a:	83 c4 10             	add    $0x10,%esp
80104a0d:	85 c0                	test   %eax,%eax
80104a0f:	78 62                	js     80104a73 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104a11:	83 ec 08             	sub    $0x8,%esp
80104a14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a17:	50                   	push   %eax
80104a18:	6a 01                	push   $0x1
80104a1a:	e8 84 f5 ff ff       	call   80103fa3 <argint>
  if((argstr(0, &path)) < 0 ||
80104a1f:	83 c4 10             	add    $0x10,%esp
80104a22:	85 c0                	test   %eax,%eax
80104a24:	78 4d                	js     80104a73 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104a26:	83 ec 08             	sub    $0x8,%esp
80104a29:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a2c:	50                   	push   %eax
80104a2d:	6a 02                	push   $0x2
80104a2f:	e8 6f f5 ff ff       	call   80103fa3 <argint>
     argint(1, &major) < 0 ||
80104a34:	83 c4 10             	add    $0x10,%esp
80104a37:	85 c0                	test   %eax,%eax
80104a39:	78 38                	js     80104a73 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104a3b:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a46:	50                   	push   %eax
80104a47:	ba 03 00 00 00       	mov    $0x3,%edx
80104a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4f:	e8 54 f7 ff ff       	call   801041a8 <create>
     argint(2, &minor) < 0 ||
80104a54:	83 c4 10             	add    $0x10,%esp
80104a57:	85 c0                	test   %eax,%eax
80104a59:	74 18                	je     80104a73 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	50                   	push   %eax
80104a5f:	e8 45 cc ff ff       	call   801016a9 <iunlockput>
  end_op();
80104a64:	e8 ef dc ff ff       	call   80102758 <end_op>
  return 0;
80104a69:	83 c4 10             	add    $0x10,%esp
80104a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a71:	c9                   	leave  
80104a72:	c3                   	ret    
    end_op();
80104a73:	e8 e0 dc ff ff       	call   80102758 <end_op>
    return -1;
80104a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a7d:	eb f2                	jmp    80104a71 <sys_mknod+0x80>

80104a7f <sys_chdir>:

int
sys_chdir(void)
{
80104a7f:	55                   	push   %ebp
80104a80:	89 e5                	mov    %esp,%ebp
80104a82:	56                   	push   %esi
80104a83:	53                   	push   %ebx
80104a84:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104a87:	e8 77 e6 ff ff       	call   80103103 <myproc>
80104a8c:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104a8e:	e8 49 dc ff ff       	call   801026dc <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104a93:	83 ec 08             	sub    $0x8,%esp
80104a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a99:	50                   	push   %eax
80104a9a:	6a 00                	push   $0x0
80104a9c:	e8 92 f5 ff ff       	call   80104033 <argstr>
80104aa1:	83 c4 10             	add    $0x10,%esp
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	78 52                	js     80104afa <sys_chdir+0x7b>
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	ff 75 f4             	push   -0xc(%ebp)
80104aae:	e8 b7 d0 ff ff       	call   80101b6a <namei>
80104ab3:	89 c3                	mov    %eax,%ebx
80104ab5:	83 c4 10             	add    $0x10,%esp
80104ab8:	85 c0                	test   %eax,%eax
80104aba:	74 3e                	je     80104afa <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104abc:	83 ec 0c             	sub    $0xc,%esp
80104abf:	50                   	push   %eax
80104ac0:	e8 41 ca ff ff       	call   80101506 <ilock>
  if(ip->type != T_DIR){
80104ac5:	83 c4 10             	add    $0x10,%esp
80104ac8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104acd:	75 37                	jne    80104b06 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	53                   	push   %ebx
80104ad3:	e8 ee ca ff ff       	call   801015c6 <iunlock>
  iput(curproc->cwd);
80104ad8:	83 c4 04             	add    $0x4,%esp
80104adb:	ff 76 68             	push   0x68(%esi)
80104ade:	e8 28 cb ff ff       	call   8010160b <iput>
  end_op();
80104ae3:	e8 70 dc ff ff       	call   80102758 <end_op>
  curproc->cwd = ip;
80104ae8:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104aeb:	83 c4 10             	add    $0x10,%esp
80104aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104af3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af6:	5b                   	pop    %ebx
80104af7:	5e                   	pop    %esi
80104af8:	5d                   	pop    %ebp
80104af9:	c3                   	ret    
    end_op();
80104afa:	e8 59 dc ff ff       	call   80102758 <end_op>
    return -1;
80104aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b04:	eb ed                	jmp    80104af3 <sys_chdir+0x74>
    iunlockput(ip);
80104b06:	83 ec 0c             	sub    $0xc,%esp
80104b09:	53                   	push   %ebx
80104b0a:	e8 9a cb ff ff       	call   801016a9 <iunlockput>
    end_op();
80104b0f:	e8 44 dc ff ff       	call   80102758 <end_op>
    return -1;
80104b14:	83 c4 10             	add    $0x10,%esp
80104b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b1c:	eb d5                	jmp    80104af3 <sys_chdir+0x74>

80104b1e <sys_exec>:

int
sys_exec(void)
{
80104b1e:	55                   	push   %ebp
80104b1f:	89 e5                	mov    %esp,%ebp
80104b21:	53                   	push   %ebx
80104b22:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104b28:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b2b:	50                   	push   %eax
80104b2c:	6a 00                	push   $0x0
80104b2e:	e8 00 f5 ff ff       	call   80104033 <argstr>
80104b33:	83 c4 10             	add    $0x10,%esp
80104b36:	85 c0                	test   %eax,%eax
80104b38:	78 38                	js     80104b72 <sys_exec+0x54>
80104b3a:	83 ec 08             	sub    $0x8,%esp
80104b3d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104b43:	50                   	push   %eax
80104b44:	6a 01                	push   $0x1
80104b46:	e8 58 f4 ff ff       	call   80103fa3 <argint>
80104b4b:	83 c4 10             	add    $0x10,%esp
80104b4e:	85 c0                	test   %eax,%eax
80104b50:	78 20                	js     80104b72 <sys_exec+0x54>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104b52:	83 ec 04             	sub    $0x4,%esp
80104b55:	68 80 00 00 00       	push   $0x80
80104b5a:	6a 00                	push   $0x0
80104b5c:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b62:	50                   	push   %eax
80104b63:	e8 08 f2 ff ff       	call   80103d70 <memset>
80104b68:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104b6b:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b70:	eb 2a                	jmp    80104b9c <sys_exec+0x7e>
    return -1;
80104b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b77:	eb 76                	jmp    80104bef <sys_exec+0xd1>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104b79:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104b80:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104b84:	83 ec 08             	sub    $0x8,%esp
80104b87:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b8d:	50                   	push   %eax
80104b8e:	ff 75 f4             	push   -0xc(%ebp)
80104b91:	e8 fa bc ff ff       	call   80100890 <exec>
80104b96:	83 c4 10             	add    $0x10,%esp
80104b99:	eb 54                	jmp    80104bef <sys_exec+0xd1>
  for(i=0;; i++){
80104b9b:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104b9c:	83 fb 1f             	cmp    $0x1f,%ebx
80104b9f:	77 49                	ja     80104bea <sys_exec+0xcc>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104ba1:	83 ec 08             	sub    $0x8,%esp
80104ba4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104baa:	50                   	push   %eax
80104bab:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104bb1:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104bb4:	50                   	push   %eax
80104bb5:	e8 71 f3 ff ff       	call   80103f2b <fetchint>
80104bba:	83 c4 10             	add    $0x10,%esp
80104bbd:	85 c0                	test   %eax,%eax
80104bbf:	78 33                	js     80104bf4 <sys_exec+0xd6>
    if(uarg == 0){
80104bc1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104bc7:	85 c0                	test   %eax,%eax
80104bc9:	74 ae                	je     80104b79 <sys_exec+0x5b>
    if(fetchstr(uarg, &argv[i]) < 0)
80104bcb:	83 ec 08             	sub    $0x8,%esp
80104bce:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104bd5:	52                   	push   %edx
80104bd6:	50                   	push   %eax
80104bd7:	e8 8a f3 ff ff       	call   80103f66 <fetchstr>
80104bdc:	83 c4 10             	add    $0x10,%esp
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	79 b8                	jns    80104b9b <sys_exec+0x7d>
      return -1;
80104be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be8:	eb 05                	jmp    80104bef <sys_exec+0xd1>
      return -1;
80104bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf2:	c9                   	leave  
80104bf3:	c3                   	ret    
      return -1;
80104bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf9:	eb f4                	jmp    80104bef <sys_exec+0xd1>

80104bfb <sys_pipe>:

int
sys_pipe(void)
{
80104bfb:	55                   	push   %ebp
80104bfc:	89 e5                	mov    %esp,%ebp
80104bfe:	53                   	push   %ebx
80104bff:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c02:	6a 08                	push   $0x8
80104c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c07:	50                   	push   %eax
80104c08:	6a 00                	push   $0x0
80104c0a:	e8 bc f3 ff ff       	call   80103fcb <argptr>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	78 79                	js     80104c8f <sys_pipe+0x94>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c16:	83 ec 08             	sub    $0x8,%esp
80104c19:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c1c:	50                   	push   %eax
80104c1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c20:	50                   	push   %eax
80104c21:	e8 2d e0 ff ff       	call   80102c53 <pipealloc>
80104c26:	83 c4 10             	add    $0x10,%esp
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	78 69                	js     80104c96 <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c30:	e8 e8 f4 ff ff       	call   8010411d <fdalloc>
80104c35:	89 c3                	mov    %eax,%ebx
80104c37:	85 c0                	test   %eax,%eax
80104c39:	78 21                	js     80104c5c <sys_pipe+0x61>
80104c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c3e:	e8 da f4 ff ff       	call   8010411d <fdalloc>
80104c43:	85 c0                	test   %eax,%eax
80104c45:	78 15                	js     80104c5c <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c4a:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c4f:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5a:	c9                   	leave  
80104c5b:	c3                   	ret    
    if(fd0 >= 0)
80104c5c:	85 db                	test   %ebx,%ebx
80104c5e:	79 20                	jns    80104c80 <sys_pipe+0x85>
    fileclose(rf);
80104c60:	83 ec 0c             	sub    $0xc,%esp
80104c63:	ff 75 f0             	push   -0x10(%ebp)
80104c66:	e8 1f c0 ff ff       	call   80100c8a <fileclose>
    fileclose(wf);
80104c6b:	83 c4 04             	add    $0x4,%esp
80104c6e:	ff 75 ec             	push   -0x14(%ebp)
80104c71:	e8 14 c0 ff ff       	call   80100c8a <fileclose>
    return -1;
80104c76:	83 c4 10             	add    $0x10,%esp
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7e:	eb d7                	jmp    80104c57 <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104c80:	e8 7e e4 ff ff       	call   80103103 <myproc>
80104c85:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104c8c:	00 
80104c8d:	eb d1                	jmp    80104c60 <sys_pipe+0x65>
    return -1;
80104c8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c94:	eb c1                	jmp    80104c57 <sys_pipe+0x5c>
    return -1;
80104c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9b:	eb ba                	jmp    80104c57 <sys_pipe+0x5c>

80104c9d <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104ca3:	e8 49 e7 ff ff       	call   801033f1 <fork>
}
80104ca8:	c9                   	leave  
80104ca9:	c3                   	ret    

80104caa <sys_exit>:

int
sys_exit(void)
{
80104caa:	55                   	push   %ebp
80104cab:	89 e5                	mov    %esp,%ebp
80104cad:	83 ec 20             	sub    $0x20,%esp
  int e;

  if(argint(0, &e) < 0)
80104cb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cb3:	50                   	push   %eax
80104cb4:	6a 00                	push   $0x0
80104cb6:	e8 e8 f2 ff ff       	call   80103fa3 <argint>
80104cbb:	83 c4 10             	add    $0x10,%esp
80104cbe:	85 c0                	test   %eax,%eax
80104cc0:	78 15                	js     80104cd7 <sys_exit+0x2d>
    return -1;
  exit(e);
80104cc2:	83 ec 0c             	sub    $0xc,%esp
80104cc5:	ff 75 f4             	push   -0xc(%ebp)
80104cc8:	e8 b5 e9 ff ff       	call   80103682 <exit>
  return 0;  // not reached
80104ccd:	83 c4 10             	add    $0x10,%esp
80104cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
    return -1;
80104cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cdc:	eb f7                	jmp    80104cd5 <sys_exit+0x2b>

80104cde <sys_wait>:

int
sys_wait(void)
{
80104cde:	55                   	push   %ebp
80104cdf:	89 e5                	mov    %esp,%ebp
80104ce1:	83 ec 1c             	sub    $0x1c,%esp
  int *w;
  int child;


  if(argptr(0, (void **)&w, sizeof(int)) < 0)
80104ce4:	6a 04                	push   $0x4
80104ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce9:	50                   	push   %eax
80104cea:	6a 00                	push   $0x0
80104cec:	e8 da f2 ff ff       	call   80103fcb <argptr>
80104cf1:	83 c4 10             	add    $0x10,%esp
80104cf4:	85 c0                	test   %eax,%eax
80104cf6:	78 10                	js     80104d08 <sys_wait+0x2a>
    return -1;
  child = wait(w);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	ff 75 f4             	push   -0xc(%ebp)
80104cfe:	e8 2d eb ff ff       	call   80103830 <wait>
  return child;
80104d03:	83 c4 10             	add    $0x10,%esp
}
80104d06:	c9                   	leave  
80104d07:	c3                   	ret    
    return -1;
80104d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d0d:	eb f7                	jmp    80104d06 <sys_wait+0x28>

80104d0f <sys_kill>:

int
sys_kill(void)
{
80104d0f:	55                   	push   %ebp
80104d10:	89 e5                	mov    %esp,%ebp
80104d12:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d18:	50                   	push   %eax
80104d19:	6a 00                	push   $0x0
80104d1b:	e8 83 f2 ff ff       	call   80103fa3 <argint>
80104d20:	83 c4 10             	add    $0x10,%esp
80104d23:	85 c0                	test   %eax,%eax
80104d25:	78 10                	js     80104d37 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104d27:	83 ec 0c             	sub    $0xc,%esp
80104d2a:	ff 75 f4             	push   -0xc(%ebp)
80104d2d:	e8 1b ec ff ff       	call   8010394d <kill>
80104d32:	83 c4 10             	add    $0x10,%esp
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
    return -1;
80104d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3c:	eb f7                	jmp    80104d35 <sys_kill+0x26>

80104d3e <sys_getpid>:

int
sys_getpid(void)
{
80104d3e:	55                   	push   %ebp
80104d3f:	89 e5                	mov    %esp,%ebp
80104d41:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104d44:	e8 ba e3 ff ff       	call   80103103 <myproc>
80104d49:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d4c:	c9                   	leave  
80104d4d:	c3                   	ret    

80104d4e <sys_sbrk>:

int
sys_sbrk(void)
{
80104d4e:	55                   	push   %ebp
80104d4f:	89 e5                	mov    %esp,%ebp
80104d51:	53                   	push   %ebx
80104d52:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104d55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d58:	50                   	push   %eax
80104d59:	6a 00                	push   $0x0
80104d5b:	e8 43 f2 ff ff       	call   80103fa3 <argint>
80104d60:	83 c4 10             	add    $0x10,%esp
80104d63:	85 c0                	test   %eax,%eax
80104d65:	78 36                	js     80104d9d <sys_sbrk+0x4f>
    return -1;
  addr = myproc()->sz;
80104d67:	e8 97 e3 ff ff       	call   80103103 <myproc>
80104d6c:	8b 18                	mov    (%eax),%ebx

  if (n > 0) {
80104d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d71:	85 c0                	test   %eax,%eax
80104d73:	7e 11                	jle    80104d86 <sys_sbrk+0x38>
    myproc()->sz +=n;
80104d75:	e8 89 e3 ff ff       	call   80103103 <myproc>
80104d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d7d:	01 10                	add    %edx,(%eax)
  else {
    if(growproc(n) < 0)
      return -1;
  }
  return addr;
}
80104d7f:	89 d8                	mov    %ebx,%eax
80104d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d84:	c9                   	leave  
80104d85:	c3                   	ret    
    if(growproc(n) < 0)
80104d86:	83 ec 0c             	sub    $0xc,%esp
80104d89:	50                   	push   %eax
80104d8a:	e8 f8 e5 ff ff       	call   80103387 <growproc>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	85 c0                	test   %eax,%eax
80104d94:	79 e9                	jns    80104d7f <sys_sbrk+0x31>
      return -1;
80104d96:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d9b:	eb e2                	jmp    80104d7f <sys_sbrk+0x31>
    return -1;
80104d9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104da2:	eb db                	jmp    80104d7f <sys_sbrk+0x31>

80104da4 <sys_sleep>:

int
sys_sleep(void)
{
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	53                   	push   %ebx
80104da8:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104dab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dae:	50                   	push   %eax
80104daf:	6a 00                	push   $0x0
80104db1:	e8 ed f1 ff ff       	call   80103fa3 <argint>
80104db6:	83 c4 10             	add    $0x10,%esp
80104db9:	85 c0                	test   %eax,%eax
80104dbb:	78 75                	js     80104e32 <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104dbd:	83 ec 0c             	sub    $0xc,%esp
80104dc0:	68 e0 3f 11 80       	push   $0x80113fe0
80104dc5:	e8 fa ee ff ff       	call   80103cc4 <acquire>
  ticks0 = ticks;
80104dca:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  while(ticks - ticks0 < n){
80104dd0:	83 c4 10             	add    $0x10,%esp
80104dd3:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
80104dd8:	29 d8                	sub    %ebx,%eax
80104dda:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104ddd:	73 39                	jae    80104e18 <sys_sleep+0x74>
    if(myproc()->killed){
80104ddf:	e8 1f e3 ff ff       	call   80103103 <myproc>
80104de4:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104de8:	75 17                	jne    80104e01 <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104dea:	83 ec 08             	sub    $0x8,%esp
80104ded:	68 e0 3f 11 80       	push   $0x80113fe0
80104df2:	68 c0 3f 11 80       	push   $0x80113fc0
80104df7:	e8 a3 e9 ff ff       	call   8010379f <sleep>
80104dfc:	83 c4 10             	add    $0x10,%esp
80104dff:	eb d2                	jmp    80104dd3 <sys_sleep+0x2f>
      release(&tickslock);
80104e01:	83 ec 0c             	sub    $0xc,%esp
80104e04:	68 e0 3f 11 80       	push   $0x80113fe0
80104e09:	e8 1b ef ff ff       	call   80103d29 <release>
      return -1;
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e16:	eb 15                	jmp    80104e2d <sys_sleep+0x89>
  }
  release(&tickslock);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	68 e0 3f 11 80       	push   $0x80113fe0
80104e20:	e8 04 ef ff ff       	call   80103d29 <release>
  return 0;
80104e25:	83 c4 10             	add    $0x10,%esp
80104e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e30:	c9                   	leave  
80104e31:	c3                   	ret    
    return -1;
80104e32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e37:	eb f4                	jmp    80104e2d <sys_sleep+0x89>

80104e39 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104e39:	55                   	push   %ebp
80104e3a:	89 e5                	mov    %esp,%ebp
80104e3c:	53                   	push   %ebx
80104e3d:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104e40:	68 e0 3f 11 80       	push   $0x80113fe0
80104e45:	e8 7a ee ff ff       	call   80103cc4 <acquire>
  xticks = ticks;
80104e4a:	8b 1d c0 3f 11 80    	mov    0x80113fc0,%ebx
  release(&tickslock);
80104e50:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
80104e57:	e8 cd ee ff ff       	call   80103d29 <release>
  return xticks;
}
80104e5c:	89 d8                	mov    %ebx,%eax
80104e5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e61:	c9                   	leave  
80104e62:	c3                   	ret    

80104e63 <sys_date>:

int
sys_date(void)
{
80104e63:	55                   	push   %ebp
80104e64:	89 e5                	mov    %esp,%ebp
80104e66:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;

  if(argptr(0, (void **)&r, sizeof(struct rtcdate)) < 0)
80104e69:	6a 18                	push   $0x18
80104e6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e6e:	50                   	push   %eax
80104e6f:	6a 00                	push   $0x0
80104e71:	e8 55 f1 ff ff       	call   80103fcb <argptr>
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	78 15                	js     80104e92 <sys_date+0x2f>
    return -1;
  cmostime(r);
80104e7d:	83 ec 0c             	sub    $0xc,%esp
80104e80:	ff 75 f4             	push   -0xc(%ebp)
80104e83:	e8 26 d5 ff ff       	call   801023ae <cmostime>
  return 0;
80104e88:	83 c4 10             	add    $0x10,%esp
80104e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e90:	c9                   	leave  
80104e91:	c3                   	ret    
    return -1;
80104e92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e97:	eb f7                	jmp    80104e90 <sys_date+0x2d>

80104e99 <sys_getprio>:

int 
sys_getprio(void)
{
80104e99:	55                   	push   %ebp
80104e9a:	89 e5                	mov    %esp,%ebp
80104e9c:	83 ec 20             	sub    $0x20,%esp
  int n;

  if(argint(0, &n) < 0)
80104e9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea2:	50                   	push   %eax
80104ea3:	6a 00                	push   $0x0
80104ea5:	e8 f9 f0 ff ff       	call   80103fa3 <argint>
80104eaa:	83 c4 10             	add    $0x10,%esp
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	78 10                	js     80104ec1 <sys_getprio+0x28>
    return -1;

  return getprio(n);
80104eb1:	83 ec 0c             	sub    $0xc,%esp
80104eb4:	ff 75 f4             	push   -0xc(%ebp)
80104eb7:	e8 55 e3 ff ff       	call   80103211 <getprio>
80104ebc:	83 c4 10             	add    $0x10,%esp
}
80104ebf:	c9                   	leave  
80104ec0:	c3                   	ret    
    return -1;
80104ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec6:	eb f7                	jmp    80104ebf <sys_getprio+0x26>

80104ec8 <sys_setprio>:

int 
sys_setprio(void)
{
80104ec8:	55                   	push   %ebp
80104ec9:	89 e5                	mov    %esp,%ebp
80104ecb:	83 ec 20             	sub    $0x20,%esp
  int n, m;
  if(argint(0, &n) < 0)
80104ece:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ed1:	50                   	push   %eax
80104ed2:	6a 00                	push   $0x0
80104ed4:	e8 ca f0 ff ff       	call   80103fa3 <argint>
80104ed9:	83 c4 10             	add    $0x10,%esp
80104edc:	85 c0                	test   %eax,%eax
80104ede:	78 28                	js     80104f08 <sys_setprio+0x40>
    return -1;

  if(argint(1, &m) < 0)
80104ee0:	83 ec 08             	sub    $0x8,%esp
80104ee3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ee6:	50                   	push   %eax
80104ee7:	6a 01                	push   $0x1
80104ee9:	e8 b5 f0 ff ff       	call   80103fa3 <argint>
80104eee:	83 c4 10             	add    $0x10,%esp
80104ef1:	85 c0                	test   %eax,%eax
80104ef3:	78 1a                	js     80104f0f <sys_setprio+0x47>
    return -1;

  return setprio(n, m);
80104ef5:	83 ec 08             	sub    $0x8,%esp
80104ef8:	ff 75 f0             	push   -0x10(%ebp)
80104efb:	ff 75 f4             	push   -0xc(%ebp)
80104efe:	e8 3b e3 ff ff       	call   8010323e <setprio>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	c9                   	leave  
80104f07:	c3                   	ret    
    return -1;
80104f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0d:	eb f7                	jmp    80104f06 <sys_setprio+0x3e>
    return -1;
80104f0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f14:	eb f0                	jmp    80104f06 <sys_setprio+0x3e>

80104f16 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104f16:	1e                   	push   %ds
  pushl %es
80104f17:	06                   	push   %es
  pushl %fs
80104f18:	0f a0                	push   %fs
  pushl %gs
80104f1a:	0f a8                	push   %gs
  pushal
80104f1c:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104f1d:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104f21:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104f23:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104f25:	54                   	push   %esp
  call trap
80104f26:	e8 2f 01 00 00       	call   8010505a <trap>
  addl $4, %esp
80104f2b:	83 c4 04             	add    $0x4,%esp

80104f2e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104f2e:	61                   	popa   
  popl %gs
80104f2f:	0f a9                	pop    %gs
  popl %fs
80104f31:	0f a1                	pop    %fs
  popl %es
80104f33:	07                   	pop    %es
  popl %ds
80104f34:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104f35:	83 c4 08             	add    $0x8,%esp
  iret
80104f38:	cf                   	iret   

80104f39 <tvinit>:
int 
mappages(pde_t *pdgir, void *va, uint size, uint pa, int perm);

void
tvinit(void)
{
80104f39:	55                   	push   %ebp
80104f3a:	89 e5                	mov    %esp,%ebp
80104f3c:	53                   	push   %ebx
80104f3d:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80104f40:	b8 00 00 00 00       	mov    $0x0,%eax
80104f45:	eb 72                	jmp    80104fb9 <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f47:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104f4e:	66 89 0c c5 20 40 11 	mov    %cx,-0x7feebfe0(,%eax,8)
80104f55:	80 
80104f56:	66 c7 04 c5 22 40 11 	movw   $0x8,-0x7feebfde(,%eax,8)
80104f5d:	80 08 00 
80104f60:	8a 14 c5 24 40 11 80 	mov    -0x7feebfdc(,%eax,8),%dl
80104f67:	83 e2 e0             	and    $0xffffffe0,%edx
80104f6a:	88 14 c5 24 40 11 80 	mov    %dl,-0x7feebfdc(,%eax,8)
80104f71:	c6 04 c5 24 40 11 80 	movb   $0x0,-0x7feebfdc(,%eax,8)
80104f78:	00 
80104f79:	8a 14 c5 25 40 11 80 	mov    -0x7feebfdb(,%eax,8),%dl
80104f80:	83 e2 f0             	and    $0xfffffff0,%edx
80104f83:	83 ca 0e             	or     $0xe,%edx
80104f86:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80104f8d:	88 d3                	mov    %dl,%bl
80104f8f:	83 e3 ef             	and    $0xffffffef,%ebx
80104f92:	88 1c c5 25 40 11 80 	mov    %bl,-0x7feebfdb(,%eax,8)
80104f99:	83 e2 8f             	and    $0xffffff8f,%edx
80104f9c:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80104fa3:	83 ca 80             	or     $0xffffff80,%edx
80104fa6:	88 14 c5 25 40 11 80 	mov    %dl,-0x7feebfdb(,%eax,8)
80104fad:	c1 e9 10             	shr    $0x10,%ecx
80104fb0:	66 89 0c c5 26 40 11 	mov    %cx,-0x7feebfda(,%eax,8)
80104fb7:	80 
  for(i = 0; i < 256; i++)
80104fb8:	40                   	inc    %eax
80104fb9:	3d ff 00 00 00       	cmp    $0xff,%eax
80104fbe:	7e 87                	jle    80104f47 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104fc0:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104fc6:	66 89 15 20 42 11 80 	mov    %dx,0x80114220
80104fcd:	66 c7 05 22 42 11 80 	movw   $0x8,0x80114222
80104fd4:	08 00 
80104fd6:	a0 24 42 11 80       	mov    0x80114224,%al
80104fdb:	83 e0 e0             	and    $0xffffffe0,%eax
80104fde:	a2 24 42 11 80       	mov    %al,0x80114224
80104fe3:	c6 05 24 42 11 80 00 	movb   $0x0,0x80114224
80104fea:	a0 25 42 11 80       	mov    0x80114225,%al
80104fef:	83 c8 0f             	or     $0xf,%eax
80104ff2:	a2 25 42 11 80       	mov    %al,0x80114225
80104ff7:	83 e0 ef             	and    $0xffffffef,%eax
80104ffa:	a2 25 42 11 80       	mov    %al,0x80114225
80104fff:	88 c1                	mov    %al,%cl
80105001:	83 c9 60             	or     $0x60,%ecx
80105004:	88 0d 25 42 11 80    	mov    %cl,0x80114225
8010500a:	83 c8 e0             	or     $0xffffffe0,%eax
8010500d:	a2 25 42 11 80       	mov    %al,0x80114225
80105012:	c1 ea 10             	shr    $0x10,%edx
80105015:	66 89 15 26 42 11 80 	mov    %dx,0x80114226

  initlock(&tickslock, "time");
8010501c:	83 ec 08             	sub    $0x8,%esp
8010501f:	68 09 71 10 80       	push   $0x80107109
80105024:	68 e0 3f 11 80       	push   $0x80113fe0
80105029:	e8 5f eb ff ff       	call   80103b8d <initlock>
}
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105034:	c9                   	leave  
80105035:	c3                   	ret    

80105036 <idtinit>:

void
idtinit(void)
{
80105036:	55                   	push   %ebp
80105037:	89 e5                	mov    %esp,%ebp
80105039:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010503c:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105042:	b8 20 40 11 80       	mov    $0x80114020,%eax
80105047:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010504b:	c1 e8 10             	shr    $0x10,%eax
8010504e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105052:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105055:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105058:	c9                   	leave  
80105059:	c3                   	ret    

8010505a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010505a:	55                   	push   %ebp
8010505b:	89 e5                	mov    %esp,%ebp
8010505d:	57                   	push   %edi
8010505e:	56                   	push   %esi
8010505f:	53                   	push   %ebx
80105060:	83 ec 1c             	sub    $0x1c,%esp
80105063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105066:	8b 43 30             	mov    0x30(%ebx),%eax
80105069:	83 f8 40             	cmp    $0x40,%eax
8010506c:	74 13                	je     80105081 <trap+0x27>
    if(myproc()->killed)
      exit(tf->trapno + 1);
    return;
  }

  switch(tf->trapno){
8010506e:	83 e8 0e             	sub    $0xe,%eax
80105071:	83 f8 31             	cmp    $0x31,%eax
80105074:	0f 87 25 02 00 00    	ja     8010529f <trap+0x245>
8010507a:	ff 24 85 e0 71 10 80 	jmp    *-0x7fef8e20(,%eax,4)
    if(myproc()->killed)
80105081:	e8 7d e0 ff ff       	call   80103103 <myproc>
80105086:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010508a:	75 31                	jne    801050bd <trap+0x63>
    myproc()->tf = tf;
8010508c:	e8 72 e0 ff ff       	call   80103103 <myproc>
80105091:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105094:	e8 cd ef ff ff       	call   80104066 <syscall>
    if(myproc()->killed)
80105099:	e8 65 e0 ff ff       	call   80103103 <myproc>
8010509e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050a2:	0f 84 95 00 00 00    	je     8010513d <trap+0xe3>
      exit(tf->trapno + 1);
801050a8:	8b 43 30             	mov    0x30(%ebx),%eax
801050ab:	40                   	inc    %eax
801050ac:	83 ec 0c             	sub    $0xc,%esp
801050af:	50                   	push   %eax
801050b0:	e8 cd e5 ff ff       	call   80103682 <exit>
801050b5:	83 c4 10             	add    $0x10,%esp
    return;
801050b8:	e9 80 00 00 00       	jmp    8010513d <trap+0xe3>
      exit(tf->trapno + 1);
801050bd:	8b 43 30             	mov    0x30(%ebx),%eax
801050c0:	40                   	inc    %eax
801050c1:	83 ec 0c             	sub    $0xc,%esp
801050c4:	50                   	push   %eax
801050c5:	e8 b8 e5 ff ff       	call   80103682 <exit>
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	eb bd                	jmp    8010508c <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801050cf:	e8 fe df ff ff       	call   801030d2 <cpuid>
801050d4:	85 c0                	test   %eax,%eax
801050d6:	74 6d                	je     80105145 <trap+0xeb>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
801050d8:	e8 1c d2 ff ff       	call   801022f9 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801050dd:	e8 21 e0 ff ff       	call   80103103 <myproc>
801050e2:	85 c0                	test   %eax,%eax
801050e4:	74 1b                	je     80105101 <trap+0xa7>
801050e6:	e8 18 e0 ff ff       	call   80103103 <myproc>
801050eb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050ef:	74 10                	je     80105101 <trap+0xa7>
801050f1:	8b 43 3c             	mov    0x3c(%ebx),%eax
801050f4:	83 e0 03             	and    $0x3,%eax
801050f7:	66 83 f8 03          	cmp    $0x3,%ax
801050fb:	0f 84 31 02 00 00    	je     80105332 <trap+0x2d8>
    exit(tf->trapno + 1);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105101:	e8 fd df ff ff       	call   80103103 <myproc>
80105106:	85 c0                	test   %eax,%eax
80105108:	74 0f                	je     80105119 <trap+0xbf>
8010510a:	e8 f4 df ff ff       	call   80103103 <myproc>
8010510f:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105113:	0f 84 2e 02 00 00    	je     80105347 <trap+0x2ed>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105119:	e8 e5 df ff ff       	call   80103103 <myproc>
8010511e:	85 c0                	test   %eax,%eax
80105120:	74 1b                	je     8010513d <trap+0xe3>
80105122:	e8 dc df ff ff       	call   80103103 <myproc>
80105127:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010512b:	74 10                	je     8010513d <trap+0xe3>
8010512d:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105130:	83 e0 03             	and    $0x3,%eax
80105133:	66 83 f8 03          	cmp    $0x3,%ax
80105137:	0f 84 1e 02 00 00    	je     8010535b <trap+0x301>
    exit(tf->trapno + 1);
}
8010513d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105140:	5b                   	pop    %ebx
80105141:	5e                   	pop    %esi
80105142:	5f                   	pop    %edi
80105143:	5d                   	pop    %ebp
80105144:	c3                   	ret    
      acquire(&tickslock);
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	68 e0 3f 11 80       	push   $0x80113fe0
8010514d:	e8 72 eb ff ff       	call   80103cc4 <acquire>
      ticks++;
80105152:	ff 05 c0 3f 11 80    	incl   0x80113fc0
      wakeup(&ticks);
80105158:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
8010515f:	e8 c0 e7 ff ff       	call   80103924 <wakeup>
      release(&tickslock);
80105164:	c7 04 24 e0 3f 11 80 	movl   $0x80113fe0,(%esp)
8010516b:	e8 b9 eb ff ff       	call   80103d29 <release>
80105170:	83 c4 10             	add    $0x10,%esp
80105173:	e9 60 ff ff ff       	jmp    801050d8 <trap+0x7e>
    ideintr();
80105178:	e8 65 cb ff ff       	call   80101ce2 <ideintr>
    lapiceoi();
8010517d:	e8 77 d1 ff ff       	call   801022f9 <lapiceoi>
    break;
80105182:	e9 56 ff ff ff       	jmp    801050dd <trap+0x83>
    kbdintr();
80105187:	e8 b7 cf ff ff       	call   80102143 <kbdintr>
    lapiceoi();
8010518c:	e8 68 d1 ff ff       	call   801022f9 <lapiceoi>
    break;
80105191:	e9 47 ff ff ff       	jmp    801050dd <trap+0x83>
    uartintr();
80105196:	e8 d1 02 00 00       	call   8010546c <uartintr>
    lapiceoi();
8010519b:	e8 59 d1 ff ff       	call   801022f9 <lapiceoi>
    break;
801051a0:	e9 38 ff ff ff       	jmp    801050dd <trap+0x83>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801051a5:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801051a8:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801051ab:	e8 22 df ff ff       	call   801030d2 <cpuid>
801051b0:	57                   	push   %edi
801051b1:	0f b7 f6             	movzwl %si,%esi
801051b4:	56                   	push   %esi
801051b5:	50                   	push   %eax
801051b6:	68 44 71 10 80       	push   $0x80107144
801051bb:	e8 1a b4 ff ff       	call   801005da <cprintf>
    lapiceoi();
801051c0:	e8 34 d1 ff ff       	call   801022f9 <lapiceoi>
    break;
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	e9 10 ff ff ff       	jmp    801050dd <trap+0x83>
    if(myproc() == 0){
801051cd:	e8 31 df ff ff       	call   80103103 <myproc>
801051d2:	85 c0                	test   %eax,%eax
801051d4:	74 7d                	je     80105253 <trap+0x1f9>
    mem = kalloc();
801051d6:	e8 4c ce ff ff       	call   80102027 <kalloc>
801051db:	89 c6                	mov    %eax,%esi
    if (mem == 0) {
801051dd:	85 c0                	test   %eax,%eax
801051df:	0f 84 99 00 00 00    	je     8010527e <trap+0x224>
    memset(mem, 0, PGSIZE);
801051e5:	83 ec 04             	sub    $0x4,%esp
801051e8:	68 00 10 00 00       	push   $0x1000
801051ed:	6a 00                	push   $0x0
801051ef:	56                   	push   %esi
801051f0:	e8 7b eb ff ff       	call   80103d70 <memset>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801051f5:	0f 20 d7             	mov    %cr2,%edi
    if (mappages(myproc()->pgdir, (char*)PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801051f8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801051fe:	e8 00 df ff ff       	call   80103103 <myproc>
80105203:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
8010520a:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80105210:	52                   	push   %edx
80105211:	68 00 10 00 00       	push   $0x1000
80105216:	57                   	push   %edi
80105217:	ff 70 04             	push   0x4(%eax)
8010521a:	e8 15 10 00 00       	call   80106234 <mappages>
8010521f:	83 c4 20             	add    $0x20,%esp
80105222:	85 c0                	test   %eax,%eax
80105224:	0f 89 b3 fe ff ff    	jns    801050dd <trap+0x83>
      cprintf("page mapping failed\n");
8010522a:	83 ec 0c             	sub    $0xc,%esp
8010522d:	68 2d 71 10 80       	push   $0x8010712d
80105232:	e8 a3 b3 ff ff       	call   801005da <cprintf>
      kfree(mem);
80105237:	89 34 24             	mov    %esi,(%esp)
8010523a:	e8 d1 cc ff ff       	call   80101f10 <kfree>
      myproc()->killed = 1;
8010523f:	e8 bf de ff ff       	call   80103103 <myproc>
80105244:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010524b:	83 c4 10             	add    $0x10,%esp
8010524e:	e9 8a fe ff ff       	jmp    801050dd <trap+0x83>
80105253:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105256:	8b 73 38             	mov    0x38(%ebx),%esi
80105259:	e8 74 de ff ff       	call   801030d2 <cpuid>
8010525e:	83 ec 0c             	sub    $0xc,%esp
80105261:	57                   	push   %edi
80105262:	56                   	push   %esi
80105263:	50                   	push   %eax
80105264:	ff 73 30             	push   0x30(%ebx)
80105267:	68 68 71 10 80       	push   $0x80107168
8010526c:	e8 69 b3 ff ff       	call   801005da <cprintf>
      panic("trap");
80105271:	83 c4 14             	add    $0x14,%esp
80105274:	68 0e 71 10 80       	push   $0x8010710e
80105279:	e8 c3 b0 ff ff       	call   80100341 <panic>
      cprintf("page fault out of memory\n");
8010527e:	83 ec 0c             	sub    $0xc,%esp
80105281:	68 13 71 10 80       	push   $0x80107113
80105286:	e8 4f b3 ff ff       	call   801005da <cprintf>
      myproc()->killed = 1;
8010528b:	e8 73 de ff ff       	call   80103103 <myproc>
80105290:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105297:	83 c4 10             	add    $0x10,%esp
8010529a:	e9 46 ff ff ff       	jmp    801051e5 <trap+0x18b>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010529f:	e8 5f de ff ff       	call   80103103 <myproc>
801052a4:	85 c0                	test   %eax,%eax
801052a6:	74 5f                	je     80105307 <trap+0x2ad>
801052a8:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801052ac:	74 59                	je     80105307 <trap+0x2ad>
801052ae:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801052b1:	8b 43 38             	mov    0x38(%ebx),%eax
801052b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801052b7:	e8 16 de ff ff       	call   801030d2 <cpuid>
801052bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801052bf:	8b 4b 34             	mov    0x34(%ebx),%ecx
801052c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801052c5:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801052c8:	e8 36 de ff ff       	call   80103103 <myproc>
801052cd:	8d 50 6c             	lea    0x6c(%eax),%edx
801052d0:	89 55 d8             	mov    %edx,-0x28(%ebp)
801052d3:	e8 2b de ff ff       	call   80103103 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801052d8:	57                   	push   %edi
801052d9:	ff 75 e4             	push   -0x1c(%ebp)
801052dc:	ff 75 e0             	push   -0x20(%ebp)
801052df:	ff 75 dc             	push   -0x24(%ebp)
801052e2:	56                   	push   %esi
801052e3:	ff 75 d8             	push   -0x28(%ebp)
801052e6:	ff 70 10             	push   0x10(%eax)
801052e9:	68 9c 71 10 80       	push   $0x8010719c
801052ee:	e8 e7 b2 ff ff       	call   801005da <cprintf>
    myproc()->killed = 1;
801052f3:	83 c4 20             	add    $0x20,%esp
801052f6:	e8 08 de ff ff       	call   80103103 <myproc>
801052fb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105302:	e9 d6 fd ff ff       	jmp    801050dd <trap+0x83>
80105307:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010530a:	8b 73 38             	mov    0x38(%ebx),%esi
8010530d:	e8 c0 dd ff ff       	call   801030d2 <cpuid>
80105312:	83 ec 0c             	sub    $0xc,%esp
80105315:	57                   	push   %edi
80105316:	56                   	push   %esi
80105317:	50                   	push   %eax
80105318:	ff 73 30             	push   0x30(%ebx)
8010531b:	68 68 71 10 80       	push   $0x80107168
80105320:	e8 b5 b2 ff ff       	call   801005da <cprintf>
      panic("trap");
80105325:	83 c4 14             	add    $0x14,%esp
80105328:	68 0e 71 10 80       	push   $0x8010710e
8010532d:	e8 0f b0 ff ff       	call   80100341 <panic>
    exit(tf->trapno + 1);
80105332:	8b 43 30             	mov    0x30(%ebx),%eax
80105335:	40                   	inc    %eax
80105336:	83 ec 0c             	sub    $0xc,%esp
80105339:	50                   	push   %eax
8010533a:	e8 43 e3 ff ff       	call   80103682 <exit>
8010533f:	83 c4 10             	add    $0x10,%esp
80105342:	e9 ba fd ff ff       	jmp    80105101 <trap+0xa7>
  if(myproc() && myproc()->state == RUNNING &&
80105347:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010534b:	0f 85 c8 fd ff ff    	jne    80105119 <trap+0xbf>
    yield();
80105351:	e8 0a e4 ff ff       	call   80103760 <yield>
80105356:	e9 be fd ff ff       	jmp    80105119 <trap+0xbf>
    exit(tf->trapno + 1);
8010535b:	8b 43 30             	mov    0x30(%ebx),%eax
8010535e:	40                   	inc    %eax
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	50                   	push   %eax
80105363:	e8 1a e3 ff ff       	call   80103682 <exit>
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	e9 cd fd ff ff       	jmp    8010513d <trap+0xe3>

80105370 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105370:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
80105377:	74 14                	je     8010538d <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105379:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010537e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010537f:	a8 01                	test   $0x1,%al
80105381:	74 10                	je     80105393 <uartgetc+0x23>
80105383:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105388:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105389:	0f b6 c0             	movzbl %al,%eax
8010538c:	c3                   	ret    
    return -1;
8010538d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105392:	c3                   	ret    
    return -1;
80105393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105398:	c3                   	ret    

80105399 <uartputc>:
  if(!uart)
80105399:	83 3d 20 48 11 80 00 	cmpl   $0x0,0x80114820
801053a0:	74 39                	je     801053db <uartputc+0x42>
{
801053a2:	55                   	push   %ebp
801053a3:	89 e5                	mov    %esp,%ebp
801053a5:	53                   	push   %ebx
801053a6:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053a9:	bb 00 00 00 00       	mov    $0x0,%ebx
801053ae:	eb 0e                	jmp    801053be <uartputc+0x25>
    microdelay(10);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	6a 0a                	push   $0xa
801053b5:	e8 60 cf ff ff       	call   8010231a <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801053ba:	43                   	inc    %ebx
801053bb:	83 c4 10             	add    $0x10,%esp
801053be:	83 fb 7f             	cmp    $0x7f,%ebx
801053c1:	7f 0a                	jg     801053cd <uartputc+0x34>
801053c3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801053c8:	ec                   	in     (%dx),%al
801053c9:	a8 20                	test   $0x20,%al
801053cb:	74 e3                	je     801053b0 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801053cd:	8b 45 08             	mov    0x8(%ebp),%eax
801053d0:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053d5:	ee                   	out    %al,(%dx)
}
801053d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053d9:	c9                   	leave  
801053da:	c3                   	ret    
801053db:	c3                   	ret    

801053dc <uartinit>:
{
801053dc:	55                   	push   %ebp
801053dd:	89 e5                	mov    %esp,%ebp
801053df:	56                   	push   %esi
801053e0:	53                   	push   %ebx
801053e1:	b1 00                	mov    $0x0,%cl
801053e3:	ba fa 03 00 00       	mov    $0x3fa,%edx
801053e8:	88 c8                	mov    %cl,%al
801053ea:	ee                   	out    %al,(%dx)
801053eb:	be fb 03 00 00       	mov    $0x3fb,%esi
801053f0:	b0 80                	mov    $0x80,%al
801053f2:	89 f2                	mov    %esi,%edx
801053f4:	ee                   	out    %al,(%dx)
801053f5:	b0 0c                	mov    $0xc,%al
801053f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053fc:	ee                   	out    %al,(%dx)
801053fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105402:	88 c8                	mov    %cl,%al
80105404:	89 da                	mov    %ebx,%edx
80105406:	ee                   	out    %al,(%dx)
80105407:	b0 03                	mov    $0x3,%al
80105409:	89 f2                	mov    %esi,%edx
8010540b:	ee                   	out    %al,(%dx)
8010540c:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105411:	88 c8                	mov    %cl,%al
80105413:	ee                   	out    %al,(%dx)
80105414:	b0 01                	mov    $0x1,%al
80105416:	89 da                	mov    %ebx,%edx
80105418:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105419:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010541e:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010541f:	3c ff                	cmp    $0xff,%al
80105421:	74 42                	je     80105465 <uartinit+0x89>
  uart = 1;
80105423:	c7 05 20 48 11 80 01 	movl   $0x1,0x80114820
8010542a:	00 00 00 
8010542d:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105432:	ec                   	in     (%dx),%al
80105433:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105438:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	6a 00                	push   $0x0
8010543e:	6a 04                	push   $0x4
80105440:	e8 a0 ca ff ff       	call   80101ee5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105445:	83 c4 10             	add    $0x10,%esp
80105448:	bb a8 72 10 80       	mov    $0x801072a8,%ebx
8010544d:	eb 10                	jmp    8010545f <uartinit+0x83>
    uartputc(*p);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	0f be c0             	movsbl %al,%eax
80105455:	50                   	push   %eax
80105456:	e8 3e ff ff ff       	call   80105399 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010545b:	43                   	inc    %ebx
8010545c:	83 c4 10             	add    $0x10,%esp
8010545f:	8a 03                	mov    (%ebx),%al
80105461:	84 c0                	test   %al,%al
80105463:	75 ea                	jne    8010544f <uartinit+0x73>
}
80105465:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105468:	5b                   	pop    %ebx
80105469:	5e                   	pop    %esi
8010546a:	5d                   	pop    %ebp
8010546b:	c3                   	ret    

8010546c <uartintr>:

void
uartintr(void)
{
8010546c:	55                   	push   %ebp
8010546d:	89 e5                	mov    %esp,%ebp
8010546f:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105472:	68 70 53 10 80       	push   $0x80105370
80105477:	e8 83 b2 ff ff       	call   801006ff <consoleintr>
}
8010547c:	83 c4 10             	add    $0x10,%esp
8010547f:	c9                   	leave  
80105480:	c3                   	ret    

80105481 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105481:	6a 00                	push   $0x0
  pushl $0
80105483:	6a 00                	push   $0x0
  jmp alltraps
80105485:	e9 8c fa ff ff       	jmp    80104f16 <alltraps>

8010548a <vector1>:
.globl vector1
vector1:
  pushl $0
8010548a:	6a 00                	push   $0x0
  pushl $1
8010548c:	6a 01                	push   $0x1
  jmp alltraps
8010548e:	e9 83 fa ff ff       	jmp    80104f16 <alltraps>

80105493 <vector2>:
.globl vector2
vector2:
  pushl $0
80105493:	6a 00                	push   $0x0
  pushl $2
80105495:	6a 02                	push   $0x2
  jmp alltraps
80105497:	e9 7a fa ff ff       	jmp    80104f16 <alltraps>

8010549c <vector3>:
.globl vector3
vector3:
  pushl $0
8010549c:	6a 00                	push   $0x0
  pushl $3
8010549e:	6a 03                	push   $0x3
  jmp alltraps
801054a0:	e9 71 fa ff ff       	jmp    80104f16 <alltraps>

801054a5 <vector4>:
.globl vector4
vector4:
  pushl $0
801054a5:	6a 00                	push   $0x0
  pushl $4
801054a7:	6a 04                	push   $0x4
  jmp alltraps
801054a9:	e9 68 fa ff ff       	jmp    80104f16 <alltraps>

801054ae <vector5>:
.globl vector5
vector5:
  pushl $0
801054ae:	6a 00                	push   $0x0
  pushl $5
801054b0:	6a 05                	push   $0x5
  jmp alltraps
801054b2:	e9 5f fa ff ff       	jmp    80104f16 <alltraps>

801054b7 <vector6>:
.globl vector6
vector6:
  pushl $0
801054b7:	6a 00                	push   $0x0
  pushl $6
801054b9:	6a 06                	push   $0x6
  jmp alltraps
801054bb:	e9 56 fa ff ff       	jmp    80104f16 <alltraps>

801054c0 <vector7>:
.globl vector7
vector7:
  pushl $0
801054c0:	6a 00                	push   $0x0
  pushl $7
801054c2:	6a 07                	push   $0x7
  jmp alltraps
801054c4:	e9 4d fa ff ff       	jmp    80104f16 <alltraps>

801054c9 <vector8>:
.globl vector8
vector8:
  pushl $8
801054c9:	6a 08                	push   $0x8
  jmp alltraps
801054cb:	e9 46 fa ff ff       	jmp    80104f16 <alltraps>

801054d0 <vector9>:
.globl vector9
vector9:
  pushl $0
801054d0:	6a 00                	push   $0x0
  pushl $9
801054d2:	6a 09                	push   $0x9
  jmp alltraps
801054d4:	e9 3d fa ff ff       	jmp    80104f16 <alltraps>

801054d9 <vector10>:
.globl vector10
vector10:
  pushl $10
801054d9:	6a 0a                	push   $0xa
  jmp alltraps
801054db:	e9 36 fa ff ff       	jmp    80104f16 <alltraps>

801054e0 <vector11>:
.globl vector11
vector11:
  pushl $11
801054e0:	6a 0b                	push   $0xb
  jmp alltraps
801054e2:	e9 2f fa ff ff       	jmp    80104f16 <alltraps>

801054e7 <vector12>:
.globl vector12
vector12:
  pushl $12
801054e7:	6a 0c                	push   $0xc
  jmp alltraps
801054e9:	e9 28 fa ff ff       	jmp    80104f16 <alltraps>

801054ee <vector13>:
.globl vector13
vector13:
  pushl $13
801054ee:	6a 0d                	push   $0xd
  jmp alltraps
801054f0:	e9 21 fa ff ff       	jmp    80104f16 <alltraps>

801054f5 <vector14>:
.globl vector14
vector14:
  pushl $14
801054f5:	6a 0e                	push   $0xe
  jmp alltraps
801054f7:	e9 1a fa ff ff       	jmp    80104f16 <alltraps>

801054fc <vector15>:
.globl vector15
vector15:
  pushl $0
801054fc:	6a 00                	push   $0x0
  pushl $15
801054fe:	6a 0f                	push   $0xf
  jmp alltraps
80105500:	e9 11 fa ff ff       	jmp    80104f16 <alltraps>

80105505 <vector16>:
.globl vector16
vector16:
  pushl $0
80105505:	6a 00                	push   $0x0
  pushl $16
80105507:	6a 10                	push   $0x10
  jmp alltraps
80105509:	e9 08 fa ff ff       	jmp    80104f16 <alltraps>

8010550e <vector17>:
.globl vector17
vector17:
  pushl $17
8010550e:	6a 11                	push   $0x11
  jmp alltraps
80105510:	e9 01 fa ff ff       	jmp    80104f16 <alltraps>

80105515 <vector18>:
.globl vector18
vector18:
  pushl $0
80105515:	6a 00                	push   $0x0
  pushl $18
80105517:	6a 12                	push   $0x12
  jmp alltraps
80105519:	e9 f8 f9 ff ff       	jmp    80104f16 <alltraps>

8010551e <vector19>:
.globl vector19
vector19:
  pushl $0
8010551e:	6a 00                	push   $0x0
  pushl $19
80105520:	6a 13                	push   $0x13
  jmp alltraps
80105522:	e9 ef f9 ff ff       	jmp    80104f16 <alltraps>

80105527 <vector20>:
.globl vector20
vector20:
  pushl $0
80105527:	6a 00                	push   $0x0
  pushl $20
80105529:	6a 14                	push   $0x14
  jmp alltraps
8010552b:	e9 e6 f9 ff ff       	jmp    80104f16 <alltraps>

80105530 <vector21>:
.globl vector21
vector21:
  pushl $0
80105530:	6a 00                	push   $0x0
  pushl $21
80105532:	6a 15                	push   $0x15
  jmp alltraps
80105534:	e9 dd f9 ff ff       	jmp    80104f16 <alltraps>

80105539 <vector22>:
.globl vector22
vector22:
  pushl $0
80105539:	6a 00                	push   $0x0
  pushl $22
8010553b:	6a 16                	push   $0x16
  jmp alltraps
8010553d:	e9 d4 f9 ff ff       	jmp    80104f16 <alltraps>

80105542 <vector23>:
.globl vector23
vector23:
  pushl $0
80105542:	6a 00                	push   $0x0
  pushl $23
80105544:	6a 17                	push   $0x17
  jmp alltraps
80105546:	e9 cb f9 ff ff       	jmp    80104f16 <alltraps>

8010554b <vector24>:
.globl vector24
vector24:
  pushl $0
8010554b:	6a 00                	push   $0x0
  pushl $24
8010554d:	6a 18                	push   $0x18
  jmp alltraps
8010554f:	e9 c2 f9 ff ff       	jmp    80104f16 <alltraps>

80105554 <vector25>:
.globl vector25
vector25:
  pushl $0
80105554:	6a 00                	push   $0x0
  pushl $25
80105556:	6a 19                	push   $0x19
  jmp alltraps
80105558:	e9 b9 f9 ff ff       	jmp    80104f16 <alltraps>

8010555d <vector26>:
.globl vector26
vector26:
  pushl $0
8010555d:	6a 00                	push   $0x0
  pushl $26
8010555f:	6a 1a                	push   $0x1a
  jmp alltraps
80105561:	e9 b0 f9 ff ff       	jmp    80104f16 <alltraps>

80105566 <vector27>:
.globl vector27
vector27:
  pushl $0
80105566:	6a 00                	push   $0x0
  pushl $27
80105568:	6a 1b                	push   $0x1b
  jmp alltraps
8010556a:	e9 a7 f9 ff ff       	jmp    80104f16 <alltraps>

8010556f <vector28>:
.globl vector28
vector28:
  pushl $0
8010556f:	6a 00                	push   $0x0
  pushl $28
80105571:	6a 1c                	push   $0x1c
  jmp alltraps
80105573:	e9 9e f9 ff ff       	jmp    80104f16 <alltraps>

80105578 <vector29>:
.globl vector29
vector29:
  pushl $0
80105578:	6a 00                	push   $0x0
  pushl $29
8010557a:	6a 1d                	push   $0x1d
  jmp alltraps
8010557c:	e9 95 f9 ff ff       	jmp    80104f16 <alltraps>

80105581 <vector30>:
.globl vector30
vector30:
  pushl $0
80105581:	6a 00                	push   $0x0
  pushl $30
80105583:	6a 1e                	push   $0x1e
  jmp alltraps
80105585:	e9 8c f9 ff ff       	jmp    80104f16 <alltraps>

8010558a <vector31>:
.globl vector31
vector31:
  pushl $0
8010558a:	6a 00                	push   $0x0
  pushl $31
8010558c:	6a 1f                	push   $0x1f
  jmp alltraps
8010558e:	e9 83 f9 ff ff       	jmp    80104f16 <alltraps>

80105593 <vector32>:
.globl vector32
vector32:
  pushl $0
80105593:	6a 00                	push   $0x0
  pushl $32
80105595:	6a 20                	push   $0x20
  jmp alltraps
80105597:	e9 7a f9 ff ff       	jmp    80104f16 <alltraps>

8010559c <vector33>:
.globl vector33
vector33:
  pushl $0
8010559c:	6a 00                	push   $0x0
  pushl $33
8010559e:	6a 21                	push   $0x21
  jmp alltraps
801055a0:	e9 71 f9 ff ff       	jmp    80104f16 <alltraps>

801055a5 <vector34>:
.globl vector34
vector34:
  pushl $0
801055a5:	6a 00                	push   $0x0
  pushl $34
801055a7:	6a 22                	push   $0x22
  jmp alltraps
801055a9:	e9 68 f9 ff ff       	jmp    80104f16 <alltraps>

801055ae <vector35>:
.globl vector35
vector35:
  pushl $0
801055ae:	6a 00                	push   $0x0
  pushl $35
801055b0:	6a 23                	push   $0x23
  jmp alltraps
801055b2:	e9 5f f9 ff ff       	jmp    80104f16 <alltraps>

801055b7 <vector36>:
.globl vector36
vector36:
  pushl $0
801055b7:	6a 00                	push   $0x0
  pushl $36
801055b9:	6a 24                	push   $0x24
  jmp alltraps
801055bb:	e9 56 f9 ff ff       	jmp    80104f16 <alltraps>

801055c0 <vector37>:
.globl vector37
vector37:
  pushl $0
801055c0:	6a 00                	push   $0x0
  pushl $37
801055c2:	6a 25                	push   $0x25
  jmp alltraps
801055c4:	e9 4d f9 ff ff       	jmp    80104f16 <alltraps>

801055c9 <vector38>:
.globl vector38
vector38:
  pushl $0
801055c9:	6a 00                	push   $0x0
  pushl $38
801055cb:	6a 26                	push   $0x26
  jmp alltraps
801055cd:	e9 44 f9 ff ff       	jmp    80104f16 <alltraps>

801055d2 <vector39>:
.globl vector39
vector39:
  pushl $0
801055d2:	6a 00                	push   $0x0
  pushl $39
801055d4:	6a 27                	push   $0x27
  jmp alltraps
801055d6:	e9 3b f9 ff ff       	jmp    80104f16 <alltraps>

801055db <vector40>:
.globl vector40
vector40:
  pushl $0
801055db:	6a 00                	push   $0x0
  pushl $40
801055dd:	6a 28                	push   $0x28
  jmp alltraps
801055df:	e9 32 f9 ff ff       	jmp    80104f16 <alltraps>

801055e4 <vector41>:
.globl vector41
vector41:
  pushl $0
801055e4:	6a 00                	push   $0x0
  pushl $41
801055e6:	6a 29                	push   $0x29
  jmp alltraps
801055e8:	e9 29 f9 ff ff       	jmp    80104f16 <alltraps>

801055ed <vector42>:
.globl vector42
vector42:
  pushl $0
801055ed:	6a 00                	push   $0x0
  pushl $42
801055ef:	6a 2a                	push   $0x2a
  jmp alltraps
801055f1:	e9 20 f9 ff ff       	jmp    80104f16 <alltraps>

801055f6 <vector43>:
.globl vector43
vector43:
  pushl $0
801055f6:	6a 00                	push   $0x0
  pushl $43
801055f8:	6a 2b                	push   $0x2b
  jmp alltraps
801055fa:	e9 17 f9 ff ff       	jmp    80104f16 <alltraps>

801055ff <vector44>:
.globl vector44
vector44:
  pushl $0
801055ff:	6a 00                	push   $0x0
  pushl $44
80105601:	6a 2c                	push   $0x2c
  jmp alltraps
80105603:	e9 0e f9 ff ff       	jmp    80104f16 <alltraps>

80105608 <vector45>:
.globl vector45
vector45:
  pushl $0
80105608:	6a 00                	push   $0x0
  pushl $45
8010560a:	6a 2d                	push   $0x2d
  jmp alltraps
8010560c:	e9 05 f9 ff ff       	jmp    80104f16 <alltraps>

80105611 <vector46>:
.globl vector46
vector46:
  pushl $0
80105611:	6a 00                	push   $0x0
  pushl $46
80105613:	6a 2e                	push   $0x2e
  jmp alltraps
80105615:	e9 fc f8 ff ff       	jmp    80104f16 <alltraps>

8010561a <vector47>:
.globl vector47
vector47:
  pushl $0
8010561a:	6a 00                	push   $0x0
  pushl $47
8010561c:	6a 2f                	push   $0x2f
  jmp alltraps
8010561e:	e9 f3 f8 ff ff       	jmp    80104f16 <alltraps>

80105623 <vector48>:
.globl vector48
vector48:
  pushl $0
80105623:	6a 00                	push   $0x0
  pushl $48
80105625:	6a 30                	push   $0x30
  jmp alltraps
80105627:	e9 ea f8 ff ff       	jmp    80104f16 <alltraps>

8010562c <vector49>:
.globl vector49
vector49:
  pushl $0
8010562c:	6a 00                	push   $0x0
  pushl $49
8010562e:	6a 31                	push   $0x31
  jmp alltraps
80105630:	e9 e1 f8 ff ff       	jmp    80104f16 <alltraps>

80105635 <vector50>:
.globl vector50
vector50:
  pushl $0
80105635:	6a 00                	push   $0x0
  pushl $50
80105637:	6a 32                	push   $0x32
  jmp alltraps
80105639:	e9 d8 f8 ff ff       	jmp    80104f16 <alltraps>

8010563e <vector51>:
.globl vector51
vector51:
  pushl $0
8010563e:	6a 00                	push   $0x0
  pushl $51
80105640:	6a 33                	push   $0x33
  jmp alltraps
80105642:	e9 cf f8 ff ff       	jmp    80104f16 <alltraps>

80105647 <vector52>:
.globl vector52
vector52:
  pushl $0
80105647:	6a 00                	push   $0x0
  pushl $52
80105649:	6a 34                	push   $0x34
  jmp alltraps
8010564b:	e9 c6 f8 ff ff       	jmp    80104f16 <alltraps>

80105650 <vector53>:
.globl vector53
vector53:
  pushl $0
80105650:	6a 00                	push   $0x0
  pushl $53
80105652:	6a 35                	push   $0x35
  jmp alltraps
80105654:	e9 bd f8 ff ff       	jmp    80104f16 <alltraps>

80105659 <vector54>:
.globl vector54
vector54:
  pushl $0
80105659:	6a 00                	push   $0x0
  pushl $54
8010565b:	6a 36                	push   $0x36
  jmp alltraps
8010565d:	e9 b4 f8 ff ff       	jmp    80104f16 <alltraps>

80105662 <vector55>:
.globl vector55
vector55:
  pushl $0
80105662:	6a 00                	push   $0x0
  pushl $55
80105664:	6a 37                	push   $0x37
  jmp alltraps
80105666:	e9 ab f8 ff ff       	jmp    80104f16 <alltraps>

8010566b <vector56>:
.globl vector56
vector56:
  pushl $0
8010566b:	6a 00                	push   $0x0
  pushl $56
8010566d:	6a 38                	push   $0x38
  jmp alltraps
8010566f:	e9 a2 f8 ff ff       	jmp    80104f16 <alltraps>

80105674 <vector57>:
.globl vector57
vector57:
  pushl $0
80105674:	6a 00                	push   $0x0
  pushl $57
80105676:	6a 39                	push   $0x39
  jmp alltraps
80105678:	e9 99 f8 ff ff       	jmp    80104f16 <alltraps>

8010567d <vector58>:
.globl vector58
vector58:
  pushl $0
8010567d:	6a 00                	push   $0x0
  pushl $58
8010567f:	6a 3a                	push   $0x3a
  jmp alltraps
80105681:	e9 90 f8 ff ff       	jmp    80104f16 <alltraps>

80105686 <vector59>:
.globl vector59
vector59:
  pushl $0
80105686:	6a 00                	push   $0x0
  pushl $59
80105688:	6a 3b                	push   $0x3b
  jmp alltraps
8010568a:	e9 87 f8 ff ff       	jmp    80104f16 <alltraps>

8010568f <vector60>:
.globl vector60
vector60:
  pushl $0
8010568f:	6a 00                	push   $0x0
  pushl $60
80105691:	6a 3c                	push   $0x3c
  jmp alltraps
80105693:	e9 7e f8 ff ff       	jmp    80104f16 <alltraps>

80105698 <vector61>:
.globl vector61
vector61:
  pushl $0
80105698:	6a 00                	push   $0x0
  pushl $61
8010569a:	6a 3d                	push   $0x3d
  jmp alltraps
8010569c:	e9 75 f8 ff ff       	jmp    80104f16 <alltraps>

801056a1 <vector62>:
.globl vector62
vector62:
  pushl $0
801056a1:	6a 00                	push   $0x0
  pushl $62
801056a3:	6a 3e                	push   $0x3e
  jmp alltraps
801056a5:	e9 6c f8 ff ff       	jmp    80104f16 <alltraps>

801056aa <vector63>:
.globl vector63
vector63:
  pushl $0
801056aa:	6a 00                	push   $0x0
  pushl $63
801056ac:	6a 3f                	push   $0x3f
  jmp alltraps
801056ae:	e9 63 f8 ff ff       	jmp    80104f16 <alltraps>

801056b3 <vector64>:
.globl vector64
vector64:
  pushl $0
801056b3:	6a 00                	push   $0x0
  pushl $64
801056b5:	6a 40                	push   $0x40
  jmp alltraps
801056b7:	e9 5a f8 ff ff       	jmp    80104f16 <alltraps>

801056bc <vector65>:
.globl vector65
vector65:
  pushl $0
801056bc:	6a 00                	push   $0x0
  pushl $65
801056be:	6a 41                	push   $0x41
  jmp alltraps
801056c0:	e9 51 f8 ff ff       	jmp    80104f16 <alltraps>

801056c5 <vector66>:
.globl vector66
vector66:
  pushl $0
801056c5:	6a 00                	push   $0x0
  pushl $66
801056c7:	6a 42                	push   $0x42
  jmp alltraps
801056c9:	e9 48 f8 ff ff       	jmp    80104f16 <alltraps>

801056ce <vector67>:
.globl vector67
vector67:
  pushl $0
801056ce:	6a 00                	push   $0x0
  pushl $67
801056d0:	6a 43                	push   $0x43
  jmp alltraps
801056d2:	e9 3f f8 ff ff       	jmp    80104f16 <alltraps>

801056d7 <vector68>:
.globl vector68
vector68:
  pushl $0
801056d7:	6a 00                	push   $0x0
  pushl $68
801056d9:	6a 44                	push   $0x44
  jmp alltraps
801056db:	e9 36 f8 ff ff       	jmp    80104f16 <alltraps>

801056e0 <vector69>:
.globl vector69
vector69:
  pushl $0
801056e0:	6a 00                	push   $0x0
  pushl $69
801056e2:	6a 45                	push   $0x45
  jmp alltraps
801056e4:	e9 2d f8 ff ff       	jmp    80104f16 <alltraps>

801056e9 <vector70>:
.globl vector70
vector70:
  pushl $0
801056e9:	6a 00                	push   $0x0
  pushl $70
801056eb:	6a 46                	push   $0x46
  jmp alltraps
801056ed:	e9 24 f8 ff ff       	jmp    80104f16 <alltraps>

801056f2 <vector71>:
.globl vector71
vector71:
  pushl $0
801056f2:	6a 00                	push   $0x0
  pushl $71
801056f4:	6a 47                	push   $0x47
  jmp alltraps
801056f6:	e9 1b f8 ff ff       	jmp    80104f16 <alltraps>

801056fb <vector72>:
.globl vector72
vector72:
  pushl $0
801056fb:	6a 00                	push   $0x0
  pushl $72
801056fd:	6a 48                	push   $0x48
  jmp alltraps
801056ff:	e9 12 f8 ff ff       	jmp    80104f16 <alltraps>

80105704 <vector73>:
.globl vector73
vector73:
  pushl $0
80105704:	6a 00                	push   $0x0
  pushl $73
80105706:	6a 49                	push   $0x49
  jmp alltraps
80105708:	e9 09 f8 ff ff       	jmp    80104f16 <alltraps>

8010570d <vector74>:
.globl vector74
vector74:
  pushl $0
8010570d:	6a 00                	push   $0x0
  pushl $74
8010570f:	6a 4a                	push   $0x4a
  jmp alltraps
80105711:	e9 00 f8 ff ff       	jmp    80104f16 <alltraps>

80105716 <vector75>:
.globl vector75
vector75:
  pushl $0
80105716:	6a 00                	push   $0x0
  pushl $75
80105718:	6a 4b                	push   $0x4b
  jmp alltraps
8010571a:	e9 f7 f7 ff ff       	jmp    80104f16 <alltraps>

8010571f <vector76>:
.globl vector76
vector76:
  pushl $0
8010571f:	6a 00                	push   $0x0
  pushl $76
80105721:	6a 4c                	push   $0x4c
  jmp alltraps
80105723:	e9 ee f7 ff ff       	jmp    80104f16 <alltraps>

80105728 <vector77>:
.globl vector77
vector77:
  pushl $0
80105728:	6a 00                	push   $0x0
  pushl $77
8010572a:	6a 4d                	push   $0x4d
  jmp alltraps
8010572c:	e9 e5 f7 ff ff       	jmp    80104f16 <alltraps>

80105731 <vector78>:
.globl vector78
vector78:
  pushl $0
80105731:	6a 00                	push   $0x0
  pushl $78
80105733:	6a 4e                	push   $0x4e
  jmp alltraps
80105735:	e9 dc f7 ff ff       	jmp    80104f16 <alltraps>

8010573a <vector79>:
.globl vector79
vector79:
  pushl $0
8010573a:	6a 00                	push   $0x0
  pushl $79
8010573c:	6a 4f                	push   $0x4f
  jmp alltraps
8010573e:	e9 d3 f7 ff ff       	jmp    80104f16 <alltraps>

80105743 <vector80>:
.globl vector80
vector80:
  pushl $0
80105743:	6a 00                	push   $0x0
  pushl $80
80105745:	6a 50                	push   $0x50
  jmp alltraps
80105747:	e9 ca f7 ff ff       	jmp    80104f16 <alltraps>

8010574c <vector81>:
.globl vector81
vector81:
  pushl $0
8010574c:	6a 00                	push   $0x0
  pushl $81
8010574e:	6a 51                	push   $0x51
  jmp alltraps
80105750:	e9 c1 f7 ff ff       	jmp    80104f16 <alltraps>

80105755 <vector82>:
.globl vector82
vector82:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $82
80105757:	6a 52                	push   $0x52
  jmp alltraps
80105759:	e9 b8 f7 ff ff       	jmp    80104f16 <alltraps>

8010575e <vector83>:
.globl vector83
vector83:
  pushl $0
8010575e:	6a 00                	push   $0x0
  pushl $83
80105760:	6a 53                	push   $0x53
  jmp alltraps
80105762:	e9 af f7 ff ff       	jmp    80104f16 <alltraps>

80105767 <vector84>:
.globl vector84
vector84:
  pushl $0
80105767:	6a 00                	push   $0x0
  pushl $84
80105769:	6a 54                	push   $0x54
  jmp alltraps
8010576b:	e9 a6 f7 ff ff       	jmp    80104f16 <alltraps>

80105770 <vector85>:
.globl vector85
vector85:
  pushl $0
80105770:	6a 00                	push   $0x0
  pushl $85
80105772:	6a 55                	push   $0x55
  jmp alltraps
80105774:	e9 9d f7 ff ff       	jmp    80104f16 <alltraps>

80105779 <vector86>:
.globl vector86
vector86:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $86
8010577b:	6a 56                	push   $0x56
  jmp alltraps
8010577d:	e9 94 f7 ff ff       	jmp    80104f16 <alltraps>

80105782 <vector87>:
.globl vector87
vector87:
  pushl $0
80105782:	6a 00                	push   $0x0
  pushl $87
80105784:	6a 57                	push   $0x57
  jmp alltraps
80105786:	e9 8b f7 ff ff       	jmp    80104f16 <alltraps>

8010578b <vector88>:
.globl vector88
vector88:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $88
8010578d:	6a 58                	push   $0x58
  jmp alltraps
8010578f:	e9 82 f7 ff ff       	jmp    80104f16 <alltraps>

80105794 <vector89>:
.globl vector89
vector89:
  pushl $0
80105794:	6a 00                	push   $0x0
  pushl $89
80105796:	6a 59                	push   $0x59
  jmp alltraps
80105798:	e9 79 f7 ff ff       	jmp    80104f16 <alltraps>

8010579d <vector90>:
.globl vector90
vector90:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $90
8010579f:	6a 5a                	push   $0x5a
  jmp alltraps
801057a1:	e9 70 f7 ff ff       	jmp    80104f16 <alltraps>

801057a6 <vector91>:
.globl vector91
vector91:
  pushl $0
801057a6:	6a 00                	push   $0x0
  pushl $91
801057a8:	6a 5b                	push   $0x5b
  jmp alltraps
801057aa:	e9 67 f7 ff ff       	jmp    80104f16 <alltraps>

801057af <vector92>:
.globl vector92
vector92:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $92
801057b1:	6a 5c                	push   $0x5c
  jmp alltraps
801057b3:	e9 5e f7 ff ff       	jmp    80104f16 <alltraps>

801057b8 <vector93>:
.globl vector93
vector93:
  pushl $0
801057b8:	6a 00                	push   $0x0
  pushl $93
801057ba:	6a 5d                	push   $0x5d
  jmp alltraps
801057bc:	e9 55 f7 ff ff       	jmp    80104f16 <alltraps>

801057c1 <vector94>:
.globl vector94
vector94:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $94
801057c3:	6a 5e                	push   $0x5e
  jmp alltraps
801057c5:	e9 4c f7 ff ff       	jmp    80104f16 <alltraps>

801057ca <vector95>:
.globl vector95
vector95:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $95
801057cc:	6a 5f                	push   $0x5f
  jmp alltraps
801057ce:	e9 43 f7 ff ff       	jmp    80104f16 <alltraps>

801057d3 <vector96>:
.globl vector96
vector96:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $96
801057d5:	6a 60                	push   $0x60
  jmp alltraps
801057d7:	e9 3a f7 ff ff       	jmp    80104f16 <alltraps>

801057dc <vector97>:
.globl vector97
vector97:
  pushl $0
801057dc:	6a 00                	push   $0x0
  pushl $97
801057de:	6a 61                	push   $0x61
  jmp alltraps
801057e0:	e9 31 f7 ff ff       	jmp    80104f16 <alltraps>

801057e5 <vector98>:
.globl vector98
vector98:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $98
801057e7:	6a 62                	push   $0x62
  jmp alltraps
801057e9:	e9 28 f7 ff ff       	jmp    80104f16 <alltraps>

801057ee <vector99>:
.globl vector99
vector99:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $99
801057f0:	6a 63                	push   $0x63
  jmp alltraps
801057f2:	e9 1f f7 ff ff       	jmp    80104f16 <alltraps>

801057f7 <vector100>:
.globl vector100
vector100:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $100
801057f9:	6a 64                	push   $0x64
  jmp alltraps
801057fb:	e9 16 f7 ff ff       	jmp    80104f16 <alltraps>

80105800 <vector101>:
.globl vector101
vector101:
  pushl $0
80105800:	6a 00                	push   $0x0
  pushl $101
80105802:	6a 65                	push   $0x65
  jmp alltraps
80105804:	e9 0d f7 ff ff       	jmp    80104f16 <alltraps>

80105809 <vector102>:
.globl vector102
vector102:
  pushl $0
80105809:	6a 00                	push   $0x0
  pushl $102
8010580b:	6a 66                	push   $0x66
  jmp alltraps
8010580d:	e9 04 f7 ff ff       	jmp    80104f16 <alltraps>

80105812 <vector103>:
.globl vector103
vector103:
  pushl $0
80105812:	6a 00                	push   $0x0
  pushl $103
80105814:	6a 67                	push   $0x67
  jmp alltraps
80105816:	e9 fb f6 ff ff       	jmp    80104f16 <alltraps>

8010581b <vector104>:
.globl vector104
vector104:
  pushl $0
8010581b:	6a 00                	push   $0x0
  pushl $104
8010581d:	6a 68                	push   $0x68
  jmp alltraps
8010581f:	e9 f2 f6 ff ff       	jmp    80104f16 <alltraps>

80105824 <vector105>:
.globl vector105
vector105:
  pushl $0
80105824:	6a 00                	push   $0x0
  pushl $105
80105826:	6a 69                	push   $0x69
  jmp alltraps
80105828:	e9 e9 f6 ff ff       	jmp    80104f16 <alltraps>

8010582d <vector106>:
.globl vector106
vector106:
  pushl $0
8010582d:	6a 00                	push   $0x0
  pushl $106
8010582f:	6a 6a                	push   $0x6a
  jmp alltraps
80105831:	e9 e0 f6 ff ff       	jmp    80104f16 <alltraps>

80105836 <vector107>:
.globl vector107
vector107:
  pushl $0
80105836:	6a 00                	push   $0x0
  pushl $107
80105838:	6a 6b                	push   $0x6b
  jmp alltraps
8010583a:	e9 d7 f6 ff ff       	jmp    80104f16 <alltraps>

8010583f <vector108>:
.globl vector108
vector108:
  pushl $0
8010583f:	6a 00                	push   $0x0
  pushl $108
80105841:	6a 6c                	push   $0x6c
  jmp alltraps
80105843:	e9 ce f6 ff ff       	jmp    80104f16 <alltraps>

80105848 <vector109>:
.globl vector109
vector109:
  pushl $0
80105848:	6a 00                	push   $0x0
  pushl $109
8010584a:	6a 6d                	push   $0x6d
  jmp alltraps
8010584c:	e9 c5 f6 ff ff       	jmp    80104f16 <alltraps>

80105851 <vector110>:
.globl vector110
vector110:
  pushl $0
80105851:	6a 00                	push   $0x0
  pushl $110
80105853:	6a 6e                	push   $0x6e
  jmp alltraps
80105855:	e9 bc f6 ff ff       	jmp    80104f16 <alltraps>

8010585a <vector111>:
.globl vector111
vector111:
  pushl $0
8010585a:	6a 00                	push   $0x0
  pushl $111
8010585c:	6a 6f                	push   $0x6f
  jmp alltraps
8010585e:	e9 b3 f6 ff ff       	jmp    80104f16 <alltraps>

80105863 <vector112>:
.globl vector112
vector112:
  pushl $0
80105863:	6a 00                	push   $0x0
  pushl $112
80105865:	6a 70                	push   $0x70
  jmp alltraps
80105867:	e9 aa f6 ff ff       	jmp    80104f16 <alltraps>

8010586c <vector113>:
.globl vector113
vector113:
  pushl $0
8010586c:	6a 00                	push   $0x0
  pushl $113
8010586e:	6a 71                	push   $0x71
  jmp alltraps
80105870:	e9 a1 f6 ff ff       	jmp    80104f16 <alltraps>

80105875 <vector114>:
.globl vector114
vector114:
  pushl $0
80105875:	6a 00                	push   $0x0
  pushl $114
80105877:	6a 72                	push   $0x72
  jmp alltraps
80105879:	e9 98 f6 ff ff       	jmp    80104f16 <alltraps>

8010587e <vector115>:
.globl vector115
vector115:
  pushl $0
8010587e:	6a 00                	push   $0x0
  pushl $115
80105880:	6a 73                	push   $0x73
  jmp alltraps
80105882:	e9 8f f6 ff ff       	jmp    80104f16 <alltraps>

80105887 <vector116>:
.globl vector116
vector116:
  pushl $0
80105887:	6a 00                	push   $0x0
  pushl $116
80105889:	6a 74                	push   $0x74
  jmp alltraps
8010588b:	e9 86 f6 ff ff       	jmp    80104f16 <alltraps>

80105890 <vector117>:
.globl vector117
vector117:
  pushl $0
80105890:	6a 00                	push   $0x0
  pushl $117
80105892:	6a 75                	push   $0x75
  jmp alltraps
80105894:	e9 7d f6 ff ff       	jmp    80104f16 <alltraps>

80105899 <vector118>:
.globl vector118
vector118:
  pushl $0
80105899:	6a 00                	push   $0x0
  pushl $118
8010589b:	6a 76                	push   $0x76
  jmp alltraps
8010589d:	e9 74 f6 ff ff       	jmp    80104f16 <alltraps>

801058a2 <vector119>:
.globl vector119
vector119:
  pushl $0
801058a2:	6a 00                	push   $0x0
  pushl $119
801058a4:	6a 77                	push   $0x77
  jmp alltraps
801058a6:	e9 6b f6 ff ff       	jmp    80104f16 <alltraps>

801058ab <vector120>:
.globl vector120
vector120:
  pushl $0
801058ab:	6a 00                	push   $0x0
  pushl $120
801058ad:	6a 78                	push   $0x78
  jmp alltraps
801058af:	e9 62 f6 ff ff       	jmp    80104f16 <alltraps>

801058b4 <vector121>:
.globl vector121
vector121:
  pushl $0
801058b4:	6a 00                	push   $0x0
  pushl $121
801058b6:	6a 79                	push   $0x79
  jmp alltraps
801058b8:	e9 59 f6 ff ff       	jmp    80104f16 <alltraps>

801058bd <vector122>:
.globl vector122
vector122:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $122
801058bf:	6a 7a                	push   $0x7a
  jmp alltraps
801058c1:	e9 50 f6 ff ff       	jmp    80104f16 <alltraps>

801058c6 <vector123>:
.globl vector123
vector123:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $123
801058c8:	6a 7b                	push   $0x7b
  jmp alltraps
801058ca:	e9 47 f6 ff ff       	jmp    80104f16 <alltraps>

801058cf <vector124>:
.globl vector124
vector124:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $124
801058d1:	6a 7c                	push   $0x7c
  jmp alltraps
801058d3:	e9 3e f6 ff ff       	jmp    80104f16 <alltraps>

801058d8 <vector125>:
.globl vector125
vector125:
  pushl $0
801058d8:	6a 00                	push   $0x0
  pushl $125
801058da:	6a 7d                	push   $0x7d
  jmp alltraps
801058dc:	e9 35 f6 ff ff       	jmp    80104f16 <alltraps>

801058e1 <vector126>:
.globl vector126
vector126:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $126
801058e3:	6a 7e                	push   $0x7e
  jmp alltraps
801058e5:	e9 2c f6 ff ff       	jmp    80104f16 <alltraps>

801058ea <vector127>:
.globl vector127
vector127:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $127
801058ec:	6a 7f                	push   $0x7f
  jmp alltraps
801058ee:	e9 23 f6 ff ff       	jmp    80104f16 <alltraps>

801058f3 <vector128>:
.globl vector128
vector128:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $128
801058f5:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801058fa:	e9 17 f6 ff ff       	jmp    80104f16 <alltraps>

801058ff <vector129>:
.globl vector129
vector129:
  pushl $0
801058ff:	6a 00                	push   $0x0
  pushl $129
80105901:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105906:	e9 0b f6 ff ff       	jmp    80104f16 <alltraps>

8010590b <vector130>:
.globl vector130
vector130:
  pushl $0
8010590b:	6a 00                	push   $0x0
  pushl $130
8010590d:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105912:	e9 ff f5 ff ff       	jmp    80104f16 <alltraps>

80105917 <vector131>:
.globl vector131
vector131:
  pushl $0
80105917:	6a 00                	push   $0x0
  pushl $131
80105919:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010591e:	e9 f3 f5 ff ff       	jmp    80104f16 <alltraps>

80105923 <vector132>:
.globl vector132
vector132:
  pushl $0
80105923:	6a 00                	push   $0x0
  pushl $132
80105925:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010592a:	e9 e7 f5 ff ff       	jmp    80104f16 <alltraps>

8010592f <vector133>:
.globl vector133
vector133:
  pushl $0
8010592f:	6a 00                	push   $0x0
  pushl $133
80105931:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105936:	e9 db f5 ff ff       	jmp    80104f16 <alltraps>

8010593b <vector134>:
.globl vector134
vector134:
  pushl $0
8010593b:	6a 00                	push   $0x0
  pushl $134
8010593d:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105942:	e9 cf f5 ff ff       	jmp    80104f16 <alltraps>

80105947 <vector135>:
.globl vector135
vector135:
  pushl $0
80105947:	6a 00                	push   $0x0
  pushl $135
80105949:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010594e:	e9 c3 f5 ff ff       	jmp    80104f16 <alltraps>

80105953 <vector136>:
.globl vector136
vector136:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $136
80105955:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010595a:	e9 b7 f5 ff ff       	jmp    80104f16 <alltraps>

8010595f <vector137>:
.globl vector137
vector137:
  pushl $0
8010595f:	6a 00                	push   $0x0
  pushl $137
80105961:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105966:	e9 ab f5 ff ff       	jmp    80104f16 <alltraps>

8010596b <vector138>:
.globl vector138
vector138:
  pushl $0
8010596b:	6a 00                	push   $0x0
  pushl $138
8010596d:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105972:	e9 9f f5 ff ff       	jmp    80104f16 <alltraps>

80105977 <vector139>:
.globl vector139
vector139:
  pushl $0
80105977:	6a 00                	push   $0x0
  pushl $139
80105979:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010597e:	e9 93 f5 ff ff       	jmp    80104f16 <alltraps>

80105983 <vector140>:
.globl vector140
vector140:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $140
80105985:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010598a:	e9 87 f5 ff ff       	jmp    80104f16 <alltraps>

8010598f <vector141>:
.globl vector141
vector141:
  pushl $0
8010598f:	6a 00                	push   $0x0
  pushl $141
80105991:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105996:	e9 7b f5 ff ff       	jmp    80104f16 <alltraps>

8010599b <vector142>:
.globl vector142
vector142:
  pushl $0
8010599b:	6a 00                	push   $0x0
  pushl $142
8010599d:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801059a2:	e9 6f f5 ff ff       	jmp    80104f16 <alltraps>

801059a7 <vector143>:
.globl vector143
vector143:
  pushl $0
801059a7:	6a 00                	push   $0x0
  pushl $143
801059a9:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801059ae:	e9 63 f5 ff ff       	jmp    80104f16 <alltraps>

801059b3 <vector144>:
.globl vector144
vector144:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $144
801059b5:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801059ba:	e9 57 f5 ff ff       	jmp    80104f16 <alltraps>

801059bf <vector145>:
.globl vector145
vector145:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $145
801059c1:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801059c6:	e9 4b f5 ff ff       	jmp    80104f16 <alltraps>

801059cb <vector146>:
.globl vector146
vector146:
  pushl $0
801059cb:	6a 00                	push   $0x0
  pushl $146
801059cd:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801059d2:	e9 3f f5 ff ff       	jmp    80104f16 <alltraps>

801059d7 <vector147>:
.globl vector147
vector147:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $147
801059d9:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801059de:	e9 33 f5 ff ff       	jmp    80104f16 <alltraps>

801059e3 <vector148>:
.globl vector148
vector148:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $148
801059e5:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801059ea:	e9 27 f5 ff ff       	jmp    80104f16 <alltraps>

801059ef <vector149>:
.globl vector149
vector149:
  pushl $0
801059ef:	6a 00                	push   $0x0
  pushl $149
801059f1:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801059f6:	e9 1b f5 ff ff       	jmp    80104f16 <alltraps>

801059fb <vector150>:
.globl vector150
vector150:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $150
801059fd:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105a02:	e9 0f f5 ff ff       	jmp    80104f16 <alltraps>

80105a07 <vector151>:
.globl vector151
vector151:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $151
80105a09:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105a0e:	e9 03 f5 ff ff       	jmp    80104f16 <alltraps>

80105a13 <vector152>:
.globl vector152
vector152:
  pushl $0
80105a13:	6a 00                	push   $0x0
  pushl $152
80105a15:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105a1a:	e9 f7 f4 ff ff       	jmp    80104f16 <alltraps>

80105a1f <vector153>:
.globl vector153
vector153:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $153
80105a21:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105a26:	e9 eb f4 ff ff       	jmp    80104f16 <alltraps>

80105a2b <vector154>:
.globl vector154
vector154:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $154
80105a2d:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105a32:	e9 df f4 ff ff       	jmp    80104f16 <alltraps>

80105a37 <vector155>:
.globl vector155
vector155:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $155
80105a39:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105a3e:	e9 d3 f4 ff ff       	jmp    80104f16 <alltraps>

80105a43 <vector156>:
.globl vector156
vector156:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $156
80105a45:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105a4a:	e9 c7 f4 ff ff       	jmp    80104f16 <alltraps>

80105a4f <vector157>:
.globl vector157
vector157:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $157
80105a51:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105a56:	e9 bb f4 ff ff       	jmp    80104f16 <alltraps>

80105a5b <vector158>:
.globl vector158
vector158:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $158
80105a5d:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105a62:	e9 af f4 ff ff       	jmp    80104f16 <alltraps>

80105a67 <vector159>:
.globl vector159
vector159:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $159
80105a69:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105a6e:	e9 a3 f4 ff ff       	jmp    80104f16 <alltraps>

80105a73 <vector160>:
.globl vector160
vector160:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $160
80105a75:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105a7a:	e9 97 f4 ff ff       	jmp    80104f16 <alltraps>

80105a7f <vector161>:
.globl vector161
vector161:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $161
80105a81:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105a86:	e9 8b f4 ff ff       	jmp    80104f16 <alltraps>

80105a8b <vector162>:
.globl vector162
vector162:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $162
80105a8d:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105a92:	e9 7f f4 ff ff       	jmp    80104f16 <alltraps>

80105a97 <vector163>:
.globl vector163
vector163:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $163
80105a99:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105a9e:	e9 73 f4 ff ff       	jmp    80104f16 <alltraps>

80105aa3 <vector164>:
.globl vector164
vector164:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $164
80105aa5:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105aaa:	e9 67 f4 ff ff       	jmp    80104f16 <alltraps>

80105aaf <vector165>:
.globl vector165
vector165:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $165
80105ab1:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ab6:	e9 5b f4 ff ff       	jmp    80104f16 <alltraps>

80105abb <vector166>:
.globl vector166
vector166:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $166
80105abd:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ac2:	e9 4f f4 ff ff       	jmp    80104f16 <alltraps>

80105ac7 <vector167>:
.globl vector167
vector167:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $167
80105ac9:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ace:	e9 43 f4 ff ff       	jmp    80104f16 <alltraps>

80105ad3 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $168
80105ad5:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ada:	e9 37 f4 ff ff       	jmp    80104f16 <alltraps>

80105adf <vector169>:
.globl vector169
vector169:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $169
80105ae1:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105ae6:	e9 2b f4 ff ff       	jmp    80104f16 <alltraps>

80105aeb <vector170>:
.globl vector170
vector170:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $170
80105aed:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105af2:	e9 1f f4 ff ff       	jmp    80104f16 <alltraps>

80105af7 <vector171>:
.globl vector171
vector171:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $171
80105af9:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105afe:	e9 13 f4 ff ff       	jmp    80104f16 <alltraps>

80105b03 <vector172>:
.globl vector172
vector172:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $172
80105b05:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105b0a:	e9 07 f4 ff ff       	jmp    80104f16 <alltraps>

80105b0f <vector173>:
.globl vector173
vector173:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $173
80105b11:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105b16:	e9 fb f3 ff ff       	jmp    80104f16 <alltraps>

80105b1b <vector174>:
.globl vector174
vector174:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $174
80105b1d:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105b22:	e9 ef f3 ff ff       	jmp    80104f16 <alltraps>

80105b27 <vector175>:
.globl vector175
vector175:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $175
80105b29:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105b2e:	e9 e3 f3 ff ff       	jmp    80104f16 <alltraps>

80105b33 <vector176>:
.globl vector176
vector176:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $176
80105b35:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105b3a:	e9 d7 f3 ff ff       	jmp    80104f16 <alltraps>

80105b3f <vector177>:
.globl vector177
vector177:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $177
80105b41:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105b46:	e9 cb f3 ff ff       	jmp    80104f16 <alltraps>

80105b4b <vector178>:
.globl vector178
vector178:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $178
80105b4d:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105b52:	e9 bf f3 ff ff       	jmp    80104f16 <alltraps>

80105b57 <vector179>:
.globl vector179
vector179:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $179
80105b59:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105b5e:	e9 b3 f3 ff ff       	jmp    80104f16 <alltraps>

80105b63 <vector180>:
.globl vector180
vector180:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $180
80105b65:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105b6a:	e9 a7 f3 ff ff       	jmp    80104f16 <alltraps>

80105b6f <vector181>:
.globl vector181
vector181:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $181
80105b71:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105b76:	e9 9b f3 ff ff       	jmp    80104f16 <alltraps>

80105b7b <vector182>:
.globl vector182
vector182:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $182
80105b7d:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105b82:	e9 8f f3 ff ff       	jmp    80104f16 <alltraps>

80105b87 <vector183>:
.globl vector183
vector183:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $183
80105b89:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105b8e:	e9 83 f3 ff ff       	jmp    80104f16 <alltraps>

80105b93 <vector184>:
.globl vector184
vector184:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $184
80105b95:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105b9a:	e9 77 f3 ff ff       	jmp    80104f16 <alltraps>

80105b9f <vector185>:
.globl vector185
vector185:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $185
80105ba1:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105ba6:	e9 6b f3 ff ff       	jmp    80104f16 <alltraps>

80105bab <vector186>:
.globl vector186
vector186:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $186
80105bad:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105bb2:	e9 5f f3 ff ff       	jmp    80104f16 <alltraps>

80105bb7 <vector187>:
.globl vector187
vector187:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $187
80105bb9:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105bbe:	e9 53 f3 ff ff       	jmp    80104f16 <alltraps>

80105bc3 <vector188>:
.globl vector188
vector188:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $188
80105bc5:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105bca:	e9 47 f3 ff ff       	jmp    80104f16 <alltraps>

80105bcf <vector189>:
.globl vector189
vector189:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $189
80105bd1:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105bd6:	e9 3b f3 ff ff       	jmp    80104f16 <alltraps>

80105bdb <vector190>:
.globl vector190
vector190:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $190
80105bdd:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105be2:	e9 2f f3 ff ff       	jmp    80104f16 <alltraps>

80105be7 <vector191>:
.globl vector191
vector191:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $191
80105be9:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105bee:	e9 23 f3 ff ff       	jmp    80104f16 <alltraps>

80105bf3 <vector192>:
.globl vector192
vector192:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $192
80105bf5:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105bfa:	e9 17 f3 ff ff       	jmp    80104f16 <alltraps>

80105bff <vector193>:
.globl vector193
vector193:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $193
80105c01:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105c06:	e9 0b f3 ff ff       	jmp    80104f16 <alltraps>

80105c0b <vector194>:
.globl vector194
vector194:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $194
80105c0d:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105c12:	e9 ff f2 ff ff       	jmp    80104f16 <alltraps>

80105c17 <vector195>:
.globl vector195
vector195:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $195
80105c19:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105c1e:	e9 f3 f2 ff ff       	jmp    80104f16 <alltraps>

80105c23 <vector196>:
.globl vector196
vector196:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $196
80105c25:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105c2a:	e9 e7 f2 ff ff       	jmp    80104f16 <alltraps>

80105c2f <vector197>:
.globl vector197
vector197:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $197
80105c31:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105c36:	e9 db f2 ff ff       	jmp    80104f16 <alltraps>

80105c3b <vector198>:
.globl vector198
vector198:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $198
80105c3d:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105c42:	e9 cf f2 ff ff       	jmp    80104f16 <alltraps>

80105c47 <vector199>:
.globl vector199
vector199:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $199
80105c49:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105c4e:	e9 c3 f2 ff ff       	jmp    80104f16 <alltraps>

80105c53 <vector200>:
.globl vector200
vector200:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $200
80105c55:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105c5a:	e9 b7 f2 ff ff       	jmp    80104f16 <alltraps>

80105c5f <vector201>:
.globl vector201
vector201:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $201
80105c61:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105c66:	e9 ab f2 ff ff       	jmp    80104f16 <alltraps>

80105c6b <vector202>:
.globl vector202
vector202:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $202
80105c6d:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105c72:	e9 9f f2 ff ff       	jmp    80104f16 <alltraps>

80105c77 <vector203>:
.globl vector203
vector203:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $203
80105c79:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105c7e:	e9 93 f2 ff ff       	jmp    80104f16 <alltraps>

80105c83 <vector204>:
.globl vector204
vector204:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $204
80105c85:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105c8a:	e9 87 f2 ff ff       	jmp    80104f16 <alltraps>

80105c8f <vector205>:
.globl vector205
vector205:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $205
80105c91:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105c96:	e9 7b f2 ff ff       	jmp    80104f16 <alltraps>

80105c9b <vector206>:
.globl vector206
vector206:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $206
80105c9d:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105ca2:	e9 6f f2 ff ff       	jmp    80104f16 <alltraps>

80105ca7 <vector207>:
.globl vector207
vector207:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $207
80105ca9:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105cae:	e9 63 f2 ff ff       	jmp    80104f16 <alltraps>

80105cb3 <vector208>:
.globl vector208
vector208:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $208
80105cb5:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105cba:	e9 57 f2 ff ff       	jmp    80104f16 <alltraps>

80105cbf <vector209>:
.globl vector209
vector209:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $209
80105cc1:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105cc6:	e9 4b f2 ff ff       	jmp    80104f16 <alltraps>

80105ccb <vector210>:
.globl vector210
vector210:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $210
80105ccd:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105cd2:	e9 3f f2 ff ff       	jmp    80104f16 <alltraps>

80105cd7 <vector211>:
.globl vector211
vector211:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $211
80105cd9:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105cde:	e9 33 f2 ff ff       	jmp    80104f16 <alltraps>

80105ce3 <vector212>:
.globl vector212
vector212:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $212
80105ce5:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105cea:	e9 27 f2 ff ff       	jmp    80104f16 <alltraps>

80105cef <vector213>:
.globl vector213
vector213:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $213
80105cf1:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105cf6:	e9 1b f2 ff ff       	jmp    80104f16 <alltraps>

80105cfb <vector214>:
.globl vector214
vector214:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $214
80105cfd:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105d02:	e9 0f f2 ff ff       	jmp    80104f16 <alltraps>

80105d07 <vector215>:
.globl vector215
vector215:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $215
80105d09:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105d0e:	e9 03 f2 ff ff       	jmp    80104f16 <alltraps>

80105d13 <vector216>:
.globl vector216
vector216:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $216
80105d15:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105d1a:	e9 f7 f1 ff ff       	jmp    80104f16 <alltraps>

80105d1f <vector217>:
.globl vector217
vector217:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $217
80105d21:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105d26:	e9 eb f1 ff ff       	jmp    80104f16 <alltraps>

80105d2b <vector218>:
.globl vector218
vector218:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $218
80105d2d:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105d32:	e9 df f1 ff ff       	jmp    80104f16 <alltraps>

80105d37 <vector219>:
.globl vector219
vector219:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $219
80105d39:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105d3e:	e9 d3 f1 ff ff       	jmp    80104f16 <alltraps>

80105d43 <vector220>:
.globl vector220
vector220:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $220
80105d45:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105d4a:	e9 c7 f1 ff ff       	jmp    80104f16 <alltraps>

80105d4f <vector221>:
.globl vector221
vector221:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $221
80105d51:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105d56:	e9 bb f1 ff ff       	jmp    80104f16 <alltraps>

80105d5b <vector222>:
.globl vector222
vector222:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $222
80105d5d:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105d62:	e9 af f1 ff ff       	jmp    80104f16 <alltraps>

80105d67 <vector223>:
.globl vector223
vector223:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $223
80105d69:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105d6e:	e9 a3 f1 ff ff       	jmp    80104f16 <alltraps>

80105d73 <vector224>:
.globl vector224
vector224:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $224
80105d75:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105d7a:	e9 97 f1 ff ff       	jmp    80104f16 <alltraps>

80105d7f <vector225>:
.globl vector225
vector225:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $225
80105d81:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105d86:	e9 8b f1 ff ff       	jmp    80104f16 <alltraps>

80105d8b <vector226>:
.globl vector226
vector226:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $226
80105d8d:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105d92:	e9 7f f1 ff ff       	jmp    80104f16 <alltraps>

80105d97 <vector227>:
.globl vector227
vector227:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $227
80105d99:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105d9e:	e9 73 f1 ff ff       	jmp    80104f16 <alltraps>

80105da3 <vector228>:
.globl vector228
vector228:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $228
80105da5:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105daa:	e9 67 f1 ff ff       	jmp    80104f16 <alltraps>

80105daf <vector229>:
.globl vector229
vector229:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $229
80105db1:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105db6:	e9 5b f1 ff ff       	jmp    80104f16 <alltraps>

80105dbb <vector230>:
.globl vector230
vector230:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $230
80105dbd:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105dc2:	e9 4f f1 ff ff       	jmp    80104f16 <alltraps>

80105dc7 <vector231>:
.globl vector231
vector231:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $231
80105dc9:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105dce:	e9 43 f1 ff ff       	jmp    80104f16 <alltraps>

80105dd3 <vector232>:
.globl vector232
vector232:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $232
80105dd5:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105dda:	e9 37 f1 ff ff       	jmp    80104f16 <alltraps>

80105ddf <vector233>:
.globl vector233
vector233:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $233
80105de1:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105de6:	e9 2b f1 ff ff       	jmp    80104f16 <alltraps>

80105deb <vector234>:
.globl vector234
vector234:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $234
80105ded:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105df2:	e9 1f f1 ff ff       	jmp    80104f16 <alltraps>

80105df7 <vector235>:
.globl vector235
vector235:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $235
80105df9:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105dfe:	e9 13 f1 ff ff       	jmp    80104f16 <alltraps>

80105e03 <vector236>:
.globl vector236
vector236:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $236
80105e05:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105e0a:	e9 07 f1 ff ff       	jmp    80104f16 <alltraps>

80105e0f <vector237>:
.globl vector237
vector237:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $237
80105e11:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105e16:	e9 fb f0 ff ff       	jmp    80104f16 <alltraps>

80105e1b <vector238>:
.globl vector238
vector238:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $238
80105e1d:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105e22:	e9 ef f0 ff ff       	jmp    80104f16 <alltraps>

80105e27 <vector239>:
.globl vector239
vector239:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $239
80105e29:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105e2e:	e9 e3 f0 ff ff       	jmp    80104f16 <alltraps>

80105e33 <vector240>:
.globl vector240
vector240:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $240
80105e35:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105e3a:	e9 d7 f0 ff ff       	jmp    80104f16 <alltraps>

80105e3f <vector241>:
.globl vector241
vector241:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $241
80105e41:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105e46:	e9 cb f0 ff ff       	jmp    80104f16 <alltraps>

80105e4b <vector242>:
.globl vector242
vector242:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $242
80105e4d:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105e52:	e9 bf f0 ff ff       	jmp    80104f16 <alltraps>

80105e57 <vector243>:
.globl vector243
vector243:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $243
80105e59:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105e5e:	e9 b3 f0 ff ff       	jmp    80104f16 <alltraps>

80105e63 <vector244>:
.globl vector244
vector244:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $244
80105e65:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105e6a:	e9 a7 f0 ff ff       	jmp    80104f16 <alltraps>

80105e6f <vector245>:
.globl vector245
vector245:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $245
80105e71:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105e76:	e9 9b f0 ff ff       	jmp    80104f16 <alltraps>

80105e7b <vector246>:
.globl vector246
vector246:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $246
80105e7d:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105e82:	e9 8f f0 ff ff       	jmp    80104f16 <alltraps>

80105e87 <vector247>:
.globl vector247
vector247:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $247
80105e89:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105e8e:	e9 83 f0 ff ff       	jmp    80104f16 <alltraps>

80105e93 <vector248>:
.globl vector248
vector248:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $248
80105e95:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105e9a:	e9 77 f0 ff ff       	jmp    80104f16 <alltraps>

80105e9f <vector249>:
.globl vector249
vector249:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $249
80105ea1:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105ea6:	e9 6b f0 ff ff       	jmp    80104f16 <alltraps>

80105eab <vector250>:
.globl vector250
vector250:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $250
80105ead:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105eb2:	e9 5f f0 ff ff       	jmp    80104f16 <alltraps>

80105eb7 <vector251>:
.globl vector251
vector251:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $251
80105eb9:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105ebe:	e9 53 f0 ff ff       	jmp    80104f16 <alltraps>

80105ec3 <vector252>:
.globl vector252
vector252:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $252
80105ec5:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105eca:	e9 47 f0 ff ff       	jmp    80104f16 <alltraps>

80105ecf <vector253>:
.globl vector253
vector253:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $253
80105ed1:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105ed6:	e9 3b f0 ff ff       	jmp    80104f16 <alltraps>

80105edb <vector254>:
.globl vector254
vector254:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $254
80105edd:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105ee2:	e9 2f f0 ff ff       	jmp    80104f16 <alltraps>

80105ee7 <vector255>:
.globl vector255
vector255:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $255
80105ee9:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105eee:	e9 23 f0 ff ff       	jmp    80104f16 <alltraps>

80105ef3 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105ef3:	55                   	push   %ebp
80105ef4:	89 e5                	mov    %esp,%ebp
80105ef6:	57                   	push   %edi
80105ef7:	56                   	push   %esi
80105ef8:	53                   	push   %ebx
80105ef9:	83 ec 0c             	sub    $0xc,%esp
80105efc:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105efe:	c1 ea 16             	shr    $0x16,%edx
80105f01:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105f04:	8b 37                	mov    (%edi),%esi
80105f06:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105f0c:	74 20                	je     80105f2e <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105f0e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105f14:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105f1a:	c1 eb 0c             	shr    $0xc,%ebx
80105f1d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105f23:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f29:	5b                   	pop    %ebx
80105f2a:	5e                   	pop    %esi
80105f2b:	5f                   	pop    %edi
80105f2c:	5d                   	pop    %ebp
80105f2d:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105f2e:	85 c9                	test   %ecx,%ecx
80105f30:	74 2b                	je     80105f5d <walkpgdir+0x6a>
80105f32:	e8 f0 c0 ff ff       	call   80102027 <kalloc>
80105f37:	89 c6                	mov    %eax,%esi
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	74 20                	je     80105f5d <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105f3d:	83 ec 04             	sub    $0x4,%esp
80105f40:	68 00 10 00 00       	push   $0x1000
80105f45:	6a 00                	push   $0x0
80105f47:	50                   	push   %eax
80105f48:	e8 23 de ff ff       	call   80103d70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105f4d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105f53:	83 c8 07             	or     $0x7,%eax
80105f56:	89 07                	mov    %eax,(%edi)
80105f58:	83 c4 10             	add    $0x10,%esp
80105f5b:	eb bd                	jmp    80105f1a <walkpgdir+0x27>
      return 0;
80105f5d:	b8 00 00 00 00       	mov    $0x0,%eax
80105f62:	eb c2                	jmp    80105f26 <walkpgdir+0x33>

80105f64 <seginit>:
{
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	57                   	push   %edi
80105f68:	56                   	push   %esi
80105f69:	53                   	push   %ebx
80105f6a:	83 ec 2c             	sub    $0x2c,%esp
  c = &cpus[cpuid()];
80105f6d:	e8 60 d1 ff ff       	call   801030d2 <cpuid>
80105f72:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105f74:	8d 14 80             	lea    (%eax,%eax,4),%edx
80105f77:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
80105f7a:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80105f7d:	c1 e0 04             	shl    $0x4,%eax
80105f80:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
80105f87:	ff ff 
80105f89:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
80105f90:	00 00 
80105f92:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
80105f99:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80105f9c:	01 d9                	add    %ebx,%ecx
80105f9e:	c1 e1 04             	shl    $0x4,%ecx
80105fa1:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
80105fa8:	83 e6 f0             	and    $0xfffffff0,%esi
80105fab:	89 f7                	mov    %esi,%edi
80105fad:	83 cf 0a             	or     $0xa,%edi
80105fb0:	89 fa                	mov    %edi,%edx
80105fb2:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105fb8:	83 ce 1a             	or     $0x1a,%esi
80105fbb:	89 f2                	mov    %esi,%edx
80105fbd:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105fc3:	83 e6 9f             	and    $0xffffff9f,%esi
80105fc6:	89 f2                	mov    %esi,%edx
80105fc8:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105fce:	83 ce 80             	or     $0xffffff80,%esi
80105fd1:	89 f2                	mov    %esi,%edx
80105fd3:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105fd9:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
80105fe0:	83 ce 0f             	or     $0xf,%esi
80105fe3:	89 f2                	mov    %esi,%edx
80105fe5:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105feb:	89 f7                	mov    %esi,%edi
80105fed:	83 e7 ef             	and    $0xffffffef,%edi
80105ff0:	89 fa                	mov    %edi,%edx
80105ff2:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105ff8:	83 e6 cf             	and    $0xffffffcf,%esi
80105ffb:	89 f2                	mov    %esi,%edx
80105ffd:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80106003:	89 f7                	mov    %esi,%edi
80106005:	83 cf 40             	or     $0x40,%edi
80106008:	89 fa                	mov    %edi,%edx
8010600a:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80106010:	83 ce c0             	or     $0xffffffc0,%esi
80106013:	89 f2                	mov    %esi,%edx
80106015:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
8010601b:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106022:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
80106029:	ff ff 
8010602b:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
80106032:	00 00 
80106034:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
8010603b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010603e:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106041:	c1 e1 04             	shl    $0x4,%ecx
80106044:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
8010604b:	83 e6 f0             	and    $0xfffffff0,%esi
8010604e:	89 f7                	mov    %esi,%edi
80106050:	83 cf 02             	or     $0x2,%edi
80106053:	89 fa                	mov    %edi,%edx
80106055:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
8010605b:	83 ce 12             	or     $0x12,%esi
8010605e:	89 f2                	mov    %esi,%edx
80106060:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106066:	83 e6 9f             	and    $0xffffff9f,%esi
80106069:	89 f2                	mov    %esi,%edx
8010606b:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80106071:	83 ce 80             	or     $0xffffff80,%esi
80106074:	89 f2                	mov    %esi,%edx
80106076:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
8010607c:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
80106083:	83 ce 0f             	or     $0xf,%esi
80106086:	89 f2                	mov    %esi,%edx
80106088:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010608e:	89 f7                	mov    %esi,%edi
80106090:	83 e7 ef             	and    $0xffffffef,%edi
80106093:	89 fa                	mov    %edi,%edx
80106095:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
8010609b:	83 e6 cf             	and    $0xffffffcf,%esi
8010609e:	89 f2                	mov    %esi,%edx
801060a0:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
801060a6:	89 f7                	mov    %esi,%edi
801060a8:	83 cf 40             	or     $0x40,%edi
801060ab:	89 fa                	mov    %edi,%edx
801060ad:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
801060b3:	83 ce c0             	or     $0xffffffc0,%esi
801060b6:	89 f2                	mov    %esi,%edx
801060b8:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
801060be:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801060c5:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
801060cc:	ff ff 
801060ce:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
801060d5:	00 00 
801060d7:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
801060de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801060e1:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801060e4:	c1 e1 04             	shl    $0x4,%ecx
801060e7:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
801060ee:	83 e6 f0             	and    $0xfffffff0,%esi
801060f1:	89 f7                	mov    %esi,%edi
801060f3:	83 cf 0a             	or     $0xa,%edi
801060f6:	89 fa                	mov    %edi,%edx
801060f8:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
801060fe:	89 f7                	mov    %esi,%edi
80106100:	83 cf 1a             	or     $0x1a,%edi
80106103:	89 fa                	mov    %edi,%edx
80106105:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
8010610b:	83 ce 7a             	or     $0x7a,%esi
8010610e:	89 f2                	mov    %esi,%edx
80106110:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80106116:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
8010611d:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
80106124:	83 ce 0f             	or     $0xf,%esi
80106127:	89 f2                	mov    %esi,%edx
80106129:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010612f:	89 f7                	mov    %esi,%edi
80106131:	83 e7 ef             	and    $0xffffffef,%edi
80106134:	89 fa                	mov    %edi,%edx
80106136:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010613c:	83 e6 cf             	and    $0xffffffcf,%esi
8010613f:	89 f2                	mov    %esi,%edx
80106141:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106147:	89 f7                	mov    %esi,%edi
80106149:	83 cf 40             	or     $0x40,%edi
8010614c:	89 fa                	mov    %edi,%edx
8010614e:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106154:	83 ce c0             	or     $0xffffffc0,%esi
80106157:	89 f2                	mov    %esi,%edx
80106159:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010615f:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106166:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
8010616d:	ff ff 
8010616f:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
80106176:	00 00 
80106178:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
8010617f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106182:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106185:	c1 e1 04             	shl    $0x4,%ecx
80106188:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
8010618f:	83 e6 f0             	and    $0xfffffff0,%esi
80106192:	89 f7                	mov    %esi,%edi
80106194:	83 cf 02             	or     $0x2,%edi
80106197:	89 fa                	mov    %edi,%edx
80106199:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
8010619f:	89 f7                	mov    %esi,%edi
801061a1:	83 cf 12             	or     $0x12,%edi
801061a4:	89 fa                	mov    %edi,%edx
801061a6:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
801061ac:	83 ce 72             	or     $0x72,%esi
801061af:	89 f2                	mov    %esi,%edx
801061b1:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
801061b7:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
801061be:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
801061c5:	83 ce 0f             	or     $0xf,%esi
801061c8:	89 f2                	mov    %esi,%edx
801061ca:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801061d0:	89 f7                	mov    %esi,%edi
801061d2:	83 e7 ef             	and    $0xffffffef,%edi
801061d5:	89 fa                	mov    %edi,%edx
801061d7:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801061dd:	83 e6 cf             	and    $0xffffffcf,%esi
801061e0:	89 f2                	mov    %esi,%edx
801061e2:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801061e8:	89 f7                	mov    %esi,%edi
801061ea:	83 cf 40             	or     $0x40,%edi
801061ed:	89 fa                	mov    %edi,%edx
801061ef:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801061f5:	83 ce c0             	or     $0xffffffc0,%esi
801061f8:	89 f2                	mov    %esi,%edx
801061fa:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106200:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106207:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010620a:	01 da                	add    %ebx,%edx
8010620c:	c1 e2 04             	shl    $0x4,%edx
8010620f:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
80106215:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
8010621b:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
8010621f:	c1 ea 10             	shr    $0x10,%edx
80106222:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106226:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106229:	0f 01 10             	lgdtl  (%eax)
}
8010622c:	83 c4 2c             	add    $0x2c,%esp
8010622f:	5b                   	pop    %ebx
80106230:	5e                   	pop    %esi
80106231:	5f                   	pop    %edi
80106232:	5d                   	pop    %ebp
80106233:	c3                   	ret    

80106234 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	57                   	push   %edi
80106238:	56                   	push   %esi
80106239:	53                   	push   %ebx
8010623a:	83 ec 0c             	sub    $0xc,%esp
8010623d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106240:	8b 75 14             	mov    0x14(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106243:	89 fb                	mov    %edi,%ebx
80106245:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010624b:	03 7d 10             	add    0x10(%ebp),%edi
8010624e:	4f                   	dec    %edi
8010624f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106255:	b9 01 00 00 00       	mov    $0x1,%ecx
8010625a:	89 da                	mov    %ebx,%edx
8010625c:	8b 45 08             	mov    0x8(%ebp),%eax
8010625f:	e8 8f fc ff ff       	call   80105ef3 <walkpgdir>
80106264:	85 c0                	test   %eax,%eax
80106266:	74 2e                	je     80106296 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80106268:	f6 00 01             	testb  $0x1,(%eax)
8010626b:	75 1c                	jne    80106289 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010626d:	89 f2                	mov    %esi,%edx
8010626f:	0b 55 18             	or     0x18(%ebp),%edx
80106272:	83 ca 01             	or     $0x1,%edx
80106275:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106277:	39 fb                	cmp    %edi,%ebx
80106279:	74 28                	je     801062a3 <mappages+0x6f>
      break;
    a += PGSIZE;
8010627b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80106281:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106287:	eb cc                	jmp    80106255 <mappages+0x21>
      panic("remap");
80106289:	83 ec 0c             	sub    $0xc,%esp
8010628c:	68 b0 72 10 80       	push   $0x801072b0
80106291:	e8 ab a0 ff ff       	call   80100341 <panic>
      return -1;
80106296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010629b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010629e:	5b                   	pop    %ebx
8010629f:	5e                   	pop    %esi
801062a0:	5f                   	pop    %edi
801062a1:	5d                   	pop    %ebp
801062a2:	c3                   	ret    
  return 0;
801062a3:	b8 00 00 00 00       	mov    $0x0,%eax
801062a8:	eb f1                	jmp    8010629b <mappages+0x67>

801062aa <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801062aa:	a1 24 48 11 80       	mov    0x80114824,%eax
801062af:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801062b4:	0f 22 d8             	mov    %eax,%cr3
}
801062b7:	c3                   	ret    

801062b8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801062b8:	55                   	push   %ebp
801062b9:	89 e5                	mov    %esp,%ebp
801062bb:	57                   	push   %edi
801062bc:	56                   	push   %esi
801062bd:	53                   	push   %ebx
801062be:	83 ec 1c             	sub    $0x1c,%esp
801062c1:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801062c4:	85 f6                	test   %esi,%esi
801062c6:	0f 84 21 01 00 00    	je     801063ed <switchuvm+0x135>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801062cc:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
801062d0:	0f 84 24 01 00 00    	je     801063fa <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801062d6:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801062da:	0f 84 27 01 00 00    	je     80106407 <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
801062e0:	e8 05 d9 ff ff       	call   80103bea <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801062e5:	e8 84 cd ff ff       	call   8010306e <mycpu>
801062ea:	89 c3                	mov    %eax,%ebx
801062ec:	e8 7d cd ff ff       	call   8010306e <mycpu>
801062f1:	8d 78 08             	lea    0x8(%eax),%edi
801062f4:	e8 75 cd ff ff       	call   8010306e <mycpu>
801062f9:	83 c0 08             	add    $0x8,%eax
801062fc:	c1 e8 10             	shr    $0x10,%eax
801062ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106302:	e8 67 cd ff ff       	call   8010306e <mycpu>
80106307:	83 c0 08             	add    $0x8,%eax
8010630a:	c1 e8 18             	shr    $0x18,%eax
8010630d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106314:	67 00 
80106316:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010631d:	8a 4d e4             	mov    -0x1c(%ebp),%cl
80106320:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106326:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
8010632c:	83 e2 f0             	and    $0xfffffff0,%edx
8010632f:	88 d1                	mov    %dl,%cl
80106331:	83 c9 09             	or     $0x9,%ecx
80106334:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
8010633a:	83 ca 19             	or     $0x19,%edx
8010633d:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106343:	83 e2 9f             	and    $0xffffff9f,%edx
80106346:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010634c:	83 ca 80             	or     $0xffffff80,%edx
8010634f:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106355:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
8010635b:	88 d1                	mov    %dl,%cl
8010635d:	83 e1 f0             	and    $0xfffffff0,%ecx
80106360:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106366:	88 d1                	mov    %dl,%cl
80106368:	83 e1 e0             	and    $0xffffffe0,%ecx
8010636b:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106371:	83 e2 c0             	and    $0xffffffc0,%edx
80106374:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010637a:	83 ca 40             	or     $0x40,%edx
8010637d:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106383:	83 e2 7f             	and    $0x7f,%edx
80106386:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010638c:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106392:	e8 d7 cc ff ff       	call   8010306e <mycpu>
80106397:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010639d:	83 e2 ef             	and    $0xffffffef,%edx
801063a0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801063a6:	e8 c3 cc ff ff       	call   8010306e <mycpu>
801063ab:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801063b1:	8b 5e 08             	mov    0x8(%esi),%ebx
801063b4:	e8 b5 cc ff ff       	call   8010306e <mycpu>
801063b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801063bf:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801063c2:	e8 a7 cc ff ff       	call   8010306e <mycpu>
801063c7:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801063cd:	b8 28 00 00 00       	mov    $0x28,%eax
801063d2:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801063d5:	8b 46 04             	mov    0x4(%esi),%eax
801063d8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801063dd:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801063e0:	e8 40 d8 ff ff       	call   80103c25 <popcli>
}
801063e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e8:	5b                   	pop    %ebx
801063e9:	5e                   	pop    %esi
801063ea:	5f                   	pop    %edi
801063eb:	5d                   	pop    %ebp
801063ec:	c3                   	ret    
    panic("switchuvm: no process");
801063ed:	83 ec 0c             	sub    $0xc,%esp
801063f0:	68 b6 72 10 80       	push   $0x801072b6
801063f5:	e8 47 9f ff ff       	call   80100341 <panic>
    panic("switchuvm: no kstack");
801063fa:	83 ec 0c             	sub    $0xc,%esp
801063fd:	68 cc 72 10 80       	push   $0x801072cc
80106402:	e8 3a 9f ff ff       	call   80100341 <panic>
    panic("switchuvm: no pgdir");
80106407:	83 ec 0c             	sub    $0xc,%esp
8010640a:	68 e1 72 10 80       	push   $0x801072e1
8010640f:	e8 2d 9f ff ff       	call   80100341 <panic>

80106414 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
80106417:	56                   	push   %esi
80106418:	53                   	push   %ebx
80106419:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
8010641c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106422:	77 4b                	ja     8010646f <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
80106424:	e8 fe bb ff ff       	call   80102027 <kalloc>
80106429:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010642b:	83 ec 04             	sub    $0x4,%esp
8010642e:	68 00 10 00 00       	push   $0x1000
80106433:	6a 00                	push   $0x0
80106435:	50                   	push   %eax
80106436:	e8 35 d9 ff ff       	call   80103d70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010643b:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106442:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106448:	50                   	push   %eax
80106449:	68 00 10 00 00       	push   $0x1000
8010644e:	6a 00                	push   $0x0
80106450:	ff 75 08             	push   0x8(%ebp)
80106453:	e8 dc fd ff ff       	call   80106234 <mappages>
  memmove(mem, init, sz);
80106458:	83 c4 1c             	add    $0x1c,%esp
8010645b:	56                   	push   %esi
8010645c:	ff 75 0c             	push   0xc(%ebp)
8010645f:	53                   	push   %ebx
80106460:	e8 81 d9 ff ff       	call   80103de6 <memmove>
}
80106465:	83 c4 10             	add    $0x10,%esp
80106468:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010646b:	5b                   	pop    %ebx
8010646c:	5e                   	pop    %esi
8010646d:	5d                   	pop    %ebp
8010646e:	c3                   	ret    
    panic("inituvm: more than a page");
8010646f:	83 ec 0c             	sub    $0xc,%esp
80106472:	68 f5 72 10 80       	push   $0x801072f5
80106477:	e8 c5 9e ff ff       	call   80100341 <panic>

8010647c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010647c:	55                   	push   %ebp
8010647d:	89 e5                	mov    %esp,%ebp
8010647f:	57                   	push   %edi
80106480:	56                   	push   %esi
80106481:	53                   	push   %ebx
80106482:	83 ec 0c             	sub    $0xc,%esp
80106485:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106488:	89 fb                	mov    %edi,%ebx
8010648a:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106490:	74 3c                	je     801064ce <loaduvm+0x52>
    panic("loaduvm: addr must be page aligned");
80106492:	83 ec 0c             	sub    $0xc,%esp
80106495:	68 b0 73 10 80       	push   $0x801073b0
8010649a:	e8 a2 9e ff ff       	call   80100341 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010649f:	83 ec 0c             	sub    $0xc,%esp
801064a2:	68 0f 73 10 80       	push   $0x8010730f
801064a7:	e8 95 9e ff ff       	call   80100341 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801064ac:	05 00 00 00 80       	add    $0x80000000,%eax
801064b1:	56                   	push   %esi
801064b2:	89 da                	mov    %ebx,%edx
801064b4:	03 55 14             	add    0x14(%ebp),%edx
801064b7:	52                   	push   %edx
801064b8:	50                   	push   %eax
801064b9:	ff 75 10             	push   0x10(%ebp)
801064bc:	e8 32 b2 ff ff       	call   801016f3 <readi>
801064c1:	83 c4 10             	add    $0x10,%esp
801064c4:	39 f0                	cmp    %esi,%eax
801064c6:	75 47                	jne    8010650f <loaduvm+0x93>
  for(i = 0; i < sz; i += PGSIZE){
801064c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064ce:	3b 5d 18             	cmp    0x18(%ebp),%ebx
801064d1:	73 2f                	jae    80106502 <loaduvm+0x86>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801064d3:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
801064d6:	b9 00 00 00 00       	mov    $0x0,%ecx
801064db:	8b 45 08             	mov    0x8(%ebp),%eax
801064de:	e8 10 fa ff ff       	call   80105ef3 <walkpgdir>
801064e3:	85 c0                	test   %eax,%eax
801064e5:	74 b8                	je     8010649f <loaduvm+0x23>
    pa = PTE_ADDR(*pte);
801064e7:	8b 00                	mov    (%eax),%eax
801064e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801064ee:	8b 75 18             	mov    0x18(%ebp),%esi
801064f1:	29 de                	sub    %ebx,%esi
801064f3:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801064f9:	76 b1                	jbe    801064ac <loaduvm+0x30>
      n = PGSIZE;
801064fb:	be 00 10 00 00       	mov    $0x1000,%esi
80106500:	eb aa                	jmp    801064ac <loaduvm+0x30>
      return -1;
  }
  return 0;
80106502:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106507:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010650a:	5b                   	pop    %ebx
8010650b:	5e                   	pop    %esi
8010650c:	5f                   	pop    %edi
8010650d:	5d                   	pop    %ebp
8010650e:	c3                   	ret    
      return -1;
8010650f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106514:	eb f1                	jmp    80106507 <loaduvm+0x8b>

80106516 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106516:	55                   	push   %ebp
80106517:	89 e5                	mov    %esp,%ebp
80106519:	57                   	push   %edi
8010651a:	56                   	push   %esi
8010651b:	53                   	push   %ebx
8010651c:	83 ec 0c             	sub    $0xc,%esp
8010651f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106522:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106525:	73 11                	jae    80106538 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
80106527:	8b 45 10             	mov    0x10(%ebp),%eax
8010652a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106530:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106536:	eb 17                	jmp    8010654f <deallocuvm+0x39>
    return oldsz;
80106538:	89 f8                	mov    %edi,%eax
8010653a:	eb 62                	jmp    8010659e <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010653c:	c1 eb 16             	shr    $0x16,%ebx
8010653f:	43                   	inc    %ebx
80106540:	c1 e3 16             	shl    $0x16,%ebx
80106543:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106549:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010654f:	39 fb                	cmp    %edi,%ebx
80106551:	73 48                	jae    8010659b <deallocuvm+0x85>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106553:	b9 00 00 00 00       	mov    $0x0,%ecx
80106558:	89 da                	mov    %ebx,%edx
8010655a:	8b 45 08             	mov    0x8(%ebp),%eax
8010655d:	e8 91 f9 ff ff       	call   80105ef3 <walkpgdir>
80106562:	89 c6                	mov    %eax,%esi
    if(!pte)
80106564:	85 c0                	test   %eax,%eax
80106566:	74 d4                	je     8010653c <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
80106568:	8b 00                	mov    (%eax),%eax
8010656a:	a8 01                	test   $0x1,%al
8010656c:	74 db                	je     80106549 <deallocuvm+0x33>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010656e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106573:	74 19                	je     8010658e <deallocuvm+0x78>
        panic("kfree");
      char *v = P2V(pa);
80106575:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010657a:	83 ec 0c             	sub    $0xc,%esp
8010657d:	50                   	push   %eax
8010657e:	e8 8d b9 ff ff       	call   80101f10 <kfree>
      *pte = 0;
80106583:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106589:	83 c4 10             	add    $0x10,%esp
8010658c:	eb bb                	jmp    80106549 <deallocuvm+0x33>
        panic("kfree");
8010658e:	83 ec 0c             	sub    $0xc,%esp
80106591:	68 c6 6b 10 80       	push   $0x80106bc6
80106596:	e8 a6 9d ff ff       	call   80100341 <panic>
    }
  }
  return newsz;
8010659b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010659e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a1:	5b                   	pop    %ebx
801065a2:	5e                   	pop    %esi
801065a3:	5f                   	pop    %edi
801065a4:	5d                   	pop    %ebp
801065a5:	c3                   	ret    

801065a6 <allocuvm>:
{
801065a6:	55                   	push   %ebp
801065a7:	89 e5                	mov    %esp,%ebp
801065a9:	57                   	push   %edi
801065aa:	56                   	push   %esi
801065ab:	53                   	push   %ebx
801065ac:	83 ec 1c             	sub    $0x1c,%esp
801065af:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801065b2:	8b 45 10             	mov    0x10(%ebp),%eax
801065b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065b8:	85 c0                	test   %eax,%eax
801065ba:	0f 88 c1 00 00 00    	js     80106681 <allocuvm+0xdb>
  if(newsz < oldsz)
801065c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801065c3:	39 45 10             	cmp    %eax,0x10(%ebp)
801065c6:	72 5c                	jb     80106624 <allocuvm+0x7e>
  a = PGROUNDUP(oldsz);
801065c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801065cb:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801065d1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801065d7:	3b 75 10             	cmp    0x10(%ebp),%esi
801065da:	0f 83 a8 00 00 00    	jae    80106688 <allocuvm+0xe2>
    mem = kalloc();
801065e0:	e8 42 ba ff ff       	call   80102027 <kalloc>
801065e5:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801065e7:	85 c0                	test   %eax,%eax
801065e9:	74 3e                	je     80106629 <allocuvm+0x83>
    memset(mem, 0, PGSIZE);
801065eb:	83 ec 04             	sub    $0x4,%esp
801065ee:	68 00 10 00 00       	push   $0x1000
801065f3:	6a 00                	push   $0x0
801065f5:	50                   	push   %eax
801065f6:	e8 75 d7 ff ff       	call   80103d70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801065fb:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106602:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106608:	50                   	push   %eax
80106609:	68 00 10 00 00       	push   $0x1000
8010660e:	56                   	push   %esi
8010660f:	57                   	push   %edi
80106610:	e8 1f fc ff ff       	call   80106234 <mappages>
80106615:	83 c4 20             	add    $0x20,%esp
80106618:	85 c0                	test   %eax,%eax
8010661a:	78 35                	js     80106651 <allocuvm+0xab>
  for(; a < newsz; a += PGSIZE){
8010661c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106622:	eb b3                	jmp    801065d7 <allocuvm+0x31>
    return oldsz;
80106624:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106627:	eb 5f                	jmp    80106688 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
80106629:	83 ec 0c             	sub    $0xc,%esp
8010662c:	68 2d 73 10 80       	push   $0x8010732d
80106631:	e8 a4 9f ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106636:	83 c4 0c             	add    $0xc,%esp
80106639:	ff 75 0c             	push   0xc(%ebp)
8010663c:	ff 75 10             	push   0x10(%ebp)
8010663f:	57                   	push   %edi
80106640:	e8 d1 fe ff ff       	call   80106516 <deallocuvm>
      return 0;
80106645:	83 c4 10             	add    $0x10,%esp
80106648:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010664f:	eb 37                	jmp    80106688 <allocuvm+0xe2>
      cprintf("allocuvm out of memory (2)\n");
80106651:	83 ec 0c             	sub    $0xc,%esp
80106654:	68 45 73 10 80       	push   $0x80107345
80106659:	e8 7c 9f ff ff       	call   801005da <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010665e:	83 c4 0c             	add    $0xc,%esp
80106661:	ff 75 0c             	push   0xc(%ebp)
80106664:	ff 75 10             	push   0x10(%ebp)
80106667:	57                   	push   %edi
80106668:	e8 a9 fe ff ff       	call   80106516 <deallocuvm>
      kfree(mem);
8010666d:	89 1c 24             	mov    %ebx,(%esp)
80106670:	e8 9b b8 ff ff       	call   80101f10 <kfree>
      return 0;
80106675:	83 c4 10             	add    $0x10,%esp
80106678:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010667f:	eb 07                	jmp    80106688 <allocuvm+0xe2>
    return 0;
80106681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010668b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010668e:	5b                   	pop    %ebx
8010668f:	5e                   	pop    %esi
80106690:	5f                   	pop    %edi
80106691:	5d                   	pop    %ebp
80106692:	c3                   	ret    

80106693 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
80106693:	55                   	push   %ebp
80106694:	89 e5                	mov    %esp,%ebp
80106696:	56                   	push   %esi
80106697:	53                   	push   %ebx
80106698:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010669b:	85 f6                	test   %esi,%esi
8010669d:	74 0d                	je     801066ac <freevm+0x19>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
8010669f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801066a3:	75 14                	jne    801066b9 <freevm+0x26>
{
801066a5:	bb 00 00 00 00       	mov    $0x0,%ebx
801066aa:	eb 23                	jmp    801066cf <freevm+0x3c>
    panic("freevm: no pgdir");
801066ac:	83 ec 0c             	sub    $0xc,%esp
801066af:	68 61 73 10 80       	push   $0x80107361
801066b4:	e8 88 9c ff ff       	call   80100341 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
801066b9:	83 ec 04             	sub    $0x4,%esp
801066bc:	6a 00                	push   $0x0
801066be:	68 00 00 00 80       	push   $0x80000000
801066c3:	56                   	push   %esi
801066c4:	e8 4d fe ff ff       	call   80106516 <deallocuvm>
801066c9:	83 c4 10             	add    $0x10,%esp
801066cc:	eb d7                	jmp    801066a5 <freevm+0x12>
  for(i = 0; i < NPDENTRIES; i++){
801066ce:	43                   	inc    %ebx
801066cf:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801066d5:	77 1f                	ja     801066f6 <freevm+0x63>
    if(pgdir[i] & PTE_P){
801066d7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801066da:	a8 01                	test   $0x1,%al
801066dc:	74 f0                	je     801066ce <freevm+0x3b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801066de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066e3:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801066e8:	83 ec 0c             	sub    $0xc,%esp
801066eb:	50                   	push   %eax
801066ec:	e8 1f b8 ff ff       	call   80101f10 <kfree>
801066f1:	83 c4 10             	add    $0x10,%esp
801066f4:	eb d8                	jmp    801066ce <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
801066f6:	83 ec 0c             	sub    $0xc,%esp
801066f9:	56                   	push   %esi
801066fa:	e8 11 b8 ff ff       	call   80101f10 <kfree>
}
801066ff:	83 c4 10             	add    $0x10,%esp
80106702:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106705:	5b                   	pop    %ebx
80106706:	5e                   	pop    %esi
80106707:	5d                   	pop    %ebp
80106708:	c3                   	ret    

80106709 <setupkvm>:
{
80106709:	55                   	push   %ebp
8010670a:	89 e5                	mov    %esp,%ebp
8010670c:	56                   	push   %esi
8010670d:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
8010670e:	e8 14 b9 ff ff       	call   80102027 <kalloc>
80106713:	89 c6                	mov    %eax,%esi
80106715:	85 c0                	test   %eax,%eax
80106717:	74 57                	je     80106770 <setupkvm+0x67>
  memset(pgdir, 0, PGSIZE);
80106719:	83 ec 04             	sub    $0x4,%esp
8010671c:	68 00 10 00 00       	push   $0x1000
80106721:	6a 00                	push   $0x0
80106723:	50                   	push   %eax
80106724:	e8 47 d6 ff ff       	call   80103d70 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106729:	83 c4 10             	add    $0x10,%esp
8010672c:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106731:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106737:	73 37                	jae    80106770 <setupkvm+0x67>
                (uint)k->phys_start, k->perm) < 0) {
80106739:	8b 53 04             	mov    0x4(%ebx),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010673c:	83 ec 0c             	sub    $0xc,%esp
8010673f:	ff 73 0c             	push   0xc(%ebx)
80106742:	52                   	push   %edx
80106743:	8b 43 08             	mov    0x8(%ebx),%eax
80106746:	29 d0                	sub    %edx,%eax
80106748:	50                   	push   %eax
80106749:	ff 33                	push   (%ebx)
8010674b:	56                   	push   %esi
8010674c:	e8 e3 fa ff ff       	call   80106234 <mappages>
80106751:	83 c4 20             	add    $0x20,%esp
80106754:	85 c0                	test   %eax,%eax
80106756:	78 05                	js     8010675d <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106758:	83 c3 10             	add    $0x10,%ebx
8010675b:	eb d4                	jmp    80106731 <setupkvm+0x28>
      freevm(pgdir, 0);
8010675d:	83 ec 08             	sub    $0x8,%esp
80106760:	6a 00                	push   $0x0
80106762:	56                   	push   %esi
80106763:	e8 2b ff ff ff       	call   80106693 <freevm>
      return 0;
80106768:	83 c4 10             	add    $0x10,%esp
8010676b:	be 00 00 00 00       	mov    $0x0,%esi
}
80106770:	89 f0                	mov    %esi,%eax
80106772:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106775:	5b                   	pop    %ebx
80106776:	5e                   	pop    %esi
80106777:	5d                   	pop    %ebp
80106778:	c3                   	ret    

80106779 <kvmalloc>:
{
80106779:	55                   	push   %ebp
8010677a:	89 e5                	mov    %esp,%ebp
8010677c:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010677f:	e8 85 ff ff ff       	call   80106709 <setupkvm>
80106784:	a3 24 48 11 80       	mov    %eax,0x80114824
  switchkvm();
80106789:	e8 1c fb ff ff       	call   801062aa <switchkvm>
}
8010678e:	c9                   	leave  
8010678f:	c3                   	ret    

80106790 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106796:	b9 00 00 00 00       	mov    $0x0,%ecx
8010679b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010679e:	8b 45 08             	mov    0x8(%ebp),%eax
801067a1:	e8 4d f7 ff ff       	call   80105ef3 <walkpgdir>
  if(pte == 0)
801067a6:	85 c0                	test   %eax,%eax
801067a8:	74 05                	je     801067af <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801067aa:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801067ad:	c9                   	leave  
801067ae:	c3                   	ret    
    panic("clearpteu");
801067af:	83 ec 0c             	sub    $0xc,%esp
801067b2:	68 72 73 10 80       	push   $0x80107372
801067b7:	e8 85 9b ff ff       	call   80100341 <panic>

801067bc <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801067bc:	55                   	push   %ebp
801067bd:	89 e5                	mov    %esp,%ebp
801067bf:	57                   	push   %edi
801067c0:	56                   	push   %esi
801067c1:	53                   	push   %ebx
801067c2:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801067c5:	e8 3f ff ff ff       	call   80106709 <setupkvm>
801067ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067cd:	85 c0                	test   %eax,%eax
801067cf:	0f 84 c6 00 00 00    	je     8010689b <copyuvm+0xdf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801067d5:	bb 00 00 00 00       	mov    $0x0,%ebx
801067da:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
801067dd:	0f 83 b8 00 00 00    	jae    8010689b <copyuvm+0xdf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801067e3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801067e6:	b9 00 00 00 00       	mov    $0x0,%ecx
801067eb:	89 da                	mov    %ebx,%edx
801067ed:	8b 45 08             	mov    0x8(%ebp),%eax
801067f0:	e8 fe f6 ff ff       	call   80105ef3 <walkpgdir>
801067f5:	85 c0                	test   %eax,%eax
801067f7:	74 65                	je     8010685e <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801067f9:	8b 00                	mov    (%eax),%eax
801067fb:	a8 01                	test   $0x1,%al
801067fd:	74 6c                	je     8010686b <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801067ff:	89 c6                	mov    %eax,%esi
80106801:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106807:	25 ff 0f 00 00       	and    $0xfff,%eax
8010680c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
8010680f:	e8 13 b8 ff ff       	call   80102027 <kalloc>
80106814:	89 c7                	mov    %eax,%edi
80106816:	85 c0                	test   %eax,%eax
80106818:	74 6a                	je     80106884 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010681a:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106820:	83 ec 04             	sub    $0x4,%esp
80106823:	68 00 10 00 00       	push   $0x1000
80106828:	56                   	push   %esi
80106829:	50                   	push   %eax
8010682a:	e8 b7 d5 ff ff       	call   80103de6 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010682f:	83 c4 04             	add    $0x4,%esp
80106832:	ff 75 e0             	push   -0x20(%ebp)
80106835:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010683b:	50                   	push   %eax
8010683c:	68 00 10 00 00       	push   $0x1000
80106841:	ff 75 e4             	push   -0x1c(%ebp)
80106844:	ff 75 dc             	push   -0x24(%ebp)
80106847:	e8 e8 f9 ff ff       	call   80106234 <mappages>
8010684c:	83 c4 20             	add    $0x20,%esp
8010684f:	85 c0                	test   %eax,%eax
80106851:	78 25                	js     80106878 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
80106853:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106859:	e9 7c ff ff ff       	jmp    801067da <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
8010685e:	83 ec 0c             	sub    $0xc,%esp
80106861:	68 7c 73 10 80       	push   $0x8010737c
80106866:	e8 d6 9a ff ff       	call   80100341 <panic>
      panic("copyuvm: page not present");
8010686b:	83 ec 0c             	sub    $0xc,%esp
8010686e:	68 96 73 10 80       	push   $0x80107396
80106873:	e8 c9 9a ff ff       	call   80100341 <panic>
      kfree(mem);
80106878:	83 ec 0c             	sub    $0xc,%esp
8010687b:	57                   	push   %edi
8010687c:	e8 8f b6 ff ff       	call   80101f10 <kfree>
      goto bad;
80106881:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
80106884:	83 ec 08             	sub    $0x8,%esp
80106887:	6a 01                	push   $0x1
80106889:	ff 75 dc             	push   -0x24(%ebp)
8010688c:	e8 02 fe ff ff       	call   80106693 <freevm>
  return 0;
80106891:	83 c4 10             	add    $0x10,%esp
80106894:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
8010689b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010689e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068a1:	5b                   	pop    %ebx
801068a2:	5e                   	pop    %esi
801068a3:	5f                   	pop    %edi
801068a4:	5d                   	pop    %ebp
801068a5:	c3                   	ret    

801068a6 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801068a6:	55                   	push   %ebp
801068a7:	89 e5                	mov    %esp,%ebp
801068a9:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801068ac:	b9 00 00 00 00       	mov    $0x0,%ecx
801068b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801068b4:	8b 45 08             	mov    0x8(%ebp),%eax
801068b7:	e8 37 f6 ff ff       	call   80105ef3 <walkpgdir>
  if((*pte & PTE_P) == 0)
801068bc:	8b 00                	mov    (%eax),%eax
801068be:	a8 01                	test   $0x1,%al
801068c0:	74 10                	je     801068d2 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
801068c2:	a8 04                	test   $0x4,%al
801068c4:	74 13                	je     801068d9 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801068c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068cb:	05 00 00 00 80       	add    $0x80000000,%eax
}
801068d0:	c9                   	leave  
801068d1:	c3                   	ret    
    return 0;
801068d2:	b8 00 00 00 00       	mov    $0x0,%eax
801068d7:	eb f7                	jmp    801068d0 <uva2ka+0x2a>
    return 0;
801068d9:	b8 00 00 00 00       	mov    $0x0,%eax
801068de:	eb f0                	jmp    801068d0 <uva2ka+0x2a>

801068e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
801068e6:	83 ec 0c             	sub    $0xc,%esp
801068e9:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801068ec:	eb 25                	jmp    80106913 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801068ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801068f1:	29 f2                	sub    %esi,%edx
801068f3:	01 d0                	add    %edx,%eax
801068f5:	83 ec 04             	sub    $0x4,%esp
801068f8:	53                   	push   %ebx
801068f9:	ff 75 10             	push   0x10(%ebp)
801068fc:	50                   	push   %eax
801068fd:	e8 e4 d4 ff ff       	call   80103de6 <memmove>
    len -= n;
80106902:	29 df                	sub    %ebx,%edi
    buf += n;
80106904:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106907:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
8010690d:	89 45 0c             	mov    %eax,0xc(%ebp)
80106910:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106913:	85 ff                	test   %edi,%edi
80106915:	74 2f                	je     80106946 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106917:	8b 75 0c             	mov    0xc(%ebp),%esi
8010691a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106920:	83 ec 08             	sub    $0x8,%esp
80106923:	56                   	push   %esi
80106924:	ff 75 08             	push   0x8(%ebp)
80106927:	e8 7a ff ff ff       	call   801068a6 <uva2ka>
    if(pa0 == 0)
8010692c:	83 c4 10             	add    $0x10,%esp
8010692f:	85 c0                	test   %eax,%eax
80106931:	74 20                	je     80106953 <copyout+0x73>
    n = PGSIZE - (va - va0);
80106933:	89 f3                	mov    %esi,%ebx
80106935:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106938:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010693e:	39 df                	cmp    %ebx,%edi
80106940:	73 ac                	jae    801068ee <copyout+0xe>
      n = len;
80106942:	89 fb                	mov    %edi,%ebx
80106944:	eb a8                	jmp    801068ee <copyout+0xe>
  }
  return 0;
80106946:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010694b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010694e:	5b                   	pop    %ebx
8010694f:	5e                   	pop    %esi
80106950:	5f                   	pop    %edi
80106951:	5d                   	pop    %ebp
80106952:	c3                   	ret    
      return -1;
80106953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106958:	eb f1                	jmp    8010694b <copyout+0x6b>
