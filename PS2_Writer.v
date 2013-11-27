module PS2_Writer (
    input       clk,
    input       rst,
    input       wr_ps2,
    inout       ps2d,
    inout       ps2c,
    input       ps2c_neg,
    input [7:0] cmd,
    output      tx_idle,
    output      sended
);

   // Timer request to send

   wire        rts_timer_rst;
   wire        rts_timer_full;
   Counter #(
     .MAX(10000)
   ) Counter_rts_ (
     .CLKB(clk),
     .rst(rts_timer_rst),
     .en(1'b1),
     .sig(1'b1),
     .full(rts_timer_full)
   );

   wire        ps2d_out;
   wire        cmd_parity = ~(^cmd);
   wire [10:0] packet = { 1'b0, cmd, cmd_parity, 1'b1 };
   wire        start_sending;
   Serial #(
      .WIDTH(11)
   ) Serial_ (
      .CLKB(clk),
      .RST(rst),
      // serial module interface
      .tx(ps2d_out),
      .data_in(packet),
      .trig(start_sending),
      .ready(sended),
      .tick(ps2c_neg)
    );

   localparam [2:0]
   IDLE = 3'd0,
   WAIT_RTS = 3'd1,
   START_SENDING = 3'd2,
   SENDING = 3'd3,
   SENDED = 3'd4;

   reg [2:0] state = IDLE;
   always @(posedge clk)
     if(rst)
       state <= IDLE;
     else
       case(state)
         IDLE:
           if(wr_ps2)
             state <= WAIT_RTS;
         WAIT_RTS:
           if(rts_timer_full)
             state <= START_SENDING;
         START_SENDING:
           state <= SENDING;
         SENDING:
           if(sended)
             state <= SENDED;
         SENDED:
             state <= IDLE;
       endcase

   assign rts_timer_rst       = (state != WAIT_RTS);
   assign start_sending       = (state == START_SENDING);
   assign tx_idle             = (state == IDLE);
   assign ps2c                = (state == WAIT_RTS) ? 1'b0 : 1'bz;
   assign ps2d                = (state == START_SENDING || state == SENDING) ? ps2d_out : 1'bz;

endmodule
