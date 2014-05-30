module Edge_Detector(
    input  clk,
    input  signal,
    output pos,
    output neg
    );

   // Record last 2 states of signal

   wire [1:0] last2;
   Shiftreg #(
      .WIDTH(2)
   ) shiftreg_ (
           .CLKB(clk),
           .en(1'b1),
           .set(1'b0),
           .tick(1'b1),
           .rx(signal),
           .data_in(2'b11),
           .data_out(last2)
           );

   // Detect negative or positive edges

   assign pos = ( last2 == 2'b01 );
   assign neg = ( last2 == 2'b10 );

endmodule
