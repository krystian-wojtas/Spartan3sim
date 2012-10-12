`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:18:18 07/24/2012 
// Design Name: 
// Module Name:    AmpLTC6912-1-behav 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


// LOGLEVEL = 0
// 	bez zadnych komunikatow
// LOGLEVEL = 1
// 	pokazuje bledy
// LOGLEVEL = 2
// 	pokazuje ostrzezenia
//
// LOGLEVEL = 3
// 	informuje o pomyslnych ustawieniach ampa
// LOGLEVEL = 4
// 	informuje o stanach linii AMP_SHDN i AMP_CS
// LOGLEVEL = 5
// 	informuje o zmianach zegara
// LOGLEVEL = 6 //TODO del
// 	debug
module AmpLTC6912_1_behav
#(
	parameter LOGLEVEL=5
) (
	input SPI_SCK,
	input SPI_MOSI,
	input AMP_CS,
	input AMP_SHDN,
	output AMP_DOUT
	
);

	//Przed uzyciem wzmacniacza nalezy go najpierw zresetowac
	//Resetowany on jest pozytywnym zboczem linii AMP_SHDN
	//W rejestrze reseting nastepuje zapamietanie faktu zainicjowania poczatkowego resetowania
	//UWAGA: Obsluga wzmacniacza bez poczatkowego resetu nie bedzie symulowana
	reg reseting = 1'b0;
	always @(posedge AMP_SHDN) begin
		reseting = 1'b1;
		if(LOGLEVEL >= 4)
			$display("%t INFO4 resetowanie amp", $time);
	end
	
	//W bloku sprawdzane jest czy po poczatkowym resecie linia AMP_SHDN powrocila do stanu niskiego
	//Jesli tak, rejestr reseted przyjmuje wartosc wysoka i mozna przystapic do obslugi ampa
	//TODO odczekanie cykli zegarowych pomiedzy obnizeniem o podniesieniem??	
	reg reseted = 1'b0;
	always @(negedge AMP_SHDN)
		if(reseting) begin
			reseted = 1'b1;
			if(LOGLEVEL >= 4)
				$display("%t INFO4 zresetowano amp", $time);
			if(LOGLEVEL >= 1)
				if(~AMP_CS)
					$display("%t BLAD Podczas resetowania ukladu linia AMP_CS powinna byc w stanie wysokim", $time); //TODO po ilu cyklach mozna wysylac dane?
		end
	
	//Aktywacja odbioru danych nastepuje przez obnizenie linii AMP_CS
	//Nie mozna zaczac odbierac danych bez uprzedniego zresetowania ukladu
	always @(negedge AMP_CS) begin
		if(~reseted)
			if(LOGLEVEL >= 1)
				$display("%t BLAD Nastepuje proba przesylnia danych, bez uprzedniego zresetowania ukladu", $time);			
	end
	
	
	always @(posedge SPI_SCK)
		if(LOGLEVEL >= 5)
			$display("%t INFO5 AMP zegar sie podnosi", $time);
	
	always @(negedge SPI_SCK)
		if(LOGLEVEL >= 5)
			$display("%t INFO5 AMP zegar sie obniza", $time);
	
	
	//TODO opuszczajac AMP_CS zegar niski
	//TODO moment odczekania 30ns miedzy opuszczeniem AMP_CS a pierwszym pozytywnym zboczem zegara
	
	
	reg [7:0] shiftreg_in = 8'd0;
	wire [3:0] amp_b = shiftreg_in[3:0];
	wire [3:0] amp_a = shiftreg_in[7:4];
	//rejestr licznika jest poszerzony o jeden bit w celu wykrycia bledu odbierania zbyt wielu bitow
	reg [3:0] shiftreg_idx = 4'd0;
	
	reg [7:0] shiftreg_out = 8'd0;
	
	//Blok odbioru danych z linii SPI_MOSI
	//Reset ukladu (chwilowym podniesieniem AMP_SHDN) zeruje glowny rejestr konfigurujacy ampa shiftreg_in oraz jego licznik shiftreg_idx
	//Obnizenie linii AMP_CS powoduje aktywowanie odbioru bitow i doklejanie ich do rejestru przesuwnego shiftreg_in w takt zegara SPI_SCK
	//Licznik shiftreg_idx zerowany jest gdy transmisja nie jest aktywna.
	//Gdy jest aktywna zwiekszany jest o jeden w takt zegara, co pokazuje aktulna liczbe odebranych bitow
	always @(AMP_SHDN) begin
//		shiftreg_in <= 8'd0;
//		shiftreg_out <= 8'd0;
		shiftreg_idx <= 4'd0;
	end
	
	always @(posedge SPI_SCK) begin
		shiftreg_in <= { shiftreg_in[6:0], SPI_MOSI };
		shiftreg_idx <= shiftreg_idx + 1;
		if(LOGLEVEL >= 4)
			$display("%t INFO4 AMP Odebrano bit %d", $time, SPI_MOSI);
	end
	
	always @(negedge AMP_CS) begin
		shiftreg_idx <= 4'd0;	
		shiftreg_out <= shiftreg_in;
	end
	
	always @(negedge SPI_SCK) begin
		shiftreg_out <= { shiftreg_out[6:0], 1'b0 };
		if(LOGLEVEL >= 4)
			$display("%t INFO4 Wysylany bit %d", $time, shiftreg_out[6]);
	end
		
	
	//Blok sprawdza czy ilosc odebranych bitow wynosi dokladnie 8
	//Jesli sie zgadza ustawia flage received8bits
	//Flaga ta jest sprawdzana w kolejnym bloku w momencie podniesienia linii AMP_CS, co sygnalizuje koniec transmisji
	//Na tej podstwie moga zostac zglaszane bledy jesli przeslanych bitow jest zbyt malo
	wire received8bits = (shiftreg_idx == 8);
	
	//Blok wykrywa przeslanie zbyt duzej liczby bitow do ampa
	//Flaga receivedtoomanybits jest wygaszana w momencie aktywowania odbioru danych obnizeniem linii AMP_CS
	//Flaga jest podnoszona jesli liczba odebranych bitow przekroczy prawidlowa ilosc 8.
	//Stan podniesionej flagi jest utrzymywany do momentu aktywowania odbioru nowej danej.
	//W tym czasie licznik odebranych bitow shiftreg_idx bedzie sie wielokrotnie przepelniac odbieraja nowe bity,
	// przez co nie bedzie mozna stwierdzic ile bitow za duzo zostalo przeslanych
	wire receivedtoomanybits = (shiftreg_idx > 8);	
	
	always @(negedge AMP_CS)
		if(reseted)
			if(LOGLEVEL >= 4)
				$display("%t INFO4 Odbieranie danych", $time);
	
	//Blok obsluguje moment podniesienia linii AMP_CS, co sygnalizuje koniec transmisji
	//Operacje tutaj zawarte sa wykonywane tylko po uprzednim zresetowaniu ukladu
	//Sprawdzana jest ilosc odebranych bitow i wyswietlane sa informacje o bledach jesli bitow nie jest dokladnie 8
	//Jesli ilosc bitow jest wlasciwa, wypisywane sa informacje o odebranej probce z podzialem na wywstawiana wartosc, adres ampa i komende
	//Jesli adres ampa lub komenda maja nieprawidlowa wartosc, zglaszany jest blad
	//Komenda zawsze powinna miec wartosc 0011
	always @(posedge AMP_CS)
		if(reseted) begin
		
			if(~received8bits) begin
			//Bledy nieodpowiedniej ilosci odebranych bitow
				if(receivedtoomanybits) begin
					if(LOGLEVEL >= 1)
						$display("%t BLAD Do ampa wyslanych zostalo wiecej bitow niz 8", $time);
				end else
					if(LOGLEVEL >= 1)		
						$display("%t BLAD Do ampa wyslanych zostalo %d bitow. Nalezy wyslac 8", $time, shiftreg_idx);
			
			
			end else begin
			//Odebrana wlasciwa ilosc bitow
				if(LOGLEVEL >= 4)
					$display("%t INFO4 Zakonczenie odbioru danych", $time);
				if(LOGLEVEL >= 3) begin
					$display("%t INFO3 ustawiono\tliczbe %d (0x%h)\tna ampu A", $time, amp_a, amp_a);
					$display("%t INFO3 ustawiono\tliczbe %d (0x%h)\tna ampu B", $time, amp_b, amp_b);					
				end
								
				//TODO task/function
				case(amp_a)
					4'b0001: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 0.4 - 2.9V", $time);
					4'b0010: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 1.025 - 2.275V", $time);
					4'b0011: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 1.4 - 1.9V", $time);
					4'b0100: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 1.525 - 1.725V", $time);
					4'b0101: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 1.5875 - 1.7125V", $time);
					4'b0110: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 1625. - 1.675V", $time);
					4'b0111: if(LOGLEVEL >= 5) $display("%t INFO5 amp A - zakres 1.6375 - 1.6625", $time);
					default: if(LOGLEVEL >= 1) $display("%t BLAD nieprawidlowa wartosc na ampie A", $time);
				endcase
				
				case(amp_b)
					4'b0001: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 0.4 - 2.9V", $time);
					4'b0010: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 1.025 - 2.275V", $time);
					4'b0011: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 1.4 - 1.9V", $time);
					4'b0100: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 1.525 - 1.725V", $time);
					4'b0101: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 1.5875 - 1.7125V", $time);
					4'b0110: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 1625. - 1.675V", $time);
					4'b0111: if(LOGLEVEL >= 5) $display("%t INFO5 amp B - zakres 1.6375 - 1.6625", $time);
					default: if(LOGLEVEL >= 1) $display("%t BLAD nieprawidlowa wartosc na ampie B", $time);
				endcase
				
			end			
		end


	//Na linii wyjsciowej AMP_DOUT beda sie pojawiac kolejne bity wypychane z rejestru przesuwnego konfigurujacego ampa
	//Nastepuje to w takt zegara SPI_SCK przy obnizonej linii aktywacji transmisji AMP_CS
	//TODO odbieranie ostatniego bitu
	assign AMP_DOUT = AMP_CS ? 1'b0 : shiftreg_out[7];
endmodule
