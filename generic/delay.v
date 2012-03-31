`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:06:43 03/29/2012 
// Design Name: 
// Module Name:    delay 
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
module delay #(parameter DELAY = 1) (
	input CLK50MHZ,
	input RST,
	input in,
	output out
    );

	reg [4:0] delay_cnt;//TODO log2
	
	reg [1:0] state;
	localparam [1:0] 	TRIG_WAITING = 2'd0,
							DELAING = 2'd1,	
							DONE = 2'd2;
	
	
	always @(posedge CLK50MHZ) begin
		if(RST) state <= TRIG_WAITING;
		else begin
				case(state)
					TRIG_WAITING:
						if(in)
							state <= DELAING;
					DELAING:
						if(delay_cnt == DELAY)
							state <= DONE;
					DONE:
						state <= TRIG_WAITING;
				endcase
		end		
	end
	
	
	always @(posedge CLK50MHZ) begin
		if(RST)
			delay_cnt <= 5'd0;
		else
			case(state)
				TRIG_WAITING:
					delay_cnt <= 5'd0;
				DELAING: 				
					delay_cnt <= delay_cnt + 1;
			endcase
	end
	
	assign out = (state == DONE);
	
endmodule
