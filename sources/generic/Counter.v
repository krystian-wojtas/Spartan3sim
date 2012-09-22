`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:51:49 07/22/2012 
// Design Name: 
// Module Name:    Counter 
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
module Counter #(
	parameter WIDTH=32
	) (
	input CLK50MHZ,
	input RST,
	// counter
	input cnt_en,
	input [WIDTH-1:0] cnt_max, //TODO log2
	output cnt_trig
   );
	
	reg [WIDTH-1:0] counter_reg = 0;
	always @(posedge CLK50MHZ)
		if(RST)
			counter_reg <= 0;
		else if(cnt_en)
			if(counter_reg < cnt_max)
				counter_reg <= counter_reg + 1;
			else
				counter_reg <= 0;
	
	assign cnt_trig = (counter_reg == cnt_max);

endmodule
