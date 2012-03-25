`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:49 03/13/2012 
// Design Name: 
// Module Name:    dac 
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
module dacspi(
	input RST,
	input CLK50MHZ,
	// hardware dac interface
	output DAC_CS,
	output DAC_CLR,
	output SPI_MOSI,
	input	DAC_OUT,
	// verilog module interface
	input spi_sck_trig,
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrig,
	output dacdone
	);	
	
	wire spi_sending;
	wire spi_done;
	assign dacdone = spi_done;
	wire [31:0] dacdatatosend = {4'b1000, data, address, command, 8'd1};
	wire [31:0] dacdatareceived;
	spi spi_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.spi_sck_trig(spi_sck_trig),
		.SPI_MISO(DAC_OUT),
		.SPI_MOSI(SPI_MOSI),
		.data_in(dacdatatosend),
		.data_out(dacdatareceived),
		.spi_trig(dactrig),
		.spi_sending(spi_sending),
		.spi_done(spi_done)
	);
	
	assign DAC_CS = ~spi_sending;
	assign DAC_CLR = ~RST;
		
endmodule
