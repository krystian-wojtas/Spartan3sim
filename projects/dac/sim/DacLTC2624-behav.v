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
   // 	informuje o pomyslnych ustawieniach daca
   // LOGLEVEL = 4
   // 	informuje o stanach linii DAC_CLR i DAC_CS
   // LOGLEVEL = 5
   // 	informuje o adresie daca
   // LOGLEVEL = 6 //TODO del
   // 	debug
   parameter LOGLEVEL      = 5,
   parameter LOGLEVEL_SCK  = 3,
   parameter LOGLEVEL_CS   = 3,
   parameter LOGLEVEL_CLR  = 3,
   parameter LOGLEVEL_MOSI = 3
) (
   input  SPI_SCK,
   input  DAC_CS,
   input  DAC_CLR,
   input  SPI_MOSI,
   output DAC_OUT
);

   // Instancje obserwatorow linii
   Monitor #(
      .LOGLEVEL(LOGLEVEL_SCK),
      .N(1)
   ) monitor_sck (
      .signals( SPI_SCK )
   );
   Monitor #(
      .LOGLEVEL(LOGLEVEL_CS),
      .N(1)
   ) monitor_cs (
      .signals( DAC_CS )
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

   // Instacja ustawiacza zwrotnego
   // Set #(
   //    .LOGLEVEL(LOGLEVEL_OUT),
   //    .N(1)
   // ) set_out (
   //    .signals( DAC_OUT )
   // );

   // Przed uzyciem daca nalezy go najpierw zresetowac poprzez chwilowe obnizenie linii DAC_CLR
   reg 	  inited = 1'b0;
   initial begin

      if(LOGLEVEL >= 4)
         $display("%t INFO4 Oczekiwanie na zresetowanie daca", $time);
      monitor_clr.wait_for_low();
      monitor_clr.ensure_low_during( 40 );
      monitor_clr.wait_for_high();

      if(LOGLEVEL >= 4)
         $display("%t INFO4 Zresetowano daca", $time);
      inited = 1'b1;
   end

   // Sprawdza czy dac zostal zresetowany przed nadaniem danych
   always @(negedge DAC_CS)
      if(inited) begin
         if(LOGLEVEL >= 4)
            $display("%t INFO4 Odbieranie danych", $time);
      end else
         if(LOGLEVEL >= 1)
            $display("%t BLAD Nie zresetowano ukladu przed nadaniem nadanych", $time);

   reg [31:0] conf;
   wire [11:0] data = conf[15:4];
   wire [3:0] address = conf[19:16];
   wire [3:0] command = conf[23:20];
   reg [5:0] conf_idx;

	//Blok odbioru danych z linii SPI_MOSI
	//Reset ukladu (chwilowym obnizeniem DAC_CLR) zeruje glowny rejestr konfigurujacy daca conf oraz jego licznik conf_idx
	//Obnizenie linii DAC_CS powoduje aktywowanie odbioru bitow i doklejanie ich do rejestru przesuwnego conf w takt zegara SPI_SCK
	//Licznik conf_idx zerowany jest gdy transmisja nie jest aktywna.
	//Gdy jest aktywna zwiekszany jest o jeden w takt zegara, co pokazuje aktulna liczbe odebranych bitow

   //
   // always @(negedge DAC_CLR or negedge SPI_SCK) begin
   //    if(~DAC_CLR) begin
   //       conf <= 32'd0;
   //       conf_idx <= 6'd0;
   //    end else
   //       if(DAC_CS) begin
   //          conf_idx <= 6'd0;
   //       end else begin
   //          conf <= { conf[30:0], SPI_MOSI };
   //          conf_idx <= conf_idx + 1;
   //       end
   // end

   // // Licznik conf_idx zerowany jest na poczatku kazdej transmisji
   // always @(negedge DAC_CS)
   //    conf_idx <= 6'd0;


   //
   always @(negedge DAC_CLR or posedge SPI_SCK) begin
      if(~DAC_CLR) begin
         conf_idx <= 6'd0;
      end else begin
         conf_idx <= conf_idx + 1;
      end
   end

   always @(negedge DAC_CLR or negedge SPI_SCK) begin
      if(~DAC_CLR) begin
         conf <= 32'd0;
      end else begin
         conf <= { conf[30:0], SPI_MOSI };
      end
   end

   // Licznik conf_idx zerowany jest na poczatku kazdej transmisji
   always @(negedge DAC_CS)
      conf_idx <= 6'd0;


	//Blok sprawdza czy ilosc odebranych bitow wynosi dokladnie 32
	//Jesli sie zgadza ustawia flage received32bits
	//Flaga ta jest sprawdzana w kolejnym bloku w momencie podniesienia linii DAC_CS, co sygnalizuje koniec transmisji
	//Na tej podstwie moga zostac zglaszane bledy jesli przeslanych bitow jest zbyt malo
   assign received32bits = (conf_idx == 32);

	//Blok wykrywa przeslanie zbyt duzej liczby bitow do daca
	//Flaga receivedtoomanybits jest wygaszana w momencie aktywowania odbioru danych obnizeniem linii DAC_CS
	//Flaga jest podnoszona jesli liczba odebranych bitow przekroczy prawidlowa ilosc 32.
	//Stan podniesionej flagi jest utrzymywany do momentu aktywowania odbioru nowej danej.
	//W tym czasie licznik odebranych bitow conf_idx bedzie sie wielokrotnie przepelniac odbieraja nowe bity,
	// przez co nie bedzie mozna stwierdzic ile bitow za duzo zostalo przeslanych
   reg      receivedtoomanybits = 1'b0;
   always @(negedge DAC_CS)
      receivedtoomanybits <= 1'b0;
   always @*
      if(conf_idx > 32)
         receivedtoomanybits <= 1'b1;

	//Blok obsluguje moment podniesienia linii DAC_CS, co sygnalizuje koniec transmisji
	//Operacje tutaj zawarte sa wykonywane tylko po uprzednim zresetowaniu ukladu
	//Sprawdzana jest ilosc odebranych bitow i wyswietlane sa informacje o bledach jesli bitow nie jest dokladnie 32
	//Jesli ilosc bitow jest wlasciwa, wypisywane sa informacje o odebranej probce z podzialem na wywstawiana wartosc, adres daca i komende
	//Jesli adres daca lub komenda maja nieprawidlowa wartosc, zglaszany jest blad
	//Komenda zawsze powinna miec wartosc 0011
   always @(posedge DAC_CS)
      if(inited) begin
	 // Zakomunikuj koniec odbioru
         if(LOGLEVEL >= 4)
            $display("%t INFO4 Podniesiono flage DAC_CS, co konczy odbior danych", $time);

         if(~received32bits) begin
            //Bledy nieodpowiedniej ilosci odebranych bitow
            if(receivedtoomanybits) begin
               if(LOGLEVEL >= 1)
                  $display("%t BLAD Do daca wyslanych zostalo wiecej bitow niz 32", $time);
            end else
               if(LOGLEVEL >= 1)
                  $display("%t BLAD Do daca wyslanych zostalo %d bitow. Nalezy wyslac 32", $time, conf_idx);

         end else begin
            // Odebrana wlasciwa ilosc bitow
            if(LOGLEVEL >= 4)
               $display("%t INFO4 Odebrane dane zawieraja wlasciwa ilosc bitow", $time);

	    // Wypisz odebrane pola
            if(LOGLEVEL >= 3)
               $display("%t INFO3 Ustawiono\twartosc %d (0x%h)\tna na adresie %d (0x%h)\tz komenda %d (0x%h)", $time, data, data, address, address, command, command);

	    // Wypisz ustawian-ego/-ne dac-a/-i bazujac na przeslanym adresie lub zakomunikuj blad
            case(address)
               4'b0000: if(LOGLEVEL >= 5) $display("%t INFO5 dac adresu %b (0x%h) - ustawi dac A", $time, address, address);
               4'b0001: if(LOGLEVEL >= 5) $display("%t INFO5 dac adresu %b (0x%h) - ustawi dac B", $time, address, address);
               4'b0010: if(LOGLEVEL >= 5) $display("%t INFO5 dac adresu %b (0x%h) - ustawi dac C (mozliwe ustawienie wzmocnienia)", $time, address, address);
               4'b0011: if(LOGLEVEL >= 5) $display("%t INFO5 dac adresu %b (0x%h) - ustawi dac D (mozliwe ustawienie wzmocnienia)", $time, address, address);
               4'b1111: if(LOGLEVEL >= 5) $display("%t INFO5 daci adresu %b (0x%h) - ustawi wszystkie dac-i", $time, address, address);
               default: if(LOGLEVEL >= 1) $display("%t BLAD nieprawidlowy adres daca", $time);
            endcase

	    // Sprawdz czy wyslano wlasciwa komende
            if(command != 4'b0011)
               if(LOGLEVEL >= 1)
                  $display("%t BLAD nieprawidlowa komenda %b (0x%h) - aby natychmiastowo ustawic dac nalezy wyslac 0011 (0x3)", $time, command, command);

         end
      end


	//Na linii wyjsciowej DAC_OUT beda sie pojawiac kolejne bity wypychane z rejestru przesuwnego konfigurujacego daca
	//Nastepuje to w takt zegara SPI_SCK przy obnizonej linii aktywacji transmisji DAC_CS
	//TODO odbieranie ostatniego bitu
	assign DAC_OUT = DAC_CS ? 1'b0 : conf[31];
endmodule
