`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:53:34 03/24/2012 
// Design Name: 
// Module Name:    cntr 
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

//the most basic implementation
module cntr(
	input RST,
	input CLK50MHZ,
	// verilog module interface
	//input spi_sck_trig, //TODO ?
//	output reg [11:0] data,
	output [11:0] data,
	output [3:0] address,
	output [3:0] command,
//	output reg dactrig,
	output dactrig,
	input dacdone,
	// control
	input less,
	input more
    );
	 
	assign address = 4'b1111;
	assign command = 4'b0011;
	assign data = 12'h03f;
//	assign data = 12'h3ff;
	
	assign dactrig = ~RST;
	
//	localparam STEP = 400;
//	localparam MAXV = {12{1'b1}};
//	
//	always @(posedge CLK50MHZ)
//		if(RST) data <= 12'h03f;
//		else
//			if(less)
//				if(data-STEP > 0)
//					data <= data-STEP;
//				else
//					data <= 0;
//			else if(more)
//				if(data+STEP<MAXV)
//					data <= data+STEP;
//				else
//					data <= MAXV;
	
endmodule
