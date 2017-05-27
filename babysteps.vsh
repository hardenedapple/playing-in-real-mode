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
bootloader [13:09:58] $ 
vshcmd: > rm otherBIOSes/sebastian-bootloader.bin
vshcmd: > nasm otherBIOSes/sebastian-minimal-linux-bootloader.asm -o otherBIOSes/sebastian-bootloader.bin
vshcmd: > dd if=otherBIOSes/sebastian-bootloader.bin of=totalUSB.img conv=notrunc
vshcmd: > qemu-system-x86_64 -drive file=totalUSB.img,format=raw
bootloader [12:02:57] $ bootloader [12:02:57] $ 0+1 records in
0+1 records out
417 bytes copied, 0.000293474 s, 1.4 MB/s
bootloader [12:02:57] $ bootloader [12:02:59] $ 
vshcmd: > dd if=otherBIOSes/debian_GRUB.img of=totalUSB.img conv=notrunc
2048+0 records in
2048+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00717153 s, 146 MB/s
bootloader [12:02:55] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > # vshcmd: > break 0x7c00  # Start of bootloader
vshcmd: > #
vshcmd: > # Positions relevant for my bootloader
vshcmd: > break 0x7e00  # Start of bootloader second section.
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
Next at t=17465668
(0) [0x000000007e00] 0000:7e00 (unk. ctxt): int 0x12                  ; cd12
<bochs:3> 
vshcmd: > break 0x7fc3
<bochs:5> 
vshcmd: > cont
(0) Breakpoint 2, 0x0000000000007fc3 in ?? ()
Next at t=17480898
(0) [0x000000007fc3] 0000:7fc3 (unk. ctxt): mov word ptr ds:0x7d85, 0x007f ; c706857d7f00
<bochs:6> 
vshcmd: > next
vshcmd: > disasm 0x7fc3 0x7fff
00007fc3: (                    ): mov word ptr ds:0x7d85, 0x007f ; c706857d7f00
00007fc9: (                    ): call .-742                ; e81afd
00007fcc: (                    ): mov ah, 0x87              ; b487
00007fce: (                    ): mov cx, 0x7f00            ; b9007f
00007fd1: (                    ): mov si, 0x8412            ; be1284
00007fd4: (                    ): int 0x15                  ; cd15
00007fd6: (                    ): jnb .+14                  ; 730e
00007fd8: (                    ): mov word ptr ds:0x7d4f, ax ; a34f7d
00007fdb: (                    ): call .-911                ; e871fc
00007fde: (                    ): mov si, 0x8374            ; be7483
00007fe1: (                    ): call .-963                ; e83dfc
00007fe4: (                    ): jmp .-2                   ; ebfe
00007fe6: (                    ): add word ptr ds:0x842c, 0xfe00 ; 81062c8400fe
00007fec: (                    ): adc byte ptr ds:0x842e, 0x00 ; 80162e8400
00007ff1: (                    ): add dword ptr ds:0x7d8b, 0x0000007f ; 6683068b7d7f
00007ff7: (                    ): sub word ptr ds:0x840e, 0x007f ; 832e0e847f
00007ffc: (                    ): jnbe .-59                 ; 77c5
00007ffe: (                    ): ret                       ; c3
<bochs:7> 
vshcmd: > cont
(0) Breakpoint 2, 0x0000000000007fc3 in ?? ()
Next at t=17615369
(0) [0x000000007fc3] 0000:7fc3 (unk. ctxt): mov word ptr ds:0x7d85, 0x007f ; c706857d7f00
<bochs:10> 
vshcmd: > info break
Num Type           Disp Enb Address
  1 pbreakpoint    keep y   0x000000007e00
  2 pbreakpoint    keep y   0x000000007fc3
<bochs:11> 
vshcmd: > cont
========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[541440000] [0x0000017efa9f] 0010:00000000017efa9f (unk. ctxt): imul ecx, edi             ; 0fafcf
bootloader [12:15:44] $ 
vshcmd: > info break
Num Type           Disp Enb Address
  1 pbreakpoint    keep y   0x000000007e00
  2 pbreakpoint    keep y   0x000000007fc3
<bochs:13> 
vshcmd: >
vshcmd: > exit
(0).[17419608] [0x000000007c93] 0000:7c93 (unk. ctxt): mov eax, 0x0000007f       ; 66b87f000000
bootloader [12:11:56] $ 
vshcmd: > x /15bx eax
[bochs]:
0x61	0x75	0x74	0x6f	0x00	0x00	0x00	0x00
0x00	0x00	0x00	0x00	0x00	0x00	0x00
<bochs:7> 
vshcmd: > exit
(0).[20531165] [0x000000010651] 1000:0651 (unk. ctxt): push ebp                  ; 6655
bootloader [11:57:38] $ 
vshcmd: > calc ebp
0x0 0
<bochs:26> 
vshcmd: > exit
(0).[20531599] [0x00000001067b] 1000:067b (unk. ctxt): xor eax, eax              ; 6631c0
bootloader [11:56:41] $ 
vshcmd: > disasm 0x00010651 67409
00010651: (                    ): push ebp                  ; 6655
00010653: (                    ): push edi                  ; 6657
00010655: (                    ): push esi                  ; 6656
00010657: (                    ): push ebx                  ; 6653
00010659: (                    ): push ecx                  ; 6651
0001065b: (                    ): mov dword ptr ss:[esp], edx ; 6766891424
00010660: (                    ): test eax, eax             ; 6685c0
00010663: (                    ): jz .+151                  ; 0f849700
00010667: (                    ): mov ebp, eax              ; 6689c5
0001066a: (                    ): and ebp, 0x0000000f       ; 6683e50f
0001066e: (                    ): shr eax, 0x04             ; 66c1e804
00010672: (                    ): movzx eax, ax             ; 660fb7c0
00010676: (                    ): mov fs, ax                ; 8ee0
00010678: (                    ): mov ecx, ebp              ; 6689e9
0001067b: (                    ): xor eax, eax              ; 6631c0
0001067e: (                    ): xor ebx, ebx              ; 6631db
00010681: (                    ): xor edi, edi              ; 6631ff
00010684: (                    ): lea esi, dword ptr ds:[ecx+1] ; 67668d7101
00010689: (                    ): mov cl, byte ptr fs:[ecx] ; 64678a09
0001068d: (                    ): mov edx, esi              ; 6689f2
00010690: (                    ): sub edx, ebp              ; 6629ea
00010693: (                    ): cmp eax, 0x00000001       ; 6683f801
00010697: (                    ): jz .+23                   ; 7417
00010699: (                    ): cmp eax, 0x00000002       ; 6683f802
0001069d: (                    ): jz .+56                   ; 7438
0001069f: (                    ): test cl, cl               ; 84c9
000106a1: (                    ): jz .+102                  ; 7466
000106a3: (                    ): cmp cl, 0x20              ; 80f920
000106a6: (                    ): jbe .+69                  ; 7645
000106a8: (                    ): mov ebx, dword ptr ss:[esp] ; 67668b1c24
000106ad: (                    ): mov edi, edx              ; 6689d7
000106b0: (                    ): mov al, byte ptr ds:[ebx] ; 678a03
000106b3: (                    ): test al, al               ; 84c0
000106b5: (                    ): jnz .+13                  ; 750d
000106b7: (                    ): cmp cl, 0x20              ; 80f920
000106ba: (                    ): jbe .+72                  ; 7648
000106bc: (                    ): mov eax, 0x00000002       ; 66b802000000
000106c2: (                    ): jmp .+44                  ; eb2c
000106c4: (                    ): test cl, cl               ; 84c9
000106c6: (                    ): jz .+65                   ; 7441
000106c8: (                    ): inc ebx                   ; 6643
000106ca: (                    ): cmp cl, al                ; 38c1
000106cc: (                    ): setnz al                  ; 0f95c0
000106cf: (                    ): movzx eax, al             ; 660fb6c0
000106d3: (                    ): inc eax                   ; 6640
000106d5: (                    ): jmp .+25                  ; eb19
000106d7: (                    ): test cl, cl               ; 84c9
000106d9: (                    ): jz .+46                   ; 742e
000106db: (                    ): xor eax, eax              ; 6631c0
000106de: (                    ): cmp cl, 0x20              ; 80f920
000106e1: (                    ): setnbe al                 ; 0f97c0
000106e4: (                    ): neg eax                   ; 66f7d8
000106e7: (                    ): and eax, 0x00000002       ; 6683e002
000106eb: (                    ): jmp .+3                   ; eb03
000106ed: (                    ): xor eax, eax              ; 6631c0
000106f0: (                    ): cmp esi, 0x0000ffff       ; 6681feffff0000
000106f7: (                    ): jnbe .+16                 ; 7710
000106f9: (                    ): mov ecx, esi              ; 6689f1
000106fc: (                    ): jmp .-122                 ; eb86
000106fe: (                    ): or eax, 0xffffffff        ; 6683c8ff
00010702: (                    ): jmp .+8                   ; eb08
00010704: (                    ): mov eax, edi              ; 6689f8
00010707: (                    ): jmp .+3                   ; eb03
00010709: (                    ): xor eax, eax              ; 6631c0
0001070c: (                    ): pop edx                   ; 665a
0001070e: (                    ): pop ebx                   ; 665b
00010710: (                    ): pop esi                   ; 665e
00010712: (                    ): pop edi                   ; 665f
00010714: (                    ): pop ebp                   ; 665d
00010716: (                    ): ret                       ; 66c3
00010718: (                    ): push si                   ; 56
00010719: (                    ): push di                   ; 57
0001071a: (                    ): mov di, ax                ; 89c7
0001071c: (                    ): mov si, dx                ; 89d6
0001071e: (                    ): push cx                   ; 51
0001071f: (                    ): shr cx, 0x02              ; c1e902
00010722: (                    ): rep movsd dword ptr es:[di], dword ptr ds:[si] ; f366a5
00010725: (                    ): pop cx                    ; 59
00010726: (                    ): and cx, 0x0003            ; 83e103
00010729: (                    ): rep movsb byte ptr es:[di], byte ptr ds:[si] ; f3a4
0001072b: (                    ): pop di                    ; 5f
0001072c: (                    ): pop si                    ; 5e
0001072d: (                    ): ret                       ; 66c3
0001072f: (                    ): push di                   ; 57
00010730: (                    ): mov di, ax                ; 89c7
00010732: (                    ): movzx eax, dl             ; 660fb6c2
00010736: (                    ): imul eax, eax, 0x01010101 ; 6669c001010101
0001073d: (                    ): push cx                   ; 51
0001073e: (                    ): shr cx, 0x02              ; c1e902
00010741: (                    ): rep stosd dword ptr es:[di], eax ; f366ab
00010744: (                    ): pop cx                    ; 59
00010745: (                    ): and cx, 0x0003            ; 83e103
00010748: (                    ): rep stosb byte ptr es:[di], al ; f3aa
0001074a: (                    ): pop di                    ; 5f
0001074b: (                    ): ret                       ; 66c3
0001074d: (                    ): push ds                   ; 1e
0001074e: (                    ): push fs                   ; 0fa0
00010750: (                    ): pop ds                    ; 1f
<bochs:73> 
vshcmd: >
vshcmd: > step
vshcmd: > disasm 0x13381 0x133ff
00013381: (                    ): sub esp, 0x00000058       ; 6683ec58
00013385: (                    ): mov esi, 0x000001f1       ; 66bef1010000
0001338b: (                    ): mov edi, 0x000047d1       ; 66bfd1470000
00013391: (                    ): mov ecx, 0x00000077       ; 66b977000000
00013397: (                    ): rep movsb byte ptr es:[di], byte ptr ds:[si] ; f3a4
00013399: (                    ): cmp dword ptr ds:0x4808, 0x00000000 ; 66833e084800
0001339f: (                    ): jnz .+43                  ; 752b
000133a1: (                    ): cmp word ptr ds:0x0020, 0xa33f ; 813e20003fa3
000133a7: (                    ): jnz .+35                  ; 7523
000133a9: (                    ): movzx edx, word ptr ds:0x0022 ; 660fb7162200
000133af: (                    ): mov eax, 0xffff9000       ; 66b80090ffff
000133b5: (                    ): cmp dx, word ptr ds:0x47f2 ; 3b16f247
000133b9: (                    ): jnb .+2                   ; 7302
000133bb: (                    ): mov ax, ds                ; 8cd8
000133bd: (                    ): movzx eax, ax             ; 660fb7c0
000133c1: (                    ): shl eax, 0x04             ; 66c1e004
000133c5: (                    ): add eax, edx              ; 6601d0
000133c8: (                    ): mov dword ptr ds:0x4808, eax ; 66a30848
000133cc: (                    ): call .-9825               ; 66e89fd9ffff
000133d2: (                    ): mov eax, dword ptr ds:0x4808 ; 66a10848
000133d6: (                    ): cmp eax, 0x000fffff       ; 663dffff0f00
000133dc: (                    ): jbe .+14                  ; 760e
000133de: (                    ): mov eax, 0x00003727       ; 66b827370000
000133e4: (                    ): call .-12340              ; 66e8cccfffff
000133ea: (                    ): jmp .+17                  ; eb11
000133ec: (                    ): mov edx, 0x00003744       ; 66ba44370000
000133f2: (                    ): call .-11687              ; 66e859d2ffff
000133f8: (                    ): test eax, eax             ; 6685c0
000133fb: (                    ): jnz .-31                  ; 75e1
000133fd: (                    ): cmp byte ptr ds:0x47f1, 0x00 ; 803ef14700
<bochs:40> 
vshcmd: > x /15bx ds:0x3744
[bochs]:
0x64	0x65	0x62	0x75	0x67	0x00	0x57	0x41
0x52	0x4e	0x49	0x4e	0x47	0x3a	0x20
<bochs:68> 
vshcmd: > # 0x61 0x75 0x74 0x6f 0x20 0x64 0x65 0x62 0x75 0x67 0x00
<bochs:47> 
vshcmd: > x /1
vshcmd: > x /1wx ds:0x1f1
[bochs]:
0x00000000000101f1 <bogus+       0>:	0x9d000121
<bochs:41> 
vshcmd: > x /1bx es:0x211
[bochs]:
0x0000000000010211 <bogus+       0>:	0x81
<bochs:29> 
vshcmd: > exit
(0).[20922659] [0x000000100088] 0010:0000000000100088 (unk. ctxt): cld                       ; fc
bootloader [11:20:04] $ 
vshcmd: > cont
(0) Breakpoint 2, 0x0000000000100000 in ?? ()
Next at t=20922658
(0) [0x000000100000] 0010:0000000000100000 (unk. ctxt): jmp .+131 (0x00100088)    ; e983000000
<bochs:20> 
vshcmd: > next
Next at t=20922659
(0) [0x000000100088] 0010:0000000000100088 (unk. ctxt): cld                       ; fc
<bochs:21> 
vshcmd: > help
h|help - show list of debugger commands
h|help command - show short command description
-*- Debugger control -*-
    help, q|quit|exit, set, instrument, show, trace, trace-reg,
    trace-mem, u|disasm, ldsym, slist
-*- Execution control -*-
    c|cont|continue, s|step, p|n|next, modebp, vmexitbp
-*- Breakpoint management -*-
    vb|vbreak, lb|lbreak, pb|pbreak|b|break, sb, sba, blist,
    bpe, bpd, d|del|delete, watch, unwatch
-*- CPU and memory contents -*-
    x, xp, setpmem, writemem, crc, info,
    r|reg|regs|registers, fp|fpu, mmx, sse, sreg, dreg, creg,
    page, set, ptime, print-stack, ?|calc
-*- Working with bochs param tree -*-
    show "param", restore
<bochs:17> 
vshcmd: > calc ebp
0x100000 1048576
<bochs:28> 
vshcmd: > calc ebx
0x1000000 16777216
<bochs:35> 
vshcmd: > disasm 0x1000b4 0x1000ff
001000b4: (                    ): mov ebx, ebp              ; 89eb
001000b6: (                    ): mov eax, dword ptr ds:[esi+560] ; 8b8630020000
001000bc: (                    ): dec eax                   ; 48
001000bd: (                    ): add ebx, eax              ; 01c3
001000bf: (                    ): not eax                   ; f7d0
001000c1: (                    ): and ebx, eax              ; 21c3
001000c3: (                    ): cmp ebx, 0x01000000       ; 81fb00000001
001000c9: (                    ): jnl .+5                   ; 7d05
001000cb: (                    ): mov ebx, 0x01000000       ; bb00000001
001000d0: (                    ): add ebx, 0x00518000       ; 81c300805100
001000d6: (                    ): lea esp, dword ptr ds:[ebx+3078592] ; 8da3c0f92e00
001000dc: (                    ): push 0x00000000           ; 6a00
001000de: (                    ): popf                      ; 9d
001000df: (                    ): push esi                  ; 56
001000e0: (                    ): lea esi, dword ptr ss:[ebp+3008956] ; 8db5bce92d00
001000e6: (                    ): lea edi, dword ptr ds:[ebx+3008956] ; 8dbbbce92d00
001000ec: (                    ): mov ecx, 0x002de9c0       ; b9c0e92d00
001000f1: (                    ): shr ecx, 0x02             ; c1e902
001000f4: (                    ): std                       ; fd
001000f5: (                    ): rep movsd dword ptr es:[edi], dword ptr ds:[esi] ; f3a5
001000f7: (                    ): cld                       ; fc
001000f8: (                    ): pop esi                   ; 5e
001000f9: (                    ): lea eax, dword ptr ds:[ebx+2978616] ; 8d8338732d00
<bochs:26> 
vshcmd: > exit
(0).[20922214] [0x0000001000dc] 0010:00000000001000dc (unk. ctxt): push 0x00000000           ; 6a00
bootloader [10:23:37] $ 
vshcmd: > next
Next at t=21056950
(0) [0x000000100088] 0010:0000000000100088 (unk. ctxt): cld                       ; fc
<bochs:4> 
vshcmd: > step
vshcmd: > cont
(0) Breakpoint 2, 0x0000000000009c29 in ?? ()
Next at t=21056934
(0) [0x000000009c29] 0860:0000000000001629 (unk. ctxt): jmpf 0x0010:0000bb1d      ; 66ea1dbb00001000
<bochs:128> 
vshcmd: > next
Next at t=21056955
(0) [0x000000100098] 0010:0000000000100098 (unk. ctxt): mov ds, ax                ; 8ed8
<bochs:153> 
vshcmd: > exit
(0).[21056955] [0x000000100098] 0010:0000000000100098 (unk. ctxt): mov ds, ax                ; 8ed8
bootloader [09:49:41] $ 
vshcmd: > disasm 0x100093 0x1000ff
00100093: (                    ): mov eax, 0x00000018       ; b818000000
00100098: (                    ): mov ds, ax                ; 8ed8
0010009a: (                    ): mov es, ax                ; 8ec0
0010009c: (                    ): mov fs, ax                ; 8ee0
0010009e: (                    ): mov gs, ax                ; 8ee8
001000a0: (                    ): mov ss, ax                ; 8ed0
001000a2: (                    ): lea esp, dword ptr ds:[esi+488] ; 8da6e8010000
001000a8: (                    ): call .+0                  ; e800000000
001000ad: (                    ): pop ebp                   ; 5d
001000ae: (                    ): sub ebp, 0x000000ad       ; 81edad000000
001000b4: (                    ): mov ebx, ebp              ; 89eb
001000b6: (                    ): mov eax, dword ptr ds:[esi+560] ; 8b8630020000
001000bc: (                    ): dec eax                   ; 48
001000bd: (                    ): add ebx, eax              ; 01c3
001000bf: (                    ): not eax                   ; f7d0
001000c1: (                    ): and ebx, eax              ; 21c3
001000c3: (                    ): cmp ebx, 0x01000000       ; 81fb00000001
001000c9: (                    ): jnl .+5                   ; 7d05
001000cb: (                    ): mov ebx, 0x01000000       ; bb00000001
001000d0: (                    ): add ebx, 0x00518000       ; 81c300805100
001000d6: (                    ): lea esp, dword ptr ds:[ebx+3078592] ; 8da3c0f92e00
001000dc: (                    ): push 0x00000000           ; 6a00
001000de: (                    ): popf                      ; 9d
001000df: (                    ): push esi                  ; 56
001000e0: (                    ): lea esi, dword ptr ss:[ebp+3008956] ; 8db5bce92d00
001000e6: (                    ): lea edi, dword ptr ds:[ebx+3008956] ; 8dbbbce92d00
001000ec: (                    ): mov ecx, 0x002de9c0       ; b9c0e92d00
001000f1: (                    ): shr ecx, 0x02             ; c1e902
001000f4: (                    ): std                       ; fd
001000f5: (                    ): rep movsd dword ptr es:[edi], dword ptr ds:[esi] ; f3a5
001000f7: (                    ): cld                       ; fc
001000f8: (                    ): pop esi                   ; 5e
001000f9: (                    ): lea eax, dword ptr ds:[ebx+2978616] ; 8d8338732d00
<bochs:152> 
vshcmd: > calc eax
0x100000 1048576
<bochs:143> 
vshcmd: > x /5bx 0x8600
[bochs]:
0x0000000000008600 <bogus+       0>:	0x4d	0x5a	0xea	0x07	0x00
<bochs:24> 
vshcmd: > cont
========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[1186856000] [0x0000017f03a9] 0010:00000000017f03a9 (unk. ctxt): cmp dword ptr ss:[esp+4], ebp ; 396c2404
bootloader [08:45:35] $ 
vshcmd: > exit
(0).[20640771] [0x000000007e1b] 0000:7e1b (unk. ctxt): xor ax, ax                ; 31c0
bootloader [08:37:35] $ 
vshcmd: > reg
CPU0:
rax: 00000000_000000fb rcx: 00000000_00000000
rdx: 00000000_00008600 rbx: 00000000_00000499
rsp: 00000000_0000c390 rbp: 00000000_0000c394
rsi: 00000000_00000268 rdi: 00000000_00004848
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_000015e4
eflags 0x00000006: id vip vif ac vm rf nt IOPL=0 of df if tf sf zf af PF cf
<bochs:119> 
vshcmd: > next
Next at t=21057333
(0) [0x000000009bec] 0860:15ec (unk. ctxt): mov dword ptr ds:0x4386, eax ; 66a38643
<bochs:120> 
vshcmd: > reg
CPU0:
rax: 00000000_0000be10 rcx: 00000000_00000000
rdx: 00000000_00008600 rbx: 00000000_00000499
rsp: 00000000_0000c390 rbp: 00000000_0000c394
rsi: 00000000_00000268 rdi: 00000000_00004848
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_000015ec
eflags 0x00000006: id vip vif ac vm rf nt IOPL=0 of df if tf sf zf af PF cf
<bochs:121> 
vshcmd: > calc edx + 14352
0xbe10 48656
<bochs:122> 
vshcmd: > next
Next at t=21057337
(0) [0x000000009c01] 0860:1601 (unk. ctxt): call .+0 (0x00009c07)     ; 66e800000000
<bochs:126> 
vshcmd: > step
Next at t=21057338
(0) [0x000000009c07] 0860:1607 (unk. ctxt): mov esi, edx              ; 6689d6
<bochs:127> 
vshcmd: > next
Next at t=21057364
(0) [0x000000100000] 0010:0000000000100000 (unk. ctxt): dec ebp                   ; 4d
<bochs:157> 
vshcmd: > sreg
es:0x0860, dh=0x00009300, dl=0x8600ffff, valid=7
	Data segment, base=0x00008600, limit=0x0000ffff, Read/Write, Accessed
cs:0x0010, dh=0x00cf9b00, dl=0x0000ffff, valid=1
	Code segment, base=0x00000000, limit=0xffffffff, Execute/Read, Non-Conforming, Accessed, 32-bit
ss:0x0860, dh=0x00009300, dl=0x8600ffff, valid=7
	Data segment, base=0x00008600, limit=0x0000ffff, Read/Write, Accessed
ds:0x0860, dh=0x00009300, dl=0x8600ffff, valid=7
	Data segment, base=0x00008600, limit=0x0000ffff, Read/Write, Accessed
fs:0x0000, dh=0x00009300, dl=0x0000ffff, valid=7
	Data segment, base=0x00000000, limit=0x0000ffff, Read/Write, Accessed
gs:0xffff, dh=0x0000930f, dl=0xfff0ffff, valid=3
	Data segment, base=0x000ffff0, limit=0x0000ffff, Read/Write, Accessed
ldtr:0x0000, dh=0x00008200, dl=0x0000ffff, valid=1
tr:0x0000, dh=0x00008b00, dl=0x0000ffff, valid=1
gdtr:base=0x000000000000be10, limit=0x27
idtr:base=0x0000000000000000, limit=0x0
<bochs:142> 
vshcmd: > reg
CPU0:
rax: 00000000_00100000 rcx: 00000000_00000018
rdx: 00000000_60000010 rbx: 00000000_00008600
rsp: 00000000_0000c38c rbp: 00000000_0000c394
rsi: 00000000_0000cbe0 rdi: 00000000_00000020
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_00001623
eflags 0x00000006: id vip vif ac vm rf nt IOPL=0 of df if tf sf zf af PF cf
<bochs:137> 
vshcmd: > exit
vshcmd: > disasm 0x9b7a 0x9bff
00009b7a: (                    ): push ebp                  ; 6655
00009b7c: (                    ): mov ebp, esp              ; 6689e5
00009b7f: (                    ): push ebx                  ; 6653
00009b81: (                    ): and esp, 0xfffffff8       ; 6683e4f8
00009b85: (                    ): cmp dword ptr ds:0x47e8, 0x00000000 ; 66833ee84700
00009b8b: (                    ): jz .+6                    ; 7406
00009b8d: (                    ): callf ds:0x47e8           ; ff1ee847
00009b91: (                    ): jmp .+7                   ; eb07
00009b93: (                    ): cli                       ; fa
00009b94: (                    ): mov al, 0x80              ; b080
00009b96: (                    ): out 0x70, al              ; e670
00009b98: (                    ): out 0x80, al              ; e680
00009b9a: (                    ): call .-4408               ; 66e8c8eeffff
00009ba0: (                    ): test eax, eax             ; 6685c0
00009ba3: (                    ): jz .+18                   ; 7412
00009ba5: (                    ): mov eax, 0x000037cb       ; 66b8cb370000
00009bab: (                    ): call .-4603               ; 66e805eeffff
00009bb1: (                    ): call .-4842               ; 66e816edffff
00009bb7: (                    ): xor eax, eax              ; 6631c0
00009bba: (                    ): out 0xf0, al              ; e6f0
00009bbc: (                    ): out 0x80, al              ; e680
00009bbe: (                    ): out 0xf1, al              ; e6f1
00009bc0: (                    ): out 0x80, al              ; e680
00009bc2: (                    ): mov al, 0xff              ; b0ff
00009bc4: (                    ): out 0xa1, al              ; e6a1
00009bc6: (                    ): out 0x80, al              ; e680
00009bc8: (                    ): mov al, 0xfb              ; b0fb
00009bca: (                    ): out 0x21, al              ; e621
00009bcc: (                    ): out 0x80, al              ; e680
00009bce: (                    ): lidt ds:0x3800            ; 660f011e0038
00009bd4: (                    ): mov word ptr ds:0x4384, 0x0027 ; c70684432700
00009bda: (                    ): mov dx, ds                ; 8cda
00009bdc: (                    ): movzx edx, dx             ; 660fb7d2
00009be0: (                    ): shl edx, 0x04             ; 66c1e204
00009be4: (                    ): lea eax, dword ptr ds:[edx+14352] ; 67668d8210380000
00009bec: (                    ): mov dword ptr ds:0x4386, eax ; 66a38643
00009bf0: (                    ): lgdt ds:0x4384            ; 660f01168443
00009bf6: (                    ): add edx, 0x000045e0       ; 6681c2e0450000
00009bfd: (                    ): mov eax, dword ptr ds:0x47f4 ; 66a1f447
<bochs:103> 
vshcmd: >
vshcmd: > calc ds << 4
0x8600 34304
<bochs:118> 
vshcmd: > x /1wx ds:0x4384
[bochs]:
0x000000000000c984 <bogus+       0>:	0x00000027
<bochs:116> 
vshcmd: > x /6bx ds:0x3800
[bochs]:
0x000000000000be00 <bogus+       0>:	0x00	0x00	0x00	0x00	0x00	0x00
<bochs:110> 
vshcmd: > x /50bx ds:0x378b
[bochs]:
0x55	0x6e	0x61	0x62	0x6c	0x65	0x20	0x74
0x6f	0x20	0x62	0x6f	0x6f	0x74	0x20	0x2d
0x20	0x70	0x6c	0x65	0x61	0x73	0x65	0x20
0x75	0x73	0x65	0x20	0x61	0x20	0x6b	0x65
0x72	0x6e	0x65	0x6c	0x20	0x61	0x70	0x70
0x72	0x6f	0x70	0x72	0x69	0x61	0x74	0x65
0x20	0x66
<bochs:38> 
vshcmd: > next
Next at t=20642006
(0) [0x00000000b991] 0860:3391 (unk. ctxt): mov ecx, 0x00000077       ; 66b977000000
<bochs:55> 
vshcmd: > x /119bx ds:si
[bochs]:
0x00000000000087f1 <bogus+       0>:	0x21	0x01	0x00	0x9d	0xde	0x02	0x00	0x00
0x00000000000087f9 <bogus+       8>:	0x00	0xff	0xff	0x00	0x00	0x55	0xaa	0xeb
0x0000000000008801 <bogus+      16>:	0x66	0x48	0x64	0x72	0x53	0x0d	0x02	0x00
0x0000000000008809 <bogus+      24>:	0x00	0x00	0x00	0x00	0x10	0x30	0x37	0xff
0x0000000000008811 <bogus+      32>:	0x81	0x00	0x80	0x00	0x00	0x10	0x00	0x00
0x0000000000008819 <bogus+      40>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x0000000000008821 <bogus+      48>:	0x00	0x00	0x00	0x00	0xc2	0x00	0x00	0x00
0x0000000000008829 <bogus+      56>:	0x4a	0x01	0x00	0xff	0xff	0xff	0x7f	0x00
0x0000000000008831 <bogus+      64>:	0x00	0x00	0x01	0x01	0x0d	0x04	0x00	0xff
0x0000000000008839 <bogus+      72>:	0x07	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x0000000000008841 <bogus+      80>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x01
0x0000000000008849 <bogus+      88>:	0x01	0x00	0x00	0x34	0x72	0x2d	0x00	0x00
0x0000000000008851 <bogus+      96>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x0000000000008859 <bogus+     104>:	0x00	0x00	0x01	0x00	0x00	0x00	0x00	0x00
0x0000000000008861 <bogus+     112>:	0x50	0x9f	0x00	0x44	0x00	0x00	0x00
<bochs:57> 
vshcmd: > next
Next at t=20642505
(0) [0x00000000ba38] 0860:3438 (unk. ctxt): call .-11479 (0x00008d67) ; 66e829d3ffff
<bochs:82> 
vshcmd: > exit
(0).[20642505] [0x00000000ba38] 0860:3438 (unk. ctxt): call .-11479 (0x00008d67) ; 66e829d3ffff
bootloader [19:14:29] $ 
vshcmd: > calc eax
0x0 0
<bochs:71> 
vshcmd: > x /9bx ds:0x3744
[bochs]:
0x000000000000bd44 <bogus+       0>:	0x64	0x65	0x62	0x75	0x67	0x00	0x57	0x41
0x000000000000bd4c <bogus+       8>:	0x52
<bochs:68> 
