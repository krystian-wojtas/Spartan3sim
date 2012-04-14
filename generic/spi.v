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
module spi #(
	parameter WIDTH=32,
	parameter TURNING_OFF_CLK = 0,

	parameter FASTDAC = 1,
// FASTDAC=1 stands for clocking dac with max speed CLK50MHZ
// if FASTDAC=0, it should be wired slower clock-triger spi_sck_trig_div2_delay

	parameter EARLY_CS_POSEDGE = 0
// only with FASTDAC=0 and TURNING_OFF_CLK=1
// with EARLY_CS_POSEDGE=1 posedge of spi_cs is triggering on high state of spi_sck
// it should be wired clock-triger spi_sck_trig_delay - 2 times faster then spi_sck_trig_div2_delay

// ostatnia sztuczka
// dla fastdaca=1 mozna przestawic spi_sck na reakcje negatywne
) (
	input RST,
	input CLK50MHZ,
	// clocks
	input spi_sck_50,
	input spi_sck_trig_delay,
	input spi_sck_trig_div2_delay,
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
	 
	wire spi_sck_trig_div2_delay_param = (FASTDAC) ? 1'b1 : spi_sck_trig_div2_delay;
	wire spi_sck_trig_delay_param = (EARLY_CS_POSEDGE) ? spi_sck_trig_delay : 1'b0;
			
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
						if(spi_sck_trig_div2_delay_param & shiftreg_idx == shiftreg_idx_full)
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
					if(spi_sck_trig_div2_delay_param) begin
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
					if(spi_sck_trig_div2_delay_param)
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
					if(spi_sck_trig_div2_delay_param)
						if(shiftreg_idx < shiftreg_idx_full) begin
							spi_cs <= 1'b0;
						end else
							spi_cs <= 1'b1;
			endcase
	end
			
	reg spi_clocking;
	always @(posedge CLK50MHZ)
		if(RST) spi_clocking <= 1'b0;
		else
			if(~spi_cs)
				spi_clocking <= 1'b1;
			else
				if(spi_sck_trig_delay_param)
					spi_clocking <= 1'b0;
	
	reg spi_sck_en;
	always @*
		if(TURNING_OFF_CLK)
			if(EARLY_CS_POSEDGE) begin
				if(spi_clocking)
					spi_sck_en = 1'b1;
				else
					spi_sck_en = 1'b0;
			end else begin
				if(~spi_cs)
					spi_sck_en = 1'b1;
				else
					spi_sck_en = 1'b0;
			end
		else
			spi_sck_en = 1'b1;
	
	wire spi_sck_source_select = (FASTDAC) ? CLK50MHZ : spi_sck_50;
	assign spi_sck = (spi_sck_en) ? spi_sck_source_select : 1'b0;
	
	assign spi_done = (state == DONE);

endmodule
