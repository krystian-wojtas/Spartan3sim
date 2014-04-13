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
   parameter LOGLEVEL_CLR  = 3
) (
   input  SPI_SCK,
   input  DAC_CS,
   input  DAC_CLR,
   input  SPI_MOSI,
   output DAC_OUT
);

   // Instancja obserwatora linii resetu
   Monitor #(
      .LOGLEVEL(LOGLEVEL_CLR),
      .N(1)
   ) monitor_clr (
      .signals( DAC_CLR )
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

   // Sprawdza czy dac zostal zresetowany przed nadaniem danych
   always @(negedge DAC_CS)
      if(inited) begin
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3\t [ %m ] \t Odbieranie danych", $time);
      end else
         if(LOGLEVEL >= 1)
            $display("%t\t BLAD\t [ %m ] \t Nie zresetowano ukladu przed nadaniem nadanych", $time);

   // Rejest zlicza kolejno odbierane bity
   reg [5:0] conf_idx;
   // W rejestrze przesuwnym zapisywane sa odbierane bity
   reg [31:0] conf;
   // Pola bitowe otrzymanych danych
   wire [11:0] data = conf[15:4];
   wire [3:0] address = conf[19:16];
   wire [3:0] command = conf[23:20];

   // Licznik conf_idx zerowany jest na poczatku kazdej transmisji
   always @(negedge DAC_CS)
      conf_idx <= 6'd0;

   // Resetuj licznik lub go podbij na kazdym narastajacym zboczu zegara
   always @(negedge DAC_CLR or posedge SPI_SCK) begin
      if(~DAC_CLR) begin
         conf_idx <= 6'd0;
      end else begin
         conf_idx <= conf_idx + 1;
      end
   end

   // Resetuj rejestr odbiorczy lub go przesun na kazdym opadajacym zboczu zegara
   always @(negedge DAC_CLR or negedge SPI_SCK) begin
      if(~DAC_CLR) begin
         conf <= 32'd0;
      end else begin
         conf <= { conf[30:0], SPI_MOSI };
      end
   end

   // Sprawdz czy odebrano 32 bity
   assign received32bits = (conf_idx == 32);

   // Zatrzaskuje moment przeslania zbyt wielu bitow
   reg      receivedtoomanybits = 1'b0;
   always @(negedge DAC_CS)
      receivedtoomanybits <= 1'b0;
   always @*
      if(conf_idx > 32)
         receivedtoomanybits <= 1'b1;

   // Podniesienie DAC_CS konczy transmisje, weryfikowane i wypisywane sa przelane dane
   always @(posedge DAC_CS)
      if(inited) begin
	 // Zakomunikuj koniec odbioru
         if(LOGLEVEL >= 6)
            $display("%t\t INFO6\t [ %m ] \t Podniesiono flage DAC_CS, co konczy odbior danych", $time);

         if(~received32bits) begin
            //Bledy nieodpowiedniej ilosci odebranych bitow
            if(receivedtoomanybits) begin
               if(LOGLEVEL >= 1)
                  $display("%t\t BLAD\t [ %m ] \t Do daca wyslanych zostalo wiecej bitow niz 32", $time);
            end else
               if(LOGLEVEL >= 1)
                  $display("%t\t BLAD\t [ %m ] \t Do daca wyslanych zostalo %d bitow. Nalezy wyslac 32", $time, conf_idx);

         end else begin
            // Odebrana wlasciwa ilosc bitow
            if(LOGLEVEL >= 4)
               $display("%t\t INFO4\t [ %m ] \t Odebrane dane zawieraja wlasciwa ilosc bitow", $time);

	    // Wypisz odebrane pola
            if(LOGLEVEL >= 3)
               $display("%t\t INFO3\t [ %m ] \t Ustawiono\twartosc %d (0x%h)\tna na adresie %d (0x%h)\tz komenda %d (0x%h)", $time, data, data, address, address, command, command);

	    // Wypisz ustawian-ego/-ne dac-a/-i bazujac na przeslanym adresie lub zakomunikuj blad
            case(address)
               4'b0000: if(LOGLEVEL >= 5) $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem A", $time, address, address);
               4'b0001: if(LOGLEVEL >= 5) $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem B", $time, address, address);
               4'b0010: if(LOGLEVEL >= 5) $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem C (mozliwe ustawienie wzmocnienia)", $time, address, address);
               4'b0011: if(LOGLEVEL >= 5) $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) jest dac-iem D (mozliwe ustawienie wzmocnienia)", $time, address, address);
               4'b1111: if(LOGLEVEL >= 5) $display("%t\t INFO5\t [ %m ] \t Dac o adresie %b (0x%h) odpowiada wszystkim dac-om", $time, address, address);
               default: if(LOGLEVEL >= 1) $display("%t\t BLAD\t [ %m ] \t Nieprawidlowy adres daca", $time);
            endcase

	    // Sprawdz czy wyslano wlasciwa komende, jedyna poprawna to 0011
            if(command != 4'b0011)
               if(LOGLEVEL >= 1)
                  $display("%t\t BLAD\t [ %m ] \t Nieprawidlowa komenda %b (0x%h) - aby natychmiastowo ustawic dac nalezy wyslac 0011 (0x3)", $time, command, command);

         end
      end

   // Na linii wyjsciowej DAC_OUT beda sie pojawiac kolejne bity wypychane z rejestru przesuwnego daca
   // Nastepuje to na opadajacym zboczu zegara SPI_SCK przy obnizonej linii aktywacji transmisji DAC_CS
   assign DAC_OUT = DAC_CS ? 1'b0 : conf[31];

endmodule
