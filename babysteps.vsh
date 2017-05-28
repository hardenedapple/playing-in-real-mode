vshcmd: > # Used the following to create totalUSB.img, in the fututre, use
vshcmd: > # dd to reset the boot partition, and to install my changes.
vshcmd: > # vshcmd: > cp otherBIOSes/full_debian_install.img ./totalUSB.img
vshcmd: > #
vshcmd: > # Use the below to reset the USB to check the debianGRUB still works.
vshcmd: > # vshcmd: > dd if=otherBIOSes/debian_GRUB.img of=totalUSB.img conv=notrunc
vshcmd: > gcc -E boot.S > boot.asm
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
vshcmd: > dd if=boot of=totalUSB.img conv=notrunc
vshcmd: > qemu-system-x86_64 -drive file=totalUSB.img,format=raw
bootloader [14:50:45] $ bootloader [14:50:45] $ bootloader [14:50:45] $ 5+0 records in
5+0 records out
2560 bytes (2.6 kB, 2.5 KiB) copied, 0.000216019 s, 11.9 MB/s
bootloader [14:50:45] $ bootloader [14:50:51] $ 
vshcmd: > asbytes att '.code16; _start: movl _start, %eax; movl %eax, end; end:'
00000000: 66 a1 00 7c 66 a3 08 7c                          f..|f..|
bootloader [13:31:29] $ 
vshcmd: > objdump -Maddr16,data16 -d boot.o

boot.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <_bootsector>:
   0:	ea                   	(bad)  
   1:	00 00                	add    %al,(%rax)
	...

0000000000000005 <_start>:
   5:	fa                   	cli    
   6:	31 c0                	xor    %ax,%ax
   8:	8e d8                	mov    %ax,%ds
   a:	8e c0                	mov    %ax,%es
   c:	b8 c0 8f             	mov    $0x8fc0,%ax
   f:	8e d0                	mov    %ax,%ss
  11:	bc ff ff             	mov    $0xffff,%sp
  14:	fb                   	sti    
  15:	e8 97 00             	call   af <initialiseDisks>
  18:	e8 12 00             	call   2d <clearScreen>
  1b:	e8 c8 00             	call   e6 <readFromHardDrive>
  1e:	e9 df 01             	jmp    200 <secondStage_start>

0000000000000021 <errmsg>:
  21:	e8 17 00             	call   3b <BIOSprint>
  24:	58                   	pop    %ax
  25:	a3                   	.byte 0xa3
  26:	00 00                	add    %al,(%rax)
  28:	50                   	push   %ax
  29:	e8 23 00             	call   4f <printReg>
  2c:	c3                   	ret    

000000000000002d <clearScreen>:
  2d:	b8 03 00             	mov    $0x3,%ax
  30:	cd 10                	int    $0x10
  32:	fc                   	cld    
  33:	c3                   	ret    
  34:	bb 01 00             	mov    $0x1,%bx
  37:	b4 0e                	mov    $0xe,%ah
  39:	cd 10                	int    $0x10

000000000000003b <BIOSprint>:
  3b:	ac                   	lods   %ds:(%rsi),%al
  3c:	3c 00                	cmp    $0x0,%al
  3e:	75 f4                	jne    34 <clearScreen+0x7>
  40:	c3                   	ret    

0000000000000041 <newline>:
  41:	bb 01 00             	mov    $0x1,%bx
  44:	b4 0e                	mov    $0xe,%ah
  46:	b0 0a                	mov    $0xa,%al
  48:	cd 10                	int    $0x10
  4a:	b0 0d                	mov    $0xd,%al
  4c:	cd 10                	int    $0x10
  4e:	c3                   	ret    

000000000000004f <printReg>:
  4f:	3c 00                	cmp    $0x0,%al
  51:	74 02                	je     55 <printReg+0x6>
  53:	b0 0a                	mov    $0xa,%al
  55:	a2 00 00 bf 00 00 a1 	movabs %al,0xa10000bf0000
  5c:	00 00 
  5e:	be 00 00             	mov    $0x0,%si
  61:	b9 04 00             	mov    $0x4,%cx

0000000000000064 <hexloop>:
  64:	c1 c0 04             	rol    $0x4,%ax
  67:	89 c3                	mov    %ax,%bx
  69:	83 e3 0f             	and    $0xf,%bx
  6c:	8a 18                	mov    (%rax),%bl
  6e:	88 1d 47 e2 f1 be    	mov    %bl,-0x410e1db9(%rip)        # ffffffffbef1e2bb <secondStage_end_addr+0xffffffffbef15cbb>
  74:	00 00                	add    %al,(%rax)
  76:	e8 c2 ff             	call   3b <BIOSprint>
  79:	c3                   	ret    

000000000000007a <printDWORD>:
  7a:	a3                   	.byte 0xa3
  7b:	00 00                	add    %al,(%rax)
  7d:	b9 01 00             	mov    $0x1,%cx
  80:	eb 06                	jmp    88 <printQWORD+0x6>

0000000000000082 <printQWORD>:
  82:	a3 00 00 b9 03 00 8b 	movabs %ax,0x368b0003b90000
  89:	36 00 
  8b:	00 89 c8 d1 e0 01    	add    %cl,0x1e0d1c8(%rcx)
  91:	c6                   	(bad)  
  92:	8b 04 a3             	mov    (%rbx,%riz,4),%ax
  95:	00 00                	add    %al,(%rax)
  97:	51                   	push   %cx
  98:	b0 00                	mov    $0x0,%al
  9a:	e8 b2 ff             	call   4f <printReg>
  9d:	59                   	pop    %cx
  9e:	e2 e8                	loop   88 <printQWORD+0x6>

00000000000000a0 <printQWORDfin>:
  a0:	8b 36                	mov    (%rsi),%si
  a2:	00 00                	add    %al,(%rax)
  a4:	8b 04 a3             	mov    (%rbx,%riz,4),%ax
  a7:	00 00                	add    %al,(%rax)
  a9:	b0 01                	mov    $0x1,%al
  ab:	e8 a1 ff             	call   4f <printReg>
  ae:	c3                   	ret    

00000000000000af <initialiseDisks>:
  af:	88 16                	mov    %dl,(%rsi)
  b1:	00 00                	add    %al,(%rax)
  b3:	b4 00                	mov    $0x0,%ah
  b5:	cd 13                	int    $0x13
  b7:	72 15                	jb     ce <ignoreerror+0x15>

00000000000000b9 <ignoreerror>:
  b9:	b4 41                	mov    $0x41,%ah
  bb:	bb aa 55             	mov    $0x55aa,%bx
  be:	cd 13                	int    $0x13
  c0:	72 1c                	jb     de <ignoreerror+0x25>
  c2:	81 fb 55 aa          	cmp    $0xaa55,%bx
  c6:	75 16                	jne    de <ignoreerror+0x25>
  c8:	83 e1 01             	and    $0x1,%cx
  cb:	74 11                	je     de <ignoreerror+0x25>
  cd:	c3                   	ret    
  ce:	b0 00                	mov    $0x0,%al
  d0:	a3 00 00 e8 79 ff be 	movabs %ax,0xbeff79e80000
  d7:	00 00 
  d9:	e8 45 ff             	call   21 <errmsg>
  dc:	eb db                	jmp    b9 <ignoreerror>
  de:	be 00 00             	mov    $0x0,%si
  e1:	e8 3d ff             	call   21 <errmsg>
  e4:	eb fe                	jmp    e4 <ignoreerror+0x2b>

00000000000000e6 <readFromHardDrive>:
  e6:	a1 00 00 50 83 e0 7f 	movabs 0xa37fe083500000,%ax
  ed:	a3 00 
  ef:	00 e8                	add    %ch,%al
  f1:	0f 00 58 2d          	ltr    0x2d(%rax)
  f5:	80 00 77             	addb   $0x77,(%rax)
  f8:	f0 c3                	lock ret 
  fa:	2b 0e                	sub    (%rsi),%cx
  fc:	00 00                	add    %al,(%rax)
  fe:	89 0e                	mov    %cx,(%rsi)
	...

0000000000000102 <doRead>:
 102:	8b 0e                	mov    (%rsi),%cx
 104:	00 00                	add    %al,(%rax)
 106:	8a 16                	mov    (%rsi),%dl
 108:	00 00                	add    %al,(%rax)
 10a:	be 00 00             	mov    $0x0,%si
 10d:	b4 42                	mov    $0x42,%ah
 10f:	cd 13                	int    $0x13
 111:	73 06                	jae    119 <doRead+0x17>
 113:	be 00 00             	mov    $0x0,%si
 116:	e8 08 ff             	call   21 <errmsg>
 119:	84 e4                	test   %ah,%ah
 11b:	74 0c                	je     129 <doRead+0x27>
 11d:	a3 00 00 e8 2c ff be 	movabs %ax,0xbeff2ce80000
 124:	00 00 
 126:	e8 f8 fe             	call   21 <errmsg>
 129:	3b 0e                	cmp    (%rsi),%cx
 12b:	00 00                	add    %al,(%rax)
 12d:	74 08                	je     137 <doRead+0x35>
 12f:	77 c9                	ja     fa <readFromHardDrive+0x14>
 131:	be 00 00             	mov    $0x0,%si
 134:	e8 ea fe             	call   21 <errmsg>
 137:	c3                   	ret    

0000000000000138 <copyExtendedMemory>:
 138:	30 31                	xor    %dh,(%rcx)
 13a:	32 33                	xor    (%rbx),%dh
 13c:	34 35                	xor    $0x35,%al
 13e:	36 37                	ss (bad) 
 140:	38 39                	cmp    %bh,(%rcx)
 142:	41                   	rex.B
 143:	42                   	rex.X
 144:	43                   	rex.XB
 145:	44                   	rex.R
 146:	45                   	rex.RB
 147:	46                   	rex.RX

0000000000000148 <outstr16>:
 148:	00 00                	add    %al,(%rax)
 14a:	00 00                	add    %al,(%rax)
 14c:	0a                   	.byte 0xa
 14d:	0d                   	.byte 0xd
	...

000000000000014f <reg16>:
	...

0000000000000151 <storedaddr>:
	...

0000000000000153 <curdrive>:
	...

0000000000000154 <msgDiskFail>:
 154:	64 69 73 6b 2e 61    	imul   $0x612e,%fs:0x6b(%rbx),%si
 15a:	73 6d                	jae    1c9 <partition_start+0x3>
 15c:	20 70 72             	and    %dh,0x72(%rax)
 15f:	6f                   	outsw  %ds:(%rsi),(%dx)
 160:	62                   	(bad)  
 161:	6c                   	insb   (%dx),%es:(%rdi)
 162:	65 6d                	gs insw (%dx),%es:(%rdi)
	...

0000000000000165 <msgReadFailed>:
 165:	63 61 6e             	movslq 0x6e(%rcx),%sp
 168:	6e                   	outsb  %ds:(%rsi),(%dx)
 169:	6f                   	outsw  %ds:(%rsi),(%dx)
 16a:	74 20                	je     18c <startBlock+0x1>
 16c:	72 65                	jb     1d3 <partition_start+0xd>
 16e:	61                   	(bad)  
 16f:	64 20 00             	and    %al,%fs:(%rax)

0000000000000172 <msgNoLBA>:
 172:	6e                   	outsb  %ds:(%rsi),(%dx)
 173:	6f                   	outsw  %ds:(%rsi),(%dx)
 174:	20 69 6e             	and    %ch,0x6e(%rcx)
 177:	73 74                	jae    1ed <partition_start+0x27>
 179:	61                   	(bad)  
 17a:	6c                   	insb   (%dx),%es:(%rdi)
 17b:	6c                   	insb   (%dx),%es:(%rdi)
 17c:	65 64 20 4c 42 41    	gs and %cl,%fs:0x41(%rdx,%rax,2)
 182:	20                   	.byte 0x20

0000000000000183 <diskPacket>:
 183:	10                   	.byte 0x10

0000000000000184 <packetReserved>:
	...

0000000000000185 <numBlocks>:
 185:	04 00                	add    $0x0,%al

0000000000000187 <transferBuffer>:
 187:	00 7e 00             	add    %bh,0x0(%rsi)
	...

000000000000018b <startBlock>:
 18b:	01 00                	add    %ax,(%rax)
	...

00000000000001b8 <diskID>:
 1b8:	be eb ee             	mov    $0xeeeb,%si
 1bb:	fe 00                	incb   (%rax)
	...

00000000000001be <partition1>:
 1be:	80 00 00             	addb   $0x0,(%rax)
	...

00000000000001c2 <partition_type>:
 1c2:	df 00                	fild   (%rax)
	...

00000000000001c6 <partition_start>:
 1c6:	00 08                	add    %cl,(%rax)
 1c8:	00 00                	add    %al,(%rax)
 1ca:	64 00 00             	add    %al,%fs:(%rax)
	...
 1fd:	00 55 aa             	add    %dl,-0x56(%rbp)

0000000000000200 <secondStage_start>:
 200:	cd 12                	int    $0x12
 202:	d1 e0                	shl    %ax
 204:	73 0c                	jae    212 <secondStage_start+0x12>
 206:	a3 00 00 e8 43 fe be 	movabs %ax,0xbefe43e80000
 20d:	00 00 
 20f:	e8 0f fe             	call   21 <errmsg>
 212:	2d 43 00             	sub    $0x43,%ax
 215:	a3 00 00 e8 30 00 be 	movabs %ax,0xbe0030e80000
 21c:	00 00 
 21e:	e8 1a fe             	call   3b <BIOSprint>
 221:	31 c0                	xor    %ax,%ax
 223:	a0 00 00 83 c0 40 69 	movabs 0xc06940c0830000,%al
 22a:	c0 00 
 22c:	02 89 c4 b8 60 08    	add    0x860b8c4(%rcx),%cl
 232:	8e d8                	mov    %ax,%ds
 234:	8e d0                	mov    %ax,%ss
 236:	8e c0                	mov    %ax,%es
 238:	8e e0                	mov    %ax,%fs
 23a:	8e e8                	mov    %ax,%gs
 23c:	fa                   	cli    
 23d:	ea                   	(bad)  
 23e:	00 00                	add    %al,(%rax)
 240:	80 08 be             	orb    $0xbe,(%rax)
 243:	00 00                	add    %al,(%rax)
 245:	e8 f3 fd             	call   3b <BIOSprint>
 248:	eb fe                	jmp    248 <secondStage_start+0x48>

000000000000024a <findLinux>:
 24a:	90                   	nop

000000000000024b <readLinux>:
 24b:	c7 06 00 00          	movw   $0x0,(%rsi)
 24f:	02 00                	add    (%rax),%al
 251:	c7 06 00 00          	movw   $0x0,(%rsi)
 255:	00 00                	add    %al,(%rax)
 257:	66 a1 00 00 66 a3 00 	movabs 0x84e80000a3660000,%eax
 25e:	00 e8 84 
 261:	fe                   	(bad)  
 262:	66 a1 00 00 66 3d 48 	movabs 0x537264483d660000,%eax
 269:	64 72 53 
 26c:	74 07                	je     275 <readLinux+0x2a>
 26e:	be 00 00             	mov    $0x0,%si
 271:	e8 ad fd             	call   21 <errmsg>
 274:	c3                   	ret    
 275:	a1 00 00 3d 04 02 73 	movabs 0xa30c7302043d0000,%ax
 27c:	0c a3 
 27e:	00 00                	add    %al,(%rax)
 280:	e8 cc fd             	call   4f <printReg>
 283:	be 00 00             	mov    $0x0,%si
 286:	e8 98 fd             	call   21 <errmsg>
 289:	66 31 c0             	xor    %eax,%eax
 28c:	a0 00 00 3c 00 75 02 	movabs 0x4b00275003c0000,%al
 293:	b0 04 
 295:	fe c0                	inc    %al
 297:	a2 00 00 83 c0 41 3b 	movabs %al,0x63b41c0830000
 29e:	06 00 
 2a0:	00 72 0c             	add    %dh,0xc(%rdx)
 2a3:	a3 00 00 e8 a6 fd be 	movabs %ax,0xbefda6e80000
 2aa:	00 00 
 2ac:	e8 72 fd             	call   21 <errmsg>
 2af:	31 c0                	xor    %ax,%ax
 2b1:	a0 00 00 a3 00 00 e8 	movabs 0xfe2ce80000a30000,%al
 2b8:	2c fe 
 2ba:	c6 06 00             	movb   $0x0,(%rsi)
 2bd:	00 ff                	add    %bh,%bh
 2bf:	a0 00 00 24 df 24 bf 	movabs 0x800cbf24df240000,%al
 2c6:	0c 80 
 2c8:	a2 00 00 a8 01 66 b8 	movabs %al,0xb86601a80000
 2cf:	00 00 
 2d1:	01 00                	add    %ax,(%rax)
 2d3:	74 04                	je     2d9 <readLinux+0x8e>
 2d5:	66 6b c0 10          	imul   $0x10,%eax,%eax
 2d9:	66 a3 00 00 66 a1 00 	movabs %eax,0x3d660000a1660000
 2e0:	00 66 3d 
 2e3:	0b 00                	or     (%rax),%ax
 2e5:	00 00                	add    %al,(%rax)
 2e7:	73 0c                	jae    2f5 <readLinux+0xaa>
 2e9:	a3 00 00 e8 60 fd be 	movabs %ax,0xbefd60e80000
 2f0:	00 00 
 2f2:	e8 2c fd             	call   21 <errmsg>
 2f5:	31 c0                	xor    %ax,%ax
 2f7:	a0 00 00 83 c0 3f 69 	movabs 0xc0693fc0830000,%al
 2fe:	c0 00 
 300:	02 a3 00 00 31 c0    	add    -0x3fcf0000(%rbx),%ah
 306:	a0 00 00 8b 1e 00 00 	movabs 0xc32900001e8b0000,%al
 30d:	29 c3 
 30f:	83 fb 7f             	cmp    $0x7f,%bx
 312:	73 0e                	jae    322 <readLinux+0xd7>
 314:	a3 00 00 e8 35 fd be 	movabs %ax,0xbefd35e80000
 31b:	00 00 
 31d:	e8 01 fd             	call   21 <errmsg>
 320:	eb fe                	jmp    320 <readLinux+0xd5>
 322:	69 c0 00 02          	imul   $0x200,%ax,%ax
 326:	05 00 00             	add    $0x0,%ax
 329:	a3 00 00 e8 2c 00 e8 	movabs %ax,0xc5e8002ce80000
 330:	c5 00 
 332:	66 31 c0             	xor    %eax,%eax
 335:	a0 00 00 83 c0 40 05 	movabs 0x430540c0830000,%al
 33c:	43 00 
 33e:	6b c0 20             	imul   $0x20,%ax,%ax
 341:	8e c0                	mov    %ax,%es
 343:	66 6b c0 10          	imul   $0x10,%eax,%eax
 347:	66 a3 00 00 bf 00 00 	movabs %eax,0xbe0000bf0000
 34e:	be 00 00 
 351:	b9 0b 00             	mov    $0xb,%cx
 354:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
 356:	31 c0                	xor    %ax,%ax
 358:	8e c0                	mov    %ax,%es
 35a:	c3                   	ret    

000000000000035b <read32bitLinux>:
 35b:	66 a1 00 00 66 ba 00 	movabs 0xba660000,%eax
 362:	00 00 00 
 365:	66 bb 20 00 00 00    	mov    $0x20,%ebx
 36b:	66 f7 f3             	div    %ebx
 36e:	66 83 fa 00          	cmp    $0x0,%edx
 372:	74 02                	je     376 <read32bitLinux+0x1b>
 374:	66 40                	data32 rex
 376:	66 3d ff ff 00 00    	cmp    $0xffff,%eax
 37c:	72 08                	jb     386 <read32bitLinux+0x2b>
 37e:	be 00 00             	mov    $0x0,%si
 381:	e8 9d fc             	call   21 <errmsg>
 384:	eb fe                	jmp    384 <read32bitLinux+0x29>
 386:	a3 00 00 66 31 c0 a0 	movabs %ax,0xa0c031660000
 38d:	00 00 
 38f:	66 03 06             	add    (%rsi),%eax
 392:	00 00                	add    %al,(%rax)
 394:	66                   	data32
 395:	a3                   	.byte 0xa3
 396:	00 00                	add    %al,(%rax)
 398:	e8 93 00             	call   42e <readAndMove>
 39b:	c3                   	ret    

000000000000039c <setInitRdFlags>:
 39c:	66 a1 00 00 66 8b 1e 	movabs 0x6600001e8b660000,%eax
 3a3:	00 00 66 
 3a6:	03 1e                	add    (%rsi),%bx
 3a8:	00 00                	add    %al,(%rax)
 3aa:	66 69 db 00 02 00 00 	imul   $0x200,%ebx,%ebx
 3b1:	71 08                	jno    3bb <setInitRdFlags+0x1f>
 3b3:	be 00 00             	mov    $0x0,%si
 3b6:	e8 68 fc             	call   21 <errmsg>
 3b9:	eb fe                	jmp    3b9 <setInitRdFlags+0x1d>
 3bb:	66 03 1e             	add    (%rsi),%ebx
 3be:	00 00                	add    %al,(%rax)
 3c0:	66 39 d8             	cmp    %ebx,%eax
 3c3:	77 08                	ja     3cd <setInitRdFlags+0x31>
 3c5:	be 00 00             	mov    $0x0,%si
 3c8:	e8 56 fc             	call   21 <errmsg>
 3cb:	eb fe                	jmp    3cb <setInitRdFlags+0x2f>
 3cd:	66 31 d2             	xor    %edx,%edx
 3d0:	66 a1 00 00 66 03 06 	movabs 0x6600000603660000,%eax
 3d7:	00 00 66 
 3da:	69 c0 00 02          	imul   $0x200,%ax,%ax
 3de:	00 00                	add    %al,(%rax)
 3e0:	71 06                	jno    3e8 <setInitRdFlags+0x4c>
 3e2:	be 00 00             	mov    $0x0,%si
 3e5:	e8 39 fc             	call   21 <errmsg>
 3e8:	66 a3 00 00 66 b8 00 	movabs %eax,0xb8660000
 3ef:	00 00 00 
 3f2:	66                   	data32
 3f3:	a3                   	.byte 0xa3
 3f4:	00 00                	add    %al,(%rax)
 3f6:	c3                   	ret    

00000000000003f7 <readInitrd>:
 3f7:	31 c0                	xor    %ax,%ax
 3f9:	a0 00 00 66 c1 e0 10 	movabs 0xa110e0c1660000,%al
 400:	a1 00 
 402:	00 66 a3             	add    %ah,-0x5d(%rsi)
 405:	00 00                	add    %al,(%rax)
 407:	66 a1 00 00 66 a3 00 	movabs 0xa1660000a3660000,%eax
 40e:	00 66 a1 
 411:	00 00                	add    %al,(%rax)
 413:	66 a3 00 00 e8 14 00 	movabs %eax,0xa1660014e80000
 41a:	66 a1 00 
 41d:	00 66 a3             	add    %ah,-0x5d(%rsi)
 420:	00 00                	add    %al,(%rax)
 422:	66 a1 00 00 66 a3 00 	movabs 0x1e80000a3660000,%eax
 429:	00 e8 01 
 42c:	00 c3                	add    %al,%bl

000000000000042e <readAndMove>:
 42e:	a1 00 00 a3 00 00 b8 	movabs 0xb80000a30000,%ax
 435:	00 00 
 437:	8e c0                	mov    %ax,%es

0000000000000439 <readandMoveLoop>:
 439:	c7 06 00 00          	movw   $0x0,(%rsi)
 43d:	7f 00                	jg     43f <readandMoveLoop+0x6>
 43f:	e8 a4 fc             	call   e6 <readFromHardDrive>
 442:	b9 00 7f             	mov    $0x7f00,%cx
 445:	be 00 00             	mov    $0x0,%si
 448:	b4 87                	mov    $0x87,%ah
 44a:	cd 15                	int    $0x15
 44c:	73 0e                	jae    45c <readandMoveLoop+0x23>
 44e:	a3 00 00 e8 fb fb be 	movabs %ax,0xbefbfbe80000
 455:	00 00 
 457:	e8 c7 fb             	call   21 <errmsg>
 45a:	eb fe                	jmp    45a <readandMoveLoop+0x21>
 45c:	81 06 00 00          	addw   $0x0,(%rsi)
 460:	00 fe                	add    %bh,%dh
 462:	80 16 00             	adcb   $0x0,(%rsi)
 465:	00 00                	add    %al,(%rax)
 467:	73 08                	jae    471 <readandMoveLoop+0x38>
 469:	be 00 00             	mov    $0x0,%si
 46c:	e8 b2 fb             	call   21 <errmsg>
 46f:	eb fe                	jmp    46f <readandMoveLoop+0x36>
 471:	66 83 06 00          	addl   $0x0,(%rsi)
 475:	00 7f 83             	add    %bh,-0x7d(%rdi)
 478:	2e 00 00             	add    %al,%cs:(%rax)
 47b:	7f 77                	jg     4f4 <check_a20+0x2c>
 47d:	bb                   	.byte 0xbb
 47e:	c3                   	ret    

000000000000047f <enablea20>:
 47f:	e8 46 00             	call   4c8 <check_a20>
 482:	83 f8 01             	cmp    $0x1,%ax
 485:	75 07                	jne    48e <enablea20+0xf>
 487:	be 00 00             	mov    $0x0,%si
 48a:	e8 ae fb             	call   3b <BIOSprint>
 48d:	c3                   	ret    
 48e:	b9 00 00             	mov    $0x0,%cx

0000000000000491 <activatea20Loop>:
 491:	89 ce                	mov    %cx,%si
 493:	8b 34 e8             	mov    (%rax,%rbp,8),%si
 496:	a3 fb 83 c1 02 89 ce 	movabs %ax,0x48bce8902c183fb
 49d:	8b 04 
 49f:	ff d0                	call   *%ax
 4a1:	83 c1 02             	add    $0x2,%cx
 4a4:	e8 21 00             	call   4c8 <check_a20>
 4a7:	83 f8 01             	cmp    $0x1,%ax
 4aa:	74 0e                	je     4ba <a20done>
 4ac:	be 00 00             	mov    $0x0,%si
 4af:	e8 89 fb             	call   3b <BIOSprint>
 4b2:	81 f9 00 00          	cmp    $0x0,%cx
 4b6:	77 09                	ja     4c1 <activatea20failed>
 4b8:	eb d7                	jmp    491 <activatea20Loop>

00000000000004ba <a20done>:
 4ba:	be 00 00             	mov    $0x0,%si
 4bd:	e8 7b fb             	call   3b <BIOSprint>
 4c0:	c3                   	ret    

00000000000004c1 <activatea20failed>:
 4c1:	be 00 00             	mov    $0x0,%si
 4c4:	e8 74 fb             	call   3b <BIOSprint>
 4c7:	c3                   	ret    

00000000000004c8 <check_a20>:
 4c8:	9c                   	pushf  
 4c9:	1e                   	(bad)  
 4ca:	06                   	(bad)  
 4cb:	57                   	push   %di
 4cc:	56                   	push   %si
 4cd:	fa                   	cli    
 4ce:	31 c0                	xor    %ax,%ax
 4d0:	8e c0                	mov    %ax,%es
 4d2:	f7 d0                	not    %ax
 4d4:	8e d8                	mov    %ax,%ds
 4d6:	bf 00 05             	mov    $0x500,%di
 4d9:	be 10 05             	mov    $0x510,%si
 4dc:	26 8a 05 50 8a 04 50 	mov    %es:0x50048a50(%rip),%al        # 50048f33 <secondStage_end_addr+0x50040933>
 4e3:	26 c6 05 00 c6 04 ff 	movb   $0x26,%es:-0xfb3a00(%rip)        # ffffffffff04caeb <secondStage_end_addr+0xffffffffff0444eb>
 4ea:	26 
 4eb:	80 3d ff 58 88 04 58 	cmpb   $0x58,0x48858ff(%rip)        # 4885df1 <secondStage_end_addr+0x487d7f1>
 4f2:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8(%rip)        # 740005b1 <secondStage_end_addr+0x73ff7fb1>
 4f9:	03                   	.byte 0x3
 4fa:	b8 01 00             	mov    $0x1,%ax

00000000000004fd <check_a20_exit>:
 4fd:	5e                   	pop    %si
 4fe:	5f                   	pop    %di
 4ff:	07                   	(bad)  
 500:	1f                   	(bad)  
 501:	9d                   	popf   
 502:	c3                   	ret    

0000000000000503 <fasta20enable>:
 503:	e4 92                	in     $0x92,%al
 505:	a8 02                	test   $0x2,%al
 507:	75 06                	jne    50f <fasta20enable+0xc>
 509:	0c 02                	or     $0x2,%al
 50b:	24 fe                	and    $0xfe,%al
 50d:	e6 92                	out    %al,$0x92
 50f:	c3                   	ret    

0000000000000510 <keyboarda20enable>:
 510:	fa                   	cli    
 511:	e8 2e 00             	call   542 <a20wait>
 514:	b0 ad                	mov    $0xad,%al
 516:	e6 64                	out    %al,$0x64
 518:	e8 27 00             	call   542 <a20wait>
 51b:	b0 d0                	mov    $0xd0,%al
 51d:	e6 64                	out    %al,$0x64
 51f:	e8 27 00             	call   549 <a20wait2>
 522:	e4 60                	in     $0x60,%al
 524:	66 50                	data32 push %rax
 526:	e8 19 00             	call   542 <a20wait>
 529:	b0 d1                	mov    $0xd1,%al
 52b:	e6 64                	out    %al,$0x64
 52d:	e8 12 00             	call   542 <a20wait>
 530:	66 58                	data32 pop %rax
 532:	0c 02                	or     $0x2,%al
 534:	e6 60                	out    %al,$0x60
 536:	e8 09 00             	call   542 <a20wait>
 539:	b0 ae                	mov    $0xae,%al
 53b:	e6 64                	out    %al,$0x64
 53d:	e8 02 00             	call   542 <a20wait>
 540:	fb                   	sti    
 541:	c3                   	ret    

0000000000000542 <a20wait>:
 542:	e4 64                	in     $0x64,%al
 544:	a8 02                	test   $0x2,%al
 546:	75 fa                	jne    542 <a20wait>
 548:	c3                   	ret    

0000000000000549 <a20wait2>:
 549:	e4 64                	in     $0x64,%al
 54b:	a8 01                	test   $0x1,%al
 54d:	74 fa                	je     549 <a20wait2>
 54f:	c3                   	ret    

0000000000000550 <biosa20enable>:
 550:	51                   	push   %cx
 551:	b8 03 24             	mov    $0x2403,%ax
 554:	cd 15                	int    $0x15
 556:	72 2e                	jb     586 <biosa20enable+0x36>
 558:	80 fc 00             	cmp    $0x0,%ah
 55b:	75 29                	jne    586 <biosa20enable+0x36>
 55d:	b8 02 24             	mov    $0x2402,%ax
 560:	cd 15                	int    $0x15
 562:	72 1c                	jb     580 <biosa20enable+0x30>
 564:	80 fc 00             	cmp    $0x0,%ah
 567:	75 17                	jne    580 <biosa20enable+0x30>
 569:	3a 06                	cmp    (%rsi),%al
 56b:	01 00                	add    %ax,(%rax)
 56d:	74 0c                	je     57b <biosa20enable+0x2b>
 56f:	b8 01 24             	mov    $0x2401,%ax
 572:	cd 15                	int    $0x15
 574:	72 0a                	jb     580 <biosa20enable+0x30>
 576:	80 fc 00             	cmp    $0x0,%ah
 579:	75 05                	jne    580 <biosa20enable+0x30>
 57b:	b8 01 00             	mov    $0x1,%ax
 57e:	eb 09                	jmp    589 <biosa20enableret>
 580:	be 00 00             	mov    $0x0,%si
 583:	e8 b5 fa             	call   3b <BIOSprint>
 586:	b8 00 00             	mov    $0x0,%ax

0000000000000589 <biosa20enableret>:
 589:	59                   	pop    %cx
 58a:	c3                   	ret    

000000000000058b <readMemorySize>:
 58b:	66 ba 50 41 4d 53    	mov    $0x534d4150,%edx
 591:	66 bb 00 00 00 00    	mov    $0x0,%ebx

0000000000000597 <loop_again>:
 597:	66 b8 20 e8 00 00    	mov    $0xe820,%eax
 59d:	66 b9 14 00 00 00    	mov    $0x14,%ecx
 5a3:	bf 00 00             	mov    $0x0,%di
 5a6:	cd 15                	int    $0x15
 5a8:	73 08                	jae    5b2 <loop_again+0x1b>
 5aa:	be 00 00             	mov    $0x0,%si
 5ad:	e8 71 fa             	call   21 <errmsg>
 5b0:	eb fe                	jmp    5b0 <loop_again+0x19>
 5b2:	66 3d 50 41 4d 53    	cmp    $0x534d4150,%eax
 5b8:	74 08                	je     5c2 <loop_again+0x2b>
 5ba:	be 00 00             	mov    $0x0,%si
 5bd:	e8 61 fa             	call   21 <errmsg>
 5c0:	eb fe                	jmp    5c0 <loop_again+0x29>
 5c2:	66 83 f9 14          	cmp    $0x14,%ecx
 5c6:	74 08                	je     5d0 <loop_again+0x39>
 5c8:	be 00 00             	mov    $0x0,%si
 5cb:	e8 53 fa             	call   21 <errmsg>
 5ce:	eb fe                	jmp    5ce <loop_again+0x37>
 5d0:	66 53                	data32 push %rbx
 5d2:	b8 00 00             	mov    $0x0,%ax
 5d5:	e8 aa fa             	call   82 <printQWORD>
 5d8:	b8 00 00             	mov    $0x0,%ax
 5db:	e8 a4 fa             	call   82 <printQWORD>
 5de:	b8 00 00             	mov    $0x0,%ax
 5e1:	e8 96 fa             	call   7a <printDWORD>
 5e4:	e8 5a fa             	call   41 <newline>
 5e7:	66 5b                	data32 pop %rbx
 5e9:	66 83 fb 00          	cmp    $0x0,%ebx
 5ed:	74 02                	je     5f1 <memmapexit>
 5ef:	eb a6                	jmp    597 <loop_again>

00000000000005f1 <memmapexit>:
 5f1:	c3                   	ret    

00000000000005f2 <faileda20>:
 5f2:	2e 2e 2e 20 73 6f    	cs cs and %dh,%cs:0x6f(%rbx)
 5f8:	6d                   	insw   (%dx),%es:(%rdi)
 5f9:	65 74 68             	gs je  664 <keyboarda20+0x15>
 5fc:	69 6e 67 20 77       	imul   $0x7720,0x67(%rsi),%bp
 601:	65 6e                	outsb  %gs:(%rsi),(%dx)
 603:	74 20                	je     625 <a20attemptsend+0xd>
 605:	77 72                	ja     679 <fasta20+0x3>
 607:	6f                   	outsw  %ds:(%rsi),(%dx)
 608:	6e                   	outsb  %ds:(%rsi),(%dx)
 609:	67 20 00             	and    %al,(%eax)

000000000000060c <a20attempts>:
	...

0000000000000618 <a20attemptsend>:
 618:	41 32 30             	xor    (%r8),%sil
 61b:	20 65 6e             	and    %ah,0x6e(%rbp)
 61e:	61                   	(bad)  
 61f:	62                   	(bad)  
 620:	6c                   	insb   (%dx),%es:(%rdi)
 621:	65 64 20 6f 6e       	gs and %ch,%fs:0x6e(%rdi)
 626:	20 62 6f             	and    %ah,0x6f(%rdx)
 629:	6f                   	outsw  %ds:(%rsi),(%dx)
 62a:	74 00                	je     62c <biosa20>

000000000000062c <biosa20>:
 62c:	41 74 74             	rex.B je 6a3 <enabledmsg+0x3>
 62f:	65 6d                	gs insw (%dx),%es:(%rdi)
 631:	70 74                	jo     6a7 <enabledmsg+0x7>
 633:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 638:	6f                   	outsw  %ds:(%rsi),(%dx)
 639:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 63d:	6e                   	outsb  %ds:(%rsi),(%dx)
 63e:	20 6f 6e             	and    %ch,0x6e(%rdi)
 641:	20 61 32             	and    %ah,0x32(%rcx)
 644:	30 20                	xor    %ah,(%rax)
 646:	76 69                	jbe    6b1 <enabledmsg+0x11>
 648:	61                   	(bad)  
 649:	20 42 49             	and    %al,0x49(%rdx)
 64c:	4f 53                	rex.WRXB push %r11
	...

000000000000064f <keyboarda20>:
 64f:	41 74 74             	rex.B je 6c6 <notenabledmsg+0x8>
 652:	65 6d                	gs insw (%dx),%es:(%rdi)
 654:	70 74                	jo     6ca <notenabledmsg+0xc>
 656:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 65b:	6f                   	outsw  %ds:(%rsi),(%dx)
 65c:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 660:	6e                   	outsb  %ds:(%rsi),(%dx)
 661:	20 6f 6e             	and    %ch,0x6e(%rdi)
 664:	20 61 32             	and    %ah,0x32(%rcx)
 667:	30 20                	xor    %ah,(%rax)
 669:	76 69                	jbe    6d4 <a20disabled>
 66b:	61                   	(bad)  
 66c:	20 6b 65             	and    %ch,0x65(%rbx)
 66f:	79 62                	jns    6d3 <notenabledmsg+0x15>
 671:	6f                   	outsw  %ds:(%rsi),(%dx)
 672:	61                   	(bad)  
 673:	72 64                	jb     6d9 <a20disabled+0x5>
	...

0000000000000676 <fasta20>:
 676:	41 74 74             	rex.B je 6ed <msgMemSizeFailed+0x7>
 679:	65 6d                	gs insw (%dx),%es:(%rdi)
 67b:	70 74                	jo     6f1 <msgMemSizeFailed+0xb>
 67d:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 682:	6f                   	outsw  %ds:(%rsi),(%dx)
 683:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 687:	6e                   	outsb  %ds:(%rsi),(%dx)
 688:	20 6f 6e             	and    %ch,0x6e(%rdi)
 68b:	20 61 32             	and    %ah,0x32(%rcx)
 68e:	30 20                	xor    %ah,(%rax)
 690:	76 69                	jbe    6fb <msgMemSizeFailed+0x15>
 692:	61                   	(bad)  
 693:	20 66 61             	and    %ah,0x61(%rsi)
 696:	73 74                	jae    70c <memmap_start+0xb>
 698:	20 6d 65             	and    %ch,0x65(%rbp)
 69b:	74 68                	je     705 <memmap_start+0x4>
 69d:	6f                   	outsw  %ds:(%rsi),(%dx)
 69e:	64                   	fs
	...

00000000000006a0 <enabledmsg>:
 6a0:	2e 2e 2e 20 20       	cs cs and %ah,%cs:(%rax)
 6a5:	77 6f                	ja     716 <availSpace+0x1>
 6a7:	72 6b                	jb     714 <memmap_start+0x13>
 6a9:	65 64 21 0d 0a 41 32 	gs and %cx,%fs:0x3032410a(%rip)        # 303247bb <secondStage_end_addr+0x3031c1bb>
 6b0:	30 
 6b1:	20 69 73             	and    %ch,0x73(%rcx)
 6b4:	20 65 6e             	and    %ah,0x6e(%rbp)
 6b7:	61                   	(bad)  
 6b8:	62                   	(bad)  
 6b9:	6c                   	insb   (%dx),%es:(%rdi)
 6ba:	65 64 21 00          	gs and %ax,%fs:(%rax)

00000000000006be <notenabledmsg>:
 6be:	2e 2e 2e 20 20       	cs cs and %ah,%cs:(%rax)
 6c3:	64 69 64 6e 27 74 20 	imul   $0x2074,%fs:0x27(%rsi,%rbp,2),%sp
 6ca:	77 6f                	ja     73b <msgTooMuchSpace+0x17>
 6cc:	72 6b                	jb     739 <msgTooMuchSpace+0x15>
 6ce:	20 2e                	and    %ch,(%rsi)
 6d0:	2e 0d 0a 00          	cs or  $0xa,%ax

00000000000006d4 <a20disabled>:
 6d4:	41 32 30             	xor    (%r8),%sil
 6d7:	20 69 73             	and    %ch,0x73(%rcx)
 6da:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
 6de:	61                   	(bad)  
 6df:	62                   	(bad)  
 6e0:	6c                   	insb   (%dx),%es:(%rdi)
 6e1:	65 64 21 21          	gs and %sp,%fs:(%rcx)
	...

00000000000006e6 <msgMemSizeFailed>:
 6e6:	67 65 74 74          	addr32 gs je 75e <msgRamdiskNotZero+0x1f>
 6ea:	69 6e 67 20 6d       	imul   $0x6d20,0x67(%rsi),%bp
 6ef:	65 6d                	gs insw (%dx),%es:(%rdi)
 6f1:	6f                   	outsw  %ds:(%rsi),(%dx)
 6f2:	72 79                	jb     76d <msgRamdiskSizeNotZero+0xd>
 6f4:	20 73 69             	and    %dh,0x69(%rbx)
 6f7:	7a 65                	jp     75e <msgRamdiskNotZero+0x1f>
 6f9:	20 66 61             	and    %ah,0x61(%rsi)
 6fc:	69                   	.byte 0x69
 6fd:	6c                   	insb   (%dx),%es:(%rdi)
 6fe:	65                   	gs
 6ff:	64                   	fs
	...

0000000000000701 <memmap_start>:
	...

0000000000000715 <availSpace>:
	...

0000000000000717 <linuxSetupSectors>:
	...

0000000000000718 <linuxProtectedSize>:
 718:	00 00                	add    %al,(%rax)
	...

000000000000071c <protectedLoadAddr>:
 71c:	00 00                	add    %al,(%rax)
 71e:	10 00                	adc    %al,(%rax)

0000000000000720 <vmlinuz_block>:
 720:	48 19 18             	sbb    %rbx,(%rax)
	...

0000000000000724 <msgTooMuchSpace>:
 724:	4f 76 65             	rex.WRXB jbe 78c <msgNoMagic+0xe>
 727:	72 66                	jb     78f <msgBadVersion+0x2>
 729:	6c                   	insb   (%dx),%es:(%rdi)
 72a:	6f                   	outsw  %ds:(%rsi),(%dx)
 72b:	77 20                	ja     74d <msgRamdiskNotZero+0xe>
 72d:	63 61 6c             	movslq 0x6c(%rcx),%sp
 730:	63 75 6c             	movslq 0x6c(%rbp),%si
 733:	61                   	(bad)  
 734:	74 69                	je     79f <msgBadVersion+0x12>
 736:	6e                   	outsb  %ds:(%rsi),(%dx)
 737:	67 20 73 70          	and    %dh,0x70(%ebx)
 73b:	61                   	(bad)  
 73c:	63 65 00             	movslq 0x0(%rbp),%sp

000000000000073f <msgRamdiskNotZero>:
 73f:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
 741:	69 74 69 61 6c 20    	imul   $0x206c,0x61(%rcx,%rbp,2),%si
 747:	72 61                	jb     7aa <msgNoSpace+0x6>
 749:	6d                   	insw   (%dx),%es:(%rdi)
 74a:	64 69 73 6b 20 70    	imul   $0x7020,%fs:0x6b(%rbx),%si
 750:	6f                   	outsw  %ds:(%rsi),(%dx)
 751:	69 6e 74 65 72       	imul   $0x7265,0x74(%rsi),%bp
 756:	20 69 73             	and    %ch,0x73(%rcx)
 759:	20 6e 6f             	and    %ch,0x6f(%rsi)
 75c:	74 20                	je     77e <msgNoMagic>
 75e:	30 00                	xor    %al,(%rax)

0000000000000760 <msgRamdiskSizeNotZero>:
 760:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
 762:	69 74 69 61 6c 20    	imul   $0x206c,0x61(%rcx,%rbp,2),%si
 768:	72 61                	jb     7cb <msgCMDtooLong+0x16>
 76a:	6d                   	insw   (%dx),%es:(%rdi)
 76b:	64 69 73 6b 20 73    	imul   $0x7320,%fs:0x6b(%rbx),%si
 771:	69 7a 65 20 69       	imul   $0x6920,0x65(%rdx),%di
 776:	73 20                	jae    798 <msgBadVersion+0xb>
 778:	6e                   	outsb  %ds:(%rsi),(%dx)
 779:	6f                   	outsw  %ds:(%rsi),(%dx)
 77a:	74 20                	je     79c <msgBadVersion+0xf>
 77c:	30 00                	xor    %al,(%rax)

000000000000077e <msgNoMagic>:
 77e:	6e                   	outsb  %ds:(%rsi),(%dx)
 77f:	6f                   	outsw  %ds:(%rsi),(%dx)
 780:	20 6d 61             	and    %ch,0x61(%rbp)
 783:	67 69 63 20 6c 69    	imul   $0x696c,0x20(%ebx),%sp
 789:	6e                   	outsb  %ds:(%rsi),(%dx)
 78a:	75 78                	jne    804 <msgCopyError+0x10>
	...

000000000000078d <msgBadVersion>:
 78d:	6f                   	outsw  %ds:(%rsi),(%dx)
 78e:	6c                   	insb   (%dx),%es:(%rdi)
 78f:	64 20 4c 69 6e       	and    %cl,%fs:0x6e(%rcx,%rbp,2)
 794:	75 78                	jne    80e <msgCopyError+0x1a>
 796:	20 62 6f             	and    %ah,0x6f(%rdx)
 799:	6f                   	outsw  %ds:(%rsi),(%dx)
 79a:	74 20                	je     7bc <msgCMDtooLong+0x7>
 79c:	76 65                	jbe    803 <msgCopyError+0xf>
 79e:	72 73                	jb     813 <msgCopyError+0x1f>
 7a0:	69                   	.byte 0x69
 7a1:	6f                   	outsw  %ds:(%rsi),(%dx)
 7a2:	6e                   	outsb  %ds:(%rsi),(%dx)
	...

00000000000007a4 <msgNoSpace>:
 7a4:	6e                   	outsb  %ds:(%rsi),(%dx)
 7a5:	6f                   	outsw  %ds:(%rsi),(%dx)
 7a6:	74 20                	je     7c8 <msgCMDtooLong+0x13>
 7a8:	65 6e                	outsb  %gs:(%rsi),(%dx)
 7aa:	6f                   	outsw  %ds:(%rsi),(%dx)
 7ab:	75 67                	jne    814 <msgCopyError+0x20>
 7ad:	68 20 73             	push   $0x7320
 7b0:	70 61                	jo     813 <msgCopyError+0x1f>
 7b2:	63 65 00             	movslq 0x0(%rbp),%sp

00000000000007b5 <msgCMDtooLong>:
 7b5:	6c                   	insb   (%dx),%es:(%rdi)
 7b6:	69 6e 75 78 20       	imul   $0x2078,0x75(%rsi),%bp
 7bb:	63 6f 6d             	movslq 0x6d(%rdi),%bp
 7be:	6d                   	insw   (%dx),%es:(%rdi)
 7bf:	61                   	(bad)  
 7c0:	6e                   	outsb  %ds:(%rsi),(%dx)
 7c1:	64 20 6c 69 6e       	and    %ch,%fs:0x6e(%rcx,%rbp,2)
 7c6:	65 20 74 6f 6f       	and    %dh,%gs:0x6f(%rdi,%rbp,2)
 7cb:	20 6c 61 72          	and    %ch,0x72(%rcx,%riz,2)
 7cf:	67                   	addr32
 7d0:	65                   	gs
	...

00000000000007d2 <msgTooMuchProtected>:
 7d2:	74 6f                	je     843 <msgHandleLargerAddresses+0x21>
 7d4:	6f                   	outsw  %ds:(%rsi),(%dx)
 7d5:	20 6d 75             	and    %ch,0x75(%rbp)
 7d8:	63 68 20             	movslq 0x20(%rax),%bp
 7db:	70 72                	jo     84f <msgNeedReadPartial+0x6>
 7dd:	6f                   	outsw  %ds:(%rsi),(%dx)
 7de:	74 65                	je     845 <msgHandleLargerAddresses+0x23>
 7e0:	63 74 65 64          	movslq 0x64(%rbp,%riz,2),%si
 7e4:	20 6b 65             	and    %ch,0x65(%rbx)
 7e7:	72 6e                	jb     857 <msgNeedReadPartial+0xe>
 7e9:	65 6c                	gs insb (%dx),%es:(%rdi)
 7eb:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
 7ef:	72 65                	jb     856 <msgNeedReadPartial+0xd>
 7f1:	61                   	(bad)  
 7f2:	64                   	fs
	...

00000000000007f4 <msgCopyError>:
 7f4:	69 6e 74 65 72       	imul   $0x7265,0x74(%rsi),%bp
 7f9:	72 75                	jb     870 <msgShouldNotReach+0x7>
 7fb:	70 74                	jo     871 <msgShouldNotReach+0x8>
 7fd:	20 66 61             	and    %ah,0x61(%rsi)
 800:	69 6c 75 72 65 20    	imul   $0x2065,0x72(%rbp,%rsi,2),%bp
 806:	6d                   	insw   (%dx),%es:(%rdi)
 807:	6f                   	outsw  %ds:(%rsi),(%dx)
 808:	76 69                	jbe    873 <msgShouldNotReach+0xa>
 80a:	6e                   	outsb  %ds:(%rsi),(%dx)
 80b:	67 20 70 72          	and    %dh,0x72(%eax)
 80f:	6f                   	outsw  %ds:(%rsi),(%dx)
 810:	74 65                	je     877 <msgShouldNotReach+0xe>
 812:	63 74 65 64          	movslq 0x64(%rbp,%riz,2),%si
 816:	20 6d 6f             	and    %ch,0x6f(%rbp)
 819:	64 65 20 62 79       	fs and %ah,%gs:0x79(%rdx)
 81e:	74 65                	je     885 <msgShouldNotReach+0x1c>
 820:	73 00                	jae    822 <msgHandleLargerAddresses>

0000000000000822 <msgHandleLargerAddresses>:
 822:	4c 6f                	rex.WR outsl %ds:(%rsi),(%dx)
 824:	61                   	(bad)  
 825:	64 20 61 64          	and    %ah,%fs:0x64(%rcx)
 829:	64 72 65             	fs jb  891 <msgGetSet+0x9>
 82c:	73 73                	jae    8a1 <msgGetSet+0x19>
 82e:	20 74 6f 6f          	and    %dh,0x6f(%rdi,%rbp,2)
 832:	20 68 69             	and    %ch,0x69(%rax)
 835:	67 68 20 66          	addr32 push $0x6620
 839:	6f                   	outsw  %ds:(%rsi),(%dx)
 83a:	72 20                	jb     85c <msgNeedReadPartial+0x13>
 83c:	31 36                	xor    %si,(%rsi)
 83e:	20 62 69             	and    %ah,0x69(%rdx)
 841:	74 20                	je     863 <msgNeedReadPartial+0x1a>
 843:	76 61                	jbe    8a6 <msgInitrdOverflowAddr+0x4>
 845:	6c                   	insb   (%dx),%es:(%rdi)
 846:	75 65                	jne    8ad <msgInitrdOverflowAddr+0xb>
	...

0000000000000849 <msgNeedReadPartial>:
 849:	43 61                	rex.XB (bad) 
 84b:	6e                   	outsb  %ds:(%rsi),(%dx)
 84c:	27                   	(bad)  
 84d:	74 20                	je     86f <msgShouldNotReach+0x6>
 84f:	75 73                	jne    8c4 <msgInitrdOverflowAddr+0x22>
 851:	65 20 30             	and    %dh,%gs:(%rax)
 854:	78 37                	js     88d <msgGetSet+0x5>
 856:	66 20 62 6c          	data32 and %ah,0x6c(%rdx)
 85a:	6f                   	outsw  %ds:(%rsi),(%dx)
 85b:	63 6b 20             	movslq 0x20(%rbx),%bp
 85e:	73 69                	jae    8c9 <msgInitrdOverflowAddr+0x27>
 860:	7a 65                	jp     8c7 <msgInitrdOverflowAddr+0x25>
 862:	20 72 65             	and    %dh,0x65(%rdx)
 865:	61                   	(bad)  
 866:	64 73 00             	fs jae 869 <msgShouldNotReach>

0000000000000869 <msgShouldNotReach>:
 869:	53                   	push   %bx
 86a:	68 6f 75             	push   $0x756f
 86d:	6c                   	insb   (%dx),%es:(%rdi)
 86e:	64 20 6e 6f          	and    %ch,%fs:0x6f(%rsi)
 872:	74 20                	je     894 <msgGetSet+0xc>
 874:	72 65                	jb     8db <msgInitrdLowAddr+0x10>
 876:	61                   	(bad)  
 877:	63 68 20             	movslq 0x20(%rax),%bp
 87a:	74 68                	je     8e4 <msgInitrdLowAddr+0x19>
 87c:	69 73 20 70 6f       	imul   $0x6f70,0x20(%rbx),%si
 881:	73 69                	jae    8ec <msgInitrdLowAddr+0x21>
 883:	74 69                	je     8ee <msgInitrdLowAddr+0x23>
 885:	6f                   	outsw  %ds:(%rsi),(%dx)
 886:	6e                   	outsb  %ds:(%rsi),(%dx)
	...

0000000000000888 <msgGetSet>:
 888:	52                   	push   %dx
 889:	65 61                	gs (bad) 
 88b:	64 79 20             	fs jns 8ae <msgInitrdOverflowAddr+0xc>
 88e:	2e 2e 2e 20 53 65    	cs cs and %dl,%cs:0x65(%rbx)
 894:	74 20                	je     8b6 <msgInitrdOverflowAddr+0x14>
 896:	2e 2e 2e 20 47 6f    	cs cs and %al,%cs:0x6f(%rdi)
 89c:	21 21                	and    %sp,(%rcx)
 89e:	21 0a                	and    %cx,(%rdx)
 8a0:	0d                   	.byte 0xd
	...

00000000000008a2 <msgInitrdOverflowAddr>:
 8a2:	47 75 65             	rex.RXB jne 90a <msgInitrdTooLarge+0x14>
 8a5:	73 73                	jae    91a <msgMoveTooMuch+0x3>
 8a7:	65 64 20 6c 6f 61    	gs and %ch,%fs:0x61(%rdi,%rbp,2)
 8ad:	64 20 61 64          	and    %ah,%fs:0x64(%rcx)
 8b1:	64 72 65             	fs jb  919 <msgMoveTooMuch+0x2>
 8b4:	73 73                	jae    929 <msgMoveTooMuch+0x12>
 8b6:	20 6f 66             	and    %ch,0x66(%rdi)
 8b9:	20 69 6e             	and    %ch,0x6e(%rcx)
 8bc:	69 74 72 64 20 6f    	imul   $0x6f20,0x64(%rdx,%rsi,2),%si
 8c2:	76 65                	jbe    929 <msgMoveTooMuch+0x12>
 8c4:	72 66                	jb     92c <msgMoveTooMuch+0x15>
 8c6:	6c                   	insb   (%dx),%es:(%rdi)
 8c7:	6f                   	outsw  %ds:(%rsi),(%dx)
 8c8:	77 73                	ja     93d <numSegments+0x1>
	...

00000000000008cb <msgInitrdLowAddr>:
 8cb:	47 75 65             	rex.RXB jne 933 <msgMoveTooMuch+0x1c>
 8ce:	73 73                	jae    943 <initrdLoadAddr+0x3>
 8d0:	65 64 20 6c 6f 61    	gs and %ch,%fs:0x61(%rdi,%rbp,2)
 8d6:	64 20 61 64          	and    %ah,%fs:0x64(%rcx)
 8da:	64 72 65             	fs jb  942 <initrdLoadAddr+0x2>
 8dd:	73 73                	jae    952 <initrdSecondLength+0x2>
 8df:	20 6f 66             	and    %ch,0x66(%rdi)
 8e2:	20 69 6e             	and    %ch,0x6e(%rcx)
 8e5:	69 74 72 64 20 69    	imul   $0x6920,0x64(%rdx,%rsi,2),%si
 8eb:	73 20                	jae    90d <msgInitrdTooLarge+0x17>
 8ed:	74 6f                	je     95e <gdtForMove+0xa>
 8ef:	6f                   	outsw  %ds:(%rsi),(%dx)
 8f0:	20 68 69             	and    %ch,0x69(%rax)
 8f3:	67                   	addr32
 8f4:	68                   	.byte 0x68
	...

00000000000008f6 <msgInitrdTooLarge>:
 8f6:	4f 76 65             	rex.WRXB jbe 95e <gdtForMove+0xa>
 8f9:	72 66                	jb     961 <gdtForMove+0xd>
 8fb:	6c                   	insb   (%dx),%es:(%rdi)
 8fc:	6f                   	outsw  %ds:(%rsi),(%dx)
 8fd:	77 20                	ja     91f <msgMoveTooMuch+0x8>
 8ff:	63 61 6c             	movslq 0x6c(%rcx),%sp
 902:	63 75 6c             	movslq 0x6c(%rbp),%si
 905:	61                   	(bad)  
 906:	74 69                	je     971 <moveGDTdest+0x3>
 908:	6e                   	outsb  %ds:(%rsi),(%dx)
 909:	67 20 69 6e          	and    %ch,0x6e(%ecx)
 90d:	69 74 72 64 20 73    	imul   $0x7320,0x64(%rdx,%rsi,2),%si
 913:	69                   	.byte 0x69
 914:	7a 65                	jp     97b <moveGDTdest+0xd>
	...

0000000000000917 <msgMoveTooMuch>:
 917:	4f 76 65             	rex.WRXB jbe 97f <moveGDTdest+0x11>
 91a:	72 66                	jb     982 <moveGDTdest+0x14>
 91c:	6c                   	insb   (%dx),%es:(%rdi)
 91d:	6f                   	outsw  %ds:(%rsi),(%dx)
 91e:	77 20                	ja     940 <initrdLoadAddr>
 920:	72 65                	jb     987 <linuxCmdLine+0x3>
 922:	61                   	(bad)  
 923:	64 69 6e 67 20 26    	imul   $0x2620,%fs:0x67(%rsi),%bp
 929:	20 6d 6f             	and    %ch,0x6f(%rbp)
 92c:	76 69                	jbe    997 <linuxCmdLine+0x13>
 92e:	6e                   	outsb  %ds:(%rsi),(%dx)
 92f:	67 20 64 61 74       	and    %ah,0x74(%ecx,%eiz,2)
 934:	61                   	(bad)  
	...

0000000000000936 <readAddr>:
	...

0000000000000938 <moveAddr>:
 938:	00 00                	add    %al,(%rax)
	...

000000000000093c <numSegments>:
	...

000000000000093e <availTempSpace>:
	...

0000000000000940 <initrdLoadAddr>:
 940:	00 00                	add    %al,(%rax)
	...

0000000000000944 <initrdFirstBlock>:
 944:	00 08                	add    %cl,(%rax)
 946:	3d                   	.byte 0x3d
	...

0000000000000948 <initrdFirstLength>:
 948:	00 40 00             	add    %al,0x0(%rax)
	...

000000000000094c <initrdSecondBlock>:
 94c:	00 4e 3d             	add    %cl,0x3d(%rsi)
	...

0000000000000950 <initrdSecondLength>:
 950:	18 2f                	sbb    %ch,(%rdi)
	...

0000000000000954 <gdtForMove>:
	...
 964:	00 fe                	add    %bh,%dh

0000000000000966 <moveGDTsource>:
 966:	00 00                	add    %al,(%rax)
 968:	00 93 00 00 ff ff    	add    %dl,-0x10000(%rbx)

000000000000096e <moveGDTdest>:
 96e:	00 00                	add    %al,(%rax)
 970:	10 93 00 00 00 00    	adc    %dl,0x0(%rbx)
	...

0000000000000984 <linuxCmdLine>:
 984:	61                   	(bad)  
 985:	75 74                	jne    9fb <linuxCmdLine+0x77>
 987:	6f                   	outsw  %ds:(%rsi),(%dx)
 988:	20 64 65 62          	and    %ah,0x62(%rbp,%riz,2)
 98c:	75 67                	jne    9f5 <linuxCmdLine+0x71>
 98e:	00 90 90 90 90 90    	add    %dl,-0x6f6f6f70(%rax)
 994:	90                   	nop
 995:	90                   	nop
 996:	90                   	nop
 997:	90                   	nop
 998:	90                   	nop
 999:	90                   	nop
 99a:	90                   	nop
 99b:	90                   	nop
 99c:	90                   	nop
 99d:	90                   	nop
 99e:	90                   	nop
 99f:	90                   	nop
 9a0:	90                   	nop
 9a1:	90                   	nop
 9a2:	90                   	nop
 9a3:	90                   	nop
 9a4:	90                   	nop
 9a5:	90                   	nop
 9a6:	90                   	nop
 9a7:	90                   	nop
 9a8:	90                   	nop
 9a9:	90                   	nop
 9aa:	90                   	nop
 9ab:	90                   	nop
 9ac:	90                   	nop
 9ad:	90                   	nop
 9ae:	90                   	nop
 9af:	90                   	nop
 9b0:	90                   	nop
 9b1:	90                   	nop
 9b2:	90                   	nop
 9b3:	90                   	nop
 9b4:	90                   	nop
 9b5:	90                   	nop
 9b6:	90                   	nop
 9b7:	90                   	nop
 9b8:	90                   	nop
 9b9:	90                   	nop
 9ba:	90                   	nop
 9bb:	90                   	nop
 9bc:	90                   	nop
 9bd:	90                   	nop
 9be:	90                   	nop
 9bf:	90                   	nop
 9c0:	90                   	nop
 9c1:	90                   	nop
 9c2:	90                   	nop
 9c3:	90                   	nop
 9c4:	90                   	nop
 9c5:	90                   	nop
 9c6:	90                   	nop
 9c7:	90                   	nop
 9c8:	90                   	nop
 9c9:	90                   	nop
 9ca:	90                   	nop
 9cb:	90                   	nop
 9cc:	90                   	nop
 9cd:	90                   	nop
 9ce:	90                   	nop
 9cf:	90                   	nop
 9d0:	90                   	nop
 9d1:	90                   	nop
 9d2:	90                   	nop
 9d3:	90                   	nop
 9d4:	90                   	nop
 9d5:	90                   	nop
 9d6:	90                   	nop
 9d7:	90                   	nop
 9d8:	90                   	nop
 9d9:	90                   	nop
 9da:	90                   	nop
 9db:	90                   	nop
 9dc:	90                   	nop
 9dd:	90                   	nop
 9de:	90                   	nop
 9df:	90                   	nop
 9e0:	90                   	nop
 9e1:	90                   	nop
 9e2:	90                   	nop
 9e3:	90                   	nop
 9e4:	90                   	nop
 9e5:	90                   	nop
 9e6:	90                   	nop
 9e7:	90                   	nop
 9e8:	90                   	nop
 9e9:	90                   	nop
 9ea:	90                   	nop
 9eb:	90                   	nop
 9ec:	90                   	nop
 9ed:	90                   	nop
 9ee:	90                   	nop
 9ef:	90                   	nop
 9f0:	90                   	nop
 9f1:	90                   	nop
 9f2:	90                   	nop
 9f3:	90                   	nop
 9f4:	90                   	nop
 9f5:	90                   	nop
 9f6:	90                   	nop
 9f7:	90                   	nop
 9f8:	90                   	nop
 9f9:	90                   	nop
 9fa:	90                   	nop
 9fb:	90                   	nop
 9fc:	90                   	nop
 9fd:	90                   	nop
 9fe:	90                   	nop
 9ff:	90                   	nop
bootloader [14:54:22] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > # vshcmd: > break 0x7c00  # Start of bootloader
vshcmd: > #
vshcmd: > # Positions relevant for my bootloader
vshcmd: > # vshcmd: > break 0x7e00  # Start of bootloader second section.
vshcmd: > # vshcmd: > break 0x7fdc # Start of readInitrd
vshcmd: > break 0x802e # Start of readAndMove
vshcmd: > # vshcmd: > break 0x9c29 # ljmp into protected mode
vshcmd: > #
vshcmd: > # Positions relevant for the sebastian-minimal bootloader
vshcmd: > # vshcmd: > break 0x7cde # sebastian-minimal run_kernel function
vshcmd: > # vshcmd: > break 0x10000 # real-mode kernel start with sebastian-minimal ...
vshcmd: > # vshcmd: > break 0x1337d # Linux real-mode main() when loaded with sebastian-minimal
vshcmd: > #
vshcmd: > # Positions relevant for both (i.e. in the protected-mode kernel).
vshcmd: > # vshcmd: > break 0x100000 # Start of Linux protected-mode kernel
vshcmd: > # vshcmd: > break 0x1000bc # arch/x86/boot/compressed/head_32.S:168
vshcmd: > # vshcmd: > break 0x167423f  # prepare_namespace
vshcmd: > cont
(0) Breakpoint 1, 0x000000000000802e in ?? ()
Next at t=20640804
(0) [0x00000000802e] 0000:802e (unk. ctxt): mov ax, word ptr ds:0x7d87 ; a1877d
<bochs:4> 
vshcmd: > 
vshcmd: > x /1wx ds:0x856e
[bochs]:
0x000000000000856e <bogus+       0>:	0x933ea200
<bochs:8> 
vshcmd: > exit
(0).[20640804] [0x00000000802e] 0000:802e (unk. ctxt): mov ax, word ptr ds:0x7d87 ; a1877d
bootloader [15:05:39] $ 
vshcmd: > disasm 0x7ff7 0x806b
00007ff7: (                    ): xor ax, ax                ; 31c0
00007ff9: (                    ): mov al, byte ptr ds:0x8570 ; a07085
00007ffc: (                    ): shl eax, 0x10             ; 66c1e010
00008000: (                    ): mov ax, word ptr ds:0x856e ; a16e85
00008003: (                    ): mov dword ptr ds:0x8540, eax ; 66a34085
00008007: (                    ): mov eax, dword ptr ds:0x8544 ; 66a14485
0000800b: (                    ): mov dword ptr ds:0x7d8b, eax ; 66a38b7d
0000800f: (                    ): mov eax, dword ptr ds:0x8548 ; 66a14885
00008013: (                    ): mov dword ptr ds:0x853c, eax ; 66a33c85
00008017: (                    ): call .+20                 ; e81400
0000801a: (                    ): mov eax, dword ptr ds:0x854c ; 66a14c85
0000801e: (                    ): mov dword ptr ds:0x7d8b, eax ; 66a38b7d
00008022: (                    ): mov eax, dword ptr ds:0x8550 ; 66a15085
00008026: (                    ): mov dword ptr ds:0x853c, eax ; 66a33c85
0000802a: (                    ): call .+1                  ; e80100
0000802d: (                    ): ret                       ; c3
    # readAndMove
0000802e: (                    ): mov ax, word ptr ds:0x7d87 ; a1877d
00008031: (                    ): mov word ptr ds:0x8566, ax ; a36685
00008034: (                    ): mov ax, 0x0000            ; b80000
00008037: (                    ): mov es, ax                ; 8ec0
    # readAndMoveLoop
00008039: (                    ): mov word ptr ds:0x7d85, 0x007f ; c706857d7f00
0000803f: (                    ): call .-860                ; e8a4fc
00008042: (                    ): mov cx, 0x7f00            ; b9007f
00008045: (                    ): mov si, 0x8554            ; be5485
00008048: (                    ): mov ah, 0x87              ; b487
0000804a: (                    ): int 0x15                  ; cd15
0000804c: (                    ): jnb .+14                  ; 730e
0000804e: (                    ): mov word ptr ds:0x7d4f, ax ; a34f7d
00008051: (                    ): call .-1029               ; e8fbfb
00008054: (                    ): mov si, 0x83f4            ; bef483
00008057: (                    ): call .-1081               ; e8c7fb
0000805a: (                    ): jmp .-2                   ; ebfe
0000805c: (                    ): add word ptr ds:0x856e, 0xfe00 ; 81066e8500fe
00008062: (                    ): adc byte ptr ds:0x8570, 0x00 ; 8016708500
00008067: (                    ): jnb .+8                   ; 7308
00008069: (                    ): mov si, 0x8517            ; be1785
<bochs:7> 
