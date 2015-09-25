// ===================================================================
// TITLE : PCM playback component
//
//   DEGISN : S.OSAFUNE ( s.osafune@j7system.jp )
//   DATE   : 2015/09/07 -> 2015/09/08
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


// reg00 STATUS  bit31:IRQENA bit2:PLAY bit1:IRQ bit0:FIFORST
// reg01 VOLUME  bit31:MUTE bit30-16:VOL_R bit14-0:VOL_L
// reg02 FIFOWR  bit31-16:PCMDATA_R bit15-0:PCMDATA_L
// reg03 rsv

// STATUSレジスタ 
//   rw  IRQENA : 0 IRQリクエストをマスク 
//                1 IRQリクエストを許可 
//
//   ro  PLAY   : 0 再生停止 
//                1 再生中 
//
//   ro  IRQ    : 0 FIFOが空いていない 
//                1 FIFOハーフエンプティ(256ワード以上の空きがある)
//
//   rw  FIFORST: 0 FIFO動作をする 
//                1 FIFOをリセットする 
//
// VOLUMEレジスタ 
//   rw  MUTE   : 0 MUTEをオフ 
//                1 出力ミューティング 
//
//   rw  VOL_R  : 0x0000-0x4000 出力音量(0x0000:最小 - 0x4000:最大)
//   rw  VOL_L  :      〃
//
// FIFOWRレジスタ 
//   wo  PCMDATA_R : 0x8000-0x7FFF  PCMデータ(右チャネル)
//   wo  PCMDATA_L : 0x8000-0x7FFF  PCMデータ(左チャネル)
//
//      このレジスタに書き込むとPCMデータがFIFOにキューイングされる 
//      読み出し値は不定 


module pcm_component(
	// Interface: clk
	input			csi_clk,
	input			csi_reset,

	// Interface: Avalon-MM slave
	input  [1:0]	avs_address,
	input			avs_read,
	output [31:0]	avs_readdata,
	input			avs_write,
	input  [31:0]	avs_writedata,

	// Interface: Avalon-MM Interrupt sender
	output			ins_irq,

	// External Interface
	input			coe_aud_clk,
	output			coe_aud_mute,
	output			coe_aud_l,
	output			coe_aud_r
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */



/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
	wire			reset_sig = csi_reset;				// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = csi_clk;				// モジュール内部駆動クロック 
	wire			audclock_sig = coe_aud_clk;			// オーディオ駆動クロック(256fs) 

	reg				irqena_reg;
	reg				fiforeset_reg;
	reg				mute_reg;
	reg [14:0]		volume_l_reg, volume_r_reg;

	reg [7:0]		fsdivcount_reg;
	wire			fs_timing_sig;

	wire [31:0]		fifowrdata_sig;
	wire			fifowrreq_sig;
	wire			fifowrfull_sig;
	wire			fifowrempty_sig;
	wire [9:0]		fifousedw_sig;
	wire [31:0]		fifoq_sig;
	wire			fifordempty_sig;
	wire			fifoirq_sig;
	wire [15:0]		pcmdata_l_sig, pcmdata_r_sig;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */


/* ===== モジュール構造記述 ============== */

	// レジスタ

	assign avs_readdata =
			(avs_address == 2'd0)? {irqena_reg, 28'b0, ~fifowrempty_sig, fifoirq_sig, fiforeset_reg} :
			(avs_address == 2'd1)? {mute_reg, volume_r_reg, 1'b0, volume_l_reg} :
			{32{1'bx}};

	assign ins_irq = (irqena_reg)? fifoirq_sig : 1'b0;

	always @(posedge clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			irqena_reg    <= 1'b0;
			fiforeset_reg <= 1'b1;
			mute_reg     <= 1'b1;
			volume_r_reg <= 1'd0;
			volume_l_reg <= 1'd0;
		end
		else begin
			if (avs_write) begin
				case (avs_address)
					2'd0 : begin
						irqena_reg    <= avs_writedata[31];
						fiforeset_reg <= avs_writedata[0];
					end
					2'd1 : begin
						mute_reg     <= avs_writedata[31];
						volume_r_reg <= avs_writedata[30:16];
						volume_l_reg <= avs_writedata[14:0];
					end
				endcase
			end

		end
	end

	assign fifowrdata_sig = avs_writedata;
	assign fifowrreq_sig  = (avs_write && avs_address == 2'd2)? 1'b1 : 1'b0;

	assign fifoirq_sig = (!fifowrfull_sig && fifousedw_sig < 10'd768)? 1'b1 : 1'b0;


	// 再生FIFO 

	pcm_fifo
	u0 (
		.aclr			( fiforeset_reg ),

		.wrclk			( clock_sig ),
		.data			( fifowrdata_sig ),
		.wrreq			( fifowrreq_sig ),
		.wrfull			( fifowrfull_sig ),
		.wrusedw		( fifousedw_sig ),
		.wrempty		( fifowrempty_sig ),

		.rdclk			( audclock_sig ),
		.rdreq			( fs_timing_sig ),
		.q				( fifoq_sig ),
		.rdempty		( fifordempty_sig )
	);

	assign pcmdata_l_sig = (fifordempty_sig)? 16'd0 : fifoq_sig[15:0];
	assign pcmdata_r_sig = (fifordempty_sig)? 16'd0 : fifoq_sig[31:16];


	// タイミング生成 

	always @(posedge audclock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			fsdivcount_reg <= 1'd0;
		end
		else begin
			fsdivcount_reg <= fsdivcount_reg + 1'd1;
		end
	end

	assign fs_timing_sig = (fsdivcount_reg == 1'd0);


	// DACインスタンス 

	os256_dac
	dac_l (
		.clk			( audclock_sig ),
		.reset			( reset_sig ),
		.volume			( volume_l_reg ),
		.mute			( mute_reg ),
		.fs_timing		( fs_timing_sig ),
		.sample_din		( pcmdata_l_sig ),
		.dsm_out		( coe_aud_l )
	);

	os256_dac
	dac_r (
		.clk			( audclock_sig ),
		.reset			( reset_sig ),
		.volume			( volume_r_reg ),
		.mute			( mute_reg ),
		.fs_timing		( fs_timing_sig ),
		.sample_din		( pcmdata_r_sig ),
		.dsm_out		( coe_aud_r )
	);

	assign coe_aud_mute = mute_reg;



endmodule
