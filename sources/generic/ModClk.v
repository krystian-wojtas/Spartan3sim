`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:20 07/17/2012 
// Design Name: 
// Module Name:    ModClk 
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
module ModClk #(
	parameter DIV=2,
	parameter DELAY=0,
	parameter POSE=0 //trigging on posedge or negedge
	) (
	input CLK50MHZ,
	input RST,
	output mod_clk_hf, //half filled 50%
	output mod_clk_trig
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
	
	reg [log2(DIV-2):0] counter = 0;	
	reg [log2(DIV-2):0] next_counter;	
	always @(posedge CLK50MHZ)
		if(RST)
			counter <= 0;
		else
			counter <= next_counter;
	
	always @*
		if(counter < DIV-1)
			next_counter = counter + 1;
		else
			next_counter = 0;
			
	
	assign mod_clk_hf = (counter <= (DIV-1)/2);
	assign mod_clk_trig = POSE ? (counter == (DIV-1+DELAY)%DIV) : (counter == (DIV-1)/2+DELAY);
	
endmodule
