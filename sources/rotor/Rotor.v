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

   wire left_;
	Counter #(
	  .MAX(10) // sim
//	  .MAX(10_000_000) // synth
	) Debouncer_rota (
	  .CLKB(clk),
	  .en(1'b1),
	  .rst(rst),
	  .sig(rota),
	  .full(left_)
	);
	
	wire ritght_;
	Counter #(
//	  .MAX(10) // sim
	  .MAX(10_000_000) // synth
	) Debouncer_rotb (
	  .CLKB(clk),
	  .en(1'b1),
	  .rst(rst),
	  .sig(rotb),
	  .full(right_)
	);

endmodule
