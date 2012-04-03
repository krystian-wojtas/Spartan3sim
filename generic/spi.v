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
	// clocks
	input spi_sck_trig_delay,
	input spi_sck_trig_div2_delay,
	// spi lines
	output reg  spi_cs,
	input spi_miso,
	output reg spi_mosi,
	// spi module interface
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	input spi_trig,
	output spi_done
    );
	 
			
	reg [WIDTH-1:0] shiftreg; //TODO WIDTH-1
	assign data_out = shiftreg;
	reg [5:0] shiftreg_idx;	//TODO log2
	wire [5:0] shiftreg_idx_full = 6'd32; //TODO WIDTH
			
			
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
						if(spi_sck_trig_div2_delay & shiftreg_idx == shiftreg_idx_full)
							state <= DONE;
					DONE:
						state <= TRIG_WAITING;
				endcase
		end		
	end
			
	
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			shiftreg <= 32'd0;
			shiftreg_idx <= 6'd0;
		end else
			case(state)
				TRIG_WAITING: begin
					shiftreg <= data_in;
					shiftreg_idx <= 6'd0;
				end
				SENDING: 
					if(spi_sck_trig_div2_delay) begin
						shiftreg <= { shiftreg[WIDTH-2:0], spi_miso };			
						shiftreg_idx <= shiftreg_idx + 1;
					end		
			endcase
	end
			
	
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			spi_mosi <= 1'b0;
		end else
			case(state)
				TRIG_WAITING:
					spi_mosi <= 1'b0;
				SENDING:
					if(spi_sck_trig_div2_delay)
						spi_mosi <= shiftreg[WIDTH-1];
			endcase
	end
			
			
	always @(posedge CLK50MHZ) begin
		if(RST) spi_cs <= 1'b1;
		else
			case(state)
				TRIG_WAITING:
					spi_cs <= 1'b1;
				SENDING:
					if(spi_sck_trig_delay)
						//if(shiftreg_idx > 0 & shiftreg_idx < shiftreg_idx_full-2)
						if(shiftreg_idx < shiftreg_idx_full) begin
							if(spi_sck_trig_div2_delay)
								spi_cs <= 1'b0;
						end else
							spi_cs <= 1'b1;
			endcase
	end
	
//	always @(posedge CLK50MHZ) begin
//		if(RST) spi_cs <= 1'b1;
//		else
//			case(state)
//				TRIG_WAITING:
//					spi_cs <= 1'b1;
//				SENDING: begin
//					if(spi_cs) begin
//						if(spi_sck_trig_div2_delay)
//							spi_cs <= 1'b0;
//					end else
//						if(shiftreg_idx == shiftreg_idx_full & spi_sck_trig_delay)
//							spi_cs <= 1'b1;
//				end
//				DONE:
//					spi_cs <= 1'b1;
//			endcase
//	end
	
	
	assign spi_done = (state == DONE);

endmodule
