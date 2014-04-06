module Counter #(
        parameter MAX=4,
        parameter K=1,
        parameter DELAY=0
) (
        input         CLKB,
        // counter
        input         en, // if high counter is enabled and is counting
        input         rst, // set counter register to zero
        input         sig, // signal which is counted
// TODO log2
        output [10:0] cnt,
        output reg    full // one pulse if counter is full
);

`include "log2.v"

        reg [log2(MAX):0] counter_reg = 0;
        always @(posedge CLKB)
                if(rst)
                        counter_reg <= 0;
                else if(en & sig)
                        if(counter_reg < MAX)
                                counter_reg <= counter_reg + K;
                        else
                                counter_reg <= DELAY;

        //assign full = (counter_reg == MAX-1);
        always @*
                full = (counter_reg == MAX);

        assign cnt = counter_reg;

endmodule
