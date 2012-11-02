`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:27:19 07/22/2012 
// Design Name: 
// Module Name:    Amp 
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
module Amp(
	input CLK50MHZ,
	input RST,
	// spi wires
	output spi_sck,
	output spi_mosi,
	// amp wires
	input amp_dout,
	output amp_cs,
	output amp_shdn,
	// amp module interface
	input amp_trig,
	output amp_done,
	input [3:0] amp_a,
	input [3:0] amp_b,
	// debug
	output [7:0] amp_datareceived
    );
	 
	 
	localparam WIDTH=8;
	
	
	wire clk_tick;
	Counter #(
		.MAX(5),
		.DELAY(1)
	) Counter_clk (
		.CLKB(CLK50MHZ),
		// counter
		.en(1'b1), // if high counter is enabled and is counting
		.rst(RST), // set counter register to zero
		.sig(1'b1), // signal which is counted
		.full(clk_tick) // one pulse if counter is full
	);
	
	
	wire clk;
	Inverter Inverter (
		.CLK(CLK50MHZ),
		.tick(clk_tick),
		.inv(clk)
	);
	
	
	wire tick_pos;
	Counter #(
		.MAX(8),
		.DELAY(0)
	) Counter_tick_pos (
		.CLKB(CLK50MHZ),
		// counter
		.en(1'b1), // if high counter is enabled and is counting
		.rst(RST), // set counter register to zero
		.sig(1'b1), // signal which is counted
		.full(tick_pos) // one pulse if counter is full
	);
	
	
	wire [WIDTH-1:0] amp_datatosend = { amp_b,  amp_a };
	Spi #(
		.WIDTH(WIDTH)
	) Spi_mosi (
		.CLKB(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(amp_cs),
		.spi_mosi(spi_mosi),
		.spi_miso(1'b1),
		// spi module interface
		.data_in(amp_datatosend),
		.data_out(amp_datareceived),
		.trig(amp_trig),
		.ready(amp_done),
		.clk(clk),
		.tick(tick_pos)
	);
	
	
	wire tick_neg;
	Counter #(
		.MAX(8),
		.DELAY(0)
	) Counter_tick_neg (
		.CLKB(CLK50MHZ),
		// counter
		.en(1'b1), // if high counter is enabled and is counting
		.rst(RST), // set counter register to zero
		.sig(1'b1), // signal which is counted
		.full(tick_neg) // one pulse if counter is full
	);
	
	
	Spi #(
		.WIDTH(WIDTH)
	) Spi_miso (
		.CLKB(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_sck(spi_sck),
		.spi_cs(amp_cs),
		.spi_miso(amp_dout),
		// spi module interface
		.data_in( 0 ),
		.data_out(amp_datareceived),
		.trig(amp_trig),
		.ready(amp_done),
		.clk(clk),
		.tick(tick_neg)
	);
	
	
	assign amp_shdn = ~RST;


endmodule
