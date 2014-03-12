module Vga_Behav_Sync
#(
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
   parameter H_BP  =      1_900
) (
   input [3:0] vga_r,
   input [3:0] vga_g,
   input [3:0] vga_b,
   input vga_hsync,
   input vga_vsync,
   input synchronized
);
   // Instancje monitorow

   Monitor #(
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(12)
   ) monitor_vga_colours_v (
      .signals( { vga_r, vga_g, vga_b } )
   );

   Monitor #(
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(12)
   ) monitor_vga_colours_h (
      .signals( { vga_r, vga_g, vga_b } )
   );

   Monitor #(
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(1)
   ) monitor_vga_vsync (
      .signals( vga_vsync )
   );

   Monitor #(
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(1)
   ) monitor_vga_hsync (
      .signals( vga_hsync )
   );

   // Sprawdzanie synchronizacji ramek

   always @(negedge vga_vsync) begin
      if(synchronized) begin
         if( INFO1 )
            $display("%t\t INFO1\t [ %m ] \t Rozpoczecie odbioru nowej ramki.", $time);

         fork begin
            // Dlugosc pulsu synchronizacji ramki
            // +1: wymaga symulacja
            monitor_vga_vsync.ensure_low_during( V_PW +1 );
            // monitor_vga_vsync.ensure_low_during( 64_040 +1 );
            // Czas do nastepnej synchronizacji ramki
            // -1: kompensacja +1 z poprzedniego; nastepne -1 aby skonczyl chwile przed nastepnym cyklem i zlapal liste wrazliwosci
            monitor_vga_vsync.ensure_high_during( V_S - V_PW -1 -1 );

         end begin

            // Dlugosc pulsu synchronizacji ramki
            monitor_vga_colours_v.ensure_low_during( V_PW + V_BP );

            // Czas wyswietlania wszystkich kolejnych wierszy w ramce
            if( INFO3 )
               $display("%t\t INFO3\t [ %m ] \t Nadawanie wierszy", $time);
            #(V_S - V_FP - V_PW - V_BP + 13581);
            if( INFO3 )
               $display("%t\t INFO3\t [ %m ] \t Nadano wiersze", $time);

            // Czas do nastepnej synchronizacji ramki
            monitor_vga_colours_v.ensure_low_during( V_FP -13581 -1 );
         end join;

         $display();
      end;
   end

   // Sprawdzanie synchronizacji wierszy

   always @(negedge vga_hsync) begin
      if(synchronized) begin
         // logs.info1("Rozpoczecie odbioru nowego wiersza");
         if( INFO1 )
            $display("%t\t INFO1\t [ %m ] \t Rozpoczecie odbioru nowego wiersza.", $time);

         Fork begin
            // Dlugosc pulsu synchronizacji wierszy
            // +1: wymaga symulacja
            monitor_vga_hsync.ensure_low_during( H_PW +1 );
            // Czas do nastepnej synchronizacji wierszy
            // -1: kompensacja +1 z poprzedniego; nastepne -1 aby skonczyl chwile przed nastepnym cyklem i zlapal liste wrazliwosci
            monitor_vga_hsync.ensure_high_during( H_S - H_PW -1 -1 );

         end begin

            // Dlugosc pulsu synchronizacji wierszy
            monitor_vga_colours_h.ensure_low_during( H_PW + H_BP );

            // Czas wyswietlania wszystkich kolejnych pikseli w wierszu
            if( INFO3 )
               $display("%t\t INFO3\t [ %m ] \t Nadawanie kolorow w wierszu", $time);
            #(H_S - H_FP - H_PW - H_BP);
            if( INFO3 )
               $display("%t\t INFO3\t [ %m ] \t Nadano kolory w wierszu", $time);

            // Czas do nastepnej synchronizacji wierszy
            monitor_vga_colours_h.ensure_low_during( H_FP -1 );

         end join;

         $display();
      end
   end

endmodule
