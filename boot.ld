SECTIONS
{
    . = 0x7c00,
    .text : { *(.text) },
    .data : { *(.data) },
    . = 0x7c00 + 510,
    bootablemarker : { *(bootablemarker) },
}

OUTPUT_FORMAT(binary)

