vshcmd: > # Used the following to create totalUSB.img, in the fututre, use
vshcmd: > # dd to reset the boot partition, and to install my changes.
vshcmd: > # vshcmd: > cp otherBIOSes/full_debian_install.img ./totalUSB.img
vshcmd: > #
vshcmd: > # Use the below to reset the USB to check the debianGRUB still works.
vshcmd: > # vshcmd: > dd if=otherBIOSes/debian_GRUB.img of=totalUSB.img conv=notrunc
vshcmd: > gcc -E boot.S > boot.asm
vshcmd: > as boot.asm -o boot.o
vshcmd: > ld --oformat=binary -Ttext 0x7c00 boot.o -o boot
vshcmd: > dd if=boot of=totalUSB.img conv=notrunc
vshcmd: > dd if=otherBIOSes/debian_GRUB.img of=boot bs=1 count=66 seek=446 skip=446 conv=notrunc
vshcmd: > qemu-system-x86_64 -drive file=totalUSB.img,format=raw -serial stdio
bootloader [12:10:06] $ bootloader [12:10:06] $ bootloader [12:10:06] $ 6+0 records in
6+0 records out
3072 bytes (3.1 kB, 3.0 KiB) copied, 0.000195137 s, 15.7 MB/s
bootloader [12:10:06] $ 66+0 records in
66+0 records out
66 bytes copied, 0.000279855 s, 236 kB/s
bootloader [12:10:06] $ 
(qemu-system-x86_64:1913): Gtk-[1;33mWARNING[0m **: Allocating size to GtkScrollbar 0x7f1a0436e210 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?

(qemu-system-x86_64:1913): Gtk-[1;33mWARNING[0m **: Allocating size to GtkScrollbar 0x7f1a0436e410 without calling gtk_widget_get_preferred_width/height(). How does the code know the size to allocate?
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-4-686-pae (debian-kernel@lists.debian.org) (gcc version 4.8.4 (Debian 4.8.4-1) ) #1 SMP Debian 3.16.43-2 (2017-04-30)
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000007fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000007fe0000-0x0000000007ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7fe0 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000f6aa0-0x000f6aaf] mapped at [c00f6aa0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x07c00000-0x07dfffff]
[    0.000000]  [mem 0x07c00000-0x07dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x04000000-0x07bfffff]
[    0.000000]  [mem 0x04000000-0x07bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x03ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x03ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x07e00000-0x07fdffff]
[    0.000000]  [mem 0x07e00000-0x07fdffff] page 4k
[    0.000000] BRK [0x0179f000, 0x0179ffff] PGTABLE
[    0.000000] BRK [0x017a0000, 0x017a1fff] PGTABLE
[    0.000000] BRK [0x017a2000, 0x017a2fff] PGTABLE
[    0.000000] BRK [0x017a3000, 0x017a3fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x003ea200-0x011ccfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F68C0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000007FE154E 000030 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000007FE142A 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000007FE0040 0013EA (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000007FE0000 000040
[    0.000000] ACPI: APIC 0x0000000007FE149E 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000007FE1516 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 127MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 07fe0000
[    0.000000]   low ram: 0 - 07fe0000
[    0.000000] BRK [0x017a4000, 0x017a4fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x07fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x07fdffff]
[    0.000000] On node 0 totalpages: 32638
[    0.000000] free_area_init_node: node 0, pgdat c165f340, node_mem_map c7ee0020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 224 pages used for memmap
[    0.000000]   Normal zone: 28640 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x08000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c7ecf000 s34752 r0 d22592 u57344
[    0.000000] pcpu-alloc: s34752 r0 d22592 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32382
[    0.000000] Kernel command line: debug root=UUID=ff9be8c0-4821-4d00-8046-78db6f7303b4 ro console=ttyS0,115200,8,n
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 109084K/130552K available (4625K kernel code, 519K rwdata, 1448K rodata, 660K init, 460K bss, 21468K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0xc87e0000 - 0xff5fe000   ( 878 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc7fe0000   ( 127 MB)
[    0.000000]       .init : 0xc1673000 - 0xc1718000   ( 660 kB)
[    0.000000]       .data : 0xc14849bc - 0xc1671d40   (1972 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14849bc   (4626 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=1.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=c7806000 soft=c7808000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2194.429 MHz processor
[    0.030281] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.85 BogoMIPS (lpj=8777716)
[    0.032000] pid_max: default: 32768 minimum: 301
[    0.033025] ACPI: Core revision 20140424
[    0.100556] ACPI: All ACPI Tables successfully acquired
[    0.102407] Security Framework initialized
[    0.107586] AppArmor: AppArmor disabled by boot time parameter
[    0.108157] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.111106] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.112236] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.133968] Initializing cgroup subsys memory
[    0.136506] Initializing cgroup subsys devices
[    0.137233] Initializing cgroup subsys freezer
[    0.137815] Initializing cgroup subsys net_cls
[    0.138436] Initializing cgroup subsys blkio
[    0.138994] Initializing cgroup subsys perf_event
[    0.139524] Initializing cgroup subsys net_prio
[    0.143365] mce: CPU supports 10 MCE banks
[    0.146505] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.146505] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.146505] tlb_flushall_shift: -1
[    0.292567] Freeing SMP alternatives memory: 20K (c1718000 - c171d000)
[    0.308885] ftrace: allocating 20833 entries in 41 pages
[    0.437185] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.443162] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.485236] smpboot: CPU0: AMD QEMU Virtual CPU version 2.5+ (fam: 06, model: 06, stepping: 03)
[    0.488000] Performance Events: Broken PMU hardware detected, using software events only.
[    0.488000] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.526378] x86: Booted up 1 node, 1 CPUs
[    0.527658] smpboot: Total of 1 processors activated (4388.85 BogoMIPS)
[    0.532720] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.558935] devtmpfs: initialized
[    0.576617] futex hash table entries: 256 (order: 2, 16384 bytes)
[    0.597597] pinctrl core: initialized pinctrl subsystem
[    0.605867] NET: Registered protocol family 16
[    0.615177] cpuidle: using governor ladder
[    0.615779] cpuidle: using governor menu
[    0.624699] ACPI: bus type PCI registered
[    0.625206] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.631550] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
[    0.632540] PCI: PCI BIOS revision 2.10 entry at 0xfd501, last bus=0
[    0.633106] PCI: Using configuration type 1 for base access
[    0.687551] ACPI: Added _OSI(Module Device)
[    0.688125] ACPI: Added _OSI(Processor Device)
[    0.688424] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.688707] ACPI: Added _OSI(Processor Aggregator Device)
[    0.738230] ACPI: Interpreter enabled
[    0.738988] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.740137] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.742156] ACPI: (supports S0 S3 S4 S5)
[    0.742560] ACPI: Using IOAPIC for interrupt routing
[    0.744369] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.862691] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.864238] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.865104] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.868216] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.881879] acpiphp: Slot [3] registered
[    0.882774] acpiphp: Slot [4] registered
[    0.883574] acpiphp: Slot [5] registered
[    0.884535] acpiphp: Slot [6] registered
[    0.886141] acpiphp: Slot [7] registered
[    0.886859] acpiphp: Slot [8] registered
[    0.887585] acpiphp: Slot [9] registered
[    0.888521] acpiphp: Slot [10] registered
[    0.889239] acpiphp: Slot [11] registered
[    0.889940] acpiphp: Slot [12] registered
[    0.890683] acpiphp: Slot [13] registered
[    0.891394] acpiphp: Slot [14] registered
[    0.892503] acpiphp: Slot [15] registered
[    0.893260] acpiphp: Slot [16] registered
[    0.893991] acpiphp: Slot [17] registered
[    0.894710] acpiphp: Slot [18] registered
[    0.895445] acpiphp: Slot [19] registered
[    0.896517] acpiphp: Slot [20] registered
[    0.897269] acpiphp: Slot [21] registered
[    0.897974] acpiphp: Slot [22] registered
[    0.898661] acpiphp: Slot [23] registered
[    0.899342] acpiphp: Slot [24] registered
[    0.900349] acpiphp: Slot [25] registered
[    0.901101] acpiphp: Slot [26] registered
[    0.901865] acpiphp: Slot [27] registered
[    0.902632] acpiphp: Slot [28] registered
[    0.903364] acpiphp: Slot [29] registered
[    0.904363] acpiphp: Slot [30] registered
[    0.905095] acpiphp: Slot [31] registered
[    0.905531] PCI host bridge to bus 0000:00
[    0.906192] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.906952] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.907451] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.908138] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.908647] pci_bus 0000:00: root bus resource [mem 0x08000000-0xfebfffff]
[    0.910221] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.918174] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.921750] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.926555] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.929052] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.929703] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.930282] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.932168] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.935235] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.936973] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
[    0.937596] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
[    0.942461] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
[    0.944247] pci 0000:00:02.0: reg 0x10: [mem 0xfd000000-0xfdffffff pref]
[    0.948901] pci 0000:00:02.0: reg 0x18: [mem 0xfebf0000-0xfebf0fff]
[    0.955856] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.961922] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.965348] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.967072] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.978171] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.982682] pci_bus 0000:00: on NUMA node 0
[    1.000626] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.003483] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.006284] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.009783] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.011216] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.017791] ACPI: Enabled 2 GPEs in block 00 to 0F
[    1.026442] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.027100] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.027770] vgaarb: loaded
[    1.028249] vgaarb: bridge control possible 0000:00:02.0
[    1.031311] PCI: Using ACPI for IRQ routing
[    1.032294] PCI: pci_cache_line_size set to 64 bytes
[    1.033585] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.034409] e820: reserve RAM buffer [mem 0x07fe0000-0x07ffffff]
[    1.048396] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.049399] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.049999] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    1.059093] amd_nb: Cannot enumerate AMD northbridges
[    1.061125] Switched to clocksource hpet
[    1.273119] pnp: PnP ACPI init
[    1.273885] ACPI: bus type PNP registered
[    1.279604] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.281887] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.283669] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.285269] pnp 00:03: [dma 2]
[    1.286253] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.288704] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.290751] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.296671] pnp: PnP ACPI: found 6 devices
[    1.297130] ACPI: bus type PNP unregistered
[    1.297597] PnPBIOS: Disabled by ACPI PNP
[    1.411828] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.413120] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.413632] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.414085] pci_bus 0000:00: resource 7 [mem 0x08000000-0xfebfffff]
[    1.415488] NET: Registered protocol family 2
[    1.427899] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    1.429416] TCP bind hash table entries: 1024 (order: 1, 8192 bytes)
[    1.430227] TCP: Hash tables configured (established 1024 bind 1024)
[    1.431731] TCP: reno registered
[    1.432546] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.433223] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.436993] NET: Registered protocol family 1
[    1.438009] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.438600] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.439306] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.440005] pci 0000:00:02.0: Video device with shadowed ROM
[    1.440999] PCI: CLS 0 bytes, default 64
[    1.453159] Unpacking initramfs...
[    4.021110] Initramfs unpacking failed: uncompression error
[    4.021920] ------------[ cut here ]------------
[    4.022496] WARNING: CPU: 0 PID: 1 at /build/linux-AY4Gs5/linux-3.16.43/arch/x86/mm/init.c:601 free_init_pages+0x7c/0x90()
[    4.023386] Modules linked in:
[    4.024140] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-4-686-pae #1 Debian 3.16.43-2
[    4.024197] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-20170228_101828-anatol 04/01/2014
[    4.024197]  00000000 c786deb4 c147da67 00000000 c15560f0 c1057b64 c15577fc 00000000
[    4.024197]  00000001 c15560f0 00000259 c104c13c c104c13c 00000009 c03eb000 c11cd000
[    4.024197]  c03eb000 c786dec4 c1057c22 00000009 00000000 c786dee4 c104c13c 00000000
[    4.024197] Call Trace:
[    4.024197]  [<c147da67>] ? dump_stack+0x55/0x6e
[    4.024197]  [<c1057b64>] ? warn_slowpath_common+0x84/0xa0
[    4.024197]  [<c104c13c>] ? free_init_pages+0x7c/0x90
[    4.024197]  [<c104c13c>] ? free_init_pages+0x7c/0x90
[    4.024197]  [<c11cd000>] ? kernfs_rename_ns+0x50/0x180
[    4.024197]  [<c1057c22>] ? warn_slowpath_null+0x22/0x30
[    4.024197]  [<c104c13c>] ? free_init_pages+0x7c/0x90
[    4.024197]  [<c11cd000>] ? kernfs_rename_ns+0x50/0x180
[    4.024197]  [<c1674a05>] ? maybe_link.part.2+0xe3/0xe3
[    4.024197]  [<c1674ad9>] ? populate_rootfs+0xd4/0xf6
[    4.024197]  [<c1674a05>] ? maybe_link.part.2+0xe3/0xe3
[    4.024197]  [<c1002132>] ? do_one_initcall+0xc2/0x1f0
[    4.024197]  [<c1674a05>] ? maybe_link.part.2+0xe3/0xe3
[    4.024197]  [<c1072be8>] ? parameq+0x18/0x70
[    4.024197]  [<c16735a2>] ? repair_env_string+0xf/0x4d
[    4.024197]  [<c1072e79>] ? parse_args+0x239/0x470
[    4.024197]  [<c1091957>] ? __wake_up+0x37/0x50
[    4.024197]  [<c1673d3c>] ? kernel_init_freeable+0x13e/0x1d3
[    4.024197]  [<c1673593>] ? initcall_blacklist+0x97/0x97
[    4.024197]  [<c14778b0>] ? kernel_init+0x10/0xe0
[    4.024197]  [<c108164f>] ? schedule_tail+0x1f/0x60
[    4.024197]  [<c1482941>] ? ret_from_kernel_thread+0x21/0x30
[    4.024197]  [<c14778a0>] ? rest_init+0x70/0x70
[    4.042126] ---[ end trace a344879c5d444afb ]---
qemu-system-x86_64: Trying to execute code outside RAM or ROM at 0x00000001f045d2cc
This usually means one of the following happened:

(1) You told QEMU to execute a kernel for the wrong machine type, and it crashed on startup (eg trying to run a raspberry pi kernel on a versatilepb QEMU machine)
(2) You didn't give QEMU a kernel or BIOS filename at all, and QEMU executed a ROM full of no-op instructions until it fell off the end
(3) Your guest kernel has a bug and crashed by jumping off into nowhere

This is almost always one of the first two, so check your command line and that you are using the right type of kernel for this machine.
If you think option (3) is likely then you can try debugging your guest with the -d debug options; in particular -d guest_errors will cause the log to include a dump of the guest register state at this point.

Execution cannot continue; stopping here.

bootloader [12:10:19] $ 
vshcmd: > asbytes att '.code16; transferBuffer: movswl transferBuffer, %eax'
00000000: 66 0f bf 06 00 7c                                f....|
bootloader [20:31:39] $ 
vshcmd: > rm otherBIOSes/sebastian-bootloader.bin
vshcmd: > nasm otherBIOSes/sebastian-minimal-linux-bootloader.asm -o otherBIOSes/sebastian-bootloader.bin
vshcmd: > dd if=otherBIOSes/sebastian-bootloader.bin of=totalUSB.img conv=notrunc
vshcmd: > qemu-system-x86_64 -drive file=totalUSB.img,format=raw
bootloader [12:07:09] $ 
vshcmd: > dd if=otherBIOSes/debian_GRUB.img of=totalUSB.img conv=notrunc
vshcmd: > qemu-system-x86_64 -drive file=totalUSB.img,format=raw
bootloader [12:17:32] $ 
vshcmd: > objdump -Maddr16,data16 -d boot.o

boot.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <_bootsector>:
   0:	ea                   	(bad)  
   1:	00 00                	add    %al,(%rax)
	...

0000000000000005 <_start>:
   5:	fa                   	cli    
   6:	31 c0                	xor    %ax,%ax
   8:	8e d8                	mov    %ax,%ds
   a:	8e c0                	mov    %ax,%es
   c:	b8 c0 8f             	mov    $0x8fc0,%ax
   f:	8e d0                	mov    %ax,%ss
  11:	bc ff ff             	mov    $0xffff,%sp
  14:	fb                   	sti    
  15:	e8 97 00             	call   af <initialiseDisks>
  18:	e8 12 00             	call   2d <clearScreen>
  1b:	e8 c8 00             	call   e6 <readFromHardDrive>
  1e:	e9 df 01             	jmp    200 <secondStage_start>

0000000000000021 <errmsg>:
  21:	e8 17 00             	call   3b <BIOSprint>
  24:	58                   	pop    %ax
  25:	a3                   	.byte 0xa3
  26:	00 00                	add    %al,(%rax)
  28:	50                   	push   %ax
  29:	e8 23 00             	call   4f <printReg>
  2c:	c3                   	ret    

000000000000002d <clearScreen>:
  2d:	b8 03 00             	mov    $0x3,%ax
  30:	cd 10                	int    $0x10
  32:	fc                   	cld    
  33:	c3                   	ret    
  34:	bb 01 00             	mov    $0x1,%bx
  37:	b4 0e                	mov    $0xe,%ah
  39:	cd 10                	int    $0x10

000000000000003b <BIOSprint>:
  3b:	ac                   	lods   %ds:(%rsi),%al
  3c:	3c 00                	cmp    $0x0,%al
  3e:	75 f4                	jne    34 <clearScreen+0x7>
  40:	c3                   	ret    

0000000000000041 <newline>:
  41:	bb 01 00             	mov    $0x1,%bx
  44:	b4 0e                	mov    $0xe,%ah
  46:	b0 0a                	mov    $0xa,%al
  48:	cd 10                	int    $0x10
  4a:	b0 0d                	mov    $0xd,%al
  4c:	cd 10                	int    $0x10
  4e:	c3                   	ret    

000000000000004f <printReg>:
  4f:	3c 00                	cmp    $0x0,%al
  51:	74 02                	je     55 <printReg+0x6>
  53:	b0 0a                	mov    $0xa,%al
  55:	a2 00 00 bf 00 00 a1 	movabs %al,0xa10000bf0000
  5c:	00 00 
  5e:	be 00 00             	mov    $0x0,%si
  61:	b9 04 00             	mov    $0x4,%cx

0000000000000064 <hexloop>:
  64:	c1 c0 04             	rol    $0x4,%ax
  67:	89 c3                	mov    %ax,%bx
  69:	83 e3 0f             	and    $0xf,%bx
  6c:	8a 18                	mov    (%rax),%bl
  6e:	88 1d 47 e2 f1 be    	mov    %bl,-0x410e1db9(%rip)        # ffffffffbef1e2bb <secondStage_end_addr+0xffffffffbef15abb>
  74:	00 00                	add    %al,(%rax)
  76:	e8 c2 ff             	call   3b <BIOSprint>
  79:	c3                   	ret    

000000000000007a <printDWORD>:
  7a:	a3                   	.byte 0xa3
  7b:	00 00                	add    %al,(%rax)
  7d:	b9 01 00             	mov    $0x1,%cx
  80:	eb 06                	jmp    88 <printQWORD+0x6>

0000000000000082 <printQWORD>:
  82:	a3 00 00 b9 03 00 8b 	movabs %ax,0x368b0003b90000
  89:	36 00 
  8b:	00 89 c8 d1 e0 01    	add    %cl,0x1e0d1c8(%rcx)
  91:	c6                   	(bad)  
  92:	8b 04 a3             	mov    (%rbx,%riz,4),%ax
  95:	00 00                	add    %al,(%rax)
  97:	51                   	push   %cx
  98:	b0 00                	mov    $0x0,%al
  9a:	e8 b2 ff             	call   4f <printReg>
  9d:	59                   	pop    %cx
  9e:	e2 e8                	loop   88 <printQWORD+0x6>

00000000000000a0 <printQWORDfin>:
  a0:	8b 36                	mov    (%rsi),%si
  a2:	00 00                	add    %al,(%rax)
  a4:	8b 04 a3             	mov    (%rbx,%riz,4),%ax
  a7:	00 00                	add    %al,(%rax)
  a9:	b0 01                	mov    $0x1,%al
  ab:	e8 a1 ff             	call   4f <printReg>
  ae:	c3                   	ret    

00000000000000af <initialiseDisks>:
  af:	88 16                	mov    %dl,(%rsi)
  b1:	00 00                	add    %al,(%rax)
  b3:	b4 00                	mov    $0x0,%ah
  b5:	cd 13                	int    $0x13
  b7:	72 15                	jb     ce <ignoreerror+0x15>

00000000000000b9 <ignoreerror>:
  b9:	b4 41                	mov    $0x41,%ah
  bb:	bb aa 55             	mov    $0x55aa,%bx
  be:	cd 13                	int    $0x13
  c0:	72 1c                	jb     de <ignoreerror+0x25>
  c2:	81 fb 55 aa          	cmp    $0xaa55,%bx
  c6:	75 16                	jne    de <ignoreerror+0x25>
  c8:	83 e1 01             	and    $0x1,%cx
  cb:	74 11                	je     de <ignoreerror+0x25>
  cd:	c3                   	ret    
  ce:	b0 00                	mov    $0x0,%al
  d0:	a3 00 00 e8 79 ff be 	movabs %ax,0xbeff79e80000
  d7:	00 00 
  d9:	e8 45 ff             	call   21 <errmsg>
  dc:	eb db                	jmp    b9 <ignoreerror>
  de:	be 00 00             	mov    $0x0,%si
  e1:	e8 3d ff             	call   21 <errmsg>
  e4:	eb fe                	jmp    e4 <ignoreerror+0x2b>

00000000000000e6 <readFromHardDrive>:
  e6:	a1 00 00 50 83 e0 7f 	movabs 0xa37fe083500000,%ax
  ed:	a3 00 
  ef:	00 e8                	add    %ch,%al
  f1:	0f 00 58 2d          	ltr    0x2d(%rax)
  f5:	80 00 77             	addb   $0x77,(%rax)
  f8:	f0 c3                	lock ret 
  fa:	2b 0e                	sub    (%rsi),%cx
  fc:	00 00                	add    %al,(%rax)
  fe:	89 0e                	mov    %cx,(%rsi)
	...

0000000000000102 <doRead>:
 102:	8b 0e                	mov    (%rsi),%cx
 104:	00 00                	add    %al,(%rax)
 106:	8a 16                	mov    (%rsi),%dl
 108:	00 00                	add    %al,(%rax)
 10a:	be 00 00             	mov    $0x0,%si
 10d:	b4 42                	mov    $0x42,%ah
 10f:	cd 13                	int    $0x13
 111:	73 06                	jae    119 <doRead+0x17>
 113:	be 00 00             	mov    $0x0,%si
 116:	e8 08 ff             	call   21 <errmsg>
 119:	84 e4                	test   %ah,%ah
 11b:	74 0c                	je     129 <doRead+0x27>
 11d:	a3 00 00 e8 2c ff be 	movabs %ax,0xbeff2ce80000
 124:	00 00 
 126:	e8 f8 fe             	call   21 <errmsg>
 129:	3b 0e                	cmp    (%rsi),%cx
 12b:	00 00                	add    %al,(%rax)
 12d:	74 08                	je     137 <doRead+0x35>
 12f:	77 c9                	ja     fa <readFromHardDrive+0x14>
 131:	be 00 00             	mov    $0x0,%si
 134:	e8 ea fe             	call   21 <errmsg>
 137:	c3                   	ret    

0000000000000138 <copyExtendedMemory>:
 138:	30 31                	xor    %dh,(%rcx)
 13a:	32 33                	xor    (%rbx),%dh
 13c:	34 35                	xor    $0x35,%al
 13e:	36 37                	ss (bad) 
 140:	38 39                	cmp    %bh,(%rcx)
 142:	41                   	rex.B
 143:	42                   	rex.X
 144:	43                   	rex.XB
 145:	44                   	rex.R
 146:	45                   	rex.RB
 147:	46                   	rex.RX

0000000000000148 <outstr16>:
 148:	00 00                	add    %al,(%rax)
 14a:	00 00                	add    %al,(%rax)
 14c:	0a                   	.byte 0xa
 14d:	0d                   	.byte 0xd
	...

000000000000014f <reg16>:
	...

0000000000000151 <storedaddr>:
	...

0000000000000153 <curdrive>:
	...

0000000000000154 <msgDiskFail>:
 154:	64 69 73 6b 2e 61    	imul   $0x612e,%fs:0x6b(%rbx),%si
 15a:	73 6d                	jae    1c9 <partition_start+0x3>
 15c:	20 70 72             	and    %dh,0x72(%rax)
 15f:	6f                   	outsw  %ds:(%rsi),(%dx)
 160:	62                   	(bad)  
 161:	6c                   	insb   (%dx),%es:(%rdi)
 162:	65 6d                	gs insw (%dx),%es:(%rdi)
	...

0000000000000165 <msgReadFailed>:
 165:	63 61 6e             	movslq 0x6e(%rcx),%sp
 168:	6e                   	outsb  %ds:(%rsi),(%dx)
 169:	6f                   	outsw  %ds:(%rsi),(%dx)
 16a:	74 20                	je     18c <startBlock+0x1>
 16c:	72 65                	jb     1d3 <partition_start+0xd>
 16e:	61                   	(bad)  
 16f:	64 20 00             	and    %al,%fs:(%rax)

0000000000000172 <msgNoLBA>:
 172:	6e                   	outsb  %ds:(%rsi),(%dx)
 173:	6f                   	outsw  %ds:(%rsi),(%dx)
 174:	20 69 6e             	and    %ch,0x6e(%rcx)
 177:	73 74                	jae    1ed <partition_start+0x27>
 179:	61                   	(bad)  
 17a:	6c                   	insb   (%dx),%es:(%rdi)
 17b:	6c                   	insb   (%dx),%es:(%rdi)
 17c:	65 64 20 4c 42 41    	gs and %cl,%fs:0x41(%rdx,%rax,2)
 182:	20                   	.byte 0x20

0000000000000183 <diskPacket>:
 183:	10                   	.byte 0x10

0000000000000184 <packetReserved>:
	...

0000000000000185 <numBlocks>:
 185:	05                   	.byte 0x5
	...

0000000000000187 <transferBuffer>:
 187:	00 7e 00             	add    %bh,0x0(%rsi)
	...

000000000000018b <startBlock>:
 18b:	01 00                	add    %ax,(%rax)
	...

00000000000001b8 <diskID>:
 1b8:	be eb ee             	mov    $0xeeeb,%si
 1bb:	fe 00                	incb   (%rax)
	...

00000000000001be <partition1>:
 1be:	80 00 00             	addb   $0x0,(%rax)
	...

00000000000001c2 <partition_type>:
 1c2:	df 00                	fild   (%rax)
	...

00000000000001c6 <partition_start>:
 1c6:	00 08                	add    %cl,(%rax)
 1c8:	00 00                	add    %al,(%rax)
 1ca:	64 00 00             	add    %al,%fs:(%rax)
	...
 1fd:	00 55 aa             	add    %dl,-0x56(%rbp)

0000000000000200 <secondStage_start>:
 200:	e8 d9 02             	call   4dc <enablea20>
 203:	e8 3b fe             	call   41 <newline>
 206:	cd 12                	int    $0x12
 208:	d1 e0                	shl    %ax
 20a:	73 0c                	jae    218 <secondStage_start+0x18>
 20c:	a3 00 00 e8 3d fe be 	movabs %ax,0xbefe3de80000
 213:	00 00 
 215:	e8 09 fe             	call   21 <errmsg>
 218:	2d 44 00             	sub    $0x44,%ax
 21b:	a3 00 00 e8 30 00 be 	movabs %ax,0xbe0030e80000
 222:	00 00 
 224:	e8 14 fe             	call   3b <BIOSprint>
 227:	31 c0                	xor    %ax,%ax
 229:	a0 00 00 83 c0 40 69 	movabs 0xc06940c0830000,%al
 230:	c0 00 
 232:	02 89 c4 b8 80 08    	add    0x880b8c4(%rcx),%cl
 238:	8e d8                	mov    %ax,%ds
 23a:	8e d0                	mov    %ax,%ss
 23c:	8e c0                	mov    %ax,%es
 23e:	8e e0                	mov    %ax,%fs
 240:	8e e8                	mov    %ax,%gs
 242:	fa                   	cli    
 243:	ea                   	(bad)  
 244:	00 00                	add    %al,(%rax)
 246:	a0 08 be 00 00 e8 ed 	movabs 0xebfdede80000be08,%al
 24d:	fd eb 
 24f:	fe                   	.byte 0xfe

0000000000000250 <findLinux>:
 250:	90                   	nop

0000000000000251 <readLinux>:
 251:	c7 06 00 00          	movw   $0x0,(%rsi)
 255:	02 00                	add    (%rax),%al
 257:	c7 06 00 00          	movw   $0x0,(%rsi)
 25b:	00 00                	add    %al,(%rax)
 25d:	66 a1 00 00 66 a3 00 	movabs 0x7ee80000a3660000,%eax
 264:	00 e8 7e 
 267:	fe                   	(bad)  
 268:	66 a1 00 00 66 3d 48 	movabs 0x537264483d660000,%eax
 26f:	64 72 53 
 272:	74 07                	je     27b <readLinux+0x2a>
 274:	be 00 00             	mov    $0x0,%si
 277:	e8 a7 fd             	call   21 <errmsg>
 27a:	c3                   	ret    
 27b:	a1 00 00 3d 04 02 73 	movabs 0xa30c7302043d0000,%ax
 282:	0c a3 
 284:	00 00                	add    %al,(%rax)
 286:	e8 c6 fd             	call   4f <printReg>
 289:	be 00 00             	mov    $0x0,%si
 28c:	e8 92 fd             	call   21 <errmsg>
 28f:	66 31 c0             	xor    %eax,%eax
 292:	a0 00 00 3c 00 75 02 	movabs 0x4b00275003c0000,%al
 299:	b0 04 
 29b:	fe c0                	inc    %al
 29d:	a2 00 00 83 c0 41 3b 	movabs %al,0x63b41c0830000
 2a4:	06 00 
 2a6:	00 72 0c             	add    %dh,0xc(%rdx)
 2a9:	a3 00 00 e8 a0 fd be 	movabs %ax,0xbefda0e80000
 2b0:	00 00 
 2b2:	e8 6c fd             	call   21 <errmsg>
 2b5:	31 c0                	xor    %ax,%ax
 2b7:	a0 00 00 a3 00 00 e8 	movabs 0xfe26e80000a30000,%al
 2be:	26 fe 
 2c0:	c6 06 00             	movb   $0x0,(%rsi)
 2c3:	00 ff                	add    %bh,%bh
 2c5:	a0 00 00 24 df 24 bf 	movabs 0x800cbf24df240000,%al
 2cc:	0c 80 
 2ce:	a2 00 00 a8 01 66 b8 	movabs %al,0xb86601a80000
 2d5:	00 00 
 2d7:	01 00                	add    %ax,(%rax)
 2d9:	74 04                	je     2df <readLinux+0x8e>
 2db:	66 6b c0 10          	imul   $0x10,%eax,%eax
 2df:	66 a3 00 00 66 a1 00 	movabs %eax,0x83660000a1660000
 2e6:	00 66 83 
 2e9:	f8                   	clc    
 2ea:	00 74 0c a3          	add    %dh,-0x5d(%rsp,%rcx,1)
 2ee:	00 00                	add    %al,(%rax)
 2f0:	e8 5c fd             	call   4f <printReg>
 2f3:	be 00 00             	mov    $0x0,%si
 2f6:	e8 28 fd             	call   21 <errmsg>
 2f9:	66 a1 00 00 66 83 f8 	movabs 0xc7400f883660000,%eax
 300:	00 74 0c 
 303:	a3 00 00 e8 46 fd be 	movabs %ax,0xbefd46e80000
 30a:	00 00 
 30c:	e8 12 fd             	call   21 <errmsg>
 30f:	66 a1 00 00 66 3d 18 	movabs 0x183d660000,%eax
 316:	00 00 00 
 319:	73 0c                	jae    327 <readLinux+0xd6>
 31b:	a3 00 00 e8 2e fd be 	movabs %ax,0xbefd2ee80000
 322:	00 00 
 324:	e8 fa fc             	call   21 <errmsg>
 327:	31 c0                	xor    %ax,%ax
 329:	a0 00 00 83 c0 3f 69 	movabs 0xc0693fc0830000,%al
 330:	c0 00 
 332:	02 a3 00 00 31 c0    	add    -0x3fcf0000(%rbx),%ah
 338:	a0 00 00 8b 1e 00 00 	movabs 0xc32900001e8b0000,%al
 33f:	29 c3 
 341:	83 fb 7f             	cmp    $0x7f,%bx
 344:	73 0e                	jae    354 <readLinux+0x103>
 346:	a3 00 00 e8 03 fd be 	movabs %ax,0xbefd03e80000
 34d:	00 00 
 34f:	e8 cf fc             	call   21 <errmsg>
 352:	eb fe                	jmp    352 <readLinux+0x101>
 354:	69 c0 00 02          	imul   $0x200,%ax,%ax
 358:	05 00 00             	add    $0x0,%ax
 35b:	a3 00 00 e8 2c 00 e8 	movabs %ax,0xc3e8002ce80000
 362:	c3 00 
 364:	66 31 c0             	xor    %eax,%eax
 367:	a0 00 00 83 c0 40 05 	movabs 0x440540c0830000,%al
 36e:	44 00 
 370:	6b c0 20             	imul   $0x20,%ax,%ax
 373:	8e c0                	mov    %ax,%es
 375:	66 6b c0 10          	imul   $0x10,%eax,%eax
 379:	66 a3 00 00 bf 00 00 	movabs %eax,0xbe0000bf0000
 380:	be 00 00 
 383:	b9 18 00             	mov    $0x18,%cx
 386:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
 388:	31 c0                	xor    %ax,%ax
 38a:	8e c0                	mov    %ax,%es
 38c:	c3                   	ret    

000000000000038d <read32bitLinux>:
 38d:	66 a1 00 00 66 ba 00 	movabs 0xba660000,%eax
 394:	00 00 00 
 397:	66 bb 20 00 00 00    	mov    $0x20,%ebx
 39d:	66 f7 f3             	div    %ebx
 3a0:	66 83 fa 00          	cmp    $0x0,%edx
 3a4:	74 02                	je     3a8 <read32bitLinux+0x1b>
 3a6:	66 40                	data32 rex
 3a8:	66 3d ff ff 00 00    	cmp    $0xffff,%eax
 3ae:	72 08                	jb     3b8 <read32bitLinux+0x2b>
 3b0:	be 00 00             	mov    $0x0,%si
 3b3:	e8 6b fc             	call   21 <errmsg>
 3b6:	eb fe                	jmp    3b6 <read32bitLinux+0x29>
 3b8:	a3 00 00 66 31 c0 a0 	movabs %ax,0xa0c031660000
 3bf:	00 00 
 3c1:	66 03 06             	add    (%rsi),%eax
 3c4:	00 00                	add    %al,(%rax)
 3c6:	66                   	data32
 3c7:	a3                   	.byte 0xa3
 3c8:	00 00                	add    %al,(%rax)
 3ca:	e8 8e 00             	call   45b <readAndMove>
 3cd:	c3                   	ret    

00000000000003ce <setInitRdFlags>:
 3ce:	66 a1 00 00 66 8b 1e 	movabs 0x6600001e8b660000,%eax
 3d5:	00 00 66 
 3d8:	03 1e                	add    (%rsi),%bx
 3da:	00 00                	add    %al,(%rax)
 3dc:	66 69 db 00 02 00 00 	imul   $0x200,%ebx,%ebx
 3e3:	71 08                	jno    3ed <setInitRdFlags+0x1f>
 3e5:	be 00 00             	mov    $0x0,%si
 3e8:	e8 36 fc             	call   21 <errmsg>
 3eb:	eb fe                	jmp    3eb <setInitRdFlags+0x1d>
 3ed:	66 03 1e             	add    (%rsi),%ebx
 3f0:	00 00                	add    %al,(%rax)
 3f2:	66 39 d8             	cmp    %ebx,%eax
 3f5:	77 08                	ja     3ff <setInitRdFlags+0x31>
 3f7:	be 00 00             	mov    $0x0,%si
 3fa:	e8 24 fc             	call   21 <errmsg>
 3fd:	eb fe                	jmp    3fd <setInitRdFlags+0x2f>
 3ff:	66 31 d2             	xor    %edx,%edx
 402:	66 a1 00 00 66 03 06 	movabs 0x6600000603660000,%eax
 409:	00 00 66 
 40c:	69 c0 00 02          	imul   $0x200,%ax,%ax
 410:	00 00                	add    %al,(%rax)
 412:	71 06                	jno    41a <setInitRdFlags+0x4c>
 414:	be 00 00             	mov    $0x0,%si
 417:	e8 07 fc             	call   21 <errmsg>
 41a:	66 a3 00 00 66 a1 00 	movabs %eax,0xa3660000a1660000
 421:	00 66 a3 
 424:	00 00                	add    %al,(%rax)
 426:	c3                   	ret    

0000000000000427 <readInitrd>:
 427:	31 c0                	xor    %ax,%ax
 429:	66 a1 00 00 66 a3 00 	movabs 0x9ae80000a3660000,%eax
 430:	00 e8 9a 
 433:	ff 66 a1             	jmp    *-0x5f(%rsi)
 436:	00 00                	add    %al,(%rax)
 438:	66 a3 00 00 66 a1 00 	movabs %eax,0xa3660000a1660000
 43f:	00 66 a3 
 442:	00 00                	add    %al,(%rax)
 444:	e8 14 00             	call   45b <readAndMove>
 447:	66 a1 00 00 66 a3 00 	movabs 0xa1660000a3660000,%eax
 44e:	00 66 a1 
 451:	00 00                	add    %al,(%rax)
 453:	66                   	data32
 454:	a3                   	.byte 0xa3
 455:	00 00                	add    %al,(%rax)
 457:	e8 01 00             	call   45b <readAndMove>
 45a:	c3                   	ret    

000000000000045b <readAndMove>:
 45b:	66 31 c0             	xor    %eax,%eax
 45e:	a1 00 00 bb 00 00 e8 	movabs 0x67e80000bb0000,%ax
 465:	67 00 
 467:	31 c0                	xor    %ax,%ax
 469:	8e c0                	mov    %ax,%es

000000000000046b <readandMoveLoop>:
 46b:	c7 06 00 00          	movw   $0x0,(%rsi)
 46f:	7f 00                	jg     471 <readandMoveLoop+0x6>
 471:	e8 72 fc             	call   e6 <readFromHardDrive>
 474:	66 a1 00 00 bb 00 00 	movabs 0x50e80000bb0000,%eax
 47b:	e8 50 00 
 47e:	fa                   	cli    
 47f:	1e                   	(bad)  
 480:	06                   	(bad)  
 481:	0f 01 16             	lgdt   (%rsi)
 484:	00 00                	add    %al,(%rax)
 486:	0f 20 c0             	mov    %cr0,%rax
 489:	0c 01                	or     $0x1,%al
 48b:	0f 22 c0             	mov    %rax,%cr0
 48e:	bb 08 00             	mov    $0x8,%bx
 491:	8e db                	mov    %bx,%ds
 493:	d1 e3                	shl    %bx
 495:	8e c3                	mov    %bx,%es
 497:	66 b9 00 fe 00 00    	mov    $0xfe00,%ecx
 49d:	66 31 f6             	xor    %esi,%esi
 4a0:	66 31 ff             	xor    %edi,%edi
 4a3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
 4a5:	24 fe                	and    $0xfe,%al
 4a7:	0f 22 c0             	mov    %rax,%cr0
 4aa:	1f                   	(bad)  
 4ab:	07                   	(bad)  
 4ac:	fb                   	sti    
 4ad:	66 81 06 00 00 00 fe 	addl   $0xfe000000,(%rsi)
 4b4:	00 00                	add    %al,(%rax)
 4b6:	73 08                	jae    4c0 <readandMoveLoop+0x55>
 4b8:	be 00 00             	mov    $0x0,%si
 4bb:	e8 63 fb             	call   21 <errmsg>
 4be:	eb fe                	jmp    4be <readandMoveLoop+0x53>
 4c0:	66 83 06 00          	addl   $0x0,(%rsi)
 4c4:	00 7f 83             	add    %bh,-0x7d(%rdi)
 4c7:	2e 00 00             	add    %al,%cs:(%rax)
 4ca:	7f 77                	jg     543 <check_a20+0x1e>
 4cc:	9e                   	sahf   
 4cd:	c3                   	ret    

00000000000004ce <setDescriptorBase>:
 4ce:	89 47 02             	mov    %ax,0x2(%rdi)
 4d1:	66 c1 e8 10          	shr    $0x10,%eax
 4d5:	88 47 04             	mov    %al,0x4(%rdi)
 4d8:	88 67 07             	mov    %ah,0x7(%rdi)
 4db:	c3                   	ret    

00000000000004dc <enablea20>:
 4dc:	e8 46 00             	call   525 <check_a20>
 4df:	83 f8 01             	cmp    $0x1,%ax
 4e2:	75 07                	jne    4eb <enablea20+0xf>
 4e4:	be 00 00             	mov    $0x0,%si
 4e7:	e8 51 fb             	call   3b <BIOSprint>
 4ea:	c3                   	ret    
 4eb:	b9 00 00             	mov    $0x0,%cx

00000000000004ee <activatea20Loop>:
 4ee:	89 ce                	mov    %cx,%si
 4f0:	8b 34 e8             	mov    (%rax,%rbp,8),%si
 4f3:	46 fb                	rex.RX sti 
 4f5:	83 c1 02             	add    $0x2,%cx
 4f8:	89 ce                	mov    %cx,%si
 4fa:	8b 04 ff             	mov    (%rdi,%rdi,8),%ax
 4fd:	d0 83 c1 02 e8 21    	rolb   0x21e802c1(%rbx)
 503:	00 83 f8 01 74 0e    	add    %al,0xe7401f8(%rbx)
 509:	be 00 00             	mov    $0x0,%si
 50c:	e8 2c fb             	call   3b <BIOSprint>
 50f:	81 f9 00 00          	cmp    $0x0,%cx
 513:	77 09                	ja     51e <activatea20failed>
 515:	eb d7                	jmp    4ee <activatea20Loop>

0000000000000517 <a20done>:
 517:	be 00 00             	mov    $0x0,%si
 51a:	e8 1e fb             	call   3b <BIOSprint>
 51d:	c3                   	ret    

000000000000051e <activatea20failed>:
 51e:	be 00 00             	mov    $0x0,%si
 521:	e8 17 fb             	call   3b <BIOSprint>
 524:	c3                   	ret    

0000000000000525 <check_a20>:
 525:	9c                   	pushf  
 526:	1e                   	(bad)  
 527:	06                   	(bad)  
 528:	57                   	push   %di
 529:	56                   	push   %si
 52a:	fa                   	cli    
 52b:	31 c0                	xor    %ax,%ax
 52d:	8e c0                	mov    %ax,%es
 52f:	f7 d0                	not    %ax
 531:	8e d8                	mov    %ax,%ds
 533:	bf 00 05             	mov    $0x500,%di
 536:	be 10 05             	mov    $0x510,%si
 539:	26 8a 05 50 8a 04 50 	mov    %es:0x50048a50(%rip),%al        # 50048f90 <secondStage_end_addr+0x50040790>
 540:	26 c6 05 00 c6 04 ff 	movb   $0x26,%es:-0xfb3a00(%rip)        # ffffffffff04cb48 <secondStage_end_addr+0xffffffffff044348>
 547:	26 
 548:	80 3d ff 58 88 04 58 	cmpb   $0x58,0x48858ff(%rip)        # 4885e4e <secondStage_end_addr+0x487d64e>
 54f:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8(%rip)        # 7400060e <secondStage_end_addr+0x73ff7e0e>
 556:	03                   	.byte 0x3
 557:	b8 01 00             	mov    $0x1,%ax

000000000000055a <check_a20_exit>:
 55a:	5e                   	pop    %si
 55b:	5f                   	pop    %di
 55c:	07                   	(bad)  
 55d:	1f                   	(bad)  
 55e:	9d                   	popf   
 55f:	c3                   	ret    

0000000000000560 <fasta20enable>:
 560:	e4 92                	in     $0x92,%al
 562:	a8 02                	test   $0x2,%al
 564:	75 06                	jne    56c <fasta20enable+0xc>
 566:	0c 02                	or     $0x2,%al
 568:	24 fe                	and    $0xfe,%al
 56a:	e6 92                	out    %al,$0x92
 56c:	c3                   	ret    

000000000000056d <keyboarda20enable>:
 56d:	fa                   	cli    
 56e:	e8 2e 00             	call   59f <a20wait>
 571:	b0 ad                	mov    $0xad,%al
 573:	e6 64                	out    %al,$0x64
 575:	e8 27 00             	call   59f <a20wait>
 578:	b0 d0                	mov    $0xd0,%al
 57a:	e6 64                	out    %al,$0x64
 57c:	e8 27 00             	call   5a6 <a20wait2>
 57f:	e4 60                	in     $0x60,%al
 581:	66 50                	data32 push %rax
 583:	e8 19 00             	call   59f <a20wait>
 586:	b0 d1                	mov    $0xd1,%al
 588:	e6 64                	out    %al,$0x64
 58a:	e8 12 00             	call   59f <a20wait>
 58d:	66 58                	data32 pop %rax
 58f:	0c 02                	or     $0x2,%al
 591:	e6 60                	out    %al,$0x60
 593:	e8 09 00             	call   59f <a20wait>
 596:	b0 ae                	mov    $0xae,%al
 598:	e6 64                	out    %al,$0x64
 59a:	e8 02 00             	call   59f <a20wait>
 59d:	fb                   	sti    
 59e:	c3                   	ret    

000000000000059f <a20wait>:
 59f:	e4 64                	in     $0x64,%al
 5a1:	a8 02                	test   $0x2,%al
 5a3:	75 fa                	jne    59f <a20wait>
 5a5:	c3                   	ret    

00000000000005a6 <a20wait2>:
 5a6:	e4 64                	in     $0x64,%al
 5a8:	a8 01                	test   $0x1,%al
 5aa:	74 fa                	je     5a6 <a20wait2>
 5ac:	c3                   	ret    

00000000000005ad <biosa20enable>:
 5ad:	51                   	push   %cx
 5ae:	b8 03 24             	mov    $0x2403,%ax
 5b1:	cd 15                	int    $0x15
 5b3:	72 2e                	jb     5e3 <biosa20enable+0x36>
 5b5:	80 fc 00             	cmp    $0x0,%ah
 5b8:	75 29                	jne    5e3 <biosa20enable+0x36>
 5ba:	b8 02 24             	mov    $0x2402,%ax
 5bd:	cd 15                	int    $0x15
 5bf:	72 1c                	jb     5dd <biosa20enable+0x30>
 5c1:	80 fc 00             	cmp    $0x0,%ah
 5c4:	75 17                	jne    5dd <biosa20enable+0x30>
 5c6:	3a 06                	cmp    (%rsi),%al
 5c8:	01 00                	add    %ax,(%rax)
 5ca:	74 0c                	je     5d8 <biosa20enable+0x2b>
 5cc:	b8 01 24             	mov    $0x2401,%ax
 5cf:	cd 15                	int    $0x15
 5d1:	72 0a                	jb     5dd <biosa20enable+0x30>
 5d3:	80 fc 00             	cmp    $0x0,%ah
 5d6:	75 05                	jne    5dd <biosa20enable+0x30>
 5d8:	b8 01 00             	mov    $0x1,%ax
 5db:	eb 09                	jmp    5e6 <biosa20enableret>
 5dd:	be 00 00             	mov    $0x0,%si
 5e0:	e8 58 fa             	call   3b <BIOSprint>
 5e3:	b8 00 00             	mov    $0x0,%ax

00000000000005e6 <biosa20enableret>:
 5e6:	59                   	pop    %cx
 5e7:	c3                   	ret    

00000000000005e8 <readMemorySize>:
 5e8:	66 ba 50 41 4d 53    	mov    $0x534d4150,%edx
 5ee:	66 bb 00 00 00 00    	mov    $0x0,%ebx

00000000000005f4 <loop_again>:
 5f4:	66 b8 20 e8 00 00    	mov    $0xe820,%eax
 5fa:	66 b9 14 00 00 00    	mov    $0x14,%ecx
 600:	bf 00 00             	mov    $0x0,%di
 603:	cd 15                	int    $0x15
 605:	73 08                	jae    60f <loop_again+0x1b>
 607:	be 00 00             	mov    $0x0,%si
 60a:	e8 14 fa             	call   21 <errmsg>
 60d:	eb fe                	jmp    60d <loop_again+0x19>
 60f:	66 3d 50 41 4d 53    	cmp    $0x534d4150,%eax
 615:	74 08                	je     61f <loop_again+0x2b>
 617:	be 00 00             	mov    $0x0,%si
 61a:	e8 04 fa             	call   21 <errmsg>
 61d:	eb fe                	jmp    61d <loop_again+0x29>
 61f:	66 83 f9 14          	cmp    $0x14,%ecx
 623:	74 08                	je     62d <loop_again+0x39>
 625:	be 00 00             	mov    $0x0,%si
 628:	e8 f6 f9             	call   21 <errmsg>
 62b:	eb fe                	jmp    62b <loop_again+0x37>
 62d:	66 53                	data32 push %rbx
 62f:	b8 00 00             	mov    $0x0,%ax
 632:	e8 4d fa             	call   82 <printQWORD>
 635:	b8 00 00             	mov    $0x0,%ax
 638:	e8 47 fa             	call   82 <printQWORD>
 63b:	b8 00 00             	mov    $0x0,%ax
 63e:	e8 39 fa             	call   7a <printDWORD>
 641:	e8 fd f9             	call   41 <newline>
 644:	66 5b                	data32 pop %rbx
 646:	66 83 fb 00          	cmp    $0x0,%ebx
 64a:	74 02                	je     64e <memmapexit>
 64c:	eb a6                	jmp    5f4 <loop_again>

000000000000064e <memmapexit>:
 64e:	c3                   	ret    

000000000000064f <faileda20>:
 64f:	2e 2e 2e 20 73 6f    	cs cs and %dh,%cs:0x6f(%rbx)
 655:	6d                   	insw   (%dx),%es:(%rdi)
 656:	65 74 68             	gs je  6c1 <keyboarda20+0x15>
 659:	69 6e 67 20 77       	imul   $0x7720,0x67(%rsi),%bp
 65e:	65 6e                	outsb  %gs:(%rsi),(%dx)
 660:	74 20                	je     682 <a20attemptsend+0xd>
 662:	77 72                	ja     6d6 <fasta20+0x3>
 664:	6f                   	outsw  %ds:(%rsi),(%dx)
 665:	6e                   	outsb  %ds:(%rsi),(%dx)
 666:	67 20 00             	and    %al,(%eax)

0000000000000669 <a20attempts>:
	...

0000000000000675 <a20attemptsend>:
 675:	41 32 30             	xor    (%r8),%sil
 678:	20 65 6e             	and    %ah,0x6e(%rbp)
 67b:	61                   	(bad)  
 67c:	62                   	(bad)  
 67d:	6c                   	insb   (%dx),%es:(%rdi)
 67e:	65 64 20 6f 6e       	gs and %ch,%fs:0x6e(%rdi)
 683:	20 62 6f             	and    %ah,0x6f(%rdx)
 686:	6f                   	outsw  %ds:(%rsi),(%dx)
 687:	74 00                	je     689 <biosa20>

0000000000000689 <biosa20>:
 689:	41 74 74             	rex.B je 700 <enabledmsg+0x3>
 68c:	65 6d                	gs insw (%dx),%es:(%rdi)
 68e:	70 74                	jo     704 <enabledmsg+0x7>
 690:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 695:	6f                   	outsw  %ds:(%rsi),(%dx)
 696:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 69a:	6e                   	outsb  %ds:(%rsi),(%dx)
 69b:	20 6f 6e             	and    %ch,0x6e(%rdi)
 69e:	20 61 32             	and    %ah,0x32(%rcx)
 6a1:	30 20                	xor    %ah,(%rax)
 6a3:	76 69                	jbe    70e <enabledmsg+0x11>
 6a5:	61                   	(bad)  
 6a6:	20 42 49             	and    %al,0x49(%rdx)
 6a9:	4f 53                	rex.WRXB push %r11
	...

00000000000006ac <keyboarda20>:
 6ac:	41 74 74             	rex.B je 723 <notenabledmsg+0x8>
 6af:	65 6d                	gs insw (%dx),%es:(%rdi)
 6b1:	70 74                	jo     727 <notenabledmsg+0xc>
 6b3:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 6b8:	6f                   	outsw  %ds:(%rsi),(%dx)
 6b9:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 6bd:	6e                   	outsb  %ds:(%rsi),(%dx)
 6be:	20 6f 6e             	and    %ch,0x6e(%rdi)
 6c1:	20 61 32             	and    %ah,0x32(%rcx)
 6c4:	30 20                	xor    %ah,(%rax)
 6c6:	76 69                	jbe    731 <a20disabled>
 6c8:	61                   	(bad)  
 6c9:	20 6b 65             	and    %ch,0x65(%rbx)
 6cc:	79 62                	jns    730 <notenabledmsg+0x15>
 6ce:	6f                   	outsw  %ds:(%rsi),(%dx)
 6cf:	61                   	(bad)  
 6d0:	72 64                	jb     736 <a20disabled+0x5>
	...

00000000000006d3 <fasta20>:
 6d3:	41 74 74             	rex.B je 74a <msgMemSizeFailed+0x7>
 6d6:	65 6d                	gs insw (%dx),%es:(%rdi)
 6d8:	70 74                	jo     74e <msgMemSizeFailed+0xb>
 6da:	69 6e 67 20 74       	imul   $0x7420,0x67(%rsi),%bp
 6df:	6f                   	outsw  %ds:(%rsi),(%dx)
 6e0:	20 74 75 72          	and    %dh,0x72(%rbp,%rsi,2)
 6e4:	6e                   	outsb  %ds:(%rsi),(%dx)
 6e5:	20 6f 6e             	and    %ch,0x6e(%rdi)
 6e8:	20 61 32             	and    %ah,0x32(%rcx)
 6eb:	30 20                	xor    %ah,(%rax)
 6ed:	76 69                	jbe    758 <msgMemSizeFailed+0x15>
 6ef:	61                   	(bad)  
 6f0:	20 66 61             	and    %ah,0x61(%rsi)
 6f3:	73 74                	jae    769 <memmap_start+0xb>
 6f5:	20 6d 65             	and    %ch,0x65(%rbp)
 6f8:	74 68                	je     762 <memmap_start+0x4>
 6fa:	6f                   	outsw  %ds:(%rsi),(%dx)
 6fb:	64                   	fs
	...

00000000000006fd <enabledmsg>:
 6fd:	2e 2e 2e 20 20       	cs cs and %ah,%cs:(%rax)
 702:	77 6f                	ja     773 <availSpace+0x1>
 704:	72 6b                	jb     771 <memmap_start+0x13>
 706:	65 64 21 0d 0a 41 32 	gs and %cx,%fs:0x3032410a(%rip)        # 30324818 <secondStage_end_addr+0x3031c018>
 70d:	30 
 70e:	20 69 73             	and    %ch,0x73(%rcx)
 711:	20 65 6e             	and    %ah,0x6e(%rbp)
 714:	61                   	(bad)  
 715:	62                   	(bad)  
 716:	6c                   	insb   (%dx),%es:(%rdi)
 717:	65 64 21 00          	gs and %ax,%fs:(%rax)

000000000000071b <notenabledmsg>:
 71b:	2e 2e 2e 20 20       	cs cs and %ah,%cs:(%rax)
 720:	64 69 64 6e 27 74 20 	imul   $0x2074,%fs:0x27(%rsi,%rbp,2),%sp
 727:	77 6f                	ja     798 <msgTooMuchSpace+0x17>
 729:	72 6b                	jb     796 <msgTooMuchSpace+0x15>
 72b:	20 2e                	and    %ch,(%rsi)
 72d:	2e 0d 0a 00          	cs or  $0xa,%ax

0000000000000731 <a20disabled>:
 731:	41 32 30             	xor    (%r8),%sil
 734:	20 69 73             	and    %ch,0x73(%rcx)
 737:	20 64 69 73          	and    %ah,0x73(%rcx,%rbp,2)
 73b:	61                   	(bad)  
 73c:	62                   	(bad)  
 73d:	6c                   	insb   (%dx),%es:(%rdi)
 73e:	65 64 21 21          	gs and %sp,%fs:(%rcx)
	...

0000000000000743 <msgMemSizeFailed>:
 743:	67 65 74 74          	addr32 gs je 7bb <msgRamdiskNotZero+0x1f>
 747:	69 6e 67 20 6d       	imul   $0x6d20,0x67(%rsi),%bp
 74c:	65 6d                	gs insw (%dx),%es:(%rdi)
 74e:	6f                   	outsw  %ds:(%rsi),(%dx)
 74f:	72 79                	jb     7ca <msgRamdiskSizeNotZero+0xd>
 751:	20 73 69             	and    %dh,0x69(%rbx)
 754:	7a 65                	jp     7bb <msgRamdiskNotZero+0x1f>
 756:	20 66 61             	and    %ah,0x61(%rsi)
 759:	69                   	.byte 0x69
 75a:	6c                   	insb   (%dx),%es:(%rdi)
 75b:	65                   	gs
 75c:	64                   	fs
	...

000000000000075e <memmap_start>:
	...

0000000000000772 <availSpace>:
	...

0000000000000774 <linuxSetupSectors>:
	...

0000000000000775 <linuxProtectedSize>:
 775:	00 00                	add    %al,(%rax)
	...

0000000000000779 <protectedLoadAddr>:
 779:	00 00                	add    %al,(%rax)
 77b:	10 00                	adc    %al,(%rax)

000000000000077d <vmlinuz_block>:
 77d:	48 19 18             	sbb    %rbx,(%rax)
	...

0000000000000781 <msgTooMuchSpace>:
 781:	4f 76 65             	rex.WRXB jbe 7e9 <msgNoMagic+0xe>
 784:	72 66                	jb     7ec <msgBadVersion+0x2>
 786:	6c                   	insb   (%dx),%es:(%rdi)
 787:	6f                   	outsw  %ds:(%rsi),(%dx)
 788:	77 20                	ja     7aa <msgRamdiskNotZero+0xe>
 78a:	63 61 6c             	movslq 0x6c(%rcx),%sp
 78d:	63 75 6c             	movslq 0x6c(%rbp),%si
 790:	61                   	(bad)  
 791:	74 69                	je     7fc <msgBadVersion+0x12>
 793:	6e                   	outsb  %ds:(%rsi),(%dx)
 794:	67 20 73 70          	and    %dh,0x70(%ebx)
 798:	61                   	(bad)  
 799:	63 65 00             	movslq 0x0(%rbp),%sp

000000000000079c <msgRamdiskNotZero>:
 79c:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
 79e:	69 74 69 61 6c 20    	imul   $0x206c,0x61(%rcx,%rbp,2),%si
 7a4:	72 61                	jb     807 <msgNoSpace+0x6>
 7a6:	6d                   	insw   (%dx),%es:(%rdi)
 7a7:	64 69 73 6b 20 70    	imul   $0x7020,%fs:0x6b(%rbx),%si
 7ad:	6f                   	outsw  %ds:(%rsi),(%dx)
 7ae:	69 6e 74 65 72       	imul   $0x7265,0x74(%rsi),%bp
 7b3:	20 69 73             	and    %ch,0x73(%rcx)
 7b6:	20 6e 6f             	and    %ch,0x6f(%rsi)
 7b9:	74 20                	je     7db <msgNoMagic>
 7bb:	30 00                	xor    %al,(%rax)

00000000000007bd <msgRamdiskSizeNotZero>:
 7bd:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
 7bf:	69 74 69 61 6c 20    	imul   $0x206c,0x61(%rcx,%rbp,2),%si
 7c5:	72 61                	jb     828 <msgCMDtooLong+0x16>
 7c7:	6d                   	insw   (%dx),%es:(%rdi)
 7c8:	64 69 73 6b 20 73    	imul   $0x7320,%fs:0x6b(%rbx),%si
 7ce:	69 7a 65 20 69       	imul   $0x6920,0x65(%rdx),%di
 7d3:	73 20                	jae    7f5 <msgBadVersion+0xb>
 7d5:	6e                   	outsb  %ds:(%rsi),(%dx)
 7d6:	6f                   	outsw  %ds:(%rsi),(%dx)
 7d7:	74 20                	je     7f9 <msgBadVersion+0xf>
 7d9:	30 00                	xor    %al,(%rax)

00000000000007db <msgNoMagic>:
 7db:	6e                   	outsb  %ds:(%rsi),(%dx)
 7dc:	6f                   	outsw  %ds:(%rsi),(%dx)
 7dd:	20 6d 61             	and    %ch,0x61(%rbp)
 7e0:	67 69 63 20 6c 69    	imul   $0x696c,0x20(%ebx),%sp
 7e6:	6e                   	outsb  %ds:(%rsi),(%dx)
 7e7:	75 78                	jne    861 <msgCopyError+0x10>
	...

00000000000007ea <msgBadVersion>:
 7ea:	6f                   	outsw  %ds:(%rsi),(%dx)
 7eb:	6c                   	insb   (%dx),%es:(%rdi)
 7ec:	64 20 4c 69 6e       	and    %cl,%fs:0x6e(%rcx,%rbp,2)
 7f1:	75 78                	jne    86b <msgCopyError+0x1a>
 7f3:	20 62 6f             	and    %ah,0x6f(%rdx)
 7f6:	6f                   	outsw  %ds:(%rsi),(%dx)
 7f7:	74 20                	je     819 <msgCMDtooLong+0x7>
 7f9:	76 65                	jbe    860 <msgCopyError+0xf>
 7fb:	72 73                	jb     870 <msgCopyError+0x1f>
 7fd:	69                   	.byte 0x69
 7fe:	6f                   	outsw  %ds:(%rsi),(%dx)
 7ff:	6e                   	outsb  %ds:(%rsi),(%dx)
	...

0000000000000801 <msgNoSpace>:
 801:	6e                   	outsb  %ds:(%rsi),(%dx)
 802:	6f                   	outsw  %ds:(%rsi),(%dx)
 803:	74 20                	je     825 <msgCMDtooLong+0x13>
 805:	65 6e                	outsb  %gs:(%rsi),(%dx)
 807:	6f                   	outsw  %ds:(%rsi),(%dx)
 808:	75 67                	jne    871 <msgCopyError+0x20>
 80a:	68 20 73             	push   $0x7320
 80d:	70 61                	jo     870 <msgCopyError+0x1f>
 80f:	63 65 00             	movslq 0x0(%rbp),%sp

0000000000000812 <msgCMDtooLong>:
 812:	6c                   	insb   (%dx),%es:(%rdi)
 813:	69 6e 75 78 20       	imul   $0x2078,0x75(%rsi),%bp
 818:	63 6f 6d             	movslq 0x6d(%rdi),%bp
 81b:	6d                   	insw   (%dx),%es:(%rdi)
 81c:	61                   	(bad)  
 81d:	6e                   	outsb  %ds:(%rsi),(%dx)
 81e:	64 20 6c 69 6e       	and    %ch,%fs:0x6e(%rcx,%rbp,2)
 823:	65 20 74 6f 6f       	and    %dh,%gs:0x6f(%rdi,%rbp,2)
 828:	20 6c 61 72          	and    %ch,0x72(%rcx,%riz,2)
 82c:	67                   	addr32
 82d:	65                   	gs
	...

000000000000082f <msgTooMuchProtected>:
 82f:	74 6f                	je     8a0 <msgHandleLargerAddresses+0x21>
 831:	6f                   	outsw  %ds:(%rsi),(%dx)
 832:	20 6d 75             	and    %ch,0x75(%rbp)
 835:	63 68 20             	movslq 0x20(%rax),%bp
 838:	70 72                	jo     8ac <msgNeedReadPartial+0x6>
 83a:	6f                   	outsw  %ds:(%rsi),(%dx)
 83b:	74 65                	je     8a2 <msgHandleLargerAddresses+0x23>
 83d:	63 74 65 64          	movslq 0x64(%rbp,%riz,2),%si
 841:	20 6b 65             	and    %ch,0x65(%rbx)
 844:	72 6e                	jb     8b4 <msgNeedReadPartial+0xe>
 846:	65 6c                	gs insb (%dx),%es:(%rdi)
 848:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
 84c:	72 65                	jb     8b3 <msgNeedReadPartial+0xd>
 84e:	61                   	(bad)  
 84f:	64                   	fs
	...

0000000000000851 <msgCopyError>:
 851:	69 6e 74 65 72       	imul   $0x7265,0x74(%rsi),%bp
 856:	72 75                	jb     8cd <msgShouldNotReach+0x7>
 858:	70 74                	jo     8ce <msgShouldNotReach+0x8>
 85a:	20 66 61             	and    %ah,0x61(%rsi)
 85d:	69 6c 75 72 65 20    	imul   $0x2065,0x72(%rbp,%rsi,2),%bp
 863:	6d                   	insw   (%dx),%es:(%rdi)
 864:	6f                   	outsw  %ds:(%rsi),(%dx)
 865:	76 69                	jbe    8d0 <msgShouldNotReach+0xa>
 867:	6e                   	outsb  %ds:(%rsi),(%dx)
 868:	67 20 70 72          	and    %dh,0x72(%eax)
 86c:	6f                   	outsw  %ds:(%rsi),(%dx)
 86d:	74 65                	je     8d4 <msgShouldNotReach+0xe>
 86f:	63 74 65 64          	movslq 0x64(%rbp,%riz,2),%si
 873:	20 6d 6f             	and    %ch,0x6f(%rbp)
 876:	64 65 20 62 79       	fs and %ah,%gs:0x79(%rdx)
 87b:	74 65                	je     8e2 <msgShouldNotReach+0x1c>
 87d:	73 00                	jae    87f <msgHandleLargerAddresses>

000000000000087f <msgHandleLargerAddresses>:
 87f:	4c 6f                	rex.WR outsl %ds:(%rsi),(%dx)
 881:	61                   	(bad)  
 882:	64 20 61 64          	and    %ah,%fs:0x64(%rcx)
 886:	64 72 65             	fs jb  8ee <msgGetSet+0x9>
 889:	73 73                	jae    8fe <msgGetSet+0x19>
 88b:	20 74 6f 6f          	and    %dh,0x6f(%rdi,%rbp,2)
 88f:	20 68 69             	and    %ch,0x69(%rax)
 892:	67 68 20 66          	addr32 push $0x6620
 896:	6f                   	outsw  %ds:(%rsi),(%dx)
 897:	72 20                	jb     8b9 <msgNeedReadPartial+0x13>
 899:	31 36                	xor    %si,(%rsi)
 89b:	20 62 69             	and    %ah,0x69(%rdx)
 89e:	74 20                	je     8c0 <msgNeedReadPartial+0x1a>
 8a0:	76 61                	jbe    903 <msgInitrdOverflowAddr+0x4>
 8a2:	6c                   	insb   (%dx),%es:(%rdi)
 8a3:	75 65                	jne    90a <msgInitrdOverflowAddr+0xb>
	...

00000000000008a6 <msgNeedReadPartial>:
 8a6:	43 61                	rex.XB (bad) 
 8a8:	6e                   	outsb  %ds:(%rsi),(%dx)
 8a9:	27                   	(bad)  
 8aa:	74 20                	je     8cc <msgShouldNotReach+0x6>
 8ac:	75 73                	jne    921 <msgInitrdOverflowAddr+0x22>
 8ae:	65 20 30             	and    %dh,%gs:(%rax)
 8b1:	78 37                	js     8ea <msgGetSet+0x5>
 8b3:	66 20 62 6c          	data32 and %ah,0x6c(%rdx)
 8b7:	6f                   	outsw  %ds:(%rsi),(%dx)
 8b8:	63 6b 20             	movslq 0x20(%rbx),%bp
 8bb:	73 69                	jae    926 <msgInitrdOverflowAddr+0x27>
 8bd:	7a 65                	jp     924 <msgInitrdOverflowAddr+0x25>
 8bf:	20 72 65             	and    %dh,0x65(%rdx)
 8c2:	61                   	(bad)  
 8c3:	64 73 00             	fs jae 8c6 <msgShouldNotReach>

00000000000008c6 <msgShouldNotReach>:
 8c6:	53                   	push   %bx
 8c7:	68 6f 75             	push   $0x756f
 8ca:	6c                   	insb   (%dx),%es:(%rdi)
 8cb:	64 20 6e 6f          	and    %ch,%fs:0x6f(%rsi)
 8cf:	74 20                	je     8f1 <msgGetSet+0xc>
 8d1:	72 65                	jb     938 <msgInitrdLowAddr+0x10>
 8d3:	61                   	(bad)  
 8d4:	63 68 20             	movslq 0x20(%rax),%bp
 8d7:	74 68                	je     941 <msgInitrdLowAddr+0x19>
 8d9:	69 73 20 70 6f       	imul   $0x6f70,0x20(%rbx),%si
 8de:	73 69                	jae    949 <msgInitrdLowAddr+0x21>
 8e0:	74 69                	je     94b <msgInitrdLowAddr+0x23>
 8e2:	6f                   	outsw  %ds:(%rsi),(%dx)
 8e3:	6e                   	outsb  %ds:(%rsi),(%dx)
	...

00000000000008e5 <msgGetSet>:
 8e5:	52                   	push   %dx
 8e6:	65 61                	gs (bad) 
 8e8:	64 79 20             	fs jns 90b <msgInitrdOverflowAddr+0xc>
 8eb:	2e 2e 2e 20 53 65    	cs cs and %dl,%cs:0x65(%rbx)
 8f1:	74 20                	je     913 <msgInitrdOverflowAddr+0x14>
 8f3:	2e 2e 2e 20 47 6f    	cs cs and %al,%cs:0x6f(%rdi)
 8f9:	21 21                	and    %sp,(%rcx)
 8fb:	21 0a                	and    %cx,(%rdx)
 8fd:	0d                   	.byte 0xd
	...

00000000000008ff <msgInitrdOverflowAddr>:
 8ff:	47 75 65             	rex.RXB jne 967 <msgInitrdTooLarge+0x14>
 902:	73 73                	jae    977 <msgMoveTooMuch+0x3>
 904:	65 64 20 6c 6f 61    	gs and %ch,%fs:0x61(%rdi,%rbp,2)
 90a:	64 20 61 64          	and    %ah,%fs:0x64(%rcx)
 90e:	64 72 65             	fs jb  976 <msgMoveTooMuch+0x2>
 911:	73 73                	jae    986 <msgMoveTooMuch+0x12>
 913:	20 6f 66             	and    %ch,0x66(%rdi)
 916:	20 69 6e             	and    %ch,0x6e(%rcx)
 919:	69 74 72 64 20 6f    	imul   $0x6f20,0x64(%rdx,%rsi,2),%si
 91f:	76 65                	jbe    986 <msgMoveTooMuch+0x12>
 921:	72 66                	jb     989 <msgMoveTooMuch+0x15>
 923:	6c                   	insb   (%dx),%es:(%rdi)
 924:	6f                   	outsw  %ds:(%rsi),(%dx)
 925:	77 73                	ja     99a <msgSegmentOverflow+0x7>
	...

0000000000000928 <msgInitrdLowAddr>:
 928:	47 75 65             	rex.RXB jne 990 <msgMoveTooMuch+0x1c>
 92b:	73 73                	jae    9a0 <msgSegmentOverflow+0xd>
 92d:	65 64 20 6c 6f 61    	gs and %ch,%fs:0x61(%rdi,%rbp,2)
 933:	64 20 61 64          	and    %ah,%fs:0x64(%rcx)
 937:	64 72 65             	fs jb  99f <msgSegmentOverflow+0xc>
 93a:	73 73                	jae    9af <msgSegmentOverflow+0x1c>
 93c:	20 6f 66             	and    %ch,0x66(%rdi)
 93f:	20 69 6e             	and    %ch,0x6e(%rcx)
 942:	69 74 72 64 20 69    	imul   $0x6920,0x64(%rdx,%rsi,2),%si
 948:	73 20                	jae    96a <msgInitrdTooLarge+0x17>
 94a:	74 6f                	je     9bb <msgSegmentOverflow+0x28>
 94c:	6f                   	outsw  %ds:(%rsi),(%dx)
 94d:	20 68 69             	and    %ch,0x69(%rax)
 950:	67                   	addr32
 951:	68                   	.byte 0x68
	...

0000000000000953 <msgInitrdTooLarge>:
 953:	4f 76 65             	rex.WRXB jbe 9bb <msgSegmentOverflow+0x28>
 956:	72 66                	jb     9be <msgSegmentOverflow+0x2b>
 958:	6c                   	insb   (%dx),%es:(%rdi)
 959:	6f                   	outsw  %ds:(%rsi),(%dx)
 95a:	77 20                	ja     97c <msgMoveTooMuch+0x8>
 95c:	63 61 6c             	movslq 0x6c(%rcx),%sp
 95f:	63 75 6c             	movslq 0x6c(%rbp),%si
 962:	61                   	(bad)  
 963:	74 69                	je     9ce <msgSegmentProblem+0x8>
 965:	6e                   	outsb  %ds:(%rsi),(%dx)
 966:	67 20 69 6e          	and    %ch,0x6e(%ecx)
 96a:	69 74 72 64 20 73    	imul   $0x7320,0x64(%rdx,%rsi,2),%si
 970:	69                   	.byte 0x69
 971:	7a 65                	jp     9d8 <msgSegmentProblem+0x12>
	...

0000000000000974 <msgMoveTooMuch>:
 974:	4f 76 65             	rex.WRXB jbe 9dc <msgSegmentProblem+0x16>
 977:	72 66                	jb     9df <msgSegmentProblem+0x19>
 979:	6c                   	insb   (%dx),%es:(%rdi)
 97a:	6f                   	outsw  %ds:(%rsi),(%dx)
 97b:	77 20                	ja     99d <msgSegmentOverflow+0xa>
 97d:	72 65                	jb     9e4 <msgSegmentProblem+0x1e>
 97f:	61                   	(bad)  
 980:	64 69 6e 67 20 26    	imul   $0x2620,%fs:0x67(%rsi),%bp
 986:	20 6d 6f             	and    %ch,0x6f(%rbp)
 989:	76 69                	jbe    9f4 <availTempSpace>
 98b:	6e                   	outsb  %ds:(%rsi),(%dx)
 98c:	67 20 64 61 74       	and    %ah,0x74(%ecx,%eiz,2)
 991:	61                   	(bad)  
	...

0000000000000993 <msgSegmentOverflow>:
 993:	53                   	push   %bx
 994:	75 62                	jne    9f8 <initrdLoadAddr+0x2>
 996:	74 72                	je     a0a <initrdSecondLength>
 998:	61                   	(bad)  
 999:	63 74 69 6e          	movslq 0x6e(%rcx,%rbp,2),%si
 99d:	67 20 6e 75          	and    %ch,0x75(%esi)
 9a1:	6d                   	insw   (%dx),%es:(%rdi)
 9a2:	62                   	(bad)  
 9a3:	65 72 20             	gs jb  9c6 <msgSegmentProblem>
 9a6:	6f                   	outsw  %ds:(%rsi),(%dx)
 9a7:	66 20 62 79          	data32 and %ah,0x79(%rdx)
 9ab:	74 65                	je     a12 <gdtinfo+0x4>
 9ad:	73 20                	jae    9cf <msgSegmentProblem+0x9>
 9af:	66 72 6f             	data32 jb a21 <datadesc+0x5>
 9b2:	6d                   	insw   (%dx),%es:(%rdi)
 9b3:	20 6d 6f             	and    %ch,0x6f(%rbp)
 9b6:	76 65                	jbe    a1d <datadesc+0x1>
 9b8:	44                   	rex.R
 9b9:	65 73 74             	gs jae a30 <linuxCmdLine>
 9bc:	20 6f 76             	and    %ch,0x76(%rdi)
 9bf:	65 72 66             	gs jb  a28 <extradesc+0x4>
 9c2:	6c                   	insb   (%dx),%es:(%rdi)
 9c3:	6f                   	outsw  %ds:(%rsi),(%dx)
 9c4:	77 00                	ja     9c6 <msgSegmentProblem>

00000000000009c6 <msgSegmentProblem>:
 9c6:	53                   	push   %bx
 9c7:	69 67 6e 20 73       	imul   $0x7320,0x6e(%rdi),%sp
 9cc:	65 74 20             	gs je  9ef <moveAddr+0x1>
 9cf:	61                   	(bad)  
 9d0:	66 74 65             	data32 je a38 <linuxCmdLine+0x8>
 9d3:	72 20                	jb     9f5 <availTempSpace+0x1>
 9d5:	61                   	(bad)  
 9d6:	72 69                	jb     a41 <linuxCmdLine+0x11>
 9d8:	74 68                	je     a42 <linuxCmdLine+0x12>
 9da:	6d                   	insw   (%dx),%es:(%rdi)
 9db:	65 74 69             	gs je  a47 <linuxCmdLine+0x17>
 9de:	63 20                	movslq (%rax),%sp
 9e0:	6f                   	outsw  %ds:(%rsi),(%dx)
 9e1:	6e                   	outsb  %ds:(%rsi),(%dx)
 9e2:	20 6d 6f             	and    %ch,0x6f(%rbp)
 9e5:	76 65                	jbe    a4c <linuxCmdLine+0x1c>
 9e7:	44                   	rex.R
 9e8:	65 73 74             	gs jae a5f <linuxCmdLine+0x2f>
	...

00000000000009ec <readAddr>:
	...

00000000000009ee <moveAddr>:
 9ee:	00 00                	add    %al,(%rax)
	...

00000000000009f2 <numSegments>:
	...

00000000000009f4 <availTempSpace>:
	...

00000000000009f6 <initrdLoadAddr>:
 9f6:	00 00                	add    %al,(%rax)
	...

00000000000009fa <initrdFirstBlock>:
 9fa:	00 08                	add    %cl,(%rax)
 9fc:	3d                   	.byte 0x3d
	...

00000000000009fe <initrdFirstLength>:
 9fe:	00 40 00             	add    %al,0x0(%rax)
	...

0000000000000a02 <initrdFirstLengthBytes>:
 a02:	00 00                	add    %al,(%rax)
 a04:	80                   	.byte 0x80
	...

0000000000000a06 <initrdSecondBlock>:
 a06:	00 4e 3d             	add    %cl,0x3d(%rsi)
	...

0000000000000a0a <initrdSecondLength>:
 a0a:	18 2f                	sbb    %ch,(%rdi)
	...

0000000000000a0e <gdtinfo>:
 a0e:	17                   	(bad)  
 a0f:	00 00                	add    %al,(%rax)
 a11:	00 00                	add    %al,(%rax)
	...

0000000000000a14 <gdt>:
	...

0000000000000a1c <datadesc>:
 a1c:	ff                   	(bad)  
 a1d:	ff 00                	incw   (%rax)
 a1f:	00 00                	add    %al,(%rax)
 a21:	93                   	xchg   %ax,%bx
 a22:	4f                   	rex.WRXB
	...

0000000000000a24 <extradesc>:
 a24:	ff                   	(bad)  
 a25:	ff 00                	incw   (%rax)
 a27:	00 00                	add    %al,(%rax)
 a29:	93                   	xchg   %ax,%bx
 a2a:	4f                   	rex.WRXB
	...

0000000000000a2c <gdt_end>:
 a2c:	00 00                	add    %al,(%rax)
 a2e:	10 00                	adc    %al,(%rax)

0000000000000a30 <linuxCmdLine>:
 a30:	64 65 62             	fs gs (bad) 
 a33:	75 67                	jne    a9c <linuxCmdLine+0x6c>
 a35:	20 72 6f             	and    %dh,0x6f(%rdx)
 a38:	6f                   	outsw  %ds:(%rsi),(%dx)
 a39:	74 3d                	je     a78 <linuxCmdLine+0x48>
 a3b:	2f                   	(bad)  
 a3c:	64 65 76 2f          	fs gs jbe a6f <linuxCmdLine+0x3f>
 a40:	73 64                	jae    aa6 <linuxCmdLine+0x76>
 a42:	61                   	(bad)  
 a43:	31 20                	xor    %sp,(%rax)
 a45:	72 6f                	jb     ab6 <linuxCmdLine+0x86>
 a47:	00 90 90 90 90 90    	add    %dl,-0x6f6f6f70(%rax)
 a4d:	90                   	nop
 a4e:	90                   	nop
 a4f:	90                   	nop
 a50:	90                   	nop
 a51:	90                   	nop
 a52:	90                   	nop
 a53:	90                   	nop
 a54:	90                   	nop
 a55:	90                   	nop
 a56:	90                   	nop
 a57:	90                   	nop
 a58:	90                   	nop
 a59:	90                   	nop
 a5a:	90                   	nop
 a5b:	90                   	nop
 a5c:	90                   	nop
 a5d:	90                   	nop
 a5e:	90                   	nop
 a5f:	90                   	nop
 a60:	90                   	nop
 a61:	90                   	nop
 a62:	90                   	nop
 a63:	90                   	nop
 a64:	90                   	nop
 a65:	90                   	nop
 a66:	90                   	nop
 a67:	90                   	nop
 a68:	90                   	nop
 a69:	90                   	nop
 a6a:	90                   	nop
 a6b:	90                   	nop
 a6c:	90                   	nop
 a6d:	90                   	nop
 a6e:	90                   	nop
 a6f:	90                   	nop
 a70:	90                   	nop
 a71:	90                   	nop
 a72:	90                   	nop
 a73:	90                   	nop
 a74:	90                   	nop
 a75:	90                   	nop
 a76:	90                   	nop
 a77:	90                   	nop
 a78:	90                   	nop
 a79:	90                   	nop
 a7a:	90                   	nop
 a7b:	90                   	nop
 a7c:	90                   	nop
 a7d:	90                   	nop
 a7e:	90                   	nop
 a7f:	90                   	nop
 a80:	90                   	nop
 a81:	90                   	nop
 a82:	90                   	nop
 a83:	90                   	nop
 a84:	90                   	nop
 a85:	90                   	nop
 a86:	90                   	nop
 a87:	90                   	nop
 a88:	90                   	nop
 a89:	90                   	nop
 a8a:	90                   	nop
 a8b:	90                   	nop
 a8c:	90                   	nop
 a8d:	90                   	nop
 a8e:	90                   	nop
 a8f:	90                   	nop
 a90:	90                   	nop
 a91:	90                   	nop
 a92:	90                   	nop
 a93:	90                   	nop
 a94:	90                   	nop
 a95:	90                   	nop
 a96:	90                   	nop
 a97:	90                   	nop
 a98:	90                   	nop
 a99:	90                   	nop
 a9a:	90                   	nop
 a9b:	90                   	nop
 a9c:	90                   	nop
 a9d:	90                   	nop
 a9e:	90                   	nop
 a9f:	90                   	nop
 aa0:	90                   	nop
 aa1:	90                   	nop
 aa2:	90                   	nop
 aa3:	90                   	nop
 aa4:	90                   	nop
 aa5:	90                   	nop
 aa6:	90                   	nop
 aa7:	90                   	nop
 aa8:	90                   	nop
 aa9:	90                   	nop
 aaa:	90                   	nop
 aab:	90                   	nop
 aac:	90                   	nop
 aad:	90                   	nop
 aae:	90                   	nop
 aaf:	90                   	nop
 ab0:	90                   	nop
 ab1:	90                   	nop
 ab2:	90                   	nop
 ab3:	90                   	nop
 ab4:	90                   	nop
 ab5:	90                   	nop
 ab6:	90                   	nop
 ab7:	90                   	nop
 ab8:	90                   	nop
 ab9:	90                   	nop
 aba:	90                   	nop
 abb:	90                   	nop
 abc:	90                   	nop
 abd:	90                   	nop
 abe:	90                   	nop
 abf:	90                   	nop
 ac0:	90                   	nop
 ac1:	90                   	nop
 ac2:	90                   	nop
 ac3:	90                   	nop
 ac4:	90                   	nop
 ac5:	90                   	nop
 ac6:	90                   	nop
 ac7:	90                   	nop
 ac8:	90                   	nop
 ac9:	90                   	nop
 aca:	90                   	nop
 acb:	90                   	nop
 acc:	90                   	nop
 acd:	90                   	nop
 ace:	90                   	nop
 acf:	90                   	nop
 ad0:	90                   	nop
 ad1:	90                   	nop
 ad2:	90                   	nop
 ad3:	90                   	nop
 ad4:	90                   	nop
 ad5:	90                   	nop
 ad6:	90                   	nop
 ad7:	90                   	nop
 ad8:	90                   	nop
 ad9:	90                   	nop
 ada:	90                   	nop
 adb:	90                   	nop
 adc:	90                   	nop
 add:	90                   	nop
 ade:	90                   	nop
 adf:	90                   	nop
 ae0:	90                   	nop
 ae1:	90                   	nop
 ae2:	90                   	nop
 ae3:	90                   	nop
 ae4:	90                   	nop
 ae5:	90                   	nop
 ae6:	90                   	nop
 ae7:	90                   	nop
 ae8:	90                   	nop
 ae9:	90                   	nop
 aea:	90                   	nop
 aeb:	90                   	nop
 aec:	90                   	nop
 aed:	90                   	nop
 aee:	90                   	nop
 aef:	90                   	nop
 af0:	90                   	nop
 af1:	90                   	nop
 af2:	90                   	nop
 af3:	90                   	nop
 af4:	90                   	nop
 af5:	90                   	nop
 af6:	90                   	nop
 af7:	90                   	nop
 af8:	90                   	nop
 af9:	90                   	nop
 afa:	90                   	nop
 afb:	90                   	nop
 afc:	90                   	nop
 afd:	90                   	nop
 afe:	90                   	nop
 aff:	90                   	nop
 b00:	90                   	nop
 b01:	90                   	nop
 b02:	90                   	nop
 b03:	90                   	nop
 b04:	90                   	nop
 b05:	90                   	nop
 b06:	90                   	nop
 b07:	90                   	nop
 b08:	90                   	nop
 b09:	90                   	nop
 b0a:	90                   	nop
 b0b:	90                   	nop
 b0c:	90                   	nop
 b0d:	90                   	nop
 b0e:	90                   	nop
 b0f:	90                   	nop
 b10:	90                   	nop
 b11:	90                   	nop
 b12:	90                   	nop
 b13:	90                   	nop
 b14:	90                   	nop
 b15:	90                   	nop
 b16:	90                   	nop
 b17:	90                   	nop
 b18:	90                   	nop
 b19:	90                   	nop
 b1a:	90                   	nop
 b1b:	90                   	nop
 b1c:	90                   	nop
 b1d:	90                   	nop
 b1e:	90                   	nop
 b1f:	90                   	nop
 b20:	90                   	nop
 b21:	90                   	nop
 b22:	90                   	nop
 b23:	90                   	nop
 b24:	90                   	nop
 b25:	90                   	nop
 b26:	90                   	nop
 b27:	90                   	nop
 b28:	90                   	nop
 b29:	90                   	nop
 b2a:	90                   	nop
 b2b:	90                   	nop
 b2c:	90                   	nop
 b2d:	90                   	nop
 b2e:	90                   	nop
 b2f:	90                   	nop
 b30:	90                   	nop
 b31:	90                   	nop
 b32:	90                   	nop
 b33:	90                   	nop
 b34:	90                   	nop
 b35:	90                   	nop
 b36:	90                   	nop
 b37:	90                   	nop
 b38:	90                   	nop
 b39:	90                   	nop
 b3a:	90                   	nop
 b3b:	90                   	nop
 b3c:	90                   	nop
 b3d:	90                   	nop
 b3e:	90                   	nop
 b3f:	90                   	nop
 b40:	90                   	nop
 b41:	90                   	nop
 b42:	90                   	nop
 b43:	90                   	nop
 b44:	90                   	nop
 b45:	90                   	nop
 b46:	90                   	nop
 b47:	90                   	nop
 b48:	90                   	nop
 b49:	90                   	nop
 b4a:	90                   	nop
 b4b:	90                   	nop
 b4c:	90                   	nop
 b4d:	90                   	nop
 b4e:	90                   	nop
 b4f:	90                   	nop
 b50:	90                   	nop
 b51:	90                   	nop
 b52:	90                   	nop
 b53:	90                   	nop
 b54:	90                   	nop
 b55:	90                   	nop
 b56:	90                   	nop
 b57:	90                   	nop
 b58:	90                   	nop
 b59:	90                   	nop
 b5a:	90                   	nop
 b5b:	90                   	nop
 b5c:	90                   	nop
 b5d:	90                   	nop
 b5e:	90                   	nop
 b5f:	90                   	nop
 b60:	90                   	nop
 b61:	90                   	nop
 b62:	90                   	nop
 b63:	90                   	nop
 b64:	90                   	nop
 b65:	90                   	nop
 b66:	90                   	nop
 b67:	90                   	nop
 b68:	90                   	nop
 b69:	90                   	nop
 b6a:	90                   	nop
 b6b:	90                   	nop
 b6c:	90                   	nop
 b6d:	90                   	nop
 b6e:	90                   	nop
 b6f:	90                   	nop
 b70:	90                   	nop
 b71:	90                   	nop
 b72:	90                   	nop
 b73:	90                   	nop
 b74:	90                   	nop
 b75:	90                   	nop
 b76:	90                   	nop
 b77:	90                   	nop
 b78:	90                   	nop
 b79:	90                   	nop
 b7a:	90                   	nop
 b7b:	90                   	nop
 b7c:	90                   	nop
 b7d:	90                   	nop
 b7e:	90                   	nop
 b7f:	90                   	nop
 b80:	90                   	nop
 b81:	90                   	nop
 b82:	90                   	nop
 b83:	90                   	nop
 b84:	90                   	nop
 b85:	90                   	nop
 b86:	90                   	nop
 b87:	90                   	nop
 b88:	90                   	nop
 b89:	90                   	nop
 b8a:	90                   	nop
 b8b:	90                   	nop
 b8c:	90                   	nop
 b8d:	90                   	nop
 b8e:	90                   	nop
 b8f:	90                   	nop
 b90:	90                   	nop
 b91:	90                   	nop
 b92:	90                   	nop
 b93:	90                   	nop
 b94:	90                   	nop
 b95:	90                   	nop
 b96:	90                   	nop
 b97:	90                   	nop
 b98:	90                   	nop
 b99:	90                   	nop
 b9a:	90                   	nop
 b9b:	90                   	nop
 b9c:	90                   	nop
 b9d:	90                   	nop
 b9e:	90                   	nop
 b9f:	90                   	nop
 ba0:	90                   	nop
 ba1:	90                   	nop
 ba2:	90                   	nop
 ba3:	90                   	nop
 ba4:	90                   	nop
 ba5:	90                   	nop
 ba6:	90                   	nop
 ba7:	90                   	nop
 ba8:	90                   	nop
 ba9:	90                   	nop
 baa:	90                   	nop
 bab:	90                   	nop
 bac:	90                   	nop
 bad:	90                   	nop
 bae:	90                   	nop
 baf:	90                   	nop
 bb0:	90                   	nop
 bb1:	90                   	nop
 bb2:	90                   	nop
 bb3:	90                   	nop
 bb4:	90                   	nop
 bb5:	90                   	nop
 bb6:	90                   	nop
 bb7:	90                   	nop
 bb8:	90                   	nop
 bb9:	90                   	nop
 bba:	90                   	nop
 bbb:	90                   	nop
 bbc:	90                   	nop
 bbd:	90                   	nop
 bbe:	90                   	nop
 bbf:	90                   	nop
 bc0:	90                   	nop
 bc1:	90                   	nop
 bc2:	90                   	nop
 bc3:	90                   	nop
 bc4:	90                   	nop
 bc5:	90                   	nop
 bc6:	90                   	nop
 bc7:	90                   	nop
 bc8:	90                   	nop
 bc9:	90                   	nop
 bca:	90                   	nop
 bcb:	90                   	nop
 bcc:	90                   	nop
 bcd:	90                   	nop
 bce:	90                   	nop
 bcf:	90                   	nop
 bd0:	90                   	nop
 bd1:	90                   	nop
 bd2:	90                   	nop
 bd3:	90                   	nop
 bd4:	90                   	nop
 bd5:	90                   	nop
 bd6:	90                   	nop
 bd7:	90                   	nop
 bd8:	90                   	nop
 bd9:	90                   	nop
 bda:	90                   	nop
 bdb:	90                   	nop
 bdc:	90                   	nop
 bdd:	90                   	nop
 bde:	90                   	nop
 bdf:	90                   	nop
 be0:	90                   	nop
 be1:	90                   	nop
 be2:	90                   	nop
 be3:	90                   	nop
 be4:	90                   	nop
 be5:	90                   	nop
 be6:	90                   	nop
 be7:	90                   	nop
 be8:	90                   	nop
 be9:	90                   	nop
 bea:	90                   	nop
 beb:	90                   	nop
 bec:	90                   	nop
 bed:	90                   	nop
 bee:	90                   	nop
 bef:	90                   	nop
 bf0:	90                   	nop
 bf1:	90                   	nop
 bf2:	90                   	nop
 bf3:	90                   	nop
 bf4:	90                   	nop
 bf5:	90                   	nop
 bf6:	90                   	nop
 bf7:	90                   	nop
 bf8:	90                   	nop
 bf9:	90                   	nop
 bfa:	90                   	nop
 bfb:	90                   	nop
 bfc:	90                   	nop
 bfd:	90                   	nop
 bfe:	90                   	nop
 bff:	90                   	nop
bootloader [10:43:58] $ 
vshcmd: > # bochs can't handle a hard-drive smaller than 10M, so put our MBR
vshcmd: > # onto a 10M hard-drive, and boot that.
vshcmd: > bochs
vshcmd: > 6
vshcmd: > # vshcmd: > break 0x7c00  # Start of bootloader
vshcmd: > #
vshcmd: > # Positions relevant for my bootloader
vshcmd: > # vshcmd: > break 0x7e00  # Start of bootloader second section.
vshcmd: > break 0x8027 # readInitrd
vshcmd: > # vshcmd: > break 0x80cd # After readandMoveLoop
vshcmd: > # vshcmd: > break 0x9c29 # ljmp into protected mode
vshcmd: > #
vshcmd: > # Positions relevant for the sebastian-minimal bootloader
vshcmd: > # vshcmd: > break 0x7cde # sebastian-minimal run_kernel function
vshcmd: > # vshcmd: > break 0x10000 # real-mode kernel start with sebastian-minimal ...
vshcmd: > # vshcmd: > break 0x1337d # Linux real-mode main() when loaded with sebastian-minimal
vshcmd: > #
vshcmd: > # Positions relevant for both (i.e. in the protected-mode kernel).
vshcmd: > # vshcmd: > break 0x100000 # Start of Linux protected-mode kernel
vshcmd: > # vshcmd: > break 0x1000bc # arch/x86/boot/compressed/head_32.S:168
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
<bochs:1> <bochs:2> (0) Breakpoint 1, 0x0000000000008027 in ?? ()
Next at t=22170064
(0) [0x000000008027] 0000:8027 (unk. ctxt): xor ax, ax                ; 31c0
<bochs:3> 
vshcmd: > disasm 0x8027 0x805f
00008027: (                    ): xor ax, ax                ; 31c0
00008029: (                    ): mov eax, dword ptr ds:0x862c ; 66a12c86
0000802d: (                    ): mov dword ptr ds:0x85f6, eax ; 66a3f685
00008031: (                    ): call .-102                ; e89aff
00008034: (                    ): mov eax, dword ptr ds:0x85fa ; 66a1fa85
00008038: (                    ): mov dword ptr ds:0x7d8b, eax ; 66a38b7d
0000803c: (                    ): mov eax, dword ptr ds:0x85fe ; 66a1fe85
00008040: (                    ): mov dword ptr ds:0x85f2, eax ; 66a3f285
00008044: (                    ): call .+20                 ; e81400
00008047: (                    ): mov eax, dword ptr ds:0x8606 ; 66a10686
0000804b: (                    ): mov dword ptr ds:0x7d8b, eax ; 66a38b7d
0000804f: (                    ): mov eax, dword ptr ds:0x860a ; 66a10a86
00008053: (                    ): mov dword ptr ds:0x85f2, eax ; 66a3f285
00008057: (                    ): call .+1                  ; e80100
0000805a: (                    ): ret                       ; c3
0000805b: (                    ): xor eax, eax              ; 6631c0
0000805e: (                    ): mov ax, word ptr ds:0x7d87 ; a1877d
<bochs:5> 
vshcmd: > next
Next at t=44552087
(0) [0x00000000805a] 0000:805a (unk. ctxt): ret                       ; c3
<bochs:33> 
vshcmd: > # n.b. moveDest is at location 0x862c
vshcmd: > calc eax # Original value of moveDest
0x3ea200 4104704
<bochs:8> 
vshcmd: > help writemem
writemem <filename> <laddr> <len> - dump 'len' bytes of virtual memory starting from the linear address 'laddr' into the file
<bochs:26> 
vshcmd: > writemem '/home/matthew/fromRAM' 0x11dc572 50
<bochs:79> 
vshcmd: > exit
(0).[44552087] [0x00000000805a] 0000:805a (unk. ctxt): ret                       ; c3
bootloader [11:59:31] $ 
vshcmd: > x /100bx 0x11dcdce
[bochs]:
0x00000000011dcdce <bogus+       0>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x00000000011dcdd6 <bogus+       8>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x00000000011dcdde <bogus+      16>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x00000000011dcde6 <bogus+      24>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x00000000011dcdee <bogus+      32>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x00000000011dcdf6 <bogus+      40>:	0x00	0x00	0x00	0x00	0x00	0x00	0x00	0x00
0x00000000011dcdfe <bogus+      48>:	0x00	0x00	0x85	0x83	0x48	0x03	0x27	0xca
0x00000000011dce06 <bogus+      56>:	0xb4	0x3d	0x4f	0x54	0x47	0xd6	0x09	0x79
0x00000000011dce0e <bogus+      64>:	0xb7	0xbd	0x4f	0xba	0x66	0x4e	0x70	0x97
0x00000000011dce16 <bogus+      72>:	0xc6	0xbd	0xac	0x13	0x8a	0x2f	0x07	0xd7
0x00000000011dce1e <bogus+      80>:	0xf9	0xbd	0x50	0xb8	0x19	0x26	0x39	0xf5
0x00000000011dce26 <bogus+      88>:	0x9e	0xbd	0x45	0xb4	0x46	0x7c	0xc1	0x99
0x00000000011dce2e <bogus+      96>:	0xca	0xbd	0xfa	0x52
<bochs:37> 
vshcmd: > x /1wx 0x862c # New moveDest
[bochs]:
0x000000000000862c <bogus+       0>:	0x00bf9e00
<bochs:28> 
vshcmd: > New 
vshcmd: > exit
(0).[22169655] [0x0000000080e2] 0000:80e2 (unk. ctxt): jns .+12 (0x000080f0)     ; 790c
bootloader [20:39:12] $ 
vshcmd: > reg
CPU0:
rax: 00000000_ffffffa4 rcx: 00000000_00000000
rdx: 00000000_00000080 rbx: 00000000_00000010
rsp: 00000000_0000fff9 rbp: 00000000_00000000
rsi: 00000000_0000fe00 rdi: 00000000_0000fe00
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_000080d6
eflags 0x00000246: id vip vif ac vm rf nt IOPL=0 of df IF tf sf ZF af PF cf
<bochs:6> 
vshcmd: > reg
CPU0:
rax: 00000000_ffff4800 rcx: 00000000_00000000
rdx: 00000000_00000080 rbx: 00000000_00000010
rsp: 00000000_0000fff9 rbp: 00000000_00000000
rsi: 00000000_0000fe00 rdi: 00000000_0000fe00
r8 : 00000000_00000000 r9 : 00000000_00000000
r10: 00000000_00000000 r11: 00000000_00000000
r12: 00000000_00000000 r13: 00000000_00000000
r14: 00000000_00000000 r15: 00000000_00000000
rip: 00000000_000080dd
eflags 0x00000286: id vip vif ac vm rf nt IOPL=0 of df IF tf SF zf af PF cf
<bochs:8> 
vshcmd: > disasm 0x80cd 0x80ff
000080cd: (                    ): xor eax, eax              ; 6631c0
000080d0: (                    ): mov ax, word ptr ds:0x861d ; a11d86
000080d3: (                    ): imul ax, ax, 0x0200       ; 69c00002
000080d7: (                    ): jnb .+12                  ; 730c
000080d9: (                    ): mov word ptr ds:0x7d4f, ax ; a34f7d
000080dc: (                    ): call .-1168               ; e870fb
000080df: (                    ): mov si, 0x85be            ; bebe85
000080e2: (                    ): call .-1220               ; e83cfb
000080e5: (                    ): add dword ptr ds:0x8653, eax ; 6601065386
000080ea: (                    ): jns .+12                  ; 790c
000080ec: (                    ): mov word ptr ds:0x7d4f, ax ; a34f7d
000080ef: (                    ): call .-1187               ; e85dfb
000080f2: (                    ): mov si, 0x85f1            ; bef185
000080f5: (                    ): call .-1239               ; e829fb
000080f8: (                    ): ret                       ; c3
000080f9: (                    ): mov word ptr ds:[bx+2], ax ; 894702
000080fc: (                    ): shr eax, 0x10             ; 66c1e810
<bochs:4> 
vshcmd: > x /1hx ds:0x861d
[bochs]:
0x000000000000861d <bogus+       0>:	0xffa4
<bochs:6> 
