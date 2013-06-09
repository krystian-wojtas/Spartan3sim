`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:42:40 04/11/2013 
// Design Name: 
// Module Name:    Rotor 
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
module Rotor(
		input clk,
		input rst,
		// inputs
		input rota,
		input rotb,
		// one pulse output direction signals
		output left,
		output right
	);

	reg rotary_q1 = 1'b0;
	always @(clk)
		if(rota ^~ rotb)
			rotary_q1 <= rotb;
	
	reg rotary_q2 = 1'b0;
	always @(clk)
		if(rota ^ rotb)
			rotary_q2 <= rotb;
	
	reg delay_rotary_q1 = 1'b0;
	reg rotary_event = 1'b0;
	reg rotary_left = 1'b0;
	always @(clk) begin
		delay_rotary_q1 <= rotary_q1;
		if(delay_rotary_q1 == 1'b0 && rotary_q1 == 1'b1) begin
			rotary_event <= 1'b1;
			rotary_left <= rotary_q2;
		end else
			rotary_event <= 1'b0;
	end
	
	assign left = rotary_event;
//	assign left = rotary_event & rotary_left;
	assign right = rotary_event & ~rotary_left;
endmodule
