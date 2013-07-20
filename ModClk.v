`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:24:20 07/17/2012
// Design Name:
// Module Name:    ModClk
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
module ModClk #(
	parameter DIV=2,
	parameter DELAY=0
	) (
	input CLK50MHZ,
	input RST,
	output clk_hf, //half filled 50%
	output neg_trig,
	output pos_trig
    );

`include "log2.v"

	reg [log2(DIV-2):0] counter = 0;
	always @(posedge CLK50MHZ)
		if(RST)
			counter <= 0;
		else
		if(counter < DIV-1)
			counter <= counter + 1;
		else
			counter <= 0;


	assign clk_hf = (counter > (DIV-1)/2);
	assign neg_trig = (counter == (DIV-1+DELAY)%DIV);
	assign pos_trig= (counter == (DIV-1)/2+DELAY);

endmodule
