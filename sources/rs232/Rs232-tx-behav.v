`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:51:49 10/23/2012 
// Design Name: 
// Module Name:    Rs232-tx-behav 
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
// 	
// LOGLEVEL = 6 //TODO del
// 	debug
module Rs232_tx_behav
#(
	parameter LOGLEVEL=3
	//TODO parameter bound rate
) (
	output reg tx = 1'b1
);

	reg [7:0] mem [4:0];  
	initial begin
		 mem[0] = 8'h81;
		 mem[1] = "e";
		 mem[2] = "l";
		 mem[3] = "l";
		 mem[4] = "o";
	end
		 
	integer j = 0;
	initial begin
		#1000;
		for(j=0; j<4; j=j+1)
			transmit( mem[j] );
	end


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
				$display("%t\tINFO3 RSTX wyslano bit nr %d o wartosci %b", $time, i, tx);
			#17400;
		end
		
		//stop bit
		tx = 1'b1;
		#17400;
		
		if(LOGLEVEL >= 3)
			$display("%t\tINFO2 RSTX wyslano bajt %b 0x%h %d %s", $time, byte_tosend, byte_tosend, byte_tosend, byte_tosend);
		end
	endtask

endmodule
