`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:22 03/13/2012 
// Design Name: 
// Module Name:    testbench 
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
module testbench(
	input CLK50MHZ,
	input RST,
	output reg [11:0] data,
	output reg [3:0] address,
	output reg [3:0] command,
	output reg dactrig,
	input dacdone
    );

	initial begin
		#10;
		dactrig = 1'b0;
		//simulating only first dac
		address = 4'b0001;
		//command to immadiately update value in dac register
		command = 4'b0011;
		
      @(posedge RST);
		
		//first data
		data = 12'h5f3;
		@(negedge CLK50MHZ);
		dactrig = 1'b1; //TODO zegar probkowania triga daca musi byc 50MHZ !
		
		@(negedge CLK50MHZ);
		@(posedge CLK50MHZ);
		dactrig = 1'b0;		
		@(negedge dacdone);
		
			
		//second data
		data = 12'h3f5;
		@(negedge CLK50MHZ);
		dactrig = 1'b1;
				
		@(negedge CLK50MHZ);
		@(posedge CLK50MHZ);
		dactrig = 1'b0;		
		@(negedge dacdone);
		
	end

endmodule
