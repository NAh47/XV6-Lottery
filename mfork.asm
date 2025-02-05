
_mfork:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *exec_args[] = {"mult", '\0'};

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  int i;
  int max = 5;
  int pid = 0;

  if (argc > 1) {
  13:	83 39 01             	cmpl   $0x1,(%ecx)
{
  16:	8b 41 04             	mov    0x4(%ecx),%eax
  if (argc > 1) {
  19:	7f 5c                	jg     77 <main+0x77>
    max = atoi(argv[1]);
  }
  printf(1, "forking %d processes\n", max);
  1b:	52                   	push   %edx
  int max = 5;
  1c:	be 05 00 00 00       	mov    $0x5,%esi
  printf(1, "forking %d processes\n", max);
  21:	6a 05                	push   $0x5
  23:	68 b8 07 00 00       	push   $0x7b8
  28:	6a 01                	push   $0x1
  2a:	e8 31 04 00 00       	call   460 <printf>
  2f:	83 c4 10             	add    $0x10,%esp

  for (i = 0; i < max; i++) {
  32:	31 db                	xor    %ebx,%ebx
  34:	eb 11                	jmp    47 <main+0x47>
  36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3d:	8d 76 00             	lea    0x0(%esi),%esi
  40:	83 c3 01             	add    $0x1,%ebx
  43:	39 de                	cmp    %ebx,%esi
  45:	7e 54                	jle    9b <main+0x9b>
    pid = fork();
  47:	e8 9f 02 00 00       	call   2eb <fork>
    if (pid == 0) {
  4c:	85 c0                	test   %eax,%eax
  4e:	75 f0                	jne    40 <main+0x40>
      exec(exec_args[0], exec_args);
  50:	50                   	push   %eax
  51:	50                   	push   %eax
  52:	68 34 0b 00 00       	push   $0xb34
  57:	ff 35 34 0b 00 00    	push   0xb34
  5d:	e8 c9 02 00 00       	call   32b <exec>
      printf(1, "fork failed for process %d\n", i);
  62:	83 c4 0c             	add    $0xc,%esp
  65:	53                   	push   %ebx
  66:	68 ce 07 00 00       	push   $0x7ce
  6b:	6a 01                	push   $0x1
  6d:	e8 ee 03 00 00       	call   460 <printf>
      exit();
  72:	e8 7c 02 00 00       	call   2f3 <exit>
    max = atoi(argv[1]);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	ff 70 04             	push   0x4(%eax)
  7d:	e8 fe 01 00 00       	call   280 <atoi>
  printf(1, "forking %d processes\n", max);
  82:	83 c4 0c             	add    $0xc,%esp
  85:	50                   	push   %eax
    max = atoi(argv[1]);
  86:	89 c6                	mov    %eax,%esi
  printf(1, "forking %d processes\n", max);
  88:	68 b8 07 00 00       	push   $0x7b8
  8d:	6a 01                	push   $0x1
  8f:	e8 cc 03 00 00       	call   460 <printf>
  for (i = 0; i < max; i++) {
  94:	83 c4 10             	add    $0x10,%esp
  97:	85 f6                	test   %esi,%esi
  99:	7f 97                	jg     32 <main+0x32>

  // This process does not wait for the forked programs
  // to complete. It leaves them as orphans.

  // in xv6, exit() does not take a parameter.
  exit();
  9b:	e8 53 02 00 00       	call   2f3 <exit>

000000a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a1:	31 c0                	xor    %eax,%eax
{
  a3:	89 e5                	mov    %esp,%ebp
  a5:	53                   	push   %ebx
  a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  b7:	83 c0 01             	add    $0x1,%eax
  ba:	84 d2                	test   %dl,%dl
  bc:	75 f2                	jne    b0 <strcpy+0x10>
    ;
  return os;
}
  be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c1:	89 c8                	mov    %ecx,%eax
  c3:	c9                   	leave  
  c4:	c3                   	ret    
  c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	8b 55 08             	mov    0x8(%ebp),%edx
  d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  da:	0f b6 02             	movzbl (%edx),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 17                	jne    f8 <strcmp+0x28>
  e1:	eb 3a                	jmp    11d <strcmp+0x4d>
  e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  e7:	90                   	nop
  e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ec:	83 c2 01             	add    $0x1,%edx
  ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  f2:	84 c0                	test   %al,%al
  f4:	74 1a                	je     110 <strcmp+0x40>
    p++, q++;
  f6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  f8:	0f b6 19             	movzbl (%ecx),%ebx
  fb:	38 c3                	cmp    %al,%bl
  fd:	74 e9                	je     e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  ff:	29 d8                	sub    %ebx,%eax
}
 101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 104:	c9                   	leave  
 105:	c3                   	ret    
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 110:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 114:	31 c0                	xor    %eax,%eax
 116:	29 d8                	sub    %ebx,%eax
}
 118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11b:	c9                   	leave  
 11c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 11d:	0f b6 19             	movzbl (%ecx),%ebx
 120:	31 c0                	xor    %eax,%eax
 122:	eb db                	jmp    ff <strcmp+0x2f>
 124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop

00000130 <strlen>:

uint
strlen(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 3a 00             	cmpb   $0x0,(%edx)
 139:	74 15                	je     150 <strlen+0x20>
 13b:	31 c0                	xor    %eax,%eax
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c0 01             	add    $0x1,%eax
 143:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 147:	89 c1                	mov    %eax,%ecx
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	89 c8                	mov    %ecx,%eax
 14d:	5d                   	pop    %ebp
 14e:	c3                   	ret    
 14f:	90                   	nop
  for(n = 0; s[n]; n++)
 150:	31 c9                	xor    %ecx,%ecx
}
 152:	5d                   	pop    %ebp
 153:	89 c8                	mov    %ecx,%eax
 155:	c3                   	ret    
 156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15d:	8d 76 00             	lea    0x0(%esi),%esi

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	8b 7d fc             	mov    -0x4(%ebp),%edi
 175:	89 d0                	mov    %edx,%eax
 177:	c9                   	leave  
 178:	c3                   	ret    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	75 12                	jne    1a3 <strchr+0x23>
 191:	eb 1d                	jmp    1b0 <strchr+0x30>
 193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 197:	90                   	nop
 198:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	84 d2                	test   %dl,%dl
 1a1:	74 0d                	je     1b0 <strchr+0x30>
    if(*s == c)
 1a3:	38 d1                	cmp    %dl,%cl
 1a5:	75 f1                	jne    198 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1b0:	31 c0                	xor    %eax,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
 1b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1bf:	90                   	nop

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1c5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1c9:	31 db                	xor    %ebx,%ebx
{
 1cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ce:	eb 27                	jmp    1f7 <gets+0x37>
    cc = read(0, &c, 1);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	6a 01                	push   $0x1
 1d5:	57                   	push   %edi
 1d6:	6a 00                	push   $0x0
 1d8:	e8 2e 01 00 00       	call   30b <read>
    if(cc < 1)
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	85 c0                	test   %eax,%eax
 1e2:	7e 1d                	jle    201 <gets+0x41>
      break;
    buf[i++] = c;
 1e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
 1eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ef:	3c 0a                	cmp    $0xa,%al
 1f1:	74 1d                	je     210 <gets+0x50>
 1f3:	3c 0d                	cmp    $0xd,%al
 1f5:	74 19                	je     210 <gets+0x50>
  for(i=0; i+1 < max; ){
 1f7:	89 de                	mov    %ebx,%esi
 1f9:	83 c3 01             	add    $0x1,%ebx
 1fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ff:	7c cf                	jl     1d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 208:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20b:	5b                   	pop    %ebx
 20c:	5e                   	pop    %esi
 20d:	5f                   	pop    %edi
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    
  buf[i] = '\0';
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	89 de                	mov    %ebx,%esi
 215:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 219:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21c:	5b                   	pop    %ebx
 21d:	5e                   	pop    %esi
 21e:	5f                   	pop    %edi
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    
 221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	push   0x8(%ebp)
 23d:	e8 f1 00 00 00       	call   333 <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	push   0xc(%ebp)
 24f:	89 c3                	mov    %eax,%ebx
 251:	50                   	push   %eax
 252:	e8 f4 00 00 00       	call   34b <fstat>
  close(fd);
 257:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25a:	89 c6                	mov    %eax,%esi
  close(fd);
 25c:	e8 ba 00 00 00       	call   31b <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	8d 65 f8             	lea    -0x8(%ebp),%esp
 267:	89 f0                	mov    %esi,%eax
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 02             	movsbl (%edx),%eax
 28a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 28d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 290:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 295:	77 1e                	ja     2b5 <atoi+0x35>
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2aa:	0f be 02             	movsbl (%edx),%eax
 2ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b8:	89 c8                	mov    %ecx,%eax
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 45 10             	mov    0x10(%ebp),%eax
 2c7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ca:	56                   	push   %esi
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 c0                	test   %eax,%eax
 2d0:	7e 13                	jle    2e5 <memmove+0x25>
 2d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d4:	89 d7                	mov    %edx,%edi
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 f8                	cmp    %edi,%eax
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <getppid>:
#ifdef GETPPID
SYSCALL(getppid)
 393:	b8 16 00 00 00       	mov    $0x16,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <cps>:
#endif // GETPPID    
#ifdef CPS
SYSCALL(cps)
 39b:	b8 17 00 00 00       	mov    $0x17,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <renice>:
#endif // CPS
#ifdef LOTTERY
SYSCALL(renice)
 3a3:	b8 18 00 00 00       	mov    $0x18,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 3c             	sub    $0x3c,%esp
 3b9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3bc:	89 d1                	mov    %edx,%ecx
{
 3be:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3c1:	85 d2                	test   %edx,%edx
 3c3:	0f 89 7f 00 00 00    	jns    448 <printint+0x98>
 3c9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3cd:	74 79                	je     448 <printint+0x98>
    neg = 1;
 3cf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3d6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3d8:	31 db                	xor    %ebx,%ebx
 3da:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e0:	89 c8                	mov    %ecx,%eax
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	89 cf                	mov    %ecx,%edi
 3e6:	f7 75 c4             	divl   -0x3c(%ebp)
 3e9:	0f b6 92 50 08 00 00 	movzbl 0x850(%edx),%edx
 3f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3f3:	89 d8                	mov    %ebx,%eax
 3f5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3f8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3fb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3fe:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 401:	76 dd                	jbe    3e0 <printint+0x30>
  if(neg)
 403:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 406:	85 c9                	test   %ecx,%ecx
 408:	74 0c                	je     416 <printint+0x66>
    buf[i++] = '-';
 40a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 40f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 411:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 416:	8b 7d b8             	mov    -0x48(%ebp),%edi
 419:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 41d:	eb 07                	jmp    426 <printint+0x76>
 41f:	90                   	nop
    putc(fd, buf[i]);
 420:	0f b6 13             	movzbl (%ebx),%edx
 423:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 426:	83 ec 04             	sub    $0x4,%esp
 429:	88 55 d7             	mov    %dl,-0x29(%ebp)
 42c:	6a 01                	push   $0x1
 42e:	56                   	push   %esi
 42f:	57                   	push   %edi
 430:	e8 de fe ff ff       	call   313 <write>
  while(--i >= 0)
 435:	83 c4 10             	add    $0x10,%esp
 438:	39 de                	cmp    %ebx,%esi
 43a:	75 e4                	jne    420 <printint+0x70>
}
 43c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43f:	5b                   	pop    %ebx
 440:	5e                   	pop    %esi
 441:	5f                   	pop    %edi
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 448:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 44f:	eb 87                	jmp    3d8 <printint+0x28>
 451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop

00000460 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 469:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 46c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 46f:	0f b6 13             	movzbl (%ebx),%edx
 472:	84 d2                	test   %dl,%dl
 474:	74 6a                	je     4e0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 476:	8d 45 10             	lea    0x10(%ebp),%eax
 479:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 47c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 47f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 481:	89 45 d0             	mov    %eax,-0x30(%ebp)
 484:	eb 36                	jmp    4bc <printf+0x5c>
 486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
 490:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 493:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	74 15                	je     4b2 <printf+0x52>
  write(fd, &c, 1);
 49d:	83 ec 04             	sub    $0x4,%esp
 4a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4a3:	6a 01                	push   $0x1
 4a5:	57                   	push   %edi
 4a6:	56                   	push   %esi
 4a7:	e8 67 fe ff ff       	call   313 <write>
 4ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4af:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4b2:	0f b6 13             	movzbl (%ebx),%edx
 4b5:	83 c3 01             	add    $0x1,%ebx
 4b8:	84 d2                	test   %dl,%dl
 4ba:	74 24                	je     4e0 <printf+0x80>
    c = fmt[i] & 0xff;
 4bc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4bf:	85 c9                	test   %ecx,%ecx
 4c1:	74 cd                	je     490 <printf+0x30>
      }
    } else if(state == '%'){
 4c3:	83 f9 25             	cmp    $0x25,%ecx
 4c6:	75 ea                	jne    4b2 <printf+0x52>
      if(c == 'd' || c == 'u'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	0f 84 ff 00 00 00    	je     5d0 <printf+0x170>
 4d1:	83 e8 63             	sub    $0x63,%eax
 4d4:	83 f8 15             	cmp    $0x15,%eax
 4d7:	77 17                	ja     4f0 <printf+0x90>
 4d9:	ff 24 85 f8 07 00 00 	jmp    *0x7f8(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop
  write(fd, &c, 1);
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4f6:	6a 01                	push   $0x1
 4f8:	57                   	push   %edi
 4f9:	56                   	push   %esi
 4fa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4fe:	e8 10 fe ff ff       	call   313 <write>
        putc(fd, c);
 503:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 507:	83 c4 0c             	add    $0xc,%esp
 50a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 50d:	6a 01                	push   $0x1
 50f:	57                   	push   %edi
 510:	56                   	push   %esi
 511:	e8 fd fd ff ff       	call   313 <write>
        putc(fd, c);
 516:	83 c4 10             	add    $0x10,%esp
      state = 0;
 519:	31 c9                	xor    %ecx,%ecx
 51b:	eb 95                	jmp    4b2 <printf+0x52>
 51d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
 528:	6a 00                	push   $0x0
 52a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 52d:	8b 10                	mov    (%eax),%edx
 52f:	89 f0                	mov    %esi,%eax
 531:	e8 7a fe ff ff       	call   3b0 <printint>
        ap++;
 536:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 53a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53d:	31 c9                	xor    %ecx,%ecx
 53f:	e9 6e ff ff ff       	jmp    4b2 <printf+0x52>
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 548:	83 ec 0c             	sub    $0xc,%esp
 54b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 550:	6a 01                	push   $0x1
 552:	eb d6                	jmp    52a <printf+0xca>
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 558:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 55b:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 55e:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 560:	6a 01                	push   $0x1
 562:	57                   	push   %edi
 563:	56                   	push   %esi
        putc(fd, *ap);
 564:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 567:	e8 a7 fd ff ff       	call   313 <write>
        ap++;
 56c:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 570:	83 c4 10             	add    $0x10,%esp
      state = 0;
 573:	31 c9                	xor    %ecx,%ecx
 575:	e9 38 ff ff ff       	jmp    4b2 <printf+0x52>
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = (char*)*ap;
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
 583:	8b 10                	mov    (%eax),%edx
        ap++;
 585:	83 c0 04             	add    $0x4,%eax
 588:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 58b:	85 d2                	test   %edx,%edx
 58d:	74 51                	je     5e0 <printf+0x180>
        while(*s != 0){
 58f:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 592:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 594:	84 c0                	test   %al,%al
 596:	0f 84 16 ff ff ff    	je     4b2 <printf+0x52>
 59c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 59f:	89 d3                	mov    %edx,%ebx
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 5a8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5ab:	83 c3 01             	add    $0x1,%ebx
 5ae:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b1:	6a 01                	push   $0x1
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	e8 59 fd ff ff       	call   313 <write>
        while(*s != 0){
 5ba:	0f b6 03             	movzbl (%ebx),%eax
 5bd:	83 c4 10             	add    $0x10,%esp
 5c0:	84 c0                	test   %al,%al
 5c2:	75 e4                	jne    5a8 <printf+0x148>
      state = 0;
 5c4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5c7:	31 c9                	xor    %ecx,%ecx
 5c9:	e9 e4 fe ff ff       	jmp    4b2 <printf+0x52>
 5ce:	66 90                	xchg   %ax,%ax
        putc(fd, c);
 5d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	e9 32 ff ff ff       	jmp    50d <printf+0xad>
 5db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
          s = "(null)";
 5e0:	ba ef 07 00 00       	mov    $0x7ef,%edx
        while(*s != 0){
 5e5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5e8:	b8 28 00 00 00       	mov    $0x28,%eax
 5ed:	89 d3                	mov    %edx,%ebx
 5ef:	eb b7                	jmp    5a8 <printf+0x148>
 5f1:	66 90                	xchg   %ax,%ax
 5f3:	66 90                	xchg   %ax,%ax
 5f5:	66 90                	xchg   %ax,%ax
 5f7:	66 90                	xchg   %ax,%ax
 5f9:	66 90                	xchg   %ax,%ax
 5fb:	66 90                	xchg   %ax,%ax
 5fd:	66 90                	xchg   %ax,%ax
 5ff:	90                   	nop

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 40 0b 00 00       	mov    0xb40,%eax
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 618:	89 c2                	mov    %eax,%edx
 61a:	8b 00                	mov    (%eax),%eax
 61c:	39 ca                	cmp    %ecx,%edx
 61e:	73 30                	jae    650 <free+0x50>
 620:	39 c1                	cmp    %eax,%ecx
 622:	72 04                	jb     628 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 624:	39 c2                	cmp    %eax,%edx
 626:	72 f0                	jb     618 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 628:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62e:	39 f8                	cmp    %edi,%eax
 630:	74 30                	je     662 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 632:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 635:	8b 42 04             	mov    0x4(%edx),%eax
 638:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 63b:	39 f1                	cmp    %esi,%ecx
 63d:	74 3a                	je     679 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 63f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 641:	5b                   	pop    %ebx
  freep = p;
 642:	89 15 40 0b 00 00    	mov    %edx,0xb40
}
 648:	5e                   	pop    %esi
 649:	5f                   	pop    %edi
 64a:	5d                   	pop    %ebp
 64b:	c3                   	ret    
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 c2                	cmp    %eax,%edx
 652:	72 c4                	jb     618 <free+0x18>
 654:	39 c1                	cmp    %eax,%ecx
 656:	73 c0                	jae    618 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 658:	8b 73 fc             	mov    -0x4(%ebx),%esi
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 f8                	cmp    %edi,%eax
 660:	75 d0                	jne    632 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 662:	03 70 04             	add    0x4(%eax),%esi
 665:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	8b 02                	mov    (%edx),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 66f:	8b 42 04             	mov    0x4(%edx),%eax
 672:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 675:	39 f1                	cmp    %esi,%ecx
 677:	75 c6                	jne    63f <free+0x3f>
    p->s.size += bp->s.size;
 679:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 67c:	89 15 40 0b 00 00    	mov    %edx,0xb40
    p->s.size += bp->s.size;
 682:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 685:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 688:	89 0a                	mov    %ecx,(%edx)
}
 68a:	5b                   	pop    %ebx
 68b:	5e                   	pop    %esi
 68c:	5f                   	pop    %edi
 68d:	5d                   	pop    %ebp
 68e:	c3                   	ret    
 68f:	90                   	nop

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 3d 40 0b 00 00    	mov    0xb40,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 70 07             	lea    0x7(%eax),%esi
 6a5:	c1 ee 03             	shr    $0x3,%esi
 6a8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6ab:	85 ff                	test   %edi,%edi
 6ad:	0f 84 9d 00 00 00    	je     750 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6b5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6b8:	39 f1                	cmp    %esi,%ecx
 6ba:	73 6a                	jae    726 <malloc+0x96>
 6bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c1:	39 de                	cmp    %ebx,%esi
 6c3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6c6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6d0:	eb 17                	jmp    6e9 <malloc+0x59>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 f1                	cmp    %esi,%ecx
 6df:	73 4f                	jae    730 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	8b 3d 40 0b 00 00    	mov    0xb40,%edi
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	39 d7                	cmp    %edx,%edi
 6eb:	75 eb                	jne    6d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	ff 75 e4             	push   -0x1c(%ebp)
 6f3:	e8 83 fc ff ff       	call   37b <sbrk>
  if(p == (char*)-1)
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fe:	74 1c                	je     71c <malloc+0x8c>
  hp->s.size = nu;
 700:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 703:	83 ec 0c             	sub    $0xc,%esp
 706:	83 c0 08             	add    $0x8,%eax
 709:	50                   	push   %eax
 70a:	e8 f1 fe ff ff       	call   600 <free>
  return freep;
 70f:	8b 15 40 0b 00 00    	mov    0xb40,%edx
      if((p = morecore(nunits)) == 0)
 715:	83 c4 10             	add    $0x10,%esp
 718:	85 d2                	test   %edx,%edx
 71a:	75 bc                	jne    6d8 <malloc+0x48>
        return 0;
  }
}
 71c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 71f:	31 c0                	xor    %eax,%eax
}
 721:	5b                   	pop    %ebx
 722:	5e                   	pop    %esi
 723:	5f                   	pop    %edi
 724:	5d                   	pop    %ebp
 725:	c3                   	ret    
    if(p->s.size >= nunits){
 726:	89 d0                	mov    %edx,%eax
 728:	89 fa                	mov    %edi,%edx
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 730:	39 ce                	cmp    %ecx,%esi
 732:	74 4c                	je     780 <malloc+0xf0>
        p->s.size -= nunits;
 734:	29 f1                	sub    %esi,%ecx
 736:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 739:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 73c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 73f:	89 15 40 0b 00 00    	mov    %edx,0xb40
}
 745:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 748:	83 c0 08             	add    $0x8,%eax
}
 74b:	5b                   	pop    %ebx
 74c:	5e                   	pop    %esi
 74d:	5f                   	pop    %edi
 74e:	5d                   	pop    %ebp
 74f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 750:	c7 05 40 0b 00 00 44 	movl   $0xb44,0xb40
 757:	0b 00 00 
    base.s.size = 0;
 75a:	bf 44 0b 00 00       	mov    $0xb44,%edi
    base.s.ptr = freep = prevp = &base;
 75f:	c7 05 44 0b 00 00 44 	movl   $0xb44,0xb44
 766:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 769:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 76b:	c7 05 48 0b 00 00 00 	movl   $0x0,0xb48
 772:	00 00 00 
    if(p->s.size >= nunits){
 775:	e9 42 ff ff ff       	jmp    6bc <malloc+0x2c>
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb b9                	jmp    73f <malloc+0xaf>
 786:	66 90                	xchg   %ax,%ax
 788:	66 90                	xchg   %ax,%ax
 78a:	66 90                	xchg   %ax,%ax
 78c:	66 90                	xchg   %ax,%ax
 78e:	66 90                	xchg   %ax,%ax

00000790 <srand>:

static unsigned long next = 1;

/* RAND_MAX assumed to be 32767 */

void srand(unsigned seed) {
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
    next = seed;
 793:	8b 45 08             	mov    0x8(%ebp),%eax
}
 796:	5d                   	pop    %ebp
    next = seed;
 797:	a3 3c 0b 00 00       	mov    %eax,0xb3c
}
 79c:	c3                   	ret    
 79d:	8d 76 00             	lea    0x0(%esi),%esi

000007a0 <rand>:
int rand(void) {
    next = next * 1103515245 + 12345;
 7a0:	69 05 3c 0b 00 00 6d 	imul   $0x41c64e6d,0xb3c,%eax
 7a7:	4e c6 41 
 7aa:	05 39 30 00 00       	add    $0x3039,%eax
 7af:	a3 3c 0b 00 00       	mov    %eax,0xb3c
    return((unsigned)(next/65536) % RAND_MAX);
 7b4:	c1 e8 10             	shr    $0x10,%eax
}
 7b7:	c3                   	ret    
