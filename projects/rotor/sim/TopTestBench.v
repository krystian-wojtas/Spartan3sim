module TopTestBench #(
   LOGLEVEL = 3,
   LOGLEVEL_BEHAV = 3,
   LOGLEVEL_BEHAV_CENTER = 3,
   LOGLEVEL_BEHAV_ROTA = 3,
   LOGLEVEL_BEHAV_ROTB = 3
) (
   // rotor control
   output ROT_CENTER,
   output ROT_A,
   output ROT_B
);

   Rotor_behav #(
      .LOGLEVEL(LOGLEVEL_BEHAV),
      .LOGLEVEL_CENTER(LOGLEVEL_BEHAV_CENTER),
      .LOGLEVEL_ROTA(LOGLEVEL_BEHAV_ROTA),
      .LOGLEVEL_ROTA(LOGLEVEL_BEHAV_ROTB)
   ) rotor_behav (
      .ROT_CENTER(ROT_CENTER),
      .ROT_A(ROT_A),
      .ROT_B(ROT_B)
   );


   initial begin
      // jalowe stany poczatkowe
      rotor_behav.set_center.low();
      rotor_behav.set_rota.high();
      rotor_behav.set_rotb.high();

      // poczatkowe opoznienie
      #300;

      if(LOGLEVEL >= 3)
         $display("%t\t INFO3 [ %m ] \t Poczatek symulacji", $time);

      // kilka ruchow
      rotor_behav.turn_left();
      rotor_behav.turn_left();
      rotor_behav.press_center();
      rotor_behav.turn_right();

      if(LOGLEVEL >= 4)
         $display("%t\t INFO3 [ %m ] \t Koniec symulacji", $time);
    end

endmodule
