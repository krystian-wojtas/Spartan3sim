module Controller(
   input RST,
   input CLK50MHZ,
   // verilog module interface
   output     [11:0] data,
   output reg [3:0 ] address = 4'b1111,
   output reg [3:0 ] command = 4'b0011,
   output            dactrig,
   // control
   input             less,
   input             more,
   input             maxx,
   // leds
   output     [7:0 ] LED
);

   reg [7:0] d = 8'd0;
   always @(posedge CLK50MHZ)
      if(RST)       d <= 8'd0;
      else if(maxx) d <= 8'hff;
      else if(less) begin if( 0 < d ) d <= d - 1; end
      else if(more) begin if( ~&  d ) d <= d + 1; end

   assign data = { d, 4'h0 };
   assign LED = d;

   assign dactrig = (less || more || maxx);

endmodule
