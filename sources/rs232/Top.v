`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:35:44 10/23/2012 
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
module Top(
	input CLK50MHZ,
	input RST,
	output [7:0] LED,
	//
	input RXD,
	output TXD
    );
	 	 
	 wire [7:0] aa = 8'h48;
	 serialfun serialfun_(
		.clk(CLK50MHZ),
		.RxD(RXD),
		.TxD(TXD),
		.GPin(aa),
		.GPout(LED)
	);
		

endmodule
