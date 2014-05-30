module TopTestBench
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o zadaniu zmiany koloru
   //
   parameter LOGLEVEL = 3,
   parameter LOGLEVEL_NEXT = 5,
   parameter LOGLEVEL_PREV = 5
) (
    // color control
    output BTN_NEXT,
    output BTN_PREV
);

   // Instancje przyciskow
   Set #(
      .LOGLEVEL(LOGLEVEL_NEXT),
      .N(1)
   ) set_next (
      .signals( BTN_NEXT )
   );
   Set #(
      .LOGLEVEL(LOGLEVEL_PREV),
      .N(1)
   ) set_prev (
      .signals( BTN_PREV )
   );

   initial begin
      // poczatkowo przyciski sa wylaczone
      set_next.low();
      set_prev.low();

      // nastepny kolor
      #500;
      if(LOGLEVEL >= 3)
         $display("%t\t INFO3 [ %m ] \t Zadanie nastepnego koloru", $time);
      set_next.high_during_and_restore( 250 );

      // nastepny kolor
      #17_000_000;
      if(LOGLEVEL >= 3)
         $display("%t\t INFO3 [ %m ] \t Zadanie nastepnego koloru", $time);
      set_next.high_during_and_restore( 250 );

      // poprzedni kolor
      #17_000_000;
      if(LOGLEVEL >= 3)
         $display("%t\t INFO3 [ %m ] \t Zadanie poprzedniego koloru", $time);
      set_prev.high_during_and_restore( 250 );
   end

endmodule
