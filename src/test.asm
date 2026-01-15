.org 0x7c00

.section .data

.section .text

  .globl _start
_start:
  jmp set_stack

set_stack:
  xor %ax, %ax
  movl %ax, %ss
  movl %ax, %cs
  movl %ax, %ds
  movl %ax, %es
  movl $0x7c00, %sp
  jmp main

main:
  jmp main

.fill 510 - ( . - init ), 1, 0
.word 0xaa55
