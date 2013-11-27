module Mouse_PS2 (
   input wire clk, rst,
   inout wire ps2d, ps2c,
   output wire [8:0] xm,
   output wire [2:0] btnm,
   output reg  m_done_tick
);

   // constant declaration
   localparam STRM=8'h2f; // stream command F4 in reverse

   // symbolic state declaration
   localparam [2:0]
      init1 = 3'b000,
      init2 = 3'b001,
      init3 = 3'b010,
      pack1 = 3'b011,
      pack2 = 3'b100,
      pack3 = 3'b101,
      done  = 3'b110;

   // signal declaration
   reg [2:0] state_reg, state_next;
   wire [7:0] rx_data;
   reg wr_ps2;
   wire rx_done_tick, tx_done_tick;
   reg [8:0] x_reg, x_next;
   reg [2:0] btn_reg, btn_next;


   // body
   // instantiation
   PS2 PS2_
      (.clk(clk), .rst(rst), .wr_ps2(wr_ps2),
       .cmd(STRM), .data_out(rx_data), .ps2d(ps2d), .ps2c(ps2c),
       .received(rx_done_tick),
       .sended(tx_done_tick));

   // body
   // FSMD state and data registers
   always @(posedge clk, posedge rst)
      if (rst)
         begin
            state_reg <= init1;
            x_reg <= 0;
            btn_reg <= 0;
         end
      else
         begin
            state_reg <= state_next;
            x_reg <= x_next;
            btn_reg <= btn_next;
         end

   // FSMD next-state logic
   always @*
   begin
      state_next = state_reg;
      wr_ps2 = 1'b0;
      m_done_tick = 1'b0;
      x_next = x_reg;
      btn_next = btn_reg;
      case (state_reg)
         init1:
            begin
               wr_ps2 = 1'b1;
               state_next = init2;
            end
         init2:  // wait for send to complete
            if (tx_done_tick)
               state_next = init3;
         init3:  // wait for acknowledge packet
            if (rx_done_tick)
               state_next = pack1;
         pack1:  // wait for 1st data packet
            if (rx_done_tick)
               begin
                  state_next = pack2;
                  x_next[8] = rx_data[4];
                  btn_next =  rx_data[2:0];
               end
         pack2:  // wait for 2nd data packet
            if (rx_done_tick)
               begin
                  state_next = pack3;
                  x_next[7:0] = rx_data;
               end
         pack3:  // wait for 3rd data packet
            if (rx_done_tick)
               begin
                  state_next = done;
               end
         done:
            begin
               m_done_tick = 1'b1;
               state_next = pack1;
            end
      endcase
   end
   // output
   assign xm = x_reg;
   assign btnm = btn_reg;

endmodule
