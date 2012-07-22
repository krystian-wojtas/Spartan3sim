`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:53:18 03/25/2012 
// Design Name: 
// Module Name:    debouncer_debug 
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
module debouncer_debug(
	input CLK50MHZ,
	input RST,
	input less,
	input more,
	output [7:0] LED
    );
	 
	reg [7:0] debug;
	assign LED = debug;
	always @(posedge CLK50MHZ)
		if(RST) debug <= 8'b11000011;
		else begin
			if(less) debug <= 8'b10000000;
			if(more) debug <= 8'b00000001;
		end
		
	 
//
//	reg [7:0] debug;
//	assign LED = debug;
//	always @* begin
//		if(RST) debug = 8'd0;
//		else begin
//			if(BTN_WEST) debug[7] = 1'b1;
//	end
	 
	 
//	assign data = 12'h03f; //0.17
////	assign data = 12'h000; //max 3.29
//	
//	reg [7:0] debug = 8'b00110001;
//	always @(posedge CLK50MHZ) begin
//		if(RST) begin
//			dactrig <= 1'b0;
//			debug <= 8'b01010101;
//		end else begin
//			dactrig <= 1'b1;
//			debug <= 8'b11001100;
//		end
//	end
//	
//	assign LED = debug;

endmodule
