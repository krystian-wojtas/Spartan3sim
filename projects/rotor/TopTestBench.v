module TopTestBench(
    input RST,
    // rotor control
    output reg ROT_CENTER = 1'b0,
    output reg ROT_A = 1'b1,
    output reg ROT_B = 1'b1
);

    initial begin

       // rozpoczecie skretu w lewo
        #300;
        ROT_A = 1'b0;
        #250;
        ROT_B = 1'b0;

        // konczenie skretu w lewo
        #300;
        ROT_A = 1'b1;
        #50;
        ROT_B = 1'b1;

        // rozpoczenie skretu w prawo
        #500;
        ROT_B = 1'b0;
        #250;
        ROT_A = 1'b0;

        // konczenie skretu w prawo
        #300;
        ROT_B = 1'b1;
        #50;
        ROT_A = 1'b1;

    end

endmodule
