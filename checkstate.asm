.file "checkstate.asm"
# General functions to check the current state of the world.
# Loaded in real-mode as an MBR -- may very well be as part of the boot1 stage.
# Makes heavy use of the BIOS provided interrupts.
#
# http://wiki.osdev.org/Rolling_Your_Own_Bootloader
readMemorySize:
    # Contigious memory 
    # vimcmd: e +1417 saved_docs/BIOSinterrupts/INTERRUP.B
    #
    # In newer BIOSes, get system memory map
    # vimcmd: e +69 saved_docs/BIOSinterrupts/INTERRUP.D
getAvailableVideoModes:
    # Have no idea how to do this at the moment, but the
    # Rolling_Your_Own_Bootloader wiki page says it's easier in Real mode.
