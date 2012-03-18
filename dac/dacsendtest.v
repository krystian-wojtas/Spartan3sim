`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:28:06 03/13/2012 
// Design Name: 
// Module Name:    dacsendtest 
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
module dacsendtest(
    );

   wire CLK50MHZ;
   clock clock50mhz_(.clk(CLK50MHZ));
    
   wire RST;
   reset #(40) reset_(.RST(RST));
   //rst rst_(.RST(RST));
	 
	wire SPI_SCK;
	spisck spisck_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.SPI_SCK(SPI_SCK)
	);
	
	wire DAC_CS;
	wire DAC_CLR = 1'b1; //TODO czy obsluga dac_clr w srodku dacsenda?
	wire dac_in; //TODO konwencja wielkich liter zmiennych oznaczajacych wyjscie do ucfa?
	wire DAC_OUT;
	dacLTC2624behav dacLTC2624behav_(
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.DAC_CLR(DAC_CLR),
		.dac_in(dac_in),
		.DAC_OUT(DAC_OUT)
	);	
	
	wire [11:0] data;
	wire [3:0] address;
	wire [3:0] command;
	wire dactrigsync;
	wire dactrigsyncack;
	wire dacdonesync;	
	dacsend dacsend_(
		.RST(RST),
		// hardware dac interface
		.SPI_SCK(SPI_SCK),
		.DAC_CS(DAC_CS),
		.dac_in(dac_in),
		// verilog module interface
		.data(data),
		.address(address),
		.command(command),
		.dactrigsync(dactrigsync),
		.dactrigsyncack(dactrigsyncack),
		.dacdonesync(dacdonesync)
	);
	
	
	dacsendtestbench dacsendtestbench_(
		.RST(RST),
		.SPI_SCK(SPI_SCK),
		.data(data),
		.address(address),
		.command(command),
		.dactrigsync(dactrigsync),
		.dactrigsyncack(dactrigsyncack),
		.dacdonesync(dacdonesync)
	);


endmodule
