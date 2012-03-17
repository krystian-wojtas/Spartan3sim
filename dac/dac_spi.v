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
module dacspi( //TODO rename dacbridge?
	input RST,
	input CLK50MHZ,
	// hardware dac interface
	input SPI_SCK,
	output DAC_CS,
	output reg DAC_CLR,
	output dac_in,
	input DAC_OUT,
	// verilog module interface
	//TODO fpga module interface ?
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrig,
	output reg dacdone
	);	
			
	reg dactrigsync;
	wire dactrigsyncack; //TODO dactrigsyncok ?
	wire dacdonesync;
	dacsend dacsend_(
		.RST(RST),
		// hardware dac interface
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.dac_in(dac_in),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrigsync(dactrigsync),
		.dactrigsyncack(dactrigsyncack),
		.dacdonesync(dacdonesync)
	);
	
	
	always @*
		if(~RST) //czy negacja?
			DAC_CLR = 1'b0;
		else
			DAC_CLR = 1'b1;			
			
			
	reg [2:0] state;
	localparam [2:0]	TRIG_WAITING = 3'd0,
							TRIGGING = 3'd1,
							TRIGGINGACK = 3'd2,
							WAITING_DONE = 3'd3,
							DONE = 3'd4;
	
	//state mashines are synchronizing trigers
	//dactrig has frequency 50MHz but dac is clocked by SPI_SCK
	always @(posedge CLK50MHZ) begin
		if(~RST) state = TRIG_WAITING;
		else begin
			case(state)
				TRIG_WAITING:
					if(~dactrig) //TODO ~?
						state = TRIG_WAITING;
					else
						state = TRIGGING;
				TRIGGING:
					state = TRIGGINGACK;
				TRIGGINGACK:
					if(~dactrigsyncack)
						state = TRIGGINGACK;
					else
						state = WAITING_DONE;
				WAITING_DONE:
					if(~dacdonesync)
						state = WAITING_DONE;
					else
						state = DONE;
				DONE:
					state = TRIG_WAITING;
			endcase
		end		
	end
	
	
	always @* begin
		dactrigsync = 1'b0;
		dacdone = 1'b0;
		case(state)
			TRIGGING: dactrigsync = 1'b1;
			TRIGGINGACK: dactrigsync = 1'b1;
			DONE: dacdone = 1'b1;
		endcase
	end
	
	
//	always @(posedge CLK50MHZ) begin
//		if(~RST) begin
//			dactrig <= 1'b0;
//			dacdone <= 1'b0;
//		end else begin
//			case(state)
//				TRIGGING: dactrigsync <= 1'b1;
//				TRIGGINGACK: dactdactrigsyncrig <= 1'b0;
//				DONE: dacdone <= 1'b1;
//			endcase
//		end
//	end
			
endmodule
