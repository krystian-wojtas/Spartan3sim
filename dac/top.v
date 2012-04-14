`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:07:44 03/12/2012 
// Design Name: 
// Module Name:    top 
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

//	sensible sets of parameters
//	parameter TURNING_OFF_CLK = 0,
//	parameter FASTDAC = 1,
//	parameter EARLY_CS_POSEDGE = 0
//
//	parameter TURNING_OFF_CLK = 1,
//	parameter FASTDAC = 1,
//	parameter EARLY_CS_POSEDGE = 0
//
//	parameter TURNING_OFF_CLK = 0,
//	parameter FASTDAC = 0,
//	parameter EARLY_CS_POSEDGE = 0
//
//	parameter TURNING_OFF_CLK = 1,
//	parameter FASTDAC = 0,
//	parameter EARLY_CS_POSEDGE = 0
//
//	parameter TURNING_OFF_CLK = 1,
//	parameter FASTDAC = 0,
//	parameter EARLY_CS_POSEDGE = 1
module top #(
	parameter TURNING_OFF_CLK = 1,
// TURNING_OFF_CLK=1 if spi should be clocking all the time

	parameter FASTDAC = 1,
// FASTDAC=1 stands for clocking dac with max speed CLK50MHZ
// if FASTDAC=0, it should be wired slower clock-triger spi_sck_trig_div2_delay

	parameter EARLY_CS_POSEDGE = 0
// only with FASTDAC=0 and TURNING_OFF_CLK=1
// with EARLY_CS_POSEDGE=1 posedge of spi_cs is triggering on high state of spi_sck
// it should be wired clock-triger spi_sck_trig_delay - 2 times faster then spi_sck_trig_div2_delay
) (
	input CLK50MHZ,
	input RST,
	// dac
	output SPI_SCK,
	output DAC_CLR,
	output DAC_CS,
	output SPI_MOSI,
	input DAC_OUT,
	// control
	input [3:0] SW,
	input BTN_WEST,
	input BTN_EAST,
	output [7:0] LED
   );	

	wire spi_sck_50;
	wire spi_sck_trig_delay;
	wire spi_sck_trig_div2_delay;
	spisck spisck_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.spi_sck_50(spi_sck_50),
		.spi_sck_trig_delay(spi_sck_trig_delay),
		.spi_sck_trig_div2_delay(spi_sck_trig_div2_delay)
	);
	
	
	wire less;
	debouncer debouncer_less_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.in(BTN_WEST),
		.out(less)
	);
	
	wire more;
	debouncer debouncer_more_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.in(BTN_EAST),
		.out(more)
	);
	
	wire [3:0] sw;
	switch_oneshot switch_oneshot_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.sw_in(SW),
		.sw_out(sw)	
	);
	
	wire [11:0] data;
	wire [3:0] address;
	wire [3:0] command;
	wire dactrig;
	wire dacdone;
	cntr cntr_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone),
		//control
		.less(less),
		.more(more),
		.sw(sw), //moze byc sw po zdebouncowaniu
		// debug
		.LED(LED)
	);
	
	dacspi #(
		.TURNING_OFF_CLK(TURNING_OFF_CLK),
		.FASTDAC(FASTDAC),
		.EARLY_CS_POSEDGE(EARLY_CS_POSEDGE)
	) dacspi_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// clocks
		.spi_sck_50(spi_sck_50),
		.spi_sck_trig_delay(spi_sck_trig_delay),
		.spi_sck_trig_div2_delay(spi_sck_trig_div2_delay),
		// hardware dac interface
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.SPI_MOSI(SPI_MOSI),
		.DAC_OUT(DAC_OUT),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone)
	);
				

endmodule
