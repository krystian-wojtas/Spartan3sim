module Vga_Behav_Lines_Counter
#(
   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0,

   parameter LINES = 521
) (
   input vga_hsync,
   input vga_vsync,
   input synchronized
);

   // Instancje monitorow

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

   // Zlicza ilosc odebranych wierszy w ramce i sprawdza czy jest wlasciwa

   integer i=0;
   always @(negedge vga_vsync, posedge synchronized)
      if(synchronized) begin
         i = 0;

         // Przeczekaj cykl ramki
         monitor_vga_vsync.wait_for_high();
         monitor_vga_vsync.wait_for_low();

         // Sprawdz ilosc odebranych linii, zakomunikuj warunkowo o rezultacie
         if(i != LINES) begin
            if(ERROR)
               $display("%t\t BLAD\t [ %m ] \t Pomiedzy synchronizacjami kolumn wyslano %d linii. W cyklu powinno ich nastapic %d.", $time, i, LINES);
         end else
            if(INFO2)
               $display("%t\t INFO2\t [ %m ] \t Odebrano wlasciwa ilosc linii %d w cyklu.", $time, i);

      end
   always @(negedge vga_hsync, posedge synchronized)
      if(synchronized) begin
         i = i + 1;

         // Przeczekaj cykl linii
         monitor_vga_hsync.wait_for_low();
         monitor_vga_hsync.wait_for_high();
      end

endmodule
