`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:02 03/12/2012 
// Design Name: 
// Module Name:    clk 
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
module clock #(parameter DELAY = 20) ( //DELAY 20ns - clock 50MHZ
	output reg clk
	);

   initial clk = 0;
   always #DELAY clk <= ~clk; //TODO =?

endmodule
