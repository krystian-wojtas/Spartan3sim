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
	output reg SPI_SCK
   );
	
	reg [7:0] counter; //TODO counter
	
	always @(posedge CLK50MHZ) begin
		if(~RST)
			counter = 8'd0;
		else
			counter = counter + 1;
	end

endmodule
