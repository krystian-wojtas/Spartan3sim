`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:35:44 10/23/2012 
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
module Top(
	input CLK50MHZ,
	input RST,
	input BTN,
	output [7:0] LED,
	//
//	input RXD,
	output TXD
    );
	 
	wire RXD= 1'b0; // TODO del
	 
	wire btn_debounce;
	Counter #(
	  .MAX(1_00) // sim
//	  .MAX(10_000_000) // synth
	) Debouncer_less (
	  .CLKB(CLK50MHZ),
	  .en(1'b1),
	  .rst(RST),
	  .sig(BTN),
	  .full(btn_debounce)
	);
	
	reg btn_once = 1'b0;
	wire btn_ee = btn_debounce & ~btn_once;
	always @(posedge CLK50MHZ)
		if(RST)
			btn_once <= 1'b0;
		else if(~BTN)
			btn_once <= 1'b0;
		else if(btn_debounce && ~btn_once)
			btn_once <= 1'b1;
			
//	reg [7:0] leds = { 3'b010, 4'h5, btn_once };
	assign LED = { 3'b010, 4'h5, btn_once };
	
	 	 
	 serialfun serialfun_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.BTN(btn_ee),
		.RxD(RXD),
		.TxD(TXD)
	);
		

endmodule
