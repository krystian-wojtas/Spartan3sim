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
module dacLTC2624behav #(parameter LOGLEVEL=1) (
	input SPI_SCK,
	input DAC_CS,
	input DAC_CLR,
	input SPI_MOSI,
	output DAC_OUT
    );
	
	assign DAC_OUT = DAC_CS ? 1'b0 : indacshiftreg[31];
	
	reg [31:0] indacshiftreg;	
	wire [11:0] data = indacshiftreg[15:4];
	wire [3:0] address = indacshiftreg[19:16];
	wire [3:0] command = indacshiftreg[23:20];
	reg [5:0] indacshiftregidx;
	always @(posedge SPI_SCK or negedge DAC_CLR) begin
		if(~DAC_CLR) begin
			indacshiftreg <= 32'd0;
			indacshiftregidx <= {5{1'b1}};
		end else
			if(DAC_CS)
				indacshiftregidx <= {5{1'b1}};
			else begin
				indacshiftreg <= { indacshiftreg[30:0], SPI_MOSI };
				indacshiftregidx <= indacshiftregidx - 1;
		end
	end
	
	wire received = indacshiftregidx[5];
	always @(posedge received)
		//if(LOGLEVEL >= 1)
			$display("%t ustawiono liczbe %d (0x%h) na dacu nr %d z komenda %d", $time, data, data, address, command);	 
	always @(negedge DAC_CLR)
		if(LOGLEVEL >= 1)
			$display("%t resetowanie dac", $time);
	always @(posedge DAC_CLR)
		if(LOGLEVEL >= 1)
			$display("%t zresetowano dac", $time);
	always @(negedge DAC_CS)
		//if(LOGLEVEL >= 2)
			$display("%t wlaczono przesyl dac", $time);	
	always @(posedge DAC_CS)
		//if(LOGLEVEL >= 2)
			$display("%t wylaczono przesyl dac", $time);

endmodule
