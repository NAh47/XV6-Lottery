
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	bb 01 00 00 00       	mov    $0x1,%ebx
  15:	51                   	push   %ecx
  16:	83 ec 0c             	sub    $0xc,%esp
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  1c:	8b 31                	mov    (%ecx),%esi
  int i;

#ifdef BETTER_LS
  printf(1, "%s\t\t%s\t%s\t%s\t%s\n",
  1e:	68 13 0b 00 00       	push   $0xb13
  23:	68 18 0b 00 00       	push   $0xb18
  28:	68 1e 0b 00 00       	push   $0xb1e
  2d:	68 24 0b 00 00       	push   $0xb24
  32:	68 29 0b 00 00       	push   $0xb29
  37:	68 2e 0b 00 00       	push   $0xb2e
  3c:	6a 01                	push   $0x1
  3e:	e8 2d 07 00 00       	call   770 <printf>
         "name", "type", "# lks", "ino #", "size"
      );
#endif // BETTER_LS
  if(argc < 2){
  43:	83 c4 20             	add    $0x20,%esp
  46:	83 fe 01             	cmp    $0x1,%esi
  49:	7e 1f                	jle    6a <main+0x6a>
  4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  4f:	90                   	nop
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	ff 34 9f             	push   (%edi,%ebx,4)
  for(i=1; i<argc; i++)
  56:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  59:	e8 e2 00 00 00       	call   140 <ls>
  for(i=1; i<argc; i++)
  5e:	83 c4 10             	add    $0x10,%esp
  61:	39 de                	cmp    %ebx,%esi
  63:	75 eb                	jne    50 <main+0x50>
  exit();
  65:	e8 99 05 00 00       	call   603 <exit>
    ls(".");
  6a:	83 ec 0c             	sub    $0xc,%esp
  6d:	68 3f 0b 00 00       	push   $0xb3f
  72:	e8 c9 00 00 00       	call   140 <ls>
    exit();
  77:	e8 87 05 00 00       	call   603 <exit>
  7c:	66 90                	xchg   %ax,%ax
  7e:	66 90                	xchg   %ax,%ax

00000080 <filetype>:
{
  80:	55                   	push   %ebp
  81:	b8 3f 00 00 00       	mov    $0x3f,%eax
  86:	89 e5                	mov    %esp,%ebp
  88:	8b 55 08             	mov    0x8(%ebp),%edx
  8b:	8d 4a ff             	lea    -0x1(%edx),%ecx
  8e:	83 f9 02             	cmp    $0x2,%ecx
  91:	77 07                	ja     9a <filetype+0x1a>
  93:	0f b6 82 40 0b 00 00 	movzbl 0xb40(%edx),%eax
}
  9a:	5d                   	pop    %ebp
  9b:	c3                   	ret    
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000a0 <fmtname>:
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	56                   	push   %esi
  a4:	53                   	push   %ebx
  a5:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  a8:	83 ec 0c             	sub    $0xc,%esp
  ab:	56                   	push   %esi
  ac:	e8 8f 03 00 00       	call   440 <strlen>
  b1:	83 c4 10             	add    $0x10,%esp
  b4:	01 f0                	add    %esi,%eax
  b6:	89 c3                	mov    %eax,%ebx
  b8:	73 0f                	jae    c9 <fmtname+0x29>
  ba:	eb 12                	jmp    ce <fmtname+0x2e>
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  c3:	39 c6                	cmp    %eax,%esi
  c5:	77 0a                	ja     d1 <fmtname+0x31>
  c7:	89 c3                	mov    %eax,%ebx
  c9:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  cc:	75 f2                	jne    c0 <fmtname+0x20>
  p++;
  ce:	83 c3 01             	add    $0x1,%ebx
  if(strlen(p) >= DIRSIZ)
  d1:	83 ec 0c             	sub    $0xc,%esp
  d4:	53                   	push   %ebx
  d5:	e8 66 03 00 00       	call   440 <strlen>
  da:	83 c4 10             	add    $0x10,%esp
  dd:	83 f8 0d             	cmp    $0xd,%eax
  e0:	77 4a                	ja     12c <fmtname+0x8c>
  memmove(buf, p, strlen(p));
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	53                   	push   %ebx
  e6:	e8 55 03 00 00       	call   440 <strlen>
  eb:	83 c4 0c             	add    $0xc,%esp
  ee:	50                   	push   %eax
  ef:	53                   	push   %ebx
  f0:	68 2c 0f 00 00       	push   $0xf2c
  f5:	e8 d6 04 00 00       	call   5d0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  fa:	89 1c 24             	mov    %ebx,(%esp)
  fd:	e8 3e 03 00 00       	call   440 <strlen>
 102:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
 105:	bb 2c 0f 00 00       	mov    $0xf2c,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 10a:	89 c6                	mov    %eax,%esi
 10c:	e8 2f 03 00 00       	call   440 <strlen>
 111:	ba 0e 00 00 00       	mov    $0xe,%edx
 116:	83 c4 0c             	add    $0xc,%esp
 119:	29 f2                	sub    %esi,%edx
 11b:	05 2c 0f 00 00       	add    $0xf2c,%eax
 120:	52                   	push   %edx
 121:	6a 20                	push   $0x20
 123:	50                   	push   %eax
 124:	e8 47 03 00 00       	call   470 <memset>
  return buf;
 129:	83 c4 10             	add    $0x10,%esp
}
 12c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 12f:	89 d8                	mov    %ebx,%eax
 131:	5b                   	pop    %ebx
 132:	5e                   	pop    %esi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    
 135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000140 <ls>:
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
 146:	81 ec 64 02 00 00    	sub    $0x264,%esp
 14c:	8b 75 08             	mov    0x8(%ebp),%esi
  if((fd = open(path, 0)) < 0){
 14f:	6a 00                	push   $0x0
 151:	56                   	push   %esi
 152:	e8 ec 04 00 00       	call   643 <open>
 157:	83 c4 10             	add    $0x10,%esp
 15a:	85 c0                	test   %eax,%eax
 15c:	0f 88 ce 01 00 00    	js     330 <ls+0x1f0>
  if(fstat(fd, &st) < 0){
 162:	83 ec 08             	sub    $0x8,%esp
 165:	8d bd d4 fd ff ff    	lea    -0x22c(%ebp),%edi
 16b:	89 c3                	mov    %eax,%ebx
 16d:	57                   	push   %edi
 16e:	50                   	push   %eax
 16f:	e8 e7 04 00 00       	call   65b <fstat>
 174:	83 c4 10             	add    $0x10,%esp
 177:	85 c0                	test   %eax,%eax
 179:	0f 88 f1 01 00 00    	js     370 <ls+0x230>
  switch(st.type){
 17f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 186:	66 83 f8 01          	cmp    $0x1,%ax
 18a:	74 74                	je     200 <ls+0xc0>
 18c:	66 83 f8 02          	cmp    $0x2,%ax
 190:	74 1e                	je     1b0 <ls+0x70>
  close(fd);
 192:	83 ec 0c             	sub    $0xc,%esp
 195:	53                   	push   %ebx
 196:	e8 90 04 00 00       	call   62b <close>
 19b:	83 c4 10             	add    $0x10,%esp
}
 19e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a1:	5b                   	pop    %ebx
 1a2:	5e                   	pop    %esi
 1a3:	5f                   	pop    %edi
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    
 1a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s\t%c\t%d\t%d\t%d\n"
 1b0:	83 ec 0c             	sub    $0xc,%esp
 1b3:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 1b9:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 1bf:	56                   	push   %esi
 1c0:	0f bf bd e0 fd ff ff 	movswl -0x220(%ebp),%edi
 1c7:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
 1cd:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 1d3:	e8 c8 fe ff ff       	call   a0 <fmtname>
 1d8:	8b 8d b0 fd ff ff    	mov    -0x250(%ebp),%ecx
 1de:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1e4:	83 c4 0c             	add    $0xc,%esp
 1e7:	51                   	push   %ecx
 1e8:	52                   	push   %edx
 1e9:	57                   	push   %edi
 1ea:	6a 66                	push   $0x66
 1ec:	50                   	push   %eax
 1ed:	68 f0 0a 00 00       	push   $0xaf0
 1f2:	6a 01                	push   $0x1
 1f4:	e8 77 05 00 00       	call   770 <printf>
    break;
 1f9:	83 c4 20             	add    $0x20,%esp
 1fc:	eb 94                	jmp    192 <ls+0x52>
 1fe:	66 90                	xchg   %ax,%ax
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 200:	83 ec 0c             	sub    $0xc,%esp
 203:	56                   	push   %esi
 204:	e8 37 02 00 00       	call   440 <strlen>
 209:	83 c4 10             	add    $0x10,%esp
 20c:	83 c0 10             	add    $0x10,%eax
 20f:	3d 00 02 00 00       	cmp    $0x200,%eax
 214:	0f 87 36 01 00 00    	ja     350 <ls+0x210>
    strcpy(buf, path);
 21a:	83 ec 08             	sub    $0x8,%esp
 21d:	56                   	push   %esi
 21e:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
 224:	56                   	push   %esi
 225:	e8 86 01 00 00       	call   3b0 <strcpy>
    p = buf+strlen(buf);
 22a:	89 34 24             	mov    %esi,(%esp)
 22d:	e8 0e 02 00 00       	call   440 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 232:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 235:	01 f0                	add    %esi,%eax
    *p++ = '/';
 237:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 23a:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
    *p++ = '/';
 240:	89 8d a0 fd ff ff    	mov    %ecx,-0x260(%ebp)
 246:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	83 ec 04             	sub    $0x4,%esp
 253:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 259:	6a 10                	push   $0x10
 25b:	50                   	push   %eax
 25c:	53                   	push   %ebx
 25d:	e8 b9 03 00 00       	call   61b <read>
 262:	83 c4 10             	add    $0x10,%esp
 265:	83 f8 10             	cmp    $0x10,%eax
 268:	0f 85 24 ff ff ff    	jne    192 <ls+0x52>
      if(de.inum == 0)
 26e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 275:	00 
 276:	74 d8                	je     250 <ls+0x110>
      memmove(p, de.name, DIRSIZ);
 278:	83 ec 04             	sub    $0x4,%esp
 27b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 281:	6a 0e                	push   $0xe
 283:	50                   	push   %eax
 284:	ff b5 a0 fd ff ff    	push   -0x260(%ebp)
 28a:	e8 41 03 00 00       	call   5d0 <memmove>
      p[DIRSIZ] = 0;
 28f:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
 295:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 299:	58                   	pop    %eax
 29a:	5a                   	pop    %edx
 29b:	57                   	push   %edi
 29c:	56                   	push   %esi
 29d:	e8 9e 02 00 00       	call   540 <stat>
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	85 c0                	test   %eax,%eax
 2a7:	0f 88 eb 00 00 00    	js     398 <ls+0x258>
      printf(1, "%s\t%c\t%d\t%d\t%d\n", fmtname(buf), filetype(st.type), st.nlink, st.ino, st.size);
 2ad:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 2b3:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
    switch (sttype) {
 2b9:	ba 3f 00 00 00       	mov    $0x3f,%edx
      printf(1, "%s\t%c\t%d\t%d\t%d\n", fmtname(buf), filetype(st.type), st.nlink, st.ino, st.size);
 2be:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 2c4:	0f bf 85 e0 fd ff ff 	movswl -0x220(%ebp),%eax
 2cb:	89 85 b0 fd ff ff    	mov    %eax,-0x250(%ebp)
    switch (sttype) {
 2d1:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 2d8:	83 e8 01             	sub    $0x1,%eax
 2db:	83 f8 02             	cmp    $0x2,%eax
 2de:	77 07                	ja     2e7 <ls+0x1a7>
      printf(1, "%s\t%c\t%d\t%d\t%d\n", fmtname(buf), filetype(st.type), st.nlink, st.ino, st.size);
 2e0:	0f be 90 41 0b 00 00 	movsbl 0xb41(%eax),%edx
 2e7:	83 ec 0c             	sub    $0xc,%esp
 2ea:	89 95 a8 fd ff ff    	mov    %edx,-0x258(%ebp)
 2f0:	56                   	push   %esi
 2f1:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 2f7:	e8 a4 fd ff ff       	call   a0 <fmtname>
 2fc:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 302:	8b 95 a8 fd ff ff    	mov    -0x258(%ebp),%edx
 308:	83 c4 0c             	add    $0xc,%esp
 30b:	51                   	push   %ecx
 30c:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 312:	ff b5 b0 fd ff ff    	push   -0x250(%ebp)
 318:	52                   	push   %edx
 319:	50                   	push   %eax
 31a:	68 f0 0a 00 00       	push   $0xaf0
 31f:	6a 01                	push   $0x1
 321:	e8 4a 04 00 00       	call   770 <printf>
 326:	83 c4 20             	add    $0x20,%esp
 329:	e9 22 ff ff ff       	jmp    250 <ls+0x110>
 32e:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot open %s\n", path);
 330:	83 ec 04             	sub    $0x4,%esp
 333:	56                   	push   %esi
 334:	68 c8 0a 00 00       	push   $0xac8
 339:	6a 02                	push   $0x2
 33b:	e8 30 04 00 00       	call   770 <printf>
    return;
 340:	83 c4 10             	add    $0x10,%esp
}
 343:	8d 65 f4             	lea    -0xc(%ebp),%esp
 346:	5b                   	pop    %ebx
 347:	5e                   	pop    %esi
 348:	5f                   	pop    %edi
 349:	5d                   	pop    %ebp
 34a:	c3                   	ret    
 34b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 34f:	90                   	nop
      printf(1, "ls: path too long\n");
 350:	83 ec 08             	sub    $0x8,%esp
 353:	68 00 0b 00 00       	push   $0xb00
 358:	6a 01                	push   $0x1
 35a:	e8 11 04 00 00       	call   770 <printf>
      break;
 35f:	83 c4 10             	add    $0x10,%esp
 362:	e9 2b fe ff ff       	jmp    192 <ls+0x52>
 367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36e:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot stat %s\n", path);
 370:	83 ec 04             	sub    $0x4,%esp
 373:	56                   	push   %esi
 374:	68 dc 0a 00 00       	push   $0xadc
 379:	6a 02                	push   $0x2
 37b:	e8 f0 03 00 00       	call   770 <printf>
    close(fd);
 380:	89 1c 24             	mov    %ebx,(%esp)
 383:	e8 a3 02 00 00       	call   62b <close>
    return;
 388:	83 c4 10             	add    $0x10,%esp
}
 38b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38e:	5b                   	pop    %ebx
 38f:	5e                   	pop    %esi
 390:	5f                   	pop    %edi
 391:	5d                   	pop    %ebp
 392:	c3                   	ret    
 393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 397:	90                   	nop
        printf(1, "ls: cannot stat %s\n", buf);
 398:	83 ec 04             	sub    $0x4,%esp
 39b:	56                   	push   %esi
 39c:	68 dc 0a 00 00       	push   $0xadc
 3a1:	6a 01                	push   $0x1
 3a3:	e8 c8 03 00 00       	call   770 <printf>
        continue;
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	e9 a0 fe ff ff       	jmp    250 <ls+0x110>

000003b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3b1:	31 c0                	xor    %eax,%eax
{
 3b3:	89 e5                	mov    %esp,%ebp
 3b5:	53                   	push   %ebx
 3b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 3c7:	83 c0 01             	add    $0x1,%eax
 3ca:	84 d2                	test   %dl,%dl
 3cc:	75 f2                	jne    3c0 <strcpy+0x10>
    ;
  return os;
}
 3ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3d1:	89 c8                	mov    %ecx,%eax
 3d3:	c9                   	leave  
 3d4:	c3                   	ret    
 3d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
 3e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3ea:	0f b6 02             	movzbl (%edx),%eax
 3ed:	84 c0                	test   %al,%al
 3ef:	75 17                	jne    408 <strcmp+0x28>
 3f1:	eb 3a                	jmp    42d <strcmp+0x4d>
 3f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f7:	90                   	nop
 3f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 3fc:	83 c2 01             	add    $0x1,%edx
 3ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 402:	84 c0                	test   %al,%al
 404:	74 1a                	je     420 <strcmp+0x40>
    p++, q++;
 406:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 408:	0f b6 19             	movzbl (%ecx),%ebx
 40b:	38 c3                	cmp    %al,%bl
 40d:	74 e9                	je     3f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 40f:	29 d8                	sub    %ebx,%eax
}
 411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 414:	c9                   	leave  
 415:	c3                   	ret    
 416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 420:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 424:	31 c0                	xor    %eax,%eax
 426:	29 d8                	sub    %ebx,%eax
}
 428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42b:	c9                   	leave  
 42c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 42d:	0f b6 19             	movzbl (%ecx),%ebx
 430:	31 c0                	xor    %eax,%eax
 432:	eb db                	jmp    40f <strcmp+0x2f>
 434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop

00000440 <strlen>:

uint
strlen(const char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 446:	80 3a 00             	cmpb   $0x0,(%edx)
 449:	74 15                	je     460 <strlen+0x20>
 44b:	31 c0                	xor    %eax,%eax
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	83 c0 01             	add    $0x1,%eax
 453:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 457:	89 c1                	mov    %eax,%ecx
 459:	75 f5                	jne    450 <strlen+0x10>
    ;
  return n;
}
 45b:	89 c8                	mov    %ecx,%eax
 45d:	5d                   	pop    %ebp
 45e:	c3                   	ret    
 45f:	90                   	nop
  for(n = 0; s[n]; n++)
 460:	31 c9                	xor    %ecx,%ecx
}
 462:	5d                   	pop    %ebp
 463:	89 c8                	mov    %ecx,%eax
 465:	c3                   	ret    
 466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi

00000470 <memset>:

void*
memset(void *dst, int c, uint n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 477:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47a:	8b 45 0c             	mov    0xc(%ebp),%eax
 47d:	89 d7                	mov    %edx,%edi
 47f:	fc                   	cld    
 480:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 482:	8b 7d fc             	mov    -0x4(%ebp),%edi
 485:	89 d0                	mov    %edx,%eax
 487:	c9                   	leave  
 488:	c3                   	ret    
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000490 <strchr>:

char*
strchr(const char *s, char c)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 49a:	0f b6 10             	movzbl (%eax),%edx
 49d:	84 d2                	test   %dl,%dl
 49f:	75 12                	jne    4b3 <strchr+0x23>
 4a1:	eb 1d                	jmp    4c0 <strchr+0x30>
 4a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a7:	90                   	nop
 4a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 4ac:	83 c0 01             	add    $0x1,%eax
 4af:	84 d2                	test   %dl,%dl
 4b1:	74 0d                	je     4c0 <strchr+0x30>
    if(*s == c)
 4b3:	38 d1                	cmp    %dl,%cl
 4b5:	75 f1                	jne    4a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 4b7:	5d                   	pop    %ebp
 4b8:	c3                   	ret    
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 4c0:	31 c0                	xor    %eax,%eax
}
 4c2:	5d                   	pop    %ebp
 4c3:	c3                   	ret    
 4c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <gets>:

char*
gets(char *buf, int max)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 4d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 4d9:	31 db                	xor    %ebx,%ebx
{
 4db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 4de:	eb 27                	jmp    507 <gets+0x37>
    cc = read(0, &c, 1);
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	6a 01                	push   $0x1
 4e5:	57                   	push   %edi
 4e6:	6a 00                	push   $0x0
 4e8:	e8 2e 01 00 00       	call   61b <read>
    if(cc < 1)
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	85 c0                	test   %eax,%eax
 4f2:	7e 1d                	jle    511 <gets+0x41>
      break;
    buf[i++] = c;
 4f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4f8:	8b 55 08             	mov    0x8(%ebp),%edx
 4fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 4ff:	3c 0a                	cmp    $0xa,%al
 501:	74 1d                	je     520 <gets+0x50>
 503:	3c 0d                	cmp    $0xd,%al
 505:	74 19                	je     520 <gets+0x50>
  for(i=0; i+1 < max; ){
 507:	89 de                	mov    %ebx,%esi
 509:	83 c3 01             	add    $0x1,%ebx
 50c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 50f:	7c cf                	jl     4e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 518:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51b:	5b                   	pop    %ebx
 51c:	5e                   	pop    %esi
 51d:	5f                   	pop    %edi
 51e:	5d                   	pop    %ebp
 51f:	c3                   	ret    
  buf[i] = '\0';
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	89 de                	mov    %ebx,%esi
 525:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 529:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52c:	5b                   	pop    %ebx
 52d:	5e                   	pop    %esi
 52e:	5f                   	pop    %edi
 52f:	5d                   	pop    %ebp
 530:	c3                   	ret    
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop

00000540 <stat>:

int
stat(const char *n, struct stat *st)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 545:	83 ec 08             	sub    $0x8,%esp
 548:	6a 00                	push   $0x0
 54a:	ff 75 08             	push   0x8(%ebp)
 54d:	e8 f1 00 00 00       	call   643 <open>
  if(fd < 0)
 552:	83 c4 10             	add    $0x10,%esp
 555:	85 c0                	test   %eax,%eax
 557:	78 27                	js     580 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 559:	83 ec 08             	sub    $0x8,%esp
 55c:	ff 75 0c             	push   0xc(%ebp)
 55f:	89 c3                	mov    %eax,%ebx
 561:	50                   	push   %eax
 562:	e8 f4 00 00 00       	call   65b <fstat>
  close(fd);
 567:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 56a:	89 c6                	mov    %eax,%esi
  close(fd);
 56c:	e8 ba 00 00 00       	call   62b <close>
  return r;
 571:	83 c4 10             	add    $0x10,%esp
}
 574:	8d 65 f8             	lea    -0x8(%ebp),%esp
 577:	89 f0                	mov    %esi,%eax
 579:	5b                   	pop    %ebx
 57a:	5e                   	pop    %esi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 580:	be ff ff ff ff       	mov    $0xffffffff,%esi
 585:	eb ed                	jmp    574 <stat+0x34>
 587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58e:	66 90                	xchg   %ax,%ax

00000590 <atoi>:

int
atoi(const char *s)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
 594:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 597:	0f be 02             	movsbl (%edx),%eax
 59a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 59d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 5a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 5a5:	77 1e                	ja     5c5 <atoi+0x35>
 5a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 5b0:	83 c2 01             	add    $0x1,%edx
 5b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 5b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 5ba:	0f be 02             	movsbl (%edx),%eax
 5bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 5c0:	80 fb 09             	cmp    $0x9,%bl
 5c3:	76 eb                	jbe    5b0 <atoi+0x20>
  return n;
}
 5c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c8:	89 c8                	mov    %ecx,%eax
 5ca:	c9                   	leave  
 5cb:	c3                   	ret    
 5cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	8b 45 10             	mov    0x10(%ebp),%eax
 5d7:	8b 55 08             	mov    0x8(%ebp),%edx
 5da:	56                   	push   %esi
 5db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5de:	85 c0                	test   %eax,%eax
 5e0:	7e 13                	jle    5f5 <memmove+0x25>
 5e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 5e4:	89 d7                	mov    %edx,%edi
 5e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5f1:	39 f8                	cmp    %edi,%eax
 5f3:	75 fb                	jne    5f0 <memmove+0x20>
  return vdst;
}
 5f5:	5e                   	pop    %esi
 5f6:	89 d0                	mov    %edx,%eax
 5f8:	5f                   	pop    %edi
 5f9:	5d                   	pop    %ebp
 5fa:	c3                   	ret    

000005fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5fb:	b8 01 00 00 00       	mov    $0x1,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <exit>:
SYSCALL(exit)
 603:	b8 02 00 00 00       	mov    $0x2,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <wait>:
SYSCALL(wait)
 60b:	b8 03 00 00 00       	mov    $0x3,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <pipe>:
SYSCALL(pipe)
 613:	b8 04 00 00 00       	mov    $0x4,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <read>:
SYSCALL(read)
 61b:	b8 05 00 00 00       	mov    $0x5,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <write>:
SYSCALL(write)
 623:	b8 10 00 00 00       	mov    $0x10,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <close>:
SYSCALL(close)
 62b:	b8 15 00 00 00       	mov    $0x15,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <kill>:
SYSCALL(kill)
 633:	b8 06 00 00 00       	mov    $0x6,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <exec>:
SYSCALL(exec)
 63b:	b8 07 00 00 00       	mov    $0x7,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <open>:
SYSCALL(open)
 643:	b8 0f 00 00 00       	mov    $0xf,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <mknod>:
SYSCALL(mknod)
 64b:	b8 11 00 00 00       	mov    $0x11,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <unlink>:
SYSCALL(unlink)
 653:	b8 12 00 00 00       	mov    $0x12,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <fstat>:
SYSCALL(fstat)
 65b:	b8 08 00 00 00       	mov    $0x8,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <link>:
SYSCALL(link)
 663:	b8 13 00 00 00       	mov    $0x13,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <mkdir>:
SYSCALL(mkdir)
 66b:	b8 14 00 00 00       	mov    $0x14,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <chdir>:
SYSCALL(chdir)
 673:	b8 09 00 00 00       	mov    $0x9,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <dup>:
SYSCALL(dup)
 67b:	b8 0a 00 00 00       	mov    $0xa,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <getpid>:
SYSCALL(getpid)
 683:	b8 0b 00 00 00       	mov    $0xb,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <sbrk>:
SYSCALL(sbrk)
 68b:	b8 0c 00 00 00       	mov    $0xc,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <sleep>:
SYSCALL(sleep)
 693:	b8 0d 00 00 00       	mov    $0xd,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <uptime>:
SYSCALL(uptime)
 69b:	b8 0e 00 00 00       	mov    $0xe,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <getppid>:
#ifdef GETPPID
SYSCALL(getppid)
 6a3:	b8 16 00 00 00       	mov    $0x16,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <cps>:
#endif // GETPPID    
#ifdef CPS
SYSCALL(cps)
 6ab:	b8 17 00 00 00       	mov    $0x17,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <renice>:
#endif // CPS
#ifdef LOTTERY
SYSCALL(renice)
 6b3:	b8 18 00 00 00       	mov    $0x18,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    
 6bb:	66 90                	xchg   %ax,%ax
 6bd:	66 90                	xchg   %ax,%ax
 6bf:	90                   	nop

000006c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 3c             	sub    $0x3c,%esp
 6c9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6cc:	89 d1                	mov    %edx,%ecx
{
 6ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 6d1:	85 d2                	test   %edx,%edx
 6d3:	0f 89 7f 00 00 00    	jns    758 <printint+0x98>
 6d9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6dd:	74 79                	je     758 <printint+0x98>
    neg = 1;
 6df:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 6e6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 6e8:	31 db                	xor    %ebx,%ebx
 6ea:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6f0:	89 c8                	mov    %ecx,%eax
 6f2:	31 d2                	xor    %edx,%edx
 6f4:	89 cf                	mov    %ecx,%edi
 6f6:	f7 75 c4             	divl   -0x3c(%ebp)
 6f9:	0f b6 92 a4 0b 00 00 	movzbl 0xba4(%edx),%edx
 700:	89 45 c0             	mov    %eax,-0x40(%ebp)
 703:	89 d8                	mov    %ebx,%eax
 705:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 708:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 70b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 70e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 711:	76 dd                	jbe    6f0 <printint+0x30>
  if(neg)
 713:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 716:	85 c9                	test   %ecx,%ecx
 718:	74 0c                	je     726 <printint+0x66>
    buf[i++] = '-';
 71a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 71f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 721:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 726:	8b 7d b8             	mov    -0x48(%ebp),%edi
 729:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 72d:	eb 07                	jmp    736 <printint+0x76>
 72f:	90                   	nop
    putc(fd, buf[i]);
 730:	0f b6 13             	movzbl (%ebx),%edx
 733:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 736:	83 ec 04             	sub    $0x4,%esp
 739:	88 55 d7             	mov    %dl,-0x29(%ebp)
 73c:	6a 01                	push   $0x1
 73e:	56                   	push   %esi
 73f:	57                   	push   %edi
 740:	e8 de fe ff ff       	call   623 <write>
  while(--i >= 0)
 745:	83 c4 10             	add    $0x10,%esp
 748:	39 de                	cmp    %ebx,%esi
 74a:	75 e4                	jne    730 <printint+0x70>
}
 74c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 74f:	5b                   	pop    %ebx
 750:	5e                   	pop    %esi
 751:	5f                   	pop    %edi
 752:	5d                   	pop    %ebp
 753:	c3                   	ret    
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 758:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 75f:	eb 87                	jmp    6e8 <printint+0x28>
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop

00000770 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 779:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 77c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 77f:	0f b6 13             	movzbl (%ebx),%edx
 782:	84 d2                	test   %dl,%dl
 784:	74 6a                	je     7f0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 786:	8d 45 10             	lea    0x10(%ebp),%eax
 789:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 78c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 78f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 791:	89 45 d0             	mov    %eax,-0x30(%ebp)
 794:	eb 36                	jmp    7cc <printf+0x5c>
 796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79d:	8d 76 00             	lea    0x0(%esi),%esi
 7a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7a3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 7a8:	83 f8 25             	cmp    $0x25,%eax
 7ab:	74 15                	je     7c2 <printf+0x52>
  write(fd, &c, 1);
 7ad:	83 ec 04             	sub    $0x4,%esp
 7b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7b3:	6a 01                	push   $0x1
 7b5:	57                   	push   %edi
 7b6:	56                   	push   %esi
 7b7:	e8 67 fe ff ff       	call   623 <write>
 7bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 7bf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7c2:	0f b6 13             	movzbl (%ebx),%edx
 7c5:	83 c3 01             	add    $0x1,%ebx
 7c8:	84 d2                	test   %dl,%dl
 7ca:	74 24                	je     7f0 <printf+0x80>
    c = fmt[i] & 0xff;
 7cc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 7cf:	85 c9                	test   %ecx,%ecx
 7d1:	74 cd                	je     7a0 <printf+0x30>
      }
    } else if(state == '%'){
 7d3:	83 f9 25             	cmp    $0x25,%ecx
 7d6:	75 ea                	jne    7c2 <printf+0x52>
      if(c == 'd' || c == 'u'){
 7d8:	83 f8 25             	cmp    $0x25,%eax
 7db:	0f 84 ff 00 00 00    	je     8e0 <printf+0x170>
 7e1:	83 e8 63             	sub    $0x63,%eax
 7e4:	83 f8 15             	cmp    $0x15,%eax
 7e7:	77 17                	ja     800 <printf+0x90>
 7e9:	ff 24 85 4c 0b 00 00 	jmp    *0xb4c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7f3:	5b                   	pop    %ebx
 7f4:	5e                   	pop    %esi
 7f5:	5f                   	pop    %edi
 7f6:	5d                   	pop    %ebp
 7f7:	c3                   	ret    
 7f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ff:	90                   	nop
  write(fd, &c, 1);
 800:	83 ec 04             	sub    $0x4,%esp
 803:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 806:	6a 01                	push   $0x1
 808:	57                   	push   %edi
 809:	56                   	push   %esi
 80a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 80e:	e8 10 fe ff ff       	call   623 <write>
        putc(fd, c);
 813:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 817:	83 c4 0c             	add    $0xc,%esp
 81a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 81d:	6a 01                	push   $0x1
 81f:	57                   	push   %edi
 820:	56                   	push   %esi
 821:	e8 fd fd ff ff       	call   623 <write>
        putc(fd, c);
 826:	83 c4 10             	add    $0x10,%esp
      state = 0;
 829:	31 c9                	xor    %ecx,%ecx
 82b:	eb 95                	jmp    7c2 <printf+0x52>
 82d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	b9 10 00 00 00       	mov    $0x10,%ecx
 838:	6a 00                	push   $0x0
 83a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 83d:	8b 10                	mov    (%eax),%edx
 83f:	89 f0                	mov    %esi,%eax
 841:	e8 7a fe ff ff       	call   6c0 <printint>
        ap++;
 846:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 84a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 84d:	31 c9                	xor    %ecx,%ecx
 84f:	e9 6e ff ff ff       	jmp    7c2 <printf+0x52>
 854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 858:	83 ec 0c             	sub    $0xc,%esp
 85b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 860:	6a 01                	push   $0x1
 862:	eb d6                	jmp    83a <printf+0xca>
 864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 868:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 86b:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 86e:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 870:	6a 01                	push   $0x1
 872:	57                   	push   %edi
 873:	56                   	push   %esi
        putc(fd, *ap);
 874:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 877:	e8 a7 fd ff ff       	call   623 <write>
        ap++;
 87c:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 880:	83 c4 10             	add    $0x10,%esp
      state = 0;
 883:	31 c9                	xor    %ecx,%ecx
 885:	e9 38 ff ff ff       	jmp    7c2 <printf+0x52>
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = (char*)*ap;
 890:	8b 45 d0             	mov    -0x30(%ebp),%eax
 893:	8b 10                	mov    (%eax),%edx
        ap++;
 895:	83 c0 04             	add    $0x4,%eax
 898:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 89b:	85 d2                	test   %edx,%edx
 89d:	74 51                	je     8f0 <printf+0x180>
        while(*s != 0){
 89f:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 8a2:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 8a4:	84 c0                	test   %al,%al
 8a6:	0f 84 16 ff ff ff    	je     7c2 <printf+0x52>
 8ac:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8af:	89 d3                	mov    %edx,%ebx
 8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 8b8:	83 ec 04             	sub    $0x4,%esp
          s++;
 8bb:	83 c3 01             	add    $0x1,%ebx
 8be:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8c1:	6a 01                	push   $0x1
 8c3:	57                   	push   %edi
 8c4:	56                   	push   %esi
 8c5:	e8 59 fd ff ff       	call   623 <write>
        while(*s != 0){
 8ca:	0f b6 03             	movzbl (%ebx),%eax
 8cd:	83 c4 10             	add    $0x10,%esp
 8d0:	84 c0                	test   %al,%al
 8d2:	75 e4                	jne    8b8 <printf+0x148>
      state = 0;
 8d4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 8d7:	31 c9                	xor    %ecx,%ecx
 8d9:	e9 e4 fe ff ff       	jmp    7c2 <printf+0x52>
 8de:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 8e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 8e3:	83 ec 04             	sub    $0x4,%esp
 8e6:	e9 32 ff ff ff       	jmp    81d <printf+0xad>
 8eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8ef:	90                   	nop
          s = "(null)";
 8f0:	ba 44 0b 00 00       	mov    $0xb44,%edx
        while(*s != 0){
 8f5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8f8:	b8 28 00 00 00       	mov    $0x28,%eax
 8fd:	89 d3                	mov    %edx,%ebx
 8ff:	eb b7                	jmp    8b8 <printf+0x148>
 901:	66 90                	xchg   %ax,%ax
 903:	66 90                	xchg   %ax,%ax
 905:	66 90                	xchg   %ax,%ax
 907:	66 90                	xchg   %ax,%ax
 909:	66 90                	xchg   %ax,%ax
 90b:	66 90                	xchg   %ax,%ax
 90d:	66 90                	xchg   %ax,%ax
 90f:	90                   	nop

00000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 911:	a1 3c 0f 00 00       	mov    0xf3c,%eax
{
 916:	89 e5                	mov    %esp,%ebp
 918:	57                   	push   %edi
 919:	56                   	push   %esi
 91a:	53                   	push   %ebx
 91b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 91e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 928:	89 c2                	mov    %eax,%edx
 92a:	8b 00                	mov    (%eax),%eax
 92c:	39 ca                	cmp    %ecx,%edx
 92e:	73 30                	jae    960 <free+0x50>
 930:	39 c1                	cmp    %eax,%ecx
 932:	72 04                	jb     938 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	39 c2                	cmp    %eax,%edx
 936:	72 f0                	jb     928 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 938:	8b 73 fc             	mov    -0x4(%ebx),%esi
 93b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 93e:	39 f8                	cmp    %edi,%eax
 940:	74 30                	je     972 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 942:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 945:	8b 42 04             	mov    0x4(%edx),%eax
 948:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 94b:	39 f1                	cmp    %esi,%ecx
 94d:	74 3a                	je     989 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 94f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 951:	5b                   	pop    %ebx
  freep = p;
 952:	89 15 3c 0f 00 00    	mov    %edx,0xf3c
}
 958:	5e                   	pop    %esi
 959:	5f                   	pop    %edi
 95a:	5d                   	pop    %ebp
 95b:	c3                   	ret    
 95c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 960:	39 c2                	cmp    %eax,%edx
 962:	72 c4                	jb     928 <free+0x18>
 964:	39 c1                	cmp    %eax,%ecx
 966:	73 c0                	jae    928 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 968:	8b 73 fc             	mov    -0x4(%ebx),%esi
 96b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 96e:	39 f8                	cmp    %edi,%eax
 970:	75 d0                	jne    942 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 972:	03 70 04             	add    0x4(%eax),%esi
 975:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 978:	8b 02                	mov    (%edx),%eax
 97a:	8b 00                	mov    (%eax),%eax
 97c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 97f:	8b 42 04             	mov    0x4(%edx),%eax
 982:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 985:	39 f1                	cmp    %esi,%ecx
 987:	75 c6                	jne    94f <free+0x3f>
    p->s.size += bp->s.size;
 989:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 98c:	89 15 3c 0f 00 00    	mov    %edx,0xf3c
    p->s.size += bp->s.size;
 992:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 995:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 998:	89 0a                	mov    %ecx,(%edx)
}
 99a:	5b                   	pop    %ebx
 99b:	5e                   	pop    %esi
 99c:	5f                   	pop    %edi
 99d:	5d                   	pop    %ebp
 99e:	c3                   	ret    
 99f:	90                   	nop

000009a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
 9a5:	53                   	push   %ebx
 9a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9ac:	8b 3d 3c 0f 00 00    	mov    0xf3c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	8d 70 07             	lea    0x7(%eax),%esi
 9b5:	c1 ee 03             	shr    $0x3,%esi
 9b8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9bb:	85 ff                	test   %edi,%edi
 9bd:	0f 84 9d 00 00 00    	je     a60 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 9c5:	8b 4a 04             	mov    0x4(%edx),%ecx
 9c8:	39 f1                	cmp    %esi,%ecx
 9ca:	73 6a                	jae    a36 <malloc+0x96>
 9cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9d1:	39 de                	cmp    %ebx,%esi
 9d3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9d6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 9dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9e0:	eb 17                	jmp    9f9 <malloc+0x59>
 9e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9ea:	8b 48 04             	mov    0x4(%eax),%ecx
 9ed:	39 f1                	cmp    %esi,%ecx
 9ef:	73 4f                	jae    a40 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f1:	8b 3d 3c 0f 00 00    	mov    0xf3c,%edi
 9f7:	89 c2                	mov    %eax,%edx
 9f9:	39 d7                	cmp    %edx,%edi
 9fb:	75 eb                	jne    9e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 9fd:	83 ec 0c             	sub    $0xc,%esp
 a00:	ff 75 e4             	push   -0x1c(%ebp)
 a03:	e8 83 fc ff ff       	call   68b <sbrk>
  if(p == (char*)-1)
 a08:	83 c4 10             	add    $0x10,%esp
 a0b:	83 f8 ff             	cmp    $0xffffffff,%eax
 a0e:	74 1c                	je     a2c <malloc+0x8c>
  hp->s.size = nu;
 a10:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a13:	83 ec 0c             	sub    $0xc,%esp
 a16:	83 c0 08             	add    $0x8,%eax
 a19:	50                   	push   %eax
 a1a:	e8 f1 fe ff ff       	call   910 <free>
  return freep;
 a1f:	8b 15 3c 0f 00 00    	mov    0xf3c,%edx
      if((p = morecore(nunits)) == 0)
 a25:	83 c4 10             	add    $0x10,%esp
 a28:	85 d2                	test   %edx,%edx
 a2a:	75 bc                	jne    9e8 <malloc+0x48>
        return 0;
  }
}
 a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a2f:	31 c0                	xor    %eax,%eax
}
 a31:	5b                   	pop    %ebx
 a32:	5e                   	pop    %esi
 a33:	5f                   	pop    %edi
 a34:	5d                   	pop    %ebp
 a35:	c3                   	ret    
    if(p->s.size >= nunits){
 a36:	89 d0                	mov    %edx,%eax
 a38:	89 fa                	mov    %edi,%edx
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a40:	39 ce                	cmp    %ecx,%esi
 a42:	74 4c                	je     a90 <malloc+0xf0>
        p->s.size -= nunits;
 a44:	29 f1                	sub    %esi,%ecx
 a46:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a49:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a4c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 a4f:	89 15 3c 0f 00 00    	mov    %edx,0xf3c
}
 a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a58:	83 c0 08             	add    $0x8,%eax
}
 a5b:	5b                   	pop    %ebx
 a5c:	5e                   	pop    %esi
 a5d:	5f                   	pop    %edi
 a5e:	5d                   	pop    %ebp
 a5f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 a60:	c7 05 3c 0f 00 00 40 	movl   $0xf40,0xf3c
 a67:	0f 00 00 
    base.s.size = 0;
 a6a:	bf 40 0f 00 00       	mov    $0xf40,%edi
    base.s.ptr = freep = prevp = &base;
 a6f:	c7 05 40 0f 00 00 40 	movl   $0xf40,0xf40
 a76:	0f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a79:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 a7b:	c7 05 44 0f 00 00 00 	movl   $0x0,0xf44
 a82:	00 00 00 
    if(p->s.size >= nunits){
 a85:	e9 42 ff ff ff       	jmp    9cc <malloc+0x2c>
 a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a90:	8b 08                	mov    (%eax),%ecx
 a92:	89 0a                	mov    %ecx,(%edx)
 a94:	eb b9                	jmp    a4f <malloc+0xaf>
 a96:	66 90                	xchg   %ax,%ax
 a98:	66 90                	xchg   %ax,%ax
 a9a:	66 90                	xchg   %ax,%ax
 a9c:	66 90                	xchg   %ax,%ax
 a9e:	66 90                	xchg   %ax,%ax

00000aa0 <srand>:

static unsigned long next = 1;

/* RAND_MAX assumed to be 32767 */

void srand(unsigned seed) {
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
    next = seed;
 aa3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 aa6:	5d                   	pop    %ebp
    next = seed;
 aa7:	a3 28 0f 00 00       	mov    %eax,0xf28
}
 aac:	c3                   	ret    
 aad:	8d 76 00             	lea    0x0(%esi),%esi

00000ab0 <rand>:
int rand(void) {
    next = next * 1103515245 + 12345;
 ab0:	69 05 28 0f 00 00 6d 	imul   $0x41c64e6d,0xf28,%eax
 ab7:	4e c6 41 
 aba:	05 39 30 00 00       	add    $0x3039,%eax
 abf:	a3 28 0f 00 00       	mov    %eax,0xf28
    return((unsigned)(next/65536) % RAND_MAX);
 ac4:	c1 e8 10             	shr    $0x10,%eax
}
 ac7:	c3                   	ret    
