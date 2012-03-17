`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:01 03/12/2012 
// Design Name: 
// Module Name:    spisck 
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
module spisck(
	input CLK50MHZ,
	input RST,
	output SPI_SCK
   );
	
	clock_divider clock_divider_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_div(SPI_SCK)
	);

endmodule
