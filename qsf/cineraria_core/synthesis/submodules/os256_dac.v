// ===================================================================
// TITLE : x256 Oversampling 1bit-DSM D/A output module
//
//   DEGISN : S.OSAFUNE ( s.osafune@j7system.jp )
//   DATE   : 2015/09/07 -> 2015/09/13
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


module os256_dac (
	output [33:0]	test_tapadder,
	output			test_shift,

	input			clk,			// 256fs input
	input			reset,

	input [14:0]	volume,			// min:0x0000 - max:0x4000
	input			mute,			// 1:muting / 0:drive

	input			fs_timing,
	input [15:0]	sample_din,
	output			dsm_out
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */

	localparam		DSM_DATABITWIDTH = 32;		// DSM出力ビット(12～32bit)


/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
	wire			reset_sig = reset;				// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = clk;				// モジュール内部駆動クロック 

	wire			shift_sig;
	reg [7:0]		phase_reg;
	reg [14:0]		volume_reg;
	reg				mute_reg;
	reg [15:0]		datain_reg;

	wire [15:0]		tap3_dout_sig;
	wire [15:0]		tap2_dout_sig;
	wire [15:0]		tap1_dout_sig;
	wire [31:0]		tap3_kout_sig;
	wire [31:0]		tap2_kout_sig;
	wire [31:0]		tap1_kout_sig;
	wire [31:0]		tap0_kout_sig;
	reg  [33:0]		tapadder_reg;
	wire [17:0]		tapsat_sig;

	reg  [17:0]		sample_reg;
	wire [17:0]		mult_dataa_sig;
	wire [17:0]		mult_datab_sig;
	wire [35:0]		mult_result_sig;

	reg  [31:0]		dsmdata_reg;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */

	assign test_tapadder = tapadder_reg;
	assign test_shift = shift_sig;


/* ===== モジュール構造記述 ============== */

	// データ入力 

	always @(posedge clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			phase_reg  <= 1'd0;
			volume_reg <= 1'd0;
			mute_reg   <= 1'b1;
		end
		else begin
			if (fs_timing) begin
				phase_reg <= 1'd0;
			end
			else begin
				phase_reg <= phase_reg + 1'd1;
			end

			if (fs_timing) begin
				if (volume[14] == 1'b0) begin
					volume_reg <= volume;
				end
				else begin
					volume_reg = 15'h4000;
				end
				mute_reg   <= mute;
				datain_reg <= sample_din;
			end
		end
	end

	assign shift_sig = (phase_reg == 1'd0);


	// オーバーサンプリングモジュール 

	os256_tap #(
		.CONFIGTAP	(3)		// t2区間 
	)
	tap3 (
		.clk		( clock_sig ),
		.shift		( shift_sig ),
		.phase		( phase_reg ),
		.din		( datain_reg ),
		.dout		( tap3_dout_sig ),
		.kout		( tap3_kout_sig )
	);

	os256_tap #(
		.CONFIGTAP	(2)		// t1区間 
	)
	tap2 (
		.clk		( clock_sig ),
		.shift		( shift_sig ),
		.phase		( phase_reg ),
		.din		( tap3_dout_sig ),
		.dout		( tap2_dout_sig ),
		.kout		( tap2_kout_sig )
	);

	os256_tap #(
		.CONFIGTAP	(1)		// t0区間 
	)
	tap1 (
		.clk		( clock_sig ),
		.shift		( shift_sig ),
		.phase		( phase_reg ),
		.din		( tap2_dout_sig ),
		.dout		( tap1_dout_sig ),
		.kout		( tap1_kout_sig )
	);

	os256_tap #(
		.CONFIGTAP	(0)		// t-1区間 
	)
	tap0 (
		.clk		( clock_sig ),
		.shift		( shift_sig ),
		.phase		( phase_reg ),
		.din		( tap1_dout_sig ),
		.dout		(),
		.kout		( tap0_kout_sig )
	);

	always @(posedge clock_sig) begin
		tapadder_reg <= 
				{{2{tap3_kout_sig[31]}}, tap3_kout_sig} +
				{{2{tap2_kout_sig[31]}}, tap2_kout_sig} +
				{{2{tap1_kout_sig[31]}}, tap1_kout_sig} +
				{{2{tap0_kout_sig[31]}}, tap0_kout_sig};
	end

	assign tapsat_sig =
			(tapadder_reg[33] == 1'b0 && tapadder_reg[32:31] != 2'b00)? 18'h1ffff :
			(tapadder_reg[33] == 1'b1 && tapadder_reg[32:31] != 2'b11)? 18'h20000 :
			tapadder_reg[31:14];


	// ボリュームの計算 

	always @(posedge clock_sig) begin
		sample_reg  <= tapsat_sig;
		dsmdata_reg <= mult_result_sig[31:0];
	end

	assign mult_dataa_sig = {3'b000, volume_reg};		// S0:INT1:DEC14 (ただし値区間は0.0～1.0) 
	assign mult_datab_sig = sample_reg;					// S1:INT17

	os256_mult_s18xs18
	u0(
		.dataa	( mult_dataa_sig ),
		.datab	( mult_datab_sig ),
		.result	( mult_result_sig )
	);


	// 1bitΔΣ変調モジュール 

	os256_dsm #(
		.DATABITWIDTH	(DSM_DATABITWIDTH)
	)
	dsm (
		.clk		( clock_sig ),
		.reset		( mute_reg ),
		.din		( dsmdata_reg[31:31-(DSM_DATABITWIDTH-1)] ),
		.dsm		( dsm_out )
	);



endmodule
