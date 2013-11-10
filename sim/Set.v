module Set
#(
   parameter LOGLEVEL = 1,
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
         signals = signals_to_set;
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


   // Zadanie ustawia stan niski i przeczekuje zadany okres czasu

   task low_during
   (
      input [31:0] period
   );
      begin
         low();
         #period;
      end
   endtask


   // Zadanie ustawia stan wysoki i przeczekuje zadany okres czasu

   task high_during
   (
      input [31:0] period
   );
      begin
         high();
         #period;
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
