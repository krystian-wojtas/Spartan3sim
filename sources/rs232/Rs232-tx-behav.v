`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:51:49 10/23/2012 
// Design Name: 
// Module Name:    Rs232-tx-behav 
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
module Rs232_tx_behav(
	output reg tx = 1'b1
);
//TODO parameter bound
//TODO array of values to send
	 
initial begin
	#1000;
	tx = 1'b0; //start bit
	#8700;
	tx = 1'b1;
	#69_600; //data 0xff
	#8700; //stop bit
	tx = 1'b0; // start bit for next data
	#8700;
	tx = 1'b1; // next data also 0xff
end


endmodule
