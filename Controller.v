`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    22:43:21 09/01/2013
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
  input 	   CLK50MHZ,
  input 	   RST,
  input [7:0] 	   scancode,
  input 	   scan_ready,
  output reg [7:0] led = 8'b0011_1100
);

    always @(posedge CLK50MHZ)
        if(RST)
          led <= 8'b0111_1110;
        else if( scan_ready )
          led <= scancode;

endmodule
