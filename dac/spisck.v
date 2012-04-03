`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:01 03/12/2012 
// Design Name: 
// Module Name:    spisck 
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
module spisck(
	input CLK50MHZ,
	input RST,
	output spi_sck_50,
	output spi_sck_trig_delay,
	output spi_sck_trig_div2_delay	
   );
	
	wire spi_sck_trig;
	clock_divider_trig clock_divider_trig_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_div_trig(spi_sck_trig)
	);
	
	wire spi_sck_trig_div2;
	clock_divider clock_divider_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.clk_div_trig(spi_sck_trig),
		.clk_div_trig_div2(spi_sck_trig_div2),
		.clk_div(spi_sck_50)
	);
	
	
	delay #(.DELAY(5)) delay_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.in(spi_sck_trig),
		.out(spi_sck_trig_delay)
	);
	
	delay #(.DELAY(5)) delay_div_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.in(spi_sck_trig_div2),
		.out(spi_sck_trig_div2_delay)
	);

endmodule
