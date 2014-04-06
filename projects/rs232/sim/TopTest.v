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
                .LOGLEVEL(3),
                .LOGLEVEL_BEHAV(5),
                .LOGLEVEL_BEHAV_RX(1),
                .LOGLEVEL_BEHAV_TX(1)
        ) rs232 (
                // polaczenie skrosne
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
