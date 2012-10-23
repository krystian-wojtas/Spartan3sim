`timescale 1ns / 1ps

module serialfun(clk, RxD, TxD, GPout, GPin);
input clk;

input RxD;
output TxD;

output [7:0] GPout;
input [7:0] GPin;

///////////////////////////////////////////////////
wire RxD_data_ready;
wire [7:0] RxD_data;
async_receiver deserializer(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));

reg [7:0] GPout;
always @(posedge clk) if(RxD_data_ready) GPout <= RxD_data;

///////////////////////////////////////////////////
async_transmitter serializer(.clk(clk), .TxD(TxD), .TxD_start(RxD_data_ready), .TxD_data(GPout));

endmodule