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
    input 	 CLK50MHZ,
    input 	 RST,
    // vga interface
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output 	 VGA_HSYNC,
    output 	 VGA_VSYNC,
    // color control
    input 	 BTN_NEXT,
    input 	 BTN_PREV,
    // debug
    output 	 DEBUG_A,
    output 	 DEBUG_B
);

    wire next;
    Counter #(
`ifdef SIM
        .MAX(10)
`else
        .MAX(10_000_000)
`endif
        ) Debouncer_next (
        .CLKB(CLK50MHZ),
        .en(1'b1),
        .rst(RST),
        .sig(BTN_NEXT),
        .full(next)
    );

    wire prev;
    Counter #(
`ifdef SIM
        .MAX(10)
`else
        .MAX(10_000_000)
`endif
        ) Debouncer_prev (
        .CLKB(CLK50MHZ),
        .en(1'b1),
        .rst(RST),
        .sig(BTN_PREV),
        .full(prev)
    );

    wire  hsync;
    wire  vsync;
    Sync Sync_(
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // vga interface
//        .VGA_HSYNC(VGA_HSYNC),
//        .VGA_VSYNC(VGA_VSYNC)
        .VGA_HSYNC(hsync),
        .VGA_VSYNC(vsync)
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
        .prev(prev)
    );

    assign DEBUG_A = vsync;
    assign DEBUG_B = hsync;

    assign VGA_VSYNC = vsync;
    assign VGA_HSYNC = hsync;


endmodule
