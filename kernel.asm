
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 6e 11 80       	mov    $0x80116ed0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 75 10 80       	push   $0x80107560
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 c5 46 00 00       	call   80104720 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 75 10 80       	push   $0x80107567
80100097:	50                   	push   %eax
80100098:	e8 53 45 00 00       	call   801045f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 07 48 00 00       	call   801048f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 29 47 00 00       	call   80104890 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 44 00 00       	call   80104630 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 1f 21 00 00       	call   801022b0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 75 10 80       	push   $0x8010756e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 0d 45 00 00       	call   801046d0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 d7 20 00 00       	jmp    801022b0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 75 10 80       	push   $0x8010757f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 44 00 00       	call   801046d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 44 00 00       	call   80104690 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 d0 46 00 00       	call   801048f0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 46 00 00       	jmp    80104890 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 75 10 80       	push   $0x80107586
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 97 15 00 00       	call   80101830 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 4b 46 00 00       	call   801048f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ce 3e 00 00       	call   801041a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 95 45 00 00       	call   80104890 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 4c 14 00 00       	call   80101750 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 3f 45 00 00       	call   80104890 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 f6 13 00 00       	call   80101750 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 22 25 00 00       	call   801028c0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 75 10 80       	push   $0x8010758d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 a3 7f 10 80 	movl   $0x80107fa3,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 43 00 00       	call   80104740 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 75 10 80       	push   $0x801075a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 61 5c 00 00       	call   80106080 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 76 5b 00 00       	call   80106080 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 5b 00 00       	call   80106080 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 5b 00 00       	call   80106080 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 fa 44 00 00       	call   80104a50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 45 44 00 00       	call   801049b0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 75 10 80       	push   $0x801075a5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 8c 12 00 00       	call   80101830 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 40 43 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 a7 42 00 00       	call   80104890 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 5e 11 00 00       	call   80101750 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 24 76 10 80 	movzbl -0x7fef89dc(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 0f 01 00 00    	jne    801007c8 <cprintf+0x128>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 7f 01 00 00    	je     80100843 <cprintf+0x1a3>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 4a                	je     8010071a <cprintf+0x7a>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	75 2b                	jne    80100700 <cprintf+0x60>
    c = fmt[++i] & 0xff;
801006d5:	83 c3 01             	add    $0x1,%ebx
801006d8:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006dc:	85 d2                	test   %edx,%edx
801006de:	74 3a                	je     8010071a <cprintf+0x7a>
    switch(c){
801006e0:	83 fa 25             	cmp    $0x25,%edx
801006e3:	0f 84 f4 00 00 00    	je     801007dd <cprintf+0x13d>
801006e9:	8d 42 9c             	lea    -0x64(%edx),%eax
801006ec:	83 f8 14             	cmp    $0x14,%eax
801006ef:	77 3f                	ja     80100730 <cprintf+0x90>
801006f1:	ff 24 85 d0 75 10 80 	jmp    *-0x7fef8a30(,%eax,4)
801006f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006ff:	90                   	nop
  if(panicked){
80100700:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100706:	85 c9                	test   %ecx,%ecx
80100708:	75 56                	jne    80100760 <cprintf+0xc0>
8010070a:	e8 f1 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070f:	83 c3 01             	add    $0x1,%ebx
80100712:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100716:	85 c0                	test   %eax,%eax
80100718:	75 b6                	jne    801006d0 <cprintf+0x30>
  if(locking)
8010071a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010071d:	85 c0                	test   %eax,%eax
8010071f:	0f 85 01 01 00 00    	jne    80100826 <cprintf+0x186>
}
80100725:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100728:	5b                   	pop    %ebx
80100729:	5e                   	pop    %esi
8010072a:	5f                   	pop    %edi
8010072b:	5d                   	pop    %ebp
8010072c:	c3                   	ret    
8010072d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100730:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100736:	85 c9                	test   %ecx,%ecx
80100738:	0f 85 c8 00 00 00    	jne    80100806 <cprintf+0x166>
8010073e:	b8 25 00 00 00       	mov    $0x25,%eax
80100743:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100746:	e8 b5 fc ff ff       	call   80100400 <consputc.part.0>
8010074b:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100751:	85 d2                	test   %edx,%edx
80100753:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100756:	0f 84 be 00 00 00    	je     8010081a <cprintf+0x17a>
8010075c:	fa                   	cli    
    for(;;)
8010075d:	eb fe                	jmp    8010075d <cprintf+0xbd>
8010075f:	90                   	nop
80100760:	fa                   	cli    
80100761:	eb fe                	jmp    80100761 <cprintf+0xc1>
80100763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100767:	90                   	nop
      printint(*argp++, 16, 0);
80100768:	8d 47 04             	lea    0x4(%edi),%eax
8010076b:	31 c9                	xor    %ecx,%ecx
8010076d:	ba 10 00 00 00       	mov    $0x10,%edx
80100772:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100775:	8b 07                	mov    (%edi),%eax
80100777:	e8 84 fe ff ff       	call   80100600 <printint>
8010077c:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
8010077f:	eb 8e                	jmp    8010070f <cprintf+0x6f>
      printint(*argp++, 10, 1);
80100781:	8d 47 04             	lea    0x4(%edi),%eax
80100784:	b9 01 00 00 00       	mov    $0x1,%ecx
80100789:	ba 0a 00 00 00       	mov    $0xa,%edx
8010078e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100791:	8b 07                	mov    (%edi),%eax
80100793:	e8 68 fe ff ff       	call   80100600 <printint>
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
8010079b:	e9 6f ff ff ff       	jmp    8010070f <cprintf+0x6f>
      if((s = (char*)*argp++) == 0)
801007a0:	8d 47 04             	lea    0x4(%edi),%eax
801007a3:	8b 3f                	mov    (%edi),%edi
801007a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a8:	85 ff                	test   %edi,%edi
801007aa:	74 4e                	je     801007fa <cprintf+0x15a>
      for(; *s; s++)
801007ac:	0f be 07             	movsbl (%edi),%eax
801007af:	84 c0                	test   %al,%al
801007b1:	0f 84 84 00 00 00    	je     8010083b <cprintf+0x19b>
  if(panicked){
801007b7:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801007bd:	85 d2                	test   %edx,%edx
801007bf:	74 2f                	je     801007f0 <cprintf+0x150>
801007c1:	fa                   	cli    
    for(;;)
801007c2:	eb fe                	jmp    801007c2 <cprintf+0x122>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007c8:	83 ec 0c             	sub    $0xc,%esp
801007cb:	68 20 ff 10 80       	push   $0x8010ff20
801007d0:	e8 1b 41 00 00       	call   801048f0 <acquire>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	e9 dc fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007dd:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007e2:	85 c0                	test   %eax,%eax
801007e4:	74 2a                	je     80100810 <cprintf+0x170>
801007e6:	fa                   	cli    
    for(;;)
801007e7:	eb fe                	jmp    801007e7 <cprintf+0x147>
801007e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007f0:	e8 0b fc ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
801007f5:	83 c7 01             	add    $0x1,%edi
801007f8:	eb b2                	jmp    801007ac <cprintf+0x10c>
        s = "(null)";
801007fa:	bf b8 75 10 80       	mov    $0x801075b8,%edi
      for(; *s; s++)
801007ff:	b8 28 00 00 00       	mov    $0x28,%eax
80100804:	eb b1                	jmp    801007b7 <cprintf+0x117>
80100806:	fa                   	cli    
    for(;;)
80100807:	eb fe                	jmp    80100807 <cprintf+0x167>
80100809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100810:	b8 25 00 00 00       	mov    $0x25,%eax
80100815:	e9 f0 fe ff ff       	jmp    8010070a <cprintf+0x6a>
8010081a:	89 d0                	mov    %edx,%eax
8010081c:	e8 df fb ff ff       	call   80100400 <consputc.part.0>
80100821:	e9 e9 fe ff ff       	jmp    8010070f <cprintf+0x6f>
    release(&cons.lock);
80100826:	83 ec 0c             	sub    $0xc,%esp
80100829:	68 20 ff 10 80       	push   $0x8010ff20
8010082e:	e8 5d 40 00 00       	call   80104890 <release>
80100833:	83 c4 10             	add    $0x10,%esp
}
80100836:	e9 ea fe ff ff       	jmp    80100725 <cprintf+0x85>
      if((s = (char*)*argp++) == 0)
8010083b:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010083e:	e9 cc fe ff ff       	jmp    8010070f <cprintf+0x6f>
    panic("null fmt");
80100843:	83 ec 0c             	sub    $0xc,%esp
80100846:	68 bf 75 10 80       	push   $0x801075bf
8010084b:	e8 30 fb ff ff       	call   80100380 <panic>

80100850 <consoleintr>:
{
80100850:	55                   	push   %ebp
80100851:	89 e5                	mov    %esp,%ebp
80100853:	57                   	push   %edi
80100854:	56                   	push   %esi
  int c, doprocdump = 0;
80100855:	31 f6                	xor    %esi,%esi
{
80100857:	53                   	push   %ebx
80100858:	83 ec 18             	sub    $0x18,%esp
8010085b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010085e:	68 20 ff 10 80       	push   $0x8010ff20
80100863:	e8 88 40 00 00       	call   801048f0 <acquire>
  while((c = getc()) >= 0){
80100868:	83 c4 10             	add    $0x10,%esp
8010086b:	eb 1a                	jmp    80100887 <consoleintr+0x37>
8010086d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100870:	83 fb 08             	cmp    $0x8,%ebx
80100873:	0f 84 d7 00 00 00    	je     80100950 <consoleintr+0x100>
80100879:	83 fb 10             	cmp    $0x10,%ebx
8010087c:	0f 85 32 01 00 00    	jne    801009b4 <consoleintr+0x164>
80100882:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100887:	ff d7                	call   *%edi
80100889:	89 c3                	mov    %eax,%ebx
8010088b:	85 c0                	test   %eax,%eax
8010088d:	0f 88 05 01 00 00    	js     80100998 <consoleintr+0x148>
    switch(c){
80100893:	83 fb 15             	cmp    $0x15,%ebx
80100896:	74 78                	je     80100910 <consoleintr+0xc0>
80100898:	7e d6                	jle    80100870 <consoleintr+0x20>
8010089a:	83 fb 7f             	cmp    $0x7f,%ebx
8010089d:	0f 84 ad 00 00 00    	je     80100950 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008a8:	89 c2                	mov    %eax,%edx
801008aa:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008b0:	83 fa 7f             	cmp    $0x7f,%edx
801008b3:	77 d2                	ja     80100887 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008b8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008be:	83 e0 7f             	and    $0x7f,%eax
801008c1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008c7:	83 fb 0d             	cmp    $0xd,%ebx
801008ca:	0f 84 13 01 00 00    	je     801009e3 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d0:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
801008d6:	85 d2                	test   %edx,%edx
801008d8:	0f 85 10 01 00 00    	jne    801009ee <consoleintr+0x19e>
801008de:	89 d8                	mov    %ebx,%eax
801008e0:	e8 1b fb ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e5:	83 fb 0a             	cmp    $0xa,%ebx
801008e8:	0f 84 14 01 00 00    	je     80100a02 <consoleintr+0x1b2>
801008ee:	83 fb 04             	cmp    $0x4,%ebx
801008f1:	0f 84 0b 01 00 00    	je     80100a02 <consoleintr+0x1b2>
801008f7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801008fc:	83 e8 80             	sub    $0xffffff80,%eax
801008ff:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100905:	75 80                	jne    80100887 <consoleintr+0x37>
80100907:	e9 fb 00 00 00       	jmp    80100a07 <consoleintr+0x1b7>
8010090c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100910:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100915:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010091b:	0f 84 66 ff ff ff    	je     80100887 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100921:	83 e8 01             	sub    $0x1,%eax
80100924:	89 c2                	mov    %eax,%edx
80100926:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100929:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100930:	0f 84 51 ff ff ff    	je     80100887 <consoleintr+0x37>
  if(panicked){
80100936:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010093c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100941:	85 d2                	test   %edx,%edx
80100943:	74 33                	je     80100978 <consoleintr+0x128>
80100945:	fa                   	cli    
    for(;;)
80100946:	eb fe                	jmp    80100946 <consoleintr+0xf6>
80100948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010094f:	90                   	nop
      if(input.e != input.w){
80100950:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100955:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010095b:	0f 84 26 ff ff ff    	je     80100887 <consoleintr+0x37>
        input.e--;
80100961:	83 e8 01             	sub    $0x1,%eax
80100964:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100969:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010096e:	85 c0                	test   %eax,%eax
80100970:	74 56                	je     801009c8 <consoleintr+0x178>
80100972:	fa                   	cli    
    for(;;)
80100973:	eb fe                	jmp    80100973 <consoleintr+0x123>
80100975:	8d 76 00             	lea    0x0(%esi),%esi
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100987:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098d:	75 92                	jne    80100921 <consoleintr+0xd1>
8010098f:	e9 f3 fe ff ff       	jmp    80100887 <consoleintr+0x37>
80100994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100998:	83 ec 0c             	sub    $0xc,%esp
8010099b:	68 20 ff 10 80       	push   $0x8010ff20
801009a0:	e8 eb 3e 00 00       	call   80104890 <release>
  if(doprocdump) {
801009a5:	83 c4 10             	add    $0x10,%esp
801009a8:	85 f6                	test   %esi,%esi
801009aa:	75 2b                	jne    801009d7 <consoleintr+0x187>
}
801009ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009af:	5b                   	pop    %ebx
801009b0:	5e                   	pop    %esi
801009b1:	5f                   	pop    %edi
801009b2:	5d                   	pop    %ebp
801009b3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009b4:	85 db                	test   %ebx,%ebx
801009b6:	0f 84 cb fe ff ff    	je     80100887 <consoleintr+0x37>
801009bc:	e9 e2 fe ff ff       	jmp    801008a3 <consoleintr+0x53>
801009c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009c8:	b8 00 01 00 00       	mov    $0x100,%eax
801009cd:	e8 2e fa ff ff       	call   80100400 <consputc.part.0>
801009d2:	e9 b0 fe ff ff       	jmp    80100887 <consoleintr+0x37>
}
801009d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009da:	5b                   	pop    %ebx
801009db:	5e                   	pop    %esi
801009dc:	5f                   	pop    %edi
801009dd:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009de:	e9 5d 39 00 00       	jmp    80104340 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 0a                	je     801009f8 <consoleintr+0x1a8>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x19f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 0a 00 00 00       	mov    $0xa,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a02:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a07:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a0a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a0f:	68 00 ff 10 80       	push   $0x8010ff00
80100a14:	e8 47 38 00 00       	call   80104260 <wakeup>
80100a19:	83 c4 10             	add    $0x10,%esp
80100a1c:	e9 66 fe ff ff       	jmp    80100887 <consoleintr+0x37>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2f:	90                   	nop

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 c8 75 10 80       	push   $0x801075c8
80100a3b:	68 20 ff 10 80       	push   $0x8010ff20
80100a40:	e8 db 3c 00 00       	call   80104720 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a52:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 e2 19 00 00       	call   80102450 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 ef 2e 00 00       	call   80103980 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 94 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	push   0x8(%ebp)
80100aa2:	e8 c9 15 00 00       	call   80102070 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 02 03 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 93 0c 00 00       	call   80101750 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 92 0f 00 00       	call   80101a60 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 01 0f 00 00       	call   801019e0 <iunlockput>
    end_op();
80100adf:	e8 bc 22 00 00       	call   80102da0 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 07 67 00 00       	call   80107210 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 ac 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b73:	e8 b8 64 00 00       	call   80107030 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba9:	e8 92 63 00 00       	call   80106f40 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100beb:	e8 a0 65 00 00       	call   80107190 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
  sz = PGROUNDUP(sz);
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 bf 0d 00 00       	call   801019e0 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 f9 63 00 00       	call   80107030 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 58 66 00 00       	call   801072b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 08 3f 00 00       	call   80104bb0 <strlen>
80100ca8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100caa:	58                   	pop    %eax
80100cab:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cae:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb7:	e8 f4 3e 00 00       	call   80104bb0 <strlen>
80100cbc:	83 c0 01             	add    $0x1,%eax
80100cbf:	50                   	push   %eax
80100cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc3:	ff 34 b8             	push   (%eax,%edi,4)
80100cc6:	53                   	push   %ebx
80100cc7:	56                   	push   %esi
80100cc8:	e8 b3 67 00 00       	call   80107480 <copyout>
80100ccd:	83 c4 20             	add    $0x20,%esp
80100cd0:	85 c0                	test   %eax,%eax
80100cd2:	79 ac                	jns    80100c80 <exec+0x200>
80100cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ce1:	e8 aa 64 00 00       	call   80107190 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 48 67 00 00       	call   80107480 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 fa 3d 00 00       	call   80104b70 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 0e 60 00 00       	call   80106db0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 e6 63 00 00       	call   80107190 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 35 76 10 80       	push   $0x80107635
80100dc1:	e8 da f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 19 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	be 00 20 00 00       	mov    $0x2000,%esi
80100dd8:	31 ff                	xor    %edi,%edi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 41 76 10 80       	push   $0x80107641
80100deb:	68 60 ff 10 80       	push   $0x8010ff60
80100df0:	e8 2b 39 00 00       	call   80104720 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 60 ff 10 80       	push   $0x8010ff60
80100e11:	e8 da 3a 00 00       	call   801048f0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 4a 3a 00 00       	call   80104890 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 60 ff 10 80       	push   $0x8010ff60
80100e5a:	e8 31 3a 00 00       	call   80104890 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 60 ff 10 80       	push   $0x8010ff60
80100e7f:	e8 6c 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 60 ff 10 80       	push   $0x8010ff60
80100e9c:	e8 ef 39 00 00       	call   80104890 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 48 76 10 80       	push   $0x80107648
80100eb0:	e8 cb f4 ff ff       	call   80100380 <panic>
80100eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 60 ff 10 80       	push   $0x8010ff60
80100ed1:	e8 1a 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 53 04             	mov    0x4(%ebx),%edx
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 d2                	test   %edx,%edx
80100ede:	0f 8e a5 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 ea 01             	sub    $0x1,%edx
80100ee7:	89 53 04             	mov    %edx,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 7f 39 00 00       	call   80104890 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 57                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 2a                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 4d 39 00 00       	jmp    80104890 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	push   -0x20(%ebp)
80100f53:	e8 28 09 00 00       	call   80101880 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 50 76 10 80       	push   $0x80107650
80100f91:	e8 ea f3 ff ff       	call   80100380 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	push   0x10(%ebx)
80100fb5:	e8 96 07 00 00       	call   80101750 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	push   0xc(%ebp)
80100fbf:	ff 73 10             	push   0x10(%ebx)
80100fc2:	e8 69 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	push   0x10(%ebx)
80100fcb:	e8 60 08 00 00       	call   80101830 <iunlock>
    return 0;
  }
  return -1;
}
80100fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd3:	83 c4 10             	add    $0x10,%esp
80100fd6:	31 c0                	xor    %eax,%eax
}
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	push   0x10(%ebx)
8010101a:	e8 31 07 00 00       	call   80101750 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	push   0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	push   0x10(%ebx)
80101027:	e8 34 0a 00 00       	call   80101a60 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	push   0x10(%ebx)
8010103e:	e8 ed 07 00 00       	call   80101830 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 3e 26 00 00       	jmp    801036a0 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 5a 76 10 80       	push   $0x8010765a
80101077:	e8 04 f3 ff ff       	call   80100380 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bd 00 00 00    	je     8010115f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 03                	mov    (%ebx),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 57 07 00 00       	call   80101830 <iunlock>
      end_op();
801010d9:	e8 c2 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 c7                	cmp    %eax,%edi
801010e6:	75 5c                	jne    80101144 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801010e8:	01 fe                	add    %edi,%esi
    while(i < n){
801010ea:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 f7                	sub    %esi,%edi
801010f9:	39 c7                	cmp    %eax,%edi
801010fb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801010fe:	e8 2d 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
80101103:	83 ec 0c             	sub    $0xc,%esp
80101106:	ff 73 10             	push   0x10(%ebx)
80101109:	e8 42 06 00 00       	call   80101750 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010110e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101111:	57                   	push   %edi
80101112:	ff 73 14             	push   0x14(%ebx)
80101115:	01 f0                	add    %esi,%eax
80101117:	50                   	push   %eax
80101118:	ff 73 10             	push   0x10(%ebx)
8010111b:	e8 40 0a 00 00       	call   80101b60 <writei>
80101120:	83 c4 20             	add    $0x20,%esp
80101123:	85 c0                	test   %eax,%eax
80101125:	7f a1                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
80101127:	83 ec 0c             	sub    $0xc,%esp
8010112a:	ff 73 10             	push   0x10(%ebx)
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101130:	e8 fb 06 00 00       	call   80101830 <iunlock>
      end_op();
80101135:	e8 66 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
8010113a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010113d:	83 c4 10             	add    $0x10,%esp
80101140:	85 c0                	test   %eax,%eax
80101142:	75 1b                	jne    8010115f <filewrite+0xdf>
        panic("short filewrite");
80101144:	83 ec 0c             	sub    $0xc,%esp
80101147:	68 63 76 10 80       	push   $0x80107663
8010114c:	e8 2f f2 ff ff       	call   80100380 <panic>
80101151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101158:	89 f0                	mov    %esi,%eax
8010115a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010115d:	74 05                	je     80101164 <filewrite+0xe4>
8010115f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 22 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 69 76 10 80       	push   $0x80107669
80101186:	e8 f5 f1 ff ff       	call   80100380 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101190:	55                   	push   %ebp
80101191:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101193:	89 d0                	mov    %edx,%eax
80101195:	c1 e8 0c             	shr    $0xc,%eax
80101198:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
8010119e:	89 e5                	mov    %esp,%ebp
801011a0:	56                   	push   %esi
801011a1:	53                   	push   %ebx
801011a2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	50                   	push   %eax
801011a8:	51                   	push   %ecx
801011a9:	e8 22 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ae:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011b0:	c1 fb 03             	sar    $0x3,%ebx
801011b3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011b6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011b8:	83 e1 07             	and    $0x7,%ecx
801011bb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011c0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011c6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011c8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011cd:	85 c1                	test   %eax,%ecx
801011cf:	74 23                	je     801011f4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011d1:	f7 d0                	not    %eax
  log_write(bp);
801011d3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801011d6:	21 c8                	and    %ecx,%eax
801011d8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801011dc:	56                   	push   %esi
801011dd:	e8 2e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
801011e2:	89 34 24             	mov    %esi,(%esp)
801011e5:	e8 06 f0 ff ff       	call   801001f0 <brelse>
}
801011ea:	83 c4 10             	add    $0x10,%esp
801011ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011f0:	5b                   	pop    %ebx
801011f1:	5e                   	pop    %esi
801011f2:	5d                   	pop    %ebp
801011f3:	c3                   	ret    
    panic("freeing free block");
801011f4:	83 ec 0c             	sub    $0xc,%esp
801011f7:	68 73 76 10 80       	push   $0x80107673
801011fc:	e8 7f f1 ff ff       	call   80100380 <panic>
80101201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010120f:	90                   	nop

80101210 <balloc>:
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010121f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 87 00 00 00    	je     801012b1 <balloc+0xa1>
8010122a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101231:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101234:	83 ec 08             	sub    $0x8,%esp
80101237:	89 f0                	mov    %esi,%eax
80101239:	c1 f8 0c             	sar    $0xc,%eax
8010123c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101242:	50                   	push   %eax
80101243:	ff 75 d8             	push   -0x28(%ebp)
80101246:	e8 85 ee ff ff       	call   801000d0 <bread>
8010124b:	83 c4 10             	add    $0x10,%esp
8010124e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101251:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101256:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101259:	31 c0                	xor    %eax,%eax
8010125b:	eb 2f                	jmp    8010128c <balloc+0x7c>
8010125d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 41                	je     801012c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 05                	je     80101291 <balloc+0x81>
8010128c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010128f:	77 cf                	ja     80101260 <balloc+0x50>
    brelse(bp);
80101291:	83 ec 0c             	sub    $0xc,%esp
80101294:	ff 75 e4             	push   -0x1c(%ebp)
80101297:	e8 54 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012a3:	83 c4 10             	add    $0x10,%esp
801012a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012a9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012af:	77 80                	ja     80101231 <balloc+0x21>
  panic("balloc: out of blocks");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 86 76 10 80       	push   $0x80107686
801012b9:	e8 c2 f0 ff ff       	call   80100380 <panic>
801012be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012c6:	09 da                	or     %ebx,%edx
801012c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012cc:	57                   	push   %edi
801012cd:	e8 3e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012d2:	89 3c 24             	mov    %edi,(%esp)
801012d5:	e8 16 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012da:	58                   	pop    %eax
801012db:	5a                   	pop    %edx
801012dc:	56                   	push   %esi
801012dd:	ff 75 d8             	push   -0x28(%ebp)
801012e0:	e8 eb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012e8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801012ed:	68 00 02 00 00       	push   $0x200
801012f2:	6a 00                	push   $0x0
801012f4:	50                   	push   %eax
801012f5:	e8 b6 36 00 00       	call   801049b0 <memset>
  log_write(bp);
801012fa:	89 1c 24             	mov    %ebx,(%esp)
801012fd:	e8 0e 1c 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 f0                	mov    %esi,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010131b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010131f:	90                   	nop

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	89 c7                	mov    %eax,%edi
80101326:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101327:	31 f6                	xor    %esi,%esi
{
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 09 11 80       	push   $0x80110960
8010133a:	e8 b1 35 00 00       	call   801048f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 3b                	cmp    %edi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101360:	73 26                	jae    80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 f6                	test   %esi,%esi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010137f:	72 e1                	jb     80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 f6                	test   %esi,%esi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101391:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101394:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010139b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013a2:	68 60 09 11 80       	push   $0x80110960
801013a7:	e8 e4 34 00 00       	call   80104890 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f0                	mov    %esi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret    
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      release(&icache.lock);
801013c5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013c8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013cb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013cd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
801013d2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d5:	e8 b6 34 00 00       	call   80104890 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f0                	mov    %esi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f3:	73 10                	jae    80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 9c 76 10 80       	push   $0x8010769c
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	89 c6                	mov    %eax,%esi
80101427:	53                   	push   %ebx
80101428:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010142b:	83 fa 0b             	cmp    $0xb,%edx
8010142e:	0f 86 8c 00 00 00    	jbe    801014c0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101434:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101437:	83 fb 7f             	cmp    $0x7f,%ebx
8010143a:	0f 87 a2 00 00 00    	ja     801014e2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101440:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101446:	85 c0                	test   %eax,%eax
80101448:	74 5e                	je     801014a8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010144a:	83 ec 08             	sub    $0x8,%esp
8010144d:	50                   	push   %eax
8010144e:	ff 36                	push   (%esi)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010145c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010145e:	8b 3b                	mov    (%ebx),%edi
80101460:	85 ff                	test   %edi,%edi
80101462:	74 1c                	je     80101480 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	52                   	push   %edx
80101468:	e8 83 ed ff ff       	call   801001f0 <brelse>
8010146d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101473:	89 f8                	mov    %edi,%eax
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5f                   	pop    %edi
80101478:	5d                   	pop    %ebp
80101479:	c3                   	ret    
8010147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101483:	8b 06                	mov    (%esi),%eax
80101485:	e8 86 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010148d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101490:	89 03                	mov    %eax,(%ebx)
80101492:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101494:	52                   	push   %edx
80101495:	e8 76 1a 00 00       	call   80102f10 <log_write>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010149d:	83 c4 10             	add    $0x10,%esp
801014a0:	eb c2                	jmp    80101464 <bmap+0x44>
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 61 fd ff ff       	call   80101210 <balloc>
801014af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014b5:	eb 93                	jmp    8010144a <bmap+0x2a>
801014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014be:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014c0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014c3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014c7:	85 ff                	test   %edi,%edi
801014c9:	75 a5                	jne    80101470 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014cb:	8b 00                	mov    (%eax),%eax
801014cd:	e8 3e fd ff ff       	call   80101210 <balloc>
801014d2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801014d6:	89 c7                	mov    %eax,%edi
}
801014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014db:	5b                   	pop    %ebx
801014dc:	89 f8                	mov    %edi,%eax
801014de:	5e                   	pop    %esi
801014df:	5f                   	pop    %edi
801014e0:	5d                   	pop    %ebp
801014e1:	c3                   	ret    
  panic("bmap: out of range");
801014e2:	83 ec 0c             	sub    $0xc,%esp
801014e5:	68 ac 76 10 80       	push   $0x801076ac
801014ea:	e8 91 ee ff ff       	call   80100380 <panic>
801014ef:	90                   	nop

801014f0 <readsb>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	56                   	push   %esi
801014f4:	53                   	push   %ebx
801014f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014f8:	83 ec 08             	sub    $0x8,%esp
801014fb:	6a 01                	push   $0x1
801014fd:	ff 75 08             	push   0x8(%ebp)
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101505:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101508:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010150a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010150d:	6a 1c                	push   $0x1c
8010150f:	50                   	push   %eax
80101510:	56                   	push   %esi
80101511:	e8 3a 35 00 00       	call   80104a50 <memmove>
  brelse(bp);
80101516:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101519:	83 c4 10             	add    $0x10,%esp
}
8010151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151f:	5b                   	pop    %ebx
80101520:	5e                   	pop    %esi
80101521:	5d                   	pop    %ebp
  brelse(bp);
80101522:	e9 c9 ec ff ff       	jmp    801001f0 <brelse>
80101527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010152e:	66 90                	xchg   %ax,%ax

80101530 <iinit>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	53                   	push   %ebx
80101534:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101539:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010153c:	68 bf 76 10 80       	push   $0x801076bf
80101541:	68 60 09 11 80       	push   $0x80110960
80101546:	e8 d5 31 00 00       	call   80104720 <initlock>
  for(i = 0; i < NINODE; i++) {
8010154b:	83 c4 10             	add    $0x10,%esp
8010154e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101550:	83 ec 08             	sub    $0x8,%esp
80101553:	68 c6 76 10 80       	push   $0x801076c6
80101558:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101559:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010155f:	e8 8c 30 00 00       	call   801045f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101564:	83 c4 10             	add    $0x10,%esp
80101567:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010156d:	75 e1                	jne    80101550 <iinit+0x20>
  bp = bread(dev, 1);
8010156f:	83 ec 08             	sub    $0x8,%esp
80101572:	6a 01                	push   $0x1
80101574:	ff 75 08             	push   0x8(%ebp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010157c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010157f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101581:	8d 40 5c             	lea    0x5c(%eax),%eax
80101584:	6a 1c                	push   $0x1c
80101586:	50                   	push   %eax
80101587:	68 b4 25 11 80       	push   $0x801125b4
8010158c:	e8 bf 34 00 00       	call   80104a50 <memmove>
  brelse(bp);
80101591:	89 1c 24             	mov    %ebx,(%esp)
80101594:	e8 57 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101599:	ff 35 cc 25 11 80    	push   0x801125cc
8010159f:	ff 35 c8 25 11 80    	push   0x801125c8
801015a5:	ff 35 c4 25 11 80    	push   0x801125c4
801015ab:	ff 35 c0 25 11 80    	push   0x801125c0
801015b1:	ff 35 bc 25 11 80    	push   0x801125bc
801015b7:	ff 35 b8 25 11 80    	push   0x801125b8
801015bd:	ff 35 b4 25 11 80    	push   0x801125b4
801015c3:	68 2c 77 10 80       	push   $0x8010772c
801015c8:	e8 d3 f0 ff ff       	call   801006a0 <cprintf>
}
801015cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015d0:	83 c4 30             	add    $0x30,%esp
801015d3:	c9                   	leave  
801015d4:	c3                   	ret    
801015d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015e0 <ialloc>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	57                   	push   %edi
801015e4:	56                   	push   %esi
801015e5:	53                   	push   %ebx
801015e6:	83 ec 1c             	sub    $0x1c,%esp
801015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
801015f3:	8b 75 08             	mov    0x8(%ebp),%esi
801015f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015f9:	0f 86 91 00 00 00    	jbe    80101690 <ialloc+0xb0>
801015ff:	bf 01 00 00 00       	mov    $0x1,%edi
80101604:	eb 21                	jmp    80101627 <ialloc+0x47>
80101606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 4d 33 00 00       	call   801049b0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 90 fc ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 cc 76 10 80       	push   $0x801076cc
80101698:	e8 e3 ec ff ff       	call   80100380 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ab:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ae:	83 ec 08             	sub    $0x8,%esp
801016b1:	c1 e8 03             	shr    $0x3,%eax
801016b4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ba:	50                   	push   %eax
801016bb:	ff 73 a4             	push   -0x5c(%ebx)
801016be:	e8 0d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ca:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fd:	6a 34                	push   $0x34
801016ff:	53                   	push   %ebx
80101700:	50                   	push   %eax
80101701:	e8 4a 33 00 00       	call   80104a50 <memmove>
  log_write(bp);
80101706:	89 34 24             	mov    %esi,(%esp)
80101709:	e8 02 18 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010170e:	89 75 08             	mov    %esi,0x8(%ebp)
80101711:	83 c4 10             	add    $0x10,%esp
}
80101714:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101717:	5b                   	pop    %ebx
80101718:	5e                   	pop    %esi
80101719:	5d                   	pop    %ebp
  brelse(bp);
8010171a:	e9 d1 ea ff ff       	jmp    801001f0 <brelse>
8010171f:	90                   	nop

80101720 <idup>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	53                   	push   %ebx
80101724:	83 ec 10             	sub    $0x10,%esp
80101727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010172a:	68 60 09 11 80       	push   $0x80110960
8010172f:	e8 bc 31 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101734:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101738:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010173f:	e8 4c 31 00 00       	call   80104890 <release>
}
80101744:	89 d8                	mov    %ebx,%eax
80101746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101749:	c9                   	leave  
8010174a:	c3                   	ret    
8010174b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010174f:	90                   	nop

80101750 <ilock>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	0f 84 b7 00 00 00    	je     80101817 <ilock+0xc7>
80101760:	8b 53 08             	mov    0x8(%ebx),%edx
80101763:	85 d2                	test   %edx,%edx
80101765:	0f 8e ac 00 00 00    	jle    80101817 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010176b:	83 ec 0c             	sub    $0xc,%esp
8010176e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101771:	50                   	push   %eax
80101772:	e8 b9 2e 00 00       	call   80104630 <acquiresleep>
  if(ip->valid == 0){
80101777:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010177a:	83 c4 10             	add    $0x10,%esp
8010177d:	85 c0                	test   %eax,%eax
8010177f:	74 0f                	je     80101790 <ilock+0x40>
}
80101781:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101784:	5b                   	pop    %ebx
80101785:	5e                   	pop    %esi
80101786:	5d                   	pop    %ebp
80101787:	c3                   	ret    
80101788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010178f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101790:	8b 43 04             	mov    0x4(%ebx),%eax
80101793:	83 ec 08             	sub    $0x8,%esp
80101796:	c1 e8 03             	shr    $0x3,%eax
80101799:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010179f:	50                   	push   %eax
801017a0:	ff 33                	push   (%ebx)
801017a2:	e8 29 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017aa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ac:	8b 43 04             	mov    0x4(%ebx),%eax
801017af:	83 e0 07             	and    $0x7,%eax
801017b2:	c1 e0 06             	shl    $0x6,%eax
801017b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017b9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017bc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017db:	8b 50 fc             	mov    -0x4(%eax),%edx
801017de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e1:	6a 34                	push   $0x34
801017e3:	50                   	push   %eax
801017e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017e7:	50                   	push   %eax
801017e8:	e8 63 32 00 00       	call   80104a50 <memmove>
    brelse(bp);
801017ed:	89 34 24             	mov    %esi,(%esp)
801017f0:	e8 fb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017f5:	83 c4 10             	add    $0x10,%esp
801017f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101804:	0f 85 77 ff ff ff    	jne    80101781 <ilock+0x31>
      panic("ilock: no type");
8010180a:	83 ec 0c             	sub    $0xc,%esp
8010180d:	68 e4 76 10 80       	push   $0x801076e4
80101812:	e8 69 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101817:	83 ec 0c             	sub    $0xc,%esp
8010181a:	68 de 76 10 80       	push   $0x801076de
8010181f:	e8 5c eb ff ff       	call   80100380 <panic>
80101824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop

80101830 <iunlock>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101838:	85 db                	test   %ebx,%ebx
8010183a:	74 28                	je     80101864 <iunlock+0x34>
8010183c:	83 ec 0c             	sub    $0xc,%esp
8010183f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101842:	56                   	push   %esi
80101843:	e8 88 2e 00 00       	call   801046d0 <holdingsleep>
80101848:	83 c4 10             	add    $0x10,%esp
8010184b:	85 c0                	test   %eax,%eax
8010184d:	74 15                	je     80101864 <iunlock+0x34>
8010184f:	8b 43 08             	mov    0x8(%ebx),%eax
80101852:	85 c0                	test   %eax,%eax
80101854:	7e 0e                	jle    80101864 <iunlock+0x34>
  releasesleep(&ip->lock);
80101856:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101859:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010185c:	5b                   	pop    %ebx
8010185d:	5e                   	pop    %esi
8010185e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010185f:	e9 2c 2e 00 00       	jmp    80104690 <releasesleep>
    panic("iunlock");
80101864:	83 ec 0c             	sub    $0xc,%esp
80101867:	68 f3 76 10 80       	push   $0x801076f3
8010186c:	e8 0f eb ff ff       	call   80100380 <panic>
80101871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iput>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	57                   	push   %edi
80101884:	56                   	push   %esi
80101885:	53                   	push   %ebx
80101886:	83 ec 28             	sub    $0x28,%esp
80101889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010188c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010188f:	57                   	push   %edi
80101890:	e8 9b 2d 00 00       	call   80104630 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101895:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 d2                	test   %edx,%edx
8010189d:	74 07                	je     801018a6 <iput+0x26>
8010189f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018a4:	74 32                	je     801018d8 <iput+0x58>
  releasesleep(&ip->lock);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	57                   	push   %edi
801018aa:	e8 e1 2d 00 00       	call   80104690 <releasesleep>
  acquire(&icache.lock);
801018af:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018b6:	e8 35 30 00 00       	call   801048f0 <acquire>
  ip->ref--;
801018bb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018bf:	83 c4 10             	add    $0x10,%esp
801018c2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018cc:	5b                   	pop    %ebx
801018cd:	5e                   	pop    %esi
801018ce:	5f                   	pop    %edi
801018cf:	5d                   	pop    %ebp
  release(&icache.lock);
801018d0:	e9 bb 2f 00 00       	jmp    80104890 <release>
801018d5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018d8:	83 ec 0c             	sub    $0xc,%esp
801018db:	68 60 09 11 80       	push   $0x80110960
801018e0:	e8 0b 30 00 00       	call   801048f0 <acquire>
    int r = ip->ref;
801018e5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018e8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018ef:	e8 9c 2f 00 00       	call   80104890 <release>
    if(r == 1){
801018f4:	83 c4 10             	add    $0x10,%esp
801018f7:	83 fe 01             	cmp    $0x1,%esi
801018fa:	75 aa                	jne    801018a6 <iput+0x26>
801018fc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101902:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101905:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101908:	89 cf                	mov    %ecx,%edi
8010190a:	eb 0b                	jmp    80101917 <iput+0x97>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101910:	83 c6 04             	add    $0x4,%esi
80101913:	39 fe                	cmp    %edi,%esi
80101915:	74 19                	je     80101930 <iput+0xb0>
    if(ip->addrs[i]){
80101917:	8b 16                	mov    (%esi),%edx
80101919:	85 d2                	test   %edx,%edx
8010191b:	74 f3                	je     80101910 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010191d:	8b 03                	mov    (%ebx),%eax
8010191f:	e8 6c f8 ff ff       	call   80101190 <bfree>
      ip->addrs[i] = 0;
80101924:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010192a:	eb e4                	jmp    80101910 <iput+0x90>
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101930:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101936:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101939:	85 c0                	test   %eax,%eax
8010193b:	75 2d                	jne    8010196a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010193d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101940:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101947:	53                   	push   %ebx
80101948:	e8 53 fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
8010194d:	31 c0                	xor    %eax,%eax
8010194f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101953:	89 1c 24             	mov    %ebx,(%esp)
80101956:	e8 45 fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
8010195b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101962:	83 c4 10             	add    $0x10,%esp
80101965:	e9 3c ff ff ff       	jmp    801018a6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010196a:	83 ec 08             	sub    $0x8,%esp
8010196d:	50                   	push   %eax
8010196e:	ff 33                	push   (%ebx)
80101970:	e8 5b e7 ff ff       	call   801000d0 <bread>
80101975:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101984:	8d 70 5c             	lea    0x5c(%eax),%esi
80101987:	89 cf                	mov    %ecx,%edi
80101989:	eb 0c                	jmp    80101997 <iput+0x117>
8010198b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop
80101990:	83 c6 04             	add    $0x4,%esi
80101993:	39 f7                	cmp    %esi,%edi
80101995:	74 0f                	je     801019a6 <iput+0x126>
      if(a[j])
80101997:	8b 16                	mov    (%esi),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x110>
        bfree(ip->dev, a[j]);
8010199d:	8b 03                	mov    (%ebx),%eax
8010199f:	e8 ec f7 ff ff       	call   80101190 <bfree>
801019a4:	eb ea                	jmp    80101990 <iput+0x110>
    brelse(bp);
801019a6:	83 ec 0c             	sub    $0xc,%esp
801019a9:	ff 75 e4             	push   -0x1c(%ebp)
801019ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019af:	e8 3c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019b4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ba:	8b 03                	mov    (%ebx),%eax
801019bc:	e8 cf f7 ff ff       	call   80101190 <bfree>
    ip->addrs[NDIRECT] = 0;
801019c1:	83 c4 10             	add    $0x10,%esp
801019c4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019cb:	00 00 00 
801019ce:	e9 6a ff ff ff       	jmp    8010193d <iput+0xbd>
801019d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801019e0 <iunlockput>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	56                   	push   %esi
801019e4:	53                   	push   %ebx
801019e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019e8:	85 db                	test   %ebx,%ebx
801019ea:	74 34                	je     80101a20 <iunlockput+0x40>
801019ec:	83 ec 0c             	sub    $0xc,%esp
801019ef:	8d 73 0c             	lea    0xc(%ebx),%esi
801019f2:	56                   	push   %esi
801019f3:	e8 d8 2c 00 00       	call   801046d0 <holdingsleep>
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	85 c0                	test   %eax,%eax
801019fd:	74 21                	je     80101a20 <iunlockput+0x40>
801019ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101a02:	85 c0                	test   %eax,%eax
80101a04:	7e 1a                	jle    80101a20 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a06:	83 ec 0c             	sub    $0xc,%esp
80101a09:	56                   	push   %esi
80101a0a:	e8 81 2c 00 00       	call   80104690 <releasesleep>
  iput(ip);
80101a0f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a12:	83 c4 10             	add    $0x10,%esp
}
80101a15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a18:	5b                   	pop    %ebx
80101a19:	5e                   	pop    %esi
80101a1a:	5d                   	pop    %ebp
  iput(ip);
80101a1b:	e9 60 fe ff ff       	jmp    80101880 <iput>
    panic("iunlock");
80101a20:	83 ec 0c             	sub    $0xc,%esp
80101a23:	68 f3 76 10 80       	push   $0x801076f3
80101a28:	e8 53 e9 ff ff       	call   80100380 <panic>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	8b 55 08             	mov    0x8(%ebp),%edx
80101a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a39:	8b 0a                	mov    (%edx),%ecx
80101a3b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a3e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a41:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a44:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a48:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a4f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a53:	8b 52 58             	mov    0x58(%edx),%edx
80101a56:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a59:	5d                   	pop    %ebp
80101a5a:	c3                   	ret    
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a72:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a75:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a78:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 a7 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	8b 40 58             	mov    0x58(%eax),%eax
80101a8f:	39 c6                	cmp    %eax,%esi
80101a91:	0f 87 ba 00 00 00    	ja     80101b51 <readi+0xf1>
80101a97:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9a:	31 c9                	xor    %ecx,%ecx
80101a9c:	89 da                	mov    %ebx,%edx
80101a9e:	01 f2                	add    %esi,%edx
80101aa0:	0f 92 c1             	setb   %cl
80101aa3:	89 cf                	mov    %ecx,%edi
80101aa5:	0f 82 a6 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aab:	89 c1                	mov    %eax,%ecx
80101aad:	29 f1                	sub    %esi,%ecx
80101aaf:	39 d0                	cmp    %edx,%eax
80101ab1:	0f 43 cb             	cmovae %ebx,%ecx
80101ab4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	85 c9                	test   %ecx,%ecx
80101ab9:	74 67                	je     80101b22 <readi+0xc2>
80101abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 51 f9 ff ff       	call   80101420 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	push   (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae4:	89 f0                	mov    %esi,%eax
80101ae6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aeb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aed:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af6:	39 d9                	cmp    %ebx,%ecx
80101af8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afb:	83 c4 0c             	add    $0xc,%esp
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	push   -0x20(%ebp)
80101b07:	e8 44 2f 00 00       	call   80104a50 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	57                   	push   %edi
80101b64:	56                   	push   %esi
80101b65:	53                   	push   %ebx
80101b66:	83 ec 1c             	sub    $0x1c,%esp
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b6f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b83:	0f 84 b7 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b8f:	0f 87 e7 00 00 00    	ja     80101c7c <writei+0x11c>
80101b95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b98:	31 d2                	xor    %edx,%edx
80101b9a:	89 f8                	mov    %edi,%eax
80101b9c:	01 f0                	add    %esi,%eax
80101b9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ba6:	0f 87 d0 00 00 00    	ja     80101c7c <writei+0x11c>
80101bac:	85 d2                	test   %edx,%edx
80101bae:	0f 85 c8 00 00 00    	jne    80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bbb:	85 ff                	test   %edi,%edi
80101bbd:	74 72                	je     80101c31 <writei+0xd1>
80101bbf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 51 f8 ff ff       	call   80101420 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	push   (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bee:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf4:	39 d9                	cmp    %ebx,%ecx
80101bf6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	push   -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 48 2e 00 00       	call   80104a50 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c96:	6a 0e                	push   $0xe
80101c98:	ff 75 0c             	push   0xc(%ebp)
80101c9b:	ff 75 08             	push   0x8(%ebp)
80101c9e:	e8 1d 2e 00 00       	call   80104ac0 <strncmp>
}
80101ca3:	c9                   	leave  
80101ca4:	c3                   	ret    
80101ca5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	56                   	push   %esi
80101cb5:	53                   	push   %ebx
80101cb6:	83 ec 1c             	sub    $0x1c,%esp
80101cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc1:	0f 85 85 00 00 00    	jne    80101d4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cca:	31 ff                	xor    %edi,%edi
80101ccc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ccf:	85 d2                	test   %edx,%edx
80101cd1:	74 3e                	je     80101d11 <dirlookup+0x61>
80101cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cd7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cd8:	6a 10                	push   $0x10
80101cda:	57                   	push   %edi
80101cdb:	56                   	push   %esi
80101cdc:	53                   	push   %ebx
80101cdd:	e8 7e fd ff ff       	call   80101a60 <readi>
80101ce2:	83 c4 10             	add    $0x10,%esp
80101ce5:	83 f8 10             	cmp    $0x10,%eax
80101ce8:	75 55                	jne    80101d3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101cea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cef:	74 18                	je     80101d09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101cf1:	83 ec 04             	sub    $0x4,%esp
80101cf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cf7:	6a 0e                	push   $0xe
80101cf9:	50                   	push   %eax
80101cfa:	ff 75 0c             	push   0xc(%ebp)
80101cfd:	e8 be 2d 00 00       	call   80104ac0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d02:	83 c4 10             	add    $0x10,%esp
80101d05:	85 c0                	test   %eax,%eax
80101d07:	74 17                	je     80101d20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d09:	83 c7 10             	add    $0x10,%edi
80101d0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d0f:	72 c7                	jb     80101cd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d14:	31 c0                	xor    %eax,%eax
}
80101d16:	5b                   	pop    %ebx
80101d17:	5e                   	pop    %esi
80101d18:	5f                   	pop    %edi
80101d19:	5d                   	pop    %ebp
80101d1a:	c3                   	ret    
80101d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d1f:	90                   	nop
      if(poff)
80101d20:	8b 45 10             	mov    0x10(%ebp),%eax
80101d23:	85 c0                	test   %eax,%eax
80101d25:	74 05                	je     80101d2c <dirlookup+0x7c>
        *poff = off;
80101d27:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d30:	8b 03                	mov    (%ebx),%eax
80101d32:	e8 e9 f5 ff ff       	call   80101320 <iget>
}
80101d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d3a:	5b                   	pop    %ebx
80101d3b:	5e                   	pop    %esi
80101d3c:	5f                   	pop    %edi
80101d3d:	5d                   	pop    %ebp
80101d3e:	c3                   	ret    
      panic("dirlookup read");
80101d3f:	83 ec 0c             	sub    $0xc,%esp
80101d42:	68 0d 77 10 80       	push   $0x8010770d
80101d47:	e8 34 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d4c:	83 ec 0c             	sub    $0xc,%esp
80101d4f:	68 fb 76 10 80       	push   $0x801076fb
80101d54:	e8 27 e6 ff ff       	call   80100380 <panic>
80101d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	89 c3                	mov    %eax,%ebx
80101d68:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d6b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d6e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d71:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d74:	0f 84 64 01 00 00    	je     80101ede <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d7a:	e8 01 1c 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101d7f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d82:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d85:	68 60 09 11 80       	push   $0x80110960
80101d8a:	e8 61 2b 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101d8f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d93:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101d9a:	e8 f1 2a 00 00       	call   80104890 <release>
80101d9f:	83 c4 10             	add    $0x10,%esp
80101da2:	eb 07                	jmp    80101dab <namex+0x4b>
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101da8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dab:	0f b6 03             	movzbl (%ebx),%eax
80101dae:	3c 2f                	cmp    $0x2f,%al
80101db0:	74 f6                	je     80101da8 <namex+0x48>
  if(*path == 0)
80101db2:	84 c0                	test   %al,%al
80101db4:	0f 84 06 01 00 00    	je     80101ec0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dba:	0f b6 03             	movzbl (%ebx),%eax
80101dbd:	84 c0                	test   %al,%al
80101dbf:	0f 84 10 01 00 00    	je     80101ed5 <namex+0x175>
80101dc5:	89 df                	mov    %ebx,%edi
80101dc7:	3c 2f                	cmp    $0x2f,%al
80101dc9:	0f 84 06 01 00 00    	je     80101ed5 <namex+0x175>
80101dcf:	90                   	nop
80101dd0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101dd4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101dd7:	3c 2f                	cmp    $0x2f,%al
80101dd9:	74 04                	je     80101ddf <namex+0x7f>
80101ddb:	84 c0                	test   %al,%al
80101ddd:	75 f1                	jne    80101dd0 <namex+0x70>
  len = path - s;
80101ddf:	89 f8                	mov    %edi,%eax
80101de1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101de3:	83 f8 0d             	cmp    $0xd,%eax
80101de6:	0f 8e ac 00 00 00    	jle    80101e98 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101dec:	83 ec 04             	sub    $0x4,%esp
80101def:	6a 0e                	push   $0xe
80101df1:	53                   	push   %ebx
    path++;
80101df2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101df4:	ff 75 e4             	push   -0x1c(%ebp)
80101df7:	e8 54 2c 00 00       	call   80104a50 <memmove>
80101dfc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dff:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e02:	75 0c                	jne    80101e10 <namex+0xb0>
80101e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e0b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e0e:	74 f8                	je     80101e08 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e10:	83 ec 0c             	sub    $0xc,%esp
80101e13:	56                   	push   %esi
80101e14:	e8 37 f9 ff ff       	call   80101750 <ilock>
    if(ip->type != T_DIR){
80101e19:	83 c4 10             	add    $0x10,%esp
80101e1c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e21:	0f 85 cd 00 00 00    	jne    80101ef4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e2a:	85 c0                	test   %eax,%eax
80101e2c:	74 09                	je     80101e37 <namex+0xd7>
80101e2e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e31:	0f 84 22 01 00 00    	je     80101f59 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e37:	83 ec 04             	sub    $0x4,%esp
80101e3a:	6a 00                	push   $0x0
80101e3c:	ff 75 e4             	push   -0x1c(%ebp)
80101e3f:	56                   	push   %esi
80101e40:	e8 6b fe ff ff       	call   80101cb0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e45:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e48:	83 c4 10             	add    $0x10,%esp
80101e4b:	89 c7                	mov    %eax,%edi
80101e4d:	85 c0                	test   %eax,%eax
80101e4f:	0f 84 e1 00 00 00    	je     80101f36 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e55:	83 ec 0c             	sub    $0xc,%esp
80101e58:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e5b:	52                   	push   %edx
80101e5c:	e8 6f 28 00 00       	call   801046d0 <holdingsleep>
80101e61:	83 c4 10             	add    $0x10,%esp
80101e64:	85 c0                	test   %eax,%eax
80101e66:	0f 84 30 01 00 00    	je     80101f9c <namex+0x23c>
80101e6c:	8b 56 08             	mov    0x8(%esi),%edx
80101e6f:	85 d2                	test   %edx,%edx
80101e71:	0f 8e 25 01 00 00    	jle    80101f9c <namex+0x23c>
  releasesleep(&ip->lock);
80101e77:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e7a:	83 ec 0c             	sub    $0xc,%esp
80101e7d:	52                   	push   %edx
80101e7e:	e8 0d 28 00 00       	call   80104690 <releasesleep>
  iput(ip);
80101e83:	89 34 24             	mov    %esi,(%esp)
80101e86:	89 fe                	mov    %edi,%esi
80101e88:	e8 f3 f9 ff ff       	call   80101880 <iput>
80101e8d:	83 c4 10             	add    $0x10,%esp
80101e90:	e9 16 ff ff ff       	jmp    80101dab <namex+0x4b>
80101e95:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101e98:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e9b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101e9e:	83 ec 04             	sub    $0x4,%esp
80101ea1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ea4:	50                   	push   %eax
80101ea5:	53                   	push   %ebx
    name[len] = 0;
80101ea6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ea8:	ff 75 e4             	push   -0x1c(%ebp)
80101eab:	e8 a0 2b 00 00       	call   80104a50 <memmove>
    name[len] = 0;
80101eb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eb3:	83 c4 10             	add    $0x10,%esp
80101eb6:	c6 02 00             	movb   $0x0,(%edx)
80101eb9:	e9 41 ff ff ff       	jmp    80101dff <namex+0x9f>
80101ebe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 be 00 00 00    	jne    80101f89 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ed8:	89 df                	mov    %ebx,%edi
80101eda:	31 c0                	xor    %eax,%eax
80101edc:	eb c0                	jmp    80101e9e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101ede:	ba 01 00 00 00       	mov    $0x1,%edx
80101ee3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ee8:	e8 33 f4 ff ff       	call   80101320 <iget>
80101eed:	89 c6                	mov    %eax,%esi
80101eef:	e9 b7 fe ff ff       	jmp    80101dab <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ef4:	83 ec 0c             	sub    $0xc,%esp
80101ef7:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101efa:	53                   	push   %ebx
80101efb:	e8 d0 27 00 00       	call   801046d0 <holdingsleep>
80101f00:	83 c4 10             	add    $0x10,%esp
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 84 91 00 00 00    	je     80101f9c <namex+0x23c>
80101f0b:	8b 46 08             	mov    0x8(%esi),%eax
80101f0e:	85 c0                	test   %eax,%eax
80101f10:	0f 8e 86 00 00 00    	jle    80101f9c <namex+0x23c>
  releasesleep(&ip->lock);
80101f16:	83 ec 0c             	sub    $0xc,%esp
80101f19:	53                   	push   %ebx
80101f1a:	e8 71 27 00 00       	call   80104690 <releasesleep>
  iput(ip);
80101f1f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f22:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f24:	e8 57 f9 ff ff       	call   80101880 <iput>
      return 0;
80101f29:	83 c4 10             	add    $0x10,%esp
}
80101f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2f:	89 f0                	mov    %esi,%eax
80101f31:	5b                   	pop    %ebx
80101f32:	5e                   	pop    %esi
80101f33:	5f                   	pop    %edi
80101f34:	5d                   	pop    %ebp
80101f35:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f36:	83 ec 0c             	sub    $0xc,%esp
80101f39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f3c:	52                   	push   %edx
80101f3d:	e8 8e 27 00 00       	call   801046d0 <holdingsleep>
80101f42:	83 c4 10             	add    $0x10,%esp
80101f45:	85 c0                	test   %eax,%eax
80101f47:	74 53                	je     80101f9c <namex+0x23c>
80101f49:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f4c:	85 c9                	test   %ecx,%ecx
80101f4e:	7e 4c                	jle    80101f9c <namex+0x23c>
  releasesleep(&ip->lock);
80101f50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f53:	83 ec 0c             	sub    $0xc,%esp
80101f56:	52                   	push   %edx
80101f57:	eb c1                	jmp    80101f1a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f59:	83 ec 0c             	sub    $0xc,%esp
80101f5c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f5f:	53                   	push   %ebx
80101f60:	e8 6b 27 00 00       	call   801046d0 <holdingsleep>
80101f65:	83 c4 10             	add    $0x10,%esp
80101f68:	85 c0                	test   %eax,%eax
80101f6a:	74 30                	je     80101f9c <namex+0x23c>
80101f6c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f6f:	85 ff                	test   %edi,%edi
80101f71:	7e 29                	jle    80101f9c <namex+0x23c>
  releasesleep(&ip->lock);
80101f73:	83 ec 0c             	sub    $0xc,%esp
80101f76:	53                   	push   %ebx
80101f77:	e8 14 27 00 00       	call   80104690 <releasesleep>
}
80101f7c:	83 c4 10             	add    $0x10,%esp
}
80101f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f82:	89 f0                	mov    %esi,%eax
80101f84:	5b                   	pop    %ebx
80101f85:	5e                   	pop    %esi
80101f86:	5f                   	pop    %edi
80101f87:	5d                   	pop    %ebp
80101f88:	c3                   	ret    
    iput(ip);
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	56                   	push   %esi
    return 0;
80101f8d:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f8f:	e8 ec f8 ff ff       	call   80101880 <iput>
    return 0;
80101f94:	83 c4 10             	add    $0x10,%esp
80101f97:	e9 2f ff ff ff       	jmp    80101ecb <namex+0x16b>
    panic("iunlock");
80101f9c:	83 ec 0c             	sub    $0xc,%esp
80101f9f:	68 f3 76 10 80       	push   $0x801076f3
80101fa4:	e8 d7 e3 ff ff       	call   80100380 <panic>
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fb0 <dirlink>:
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	57                   	push   %edi
80101fb4:	56                   	push   %esi
80101fb5:	53                   	push   %ebx
80101fb6:	83 ec 20             	sub    $0x20,%esp
80101fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fbc:	6a 00                	push   $0x0
80101fbe:	ff 75 0c             	push   0xc(%ebp)
80101fc1:	53                   	push   %ebx
80101fc2:	e8 e9 fc ff ff       	call   80101cb0 <dirlookup>
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	85 c0                	test   %eax,%eax
80101fcc:	75 67                	jne    80102035 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fce:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fd1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fd4:	85 ff                	test   %edi,%edi
80101fd6:	74 29                	je     80102001 <dirlink+0x51>
80101fd8:	31 ff                	xor    %edi,%edi
80101fda:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fdd:	eb 09                	jmp    80101fe8 <dirlink+0x38>
80101fdf:	90                   	nop
80101fe0:	83 c7 10             	add    $0x10,%edi
80101fe3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fe6:	73 19                	jae    80102001 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe8:	6a 10                	push   $0x10
80101fea:	57                   	push   %edi
80101feb:	56                   	push   %esi
80101fec:	53                   	push   %ebx
80101fed:	e8 6e fa ff ff       	call   80101a60 <readi>
80101ff2:	83 c4 10             	add    $0x10,%esp
80101ff5:	83 f8 10             	cmp    $0x10,%eax
80101ff8:	75 4e                	jne    80102048 <dirlink+0x98>
    if(de.inum == 0)
80101ffa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fff:	75 df                	jne    80101fe0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102001:	83 ec 04             	sub    $0x4,%esp
80102004:	8d 45 da             	lea    -0x26(%ebp),%eax
80102007:	6a 0e                	push   $0xe
80102009:	ff 75 0c             	push   0xc(%ebp)
8010200c:	50                   	push   %eax
8010200d:	e8 fe 2a 00 00       	call   80104b10 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102012:	6a 10                	push   $0x10
  de.inum = inum;
80102014:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102017:	57                   	push   %edi
80102018:	56                   	push   %esi
80102019:	53                   	push   %ebx
  de.inum = inum;
8010201a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010201e:	e8 3d fb ff ff       	call   80101b60 <writei>
80102023:	83 c4 20             	add    $0x20,%esp
80102026:	83 f8 10             	cmp    $0x10,%eax
80102029:	75 2a                	jne    80102055 <dirlink+0xa5>
  return 0;
8010202b:	31 c0                	xor    %eax,%eax
}
8010202d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102030:	5b                   	pop    %ebx
80102031:	5e                   	pop    %esi
80102032:	5f                   	pop    %edi
80102033:	5d                   	pop    %ebp
80102034:	c3                   	ret    
    iput(ip);
80102035:	83 ec 0c             	sub    $0xc,%esp
80102038:	50                   	push   %eax
80102039:	e8 42 f8 ff ff       	call   80101880 <iput>
    return -1;
8010203e:	83 c4 10             	add    $0x10,%esp
80102041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102046:	eb e5                	jmp    8010202d <dirlink+0x7d>
      panic("dirlink read");
80102048:	83 ec 0c             	sub    $0xc,%esp
8010204b:	68 1c 77 10 80       	push   $0x8010771c
80102050:	e8 2b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102055:	83 ec 0c             	sub    $0xc,%esp
80102058:	68 8a 7d 10 80       	push   $0x80107d8a
8010205d:	e8 1e e3 ff ff       	call   80100380 <panic>
80102062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <namei>:

struct inode*
namei(char *path)
{
80102070:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102071:	31 d2                	xor    %edx,%edx
{
80102073:	89 e5                	mov    %esp,%ebp
80102075:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102078:	8b 45 08             	mov    0x8(%ebp),%eax
8010207b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010207e:	e8 dd fc ff ff       	call   80101d60 <namex>
}
80102083:	c9                   	leave  
80102084:	c3                   	ret    
80102085:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102090 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102090:	55                   	push   %ebp
  return namex(path, 1, name);
80102091:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102096:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010209b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010209e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010209f:	e9 bc fc ff ff       	jmp    80101d60 <namex>
801020a4:	66 90                	xchg   %ax,%ax
801020a6:	66 90                	xchg   %ax,%ax
801020a8:	66 90                	xchg   %ax,%ax
801020aa:	66 90                	xchg   %ax,%ax
801020ac:	66 90                	xchg   %ax,%ax
801020ae:	66 90                	xchg   %ax,%ax

801020b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020b9:	85 c0                	test   %eax,%eax
801020bb:	0f 84 b4 00 00 00    	je     80102175 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020c1:	8b 70 08             	mov    0x8(%eax),%esi
801020c4:	89 c3                	mov    %eax,%ebx
801020c6:	81 fe 1f 4e 00 00    	cmp    $0x4e1f,%esi
801020cc:	0f 87 96 00 00 00    	ja     80102168 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020de:	66 90                	xchg   %ax,%ax
801020e0:	89 ca                	mov    %ecx,%edx
801020e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e3:	83 e0 c0             	and    $0xffffffc0,%eax
801020e6:	3c 40                	cmp    $0x40,%al
801020e8:	75 f6                	jne    801020e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ea:	31 ff                	xor    %edi,%edi
801020ec:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020f1:	89 f8                	mov    %edi,%eax
801020f3:	ee                   	out    %al,(%dx)
801020f4:	b8 01 00 00 00       	mov    $0x1,%eax
801020f9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020fe:	ee                   	out    %al,(%dx)
801020ff:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102104:	89 f0                	mov    %esi,%eax
80102106:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102107:	89 f0                	mov    %esi,%eax
80102109:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010210e:	c1 f8 08             	sar    $0x8,%eax
80102111:	ee                   	out    %al,(%dx)
80102112:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102117:	89 f8                	mov    %edi,%eax
80102119:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010211a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010211e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102123:	c1 e0 04             	shl    $0x4,%eax
80102126:	83 e0 10             	and    $0x10,%eax
80102129:	83 c8 e0             	or     $0xffffffe0,%eax
8010212c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010212d:	f6 03 04             	testb  $0x4,(%ebx)
80102130:	75 16                	jne    80102148 <idestart+0x98>
80102132:	b8 20 00 00 00       	mov    $0x20,%eax
80102137:	89 ca                	mov    %ecx,%edx
80102139:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010213a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213d:	5b                   	pop    %ebx
8010213e:	5e                   	pop    %esi
8010213f:	5f                   	pop    %edi
80102140:	5d                   	pop    %ebp
80102141:	c3                   	ret    
80102142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102148:	b8 30 00 00 00       	mov    $0x30,%eax
8010214d:	89 ca                	mov    %ecx,%edx
8010214f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102150:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102155:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102158:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010215d:	fc                   	cld    
8010215e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102163:	5b                   	pop    %ebx
80102164:	5e                   	pop    %esi
80102165:	5f                   	pop    %edi
80102166:	5d                   	pop    %ebp
80102167:	c3                   	ret    
    panic("incorrect blockno");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 88 77 10 80       	push   $0x80107788
80102170:	e8 0b e2 ff ff       	call   80100380 <panic>
    panic("idestart");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 7f 77 10 80       	push   $0x8010777f
8010217d:	e8 fe e1 ff ff       	call   80100380 <panic>
80102182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <ideinit>:
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102196:	68 9a 77 10 80       	push   $0x8010779a
8010219b:	68 00 26 11 80       	push   $0x80112600
801021a0:	e8 7b 25 00 00       	call   80104720 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021a5:	58                   	pop    %eax
801021a6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021ab:	5a                   	pop    %edx
801021ac:	83 e8 01             	sub    $0x1,%eax
801021af:	50                   	push   %eax
801021b0:	6a 0e                	push   $0xe
801021b2:	e8 99 02 00 00       	call   80102450 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ba:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021bf:	90                   	nop
801021c0:	ec                   	in     (%dx),%al
801021c1:	83 e0 c0             	and    $0xffffffc0,%eax
801021c4:	3c 40                	cmp    $0x40,%al
801021c6:	75 f8                	jne    801021c0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021cd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d2:	ee                   	out    %al,(%dx)
801021d3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021dd:	eb 06                	jmp    801021e5 <ideinit+0x55>
801021df:	90                   	nop
  for(i=0; i<1000; i++){
801021e0:	83 e9 01             	sub    $0x1,%ecx
801021e3:	74 0f                	je     801021f4 <ideinit+0x64>
801021e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e6:	84 c0                	test   %al,%al
801021e8:	74 f6                	je     801021e0 <ideinit+0x50>
      havedisk1 = 1;
801021ea:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801021f1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021f9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021fe:	ee                   	out    %al,(%dx)
}
801021ff:	c9                   	leave  
80102200:	c3                   	ret    
80102201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220f:	90                   	nop

80102210 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	57                   	push   %edi
80102214:	56                   	push   %esi
80102215:	53                   	push   %ebx
80102216:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102219:	68 00 26 11 80       	push   $0x80112600
8010221e:	e8 cd 26 00 00       	call   801048f0 <acquire>

  if((b = idequeue) == 0){
80102223:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102229:	83 c4 10             	add    $0x10,%esp
8010222c:	85 db                	test   %ebx,%ebx
8010222e:	74 63                	je     80102293 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102230:	8b 43 58             	mov    0x58(%ebx),%eax
80102233:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102238:	8b 33                	mov    (%ebx),%esi
8010223a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102240:	75 2f                	jne    80102271 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102242:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224e:	66 90                	xchg   %ax,%ax
80102250:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102251:	89 c1                	mov    %eax,%ecx
80102253:	83 e1 c0             	and    $0xffffffc0,%ecx
80102256:	80 f9 40             	cmp    $0x40,%cl
80102259:	75 f5                	jne    80102250 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010225b:	a8 21                	test   $0x21,%al
8010225d:	75 12                	jne    80102271 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010225f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102262:	b9 80 00 00 00       	mov    $0x80,%ecx
80102267:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010226c:	fc                   	cld    
8010226d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010226f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102271:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102274:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102277:	83 ce 02             	or     $0x2,%esi
8010227a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010227c:	53                   	push   %ebx
8010227d:	e8 de 1f 00 00       	call   80104260 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102282:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	85 c0                	test   %eax,%eax
8010228c:	74 05                	je     80102293 <ideintr+0x83>
    idestart(idequeue);
8010228e:	e8 1d fe ff ff       	call   801020b0 <idestart>
    release(&idelock);
80102293:	83 ec 0c             	sub    $0xc,%esp
80102296:	68 00 26 11 80       	push   $0x80112600
8010229b:	e8 f0 25 00 00       	call   80104890 <release>

  release(&idelock);
}
801022a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a3:	5b                   	pop    %ebx
801022a4:	5e                   	pop    %esi
801022a5:	5f                   	pop    %edi
801022a6:	5d                   	pop    %ebp
801022a7:	c3                   	ret    
801022a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop

801022b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 10             	sub    $0x10,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801022bd:	50                   	push   %eax
801022be:	e8 0d 24 00 00       	call   801046d0 <holdingsleep>
801022c3:	83 c4 10             	add    $0x10,%esp
801022c6:	85 c0                	test   %eax,%eax
801022c8:	0f 84 c3 00 00 00    	je     80102391 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ce:	8b 03                	mov    (%ebx),%eax
801022d0:	83 e0 06             	and    $0x6,%eax
801022d3:	83 f8 02             	cmp    $0x2,%eax
801022d6:	0f 84 a8 00 00 00    	je     80102384 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022dc:	8b 53 04             	mov    0x4(%ebx),%edx
801022df:	85 d2                	test   %edx,%edx
801022e1:	74 0d                	je     801022f0 <iderw+0x40>
801022e3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801022e8:	85 c0                	test   %eax,%eax
801022ea:	0f 84 87 00 00 00    	je     80102377 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022f0:	83 ec 0c             	sub    $0xc,%esp
801022f3:	68 00 26 11 80       	push   $0x80112600
801022f8:	e8 f3 25 00 00       	call   801048f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022fd:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102302:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	85 c0                	test   %eax,%eax
8010230e:	74 60                	je     80102370 <iderw+0xc0>
80102310:	89 c2                	mov    %eax,%edx
80102312:	8b 40 58             	mov    0x58(%eax),%eax
80102315:	85 c0                	test   %eax,%eax
80102317:	75 f7                	jne    80102310 <iderw+0x60>
80102319:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010231c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010231e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102324:	74 3a                	je     80102360 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102326:	8b 03                	mov    (%ebx),%eax
80102328:	83 e0 06             	and    $0x6,%eax
8010232b:	83 f8 02             	cmp    $0x2,%eax
8010232e:	74 1b                	je     8010234b <iderw+0x9b>
    sleep(b, &idelock);
80102330:	83 ec 08             	sub    $0x8,%esp
80102333:	68 00 26 11 80       	push   $0x80112600
80102338:	53                   	push   %ebx
80102339:	e8 62 1e 00 00       	call   801041a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	83 e0 06             	and    $0x6,%eax
80102346:	83 f8 02             	cmp    $0x2,%eax
80102349:	75 e5                	jne    80102330 <iderw+0x80>
  }


  release(&idelock);
8010234b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102355:	c9                   	leave  
  release(&idelock);
80102356:	e9 35 25 00 00       	jmp    80104890 <release>
8010235b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010235f:	90                   	nop
    idestart(b);
80102360:	89 d8                	mov    %ebx,%eax
80102362:	e8 49 fd ff ff       	call   801020b0 <idestart>
80102367:	eb bd                	jmp    80102326 <iderw+0x76>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102370:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102375:	eb a5                	jmp    8010231c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 c9 77 10 80       	push   $0x801077c9
8010237f:	e8 fc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102384:	83 ec 0c             	sub    $0xc,%esp
80102387:	68 b4 77 10 80       	push   $0x801077b4
8010238c:	e8 ef df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102391:	83 ec 0c             	sub    $0xc,%esp
80102394:	68 9e 77 10 80       	push   $0x8010779e
80102399:	e8 e2 df ff ff       	call   80100380 <panic>
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023a0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023a1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023a8:	00 c0 fe 
{
801023ab:	89 e5                	mov    %esp,%ebp
801023ad:	56                   	push   %esi
801023ae:	53                   	push   %ebx
  ioapic->reg = reg;
801023af:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023b6:	00 00 00 
  return ioapic->data;
801023b9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023bf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023c2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023c8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ce:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023d5:	c1 ee 10             	shr    $0x10,%esi
801023d8:	89 f0                	mov    %esi,%eax
801023da:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023dd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023e0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023e3:	39 c2                	cmp    %eax,%edx
801023e5:	74 16                	je     801023fd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 e8 77 10 80       	push   $0x801077e8
801023ef:	e8 ac e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
801023f4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fa:	83 c4 10             	add    $0x10,%esp
801023fd:	83 c6 21             	add    $0x21,%esi
{
80102400:	ba 10 00 00 00       	mov    $0x10,%edx
80102405:	b8 20 00 00 00       	mov    $0x20,%eax
8010240a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102410:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102412:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102414:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010241a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010241d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102423:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102426:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102429:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010242c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010242e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102434:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010243b:	39 f0                	cmp    %esi,%eax
8010243d:	75 d1                	jne    80102410 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010243f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102442:	5b                   	pop    %ebx
80102443:	5e                   	pop    %esi
80102444:	5d                   	pop    %ebp
80102445:	c3                   	ret    
80102446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244d:	8d 76 00             	lea    0x0(%esi),%esi

80102450 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102450:	55                   	push   %ebp
  ioapic->reg = reg;
80102451:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102457:	89 e5                	mov    %esp,%ebp
80102459:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010245c:	8d 50 20             	lea    0x20(%eax),%edx
8010245f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102463:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102465:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010246e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102471:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102474:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102476:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010247e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102481:	5d                   	pop    %ebp
80102482:	c3                   	ret    
80102483:	66 90                	xchg   %ax,%ax
80102485:	66 90                	xchg   %ax,%ax
80102487:	66 90                	xchg   %ax,%ax
80102489:	66 90                	xchg   %ax,%ax
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010249a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024a0:	75 76                	jne    80102518 <kfree+0x88>
801024a2:	81 fb d0 6e 11 80    	cmp    $0x80116ed0,%ebx
801024a8:	72 6e                	jb     80102518 <kfree+0x88>
801024aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024b5:	77 61                	ja     80102518 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024b7:	83 ec 04             	sub    $0x4,%esp
801024ba:	68 00 10 00 00       	push   $0x1000
801024bf:	6a 01                	push   $0x1
801024c1:	53                   	push   %ebx
801024c2:	e8 e9 24 00 00       	call   801049b0 <memset>

  if(kmem.use_lock)
801024c7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024cd:	83 c4 10             	add    $0x10,%esp
801024d0:	85 d2                	test   %edx,%edx
801024d2:	75 1c                	jne    801024f0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024d4:	a1 78 26 11 80       	mov    0x80112678,%eax
801024d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024db:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024e0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024e6:	85 c0                	test   %eax,%eax
801024e8:	75 1e                	jne    80102508 <kfree+0x78>
    release(&kmem.lock);
}
801024ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ed:	c9                   	leave  
801024ee:	c3                   	ret    
801024ef:	90                   	nop
    acquire(&kmem.lock);
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 40 26 11 80       	push   $0x80112640
801024f8:	e8 f3 23 00 00       	call   801048f0 <acquire>
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	eb d2                	jmp    801024d4 <kfree+0x44>
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102508:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010250f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102512:	c9                   	leave  
    release(&kmem.lock);
80102513:	e9 78 23 00 00       	jmp    80104890 <release>
    panic("kfree");
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	68 1a 78 10 80       	push   $0x8010781a
80102520:	e8 5b de ff ff       	call   80100380 <panic>
80102525:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102530 <freerange>:
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102534:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102537:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010253b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102541:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102547:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010254d:	39 de                	cmp    %ebx,%esi
8010254f:	72 23                	jb     80102574 <freerange+0x44>
80102551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102567:	50                   	push   %eax
80102568:	e8 23 ff ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	39 f3                	cmp    %esi,%ebx
80102572:	76 e4                	jbe    80102558 <freerange+0x28>
}
80102574:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102577:	5b                   	pop    %ebx
80102578:	5e                   	pop    %esi
80102579:	5d                   	pop    %ebp
8010257a:	c3                   	ret    
8010257b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010257f:	90                   	nop

80102580 <kinit2>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102587:	8b 75 0c             	mov    0xc(%ebp),%esi
8010258a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <kinit2+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 d3 fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit2+0x28>
  kmem.use_lock = 1;
801025c4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025cb:	00 00 00 
}
801025ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d1:	5b                   	pop    %ebx
801025d2:	5e                   	pop    %esi
801025d3:	5d                   	pop    %ebp
801025d4:	c3                   	ret    
801025d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <kinit1>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
801025e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025e8:	83 ec 08             	sub    $0x8,%esp
801025eb:	68 20 78 10 80       	push   $0x80107820
801025f0:	68 40 26 11 80       	push   $0x80112640
801025f5:	e8 26 21 00 00       	call   80104720 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102600:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102607:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102610:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102616:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261c:	39 de                	cmp    %ebx,%esi
8010261e:	72 1c                	jb     8010263c <kinit1+0x5c>
    kfree(p);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102629:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010262f:	50                   	push   %eax
80102630:	e8 5b fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102635:	83 c4 10             	add    $0x10,%esp
80102638:	39 de                	cmp    %ebx,%esi
8010263a:	73 e4                	jae    80102620 <kinit1+0x40>
}
8010263c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010263f:	5b                   	pop    %ebx
80102640:	5e                   	pop    %esi
80102641:	5d                   	pop    %ebp
80102642:	c3                   	ret    
80102643:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102650 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102650:	a1 74 26 11 80       	mov    0x80112674,%eax
80102655:	85 c0                	test   %eax,%eax
80102657:	75 1f                	jne    80102678 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102659:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010265e:	85 c0                	test   %eax,%eax
80102660:	74 0e                	je     80102670 <kalloc+0x20>
    kmem.freelist = r->next;
80102662:	8b 10                	mov    (%eax),%edx
80102664:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010266a:	c3                   	ret    
8010266b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010266f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102670:	c3                   	ret    
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102678:	55                   	push   %ebp
80102679:	89 e5                	mov    %esp,%ebp
8010267b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010267e:	68 40 26 11 80       	push   $0x80112640
80102683:	e8 68 22 00 00       	call   801048f0 <acquire>
  r = kmem.freelist;
80102688:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
8010268d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	85 c0                	test   %eax,%eax
80102698:	74 08                	je     801026a2 <kalloc+0x52>
    kmem.freelist = r->next;
8010269a:	8b 08                	mov    (%eax),%ecx
8010269c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026a2:	85 d2                	test   %edx,%edx
801026a4:	74 16                	je     801026bc <kalloc+0x6c>
    release(&kmem.lock);
801026a6:	83 ec 0c             	sub    $0xc,%esp
801026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ac:	68 40 26 11 80       	push   $0x80112640
801026b1:	e8 da 21 00 00       	call   80104890 <release>
  return (char*)r;
801026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026b9:	83 c4 10             	add    $0x10,%esp
}
801026bc:	c9                   	leave  
801026bd:	c3                   	ret    
801026be:	66 90                	xchg   %ax,%ax

801026c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c0:	ba 64 00 00 00       	mov    $0x64,%edx
801026c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026c6:	a8 01                	test   $0x1,%al
801026c8:	0f 84 c2 00 00 00    	je     80102790 <kbdgetc+0xd0>
{
801026ce:	55                   	push   %ebp
801026cf:	ba 60 00 00 00       	mov    $0x60,%edx
801026d4:	89 e5                	mov    %esp,%ebp
801026d6:	53                   	push   %ebx
801026d7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026d8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
801026de:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801026e1:	3c e0                	cmp    $0xe0,%al
801026e3:	74 5b                	je     80102740 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801026e5:	89 da                	mov    %ebx,%edx
801026e7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801026ea:	84 c0                	test   %al,%al
801026ec:	78 62                	js     80102750 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026ee:	85 d2                	test   %edx,%edx
801026f0:	74 09                	je     801026fb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026f2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026f5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026f8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801026fb:	0f b6 91 60 79 10 80 	movzbl -0x7fef86a0(%ecx),%edx
  shift ^= togglecode[data];
80102702:	0f b6 81 60 78 10 80 	movzbl -0x7fef87a0(%ecx),%eax
  shift |= shiftcode[data];
80102709:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010270b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010270f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102715:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102718:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010271b:	8b 04 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%eax
80102722:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102726:	74 0b                	je     80102733 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102728:	8d 50 9f             	lea    -0x61(%eax),%edx
8010272b:	83 fa 19             	cmp    $0x19,%edx
8010272e:	77 48                	ja     80102778 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102730:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102736:	c9                   	leave  
80102737:	c3                   	ret    
80102738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273f:	90                   	nop
    shift |= E0ESC;
80102740:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102743:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102745:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010274b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010274e:	c9                   	leave  
8010274f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102750:	83 e0 7f             	and    $0x7f,%eax
80102753:	85 d2                	test   %edx,%edx
80102755:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102758:	0f b6 81 60 79 10 80 	movzbl -0x7fef86a0(%ecx),%eax
8010275f:	83 c8 40             	or     $0x40,%eax
80102762:	0f b6 c0             	movzbl %al,%eax
80102765:	f7 d0                	not    %eax
80102767:	21 d8                	and    %ebx,%eax
}
80102769:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010276c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102771:	31 c0                	xor    %eax,%eax
}
80102773:	c9                   	leave  
80102774:	c3                   	ret    
80102775:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102778:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010277b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010277e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102781:	c9                   	leave  
      c += 'a' - 'A';
80102782:	83 f9 1a             	cmp    $0x1a,%ecx
80102785:	0f 42 c2             	cmovb  %edx,%eax
}
80102788:	c3                   	ret    
80102789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102795:	c3                   	ret    
80102796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <kbdintr>:

void
kbdintr(void)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027a6:	68 c0 26 10 80       	push   $0x801026c0
801027ab:	e8 a0 e0 ff ff       	call   80100850 <consoleintr>
}
801027b0:	83 c4 10             	add    $0x10,%esp
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	66 90                	xchg   %ax,%ax
801027b7:	66 90                	xchg   %ax,%ax
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027c0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027c5:	85 c0                	test   %eax,%eax
801027c7:	0f 84 cb 00 00 00    	je     80102898 <lapicinit+0xd8>
  lapic[index] = value;
801027cd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027d4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027da:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027ee:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027fb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102808:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102815:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102818:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010281b:	8b 50 30             	mov    0x30(%eax),%edx
8010281e:	c1 ea 10             	shr    $0x10,%edx
80102821:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102827:	75 77                	jne    801028a0 <lapicinit+0xe0>
  lapic[index] = value;
80102829:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102830:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102833:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102836:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102840:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102843:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010284a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102850:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102857:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102864:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102871:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
80102877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102880:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102886:	80 e6 10             	and    $0x10,%dh
80102889:	75 f5                	jne    80102880 <lapicinit+0xc0>
  lapic[index] = value;
8010288b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102892:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102895:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102898:	c3                   	ret    
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ad:	e9 77 ff ff ff       	jmp    80102829 <lapicinit+0x69>
801028b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028c0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028c0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	74 07                	je     801028d0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028c9:	8b 40 20             	mov    0x20(%eax),%eax
801028cc:	c1 e8 18             	shr    $0x18,%eax
801028cf:	c3                   	ret    
    return 0;
801028d0:	31 c0                	xor    %eax,%eax
}
801028d2:	c3                   	ret    
801028d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028e0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028e5:	85 c0                	test   %eax,%eax
801028e7:	74 0d                	je     801028f6 <lapiceoi+0x16>
  lapic[index] = value;
801028e9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028f6:	c3                   	ret    
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax

80102900 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102900:	c3                   	ret    
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102910:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102911:	b8 0f 00 00 00       	mov    $0xf,%eax
80102916:	ba 70 00 00 00       	mov    $0x70,%edx
8010291b:	89 e5                	mov    %esp,%ebp
8010291d:	53                   	push   %ebx
8010291e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102921:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102924:	ee                   	out    %al,(%dx)
80102925:	b8 0a 00 00 00       	mov    $0xa,%eax
8010292a:	ba 71 00 00 00       	mov    $0x71,%edx
8010292f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102930:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102932:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102935:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010293b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010293d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102940:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102942:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102945:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102948:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010294e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102953:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102959:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102963:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102966:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102969:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102970:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102976:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102985:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102988:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102991:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102997:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010299a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010299d:	c9                   	leave  
8010299e:	c3                   	ret    
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	55                   	push   %ebp
801029a1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029a6:	ba 70 00 00 00       	mov    $0x70,%edx
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	57                   	push   %edi
801029ae:	56                   	push   %esi
801029af:	53                   	push   %ebx
801029b0:	83 ec 4c             	sub    $0x4c,%esp
801029b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b4:	ba 71 00 00 00       	mov    $0x71,%edx
801029b9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ba:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029bd:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c5:	8d 76 00             	lea    0x0(%esi),%esi
801029c8:	31 c0                	xor    %eax,%eax
801029ca:	89 da                	mov    %ebx,%edx
801029cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029d2:	89 ca                	mov    %ecx,%edx
801029d4:	ec                   	in     (%dx),%al
801029d5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d8:	89 da                	mov    %ebx,%edx
801029da:	b8 02 00 00 00       	mov    $0x2,%eax
801029df:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e0:	89 ca                	mov    %ecx,%edx
801029e2:	ec                   	in     (%dx),%al
801029e3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e6:	89 da                	mov    %ebx,%edx
801029e8:	b8 04 00 00 00       	mov    $0x4,%eax
801029ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ee:	89 ca                	mov    %ecx,%edx
801029f0:	ec                   	in     (%dx),%al
801029f1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f4:	89 da                	mov    %ebx,%edx
801029f6:	b8 07 00 00 00       	mov    $0x7,%eax
801029fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fc:	89 ca                	mov    %ecx,%edx
801029fe:	ec                   	in     (%dx),%al
801029ff:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a02:	89 da                	mov    %ebx,%edx
80102a04:	b8 08 00 00 00       	mov    $0x8,%eax
80102a09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0a:	89 ca                	mov    %ecx,%edx
80102a0c:	ec                   	in     (%dx),%al
80102a0d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0f:	89 da                	mov    %ebx,%edx
80102a11:	b8 09 00 00 00       	mov    $0x9,%eax
80102a16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a17:	89 ca                	mov    %ecx,%edx
80102a19:	ec                   	in     (%dx),%al
80102a1a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1c:	89 da                	mov    %ebx,%edx
80102a1e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a24:	89 ca                	mov    %ecx,%edx
80102a26:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a27:	84 c0                	test   %al,%al
80102a29:	78 9d                	js     801029c8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a2b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a2f:	89 fa                	mov    %edi,%edx
80102a31:	0f b6 fa             	movzbl %dl,%edi
80102a34:	89 f2                	mov    %esi,%edx
80102a36:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a39:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a3d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a40:	89 da                	mov    %ebx,%edx
80102a42:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a45:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a48:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a4c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a4f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a52:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a56:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a59:	31 c0                	xor    %eax,%eax
80102a5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5c:	89 ca                	mov    %ecx,%edx
80102a5e:	ec                   	in     (%dx),%al
80102a5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a62:	89 da                	mov    %ebx,%edx
80102a64:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a67:	b8 02 00 00 00       	mov    $0x2,%eax
80102a6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6d:	89 ca                	mov    %ecx,%edx
80102a6f:	ec                   	in     (%dx),%al
80102a70:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a73:	89 da                	mov    %ebx,%edx
80102a75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a78:	b8 04 00 00 00       	mov    $0x4,%eax
80102a7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7e:	89 ca                	mov    %ecx,%edx
80102a80:	ec                   	in     (%dx),%al
80102a81:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a84:	89 da                	mov    %ebx,%edx
80102a86:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a89:	b8 07 00 00 00       	mov    $0x7,%eax
80102a8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8f:	89 ca                	mov    %ecx,%edx
80102a91:	ec                   	in     (%dx),%al
80102a92:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a95:	89 da                	mov    %ebx,%edx
80102a97:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a9a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa0:	89 ca                	mov    %ecx,%edx
80102aa2:	ec                   	in     (%dx),%al
80102aa3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa6:	89 da                	mov    %ebx,%edx
80102aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aab:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab1:	89 ca                	mov    %ecx,%edx
80102ab3:	ec                   	in     (%dx),%al
80102ab4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac0:	6a 18                	push   $0x18
80102ac2:	50                   	push   %eax
80102ac3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ac6:	50                   	push   %eax
80102ac7:	e8 34 1f 00 00       	call   80104a00 <memcmp>
80102acc:	83 c4 10             	add    $0x10,%esp
80102acf:	85 c0                	test   %eax,%eax
80102ad1:	0f 85 f1 fe ff ff    	jne    801029c8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ad7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102adb:	75 78                	jne    80102b55 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102add:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae0:	89 c2                	mov    %eax,%edx
80102ae2:	83 e0 0f             	and    $0xf,%eax
80102ae5:	c1 ea 04             	shr    $0x4,%edx
80102ae8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aeb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aee:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102af4:	89 c2                	mov    %eax,%edx
80102af6:	83 e0 0f             	and    $0xf,%eax
80102af9:	c1 ea 04             	shr    $0x4,%edx
80102afc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b02:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b05:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b08:	89 c2                	mov    %eax,%edx
80102b0a:	83 e0 0f             	and    $0xf,%eax
80102b0d:	c1 ea 04             	shr    $0x4,%edx
80102b10:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b13:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b16:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b1c:	89 c2                	mov    %eax,%edx
80102b1e:	83 e0 0f             	and    $0xf,%eax
80102b21:	c1 ea 04             	shr    $0x4,%edx
80102b24:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b27:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b30:	89 c2                	mov    %eax,%edx
80102b32:	83 e0 0f             	and    $0xf,%eax
80102b35:	c1 ea 04             	shr    $0x4,%edx
80102b38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b41:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b44:	89 c2                	mov    %eax,%edx
80102b46:	83 e0 0f             	and    $0xf,%eax
80102b49:	c1 ea 04             	shr    $0x4,%edx
80102b4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b52:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b55:	8b 75 08             	mov    0x8(%ebp),%esi
80102b58:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b5b:	89 06                	mov    %eax,(%esi)
80102b5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b60:	89 46 04             	mov    %eax,0x4(%esi)
80102b63:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b66:	89 46 08             	mov    %eax,0x8(%esi)
80102b69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b6c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b72:	89 46 10             	mov    %eax,0x10(%esi)
80102b75:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b78:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b7b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b85:	5b                   	pop    %ebx
80102b86:	5e                   	pop    %esi
80102b87:	5f                   	pop    %edi
80102b88:	5d                   	pop    %ebp
80102b89:	c3                   	ret    
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 e4 26 11 80    	push   0x801126e4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102bd4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 57 1e 00 00       	call   80104a50 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 d4 26 11 80    	push   0x801126d4
80102c3d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 2c             	sub    $0x2c,%esp
80102c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9a:	68 60 7a 10 80       	push   $0x80107a60
80102c9f:	68 a0 26 11 80       	push   $0x801126a0
80102ca4:	e8 77 1a 00 00       	call   80104720 <initlock>
  readsb(dev, &sb);
80102ca9:	58                   	pop    %eax
80102caa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cad:	5a                   	pop    %edx
80102cae:	50                   	push   %eax
80102caf:	53                   	push   %ebx
80102cb0:	e8 3b e8 ff ff       	call   801014f0 <readsb>
  log.start = sb.logstart;
80102cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cb8:	59                   	pop    %ecx
  log.dev = dev;
80102cb9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cc7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102ccd:	5a                   	pop    %edx
80102cce:	50                   	push   %eax
80102ccf:	53                   	push   %ebx
80102cd0:	e8 fb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cd8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102cdb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102ce1:	85 db                	test   %ebx,%ebx
80102ce3:	7e 1d                	jle    80102d02 <initlog+0x72>
80102ce5:	31 d2                	xor    %edx,%edx
80102ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cee:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102cf4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d3                	cmp    %edx,%ebx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d36:	68 a0 26 11 80       	push   $0x801126a0
80102d3b:	e8 b0 1b 00 00       	call   801048f0 <acquire>
80102d40:	83 c4 10             	add    $0x10,%esp
80102d43:	eb 18                	jmp    80102d5d <begin_op+0x2d>
80102d45:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d48:	83 ec 08             	sub    $0x8,%esp
80102d4b:	68 a0 26 11 80       	push   $0x801126a0
80102d50:	68 a0 26 11 80       	push   $0x801126a0
80102d55:	e8 46 14 00 00       	call   801041a0 <sleep>
80102d5a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d5d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d62:	85 c0                	test   %eax,%eax
80102d64:	75 e2                	jne    80102d48 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d66:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d6b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d71:	83 c0 01             	add    $0x1,%eax
80102d74:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d77:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d7a:	83 fa 1e             	cmp    $0x1e,%edx
80102d7d:	7f c9                	jg     80102d48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d7f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d82:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102d87:	68 a0 26 11 80       	push   $0x801126a0
80102d8c:	e8 ff 1a 00 00       	call   80104890 <release>
      break;
    }
  }
}
80102d91:	83 c4 10             	add    $0x10,%esp
80102d94:	c9                   	leave  
80102d95:	c3                   	ret    
80102d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9d:	8d 76 00             	lea    0x0(%esi),%esi

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	57                   	push   %edi
80102da4:	56                   	push   %esi
80102da5:	53                   	push   %ebx
80102da6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102da9:	68 a0 26 11 80       	push   $0x801126a0
80102dae:	e8 3d 1b 00 00       	call   801048f0 <acquire>
  log.outstanding -= 1;
80102db3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102db8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dbe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dca:	85 f6                	test   %esi,%esi
80102dcc:	0f 85 22 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd2:	85 db                	test   %ebx,%ebx
80102dd4:	0f 85 f6 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dda:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102de1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de4:	83 ec 0c             	sub    $0xc,%esp
80102de7:	68 a0 26 11 80       	push   $0x801126a0
80102dec:	e8 9f 1a 00 00       	call   80104890 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102df7:	83 c4 10             	add    $0x10,%esp
80102dfa:	85 c9                	test   %ecx,%ecx
80102dfc:	7f 42                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102dfe:	83 ec 0c             	sub    $0xc,%esp
80102e01:	68 a0 26 11 80       	push   $0x801126a0
80102e06:	e8 e5 1a 00 00       	call   801048f0 <acquire>
    wakeup(&log);
80102e0b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e12:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e19:	00 00 00 
    wakeup(&log);
80102e1c:	e8 3f 14 00 00       	call   80104260 <wakeup>
    release(&log.lock);
80102e21:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e28:	e8 63 1a 00 00       	call   80104890 <release>
80102e2d:	83 c4 10             	add    $0x10,%esp
}
80102e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e33:	5b                   	pop    %ebx
80102e34:	5e                   	pop    %esi
80102e35:	5f                   	pop    %edi
80102e36:	5d                   	pop    %ebp
80102e37:	c3                   	ret    
80102e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e64:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 c7 1b 00 00       	call   80104a50 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 34 ff ff ff       	jmp    80102dfe <end_op+0x5e>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 a0 26 11 80       	push   $0x801126a0
80102ed8:	e8 83 13 00 00       	call   80104260 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ee4:	e8 a7 19 00 00       	call   80104890 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 64 7a 10 80       	push   $0x80107a64
80102efc:	e8 7f d4 ff ff       	call   80100380 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f17:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f20:	83 fa 1d             	cmp    $0x1d,%edx
80102f23:	0f 8f 85 00 00 00    	jg     80102fae <log_write+0x9e>
80102f29:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f2e:	83 e8 01             	sub    $0x1,%eax
80102f31:	39 c2                	cmp    %eax,%edx
80102f33:	7d 79                	jge    80102fae <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f35:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f3a:	85 c0                	test   %eax,%eax
80102f3c:	7e 7d                	jle    80102fbb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	68 a0 26 11 80       	push   $0x801126a0
80102f46:	e8 a5 19 00 00       	call   801048f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f4b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	85 d2                	test   %edx,%edx
80102f56:	7e 4a                	jle    80102fa2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f58:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f5b:	31 c0                	xor    %eax,%eax
80102f5d:	eb 08                	jmp    80102f67 <log_write+0x57>
80102f5f:	90                   	nop
80102f60:	83 c0 01             	add    $0x1,%eax
80102f63:	39 c2                	cmp    %eax,%edx
80102f65:	74 29                	je     80102f90 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f67:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f6e:	75 f0                	jne    80102f60 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f70:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f77:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f7d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102f84:	c9                   	leave  
  release(&log.lock);
80102f85:	e9 06 19 00 00       	jmp    80104890 <release>
80102f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102f97:	83 c2 01             	add    $0x1,%edx
80102f9a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fa0:	eb d5                	jmp    80102f77 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fa2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fa5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102faa:	75 cb                	jne    80102f77 <log_write+0x67>
80102fac:	eb e9                	jmp    80102f97 <log_write+0x87>
    panic("too big a transaction");
80102fae:	83 ec 0c             	sub    $0xc,%esp
80102fb1:	68 73 7a 10 80       	push   $0x80107a73
80102fb6:	e8 c5 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fbb:	83 ec 0c             	sub    $0xc,%esp
80102fbe:	68 89 7a 10 80       	push   $0x80107a89
80102fc3:	e8 b8 d3 ff ff       	call   80100380 <panic>
80102fc8:	66 90                	xchg   %ax,%ax
80102fca:	66 90                	xchg   %ax,%ax
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 84 09 00 00       	call   80103960 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 7d 09 00 00       	call   80103960 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 a4 7a 10 80       	push   $0x80107aa4
80102fed:	e8 ae d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 b9 2c 00 00       	call   80105cb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 04 09 00 00       	call   80103900 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 41 0c 00 00       	call   80103c50 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 85 3d 00 00       	call   80106da0 <switchkvm>
  seginit();
8010301b:	e8 f0 3c 00 00       	call   80106d10 <seginit>
  lapicinit();
80103020:	e8 9b f7 ff ff       	call   801027c0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 d0 6e 11 80       	push   $0x80116ed0
8010304c:	e8 8f f5 ff ff       	call   801025e0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 3a 42 00 00       	call   80107290 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 60 f7 ff ff       	call   801027c0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 ab 3c 00 00       	call   80106d10 <seginit>
  picinit();       // disable pic
80103065:	e8 76 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 31 f3 ff ff       	call   801023a0 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 bc d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103074:	e8 27 2f 00 00       	call   80105fa0 <uartinit>
  pinit();         // process table
80103079:	e8 62 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 ad 2b 00 00       	call   80105c30 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 53 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
8010308d:	e8 fe f0 ff ff       	call   80102190 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c b4 10 80       	push   $0x8010b48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 a7 19 00 00       	call   80104a50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030bb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 12 08 00 00       	call   80103900 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 59 f5 ff ff       	call   80102650 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010310b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 ea f7 ff ff       	call   80102910 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 2e f4 ff ff       	call   80102580 <kinit2>
  userinit();      // first user process
80103152:	e8 59 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 fb                	cmp    %edi,%ebx
80103184:	76 42                	jbe    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 b8 7a 10 80       	push   $0x80107ab8
80103193:	56                   	push   %esi
80103194:	e8 67 18 00 00       	call   80104a00 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret    
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c3                	mov    %eax,%ebx
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 40 01 00 00    	je     80103370 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 73 04             	mov    0x4(%ebx),%esi
80103233:	85 f6                	test   %esi,%esi
80103235:	0f 84 25 01 00 00    	je     80103360 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103244:	6a 04                	push   $0x4
80103246:	68 bd 7a 10 80       	push   $0x80107abd
8010324b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010324c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	e8 ac 17 00 00       	call   80104a00 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 01 01 00 00    	jne    80103360 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	74 08                	je     80103272 <mpinit+0x92>
8010326a:	3c 04                	cmp    $0x4,%al
8010326c:	0f 85 ee 00 00 00    	jne    80103360 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103272:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103279:	66 85 d2             	test   %dx,%dx
8010327c:	74 22                	je     801032a0 <mpinit+0xc0>
8010327e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103281:	89 f0                	mov    %esi,%eax
  sum = 0;
80103283:	31 d2                	xor    %edx,%edx
80103285:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010328f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103292:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103294:	39 c7                	cmp    %eax,%edi
80103296:	75 f0                	jne    80103288 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103298:	84 d2                	test   %dl,%dl
8010329a:	0f 85 c0 00 00 00    	jne    80103360 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032a6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ab:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032b2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032b8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bd:	03 55 e4             	add    -0x1c(%ebp),%edx
801032c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032c7:	90                   	nop
801032c8:	39 d0                	cmp    %edx,%eax
801032ca:	73 15                	jae    801032e1 <mpinit+0x101>
    switch(*p){
801032cc:	0f b6 08             	movzbl (%eax),%ecx
801032cf:	80 f9 02             	cmp    $0x2,%cl
801032d2:	74 4c                	je     80103320 <mpinit+0x140>
801032d4:	77 3a                	ja     80103310 <mpinit+0x130>
801032d6:	84 c9                	test   %cl,%cl
801032d8:	74 56                	je     80103330 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032da:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032dd:	39 d0                	cmp    %edx,%eax
801032df:	72 eb                	jb     801032cc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032e4:	85 f6                	test   %esi,%esi
801032e6:	0f 84 d9 00 00 00    	je     801033c5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ec:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032f0:	74 15                	je     80103307 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f2:	b8 70 00 00 00       	mov    $0x70,%eax
801032f7:	ba 22 00 00 00       	mov    $0x22,%edx
801032fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032fd:	ba 23 00 00 00       	mov    $0x23,%edx
80103302:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103303:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103306:	ee                   	out    %al,(%dx)
  }
}
80103307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330a:	5b                   	pop    %ebx
8010330b:	5e                   	pop    %esi
8010330c:	5f                   	pop    %edi
8010330d:	5d                   	pop    %ebp
8010330e:	c3                   	ret    
8010330f:	90                   	nop
    switch(*p){
80103310:	83 e9 03             	sub    $0x3,%ecx
80103313:	80 f9 01             	cmp    $0x1,%cl
80103316:	76 c2                	jbe    801032da <mpinit+0xfa>
80103318:	31 f6                	xor    %esi,%esi
8010331a:	eb ac                	jmp    801032c8 <mpinit+0xe8>
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103320:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103324:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103327:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010332d:	eb 99                	jmp    801032c8 <mpinit+0xe8>
8010332f:	90                   	nop
      if(ncpu < NCPU) {
80103330:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103336:	83 f9 07             	cmp    $0x7,%ecx
80103339:	7f 19                	jg     80103354 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010333b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103341:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103345:	83 c1 01             	add    $0x1,%ecx
80103348:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010334e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103354:	83 c0 14             	add    $0x14,%eax
      continue;
80103357:	e9 6c ff ff ff       	jmp    801032c8 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	68 c2 7a 10 80       	push   $0x80107ac2
80103368:	e8 13 d0 ff ff       	call   80100380 <panic>
8010336d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103370:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103375:	eb 13                	jmp    8010338a <mpinit+0x1aa>
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103380:	89 f3                	mov    %esi,%ebx
80103382:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103388:	74 d6                	je     80103360 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010338a:	83 ec 04             	sub    $0x4,%esp
8010338d:	8d 73 10             	lea    0x10(%ebx),%esi
80103390:	6a 04                	push   $0x4
80103392:	68 b8 7a 10 80       	push   $0x80107ab8
80103397:	53                   	push   %ebx
80103398:	e8 63 16 00 00       	call   80104a00 <memcmp>
8010339d:	83 c4 10             	add    $0x10,%esp
801033a0:	85 c0                	test   %eax,%eax
801033a2:	75 dc                	jne    80103380 <mpinit+0x1a0>
801033a4:	89 da                	mov    %ebx,%edx
801033a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033b8:	39 d6                	cmp    %edx,%esi
801033ba:	75 f4                	jne    801033b0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033bc:	84 c0                	test   %al,%al
801033be:	75 c0                	jne    80103380 <mpinit+0x1a0>
801033c0:	e9 6b fe ff ff       	jmp    80103230 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033c5:	83 ec 0c             	sub    $0xc,%esp
801033c8:	68 dc 7a 10 80       	push   $0x80107adc
801033cd:	e8 ae cf ff ff       	call   80100380 <panic>
801033d2:	66 90                	xchg   %ax,%ax
801033d4:	66 90                	xchg   %ax,%ax
801033d6:	66 90                	xchg   %ax,%ax
801033d8:	66 90                	xchg   %ax,%ax
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
801033e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e5:	ba 21 00 00 00       	mov    $0x21,%edx
801033ea:	ee                   	out    %al,(%dx)
801033eb:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f1:	c3                   	ret    
801033f2:	66 90                	xchg   %ax,%ax
801033f4:	66 90                	xchg   %ax,%ax
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 0c             	sub    $0xc,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010340c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010340f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103415:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341b:	e8 e0 d9 ff ff       	call   80100e00 <filealloc>
80103420:	89 03                	mov    %eax,(%ebx)
80103422:	85 c0                	test   %eax,%eax
80103424:	0f 84 a8 00 00 00    	je     801034d2 <pipealloc+0xd2>
8010342a:	e8 d1 d9 ff ff       	call   80100e00 <filealloc>
8010342f:	89 06                	mov    %eax,(%esi)
80103431:	85 c0                	test   %eax,%eax
80103433:	0f 84 87 00 00 00    	je     801034c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103439:	e8 12 f2 ff ff       	call   80102650 <kalloc>
8010343e:	89 c7                	mov    %eax,%edi
80103440:	85 c0                	test   %eax,%eax
80103442:	0f 84 b0 00 00 00    	je     801034f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103448:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010344f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103452:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103455:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010345c:	00 00 00 
  p->nwrite = 0;
8010345f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103466:	00 00 00 
  p->nread = 0;
80103469:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103470:	00 00 00 
  initlock(&p->lock, "pipe");
80103473:	68 fb 7a 10 80       	push   $0x80107afb
80103478:	50                   	push   %eax
80103479:	e8 a2 12 00 00       	call   80104720 <initlock>
  (*f0)->type = FD_PIPE;
8010347e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103480:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103483:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010348f:	8b 03                	mov    (%ebx),%eax
80103491:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103495:	8b 03                	mov    (%ebx),%eax
80103497:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349a:	8b 06                	mov    (%esi),%eax
8010349c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034a8:	8b 06                	mov    (%esi),%eax
801034aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ae:	8b 06                	mov    (%esi),%eax
801034b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034b6:	31 c0                	xor    %eax,%eax
}
801034b8:	5b                   	pop    %ebx
801034b9:	5e                   	pop    %esi
801034ba:	5f                   	pop    %edi
801034bb:	5d                   	pop    %ebp
801034bc:	c3                   	ret    
801034bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034c0:	8b 03                	mov    (%ebx),%eax
801034c2:	85 c0                	test   %eax,%eax
801034c4:	74 1e                	je     801034e4 <pipealloc+0xe4>
    fileclose(*f0);
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	50                   	push   %eax
801034ca:	e8 f1 d9 ff ff       	call   80100ec0 <fileclose>
801034cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	85 c0                	test   %eax,%eax
801034d6:	74 0c                	je     801034e4 <pipealloc+0xe4>
    fileclose(*f1);
801034d8:	83 ec 0c             	sub    $0xc,%esp
801034db:	50                   	push   %eax
801034dc:	e8 df d9 ff ff       	call   80100ec0 <fileclose>
801034e1:	83 c4 10             	add    $0x10,%esp
}
801034e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034ec:	5b                   	pop    %ebx
801034ed:	5e                   	pop    %esi
801034ee:	5f                   	pop    %edi
801034ef:	5d                   	pop    %ebp
801034f0:	c3                   	ret    
801034f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f8:	8b 03                	mov    (%ebx),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 c8                	jne    801034c6 <pipealloc+0xc6>
801034fe:	eb d2                	jmp    801034d2 <pipealloc+0xd2>

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 dc 13 00 00       	call   801048f0 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 65                	je     80103580 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 2c 0d 00 00       	call   80104260 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 15                	je     80103560 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 37 13 00 00       	jmp    80104890 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 27 13 00 00       	call   80104890 <release>
    kfree((char*)p);
80103569:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010356c:	83 c4 10             	add    $0x10,%esp
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    kfree((char*)p);
80103575:	e9 16 ef ff ff       	jmp    80102490 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 c7 0c 00 00       	call   80104260 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb 99                	jmp    80103537 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ac:	53                   	push   %ebx
801035ad:	e8 3e 13 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++){
801035b2:	8b 45 10             	mov    0x10(%ebp),%eax
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 c0                	test   %eax,%eax
801035ba:	0f 8e c0 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d2:	03 45 10             	add    0x10(%ebp),%eax
801035d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035d8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035de:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e4:	89 ca                	mov    %ecx,%edx
801035e6:	05 00 02 00 00       	add    $0x200,%eax
801035eb:	39 c1                	cmp    %eax,%ecx
801035ed:	74 3f                	je     8010362e <pipewrite+0x8e>
801035ef:	eb 67                	jmp    80103658 <pipewrite+0xb8>
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 83 03 00 00       	call   80103980 <myproc>
801035fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 53 0c 00 00       	call   80104260 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 8a 0b 00 00       	call   801041a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 4f 12 00 00       	call   80104890 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 58 ff ff ff    	jne    801035d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 d1 0b 00 00       	call   80104260 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 f9 11 00 00       	call   80104890 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 18             	sub    $0x18,%esp
801036a9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036af:	56                   	push   %esi
801036b0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036b6:	e8 35 12 00 00       	call   801048f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c1:	83 c4 10             	add    $0x10,%esp
801036c4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ca:	74 2f                	je     801036fb <piperead+0x5b>
801036cc:	eb 37                	jmp    80103705 <piperead+0x65>
801036ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801036d0:	e8 ab 02 00 00       	call   80103980 <myproc>
801036d5:	8b 48 24             	mov    0x24(%eax),%ecx
801036d8:	85 c9                	test   %ecx,%ecx
801036da:	0f 85 80 00 00 00    	jne    80103760 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e0:	83 ec 08             	sub    $0x8,%esp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	e8 b6 0a 00 00       	call   801041a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ea:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f0:	83 c4 10             	add    $0x10,%esp
801036f3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801036f9:	75 0a                	jne    80103705 <piperead+0x65>
801036fb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103701:	85 c0                	test   %eax,%eax
80103703:	75 cb                	jne    801036d0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103705:	8b 55 10             	mov    0x10(%ebp),%edx
80103708:	31 db                	xor    %ebx,%ebx
8010370a:	85 d2                	test   %edx,%edx
8010370c:	7f 20                	jg     8010372e <piperead+0x8e>
8010370e:	eb 2c                	jmp    8010373c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103710:	8d 48 01             	lea    0x1(%eax),%ecx
80103713:	25 ff 01 00 00       	and    $0x1ff,%eax
80103718:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010371e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103723:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103726:	83 c3 01             	add    $0x1,%ebx
80103729:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010372c:	74 0e                	je     8010373c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010372e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103734:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010373a:	75 d4                	jne    80103710 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010373c:	83 ec 0c             	sub    $0xc,%esp
8010373f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103745:	50                   	push   %eax
80103746:	e8 15 0b 00 00       	call   80104260 <wakeup>
  release(&p->lock);
8010374b:	89 34 24             	mov    %esi,(%esp)
8010374e:	e8 3d 11 00 00       	call   80104890 <release>
  return i;
80103753:	83 c4 10             	add    $0x10,%esp
}
80103756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103759:	89 d8                	mov    %ebx,%eax
8010375b:	5b                   	pop    %ebx
8010375c:	5e                   	pop    %esi
8010375d:	5f                   	pop    %edi
8010375e:	5d                   	pop    %ebp
8010375f:	c3                   	ret    
      release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103763:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103768:	56                   	push   %esi
80103769:	e8 22 11 00 00       	call   80104890 <release>
      return -1;
8010376e:	83 c4 10             	add    $0x10,%esp
}
80103771:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103774:	89 d8                	mov    %ebx,%eax
80103776:	5b                   	pop    %ebx
80103777:	5e                   	pop    %esi
80103778:	5f                   	pop    %edi
80103779:	5d                   	pop    %ebp
8010377a:	c3                   	ret    
8010377b:	66 90                	xchg   %ax,%ax
8010377d:	66 90                	xchg   %ax,%ax
8010377f:	90                   	nop

80103780 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103784:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103789:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010378c:	68 20 2d 11 80       	push   $0x80112d20
80103791:	e8 5a 11 00 00       	call   801048f0 <acquire>
80103796:	83 c4 10             	add    $0x10,%esp
80103799:	eb 17                	jmp    801037b2 <allocproc+0x32>
8010379b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801037a6:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801037ac:	0f 84 ae 00 00 00    	je     80103860 <allocproc+0xe0>
    if(p->state == UNUSED)
801037b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037b5:	85 c0                	test   %eax,%eax
801037b7:	75 e7                	jne    801037a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037b9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037be:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037c8:	89 43 10             	mov    %eax,0x10(%ebx)
801037cb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037ce:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037d3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801037d9:	e8 b2 10 00 00       	call   80104890 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037de:	e8 6d ee ff ff       	call   80102650 <kalloc>
801037e3:	83 c4 10             	add    $0x10,%esp
801037e6:	89 43 08             	mov    %eax,0x8(%ebx)
801037e9:	85 c0                	test   %eax,%eax
801037eb:	0f 84 88 00 00 00    	je     80103879 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037f1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037f7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037fa:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037ff:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103802:	c7 40 14 23 5c 10 80 	movl   $0x80105c23,0x14(%eax)
  p->context = (struct context*)sp;
80103809:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010380c:	6a 14                	push   $0x14
8010380e:	6a 00                	push   $0x0
80103810:	50                   	push   %eax
80103811:	e8 9a 11 00 00       	call   801049b0 <memset>
  p->context->eip = (uint)forkret;
80103816:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103819:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)

#ifdef PROC_TIMES
//# error this is a good place to initialize some data members
  cmostime(&p->begin_date);
80103820:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103823:	89 04 24             	mov    %eax,(%esp)
80103826:	e8 75 f1 ff ff       	call   801029a0 <cmostime>
//# error this is a good place to set the default nice value
  p->nice_value = DEFAULT_NICE_VALUE;
#endif // LOTTERY
  
  return p;
}
8010382b:	89 d8                	mov    %ebx,%eax
  return p;
8010382d:	83 c4 10             	add    $0x10,%esp
  p->ticks_begin = 0;
80103830:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103837:	00 00 00 
  p->ticks_total = 0;
8010383a:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103841:	00 00 00 
  p->sched_times = 0;
80103844:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010384b:	00 00 00 
  p->nice_value = DEFAULT_NICE_VALUE;
8010384e:	c7 83 a0 00 00 00 28 	movl   $0x28,0xa0(%ebx)
80103855:	00 00 00 
}
80103858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385b:	c9                   	leave  
8010385c:	c3                   	ret    
8010385d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 20 2d 11 80       	push   $0x80112d20
8010386a:	e8 21 10 00 00       	call   80104890 <release>
}
8010386f:	89 d8                	mov    %ebx,%eax
  return 0;
80103871:	83 c4 10             	add    $0x10,%esp
}
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103880:	31 db                	xor    %ebx,%ebx
}
80103882:	89 d8                	mov    %ebx,%eax
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 20 2d 11 80       	push   $0x80112d20
8010389b:	e8 f0 0f 00 00       	call   80104890 <release>

  if (first) {
801038a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave  
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 6c dc ff ff       	call   80101530 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 c0 f3 ff ff       	call   80102c90 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
801038d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 00 7b 10 80       	push   $0x80107b00
801038eb:	68 20 2d 11 80       	push   $0x80112d20
801038f0:	e8 2b 0e 00 00       	call   80104720 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf  
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 af ef ff ff       	call   801028c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret    
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 07 7b 10 80       	push   $0x80107b07
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 04 7c 10 80       	push   $0x80107c04
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave  
  return mycpu()-cpus;
8010396c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret    
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 14 0e 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 54 0e 00 00       	call   801047f0 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave  
801039a2:	c3                   	ret    
801039a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 c4 fd ff ff       	call   80103780 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 54 56 11 80       	mov    %eax,0x80115654
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 48 38 00 00       	call   80107210 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 b4 10 80       	push   $0x8010b460
801039e0:	50                   	push   %eax
801039e1:	e8 da 34 00 00       	call   80106ec0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 b5 0f 00 00       	call   801049b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 30 7b 10 80       	push   $0x80107b30
80103a54:	50                   	push   %eax
80103a55:	e8 16 11 00 00       	call   80104b70 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 39 7b 10 80 	movl   $0x80107b39,(%esp)
80103a61:	e8 0a e6 ff ff       	call   80102070 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a70:	e8 7b 0e 00 00       	call   801048f0 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a83:	e8 08 0e 00 00       	call   80104890 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 17 7b 10 80       	push   $0x80107b17
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 f3 0c 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 33 0d 00 00       	call   801047f0 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 e0 32 00 00       	call   80106db0 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret    
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 41 35 00 00       	call   80107030 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 51 36 00 00       	call   80107160 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 72 0c 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 b2 0c 00 00       	call   801047f0 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 3d fc ff ff       	call   80103780 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 c6 00 00 00    	je     80103c14 <fork+0xf4>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 a3 37 00 00       	call   80107300 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 b0 00 00 00    	je     80103c1b <fork+0xfb>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b75:	89 c8                	mov    %ecx,%eax
80103b77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 cf d2 ff ff       	call   80100e70 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 5f db ff ff       	call   80101720 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 9a 0f 00 00       	call   80104b70 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be0:	e8 0b 0d 00 00       	call   801048f0 <acquire>
np->nice_value = np->parent->nice_value;
80103be5:	8b 47 14             	mov    0x14(%edi),%eax
  np->state = RUNNABLE;
80103be8:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
np->nice_value = np->parent->nice_value;
80103bef:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103bf5:	89 87 a0 00 00 00    	mov    %eax,0xa0(%edi)
  release(&ptable.lock);
80103bfb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c02:	e8 89 0c 00 00       	call   80104890 <release>
  return pid;
80103c07:	83 c4 10             	add    $0x10,%esp
}
80103c0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0d:	89 d8                	mov    %ebx,%eax
80103c0f:	5b                   	pop    %ebx
80103c10:	5e                   	pop    %esi
80103c11:	5f                   	pop    %edi
80103c12:	5d                   	pop    %ebp
80103c13:	c3                   	ret    
    return -1;
80103c14:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c19:	eb ef                	jmp    80103c0a <fork+0xea>
    kfree(np->kstack);
80103c1b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103c1e:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c21:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103c26:	ff 77 08             	push   0x8(%edi)
80103c29:	e8 62 e8 ff ff       	call   80102490 <kfree>
    np->kstack = 0;
80103c2e:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103c35:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c38:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103c3f:	eb c9                	jmp    80103c0a <fork+0xea>
80103c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4f:	90                   	nop

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103c59:	e8 a2 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c3                	mov    %eax,%ebx
  int check=0;
80103c6a:	8d 40 04             	lea    0x4(%eax),%eax
80103c6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
80103c74:	68 20 2d 11 80       	push   $0x80112d20
80103c79:	e8 72 0c 00 00       	call   801048f0 <acquire>
80103c7e:	83 c4 10             	add    $0x10,%esp
	int total=0;
80103c81:	31 d2                	xor    %edx,%edx
	for(curr=ptable.proc; curr<&ptable.proc[NPROC]; curr++){
80103c83:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
		if(curr->state == RUNNABLE){
80103c90:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103c94:	75 06                	jne    80103c9c <scheduler+0x4c>
			total+=curr->nice_value;
80103c96:	03 90 a0 00 00 00    	add    0xa0(%eax),%edx
	for(curr=ptable.proc; curr<&ptable.proc[NPROC]; curr++){
80103c9c:	05 a4 00 00 00       	add    $0xa4,%eax
80103ca1:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103ca6:	75 e8                	jne    80103c90 <scheduler+0x40>
    if(nice_sum()>0){//NK, runs only if there is a runnable proc
80103ca8:	85 d2                	test   %edx,%edx
80103caa:	0f 8e e1 00 00 00    	jle    80103d91 <scheduler+0x141>
	    rand_num=(rand()%nice_sum())+1;
80103cb0:	e8 1b 09 00 00       	call   801045d0 <rand>
	int total=0;
80103cb5:	31 c9                	xor    %ecx,%ecx
	for(curr=ptable.proc; curr<&ptable.proc[NPROC]; curr++){
80103cb7:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(curr->state == RUNNABLE){
80103cc0:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103cc4:	75 06                	jne    80103ccc <scheduler+0x7c>
			total+=curr->nice_value;
80103cc6:	03 8a a0 00 00 00    	add    0xa0(%edx),%ecx
	for(curr=ptable.proc; curr<&ptable.proc[NPROC]; curr++){
80103ccc:	81 c2 a4 00 00 00    	add    $0xa4,%edx
80103cd2:	81 fa 54 56 11 80    	cmp    $0x80115654,%edx
80103cd8:	75 e6                	jne    80103cc0 <scheduler+0x70>
	    rand_num=(rand()%nice_sum())+1;
80103cda:	99                   	cltd   
	    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cdb:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
	    rand_num=(rand()%nice_sum())+1;
80103ce0:	f7 f9                	idiv   %ecx
    check=0;
80103ce2:	31 c0                	xor    %eax,%eax
	    rand_num=(rand()%nice_sum())+1;
80103ce4:	83 c2 01             	add    $0x1,%edx
	      if(p->state != RUNNABLE){
80103ce7:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103ceb:	0f 85 bf 00 00 00    	jne    80103db0 <scheduler+0x160>
	      if(rand_num > (check+p->nice_value)){
80103cf1:	03 87 a0 00 00 00    	add    0xa0(%edi),%eax
80103cf7:	39 d0                	cmp    %edx,%eax
80103cf9:	0f 82 b1 00 00 00    	jb     80103db0 <scheduler+0x160>
	      switchuvm(p);
80103cff:	83 ec 0c             	sub    $0xc,%esp
	      c->proc = p;
80103d02:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
	      switchuvm(p);
80103d08:	57                   	push   %edi
80103d09:	e8 a2 30 00 00       	call   80106db0 <switchuvm>
  acquire(&tickslock);
80103d0e:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
	      p->state = RUNNING;
80103d15:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
  acquire(&tickslock);
80103d1c:	e8 cf 0b 00 00       	call   801048f0 <acquire>
  release(&tickslock);
80103d21:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
  xticks = ticks;
80103d28:	8b 35 60 56 11 80    	mov    0x80115660,%esi
  release(&tickslock);
80103d2e:	e8 5d 0b 00 00       	call   80104890 <release>
	      swtch(&(c->scheduler), p->context);
80103d33:	58                   	pop    %eax
80103d34:	5a                   	pop    %edx
80103d35:	ff 77 1c             	push   0x1c(%edi)
80103d38:	ff 75 e4             	push   -0x1c(%ebp)
		p->ticks_begin= uptime(); //start
80103d3b:	89 b7 98 00 00 00    	mov    %esi,0x98(%edi)
		p->sched_times++;
80103d41:	83 87 9c 00 00 00 01 	addl   $0x1,0x9c(%edi)
	      swtch(&(c->scheduler), p->context);
80103d48:	e8 7e 0e 00 00       	call   80104bcb <swtch>
	      switchkvm();
80103d4d:	e8 4e 30 00 00       	call   80106da0 <switchkvm>
  acquire(&tickslock);
80103d52:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
80103d59:	e8 92 0b 00 00       	call   801048f0 <acquire>
  release(&tickslock);
80103d5e:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
  xticks = ticks;
80103d65:	8b 35 60 56 11 80    	mov    0x80115660,%esi
  release(&tickslock);
80103d6b:	e8 20 0b 00 00       	call   80104890 <release>
		p->ticks_total+= uptime() - p->ticks_begin;
80103d70:	8b 87 94 00 00 00    	mov    0x94(%edi),%eax
	      break;
80103d76:	83 c4 10             	add    $0x10,%esp
		p->ticks_total+= uptime() - p->ticks_begin;
80103d79:	01 f0                	add    %esi,%eax
80103d7b:	2b 87 98 00 00 00    	sub    0x98(%edi),%eax
80103d81:	89 87 94 00 00 00    	mov    %eax,0x94(%edi)
	      c->proc = 0;
80103d87:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d8e:	00 00 00 
    release(&ptable.lock);
80103d91:	83 ec 0c             	sub    $0xc,%esp
80103d94:	68 20 2d 11 80       	push   $0x80112d20
80103d99:	e8 f2 0a 00 00       	call   80104890 <release>
    sti();
80103d9e:	83 c4 10             	add    $0x10,%esp
80103da1:	e9 ca fe ff ff       	jmp    80103c70 <scheduler+0x20>
80103da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
	    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db0:	81 c7 a4 00 00 00    	add    $0xa4,%edi
80103db6:	81 ff 54 56 11 80    	cmp    $0x80115654,%edi
80103dbc:	0f 85 25 ff ff ff    	jne    80103ce7 <scheduler+0x97>
80103dc2:	eb cd                	jmp    80103d91 <scheduler+0x141>
80103dc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop

80103dd0 <uptime>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 10             	sub    $0x10,%esp
  acquire(&tickslock);
80103dd7:	68 80 56 11 80       	push   $0x80115680
80103ddc:	e8 0f 0b 00 00       	call   801048f0 <acquire>
  xticks = ticks;
80103de1:	8b 1d 60 56 11 80    	mov    0x80115660,%ebx
  release(&tickslock);
80103de7:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
80103dee:	e8 9d 0a 00 00       	call   80104890 <release>
}
80103df3:	89 d8                	mov    %ebx,%eax
80103df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df8:	c9                   	leave  
80103df9:	c3                   	ret    
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e00 <nice_sum>:
	for(curr=ptable.proc; curr<&ptable.proc[NPROC]; curr++){
80103e00:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
	int total=0;
80103e05:	31 d2                	xor    %edx,%edx
80103e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0e:	66 90                	xchg   %ax,%ax
		if(curr->state == RUNNABLE){
80103e10:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e14:	75 06                	jne    80103e1c <nice_sum+0x1c>
			total+=curr->nice_value;
80103e16:	03 90 a0 00 00 00    	add    0xa0(%eax),%edx
	for(curr=ptable.proc; curr<&ptable.proc[NPROC]; curr++){
80103e1c:	05 a4 00 00 00       	add    $0xa4,%eax
80103e21:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103e26:	75 e8                	jne    80103e10 <nice_sum+0x10>
}
80103e28:	89 d0                	mov    %edx,%eax
80103e2a:	c3                   	ret    
80103e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop

80103e30 <sched>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
  pushcli();
80103e35:	e8 66 09 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80103e3a:	e8 c1 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103e3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e45:	e8 a6 09 00 00       	call   801047f0 <popcli>
  if(!holding(&ptable.lock))
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 20 2d 11 80       	push   $0x80112d20
80103e52:	e8 f9 09 00 00       	call   80104850 <holding>
80103e57:	83 c4 10             	add    $0x10,%esp
80103e5a:	85 c0                	test   %eax,%eax
80103e5c:	74 4f                	je     80103ead <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e5e:	e8 9d fa ff ff       	call   80103900 <mycpu>
80103e63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e6a:	75 68                	jne    80103ed4 <sched+0xa4>
  if(p->state == RUNNING)
80103e6c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e70:	74 55                	je     80103ec7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e72:	9c                   	pushf  
80103e73:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e74:	f6 c4 02             	test   $0x2,%ah
80103e77:	75 41                	jne    80103eba <sched+0x8a>
  intena = mycpu()->intena;
80103e79:	e8 82 fa ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e7e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e87:	e8 74 fa ff ff       	call   80103900 <mycpu>
80103e8c:	83 ec 08             	sub    $0x8,%esp
80103e8f:	ff 70 04             	push   0x4(%eax)
80103e92:	53                   	push   %ebx
80103e93:	e8 33 0d 00 00       	call   80104bcb <swtch>
  mycpu()->intena = intena;
80103e98:	e8 63 fa ff ff       	call   80103900 <mycpu>
}
80103e9d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ea0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ea6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ea9:	5b                   	pop    %ebx
80103eaa:	5e                   	pop    %esi
80103eab:	5d                   	pop    %ebp
80103eac:	c3                   	ret    
    panic("sched ptable.lock");
80103ead:	83 ec 0c             	sub    $0xc,%esp
80103eb0:	68 3b 7b 10 80       	push   $0x80107b3b
80103eb5:	e8 c6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 67 7b 10 80       	push   $0x80107b67
80103ec2:	e8 b9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 59 7b 10 80       	push   $0x80107b59
80103ecf:	e8 ac c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 4d 7b 10 80       	push   $0x80107b4d
80103edc:	e8 9f c4 ff ff       	call   80100380 <panic>
80103ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop

80103ef0 <exit>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ef9:	e8 82 fa ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103efe:	39 05 54 56 11 80    	cmp    %eax,0x80115654
80103f04:	0f 84 07 01 00 00    	je     80104011 <exit+0x121>
80103f0a:	89 c3                	mov    %eax,%ebx
80103f0c:	8d 70 28             	lea    0x28(%eax),%esi
80103f0f:	8d 78 68             	lea    0x68(%eax),%edi
80103f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f18:	8b 06                	mov    (%esi),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 12                	je     80103f30 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	50                   	push   %eax
80103f22:	e8 99 cf ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103f27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f30:	83 c6 04             	add    $0x4,%esi
80103f33:	39 f7                	cmp    %esi,%edi
80103f35:	75 e1                	jne    80103f18 <exit+0x28>
  begin_op();
80103f37:	e8 f4 ed ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
80103f3c:	83 ec 0c             	sub    $0xc,%esp
80103f3f:	ff 73 68             	push   0x68(%ebx)
80103f42:	e8 39 d9 ff ff       	call   80101880 <iput>
  end_op();
80103f47:	e8 54 ee ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
80103f4c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f5a:	e8 91 09 00 00       	call   801048f0 <acquire>
  wakeup1(curproc->parent);
80103f5f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f62:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f65:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f6a:	eb 10                	jmp    80103f7c <exit+0x8c>
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f70:	05 a4 00 00 00       	add    $0xa4,%eax
80103f75:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103f7a:	74 1e                	je     80103f9a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103f7c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f80:	75 ee                	jne    80103f70 <exit+0x80>
80103f82:	3b 50 20             	cmp    0x20(%eax),%edx
80103f85:	75 e9                	jne    80103f70 <exit+0x80>
      p->state = RUNNABLE;
80103f87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f8e:	05 a4 00 00 00       	add    $0xa4,%eax
80103f93:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103f98:	75 e2                	jne    80103f7c <exit+0x8c>
      p->parent = initproc;
80103f9a:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103fa5:	eb 17                	jmp    80103fbe <exit+0xce>
80103fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fae:	66 90                	xchg   %ax,%ax
80103fb0:	81 c2 a4 00 00 00    	add    $0xa4,%edx
80103fb6:	81 fa 54 56 11 80    	cmp    $0x80115654,%edx
80103fbc:	74 3a                	je     80103ff8 <exit+0x108>
    if(p->parent == curproc){
80103fbe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103fc1:	75 ed                	jne    80103fb0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103fc3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fc7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fca:	75 e4                	jne    80103fb0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fcc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fd1:	eb 11                	jmp    80103fe4 <exit+0xf4>
80103fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd7:	90                   	nop
80103fd8:	05 a4 00 00 00       	add    $0xa4,%eax
80103fdd:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103fe2:	74 cc                	je     80103fb0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103fe4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fe8:	75 ee                	jne    80103fd8 <exit+0xe8>
80103fea:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fed:	75 e9                	jne    80103fd8 <exit+0xe8>
      p->state = RUNNABLE;
80103fef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ff6:	eb e0                	jmp    80103fd8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103ff8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fff:	e8 2c fe ff ff       	call   80103e30 <sched>
  panic("zombie exit");
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 88 7b 10 80       	push   $0x80107b88
8010400c:	e8 6f c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104011:	83 ec 0c             	sub    $0xc,%esp
80104014:	68 7b 7b 10 80       	push   $0x80107b7b
80104019:	e8 62 c3 ff ff       	call   80100380 <panic>
8010401e:	66 90                	xchg   %ax,%ax

80104020 <wait>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
  pushcli();
80104025:	e8 76 07 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010402a:	e8 d1 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010402f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104035:	e8 b6 07 00 00       	call   801047f0 <popcli>
  acquire(&ptable.lock);
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 20 2d 11 80       	push   $0x80112d20
80104042:	e8 a9 08 00 00       	call   801048f0 <acquire>
80104047:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010404a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104051:	eb 13                	jmp    80104066 <wait+0x46>
80104053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104057:	90                   	nop
80104058:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
8010405e:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
80104064:	74 1e                	je     80104084 <wait+0x64>
      if(p->parent != curproc)
80104066:	39 73 14             	cmp    %esi,0x14(%ebx)
80104069:	75 ed                	jne    80104058 <wait+0x38>
      if(p->state == ZOMBIE){
8010406b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010406f:	74 5f                	je     801040d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104071:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      havekids = 1;
80104077:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407c:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
80104082:	75 e2                	jne    80104066 <wait+0x46>
    if(!havekids || curproc->killed){
80104084:	85 c0                	test   %eax,%eax
80104086:	0f 84 9a 00 00 00    	je     80104126 <wait+0x106>
8010408c:	8b 46 24             	mov    0x24(%esi),%eax
8010408f:	85 c0                	test   %eax,%eax
80104091:	0f 85 8f 00 00 00    	jne    80104126 <wait+0x106>
  pushcli();
80104097:	e8 04 07 00 00       	call   801047a0 <pushcli>
  c = mycpu();
8010409c:	e8 5f f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801040a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a7:	e8 44 07 00 00       	call   801047f0 <popcli>
  if(p == 0)
801040ac:	85 db                	test   %ebx,%ebx
801040ae:	0f 84 89 00 00 00    	je     8010413d <wait+0x11d>
  p->chan = chan;
801040b4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040b7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040be:	e8 6d fd ff ff       	call   80103e30 <sched>
  p->chan = 0;
801040c3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040ca:	e9 7b ff ff ff       	jmp    8010404a <wait+0x2a>
801040cf:	90                   	nop
        kfree(p->kstack);
801040d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040d3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040d6:	ff 73 08             	push   0x8(%ebx)
801040d9:	e8 b2 e3 ff ff       	call   80102490 <kfree>
        p->kstack = 0;
801040de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040e5:	5a                   	pop    %edx
801040e6:	ff 73 04             	push   0x4(%ebx)
801040e9:	e8 a2 30 00 00       	call   80107190 <freevm>
        p->pid = 0;
801040ee:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040f5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040fc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104100:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104107:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010410e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104115:	e8 76 07 00 00       	call   80104890 <release>
        return pid;
8010411a:	83 c4 10             	add    $0x10,%esp
}
8010411d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104120:	89 f0                	mov    %esi,%eax
80104122:	5b                   	pop    %ebx
80104123:	5e                   	pop    %esi
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret    
      release(&ptable.lock);
80104126:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104129:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010412e:	68 20 2d 11 80       	push   $0x80112d20
80104133:	e8 58 07 00 00       	call   80104890 <release>
      return -1;
80104138:	83 c4 10             	add    $0x10,%esp
8010413b:	eb e0                	jmp    8010411d <wait+0xfd>
    panic("sleep");
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	68 94 7b 10 80       	push   $0x80107b94
80104145:	e8 36 c2 ff ff       	call   80100380 <panic>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <yield>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104157:	68 20 2d 11 80       	push   $0x80112d20
8010415c:	e8 8f 07 00 00       	call   801048f0 <acquire>
  pushcli();
80104161:	e8 3a 06 00 00       	call   801047a0 <pushcli>
  c = mycpu();
80104166:	e8 95 f7 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 7a 06 00 00       	call   801047f0 <popcli>
  myproc()->state = RUNNABLE;
80104176:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010417d:	e8 ae fc ff ff       	call   80103e30 <sched>
  release(&ptable.lock);
80104182:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104189:	e8 02 07 00 00       	call   80104890 <release>
}
8010418e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104191:	83 c4 10             	add    $0x10,%esp
80104194:	c9                   	leave  
80104195:	c3                   	ret    
80104196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419d:	8d 76 00             	lea    0x0(%esi),%esi

801041a0 <sleep>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041af:	e8 ec 05 00 00       	call   801047a0 <pushcli>
  c = mycpu();
801041b4:	e8 47 f7 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801041b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bf:	e8 2c 06 00 00       	call   801047f0 <popcli>
  if(p == 0)
801041c4:	85 db                	test   %ebx,%ebx
801041c6:	0f 84 87 00 00 00    	je     80104253 <sleep+0xb3>
  if(lk == 0)
801041cc:	85 f6                	test   %esi,%esi
801041ce:	74 76                	je     80104246 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801041d6:	74 50                	je     80104228 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 20 2d 11 80       	push   $0x80112d20
801041e0:	e8 0b 07 00 00       	call   801048f0 <acquire>
    release(lk);
801041e5:	89 34 24             	mov    %esi,(%esp)
801041e8:	e8 a3 06 00 00       	call   80104890 <release>
  p->chan = chan;
801041ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f7:	e8 34 fc ff ff       	call   80103e30 <sched>
  p->chan = 0;
801041fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104203:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010420a:	e8 81 06 00 00       	call   80104890 <release>
    acquire(lk);
8010420f:	89 75 08             	mov    %esi,0x8(%ebp)
80104212:	83 c4 10             	add    $0x10,%esp
}
80104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104218:	5b                   	pop    %ebx
80104219:	5e                   	pop    %esi
8010421a:	5f                   	pop    %edi
8010421b:	5d                   	pop    %ebp
    acquire(lk);
8010421c:	e9 cf 06 00 00       	jmp    801048f0 <acquire>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104228:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010422b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104232:	e8 f9 fb ff ff       	call   80103e30 <sched>
  p->chan = 0;
80104237:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010423e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5f                   	pop    %edi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    
    panic("sleep without lk");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 9a 7b 10 80       	push   $0x80107b9a
8010424e:	e8 2d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 94 7b 10 80       	push   $0x80107b94
8010425b:	e8 20 c1 ff ff       	call   80100380 <panic>

80104260 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010426a:	68 20 2d 11 80       	push   $0x80112d20
8010426f:	e8 7c 06 00 00       	call   801048f0 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104277:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010427c:	eb 0e                	jmp    8010428c <wakeup+0x2c>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	05 a4 00 00 00       	add    $0xa4,%eax
80104285:	3d 54 56 11 80       	cmp    $0x80115654,%eax
8010428a:	74 1e                	je     801042aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010428c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104290:	75 ee                	jne    80104280 <wakeup+0x20>
80104292:	3b 58 20             	cmp    0x20(%eax),%ebx
80104295:	75 e9                	jne    80104280 <wakeup+0x20>
      p->state = RUNNABLE;
80104297:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010429e:	05 a4 00 00 00       	add    $0xa4,%eax
801042a3:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801042a8:	75 e2                	jne    8010428c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801042aa:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801042b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b4:	c9                   	leave  
  release(&ptable.lock);
801042b5:	e9 d6 05 00 00       	jmp    80104890 <release>
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 20 2d 11 80       	push   $0x80112d20
801042cf:	e8 1c 06 00 00       	call   801048f0 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042dc:	eb 0e                	jmp    801042ec <kill+0x2c>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	05 a4 00 00 00       	add    $0xa4,%eax
801042e5:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801042ea:	74 34                	je     80104320 <kill+0x60>
    if(p->pid == pid){
801042ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ef:	75 ef                	jne    801042e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042fc:	75 07                	jne    80104305 <kill+0x45>
        p->state = RUNNABLE;
801042fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104305:	83 ec 0c             	sub    $0xc,%esp
80104308:	68 20 2d 11 80       	push   $0x80112d20
8010430d:	e8 7e 05 00 00       	call   80104890 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104315:	83 c4 10             	add    $0x10,%esp
80104318:	31 c0                	xor    %eax,%eax
}
8010431a:	c9                   	leave  
8010431b:	c3                   	ret    
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 20 2d 11 80       	push   $0x80112d20
80104328:	e8 63 05 00 00       	call   80104890 <release>
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104330:	83 c4 10             	add    $0x10,%esp
80104333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104338:	c9                   	leave  
80104339:	c3                   	ret    
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104348:	53                   	push   %ebx
80104349:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010434e:	83 ec 3c             	sub    $0x3c,%esp
80104351:	eb 27                	jmp    8010437a <procdump+0x3a>
80104353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104357:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 a3 7f 10 80       	push   $0x80107fa3
80104360:	e8 3b c3 ff ff       	call   801006a0 <cprintf>
80104365:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104368:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
8010436e:	81 fb c0 56 11 80    	cmp    $0x801156c0,%ebx
80104374:	0f 84 7e 00 00 00    	je     801043f8 <procdump+0xb8>
    if(p->state == UNUSED)
8010437a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010437d:	85 c0                	test   %eax,%eax
8010437f:	74 e7                	je     80104368 <procdump+0x28>
      state = "???";
80104381:	ba ab 7b 10 80       	mov    $0x80107bab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104386:	83 f8 05             	cmp    $0x5,%eax
80104389:	77 11                	ja     8010439c <procdump+0x5c>
8010438b:	8b 14 85 90 7c 10 80 	mov    -0x7fef8370(,%eax,4),%edx
      state = "???";
80104392:	b8 ab 7b 10 80       	mov    $0x80107bab,%eax
80104397:	85 d2                	test   %edx,%edx
80104399:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010439c:	53                   	push   %ebx
8010439d:	52                   	push   %edx
8010439e:	ff 73 a4             	push   -0x5c(%ebx)
801043a1:	68 af 7b 10 80       	push   $0x80107baf
801043a6:	e8 f5 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801043ab:	83 c4 10             	add    $0x10,%esp
801043ae:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043b2:	75 a4                	jne    80104358 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043b4:	83 ec 08             	sub    $0x8,%esp
801043b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043bd:	50                   	push   %eax
801043be:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043c1:	8b 40 0c             	mov    0xc(%eax),%eax
801043c4:	83 c0 08             	add    $0x8,%eax
801043c7:	50                   	push   %eax
801043c8:	e8 73 03 00 00       	call   80104740 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043cd:	83 c4 10             	add    $0x10,%esp
801043d0:	8b 17                	mov    (%edi),%edx
801043d2:	85 d2                	test   %edx,%edx
801043d4:	74 82                	je     80104358 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043dc:	52                   	push   %edx
801043dd:	68 a1 75 10 80       	push   $0x801075a1
801043e2:	e8 b9 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043e7:	83 c4 10             	add    $0x10,%esp
801043ea:	39 fe                	cmp    %edi,%esi
801043ec:	75 e2                	jne    801043d0 <procdump+0x90>
801043ee:	e9 65 ff ff ff       	jmp    80104358 <procdump+0x18>
801043f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f7:	90                   	nop
  }
}
801043f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043fb:	5b                   	pop    %ebx
801043fc:	5e                   	pop    %esi
801043fd:	5f                   	pop    %edi
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret    

80104400 <renice>:

#ifdef LOTTERY
int
renice(int nice_val,int pid){
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	53                   	push   %ebx
80104406:	83 ec 0c             	sub    $0xc,%esp
80104409:	8b 7d 08             	mov    0x8(%ebp),%edi
8010440c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int check=0;
	if(nice_val<MIN_NICE_VALUE || nice_val>MAX_NICE_VALUE){
8010440f:	8d 47 ff             	lea    -0x1(%edi),%eax
80104412:	83 f8 63             	cmp    $0x63,%eax
80104415:	77 63                	ja     8010447a <renice+0x7a>
		cprintf(" Error: Out of bounds\n");
		return 1;
	}
	acquire(&ptable.lock);
80104417:	83 ec 0c             	sub    $0xc,%esp
	int check=0;
8010441a:	31 f6                	xor    %esi,%esi
	acquire(&ptable.lock);
8010441c:	68 20 2d 11 80       	push   $0x80112d20
80104421:	e8 ca 04 00 00       	call   801048f0 <acquire>
	for(int i=0; i<NPROC; i++){
80104426:	b8 60 2d 11 80       	mov    $0x80112d60,%eax
8010442b:	83 c4 10             	add    $0x10,%esp
8010442e:	66 90                	xchg   %ax,%ax
		if(ptable.proc[i].state!=UNUSED){
80104430:	8b 10                	mov    (%eax),%edx
80104432:	85 d2                	test   %edx,%edx
80104434:	74 1a                	je     80104450 <renice+0x50>
			if(ptable.proc[i].pid==pid){
80104436:	39 58 04             	cmp    %ebx,0x4(%eax)
80104439:	75 15                	jne    80104450 <renice+0x50>
				ptable.proc[i].nice_value=nice_val;
8010443b:	89 b8 94 00 00 00    	mov    %edi,0x94(%eax)
				check=1;
80104441:	be 01 00 00 00       	mov    $0x1,%esi
80104446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
	for(int i=0; i<NPROC; i++){
80104450:	05 a4 00 00 00       	add    $0xa4,%eax
80104455:	3d 60 56 11 80       	cmp    $0x80115660,%eax
8010445a:	75 d4                	jne    80104430 <renice+0x30>
			}
		}
	}
	release(&ptable.lock);
8010445c:	83 ec 0c             	sub    $0xc,%esp
8010445f:	68 20 2d 11 80       	push   $0x80112d20
80104464:	e8 27 04 00 00       	call   80104890 <release>
	if(check==0) return 2;//pid doesn't match
80104469:	8d 04 36             	lea    (%esi,%esi,1),%eax
8010446c:	83 c4 10             	add    $0x10,%esp
	return 0; //success
}
8010446f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104472:	5b                   	pop    %ebx
	if(check==0) return 2;//pid doesn't match
80104473:	83 f0 02             	xor    $0x2,%eax
}
80104476:	5e                   	pop    %esi
80104477:	5f                   	pop    %edi
80104478:	5d                   	pop    %ebp
80104479:	c3                   	ret    
		cprintf(" Error: Out of bounds\n");
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	68 b8 7b 10 80       	push   $0x80107bb8
80104482:	e8 19 c2 ff ff       	call   801006a0 <cprintf>
		return 1;
80104487:	83 c4 10             	add    $0x10,%esp
}
8010448a:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return 1;
8010448d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104492:	5b                   	pop    %ebx
80104493:	5e                   	pop    %esi
80104494:	5f                   	pop    %edi
80104495:	5d                   	pop    %ebp
80104496:	c3                   	ret    
80104497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <proc_cps>:
#endif // LOTTERY

#ifdef CPS
int
proc_cps(void)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801044ab:	83 ec 48             	sub    $0x48,%esp
    int i;
    const char *state = 0x0;

    acquire(&ptable.lock);
801044ae:	68 20 2d 11 80       	push   $0x80112d20
801044b3:	e8 38 04 00 00       	call   801048f0 <acquire>

    cprintf(
801044b8:	c7 04 24 2c 7c 10 80 	movl   $0x80107c2c,(%esp)
801044bf:	e8 dc c1 ff ff       	call   801006a0 <cprintf>
        );
#ifdef PROC_TIMES
//# error this is an excellent place to add some new header into to the o/p of cps
   // cprintf("\n");
#endif // PROC_TIMES
    cprintf("\n");
801044c4:	c7 04 24 a3 7f 10 80 	movl   $0x80107fa3,(%esp)
801044cb:	e8 d0 c1 ff ff       	call   801006a0 <cprintf>
    for (i = 0; i < NPROC; i++) {
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d7:	90                   	nop
        if (ptable.proc[i].state != UNUSED) {
801044d8:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044db:	85 c0                	test   %eax,%eax
801044dd:	0f 84 b0 00 00 00    	je     80104593 <proc_cps+0xf3>
            if (ptable.proc[i].state >= 0 && ptable.proc[i].state < NELEM(states)
                && states[ptable.proc[i].state]) {
                state = states[ptable.proc[i].state];
            }
            else {
                state = "uknown";
801044e3:	be cf 7b 10 80       	mov    $0x80107bcf,%esi
            if (ptable.proc[i].state >= 0 && ptable.proc[i].state < NELEM(states)
801044e8:	83 f8 05             	cmp    $0x5,%eax
801044eb:	77 11                	ja     801044fe <proc_cps+0x5e>
                && states[ptable.proc[i].state]) {
801044ed:	8b 34 85 90 7c 10 80 	mov    -0x7fef8370(,%eax,4),%esi
                state = "uknown";
801044f4:	b8 cf 7b 10 80       	mov    $0x80107bcf,%eax
801044f9:	85 f6                	test   %esi,%esi
801044fb:	0f 44 f0             	cmove  %eax,%esi
            }
            cprintf("%d\t%d\t%s\t%s\t%u\t%u-%s%u-%u %u:%u:%u\t%u\t%u\t%u"
801044fe:	8b 43 30             	mov    0x30(%ebx),%eax
80104501:	b9 d6 7b 10 80       	mov    $0x80107bd6,%ecx
80104506:	ba a4 7f 10 80       	mov    $0x80107fa4,%edx
8010450b:	8b 7b 34             	mov    0x34(%ebx),%edi
8010450e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104511:	8b 43 28             	mov    0x28(%ebx),%eax
80104514:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104517:	8b 43 10             	mov    0x10(%ebx),%eax
8010451a:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010451d:	8b 43 14             	mov    0x14(%ebx),%eax
80104520:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104523:	8b 43 18             	mov    0x18(%ebx),%eax
80104526:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104529:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010452c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010452f:	8b 43 20             	mov    0x20(%ebx),%eax
80104532:	83 f8 0a             	cmp    $0xa,%eax
80104535:	0f 42 d1             	cmovb  %ecx,%edx
80104538:	8b 4b 24             	mov    0x24(%ebx),%ecx
8010453b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010453e:	8b 53 94             	mov    -0x6c(%ebx),%edx
80104541:	89 4d cc             	mov    %ecx,-0x34(%ebp)
                    , ptable.proc[i].pid
                    , ptable.proc[i].parent ? ptable.proc[i].parent->pid : 1
80104544:	8b 4b a8             	mov    -0x58(%ebx),%ecx
            cprintf("%d\t%d\t%s\t%s\t%u\t%u-%s%u-%u %u:%u:%u\t%u\t%u\t%u"
80104547:	89 55 c8             	mov    %edx,-0x38(%ebp)
8010454a:	ba 01 00 00 00       	mov    $0x1,%edx
8010454f:	85 c9                	test   %ecx,%ecx
80104551:	74 03                	je     80104556 <proc_cps+0xb6>
80104553:	8b 51 10             	mov    0x10(%ecx),%edx
80104556:	57                   	push   %edi
80104557:	ff 75 e4             	push   -0x1c(%ebp)
8010455a:	ff 75 e0             	push   -0x20(%ebp)
8010455d:	ff 75 dc             	push   -0x24(%ebp)
80104560:	ff 75 d8             	push   -0x28(%ebp)
80104563:	ff 75 d4             	push   -0x2c(%ebp)
80104566:	ff 75 d0             	push   -0x30(%ebp)
80104569:	50                   	push   %eax
8010456a:	ff 75 c4             	push   -0x3c(%ebp)
8010456d:	ff 75 cc             	push   -0x34(%ebp)
80104570:	ff 75 c8             	push   -0x38(%ebp)
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	52                   	push   %edx
80104576:	ff 73 a4             	push   -0x5c(%ebx)
80104579:	68 64 7c 10 80       	push   $0x80107c64
8010457e:	e8 1d c1 ff ff       	call   801006a0 <cprintf>
 		);
#ifdef PROC_TIMES
//# error this is an excellent place to add some new data to the o/p of cps

#endif // PROC_TIMES
            cprintf("\n");
80104583:	83 c4 34             	add    $0x34,%esp
80104586:	68 a3 7f 10 80       	push   $0x80107fa3
8010458b:	e8 10 c1 ff ff       	call   801006a0 <cprintf>
80104590:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPROC; i++) {
80104593:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104599:	81 fb c0 56 11 80    	cmp    $0x801156c0,%ebx
8010459f:	0f 85 33 ff ff ff    	jne    801044d8 <proc_cps+0x38>
        else {
            // UNUSED process table entry is ignored
        }
    }

    release(&ptable.lock);
801045a5:	83 ec 0c             	sub    $0xc,%esp
801045a8:	68 20 2d 11 80       	push   $0x80112d20
801045ad:	e8 de 02 00 00       	call   80104890 <release>
    return 0;
}
801045b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b5:	31 c0                	xor    %eax,%eax
801045b7:	5b                   	pop    %ebx
801045b8:	5e                   	pop    %esi
801045b9:	5f                   	pop    %edi
801045ba:	5d                   	pop    %ebp
801045bb:	c3                   	ret    
801045bc:	66 90                	xchg   %ax,%ax
801045be:	66 90                	xchg   %ax,%ax

801045c0 <srand>:

static unsigned long next = 1;

/* RAND_MAX assumed to be 32767 */

void srand(unsigned seed) {
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
    next = seed;
801045c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801045c6:	5d                   	pop    %ebp
    next = seed;
801045c7:	a3 08 b0 10 80       	mov    %eax,0x8010b008
}
801045cc:	c3                   	ret    
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <rand>:
int rand(void) {
    next = next * 1103515245 + 12345;
801045d0:	69 05 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%eax
801045d7:	4e c6 41 
801045da:	05 39 30 00 00       	add    $0x3039,%eax
801045df:	a3 08 b0 10 80       	mov    %eax,0x8010b008
    return((unsigned)(next/65536) % RAND_MAX);
801045e4:	c1 e8 10             	shr    $0x10,%eax
}
801045e7:	c3                   	ret    
801045e8:	66 90                	xchg   %ax,%ax
801045ea:	66 90                	xchg   %ax,%ax
801045ec:	66 90                	xchg   %ax,%ax
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045fa:	68 a8 7c 10 80       	push   $0x80107ca8
801045ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104602:	50                   	push   %eax
80104603:	e8 18 01 00 00       	call   80104720 <initlock>
  lk->name = name;
80104608:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010460b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104611:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104614:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010461b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010461e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104621:	c9                   	leave  
80104622:	c3                   	ret    
80104623:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	8d 73 04             	lea    0x4(%ebx),%esi
8010463b:	83 ec 0c             	sub    $0xc,%esp
8010463e:	56                   	push   %esi
8010463f:	e8 ac 02 00 00       	call   801048f0 <acquire>
  while (lk->locked) {
80104644:	8b 13                	mov    (%ebx),%edx
80104646:	83 c4 10             	add    $0x10,%esp
80104649:	85 d2                	test   %edx,%edx
8010464b:	74 16                	je     80104663 <acquiresleep+0x33>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104650:	83 ec 08             	sub    $0x8,%esp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	e8 46 fb ff ff       	call   801041a0 <sleep>
  while (lk->locked) {
8010465a:	8b 03                	mov    (%ebx),%eax
8010465c:	83 c4 10             	add    $0x10,%esp
8010465f:	85 c0                	test   %eax,%eax
80104661:	75 ed                	jne    80104650 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104663:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104669:	e8 12 f3 ff ff       	call   80103980 <myproc>
8010466e:	8b 40 10             	mov    0x10(%eax),%eax
80104671:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104674:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104677:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010467a:	5b                   	pop    %ebx
8010467b:	5e                   	pop    %esi
8010467c:	5d                   	pop    %ebp
  release(&lk->lk);
8010467d:	e9 0e 02 00 00       	jmp    80104890 <release>
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104698:	8d 73 04             	lea    0x4(%ebx),%esi
8010469b:	83 ec 0c             	sub    $0xc,%esp
8010469e:	56                   	push   %esi
8010469f:	e8 4c 02 00 00       	call   801048f0 <acquire>
  lk->locked = 0;
801046a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046b1:	89 1c 24             	mov    %ebx,(%esp)
801046b4:	e8 a7 fb ff ff       	call   80104260 <wakeup>
  release(&lk->lk);
801046b9:	89 75 08             	mov    %esi,0x8(%ebp)
801046bc:	83 c4 10             	add    $0x10,%esp
}
801046bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
  release(&lk->lk);
801046c5:	e9 c6 01 00 00       	jmp    80104890 <release>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	31 ff                	xor    %edi,%edi
801046d6:	56                   	push   %esi
801046d7:	53                   	push   %ebx
801046d8:	83 ec 18             	sub    $0x18,%esp
801046db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046de:	8d 73 04             	lea    0x4(%ebx),%esi
801046e1:	56                   	push   %esi
801046e2:	e8 09 02 00 00       	call   801048f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046e7:	8b 03                	mov    (%ebx),%eax
801046e9:	83 c4 10             	add    $0x10,%esp
801046ec:	85 c0                	test   %eax,%eax
801046ee:	75 18                	jne    80104708 <holdingsleep+0x38>
  release(&lk->lk);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	56                   	push   %esi
801046f4:	e8 97 01 00 00       	call   80104890 <release>
  return r;
}
801046f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046fc:	89 f8                	mov    %edi,%eax
801046fe:	5b                   	pop    %ebx
801046ff:	5e                   	pop    %esi
80104700:	5f                   	pop    %edi
80104701:	5d                   	pop    %ebp
80104702:	c3                   	ret    
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104708:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010470b:	e8 70 f2 ff ff       	call   80103980 <myproc>
80104710:	39 58 10             	cmp    %ebx,0x10(%eax)
80104713:	0f 94 c0             	sete   %al
80104716:	0f b6 c0             	movzbl %al,%eax
80104719:	89 c7                	mov    %eax,%edi
8010471b:	eb d3                	jmp    801046f0 <holdingsleep+0x20>
8010471d:	66 90                	xchg   %ax,%ax
8010471f:	90                   	nop

80104720 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104726:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010472f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop

80104740 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104740:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104741:	31 d2                	xor    %edx,%edx
{
80104743:	89 e5                	mov    %esp,%ebp
80104745:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104746:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010474c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010474f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104750:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104756:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010475c:	77 1a                	ja     80104778 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010475e:	8b 58 04             	mov    0x4(%eax),%ebx
80104761:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104764:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104767:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104769:	83 fa 0a             	cmp    $0xa,%edx
8010476c:	75 e2                	jne    80104750 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010476e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104771:	c9                   	leave  
80104772:	c3                   	ret    
80104773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104777:	90                   	nop
  for(; i < 10; i++)
80104778:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010477b:	8d 51 28             	lea    0x28(%ecx),%edx
8010477e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104786:	83 c0 04             	add    $0x4,%eax
80104789:	39 d0                	cmp    %edx,%eax
8010478b:	75 f3                	jne    80104780 <getcallerpcs+0x40>
}
8010478d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104790:	c9                   	leave  
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
801047a7:	9c                   	pushf  
801047a8:	5b                   	pop    %ebx
  asm volatile("cli");
801047a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047aa:	e8 51 f1 ff ff       	call   80103900 <mycpu>
801047af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047b5:	85 c0                	test   %eax,%eax
801047b7:	74 17                	je     801047d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047b9:	e8 42 f1 ff ff       	call   80103900 <mycpu>
801047be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c8:	c9                   	leave  
801047c9:	c3                   	ret    
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801047d0:	e8 2b f1 ff ff       	call   80103900 <mycpu>
801047d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047e1:	eb d6                	jmp    801047b9 <pushcli+0x19>
801047e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <popcli>:

void
popcli(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047f6:	9c                   	pushf  
801047f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047f8:	f6 c4 02             	test   $0x2,%ah
801047fb:	75 35                	jne    80104832 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047fd:	e8 fe f0 ff ff       	call   80103900 <mycpu>
80104802:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104809:	78 34                	js     8010483f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010480b:	e8 f0 f0 ff ff       	call   80103900 <mycpu>
80104810:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104816:	85 d2                	test   %edx,%edx
80104818:	74 06                	je     80104820 <popcli+0x30>
    sti();
}
8010481a:	c9                   	leave  
8010481b:	c3                   	ret    
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104820:	e8 db f0 ff ff       	call   80103900 <mycpu>
80104825:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010482b:	85 c0                	test   %eax,%eax
8010482d:	74 eb                	je     8010481a <popcli+0x2a>
  asm volatile("sti");
8010482f:	fb                   	sti    
}
80104830:	c9                   	leave  
80104831:	c3                   	ret    
    panic("popcli - interruptible");
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 b3 7c 10 80       	push   $0x80107cb3
8010483a:	e8 41 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010483f:	83 ec 0c             	sub    $0xc,%esp
80104842:	68 ca 7c 10 80       	push   $0x80107cca
80104847:	e8 34 bb ff ff       	call   80100380 <panic>
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <holding>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 75 08             	mov    0x8(%ebp),%esi
80104858:	31 db                	xor    %ebx,%ebx
  pushcli();
8010485a:	e8 41 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010485f:	8b 06                	mov    (%esi),%eax
80104861:	85 c0                	test   %eax,%eax
80104863:	75 0b                	jne    80104870 <holding+0x20>
  popcli();
80104865:	e8 86 ff ff ff       	call   801047f0 <popcli>
}
8010486a:	89 d8                	mov    %ebx,%eax
8010486c:	5b                   	pop    %ebx
8010486d:	5e                   	pop    %esi
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104870:	8b 5e 08             	mov    0x8(%esi),%ebx
80104873:	e8 88 f0 ff ff       	call   80103900 <mycpu>
80104878:	39 c3                	cmp    %eax,%ebx
8010487a:	0f 94 c3             	sete   %bl
  popcli();
8010487d:	e8 6e ff ff ff       	call   801047f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104882:	0f b6 db             	movzbl %bl,%ebx
}
80104885:	89 d8                	mov    %ebx,%eax
80104887:	5b                   	pop    %ebx
80104888:	5e                   	pop    %esi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <release>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104898:	e8 03 ff ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010489d:	8b 03                	mov    (%ebx),%eax
8010489f:	85 c0                	test   %eax,%eax
801048a1:	75 15                	jne    801048b8 <release+0x28>
  popcli();
801048a3:	e8 48 ff ff ff       	call   801047f0 <popcli>
    panic("release");
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 d1 7c 10 80       	push   $0x80107cd1
801048b0:	e8 cb ba ff ff       	call   80100380 <panic>
801048b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048b8:	8b 73 08             	mov    0x8(%ebx),%esi
801048bb:	e8 40 f0 ff ff       	call   80103900 <mycpu>
801048c0:	39 c6                	cmp    %eax,%esi
801048c2:	75 df                	jne    801048a3 <release+0x13>
  popcli();
801048c4:	e8 27 ff ff ff       	call   801047f0 <popcli>
  lk->pcs[0] = 0;
801048c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5d                   	pop    %ebp
  popcli();
801048e8:	e9 03 ff ff ff       	jmp    801047f0 <popcli>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <acquire>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048f7:	e8 a4 fe ff ff       	call   801047a0 <pushcli>
  if(holding(lk))
801048fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048ff:	e8 9c fe ff ff       	call   801047a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104904:	8b 03                	mov    (%ebx),%eax
80104906:	85 c0                	test   %eax,%eax
80104908:	75 7e                	jne    80104988 <acquire+0x98>
  popcli();
8010490a:	e8 e1 fe ff ff       	call   801047f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010490f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104918:	8b 55 08             	mov    0x8(%ebp),%edx
8010491b:	89 c8                	mov    %ecx,%eax
8010491d:	f0 87 02             	lock xchg %eax,(%edx)
80104920:	85 c0                	test   %eax,%eax
80104922:	75 f4                	jne    80104918 <acquire+0x28>
  __sync_synchronize();
80104924:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104929:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010492c:	e8 cf ef ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104931:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104934:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104936:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104939:	31 c0                	xor    %eax,%eax
8010493b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010493f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104940:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104946:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010494c:	77 1a                	ja     80104968 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010494e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104951:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104955:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104958:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010495a:	83 f8 0a             	cmp    $0xa,%eax
8010495d:	75 e1                	jne    80104940 <acquire+0x50>
}
8010495f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104962:	c9                   	leave  
80104963:	c3                   	ret    
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104968:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010496c:	8d 51 34             	lea    0x34(%ecx),%edx
8010496f:	90                   	nop
    pcs[i] = 0;
80104970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104976:	83 c0 04             	add    $0x4,%eax
80104979:	39 c2                	cmp    %eax,%edx
8010497b:	75 f3                	jne    80104970 <acquire+0x80>
}
8010497d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104980:	c9                   	leave  
80104981:	c3                   	ret    
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104988:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010498b:	e8 70 ef ff ff       	call   80103900 <mycpu>
80104990:	39 c3                	cmp    %eax,%ebx
80104992:	0f 85 72 ff ff ff    	jne    8010490a <acquire+0x1a>
  popcli();
80104998:	e8 53 fe ff ff       	call   801047f0 <popcli>
    panic("acquire");
8010499d:	83 ec 0c             	sub    $0xc,%esp
801049a0:	68 d9 7c 10 80       	push   $0x80107cd9
801049a5:	e8 d6 b9 ff ff       	call   80100380 <panic>
801049aa:	66 90                	xchg   %ax,%ax
801049ac:	66 90                	xchg   %ax,%ax
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	8b 55 08             	mov    0x8(%ebp),%edx
801049b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ba:	53                   	push   %ebx
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801049be:	89 d7                	mov    %edx,%edi
801049c0:	09 cf                	or     %ecx,%edi
801049c2:	83 e7 03             	and    $0x3,%edi
801049c5:	75 29                	jne    801049f0 <memset+0x40>
    c &= 0xFF;
801049c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049ca:	c1 e0 18             	shl    $0x18,%eax
801049cd:	89 fb                	mov    %edi,%ebx
801049cf:	c1 e9 02             	shr    $0x2,%ecx
801049d2:	c1 e3 10             	shl    $0x10,%ebx
801049d5:	09 d8                	or     %ebx,%eax
801049d7:	09 f8                	or     %edi,%eax
801049d9:	c1 e7 08             	shl    $0x8,%edi
801049dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049de:	89 d7                	mov    %edx,%edi
801049e0:	fc                   	cld    
801049e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049e3:	5b                   	pop    %ebx
801049e4:	89 d0                	mov    %edx,%eax
801049e6:	5f                   	pop    %edi
801049e7:	5d                   	pop    %ebp
801049e8:	c3                   	ret    
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049f0:	89 d7                	mov    %edx,%edi
801049f2:	fc                   	cld    
801049f3:	f3 aa                	rep stos %al,%es:(%edi)
801049f5:	5b                   	pop    %ebx
801049f6:	89 d0                	mov    %edx,%eax
801049f8:	5f                   	pop    %edi
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049ff:	90                   	nop

80104a00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	8b 75 10             	mov    0x10(%ebp),%esi
80104a07:	8b 55 08             	mov    0x8(%ebp),%edx
80104a0a:	53                   	push   %ebx
80104a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a0e:	85 f6                	test   %esi,%esi
80104a10:	74 2e                	je     80104a40 <memcmp+0x40>
80104a12:	01 c6                	add    %eax,%esi
80104a14:	eb 14                	jmp    80104a2a <memcmp+0x2a>
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a26:	39 f0                	cmp    %esi,%eax
80104a28:	74 16                	je     80104a40 <memcmp+0x40>
    if(*s1 != *s2)
80104a2a:	0f b6 0a             	movzbl (%edx),%ecx
80104a2d:	0f b6 18             	movzbl (%eax),%ebx
80104a30:	38 d9                	cmp    %bl,%cl
80104a32:	74 ec                	je     80104a20 <memcmp+0x20>
      return *s1 - *s2;
80104a34:	0f b6 c1             	movzbl %cl,%eax
80104a37:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	5b                   	pop    %ebx
  return 0;
80104a41:	31 c0                	xor    %eax,%eax
}
80104a43:	5e                   	pop    %esi
80104a44:	5d                   	pop    %ebp
80104a45:	c3                   	ret    
80104a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	8b 55 08             	mov    0x8(%ebp),%edx
80104a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a5a:	56                   	push   %esi
80104a5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a5e:	39 d6                	cmp    %edx,%esi
80104a60:	73 26                	jae    80104a88 <memmove+0x38>
80104a62:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a65:	39 fa                	cmp    %edi,%edx
80104a67:	73 1f                	jae    80104a88 <memmove+0x38>
80104a69:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a6c:	85 c9                	test   %ecx,%ecx
80104a6e:	74 0c                	je     80104a7c <memmove+0x2c>
      *--d = *--s;
80104a70:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a74:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a77:	83 e8 01             	sub    $0x1,%eax
80104a7a:	73 f4                	jae    80104a70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a7c:	5e                   	pop    %esi
80104a7d:	89 d0                	mov    %edx,%eax
80104a7f:	5f                   	pop    %edi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a88:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a8b:	89 d7                	mov    %edx,%edi
80104a8d:	85 c9                	test   %ecx,%ecx
80104a8f:	74 eb                	je     80104a7c <memmove+0x2c>
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a98:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a99:	39 c6                	cmp    %eax,%esi
80104a9b:	75 fb                	jne    80104a98 <memmove+0x48>
}
80104a9d:	5e                   	pop    %esi
80104a9e:	89 d0                	mov    %edx,%eax
80104aa0:	5f                   	pop    %edi
80104aa1:	5d                   	pop    %ebp
80104aa2:	c3                   	ret    
80104aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ab0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ab0:	eb 9e                	jmp    80104a50 <memmove>
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aca:	53                   	push   %ebx
80104acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104ace:	85 f6                	test   %esi,%esi
80104ad0:	74 2e                	je     80104b00 <strncmp+0x40>
80104ad2:	01 d6                	add    %edx,%esi
80104ad4:	eb 18                	jmp    80104aee <strncmp+0x2e>
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi
80104ae0:	38 d8                	cmp    %bl,%al
80104ae2:	75 14                	jne    80104af8 <strncmp+0x38>
    n--, p++, q++;
80104ae4:	83 c2 01             	add    $0x1,%edx
80104ae7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104aea:	39 f2                	cmp    %esi,%edx
80104aec:	74 12                	je     80104b00 <strncmp+0x40>
80104aee:	0f b6 01             	movzbl (%ecx),%eax
80104af1:	0f b6 1a             	movzbl (%edx),%ebx
80104af4:	84 c0                	test   %al,%al
80104af6:	75 e8                	jne    80104ae0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104af8:	29 d8                	sub    %ebx,%eax
}
80104afa:	5b                   	pop    %ebx
80104afb:	5e                   	pop    %esi
80104afc:	5d                   	pop    %ebp
80104afd:	c3                   	ret    
80104afe:	66 90                	xchg   %ax,%ax
80104b00:	5b                   	pop    %ebx
    return 0;
80104b01:	31 c0                	xor    %eax,%eax
}
80104b03:	5e                   	pop    %esi
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	8b 75 08             	mov    0x8(%ebp),%esi
80104b18:	53                   	push   %ebx
80104b19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b1c:	89 f0                	mov    %esi,%eax
80104b1e:	eb 15                	jmp    80104b35 <strncpy+0x25>
80104b20:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b24:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b27:	83 c0 01             	add    $0x1,%eax
80104b2a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104b2e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b31:	84 d2                	test   %dl,%dl
80104b33:	74 09                	je     80104b3e <strncpy+0x2e>
80104b35:	89 cb                	mov    %ecx,%ebx
80104b37:	83 e9 01             	sub    $0x1,%ecx
80104b3a:	85 db                	test   %ebx,%ebx
80104b3c:	7f e2                	jg     80104b20 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b3e:	89 c2                	mov    %eax,%edx
80104b40:	85 c9                	test   %ecx,%ecx
80104b42:	7e 17                	jle    80104b5b <strncpy+0x4b>
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b48:	83 c2 01             	add    $0x1,%edx
80104b4b:	89 c1                	mov    %eax,%ecx
80104b4d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104b51:	29 d1                	sub    %edx,%ecx
80104b53:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104b57:	85 c9                	test   %ecx,%ecx
80104b59:	7f ed                	jg     80104b48 <strncpy+0x38>
  return os;
}
80104b5b:	5b                   	pop    %ebx
80104b5c:	89 f0                	mov    %esi,%eax
80104b5e:	5e                   	pop    %esi
80104b5f:	5f                   	pop    %edi
80104b60:	5d                   	pop    %ebp
80104b61:	c3                   	ret    
80104b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	8b 55 10             	mov    0x10(%ebp),%edx
80104b77:	8b 75 08             	mov    0x8(%ebp),%esi
80104b7a:	53                   	push   %ebx
80104b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b7e:	85 d2                	test   %edx,%edx
80104b80:	7e 25                	jle    80104ba7 <safestrcpy+0x37>
80104b82:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b86:	89 f2                	mov    %esi,%edx
80104b88:	eb 16                	jmp    80104ba0 <safestrcpy+0x30>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b90:	0f b6 08             	movzbl (%eax),%ecx
80104b93:	83 c0 01             	add    $0x1,%eax
80104b96:	83 c2 01             	add    $0x1,%edx
80104b99:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b9c:	84 c9                	test   %cl,%cl
80104b9e:	74 04                	je     80104ba4 <safestrcpy+0x34>
80104ba0:	39 d8                	cmp    %ebx,%eax
80104ba2:	75 ec                	jne    80104b90 <safestrcpy+0x20>
    ;
  *s = 0;
80104ba4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ba7:	89 f0                	mov    %esi,%eax
80104ba9:	5b                   	pop    %ebx
80104baa:	5e                   	pop    %esi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret    
80104bad:	8d 76 00             	lea    0x0(%esi),%esi

80104bb0 <strlen>:

int
strlen(const char *s)
{
80104bb0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bb1:	31 c0                	xor    %eax,%eax
{
80104bb3:	89 e5                	mov    %esp,%ebp
80104bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104bb8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bbb:	74 0c                	je     80104bc9 <strlen+0x19>
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
80104bc0:	83 c0 01             	add    $0x1,%eax
80104bc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bc7:	75 f7                	jne    80104bc0 <strlen+0x10>
    ;
  return n;
}
80104bc9:	5d                   	pop    %ebp
80104bca:	c3                   	ret    

80104bcb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bcb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bcf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bd3:	55                   	push   %ebp
  pushl %ebx
80104bd4:	53                   	push   %ebx
  pushl %esi
80104bd5:	56                   	push   %esi
  pushl %edi
80104bd6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bd7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bd9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bdb:	5f                   	pop    %edi
  popl %esi
80104bdc:	5e                   	pop    %esi
  popl %ebx
80104bdd:	5b                   	pop    %ebx
  popl %ebp
80104bde:	5d                   	pop    %ebp
  ret
80104bdf:	c3                   	ret    

80104be0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	83 ec 04             	sub    $0x4,%esp
80104be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bea:	e8 91 ed ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bef:	8b 00                	mov    (%eax),%eax
80104bf1:	39 d8                	cmp    %ebx,%eax
80104bf3:	76 1b                	jbe    80104c10 <fetchint+0x30>
80104bf5:	8d 53 04             	lea    0x4(%ebx),%edx
80104bf8:	39 d0                	cmp    %edx,%eax
80104bfa:	72 14                	jb     80104c10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bff:	8b 13                	mov    (%ebx),%edx
80104c01:	89 10                	mov    %edx,(%eax)
  return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c08:	c9                   	leave  
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb ee                	jmp    80104c05 <fetchint+0x25>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 04             	sub    $0x4,%esp
80104c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c2a:	e8 51 ed ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
80104c2f:	39 18                	cmp    %ebx,(%eax)
80104c31:	76 2d                	jbe    80104c60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c3a:	39 d3                	cmp    %edx,%ebx
80104c3c:	73 22                	jae    80104c60 <fetchstr+0x40>
80104c3e:	89 d8                	mov    %ebx,%eax
80104c40:	eb 0d                	jmp    80104c4f <fetchstr+0x2f>
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	83 c0 01             	add    $0x1,%eax
80104c4b:	39 c2                	cmp    %eax,%edx
80104c4d:	76 11                	jbe    80104c60 <fetchstr+0x40>
    if(*s == 0)
80104c4f:	80 38 00             	cmpb   $0x0,(%eax)
80104c52:	75 f4                	jne    80104c48 <fetchstr+0x28>
      return s - *pp;
80104c54:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c59:	c9                   	leave  
80104c5a:	c3                   	ret    
80104c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop
80104c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	e8 06 ed ff ff       	call   80103980 <myproc>
80104c7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7d:	8b 40 18             	mov    0x18(%eax),%eax
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c86:	e8 f5 ec ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8e:	8b 00                	mov    (%eax),%eax
80104c90:	39 c6                	cmp    %eax,%esi
80104c92:	73 1c                	jae    80104cb0 <argint+0x40>
80104c94:	8d 53 08             	lea    0x8(%ebx),%edx
80104c97:	39 d0                	cmp    %edx,%eax
80104c99:	72 15                	jb     80104cb0 <argint+0x40>
  *ip = *(int*)(addr);
80104c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb5:	eb ee                	jmp    80104ca5 <argint+0x35>
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
80104cc6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104cc9:	e8 b2 ec ff ff       	call   80103980 <myproc>
80104cce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd0:	e8 ab ec ff ff       	call   80103980 <myproc>
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd8:	8b 40 18             	mov    0x18(%eax),%eax
80104cdb:	8b 40 44             	mov    0x44(%eax),%eax
80104cde:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ce1:	e8 9a ec ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ce9:	8b 00                	mov    (%eax),%eax
80104ceb:	39 c7                	cmp    %eax,%edi
80104ced:	73 31                	jae    80104d20 <argptr+0x60>
80104cef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104cf2:	39 c8                	cmp    %ecx,%eax
80104cf4:	72 2a                	jb     80104d20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cf6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104cf9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cfc:	85 d2                	test   %edx,%edx
80104cfe:	78 20                	js     80104d20 <argptr+0x60>
80104d00:	8b 16                	mov    (%esi),%edx
80104d02:	39 c2                	cmp    %eax,%edx
80104d04:	76 1a                	jbe    80104d20 <argptr+0x60>
80104d06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d09:	01 c3                	add    %eax,%ebx
80104d0b:	39 da                	cmp    %ebx,%edx
80104d0d:	72 11                	jb     80104d20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d12:	89 02                	mov    %eax,(%edx)
  return 0;
80104d14:	31 c0                	xor    %eax,%eax
}
80104d16:	83 c4 0c             	add    $0xc,%esp
80104d19:	5b                   	pop    %ebx
80104d1a:	5e                   	pop    %esi
80104d1b:	5f                   	pop    %edi
80104d1c:	5d                   	pop    %ebp
80104d1d:	c3                   	ret    
80104d1e:	66 90                	xchg   %ax,%ax
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	eb ef                	jmp    80104d16 <argptr+0x56>
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d35:	e8 46 ec ff ff       	call   80103980 <myproc>
80104d3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d3d:	8b 40 18             	mov    0x18(%eax),%eax
80104d40:	8b 40 44             	mov    0x44(%eax),%eax
80104d43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d46:	e8 35 ec ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d4e:	8b 00                	mov    (%eax),%eax
80104d50:	39 c6                	cmp    %eax,%esi
80104d52:	73 44                	jae    80104d98 <argstr+0x68>
80104d54:	8d 53 08             	lea    0x8(%ebx),%edx
80104d57:	39 d0                	cmp    %edx,%eax
80104d59:	72 3d                	jb     80104d98 <argstr+0x68>
  *ip = *(int*)(addr);
80104d5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d5e:	e8 1d ec ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz)
80104d63:	3b 18                	cmp    (%eax),%ebx
80104d65:	73 31                	jae    80104d98 <argstr+0x68>
  *pp = (char*)addr;
80104d67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d6e:	39 d3                	cmp    %edx,%ebx
80104d70:	73 26                	jae    80104d98 <argstr+0x68>
80104d72:	89 d8                	mov    %ebx,%eax
80104d74:	eb 11                	jmp    80104d87 <argstr+0x57>
80104d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	83 c0 01             	add    $0x1,%eax
80104d83:	39 c2                	cmp    %eax,%edx
80104d85:	76 11                	jbe    80104d98 <argstr+0x68>
    if(*s == 0)
80104d87:	80 38 00             	cmpb   $0x0,(%eax)
80104d8a:	75 f4                	jne    80104d80 <argstr+0x50>
      return s - *pp;
80104d8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d8e:	5b                   	pop    %ebx
80104d8f:	5e                   	pop    %esi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	5b                   	pop    %ebx
    return -1;
80104d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d9e:	5e                   	pop    %esi
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret    
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop

80104db0 <syscall>:
#endif // LOTTERY
};

void
syscall(void)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104db7:	e8 c4 eb ff ff       	call   80103980 <myproc>
80104dbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dbe:	8b 40 18             	mov    0x18(%eax),%eax
80104dc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dc7:	83 fa 17             	cmp    $0x17,%edx
80104dca:	77 24                	ja     80104df0 <syscall+0x40>
80104dcc:	8b 14 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%edx
80104dd3:	85 d2                	test   %edx,%edx
80104dd5:	74 19                	je     80104df0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104dd7:	ff d2                	call   *%edx
80104dd9:	89 c2                	mov    %eax,%edx
80104ddb:	8b 43 18             	mov    0x18(%ebx),%eax
80104dde:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de4:	c9                   	leave  
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104df0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104df1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104df4:	50                   	push   %eax
80104df5:	ff 73 10             	push   0x10(%ebx)
80104df8:	68 e1 7c 10 80       	push   $0x80107ce1
80104dfd:	e8 9e b8 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104e02:	8b 43 18             	mov    0x18(%ebx),%eax
80104e05:	83 c4 10             	add    $0x10,%esp
80104e08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e12:	c9                   	leave  
80104e13:	c3                   	ret    
80104e14:	66 90                	xchg   %ax,%ax
80104e16:	66 90                	xchg   %ax,%ax
80104e18:	66 90                	xchg   %ax,%ax
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e28:	53                   	push   %ebx
80104e29:	83 ec 34             	sub    $0x34,%esp
80104e2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e32:	57                   	push   %edi
80104e33:	50                   	push   %eax
{
80104e34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e3a:	e8 51 d2 ff ff       	call   80102090 <nameiparent>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	0f 84 46 01 00 00    	je     80104f90 <create+0x170>
    return 0;
  ilock(dp);
80104e4a:	83 ec 0c             	sub    $0xc,%esp
80104e4d:	89 c3                	mov    %eax,%ebx
80104e4f:	50                   	push   %eax
80104e50:	e8 fb c8 ff ff       	call   80101750 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e55:	83 c4 0c             	add    $0xc,%esp
80104e58:	6a 00                	push   $0x0
80104e5a:	57                   	push   %edi
80104e5b:	53                   	push   %ebx
80104e5c:	e8 4f ce ff ff       	call   80101cb0 <dirlookup>
80104e61:	83 c4 10             	add    $0x10,%esp
80104e64:	89 c6                	mov    %eax,%esi
80104e66:	85 c0                	test   %eax,%eax
80104e68:	74 56                	je     80104ec0 <create+0xa0>
    iunlockput(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	53                   	push   %ebx
80104e6e:	e8 6d cb ff ff       	call   801019e0 <iunlockput>
    ilock(ip);
80104e73:	89 34 24             	mov    %esi,(%esp)
80104e76:	e8 d5 c8 ff ff       	call   80101750 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e7b:	83 c4 10             	add    $0x10,%esp
80104e7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e83:	75 1b                	jne    80104ea0 <create+0x80>
80104e85:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e8a:	75 14                	jne    80104ea0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e8f:	89 f0                	mov    %esi,%eax
80104e91:	5b                   	pop    %ebx
80104e92:	5e                   	pop    %esi
80104e93:	5f                   	pop    %edi
80104e94:	5d                   	pop    %ebp
80104e95:	c3                   	ret    
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
80104ea3:	56                   	push   %esi
    return 0;
80104ea4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ea6:	e8 35 cb ff ff       	call   801019e0 <iunlockput>
    return 0;
80104eab:	83 c4 10             	add    $0x10,%esp
}
80104eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb1:	89 f0                	mov    %esi,%eax
80104eb3:	5b                   	pop    %ebx
80104eb4:	5e                   	pop    %esi
80104eb5:	5f                   	pop    %edi
80104eb6:	5d                   	pop    %ebp
80104eb7:	c3                   	ret    
80104eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ec0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ec4:	83 ec 08             	sub    $0x8,%esp
80104ec7:	50                   	push   %eax
80104ec8:	ff 33                	push   (%ebx)
80104eca:	e8 11 c7 ff ff       	call   801015e0 <ialloc>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	89 c6                	mov    %eax,%esi
80104ed4:	85 c0                	test   %eax,%eax
80104ed6:	0f 84 cd 00 00 00    	je     80104fa9 <create+0x189>
  ilock(ip);
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	50                   	push   %eax
80104ee0:	e8 6b c8 ff ff       	call   80101750 <ilock>
  ip->major = major;
80104ee5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ee9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104eed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ef1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ef5:	b8 01 00 00 00       	mov    $0x1,%eax
80104efa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104efe:	89 34 24             	mov    %esi,(%esp)
80104f01:	e8 9a c7 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f0e:	74 30                	je     80104f40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f10:	83 ec 04             	sub    $0x4,%esp
80104f13:	ff 76 04             	push   0x4(%esi)
80104f16:	57                   	push   %edi
80104f17:	53                   	push   %ebx
80104f18:	e8 93 d0 ff ff       	call   80101fb0 <dirlink>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 78                	js     80104f9c <create+0x17c>
  iunlockput(dp);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	53                   	push   %ebx
80104f28:	e8 b3 ca ff ff       	call   801019e0 <iunlockput>
  return ip;
80104f2d:	83 c4 10             	add    $0x10,%esp
}
80104f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f33:	89 f0                	mov    %esi,%eax
80104f35:	5b                   	pop    %ebx
80104f36:	5e                   	pop    %esi
80104f37:	5f                   	pop    %edi
80104f38:	5d                   	pop    %ebp
80104f39:	c3                   	ret    
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f48:	53                   	push   %ebx
80104f49:	e8 52 c7 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f4e:	83 c4 0c             	add    $0xc,%esp
80104f51:	ff 76 04             	push   0x4(%esi)
80104f54:	68 80 7d 10 80       	push   $0x80107d80
80104f59:	56                   	push   %esi
80104f5a:	e8 51 d0 ff ff       	call   80101fb0 <dirlink>
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	85 c0                	test   %eax,%eax
80104f64:	78 18                	js     80104f7e <create+0x15e>
80104f66:	83 ec 04             	sub    $0x4,%esp
80104f69:	ff 73 04             	push   0x4(%ebx)
80104f6c:	68 7f 7d 10 80       	push   $0x80107d7f
80104f71:	56                   	push   %esi
80104f72:	e8 39 d0 ff ff       	call   80101fb0 <dirlink>
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	79 92                	jns    80104f10 <create+0xf0>
      panic("create dots");
80104f7e:	83 ec 0c             	sub    $0xc,%esp
80104f81:	68 73 7d 10 80       	push   $0x80107d73
80104f86:	e8 f5 b3 ff ff       	call   80100380 <panic>
80104f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f8f:	90                   	nop
}
80104f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f93:	31 f6                	xor    %esi,%esi
}
80104f95:	5b                   	pop    %ebx
80104f96:	89 f0                	mov    %esi,%eax
80104f98:	5e                   	pop    %esi
80104f99:	5f                   	pop    %edi
80104f9a:	5d                   	pop    %ebp
80104f9b:	c3                   	ret    
    panic("create: dirlink");
80104f9c:	83 ec 0c             	sub    $0xc,%esp
80104f9f:	68 82 7d 10 80       	push   $0x80107d82
80104fa4:	e8 d7 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104fa9:	83 ec 0c             	sub    $0xc,%esp
80104fac:	68 64 7d 10 80       	push   $0x80107d64
80104fb1:	e8 ca b3 ff ff       	call   80100380 <panic>
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi

80104fc0 <sys_dup>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fcb:	50                   	push   %eax
80104fcc:	6a 00                	push   $0x0
80104fce:	e8 9d fc ff ff       	call   80104c70 <argint>
80104fd3:	83 c4 10             	add    $0x10,%esp
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	78 36                	js     80105010 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fde:	77 30                	ja     80105010 <sys_dup+0x50>
80104fe0:	e8 9b e9 ff ff       	call   80103980 <myproc>
80104fe5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fec:	85 f6                	test   %esi,%esi
80104fee:	74 20                	je     80105010 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ff0:	e8 8b e9 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ff5:	31 db                	xor    %ebx,%ebx
80104ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105000:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105004:	85 d2                	test   %edx,%edx
80105006:	74 18                	je     80105020 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105008:	83 c3 01             	add    $0x1,%ebx
8010500b:	83 fb 10             	cmp    $0x10,%ebx
8010500e:	75 f0                	jne    80105000 <sys_dup+0x40>
}
80105010:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105013:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105018:	89 d8                	mov    %ebx,%eax
8010501a:	5b                   	pop    %ebx
8010501b:	5e                   	pop    %esi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105020:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105023:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105027:	56                   	push   %esi
80105028:	e8 43 be ff ff       	call   80100e70 <filedup>
  return fd;
8010502d:	83 c4 10             	add    $0x10,%esp
}
80105030:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105033:	89 d8                	mov    %ebx,%eax
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret    
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105040 <sys_read>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105045:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105048:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504b:	53                   	push   %ebx
8010504c:	6a 00                	push   $0x0
8010504e:	e8 1d fc ff ff       	call   80104c70 <argint>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 5e                	js     801050b8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505e:	77 58                	ja     801050b8 <sys_read+0x78>
80105060:	e8 1b e9 ff ff       	call   80103980 <myproc>
80105065:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105068:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010506c:	85 f6                	test   %esi,%esi
8010506e:	74 48                	je     801050b8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105070:	83 ec 08             	sub    $0x8,%esp
80105073:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105076:	50                   	push   %eax
80105077:	6a 02                	push   $0x2
80105079:	e8 f2 fb ff ff       	call   80104c70 <argint>
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	85 c0                	test   %eax,%eax
80105083:	78 33                	js     801050b8 <sys_read+0x78>
80105085:	83 ec 04             	sub    $0x4,%esp
80105088:	ff 75 f0             	push   -0x10(%ebp)
8010508b:	53                   	push   %ebx
8010508c:	6a 01                	push   $0x1
8010508e:	e8 2d fc ff ff       	call   80104cc0 <argptr>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 1e                	js     801050b8 <sys_read+0x78>
  return fileread(f, p, n);
8010509a:	83 ec 04             	sub    $0x4,%esp
8010509d:	ff 75 f0             	push   -0x10(%ebp)
801050a0:	ff 75 f4             	push   -0xc(%ebp)
801050a3:	56                   	push   %esi
801050a4:	e8 47 bf ff ff       	call   80100ff0 <fileread>
801050a9:	83 c4 10             	add    $0x10,%esp
}
801050ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050af:	5b                   	pop    %ebx
801050b0:	5e                   	pop    %esi
801050b1:	5d                   	pop    %ebp
801050b2:	c3                   	ret    
801050b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b7:	90                   	nop
    return -1;
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb ed                	jmp    801050ac <sys_read+0x6c>
801050bf:	90                   	nop

801050c0 <sys_write>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cb:	53                   	push   %ebx
801050cc:	6a 00                	push   $0x0
801050ce:	e8 9d fb ff ff       	call   80104c70 <argint>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 5e                	js     80105138 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050de:	77 58                	ja     80105138 <sys_write+0x78>
801050e0:	e8 9b e8 ff ff       	call   80103980 <myproc>
801050e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ec:	85 f6                	test   %esi,%esi
801050ee:	74 48                	je     80105138 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050f0:	83 ec 08             	sub    $0x8,%esp
801050f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050f6:	50                   	push   %eax
801050f7:	6a 02                	push   $0x2
801050f9:	e8 72 fb ff ff       	call   80104c70 <argint>
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	85 c0                	test   %eax,%eax
80105103:	78 33                	js     80105138 <sys_write+0x78>
80105105:	83 ec 04             	sub    $0x4,%esp
80105108:	ff 75 f0             	push   -0x10(%ebp)
8010510b:	53                   	push   %ebx
8010510c:	6a 01                	push   $0x1
8010510e:	e8 ad fb ff ff       	call   80104cc0 <argptr>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 1e                	js     80105138 <sys_write+0x78>
  return filewrite(f, p, n);
8010511a:	83 ec 04             	sub    $0x4,%esp
8010511d:	ff 75 f0             	push   -0x10(%ebp)
80105120:	ff 75 f4             	push   -0xc(%ebp)
80105123:	56                   	push   %esi
80105124:	e8 57 bf ff ff       	call   80101080 <filewrite>
80105129:	83 c4 10             	add    $0x10,%esp
}
8010512c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010512f:	5b                   	pop    %ebx
80105130:	5e                   	pop    %esi
80105131:	5d                   	pop    %ebp
80105132:	c3                   	ret    
80105133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105137:	90                   	nop
    return -1;
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb ed                	jmp    8010512c <sys_write+0x6c>
8010513f:	90                   	nop

80105140 <sys_close>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105145:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105148:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514b:	50                   	push   %eax
8010514c:	6a 00                	push   $0x0
8010514e:	e8 1d fb ff ff       	call   80104c70 <argint>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	78 3e                	js     80105198 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010515e:	77 38                	ja     80105198 <sys_close+0x58>
80105160:	e8 1b e8 ff ff       	call   80103980 <myproc>
80105165:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105168:	8d 5a 08             	lea    0x8(%edx),%ebx
8010516b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010516f:	85 f6                	test   %esi,%esi
80105171:	74 25                	je     80105198 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105173:	e8 08 e8 ff ff       	call   80103980 <myproc>
  fileclose(f);
80105178:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010517b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105182:	00 
  fileclose(f);
80105183:	56                   	push   %esi
80105184:	e8 37 bd ff ff       	call   80100ec0 <fileclose>
  return 0;
80105189:	83 c4 10             	add    $0x10,%esp
8010518c:	31 c0                	xor    %eax,%eax
}
8010518e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105191:	5b                   	pop    %ebx
80105192:	5e                   	pop    %esi
80105193:	5d                   	pop    %ebp
80105194:	c3                   	ret    
80105195:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519d:	eb ef                	jmp    8010518e <sys_close+0x4e>
8010519f:	90                   	nop

801051a0 <sys_fstat>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051ab:	53                   	push   %ebx
801051ac:	6a 00                	push   $0x0
801051ae:	e8 bd fa ff ff       	call   80104c70 <argint>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	78 46                	js     80105200 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051be:	77 40                	ja     80105200 <sys_fstat+0x60>
801051c0:	e8 bb e7 ff ff       	call   80103980 <myproc>
801051c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051cc:	85 f6                	test   %esi,%esi
801051ce:	74 30                	je     80105200 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d0:	83 ec 04             	sub    $0x4,%esp
801051d3:	6a 14                	push   $0x14
801051d5:	53                   	push   %ebx
801051d6:	6a 01                	push   $0x1
801051d8:	e8 e3 fa ff ff       	call   80104cc0 <argptr>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 1c                	js     80105200 <sys_fstat+0x60>
  return filestat(f, st);
801051e4:	83 ec 08             	sub    $0x8,%esp
801051e7:	ff 75 f4             	push   -0xc(%ebp)
801051ea:	56                   	push   %esi
801051eb:	e8 b0 bd ff ff       	call   80100fa0 <filestat>
801051f0:	83 c4 10             	add    $0x10,%esp
}
801051f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f6:	5b                   	pop    %ebx
801051f7:	5e                   	pop    %esi
801051f8:	5d                   	pop    %ebp
801051f9:	c3                   	ret    
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105205:	eb ec                	jmp    801051f3 <sys_fstat+0x53>
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <sys_link>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105215:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105218:	53                   	push   %ebx
80105219:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 0c fb ff ff       	call   80104d30 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 fb 00 00 00    	js     8010532a <sys_link+0x11a>
8010522f:	83 ec 08             	sub    $0x8,%esp
80105232:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105235:	50                   	push   %eax
80105236:	6a 01                	push   $0x1
80105238:	e8 f3 fa ff ff       	call   80104d30 <argstr>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	0f 88 e2 00 00 00    	js     8010532a <sys_link+0x11a>
  begin_op();
80105248:	e8 e3 da ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	ff 75 d4             	push   -0x2c(%ebp)
80105253:	e8 18 ce ff ff       	call   80102070 <namei>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	89 c3                	mov    %eax,%ebx
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 e4 00 00 00    	je     80105349 <sys_link+0x139>
  ilock(ip);
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	50                   	push   %eax
80105269:	e8 e2 c4 ff ff       	call   80101750 <ilock>
  if(ip->type == T_DIR){
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105276:	0f 84 b5 00 00 00    	je     80105331 <sys_link+0x121>
  iupdate(ip);
8010527c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010527f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105284:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105287:	53                   	push   %ebx
80105288:	e8 13 c4 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
8010528d:	89 1c 24             	mov    %ebx,(%esp)
80105290:	e8 9b c5 ff ff       	call   80101830 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105295:	58                   	pop    %eax
80105296:	5a                   	pop    %edx
80105297:	57                   	push   %edi
80105298:	ff 75 d0             	push   -0x30(%ebp)
8010529b:	e8 f0 cd ff ff       	call   80102090 <nameiparent>
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	89 c6                	mov    %eax,%esi
801052a5:	85 c0                	test   %eax,%eax
801052a7:	74 5b                	je     80105304 <sys_link+0xf4>
  ilock(dp);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 9e c4 ff ff       	call   80101750 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052b2:	8b 03                	mov    (%ebx),%eax
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	39 06                	cmp    %eax,(%esi)
801052b9:	75 3d                	jne    801052f8 <sys_link+0xe8>
801052bb:	83 ec 04             	sub    $0x4,%esp
801052be:	ff 73 04             	push   0x4(%ebx)
801052c1:	57                   	push   %edi
801052c2:	56                   	push   %esi
801052c3:	e8 e8 cc ff ff       	call   80101fb0 <dirlink>
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	85 c0                	test   %eax,%eax
801052cd:	78 29                	js     801052f8 <sys_link+0xe8>
  iunlockput(dp);
801052cf:	83 ec 0c             	sub    $0xc,%esp
801052d2:	56                   	push   %esi
801052d3:	e8 08 c7 ff ff       	call   801019e0 <iunlockput>
  iput(ip);
801052d8:	89 1c 24             	mov    %ebx,(%esp)
801052db:	e8 a0 c5 ff ff       	call   80101880 <iput>
  end_op();
801052e0:	e8 bb da ff ff       	call   80102da0 <end_op>
  return 0;
801052e5:	83 c4 10             	add    $0x10,%esp
801052e8:	31 c0                	xor    %eax,%eax
}
801052ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ed:	5b                   	pop    %ebx
801052ee:	5e                   	pop    %esi
801052ef:	5f                   	pop    %edi
801052f0:	5d                   	pop    %ebp
801052f1:	c3                   	ret    
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	56                   	push   %esi
801052fc:	e8 df c6 ff ff       	call   801019e0 <iunlockput>
    goto bad;
80105301:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	53                   	push   %ebx
80105308:	e8 43 c4 ff ff       	call   80101750 <ilock>
  ip->nlink--;
8010530d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105312:	89 1c 24             	mov    %ebx,(%esp)
80105315:	e8 86 c3 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
8010531a:	89 1c 24             	mov    %ebx,(%esp)
8010531d:	e8 be c6 ff ff       	call   801019e0 <iunlockput>
  end_op();
80105322:	e8 79 da ff ff       	call   80102da0 <end_op>
  return -1;
80105327:	83 c4 10             	add    $0x10,%esp
8010532a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532f:	eb b9                	jmp    801052ea <sys_link+0xda>
    iunlockput(ip);
80105331:	83 ec 0c             	sub    $0xc,%esp
80105334:	53                   	push   %ebx
80105335:	e8 a6 c6 ff ff       	call   801019e0 <iunlockput>
    end_op();
8010533a:	e8 61 da ff ff       	call   80102da0 <end_op>
    return -1;
8010533f:	83 c4 10             	add    $0x10,%esp
80105342:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105347:	eb a1                	jmp    801052ea <sys_link+0xda>
    end_op();
80105349:	e8 52 da ff ff       	call   80102da0 <end_op>
    return -1;
8010534e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105353:	eb 95                	jmp    801052ea <sys_link+0xda>
80105355:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_unlink>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105365:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105368:	53                   	push   %ebx
80105369:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 bc f9 ff ff       	call   80104d30 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 7a 01 00 00    	js     801054f9 <sys_unlink+0x199>
  begin_op();
8010537f:	e8 ac d9 ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105384:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	53                   	push   %ebx
8010538b:	ff 75 c0             	push   -0x40(%ebp)
8010538e:	e8 fd cc ff ff       	call   80102090 <nameiparent>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105399:	85 c0                	test   %eax,%eax
8010539b:	0f 84 62 01 00 00    	je     80105503 <sys_unlink+0x1a3>
  ilock(dp);
801053a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	57                   	push   %edi
801053a8:	e8 a3 c3 ff ff       	call   80101750 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053ad:	58                   	pop    %eax
801053ae:	5a                   	pop    %edx
801053af:	68 80 7d 10 80       	push   $0x80107d80
801053b4:	53                   	push   %ebx
801053b5:	e8 d6 c8 ff ff       	call   80101c90 <namecmp>
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	85 c0                	test   %eax,%eax
801053bf:	0f 84 fb 00 00 00    	je     801054c0 <sys_unlink+0x160>
801053c5:	83 ec 08             	sub    $0x8,%esp
801053c8:	68 7f 7d 10 80       	push   $0x80107d7f
801053cd:	53                   	push   %ebx
801053ce:	e8 bd c8 ff ff       	call   80101c90 <namecmp>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	0f 84 e2 00 00 00    	je     801054c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053de:	83 ec 04             	sub    $0x4,%esp
801053e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053e4:	50                   	push   %eax
801053e5:	53                   	push   %ebx
801053e6:	57                   	push   %edi
801053e7:	e8 c4 c8 ff ff       	call   80101cb0 <dirlookup>
801053ec:	83 c4 10             	add    $0x10,%esp
801053ef:	89 c3                	mov    %eax,%ebx
801053f1:	85 c0                	test   %eax,%eax
801053f3:	0f 84 c7 00 00 00    	je     801054c0 <sys_unlink+0x160>
  ilock(ip);
801053f9:	83 ec 0c             	sub    $0xc,%esp
801053fc:	50                   	push   %eax
801053fd:	e8 4e c3 ff ff       	call   80101750 <ilock>
  if(ip->nlink < 1)
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010540a:	0f 8e 1c 01 00 00    	jle    8010552c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105410:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105415:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105418:	74 66                	je     80105480 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010541a:	83 ec 04             	sub    $0x4,%esp
8010541d:	6a 10                	push   $0x10
8010541f:	6a 00                	push   $0x0
80105421:	57                   	push   %edi
80105422:	e8 89 f5 ff ff       	call   801049b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105427:	6a 10                	push   $0x10
80105429:	ff 75 c4             	push   -0x3c(%ebp)
8010542c:	57                   	push   %edi
8010542d:	ff 75 b4             	push   -0x4c(%ebp)
80105430:	e8 2b c7 ff ff       	call   80101b60 <writei>
80105435:	83 c4 20             	add    $0x20,%esp
80105438:	83 f8 10             	cmp    $0x10,%eax
8010543b:	0f 85 de 00 00 00    	jne    8010551f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105441:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105446:	0f 84 94 00 00 00    	je     801054e0 <sys_unlink+0x180>
  iunlockput(dp);
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	ff 75 b4             	push   -0x4c(%ebp)
80105452:	e8 89 c5 ff ff       	call   801019e0 <iunlockput>
  ip->nlink--;
80105457:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010545c:	89 1c 24             	mov    %ebx,(%esp)
8010545f:	e8 3c c2 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105464:	89 1c 24             	mov    %ebx,(%esp)
80105467:	e8 74 c5 ff ff       	call   801019e0 <iunlockput>
  end_op();
8010546c:	e8 2f d9 ff ff       	call   80102da0 <end_op>
  return 0;
80105471:	83 c4 10             	add    $0x10,%esp
80105474:	31 c0                	xor    %eax,%eax
}
80105476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105479:	5b                   	pop    %ebx
8010547a:	5e                   	pop    %esi
8010547b:	5f                   	pop    %edi
8010547c:	5d                   	pop    %ebp
8010547d:	c3                   	ret    
8010547e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105480:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105484:	76 94                	jbe    8010541a <sys_unlink+0xba>
80105486:	be 20 00 00 00       	mov    $0x20,%esi
8010548b:	eb 0b                	jmp    80105498 <sys_unlink+0x138>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
80105490:	83 c6 10             	add    $0x10,%esi
80105493:	3b 73 58             	cmp    0x58(%ebx),%esi
80105496:	73 82                	jae    8010541a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105498:	6a 10                	push   $0x10
8010549a:	56                   	push   %esi
8010549b:	57                   	push   %edi
8010549c:	53                   	push   %ebx
8010549d:	e8 be c5 ff ff       	call   80101a60 <readi>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	83 f8 10             	cmp    $0x10,%eax
801054a8:	75 68                	jne    80105512 <sys_unlink+0x1b2>
    if(de.inum != 0)
801054aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054af:	74 df                	je     80105490 <sys_unlink+0x130>
    iunlockput(ip);
801054b1:	83 ec 0c             	sub    $0xc,%esp
801054b4:	53                   	push   %ebx
801054b5:	e8 26 c5 ff ff       	call   801019e0 <iunlockput>
    goto bad;
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	ff 75 b4             	push   -0x4c(%ebp)
801054c6:	e8 15 c5 ff ff       	call   801019e0 <iunlockput>
  end_op();
801054cb:	e8 d0 d8 ff ff       	call   80102da0 <end_op>
  return -1;
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d8:	eb 9c                	jmp    80105476 <sys_unlink+0x116>
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801054e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801054e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801054eb:	50                   	push   %eax
801054ec:	e8 af c1 ff ff       	call   801016a0 <iupdate>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	e9 53 ff ff ff       	jmp    8010544c <sys_unlink+0xec>
    return -1;
801054f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fe:	e9 73 ff ff ff       	jmp    80105476 <sys_unlink+0x116>
    end_op();
80105503:	e8 98 d8 ff ff       	call   80102da0 <end_op>
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	e9 64 ff ff ff       	jmp    80105476 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105512:	83 ec 0c             	sub    $0xc,%esp
80105515:	68 a4 7d 10 80       	push   $0x80107da4
8010551a:	e8 61 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	68 b6 7d 10 80       	push   $0x80107db6
80105527:	e8 54 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	68 92 7d 10 80       	push   $0x80107d92
80105534:	e8 47 ae ff ff       	call   80100380 <panic>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_open>:

int
sys_open(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105545:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105548:	53                   	push   %ebx
80105549:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 dc f7 ff ff       	call   80104d30 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 8e 00 00 00    	js     801055ed <sys_open+0xad>
8010555f:	83 ec 08             	sub    $0x8,%esp
80105562:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105565:	50                   	push   %eax
80105566:	6a 01                	push   $0x1
80105568:	e8 03 f7 ff ff       	call   80104c70 <argint>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	78 79                	js     801055ed <sys_open+0xad>
    return -1;

  begin_op();
80105574:	e8 b7 d7 ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
80105579:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010557d:	75 79                	jne    801055f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010557f:	83 ec 0c             	sub    $0xc,%esp
80105582:	ff 75 e0             	push   -0x20(%ebp)
80105585:	e8 e6 ca ff ff       	call   80102070 <namei>
8010558a:	83 c4 10             	add    $0x10,%esp
8010558d:	89 c6                	mov    %eax,%esi
8010558f:	85 c0                	test   %eax,%eax
80105591:	0f 84 7e 00 00 00    	je     80105615 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	50                   	push   %eax
8010559b:	e8 b0 c1 ff ff       	call   80101750 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a0:	83 c4 10             	add    $0x10,%esp
801055a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055a8:	0f 84 c2 00 00 00    	je     80105670 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055ae:	e8 4d b8 ff ff       	call   80100e00 <filealloc>
801055b3:	89 c7                	mov    %eax,%edi
801055b5:	85 c0                	test   %eax,%eax
801055b7:	74 23                	je     801055dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801055b9:	e8 c2 e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801055c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055c4:	85 d2                	test   %edx,%edx
801055c6:	74 60                	je     80105628 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801055c8:	83 c3 01             	add    $0x1,%ebx
801055cb:	83 fb 10             	cmp    $0x10,%ebx
801055ce:	75 f0                	jne    801055c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	57                   	push   %edi
801055d4:	e8 e7 b8 ff ff       	call   80100ec0 <fileclose>
801055d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	56                   	push   %esi
801055e0:	e8 fb c3 ff ff       	call   801019e0 <iunlockput>
    end_op();
801055e5:	e8 b6 d7 ff ff       	call   80102da0 <end_op>
    return -1;
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055f2:	eb 6d                	jmp    80105661 <sys_open+0x121>
801055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055fe:	31 c9                	xor    %ecx,%ecx
80105600:	ba 02 00 00 00       	mov    $0x2,%edx
80105605:	6a 00                	push   $0x0
80105607:	e8 14 f8 ff ff       	call   80104e20 <create>
    if(ip == 0){
8010560c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010560f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105611:	85 c0                	test   %eax,%eax
80105613:	75 99                	jne    801055ae <sys_open+0x6e>
      end_op();
80105615:	e8 86 d7 ff ff       	call   80102da0 <end_op>
      return -1;
8010561a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010561f:	eb 40                	jmp    80105661 <sys_open+0x121>
80105621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010562b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010562f:	56                   	push   %esi
80105630:	e8 fb c1 ff ff       	call   80101830 <iunlock>
  end_op();
80105635:	e8 66 d7 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
8010563a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105643:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105646:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105649:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010564b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105652:	f7 d0                	not    %eax
80105654:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105657:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010565a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010565d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105661:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105664:	89 d8                	mov    %ebx,%eax
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5f                   	pop    %edi
80105669:	5d                   	pop    %ebp
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105670:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105673:	85 c9                	test   %ecx,%ecx
80105675:	0f 84 33 ff ff ff    	je     801055ae <sys_open+0x6e>
8010567b:	e9 5c ff ff ff       	jmp    801055dc <sys_open+0x9c>

80105680 <sys_mkdir>:

int
sys_mkdir(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105686:	e8 a5 d6 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010568b:	83 ec 08             	sub    $0x8,%esp
8010568e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105691:	50                   	push   %eax
80105692:	6a 00                	push   $0x0
80105694:	e8 97 f6 ff ff       	call   80104d30 <argstr>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	78 30                	js     801056d0 <sys_mkdir+0x50>
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a6:	31 c9                	xor    %ecx,%ecx
801056a8:	ba 01 00 00 00       	mov    $0x1,%edx
801056ad:	6a 00                	push   $0x0
801056af:	e8 6c f7 ff ff       	call   80104e20 <create>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	74 15                	je     801056d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056bb:	83 ec 0c             	sub    $0xc,%esp
801056be:	50                   	push   %eax
801056bf:	e8 1c c3 ff ff       	call   801019e0 <iunlockput>
  end_op();
801056c4:	e8 d7 d6 ff ff       	call   80102da0 <end_op>
  return 0;
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	31 c0                	xor    %eax,%eax
}
801056ce:	c9                   	leave  
801056cf:	c3                   	ret    
    end_op();
801056d0:	e8 cb d6 ff ff       	call   80102da0 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_mknod>:

int
sys_mknod(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056e6:	e8 45 d6 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056f1:	50                   	push   %eax
801056f2:	6a 00                	push   $0x0
801056f4:	e8 37 f6 ff ff       	call   80104d30 <argstr>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	85 c0                	test   %eax,%eax
801056fe:	78 60                	js     80105760 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105700:	83 ec 08             	sub    $0x8,%esp
80105703:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105706:	50                   	push   %eax
80105707:	6a 01                	push   $0x1
80105709:	e8 62 f5 ff ff       	call   80104c70 <argint>
  if((argstr(0, &path)) < 0 ||
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	85 c0                	test   %eax,%eax
80105713:	78 4b                	js     80105760 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105715:	83 ec 08             	sub    $0x8,%esp
80105718:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010571b:	50                   	push   %eax
8010571c:	6a 02                	push   $0x2
8010571e:	e8 4d f5 ff ff       	call   80104c70 <argint>
     argint(1, &major) < 0 ||
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	85 c0                	test   %eax,%eax
80105728:	78 36                	js     80105760 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010572a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010572e:	83 ec 0c             	sub    $0xc,%esp
80105731:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105735:	ba 03 00 00 00       	mov    $0x3,%edx
8010573a:	50                   	push   %eax
8010573b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010573e:	e8 dd f6 ff ff       	call   80104e20 <create>
     argint(2, &minor) < 0 ||
80105743:	83 c4 10             	add    $0x10,%esp
80105746:	85 c0                	test   %eax,%eax
80105748:	74 16                	je     80105760 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010574a:	83 ec 0c             	sub    $0xc,%esp
8010574d:	50                   	push   %eax
8010574e:	e8 8d c2 ff ff       	call   801019e0 <iunlockput>
  end_op();
80105753:	e8 48 d6 ff ff       	call   80102da0 <end_op>
  return 0;
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	31 c0                	xor    %eax,%eax
}
8010575d:	c9                   	leave  
8010575e:	c3                   	ret    
8010575f:	90                   	nop
    end_op();
80105760:	e8 3b d6 ff ff       	call   80102da0 <end_op>
    return -1;
80105765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010576a:	c9                   	leave  
8010576b:	c3                   	ret    
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_chdir>:

int
sys_chdir(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	56                   	push   %esi
80105774:	53                   	push   %ebx
80105775:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105778:	e8 03 e2 ff ff       	call   80103980 <myproc>
8010577d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010577f:	e8 ac d5 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105784:	83 ec 08             	sub    $0x8,%esp
80105787:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010578a:	50                   	push   %eax
8010578b:	6a 00                	push   $0x0
8010578d:	e8 9e f5 ff ff       	call   80104d30 <argstr>
80105792:	83 c4 10             	add    $0x10,%esp
80105795:	85 c0                	test   %eax,%eax
80105797:	78 77                	js     80105810 <sys_chdir+0xa0>
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	ff 75 f4             	push   -0xc(%ebp)
8010579f:	e8 cc c8 ff ff       	call   80102070 <namei>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	89 c3                	mov    %eax,%ebx
801057a9:	85 c0                	test   %eax,%eax
801057ab:	74 63                	je     80105810 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	50                   	push   %eax
801057b1:	e8 9a bf ff ff       	call   80101750 <ilock>
  if(ip->type != T_DIR){
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057be:	75 30                	jne    801057f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	53                   	push   %ebx
801057c4:	e8 67 c0 ff ff       	call   80101830 <iunlock>
  iput(curproc->cwd);
801057c9:	58                   	pop    %eax
801057ca:	ff 76 68             	push   0x68(%esi)
801057cd:	e8 ae c0 ff ff       	call   80101880 <iput>
  end_op();
801057d2:	e8 c9 d5 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
801057d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	31 c0                	xor    %eax,%eax
}
801057df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057e2:	5b                   	pop    %ebx
801057e3:	5e                   	pop    %esi
801057e4:	5d                   	pop    %ebp
801057e5:	c3                   	ret    
801057e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	53                   	push   %ebx
801057f4:	e8 e7 c1 ff ff       	call   801019e0 <iunlockput>
    end_op();
801057f9:	e8 a2 d5 ff ff       	call   80102da0 <end_op>
    return -1;
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105806:	eb d7                	jmp    801057df <sys_chdir+0x6f>
80105808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580f:	90                   	nop
    end_op();
80105810:	e8 8b d5 ff ff       	call   80102da0 <end_op>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581a:	eb c3                	jmp    801057df <sys_chdir+0x6f>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_exec>:

int
sys_exec(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105825:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010582b:	53                   	push   %ebx
8010582c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105832:	50                   	push   %eax
80105833:	6a 00                	push   $0x0
80105835:	e8 f6 f4 ff ff       	call   80104d30 <argstr>
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	85 c0                	test   %eax,%eax
8010583f:	0f 88 87 00 00 00    	js     801058cc <sys_exec+0xac>
80105845:	83 ec 08             	sub    $0x8,%esp
80105848:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010584e:	50                   	push   %eax
8010584f:	6a 01                	push   $0x1
80105851:	e8 1a f4 ff ff       	call   80104c70 <argint>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	78 6f                	js     801058cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010585d:	83 ec 04             	sub    $0x4,%esp
80105860:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105866:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105868:	68 80 00 00 00       	push   $0x80
8010586d:	6a 00                	push   $0x0
8010586f:	56                   	push   %esi
80105870:	e8 3b f1 ff ff       	call   801049b0 <memset>
80105875:	83 c4 10             	add    $0x10,%esp
80105878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105889:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105890:	50                   	push   %eax
80105891:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105897:	01 f8                	add    %edi,%eax
80105899:	50                   	push   %eax
8010589a:	e8 41 f3 ff ff       	call   80104be0 <fetchint>
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	85 c0                	test   %eax,%eax
801058a4:	78 26                	js     801058cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058ac:	85 c0                	test   %eax,%eax
801058ae:	74 30                	je     801058e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058b0:	83 ec 08             	sub    $0x8,%esp
801058b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801058b6:	52                   	push   %edx
801058b7:	50                   	push   %eax
801058b8:	e8 63 f3 ff ff       	call   80104c20 <fetchstr>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 08                	js     801058cc <sys_exec+0xac>
  for(i=0;; i++){
801058c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058c7:	83 fb 20             	cmp    $0x20,%ebx
801058ca:	75 b4                	jne    80105880 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d4:	5b                   	pop    %ebx
801058d5:	5e                   	pop    %esi
801058d6:	5f                   	pop    %edi
801058d7:	5d                   	pop    %ebp
801058d8:	c3                   	ret    
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801058e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058e7:	00 00 00 00 
  return exec(path, argv);
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	56                   	push   %esi
801058ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058f5:	e8 86 b1 ff ff       	call   80100a80 <exec>
801058fa:	83 c4 10             	add    $0x10,%esp
}
801058fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105900:	5b                   	pop    %ebx
80105901:	5e                   	pop    %esi
80105902:	5f                   	pop    %edi
80105903:	5d                   	pop    %ebp
80105904:	c3                   	ret    
80105905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_pipe>:

int
sys_pipe(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105915:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105918:	53                   	push   %ebx
80105919:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010591c:	6a 08                	push   $0x8
8010591e:	50                   	push   %eax
8010591f:	6a 00                	push   $0x0
80105921:	e8 9a f3 ff ff       	call   80104cc0 <argptr>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	85 c0                	test   %eax,%eax
8010592b:	78 4a                	js     80105977 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010592d:	83 ec 08             	sub    $0x8,%esp
80105930:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105933:	50                   	push   %eax
80105934:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	e8 c3 da ff ff       	call   80103400 <pipealloc>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 33                	js     80105977 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105944:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105947:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105949:	e8 32 e0 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010594e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105950:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105954:	85 f6                	test   %esi,%esi
80105956:	74 28                	je     80105980 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105958:	83 c3 01             	add    $0x1,%ebx
8010595b:	83 fb 10             	cmp    $0x10,%ebx
8010595e:	75 f0                	jne    80105950 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	ff 75 e0             	push   -0x20(%ebp)
80105966:	e8 55 b5 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010596b:	58                   	pop    %eax
8010596c:	ff 75 e4             	push   -0x1c(%ebp)
8010596f:	e8 4c b5 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597c:	eb 53                	jmp    801059d1 <sys_pipe+0xc1>
8010597e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105980:	8d 73 08             	lea    0x8(%ebx),%esi
80105983:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010598a:	e8 f1 df ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010598f:	31 d2                	xor    %edx,%edx
80105991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105998:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010599c:	85 c9                	test   %ecx,%ecx
8010599e:	74 20                	je     801059c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801059a0:	83 c2 01             	add    $0x1,%edx
801059a3:	83 fa 10             	cmp    $0x10,%edx
801059a6:	75 f0                	jne    80105998 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801059a8:	e8 d3 df ff ff       	call   80103980 <myproc>
801059ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059b4:	00 
801059b5:	eb a9                	jmp    80105960 <sys_pipe+0x50>
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801059c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059cf:	31 c0                	xor    %eax,%eax
}
801059d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    
801059d9:	66 90                	xchg   %ax,%ax
801059db:	66 90                	xchg   %ax,%ax
801059dd:	66 90                	xchg   %ax,%ax
801059df:	90                   	nop

801059e0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801059e0:	e9 3b e1 ff ff       	jmp    80103b20 <fork>
801059e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exit>:
}

int
sys_exit(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059f6:	e8 f5 e4 ff ff       	call   80103ef0 <exit>
  return 0;  // not reached
}
801059fb:	31 c0                	xor    %eax,%eax
801059fd:	c9                   	leave  
801059fe:	c3                   	ret    
801059ff:	90                   	nop

80105a00 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a00:	e9 1b e6 ff ff       	jmp    80104020 <wait>
80105a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_kill>:
}

int
sys_kill(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a19:	50                   	push   %eax
80105a1a:	6a 00                	push   $0x0
80105a1c:	e8 4f f2 ff ff       	call   80104c70 <argint>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	85 c0                	test   %eax,%eax
80105a26:	78 18                	js     80105a40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	ff 75 f4             	push   -0xc(%ebp)
80105a2e:	e8 8d e8 ff ff       	call   801042c0 <kill>
80105a33:	83 c4 10             	add    $0x10,%esp
}
80105a36:	c9                   	leave  
80105a37:	c3                   	ret    
80105a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop
80105a40:	c9                   	leave  
    return -1;
80105a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a46:	c3                   	ret    
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_getpid>:

int
sys_getpid(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a56:	e8 25 df ff ff       	call   80103980 <myproc>
80105a5b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_getppid>:

#ifdef GETPPID
int
sys_getppid(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 08             	sub    $0x8,%esp
    int ppid = 1;

    if (myproc()->parent) {
80105a66:	e8 15 df ff ff       	call   80103980 <myproc>
80105a6b:	8b 40 14             	mov    0x14(%eax),%eax
80105a6e:	85 c0                	test   %eax,%eax
80105a70:	74 0e                	je     80105a80 <sys_getppid+0x20>
        ppid = myproc()->parent->pid;
80105a72:	e8 09 df ff ff       	call   80103980 <myproc>
80105a77:	8b 40 14             	mov    0x14(%eax),%eax
80105a7a:	8b 40 10             	mov    0x10(%eax),%eax
    }
    return ppid;
}
80105a7d:	c9                   	leave  
80105a7e:	c3                   	ret    
80105a7f:	90                   	nop
80105a80:	c9                   	leave  
80105a81:	b8 01 00 00 00       	mov    $0x1,%eax
80105a86:	c3                   	ret    
80105a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_sbrk>:
#endif // GETPPID

int
sys_sbrk(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 ce f1 ff ff       	call   80104c70 <argint>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	78 27                	js     80105ad0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105aa9:	e8 d2 de ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
80105aae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ab1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ab3:	ff 75 f4             	push   -0xc(%ebp)
80105ab6:	e8 e5 df ff ff       	call   80103aa0 <growproc>
80105abb:	83 c4 10             	add    $0x10,%esp
80105abe:	85 c0                	test   %eax,%eax
80105ac0:	78 0e                	js     80105ad0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ac2:	89 d8                	mov    %ebx,%eax
80105ac4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac7:	c9                   	leave  
80105ac8:	c3                   	ret    
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ad0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ad5:	eb eb                	jmp    80105ac2 <sys_sbrk+0x32>
80105ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_sleep>:

int
sys_sleep(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ae7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aea:	50                   	push   %eax
80105aeb:	6a 00                	push   $0x0
80105aed:	e8 7e f1 ff ff       	call   80104c70 <argint>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	0f 88 8a 00 00 00    	js     80105b87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	68 80 56 11 80       	push   $0x80115680
80105b05:	e8 e6 ed ff ff       	call   801048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b0d:	8b 1d 60 56 11 80    	mov    0x80115660,%ebx
  while(ticks - ticks0 < n){
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	85 d2                	test   %edx,%edx
80105b18:	75 27                	jne    80105b41 <sys_sleep+0x61>
80105b1a:	eb 54                	jmp    80105b70 <sys_sleep+0x90>
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b20:	83 ec 08             	sub    $0x8,%esp
80105b23:	68 80 56 11 80       	push   $0x80115680
80105b28:	68 60 56 11 80       	push   $0x80115660
80105b2d:	e8 6e e6 ff ff       	call   801041a0 <sleep>
  while(ticks - ticks0 < n){
80105b32:	a1 60 56 11 80       	mov    0x80115660,%eax
80105b37:	83 c4 10             	add    $0x10,%esp
80105b3a:	29 d8                	sub    %ebx,%eax
80105b3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b3f:	73 2f                	jae    80105b70 <sys_sleep+0x90>
    if(myproc()->killed){
80105b41:	e8 3a de ff ff       	call   80103980 <myproc>
80105b46:	8b 40 24             	mov    0x24(%eax),%eax
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	74 d3                	je     80105b20 <sys_sleep+0x40>
      release(&tickslock);
80105b4d:	83 ec 0c             	sub    $0xc,%esp
80105b50:	68 80 56 11 80       	push   $0x80115680
80105b55:	e8 36 ed ff ff       	call   80104890 <release>
  }
  release(&tickslock);
  return 0;
}
80105b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    
80105b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	68 80 56 11 80       	push   $0x80115680
80105b78:	e8 13 ed ff ff       	call   80104890 <release>
  return 0;
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	31 c0                	xor    %eax,%eax
}
80105b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
    return -1;
80105b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8c:	eb f4                	jmp    80105b82 <sys_sleep+0xa2>
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
80105b94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b97:	68 80 56 11 80       	push   $0x80115680
80105b9c:	e8 4f ed ff ff       	call   801048f0 <acquire>
  xticks = ticks;
80105ba1:	8b 1d 60 56 11 80    	mov    0x80115660,%ebx
  release(&tickslock);
80105ba7:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
80105bae:	e8 dd ec ff ff       	call   80104890 <release>
  return xticks;
}
80105bb3:	89 d8                	mov    %ebx,%eax
80105bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb8:	c9                   	leave  
80105bb9:	c3                   	ret    
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bc0 <sys_cps>:

#ifdef CPS
int
sys_cps(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 08             	sub    $0x8,%esp
    proc_cps();
80105bc6:	e8 d5 e8 ff ff       	call   801044a0 <proc_cps>
    return 0;
}
80105bcb:	31 c0                	xor    %eax,%eax
80105bcd:	c9                   	leave  
80105bce:	c3                   	ret    
80105bcf:	90                   	nop

80105bd0 <sys_renice>:
#endif // CPS

#ifdef LOTTERY
int
sys_renice(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 20             	sub    $0x20,%esp
	int nice_val=0;
	int pid=0;
	argint(0,&nice_val);
80105bd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
	int nice_val=0;
80105bd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	argint(0,&nice_val);
80105be0:	50                   	push   %eax
80105be1:	6a 00                	push   $0x0
	int pid=0;
80105be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	argint(0,&nice_val);
80105bea:	e8 81 f0 ff ff       	call   80104c70 <argint>
	argint(1,&pid);
80105bef:	58                   	pop    %eax
80105bf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf3:	5a                   	pop    %edx
80105bf4:	50                   	push   %eax
80105bf5:	6a 01                	push   $0x1
80105bf7:	e8 74 f0 ff ff       	call   80104c70 <argint>
return renice(nice_val,pid);
80105bfc:	59                   	pop    %ecx
80105bfd:	58                   	pop    %eax
80105bfe:	ff 75 f4             	push   -0xc(%ebp)
80105c01:	ff 75 f0             	push   -0x10(%ebp)
80105c04:	e8 f7 e7 ff ff       	call   80104400 <renice>
}
80105c09:	c9                   	leave  
80105c0a:	c3                   	ret    

80105c0b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c0b:	1e                   	push   %ds
  pushl %es
80105c0c:	06                   	push   %es
  pushl %fs
80105c0d:	0f a0                	push   %fs
  pushl %gs
80105c0f:	0f a8                	push   %gs
  pushal
80105c11:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c12:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c16:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c18:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c1a:	54                   	push   %esp
  call trap
80105c1b:	e8 c0 00 00 00       	call   80105ce0 <trap>
  addl $4, %esp
80105c20:	83 c4 04             	add    $0x4,%esp

80105c23 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c23:	61                   	popa   
  popl %gs
80105c24:	0f a9                	pop    %gs
  popl %fs
80105c26:	0f a1                	pop    %fs
  popl %es
80105c28:	07                   	pop    %es
  popl %ds
80105c29:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c2a:	83 c4 08             	add    $0x8,%esp
  iret
80105c2d:	cf                   	iret   
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c31:	31 c0                	xor    %eax,%eax
{
80105c33:	89 e5                	mov    %esp,%ebp
80105c35:	83 ec 08             	sub    $0x8,%esp
80105c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c40:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105c47:	c7 04 c5 c2 56 11 80 	movl   $0x8e000008,-0x7feea93e(,%eax,8)
80105c4e:	08 00 00 8e 
80105c52:	66 89 14 c5 c0 56 11 	mov    %dx,-0x7feea940(,%eax,8)
80105c59:	80 
80105c5a:	c1 ea 10             	shr    $0x10,%edx
80105c5d:	66 89 14 c5 c6 56 11 	mov    %dx,-0x7feea93a(,%eax,8)
80105c64:	80 
  for(i = 0; i < 256; i++)
80105c65:	83 c0 01             	add    $0x1,%eax
80105c68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c6d:	75 d1                	jne    80105c40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c72:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80105c77:	c7 05 c2 58 11 80 08 	movl   $0xef000008,0x801158c2
80105c7e:	00 00 ef 
  initlock(&tickslock, "time");
80105c81:	68 c5 7d 10 80       	push   $0x80107dc5
80105c86:	68 80 56 11 80       	push   $0x80115680
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c8b:	66 a3 c0 58 11 80    	mov    %ax,0x801158c0
80105c91:	c1 e8 10             	shr    $0x10,%eax
80105c94:	66 a3 c6 58 11 80    	mov    %ax,0x801158c6
  initlock(&tickslock, "time");
80105c9a:	e8 81 ea ff ff       	call   80104720 <initlock>
}
80105c9f:	83 c4 10             	add    $0x10,%esp
80105ca2:	c9                   	leave  
80105ca3:	c3                   	ret    
80105ca4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop

80105cb0 <idtinit>:

void
idtinit(void)
{
80105cb0:	55                   	push   %ebp
  pd[0] = size-1;
80105cb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cb6:	89 e5                	mov    %esp,%ebp
80105cb8:	83 ec 10             	sub    $0x10,%esp
80105cbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cbf:	b8 c0 56 11 80       	mov    $0x801156c0,%eax
80105cc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cc8:	c1 e8 10             	shr    $0x10,%eax
80105ccb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ccf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cd5:	c9                   	leave  
80105cd6:	c3                   	ret    
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
80105ce5:	53                   	push   %ebx
80105ce6:	83 ec 1c             	sub    $0x1c,%esp
80105ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cec:	8b 43 30             	mov    0x30(%ebx),%eax
80105cef:	83 f8 40             	cmp    $0x40,%eax
80105cf2:	0f 84 68 01 00 00    	je     80105e60 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cf8:	83 e8 20             	sub    $0x20,%eax
80105cfb:	83 f8 1f             	cmp    $0x1f,%eax
80105cfe:	0f 87 8c 00 00 00    	ja     80105d90 <trap+0xb0>
80105d04:	ff 24 85 6c 7e 10 80 	jmp    *-0x7fef8194(,%eax,4)
80105d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d10:	e8 fb c4 ff ff       	call   80102210 <ideintr>
    lapiceoi();
80105d15:	e8 c6 cb ff ff       	call   801028e0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d1a:	e8 61 dc ff ff       	call   80103980 <myproc>
80105d1f:	85 c0                	test   %eax,%eax
80105d21:	74 1d                	je     80105d40 <trap+0x60>
80105d23:	e8 58 dc ff ff       	call   80103980 <myproc>
80105d28:	8b 50 24             	mov    0x24(%eax),%edx
80105d2b:	85 d2                	test   %edx,%edx
80105d2d:	74 11                	je     80105d40 <trap+0x60>
80105d2f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d33:	83 e0 03             	and    $0x3,%eax
80105d36:	66 83 f8 03          	cmp    $0x3,%ax
80105d3a:	0f 84 e8 01 00 00    	je     80105f28 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d40:	e8 3b dc ff ff       	call   80103980 <myproc>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	74 0f                	je     80105d58 <trap+0x78>
80105d49:	e8 32 dc ff ff       	call   80103980 <myproc>
80105d4e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d52:	0f 84 b8 00 00 00    	je     80105e10 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d58:	e8 23 dc ff ff       	call   80103980 <myproc>
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	74 1d                	je     80105d7e <trap+0x9e>
80105d61:	e8 1a dc ff ff       	call   80103980 <myproc>
80105d66:	8b 40 24             	mov    0x24(%eax),%eax
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	74 11                	je     80105d7e <trap+0x9e>
80105d6d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d71:	83 e0 03             	and    $0x3,%eax
80105d74:	66 83 f8 03          	cmp    $0x3,%ax
80105d78:	0f 84 0f 01 00 00    	je     80105e8d <trap+0x1ad>
    exit();
}
80105d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d81:	5b                   	pop    %ebx
80105d82:	5e                   	pop    %esi
80105d83:	5f                   	pop    %edi
80105d84:	5d                   	pop    %ebp
80105d85:	c3                   	ret    
80105d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d90:	e8 eb db ff ff       	call   80103980 <myproc>
80105d95:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d98:	85 c0                	test   %eax,%eax
80105d9a:	0f 84 a2 01 00 00    	je     80105f42 <trap+0x262>
80105da0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105da4:	0f 84 98 01 00 00    	je     80105f42 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105daa:	0f 20 d1             	mov    %cr2,%ecx
80105dad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105db0:	e8 ab db ff ff       	call   80103960 <cpuid>
80105db5:	8b 73 30             	mov    0x30(%ebx),%esi
80105db8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dbb:	8b 43 34             	mov    0x34(%ebx),%eax
80105dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105dc1:	e8 ba db ff ff       	call   80103980 <myproc>
80105dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105dc9:	e8 b2 db ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105dd4:	51                   	push   %ecx
80105dd5:	57                   	push   %edi
80105dd6:	52                   	push   %edx
80105dd7:	ff 75 e4             	push   -0x1c(%ebp)
80105dda:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ddb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dde:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105de1:	56                   	push   %esi
80105de2:	ff 70 10             	push   0x10(%eax)
80105de5:	68 28 7e 10 80       	push   $0x80107e28
80105dea:	e8 b1 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105def:	83 c4 20             	add    $0x20,%esp
80105df2:	e8 89 db ff ff       	call   80103980 <myproc>
80105df7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dfe:	e8 7d db ff ff       	call   80103980 <myproc>
80105e03:	85 c0                	test   %eax,%eax
80105e05:	0f 85 18 ff ff ff    	jne    80105d23 <trap+0x43>
80105e0b:	e9 30 ff ff ff       	jmp    80105d40 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105e10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e14:	0f 85 3e ff ff ff    	jne    80105d58 <trap+0x78>
    yield();
80105e1a:	e8 31 e3 ff ff       	call   80104150 <yield>
80105e1f:	e9 34 ff ff ff       	jmp    80105d58 <trap+0x78>
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e28:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e2b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e2f:	e8 2c db ff ff       	call   80103960 <cpuid>
80105e34:	57                   	push   %edi
80105e35:	56                   	push   %esi
80105e36:	50                   	push   %eax
80105e37:	68 d0 7d 10 80       	push   $0x80107dd0
80105e3c:	e8 5f a8 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105e41:	e8 9a ca ff ff       	call   801028e0 <lapiceoi>
    break;
80105e46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e49:	e8 32 db ff ff       	call   80103980 <myproc>
80105e4e:	85 c0                	test   %eax,%eax
80105e50:	0f 85 cd fe ff ff    	jne    80105d23 <trap+0x43>
80105e56:	e9 e5 fe ff ff       	jmp    80105d40 <trap+0x60>
80105e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop
    if(myproc()->killed)
80105e60:	e8 1b db ff ff       	call   80103980 <myproc>
80105e65:	8b 70 24             	mov    0x24(%eax),%esi
80105e68:	85 f6                	test   %esi,%esi
80105e6a:	0f 85 c8 00 00 00    	jne    80105f38 <trap+0x258>
    myproc()->tf = tf;
80105e70:	e8 0b db ff ff       	call   80103980 <myproc>
80105e75:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e78:	e8 33 ef ff ff       	call   80104db0 <syscall>
    if(myproc()->killed)
80105e7d:	e8 fe da ff ff       	call   80103980 <myproc>
80105e82:	8b 48 24             	mov    0x24(%eax),%ecx
80105e85:	85 c9                	test   %ecx,%ecx
80105e87:	0f 84 f1 fe ff ff    	je     80105d7e <trap+0x9e>
}
80105e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e90:	5b                   	pop    %ebx
80105e91:	5e                   	pop    %esi
80105e92:	5f                   	pop    %edi
80105e93:	5d                   	pop    %ebp
      exit();
80105e94:	e9 57 e0 ff ff       	jmp    80103ef0 <exit>
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ea0:	e8 3b 02 00 00       	call   801060e0 <uartintr>
    lapiceoi();
80105ea5:	e8 36 ca ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eaa:	e8 d1 da ff ff       	call   80103980 <myproc>
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	0f 85 6c fe ff ff    	jne    80105d23 <trap+0x43>
80105eb7:	e9 84 fe ff ff       	jmp    80105d40 <trap+0x60>
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ec0:	e8 db c8 ff ff       	call   801027a0 <kbdintr>
    lapiceoi();
80105ec5:	e8 16 ca ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eca:	e8 b1 da ff ff       	call   80103980 <myproc>
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	0f 85 4c fe ff ff    	jne    80105d23 <trap+0x43>
80105ed7:	e9 64 fe ff ff       	jmp    80105d40 <trap+0x60>
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ee0:	e8 7b da ff ff       	call   80103960 <cpuid>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	0f 85 28 fe ff ff    	jne    80105d15 <trap+0x35>
      acquire(&tickslock);
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	68 80 56 11 80       	push   $0x80115680
80105ef5:	e8 f6 e9 ff ff       	call   801048f0 <acquire>
      wakeup(&ticks);
80105efa:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
      ticks++;
80105f01:	83 05 60 56 11 80 01 	addl   $0x1,0x80115660
      wakeup(&ticks);
80105f08:	e8 53 e3 ff ff       	call   80104260 <wakeup>
      release(&tickslock);
80105f0d:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
80105f14:	e8 77 e9 ff ff       	call   80104890 <release>
80105f19:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f1c:	e9 f4 fd ff ff       	jmp    80105d15 <trap+0x35>
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f28:	e8 c3 df ff ff       	call   80103ef0 <exit>
80105f2d:	e9 0e fe ff ff       	jmp    80105d40 <trap+0x60>
80105f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f38:	e8 b3 df ff ff       	call   80103ef0 <exit>
80105f3d:	e9 2e ff ff ff       	jmp    80105e70 <trap+0x190>
80105f42:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f45:	e8 16 da ff ff       	call   80103960 <cpuid>
80105f4a:	83 ec 0c             	sub    $0xc,%esp
80105f4d:	56                   	push   %esi
80105f4e:	57                   	push   %edi
80105f4f:	50                   	push   %eax
80105f50:	ff 73 30             	push   0x30(%ebx)
80105f53:	68 f4 7d 10 80       	push   $0x80107df4
80105f58:	e8 43 a7 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105f5d:	83 c4 14             	add    $0x14,%esp
80105f60:	68 ca 7d 10 80       	push   $0x80107dca
80105f65:	e8 16 a4 ff ff       	call   80100380 <panic>
80105f6a:	66 90                	xchg   %ax,%ax
80105f6c:	66 90                	xchg   %ax,%ax
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f70:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80105f75:	85 c0                	test   %eax,%eax
80105f77:	74 17                	je     80105f90 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f79:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f7e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f7f:	a8 01                	test   $0x1,%al
80105f81:	74 0d                	je     80105f90 <uartgetc+0x20>
80105f83:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f88:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f89:	0f b6 c0             	movzbl %al,%eax
80105f8c:	c3                   	ret    
80105f8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f95:	c3                   	ret    
80105f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi

80105fa0 <uartinit>:
{
80105fa0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fa1:	31 c9                	xor    %ecx,%ecx
80105fa3:	89 c8                	mov    %ecx,%eax
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	57                   	push   %edi
80105fa8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105fad:	56                   	push   %esi
80105fae:	89 fa                	mov    %edi,%edx
80105fb0:	53                   	push   %ebx
80105fb1:	83 ec 1c             	sub    $0x1c,%esp
80105fb4:	ee                   	out    %al,(%dx)
80105fb5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105fba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fbf:	89 f2                	mov    %esi,%edx
80105fc1:	ee                   	out    %al,(%dx)
80105fc2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fc7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fcc:	ee                   	out    %al,(%dx)
80105fcd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105fd2:	89 c8                	mov    %ecx,%eax
80105fd4:	89 da                	mov    %ebx,%edx
80105fd6:	ee                   	out    %al,(%dx)
80105fd7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fdc:	89 f2                	mov    %esi,%edx
80105fde:	ee                   	out    %al,(%dx)
80105fdf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fe4:	89 c8                	mov    %ecx,%eax
80105fe6:	ee                   	out    %al,(%dx)
80105fe7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fec:	89 da                	mov    %ebx,%edx
80105fee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ff4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ff5:	3c ff                	cmp    $0xff,%al
80105ff7:	74 78                	je     80106071 <uartinit+0xd1>
  uart = 1;
80105ff9:	c7 05 c0 5e 11 80 01 	movl   $0x1,0x80115ec0
80106000:	00 00 00 
80106003:	89 fa                	mov    %edi,%edx
80106005:	ec                   	in     (%dx),%al
80106006:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010600b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010600c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010600f:	bf ec 7e 10 80       	mov    $0x80107eec,%edi
80106014:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106019:	6a 00                	push   $0x0
8010601b:	6a 04                	push   $0x4
8010601d:	e8 2e c4 ff ff       	call   80102450 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106022:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106026:	83 c4 10             	add    $0x10,%esp
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106030:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80106035:	bb 80 00 00 00       	mov    $0x80,%ebx
8010603a:	85 c0                	test   %eax,%eax
8010603c:	75 14                	jne    80106052 <uartinit+0xb2>
8010603e:	eb 23                	jmp    80106063 <uartinit+0xc3>
    microdelay(10);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	6a 0a                	push   $0xa
80106045:	e8 b6 c8 ff ff       	call   80102900 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010604a:	83 c4 10             	add    $0x10,%esp
8010604d:	83 eb 01             	sub    $0x1,%ebx
80106050:	74 07                	je     80106059 <uartinit+0xb9>
80106052:	89 f2                	mov    %esi,%edx
80106054:	ec                   	in     (%dx),%al
80106055:	a8 20                	test   $0x20,%al
80106057:	74 e7                	je     80106040 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106059:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010605d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106062:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106063:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106067:	83 c7 01             	add    $0x1,%edi
8010606a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010606d:	84 c0                	test   %al,%al
8010606f:	75 bf                	jne    80106030 <uartinit+0x90>
}
80106071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106074:	5b                   	pop    %ebx
80106075:	5e                   	pop    %esi
80106076:	5f                   	pop    %edi
80106077:	5d                   	pop    %ebp
80106078:	c3                   	ret    
80106079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106080 <uartputc>:
  if(!uart)
80106080:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80106085:	85 c0                	test   %eax,%eax
80106087:	74 47                	je     801060d0 <uartputc+0x50>
{
80106089:	55                   	push   %ebp
8010608a:	89 e5                	mov    %esp,%ebp
8010608c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010608d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106092:	53                   	push   %ebx
80106093:	bb 80 00 00 00       	mov    $0x80,%ebx
80106098:	eb 18                	jmp    801060b2 <uartputc+0x32>
8010609a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	6a 0a                	push   $0xa
801060a5:	e8 56 c8 ff ff       	call   80102900 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	83 eb 01             	sub    $0x1,%ebx
801060b0:	74 07                	je     801060b9 <uartputc+0x39>
801060b2:	89 f2                	mov    %esi,%edx
801060b4:	ec                   	in     (%dx),%al
801060b5:	a8 20                	test   $0x20,%al
801060b7:	74 e7                	je     801060a0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060b9:	8b 45 08             	mov    0x8(%ebp),%eax
801060bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060c1:	ee                   	out    %al,(%dx)
}
801060c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060c5:	5b                   	pop    %ebx
801060c6:	5e                   	pop    %esi
801060c7:	5d                   	pop    %ebp
801060c8:	c3                   	ret    
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060d0:	c3                   	ret    
801060d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060df:	90                   	nop

801060e0 <uartintr>:

void
uartintr(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060e6:	68 70 5f 10 80       	push   $0x80105f70
801060eb:	e8 60 a7 ff ff       	call   80100850 <consoleintr>
}
801060f0:	83 c4 10             	add    $0x10,%esp
801060f3:	c9                   	leave  
801060f4:	c3                   	ret    

801060f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $0
801060f7:	6a 00                	push   $0x0
  jmp alltraps
801060f9:	e9 0d fb ff ff       	jmp    80105c0b <alltraps>

801060fe <vector1>:
.globl vector1
vector1:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $1
80106100:	6a 01                	push   $0x1
  jmp alltraps
80106102:	e9 04 fb ff ff       	jmp    80105c0b <alltraps>

80106107 <vector2>:
.globl vector2
vector2:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $2
80106109:	6a 02                	push   $0x2
  jmp alltraps
8010610b:	e9 fb fa ff ff       	jmp    80105c0b <alltraps>

80106110 <vector3>:
.globl vector3
vector3:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $3
80106112:	6a 03                	push   $0x3
  jmp alltraps
80106114:	e9 f2 fa ff ff       	jmp    80105c0b <alltraps>

80106119 <vector4>:
.globl vector4
vector4:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $4
8010611b:	6a 04                	push   $0x4
  jmp alltraps
8010611d:	e9 e9 fa ff ff       	jmp    80105c0b <alltraps>

80106122 <vector5>:
.globl vector5
vector5:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $5
80106124:	6a 05                	push   $0x5
  jmp alltraps
80106126:	e9 e0 fa ff ff       	jmp    80105c0b <alltraps>

8010612b <vector6>:
.globl vector6
vector6:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $6
8010612d:	6a 06                	push   $0x6
  jmp alltraps
8010612f:	e9 d7 fa ff ff       	jmp    80105c0b <alltraps>

80106134 <vector7>:
.globl vector7
vector7:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $7
80106136:	6a 07                	push   $0x7
  jmp alltraps
80106138:	e9 ce fa ff ff       	jmp    80105c0b <alltraps>

8010613d <vector8>:
.globl vector8
vector8:
  pushl $8
8010613d:	6a 08                	push   $0x8
  jmp alltraps
8010613f:	e9 c7 fa ff ff       	jmp    80105c0b <alltraps>

80106144 <vector9>:
.globl vector9
vector9:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $9
80106146:	6a 09                	push   $0x9
  jmp alltraps
80106148:	e9 be fa ff ff       	jmp    80105c0b <alltraps>

8010614d <vector10>:
.globl vector10
vector10:
  pushl $10
8010614d:	6a 0a                	push   $0xa
  jmp alltraps
8010614f:	e9 b7 fa ff ff       	jmp    80105c0b <alltraps>

80106154 <vector11>:
.globl vector11
vector11:
  pushl $11
80106154:	6a 0b                	push   $0xb
  jmp alltraps
80106156:	e9 b0 fa ff ff       	jmp    80105c0b <alltraps>

8010615b <vector12>:
.globl vector12
vector12:
  pushl $12
8010615b:	6a 0c                	push   $0xc
  jmp alltraps
8010615d:	e9 a9 fa ff ff       	jmp    80105c0b <alltraps>

80106162 <vector13>:
.globl vector13
vector13:
  pushl $13
80106162:	6a 0d                	push   $0xd
  jmp alltraps
80106164:	e9 a2 fa ff ff       	jmp    80105c0b <alltraps>

80106169 <vector14>:
.globl vector14
vector14:
  pushl $14
80106169:	6a 0e                	push   $0xe
  jmp alltraps
8010616b:	e9 9b fa ff ff       	jmp    80105c0b <alltraps>

80106170 <vector15>:
.globl vector15
vector15:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $15
80106172:	6a 0f                	push   $0xf
  jmp alltraps
80106174:	e9 92 fa ff ff       	jmp    80105c0b <alltraps>

80106179 <vector16>:
.globl vector16
vector16:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $16
8010617b:	6a 10                	push   $0x10
  jmp alltraps
8010617d:	e9 89 fa ff ff       	jmp    80105c0b <alltraps>

80106182 <vector17>:
.globl vector17
vector17:
  pushl $17
80106182:	6a 11                	push   $0x11
  jmp alltraps
80106184:	e9 82 fa ff ff       	jmp    80105c0b <alltraps>

80106189 <vector18>:
.globl vector18
vector18:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $18
8010618b:	6a 12                	push   $0x12
  jmp alltraps
8010618d:	e9 79 fa ff ff       	jmp    80105c0b <alltraps>

80106192 <vector19>:
.globl vector19
vector19:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $19
80106194:	6a 13                	push   $0x13
  jmp alltraps
80106196:	e9 70 fa ff ff       	jmp    80105c0b <alltraps>

8010619b <vector20>:
.globl vector20
vector20:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $20
8010619d:	6a 14                	push   $0x14
  jmp alltraps
8010619f:	e9 67 fa ff ff       	jmp    80105c0b <alltraps>

801061a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $21
801061a6:	6a 15                	push   $0x15
  jmp alltraps
801061a8:	e9 5e fa ff ff       	jmp    80105c0b <alltraps>

801061ad <vector22>:
.globl vector22
vector22:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $22
801061af:	6a 16                	push   $0x16
  jmp alltraps
801061b1:	e9 55 fa ff ff       	jmp    80105c0b <alltraps>

801061b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $23
801061b8:	6a 17                	push   $0x17
  jmp alltraps
801061ba:	e9 4c fa ff ff       	jmp    80105c0b <alltraps>

801061bf <vector24>:
.globl vector24
vector24:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $24
801061c1:	6a 18                	push   $0x18
  jmp alltraps
801061c3:	e9 43 fa ff ff       	jmp    80105c0b <alltraps>

801061c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $25
801061ca:	6a 19                	push   $0x19
  jmp alltraps
801061cc:	e9 3a fa ff ff       	jmp    80105c0b <alltraps>

801061d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $26
801061d3:	6a 1a                	push   $0x1a
  jmp alltraps
801061d5:	e9 31 fa ff ff       	jmp    80105c0b <alltraps>

801061da <vector27>:
.globl vector27
vector27:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $27
801061dc:	6a 1b                	push   $0x1b
  jmp alltraps
801061de:	e9 28 fa ff ff       	jmp    80105c0b <alltraps>

801061e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $28
801061e5:	6a 1c                	push   $0x1c
  jmp alltraps
801061e7:	e9 1f fa ff ff       	jmp    80105c0b <alltraps>

801061ec <vector29>:
.globl vector29
vector29:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $29
801061ee:	6a 1d                	push   $0x1d
  jmp alltraps
801061f0:	e9 16 fa ff ff       	jmp    80105c0b <alltraps>

801061f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $30
801061f7:	6a 1e                	push   $0x1e
  jmp alltraps
801061f9:	e9 0d fa ff ff       	jmp    80105c0b <alltraps>

801061fe <vector31>:
.globl vector31
vector31:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $31
80106200:	6a 1f                	push   $0x1f
  jmp alltraps
80106202:	e9 04 fa ff ff       	jmp    80105c0b <alltraps>

80106207 <vector32>:
.globl vector32
vector32:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $32
80106209:	6a 20                	push   $0x20
  jmp alltraps
8010620b:	e9 fb f9 ff ff       	jmp    80105c0b <alltraps>

80106210 <vector33>:
.globl vector33
vector33:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $33
80106212:	6a 21                	push   $0x21
  jmp alltraps
80106214:	e9 f2 f9 ff ff       	jmp    80105c0b <alltraps>

80106219 <vector34>:
.globl vector34
vector34:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $34
8010621b:	6a 22                	push   $0x22
  jmp alltraps
8010621d:	e9 e9 f9 ff ff       	jmp    80105c0b <alltraps>

80106222 <vector35>:
.globl vector35
vector35:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $35
80106224:	6a 23                	push   $0x23
  jmp alltraps
80106226:	e9 e0 f9 ff ff       	jmp    80105c0b <alltraps>

8010622b <vector36>:
.globl vector36
vector36:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $36
8010622d:	6a 24                	push   $0x24
  jmp alltraps
8010622f:	e9 d7 f9 ff ff       	jmp    80105c0b <alltraps>

80106234 <vector37>:
.globl vector37
vector37:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $37
80106236:	6a 25                	push   $0x25
  jmp alltraps
80106238:	e9 ce f9 ff ff       	jmp    80105c0b <alltraps>

8010623d <vector38>:
.globl vector38
vector38:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $38
8010623f:	6a 26                	push   $0x26
  jmp alltraps
80106241:	e9 c5 f9 ff ff       	jmp    80105c0b <alltraps>

80106246 <vector39>:
.globl vector39
vector39:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $39
80106248:	6a 27                	push   $0x27
  jmp alltraps
8010624a:	e9 bc f9 ff ff       	jmp    80105c0b <alltraps>

8010624f <vector40>:
.globl vector40
vector40:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $40
80106251:	6a 28                	push   $0x28
  jmp alltraps
80106253:	e9 b3 f9 ff ff       	jmp    80105c0b <alltraps>

80106258 <vector41>:
.globl vector41
vector41:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $41
8010625a:	6a 29                	push   $0x29
  jmp alltraps
8010625c:	e9 aa f9 ff ff       	jmp    80105c0b <alltraps>

80106261 <vector42>:
.globl vector42
vector42:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $42
80106263:	6a 2a                	push   $0x2a
  jmp alltraps
80106265:	e9 a1 f9 ff ff       	jmp    80105c0b <alltraps>

8010626a <vector43>:
.globl vector43
vector43:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $43
8010626c:	6a 2b                	push   $0x2b
  jmp alltraps
8010626e:	e9 98 f9 ff ff       	jmp    80105c0b <alltraps>

80106273 <vector44>:
.globl vector44
vector44:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $44
80106275:	6a 2c                	push   $0x2c
  jmp alltraps
80106277:	e9 8f f9 ff ff       	jmp    80105c0b <alltraps>

8010627c <vector45>:
.globl vector45
vector45:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $45
8010627e:	6a 2d                	push   $0x2d
  jmp alltraps
80106280:	e9 86 f9 ff ff       	jmp    80105c0b <alltraps>

80106285 <vector46>:
.globl vector46
vector46:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $46
80106287:	6a 2e                	push   $0x2e
  jmp alltraps
80106289:	e9 7d f9 ff ff       	jmp    80105c0b <alltraps>

8010628e <vector47>:
.globl vector47
vector47:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $47
80106290:	6a 2f                	push   $0x2f
  jmp alltraps
80106292:	e9 74 f9 ff ff       	jmp    80105c0b <alltraps>

80106297 <vector48>:
.globl vector48
vector48:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $48
80106299:	6a 30                	push   $0x30
  jmp alltraps
8010629b:	e9 6b f9 ff ff       	jmp    80105c0b <alltraps>

801062a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $49
801062a2:	6a 31                	push   $0x31
  jmp alltraps
801062a4:	e9 62 f9 ff ff       	jmp    80105c0b <alltraps>

801062a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $50
801062ab:	6a 32                	push   $0x32
  jmp alltraps
801062ad:	e9 59 f9 ff ff       	jmp    80105c0b <alltraps>

801062b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $51
801062b4:	6a 33                	push   $0x33
  jmp alltraps
801062b6:	e9 50 f9 ff ff       	jmp    80105c0b <alltraps>

801062bb <vector52>:
.globl vector52
vector52:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $52
801062bd:	6a 34                	push   $0x34
  jmp alltraps
801062bf:	e9 47 f9 ff ff       	jmp    80105c0b <alltraps>

801062c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $53
801062c6:	6a 35                	push   $0x35
  jmp alltraps
801062c8:	e9 3e f9 ff ff       	jmp    80105c0b <alltraps>

801062cd <vector54>:
.globl vector54
vector54:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $54
801062cf:	6a 36                	push   $0x36
  jmp alltraps
801062d1:	e9 35 f9 ff ff       	jmp    80105c0b <alltraps>

801062d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $55
801062d8:	6a 37                	push   $0x37
  jmp alltraps
801062da:	e9 2c f9 ff ff       	jmp    80105c0b <alltraps>

801062df <vector56>:
.globl vector56
vector56:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $56
801062e1:	6a 38                	push   $0x38
  jmp alltraps
801062e3:	e9 23 f9 ff ff       	jmp    80105c0b <alltraps>

801062e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $57
801062ea:	6a 39                	push   $0x39
  jmp alltraps
801062ec:	e9 1a f9 ff ff       	jmp    80105c0b <alltraps>

801062f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $58
801062f3:	6a 3a                	push   $0x3a
  jmp alltraps
801062f5:	e9 11 f9 ff ff       	jmp    80105c0b <alltraps>

801062fa <vector59>:
.globl vector59
vector59:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $59
801062fc:	6a 3b                	push   $0x3b
  jmp alltraps
801062fe:	e9 08 f9 ff ff       	jmp    80105c0b <alltraps>

80106303 <vector60>:
.globl vector60
vector60:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $60
80106305:	6a 3c                	push   $0x3c
  jmp alltraps
80106307:	e9 ff f8 ff ff       	jmp    80105c0b <alltraps>

8010630c <vector61>:
.globl vector61
vector61:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $61
8010630e:	6a 3d                	push   $0x3d
  jmp alltraps
80106310:	e9 f6 f8 ff ff       	jmp    80105c0b <alltraps>

80106315 <vector62>:
.globl vector62
vector62:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $62
80106317:	6a 3e                	push   $0x3e
  jmp alltraps
80106319:	e9 ed f8 ff ff       	jmp    80105c0b <alltraps>

8010631e <vector63>:
.globl vector63
vector63:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $63
80106320:	6a 3f                	push   $0x3f
  jmp alltraps
80106322:	e9 e4 f8 ff ff       	jmp    80105c0b <alltraps>

80106327 <vector64>:
.globl vector64
vector64:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $64
80106329:	6a 40                	push   $0x40
  jmp alltraps
8010632b:	e9 db f8 ff ff       	jmp    80105c0b <alltraps>

80106330 <vector65>:
.globl vector65
vector65:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $65
80106332:	6a 41                	push   $0x41
  jmp alltraps
80106334:	e9 d2 f8 ff ff       	jmp    80105c0b <alltraps>

80106339 <vector66>:
.globl vector66
vector66:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $66
8010633b:	6a 42                	push   $0x42
  jmp alltraps
8010633d:	e9 c9 f8 ff ff       	jmp    80105c0b <alltraps>

80106342 <vector67>:
.globl vector67
vector67:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $67
80106344:	6a 43                	push   $0x43
  jmp alltraps
80106346:	e9 c0 f8 ff ff       	jmp    80105c0b <alltraps>

8010634b <vector68>:
.globl vector68
vector68:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $68
8010634d:	6a 44                	push   $0x44
  jmp alltraps
8010634f:	e9 b7 f8 ff ff       	jmp    80105c0b <alltraps>

80106354 <vector69>:
.globl vector69
vector69:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $69
80106356:	6a 45                	push   $0x45
  jmp alltraps
80106358:	e9 ae f8 ff ff       	jmp    80105c0b <alltraps>

8010635d <vector70>:
.globl vector70
vector70:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $70
8010635f:	6a 46                	push   $0x46
  jmp alltraps
80106361:	e9 a5 f8 ff ff       	jmp    80105c0b <alltraps>

80106366 <vector71>:
.globl vector71
vector71:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $71
80106368:	6a 47                	push   $0x47
  jmp alltraps
8010636a:	e9 9c f8 ff ff       	jmp    80105c0b <alltraps>

8010636f <vector72>:
.globl vector72
vector72:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $72
80106371:	6a 48                	push   $0x48
  jmp alltraps
80106373:	e9 93 f8 ff ff       	jmp    80105c0b <alltraps>

80106378 <vector73>:
.globl vector73
vector73:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $73
8010637a:	6a 49                	push   $0x49
  jmp alltraps
8010637c:	e9 8a f8 ff ff       	jmp    80105c0b <alltraps>

80106381 <vector74>:
.globl vector74
vector74:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $74
80106383:	6a 4a                	push   $0x4a
  jmp alltraps
80106385:	e9 81 f8 ff ff       	jmp    80105c0b <alltraps>

8010638a <vector75>:
.globl vector75
vector75:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $75
8010638c:	6a 4b                	push   $0x4b
  jmp alltraps
8010638e:	e9 78 f8 ff ff       	jmp    80105c0b <alltraps>

80106393 <vector76>:
.globl vector76
vector76:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $76
80106395:	6a 4c                	push   $0x4c
  jmp alltraps
80106397:	e9 6f f8 ff ff       	jmp    80105c0b <alltraps>

8010639c <vector77>:
.globl vector77
vector77:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $77
8010639e:	6a 4d                	push   $0x4d
  jmp alltraps
801063a0:	e9 66 f8 ff ff       	jmp    80105c0b <alltraps>

801063a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $78
801063a7:	6a 4e                	push   $0x4e
  jmp alltraps
801063a9:	e9 5d f8 ff ff       	jmp    80105c0b <alltraps>

801063ae <vector79>:
.globl vector79
vector79:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $79
801063b0:	6a 4f                	push   $0x4f
  jmp alltraps
801063b2:	e9 54 f8 ff ff       	jmp    80105c0b <alltraps>

801063b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $80
801063b9:	6a 50                	push   $0x50
  jmp alltraps
801063bb:	e9 4b f8 ff ff       	jmp    80105c0b <alltraps>

801063c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $81
801063c2:	6a 51                	push   $0x51
  jmp alltraps
801063c4:	e9 42 f8 ff ff       	jmp    80105c0b <alltraps>

801063c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $82
801063cb:	6a 52                	push   $0x52
  jmp alltraps
801063cd:	e9 39 f8 ff ff       	jmp    80105c0b <alltraps>

801063d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $83
801063d4:	6a 53                	push   $0x53
  jmp alltraps
801063d6:	e9 30 f8 ff ff       	jmp    80105c0b <alltraps>

801063db <vector84>:
.globl vector84
vector84:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $84
801063dd:	6a 54                	push   $0x54
  jmp alltraps
801063df:	e9 27 f8 ff ff       	jmp    80105c0b <alltraps>

801063e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $85
801063e6:	6a 55                	push   $0x55
  jmp alltraps
801063e8:	e9 1e f8 ff ff       	jmp    80105c0b <alltraps>

801063ed <vector86>:
.globl vector86
vector86:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $86
801063ef:	6a 56                	push   $0x56
  jmp alltraps
801063f1:	e9 15 f8 ff ff       	jmp    80105c0b <alltraps>

801063f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $87
801063f8:	6a 57                	push   $0x57
  jmp alltraps
801063fa:	e9 0c f8 ff ff       	jmp    80105c0b <alltraps>

801063ff <vector88>:
.globl vector88
vector88:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $88
80106401:	6a 58                	push   $0x58
  jmp alltraps
80106403:	e9 03 f8 ff ff       	jmp    80105c0b <alltraps>

80106408 <vector89>:
.globl vector89
vector89:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $89
8010640a:	6a 59                	push   $0x59
  jmp alltraps
8010640c:	e9 fa f7 ff ff       	jmp    80105c0b <alltraps>

80106411 <vector90>:
.globl vector90
vector90:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $90
80106413:	6a 5a                	push   $0x5a
  jmp alltraps
80106415:	e9 f1 f7 ff ff       	jmp    80105c0b <alltraps>

8010641a <vector91>:
.globl vector91
vector91:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $91
8010641c:	6a 5b                	push   $0x5b
  jmp alltraps
8010641e:	e9 e8 f7 ff ff       	jmp    80105c0b <alltraps>

80106423 <vector92>:
.globl vector92
vector92:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $92
80106425:	6a 5c                	push   $0x5c
  jmp alltraps
80106427:	e9 df f7 ff ff       	jmp    80105c0b <alltraps>

8010642c <vector93>:
.globl vector93
vector93:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $93
8010642e:	6a 5d                	push   $0x5d
  jmp alltraps
80106430:	e9 d6 f7 ff ff       	jmp    80105c0b <alltraps>

80106435 <vector94>:
.globl vector94
vector94:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $94
80106437:	6a 5e                	push   $0x5e
  jmp alltraps
80106439:	e9 cd f7 ff ff       	jmp    80105c0b <alltraps>

8010643e <vector95>:
.globl vector95
vector95:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $95
80106440:	6a 5f                	push   $0x5f
  jmp alltraps
80106442:	e9 c4 f7 ff ff       	jmp    80105c0b <alltraps>

80106447 <vector96>:
.globl vector96
vector96:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $96
80106449:	6a 60                	push   $0x60
  jmp alltraps
8010644b:	e9 bb f7 ff ff       	jmp    80105c0b <alltraps>

80106450 <vector97>:
.globl vector97
vector97:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $97
80106452:	6a 61                	push   $0x61
  jmp alltraps
80106454:	e9 b2 f7 ff ff       	jmp    80105c0b <alltraps>

80106459 <vector98>:
.globl vector98
vector98:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $98
8010645b:	6a 62                	push   $0x62
  jmp alltraps
8010645d:	e9 a9 f7 ff ff       	jmp    80105c0b <alltraps>

80106462 <vector99>:
.globl vector99
vector99:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $99
80106464:	6a 63                	push   $0x63
  jmp alltraps
80106466:	e9 a0 f7 ff ff       	jmp    80105c0b <alltraps>

8010646b <vector100>:
.globl vector100
vector100:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $100
8010646d:	6a 64                	push   $0x64
  jmp alltraps
8010646f:	e9 97 f7 ff ff       	jmp    80105c0b <alltraps>

80106474 <vector101>:
.globl vector101
vector101:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $101
80106476:	6a 65                	push   $0x65
  jmp alltraps
80106478:	e9 8e f7 ff ff       	jmp    80105c0b <alltraps>

8010647d <vector102>:
.globl vector102
vector102:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $102
8010647f:	6a 66                	push   $0x66
  jmp alltraps
80106481:	e9 85 f7 ff ff       	jmp    80105c0b <alltraps>

80106486 <vector103>:
.globl vector103
vector103:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $103
80106488:	6a 67                	push   $0x67
  jmp alltraps
8010648a:	e9 7c f7 ff ff       	jmp    80105c0b <alltraps>

8010648f <vector104>:
.globl vector104
vector104:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $104
80106491:	6a 68                	push   $0x68
  jmp alltraps
80106493:	e9 73 f7 ff ff       	jmp    80105c0b <alltraps>

80106498 <vector105>:
.globl vector105
vector105:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $105
8010649a:	6a 69                	push   $0x69
  jmp alltraps
8010649c:	e9 6a f7 ff ff       	jmp    80105c0b <alltraps>

801064a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $106
801064a3:	6a 6a                	push   $0x6a
  jmp alltraps
801064a5:	e9 61 f7 ff ff       	jmp    80105c0b <alltraps>

801064aa <vector107>:
.globl vector107
vector107:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $107
801064ac:	6a 6b                	push   $0x6b
  jmp alltraps
801064ae:	e9 58 f7 ff ff       	jmp    80105c0b <alltraps>

801064b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $108
801064b5:	6a 6c                	push   $0x6c
  jmp alltraps
801064b7:	e9 4f f7 ff ff       	jmp    80105c0b <alltraps>

801064bc <vector109>:
.globl vector109
vector109:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $109
801064be:	6a 6d                	push   $0x6d
  jmp alltraps
801064c0:	e9 46 f7 ff ff       	jmp    80105c0b <alltraps>

801064c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $110
801064c7:	6a 6e                	push   $0x6e
  jmp alltraps
801064c9:	e9 3d f7 ff ff       	jmp    80105c0b <alltraps>

801064ce <vector111>:
.globl vector111
vector111:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $111
801064d0:	6a 6f                	push   $0x6f
  jmp alltraps
801064d2:	e9 34 f7 ff ff       	jmp    80105c0b <alltraps>

801064d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $112
801064d9:	6a 70                	push   $0x70
  jmp alltraps
801064db:	e9 2b f7 ff ff       	jmp    80105c0b <alltraps>

801064e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $113
801064e2:	6a 71                	push   $0x71
  jmp alltraps
801064e4:	e9 22 f7 ff ff       	jmp    80105c0b <alltraps>

801064e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $114
801064eb:	6a 72                	push   $0x72
  jmp alltraps
801064ed:	e9 19 f7 ff ff       	jmp    80105c0b <alltraps>

801064f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $115
801064f4:	6a 73                	push   $0x73
  jmp alltraps
801064f6:	e9 10 f7 ff ff       	jmp    80105c0b <alltraps>

801064fb <vector116>:
.globl vector116
vector116:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $116
801064fd:	6a 74                	push   $0x74
  jmp alltraps
801064ff:	e9 07 f7 ff ff       	jmp    80105c0b <alltraps>

80106504 <vector117>:
.globl vector117
vector117:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $117
80106506:	6a 75                	push   $0x75
  jmp alltraps
80106508:	e9 fe f6 ff ff       	jmp    80105c0b <alltraps>

8010650d <vector118>:
.globl vector118
vector118:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $118
8010650f:	6a 76                	push   $0x76
  jmp alltraps
80106511:	e9 f5 f6 ff ff       	jmp    80105c0b <alltraps>

80106516 <vector119>:
.globl vector119
vector119:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $119
80106518:	6a 77                	push   $0x77
  jmp alltraps
8010651a:	e9 ec f6 ff ff       	jmp    80105c0b <alltraps>

8010651f <vector120>:
.globl vector120
vector120:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $120
80106521:	6a 78                	push   $0x78
  jmp alltraps
80106523:	e9 e3 f6 ff ff       	jmp    80105c0b <alltraps>

80106528 <vector121>:
.globl vector121
vector121:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $121
8010652a:	6a 79                	push   $0x79
  jmp alltraps
8010652c:	e9 da f6 ff ff       	jmp    80105c0b <alltraps>

80106531 <vector122>:
.globl vector122
vector122:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $122
80106533:	6a 7a                	push   $0x7a
  jmp alltraps
80106535:	e9 d1 f6 ff ff       	jmp    80105c0b <alltraps>

8010653a <vector123>:
.globl vector123
vector123:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $123
8010653c:	6a 7b                	push   $0x7b
  jmp alltraps
8010653e:	e9 c8 f6 ff ff       	jmp    80105c0b <alltraps>

80106543 <vector124>:
.globl vector124
vector124:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $124
80106545:	6a 7c                	push   $0x7c
  jmp alltraps
80106547:	e9 bf f6 ff ff       	jmp    80105c0b <alltraps>

8010654c <vector125>:
.globl vector125
vector125:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $125
8010654e:	6a 7d                	push   $0x7d
  jmp alltraps
80106550:	e9 b6 f6 ff ff       	jmp    80105c0b <alltraps>

80106555 <vector126>:
.globl vector126
vector126:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $126
80106557:	6a 7e                	push   $0x7e
  jmp alltraps
80106559:	e9 ad f6 ff ff       	jmp    80105c0b <alltraps>

8010655e <vector127>:
.globl vector127
vector127:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $127
80106560:	6a 7f                	push   $0x7f
  jmp alltraps
80106562:	e9 a4 f6 ff ff       	jmp    80105c0b <alltraps>

80106567 <vector128>:
.globl vector128
vector128:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $128
80106569:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010656e:	e9 98 f6 ff ff       	jmp    80105c0b <alltraps>

80106573 <vector129>:
.globl vector129
vector129:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $129
80106575:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010657a:	e9 8c f6 ff ff       	jmp    80105c0b <alltraps>

8010657f <vector130>:
.globl vector130
vector130:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $130
80106581:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106586:	e9 80 f6 ff ff       	jmp    80105c0b <alltraps>

8010658b <vector131>:
.globl vector131
vector131:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $131
8010658d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106592:	e9 74 f6 ff ff       	jmp    80105c0b <alltraps>

80106597 <vector132>:
.globl vector132
vector132:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $132
80106599:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010659e:	e9 68 f6 ff ff       	jmp    80105c0b <alltraps>

801065a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $133
801065a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065aa:	e9 5c f6 ff ff       	jmp    80105c0b <alltraps>

801065af <vector134>:
.globl vector134
vector134:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $134
801065b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065b6:	e9 50 f6 ff ff       	jmp    80105c0b <alltraps>

801065bb <vector135>:
.globl vector135
vector135:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $135
801065bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065c2:	e9 44 f6 ff ff       	jmp    80105c0b <alltraps>

801065c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $136
801065c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ce:	e9 38 f6 ff ff       	jmp    80105c0b <alltraps>

801065d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $137
801065d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065da:	e9 2c f6 ff ff       	jmp    80105c0b <alltraps>

801065df <vector138>:
.globl vector138
vector138:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $138
801065e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065e6:	e9 20 f6 ff ff       	jmp    80105c0b <alltraps>

801065eb <vector139>:
.globl vector139
vector139:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $139
801065ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065f2:	e9 14 f6 ff ff       	jmp    80105c0b <alltraps>

801065f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $140
801065f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065fe:	e9 08 f6 ff ff       	jmp    80105c0b <alltraps>

80106603 <vector141>:
.globl vector141
vector141:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $141
80106605:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010660a:	e9 fc f5 ff ff       	jmp    80105c0b <alltraps>

8010660f <vector142>:
.globl vector142
vector142:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $142
80106611:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106616:	e9 f0 f5 ff ff       	jmp    80105c0b <alltraps>

8010661b <vector143>:
.globl vector143
vector143:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $143
8010661d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106622:	e9 e4 f5 ff ff       	jmp    80105c0b <alltraps>

80106627 <vector144>:
.globl vector144
vector144:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $144
80106629:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010662e:	e9 d8 f5 ff ff       	jmp    80105c0b <alltraps>

80106633 <vector145>:
.globl vector145
vector145:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $145
80106635:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010663a:	e9 cc f5 ff ff       	jmp    80105c0b <alltraps>

8010663f <vector146>:
.globl vector146
vector146:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $146
80106641:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106646:	e9 c0 f5 ff ff       	jmp    80105c0b <alltraps>

8010664b <vector147>:
.globl vector147
vector147:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $147
8010664d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106652:	e9 b4 f5 ff ff       	jmp    80105c0b <alltraps>

80106657 <vector148>:
.globl vector148
vector148:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $148
80106659:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010665e:	e9 a8 f5 ff ff       	jmp    80105c0b <alltraps>

80106663 <vector149>:
.globl vector149
vector149:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $149
80106665:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010666a:	e9 9c f5 ff ff       	jmp    80105c0b <alltraps>

8010666f <vector150>:
.globl vector150
vector150:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $150
80106671:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106676:	e9 90 f5 ff ff       	jmp    80105c0b <alltraps>

8010667b <vector151>:
.globl vector151
vector151:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $151
8010667d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106682:	e9 84 f5 ff ff       	jmp    80105c0b <alltraps>

80106687 <vector152>:
.globl vector152
vector152:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $152
80106689:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010668e:	e9 78 f5 ff ff       	jmp    80105c0b <alltraps>

80106693 <vector153>:
.globl vector153
vector153:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $153
80106695:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010669a:	e9 6c f5 ff ff       	jmp    80105c0b <alltraps>

8010669f <vector154>:
.globl vector154
vector154:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $154
801066a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066a6:	e9 60 f5 ff ff       	jmp    80105c0b <alltraps>

801066ab <vector155>:
.globl vector155
vector155:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $155
801066ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066b2:	e9 54 f5 ff ff       	jmp    80105c0b <alltraps>

801066b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $156
801066b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066be:	e9 48 f5 ff ff       	jmp    80105c0b <alltraps>

801066c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $157
801066c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ca:	e9 3c f5 ff ff       	jmp    80105c0b <alltraps>

801066cf <vector158>:
.globl vector158
vector158:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $158
801066d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066d6:	e9 30 f5 ff ff       	jmp    80105c0b <alltraps>

801066db <vector159>:
.globl vector159
vector159:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $159
801066dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066e2:	e9 24 f5 ff ff       	jmp    80105c0b <alltraps>

801066e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $160
801066e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066ee:	e9 18 f5 ff ff       	jmp    80105c0b <alltraps>

801066f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $161
801066f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066fa:	e9 0c f5 ff ff       	jmp    80105c0b <alltraps>

801066ff <vector162>:
.globl vector162
vector162:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $162
80106701:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106706:	e9 00 f5 ff ff       	jmp    80105c0b <alltraps>

8010670b <vector163>:
.globl vector163
vector163:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $163
8010670d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106712:	e9 f4 f4 ff ff       	jmp    80105c0b <alltraps>

80106717 <vector164>:
.globl vector164
vector164:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $164
80106719:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010671e:	e9 e8 f4 ff ff       	jmp    80105c0b <alltraps>

80106723 <vector165>:
.globl vector165
vector165:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $165
80106725:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010672a:	e9 dc f4 ff ff       	jmp    80105c0b <alltraps>

8010672f <vector166>:
.globl vector166
vector166:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $166
80106731:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106736:	e9 d0 f4 ff ff       	jmp    80105c0b <alltraps>

8010673b <vector167>:
.globl vector167
vector167:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $167
8010673d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106742:	e9 c4 f4 ff ff       	jmp    80105c0b <alltraps>

80106747 <vector168>:
.globl vector168
vector168:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $168
80106749:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010674e:	e9 b8 f4 ff ff       	jmp    80105c0b <alltraps>

80106753 <vector169>:
.globl vector169
vector169:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $169
80106755:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010675a:	e9 ac f4 ff ff       	jmp    80105c0b <alltraps>

8010675f <vector170>:
.globl vector170
vector170:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $170
80106761:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106766:	e9 a0 f4 ff ff       	jmp    80105c0b <alltraps>

8010676b <vector171>:
.globl vector171
vector171:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $171
8010676d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106772:	e9 94 f4 ff ff       	jmp    80105c0b <alltraps>

80106777 <vector172>:
.globl vector172
vector172:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $172
80106779:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010677e:	e9 88 f4 ff ff       	jmp    80105c0b <alltraps>

80106783 <vector173>:
.globl vector173
vector173:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $173
80106785:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010678a:	e9 7c f4 ff ff       	jmp    80105c0b <alltraps>

8010678f <vector174>:
.globl vector174
vector174:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $174
80106791:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106796:	e9 70 f4 ff ff       	jmp    80105c0b <alltraps>

8010679b <vector175>:
.globl vector175
vector175:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $175
8010679d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067a2:	e9 64 f4 ff ff       	jmp    80105c0b <alltraps>

801067a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $176
801067a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ae:	e9 58 f4 ff ff       	jmp    80105c0b <alltraps>

801067b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $177
801067b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067ba:	e9 4c f4 ff ff       	jmp    80105c0b <alltraps>

801067bf <vector178>:
.globl vector178
vector178:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $178
801067c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067c6:	e9 40 f4 ff ff       	jmp    80105c0b <alltraps>

801067cb <vector179>:
.globl vector179
vector179:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $179
801067cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067d2:	e9 34 f4 ff ff       	jmp    80105c0b <alltraps>

801067d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $180
801067d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067de:	e9 28 f4 ff ff       	jmp    80105c0b <alltraps>

801067e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $181
801067e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067ea:	e9 1c f4 ff ff       	jmp    80105c0b <alltraps>

801067ef <vector182>:
.globl vector182
vector182:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $182
801067f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067f6:	e9 10 f4 ff ff       	jmp    80105c0b <alltraps>

801067fb <vector183>:
.globl vector183
vector183:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $183
801067fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106802:	e9 04 f4 ff ff       	jmp    80105c0b <alltraps>

80106807 <vector184>:
.globl vector184
vector184:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $184
80106809:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010680e:	e9 f8 f3 ff ff       	jmp    80105c0b <alltraps>

80106813 <vector185>:
.globl vector185
vector185:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $185
80106815:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010681a:	e9 ec f3 ff ff       	jmp    80105c0b <alltraps>

8010681f <vector186>:
.globl vector186
vector186:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $186
80106821:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106826:	e9 e0 f3 ff ff       	jmp    80105c0b <alltraps>

8010682b <vector187>:
.globl vector187
vector187:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $187
8010682d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106832:	e9 d4 f3 ff ff       	jmp    80105c0b <alltraps>

80106837 <vector188>:
.globl vector188
vector188:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $188
80106839:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010683e:	e9 c8 f3 ff ff       	jmp    80105c0b <alltraps>

80106843 <vector189>:
.globl vector189
vector189:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $189
80106845:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010684a:	e9 bc f3 ff ff       	jmp    80105c0b <alltraps>

8010684f <vector190>:
.globl vector190
vector190:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $190
80106851:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106856:	e9 b0 f3 ff ff       	jmp    80105c0b <alltraps>

8010685b <vector191>:
.globl vector191
vector191:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $191
8010685d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106862:	e9 a4 f3 ff ff       	jmp    80105c0b <alltraps>

80106867 <vector192>:
.globl vector192
vector192:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $192
80106869:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010686e:	e9 98 f3 ff ff       	jmp    80105c0b <alltraps>

80106873 <vector193>:
.globl vector193
vector193:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $193
80106875:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010687a:	e9 8c f3 ff ff       	jmp    80105c0b <alltraps>

8010687f <vector194>:
.globl vector194
vector194:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $194
80106881:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106886:	e9 80 f3 ff ff       	jmp    80105c0b <alltraps>

8010688b <vector195>:
.globl vector195
vector195:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $195
8010688d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106892:	e9 74 f3 ff ff       	jmp    80105c0b <alltraps>

80106897 <vector196>:
.globl vector196
vector196:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $196
80106899:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010689e:	e9 68 f3 ff ff       	jmp    80105c0b <alltraps>

801068a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $197
801068a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068aa:	e9 5c f3 ff ff       	jmp    80105c0b <alltraps>

801068af <vector198>:
.globl vector198
vector198:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $198
801068b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068b6:	e9 50 f3 ff ff       	jmp    80105c0b <alltraps>

801068bb <vector199>:
.globl vector199
vector199:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $199
801068bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068c2:	e9 44 f3 ff ff       	jmp    80105c0b <alltraps>

801068c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $200
801068c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ce:	e9 38 f3 ff ff       	jmp    80105c0b <alltraps>

801068d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $201
801068d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068da:	e9 2c f3 ff ff       	jmp    80105c0b <alltraps>

801068df <vector202>:
.globl vector202
vector202:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $202
801068e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068e6:	e9 20 f3 ff ff       	jmp    80105c0b <alltraps>

801068eb <vector203>:
.globl vector203
vector203:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $203
801068ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068f2:	e9 14 f3 ff ff       	jmp    80105c0b <alltraps>

801068f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $204
801068f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068fe:	e9 08 f3 ff ff       	jmp    80105c0b <alltraps>

80106903 <vector205>:
.globl vector205
vector205:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $205
80106905:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010690a:	e9 fc f2 ff ff       	jmp    80105c0b <alltraps>

8010690f <vector206>:
.globl vector206
vector206:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $206
80106911:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106916:	e9 f0 f2 ff ff       	jmp    80105c0b <alltraps>

8010691b <vector207>:
.globl vector207
vector207:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $207
8010691d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106922:	e9 e4 f2 ff ff       	jmp    80105c0b <alltraps>

80106927 <vector208>:
.globl vector208
vector208:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $208
80106929:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010692e:	e9 d8 f2 ff ff       	jmp    80105c0b <alltraps>

80106933 <vector209>:
.globl vector209
vector209:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $209
80106935:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010693a:	e9 cc f2 ff ff       	jmp    80105c0b <alltraps>

8010693f <vector210>:
.globl vector210
vector210:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $210
80106941:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106946:	e9 c0 f2 ff ff       	jmp    80105c0b <alltraps>

8010694b <vector211>:
.globl vector211
vector211:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $211
8010694d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106952:	e9 b4 f2 ff ff       	jmp    80105c0b <alltraps>

80106957 <vector212>:
.globl vector212
vector212:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $212
80106959:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010695e:	e9 a8 f2 ff ff       	jmp    80105c0b <alltraps>

80106963 <vector213>:
.globl vector213
vector213:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $213
80106965:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010696a:	e9 9c f2 ff ff       	jmp    80105c0b <alltraps>

8010696f <vector214>:
.globl vector214
vector214:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $214
80106971:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106976:	e9 90 f2 ff ff       	jmp    80105c0b <alltraps>

8010697b <vector215>:
.globl vector215
vector215:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $215
8010697d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106982:	e9 84 f2 ff ff       	jmp    80105c0b <alltraps>

80106987 <vector216>:
.globl vector216
vector216:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $216
80106989:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010698e:	e9 78 f2 ff ff       	jmp    80105c0b <alltraps>

80106993 <vector217>:
.globl vector217
vector217:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $217
80106995:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010699a:	e9 6c f2 ff ff       	jmp    80105c0b <alltraps>

8010699f <vector218>:
.globl vector218
vector218:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $218
801069a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069a6:	e9 60 f2 ff ff       	jmp    80105c0b <alltraps>

801069ab <vector219>:
.globl vector219
vector219:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $219
801069ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069b2:	e9 54 f2 ff ff       	jmp    80105c0b <alltraps>

801069b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $220
801069b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069be:	e9 48 f2 ff ff       	jmp    80105c0b <alltraps>

801069c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $221
801069c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ca:	e9 3c f2 ff ff       	jmp    80105c0b <alltraps>

801069cf <vector222>:
.globl vector222
vector222:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $222
801069d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069d6:	e9 30 f2 ff ff       	jmp    80105c0b <alltraps>

801069db <vector223>:
.globl vector223
vector223:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $223
801069dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069e2:	e9 24 f2 ff ff       	jmp    80105c0b <alltraps>

801069e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $224
801069e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069ee:	e9 18 f2 ff ff       	jmp    80105c0b <alltraps>

801069f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $225
801069f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069fa:	e9 0c f2 ff ff       	jmp    80105c0b <alltraps>

801069ff <vector226>:
.globl vector226
vector226:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $226
80106a01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a06:	e9 00 f2 ff ff       	jmp    80105c0b <alltraps>

80106a0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $227
80106a0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a12:	e9 f4 f1 ff ff       	jmp    80105c0b <alltraps>

80106a17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $228
80106a19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a1e:	e9 e8 f1 ff ff       	jmp    80105c0b <alltraps>

80106a23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $229
80106a25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a2a:	e9 dc f1 ff ff       	jmp    80105c0b <alltraps>

80106a2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $230
80106a31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a36:	e9 d0 f1 ff ff       	jmp    80105c0b <alltraps>

80106a3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $231
80106a3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a42:	e9 c4 f1 ff ff       	jmp    80105c0b <alltraps>

80106a47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $232
80106a49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a4e:	e9 b8 f1 ff ff       	jmp    80105c0b <alltraps>

80106a53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $233
80106a55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a5a:	e9 ac f1 ff ff       	jmp    80105c0b <alltraps>

80106a5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $234
80106a61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a66:	e9 a0 f1 ff ff       	jmp    80105c0b <alltraps>

80106a6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $235
80106a6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a72:	e9 94 f1 ff ff       	jmp    80105c0b <alltraps>

80106a77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $236
80106a79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a7e:	e9 88 f1 ff ff       	jmp    80105c0b <alltraps>

80106a83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $237
80106a85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a8a:	e9 7c f1 ff ff       	jmp    80105c0b <alltraps>

80106a8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $238
80106a91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a96:	e9 70 f1 ff ff       	jmp    80105c0b <alltraps>

80106a9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $239
80106a9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106aa2:	e9 64 f1 ff ff       	jmp    80105c0b <alltraps>

80106aa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $240
80106aa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106aae:	e9 58 f1 ff ff       	jmp    80105c0b <alltraps>

80106ab3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $241
80106ab5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aba:	e9 4c f1 ff ff       	jmp    80105c0b <alltraps>

80106abf <vector242>:
.globl vector242
vector242:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $242
80106ac1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ac6:	e9 40 f1 ff ff       	jmp    80105c0b <alltraps>

80106acb <vector243>:
.globl vector243
vector243:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $243
80106acd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ad2:	e9 34 f1 ff ff       	jmp    80105c0b <alltraps>

80106ad7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $244
80106ad9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ade:	e9 28 f1 ff ff       	jmp    80105c0b <alltraps>

80106ae3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $245
80106ae5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aea:	e9 1c f1 ff ff       	jmp    80105c0b <alltraps>

80106aef <vector246>:
.globl vector246
vector246:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $246
80106af1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106af6:	e9 10 f1 ff ff       	jmp    80105c0b <alltraps>

80106afb <vector247>:
.globl vector247
vector247:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $247
80106afd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b02:	e9 04 f1 ff ff       	jmp    80105c0b <alltraps>

80106b07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $248
80106b09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b0e:	e9 f8 f0 ff ff       	jmp    80105c0b <alltraps>

80106b13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $249
80106b15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b1a:	e9 ec f0 ff ff       	jmp    80105c0b <alltraps>

80106b1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $250
80106b21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b26:	e9 e0 f0 ff ff       	jmp    80105c0b <alltraps>

80106b2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $251
80106b2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b32:	e9 d4 f0 ff ff       	jmp    80105c0b <alltraps>

80106b37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $252
80106b39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b3e:	e9 c8 f0 ff ff       	jmp    80105c0b <alltraps>

80106b43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $253
80106b45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b4a:	e9 bc f0 ff ff       	jmp    80105c0b <alltraps>

80106b4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $254
80106b51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b56:	e9 b0 f0 ff ff       	jmp    80105c0b <alltraps>

80106b5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $255
80106b5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b62:	e9 a4 f0 ff ff       	jmp    80105c0b <alltraps>
80106b67:	66 90                	xchg   %ax,%ax
80106b69:	66 90                	xchg   %ax,%ax
80106b6b:	66 90                	xchg   %ax,%ax
80106b6d:	66 90                	xchg   %ax,%ax
80106b6f:	90                   	nop

80106b70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b82:	83 ec 1c             	sub    $0x1c,%esp
80106b85:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b88:	39 d3                	cmp    %edx,%ebx
80106b8a:	73 49                	jae    80106bd5 <deallocuvm.part.0+0x65>
80106b8c:	89 c7                	mov    %eax,%edi
80106b8e:	eb 0c                	jmp    80106b9c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b90:	83 c0 01             	add    $0x1,%eax
80106b93:	c1 e0 16             	shl    $0x16,%eax
80106b96:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b98:	39 da                	cmp    %ebx,%edx
80106b9a:	76 39                	jbe    80106bd5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106b9c:	89 d8                	mov    %ebx,%eax
80106b9e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ba1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106ba4:	f6 c1 01             	test   $0x1,%cl
80106ba7:	74 e7                	je     80106b90 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106ba9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106bb1:	c1 ee 0a             	shr    $0xa,%esi
80106bb4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106bba:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106bc1:	85 f6                	test   %esi,%esi
80106bc3:	74 cb                	je     80106b90 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106bc5:	8b 06                	mov    (%esi),%eax
80106bc7:	a8 01                	test   $0x1,%al
80106bc9:	75 15                	jne    80106be0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106bcb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bd1:	39 da                	cmp    %ebx,%edx
80106bd3:	77 c7                	ja     80106b9c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bdb:	5b                   	pop    %ebx
80106bdc:	5e                   	pop    %esi
80106bdd:	5f                   	pop    %edi
80106bde:	5d                   	pop    %ebp
80106bdf:	c3                   	ret    
      if(pa == 0)
80106be0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106be5:	74 25                	je     80106c0c <deallocuvm.part.0+0x9c>
      kfree(v);
80106be7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bea:	05 00 00 00 80       	add    $0x80000000,%eax
80106bef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bf2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106bf8:	50                   	push   %eax
80106bf9:	e8 92 b8 ff ff       	call   80102490 <kfree>
      *pte = 0;
80106bfe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106c04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c07:	83 c4 10             	add    $0x10,%esp
80106c0a:	eb 8c                	jmp    80106b98 <deallocuvm.part.0+0x28>
        panic("kfree");
80106c0c:	83 ec 0c             	sub    $0xc,%esp
80106c0f:	68 1a 78 10 80       	push   $0x8010781a
80106c14:	e8 67 97 ff ff       	call   80100380 <panic>
80106c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c20 <mappages>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c26:	89 d3                	mov    %edx,%ebx
80106c28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c2e:	83 ec 1c             	sub    $0x1c,%esp
80106c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c34:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c40:	8b 45 08             	mov    0x8(%ebp),%eax
80106c43:	29 d8                	sub    %ebx,%eax
80106c45:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c48:	eb 3d                	jmp    80106c87 <mappages+0x67>
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c50:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c57:	c1 ea 0a             	shr    $0xa,%edx
80106c5a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c60:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c67:	85 c0                	test   %eax,%eax
80106c69:	74 75                	je     80106ce0 <mappages+0xc0>
    if(*pte & PTE_P)
80106c6b:	f6 00 01             	testb  $0x1,(%eax)
80106c6e:	0f 85 86 00 00 00    	jne    80106cfa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c74:	0b 75 0c             	or     0xc(%ebp),%esi
80106c77:	83 ce 01             	or     $0x1,%esi
80106c7a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c7c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c7f:	74 6f                	je     80106cf0 <mappages+0xd0>
    a += PGSIZE;
80106c81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c8a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c8d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c90:	89 d8                	mov    %ebx,%eax
80106c92:	c1 e8 16             	shr    $0x16,%eax
80106c95:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c98:	8b 07                	mov    (%edi),%eax
80106c9a:	a8 01                	test   $0x1,%al
80106c9c:	75 b2                	jne    80106c50 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c9e:	e8 ad b9 ff ff       	call   80102650 <kalloc>
80106ca3:	85 c0                	test   %eax,%eax
80106ca5:	74 39                	je     80106ce0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ca7:	83 ec 04             	sub    $0x4,%esp
80106caa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106cad:	68 00 10 00 00       	push   $0x1000
80106cb2:	6a 00                	push   $0x0
80106cb4:	50                   	push   %eax
80106cb5:	e8 f6 dc ff ff       	call   801049b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106cbd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cc0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106cc6:	83 c8 07             	or     $0x7,%eax
80106cc9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106ccb:	89 d8                	mov    %ebx,%eax
80106ccd:	c1 e8 0a             	shr    $0xa,%eax
80106cd0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cd5:	01 d0                	add    %edx,%eax
80106cd7:	eb 92                	jmp    80106c6b <mappages+0x4b>
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ce8:	5b                   	pop    %ebx
80106ce9:	5e                   	pop    %esi
80106cea:	5f                   	pop    %edi
80106ceb:	5d                   	pop    %ebp
80106cec:	c3                   	ret    
80106ced:	8d 76 00             	lea    0x0(%esi),%esi
80106cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cf3:	31 c0                	xor    %eax,%eax
}
80106cf5:	5b                   	pop    %ebx
80106cf6:	5e                   	pop    %esi
80106cf7:	5f                   	pop    %edi
80106cf8:	5d                   	pop    %ebp
80106cf9:	c3                   	ret    
      panic("remap");
80106cfa:	83 ec 0c             	sub    $0xc,%esp
80106cfd:	68 f4 7e 10 80       	push   $0x80107ef4
80106d02:	e8 79 96 ff ff       	call   80100380 <panic>
80106d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0e:	66 90                	xchg   %ax,%ax

80106d10 <seginit>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d16:	e8 45 cc ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106d1b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d20:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d26:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d2a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106d31:	ff 00 00 
80106d34:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106d3b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d3e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106d45:	ff 00 00 
80106d48:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106d4f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d52:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106d59:	ff 00 00 
80106d5c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106d63:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d66:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106d6d:	ff 00 00 
80106d70:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106d77:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d7a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106d7f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d83:	c1 e8 10             	shr    $0x10,%eax
80106d86:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d8a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d8d:	0f 01 10             	lgdtl  (%eax)
}
80106d90:	c9                   	leave  
80106d91:	c3                   	ret    
80106d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106da0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106da0:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
80106da5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106daa:	0f 22 d8             	mov    %eax,%cr3
}
80106dad:	c3                   	ret    
80106dae:	66 90                	xchg   %ax,%ax

80106db0 <switchuvm>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
80106db6:	83 ec 1c             	sub    $0x1c,%esp
80106db9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106dbc:	85 f6                	test   %esi,%esi
80106dbe:	0f 84 cb 00 00 00    	je     80106e8f <switchuvm+0xdf>
  if(p->kstack == 0)
80106dc4:	8b 46 08             	mov    0x8(%esi),%eax
80106dc7:	85 c0                	test   %eax,%eax
80106dc9:	0f 84 da 00 00 00    	je     80106ea9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106dcf:	8b 46 04             	mov    0x4(%esi),%eax
80106dd2:	85 c0                	test   %eax,%eax
80106dd4:	0f 84 c2 00 00 00    	je     80106e9c <switchuvm+0xec>
  pushcli();
80106dda:	e8 c1 d9 ff ff       	call   801047a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ddf:	e8 1c cb ff ff       	call   80103900 <mycpu>
80106de4:	89 c3                	mov    %eax,%ebx
80106de6:	e8 15 cb ff ff       	call   80103900 <mycpu>
80106deb:	89 c7                	mov    %eax,%edi
80106ded:	e8 0e cb ff ff       	call   80103900 <mycpu>
80106df2:	83 c7 08             	add    $0x8,%edi
80106df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106df8:	e8 03 cb ff ff       	call   80103900 <mycpu>
80106dfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e00:	ba 67 00 00 00       	mov    $0x67,%edx
80106e05:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106e0c:	83 c0 08             	add    $0x8,%eax
80106e0f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e16:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e1b:	83 c1 08             	add    $0x8,%ecx
80106e1e:	c1 e8 18             	shr    $0x18,%eax
80106e21:	c1 e9 10             	shr    $0x10,%ecx
80106e24:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e2a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e30:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e35:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e41:	e8 ba ca ff ff       	call   80103900 <mycpu>
80106e46:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e4d:	e8 ae ca ff ff       	call   80103900 <mycpu>
80106e52:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e56:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e5f:	e8 9c ca ff ff       	call   80103900 <mycpu>
80106e64:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e67:	e8 94 ca ff ff       	call   80103900 <mycpu>
80106e6c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e70:	b8 28 00 00 00       	mov    $0x28,%eax
80106e75:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e78:	8b 46 04             	mov    0x4(%esi),%eax
80106e7b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e80:	0f 22 d8             	mov    %eax,%cr3
}
80106e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e86:	5b                   	pop    %ebx
80106e87:	5e                   	pop    %esi
80106e88:	5f                   	pop    %edi
80106e89:	5d                   	pop    %ebp
  popcli();
80106e8a:	e9 61 d9 ff ff       	jmp    801047f0 <popcli>
    panic("switchuvm: no process");
80106e8f:	83 ec 0c             	sub    $0xc,%esp
80106e92:	68 fa 7e 10 80       	push   $0x80107efa
80106e97:	e8 e4 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e9c:	83 ec 0c             	sub    $0xc,%esp
80106e9f:	68 25 7f 10 80       	push   $0x80107f25
80106ea4:	e8 d7 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106ea9:	83 ec 0c             	sub    $0xc,%esp
80106eac:	68 10 7f 10 80       	push   $0x80107f10
80106eb1:	e8 ca 94 ff ff       	call   80100380 <panic>
80106eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi

80106ec0 <inituvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ecc:	8b 75 10             	mov    0x10(%ebp),%esi
80106ecf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ed2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ed5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106edb:	77 4b                	ja     80106f28 <inituvm+0x68>
  mem = kalloc();
80106edd:	e8 6e b7 ff ff       	call   80102650 <kalloc>
  memset(mem, 0, PGSIZE);
80106ee2:	83 ec 04             	sub    $0x4,%esp
80106ee5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106eea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106eec:	6a 00                	push   $0x0
80106eee:	50                   	push   %eax
80106eef:	e8 bc da ff ff       	call   801049b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ef4:	58                   	pop    %eax
80106ef5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106efb:	5a                   	pop    %edx
80106efc:	6a 06                	push   $0x6
80106efe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f03:	31 d2                	xor    %edx,%edx
80106f05:	50                   	push   %eax
80106f06:	89 f8                	mov    %edi,%eax
80106f08:	e8 13 fd ff ff       	call   80106c20 <mappages>
  memmove(mem, init, sz);
80106f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f10:	89 75 10             	mov    %esi,0x10(%ebp)
80106f13:	83 c4 10             	add    $0x10,%esp
80106f16:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106f19:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f1f:	5b                   	pop    %ebx
80106f20:	5e                   	pop    %esi
80106f21:	5f                   	pop    %edi
80106f22:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f23:	e9 28 db ff ff       	jmp    80104a50 <memmove>
    panic("inituvm: more than a page");
80106f28:	83 ec 0c             	sub    $0xc,%esp
80106f2b:	68 39 7f 10 80       	push   $0x80107f39
80106f30:	e8 4b 94 ff ff       	call   80100380 <panic>
80106f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f40 <loaduvm>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 1c             	sub    $0x1c,%esp
80106f49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f4c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f4f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f54:	0f 85 bb 00 00 00    	jne    80107015 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106f5a:	01 f0                	add    %esi,%eax
80106f5c:	89 f3                	mov    %esi,%ebx
80106f5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f61:	8b 45 14             	mov    0x14(%ebp),%eax
80106f64:	01 f0                	add    %esi,%eax
80106f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f69:	85 f6                	test   %esi,%esi
80106f6b:	0f 84 87 00 00 00    	je     80106ff8 <loaduvm+0xb8>
80106f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f7e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f80:	89 c2                	mov    %eax,%edx
80106f82:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f85:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f88:	f6 c2 01             	test   $0x1,%dl
80106f8b:	75 13                	jne    80106fa0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f8d:	83 ec 0c             	sub    $0xc,%esp
80106f90:	68 53 7f 10 80       	push   $0x80107f53
80106f95:	e8 e6 93 ff ff       	call   80100380 <panic>
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fa0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fa3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106fa9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fb5:	85 c0                	test   %eax,%eax
80106fb7:	74 d4                	je     80106f8d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106fb9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fbb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fbe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fc8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106fce:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fd1:	29 d9                	sub    %ebx,%ecx
80106fd3:	05 00 00 00 80       	add    $0x80000000,%eax
80106fd8:	57                   	push   %edi
80106fd9:	51                   	push   %ecx
80106fda:	50                   	push   %eax
80106fdb:	ff 75 10             	push   0x10(%ebp)
80106fde:	e8 7d aa ff ff       	call   80101a60 <readi>
80106fe3:	83 c4 10             	add    $0x10,%esp
80106fe6:	39 f8                	cmp    %edi,%eax
80106fe8:	75 1e                	jne    80107008 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106fea:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ff0:	89 f0                	mov    %esi,%eax
80106ff2:	29 d8                	sub    %ebx,%eax
80106ff4:	39 c6                	cmp    %eax,%esi
80106ff6:	77 80                	ja     80106f78 <loaduvm+0x38>
}
80106ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ffb:	31 c0                	xor    %eax,%eax
}
80106ffd:	5b                   	pop    %ebx
80106ffe:	5e                   	pop    %esi
80106fff:	5f                   	pop    %edi
80107000:	5d                   	pop    %ebp
80107001:	c3                   	ret    
80107002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107008:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010700b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107010:	5b                   	pop    %ebx
80107011:	5e                   	pop    %esi
80107012:	5f                   	pop    %edi
80107013:	5d                   	pop    %ebp
80107014:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107015:	83 ec 0c             	sub    $0xc,%esp
80107018:	68 f4 7f 10 80       	push   $0x80107ff4
8010701d:	e8 5e 93 ff ff       	call   80100380 <panic>
80107022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107030 <allocuvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107039:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010703c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010703f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107042:	85 c0                	test   %eax,%eax
80107044:	0f 88 b6 00 00 00    	js     80107100 <allocuvm+0xd0>
  if(newsz < oldsz)
8010704a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010704d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107050:	0f 82 9a 00 00 00    	jb     801070f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107056:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010705c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107062:	39 75 10             	cmp    %esi,0x10(%ebp)
80107065:	77 44                	ja     801070ab <allocuvm+0x7b>
80107067:	e9 87 00 00 00       	jmp    801070f3 <allocuvm+0xc3>
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107070:	83 ec 04             	sub    $0x4,%esp
80107073:	68 00 10 00 00       	push   $0x1000
80107078:	6a 00                	push   $0x0
8010707a:	50                   	push   %eax
8010707b:	e8 30 d9 ff ff       	call   801049b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107080:	58                   	pop    %eax
80107081:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107087:	5a                   	pop    %edx
80107088:	6a 06                	push   $0x6
8010708a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010708f:	89 f2                	mov    %esi,%edx
80107091:	50                   	push   %eax
80107092:	89 f8                	mov    %edi,%eax
80107094:	e8 87 fb ff ff       	call   80106c20 <mappages>
80107099:	83 c4 10             	add    $0x10,%esp
8010709c:	85 c0                	test   %eax,%eax
8010709e:	78 78                	js     80107118 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801070a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801070a9:	76 48                	jbe    801070f3 <allocuvm+0xc3>
    mem = kalloc();
801070ab:	e8 a0 b5 ff ff       	call   80102650 <kalloc>
801070b0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801070b2:	85 c0                	test   %eax,%eax
801070b4:	75 ba                	jne    80107070 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070b6:	83 ec 0c             	sub    $0xc,%esp
801070b9:	68 71 7f 10 80       	push   $0x80107f71
801070be:	e8 dd 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801070c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070c6:	83 c4 10             	add    $0x10,%esp
801070c9:	39 45 10             	cmp    %eax,0x10(%ebp)
801070cc:	74 32                	je     80107100 <allocuvm+0xd0>
801070ce:	8b 55 10             	mov    0x10(%ebp),%edx
801070d1:	89 c1                	mov    %eax,%ecx
801070d3:	89 f8                	mov    %edi,%eax
801070d5:	e8 96 fa ff ff       	call   80106b70 <deallocuvm.part.0>
      return 0;
801070da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e7:	5b                   	pop    %ebx
801070e8:	5e                   	pop    %esi
801070e9:	5f                   	pop    %edi
801070ea:	5d                   	pop    %ebp
801070eb:	c3                   	ret    
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801070f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801070f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f9:	5b                   	pop    %ebx
801070fa:	5e                   	pop    %esi
801070fb:	5f                   	pop    %edi
801070fc:	5d                   	pop    %ebp
801070fd:	c3                   	ret    
801070fe:	66 90                	xchg   %ax,%ax
    return 0;
80107100:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010710a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010710d:	5b                   	pop    %ebx
8010710e:	5e                   	pop    %esi
8010710f:	5f                   	pop    %edi
80107110:	5d                   	pop    %ebp
80107111:	c3                   	ret    
80107112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	68 89 7f 10 80       	push   $0x80107f89
80107120:	e8 7b 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107125:	8b 45 0c             	mov    0xc(%ebp),%eax
80107128:	83 c4 10             	add    $0x10,%esp
8010712b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010712e:	74 0c                	je     8010713c <allocuvm+0x10c>
80107130:	8b 55 10             	mov    0x10(%ebp),%edx
80107133:	89 c1                	mov    %eax,%ecx
80107135:	89 f8                	mov    %edi,%eax
80107137:	e8 34 fa ff ff       	call   80106b70 <deallocuvm.part.0>
      kfree(mem);
8010713c:	83 ec 0c             	sub    $0xc,%esp
8010713f:	53                   	push   %ebx
80107140:	e8 4b b3 ff ff       	call   80102490 <kfree>
      return 0;
80107145:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010714c:	83 c4 10             	add    $0x10,%esp
}
8010714f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107160 <deallocuvm>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	8b 55 0c             	mov    0xc(%ebp),%edx
80107166:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107169:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010716c:	39 d1                	cmp    %edx,%ecx
8010716e:	73 10                	jae    80107180 <deallocuvm+0x20>
}
80107170:	5d                   	pop    %ebp
80107171:	e9 fa f9 ff ff       	jmp    80106b70 <deallocuvm.part.0>
80107176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
80107180:	89 d0                	mov    %edx,%eax
80107182:	5d                   	pop    %ebp
80107183:	c3                   	ret    
80107184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010718f:	90                   	nop

80107190 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 0c             	sub    $0xc,%esp
80107199:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010719c:	85 f6                	test   %esi,%esi
8010719e:	74 59                	je     801071f9 <freevm+0x69>
  if(newsz >= oldsz)
801071a0:	31 c9                	xor    %ecx,%ecx
801071a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071a7:	89 f0                	mov    %esi,%eax
801071a9:	89 f3                	mov    %esi,%ebx
801071ab:	e8 c0 f9 ff ff       	call   80106b70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071b6:	eb 0f                	jmp    801071c7 <freevm+0x37>
801071b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071bf:	90                   	nop
801071c0:	83 c3 04             	add    $0x4,%ebx
801071c3:	39 df                	cmp    %ebx,%edi
801071c5:	74 23                	je     801071ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071c7:	8b 03                	mov    (%ebx),%eax
801071c9:	a8 01                	test   $0x1,%al
801071cb:	74 f3                	je     801071c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071dd:	50                   	push   %eax
801071de:	e8 ad b2 ff ff       	call   80102490 <kfree>
801071e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071e6:	39 df                	cmp    %ebx,%edi
801071e8:	75 dd                	jne    801071c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f0:	5b                   	pop    %ebx
801071f1:	5e                   	pop    %esi
801071f2:	5f                   	pop    %edi
801071f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071f4:	e9 97 b2 ff ff       	jmp    80102490 <kfree>
    panic("freevm: no pgdir");
801071f9:	83 ec 0c             	sub    $0xc,%esp
801071fc:	68 a5 7f 10 80       	push   $0x80107fa5
80107201:	e8 7a 91 ff ff       	call   80100380 <panic>
80107206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720d:	8d 76 00             	lea    0x0(%esi),%esi

80107210 <setupkvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	56                   	push   %esi
80107214:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107215:	e8 36 b4 ff ff       	call   80102650 <kalloc>
8010721a:	89 c6                	mov    %eax,%esi
8010721c:	85 c0                	test   %eax,%eax
8010721e:	74 42                	je     80107262 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107223:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107228:	68 00 10 00 00       	push   $0x1000
8010722d:	6a 00                	push   $0x0
8010722f:	50                   	push   %eax
80107230:	e8 7b d7 ff ff       	call   801049b0 <memset>
80107235:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107238:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010723b:	83 ec 08             	sub    $0x8,%esp
8010723e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107241:	ff 73 0c             	push   0xc(%ebx)
80107244:	8b 13                	mov    (%ebx),%edx
80107246:	50                   	push   %eax
80107247:	29 c1                	sub    %eax,%ecx
80107249:	89 f0                	mov    %esi,%eax
8010724b:	e8 d0 f9 ff ff       	call   80106c20 <mappages>
80107250:	83 c4 10             	add    $0x10,%esp
80107253:	85 c0                	test   %eax,%eax
80107255:	78 19                	js     80107270 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107257:	83 c3 10             	add    $0x10,%ebx
8010725a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107260:	75 d6                	jne    80107238 <setupkvm+0x28>
}
80107262:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107265:	89 f0                	mov    %esi,%eax
80107267:	5b                   	pop    %ebx
80107268:	5e                   	pop    %esi
80107269:	5d                   	pop    %ebp
8010726a:	c3                   	ret    
8010726b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010726f:	90                   	nop
      freevm(pgdir);
80107270:	83 ec 0c             	sub    $0xc,%esp
80107273:	56                   	push   %esi
      return 0;
80107274:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107276:	e8 15 ff ff ff       	call   80107190 <freevm>
      return 0;
8010727b:	83 c4 10             	add    $0x10,%esp
}
8010727e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107281:	89 f0                	mov    %esi,%eax
80107283:	5b                   	pop    %ebx
80107284:	5e                   	pop    %esi
80107285:	5d                   	pop    %ebp
80107286:	c3                   	ret    
80107287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728e:	66 90                	xchg   %ax,%ax

80107290 <kvmalloc>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107296:	e8 75 ff ff ff       	call   80107210 <setupkvm>
8010729b:	a3 c4 5e 11 80       	mov    %eax,0x80115ec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072a0:	05 00 00 00 80       	add    $0x80000000,%eax
801072a5:	0f 22 d8             	mov    %eax,%cr3
}
801072a8:	c9                   	leave  
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	83 ec 08             	sub    $0x8,%esp
801072b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072bc:	89 c1                	mov    %eax,%ecx
801072be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072c4:	f6 c2 01             	test   $0x1,%dl
801072c7:	75 17                	jne    801072e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072c9:	83 ec 0c             	sub    $0xc,%esp
801072cc:	68 b6 7f 10 80       	push   $0x80107fb6
801072d1:	e8 aa 90 ff ff       	call   80100380 <panic>
801072d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801072f5:	85 c0                	test   %eax,%eax
801072f7:	74 d0                	je     801072c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801072f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072fc:	c9                   	leave  
801072fd:	c3                   	ret    
801072fe:	66 90                	xchg   %ax,%ax

80107300 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107309:	e8 02 ff ff ff       	call   80107210 <setupkvm>
8010730e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107311:	85 c0                	test   %eax,%eax
80107313:	0f 84 bd 00 00 00    	je     801073d6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010731c:	85 c9                	test   %ecx,%ecx
8010731e:	0f 84 b2 00 00 00    	je     801073d6 <copyuvm+0xd6>
80107324:	31 f6                	xor    %esi,%esi
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107330:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107333:	89 f0                	mov    %esi,%eax
80107335:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107338:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010733b:	a8 01                	test   $0x1,%al
8010733d:	75 11                	jne    80107350 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010733f:	83 ec 0c             	sub    $0xc,%esp
80107342:	68 c0 7f 10 80       	push   $0x80107fc0
80107347:	e8 34 90 ff ff       	call   80100380 <panic>
8010734c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107350:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107352:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107357:	c1 ea 0a             	shr    $0xa,%edx
8010735a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107360:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107367:	85 c0                	test   %eax,%eax
80107369:	74 d4                	je     8010733f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010736b:	8b 00                	mov    (%eax),%eax
8010736d:	a8 01                	test   $0x1,%al
8010736f:	0f 84 9f 00 00 00    	je     80107414 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107375:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107377:	25 ff 0f 00 00       	and    $0xfff,%eax
8010737c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010737f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107385:	e8 c6 b2 ff ff       	call   80102650 <kalloc>
8010738a:	89 c3                	mov    %eax,%ebx
8010738c:	85 c0                	test   %eax,%eax
8010738e:	74 64                	je     801073f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107390:	83 ec 04             	sub    $0x4,%esp
80107393:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107399:	68 00 10 00 00       	push   $0x1000
8010739e:	57                   	push   %edi
8010739f:	50                   	push   %eax
801073a0:	e8 ab d6 ff ff       	call   80104a50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801073a5:	58                   	pop    %eax
801073a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073ac:	5a                   	pop    %edx
801073ad:	ff 75 e4             	push   -0x1c(%ebp)
801073b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073b5:	89 f2                	mov    %esi,%edx
801073b7:	50                   	push   %eax
801073b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073bb:	e8 60 f8 ff ff       	call   80106c20 <mappages>
801073c0:	83 c4 10             	add    $0x10,%esp
801073c3:	85 c0                	test   %eax,%eax
801073c5:	78 21                	js     801073e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801073c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801073d0:	0f 87 5a ff ff ff    	ja     80107330 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801073d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073dc:	5b                   	pop    %ebx
801073dd:	5e                   	pop    %esi
801073de:	5f                   	pop    %edi
801073df:	5d                   	pop    %ebp
801073e0:	c3                   	ret    
801073e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073e8:	83 ec 0c             	sub    $0xc,%esp
801073eb:	53                   	push   %ebx
801073ec:	e8 9f b0 ff ff       	call   80102490 <kfree>
      goto bad;
801073f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801073f4:	83 ec 0c             	sub    $0xc,%esp
801073f7:	ff 75 e0             	push   -0x20(%ebp)
801073fa:	e8 91 fd ff ff       	call   80107190 <freevm>
  return 0;
801073ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107406:	83 c4 10             	add    $0x10,%esp
}
80107409:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010740c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740f:	5b                   	pop    %ebx
80107410:	5e                   	pop    %esi
80107411:	5f                   	pop    %edi
80107412:	5d                   	pop    %ebp
80107413:	c3                   	ret    
      panic("copyuvm: page not present");
80107414:	83 ec 0c             	sub    $0xc,%esp
80107417:	68 da 7f 10 80       	push   $0x80107fda
8010741c:	e8 5f 8f ff ff       	call   80100380 <panic>
80107421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742f:	90                   	nop

80107430 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107436:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107439:	89 c1                	mov    %eax,%ecx
8010743b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010743e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107441:	f6 c2 01             	test   $0x1,%dl
80107444:	0f 84 00 01 00 00    	je     8010754a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010744a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010744d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107453:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107454:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107459:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107460:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107467:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010746a:	05 00 00 00 80       	add    $0x80000000,%eax
8010746f:	83 fa 05             	cmp    $0x5,%edx
80107472:	ba 00 00 00 00       	mov    $0x0,%edx
80107477:	0f 45 c2             	cmovne %edx,%eax
}
8010747a:	c3                   	ret    
8010747b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010747f:	90                   	nop

80107480 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 0c             	sub    $0xc,%esp
80107489:	8b 75 14             	mov    0x14(%ebp),%esi
8010748c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010748f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107492:	85 f6                	test   %esi,%esi
80107494:	75 51                	jne    801074e7 <copyout+0x67>
80107496:	e9 a5 00 00 00       	jmp    80107540 <copyout+0xc0>
8010749b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010749f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801074a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801074a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801074ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801074b2:	74 75                	je     80107529 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801074b4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074b6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801074b9:	29 c3                	sub    %eax,%ebx
801074bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074c1:	39 f3                	cmp    %esi,%ebx
801074c3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801074c6:	29 f8                	sub    %edi,%eax
801074c8:	83 ec 04             	sub    $0x4,%esp
801074cb:	01 c1                	add    %eax,%ecx
801074cd:	53                   	push   %ebx
801074ce:	52                   	push   %edx
801074cf:	51                   	push   %ecx
801074d0:	e8 7b d5 ff ff       	call   80104a50 <memmove>
    len -= n;
    buf += n;
801074d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801074de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801074e3:	29 de                	sub    %ebx,%esi
801074e5:	74 59                	je     80107540 <copyout+0xc0>
  if(*pde & PTE_P){
801074e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801074ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801074fa:	f6 c1 01             	test   $0x1,%cl
801074fd:	0f 84 4e 00 00 00    	je     80107551 <copyout.cold>
  return &pgtab[PTX(va)];
80107503:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107505:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010750b:	c1 eb 0c             	shr    $0xc,%ebx
8010750e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107514:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010751b:	89 d9                	mov    %ebx,%ecx
8010751d:	83 e1 05             	and    $0x5,%ecx
80107520:	83 f9 05             	cmp    $0x5,%ecx
80107523:	0f 84 77 ff ff ff    	je     801074a0 <copyout+0x20>
  }
  return 0;
}
80107529:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010752c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107531:	5b                   	pop    %ebx
80107532:	5e                   	pop    %esi
80107533:	5f                   	pop    %edi
80107534:	5d                   	pop    %ebp
80107535:	c3                   	ret    
80107536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753d:	8d 76 00             	lea    0x0(%esi),%esi
80107540:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107543:	31 c0                	xor    %eax,%eax
}
80107545:	5b                   	pop    %ebx
80107546:	5e                   	pop    %esi
80107547:	5f                   	pop    %edi
80107548:	5d                   	pop    %ebp
80107549:	c3                   	ret    

8010754a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010754a:	a1 00 00 00 00       	mov    0x0,%eax
8010754f:	0f 0b                	ud2    

80107551 <copyout.cold>:
80107551:	a1 00 00 00 00       	mov    0x0,%eax
80107556:	0f 0b                	ud2    
