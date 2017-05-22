vshcmd: > sudo losetup -P /dev/loop0 totalUSB.img
bootloader [15:35:56] $ 
vshcmd: > sudo mount /dev/loop0p1 /mnt/usb
bootloader [15:36:13] $ 
vshcmd: > dd if=/mnt/usb/boot/vmlinuz-3.16.0-4-686-pae bs=1 count=4 skip=517 | xxd
4+0 records in
4+0 records out
4 bytes copied, 0.000100223 s, 39.9 kB/s00000000: 530d 0200                                S...

bootloader [15:37:46] $ 
vshcmd: > sudo 
vshcmd: > sudo losetup -f
[sudo] password for matthew: 
/dev/loop0
bootloader [15:33:26] $ 
vshcmd: > grep losetup ~/.bash_history 
losetup /dev/loop0 full_debian_install.img
losetup loopdev
losetup -f
sudo losetup -f
sudo losetup /dev/loop0 full_debian_install.img
sudo losetup -d /dev/loop0
sudo losetup -f
sudo losetup -P /dev/loop0 full_debian_install.img
sudo losetup -D
bootloader [15:34:43] $ 
vshcmd: > sudo umount /mnt/usb
[sudo] password for matthew: 
bootloader [15:41:56] $ 
vshcmd: > sudo losetup  -D
bootloader [15:42:00] $ 
