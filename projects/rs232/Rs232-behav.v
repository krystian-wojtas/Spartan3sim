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
   // LOGLEVEL = 6 //TODO del
   //      debug
   parameter LOGLEVEL=3,

   parameter BAUDRATE = 115_200
) (
   input rx,
   output tx
);

   // czas jednego okresu przy zakladanej szybkosci
   parameter period = 1_000_000_000 / BAUDRATE;
   // czas polowy okresu
   parameter half_period = period / 2;

   // Instancje ustawiacza i obserwatora linii tx i rx

   Set #(
      .LOGLEVEL(5),
      .N(1)
   ) set_tx (
      .signals( tx )
   );

   Monitor #(
      .LOGLEVEL(5),
      .N(1)
   ) monitor_rx (
      .signals( rx )
   );

   // Zadanie wysyla przekazany bajt wraz z poprzedajacym bitem startu i nastepujacym stopu

   task transmit
   (
      input [7:0] byte_tosend
   );
      integer     i;
      begin

         // Zalogowanie poczatku transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wysylany bajt '%b' (0x %h) (dec %d)  (ascii %s)", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);

         // Start bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Rozpoczecie transmisji, start bit 0", $time);
         set_tx.low_during( period );

         // Przekazany bajt
         for(i=0; i < 8; i=i+1) begin
            set_tx.state_during( period, byte_tosend[i] );

            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] \t Wyslano bit nr %d o wartosci %b", $time, i, tx);
         end

         // Stop bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie transmisji, stop bit 1", $time);
         set_tx.high_during( period );

         // Zalogowanie konca transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wyslano bajt %b (0x %h) (dec %d)  (ascii %s)", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);

      end
   endtask


   // Zadanie odbiera bit probkujac go 3 krotnie

   task receive_bit3x
   (
      output reg received
   );
      begin

         // Pierwsze probkowanie zapisuje stan linii rx
         #(period / 6);
         received = rx;

         // Drugie probkowanie porownuje zapisany stan z obecnym, powinny sie zgadzac
         #(period / 3);
         if(received != rx)
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Druga proba odbieranego bitu %b rozni sie od pierwszej %b", $time, rx, received);

         // Trzecie probkowanie jak wyzej
         #(period / 3);
         if(received != rx)
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Trzecia proba odbieranego bitu %b rozni sie od pierwszej %b", $time, rx, received);

         // Konczenie okresu
         #(period / 6);

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
         receive_bit3x( startbit );
         if(startbit != 1'b0)
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Bit startu powinien byc niski", $time);
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Bit startu zostal odebrany", $time);

         // Odbierz bajt danych
         for(i=0; i < 8; i=i+1) begin
            receive_bit3x( byte_received[i] );
            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] \t Odebrano bit nr %d o wartosci %b", $time, i, byte_received[i]);
         end

         // Odbierz oczekiwany stop bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie odbioru danych, nastepuje odbior spodziewanego stop bitu", $time);
         receive_bit3x( stopbit );
         if(stopbit != 1'b1)
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Oczekiwany bit stopu powinien byc wysoki", $time);

         // Zalogowanie zakonczenia odbioru
         if(LOGLEVEL >= 3)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie odbioru pakietu", $time);

      end
   endtask


        localparam CHARS = 1;
        reg [7:0] mem [CHARS:0];
        initial begin
                 mem[0] = 8'b1000_0000;
//                 mem[0] = 8'hff;
                 mem[0] = 8'h0a;
                 mem[1] = 8'hc2; //"e";
                 mem[2] = "l";
                 mem[3] = "l";
                 mem[4] = "o";
                 mem[5] = " ";
                 mem[6] = "R";
                 mem[7] = "S";
                 mem[8] = "2";
                 mem[9] = "3";
                 mem[10]="2";
        end


        integer j = 0;
        initial begin
           set_tx.high();
                #10_000; // opoznienie
//              for(j=0; j<CHARS; j=j+1)
//                      transmit( mem[j] );
           transmit( "?" );
           // transmit( "\n" );
        end

   // W chwili przed symulacja stany linii sa nieustalone a wszelkie zbocza na nich zostaja wykryte
   // Rejestr init zapobiega probie odbioru pakietu w chwili zero czasu symulacji

   reg inited = 1'b0;
   initial begin
      #1;
      inited = 1'b1;
   end

        integer k = 0;
        reg [7:0] byte_received = 8'd0;
        always @(negedge rx) begin
           if(inited) begin
                // odbior bajtu
                receive( byte_received );
                if(LOGLEVEL >= 3)
                        $display("%t\t INFO3 [ %m ] \t Odebrano bajt %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received);
                // weryfikacja
                if( byte_received != mem[k] )
                        if(LOGLEVEL >= 1)
                                $display("%t\t ERROR [ %m ] \t Odebrany bajt %b 0x%h %d %s rozni sie od wyslanego wzorca %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received, mem[k], mem[k], mem[k], mem[k]);
                k = k + 1;
           end
        end


endmodule
