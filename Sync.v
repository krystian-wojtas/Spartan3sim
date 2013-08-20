`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:22:47 08/18/2013
// Design Name:
// Module Name:    Sync
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

module Sync (
	input  CLK50MHZ,
	input  RST,
	// vga interface
	output VGA_HSYNC,
	output VGA_VSYNC,
	// tick for next pixel
	output next_px
);

`ifdef SIM
	localparam [10:0] H_TS  = 16;
	localparam [ 7:0] H_TPW = 4;
	localparam [ 6:0] H_TBP = 2;
	localparam [ 9:0] V_TS  = 20;
	localparam [ 1:0] V_TPW = 2;
	localparam [ 3:0] V_TFP = 4;
	localparam [ 4:0] V_TBP = 3;
`else
	localparam [10:0] H_TS  = 1600;
	localparam [ 7:0] H_TPW = 192;
	localparam [ 6:0] H_TBP = 96;
	localparam [ 9:0] V_TS  = 521;
	localparam [ 1:0] V_TPW = 2;
	localparam [ 3:0] V_TFP = 10;
	localparam [ 4:0] V_TBP = 29;
`endif

	wire [10:0] x;
	wire 	    h;
	Counter #(
		.MAX(H_TS)
	) Counter_h (
		.CLKB(CLK50MHZ),
		// counter
		.en(1'b1),
		.rst(RST),
		.sig(1'b1), // count all CLK50MHZ ticks
		.cnt(x),
		.full(h)
	);

	wire [9:0] y;
   	Counter #(
		.MAX(V_TS)
	) Counter_v (
		.CLKB(CLK50MHZ),
		// counter
		.en(1'b1),
		.rst(RST),
		.sig(h), // count h sync
		.cnt(y)
	);

	wire 	   displaying = (y > V_TBP && y < V_TS - V_TFP - V_TPW);
	assign VGA_HSYNC = ~displaying || (x < H_TS - H_TPW); // <= ?
	assign VGA_VSYNC = (y < V_TS - V_TPW);

endmodule
