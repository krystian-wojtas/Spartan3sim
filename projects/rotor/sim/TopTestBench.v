module TopTestBench(
    input RST,
    // rotor control
    output ROT_CENTER,
    output ROT_A,
    output ROT_B
);

   // Instancje ustawiaczy pokrętłą
   Set #(
      .LOGLEVEL(5),
      .N(1)
   ) set_center (
      .signals( ROT_CENTER )
   );
   Set #(
      .LOGLEVEL(5),
      .N(1)
   ) set_rota (
      .signals( ROT_A )
   );
   Set #(
      .LOGLEVEL(5),
      .N(1)
   ) set_rotb (
      .signals( ROT_B )
   );

   task turn_left();
      begin
          // rozpoczecie skretu w lewo
         set_rota.low_during( 250 );
         set_rotb.low_during( 300 );

         // konczenie skretu w lewo
         set_rota.high_during( 50 );
         set_rotb.high_during( 500 );
      end
   endtask

   task turn_right();
      begin
          // rozpoczecie skretu w prawo
         set_rotb.low_during( 250 );
         set_rota.low_during( 300 );

         // konczenie skretu w prawo
         set_rotb.high_during( 50 );
         set_rota.high_during( 500 );
      end
   endtask

   task press_center();
      begin
         set_center.high_during( 400 );
         set_center.low_during( 200 );
      end
   endtask

   initial begin
      // jalowe stany poczatkowe
      set_center.low();
      set_rota.high();
      set_rotb.high();

      // poczatkowe opoznienie
      #300;

      // kilka ruchow
      turn_left();
      turn_left();

      press_center();

      turn_right();
    end

endmodule
