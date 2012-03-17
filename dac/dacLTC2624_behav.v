`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:08 03/13/2012 
// Design Name: 
// Module Name:    dacsim 
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
module dacLTC2624behav (
	input SPI_SCK,
	input DAC_CS,
	input DAC_CLR,
	input SPI_MOSI,
	output DAC_OUT
    );
	
	assign DAC_OUT = SPI_MOSI;
	
	reg [31:0] indacshiftreg;	
	wire [11:0] data = indacshiftreg[4:15];
	wire [3:0] address = indacshiftreg[16:19];
	wire [3:0] command = indacshiftreg[20:23];
	reg [4:0] indacshiftregidx;
	always @(posedge SPI_SCK) begin
		if(~DAC_CLR || DAC_CS) begin
			indacshiftreg = 32'd0;
			indacshiftregidx = 5'd0;
		end else begin
			indacshiftreg[indacshiftregidx] = SPI_MOSI;
			indacshiftregidx = indacshiftregidx + 1;
		end
	end
	
	//TODO sprawdzac czy miedzy wlaczeniem a wylaczeniem daca wyslano 32bity - sprawdzac counter
	wire data_received = & indacshiftregidx;
	always @(posedge data_received)
		$display("ustawiono liczbe %d na dacu nr %d z komenda %d", data, address, command);	 
	always @(negedge DAC_CLR)
		$display("zresetowana dac");	
	always @(negedge DAC_CS)
		$display("wlaczono przesyl dac");	
	always @(posedge DAC_CS)
		$display("wylaczono przesyl dac");

endmodule
