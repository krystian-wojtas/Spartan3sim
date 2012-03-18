`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:49 03/13/2012 
// Design Name: 
// Module Name:    dac 
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
module dacspi(
	input RST,
	input CLK50MHZ,
	// hardware dac interface
	output reg DAC_CS,
	output reg DAC_CLR,
	output SPI_MOSI,
	input	DAC_OUT,
	// verilog module interface
	input spi_sck_trig,
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrig,
	output dacdone
	);	
	
	
	wire dacdone_;
	wire [31:0] dacdatatosend = {4'b1000, data, address, command, 8'd1};
	wire [31:0] dacdatareceived;
	spi spi_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.spi_sck_trig(spi_sck_trig),
		.SPI_MISO(SPI_MISO),
		.SPI_MOSI(SPI_MOSI),
		.data_in(dacdatatosend),
		.data_out(dacdatareceived),
		.spi_trig(dactrig),
		.spi_done(dacdone_)
	);
	assign dacdone = dacdone_;
	
		
	reg [1:0] state;
	localparam [1:0] 	TRIG_WAITING = 2'd0,
							TRIGGING = 2'd1,
							SENDING = 2'd2,	
							DONE = 2'd3;
	
	
	always @(posedge CLK50MHZ) begin
		if(~RST) state = TRIG_WAITING;
		else begin
			if(spi_sck_trig)
				case(state)
					TRIG_WAITING:
						if(~dactrig)
							state = TRIG_WAITING;
						else
							state = TRIGGING;
					TRIGGING:
						state = SENDING;
					SENDING:
						if(~dacdone_)
							state = SENDING;
						else
							state = DONE;
					DONE:
						state = TRIG_WAITING;
				endcase
		end		
	end
	
	
	always @*
		if(state == SENDING || state == TRIGGING)
			DAC_CS = 1'b0;
		else
			DAC_CS = 1'b1;
	
	always @*
		if(~RST) // czy negacja? moze odwrotnie wartosci?
			DAC_CLR = 1'b0;
		else
			DAC_CLR = 1'b1;
	
endmodule
