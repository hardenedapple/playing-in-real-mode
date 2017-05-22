vshcmd: > # Used the following to create totalUSB.img, in the fututre, use
vshcmd: > # dd to reset the boot partition, and to install my changes.
vshcmd: > # vshcmd: > cp otherBIOSes/full_debian_install.img ./totalUSB.img
vshcmd: > gcc -E boot.S > boot.asm
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
bootloader [12:43:51] $ bootloader [12:43:51] $ bootloader [12:43:51] $ 
vshcmd: > dd if=boot of=totalUSB.img conv=notrunc
3+0 records in
3+0 records out
1536 bytes (1.5 kB, 1.5 KiB) copied, 0.000147855 s, 10.4 MB/s
bootloader [12:43:56] $ 
vshcmd: > dd if=otherBIOSes/debian_GRUB.img of=totalUSB.img conv=notrunc
2048+0 records in
2048+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.128804 s, 8.1 MB/s
bootloader [11:55:17] $ 
vshcmd: > qemu-system-x86_64 -drive file=totalUSB.img,format=raw
bootloader [12:44:01] $ 
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
