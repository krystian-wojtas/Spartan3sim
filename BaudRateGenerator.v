`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:11:54 04/17/2013
// Design Name:
// Module Name:    BaudRateGenerator
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
module BaudRateGenerator
#(
	parameter INC = 100,
        parameter N = 10
) (
	input CLK50MHZ,
	input RST,
	input en,
	output tick
);

	reg [N:0] acc = {N{1'b0}};
	always @(posedge CLK50MHZ)
		if(RST) acc <= {N{1'b0}};
		else if(en) acc <= acc[N-1:0] + INC;

	assign tick = acc[N];

endmodule
