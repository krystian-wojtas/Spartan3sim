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
	output reg [3:0] sw_out
    );

	always @(posedge CLK50MHZ)
		if(RST)
			sw_out <= 4'h0;
		else
			if(sw_in)
				if(~sw_out)
					sw_out <= sw_in;
				else
					sw_out <= 4'h0;

endmodule
