`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:29 03/12/2012 
// Design Name: 
// Module Name:    rst 
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
module reset #(parameter DELAY = 40) (
    output reg RST
   );

    initial begin
        RST = 1;
        #10;
        RST = 0;
        #DELAY;
        RST = 1;
    end

endmodule