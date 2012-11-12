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
	parameter WIDTH=32,
	parameter DIV=1
) (
	input RST,
	input CLK50MHZ,
	// spi lines
	output spi_sck,
	output reg spi_cs,
	input spi_miso,
	output reg spi_mosi,
	// spi module interface
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	input spi_trig,
	output spi_done
    );
	 	
	
	wire clk_hf;
	wire clk_pos_trig;
	wire clk_neg_trig;
	ModClkConditional #(
		.DIV(DIV)
	) ModClkConditional_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_hf(clk_hf),
		.clk_pos_trig(clk_pos_trig),
		.clk_neg_trig(clk_neg_trig)	
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
	
			
	reg [WIDTH-1:0] shiftreg;
	reg [log2(WIDTH):0] shiftreg_idx;
	
	assign data_out = shiftreg;
			
			
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
						if(clk_pos_trig & shiftreg_idx == WIDTH+1)
							state <= DONE;
					DONE:
						state <= TRIG_WAITING;
				endcase
		end
	end
			
			
	always @(posedge CLK50MHZ) begin
		if(RST)
			shiftreg_idx <= 0;
		else
			case(state)
				TRIG_WAITING:
					shiftreg_idx <= 0;
				SENDING: 
					if(clk_pos_trig)
						if(shiftreg_idx <= WIDTH) //TODO <= ? <
							shiftreg_idx <= shiftreg_idx + 1;
						else
							shiftreg_idx <= 0;
			endcase
	end
			
			
	always @(posedge CLK50MHZ) begin
		if(RST) begin
			shiftreg <= 0;
		end else
			case(state)
				TRIG_WAITING:
					shiftreg <= data_in;
				SENDING: 
					if(clk_pos_trig & shiftreg_idx > 0)
						shiftreg <= { shiftreg[WIDTH-2:0], spi_miso };
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
					if(clk_pos_trig & shiftreg_idx > 0)
						spi_mosi <= shiftreg[WIDTH-1];
			endcase
	end


	always @(posedge CLK50MHZ) begin
		if(RST) spi_cs <= 1'b1;
		else
			if(state == SENDING)
				spi_cs <= 1'b0;
			else if(state == DONE)
				spi_cs <= 1'b1;
	end
	
	
	assign spi_sck = (shiftreg_idx > 1 & shiftreg_idx <= WIDTH+1) ? clk_hf : 1'b0;			
	assign spi_done = (state == DONE);

endmodule
