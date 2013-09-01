`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:22:34 08/18/2013
// Design Name:
// Module Name:    Controller
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

module Controller (
    input      CLK50MHZ,
    input      RST,
    // vga interface
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    // color control
    input 	 next,
    input 	 prev,
    input [10:0] x,
    input [10:0] y,
    input displaying
);

    assign VGA_R = (displaying) ? 4'hf : 4'h0;
    assign VGA_G = 4'h0;
    assign VGA_B = (displaying) ? 4'hf : 4'h0;

endmodule
