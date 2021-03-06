`timescale 1ns / 1ps

module TopTest ();

    wire CLK50MHZ;
    Clock Clock_( .clk(CLK50MHZ) );

    wire RST;
    Reset Reset_( .RST(RST) );

    // vga interface
    wire [3:0] VGA_R;
    wire [3:0] VGA_G;
    wire [3:0] VGA_B;
    wire       VGA_HSYNC;
    wire       VGA_VSYNC;
    Vga_Behav #(
       .INFO1(1),
       .INFO2(1),
       .INFO3(1),
       .INFO4(1)
    ) vga_behav_ (
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B),
        .vga_hsync(VGA_HSYNC),
        .vga_vsync(VGA_VSYNC)
    );

    // color control
    wire       BTN_NEXT;
    wire       BTN_PREV;
    TopTestBench TopTestBench_ (
        .BTN_NEXT(BTN_NEXT),
        .BTN_PREV(BTN_PREV)
    );

    Top Top_ (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        // vga interface
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HSYNC(VGA_HSYNC),
        .VGA_VSYNC(VGA_VSYNC),
        // color control
        .BTN_NEXT(BTN_NEXT),
        .BTN_PREV(BTN_PREV)
    );

endmodule
