module Monitor
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      bledy
   // LOGLEVEL = 2
   //      ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o stalosci przeczekanego sygnalu
   // LOGLEVEL = 4
   //      informuj o oczekiwaniu na przyjecie przez sygnal zadanej wartosci
   // LOGLEVEL = 5
   //      informuj o zastaniu spodziewanego stanu sygnalow
   // LOGLEVEL = 6
   //      zrzuca stan monitorowanej linii z kazdej chwili czasu
   parameter LOGLEVEL = 1,

   // Szerokosc badanej szyny sygnalowej
   //
   parameter N = 1
) (
   input [N-1:0] signals
);

   // Zadanie sprawdza, czy sygnaly sa w zadanym stanie
   task ensure_state
   (
      input [N-1:0] expected_signals,
      output ensurance
   );
      begin

         // Jesli sygnaly sa zgodne z oczekiwaniami, wystawi jedynke
         ensurance = 1'b1;

         if( signals !== expected_signals ) begin

            // Sygnaly sie roznia, wystaw zero
            ensurance = 1'b0;

            // Zglos blad
            if( LOGLEVEL >= 1 )
               $display("%t\t ERROR\t [ %m ] \t Sygnaly nie sa zgodne z oczekiwaniami. Stan obecny '%b' (0x %h), spodziewany '%b' (0x %h)", $time, signals, signals, expected_signals, expected_signals);

         end

         // Zakomunikuj o zastaniu spodziewanych stanow
         if( ensurance )
            if( LOGLEVEL >= 5 )
               $display("%t\t INFO5\t [ %m ] \t Sygnaly sa zgodne z oczekiwaniami. Stan oczekiwany '%b' (0x %h)", $time, expected_signals, expected_signals);

      end
   endtask


   // Zadanie sprawdza czy sygnaly sa w stanie niskim
   task ensure_low
   (
      output ensurance
   );
      begin
         ensure_state( {N{1'b0}}, ensurance );
      end
   endtask


   // Zadanie sprawdza czy sygnaly sa w stanie wysokim
   task ensure_high
   (
      output ensurance
   );
      begin
         ensure_state( {N{1'b1}}, ensurance );
      end
   endtask


   // Zadanie sprawdza czy sygnaly sa w stanie wysokiej impedancji
   task ensure_z
   (
      output ensurance
   );
      begin
         ensure_state( {N{1'bz}}, ensurance );
      end
   endtask

   // Zadanie bada stalosc zadanych sygnalow w ustalonym przedziale czasu
   task ensure_same_during
   (
      input [31:0] period,
      output       ensurance
   );
      integer         i;
      reg [N-1:0] saved_signals;
      begin

         // Jesli stan linii pozostanie bez zmian, wystawi jedynke
         ensurance = 1'b1;

         // Zapisz stan linii z momentu rozpoczecia tego zadania
         saved_signals = signals;

         // Monitoruj linie przez zadany czas lub do momentu pierwszej zmiany stanu
         for(i=0; i<period && ensurance; i=i+1) begin
            if(signals !== saved_signals) begin

               // Sygnal sie zmienil podczas badania, zakoncz zerem
               ensurance = 1'b0;

               // Zglos blad
               if( LOGLEVEL >= 1 )
                  $display("%t\t ERROR\t [ %m ] \t Nastapila nieoczekiwana zmiana stanu monitorowanej linii po czasie %d 000 / %d 000. Stan obecny '%b' (0x %h), spodziewany '%b' (0x %h)", $time, i, period, signals, signals, saved_signals, saved_signals);

            end

            // Wypisz wszystkie iteracje petli na zyczenie ostatniego poziomu logowania
            if( LOGLEVEL >= 9 )
               $display("%t\t INFO9\t [ %m ] \t Stan linii '%b' (0x %h) zapisana '%b' (0x %h) czas %d 000", $time, signals, signals, saved_signals, saved_signals, i);

            // Przejdz do nastepnego kroku czasowego
            #1;

         end

         // Zakomunikuj o oczekiwanej stalosci sygnalu w zadanym czasie
         if( ~ensurance )

            if( LOGLEVEL >= 3 )
               $display("%t\t INFO3\t [ %m ] \t Stan '%b' (0x %h) linii zgodnie z oczekiwaniami nie zmienil sie po czasie %d 000", $time, signals, signals, i);

      end
   endtask


   // Zadanie oczekuje okreslonego stanu badanych linii w nadzorowanym okresie
   task ensure_state_during
   (
      input [31:0] period,
      input [N-1:0] expected_signals,
      output ensurance
    );
      reg    same;
      begin

         if( LOGLEVEL >= 7 )
            $display("%t\t INFO7\t [ %m ] \t Sprawdzanie czy obecny stan sygnalow '%b' (0x %h) bedzie niezmienny i zgodny z oczekiwanym wzorcem '%b' (0x %h) przez zadany czas '%d'", $time, signals, signals, expected_signals, expected_signals, period);

         // Jesli linie pozostaly w zadanym stanie przez okres proby, potwierdzi jedynka
         ensurance = 1'b1;

         // Sprawdz czy od poczatku wystapil stan wzorcowy
         if( signals != expected_signals ) begin

            // Sygnaly roznia sie od wzorca od poczatku, zwroc zero
            ensurance = 1'b0;

            // Zlos blad
            if( LOGLEVEL >= 1 )
               $display("%t\t ERROR\t [ %m ] \t Wszystkie sygnaly juz od poczatku roznia sie od wzorca '%b' (0x %h), natomiast wystapily '%b' (0x %h)", $time, expected_signals, expected_signals, signals, signals);

         end

         // Jesli sygnaly zaczely jako zgodne ze wzorcem, dopilnuj ich niezmiennosci w badanym czasie
         ensure_same_during(period, same);
         if( ensurance && ~same ) begin

            // Co najmniej jedna linia sie poroznila, zwroc zero
            ensurance = 1'b0;

            // Zglos blad
            if( LOGLEVEL >= 1 )
               $display("%t\t ERROR\t [ %m ] \t Sygnaly '%b' (0x %h) nieoczekiwanie rozminely sie ze wzorcem '%b' (0x %h)", $time, signals, signals, expected_signals, expected_signals);
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


   // Zadanie oczekuje stanow wysokiej impedancji na badanych liniach w badanym okresie

   task ensure_z_during
   (
      input [31:0] period,
      output ensurance
   );
      begin

         // Wynikiem badania oraz ewentualnymi komunikatami bledow zajmuje sie zadanie ogolne z wzorcem
         // Jedynie doprecyzuj wzorzec jako wszystkie stany w wysokiej impedancji
         ensure_state_during(period, {N{1'bz}}, ensurance);

      end
   endtask

   // Zadanie czeka na zadany stan
   task wait_for_state
   (
      input [N-1:0] expected_signals
   );
      integer       i;
      // reg     [1023:0]      a;
      begin
         i = 0;

         // Poinformuj o oczekiwaniu na zadany stan
         if( LOGLEVEL >= 4 )
            $display("%t\t INFO4 \t [ %m ] \t Oczekiwanie na przyjecie stanu '%b' (0x %h). Stan obecny '%b' (0x %h)", $time, expected_signals, expected_signals, signals, signals);

         // Oczekuj zadanego stanu
         while( signals !== expected_signals ) begin
            i = i+1;
            #1;
         end

         // Poinformuj o ustaleniu sie zadanego stanu
         if( LOGLEVEL >= 4 )
            $display("%t\t INFO4\t [ %m ] \t Oczekiwany stan  '%b' (0x %h) ustalil sie po czasie %d 000", $time, expected_signals, expected_signals, i);

      end
   endtask


   // Zadanie czeka na ustalenie sie stanu niskiego
   task wait_for_low ();
      begin
         wait_for_state( {N{1'b0}} );
      end
   endtask


   // Zadanie czeka na ustalenie sie stanu wysokiego
   task wait_for_high ();
      begin
         wait_for_state( {N{1'b1}} );
      end
   endtask


   // Zadanie czeka na ustalenie sie stanu wysokiej impedancji
   task wait_for_z ();
      begin
         wait_for_state( {N{1'bz}} );
      end
   endtask


endmodule
