module Keyboard_behav
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //
   // LOGLEVEL = 4
   //
   // LOGLEVEL = 5
   //
   // LOGLEVEL = 6
   //
   parameter LOGLEVEL=3
) (
   output  clk,
   output  data
);

   // czas polowy okresu
   localparam HALF_PERIOD = 40_000;
   // opoznienie
   localparam QUARTER_PERIOD = HALF_PERIOD / 2;

   Set #(
      // .LOGLEVEL(LOGLEVEL_TX),
      .N(1)
   ) set_clk (
      .signals( clk )
   );

   Set #(
      // .LOGLEVEL(LOGLEVEL_TX),
      .N(1)
   ) set_data (
      .signals( data )
   );

   // Stany jalowe sa wysokie
   initial begin
      set_clk.high();
      set_data.high();
   end

   // Zadanie wysyla przekazany bajt wraz z poprzedajacym bitem startu i nastepujacym stopu
   task send_char
   (
      input [7:0] char
   );
      integer     i;
      reg 	  odd;
      reg [8:0]   frame;
      begin

         // Zalogowanie poczatku transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wysylanie bajtu '%b' (0x %h) (dec %d) (ascii %s)", $time, char, char, char, char);

         // Start bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Rozpoczecie transmisji, start bit 0", $time);
         set_data.low_during( QUARTER_PERIOD );

	 set_clk.low_during( HALF_PERIOD );

         set_clk.high_during( QUARTER_PERIOD );

	 odd = ~^ char;
	 // odd = 1'b0;
	 frame = { odd, char[7:0] };

         // Przekazany bajt
         for(i=0; i < 9; i=i+1) begin

            set_data.state_during( QUARTER_PERIOD, frame[i] );

            set_clk.low_during( HALF_PERIOD );

            set_clk.high_during( QUARTER_PERIOD );

            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] \t Wyslano bit nr %d o wartosci %b", $time, i, char[i]);
         end

         set_data.high_during( QUARTER_PERIOD );

         set_clk.low_during( HALF_PERIOD );

         set_clk.high_during( QUARTER_PERIOD );

         // Stop bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie transmisji, stop bit 1", $time);
         // set_tx.high_during( HALF_PERIOD );

         // Zalogowanie konca transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wyslano bajt %b (0x %h) (dec %d) (ascii %s)", $time, char, char, char, char);

      end
   endtask

endmodule
