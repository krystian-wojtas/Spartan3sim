module PS2_Reader (
    input             clk,
    input             rst,
    input             ps2d,
    input             ps2c_neg,
    input             en,
    output            received,
    output [7:0]      data_out
);

   wire [10:0] packet;
   wire        start_receiving;
	wire received_;
   Serial #(
      .WIDTH(11)
   ) Serial_ (
      .CLKB(clk),
      .RST(rst),
      // serial module interface
      .rx(ps2d),
      .data_out(packet),
      .trig(start_receiving),
      .ready(received_),
      .tick(ps2c_neg)
    );

   localparam [2:0]
    IDLE = 3'd0,
    START_RECEIVING = 1'd1,
    RECEIVING = 3'd2,
    RECEIVED = 3'd3;

   reg [1:0]  state = IDLE;
   always @(posedge clk)
     if(rst)
       state <= IDLE;
     else
       case(state)
         IDLE:
           if(en & ps2c_neg)
             state <= START_RECEIVING;
         START_RECEIVING:
           state <= RECEIVING;
         RECEIVING:
           if(received_)
			    state <= IDLE;
//           if(sended)
//             state <= RECEIVED;
//         RECEIVED:
//             state <= IDLE;
       endcase

    assign       start_receiving = (state == START_RECEIVING);
    //assign       received = (state == RECEIVED);
	 assign       received = received_;
    assign       data_out = packet[8:1];

endmodule
