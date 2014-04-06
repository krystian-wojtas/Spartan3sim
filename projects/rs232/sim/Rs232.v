module Rs232
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   //
   // LOGLEVEL = 3
   //      informuje o wyslaniu/otrzymaniu danych
   parameter LOGLEVEL = 3,
   parameter LOGLEVEL_BEHAV=3,
   parameter LOGLEVEL_BEHAV_RX=3,
   parameter LOGLEVEL_BEHAV_TX=3
) (
   input rx,
   output tx
);

   Rs232_behav #(
      .LOGLEVEL(LOGLEVEL_BEHAV),
      .LOGLEVEL_RX(LOGLEVEL_BEHAV_RX),
      .LOGLEVEL_TX(LOGLEVEL_BEHAV_TX)
   ) rs232_behav (
      .rx(rx),
      .tx(tx)
   );

   localparam CHARS = 10;
   reg [7:0] mem [CHARS:0];
   initial begin
      mem[0] = "H";
      mem[1] = "E";
      mem[2] = "L";
      mem[3] = "L";
      mem[4] = "O";
      mem[5] = " ";
      mem[6] = "R";
      mem[7] = "S";
      mem[8] = "2";
      mem[9] = "3";
      mem[10]= "2";
   end

   integer j = 0;
   initial begin

      // poczatkowe opoznienie
      #10_000;

      // wyslanie kolejnych liter napisu powitalnego
      for(j=0; j<CHARS; j=j+1) begin
         rs232_behav.transmit( mem[j] );
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wyslano bajt '%b' (0x %h) (dec %d) (ascii %s)", $time, mem[j], mem[j], mem[j], mem[j]);
      end
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
         rs232_behav.receive( byte_received );
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Odebrano bajt '%b' (0x %h) (dec %d) (ascii %s)", $time, byte_received, byte_received, byte_received, byte_received);

         // weryfikacja
         if( byte_received != mem[k] )
            if(LOGLEVEL >= 1)
               $display("%t\t ERROR [ %m ] \t Odebrany bajt %b 0x%h %d %s rozni sie od wyslanego wzorca %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received, mem[k], mem[k], mem[k], mem[k]);

         // inkrementuj numer biezacego bajtu
         k = k + 1;
     end
  end

endmodule
