`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    19:17:46 08/18/2013
// Design Name:
// Module Name:    TopTest
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module TopTest ();

    wire CLK50MHZ;
    Clock Clock_( .clk(CLK50MHZ) );

    wire RST;
    Reset Reset_( .RST(RST) );

   // keyboard interface
   wire  PS2_CLK1;
   wire  PS2_DATA1;
   wire  btn_kbd_rst;
   wire  btn_kbd_echo;
   TopTestBench TopTestBench_ (
      .RST(RST),
      .PS2_CLK1(PS2_CLK1),
      .PS2_DATA1(PS2_DATA1),
      .btn_kbd_rst(btn_kbd_rst),
      .btn_kbd_echo(btn_kbd_echo)
   );

   wire [7:0]  leds;
    Top Top_ (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // keyboard
        .PS2_CLK1(PS2_CLK1),
        .PS2_DATA1(PS2_DATA1),
        // user interface
        .BTN_NORH(btn_kbd_rst),
        .BTN_PREV(btn_kbd_echo),
        .LED(leds)
    );

endmodule
