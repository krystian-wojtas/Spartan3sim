`timescale 1ns / 1ps

module TopTest();

    wire clk;
    Clock Clock_(.clk(clk));

    wire rst;
    Reset Reset_(.RST(rst));

    wire [7:0] outport;
    Top Top_(
        .clk(clk),
        .rst(rst),
        .outport(outport)
    );

endmodule
