`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:34:11 04/11/2013
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
    // rotor control
    input 	 ROT_CENTER,
    input 	 ROT_A,
    input 	 ROT_B,
    // leds
    output [7:0] LED,
    output 	 DEBUG_A,
    output 	 DEBUG_B
    );


    wire center;
    Counter #(
`ifdef SIM
        .MAX(10)
`else
        .MAX(10_000_000)
`endif
        ) Debouncer_center (
        .CLKB(CLK50MHZ),
        .en(1'b1),
        .rst(RST),
        .sig(ROT_CENTER),
        .full(center)
    );

    wire left;
    wire right;
    Rotor Rotor_ (
        .clk(CLK50MHZ),
        .rst(RST),
        // inputs
        .rota(ROT_A),
        .rotb(ROT_B),
        // outputs direction
        .left(left),
        .right(right)
    );

    Controller Controller_(
        .clk(CLK50MHZ),
        .rst(RST),
        // tick inputs
        .center(center),
        .left(left),
        .right(right),
        // debug
        .leds(LED)
    );

    assign DEBUG_A = ROT_A;
    assign DEBUG_B = ROT_B;

endmodule