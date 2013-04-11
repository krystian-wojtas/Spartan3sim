`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:49 04/11/2013 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
	 input clk,
	 input rst,
	 // tick inputs
	 input center,
	 input left,
	 input right,
	 // debug leds
	 output reg [7:0] leds = 8'b10101010
    );
	 
	 always @(posedge clk)
	   if(rst)             leds <= 8'b0101_0101;
		else if(center) leds <= 8'b0011_1100;
		else if(left)      leds <= 8'b1111_0000;
		else if(right)    leds <= 8'b0000_1111;
	 
endmodule
