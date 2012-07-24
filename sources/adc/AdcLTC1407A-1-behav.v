`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:36 07/24/2012 
// Design Name: 
// Module Name:    AdcLTC1407A-1-behav 
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
module AdcLTC1407A_1_behav
#(
	parameter LOGLEVEL=5
) (
	input SPI_SCK,
	input AD_CONV,
	output ADC_OUT
);
	
	reg value = 1'b0;
	reg value_next = 1'b0;
	always @(posedge SPI_SCK)
		value <= value_next;
	
	always @*
		value_next = ~value;
	
	assign ADC_OUT = value;

endmodule
