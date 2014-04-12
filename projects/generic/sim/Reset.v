module Reset #(
   parameter DELAY = 40
) (
    output reg RST
);

   initial begin
      RST = 0;
      #10;
      RST = 1;
      #DELAY;
      RST = 0;
   end

endmodule
