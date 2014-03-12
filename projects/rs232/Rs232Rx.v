`timescale 1ns / 1ps

module Rs232Rx
#(
        parameter FREQ = 50000000,      // 50MHz
        parameter BAUD = 115200         // 115 200 bounds/sec
) (
        input        CLK50MHZ,
        input        RST,
        input        RxD,
        output [7:0] RxD_data,
        output       RxD_data_ready
);

`include "../../generic/log2.v"

   localparam N = log2(BAUD);

   wire              receving;
   wire              BaudTick3;
   BaudRateGenerator #(
        // 3 times oversampling
        .INC( ((BAUD*3<<(N-7))+(FREQ>>8))/(FREQ>>7) ), // = 2416
        .N(N)
    ) baud_115200x3 (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .en(receving),
        .tick(BaudTick3)
    );

    wire        BaudTick;
    BaudRateGenerator #(
        .INC( ((BAUD<<(N-4))+(FREQ>>5))/(FREQ>>4) ), // = 302
        .N(N)
    ) baud_115200 (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .en(receving),
        .tick(BaudTick)
    );

   wire [2:0]   rx3;
   Shiftreg #(
      .WIDTH(3)
   ) rx3_shitftreg (
           .CLKB(CLK50MHZ),
           .en(1'b1),
           .set(1'b0),
           .tick(BaudTick3),
           .rx(RxD),
           .data_in(3'b000),
           .data_out(rx3)
           );

   // Vote for rx value
   wire                    rx =
                           rx3 != 3'b000 &&
                           rx3 != 3'b001 &&
                           rx3 != 3'b010 &&
                           rx3 != 3'b100;
   wire                    trig;
   wire                    ready;
   wire [9:0]              data_out;
   Serial #(
        .WIDTH(10)
    ) Serial_ (
        .CLKB(CLK50MHZ),
        .RST(RST),
        // serial module interface
        .rx(rx),
        .data_in(10'b0),
        .data_out(data_out),
        .trig(trig),
        .ready(ready),
        .tick(BaudTick)
    );

   // get rid of START and STOP bits
   assign RxD_data = data_out[8:1];

   localparam [1:0]
     WAIT_STARTBIT = 3'd0,
     START_RECEVING = 3'd1,
     RECEVING = 3'd2,
     RECEIVED = 3'd3;

   reg [2:0]               state = WAIT_STARTBIT;
   always @(posedge CLK50MHZ)
     if(RST)
       state <= WAIT_STARTBIT;
     else
       case(state)
         WAIT_STARTBIT:
           if(~RxD)
             state <= START_RECEVING;
         START_RECEVING:
             state <= RECEVING;
         RECEVING:
           if(ready)
             state <= RECEIVED;
         RECEIVED:
             state <= WAIT_STARTBIT;
       endcase

   assign       trig = (state == START_RECEVING);
   assign       RxD_data_ready = (state == RECEIVED);
   assign       receving = (state == RECEVING);

endmodule