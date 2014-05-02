module Keyboard(
    input  CLK50MHZ,
    input  RST,
    input  ps2_clk,
    input  ps2_data,
    output [7:0] scancode,
    output scan_ready
    );

   // Detect negative edge on input ps2 clock line

   wire [1:0]  ps2_clk_reg;
   Shiftreg #(
      .WIDTH(2)
   ) ps2_clk_shiftreg_ (
      .CLKB(CLK50MHZ),
      .en(1'b1),
      .set(1'b0),
      .tick(1'b1),
      .rx(ps2_clk),
      .data_in(2'b11),
      .data_out(ps2_clk_reg)
   );

   wire        ps2_clk_negedge = ( ps2_clk_reg == 2'b10 );
   wire        trig;
   wire        ready;
   wire [9:0] data_out;
   Serial #(
      .WIDTH(10)
   ) Serial_ (
      .CLKB(CLK50MHZ),
      .RST(RST),
      // serial module interface
      .rx(ps2_data),
      .data_in(10'b0),
      .data_out(data_out),
      .trig(trig),
      .ready(ready),
      .tick(ps2_clk_negedge)
   );

   // Get rid of start, stop and odd bits
   assign scancode = data_out[9:2];

   localparam [2:0]
    WAIT_STARTBIT = 3'd0,
    START_RECEVING = 3'd1,
    RECEIVING = 3'd2,
    RECEIVED = 3'd3;

   reg [1:0]  state = WAIT_STARTBIT;
   always @(posedge CLK50MHZ)
     if(RST)
       state <= WAIT_STARTBIT;
     else
       case(state)
         WAIT_STARTBIT:
           if(ps2_clk_negedge)
             state <= START_RECEVING;
         START_RECEVING:
             state <= RECEIVING;
         RECEIVING:
           if(ready)
             state <= RECEIVED;
         RECEIVED:
             state <= WAIT_STARTBIT;
       endcase

    assign       trig = (state == START_RECEVING);
    assign       scan_ready = (state == RECEIVED);

endmodule
