module Keyboard_behav
#(
   // LOGLEVEL = 0
   //      bez zadnych komunikatow
   // LOGLEVEL = 1
   //      pokazuje bledy
   // LOGLEVEL = 2
   //      pokazuje ostrzezenia
   //
   // LOGLEVEL = 3
   //      informuje o wcisnieciu / zwolnieniu / przytrzymaniu dedykowanych zadan
   // LOGLEVEL = 4
   //      informuje o wcisnieciu / zwolnieniu / przytrzymaniu zadan ogolnych
   // LOGLEVEL = 5
   //      informuje o wyslaniu/otrzymaniu pelnego bajtu
   // LOGLEVEL = 6
   //      informuje o wysylaniu/otrzymywaniu poszczegolnych bitow
   // LOGLEVEL = 7
   //      informuje o wyslaniu/otrzymywaniue start i stop bitow
   //
   parameter LOGLEVEL=5,
   parameter LOGLEVEL_CLK=1,
   parameter LOGLEVEL_DATA=1
) (
   output  clk,
   output  data
);

   // czas polowy okresu
   localparam HALF_PERIOD = 40_000;
   // opoznienie
   localparam QUARTER_PERIOD = HALF_PERIOD / 2;

   Set #(
      .LOGLEVEL(LOGLEVEL_CLK),
      .N(1)
   ) set_clk (
      .signals( clk )
   );

   Set #(
      .LOGLEVEL(LOGLEVEL_DATA),
      .N(1)
   ) set_data (
      .signals( data )
   );

   // Stany jalowe sa wysokie
   initial begin
      set_clk.high();
      set_data.high();
   end

   // Zadanie wysyla przekazany bajt wraz z poprzedajacym bitem startu i nastepujacymi parzystości oraz stopu
   task send_
   (
      input [7:0] scancode
   );
      integer     i;
      reg 	  odd;
      reg [8:0]   frame;
      begin

         // Zalogowanie poczatku transmisji
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Wysylanie bajtu '%b' (0x %h)", $time, scancode, scancode);

         // Start bit
         if(LOGLEVEL >= 7)
            $display("%t\t INFO7 [ %m ] \t Rozpoczecie transmisji, start bit 0", $time);
         set_data.low_during( QUARTER_PERIOD );

	 set_clk.low_during( HALF_PERIOD );

         set_clk.high_during( QUARTER_PERIOD );

	 odd = ~^ scancode;
	 // odd = 1'b0;
	 frame = { odd, scancode[7:0] };

         // Przekazany bajt
         for(i=0; i < 9; i=i+1) begin

            set_data.state_during( QUARTER_PERIOD, frame[i] );

            set_clk.low_during( HALF_PERIOD );

            set_clk.high_during( QUARTER_PERIOD );

            if(LOGLEVEL >= 6)
               $display("%t\t INFO6 [ %m ] \t Wyslano bit nr %d o wartosci %b", $time, i, scancode[i]);
         end

         // Stop bit
         if(LOGLEVEL >= 7)
            $display("%t\t INFO7 [ %m ] \t Zakonczenie transmisji, stop bit 1", $time);

         set_data.high_during( QUARTER_PERIOD );

         set_clk.low_during( HALF_PERIOD );

         set_clk.high_during( QUARTER_PERIOD );
         // set_tx.high_during( HALF_PERIOD );

         // Zalogowanie konca transmisji
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Wyslano bajt %b (0x %h)", $time, scancode, scancode);

      end
   endtask

   // Pare klawiszy specjalnych

   reg [7:0] ESC         = 8'h76;
   reg [7:0] TAB         = 8'h0d;
   reg [7:0] BKSPC       = 8'h0d;
   reg [7:0] ENTER       = 8'h5a;
   reg [7:0] SPACE       = 8'h29;
   reg [7:0] LEFT_SHIFT  = 8'h12;
   reg [7:0] RIGHT_SHIFT = 8'h59;
   reg [7:0] LEFT_CTRL   = 8'h14;
   reg [7:0] LEFT_ALT    = 8'h11;

   reg [7:0] EXT         = 8'he0;
   reg [7:0] RELEASE     = 8'hf0;

   // Zadania ogolne do wcisniecia, puszczenia oraz przetrzymania zadanego klawisza

   task press_
   (
      input [7:0] scancode
   );
      begin
	 if(LOGLEVEL >= 4)
            $display("%t\t INFO4 [ %m ] \t Wciśnięto przycisk o skan kodzie %b (0x %h)", $time, scancode, scancode);

         send_(scancode);
      end
   endtask

   task release_
   (
      input [7:0] scancode
   );
      begin
	 if(LOGLEVEL >= 4)
            $display("%t\t INFO4 [ %m ] \t Zwalnianie przycisku o skan kodzie %b (0x %h)", $time, scancode, scancode);

         press_(RELEASE);
	 press_(scancode);
      end
   endtask

   task type_
   (
      input [7:0] scancode
   );
      begin
	 if(LOGLEVEL >= 4)
            $display("%t\t INFO4 [ %m ] \t Wpisywanie przycisku o skan kodzie %b (0x %h)", $time, scancode, scancode);

	 press_(scancode);
	 #(2 * HALF_PERIOD);
	 release_(scancode);
	 #(2 * HALF_PERIOD);
      end
   endtask

   // Klawisze lewego i prawego alt-a oraz ctrl-a sa rozroznialne

   task press_left_control
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wciśnięto lewy ctrl", $time);

	 press_(LEFT_CTRL);
      end
   endtask

   task release_left_control
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Zwalnanie lewego ctrl-a", $time);

	 release_(LEFT_CTRL);
      end
   endtask

   task press_right_control
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wciśnięto prawy ctrl", $time);

	 press_(EXT);
	 press_(LEFT_CTRL);
      end
   endtask

   task release_right_control
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Zwalnianie lewy ctrl-a", $time);

	 press_(EXT);
	 release_(LEFT_CTRL);
      end
   endtask

   task press_left_alt
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wciśnięto lewy alt", $time);

         press_(LEFT_ALT);
      end
   endtask

   task release_left_alt
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Zwalnianie lewy alt-a", $time);

         release_(LEFT_ALT);
      end
   endtask

   task press_right_alt
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wciśnięto prawy alt", $time);

         press_(EXT);
	 press_(LEFT_ALT);
      end
   endtask

   task release_right_alt
   ();
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Zwalnianie prawego alt-a", $time);

         press_(EXT);
	 release_(LEFT_ALT);
      end
   endtask

   // Mapowanie znaku do skan kodu
   reg [7:0] char_to_scancode [255:0];
   initial begin
       char_to_scancode["a"] = 8'h1c;
       char_to_scancode["b"] = 8'h32;
       char_to_scancode["c"] = 8'h21;
       char_to_scancode["d"] = 8'h23;
       char_to_scancode["e"] = 8'h24;
       char_to_scancode["f"] = 8'h2b;
       char_to_scancode["g"] = 8'h34;
       char_to_scancode["h"] = 8'h33;
       char_to_scancode["i"] = 8'h43;
       char_to_scancode["j"] = 8'h3b;
       char_to_scancode["k"] = 8'h42;
       char_to_scancode["l"] = 8'h4b;
       char_to_scancode["m"] = 8'h3a;
       char_to_scancode["n"] = 8'h31;
       char_to_scancode["o"] = 8'h44;
       char_to_scancode["p"] = 8'h4d;
       char_to_scancode["q"] = 8'h15;
       char_to_scancode["r"] = 8'h2d;
       char_to_scancode["s"] = 8'h1b;
       char_to_scancode["t"] = 8'h2c;
       char_to_scancode["u"] = 8'h3c;
       char_to_scancode["v"] = 8'h2a;
       char_to_scancode["w"] = 8'h1d;
       char_to_scancode["x"] = 8'h22;
       char_to_scancode["y"] = 8'h35;
       char_to_scancode["z"] = 8'h1a;

       char_to_scancode["0"] = 8'h45;
       char_to_scancode["1"] = 8'h16;
       char_to_scancode["2"] = 8'h1e;
       char_to_scancode["3"] = 8'h26;
       char_to_scancode["4"] = 8'h25;
       char_to_scancode["5"] = 8'h2e;
       char_to_scancode["6"] = 8'h36;
       char_to_scancode["7"] = 8'h3d;
       char_to_scancode["8"] = 8'h3e;
       char_to_scancode["9"] = 8'h46;

       char_to_scancode[" "] = 8'h29;
   end

   // Zadania operuja na znakach

   task press_char
   (
      input [7:0] char
   );
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wciśnięto klawisz o literze/cyfrze %b (0x %h) (dec %d) (ascii %s)", $time, char, char, char, char);

         press_(char_to_scancode[char]);
      end
   endtask

   task release_char
   (
      input [7:0] char
   );
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Zwalnianie klawisza o literze/cyfrze %b (0x %h) (dec %d) (ascii %s)", $time, char, char, char, char);

         release_(char_to_scancode[char]);
      end
   endtask

   task type_char
   (
      input [7:0] char
   );
      begin
	 if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wpisywanie klawisza o literze/cyfrze %b (0x %h) (dec %d) (ascii %s)", $time, char, char, char, char);

         type_(char_to_scancode[char]);
      end
   endtask

endmodule
