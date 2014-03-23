`timescale 1ns / 1ps

module TopTest(
    );

        wire CLK50MHZ;
        Clock Clock_(.clk(CLK50MHZ));

        wire RST;
        Reset Reset_(.RST(RST));

        wire RXD;
        wire TXD;
        Rs232 #(
                .LOGLEVEL(5)
        ) rs232 (
                .rx(TXD),
                .tx(RXD)
        );

        Top Top_ (
                .CLK50MHZ(CLK50MHZ),
                .RST(RST),
                .RXD(RXD),
                .TXD(TXD)
        );

endmodule
