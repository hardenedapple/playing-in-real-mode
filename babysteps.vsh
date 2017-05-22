vshcmd: > gcc -E boot.S > boot.asm
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot

vshcmd: > # Used the following to create totalUSB.img, in the fututre, use
vshcmd: > # dd to reset the boot partition, and to install my changes.
vshcmd: > # vshcmd: > cp otherBIOSes/full_debian_install.img ./totalUSB.img
bootloader [11:44:31] $ 
vshcmd: > dd if=boot of=total
vshcmd: > qemu-system-x86_64 -drive file=boot,format=raw
bootloader [10:05:53] $ bootloader [10:05:53] $ bootloader [10:05:53] $ bootloader [10:05:58] $ 
vshcmd: > # Create a hard-drive image using the bximage tool.
vshcmd: > rm bxcreated.img
vshcmd: > bximage
vshcmd: > 1
vshcmd: > hd
vshcmd: > flat
vshcmd: > 10
vshcmd: > bxcreated.img
bootloader [17:14:45] $ ========================================================================
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
Creating hard disk image 'bxcreated.img' with CHS=20/16/63

The following line should appear in your bochsrc:
  ata0-master: type=disk, path="bxcreated.img", mode=flat
bootloader [17:14:45] $ 
vshcmd: > dd if=boot of=bxcreated.img conv=notrunc
2+1 records in
2+1 records out
1191 bytes (1.2 kB, 1.2 KiB) copied, 0.00021588 s, 5.5 MB/s
bootloader [17:59:37] $ 
vshcmd: > qemu-system-x86_64 -drive file=bxcreated.img,format=raw
bootloader [17:15:06] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > # vshcmd: > break 0x7e00
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
