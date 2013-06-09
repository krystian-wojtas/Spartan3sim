`timescale 1ns / 1ps

module serialfun(
	input CLK50MHZ,
	input RST,
	input BTN,
	input RxD,
	output TxD
);


//	wire RxD_data_ready;
//	wire [7:0] RxD_data;

//	async_receiver deserializer(.CLK50MHZ(CLK50MHZ), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
//	async_transmitter serializer(.CLK50MHZ(CLK50MHZ), .TxD(TxD), .TxD_start(RxD_data_ready), .TxD_data(RxD_data));
	
	wire ready;
	Rs232Tx Rs232Tx_ (
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		.tx(TxD),
		.trig(BTN),
		.data("f"),
		.ready(ready)
	);
	
endmodule