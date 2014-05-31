module Keyboard (
    input  CLK50MHZ,
    input  RST,
    input  ps2_clk,
    input  ps2_data,
    output [7:0] scancode,
    output scan_ready
    );

   // Detect negative edge on input ps2 clock line
   wire    ps2_clk_negedge;
   Edge_Detector ps2_clk_negedge_detector (
      .clk(CLK50MHZ),
      .signal(ps2_clk),
      .neg(ps2_clk_negedge)
   );

   wire        trig;
   wire        ready;
   wire [9:0] frame;
   Serial #(
      // ignore 11th stop bit as first tick is not counted
      .WIDTH(10)
   ) Serial_ (
      .CLKB(CLK50MHZ),
      .RST(RST),
      // serial module interface
      .rx(ps2_data),
      .data_in(10'b0),
      .data_out(frame),
      .trig(trig),
      .ready(ready),
      .tick(ps2_clk_negedge)
   );

   // Get rid of start and odd bits, then reverse bit order of the data
   Bits_Reverse reversing (
      .orginal( frame[9:2] ),
      .reversed( scancode)
   );

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
