`timescale 1ns / 1ps

module PS2_Cmd(
    input  CLK50MHZ,
    input  RST,
    input  ps2_clk,
    input  ps2_data,
    output [7:0] scancode,
    output scan_ready
    );

   // Detect negative edge on input ps2 clock line

   wire ps2_clk_negedge;
   Edge_Detector edge_detector_ps2clk (
      .CLK50MHZ(CLK50MHZ),
      .line(ps2_clk),
      .neg(ps2_clk_negedge)
   );

   PS2_Reader ps2_reader (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .ps2_clk_negedge(ps2_clk_negedge),
        .scancode(scancode),
        .scan_ready(scan_ready)
    );

endmodule
