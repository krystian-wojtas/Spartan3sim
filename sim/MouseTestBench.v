module MouseTestBench
#(
   parameter LABEL = " myszka",
   parameter PARENT_LABEL = ""
) (
   inout ps2c,
   inout ps2d
);

   Mouse_behav #(
      .TOPLABEL({PARENT_LABEL, LABEL}),
      .INFO1(1),
      .INFO2(1),
      .INFO3(1),
      .INFO4(1)
   ) mouse_behav (
      .ps2c(ps2c),
      .ps2d(ps2d)
   );

   initial begin
      mouse_behav.receive_streaming_cmd();

      #10_000;

      mouse_behav.click_right_button();

      #20_000;

      mouse_behav.click_left_button();
   end

endmodule
