`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:22 04/13/2012 
// Design Name: 
// Module Name:    debouncer_sw 
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
module switch_oneshot(
	input RST,
	input CLK50MHZ,
	input [3:0] sw_in,
	output reg [3:0] sw_out = 4'h0
    );

	reg [3:0] sw_prev = 4'h0;
	always @(posedge CLK50MHZ)
		if(RST) begin
			sw_out <= 4'h0;
			sw_prev <= 4'h0;
		end else
			if(sw_in != sw_prev && ~sw_out) begin
				sw_out <= sw_in;
				sw_prev <= sw_in;
			end else
				sw_out <= 4'h0;

endmodule
