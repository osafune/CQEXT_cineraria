#!/bin/sh
cd /cygdrive/c/PROJECT/cq_viola/cineraria_de0cv
nios2-configure-sof -c "USB-Blaster [USB-0]" output_files/cineraria_top.sof
nios2-download -c "USB-Blaster [USB-0]" -g -r software/cineraria_wavplay/cineraria_wavplay.elf
nios2-terminal -c "USB-Blaster [USB-0]"
