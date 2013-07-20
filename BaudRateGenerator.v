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
	parameter FREQ = 50000000,	// 50MHz
	parameter BAUD = 115200
) (
	input CLK50MHZ,
	input RST,
	input en,
	output tick
);

`include "log2.v"

	localparam N = log2(BAUD);

	reg [N:0] acc = {N{1'b0}};
	wire [N:0] inc = ((BAUD<<(N-4))+(FREQ>>5))/(FREQ>>4); // = 302
	always @(posedge CLK50MHZ)
		if(RST) acc <= {N{1'b0}};
		else if(en) acc <= acc[N-1:0] + inc;

	assign tick = acc[N];

endmodule
