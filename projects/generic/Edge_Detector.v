`timescale 1ns / 1ps

module Edge_Detector(
    input  CLK50MHZ,
    input  line,
    output pos,
    output neg
    );

   // Record last 2 states of line

   wire [1:0]  line_last2;
   Shiftreg #(
      .WIDTH(2)
   ) ps2_clk_shiftreg_ (
           .CLKB(CLK50MHZ),
           .en(1'b1),
           .set(1'b0),
           .tick(1'b1),
           .rx(line),
           .data_in(2'b11),
           .data_out(line_last2)
           );

   // Detect negative or positive edges

   assign pos = ( line_last2 == 2'b01 );
   assign neg = ( line_last2 == 2'b10 );

endmodule