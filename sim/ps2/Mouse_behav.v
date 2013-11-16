module Mouse_behav
#(
   parameter LABEL = "myszka",

   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0
) (
   inout ps2c,
   inout ps2d
);

   PS2 #(
      .LABEL(LABEL),
      .INFO1(1),
      .INFO2(1),
      .INFO3(1),
      .INFO4(1)
   ) ps2 (
      .ps2c(ps2c),
      .ps2d(ps2d)
   );

   // Zadanie czeka na nowiazanie komunikacji ze strony FPGA, odbiera komende i sprawdza czy dotyczy ona zmiany trybu pracy na strumieniowy

   task receive_streaming_cmd ();
      reg [7:0] cmd;
      begin

         // Odbierz komende

         ps2.receive_cmd( cmd );

      // Sprawdz odebrana komende

      // Jedyna spodziewana i obslugiwana jest 0xF4 oznaczajaca nakaz przelaczenia sie myszy w tryb strumieniowy

      // W trybie tym myszka przesyla powiadomienia o zdarzeniach bez potrzeby uprzedniego ciaglego odpytywania jej czy nowe zdarzenie zaszlo

      if( cmd !== 8'hF4 )
         if( ERROR )
             $display("%t\t BLAD %s Przeslana komenda %b (0x%h) rozni sie od oczekiwanej 1111_0100 (0xF4)", $time, LABEL, cmd, cmd);

      // Poinforumuj o zmianie trybu pracy

      if( INFO2 )
          $display("%t\t INFO2 %s Poprawnie zmieniono tryb pracy myszki na strumieniowy", $time, LABEL);

      end
   endtask

endmodule
