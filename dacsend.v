`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:41:41 03/13/2012 
// Design Name: 
// Module Name:    dacsend 
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
module dacsend(
	input RST,
	// hardware dac interface
	input SPI_SCK,
	output reg DAC_CS,
	output reg dac_in,
	// verilog module interface
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrigsync,
	output reg dactrigsyncack,
	output reg dacdonesync
    );	 	 
	 

	reg [1:0] state;
	localparam [1:0]	TRIG_WAITING = 2'd0,
							TRIGACK = 2'd1,
							SENDING = 2'd2,
							DONE = 2'd3;
	 
	
	reg [3:0] _4dontcare = 4'd0; //TODO 4'dx ?
	reg [7:0] _8dontcare = 8'd0;
	wire [31:0] outdacshiftreg = {_4dontcare, data, address, command, _8dontcare}; //albo krotszy rejestr i dodatkowe stany wysylaje dontcarey; mniej zasobow, bufor tez krotszy
	reg [31:0] outdacshiftregbuf = 32'd0; //TODO x?
	wire firstbitoutdac = outdacshiftregbuf[0];
	reg [5:0] outdacidx;
	wire sended = & outdacidx;
	
	
	always @(posedge SPI_SCK) begin //TODO czy resetowac przez RST? wtedy szybciej sie zresetuje ale wymagany nextstate
		if(~RST) state = TRIG_WAITING;
		else begin
			case(state)
				TRIG_WAITING:
					if(~dactrigsync)
						state = TRIG_WAITING;
					else
						state = TRIGACK;
				TRIGACK:
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
	
	
	always @* begin
		dactrigsyncack = 1'b0;
		dacdonesync = 1'b0;
		DAC_CS = 1'b1;
		dac_in = 1'b0;
		case(state)
			TRIGACK:
				dactrigsyncack = 1'b1;
			SENDING: begin
				DAC_CS = 1'b0;
				dac_in = firstbitoutdac;
			end
			DONE:
				dacdonesync = 1'b1;
		endcase		
	end
	
	
	always @(posedge SPI_SCK) begin
		case(state)
			TRIGACK: begin
				outdacshiftregbuf <= outdacshiftreg;
				//outdacshiftregbuf <= {_4dontcare, data, address, command, _8dontcare};
			end
			SENDING: begin
				outdacshiftregbuf <= outdacshiftregbuf << 1; //TODO w jaki sposob przekrecac rejestr?
				//outdacshiftregbuf[0:31] <= {outdacshiftregbuf[1:31], 1'b0};
				//TODO ? outdacshiftregbuf <= {outdacshiftregbuf[1:31], outdacshiftregbuf[0]};
				outdacidx <= outdacidx + 1;
			end
		endcase
	end	

endmodule
