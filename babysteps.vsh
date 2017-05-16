vshcmd: > gcc -E boot.S > boot.asm
bootloader [14:03:09] $ 
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
bootloader [11:39:41] $ bootloader [11:39:41] $ bootloader [11:39:41] $ 

vshcmd: > # View the disassembly with symbols.
vshcmd: > ld -Ttext 0x7c00 readbios.o -o tmp
vshcmd: > objdump -D -Mdata16,addr16 tmp
vshcmd: > rm tmp

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
vshcmd: > as readbios.s -o readbios.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 readbios.o -o readbios
vshcmd: > ld --oformat=binary -Ttext 0x7e00 readbios.o -o secondpart
vshcmd: > dd if=/dev/zero of=bootloaderspace bs=512 count=2046
vshcmd: > cat readbios secondpart bootloaderspace vmlinuz-linux > totalimage
vshcmd: > dd if=totalimage of=bxcreated.img conv=notrunc
vshcmd: > qemu-system-x86_64 -drive file=bxcreated.img,format=raw
bootloader [14:03:10] $ bootloader [14:03:10] $ bootloader [14:03:10] $ 2046+0 records in
2046+0 records out
1047552 bytes (1.0 MB, 1023 KiB) copied, 0.0131046 s, 79.9 MB/s
bootloader [14:03:10] $ bootloader [14:03:11] $ 11755+1 records in
11755+1 records out
6018832 bytes (6.0 MB, 5.7 MiB) copied, 0.0387163 s, 155 MB/s
bootloader [14:03:11] $ bootloader [14:03:12] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > # break 0x7c00
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
(0).[146212000] [0x0000000fe869] f000:e869 (unk. ctxt): cli                       ; fa
bootloader [13:56:03] $ 
vshcmd: > sudo dd if=bxcreated.img of=/dev/sdb bs=10M
vshcmd: > sync
bootloader [14:03:41] $ 
