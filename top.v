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

	spisck spisck_(.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.SPI_SCK(SPI_SCK)
	);
	
	dac dac_(
		.RST(RST),
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.dac_in(SPI_MOSI),
		.DAC_OUT(DAC_OUT)
	);
				

endmodule