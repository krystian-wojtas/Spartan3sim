`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:18:08 08/18/2013
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

module TopTestBench (
    // color control
    output reg BTN_NEXT = 1'b0,
    output reg BTN_PREV = 1'b0
);

    initial begin

       // nastepny kolor
        #300;
        BTN_NEXT = 1'b1;
        #250;
        BTN_NEXT = 1'b0;

       // nastepny kolor
        #500;
        BTN_NEXT = 1'b1;
        #250;
        BTN_NEXT = 1'b0;

       // poprzedni kolor
        #300;
        BTN_PREV = 1'b1;
        #250;
        BTN_PREV = 1'b0;

    end

endmodule
