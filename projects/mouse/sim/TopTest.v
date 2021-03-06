`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:42:57 10/27/2013
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
module TopTest ();

        wire CLK50MHZ;
        Clock Clock_(.clk(CLK50MHZ));

        wire RST;
        Reset Reset_( .RST(RST) );

        wire PS2C;
        wire PS2D;
        MouseTestBench #(
           .INFO1(1),
           .INFO2(1),
           .INFO3(1),
           .INFO4(1)
        ) MouseTestBench_ (
            .ps2c(PS2C),
            .ps2d(PS2D)
        );

        wire [7:0] LED;
        Top Top_( .clk(CLK50MHZ), .reset(RST), .ps2c(PS2C), .ps2d(PS2D), .led(LED) );

endmodule
