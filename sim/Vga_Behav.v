module Vga_Behav
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
      .LABEL(" monitor vga sync vertical"),
      .LOGLEVEL(7),
      // .LOGLEVEL(9),
      .N(1)
   ) monitor_vga_vsync (
      .signals( vga_vsync )
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

   Vga_Behav_Sync #(
      .ERROR(ERROR),
      .INFO1(INFO1),
      .INFO2(INFO2),
      .INFO3(INFO3),
      .INFO4(INFO4)
   ) vga_behav_sync_ (
      .vga_r(vga_r),
      .vga_g(vga_g),
      .vga_b(vga_b),
      .vga_hsync(vga_hsync),
      .vga_vsync(vga_vsync),
      .synchronized(synchronized)
   );

   Vga_Behav_Lines_Counter #(
      .ERROR(ERROR),
      .INFO1(INFO1),
      .INFO2(INFO2),
      .INFO3(INFO3),
      .INFO4(INFO4)
   ) vga_behav_lines_counter_ (
      .vga_hsync(vga_hsync),
      .vga_vsync(vga_vsync),
      .synchronized(synchronized)
   );

endmodule
