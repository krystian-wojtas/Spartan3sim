`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:40 04/12/2013 
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
		output reg ROT_CENTER = 1'b0,
		output reg ROT_A = 1'b0,
		output reg ROT_B = 1'b0
    );

	initial begin		
		@(negedge RST);
		#300;
		
		// jiter
		ROT_CENTER = 1'b1;
		#10;
		ROT_CENTER = 1'b0;
		#12
		ROT_CENTER = 1'b1;
		#7;
		ROT_CENTER = 1'b0;
		#9
		ROT_CENTER = 1'b1;
		#14;
		ROT_CENTER = 1'b0;
		#3
		ROT_CENTER = 1'b1;
		#7;
		ROT_CENTER = 1'b0;
		#15
		ROT_CENTER = 1'b1;
		#11;
		ROT_CENTER = 1'b0;
		#6
		ROT_CENTER = 1'b1;
		
		#200;
		ROT_CENTER = 1'b0;
		
	end

endmodule
