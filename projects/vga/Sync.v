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

module Sync
#(
   parameter H_S  = 2*800,
   parameter H_FP = 2*16,
   parameter H_PW = 2*96,
   parameter H_BP = 2*48,
   parameter V_S  = 521,
   parameter V_PW = 2,
   parameter V_FP = 10,
   parameter V_BP = 29
) (
   input         CLK50MHZ,
   input         RST,
   // vga interface
   output        VGA_HSYNC,
   output        VGA_VSYNC,
   // tick for next pixel
   output [10:0] x,
   output [10:0] y,
   output        displaying
);

        wire [10:0] i;
        wire        h;
        Counter #(
                .MAX(H_S)
        ) Counter_h (
                .CLKB(CLK50MHZ),
                // counter
                .en(1'b1),
                .rst(RST),
                .sig(1'b1), // count all CLK50MHZ ticks
                .cnt(i),
                .full(h)
        );

        wire [9:0] j;
        Counter #(
                .MAX(V_S)
        ) Counter_v (
                .CLKB(CLK50MHZ),
                // counter
                .en(1'b1),
                .rst(RST),
                .sig(h), // count h sync
                .cnt(j)
        );

        assign displaying = (
            i >= H_PW + H_BP &&
            i <  H_S  - H_FP &&
            j >= V_PW + V_BP &&
            j <= V_S  - V_FP
        );

        assign VGA_HSYNC = (i >  H_PW);
        assign VGA_VSYNC = (j >= V_PW);

        assign x = i - H_PW - H_BP;
        assign y = j - V_PW - V_BP;

endmodule
