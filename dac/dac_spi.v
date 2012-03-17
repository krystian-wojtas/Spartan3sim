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
	input spi_sck_trig,
	output reg DAC_CS,
	output reg DAC_CLR,
	output reg dac_in,
	input DAC_OUT,
	// verilog module interface
	//TODO fpga module interface ?
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrig,
	output reg dacdone
	);	
	
	
	always @*
		if(~RST) //czy negacja?
			DAC_CLR = 1'b0;
		else
			DAC_CLR = 1'b1;			
			
			
	reg [31:0] outdacshiftreg = 32'dx;
	reg [5:0] outdacidx;
	wire sended = outdacidx[6]; //the content of outdacshiftreg is sended if counter outdacidx is 6'b1_xxxxx
			
			
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
						if(~sended)
							state = SENDING;
						else
							state = DONE;
					DONE:
						state = TRIG_WAITING;
				endcase
		end		
	end
			
	
	wire dacdatatosend = {4'bx, data, address, command, 8'bx};
	always @(posedge CLK50MHZ)
		if(~RST) begin
			outdacshiftreg <= 32'd0;
			outdacidx <= 6'd0;
		end else if(spi_sck_trig)
			case(state)
				TRIGGING: begin
					outdacshiftreg <= dacdatatosend;
					outdacidx <= 6'd0;
				end
				SENDING: begin
					outdacshiftreg <= outdacshiftreg << 1;
					outdacidx <= outdacidx + 1;
				end
			endcase
			
			
	wire firstbitoutdac = outdacshiftreg[0];
	always @* begin
		DAC_CS = 1'b1;
		dac_in = 1'b0;
		dacdone = 1'b0;
		case(state)
			SENDING: begin
				DAC_CS = 1'b0;
				dac_in = firstbitoutdac;
			end
			DONE:
				dacdone = 1'b1;
		endcase		
	end
			
endmodule
