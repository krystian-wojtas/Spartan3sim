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
	//input BTN_SOUTH,
	output SPI_MOSI,
	output SPI_SCK,
	output DAC_CS,
	output DAC_CLR,
	input DAC_OUT,
	output [7:0] LED
   );	

	wire spi_sck_trig;
	spisck spisck_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.SPI_SCK(SPI_SCK),
		.spi_sck_trig(spi_sck_trig)
	);
	
	
	wire [11:0] data;
	wire [3:0] address;
	wire [3:0] command;
	wire dactrig;
	wire dacdone;
//	assign data = 12'h03f;
//	assign address = 4'b1111;
//	assign command = 4'b0011;
//	assign dactrig = 1'b1;
	cntr cntr_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// debug
		.LED(LED),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone)		
	);
	
	dacspi dacspi_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// hardware dac interface
		.spi_sck_trig(spi_sck_trig),
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.SPI_MOSI(SPI_MOSI),
		.DAC_OUT(DAC_OUT),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone)
	);
				

endmodule
