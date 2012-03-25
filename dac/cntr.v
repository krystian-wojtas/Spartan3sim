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
	// debug
	output [7:0] LED
    );
	 
	assign data = 12'h03f;
	assign address = 4'b1111;
	assign command = 4'b0011;
	
	reg [7:0] debug = 8'b00110001;
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			dactrig <= 1'b0;
			debug <= 8'b01010101;
		end else begin
			dactrig <= 1'b1;
			debug <= 8'b11001100;
		end
	end
	
	assign LED = debug;
	
endmodule
