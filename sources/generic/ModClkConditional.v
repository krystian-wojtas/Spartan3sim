`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:41:29 07/21/2012 
// Design Name: 
// Module Name:    ModClkConditional 
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
module ModClkConditional #(
	parameter DIV=1,
	parameter DELAY=0,
	parameter POSE=1 //trigging on posedge or negedge
	) (
	input CLK50MHZ,
	input RST,
	output mod_clk_hf, //half filled 50%
	output mod_clk_trig
    );

	generate
		if(DIV == 1) begin
			assign mod_clk_hf = CLK50MHZ;
			assign mod_clk_trig = 1'b1;
		end else begin
			ModClk #(
				.DIV(DIV),
				.DELAY(DELAY),
				.POSE(POSE)
			) ModClk_ (
				.CLK50MHZ(CLK50MHZ),
				.RST(RST),
				.mod_clk_hf(mod_clk_hf),
				.mod_clk_trig(mod_clk_trig)
			);	
		end 
	endgenerate

endmodule
