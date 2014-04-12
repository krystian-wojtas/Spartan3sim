module Clock #(
   //DELAY 10ns - clock 50MHZ
   parameter DELAY = 10
) (
   output reg clk
);

   initial clk = 0;
   always #DELAY clk <= ~clk;

endmodule
