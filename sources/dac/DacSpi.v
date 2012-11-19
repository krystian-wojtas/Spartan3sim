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
	output [32:0] dac_datareceived, //TODO 31 _
	input dactrig,
	output dacdone
	);
	
	localparam WIDTH=33;
	
	wire [WIDTH-1:0] dacdatatosend = {9'h080, command, address, data, 4'h1};
	wire spi_sck;
	Spi #(
		.WIDTH(WIDTH)
	) Spi_ (
		.CLKB(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(DAC_CS),
		.spi_mosi(SPI_MOSI),
		.spi_miso(DAC_OUT),
		// spi module interface
		.data_in(dacdatatosend),
		.data_out(dac_datareceived),
		.trig(dactrig),
		.ready(dacdone),
		.clk(CLK50MHZ),
		.tick(1'b1)
	);
	
	reg ignorefirsttick = 1'b0;
	always @(posedge CLK50MHZ)
		if(RST)
			ignorefirsttick = 1'b0;
		else if(~DAC_CS)
			ignorefirsttick = 1'b1;
		else
			ignorefirsttick = 1'b0;
			
			
	assign SPI_SCK = (ignorefirsttick && ~dacdone) ? spi_sck : 1'b0;	
	assign DAC_CLR = ~RST;
	
endmodule
