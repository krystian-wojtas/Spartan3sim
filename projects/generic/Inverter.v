`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:18 11/02/2012 
// Design Name: 
// Module Name:    Inverter 
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
module Inverter #(
	parameter INIT = 1'b0
 ) (
	input CLK,
	input tick,
	output reg inv = INIT
);

	always @(posedge CLK)
		if(tick)
			inv <= ~inv;

endmodule
