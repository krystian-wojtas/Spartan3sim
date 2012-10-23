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
    
   wire RST;
   Reset Reset_(.RST(RST));

	wire RXD;
	Rs232_tx_behav Rs232_tx_behav_(
		.tx(RXD)
	);
	
	wire [7:0] LED;
	wire TXD;
	Top Top_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.LED(LED),
		.RXD(RXD),
		.TXD(TXD)
	);

endmodule
