module Debouncer (
   input   clk,
   input   rst, // set counter register to zero
   input   sig, // signal which is debouncing
   output  full // one pulse if counter is full
);

   Counter #(
`ifdef SIM
      .MAX(10)
`else
      .MAX(10_000_000)
`endif
   ) counter_ (
      .CLKB(clk),
      .en(1'b1),
      .rst(rst),
      .sig(sig),
      .full(full)
   );

endmodule
