`timescale 1ns / 1ps

module PS2 (
    input wire        clk,
    input wire        rst,
    input wire        wr_ps2,
    inout wire        ps2d,
    inout wire        ps2c,
    input wire [7:0]  cmd,
    output wire [7:0] data_out,
    output wire       received,
    output wire       sended
);

   // Detect negative edge on input ps2 clock line

   wire ps2c_neg;
   Edge_Detector edge_detector_ps2clk (
      .CLK50MHZ(clk),
      .line(ps2c),
      .neg(ps2c_neg)
   );

   wire tx_idle;
   PS2_Writer PS2_Writer_ (
      .clk(clk),
      .rst(rst),
      .wr_ps2(wr_ps2),
      .ps2d(ps2d),
      .ps2c(ps2c),
      .ps2c_neg(ps2c_neg),
      .cmd(cmd),
      .tx_idle(tx_idle),
      .sended(sended)
   );

   PS2_Reader PS2_Reader_ (
      .clk(clk),
      .rst(rst),
      .ps2d(ps2d),
      .ps2c(ps2c),
      .ps2c_neg(ps2c_neg),
      .en(tx_idle),
      .received(received),
      .data_out(data_out)
   );

   // // Detect negative edge on input ps2 clock line

   // wire ps2_clk_negedge;
   // Edge_Detector edge_detector_ps2clk (
   //    .CLK50MHZ(CLK50MHZ),
   //    .line(ps2_clk),
   //    .neg(ps2_clk_negedge)
   // );

   // wire        trig;
   // wire        ready;
   // // wire        cmd_parity |= cmd; // TODO [7:0] ? ~(~cmd) ?
   // wire        cmd_parity = ~(~cmd); // TODO [7:0] ? ~(~cmd) ?
   // wire [10:0]   data_in = { 1'b0, cmd[7:0], cmd_parity, 1'b1 };
   // wire [9:0] data_out; // TODO 10?
   //  Serial #(
   //      .WIDTH(11)
   //  ) Serial_ (
   //      .CLKB(CLK50MHZ),
   //      .RST(RST),
   //      // serial module interface
   //      .rx(ps2_data),
   //      .tx(ps2_data_out),
   //      .data_in(data_in),
   //      .data_out(data_out),
   //      .trig(trig),
   //      .ready(ready),
   //      .tick(ps2_clk_negedge)
   //  );

   // // Get rid of start, stop and odd bits
   // assign scancode = data_out[9:2];

   // wire start_sending;
   // wire writer_busy;
   // PS2_Writer ps2_writer (
   //      .CLK50MHZ(CLK50MHZ),
   //      .RST(RST),
   //      .cmd_trig(cmd_trig),
   //      .ready(ready),
   //      .start_sending(start_sending),
   //      .ps2_clk_out(ps2_clk_out),
   //      .busy(writer_busy)
   //  );

   // // Writing has priority over reading
   // wire reader_rst = RST | writer_busy;
   // wire start_receiving;
   // PS2_Reader ps2_reader (
   //      .CLK50MHZ(CLK50MHZ),
   //      .RST(reader_rst),
   //      .ps2_clk_negedge(ps2_clk_negedge),
   //      .ready(ready),
   //      .start_receiving(start_receiving),
   //      .scan_ready(scan_ready)
   //  );

   // assign trig = start_receiving | start_sending;


   // localparam [2:0]
   //   READING = 3'd0,
   //   WRITE_CMD = 3'd1,
   //   READ_CMD_ANSWER = 3'd2;

   // reg [2:0] state = READING;
   // always @(posedge CLK50MHZ)
   //    if(RST)
   //      state <= READING;
   //    else
   //      case(state)
   //        READING:
   //          if(cmd_trig)
   //            state <= WRITE_CMD;
   //        WRITE_CMD:
   //          if(ready)
   //            state <= READ_CMD_ANSWER;
   //        READ_CMD_ANSWER:
   //          if(ready)
   //            state <= READING;
   //      endcase

   // assign ps2_clk_z  = (state != WRITE_CMD);
   // assign ps2_data_z = (state != WRITE_CMD);

endmodule
