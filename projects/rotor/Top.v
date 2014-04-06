module Top (
    input        CLK50MHZ,
    input        RST,
    // rotor control
    input        ROT_CENTER,
    input        ROT_A,
    input        ROT_B,
    // leds
    output [7:0] LED,
    // debug
    output       DEBUG_A,
    output       DEBUG_B
    );

    wire center;
    Debouncer debouncer_next (
        .clk(CLK50MHZ),
        .rst(RST),
        .sig(ROT_CENTER),
        .full(center)
    );

    wire left;
    wire right;
    Rotor Rotor_ (
        .clk(CLK50MHZ),
        .rst(RST),
        // inputs
        .rota(ROT_A),
        .rotb(ROT_B),
        // outputs direction
        .left(left),
        .right(right)
    );

    Controller Controller_(
        .clk(CLK50MHZ),
        .rst(RST),
        // tick inputs
        .center(center),
        .left(left),
        .right(right),
        // debug
        .leds(LED)
    );

    assign DEBUG_A = ROT_A;
    assign DEBUG_B = ROT_B;

endmodule
