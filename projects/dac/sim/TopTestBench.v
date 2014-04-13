module TopTestBench #(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      bledy
   // LOGLEVEL = 2
   //      ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o wciskaniu przyciskow
   // LOGLEVEL = 4
   //      informuje o rozpoczynaniu symulacji
   // LOGLEVEL = 5
   //      informuje o oczekiwaniu na reset
   parameter LOGLEVEL      = 5,
   parameter LOGLEVEL_LESS = 3,
   parameter LOGLEVEL_MORE = 3,
   parameter LOGLEVEL_SW   = 3,
   parameter LOGLEVEL_RST  = 3
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
      if( LOGLEVEL >= 4 )
         $display("%t\t INFO4\t [ %m ] \t Rozpoczynanie symulacji, ustawianie przyciskow na poczatkowe stany rozwarcia", $time);
      set_less.low();
      set_more.low();
      set_sw.low();

      // Poczekaj na zresetowanie ukladu
      if( LOGLEVEL >= 5 )
         $display("%t\t INFO5\t [ %m ] \t Oczekiwanie na zresetowanie ukladu", $time);
      monitor_rst.wait_for_low();
      #300;

      // Zwieksz
      if( LOGLEVEL >= 3 )
         $display("%t\t INFO3\t [ %m ] \t Zwiekszanie napiecia", $time);
      set_more.high_during_and_restore(250);

      // Zwieksz
      #3800;
      if( LOGLEVEL >= 3 )
         $display("%t\t INFO3\t [ %m ] \t Zwiekszanie napiecia", $time);
      set_more.high_during_and_restore(250);

      // Zmniejsz
      #3800;
      if( LOGLEVEL >= 3 )
         $display("%t\t INFO3\t [ %m ] \t Zmniejszanie napiecia", $time);
      set_less.high_during_and_restore(250);

      // Ustaw zadana wartosc
      #3800;
      if( LOGLEVEL >= 3 )
         $display("%t\t INFO3\t [ %m ] \t Ustawianie wybranej wartosci", $time);
      set_sw.state_during_and_restore(2000, 4'h1);
   end

endmodule
