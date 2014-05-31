module ModClk #(
	parameter DIV=2
) (
	input CLK50MHZ,
	input rst,
	output clk_hf, //half filled 50%
	output neg_trig,
	output pos_trig
);

`include "log2.v"

   localparam WIDTH = log2(DIV);

   wire [WIDTH-1:0] cnt;
   Counter #(
      .MAX(DIV-1),
      .WIDTH(WIDTH)
   ) counter_ (
      .CLKB(CLK50MHZ),
      .en(1'b1),
      .sig(1'b1),
      .rst(rst),
      .cnt(cnt)
   );

   assign clk_hf = (cnt > (DIV-1)/2);
   assign neg_trig = (cnt == (DIV-1)%DIV);
   assign pos_trig= (cnt == (DIV-1)/2);

endmodule
