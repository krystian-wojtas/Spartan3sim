module Controller(
         input clk,
         input rst,
         // tick inputs
         input center,
         input left,
         input right,
         //  leds
         output reg [7:0] leds = 8'b0001_0000
    );

    always @(posedge clk)
        if(rst)           leds <= 8'b0010_0000;
        else if(center)   leds[0] <= ~leds[0];
        else if(left)     leds <= { leds[6:0], leds[7] };
        else if(right)    leds <= { leds[0], leds[7:1] };

endmodule
