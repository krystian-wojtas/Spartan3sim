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
	output spi_mosi,
	// spi module interface
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	input spi_trig,
	output spi_done
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
	
	 
	wire spi_en;
	wire sent_all_bits;	
	Counter #(
//		.N(log2(WIDTH)),
		.N(5),
		.MAX(WIDTH)
	) Counter_ (
		.CLK50MHZ(CLK50MHZ),
		// counter
		.cnt_en(spi_en), // if high counter is enabled and is counting
		.rst(~spi_en), // set counter register to zero
		.sig(1'b1), // signal which is counted
		.cnt_tick(sent_all_bits) // one pulse if counter is full
);

Shiftreg #(
	.WIDTH(WIDTH)
) Shiftreg_ (
	.CLK50MHZ(CLK50MHZ),
	// shiftreg
	.en(spi_en), // set shiftreg register to zero
	.tick(1'b1), //TODO
	.rx(1'b0),
	.tx(spi_mosi),
	.data_in(data_in),
	.data_out(data_out)
);

			
			
	localparam [1:0] 	TRIG_WAITING = 2'd0,
							SENDING = 2'd1,	
							DONE = 2'd2;
	reg [1:0] state = TRIG_WAITING;
	
	
	always @(posedge CLK50MHZ) begin
		if(RST) state <= TRIG_WAITING;
		else begin
				case(state)
					TRIG_WAITING:
						if(spi_trig)
							state <= SENDING;
					SENDING:
						if(sent_all_bits)
							state <= DONE;
					DONE:
						state <= TRIG_WAITING;
				endcase
		end
	end

	

	always @(posedge CLK50MHZ) begin
		if(RST) spi_cs <= 1'b1;
		else
			if(state == SENDING)
				spi_cs <= 1'b0;
			else if(spi_done)
				spi_cs <= 1'b1;
	end
	
	
	assign spi_en = (state == SENDING);
	assign spi_sck = (spi_en) ? CLK50MHZ : 1'b0;			
	assign spi_done = (state == DONE);

endmodule
