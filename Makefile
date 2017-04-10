floppy: test.S
	as test.S -o test.o
	ld -Ttext 0x7c00 --oformat=binary test.o -o test.bin
	dd if=test.bin of=floppy.img conv=notrunc

via_c: test.ld test.c
	gcc -c -g -Os -ffreestanding -Wall -Werror test.c -o test.o
	ld -static -Ttest.ld -nostdlib --nmagic -o test.elf test.o
	objcopy -O binary test.elf test-c.bin
	dd if=test-c.bin of=floppy.img conv=notrunc

run:
	qemu-system-x86_64 -enable-kvm -drive file=floppy.img,index=0,if=floppy,format=raw -boot order=a

clean:
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	+rm test-c.bin test.o test.bin
