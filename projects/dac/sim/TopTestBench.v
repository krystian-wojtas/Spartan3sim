module TopTestBench #(
   LOGLEVEL      = 3,
   LOGLEVEL_LESS = 3,
   LOGLEVEL_MORE = 3,
   LOGLEVEL_SW   = 3,
   LOGLEVEL_RST  = 3
) (
   input 	 CLK50MHZ,
   input 	 RST,
   output  	 BTN_WEST,
   output  	 BTN_EAST,
   output  [3:0] SW
);

   // Instancje przyciskow
   Set #(
      .LOGLEVEL(LOGLEVEL_LESS),
      .N(1)
   ) set_less (
      .signals( BTN_EAST )
   );
   Set #(
      .LOGLEVEL(LOGLEVEL_MORE),
      .N(1)
   ) set_more (
      .signals( BTN_WEST )
   );
   Set #(
      .LOGLEVEL(LOGLEVEL_SW),
      .N(4)
   ) set_sw (
      .signals( SW )
   );

   // Monitorowanie resetu
   Monitor #(
      .LOGLEVEL(LOGLEVEL_RST),
      .N(1)
   ) monitor_rst (
      .signals( RST )
   );


   initial begin
      // Zainicjuj niskimi stanami przyciskow
      set_less.low();
      set_more.low();
      set_sw.low();

      // Poczekaj na zresetowanie ukladu
      monitor_rst.wait_for_low();
      #300;

      // Zwieksz
      set_more.high_during_and_restore(250);

      // Zwieksz
      #3800;
      set_more.high_during_and_restore(250);

      // Zmniejsz
      #3800;
      set_less.high_during_and_restore(250);

      // Ustaw zadana wartosc
      #3800;
      set_sw.state_during_and_restore(2000, 4'h1);
   end

endmodule
