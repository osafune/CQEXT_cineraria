# ------------------------------------------
# Create generated clocks based on PLLs
# ------------------------------------------

derive_pll_clocks
derive_clock_uncertainty



# ---------------------------------------------
# Original Clock
# ---------------------------------------------

create_clock -period "20.000 ns" [get_ports CLOCK_50]
create_clock -period "20.000 ns" [get_ports CLOCK2_50]
create_clock -period "20.000 ns" [get_ports CLOCK3_50]
create_clock -period "20.000 ns" [get_ports CLOCK4_50]



# ---------------------------------------------
# Set Clock Groups
# ---------------------------------------------

set_clock_groups -asynchronous \
	-group { \
		{syspll_inst|syspll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} \
		{syspll_inst|syspll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} \
	} \
    -group { \
		{syspll_inst|syspll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} \
	} \
    -group { \
		{videopll_inst|videopll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} \
		{videopll_inst|videopll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} \
    } \
    -group { \
		{videopll_inst|videopll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} \
    } \
    -group { \
		{videopll_inst|videopll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk} \
    } \



# ---------------------------------------------
# Set SDRAM I/O requirements
# ---------------------------------------------

#create_clock -period "143.0 MHZ" -name "sdram_clk" [get_ports DRAM_CLK]



