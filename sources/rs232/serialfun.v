`timescale 1ns / 1ps

module serialfun(
	input clk,
	input RxD,
	output TxD,
	output reg [7:0] debug = 8'haa
);


	wire RxD_data_ready;
	wire [7:0] RxD_data;
	always @(posedge clk) if(RxD_data_ready) debug <= RxD_data;

	async_receiver deserializer(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
	async_transmitter serializer(.CLK50MHZ(clk), .TxD(TxD), .TxD_start(RxD_data_ready), .TxD_data(RxD_data));

endmodule