# Failed (i.e. unfinished) attempt at a toy Linux Bootloader

This repo was in order to learn about how a PC boots up.
Given that this is a very vague goal, I gave myself some short-term targets to
reach.

Originally it was just things like "enable the a20 line" and "load some data
from the hard-drive into memory", these I completed.

A later target was "do a minimal boot of the Linux kernel", where minimal meant
reading from a hard-coded position.
This didn't go so well, a description of the problems I had are below.
While I'm confident I could eventually reach this target, the effort involved
looks to be not worth the benefit.
This is mainly attributed to the fact that the benefit boils down to "I like to
finish things ...".
Below is a description of the problems encountered, and plans made.

## Current "problem" state

I have implemented what I thought I needed to do from reading the linux
documentation ( Documentation/x86/boot.txt ).
This consists of loading the kernel into memory, loading the initramfs into
memory, setting flags in the first & second 512 bytes of the kernel in memory
and jumping to 0x20 sector offset in the loaded memory.
Running this code, the linux kernel appears to boot, but gives errors to do
with uncompressing the initramfs.
n.b. for future reference, the error message depends on where the initramdisk
is loaded.

I know that the initramfs I've loaded into memory is the same as the initramfs
I saw on disk, and that the `ramdisk_image` and `ramdisk_size` values correctly
delimit it.
I checked this by writing that area of memory to disk using the bochs
`writemem` command and running `diff` against the initramfs file on disk.

### Possible routes to progress

There are a few different ways I could proceed and short-term targets.

##### Check I've at least loaded the kernel correctly.
With that knowledge, I could stop looking at a large part of the code, and just
focus on finding what's going wrong in how I'm loading the ramfs and
communicating where it is to the kernel.

I've had a look at the
[sebastian plotz minimal bootloader](http://sebastian-plotz.blogspot.co.uk/)
that is targeted towards a kernel image without an initramfs.
I know that commit 01f5775, where I hadn't yet added code to working with an
initramfs, got the same errors when attempting to load a kernel that uses an
initramfs as this minimal bootloader did.
This doesn't mean much, just indicates I may be doing things right.

I attempted this by recompiling the kernel to not use an initramdisk, but while
this would boot on the machine I compiled it on, it wouldn't boot on the
virtual machine I want to debug on.
I tried to configure for the virtual machine by running `make defconfig` on the
virtual machine to create a `.config` file, then compile on a real machine for
speed.
I obviously, also tried to ensure the correct drivers were installed manually
by looking at the output of `lspci -k`.
This didn't work, though I could compile an image that worked without an initrd
for the real machine.

##### Step through the Linux code in bochs, compare to source
I did this a little, but seeing as this was supposed to be a small
side-project, reading large amounts of the Linux source code is a task that
seems more effort than value.

##### Read other bootloaders source and compare
The idea here is mainly to see what I'm misunderstanding in the boot.txt
documentation.
Given that other bootloaders *work*, they must do something different to mine.
From a cursory look they seem to do what I do (excepting the many extra
features), there's at least nothing obvious saying something like "must unzip
initrd before loading into memory".
