`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:02 03/31/2012 
// Design Name: 
// Module Name:    toptestbench 
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
module toptestbench(
	input CLK50MHZ,
	input RST,
	output reg BTN_WEST,
	output reg BTN_EAST
    );
	
	initial begin
		BTN_WEST = 1'b0;
		BTN_EAST = 1'b0;
		
		@(negedge RST);
		#300;
		@(negedge CLK50MHZ);
		BTN_WEST = 1'b1;
		#1000;
		BTN_WEST = 1'b0;
		
		#40000;
		@(negedge CLK50MHZ);
		BTN_WEST = 1'b1;
		#1000;
		BTN_WEST = 1'b0;

		$finish;
	end

endmodule
