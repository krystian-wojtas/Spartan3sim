`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:02 03/31/2012 
// Design Name: 
// Module Name:    TopTestBench 
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
module TopTestBench(
	input CLK50MHZ,
	input RST,
	output reg BTN_WEST,
	output reg BTN_EAST,
	output reg [3:0] SW
    );
	
	initial begin
		SW = 4'h0;
		BTN_WEST = 1'b0;
		BTN_EAST = 1'b0;
		
		@(negedge RST);
		#300;
		
		BTN_EAST = 1'b1;
		#250;
		BTN_EAST = 1'b0;
		
		
		#1500;
		BTN_EAST = 1'b1;
		#250;
		BTN_EAST = 1'b0;
		
		
		#1000;
		SW = 4'h4;
		#1000;
		SW = 4'h0;
		
		#1500;
		$finish;
	end

endmodule
