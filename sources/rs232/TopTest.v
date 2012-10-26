`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:08 10/23/2012 
// Design Name: 
// Module Name:    TopTest 
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
module TopTest(
    );
	 
	wire CLK50MHZ;
   Clock Clock_(.clk(CLK50MHZ));

	wire RXD;
	wire TXD;
	Rs232_behav Rs232_behav_(
		.rx(TXD),
		.tx(RXD)
	);
	
	wire [7:0] LED;
	Top Top_(
		.CLK50MHZ(CLK50MHZ),
		.LED(LED),
		.RXD(RXD),
		.TXD(TXD)
	);

endmodule
