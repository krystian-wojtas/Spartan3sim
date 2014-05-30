module Vga_Behav
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o oczekiwaniu na poczatek nowej ramki
   // LOGLEVEL = 4
   //      informuje o zsynchronizowaniu ramki
   //
   parameter LOGLEVEL = 5,
   parameter LOGLEVEL_SYNC = 5,
   parameter LOGLEVEL_LINES = 5,

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

   Monitor #(
      .LOGLEVEL(2),
      .N(1)
   ) monitor_vga_vsync (
      .signals( vga_vsync )
   );

   // Synchronizacja pierwszej ramki

   reg   synchronized=1'b0;
   initial begin
      if( LOGLEVEL >= 3 )
         $display("%t\t INFO3\t [ %m ] \t Oczekiwanie na poczatek nowej ramki.", $time);

      // Poczekaj na pierwszy puls synchronizacji ramki
      // Nie sprawdza jednak dlugosci jego trwania, pomiar pulsu synchronizacji nastapi od drugiej ramki
      monitor_vga_vsync.wait_for_low();
      monitor_vga_vsync.wait_for_high();

      // Zsynchronizowano, zacznij odbierac ramki
      synchronized=1'b1;

      if( LOGLEVEL >= 4 )
         $display("%t\t INFO4\t [ %m ] \t Zsynchronizowano, rozpoczecie odbioru ramek.", $time);
   end

   Vga_Behav_Sync #(
      .LOGLEVEL(LOGLEVEL_SYNC),
      .V_S(V_S),
      .V_FP(V_FP),
      .V_PW(V_PW),
      .V_BP(V_BP),
      .H_S(H_S),
      .H_PW(H_PW),
      .H_FP(H_FP),
      .H_BP(H_BP)
   ) vga_behav_sync_ (
      .vga_r(vga_r),
      .vga_g(vga_g),
      .vga_b(vga_b),
      .vga_hsync(vga_hsync),
      .vga_vsync(vga_vsync),
      .synchronized(synchronized)
   );

   Vga_Behav_Lines_Counter #(
      .LOGLEVEL(LOGLEVEL_LINES),
      .LINES(LINES)
   ) vga_behav_lines_counter_ (
      .vga_hsync(vga_hsync),
      .vga_vsync(vga_vsync),
      .synchronized(synchronized)
   );

endmodule
