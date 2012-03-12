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
module sim(
    );
	 
    wire CLK50MHZ;
    clk clk_(.CLK50MHZ(CLK50MHZ));
    
    wire RST;
    rst rst_(.RST(RST));
	 
	 wire SPI_MOSI;
	 wire SPI_SCK;
	 wire DAC_CS;
	 wire DAC_CLR;
	 reg DAC_OUT;
	 top top_(.RST(RST),
	          .CLK50MHZ(CLK50MHZ),
				 .SPI_MOSI(SPI_MOSI),
				 .SPI_SCK(SPI_SCK),
				 .DAC_CS(DAC_CS),
				 .DAC_CLR(DAC_CLR),
				 .DAC_OUT(DAC_OUT));

endmodule
