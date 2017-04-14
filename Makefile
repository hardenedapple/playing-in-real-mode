floppy: test.S
	as test.S -o test.o
	ld -Ttext 0x7c00 --oformat=binary test.o -o test.bin
	dd if=test.bin of=floppy.img conv=notrunc

via_c: test.ld test.c
	gcc -c -Os -m16 -march=i386 -ffreestanding -Wall -Werror test.c -o test.o
	ld -melf_i386 -static -Ttest.ld -nostdlib --nmagic -o test.elf test.o
	objcopy -O binary test.elf test-c.bin
	dd if=test-c.bin of=floppy.img conv=notrunc

qemurun:
	qemu-system-x86_64 -enable-kvm -drive file=floppy.img,index=0,if=floppy,format=raw -boot order=a

# N.B. I don't know why bochs -q seems to break
#
#
# bootloader [18:21:14] % bochs                                                                                                                                                                                                                                                                      [git][master] U [148,1052]
# ========================================================================
# 					   Bochs x86 Emulator 2.6.8
# 				Built from SVN snapshot on May 3, 2015
# 				  Compiled on Nov  7 2016 at 17:36:50
# ========================================================================
# 00000000000i[      ] BXSHARE not set. using compile time default '/usr/share/bochs'
# 00000000000i[      ] reading configuration from bochsrc.txt
# ------------------------------
# Bochs Configuration: Main Menu
# ------------------------------
#
# This is the Bochs Configuration Interface, where you can describe the
# machine that you want to simulate.  Bochs has already searched for a
# configuration file (typically called bochsrc.txt) and loaded it if it
# could be found.  When you are satisfied with the configuration, go
# ahead and start the simulation.
#
# You can also start bochs with the -q option to skip these menus.
#
# 1. Restore factory default configuration
# 2. Read options from...
# 3. Edit options
# 4. Save options to...
# 5. Restore the Bochs state from...
# 6. Begin simulation
# 7. Quit now
#
# Please choose one: [6]
# 00000000000i[      ] installing x module as the Bochs GUI
# 00000000000i[      ] using log file bochsout.txt
# Next at t=0
# (0) [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
# <bochs:1> cont
# t========================================================================
# Bochs is exiting with the following message:
# [XGUI  ] POWER button turned off.
# ========================================================================
# (0).[261572000] [0x0000000c7d75] c000:7d75 (unk. ctxt): cmp al, byte ptr ss:[bp+4] ; 3a4604
# bootloader [18:21:30] % bochs -q                                                                                                                                                                                                                                                                     [git][master] U [1,1053]
# ========================================================================
# 					   Bochs x86 Emulator 2.6.8
# 				Built from SVN snapshot on May 3, 2015
# 				  Compiled on Nov  7 2016 at 17:36:50
# ========================================================================
# 00000000000i[      ] BXSHARE not set. using compile time default '/usr/share/bochs'
# 00000000000i[      ] reading configuration from bochsrc.txt
# 00000000000i[      ] installing x module as the Bochs GUI
# 00000000000i[      ] using log file bochsout.txt
# Next at t=0
# (0) [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
# <bochs:1> fgets() returned ERROR.
# debugger interrupt request was 0
# (0).[0] [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
#
#
# It doesn't really matter why (though I would very much like to know), what
# matters is that it doesn't work, so I can't use it.
bochsrun:
	bochs

vboxrun:
	VBoxManage startvm own_os

clean:
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	+rm test-c.bin test.o test.bin
