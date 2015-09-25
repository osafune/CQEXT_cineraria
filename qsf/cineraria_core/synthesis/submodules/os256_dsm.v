// ===================================================================
// TITLE : 1bit Delta-Sigma modulator
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


module os256_dsm #(
	parameter		DATABITWIDTH = 16
) (
	input			clk,
	input			reset,

	input [DATABITWIDTH-1:0] din,	// �����t������ 
	output			dsm
);


/* ===== �O���ύX�\�p�����[�^ ========== */



/* ----- �����p�����[�^ ------------------ */



/* ���ȍ~�̃p�����[�^�錾�͋֎~�� */

/* ===== �m�[�h�錾 ====================== */
				/* �����͑S�Đ��_�����Z�b�g�Ƃ���B�����Œ�`���Ă��Ȃ��m�[�h�̎g�p�͋֎~ */
	wire			reset_sig = reset;				// ���W���[�������쓮�񓯊����Z�b�g 

				/* �����͑S�Đ��G�b�W�쓮�Ƃ���B�����Œ�`���Ă��Ȃ��N���b�N�m�[�h�̎g�p�͋֎~ */
	wire			clock_sig = clk;				// ���W���[�������쓮�N���b�N 

	reg  [DATABITWIDTH-1:0]	indata_reg;

	wire [DATABITWIDTH:0]	add1_sig;
	reg  [DATABITWIDTH-3:0]	z1_reg, z2_reg;
	reg  [2:0]				zo_reg;

	wire [3:0]				add2_sig;
	reg  [2:0]				ze_reg;
	reg						dsmout_reg;


/* ���ȍ~��wire�Areg�錾�͋֎~�� */

/* ===== �e�X�g�L�q ============== */



/* ===== ���W���[���\���L�q ============== */

	// 1bit�����ϒ� (�O�i2���{��i1���ϒ�) 

	assign add1_sig = {indata_reg[DATABITWIDTH-1], indata_reg} - {3'b000, z2_reg} + {2'b00, z1_reg, 1'b0};
	assign add2_sig = {1'b0, ~zo_reg[2], zo_reg[1:0]} + {1'b0, ze_reg};

	always @(posedge clock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			z1_reg <= 1'd0;
			z2_reg <= 1'd0;
			zo_reg <= 1'd0;

			ze_reg <= 1'd0;
			dsmout_reg <= 1'b0;
		end
		else begin
			indata_reg <= din;

			z1_reg <= add1_sig[DATABITWIDTH-3:0];
			z2_reg <= z1_reg;
			zo_reg <= add1_sig[DATABITWIDTH:DATABITWIDTH-2];

			ze_reg <= add2_sig[2:0];
			dsmout_reg <= add2_sig[3];
		end
	end


	// �f�[�^�o�� 

	assign dsm = dsmout_reg;


endmodule
