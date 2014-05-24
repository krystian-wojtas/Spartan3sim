module TopTestBench (
    // keyboard
    input RST,
    output PS2_CLK1,
    output PS2_DATA1
);

   Keyboard_behav #(
      .LOGLEVEL(5)
   ) keyboard_behav (
      .clk(PS2_CLK1),
      .data(PS2_DATA1)
   );

   initial begin
      @(negedge RST);
      #10_000;

      keyboard_behav.send_char(8'b00001111);
   end

endmodule
