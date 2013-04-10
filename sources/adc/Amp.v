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
	 
	 
	localparam WIDTH=9;
	
	wire tick_neg;
	wire spi_sck_;
	ModClk #(
		.DIV(6)
	) ModClk_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_hf(spi_sck_), //half filled 50%
		.neg_trig(tick_neg)
	);
	
	
	wire [WIDTH-1:0] amp_datatosend = { 1'b1,  amp_b,  amp_a };
	Spi #(
		.WIDTH(WIDTH)
	) Spi_mosi (
		.CLKB(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_cs(amp_cs),
		.spi_mosi(spi_mosi),
		.spi_miso(1'b1),
		// spi module interface
		.data_in(amp_datatosend),
		.data_out(amp_datareceived),
		.trig(amp_trig),
		.ready(amp_done),
		.tick(tick_neg),
		.clk(CLK50MHZ) // TODO del
	);	
	
	reg ignorefirsttick = 1'b0;
	always @(posedge CLK50MHZ)
		if(RST)
			ignorefirsttick = 1'b0;
		else if(~amp_cs) begin
			if(tick_neg)
				ignorefirsttick = 1'b1;
		end else
			if(tick_neg)
				ignorefirsttick = 1'b0;
	
	
	assign spi_sck = (ignorefirsttick && ~amp_done) ? spi_sck_ : 1'b0;
	assign amp_shdn = ~RST;


endmodule
