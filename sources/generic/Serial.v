`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:39 10/26/2012 
// Design Name: 
// Module Name:    Serial 
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
module Serial  #(
		parameter WIDTH=32
	) (
		input RST,
		input CLKB,
		// serial module interface
		input rx,
		output tx,
		input [WIDTH-1:0] data_in,
		output [WIDTH-1:0] data_out,
		input trig,
		output reg ready = 1'b1,
		input tick
	);
	
	 
	wire sent_all_bits;	
	Counter #(
		.MAX(WIDTH-1)
	) Counter_bits (
		.CLKB(CLKB),
		// counter
		.en(1'b1), // if high counter is enabled and is counting
		.rst(ready), // set counter register to zero
		.sig(tick), // signal which is counted; counts ticks
		.full(sent_all_bits) // one pulse if counter is full
	);

	Shiftreg #(
		.WIDTH(WIDTH)
	) Shiftreg_ (
		.CLKB(CLKB),
		// shiftreg
		.en(~ready),
		.set(trig), // setting shiftreg value to data_in if trig occurs
		.tick(tick),
		.rx(rx),
		.tx(tx),
		.data_in(data_in),
		.data_out(data_out)
	);
	
	
	always @(posedge CLKB)
		if(RST)
			ready <= 1'b1;
		else if(trig)
			ready <= 1'b0;
		else if(sent_all_bits && tick)
			ready <= 1'b1;

endmodule
