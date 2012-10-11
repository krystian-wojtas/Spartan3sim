`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:36 03/17/2012 
// Design Name: 
// Module Name:    Spi 
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

module Spi #(
    parameter WIDTH=32
) (
	input RST,
	input CLK50MHZ,
	// spi lines
	output spi_sck,
	output reg spi_cs = 1,
	input spi_miso,
	output reg spi_mosi = 0,
	// spi module interface
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	input spi_trig,
	output spi_done,
	// spi clock
	input clk_hf,
	input write_trig,
	input read_trig	
 );

	//constant function calculetes value at collaboration time
	//source http://www.beyond-circuits.com/wordpress/2008/11/constant-functions/
	function integer log2;
	  input integer value;
	  begin
		 value = value-1;
		 for (log2=0; value>0; log2=log2+1)
			value = value>>1;
	  end
	endfunction
	
			
	reg [log2(WIDTH):0] shiftreg_idx = 0;
	reg [WIDTH-1:0] shiftreg_in = 0;
	reg [WIDTH-1:0] shiftreg_out = 0;
	
	assign data_out = shiftreg_out;
			
			
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
						if(write_trig & shiftreg_idx == WIDTH+1)
							state <= DONE;
					DONE:
						state <= TRIG_WAITING;
				endcase
		end
	end
			
			
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			shiftreg_idx <= 0;
		end else
			case(state)
				TRIG_WAITING: begin
					shiftreg_idx <= 0;
				end
				SENDING: 
					if(write_trig)
						if(shiftreg_idx <= WIDTH) //TODO <= ? <
							shiftreg_idx <= shiftreg_idx + 1;
						else
							shiftreg_idx <= 0;
			endcase
	end
			
			
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			shiftreg_in <= 0;
		end else
			case(state)
				TRIG_WAITING:
					shiftreg_in <= data_in;
				SENDING: 
					if(shiftreg_idx > 0) begin
						if(write_trig)
							shiftreg_in <= { shiftreg_in[WIDTH-2:0], 1'b0 };
						if(read_trig)
							shiftreg_out <= { shiftreg_out[WIDTH-2:0], spi_miso };
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
					if(shiftreg_idx > 0 & write_trig)
						spi_mosi <= shiftreg_in[WIDTH-1];
			endcase
	end
	
			
	always @(posedge CLK50MHZ) begin
		if(RST) spi_cs <= 1'b1;
		else
			if(spi_trig)
				spi_cs <= 1'b0;
			else if(spi_done)
					spi_cs <= 1'b1;
	end
	
	
	assign spi_sck = (shiftreg_idx > 1 & shiftreg_idx <= WIDTH+1) ? clk_hf : 1'b0;			
	assign spi_done = (state == DONE);


endmodule
