`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:12:16 07/22/2012 
// Design Name: 
// Module Name:    TopTest 
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
module TopTest(
    );
	 
	wire CLK50MHZ;
   Clock Clock_(.clk(CLK50MHZ));
    
   wire RST;
   Reset Reset_(.RST(RST));
	
	// spi wires
	wire SPI_SCK;
	wire SPI_MOSI;
	// amp wires
	wire AMP_CS;
	wire AMP_SHDN;
	wire AMP_DOUT;
	// adc wires
	wire AD_CONV;
	wire ADC_OUT;
	// control
	wire [3:0] SW;
	wire [7:0] LED;
	Top Top_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// spi wires
		.SPI_SCK(SPI_SCK),
		.SPI_MOSI(SPI_MOSI),
		// amp wires
		.AMP_CS(AMP_CS),
		.AMP_SHDN(AMP_SHDN),
		.AMP_DOUT(AMP_DOUT),
		// adc wires
		.AD_CONV(AD_CONV),
		.ADC_OUT(ADC_OUT),
		// control
		.SW(SW),
		.LED(LED)
	);
	
	
	AmpLTC6912_1_behav AmpLTC6912_1_behav_(
		.SPI_SCK(SPI_SCK),
		.SPI_MOSI(SPI_MOSI),
		.AMP_CS(AMP_CS),
		.AMP_SHDN(AMP_SHDN),
		.AMP_DOUT(AMP_DOUT)
	);
	
	
	AdcLTC1407A_1_behav AdcLTC1407A_1_behav_(
		.SPI_SCK(SPI_SCK),
		.AD_CONV(AD_CONV),
		.ADC_OUT(ADC_OUT)
	);
	
	
	TopTestBench TopTestBench_(
		.SW(SW)
	);

endmodule
