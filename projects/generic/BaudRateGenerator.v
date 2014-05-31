module BaudRateGenerator
#(
   parameter INC = 100,
   parameter N = 10
) (
   input  CLK50MHZ,
   input  RST,
   input  en,
   output tick
);

   reg [N:0] acc = {N{1'b0}};
   always @(posedge CLK50MHZ)
      if(RST) acc <= {N{1'b0}};
      else if(en) acc <= acc[N-1:0] + INC;

   assign tick = acc[N];

endmodule
