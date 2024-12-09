ENTRY(reset)
MEMORY{
    RAM : ORIGIN = 0, LENGTH = 2k
}
SECTIONS{
    .text : {*(.text.reset) *(.text.*) *(.text)} >RAM
    .data : {*(.rodata.*) *(.rodata) *(.data.*) *(.data)} >RAM
    .bss  : {*(.bss.*) *(.bss)} >RAM
}