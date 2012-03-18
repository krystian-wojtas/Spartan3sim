`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:36 03/17/2012 
// Design Name: 
// Module Name:    spi 
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
module spi #(parameter WIDTH=31) (
	input RST,
	input CLK50MHZ,
	// spi interface
	input spi_sck_trig,
	input SPI_MISO,
	output SPI_MOSI,
	input [WIDTH:0] data_in,
	output reg [WIDTH:0] data_out,
	input spi_trig,
	output reg spi_done
    );
			
	reg [31:0] outdacshiftreg;
	assign SPI_MOSI = outdacshiftreg[WIDTH];
//	reg [4:0] outdacidx;
//	wire sended = & outdacidx;
	reg [5:0] outdacidx;
	wire sended = outdacidx[5]; //the content of outdacshiftreg is sended if counter outdacidx is 6'b1_xxxxx
			
			
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
						if(~spi_trig)
							state = TRIG_WAITING;
						else
							state = TRIGGING;
					TRIGGING:
						state = SENDING;
					SENDING:
						if(~sended)
							state = SENDING;
						else
							state = DONE;
					DONE:
						state = TRIG_WAITING;
				endcase
		end		
	end
			
	
	always @(posedge CLK50MHZ)
		if(~RST) begin
			outdacshiftreg <= 32'd0;
			outdacidx <= 6'd0;
		end else if(spi_sck_trig)
			case(state)
				TRIGGING: begin
					outdacshiftreg <= data_in;
					outdacidx <= 6'd0;
				end
				SENDING: begin
					outdacshiftreg <= outdacshiftreg << 1;
					outdacidx <= outdacidx + 1;
				end
			endcase
			
	always @*
		if(state == DONE)
			spi_done = 1'b1;
		else
			spi_done = 1'b0;

endmodule
