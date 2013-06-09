`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:15 04/12/2013 
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
module TopTest();
	 
	wire CLK50MHZ;
	Clock Clock_(.clk(CLK50MHZ));
    
	wire RST;
	Reset Reset_(.RST(RST));
	
	
	wire ROT_CENTER;
	wire ROT_A;
	wire ROT_B;
	wire TXD;
	wire LED;
	Top Top_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// signals
		.ROT_CENTER(ROT_CENTER),
		.ROT_A(ROT_A),
		.ROT_B(ROT_B),
		// rs232
		.TXD(TXD),
	// led debug
		.LED(LED)
	);
	
	
	TopTestBench TopTestBench_(
		.RST(RST),
		// signals
		.ROT_CENTER(ROT_CENTER),
		.ROT_A(ROT_A),
		.ROT_B(ROT_B)	
	);

endmodule
