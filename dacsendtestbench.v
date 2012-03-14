`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:37:57 03/13/2012 
// Design Name: 
// Module Name:    dacsendtestbench 
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
module dacsendtestbench(
	input RST,
	input SPI_SCK,
	output reg [11:0] data,
	output reg [3:0] address,
	output reg [3:0] command,
	output reg dactrigsync,
	input dactrigsyncack,
	input dacdonesync
	);
	
	initial begin
		data = 12'd0;
		address = 4'd0;
		command = 4'd0;
		dactrigsync = 1'd0;
		
		#10;
		dactrigsync = 1'b0;
		//simulating only first dac A
		address = 4'b0000;
		//command to immadiately update value in dac register
		command = 4'b0011;
		
      @(posedge RST);
		
		//first data
		data = 12'h5f3;
		@(negedge SPI_SCK);
		dactrigsync = 1'b1;
		
		@(negedge SPI_SCK);
		@(posedge SPI_SCK);
		dactrigsync = 1'b0;		
		@(negedge dacdonesync);
		
			
		//second data
		data = 12'h3f5;
		@(negedge SPI_SCK);
		dactrigsync = 1'b1;
				
		@(negedge SPI_SCK);
		@(posedge SPI_SCK);
		dactrigsync = 1'b0;		
		@(negedge dacdonesync);		
	end
	
endmodule
