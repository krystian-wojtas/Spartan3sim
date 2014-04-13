module DacLTC2624Behav
#(
   // LOGLEVEL = 0
   // 	bez zadnych komunikatow
   // LOGLEVEL = 1
   // 	pokazuje bledy
   // LOGLEVEL = 2
   // 	pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   // 	informuje o odbieraniu danych i ich interpretacji
   // LOGLEVEL = 4
   // 	informuje o wlasciwej liczbie bitow w pakiecie
   // LOGLEVEL = 5
   // 	informuje o adresie daca
   // LOGLEVEL = 6
   // 	informuje o odbiorze danych (moment podniesienia flagi DAC_CS)
   // LOGLEVEL = 7
   // 	informuje o przebiegu resetowania daca
   parameter LOGLEVEL      = 5,
   parameter LOGLEVEL_SCK  = 3,
   parameter LOGLEVEL_CLR  = 3,
   parameter LOGLEVEL_MOSI = 3,
   parameter LOGLEVEL_SCK_MOSI = 3
) (
   input  SPI_SCK,
   input  DAC_CS,
   input  DAC_CLR,
   input  SPI_MOSI,
   output DAC_OUT
);

   // Instancja obserwatora linii resetu
   Monitor #(
      .LOGLEVEL(LOGLEVEL_SCK),
      .N(1)
   ) monitor_sck (
      .signals( SPI_SCK )
   );
   Monitor #(
      .LOGLEVEL(LOGLEVEL_CLR),
      .N(1)
   ) monitor_clr (
      .signals( DAC_CLR )
   );
   Monitor #(
      .LOGLEVEL(LOGLEVEL_MOSI),
      .N(1)
   ) monitor_mosi (
      .signals( SPI_MOSI )
   );
   Monitor #(
      .LOGLEVEL(LOGLEVEL_SCK_MOSI),
      .N(2)
   ) monitor_sck_mosi (
      .signals( { SPI_SCK, SPI_MOSI } )
   );

   // Przed uzyciem daca nalezy go najpierw zresetowac poprzez chwilowe obnizenie linii DAC_CLR
   reg 	  inited = 1'b0;
   initial begin

      if(LOGLEVEL >= 7)
         $display("%t\t INFO7\t [ %m ] \t Oczekiwanie na zresetowanie daca", $time);
      monitor_clr.wait_for_low();
      monitor_clr.ensure_low_during( 40 );
      monitor_clr.wait_for_high();

      if(LOGLEVEL >= 7)
         $display("%t\t INFO7\t [ %m ] \t Zresetowano daca", $time);
      inited = 1'b1;
   end

   // Rejest zlicza kolejno odbierane bity
   reg [5:0] idx = 6'd0;
   // Licznik idx zerowany jest na poczatku kazdej transmisji
   always @(negedge DAC_CS)
      idx <= 6'd0;
   // Resetuj licznik lub go podbij na kazdym narastajacym zboczu zegara
   always @(posedge SPI_SCK) begin
      idx <= idx + 1;
   end

   // Odbiera jeden bit
   task receive_bit
   (
      output received_bit
   );
      begin
         // if(LOGLEVEL >= 7)
         //    $display("%t\t INFO7\t [ %m ] \t Odbieranie kolejnego bitu", $time);

	 // Po wlaczeniu daca do szyny spi zegar powinien zaczac nisko
         monitor_sck.ensure_low_during( 40 );
         monitor_sck.wait_for_high();

	 // 4ns stabilnosci zegara i zczytywanej linii miso
	 monitor_sck_mosi.ensure_state_during( 4 );
	 received_bit = SPI_MOSI;

	 // konczenie okresu zegara
	 monitor_sck.ensure_high_during( 40 - 4 );
	 monitor_sck.wait_for_low();

         // if(LOGLEVEL >= 8)
         //    $display("%t\t INFO8\t [ %m ] \t Odebrano bit %b", $time, received_bit);
      end
   endtask

   // Pola bitowe otrzymanych danych
   reg [ 3:0] dontcare4 = 4'd0;
   reg [11:0] value     = 12'd0;
   reg [ 3:0] address   = 4'd0;
   reg [ 3:0] command   = 4'd0;
   reg [ 8:0] dontcare8 = 8'd0;
   wire [31:0] packet = { dontcare4, value, address, command, dontcare8 };
   // Odbiera 32 bity danych pakietu
   task receive_packet
   ();
      integer i;
      begin
         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odbieranie pakietu", $time);

	 // Receive 8 dont care bits
         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odbieranie 8 pierwszych nie znaczacych bitow", $time);
	 for(i = 0; i < 8; i=i+1) begin
            receive_bit( dontcare8[i] );
	 end

	 // Receive command
         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odbieranie komendy", $time);
	 for(i = 0; i < 4; i=i+1) begin
            receive_bit( command[i] );
	 end

	 // Receive address of dac
         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odbieranie adresu", $time);
	 for(i = 0; i < 4; i=i+1) begin
            receive_bit( address[i] );
	 end

	 // Receive 12 bit of value
         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odbieranie wartosci", $time);
	 for(i = 0; i < 12; i=i+1) begin
            receive_bit( value[i] );
	 end

	 // Receive 4 dont care bits
         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odbieranie 4 ostatnich nie znaczacych bitow", $time);
	 for(i = 0; i < 4; i=i+1) begin
            receive_bit( dontcare4[i] );
	 end

         if(LOGLEVEL >= 8)
            $display("%t\t INFO8\t [ %m ] \t Odebrano pakiet", $time);
      end
   endtask

   reg received_packet = 1'b0;
   // Odbiera pakiet i wyzwala o tym flage
   always @(negedge DAC_CS)
      if(!inited) begin
         if(LOGLEVEL >= 1)
            $display("%t\t BLAD\t [ %m ] \t Nie zresetowano ukladu przed nadaniem nadanych", $time);
      end else begin
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3\t [ %m ] \t Odbieranie danych", $time);

	 received_packet = 1'b0;

	 //
	 receive_packet();

	 //
	 received_packet = 1'b1;

      end

   // Zatrzaskuje moment przeslania zbyt wielu bitow
   reg too_many_bits = 1'b0;
   always @(negedge DAC_CS)
      too_many_bits = 1'b0;
   always @(posedge received_packet) begin
      // if(received_packet) begin
         monitor_sck.wait_for_low();
         monitor_sck.wait_for_high();

         too_many_bits = 1'b1;
      // end
   end
   wire received_too_many_bits = received_packet && too_many_bits;

   // Podniesienie DAC_CS konczy transmisje, weryfikowane i wypisywane sa przeslane dane
   always @(posedge DAC_CS) begin
      if(inited) begin

         // Zakomunikuj koniec odbioru
         if(LOGLEVEL >= 6)
            $display("%t\t INFO6\t [ %m ] \t Podniesiono flage DAC_CS, co konczy odbior danych", $time);

         //Bledy nieodpowiedniej ilosci odebranych bitow
         if(received_too_many_bits) begin
            if(LOGLEVEL >= 1)
               $display("%t\t BLAD\t [ %m ] \t Do daca wyslanych zostalo wiecej bitow niz 32", $time);
         end else if(idx < 32) begin
            if(LOGLEVEL >= 1)
               $display("%t\t BLAD\t [ %m ] \t Do daca wyslanych zostalo %d bitow. Nalezy wyslac 32", $time, idx);

         // Odebrano wlasciwa ilosc bitow, parsuj dane
         end else begin

            if(LOGLEVEL >= 4)
               $display("%t\t INFO4\t [ %m ] \t Odebrane dane zawieraja wlasciwa ilosc bitow", $time);

               // Wypisz odebrane pola
               if(LOGLEVEL >= 3)
                  $display("%t\t INFO3\t [ %m ] \t Ustawiono\twartosc %d (0x%h)\tna adresie %d (0x%h)\tz komenda %d (0x%h)", $time, value, value, address, address, command, command);

               // Wypisz ustawian-ego/-ne dac-a/-i bazujac na przeslanym adresie lub zakomunikuj blad
               case(address)
                  4'b0000:
                     if(LOGLEVEL >= 5)
                        $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem A", $time, address, address);
                  4'b0001:
                     if(LOGLEVEL >= 5)
                        $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem B", $time, address, address);
                  4'b0010:
                     if(LOGLEVEL >= 5)
                        $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem C (mozliwe ustawienie wzmocnienia)", $time, address, address);
                  4'b0011:
                     if(LOGLEVEL >= 5)
                        $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem D (mozliwe ustawienie wzmocnienia)", $time, address, address);
                  4'b1111:
                     if(LOGLEVEL >= 5)
                        $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) odpowiada wszystkim dac-om", $time, address, address);
                  default:
                     if(LOGLEVEL >= 1)
                        $display("%t\t BLAD\t [ %m ] \t Nieprawidlowy adres daca", $time);
               endcase

               // Sprawdz czy wyslano wlasciwa komende, jedyna poprawna to 0011
               // Odbierana komenda jest w odwroconym porzadku bitow
               if(command != 4'b1100)
                  if(LOGLEVEL >= 1)
                     $display("%t\t BLAD\t [ %m ] \t Nieprawidlowa komenda %b (0x%h) - aby natychmiastowo ustawic dac nalezy wyslac 0011 (0x3)", $time, command, command);

         end
      end
   end

   // Na linii wyjsciowej DAC_OUT beda sie pojawiac kolejne bity wypychane z rejestru przesuwnego daca
   // Nastepuje to na narastajacym zboczu zegara SPI_SCK przy obnizonej linii aktywacji transmisji DAC_CS
   assign DAC_OUT = DAC_CS ? 1'b0 : packet[31];

endmodule
