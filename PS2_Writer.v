`timescale 1ns / 1ps


module PS2_Writer(
    input      CLK50MHZ,
    input      RST,
    input      cmd_trig,
    input      ready,
    output     start_sending
    );

   wire        low_clock_timer_full;
   wire        low_clock_timer_en;
   Counter #(
     .MAX(2600)
   ) counter_force_low_clock_timer (
     .CLKB(CLK50MHZ),
     .rst(RST),
     .en(low_clock_timer_en),
     .sig(1'b1),
     .full(low_clock_timer_full)
   );

   localparam [2:0]
    WAIT_CMD_TRIG = 3'd0,
    WAIT_FORCE_LOW_CLOCK = 3'd1,
    START_SENDING = 3'd2,
    SENDING = 3'd3,
    SENDED = 3'd4;

   reg [2:0] state = WAIT_CMD_TRIG;
   always @(posedge CLK50MHZ)
     if(RST)
       state <= WAIT_CMD_TRIG;
     else
       case(state)
         WAIT_CMD_TRIG:
           if(cmd_trig)
             state <= WAIT_FORCE_LOW_CLOCK;
         WAIT_FORCE_LOW_CLOCK:
           if(low_clock_timer_full)
             state <= START_SENDING;
         START_SENDING:
           state <= SENDING;
         SENDING:
           if(ready)
             state <= SENDED;
         SENDED:
             state <= WAIT_CMD_TRIG;
       endcase

   assign low_clock_timer_en  = (state == WAIT_FORCE_LOW_CLOCK);
   assign start_sending       = (state == START_SENDING);

endmodule
