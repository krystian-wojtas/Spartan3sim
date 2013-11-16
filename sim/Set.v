module Set
#(
   parameter LABEL = "",

   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0,

   parameter N = 1
) (
   output reg [N-1:0] signals
);

   // Zadanie ustawia okreslony stan

   task state
   (
      input [N-1:0] signals_to_set
   );
      begin

         // Poinformuj o stanie poprzednim

         if( INFO2 )
            $display("%t\t INFO2 %s Stan sygnalow zostanie zmieniony. Obecny stan '%b' (0x %h), spodziewany stan '%b' (0x %h)", $time, LABEL, signals, signals, signals_to_set, signals_to_set);

         // Zmien stan

         signals = signals_to_set;

         // Poinformuj o zmianie

         if( INFO1 )
            $display("%t\t INFO1 %s Stan sygnalow zostal zmieniony. Poprzedni stan '%b' (0x %h), obecny stan '%b' (0x %h)", $time, LABEL, signals, signals, signals_to_set, signals_to_set);

      end
   endtask


   // Zadanie ustawia stan niski na wszystkich liniach

   task low ();
      begin
         state( {N{1'b0}} );
      end
   endtask


   // Zadanie ustawia stan wysoki na wszystkich liniach

   task high ();
      begin
         state( {N{1'b1}} );
      end
   endtask


   // Zadanie ustawia stan wysokiej impedancji na wszystkich liniach

   task z ();
      begin
         state( {N{1'bz}} );
      end
   endtask



   // Zadanie ustawia stan niski i przeczekuje zadany okres czasu

   task low_during
   (
      input [31:0] period
   );
      begin

         // Ustaw stan sygnalow na niski

         low();

         // Opcjonalnie poinformuj o przeczekiwaniu

         if( INFO3 )
            $display("%t\t INFO3 %s sygnal w stanie niskim zostaje zamrozony przez zadany okres czasu %d", $time, LABEL, period);

         // Przeczekaj zadany czas

         #period;

         // Opcjonalnie poinformuj o dalszym biegu

         if( INFO4 )
            $display("%t\t INFO4 %s Przeczekiwanie stanu niskiego zostalo zakonczone %d", $time, LABEL, period);

      end
   endtask


   // Zadanie ustawia stan wysoki i przeczekuje zadany okres czasu

   task high_during
   (
      input [31:0] period
   );
      begin

         // Ustaw stan sygnalow na wysoki

         high();

         // Opcjonalnie poinformuj o przeczekiwaniu

         if( INFO3 )
            $display("%t\t INFO3 %s sygnal w stanie wysokim zostaje zamrozony przez zadany okres czasu %d", $time, LABEL, period);

         // Przeczekaj zadany czas

         #period;

         // Opcjonalnie poinformuj o dalszym biegu

         if( INFO4 )
            $display("%t\t INFO4 %s Przeczekiwanie stanu wysokiego zostalo zakonczone %d", $time, LABEL, period);

      end
   endtask


   // Zadanie ustawia okreslony stan i przeczekuje zadany okres czasu, po czym wraca do stanu poprzedniego

   task state_during_and_restore
   (
      input [31:0]  period,
      input [N-1:0] signals_to_set
   );
      reg [N-1:0]   saved_signals;
      begin
         saved_signals = signals;
         state( signals_to_set );
         #period;
         state( saved_signals );
      end
   endtask


   // Zadanie ustawia stan niski i przeczekuje zadany okres czasu, po czym wraca do stanu poprzedniego

   task low_during_and_restore
   (
      input [31:0] period
   );
      begin
         state_during_and_restore( period, {N{1'b0}} );
      end
   endtask


   // Zadanie ustawia stan wysoki i przeczekuje zadany okres czasu, po czym wraca do stanu poprzedniego

   task high_during_and_restore
   (
      input [31:0] period
   );
      begin
         state_during_and_restore( period, {N{1'b1}} );
      end
   endtask


endmodule
