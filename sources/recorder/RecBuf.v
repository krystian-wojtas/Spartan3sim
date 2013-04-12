`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:04 04/11/2013 
// Design Name: 
// Module Name:    RecBuf 
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
module RecBuf #(
		parameter N = 1000
	) (
		input CLK50MHZ,
		input RST,
		// recording interface
		input signal,
		input recording,
		output rec_full,
		// reading interface
		input reading,
		output read_full,
		output current
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
	  
	  
	reg [N-1:0] buffer = {N{1'b0}};
	
	 
	reg [log2(N):0] i = 0;
	always @(posedge CLK50MHZ)
		if(RST) i <= 0;
		else if(i >= N-1) i <= 0;
		else if(~recording) i <= 0;
		else i <= i + 1;
	
	always @(posedge CLK50MHZ)
		if(RST) buffer <= {N{1'b0}};
		else if(recording) buffer[i] <= signal;
		
	assign rec_full = (i == N-1);
		
	 
	reg [log2(N):0] j = 0;
	always @(posedge CLK50MHZ)
		if(RST) j <= 0;
		else if(j >= N-1) j <= 0;
		else if(~reading) j <= 0;
		else j <= j + 1;

	assign read_full = (j == N-1);
	assign current = buffer[j];

endmodule
