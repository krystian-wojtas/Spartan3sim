module Top (
    input  CLK50MHZ,
    input  RST,
    // keyboard
    input  PS2_CLK1,
    input  PS2_DATA1,
    output [7:0] LED,
    // debug
    output DEBUG_A,
    output DEBUG_B
);

    wire [7:0] scancode;
    wire scan_ready;
    Keyboard keyboard_ (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .ps2_clk(PS2_CLK1),
        .ps2_data(PS2_DATA1),
        .scancode(scancode),
        .scan_ready(scan_ready)
    );

    Controller controller_ (
        .CLK50MHZ(CLK50MHZ),
        .RST(RST),
        .scancode(scancode),
        .scan_ready(scan_ready),
        .led(LED)
    );

    assign DEBUG_A = PS2_CLK1;
    assign DEBUG_B = PS2_DATA1;

endmodule
