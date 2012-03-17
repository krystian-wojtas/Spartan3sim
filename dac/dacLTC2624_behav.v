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
	input dac_in, //TODO in i outy zawsze patrze od strony hardwaru?
	output DAC_OUT
    );
	
	assign DAC_OUT = dac_in;
	
	reg [5:0] indacshiftregidx;
	reg [5:0] nindacshiftregidx;
	always @(negedge DAC_CS or negedge DAC_CLR)
		nindacshiftregidx = 6'd0;
	always @(SPI_SCK)
		indacshiftregidx <= nindacshiftregidx;
	
	reg [31:0] indacshiftreg; //TODO to samo pytanie co w dacu czy krotszy rejestr bez dontcarow?
	wire [11:0] data = indacshiftreg[4:15];
	wire [3:0] address = indacshiftreg[16:19];
	wire [3:0] command = indacshiftreg[20:23];		
	always @(posedge SPI_SCK) begin
		if(~DAC_CS) begin
			indacshiftreg[indacshiftregidx] = dac_in;
			nindacshiftregidx = indacshiftregidx + 1;
		end
	end
	
	
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
