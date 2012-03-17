`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:07:44 03/12/2012 
// Design Name: 
// Module Name:    top 
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
module top(
	input CLK50MHZ,
	input RST,
	output SPI_MOSI,
	output SPI_SCK,
	output DAC_CS,
	output DAC_CLR,
	input DAC_OUT
   );

	wire spi_sck_trig;
	spisck spisck_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.SPI_SCK(SPI_SCK),
		.spi_sck_trig(spi_sck_trig)
	);
	
	
	wire [11:0] data = 12'd0;
	wire [3:0] address = 4'd0;
	wire [3:0] command = 4'd0;
	wire dactrig = 1'd0;
	wire dacdone = 1'd0;
	//TODO modul sterujacy powyzszymi
	
	dacspi dacspi_(
		.CLK50MHZ(CLK50MHZ),
		// hardware dac interface
		.RST(RST),
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.dac_in(SPI_MOSI),
		.DAC_OUT(DAC_OUT),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone)
	);
				

endmodule
