`timescale 1ns / 1ps

module async_transmitter
#(
	parameter FREQ = 50000000,	// 50MHz
	parameter BAUD = 115200		// 115 200 bounds/sec
) (
	input 	    CLK50MHZ,
	input 	    RST,
	input 	    TxD_start,
	input [7:0] TxD_data,
	output 	    TxD,
	output 	    TxD_busy
);

    wire 	    TxD_busy_neg;
    assign TxD_busy = ~ TxD_busy_neg;
    wire        BaudTick;
    BaudRateGenerator #(
        .FREQ(FREQ),
        .BAUD(BAUD)
    ) baud115200 (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .en(TxD_busy),
        .tick(BaudTick)
    );

    // output TxD line should be hight in idle
    wire 	tx_neg;
    assign TxD = ~ tx_neg;
    // concatenate START BIT and sending data reg in reverse order
    wire [8:0] 	rs_data = { 1'b1, ~TxD_data[0], ~TxD_data[1], ~TxD_data[2], ~TxD_data[3], ~TxD_data[4], ~TxD_data[5], ~TxD_data[6], ~TxD_data[7]  };
    Serial #(
        .WIDTH(9)
    ) Serial_ (
        .CLKB(CLK50MHZ),
        .RST(RST),
        // serial module interface
        .rx(1'b0),
        .tx(tx_neg),
        .data_in(rs_data),
        .trig(TxD_start),
        .ready(TxD_busy_neg),
        .tick(BaudTick)
    );

endmodule