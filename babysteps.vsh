vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
vshcmd: > diff <(xxd nasmboot.bin) <(xxd boot)
7c7
< 00000060: 0066 678b 0666 678d 7601 3c00 75f0 8006  .fg..fg.v.<.u...
---
> 00000060: 0067 668b 0667 668d 7601 3c00 75f0 8006  .gf..gf.v.<.u...
bootloader [14:59:17] $ 
vshcmd: > nasm nasmboot.asm -f bin -o nasmboot.bin
bootloader [15:31:51] $ 
vshcmd: > qemu-system-x86_64 -enable-kvm -drive file=nasmboot.bin,format=raw
bootloader [13:20:55] $ 
vshcmd: > qemu-system-x86_64 -enable-kvm -drive file=boot,format=raw
bootloader [12:55:33] $ 
vshcmd: > bochs 'floppya: 1_44=nasmboot.bin, status=inserted'
========================================================================
                       Bochs x86 Emulator 2.6.9
               Built from SVN snapshot on April 9, 2017
                  Compiled on Apr 21 2017 at 23:41:40
========================================================================
00000000000i[      ] BXSHARE not set. using compile time default '/usr/share/bochs'
00000000000i[      ] reading configuration from bochsrc.txt
00000000000i[      ] parsing arg 1, floppya: 1_44=nasmboot.bin, status=inserted
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

Please choose one: [6] 
vshcmd: > 6
00000000000i[      ] installing x module as the Bochs GUI
00000000000i[      ] using log file bochsout.txt
Next at t=0
(0) [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
<bochs:1> 
vshcmd: > break 0x7c00
<bochs:2> 
vshcmd: > cont
(0) Breakpoint 1, 0x0000000000007c00 in ?? ()
Next at t=14040244
(0) [0x000000007c00] 0000:7c00 (unk. ctxt): jmp .+230 (0x00007ce9)    ; e9e600
<bochs:3> 
vshcmd: > step
Next at t=14040246
(0) [0x000000007cec] 0000:7cec (unk. ctxt): int 0x10                  ; cd10
<bochs:5> 
vshcmd: > disasm 0x7cec 0x7cef
00007cec: (                    ): int 0x10                  ; cd10
00007cee: (                    ): cld                       ; fc
<bochs:8> 
vshcmd: > break 0x7cee
<bochs:9> 
vshcmd: > cont
(0) Breakpoint 2, 0x0000000000007cee in ?? ()
Next at t=14098351
(0) [0x000000007cee] 0000:7cee (unk. ctxt): cld                       ; fc
<bochs:10> 
vshcmd: > next
Next at t=14098364
(0) [0x000000007d0c] 0000:0000000000007d0c (unk. ctxt): mov bx, 0x0008            ; bb0800
<bochs:26> 
vshcmd: > exit
(0).[14098364] [0x000000007d0c] 0000:0000000000007d0c (unk. ctxt): mov bx, 0x0008            ; bb0800
bootloader [13:41:57] $ 
vshcmd: > regs
CPU0:
rax: 00000000_60000011 rcx: 00000000_00090000
rdx: 00000000_00000000 rbx: 00000000_00000000
rsp: 00000000_00009bfe rbp: 00000000_00000000
rsi: 00000000_000e0000 rdi: 00000000_0000ffac
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_00007d0c
eflags 0x00000006: id vip vif ac vm rf nt IOPL=0 of df if tf sf zf af PF cf
<bochs:29> 
vshcmd: > creg
CR0=0x60000011: pg CD NW ac wp ne ET ts em mp PE
CR2=page fault laddr=0x0000000000000000
CR3=0x000000000000
    PCD=page-level cache disable=0
    PWT=page-level write-through=0
CR4=0x00000000: pke smap smep osxsave pcid fsgsbase smx vmx osxmmexcpt umip osfxsr pce pge mce pae pse de tsd pvi vme
CR8: 0x0
EFER=0x00000000: ffxsr nxe lma lme sce
<bochs:27> 
vshcmd: > disasm 0x000000007ce9 0x000000007d50
00007ce9: (                    ): mov ax, 0x0003            ; b80300
00007cec: (                    ): int 0x10                  ; cd10
00007cee: (                    ): cld                       ; fc
00007cef: (                    ): xor ax, ax                ; 31c0
00007cf1: (                    ): mov ds, ax                ; 8ed8
00007cf3: (                    ): mov ss, ax                ; 8ed0
00007cf5: (                    ): mov sp, 0x9c00            ; bc009c
00007cf8: (                    ): mov ax, 0xb800            ; b800b8
00007cfb: (                    ): mov es, ax                ; 8ec0
00007cfd: (                    ): cli                       ; fa
00007cfe: (                    ): push ds                   ; 1e
00007cff: (                    ): lgdt ds:0x7d5d            ; 0f01165d7d
00007d04: (                    ): mov eax, cr0              ; 0f20c0
00007d07: (                    ): or al, 0x01               ; 0c01
00007d09: (                    ): mov cr0, eax              ; 0f22c0
00007d0c: (                    ): mov bx, 0x0008            ; bb0800
00007d0f: (                    ): mov ds, bx                ; 8edb
00007d11: (                    ): xor ecx, ecx              ; 6631c9
00007d14: (                    ): mov cx, word ptr ds:0x7ce6 ; 8b0ee67c
00007d18: (                    ): mov dword ptr ds:0x7d52, ecx ; 66890e527d
00007d1d: (                    ): call .-114                ; e88eff
00007d20: (                    ): xor ecx, ecx              ; 6631c9
00007d23: (                    ): mov cx, word ptr ds:0x7ce6 ; 8b0ee67c
00007d27: (                    ): and al, 0xfe              ; 24fe
00007d29: (                    ): mov cr0, eax              ; 0f22c0
00007d2c: (                    ): pop ds                    ; 1f
00007d2d: (                    ): sti                       ; fb
00007d2e: (                    ): mov word ptr ds:0x7d5b, cx ; 890e5b7d
00007d32: (                    ): call .-250                ; e806ff
00007d35: (                    ): jmp .-2                   ; ebfe
00007d37: (                    ): add byte ptr ds:[bx+si], al ; 0000
00007d39: (                    ): xor byte ptr ds:[bx+di], dh ; 3031
00007d3b: (                    ): xor dh, byte ptr ss:[bp+di] ; 3233
00007d3d: (                    ): xor al, 0x35              ; 3435
00007d3f: (                    ): aaa                       ; 3637
00007d41: (                    ): cmp byte ptr ds:[bx+di], bh ; 3839
00007d43: (                    ): inc cx                    ; 41
00007d44: (                    ): inc dx                    ; 42
00007d45: (                    ): inc bx                    ; 43
00007d46: (                    ): inc sp                    ; 44
00007d47: (                    ): inc bp                    ; 45
00007d48: (                    ): inc si                    ; 46
00007d49: (                    ): xor byte ptr ds:[bx+si], dh ; 3030
00007d4b: (                    ): xor byte ptr ds:[bx+si], dh ; 3030
00007d4d: (                    ): xor byte ptr ds:[bx+si], dh ; 3030
00007d4f: (                    ): xor byte ptr ds:[bx+si], dh ; 3030
<bochs:11> 
vshcmd: > disasm 0x7c00 0x7d00
00007c00: (                    ): jmp .+230                 ; e9e600
00007c03: (                    ): call .+16                 ; e81000
00007c06: (                    ): lodsb al, byte ptr ds:[si] ; ac
00007c07: (                    ): cmp al, 0x00              ; 3c00
00007c09: (                    ): jnz .-8                   ; 75f8
00007c0b: (                    ): add byte ptr ds:0x7d38, 0x01 ; 8006387d01
00007c10: (                    ): mov byte ptr ds:0x7d37, 0x00 ; c606377d00
00007c15: (                    ): ret                       ; c3
00007c16: (                    ): mov ah, 0x0f              ; b40f
00007c18: (                    ): mov cx, ax                ; 89c1
00007c1a: (                    ): movzx ax, byte ptr ds:0x7d38 ; 0fb606387d
00007c1f: (                    ): mov dx, 0x00a0            ; baa000
00007c22: (                    ): mul ax, dx                ; f7e2
00007c24: (                    ): movzx bx, byte ptr ds:0x7d37 ; 0fb61e377d
00007c29: (                    ): shl bx, 1                 ; d1e3
00007c2b: (                    ): mov di, 0x0000            ; bf0000
00007c2e: (                    ): add di, ax                ; 01c7
00007c30: (                    ): add di, bx                ; 01df
00007c32: (                    ): mov ax, cx                ; 89c8
00007c34: (                    ): stosw word ptr es:[di], ax ; ab
00007c35: (                    ): add byte ptr ds:0x7d37, 0x01 ; 8006377d01
00007c3a: (                    ): ret                       ; c3
00007c3b: (                    ): mov di, 0x7d56            ; bf567d
00007c3e: (                    ): mov ax, word ptr ds:0x7d5b ; a15b7d
00007c41: (                    ): mov si, 0x7d39            ; be397d
00007c44: (                    ): mov cx, 0x0004            ; b90400
00007c47: (                    ): rol ax, 0x04              ; c1c004
00007c4a: (                    ): mov bx, ax                ; 89c3
00007c4c: (                    ): and bx, 0x000f            ; 83e30f
00007c4f: (                    ): mov bl, byte ptr ds:[bx+si] ; 8a18
00007c51: (                    ): mov byte ptr ds:[di], bl  ; 881d
00007c53: (                    ): inc di                    ; 47
00007c54: (                    ): dec cx                    ; 49
00007c55: (                    ): jnz .-16                  ; 75f0
00007c57: (                    ): mov si, 0x7d56            ; be567d
00007c5a: (                    ): call .-87                 ; e8a9ff
00007c5d: (                    ): ret                       ; c3
00007c5e: (                    ): call .+24                 ; e81800
00007c61: (                    ): mov eax, dword ptr ds:[esi] ; 66678b06
00007c65: (                    ): lea esi, dword ptr ds:[esi+1] ; 66678d7601
00007c6a: (                    ): cmp al, 0x00              ; 3c00
00007c6c: (                    ): jnz .-16                  ; 75f0
00007c6e: (                    ): add byte ptr ds:0x7d38, 0x01 ; 8006387d01
00007c73: (                    ): mov byte ptr ds:0x7d37, 0x00 ; c606377d00
00007c78: (                    ): ret                       ; c3
00007c79: (                    ): mov ah, 0x0f              ; b40f
00007c7b: (                    ): mov ecx, eax              ; 6689c1
00007c7e: (                    ): movzx eax, byte ptr ds:0x7d38 ; 660fb606387d
00007c84: (                    ): mov edx, 0x000000a0       ; 66baa0000000
00007c8a: (                    ): mul eax, edx              ; 66f7e2
00007c8d: (                    ): movzx ebx, byte ptr ds:0x7d37 ; 660fb61e377d
00007c93: (                    ): shl ebx, 1                ; 66d1e3
00007c96: (                    ): mov edi, 0x000b8000       ; 66bf00800b00
00007c9c: (                    ): add edi, eax              ; 6601c7
00007c9f: (                    ): add edi, ebx              ; 6601df
00007ca2: (                    ): mov eax, ecx              ; 6689c8
00007ca5: (                    ): mov word ptr ds:[edi], ax ; 678907
00007ca8: (                    ): add byte ptr ds:0x7d37, 0x01 ; 8006377d01
00007cad: (                    ): ret                       ; c3
00007cae: (                    ): mov edi, 0x00007d49       ; 66bf497d0000
00007cb4: (                    ): mov eax, dword ptr ds:0x7d52 ; 66a1527d
00007cb8: (                    ): mov esi, 0x00007d39       ; 66be397d0000
00007cbe: (                    ): mov ecx, 0x00000008       ; 66b908000000
00007cc4: (                    ): rol eax, 0x04             ; 66c1c004
00007cc8: (                    ): mov ebx, eax              ; 6689c3
00007ccb: (                    ): and ebx, 0x0000000f       ; 6683e30f
00007ccf: (                    ): mov bl, byte ptr ds:[esi+ebx] ; 678a1c1e
00007cd3: (                    ): mov byte ptr ds:[edi], bl ; 67881f
00007cd6: (                    ): inc edi                   ; 6647
00007cd8: (                    ): dec ecx                   ; 6649
00007cda: (                    ): jnz .-24                  ; 75e8
00007cdc: (                    ): mov esi, 0x00007d49       ; 66be497d0000
00007ce2: (                    ): call .-132                ; e87cff
00007ce5: (                    ): ret                       ; c3
00007ce6: (                    ): adc byte ptr ds:[bx+si], al ; 1000
00007ce8: (                    ): add byte ptr ds:[bx+si+3], bh ; 00b80300
00007cec: (                    ): int 0x10                  ; cd10
00007cee: (                    ): cld                       ; fc
00007cef: (                    ): xor ax, ax                ; 31c0
00007cf1: (                    ): mov ds, ax                ; 8ed8
00007cf3: (                    ): mov ss, ax                ; 8ed0
00007cf5: (                    ): mov sp, 0x9c00            ; bc009c
00007cf8: (                    ): mov ax, 0xb800            ; b800b8
00007cfb: (                    ): mov es, ax                ; 8ec0
00007cfd: (                    ): cli                       ; fa
00007cfe: (                    ): push ds                   ; 1e
00007cff: (                    ): lgdt ds:0x7d5d            ; 0f01165d7d
<bochs:12> 
vshcmd: > exit
(0).[14040242] [0x000000007ce9] 0000:7ce9 (unk. ctxt): mov ax, 0x0003            ; b80300
bootloader [13:11:45] $ 
vshcmd: > # Where the call in the main program goes to 0x7d47 - 149 = 0x7cb2
vshcmd: > break 0x00007d15
<bochs:18> 
vshcmd: > cont
(0) Breakpoint 2, 0x0000000000007d15 in ?? ()
Next at t=14098351
(0) [0x000000007d15] 0000:7d15 (unk. ctxt): cld                       ; fc
<bochs:19> 
vshcmd: > step
Next at t=14098366
(0) [0x000000007d38] 0000:0000000000007d38 (unk. ctxt): mov cx, word ptr ds:0x7c03 ; 8b0e037c
<bochs:34> 
vshcmd: > quit
(0).[14098371] [0x000000007cb8] 0000:0000000000007cb8 (unk. ctxt): mov eax, dword ptr ds:0x7d05 ; 66a1057d
bootloader [18:44:00] $ 
