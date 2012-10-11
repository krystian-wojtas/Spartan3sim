`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:19 07/22/2012 
// Design Name: 
// Module Name:    Amp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Amp(
	input CLK50MHZ,
	input RST,
	// spi wires
	output spi_sck,
	output spi_mosi,
	// amp wires
	input amp_dout,
	output amp_cs,
	output amp_shdn,
	// amp module interface
	input amp_trig,
	output amp_done,
	input [3:0] amp_a,
	input [3:0] amp_b,
	// debug
	output [7:0] amp_datareceived
    );
	 
	
	wire clk_hf;
	wire clk_pos_trig;
	wire clk_neg_trig;
	ModClkConditional #(
		.DIV(4)
	)  ModClkConditional_ (
		.CLK50MHZ(CLK50MHZ),
		.clk_hf(clk_hf),
		.clk_pos_trig(clk_pos_trig),
		.clk_neg_trig(clk_neg_trig)	
	);
	
	 
	localparam WIDTH=8;
	
	wire [WIDTH-1:0] amp_datatosend = { amp_b,  amp_a };	
	Spi #(
		.WIDTH(WIDTH)
	) Spi_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(amp_cs),
		.spi_mosi(spi_mosi),
		.spi_miso(amp_dout),
		// spi module interface
		.data_in(amp_datatosend),
		.data_out(amp_datareceived),
		.spi_trig(amp_trig),
		.spi_done(amp_done),
		// spi clock
		.clk_hf(clk_hf),
		.write_trig(clk_neg_trig),
		.read_trig(clk_pos_trig)	
	);
	
	
	assign amp_shdn = ~RST;


endmodule
