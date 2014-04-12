module Rotor_behav #(
   LOGLEVEL = 3,
   LOGLEVEL_CENTER = 3,
   LOGLEVEL_ROTA = 3,
   LOGLEVEL_ROTB = 3

) (
    // rotor control
    output ROT_CENTER,
    output ROT_A,
    output ROT_B
);

   // Instancje ustawiaczy pokretla
   Set #(
      .LOGLEVEL(LOGLEVEL_CENTER),
      .N(1)
   ) set_center (
      .signals( ROT_CENTER )
   );
   Set #(
      .LOGLEVEL(LOGLEVEL_ROTA),
      .N(1)
   ) set_rota (
      .signals( ROT_A )
   );
   Set #(
      .LOGLEVEL(LOGLEVEL_ROTB),
      .N(1)
   ) set_rotb (
      .signals( ROT_B )
   );

   task turn_left();
      begin
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Obracanie pokretla w lewo", $time);

          // rozpoczecie skretu w lewo
         set_rota.low_during( 250 );
         set_rotb.low_during( 300 );

         // konczenie skretu w lewo
         set_rota.high_during( 50 );
         set_rotb.high_during( 500 );

         if(LOGLEVEL >= 4)
            $display("%t\t INFO4 [ %m ] \t Obrocono pokretlo w lewo", $time);
      end
   endtask

   task turn_right();
      begin
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Obracanie pokretla w prawo", $time);

          // rozpoczecie skretu w prawo
         set_rotb.low_during( 250 );
         set_rota.low_during( 300 );

         // konczenie skretu w prawo
         set_rotb.high_during( 50 );
         set_rota.high_during( 500 );

         if(LOGLEVEL >= 4)
            $display("%t\t INFO4 [ %m ] \t Obrocono pokretla w prawo", $time);
      end
   endtask

   task press_center();
      begin
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wciskanie pokretla", $time);

         set_center.high_during( 400 );
         set_center.low_during( 200 );

         if(LOGLEVEL >= 4)
            $display("%t\t INFO4 [ %m ] \t Wcisnieto pokretlo", $time);
      end
   endtask

endmodule
