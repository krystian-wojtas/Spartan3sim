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
   //
   // LOGLEVEL = 4
   //
   // LOGLEVEL = 5
   //
   // LOGLEVEL = 6
   //
   parameter LOGLEVEL=3
) (
   output  clk,
   output  data
);

   // czas polowy okresu
   localparam HALF_PERIOD = 40_000;
   // opoznienie
   localparam QUARTER_PERIOD = HALF_PERIOD / 2;

   Set #(
      // .LOGLEVEL(LOGLEVEL_TX),
      .N(1)
   ) set_clk (
      .signals( clk )
   );

   Set #(
      // .LOGLEVEL(LOGLEVEL_TX),
      .N(1)
   ) set_data (
      .signals( data )
   );

   // Stany jalowe sa wysokie
   initial begin
      set_clk.high();
      set_data.high();
   end

   // Zadanie wysyla przekazany bajt wraz z poprzedajacym bitem startu i nastepujacym stopu
   task send_scancode
   (
      input [7:0] scancode
   );
      integer     i;
      reg 	  odd;
      reg [8:0]   frame;
      begin

         // Zalogowanie poczatku transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wysylanie bajtu '%b' (0x %h) (dec %d) (ascii %s)", $time, scancode, scancode, scancode, scancode);

         // Start bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Rozpoczecie transmisji, start bit 0", $time);
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

            if(LOGLEVEL >= 4)
               $display("%t\t INFO4 [ %m ] \t Wyslano bit nr %d o wartosci %b", $time, i, scancode[i]);
         end

         set_data.high_during( QUARTER_PERIOD );

         set_clk.low_during( HALF_PERIOD );

         set_clk.high_during( QUARTER_PERIOD );

         // Stop bit
         if(LOGLEVEL >= 5)
            $display("%t\t INFO5 [ %m ] \t Zakonczenie transmisji, stop bit 1", $time);
         // set_tx.high_during( HALF_PERIOD );

         // Zalogowanie konca transmisji
         if(LOGLEVEL >= 3)
            $display("%t\t INFO3 [ %m ] \t Wyslano bajt %b (0x %h) (dec %d) (ascii %s)", $time, scancode, scancode, scancode, scancode);

      end
   endtask

   reg [7:0] char_to_scancode [127:0];
   // char_to_scancode["a"] = 8'h1c;
   // char_to_scancode["b"] = 8'h32;
   // char_to_scancode["c"] = 8'h21;
   // char_to_scancode["d"] = 8'h23;
   // char_to_scancode["e"] = 8'h24;
   // char_to_scancode["f"] = 8'h2b;
   // char_to_scancode["g"] = 8'h34;
   // char_to_scancode["h"] = 8'h33;
   // char_to_scancode["i"] = 8'h43;
   // char_to_scancode["j"] = 8'h3b;
   // char_to_scancode["k"] = 8'h42;
   // char_to_scancode["l"] = 8'h4b;
   // char_to_scancode["m"] = 8'h3a;
   // char_to_scancode["n"] = 8'h31;
   // char_to_scancode["o"] = 8'h44;
   // char_to_scancode["p"] = 8'h4d;
   // char_to_scancode["q"] = 8'h15;
   // char_to_scancode["r"] = 8'h2d;
   // char_to_scancode["s"] = 8'h1b;
   // char_to_scancode["t"] = 8'h2c;
   // char_to_scancode["u"] = 8'h3c;
   // char_to_scancode["v"] = 8'h2a;
   // char_to_scancode["w"] = 8'h1d;
   // char_to_scancode["x"] = 8'h22;
   // char_to_scancode["y"] = 8'h35;
   // char_to_scancode["z"] = 8'h1a;

   // char_to_scancode["0"] = 8'h45;
   // char_to_scancode["1"] = 8'h16;
   // char_to_scancode["2"] = 8'h1e;
   // char_to_scancode["3"] = 8'h26;
   // char_to_scancode["4"] = 8'h25;
   // char_to_scancode["5"] = 8'h2e;
   // char_to_scancode["6"] = 8'h36;
   // char_to_scancode["7"] = 8'h3d;
   // char_to_scancode["8"] = 8'h3e;
   // char_to_scancode["9"] = 8'h46;

   reg [7:0] ESC         = 8'h76;
   reg [7:0] TAB         = 8'h0d;
   reg [7:0] BKSPC       = 8'h0d;
   reg [7:0] ENTER       = 8'h5a;
   reg [7:0] SPACE       = 8'h29;
   reg [7:0] LEFT_SHIFT  = 8'h12;
   reg [7:0] RIGHT_SHIFT = 8'h59;
   reg [7:0] LEFT_CTRL  = 8'h14;
   reg [7:0] LEFT_ALT    = 8'h11;

   reg [7:0] EXT         = 8'he0;
   reg [7:0] RELEASE     = 8'hf0;

   task press
   (
      input [7:0] scancode
   );
      begin
         send_scancode(scancode);
      end
   endtask

   task release_
   (
      input [7:0] scancode
   );
      begin
         send_scancode(8'hf0);
	 send_scancode(scancode);
         // press(scancode);
      end
   endtask

   task type_
   (
      input [7:0] scancode
   );
      begin
	 press(scancode);
	 #1000;
	 release_(scancode);
	 #1000;
      end
   endtask

   task press_char
   (
      input [7:0] char
   );
      begin
         press(char_to_scancode[char]);
      end
   endtask

   task release_char
   (
      input [7:0] char
   );
      begin
         release_(char_to_scancode[char]);
      end
   endtask


   task press_left_control
   ();
      begin
	 press(LEFT_CTRL);
      end
   endtask

   task release_left_control
   ();
      begin
	 release_(LEFT_CTRL);
      end
   endtask

   task press_right_control
   ();
      begin
	 press(EXT);
	 press(LEFT_CTRL);
      end
   endtask

   task release_right_control
   ();
      begin
	 press(EXT);
	 release_(LEFT_CTRL);
      end
   endtask

   task press_left_alt
   ();
      begin
         press(LEFT_ALT);
      end
   endtask

   task release_left_alt
   ();
      begin
         release_(LEFT_ALT);
      end
   endtask

   task press_right_alt
   ();
      begin
         press(EXT);
	 press(LEFT_ALT);
      end
   endtask

   task release_right_alt
   ();
      begin
         press(EXT);
	 release_(LEFT_ALT);
      end
   endtask


endmodule
