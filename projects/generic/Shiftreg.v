module Shiftreg #(
   parameter WIDTH=8
) (
   input  CLKB,
   // shiftreg
   input  en,
   input  set,  // setting shiftreg value to data_in if spi_trig occurs
   input  tick, // register shifting is syncronized with tick signal
   input  rx,
   output tx,
   input  [WIDTH-1:0] data_in,
   output [WIDTH-1:0] data_out
);

   reg [WIDTH-1:0] shiftreg = {WIDTH{1'b0}};
   always @(posedge CLKB) begin
      if(set)
         shiftreg <= data_in;
      else if(en & tick)
	 shiftreg <= { shiftreg[WIDTH-2:0], rx };
   end

   assign tx = shiftreg[WIDTH-1];
   assign data_out = shiftreg;

endmodule
