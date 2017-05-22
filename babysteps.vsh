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
bootloader [15:46:47] $ bootloader [15:46:47] $ bootloader [15:46:47] $ 3+0 records in
3+0 records out
1536 bytes (1.5 kB, 1.5 KiB) copied, 0.000205125 s, 7.5 MB/s
bootloader [15:46:47] $ bootloader [15:46:53] $ 
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
  6e:	88 1d 47 e2 f1 be    	mov    %bl,-0x410e1db9(%rip)        # ffffffffbef1e2bb <secondStage_end+0xffffffffbef1dcbb>
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
  e6:	8b 0e                	mov    (%rsi),%cx
  e8:	00 00                	add    %al,(%rax)
  ea:	8a 16                	mov    (%rsi),%dl
  ec:	00 00                	add    %al,(%rax)
  ee:	be 00 00             	mov    $0x0,%si
  f1:	b4 42                	mov    $0x42,%ah
  f3:	cd 13                	int    $0x13
  f5:	73 06                	jae    fd <readFromHardDrive+0x17>
  f7:	be 00 00             	mov    $0x0,%si
  fa:	e8 24 ff             	call   21 <errmsg>
  fd:	84 e4                	test   %ah,%ah
  ff:	74 06                	je     107 <readFromHardDrive+0x21>
 101:	be 00 00             	mov    $0x0,%si
 104:	e8 1a ff             	call   21 <errmsg>
 107:	39 0e                	cmp    %cx,(%rsi)
 109:	00 00                	add    %al,(%rax)
 10b:	74 06                	je     113 <readFromHardDrive+0x2d>
 10d:	be 00 00             	mov    $0x0,%si
 110:	e8 0e ff             	call   21 <errmsg>
 113:	c3                   	ret    

0000000000000114 <copyExtendedMemory>:
 114:	30 31                	xor    %dh,(%rcx)
 116:	32 33                	xor    (%rbx),%dh
 118:	34 35                	xor    $0x35,%al
 11a:	36 37                	ss (bad) 
 11c:	38 39                	cmp    %bh,(%rcx)
 11e:	41                   	rex.B
 11f:	42                   	rex.X
 120:	43                   	rex.XB
 121:	44                   	rex.R
 122:	45                   	rex.RB
 123:	46                   	rex.RX

0000000000000124 <outstr16>:
 124:	00 00                	add    %al,(%rax)
 126:	00 00                	add    %al,(%rax)
 128:	0a                   	.byte 0xa
 129:	0d                   	.byte 0xd
	...

000000000000012b <reg16>:
	...

000000000000012d <storedaddr>:
	...

000000000000012f <curdrive>:
	...

0000000000000130 <msgDiskFail>:
 130:	64 69 73 6b 2e 61    	imul   $0x612e,%fs:0x6b(%rbx),%si
 136:	73 6d                	jae    1a5 <successMsg+0x36>
 138:	20 70 72             	and    %dh,0x72(%rax)
 13b:	6f                   	outsw  %ds:(%rsi),(%dx)
 13c:	62                   	(bad)  
 13d:	6c                   	insb   (%dx),%es:(%rdi)
 13e:	65 6d                	gs insw (%dx),%es:(%rdi)
	...

0000000000000141 <msgReadFailed>:
 141:	63 61 6e             	movslq 0x6e(%rcx),%sp
 144:	6e                   	outsb  %ds:(%rsi),(%dx)
 145:	6f                   	outsw  %ds:(%rsi),(%dx)
 146:	74 20                	je     168 <startBlock+0x1>
 148:	72 65                	jb     1af <successMsg+0x40>
 14a:	61                   	(bad)  
 14b:	64 20 00             	and    %al,%fs:(%rax)

000000000000014e <msgNoLBA>:
 14e:	6e                   	outsb  %ds:(%rsi),(%dx)
 14f:	6f                   	outsw  %ds:(%rsi),(%dx)
 150:	20 69 6e             	and    %ch,0x6e(%rcx)
 153:	73 74                	jae    1c9 <partition_start+0x3>
 155:	61                   	(bad)  
 156:	6c                   	insb   (%dx),%es:(%rdi)
 157:	6c                   	insb   (%dx),%es:(%rdi)
 158:	65 64 20 4c 42 41    	gs and %cl,%fs:0x41(%rdx,%rax,2)
 15e:	20                   	.byte 0x20

000000000000015f <diskPacket>:
 15f:	10                   	.byte 0x10

0000000000000160 <packetReserved>:
	...

0000000000000161 <numBlocks>:
 161:	02 00                	add    (%rax),%al

0000000000000163 <transferBuffer>:
 163:	00 7e 00             	add    %bh,0x0(%rsi)
	...

0000000000000167 <startBlock>:
 167:	01 00                	add    %ax,(%rax)
 169:	00 00                	add    %al,(%rax)
 16b:	00 00                	add    %al,(%rax)
	...

000000000000016f <successMsg>:
 16f:	59                   	pop    %cx
 170:	41 59                	pop    %r9w
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
 200:	e8 8f 00             	call   292 <enablea20>
 203:	e8 3b fe             	call   41 <newline>
 206:	cd 12                	int    $0x12
 208:	d1 e0                	shl    %ax
 20a:	73 0c                	jae    218 <secondStage_start+0x18>
 20c:	a3 00 00 e8 3d fe be 	movabs %ax,0xbefe3de80000
 213:	00 00 
 215:	e8 09 fe             	call   21 <errmsg>
 218:	2d 42 00             	sub    $0x42,%ax
 21b:	a3 00 00 e8 08 00 be 	movabs %ax,0xbe0008e80000
 222:	00 00 
 224:	e8 14 fe             	call   3b <BIOSprint>
 227:	eb fe                	jmp    227 <secondStage_start+0x27>

0000000000000229 <findLinux>:
 229:	c7 06 00 00          	movw   $0x0,(%rsi)
 22d:	02 00                	add    (%rax),%al
 22f:	c7 06 00 00          	movw   $0x0,(%rsi)
 233:	00 00                	add    %al,(%rax)
 235:	66 a1 00 00 66 a3 00 	movabs 0xa6e80000a3660000,%eax
 23c:	00 e8 a6 
 23f:	fe                   	(bad)  
 240:	66 a1 00 00 66 3d 48 	movabs 0x537264483d660000,%eax
 247:	64 72 53 
 24a:	74 07                	je     253 <findLinux+0x2a>
 24c:	be 00 00             	mov    $0x0,%si
 24f:	e8 cf fd             	call   21 <errmsg>
 252:	c3                   	ret    
 253:	a1 00 00 3d 04 02 73 	movabs 0xa30c7302043d0000,%ax
 25a:	0c a3 
 25c:	00 00                	add    %al,(%rax)
 25e:	e8 ee fd             	call   4f <printReg>
 261:	be 00 00             	mov    $0x0,%si
 264:	e8 ba fd             	call   21 <errmsg>
 267:	66 31 c0             	xor    %eax,%eax
 26a:	a0 00 00 3c 00 74 02 	movabs 0x4b00274003c0000,%al
 271:	b0 04 
 273:	a2 00 00 05 80 00 3b 	movabs %al,0x63b0080050000
 27a:	06 00 
 27c:	00 72 0c             	add    %dh,0xc(%rdx)
 27f:	a3 00 00 e8 ca fd be 	movabs %ax,0xbefdcae80000
 286:	00 00 
 288:	e8 96 fd             	call   21 <errmsg>
 28b:	a3                   	.byte 0xa3
 28c:	00 00                	add    %al,(%rax)
 28e:	e8 55 fe             	call   e6 <readFromHardDrive>
 291:	c3                   	ret    

0000000000000292 <enablea20>:
 292:	e8 46 00             	call   2db <check_a20>
 295:	83 f8 01             	cmp    $0x1,%ax
 298:	75 07                	jne    2a1 <enablea20+0xf>
 29a:	be 00 00             	mov    $0x0,%si
 29d:	e8 9b fd             	call   3b <BIOSprint>
 2a0:	c3                   	ret    
 2a1:	b9 00 00             	mov    $0x0,%cx

00000000000002a4 <activatea20Loop>:
 2a4:	89 ce                	mov    %cx,%si
 2a6:	8b 34 e8             	mov    (%rax,%rbp,8),%si
 2a9:	90                   	nop
 2aa:	fd                   	std    
 2ab:	83 c1 02             	add    $0x2,%cx
 2ae:	89 ce                	mov    %cx,%si
 2b0:	8b 04 ff             	mov    (%rdi,%rdi,8),%ax
 2b3:	d0 83 c1 02 e8 21    	rolb   0x21e802c1(%rbx)
 2b9:	00 83 f8 01 74 0e    	add    %al,0xe7401f8(%rbx)
 2bf:	be 00 00             	mov    $0x0,%si
 2c2:	e8 76 fd             	call   3b <BIOSprint>
 2c5:	81 f9 00 00          	cmp    $0x0,%cx
 2c9:	77 09                	ja     2d4 <activatea20failed>
 2cb:	eb d7                	jmp    2a4 <activatea20Loop>

00000000000002cd <a20done>:
 2cd:	be 00 00             	mov    $0x0,%si
 2d0:	e8 68 fd             	call   3b <BIOSprint>
 2d3:	c3                   	ret    

00000000000002d4 <activatea20failed>:
 2d4:	be 00 00             	mov    $0x0,%si
 2d7:	e8 61 fd             	call   3b <BIOSprint>
 2da:	c3                   	ret    

00000000000002db <check_a20>:
 2db:	9c                   	pushf  
 2dc:	1e                   	(bad)  
 2dd:	06                   	(bad)  
 2de:	57                   	push   %di
 2df:	56                   	push   %si
 2e0:	fa                   	cli    
 2e1:	31 c0                	xor    %ax,%ax
 2e3:	8e c0                	mov    %ax,%es
 2e5:	f7 d0                	not    %ax
 2e7:	8e d8                	mov    %ax,%ds
 2e9:	bf 00 05             	mov    $0x500,%di
 2ec:	be 10 05             	mov    $0x510,%si
 2ef:	26 8a 05 50 8a 04 50 	mov    %es:0x50048a50(%rip),%al        # 50048d46 <secondStage_end+0x50048746>
 2f6:	26 c6 05 00 c6 04 ff 	movb   $0x26,%es:-0xfb3a00(%rip)        # ffffffffff04c8fe <secondStage_end+0xffffffffff04c2fe>
 2fd:	26 
 2fe:	80 3d ff 58 88 04 58 	cmpb   $0x58,0x48858ff(%rip)        # 4885c04 <secondStage_end+0x4885604>
 305:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8(%rip)        # 740003c4 <secondStage_end+0x73fffdc4>
 30c:	03                   	.byte 0x3
 30d:	b8 01 00             	mov    $0x1,%ax

0000000000000310 <check_a20_exit>:
 310:	5e                   	pop    %si
 311:	5f                   	pop    %di
 312:	07                   	(bad)  
 313:	1f                   	(bad)  
 314:	9d                   	popf   
 315:	c3                   	ret    

0000000000000316 <fasta20enable>:
 316:	e4 92                	in     $0x92,%al
 318:	a8 02                	test   $0x2,%al
 31a:	75 06                	jne    322 <fasta20enable+0xc>
 31c:	0c 02                	or     $0x2,%al
 31e:	24 fe                	and    $0xfe,%al
 320:	e6 92                	out    %al,$0x92
 322:	c3                   	ret    

0000000000000323 <keyboarda20enable>:
 323:	fa                   	cli    
 324:	e8 2e 00             	call   355 <a20wait>
 327:	b0 ad                	mov    $0xad,%al
 329:	e6 64                	out    %al,$0x64
 32b:	e8 27 00             	call   355 <a20wait>
 32e:	b0 d0                	mov    $0xd0,%al
 330:	e6 64                	out    %al,$0x64
 332:	e8 27 00             	call   35c <a20wait2>
 335:	e4 60                	in     $0x60,%al
 337:	66 50                	data32 push %rax
 339:	e8 19 00             	call   355 <a20wait>
 33c:	b0 d1                	mov    $0xd1,%al
 33e:	e6 64                	out    %al,$0x64
 340:	e8 12 00             	call   355 <a20wait>
 343:	66 58                	data32 pop %rax
 345:	0c 02                	or     $0x2,%al
 347:	e6 60                	out    %al,$0x60
 349:	e8 09 00             	call   355 <a20wait>
 34c:	b0 ae                	mov    $0xae,%al
 34e:	e6 64                	out    %al,$0x64
 350:	e8 02 00             	call   355 <a20wait>
 353:	fb                   	sti    
 354:	c3                   	ret    

0000000000000355 <a20wait>:
 355:	e4 64                	in     $0x64,%al
 357:	a8 02                	test   $0x2,%al
 359:	75 fa                	jne    355 <a20wait>
 35b:	c3                   	ret    

000000000000035c <a20wait2>:
 35c:	e4 64                	in     $0x64,%al
 35e:	a8 01                	test   $0x1,%al
 360:	74 fa                	je     35c <a20wait2>
 362:	c3                   	ret    

0000000000000363 <biosa20enable>:
 363:	51                   	push   %cx
 364:	b8 03 24             	mov    $0x2403,%ax
 367:	cd 15                	int    $0x15
 369:	72 2e                	jb     399 <biosa20enable+0x36>
 36b:	80 fc 00             	cmp    $0x0,%ah
 36e:	75 29                	jne    399 <biosa20enable+0x36>
 370:	b8 02 24             	mov    $0x2402,%ax
 373:	cd 15                	int    $0x15
 375:	72 1c                	jb     393 <biosa20enable+0x30>
 377:	80 fc 00             	cmp    $0x0,%ah
 37a:	75 17                	jne    393 <biosa20enable+0x30>
 37c:	3a 06                	cmp    (%rsi),%al
 37e:	01 00                	add    %ax,(%rax)
 380:	74 0c                	je     38e <biosa20enable+0x2b>
 382:	b8 01 24             	mov    $0x2401,%ax
 385:	cd 15                	int    $0x15
 387:	72 0a                	jb     393 <biosa20enable+0x30>
 389:	80 fc 00             	cmp    $0x0,%ah
 38c:	75 05                	jne    393 <biosa20enable+0x30>
 38e:	b8 01 00             	mov    $0x1,%ax
 391:	eb 09                	jmp    39c <biosa20enableret>
 393:	be 00 00             	mov    $0x0,%si
 396:	e8 a2 fc             	call   3b <BIOSprint>
 399:	b8 00 00             	mov    $0x0,%ax

000000000000039c <biosa20enableret>:
 39c:	59                   	pop    %cx
 39d:	c3                   	ret    

000000000000039e <readMemorySize>:
 39e:	66 ba 50 41 4d 53    	mov    $0x534d4150,%edx
 3a4:	66 bb 00 00 00 00    	mov    $0x0,%ebx

00000000000003aa <loop_again>:
 3aa:	66 b8 20 e8 00 00    	mov    $0xe820,%eax
 3b0:	66 b9 14 00 00 00    	mov    $0x14,%ecx
 3b6:	bf 00 00             	mov    $0x0,%di
 3b9:	cd 15                	int    $0x15
 3bb:	73 08                	jae    3c5 <loop_again+0x1b>
 3bd:	be 00 00             	mov    $0x0,%si
 3c0:	e8 5e fc             	call   21 <errmsg>
 3c3:	eb fe                	jmp    3c3 <loop_again+0x19>
 3c5:	66 3d 50 41 4d 53    	cmp    $0x534d4150,%eax
 3cb:	74 08                	je     3d5 <loop_again+0x2b>
 3cd:	be 00 00             	mov    $0x0,%si
 3d0:	e8 4e fc             	call   21 <errmsg>
 3d3:	eb fe                	jmp    3d3 <loop_again+0x29>
 3d5:	66 83 f9 14          	cmp    $0x14,%ecx
 3d9:	74 08                	je     3e3 <loop_again+0x39>
 3db:	be 00 00             	mov    $0x0,%si
 3de:	e8 40 fc             	call   21 <errmsg>
 3e1:	eb fe                	jmp    3e1 <loop_again+0x37>
 3e3:	66 53                	data32 push %rbx
 3e5:	b8 00 00             	mov    $0x0,%ax
 3e8:	e8 97 fc             	call   82 <printQWORD>
 3eb:	b8 00 00             	mov    $0x0,%ax
 3ee:	e8 91 fc             	call   82 <printQWORD>
 3f1:	b8 00 00             	mov    $0x0,%ax
 3f4:	e8 83 fc             	call   7a <printDWORD>
 3f7:	e8 47 fc             	call   41 <newline>
 3fa:	66 5b                	data32 pop %rbx
 3fc:	66 83 fb 00          	cmp    $0x0,%ebx
 400:	74 02                	je     404 <memmapexit>
 402:	eb a6                	jmp    3aa <loop_again>

0000000000000404 <memmapexit>:
 404:	c3                   	ret    

0000000000000405 <faileda20>:
 405:	2e 2e 2e 20 73 6f    	cs cs and %dh,%cs:0x6f(%rbx)
 40b:	6d                   	insw   (%dx),%es:(%rdi)
 40c:	65 74 68             	gs je  477 <keyboarda20+0x15>
 40f:	69 6e 67 20 77       	imul   $0x7720,0x67(%rsi),%bp
 414:	65 6e                	outsb  %gs:(%rsi),(%dx)
 416:	74 20                	je     438 <a20attemptsend+0xd>
 418:	77 72                	ja     48c <fasta20+0x3>
 41a:	6f                   	outsw  %ds:(%rsi),(%dx)
 41b:	6e                   	outsb  %ds:(%rsi),(%dx)
 41c:	67 20 00             	and    %al,(%eax)

000000000000041f <a20attempts>:
	...

000000000000042b <a20attemptsend>:
 42b:	41 32 30             	xor    (%r8),%sil
 42e:	20 65 6e             	and    %ah,0x6e(%rbp)
 431:	61                   	(bad)  
 432:	62                   	(bad)  
 433:	6c                   	insb   (%dx),%es:(%rdi)
 434:	65 64 20 6f 6e       	gs and %ch,%fs:0x6e(%rdi)
 439:	20 62 6f             	and    %ah,0x6f(%rdx)
 43c:	6f                   	outsw  %ds:(%rsi),(%dx)
 43d:	74 00                	je     43f <biosa20>

000000000000043f <biosa20>:
 43f:	41 74 74             	rex.B je 4b6 <enabledmsg+0x3>
 442:	65 6d                	gs insw (%dx),%es:(%rdi)
 444:	70 74                	jo     4ba <enabledmsg+0x7>
 446:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 44b:	6f                   	outsw  %ds:(%rsi),(%dx)
 44c:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 450:	6e                   	outsb  %ds:(%rsi),(%dx)
 451:	20 6f 6e             	and    %ch,0x6e(%rdi)
 454:	20 61 32             	and    %ah,0x32(%rcx)
 457:	30 20                	xor    %ah,(%rax)
 459:	76 69                	jbe    4c4 <enabledmsg+0x11>
 45b:	61                   	(bad)  
 45c:	20 42 49             	and    %al,0x49(%rdx)
 45f:	4f 53                	rex.WRXB push %r11
	...

0000000000000462 <keyboarda20>:
 462:	41 74 74             	rex.B je 4d9 <notenabledmsg+0x8>
 465:	65 6d                	gs insw (%dx),%es:(%rdi)
 467:	70 74                	jo     4dd <notenabledmsg+0xc>
 469:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 46e:	6f                   	outsw  %ds:(%rsi),(%dx)
 46f:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 473:	6e                   	outsb  %ds:(%rsi),(%dx)
 474:	20 6f 6e             	and    %ch,0x6e(%rdi)
 477:	20 61 32             	and    %ah,0x32(%rcx)
 47a:	30 20                	xor    %ah,(%rax)
 47c:	76 69                	jbe    4e7 <a20disabled>
 47e:	61                   	(bad)  
 47f:	20 6b 65             	and    %ch,0x65(%rbx)
 482:	79 62                	jns    4e6 <notenabledmsg+0x15>
 484:	6f                   	outsw  %ds:(%rsi),(%dx)
 485:	61                   	(bad)  
 486:	72 64                	jb     4ec <a20disabled+0x5>
	...

0000000000000489 <fasta20>:
 489:	41 74 74             	rex.B je 500 <msgMemSizeFailed+0x7>
 48c:	65 6d                	gs insw (%dx),%es:(%rdi)
 48e:	70 74                	jo     504 <msgMemSizeFailed+0xb>
 490:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 495:	6f                   	outsw  %ds:(%rsi),(%dx)
 496:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 49a:	6e                   	outsb  %ds:(%rsi),(%dx)
 49b:	20 6f 6e             	and    %ch,0x6e(%rdi)
 49e:	20 61 32             	and    %ah,0x32(%rcx)
 4a1:	30 20                	xor    %ah,(%rax)
 4a3:	76 69                	jbe    50e <msgMemSizeFailed+0x15>
 4a5:	61                   	(bad)  
 4a6:	20 66 61             	and    %ah,0x61(%rsi)
 4a9:	73 74                	jae    51f <memmap_start+0xb>
 4ab:	20 6d 65             	and    %ch,0x65(%rbp)
 4ae:	74 68                	je     518 <memmap_start+0x4>
 4b0:	6f                   	outsw  %ds:(%rsi),(%dx)
 4b1:	64                   	fs
	...

00000000000004b3 <enabledmsg>:
 4b3:	2e 2e 2e 20 20       	cs cs and %ah,%cs:(%rax)
 4b8:	77 6f                	ja     529 <availSpace+0x1>
 4ba:	72 6b                	jb     527 <memmap_start+0x13>
 4bc:	65 64 21 0d 0a 41 32 	gs and %cx,%fs:0x3032410a(%rip)        # 303245ce <secondStage_end+0x30323fce>
 4c3:	30 
 4c4:	20 69 73             	and    %ch,0x73(%rcx)
 4c7:	20 65 6e             	and    %ah,0x6e(%rbp)
 4ca:	61                   	(bad)  
 4cb:	62                   	(bad)  
 4cc:	6c                   	insb   (%dx),%es:(%rdi)
 4cd:	65 64 21 00          	gs and %ax,%fs:(%rax)

00000000000004d1 <notenabledmsg>:
 4d1:	2e 2e 2e 20 20       	cs cs and %ah,%cs:(%rax)
 4d6:	64 69 64 6e 27 74 20 	imul   $0x2074,%fs:0x27(%rsi,%rbp,2),%sp
 4dd:	77 6f                	ja     54e <msgNoMagic>
 4df:	72 6b                	jb     54c <msgTooMuchSpace+0x19>
 4e1:	20 2e                	and    %ch,(%rsi)
 4e3:	2e 0d 0a 00          	cs or  $0xa,%ax

00000000000004e7 <a20disabled>:
 4e7:	41 32 30             	xor    (%r8),%sil
 4ea:	20 69 73             	and    %ch,0x73(%rcx)
 4ed:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
 4f1:	61                   	(bad)  
 4f2:	62                   	(bad)  
 4f3:	6c                   	insb   (%dx),%es:(%rdi)
 4f4:	65 64 21 21          	gs and %sp,%fs:(%rcx)
	...

00000000000004f9 <msgMemSizeFailed>:
 4f9:	67 65 74 74          	addr32 gs je 571 <msgBadVersion+0x14>
 4fd:	69 6e 67 20 6d       	imul   $0x6d20,0x67(%rsi),%bp
 502:	65 6d                	gs insw (%dx),%es:(%rdi)
 504:	6f                   	outsw  %ds:(%rsi),(%dx)
 505:	72 79                	jb     580 <msgNoSpace+0xc>
 507:	20 73 69             	and    %dh,0x69(%rbx)
 50a:	7a 65                	jp     571 <msgBadVersion+0x14>
 50c:	20 66 61             	and    %ah,0x61(%rsi)
 50f:	69                   	.byte 0x69
 510:	6c                   	insb   (%dx),%es:(%rdi)
 511:	65                   	gs
 512:	64                   	fs
	...

0000000000000514 <memmap_start>:
	...

0000000000000528 <availSpace>:
	...

000000000000052a <linuxSetupSectors>:
	...

000000000000052b <linuxProtectedSize>:
 52b:	00 00                	add    %al,(%rax)
	...

000000000000052f <vmlinuz_block>:
 52f:	48 19 18             	sbb    %rbx,(%rax)
	...

0000000000000533 <msgTooMuchSpace>:
 533:	4f 76 65             	rex.WRXB jbe 59b <linuxCmdLine+0x16>
 536:	72 66                	jb     59e <linuxCmdLine+0x19>
 538:	6c                   	insb   (%dx),%es:(%rdi)
 539:	6f                   	outsw  %ds:(%rsi),(%dx)
 53a:	77 20                	ja     55c <msgNoMagic+0xe>
 53c:	63 61 6c             	movslq 0x6c(%rcx),%sp
 53f:	63 75 6c             	movslq 0x6c(%rbp),%si
 542:	61                   	(bad)  
 543:	74 69                	je     5ae <linuxCmdLine+0x29>
 545:	6e                   	outsb  %ds:(%rsi),(%dx)
 546:	67 20 73 70          	and    %dh,0x70(%ebx)
 54a:	61                   	(bad)  
 54b:	63 65 00             	movslq 0x0(%rbp),%sp

000000000000054e <msgNoMagic>:
 54e:	6e                   	outsb  %ds:(%rsi),(%dx)
 54f:	6f                   	outsw  %ds:(%rsi),(%dx)
 550:	20 6d 61             	and    %ch,0x61(%rbp)
 553:	67 69 63 20 6c 69    	imul   $0x696c,0x20(%ebx),%sp
 559:	6e                   	outsb  %ds:(%rsi),(%dx)
 55a:	75 78                	jne    5d4 <linuxCmdLine+0x4f>
	...

000000000000055d <msgBadVersion>:
 55d:	6f                   	outsw  %ds:(%rsi),(%dx)
 55e:	6c                   	insb   (%dx),%es:(%rdi)
 55f:	64 20 4c 69 6e       	and    %cl,%fs:0x6e(%rcx,%rbp,2)
 564:	75 78                	jne    5de <linuxCmdLine+0x59>
 566:	20 62 6f             	and    %ah,0x6f(%rdx)
 569:	6f                   	outsw  %ds:(%rsi),(%dx)
 56a:	74 20                	je     58c <linuxCmdLine+0x7>
 56c:	76 65                	jbe    5d3 <linuxCmdLine+0x4e>
 56e:	72 73                	jb     5e3 <linuxCmdLine+0x5e>
 570:	69                   	.byte 0x69
 571:	6f                   	outsw  %ds:(%rsi),(%dx)
 572:	6e                   	outsb  %ds:(%rsi),(%dx)
	...

0000000000000574 <msgNoSpace>:
 574:	6e                   	outsb  %ds:(%rsi),(%dx)
 575:	6f                   	outsw  %ds:(%rsi),(%dx)
 576:	74 20                	je     598 <linuxCmdLine+0x13>
 578:	65 6e                	outsb  %gs:(%rsi),(%dx)
 57a:	6f                   	outsw  %ds:(%rsi),(%dx)
 57b:	75 67                	jne    5e4 <linuxCmdLine+0x5f>
 57d:	68 20 73             	push   $0x7320
 580:	70 61                	jo     5e3 <linuxCmdLine+0x5e>
 582:	63 65 00             	movslq 0x0(%rbp),%sp

0000000000000585 <linuxCmdLine>:
 585:	72 6f                	jb     5f6 <linuxCmdLine+0x71>
 587:	6f                   	outsw  %ds:(%rsi),(%dx)
 588:	74 3d                	je     5c7 <linuxCmdLine+0x42>
 58a:	55                   	push   %bp
 58b:	55                   	push   %bp
 58c:	49                   	rex.WB
 58d:	44 3d 66 66          	rex.R cmp $0x6666,%ax
 591:	39 62 65             	cmp    %sp,0x65(%rdx)
 594:	38 63 30             	cmp    %ah,0x30(%rbx)
 597:	2d 34 38             	sub    $0x3834,%ax
 59a:	32 31                	xor    (%rcx),%dh
 59c:	2d 34 64             	sub    $0x6434,%ax
 59f:	30 30                	xor    %dh,(%rax)
 5a1:	2d 38 30             	sub    $0x3038,%ax
 5a4:	34 36                	xor    $0x36,%al
 5a6:	2d 37 38             	sub    $0x3837,%ax
 5a9:	64 62                	fs (bad) 
 5ab:	36 66 37             	ss data32 (bad) 
 5ae:	33 30                	xor    (%rax),%si
 5b0:	33 62 34             	xor    0x34(%rdx),%sp
 5b3:	20 72 6f             	and    %dh,0x6f(%rdx)
 5b6:	20 20                	and    %ah,(%rax)
 5b8:	71 75                	jno    62f <secondStage_end+0x2f>
 5ba:	69 65 74 00 90       	imul   $0x9000,0x74(%rbp),%sp
 5bf:	90                   	nop
 5c0:	90                   	nop
 5c1:	90                   	nop
 5c2:	90                   	nop
 5c3:	90                   	nop
 5c4:	90                   	nop
 5c5:	90                   	nop
 5c6:	90                   	nop
 5c7:	90                   	nop
 5c8:	90                   	nop
 5c9:	90                   	nop
 5ca:	90                   	nop
 5cb:	90                   	nop
 5cc:	90                   	nop
 5cd:	90                   	nop
 5ce:	90                   	nop
 5cf:	90                   	nop
 5d0:	90                   	nop
 5d1:	90                   	nop
 5d2:	90                   	nop
 5d3:	90                   	nop
 5d4:	90                   	nop
 5d5:	90                   	nop
 5d6:	90                   	nop
 5d7:	90                   	nop
 5d8:	90                   	nop
 5d9:	90                   	nop
 5da:	90                   	nop
 5db:	90                   	nop
 5dc:	90                   	nop
 5dd:	90                   	nop
 5de:	90                   	nop
 5df:	90                   	nop
 5e0:	90                   	nop
 5e1:	90                   	nop
 5e2:	90                   	nop
 5e3:	90                   	nop
 5e4:	90                   	nop
 5e5:	90                   	nop
 5e6:	90                   	nop
 5e7:	90                   	nop
 5e8:	90                   	nop
 5e9:	90                   	nop
 5ea:	90                   	nop
 5eb:	90                   	nop
 5ec:	90                   	nop
 5ed:	90                   	nop
 5ee:	90                   	nop
 5ef:	90                   	nop
 5f0:	90                   	nop
 5f1:	90                   	nop
 5f2:	90                   	nop
 5f3:	90                   	nop
 5f4:	90                   	nop
 5f5:	90                   	nop
 5f6:	90                   	nop
 5f7:	90                   	nop
 5f8:	90                   	nop
 5f9:	90                   	nop
 5fa:	90                   	nop
 5fb:	90                   	nop
 5fc:	90                   	nop
 5fd:	90                   	nop
 5fe:	90                   	nop
 5ff:	90                   	nop
bootloader [15:47:07] $ 
vshcmd: > sudo fdisk -l
[sudo] password for matthew: 
[1mDisk /dev/sda: 232.9 GiB, 250059350016 bytes, 488397168 sectors
[0mUnits: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x7b823c67

[1mDevice[0m     [1mBoot[0m [1m    Start[0m [1m      End[0m [1m  Sectors[0m [1m  Size[0m [1mId[0m [1mType[0m
/dev/sda1  *         2048    206847    204800   100M  7 HPFS/NTFS/exFAT
/dev/sda2          206848 153925631 153718784  73.3G  7 HPFS/NTFS/exFAT
/dev/sda3       153925632 154847231    921600   450M 27 Hidden NTFS WinRE
/dev/sda4       154849280 488396799 333547520   159G  5 Extended
/dev/sda5       154851328 203988991  49137664  23.4G 82 Linux swap / Solaris
/dev/sda6       203991040 488396799 284405760 135.6G 83 Linux




[1mDisk /dev/sdb: 3.8 GiB, 4009754624 bytes, 7831552 sectors
[0mUnits: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6f215e7b

[1mDevice[0m     [1mBoot[0m [1m  Start[0m [1m    End[0m [1mSectors[0m [1m Size[0m [1mId[0m [1mType[0m
/dev/sdb1  *       2048 7403519 7401472  3.5G 83 Linux
/dev/sdb2       7405566 7829503  423938  207M  5 Extended
/dev/sdb5       7405568 7829503  423936  207M 82 Linux swap / Solaris
bootloader [12:28:29] $ 
vshcmd: > python
vshcmd: > numbytes = 512 * 7831552
vshcmd: > nummegabytes = numbytes / (1024 ** 2)
vshcmd: > nummegabytes
Python 3.6.1 (default, Mar 27 2017, 00:27:06) 
[GCC 6.3.1 20170306] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> >>> >>> 3824.0
>>> 
vshcmd: > # Create a hard-drive image using the bximage tool.
vshcmd: > rm bxcreated.img
vshcmd: > bximage
vshcmd: > 1
vshcmd: > hd
vshcmd: > flat
vshcmd: > 3824
vshcmd: > bxcreated.img
rm: cannot remove 'bxcreated.img': No such file or directory
bootloader [12:35:38] $ ========================================================================
                                bximage
  Disk Image Creation / Conversion / Resize and Commit Tool for Bochs
         $Id: bximage.cc 13069 2017-02-12 16:51:52Z vruppert $
========================================================================

1. Create new floppy or hard disk image
2. Convert hard disk image to other format (mode)
3. Resize hard disk image
4. Commit 'undoable' redolog to base image
5. Disk image info

0. Quit

Please choose one [0] 
Create image

Do you want to create a floppy disk image or a hard disk image?
Please type hd or fd. [hd] 
What kind of image should I create?
Please type flat, sparse, growing, vpc or vmware4. [flat] 
Enter the hard disk size in megabytes, between 10 and 8257535
[10] 
What should be the name of the image?
[c.img] 
Creating hard disk image 'bxcreated.img' with CHS=7769/16/63

The following line should appear in your bochsrc:
  ata0-master: type=disk, path="bxcreated.img", mode=flat
bootloader [12:35:38] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > break 0x7e00
vshcmd: > cont
========================================================================
                       Bochs x86 Emulator 2.6.9
               Built from SVN snapshot on April 9, 2017
                  Compiled on Apr 21 2017 at 23:41:40
========================================================================
00000000000i[      ] BXSHARE not set. using compile time default '/usr/share/bochs'
00000000000i[      ] reading configuration from bochsrc.txt
------------------------------
Bochs Configuration: Main Menu
------------------------------

This is the Bochs Configuration Interface, where you can describe the
machine that you want to simulate.  Bochs has already searched for a
configuration file (typically called bochsrc.txt) and loaded it if it
could be found.  When you are satisfied with the configuration, go
ahead and start the simulation.

You can also start bochs with the -q option to skip these menus.

1. Restore factory default configuration
2. Read options from...
3. Edit options
4. Save options to...
5. Restore the Bochs state from...
6. Begin simulation
7. Quit now

Please choose one: [6] 00000000000i[      ] installing x module as the Bochs GUI
00000000000i[      ] using log file bochsout.txt
Next at t=0
(0) [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
<bochs:1> <bochs:2> (0) Breakpoint 1, 0x0000000000007e00 in ?? ()
Next at t=17465137
(0) [0x000000007e00] 0000:7e00 (unk. ctxt): call .+103 (0x00007e6a)   ; e86700
<bochs:3> 
vshcmd: > next
Next at t=17485172
(0) [0x000000007e5d] 0000:7e5d (unk. ctxt): mov word ptr ds:0x7d2b, ax ; a32b7d
<bochs:32> 
vshcmd: > cont
========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[183580000] [0x000000007e11] 0000:7e11 (unk. ctxt): jmp .-2 (0x00007e11)      ; ebfe
bootloader [12:50:16] $ 
vshcmd: > reg
CPU0:
rax: 00000000_00000072 rcx: 00000000_00090002
rdx: 00000000_00000000 rbx: 00000000_00000002
rsp: 00000000_0000fffd rbp: 00000000_00000000
rsi: 00000000_000e7d5f rdi: 00000000_0000ffac
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_00007e5b
eflags 0x00000206: id vip vif ac vm rf nt IOPL=0 of df IF tf sf zf af PF cf
<bochs:31> 
vshcmd: > calc ax
0x72 114
<bochs:27> 
vshcmd: > x /1xh 0x8100
[bochs]:
0x0000000000008100 <bogus+       0>:	0x0000
<bochs:28> 
vshcmd: > calc ax
0x22 34
<bochs:23> 
vshcmd: > step
Next at t=17479791
(0) [0x000000007e13] 0000:7e13 (unk. ctxt): mov word ptr ds:0x7d61, 0x0002 ; c706617d0200
<bochs:7> 
vshcmd: > next
Next at t=17485406
(0) [0x000000007e4c] 0000:7e4c (unk. ctxt): div ax, bx                ; f7f3
<bochs:23> ========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[77940000] [0x000000007e4c] 0000:7e4c (unk. ctxt): div ax, bx                ; f7f3
bootloader [12:42:00] $ 
vshcmd: > calc eax
0x22 34
<bochs:22> 
