.org 0x7c00
.bits 16

.section .data

.equ CODE_OFFSET, 0x8
.equ DATA_OFFSET, 0x10

.section .text

  .globl _start
_start:
  jmp set_stack

set_stack:
  cli
  xor %ax, %ax
  movl %ax, %ss
  movl %ax, %ds
  movl %ax, %es
  movl $0x7c00, %sp
  sti 

movl $KERNEL_LOAD_SEG
movl $0x00, %dh
movl $0x80, %dl
movl $0x02, %cl 
movl $0x00, %ch 
movl $0x02, %ah 
movl $8, %al 

int $0x13

jc disk_read_error

load_PM:
  cli 
  lgdt (GDT_descriptor)
  mov %cr0, %eax
  or %al, $1
  mov %eax, %cr0
  jmp CODE_OFFSET:PMMain

disk_read_error:
  cli 
  hlt
  jmp disk_read_error


GDT_start:
 .long 0x00000000
 .long 0x00000000

 .word 0xFFFF
 .word 0x0000
 .byte 0x00
 .byte 10011010b
 .byte 11001111b
 .byte 0x00

 .word 0xFFFF
 .word 0x0000
 .byte 10010010b
 .byte 11001111b
 .byte 0x00

 GDT_END:

 GDT_descriptor:
  .word GDT_END - GDT_start - 1
  .double GDT_start

.bits 32

PMMain:
  movl DATA_OFFSET, %ax
  movl %ax, %ds
  movl %ax, %es
  movl %ax, %fs 
  movl %ax, %ss
  movl %ax, %gs 
  movl $0x9c00, ebp
  movl %ebp, %esp

  inb $0x92, %al
  or %al, $2
  outb %al, $0x92

  jmp CODE_OFFSET:KERNEL_LOAD_ADDr

.fill 510 - ( . - init ), 1, 0
.word 0xaa55
