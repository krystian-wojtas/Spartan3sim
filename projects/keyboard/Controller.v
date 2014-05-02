module Controller(
  input 	   CLK50MHZ,
  input 	   RST,
  input [7:0] 	   scancode,
  input 	   scan_ready,
  output reg [7:0] led = 8'b0011_1100
);

    always @(posedge CLK50MHZ)
        if(RST)
          led <= 8'b0111_1110;
        else if( scan_ready )
          led <= scancode;

endmodule
