// altera_epcq_controller_core.v

// Generated using ACDS version 15.0 153

`timescale 1 ps / 1 ps
module altera_epcq_controller_core #(
		parameter DEVICE_FAMILY     = "Cyclone V",
		parameter ADDR_WIDTH        = 21,
		parameter ASMI_ADDR_WIDTH   = 24,
		parameter ASI_WIDTH         = 1,
		parameter CS_WIDTH          = 1,
		parameter CHIP_SELS         = 1,
		parameter ENABLE_4BYTE_ADDR = 0
	) (
		input  wire        clk,                  //          clock_sink.clk
		input  wire        reset_n,              //               reset.reset_n
		input  wire        avl_csr_read,         //             avl_csr.read
		output wire        avl_csr_waitrequest,  //                    .waitrequest
		input  wire        avl_csr_write,        //                    .write
		input  wire [2:0]  avl_csr_addr,         //                    .address
		input  wire [31:0] avl_csr_wrdata,       //                    .writedata
		output wire [31:0] avl_csr_rddata,       //                    .readdata
		output wire        avl_csr_rddata_valid, //                    .readdatavalid
		input  wire        avl_mem_write,        //             avl_mem.write
		input  wire [6:0]  avl_mem_burstcount,   //                    .burstcount
		output wire        avl_mem_waitrequest,  //                    .waitrequest
		input  wire        avl_mem_read,         //                    .read
		input  wire [20:0] avl_mem_addr,         //                    .address
		input  wire [31:0] avl_mem_wrdata,       //                    .writedata
		output wire [31:0] avl_mem_rddata,       //                    .readdata
		output wire        avl_mem_rddata_valid, //                    .readdatavalid
		input  wire [3:0]  avl_mem_byteenable,   //                    .byteenable
		input  wire [7:0]  asmi_status_out,      //     asmi_status_out.conduit_status_out
		input  wire [7:0]  asmi_epcs_id,         //        asmi_epcs_id.conduit_epcs_id
		input  wire        asmi_illegal_erase,   //  asmi_illegal_erase.conduit_illegal_erase
		input  wire        asmi_illegal_write,   //  asmi_illegal_write.conduit_illegal_write
		input  wire [0:0]  ddasi_dataoe,         //        ddasi_dataoe.conduit_ddasi_dataoe
		input  wire        ddasi_dclk,           //          ddasi_dclk.conduit_ddasi_dclk
		input  wire [0:0]  ddasi_scein,          //         ddasi_scein.conduit_ddasi_scein
		input  wire [0:0]  ddasi_sdoin,          //         ddasi_sdoin.conduit_ddasi_sdoin
		input  wire        asmi_busy,            //           asmi_busy.conduit_busy
		input  wire        asmi_data_valid,      //     asmi_data_valid.conduit_data_valid
		input  wire [7:0]  asmi_dataout,         //        asmi_dataout.conduit_dataout
		input  wire [0:0]  epcq_dataout,         //        epcq_dataout.conduit_epcq_dataout
		output wire [0:0]  ddasi_dataout,        //       ddasi_dataout.conduit_ddasi_dataout
		output wire        asmi_read_rdid,       //      asmi_read_rdid.conduit_read_rdid
		output wire        asmi_read_status,     //    asmi_read_status.conduit_read_status
		output wire        asmi_read_sid,        //       asmi_read_sid.conduit_read_sid
		output wire        asmi_bulk_erase,      //     asmi_bulk_erase.conduit_bulk_erase
		output wire        asmi_sector_erase,    //   asmi_sector_erase.conduit_sector_erase
		output wire        asmi_sector_protect,  // asmi_sector_protect.conduit_sector_protect
		output wire        epcq_dclk,            //           epcq_dclk.conduit_epcq_dclk
		output wire [0:0]  epcq_scein,           //          epcq_scein.conduit_epcq_scein
		output wire [0:0]  epcq_sdoin,           //          epcq_sdoin.conduit_epcq_sdoin
		output wire [0:0]  epcq_dataoe,          //         epcq_dataoe.conduit_epcq_dataoe
		output wire        asmi_clkin,           //          asmi_clkin.conduit_clkin
		output wire        asmi_reset,           //          asmi_reset.conduit_reset
		output wire [0:0]  asmi_sce,             //            asmi_sce.conduit_asmi_sce
		output wire [23:0] asmi_addr,            //           asmi_addr.conduit_addr
		output wire [7:0]  asmi_datain,          //         asmi_datain.conduit_datain
		output wire        asmi_fast_read,       //      asmi_fast_read.conduit_fast_read
		output wire        asmi_rden,            //           asmi_rden.conduit_rden
		output wire        asmi_shift_bytes,     //    asmi_shift_bytes.conduit_shift_bytes
		output wire        asmi_wren,            //           asmi_wren.conduit_wren
		output wire        asmi_write,           //          asmi_write.conduit_write
		input  wire [7:0]  asmi_rdid_out,        //       asmi_rdid_out.conduit_rdid_out
		output wire        asmi_en4b_addr,       //      asmi_en4b_addr.conduit_en4b_addr
		output wire        irq                   //    interrupt_sender.irq
	);

	generate
		// If any of the display statements (or deliberately broken
		// instantiations) within this generate block triggers then this module
		// has been instantiated this module with a set of parameters different
		// from those it was generated for.  This will usually result in a
		// non-functioning system.
		if (DEVICE_FAMILY != "Cyclone V")
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					device_family_check ( .error(1'b1) );
		end
		if (ADDR_WIDTH != 21)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					addr_width_check ( .error(1'b1) );
		end
		if (ASMI_ADDR_WIDTH != 24)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					asmi_addr_width_check ( .error(1'b1) );
		end
		if (ASI_WIDTH != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					asi_width_check ( .error(1'b1) );
		end
		if (CS_WIDTH != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					cs_width_check ( .error(1'b1) );
		end
		if (CHIP_SELS != 1)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					chip_sels_check ( .error(1'b1) );
		end
		if (ENABLE_4BYTE_ADDR != 0)
		begin
			initial begin
				$display("Generated module instantiated with wrong parameters");
				$stop;
			end
			instantiated_with_wrong_parameters_error_see_comment_above
					enable_4byte_addr_check ( .error(1'b1) );
		end
	endgenerate

	altera_epcq_controller_arb #(
		.DEVICE_FAMILY     ("Cyclone V"),
		.ADDR_WIDTH        (21),
		.ASMI_ADDR_WIDTH   (24),
		.ASI_WIDTH         (1),
		.CS_WIDTH          (1),
		.CHIP_SELS         (1),
		.ENABLE_4BYTE_ADDR (0)
	) altera_epcq_controller_core (
		.clk                  (clk),                  //          clock_sink.clk
		.reset_n              (reset_n),              //               reset.reset_n
		.avl_csr_read         (avl_csr_read),         //             avl_csr.read
		.avl_csr_waitrequest  (avl_csr_waitrequest),  //                    .waitrequest
		.avl_csr_write        (avl_csr_write),        //                    .write
		.avl_csr_addr         (avl_csr_addr),         //                    .address
		.avl_csr_wrdata       (avl_csr_wrdata),       //                    .writedata
		.avl_csr_rddata       (avl_csr_rddata),       //                    .readdata
		.avl_csr_rddata_valid (avl_csr_rddata_valid), //                    .readdatavalid
		.avl_mem_write        (avl_mem_write),        //             avl_mem.write
		.avl_mem_burstcount   (avl_mem_burstcount),   //                    .burstcount
		.avl_mem_waitrequest  (avl_mem_waitrequest),  //                    .waitrequest
		.avl_mem_read         (avl_mem_read),         //                    .read
		.avl_mem_addr         (avl_mem_addr),         //                    .address
		.avl_mem_wrdata       (avl_mem_wrdata),       //                    .writedata
		.avl_mem_rddata       (avl_mem_rddata),       //                    .readdata
		.avl_mem_rddata_valid (avl_mem_rddata_valid), //                    .readdatavalid
		.avl_mem_byteenable   (avl_mem_byteenable),   //                    .byteenable
		.asmi_status_out      (asmi_status_out),      //     asmi_status_out.conduit_status_out
		.asmi_epcs_id         (asmi_epcs_id),         //        asmi_epcs_id.conduit_epcs_id
		.asmi_illegal_erase   (asmi_illegal_erase),   //  asmi_illegal_erase.conduit_illegal_erase
		.asmi_illegal_write   (asmi_illegal_write),   //  asmi_illegal_write.conduit_illegal_write
		.ddasi_dataoe         (ddasi_dataoe),         //        ddasi_dataoe.conduit_ddasi_dataoe
		.ddasi_dclk           (ddasi_dclk),           //          ddasi_dclk.conduit_ddasi_dclk
		.ddasi_scein          (ddasi_scein),          //         ddasi_scein.conduit_ddasi_scein
		.ddasi_sdoin          (ddasi_sdoin),          //         ddasi_sdoin.conduit_ddasi_sdoin
		.asmi_busy            (asmi_busy),            //           asmi_busy.conduit_busy
		.asmi_data_valid      (asmi_data_valid),      //     asmi_data_valid.conduit_data_valid
		.asmi_dataout         (asmi_dataout),         //        asmi_dataout.conduit_dataout
		.epcq_dataout         (epcq_dataout),         //        epcq_dataout.conduit_epcq_dataout
		.ddasi_dataout        (ddasi_dataout),        //       ddasi_dataout.conduit_ddasi_dataout
		.asmi_read_rdid       (asmi_read_rdid),       //      asmi_read_rdid.conduit_read_rdid
		.asmi_read_status     (asmi_read_status),     //    asmi_read_status.conduit_read_status
		.asmi_read_sid        (asmi_read_sid),        //       asmi_read_sid.conduit_read_sid
		.asmi_bulk_erase      (asmi_bulk_erase),      //     asmi_bulk_erase.conduit_bulk_erase
		.asmi_sector_erase    (asmi_sector_erase),    //   asmi_sector_erase.conduit_sector_erase
		.asmi_sector_protect  (asmi_sector_protect),  // asmi_sector_protect.conduit_sector_protect
		.epcq_dclk            (epcq_dclk),            //           epcq_dclk.conduit_epcq_dclk
		.epcq_scein           (epcq_scein),           //          epcq_scein.conduit_epcq_scein
		.epcq_sdoin           (epcq_sdoin),           //          epcq_sdoin.conduit_epcq_sdoin
		.epcq_dataoe          (epcq_dataoe),          //         epcq_dataoe.conduit_epcq_dataoe
		.asmi_clkin           (asmi_clkin),           //          asmi_clkin.conduit_clkin
		.asmi_reset           (asmi_reset),           //          asmi_reset.conduit_reset
		.asmi_sce             (asmi_sce),             //            asmi_sce.conduit_asmi_sce
		.asmi_addr            (asmi_addr),            //           asmi_addr.conduit_addr
		.asmi_datain          (asmi_datain),          //         asmi_datain.conduit_datain
		.asmi_fast_read       (asmi_fast_read),       //      asmi_fast_read.conduit_fast_read
		.asmi_rden            (asmi_rden),            //           asmi_rden.conduit_rden
		.asmi_shift_bytes     (asmi_shift_bytes),     //    asmi_shift_bytes.conduit_shift_bytes
		.asmi_wren            (asmi_wren),            //           asmi_wren.conduit_wren
		.asmi_write           (asmi_write),           //          asmi_write.conduit_write
		.asmi_rdid_out        (asmi_rdid_out),        //       asmi_rdid_out.conduit_rdid_out
		.asmi_en4b_addr       (asmi_en4b_addr),       //      asmi_en4b_addr.conduit_en4b_addr
		.irq                  (irq)                   //    interrupt_sender.irq
	);

endmodule
