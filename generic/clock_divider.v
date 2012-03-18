`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:00 03/17/2012 
// Design Name: 
// Module Name:    clk_div 
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
module clock_divider(
	input CLK50MHZ,
	input RST,
	input clk_div_trig2x,
	output reg clk_div_trig,
	output reg clk_div
    );
	
	reg second_trig;
	always @*
		if(~RST) second_trig = 1'b0; //jesli reset ustawi 1, bedzie pikowac na poczatku opadajacego zbocza
		else
			if(clk_div_trig2x)
				second_trig = second_trig + 1;
			
	always @(posedge CLK50MHZ) begin
		clk_div_trig <= 1'b0;
		if(~RST)
			clk_div <= 1'b0;
		else
			if(clk_div_trig2x) begin
				clk_div <= ~clk_div;
				if(second_trig)
					clk_div_trig <= 1'b1;
			end
	end
	
endmodule
