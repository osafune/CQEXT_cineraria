# TCL File Generated by Component Editor 15.0
# Wed Sep 09 10:25:53 JST 2015
# DO NOT MODIFY


# 
# pcm_component "PCM Playback componennt" v1.0
# J-7SYSTEM WORKS LTD. 2015.09.09.10:25:53
# 
# 

# 
# request TCL package from ACDS 15.0
# 
package require -exact qsys 15.0


# 
# module pcm_component
# 
set_module_property DESCRIPTION ""
set_module_property NAME pcm_component
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "J-7SYSTEM WORKS LTD."
set_module_property DISPLAY_NAME "PCM Playback componennt"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pcm_component
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file os256_dac.v VERILOG PATH os256_dac.v
add_fileset_file os256_dsm.v VERILOG PATH os256_dsm.v
add_fileset_file os256_lanczos_table.mif MIF PATH os256_lanczos_table.mif
add_fileset_file os256_lanczos_table.v VERILOG PATH os256_lanczos_table.v
add_fileset_file os256_mult_s18xs18.v VERILOG PATH os256_mult_s18xs18.v
add_fileset_file os256_tap.v VERILOG PATH os256_tap.v
add_fileset_file pcm_fifo.v VERILOG PATH pcm_fifo.v
add_fileset_file pcm_component.v VERILOG PATH pcm_component.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock csi_clk clk Input 1


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 bitsPerSymbol 8
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 burstcountUnits WORDS
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 maximumPendingWriteTransactions 0
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0
set_interface_property s0 ENABLED true
set_interface_property s0 EXPORT_OF ""
set_interface_property s0 PORT_NAME_MAP ""
set_interface_property s0 CMSIS_SVD_VARIABLES ""
set_interface_property s0 SVD_ADDRESS_GROUP ""

add_interface_port s0 avs_address address Input 2
add_interface_port s0 avs_read read Input 1
add_interface_port s0 avs_readdata readdata Output 32
add_interface_port s0 avs_write write Input 1
add_interface_port s0 avs_writedata writedata Input 32
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset csi_reset reset Input 1


# 
# connection point irs
# 
add_interface irs interrupt end
set_interface_property irs associatedAddressablePoint s0
set_interface_property irs associatedClock clock
set_interface_property irs associatedReset reset
set_interface_property irs bridgedReceiverOffset ""
set_interface_property irs bridgesToReceiver ""
set_interface_property irs ENABLED true
set_interface_property irs EXPORT_OF ""
set_interface_property irs PORT_NAME_MAP ""
set_interface_property irs CMSIS_SVD_VARIABLES ""
set_interface_property irs SVD_ADDRESS_GROUP ""

add_interface_port irs ins_irq irq Output 1


# 
# connection point export
# 
add_interface export conduit end
set_interface_property export associatedClock ""
set_interface_property export associatedReset ""
set_interface_property export ENABLED true
set_interface_property export EXPORT_OF ""
set_interface_property export PORT_NAME_MAP ""
set_interface_property export CMSIS_SVD_VARIABLES ""
set_interface_property export SVD_ADDRESS_GROUP ""

add_interface_port export coe_aud_clk clk Input 1
add_interface_port export coe_aud_mute mute Output 1
add_interface_port export coe_aud_l aud_l Output 1
add_interface_port export coe_aud_r aud_r Output 1

