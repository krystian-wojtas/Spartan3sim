`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:10:37 07/22/2012 
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
	// spi wires
	output SPI_SCK,
	output SPI_MOSI,
	// amp wires
	output AMP_CS,
	output AMP_SHDN,
	input AMP_DOUT,
	// adc wires
	output AD_CONV,
	input ADC_OUT,
	// control
	input [3:0] SW,
	output [7:0] LED
   );	
	
	
	// amp
	wire amp_trig;
	wire [3:0] amp_a;
	wire [3:0] amp_b;
	wire amp_done;
	// adc
	wire adc_trig;
	wire [13:0] adc_a;
	wire [13:0] adc_b;
	wire [7:0] amp_datareceived;
	cntr cntr_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// amp
		.amp_trig(amp_trig),
		.amp_a(amp_a),
		.amp_b(amp_b),
		.amp_done(amp_done),
		// adc
		.adc_trig(adc_trig),
		.adc_done(adc_done),
		.adc_a(adc_a),
		.adc_b(adc_b),
		// control
		.sw(SW),
		.led(LED),
		.amp_datareceived(amp_datareceived)
	);
	
	
	// spi wires
	wire spi_sck_amp;
	Amp amp_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi wires
		.spi_sck(spi_sck_amp),
		.spi_mosi(SPI_MOSI),
		// amp wires
		.amp_cs(AMP_CS),
		.amp_shdn(AMP_SHDN),
		.amp_dout(AMP_DOUT),
		// amp module interface
		.amp_trig(amp_trig),
		.amp_done(amp_done),
		.amp_a(amp_a),
		.amp_b(amp_b),
		.amp_datareceived(amp_datareceived)
	);
	
	
	wire spi_sck_adc;
	Adc Adc_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi wires
		.spi_sck(spi_sck_adc),
		// adc wires
		.adc_conv(AD_CONV),
		.adc_out(ADC_OUT),
		// adc module interface
		.adc_trig(adc_trig),
		.adc_done(adc_done),
		.adc_a(adc_a),
		.adc_b(adc_b)
	);
	

	assign SPI_SCK = spi_sck_amp | spi_sck_adc;

endmodule












