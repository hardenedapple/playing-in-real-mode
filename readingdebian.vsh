vshcmd: > sudo losetup -P /dev/loop0 images/usb_arch_initrdfree.img
bootloader [10:27:11] $ 
vshcmd: > sudo mount /dev/loop0p1 /mnt/hard_drive
bootloader [10:27:14] $ 
vshcmd: > sudo mount /dev/sdb1 /mnt/usb
bootloader [10:27:20] $ 
vshcmd: > sudo rm -r /mnt/hard_drive/home/apple/kernelbuild/linux-4.11.4/
bootloader [10:27:58] $ 
vshcmd: > sudo cp -R /mnt/usb/home/apple/kernelbuild/linux-4.11.4 /mnt/hard_drive/home/apple/kernelbuild/
bootloader [10:29:53] $ 
vshcmd: > sudo cp /mnt/usb/home/apple/kernelbuild/linux-4.11.4/.config /mnt/hard_drive/home/apple/kernelbuild/linux-4.11.4/
bootloader [09:23:41] $ 
vshcmd: > sudo umount /mnt/hard_drive/
bootloader [09:23:53] $ 
vshcmd: > sudo umount /mnt/usb
bootloader [13:57:20] $ 
vshcmd: > sudo losetup  -D
bootloader [10:26:13] $ 
vshcmd: > sudo umount /mnt/hard_drive
[sudo] password for matthew: 
bootloader [10:25:57] $ 
vshcmd: >
vshcmd: > sudo losetup -f
/dev/loop0
bootloader [13:57:41] $ 
vshcmd: > sudo losetup -P /dev/loop0 images/full_debian_install.img
bootloader [14:17:05] $ 
vshcmd: > sudo mount /dev/loop0p1 /mnt/usb
bootloader [14:17:07] $ 
vshcmd: > sudo umount /mnt/usb
bootloader [14:19:56] $ 
vshcmd: > ls /mnt/usb
bin   dev  home        lib         media  opt   root  sbin  sys  usr  vmlinuz
boot  etc  initrd.img  lost+found  mnt    proc  run   srv   tmp  var
bootloader [14:17:11] $ 
vshcmd: > dd if=/mnt/usb/boot/vmlinuz-3.16.0-4-686-pae bs=1 count=4 skip=517 | xxd
4+0 records in
4+0 records out
4 bytes copied, 0.000100223 s, 39.9 kB/s00000000: 530d 0200                                S...

bootloader [15:37:46] $ 
vshcmd: > sudo 
vshcmd: > sudo losetup -f
/dev/loop1
bootloader [14:15:15] $ 
vshcmd: > sudo losetup -D
bootloader [14:20:04] $ 
vshcmd: >
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
vshcmd: > sudo umount /mnt/usb
[sudo] password for matthew: 
bootloader [14:27:48] $ 
vshcmd: > sudo dd if=/dev/sdb of=images/usb_arch.img bs=4M
[sudo] password for matthew: 
bootloader [18:16:09] $ 
