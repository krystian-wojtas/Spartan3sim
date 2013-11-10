// Modul sprawdza czy w ustalonym przedziale czasu zadane sygnaly byly zawsze wszystkie niskie, wysokie lub stale

module Monitor
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //
   // LOGLEVEL = 4
   //
   // LOGLEVEL = 5
   //      zrzuca stan monitorowanej linii z kazdej chwili czasu
   // LOGLEVEL = 6
   //
   parameter LOGLEVEL = 1,

   // Szerokosc badanej szyny sygnalowej
   //
   parameter N=1
) (
   input [N:1] signals
);

   // Zadanie bada stalosc zadanych sygnalow w ustalonym przedziale czasu

   task is_changed_during
   (
      input [31:0] period,
      output       changed
   );
      integer         i;
      reg [N-1:0] saved_signals;
      begin

         // Jesli stan linii pozostanie bez zmian, wystawi zero

         changed = 1'b0;

         // Zapisz stan linii z momentu rozpoczecia tego zadania

         saved_signals = signals;

         // Monitoruj linie przez zadany czas lub do momentu pierwszej zmiany stanu

         for(i=0; i<period && ~changed; i=i+1) begin
            if(signals != saved_signals) begin

               // Sygnal sie zmienil podczas badania, zakoncz jedynka

               changed = 1'b1;

               // Zglos blad

               if( LOGLEVEL >= 1 )
                  $display("%t\t BLAD Nastapila nieoczekiwana zmiana stanu monitorowanej linii po czasie %d. Stan obecny %b, spodziewany %b", $time, i, signals, saved_signals);

            end

            // Wypisz wszystkie iteracje petli na zyczenie ostatniego poziomu logowania

            if( LOGLEVEL >= 5 )
               $display("%t\t INFO5 Stan linii %b zapisana %b czas %d", $time, signals, saved_signals, i);

            // Poczekaj na nastepny krok czasowy

            #1;

         end
      end
   endtask


   // Zadanie oczekuje okreslonego stanu badanych linii w nadzorowanym okresie

   task ensure_state_during
   (
      input [31:0] period,
      input [N-1:0] expected_signals,
      output ensurance
    );
      reg    changed;
      begin

         // Jesli linie pozostaly w zadanym stanie przez okres proby, potwierdzi jedynka

         ensurance = 1'b1;

         // Sprawdz czy od poczatku wystapil stan wzorcowy

         if( signals != expected_signals ) begin

            // Sygnaly roznia sie od wzorca od poczatku, zwroc zero

            ensurance = 1'b0;

            // Zlos blad

            if( LOGLEVEL >= 1 )
               $display("%t\tBLAD Wszystkie sygnaly juz od poczatku roznia sie od wzorca $b (%h), natomiast wystapily %b (%h)", $time, expected_signals, expected_signals, signals, signals);

         end

         // Jesli sygnaly zaczely jako zgodne ze wzorcem, dopilnuj ich niezmiennosci w badanym czasie

         is_changed_during(period, changed);
         if( ensurance && changed ) begin

            // Co najmniej jedna linia sie poroznila, zwroc zero

            ensurance = 1'b0;

            // Zglos blad

            if( LOGLEVEL >= 1 )
               $display("%t\t Sygnaly %b (%h) nieoczekiwanie rozminely sie ze wzorcem %b (%h)", $time, signals, signals, expected_signals, expected_signals);
         end

      end
   endtask


   // Zadanie oczekuje stanow niskich na badanych liniach w badanym okresie

   task ensure_low_during
   (
      input [31:0] period,
      output ensurance
   );
      begin

         // Wynikiem badania oraz ewentualnymi komunikatami bledow zajmuje sie zadanie ogolne z wzorcem

         // Jedynie doprecyzuj wzorzec jako wszystkie stany niskie

         ensure_state_during(period, {N{1'b0}}, ensurance);

      end
   endtask


   // Zadanie oczekuje stanow wysokich na badanych liniach w badanym okresie

   task ensure_high_during
   (
      input [31:0] period,
      output ensurance
   );
      begin

         // Wynikiem badania oraz ewentualnymi komunikatami bledow zajmuje sie zadanie ogolne z wzorcem

         // Jedynie doprecyzuj wzorzec jako wszystkie stany wysokie

         ensure_state_during(period, {N{1'b1}}, ensurance);

      end
   endtask


endmodule
