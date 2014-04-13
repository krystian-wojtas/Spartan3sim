`timescale 1ns / 1ps

module TopTest();

   wire CLK50MHZ;
   Clock Clock_(.clk(CLK50MHZ));

   wire RST;
   Reset Reset_(.RST(RST));

   wire SPI_SCK;
   wire DAC_CS;
   wire DAC_CLR;
   wire SPI_MOSI;
   wire DAC_OUT;
   DacLTC2624Behav #(
      .LOGLEVEL(5),
      .LOGLEVEL_CLR(3)
   ) DacLTC2624Behav_(
      .SPI_SCK(SPI_SCK),
      .DAC_CS(DAC_CS),
      .DAC_CLR(DAC_CLR),
      .SPI_MOSI(SPI_MOSI),
      .DAC_OUT(DAC_OUT)
   );

   wire BTN_WEST;
   wire BTN_EAST;
   wire [3:0] SW;
   wire [7:0] LED;
   Top Top_(
      .CLK50MHZ(CLK50MHZ),
      .RST(RST),
      //dac
      .SPI_MOSI(SPI_MOSI),
      .SPI_SCK(SPI_SCK),
      .DAC_CS(DAC_CS),
      .DAC_CLR(DAC_CLR),
      .DAC_OUT(DAC_OUT),
      //control
      .BTN_WEST(BTN_WEST),
      .BTN_EAST(BTN_EAST),
      .SW(SW),
      .LED(LED)
   );

   TopTestBench #(
      .LOGLEVEL(5),
      .LOGLEVEL_LESS(0),
      .LOGLEVEL_MORE(0),
      .LOGLEVEL_SW(0),
      .LOGLEVEL_RST(0)
   ) TopTestBench_ (
      .CLK50MHZ(CLK50MHZ),
      .RST(RST),
      .BTN_WEST(BTN_WEST),
      .BTN_EAST(BTN_EAST),
      .SW(SW)
   );

endmodule
