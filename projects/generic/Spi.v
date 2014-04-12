module Spi #(
   parameter WIDTH=32
) (
   input RST,
   input CLKB,
   // spi lines
   output spi_sck,
   output spi_cs,
   input spi_miso,
   output spi_mosi,
   // spi module interface
   input [WIDTH-1:0] data_in,
   output [WIDTH-1:0] data_out,
   input trig,
   output ready,
   input clk,
   input tick
);

        wire ready_;
        assign ready = ready_;
        Serial #(
                .WIDTH(WIDTH)
        ) Serial_ (
                .CLKB(CLKB),
                .RST(RST),
                // serial module interface
                .rx(spi_miso),
                .tx(spi_mosi),
                .data_in(data_in),
                .data_out(data_out),
                .trig(trig),
                .ready(ready_),
                .tick(tick)
        );

        assign spi_cs = ready_;
        assign spi_sck = (~ready_) ? clk : 1'b0;
//      assign spi_mosi = (en) ? tx : 1'b1;

endmodule
