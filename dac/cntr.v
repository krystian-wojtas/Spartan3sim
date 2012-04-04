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
	output [11:0] data,
	output [3:0] address,
	output [3:0] command,
	output reg dactrig,
	input dacdone,
	// control
	input less,
	input more,
	// debug
	output [7:0] LED
    );
	 
	assign address = 4'b1111;
	assign command = 4'b1100;
	reg [7:0] datareg = 8'h55;
	assign LED = datareg;
//	assign data = {datareg, 4'b1}; //TODO 4'b1 ?
	assign data = 12'hffe;
//	assign data = 12'h3ff;
	
	localparam STEP = 32;
	localparam MAXV = {8{1'b1}};
	
	always @(posedge CLK50MHZ)
		if(RST) datareg <= 8'h0f;
		else
			if(less)
				if(datareg-STEP > 0)
					datareg <= datareg-STEP;
				else
					datareg <= 0;
			else if(more)
				if(datareg+STEP<MAXV)
					datareg <= datareg+STEP;
				else
					datareg <= MAXV;
				
	always @(posedge CLK50MHZ)
		if(RST) dactrig <= 1'b0;
		else
			if(less | more)
				dactrig <= 1'b1;
			else
				dactrig <= 1'b0;
	
endmodule
