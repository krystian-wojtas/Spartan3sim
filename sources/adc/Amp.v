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
	input [3:0] amp_b
    );
	 
	 
	localparam WIDTH=8;
	
	wire [WIDTH-1:0] amp_datatosend = { amp_a, amp_b };
	wire [WIDTH-1:0] amp_datareceived;
	
	Spi #(
		.WIDTH(WIDTH),
		.DIV(6)
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
		//.data_out(amp_datareceived),
		.spi_trig(amp_trig),
		.spi_done(amp_done)
	);
	
	
	assign amp_shdn = ~RST;


endmodule
