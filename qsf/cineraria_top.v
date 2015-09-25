// ===================================================================
// TITLE : DE0-CV CQ-EXT sample "cineraria DE0-CV"
//
//   DEGISN : S.OSAFUNE ( s.osafune@j7system.jp )
//   DATE   : 2015/09/07 -> 2015/09/10
//   UPDATE : 
//
// ===================================================================
// *******************************************************************
//   COPYRIGHT (C) 2015 J-7SYSTEM WORKS LTD. ALL RIGHTS RESERVED.
//
// * This module is a free sourcecode and there is NO WARRANTY.
// * No restriction on use. You can use, modify and redistribute it
//   for personal, non-profit or commercial products UNDER YOUR
//   RESPONSIBILITY.
// * Redistributions of source code must retain the above copyright
//   notice.
// *******************************************************************

module cineraria_top(
	input			CLOCK_50,
	input			CLOCK2_50,
	input			CLOCK3_50,
	input			CLOCK4_50,
	input			RESET_N,

	output [12:0]	DRAM_ADDR,
	output [1:0]	DRAM_BA,
	output			DRAM_CS_N,
	output			DRAM_CAS_N,
	output			DRAM_RAS_N,
	output			DRAM_WE_N,
	inout  [15:0]	DRAM_DQ,
	output			DRAM_LDQM,
	output			DRAM_UDQM,
	output			DRAM_CKE,
	output			DRAM_CLK,

	inout  [35:0]	GPIO_0,
	output [9:0]	LEDR,
	output [6:0]	HEX0,
	output [6:0]	HEX1,
	output [6:0]	HEX2,
	output [6:0]	HEX3,
	output [6:0]	HEX4,
	output [6:0]	HEX5,
	input  [3:0]	KEY,
	input  [9:0]	SW,
	inout			PS2_CLK,
	inout			PS2_DAT,
	output			SD_CLK,
	inout			SD_CMD,
	inout  [3:0]	SD_DATA,
	output			VGA_HS,
	output			VGA_VS,
	output [3:0]	VGA_R,
	output [3:0]	VGA_G,
	output [3:0]	VGA_B,

	output			DVI_DATA0P,
	output			DVI_DATA0N,
	output			DVI_DATA1P,
	output			DVI_DATA1N,
	output			DVI_DATA2P,
	output			DVI_DATA2N,
	output			DVI_CLOCKP,
	output			DVI_CLOCKN,
	output			AUD_L,
	output			AUD_R,
	inout			USBH_DP,
	inout			USBH_DM,
	output			E_RST_N
);



/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */



/* ===== ノード宣言 ====================== */
	wire			clk143m_sig, clk50m_sig;
	wire			clk25m175_sig, clk_x5_sig;
	wire			clk12m288_sig, clk48m_sig;
	wire			vpll_reset_sig, vpll_locked_sig;
	wire			spll_reset_sig, spll_locked_sig;
	wire			qsysreset_n_sig;

	wire [4:0]		vga_r_sig, vga_g_sig, vga_b_sig;
	wire			vga_hs_n_sig, vga_vs_n_sig, vga_de_sig;
	wire [9:0]		led_sig;
	wire [15:0]		led7seg_0_sig, led7seg_1_sig, led7seg_2_sig;
	wire [31:0]		gpio0_sig;
	wire			sd_cs_n_sig, sd_sdo_sig, sd_sdi_sig;



/* ===== テスト記述 ============== */

	assign E_RST_N = 1'b0;

//	assign LEDR = {led_sig[9:3], spll_locked_sig, vpll_locked_sig, ~RESET_N};



/* ===== モジュール構造記述 ============== */

	// クロックとリセット 

	assign vpll_reset_sig = ~RESET_N;

	videopll
	videopll_inst (
		.refclk			( CLOCK2_50 ),
		.rst			( vpll_reset_sig ),
		.outclk_0		( clk_x5_sig ),
		.outclk_1		( clk25m175_sig ),
		.outclk_2		( clk12m288_sig ),
		.outclk_3		( clk48m_sig ),
		.locked			( vpll_locked_sig )
	);


	assign spll_reset_sig = ~vpll_locked_sig;

	syspll
	syspll_inst (
		.refclk			( CLOCK_50 ),
		.rst			( spll_reset_sig ),
		.outclk_0		( DRAM_CLK ),
		.outclk_1		( clk143m_sig ),
		.outclk_2		( clk50m_sig ),
		.locked			( spll_locked_sig )
	);

	assign qsysreset_n_sig = spll_locked_sig;



	// Qsysコンポーネントインスタンス 

	cineraria_core
	core_inst (
        .reset_reset_n        ( qsysreset_n_sig ),
        .core_clk             ( clk143m_sig ),
        .peri_clk             ( clk50m_sig ),

        .vga_clk              ( clk25m175_sig ),
        .vga_rout             ( vga_r_sig ),
        .vga_gout             ( vga_g_sig ),
        .vga_bout             ( vga_b_sig ),
        .vga_hsync_n          ( vga_hs_n_sig ),
        .vga_vsync_n          ( vga_vs_n_sig ),
        .vga_enable           ( vga_de_sig ),

        .pcm_clk              ( clk12m288_sig ),
        .pcm_aud_l            ( AUD_L ),
        .pcm_aud_r            ( AUD_R ),

        .usb_usbclk_48mhz     ( clk48m_sig ),
        .usb_usb_dp           ( USBH_DP ),
        .usb_usb_dm           ( USBH_DM ),

        .sd_nCS               ( sd_cs_n_sig ),
        .sd_SCK               ( SD_CLK ),
        .sd_SDO               ( sd_sdo_sig ),
        .sd_SDI               ( sd_sdi_sig ),
        .sd_CD                ( 1'b0 ),
        .sd_WP                ( 1'b1 ),

        .led_export           ( led_sig ),
        .led7seg_0_export     ( led7seg_0_sig ),
        .led7seg_1_export     ( led7seg_1_sig ),
        .led7seg_2_export     ( led7seg_2_sig ),

        .psw_export           ( KEY ),
        .dipsw_export         ( SW ),

        .gpio0_export         ( gpio0_sig ),

        .ps2_kb_CLK           ( PS2_CLK ),
        .ps2_kb_DAT           ( PS2_DAT ),

        .sdr_addr             ( DRAM_ADDR ),
        .sdr_ba               ( DRAM_BA ),
        .sdr_cs_n             ( DRAM_CS_N ),
        .sdr_ras_n            ( DRAM_RAS_N ),
        .sdr_cas_n            ( DRAM_CAS_N ),
        .sdr_we_n             ( DRAM_WE_N),
        .sdr_dq               ( DRAM_DQ ),
        .sdr_dqm              ( {DRAM_UDQM, DRAM_LDQM} ),
        .sdr_cke              ( DRAM_CKE )
	);

	assign VGA_HS = vga_hs_n_sig;
	assign VGA_VS = vga_vs_n_sig;
	assign VGA_R = vga_r_sig[4:1];
	assign VGA_G = vga_g_sig[4:1];
	assign VGA_B = vga_b_sig[4:1];

	assign SD_CMD = sd_sdo_sig;
	assign SD_DATA = {sd_cs_n_sig, 1'bz, 1'bz, 1'bz};
	assign sd_sdi_sig = SD_DATA[0];

	assign LEDR = led_sig;

	assign HEX0 = led7seg_0_sig[6:0];
	assign HEX1 = led7seg_0_sig[14:8];
	assign HEX2 = led7seg_1_sig[6:0];
	assign HEX3 = led7seg_1_sig[14:8];
	assign HEX4 = led7seg_2_sig[6:0];
	assign HEX5 = led7seg_2_sig[14:8];

	assign GPIO_0[31:0] = gpio0_sig;
	assign GPIO_0[35:32] = {1'bz, 1'bz, 1'bz, 1'bz};



	// DVIトランスミッタインスタンス 

	dvi_tx_pdiff 
	dvi_inst (
		.reset			( ~vpll_locked_sig ),
		.clk			( clk25m175_sig ),
		.clk_x5			( clk_x5_sig ),

		.dvi_red		( {vga_r_sig, vga_r_sig[4:2]} ),
		.dvi_grn		( {vga_g_sig, vga_g_sig[4:2]} ),
		.dvi_blu		( {vga_b_sig, vga_b_sig[4:2]} ),
		.dvi_hsync		( ~vga_hs_n_sig ),
		.dvi_vsync		( ~vga_vs_n_sig ),
		.dvi_de			( vga_de_sig ),
		.dvi_ctl		( 4'b0000 ),

		.data0_p		( DVI_DATA0P ),
		.data0_n		( DVI_DATA0N ),
		.data1_p		( DVI_DATA1P ),
		.data1_n		( DVI_DATA1N ),
		.data2_p		( DVI_DATA2P ),
		.data2_n		( DVI_DATA2N ),
		.clock_p		( DVI_CLOCKP ),
		.clock_n		( DVI_CLOCKN )
	);



endmodule
