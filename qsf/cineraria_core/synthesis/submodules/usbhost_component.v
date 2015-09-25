// ===================================================================
//	Title  : USBホストコンポーネント (OpenCores UsbHostSlaveWapper)
//
//	Design : S.OSAFUNE (J-7SYSTEM Works / s.osafune@gmail.com)
//	Date   : 2013/03/09 -> 
//	Update : 
//
// -------------------------------------------------------------------
//     Copyright (C) 2013, J-7SYSTEM Works.  All rights Reserved.
//
// * This module is a free sourcecode and there is NO WARRANTY.
// * No restriction on use. You can use, modify and redistribute it
//   for personal, non-profit or commercial products UNDER YOUR
//   RESPONSIBILITY.
// * Redistributions of source code must retain the above copyright
//   notice.
// ===================================================================

//`default_nettype none	// 未定義ノードの禁止 

module usbhost_component(
	output			test_dataouttick,
	output			test_dataintick,

	// AvalonMM レジスタスレーブ 

	input			avs_s1_clk,
	input			avs_s1_reset,

	input			avs_s1_chipselect,
	input  [7:0]	avs_s1_address,
	input			avs_s1_read,
	output [7:0]	avs_s1_readdata,
	input			avs_s1_write,
	input  [7:0]	avs_s1_writedata,

	output			avs_s1_waitrequest,
	output			avs_s1_irq,

	// USB信号 

	input			usbclk_48mhz,
	inout			usb_dp,
	inout			usb_dm,
	output			usb_oe_n,
	output			usb_fullspeed
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */


/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
	wire			reset_sig = avs_s1_reset;			// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = avs_s1_clk;				// モジュール内部駆動クロック 

	wire			strobe_i_sig;
	wire			ack_o_sig;
	wire			host_sofsent_sig;		//hostSOFSentIntOut; 
	wire			host_connevnt_sig;		//hostConnEventIntOut; 
	wire			host_resume_sig;		//hostResumeIntOut; 
	wire			host_transdone_sig;		//hostTransDoneIntOut;
	wire			usb_outena_sig;			//USBWireCtrlOut;
	wire [1:0]		usb_datain_sig;			//USBWireDataIn;
	wire [1:0]		usb_dataout_sig;		//USBWireDataOut;
	wire			usb_dataintick_sig;
	wire			usb_dataouttick_sig;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テストポート記述 ============== */

	assign test_dataintick  = usb_dataintick_sig;
	assign test_dataouttick = usb_dataouttick_sig;


/* ===== モジュール構造記述 ============== */

	assign strobe_i_sig = avs_s1_chipselect & (avs_s1_read | avs_s1_write);

	assign avs_s1_irq = host_sofsent_sig | host_connevnt_sig | host_resume_sig | host_transdone_sig;
	assign avs_s1_waitrequest = ~ack_o_sig;

	assign usb_datain_sig[1] = usb_dp;
	assign usb_datain_sig[0] = usb_dm;
	assign usb_dp = (usb_outena_sig)? usb_dataout_sig[1] : 1'bz;
	assign usb_dm = (usb_outena_sig)? usb_dataout_sig[0] : 1'bz;

	assign usb_oe_n = ~usb_outena_sig;


	// USBHostSlaveモジュールのインスタンス 

	defparam usbHostInst.HOST_FIFO_DEPTH = 64;
	parameter HOST_FIFO_DEPTH = 64;
	defparam usbHostInst.HOST_FIFO_ADDR_WIDTH = 6;
	parameter HOST_FIFO_ADDR_WIDTH = 6;
	usbHost usbHostInst (
		.clk_i(clock_sig),
		.rst_i(reset_sig),
		.address_i(avs_s1_address),
		.data_i(avs_s1_writedata),
		.data_o(avs_s1_readdata),
		.we_i(avs_s1_write),
		.strobe_i(strobe_i_sig),
		.ack_o(ack_o_sig),
		.usbClk(usbclk_48mhz),
		.hostSOFSentIntOut(host_sofsent_sig),
		.hostConnEventIntOut(host_connevnt_sig),
		.hostResumeIntOut(host_resume_sig),
		.hostTransDoneIntOut(host_transdone_sig),
		.USBWireDataIn(usb_datain_sig),
		.USBWireDataInTick(usb_dataintick_sig),		// テスト用 
		.USBWireDataOut(usb_dataout_sig),
		.USBWireDataOutTick(usb_dataouttick_sig),	// テスト用 
		.USBWireCtrlOut(usb_outena_sig),
		.USBFullSpeed(usb_fullspeed)
	);


endmodule
//`default_nettype wire	// 未定義ノードの禁止ここまで 

