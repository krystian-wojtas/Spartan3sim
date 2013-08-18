`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    22:25:01 03/24/2012
// Design Name:
// Module Name:    TopTest
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

module TopTest();

    wire CLK50MHZ;
    Clock Clock_(.clk(CLK50MHZ));

    wire RST;
    Reset Reset_(.RST(RST));

    wire ROT_CENTER;
    wire ROT_A;
    wire ROT_B;
    wire [7:0] LED;
    Top Top_(
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // rotor control
        .ROT_CENTER(ROT_CENTER),
        .ROT_A(ROT_A),
        .ROT_B(ROT_B),
        // debug leds
        .LED(LED)
    );

    TopTestBench TopTestBench_(
        .RST(RST),
        // rotor control
        .ROT_CENTER(ROT_CENTER),
        .ROT_A(ROT_A),
        .ROT_B(ROT_B)
    );

endmodule
