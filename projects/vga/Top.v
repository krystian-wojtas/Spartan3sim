`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:17:33 08/18/2013
// Design Name:
// Module Name:    Top
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

module Top (
    input        CLK50MHZ,
    input        RST,
    // vga interface
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output       VGA_HSYNC,
    output       VGA_VSYNC,
    // color control
    input        BTN_NEXT,
    input        BTN_PREV,
);

    wire next;
    Debouncer debouncer_next (
        .clk(CLK50MHZ),
        .rst(RST),
        .sig(BTN_NEXT),
        .full(next)
    );

    wire prev;
    Debouncer debouncer_prev (
        .clk(CLK50MHZ),
        .rst(RST),
        .sig(BTN_PREV),
        .full(prev)
    );

    wire [10:0] x;
    wire [10:0] y;
    wire displaying;
    Sync Sync_(
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // vga interface
        .VGA_HSYNC(VGA_HSYNC),
        .VGA_VSYNC(VGA_VSYNC),
        .x(x),
        .y(y),
        .displaying(displaying)
    );

    Controller Controller_(
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // vga interface
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        // color control
        .next(next),
        .prev(prev),
        .x(x),
        .y(y),
        .displaying(displaying)
    );

endmodule
