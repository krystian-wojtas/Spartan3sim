module Rs232Tx
#(
   parameter FREQ = 50000000,   // 50MHz
   parameter BAUD = 115200      // 115 200 bounds/sec
) (
   input       CLK50MHZ,
   input       RST,
   input       TxD_start,
   input [7:0] TxD_data,
   output      TxD,
   output      TxD_busy
);

   `include "../../generic/log2.v"
   localparam N = log2(BAUD);

   wire        BaudTick;
   wire        TxD_ready;
   BaudRateGenerator #(
        .INC( ((BAUD<<(N-4))+(FREQ>>5))/(FREQ>>4) ), // = 302
        .N(N)
     ) baud115200 (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .en(TxD_busy),
        .tick(BaudTick)
    );

    // START BIT, data, STOP BIT
    wire [9:0]  rs_data = { 1'b1, ~TxD_data, 1'b0 };
    // output TxD line should be high at idle
    wire        TxD_neg;
    Serial #(
        .WIDTH(10)
    ) Serial_ (
        .CLKB(CLK50MHZ),
        .RST(RST),
        // serial module interface
        .rx(1'b0),
        .tx(TxD_neg),
        .data_in(rs_data),
        .trig(TxD_start),
        .ready(TxD_ready),
        .tick(BaudTick)
    );

   assign TxD      = ~ TxD_neg;
   assign TxD_busy = ~ TxD_ready;

endmodule