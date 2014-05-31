module Counter #(
        parameter MAX=4,
        parameter K=1,
        parameter DELAY=0,
        parameter WIDTH=32
) (
        input         CLKB,
        // counter
        input         en,  // if high, then counter is enabled and is counting
        input         rst, // set counter register to zero
        input         sig, // signal which is counted
        output reg [WIDTH-1:0] cnt = {WIDTH{1'b0}},
        output        full // one pulse if counter is full
);

   always @(posedge CLKB)
      if(rst)
         cnt <= 0;
      else if(en & sig)
         if(cnt < MAX)
            cnt <= cnt + K;
         else
            cnt <= DELAY;

   assign full = (cnt == MAX);

endmodule
