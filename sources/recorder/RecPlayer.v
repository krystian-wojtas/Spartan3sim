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
	output send_busy,
	output reg TxD
    );
	 
	wire reading;
	wire current;
	RecBuf #(
		.N(N)
	) RecBuf_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(signal),
		.recording(recording),
		// read
		.reading(reading),
		.rec_full(rec_full),
		.current(current)
	);
	
	async_transmitter async_transmitter_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.TxD_start(sending),
		.TxD_data(current),
		.TxD(TxD),
		.TxD_busy(send_busy)
	);

endmodule
