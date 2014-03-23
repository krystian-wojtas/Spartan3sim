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

   // Instancje ustawiacza i monitora linii tx i rx

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
            $display("%t\t INFO5 [ %m ] \t RS rozpoczecie transmisji, start bit 0", $time);

         set_tx.low_during( period );

         // Przekazany bajt

         for(i=0; i < 8; i=i+1) begin
            set_tx.state_during( period, byte_tosend[i] );

            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] RS wyslano bit nr %d o wartosci %b", $time, i, tx);
         end

         // Stop bit

         if(LOGLEVEL >= 5)
            $display("%t\tINFO5 RS zakonczenie transmisji, stop bit 1", $time);

         set_tx.high_during( period );

         // Zalogowanie konca transmisji

         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] RS wyslano bajt %b (0x %h) (dec %d)  (ascii %s)", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);

      end
   endtask


   task receive
   (
      output reg [7:0] byte_received
   );
      integer i;
      begin

                //start bit
                if(LOGLEVEL >= 5)
                        $display("%t\tINFO5 RS rozpoczecie odbioru, start bit 0", $time);
                #period; // przeczekanie start bitu
                #half_period; // opoznienie aby probkowac w polowie taktu

                //byte
                for(i=0; i < 8; i=i+1) begin
                        byte_received[i] = rx;
//                      if(LOGLEVEL >= 4)
//                              $display("%t\tINFO4 RS odebrano bit nr %d o wartosci %b", $time, i, rx);
                        #period;
                end

                //stop bit
                if(LOGLEVEL >= 5)
                        $display("%t\tINFO5 RS zakonczenie odbioru, stop bit %b", $time, rx);
                if(~rx)
                        if(LOGLEVEL >= 1)
                                $display("%t\tERROR RS spodziwany odbior stop bitu (jedynki), jednak nastapilo zero", $time);
                #half_period; // przeczekanie polowy stop bitu; nie czekam do konca bo przeocze zdarzenie negatywnego zbocza rx (start bit 0) co rozpoczynaloby odbior kolejnego pakietu
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
           transmit( "\n" );
        end


        integer k = 0;
        reg [7:0] byte_received = 8'd0;
        // always @(negedge rx) begin
        //         // odbior bajtu
        //         receive( byte_received );
        //         if(LOGLEVEL >= 3)
        //                 $display("%t\tINFO3 RS odebrano bajt %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received);
        //         // weryfikacja
        //         if( byte_received != mem[k] )
        //                 if(LOGLEVEL >= 1)
        //                         $display("%t\tERROR RS odebrany bajt %b 0x%h %d %s rozni sie od wyslanego wzorca %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received, mem[k], mem[k], mem[k], mem[k]);
        //         k = k + 1;
        // end


endmodule
