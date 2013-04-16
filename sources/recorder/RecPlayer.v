`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:05 04/11/2013 
// Design Name: 
// Module Name:    RecPlayer 
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
module RecPlayer #(
		parameter WIDTH = 1000
	) (
	input CLK50MHZ,
	input RST,
	// rec
	input signal,
	input recording,
	output rec_full,
	// tx
	input sending,
	output sended,
	output TxD
	);
	 
	
	wire tx;
	wire ready;
	wire [WIDTH-1:0] data;
	wire tick;
	Serial #(
		.WIDTH(WIDTH)
	) Serial_(
		.CLKB(CLK50MHZ),
		.RST(RST),
		// rec
		.rx(signal),
		.tx(tx),
		.data_in(data),
		.data_out(data),
		.trig(recording),
		.ready(ready),
		.tick(tick)
	);
	
	reg recording_ = 1'b0;
	always @(posedge CLK50MHZ)
		if(RST) recording_ <= 1'b0;
		else recording_ <= recording;
	assign rec_full = recording_ & ready;
	
	wire [7:0] tx_data = tx ? "1" : "0";
//	wire [7:0] tx_data = tx ? {8'b1000_0001} : {8'b1100_0011};
	wire TxD_busy;
	async_transmitter async_transmitter_(
		.CLK50MHZ(CLK50MHZ),
		.TxD_start(sending),
		.TxD_data(tx_data),
		.TxD(TxD),
		.TxD_busy(TxD_busy)
	);	
	
	assign tick = sending ? ~TxD_busy : 1'b1;
	assign sended = ready;

endmodule
