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
module dac( //TODO rename dacbridge?
	// hardware dac interface
	input SPI_SCK,
	output reg DAC_CS,
	output reg DAC_CLR,
	output reg dac_in,
	input DAC_OUT,
	// fpga module interface
	input RST,
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dac_trig,
	output reg dac_done
	);
	
	
	always @*
		if(~RST)
			DAC_CLR = 1'b0;
		else
			DAC_CLR = 1'b1;

//	always @(posedge RST) begin
//		DAC_CLR = 1'b1;
//	end
	
	
	reg [3:0] _4dontcare;
	reg [8:0] _8dontcare;
	wire [31:0] outdacshiftreg = {_4dontcare, data, address, command, _8dontcare}; //albo krotszy rejestr i dodatkowe stany wysylaje dontcarey; mniej zasobow, bufor tez krotszy
	reg [31:0] outdacshiftregbuf;
	reg [5:0] outdacidx;
	reg [5:0] noutdacidx;
	
	reg [2:0] state;
	reg [2:0] nstate;
	localparam [2:0]	IDLE = 3'd0, //TODO po co idle?
							TRIG_WAITING = 3'd1,
							CHIP_SELECT = 4'd2,
							SENDING = 3'd3,
							DONE = 3'd4;
	
	always @(posedge SPI_SCK) begin
		state <= nstate;
		outdacidx <= noutdacidx;
	end
	
	//czy w tym bloku zliczanie outdacidx?
	always @(posedge SPI_SCK) begin //TODO trig waiting zgodnie z CLK50MHZ?
		if(~RST) nstate <= IDLE;
		else begin
			case(state)
				IDLE:
					nstate <= TRIG_WAITING;
				TRIG_WAITING:
					if(dac_trig)
						nstate <= CHIP_SELECT;
				CHIP_SELECT: begin
					noutdacidx <= 6'b0;
					nstate <= SENDING;
				end
				SENDING: begin
					if(& outdacidx) nstate <= DONE;					
					noutdacidx <= outdacidx + 1;
				end
				DONE:
					nstate <= IDLE;
			endcase
		end		
	end
	
	always @* begin
		dac_done = 1'b0;
		DAC_CS = 1'b1;
		dac_in = 1'b0;
		case(state)
			CHIP_SELECT: begin
				DAC_CS = 1'b0;
				outdacshiftregbuf = outdacshiftreg;
			end
			SENDING: begin
				DAC_CS = 1'b0;
				dac_in = outdacshiftregbuf[0];
				outdacshiftregbuf = outdacshiftregbuf << 1; //TODO w jaki sposob przekrecac rejestr?
				//outdacshiftregbuf[0:31] = {outdacshiftregbuf[1:31], 1'b0};
				//TODO ? outdacshiftregbuf = {outdacshiftregbuf[1:31], outdacshiftregbuf[0]};
			end
			DONE:
				dac_done = 1'b1;
		endcase
	end

endmodule
