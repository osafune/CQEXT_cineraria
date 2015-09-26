#!/bin/sh
nios2-configure-sof -c "USB-Blaster [USB-0]" qsf/output_files/cineraria_top.sof
nios2-download -c "USB-Blaster [USB-0]" -g -r qsf/software/cineraria_wavplay/cineraria_wavplay.elf
nios2-terminal -c "USB-Blaster [USB-0]"
