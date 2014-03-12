`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:47:08 10/26/2012
// Design Name:
// Module Name:    Shiftreg
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
module Shiftreg #(
	parameter WIDTH=8
) (
	input CLKB,
	// shiftreg
	input en,
	input set, // setting shiftreg value to data_in if spi_trig occurs
	input tick, // register shifting is syncronized with tick signal
	input rx,
	output reg tx = 1'b1,
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out
);

	reg [WIDTH-1:0] shiftreg = {WIDTH{1'b0}};
	always @(posedge CLKB) begin
		if(set)
			shiftreg <= data_in;
		else if(en & tick)
			shiftreg <= { shiftreg[WIDTH-2:0], rx };
	end


//	assign tx = shiftreg[WIDTH-1];
	always @*
		tx = shiftreg[WIDTH-1];
	assign data_out = shiftreg;



endmodule
