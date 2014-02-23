module Vga_behav
#(
   parameter LABEL = " vga_behav",
   parameter PARENT_LABEL = "",

   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0,

   // Domyslnie 640x480
   parameter V_S   = 16_700_000,
   parameter V_FP  =    320_000,
   parameter V_PW  =     64_040,
   parameter V_BP  =    928_000,
   parameter H_S   =     32_020,
   parameter H_PW  =      3_860,
   parameter H_FP  =        640,
   parameter H_BP  =      1_900,

   parameter LINES = 521
) (
   input [3:0] vga_r,
   input [3:0] vga_g,
   input [3:0] vga_b,
   input vga_hsync,
   input vga_vsync
);
   localparam MODULE_LABEL = {PARENT_LABEL, LABEL};

   // Instancje monitorow

   Monitor #(
      .PARENT_LABEL(MODULE_LABEL),
      .LABEL(" monitor vga kolory"),
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(12)
   ) monitor_vga_colours (
      .signals( { vga_r, vga_g, vga_b } )
   );

   Monitor #(
      .PARENT_LABEL(MODULE_LABEL),
      .LABEL(" monitor vga vsync"),
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(1)
   ) monitor_vga_vsync (
      .signals( vga_vsync )
   );

   Monitor #(
      .PARENT_LABEL(MODULE_LABEL),
      .LABEL(" monitor vga hsync"),
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(1)
   ) monitor_vga_hsync (
      .signals( vga_hsync )
   );

   // Synchronizacja pierwszej ramki

   reg   synchronized=1'b0;
   initial begin
      if( INFO1 )
         $display("%t\t INFO1\t [ %s ] \t Oczekiwanie na poczatek nowej ramki.", $time, MODULE_LABEL);

      // Poczekaj na pierwszy puls synchronizacji ramki
      // Nie sprawdza jednak dlugosci jego trwania, pomiar pulsu synchronizacji nastapi od drugiej ramki
      monitor_vga_vsync.wait_for_low();
      monitor_vga_vsync.wait_for_high();

      // Zsynchronizowano, zacznij odbierac ramki
      synchronized=1'b1;

      if( INFO1 )
         $display("%t\t INFO1\t [ %s ] \t Rozpoczecie odbioru ramek.", $time, MODULE_LABEL);
   end

   // Sprawdzanie synchronizacji ramek

   always @(negedge vga_vsync) begin
      if(synchronized) begin
         fork begin
            // Dlugosc pulsu synchronizacji kolumn
            // +1: wymaga symulacja
            monitor_vga_vsync.ensure_low_during( V_PW +1 );
            // Czas do nastepnej synchronizacji kolumn
            // -1: kompensacja +1 z poprzedniego; nastepne -1 aby skonczyl chwile przed nastepnym cyklem i zlapal liste wrazliwosci
            monitor_vga_vsync.ensure_high_during( V_S - V_PW -1 -1 );

         end begin

            // Dlugosc pulsu synchronizacji wierszy
            monitor_vga_colours.ensure_low_during( V_PW + V_BP );

            // Czas wyswietlania wszystkich kolejnych wierszy w ramce
            #(V_S - V_FP - V_PW - V_BP);

            // Czas do nastepnej synchronizacji wierszy
            monitor_vga_colours.ensure_low_during( V_FP );
         end join;

         $display();
      end;
   end

   // Sprawdzanie synchronizacji wiersze

   always @(negedge vga_hsync) begin
      if(synchronized) begin
         fork begin
            // Dlugosc pulsu synchronizacji wierszy
            // +1: wymaga symulacja
            monitor_vga_hsync.ensure_low_during( H_PW +1 );
            // Czas do nastepnej synchronizacji wierszy
            // -1: kompensacja +1 z poprzedniego; nastepne -1 aby skonczyl chwile przed nastepnym cyklem i zlapal liste wrazliwosci
            monitor_vga_hsync.ensure_high_during( H_S - H_PW -1 -1 );

         end begin

            // Dlugosc pulsu synchronizacji wierszy
            monitor_vga_colours.ensure_low_during( H_PW + H_BP );

            // Czas wyswietlania wszystkich kolejnych pikseli w wierszu
            #(H_S - H_FP - H_PW - H_BP);

            // Czas do nastepnej synchronizacji wierszy
            monitor_vga_colours.ensure_low_during( H_FP );

         end join;

         $display();
      end

   end

   // Zlicza ilosc odebranych wierszy w ramce i sprawdza czy jest wlasciwa

   integer i=0;
   always @(negedge vga_vsync, posedge synchronized)
      if(synchronized) begin
         i = 0;

         // Przeczekaj okres ramki

         monitor_vga_vsync.wait_for_high();
         monitor_vga_vsync.wait_for_low();

         // Sprawdz ilosc odebranych linii, zakomunikuj warunkowo

         if(i != LINES) begin
            if(ERROR)
               $display("%t\t BLAD\t [ %s ] \t Pomiedzy synchronizacjami kolumn wyslano %d linii. W cyklu powinno ich nastapic %d.", $time, MODULE_LABEL, i, LINES);
         end else
           if(INFO2)
              $display("%t\t INFO2\t [ %s ] \t Odebrano wlasciwa ilosc linii %d w cyklu.", $time, MODULE_LABEL, i);

      end
   always @(negedge vga_hsync, posedge synchronized)
      if(synchronized) begin
         i = i + 1;

         // Przeczekaj okres linii

         monitor_vga_hsync.wait_for_low();
         monitor_vga_hsync.wait_for_high();
      end

endmodule
