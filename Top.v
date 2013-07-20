`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:07:44 03/12/2012 
// Design Name: 
// Module Name:    Top 
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

module Top (
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
	
	
	wire less;
	Counter #(
//	  .MAX(10) // sim
	  .MAX(10_000_000) // synth
	) Debouncer_less (
	  .CLKB(CLK50MHZ),
	  .en(1'b1),
	  .rst(RST),
	  .sig(BTN_WEST),
	  .full(less)
	);
	
	wire more;
	Counter #(
//	  .MAX(10) // sim
	  .MAX(10_000_000) // synth
	) Debouncer_more (
	  .CLKB(CLK50MHZ),
	  .en(1'b1),
	  .rst(RST),
	  .sig(BTN_EAST),
	  .full(more)
	);
	
	wire [11:0] data;
	wire [3:0] address;
	wire [3:0] command;
	wire dactrig;
	wire dacdone;
	wire [31:0] dac_datareceived;
	Controller Controller_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dac_datareceived(dac_datareceived),
		.dactrig(dactrig),
		.dacdone(dacdone),
		//control
		.less(less),
		.more(more),
		.SW(SW),
		// debug
		.LED(LED)
	);
	
	DacSpi DacSpi_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
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
		.dac_datareceived(dac_datareceived),
		.dactrig(dactrig),
		.dacdone(dacdone)
	);

				

endmodule
