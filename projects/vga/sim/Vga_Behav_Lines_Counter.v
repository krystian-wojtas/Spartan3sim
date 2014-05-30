module Vga_Behav_Lines_Counter
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o odebraniu prawidlowej ilosci linii w ramce
   //
   parameter LOGLEVEL = 5,
   parameter LOGLEVEL_VGA_VSYNC = 5,
   parameter LOGLEVEL_VGA_HSYNC = 5,

   parameter LINES = 521
) (
   input vga_hsync,
   input vga_vsync,
   input synchronized
);

   // Instancje monitorow

   Monitor #(
      .LOGLEVEL(LOGLEVEL_VGA_VSYNC),
      .N(1)
   ) monitor_vga_vsync (
      .signals( vga_vsync )
   );

   Monitor #(
      .LOGLEVEL(LOGLEVEL_VGA_HSYNC),
      .N(1)
   ) monitor_vga_hsync (
      .signals( vga_hsync )
   );

   // Zlicza ilosc odebranych wierszy w ramce i sprawdza czy jest wlasciwa

   integer i=0;
   always @(negedge vga_vsync)
      if(synchronized) begin
         i = 0;

         // Przeczekaj cykl ramki
         monitor_vga_vsync.wait_for_high();
         monitor_vga_vsync.wait_for_low();

         // Sprawdz ilosc odebranych linii, zakomunikuj warunkowo o rezultacie
         if(i != LINES+1) begin
            if(LOGLEVEL >= 1)
               $display("%t\t BLAD\t [ %m ] \t Pomiedzy synchronizacjami kolumn wyslano %d linii. W cyklu powinno ich nastapic %d.", $time, i, LINES);
         end else
            if(LOGLEVEL >= 3)
               $display("%t\t INFO3\t [ %m ] \t Odebrano wlasciwa ilosc linii %d w cyklu.", $time, i);

      end
   always @(negedge vga_hsync)
      if(synchronized) begin
         i = i + 1;

         // Przeczekaj cykl linii
         monitor_vga_hsync.wait_for_low();
         monitor_vga_hsync.wait_for_high();
      end

endmodule
