module Bits_Reverse #(
   parameter WIDTH = 8
) (
   input  [WIDTH-1:0] orginal,
   output [WIDTH-1:0] reversed
);

   // Reverse bits order
   genvar      i;
   generate
      for(i=0; i<WIDTH; i=i+1)
      begin
	 assign reversed[i] = orginal[WIDTH-1-i];
      end
   endgenerate

endmodule
