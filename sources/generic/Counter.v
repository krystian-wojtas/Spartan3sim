`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:51:49 07/22/2012 
// Design Name: 
// Module Name:    Counter 
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
module Counter #(
	parameter MAX=4,
	parameter K=1,
	parameter DELAY=0
) (
	input CLK50MHZ,
	// counter
	input cnt_en, // if high counter is enabled and is counting
	input rst, // set counter register to zero
	input sig, // signal which is counted
	output cnt_tick // one pulse if counter is full
);


	//constant function calculetes value at collaboration time
	//source http://www.beyond-circuits.com/wordpress/2008/11/constant-functions/
	function integer log2;
	  input integer value;
	  begin
		 value = value-1;
		 for (log2=0; value>0; log2=log2+1)
			value = value>>1;
	  end
	endfunction
	
	reg [log2(MAX)-1:0] counter_reg = 0;
	always @(posedge CLK50MHZ)
		if(rst)
			counter_reg <= 0;
		else if(cnt_en & sig)
			if(counter_reg < MAX)
				counter_reg <= counter_reg + K;
			else
				counter_reg <= DELAY;
		
	assign cnt_tick = (counter_reg == MAX-1);

endmodule
