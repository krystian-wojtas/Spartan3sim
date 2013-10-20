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
    input  CLK50MHZ,
    input  RST,
    // keyboard
    inout  PS2_CLK1,
    inout  PS2_DATA1,
    output [7:0] LED,
    // debug
    output DEBUG_A,
    output DEBUG_B
);

   wire    ps2_clk_z = 1'b1;
   wire    ps2_data_z = 1'b1;

   wire    ps2_clk_out = 1'b0;
   wire    ps2_data_out = 1'b0;

   assign PS2_CLK1 = (ps2_clk_z) ? 1'bz : ps2_clk_out;
   assign PS2_DATA1 = (ps2_data_z) ? 1'bz : ps2_data_out;

    wire [7:0] scancode;
    wire scan_ready;
    PS2_Cmd ps2_cmd0 (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .ps2_clk(PS2_CLK1),
        .ps2_data(PS2_DATA1),
        .ps2_clk_out(ps2_clk_out),
        .ps2_data_out(ps2_data_out),
        .ps2_clk_z(ps2_clk_z),
        .ps2_data_z(ps2_data_z),
        .scancode(scancode),
        .scan_ready(scan_ready)
    );

    Controller controller_ (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .scancode(scancode),
        .scan_ready(scan_ready),
        .led(LED)
    );

    assign DEBUG_A = PS2_CLK1;
    assign DEBUG_B = PS2_DATA1;

endmodule
