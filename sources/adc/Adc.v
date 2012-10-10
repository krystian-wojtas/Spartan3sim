`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:32 07/22/2012 
// Design Name: 
// Module Name:    Adc 
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
module Adc(
	input CLK50MHZ,
	input RST,
	// spi wires
	output spi_sck,
	// adc wires
	output adc_conv,
	input adc_out,	
	// adc module interface
	input adc_trig,
	output adc_done,
	output [13:0] adc_a,
	output [13:0] adc_b
    );	 
	
	
	wire clk_hf;
	wire clk_pos_trig;
	wire clk_neg_trig;
	ModClkConditional #(
		.DIV(10)
	)  ModClkConditional_ (
		.CLK50MHZ(CLK50MHZ),
		.clk_hf(clk_hf),
		.clk_pos_trig(clk_pos_trig),
		.clk_neg_trig(clk_neg_trig)	
	);	
	
	
	localparam WIDTH=32;
	
	wire [WIDTH-1:0] adc_datatosend = 0;
	wire [WIDTH-1:0] adc_datareceived;
	assign adc_a = adc_datareceived[15:2]; //TODO reverse
	assign adc_b = adc_datareceived[31:18];
	
	wire spi_cs;
	wire spi_mosi;
	Spi #(
		.WIDTH(WIDTH)
	) Spi_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(spi_cs),
		.spi_mosi(spi_mosi),
		.spi_miso(adc_out),
		// spi module interface
		.data_in(adc_datatosend),
		.data_out(adc_datareceived),
		.spi_trig(adc_trig),
		.spi_done(adc_done),
		// spi clock
		.clk_hf(clk_hf),
		.write_trig(clk_pos_trig),
		.read_trig(clk_neg_trig)	
	);
	
	assign adc_conv = adc_trig;


endmodule
