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

// STATUS���W�X�^ 
//   rw  IRQENA : 0 IRQ���N�G�X�g���}�X�N 
//                1 IRQ���N�G�X�g������ 
//
//   ro  PLAY   : 0 �Đ���~ 
//                1 �Đ��� 
//
//   ro  IRQ    : 0 FIFO���󂢂Ă��Ȃ� 
//                1 FIFO�n�[�t�G���v�e�B(256���[�h�ȏ�̋󂫂�����)
//
//   rw  FIFORST: 0 FIFO��������� 
//                1 FIFO�����Z�b�g���� 
//
// VOLUME���W�X�^ 
//   rw  MUTE   : 0 MUTE���I�t 
//                1 �o�̓~���[�e�B���O 
//
//   rw  VOL_R  : 0x0000-0x4000 �o�͉���(0x0000:�ŏ� - 0x4000:�ő�)
//   rw  VOL_L  :      �V
//
// FIFOWR���W�X�^ 
//   wo  PCMDATA_R : 0x8000-0x7FFF  PCM�f�[�^(�E�`���l��)
//   wo  PCMDATA_L : 0x8000-0x7FFF  PCM�f�[�^(���`���l��)
//
//      ���̃��W�X�^�ɏ������ނ�PCM�f�[�^��FIFO�ɃL���[�C���O����� 
//      �ǂݏo���l�͕s�� 


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


/* ===== �O���ύX�\�p�����[�^ ========== */



/* ----- �����p�����[�^ ------------------ */



/* ���ȍ~�̃p�����[�^�錾�͋֎~�� */

/* ===== �m�[�h�錾 ====================== */
				/* �����͑S�Đ��_�����Z�b�g�Ƃ���B�����Œ�`���Ă��Ȃ��m�[�h�̎g�p�͋֎~ */
	wire			reset_sig = csi_reset;				// ���W���[�������쓮�񓯊����Z�b�g 

				/* �����͑S�Đ��G�b�W�쓮�Ƃ���B�����Œ�`���Ă��Ȃ��N���b�N�m�[�h�̎g�p�͋֎~ */
	wire			clock_sig = csi_clk;				// ���W���[�������쓮�N���b�N 
	wire			audclock_sig = coe_aud_clk;			// �I�[�f�B�I�쓮�N���b�N(256fs) 

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


/* ���ȍ~��wire�Areg�錾�͋֎~�� */

/* ===== �e�X�g�L�q ============== */


/* ===== ���W���[���\���L�q ============== */

	// ���W�X�^

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


	// �Đ�FIFO 

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


	// �^�C�~���O���� 

	always @(posedge audclock_sig or posedge reset_sig) begin
		if (reset_sig) begin
			fsdivcount_reg <= 1'd0;
		end
		else begin
			fsdivcount_reg <= fsdivcount_reg + 1'd1;
		end
	end

	assign fs_timing_sig = (fsdivcount_reg == 1'd0);


	// DAC�C���X�^���X 

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
