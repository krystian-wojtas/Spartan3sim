`timescale 1ns / 1ps

module serialfun(
	input 		 clk,
	input 		 RST,
	input 		 RxD,
	output 		 TxD
);

	wire RxD_data_ready;
	wire [7:0] RxD_data;
	Rs232Rx rx(.CLK50MHZ(clk), .RST(RST), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
	Rs232Tx tx(.CLK50MHZ(clk), .RST(RST), .TxD(TxD), .TxD_start(RxD_data_ready), .TxD_data(RxD_data));

endmodule
