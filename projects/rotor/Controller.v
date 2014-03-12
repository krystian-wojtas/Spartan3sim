`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:39:49 04/11/2013
// Design Name:
// Module Name:    Controller
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
module Controller(
	 input clk,
	 input rst,
	 // tick inputs
	 input center,
	 input left,
	 input right,
	 //  leds
	 output reg [7:0] leds = 8'b0001_0000
    );

    always @(posedge clk)
        if(rst)           leds <= 8'b0010_0000;
        else if(center)   leds[0] <= ~leds[0];
        else if(left)     leds <= { leds[6:0], leds[7] };
        else if(right)    leds <= { leds[0], leds[7:1] };

endmodule
