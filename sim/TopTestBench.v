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
    // keyboard
    input RST,
    output reg PS2_CLK1,
    output reg PS2_DATA1
);

    initial begin
       // idle means higth
       PS2_CLK1  = 1'b1;
       PS2_DATA1 = 1'b1;

       // bit 0
       @(negedge RST);
       #3000;
       PS2_DATA1 = 1'b0;
       #45000;
       PS2_CLK1  = 1'b0;

       #40000;
       PS2_DATA1 = 1'b1;
       #5000;
       PS2_CLK1 = 1'b1;

       // send 0xf

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       // send 0x0

       #40000;
       PS2_CLK1 = 1'b0;

       #35000;
       PS2_DATA1 = 1'b0;

       #5000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #35000;
       PS2_DATA1 = 1'b1;

       #5000;
       PS2_CLK1 = 1'b1;

       #40000;
       PS2_CLK1 = 1'b0;

       #40000;
       PS2_CLK1 = 1'b1;

    end

endmodule
