// ===================================================================
// TITLE : Lanczos-2 interpolater
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


module os256_tap #(
	parameter		CONFIGTAP = 0		// TAPの位置を指定する(0:t-1 / 1:t0 / 2:t1 / 3:t2)
) (
	input			clk,

	input			shift,
	input [7:0]		phase,
	input [15:0]	din,
	output [15:0]	dout,
	output [31:0]	kout
);


/* ===== 外部変更可能パラメータ ========== */



/* ----- 内部パラメータ ------------------ */



/* ※以降のパラメータ宣言は禁止※ */

/* ===== ノード宣言 ====================== */
				/* 内部は全て正論理リセットとする。ここで定義していないノードの使用は禁止 */
//	wire			reset_sig = reset;				// モジュール内部駆動非同期リセット 

				/* 内部は全て正エッジ駆動とする。ここで定義していないクロックノードの使用は禁止 */
	wire			clock_sig = clk;				// モジュール内部駆動クロック 

	reg [15:0]		indata_reg;

	wire [8:0]		table_addr_sig;
	wire [17:0]		table_data_sig;

	reg [17:0]		mult_dataa_reg;
	reg [17:0]		mult_datab_reg;
	wire [35:0]		mult_result_sig;
	reg [31:0]		mult_result_reg;


/* ※以降のwire、reg宣言は禁止※ */

/* ===== テスト記述 ============== */



/* ===== モジュール構造記述 ============== */

	// データ入力 

	always @(posedge clock_sig) begin
		if (shift) begin
			indata_reg <= din;
		end
	end

	assign dout = indata_reg;


	// 係数テーブル 

	assign table_addr_sig = 
			(CONFIGTAP == 0)? {1'b1, phase} :				// t-1 (511-256)
			(CONFIGTAP == 1)? {1'b0, phase} :				// t0  (255-0)
			(CONFIGTAP == 2)? 9'd256 - {1'b0, phase} :		// t1  (1-256)
			(CONFIGTAP == 3)? {1'b1, ~(phase - 8'd1)} :		// t2  (257-512(256))
			9'd256;

	os256_lanczos_table
	u0(
		.clock	( clock_sig ),
		.address( table_addr_sig ),
		.q		( table_data_sig )
	);


	// 係数の乗算 

	always @(posedge clock_sig) begin
		mult_dataa_reg <= {{2{indata_reg[15]}}, indata_reg};	// S1:INT15
		mult_datab_reg <= table_data_sig;						// S1:INT1:DEC16	(ただし値区間は-1.0～1.0) 
		mult_result_reg <= mult_result_sig[31:0];				// S1:INT15:DEC16
	end

	os256_mult_s18xs18
	u1(
		.dataa	( mult_dataa_reg ),
		.datab	( mult_datab_reg ),
		.result	( mult_result_sig )
	);


	// データ出力 

	assign kout = mult_result_reg;


endmodule
