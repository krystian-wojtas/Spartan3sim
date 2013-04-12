`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:12 04/11/2013 
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
	// signals
	input ROT_CENTER,
	input ROT_A,
	input ROT_B,
	// rs232
	output TXD,
	// led debug
		output [7:0] LED
);
	 
	
	// ROT_A
	// rec
	wire a_recording;
	wire a_rec_full;
	// send
	wire a_sending;
	wire a_send_busy;
	RecPlayer rota_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(ROT_A),
		.recording(a_recording),
		.rec_full(a_rec_full),
		// send
		.sending(a_sending),
		.send_busy(a_send_busy),
		.TxD(TxD)
	);
	
	// ROT_B
	// rec
	wire b_recording;
	wire b_rec_full;
	// send
	wire b_sending;
	wire b_send_busy;
	RecPlayer rotb_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(ROT_B),
		.recording(b_recording),
		.rec_full(b_rec_full),
		// send
		.sending(b_sending),
		.send_busy(b_send_busy),
		.TxD(TxD)
	);
	
	// ROT_CENTER
	// rec
	wire c_recording;
	wire c_rec_full;
	// send
	wire c_sending;
	wire c_send_busy;
	RecPlayer rotc_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(ROT_CENTER),
		.recording(c_recording),
		.rec_full(c_rec_full),
		// send
		.sending(c_sending),
		.send_busy(c_send_busy),
		.TxD(TxD)
	);
	
	
	

endmodule
