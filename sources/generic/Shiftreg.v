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
	input CLK50MHZ,
	// shiftreg
	input en,
	input tick,
	input rx,
	output reg tx = 1'b1,
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out
);

	
	//constant function calculetes value at collaboration time
	//source http://www.beyond-circuits.com/wordpress/2008/11/constant-functions/
	function integer log2;
	  input integer value;
	  begin
		 value = value-1;
		 for (log2=0; value>0; log2=log2+1)
			value = value>>1;
	  end
	endfunction
	
			
	reg [WIDTH-1:0] shiftreg = {WIDTH{1'b0}};			
	always @(posedge CLK50MHZ) begin
		if(~en)
			shiftreg <= data_in;
		else if(tick)
			shiftreg <= { shiftreg[WIDTH-2:0], rx };
	end
			
	
//	assign tx = shiftreg[WIDTH-1];
	always @*
		tx = shiftreg[WIDTH-1];
	assign data_out = shiftreg;		

	

endmodule
