`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:11:15 04/17/2013 
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
		input RST,
		output reg BTN = 1'b0
    );


	initial begin		
		@(negedge RST);		
		
		#300;
		BTN = 1'b1;
		#110_250;
		BTN = 1'b0;
	end

endmodule
