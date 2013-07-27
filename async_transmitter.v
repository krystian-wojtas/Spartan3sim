`timescale 1ns / 1ps
// RS-232 TX module
// (c) fpga4fun.com KNJN LLC - 2003, 2004, 2005, 2006

//`define DEBUG   // in DEBUG mode, we output one bit per clock cycle (useful for faster simulations)

module async_transmitter
#(
	parameter FREQ = 50000000,	// 50MHz
	parameter BAUD = 115200
) (
	input CLK50MHZ,
	input TxD_start,
	input [7:0] TxD_data,
	output reg TxD,
	output TxD_busy
);




    // Baud generator
    wire        BaudTick;
    BaudRateGenerator
    #(
        .FREQ(FREQ),
        .BAUD(BAUD)
    ) baud115200 (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .en(TxD_busy),
        .tick(BaudTick)
    );


	localparam WIDTH = 8;
	reg [7:0] shiftreg = 8'd0;
	reg [3:0] shiftreg_idx = 4'd0;
	wire shiftreg_empty = shiftreg_idx[3];

	localparam [1:0] 	TRIG_WAITING = 2'd0,
											START_BIT = 2'd1,
											SENDING = 2'd2,
											STOP_BIT = 2'd3;

	// Transmitter state machine
	reg [1:0] state = TRIG_WAITING;
	wire TxD_ready = (state==TRIG_WAITING);
	assign TxD_busy = ~TxD_ready;

	always @(posedge CLK50MHZ)
	case(state)
		TRIG_WAITING:
			if(TxD_start)
				state <= START_BIT;
		START_BIT:
			if(BaudTick)
				state <= SENDING;
		SENDING:
			if(shiftreg_empty)
				state <= STOP_BIT;
		STOP_BIT:
			state <= TRIG_WAITING;
		default:
			state <= TRIG_WAITING;
	endcase


	always @(posedge CLK50MHZ) begin
		case(state)
			TRIG_WAITING: begin
				shiftreg_idx <= 0;
			end
			SENDING:
				if(BaudTick)
					if(shiftreg_idx <= WIDTH+1)
						shiftreg_idx <= shiftreg_idx + 1;
					else
						shiftreg_idx <= 0;
		endcase
	end


	always @(posedge CLK50MHZ) begin
		case(state)
			TRIG_WAITING:
				if(TxD_ready & TxD_start)
					shiftreg <= TxD_data;
			SENDING:
				if(BaudTick)
					shiftreg <= { 1'b0, shiftreg[WIDTH-1:1] };
		endcase
	end


	always @* begin
		case(state)
			START_BIT:
				TxD = 1'b0;
			SENDING:
				TxD = shiftreg[0];
			default:
				TxD = 1'b1;
		endcase
	end


endmodule