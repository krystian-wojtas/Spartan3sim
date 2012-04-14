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
module dacspi #(
	parameter TURNING_OFF_CLK = 0,
	parameter FASTDAC = 1,
	parameter EARLY_CS_POSEDGE = 0
) (
	input RST,
	input CLK50MHZ,
	// clocks
	input spi_sck_50,
	input spi_sck_trig_delay,
	input spi_sck_trig_div2_delay,
	// hardware dac interface
	output SPI_SCK,
	output DAC_CLR,
	output DAC_CS,
	output SPI_MOSI,
	input	DAC_OUT,
	// verilog module interface
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	input dactrig,
	output dacdone
	);
	
	localparam WIDTH=32;
	
	wire [WIDTH-1:0] dacdatatosend = {8'h80, command, address, data, 4'h1};
	wire [WIDTH-1:0] dacdatareceived;
	spi #(
		.WIDTH(WIDTH),
		.TURNING_OFF_CLK(TURNING_OFF_CLK),
		.FASTDAC(FASTDAC),
		.EARLY_CS_POSEDGE(EARLY_CS_POSEDGE)
	) spi_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// clocks
		.spi_sck_50(spi_sck_50),
		.spi_sck_trig_delay(spi_sck_trig_delay),
		.spi_sck_trig_div2_delay(spi_sck_trig_div2_delay),
		// spi lines
		.spi_sck(SPI_SCK),
		.spi_cs(DAC_CS),
		.spi_mosi(SPI_MOSI),
		.spi_miso(DAC_OUT),
		// spi module interface
		.data_in(dacdatatosend),
		.data_out(dacdatareceived),
		.spi_trig(dactrig),
		.spi_done(dacdone)
	);
	
	assign DAC_CLR = ~RST;
	
endmodule
