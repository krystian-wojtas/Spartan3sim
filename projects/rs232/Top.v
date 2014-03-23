module Top(
    input        CLK50MHZ,
    input        RST,
    //           rs232
    input        RXD,
    output       TXD,
	//
	output 	DEBUG_TX,
	output 	DEBUG_RX
);

    Rs232Echo Rs232Echo_(
        .clk(CLK50MHZ),
        .RST(RST),
        .RxD(RXD),
        .TxD(TXD)
    );

   assign DEBUG_TX = TXD;
   assign DEBUG_RX = RXD;

endmodule
