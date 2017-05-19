vshcmd: > gcc -E boot.S > boot.asm
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
vshcmd: > qemu-system-x86_64 -drive file=boot,format=raw
bootloader [16:11:56] $ 
vshcmd: > sudo dd if=boot of=/dev/sdb
vshcmd: > sudo sync
bootloader [16:13:08] $ 
vshcmd: > xxd boot
00000000: ea05 7c00 00fa 31c0 8ed8 b8c0 8f8e d0bc  ..|...1.........
00000010: ffff fbe8 4d00 e814 00be 1e7d e81c 00eb  ....M......}....
00000020: fee8 1700 58a3 dc7c 50e8 1500 c3b8 0300  ....X..|P.......
00000030: cd10 fcc3 bb01 00b4 0ecd 10ac 3c00 75f4  ............<.u.
00000040: c3bf d57c a1dc 7cbe c57c b904 00c1 c004  ...|..|..|......
00000050: 89c3 83e3 0f8a 1888 1d47 e2f1 bed5 7ce8  .........G....|.
00000060: d9ff c388 16de 7cb4 00cd 1372 15b4 41bb  ......|....r..A.
00000070: aa55 cd13 721c 81fb 55aa 7516 83e1 0174  .U..r...U.u....t
00000080: 11c3 b000 a3dc 7ce8 b7ff bedf 7ce8 91ff  ......|.....|...
00000090: ebdb befd 7ce8 89ff ebfe 8a16 de7c be0e  ....|........|..
000000a0: 7db4 42cd 1373 06be f07c e874 ff84 e474  }.B..s...|.t...t
000000b0: 06be f07c e86a ff83 3e10 7d01 7406 bef0  ...|.j..>.}.t...
000000c0: 7ce8 5dff c330 3132 3334 3536 3738 3941  |.]..0123456789A
000000d0: 4243 4445 4600 0000 000a 0d00 0000 0064  BCDEF..........d
000000e0: 6973 6b2e 6173 6d20 7072 6f62 6c65 6d00  isk.asm problem.
000000f0: 6361 6e6e 6f74 2072 6561 6420 006e 6f20  cannot read .no 
00000100: 696e 7374 616c 6c65 6420 4c42 4120 1000  installed LBA ..
00000110: 0100 007e 0000 0100 0000 0000 0000 5941  ...~..........YA
00000120: 5900 0000 0000 0000 0000 0000 0000 0000  Y...............
00000130: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000140: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000150: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000160: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000170: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000180: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000190: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001a0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001b0: 0000 0000 0000 0000 beeb eefe 0000 8000  ................
000001c0: 0000 df00 0000 0008 0000 6400 0000 0000  ..........d.....
000001d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.
00000200: e800 00e8 4800 83f8 0175 08be ea7e e82a  ....H....u...~.*
00000210: feeb 3ab9 de7e 89ce 8b34 e81e fe83 c102  ..:..~...4......
00000220: 89ce 8b04 ffd0 83c1 02e8 2200 83f8 0174  .........."....t
00000230: 0ebe 907f e804 fe81 f9ea 7e77 0aeb d7be  ..........~w....
00000240: 727f e8f6 fdeb 06be a67f e8ee fdc3 9c1e  r...............
00000250: 0657 56fa 31c0 8ec0 f7d0 8ed8 bf00 05be  .WV.1...........
00000260: 1005 268a 0550 8a04 5026 c605 00c6 04ff  ..&..P..P&......
00000270: 2680 3dff 5888 0458 2688 05b8 0000 7403  &.=.X..X&.....t.
00000280: b801 005e 5f07 1f9d c351 b803 24cd 1572  ...^_....Q..$..r
00000290: 2e80 fc00 7529 b802 24cd 1572 1c80 fc00  ....u)..$..r....
000002a0: 7517 3a06 0100 740c b801 24cd 1572 0a80  u.:...t...$..r..
000002b0: fc00 7505 b801 00eb 09be c47e e87c fdb8  ..u........~.|..
000002c0: 0000 59c3 2e2e 2e20 736f 6d65 7468 696e  ..Y.... somethin
000002d0: 6720 7765 6e74 2077 726f 6e67 2000 fe7e  g went wrong ..~
000002e0: 897e 217f 897e 487f 897e 4132 3020 656e  .~!..~H..~A20 en
000002f0: 6162 6c65 6420 6f6e 2062 6f6f 7400 4174  abled on boot.At
00000300: 7465 6d70 7469 6e67 2074 6f20 7475 726e  tempting to turn
00000310: 206f 6e20 6132 3020 7669 6120 4249 4f53   on a20 via BIOS
00000320: 0041 7474 656d 7074 696e 6720 746f 2074  .Attempting to t
00000330: 7572 6e20 6f6e 2061 3230 2076 6961 206b  urn on a20 via k
00000340: 6579 626f 6172 6400 4174 7465 6d70 7469  eyboard.Attempti
00000350: 6e67 2074 6f20 7475 726e 206f 6e20 6132  ng to turn on a2
00000360: 3020 7669 6120 6661 7374 206d 6574 686f  0 via fast metho
00000370: 6400 2e2e 2e20 2077 6f72 6b65 6421 0d0a  d....  worked!..
00000380: 4132 3020 6973 2065 6e61 626c 6564 2100  A20 is enabled!.
00000390: 2e2e 2e20 2064 6964 6e27 7420 776f 726b  ...  didn't work
000003a0: 202e 2e0d 0a00 4132 3020 6973 2064 6973   .....A20 is dis
000003b0: 6162 6c65 6421 2100                      abled!!.
bootloader [12:48:09] $ 
vshcmd: > # Create a hard-drive image using the bximage tool.
vshcmd: > bximage
vshcmd: > 1
vshcmd: > hd
vshcmd: > flat
vshcmd: > 10
vshcmd: > bxcreated.img
========================================================================
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
The disk image 'bxcreated.img' already exists.  Are you sure you want to replace it?

Creating hard disk image 'bxcreated.img' with CHS=20/16/63

The following line should appear in your bochsrc:
  ata0-master: type=disk, path="bxcreated.img", mode=flat
bootloader [12:19:18] $ 
vshcmd: > # Assemble and link readbios.
vshcmd: > dd if=/dev/zero of=bootloaderspace bs=512 count=2046
vshcmd: > dd if=boot of=bxcreated.img conv=notrunc
2046+0 records in
2046+0 records out
1047552 bytes (1.0 MB, 1023 KiB) copied, 0.0103267 s, 101 MB/s
bootloader [12:47:45] $ 1+1 records in
1+1 records out
952 bytes copied, 0.000235993 s, 4.0 MB/s
bootloader [12:47:45] $ 
vshcmd: > qemu-system-x86_64 -drive file=bxcreated.img,format=raw
bootloader [12:16:07] $ bootloader [12:16:07] $ bootloader [12:16:07] $ 2046+0 records in
2046+0 records out
1047552 bytes (1.0 MB, 1023 KiB) copied, 0.01061 s, 98.7 MB/s
bootloader [12:16:07] $ bootloader [12:16:08] $ 11755+1 records in
11755+1 records out
6018832 bytes (6.0 MB, 5.7 MiB) copied, 0.0379054 s, 159 MB/s
bootloader [12:16:08] $ bootloader [12:16:12] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > break 0x7c00
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
<bochs:1> ========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[119116000] [0x000000007c1f] 0000:7c1f (unk. ctxt): jmp .-2 (0x00007c1f)      ; ebfe
bootloader [12:47:56] $ 
vshcmd: > next
Next at t=17463682
(0) [0x000000007c19] 0000:7c19 (unk. ctxt): mov si, 0x7e59            ; be597e
<bochs:13> 
vshcmd: > x /3xb 0x7e59
[bochs]:
0x0000000000007e59 <bogus+       0>:	0x00	0x00	0x00
<bochs:14> 
vshcmd: > sudo dd if=bxcreated.img of=/dev/sdb bs=10M
vshcmd: > sync
bootloader [14:03:41] $ 
