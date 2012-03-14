`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:01 03/12/2012 
// Design Name: 
// Module Name:    spisck 
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
module spisck(
	input CLK50MHZ,
	input RST,
	output SPI_SCK
   );
	
	reg spisckreg = 1'b0;
	assign SPI_SCK = spisckreg;
	
	reg rstneg2 = 1'b1;
	reg rstneg1 = 1'b1;
	always @(posedge CLK50MHZ) begin
		rstneg2 <= rstneg1;
		rstneg1 <= RST;
	end
	wire rstnegalert = rstneg2 & ~rstneg1;
	
	reg [2:0] counter; //TODO counter zakres	
	always @(posedge CLK50MHZ)
		if(rstnegalert)
			counter <= 8'd0;
		else
			counter <= counter + 1;
	
	wire counterfull = & counter;
	always @(posedge CLK50MHZ)
		if(counterfull)
			spisckreg <= ~spisckreg;

endmodule
