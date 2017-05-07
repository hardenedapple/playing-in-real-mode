vshcmd: > # Run suggestions given in
vshcmd: > # http://stackoverflow.com/questions/27679693/unsupported-x86-64-instruction-set-error-when-compiling-c-file
vshcmd: > # The file compiles fine, but instead of printing "Hello, World", it prints
vshcmd: > # "S" (see the output on the screen after `make run`).
vshcmd: > # With .code16gcc
vshcmd: > make floppy

vshcmd: > as test.S -o test.o
vshcmd: > ld -Ttext 0x7c00 -o test test.o
vshcmd: > file test

    
vshcmd: > # Saved commands (just storing some oft-used commands out of the way
vshcmd: > # so I can use C-x C-l to get at them)
vshcmd: > objdump -D -b binary -mi386 -Maddr16,data16 test.bin
vshcmd: > objdump -M data16,addr16 -d test.elf
vshcmd: > dd if=test.bin of=floppy.img conv=notrunc
vshcmd: > # n.b. the linker manual is a little confusing ...
vshcmd: > # -T is one option, but -Ttext is another  -- search for -Ttext to
vshcmd: > # see what's happening here.
vshcmd: > ld -Ttext 0x7c00 -o test2 test.o
vshcmd: > ld -nostdlib --section-start=mytext=0x7c00 -o test test.o
vshcmd: > ld -melf_i386 -static -Ttest.ld -nostdlib --nmagic -o test.elf test.o
vshcmd: > set architecture i8086
vshcmd: > gcc -c -Os -m16 -march=i386 -ffreestanding -Wall -Werror test.c -o testgcc.o
vshcmd: > objcopy -O binary testgcc.elf test-cgcc.bin
vshcmd: > # To be used in another terminal (it doesn't return)
vshcmd: > qemu-system-x86_64 -s -S -enable-kvm -drive file=floppy.img,index=0,if=floppy,format=raw -boot order=a &
vshcmd: > qemu-system-x86_64 -enable-kvm -drive file=challenge_binary,index=0,if=floppy,format=raw -boot order=a &
[1] 3714
bootloader [16:06:45] $ qemu-system-x86_64: -drive file=challenge_binary,index=0,if=floppy,format=raw: Could not open 'challenge_binary': No such file or directory

vshcmd: >
[1]+  Exit 1                  qemu-system-x86_64 -enable-kvm -drive file=challenge_binary,index=0,if=floppy,format=raw -boot order=a
bootloader [16:07:02] $ 
