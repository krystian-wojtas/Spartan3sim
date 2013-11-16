module Set
#(
   parameter LABEL = "set",

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
            $display("%t\t INFO1 %s Stan sygnalow zostal zmieniony. Obecny stan '%b' (0x %h)", $time, LABEL, signals, signals);

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


   // Zadanie ustawia zadany stan i przeczekuje zadany okres czasu

   task state_during
   (
      input [31:0] period,
      input [N-1:0] signals_to_set
   );
      begin

         // Ustaw stan sygnalow na zadany

         state( signals_to_set );

         // Opcjonalnie poinformuj o przeczekiwaniu

         if( INFO3 )
            $display("%t\t INFO3 %s sygnal w stanie %b (hex %h) zostaje zamrozony przez zadany okres czasu %d", $time, LABEL, signals_to_set, signals_to_set, period);

         // Przeczekaj zadany czas

         #period;

         // Opcjonalnie poinformuj o dalszym biegu

         if( INFO4 )
            $display("%t\t INFO4 %s Przeczekiwanie stanu %b (hex %h) zostalo zakonczone po %d", $time, LABEL, signals_to_set, signals_to_set, period);

      end
   endtask



   // Zadanie ustawia stan niski i przeczekuje zadany okres czasu

   task low_during
   (
      input [31:0] period
   );
      begin
         state_during( period, {N{1'b0}} );
      end
   endtask


   // Zadanie ustawia stan wysoki i przeczekuje zadany okres czasu

   task high_during
   (
      input [31:0] period
   );
      begin
         state_during( period, {N{1'b1}} );
      end
   endtask


   // Zadanie ustawia stan wysokiej impedancji i przeczekuje zadany okres czasu

   task z_during
   (
      input [31:0] period
   );
      begin
         state_during( period, {N{1'bz}} );
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
