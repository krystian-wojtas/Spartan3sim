`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:17 10/24/2012 
// Design Name: 
// Module Name:    Rs232-rx-behav 
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
// 	informuje o wyslaniu pelnego bajtu
// LOGLEVEL = 4
// 	informuje o wysylaniu poszczegolnych bitow
// LOGLEVEL = 5
// 	informuje o start i stop bitach
// LOGLEVEL = 6 //TODO del
// 	debug
module Rs232_rx_behav
#(
	parameter LOGLEVEL=3
	//TODO parameter bound rate
) (
	input rx
);
	 
	 
	task receive( output reg [7:0] byte_received );
		integer i;
		begin
		//start bit
		if(LOGLEVEL >= 5)
			$display("%t\tINFO5 RSRX start bit 0, rozpoczecie odbioru", $time);
		#17400; // przeczekanie start bitu
		#6700; // opoznienie aby probkowac w polowie taktu
		
		//byte
		for(i=0; i < 8; i=i+1) begin
			byte_received[i] = rx;
			if(LOGLEVEL >= 4)
				$display("%t\tINFO4 RSRX odebrano bit nr %d o wartosci %b", $time, i, rx);
			#17400;
		end
		
		//stop bit
		if(LOGLEVEL >= 5)
			$display("%t\tINFO5 RSRX stop bit %b, zakonczenie odbioru", $time, rx);
		if(~rx)
			if(LOGLEVEL >= 1)
				$display("%t\tERROR RSRX spodziwany odbior stop bitu (jedynki), jednak nastapilo zero", $time);
		#6700; // przeczekanie polowy stop bitu; nie czekam do konca bo przeocze zdarzenie negatywnego zbocza rx (start bit 0) co rozpoczynaloby odbior kolejnego pakietu
		end
	endtask
	
	
	reg [7:0] byte_received = 8'd0;
	always @(negedge rx) begin
		receive( byte_received );
		if(LOGLEVEL >= 3)		
			$display("%t\tINFO3 RSRX odebrano bajt %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received);
	end
	 
endmodule
