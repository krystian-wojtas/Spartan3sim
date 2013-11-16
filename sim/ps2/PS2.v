module PS2
#(
   parameter LABEL = "",

   parameter ERROR = 1,
   parameter WARN  = 1,
   parameter INFO1 = 0,
   parameter INFO2 = 0,
   parameter INFO3 = 0,
   parameter INFO4 = 0
) (
   inout ps2c,
   inout ps2d
);

   Set #(
      .LABEL("zegar"),
      .INFO1(1),
      .INFO2(1),
      .INFO3(1),
      .INFO4(1),
      .N(1)
   ) set_ps2c (
      .signals( ps2c )
   );

   Set #(
      .LABEL("dane"),
      .INFO1(1),
      .INFO2(1),
      .INFO3(1),
      .INFO4(1),
      .N(1)
   ) set_ps2d (
      .signals( ps2d )
   );

   Monitor #(
      .LOGLEVEL(5),
      // .LOGLEVEL(9),
      .LABEL("zegar"),
      .N(1)
   ) monitor_ps2c (
      .signals( ps2c )
   );

   Monitor #(
      .LOGLEVEL(5),
      // .LOGLEVEL(9),
      .LABEL("dane"),
      .N(1)
   ) monitor_ps2d (
      .signals( ps2d )
   );

   // reg [31:0] half_period = 32'd1 / 32'd16700 / 32'd2;

   reg [31:0] half_period = 32'd59880;


   // Zadanie odbiera komende od FPGA oczekujac najpierw na rozpoczecie komunikacji ze strony FPGA

   task receive_cmd
   (
      output reg [7:0] cmd
   );
      reg [10:0] received_data;
      reg        parity;
      reg        expected_parity;
      integer    i;
   begin

      // Domyslnym stanem sa wysokie impedancje, ktore poprzez podciagniete otwarte kolektory przekladaja sie na wartosci wysokie na wyjsciach linii

      set_ps2c.z();
      set_ps2d.z();

      // Modul komunikacyjny powinien rowniez zaczac stanami wysokiej impedancji

      #1;

      if( INFO1 )
          $display("%t\t INFO1 %s Sprawdzanie czy FPGA zaczelo prace z liniami zegara i danych w stanach wysokich impedancji", $time, LABEL);

      monitor_ps2c.ensure_z();

      monitor_ps2d.ensure_z();

      // Modul komunikacyjny powinien ustawic tryb strumieniowy myszki, inaczej jest ona niema

      // Odbywa sie to poprzez przeslanie komendy 0xF4 do myszki

      // Aby rozpoczac transmisje do myszki, nalezy przetrzymac linie zegarowa nisko przez co najmniej 100 mikro sekund

      if( INFO1 )
          $display("%t\t INFO1 %s Oczekiwanie na rozpoczecie transmisji przez FPGA", $time, LABEL);

      monitor_ps2c.wait_for_low();

      if( INFO1 )
          $display("%t\t INFO1 %s FPGA rozpoczyna transmisje komendy do myszki", $time, LABEL);

      monitor_ps2c.ensure_low_during( 32'd100000 );

      if( INFO1 )
          $display("%t\t INFO1 %s FPGA wlasciwie zazadalo wytaktowania zegara w celu wyslania swojej komendy", $time, LABEL);

      if( INFO1 )
          $display("%t\t INFO1 %s FPGA powinno zwolnic zegar i reagowac na jego zmiane przez myszke", $time, LABEL);

      // Po tym FPGA musi zwolnic linie zegarowa aby umozliwic wytaktowanie jej przez myszke

      monitor_ps2c.wait_for_z();

      // Upewnij sie, ze rownoczesnie linia danych zostala wysterowana nisko dla pierwszego przesylanego bitu 'zero' rozpoczynajacego transmisje

      if( INFO1 )
          $display("%t\t INFO1 %s W momencie zwalniania zegara linia danych powinno byc wysterowana nisko jako piereszy przesylany bit stopu", $time, LABEL);

      monitor_ps2d.ensure_low();

      // Podaj zegar do FPGA, zbierz kolejne bity przesylanej komendy od FPGA

      // Zegar dostarcza myszka, musi miescic sie w granicach 10 .. 16.7 kHz

      // half_period = 32'd100000 / 32'd16700 / 32'd2;
      half_period = 32'd59880;

      // Odbierz w petli bit startu, 8 bitow danych, bit parzystosci i bit stopu

      for( i = 0; i < 11; i = i+1 ) begin

         // Przeczekaj prawie pol okresu zegara 16.7 kHz, zatrzymaj sie 5 mikrosekund wczesniej, przesylany bit powinnien  byc juz gotowy do zebrania

         if( INFO2 )
             $display("%t\t INFO2 %s Myszka obniza zegar", $time, LABEL);

         set_ps2c.low_during( half_period - 32'd5000 );

         // Odbierz kolejny bit

         if( INFO1 )
             $display("%t\t INFO1 %s Odbieranie bitu nr %d w stanie %b (0x%h) na 5 us przed wystawieniem zbocza narastajacego", $time, LABEL, i, ps2d, ps2d);

         received_data[i] = ps2d;

         // Upewnij sie, ze 5 mikro sekund przed narastajacym zboczem linia danych jest ustabilizowana i nie zmienia swojej wartosci

         if( INFO1 )
             $display("%t\t INFO1 %s Sprawdzanie czy linia danych jest stabilna 5 mikrosekund przed narastajacym zboczem", $time, LABEL);

         monitor_ps2d.ensure_same_during( 32'd5000 );

         // Podnies zegar

         if( INFO2 )
             $display("%t\t INFO2 %s Myszka podnosi zegar", $time, LABEL);

         set_ps2c.high();

         // Upewnij sie, ze 5 mikro sekund po narastajacym zboczu linia danych wciaz jest stabilna trzymajac ta sama wartosc

         if( INFO1 )
             $display("%t\t INFO1 %s Sprawdzanie czy linia danych jest wciaz stabilna 5 mikrosekund po narastajacym zboczu", $time, LABEL);

         monitor_ps2d.ensure_same_during( 32'd5000 );

         // Przeczekaj druga prawie cala polowke okresu zegara wysoko co konczcy cykl odbioru bitu

         if( INFO2 )
             $display("%t\t INFO2 %s Konczenie cyklu wysokiego stanu zegara", $time, LABEL);

         set_ps2c.high_during( half_period - 32'd5000 );

      end

      // Upewnij sie, ze ostatni przeslany bit stopu jest jedynka

      if( INFO1 )
          $display("%t\t INFO1 %s Sprawdzanie czy ostatni bit stopu jest wysoki", $time, LABEL);

      monitor_ps2d.ensure_high();

      // Podaj ostatnie zbocze opadajace modulowi komunikacyjnemu aby zwolnil linie danych

      if( INFO2 )
          $display("%t\t INFO2 %s Wystawienie zbocza opadajacego zegara, aby FPGA zwolnilo linie danych", $time, LABEL);

      set_ps2c.low_during( half_period );

      // Upewnij sie, ze faktycznie linia danych zostala zwolniona

      if( INFO1 )
          $display("%t\t INFO1 %s Sprawdzanie, czy linia danych zostala zwolniona", $time, LABEL);

      monitor_ps2d.ensure_z();

      // W ostatnim cyklu urzadzenie wysterowuje linie danych do zera potwierdzajac poprawny odbior danych

      if( INFO1 )
          $display("%t\t INFO1 %s Ostatni cykl dla potwierdzenia odbioru", $time, LABEL);

      set_ps2d.low();

      set_ps2c.high_during( half_period );

      set_ps2c.low_during( half_period );

      // Zwolnij linie

      if( INFO1 )
          $display("%t\t INFO1 %s Zwalnianie linii sygnalowej i danych", $time, LABEL);

      set_ps2c.z();

      set_ps2d.z();

      // Cykl odbioru komendy zostal zakonczony

      if( INFO1 )
          $display("%t\t INFO1 %s Pomyslnie zakonczono odbior danych", $time, LABEL);

      // Przepisz dane

      cmd = received_data[8:1];

      parity = received_data[9];

      // Sprawdz poprawnosc danych

      if( INFO1 )
          $display("%t\t INFO1 %s Sprawdzanie poprawnosci odebranych danych", $time, LABEL);

      // Policz parzystosc

      if( INFO1 )
          $display("%t\t INFO1 %s Sprawdzanie poprawnosci bitu parzystosci", $time, LABEL);

      expected_parity = ~(^cmd);

      if( parity != expected_parity ) begin
         if( ERROR )
             $display("%t\t BLAD %s Przeslany bit parzystosci nie zgadza sie z otrzymanymi danymi", $time, LABEL);
      end

   end
   endtask

endmodule
