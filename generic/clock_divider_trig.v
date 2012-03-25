`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:51:23 03/17/2012 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider_trig #(parameter N = 10) (
	input CLK50MHZ,
	input RST,
	output reg clk_div_trig
    );
	
	//constant function calculetes value at collaboration time
	//source http://www.beyond-circuits.com/wordpress/2008/11/constant-functions/
	//TODO czy mozna zrobic modul z ta funkcja?
	function integer log2;
	  input integer value;
	  begin
		 value = value-1;
		 for (log2=0; value>0; log2=log2+1)
			value = value>>1;
	  end
	endfunction
	reg [log2(N):0] counter;

	always @(posedge CLK50MHZ) begin
		clk_div_trig = 1'b0;
		if(RST) counter = {log2(N){1'b0}};
		else begin
			counter = counter + 1;
			if(counter == N) begin
				clk_div_trig = 1'b1;
				counter = {log2(N){1'b0}};
			end
		end
	end			

endmodule

