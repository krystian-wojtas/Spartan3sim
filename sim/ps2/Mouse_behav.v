module Mouse_behav
#(
   parameter LABEL = " myszka_behav",
   parameter PARENT_LABEL = "",

   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0
) (
   inout ps2c,
   inout ps2d
);

   PS2_behav #(
      .PARENT_LABEL({PARENT_LABEL, LABEL}),
      .INFO1(1),
      .INFO2(1),
      .INFO3(1),
      .INFO4(1)
   ) ps2 (
      .ps2c(ps2c),
      .ps2d(ps2d)
   );

   // Zadanie czeka na nowiazanie komunikacji ze strony FPGA, odbiera komende i sprawdza czy dotyczy ona zmiany trybu pracy na strumieniowy

   task receive_streaming_cmd ();
      reg [7:0] cmd;
      begin

         // Odbierz komende

         ps2.receive_cmd( cmd );

      // Sprawdz odebrana komende

      // Jedyna spodziewana i obslugiwana jest 0xF4 oznaczajaca nakaz przelaczenia sie myszy w tryb strumieniowy

      // W trybie tym myszka przesyla powiadomienia o zdarzeniach bez potrzeby uprzedniego ciaglego odpytywania jej czy nowe zdarzenie zaszlo

      if( cmd !== 8'hF4 )
         if( ERROR )
             $display("%t\t BLAD %s Przeslana komenda %b (0x%h) rozni sie od oczekiwanej 1111_0100 (0xF4)", $time, LABEL, cmd, cmd);

         // Potwierdz poprawne odebranie komendy

         ps2.transmit_data( 8'hFA );

      // Poinformuj o zmianie trybu pracy

      if( INFO2 )
          $display("%t\t INFO2 %s Poprawnie zmieniono tryb pracy myszki na strumieniowy", $time, LABEL);

      end
   endtask

   task transmit_packet
   (
      input left_button,
      input middle_button,
      input right_button,
      input [7:0] x,
      input x_sign,
      input x_overflow,
      input [7:0] y,
      input y_sign,
      input y_overflow
   );
      reg [7:0] control;
      begin

         // Skonstruuj pierwszy pakiet danych kontrolnych

         control = { y_overflow, x_overflow, y_sign, x_sign, 1'b1, middle_button, right_button, left_button };

         // Przeslij kolejne 3 bajty: kontrolny oraz ruchy myszy

         ps2.transmit_data( control );
         ps2.transmit_data( x );
         ps2.transmit_data( y );
      end
   endtask


   task click_left_button ();
      begin
         transmit_packet (
            1'b1, // left button
            1'b0, // middle button
            1'b0, // right button
            8'd0, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd0, // y movement
            1'b0, // y sign
            1'b0  // y overflow
         );
      end
   endtask


   task click_middle_button ();
      begin
         transmit_packet (
            1'b0, // left button
            1'b1, // middle button
            1'b0, // right button
            8'd0, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd0, // y movement
            1'b0, // y sign
            1'b0  // y overflow
         );
      end
   endtask


   task click_right_button ();
      begin
         transmit_packet (
            1'b0, // left button
            1'b0, // middle button
            1'b1, // right button
            8'd0, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd0, // y movement
            1'b0, // y sign
            1'b0  // y overflow
         );
      end
   endtask


   task move_right ();
      begin
         transmit_packet (
            1'b0, // left button
            1'b0, // middle button
            1'b0, // right button
            8'd1, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd0, // y movement
            1'b0, // y sign
            1'b0  // y overflow
         );
      end
   endtask


   task move_left ();
      begin
         transmit_packet (
            1'b0, // left button
            1'b0, // middle button
            1'b0, // right button
            8'd1, // x movement
            1'b1, // x sign
            1'b0, // x overflow
            8'd0, // y movement
            1'b0, // y sign
            1'b0  // y overflow
         );
      end
   endtask


   task move_up ();
      begin
         transmit_packet (
            1'b0, // left button
            1'b0, // middle button
            1'b0, // right button
            8'd0, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd1, // y movement
            1'b0, // y sign
            1'b0  // y overflow
         );
      end
   endtask

   task move_down ();
      begin
         transmit_packet (
            1'b0, // left button
            1'b0, // middle button
            1'b0, // right button
            8'd0, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd1, // y movement
            1'b1, // y sign
            1'b0  // y overflow
         );
      end
   endtask


   task test ();
      begin
         transmit_packet (
            1'b1, // left button
            1'b0, // middle button
            1'b0, // right button
            8'd0, // x movement
            1'b0, // x sign
            1'b0, // x overflow
            8'd0, // y movement
            1'b0, // y sign
            1'b1  // y overflow
         );
      end
   endtask


endmodule
