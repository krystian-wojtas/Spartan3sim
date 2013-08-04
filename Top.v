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
	   input 	CLK50MHZ,
	   input 	RST,
	   //
	   input 	RXD,
	   output 	TXD,
	   //
	   output 	DEBUG_TX,
	   output 	DEBUG_RX
	   );

   serialfun serialfun_(
			.clk(CLK50MHZ),
			.RST(RST),
			.RxD(RXD),
			.TxD(TXD)
			);

   assign DEBUG_TX = TXD;
   assign DEBUG_RX = RXD;

endmodule
