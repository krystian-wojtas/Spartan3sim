`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:41 03/25/2012 
// Design Name: 
// Module Name:    debuncer 
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
module debouncer #(parameter N=4) ( //10000000
	input CLK50MHZ,
	input RST,
	input in,
	output reg out
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
		out <= 1'b0;
		if(RST) counter <= {log2(N){1'b0}};
		else begin
			if(in) begin
				counter <= counter + 1;
				if(counter == N) begin
					out <= 1'b1;
					counter <= {log2(N){1'b0}};
				end
			end else
				counter <= {log2(N){1'b0}};
		end
	end	

endmodule
