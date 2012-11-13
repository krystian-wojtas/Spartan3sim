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
	 
	 
	localparam WIDTH=8;
	
	wire tick_pos;
	wire tick_neg;
	wire clk;
	ModClk #(
		.DIV(4),
		.DELAY(1)
	) ModClk_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_hf(clk), //half filled 50%
		.pos_trig(tick_pos),
		.neg_trig(tick_neg)
	);
	
	
	wire [WIDTH-1:0] amp_datatosend = { amp_b,  amp_a };
	Spi #(
		.WIDTH(WIDTH)
	) Spi_mosi (
		.CLKB(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(amp_cs),
		.spi_mosi(spi_mosi),
		.spi_miso(1'b1),
		// spi module interface
		.data_in(amp_datatosend),
		.trig(amp_trig),
		.ready(amp_done),
		.clk(clk),
		.tick(tick_pos)
	);
	
	

	Shiftreg #(
		.WIDTH(WIDTH)
	) Shiftreg_ (
		.CLKB(CLK50MHZ),
		// shiftreg
		.en(1'b1),
		.set(1'b0),
//		.set(trig), // setting shiftreg value to data_in if trig occurs
		.tick(tick_neg),
		.rx(amp_dout),
//		.tx(tx),
		.data_in( 0 ),
		.data_out(amp_datareceived)
	);
	
	
	assign amp_shdn = ~RST;


endmodule
