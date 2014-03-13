module Controller (
    input      CLK50MHZ,
    input      RST,
    // vga interface
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    // color control
    input        next,
    input        prev,
    input [10:0] x,
    input [10:0] y,
    input displaying
);

   reg [2:0]      i = 1;
   always @(posedge CLK50MHZ)
      if(RST)
        i <= 1;
      else if(next)
        i <= i + 1;
      else if(prev)
        i <= i - 1;

    assign VGA_R = (displaying && i[0]) ? 4'hf : 4'h0;
    assign VGA_G = (displaying && i[1]) ? 4'hf : 4'h0;
    assign VGA_B = (displaying && i[2]) ? 4'hf : 4'h0;

endmodule
