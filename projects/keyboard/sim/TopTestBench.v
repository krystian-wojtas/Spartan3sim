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

      keyboard_behav.send_scancode(8'b00001111);
      keyboard_behav.press_char("a");
      keyboard_behav.press_(keyboard_behav.SPACE);
      keyboard_behav.type_char("a");

      keyboard_behav.press_right_alt();
      keyboard_behav.type_char("b");
      keyboard_behav.release_right_alt();
   end

endmodule
