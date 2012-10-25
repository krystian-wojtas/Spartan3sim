`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:21 10/25/2012 
// Design Name: 
// Module Name:    Rs232-behav 
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
// 	informuje o wyslaniu/otrzymaniu pelnego bajtu
// LOGLEVEL = 4
// 	informuje o wysylaniu/otrzymywaniu poszczegolnych bitow
// LOGLEVEL = 5
// 	
// LOGLEVEL = 6 //TODO del
// 	debug
module Rs232_behav
#(
	parameter LOGLEVEL=3
	//TODO parameter bound rate
) (
	input rx,
	output reg tx = 1'b1
);


	task transmit( input [7:0] byte_tosend);
		integer i;
		begin
		//start bit
		tx = 1'b0;
		#17400;
		
		//byte
		for(i=0; i < 8; i=i+1) begin
			tx = byte_tosend[i];
			if(LOGLEVEL >= 4)		
				$display("%t\tINFO3 RS wyslano bit nr %d o wartosci %b", $time, i, tx);
			#17400;
		end
		
		//stop bit
		tx = 1'b1;
		#17400;
		
		if(LOGLEVEL >= 3)
			$display("%t\tINFO2 RS wyslano bajt %b 0x%h %d %s", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);
		end
	endtask
	 
	 
	task receive( output reg [7:0] byte_received );
		integer i;
		begin
		//start bit
		if(LOGLEVEL >= 5)
			$display("%t\tINFO5 RS start bit 0, rozpoczecie odbioru", $time);
		#17400; // przeczekanie start bitu
		#6700; // opoznienie aby probkowac w polowie taktu
		
		//byte
		for(i=0; i < 8; i=i+1) begin
			byte_received[i] = rx;
			if(LOGLEVEL >= 4)
				$display("%t\tINFO4 RS odebrano bit nr %d o wartosci %b", $time, i, rx);
			#17400;
		end
		
		//stop bit
		if(LOGLEVEL >= 5)
			$display("%t\tINFO5 RS stop bit %b, zakonczenie odbioru", $time, rx);
		if(~rx)
			if(LOGLEVEL >= 1)
				$display("%t\tERROR RS spodziwany odbior stop bitu (jedynki), jednak nastapilo zero", $time);
		#6700; // przeczekanie polowy stop bitu; nie czekam do konca bo przeocze zdarzenie negatywnego zbocza rx (start bit 0) co rozpoczynaloby odbior kolejnego pakietu
		end
	endtask
	

	localparam CHARS = 11;
	reg [7:0] mem [CHARS-1:0];  
	initial begin
		 mem[0] = "H";
		 mem[1] = "e";
		 mem[2] = "l";
		 mem[3] = "l";
		 mem[4] = "o";
		 mem[5] = " ";
		 mem[6] = "R";
		 mem[7] = "S";
		 mem[8] = "2";
		 mem[9] = "3";
		 mem[10]="2";
	end
	
		 
	integer j = 0;
	initial begin
		#1000;
		for(j=0; j<CHARS; j=j+1)
			transmit( mem[j] );
	end
	
	
	integer k = 0;
	reg [7:0] byte_received = 8'd0;
	always @(negedge rx) begin
		// odbior bajtu
		receive( byte_received );
		if(LOGLEVEL >= 3)		
			$display("%t\tINFO3 RS odebrano bajt %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received);
		// weryfikacja
		if( byte_received != mem[k] )
			if(LOGLEVEL >= 1)
				$display("%t\tERROR RS odebrany bajt %b 0x%h %d %s rozni sie od wyslanego wzorca %b 0x%h %d %s", $time, byte_received, byte_received, byte_received, byte_received, mem[k], mem[k], mem[k], mem[k]);
		k = k + 1;
	end


endmodule
