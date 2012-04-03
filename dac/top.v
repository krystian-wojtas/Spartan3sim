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
module top(
	input CLK50MHZ,
	input RST,
	// dac
	output SPI_SCK,
	output DAC_CLR,
	output DAC_CS,
	output SPI_MOSI,
	input DAC_OUT,
	// control
	input BTN_WEST,
	input BTN_EAST,
	output [7:0] LED
   );	

	wire spi_sck_trig_delay;
	wire spi_sck_trig_div2_delay;
	spisck spisck_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.SPI_SCK(SPI_SCK),
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
	
	wire [11:0] data;
	wire [3:0] address;
	wire [3:0] command;
	wire dactrig;
	wire dacdone;
//	assign data = 12'h03f;
//	assign address = 4'b1111;
//	assign command = 4'b0011;
//	assign dactrig = 1'b1;
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
		// debug
		.LED(LED)
	);
	
	dacspi dacspi_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// clocks
		.spi_sck_trig_delay(spi_sck_trig_delay),
		.spi_sck_trig_div2_delay(spi_sck_trig_div2_delay),
		// hardware dac interface
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
