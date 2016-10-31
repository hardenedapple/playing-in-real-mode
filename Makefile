floppy: test.S
	as test.S -o test.o
	ld -Ttext 0x7c00 --oformat=binary test.o -o test.bin
	dd if=test.bin of=floppy.img conv=notrunc

run: floppy
	qemu-system-x86_64 -enable-kvm -drive file=floppy.img,index=0,if=floppy,format=raw -boot order=a
