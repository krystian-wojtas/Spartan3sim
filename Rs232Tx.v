`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:16 04/17/2013 
// Design Name: 
// Module Name:    Rs232Tx 
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
module Rs232Tx
#(
	parameter ClkFrequency = 50000000,	// 50MHz
	parameter Baud = 115200
) (
	input CLK50MHZ,
	input RST,
	input trig, // TxD_start,
	input [7:0] data, // TxD_data,
	output tx, //TxD,
	output ready // TxD_busy TODDO busy -> ready
);

	localparam WIDTH = 10;
	
	wire en;
	wire tick;
	BaudRateGenerator BaudRateGenerator(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.en(en),
		.tick(tick)
	);

	wire ready_;
	wire tx_;
//	wire [WIDTH-1:0] data_in = {1'b1, ~data, 1'b0};
//	wire [WIDTH-1:0] data_in = {10'b1__100_01110__1};
	wire [WIDTH-1:0] data_in = 10'b1_1001_1001_0; // "f" 1111_0110 f6
//	wire [WIDTH-1:0] data_in = 10'b1101_0110_00; // 1111_1001 f9
//	wire [WIDTH-1:0] data_in = 10'b0000_0000_00; // 
	Serial #(
		.WIDTH(WIDTH)
	) Serial_ (
		.CLKB(CLK50MHZ),
		.RST(RST),
		.tx(tx_),
		.rx(1'b0),
		.data_in( data_in ),
		.trig(trig),
		.ready(ready_),
		.tick(tick)
	);
	
	assign en = ~ready_;
	assign ready = ready_;
	assign tx = ~tx_;

endmodule
