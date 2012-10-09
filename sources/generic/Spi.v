`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:36 03/17/2012 
// Design Name: 
// Module Name:    Spi 
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

module Spi #(
	parameter WIDTH=32,
	parameter DIV=1
) (
	input RST,
	input CLK50MHZ,
	// spi lines
	output spi_sck,
	output spi_cs,
	input spi_miso,
	output spi_mosi,
	// spi module interface
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	input spi_trig,
	output spi_done
    );
	 	
	
	wire clk_hf;
	wire clk_pos_trig;
	wire clk_neg_trig;
	ModClkConditional #(
		.DIV(DIV)
	) ModClkConditional_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_hf(clk_hf),
		.clk_pos_trig(clk_pos_trig),
		.clk_neg_trig(clk_neg_trig)	
	);
	
	
	SpiCore #(
		.WIDTH(WIDTH)
	) SpiCore_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(spi_cs),
		.spi_mosi(spi_mosi),
		.spi_miso(spi_miso),
		// spi module interface
		.data_in(data_in),
		.data_out(data_out),
		.spi_trig(spi_trig),
		.spi_done(spi_done),
		// spi clock
		.clk_hf(clk_hf),
		.clk_pos_trig(clk_pos_trig),
		.clk_neg_trig(clk_neg_trig)		
	);

endmodule
