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
		output reg spi_cs = 1'b1,
		input spi_miso,
		output spi_mosi,
		// spi module interface
		input [WIDTH-1:0] data_in,
		output [WIDTH-1:0] data_out,
		input spi_trig,
		output spi_ready,
		input clk,
		input tick
	);
	 
	 
	wire spi_en;
	wire sent_all_bits;	
	Counter #(
		.MAX(WIDTH+1)
	) Counter_bits (
		.CLK50MHZ(CLK50MHZ),
		// counter
		.cnt_en(spi_en), // if high counter is enabled and is counting
		.rst(~spi_en), // set counter register to zero
		.sig(tick), // signal which is counted
		.cnt_tick(sent_all_bits) // one pulse if counter is full
);

wire tx;
Shiftreg #(
	.WIDTH(WIDTH)
) Shiftreg_ (
	.CLK50MHZ(CLK50MHZ),
	// shiftreg
	.en(spi_en),
	.set(spi_trig), // setting shiftreg value to data_in if spi_trig occurs
	.tick(tick),
	.rx(spi_miso),
	.tx(tx),
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
			else if(state == DONE) // TODO spi_ready
				spi_cs <= 1'b1;
	end
	
	
	assign spi_en = (state == SENDING);
	assign spi_ready = ~spi_en; // TODO or state == DONE ?
	assign spi_sck = (spi_en) ? clk : 1'b0;
	assign spi_mosi = (spi_en) ? tx : 1'b1;

endmodule
