`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:02 03/12/2012 
// Design Name: 
// Module Name:    Clock 
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
module Clock #(parameter DELAY = 10) ( //DELAY 10ns - clock 50MHZ
	output reg clk
	);

   initial clk = 0;
   always #DELAY clk <= ~clk; //TODO =?

endmodule
