set_global_assignment -entity "videopll" -library "lib_videopll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "videopll" -library "lib_videopll" -name IP_TOOL_VERSION "15.0"
set_global_assignment -entity "videopll" -library "lib_videopll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_videopll" -name SPD_FILE [file join $::quartus(sip_path) "videopll.spd"]

set_global_assignment -library "lib_videopll" -name MISC_FILE [file join $::quartus(sip_path) "videopll_sim/videopll.vo"]
