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
		parameter N = 1000
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
	 
	wire current_data;
	RecBuf #(
		.N(N)
	) RecBuf_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(signal),
		.recording(recording),
		.rec_full(rec_full),
		// read
		.reading(sending),
		.read_full(sended),
		.current(current_data)
	);
	
	async_transmitter async_transmitter_(
		.CLK50MHZ(CLK50MHZ),
		.TxD_start(sending),
		.TxD_data(current_data),
		.TxD(TxD)
	);

endmodule
