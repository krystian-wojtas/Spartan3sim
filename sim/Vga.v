`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:05:00 08/20/2013 
// Design Name: 
// Module Name:    Vga 
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

module Vga (
    input [3:0] VGA_R,
    input [3:0] VGA_G,
    input [3:0] VGA_B,
    input 	 VGA_HSYNC,
    input 	 VGA_VSYNC
    );
	 
    integer i = 0;
	 integer x;
	 integer y;
    
	 always @*
	     if(VGA_VSYNC) begin
		      i = 0;
		  end
		  
	 always @(posedge VGA_HSYNC)
	     i = i + 1;
		  
	 always @* begin
	     x = i / 480;
	     y = i % 480;
		  $display("%t i %d x %d y %d", $time, i, x, y);
	 end
	 
	
endmodule
