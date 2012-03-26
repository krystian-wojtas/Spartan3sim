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
module spi #(parameter WIDTH=32) (
	input RST,
	input CLK50MHZ,
	// spi interface
	input spi_sck_trig,
	input SPI_MISO,
	output reg SPI_MOSI,
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	input spi_trig,
	output reg spi_sending,
	output spi_done
    );
			
	reg [31:0] outshiftreg; //TODO WIDTH-1
	reg [WIDTH-1:0] inshiftreg; //TODO WIDTH-1
	assign data_out = inshiftreg;
	reg [5:0] outdacidx;	//TODO log2
	wire [5:0] outdacidxfull = 6'd32; //TODO WIDTH
			
			
	reg [1:0] state;
	localparam [1:0] 	TRIG_WAITING = 2'd0,
							SENDING = 2'd1,	
							DONE = 2'd2;
	
	
	always @(posedge CLK50MHZ) begin
		if(RST) state <= TRIG_WAITING;
		else begin
				case(state)
					TRIG_WAITING:
						if(spi_trig)
							state <= SENDING;
					SENDING:
						if(spi_sck_trig & outdacidx == outdacidxfull)
							state <= DONE;
					DONE:
						state <= TRIG_WAITING;
				endcase
		end		
	end
			
	
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			outshiftreg <= 32'd0;
			inshiftreg <= 32'd0; //TODO czy potrzebne zerowanie na resecie ina i outa?
			outdacidx <= 6'd0;
			SPI_MOSI <= 1'b0;
		end else
			case(state)
				TRIG_WAITING: begin
					outshiftreg <= data_in;
					inshiftreg <= 32'd0;
					outdacidx <= 6'd0;
					SPI_MOSI <= 1'b0;
				end
				SENDING: 
					if(spi_sck_trig) begin
						outshiftreg <= outshiftreg << 1;
						SPI_MOSI <= outshiftreg[WIDTH-1];
						inshiftreg <= inshiftreg << 1;
						inshiftreg[0] <= SPI_MISO;
						outdacidx <= outdacidx + 1;
					end
				DONE: begin
					SPI_MOSI <= 1'b0;	
					//dac potrzebuje dodatkowego cyklu aby wyslac ostatni bit; zaczyna odsylac bity kiedy juz dostal pierwszy; stad poslizg w dacu; dla ogolnego przypadku spi nie moze wystepowac poslizg
					//inshiftreg <= inshiftreg << 1; //TODO del
					//inshiftreg[0] <= SPI_MISO; 
				end
				default:
					SPI_MOSI <= 1'b0;					
			endcase
	end
	
	
	always @(posedge CLK50MHZ) begin
		if(RST) spi_sending <= 1'b0;
		else
			if(state == SENDING) begin
				if(spi_sck_trig)
					spi_sending <= 1'b1;
			end else
				spi_sending <= 1'b0;
	end
	
	
	assign spi_done = (state == DONE);

endmodule
