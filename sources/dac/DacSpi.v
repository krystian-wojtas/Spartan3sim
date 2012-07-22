`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:49 03/13/2012 
// Design Name: 
// Module Name:    DacSpi 
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
module DacSpi (
	input RST,
	input CLK50MHZ,
	// hardware dac interface
	output SPI_SCK,
	output DAC_CLR,
	output DAC_CS,
	output SPI_MOSI,
	input	DAC_OUT,
	// verilog module interface
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrig,
	output dacdone
	);
	
	localparam WIDTH=32;
	
	wire [WIDTH-1:0] dacdatatosend = {8'h80, command, address, data, 4'h1};
	wire [WIDTH-1:0] dacdatareceived;
	Spi #(
		.WIDTH(WIDTH)
	) Spi_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(SPI_SCK),
		.spi_cs(DAC_CS),
		.spi_mosi(SPI_MOSI),
		.spi_miso(DAC_OUT),
		// spi module interface
		.data_in(dacdatatosend),
		.data_out(dacdatareceived),
		.spi_trig(dactrig),
		.spi_done(dacdone)
	);
	
	assign DAC_CLR = ~RST;
	
endmodule
