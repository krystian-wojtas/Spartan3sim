//Listing 10.2
module ps2_rxtx
   (
    input wire clk, reset,
    input wire wr_ps2,
    inout wire ps2d, ps2c,
    input wire [7:0] din,
    output wire rx_done_tick, tx_done_tick,
    output wire [7:0] dout
   );


   // body
   //=================================================
   // filter and falling-edge tick generation for ps2c
   //=================================================
   reg [7:0] filter_reg;
   wire [7:0] filter_next;
   reg f_ps2c_reg;
   wire f_ps2c_next;
   wire fall_edge;
   always @(posedge clk, posedge reset)
   if (reset)
      begin
         filter_reg <= 0;
         f_ps2c_reg <= 0;
      end
   else
      begin
         filter_reg <= filter_next;
         f_ps2c_reg <= f_ps2c_next;
      end

   assign filter_next = {ps2c, filter_reg[7:1]};
   assign f_ps2c_next = (filter_reg==8'b11111111) ? 1'b1 :
                        (filter_reg==8'b00000000) ? 1'b0 :
                         f_ps2c_reg;
   assign fall_edge = f_ps2c_reg & ~f_ps2c_next;
   assign ps2c_neg = fall_edge;



   // signal declaration
   wire tx_idle;

   // body
   // instantiate ps2 receiver
  ps2_rx ps2_rx_unit
     (.clk(clk), .reset(reset), .rx_en(tx_idle),
      .ps2d(ps2d), .ps2c(ps2c),
      .rx_done_tick(rx_done_tick), .dout(dout));
   // wire [7:0] dout2;
   //  PS2_Reader PS2_Reader_ (
   //     .clk(clk),
   //     .rst(rst),
   //     .ps2d(ps2d),
   //     .ps2c_neg(ps2c_neg),
   //     .en(tx_idle),
   //     .received(rx_done_tick),
   //     .data_out(dout2)
   //  );

   // assign dout[0] = dout2[7];
   // assign dout[1] = dout2[6];
   // assign dout[2] = dout2[5];
   // assign dout[3] = dout2[4];
   // assign dout[4] = dout2[3];
   // assign dout[5] = dout2[2];
   // assign dout[6] = dout2[1];
   // assign dout[7] = dout2[0];


   // instantiate ps2 transmitter
   ps2_tx ps2_tx_unit
      (.clk(clk), .reset(reset), .wr_ps2(wr_ps2),
       .din(din), .ps2d(ps2d), .ps2c(ps2c),
       .tx_idle(tx_idle), .tx_done_tick(tx_done_tick));
   // localparam STRM=8'h2f; // stream command F4
   // PS2_Writer PS2_Writer_ (
   //    .clk(clk),
   //    .rst(reset),
   //    .wr_ps2(wr_ps2),
   //    .ps2d(ps2d),
   //    .ps2c(ps2c),
   //    .ps2c_neg(ps2c_neg),
   //    .cmd(STRM),
   //    .tx_idle(tx_idle),
   //    .sended(tx_done_tick)
   // );

endmodule
