`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:11:02 03/31/2012
// Design Name:
// Module Name:    TopTestBench
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

module TopTestBench(
    input RST,
    // rotor control
    output reg ROT_CENTER = 1'b0,
    output reg ROT_A = 1'b1,
    output reg ROT_B = 1'b1
);

    initial begin

       // rozpoczecie skretu w lewo
        #300;
        ROT_A = 1'b0;
        #250;
        ROT_B = 1'b0;

        // konczenie skretu w lewo
        #300;
        ROT_A = 1'b1;
        #50;
        ROT_B = 1'b1;

        // rozpoczenie skretu w prawo
        #500;
        ROT_B = 1'b0;
        #250;
        ROT_A = 1'b0;

        // konczenie skretu w prawo
        #300;
        ROT_B = 1'b1;
        #50;
        ROT_A = 1'b1;

    end

endmodule
