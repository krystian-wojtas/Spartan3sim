module Rs232_behav
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o wyslaniu/otrzymaniu pelnego bajtu
   // LOGLEVEL = 4
   //      informuje o wysylaniu/otrzymywaniu poszczegolnych bitow
   // LOGLEVEL = 5
   //      informuje o wyslaniu/otrzymywaniue start i stop bitow
   // LOGLEVEL = 6
   //      informuje o przeczekiwaniu tolerowanego przesuniecia zegara
   parameter LOGLEVEL=3,
   parameter LOGLEVEL_RX=3,
   parameter LOGLEVEL_TX=3,

   parameter BAUDRATE = 115_200
) (
   input rx,
   output tx
);

   // czas jednego okresu przy zakladanej szybkosci
   localparam PERIOD = 1_000_000_000 / BAUDRATE;
   // tolerancja zegara
   localparam BITTOL = 0.05 * PERIOD;

   // Instancje obserwatora i ustawiacza linii tx i rx
   Monitor #(
      .LOGLEVEL(LOGLEVEL_RX),
      .N(1)
   ) monitor_rx (
      .signals( rx )
   );
   Set #(
      .LOGLEVEL(LOGLEVEL_TX),
      .N(1)
   ) set_tx (
      .signals( tx )
   );

   // Stan jalowy jest wysoki
   initial
      set_tx.high();

   // Zadanie wysyla przekazany bajt wraz z poprzedajacym bitem startu i nastepujacym stopu
   task transmit
   (
      input [7:0] byte_tosend
   );
      integer     i;
      begin

         // Zalogowanie poczatku transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wysylanie bajtu '%b' (0x %h) (dec %d) (ascii %s)", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);

         // Start bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Rozpoczecie transmisji, start bit 0", $time);
         set_tx.low_during( PERIOD );

         // Przekazany bajt
         for(i=0; i < 8; i=i+1) begin
            set_tx.state_during( PERIOD, byte_tosend[i] );

            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] \t Wyslano bit nr %d o wartosci %b", $time, i, tx);
         end

         // Stop bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie transmisji, stop bit 1", $time);
         set_tx.high_during( PERIOD );

         // Zalogowanie konca transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wyslano bajt %b (0x %h) (dec %d) (ascii %s)", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);

      end
   endtask


   // Zadanie odbiera bit probkujac go 3 krotnie
   task receive_bit
   (
      output reg received
   );
      begin

         if(LOGLEVEL >= 6)
            $display("%t\t INFO6 [ %m ] \t Czas %d na tolerancje przesuniecia zegara przed odbieranym bitem", $time, BITTOL);
         #(BITTOL);

         if(LOGLEVEL >= 6)
            $display("%t\t INFO5 [ %m ] \t Linia rx powinna byc stabilna przez %d podczas odbioru bitu", $time, (PERIOD-2*BITTOL));
         monitor_rx.ensure_same_during( (PERIOD-2*BITTOL) );

         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Obebrano bit o wartosci %b", $time, rx);
         received = rx;

         if(LOGLEVEL >= 6)
            $display("%t\t INFO6 [ %m ] \t Czas %d na tolerancje przesuniecia zegara po obebranym bicie", $time, BITTOL);
         #(BITTOL);

         if(LOGLEVEL >= 6)
            $display("%t\t INFO6 [ %m ] \t Zakonczono odbior bitu", $time);
      end
   endtask

   task receive
   (
      output reg [7:0] byte_received
   );
      integer i;
      reg startbit;
      reg stopbit;
      begin

         // Zaczekaj na start bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Oczekiwanie na bit startu nowego pakietu", $time);
         monitor_rx.wait_for_low();

         // Zaloguj poczatek odbioru pakietu
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Odbieranie nowego pakietu", $time);

         // Odbierz bit startu
         receive_bit( startbit );
         if(startbit != 1'b0)
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Bit startu powinien byc niski", $time);
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Bit startu zostal odebrany", $time);

         // Odbierz bajt danych
         for(i=0; i < 8; i=i+1) begin
            receive_bit( byte_received[i] );
            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] \t Odebrano bit nr %d o wartosci %b", $time, i, byte_received[i]);
         end

         // Odbierz oczekiwany stop bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie odbioru danych, nastepuje odbior spodziewanego stop bitu", $time);
         receive_bit( stopbit );
         if(stopbit != 1'b1)
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Oczekiwany bit stopu powinien byc wysoki", $time);

         // Zalogowanie zakonczenia odbioru
         if(LOGLEVEL >= 3)
            $display("%t\t INFO5 [ %m ] \t Odebrano pakiet z danymi '%b' (0x %h) (dec %d) (ascii %s)", $time, byte_received, byte_received, byte_received, byte_received);

      end
   endtask

endmodule
