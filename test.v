`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:08:00 03/12/2012 
// Design Name: 
// Module Name:    sim 
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
module test(
    );
	 
   wire CLK50MHZ;
   clk clk_(.CLK50MHZ(CLK50MHZ));
    
   wire RST;
   rst rst_(.RST(RST));
	 
	wire SPI_SCK;
	wire DAC_CS;
	wire DAC_CLR;
	wire dac_in; //TODO konwencja wielkich liter zmiennych oznaczajacych wyjscie do usfa?
	wire DAC_OUT;
	dacsim dacsim_(
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.dac_in(dac_in),
		.DAC_OUT(DAC_OUT)
	);	 
	 
	wire SPI_MOSI;
	wire [11:0] data;
	wire [3:0] address;
	wire [3:0] command;
	dac dac_(
		// hardware dac interface
		.SPI_SCK(SPI_SCK),			 
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.dac_in(SPI_MOSI), //rename SPI_MOSI -> dac_in
		.DAC_OUT(DAC_OUT),
		// fpga module interface
		.RST(RST),
		.data(data),
		.address(address),
		.command(command),
		.dac_trig(dac_trig),
		.dac_done(dac_done)
	);
	 
	
	testbench testbench_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.data(data),
		.address(address),
		.command(command),
		.dac_trig(dac_trig),
		.dac_done(dac_done)
	);

endmodule
