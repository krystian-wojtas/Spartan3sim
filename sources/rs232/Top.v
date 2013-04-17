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
	input BTN,
	output [7:0] LED,
	//
//	input RXD,
	output TXD
    );
	 
	wire RXD= 1'b0; // TODO del
	 
	 	 
	 serialfun serialfun_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.BTN(btn_ee),
		.RxD(RXD),
		.TxD(TXD)
	);
		

endmodule
