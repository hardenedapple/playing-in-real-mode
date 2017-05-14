vshcmd: > gcc -E boot.S > boot.asm
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
bootloader [11:39:41] $ bootloader [11:39:41] $ bootloader [11:39:41] $ 

vshcmd: > 
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
Creating hard disk image 'bxcreated.img' with CHS=20/16/63

The following line should appear in your bochsrc:
  ata0-master: type=disk, path="bxcreated.img", mode=flat
bootloader [19:43:17] $ 
vshcmd: > as readbios.s -o readbios.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 readbios.o -o readbios
vshcmd: > qemu-system-x86_64 -drive file=readbios,format=raw
bootloader [19:53:59] $ bootloader [19:53:59] $ bootloader [19:54:01] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > dd if=readbios of=bxcreated.img bs=512 count=3 conv=notrunc
3+0 records in
3+0 records out
1536 bytes (1.5 kB, 1.5 KiB) copied, 0.000195416 s, 7.9 MB/s
bootloader [19:54:02] $ 
vshcmd: > fdisk -l bxcreated.img
[1mDisk bxcreated.img: 9.9 MiB, 10321920 bytes, 20160 sectors
[0mUnits: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000
bootloader [19:54:03] $ 
vshcmd: > # Write the below into bochsrc.txt vimcmd: +1;/vshcmd/-1 w !cat > bochsrc.txt
megs: 32
#romimage: file=/usr/share/bochs/BIOS-bochs-latest, address=0xf0000
#vgaromimage: /usr/share/bochs/VGABIOS-elpin-2.40
boot: disk
ata0-master: type=disk, path=bxcreated.img, mode=flat, cylinders=20, heads=16, spt=63
log: bochsout.txt
mouse: enabled=0
vshcmd: > bochs
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

Please choose one: [6] 
vshcmd: > 6
00000000000i[      ] installing x module as the Bochs GUI
00000000000i[      ] using log file bochsout.txt
========================================================================
Bochs is exiting with the following message:
[HD    ] ata0-0: specified geometry doesn't fit on disk image
========================================================================
(0).[0] [0x000000000000] 0000:0000 (unk. ctxt): add byte ptr ds:[bx+si], al ; 0000
bootloader [19:55:22] $ 
vshcmd: > cont
========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[119416000] [0x000000007cde] 0000:7cde (unk. ctxt): jmp .-2 (0x00007cde)      ; ebfe
bootloader [19:54:12] $ 
vshcmd: > rm bxcreated.img.lock
bootloader [19:50:51] $ 
vshcmd: > cont
(0) Breakpoint 1, 0x0000000000007c00 in ?? ()
Next at t=17404825
(0) [0x000000007c00] 0000:7c00 (unk. ctxt): jmp .+202 (0x00007ccd)    ; e9ca00
<bochs:3> 
vshcmd: > next
Next at t=17404836
(0) [0x000000007c4c] 0000:7c4c (unk. ctxt): cmp al, 0x00              ; 3c00
<bochs:14> 
vshcmd: > step
Next at t=17404833
(0) [0x000000007c48] 0000:7c48 (unk. ctxt): mov ah, 0x0e              ; b40e
<bochs:11> 
vshcmd: >
vshcmd: >
vshcmd: > mv readbios workingbios
bootloader [16:07:14] $ 
vshcmd: > as readbios.s -o readbios.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 readbios.o -o readbios
vshcmd: > echo && fdisk -l readbios
bootloader [18:09:16] $ bootloader [18:09:16] $ 
[1mDisk readbios: 4 KiB, 4096 bytes, 8 sectors
[0mUnits: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xfeeeebbe

[1mDevice[0m     [1mBoot[0m [1mStart[0m [1mEnd[0m [1mSectors[0m [1m Size[0m [1mId[0m [1mType[0m
readbios1  *        1   7       7  3.5K ee GPT
bootloader [18:09:16] $ 
vshcmd: > fdisk -l os.iso
[1mDisk os.iso: 19.4 MiB, 20338688 bytes, 39724 sectors
[0mUnits: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: AE06F349-3633-4BFF-8E6A-3C1EF23C9997

[1mDevice[0m     [1mStart[0m [1m  End[0m [1mSectors[0m [1m Size[0m [1mType[0m
os.iso1       64   355     292  146K Microsoft basic data
os.iso2      356  6115    5760  2.8M EFI System
os.iso3     6116 39075   32960 16.1M Apple HFS/HFS+
os.iso4    39076 39675     600  300K Microsoft basic data
bootloader [18:32:17] $ 
vshcmd: > dd if=os.iso of=temp.img bs=512 count=20
20+0 records in
20+0 records out
10240 bytes (10 kB, 10 KiB) copied, 0.000407524 s, 25.1 MB/s
bootloader [18:32:19] $ 
vshcmd: > fdisk -l temp.img
[31mGPT PMBR size mismatch (39723 != 19) will be corrected by w(rite).[0m
[1mDisk temp.img: 10 KiB, 10240 bytes, 20 sectors
[0mUnits: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

[1mDevice[0m     [1mBoot[0m [1mStart[0m [1m  End[0m [1mSectors[0m [1m Size[0m [1mId[0m [1mType[0m
temp.img1           1 39723   39723 19.4M ee GPT
bootloader [18:32:21] $ 
vshcmd: > fdisk readbios
[32m
Welcome to fdisk (util-linux 2.29.2).
[0mChanges will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): 
vshcmd: > m

Help:
[1m
  DOS (MBR)
[0m   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag
[1m
  Generic
[0m   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition
[1m
  Misc
[0m   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)
[1m
  Script
[0m   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file
[1m
  Save & Exit
[0m   w   write table to disk and exit
   q   quit without saving changes
[1m
  Create a new label
[0m   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table


Command (m for help): 
vshcmd: > l

 0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris        
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden or  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx         
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data    
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility   
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi ea  Rufus alignment
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         eb  BeOS fs        
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ee  GPT            
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        ef  EFI (FAT-12/16/
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f0  Linux/PA-RISC b
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f1  SpeedStor      
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f4  SpeedStor      
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      f2  DOS secondary  
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fb  VMware VMFS    
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fc  VMware VMKCORE 
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fd  Linux raid auto
1c  Hidden W95 FAT3 75  PC/IX           bc  Acronis FAT32 L fe  LANstep        
1e  Hidden W95 FAT1 80  Old Minix       be  Solaris boot    ff  BBT            

Command (m for help): 
vshcmd: > q

bootloader [17:27:51] $ 
