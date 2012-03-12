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
	 output reg SPI_MOSI,
	 output reg SPI_SCK,
	 output reg DAC_CS,
	 output reg DAC_CLR,
	 input DAC_OUT
    );

always @(negedge RST) begin
	DAC_CLR = 1'b1;
end

endmodule
