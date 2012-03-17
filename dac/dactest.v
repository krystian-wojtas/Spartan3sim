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
module dactest(
    );
	 
   wire CLK50MHZ;
   clock clock_(.CLK50MHZ(CLK50MHZ));
    
   wire RST;
   reset reset_(.RST(RST));
	 
	wire SPI_SCK;
	wire spi_sck_trig;
	spisck spisck_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.SPI_SCK(SPI_SCK),
		.spi_sck_trig(spi_sck_trig)
	);
	 
	wire DAC_CS;
	wire DAC_CLR;
	wire dac_in; //TODO konwencja wielkich liter zmiennych oznaczajacych wyjscie do ucfa?
	wire DAC_OUT;
	dacLTC2624behav dacLTC2624behav_(
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
	dacspi dacspi_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// hardware dac interface
		.spi_sck_trig(spi_sck_trig),			 
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.dac_in(SPI_MOSI), //rename SPI_MOSI -> dac_in
		.DAC_OUT(DAC_OUT),
		// fpga module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone)
	);
	 
	
	dactestbench dactestbench_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.data(data),
		.address(address),
		.command(command),
		.dactrig(dactrig),
		.dacdone(dacdone)
	);

endmodule
