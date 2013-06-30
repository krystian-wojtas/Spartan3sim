`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:29 03/12/2012 
// Design Name: 
// Module Name:    Reset 
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
module Reset #(parameter DELAY = 40) (
    output reg RST
   );

    initial begin
        RST = 0;
        #10;
        RST = 1;
        #DELAY;
        RST = 0;
    end

endmodule
