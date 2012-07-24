`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:18:18 07/24/2012 
// Design Name: 
// Module Name:    AmpLTC6912-1-behav 
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
module AmpLTC6912_1_behav
#(
	parameter LOGLEVEL=5
) (
	input SPI_SCK,
	input SPI_MOSI,
	input AMP_CS,
	input AMP_SHDN,
	output AMP_DOUT
	
);

	assign AMP_DOUT = 1'b0;

endmodule
