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
	parameter DELAY=0
	) (
	input CLK50MHZ,
	input RST,
	output clk_hf, //half filled 50%
	output clk_pos_trig,
	output clk_neg_trig
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
			
	
	assign clk_hf = (counter <= (DIV-1)/2);
	assign clk_pos_trig = (counter == (DIV-1+DELAY)%DIV);
	assign clk_neg_trig = (counter == (DIV-1)/2+DELAY);
	
endmodule
