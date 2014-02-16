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
   parameter V_S  = 16_700_000,
   parameter V_FP =    320_000,
   parameter V_PW =     64_000,
   parameter V_BP =    928_000,
   parameter H_S  =     32_000,
   parameter H_PW =      3_840,
   parameter H_FP =        640,
   parameter H_BP =      1_920
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

   reg   synchronized=1'b0;
   integer i = 0;
   always begin

      fork begin
         if(~synchronized) begin

            if( INFO1 )
               $display("%t\t INFO1\t [ %s ] \t Oczekiwanie na poczatek nowej ramki.", $time, MODULE_LABEL);

            // Wartosci w zerowej chwili nie sa okreslone
            #1;

            // Poczekaj na pierwszy puls synchronizacji ramki
            // Nie sprawdza jednak dlugosci jego trwania, pomiar pulsu synchronizacji nastapi od drugiej ramki
            monitor_vga_vsync.wait_for_low();
            monitor_vga_vsync.wait_for_high();

            if( INFO1 )
               $display("%t\t INFO1\t [ %s ] \t Rozpoczecie odbioru ramek.", $time, MODULE_LABEL);

            // Zacznij odbierac ramki
            synchronized=1'b1;
         end

      end begin

  //        if(synchronized) begin
  //           // Dlugosc pulsu synchronizacji kolumn
  // // $display("%t\t DEBUG\t [ %s ] \t AAA.", $time, MODULE_LABEL);
  //           monitor_vga_vsync.ensure_low_during( V_PW );
  // // $display("%t\t DEBUG\t [ %s ] \t BBB.", $time, MODULE_LABEL);
  //           // Czas do nastepnej synchronizacji kolumn
  //           monitor_vga_vsync.ensure_high_during( V_S - V_PW );
  // // $display("%t\t DEBUG\t [ %s ] \t CCC.", $time, MODULE_LABEL);
  //        end

  //     end begin

  //        if(synchronized) begin
  //           // Dlugosc pulsu synchronizacji wierszy
  //           monitor_vga_colours.ensure_low_during( V_PW + V_BP );

  //           // Czas wyswietlania wszystkich kolejnych wierszy w ramce
  //           #(V_S - V_FP - V_PW - V_BP);

  //           // Czas do nastepnej synchronizacji wierszy
  //           monitor_vga_colours.ensure_low_during( V_FP );
  //        end


      end begin

         if(synchronized) begin
            // Dlugosc pulsu synchronizacji wierszy
            monitor_vga_hsync.ensure_low_during( H_PW );
            // Czas do nastepnej synchronizacji wierszy
            monitor_vga_hsync.ensure_high_during( H_S - H_PW );
         end

      end begin

         if(synchronized) begin
            // Dlugosc pulsu synchronizacji wierszy
            monitor_vga_colours.ensure_low_during( H_PW + H_BP );

            // Czas wyswietlania wszystkich kolejnych pikseli w wierszu
            #(H_S - H_FP - H_PW - H_BP);

            // Czas do nastepnej synchronizacji wierszy
            monitor_vga_colours.ensure_low_during( H_FP );
         end


      // end begin

      //    if(synchronized) begin
      //       monitor_vga_vsync.wait_for_low();
      //       i = i + 1;
      //       if(i > 480)
      //          if(ERROR)
      //            display("Za duzo linii");
      //    end

      // end begin

      //    if(synchronized) begin
      //       monitor_vga_hsync.wait_for_low();
      //       i = 0;
      //    end

      end join;

   end

endmodule
