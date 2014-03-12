// Modul sprawdza czy w ustalonym przedziale czasu zadane sygnaly byly zawsze wszystkie niskie, wysokie lub stale

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
                  $display("%t\t ERROR\t [ %m ] \t Nastapila nieoczekiwana zmiana stanu monitorowanej linii po czasie %d. Stan obecny '%b' (0x %h), spodziewany '%b' (0x %h)", $time, i, signals, signals, saved_signals, saved_signals);

            end

            // Wypisz wszystkie iteracje petli na zyczenie ostatniego poziomu logowania

            if( LOGLEVEL >= 9 )
               $display("%t\t INFO9\t [ %m ] \t Stan linii '%b' (0x %h) zapisana '%b' (0x %h) czas %d", $time, signals, signals, saved_signals, saved_signals, i);

            // Przejdz do nastepnego kroku czasowego

            #1;

         end

         // Zakomunikuj o oczekiwanej stalosci sygnalu w zadanym czasie

         if( ~ensurance )

            if( LOGLEVEL >= 3 )
               $display("%t\t INFO3\t [ %m ] \t Stan '%b' (0x %h) linii zgodnie z oczekiwaniami nie zmienil sie po czasie %d", $time, signals, signals, i);

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

   // // Zadanie oczekuje na jakakolwiek zmiane stanu obserwowanych linii

   // task wait_for_change
   // ();
   //    reg     [N-1:0] saved_signals;
   //    integer         i;
   //    begin

   //       // Zapisz stan linii z momentu rozpoczecia tego zadania

   //       saved_signals = signals;

   //       // Poinformuj o oczekiwaniu na zmiane stanu

   //       if( INFO4 )
   //          $display("%t\t INFO4 \t [ %m ] \t Oczekiwanie na zmiane stanu sygnalow. Stan obecny '%b' (0x %h)", $time, signals, signals, i);

   //       // Oczekuj zadanego stanu

   //       while( signals === saved_signals ) begin
   //          i = i+1;
   //          #1;
   //       end

   //       // Poinformuj o nowym stanie

   //       if( INFO4 )
   //          $display("%t\t INFO4\t [ %m ] \t Nastapila zmiana stanu monitorowanych sygnalow. Stan poprzedni '%b' (0x %h). Nowy stan '%b' (0x %h) ustalil sie po czasie %d", $time, saved_signals, saved_signals, signals, signals, i);

   //    end
   // endtask


   // Zadanie czeka na zadany stan

         // reg a [1023:0] = $sformatf("Oczekiwanie na przyjecie stanu %d dd", 10);
   task wait_for_state
   (
      input [N-1:0] expected_signals
   );
      integer       i;
      // reg     [1023:0]      a;
      begin
         i = 0;

         // Poinformuj o oczekiwaniu na zadany stan

         // $sformat(a, "Oczekiwanie na przyjecie stanu %d dd", 10);
         // $display("aa %s", a);
         // a = $sformatf("Oczekiwanie na przyjecie stanu %d dd", 10);
         // a = $psprintf("Oczekiwanie na przyjecie stanu %d dd", 10);
         // logs.info4( a );
         // logs.info4( sprintf("Oczekiwanie na przyjecie stanu %d dd", 10) );
         if( LOGLEVEL >= 4 )
            $display("%t\t INFO4 \t [ %m ] \t Oczekiwanie na przyjecie stanu '%b' (0x %h). Stan obecny '%b' (0x %h)", $time, expected_signals, expected_signals, signals, signals, i);

         // Oczekuj zadanego stanu

         while( signals !== expected_signals ) begin
            i = i+1;
            #1;
         end

         // Poinformuj o ustaleniu sie zadanego stanu

         if( LOGLEVEL >= 4 )
            $display("%t\t INFO4\t [ %m ] \t Oczekiwany stan  '%b' (0x %h) ustalil sie po czasie %d", $time, expected_signals, expected_signals, i);

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
