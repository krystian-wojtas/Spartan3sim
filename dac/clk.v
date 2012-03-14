`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:02 03/12/2012 
// Design Name: 
// Module Name:    clk 
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
module clk(output reg CLK50MHZ
    );

    initial CLK50MHZ = 0;
    always #10 CLK50MHZ <= ~CLK50MHZ;

endmodule
