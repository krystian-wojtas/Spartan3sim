`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:00 03/17/2012 
// Design Name: 
// Module Name:    clk_div 
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
module clock_divider(
	input CLK50MHZ,
	input RST,
	input clk_div_trig2x,
	output reg clk_div_trig,
	output reg clk_div
    );
			
	always @(posedge CLK50MHZ)
		if(~RST)
			clk_div <= 1'b0;
		else
			if(clk_div_trig2x)
				clk_div <= ~clk_div;
		
	always @*
		if(~RST) clk_div_trig <= 1'b1;
		else
			clk_div_trig = clk_div_trig2x && clk_div;
			
endmodule

