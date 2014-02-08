module Vga_behav
#(
   parameter LABEL = " vga_behav",
   parameter PARENT_LABEL = "",

   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0
) (
   input [3:0] vga_r,
   input [3:0] vga_g,
   input [3:0] vga_b,
   input vga_hsync,
   input vga_vsync
);
   localparam MODULE_LABEL = {PARENT_LABEL, LABEL};

   Monitor #(
      .PARENT_LABEL(MODULE_LABEL),
      .LABEL(" monitor vga"),
      .LOGLEVEL(5),
      // .LOGLEVEL(9),
      .N(14)
   ) monitor_vga (
      .signals( { vga_hsync, vga_vsync, vga_r, vga_g, vga_b } )
   );

   Monitor #(
      .PARENT_LABEL(MODULE_LABEL),
      .LABEL(" monitor vga kolory"),
      .LOGLEVEL(5),
      // .LOGLEVEL(9),
      .N(12)
   ) monitor_vga_colours (
      .signals( { vga_r, vga_g, vga_b } )
   );

   Monitor #(
      .PARENT_LABEL(MODULE_LABEL),
      .LABEL(" monitor vga synchronizacja"),
      .LOGLEVEL(5),
      // .LOGLEVEL(9),
      .N(2)
   ) monitor_vga_syncs (
      .signals( { vga_hsync, vga_vsync } )
   );

   reg   inited=1'b0;

   // always begin
   //    if(~inited) begin

   //       // Sprawdz czy sygnaly synchronizacyjne zaczynaja stanami wyskokimi
   //       monitor_vga_syncs.ensure_high();

   //       // Poczekaj na opadajaca synchronizacje kolumn
   //       monitor_vga_syncs.wait_for_state( 2'b10 );

   //       // Zacznij odbierac kolory
   //       inited=1'b1;

   //       if( INFO1 )
   //          $display("%t\t INFO1\t [ %s ] \t Wykryto rozpoczecie synchronizacji kolumn.", $time, MODULE_LABEL);
   //    end
   // end

   integer i;

   always begin

      fork
      begin
      if(~inited) begin

         // Sprawdz czy sygnaly synchronizacyjne zaczynaja stanami wyskokimi
         monitor_vga_syncs.ensure_high();

         #100;

         // Poczekaj na opadajaca synchronizacje kolumn
         monitor_vga_syncs.wait_for_state( 2'b10 );

         // Zacznij odbierac kolory
         inited=1'b1;

         if( INFO1 )
            $display("%t\t INFO1\t [ %s ] \t Wykryto rozpoczecie synchronizacji kolumn.", $time, MODULE_LABEL);
      end
      end
      begin

      if(inited) begin

         // Sygnaly kolorow powinny byc wtedy opuszczone
         monitor_vga_colours.ensure_low();
         // Wszystkie sygnaly vga nie powinny sie zmienic przez cala dlugosc pulsu synchronizacji kolumn
         monitor_vga.ensure_same_during( 32'd64 );
         // Sygnal synchronizujacy kolumhy powinien teraz powrocic do stanu wysokiego
         monitor_vga_syncs.ensure_high();
         // Sygnaly kolorow powinny jednak wciaz byc opuszczone przez chwile ciszy po synchronizacji
         monitor_vga_colours.ensure_low_during( 32'd320 );

         // Odbierz kolejne wiersze

         for(i=0; i<480; i=i+1) begin

            // Poczekaj na opadajaca synchronizacje wierszy
            monitor_vga_syncs.wait_for_state( 2'b01 );
            // Sygnaly kolorow powinny byc wtedy opuszczone
            monitor_vga_colours.ensure_low();
            // Wszystkie sygnaly vga nie powinny sie zmienic przez cala dlugosc pulsu synchronizacji wierszy
            monitor_vga.ensure_same_during( 32'd384 );
            // Sygnal synchronizujacy wiersze powinien teraz powrocic do stanu wysokiego
            monitor_vga_syncs.ensure_high();
            // Sygnaly kolorow powinny jednak wciaz byc opuszczone przez chwile ciszy po synchronizacji
            monitor_vga_colours.ensure_low_during( 32'd192 );

            // Nastepuje prezentacja kolorow dla kolejnych pikseli w wierszu
            #256;

            // Czas ciszy przed nastepujaca synchronizacja kolejnego wiersza
            monitor_vga_colours.ensure_low_during( 32'd640_000 );
         end

         // Czas ciszy przed nastepujaca synchronizacja kolumn
         monitor_vga_colours.ensure_low_during( 32'd320 );
      end

      end
      join;

   end

endmodule
