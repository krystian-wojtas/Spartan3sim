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
	wire a_sended;
	wire a_txd;
	RecPlayer rota_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(ROT_A),
		.recording(a_recording),
		.rec_full(a_rec_full),
		// send
		.sending(a_sending),
		.sended(a_sended),
		.TxD(a_txd)
	);
	
	// ROT_B
	// rec
	wire b_recording;
	wire b_rec_full;
	// send
	wire b_sending;
	wire b_sended;
	wire b_txd;
	RecPlayer rotb_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(ROT_B),
		.recording(b_recording),
		.rec_full(b_rec_full),
		// send
		.sending(b_sending),
		.sended(b_sended),
		.TxD(b_txd)
	);
	
	// ROT_CENTER
	// rec
	wire c_recording;
	wire c_rec_full;
	// send
	wire c_sending;
	wire c_sended;
	wire c_txd;
	RecPlayer #(
//		.WIDTH(1000)
		.WIDTH(3)
	) rotc_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// rec
		.signal(ROT_CENTER),
		.recording(c_recording),
		.rec_full(c_rec_full),
		// send
		.sending(c_sending),
		.sended(c_sended),
		.TxD(c_txd)
	);
	
	wire rec_full = a_rec_full || b_rec_full || c_rec_full;
	wire sended = a_sended || b_sended || c_sended;
//	assign TXD = a_txd || b_txd || c_txd; // TODO
	assign TXD = c_txd;
	
	
	localparam [1:0]	SIG_WAITING			= 3'd0,
										RECORDING	= 3'd1,
										SENDING		 	= 3'd2;
	
	reg [1:0] state = SIG_WAITING;
	always @(posedge CLK50MHZ)
		if(RST)  state <= SIG_WAITING;
		else
			case(state)
				SIG_WAITING:
					if(ROT_CENTER) // || ROT_A || ROT_B
						state <= RECORDING;
				RECORDING:
					if(c_rec_full) // TODO rec_full
						state <= SENDING;
				SENDING:
					if(c_sended) // TODO sended
						state <= SIG_WAITING;
			endcase
		
	assign a_recording	= (state == RECORDING);
	assign b_recording	= (state == RECORDING);
	assign c_recording	= (state == RECORDING);
	assign a_sending		= (state == SENDING);
	assign b_sending		= (state == SENDING);
	assign c_sending		= (state == SENDING);
						

endmodule
