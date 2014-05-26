`timescale 1ns / 1ps

module TopTest ();

    wire CLK50MHZ;
    Clock Clock_( .clk(CLK50MHZ) );

    wire RST;
    Reset Reset_( .RST(RST) );

   // keyboard interface
   wire  PS2_CLK1;
   wire  PS2_DATA1;
   TopTestBench TopTestBench_ (
      .RST(RST),
      .PS2_CLK1(PS2_CLK1),
      .PS2_DATA1(PS2_DATA1)
   );

   wire [7:0]  LED;
    Top Top_ (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // keyboard
        .PS2_CLK1(PS2_CLK1),
        .PS2_DATA1(PS2_DATA1),
        // leds
        .LED(LED)
    );

endmodule
