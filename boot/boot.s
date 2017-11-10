.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

# Multiboot Header
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# Stack Allocation with 16-byte alignment
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

# Kernel Entry Point
.section .text
.global _start
.type _start, @function
_start:

# Setup Stack by pointing esp to stack_top
mov $stack_top, %esp

# Initialize Crucial Processor State
# Try and do it as early as possible
# IDT: Interrupt Descriptor Table
# GDT: Global Descriptor Table
# Paging
# C++ Features: Global Constructors, Exceptions, etc.

# Enter High-Level Kernel
call kernel_main

# System has nothing more to do, so go into Infitine Loop
# Disable Interrupts with cli
cli
# Wait for next Interrupt
1: hlt
jmp 1b

.size _start, . - _start
