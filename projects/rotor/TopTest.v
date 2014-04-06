`timescale 1ns / 1ps

module TopTest();

    wire CLK50MHZ;
    Clock Clock_(.clk(CLK50MHZ));

    wire RST;
    Reset Reset_(.RST(RST));

    wire ROT_CENTER;
    wire ROT_A;
    wire ROT_B;
    wire [7:0] LED;
    Top Top_(
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // rotor control
        .ROT_CENTER(ROT_CENTER),
        .ROT_A(ROT_A),
        .ROT_B(ROT_B),
        // debug leds
        .LED(LED)
    );

    TopTestBench TopTestBench_(
        .RST(RST),
        // rotor control
        .ROT_CENTER(ROT_CENTER),
        .ROT_A(ROT_A),
        .ROT_B(ROT_B)
    );

endmodule
