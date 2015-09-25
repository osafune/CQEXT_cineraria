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
	parameter		CONFIGTAP = 0		// TAP�̈ʒu���w�肷��(0:t-1 / 1:t0 / 2:t1 / 3:t2)
) (
	input			clk,

	input			shift,
	input [7:0]		phase,
	input [15:0]	din,
	output [15:0]	dout,
	output [31:0]	kout
);


/* ===== �O���ύX�\�p�����[�^ ========== */



/* ----- �����p�����[�^ ------------------ */



/* ���ȍ~�̃p�����[�^�錾�͋֎~�� */

/* ===== �m�[�h�錾 ====================== */
				/* �����͑S�Đ��_�����Z�b�g�Ƃ���B�����Œ�`���Ă��Ȃ��m�[�h�̎g�p�͋֎~ */
//	wire			reset_sig = reset;				// ���W���[�������쓮�񓯊����Z�b�g 

				/* �����͑S�Đ��G�b�W�쓮�Ƃ���B�����Œ�`���Ă��Ȃ��N���b�N�m�[�h�̎g�p�͋֎~ */
	wire			clock_sig = clk;				// ���W���[�������쓮�N���b�N 

	reg [15:0]		indata_reg;

	wire [8:0]		table_addr_sig;
	wire [17:0]		table_data_sig;

	reg [17:0]		mult_dataa_reg;
	reg [17:0]		mult_datab_reg;
	wire [35:0]		mult_result_sig;
	reg [31:0]		mult_result_reg;


/* ���ȍ~��wire�Areg�錾�͋֎~�� */

/* ===== �e�X�g�L�q ============== */



/* ===== ���W���[���\���L�q ============== */

	// �f�[�^���� 

	always @(posedge clock_sig) begin
		if (shift) begin
			indata_reg <= din;
		end
	end

	assign dout = indata_reg;


	// �W���e�[�u�� 

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


	// �W���̏�Z 

	always @(posedge clock_sig) begin
		mult_dataa_reg <= {{2{indata_reg[15]}}, indata_reg};	// S1:INT15
		mult_datab_reg <= table_data_sig;						// S1:INT1:DEC16	(�������l��Ԃ�-1.0�`1.0) 
		mult_result_reg <= mult_result_sig[31:0];				// S1:INT15:DEC16
	end

	os256_mult_s18xs18
	u1(
		.dataa	( mult_dataa_reg ),
		.datab	( mult_datab_reg ),
		.result	( mult_result_sig )
	);


	// �f�[�^�o�� 

	assign kout = mult_result_reg;


endmodule
