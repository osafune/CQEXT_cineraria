/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_fast' in SOPC Builder design 'cineraria_core'
 * SOPC Builder design path: ../../cineraria_core.sopcinfo
 *
 * Generated: Mon Sep 14 16:56:41 JST 2015
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x0fff0820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 133333333u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1d
#define ALT_CPU_DCACHE_BYPASS_MASK 0x80000000
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 32768
#define ALT_CPU_EXCEPTION_ADDR 0x00000020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 133333333
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 1
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 1
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_DIVISION_ERROR_EXCEPTION
#define ALT_CPU_HAS_EXTRA_EXCEPTION_INFO
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 32768
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x1c
#define ALT_CPU_NAME "nios2_fast"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x0f000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x0fff0820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 133333333u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x1d
#define NIOS2_DCACHE_BYPASS_MASK 0x80000000
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 32768
#define NIOS2_EXCEPTION_ADDR 0x00000020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 1
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 1
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_DIVISION_ERROR_EXCEPTION
#define NIOS2_HAS_EXTRA_EXCEPTION_INFO
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 32768
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x1c
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x0f000000


/*
 * Custom instruction macros
 *
 */

#define ALT_CI_NIOS_CUSTOM_INSTR_FLOATING_POINT_0(n,A,B) __builtin_custom_inii(ALT_CI_NIOS_CUSTOM_INSTR_FLOATING_POINT_0_N+(n&ALT_CI_NIOS_CUSTOM_INSTR_FLOATING_POINT_0_N_MASK),(A),(B))
#define ALT_CI_NIOS_CUSTOM_INSTR_FLOATING_POINT_0_N 0xfc
#define ALT_CI_NIOS_CUSTOM_INSTR_FLOATING_POINT_0_N_MASK ((1<<2)-1)
#define ALT_CI_PIXELSIMD(n,A,B) __builtin_custom_inii(ALT_CI_PIXELSIMD_N+(n&ALT_CI_PIXELSIMD_N_MASK),(A),(B))
#define ALT_CI_PIXELSIMD_N 0x0
#define ALT_CI_PIXELSIMD_N_MASK ((1<<3)-1)


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_EPCQ_CONTROLLER
#define __ALTERA_NIOS2_GEN2
#define __ALTERA_NIOS_CUSTOM_INSTR_FLOATING_POINT
#define __ALTERA_UP_AVALON_PS2
#define __MMCDMA
#define __PCM_COMPONENT
#define __PIXELSIMD
#define __USBHOST_COMPONENT
#define __VGA_COMPONENT


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone V"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x10000080
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x10000080
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x10000080
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "cineraria_core"


/*
 * bootmem configuration
 *
 */

#define ALT_MODULE_CLASS_bootmem altera_avalon_onchip_memory2
#define BOOTMEM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define BOOTMEM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define BOOTMEM_BASE 0xf000000
#define BOOTMEM_CONTENTS_INFO ""
#define BOOTMEM_DUAL_PORT 0
#define BOOTMEM_GUI_RAM_BLOCK_TYPE "AUTO"
#define BOOTMEM_INIT_CONTENTS_FILE "boot"
#define BOOTMEM_INIT_MEM_CONTENT 1
#define BOOTMEM_INSTANCE_ID "NONE"
#define BOOTMEM_IRQ -1
#define BOOTMEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define BOOTMEM_NAME "/dev/bootmem"
#define BOOTMEM_NON_DEFAULT_INIT_FILE_ENABLED 1
#define BOOTMEM_RAM_BLOCK_TYPE "AUTO"
#define BOOTMEM_READ_DURING_WRITE_MODE "DONT_CARE"
#define BOOTMEM_SINGLE_CLOCK_OP 0
#define BOOTMEM_SIZE_MULTIPLE 1
#define BOOTMEM_SIZE_VALUE 65536
#define BOOTMEM_SPAN 65536
#define BOOTMEM_TYPE "altera_avalon_onchip_memory2"
#define BOOTMEM_WRITABLE 1


/*
 * dipsw configuration
 *
 */

#define ALT_MODULE_CLASS_dipsw altera_avalon_pio
#define DIPSW_BASE 0x10000260
#define DIPSW_BIT_CLEARING_EDGE_REGISTER 0
#define DIPSW_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DIPSW_CAPTURE 0
#define DIPSW_DATA_WIDTH 10
#define DIPSW_DO_TEST_BENCH_WIRING 0
#define DIPSW_DRIVEN_SIM_VALUE 0
#define DIPSW_EDGE_TYPE "NONE"
#define DIPSW_FREQ 50000000
#define DIPSW_HAS_IN 1
#define DIPSW_HAS_OUT 0
#define DIPSW_HAS_TRI 0
#define DIPSW_IRQ -1
#define DIPSW_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DIPSW_IRQ_TYPE "NONE"
#define DIPSW_NAME "/dev/dipsw"
#define DIPSW_RESET_VALUE 0
#define DIPSW_SPAN 16
#define DIPSW_TYPE "altera_avalon_pio"


/*
 * epcq_avl_csr configuration
 *
 */

#define ALT_MODULE_CLASS_epcq_avl_csr altera_epcq_controller
#define EPCQ_AVL_CSR_BASE 0x1000f000
#define EPCQ_AVL_CSR_FLASH_TYPE "EPCS64"
#define EPCQ_AVL_CSR_IRQ 16
#define EPCQ_AVL_CSR_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCQ_AVL_CSR_IS_EPCS 1
#define EPCQ_AVL_CSR_NAME "/dev/epcq_avl_csr"
#define EPCQ_AVL_CSR_NUMBER_OF_SECTORS 128
#define EPCQ_AVL_CSR_PAGE_SIZE 256
#define EPCQ_AVL_CSR_SECTOR_SIZE 65536
#define EPCQ_AVL_CSR_SPAN 32
#define EPCQ_AVL_CSR_SUBSECTOR_SIZE 4096
#define EPCQ_AVL_CSR_TYPE "altera_epcq_controller"


/*
 * epcq_avl_mem configuration
 *
 */

#define ALT_MODULE_CLASS_epcq_avl_mem altera_epcq_controller
#define EPCQ_AVL_MEM_BASE 0x10800000
#define EPCQ_AVL_MEM_FLASH_TYPE "EPCS64"
#define EPCQ_AVL_MEM_IRQ -1
#define EPCQ_AVL_MEM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define EPCQ_AVL_MEM_IS_EPCS 1
#define EPCQ_AVL_MEM_NAME "/dev/epcq_avl_mem"
#define EPCQ_AVL_MEM_NUMBER_OF_SECTORS 128
#define EPCQ_AVL_MEM_PAGE_SIZE 256
#define EPCQ_AVL_MEM_SECTOR_SIZE 65536
#define EPCQ_AVL_MEM_SPAN 8388608
#define EPCQ_AVL_MEM_SUBSECTOR_SIZE 4096
#define EPCQ_AVL_MEM_TYPE "altera_epcq_controller"


/*
 * gpio0 configuration
 *
 */

#define ALT_MODULE_CLASS_gpio0 altera_avalon_pio
#define GPIO0_BASE 0x10000280
#define GPIO0_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define GPIO0_CAPTURE 0
#define GPIO0_DATA_WIDTH 32
#define GPIO0_DO_TEST_BENCH_WIRING 0
#define GPIO0_DRIVEN_SIM_VALUE 0
#define GPIO0_EDGE_TYPE "NONE"
#define GPIO0_FREQ 50000000
#define GPIO0_HAS_IN 0
#define GPIO0_HAS_OUT 0
#define GPIO0_HAS_TRI 1
#define GPIO0_IRQ -1
#define GPIO0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO0_IRQ_TYPE "NONE"
#define GPIO0_NAME "/dev/gpio0"
#define GPIO0_RESET_VALUE 0
#define GPIO0_SPAN 16
#define GPIO0_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYSTIMER
#define ALT_TIMESTAMP_CLK SYSTIMER


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x10000080
#define JTAG_UART_IRQ 8
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * led configuration
 *
 */

#define ALT_MODULE_CLASS_led altera_avalon_pio
#define LED_BASE 0x10000100
#define LED_BIT_CLEARING_EDGE_REGISTER 0
#define LED_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_CAPTURE 0
#define LED_DATA_WIDTH 10
#define LED_DO_TEST_BENCH_WIRING 0
#define LED_DRIVEN_SIM_VALUE 0
#define LED_EDGE_TYPE "NONE"
#define LED_FREQ 50000000
#define LED_HAS_IN 0
#define LED_HAS_OUT 1
#define LED_HAS_TRI 0
#define LED_IRQ -1
#define LED_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_IRQ_TYPE "NONE"
#define LED_NAME "/dev/led"
#define LED_RESET_VALUE 0
#define LED_SPAN 16
#define LED_TYPE "altera_avalon_pio"


/*
 * led_7seg_0 configuration
 *
 */

#define ALT_MODULE_CLASS_led_7seg_0 altera_avalon_pio
#define LED_7SEG_0_BASE 0x10000200
#define LED_7SEG_0_BIT_CLEARING_EDGE_REGISTER 0
#define LED_7SEG_0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_7SEG_0_CAPTURE 0
#define LED_7SEG_0_DATA_WIDTH 16
#define LED_7SEG_0_DO_TEST_BENCH_WIRING 0
#define LED_7SEG_0_DRIVEN_SIM_VALUE 0
#define LED_7SEG_0_EDGE_TYPE "NONE"
#define LED_7SEG_0_FREQ 50000000
#define LED_7SEG_0_HAS_IN 0
#define LED_7SEG_0_HAS_OUT 1
#define LED_7SEG_0_HAS_TRI 0
#define LED_7SEG_0_IRQ -1
#define LED_7SEG_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_7SEG_0_IRQ_TYPE "NONE"
#define LED_7SEG_0_NAME "/dev/led_7seg_0"
#define LED_7SEG_0_RESET_VALUE 0
#define LED_7SEG_0_SPAN 16
#define LED_7SEG_0_TYPE "altera_avalon_pio"


/*
 * led_7seg_1 configuration
 *
 */

#define ALT_MODULE_CLASS_led_7seg_1 altera_avalon_pio
#define LED_7SEG_1_BASE 0x10000210
#define LED_7SEG_1_BIT_CLEARING_EDGE_REGISTER 0
#define LED_7SEG_1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_7SEG_1_CAPTURE 0
#define LED_7SEG_1_DATA_WIDTH 16
#define LED_7SEG_1_DO_TEST_BENCH_WIRING 0
#define LED_7SEG_1_DRIVEN_SIM_VALUE 0
#define LED_7SEG_1_EDGE_TYPE "NONE"
#define LED_7SEG_1_FREQ 50000000
#define LED_7SEG_1_HAS_IN 0
#define LED_7SEG_1_HAS_OUT 1
#define LED_7SEG_1_HAS_TRI 0
#define LED_7SEG_1_IRQ -1
#define LED_7SEG_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_7SEG_1_IRQ_TYPE "NONE"
#define LED_7SEG_1_NAME "/dev/led_7seg_1"
#define LED_7SEG_1_RESET_VALUE 0
#define LED_7SEG_1_SPAN 16
#define LED_7SEG_1_TYPE "altera_avalon_pio"


/*
 * led_7seg_2 configuration
 *
 */

#define ALT_MODULE_CLASS_led_7seg_2 altera_avalon_pio
#define LED_7SEG_2_BASE 0x10000220
#define LED_7SEG_2_BIT_CLEARING_EDGE_REGISTER 0
#define LED_7SEG_2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_7SEG_2_CAPTURE 0
#define LED_7SEG_2_DATA_WIDTH 16
#define LED_7SEG_2_DO_TEST_BENCH_WIRING 0
#define LED_7SEG_2_DRIVEN_SIM_VALUE 0
#define LED_7SEG_2_EDGE_TYPE "NONE"
#define LED_7SEG_2_FREQ 50000000
#define LED_7SEG_2_HAS_IN 0
#define LED_7SEG_2_HAS_OUT 1
#define LED_7SEG_2_HAS_TRI 0
#define LED_7SEG_2_IRQ -1
#define LED_7SEG_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_7SEG_2_IRQ_TYPE "NONE"
#define LED_7SEG_2_NAME "/dev/led_7seg_2"
#define LED_7SEG_2_RESET_VALUE 0
#define LED_7SEG_2_SPAN 16
#define LED_7SEG_2_TYPE "altera_avalon_pio"


/*
 * mmcdma configuration
 *
 */

#define ALT_MODULE_CLASS_mmcdma mmcdma
#define MMCDMA_BASE 0x10000400
#define MMCDMA_IRQ 7
#define MMCDMA_IRQ_INTERRUPT_CONTROLLER_ID 0
#define MMCDMA_NAME "/dev/mmcdma"
#define MMCDMA_SPAN 1024
#define MMCDMA_TYPE "mmcdma"


/*
 * pcm configuration
 *
 */

#define ALT_MODULE_CLASS_pcm pcm_component
#define PCM_BASE 0x10000820
#define PCM_IRQ 5
#define PCM_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PCM_NAME "/dev/pcm"
#define PCM_SPAN 16
#define PCM_TYPE "pcm_component"


/*
 * ps2_kb configuration
 *
 */

#define ALT_MODULE_CLASS_ps2_kb altera_up_avalon_ps2
#define PS2_KB_BASE 0x10000300
#define PS2_KB_IRQ 21
#define PS2_KB_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PS2_KB_NAME "/dev/ps2_kb"
#define PS2_KB_SPAN 8
#define PS2_KB_TYPE "altera_up_avalon_ps2"


/*
 * psw configuration
 *
 */

#define ALT_MODULE_CLASS_psw altera_avalon_pio
#define PSW_BASE 0x10000240
#define PSW_BIT_CLEARING_EDGE_REGISTER 0
#define PSW_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PSW_CAPTURE 1
#define PSW_DATA_WIDTH 4
#define PSW_DO_TEST_BENCH_WIRING 0
#define PSW_DRIVEN_SIM_VALUE 0
#define PSW_EDGE_TYPE "FALLING"
#define PSW_FREQ 50000000
#define PSW_HAS_IN 1
#define PSW_HAS_OUT 0
#define PSW_HAS_TRI 0
#define PSW_IRQ 20
#define PSW_IRQ_INTERRUPT_CONTROLLER_ID 0
#define PSW_IRQ_TYPE "EDGE"
#define PSW_NAME "/dev/psw"
#define PSW_RESET_VALUE 0
#define PSW_SPAN 16
#define PSW_TYPE "altera_avalon_pio"


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x0
#define SDRAM_CAS_LATENCY 3
#define SDRAM_CONTENTS_INFO
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_REFRESH_PERIOD 7.8125
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x19
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 10
#define SDRAM_SDRAM_DATA_WIDTH 16
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 13
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 0
#define SDRAM_SPAN 67108864
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 5.4
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 15.0
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 15.0
#define SDRAM_T_WR 14.0


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x10000000
#define SYSID_ID 538249488
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1441886274
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * systimer configuration
 *
 */

#define ALT_MODULE_CLASS_systimer altera_avalon_timer
#define SYSTIMER_ALWAYS_RUN 0
#define SYSTIMER_BASE 0x10000020
#define SYSTIMER_COUNTER_SIZE 32
#define SYSTIMER_FIXED_PERIOD 0
#define SYSTIMER_FREQ 50000000
#define SYSTIMER_IRQ 0
#define SYSTIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYSTIMER_LOAD_VALUE 49999
#define SYSTIMER_MULT 0.001
#define SYSTIMER_NAME "/dev/systimer"
#define SYSTIMER_PERIOD 1
#define SYSTIMER_PERIOD_UNITS "ms"
#define SYSTIMER_RESET_OUTPUT 0
#define SYSTIMER_SNAPSHOT 1
#define SYSTIMER_SPAN 32
#define SYSTIMER_TICKS_PER_SEC 1000
#define SYSTIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYSTIMER_TYPE "altera_avalon_timer"


/*
 * usb configuration
 *
 */

#define ALT_MODULE_CLASS_usb usbhost_component
#define USB_BASE 0x10000900
#define USB_IRQ 2
#define USB_IRQ_INTERRUPT_CONTROLLER_ID 0
#define USB_NAME "/dev/usb"
#define USB_SPAN 256
#define USB_TYPE "usbhost_component"


/*
 * vga configuration
 *
 */

#define ALT_MODULE_CLASS_vga vga_component
#define VGA_BASE 0x10000800
#define VGA_IRQ 4
#define VGA_IRQ_INTERRUPT_CONTROLLER_ID 0
#define VGA_NAME "/dev/vga"
#define VGA_SPAN 16
#define VGA_TYPE "vga_component"

#endif /* __SYSTEM_H_ */
